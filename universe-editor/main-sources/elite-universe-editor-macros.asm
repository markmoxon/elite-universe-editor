\ ******************************************************************************
\
\ ELITE UNIVERSE EDITOR (MACROS FOR BBC MASTER)
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
\       Name: EJMP
\       Type: Macro
\   Category: Text
\    Summary: Macro definition for jump tokens in the extended token table
\  Deep dive: Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used when building the extended token table:
\
\   EJMP n              Insert a jump to address n in the JMTB table
\
\ See the deep dive on "Printing extended text tokens" for details on how jump
\ tokens are stored in the extended token table.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   n                   The jump number to insert into the table
\
\ ******************************************************************************

MACRO EJMP n

  EQUB n EOR VE

ENDMACRO

\ ******************************************************************************
\
\       Name: ECHR
\       Type: Macro
\   Category: Text
\    Summary: Macro definition for characters in the extended token table
\  Deep dive: Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used when building the extended token table:
\
\   ECHR 'x'            Insert ASCII character "x"
\
\ To include an apostrophe, use a backtick character, as in ECHR '`'.
\
\ See the deep dive on "Printing extended text tokens" for details on how
\ characters are stored in the extended token table.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   'x'                 The character to insert into the table
\
\ ******************************************************************************

MACRO ECHR x

  IF x = '`'
    EQUB 39 EOR VE
  ELSE
    EQUB x EOR VE
  ENDIF

ENDMACRO

\ ******************************************************************************
\
\       Name: ETOK
\       Type: Macro
\   Category: Text
\    Summary: Macro definition for recursive tokens in the extended token table
\  Deep dive: Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used when building the extended token table:
\
\   ETOK n              Insert extended recursive token [n]
\
\ See the deep dive on "Printing extended text tokens" for details on how
\ recursive tokens are stored in the extended token table.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   n                   The number of the recursive token to insert into the
\                       table, in the range 129 to 214
\
\ ******************************************************************************

MACRO ETOK n

  EQUB n EOR VE

ENDMACRO

\ ******************************************************************************
\
\       Name: ETWO
\       Type: Macro
\   Category: Text
\    Summary: Macro definition for two-letter tokens in the extended token table
\  Deep dive: Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used when building the extended token table:
\
\   ETWO 'x', 'y'       Insert two-letter token "xy"
\
\ The newline token can be entered using ETWO '-', '-'.
\
\ See the deep dive on "Printing extended text tokens" for details on how
\ two-letter tokens are stored in the extended token table.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   'x'                 The first letter of the two-letter token to insert into
\                       the table
\
\   'y'                 The second letter of the two-letter token to insert into
\                       the table
\
\ ******************************************************************************

MACRO ETWO t, k

  IF t = '-' AND k = '-' : EQUB 215 EOR VE : ENDIF
  IF t = 'A' AND k = 'B' : EQUB 216 EOR VE : ENDIF
  IF t = 'O' AND k = 'U' : EQUB 217 EOR VE : ENDIF
  IF t = 'S' AND k = 'E' : EQUB 218 EOR VE : ENDIF
  IF t = 'I' AND k = 'T' : EQUB 219 EOR VE : ENDIF
  IF t = 'I' AND k = 'L' : EQUB 220 EOR VE : ENDIF
  IF t = 'E' AND k = 'T' : EQUB 221 EOR VE : ENDIF
  IF t = 'S' AND k = 'T' : EQUB 222 EOR VE : ENDIF
  IF t = 'O' AND k = 'N' : EQUB 223 EOR VE : ENDIF
  IF t = 'L' AND k = 'O' : EQUB 224 EOR VE : ENDIF
  IF t = 'N' AND k = 'U' : EQUB 225 EOR VE : ENDIF
  IF t = 'T' AND k = 'H' : EQUB 226 EOR VE : ENDIF
  IF t = 'N' AND k = 'O' : EQUB 227 EOR VE : ENDIF

  IF t = 'A' AND k = 'L' : EQUB 228 EOR VE : ENDIF
  IF t = 'L' AND k = 'E' : EQUB 229 EOR VE : ENDIF
  IF t = 'X' AND k = 'E' : EQUB 230 EOR VE : ENDIF
  IF t = 'G' AND k = 'E' : EQUB 231 EOR VE : ENDIF
  IF t = 'Z' AND k = 'A' : EQUB 232 EOR VE : ENDIF
  IF t = 'C' AND k = 'E' : EQUB 233 EOR VE : ENDIF
  IF t = 'B' AND k = 'I' : EQUB 234 EOR VE : ENDIF
  IF t = 'S' AND k = 'O' : EQUB 235 EOR VE : ENDIF
  IF t = 'U' AND k = 'S' : EQUB 236 EOR VE : ENDIF
  IF t = 'E' AND k = 'S' : EQUB 237 EOR VE : ENDIF
  IF t = 'A' AND k = 'R' : EQUB 238 EOR VE : ENDIF
  IF t = 'M' AND k = 'A' : EQUB 239 EOR VE : ENDIF
  IF t = 'I' AND k = 'N' : EQUB 240 EOR VE : ENDIF
  IF t = 'D' AND k = 'I' : EQUB 241 EOR VE : ENDIF
  IF t = 'R' AND k = 'E' : EQUB 242 EOR VE : ENDIF
  IF t = 'A' AND k = '?' : EQUB 243 EOR VE : ENDIF
  IF t = 'E' AND k = 'R' : EQUB 244 EOR VE : ENDIF
  IF t = 'A' AND k = 'T' : EQUB 245 EOR VE : ENDIF
  IF t = 'E' AND k = 'N' : EQUB 246 EOR VE : ENDIF
  IF t = 'B' AND k = 'E' : EQUB 247 EOR VE : ENDIF
  IF t = 'R' AND k = 'A' : EQUB 248 EOR VE : ENDIF
  IF t = 'L' AND k = 'A' : EQUB 249 EOR VE : ENDIF
  IF t = 'V' AND k = 'E' : EQUB 250 EOR VE : ENDIF
  IF t = 'T' AND k = 'I' : EQUB 251 EOR VE : ENDIF
  IF t = 'E' AND k = 'D' : EQUB 252 EOR VE : ENDIF
  IF t = 'O' AND k = 'R' : EQUB 253 EOR VE : ENDIF
  IF t = 'Q' AND k = 'U' : EQUB 254 EOR VE : ENDIF
  IF t = 'A' AND k = 'N' : EQUB 255 EOR VE : ENDIF

ENDMACRO

\ ******************************************************************************
\
\       Name: ERND
\       Type: Macro
\   Category: Text
\    Summary: Macro definition for random tokens in the extended token table
\  Deep dive: Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used when building the extended token table:
\
\   ERND n              Insert recursive token [n]
\
\                         * Tokens 0-123 get stored as n + 91
\
\ See the deep dive on "Printing extended text tokens" for details on how
\ random tokens are stored in the extended token table.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   n                   The number of the random token to insert into the
\                       table, in the range 0 to 37
\
\ ******************************************************************************

MACRO ERND n

  EQUB (n + 91) EOR VE

ENDMACRO

\ ******************************************************************************
\
\       Name: TOKN
\       Type: Macro
\   Category: Text
\    Summary: Macro definition for standard tokens in the extended token table
\  Deep dive: Printing text tokens
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used when building the recursive token table:
\
\   TOKN n              Insert recursive token [n]
\
\                         * Tokens 0-95 get stored as n + 160
\
\                         * Tokens 128-145 get stored as n - 114
\
\                         * Tokens 96-127 get stored as n
\
\ See the deep dive on "Printing text tokens" for details on how recursive
\ tokens are stored in the recursive token table.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   n                   The number of the recursive token to insert into the
\                       table, in the range 0 to 145
\
\ ******************************************************************************

MACRO TOKN n

  IF n >= 0 AND n <= 95
    t = n + 160
  ELIF n >= 128
    t = n - 114
  ELSE
    t = n
  ENDIF

  EQUB t EOR VE

ENDMACRO
