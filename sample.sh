#!/bin/bash

tkbash gui1 --theme clam --title "Fruit chooser" --icon "kitten.png" -w 405 -h 245 --drag 1

tkbash gui1 label  label1  -x 5   -y 5   -w 130 -h 30  --text "I like bananas."
tkbash gui1 select select1 -x 5   -y 40  -w 130 -h 30  --text "Me too|I prefer cookies||Apples|???"

tkbash gui1 button button1 -x 140 -y 5   -w 130 -h 30  --text "Say hello" --command "notify-send hello"
tkbash gui1 edit   edit1   -x 140 -y 40  -w 115 -h 94  --text "Yorem Lipsum yolo git amet" --scrollbar 1 --background "grey" --foreground "yellow" --style "font:verdana 12"

tkbash gui1 image  image1  -x 275 -y 5   -w 125 -h 127 --image "kitten.png"

tkbash gui1 radio  radio1  -x 5   -y 140 -w 130 -h 30  --text "Option 0" --group group1
tkbash gui1 radio  radio2  -x 5   -y 175 -w 130 -h 30  --text "Option 1" --group group1 --selected
tkbash gui1 radio  radio3  -x 5   -y 210 -w 130 -h 30  --text "Option 2" --group group1 --command 'tkbash gui1 label2 --text "You selected option $(tkbash gui1 get radio1)."'

tkbash gui1 label  label2  -x 140 -y 175 -w 395 -h 30 --text "?" --fg '#ff5555'

tkbash gui1 --hotkey Escape --command 'tkbash gui1 --close'
