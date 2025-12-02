#!/bin/bash

# Directory containing your images
IMAGE_DIR="$HOME/Pictures/wallpapers"  # Set this to your folder with images

# Time interval between background changes (in seconds)
INTERVAL=5  # 300 seconds = 5 minutes

# Infinite loop to keep cycling through the images
while true; do
    # Loop through each image file in the directory
    for img in "$IMAGE_DIR"/*; do
        # Check if the file is an actual image (optional)
        if file "$img" | grep -qE 'image|bitmap'; then
            swaybg --output '*' --mode fill  --image "$img"
            wal -i "$img"
            echo "Set background to $img"

            # Wait for the specified interval before moving to the next image
            sleep $INTERVAL
        fi
    done
done
