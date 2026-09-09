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

/* Rutina que genera una salida y un ingreso automatico */

DEF INPUT PARAMETER pRowid     AS ROWID.
DEF INPUT PARAMETER pAlmacen-1 AS CHAR.     /* De donde sale: Alm. 11 */
DEF INPUT PARAMETER pAlmacen-2 AS CHAR.     /* A donde llega: Alm. 11m */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

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
         HEIGHT             = 5.81
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF VAR s-NroSer AS INT INIT 000 NO-UNDO.   /* Transferencias internas */
DEF VAR s-CodMov AS INT INIT 03  NO-UNDO.   /* Transferencia */

/* 1ro. Verificamos  */
FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN.
FIND FIRST Facdpedi OF Faccpedi WHERE Facdpedi.CanTrf > 0 NO-LOCK NO-ERROR.
IF NOT AVAILABLE Facdpedi THEN RETURN.
/* Salida por Transferencia */
FIND FIRST Almtdocm WHERE Almtdocm.CodCia = s-codcia
    AND Almtdocm.CodAlm = pAlmacen-1    /* Alm 11 */
    AND Almtdocm.TipMov = "S"
    AND Almtdocm.CodMov = s-CodMov
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtdocm THEN DO:
    MESSAGE 'NO definida la SALIDA POR TRANSFERENCIA del almacén:' pAlmacen-1
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
/* 3ro Ingreso por Transferencia */
FIND FIRST Almtdocm WHERE Almtdocm.CodCia = s-codcia
    AND Almtdocm.CodAlm = pAlmacen-2    /* Alm 11e */
    AND Almtdocm.TipMov = "I"
    AND Almtdocm.CodMov = s-CodMov
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtdocm THEN DO:
    MESSAGE 'NO definido el INGRESO POR TRANSFERENCIA del almacén:' pAlmacen-2
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    /* 1ro Control */
    FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RETURN ERROR.
    /* 2do. Salida por Transferencia */
    FIND FIRST Almtdocm WHERE Almtdocm.CodCia = s-codcia
        AND Almtdocm.CodAlm = pAlmacen-1    /* Alm 11 */
        AND Almtdocm.TipMov = "S"
        AND Almtdocm.CodMov = s-CodMov
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtdocm THEN DO:
        MESSAGE 'NO definida la SALIDA POR TRANSFERENCIA del almacén:' pAlmacen-1
            VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    RUN Salida-por-Transferencia NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.
    /* 3ro Ingreso por Transferencia */
    FIND FIRST Almtdocm WHERE Almtdocm.CodCia = s-codcia
        AND Almtdocm.CodAlm = pAlmacen-2    /* Alm 11e */
        AND Almtdocm.TipMov = "I"
        AND Almtdocm.CodMov = s-CodMov
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtdocm THEN DO:
        MESSAGE 'NO definido el INGRESO POR TRANSFERENCIA del almacén:' pAlmacen-2
            VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    RUN Ingreso-por-Transferencia NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.
    /* Control */
    ASSIGN
        FacCPedi.TipVta = "CMTRANSF".   /* Contrato Marco Transferencia */
END.
IF AVAILABLE Almcmov THEN RELEASE Almcmov.
IF AVAILABLE ALmdmov THEN RELEASE Almdmov.
FIND CURRENT Faccpedi.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Ingreso-por-Transferencia) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ingreso-por-Transferencia Procedure 
PROCEDURE Ingreso-por-Transferencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR r-Rowid AS ROWID.
DEF VAR x-NroDoc AS INT NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    {lib/lock-genericov2.i ~
        &Tabla="Almtdocm" ~
        &Condicion="Almtdocm.CodCia = S-CODCIA  ~
        AND Almtdocm.CodAlm = pAlmacen-2 ~
        AND Almtdocm.TipMov = 'I' ~
        AND Almtdocm.CodMov = S-CODMOV" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="RETURN ERROR" ~
        }
    ASSIGN x-Nrodoc = Almtdocm.NroDoc.
    REPEAT:
        IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia
                        AND Almcmov.CodAlm = Almtdocm.CodAlm 
                        AND Almcmov.TipMov = Almtdocm.TipMov
                        AND Almcmov.CodMov = Almtdocm.CodMov
                        AND Almcmov.NroSer = s-NroSer
                        AND Almcmov.NroDoc = x-NroDoc
                        NO-LOCK)
            THEN LEAVE.
        ASSIGN x-NroDoc = x-NroDoc + 1.
    END.
    CREATE Almcmov.
  ASSIGN
      Almcmov.CodCia  = Almtdocm.CodCia 
      Almcmov.CodAlm  = Almtdocm.CodAlm 
      Almcmov.AlmDes  = pAlmacen-1      /* Alm 11 */
      Almcmov.TipMov  = Almtdocm.TipMov 
      Almcmov.CodMov  = Almtdocm.CodMov 
      Almcmov.NroSer  = 000
      Almcmov.NroDoc  = x-NroDoc
      Almcmov.FlgSit  = ""
      Almcmov.FchDoc  = TODAY
      Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS")
      Almcmov.CodRef  = Faccpedi.CodDoc
      Almcmov.NroRef  = Faccpedi.NroPed
      Almcmov.usuario = S-USER-ID. 
  ASSIGN
      Almtdocm.NroDoc = x-NroDoc + 1.
  FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.CanTrf > 0:
      CREATE almdmov.
      ASSIGN Almdmov.CodCia = Almcmov.CodCia 
             Almdmov.CodAlm = Almcmov.CodAlm 
             Almdmov.TipMov = Almcmov.TipMov 
             Almdmov.CodMov = Almcmov.CodMov 
             Almdmov.NroSer = Almcmov.NroSer 
             Almdmov.NroDoc = Almcmov.NroDoc 
             Almdmov.CodMon = Almcmov.CodMon 
             Almdmov.FchDoc = Almcmov.FchDoc 
             Almdmov.TpoCmb = Almcmov.TpoCmb 
             Almdmov.codmat = Facdpedi.codmat 
             Almdmov.CanDes = Facdpedi.CanTrf
             Almdmov.CodUnd = Facdpedi.UndVta
             Almdmov.Factor = Facdpedi.Factor 
             /*Almdmov.ImpCto = ITEM.ImpCto */
             Almdmov.PreUni = Facdpedi.PreUni 
             Almdmov.AlmOri = Almcmov.AlmDes 
             Almdmov.CodAjt = '' 
             Almdmov.HraDoc = Almcmov.HorRcp
                    R-ROWID = ROWID(Almdmov).

      RUN ALM\ALMACSTK (R-ROWID).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN ERROR.
      
      /*
      RUN ALM\ALMACPR1 (R-ROWID,"U").
      RUN ALM\ALMACPR2 (R-ROWID,"U").
      */
      /* RHC 03.04.04 REACTIVAMOS KARDEX POR ALMACEN */
      RUN alm/almacpr1 (R-ROWID, 'U').
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN ERROR.
  END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Salida-por-Transferencia) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Salida-por-Transferencia Procedure 
PROCEDURE Salida-por-Transferencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-NroDoc LIKE Almcmov.nrodoc INIT 0 NO-UNDO.
DEF VAR x-Item AS INT INIT 0 NO-UNDO.
DEF VAR r-Rowid AS ROWID NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    {lib/lock-genericov2.i ~
        &Tabla="Almacen" ~
        &Condicion="Almacen.CodCia = S-CODCIA  ~
        AND Almacen.CodAlm = Almtdocm.CodAlm" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="RETURN ERROR" ~
        }
    ASSIGN 
        x-Nrodoc  = Almacen.CorrSal.
    /* Buscamos número válido */
    REPEAT:
        IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia
                        AND Almcmov.CodAlm = Almtdocm.CodAlm 
                        AND Almcmov.TipMov = Almtdocm.TipMov
                        AND Almcmov.CodMov = Almtdocm.CodMov
                        AND Almcmov.NroSer = s-nroser
                        AND Almcmov.NroDoc = x-NroDoc
                        NO-LOCK)
            THEN LEAVE.
        ASSIGN x-NroDoc = x-NroDoc + 1.
    END.
    ASSIGN
        Almacen.CorrSal = x-NroDoc + 1.
    CREATE Almcmov.
    ASSIGN 
        Almcmov.CodCia = Almtdocm.CodCia 
        Almcmov.CodAlm = Almtdocm.CodAlm 
        Almcmov.AlmDes = pAlmacen-2         /* Alm. 11 */
        Almcmov.TipMov = Almtdocm.TipMov
        Almcmov.CodMov = Almtdocm.CodMov
        Almcmov.NroSer = s-nroser
        Almcmov.NroDoc = x-NroDoc
        Almcmov.FlgSit = "R"      /* Recepcionado */
        Almcmov.FchDoc = TODAY
        Almcmov.HorSal = STRING(TIME,"HH:MM")
        Almcmov.HraDoc = STRING(TIME,"HH:MM")
        Almcmov.CodRef = Faccpedi.coddoc
        Almcmov.NroRef = Faccpedi.nroped
        Almcmov.usuario = S-USER-ID.

    FIND FacCfgGn WHERE Faccfggn.codcia = s-codcia NO-LOCK.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.CanTrf > 0:
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
               Almdmov.codmat = Facdpedi.codmat
               Almdmov.CanDes = Facdpedi.CanTrf
               Almdmov.CodUnd = Facdpedi.undvta
               Almdmov.Factor = Facdpedi.Factor
               Almdmov.PreUni = Facdpedi.PreUni
               Almdmov.AlmOri = Almcmov.AlmDes
               Almdmov.CodAjt = ''
               Almdmov.HraDoc = Almcmov.HorSal
               Almdmov.NroItm = x-Item
               R-ROWID = ROWID(Almdmov).
        x-Item = x-Item + 1.
        RUN alm/almdcstk (R-ROWID).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN ERROR.
        RUN alm/almacpr1 (R-ROWID, "U").
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN ERROR.
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

