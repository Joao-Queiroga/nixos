#!/bin/sh
# Liga/desliga um monitor do umbriel usando o noctalia dmenu como seletor.
# Requer: umbriel, noctalia, jq

set -eu

map_file=$(mktemp)
trap 'rm -f "$map_file"' EXIT INT TERM

# 1. Lista os outputs conectados (nome + estado atual "on"/"off")
#    `umbriel outputs --json` retorna uma lista de objetos com "name" e "enabled".
#    O jq aceita tanto a lista direta quanto o formato "{"ok": [...]}".
umbriel outputs --json \
  | jq -r 'if type == "array" then .[] else .ok[] end | "\(.name)\t\(if .enabled then "on" else "off" end)"' \
  | while IFS="$(printf '\t')" read -r name state; do
      if [ "$state" = "on" ]; then
        estado_pt="ligado"
      else
        estado_pt="desligado"
      fi
      printf '%s (%s)\t%s\t%s\n' "$name" "$estado_pt" "$name" "$state" >> "$map_file"
    done

if [ ! -s "$map_file" ]; then
  notify-send "umbriel" "Nenhum monitor encontrado" 2>/dev/null || echo "Nenhum monitor encontrado" >&2
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
  umbriel msg output-disable "$output_name"
  action_desc="desligado"
else
  umbriel msg output-enable "$output_name"
  action_desc="ligado"
fi

notify-send "umbriel" "$output_name $action_desc" 2>/dev/null || true
