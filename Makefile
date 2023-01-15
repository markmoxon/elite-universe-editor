BEEBASM?=beebasm
PYTHON?=python

.PHONY:all
all:
	+$(MAKE) encrypt -C 6502sp-elite
	+$(MAKE) encrypt -C master-elite
	$(BEEBASM) -i universe-editor/main-sources/elite-universe-editor-readme.asm
	$(BEEBASM) -i universe-editor/main-sources/elite-universe-editor-disc.asm -do universe-editor-disks/elite-universe-editor-bbc.ssd -opt 3 -title "ELITE U E"
	c64-elite/build.sh
