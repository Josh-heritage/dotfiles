!/bin/bash

line=$(hyprctl getoption general:gaps_in | grep 'custom type:')

current_gaps=$(echo "$line" | grep -oE '[0-9]+' | head -n 1)

echo "Parsed current gaps: '$current_gaps'"

if [[ -z "$current_gaps" || ! "$current_gaps" =~ ^[0-9]+$ ]]; then
  echo "Could not parse numeric gaps_in value"
  exit 1
fi

# Toggle
if [[ "$current_gaps" -eq 7 ]]; then
  hyprctl keyword general:gaps_in 0
  hyprctl keyword general:gaps_out 0
  hyprctl keyword general:border_size 0
  hyprctl keyword decoration:rounding 0
  hyprctl keyword decoration:inactive_opacity 1
else
  hyprctl keyword general:gaps_in 7
  hyprctl keyword general:gaps_out 20
  hyprctl keyword general:border_size 2
  hyprctl keyword decoration:rounding 10
  hyprctl keyword decoration:inactive_opacity 0.95
fi
