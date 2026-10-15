#!/bin/bash

set -e

# URL directa del archivo JSON en GitHub
URL_JSON="https://raw.githubusercontent.com/jse-che/actualizacion-cortina/main/mh-c521.json"

# Archivo de destino Z-Wave JS UI
DESTINO="/home/cat/zwave-js-ui-store/.config-db/devices/0x015f/mh-c521.json"

# Archivo de configuración de Home Assistant
CONFIG="/home/cat/config/configuration.yaml"

echo "=========================================="
echo " Actualización de cortina y configuración Alexa"
echo "=========================================="

# 1. Descargar y reemplazar mh-c521.json
echo ""
echo "Descargando mh-c521.json desde GitHub..."

if curl -fsSL "$URL_JSON" -o "${DESTINO}.tmp"; then
    if python -m json.tool "${DESTINO}.tmp" >/dev/null 2>&1; then
        cp -p "$DESTINO" "${DESTINO}.bak" 2>/dev/null || true
        mv "${DESTINO}.tmp" "$DESTINO"
        echo "Archivo JSON actualizado correctamente."
    else
        rm -f "${DESTINO}.tmp"
        echo "ERROR: El archivo descargado no es un JSON válido." >&2
        exit 1
    fi
else
    rm -f "${DESTINO}.tmp"
    echo "ERROR: No se pudo descargar el archivo JSON." >&2
    exit 1
fi

# 2. Comprobar que existe configuration.yaml
echo ""
echo "Revisando configuration.yaml..."

if [ ! -f "$CONFIG" ]; then
    echo "ERROR: No existe el archivo $CONFIG" >&2
    exit 1
fi

# 3. Agregar Alexa solo si no existe ya el bloque
if grep -Eq '^[[:space:]]*alexa:[[:space:]]*(#.*)?$' "$CONFIG"; then
    echo "Ya existe una sección 'alexa:' en configuration.yaml."
    echo "No se modifica automáticamente para evitar duplicados."
    echo "Revisa si ya tiene la configuración smart_home requerida."
else
    cp -p "$CONFIG" "${CONFIG}.bak"

    cat >> "$CONFIG" <<'YAML'

# Configuración Alexa Smart Home
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

    echo "Configuración Alexa agregada correctamente."
    echo "Copia de seguridad: ${CONFIG}.bak"
fi

echo ""
echo "Proceso finalizado."
