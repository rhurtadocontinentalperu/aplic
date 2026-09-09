&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-DTPED FOR vtadtrkped.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : pTracking-01
    Purpose     : Nuevo control de tracking

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pCodCia AS INT.     /* Código de empresa */
DEF INPUT PARAMETER pCodDiv AS CHAR.    /* Division de seguimiento de tracking */
DEF INPUT PARAMETER pCodDoc AS CHAR.    /* PED */
DEF INPUT PARAMETER pNroPed AS CHAR.    /* Número de pedido */
DEF INPUT PARAMETER pUsuario AS CHAR.   /* Usuario responsable */
DEF INPUT PARAMETER pCodUbi AS CHAR.    /* Detalle del Ciclo */
DEF INPUT PARAMETER pFlgSit AS CHAR.    /* Situacion (P) en proceso, (A) anulacion */
DEF INPUT PARAMETER pFechaI AS DATETIME.    /* Inicio del ciclo */
DEF INPUT PARAMETER pFechaT AS DATETIME.    /* Termino del ciclo */
DEF INPUT PARAMETER pCodRef1 AS CHAR.    /* Documento Actual */
DEF INPUT PARAMETER pNroRef1 AS CHAR.    /* Documento Actual */
DEF INPUT PARAMETER pCodRef2 AS CHAR.    /* Documento Anterior */
DEF INPUT PARAMETER pNroRef2 AS CHAR.    /* Documento Anterior */

DEF VAR pDivTrk AS CHAR NO-UNDO.        /* Division de flujo de tracking */

RETURN 'OK'.

/* RHC 18.10.09 FILTROS */
IF pCodRef1 = 'TCK' THEN RETURN 'OK'.       /* NO Tickets */

CASE pCodDoc:
    WHEN 'P/M' THEN DO:
        FIND Faccpedm WHERE Faccpedm.codcia = pcodcia
            AND Faccpedm.coddoc = pcoddoc
            AND Faccpedm.nroped = pnroped
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccpedm THEN RETURN 'OK'.
        ASSIGN
            pDivTrk = Faccpedm.coddiv.
        IF faccpedm.fchped < 01/18/10 THEN RETURN 'OK'.
    END.
    WHEN 'PED' THEN DO:
        FIND Faccpedi WHERE Faccpedi.codcia = pcodcia
            AND Faccpedi.coddoc = pcoddoc
            AND Faccpedi.nroped = pnroped
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccpedi THEN RETURN 'OK'.
        ASSIGN
            pDivTrk = Faccpedi.coddiv.
        IF faccpedi.fchped < 01/18/10 THEN RETURN 'OK'.
        /* RHC 25.03.10 NO STANDFORD NI CONTI */
        IF Faccpedi.codcli = '20511358907'
            OR Faccpedi.codcli = '20100038146' THEN RETURN 'OK'.
    END.
    OTHERWISE RETURN 'OK'.
END CASE.

/* Verificamos si la división está configurada el tracking */
FIND VtaTrack03 WHERE Vtatrack03.codcia = pCodCia
    AND Vtatrack03.coddiv = pDivTrk
    AND Vtatrack03.coddoc = pCodDoc
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Vtatrack03 THEN DO:
    RETURN 'OK'.
END.

/* Verificamos si el detalle del ciclo está configurado en el tracking */
FIND LAST Vtatrack02 WHERE 
    VtaTrack02.Ciclo  = VtaTrack03.Ciclo AND
    VtaTrack02.CodCia = pCodCia AND 
    VtaTrack02.CodUbic2 = pCodUbi
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Vtatrack02 THEN DO:
    RETURN 'OK'.
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
   Temp-Tables and Buffers:
      TABLE: B-DTPED B "?" ? INTEGRAL vtadtrkped
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.23
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
FIND LAST Vtatrack02 WHERE 
    VtaTrack02.Ciclo  = VtaTrack03.Ciclo AND
    VtaTrack02.CodCia = pCodCia
    NO-LOCK NO-ERROR.

IF LOOKUP(pFlgSit, 'A,S') = 0 THEN DO:
    IF pCodUbi = VtaTrack02.CodUbic2 THEN pFlgSit = 'C'.    /* Cierre del Tracking */
END.

CASE pFlgSit:
    WHEN 'A' THEN DO:       /* ANULACION */
        RUN Anulacion-Tracking.
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    END.
    WHEN 'C' THEN DO:       /* CIERRE */
        RUN Cierre-Tracking.
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    END.
    WHEN 'S' THEN DO:       /* SUSPENDER */
        RUN Suspender-Tracking.
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    END.
    OTHERWISE DO:
        RUN Actualiza-Tracking.
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    END.
END CASE.

RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Actualiza-Tracking) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Tracking Procedure 
PROCEDURE Actualiza-Tracking :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* buscamos registro de control */
DEF VAR pCodUbiIni LIKE VtaTrack02.CodUbic1 NO-UNDO.

FIND FIRST Vtatrack02 WHERE 
    VtaTrack02.Ciclo  = VtaTrack03.Ciclo AND
    VtaTrack02.CodCia = pCodCia
    NO-LOCK NO-ERROR.
pCodUbiIni = VtaTrack02.CodUbic1.

IF pCodUbi <> pCodUbiIni THEN DO:
    FIND VtaCTrkPed WHERE Vtactrkped.codcia = pcodcia
        AND Vtactrkped.coddiv = pcoddiv
        AND Vtactrkped.coddoc = pcoddoc
        AND Vtactrkped.nroped = pnroped
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaCTrkPed THEN DO:
        MESSAGE 'Cabecera del tracking NO registrada'
            VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
        RETURN 'ADM-ERROR'.
    END.
    /* hubo un caso raro con el PED 015100126 ¿quién malogró el ciclo? */
    /* simulo que todo está bien */
    FIND LAST Vtadtrkped WHERE Vtadtrkped.codcia = pcodcia
        AND Vtadtrkped.coddiv = pcoddiv
        AND Vtadtrkped.coddoc = pcoddoc
        AND Vtadtrkped.nroped = pnroped
        AND Vtadtrkped.flgsit <> 'A'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtadtrkped THEN RETURN.
END.

FIND LAST Vtatrack02 WHERE 
    VtaTrack02.Ciclo  = VtaTrack03.Ciclo AND
    VtaTrack02.CodCia = pCodCia AND 
    VtaTrack02.CodUbic2 = pCodUbi
    NO-LOCK NO-ERROR.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    IF pCodUbi <> pCodUbiIni THEN DO:
        FIND VtaCTrkPed WHERE Vtactrkped.codcia = pcodcia
            AND Vtactrkped.coddiv = pcoddiv
            AND Vtactrkped.coddoc = pcoddoc
            AND Vtactrkped.nroped = pnroped
            EXCLUSIVE-LOCK NO-ERROR.
        /* CONTROL DEL FLUJO LOGICO */
        /* Buscamos el último movimiento del documento anterior */
        FIND LAST Vtadtrkped WHERE Vtadtrkped.codcia = pcodcia
            AND Vtadtrkped.coddiv = pcoddiv
            AND Vtadtrkped.coddoc = pcoddoc
            AND Vtadtrkped.nroped = pnroped
            AND vtadtrkped.codref = pcodref2
            AND vtadtrkped.nroref = pnroref2
            AND vtadtrkped.CodUbic <> pcodubi
            AND Vtadtrkped.flgsit <> 'A'
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Vtadtrkped THEN DO:
            MESSAGE 'El proceso no sigue el flujo lógico' SKIP
                'Doc. de referencia' pcodref2 pnroref2 'no ubicado en el tracking'
                VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
            RETURN 'ADM-ERROR'.
        END.
        IF VtaTrack02.CodUbic1 <> vtadtrkped.CodUbic THEN DO:
            MESSAGE 'El proceso no sigue el flujo lógico' SKIP
                'Dice:' Vtadtrkped.codubic SKIP
                'Debería decir:' Vtatrack02.codubic1
                VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
            RETURN 'ADM-ERROR'.
        END.
        /* GRABAMOS EL TRACKING */
        ASSIGN
            vtactrkped.FechaT = pfechat
            vtactrkped.FlgSit = pflgsit
            vtactrkped.CodUbic = pcodubi.
        FIND LAST Vtadtrkped WHERE Vtadtrkped.codcia = pcodcia
            AND Vtadtrkped.coddiv = pcoddiv
            AND Vtadtrkped.coddoc = pcoddoc
            AND Vtadtrkped.nroped = pnroped
            AND Vtadtrkped.codubi = pCodUbi
            AND Vtadtrkped.codref = pcodref1
            AND Vtadtrkped.nroref = pnroref1
            AND Vtadtrkped.flgsit <> 'A'
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Vtadtrkped THEN DO:
            CREATE Vtadtrkped.
            ASSIGN
                vtadtrkped.CodCia = pcodcia
                vtadtrkped.CodDiv = pcoddiv
                vtadtrkped.CodDoc = pcoddoc
                vtadtrkped.NroPed = pnroped
                vtadtrkped.CodUbic = pcodubi
                vtadtrkped.FechaI = pfechai
                vtadtrkped.CodRef = pCodRef1
                vtadtrkped.NroRef = pNroRef1.
        END.
        ASSIGN
            vtadtrkped.FechaT = pfechat
            vtadtrkped.FlgSit = pFlgSit
            vtadtrkped.Libre_C01 = pCodRef2
            vtadtrkped.Libre_C02 = pNroRef2
            vtadtrkped.Libre_C03 = pDivTrk
            vtadtrkped.Usuario = pusuario.
    END.
    ELSE DO:
        CREATE VtaCTrkPed.
        ASSIGN
            vtactrkped.CodCia = pCodCia
            vtactrkped.CodDiv = pCodDiv
            vtactrkped.CodDoc = pCodDoc
            vtactrkped.NroPed = pNroPed
            vtactrkped.CodUbic = pcodubi
            vtactrkped.FechaI = pFechaI
            vtactrkped.FechaT = pfechat
            vtactrkped.FlgSit = pflgsit.
        CREATE VtaDTrkPed.
        ASSIGN
            vtadtrkped.CodCia = pcodcia
            vtadtrkped.CodDiv = pcoddiv
            vtadtrkped.CodDoc = pcoddoc
            vtadtrkped.NroPed = pnroped
            vtadtrkped.CodUbic = pcodubi
            vtadtrkped.FechaI = pfechai
            vtadtrkped.FechaT = pfechat
            vtadtrkped.FlgSit = pFlgSit
            vtadtrkped.CodRef = pCodRef1
            vtadtrkped.NroRef = pNroRef1
            vtadtrkped.Libre_C01 = pCodRef2
            vtadtrkped.Libre_C02 = pNroRef2
            vtadtrkped.Libre_C03 = pDivTrk
            vtadtrkped.Usuario = pusuario.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Anulacion-Tracking) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anulacion-Tracking Procedure 
PROCEDURE Anulacion-Tracking :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND VtaCTrkPed WHERE Vtactrkped.codcia = pcodcia
        AND Vtactrkped.coddiv = pcoddiv
        AND Vtactrkped.coddoc = pcoddoc
        AND Vtactrkped.nroped = pnroped
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaCTrkPed THEN DO:
        MESSAGE 'No existe el registro de cabecera de control del tracking'
            VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* Verificamos última entrada del tracking */
    FIND LAST Vtadtrkped WHERE Vtadtrkped.codcia = pcodcia
        AND Vtadtrkped.coddiv = pcoddiv
        AND Vtadtrkped.coddoc = pcoddoc
        AND Vtadtrkped.nroped = pnroped
        AND Vtadtrkped.codubic = pcodubi
        AND vtadtrkped.codref = pcodref1
        AND vtadtrkped.nroref = pnroref1
        AND Vtadtrkped.flgsit <> 'A'
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtadtrkped THEN DO:
        MESSAGE 'No existe el registro del detalle de control del tracking'
            VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        vtadtrkped.FechaT = pfechat
        vtadtrkped.FlgSit = pFlgSit
        vtadtrkped.Usuario = pusuario.
    ASSIGN
        vtactrkped.FechaT = pfechat
        vtactrkped.FlgSit = pflgsit.
    /* RHC 22.01.10 ANULAMOS LOS SUBSIGUIENTES MOVIMIENTOS RELACIONADOS */
    FIND LAST B-dtped WHERE B-dtped.codcia = pcodcia
        AND B-dtped.coddiv = pcoddiv
        AND B-dtped.coddoc = pcoddoc
        AND B-dtped.nroped = pnroped
        AND B-dtped.codubic = pcodubi
        AND B-dtped.codref = pcodref1
        AND B-dtped.nroref = pnroref1
        AND B-dtped.flgsit = 'A'
        NO-LOCK NO-ERROR.
    REPEAT WHILE AVAILABLE B-dtped.
        FIND NEXT B-dtped WHERE B-dtped.codcia = pcodcia
            AND B-dtped.coddiv = pcoddiv
            AND B-dtped.coddoc = pcoddoc
            AND B-dtped.nroped = pnroped
            AND B-dtped.codref = pcodref1
            AND B-dtped.nroref = pnroref1
            EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE B-dtped THEN DO:
            B-dtped.flgsit = 'A'.
        END.
    END.

    /* ACTUALIZAMOS ESTADO GENERAL DEL PEDIDO */
    FIND LAST Vtadtrkped WHERE Vtadtrkped.codcia = pcodcia
        AND Vtadtrkped.coddiv = pcoddiv
        AND Vtadtrkped.coddoc = pcoddoc
        AND Vtadtrkped.nroped = pnroped
        AND Vtadtrkped.flgsit <> 'A'
        NO-LOCK NO-ERROR.
    IF AVAILABLE Vtadtrkped 
    THEN ASSIGN
            vtactrkped.FechaT = Vtadtrkped.FechaT
            vtactrkped.CodUbic = Vtadtrkped.CodUbic
            vtactrkped.FlgSit = Vtadtrkped.flgsit.

    RELEASE B-dtped.
    RELEASE VtaCTrkPed.
    RELEASE VtaDTrkPed.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Cierre-Tracking) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierre-Tracking Procedure 
PROCEDURE Cierre-Tracking :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND VtaCTrkPed WHERE Vtactrkped.codcia = pcodcia
    AND Vtactrkped.coddiv = pcoddiv
    AND Vtactrkped.coddoc = pcoddoc
    AND Vtactrkped.nroped = pnroped
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaCTrkPed THEN DO:
    MESSAGE 'Cabecera del tracking NO registrada'
        VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
    RETURN 'ADM-ERROR'.
END.
FIND LAST Vtatrack02 WHERE 
    VtaTrack02.Ciclo  = VtaTrack03.Ciclo AND
    VtaTrack02.CodCia = pCodCia AND 
    VtaTrack02.CodUbic2 = pCodUbi
    NO-LOCK NO-ERROR.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND VtaCTrkPed WHERE Vtactrkped.codcia = pcodcia
        AND Vtactrkped.coddiv = pcoddiv
        AND Vtactrkped.coddoc = pcoddoc
        AND Vtactrkped.nroped = pnroped
        EXCLUSIVE-LOCK NO-ERROR.
    /* CONTROL DEL FLUJO LOGICO */
    /* Buscamos el último movimiento del documento anterior */
    FIND LAST Vtadtrkped WHERE Vtadtrkped.codcia = pcodcia
        AND Vtadtrkped.coddiv = pcoddiv
        AND Vtadtrkped.coddoc = pcoddoc
        AND Vtadtrkped.nroped = pnroped
        AND vtadtrkped.codref = pcodref2
        AND vtadtrkped.nroref = pnroref2
        AND Vtadtrkped.flgsit <> 'A'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtadtrkped THEN DO:
        MESSAGE 'El proceso no sigue el flujo lógico' SKIP
            'Doc. de referencia' pcodref2 pnroref2 'no ubicado en el tracking'
            VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
        RETURN 'ADM-ERROR'.
    END.
    IF VtaTrack02.CodUbic1 <> vtadtrkped.CodUbic THEN DO:
        MESSAGE 'El proceso no sigue el flujo lógico' SKIP
            'Dice:' Vtadtrkped.codubic SKIP
            'Debería decir:' Vtatrack02.codubic1
            VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
        RETURN 'ADM-ERROR'.
    END.
    /* GRABAMOS EL TRACKING */
    ASSIGN
        vtactrkped.FechaT = pfechat
        /*vtactrkped.FlgSit = pflgsit*/
        vtactrkped.CodUbic = pcodubi.
    FIND LAST Vtadtrkped WHERE Vtadtrkped.codcia = pcodcia
        AND Vtadtrkped.coddiv = pcoddiv
        AND Vtadtrkped.coddoc = pcoddoc
        AND Vtadtrkped.nroped = pnroped
        AND Vtadtrkped.codubi = pCodUbi
        AND Vtadtrkped.codref = pcodref1
        AND Vtadtrkped.nroref = pnroref1
        AND Vtadtrkped.flgsit <> 'A'
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtadtrkped THEN DO:
        CREATE Vtadtrkped.
        ASSIGN
            vtadtrkped.CodCia = pcodcia
            vtadtrkped.CodDiv = pcoddiv
            vtadtrkped.CodDoc = pcoddoc
            vtadtrkped.NroPed = pnroped
            vtadtrkped.CodUbic = pcodubi
            vtadtrkped.FechaI = pfechai
            vtadtrkped.CodRef = pCodRef1
            vtadtrkped.NroRef = pNroRef1.
    END.
    ASSIGN
        vtadtrkped.FechaT = pfechat
        vtadtrkped.FlgSit = pFlgSit
        vtadtrkped.Libre_C01 = pCodRef2
        vtadtrkped.Libre_C02 = pNroRef2
        vtadtrkped.Libre_C03 = pDivTrk
        vtadtrkped.Usuario = pusuario.
    /* COMO SABEMOS QUE TODOS LOS DOCUMENTOS YA ESTAN CERRADOS? */
    DEF VAR logCerrado AS LOG INIT YES NO-UNDO.
    FOR EACH Vtadtrkped NO-LOCK WHERE Vtadtrkped.codcia = pcodcia
        AND Vtadtrkped.coddiv = pcoddiv
        AND Vtadtrkped.coddoc = pcoddoc
        AND Vtadtrkped.nroped = pnroped
        AND Vtadtrkped.codref = pcodref1
        BREAK BY Vtadtrkped.nroref BY Vtadtrkped.fechai:
        IF LAST-OF (Vtadtrkped.nroref) THEN DO:
            IF Vtadtrkped.flgsit <> 'C' THEN logCerrado = NO.
            LEAVE.
        END.
    END.
    IF logCerrado = YES THEN Vtactrkped.flgsit = pflgsit.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Suspender-Tracking) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Suspender-Tracking Procedure 
PROCEDURE Suspender-Tracking :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND VtaCTrkPed WHERE Vtactrkped.codcia = pcodcia
    AND Vtactrkped.coddiv = pcoddiv
    AND Vtactrkped.coddoc = pcoddoc
    AND Vtactrkped.nroped = pnroped
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaCTrkPed THEN DO:
    MESSAGE 'Cabecera del tracking NO registrada'
        VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
    RETURN 'ADM-ERROR'.
END.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND VtaCTrkPed WHERE Vtactrkped.codcia = pcodcia
        AND Vtactrkped.coddiv = pcoddiv
        AND Vtactrkped.coddoc = pcoddoc
        AND Vtactrkped.nroped = pnroped
        EXCLUSIVE-LOCK NO-ERROR.
    /* GRABAMOS EL TRACKING */
    ASSIGN
        vtactrkped.FechaT = pfechat
        vtactrkped.FlgSit = pflgsit.
    CREATE Vtadtrkped.
    ASSIGN
        vtadtrkped.CodCia = pcodcia
        vtadtrkped.CodDiv = pcoddiv
        vtadtrkped.CodDoc = pcoddoc
        vtadtrkped.NroPed = pnroped
        vtadtrkped.CodUbic = pcodubi
        vtadtrkped.FechaI = pfechai
        vtadtrkped.CodRef = pCodRef1
        vtadtrkped.NroRef = pNroRef1
        vtadtrkped.FechaT = pfechat
        vtadtrkped.FlgSit = pFlgSit
        vtadtrkped.Libre_C01 = pCodRef2
        vtadtrkped.Libre_C02 = pNroRef2
        vtadtrkped.Libre_C03 = pDivTrk
        vtadtrkped.Usuario = pusuario.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

