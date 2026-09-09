&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : logread/logmsgs.i
    Purpose     : Provides handling for Promsgs translations

    Syntax      : {logread/logmsgs.i}

    Description :

    Author(s)   : 
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* list of loaded promsgs files */
DEF TEMP-TABLE ttpromsgs NO-UNDO
    FIELD msgfile AS CHAR
    FIELD msgcp AS CHAR
    FIELD msgfno AS INT
    INDEX msgsix msgfile.

/* list of loaded messages from the loaded promsgs file */
DEF TEMP-TABLE ttmsgs NO-UNDO
    FIELD msgfno AS INT
    FIELD msgno AS INT
    FIELD msgtext AS CHAR
    FIELD imsgid AS INT  /* unique identifier for message */
    INDEX msgix msgfno msgno.

/* list of messages parts (parts of message between substitution chars)
 * between loaded messages */
DEF TEMP-TABLE ttmsgpart NO-UNDO
    FIELD imsgid AS INT
    FIELD ipart AS INT
    FIELD ilen AS INT  /* length of this part of the message */
    FIELD cnext AS CHAR /* search string for the next part of the message */
    INDEX msgpix imsgid ipart.

DEFINE VARIABLE imsgfseq AS INTEGER INIT 1   NO-UNDO.
DEFINE VARIABLE imsgseq AS INTEGER INIT 1   NO-UNDO.

DEFINE STREAM sMsgs.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPromsgsFile Include 
PROCEDURE checkPromsgsFile :
/*------------------------------------------------------------------------------
  Purpose:     Checks that a given file is a promsgs file
  Parameters:  
    cMsgFile - [IN] path name of file to check
    lOK      - [OUT] true if cMsgFile is a promsgs file
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM cMsgFile AS CHAR NO-UNDO.
  DEF OUTPUT PARAM lOK AS LOG INIT FALSE NO-UNDO.

  DEFINE VARIABLE mmsg AS MEMPTR     NO-UNDO.
  DEFINE VARIABLE ioffset AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ival AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ibyte AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ictr AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cval AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ccodepage AS CHARACTER  NO-UNDO.

  FIND FIRST ttpromsgs NO-LOCK WHERE
      ttpromsgs.msgfile = cmsgfile NO-ERROR.
  IF AVAILABLE ttpromsgs THEN
  DO:
      lOK = TRUE.
      RETURN.
  END.

  ioffset = 0.
  INPUT STREAM smsgs FROM value(cmsgfile) BINARY NO-CONVERT NO-ECHO.
  SEEK STREAM smsgs TO ioffset.
  SET-SIZE(mmsg) = 81.
  IMPORT STREAM smsgs mmsg.
  INPUT CLOSE.
  /* check checksum at start of file */
  DO ictr = 1 TO 4:
      ASSIGN 
          ibyte = GET-BYTE(mmsg,ictr)
          ival = (ival * 256) + ibyte.
  END.
  cval = GET-STRING(mmsg,5,-1).
  IF (INT(cval) <> ival) THEN
  DO:
      lok = FALSE.
      RETURN.
  END.
  /* valid promsgs file, load codepage */
  lok = TRUE.
  ccodepage = GET-STRING(mmsg,5 + LENGTH(cval) + 1,-1).
  SET-SIZE(mmsg) = 0.
  /* create a new ttpromsgs for this promsgs file */
  CREATE ttpromsgs.
  ASSIGN 
      ttpromsgs.msgfile = cmsgfile
      ttpromsgs.msgfno = imsgfseq
      imsgfseq = imsgfseq + 1.
  /* look for a conversion */
  IF CODEPAGE-CONVERT("test",session:charset,ccodepage) = ? THEN
      ttpromsgs.msgcp = ?.  /* no conversion available */
  ELSE
      ttpromsgs.msgcp = ccodepage. /* conversion available */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPromsgFragment Include 
PROCEDURE getPromsgFragment PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Returns a fragment of a promsg from a promsgs file.
  Parameters:  
    cmsgfile - [IN] promsgs file to extract message fragment from
    imsgno   - [IN] message number to extract
    cmsgfrag - [OUT] message fragment
    cmsgnum  - [OUT] message number of next fragment of promsg
    lFinished - [OUT] TRUE if the retrieved fragment is the last fragment 
                of the message.
  Notes:       Later promsgs may be longer than 81 chars. If this is the case, 
               they are split across multiple promsgs, called fragments.
               
------------------------------------------------------------------------------*/
  DEF INPUT PARAM cmsgfile AS CHAR NO-UNDO.
  DEF INPUT PARAM imsgno AS INT NO-UNDO.
  DEF OUTPUT PARAM cmsgfrag AS CHAR NO-UNDO.
  DEF OUTPUT PARAM cmsgnum AS INT NO-UNDO.
  DEF OUTPUT PARAM lfinished AS LOGICAL NO-UNDO.

  DEFINE VARIABLE mmsg AS MEMPTR     NO-UNDO.
  DEFINE VARIABLE ioffset AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ilastbyte AS INTEGER    NO-UNDO.

  ioffset = imsgno * 81.
  INPUT STREAM smsgs FROM value(cmsgfile) BINARY NO-CONVERT NO-ECHO.
  SEEK STREAM smsgs TO ioffset.
  SET-SIZE(mmsg) = 82.
  IMPORT STREAM smsgs mmsg.
  INPUT CLOSE.
  cmsgfrag = GET-STRING(mmsg,1,81).
  /* if the last byte is non-null, this is a long message, with > 1 fragment */
  ilastbyte = GET-BYTE(mmsg,81).
  IF (ilastbyte <> 0) THEN
  DO:
      lfinished = FALSE.
      cmsgnum = INT(SUBSTRING(cmsgfrag,1,6)) NO-ERROR.
      cmsgfrag = SUBSTRING(cmsgfrag,7).
  END.
  ELSE
  DO:
      lfinished = TRUE.
  END.
  SET-SIZE(mmsg) = 0.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPromsgNum Include 
PROCEDURE getPromsgNum :
/*------------------------------------------------------------------------------
  Purpose:     Locates the promsgs number within a message
  Parameters:  
    cmsg   - [IN] test of message to search for promsg number
    imsgno - [OUT] promsg number found in cmsg (0 if none found)
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM cmsg AS CHAR NO-UNDO.
  DEF OUTPUT PARAM imsgno AS INT INIT 0 NO-UNDO.

  DEFINE VARIABLE ipos AS INTEGER    NO-UNDO.

  ipos = R-INDEX(cmsg,"(").
  IF ipos = 0 THEN RETURN.
  ASSIGN 
      cmsg = SUBSTRING(cmsg,ipos + 1)
      ipos = R-INDEX(cmsg,")")
      imsgno = INT(SUBSTRING(cmsg,1,ipos - 1)) NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPromsgRawText Include 
PROCEDURE getPromsgRawText PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Returns the raw (unconverted) text of a promsg from promsgs file.
  Parameters:  
    cmsgfile - [IN] promsgs file to extract message text from
    imsgno   - [IN] message number to extract
    cmsgtxt  - [OUT] message text
               
------------------------------------------------------------------------------*/
  DEF INPUT PARAM cmsgfile AS CHAR NO-UNDO.
  DEF INPUT PARAM imsgno AS INT NO-UNDO.
  DEF OUTPUT PARAM cmsgtxt AS CHAR NO-UNDO.

  DEFINE VARIABLE ifragno AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cmsgfrag AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lfinished AS LOGICAL INIT NO  NO-UNDO.

  ifragno = imsgno.
  DO WHILE NOT lfinished:
      RUN getPromsgFragment(cmsgfile,ifragno,OUTPUT cmsgfrag, OUTPUT ifragno, OUTPUT lfinished).
      cmsgtxt = cmsgtxt + cmsgfrag.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPromsgText Include 
PROCEDURE getPromsgText :
/*------------------------------------------------------------------------------
  Purpose:     Returns the text of a promsg from a promsgs file.
               Converts from promsg codepage to the current codepage,
               if necessary.
  Parameters:  
    cmsgfile - [IN] promsgs file to extract message text from
    imsgno   - [IN] message number to extract
    cmsgtxt  - [OUT] message text
               
------------------------------------------------------------------------------*/
  DEF INPUT PARAM cmsgfile AS CHAR NO-UNDO.
  DEF INPUT PARAM imsgno AS INT NO-UNDO.
  DEF OUTPUT PARAM cmsgtxt AS CHAR NO-UNDO.

  IF cmsgfile = "" THEN
      cmsgfile = search(PROMSGS).
  RUN getPromsgRawText(cmsgfile,imsgno,OUTPUT cmsgtxt).

  /* check for ttpromsgs entry for codepage conversion info */
  FIND FIRST ttpromsgs NO-LOCK WHERE
      ttpromsgs.msgfile = cmsgfile NO-ERROR.
  IF NOT AVAILABLE ttpromsgs THEN
  DO:
      /* something in checkPromsgsFile failed - error */
      RETURN. 
  END.
  /* perform codepage conversion if possible and necessary */
  IF ttpromsgs.msgcp <> ? AND ttpromsgs.msgcp <> "undefined" THEN
      cmsgtxt = CODEPAGE-CONVERT(cmsgtxt,SESSION:CHARSET,ttpromsgs.msgcp).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadPromsg Include 
PROCEDURE loadPromsg PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Loads a specific promsg from a promsgs file, into the 
               message temp-tables.
  Parameters:  
    cmsgfile - [IN] promsgs file containing promsg
    imsgno   - [IN] message number to extract.
  Notes:       If the promsg contains more than one fragment, loads all fragments.
------------------------------------------------------------------------------*/
  DEF INPUT PARAM cmsgfile AS CHAR NO-UNDO.
  DEF INPUT PARAM imsgno AS INT NO-UNDO.

  DEFINE VARIABLE cmsg AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lfinished AS LOGICAL INIT NO   NO-UNDO.
  DEFINE VARIABLE cmsgfrag AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ipos AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ipos1 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ilen AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ipart AS INTEGER INIT 1   NO-UNDO.
  DEFINE VARIABLE inumparts AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cpart AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE clastpart AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ccodepage AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOK AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE ifragno AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cstart AS CHARACTER  NO-UNDO.

  RUN checkPromsgsFile(INPUT cmsgfile,OUTPUT lOK).
  IF NOT lOK THEN
      RETURN.  /* error here */

  /* get the whole message text */
  RUN getPromsgRawText(cmsgfile,imsgno,OUTPUT cmsg).

  /* check for ttpromsgs entry fo codepage conversion info */
  FIND FIRST ttpromsgs NO-LOCK WHERE
      ttpromsgs.msgfile = cmsgfile NO-ERROR.
  IF NOT AVAILABLE ttpromsgs THEN
  DO:
      /* something in checkPromsgsFile failed - error */
      RETURN. 
  END.
  /* perform codepage conversion if possible and necessary */
  IF ttpromsgs.msgcp <> ? AND ttpromsgs.msgcp <> "undefined" THEN
      cmsg = CODEPAGE-CONVERT(cmsg,SESSION:CHARSET,ttpromsgs.msgcp).

  CREATE ttmsgs.
  ASSIGN 
      ttmsgs.msgfno = ttpromsgs.msgfno
      ttmsgs.msgno = imsgno
      ttmsgs.msgtext = cmsg
      ttmsgs.imsgid = imsgseq
      /* imsgseq = imsgseq + 1 */ .

  /* parse the message */
  /* if msg starts with %W, %L, %G, %B, ignore these params */  
  IF cmsg BEGINS "%" THEN
  DO:
      cstart = SUBSTRING(cmsg,2,1).
      IF (COMPARE(cstart,"=","L","case-sensitive") OR
          COMPARE(cstart,"=","G","case-sensitive") OR
          COMPARE(cstart,"=","W","case-sensitive") OR
          COMPARE(cstart,"=","B","case-sensitive")) THEN
          cmsg = SUBSTRING(cmsg,3).
  END.
  
  /* remove any %r */
  cmsg = REPLACE(cmsg,"%r","").
  
  inumparts = NUM-ENTRIES(cmsg,"%":U).
  DO ipart = 0 TO inumparts :
      ASSIGN
          clastpart = (IF ipart = 0 THEN "" ELSE ENTRY(ipart,cmsg,"%":U))
          cpart = (IF ipart < inumparts THEN 
              ENTRY(ipart + 1,cmsg,"%":U)
              ELSE
              "")
          ilen = LENGTH(clastpart).
      IF (ipart > 0) THEN
          cpart = SUBSTRING(cpart,2).
      CREATE ttmsgpart.
      ASSIGN 
          ttmsgpart.imsgid = imsgseq
          ttmsgpart.ipart = ipart
          ttmsgpart.ilen = ilen
          ttmsgpart.cnext = cpart.
  END.
  
  imsgseq = imsgseq + 1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE translatePromsg Include 
PROCEDURE translatePromsg :
/*------------------------------------------------------------------------------
  Purpose:     Translates a promsg from one language to another. Copies
               substitutions, where possible from source promsg to 
               target promsg.
  Parameters:  
    coldmsg  - [IN] text of message in source language
    csrcmsgs - [IN] source promsgs file
    ctrgmsgs - [IN] target promsgs file
    cnewmsg  - [OUT] text of message in target language (inluding substitutions)
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM coldmsg AS CHAR NO-UNDO.
  DEF INPUT PARAM csrcmsgs AS CHAR NO-UNDO.
  DEF INPUT PARAM ctrgmsgs AS CHAR NO-UNDO.
  DEF OUTPUT PARAM cnewmsg AS CHAR NO-UNDO.

  DEFINE VARIABLE imsgno AS INTEGER    NO-UNDO.
  DEFINE VARIABLE isrcid AS INTEGER    NO-UNDO.
  DEFINE VARIABLE itrgid AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ipos1 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ipos2 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ctmpmsg AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOK AS LOGICAL    NO-UNDO.
  DEFINE BUFFER bmsgpart FOR ttmsgpart.

  /* check to make sure the promsgs files are valid */
  RUN checkPromsgsFile(INPUT csrcmsgs,OUTPUT lOK).
  IF NOT lOK THEN
  DO:
      RETURN. /* error, invalid promsgs file */
  END.
  RUN checkPromsgsFile(INPUT ctrgmsgs,OUTPUT lOK).
  IF NOT lOK THEN
  DO:
      RETURN. /* error, invalid promsgs file */
  END.

  /* trim any spaces from the start or end of the old message */
  coldmsg = TRIM(coldmsg).

  /* by default, set new message to old message */
  cnewmsg = coldmsg.
  
  RUN getPromsgNum (INPUT coldmsg, OUTPUT imsgno).

  IF imsgno <= 0 THEN RETURN.

  FIND FIRST ttpromsgs NO-LOCK WHERE
      ttpromsgs.msgfile = csrcmsgs NO-ERROR.
  IF NOT AVAILABLE ttpromsgs THEN 
  DO:
      RETURN. /* something weird happened here, error */
  END.
  /* get the source message */
  FIND FIRST ttmsgs NO-LOCK WHERE
      ttmsgs.msgfno = ttpromsgs.msgfno AND
      ttmsgs.msgno = imsgno NO-ERROR.
  IF NOT AVAILABLE ttmsgs THEN
  DO:
      RUN loadPromsg(INPUT csrcmsgs,INPUT imsgno).
      FIND FIRST ttmsgs NO-LOCK WHERE
          ttmsgs.msgfno = ttpromsgs.msgfno AND
          ttmsgs.msgno = imsgno NO-ERROR.
      IF NOT AVAILABLE ttmsgs THEN 
      DO:
          RETURN.
      END.
  END.
  isrcid = ttmsgs.imsgid.

  FIND FIRST ttpromsgs NO-LOCK WHERE
      ttpromsgs.msgfile = ctrgmsgs NO-ERROR.
  IF NOT AVAILABLE ttpromsgs THEN 
  DO:
      RETURN. /* something weird happened here, error */
  END.
  /* get the target message */
  FIND FIRST ttmsgs NO-LOCK WHERE
      ttmsgs.msgfno = ttpromsgs.msgfno AND
      ttmsgs.msgno = imsgno NO-ERROR.
  IF NOT AVAILABLE ttmsgs THEN
  DO:
      RUN loadPromsg(INPUT ctrgmsgs,INPUT imsgno).
      FIND FIRST ttmsgs NO-LOCK WHERE
          ttmsgs.msgfno = ttpromsgs.msgfno AND
          ttmsgs.msgno = imsgno NO-ERROR.
      IF NOT AVAILABLE ttmsgs THEN 
      DO:
          RETURN.
      END.
  END.
  itrgid = ttmsgs.imsgid.

  /* now, parse src message for params */
  FOR EACH ttmsgpart NO-LOCK WHERE
      ttmsgpart.imsgid = isrcid 
      BY ttmsgpart.ipart:
      FIND FIRST bmsgpart NO-LOCK WHERE
          bmsgpart.imsgid = itrgid AND
          bmsgpart.ipart = ttmsgpart.ipart NO-ERROR.
      /* move past the current msg part */
      IF (ttmsgpart.ilen > 0) THEN
          coldmsg = SUBSTRING(coldmsg,ttmsgpart.ilen).      
      IF NOT AVAILABLE bmsgpart THEN
      DO:
          LEAVE.
      END.
      IF ttmsgpart.ipart > 0 THEN
      DO:
          /* locate the next part of the message */
          ipos2 = INDEX(coldmsg,ttmsgpart.cnext).
          IF ipos2 > 0 THEN
          DO:
              /* build the new message part */
              ASSIGN 
                  ctmpmsg = ctmpmsg + 
                      SUBSTRING(coldmsg,1,ipos2 - 1) +
                      bmsgpart.cnext.
              /* move after the param */
              coldmsg = SUBSTRING(coldmsg,ipos2).
          END.
          ELSE 
          DO:
              /* if message starts with a substitution */
              IF ttmsgpart.ipart = 1 THEN
              DO:
                  /* skip straight to the next message part */
                  NEXT.
              END.
              ELSE
              DO:
                  LEAVE. /* failed to find next part of message */
              END.
          END.
      END.
      ELSE
          /* first part of the message */
          ctmpmsg = bmsgpart.cnext.
  END.

  cnewmsg = ctmpmsg.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

