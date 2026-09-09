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
DEFINE INPUT PARAMETER pKeyValue AS CHAR.
DEFINE INPUT PARAMETER pEvent AS CHAR.
DEFINE INPUT PARAMETER pDataRecord AS RAW.
DEFINE OUTPUT PARAMETER L-FLG AS LOGICAL NO-UNDO.

DISABLE TRIGGERS FOR LOAD OF vtadtickets.
DEFINE VAR iErrores AS INT INIT 0 NO-UNDO.

L-FLG = NO.

RLOOP:
DO TRANSACTION ON STOP UNDO, RETRY:
    IF RETRY THEN iErrores = iErrores + 1.
    IF iErrores > 5 THEN UNDO, LEAVE RLOOP.
    FIND vtadtickets WHERE vtadtickets.codcia = INTEGER (SUBSTRING(pkeyvalue,1,3)) 
        AND vtadtickets.codpro = SUBSTRING(pkeyvalue,4,11)
        AND vtadtickets.producto = SUBSTRING(pkeyvalue,15,8)
        AND vtadtickets.nrotck = SUBSTRING(pkeyvalue,23)
        EXCLUSIVE-LOCK NO-ERROR.
    CASE PEvent:
        WHEN 'DELETE' THEN DO:
            IF AVAILABLE vtadtickets THEN DO:
                DELETE vtadtickets.
            END.
            L-FLG = YES.    
        END.
        WHEN 'WRITE' THEN DO:
            IF NOT AVAILABLE vtadtickets THEN CREATE vtadtickets.
            RAW-TRANSFER pDATARECORD TO vtadtickets.
            L-FLG = YES.
        END.
    END CASE.
    CATCH eError AS PROGRESS.Lang.Error:
        MESSAGE eError:GetMessage(1) VIEW-AS ALERT-BOX ERROR.
        DELETE OBJECT eError.
        UNDO, LEAVE RLOOP.
    END CATCH.
END.
IF AVAILABLE(vtadtickets) THEN RELEASE vtadtickets.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


