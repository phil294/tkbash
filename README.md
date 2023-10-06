# tkbash
## Build fancy GUIs via command line!
Bash wrapper for Tcl/Tk gui. Inspired by [AutoHotkey](https://autohotkey.com/docs/commands/Gui.htm)'s GUI

---
*Status of this project:*
*It all works pretty well (albeit slow) and stable. The only known significant bug is [#14](/../../issues/14). I'm not actively working on this anymore but if someone feels like it, I will of course help you out. For a more feature-complete and much more performant alternative for easy Guis on Linux – if Python is feasible for you – I recommend [guietta](https://github.com/alfiopuglisi/guietta/). If you need a standalone binary, consider [AHK_X11](https://github.com/phil294/AHK_X11) (Autohotkey Linux).*

---

![tkbash-gui](https://i.imgur.com/VcacY87.png)
```bash
tkbash gui1 --theme clam --title "Fruit chooser" -w 405 -h 245
tkbash gui1 --hotkey Escape --command 'tkbash gui1 --close'
# elements
tkbash gui1 label  label1  -x 5   -y 5   -w 130 -h 30  --text "I like bananas."
tkbash gui1 select select1 -x 5   -y 40  -w 130 -h 30  --text "Me too|I prefer cookies||Apples|???"
tkbash gui1 button button1 -x 140 -y 5   -w 130 -h 30  --text "Say hello" --command "notify-send hi"
tkbash gui1 edit   edit1   -x 140 -y 40  -w 115 -h 94  --text "Yorem Lipsum yolo git amet" \
	--scrollbar 1 --background "grey" --foreground "yellow" --style "font:verdana 12"
tkbash gui1 image  image1  -x 275 -y 5   -w 125 -h 127 --image "kitten.png"
tkbash gui1 radio  radio1  -x 5   -y 140 -w 130 -h 30  --text "Option 0" --group group1
tkbash gui1 radio  radio2  -x 5   -y 175 -w 130 -h 30  --text "Option 1" --group group1 --selected
tkbash gui1 radio  radio3  -x 5   -y 210 -w 130 -h 30  --text "Option 2" --group group1 \
	--command 'tkbash gui1 label2 --text "You selected option $(tkbash gui1 get radio1)."'
tkbash gui1 label  label2  -x 140 -y 175 -w 395 -h 30 --text "?" --fg '#ff5555'
```

- **Same syntax for adding and editing elements**
- Pure bash code (internally translates into respective [Tcl/Tk](https://www.tcl.tk/) code, sent to `wish` background process)
- Gui runs in background, accessible from everywhere and everytime using `tkbash <gui-id> dosomething...`
- Pass callback code directly as `--command <command>`
- Print element contents with `get <variable>`
- Currently supports: text (input), combobox (select), checkbutton (checkbox), radiobutton groups, button, label, image
- Every element gets placed with absolute or window-relative coordinates. No geometry managers supported.
- Hotkey support
- Entire functionality of Tk available if desired via `--tkcommand` (see end of this page)
- Not very fast (above example takes ~0.35 sec)
- Configure multiple GUIs that access each other
- Busybox-compatible
- Docker-compatible (see below)

### Popup
Example of a basic popup (similar to notify-send) that closes itself and opens up google if clicked.

<img align="center" alt="tkbash-popup" src="https://i.imgur.com/M9S6yra.png">

```bash
tkbash gui2 --notitlebar -w 350 -h 100 -x 10 -y 10 --alpha 0.68 --bg black --onclick -c "x-www-browser 'google.com'; tkbash gui2 --close"
tkbash gui2 p p -x 10 -y 10 -w 330 -h 80 --bg black --fg white -t "popup text..."
```

This repository is fairly new. If you experience any issues or think that some cool stuff is missing, please open an issue above or contact philip@waritschlager.de. Commits welcome.

Snapshot of `tkbash --help`:

```
>>> TkBash. Basic Bash superset for Tcl/Tk gui. Just a layer,
NO reimplementation of Tk. Place elements using absolute coordinates x/y/w/h.

USAGE:
    tkbash <gui_id> [<element>] <variable> [-options...]
        Add / edit element. For basic usage, you dont need anything else.
    tkbash <gui_id> get <variable>
        Print the value of the associated element.
    tkbash <gui_id> [-options...]
        Set global window properties.

    tkbash <gui_id> [<variable>] --tkcommand <command>
        Execute custom Tcl/Tk code. For advanced element configuration not
        provied by tkbash itself. "--tkcommand" can also be "--tk". Variable
        can be ommitted for full access. Example:
        "tkbash mygui mybutton --tkcommand 'configure -font verdana'" or
        "tkbash mygui --tkcommand 'wm maxsize .w 200 200'".
        Note: toplevel root window in tkbash is ".w".
    [any command...] --debug, --print, --log
        Print all commands sent to the wish background process (Tcl/Tk code)
        to stderr. For debugging.


        gui_id
            Unique identifier for the GUI. To be reused with subsequent tkbash
            calls.
        element
            Any of the elements listed below. Required when adding a new one.
        variable
            Variable to hold the value associated with the element.

        When adding an element for the first time, all positional options are
        required (-x, -y, -w, -h). See general element options.

Window properties
Set options for the entire interface / window as described above. You can set
width and height if BOTH are specified (if w and y are also specified, you will
set also the window position).
    --theme <themename>
        Set the look and feel used by all all elements. Available themes usually
        include clam, alt, default and classic. Important: If you use this
        option, any individual styling to themed elements might be gone and
        needs to be reapplied.
    --title <title>
        Set the window title.
    --alwaysontop, --topmost <switch>
        Set the window's always on top behaviour. Activate with 0,
        deactivate with 1.
    --maximize
        Maxmize the window to fullscreen.
    --alpha, --transparency <alpha>
        Set the transparency of the entire window. Floating value between 0 and
        1. Note that sometimes, this does not work. You might need to put a
        delay before using this option, for some reason. Try it out.
    --icon <iconpath>
        Set the window icon.
    --background, --backgroundcolor, --bck, --bg <color>
        Set the background color for the entire window. You might need to also
        set the background for individual elements for they do not inherit this
        setting. Use common color names like red, yellow etc. or hex notation
        like #ff1234.
    --resizable <switch>
        Set the window's resizable behaviour. Activate with 0, deactivate with 1.
    --movebymouse, --movewithmouse, --draggable --drag <switch>
        Enable or disable the ability of the window to be dragged with the mouse
        around the screen. Activate with 0, deactivate with 1. The window can
        only be dragged when the mouse is not hovering over any interactive
        element. Note: If you are looking for drag&drop for external files, text
        etc., see the readme example at the end.
    --iconify
        Minimize the window.
    --hide
        Hide the window by detaching it from the Window Manager.
    --show
        Set the window visible by re-attaching it to the Winodow Manager.
    --close, --exit, --quit, --destroy
        Close the window programmatically. This is equal to the user pressing
        the X button or pressing alt+f4. Waits until closing operations finished
        (including --onclose commands).
    --hotkey, --bind, --shortcut
        Add an action to be executed when a key ("sequence") is pressed.
        Possible sequences: See https://www.tcl.tk/man/tcl8.4/TkCmd/bind.htm#M5.
        Specify the commands to be executed use the --command option. Example:
        "tkbash mygui --hotkey Escape --command 'echo You pressed Escape.'"
        Also see --command note below.
    --onclose, --onexit
        Add an action to be executed when the window is closed. Specify the
        commands to be executed using the --command option. Example:
        "tkbash mygui --onclose --command 'echo tkbash now exits.'"
        The GUI will only exit once the --command has finished. Also see
        --command note below.
    --exist
        Prints 1 if the specified <gui_id> belongs to a running window, 0
        otherwise.
    --notitlebar, --nobar, --nocaption, --nodecorations, --tooltip, --popup,
    --overrideredirect
        Important: This option is only considered at window creation. Thus, it
        should be part of the very first tkbash call made for this <gui_id>.
        - Make the GUI unmapped: The window cannot be moved, typed into, have
        hotkeys assigned etc. The window is automatically always-on-top and does
        not appear in the panel. This option might be interesting for creating a
        tooltip. Appropriate buttons should be configured so the user can
        actually close the window (see window --close).
    --onclick
        Add an action to be executed when the user clicks anywhere on the gui.
        Specify the commands to be executed using the --command option. Example:
        "tkbash mygui --onclick --command 'echo You clicked the window.'" Also
        see --command note below.

ELEMENTS
    button / submit / b
        Options:
            -t, --text, --content <text>
                The text that will be displayed on the button.
            -c, --command <command>
                Code to be executed when the element is clicked. Also see
                --command note below.
        Get:
            You cannot retrieve any value from a button.
    text / input / edit / textfield / textarea / t
        A text element is a multiline input area for text.
        Options:
            --scrollbar <switch>
                Show or hide the vertical scrollbar next to the textfield.
                <switch> is 0 or 1.
            -t, --text, --content <text>
                Set the contents of the text field.
            --ignore-return, --ignore-newline, --entry, --one-row
                The user cannot type newlines. If combined with an appropriate
                height, this could also be used as a form input.
        Get:
            Prints the contents of the text field.
    label / p / l
        A label element displays plain text somewhere on the gui.
        Options:
            -t, --text, --content <text>
                Set the contents of the label.
        Get:
            You cannot retrieve any value from a label.
    image / picture / img / bmp / bitmap / i
        Display an image.
        Options:
            --image <path>
                Path of the image to be shown. Not all formats are supported.
                (yes: png, no: jpg)
        Get:
            You cannot retrieve any value from an image.
        Note: Internally, this does the same like 'label', meaning these two
        element names are interchangeable.
    checkbutton / checkbox / check / tick / toggle / cb
        For boolean values. If neither --checked nor --unchecked is passed, the
        checkbutton is in a neither-state (pristine)
        Options:
            -t, --text, --content <text>
                Set the text to be displayed next to the tick.
            -c, --command <command>
                Code to be executed when the element is clicked. Also see
                --command note below.
            --selected, --checked
                Set selected state to 1.
            --deselected, --unchecked
                Set selected state to 0.
        Get:
            Prints 1 when checked, 0 when unchecked, nothing when pristine.
    radiobutton / radio / r
        Multiple radiobuttons form a group. Only one radiobutton in a group can
        be active at the same time.
        Options:
            [required] --group <group-id>
                Assign this radiobutton to a group. Can be any string. See 'get'
                below. In contrary to most options, this one can not be changed
                afterwards, meaning if you pass it any other time that on
                element creation, it is ignored.
            -t, --text, --content <text>
                Set the text to be displayed next to the radiobutton.
            -c, --command <command>
                Code to be executed when the element is clicked. Also see
                --command note below.
            --selected, --checked
                Set this radio as the selected one from its group.
        Get:
            Every radiobutton gets internally assigned a number. The first
            radiobutton of a group has the number 0, the second 1, third 2 and
            so on. When you call the 'get' method for any of the radios
            contained in this group, it will print out the number of the
            selected radio (or nothing when pristine) in its group: 0 or 1 or 2
            or whatever. The name of the group does not matter for retrieving
            the value. The group is only needed when a radiobutton is created.
    combobox / select / dropdown / dropdownmenu / s / c
        Select one of many values. Behaves like a classical HTML-select (the Tk-
        state 'readonly' is active).
        Options:
            -t, --text, --content <text>
                A pipe-delimited list (e.g. "option1|option2|option3") of
                options for this select which the user will be able to choose
                from. Set the default value by appending two pipes. For example
                "option1|option2||option3" to have option2 be selected by
                default. Otherwise, the first one would be selected.
            -c, --command <command>
                Code to be executed when an item is chosen. Also see
                --command note below.
        Get:
            Prints the selected value, e.g. "option1" when the first value is
            chosen.

General element options
    -x <x-position>
    (optional) -X, --relx <x-position>
    -y <y-position>
    (optional) -Y, --rely <y-position>
    -w, --width <width>
    -h, --height <height>

    --disabled <switch>
        Dissables (greys out) the command. Can be used with any element, will
        however take no action  on labels. <switch> is 0 or 1.
    --notheme
        Make the element ignore the current theme. Can only be used upon element
        creation (ignored in subsequent calls!).
    --foreground, --foregroundcolor, --color, --textcolor, --fg <color>
        Set the foreground color (typically, text color). Use common color names
        like red, yellow etc. or hex notation #ff1234.
    --background, --backgroundcolor, --bck, --bg <color>
        Set the background color. Use common color names like red, yellow etc.
        or hex notation like #ff1234.
    --style <property:value>
        You can set any arbitrary styling option with this syntax, even those
        which are not supported natively by tkbash. For a list of available
        properties, visit https://www.tcl.tk/man/tcl8.4/TkCmd/options.htm or
        https://wiki.tcl.tk/37973 or ...? (neither of them is complete it
        seems). Example: 'tkbash mygui mybutton --style "font:verdana 20"'

Additional notes
Note on the -c, --command option: The command contents will be written into
a temp file and then called on action. You can preceed this with your custom
shebang. Thus, session variables cannot be accessed.

```

## Bonus stuff

### Drag+drop
Here is a minimal example of how drag'n'drop might be implemented for the image element from the above sample window. This supports files, text etc. This functionality is not supported natively because it needs an external library. Download here: http://wiki.tcl.tk/2768 & copy for example to /usr/share/tcltk/tclx.y/. The below code makes use of the `--tkcommand` option. So, everything starting from `package` on is tcl code.
```bash
# full tkdnd reference: http://wiki.tcl.tk/36708
tkbash gui1 --tk 'package require tkdnd
    tkdnd::drop_target register .w.image1 *
    bind .w.image1 <<Drop>> {
        exec notify-send "You dropped %D"
    }'
```

### Busybox and Docker Alpine
You can run tkbash from within a Docker container with X11 forwarding. Unfortunately, Alpine Linux results in a segmentation fault ([bugreport](https://core.tcl.tk/tk/tktview?name=a043e3a8b5)), so you need another OS. In the subfolder `docker`, you find an example with Debian (run `build_run.sh`).
