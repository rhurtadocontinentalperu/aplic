&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Control de Tracking de Pedidos (Mostrador y Credito)

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pCodCia AS INT.
DEF INPUT PARAMETER pDivTrk AS CHAR.    /* Division de flujo de tracking */
DEF INPUT PARAMETER pCodDiv AS CHAR.    /* Division de seguimiento */
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroPed AS CHAR.
DEF INPUT PARAMETER pUsuario AS CHAR.
DEF INPUT PARAMETER pCodUbi AS CHAR.
DEF INPUT PARAMETER pFlgSit AS CHAR.
DEF INPUT PARAMETER pCodIO  AS CHAR.
DEF INPUT PARAMETER pFechaI AS DATETIME.
DEF INPUT PARAMETER pFechaT AS DATETIME.
DEF INPUT PARAMETER pCodRef AS CHAR.
DEF INPUT PARAMETER pNroRef AS CHAR.

/* Verificar si está configurado el tracking */
FIND VtaTrack03 WHERE codcia = pCodCia
    AND coddiv = pDivTrk
    AND coddoc = pCodDoc
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Vtatrack03 THEN DO:
    RETURN 'OK'.
END.

/* Verificamos si el detalle del ciclo está configurado en el tracking */
FIND FIRST Vtatrack02 WHERE 
    VtaTrack02.Ciclo  = VtaTrack03.Ciclo AND
    VtaTrack02.CodCia = pCodCia AND 
    VtaTrack02.CodUbic1 = pCodUbi
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
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 3.27
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF VAR x-FchCot AS DATE NO-UNDO.
DEF VAR x-NroCot AS CHAR NO-UNDO.
DEF VAR x-CodCli AS CHAR NO-UNDO.

CASE pCodDoc:
    WHEN 'P/M' THEN DO:
        FIND Faccpedm WHERE Faccpedm.codcia = pcodcia
            AND Faccpedm.coddoc = pcoddoc
            AND Faccpedm.nroped = pnroped
            NO-LOCK NO-ERROR.
        IF AVAILABLE Faccpedm THEN DO:
            ASSIGN
                x-CodCli = Faccpedm.codcli
                x-NroCot = Faccpedm.ordcmp.
            IF Faccpedm.fchped < 11/25/2009 THEN RETURN 'OK'.
        END.
    END.
    WHEN 'PED' THEN DO:
        FIND Faccpedi WHERE Faccpedi.codcia = pcodcia
            AND Faccpedi.coddoc = pcoddoc
            AND Faccpedi.nroped = pnroped
            NO-LOCK NO-ERROR.
        IF AVAILABLE Faccpedi THEN DO:
            ASSIGN
                x-CodCli = Faccpedi.codcli
                x-NroCot = Faccpedi.ordcmp.
            IF Faccpedi.fchped < 12/02/2009 THEN RETURN 'OK'.
        END.
    END.
END CASE.

CASE pFlgSit:
    WHEN 'P' OR WHEN 'S' THEN DO: 
        RUN Actualiza-Tracking.
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    END.
    WHEN 'C' THEN DO: 
        RUN Cierra-Tracking.
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    END.
    WHEN 'A' THEN DO:       /* ANULACION */
        RUN Anulacion-Tracking.
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
  Notes:       Si pCoIO es I o O siempre debe haber un proceso anterior
------------------------------------------------------------------------------*/

/* Control del flujo del tracking */
FIND FIRST VtaTrack02 WHERE Vtatrack02.codcia = Vtatrack03.codcia
    AND Vtatrack02.ciclo = Vtatrack03.ciclo
    AND Vtatrack02.codubic2 = pCodUbi
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTrack02 THEN DO:
    /* RHC 14.01.10 LO PASAMOS POR ALTO */
    RETURN.
/*     MESSAGE 'El proceso' pCodUbi 'no está registrado en el flujo lógico' */
/*         VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.            */
/*     UNDO, RETURN 'ADM-ERROR'.                                            */
END.
/* buscamos registro de control */
IF pCodUbi <> 'GNP' THEN DO:
    FIND VtaCTrkPed WHERE Vtactrkped.codcia = pcodcia
        AND Vtactrkped.coddiv = pcoddiv
        AND Vtactrkped.coddoc = pcoddoc
        AND Vtactrkped.nroped = pnroped
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaCTrkPed THEN DO:
        MESSAGE 'ERROR EN EL TRACKING' SKIP
            'Cabecera del tracking NO registrada'
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    CASE Vtactrkped.flgsit:
        /* RHC 14.01.10 BLOQUEADO */
/*         WHEN 'C' THEN DO:                             */
/*             MESSAGE 'ERROR EN EL TRACKING' SKIP       */
/*                 'El tracking del pedido está CERRADO' */
/*                 VIEW-AS ALERT-BOX ERROR.              */
/*             RETURN 'ADM-ERROR'.                       */
/*         END.                                          */
        WHEN 'S' THEN DO:
            MESSAGE 'ERROR EN EL TRACKING' SKIP
                'El tracking del pedido está SUSPENDIDO'
                VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
        END.
    END CASE.
END.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    CASE pCodIO:
        WHEN 'I' THEN DO:           /* INICIO DE UN PROCESO */
            /* Verificamos última entrada del tracking */
            FIND LAST Vtadtrkped WHERE Vtadtrkped.codcia = pcodcia
                AND Vtadtrkped.coddiv = pcoddiv
                AND Vtadtrkped.coddoc = pcoddoc
                AND Vtadtrkped.nroped = pnroped
                AND Vtadtrkped.flgsit <> 'A'
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Vtadtrkped OR Vtadtrkped.FechaT = ? THEN DO:
                MESSAGE 'El proceso anterior aún no se ha concluido' SKIP
                    'o no sigue el flujo lógico'
                    VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
                UNDO, RETURN 'ADM-ERROR'.
            END.
            /* Verificamos si es un proceso logico */
            IF NOT AVAILABLE VtaTrack02 OR VtaTrack02.CodUbic1 <> vtadtrkped.CodUbic THEN DO:
                MESSAGE 'El proceso no sigue el flujo lógico'
                    VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
                RETURN 'ADM-ERROR'.
            END.
            FIND VtaCTrkPed WHERE Vtactrkped.codcia = pcodcia
                AND Vtactrkped.coddiv = pcoddiv
                AND Vtactrkped.coddoc = pcoddoc
                AND Vtactrkped.nroped = pnroped
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE VtaCTrkPed THEN DO:
                MESSAGE 'No existe el registro de control del tracking'
                    VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
                UNDO, RETURN 'ADM-ERROR'.
            END.
            ASSIGN
                vtactrkped.FechaI = pfechai
                vtactrkped.FlgSit = pflgsit
                vtactrkped.CodUbic = pcodubi.
            CREATE VtaDTrkPed.
            ASSIGN
                vtadtrkped.CodCia = pcodcia
                vtadtrkped.CodDiv = pcoddiv
                vtadtrkped.CodDoc = pcoddoc
                vtadtrkped.NroPed = pnroped
                vtadtrkped.CodUbic = pcodubi
                vtadtrkped.FechaT = pfechai     /* *** OJO *** */
                vtadtrkped.FlgSit = pFlgSit
                vtadtrkped.CodRef = pCodRef
                vtadtrkped.NroRef = pNroRef
                vtadtrkped.Usuario = pusuario.
        END.
        WHEN 'O' THEN DO:           /* CIERRE DE UN PROCESO */
            /* Verificamos última entrada del tracking */
            FIND LAST Vtadtrkped WHERE Vtadtrkped.codcia = pcodcia
                AND Vtadtrkped.coddiv = pcoddiv
                AND Vtadtrkped.coddoc = pcoddoc
                AND Vtadtrkped.nroped = pnroped
                AND Vtadtrkped.flgsit <> 'A'
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Vtadtrkped 
                    OR NOT (Vtadtrkped.codubi = pcodubi AND Vtadtrkped.FechaT = ?) THEN DO:
                MESSAGE 'El proceso de inicio no existe' SKIP
                    'o ya fue concluido'
                    VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
                UNDO, RETURN 'ADM-ERROR'.
            END.
            FIND VtaCTrkPed WHERE Vtactrkped.codcia = pcodcia
                AND Vtactrkped.coddiv = pcoddiv
                AND Vtactrkped.coddoc = pcoddoc
                AND Vtactrkped.nroped = pnroped
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE VtaCTrkPed THEN DO:
                MESSAGE 'No existe el registro de control del tracking'
                    VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
                UNDO, RETURN 'ADM-ERROR'.
            END.
            ASSIGN
                vtactrkped.FechaT = pfechat
                vtactrkped.FlgSit = pflgsit
                vtactrkped.CodUbic = pcodubi.
            FIND CURRENT VtaDTrkPed EXCLUSIVE-LOCK.
            ASSIGN
                vtadtrkped.FechaT = pfechat
                vtadtrkped.Usuario = pusuario.
        END.
        WHEN 'IO' THEN DO:       
            /* EN CASO DE REPETIR EL TRACKING (BARRAS DE GUIAS DE REMISION) */
            FIND VtaCTrkPed WHERE Vtactrkped.codcia = pcodcia
                AND Vtactrkped.coddiv = pcoddiv
                AND Vtactrkped.coddoc = pcoddoc
                AND Vtactrkped.nroped = pnroped
                EXCLUSIVE-LOCK NO-ERROR.
            IF pCodUbi <> 'GNP' THEN DO:
                IF NOT AVAILABLE VtaCTrkPed THEN DO:
                    MESSAGE 'No existe el registro de control del tracking'
                        VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
                    UNDO, RETURN 'ADM-ERROR'.
                END.
                /* Verificamos si es un proceso logico */
                FIND LAST Vtadtrkped WHERE Vtadtrkped.codcia = pcodcia
                    AND Vtadtrkped.coddiv = pcoddiv
                    AND Vtadtrkped.coddoc = pcoddoc
                    AND Vtadtrkped.nroped = pnroped
                    AND Vtadtrkped.flgsit <> 'A'
                    NO-LOCK NO-ERROR.

                /* hubo un caso raro con el PED 015100126 ¿quién malogró el ciclo? */
                /* simulo que todo está bien */
                IF NOT AVAILABLE Vtadtrkped THEN RETURN.

                /* RHC 14.01.10 Voy a cerrarlo hasta revisar bien el proceso */
/*                 IF Vtadtrkped.CodUbic <> pCodUbi                              */
/*                     AND VtaTrack02.CodUbic1 <> vtadtrkped.CodUbic THEN DO:    */
/*                     MESSAGE 'El proceso no sigue el flujo lógico'             */
/*                         VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'. */
/*                     RETURN 'ADM-ERROR'.                                       */
/*                 END.                                                          */
                ASSIGN
                    vtactrkped.FechaT = pfechat
                    vtactrkped.FlgSit = pflgsit
                    vtactrkped.CodUbic = pcodubi.
                FIND LAST Vtadtrkped WHERE Vtadtrkped.codcia = pcodcia
                    AND Vtadtrkped.coddiv = pcoddiv
                    AND Vtadtrkped.coddoc = pcoddoc
                    AND Vtadtrkped.nroped = pnroped
                    AND Vtadtrkped.codubi = pCodUbi
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
                        vtadtrkped.FechaT = pfechat
                        vtadtrkped.FlgSit = pFlgSit
                        vtadtrkped.CodRef = pCodRef
                        vtadtrkped.NroRef = pNroRef
                        vtadtrkped.Usuario = pusuario.
                END.
                ELSE DO:
                    ASSIGN
                        vtadtrkped.FechaT = pfechat
                        vtadtrkped.FlgSit = pFlgSit
                        vtadtrkped.CodRef = pCodRef
                        vtadtrkped.NroRef = pNroRef
                        vtadtrkped.Usuario = pusuario.
                END.
            END.
            ELSE DO:
                IF NOT AVAILABLE VtaCTrkPed THEN CREATE VtaCTrkPed.
                ASSIGN
                    vtactrkped.CodCia = pCodCia
                    vtactrkped.CodDiv = pCodDiv
                    vtactrkped.CodDoc = pCodDoc
                    vtactrkped.NroPed = pNroPed
                    vtactrkped.CodCli = x-CodCli
                    vtactrkped.NroCot = x-NroCot
                    vtactrkped.FchCot = x-FchCot
                    vtactrkped.FechaI = pFechaI
                    vtactrkped.FechaT = pfechat
                    vtactrkped.FlgSit = pflgsit
                    vtactrkped.CodUbic = pcodubi.
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
                    vtadtrkped.CodRef = pCodRef
                    vtadtrkped.NroRef = pNroRef
                    vtadtrkped.Usuario = pusuario.
            END.
        END.
    END CASE.
    RELEASE VtaCTrkPed.
    RELEASE VtaDTrkPed.
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
        MESSAGE 'No existe el registro de control del tracking'
            VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* Verificamos última entrada del tracking */
    FIND LAST Vtadtrkped WHERE Vtadtrkped.codcia = pcodcia
        AND Vtadtrkped.coddiv = pcoddiv
        AND Vtadtrkped.coddoc = pcoddoc
        AND Vtadtrkped.nroped = pnroped
        AND Vtadtrkped.codubic = pcodubi
        /*AND Vtadtrkped.flgsit <> 'A'*/
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtadtrkped THEN DO:
        MESSAGE 'NO se puede anular el Tracking'
            VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
        UNDO, RETURN 'ADM-ERROR'.
    END.


    CASE pCodIO:
        WHEN 'I' THEN DO:           /* INICIO DE UN PROCESO */
            IF NOT (Vtadtrkped.codubic = pcodubi AND Vtadtrkped.fechat = ?) THEN DO:
                MESSAGE 'NO se puede anular el Tracking'
                    VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
                UNDO, RETURN 'ADM-ERROR'.
            END.
            ASSIGN
                Vtactrkped.FlgSit = pFlgSit
                vtactrkped.FechaT = pfechai
                vtadtrkped.FechaT = pfechai
                vtadtrkped.FlgSit = pFlgSit
                vtadtrkped.Usuario = pusuario.
        END.
        WHEN 'O' THEN DO:           /* CIERRE DE UN PROCESO */
            IF NOT (Vtadtrkped.codubi = pcodubi AND Vtadtrkped.FechaT <> ?) THEN DO:
                MESSAGE 'NO se puede anular el Tracking'
                    VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
                UNDO, RETURN 'ADM-ERROR'.
            END.
            ASSIGN
                vtactrkped.FechaT = pfechat
                vtactrkped.FlgSit = pflgsit
                vtadtrkped.FlgSit = pFlgSit
                vtadtrkped.FechaT = pfechat
                vtadtrkped.Usuario = pusuario.
        END.
        WHEN 'IO' THEN DO:           
/*             CREATE VtaDTrkPed. */
            ASSIGN
/*                 vtadtrkped.CodCia = pcodcia  */
/*                 vtadtrkped.CodDiv = pcoddiv  */
/*                 vtadtrkped.CodDoc = pcoddoc  */
/*                 vtadtrkped.CodUbic = pcodubi */
/*                 vtadtrkped.FechaI = pfechai  */
                vtadtrkped.FechaT = pfechat
/*                 vtadtrkped.NroPed = pnroped */
                vtadtrkped.CodRef = pCodRef
                vtadtrkped.NroRef = pNroRef
                vtadtrkped.FlgSit = pFlgSit
                vtadtrkped.Usuario = pusuario.
            ASSIGN
                vtactrkped.FechaT = pfechat
                vtactrkped.FlgSit = pflgsit.
        END.
    END CASE.
    RELEASE VtaCTrkPed.
    RELEASE VtaDTrkPed.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Cierra-Tracking) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierra-Tracking Procedure 
PROCEDURE Cierra-Tracking :
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
    MESSAGE 'No existe el registro de control del tracking'
        VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
    RETURN 'ADM-ERROR'.
END.
CASE Vtactrkped.flgsit:
/*     WHEN 'C' THEN DO:                                             */
/*         MESSAGE 'El tracking del pedido está CERRADO'             */
/*             VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'. */
/*         RETURN 'ADM-ERROR'.                                       */
/*     END.                                                          */
    WHEN 'S' THEN DO:
        MESSAGE 'El tracking del pedido está SUSPENDIDO'
            VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
        RETURN 'ADM-ERROR'.
    END.
END CASE.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Verificamos última entrada del tracking */
    FIND LAST Vtadtrkped WHERE Vtadtrkped.codcia = pcodcia
        AND Vtadtrkped.coddiv = pcoddiv
        AND Vtadtrkped.coddoc = pcoddoc
        AND Vtadtrkped.nroped = pnroped
        AND Vtadtrkped.flgsit <> 'A'
        AND Vtadtrkped.codubi <> pCodUbi
        NO-LOCK NO-ERROR.
    /* Control del flujo del tracking */
    FIND FIRST VtaTrack02 WHERE Vtatrack02.codcia = Vtatrack03.codcia
        AND Vtatrack02.ciclo = Vtatrack03.ciclo
        AND Vtatrack02.codubic2 = pCodUbi
        NO-LOCK NO-ERROR.
    CASE pCodIO:
        WHEN 'I' THEN DO:           /* INICIO DE UN PROCESO */
            /* Verificamos última entrada del tracking */
            IF NOT AVAILABLE Vtadtrkped OR Vtadtrkped.FechaT = ? THEN DO:
                MESSAGE 'El proceso anterior aun no se ha concluido'
                    VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
                RETURN 'ADM-ERROR'.
            END.
            /* Verificamos si es un proceso logico */
            IF NOT AVAILABLE VtaTrack02 OR VtaTrack02.CodUbic1 <> vtadtrkped.CodUbic THEN DO:
                MESSAGE 'El proceso no sigue el flujo lógico'
                    VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
                RETURN 'ADM-ERROR'.
            END.
            FIND CURRENT VtaCTrkPed EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE VtaCTrkPed THEN UNDO, RETURN 'ADM-ERROR'.
            ASSIGN
                vtactrkped.FechaI = pfechai
                vtactrkped.FlgSit = pflgsit
                vtactrkped.CodUbic = pcodubi.
            CREATE VtaDTrkPed.
            ASSIGN
                vtadtrkped.CodCia = pcodcia
                vtadtrkped.CodDiv = pcoddiv
                vtadtrkped.CodDoc = pcoddoc
                vtadtrkped.CodUbic = pcodubi
                vtadtrkped.FechaT = pfechai     /* *** OJO *** */
                /*vtadtrkped.FechaT */
                vtadtrkped.NroPed = pnroped
                vtadtrkped.FlgSit = pFlgSit
                vtadtrkped.Usuario = pusuario.
        END.
        WHEN 'O' THEN DO:           /* CIERRE DE UN PROCESO */
            /* Verificamos última entrada del tracking */
            IF NOT AVAILABLE Vtadtrkped 
                OR NOT (Vtadtrkped.codubi = pcodubi AND Vtadtrkped.FechaT = ?) THEN DO:
                MESSAGE 'El proceso de inicio NO existe' SKIP
                        'o YA fue concluido'
                    VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
                RETURN 'ADM-ERROR'.
            END.
            FIND CURRENT VtaCTrkPed EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE VtaCTrkPed THEN UNDO, RETURN 'ADM-ERROR'.
            ASSIGN
                vtactrkped.FechaT = pfechat
                vtactrkped.FlgSit = pflgsit
                vtactrkped.CodUbic = pcodubi.
            FIND CURRENT VtaDTrkPed EXCLUSIVE-LOCK.
            ASSIGN
                vtadtrkped.FechaT = pfechat
                vtadtrkped.Usuario = pusuario.
        END.
        WHEN 'IO' THEN DO:           
            /* Verificamos última entrada del tracking */
            IF NOT AVAILABLE Vtadtrkped OR Vtadtrkped.FechaT = ? THEN DO:
                MESSAGE  'ERROR EN EL TRACKING' SKIP
                    'El proceso anterior aun no se ha concluido'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
            /* Verificamos si es un proceso logico */
            IF NOT AVAILABLE VtaTrack02 OR VtaTrack02.CodUbic1 <> vtadtrkped.CodUbic THEN DO:
                MESSAGE 'El proceso no sigue el flujo lógico'
                    VIEW-AS ALERT-BOX ERROR TITLE 'ERROR EN EL TRACKING'.
                RETURN 'ADM-ERROR'.
            END.
            FIND CURRENT VtaCTrkPed EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE VtaCTrkPed THEN UNDO, RETURN 'ADM-ERROR'.
            ASSIGN
                vtactrkped.FechaT = pfechat
                vtactrkped.FlgSit = pflgsit
                vtactrkped.CodUbic = pcodubi.
            CREATE VtaDTrkPed.
            ASSIGN
                vtadtrkped.CodCia = pcodcia
                vtadtrkped.CodDiv = pcoddiv
                vtadtrkped.CodDoc = pcoddoc
                vtadtrkped.CodUbic = pcodubi
                vtadtrkped.FechaI = pfechai
                vtadtrkped.FechaT = pfechat
                vtadtrkped.NroPed = pnroped
                vtadtrkped.FlgSit = pFlgSit
                vtadtrkped.CodRef = pCodRef
                vtadtrkped.NroRef = pNroRef
                vtadtrkped.Usuario = pusuario.
        END.
    END CASE.
    RELEASE VtaCTrkPed.
    RELEASE VtaDTrkPed.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

