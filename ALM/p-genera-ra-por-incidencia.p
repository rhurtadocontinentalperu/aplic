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

DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF SHARED VAR s-CodCia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

IF NOT CAN-FIND(FIRST AlmCIncidencia WHERE ROWID(AlmCIncidencia) = pRowid NO-LOCK)
    THEN DO:
    pMensaje = 'Registro de Incidencia NO encontrado'.
    RETURN 'ADM-ERROR'.
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
         HEIGHT             = 4.65
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF VAR pFechaEntrega AS DATE NO-UNDO.
DEF VAR pMensaje2 AS CHAR NO-UNDO.
DEF VAR pNroSalida AS CHAR NO-UNDO.
DEF VAR pNroIngreso AS CHAR NO-UNDO.

DEFINE BUFFER b-faccpedi FOR faccpedi.
DEFINE BUFFER b-almcrepo FOR almcrepo.

DEFINE VAR x-rowid-cpedi AS ROWID.
DEFINE VAR x-rowid-crepo AS ROWID.

DEF VAR hProc AS HANDLE NO-UNDO.
RUN gn/master-library PERSISTENT SET hProc.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="AlmCIncidencia" ~
        &Condicion="ROWID(AlmCIncidencia) = pRowid" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, LEAVE" }
    FIND FIRST AlmDIncidencia OF AlmCIncidencia NO-LOCK.
    /* Barremos todas las R/A relacionadas a esta incidencia */
    FOR EACH Almcrepo NO-LOCK WHERE almcrepo.CodCia = AlmCIncidencia.CodCia AND
        almcrepo.TipMov = "INC" AND
        almcrepo.CodRef = "INC" AND
        almcrepo.NroRef = AlmCIncidencia.NroControl AND
        almcrepo.FlgEst = "P" AND 
        almcrepo.FlgSit = "G":
        x-rowid-crepo = ROWID(almcrepo).
        /* ****************************************************************************** */
        /* 1ro. Generamos las OTR */
        /* ****************************************************************************** */
        RUN genera-OTR IN hProc ("R/A",
                                 ROWID(Almcrepo),
                                 NO,
                                 "",
                                 OUTPUT pFechaEntrega,
                                 OUTPUT pMensaje,
                                 OUTPUT pMensaje2).
/*         RUN alm/genera-otr (ROWID(Almcrepo),      */
/*                             NO,                   */
/*                             "",                   */
/*                             OUTPUT pFechaEntrega, */
/*                             OUTPUT pMensaje,      */
/*                             OUTPUT pMensaje2).    */
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar la Orden de Transferencias'.
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        /* 2do. Generamos las Salidas por Transferencia por cada OTR */
        FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-CodCia
            AND Faccpedi.coddoc = 'OTR'
            AND Faccpedi.codref = 'R/A'
            AND INTEGER(SUBSTRING(Faccpedi.nroref,1,3)) = Almcrepo.nroser
            AND INTEGER(SUBSTRING(Faccpedi.nroref,4)) = Almcrepo.nrodoc
            AND Faccpedi.flgest = "P":

            x-rowid-cpedi = ROWID(faccpedi).

            CASE almcrepo.Incidencia:
                WHEN "F" OR WHEN "S" THEN DO:
                    /* SALIDA E INGRESO AUTOMATICO */
                    RUN dist/p-transfxppv-v2 ("APPEND",
                                              ROWID(Faccpedi),
                                              Faccpedi.CodAlm,
                                              Faccpedi.CodCli,
                                              OUTPUT pNroSalida,
                                              OUTPUT pNroIngreso,
                                              OUTPUT pMensaje).
                    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                        IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar las Transferencias'.
                        UNDO RLOOP, RETURN 'ADM-ERROR'.
                    END.

                    /* Ic - 20Set2018 */
                    FIND FIRST b-faccpedi WHERE ROWID(b-faccpedi) = x-rowid-cpedi EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT AVAILABLE b-faccpedi THEN DO:
                        pMensaje = "NO se pudo actualizar el faccpedi.flgest y flgest = 'C' y 'C' ".
                        UNDO RLOOP, RETURN 'ADM-ERROR'.
                    END.

                    ASSIGN
                        b-Faccpedi.FlgSit = "C"   /* Chequeado */
                        b-Faccpedi.FlgEst = "C".  /* Atendido */
                    /* *********************************************************************************** */
                    /* RHC 23/02/2019 Solicitado por Lucy Mesia */
                    /* Viene de una INCidencia */
                    /* *********************************************************************************** */
                    ASSIGN
                        b-Faccpedi.fchchq = TODAY
                        b-Faccpedi.horchq = STRING(TIME,'HH:MM:SS').
                    /* *********************************************************************************** */
                    FOR EACH Facdpedi OF Faccpedi EXCLUSIVE-LOCK:
                        Facdpedi.CanAte = Facdpedi.CanPed.
                    END.
                END.
            END CASE.

            /* Ic - 20Set2018 */
            FIND FIRST b-faccpedi WHERE ROWID(b-faccpedi) = x-rowid-cpedi EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE b-faccpedi THEN DO:
                pMensaje = "NO se pudo actualizar el faccpedi.tpoped = 'INC' ".
                UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
            ASSIGN
                b-Faccpedi.TpoPed = "INC".    /* OTR por Incidencia */
        END.

        /* ****************************************************************************** */
        /* Ic - 20Set2018 */
        /* ****************************************************************************** */
        FIND FIRST b-almcrepo WHERE ROWID(b-almcrepo) = x-rowid-crepo EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE b-almcrepo THEN DO:
            pMensaje = "NO se pudo actualizar la reposicion(almcrepo.flgest y flgsit = 'P' y 'G') ".
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            b-almcrepo.FlgEst = "P"
            b-almcrepo.FlgSit = "G".
        /* RHC 09/04/2019 Cambiar de estado para que no afecte el stock comprometido */
        ASSIGN
            b-almcrepo.FlgEst = "C".
        /* ****************************************************************************** */
        /* ****************************************************************************** */
    END.
    ASSIGN
        AlmCIncidencia.FlgEst = "C"
        AlmCIncidencia.FechaAprobacion = TODAY
        AlmCIncidencia.HoraAprobacion = STRING(TIME, 'HH:MM:SS')
        AlmCIncidencia.UsrAprobacion = s-user-id.
END.
DELETE PROCEDURE hProc.
IF AVAILABLE(AlmCIncidencia) THEN RELEASE AlmCIncidencia.
IF AVAILABLE(Almcrepo) THEN RELEASE Almcrepo.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(b-Almcrepo) THEN RELEASE Almcrepo.
IF AVAILABLE(b-Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.

IF pMensaje > '' THEN RETURN 'ADM-ERROR'.
RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


