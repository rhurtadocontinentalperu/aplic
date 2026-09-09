&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Extornar A/C

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       : Hay N/C que se crean para amortizar A/C
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pRowid AS ROWID.

FIND Ccbcdocu WHERE ROWID(Ccbcdocu) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbcdocu THEN DO:
    MESSAGE 'NO se pudo posicionar el puntero correctamente' SKIP
        'procedimiento vta2/extorna-ac'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

DEF BUFFER B-DOCU FOR Ccbcdocu.

FOR EACH Ccbdmov WHERE Ccbdmov.codcia = Ccbcdocu.codcia
    AND Ccbdmov.coddoc = "A/C"
    AND Ccbdmov.codref = Ccbcdocu.coddoc
    AND Ccbdmov.nroref = Ccbcdocu.nrodoc
    TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND B-DOCU WHERE B-DOCU.codcia = Ccbdmov.codcia
        AND B-DOCU.coddoc = Ccbdmov.coddoc
        AND B-DOCU.nrodoc = Ccbdmov.nrodoc
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE B-DOCU THEN DO:
        MESSAGE 'No se pudo bloquear el' Ccbdmov.coddoc Ccbdmov.nrodoc SKIP
            'procedimiento vta2/extorna-ac'
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        B-DOCU.flgest = "P"
        B-DOCU.sdoact = B-DOCU.sdoact + Ccbdmov.imptot
        B-DOCU.fchcan = ?.
    DELETE Ccbdmov.
END.

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


