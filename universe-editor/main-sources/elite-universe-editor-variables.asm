\ ******************************************************************************
\
\ ELITE UNIVERSE EDITOR (CONFIGURATION VARIABLES)
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
\ https://www.bbcelite.com/about_site/terminology_used_in_this_commentary.html
\
\ The deep dive articles referred to in this commentary can be found at
\ https://www.bbcelite.com/deep_dives
\
\ ******************************************************************************

shiftCtrl = ECMA        \ ECMA is only used when the E.C.M. is active, so we can
                        \ reuse it in the Universe Editor

IF _6502SP_VERSION

currentSlot = XSAV2     \ XSAV2 and YSAV2 are unused in the original game, so we
repeatingKey = YSAV2    \ can reuse them in the Universe Editor

keyA = &41
keyC = &52
keyD = &32
keyE = &22
keyG = &53
keyH = &54
keyK = &46
keyL = &56
keyM = &65
keyN = &55
keyO = &36
keyP = &37
keyQ = &10
keyR = &33
keyS = &51
keyT = &23
keyW = &21
keyX = &42

key1 = &30
key2 = &31
key3 = &11
key4 = &12
key5 = &13
key6 = &34
key7 = &24
key8 = &15
key9 = &26
key0 = &27

keyAt = &47
keyCopy = &69
keyDelete = &59
keyDown = &29
keyEscape = &70
keyReturn = &49
keyUp = &39
keyGt = &67
keyLt = &66

ELIF _MASTER_VERSION

currentSlot = &0000     \ &0000 and &0001 are unused in the original game, so we
repeatingKey = &0001    \ can reuse them in the Universe Editor

IF _SNG47

token8 = &A49E

ELIF _COMPACT

token8 = &A495

ENDIF

keyA = &41              \ See TRANTABLE for key values
keyC = &43
keyD = &44
keyE = &45
keyG = &47
keyH = &48
keyK = &4B
keyL = &4C
keyM = &4D
keyN = &4E
keyO = &4F
keyP = &50
keyQ = &51
keyR = &52
keyS = &53
keyT = &54
keyW = &57
keyX = &58

key1 = &31
key2 = &32
key3 = &33
key4 = &34
key5 = &35
key6 = &36
key7 = &37
key8 = &38
key9 = &39
key0 = &30

keyAt = &40
keyCopy = &8B
keyDelete = &7F
keyDown = &8E
keyEscape = &1B
keyReturn = &0D
keyUp = &8F
keyGt = &2E
keyLt = &2C

INCLUDE "../universe-editor/main-sources/elite-universe-editor-macros.asm"

ENDIF
