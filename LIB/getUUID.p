/* ***************************************************************************
COPYRIGHT (C) 2005 BY SMART-IT-CONSULTING.COM
* Do not remove this header
* This program is provided AS IS 
* Use this program at your own risk
* Don't publish this code, link to http://www.smart-it-consulting.com/ instead
* GUID stuff: credits go to http://www.global-shared.com/
*************************************************************************** */

/*
  Returns a unified unique identifier (UUID)
  
  Note: NOT DCE conform. If you need persistent UUIDs use a DCE conform UUID generator!
  
  def var cUUID as char no-undo.                    
  def var lGUID as log init false no-undo.
  def var cConstantNode as char init ? no-undo.
  def var cMode as char init "String":U no-undo.
  RUN globtools/getUUID.p(
        INPUT  cMode,
        INPUT  lGUID,
        INPUT  cConstantNode,        
        OUTPUT cUUID).

  Best usage:
  Make this procedure a SUPER procedure and define a function getUUID() which
  runs this procedure using standard input parameters 

*/

DEF INPUT  PARAM cMode       AS CHAR                NO-UNDO. /* "Binary" x(16) || "String" x(36) */
DEF INPUT  PARAM lGUID       AS LOG                 NO-UNDO. /* Return a Windows GUID, if possible (means OS=WIN). Note: binary representations of GUIDs are not that unique :(  */
DEF INPUT  PARAM cUniqueNode AS CHAR FORMAT "x(06)" NO-UNDO. /* can be used for host-address, table prefix ... If you use all 6 bytes, UUIDs created on a fast machine will not be unique! (~2 dupes in 100,000 GUIDs) Default = ? */
DEF OUTPUT PARAM cUUID       AS CHAR INIT ?         NO-UNDO. /* UUID or ? on failure */

DEF VAR cDisplayUUID         AS CHAR INIT ? NO-UNDO.
DEF VAR cBinaryUUID          AS CHAR INIT ? NO-UNDO.
&GLOBAL-DEFINE assignUUID ASSIGN cUUID = (IF cMode = "Binary":U THEN cBinaryUUID ELSE cDisplayUUID).

DEF VAR lUseFake AS LOG INIT FALSE NO-UNDO. /* Debug setting, force faked UUIDs */
DEF VAR lConstantNode AS LOG INIT FALSE NO-UNDO. /*true="Node"-part is a constant value */
IF cUniqueNode NE ? AND TRIM(cUniqueNode) NE "":U THEN
    ASSIGN lConstantNode = TRUE.


/* see remarks at http://msdn.microsoft.com/library/default.asp?url=/library/en-us/rpc/rpc/uuidcreatesequential.asp */
PROCEDURE UuidCreate EXTERNAL "rpcrt4.dll":U :
    DEFINE INPUT-OUTPUT PARAMETER opi-guid AS CHAR NO-UNDO.
END PROCEDURE. 

PROCEDURE UuidCreateSequential EXTERNAL "rpcrt4.dll":U :
    DEFINE INPUT-OUTPUT PARAMETER opi-guid AS CHAR NO-UNDO.
END PROCEDURE. 


FUNCTION inttohex RETURNS CHAR (INPUT i AS INTEGER): 
   /* only for 0..255 integer values  */
   DEF VAR cHex AS CHAR NO-UNDO INIT '0123456789ABCDEF':U.
   DEF VAR j1   AS INT NO-UNDO.   
   DEF VAR j2   AS INT NO-UNDO. 
   ASSIGN j1 = TRUNCATE(i / 16, 0)    
          j2 = i - (j1 * 16).
   /* i is negative if a byte of the UUID is empty */
   IF j1 < 1 THEN ASSIGN j1 = 0.
   IF j2 < 1 THEN ASSIGN j2 = 0.
   RETURN SUBSTR(cHex, j1 + 1, 1) 
        + SUBSTR(cHex, j2 + 1, 1).
END.  

FUNCTION GetGuid RETURNS CHAR:   
   DEF VAR X AS CHAR NO-UNDO.
   X = FILL(' ':U, 46). 
   
   /*  Creates a GUID which is unique on this machine 
   RUN UuidCreate (INPUT-OUTPUT X).    */

   /*  Creates a GUID which is globally unique, coz it contains the MAC address of this machine */
   RUN UuidCreateSequential (INPUT-OUTPUT X).

   RETURN X.
END.  

FUNCTION getDisplayGuid RETURNS CHAR (INPUT cBinUUID AS CHAR):
    DEF VAR X AS CHAR NO-UNDO.
    DEF VAR i AS INT NO-UNDO.      
    X = "":U. 

    DO i = 1 TO 16:
      X = X +  inttohex(ASC(SUBSTR(cBinUUID,i,1))).    

      IF i = 4 OR
         i = 6 OR
         i = 8 OR
         i = 10 THEN
         X = X + "-":U.
    END. 

    RETURN X.
END.

/* ****************** MAIN ************************* */

IF lUseFake THEN DO:
   RUN getFakedUUID.
   IF cDisplayUUID NE ? THEN DO:
       {&assignUUID}
       RETURN "This value SHOULD be unique, but no guarantees!".
   END.
      
END.

IF OPSYS = "UNIX":U THEN
    RUN getUnixUUID.


IF OPSYS = "WIN32":U AND lGUID THEN
    RUN getWindowsGUID.    


IF cDisplayUUID NE ? THEN DO:
    {&assignUUID}
    RETURN.
END.    
ELSE DO:
    RUN getProgressUUID.
    IF cDisplayUUID NE ? THEN DO:
        {&assignUUID}
        RETURN.
    END.
    ELSE DO:
       RUN getFakedUUID.
       IF cDisplayUUID NE ? THEN DO:
          {&assignUUID}
          RETURN "This value SHOULD be unique, but no guarantees!".
       END.
    END.
       
END.

ASSIGN cUUID = ?.
RETURN "Cannot supply a UUID":U.


/* ************************************************************************ */
PROCEDURE getWindowsGUID:
    ASSIGN cBinaryUUID = GetGuid()
           cDisplayUUID = LOWER(getDisplayGuid(cBinaryUUID)).    
    {&assignUUID}
    RETURN.
END PROCEDURE.


/* ************************************************************************ */
PROCEDURE getUnixUUID:
    /* Call /usr/bin/uuidgen */
END PROCEDURE.


/* ************************************************************************ */
PROCEDURE getProgressUUID:
   /* Call $DLC/bin/genuuid   40 Bytes instead of 36 and INCREDIBLE SLOW! */
END PROCEDURE.

/* ************************************************************************ */
PROCEDURE getFakedUUID:
    /* Tested a few times with bunches of 1,000,000 UUIDs (>1,000 UUIDs per second) 
       and all were unique, but there is no guarantee!
       Since there is no machine identifier, faked UUIDs generated by different machines
       running parallel may produce dupes.
    */
    DEF VAR iFakes AS INT EXTENT 16 NO-UNDO.
    DEF VAR cFakes AS CHAR EXTENT 16 NO-UNDO.
    DEF VAR i AS INT NO-UNDO.

    /* Initialize with random numbers */
    DO i = 1 TO 16:
        ASSIGN iFakes[i] = RANDOM(1, 255)
               cFakes[i] = CHR(iFakes[i]).
    END.
    
    

    /* Node */
    IF lConstantNode THEN DO:  /* Will not be unique if you create faked UUIDs on a fast machine */       
        DEF VAR cName AS CHAR INIT "":U NO-UNDO.
        ASSIGN cName = TRIM(cUniqueNode).
        IF cName NE ? AND trim(cName) NE "":U THEN DO i = 1 TO 6:
            IF SUBSTRING(cName, i, 1) NE "":U AND
               SUBSTRING(cName, i, 1) NE ?    THEN
               ASSIGN iFakes[i + 10] = asc(SUBSTRING(cName, i, 1))
                      cFakes[i + 10] = CHR(iFakes[i + 10]).
        END.
    END.
    /* ELSE use random numbers */


    /* Date and Time mixed up - not DCE conform! */
    DEF VAR iDate AS INT FORMAT "-9999999999":U NO-UNDO.
    DEF VAR cDate AS CHAR NO-UNDO.
    DEF VAR iLengthDate AS INT NO-UNDO. /* Constant = 8, 7 Bytes needed til 9999 */
    DEF VAR iLengthTS AS INT NO-UNDO.  /* Max length timestamp = 30 */
    DEF VAR iTime AS INT FORMAT "-9999999999":U NO-UNDO.
    DEF VAR cTime AS CHAR NO-UNDO.
    DEF VAR iEtime AS INT FORMAT "-9999999999":U NO-UNDO.
    DEF VAR cETime AS CHAR NO-UNDO.
    DEF VAR cTimeStamp AS CHAR NO-UNDO.
    DEF VAR cVal AS CHAR NO-UNDO.
    DEF VAR iSub AS INT NO-UNDO.

    ASSIGN iDate = INTEGER(TODAY)        
           iDate = (IF iDate < 0 THEN iDate * -1 ELSE iDate)
           cDate = TRIM(STRING(iDate, ">>>9999999":U))           
           iTime = INTEGER(TIME)
           iTime = (IF iTime < 0 THEN iTime * -1 ELSE iTime)
           cTime = TRIM(STRING(iTime, ">>>>>99999":U))
           iETime = ETIME(FALSE)
           iETime = (IF iETime < 0 THEN iETime * -1 ELSE iETime)
           cETime = TRIM(STRING(iETime, ">>>>>>9999":U))
           .

    /* Byte 1 - 4 = Date - save til 9999 */
    DO WHILE LENGTH(cDate) < 8:
        ASSIGN cDate = "0":U + cDate.  
    END.
    ASSIGN cTimeStamp  = cDate + cTime + cETime
           iLengthDate = LENGTH(cDate)
           iLengthTS   = LENGTH(cTimeStamp)
           cFakes[1]   = chr(integer(SUBSTRING(cTimeStamp,1,2)))
           iFakes[1]   = integer(SUBSTRING(cTimeStamp,1,2))
           cFakes[2]   = chr(integer(SUBSTRING(cTimeStamp,3,2)))
           iFakes[2]   = integer(SUBSTRING(cTimeStamp,3,2))
           cFakes[3]   = chr(integer(SUBSTRING(cTimeStamp,5,2)))
           iFakes[3]   = integer(SUBSTRING(cTimeStamp,5,2))
           cFakes[4]   = chr(integer(SUBSTRING(cTimeStamp,7,2)))
           iFakes[4]   = integer(SUBSTRING(cTimeStamp,7,2))
           iSub        = 5
           cVal        = "":U
           .

    /* Byte 5 - 10 = Time + ETime + (if too short) random numbers */

    DO i = 9 TO (iLengthTS + 1):
        IF iSub > 10 THEN
            LEAVE.
        IF  i > iLengthTS OR
            INTEGER(cVal + SUBSTRING(cTimeStamp,i,1)) > 255 THEN
            IF cVal NE ? AND TRIM(cVal) NE "":U THEN
               ASSIGN cFakes[iSub] = chr(integer(cVal))
                      iFakes[iSub] = integer(cVal)
                      cVal = SUBSTRING(cTimeStamp,i,1)
                      iSub = iSub + 1.
            ELSE
               LEAVE.
        ELSE
            ASSIGN cVal = cVal + SUBSTRING(cTimeStamp,i,1).                    
        IF i > iLengthTS THEN
            LEAVE.
    END.


    ASSIGN cBinaryUUID = "":U.
    DO i = 1 TO 16:
        IF iFakes[i] > 255 OR iFakes[i] < 0 OR cFakes[i] = "":U THEN
           ASSIGN iFakes[i] = RANDOM(1, 255)
                  cFakes[i] = chr(iFakes[i]). 
        ASSIGN cBinaryUUID = cBinaryUUID + cFakes[i].
    END.

    ASSIGN cDisplayUUID = LOWER(getDisplayGuid(cBinaryUUID)).
    {&assignUUID}

    RETURN.

END PROCEDURE.

