REM     ... E L I T E ...
:
REM     ... Version n ...
:
REM Copyright (C) Acornsoft 1986
:
*TAPE
A%=114:X%=1:CALL&FFF4
*DISC
:
IF INKEY(-256)=0 PRINT"This version is not suitable for the Electron"
machine%=0
A%=&EA:X%=0:Y%=&FF:IF USR(&FFF4) AND &FF00 THEN machine%=1
A%=0:X%=1:IF (USR(&FFF4) AND &FF00) DIV 256 = &3 THEN machine%=2
IF machine%=0 THEN PRINT "No 6502 2nd Processor detected.":PRINT "Master 128 hardware not present."
MODE7
VDU 23;8202;0;0;0;
*LOAD SCREEN
A%=INKEY(300)
IF machine%=1 THEN */TubeElt
*/M128Elt
