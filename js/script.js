function agregarFila(event) {
    event.preventDefault(); // Evita el envío predeterminado del formulario

    const id = document.getElementById("id-inventario").value.trim();
    const componente = document.getElementById("componente").value.trim();
    const descripcion = document.getElementById("descripcion").value.trim();
    const cantidad = document.getElementById("cantidad").value.trim();
    const ubicacion = document.getElementById("ubicacion").value.trim();
    const precio = document.getElementById("precio").value.trim();

    // Validación básica
    if (!id || !componente || !descripcion || !cantidad || !ubicacion || !precio) {
        errorMsg.textContent = "Por favor, complete todos los campos.";
        return;
    }

    //errorMsg.textContent = ""; // Limpia mensajes de error

    // Añadir fila a la tabla
    const tabla = document.getElementById("Inventario").getElementsByTagName("tbody")[0];
    const nuevaFila = tabla.insertRow();

    const celdaId = nuevaFila.insertCell(0);
    const celdaComponente = nuevaFila.insertCell(1);
    const celdaDescripcion = nuevaFila.insertCell(2);
    const celdaCantidad = nuevaFila.insertCell(3);
    const celdaUbicacion = nuevaFila.insertCell(4);
    const celdaPrecio = nuevaFila.insertCell(5);

    celdaId.textContent = id;
    celdaComponente.textContent = componente;
    celdaDescripcion.textContent = descripcion;
    celdaCantidad.textContent = cantidad;
    celdaUbicacion.textContent = ubicacion;
    celdaPrecio.textContent = precio;

    // Limpiar formulario
    document.getElementById("for-Inventario").reset();

}

// Llena la tabla con los datos de MySQL
function fillTable() {

    // La ruta es relativa al mismo origen; Nginx la reenvía a Flask.
    return fetch("/inventario")
        .then(response => {
            if (!response.ok) {
                throw new Error("Error al consultar la API");
            }

            return response.json();
        })
        .then(data => {

            const tbody = document.querySelector("#Inventario tbody");

            tbody.innerHTML = "";

            data.forEach(componente => {

                const fila = document.createElement("tr");

                fila.innerHTML = `
                    <td>${componente.id_inventario}</td>
                    <td>${componente.nombre}</td>
                    <td>${componente.descripcion ?? ""}</td>
                    <td>${componente.cantidad}</td>
                    <td>${componente.ubicacion ?? ""}</td>
                    <td>${componente.precio ?? "0.00"}</td>
                `;

                tbody.appendChild(fila);

            });

        })
        .catch(error => {
            console.error("Error:", error);
        });

}

function validateUser(empleado) {

    fetch(`/empleado?empleado=${encodeURIComponent(empleado)}`)
        .then(response => {
            return response.json().then(data => ({
                ok: response.ok,
                data: data
            }));
        })
        .then(result => {

            if (result.ok) {
                sessionStorage.setItem("empleado", JSON.stringify(result.data));
                window.location.href = "/pedir";
            } else {
                alert(result.data.error);
            }

        })
        .catch(error => {
            console.error(error);
            alert("Error al conectar con el servidor");
        });
}

function cargarPeticiones() {

    fetch("/api/peticiones")
        .then(response => {
            if (!response.ok) {
                throw new Error("Error al consultar las peticiones");
            }

            return response.json();
        })
        .then(data => {

            const contenedor = document.getElementById("lista-peticiones");

            contenedor.innerHTML = "";

            if (data.length === 0) {
                contenedor.textContent = "No hay peticiones registradas.";
                return;
            }

            data.forEach(peticion => {

                const tarjeta = document.createElement("section");

                const titulo = document.createElement("h3");
                titulo.textContent = `Pedido #${peticion.id_pedido}`;

                const empleado = document.createElement("p");
                empleado.textContent = `Empleado: ${peticion.empleado}`;

                const fecha = document.createElement("p");
                fecha.textContent = `Fecha: ${peticion.fecha_hora}`;

                const estado = document.createElement("p");
                estado.textContent = `Estado: ${peticion.estado}`;

                const lista = document.createElement("ul");

                peticion.componentes.forEach(componente => {
                    const elemento = document.createElement("li");

                    elemento.textContent =
                        `${componente.nombre} - Cantidad: ${componente.cantidad}`;

                    lista.appendChild(elemento);
                });

                const comentarios = document.createElement("p");
                comentarios.textContent =
                    `Comentarios: ${peticion.comentarios || "Ninguno"}`;

                tarjeta.appendChild(titulo);
                tarjeta.appendChild(empleado);
                tarjeta.appendChild(fecha);
                tarjeta.appendChild(estado);
                tarjeta.appendChild(lista);
                tarjeta.appendChild(comentarios);

                contenedor.appendChild(tarjeta);

            });

        })
        .catch(error => {
            console.error("Error al cargar peticiones:", error);
        });
}

// ===== Modal de resultado NFC =====

let ultimoIdNfc = null;

function agregarTexto(contenedor, texto) {
    const p = document.createElement("p");
    p.textContent = texto;
    contenedor.appendChild(p);
}

function mostrarModalNfc(evento) {
    const caja = document.getElementById("modal-nfc-caja");
    const titulo = document.getElementById("modal-nfc-titulo");
    const cuerpo = document.getElementById("modal-nfc-cuerpo");

    cuerpo.innerHTML = "";

    if (evento.tipo === "retiro_exitoso") {
        caja.className = "modal-caja exito";
        titulo.textContent = "¡Retiro realizado!";

        agregarTexto(cuerpo, `Empleado: ${evento.empleado}`);
        agregarTexto(cuerpo, `Pedidos retirados: ${evento.pedidos_retirados}`);
        agregarTexto(cuerpo, "Componentes retirados:");

        const lista = document.createElement("ul");
        evento.componentes.forEach(componente => {
            const elemento = document.createElement("li");
            elemento.textContent = `${componente.cantidad} × ${componente.nombre}`;
            lista.appendChild(elemento);
        });
        cuerpo.appendChild(lista);

    } else if (evento.tipo === "nfc_no_registrado") {
        caja.className = "modal-caja error";
        titulo.textContent = "NFC no registrado";
        agregarTexto(cuerpo, `El identificador ${evento.nfc_id} no existe en el sistema.`);

    } else if (evento.tipo === "sin_pedidos") {
        caja.className = "modal-caja aviso";
        titulo.textContent = "No hay pedidos asociados al retiro.";
        agregarTexto(cuerpo, "El empleado fue identificado, pero no tiene pedidos pendientes.");
        agregarTexto(cuerpo, `Empleado: ${evento.empleado}`);

    } else if (evento.tipo === "sin_existencias") {
        caja.className = "modal-caja error";
        titulo.textContent = "No hay existencias suficientes";

        agregarTexto(cuerpo, `Empleado: ${evento.empleado}`);
        agregarTexto(cuerpo, "El retiro no se realizó. Faltan:");

        const lista = document.createElement("ul");
        evento.faltantes.forEach(faltante => {
            const elemento = document.createElement("li");
            elemento.textContent = `${faltante.faltan} × ${faltante.nombre}`;
            lista.appendChild(elemento);
        });
        cuerpo.appendChild(lista);
    } else {
        caja.className = "modal-caja error";
        titulo.textContent = "No fue posible procesar el retiro";
        agregarTexto(cuerpo, "Ocurrió un error en el servidor. Intenta de nuevo o avisa al administrador.");
    }

    document.getElementById("modal-nfc").classList.add("abierto");
}

function cerrarModalNfc() {
    document.getElementById("modal-nfc").classList.remove("abierto");
}

function consultarEventosNfc() {
    const parametro = ultimoIdNfc === null ? "" : `?desde=${ultimoIdNfc}`;

    fetch(`/api/nfc-eventos${parametro}`)
        .then(response => {
            if (!response.ok) {
                throw new Error("Error al consultar eventos NFC");
            }
            return response.json();
        })
        .then(data => {
            ultimoIdNfc = data.ultimo_id;

            if (data.eventos.length > 0) {
                // Si llegaron varios a la vez, se muestra el más reciente
                mostrarModalNfc(data.eventos[data.eventos.length - 1]);
                cargarPeticiones();   // el pedido retirado desaparece del panel al instante
                fillTable();          // el inventario se actualiza con las nuevas cantidades
            }
        })
        .catch(error => {
            console.error("Error al consultar NFC:", error);
        });
}

// Cerrar el modal con la tecla Escape
document.addEventListener("keydown", event => {
    if (event.key === "Escape") {
        cerrarModalNfc();
    }
});