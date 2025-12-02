#!/bin/sh
WALLPAPER_DIR="$HOME/Pictures/wallpapers" # **Update this path**

# Start the first wallpaper instance
swaybg -i $(find "$WALLPAPER_DIR" -type f | shuf -n1) -m fill &
OLD_PID=$!

while true; do
  sleep 100 # Change every 10 minutes (600 seconds)
  swaybg -i $(find "$WALLPAPER_DIR" -type f | shuf -n1) -m fill &
  wall -i "$WALLPAPER_DIR"
  NEXT_PID=$!
  sleep 5
  kill $OLD_PID
  OLD_PID=$NEXT_PID
done

