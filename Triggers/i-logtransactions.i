&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/*
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR pRCID AS INT.

&IF DEFINED(TipoEvento) &THEN
CREATE LogTransactions.
ASSIGN
    logtransactions.logdate = NOW
    logtransactions.tablename = "{&TableName}"
    logtransactions.event = pEvento
    logtransactions.Usuario = s-user-id
    logtransactions.NumId = pRCID.
RAW-TRANSFER {&TableName} TO logtransactions.datarecord.
&ELSE
CREATE LogTransactions.
ASSIGN
    logtransactions.logdate = NOW
    logtransactions.tablename = "{&TableName}"
    logtransactions.event = "{&Event}"
    logtransactions.Usuario = s-user-id
    logtransactions.NumId = pRCID.
RAW-TRANSFER {&TableName} TO logtransactions.datarecord.
&ENDIF

*/

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
         HEIGHT             = 4.08
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


