import os
import sys
import time
import threading
from collections import deque
from flask import Flask, jsonify, request, render_template
import subprocess

import mysql.connector

app = Flask(__name__)

# ---------- Cola sencilla de resultados NFC (en memoria) ----------
eventos_nfc = deque(maxlen=20)           # guarda solo los últimos 20
candado_nfc = threading.Lock()
ultimo_id_evento = int(time.time() * 1000)   # basado en la hora, así nunca se repite al reiniciar Flask

DB_HOST = "mysql"
DB_PORT = 3306  # Usa el puerto real de tu servidor
DB_USER = "root"
DB_PASSWORD = "1234"
DB_NAME = "inventario_ct"

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

BACKUP_PATH = os.path.join(
    BASE_DIR,
    "database_ct",
    "respaldo_ct.sql"
)


# ---------- CONEXION AL SERVIDOR ----------

def conectar_servidor():
    return mysql.connector.connect(
        host=DB_HOST,
        port=DB_PORT,
        user=DB_USER,
        password=DB_PASSWORD
    )


# ---------- CONEXION A LA BASE DE DATOS ----------

def connect():
    return mysql.connector.connect(
        host=DB_HOST,
        port=DB_PORT,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME
    )


# ---------- INICIALIZACION DE LA BASE DE DATOS ----------

def inicializar_base_datos():

    if not os.path.isfile(BACKUP_PATH):
        print(f"[ERROR] No existe el respaldo: {BACKUP_PATH}")
        return False

    conexion = None
    creada = False

    try:
        conexion = conectar_servidor()
        cursor = conexion.cursor()

        cursor.execute(
            "SHOW DATABASES LIKE %s",
            (DB_NAME,)
        )

        existe = cursor.fetchone()

        if existe:
            print(f"[INFO] La base de datos '{DB_NAME}' ya existe.")
            return True

        print(f"[INFO] Creando base de datos '{DB_NAME}'...")

        cursor.execute(
            f"CREATE DATABASE `{DB_NAME}` "
            "CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
        )

        creada = True

        cursor.close()
        conexion.close()
        conexion = None

        print("[INFO] Restaurando respaldo...")

        # Configuracion del cliente MySQL
        entorno = os.environ.copy()
        entorno["MYSQL_PWD"] = DB_PASSWORD

        comando = [
            "mysql",
            f"--host={DB_HOST}",
            f"--port={DB_PORT}",
            f"--user={DB_USER}",
            DB_NAME
        ]

        with open(BACKUP_PATH, "rb") as archivo:
            resultado = subprocess.run(
                comando,
                stdin=archivo,
                capture_output=True,
                env=entorno
            )

        if resultado.returncode != 0:
            raise RuntimeError(
                resultado.stderr.decode(errors="replace")
            )

        print("[INFO] Validando tablas...")

        conexion = connect()
        cursor = conexion.cursor()

        cursor.execute("SHOW TABLES")
        tablas = {fila[0] for fila in cursor.fetchall()}

        tablas_requeridas = {
            "componentes",
            "empleados",
            "historial_pedidos",
            "inventario",
            "pedidos"
        }

        faltantes = tablas_requeridas - tablas

        if faltantes:
            raise RuntimeError(
                f"Faltan tablas: {faltantes}"
            )

        print("[SUCCESS] Base de datos restaurada y validada.")

        return True

    except Exception as error:

        print(f"[ERROR] Inicializacion MySQL: {error}")

        # Eliminar solamente la base recién creada
        # si la restauración o validación falla.
        if creada:
            try:
                if conexion is None or not conexion.is_connected():
                    conexion = conectar_servidor()

                cursor = conexion.cursor()
                cursor.execute(
                    f"DROP DATABASE IF EXISTS `{DB_NAME}`"
                )
                cursor.close()

                print("[INFO] Se elimino la base incompleta.")

            except Exception as error_limpieza:
                print(f"[ERROR] Limpieza: {error_limpieza}")

        return False

    finally:
        if conexion is not None and conexion.is_connected():
            conexion.close()

def registrar_evento_nfc(tipo, **datos):
    global ultimo_id_evento
    with candado_nfc:
        ultimo_id_evento += 1
        eventos_nfc.append({"id": ultimo_id_evento, "tipo": tipo, **datos})

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/login")
def login():
    return render_template("login.html")

@app.route("/inventario", methods=['GET'])
def getComponents():
    conexion = connect()
    cursor = conexion.cursor(dictionary=True)

    try:
        cursor.execute("""SELECT
    c.id_componente,
    c.nombre,
    i.id_inventario,
    i.cantidad,
    i.ubicacion,
    i.precio
    FROM componentes c
    INNER JOIN inventario i
        ON c.id_componente = i.id_componente
    ORDER BY c.nombre ASC""")

        data = cursor.fetchall()

        return jsonify(data), 200

    except mysql.connector.Error as error:
        return jsonify({
            "error": str(error)
        }), 500

    finally:
        cursor.close()
        conexion.close()

@app.route("/empleado", methods=["GET"])
def validateUser():

    empleado = request.args.get("empleado")

    if not empleado:
        return jsonify({"error": "No se recibió un empleado"}), 400

    connection = connect()
    cursor = connection.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT id_empleado, nombre
            FROM empleados
            WHERE nombre = %s
        """, (empleado,))

        data = cursor.fetchone()

        if data:
            return jsonify(data), 200

        return jsonify({"error": "El empleado no existe"}), 404

    except mysql.connector.Error as error:
        return jsonify({"error": str(error)}), 500

    finally:
        cursor.close()
        connection.close()

@app.route('/pedir')
def pedir():
    return render_template("cliente.html")

@app.route("/api/solicitudes", methods=["POST"])
def crearSolicitud():
    datos = request.get_json(silent=True)

    # Validar que se haya recibido información
    if not datos:
        return jsonify({"error": "No se recibieron datos"}), 400

    empleado = datos.get("empleado")
    componentes = datos.get("componentes", [])
    comentarios = datos.get("comentarios", "")

    # Validar empleado
    if not isinstance(empleado, dict) or not empleado.get("id_empleado"):
        return jsonify({"error": "No se recibió un empleado válido"}), 400

    # Validar componentes
    if not isinstance(componentes, list) or len(componentes) == 0:
        return jsonify({"error": "La solicitud no contiene componentes"}), 400

    try:
        id_empleado = int(empleado["id_empleado"])

        # Validar cantidades e identificadores
        ids_inventario = set()

        for item in componentes:
            id_inventario = int(item["id_inventario"])
            cantidad = int(item["cantidad"])

            if id_inventario <= 0 or cantidad <= 0:
                return jsonify({
                    "error": "Los componentes y cantidades deben ser válidos"
                }), 400

            if id_inventario in ids_inventario:
                return jsonify({
                    "error": "Hay componentes repetidos en la solicitud"
                }), 400

            ids_inventario.add(id_inventario)

    except (ValueError, TypeError, KeyError):
        return jsonify({"error": "Los datos de los componentes no son válidos"}), 400

    conexion = None
    cursor = None

    try:
        conexion = connect()
        cursor = conexion.cursor(dictionary=True)

        # Comprobar que el empleado exista
        cursor.execute("""
            SELECT id_empleado
            FROM empleados
            WHERE id_empleado = %s
        """, (id_empleado,))

        if not cursor.fetchone():
            return jsonify({"error": "El empleado no existe"}), 404

        # Comprobar que los componentes existan y tengan existencias
        for item in componentes:
            id_inventario = int(item["id_inventario"])
            cantidad = int(item["cantidad"])

            cursor.execute("""
                SELECT id_componente, cantidad
                FROM inventario
                WHERE id_inventario = %s
            """, (id_inventario,))

            inventario = cursor.fetchone()

            if not inventario:
                return jsonify({
                    "error": f"No existe el elemento de inventario {id_inventario}"
                }), 404

            if cantidad > inventario["cantidad"]:
                return jsonify({
                    "error": f"No hay suficientes existencias para el inventario {id_inventario}"
                }), 400

        # Crear el pedido
        cursor.execute("""
            INSERT INTO pedidos (id_empleado, comentarios)
            VALUES (%s, %s)
        """, (id_empleado, comentarios))

        id_pedido = cursor.lastrowid

        # Guardar cada componente solicitado
        for item in componentes:
            id_inventario = int(item["id_inventario"])
            cantidad = int(item["cantidad"])

            cursor.execute("""
                SELECT id_componente
                FROM inventario
                WHERE id_inventario = %s
            """, (id_inventario,))

            inventario = cursor.fetchone()
            id_componente = inventario["id_componente"]

            cursor.execute("""
                INSERT INTO historial_pedidos
                    (id_componente, id_empleado, cantidad, recibido, id_pedido)
                VALUES (%s, %s, %s, %s, %s)
            """, (
                id_componente,
                id_empleado,
                cantidad,
                0,
                id_pedido
            ))

        # Guardar todos los cambios
        conexion.commit()

        return jsonify({
            "mensaje": "Solicitud enviada correctamente",
            "id_pedido": id_pedido
        }), 201

    except Exception as error:
        if conexion:
            conexion.rollback()

        print("ERROR AL GUARDAR SOLICITUD:", repr(error))

        return jsonify({
            "error": "Error al guardar la solicitud",
            "detalle": str(error)
        }), 500

    finally:
        if cursor:
            cursor.close()

        if conexion:
            conexion.close()

@app.route("/api/peticiones", methods=["GET"])
def obtenerPeticiones():
    conexion = connect()
    cursor = conexion.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT
                p.id_pedido,
                e.nombre AS empleado,
                p.fecha_hora,
                p.estado,
                p.comentarios,
                c.nombre AS componente,
                h.cantidad
            FROM pedidos p
            INNER JOIN empleados e
                ON p.id_empleado = e.id_empleado
            INNER JOIN historial_pedidos h
                ON p.id_pedido = h.id_pedido
            INNER JOIN componentes c
                ON h.id_componente = c.id_componente
            WHERE p.estado = 'pendiente'
            ORDER BY p.fecha_hora ASC, p.id_pedido ASC
        """)

        filas = cursor.fetchall()
        peticiones = {}

        for fila in filas:
            id_pedido = fila["id_pedido"]

            if id_pedido not in peticiones:
                peticiones[id_pedido] = {
                    "id_pedido": id_pedido,
                    "empleado": fila["empleado"],
                    "fecha_hora": fila["fecha_hora"].strftime("%d/%m/%Y %H:%M"),
                    "estado": fila["estado"],
                    "comentarios": fila["comentarios"] or "",
                    "componentes": []
                }

            if fila["componente"]:
                peticiones[id_pedido]["componentes"].append({
                    "nombre": fila["componente"],
                    "cantidad": fila["cantidad"]
                })

        return jsonify(list(peticiones.values())), 200

    except mysql.connector.Error as error:
        return jsonify({"error": str(error)}), 500

    finally:
        cursor.close()
        conexion.close()

@app.route("/api/nfc-eventos", methods=["GET"])
def obtener_eventos_nfc():
    desde = request.args.get("desde", type=int)

    with candado_nfc:
        ultimo = ultimo_id_evento

        # Primera consulta de una página: no mostrar eventos viejos
        if desde is None:
            return jsonify({"ultimo_id": ultimo, "eventos": []}), 200

        nuevos = [e for e in eventos_nfc if e["id"] > desde]

    return jsonify({"ultimo_id": ultimo, "eventos": nuevos}), 200

@app.route('/api/retiro-nfc', methods=['POST'])
def retiro_nfc():
    data = request.get_json(silent=True) or {}
    nfc_id = str(data.get("nfc_id", "")).strip().upper()

    if not nfc_id:
        return jsonify({"error": "No se recibió un NFC ID"}), 400

    conexion = None
    cursor = None

    try:
        conexion = connect()
        cursor = conexion.cursor(dictionary=True)

        # Buscar al empleado por su NFC ID
        cursor.execute("""
            SELECT id_empleado, nombre
            FROM empleados
            WHERE UPPER(nfc_id) = %s
        """, (nfc_id,))

        empleado = cursor.fetchone()

        if not empleado:
            registrar_evento_nfc("nfc_no_registrado", nfc_id=nfc_id)
            return jsonify({"error": "NFC no registrado"}), 404

        # Buscar y bloquear todos sus pedidos pendientes
        cursor.execute("""
            SELECT id_pedido
            FROM pedidos
            WHERE id_empleado = %s
              AND estado = 'pendiente'
            FOR UPDATE
        """, (empleado["id_empleado"],))

        pedidos = cursor.fetchall()

        if not pedidos:
            registrar_evento_nfc(
                "sin_pedidos",
                nfc_id=nfc_id,
                empleado=empleado["nombre"]
            )
            return jsonify({
                "error": "El empleado no tiene pedidos pendientes",
                "empleado": empleado["nombre"]
            }), 404

        ids_pedidos = [p["id_pedido"] for p in pedidos]
        placeholders = ",".join(["%s"] * len(ids_pedidos))

        # Componentes que se van a retirar (sumados por componente)
        cursor.execute(f"""
            SELECT c.id_componente, c.nombre, SUM(h.cantidad) AS cantidad
            FROM historial_pedidos h
            INNER JOIN componentes c
                ON h.id_componente = c.id_componente
            WHERE h.id_pedido IN ({placeholders})
            GROUP BY c.id_componente, c.nombre
            ORDER BY c.nombre
        """, tuple(ids_pedidos))

        componentes = [
            {
                "id_componente": fila["id_componente"],
                "nombre": fila["nombre"],
                "cantidad": int(fila["cantidad"])
            }
            for fila in cursor.fetchall()
        ]

        # Descontar del inventario (si falta algo, no se retira nada)
        faltantes = []

        for componente in componentes:
            restante = componente["cantidad"]

            cursor.execute("""
                SELECT id_inventario, cantidad
                FROM inventario
                WHERE id_componente = %s
                  AND cantidad > 0
                ORDER BY id_inventario
                FOR UPDATE
            """, (componente["id_componente"],))

            for fila in cursor.fetchall():
                if restante <= 0:
                    break

                a_descontar = min(restante, fila["cantidad"])

                cursor.execute("""
                    UPDATE inventario
                    SET cantidad = cantidad - %s
                    WHERE id_inventario = %s
                """, (a_descontar, fila["id_inventario"]))

                restante -= a_descontar

            if restante > 0:
                faltantes.append({
                    "nombre": componente["nombre"],
                    "faltan": restante
                })

        if faltantes:
            conexion.rollback()

            registrar_evento_nfc(
                "sin_existencias",
                nfc_id=nfc_id,
                empleado=empleado["nombre"],
                faltantes=faltantes
            )

            return jsonify({
                "error": "No hay existencias suficientes",
                "empleado": empleado["nombre"],
                "faltantes": faltantes
            }), 409

        # Cambiar todos los pedidos a retirado
        cursor.execute(f"""
            UPDATE pedidos
            SET estado = 'retirado'
            WHERE id_pedido IN ({placeholders})
        """, tuple(ids_pedidos))

        # Marcar todos sus componentes como recibidos
        cursor.execute(f"""
            UPDATE historial_pedidos
            SET recibido = 1
            WHERE id_pedido IN ({placeholders})
        """, tuple(ids_pedidos))

        conexion.commit()

        # Registrar el evento DESPUÉS del commit
        registrar_evento_nfc(
            "retiro_exitoso",
            nfc_id=nfc_id,
            empleado=empleado["nombre"],
            pedidos_retirados=len(ids_pedidos),
            componentes=componentes
        )

        return jsonify({
            "mensaje": "Retiro realizado correctamente",
            "empleado": empleado["nombre"],
            "pedidos_retirados": len(ids_pedidos),
            "ids_pedidos": ids_pedidos,
            "componentes": componentes
        }), 200

    except Exception as error:
        if conexion:
            conexion.rollback()

        print("ERROR EN RETIRO NFC:", repr(error))
        registrar_evento_nfc("error", nfc_id=nfc_id)

        return jsonify({"error": str(error)}), 500

    finally:
        if cursor:
            cursor.close()

        if conexion:
            conexion.close()

if not inicializar_base_datos():
    sys.exit(1)

if __name__ == "__main__":
    if not inicializar_base_datos():
        sys.exit(1)

    app.run(host='0.0.0.0', debug=True)

