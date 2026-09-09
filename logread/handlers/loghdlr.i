&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : logread/handlers/loghdlr.i
    Purpose     : Utility routines for use by all handlers

    Syntax      : {logread/handlers/loghdlr.i}

    Description : Developers of new handlers can include this log to 
                  implement some of the LogRead Handler API, and to
                  provide useful support functionality.

    Author(s)   : 
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAM hparent AS HANDLE NO-UNDO.
DEF OUTPUT PARAM cLogType AS CHAR NO-UNDO.
DEF OUTPUT PARAM cTypeName AS CHAR NO-UNDO.

DEF TEMP-TABLE ttqry NO-UNDO
    FIELD qryname AS CHAR
    FIELD qrytext AS CHAR.

/* hack, to get around 9.1D not handling array parameters.
 * declare these as global to the procedure, so we can access them
 * from multiple functions during failure on load */
DEFINE VARIABLE chist AS CHARACTER EXTENT 4 NO-UNDO.
DEFINE VARIABLE ihistidx AS INTEGER INIT 1 NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD abortLoad Include 
FUNCTION abortLoad RETURNS LOGICAL
  ( INPUT lcancelled AS LOGICAL, 
    INPUT imsgs AS INT, 
    INPUT cerrmsg AS CHAR,
    OUTPUT labort AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addQuery Include 
PROCEDURE addQuery PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Adds a query to the list of queries provided by this handler
  Parameters:  cname - name used to identify query
               cqrytext - 4GL query text
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM cname AS CHAR NO-UNDO.
  DEF INPUT PARAM cqrytext AS CHAR NO-UNDO.

  FIND FIRST ttqry NO-LOCK WHERE
      ttqry.qryname = cname NO-ERROR.
  IF AVAILABLE ttqry THEN RETURN.
  CREATE ttqry.
  ASSIGN 
      ttqry.qryname = cname
      ttqry.qrytext = cqrytext.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogType Include 
PROCEDURE getLogType :
/*------------------------------------------------------------------------------
  Purpose:     Returns the log type of this handler
  Parameters:  <none>
  Notes:       Part of the LogRead Handler API
------------------------------------------------------------------------------*/
  DEF OUTPUT PARAM coLogType AS CHAR NO-UNDO.
  coLogType = cLogType.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQuery Include 
PROCEDURE getQuery :
/*------------------------------------------------------------------------------
  Purpose:     Returns the 4GL query text of the selected query.
               If ? or "" are passed in, returns the list of query names.
  Parameters:  cqryname - name of query to get the 4GL text for
                          (? or "" for list of query names)
               cqrystring - returns 4GL query text (or CSV list of query names)
  Notes:       Part of the LogRead Handler API
------------------------------------------------------------------------------*/
    DEF INPUT PARAM cqryname AS CHAR NO-UNDO.
    DEF OUTPUT PARAM cqrystring AS CHAR NO-UNDO.

    DEFINE VARIABLE lfirst AS LOGICAL INIT YES   NO-UNDO.

    IF cqryname = ? OR cqryname = "" THEN
    DO:
        FOR EACH ttqry:
            ASSIGN 
                cqryString = cqrystring + (IF lfirst THEN "" ELSE ",") + 
                    ttqry.qryname
                lfirst = FALSE.
        END.
    END.
    ELSE
    DO:
        FIND FIRST ttqry NO-LOCK WHERE
            ttqry.qryname = cqryname NO-ERROR.
        IF AVAILABLE ttqry THEN
            cqrystring = ttqry.qrytext.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION abortLoad Include 
FUNCTION abortLoad RETURNS LOGICAL
  ( INPUT lcancelled AS LOGICAL, 
    INPUT imsgs AS INT, 
    INPUT cerrmsg AS CHAR,
    OUTPUT labort AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Displays a dialog on load errors, or if user cancels load.
            Returns true if user wants to stop the load, otherwise false.
            labort is set to true if the user wants to cancel the load and
            delete the log from memory. labort is set to false if the user
            wants to stop the load, but keep the log file contents in memory.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE clines AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iline AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iidx AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lresponse AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE ctitle AS CHARACTER  NO-UNDO.

  labort = FALSE.

  /* if not cancelled, this is an error.
   * get the error text */
  IF (NOT lcancelled) THEN
  DO:
      clines = "Errors:" + CHR(13).
      IF (cerrmsg <> ?) THEN
          clines = clines + cerrmsg + CHR(13).
      DO iidx = 1 TO ERROR-STATUS:NUM-MESSAGES:
          clines = clines + ERROR-STATUS:GET-MESSAGE(iidx) + CHR(13).
      END.

      /* add the current message */
      clines = clines + CHR(13) + 
          "Loading message: ":U + chist[ihistidx] + CHR(13).
  END.

  /* loaded messages */
  ASSIGN 
      ctitle = (IF lcancelled THEN "User Cancelled Load" ELSE "ERROR")
      clines = clines + "Log Messages Loaded: ":U + STRING(imsgs) + CHR(13).

  /* combine all the history lines together, 
   * except chist[ihistidx], which contains the current line */
  clines = clines + "Last Messages:":U + CHR(13).
  iidx = ihistidx.
  DO iline = 1 TO 3:
      iidx = (IF iidx = 4 THEN 1 ELSE iidx + 1).
      IF (chist[iidx] <> ?) THEN
          clines = clines + CHR(13) + chist[iidx].
  END.

  MESSAGE
      clines SKIP(1)
      "Continue Loading?":U SKIP (1)
      "Clicking Yes will cause LogRead to continue loading the log file" +
      (IF NOT lcancelled THEN ", ignoring this line." ELSE ".") SKIP
      "Clicking No will cause LogRead to stop loading the log file, but will leave the log in memory." SKIP
      "Clicking Cancel will cause LogRead to stop loading the log file, and remove the log file from memory." SKIP
      VIEW-AS ALERT-BOX 
      BUTTONS YES-NO-CANCEL
      TITLE ctitle
      UPDATE lresponse.

  IF (lresponse = ?) THEN labort = TRUE.

  RETURN (IF lresponse = TRUE THEN FALSE ELSE TRUE).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

