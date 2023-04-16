\ ******************************************************************************
\
\ ELITE UNIVERSE EDITOR (COMMODORE 64)
\
\ The Universe Editor is an extended version of BBC Micro Elite by Mark Moxon
\
\ The original Commodore 64 Elite was written by Ian Bell and David Braben and
\ is copyright D. Braben and I. Bell 1985
\
\ The extra code in the Universe Editor is copyright Mark Moxon
\
\ The code on this site has been reconstructed from a disassembly of the version
\ released on Ian Bell's personal website at http://www.elitehomepage.org/
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
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * editor.bin
\
\ ******************************************************************************

 _6502SP_VERSION = FALSE
 _MASTER_VERSION = FALSE
 _C64_VERSION    = TRUE

 INCLUDE "../../universe-editor/main-sources/elite-universe-editor-variables.asm"

\ ******************************************************************************
\
\ UNIVERSE EDITOR FILE
\
\ ******************************************************************************

 CODE% = &B72D
 LOAD% = &B72D

 ORG CODE%

\ ******************************************************************************
\
\       Name: BR1 (Part 1 of 2)
\       Type: Subroutine
\   Category: Start and end
\    Summary: Show the "Load New Commander (Y/N)?" screen and start the game
\
\ ******************************************************************************

.PATCH1

                        \ We replaced the JSR TITLE in BR1 with JSR PATCH1, so
                        \ we start with this instruction to ensure that it still
                        \ gets done

 JSR TITLE              \ Call TITLE to show the rotating Cobra Mk III and "Load
                        \ New Commander?" prompt

 CMP #f0                \ Did we press f1/f2? If not, skip the following
 BNE P%+5               \ instruction

 JMP UniverseEditor     \ We pressed f1/f2, so jump to UniverseEditor to start
                        \ the universe editor

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: TITLE
\       Type: Subroutine
\   Category: Start and end
\    Summary: Show the "Universe Editor" subtitle
\
\ ******************************************************************************

.PATCH2

 LDA #8                 \ Move the text cursor to column 8
 JSR DOXC

 LDA #6                 \ Print extended token 6 ("UNIVERSE EDITOR")
 JSR PrintToken

 JMP MT19               \ Call MT19 to capitalise the next letter (i.e. set
                        \ Sentence Case for this word only) and return from the
                        \ subroutine using a tail call

\ ******************************************************************************
\
\       Name: BEGIN
\       Type: Subroutine
\   Category: Start and end
\    Summary: Initialise the configuration variables and start the game
\
\ ******************************************************************************

.PATCH3

 DEC DTAPE              \ Change the current media configuration in DTAPE from 0
                        \ to &FF, so the game defaults to disk on loading

 JMP JAMESON            \ We replace the JSR JAMESON in BEGIN with JSR PATCH3,
                        \ so we finish with this instruction to ensure that it
                        \ still gets done

\ ******************************************************************************
\
\       Name: SkipModifierKeys
\       Type: Subroutine
\   Category: Universe Editor
\    Summary: Patch to stop RDKEY from storing modifier keys in KL, and to
\             implement SHIFT-cursor keys
\
\ ******************************************************************************

.SkipModifierKeys

 CPX #keyShiftL         \ If this is a modifier key, jump to smod1 to skip the
 BEQ smod1              \ following, so we do not store the key in KL
 CPX #keyShiftR
 BEQ smod1
 CPX #keyCtrl
 BEQ smod1
 CPX #keyC64
 BEQ smod1

 STX KL                 \ Store the key pressed in KL

.smod1

 SEC                    \ Set the C flag, as in the original

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: ShiftCursorKeys
\       Type: Subroutine
\   Category: Universe Editor
\    Summary: Patch to implement the SHIFT-cursor keys in RDKEY
\
\ ******************************************************************************

.ShiftCursorKeys

 PHA                    \ Store A on the stack, so we can implement the code
                        \ below that the patch replaces

 LDX KL                 \ Fetch the key press

 CPX #keyDown           \ If the down arrow is not being pressed, jump to scur2
 BNE scur2              \ to keep checking

                        \ If we get here then the down arrow is being pressed,
                        \ so we need to check whether SHIFT is also being
                        \ pressed

 BIT keyLog+keyShiftL   \ If the left SHIFT is being pressed, jump to scur1 to
 BMI scur1              \ set KL to the up arrow (i.e. SHIFT-down arrow)

 BIT keyLog+keyShiftR   \ If the right SHIFT is being pressed, jump to scur1 to
 BMI scur1              \ set KL to the up arrow (i.e. SHIFT-down arrow)

 BPL scur4              \ SHIFT is not being pressed, so jump to scur4 to return
                        \ from the subroutine

.scur1

 PHA                    \ SHIFT-down arrow is being pressed, so set KL to the up
 LDA #keyUp             \ arrow
 STA KL
 PLA

 JMP scur4              \ Jump to scur4 to return from the subroutine

.scur2

 CPX #keyRight          \ If the right arrow is not being pressed, jump to scur4
 BNE scur4              \ to keep checking

 BIT keyLog+keyShiftL   \ If the left SHIFT is being pressed, jump to scur3 to
 BMI scur3              \ set KL to the right arrow (i.e. SHIFT-left arrow)

 BIT keyLog+keyShiftR   \ If the left SHIFT is being pressed, jump to scur3 to
 BMI scur3              \ set KL to the right arrow (i.e. SHIFT-left arrow)

 BPL scur4              \ SHIFT is not being pressed, so jump to scur4 to return
                        \ from the subroutine

.scur3

 PHA                    \ SHIFT-right arrow is being pressed, so set KL to the
 LDA #keyLeft           \ left arrow
 STA KL
 PLA

.scur4

 PLA                    \ Fetch the value of A from the stack, so it is the same
                        \ as when we jumped to the patch

 STA CIA1_PORTA         \ Implement the instruction that the patch replaces

 RTS                    \ Return from the subroutine

 INCLUDE "../../universe-editor/main-sources/elite-universe-editor-3.asm"
 INCLUDE "../../universe-editor/main-sources/elite-universe-editor-1.asm"
 INCLUDE "../../universe-editor/main-sources/elite-universe-editor-2.asm"
 INCLUDE "../../universe-editor/main-sources/elite-universe-editor-4.asm"
 INCLUDE "../../universe-editor/main-sources/elite-universe-editor-z.asm"

\ ******************************************************************************
\
\ Save editor.bin
\
\ ******************************************************************************

 SAVE "editor.bin", CODE%, P%, LOAD%
