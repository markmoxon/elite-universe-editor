BEEBASM?=beebasm
PYTHON?=python

.PHONY:all
all:
	$(BEEBASM) -i universe-editor/main-sources/elite-universe-editor-readme.asm
	$(BEEBASM) -i universe-editor/main-sources/elite-universe-editor-disc.asm -do universe-editor-disks/elite-universe-editor-bbc.ssd -opt 3 -title "ELITE U E"
	./build.sh
