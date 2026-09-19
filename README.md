# ANSI Image Generator

Generator for images using ANSI escape codes using Processing (for use in Discord and Windows Command Prompt)

This program requires [Processing](https://processing.org/).

## Usage

### discord

ANSI color highlighting on Discord does not work on mobile!

#### image-convert

Place the `.pde` file in the same folder as any `in.png` (preferably under around 25x25) and run the program. The program will find the closest available color in Discord's ANSI color scheme to each pixel and create a resulting image from that, displayed to the screen - this is what the text should look like on Discord. A file `out.txt` will be created, containing the text to copy and send on Discord to get the image to display. The console will have info about how close you are to the message length limit.

#### drawing

Modify the `w` and `h` variables to change the width and height of the drawing canvas. Select colors by clicking the colors at the bottom of the screen, or using the numbers `0`-`7` to select a color. Deselect a color / erase using `` ` ``. A file `out.txt` will be constantly updated with the Discord ANSI version of what you drew - copy the entire contents of the file into a Discord message to send the image. Info about how close the output is to Discord's message length limit will be printed to the console.

### cmd

Place the `.pde` in the same folder as some `in.png` (preferably under about 100x100) and run it; a file `out.bat` will be created in the same directory. Viewing this correctly requires `cmd` to be **run as an administrator** on most systems in order to change the character set (this will not affect your system in any way); open Command Prompt as an administrator, `cd` to the directory containing `out.bat` and run `out.bat` from the terminal. Command Prompt, unlike Discord, allows the use of any hex code to display colors, so the image should come out perfectly.
