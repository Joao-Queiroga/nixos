#!/bin/sh
# Liga/desliga monitores do mango via mmsg (IPC), usando o dmenu do noctalia.
# Requer: mango (mmsg), jq, noctalia, notify-send
#
# Uso:
#   monitors.sh       -> lista os monitores e alterna o escolhido (SUPER+M)
#   monitors.sh all   -> desliga a energia de todos os monitores (SUPER+SHIFT+P)
#
# Observação: o IPC do mango não expõe o estado de energia (DPMS), então o
# estado "ligado/desligado" é rastreado em um arquivo de estado.

set -eu

state_file="${XDG_RUNTIME_DIR:-/tmp}/mango-monitor-states"

state_of() {
  if [ -f "$state_file" ]; then
    awk -F'\t' -v n="$1" '$2 == n { print $1; found = 1 } END { if (!found) print "on" }' "$state_file"
  else
    printf 'on'
  fi
}

set_state() {
  tmp=$(mktemp)
  if [ -f "$state_file" ]; then
    awk -F'\t' -v n="$1" '$2 != n' "$state_file" > "$tmp"
  else
    : > "$tmp"
  fi
  printf '%s\t%s\n' "$2" "$1" >> "$tmp"
  mv "$tmp" "$state_file"
}

all_monitors() {
  mmsg get all-monitors | jq -r '.monitors[].name'
}

# Desliga todos os monitores
if [ "${1:-}" = "all" ]; then
  count=0
  for name in $(all_monitors); do
    [ -n "$name" ] || continue
    mmsg dispatch "sleep_monitor,$name"
    set_state "$name" off
    count=$((count + 1))
  done
  if [ "$count" -eq 0 ]; then
    notify-send "mango" "Nenhum monitor encontrado" 2>/dev/null || true
    exit 1
  fi
  notify-send "mango" "Monitores desligados" 2>/dev/null || true
  exit 0
fi

# 1. Monta o menu: "NOME (ligado/desligado)<TAB>NOME"
map_file=$(mktemp)
trap 'rm -f "$map_file"' EXIT INT TERM

for name in $(all_monitors); do
  [ -n "$name" ] || continue
  state=$(state_of "$name")
  if [ "$state" = "on" ]; then
    label="ligado"
  else
    label="desligado"
  fi
  printf '%s (%s)\t%s\n' "$name" "$label" "$name" >> "$map_file"
done

if [ ! -s "$map_file" ]; then
  notify-send "mango" "Nenhum monitor encontrado" 2>/dev/null || echo "Nenhum monitor encontrado" >&2
  exit 1
fi

# 2. Seletor
chosen=$(cut -f1 "$map_file" | noctalia dmenu -p "Monitor")
[ -n "$chosen" ] || exit 0

line=$(grep -F -- "$(printf '%s\t' "$chosen")" "$map_file" || true)
[ -n "$line" ] || { echo "Seleção inválida: $chosen" >&2; exit 1; }

name=$(printf '%s\n' "$line" | cut -f2)

# 3. Alterna a energia do monitor escolhido
state=$(state_of "$name")
mmsg dispatch "sleep_toggle_monitor,$name"

if [ "$state" = "on" ]; then
  set_state "$name" off
  action_desc="desligado"
else
  set_state "$name" on
  action_desc="ligado"
fi

notify-send "mango" "$name $action_desc" 2>/dev/null || true
