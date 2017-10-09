#!/bin/bash
tkbash 1 label label1 --relx 0.4 -y 10 -w 130 -h 20 -t "I like bananas."
tkbash 1 select select1 --relx 0.4 -y 30 -w 130 -h 20 -t "Black|White|Green|Blue"
tkbash 1 button button1 -x 165 -y 75 -w 120 -h 30 -t "Delete text" --command "
    tkbash 1 text1 -t ''
    notify-send \"You selected color \$(tkbash 1 get select1)! \""
tkbash 1 text text1 -x 165 -y 105 -w 120 -h 120 -t "Yorem Lipsum"
tkbash 1 image image1 -x 10 -y 60 -w 125 -h 120 --image "kitten.png"
tkbash 1 window --theme clam -w 290 -h 250 --title "I am butiful" --alwaysontop 1 --icon "kitten.png"
tkbash 1 window --hotkey Escape --command "echo You pressed Escape."
