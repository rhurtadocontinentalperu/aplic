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

/* Recibimos el Rowid de Faccpedi
   PPV: Pre-pedido Vitrina
*/
DEF INPUT PARAMETER pEvento AS CHAR.
DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pAlmOri AS CHAR.
DEF INPUT PARAMETER pAlmDes AS CHAR.    /* Almacén destino */
DEF OUTPUT PARAMETER pNroSalida AS CHAR.
DEF OUTPUT PARAMETER pNroIngreso AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-codalm AS CHAR NO-UNDO.       /* Almacén de salida */
DEF VAR output-var-1 AS ROWID NO-UNDO.

FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN "ADM-ERROR".
/*s-CodAlm = ENTRY(1, Faccpedi.codalm).*/
s-CodAlm = pAlmOri.
IF s-CodAlm = '' THEN RETURN "ADM-ERROR".

DEF BUFFER CMOV FOR Almcmov.
DEF BUFFER DMOV FOR Almdmov.

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
         HEIGHT             = 7.12
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Vamos a generar 2 movimientos:
    1. La salida por transferencia
    2. El ingreso por transferencia 
*/

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    CASE pEvento:
        WHEN 'APPEND' THEN DO:
            RUN Salida.
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
            RUN Ingreso.
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        END.
        WHEN 'DELETE' THEN DO:
            RUN Del-Salida.
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
            RUN Del-Ingreso.
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        END.
    END CASE.
END.
/* DESBLOQUEAMOS LOS CORRELATIVOS */
IF AVAILABLE(Almacen)  THEN RELEASE Almacen.
IF AVAILABLE(Almcmov)  THEN RELEASE Almcmov.
IF AVAILABLE(Almdmov)  THEN RELEASE Almdmov.
IF AVAILABLE(Almmmate) THEN RELEASE Almmmate.
IF AVAILABLE(CMOV)     THEN RELEASE CMOV.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Del-Ingreso) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Del-Ingreso Procedure 
PROCEDURE Del-Ingreso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR R-ROWID AS ROWID.

/* Buscamos el movimiento de ingreso */
FIND Almcmov WHERE Almcmov.codcia = Faccpedi.codcia
    AND Almcmov.codalm = Faccpedi.codcli
    AND Almcmov.tipmov = 'I'
    AND Almcmov.codmov = 03
    AND Almcmov.nroser = INTEGER(SUBSTRING(Faccpedi.Ubigeo[2],1,3))
    AND Almcmov.nrodoc = INTEGER(SUBSTRING(Faccpedi.Ubigeo[2],4))
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcmov THEN RETURN 'ADM-ERROR'.

CICLO:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FOR EACH Almdmov EXCLUSIVE-LOCK WHERE Almdmov.CodCia = Almcmov.CodCia 
                                     AND  Almdmov.CodAlm = Almcmov.CodAlm 
                                     AND  Almdmov.TipMov = Almcmov.TipMov 
                                     AND  Almdmov.CodMov = Almcmov.CodMov 
                                     AND  Almdmov.NroSer = Almcmov.NroSer 
                                     AND  Almdmov.NroDoc = Almcmov.NroDoc :
        ASSIGN R-ROWID = ROWID(Almdmov).
        RUN ALM\ALMDCSTK (R-ROWID).   /* Descarga del Almacen POR INGRESOS */
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO CICLO, RETURN 'ADM-ERROR'.
        /*
        RUN ALM\ALMACPR1 (R-ROWID,"D").
        RUN ALM\ALMACPR2 (R-ROWID,"D").
        */
        /* RHC 03.04.04 REACTIVAMOS KARDEX POR ALMACEN */
        RUN alm/almacpr1 (R-ROWID, 'D').
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO CICLO, RETURN 'ADM-ERROR'.
        DELETE Almdmov.
    END.

    FIND CMOV WHERE CMOV.CodCia = Almcmov.CodCia 
       AND  CMOV.CodAlm = Almcmov.CodAlm 
       AND  CMOV.TipMov = Almcmov.TipMov 
       AND  CMOV.CodMov = Almcmov.CodMov 
       AND  CMOV.NroDoc = Almcmov.NroDoc 
       EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN 
       CMOV.FlgEst = 'A'
       CMOV.Observ = "      A   N   U   L   A   D   O       "
       CMOV.Usuario = S-USER-ID.

    FIND CMOV WHERE CMOV.CodCia = Almcmov.CodCia 
       AND  CMOV.CodAlm = Almcmov.AlmDes 
       AND  CMOV.TipMov = "S" 
       AND  CMOV.CodMov = 03
       AND  CMOV.NroSer = INTEGER(SUBSTRING(Almcmov.NroRf1,1,3)) 
       AND  CMOV.NroDoc = INTEGER(SUBSTRING(Almcmov.NroRf1,4)) 
       EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN 
       CMOV.FlgSit  = "T"
       CMOV.HorRcp  = STRING(TIME,"HH:MM:SS").
    IF AVAILABLE(CMOV) THEN RELEASE CMOV.
    IF AVAILABLE(Almdmov) THEN RELEASE Almdmov.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Del-Salida) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Del-Salida Procedure 
PROCEDURE Del-Salida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR R-ROWID AS ROWID.

/* Buscamos el movimiento de ingreso */
FIND Almcmov WHERE Almcmov.codcia = Faccpedi.codcia
    AND Almcmov.codalm = Faccpedi.codalm
    AND Almcmov.tipmov = 'S'
    AND Almcmov.codmov = 03
    AND Almcmov.nroser = INTEGER(SUBSTRING(Faccpedi.Ubigeo[1],1,3))
    AND Almcmov.nrodoc = INTEGER(SUBSTRING(Faccpedi.Ubigeo[1],4))
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcmov THEN RETURN 'ADM-ERROR'.

CICLO:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Eliminamos el detalle para el almacen de Origen */
    FOR EACH Almdmov OF Almcmov:
        ASSIGN R-ROWID = ROWID(Almdmov).
        RUN alm/almacstk (R-ROWID).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO CICLO, RETURN 'ADM-ERROR'.
        /* RHC 30.03.04 REACTIVAMOS RUTINA */
        RUN alm/almacpr1 (R-ROWID, "D").
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO CICLO, RETURN 'ADM-ERROR'.
        DELETE Almdmov.
    END.

    FIND CURRENT Almcmov EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Almcmov
    THEN DO:
        RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
        UNDO, RETURN "ADM-ERROR".
    END.
    ASSIGN 
        Almcmov.FlgEst = 'A'
        Almcmov.Observ = "      A   N   U   L   A   D   O       "
        Almcmov.usuario = S-USER-ID
        Almcmov.FchAnu = TODAY.
    FIND CURRENT Almcmov NO-LOCK NO-ERROR.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Ingreso) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ingreso Procedure 
PROCEDURE Ingreso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR s-NroSer AS INT INIT 000 NO-UNDO.
DEF VAR x-NroDoc AS INT NO-UNDO.
DEF VAR s-CodCia AS INT INIT 000 NO-UNDO.
DEF VAR s-CodDiv AS CHAR NO-UNDO.
DEF VAR x-Item   AS INT INIT 1 NO-UNDO.
DEF VAR r-Rowid  AS ROWID NO-UNDO.

ASSIGN
    s-CodCia = Faccpedi.codcia
    s-CodDiv = Faccpedi.coddiv.

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FIND CMOV WHERE ROWID(CMOV) = output-var-1 EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    FIND Almtdocm WHERE Almtdocm.CodCia = s-codcia
        AND Almtdocm.CodAlm = pAlmDes
        AND Almtdocm.TipMov = "I"
        AND Almtdocm.CodMov = 03
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtdocm THEN DO:
/*         MESSAGE 'NO está definido el movimiento I03 en el almacén' pAlmDes */
/*             SKIP 'Proceso abortado'                                        */
/*             VIEW-AS ALERT-BOX ERROR.                                       */
        pMensaje = 'NO está definido el movimiento I03 en el almacén ' + pAlmDes + CHR(10) +
            'Proceso abortado'.
        RETURN 'ADM-ERROR'.
    END.

    {lib/lock-genericov3.i &Tabla="Almtdocm" ~
        &Condicion="Almtdocm.CodCia = S-CODCIA ~
        AND Almtdocm.CodAlm = pAlmDes ~
        AND Almtdocm.TipMov = 'I' ~
        AND Almtdocm.CodMov = 03" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="LEAVE" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje"
        &TipoError="RETURN 'ADM-ERROR'" ~
        }

    ASSIGN 
        x-Nrodoc  = Almtdocm.NroDoc.
    REPEAT:
        IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia
                        AND Almcmov.CodAlm = Almtdocm.CodAlm 
                        AND Almcmov.TipMov = Almtdocm.TipMov
                        AND Almcmov.CodMov = Almtdocm.CodMov
                        AND Almcmov.NroSer = s-nroser
                        AND Almcmov.NroDoc = x-NroDoc
                        NO-LOCK)
            THEN LEAVE.
        ASSIGN
            x-NroDoc = x-NroDoc + 1.
    END.
    CREATE Almcmov.
    ASSIGN
        Almcmov.CodCia  = Almtdocm.CodCia 
        Almcmov.CodAlm  = Almtdocm.CodAlm 
        Almcmov.TipMov  = Almtdocm.TipMov 
        Almcmov.CodMov  = Almtdocm.CodMov 
        Almcmov.NroSer  = s-NroSer
        Almcmov.NroDoc  = x-NroDoc
        Almcmov.FchDoc  = TODAY
        Almcmov.FlgSit  = ""
        Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS")
        Almcmov.AlmDes  = pAlmOri
        Almcmov.NroRf1  = STRING(CMOV.NroSer,"999") + STRING(CMOV.NroDoc)
        Almcmov.CodRef = Faccpedi.coddoc    /* OTR */
        Almcmov.NroRef = Faccpedi.nroped
        Almcmov.usuario = S-USER-ID.
    ASSIGN
        Almcmov.Observ = Faccpedi.Observ.   /* En caso de INCIDENCIA */
    ASSIGN 
        Almtdocm.NroDoc = x-NroDoc + 1.
    ASSIGN
        pNroIngreso = STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc).
    FOR EACH DMOV NO-LOCK WHERE DMOV.CodCia = CMOV.CodCia 
        AND DMOV.CodAlm = CMOV.CodAlm 
        AND DMOV.TipMov = CMOV.TipMov 
        AND DMOV.CodMov = CMOV.CodMov 
        AND DMOV.NroSer = CMOV.NroSer
        AND DMOV.NroDoc = CMOV.NroDoc:
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
            Almdmov.codmat = DMOV.codmat 
            Almdmov.CanDes = DMOV.CanDes 
            Almdmov.CodUnd = DMOV.CodUnd 
            Almdmov.Factor = 1
            /*Almdmov.Factor = DMOV.Factor */
            Almdmov.ImpCto = DMOV.ImpCto 
            Almdmov.PreUni = DMOV.PreUni 
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

DEF VAR s-NroSer AS INT INIT 000 NO-UNDO.
DEF VAR x-NroDoc AS INT NO-UNDO.
DEF VAR s-CodCia AS INT INIT 000 NO-UNDO.
DEF VAR s-CodDiv AS CHAR NO-UNDO.
DEF VAR x-Item   AS INT INIT 1 NO-UNDO.
DEF VAR r-Rowid  AS ROWID NO-UNDO.

ASSIGN
    s-CodCia = Faccpedi.codcia
    s-CodDiv = Faccpedi.coddiv
    output-var-1 = ?.
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FIND Almtdocm WHERE Almtdocm.CodCia = s-codcia
        AND Almtdocm.CodAlm = s-codalm 
        AND Almtdocm.TipMov = "S"
        AND Almtdocm.CodMov = 03
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtdocm THEN DO:
/*         MESSAGE 'NO está definido el movimiento S03 en el almacén' s-codalm */
/*             SKIP 'Proceso abortado'                                         */
/*             VIEW-AS ALERT-BOX ERROR.                                        */
        pMensaje = 'NO está definido el movimiento S03 en el almacén ' +  s-codalm + CHR(10) +
            'Proceso abortado'.
        RETURN 'ADM-ERROR'.
    END.
    {lib/lock-genericov3.i &Tabla="Almacen" ~
        &Condicion="Almacen.CodCia = S-CODCIA AND Almacen.CodAlm = s-CodAlm" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje"
        &TipoError="RETURN 'ADM-ERROR'" ~
        }

    ASSIGN 
        x-Nrodoc  = Almacen.CorrSal.
    REPEAT:
        IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia
                        AND Almcmov.CodAlm = Almtdocm.CodAlm 
                        AND Almcmov.TipMov = Almtdocm.TipMov
                        AND Almcmov.CodMov = Almtdocm.CodMov
                        AND Almcmov.NroSer = s-nroser
                        AND Almcmov.NroDoc = x-NroDoc
                        NO-LOCK)
            THEN LEAVE.
        ASSIGN
            x-NroDoc = x-NroDoc + 1.
    END.
    CREATE Almcmov.
    ASSIGN 
        Almcmov.CodCia = Almtdocm.CodCia 
        Almcmov.CodAlm = Almtdocm.CodAlm 
        Almcmov.AlmDes = pAlmDes
        Almcmov.TipMov = Almtdocm.TipMov
        Almcmov.CodMov = Almtdocm.CodMov
        Almcmov.NroSer = s-NroSer
        Almcmov.NroDoc = x-NroDoc
        Almcmov.FlgSit = "T"      /* Transferido pero no Recepcionado */
        Almcmov.FchDoc = TODAY
        Almcmov.HorSal = STRING(TIME,"HH:MM")
        Almcmov.HraDoc = STRING(TIME,"HH:MM")
        Almcmov.CodRef = Faccpedi.coddoc
        Almcmov.NroRef = Faccpedi.nroped
        Almcmov.usuario = S-USER-ID.
    ASSIGN
        Almcmov.Observ = Faccpedi.Observ.   /* En caso de INCIDENCIA */
    ASSIGN
        output-var-1 = ROWID(Almcmov)   /* OJO: CONTROL */
        pNroSalida = STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc).
    ASSIGN 
        Almacen.CorrSal = x-NroDoc + 1.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK:
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
               Almdmov.CanDes = Facdpedi.CanPed
               Almdmov.CodUnd = Facdpedi.UndVta
               Almdmov.Factor = 1
               /*Almdmov.Factor = Facdpedi.Factor*/
               /*Almdmov.ImpCto = Facdpedi.ImpCto*/
               Almdmov.PreUni = Facdpedi.PreUni
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
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

