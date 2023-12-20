\ ******************************************************************************
\
\ ELITE UNIVERSE EDITOR (I/O PROCESSOR CODE)
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

 BLACK_BLACK     = %00000000        \ 0, 0          0000, 0000
 BLACK_CYAN      = %00010100        \ 0, 6          0000, 0110
 CYAN_BLACK      = %00101000        \ 6, 0          0110, 0000
 CYAN_CYAN       = %00111100        \ 6, 6          0110, 0110

 YELLOW_CYAN     = %00011110        \ 3, 6          0011, 0110
 YELLOW_MAGENTA  = %00011011        \ 3, 5          0011, 0101

 MAGENTA_MAGENTA = %00110011        \ 5, 5          0101, 0101
 BLACK_MAGENTA   = %00010001        \ 0, 5          0000, 0101
 MAGENTA_BLACK   = %00100010        \ 5, 0          0101, 0000

\ ******************************************************************************
\
\       Name: rowOffsets
\       Type: Variable
\   Category: Universe editor
\    Summary: Screen modifications to change the dashboard
\
\ ------------------------------------------------------------------------------
\
\ This table contains offsets for the modifications on each screen row.
\
\ ******************************************************************************

.rowOffsets

IF _6502SP_VERSION OR _MASTER_VERSION

                        \ &7000

 EQUB &0B               \ Right column of A in AC
 EQUB &0C
 EQUB &0D
 EQUB &0E

 EQUB &15               \ Left column of C in AC

 EQUB &1C               \ Right column of C in AC
 EQUB &1D

 EQUB &FF               \ End row

                        \ &7200

 EQUB &01               \ Left column of A in AI
 EQUB &02
 EQUB &03
 EQUB &04
 EQUB &05

 EQUB &09               \ Right column of A in AI
 EQUB &0A
 EQUB &0B
 EQUB &0C
 EQUB &0D

 EQUB &11               \ Left column of I in AI
 EQUB &12
 EQUB &13
 EQUB &14
 EQUB &15

 EQUB &19               \ Right column of I in AI
 EQUB &1B
 EQUB &1C
 EQUB &1D

 EQUB &FF               \ End row

                        \ &7400

 EQUB &01               \ Left column of I in IB
 EQUB &02
 EQUB &03
 EQUB &04
 EQUB &05

 EQUB &09               \ Right column of I in IB
 EQUB &0A
 EQUB &0B
 EQUB &0C
 EQUB &0D

 EQUB &11               \ Left column of B in IB
 EQUB &12
 EQUB &13
 EQUB &14
 EQUB &15

 EQUB &19               \ Right column of B in IB
 EQUB &1A
 EQUB &1B
 EQUB &1C

 EQUB &FF               \ End row

                        \ &7600

 EQUB &11               \ Left column of O in CO
 EQUB &12
 EQUB &13
 EQUB &14

 EQUB &19               \ Right column of O in CO
 EQUB &1A
 EQUB &1B
 EQUB &1C

 EQUB &FF               \ End row

                        \ &7800

 EQUB &09               \ Right column of H in HS
 EQUB &0A
 EQUB &0B
 EQUB &0C
 EQUB &0D

 EQUB &11               \ Left column of S in HS
 EQUB &14

 EQUB &1B               \ Right column of S in HS
 EQUB &1C
 EQUB &1D

 EQUB &FF               \ End row

ELIF _C64_VERSION

                        \ $EF90

 EQUB $23               \ Second row of A in AC
 EQUB $24
 EQUB $25
 EQUB $26

 EQUB $2C               \ Third row of C in AC
 EQUB $2D

 EQUB $FF               \ End row

                        \ $F0D0

 EQUB $29               \ First row of I in AI
 EQUB $2B
 EQUB $2C
 EQUB $2D

 EQUB $FF               \ End row

                        \ $F210

 EQUB $21               \ First row of I in IB
 EQUB $22
 EQUB $23
 EQUB $24
 EQUB $25

 EQUB $29               \ First row of B in IB
 EQUB $2A
 EQUB $2B
 EQUB $2C
 EQUB $2D

 EQUB $FF               \ End row

                        \ $F350

 EQUB $29               \ First row of O in CO
 EQUB $2A
 EQUB $2B
 EQUB $2C

 EQUB $FF               \ End row

                        \ $F490

 EQUB $21               \ First row of H in HS
 EQUB $22
 EQUB $23
 EQUB $24
 EQUB $25

 EQUB $29               \ First row of S in HS
 EQUB $2B
 EQUB $2C
 EQUB $2D

 EQUB $FF               \ End row

ENDIF

\ ******************************************************************************
\
\       Name: editorRows
\       Type: Variable
\   Category: Universe editor
\    Summary: Screen modifications to change to the Universe Editor dashboard
\
\ ------------------------------------------------------------------------------
\
\ This table contains bytes to poke into the offsets to switch the dashboard to
\ the Universe Editor.
\
\ ******************************************************************************

.editorRows

IF _6502SP_VERSION OR _MASTER_VERSION

                        \ &7000

 EQUB BLACK_CYAN        \ Right column of A in AC
 EQUB BLACK_CYAN
 EQUB CYAN_CYAN
 EQUB BLACK_CYAN

 EQUB BLACK_CYAN        \ Left column of C in AC

 EQUB BLACK_BLACK       \ Right column of C in AC
 EQUB BLACK_BLACK

 EQUB &FF               \ End row

                        \ &7200

 EQUB YELLOW_MAGENTA    \ Left column of A in AI
 EQUB YELLOW_MAGENTA
 EQUB YELLOW_MAGENTA
 EQUB YELLOW_MAGENTA
 EQUB YELLOW_MAGENTA

 EQUB MAGENTA_MAGENTA   \ Right column of A in AI
 EQUB BLACK_MAGENTA
 EQUB BLACK_MAGENTA
 EQUB MAGENTA_MAGENTA
 EQUB BLACK_MAGENTA

 EQUB BLACK_MAGENTA     \ Left column of I in AI
 EQUB BLACK_MAGENTA
 EQUB BLACK_MAGENTA
 EQUB BLACK_MAGENTA
 EQUB BLACK_MAGENTA

 EQUB BLACK_BLACK       \ Right column of I in AI
 EQUB BLACK_BLACK
 EQUB BLACK_BLACK
 EQUB BLACK_BLACK

 EQUB &FF               \ End row

                        \ &7400

 EQUB YELLOW_MAGENTA    \ Left column of I in IB
 EQUB YELLOW_MAGENTA
 EQUB YELLOW_MAGENTA
 EQUB YELLOW_MAGENTA
 EQUB YELLOW_MAGENTA

 EQUB BLACK_MAGENTA     \ Right column of I in IB
 EQUB BLACK_MAGENTA
 EQUB BLACK_MAGENTA
 EQUB BLACK_MAGENTA
 EQUB BLACK_MAGENTA

 EQUB MAGENTA_BLACK     \ Left column of B in IB
 EQUB BLACK_MAGENTA
 EQUB MAGENTA_BLACK
 EQUB BLACK_MAGENTA
 EQUB MAGENTA_BLACK

 EQUB BLACK_BLACK       \ Right column of B in IB
 EQUB BLACK_BLACK
 EQUB BLACK_BLACK
 EQUB BLACK_BLACK

 EQUB &FF               \ End row

                        \ &7600

 EQUB BLACK_MAGENTA     \ Left column of O in CO
 EQUB MAGENTA_BLACK
 EQUB MAGENTA_BLACK
 EQUB MAGENTA_BLACK

 EQUB BLACK_BLACK       \ Right column of O in CO
 EQUB MAGENTA_BLACK
 EQUB MAGENTA_BLACK
 EQUB MAGENTA_BLACK

 EQUB &FF               \ End row

                        \ &7800

 EQUB BLACK_MAGENTA     \ Right column of H in HS
 EQUB BLACK_MAGENTA
 EQUB MAGENTA_MAGENTA
 EQUB BLACK_MAGENTA
 EQUB BLACK_MAGENTA

 EQUB BLACK_MAGENTA     \ Left column of S in HS
 EQUB BLACK_BLACK

 EQUB MAGENTA_BLACK     \ Right column of S in HS
 EQUB MAGENTA_BLACK
 EQUB MAGENTA_BLACK

 EQUB &FF               \ End row

ELIF _C64_VERSION

                        \ $EF90

 EQUB $11               \ Second row of A in AC
 EQUB $11
 EQUB $15
 EQUB $11

 EQUB $10               \ Third row of C in AC
 EQUB $10

 EQUB $FF               \ End row

                        \ $F0D0

 EQUB $10               \ First row of I in AI
 EQUB $10
 EQUB $10
 EQUB $10

 EQUB $FF               \ End row

                        \ $F210

 EQUB $11               \ First row of I in IB
 EQUB $11
 EQUB $11
 EQUB $11
 EQUB $11

 EQUB $40               \ First row of B in IB
 EQUB $10
 EQUB $40
 EQUB $10
 EQUB $40

 EQUB $FF               \ End row

                        \ $F350

 EQUB $10               \ First row of O in CO
 EQUB $44
 EQUB $44
 EQUB $44

 EQUB $FF               \ End row

                        \ $F490

 EQUB $11               \ First row of H in HS
 EQUB $11
 EQUB $15
 EQUB $11
 EQUB $11

 EQUB $14               \ First row of S in HS
 EQUB $14
 EQUB $04
 EQUB $14

 EQUB $FF               \ End row

ENDIF

\ ******************************************************************************
\
\       Name: gameRows
\       Type: Variable
\   Category: Universe editor
\    Summary: Screen modifications to change back to the main game dashboard
\
\ ------------------------------------------------------------------------------
\
\ This table contains bytes to poke into the offsets to switch the dashboard
\ back for the main game.
\
\ ******************************************************************************

.gameRows

IF _6502SP_VERSION OR _MASTER_VERSION

                        \ &7000

 EQUB BLACK_BLACK       \ Right column of F in FS
 EQUB CYAN_CYAN
 EQUB BLACK_BLACK
 EQUB BLACK_BLACK

 EQUB BLACK_BLACK       \ Left column of F in FS

 EQUB CYAN_BLACK        \ Right column of F in FS
 EQUB CYAN_BLACK

 EQUB &FF               \ End row

                        \ &7200

 EQUB YELLOW_CYAN       \ Left column of A in AS
 EQUB YELLOW_CYAN
 EQUB YELLOW_CYAN
 EQUB YELLOW_CYAN
 EQUB YELLOW_CYAN

 EQUB CYAN_CYAN         \ Right column of A in AS
 EQUB BLACK_CYAN
 EQUB BLACK_CYAN
 EQUB CYAN_CYAN
 EQUB BLACK_CYAN

 EQUB BLACK_CYAN        \ Left column of S in AS
 EQUB BLACK_CYAN
 EQUB BLACK_CYAN
 EQUB BLACK_BLACK
 EQUB BLACK_CYAN

 EQUB CYAN_BLACK        \ Right column of S in AS
 EQUB CYAN_BLACK
 EQUB CYAN_BLACK
 EQUB CYAN_BLACK

 EQUB &FF               \ End row

                        \ &7400

 EQUB YELLOW_CYAN       \ Left column of F in FU
 EQUB YELLOW_CYAN
 EQUB YELLOW_CYAN
 EQUB YELLOW_CYAN
 EQUB YELLOW_CYAN

 EQUB CYAN_BLACK        \ Right column of F in FU
 EQUB BLACK_BLACK
 EQUB CYAN_BLACK
 EQUB BLACK_BLACK
 EQUB BLACK_BLACK

 EQUB CYAN_BLACK        \ Left column of U in FU
 EQUB CYAN_BLACK
 EQUB CYAN_BLACK
 EQUB CYAN_BLACK
 EQUB BLACK_CYAN

 EQUB CYAN_BLACK        \ Right column of U in FU
 EQUB CYAN_BLACK
 EQUB CYAN_BLACK
 EQUB CYAN_BLACK

 EQUB &FF               \ End row

                        \ &7600

 EQUB MAGENTA_MAGENTA   \ Left column of T in CT
 EQUB BLACK_MAGENTA
 EQUB BLACK_MAGENTA
 EQUB BLACK_MAGENTA

 EQUB MAGENTA_BLACK     \ Right column of T in CT
 EQUB BLACK_BLACK
 EQUB BLACK_BLACK
 EQUB BLACK_BLACK

 EQUB &FF               \ End row

                        \ &7800

 EQUB BLACK_BLACK       \ Right column of L in LT
 EQUB BLACK_BLACK
 EQUB BLACK_BLACK
 EQUB BLACK_BLACK
 EQUB MAGENTA_BLACK

 EQUB MAGENTA_MAGENTA   \ Left column of T in LT
 EQUB BLACK_MAGENTA

 EQUB BLACK_BLACK       \ Right column of T in LT
 EQUB BLACK_BLACK
 EQUB BLACK_BLACK

 EQUB &FF               \ End row

ELIF _C64_VERSION

                        \ $EF90

 EQUB $10               \ Second row of F in FS
 EQUB $15
 EQUB $10
 EQUB $10

 EQUB $14               \ Third row of S in FS
 EQUB $04

 EQUB $FF               \ End row

                        \ $F0D0

 EQUB $14               \ First row of S in AS
 EQUB $14
 EQUB $04
 EQUB $14

 EQUB $FF               \ End row

                        \ $F210

 EQUB $14               \ First row of F in FU
 EQUB $10
 EQUB $14
 EQUB $10
 EQUB $10

 EQUB $44               \ First row of U in FU
 EQUB $44
 EQUB $44
 EQUB $44
 EQUB $10

 EQUB $FF               \ End row

                        \ $F350

 EQUB $54               \ First row of T in CT
 EQUB $10
 EQUB $10
 EQUB $10

 EQUB $FF               \ End row

                        \ $F490

 EQUB $10               \ First row of L in LT
 EQUB $10
 EQUB $10
 EQUB $10
 EQUB $14

 EQUB $54               \ First row of T in LT
 EQUB $10
 EQUB $10
 EQUB $10

 EQUB $FF               \ End row

ENDIF

\ ******************************************************************************
\
\       Name: ModifyDashboard
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Poke a set of bytes into a screen row to modify the dashboard
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   P(1 0)              The starting point in the table of offsets
\
\   R(1 0)              The starting point in the table of pokes
\
\   SC(1 0)             Start address of screen row
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   P(1 0)              The address ofthe next offset
\
\   R(1 0)              The address of the next poke
\
\ ******************************************************************************

.ModifyDashboard

 LDY #0                 \ Set Y to use as an index into the byte tables

.mod1

 LDA (P),Y              \ Set T to the offset within the screen row for this
 STA T                  \ byte

 BMI mod2               \ If this is the last entry, then the offset will be
                        \ &FF, so jump to mod2 to return from the subroutine

 STY K                  \ Store the index in K so we can retrieve it below

 LDA (R),Y              \ Set A to the byte we need to poke into screen memory

 LDY T                  \ Store the byte in screen memory at the offset we
 STA (SC),Y             \ stored in T

 LDY K                  \ Retrieve the index from K

 INY                    \ Increment the index to point to the next entry in the
                        \ table

 BNE mod1               \ Loop back for the next byte (this BNE is effectively a
                        \ JMP as Y is never zero)

.mod2

 INY                    \ Set P(1 0) = P(1 0) + Y + 1
 TYA                    \
 CLC                    \ so P(1 0) points to the next table
 ADC P
 STA P
 BCC mod3
 INC P+1

.mod3

 TYA                    \ Set R(1 0) = R(1 0) + Y + 1
 CLC                    \
 ADC R                  \ so R(1 0) points to the next table
 STA R
 BCC mod4
 INC R+1

.mod4

IF _6502SP_VERSION OR _MASTER_VERSION

 INC SCH                \ Set SC(1 0) = SC(1 0) + 2, to point to the next screen
 INC SCH                \ row

ELIF _C64_VERSION

 LDA SC                 \ Set SC(1 0) = SC(1 0) + $140, to point to the next
 CLC                    \ screen row
 ADC #$40
 STA SC

 LDA SCH
 ADC #$01
 STA SCH

ENDIF

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: EditorDashboard
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Display the editor dashboard
\
\ ******************************************************************************

.EditorDashboard

IF _MASTER_VERSION

 LDA #%00001111         \ Set bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch screen memory into &3000-&7FFF

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION

 LDA #MAGENTA_MAGENTA   \ Fix the incorrect colour in the A of AL (which is a
 STA &7A0C              \ bug in the original release), so we can tell from a
                        \ screenshot if the Universe Editor has been run (as
                        \ we do not revert this fix)

 LDA #0                 \ Set SC(1 0) = &7000
 STA SC
 LDA #&70
 STA SC+1

ELIF _C64_VERSION

 LDA #$90               \ Set SC(1 0) = $EF90
 STA SC
 LDA #$EF
 STA SC+1

ENDIF

 LDA #LO(rowOffsets)    \ Set P(1 0) = rowOffsets
 STA P
 LDA #HI(rowOffsets)
 STA P+1

 LDA #LO(editorRows)    \ Set R(1 0) = editorRows
 STA R
 LDA #HI(editorRows)
 STA R+1

 JSR ModifyDashboard    \ Modify row 0 of the dashboard

 JSR ModifyDashboard    \ Modify row 1 of the dashboard

 JSR ModifyDashboard    \ Modify row 2 of the dashboard

 JSR ModifyDashboard    \ Modify row 3 of the dashboard

 JSR ModifyDashboard    \ Modify row 4 of the dashboard

IF _MASTER_VERSION

 LDA #%00001001         \ Clear bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch main memory back into &3000-&7FFF

ENDIF

IF _C64_VERSION

                        \ The following instructions modify the screen RAM at
                        \ $6400, which defines colour 1 in the upper nibble

 LDA #$37               \ Set dashboard labels to cyan ($3 in the upper nibble)
 STA $66D4
 STA $66D5

 LDA #$47               \ Set dashboard labels to purple ($4 in the upper
 STA $66FC              \ nibble)
 STA $66FD
 STA $6724
 STA $6725
 STA $674C
 STA $674D
 STA $6774
 STA $6775
 STA $679C
 STA $679D

 LDA #0                 \ Zero dashboardActive so the following call overwrites
 STA dashboardActive    \ the existing dashboard

 JSR ShowDashboard      \ Copy the updated dashboard to the screen

ENDIF

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: GameDashboard
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Display the game dashboard
\
\ ******************************************************************************

.GameDashboard

IF _MASTER_VERSION

 LDA #%00001111         \ Set bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch screen memory into &3000-&7FFF

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION

 LDA #0                 \ Set SC(1 0) = &7000
 STA SC
 LDA #&70
 STA SC+1

ELIF _C64_VERSION

 LDA #$90               \ Set SC(1 0) = $EF90
 STA SC
 LDA #$EF
 STA SC+1

ENDIF

 LDA #LO(rowOffsets)    \ Set P(1 0) = rowOffsets
 STA P
 LDA #HI(rowOffsets)
 STA P+1

 LDA #LO(gameRows)      \ Set R(1 0) = gameRows
 STA R
 LDA #HI(gameRows)
 STA R+1

 JSR ModifyDashboard    \ Modify row 0 of the dashboard

 JSR ModifyDashboard    \ Modify row 1 of the dashboard

 JSR ModifyDashboard    \ Modify row 2 of the dashboard

 JSR ModifyDashboard    \ Modify row 3 of the dashboard

 JSR ModifyDashboard    \ Modify row 4 of the dashboard

IF _MASTER_VERSION

 LDA #%00001001         \ Clear bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch main memory back into &3000-&7FFF

ENDIF

IF _C64_VERSION

                        \ The following instructions modify the screen RAM at
                        \ $6400, which defines colour 1 in the upper nibble

 LDA #$17               \ Set dashboard labels back to white
 STA $66D4
 STA $66D5
 STA $66FC
 STA $66FD

 LDA #$37               \ Set dashboard labels back to cyan
 STA $6724
 STA $6725
 STA $674C
 STA $674D
 STA $6774
 STA $6775
 STA $679C
 STA $679D

 LDA #0                 \ Zero dashboardActive so the following call overwrites
 STA dashboardActive    \ the existing dashboard

 JSR ShowDashboard      \ Copy the updated dashboard to the screen

ENDIF

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: TWIST
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Pitch the current ship by a small angle in a positive direction
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   Pitch direction
\
\ ******************************************************************************

IF _MASTER_VERSION OR _C64_VERSION

.TWIST2

 STA RAT2               \ Set the pitch direction in RAT2 to A

 LDX #15                \ Rotate (roofv_x, nosev_x) by a small angle (pitch)
 LDY #9                 \ in the direction given in RAT2
 JSR MVS5

 LDX #17                \ Rotate (roofv_y, nosev_y) by a small angle (pitch)
 LDY #11                \ in the direction given in RAT2
 JSR MVS5

 LDX #19                \ Rotate (roofv_z, nosev_z) by a small angle (pitch)
 LDY #13                \ in the direction given in RAT2 and return from the
 JMP MVS5               \ subroutine using a tail call

ENDIF

\ ******************************************************************************
\
\       Name: STORE
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Copy the ship data block at INWK back to the K% workspace
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   INF                 The ship data block in the K% workspace to copy INWK to
\
\ ******************************************************************************

IF _MASTER_VERSION OR _C64_VERSION

.STORE

 LDY #(NI%-1)           \ Set a counter in Y so we can loop through the NI%
                        \ bytes in the ship data block

.DML2

 LDA INWK,Y             \ Load the Y-th byte of INWK and store it in the Y-th
 STA (INF),Y            \ byte of INF

 DEY                    \ Decrement the loop counter

 BPL DML2               \ Loop back for the next byte, until we have copied the
                        \ last byte from INWK back to INF

 RTS                    \ Return from the subroutine

ENDIF

.endUniverseEditorZ
