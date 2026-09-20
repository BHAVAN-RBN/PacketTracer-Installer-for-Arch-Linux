#!/usr/bin/env bash
# Install Cisco Packet Tracer 9.x from the official Ubuntu .deb on Arch Linux.
# The 9.x package ships Packet Tracer as a single AppImage under /opt/pt, so this
# copies it into place and adds a "packettracer" launcher command.
set -euo pipefail

msg()  { printf '\e[1;32m==>\e[0m %s\n' "$*"; }
warn() { printf '\e[1;33mWarning:\e[0m %s\n' "$*" >&2; }
die()  { printf '\e[1;31mError:\e[0m %s\n' "$*" >&2; exit 1; }

usage() {
    cat <<'EOF'
Usage:
  sudo ./packettracer_installer.sh <packettracer.deb>     install
       ./packettracer_installer.sh --inspect <file.deb>   list the package files, install nothing
EOF
}

INSPECT=0
DEB=""
for arg in "$@"; do
    case "$arg" in
        -h|--help) usage; exit 0 ;;
        --inspect) INSPECT=1 ;;
        -*) die "Unknown option: $arg" ;;
        *)  DEB="$arg" ;;
    esac
done

[[ -n "$DEB" ]] || { usage; exit 1; }
[[ -f "$DEB" ]] || die "File not found: $DEB"
DEB=$(realpath "$DEB")
command -v ar  >/dev/null || die "'ar' not found. Install binutils first."
command -v tar >/dev/null || die "'tar' not found."

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir "$tmp/deb" "$tmp/root"

list_files() { (cd "$tmp/root" && find . -maxdepth 4 -printf '%M %10s  %p\n' | sort -k3); }

msg "Extracting $(basename "$DEB")..."
(cd "$tmp/deb" && ar x "$DEB") || die "Not a valid .deb file."
data=$(find "$tmp/deb" -maxdepth 1 -name 'data.tar*' -print -quit)
[[ -n "$data" ]] || die "No data.tar.* found inside the package."
tar -xf "$data" -C "$tmp/root" || die "Could not unpack $(basename "$data") (for .zst you need the zstd package)."

if (( INSPECT )); then
    msg "Files inside the package (depth 4):"
    list_files
    exit 0
fi

[[ $EUID -eq 0 ]] || die "Root privileges are required. Run this script with sudo."
command -v pacman >/dev/null || die "pacman not found. This script is for Arch-based systems."

app=$(find "$tmp/root" -type f -iname '*.appimage' -print -quit)
if [[ -z "$app" ]]; then
    warn "No AppImage found in this package. Files inside:"
    list_files >&2
    die "Unexpected package layout (older 8.x packages did not use an AppImage). Send me the list above."
fi
rel="${app#"$tmp/root"}"          # e.g. /opt/pt/packettracer.AppImage
msg "Found AppImage at $rel"

msg "Installing dependency (fuse2, needed to run AppImages)..."
pacman -S --needed --noconfirm fuse2

msg "Copying files..."
for top in opt usr; do
    if [[ -d "$tmp/root/$top" ]]; then
        mkdir -p "/$top"
        cp -a "$tmp/root/$top/." "/$top/"
    fi
done
while IFS= read -r extra; do
    warn "Package also contains /$(basename "$extra"), which was not installed."
done < <(find "$tmp/root" -mindepth 1 -maxdepth 1 -not -name opt -not -name usr)
chmod 755 "$rel"

msg "Creating launcher /usr/local/bin/packettracer..."
mkdir -p /usr/local/bin
printf '#!/bin/sh\nexec %q "$@"\n' "$rel" > /usr/local/bin/packettracer
chmod 755 /usr/local/bin/packettracer

msg "Installed."
echo "Next: run 'packettracer' once from a terminal (as your normal user, not root)."
echo "That first run asks you to accept Cisco's license and sets up the desktop files."
