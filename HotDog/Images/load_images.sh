#!/bin/bash

# This script adds all image files in the current directory to the iOS simulator
# Ensure that the iOS simulator is already booted before running this script

# Loop through all jpg and png files in the current directory
for image in *.jpg *.png; do
  # Check if the file exists and is not a directory
  if [ -f "$image" ]; then
    echo "Adding $image to the simulator..."
    xcrun simctl addmedia booted "$image"
  fi
done

echo "All applicable images have been added to the simulator."
