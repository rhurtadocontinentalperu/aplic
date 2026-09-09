/******************************************************************************/
/* OE10 way to base64encode attachments : use built-in base64-encode function */
/* Some mailserers demand the 76-character sized mail standard, so we split   */
/* the original long string into smaller pieces.                              */
/* This in done as most as possible with mem-pointers for performance reasons */
/* January 2008 - Dries Feys - TVH Forklift Parts Belgium                     */
/******************************************************************************/

DEFINE INPUT PARAMETER cInFileName AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER cOutFileName AS CHAR NO-UNDO.

&SCOPED-DEFINE sdLength 76
DEFINE VARIABLE memFile       AS MEMPTR     NO-UNDO.
DEFINE VARIABLE cResult       AS LONGCHAR   NO-UNDO.
DEFINE VARIABLE cResultTempo  AS LONGCHAR   NO-UNDO.
DEFINE VARIABLE cResultEnter  AS LONGCHAR   NO-UNDO.
DEFINE VARIABLE crlf          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iFileLength   AS INTEGER    NO-UNDO.
DEFINE VARIABLE iOffSet       AS INTEGER    NO-UNDO INIT 1.


ASSIGN FILE-INFO:FILE-NAME = cInFileName
  crlf = CHR(13) + CHR(10).

IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
  OUTPUT TO VALUE(cInFileName).
  PUT UNFORMATTED "ERROR MESSAGE! File not found!" SKIP.
  OUTPUT CLOSE.
END.

IF FILE-INFO:FILE-SIZE > 12000000 THEN DO:
  OUTPUT TO VALUE(cInFileName).
  PUT UNFORMATTED "ERROR MESSAGE! File too large!" SKIP.
  OUTPUT CLOSE.
END.

COPY-LOB FROM FILE FILE-INFO:FULL-PATHNAME TO memFile.
cResult = BASE64-ENCODE (memFile).

SET-SIZE(memFile) = 0.
ASSIGN iFileLength = LENGTH(cResult).
SET-SIZE(memFile) = iFileLength.
COPY-LOB FROM cResult TO memFile.

OS-DELETE cOutFileName.
/* Apparently, our mailserver wants some chr(10) inbetween the base64'd files. Do some tweaking for this. */
DO iOffSet = 1 TO iFileLength BY {&sdLength}:
  ASSIGN cResultEnter = cResultEnter + 
    GET-STRING(memFile,iOffSet,MIN({&sdLength},(iFileLength - iOffSet + 1))) + crlf.
END.

COPY-LOB cResultEnter TO FILE cOutFileName.

SET-SIZE(memFile) = 0.
