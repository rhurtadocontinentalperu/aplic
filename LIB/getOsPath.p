/* ***************************************************************************
COPYRIGHT (C) 2005 BY SMART-IT-CONSULTING.COM
* Do not remove this header
* This program is provided AS IS 
* Use this program at your own risk
* Don't publish this code, link to http://www.smart-it-consulting.com/ instead
*************************************************************************** */


/*

  Returns a fully qualified path including a trailing slash.

  def var cWhat as char no-undo.                    
  def var cPath as char no-undo.
  RUN getOsPath.p(
        input cWhat,    /* WorkDir         : Progress current directory
                           TempDir         : OS tempDir
                           AppTempDir      : Progress tempDir
                           A relative path : relative path like "tools" "tools/temp" or "./tools"
                        */
        output cPath).  /* ? on failure || OS-Path incl. trailing slash */
*/

DEF INPUT PARAM cWhat AS CHAR NO-UNDO.
DEF OUTPUT PARAM cPath AS CHAR INIT ? NO-UNDO.

DEF VAR cTempDir AS CHAR NO-UNDO.
DEF VAR cOsTempDir AS CHAR NO-UNDO.
DEF VAR cCurrDir AS CHAR NO-UNDO.
ASSIGN FILE-INFO:FILE-NAME = ".":U    
       cCurrDir = FILE-INFO:FULL-PATHNAME.
IF SUBSTRING(cCurrDir, LENGTH(cCurrDir), 1) = ".":U THEN
   ASSIGN cCurrDir = SUBSTRING(cCurrDir, 1, LENGTH(cCurrDir) - 1).
IF SUBSTRING(cCurrDir, LENGTH(cCurrDir), 1) NE "/":U AND
   SUBSTRING(cCurrDir, LENGTH(cCurrDir), 1) NE "\":U THEN
   ASSIGN cCurrDir = cCurrDir + "/":U.
ASSIGN FILE-INFO:FILE-NAME = SESSION:TEMP-DIRECTORY    
       cTempDir = FILE-INFO:FULL-PATHNAME.
IF SUBSTRING(cTempDir, LENGTH(cTempDir), 1) NE "/":U AND
   SUBSTRING(cTempDir, LENGTH(cTempDir), 1) NE "\":U THEN
   ASSIGN cTempDir = cTempDir + "/":U.
IF cCurrDir = cTempDir THEN DO:
   ASSIGN FILE-INFO:FILE-NAME = cTempDir + "temp":U.
   IF FILE-INFO:FULL-PATHNAME NE ? THEN DO:
       cTempDir = FILE-INFO:FULL-PATHNAME.
       IF SUBSTRING(cTempDir, LENGTH(cTempDir), 1) NE "/":U AND
           SUBSTRING(cTempDir, LENGTH(cTempDir), 1) NE "\":U THEN
           ASSIGN cTempDir = cTempDir + "/":U.
   END.
END.

ASSIGN cOsTempDir = "":U
       cOsTempDir = OS-GETENV("TEMP":U)
       cOsTempDir = (IF TRIM(cOsTempDir) = "":U THEN OS-GETENV("TMP":U) ELSE cOsTempDir)
       cOsTempDir = (IF TRIM(cOsTempDir) = "":U THEN OS-GETENV("tmpDir":U) ELSE cOsTempDir)
       cOsTempDir = (IF TRIM(cOsTempDir) = "":U THEN cTempDir ELSE cOsTempDir)
       FILE-INFO:FILE-NAME = cOsTempDir
       .
IF FILE-INFO:FULL-PATHNAME NE ? THEN DO:
   cOsTempDir = FILE-INFO:FULL-PATHNAME.
   IF SUBSTRING(cOsTempDir, LENGTH(cOsTempDir), 1) NE "/":U AND
       SUBSTRING(cOsTempDir, LENGTH(cOsTempDir), 1) NE "\":U THEN
       ASSIGN cOsTempDir = cOsTempDir + "/":U.
END.


CASE cWhat:
    WHEN "WorkDir":U THEN DO:
        ASSIGN cPath = cCurrDir.
    END.
    WHEN "TempDir":U THEN DO:
        ASSIGN cPath = cOsTempDir.
    END.
    WHEN "AppTempDir":U THEN DO:
        ASSIGN cPath = cTempDir.
    END.
    OTHERWISE DO:
        ASSIGN FILE-INFO:FILE-NAME = cWhat.
        IF FILE-INFO:FULL-PATHNAME NE ? AND           /* exists */
           FILE-INFO:FILE-TYPE MATCHES "*D*":U  AND   /* is directory */
           FILE-INFO:FILE-TYPE MATCHES "*R*":U  AND   /* read permissions */
           FILE-INFO:FILE-TYPE MATCHES "*W*":U        /* write permissions */
            THEN DO:
           ASSIGN cPath = FILE-INFO:FULL-PATHNAME.
           IF SUBSTRING(cPath, LENGTH(cPath), 1) NE "/":U AND
               SUBSTRING(cPath, LENGTH(cPath), 1) NE "\":U THEN
               ASSIGN cPath = cPath + "/":U.
        END.
        ELSE DO:        
           ASSIGN cPath = ?.
           RETURN "Method not avail, or given directory does not exist, or read/write permissions missing ":U.
        END.
    END.
END CASE.

IF OPSYS = "WIN32":U THEN
    cPath = REPLACE(cPath, "/":U, "\":U).
IF OPSYS = "UNIX":U THEN
    cPath = REPLACE(cPath, "\":U, "/":U).


RETURN.


