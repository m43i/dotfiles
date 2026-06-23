#!/usr/bin/env bash

set -euo pipefail

theme_file="${HOME}/.config/omarchy/current/theme/colors.toml"

background="#1F1F28"
foreground="#DCD7BA"
accent="#7E9CD8"
muted="#54546D"

trim() {
  local value="$1"
  value="${value#${value%%[![:space:]]*}}"
  value="${value%${value##*[![:space:]]}}"
  printf '%s' "$value"
}

read_palette() {
  [ -f "$theme_file" ] || return 0

  while IFS='=' read -r raw_key raw_value; do
    [ -n "${raw_value:-}" ] || continue

    local key value
    key="$(trim "$raw_key")"
    value="$(trim "$raw_value")"
    value="${value#\"}"
    value="${value%\"}"

    case "$key" in
      background) background="$value" ;;
      foreground) foreground="$value" ;;
      accent) accent="$value" ;;
      color8) muted="$value" ;;
    esac
  done < "$theme_file"
}

apply_tmux_theme() {
  tmux set-option -gq status-style "bg=${background},fg=${foreground}"
  tmux set-option -gq message-style "bg=${background},fg=${foreground}"

  tmux set-option -gq pane-border-style "fg=${muted}"
  tmux set-option -gq pane-active-border-style "fg=${muted}"
  tmux set-option -gq pane-border-format "#[bg=${muted},fg=${muted}]"

  tmux set-option -gq status-left "#[fg=${accent}]#S #[fg=${muted}]│ "
  tmux set-option -gq status-right "#[fg=${muted}] #(iw dev wlan0 link 2>/dev/null | awk '/SSID/ {print \"󰖩 \" \$2}' || (ip link show | grep -E 'eth|enp' | grep -q 'state UP' && echo '󰈁 ethernet') || echo '󰖪 disconnected') │  #(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null || echo '')#(test -f /sys/class/power_supply/BAT*/capacity && echo '%' || echo '')#(grep -q 'Charging' /sys/class/power_supply/BAT*/status 2>/dev/null && echo ' 󱐋' || echo '')#(test -f /sys/class/power_supply/BAT*/capacity && echo ' │ ' || echo '') %H:%M %d.%m.%Y"

  tmux set-window-option -gq window-status-format "#[fg=${muted}]#I:#W"
  tmux set-window-option -gq window-status-current-format "#[fg=${foreground},bold]#I:#W"
}

read_palette
apply_tmux_theme
