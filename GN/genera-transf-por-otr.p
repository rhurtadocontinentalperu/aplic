&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ITEM LIKE Almdmov.



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

/* GENERACION DE SALIDAS POR TRANSFERENCIAS (SERIE OOO) POR OTR */

DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

FIND FIRST Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN DO:
    pMensaje = "OTR no registrada" + CHR(10) + "No se pudo generar la Salida x Transferencia".
    RETURN 'ADM-ERROR'.
END.

DEF SHARED VAR s-CodCia AS INT.
DEF SHARED VAR s-User-Id AS CHAR.

DEF VAR s-TipMov AS CHAR INIT "S" NO-UNDO.
DEF VAR s-NroSer AS INT INIT 000 NO-UNDO.
DEF VAR s-AlmDes AS CHAR NO-UNDO.
DEF VAR x-NroDoc LIKE Almcmov.nrodoc INIT 0 NO-UNDO.
DEF VAR s-CodAlm AS CHAR.
DEF VAR s-CodMov AS INT INIT 03 NO-UNDO.
DEF VAR s-CodRef AS CHAR NO-UNDO.

s-CodAlm = Faccpedi.CodAlm.
s-CodRef = Faccpedi.CodDoc.

FIND Almtdocm WHERE Almtdocm.CodAlm = s-codalm
    AND Almtdocm.CodCia = s-codcia
    AND Almtdocm.TipMov = s-tipmov 
    AND CAN-FIND(FIRST Almtmovm OF Almtdocm WHERE Almtmovm.MovTrf = TRUE NO-LOCK)
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtdocm THEN DO:
    pMensaje = "Movimiento por Transferencia no registrado, almacén " + s-CodAlm + CHR(10) + 
        "No se pudo generar la Salida x Transferencia".
    RETURN 'ADM-ERROR'.
END.
s-CodMov = Almtdocm.CodMov.

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
      TABLE: ITEM T "?" ? INTEGRAL Almdmov
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.62
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="Faccpedi" ~
        &Condicion="ROWID(Faccpedi) = pRowid" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError"UNDO, RETURN 'ADM-ERROR'"}
        
    RUN control-por-almacen.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = "ERROR en el correlativo de Salida por Transferencia".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* CABECERA DE TRANSFERENCIA */
    CREATE Almcmov.
    ASSIGN
        Almcmov.CodCia = Almtdocm.CodCia 
        Almcmov.CodAlm = Almtdocm.CodAlm 
        Almcmov.TipMov = Almtdocm.TipMov
        Almcmov.CodMov = Almtdocm.CodMov
        Almcmov.FlgSit = "T"      /* Transferido pero no Recepcionado */
        Almcmov.FchDoc = TODAY
        Almcmov.HorSal = STRING(TIME,"HH:MM")
        Almcmov.HraDoc = STRING(TIME,"HH:MM")
        Almcmov.NroSer = s-nroser
        Almcmov.NroDoc = x-NroDoc
        Almcmov.usuario = S-USER-ID
        Almcmov.AlmDes = Faccpedi.codcli
        Almcmov.CodRef = Faccpedi.coddoc
        Almcmov.NroRef = Faccpedi.nroped
        Almcmov.Observ = FacCPedi.Glosa
        Almcmov.AlmacenXD = Faccpedi.AlmacenXD
        Almcmov.CrossDocking = Faccpedi.CrossDocking
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = ERROR-STATUS:GET-MESSAGE(1).
        UNDO, RETURN 'ADM-ERROR'.
    END.
    FIND Almacen WHERE Almacen.CodCia = Almtdocm.CodCia AND
        Almacen.CodAlm = Almcmov.AlmDes NO-LOCK NO-ERROR.
    Almcmov.NomRef = Almacen.Descripcion.
    s-AlmDes = Almcmov.AlmDes.
    /* DETALLE */
    EMPTY TEMP-TABLE ITEM.
    FOR EACH Facdpedi OF Faccpedi EXCLUSIVE-LOCK,
        FIRST Almmmatg WHERE Almmmatg.CodCia = Facdpedi.CodCia  
        AND Almmmatg.CodMat = Facdpedi.CodMat NO-LOCK:
        /* GENERAMOS MOVIMIENTO PARA ALMACEN ORIGEN */
        CREATE ITEM.
        ASSIGN 
            ITEM.CodCia = Almtdocm.CodCia
            ITEM.CodAlm = Almtdocm.CodAlm
            ITEM.CodMat = Facdpedi.CodMat
            ITEM.CodAjt = ""
            ITEM.Factor = 1
            ITEM.CodUnd = Almmmatg.UndStk
            ITEM.AlmOri = Faccpedi.CodAlm
            ITEM.CanDes = Facdpedi.CanPed 
            ITEM.StkAct = Facdpedi.CanPed.  /* OJO: TOPE */
        ASSIGN
            Facdpedi.CanAte = Facdpedi.CanPed.  /* Cierra el saldo */
    END.
    RUN Genera-Detalle.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = "No hay stock suficiente" + CHR(10) + "Proceso abortado".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        Faccpedi.FlgEst = "C".  /* Atendido */
END.
IF AVAILABLE(Faccorre) THEN RELEASE Faccorre.
IF AVAILABLE(Almacen) THEN RELEASE Almacen.
IF AVAILABLE(Almdmov) THEN RELEASE Almdmov.
IF AVAILABLE(Almmmate) THEN RELEASE Almmmate.
IF AVAILABLE(Almcrepo) THEN RELEASE Almcrepo.
IF AVAILABLE(Almdrepo) THEN RELEASE Almdrepo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-control-por-almacen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control-por-almacen Procedure 
PROCEDURE control-por-almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR LocalCounter AS INT NO-UNDO.
DEF VAR ix AS INT NO-UNDO.

pMensaje = "".
GetLock:
REPEAT ON STOP UNDO GetLock, RETRY GetLock ON ERROR UNDO GetLock, LEAVE GetLock:
    IF RETRY THEN DO:
        LocalCounter = LocalCounter + 1.
        IF LocalCounter = 5 THEN LEAVE GetLock.    /* 5 intentos máximo */
    END.
    FIND Almacen WHERE Almacen.CodCia = Almtdocm.CodCia
        AND Almacen.CodAlm = Almtdocm.CodAlm
        EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN LEAVE.
    IF AMBIGUOUS Almacen OR ERROR-STATUS:ERROR THEN DO:      /* Llave Duplicada o No existe*/
        IF ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
            pMensaje = ERROR-STATUS:GET-MESSAGE(1).
            DO ix = 2 TO ERROR-STATUS:NUM-MESSAGES:
                pMensaje = pMensaje + CHR(10) + ERROR-STATUS:GET-MESSAGE(ix).
            END.
            /*MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR BUTTONS OK.*/
        END.
        LEAVE GetLock.
    END.
END.
IF LocalCounter = 5 OR NOT AVAILABLE Almacen THEN RETURN "ADM-ERROR".
REPEAT:
    ASSIGN
        x-NroDoc = Almacen.CorrSal
        Almacen.CorrSal = Almacen.CorrSal + 1.
    IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia 
                    AND Almcmov.codalm = Almtdocm.CodAlm
                    AND Almcmov.tipmov = Almtdocm.TipMov
                    AND Almcmov.codmov = Almtdocm.CodMov
                    AND Almcmov.nroser = s-NroSer
                    AND Almcmov.nrodoc = x-NroDoc
                    NO-LOCK)
        THEN LEAVE.
END.
RETURN 'OK'.
              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Genera-Detalle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle Procedure 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR r-Rowid AS ROWID NO-UNDO.
DEF VAR x-Item AS INT INIT 0 NO-UNDO.

FIND FIRST FacCfgGn WHERE Faccfggn.codcia = s-codcia NO-LOCK NO-ERROR.

rloop:
FOR EACH ITEM BY ITEM.NroItm ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
/*     /* Solo en caso de G/R se controla el # de items */               */
/*     IF s-NroSer <> 000 AND x-Item >= FacCfgGn.Items_Guias THEN LEAVE. */
    CREATE almdmov.
    ASSIGN Almdmov.CodCia = Almcmov.CodCia 
           Almdmov.CodAlm = Almcmov.CodAlm 
           Almdmov.TipMov = Almcmov.TipMov 
           Almdmov.CodMov = Almcmov.CodMov 
           Almdmov.NroSer = Almcmov.NroSer
           Almdmov.NroDoc = Almcmov.NroDoc 
           Almdmov.CodMon = Almcmov.CodMon 
           Almdmov.FchDoc = Almcmov.FchDoc 
           Almdmov.HraDoc = Almcmov.HraDoc
           Almdmov.TpoCmb = Almcmov.TpoCmb
           Almdmov.codmat = ITEM.codmat
           Almdmov.CanDes = ITEM.CanDes
           Almdmov.CodUnd = ITEM.CodUnd
           Almdmov.Factor = ITEM.Factor
           Almdmov.ImpCto = ITEM.ImpCto
           Almdmov.PreUni = ITEM.PreUni
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
    /* Se anulan los items que se pueden descargar */
    DELETE ITEM.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

