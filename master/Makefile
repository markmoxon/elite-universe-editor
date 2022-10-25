BEEBASM?=beebasm
PYTHON?=python

variant-master=1
folder-master=/sng47
suffix-master=-sng47
boot-master=-boot M128Elt

.PHONY:encrypt
encrypt:
	echo _VERSION=4 > 1-source-files/main-sources/elite-header.h.asm
	echo _VARIANT=$(variant-master) >> 1-source-files/main-sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=FALSE >> 1-source-files/main-sources/elite-header.h.asm
	echo _MATCH_ORIGINAL_BINARIES=TRUE >> 1-source-files/main-sources/elite-header.h.asm
	$(BEEBASM) -i 1-source-files/main-sources/elite-loader.asm -v > 3-assembled-output/compile.txt
	$(BEEBASM) -i 1-source-files/main-sources/elite-source.asm -v >> 3-assembled-output/compile.txt
	$(BEEBASM) -i 1-source-files/main-sources/elite-data.asm -v >> 3-assembled-output/compile.txt
	$(PYTHON) 2-build-files/elite-checksum.py -rel$(variant-master)
