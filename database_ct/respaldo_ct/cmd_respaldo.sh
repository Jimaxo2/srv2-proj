#!/bin/bash

set -Eeuo pipefail

# Variables de configuracion
CONTENEDOR="mysql_db"
BASE_DATOS="inventario_ct"
CARPETA="$HOME/srv-proj-test/database_ct/respaldo_ct"

# Fecha que toma en cuenta el sistema para el respaldo
FECHA=$(date +%Y-%m-%d)

# Archivos de respaldo
TEMP="$CARPETA/respaldo_$FECHA.sql.gz.tmp"
DESTINO="$CARPETA/respaldo_$FECHA.sql.gz"

# Crear carpeta si no existe
mkdir -p "$CARPETA"

# Registrar la ejecución
exec >> "$CARPETA/ejecuciones.log" 2>&1

echo "-----------------------------------"
echo "Iniciando respaldo: $(date)"

# Limpiar archivo temporal si ocurre un error
trap 'rm -f "$TEMP"' EXIT

# Generar respaldo y comprimirlo
if docker exec "$CONTENEDOR" sh -c \
'exec mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" --single-transaction --routines --triggers --events --databases "$1"' \
sh "$BASE_DATOS" | gzip > "$TEMP"; then

    # Comprobar que el archivo no esté vacío y sea válido
    if [ -s "$TEMP" ] && gzip -t "$TEMP"; then

        mv "$TEMP" "$DESTINO"

        echo "Respaldo generado correctamente: $DESTINO"

    else
        echo "ERROR: El respaldo está vacío o dañado."
        exit 1
    fi

else
    echo "ERROR: No se pudo generar el respaldo."
    exit 1
fi

# Eliminar respaldos con mas de 30 días
find "$CARPETA" -type f -name 'respaldo_*.sql.gz' -mtime +30 -delete

echo "Proceso finalizado: $(date)"
