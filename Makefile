BEEBASM?=beebasm
PYTHON?=python
C1541?=c1541

.PHONY:all
all:
	$(BEEBASM) -i 1-source-files/main-sources/elite-universe-editor-readme.asm
	$(BEEBASM) -i 1-source-files/main-sources/elite-universe-editor-disc.asm -do 4-compiled-game-discs/elite-universe-editor-bbc.ssd -opt 3 -title "ELITE U E"

	@$(C1541) \
    -format "elite uni editor,1" \
            d64 \
            4-compiled-game-discs/elite-universe-editor-c64-ntsc.d64 \
    -attach 4-compiled-game-discs/elite-universe-editor-c64-ntsc.d64 \
    -write elite-universe-editor-commodore-64/work/ntsc/firebird \
    -write elite-universe-editor-commodore-64/work/ntsc/gma1.modified gma1 \
    -write elite-universe-editor-commodore-64/work/ntsc/gma3 \
    -write elite-universe-editor-commodore-64/work/ntsc/gma4 \
    -write elite-universe-editor-commodore-64/work/ntsc/gma5 \
    -write elite-universe-editor-commodore-64/work/ntsc/gma6.encrypted gma6 \
    -write elite-universe-editor-library/universe-files/u.boxart1.bin "boxart1" \
    -write elite-universe-editor-library/universe-files/u.boxart2.bin "boxart2" \
    -write elite-universe-editor-library/universe-files/u.boxartc.bin "boxartc" \
    -write elite-universe-editor-library/universe-files/u.manual.bin "manual" \
    -write elite-universe-editor-library/universe-files/u.shipid.bin "shipid" \
    -write elite-universe-editor-library/universe-files/u.shipidc.bin "shipidc" \
    -write 3-assembled-output/readme64.txt "readme,s"

	@$(C1541) \
    -format "elite uni editor,1" \
            d64 \
            4-compiled-game-discs/elite-universe-editor-c64-pal.d64 \
    -attach 4-compiled-game-discs/elite-universe-editor-c64-pal.d64 \
    -write elite-universe-editor-commodore-64/work/pal/firebird \
    -write elite-universe-editor-commodore-64/work/pal/byebyejulie \
    -write elite-universe-editor-commodore-64/work/pal/gma1.modified gma1 \
    -write elite-universe-editor-commodore-64/work/pal/gma3 \
    -write elite-universe-editor-commodore-64/work/pal/gma4 \
    -write elite-universe-editor-commodore-64/work/pal/gma5 \
    -write elite-universe-editor-commodore-64/work/pal/gma6.encrypted gma6 \
    -write elite-universe-editor-library/universe-files/u.boxart1.bin "boxart1" \
    -write elite-universe-editor-library/universe-files/u.boxart2.bin "boxart2" \
    -write elite-universe-editor-library/universe-files/u.boxartc.bin "boxartc" \
    -write elite-universe-editor-library/universe-files/u.manual.bin "manual" \
    -write elite-universe-editor-library/universe-files/u.shipid.bin "shipid" \
    -write elite-universe-editor-library/universe-files/u.shipidc.bin "shipidc" \
    -write 3-assembled-output/readme64.txt "readme,s"
