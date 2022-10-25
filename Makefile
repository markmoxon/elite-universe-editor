BEEBASM?=beebasm
PYTHON?=python

all:
	+$(MAKE) encrypt -C 6502sp-elite
	+$(MAKE) encrypt -C master-elite
	$(BEEBASM) -i universe-editor/main-sources/elite-universe-editor-disc.asm $(boot-master) -do elite-universe-editor.ssd -opt 3 -title "ELITE U E"
