&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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
         HEIGHT             = 3.96
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE INPUT PARAMETER pKeyValue AS CHAR.
DEFINE INPUT PARAMETER pEvent AS CHAR.
DEFINE INPUT PARAMETER pDataRecord AS RAW.
DEFINE OUTPUT PARAMETER L-FLG AS LOGICAL NO-UNDO.

DISABLE TRIGGERS FOR LOAD OF ccbccaja.
DEFINE VAR iErrores AS INT INIT 0 NO-UNDO.

L-FLG = NO.

RLOOP:
DO TRANSACTION ON STOP UNDO, RETRY:
    IF RETRY THEN iErrores = iErrores + 1.
    IF iErrores > 5 THEN UNDO, LEAVE RLOOP.
    FIND ccbccaja WHERE ccbccaja.codcia = INTEGER(SUBSTRING(pkeyvalue,1,3)) AND
         ccbccaja.coddoc = SUBSTRING(pkeyvalue,4,3) AND
         ccbccaja.nrodoc = SUBSTRING(pkeyvalue,7)
         EXCLUSIVE-LOCK NO-ERROR.
    CASE pEvent:
        WHEN 'DELETE' THEN DO:
            IF AVAILABLE ccbccaja THEN DO:
                DELETE ccbccaja.
            END.
            L-FLG = YES.    
        END.
        WHEN 'WRITE' THEN DO:
            IF NOT AVAILABLE ccbccaja THEN CREATE ccbccaja.
            RAW-TRANSFER pDATARECORD TO ccbccaja.
            L-FLG = YES.
        END.
    END CASE.
    CATCH eError AS PROGRESS.Lang.Error:
        MESSAGE eError:GetMessage(1) VIEW-AS ALERT-BOX ERROR.
        DELETE OBJECT eError.
        UNDO, LEAVE RLOOP.
    END CATCH.
END.
IF AVAILABLE(ccbccaja) THEN RELEASE ccbccaja.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


