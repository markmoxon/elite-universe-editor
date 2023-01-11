#!/usr/bin/env bash

# Set up program locations (change these if they are not aleady in the path)
beebasm="beebasm"
c1541="c1541"
python="python"

# Change directory to the folder containing this script
cd "$(dirname "$0")"

# Create an empty work folder
rm -fr work
mkdir work

# First, we build the NTSC version
cd work

# Extract the files from the original disk image
$c1541 -attach "../original-disks/elite[firebird_1986](ntsc)(v060186)(!).g64" \
       -extract

# Assemble the additional code required for flicker-free ships
$beebasm -i ../src/elite-flicker-free.asm -v > compile.txt

# Assemble the additional code required for the Universe Editor
$beebasm -i ../src/elite-universe-editor-c64.asm -v > compile.txt

# Modify the main game code
$python ../src/elite-modify.py ntsc

# Rebuild the game disk
$c1541 \
    -format "elite uni editor,1" \
            d64 \
            ../../universe-editor-disks/elite-universe-editor-c64-ntsc.d64 \
    -attach ../../universe-editor-disks/elite-universe-editor-c64-ntsc.d64 \
    -write firebird \
    -write gma1.modified gma1 \
    -write gma3 \
    -write gma4 \
    -write gma5 \
    -write gma6.encrypted gma6 \
    -write ../../universe-editor/universe-files/u.boxart1.bin "boxart1" \
    -write ../../universe-editor/universe-files/u.boxart2.bin "boxart2" \
    -write ../../universe-editor/universe-files/u.boxartc.bin "boxartc" \
    -write ../../universe-editor/universe-files/u.manual.bin "manual" \
    -write ../../universe-editor/universe-files/u.shipid.bin "shipid" \
    -write ../../universe-editor/universe-files/u.shipidc.bin "shipidc" \
    -write ../../universe-editor/other-files/readme64.txt "readme,s"

# Next, we build the PAL version
cd work

# Extract the files from the original disk image
$c1541 -attach "../original-disks/elite[firebird_1986](pal)(v040486).g64" \
       -extract

# Assemble the additional code required for flicker-free ships
$beebasm -i ../src/elite-flicker-free.asm -v >> compile.txt

# Assemble the additional code required for the Universe Editor
$beebasm -i ../src/elite-universe-editor-c64.asm -v > compile.txt

# Modify the main game code
$python ../src/elite-modify.py pal

# Rebuild the game disk
$c1541 \
    -format "elite uni editor,1" \
            d64 \
            ../../universe-editor-disks/elite-universe-editor-c64-pal.d64 \
    -attach ../../universe-editor-disks/elite-universe-editor-c64-pal.d64 \
    -write firebird \
    -write byebyejulie \
    -write gma1.modified gma1 \
    -write gma3 \
    -write gma4 \
    -write gma5 \
    -write gma6.encrypted gma6 \
    -write ../../universe-editor/universe-files/u.boxart1.bin "boxart1" \
    -write ../../universe-editor/universe-files/u.boxart2.bin "boxart2" \
    -write ../../universe-editor/universe-files/u.boxartc.bin "boxartc" \
    -write ../../universe-editor/universe-files/u.manual.bin "manual" \
    -write ../../universe-editor/universe-files/u.shipid.bin "shipid" \
    -write ../../universe-editor/universe-files/u.shipidc.bin "shipidc" \
    -write ../../universe-editor/other-files/readme64.txt "readme,s"
