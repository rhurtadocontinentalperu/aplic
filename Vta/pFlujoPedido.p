&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Tracking de Pedidos

    Syntax      :

    Description : Grabación del Tracking de pedidos slo si es válido

    Author(s)   :
    Created     :
    Notes       : GNP es un caso especial
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pCodCia AS INT.
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodUbi AS CHAR.
DEF INPUT PARAMETER pUsuario AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroPed AS CHAR.
DEF INPUT PARAMETER pFlgSit AS CHAR.
DEF INPUT PARAMETER pCodIO  AS CHAR.
DEF INPUT PARAMETER pFechaI AS DATETIME.
DEF INPUT PARAMETER pFechaT AS DATETIME.

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

DEF VAR x-FchCot AS DATE NO-UNDO.
DEF VAR x-NroCot AS CHAR NO-UNDO.
DEF VAR x-CodCli AS CHAR NO-UNDO.

CASE pCodDoc:
    WHEN 'P/M' THEN DO:
        FIND Faccpedm WHERE Faccpedm.codcia = pcodcia
            AND Faccpedm.coddoc = pcoddoc
            AND Faccpedm.nroped = pnroped
            NO-LOCK NO-ERROR.
        IF AVAILABLE Faccpedm 
            THEN ASSIGN
                    x-CodCli = Faccpedm.codcli
                    x-NroCot = Faccpedm.ordcmp.
    END.
    WHEN 'PED' THEN DO:
        FIND Faccpedi WHERE Faccpedi.codcia = pcodcia
            AND Faccpedi.coddoc = pcoddoc
            AND Faccpedi.nroped = pnroped
            NO-LOCK NO-ERROR.
        IF AVAILABLE Faccpedi 
            THEN ASSIGN
                    x-CodCli = Faccpedi.codcli
                    x-NroCot = Faccpedi.ordcmp.
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
    END.
END CASE.

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
/* caso especial GNP */
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
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
        WHEN 'C' THEN DO:
            MESSAGE 'ERROR EN EL TRACKING' SKIP
                'El tracking del pedido está CERRADO'
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
        WHEN 'S' THEN DO:
            MESSAGE 'ERROR EN EL TRACKING' SKIP
                'El tracking del pedido está SUSPENDIDO'
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
/*         WHEN 'A' THEN DO:                             */
/*             MESSAGE 'ERROR EN EL TRACKING' SKIP       */
/*                 'El tracking del pedido está ANULADO' */
/*                 VIEW-AS ALERT-BOX ERROR.              */
/*             RETURN 'ADM-ERROR'.                       */
/*         END.                                          */
        END CASE.
    END.
    CASE pCodIO:
        WHEN 'I' THEN DO:           /* INICIO DE UN PROCESO */
            /* Verificamos última entrada del tracking */
            FIND LAST Vtadtrkped WHERE Vtadtrkped.codcia = pcodcia
                AND Vtadtrkped.coddiv = pcoddiv
                AND Vtadtrkped.coddoc = pcoddoc
                AND VTadtrkped.nroped = pnroped
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Vtadtrkped OR Vtadtrkped.FechaT = ? THEN DO:
                MESSAGE 'ERROR EN EL TRACKING' SKIP
                    'El proceso anterior aun no se ha concluido'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
            /* Verificamos si es un proceso logico */
            FIND FIRST VtaFTrkPed WHERE vtaftrkped.Codcia = pcodcia
                AND vtaftrkped.CodDiv = pcoddiv
                AND vtaftrkped.CodUbic2 = pcodubi
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE vtaftrkped OR vtaftrkped.CodUbic1 <> vtadtrkped.CodUbic THEN DO:
                MESSAGE 'ERROR EN EL TRACKING' SKIP
                    'El proceso NO sigue el flujo logico'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
            FIND VtaCTrkPed WHERE Vtactrkped.codcia = pcodcia
                AND Vtactrkped.coddiv = pcoddiv
                AND Vtactrkped.coddoc = pcoddoc
                AND Vtactrkped.nroped = pnroped
                EXCLUSIVE-LOCK NO-ERROR.
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
            RELEASE VtaCTrkPed.
            RELEASE VtaDTrkPed.
        END.
        WHEN 'O' THEN DO:           /* CIERRE DE UN PROCESO */
            /* Verificamos última entrada del tracking */
            FIND LAST Vtadtrkped WHERE Vtadtrkped.codcia = pcodcia
                AND Vtadtrkped.coddiv = pcoddiv
                AND Vtadtrkped.coddoc = pcoddoc
                AND VTadtrkped.nroped = pnroped
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Vtadtrkped 
                OR NOT (Vtadtrkped.codubi = pcodubi AND Vtadtrkped.FechaT = ?) THEN DO:
                MESSAGE  'ERROR EN EL TRACKING' SKIP
                    'El proceso de inicio NO existe' SKIP
                        'o YA fue concluido'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
            FIND VtaCTrkPed WHERE Vtactrkped.codcia = pcodcia
                AND Vtactrkped.coddiv = pcoddiv
                AND Vtactrkped.coddoc = pcoddoc
                AND Vtactrkped.nroped = pnroped
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE VtaCTrkPed THEN UNDO, RETURN 'ADM-ERROR'.
            ASSIGN
                vtactrkped.FechaT = pfechat
                vtactrkped.FlgSit = pflgsit
                vtactrkped.CodUbic = pcodubi.
            FIND CURRENT VtaDTrkPed EXCLUSIVE-LOCK.
            ASSIGN
                vtadtrkped.FechaT = pfechat
                vtadtrkped.Usuario = pusuario.
            RELEASE VtaCTrkPed.
            RELEASE VtaDTrkPed.
        END.
        WHEN 'IO' THEN DO:           
            /* Verificamos última entrada del tracking */
            FIND LAST Vtadtrkped WHERE Vtadtrkped.codcia = pcodcia
                AND Vtadtrkped.coddiv = pcoddiv
                AND Vtadtrkped.coddoc = pcoddoc
                AND VTadtrkped.nroped = pnroped
                AND Vtadtrkped.flgsit <> 'A'
                NO-LOCK NO-ERROR.
            IF pCodUbi <> 'GNP' THEN DO:
                FIND VtaCTrkPed WHERE Vtactrkped.codcia = pcodcia
                    AND Vtactrkped.coddiv = pcoddiv
                    AND Vtactrkped.coddoc = pcoddoc
                    AND Vtactrkped.nroped = pnroped
                    EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE VtaCTrkPed THEN UNDO, RETURN 'ADM-ERROR'.
                ASSIGN
                    vtactrkped.FechaT = pfechat
                    vtactrkped.FlgSit = pflgsit
                    vtactrkped.CodUbic = pcodubi.
            END.
            ELSE DO:
/*                 IF AVAILABLE Vtadtrkped THEN DO:          */
/*                     MESSAGE  'ERROR EN EL TRACKING' SKIP  */
/*                         'Existe un proceso anterior (¿?)' */
/*                         VIEW-AS ALERT-BOX ERROR.          */
/*                     RETURN 'ADM-ERROR'.                   */
/*                 END.                                      */
                FIND VtaCTrkPed WHERE Vtactrkped.codcia = pcodcia
                    AND Vtactrkped.coddiv = pcoddiv
                    AND Vtactrkped.coddoc = pcoddoc
                    AND Vtactrkped.nroped = pnroped
                    EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE VtaCTrkPed THEN CREATE VtaCTrkPed.
                ASSIGN
                    vtactrkped.CodCia = pCodCia
                    vtactrkped.CodCli = x-CodCli
                    vtactrkped.CodDiv = pCodDiv
                    vtactrkped.CodDoc = pCodDoc
                    vtactrkped.NroPed = pNroPed
                    vtactrkped.CodUbic = pCodUbi
                    vtactrkped.FchCot = x-FchCot
                    vtactrkped.FechaI = pFechaI
                    vtactrkped.FechaT = pFechaT
                    vtactrkped.FlgSit = pFlgSit
                    vtactrkped.NroCot = x-NroCot.
            END.
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
                vtadtrkped.Usuario = pusuario.
            RELEASE VtaCTrkPed.
            RELEASE VtaDTrkPed.
        END.
    END CASE.
END.
RETURN 'OK'.

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
    CASE pCodIO:
        WHEN 'I' THEN DO:           /* INICIO DE UN PROCESO */
            /* Verificamos última entrada del tracking */
            FIND LAST Vtadtrkped WHERE Vtadtrkped.codcia = pcodcia
                AND Vtadtrkped.coddiv = pcoddiv
                AND Vtadtrkped.coddoc = pcoddoc
                AND VTadtrkped.nroped = pnroped
                AND Vtadtrkped.flgsit <> 'A'
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Vtadtrkped THEN DO:
                MESSAGE  'ERROR EN EL TRACKING' SKIP
                    'NO se puede anular el Tracking'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
            IF NOT (Vtadtrkped.codubic = pcodubi AND Vtadtrkped.fechat = ?) THEN DO:
                MESSAGE 'NO se puede anular el Tracking'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
            FIND VtaCTrkPed WHERE Vtactrkped.codcia = pcodcia
                AND Vtactrkped.coddiv = pcoddiv
                AND Vtactrkped.coddoc = pcoddoc
                AND Vtactrkped.nroped = pnroped
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE VtaCTrkPed THEN UNDO, RETURN 'ADM-ERROR'.
            ASSIGN
                vtadtrkped.FechaT = pfechai
                vtadtrkped.FlgSit = pFlgSit
                Vtactrkped.FlgSit = pFlgSit.
            ASSIGN
                vtactrkped.FechaT = pfechai
                vtadtrkped.NroPed = pnroped
                vtadtrkped.Usuario = pusuario.
            RELEASE VtaCTrkPed.
            RELEASE VtaDTrkPed.
        END.
        WHEN 'O' THEN DO:           /* CIERRE DE UN PROCESO */
            /* Verificamos última entrada del tracking */
            FIND LAST Vtadtrkped WHERE Vtadtrkped.codcia = pcodcia
                AND Vtadtrkped.coddiv = pcoddiv
                AND Vtadtrkped.coddoc = pcoddoc
                AND Vtadtrkped.nroped = pnroped
                AND Vtadtrkped.flgsit <> 'A'
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Vtadtrkped THEN DO:
                MESSAGE  'ERROR EN EL TRACKING' SKIP
                    'NO se puede anular el Tracking'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
            IF NOT (Vtadtrkped.codubi = pcodubi AND Vtadtrkped.FechaT <> ?) THEN DO:
                MESSAGE 'NO se puede anular el Tracking'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
            FIND VtaCTrkPed WHERE Vtactrkped.codcia = pcodcia
                AND Vtactrkped.coddiv = pcoddiv
                AND Vtactrkped.coddoc = pcoddoc
                AND Vtactrkped.nroped = pnroped
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE VtaCTrkPed THEN UNDO, RETURN 'ADM-ERROR'.
            ASSIGN
                vtactrkped.FechaT = pfechat
                vtactrkped.FlgSit = pflgsit.
            FIND CURRENT VtaDTrkPed EXCLUSIVE-LOCK.
            ASSIGN
                vtadtrkped.FlgSit = pFlgSit
                vtadtrkped.FechaT = pfechat
                vtadtrkped.Usuario = pusuario.
            RELEASE VtaCTrkPed.
            RELEASE VtaDTrkPed.
        END.
        WHEN 'IO' THEN DO:           
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
                vtadtrkped.Usuario = pusuario.
            /* Verificamos última entrada del tracking */
/*             FIND LAST Vtadtrkped WHERE Vtadtrkped.codcia = pcodcia */
/*                 AND Vtadtrkped.coddiv = pcoddiv                    */
/*                 AND Vtadtrkped.coddoc = pcoddoc                    */
/*                 AND Vtadtrkped.nroped = pnroped                    */
/*                 AND Vtadtrkped.flgsit <> 'A'                       */
/*                 EXCLUSIVE-LOCK NO-ERROR.                           */
/*             IF NOT AVAILABLE Vtadtrkped THEN DO:                   */
/*                 MESSAGE  'ERROR EN EL TRACKING' SKIP               */
/*                     'NO se puede anular el Tracking'               */
/*                     VIEW-AS ALERT-BOX ERROR.                       */
/*                 RETURN 'ADM-ERROR'.                                */
/*             END.                                                   */
/*             IF Vtadtrkped.codubi <> pcodubi THEN DO:               */
/*                 MESSAGE 'NO se puede anular el Tracking'           */
/*                     VIEW-AS ALERT-BOX ERROR.                       */
/*                 RETURN 'ADM-ERROR'.                                */
/*             END.                                                   */
            /* Verificamos si es un proceso logico */
            FIND VtaCTrkPed WHERE Vtactrkped.codcia = pcodcia
                AND Vtactrkped.coddiv = pcoddiv
                AND Vtactrkped.coddoc = pcoddoc
                AND Vtactrkped.nroped = pnroped
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE VtaCTrkPed THEN UNDO, RETURN 'ADM-ERROR'.
            ASSIGN
                vtactrkped.FechaT = pfechat
                vtactrkped.FlgSit = pflgsit.
            ASSIGN
                vtadtrkped.FlgSit = pFlgSit
                vtadtrkped.FechaT = pfechat
                vtadtrkped.Usuario = pusuario.
            RELEASE VtaCTrkPed.
            RELEASE VtaDTrkPed.
        END.
    END CASE.
END.
RETURN 'OK'.

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
/* caso especial GNP */
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
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
        WHEN 'C' THEN DO:
            MESSAGE 'ERROR EN EL TRACKING' SKIP
                'El tracking del pedido está CERRADO'
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
        WHEN 'S' THEN DO:
            MESSAGE 'ERROR EN EL TRACKING' SKIP
                'El tracking del pedido está SUSPENDIDO'
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
/*         WHEN 'A' THEN DO:                             */
/*             MESSAGE 'ERROR EN EL TRACKING' SKIP       */
/*                 'El tracking del pedido está ANULADO' */
/*                 VIEW-AS ALERT-BOX ERROR.              */
/*             RETURN 'ADM-ERROR'.                       */
/*         END.                                          */
        END CASE.
    END.
    CASE pCodIO:
        WHEN 'I' THEN DO:           /* INICIO DE UN PROCESO */
            /* Verificamos última entrada del tracking */
            FIND LAST Vtadtrkped WHERE Vtadtrkped.codcia = pcodcia
                AND Vtadtrkped.coddiv = pcoddiv
                AND Vtadtrkped.coddoc = pcoddoc
                AND VTadtrkped.nroped = pnroped
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Vtadtrkped OR Vtadtrkped.FechaT = ? THEN DO:
                MESSAGE 'ERROR EN EL TRACKING' SKIP
                    'El proceso anterior aun no se ha concluido'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
            /* Verificamos si es un proceso logico */
            FIND FIRST VtaFTrkPed WHERE vtaftrkped.Codcia = pcodcia
                AND vtaftrkped.CodDiv = pcoddiv
                AND vtaftrkped.CodUbic2 = pcodubi
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE vtaftrkped OR vtaftrkped.CodUbic1 <> vtadtrkped.CodUbic THEN DO:
                MESSAGE 'ERROR EN EL TRACKING' SKIP
                    'El proceso NO sigue el flujo logico'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
            FIND VtaCTrkPed WHERE Vtactrkped.codcia = pcodcia
                AND Vtactrkped.coddiv = pcoddiv
                AND Vtactrkped.coddoc = pcoddoc
                AND Vtactrkped.nroped = pnroped
                EXCLUSIVE-LOCK NO-ERROR.
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
            RELEASE VtaCTrkPed.
            RELEASE VtaDTrkPed.
        END.
        WHEN 'O' THEN DO:           /* CIERRE DE UN PROCESO */
            /* Verificamos última entrada del tracking */
            FIND LAST Vtadtrkped WHERE Vtadtrkped.codcia = pcodcia
                AND Vtadtrkped.coddiv = pcoddiv
                AND Vtadtrkped.coddoc = pcoddoc
                AND VTadtrkped.nroped = pnroped
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Vtadtrkped 
                OR NOT (Vtadtrkped.codubi = pcodubi AND Vtadtrkped.FechaT = ?) THEN DO:
                MESSAGE  'ERROR EN EL TRACKING' SKIP
                    'El proceso de inicio NO existe' SKIP
                        'o YA fue concluido'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
            FIND VtaCTrkPed WHERE Vtactrkped.codcia = pcodcia
                AND Vtactrkped.coddiv = pcoddiv
                AND Vtactrkped.coddoc = pcoddoc
                AND Vtactrkped.nroped = pnroped
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE VtaCTrkPed THEN UNDO, RETURN 'ADM-ERROR'.
            ASSIGN
                vtactrkped.FechaT = pfechat
                vtactrkped.FlgSit = pflgsit
                vtactrkped.CodUbic = pcodubi.
            FIND CURRENT VtaDTrkPed EXCLUSIVE-LOCK.
            ASSIGN
                vtadtrkped.FechaT = pfechat
                vtadtrkped.Usuario = pusuario.
            RELEASE VtaCTrkPed.
            RELEASE VtaDTrkPed.
        END.
        WHEN 'IO' THEN DO:           
            /* Verificamos última entrada del tracking */
            FIND LAST Vtadtrkped WHERE Vtadtrkped.codcia = pcodcia
                AND Vtadtrkped.coddiv = pcoddiv
                AND Vtadtrkped.coddoc = pcoddoc
                AND VTadtrkped.nroped = pnroped
                AND Vtadtrkped.flgsit <> 'A'
                NO-LOCK NO-ERROR.
            IF pCodUbi <> 'GNP' THEN DO:
                IF NOT AVAILABLE Vtadtrkped OR Vtadtrkped.FechaT = ? THEN DO:
                    MESSAGE  'ERROR EN EL TRACKING' SKIP
                        'El proceso anterior aun no se ha concluido'
                        VIEW-AS ALERT-BOX ERROR.
                    RETURN 'ADM-ERROR'.
                END.
                /* Verificamos si es un proceso logico */
                FIND FIRST VtaFTrkPed WHERE vtaftrkped.Codcia = pcodcia
                    AND vtaftrkped.CodDiv = pcoddiv
                    AND vtaftrkped.CodUbic2 = pcodubi
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE vtaftrkped OR vtaftrkped.CodUbic1 <> vtadtrkped.CodUbic THEN DO:
                    MESSAGE  'ERROR EN EL TRACKING' SKIP
                        'El proceso NO sigue el flujo logico (' pcodubi ')'
                        VIEW-AS ALERT-BOX ERROR.
                    RETURN 'ADM-ERROR'.
                END.
                FIND VtaCTrkPed WHERE Vtactrkped.codcia = pcodcia
                    AND Vtactrkped.coddiv = pcoddiv
                    AND Vtactrkped.coddoc = pcoddoc
                    AND Vtactrkped.nroped = pnroped
                    EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE VtaCTrkPed THEN UNDO, RETURN 'ADM-ERROR'.
                ASSIGN
                    vtactrkped.FechaT = pfechat
                    vtactrkped.FlgSit = pflgsit
                    vtactrkped.CodUbic = pcodubi.
            END.
            ELSE DO:
                IF AVAILABLE Vtadtrkped THEN DO:
                    MESSAGE  'ERROR EN EL TRACKING' SKIP
                        'Existe un proceso anterior (¿?)'
                        VIEW-AS ALERT-BOX ERROR.
                    RETURN 'ADM-ERROR'.
                END.
                CREATE  VtaCTrkPed.
                ASSIGN
                    vtactrkped.CodCia = pCodCia
                    vtactrkped.CodCli = x-CodCli
                    vtactrkped.CodDiv = pCodDiv
                    vtactrkped.CodDoc = pCodDoc
                    vtactrkped.NroPed = pNroPed
                    vtactrkped.CodUbic = pCodUbi
                    vtactrkped.FchCot = x-FchCot
                    vtactrkped.FechaI = pFechaI
                    vtactrkped.FechaT = pFechaT
                    vtactrkped.FlgSit = pFlgSit
                    vtactrkped.NroCot = x-NroCot.
            END.
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
                vtadtrkped.Usuario = pusuario.
            RELEASE VtaCTrkPed.
            RELEASE VtaDTrkPed.
        END.
    END CASE.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

