&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : logread/logcp.i
    Purpose     : handles all codepage related functionality for LogRead

    Syntax      : {logread/logcp.i}

    Description :

    Author(s)   : 
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE VARIABLE cConvcp AS CHARACTER  NO-UNDO.

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

RUN getCPConversions(SESSION:CHARSET,OUTPUT cconvcp).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkCPConversion Include 
PROCEDURE checkCPConversion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM ctrgcp AS CHAR NO-UNDO.
    DEF OUTPUT PARAM coutcp AS CHAR NO-UNDO.

    coutcp = IF CAN-DO(cconvcp,ctrgcp) THEN ctrgcp ELSE SESSION:CHARSET.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCodepageList Include 
PROCEDURE getCodepageList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF OUTPUT PARAM cCPList AS CHAR NO-UNDO.
  
  IF cconvcp = "" THEN
      RUN getCPConversions(SESSION:CHARSET,OUTPUT cconvcp).
  cCPList = cconvcp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCPConversions Include 
PROCEDURE getCPConversions :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM csrccp AS CHAR NO-UNDO.
    DEF OUTPUT PARAM cconvcps AS CHAR NO-UNDO.
    DEFINE VARIABLE icnt AS INTEGER    NO-UNDO.
    DEFINE VARIABLE ccp AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE ctest AS CHARACTER  NO-UNDO.
    
    DO icnt = 1 TO NUM-ENTRIES(GET-CODEPAGES):
        ccp = ENTRY(icnt,GET-CODEPAGES).
        IF ccp = "undefined":U THEN NEXT.
        IF ccp = csrccp THEN NEXT.
        ASSIGN ctest = CHR(65,SESSION:CHARSET,ccp) NO-ERROR.
        IF ctest <> "":U THEN
            cconvcps = cconvcps + ccp + ",":U.
    END.
    
    cconvcps = cconvcps + SESSION:CHARSET.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

