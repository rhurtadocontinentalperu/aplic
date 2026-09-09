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

DEF VAR k AS INT NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.
DEF BUFFER COTIZACION FOR Faccpedi.

IF {&browse-name}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN DO:
    MESSAGE 'Debe seleccionar al menos 1 registro' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.
MESSAGE 'Procedemos con la aprobación?'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE rpta-1 AS LOG.
IF rpta-1 = NO THEN RETURN 'ADM-ERROR'.
CICLO:
DO k = 1 TO {&browse-name}:NUM-SELECTED-ROWS ON ERROR UNDO, NEXT ON STOP UNDO, NEXT:
    IF NOT {&browse-name}:FETCH-SELECTED-ROW(k) THEN NEXT.
    FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccpedi THEN NEXT CICLO.
    FIND COTIZACION WHERE COTIZACION.codcia = Faccpedi.codcia
        AND COTIZACION.coddiv = Faccpedi.coddiv
        AND COTIZACION.coddoc = Faccpedi.codref
        AND COTIZACION.nroped = Faccpedi.nroref
        NO-LOCK NO-ERROR.
    ASSIGN
        Faccpedi.Flgest = 'P'
        Faccpedi.UsrAprobacion = s-user-id
        Faccpedi.FchAprobacion = TODAY.
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
                            'ANPGG',
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed).
    /* RHC 13.07.2012 GENERACION AUTOMATICA DE ORDENES DE DESPACHO */
    /* RHC 14/11/2016 Se puede crear una O/D o una OTR */
    DEF VAR x-FlgSit AS CHAR INIT "" NO-UNDO.
    DEF VAR hProc AS HANDLE NO-UNDO.
    DEF VAR pComprobante AS CHAR NO-UNDO.
    RUN vtagn/ventas-library PERSISTENT SET hProc.
    pMensaje = "".
    CASE TRUE:
        WHEN Faccpedi.CrossDocking = NO THEN DO:
            /* 10/04/2025 Felix Perez: La HPK siempre se genera, la PHR es condicional */
            RUN VTA_Genera-OD-v2 IN hProc ( ROWID(Faccpedi), OUTPUT pComprobante, OUTPUT pMensaje).
            /*RUN VTA_Genera-OD IN hProc (ROWID(Faccpedi), OUTPUT pComprobante, OUTPUT pMensaje).*/
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO CICLO, LEAVE CICLO.
        END.
        WHEN Faccpedi.CrossDocking = YES THEN DO:
            RUN VTA_Genera-OTR IN hProc (ROWID(Faccpedi), OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO CICLO, LEAVE CICLO.
        END.
    END CASE.
    DELETE PROCEDURE hProc.
    FIND CURRENT Faccpedi NO-LOCK NO-ERROR.
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


