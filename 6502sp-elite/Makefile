BEEBASM?=beebasm
PYTHON?=python

variant-6502sp=2
folder-6502sp=/sng45
suffix-6502sp=-sng45

.PHONY:encrypt
encrypt:
	echo _VERSION=3 > 1-source-files/main-sources/elite-header.h.asm
	echo _VARIANT=$(variant-6502sp) >> 1-source-files/main-sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=FALSE >> 1-source-files/main-sources/elite-header.h.asm
	echo _MATCH_ORIGINAL_BINARIES=FALSE >> 1-source-files/main-sources/elite-header.h.asm
	$(BEEBASM) -i 1-source-files/main-sources/elite-source.asm -v > 3-assembled-output/compile.txt
	$(BEEBASM) -i 1-source-files/main-sources/elite-bcfs.asm -v >> 3-assembled-output/compile.txt
	$(BEEBASM) -i 1-source-files/main-sources/elite-z.asm -v >> 3-assembled-output/compile.txt
	$(BEEBASM) -i 1-source-files/main-sources/elite-loader1.asm -v >> 3-assembled-output/compile.txt
	$(BEEBASM) -i 1-source-files/main-sources/elite-loader2.asm -v >> 3-assembled-output/compile.txt
	$(PYTHON) 2-build-files/elite-checksum.py -rel$(variant-6502sp)
