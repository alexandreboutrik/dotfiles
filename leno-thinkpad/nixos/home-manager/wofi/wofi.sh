#!/usr/bin/env bash

# Define menu options
options="󰈹  Firefox\n󰈙  Libreoffice\n  Alacritty\n  Shutdown"

# Launch wofi with the specified options
selected=$(echo -e "$options" | wofi --show dmenu --cache-file=/dev/null)

# Handle the selected option
case $(echo "$selected" | sed 's/.* //') in
  "Firefox")
    firefox &
    ;;
  "Libreoffice")
    libreoffice &
    ;;
  "Alacritty")
    alacritty -o font.size=18 &
    ;;
  "Shutdown")
    shutdown -h now
    ;;
esac
