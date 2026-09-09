&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : logread/qryval.i
    Purpose     : Provides validation for queries entered in the
                  Log Filter dialog and Search diaog

    Syntax      : {logread/qryval.i <TRUE|FALSE> }
                  TRUE indicates this was included in the Search Dialog
                  FALSE indicates this was included in the Log Filter Dialog

    Description :

    Author(s)   : 
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cleanQuery Include 
FUNCTION cleanQuery RETURNS CHARACTER
  ( INPUT cqrytxt AS CHAR )  FORWARD.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateQuery Include 
PROCEDURE validateQuery :
/*------------------------------------------------------------------------------
  Purpose:     Validates the query text, against the log file temp-table.
  Parameters:  
    htt     - [IN] log file temp-table
    cqrytxt - [IN] query to validate against the temp-table
    lOK     - [OUT] TRUE if cqrytxt is valid, otherwise FALSE
    cerrtxt - [OUT] text of the validation error.
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM htt AS HANDLE NO-UNDO.
  DEF INPUT PARAM cqrytxt AS CHAR NO-UNDO.
  DEF OUTPUT PARAM lOK AS LOG INIT NO NO-UNDO.
  DEF OUTPUT PARAM cerrtxt AS CHAR NO-UNDO.

  DEFINE VARIABLE hqry AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hbuf AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ctxt AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ictr AS INTEGER    NO-UNDO.

  /* clean up the query */
  ctxt = cleanQuery(cqrytxt).

/* prepare a new query with this criteria */
  CREATE BUFFER hbuf FOR TABLE htt:DEFAULT-BUFFER-HANDLE.
  CREATE QUERY hqry.
  hqry:SET-BUFFERS(hbuf).
  lOK = hqry:QUERY-PREPARE("for each " + hbuf:NAME + " where " + ctxt) NO-ERROR.
  IF NOT lOK THEN
  DO:
      cerrtxt = "Error in query ~"" + ctxt + "~":" + CHR(10).
      DO ictr = 1 TO ERROR-STATUS:NUM-MESSAGES:
          cerrtxt = cerrtxt + 
              ERROR-STATUS:GET-MESSAGE(ictr) + CHR(10).
      END.
  END.
  DELETE OBJECT hbuf.
  DELETE OBJECT hqry.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cleanQuery Include 
FUNCTION cleanQuery RETURNS CHARACTER
  ( INPUT cqrytxt AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Removes leading spaces and WHERE keyword
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE ctxt AS CHARACTER  NO-UNDO.

    /* If search query, remove any BY statements */
    IF {1} THEN
    DO:
        /* clear any search criteria that begins with "BY" */
        IF (cqrytxt BEGINS "by ") THEN cqrytxt = "".
        /* remove the rest of the criteria starting at " BY " */
        ELSE IF (INDEX(cqrytxt, " by ") > 0) THEN
            cqrytxt = SUBSTRING(cqrytxt,1,INDEX(cqrytxt, " by ") - 1).
    END.

    /* remove any leading spaces */
    ctxt = trim(cqrytxt).
    /* remove any where clause */
    IF ctxt BEGINS "where " THEN
        ctxt = trim(SUBSTRING(ctxt,7)).
    IF ctxt = "" THEN ctxt = "TRUE".

    RETURN ctxt.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

