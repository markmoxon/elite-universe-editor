\ ******************************************************************************
\
\ ELITE UNIVERSE EDITOR (PART 1)
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
\       Name: CheckShiftCtrl
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Check for SHIFT and CTRL (or C= and CTRL on the Commodore 64)
\
\ ******************************************************************************

.CheckShiftCtrl

IF _6502SP_VERSION OR _MASTER_VERSION

 STZ shiftCtrl          \ We now test for SHIFT and CTRL and set bit 7 and 6 of
                        \ shiftCtrl accordingly, so zero the byte first

ELIF _C64_VERSION

 LDA #0                 \ We now test for C= and CTRL and set bit 7 and 6 of
 STA shiftCtrl          \ shiftCtrl accordingly, so zero the byte first

ENDIF

IF _6502SP_VERSION OR _C64_VERSION

 JSR CTRL               \ Scan the keyboard to see if CTRL is currently pressed,
                        \ returning a negative value in A if it is

ELIF _MASTER_VERSION

IF _SNG47

 JSR CTRL               \ Scan the keyboard to see if CTRL is currently pressed,
                        \ returning a negative value in A if it is

ELIF _COMPACT

 JSR CTRLmc             \ Scan the keyboard to see if CTRL is currently pressed,
                        \ returning a negative value in A if it is

ENDIF

ENDIF

 BPL P%+5               \ If CTRL is being pressed, set bit 7 of shiftCtrl
 SEC                    \ (which we will shift into bit 6 below)
 ROR shiftCtrl

IF _6502SP_VERSION

 LDX #0                 \ Call DKS4 with X = 0 to check whether the SHIFT key is
 JSR DKS4               \ being pressed

ELIF _MASTER_VERSION

IF _SNG47

 LDA #0                 \ Call DKS5 to check whether the SHIFT key is being
 JSR DKS5               \ pressed

ELIF _COMPACT

 LDA #0                 \ Call DKS4mc to check whether the SHIFT key is being
 JSR DKS4mc             \ pressed

ENDIF

ELIF _C64_VERSION

 LDA keyLog+keyC64      \ Set A to &FF if the C= key is being pressed

ENDIF

 CLC                    \ If SHIFT is being pressed, set the C flag, otherwise
 BPL P%+3               \ clear it
 SEC

 ROR shiftCtrl          \ Shift the C flag into bit 7 of shiftCtrl, moving the
                        \ CTRL bit into bit 6, so we now have SHIFT and CTRL
                        \ captured in bits 7 and 6 of shiftCtrl

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: ConvertFile
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Convert the file format between platforms
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   K                   Ship number to search for (0 for no search and replace)
\
\   K+1                 Ship number to replace with
\
\   K+2                 The delta to apply to the high byte of the ship heap
\                       addresses:
\
\                         * 0 = do not change addresses
\
\                         * &C8 = Add &D000-&0800 to each address (&C800)
\                                 (Save file from Master)
\
\                         * &38 = Add -(&D000-&0800) to each address (&3800)
\                                 (Load file on Master)
\
\                         * $D0 = Add -($FFC0-$D000) to each address ($D040)
\                                 (Save file on Commodore 64)
\
\                         * $2F = Add $FFC0-$D000 to each address ($2FC0)
\                                 (Load file on Commodore 64)
\
\                       Note that the Commodore 64 also adds &C0 to the low byte
\
\   K+3                 Ship number to delete (0 for no deletion)
\
\ ******************************************************************************

IF _MASTER_VERSION OR _C64_VERSION

.ConvertFile

IF _C64_VERSION

 LDX #$C0               \ Set the following, to cater for the Commodore 64:
 BIT K+2                \
 BPL P%+4               \   * If K+2 = $2F, set P = $C0 so we add $2FC0
 LDX #$40               \
 STX P                  \   * If K+2 = $D0, set P = $40 so we add $D040

ENDIF

 LDX #2                 \ Set a counter in X to loop through all the ship slots,
                        \ not including the station

.conv1

 LDA FRIN,X             \ If the slot is empty then we have done them all, so
 BEQ conv5              \ jump to conv5 to move on to updating SLSP

 CMP K+3                \ If the slot entry is not equal to the ship to delete
 BNE conv2              \ in K+3, jump to conv2

                        \ This ship type is not supported in this version, so we
                        \ need to clear the slot, though this will only work if
                        \ the unsupported ship is in the last slot

 LDA #0                 \ Zero the slot in both the file in memory and in the
 STA FRIN,X             \ file we assembled for saving (where the slots are at
 STA K%+&2E4,X          \ K%+&2E4) to delete the unsupported ship

 BEQ conv5              \ Jump to conv5 to move on to updating SLSP, as we have
                        \ just created the last empty slot (this BEQ is
                        \ effectively a JMP as A is always zero)

.conv2

 CMP K                  \ If the slot entry is not equal to the search value in
 BNE conv3              \ K, jump to conv3 to update the heap pointer

 LDA K+1                \ We have a match, so replace the slot entry with the
 STA FRIN,X             \ replace value in K+1 in both the file in memory and in
 STA K%+&2E4,X          \ the file we assembled for saving (where the slots are
                        \ at K%+&2E4) to delete the unsupported ship

.conv3

                        \ We now update the ship heap pointer to point to the
                        \ correct address for the platform we are running on

 TXA                    \ Set Y = X * 2
 ASL A                  \
 TAY                    \ so we can use X as an index into UNIV for this slot

 LDA UNIV,Y             \ Copy the address of the target ship's data block from
 STA V                  \ UNIV(X+1 X) to V(1 0)
 LDA UNIV+1,Y
 STA V+1

IF _MASTER_VERSION

 LDY #34                \ Set A = INWK+34, the high byte of the ship heap
 LDA (V),Y              \ address

 CLC                    \ Apply the delta to the high byte of the ship heap
 ADC K+2                \ address

 STA (V),Y              \ Update the high byte of the ship heap address

ELIF _C64_VERSION

 LDY #33                \ Set A = INWK+33, the low byte of the ship heap
 LDA (V),Y              \ address

 CLC                    \ Add $C0 or $40 to the low byte of the ship heap
 ADC P

 STA (V),Y              \ Update the low byte of the ship heap address

 LDY #34                \ Set A = INWK+34, the high byte of the ship heap
 LDA (V),Y              \ address

 ADC K+2                \ Apply the delta to the high byte of the ship heap
                        \ address

 STA (V),Y              \ Update the high byte of the ship heap address

ENDIF

.conv4

 INX                    \ Increment the counter to move on to the next slot

 CPX #NOSH
 BCC conv1              \ Loop back until all X bytes are searched

.conv5

IF _MASTER_VERSION

 LDA K%+&2E4+21+37      \ Apply the delta to the high byte of SLSP
 CLC              
 ADC K+2
 STA K%+&2E4+21+37
 STA SLSP+1

ELIF _C64_VERSION

 LDA K%+&2E4+21+36      \ Apply the delta + $C0 or $40 to SLSP, starting with
 CLC                    \ the low bytes
 ADC P
 STA K%+&2E4+21+36
 STA SLSP

 LDA K%+&2E4+21+37      \ And then the high bytes
 ADC K+2
 STA K%+&2E4+21+37
 STA SLSP+1

ENDIF

 RTS                    \ Return from the subroutine

ENDIF

\ ******************************************************************************
\
\       Name: RotateShip
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Rotate ship in space
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The first vector to rotate:
\
\                         * If X = 15, rotate roofv_x
\                                      then roofv_y
\                                      then roofv_z
\
\                         * If X = 21, rotate sidev_x
\                                      then sidev_y
\                                      then sidev_z
\
\   Y                   The second vector to rotate:
\
\                         * If Y = 9,  rotate nosev_x
\                                      then nosev_y
\                                      then nosev_z
\
\                         * If Y = 21, rotate sidev_x
\                                      then sidev_y
\                                      then sidev_z
\
\   RAT2                The direction of the pitch or roll to perform, positive
\                       or negative (i.e. the sign of the roll or pitch counter
\                       in bit 7)
\
\ ******************************************************************************

.RotateShip

IF _6502SP_VERSION OR _MASTER_VERSION

 PHX                    \ Store X and Y on the stack
 PHY

ELIF _C64_VERSION

 TXA                    \ Store X and Y on the stack
 PHA
 TYA
 PHA

ENDIF

 JSR MVS5               \ Rotate vector_x by a small angle

 PLA                    \ Retrieve Y from the stack and add 2 to point to the
 TAY                    \ next axis
 INY
 INY

 PLA                    \ Retrieve X from the stack and add 2 to point to the
 TAX                    \ next axis
 INX
 INX

IF _6502SP_VERSION OR _MASTER_VERSION

 PHX                    \ Store X and Y on the stack
 PHY

ELIF _C64_VERSION

 TXA                    \ Store X and Y on the stack
 PHA
 TYA
 PHA

ENDIF

 JSR MVS5               \ Rotate vector_y by a small angle

 PLA                    \ Retrieve Y from the stack and add 2 to point to the
 TAY                    \ next axis
 INY
 INY

 PLA                    \ Retrieve X from the stack and add 2 to point to the
 TAX                    \next axis
 INX
 INX

 JSR MVS5               \ Rotate vector_z by a small angle

 JSR TIDY               \ Call TIDY to tidy up the orientation vectors, to
                        \ prevent the ship from getting elongated and out of
                        \ shape due to the imprecise nature of trigonometry
                        \ in assembly language

 JMP DrawShipStore      \ Store the ship data and draw the ship (but not on the
                        \ scanner) and return from the subroutine using a tail
                        \ call

\ ******************************************************************************
\
\       Name: HideBulbs
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Hide both dashboard bulbs
\
\ ******************************************************************************

.HideBulbs

 BIT showingBulb        \ If bit 6 of showingBulb is set, then we are showing
 BVC hide1              \ the station bulb, so call SPBLB to remove it
 JSR SPBLB

.hide1

 BIT showingBulb        \ If bit 7 of showingBulb is set, then we are showing
 BPL hide2              \ the E.C.M. bulb, so call ECBLB to remove it
 JSR ECBLB

.hide2

IF _6502SP_VERSION OR _MASTER_VERSION

 STZ showingBulb        \ Zero the bulb status byte

ELIF _C64_VERSION

 LDA #0                 \ Zero the bulb status byte
 STA showingBulb

ENDIF

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: ShowBulbs
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Show both dashboard bulbs according to the ship's INWK settings
\
\ ******************************************************************************

.ShowBulbs

 JSR HideBulbs          \ Hide both bulbs

 LDA INWK+36            \ Fetch the "docking" setting from bit 4 of INWK+36
 AND #%00010000         \ (NEWB)

 BEQ bulb1              \ If it is zero, jump to bulb1

 LDA #%01000000         \ Set bit 6 of showingBulb
 STA showingBulb

 JSR SPBLB              \ Show the S bulb

.bulb1

 LDA INWK+32            \ Fetch the E.C.M setting from bit 1 of INWK+32
 AND #%00000001

 BEQ ShowBulbs-1        \ If it is zero, return from the subroutine (as
                        \ ShowBulbs-1 contains an RTS)

 LDA showingBulb        \ Set bit 7 of showingBulb
 ORA #%10000000
 STA showingBulb

 JMP ECBLB              \ Show the E bulb and return from the subroutine using a
                        \ tail call

\ ******************************************************************************
\
\       Name: ResetShip
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Reset the position of the current ship
\
\ ******************************************************************************

.ResetShip

 JSR MV5                \ Draw the current ship on the scanner to remove it

 LDA #26                \ Modify ZINF so it only resets the coordinates and
 STA ZINF+1             \ orientation vectors (and keeps other ship settings)

 JSR ZINF               \ Reset the coordinates and orientation vectors

 LDA #NI%-1             \ Undo the modification
 STA ZINF+1

 JSR InitialiseShip     \ Initialise the ship coordinates

 JMP DrawShipScanner    \ Draw the ship and return from the subroutine using a
                        \ tail call

\ ******************************************************************************
\
\       Name: ChangeValue
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Update one of the ship's details
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   Offset of INWK byte within INWK block
\
\   A                   The minimum allowed value + 1
\
\   Y                   The maximum allowed value + 1
\
\ ******************************************************************************

.ChangeValue

 STA P                  \ Store the minimum value in P

 STY K                  \ Store the maximum value in K

 BIT shiftCtrl          \ If SHIFT is being held, jump to chan1 to reduce the
 BMI chan1              \ value

 INC INWK,X             \ Increment the value at the correct offset

 LDA INWK,X             \ If we didn't go past the maximum value, jump to
 CMP K                  \ StoreValue to store the value
 BNE StoreValue

 DEC INWK,X             \ Otherwise decrement the value again so we don't
                        \ overflow

 JMP chan2              \ Jump to chan2 to beep and return from the subroutine

.chan1

 DEC INWK,X             \ Decrement the value at the correct offset

 LDA INWK,X             \ If we didn't go past the miniumum value, jump to
 CMP P                  \ StoreValue to store the value
 BNE StoreValue

 INC INWK,X             \ Otherwise increment the value again so we don't
                        \ underflow

.chan2

 JMP BEEP               \ Beep to indicate we have reached the maximum and
                        \ return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: StoreValue
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Store an updated ship's details and update the dashboard
\
\ ******************************************************************************

.StoreValue

 JSR STORE              \ Call STORE to copy the ship data block at INWK back to
                        \ the K% workspace at INF

 JMP UpdateDashboard    \ Update the dashboard, returning from the subroutine
                        \ using a tail call

\ ******************************************************************************
\
\       Name: ApplyExplosionMod
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Apply mods for explosions
\
\ ******************************************************************************

.ApplyExplosionMod

 LDA #&4C               \ Modify DOEXP so that it jumps to DrawExplosion instead
 STA DOEXP              \ to draw the cloud but without progressing it
 LDA #LO(DrawExplosion)
 STA DOEXP+1
 LDA #Hi(DrawExplosion)
 STA DOEXP+2

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: RevertExplosionMod
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Reverse mods for explosions
\
\ ******************************************************************************

.RevertExplosionMod

IF _6502SP_VERSION

 LDA #&A5               \ Revert DOEXP to its default behaviour of drawing the
 STA DOEXP              \ cloud
 LDA #&64
 STA DOEXP+1
 LDA #&29
 STA DOEXP+2

ELIF _MASTER_VERSION

 LDA #&A5               \ Revert DOEXP to its default behaviour of drawing the
 STA DOEXP              \ cloud
 LDA #&BB
 STA DOEXP+1
 LDA #&29
 STA DOEXP+2

ELIF _C64_VERSION

 LDA #$A5               \ Revert DOEXP to its default behaviour of drawing the
 STA DOEXP              \ cloud
 LDA #$28
 STA DOEXP+1
 LDA #$29
 STA DOEXP+2

ENDIF

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: ChangeSeeds
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Edit galaxy seeds
\
\ ******************************************************************************

.ChangeSeeds

 LDA #8                 \ Clear the top part of the screen, draw a white border,
 JSR TRADEMODE          \ and set up a printable trading screen with a view type
                        \ in QQ11 of 8 (Status Mode screen)

 LDA #10                \ Move the text cursor to column 10
 JSR DOXC

 LDA #12                \ Print extended token 12 ("GALAXY SEEDS{cr}{cr}")
 JSR PrintToken

 JSR NLIN4              \ Draw a horizontal line at pixel row 19 to box in the
                        \ title, and move the text cursor down one line

 LDY #&FF               \ Set maximum number for gnum to 255
 STY QQ25

IF _6502SP_VERSION OR _MASTER_VERSION

 STZ V                  \ Set seed counter in V to 0

ELIF _C64_VERSION

 LDA #0                 \ Set seed counter in V to 0
 STA V

ENDIF

 LDA #&60               \ Modify gnum so that errors return rather than jumping
 STA BAY2               \ to the inventory screen

.seed1

 JSR TT67               \ Print a newline

 LDY V
 LDX QQ21,Y             \ Get seed Y

 CLC                    \ Print the 8-bit number in X to 3 digits, without a
 JSR pr2                \ decimal point

 JSR prq+3              \ Print a question mark

 JSR TT162              \ Print a space

 JSR gnum               \ Call gnum to get a number from the keyboard

 BEQ seed2              \ If no number was entered, skip the following to leave
                        \ this seed alone

 LDY V                  \ Store the new seed in the current galaxy seeds
 STA QQ21,Y

 STA NA%+11,Y           \ Store the new seed in the last saved commander file

.seed2

 INC V                  \ Next seed

 LDY V                  \ Loop back until all seeds are edited
 CPY #6
 BNE seed1

 LDA #&A9               \ Revert the modification to gnum
 STA BAY2

 STA jmp-3              \ Disable the JSR MESS in zZ

IF _6502SP_VERSION OR _C64_VERSION

 JSR zZ+11              \ Call the zZ routine at the JSR TT111 to change
                        \ galaxy without moving the selected system

ELIF _MASTER_VERSION

 JSR zZ+9               \ Call the zZ routine at the JSR TT111 to change
                        \ galaxy without moving the selected system

ENDIF

 STA jmp-3              \ Re-enable the JSR MESS in zZ

 JSR UpdateChecksum     \ Update the commander checksum to cater for the new
                        \ values

 LDA QQ14               \ Store the current fuel level on the stack
 PHA

 LDA #70                \ Set the fuel level to 7 light years, for the chart
 STA QQ14               \ display

IF _6502SP_VERSION OR _MASTER_VERSION

 STZ KL                 \ Flush the key logger

ELIF _C64_VERSION

 LDA #0                 \ Flush the key logger
 STA KL

ENDIF

 LDA #f4                \ Jump to ForceChart, setting the key that's "pressed"
 JMP ForceChart         \ to red key f4 (so we show the Long-range Chart)

\ ******************************************************************************
\
\       Name: EraseShip
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Erase the current ship from the screen
\
\ ******************************************************************************

.EraseShip

 LDA INWK+31            \ If bit 5 of byte #31 is clear, then the ship is not
 AND #%00100000         \ exploding, so jump to eras1
 BEQ eras1

 JMP DrawExplosion      \ Call DrawExplosion to draw the existing cloud to
                        \ remove it, returning from the subroutine using a tail
                        \ call

.eras1

 JSR MV5                \ Draw the current ship on the scanner to remove it

 LDX TYPE               \ Get the current ship type

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

 LDA NEWB               \ Set bit 7 of the ship to indicate it has docked (so
 ORA #%10000000         \ the call to LL9 removes it from the screen)
 STA NEWB

 JMP LL9                \ Draw the existing ship to erase it and mark it as gone
                        \ and return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: ResetExplosions
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Restart any exploding ships to the point just before they explode
\
\ ******************************************************************************

.ResetExplosions

 LDX #2                 \ Set a counter in X to loop through all the slots,
                        \ starting with the first ship slot

.rexp1

 STX currentSlot        \ Store the counter in currentSlot

 LDY FRIN,X             \ If the slot is empty, jump to rexp3 to return from the
 BEQ rexp3              \ subroutine

 JSR GetShipData        \ Fetch the ship data for this slot

 LDA INWK+31            \ If bit 5 of INWK+31 is clear, then the ship is not
 AND #%00100000         \ exploding, so jump to the next slot
 BEQ rexp2

 LDA INWK+31            \ Reset the explosion by clearing bits 3, 5 and 6 and
 ORA #%10000000         \ setting bit 7 of the ship's INWK+31 byte
 AND #%10010111
 STA INWK+31

 JSR KickstartExplosion \ Kickstart the explosion

.rexp2

 LDX currentSlot        \ Restore the counter from currentSlot

 INX                    \ Decrement the counter

 CPX #NOSH
 BCC rexp1              \ Loop back until all slots are processed

.rexp3

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: KickstartExplosion
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Restart an explosion by working through the first four steps
\
\ ******************************************************************************

.KickstartExplosion

 JSR RevertExplosionMod \ Revert the explosion modification so it implements the
                        \ normal explosion cloud

 JSR DrawShipStore      \ Store the ship data and draw the ship (but not on the
                        \ scanner)

 JSR DrawShip           \ Draw the ship (but not on the scanner, and without
                        \ storing or updating the axes)

 JSR DrawShip           \ Draw the ship (but not on the scanner, and without
                        \ storing or updating the axes)

 JSR DrawShip           \ Draw the ship (but not on the scanner, and without
                        \ storing or updating the axes)

 JMP ApplyExplosionMod  \ Modify the explosion code so it doesn't update the
                        \ explosion, returningh from the subroutine using a tail
                        \ call

\ ******************************************************************************
\
\       Name: SwitchDashboard
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Change the dashboard
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The dashboard to display:
\
\                         * 250 = the Universe Editor dashboard
\
\                         * 251 = the main game dashboard
\
\ ******************************************************************************

IF _6502SP_VERSION

.SwitchDashboard

 LDX #LO(dashboardBuff) \ Set (Y X) to point to the dashboardBuff parameter
 LDY #HI(dashboardBuff) \ block

 JMP OSWORD             \ Send an OSWORD command to the I/O processor to
                        \ draw the dashboard, returning from the subroutine
                        \ using a tail call

ENDIF

\ ******************************************************************************
\
\       Name: YESNO
\       Type: Subroutine
\   Category: Universe editor
\    Summary: Wait until either "Y" or "N" is pressed
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              Set if "Y" was pressed, clear if "N" was pressed
\
\ ******************************************************************************

IF _6502SP_VERSION

.YESNO

 JSR t                  \ Scan the keyboard until a key is pressed, returning
                        \ the ASCII code in A and X

 CMP #'y'               \ If "Y" was pressed, return from the subroutine with
 BEQ gety1              \ the C flag set (as the CMP sets the C flag)

 CMP #'n'               \ If "N" was not pressed, loop back to keep scanning
 BNE YESNO              \ for key presses

 CLC                    \ Clear the C flag

.gety1

 RTS                    \ Return from the subroutine

ENDIF

.endUniverseEditor1
