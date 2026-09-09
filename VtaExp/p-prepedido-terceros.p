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

DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodCli AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF SHARED VAR s-CodCia AS INTE.
DEF SHARED VAR s-CodDiv AS CHAR.
DEF SHARED VAR s-User-Id AS CHAR.

DEF VAR s-CodDoc AS CHAR INIT 'PPT' NO-UNDO.

/* Verificamos si está configurado en la división */
IF NOT CAN-FIND(FIRST FacDocum WHERE FacDocum.CodCia = s-CodCia
                AND FacDocum.CodDoc = s-CodDoc NO-LOCK) THEN DO:
    pMensaje = "NO está configurado el documento " + s-coddoc + CHR(10) +
        "Avisar al administrador".
    RETURN 'ADM-ERROR'.
END.
FIND FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia
    AND FacCorre.CodDiv = s-CodDiv
    AND FacCorre.CodDoc = s-CodDoc
    AND FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    pMensaje = "NO está configurado el correlativo para el documento " + s-coddoc + CHR(10) +
        "Avisar al administrador".
    RETURN 'ADM-ERROR'.
END.
/* Verificamos si hay notas de pedidos de terceros */
FIND FIRST AlmCatVtaD WHERE AlmCatVtaD.CodCia = s-CodCia
    AND AlmCatVtaD.CodDiv = pCodDiv
    AND CAN-FIND(FIRST AlmCatVtaC OF AlmCatVtaD WHERE 
                 CAN-FIND(FIRST VtaCatVenta OF AlmCatVtaC NO-LOCK) NO-LOCK)
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE AlmCatVtaD THEN DO:
    pMensaje = "NO hay Notas de Pedido de TERCEROS para la lista " + pCodDiv + CHR(10) +
        "Avisar al administrador".
    RETURN 'ADM-ERROR'.
END.

/* Verificamos Cliente */
DEF SHARED VAR cl-codcia AS INTE.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = pCodCli
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clie THEN DO:
    pMensaje = "Cliente no registrado " + pCodCli + CHR(10) +
        "Avisar al administrador".
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
         HEIGHT             = 3.81
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* Deshabiltamos triggers para acelerar el proceso */
DISABLE TRIGGERS FOR LOAD OF Vtacdocu.
DISABLE TRIGGERS FOR LOAD OF Vtaddocu.

/* Solo se puede generar un pedido a la vez */
IF CAN-FIND(FIRST VtaCDocu WHERE VtaCDocu.CodCia = s-CodCia
            AND VtaCDocu.CodDiv = s-CodDiv
            AND VtaCDocu.CodPed = s-CodDoc
            AND VtaCDocu.FlgEst <> "A"      /* NO anuladas */
            AND VtaCDocu.CodCli = pCodCli
            AND VtaCDocu.FchVen >= TODAY    /* Vigente */
            NO-LOCK)
    THEN RETURN 'OK'.


DEF VAR pCuenta AS INTE NO-UNDO.
DEF VAR x-NroItm AS INTE NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').
    /* Control de Correlativos */
    {lib/lock-genericov3.i ~
        &Tabla="FacCorre" ~
        &Alcance="FIRST" ~
        &Condicion="FacCorre.CodCia = s-CodCia ~
        AND FacCorre.CodDiv = s-CodDiv ~
        AND FacCorre.CodDoc = s-CodDoc ~
        AND FacCorre.FlgEst = YES" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        }
    /* Creamos PPT (Pre-Pedido Terceros) */
    CREATE VtaCDocu.
    ASSIGN
        VtaCDocu.CodCia = s-CodCia
        VtaCDocu.CodPed = s-CodDoc
        VtaCDocu.NroPed = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999')
        VtaCDocu.FlgEst = "P"
        VtaCDocu.CodCli = pCodCli
        VtaCDocu.DniCli = gn-clie.dni
        VtaCDocu.NomCli = gn-clie.nomcli
        VtaCDocu.RucCli = gn-clie.ruc
        VtaCDocu.CodDiv = s-CodDiv
        VtaCDocu.Libre_c01 = pCodDiv
        VtaCDocu.FchPed = TODAY
        VtaCDocu.FchVen = TODAY + 7
        VtaCDocu.Hora = STRING(TIME, 'HH:MM:SS')
        VtaCDocu.usuario = s-User-Id
        NO-ERROR
        .
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ACtualizamos el correlativo */
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /* Detalle */
    x-NroItm = 1.
    FOR EACH almcatvtac NO-LOCK WHERE almcatvtac.codcia = s-codcia 
            AND almcatvtac.coddiv = pCodDiv,
        FIRST VtaCatVenta NO-LOCK WHERE VtaCatVenta.CodCia = almcatvtac.codcia
            AND VtaCatVenta.CodDiv = almcatvtac.coddiv
            AND VtaCatVenta.CodPro = AlmCatVtaC.CodPro,
        EACH almcatvtad USE-INDEX Index01 NO-LOCK WHERE almcatvtad.codcia = s-codcia
            AND almcatvtad.coddiv = almcatvtac.coddiv
            AND almcatvtad.codpro = almcatvtac.codpro,
            FIRST almmmatg OF Almcatvtad NO-LOCK:
        FIND FIRST VtaDDocu OF VtaCDocu WHERE VtaDDocu.CodMat = Almcatvtad.CodMat NO-LOCK NO-ERROR.
        IF AVAILABLE VtaDDocu THEN NEXT.
        CREATE VtaDDocu.
        BUFFER-COPY VtaCDocu TO VtaDDocu
            ASSIGN
            VtaDDocu.Libre_c01 = STRING(AlmCatVtaD.NroPag,"9999")
            VtaDDocu.Libre_c02 = STRING(AlmCatVtaD.NroSec,"9999")
            VtaDDocu.Libre_c03 = AlmCatVtaD.CodPro
            VtaDDocu.Libre_c04 = AlmCatVtaD.Libre_c05   /* Descrip. grupo */
            VtaDDocu.Libre_d01 = AlmCatVtaD.Libre_d02   /* Mínimo */
            VtaDDocu.Libre_d02 = AlmCatVtaD.Libre_d03   /* Empaque */
            VtaDDocu.CodMat = Almmmatg.CodMat
            VtaDDocu.CanPed = 0
            VtaDDocu.Factor = 1
            VtaDDocu.NroItm = x-NroItm
            VtaDDocu.UndVta = Almmmatg.CHR__01
            .
        x-NroItm = x-NroItm + 1.
    END.

IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(VtaCDocu) THEN RELEASE VtaCDocu.
IF AVAILABLE(VtaDDocu) THEN RELEASE VtaDDocu.
SESSION:SET-WAIT-STATE('').

IF pMensaje > '' THEN RETURN 'ADM-ERROR'.
ELSE RETURN 'OK'.

/*
SESSION:SET-WAIT-STATE('GENERAL').
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Control de Correlativos */
    {lib/lock-genericov3.i ~
        &Tabla="FacCorre" ~
        &Alcance="FIRST" ~
        &Condicion="FacCorre.CodCia = s-CodCia ~
        AND FacCorre.CodDiv = pCodDiv ~
        AND FacCorre.CodDoc = s-CodDoc ~
        AND FacCorre.FlgEst = YES" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, LEAVE" ~
        }
    /* Creamos PPT (Pre-Pedido Terceros) */
    CREATE VtaCDocu.
    ASSIGN
        VtaCDocu.CodCia = s-CodCia
        VtaCDocu.CodPed = s-CodDoc
        VtaCDocu.NroPed = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999')
        VtaCDocu.FlgEst = "P"
        VtaCDocu.CodCli = pCodCli
        VtaCDocu.DniCli = gn-clie.dni
        VtaCDocu.NomCli = gn-clie.nomcli
        VtaCDocu.RucCli = gn-clie.ruc
        VtaCDocu.CodDiv = pCodDiv
        VtaCDocu.FchPed = TODAY
        VtaCDocu.FchVen = TODAY + 7
        VtaCDocu.Hora = STRING(TIME, 'HH:MM:SS')
        VtaCDocu.usuario = s-User-Id
        NO-ERROR
        .
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
        UNDO, LEAVE.
    END.
    /* ACtualizamos el correlativo */
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /* Detalle */
    x-NroItm = 1.
    FOR EACH almcatvtac NO-LOCK WHERE almcatvtac.codcia = s-codcia 
            AND almcatvtac.coddiv = pCodDiv,
        FIRST VtaCatVenta NO-LOCK WHERE VtaCatVenta.CodCia = almcatvtac.codcia
            AND VtaCatVenta.CodDiv = almcatvtac.coddiv
            AND VtaCatVenta.CodPro = AlmCatVtaC.CodPro,
        EACH almcatvtad USE-INDEX Index01 NO-LOCK WHERE almcatvtad.codcia = s-codcia
            AND almcatvtad.coddiv = almcatvtac.coddiv
            AND almcatvtad.codpro = almcatvtac.codpro,
            FIRST almmmatg OF Almcatvtad NO-LOCK:
        FIND FIRST VtaDDocu OF VtaCDocu WHERE VtaDDocu.CodMat = Almcatvtad.CodMat NO-LOCK NO-ERROR.
        IF AVAILABLE VtaDDocu THEN NEXT.
        CREATE VtaDDocu.
        BUFFER-COPY VtaCDocu TO VtaDDocu
            ASSIGN
            VtaDDocu.Libre_c01 = STRING(AlmCatVtaD.NroPag,"9999")
            VtaDDocu.Libre_c02 = STRING(AlmCatVtaD.NroSec,"9999")
            VtaDDocu.Libre_c03 = AlmCatVtaD.CodPro
            VtaDDocu.CodMat = Almmmatg.CodMat
            VtaDDocu.CanPed = 0
            VtaDDocu.Factor = 1
            VtaDDocu.NroItm = x-NroItm
            VtaDDocu.UndVta = Almmmatg.CHR__01
            .
        x-NroItm = x-NroItm + 1.
    END.
END.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(VtaCDocu) THEN RELEASE VtaCDocu.
IF AVAILABLE(VtaDDocu) THEN RELEASE VtaDDocu.
SESSION:SET-WAIT-STATE('').
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


