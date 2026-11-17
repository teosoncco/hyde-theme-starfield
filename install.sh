#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_THEME_DIR="${SCRIPT_DIR}/Starfield"
DEST_THEME_DIR="${HOME}/.config/hyde/themes/Starfield"
SRC_FF_DIR="${SCRIPT_DIR}/fastfetch"
DEST_FF_DIR="${HOME}/.config/fastfetch"
DEFAULT_WALLPAPER="starfield_constellation_light.png"

if [[ ! -d "${SRC_THEME_DIR}" ]]; then
    echo "Error: No se encontró ${SRC_THEME_DIR}" >&2
    exit 1
fi

echo "Instalando tema Starfield (Light Mode) en ${DEST_THEME_DIR}..."
mkdir -p "${DEST_THEME_DIR}"
cp -a "${SRC_THEME_DIR}/." "${DEST_THEME_DIR}/"

WALL_PATH="${DEST_THEME_DIR}/wallpapers/${DEFAULT_WALLPAPER}"
if [[ ! -f "${WALL_PATH}" ]]; then
    FIRST_WALL="$(find "${DEST_THEME_DIR}/wallpapers" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) | sort | head -n 1 || true)"
    if [[ -n "${FIRST_WALL}" ]]; then
        WALL_PATH="${FIRST_WALL}"
    fi
fi

if [[ -n "${WALL_PATH}" && -f "${WALL_PATH}" ]]; then
    ln -sf "${WALL_PATH}" "${DEST_THEME_DIR}/wall.set"
    ln -sf "${WALL_PATH}" "${DEST_THEME_DIR}/wall.awww.png"
    ln -sf "${WALL_PATH}" "${DEST_THEME_DIR}/wall.swww.png"
    ln -sf "${WALL_PATH}" "${DEST_THEME_DIR}/wall.hyprlock.png"
    echo "Symlinks de wallpaper configurados -> ${WALL_PATH}"
else
    echo "Advertencia: No se encontraron wallpapers en ${DEST_THEME_DIR}/wallpapers" >&2
fi

if [[ -d "${SRC_FF_DIR}" ]]; then
    echo "Instalando preset de Fastfetch Starfield en ${DEST_FF_DIR}/starfield.jsonc..."
    mkdir -p "${DEST_FF_DIR}"
    cp "${SRC_FF_DIR}/config.jsonc" "${DEST_FF_DIR}/starfield.jsonc"
    cp "${SRC_FF_DIR}/starfield-logo.sh" "${DEST_FF_DIR}/starfield-logo.sh"
    chmod +x "${DEST_FF_DIR}/starfield-logo.sh"
fi

SRC_ICONS_DIR="${SCRIPT_DIR}/Starfield-Icons"
DEST_ICONS_DIR="${HOME}/.local/share/icons/Starfield-Icons"

if [[ -d "${SRC_ICONS_DIR}" ]]; then
    echo "Instalando tema de íconos Starfield-Icons en ${DEST_ICONS_DIR}..."
    mkdir -p "${DEST_ICONS_DIR}"
    cp -a "${SRC_ICONS_DIR}/." "${DEST_ICONS_DIR}/"
    if command -v gtk-update-icon-cache >/dev/null 2>&1; then
        gtk-update-icon-cache -f -t "${DEST_ICONS_DIR}" >/dev/null 2>&1 || true
    fi
fi

if [[ "${1:-}" == "--apply" ]]; then
    if command -v hydectl >/dev/null 2>&1; then
        echo "Aplicando tema Starfield con hydectl..."
        hydectl theme set Starfield
    else
        echo "Advertencia: hydectl no encontrado en PATH. Aplícalo manualmente desde el selector de temas." >&2
    fi
fi

echo "Listo. Puedes seleccionarlo en HyDE con 'hydectl theme set Starfield' o desde el selector de temas."
