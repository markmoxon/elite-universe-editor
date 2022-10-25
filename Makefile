BEEBASM?=beebasm
PYTHON?=python

all:
	+$(MAKE) encrypt -C 6502sp
	+$(MAKE) encrypt -C master
	$(BEEBASM) -i source-files/elite-universe-editor-disc.asm $(boot-master) -do elite-universe-editor.ssd -opt 3 -title "ELITE UE"
