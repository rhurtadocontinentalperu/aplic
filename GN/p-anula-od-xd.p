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
DEF INPUT PARAMETER pDevolucion AS LOG.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

IF pDevolucion = ? THEN RETURN 'ADM-ERROR'.

DEF BUFFER B-CPEDI FOR Faccpedi.
DEF BUFFER B-DPEDI FOR Facdpedi.
DEF BUFFER ORDEN   FOR Faccpedi.
DEF BUFFER B-ALMA  FOR Almacen.
DEF BUFFER ITEM    FOR Almdmov.
DEF BUFFER CMOV    FOR Almcmov.

FIND B-CPEDI WHERE ROWID(B-CPEDI) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CPEDI THEN RETURN 'ADM-ERROR'.

DEF VAR s-CodMov AS INT INIT 03 NO-UNDO.

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
         HEIGHT             = 6.23
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Dos casos:
    - pDevolucion = NO  => Crear una salida x transf y un ingreso automático
    - pDevolucion = YES => Genera una nueva OTR al almacén de origen
    
*/

pMensaje = ''.
/* Buscamos el PED Origen */
FIND ORDEN WHERE ORDEN.codcia = B-CPEDI.codcia 
    AND ORDEN.coddoc = B-CPEDI.codref       /* PED */
    AND ORDEN.nroped = B-CPEDI.nroref 
    AND ORDEN.crossdocking = YES
    AND ORDEN.flgest <> "A"
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE ORDEN THEN DO:
    pMensaje = "NO se pudo ubicar el PED Origen".
    UNDO, RETURN 'ADM-ERROR'.
END.
CASE TRUE:
    WHEN pDevolucion = YES THEN DO:
        RUN vta2/pmigraordendesp-v2.p (
            B-CPEDI.CodAlm,         /* Almacén de Origen */
            ORDEN.CodAlm,           /* Almacén de Destino */
            B-CPEDI.CodDoc,         /* OTR a duplicar */
            B-CPEDI.NroPed,
            OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.
    WHEN pDevolucion = NO THEN DO:
        RUN salida-ingreso.
    END.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Ingreso) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ingreso Procedure 
PROCEDURE Ingreso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pAlmOri AS CHAR.
DEF INPUT PARAMETER pRowid  AS ROWID.

DEF VAR x-Nrodoc LIKE Almtdocm.NroDoc NO-UNDO.
DEF VAR s-CodAlm AS CHAR NO-UNDO.
DEF VAR r-Rowid AS ROWID NO-UNDO.

s-CodAlm = pAlmOri.
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="CMOV" ~
        &Condicion="ROWID(CMOV) = pRowid" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        }
    ASSIGN 
        x-Nrodoc  = Almtdocm.NroDoc.
    REPEAT:
        IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia
                        AND Almcmov.CodAlm = Almtdocm.CodAlm 
                        AND Almcmov.TipMov = Almtdocm.TipMov
                        AND Almcmov.CodMov = Almtdocm.CodMov
                        AND Almcmov.NroSer = 000
                        AND Almcmov.NroDoc = x-NroDoc
                        NO-LOCK)
            THEN LEAVE.
        ASSIGN
            x-NroDoc = x-NroDoc + 1.
    END.
    CREATE Almcmov.
    ASSIGN
        Almcmov.CodCia  = Almtdocm.CodCia 
        Almcmov.TipMov  = Almtdocm.TipMov 
        Almcmov.CodMov  = Almtdocm.CodMov 
        Almcmov.CodAlm  = s-CodAlm 
        Almcmov.AlmDes  = CMOV.CodAlm
        Almcmov.NroSer  = 000
        Almcmov.NroDoc  = x-NroDoc
        Almcmov.FlgSit  = ""
        Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS")
        Almcmov.usuario = S-USER-ID
        Almcmov.NroRf1 = STRING(CMOV.NroSer, '999') + STRING(CMOV.NroDoc)
        Almcmov.NroRf3 = CMOV.NroRf3
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = ERROR-STATUS:GET-MESSAGE(1).
        UNDO, RETURN "ADM-ERROR".
    END.
    FIND Almacen WHERE Almacen.CodCia = Almtdocm.CodCia 
        AND  Almacen.CodAlm = Almcmov.AlmDes
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN Almcmov.NomRef = Almacen.Descripcion.

    ASSIGN
        Almtdocm.NroDoc = x-NroDoc + 1.
    FOR EACH ITEM OF CMOV NO-LOCK:
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
            Almdmov.TpoCmb = Almcmov.TpoCmb 
            Almdmov.codmat = ITEM.codmat 
            Almdmov.CanDes = ITEM.CanDes 
            Almdmov.CodUnd = ITEM.CodUnd 
            Almdmov.Factor = ITEM.Factor 
            Almdmov.ImpCto = ITEM.ImpCto 
            Almdmov.PreUni = ITEM.PreUni 
            Almdmov.AlmOri = Almcmov.AlmDes 
            Almdmov.CodAjt = '' 
            Almdmov.HraDoc = Almcmov.HorRcp
            R-ROWID = ROWID(Almdmov).
        RUN ALM\ALMACSTK (R-ROWID).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

        RUN alm/almacpr1 (R-ROWID, 'U').
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN 
        CMOV.FlgSit  = "R" 
        CMOV.HorRcp  = STRING(TIME,"HH:MM:SS")
        CMOV.NroRf2  = STRING(Almcmov.NroDoc).
    ASSIGN
        Almcmov.Libre_L02 = CMOV.Libre_L02    /* URGENTE */
        Almcmov.Libre_C05 = CMOV.Libre_C05.   /* MOTIVO */
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Salida) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Salida Procedure 
PROCEDURE Salida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pAlmPrincipal AS CHAR.
DEF OUTPUT PARAMETER pRowid AS ROWID.

DEF VAR x-Item AS INT INIT 0 NO-UNDO.
DEF VAR r-Rowid AS ROWID NO-UNDO.
DEF VAR x-NroDoc LIKE Almcmov.nrodoc INIT 0 NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i
        &Tabla="Almacen"
        &Condicion="Almacen.codcia = s-codcia AND Almacen.codalm = B-CPEDI.codalm"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    ASSIGN 
        x-Nrodoc  = Almacen.CorrSal.
    REPEAT:
        IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = s-CodCia
                        AND Almcmov.CodAlm = B-CPEDI.CodAlm 
                        AND Almcmov.TipMov = "S"
                        AND Almcmov.CodMov = s-CodMov
                        AND Almcmov.NroSer = 000
                        AND Almcmov.NroDoc = x-NroDoc
                        NO-LOCK)
            THEN LEAVE.
        ASSIGN x-NroDoc = x-NroDoc + 1.
    END.
    ASSIGN 
        Almacen.CorrSal = x-NroDoc + 1.
    CREATE Almcmov.
    ASSIGN 
        Almcmov.CodCia = s-CodCia 
        Almcmov.CodAlm = Almacen.CodAlm 
        Almcmov.AlmDes = pAlmPrincipal      /* ALMACEN PRINCIPAL */
        Almcmov.TipMov = "S"
        Almcmov.CodMov = s-CodMov
        Almcmov.NroSer = 000
        Almcmov.NroDoc = x-NroDoc
        Almcmov.FlgSit = "T"      /* Transferido pero no Recepcionado */
        Almcmov.FchDoc = TODAY
        Almcmov.HorSal = STRING(TIME,"HH:MM")
        Almcmov.HraDoc = STRING(TIME,"HH:MM")
        Almcmov.usuario = S-USER-ID.
    ASSIGN
        Almacen.CorrSal = Almacen.CorrSal + 1.
    FOR EACH B-DPEDI OF B-CPEDI NO-LOCK:
        CREATE Almdmov.
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
            Almdmov.codmat = B-DPEDI.codmat
            Almdmov.CanDes = B-DPEDI.CanPed
            Almdmov.CodUnd = B-DPEDI.UndVta
            Almdmov.Factor = B-DPEDI.Factor
            /*Almdmov.ImpCto = ITEM.ImpCto
            Almdmov.PreUni = ITEM.PreUni*/
            Almdmov.AlmOri = Almcmov.AlmDes 
            Almdmov.CodAjt = ''
            Almdmov.HraDoc = HorSal
            Almdmov.NroItm = x-Item
            R-ROWID = ROWID(Almdmov).
        x-Item = x-Item + 1.
        RUN alm/almdcstk (R-ROWID).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        RUN alm/almacpr1 (R-ROWID, "U").
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN 
        Almcmov.Libre_c02 = "C".
    ASSIGN
        pRowid = ROWID(Almcmov).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-salida-ingreso) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE salida-ingreso Procedure 
PROCEDURE salida-ingreso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pAlmPrincipal AS CHAR NO-UNDO.
DEF VAR pRowid AS ROWID NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Buscamos el Almacén Principal de la sede */
    FIND Almacen WHERE Almacen.codcia = B-CPEDI.codcia
        AND Almacen.codalm = B-CPEDI.codalm
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN DO:
        pMensaje = "NO se encontró el almacén " + B-CPEDI.codalm.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    FIND FIRST B-ALMA WHERE B-ALMA.codcia = s-codcia
        AND B-ALMA.coddiv = Almacen.coddiv
        AND CAN-FIND(FIRST TabGener WHERE TabGener.CodCia = s-codcia
                     AND TabGener.Clave = "ZG"
                     AND TabGener.Libre_C01 = B-ALMA.codalm
                     AND TabGener.Libre_L01 = YES NO-LOCK)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-ALMA THEN DO:
        pMensaje = "NO existe un almacén principal para la división " + Almacen.coddiv.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    pAlmPrincipal = B-ALMA.CodAlm.
    /* ************************************************************************************* */
    /* Primero la Salida */
    /* ************************************************************************************* */
    RUN Salida (INPUT pAlmPrincipal, OUTPUT pRowid).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo generar la salida automática".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ************************************************************************************* */
    /* Segundo el Ingreso */
    /* ************************************************************************************* */
    {lib/lock-genericov3.i ~
        &Tabla="Almtdocm" ~
        &Condicion="Almtdocm.CodCia = s-CodCia AND ~
        Almtdocm.CodAlm = pAlmPrincipal AND ~
        Almtdocm.TipMov = 'I' AND ~
        Almtdocm.CodMov = s-CodMov" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        }
    RUN Ingreso (INPUT pAlmPrincipal, INPUT pRowid).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo generar el ingreso automático".
        UNDO, RETURN 'ADM-ERROR'.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

