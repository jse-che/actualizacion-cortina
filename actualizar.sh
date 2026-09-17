#!/bin/bash

# URL directa (RAW) de tu archivo mh-c521.json en el repositorio
URL_JSON="http://raw.githubusercontent.com/jse-che/actualizacion-cortina/refs/heads/main/mh-c521.json"

# Ruta de destino final
DESTINO="/home/cat/zwave-js-ui-store/.config-db/devices/0x015f/mh-c521.json"

echo "Descargando mh-c521.json desde el repositorio..."
if curl -sSL "$URL_JSON" -o "$DESTINO"; then
    echo "¡Archivo reemplazado con éxito en $DESTINO!"
else
    echo "Error: No se pudo descargar el archivo desde el repositorio." >&2
    exit 1
fi