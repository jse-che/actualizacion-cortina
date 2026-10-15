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

# Agregar configuración de Alexa Smart Home
CONFIG="/home/cat/config/configuration.yaml"

echo "Revisando configuración de Alexa..."

if [ ! -f "$CONFIG" ]; then
    echo "Error: No se encontró $CONFIG" >&2
    exit 1
fi

if grep -Eq '^alexa:[[:space:]]*(#.*)?$' "$CONFIG"; then
    echo "La sección alexa: ya existe. No se realizaron cambios."
else
    cp -p "$CONFIG" "${CONFIG}.bak"

    cat >> "$CONFIG" <<'YAML'

alexa:
  smart_home:
    filter:
      include_domains:
        - light
        - switch
        - climate
        - cover
        - media_player
        - fan
        - scene
        - script
YAML

    echo "Configuración de Alexa agregada correctamente."
    echo "Copia de seguridad creada en ${CONFIG}.bak"
fi

echo "Proceso finalizado."
