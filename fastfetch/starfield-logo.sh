#!/usr/bin/env bash
# Selecciona aleatoriamente una de las 3 imágenes pixel art de Starfield para Fastfetch
LOGO_DIR="${HOME}/.config/hyde/themes/Starfield/logo"

if [[ -d "${LOGO_DIR}" ]]; then
    shuf -n 1 -e "${LOGO_DIR}"/*.png 2>/dev/null
fi
