\ ******************************************************************************
\
\ ELITE UNIVERSE EDITOR DISC IMAGE SCRIPT
\
\ The Universe Editor is an extended version of BBC Micro Elite by Mark Moxon
\
\ The original 6502 Second Processor Elite was written by Ian Bell and David
\ Braben and is copyright Acornsoft 1985
\
\ The original BBC Master Elite was written by Ian Bell and David Braben and is
\ copyright Acornsoft 1986
\
\ The extra code in the Universe Editor is copyright Mark Moxon
\
\ The code on this site is identical to the source discs released on Ian Bell's
\ personal website at http://www.elitehomepage.org/ (it's just been reformatted
\ to be more readable)
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://elite.bbcelite.com/terminology
\
\ The deep dive articles referred to in this commentary can be found at
\ https://elite.bbcelite.com/deep_dives
\
\ ******************************************************************************

 PUTFILE "elite-universe-editor-6502-second-processor/3-assembled-output/ELITE.bin", "TubeElt", &FF1FDC, &FF2085
 PUTFILE "elite-universe-editor-6502-second-processor/3-assembled-output/ELITEa.bin", "I.ELITEa", &FF2000, &FF2000
 PUTFILE "elite-universe-editor-6502-second-processor/3-assembled-output/I.CODE.bin", "I.CODE", &FF2400, &FF2C89
 PUTFILE "elite-universe-editor-6502-second-processor/3-assembled-output/P.CODE.bin", "P.CODE", &000E3C, &00106A

 PUTFILE "elite-universe-editor-bbc-master/3-assembled-output/M128Elt.bin", "M128Elt", &FF0E00, &FF0E43
 PUTFILE "elite-universe-editor-bbc-master/3-assembled-output/BDATA.bin", "BDATA", &000000, &000000
 PUTFILE "elite-universe-editor-bbc-master/3-assembled-output/BCODE.bin", "BCODE", &000000, &000000

 PUTFILE "elite-universe-editor-library/universe-files/U.BOXART1.bin", "U.BOXART1", &000000, &000000
 PUTFILE "elite-universe-editor-library/universe-files/U.BOXART2.bin", "U.BOXART2", &000000, &000000
 PUTFILE "elite-universe-editor-library/universe-files/U.BOXARTC.bin", "U.BOXARTC", &000000, &000000
 PUTFILE "elite-universe-editor-library/universe-files/U.MANUAL.bin", "U.MANUAL", &000000, &000000
 PUTFILE "elite-universe-editor-library/universe-files/U.SHIPID.bin", "U.SHIPID", &000000, &000000
 PUTFILE "elite-universe-editor-library/universe-files/U.SHIPID6.bin", "U.SHIPID6", &000000, &000000
 PUTFILE "elite-universe-editor-library/universe-files/U.SHIPIDC.bin", "U.SHIPIDC", &000000, &000000

 PUTFILE "1-source-files/other-files/$.ELITE.bin", "ELITE", &FF1900, &FF8023
 PUTFILE "2-assembled-output/README.txt", "README", &FFFFFF, &FFFFFF
 PUTFILE "1-source-files/other-files/$.!BOOT.bin", "!BOOT", &FFFFFF, &FFFFFF

 PUTFILE "elite-universe-editor-library/basic-programs/B.CONVERT.bin", "B.CONVERT", &FF0E00, &FF8023
