&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : logread/handlers/hassrv91c.p
    Purpose     : Log Type Handler for AppServer server log files, 
                  9.1C and greater

    Syntax      :

    Description :

    Author(s)   : 
    Created     :
    Notes       : Conforms to the LogRead Handler API
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* basic log handler info */
{logread/handlers/loghdlr.i}

/* include enhanced logging */
{logread/handlers/ublog.i &tablename = "assrv91c" }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

ASSIGN
  cLogType = "assrv91c"
  cTypeName = "AppServer Server Log File <=9.1C".

RUN addQuery("ThreadByTime","by tid by logdate by logtime").

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-guessType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE guessType Procedure 
PROCEDURE guessType :
/*------------------------------------------------------------------------------
  Purpose:     Returns whether this log could be an AppServer server log file, 
               based on the filename.
  Parameters:  cLogFile - [input] name of log file to load
               lHandled - [output] TRUE if name indicates this is an
                          AppServer server log file, else FALSE.
  Notes:       This is part of the LogRead Handler API
------------------------------------------------------------------------------*/
    DEF INPUT PARAM cLogFile AS CHAR NO-UNDO.
    DEF OUTPUT PARAM lHandled AS LOG NO-UNDO.
    IF cLogFile MATCHES "*ws*.server.log" THEN
        lhandled = YES.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

