/* ***************************************************************************
COPYRIGHT (C) 2005 BY SMART-IT-CONSULTING.COM
* Do not remove this header
* This program is provided AS IS 
* Use this program at your own risk
* Don't publish this code, link to http://www.smart-it-consulting.com/ instead
*************************************************************************** */

/*
Returns a unique file name incl. fully qualified path

DEF var cExtension AS CHAR NO-UNDO.              /* .txt  .wmf  .bmp ....*/
DEF var cTargetPath AS CHAR init ? NO-UNDO.      /* ?=tempDir or relative path from workdir like /globtools */
DEF var cUniqueFileName AS CHAR INIT ? NO-UNDO.  /* ? on error, see return value  */
RUN getUniqueFileName.p(
    INPUT cExtension,
    INPUT cTargetPath,
    OUTPUT cUniqueFileName).

*/


DEF INPUT  PARAM cExtension AS CHAR NO-UNDO.
DEF INPUT  PARAM cTargetPath AS CHAR NO-UNDO.
DEF OUTPUT PARAM cUniqueFileName AS CHAR INIT ? NO-UNDO.

DEF VAR cWhat as char no-undo.                    
DEF VAR cPath as char no-undo.
IF cTargetPath = ? OR TRIM(cTargetPath) = "":U THEN
    ASSIGN cWhat = "TempDir".
ELSE
    ASSIGN cWhat = cTargetPath.
RUN lib/getOsPath.p(
    input cWhat,    /* WorkDir         : Progress current directory
                       TempDir         : OS tempDir
                       AppTempDir      : Progress tempDir
                       A relative path : relative path like "tools" "/tools" or "./tools"
                    */
    output cPath).  /* ? on failure || OS-Path incl. trailing slash */

IF cPath = ? OR TRIM(cPath) = "":U THEN 
    RETURN "Path parameter results in an unknown destination":U.


def var cUUID as char no-undo.                    
def var lGUID as log init TRUE no-undo.
def var cConstantNode as char init ? no-undo.
def var cMode as char init "String":U no-undo.
RUN lib/getUUID.p(
    INPUT  cMode,
    INPUT  lGUID,
    INPUT  cConstantNode,        
    OUTPUT cUUID).

IF cUUID = ? OR TRIM(cUUID) = "":U THEN
    RETURN "UUID generation failed".

IF cExtension = ? THEN
    ASSIGN cExtension = "":U.

ASSIGN cUniqueFileName = TRIM(cPath) + TRIM(cUUID) + TRIM(cExtension).

DEF VAR i AS INT INIT 0 NO-UNDO.
DO WHILE SEARCH(cUniqueFileName) <> ?: /* Paranoid? Nope, depending on the input params getUUID could produce dupes */
    ASSIGN i = i + 1
           cUniqueFileName = TRIM(cPath) + TRIM(cUUID) + "-":U + TRIM(STRING(i)) + TRIM(cExtension).
END.

RETURN.

