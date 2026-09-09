&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CMOV FOR Almcmov.
DEFINE BUFFER B-DMOV FOR Almdmov.
DEFINE BUFFER ORDEN FOR FacCPedi.
DEFINE TEMP-TABLE t-Almcmov LIKE OOMoviAlmacen.



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
DEF INPUT  PARAMETER pCodDoc  AS CHAR.
DEF INPUT  PARAMETER pNroPed  AS CHAR.
DEF INPUT  PARAMETER x-UsrChq AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-CodMov AS INTE INIT 03 NO-UNDO.

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
      TABLE: B-CMOV B "?" ? INTEGRAL Almcmov
      TABLE: B-DMOV B "?" ? INTEGRAL Almdmov
      TABLE: ORDEN B "?" ? INTEGRAL FacCPedi
      TABLE: t-Almcmov T "?" ? INTEGRAL OOMoviAlmacen
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 6.46
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* NOTA:
    El movimiento de almacén se va a grabar en la tabla OOMoviAlmacen
*/

  pMensaje = ''.
  CICLO:
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      /* Bloqueamos OTR */
      {lib/lock-genericov3.i ~
          &Tabla="Faccpedi" ~
          &Condicion="Faccpedi.codcia = s-codcia ~
                        AND Faccpedi.coddoc = pCodDoc ~
                        AND Faccpedi.nroped = pNroPed ~
                        AND Faccpedi.flgest = 'C'"
          &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
          &Accion="RETRY" ~
          &Mensaje="NO" ~
          &txtMensaje="pMensaje" ~
          &TipoError="UNDO, LEAVE" ~
          }
/*           {lib/lock-genericov3.i ~                           */
/*               &Tabla="Faccpedi" ~                            */
/*               &Condicion="Faccpedi.codcia = s-codcia ~       */
/*                             AND Faccpedi.coddoc = pCodDoc ~  */
/*                             AND Faccpedi.nroped = pNroPed ~  */
/*                             AND Faccpedi.codcli = s-codalm ~ */
/*                             AND Faccpedi.flgest = 'C'"       */
/*               &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~           */
/*               &Accion="RETRY" ~                              */
/*               &Mensaje="NO" ~                                */
/*               &txtMensaje="pMensaje" ~                       */
/*               &TipoError="UNDO, LEAVE" ~                     */
/*               }                                              */
      IF NOT CAN-FIND(FIRST B-CMOV WHERE B-CMOV.codcia = s-codcia
                      AND B-CMOV.CodRef = Faccpedi.coddoc
                      AND B-CMOV.NroRef = Faccpedi.nroped
                      AND B-CMOV.TipMov = "S"
                      AND B-CMOV.CodMov = s-CodMov
                      AND B-CMOV.FlgEst <> 'A'
                      AND B-CMOV.FlgSit = "T" NO-LOCK)
          THEN DO:
          pMensaje = 'NO tiene ninguna G/R pendiente de recepcionar'.
          UNDO, LEAVE.
      END.
      /* Barremos todas las G/R relacionadas a la OTR que aún no han sido recepcionadas */
      FOR EACH B-CMOV EXCLUSIVE-LOCK WHERE B-CMOV.codcia = s-codcia
          AND B-CMOV.CodRef = Faccpedi.coddoc
          AND B-CMOV.NroRef = Faccpedi.nroped
          AND B-CMOV.TipMov = "S"
          AND B-CMOV.CodMov = s-CodMov
          AND B-CMOV.FlgEst <> 'A'
          AND B-CMOV.FlgSit = "T" ON ERROR UNDO, THROW:

          RUN FIRST-TRANSACTION.    /* Crea I-03 */

          IF RETURN-VALUE = "ADM-ERROR" THEN DO:
              IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo generar el ingreso por transferencia" + CHR(10) +
                  "para la G/R " + STRING(B-CMOV.NroSer, '999') + STRING(B-CMOV.NroDoc, '99999999').
              UNDO CICLO, LEAVE CICLO.
          END.
      END.
      /* GRABACIONES FINALES */
      RUN lib/logtabla ( "FACCPEDI",
                         s-coddiv + '|' + faccpedi.coddoc + '|' + faccpedi.nroped + '|' + ~
                         STRING(TODAY,'99/99/9999') + '|' + STRING(TIME,'HH:MM:SS') + '|' + ~
                         x-UsrChq, "CHKDESTINO" ).
  END.
  IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
  IF AVAILABLE(B-CMOV)   THEN RELEASE B-CMOV.
  IF pMensaje > '' THEN RETURN 'ADM-ERROR'.
  RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-FIRST-TRANSACTION) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FIRST-TRANSACTION Procedure 
PROCEDURE FIRST-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-CrossDocking AS LOG INIT NO NO-UNDO.
DEF VAR x-MsgCrossDocking AS CHAR NO-UNDO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    CREATE t-Almcmov.
    ASSIGN
        t-Almcmov.FchDoc = TODAY
        t-Almcmov.CodAlm = B-CMOV.AlmDes
        t-Almcmov.AlmDes = B-CMOV.CodAlm
        t-Almcmov.NroRf1 = STRING(B-CMOV.NroSer, '999') + STRING(B-CMOV.NroDoc)
        t-Almcmov.NroRf3 = B-CMOV.NroRf3
        t-Almcmov.AlmacenXD = B-CMOV.AlmacenXD
        t-Almcmov.CrossDocking = B-CMOV.CrossDocking.
    /* ******************************** */
    /* Referenciamos a la OTR de origen */
    /* ******************************** */
    ASSIGN
        t-Almcmov.CodRef = Faccpedi.coddoc      /* OTR */
        t-Almcmov.NroRef = Faccpedi.nroped.
    /* ******************************** */
    IF B-CMOV.CrossDocking = YES THEN DO:
        RUN Rutina-Cross-Docking.
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
        x-CrossDocking = YES.
    END.
    ELSE DO:
        RUN Rutina-Normal.
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
        x-CrossDocking = NO.
    END.
    RUN Genera-Detalle.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN 
        B-CMOV.FlgSit  = "R" 
        B-CMOV.HorRcp  = STRING(TIME,"HH:MM:SS")
        B-CMOV.NroRf2  = STRING(t-Almcmov.NroDoc).
    ASSIGN
        t-Almcmov.Libre_L02 = B-CMOV.Libre_L02    /* URGENTE */
        t-Almcmov.Libre_C05 = B-CMOV.Libre_C05.   /* MOTIVO */
    /* ********************************************************************* */
    /* RHC 21/12/2017 MIGRACION DE ORDENES DE DESPACHO DEL ORIGEN AL DESTINO */
    /* SOLO PARA CROSSDOCKING */
    /* ********************************************************************* */
    DEFINE VAR hProc AS HANDLE NO-UNDO.
    RUN gn/xd-library.p PERSISTENT SET hProc.
    IF B-CMOV.CrossDocking = YES THEN DO:
        FIND ORDEN WHERE ORDEN.codcia = s-codcia 
            AND ORDEN.coddoc = B-CMOV.codref 
            AND ORDEN.nroped = B-CMOV.nroref NO-LOCK NO-ERROR.
        CASE TRUE:
            WHEN ORDEN.CodRef = "R/A" THEN DO:
                RUN XD_Migra-RA IN hProc (t-Almcmov.CodAlm,      /* Almacén de Origen */
                                          t-Almcmov.AlmacenXD,   /* Almacén de Destino */
                                          B-CMOV.CodRef,         /* OTR */
                                          B-CMOV.NroRef,         /* Número de la OTR */
                                          OUTPUT pMensaje).
                IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                    IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo migrar la OTR'.
                    UNDO, RETURN 'ADM-ERROR'.
                END.
                /* ****************************************** */
                /* RHC 18/08/18 Almacenamos la OTR del ORIGEN */
                /* ****************************************** */
                ASSIGN
                    t-Almcmov.CodRef = B-CMOV.CodRef
                    t-Almcmov.NroRef = B-CMOV.NroRef.
                /* ****************************************** */
            END.
            WHEN ORDEN.CodRef = "PED" THEN DO:
                RUN XD_Migra-OTR IN hProc (t-Almcmov.CodAlm,         /* Almacén de Origen */
                                          B-CMOV.CodRef,         /* OTR */
                                          B-CMOV.NroRef,         /* Número de la OTR */
                                          OUTPUT pMensaje).
                IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                    IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo migrar el PED'.
                    UNDO, RETURN 'ADM-ERROR'.
                END.
            END.
        END CASE.
    END.
    DELETE PROCEDURE hProc.
    /* ********************************************************************* */
    /* ********************************************************************* */
    /* RHC 01/12/17 Log para e-Commerce */
/*     DEF VAR pOk AS LOG NO-UNDO.                                  */
/*     RUN gn/log-inventory-qty.p (ROWID(t-Almcmov),                */
/*                                 "C",      /* CREATE */           */
/*                                 OUTPUT pOk).                     */
/*     IF pOk = NO THEN DO:                                         */
/*         pMensaje = "NO se pudo actualizar el log de e-Commerce". */
/*         UNDO, RETURN 'ADM-ERROR'.                                */
/*     END.                                                         */
END.
IF AVAILABLE(t-Almcmov) THEN RELEASE t-Almcmov.
IF AVAILABLE(Almdmov) THEN RELEASE Almdmov.
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

  DEF VAR R-ROWID AS ROWID NO-UNDO.

  FOR EACH B-DMOV OF B-CMOV NO-LOCK WHERE B-DMOV.codmat > "" ON ERROR UNDO, RETURN "ADM-ERROR":
      CREATE OOMoviAlmacen.
      ASSIGN OOMoviAlmacen.CodCia = t-Almcmov.CodCia 
             OOMoviAlmacen.CodAlm = t-Almcmov.CodAlm 
             OOMoviAlmacen.TipMov = t-Almcmov.TipMov 
             OOMoviAlmacen.CodMov = t-Almcmov.CodMov 
             OOMoviAlmacen.NroSer = t-Almcmov.NroSer 
             OOMoviAlmacen.NroDoc = t-Almcmov.NroDoc 
             OOMoviAlmacen.CodMon = t-Almcmov.CodMon 
             OOMoviAlmacen.FchDoc = t-Almcmov.FchDoc 
             OOMoviAlmacen.TpoCmb = t-Almcmov.TpoCmb 
             OOMoviAlmacen.codmat = B-DMOV.codmat 
             OOMoviAlmacen.CanDes = B-DMOV.CanDes 
             OOMoviAlmacen.CodUnd = B-DMOV.CodUnd 
             OOMoviAlmacen.Factor = B-DMOV.Factor 
             OOMoviAlmacen.ImpCto = B-DMOV.ImpCto 
             OOMoviAlmacen.PreUni = B-DMOV.PreUni
             OOMoviAlmacen.AlmOri = t-Almcmov.AlmDes 
             OOMoviAlmacen.CodAjt = '' 
             OOMoviAlmacen.HraDoc = t-Almcmov.HorRcp
                    R-ROWID = ROWID(OOMoviAlmacen).

            /* Ic - 27Jun2019 */
            ASSIGN OOMoviAlmacen.NroRf1 = t-Almcmov.NroRf1
                    OOMoviAlmacen.NroRf3 = t-Almcmov.NroRf3
                    OOMoviAlmacen.AlmacenXD = t-Almcmov.AlmacenXD
                    OOMoviAlmacen.CrossDocking = t-Almcmov.CrossDocking
                    OOMoviAlmacen.AlmDes = t-Almcmov.AlmDes
                    OOMoviAlmacen.CodRef = t-Almcmov.CodRef
                    OOMoviAlmacen.NroRef = t-Almcmov.NroRef
                    OOMoviAlmacen.usuario = S-USER-ID
                    OOMoviAlmacen.FlgSit  = ""
                    OOMoviAlmacen.Libre_L02 = t-Almcmov.Libre_L02
                    OOMoviAlmacen.Libre_C05 = t-Almcmov.Libre_C05
                .

/*       RUN ALM\ALMACSTK (R-ROWID).                                  */
/*       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
/*       RUN alm/almacpr1 (R-ROWID, 'U').                             */
/*       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
  END.

END PROCEDURE.

/*
        t-Almcmov.FchDoc = TODAY
        t-Almcmov.CodAlm = B-CMOV.AlmDes
        t-Almcmov.AlmDes = B-CMOV.CodAlm
        t-Almcmov.NroRf1 = STRING(B-CMOV.NroSer, '999') + STRING(B-CMOV.NroDoc)
        t-Almcmov.NroRf3 = B-CMOV.NroRf3
        t-Almcmov.AlmacenXD = B-CMOV.AlmacenXD
        t-Almcmov.CrossDocking = B-CMOV.CrossDocking.
        
    ASSIGN
        t-Almcmov.CodRef = Faccpedi.coddoc      /* OTR */
        t-Almcmov.NroRef = Faccpedi.nroped.
        
        t-Almcmov.CodCia  = Almtdocm.CodCia 
        t-Almcmov.TipMov  = Almtdocm.TipMov 
        t-Almcmov.CodMov  = Almtdocm.CodMov 
        t-Almcmov.NroSer  = 000
        t-Almcmov.NroDoc  = x-NroDoc
        t-Almcmov.FlgSit  = ""
        t-Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS")
        t-Almcmov.usuario = S-USER-ID
        NO-ERROR.
        
        t-Almcmov.Libre_L02 = B-CMOV.Libre_L02    /* URGENTE */
        t-Almcmov.Libre_C05 = B-CMOV.Libre_C05.   /* MOTIVO */
        
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Rutina-Cross-Docking) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rutina-Cross-Docking Procedure 
PROCEDURE Rutina-Cross-Docking :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Nrodoc LIKE Almtdocm.NroDoc NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND FIRST Almacen WHERE Almacen.codcia = s-codcia
        AND Almacen.coddiv = s-coddiv
        AND Almacen.campo-c[1] = "XD"
        AND Almacen.campo-c[9] <> 'I'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN DO:
        pMensaje = "NO definido el almacén de Cross Docking".
        RETURN "ADM-ERROR".
    END.
    IF NOT CAN-FIND(FIRST Almtdocm WHERE Almtdocm.CodCia = s-CodCia AND
                    Almtdocm.CodAlm = Almacen.CodAlm AND
                    Almtdocm.TipMov = 'I' AND
                    Almtdocm.CodMov = s-CodMov)
        THEN DO:
        pMensaje = "NO definido el movimiento de ingreso por transferencia en el almacén " +
            Almacen.CodAlm.
        RETURN "ADM-ERROR".
    END.

    {lib/lock-genericov3.i ~
        &Tabla="Almtdocm" ~
        &Condicion="Almtdocm.CodCia = S-CODCIA AND ~
        Almtdocm.CodAlm = Almacen.CodAlm AND ~
        Almtdocm.TipMov = 'I' AND ~
        Almtdocm.CodMov = S-CODMOV" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
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
    ASSIGN
        t-Almcmov.CodCia  = Almtdocm.CodCia 
        t-Almcmov.CodAlm  = Almacen.CodAlm      /* Almacén de Cross Docking */
        t-Almcmov.TipMov  = Almtdocm.TipMov 
        t-Almcmov.CodMov  = Almtdocm.CodMov 
        t-Almcmov.NroSer  = 000
        t-Almcmov.NroDoc  = x-NroDoc
        t-Almcmov.FlgSit  = ""
        t-Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS")
        t-Almcmov.usuario = S-USER-ID
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = ERROR-STATUS:GET-MESSAGE(1).
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        Almtdocm.NroDoc = x-NroDoc + 1.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Rutina-Normal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rutina-Normal Procedure 
PROCEDURE Rutina-Normal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Nrodoc LIKE Almtdocm.NroDoc NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="Almtdocm" ~
        &Condicion="Almtdocm.CodCia = S-CODCIA AND ~
        Almtdocm.CodAlm = s-CodAlm AND ~
        Almtdocm.TipMov = 'I' AND ~
        Almtdocm.CodMov = S-CODMOV" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
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
    ASSIGN
        t-Almcmov.CodCia  = Almtdocm.CodCia 
        t-Almcmov.TipMov  = Almtdocm.TipMov 
        t-Almcmov.CodMov  = Almtdocm.CodMov 
        t-Almcmov.NroSer  = 000
        t-Almcmov.NroDoc  = x-NroDoc
        t-Almcmov.FlgSit  = ""
        t-Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS")
        t-Almcmov.usuario = S-USER-ID
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = ERROR-STATUS:GET-MESSAGE(1).
        RETURN "ADM-ERROR".
    END.
    ASSIGN
        Almtdocm.NroDoc = x-NroDoc + 1.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

