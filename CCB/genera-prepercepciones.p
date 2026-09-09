&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Calcular las pre-percepciones

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEF INPUT PARAMETER CodDocCja AS CHAR.
DEF INPUT PARAMETER NroDocCja AS CHAR.

DEF SHARED VAR s-codcia AS INT.

FIND Ccbccaja WHERE Ccbccaja.codcia = s-codcia
    AND Ccbccaja.coddoc = CodDocCja
    AND Ccbccaja.nrodoc = NroDocCja
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbccaja THEN RETURN 'OK'.
IF LOOKUP(Ccbccaja.Tipo, 'MOSTRADOR,CANCELACION') = 0 THEN RETURN 'OK'.

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
         HEIGHT             = 4.35
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Primero los documentos de CARGO */
    FOR EACH Ccbdcaja OF Ccbccaja NO-LOCK, 
        FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Ccbdcaja.codcia
        AND Ccbcdocu.coddoc = Ccbdcaja.codref AND Ccbcdocu.nrodoc = Ccbdcaja.nroref:
        RUN ccb/control-prepercepcion-cargos (ROWID(Ccbcdocu), Ccbccaja.CodDiv, Ccbccaja.CodDoc, Ccbccaja.NroDoc ) 
            NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    END.
    /* Segundo los documentos de ABONO */
    FOR EACH Ccbdmov NO-LOCK WHERE Ccbdmov.codcia = Ccbccaja.codcia
        AND Ccbdmov.coddiv = Ccbccaja.coddiv
        AND Ccbdmov.coddoc = "N/C"
        AND Ccbdmov.codref = Ccbccaja.coddoc
        AND Ccbdmov.nroref = Ccbccaja.nrodoc,
        FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Ccbdmov.codcia
        AND Ccbcdocu.coddoc = Ccbdmov.coddoc
        AND Ccbcdocu.nrodoc = Ccbdmov.nrodoc:
        RUN ccb/control-prepercepcion-abonos (ROWID(Ccbcdocu), Ccbccaja.CodDiv, Ccbccaja.CodDoc, Ccbccaja.NroDoc ) 
            NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    END.
    /* Tercero los comprobantes de PRE-PERCEPCION */
    RUN ccb/control-prepercepcion-final (Ccbccaja.CodDiv, Ccbccaja.CodDoc, Ccbccaja.NroDoc).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


