#!/bin/sh
# Screenshots para o mango (não tem ferramenta embutida).
# Requer: grim, slurp, jq, mmsg (mango), notify-send
#
# Uso:
#   screenshot.sh region   -> seleciona uma região (slurp)   (Print)
#   screenshot.sh full     -> tela inteira                    (Ctrl+Print)
#   screenshot.sh window   -> janela focada                  (Alt+Print)

set -eu

dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"
file="$dir/$(date +%Y%m%d%H%M%S).png"

case "${1:-region}" in
  full)
    grim "$file"
    ;;
  region)
    geometry=$(slurp -d) || exit 0
    [ -n "$geometry" ] || exit 0
    grim -g "$geometry" "$file"
    ;;
  window)
    geometry=$(mmsg get focusing-client | jq -r '"\(.x),\(.y) \(.width)x\(.height)"')
    [ -n "$geometry" ] && [ "$geometry" != "null" ] || exit 0
    grim -g "$geometry" "$file"
    ;;
  *)
    echo "uso: $0 {region|full|window}" >&2
    exit 1
    ;;
esac

notify-send "Screenshot" "$file" 2>/dev/null || true
