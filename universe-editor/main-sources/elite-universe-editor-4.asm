\ ******************************************************************************
\
\ ELITE UNIVERSE EDITOR (PART 4)
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

\ ******************************************************************************
\
\       Name: UpdateChecksum
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Update the checksum in the last saved commander file
\
\ ******************************************************************************

.UpdateChecksum

 LDA QQ0                \ Copy the selected system to the last saved commander
 STA NA%+9              \ file
 LDA QQ1
 STA NA%+10

IF _6502SP_VERSION OR _MASTER_VERSION

 JSR CHECK              \ Call CHECK to calculate the checksum for the last
                        \ saved commander and return it in A

 STA CHK                \ Store the checksum in CHK, which is at the end of the
                        \ last saved commander block

 EOR #&A9               \ Store the checksum EOR &A9 in CHK2, the penultimate
 STA CHK2               \ byte of the last saved commander block

ELIF _C64_VERSION

 JSR CHECK2             \ Call CHECK2 to calculate the second checksum for the
                        \ last saved commander and return it in A

 STA CHK2               \ Store the second checksum in CHK2, the penultimate
                        \ byte of the last saved commander block

 JSR CHECK              \ Call CHECK to calculate the checksum for the last
                        \ saved commander and return it in A

 STA CHK                \ Store the checksum in CHK, which is at the end of the
                        \ last saved commander block

ENDIF

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: ApplyMods
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Apply code modifications for the Universe Editor
\
\ ******************************************************************************

.ApplyMods

IF _6502SP_VERSION

 LDA #250               \ Switch to the Universe Editor dashboard
 JSR SwitchDashboard

 LDA #&24               \ Disable the TRB XX1+31 instruction in part 9 of LL9
 STA LL74+20            \ that disables the laser once it has fired, so that
                        \ lasers remain on-screen while in the editor

ELIF _MASTER_VERSION

 JSR EditorDashboard    \ Switch to the Universe Editor dashboard

 LDA #&24               \ Disable the STA XX1+31 instruction in part 9 of LL9
 STA LL74+16            \ that disables the laser once it has fired, so that
                        \ lasers remain on-screen while in the editor

ELIF _C64_VERSION

 LDA #$60               \ Modify DIALS to skip calling COMPAS at the end
 STA PZW2-3

 JSR EditorDashboard    \ Switch to the Universe Editor dashboard

 JSR DOT                \ Remove the dot from the compass that the title screen
                        \ otherwise leaves in-place

 LDA #$24               \ Disable the STA XX1+31 instruction in part 9 of LL9
 STA LL74+26            \ that disables the laser once it has fired, so that
                        \ lasers remain on-screen while in the editor

ENDIF

 LDA #%11100111         \ Disable the clearing of bit 7 (lasers firing) in
 STA WS1-3              \ WPSHPS

 JSR ApplyExplosionMod  \ Modify the explosion code so it doesn't update the
                        \ explosion

 LDA #NWDAV5-TT92+6     \ Modify BNE TT92 in TT102 to BNE NWDAV5
 STA TT92-7

 LDX #8                 \ The size of the default universe filename

.mods1

 LDA defaultName,X      \ Copy the X-th character of the filename to NAME
 STA NAME,X

 DEX                    \ Decrement the loop counter

 BPL mods1              \ Loop back for the next byte of the universe filename

IF _6502SP_VERSION OR _MASTER_VERSION

 STZ showingBulb        \ Zero the flags that keep track of the bulb indicators

ELIF _C64_VERSION

 LDA #0                 \ Zero the flags that keep track of the bulb indicators
 STA showingBulb

ENDIF

IF _C64_VERSION

 LDA #$20               \ Modify the STX KL: SEC instructions in RDKEY to
 STA RDKEY+72           \ JSR SkipModifierKeys
 LDA #LO(SkipModifierKeys)
 STA RDKEY+73
 LDA #HI(SkipModifierKeys)
 STA RDKEY+74

 LDA #$20               \ Modify the STA CIA1_PORTA instruction in RDKEY to
 STA RDKEY+89           \ JSR ShiftCursorKeys
 LDA #LO(ShiftCursorKeys)
 STA RDKEY+90
 LDA #HI(ShiftCursorKeys)
 STA RDKEY+91

ENDIF

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: RevertMods
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Reverse code modifications for the Universe Editor
\
\ ******************************************************************************

.RevertMods

 JSR HideBulbs          \ Hide both dashboard bulbs

IF _C64_VERSION

 LDA #$86               \ Revert the STX KL: SEC instructions in RDKEY
 STA RDKEY+72
 LDA #KL
 STA RDKEY+73
 LDA #$38
 STA RDKEY+74

 LDA #$8D               \ Revert the STA CIA1_PORTA instruction in RDKEY
 STA RDKEY+89
 LDA #LO(CIA1_PORTA)
 STA RDKEY+90
 LDA #HI(CIA1_PORTA)
 STA RDKEY+91

ENDIF

IF _6502SP_VERSION

 LDA #&14               \ Re-enable the TRB XX1+31 instruction in part 9 of LL9
 STA LL74+20

ELIF _MASTER_VERSION

 LDA #&85               \ Re-enable the STA XX1+31 instruction in part 9 of LL9
 STA LL74+16

ELIF _C64_VERSION

 LDA #$85               \ Re-enable the STA XX1+31 instruction in part 9 of LL9
 STA LL74+26

ENDIF

 LDA #%10100111         \ Re-enable the clearing of bit 7 (lasers firing) in
 STA WS1-3              \ WPSHPS

 JSR RevertExplosionMod \ Revert the explosion modification so it implements the
                        \ normal explosion cloud

 LDA #6                 \ Revert BNE NWDAV5 in TT102 to BNE TT92
 STA TT92-7

 JSR DFAULT             \ Call DFAULT to reset the current commander data
                        \ block to the last saved commander

IF _6502SP_VERSION

 LDA #251               \ Switch to the main game dashboard, returning from the
 JMP SwitchDashboard    \ subroutine using a tail call

ELIF _MASTER_VERSION

 JMP GameDashboard      \ Switch to the main game dashboard, returning from the
                        \ subroutine using a tail call

ELIF _C64_VERSION

 JSR GameDashboard      \ Switch to the main game dashboard

 LDA #$4C               \ Re-enable the call to COMPAS at the end of DIALS
 STA PZW2-3

 RTS                    \ Return from the subroutine

ENDIF

\ ******************************************************************************
\
\       Name: ChangeView
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Process the key press to change the space view to front, rear,
\             left or right
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   Internal key number for f0, f1, f2 or f3
\
\ ******************************************************************************

.ChangeView

 AND #3                 \ If we get here then we have pressed f0-f3, so extract
 TAX                    \ bits 0-1 to set X = 0, 1, 2, 3 for f0, f1, f2, f3

 CPX VIEW               \ If we are not already on this view, jump to
 BNE SetSpaceView       \ SetSpaceView to change view to the new one

 LDA QQ11               \ If this is not already a space view, jump to
 BNE SetSpaceView       \ SetSpaceView to change view to the new one

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: SetSpaceView
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Change the space view to front, rear, left or right space view
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   Space view number:
\
\                         * 0 = front
\                         * 1 = rear
\                         * 2 = left
\                         * 3 = right
\
\ ******************************************************************************

.SetSpaceView

 JSR LOOK1              \ Call LOOK1 to switch to view X

 JSR NWSTARS            \ Set up a new stardust field (not sure why LOOK1
                        \ doesn't draw the stardust - it should)

 LDX currentSlot        \ Fetch the current ship data (as LOOK1 overwrites INWK
 JSR GetShipData        \ and TYPE)

 JSR PrintSlotNumber    \ Print the current slot number at text location (0, 1)

 JSR PrintShipType      \ Print the current ship type on the screen

 JMP DrawShips          \ Draw all ships, returning from the subroutine using a
                        \ tail call

\ ******************************************************************************
\
\       Name: ConfirmChoice
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Display a prompt and ask for confirmation
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              Set if "Y" was pressed, clear if "N" was pressed
\
\
\ ******************************************************************************

.ConfirmChoice

 LDA #10                \ Modify the PrintPrompt routine to print at column 10
 STA promptColumn+1

 LDA #5                 \ Print extended token 5 ("ARE YOU SURE?") as a prompt
 JSR PrintPrompt

 JSR YESNO              \ Call YESNO to wait until either "Y" or "N" is pressed

 PHP                    \ Store the response in the C flag on the stack

 LDA #5                 \ Print extended token 5 ("ARE YOU SURE?") as a prompt
 JSR PrintPrompt        \ to remove it

 LDA #13                \ Restore the PrintPrompt routine to print at column 13
 STA promptColumn+1

 PLP                    \ Restore the response from the stack

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: QuitEditor
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Quit the universe editor
\
\ ******************************************************************************

.QuitEditor

 JSR ConfirmChoice      \ Print "Are you sure?" at the bottom of the screen and
                        \ wait for a response

 BCS quit1              \ If "Y" was pressed, jump to quit1 to quit

 JMP edit3              \ Rejoin the main loop after the key has been processed

.quit1

 JSR WPSHPS             \ Remove all ships from the scanner

 JSR RevertMods         \ Revert the mods we made when the Universe Editor
                        \ started up

 JMP BR1                \ Quit the scene editor by returning to the start

\ ******************************************************************************
\
\       Name: UpdateSlotNumber
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Set the current slot number and update it on-screen
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   New slot number
\
\ ******************************************************************************

.UpdateSlotNumber

IF _6502SP_VERSION OR _MASTER_VERSION

 PHX                    \ Store the new slot number on the stack

ELIF _C64_VERSION

 TXA                    \ Store the new slot number on the stack
 PHA

ENDIF

 JSR PrintSlotNumber    \ Erase the current slot number from screen

IF _6502SP_VERSION OR _MASTER_VERSION

 PLX                    \ Retrieve the new slot number from the stack

ELIF _C64_VERSION

 PLA                    \ Retrieve the new slot number from the stack
 TAX

ENDIF

 STX currentSlot        \ Set the current slot number to the new slot number

 JMP PrintSlotNumber    \ Print new slot number and return from the subroutine
                        \ using a tail call

\ ******************************************************************************
\
\       Name: PrintPrompt
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Show a prompt on-screen
\
\ ------------------------------------------------------------------------------
\
\ Set up the text cursor and colour for an in-flight message at the bottom of
\ the space view.
\
\ ******************************************************************************

.PrintPrompt

 PHA                    \ Store the token number on the stack

IF _6502SP_VERSION OR _MASTER_VERSION

 STZ DLY                \ Set the delay in DLY to 0, so any new in-flight
                        \ messages will be shown instantly

ELIF _C64_VERSION

 LDA #0                 \ Set the delay in DLY to 0, so any new in-flight
 STA DLY                \ messages will be shown instantly

ENDIF

IF _6502SP_VERSION

 LDA #YELLOW            \ Send a #SETCOL YELLOW command to the I/O processor to
 JSR DOCOL              \ switch to colour 1, which is yellow

ELIF _MASTER_VERSION

 LDA #YELLOW            \ Switch to colour 1, which is yellow
 STA COL

ENDIF

 LDA #%10000000         \ Set bit 7 of QQ17 to switch to Sentence Case
 STA QQ17

.promptColumn

 LDA #13                \ Move the text cursor to column 13
 JSR DOXC

IF _6502SP_VERSION OR _MASTER_VERSION

 LDA #22                \ Move the text cursor to row 22
 JSR DOYC

ELIF _C64_VERSION

 LDA #16                \ Move the text cursor to row 16
 JSR DOYC

ENDIF

 PLA                    \ Print the token, returning from the subroutine using a
 JMP PrintToken         \ tail call

\ ******************************************************************************
\
\       Name: PrintSlotNumber
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Print the current slot number
\
\ ******************************************************************************

.PrintSlotNumber

 LDX currentSlot        \ Print the current slot number at text location (0, 1)
 JMP ee3                \ and return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: NextSlot
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Go to the next slot, wrapping around if required
\
\ ******************************************************************************

.NextSlot

 LDX currentSlot        \ Fetch the current slot number

 INX                    \ Increment to point to the next slot

 LDA FRIN,X             \ If slot X contains a ship, jump to SwitchToSlot to get
 BNE SwitchToSlot       \ the ship's data and return from the subroutine using a
                        \ tail call

 LDX #0                 \ Otherwise wrap round to slot 0, the planet

 BEQ SwitchToSlot       \ Jump to SwitchToSlot to get the planet's data (this
                        \ BEQ is effectively a JMP as X is always 0), returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: PreviousSlot
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Go to the previous slot, wrapping around if required
\
\ ******************************************************************************

.PreviousSlot

 LDX currentSlot        \ Fetch the current slot number

 DEX                    \ Decrement to point to the previous slot

 BPL SwitchToSlot       \ If X is positive, then this is a valid ship slot, so
                        \ jump to SwitchToSlot to get the ship's data

                        \ Otherwise we have gone past slot 0, so we need to find
                        \ the last ship slot

 LDX #1                 \ Start at the first ship slot (slot 1) and work
                        \ forwards until we find an empty slot

.prev1

 INX                    \ Increment the slot number

 CPX #NOSH              \ If we haven't reached the last slot, jump to prev2 to
 BCC prev2              \ skip the following

 LDX #NOSH-1            \ There are no empty ship slots, so set X to the last
 BNE SwitchToSlot       \ slot and jump to SwitchToSlot (this BNE is effectively
                        \ a JMP as X is never 0)

.prev2

 LDA FRIN,X             \ If slot X is populated, loop back to move to the next
 BNE prev1              \ slot

                        \ If we get here then we hae found the first empty slot

 DEX                    \ Decrement the slot number to the populated slot before
                        \ the empty one we just found

                        \ If we get here, we have found the correct slot, so
                        \ fall through into SwitchToSlot to get the ship's data

\ ******************************************************************************
\
\       Name: SwitchToSlot
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Switch to a specific slot, updating the slot number, fetching the
\             ship data and highlighting the ship
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   New slot number
\
\ ******************************************************************************

.SwitchToSlot

 JSR UpdateSlotNumber   \ Store and print the new slot number

 JSR PrintShipType      \ Remove the current ship type from the screen

 LDX currentSlot        \ Get the ship data for the new slot
 JSR GetShipData

 JSR PrintShipType      \ Print the current ship type on the screen

 JMP HighlightShip      \ Highlight the new ship, so we can see which one it is,
                        \ and return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: GetShipData
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Fetch the ship info for a specific ship slot
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   Slot number of ship data to fetch
\
\ Returns:
\
\   X                   X is unchanged
\
\ ******************************************************************************

.GetShipData

 LDA FRIN,X             \ Fetch the contents of this slot into A. If it is 0
 BEQ gets2              \ then this slot is empty, so jump to gets2 to return
                        \ from the subroutine

 STA TYPE               \ Store the ship type in TYPE

 JSR GINF               \ Call GINF to fetch the address of the ship data block
                        \ for the ship in slot X and store it in INF. The data
                        \ block is in the K% workspace, which is where all the
                        \ ship data blocks are stored

                        \ Next we want to copy the ship data block from INF to
                        \ the zero-page workspace at INWK, so we can process it
                        \ more efficiently

 LDY #NI%-1             \ There are NI% bytes in each ship data block (and in
                        \ the INWK workspace, so we set a counter in Y so we can
                        \ loop through them

.gets1

 LDA (INF),Y            \ Load the Y-th byte of INF and store it in the Y-th
 STA INWK,Y             \ byte of INWK

 DEY                    \ Decrement the loop counter

 BPL gets1              \ Loop back for the next byte until we have copied the
                        \ last byte from INF to INWK

 LDA TYPE               \ If the ship type is negative then this indicates a
 BMI gets2              \ planet or sun, so jump down to gets2, as the next bit
                        \ sets up a pointer to the ship blueprint, which doesn't
                        \ apply to planets and suns

 ASL A                  \ Set Y = ship type * 2
 TAY

 LDA XX21-2,Y           \ The ship blueprints at XX21 start with a lookup
 STA XX0                \ table that points to the individual ship blueprints,
                        \ so this fetches the low byte of this particular ship
                        \ type's blueprint and stores it in XX0

 LDA XX21-1,Y           \ Fetch the high byte of this particular ship type's
 STA XX0+1              \ blueprint and store it in XX0+1

.gets2

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: HighlightScanner
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Highlight the current ship on the scanner
\
\ ******************************************************************************

.HighlightScanner

 LDX TYPE               \ If this is the sun or planet, give an error beep and
 BPL P%+5               \ return from the subroutine using a tail call, as they
 JMP MakeErrorBeep      \ don't appear on the scanner

 LDA INWK+31            \ If bit 5 of byte #31 is clear, then the ship is not
 AND #%00100000         \ exploding, so jump to draw2 to skip the following
 BEQ hsca1

 LDA INWK+31            \ Set bit 4 of INWK+31 so the explosion is shown on the
 ORA #%00010000         \ scanner
 STA INWK+31

.hsca1

 LDX #10                \ Move the ship on the scanner up by up to 10 steps

.hsca2

IF _6502SP_VERSION OR _MASTER_VERSION

 PHX                    \ Store the loop counter in X on the stack

ELIF _C64_VERSION

 TXA                    \ Store the loop counter in X on the stack
 PHA

ENDIF

 JSR SCAN               \ Draw the ship on the scanner to remove it

 LDA INWK+4             \ Move the ship up/down by 2, applied to y_hi
 CLC
 ADC #2
 STA INWK+4
 BCC P%+4
 INC INWK+5

 JSR SCAN               \ Redraw the ship on the scanner

 LDY #2                 \ Wait for 2/50 of a second (0.04 seconds)
 JSR DELAY

IF _6502SP_VERSION OR _MASTER_VERSION

 PLX                    \ Retrieve the loop counter in X and decrement it
 DEX

ELIF _C64_VERSION

 PLA                    \ Retrieve the loop counter in X and decrement it
 TAX
 DEX

ENDIF

 BPL hsca2              \ Loop back until we have moved the ship X times

 LDX #10                \ Move the ship on the scanner up by up to 10 steps

.hsca3

IF _6502SP_VERSION OR _MASTER_VERSION

 PHX                    \ Store the loop counter in X on the stack

ELIF _C64_VERSION

 TXA                    \ Store the loop counter in X on the stack
 PHA

ENDIF

 JSR SCAN               \ Draw the ship on the scanner to remove it

 LDA INWK+4             \ Move the ship down/up by 2, applied to y_hi
 SEC
 SBC #2
 STA INWK+4
 BCS P%+4
 DEC INWK+5

 JSR SCAN               \ Draw the ship on the scanner to remove it

 LDY #2                 \ Wait for 2/50 of a second (0.04 seconds)
 JSR DELAY

IF _6502SP_VERSION OR _MASTER_VERSION

 PLX                    \ Retrieve the loop counter in X and decrement it
 DEX

ELIF _C64_VERSION

 PLA                    \ Retrieve the loop counter in X and decrement it
 TAX
 DEX

ENDIF

 BPL hsca3              \ Loop back until we have moved the ship X times

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: HighlightShip
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Highlight the current ship on-screen
\
\ ******************************************************************************

.HighlightShip

 LDX TYPE               \ Get the current ship type

 BMI high2              \ If this is the planet or sun, jump to high2

                        \ If we get here then this is a ship or the station

 LDA INWK+31            \ If bit 5 of byte #31 is set, then the ship is
 AND #%00100000         \ exploding, so jump to high5 to highlight the cloud
 BNE high5

IF _6502SP_VERSION

 LDA shpcol,X           \ Set A to the ship colour for this type, from the X-th
                        \ entry in the shpcol table

 JSR DOCOL              \ Send a #SETCOL command to the I/O processor to switch
                        \ to this colour

ELIF _MASTER_VERSION

 LDA shpcol,X           \ Set A to the ship colour for this type, from the X-th
                        \ entry in the shpcol table

 STA COL                \ Switch to this colour

ENDIF

 JSR high1              \ Repeat the following subroutine twice

 LDX currentSlot        \ Get the ship data for the current slot, as otherwise
 JSR GetShipData        \ we will leave the wrong axes in INWK, and return from
                        \ the subroutine using a tail call

 LDY #5                 \ Wait for 5/50 of a second (0.1 seconds)
 JSR DELAY

.high1

 LDA NEWB               \ Set bit 7 of the ship to indicate it has docked (so
 ORA #%10000000         \ the call to LL9 removes it from the screen)
 STA NEWB

 JSR SCAN               \ Draw the ship on the scanner to remove it

 JSR PLUT               \ Call PLUT to update the geometric axes in INWK to
                        \ match the view (front, rear, left, right)

 JSR LL9                \ Draw the existing ship to erase it

 LDY #5                 \ Wait for 5/50 of a second (0.1 seconds)
 JSR DELAY

 LDX currentSlot        \ Get the ship data for the current slot, as otherwise
 JSR GetShipData        \ we will use the wrong axes in INWK

 JSR SCAN               \ Redraw the ship on the scanner

 JSR PLUT               \ Call PLUT to update the geometric axes in INWK to
                        \ match the view (front, rear, left, right)

 JMP LL9                \ Redraw the existing ship, returning from the
                        \ subroutine using a tail call

.high2

                        \ If we get here then this is the planet or sun

IF _6502SP_VERSION

 LDA #GREEN             \ Send a #SETCOL GREEN command to the I/O processor to
 JSR DOCOL              \ switch to stripe 3-1-3-1, which is cyan/yellow in the
                        \ space view

ELIF _MASTER_VERSION

 LDA #GREEN             \ Switch to stripe 3-1-3-1, which is cyan/yellow in the
 STA COL                \ space view

ENDIF

.high3

 JSR high4              \ Repeat the following subroutine twice

 LDY #5                 \ Wait for 5/50 of a second (0.1 seconds)
 JSR DELAY

.high4

 LDA #48                \ Move the planet or sun far away so it gets erased by
 STA INWK+8             \ the call to LL9

 JSR LL9                \ Redraw the planet or sun, which erases it from the
                        \ screen

 LDY #5                 \ Wait for 5/50 of a second (0.1 seconds)
 JSR DELAY

 LDX currentSlot        \ Get the ship data for the current slot, as otherwise
 JSR GetShipData        \ we will use the wrong axes in INWK

 JSR PLUT               \ Call PLUT to update the geometric axes in INWK to
                        \ match the view (front, rear, left, right)

 JMP LL9                \ Redraw the planet or sun and return from the
                        \ subroutine using a tail call

.high5

 JSR high6              \ Repeat the following subroutine twice

 LDY #5                 \ Wait for 5/50 of a second (0.1 seconds)
 JSR DELAY

.high6

 JSR DrawExplosion      \ Call DrawExplosion to draw the existing cloud to
                        \ remove it

 LDY #5                 \ Wait for 5/50 of a second (0.1 seconds)
 JSR DELAY

 JMP DrawExplosion      \ Call DrawExplosion to draw the existing cloud to
                        \ remove it

\ ******************************************************************************
\
\       Name: PrintToken
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Print an extended recursive token from the UniverseToken table
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The recursive token to be printed, in the range 0-255
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is preserved
\
\   Y                   Y is preserved
\
\   V(1 0)              V(1 0) is preserved
\
\ ******************************************************************************

.PrintToken

 PHA                    \ Store A on the stack, so we can retrieve it later

 TAX                    \ Copy the token number from A into X

 TYA                    \ Store Y on the stack
 PHA

 LDA V                  \ Store V(1 0) on the stack
 PHA
 LDA V+1
 PHA

 JSR MT19               \ Call MT19 to capitalise the next letter (i.e. set
                        \ Sentence Case for this word only)

 LDA #LO(UniverseToken) \ Set V to the low byte of UniverseToken
 STA V

 LDA #HI(UniverseToken) \ Set A to the high byte of UniverseToken

 JMP DTEN               \ Call DTEN to print token number X from the
                        \ UniverseToken table and restore the values of A, Y and
                        \ V(1 0) from the stack, returning from the subroutine
                        \ using a tail call

\ ******************************************************************************
\
\       Name: ShowDiscMenu
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Show the universe disc menu
\
\ ******************************************************************************

.ShowDiscMenu

 JSR WPSHPS             \ Clear the ships from the scanner

IF _6502SP_VERSION

 TSX                    \ Transfer the stack pointer to X and store it in stack,
 STX stack              \ so we can restore it in the break handler

ELIF _MASTER_VERSION

 TSX                    \ Transfer the stack pointer to X and store it in
 STX stackpt            \ stackpt, so we can restore it in the break handler

ENDIF

 LDA #LO(NAME)          \ Change TR1 so it uses the universe name in NAME as the
 STA GTL2+1             \ default when no filename is entered
 LDA #HI(NAME)
 STA GTL2+2

 LDA #&11               \ Change token 8 in TKN1 from "Commander's Name" to
 STA token8             \ "File Name" by changing the first three tokens to:
 LDA #&1E               \
 STA token8+1           \ ECHR 'F'
 LDA #&B2               \ ECHR 'I'
 STA token8+2           \ ETWO 'L', 'E'

IF _6502SP_VERSION

 LDA #'U'               \ Change the directory to U
 STA S1%+3
 STA dirCommand+4
 STA DELI+9

 LDA #&4C               \ Stop MEBRK error handler from returning to the SVE
 STA SVE                \ routine, jump back here instead
 LDA #LO(ReturnToDiscMenu)
 STA SVE+1
 LDA #HI(ReturnToDiscMenu)
 STA SVE+2

 JSR ChangeDirectory    \ Change directory to U

ELIF _MASTER_VERSION

 LDA #'U'               \ Change the directory to U
 STA NA%-2
 STA dirCommand+4

 LDA #LO(ReturnToDiscMenu) \ Stop BRBR error handler from returning to the SVE
 STA DEATH-2               \ routine, jump back here instead
 LDA #HI(ReturnToDiscMenu)
 STA DEATH-1

 JSR ChangeDirectory    \ Change directory to U

ENDIF

\ ******************************************************************************
\
\       Name: ReturnToDiscMenu
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Re-display the universe disc menu
\
\ ******************************************************************************

.ReturnToDiscMenu

                        \ The following is based on the SVE routine for the
                        \ normal disc access menu

IF _6502SP_VERSION

 JSR ZEBC               \ Call ZEBC to zero-fill pages &B and &C

 LDA #LO(MEBRK)         \ Set BRKV to point to the MEBRK routine, disabling
 SEI                    \ interrupts while we make the change and re-enabling
 STA BRKV               \ them once we are done. MEBRK is the BRKV handler for
 LDA #HI(MEBRK)         \ disc access operations, and replaces the standard BRKV
 STA BRKV+1             \ handler in BRBR while disc access operations are
 CLI                    \ happening

ELIF _MASTER_VERSION

 JSR TRADEMODE2         \ Set the palette for trading screens and switch the
                        \ current colour to white

ENDIF

 LDA #1                 \ Print extended token 1, the disc access menu, which
 JSR PrintToken         \ presents these options on the BBC:
                        \
                        \   1. Load Universe
                        \   2. Save Universe {universe name}
                        \   3. Catalogue
                        \   4. Delete A File
                        \   5. Play Universe
                        \   6. Exit
                        \
                        \ or these options on the Commodore 64:
                        \
                        \   1. Load Universe
                        \   2. Save Universe {universe name}
                        \   3. Change to {other media}
                        \   4. Play Universe
                        \   5. Exit

 JSR t                  \ Scan the keyboard until a key is pressed, returning
                        \ the ASCII code in A and X

 CMP #'1'               \ If A < ASCII "1", jump to disc5 to exit as the key
 BCC disc5              \ press doesn't match a menu option

IF _6502SP_VERSION OR _MASTER_VERSION

 CMP #'4'               \ If "4" was not pressed, jump to disc1
 BNE disc1

                        \ Option 4: Delete (BBC)

 JSR DeleteUniverse     \ Delete a file

ELIF _C64_VERSION

 CMP #'3'               \ If "3" was not pressed, jump to disc1
 BNE disc1

                        \ Option 3: Change to {other media} (Commodore 64)

 LDA DTAPE              \ Flip the current device in DTAPE, so it contains:
 EOR #%11111111         \
 STA DTAPE              \   * 0 for tape
                        \   * &FF for disk

ENDIF

 JMP ReturnToDiscMenu   \ Show disc menu

.disc1

IF _6502SP_VERSION OR _MASTER_VERSION

 CMP #'5'               \ If "5" was not pressed, jump to disc2 to skip the
 BNE disc2              \ following

ELIF _C64_VERSION

 CMP #'4'               \ If "4" was not pressed, jump to disc2 to skip the
 BNE disc2              \ following

ENDIF

                        \ Option 5: Play universe (BBC)
                        \ Option 4: Play universe (Commodore 64)

 JMP PlayUniverse       \ Play the current universe file

.disc2

IF _6502SP_VERSION OR _MASTER_VERSION

 BCS disc5              \ If A >= ASCII "5", jump to disc5 to exit as the key
                        \ press is either option 6 (exit), or it doesn't match a
                        \ menu option (as we already checked for "5" above)

 CMP #'2'               \ If A >= ASCII "2" (i.e. save or catalogue), skip to
 BCS disc3              \ disc3

ELIF _C64_VERSION

 BCS disc5              \ If A >= ASCII "4", jump to disc5 to exit as the key
                        \ press is either option 5 (exit), or it doesn't match a
                        \ menu option (as we already checked for "4" above)

 CMP #'2'               \ If A = ASCII "2" (i.e. save), skip to disc4
 BEQ disc4

ENDIF

                        \ Option 1: Load (BBC and Commodore 64)

 JSR GTNMEW             \ If we get here then option 1 (load) was chosen, so
                        \ call GTNMEW to fetch the name of the commander file
                        \ to load (including drive number and directory) into
                        \ INWK

 JSR LoadUniverse       \ Call LoadUniverse to load the commander file

 JMP disc5              \ Jump to disc5 to return from the subroutine

IF _6502SP_VERSION OR _MASTER_VERSION

.disc3

 BEQ disc4              \ We get here following the CMP #'2' above, so this
                        \ jumps to disc4 if option 2 (save) was chosen

                        \ Option 3: Catalogue (BBC)

 JSR CATS               \ Call CATS to ask for a drive number, catalogue that
                        \ disc and update the catalogue command at CTLI

 JSR t                  \ Scan the keyboard until a key is pressed, returning
                        \ the ASCII code in A and X

 JMP ReturnToDiscMenu   \ Show the disc menu again

ENDIF

.disc4

                        \ Option 2: Save (BBC and Commodore 64)

 JSR SaveUniverse       \ Save the universe file

 JMP ReturnToDiscMenu   \ Show the disc menu again

.disc5

                        \ Option 6: Exit (BBC)
                        \ Option 5: Exit (Commodore 64)

 JSR RevertDiscMods     \ Reverse all the modifications we did above

 LDX #0                 \ Draw the front view, returning from the subroutine
 STX VIEW               \ using a tail call
 JMP SetSpaceView

\ ******************************************************************************
\
\       Name: RevertDiscMods
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Reverse the code modifications we added for the disc access menu
\
\ ******************************************************************************

.RevertDiscMods

IF _6502SP_VERSION

 LDA #'E'               \ Change the directory back to E
 STA S1%+3
 STA dirCommand+4
 STA DELI+9

 JSR ChangeDirectory    \ Change directory to E

ELIF _MASTER_VERSION

 LDA #'E'               \ Change the directory back to E
 STA NA%-2
 STA dirCommand+4

 JSR ChangeDirectory    \ Change directory to E

ENDIF

 LDA #&CD               \ Revert token 8 in TKN1 to "Commander's Name" by
 STA token8             \ changing the first three tokens back to:
 LDA #&70               \
 STA token8+1           \ ETOK 154
 LDA #&04               \ ECHR '`'
 STA token8+2           \ ECHR 'S'

 LDA #LO(NA%)           \ Revert TR1 so it uses the commander name in NA% as the
 STA GTL2+1             \ default when no filename is entered
 LDA #HI(NA%)
 STA GTL2+2

IF _6502SP_VERSION

 LDA #&20               \ Return MEBRK error handler to its default state
 SEI
 STA SVE
 LDA #LO(ZEBC)
 STA SVE+1
 LDA #HI(ZEBC)
 STA SVE+2
 CLI

 JMP BRKBK              \ Jump to BRKBK to set BRKV back to the standard BRKV
                        \ handler for the game, and return from the subroutine
                        \ using a tail call

ELIF _MASTER_VERSION

 LDA #LO(SVE)           \ Return BRBR error handler to default state
 STA DEATH-2
 LDA #HI(SVE)
 STA DEATH-1

 RTS                    \ Return from the subroutine

ELIF _C64_VERSION

 RTS                    \ Return from the subroutine

ENDIF

\ ******************************************************************************
\
\       Name: LoadUniverse
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Load a universe file
\
\ ******************************************************************************

.LoadUniverse

IF _6502SP_VERSION

 JSR ZEBC               \ Call ZEBC to zero-fill pages &B and &C

 LDY #HI(K%-2)          \ Set up an OSFILE block at &0C00, containing:
 STY &0C03              \
 LDY #LO(K%-2)          \ Load address = K%-2 in &0C02 to &0C05
 STY &0C02              \
 LDY #&03               \ Length of file = &0321 in &0C0A to &0C0D
 STY &0C0B
 LDY #&21
 STY &0C0A

ELIF _MASTER_VERSION

 JSR SetFilename        \ Copy the filename to the load and save commands

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION

 LDA #&FF               \ Call SaveLoadFile with A = &FF to load the universe
 JSR SaveLoadFile       \ file to address K%

 BCS load1              \ If the C flag is set then an invalid drive number was
                        \ entered during the call to SaveLoadFile and the file
                        \ wasn't loaded, so jump to load1 to skip the following
                        \ and return from the subroutine

ELIF _C64_VERSION

 JSR LoadUniverseC64    \ Load the universe file

 BCS load1              \ If there was a loading error, skip the following

ENDIF

 JSR StoreName          \ Transfer the universe filename from INWK to NAME, to
                        \ set it as the current filename

                        \ We now split up the file, by copying the data after
                        \ the end of the K% block into FRIN, MANY and JUNK

 LDA #HI(K%+&2E4)       \ Copy NOSH+1 bytes from K%+&2E4 to FRIN
 STA P+1
 LDA #LO(K%+&2E4)
 STA P
 LDA #HI(FRIN)
 STA Q+1
 LDA #LO(FRIN)
 STA Q
 LDY #NOSH+1
 JSR CopyBlock

IF _6502SP_VERSION OR _MASTER_VERSION

 STZ FRIN+NOSH          \ Zero the slot terminator

ELIF _C64_VERSION

 LDA #0                 \ Zero the slot terminator
 STA FRIN+NOSH

ENDIF

 LDA #HI(K%+&2E4+21)    \ Copy NTY + 1 bytes from K%+&2E4+21 to MANY
 STA P+1
 LDA #LO(K%+&2E4+21)    
 STA P
 LDA #HI(MANY)
 STA Q+1
 LDA #LO(MANY)
 STA Q
 LDY #NTY+1
 JSR CopyBlock

 LDA K%+&2E4+21+35      \ Copy 1 byte from K%+&2E4+21+35 to JUNK
 STA JUNK

 LDA K%+&2E4+21+36      \ Copy 2 bytes from K%+&2E4+21+36 to SLSP
 STA SLSP
 LDA K%+&2E4+21+37
 STA SLSP+1

IF _MASTER_VERSION

 JSR ConvertToMaster    \ Convert the loaded file so it works on the Master

ELIF _C64_VERSION

 JSR ConvertToC64       \ Convert the loaded file so it works on the Commodore
                        \ 64

ENDIF

 JSR ResetExplosions    \ Reset any explosions so they restart on loading

.load1

IF _6502SP_VERSION OR _MASTER_VERSION

 STZ currentSlot        \ Switch to slot 0

ELIF _C64_VERSION

 LDA #0                 \ Switch to slot 0
 STA currentSlot

ENDIF

 JMP HideBulbs          \ Hide both dashboard bulbs, returning from the
                        \ subroutine using a tail call

\ ******************************************************************************
\
\       Name: LoadUniverseC64
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Load and convert a universe file for the Commodore 64
\
\ ******************************************************************************

IF _C64_VERSION

.LoadUniverseC64

 JSR OpenFile           \ Open a file for loading, returning the device number
                        \ in X

 LDA #1                 \ Call SETLFS to set the file parameters, with X set to
 LDY #0                 \ the device number from above, and A and Y set to file
 JSR SETLFS             \ number 1 and secondary address 0

 LDX #LO(K%)            \ Set (Y X) to the load address of K%
 LDY #HI(K%)

 LDA #0                 \ Set A = 0 so the call to LOAD loads the file to memory
                        \ (as opposed to verifying)

 JSR LOAD               \ Call LOAD to load the file

 PHP                    \ Store the C flag on the stack

 JSR CloseFile          \ Close the file that was opened by OpenFile

 PLP                    \ Retrieve the C flag from the stack

 BCC loco1              \ If there was no error, jump to loco1 to return from
                        \ the subroutine

 LDA #255               \ Print token 255 ("{cr}{currently selected media}
 JSR DETOK              \ ERROR")

 JSR t                  \ Wait for a key press

 SEC                    \ Set the C flag to indicate a failure

.loco1

 RTS                    \ Return from the subroutine

ENDIF

\ ******************************************************************************
\
\       Name: OpenFile
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Open a file
\
\ ------------------------------------------------------------------------------
\
\ This routine reverses the changes that are implemented in the GETDRV routine,
\ which disables interrupts and pages the kernal ROM and I/O into main memory.
\ GETDRV gets the system ready for file access, and this routine reverses the
\ process.
\
\ It is based on the code in the routine at $8BC0, which is the Commodore 64
\ equivalent of the GETDRV routine in the BBC versions.
\
\ ******************************************************************************

IF _C64_VERSION

.OpenFile

 JSR getzp              \ Call getzp to save the top part of zero page

 LDA #%00000110         \ Set A so we can page the kernal ROM and I/O into main
                        \ memory below

 SEI                    \ Disable interrupts

 JSR SetMemory          \ Page the kernal ROM and I/O into main memory

 LDA #0                 \ Clear bit 0 of the VIC Interrupt Control Register to
 STA VIC_ICREG          \ disable the raster interrupt
 
 CLI

 LDA #%10000001         \ Set bit 0 of the CIA #1 Interrupt Control and Status
 STA CIA1_ICSREG        \ Register to enable interrupts generated by a timer A
                        \ underflow

 LDA #%11000000         \ Set the system error display switch so we display both
 JSR SETMSG             \ error and control messages

 LDA NAMELEN1           \ Set A to the filename length that was set in GTNMEW

 LDX #LO(INWK+5)        \ Set (Y X) to the address of the file name at INWK,
 LDY #HI(INWK+5)        \ skipping the ":0.E." prefix

 JSR SETNAM             \ Call SETNAM to set the name of file 2

 LDX DTAPE              \ Set X to the correct device number for tape or disk,
 INX                    \ taken from the table at deviceNumber, using the media
 LDA deviceNumber,X     \ setting in DTAPE
 TAX

 RTS                    \ Return from the subroutine

ENDIF

\ ******************************************************************************
\
\       Name: CloseFile
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Close the file that was opened by OpenFile
\
\ ------------------------------------------------------------------------------
\
\ This routine reverses the changes that are implemented in the GETDRV routine,
\ which disables interrupts and pages the kernal ROM and I/O into main memory.
\ GETDRV gets the system ready for file access, and this routine reverses the
\ process.
\
\ It is based on the code in the routine at $8C0D, which is the Commodore 64
\ equivalent of the LOD routine in the BBC versions.
\
\ ******************************************************************************

IF _C64_VERSION

.CloseFile

 LDA #%00000001         \ Clear bit 0 of the CIA #1 Interrupt Control and Status
 STA CIA1_ICSREG        \ Register to disable interrupts generated by a timer A
                        \ underflow

 SEI                    \ Disable interrupts
 
 LDX #0                 \ Set the screen part to the first part of the screen,
 STX screenSection      \ above the mode switch, i.e. part 0, or the space view

 INX                    \ Set bit 0 of the VIC Interrupt Control Register to
 STX VIC_ICREG          \ enable the raster interrupt
 
 LDA VIC_SCREG1         \ Clear bit 7 of the VIC Screen Control Register #1,
 AND #%01111111         \ which contains bit 8 of the number of the raster line
 STA VIC_SCREG1         \ at which we generate the interrupt
 
 LDA #40                \ Set bits 0-7 of the number of the raster line at which
 STA VIC_RASTER         \ we generate the interupt to 40 (we cleared bit 8 in
                        \ the previous instruction)
 
 LDA #%00000100         \ Page the kernal ROM and I/O out of main memory, so we
 JSR SetMemory          \ switch back to a full 64K of RAM
 
 CLI                    \ Re-enable interrupts

 JMP getzp              \ Call getzp to restore the top part of zero page,
                        \ returning from the subroutine using a tail call

ENDIF

\ ******************************************************************************
\
\       Name: SaveUniverse
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Save a universe file
\
\ ******************************************************************************

.SaveUniverse

 JSR GTNMEW             \ If we get here then option 2 (save) was chosen, so
                        \ call GTNMEW to fetch the name of the commander file
                        \ to save (including drive number and directory) into
                        \ INWK

 JSR StoreName          \ Transfer the universe filename from INWK to NAME, to
                        \ set it as the current filename

IF _6502SP_VERSION

 JSR ZEBC               \ Call ZEBC to zero-fill pages &B and &C

 LDY #HI(K%-2)          \ Set up an OSFILE block at &0C00, containing:
 STY &0C0B              \
 LDY #LO(K%-2)          \ Start address for save = K%-2 in &0C0A to &0C0D
 STY &0C0A              \
 LDY #HI(K%+&031F)      \ End address for save = K%+&031F in &0C0E to &0C11
 STY &0C0F
 LDY #LO(K%+&031F)
 STY &0C0E

ELIF _MASTER_VERSION

 JSR SetFilename        \ Copy the filename to the load and save commands

ENDIF

                        \ We now assemble the file in one place, by copying the
                        \ data from FRIN, MANY and JUNK to the space after the
                        \ end of the K% ship data block

 LDA #HI(FRIN)          \ Copy NOSH + 1 bytes from FRIN to K%+&2E4
 STA P+1
 LDA #LO(FRIN)
 STA P
 LDA #HI(K%+&2E4)
 STA Q+1
 LDA #LO(K%+&2E4)
 STA Q
 LDY #NOSH+1
 JSR CopyBlock

 LDA #HI(MANY)          \ Copy NTY + 1 bytes from MANY to K%+&2E4+21 (so we
 STA P+1                \ always save for NOSH = 20, even if NOSH is less)
 LDA #LO(MANY)
 STA P
 LDA #HI(K%+&2E4+21)
 STA Q+1
 LDA #LO(K%+&2E4+21)
 STA Q
 LDY #NTY+1
 JSR CopyBlock

 LDA JUNK               \ Copy 1 byte from JUNK to K%+&2E4+21+35 (so we
 STA K%+&2E4+21+35      \ always save for NOSH = 20 and NTY = 34, even if they
                        \ are less)

 LDA SLSP               \ Copy 2 bytes from SLSP to K%+&2E4+21+36
 STA K%+&2E4+21+36
 LDA SLSP+1
 STA K%+&2E4+21+37

IF _6502SP_VERSION

 LDA #0                 \ Call SaveLoadFile with A = 0 to save the universe
 JMP SaveLoadFile       \ file with the filename we copied to INWK at the start
                        \ of this routine, returning from the subroutine using
                        \ a tail call

ELIF _MASTER_VERSION

 JSR ConvertFromMaster  \ Convert the universe file so it can be saved

 LDA #0                 \ Call SaveLoadFile with A = 0 to save the universe
 JSR SaveLoadFile       \ file with the filename we copied to INWK at the start
                        \ of this routine

 JMP ConvertToMaster    \ Convert the loaded file back again so it works on the
                        \ Master, returning from the subroutine using a tail
                        \ call

ELIF _C64_VERSION

 JSR ConvertFromC64     \ Convert the universe file so it can be saved

 JSR SaveUniverseC64    \ Save the universe file, returning from the subroutine
                        \ using a tail call

 JMP ConvertToC64       \ Convert the loaded file back again so it works on the
                        \ Commodore 64, returning from the subroutine using a
                        \ tail call

ENDIF

\ ******************************************************************************
\
\       Name: SwapWithLogData
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Swap the universe file with the log data, so we can save it (as
\             otherwise the universe file clashes with the kernal ROM)
\
\ ******************************************************************************

IF _C64_VERSION

.SwapWithLogData

 LDA #HI(K%)            \ Set P(1 0) to point to K%
 STA P+1
 LDA #LO(K%)    
 STA P

 LDA #HI(log)           \ Set Q(1 0) to point to the log tables
 STA Q+1
 LDA #LO(log)
 STA Q

 LDY #0                 \ Set Y = 0 to act as a byte counter

.slog1

 LDA (P),Y              \ Swap the Y-th byte of P(1 0) and the Y-th byte of
 TAX                    \ Q(1 0)
 LDA (Q),Y
 STA (P),Y
 TXA
 STA (Q),Y

 INY                    \ Increment the byte counter

 BNE slog1              \ Loop back until we have swapped a whole page of data

 INC P+1                \ Increment P(1 0) and Q(1 0) to point to the next page
 INC Q+1                \ by incrementing their high bytes

 LDA Q+1                \ Loop back to copy the next page, until the high byte
 CMP #HI(log+$0400)     \ of Q(1 0) equals the high byte of log + $0400, at
 BNE slog1              \ which point we have swapped four pages of data

 RTS                    \ Return from the subroutine

ENDIF

\ ******************************************************************************
\
\       Name: SaveUniverseC64
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Save a universe file from the Commodore 64
\
\ ******************************************************************************

IF _C64_VERSION

.SaveUniverseC64

 JSR SwapWithLogData    \ Swap the save file with the log tables

 JSR OpenFile           \ Open a file for loading, returning the device number
                        \ in X

 LDA #0                 \ Call SETLFS to set the file parameters, with X set to
 LDY #0                 \ the device number from above, and A and Y set to file
 JSR SETLFS             \ number 0 and secondary address 0

 LDX #LO(log)           \ Set RAND(1 0) to the save address of log
 STX RAND
 LDY #HI(log)
 STY RAND+1

 LDX #LO(log+$031F)     \ Set (Y X) to the address of the byte after the last
 LDY #HI(log+$031F)     \ byte of the file to save

 LDA #RAND              \ Set A to the address of RAND, where we stored the save
                        \ address

 JSR SAVE               \ Call SAVE to save the file

 PHP                    \ Store the C flag on the stack

 JSR CloseFile          \ Close the file that was opened by OpenFile

 JSR SwapWithLogData    \ Swap the save file with the log tables

 PLP                    \ Retrieve the C flag from the stack

 BCC saco1              \ If there was no error, jump to saco1 to return from
                        \ the subroutine

 LDA #255               \ Print token 255 ("{cr}{currently selected media}
 JSR DETOK              \ ERROR")

 JSR t                  \ Wait for a key press

 SEC                    \ Set the C flag to indicate a failure

.saco1

 RTS                    \ Return from the subroutine

ENDIF

\ ******************************************************************************
\
\       Name: ConvertFromC64
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Convert a Commodore 64 universe file to the save format
\
\ ******************************************************************************

IF _C64_VERSION

.ConvertFromC64

                        \ We are saving a file from the Master version, so we
                        \ need to make the following changes:
                        \
                        \   * Change any Cougars from type 32 to 33
                        \
                        \   * Fix the ship heap addresses in INWK+33 and INWK+34
                        \     by subtracting $FFC0-$D000 (as the ship line heap
                        \     descends from $D000 in the 6502SP version and from
                        \     $FFC0 in the Commodore 64 version)

 LDX #32                \ Set K = 32, to act as the search value
 STX K

 INX                    \ Set K+1 = 33, to act as the replacement value
 STX K+1

 LDX #0                 \ Set K+3 = 0, so we don't delete any ships from the
 STX K+3                \ file

 LDX #$D0               \ Set K+2 = -($FF-$D0) - 1 = $D0, so we move the ship
 STX K+2                \ heap addresses from $FFC0 to $D000

 LDA #$0D               \ If the second slot contains the station, set A = $0D,
 BIT FRIN+1             \ otherwise set A = $00, so that (A 0) is equal to the
 BPL cofr1              \ correct heap address for the slot in the 6502 Second
 LDA #$00               \ Processor version, which is at $0D00 for the station
                        \ or &0000 for the sun

.cofr1

 STA K%+NI%+34          \ Set bytes #33 and #34 to point to the ship line heap
 LDA #0                 \ for the space station or sun, as given in (A 0)
 STA K%+NI%+33

 JMP ConvertFile        \ Convert the Commodore 64 file into the correct format
                        \ for saving, returning from the subroutine using a tail
                        \ call

ENDIF

\ ******************************************************************************
\
\       Name: ConvertFromMaster
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Convert a BBC Master universe file to the save format
\
\ ******************************************************************************

IF _MASTER_VERSION

.ConvertFromMaster

                        \ We are saving a file from the Master version, so we
                        \ need to make the following changes:
                        \
                        \   * Change any Cougars from type 32 to 33
                        \
                        \   * Fix the ship heap addresses in INWK+33 and INWK+34
                        \     by adding &D000-&0800 (as the ship line heap
                        \     descends from &D000 in the 6502SP version and from
                        \     &0800 in the Master version)

 LDX #32                \ Set K = 32, to act as the search value
 STX K

 INX                    \ Set K+1 = 33, to act as the replacement value
 STX K+1

 STZ K+3                \ Set K+3 = 0, so we don't delete any ships from the
                        \ file

 LDX #&C8               \ Set K+2 = &D0-&08 = &C8, so we move the ship heap
 STX K+2                \ addresses from &0800 to &D000

 LDA #&0D               \ If the second slot contains the station, set A = &0D,
 BIT FRIN+1             \ otherwise set A = &00, so that (A 0) is equal to the
 BPL cofr1              \ correct heap address for the slot in the 6502 Second
 LDA #&00               \ Processor version, which is at &0D00 for the station
                        \ or &0000 for the sun

.cofr1

 STA K%+NI%+34          \ Set bytes #33 and #34 to point to the ship line heap
 STZ K%+NI%+33          \ for the space station or sun, as given in (A 0)

 JMP ConvertFile        \ Convert the Master file into the correct format for
                        \ saving, returning from the subroutine using a tail
                        \ call

ENDIF

\ ******************************************************************************
\
\       Name: ConvertToC64
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Convert a loaded universe file so it works on a Commodore 64
\
\ ******************************************************************************

IF _C64_VERSION

.ConvertToC64

                        \ We are loading a file into the Master version, so we
                        \ need to make the following changes:
                        \
                        \   * Delete any Elite logos of type 32
                        \
                        \   * Change any Cougars from type 33 to 32
                        \
                        \   * Fix the ship heap addresses in INWK+33 and INWK+34
                        \     by adding $FFC0-$D000 (as the ship line heap
                        \     descends from $D000 in the 6502SP version and from
                        \     $FFC0 in the Commodore 64 version)

 LDX #33                \ Set K = 33, to act as the search value
 STX K

 DEX                    \ Set K+1 = 32, to act as the replacement value
 STX K+1

 STX K+3                \ Set K+3 = 32, so we delete the Elite logo from the
                        \ 6502SP file (before doing the above search)

 LDX #$2F               \ Set K+2 = $FF-$D0 = &2F, so we move the ship heap
 STX K+2                \ addresses from $D000 to $FFC0 (as ConvertFile also
                        \ adds $C0 in the Commodore 64 version)

 JSR ConvertFile        \ Convert the loaded file so it works on the Commodore
                        \ 64

 LDA #0                 \ Clear the last ship slot, so it can act as a backstop
 STA FRIN+NOSH

 BIT FRIN+1             \ If the second slot contains the station, jump to coto1
 BPL coto1              \ to set the correct line heap address

 LDA #0                 \ This is the sun, so zero bytes #33 and #34 as the line
 STA K%+NI%+33          \ heap value for the sun
 STA K%+NI%+34

 RTS                    \ Return from the subroutine
 
.coto1

 LDA #LO(LSO)           \ Set bytes #33 and #34 to point to LSO for the ship
 STA K%+NI%+33          \ line heap for the space station
 LDA #HI(LSO)
 STA K%+NI%+34

 RTS                    \ Return from the subroutine

ENDIF

\ ******************************************************************************
\
\       Name: ConvertToMaster
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Convert a loaded universe file so it works on a BBC Master
\
\ ******************************************************************************

IF _MASTER_VERSION

.ConvertToMaster

                        \ We are loading a file into the Master version, so we
                        \ need to make the following changes:
                        \
                        \   * Delete any Elite logos of type 32
                        \
                        \   * Change any Cougars from type 33 to 32
                        \
                        \   * Fix the ship heap addresses in INWK+33 and INWK+34
                        \     by subtracting &D000-&0800 (as the ship line heap
                        \     descends from &D000 in the 6502SP version and from
                        \     &0800 in the Master version)

 LDX #33                \ Set K = 33, to act as the search value
 STX K

 DEX                    \ Set K+1 = 32, to act as the replacement value
 STX K+1

 STX K+3                \ Set K+3 = 32, so we delete the Elite logo from the
                        \ 6502SP file (before doing the above search)

 LDX #&38               \ Set K+2 = -(&D0-&08) = &38, so we move the ship heap
 STX K+2                \ addresses from &D000 to &0800

 JSR ConvertFile        \ Convert the loaded file so it works on the Master

 STZ FRIN+NOSH          \ Clear the last ship slot, so it can act as a backstop

 BIT FRIN+1             \ If the second slot contains the station, jump to coto1
 BPL coto1              \ to set the correct line heap address

 STZ K%+NI%+33          \ This is the sun, so zero bytes #33 and #34 as the line
 STZ K%+NI%+34          \ heap value for the sun

 RTS                    \ Return from the subroutine
 
.coto1

 LDA #LO(LSO)           \ Set bytes #33 and #34 to point to LSO for the ship
 STA K%+NI%+33          \ line heap for the space station
 LDA #HI(LSO)
 STA K%+NI%+34

 RTS                    \ Return from the subroutine

ENDIF

\ ******************************************************************************
\
\       Name: PlayUniverse
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Play a universe file
\
\ ******************************************************************************

.PlayUniverse

 JSR ConfirmChoice      \ Print "Are you sure?" at the bottom of the screen and
                        \ wait for a response

 BCS play1              \ If "Y" was pressed, jump to play1 to play the universe

 JMP ReturnToDiscMenu   \ Otherwise return to the disc menu

.play1

 JSR RevertDiscMods     \ Revert the mods we made for the disc access menu

 JSR RevertMods         \ Revert the mods we made when the Universe Editor
                        \ started up

 LDX #1                 \ Force-load the front space view
 STX QQ11
 DEX
 STX VIEW
 JSR LOOK1

                        \ Do the following from DEATH2:

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

IF _6502SP_VERSION OR _MASTER_VERSION

 STZ ECMA               \ Set ECMA to zero so the call to RES2 doesn't shoe the
                        \ "E" bulb (we've been reusing the location of ECMA as
                        \ shiftCtrl to store the CTRL and SHIFT key presses, so
                        \ it could be non-zero at this point)

ELIF _C64_VERSION

 LDA #0                 \ Set ECMA to zero so the call to RES2 doesn't shoe the
 STA ECMA               \ "E" bulb (we've been reusing the location of ECMA as
                        \ shiftCtrl to store the CTRL and SHIFT key presses, so
                        \ it could be non-zero at this point)

ENDIF

 LDA #&60               \ Modify the JSR ZERO in RES2 so it's an RTS, which
 STA yu+3               \ stops RES2 from resetting the ship slots, ship heap
                        \ and dashboard

 JSR RES2               \ Reset a number of flight variables and workspaces, but
                        \ without resetting the ship slots, ship heap or
                        \ dashboard

 LDA #&20               \ Re-enable the JSR ZERO in RES2
 STA yu+3

 LDA #&FF               \ Recharge the forward and aft shields
 STA FSH
 STA ASH

 STA ENERGY             \ Recharge the energy banks

 LDA #128               \ Set the roll and pitch inputs to zero
 STA JSTX
 STA JSTY

                        \ We now do what ZERO would have done, but leaving
                        \ the ship slots alone, and we then call DIALS and ZINF
                        \ as we disabled them above

 LDX #(de-auto)         \ We're going to zero the UP workspace variables from
                        \ auto to de, so set a counter in X for the correct
                        \ number of bytes

 LDA #0                 \ Set A = 0 so we can zero the variables

.play2

 STA auto,X             \ Zero the X-th byte of FRIN to de

 DEX                    \ Decrement the loop counter

 BPL play2              \ Loop back to zero the next variable until we have done
                        \ them all

 JSR DIALS              \ Update the dashboard to show all the above values

 JSR ZINF               \ Call ZINF to reset the INWK ship workspace

                        \ Do the following from BR1 (part 1):

IF _6502SP_VERSION

 JSR ZEKTRAN            \ Reset the key logger buffer that gets returned from
                        \ the I/O processor

 JSR U%                 \ Clear the key logger

ELIF _MASTER_VERSION OR _C64_VERSION

 JSR ZEKTRAN            \ Clear the key logger

ENDIF

 LDA #3                 \ Move the text cursor to column 3
 JSR DOXC

 LDX #3                 \ Set X = 3 for the call to FX200

IF _6502SP_VERSION

 JSR FX200              \ Disable the ESCAPE key and clear memory if the BREAK
                        \ key is pressed (*FX 200,3)

ELIF _MASTER_VERSION

 LDY #0                 \ Call OSBYTE 200 with Y = 0, so the new value is set to
 LDA #200               \ X, and return from the subroutine using a tail call
 JSR OSBYTE

ENDIF

 JSR DFAULT             \ Call DFAULT to reset the current commander data block
                        \ to the last saved commander

                        \ Do the following from BR1 (part 2):

 JSR msblob             \ Reset the dashboard's missile indicators so none of
                        \ them are targeted

 JSR ping               \ Set the target system coordinates (QQ9, QQ10) to the
                        \ current system coordinates (QQ0, QQ1) we just loaded

 JSR TT111              \ Select the system closest to galactic coordinates
                        \ (QQ9, QQ10)

 JSR jmp                \ Set the current system to the selected system

 LDX #5                 \ We now want to copy the seeds for the selected system
                        \ in QQ15 into QQ2, where we store the seeds for the
                        \ current system, so set up a counter in X for copying
                        \ 6 bytes (for three 16-bit seeds)

.play3

 LDA QQ15,X             \ Copy the X-th byte in QQ15 to the X-th byte in QQ2,
 STA QQ2,X

 DEX                    \ Decrement the counter

 BPL play3              \ Loop back to play3 if we still have more bytes to
                        \ copy

 LDA QQ3                \ Set the current system's economy in QQ28 to the
 STA QQ28               \ selected system's economy from QQ3

 LDA QQ5                \ Set the current system's tech level in tek to the
 STA tek                \ selected system's economy from QQ5

 LDA QQ4                \ Set the current system's government in gov to the
 STA gov                \ selected system's government from QQ4

                        \ Do the following from BAY:

 LDA #0                 \ Set QQ12 = 0 (the docked flag) to indicate that we
 STA QQ12               \ are not docked

                        \ We are done setting up, so now we play the game:

 LDA #1                 \ Reset DELTA (speed) to 1, so we go as slowly as
 STA DELTA              \ possible at the start

 JSR DrawShips          \ Redraw all the ships in the current view

 LDX #5                 \ Set a countdown timer, counting down from 5 (we can
 STX ECMA               \ use ECMA, as this is only used when E.C.M. is active)

.play4

 JSR ee3                \ Print the 8-bit number in X at text location (0, 1),
                        \ i.e. print the countdown in the top-left corner

 LDY #44                \ Wait for 44/50 of a second (0.88 seconds)
 JSR DELAY

 LDX ECMA               \ Fetch the counter

 JSR ee3                \ Re-print the 8-bit number in X at text location (0, 1)
                        \ to remove it

 DEC ECMA               \ Decrement the counter

 LDX ECMA               \ Fetch the counter

 BNE play4              \ Loop back to keep counting down until we reach zero

 JMP TT100              \ Jump to TT100 to start the main loop and play the game

\ ******************************************************************************
\
\       Name: UpdateDashboard
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Update the dashboard with the current ship's details
\
\ ******************************************************************************

.UpdateDashboard

 LDA INWK+27            \ Set DELTA to the ship's energy speed
 STA DELTA

 LDA INWK+28            \ Set FSH to the ship's acceleration, adding 128 so it
 CLC                    \ goes from a signed 8-bit number:
 ADC #128               \
 STA FSH                \   0 to 127, -128 to -1
                        \
                        \ to the range:
                        \
                        \   128 to 255, 0 to 127
                        \
                        \ so positive is in the right half of the indicator, and
                        \ negative is in the left half

 LDA INWK+29            \ Set ALP1 and ALP2 to the magnitude and sign of the
 AND #%10000000         \ roll counter (magnitude of ALP1 is in the range 0-31)
 EOR #%10000000
 STA ALP2
 LDA INWK+29
 AND #%01111111 
 LSR A
 LSR A
 STA ALP1

 LDA INWK+30            \ Set BETA and BET1 to the value and magnitude of the
 AND #%10000000         \ pitch counter (BETA is in the range -8 to +8)
 STA T1
 LDA INWK+30
 AND #%01111111
 LSR A
 LSR A
 LSR A
 LSR A
 STA BET1
 ORA T1
 STA BETA

 LDA INWK+35            \ Set ENERGY to the ship's energy level
 STA ENERGY

 LDX #0                 \ Set ASH to the ship's AI setting (on/off) from bit 7
 BIT INWK+32            \ of INWK+32, reusing the aft shields indicator
 BPL P%+4
 LDX #&FF
 STX ASH

 LDX #0                 \ Set QQ14 to the ship's Innocent Bystander setting
 LDA INWK+36            \ (on/off) from bit 5 of INWK+36 (NEWB), reusing the
 AND #%00100000         \ fuel indicator
 BEQ P%+4
 LDX #70
 STX QQ14

 LDX #0                 \ Set CABTMP to the ship's Cop setting (on/off) from
 BIT INWK+36            \ bit 6 of INWK+36 (NEWB), reusing the cabin temperature
 BVC P%+4               \ indicator
 LDX #&FF
 STX CABTMP

 LDX #0                 \ Set GNTMP to the ship's Cop setting (on/off) from
 BIT INWK+32            \ bit 6 of INWK+32, reusing the laser temperature
 BVC P%+4               \ indicator
 LDX #&FF
 STX GNTMP

 LDA INWK+32            \ Set ALTIT to the ship's Aggression Level setting from
 AND #%00111110         \ bits 1-5 of INWK+32, reusing the altitude indicator
 ASL A
 ASL A
 STA ALTIT

IF _C64_VERSION

 LDA QQ11               \ If this is not a space view, then we do not want to
 BEQ P%+3               \ update the dashboard as it is not being shown, so
 RTS                    \ return from the subroutine

ENDIF

 JSR DIALS              \ Update the dashboard

 LDA INWK+31            \ Get the number of missiles
 AND #%00000111

 CMP #5                 \ If there are 0 to 4 missiles, jump to upda1 to show
 BCC upda1              \ them in green

 LDY #YELLOW2           \ Modify the msblob routine so it shows missiles in
 STY SAL8+1             \ yellow

 SEC                    \ Subtract 4 from the missile count, so we just show the
 SBC #4                 \ missiles in positions 5-7

.upda1

 STA NOMSL              \ Set NOMSL to the number of missiles to show

 JSR msblob             \ Update the dashboard's missile indicators in green so
                        \ none of them are targeted

 LDA #GREEN2            \ Reverse the modification to the msblob routine so it
 STA SAL8+1             \ shows missiles in green once again

 JSR ShowBulbs          \ Show the bulbs on the dashboard

.upda2

 JMP UpdateCompass      \ Update the compass, returning from the subroutine
                        \ using a tail call

\ ******************************************************************************
\
\       Name: TogglePlanetType
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Toggle the planet between meridian and crater
\
\ ******************************************************************************

.TogglePlanetType

 LDX #0                 \ Switch to slot 0, which is the planet, and highlight
 JSR SwitchToSlot       \ the existing contents

 LDA TYPE               \ Flip the planet type between 128 and 130
 EOR #%00000010
 STA TYPE
 STA FRIN

 JMP DrawShipScanner    \ Draw the ship and return from the subroutine using a
                        \ tail call

\ ******************************************************************************
\
\       Name: ToggleValue
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Toggle one of the ship's details
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   Offset of INWK byte within INWK block
\
\   A                   Mask containing bits to toggle
\
\ ******************************************************************************

.ToggleValue

 STA P                  \ Store the bit mask in P

 LDA INWK,X             \ Flip the corresponding bits in INWK+X
 EOR P
 STA INWK,X

 JMP StoreValue         \ Store the updated results and update the dashboard,
                        \ returning from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: PrintShipType
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Print the trader/bounty hunter/pirate flag
\
\ ******************************************************************************

.PrintShipType

IF _6502SP_VERSION

 LDA #RED               \ Send a #SETCOL RED command to the I/O processor to
 JSR DOCOL              \ switch to colour 2, which is red in the space view

ELIF _MASTER_VERSION

 LDA #RED               \ Switch to colour 2, which is red
 STA COL

ENDIF

 LDA #1                 \ Move the text cursor to column 24 on row 1
 JSR DOYC
 LDA #24
 JSR DOXC

 LDA INWK+31            \ If bit 5 of byte #31 is clear, then the ship is not
 AND #%00100000         \ exploding, so jump to ptyp1
 BEQ ptyp1

 LDA #9                 \ Print extended token 9 ("CLOUD"), returning from the
 JMP PrintToken         \ subroutine using a tail call
 
.ptyp1

 LDA TYPE               \ If this is not the planet or sun, jump to ptyp3
 BPL ptyp3

 CMP #129               \ If this is the sun, jump to ptyp2
 BEQ ptyp2

 JSR MT19               \ Call MT19 to capitalise the next letter (i.e. set
                        \ Sentence Case for this word only)

 LDA #145               \ Print extended token 145 ("PLANET"), returning from
 JMP DETOK              \ the subroutine using a tail call

.ptyp2

 LDA #11                \ Print extended token 11 ("SUN"), returning from the
 JMP PrintToken         \ subroutine using a tail call

.ptyp3

 CMP #MSL               \ If this is not a missile, jump to ptyp4
 BNE ptyp4

 LDA INWK+32            \ Extract the target number from bits 1-5 into X
 LSR A
 AND #%00011111
 TAX

 LDY #0                 \ Set Y = 0 for the high byte in pr6

 JMP pr6                \ Print the number in (Y X) and return from the
                        \ subroutine using a tail call

.ptyp4

 CMP #SST               \ If this is not the station, jump to ptyp5
 BNE ptyp5

 LDA #10                \ Print extended token 10 ("STATION"), returning from
 JMP PrintToken         \ the subroutine using a tail call

.ptyp5

 LDA #%10000000         \ Set bit 7 of QQ17 to switch to Sentence Case
 STA QQ17

 LDA INWK+36            \ Set A to the NEWB flag in INWK+36

 LSR A                  \ Set the C flag to bit 0 of NEWB (trader)

 BCC ptyp6              \ If bit 0 is clear, jump to ptyp6

                        \ Bit 0 is set, so the ship is a trader

 LDA #2                 \ Print extended token 2 ("TRADER"), returning from the
 JMP PrintToken         \ subroutine using a tail call

.ptyp6

 LSR A                  \ Set the C flag to bit 1 of NEWB (bounty hunter)

 BCC ptyp7              \ If bit 1 is clear, jump to ptyp7

                        \ Bit 1 is set, so the ship is a bounty hunter

 LDA #3                 \ Print extended token 3 ("BOUNTY"), returning from the
 JMP PrintToken         \ subroutine using a tail call

.ptyp7

 LSR A                  \ Set the C flag to bit 3 of NEWB (pirate)
 LSR A

 BCS ptyp8              \ If bit 3 is set, jump to ptyp8 to skip the following

 RTS                    \ Bit 3 is clear, so return from the subroutine without
                        \ printing anything

.ptyp8

 LDA #4                 \ Print extended token 4 ("PIRATE"), returning from the
 JMP PrintToken         \ subroutine using a tail call

\ ******************************************************************************
\
\       Name: ToggleShipType
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Toggle the trader/bounty hunter/pirate flag
\
\ ******************************************************************************

.ToggleShipType

 LDX currentSlot        \ If this is not the planet (slot 0), jump to styp1
 BNE styp1

 JMP TogglePlanetType   \ Jump to TogglePlanetType to toggle the planet type,
                        \ returning from the subroutine using a tail call

.styp1

 CPX #1                 \ If this is not the sun/station, jump to styp2
 BNE styp2

 JMP SwapStationSun     \ Jump to SwapStationSun to toggle the sun/station type,
                        \ returning from the subroutine using a tail call

.styp2

 JSR PrintShipType      \ Remove the current ship type from the screen

 LDA INWK+36            \ Set X and A to the NEWB flag
 TAX

 LSR A                  \ Set the C flag to bit 0 of NEWB (trader)

 BCC styp3              \ If bit 0 is clear, jump to styp3

                        \ Bit 0 is set, so we are already a trader, and we move
                        \ on to bounty hunter

 LDA #%00000010         \ Set bit 1 of A (bounty hunter) and jump to styp6
 BNE styp6

.styp3

 LSR A                  \ Set the C flag to bit 1 of NEWB (bounty hunter)

 BCC styp4              \ If bit 1 is clear, jump to styp4

                        \ Bit 1 is set, so we are already a bounty hunter, and
                        \ we move on to pirate

 LDA #%00001000         \ Set bit 3 of A (pirate) and jump to styp6
 BNE styp6

.styp4

 LSR A                  \ Set the C flag to bit 3 of NEWB (pirate)
 LSR A

 BCC styp5              \ If bit 3 is clear, jump to styp5

                        \ Bit 3 is set, so we are already a pirate, and we move
                        \ on to no status

 LDA #%00000000         \ Clear all bits of T (no status) and jump to styp6
 BEQ styp6

.styp5

 LDA #%00000001         \ Set bit 0 of A (trader)

.styp6

 STA T                  \ Store the bits we want to set in T

 TXA                    \ Set the bits in T in NEWB (which we fetch from X)
 AND #%11110100
 ORA T
 STA INWK+36

 JSR PrintShipType      \ Print the current ship type on the screen

 JMP StoreValue         \ Store the updated results and update the dashboard,
                        \ returning from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: ChangeMissiles
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Update the ship's missile count
\
\ ******************************************************************************

.ChangeMissiles

 LDA INWK+31            \ Extract the missile count from bits 0-2 of INWK+31
 AND #%00000111         \ into X
 TAX

 BIT shiftCtrl          \ If SHIFT is being held, jump to cham1 to reduce the
 BMI cham1              \ value

 INX                    \ Increment the number of missiles

 CPX #%00001000         \ If we didn't go past the maximum value, jump to cham3
 BCC cham3              \ to store the value

 BCS cham2              \ Jump to cham2 to beep (this BCS is effectively a JMP
                        \ as we just passed through a BCC)


.cham1

 DEX                    \ Decrement the number of missiles

 CPX #255               \ If we didn't wrap around to 255, jump to cham3
 BNE cham3              \ to store the value

.cham2

                        \ If we get here then we already reached the minimum or
                        \ maximum value, so we make an error beep and do not
                        \ update the value

 JMP BEEP               \ Beep to indicate we have reached the maximum and
                        \ return from the subroutine using a tail call

.cham3

 STX P                  \ Stick the new missile count into P

 LDA INWK+31            \ Insert the new missile count into bits 0-2 of
 AND #%11111000         \ INWK+31
 ORA P
 STA INWK+31

 JMP StoreValue         \ Store the updated results and update the dashboard,
                        \ returning from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: ChangeAggression
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Update the ship's aggression level
\
\ ******************************************************************************

.ChangeAggression

 LDA INWK+32            \ Extract the aggression level from bits 1-5 of INWK+32
 AND #%00111110         \ into X
 LSR A
 TAX

 BIT shiftCtrl          \ If SHIFT is being held, jump to chag1 to reduce the
 BMI chag1              \ value

 INX                    \ Increment the aggression level

 CPX #%00100000         \ If we didn't reach the maximum value, jump to chag3 
 BCC chag3              \ to store the value

 BCS chag2              \ Jump to chag2 to beep (this BCS is effectively a JMP
                        \ as we just passed through a BCC)

.chag1

 DEX                    \ Decrement the aggression level

 CPX #255               \ If we didn't wrap around to 255, jump to chag3
 BNE chag3              \ to store the value

.chag2

                        \ If we get here then we already reached the minimum or
                        \ maximum value, so we make an error beep and do not
                        \ update the value

 JMP BEEP               \ Beep to indicate we have reached the maximum and
                        \ return from the subroutine using a tail call

.chag3

 TXA                    \ Stick the new aggression level into P, shifted left
 ASL A                  \ by one place so we can OR it into the correct place in
 STA P                  \ INWK+32 (i.e. into bits 1-5)

 LDA INWK+32            \ Insert the new aggression level into bits 1-5 of
 AND #%11000001         \ INWK+32
 ORA P
 STA INWK+32

 JMP StoreValue         \ Store the updated results and update the dashboard,
                        \ returning from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: ChangeCounter
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Update one of the ship's counters
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   Offset of INWK byte within INWK block
\
\ ******************************************************************************

.ChangeCounter

 LDA INWK,X             \ Extract the sign (bit 7) of the counter and store
 AND #%10000000         \ it in T
 STA T

 LDA INWK,X             \ Extract the magnitude of the counter into A
 AND #%01111111
 TAY

 BIT shiftCtrl          \ If SHIFT is being held, jump to chav5 to reduce the
 BMI chav5              \ value

 LDA T                  \ If the counter is negative, we need to decrease the
 BMI chav2              \ magnitude in Y, so jump to the DEY below

.chav1

 INY                    \ Otherwise increment the magnitude in Y

 EQUB &24               \ Skip the next instruction by turning it into &24 &88,
                        \ or BIT &0088, which does nothing apart from affect the
                        \ flags

.chav2

 DEY                    \ Decrement the magnitude in Y

 CPY #128               \ If Y has not yet overflowed, jump to chav3
 BNE chav3

 JMP BEEP               \ Beep to indicate we have reached the maximum and
                        \ return from the subroutine using a tail call

.chav3

 TYA                    \ If the magnitude is still positive, jump to chav4 to
 BPL chav4              \ skip the following

 LDA T                  \ Flip the sign in T, so we go past the middle point
 EOR #%10000000
 STA T

 LDY #0                 \ Set the counter magnitude to 0

.chav4

 TYA                    \ Copy the updated magnitude into A

 ORA T                  \ Put the sign back

 STA INWK,X             \ Updated the counter with the new value

 JMP StoreValue         \ Store the updated results and update the dashboard,
                        \ returning from the subroutine using a tail call

.chav5

 LDA T                  \ If the counter is positive, we need to decrease the
 BPL chav2              \ magnitude in Y, so jump to the DEY above

 BMI chav1              \ Jump up to chav1 to store the new value (this BMI is
                        \ effectively a JMP as we just passed through a BPL)

\ ******************************************************************************
\
\       Name: CopyBlock
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Copy a small block of memory
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   Number of bytes to copy - 1
\
\   P(1 0)              From address
\
\   Q(1 0)              To address
\
\ ******************************************************************************

.CopyBlock

 LDA (P),Y              \ Copy byte X from P(1 0) to Q(1 0)
 STA (Q),Y

 DEY                    \ Decrement the counter

 BPL CopyBlock          \ Loop back until all X bytes are copied

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: defaultName
\       Type: Variable
\   Category: Universe editor
\    Summary: The default name for a universe file
\
\ ******************************************************************************

.defaultName

 EQUS "MYSCENE"
 EQUB 13

\ ******************************************************************************
\
\       Name: dirCommand
\       Type: Variable
\   Category: Universe editor
\    Summary: The OS command string for changing the disc directory to E
\
\ ******************************************************************************

IF _6502SP_VERSION OR _MASTER_VERSION

.dirCommand

 EQUS "DIR E"
 EQUB 13

ENDIF

\ ******************************************************************************
\
\       Name: saveCommand
\       Type: Variable
\   Category: Universe editor
\    Summary: The OS command string for saving a universe file
\
\ ******************************************************************************

IF _MASTER_VERSION

.saveCommand

IF _SNG47

 EQUS "SAVE :1.U.MYSCENE 3FE +321 0 0"
 EQUB 13

ELIF _COMPACT

 EQUS "SAVE MYSCENE 3FE +321 0 0"
 EQUB 13

ENDIF

ENDIF

\ ******************************************************************************
\
\       Name: deleteCommand
\       Type: Variable
\   Category: Universe editor
\    Summary: The OS command string for deleting a universe file
\
\ ******************************************************************************

IF _MASTER_VERSION

.deleteCommand

 EQUS "DELETE :1.U.MYSCENE"
 EQUB 13

ENDIF

\ ******************************************************************************
\
\       Name: UniverseToken
\       Type: Variable
\   Category: Universe editor
\    Summary: Extended recursive token table for the universe editor
\
\ ******************************************************************************

.UniverseToken

 EQUB VE                \ Token 0:      ""
                        \
                        \ Encoded as:   ""

 EJMP 9                 \ Token 1:      "{clear screen}
 EJMP 11                \                {draw box around title}
IF _6502SP_VERSION
 EJMP 30                \                {white}
ENDIF
 EJMP 1                 \                {all caps}
 EJMP 8                 \                {tab 6} UNIVERSE MENU{crlf}
 ECHR ' '               \                {lf}
 ECHR 'U'               \                {sentence case}
 ECHR 'N'               \                1. LOAD UNIVERSE{crlf}
 ECHR 'I'               \                2. SAVE UNIVERSE {commander name}{crlf}
 ETWO 'V', 'E'          \                3. CATALOGUE{crlf}
 ECHR 'R'               \                4. DELETE A FILE{crlf}
 ETWO 'S', 'E'          \                5. PLAY UNIVERSE{crlf}
 ECHR ' '               \                6. EXIT{crlf}
 ECHR 'M'               \               "
 ECHR 'E'
 ETWO 'N', 'U'
IF _C64_VERSION
 ECHR ' '               \ For Commodore 64:
 ECHR '('               \
 EJMP 30                \ Token 1:      "{clear screen}
 ECHR ')'               \                {draw box around title}
                        \                {all caps}
                        \                {tab 6} UNIVERSE MENU ({current media})
                        \                {crlf}
                        \                {lf}
                        \                {sentence case}
                        \                1. LOAD UNIVERSE{crlf}
                        \                2. SAVE UNIVERSE {commander name}{crlf}
                        \                3. CHANGE TO {other media}{crlf}
                        \                4. PLAY UNIVERSE{crlf}
                        \                5. EXIT{crlf}
                        \               "
ENDIF
 ETWO '-', '-'
 EJMP 10
 EJMP 2
 ECHR '1'
 ECHR '.'
 ECHR ' '
 ETWO 'L', 'O'
 ECHR 'A'
 ECHR 'D'
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ECHR 'I'
 ETWO 'V', 'E'
 ECHR 'R'
 ETWO 'S', 'E'
 ETWO '-', '-'
 ECHR '2'
 ECHR '.'
 ECHR ' '
 ECHR 'S'
 ECHR 'A'
 ETWO 'V', 'E'
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ECHR 'I'
 ETWO 'V', 'E'
 ECHR 'R'
 ETWO 'S', 'E'
 ECHR ' '
 EJMP 4
 ETWO '-', '-'
IF _6502SP_VERSION OR _MASTER_VERSION
 ECHR '3'
 ECHR '.'
 ECHR ' '
 ECHR 'C'
 ETWO 'A', 'T'
 ECHR 'A'
 ETWO 'L', 'O'
 ECHR 'G'
 ECHR 'U'
 ECHR 'E'
 ETWO '-', '-'
 ECHR '4'
 ECHR '.'
 ECHR ' '
 ECHR 'D'
 ECHR 'E'
 ECHR 'L'
 ETWO 'E', 'T'
 ECHR 'E'
 ETOK 208
 ECHR 'F'
 ECHR 'I'
 ETWO 'L', 'E'
 ETWO '-', '-'
 ECHR '5'
ELIF _C64_VERSION
 ECHR '3'
 ECHR '.'
 ECHR ' '
 ECHR 'C'
 ECHR 'H'
 ETWO 'A', 'N'
 ETWO 'G', 'E'
 ETOK 201
 EJMP 31
 ETWO '-', '-'
 ECHR '4'
ENDIF
 ECHR '.'
 ECHR ' '
 ECHR 'P'
 ETWO 'L', 'A'
 ECHR 'Y'
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ECHR 'I'
 ETWO 'V', 'E'
 ECHR 'R'
 ETWO 'S', 'E'
 ETWO '-', '-'
IF _6502SP_VERSION OR _MASTER_VERSION
 ECHR '6'
ELIF _C64_VERSION
 ECHR '5'
ENDIF
 ECHR '.'
 ECHR ' '
 ECHR 'E'
 ECHR 'X'
 ETWO 'I', 'T'
 ETWO '-', '-'
 EQUB VE

 ECHR 'T'               \ Token 2:    "TRADER"
 ETWO 'R', 'A'
 ECHR 'D'
 ETWO 'E', 'R'
 EQUB VE

 ECHR 'B'               \ Token 3:    "BOUNTY"
 ETWO 'O', 'U'
 ECHR 'N'
 ECHR 'T'
 ECHR 'Y'
 EQUB VE

 ECHR 'P'               \ Token 4:    "PIRATE"
 ECHR 'I'
 ETWO 'R', 'A'
 ECHR 'T'
 ECHR 'E'
 EQUB VE

 ECHR 'A'               \ Token 5:    "ARE YOU SURE?"
 ETWO 'R', 'E'
 ECHR ' '
 ETOK 179
 ECHR ' '
 ECHR 'S'
 ECHR 'U'
 ETWO 'R', 'E'
 ECHR '?'
 EQUB VE

 ECHR 'U'               \ Token 6:    "UNIVERSE EDITOR"
 ECHR 'N'
 ECHR 'I'
 ETWO 'V', 'E'
 ECHR 'R'
 ETWO 'S', 'E'
 ECHR ' '
 ETWO 'E', 'D'
 ETWO 'I', 'T'
 ETWO 'O', 'R'
 EQUB VE

 ECHR 'S'               \ Token 7:    "SLOT?"
 ETWO 'L', 'O'
 ECHR 'T'
 ECHR '?'
 EQUB VE

 ECHR 'T'               \ Token 8:    "TYPE?"
 ECHR 'Y'
 ECHR 'P'
 ECHR 'E'
 ECHR '?'
 EQUB VE

 ECHR 'C'               \ Token 9:    "CLOUD"
 ETWO 'L', 'O'
 ECHR 'U'
 ECHR 'D'
 EQUB VE

 ETWO 'S', 'T'          \ Token 10:   "STATION"
 ETWO 'A', 'T'
 ECHR 'I'
 ETWO 'O', 'N'
 EQUB VE

 ECHR 'S'               \ Token 11:   "SUN"
 ECHR 'U'
 ECHR 'N'
 EQUB VE

 EJMP 1                 \ Token 12: "{all caps}GALAXY SEEDS{cr}{cr}"
 ECHR 'G'
 ECHR 'A'
 ETWO 'L', 'A'
 ECHR 'X'
 ECHR 'Y'
 ECHR ' '
 ETWO 'S', 'E'
 ETWO 'E', 'D'
 ECHR 'S'
 EJMP 12
 EJMP 12
 EQUB VE

.endUniverseEditor4
