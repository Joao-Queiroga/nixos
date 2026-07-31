#!/bin/sh
# Liga/desliga um monitor do niri usando o noctalia dmenu como seletor.
# Requer: niri, noctalia, jq

set -eu

map_file=$(mktemp)
trap 'rm -f "$map_file"' EXIT INT TERM

# 1. Lista os outputs conectados (nome + estado atual "on"/"off")
#    e monta o arquivo de mapeamento: "label<TAB>nome<TAB>estado"
niri msg --json outputs \
  | jq -r 'to_entries[] | "\(.key)\t\(if .value.current_mode != null then "on" else "off" end)"' \
  | while IFS="$(printf '\t')" read -r name state; do
      if [ "$state" = "on" ]; then
        estado_pt="ligado"
      else
        estado_pt="desligado"
      fi
      printf '%s (%s)\t%s\t%s\n' "$name" "$estado_pt" "$name" "$state" >> "$map_file"
    done

if [ ! -s "$map_file" ]; then
  notify-send "niri" "Nenhum monitor encontrado" 2>/dev/null || echo "Nenhum monitor encontrado" >&2
  exit 1
fi

chosen=$(cut -f1 "$map_file" | noctalia dmenu -p "Monitor")

# Usuário cancelou (Esc) ou não selecionou nada
[ -z "$chosen" ] && exit 0

line=$(grep -F -- "$(printf '%s\t' "$chosen")" "$map_file" || true)
if [ -z "$line" ]; then
  echo "Seleção inválida: $chosen" >&2
  exit 1
fi

output_name=$(printf '%s\n' "$line" | cut -f2)
current_state=$(printf '%s\n' "$line" | cut -f3)

# 2. Alterna: se está ligado, desliga; se está desligado, liga
if [ "$current_state" = "on" ]; then
  niri msg output "$output_name" off
  action_desc="desligado"
else
  niri msg output "$output_name" on
  action_desc="ligado"
fi

notify-send "niri" "$output_name $action_desc" 2>/dev/null || true
