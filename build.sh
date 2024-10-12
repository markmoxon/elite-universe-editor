#!/usr/bin/env bash

# Set up program locations (change these if they are not aleady in the path)
c1541="c1541"

# Build NTSC game disk
$c1541 \
    -format "elite uni editor,1" \
            d64 \
            3-compiled-game-discs/elite-universe-editor-c64-ntsc.d64 \
    -attach 3-compiled-game-discs/elite-universe-editor-c64-ntsc.d64 \
    -write c64-elite-universe-editor/work/ntsc/firebird \
    -write c64-elite-universe-editor/work/ntsc/gma1.modified gma1 \
    -write c64-elite-universe-editor/work/ntsc/gma3 \
    -write c64-elite-universe-editor/work/ntsc/gma4 \
    -write c64-elite-universe-editor/work/ntsc/gma5 \
    -write c64-elite-universe-editor/work/ntsc/gma6.encrypted gma6 \
    -write elite-universe-editor-library/universe-files/u.boxart1.bin "boxart1" \
    -write elite-universe-editor-library/universe-files/u.boxart2.bin "boxart2" \
    -write elite-universe-editor-library/universe-files/u.boxartc.bin "boxartc" \
    -write elite-universe-editor-library/universe-files/u.manual.bin "manual" \
    -write elite-universe-editor-library/universe-files/u.shipid.bin "shipid" \
    -write elite-universe-editor-library/universe-files/u.shipidc.bin "shipidc" \
    -write 2-assembled-output/readme64.txt "readme,s" \
    -write 1-source-files/other-files/empty.txt "build ${CURRENTDATE},s"

# Build the PAL game disk
$c1541 \
    -format "elite uni editor,1" \
            d64 \
            3-compiled-game-discs/elite-universe-editor-c64-pal.d64 \
    -attach 3-compiled-game-discs/elite-universe-editor-c64-pal.d64 \
    -write c64-elite-universe-editor/work/pal/firebird \
    -write c64-elite-universe-editor/work/pal/byebyejulie \
    -write c64-elite-universe-editor/work/pal/gma1.modified gma1 \
    -write c64-elite-universe-editor/work/pal/gma3 \
    -write c64-elite-universe-editor/work/pal/gma4 \
    -write c64-elite-universe-editor/work/pal/gma5 \
    -write c64-elite-universe-editor/work/pal/gma6.encrypted gma6 \
    -write elite-universe-editor-library/universe-files/u.boxart1.bin "boxart1" \
    -write elite-universe-editor-library/universe-files/u.boxart2.bin "boxart2" \
    -write elite-universe-editor-library/universe-files/u.boxartc.bin "boxartc" \
    -write elite-universe-editor-library/universe-files/u.manual.bin "manual" \
    -write elite-universe-editor-library/universe-files/u.shipid.bin "shipid" \
    -write elite-universe-editor-library/universe-files/u.shipidc.bin "shipidc" \
    -write 2-assembled-output/readme64.txt "readme,s" \
    -write 1-source-files/other-files/empty.txt "build ${CURRENTDATE},s"
