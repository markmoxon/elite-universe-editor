BEEBASM?=beebasm
PYTHON?=python

.PHONY:all
all:
	$(BEEBASM) -i 1-source-files/main-sources/elite-universe-editor-readme.asm
	$(BEEBASM) -i 1-source-files/main-sources/elite-universe-editor-disc.asm -do 3-compiled-game-discs/elite-universe-editor-bbc.ssd -opt 3 -title "ELITE U E"
	./build.sh
