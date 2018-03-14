#!/bin/bash
set -m
tail -f /dev/null &
fg=$!

tkbash gui1 label label1 -x 5 -y 5 -w 130 -h 30 -t "gui"
# ... more gui

tkbash gui1 --onclose -c "kill $fg"
fg