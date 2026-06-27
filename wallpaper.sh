#!/bin/bash

WALLPAPER_DIR="/home/$USER/.wallpaper"
LAST_WALLPAPER_FILE="$HOME/.last_wallpaper"

# 1. Get wallpapers
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) | sort)

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    echo "Error: No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# 2. Get last wallpaper
LAST_WALLPAPER=$(cat "$LAST_WALLPAPER_FILE" 2>/dev/null || echo "")

# 3. Find next index
INDEX=-1
for i in "${!WALLPAPERS[@]}"; do
    if [[ "${WALLPAPERS[$i]}" == "$LAST_WALLPAPER" ]]; then
        INDEX=$i
        break
    fi
done

INDEX=$((INDEX + 1))
[ $INDEX -ge ${#WALLPAPERS[@]} ] && INDEX=0
SELECTED_WALLPAPER="${WALLPAPERS[$INDEX]}"

# 4. The new Hyprpaper v0.8.0+ Commands
# We must PRELOAD first, then set the WALLPAPER
hyprctl hyprpaper preload "$SELECTED_WALLPAPER"
hyprctl hyprpaper wallpaper " ,$SELECTED_WALLPAPER"

# 5. Clean up: Save state and unload old wallpaper to save RAM
echo "$SELECTED_WALLPAPER" > "$LAST_WALLPAPER_FILE"
if [ -n "$LAST_WALLPAPER" ] && [ "$LAST_WALLPAPER" != "$SELECTED_WALLPAPER" ]; then
    hyprctl hyprpaper unload "$LAST_WALLPAPER"
fi

echo "Setting wallpaper: $SELECTED_WALLPAPER"
