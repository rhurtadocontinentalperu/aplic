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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.


/* Sintaxis 
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN <libreria> PERSISTENT SET hProc.
RUN <libreria>.rutina_internaIN hProc (input  buffer tt-excel:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .
DELETE PROCEDURE hProc.
*/

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


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-GRE_Generacion_Detalle_S03) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRE_Generacion_Detalle_S03 Procedure 
PROCEDURE GRE_Generacion_Detalle_S03 PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR x-Item AS INTE INIT 1 NO-UNDO.
DEF VAR R-ROWID AS ROWID NO-UNDO.

FOR EACH Facdpedi OF Faccpedi NO-LOCK BY Facdpedi.NroItm:
    CREATE almdmov.
    ASSIGN 
        Almdmov.CodCia = Almcmov.CodCia 
        Almdmov.CodAlm = Almcmov.CodAlm 
        Almdmov.TipMov = Almcmov.TipMov 
        Almdmov.CodMov = Almcmov.CodMov 
        Almdmov.NroSer = Almcmov.NroSer
        Almdmov.NroDoc = Almcmov.NroDoc 
        Almdmov.CodMon = Almcmov.CodMon 
        Almdmov.FchDoc = Almcmov.FchDoc 
        Almdmov.HraDoc = Almcmov.HraDoc
        Almdmov.TpoCmb = Almcmov.TpoCmb
        Almdmov.codmat = Facdpedi.codmat
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = "Registro duplicado en el código " + Facdpedi.codmat.
        UNDO, RETURN "ADM-ERROR".
    END.
    ASSIGN
        Almdmov.CanDes = Facdpedi.CanPed
        Almdmov.CodUnd = Facdpedi.UndVta
        Almdmov.Factor = Facdpedi.Factor
        /*Almdmov.ImpCto = Facdpedi.ImpCto*/
        Almdmov.PreUni = Facdpedi.PreUni
        Almdmov.AlmOri = Almcmov.AlmDes 
        Almdmov.CodAjt = ''
        Almdmov.HraDoc = Almcmov.HorSal
        Almdmov.NroItm = x-Item
        R-ROWID = ROWID(Almdmov).
    x-Item = x-Item + 1.
    RUN alm/almdcstk (R-ROWID).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    RUN alm/almacpr1 (R-ROWID, "U").
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRE_Generacion_Documentos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRE_Generacion_Documentos Procedure 
PROCEDURE GRE_Generacion_Documentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pnCorrelatio LIKE gre_header.ncorrelatio.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

FIND GRE_Header WHERE GRE_Header.ncorrelatio = pnCorrelatio NO-LOCK NO-ERROR.
IF NOT AVAILABLE GRE_Header THEN RETURN "ADM-ERROR".

/* De acuerdo a los datos de la GRE se genera el documento */
CASE TRUE:
    WHEN GRE_Header.m_tipmov = "S" AND GRE_Header.m_codmov = 3 AND GRE_Header.m_coddoc = "OTR" THEN DO:
        FIND Faccpedi WHERE Faccpedi.codcia = s-codcia AND
            Faccpedi.coddoc = GRE_Header.m_coddoc AND
            INTEGER(SUBSTRING(Faccpedi.nroped,1,3)) = GRE_Header.m_nroser AND
            INTEGER(SUBSTRING(Faccpedi.nroped,4)) = GRE_Header.m_nrodoc
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccpedi THEN RETURN "ADM-ERROR".
        RUN GRE_Generacion_S03 (INPUT Faccpedi.coddiv,
                                INPUT Faccpedi.coddoc,
                                INPUT Faccpedi.nroped,
                                OUTPUT pMensaje).
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
    END.
END CASE.


END PROCEDURE.


/*
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroPed AS CHAR.

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRE_Generacion_Pedido_S03) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRE_Generacion_Pedido_S03 Procedure 
PROCEDURE GRE_Generacion_Pedido_S03 PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF BUFFER B-CPEDI FOR Faccpedi.
DEF BUFFER B-DPEDI FOR Facdpedi.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FIND B-CPEDI WHERE B-CPEDI.codcia = s-codcia
        AND B-CPEDI.coddoc = Almcmov.codref
        AND B-CPEDI.nroped = Almcmov.nroref
        EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE B-CPEDI THEN DO:
        pMensaje = 'No se pudo bloquear la Orden de Transferencia'.
        RETURN "ADM-ERROR".
    END.
    FOR EACH almdmov OF almcmov NO-LOCK:
        FIND B-DPEDI OF B-CPEDI WHERE B-DPEDI.codmat = Almdmov.codmat
            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE B-DPEDI THEN DO:
            pMensaje = 'No se pudo bloquear el detalle de la Orden de Transferencia'.
            UNDO RLOOP, RETURN "ADM-ERROR".
        END.
        ASSIGN
            B-DPEDI.CanAte = B-DPEDI.CanAte + Almdmov.candes.
    END.
    FIND FIRST B-DPEDI OF B-CPEDI WHERE B-DPEDI.CanPed > B-DPEDI.CanAte NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-DPEDI 
    THEN B-CPEDI.FlgEst = 'C'.     /* Atendido */
    ELSE B-CPEDI.FlgEst = 'P'.     /* Pendiente */
    /* RHC 08/07/2104 La G/R hereda el chequeo */
    ASSIGN
        Almcmov.Libre_c02 = 'C'
        Almcmov.Libre_c03 = B-CPEDI.usrchq + '|' + 
            STRING(B-CPEDI.fchchq, '99/99/9999') + '|' +
            STRING(B-CPEDI.horchq,'HH:MM:SS') + '|' +
            STRING(B-CPEDI.fecsac, '99/99/9999') + '|' + B-CPEDI.horsac
        .
END.
IF AVAILABLE(B-CPEDI) THEN RELEASE B-CPEDI.
IF AVAILABLE(B-DPEDI) THEN RELEASE B-DPEDI.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRE_Generacion_S03) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRE_Generacion_S03 Procedure 
PROCEDURE GRE_Generacion_S03 PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroPed AS CHAR.

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

FIND Faccpedi WHERE Faccpedi.codcia = s-codcia AND
    Faccpedi.coddiv = pCodDiv AND
    Faccpedi.coddoc = pCodDoc AND
    Faccpedi.nroped = pNroPed
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN DO:
    pMensaje = "Documento " + pCodDoc + " " + pNroPed + " no encontrado".
    RETURN "ADM-ERROR".
END.

/* Buscamos correlativo del almacén */
/* Cargamos series */
DEF VAR l-NroSer AS CHAR NO-UNDO.
DEF VAR pSeries AS CHAR NO-UNDO.

RUN gn/p-series-solo-gr (INPUT pCodDiv,
                         INPUT "TRANSFERENCIAS",
                         INPUT YES,       /* SOLO ACTIVAS */
                         OUTPUT pSeries).

IF LOOKUP(l-NroSer, pSeries) = 0 THEN l-NroSer = l-NroSer + 
    (IF TRUE <> (l-NroSer > "") THEN "" ELSE ",") + 
    pSeries.
ELSE l-NroSer = pSeries.

DEF VAR k AS INTE NO-UNDO.
DEF VAR s-NroSer AS INTE NO-UNDO.

DO k = 1 TO NUM-ENTRIES(l-NroSer):
    s-NroSer = INTEGER(ENTRY(k, l-NroSer)) NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN NEXT.
    IF s-NroSer <> 0 THEN LEAVE.
END.

/* ***************************************************************************** */
/* RUTINA PRINCIPAL */
/* ***************************************************************************** */
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    {lib\lock-genericov3.i &Tabla="FacCorre" ~
        &Alcance="FIRST" ~
        &Condicion="FacCorre.CodCia = s-CodCia ~
        AND FacCorre.CodDiv = pCodDiv ~
        AND FacCorre.CodDoc = 'G/R' ~
        AND FacCorre.NroSer = s-NroSer" ~
        &Bloqueo= "EXCLUSIVE-LOCK no-error" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="RETURN 'ADM-ERROR'" ~
        }

    CREATE Almcmov.
    ASSIGN
        Almcmov.CodCia = s-CodCia 
        Almcmov.TipMov = "S"
        Almcmov.CodMov = 03
        Almcmov.FlgSit = "T"      /* Transferido pero no Recepcionado */
        Almcmov.FchDoc = TODAY
        Almcmov.HorSal = STRING(TIME,"HH:MM")
        Almcmov.HraDoc = STRING(TIME,"HH:MM")
        Almcmov.NroSer = s-NroSer
        Almcmov.NroDoc = FacCorre.Correlativo
        Almcmov.usuario = S-USER-ID
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = "Ingreso S03 duplicado: " + STRING(FacCorre.Correlativo).
        UNDO, RETURN "ADM-ERROR".
    END.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    RELEASE FacCorre.

    ASSIGN
        Almcmov.CodAlm = Faccpedi.codalm
        Almcmov.AlmDes = Faccpedi.codalm
        Almcmov.CodRef = Faccpedi.coddoc
        Almcmov.NroRef = Faccpedi.nroped
        Almcmov.Observ = Faccpedi.glosa
        Almcmov.AlmacenXD = Faccpedi.AlmacenXD
        Almcmov.CrossDocking = Faccpedi.CrossDocking
        Almcmov.NroRf3 = Faccpedi.libre_c03
        .
    /* RHC 01/09/16: Marca de URGENTE */
    ASSIGN 
        Almcmov.Libre_l02 = Faccpedi.VtaPuntual
        Almcmov.Libre_c05 = FacCPedi.MotReposicion.
    /* ***************************************************************************** */
    /* DETALLE */
    /* ***************************************************************************** */
    RUN GRE_Generacion_Detalle_S03 (OUTPUT pMensaje).
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
    /* ***************************************************************************** */

    /* ***************************************************************************** */
    /* ACTUALIZA ATENDIDO EN LA OTR */
    /* ***************************************************************************** */
    RUN GRE_Generacion_Pedido_S03 (OUTPUT pMensaje).
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
    /* ***************************************************************************** */

    /* ***************************************************************************** */
    /* RHC 01/12/17 Log para e-Commerce */
    /* ***************************************************************************** */
    DEF VAR pOk AS LOG NO-UNDO.

    RUN gn/log-inventory-qty.p (ROWID(Almcmov),
                                "C",      /* CREATE */
                                OUTPUT pOk).
    IF pOk = NO THEN DO:
        pMensaje = "NO se pudo actualizar el log de e-Commerce" + CHR(10) +
            "Proceso Abortado".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ***************************************************************************** */
    /* RHC 12/10/2020 CONTROL MR */
    /* ***************************************************************************** */
    DEFINE VAR hMaster AS HANDLE NO-UNDO.

    RUN gn/master-library PERSISTENT SET hMaster.
    RUN ML_Actualiza-TRF-Control IN hMaster (INPUT ROWID(Almcmov),     /* S-03 */
                                             OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    DELETE PROCEDURE hMaster.
    /* ***************************************************************************** */

END.
IF AVAILABLE(Almcmov) THEN RELEASE Almcmov.
IF AVAILABLE(Almdmov) THEN RELEASE Almdmov.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

