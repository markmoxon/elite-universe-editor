\ ******************************************************************************
\
\ ELITE UNIVERSE EDITOR README
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

.readme

 EQUB 10, 13
 EQUS "---------------------------------------"
 EQUB 10, 13
 EQUS "Elite Universe Editor"
 EQUB 10, 13
 EQUS "by Mark Moxon"
 EQUB 10, 13
 EQUB 10, 13
 EQUS "For the following machines:"
 EQUB 10, 13
 EQUB 10, 13
 EQUS "* BBC Micro with 6502 Second Processor"
 EQUB 10, 13
 EQUS "* BBC Master 128"
 EQUB 10, 13
 EQUS "* BBC Master Turbo"
 EQUB 10, 13
 EQUB 10, 13
 EQUS "Based on the Acornsoft SNG47 release"
 EQUB 10, 13
 EQUS "of Elite by Ian Bell and David Braben"
 EQUB 10, 13
 EQUS "Copyright (c) Acornsoft 1986"
 EQUB 10, 13
 EQUB 10, 13
 EQUS "See www.bbcelite.com for details"
 EQUB 10, 13
 EQUB 10, 13
 EQUS "Build: ", TIME$("%F %T")
 EQUB 10, 13
 EQUS "---------------------------------------"
 EQUB 10, 13

 SAVE "2-assembled-output/README.txt", readme, P%

MACRO CAP x
 EQUB x + 128
ENDMACRO

.readmeC64

 EQUB 13
 EQUS "---------------------------------------"
 EQUB 13
 CAP 'E'
 EQUS "LITE "
 CAP 'U'
 EQUS "NIVERSE "
 CAP 'E'
 EQUS "DITOR"
 EQUB 13
 CAP 'B'
 EQUS "Y "
 CAP 'M'
 EQUS "ARK "
 CAP 'M'
 EQUS "OXON"
 EQUB 13
 EQUB 13
 CAP 'F'
 EQUS "OR THE "
 CAP 'C'
 EQUS "OMMODORE 64"
 EQUB 13
 EQUB 13
 CAP 'B'
 EQUS "ASED ON THE "
 CAP 'F'
 EQUS "IREBIRD RELEASE OF "
 CAP 'E'
 EQUS "LITE"
 EQUB 13
 CAP 'B'
 EQUS "Y "
 CAP 'I'
 EQUS "AN "
 CAP 'B'
 EQUS "ELL AND "
 CAP 'D'
 EQUS "AVID "
 CAP 'B'
 EQUS "RABEN"
 EQUB 13
 CAP 'C'
 EQUS "OPYRIGHT (C) "
 CAP 'D'
 EQUS "."
 CAP 'B'
 EQUS "RABEN AND "
 CAP 'I'
 EQUS "."
 CAP 'B'
 EQUS "ELL 1985"
 EQUB 13
 EQUB 13
 CAP 'S'
 EQUS "EE WWW.BBCELITE.COM FOR DETAILS"
 EQUB 13
 EQUB 13
 CAP 'B'
 EQUS "UILD: ", TIME$("%F %T")
 EQUB 13
 EQUS "---------------------------------------"
 EQUB 13

 SAVE "2-assembled-output/README64.txt", readmeC64, P%
