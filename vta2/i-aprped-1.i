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

DEF VAR k AS INT.

IF {&browse-name}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN DO:
    MESSAGE 'Debe seleccionar al menos 1 registro' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.
MESSAGE 'Procedemos con la aprobación?'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE rpta-1 AS LOG.
IF rpta-1 = NO THEN RETURN 'ADM-ERROR'.
DO WITH FRAME {&FRAME-NAME}
    TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    CICLO:
    DO k = 1 TO {&browse-name}:NUM-SELECTED-ROWS:
        IF {&browse-name}:FETCH-SELECTED-ROW(k) THEN DO:
            /* Buscamos deudas pendientes */
            FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
                AND LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL,LET,N/D,CHQ') > 0
                AND Ccbcdocu.flgest = 'P'
                AND Ccbcdocu.codcli = Faccpedi.codcli
                AND Ccbcdocu.fchvto + 1 < TODAY
                NO-LOCK NO-ERROR.
            IF AVAILABLE Ccbcdocu THEN DO:
                MESSAGE 'El cliente tiene una deuda atrazada:' SKIP
                    'Cliente:' Faccpedi.nomcli SKIP
                    'Documento:' Ccbcdocu.coddoc Ccbcdocu.nrodoc SKIP
                    'Vencimiento:' Ccbcdocu.fchvto SKIP
                    'Continúa con la aprobación?'
                    VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
                    UPDATE Rpta AS LOG.
                IF Rpta = NO THEN NEXT CICLO.
            END.
            FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Faccpedi THEN NEXT CICLO.
            ASSIGN
                Faccpedi.Flgest = 'P'
                Faccpedi.UsrAprobacion = s-user-id
                Faccpedi.FchAprobacion = TODAY.
            /* Provincias pasa a APROBACION POR JEFE DE LOGISTICA */
            IF s-FlgEst = "X" AND LOOKUP(Faccpedi.codven, '015,017,173') > 0 
                THEN Faccpedi.FlgEst = "WL".
            /* RHC 01.12.2011 CHEQUEO DE PRECIOS BAJO EL MARGEN */
            /* ************************************************ */
            /* Por precios bajos pasa APROBACION GERENTE GENERAL */
            IF s-FlgEst = "W" /*AND LOOKUP(Faccpedi.codven, '015,017,173,900,901,902') > 0 */
                THEN Faccpedi.FlgEst = "WX".
            /* ******************************** */
            FOR EACH FacDPedi OF Faccpedi :
                ASSIGN FacDPedi.Flgest = Faccpedi.Flgest.    /* <<< OJO <<< */
            END.

            /* TRACKING */
            RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                                    Faccpedi.CodDiv,
                                    Faccpedi.CodDoc,
                                    Faccpedi.NroPed,
                                    s-User-Id,
                                    'ANP',
                                    'P',
                                    DATETIME(TODAY, MTIME),
                                    DATETIME(TODAY, MTIME),
                                    Faccpedi.CodDoc,
                                    Faccpedi.NroPed,
                                    Faccpedi.CodDoc,
                                    Faccpedi.NroPed).
        END.
    END.
    IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
END.
RUN dispatch IN THIS-PROCEDURE ('open-query').
RETURN "OK".

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
         HEIGHT             = 4.31
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


