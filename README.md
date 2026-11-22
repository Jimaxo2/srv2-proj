# SRV2-PROJ

## Descripción

Este proyecto implementa un sistema que utiliza tecnología NFC para la identificación de usuarios. Para su correcto funcionamiento, requiere un entorno basado en Docker, una base de datos MySQL y un dispositivo NFC conectado mediante USB.

Este documento describe los pasos necesarios para preparar el entorno, desplegar los contenedores y poner en funcionamiento el sistema.

## Requisitos del sistema

Antes de comenzar, es necesario contar con un servidor que cumpla con las siguientes especificaciones:

### Hardware

| Recurso | Requisito |
|---|---|
| Almacenamiento | 20 GB |
| Memoria RAM | 4 GB |
| Puerto USB | `/dev/ttyUSB0` |

### Software y versiones

| Componente | Versión |
|---|---|
| Sistema operativo | Ubuntu Server 24.04 LTS |
| Docker | 29.10.0, build fdd4b8e |
| Python | 3.12.0 |
| MySQL | 8.0 |
| Nginx | PLS.37 TLS |

**Importante:** Se recomienda utilizar las versiones indicadas para mantener la compatibilidad del entorno y evitar problemas durante el despliegue.

## Instalación y configuración

### 1. Clonar el repositorio

Clonar el repositorio dentro del directorio donde se desea desplegar el proyecto:

```bash
git clone https://github.com/Jimaxo2/srv2-proj.git
```

Ingresar al directorio del proyecto:

```bash
cd srv2-proj
```

### 2. Preparar el entorno

Verificar que el servidor cuente con las versiones de software indicadas en la sección de requisitos.

También es necesario comprobar que Docker y Docker Compose estén instalados y funcionando correctamente.

Para verificar la instalación de Docker:

```bash
docker --version
```

Comprobar que Docker Compose esté disponible:

```bash
docker compose version
```

### 3. Conectar el dispositivo NFC

Conectar el dispositivo NFC mediante USB al servidor.

**IMPORTANTE:** El dispositivo debe estar conectado y reconocido específicamente en la siguiente ruta:

```bash
/dev/ttyUSB0
```

Para comprobar que el dispositivo se encuentra disponible, ejecutar:

```bash
ls -l /dev/ttyUSB0
```

Si el dispositivo no aparece en esta ubicación, es necesario revisar la conexión USB y verificar que el sistema operativo lo haya reconocido correctamente.

La conexión del dispositivo en esta ruta es indispensable para el funcionamiento correcto del sistema.

### 4. Construir y ejecutar los contenedores

Desde el directorio raíz del proyecto, ejecutar el siguiente comando:

```bash
docker compose up -d --build
```

Este comando realiza las siguientes operaciones:

- Construye las imágenes necesarias para el proyecto.
- Descarga las imágenes base que no se encuentren disponibles localmente.
- Crea los contenedores definidos en el archivo `docker-compose.yml`.
- Inicia los servicios en segundo plano.

Para comprobar que los contenedores estén funcionando correctamente:

```bash
docker compose ps
```

En caso de necesitar revisar los registros de ejecución de los servicios:

```bash
docker compose logs
```

### 5. Acceder a la aplicación web

Una vez que los contenedores se encuentren ejecutándose correctamente, abrir un navegador web desde un equipo conectado a la misma red que el servidor.

Ingresar la siguiente dirección:

```text
http://<IP-SERVIDOR>
```

La aplicación realizará automáticamente una redirección hacia la página de inicio de sesión:

```text
http://<IP-SERVIDOR>/login.html
```

Sustituir `<IP-SERVIDOR>` por la dirección IP correspondiente al servidor donde se encuentra desplegado el proyecto.

### 6. Registrar un usuario en la base de datos

**IMPORTANTE:** Antes de realizar el primer inicio de sesión, es necesario registrar al menos un usuario directamente en la base de datos MySQL.

El registro debe incluir los datos del usuario y su correspondiente identificador NFC (`nfcid`).

El campo `nfcid` es obligatorio para el funcionamiento del sistema.

Se debe verificar que:

- El usuario esté correctamente registrado en la base de datos.
- El identificador `nfcid` esté asociado al usuario.
- El valor de `nfcid` corresponda al identificador de la tarjeta o dispositivo NFC que utilizará el usuario.

Una vez realizado el registro, se podrá acceder a la aplicación mediante la interfaz de inicio de sesión.

### 7. Verificar el funcionamiento

Después de completar los pasos anteriores:

1. Comprobar que todos los contenedores estén activos.
2. Verificar que la conexión con MySQL funcione correctamente.
3. Confirmar que el dispositivo NFC esté conectado en `/dev/ttyUSB0`.
4. Acceder a la aplicación web.
5. Iniciar sesión utilizando un usuario previamente registrado y asociado a un `nfcid`.

Si todos los pasos se han completado correctamente, el sistema estará listo para funcionar.

## Comandos útiles

A continuación, se presentan algunos comandos que pueden resultar útiles para administrar el proyecto.

| Acción | Comando |
|---|---|
| Iniciar y construir servicios | `docker compose up -d --build` |
| Consultar estado de contenedores | `docker compose ps` |
| Consultar registros | `docker compose logs` |
| Seguir registros en tiempo real | `docker compose logs -f` |
| Detener servicios | `docker compose stop` |
| Detener y eliminar contenedores | `docker compose down` |
| Reiniciar servicios | `docker compose restart` |

## Consideraciones importantes

- Mantener conectado el dispositivo NFC durante la ejecución del sistema.
- No modificar la ruta `/dev/ttyUSB0` sin actualizar también la configuración correspondiente del proyecto.
- Registrar previamente los usuarios en MySQL antes de intentar iniciar sesión.
- El campo `nfcid` es obligatorio para cada usuario.
- Verificar que los contenedores estén activos antes de acceder a la aplicación web.
- Se recomienda no modificar las versiones de las dependencias y servicios especificados sin comprobar previamente su compatibilidad.

## Resultado esperado

Al completar correctamente el procedimiento de instalación y configuración, se contará con el sistema desplegado mediante Docker Compose, con acceso a la interfaz web, conexión a la base de datos MySQL y comunicación con el dispositivo NFC.

**El sistema estará listo para utilizarse.**