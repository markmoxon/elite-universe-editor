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

IF _6502SP_VERSION

\ Key numbers, translated using the values in TRANTABLE

keyA            = &41
keyC            = &52
keyD            = &32
keyE            = &22
keyG            = &53
keyH            = &54
keyK            = &46
keyL            = &56
keyM            = &65
keyN            = &55
keyO            = &36
keyP            = &37
keyQ            = &10
keyR            = &33
keyS            = &51
keyT            = &23
keyW            = &21
keyX            = &42

key1            = &30
key2            = &31
key3            = &11
key4            = &12
key5            = &13
key6            = &34
key7            = &24
key8            = &15
key9            = &26
key0            = &27

keyDown         = &29
keyUp           = &39
keyAt           = &47
keyReturn       = &49
keyDelete       = &59
keyLt           = &66
keyCopy         = &69
keyGt           = &67
keyEscape       = &70

\ Game variables and labels

currentSlot     = XSAV2 \ XSAV2 and YSAV2 are unused in the original game, so we
repeatingKey    = YSAV2 \ can reuse them in the Universe Editor

shiftCtrl       = ECMA  \ ECMA is only used when the E.C.M. is active, so we can
                        \ reuse it in the Universe Editor

ELIF _MASTER_VERSION

\ Key numbers, translated using the values in TRANTABLE

keyA            = &41
keyC            = &43
keyD            = &44
keyE            = &45
keyG            = &47
keyH            = &48
keyK            = &4B
keyL            = &4C
keyM            = &4D
keyN            = &4E
keyO            = &4F
keyP            = &50
keyQ            = &51
keyR            = &52
keyS            = &53
keyT            = &54
keyW            = &57
keyX            = &58

key1            = &31
key2            = &32
key3            = &33
key4            = &34
key5            = &35
key6            = &36
key7            = &37
key8            = &38
key9            = &39
key0            = &30

keyReturn       = &0D
keyEscape       = &1B
keyLt           = &2C
keyGt           = &2E
keyAt           = &40
keyDelete       = &7F
keyCopy         = &8B
keyDown         = &8E
keyUp           = &8F

\ Game variables and labels

currentSlot     = &0000 \ &0000 and &0001 are unused in the original game, so we
repeatingKey    = &0001 \ can reuse them in the Universe Editor

shiftCtrl       = ECMA  \ ECMA is only used when the E.C.M. is active, so we can
                        \ reuse it in the Universe Editor

IF _SNG47

token8          = &A49E \ Token 8 in TKN1 ("{single cap}COMMANDER'S NAME? ")

ELIF _COMPACT

token8          = &A495 \ Token 8 in TKN1 ("{single cap}COMMANDER'S NAME? ")

ENDIF

INCLUDE "../universe-editor/main-sources/elite-universe-editor-macros.asm"

ELIF _C64_VERSION

\ Key numbers, mapped to the key logger table at $8D0C

keyA            = $36
keyC            = $2C
keyD            = $2E
keyE            = $32
keyG            = $26
keyH            = $23
keyK            = $1B
keyL            = $16
keyM            = $1C
keyN            = $19
keyO            = $1A
keyP            = $17
keyQ            = $02
keyR            = $2F
keyS            = $33
keyT            = $2A
keyW            = $37
keyX            = $29

key1            = $08
key2            = $05
key3            = $38
key4            = $35
key5            = $30
key6            = $2D
key7            = $28
key8            = $25
key9            = $20
key0            = $1D

keyEscape       = $01   \ Quit editor = RUN/STOP
keyCopy         = $0D   \ Duplicate ship = CLR/HOME
keyLeftArrow    = $07   \ Switch to charts = "<-"
keyLt           = $11
keyAt           = $12
keyGt           = $14
keyDown         = $39
keyRight        = $3E
keyReturn       = $3F
keyDelete       = $40
keyUp           = $41   \ Mapped to a spare byte on the end of key logger table
keyLeft         = $42   \ Mapped to a spare byte on the end of key logger table

keyC64          = $03   \ Modifier keys
keyCtrl         = $06
keyShiftR       = $0C
keyShiftL       = $31         

f0              = $3C   \ Show front view = f1/f2 key
f1              = $3B   \ Show rear view = f3/f4 key
f2              = $3A   \ Show left view = f5/f7 key
f3              = $3D   \ Show right view = f7/f8 key
f4              = $35   \ Show the long-range chart = "4"

\ Game configuration variables

NI%             = 37
NOSH            = 10
NTY             = 33
MSL             = 1
SST             = 2

VE              = $57

YELLOW2         = %10101010
GREEN2          = %11111111

\ Commodore 64 system variables and routines

VIC_SCREG1      = $D011
VIC_RASTER      = $D012
VIC_ICREG       = $D01A

CIA1_PORTA      = $DC00
CIA1_ICSREG     = $DC0D

SETMSG          = $FF90
SETLFS          = $FFBA
SETNAM          = $FFBD
LOAD            = $FFD5
SAVE            = $FFD8

\ Game variables and labels

RAND            = $0002
T1              = $0006
SC              = $0007
SCH             = $0008
INWK            = $0009
NEWB            = $002D
P               = $002E
XC              = $0031
YC              = $0033
QQ17            = $0034
K3              = $0035
XX0             = $0057
K4              = $0043
INF             = $0059
V               = $005B
BETA            = $0063
BET1            = $0064
ECMA            = $0067
shiftCtrl       = ECMA  \ ECMA is only used when the E.C.M. is active, so we can
                        \ reuse it in the Universe Editor
ALP1            = $0068
ALP2            = $0069
K               = $0077
KL              = $007D
QQ15            = $007F
DELTA           = $0096
A               = $009A
U               = $0099
Q               = $009A
R               = $009B
S               = $009C
QQ11            = $00A0
MCNT            = $00A3
TYPE            = $00A5
QQ12            = $00A7
RAT2            = $00B1
T               = $00BB
currentSlot     = $00FD \ New variable for Universe Editor
repeatingKey    = $00FE \ New variable for Universe Editor

FRIN            = $0452
MANY            = $045D
JUNK            = $047F
auto            = $0480 \ LDX #(de-auto) in PlayUniverse
CABTMP          = $0483
VIEW            = $0486
GNTMP           = $0488
DLY             = $048B
de              = $048C \ LDX #(de-auto) in PlayUniverse
JSTX            = $048D
JSTY            = $048E
NAME            = $0491
QQ0             = $049A
QQ1             = $049B
QQ21            = $049C
ESCP            = $04C7
NOMSL           = $04CC
FSH             = $04E7
ASH             = $04E8
ENERGY          = $04E9
QQ28            = $04EE
gov             = $04F0
tek             = $04F1
SLSP            = $04F2
QQ2             = $04F4
QQ14            = $04A6
QQ25            = $04ED
QQ3             = $0500
QQ4             = $0501
QQ5             = $0502
LSO             = $0580
ALTIT           = $06F3
token8          = &0E8D \ Token 8 in TKN1 ("{single cap}COMMANDER'S NAME? ")
dashboardActive = $1D04 \ Unique to Commodore 64
DTAPE           = $1D0E

DETOK           = $2390
DTEN            = $23A0
MT19            = $24ED
S1%             = $25A6
NA%             = $25AB
CHK2            = $25FE
CHK             = $25FF
UNIV            = $28A4
NLIN4           = $28DC
MVT3            = $2D69
MVS5            = $2DC5
pr2             = $2E55
BEEP            = $2FEE
DIALS           = $2FF3
PZW2            = $30BB \ STA PZW2-3 in ApplyMods/RevertMods
GINF            = $3E87
ping            = $3E95
DELAY           = $3EA1
DOXC            = $6A25
DOYC            = $6A28
DOVDU19         = $6A2E
TRADEMODE       = $6A2F
TT67            = $6A8E
BAY2            = $6DBF
gnum            = $6DC9
TT111           = $70AB
G1              = $71E8 \ JSR G1-13 in DrawCharts
zZ              = $71F2
jmp             = $7217
ee3             = $7224
pr6             = $7234
prq             = $723C
TT162           = $72C5
TT114           = $7452
SWAPZP          = $784F
DOEXP           = $7866 \ STA DOEXP in ApplyExplosionMod/RevertExplosionMod
PTCLS           = $78D6
SOLAR           = $7AC2
NWSTARS         = $7AF3
WPSHPS          = $7B1A
WS1             = $7B41 \ STA WS1-3 in ApplyMods/RevertMods
SP2             = $7BAB
NWSPS           = $7C24 \ JSR NWSPS+3 in SwapStationSun
NWSHP           = $7C6B
NwS1            = $7D03
WPLS            = $80FF
GETYN           = $81EE
TT17            = $81FB
SetMemory       = $827F
KS4             = $82A4
KILLSHP         = $82F3
RESET           = $83CA
RES2            = $83DF
yu              = $8437 \ STA yu+3 in PlayUniverse
ZINF            = $8447
msblob          = $845C
SAL8            = $846C \ STY SAL8+1 in UpdateDashboard
TT100           = $84ED
TT102           = $86B1 \ JSR TT102+7 in DrawCharts
TT92            = $86D0 \ STA TT92-7 in ApplyMods/RevertMods
NWDAV5          = $872C \ LDA #NWDAV5-TT92+6 in ApplyMods
BR1             = $8882
DFAULT          = $88F0
TITLE           = $8920
CHECK           = $89EB
CHECK2          = $89F9 \ Unique to Commodore 64
JAMESON         = $8A0C
GTL2            = $8A2F \ STA GTL2+1 in ShowDiscMenu/RevertDiscMods
GTNMEW          = $8A38
MT26            = $8A5B
NAMELEN1        = $8BBE
deviceNumber    = $8C0B \ Unique to Commodore 64
U%              = $8C6D
TAS2            = $8C8A
keyLog          = $8D0C \ Unique to Commodore 64, distinct key logger from KL
RDKEY           = $8D53
CTRL            = $8E92
TT217           = $8FEA
t               = $8FEC
TIDY            = $9105
log             = $9300
LL9             = $9A86
LL74            = $9F35 \ STA LL74+16 in ApplyMods/RevertMods
MV5             = $A434
PLUT            = $A626
LOOK1           = $A6BA
SIGHT           = $A6D4
TT66            = $A72F
NOISE           = $A858
screenSection   = $A8D9 \ Unique to Commodore 64
DOT             = $B09D
ECBLB           = $B0FD
SPBLB           = $B10E
ShowDashboard   = $B301 \ Unique to Commodore 64
SCAN            = $B410
XX21            = $D000
K%              = $F900

INCLUDE "../../universe-editor/main-sources/elite-universe-editor-macros.asm"

ENDIF
