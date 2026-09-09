&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-CPEDM FOR FacCPedi.
DEFINE BUFFER B-DPEDM FOR FacDPedi.
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.
DEFINE TEMP-TABLE T-CDOCU NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE T-CODES NO-UNDO LIKE FacCPedi.
DEFINE TEMP-TABLE T-DDOCU NO-UNDO LIKE CcbDDocu.
DEFINE TEMP-TABLE T-DODES NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.
DEFINE TEMP-TABLE T-Tickets NO-UNDO LIKE VtaDTickets.
DEFINE TEMP-TABLE T-VALES NO-UNDO LIKE VtaVales.
DEFINE TEMP-TABLE wrk_dcaja NO-UNDO LIKE CcbDCaja.



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

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR x-articulo-ICBPER AS CHAR.
    x-articulo-ICBPER = "099268".

DEFINE NEW SHARED TEMP-TABLE wrk_ret NO-UNDO
    FIELDS CodCia LIKE CcbDCaja.CodCia
    FIELDS CodCli LIKE CcbCDocu.CodCli
    FIELDS CodDoc LIKE CcbCDocu.CodDoc COLUMN-LABEL "Tipo  "
    FIELDS NroDoc LIKE CcbCDocu.NroDoc COLUMN-LABEL "Documento " FORMAT "x(10)"
    FIELDS CodRef LIKE CcbDCaja.CodRef
    FIELDS NroRef LIKE CcbDCaja.NroRef
    FIELDS FchDoc LIKE CcbCDocu.FchDoc COLUMN-LABEL "    Fecha    !    Emisión    "
    FIELDS FchVto LIKE CcbCDocu.FchVto COLUMN-LABEL "    Fecha    ! Vencimiento"
    FIELDS CodMon AS CHARACTER COLUMN-LABEL "Moneda" FORMAT "x(3)"
    FIELDS ImpTot LIKE CcbDCaja.ImpTot COLUMN-LABEL "Importe Total"
    FIELDS ImpRet LIKE CcbDCaja.ImpTot COLUMN-LABEL "Importe!a Retener"
    FIELDS FchRet AS DATE
    FIELDS NroRet AS CHARACTER
    INDEX ind01 CodRef NroRef.

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
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: B-CPEDM B "?" ? INTEGRAL FacCPedi
      TABLE: B-DPEDM B "?" ? INTEGRAL FacDPedi
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
      TABLE: T-CcbCCaja T "?" ? INTEGRAL CcbCCaja
      TABLE: T-CDOCU T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: T-CODES T "?" NO-UNDO INTEGRAL FacCPedi
      TABLE: T-DDOCU T "?" NO-UNDO INTEGRAL CcbDDocu
      TABLE: T-DODES T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
      TABLE: T-Tickets T "?" NO-UNDO INTEGRAL VtaDTickets
      TABLE: T-VALES T "?" NO-UNDO INTEGRAL VtaVales
      TABLE: wrk_dcaja T "?" NO-UNDO INTEGRAL CcbDCaja
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 20.85
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-CJC_Canc-May-Contado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CJC_Canc-May-Contado Procedure 
PROCEDURE CJC_Canc-May-Contado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER s-CodDoc AS CHAR.            /* BOL o FAC */                                        
DEFINE INPUT PARAMETER s-CodMov AS INT.             /* Normalmente 02 (Ventas) */
DEFINE INPUT PARAMETER s-PtoVta AS INT.             /* Nro de Serie del Comprobante */
DEFINE INPUT PARAMETER s-Tipo AS CHAR.              /* MOSTRADOR */
DEFINE INPUT PARAMETER s-CodTer AS CHAR.            /* Terminal de Caja */
DEFINE INPUT PARAMETER s-SerCja AS INT.             /* Nro de Serie del I/C */
DEFINE INPUT PARAMETER d_Rowid AS ROWID.            /* Rowid del P/M */
DEFINE INPUT PARAMETER x-Importe-Control AS DEC.    /* Importe Base del P/M */
/* ************************************************************************************** */
/* Cargamos tablas temporales */
/* ************************************************************************************** */
DEFINE INPUT PARAMETER TABLE FOR ITEM.
DEFINE INPUT PARAMETER TABLE FOR wrk_dcaja.
DEFINE INPUT PARAMETER TABLE FOR wrk_ret.
DEFINE INPUT PARAMETER TABLE FOR T-CcbCCaja.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR T-CDOCU.
/* ************************************************************************************** */
DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.   /* Mensaje de Error */

DEFINE VAR NroDocCja AS CHARACTER NO-UNDO.

/* LOOP Principal */
RLOOP:
DO TRANSACTION ON ERROR UNDO RLOOP, LEAVE RLOOP ON STOP UNDO RLOOP, LEAVE RLOOP:
    /* Archivo de control */
    FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
    /* ************************************************************************************** */
    /* Generación de los comprobantes y del ingreso a caja con sus anexos */
    /* ************************************************************************************** */
    RUN CJC_FIRST-Canc-May-Contado (INPUT s-CodDoc,
                                    INPUT s-CodMov,
                                    INPUT s-PtoVta,
                                    INPUT s-Tipo,
                                    INPUT s-CodTer,
                                    INPUT s-SerCja,
                                    INPUT d_Rowid,
                                    INPUT x-Importe-Control,
                                    OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR: No se pudo generar el comprobante" .
        UNDO RLOOP, LEAVE RLOOP.
    END.
    /* ************************************************************************************** */
    RUN CJC_SECOND-Canc-May-Contado (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR: No se pudo generar el comprobante" .
        UNDO RLOOP, LEAVE RLOOP.
    END.
    IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
        /* NO se detiene la grabación */
        pMensaje = ''.
    END.
    IF RETURN-VALUE = 'PLAN-B' THEN DO:
        pMensaje = ''.
    END.
END.
RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */
IF pMensaje > '' THEN DO:
    pMensaje = pMensaJe + CHR(10) + "VERIFIQUE EL REGISTRO DE VENTAS DE SU CAJA" + CHR(10) + 
        "SUNAT RECHAZÓ EL COMPROBANTE".
    RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CJC_Canc-May-Contado-SUNAT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CJC_Canc-May-Contado-SUNAT Procedure 
PROCEDURE CJC_Canc-May-Contado-SUNAT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER s-CodDoc AS CHAR.            /* BOL o FAC */                                        
DEFINE INPUT PARAMETER s-CodMov AS INT.             /* Normalmente 02 (Ventas) */
DEFINE INPUT PARAMETER s-PtoVta AS INT.             /* Nro de Serie del Comprobante */
DEFINE INPUT PARAMETER s-Tipo AS CHAR.              /* MOSTRADOR */
DEFINE INPUT PARAMETER s-CodTer AS CHAR.            /* Terminal de Caja */
DEFINE INPUT PARAMETER s-SerCja AS INT.             /* Nro de Serie del I/C */
DEFINE INPUT PARAMETER d_Rowid AS ROWID.            /* Rowid del P/M */
DEFINE INPUT PARAMETER x-Importe-Control AS DEC.    /* Importe Base del P/M */
/* ************************************************************************************** */
/* Cargamos tablas temporales */
/* ************************************************************************************** */
DEFINE INPUT PARAMETER TABLE FOR ITEM.
DEFINE INPUT PARAMETER TABLE FOR wrk_dcaja.
DEFINE INPUT PARAMETER TABLE FOR wrk_ret.
DEFINE INPUT PARAMETER TABLE FOR T-CcbCCaja.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR T-CDOCU.
/* ************************************************************************************** */
DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.   /* Mensaje de Error */

DEFINE VAR NroDocCja AS CHARACTER NO-UNDO.

/* LOOP Principal */
RLOOP:
DO TRANSACTION ON ERROR UNDO RLOOP, LEAVE RLOOP ON STOP UNDO RLOOP, LEAVE RLOOP:
    /* Archivo de control */
    FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
    /* ************************************************************************************** */
    /* Generación de los comprobantes y del ingreso a caja con sus anexos */
    /* ************************************************************************************** */
    RUN CJC_FIRST-Canc-May-Contado-SUNAT (INPUT s-CodDoc,
                                          INPUT s-CodMov,
                                          INPUT s-PtoVta,
                                          INPUT s-Tipo,
                                          INPUT s-CodTer,
                                          INPUT s-SerCja,
                                          INPUT d_Rowid,
                                          INPUT x-Importe-Control,
                                          OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR: No se pudo generar el comprobante" .
        UNDO RLOOP, LEAVE RLOOP.
    END.
    /* ************************************************************************************** */
    RUN CJC_SECOND-Canc-May-Contado (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR: No se pudo generar el comprobante" .
        UNDO RLOOP, LEAVE RLOOP.
    END.
    IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
        /* NO se detiene la grabación */
        pMensaje = ''.
    END.
    IF RETURN-VALUE = 'PLAN-B' THEN DO:
        pMensaje = ''.
    END.
END.
RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */

IF pMensaje > '' AND pMensaje <> 'OK' THEN DO:
    pMensaje = pMensaJe + CHR(10) + "VERIFIQUE EL REGISTRO DE VENTAS DE SU CAJA" + CHR(10) + 
        "SUNAT RECHAZÓ EL COMPROBANTE".
    RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CJC_Canc-Min-Contado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CJC_Canc-Min-Contado Procedure 
PROCEDURE CJC_Canc-Min-Contado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER s-CodDoc AS CHAR.            /* BOL o FAC */                                        
DEFINE INPUT PARAMETER s-CodMov AS INT.             /* Normalmente 02 (Ventas) */
DEFINE INPUT PARAMETER s-PtoVta AS INT.             /* Nro de Serie del Comprobante */
DEFINE INPUT PARAMETER s-Tipo AS CHAR.              /* MOSTRADOR */
DEFINE INPUT PARAMETER s-CodTer AS CHAR.            /* Terminal de Caja */
DEFINE INPUT PARAMETER s-SerCja AS INT.             /* Nro de Serie del I/C */
DEFINE INPUT PARAMETER d_Rowid AS ROWID.            /* Rowid del P/M */
DEFINE INPUT PARAMETER x-Importe-Control AS DEC.    /* Importe Base del P/M */
/* ************************************************************************************** */
/* Cargamos tablas temporales */
/* ************************************************************************************** */
DEFINE INPUT PARAMETER TABLE FOR T-Tickets.
DEFINE INPUT PARAMETER TABLE FOR T-Vales.
DEFINE INPUT PARAMETER TABLE FOR wrk_dcaja.
DEFINE INPUT PARAMETER TABLE FOR wrk_ret.
DEFINE INPUT PARAMETER TABLE FOR T-CcbCCaja.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR T-CDOCU.
/* ************************************************************************************** */
DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.   /* Mensaje de Error */

DEFINE VAR NroDocCja AS CHARACTER NO-UNDO.

DEFINE VAR Imprime-Sin-Hash AS LOG NO-UNDO.

Imprime-Sin-Hash = NO.

/* LOOP Principal */
RLOOP:
DO TRANSACTION ON ERROR UNDO RLOOP, LEAVE RLOOP ON STOP UNDO RLOOP, LEAVE RLOOP:
    /* Archivo de control */
    FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
    /* ************************************************************************************** */
    /* Generación de los comprobantes y del ingreso a caja con sus anexos */
    /* ************************************************************************************** */
    RUN CJC_FIRST-Canc-Min-Contado (INPUT s-CodDoc,
                                    INPUT s-CodMov,
                                    INPUT s-PtoVta,
                                    INPUT s-Tipo,
                                    INPUT s-CodTer,
                                    INPUT s-SerCja,
                                    INPUT d_Rowid,
                                    INPUT x-Importe-Control,
                                    OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR: No se pudo generar el comprobante" .
        UNDO RLOOP, LEAVE RLOOP.
    END.
    /* ************************************************************************************** */
    RUN CJC_SECOND-Canc-May-Contado (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR: No se pudo generar el comprobante" .
        UNDO RLOOP, LEAVE RLOOP.
    END.
    IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
        /* NO se detiene la grabación */
        pMensaje = ''.
    END.
    IF RETURN-VALUE = 'PLAN-B' THEN DO:
        pMensaje = ''.
        Imprime-Sin-Hash = YES.
    END.
END.
RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */
IF pMensaje > '' THEN DO:
    pMensaje = pMensaJe + CHR(10) + "VERIFIQUE EL REGISTRO DE VENTAS DE SU CAJA" + CHR(10) + 
        "SUNAT RECHAZÓ EL COMPROBANTE".
    RETURN 'ADM-ERROR'.
END.
IF Imprime-Sin-Hash = YES THEN RETURN 'PLAN-B'.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CJC_Canc-Min-Contado-SUNAT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CJC_Canc-Min-Contado-SUNAT Procedure 
PROCEDURE CJC_Canc-Min-Contado-SUNAT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER s-CodDoc AS CHAR.            /* BOL o FAC */                                        
DEFINE INPUT PARAMETER s-CodMov AS INT.             /* Normalmente 02 (Ventas) */
DEFINE INPUT PARAMETER s-PtoVta AS INT.             /* Nro de Serie del Comprobante */
DEFINE INPUT PARAMETER s-Tipo AS CHAR.              /* MOSTRADOR */
DEFINE INPUT PARAMETER s-CodTer AS CHAR.            /* Terminal de Caja */
DEFINE INPUT PARAMETER s-SerCja AS INT.             /* Nro de Serie del I/C */
DEFINE INPUT PARAMETER d_Rowid AS ROWID.            /* Rowid del P/M */
DEFINE INPUT PARAMETER x-Importe-Control AS DEC.    /* Importe Base del P/M */
/* ************************************************************************************** */
/* Cargamos tablas temporales */
/* ************************************************************************************** */
DEFINE INPUT PARAMETER TABLE FOR T-Tickets.
DEFINE INPUT PARAMETER TABLE FOR T-Vales.
DEFINE INPUT PARAMETER TABLE FOR wrk_dcaja.
DEFINE INPUT PARAMETER TABLE FOR wrk_ret.
DEFINE INPUT PARAMETER TABLE FOR T-CcbCCaja.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR T-CDOCU.
/* ************************************************************************************** */
DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.   /* Mensaje de Error */

DEFINE VAR NroDocCja AS CHARACTER NO-UNDO.

DEFINE VAR Imprime-Sin-Hash AS LOG NO-UNDO.

Imprime-Sin-Hash = NO.

/* LOOP Principal */
RLOOP:
DO TRANSACTION ON ERROR UNDO RLOOP, LEAVE RLOOP ON STOP UNDO RLOOP, LEAVE RLOOP:
    /* Archivo de control */
    FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
    /* ************************************************************************************** */
    /* Generación de los comprobantes y del ingreso a caja con sus anexos */
    /* ************************************************************************************** */
    RUN CJC_FIRST-Canc-Min-Contado-SUNAT (INPUT s-CodDoc,
                                          INPUT s-CodMov,
                                          INPUT s-PtoVta,
                                          INPUT s-Tipo,
                                          INPUT s-CodTer,
                                          INPUT s-SerCja,
                                          INPUT d_Rowid,
                                          INPUT x-Importe-Control,
                                          OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR: No se pudo generar el comprobante" .
        UNDO RLOOP, LEAVE RLOOP.
    END.
    /* ************************************************************************************** */
    RUN CJC_SECOND-Canc-May-Contado (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR: No se pudo generar el comprobante" .
        UNDO RLOOP, LEAVE RLOOP.
    END.
    IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
        /* NO se detiene la grabación */
        pMensaje = ''.
    END.
    IF RETURN-VALUE = 'PLAN-B' THEN DO:
        pMensaje = ''.
        Imprime-Sin-Hash = YES.
    END.
END.
RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */
IF pMensaje > '' AND pMensaje <> 'OK' THEN DO:
    pMensaje = pMensaje + CHR(10) + "VERIFIQUE EL REGISTRO DE VENTAS DE SU CAJA" + CHR(10) + 
        "SUNAT RECHAZÓ EL COMPROBANTE".
    RETURN 'ADM-ERROR'.
END.
IF Imprime-Sin-Hash = YES THEN RETURN 'PLAN-B'.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CJC_FIRST-Canc-May-Contado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CJC_FIRST-Canc-May-Contado Procedure 
PROCEDURE CJC_FIRST-Canc-May-Contado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Rutina principal
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER s-CodDoc AS CHAR.            /* BOL o FAC */                                        
DEFINE INPUT PARAMETER s-CodMov AS INT.             /* Normalmente 02 (Ventas) */
DEFINE INPUT PARAMETER s-PtoVta AS INT.             /* Nro de Serie del Comprobante */
DEFINE INPUT PARAMETER s-Tipo AS CHAR.              /* MOSTRADOR */
DEFINE INPUT PARAMETER s-CodTer AS CHAR.            /* Terminal de Caja */
DEFINE INPUT PARAMETER s-SerCja AS INT.
DEFINE INPUT PARAMETER d_Rowid AS ROWID.            /* Rowid del P/M */
DEFINE INPUT PARAMETER x-Importe-Control AS DEC.    /* Importe Base del P/M */
DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.   /* Mensaje de Error */

ASSIGN pMensaje = "".

DEFINE VAR x-retval AS CHAR.
DEFINE VAR s-CodCja AS CHAR INIT 'I/C' NO-UNDO.
DEFINE VAR NroDocCja AS CHARACTER NO-UNDO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Archivo de control */
    FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
    {lib\lock-genericov3.i ~
        &Tabla="B-CPEDM" ~
        &Condicion="ROWID(B-CPEDM) = d_rowid" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje"
        &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'" }
    /* CONTROL DE SITUACION DEL PEDIDO AL CONTADO */
    IF B-CPEDM.FlgEst <> "P" THEN DO:
        pMensaje = "Pedido mostrador ya no esta PENDIENTE".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    IF B-CPEDM.ImpTot <> x-Importe-Control THEN DO:
        pMensaje = 'El IMPORTE del pedido ha sido cambiado por el vendedor' + CHR(10) +
            'Proceso cancelado' .
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* ************************************************************************************* */
    /* CREACION DE LAS ORDENES DE DESPACHO */
    /* ************************************************************************************* */
    EMPTY TEMP-TABLE T-CODES.
    EMPTY TEMP-TABLE T-DODES.
    RUN proc_Crea-Ordenes (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear la Orden de Despacho".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* ************************************************************************************* */
    /* RHC 09/03/2019 ORDENES DE DESPACHO PROMOCIONAL TRANSFERENCIA GRATUITA (899) */
    /* ************************************************************************************* */
    RUN proc_Crea-Orden-Promocion (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = "NO se pudo crear la Orden de Despacho PROMOCIONES".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* ****************************************************** */
    /* CREACION DE COMPROBANTES A PARTIR DE LAS ORDENES DE DESPACHO */
    EMPTY TEMP-TABLE T-CDOCU.
    EMPTY TEMP-TABLE T-DDOCU.
    RUN proc_Crea-Comprobantes (INPUT s-CodDoc,
                                INPUT s-PtoVta,
                                INPUT s-CodMov,
                                INPUT s-Tipo,
                                INPUT s-CodTer,
                                OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear el Comprobante Temporal".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* CREACION DEL INGRESO A CAJA EN CcbCCaja */
    NroDocCja = "".
    RUN proc_IngCja (INPUT s-CodCja,    /* I/C */
                     INPUT s-CodTer,
                     INPUT s-SerCja,
                     INPUT s-Tipo,
                     OUTPUT NroDocCja,
                     OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear el Ingreso a Caja".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* GRABACION DE LOS COMPROBANTES: ACTUALIZA ALMACENES */
    RUN proc_Graba-Comprobantes (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear el Comprobante".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* GRABA ORDENES DE DESPACHO */
    RUN proc_Graba-Ordenes (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear las Ordenes de Despacho".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* CREACION DE OTROS DOCUMENTOS ANEXOS */
    RUN proc_Documentos-Anexos (INPUT NroDocCja,
                                INPUT s-CodCja,
                                OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudieron crear los Documentos Anexos".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* CERRAMOS PEDIDO MOSTRADOR */
    ASSIGN 
        B-CPEDM.flgest = "C".        /* Pedido Mostrador CERRADO */
    FOR EACH FacDPedi OF B-CPEDM EXCLUSIVE-LOCK:
        FacDPedi.canate = FacDPedi.canped.  /* Atendido al 100% */
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CJC_FIRST-Canc-May-Contado-SUNAT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CJC_FIRST-Canc-May-Contado-SUNAT Procedure 
PROCEDURE CJC_FIRST-Canc-May-Contado-SUNAT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Rutina principal
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER s-CodDoc AS CHAR.            /* BOL o FAC */                                        
DEFINE INPUT PARAMETER s-CodMov AS INT.             /* Normalmente 02 (Ventas) */
DEFINE INPUT PARAMETER s-PtoVta AS INT.             /* Nro de Serie del Comprobante */
DEFINE INPUT PARAMETER s-Tipo AS CHAR.              /* MOSTRADOR */
DEFINE INPUT PARAMETER s-CodTer AS CHAR.            /* Terminal de Caja */
DEFINE INPUT PARAMETER s-SerCja AS INT.
DEFINE INPUT PARAMETER d_Rowid AS ROWID.            /* Rowid del P/M */
DEFINE INPUT PARAMETER x-Importe-Control AS DEC.    /* Importe Base del P/M */
DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.   /* Mensaje de Error */

ASSIGN pMensaje = "".

DEFINE VAR x-retval AS CHAR.
DEFINE VAR s-CodCja AS CHAR INIT 'I/C' NO-UNDO.
DEFINE VAR NroDocCja AS CHARACTER NO-UNDO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Archivo de control */
    FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
    {lib\lock-genericov3.i ~
        &Tabla="B-CPEDM" ~
        &Condicion="ROWID(B-CPEDM) = d_rowid" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje"
        &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'" }
    /* CONTROL DE SITUACION DEL PEDIDO AL CONTADO */
    IF B-CPEDM.FlgEst <> "P" THEN DO:
        pMensaje = "Pedido mostrador ya no esta PENDIENTE".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    IF B-CPEDM.TotalVenta <> x-Importe-Control THEN DO:
        pMensaje = 'El IMPORTE del pedido ha sido cambiado por el vendedor' + CHR(10) +
            'Proceso cancelado' .
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* ************************************************************************************* */
    /* CREACION DE LAS ORDENES DE DESPACHO */
    /* ************************************************************************************* */
    EMPTY TEMP-TABLE T-CODES.
    EMPTY TEMP-TABLE T-DODES.
    RUN proc_Crea-Ordenes (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear la Orden de Despacho".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* ************************************************************************************* */
    /* RHC 09/03/2019 ORDENES DE DESPACHO PROMOCIONAL TRANSFERENCIA GRATUITA (899) */
    /* ************************************************************************************* */
    RUN proc_Crea-Orden-Promocion (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = "NO se pudo crear la Orden de Despacho PROMOCIONES".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* ****************************************************** */
    /* CREACION DE COMPROBANTES A PARTIR DE LAS ORDENES DE DESPACHO */
    EMPTY TEMP-TABLE T-CDOCU.
    EMPTY TEMP-TABLE T-DDOCU.
    RUN proc_Crea-Comprobantes-SUNAT (INPUT s-CodDoc,
                                      INPUT s-PtoVta,
                                      INPUT s-CodMov,
                                      INPUT s-Tipo,
                                      INPUT s-CodTer,
                                      OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear el Comprobante Temporal".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* GRABACION DE LOS COMPROBANTES: ACTUALIZA ALMACENES */
    RUN proc_Graba-Comprobantes-SUNAT (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear el Comprobante".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* CREACION DEL INGRESO A CAJA EN CcbCCaja */
    NroDocCja = "".
    RUN proc_IngCja-SUNAT (INPUT s-CodCja,    /* I/C */
                           INPUT s-CodTer,
                           INPUT s-SerCja,
                           INPUT s-Tipo,
                           OUTPUT NroDocCja,
                           OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear el Ingreso a Caja".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* GRABA ORDENES DE DESPACHO */
    RUN proc_Graba-Ordenes (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear las Ordenes de Despacho".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* CREACION DE OTROS DOCUMENTOS ANEXOS */
    RUN proc_Documentos-Anexos (INPUT NroDocCja,
                                INPUT s-CodCja,
                                OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudieron crear los Documentos Anexos".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* CERRAMOS PEDIDO MOSTRADOR */
    ASSIGN 
        B-CPEDM.flgest = "C".        /* Pedido Mostrador CERRADO */
    FOR EACH FacDPedi OF B-CPEDM EXCLUSIVE-LOCK:
        FacDPedi.canate = FacDPedi.canped.  /* Atendido al 100% */
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CJC_FIRST-Canc-Min-Contado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CJC_FIRST-Canc-Min-Contado Procedure 
PROCEDURE CJC_FIRST-Canc-Min-Contado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER s-CodDoc AS CHAR.            /* BOL o FAC */                                        
DEFINE INPUT PARAMETER s-CodMov AS INT.             /* Normalmente 02 (Ventas) */
DEFINE INPUT PARAMETER s-PtoVta AS INT.             /* Nro de Serie del Comprobante */
DEFINE INPUT PARAMETER s-Tipo AS CHAR.              /* MOSTRADOR */
DEFINE INPUT PARAMETER s-CodTer AS CHAR.            /* Terminal de Caja */
DEFINE INPUT PARAMETER s-SerCja AS INT.
DEFINE INPUT PARAMETER d_Rowid AS ROWID.            /* Rowid del P/M */
DEFINE INPUT PARAMETER x-Importe-Control AS DEC.    /* Importe Base del P/M */
DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.   /* Mensaje de Error */

ASSIGN pMensaje = "".

DEFINE VAR x-retval AS CHAR.
DEFINE VAR s-CodCja AS CHAR INIT 'I/C' NO-UNDO.
DEFINE VAR NroDocCja AS CHARACTER NO-UNDO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Archivo de control */
    FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
    {lib\lock-genericov3.i ~
        &Tabla="B-CPEDM" ~
        &Condicion="ROWID(B-CPEDM) = d_rowid" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje"
        &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'" }
    /* CONTROL DE SITUACION DEL PEDIDO AL CONTADO */
    IF B-CPEDM.FlgEst <> "P" THEN DO:
        pMensaje = "Pedido mostrador ya no esta PENDIENTE".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    IF B-CPEDM.ImpTot <> x-Importe-Control THEN DO:
        pMensaje = 'El IMPORTE del pedido ha sido cambiado por el vendedor' + CHR(10) +
            'Proceso cancelado' .
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* ************************************************************************************* */
    /* CREACION DE LAS ORDENES DE DESPACHO */
    /* ************************************************************************************* */
    EMPTY TEMP-TABLE T-CODES.
    EMPTY TEMP-TABLE T-DODES.
    RUN proc_Crea-Ordenes (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear la Orden de Despacho".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* ************************************************************************************* */
    /* CREACION DE COMPROBANTES A PARTIR DE LAS ORDENES DE DESPACHO */
    /* ************************************************************************************* */
    EMPTY TEMP-TABLE T-CDOCU.
    EMPTY TEMP-TABLE T-DDOCU.
    RUN proc_Crea-Comprobantes (INPUT s-CodDoc,
                                INPUT s-PtoVta,
                                INPUT s-CodMov,
                                INPUT s-Tipo,
                                INPUT s-CodTer,
                                OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear el Comprobante Temporal".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* CREACION DEL INGRESO A CAJA EN CcbCCaja */
    NroDocCja = "".
    RUN proc_IngCja (INPUT s-CodCja,    /* I/C */
                     INPUT s-CodTer,
                     INPUT s-SerCja,
                     INPUT s-Tipo,
                     OUTPUT NroDocCja,
                     OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear el Ingreso a Caja".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* GRABACION DE LOS COMPROBANTES: ACTUALIZA ALMACENES */
    RUN proc_Graba-Comprobantes (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear el Comprobante".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* GRABA ORDENES DE DESPACHO */
    RUN proc_Graba-Ordenes (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear las Ordenes de Despacho".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* CREACION DE OTROS DOCUMENTOS ANEXOS */
    RUN proc_Documentos-Anexos (INPUT NroDocCja,
                                INPUT s-CodCja,
                                OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudieron crear los Documentos Anexos".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* CONTROL DE VALES DE COMPRA */
    RUN proc_Control-de-Vales (INPUT NroDocCja,
                               OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo actualizar los vales de consumo'.
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* ACTUALIZA CONTROL DE TICKETS */
    /* 04Ago2016 - NroDocCja ??? */
    RUN proc_Control-de-Tickets (INPUT NroDocCja,
                                 OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo actualizar el control de Tickets'.
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* CERRAMOS PEDIDO MOSTRADOR */
    ASSIGN 
        B-CPEDM.flgest = "C".        /* Pedido Mostrador CERRADO */
    FOR EACH FacDPedi OF B-CPEDM EXCLUSIVE-LOCK:
        FacDPedi.canate = FacDPedi.canped.  /* Atendido al 100% */
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CJC_FIRST-Canc-Min-Contado-SUNAT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CJC_FIRST-Canc-Min-Contado-SUNAT Procedure 
PROCEDURE CJC_FIRST-Canc-Min-Contado-SUNAT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER s-CodDoc AS CHAR.            /* BOL o FAC */                                        
DEFINE INPUT PARAMETER s-CodMov AS INT.             /* Normalmente 02 (Ventas) */
DEFINE INPUT PARAMETER s-PtoVta AS INT.             /* Nro de Serie del Comprobante */
DEFINE INPUT PARAMETER s-Tipo AS CHAR.              /* MOSTRADOR */
DEFINE INPUT PARAMETER s-CodTer AS CHAR.            /* Terminal de Caja */
DEFINE INPUT PARAMETER s-SerCja AS INT.
DEFINE INPUT PARAMETER d_Rowid AS ROWID.            /* Rowid del P/M */
DEFINE INPUT PARAMETER x-Importe-Control AS DEC.    /* Importe Base del P/M */
DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.   /* Mensaje de Error */

ASSIGN pMensaje = "".

DEFINE VAR x-retval AS CHAR.
DEFINE VAR s-CodCja AS CHAR INIT 'I/C' NO-UNDO.
DEFINE VAR NroDocCja AS CHARACTER NO-UNDO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Archivo de control */
    FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
    {lib\lock-genericov3.i ~
        &Tabla="B-CPEDM" ~
        &Condicion="ROWID(B-CPEDM) = d_rowid" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje"
        &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'" }
    /* CONTROL DE SITUACION DEL PEDIDO AL CONTADO */
    IF B-CPEDM.FlgEst <> "P" THEN DO:
        pMensaje = "Pedido mostrador ya no está PENDIENTE".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    IF B-CPEDM.TotalVenta <> x-Importe-Control THEN DO:
        pMensaje = 'El IMPORTE del pedido ha sido cambiado por el vendedor' + CHR(10) +
            'Proceso cancelado' .
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* ************************************************************************************* */
    /* CREACION DE LAS ORDENES DE DESPACHO */
    /* ************************************************************************************* */
    EMPTY TEMP-TABLE T-CODES.
    EMPTY TEMP-TABLE T-DODES.
    RUN proc_Crea-Ordenes (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear la Orden de Despacho".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* ************************************************************************************* */
    /* CREACION DE COMPROBANTES A PARTIR DE LAS ORDENES DE DESPACHO */
    /* ************************************************************************************* */
    EMPTY TEMP-TABLE T-CDOCU.
    EMPTY TEMP-TABLE T-DDOCU.
    RUN proc_Crea-Comprobantes-SUNAT (INPUT s-CodDoc,
                                      INPUT s-PtoVta,
                                      INPUT s-CodMov,
                                      INPUT s-Tipo,
                                      INPUT s-CodTer,
                                      OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear el Comprobante Temporal".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* GRABACION DE LOS COMPROBANTES: ACTUALIZA ALMACENES */
    RUN proc_Graba-Comprobantes-SUNAT (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear el Comprobante".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* CREACION DEL INGRESO A CAJA EN CcbCCaja */
    NroDocCja = "".
    RUN proc_IngCja-SUNAT (INPUT s-CodCja,    /* I/C */
                           INPUT s-CodTer,
                           INPUT s-SerCja,
                           INPUT s-Tipo,
                           OUTPUT NroDocCja,
                           OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear el Ingreso a Caja".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* GRABA ORDENES DE DESPACHO */
    RUN proc_Graba-Ordenes (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear las Ordenes de Despacho".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* CREACION DE OTROS DOCUMENTOS ANEXOS */
    RUN proc_Documentos-Anexos (INPUT NroDocCja,
                                INPUT s-CodCja,
                                OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudieron crear los Documentos Anexos".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* CONTROL DE VALES DE COMPRA */
    RUN proc_Control-de-Vales (INPUT NroDocCja,
                               OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo actualizar los vales de consumo'.
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* ACTUALIZA CONTROL DE TICKETS */
    /* 04Ago2016 - NroDocCja ??? */
    RUN proc_Control-de-Tickets (INPUT NroDocCja,
                                 OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo actualizar el control de Tickets'.
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* CERRAMOS PEDIDO MOSTRADOR */
    ASSIGN 
        B-CPEDM.flgest = "C".        /* Pedido Mostrador CERRADO */
    FOR EACH FacDPedi OF B-CPEDM EXCLUSIVE-LOCK:
        FacDPedi.canate = FacDPedi.canped.  /* Atendido al 100% */
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CJC_SECOND-Canc-May-Contado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CJC_SECOND-Canc-May-Contado Procedure 
PROCEDURE CJC_SECOND-Canc-May-Contado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* NOTA:
- Si pasa el primero entonces pasa el segundo
- Si el error es ERROR-EPOS solo se informa el error pero no se detiene la grabación 
*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* Segundo Generamos los comprobantes que faltan */
DEFINE VAR x-retval AS CHAR.

pMensaje = "".
EMPTY TEMP-TABLE T-FELogErrores.    /* CONTROL DE ERRORES DE FACTURACION ELECTRONICA */
FOR EACH T-CDOCU NO-LOCK, FIRST Ccbcdocu OF T-CDOCU NO-LOCK:
    /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
    /* Si s-user-id = 'ADMIN' entonces NO pasa por bizlink */
    RUN sunat\progress-to-ppll-v3 ( INPUT Ccbcdocu.CodDiv,
                                    INPUT Ccbcdocu.CodDoc,
                                    INPUT Ccbcdocu.NroDoc,
                                    INPUT-OUTPUT TABLE T-FELogErrores,
                                    OUTPUT pMensaje ).
    /* 2 tipos de errores:
        ADM-ERROR: Rechazo de BizzLinks
        ERROR-EPOS: No se pudo grabar en control de comprobante FELOgComprobantes */
    IF RETURN-VALUE <> "OK" THEN DO:
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR de ePos".
            RETURN "ADM-ERROR".
        END.
        IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
            IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR log de comprobantes".
            RETURN "ERROR-EPOS".
        END.
        IF RETURN-VALUE = 'PLAN-B' THEN DO:
            pMensaje = ''.
            RETURN "PLAN-B".
        END.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Graba-Temp-FeLogErrores) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Temp-FeLogErrores Procedure 
PROCEDURE Graba-Temp-FeLogErrores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH T-FeLogErrores:
    CREATE FeLogErrores.
    BUFFER-COPY T-FeLogErrores TO FeLogErrores NO-ERROR.
    DELETE T-FeLogErrores.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_AplicaDoc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_AplicaDoc Procedure 
PROCEDURE proc_AplicaDoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_CodDoc LIKE CcbCDocu.CodDoc.
    DEFINE INPUT PARAMETER para_NroDoc LIKE CcbDMov.NroDoc.
    DEFINE INPUT PARAMETER para_NroDocCja LIKE CcbDMov.NroDoc.    
    DEFINE INPUT PARAMETER para_TpoCmb LIKE CCBDMOV.TpoCmb.
    DEFINE INPUT PARAMETER para_ImpNac LIKE CcbDMov.ImpTot.
    DEFINE INPUT PARAMETER para_ImpUSA LIKE CcbDMov.ImpTot.
    DEFINE INPUT PARAMETER s-CodCja AS CHAR.
    DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    /* Tipo de Documento */
    FIND FacDoc WHERE FacDoc.CodCia = s-CodCia AND
        FacDoc.CodDoc = para_CodDoc
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacDoc THEN DO:
        pMensaje = para_CodDoc + ' NO CONFIGURADO'.
        RETURN "ADM-ERROR".
    END.

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        /* Busca Documento */
        {lib\lock-genericov3.i &Tabla="B-CDOCU" ~
            &Alcance="FIRST" ~
            &Condicion="B-CDocu.CodCia = s-codcia ~
            AND B-CDocu.CodDoc = para_CodDoc ~
            AND B-CDocu.NroDoc = para_NroDoc" ~
            &Bloqueo="EXCLUSIVE-LOCK" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje" ~
            &TipoError="UNDO, RETURN 'ADM-ERROR'" }

        /* Crea Detalle de la Aplicación */
        CREATE CCBDMOV.
        ASSIGN
            CCBDMOV.CodCia = s-CodCia
            CCBDMOV.CodDiv = s-CodDiv
            CCBDMOV.NroDoc = B-CDocu.NroDoc
            CCBDMOV.CodDoc = B-CDocu.CodDoc
            CCBDMOV.CodMon = B-CDocu.CodMon
            CCBDMOV.CodRef = s-CodCja
            CCBDMOV.NroRef = para_NroDocCja
            CCBDMOV.CodCli = B-CDocu.CodCli
            CCBDMOV.FchDoc = B-CDocu.FchDoc
            CCBDMOV.HraMov = STRING(TIME,"HH:MM:SS")
            CCBDMOV.TpoCmb = para_tpocmb
            CCBDMOV.usuario = s-User-ID.
        IF B-CDocu.CodMon = 1 THEN
            ASSIGN CCBDMOV.ImpTot = para_ImpNac.
        ELSE ASSIGN CCBDMOV.ImpTot = para_ImpUSA.
        IF FacDoc.TpoDoc THEN
            ASSIGN B-CDocu.SdoAct = B-CDocu.SdoAct + CCBDMOV.ImpTot.
        ELSE
            ASSIGN B-CDocu.SdoAct = B-CDocu.SdoAct - CCBDMOV.ImpTot.
        /* Cancela Documento */
        IF B-CDocu.SdoAct = 0 THEN
            ASSIGN 
                B-CDocu.FlgEst = "C"
                B-CDocu.FchCan = TODAY.
        ELSE
            ASSIGN
                B-CDocu.FlgEst = "P"
                B-CDocu.FchCan = ?.
        /* RHC 26/08/2015 Chequeo adicional */
        IF B-CDOCU.SdoAct < 0 THEN DO:
            pMensaje = "ERROR en el saldo del documento: " + B-CDocu.coddoc + " " + B-CDocu.nrodoc.
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END. /* DO TRANSACTION... */
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_Control-de-Tickets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Control-de-Tickets Procedure 
PROCEDURE proc_Control-de-Tickets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER NroDocCja AS CHAR.                                           
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

RLOOP:
FOR EACH T-Tickets NO-LOCK:
    FIND FIRST VtaDTickets OF T-Tickets NO-LOCK NO-ERROR.
    IF AVAILABLE Vtadtickets THEN DO:
        pMensaje = 'ERROR: el ticket ' + T-Tickets.NroTck + ' YA ha sido aplicado'.
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    CREATE Vtadtickets.
    BUFFER-COPY T-Tickets TO Vtadtickets
        ASSIGN
            Vtadtickets.CodRef = "I/C"
            Vtadtickets.NroRef = NroDocCja 
            VtaDTickets.Fecha = DATETIME(TODAY, MTIME)
            VtaDTickets.CodDiv = s-coddiv
            VtaDTickets.Usuario = s-user-id
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = "NO se pudo actualizar el control de tickets".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_Control-de-Vales) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Control-de-Vales Procedure 
PROCEDURE proc_Control-de-Vales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER NroDocCja AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* Se va a aplicar todo lo que se pueda */
DEF VAR x-Importe-Vales AS DEC NO-UNDO.
RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND FIRST T-CcbCCaja.
    x-Importe-Vales = T-CcbCCaja.ImpNac[10] + T-CcbCCaja.ImpUsa[10] * T-CcbCCaja.TpoCmb.
    FOR EACH T-VALES NO-LOCK:
        {lib/lock-genericov3.i
            &Tabla="VtaVales"
            &Alcance="FIRST"
            &Condicion="VtaVales.codcia = s-codcia ~
            AND VtaVales.nrodoc = T-VALES.nrodoc"
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
            &Accion="RETRY"
            &Mensaje="NO"
            &txtMensaje="pMensaje"
            &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'"
            }
        IF NOT AVAILABLE VtaVales THEN DO:
            pMensaje = 'NO se pudo actualizar el vale de consumo ' + T-VALES.nrodoc.
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        IF VtaVales.FlgEst <> "P" THEN DO:
            pMensaje = 'El vale de consumo ' + T-VALES.nrodoc + ' acaba de ser utilizado en otra caja'.
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            VtaVales.CodDiv = s-coddiv
            VtaVales.CodRef = "I/C"
            VtaVales.FchApl = DATETIME(TODAY, MTIME)
            VtaVales.FlgEst = 'C'
            VtaVales.NroRef = NroDocCja
            VtaVales.UsrApli = s-user-id.
        IF VtaVales.CodMon = 1 THEN DO:
            VtaVales.ImpApl = MINIMUM(x-Importe-Vales, VtaVales.ImpVal).
            x-Importe-Vales = x-Importe-Vales - VtaVales.ImpVal.
        END.
        IF VtaVales.CodMon = 2 THEN DO:
            VtaVales.ImpApl = MINIMUM(x-Importe-Vales / T-CcbCCaja.TpoCmb, VtaVales.ImpVal).
            x-Importe-Vales = x-Importe-Vales - VtaVales.ImpVal * T-CcbCCaja.TpoCmb.
        END.
        IF x-Importe-Vales <= 0 THEN x-Importe-Vales = 0.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_Crea-Comprobantes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Crea-Comprobantes Procedure 
PROCEDURE proc_Crea-Comprobantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER s-CodDoc AS CHAR.
DEF INPUT PARAMETER s-PtoVta AS INT.
DEF INPUT PARAMETER s-CodMov AS INT.
DEF INPUT PARAMETER s-Tipo AS CHAR.
DEF INPUT PARAMETER s-CodTer AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEFINE VARIABLE iCountItem AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE lCreaHeader AS LOGICAL NO-UNDO.
DEFINE VARIABLE lItemOk AS LOGICAL NO-UNDO.
DEFINE VARIABLE FILL-IN-items AS INT NO-UNDO.
DEFINE VARIABLE X_cto1 AS DEC NO-UNDO.
DEFINE VARIABLE X_cto2 AS DEC NO-UNDO.
DEFINE VARIABLE x-ImporteAcumulado AS DEC NO-UNDO.
DEFINE VARIABLE Fac_Rowid AS ROWID NO-UNDO.

/* CONSISTENCIA */
/* FOR EACH T-CODES NO-LOCK:                                                                                            */
/*     /* Verifica Detalle */                                                                                           */
/*     FOR EACH T-DODES OF T-CODES NO-LOCK BY FacDPedi.NroItm:                                                          */
/*         FIND Almmmate WHERE Almmmate.CodCia = T-DODES.CodCia                                                         */
/*             AND Almmmate.CodAlm = T-DODES.AlmDes                                                                     */
/*             AND Almmmate.codmat = T-DODES.CodMat                                                                     */
/*             NO-LOCK NO-ERROR.                                                                                        */
/*         IF NOT AVAILABLE Almmmate THEN DO:                                                                           */
/*             pMensaje = "Artículo " + FacDPedi.CodMat + " NO está asignado al almacén " + FacDPedi.AlmDes + CHR(10) + */
/*                 'Proceso abortado'.                                                                                  */
/*             RETURN 'ADM-ERROR'.                                                                                      */
/*         END.                                                                                                         */
/*     END.                                                                                                             */
/* END.                                                                                                                 */
FIND FIRST Ccbdterm WHERE CcbDTerm.CodCia = s-CodCia AND 
    CcbDTerm.CodDiv = s-CodDiv AND
    CcbDTerm.CodDoc = s-CodDoc AND
    CcbDTerm.CodTer = s-Codter AND
    CcbDTerm.NroSer = s-PtoVta AND
    CAN-FIND(FIRST CcbCTerm OF CcbDTerm NO-LOCK)
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE CcbDTerm THEN DO:
    pMensaje = "NO está configurado el documento " + s-CodDoc + " en el terminal " + s-CodTer.
    RETURN 'ADM-ERROR'.
END.
IF LOOKUP(s-CodDoc, 'FAC,BOL') = 0 THEN DO:
    MESSAGE "El documento " + s-CodDoc + " NO es válido (debe ser FAC o BOL)".
    RETURN 'ADM-ERROR'.
END.
/*  FIN DE CONSISTENCIA */
FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
FILL-IN-items = 999999.     /* Sin Límites */

IF s-coddoc = 'BOL' THEN FILL-IN-items = FacCfgGn.Items_Boleta.
IF s-coddoc = 'FAC' THEN FILL-IN-items = FacCfgGn.Items_Factura.
RUN sunat\p-nro-items (s-CodDoc, s-PtoVta, OUTPUT FILL-IN-items).
/* ***************************************************************************** */
/* RHC 24/06/2016 TODO SE VA A CREAR EL TABLAS TEMPORALES                        */
/* ***************************************************************************** */
DEF BUFFER BT-DDOCU FOR T-DDOCU.
TRLOOP:    
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    /* Correlativo */
    {lib\lock-genericov3.i 
        &Tabla="FacCorre" ~
        &Alcance="FIRST"
        &Condicion="FacCorre.CodCia = s-CodCia ~
        AND FacCorre.CodDiv = s-CodDiv ~
        AND FacCorre.CodDoc = s-CodDoc ~
        AND FacCorre.NroSer = s-PtoVta" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &TxtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
    FOR EACH T-CODES NO-LOCK:
        ASSIGN
            lCreaHeader = TRUE
            lItemOk     = FALSE.
        /* NO se fija en el stock del almacén, simplemente lo crea 
            OJO: Para el código 099268 IMPUESTO BOÑLSA PLASTICA */
        FOR EACH T-DODES OF T-CODES NO-LOCK, FIRST Almmmatg OF T-DODES NO-LOCK
/*             FIRST Almmmate NO-LOCK WHERE Almmmate.CodCia = T-DODES.CodCia */
/*                 AND Almmmate.CodAlm = T-DODES.AlmDes                      */
/*                 AND Almmmate.CodMat = T-DODES.CodMat                      */
            BREAK BY T-DODES.CodCia BY T-DODES.CodMat:
            /* Crea Cabecera */
            IF lCreaHeader THEN DO:
                /* Cabecera del Comprobante */
                RUN proc_CreaCabecera (INPUT s-CodDoc, 
                                       INPUT s-CodMov,
                                       INPUT s-Tipo,
                                       INPUT s-CodTer,
                                       OUTPUT Fac_Rowid,
                                       OUTPUT pMensaje).
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO TRLOOP, RETURN 'ADM-ERROR'.
                ASSIGN
                    x_cto1 = 0
                    x_cto2 = 0
                    iCountItem = 1
                    lCreaHeader = FALSE
                    x-ImporteAcumulado = 0.
            END.
            /* Crea Detalle */
            FIND T-CDOCU WHERE ROWID(T-CDOCU) = Fac_Rowid.
            CREATE T-DDOCU.
            BUFFER-COPY T-DODES 
                TO T-DDOCU
                ASSIGN
                    T-DDOCU.NroItm = iCountItem
                    T-DDOCU.CodCia = T-CDOCU.CodCia
                    T-DDOCU.Coddoc = T-CDOCU.Coddoc
                    T-DDOCU.NroDoc = T-CDOCU.NroDoc 
                    T-DDOCU.FchDoc = T-CDOCU.FchDoc
                    T-DDOCU.CodDiv = T-CDOCU.CodDiv
                    T-DDOCU.CanDes = T-DODES.CanPed
                    T-DDOCU.Factor = T-DODES.Factor
                    T-DDOCU.UndVta = T-DODES.UndVta
                    T-DDOCU.ImpIgv = T-DODES.ImpIgv
                    T-DDOCU.ImpIsc = T-DODES.ImpIsc
                    T-DDOCU.ImpDto = T-DODES.ImpDto
                    T-DDOCU.ImpLin = T-DODES.ImpLin
                    T-DDOCU.impdcto_adelanto[4] = T-DODES.Libre_d02.  /* Flete Unitario */
            /* *********************************************** */
            x-ImporteAcumulado = x-ImporteAcumulado + T-DODES.ImpLin.
            /* Contador de registros válidos */
            iCountItem = iCountItem + 1.
            /* Guarda Costos */
            IF almmmatg.monvta = 1 THEN DO:
                x_cto1 = ROUND(Almmmatg.Ctotot * T-DDOCU.CanDes * T-DDOCU.Factor,2).
                x_cto2 = ROUND((Almmmatg.Ctotot * T-DDOCU.CanDes * T-DDOCU.Factor) / Almmmatg.Tpocmb,2).
            END.
            IF almmmatg.monvta = 2 THEN DO:
                x_cto1 = ROUND(Almmmatg.Ctotot * T-DDOCU.CanDes * T-DDOCU.Factor * Almmmatg.TpoCmb, 2).
                x_cto2 = ROUND((Almmmatg.Ctotot * T-DDOCU.CanDes * T-DDOCU.Factor), 2).
            END.
            ASSIGN
                T-DDOCU.ImpCto = ( IF T-CDOCU.Codmon = 1 THEN x_cto1 ELSE x_cto2 )
                T-CDOCU.ImpCto = T-CDOCU.ImpCto + T-DDOCU.ImpCto.
            /* ************** */
            IF iCountItem > FILL-IN-items OR LAST-OF(T-DODES.CodCia) THEN DO:
                /* GRABAR LOS TOTALES DEl COMPROBANTE */
                RUN proc_Graba-Totales-Factura (OUTPUT pMensaje).
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO TRLOOP, RETURN 'ADM-ERROR'.
            END.
            /* ************** */
            IF iCountItem > FILL-IN-items THEN DO:
                iCountItem = 1.
                lCreaHeader = TRUE.
            END.
        END. /* FOR EACH T-DODES... */
    END.    /* FOR EACH T-CODES */
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_Crea-Comprobantes-SUNAT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Crea-Comprobantes-SUNAT Procedure 
PROCEDURE proc_Crea-Comprobantes-SUNAT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER s-CodDoc AS CHAR.
DEF INPUT PARAMETER s-PtoVta AS INT.
DEF INPUT PARAMETER s-CodMov AS INT.
DEF INPUT PARAMETER s-Tipo AS CHAR.
DEF INPUT PARAMETER s-CodTer AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEFINE VARIABLE iCountItem AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE lCreaHeader AS LOGICAL NO-UNDO.
DEFINE VARIABLE lItemOk AS LOGICAL NO-UNDO.
DEFINE VARIABLE FILL-IN-items AS INT NO-UNDO.
DEFINE VARIABLE X_cto1 AS DEC NO-UNDO.
DEFINE VARIABLE X_cto2 AS DEC NO-UNDO.
DEFINE VARIABLE x-ImporteAcumulado AS DEC NO-UNDO.
DEFINE VARIABLE Fac_Rowid AS ROWID NO-UNDO.

FIND FIRST Ccbdterm WHERE CcbDTerm.CodCia = s-CodCia AND 
    CcbDTerm.CodDiv = s-CodDiv AND
    CcbDTerm.CodDoc = s-CodDoc AND
    CcbDTerm.CodTer = s-Codter AND
    CcbDTerm.NroSer = s-PtoVta AND
    CAN-FIND(FIRST CcbCTerm OF CcbDTerm NO-LOCK)
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE CcbDTerm THEN DO:
    pMensaje = "NO está configurado el documento " + s-CodDoc + " en el terminal " + s-CodTer.
    RETURN 'ADM-ERROR'.
END.
IF LOOKUP(s-CodDoc, 'FAC,BOL') = 0 THEN DO:
    MESSAGE "El documento " + s-CodDoc + " NO es válido (debe ser FAC o BOL)".
    RETURN 'ADM-ERROR'.
END.
/*  FIN DE CONSISTENCIA */
FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
FILL-IN-items = 999999.     /* Sin Límites */

IF s-coddoc = 'BOL' THEN FILL-IN-items = FacCfgGn.Items_Boleta.
IF s-coddoc = 'FAC' THEN FILL-IN-items = FacCfgGn.Items_Factura.
RUN sunat\p-nro-items (s-CodDoc, s-PtoVta, OUTPUT FILL-IN-items).
/* ***************************************************************************** */
/* RHC 24/06/2016 TODO SE VA A CREAR EL TABLAS TEMPORALES                        */
/* ***************************************************************************** */
DEF BUFFER BT-DDOCU FOR T-DDOCU.
TRLOOP:    
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    /* Correlativo */
    {lib\lock-genericov3.i 
        &Tabla="FacCorre" ~
        &Alcance="FIRST"
        &Condicion="FacCorre.CodCia = s-CodCia ~
        AND FacCorre.CodDiv = s-CodDiv ~
        AND FacCorre.CodDoc = s-CodDoc ~
        AND FacCorre.NroSer = s-PtoVta" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &TxtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
    FOR EACH T-CODES NO-LOCK:
        ASSIGN
            lCreaHeader = TRUE
            lItemOk     = FALSE.
        /* NO se fija en el stock del almacén, simplemente lo crea 
            OJO: Para el código 099268 IMPUESTO BOLSA PLASTICA */
        FOR EACH T-DODES OF T-CODES NO-LOCK, FIRST Almmmatg OF T-DODES NO-LOCK BREAK BY T-DODES.CodCia BY T-DODES.CodMat:
            /* Crea Cabecera */
            IF lCreaHeader THEN DO:
                /* Cabecera del Comprobante */
                RUN proc_CreaCabecera (INPUT s-CodDoc, 
                                       INPUT s-CodMov,
                                       INPUT s-Tipo,
                                       INPUT s-CodTer,
                                       OUTPUT Fac_Rowid,
                                       OUTPUT pMensaje).
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO TRLOOP, RETURN 'ADM-ERROR'.
                ASSIGN
                    x_cto1 = 0
                    x_cto2 = 0
                    iCountItem = 1
                    lCreaHeader = FALSE
                    x-ImporteAcumulado = 0.
            END.
            /* Crea Detalle */
            FIND T-CDOCU WHERE ROWID(T-CDOCU) = Fac_Rowid.
            CREATE T-DDOCU.
            BUFFER-COPY T-DODES 
                TO T-DDOCU
                ASSIGN
                    T-DDOCU.NroItm = iCountItem
                    T-DDOCU.CodCia = T-CDOCU.CodCia
                    T-DDOCU.Coddoc = T-CDOCU.Coddoc
                    T-DDOCU.NroDoc = T-CDOCU.NroDoc 
                    T-DDOCU.FchDoc = T-CDOCU.FchDoc
                    T-DDOCU.CodDiv = T-CDOCU.CodDiv
                    T-DDOCU.CanDes = T-DODES.CanPed
                    T-DDOCU.Factor = T-DODES.Factor
                    T-DDOCU.UndVta = T-DODES.UndVta
                    T-DDOCU.ImpIgv = T-DODES.ImpIgv
                    T-DDOCU.ImpIsc = T-DODES.ImpIsc
                    T-DDOCU.ImpDto = T-DODES.ImpDto
                    T-DDOCU.ImpLin = T-DODES.ImpLin
                    T-DDOCU.impdcto_adelanto[4] = T-DODES.Libre_d02.  /* Flete Unitario */
            /* *********************************************** */
            x-ImporteAcumulado = x-ImporteAcumulado + T-DODES.ImpLin.
            /* Contador de registros válidos */
            iCountItem = iCountItem + 1.
            /* Guarda Costos */
            IF almmmatg.monvta = 1 THEN DO:
                x_cto1 = ROUND(Almmmatg.Ctotot * T-DDOCU.CanDes * T-DDOCU.Factor,2).
                x_cto2 = ROUND((Almmmatg.Ctotot * T-DDOCU.CanDes * T-DDOCU.Factor) / Almmmatg.Tpocmb,2).
            END.
            IF almmmatg.monvta = 2 THEN DO:
                x_cto1 = ROUND(Almmmatg.Ctotot * T-DDOCU.CanDes * T-DDOCU.Factor * Almmmatg.TpoCmb, 2).
                x_cto2 = ROUND((Almmmatg.Ctotot * T-DDOCU.CanDes * T-DDOCU.Factor), 2).
            END.
            ASSIGN
                T-DDOCU.ImpCto = ( IF T-CDOCU.Codmon = 1 THEN x_cto1 ELSE x_cto2 )
                T-CDOCU.ImpCto = T-CDOCU.ImpCto + T-DDOCU.ImpCto.
            /* ************** */
            IF iCountItem > FILL-IN-items OR LAST-OF(T-DODES.CodCia) THEN DO:
                /* GRABAR LOS TOTALES DEl COMPROBANTE */
                RUN proc_Graba-Totales-Factura-SUNAT (OUTPUT pMensaje).
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO TRLOOP, RETURN 'ADM-ERROR'.
            END.
            /* ************** */
            IF iCountItem > FILL-IN-items THEN DO:
                iCountItem = 1.
                lCreaHeader = TRUE.
            END.
        END. /* FOR EACH T-DODES... */
    END.    /* FOR EACH T-CODES */
END.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_Crea-Orden-Promocion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Crea-Orden-Promocion Procedure 
PROCEDURE proc_Crea-Orden-Promocion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

IF NOT CAN-FIND(FIRST ITEM NO-LOCK) THEN RETURN 'OK'.

ASSIGN pMensaje = "".

DEFINE VARIABLE x_igv AS DECIMAL NO-UNDO.
DEFINE VARIABLE x_isc AS DECIMAL NO-UNDO.
DEFINE VARIABLE i_NPed   AS INTEGER INIT 0.
DEFINE VARIABLE i_NItem  AS INTEGER INIT 0.

/* Archivo de control */
FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.

DEFINE VARIABLE s-CodDoc AS CHAR NO-UNDO.
DEFINE VARIABLE s-NroSer LIKE FacCorre.NroSer.
DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
DEFINE VARIABLE s-FlgPicking LIKE GN-DIVI.FlgPicking.
DEFINE VARIABLE s-FlgBarras LIKE GN-DIVI.FlgBarras.

/* GENERAMOS UNA O/M POR CADA ALMACÉN */
ASSIGN
    s-CodDoc = "O/M".               /* ORDEN DE DESPACHO MOSTRADOR */
FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
    FacCorre.CodDiv = s-CodDiv AND
    FacCorre.CodDoc = S-CODDOC AND
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccorre THEN DO:
    pMensaje = 'NO está configurado el correlativo para el documento ' + s-coddoc + CHR(10) +
        'para la división ' + s-coddiv.
    RETURN 'ADM-ERROR'.
END.
ASSIGN
    s-NroSer = FacCorre.NroSer.
RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    /* ****************************************************************************** */
    /* CONTROL DE CORRELATIVO */
    /* ****************************************************************************** */
    REPEAT:
        {lib/lock-genericov3.i
            &Tabla="FacCorre"
            &Condicion="FacCorre.codcia = s-codcia ~
            AND FacCorre.coddoc = s-coddoc ~
            AND FacCorre.nroser = s-nroser" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &TxtMensaje="pMensaje" ~
            &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'" ~
            }
        IF NOT CAN-FIND(FIRST FacCPedi WHERE FacCPedi.codcia = s-codcia
                        AND FacCPedi.coddiv = FacCorre.coddiv
                        AND FacCPedi.coddoc = FacCorre.coddoc
                        AND FacCPedi.nroped = STRING(FacCorre.nroser, '999') + 
                            STRING(FacCorre.correlativo, '999999')
                        NO-LOCK)
            THEN LEAVE.
        ASSIGN
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
    END.
    /* ****************************************************************************** */
    /* Barremos el ITEM */
    FOR EACH ITEM NO-LOCK, FIRST Almacen NO-LOCK WHERE Almacen.codcia = ITEM.codcia 
        AND Almacen.codalm = ITEM.almdes BREAK BY ITEM.almdes: 
        IF FIRST-OF(ITEM.almdes) THEN DO:       /* En realidad hay un solo almacén */
            I-NITEM = 0.
            CREATE T-CODES.
            BUFFER-COPY B-CPEDM
                EXCEPT 
                B-CPEDM.FlgEst
                B-CPEDM.FlgSit
                TO T-CODES
                ASSIGN 
                T-CODES.CodCia = S-CODCIA
                T-CODES.CodDiv = S-CODDIV
                T-CODES.CodDoc = s-coddoc 
                T-CODES.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
                T-CODES.DivDes = Almacen.CodDiv    /* <<< OJO <<< */
                T-CODES.CodAlm = Almacen.CodAlm    /* <<< OJO <<< */
                T-CODES.FlgEst = 'P'               
                T-CODES.CodRef = B-CPEDM.CodDoc    /* El Pedido */
                T-CODES.NroRef = B-CPEDM.NroPed
                T-CODES.TpoCmb = FacCfgGn.TpoCmb[1] 
                T-CODES.Hora = STRING(TIME,"HH:MM")
                T-CODES.FchPed = TODAY
                T-CODES.FchVen = TODAY
                NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
            ASSIGN
                FacCorre.Correlativo = FacCorre.Correlativo + 1.
            ASSIGN
                T-CODES.FmaPgo = "899".    /* Transferencia Gratuita */
            /* RHC solo cuando es por enviar */
            IF T-CODES.FlgEnv = YES THEN DO:
                FIND gn-divi WHERE gn-divi.codcia = T-CODES.codcia
                    AND gn-divi.coddiv = T-CODES.divdes
                    NO-LOCK.
                ASSIGN
                    s-FlgPicking = GN-DIVI.FlgPicking
                    s-FlgBarras  = GN-DIVI.FlgBarras
                    T-CODES.FchVen = TODAY + GN-DIVI.DiasVtoO_D.
                IF s-FlgPicking = YES THEN T-CODES.FlgSit = "T".    /* Falta Pre-Picking */
                IF s-FlgPicking = NO AND s-FlgBarras = NO THEN T-CODES.FlgSit = "C".    /* Picking OK */
                IF s-FlgPicking = NO AND s-FlgBarras = YES THEN T-CODES.FlgSit = "P".   /* Falta Picking */
            END.
            ELSE T-CODES.FlgSit = "C".    /* Barras OK */
            /* ****************************** */
        END.
        I-NITEM = I-NITEM + 1.
        CREATE T-DODES. 
        BUFFER-COPY ITEM 
            EXCEPT ITEM.CanAte ITEM.Libre_d04 ITEM.Libre_d05
            TO T-DODES
            ASSIGN  
            T-DODES.CodCia  = T-CODES.CodCia 
            T-DODES.coddiv  = T-CODES.coddiv 
            T-DODES.coddoc  = T-CODES.coddoc 
            T-DODES.NroPed  = T-CODES.NroPed 
            T-DODES.FchPed  = T-CODES.FchPed
            T-DODES.Hora    = T-CODES.Hora 
            T-DODES.FlgEst  = T-CODES.FlgEst
            T-DODES.NroItm  = I-NITEM
            T-DODES.CanPick = ITEM.CanPed.     /* <<< OJO <<< */
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_Crea-Ordenes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Crea-Ordenes Procedure 
PROCEDURE proc_Crea-Ordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       El puntero debe estar en B-CPEDM
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.                                         
                                         
DEFINE VARIABLE x_igv AS DECIMAL NO-UNDO.
DEFINE VARIABLE x_isc AS DECIMAL NO-UNDO.
DEFINE VARIABLE i_NPed   AS INTEGER INIT 0.
DEFINE VARIABLE i_NItem  AS INTEGER INIT 0.


EMPTY TEMP-TABLE T-CODES.
EMPTY TEMP-TABLE T-DODES.

/* Archivo de control */
FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.

DEFINE VARIABLE s-CodDoc AS CHAR NO-UNDO.
DEFINE VARIABLE s-NroSer LIKE FacCorre.NroSer.
DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
DEFINE VARIABLE s-FlgPicking LIKE GN-DIVI.FlgPicking.
DEFINE VARIABLE s-FlgBarras LIKE GN-DIVI.FlgBarras.

/* GENERAMOS UNA O/M POR CADA ALMACÉN */
ASSIGN
    s-CodDoc = "O/M".               /* ORDEN DE DESPACHO MOSTRADOR */
FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
    FacCorre.CodDiv = s-CodDiv AND
    FacCorre.CodDoc = S-CODDOC AND
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccorre THEN DO:
    pMensaje = 'NO está configurado el correlativo para el documento ' + s-coddoc + CHR(10) +
        'para la división ' + s-coddiv.
    RETURN 'ADM-ERROR'.
END.
ASSIGN
    s-NroSer = FacCorre.NroSer.
RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    /* ****************************************************************************** */
    /* CONTROL DE CORRELATIVO */
    /* ****************************************************************************** */
    REPEAT:
        {lib/lock-genericov3.i
            &Tabla="FacCorre"
            &Condicion="FacCorre.codcia = s-codcia ~
            AND FacCorre.CodDiv = s-CodDiv ~
            AND FacCorre.coddoc = s-coddoc ~
            AND FacCorre.nroser = s-nroser"
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
            &Accion="RETRY"
            &Mensaje="NO"
            &TxtMensaje="pMensaje"
            &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'"
            }
        IF NOT CAN-FIND(FIRST FacCPedi WHERE FacCPedi.codcia = s-codcia
                        AND FacCPedi.coddiv = FacCorre.coddiv
                        AND FacCPedi.coddoc = FacCorre.coddoc
                        AND FacCPedi.nroped = STRING(FacCorre.nroser, '999') + 
                            STRING(FacCorre.correlativo, '999999')
                        NO-LOCK)
            THEN LEAVE.
        ASSIGN
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
    END.
    /* ****************************************************************************** */
    /* Barremos el P/M */
    FOR EACH B-DPEDM OF B-CPEDM NO-LOCK, FIRST Almacen NO-LOCK WHERE 
        Almacen.codcia = B-DPEDM.codcia AND Almacen.codalm = B-DPEDM.almdes
        BREAK BY B-DPEDM.almdes: 
        IF FIRST-OF(B-DPEDM.almdes) THEN DO:
            I-NITEM = 0.
            CREATE T-CODES.
            BUFFER-COPY B-CPEDM
                EXCEPT 
                B-CPEDM.FlgEst
                B-CPEDM.FlgSit
                TO T-CODES
                ASSIGN 
                T-CODES.CodCia = S-CODCIA
                T-CODES.CodDiv = S-CODDIV
                T-CODES.CodDoc = s-coddoc 
                T-CODES.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
                T-CODES.DivDes = Almacen.CodDiv    /* <<< OJO <<< */
                T-CODES.CodAlm = Almacen.CodAlm    /* <<< OJO <<< */
                T-CODES.FlgEst = 'P'               
                T-CODES.CodRef = B-CPEDM.CodDoc    /* El Pedido */
                T-CODES.NroRef = B-CPEDM.NroPed
                T-CODES.TpoCmb = FacCfgGn.TpoCmb[1] 
                T-CODES.Hora = STRING(TIME,"HH:MM")
                T-CODES.FchPed = TODAY
                T-CODES.FchVen = TODAY
                NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
            ASSIGN
                FacCorre.Correlativo = FacCorre.Correlativo + 1.
            /* RHC solo cuando es por enviar */
            IF T-CODES.FlgEnv = YES THEN DO:
                FIND gn-divi WHERE gn-divi.codcia = T-CODES.codcia
                    AND gn-divi.coddiv = T-CODES.divdes
                    NO-LOCK.
                ASSIGN
                    s-FlgPicking = GN-DIVI.FlgPicking
                    s-FlgBarras  = GN-DIVI.FlgBarras
                    T-CODES.FchVen = TODAY + GN-DIVI.DiasVtoO_D.
                IF s-FlgPicking = YES THEN T-CODES.FlgSit = "T".    /* Falta Pre-Picking */
                IF s-FlgPicking = NO AND s-FlgBarras = NO THEN T-CODES.FlgSit = "C".    /* Picking OK */
                IF s-FlgPicking = NO AND s-FlgBarras = YES THEN T-CODES.FlgSit = "P".   /* Falta Picking */
                /* RHC 20/05/2019 NO pasa por picking */
                T-CODES.FlgSit = "P".    /* Barras OK */
            END.
            ELSE T-CODES.FlgSit = "C".    /* Barras OK */
            /* ****************************** */
        END.
        I-NITEM = I-NITEM + 1.
        CREATE T-DODES. 
        BUFFER-COPY B-DPEDM 
            EXCEPT B-DPEDM.CanAte
            TO T-DODES
            ASSIGN  
            T-DODES.CodCia  = T-CODES.CodCia 
            T-DODES.coddiv  = T-CODES.coddiv 
            T-DODES.coddoc  = T-CODES.coddoc 
            T-DODES.NroPed  = T-CODES.NroPed 
            T-DODES.FchPed  = T-CODES.FchPed
            T-DODES.Hora    = T-CODES.Hora 
            T-DODES.FlgEst  = T-CODES.FlgEst
            T-DODES.NroItm  = I-NITEM
            T-DODES.CanPick = B-DPEDM.CanPed.     /* <<< OJO <<< */
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_CreaCabecera) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CreaCabecera Procedure 
PROCEDURE proc_CreaCabecera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER s-CodDoc AS CHAR.
DEF INPUT PARAMETER s-CodMov AS INT.
DEF INPUT PARAMETER s-Tipo AS CHAR.
DEF INPUT PARAMETER s-CodTer AS CHAR.
DEF OUTPUT PARAMETER Fac_Rowid AS ROWID.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    CREATE T-CDOCU.
    ASSIGN
        T-CDOCU.CodCia = s-CodCia
        T-CDOCU.CodDiv = s-CodDiv   
        T-CDOCU.CodDoc = s-CodDoc              /* FAC BOL TCK */
        T-CDOCU.NroDoc = STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) + STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')) 
        T-CDOCU.DivOri = T-CODES.CodDiv       /* OJO: division de estadisticas */
        T-CDOCU.CodAlm = T-CODES.CodAlm       /* Almacén de descarga */
        T-CDOCU.FchDoc = TODAY
        T-CDOCU.CodMov = s-CodMov
        T-CDOCU.CodRef = T-CODES.CodDoc           /* CONTROL POR DEFECTO */
        T-CDOCU.NroRef = T-CODES.NroPed
        T-CDOCU.Libre_c01 = T-CODES.CodDoc        /* CONTROL ADICIONAL */
        T-CDOCU.Libre_c02 = T-CODES.NroPed
        T-CDOCU.CodPed = B-CPEDM.CodDoc           /* NUMERO DE PEDIDO */
        T-CDOCU.NroPed = B-CPEDM.NroPed
        T-CDOCU.Tipo   = s-Tipo
        T-CDOCU.CodCaja= s-CodTer
        T-CDOCU.FchVto = TODAY
        T-CDOCU.CodCli = T-CODES.CodCli
        T-CDOCU.NomCli = T-CODES.NomCli
        T-CDOCU.RucCli = T-CODES.RucCli
        T-CDOCU.CodAnt = T-CODES.Atencion     /* DNI */
        T-CDOCU.DirCli = T-CODES.DirCli
        T-CDOCU.CodVen = T-CODES.CodVen
        T-CDOCU.TipVta = "1"
        T-CDOCU.TpoFac = "CO"                  /* CONTADO, (OJO Utilex dice solo "C" ) */
        T-CDOCU.FmaPgo = T-CODES.FmaPgo
        T-CDOCU.CodMon = T-CODES.CodMon
        T-CDOCU.TpoCmb = FacCfgGn.TpoCmb[1]
        T-CDOCU.PorIgv = T-CODES.PorIgv
        T-CDOCU.NroOrd = T-CODES.ordcmp
        T-CDOCU.FlgEst = "P"                   /* PENDIENTE */
        T-CDOCU.FlgSit = "P"
        T-CDOCU.usuario = S-USER-ID
        T-CDOCU.HorCie = STRING(TIME,'hh:mm')
        /* INFORMACION DE LA TIQUETERA */
        T-CDOCU.libre_c03 = FacCorre.NroImp
        /* INFORMACION DEL P/M */
        T-CDOCU.Glosa     = B-CPEDM.Glosa
        T-CDOCU.TipBon[1] = B-CPEDM.TipBon[1]
        T-CDOCU.NroCard   = B-CPEDM.NroCard 
        T-CDOCU.FlgEnv    = B-CPEDM.FlgEnv /* OJO Control de envio de documento */
        T-CDOCU.FlgCbd    = B-CPEDM.FlgIgv
        /* RHC 18/01/2016 TCK Factura */
        T-CDOCU.Libre_c04 = B-CPEDM.Cmpbnte
        /* Información Ventas Utilex */
        T-CDOCU.ImpDto2    = B-CPEDM.ImpDto2
        /* INFORMACION DEL ENCARTE */
        T-CDOCU.Libre_c05 = B-CPEDM.FlgSit + '|' + B-CPEDM.Libre_c05
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "NO se pudo generar el temporal de comprobantes".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /* PUNTERO DE LA FACTURA */
    ASSIGN
        Fac_Rowid = ROWID(T-CDOCU).
    /* ********************* */
    FIND gn-convt WHERE gn-convt.Codig = T-CDOCU.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN DO:
        T-CDOCU.TipVta = IF gn-ConVt.TotDias = 0 THEN "1" ELSE "2".
        T-CDOCU.FchVto = T-CDOCU.FchDoc + INTEGER(ENTRY(NUM-ENTRIES(gn-ConVt.Vencmtos),gn-ConVt.Vencmtos)).
    END.
    FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
        AND gn-clie.CodCli = T-CDOCU.CodCli 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie  THEN DO:
        ASSIGN
            T-CDOCU.CodDpto = gn-clie.CodDept 
            T-CDOCU.CodProv = gn-clie.CodProv 
            T-CDOCU.CodDist = gn-clie.CodDist.
    END.
    /* ******************************** */
    /*IF cMess <> "" THEN ASSIGN T-CDOCU.Libre_c05 = cMess.        */

    /* Guarda Centro de Costo */
    FIND gn-ven WHERE
        gn-ven.codcia = s-codcia AND
        gn-ven.codven = T-CDOCU.codven
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN T-CDOCU.cco = gn-ven.cco.
    /* TRACKING FACTURAS */
    RUN vtagn/pTracking-04 (s-CodCia,
                            s-CodDiv,
                            T-CDOCU.CodPed,
                            T-CDOCU.NroPed,
                            s-User-Id,
                            'EFAC',
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            T-CDOCU.coddoc,
                            T-CDOCU.nrodoc,
                            T-CDOCU.Libre_c01,
                            T-CDOCU.Libre_c02).
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_CreaRetencion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CreaRetencion Procedure 
PROCEDURE proc_CreaRetencion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEFINE VARIABLE cNomcli AS CHAR NO-UNDO.

FIND FIRST T-CcbCCaja NO-ERROR.
RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH wrk_ret NO-LOCK:
        FIND FIRST CCBCMOV WHERE CCBCMOV.CodCia = wrk_ret.CodCia AND
            CCBCMOV.CodDoc = wrk_ret.CodDoc AND
            CCBCMOV.NroDoc = wrk_ret.NroDoc
            NO-LOCK NO-ERROR.
        IF AVAILABLE CCBCMOV THEN DO:
            pMensaje = "YA EXISTE RETENCION PARA DOCUMENTO " + CCBCMOV.CodDoc + " " + CCBCMOV.NroDoc + CHR(10) +
                "CREADO POR: " + CCBCMOV.usuario + CHR(10) + 
                "FECHA: " + STRING(CCBCMOV.FchMov) + CHR(10) +
                "HORA: " + CCBCMOV.HraMov.
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        CREATE CCBCMOV.
        ASSIGN
            CCBCMOV.CodCia = wrk_ret.CodCia
            CCBCMOV.CodDoc = wrk_ret.CodDoc
            CCBCMOV.NroDoc = wrk_ret.NroDoc
            CCBCMOV.CodRef = wrk_ret.CodRef
            CCBCMOV.NroRef = wrk_ret.NroRef
            CCBCMOV.CodCli = wrk_ret.CodCli
            CCBCMOV.CodDiv = s-CodDiv
            CCBCMOV.CodMon = 1                  /* Ojo: Siempre en Soles */
            CCBCMOV.TpoCmb = T-CcbCCaja.TpoCmb
            CCBCMOV.FchDoc = wrk_ret.FchDoc
            CCBCMOV.ImpTot = wrk_ret.ImpTot
            CCBCMOV.DocRef = wrk_ret.NroRet     /* Comprobante */
            CCBCMOV.FchRef = wrk_ret.FchRet     /* Fecha */
            CCBCMOV.ImpRef = wrk_ret.ImpRet     /* Importe */
            CCBCMOV.FchMov = TODAY
            CCBCMOV.HraMov = STRING(TIME,"HH:MM:SS")
            CCBCMOV.usuario = s-User-ID
            CCBCMOV.chr__01 = cNomcli.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_Documentos-Anexos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Documentos-Anexos Procedure 
PROCEDURE proc_Documentos-Anexos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER NroDocCja AS CHARACTER.
DEFINE INPUT PARAMETER s-CodCja AS CHAR.
DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEFINE VARIABLE cliename    LIKE Gn-Clie.Nomcli.
DEFINE VARIABLE clieruc     LIKE Gn-Clie.Ruc.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FIND FIRST T-CcbCCaja.
    /* Genera Cheque */
    IF ((T-CcbCCaja.Voucher[2] > "") AND (T-CcbCCaja.ImpNac[2] + T-CcbCCaja.ImpUsa[2]) > 0) OR
        ((T-CcbCCaja.Voucher[3] > "") AND (T-CcbCCaja.ImpNac[3] + T-CcbCCaja.ImpUsa[3]) > 0) 
        THEN DO:
        FIND Gn-Clie WHERE Gn-Clie.Codcia = cl-codcia AND
            Gn-Clie.CodCli = T-CcbCCaja.Voucher[10]
            NO-LOCK NO-ERROR.
        IF AVAILABLE Gn-Clie THEN
            ASSIGN
                cliename = Gn-Clie.Nomcli
                clieruc = Gn-Clie.Ruc.
        CREATE CcbCDocu.
        ASSIGN
            CcbCDocu.CodCia = S-CodCia
            CcbCDocu.CodDiv = S-CodDiv
            CcbCDocu.CodDoc = "CHC"
            CcbCDocu.CodCli = T-CcbCCaja.Voucher[10]
            CcbCDocu.NomCli = cliename
            CcbCDocu.RucCli = clieruc
            CcbCDocu.FlgEst = "P"
            CcbCDocu.Usuario = s-User-Id
            CcbCDocu.TpoCmb = T-CcbCCaja.TpoCmb
            CcbCDocu.FchDoc = TODAY.
        IF T-CcbCCaja.ImpNac[2] + T-CcbCCaja.ImpUsa[2] > 0 THEN
            ASSIGN
                CcbCDocu.NroDoc = T-CcbCCaja.Voucher[2]
                CcbCDocu.CodMon = IF T-ccbCCaja.ImpNac[2] <> 0 THEN 1 ELSE 2
                CcbCDocu.ImpTot = IF T-ccbCCaja.ImpNac[2] <> 0 THEN
                    T-ccbCCaja.ImpNac[2] ELSE T-ccbCCaja.ImpUsa[2]
                CcbCDocu.SdoAct = IF T-ccbCCaja.ImpNac[2] <> 0 THEN
                    T-ccbCCaja.ImpNac[2] ELSE T-ccbCCaja.ImpUsa[2]
                CcbCDocu.ImpBrt = IF T-ccbCCaja.ImpNac[2] <> 0 THEN
                    T-ccbCCaja.ImpNac[2] ELSE T-ccbCCaja.ImpUsa[2]
                CcbCDocu.FchVto = T-CcbCCaja.FchVto[2]
                        NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pMensaje = "Cheque CHC " + T-CcbCCaja.Voucher[2] + " ya registrado".
                UNDO, RETURN "ADM-ERROR".
            END.
        ELSE
            ASSIGN
                CcbCDocu.NroDoc = T-CcbCCaja.Voucher[3]
                CcbCDocu.CodMon = IF T-ccbCCaja.ImpNac[3] <> 0 THEN 1 ELSE 2
                CcbCDocu.ImpTot = IF T-ccbCCaja.ImpNac[3] <> 0 THEN
                    T-ccbCCaja.ImpNac[3] ELSE T-ccbCCaja.ImpUsa[3]
                CcbCDocu.SdoAct = IF T-ccbCCaja.ImpNac[3] <> 0 THEN
                    T-ccbCCaja.ImpNac[3] ELSE T-ccbCCaja.ImpUsa[3]
                CcbCDocu.ImpBrt = IF T-ccbCCaja.ImpNac[3] <> 0 THEN
                    T-ccbCCaja.ImpNac[3] ELSE T-ccbCCaja.ImpUsa[3]
                CcbCDocu.FchVto = T-CcbCCaja.FchVto[3]
                        NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pMensaje = "Cheque CHC " + T-CcbCCaja.Voucher[3] + " ya registrado".
                UNDO, RETURN "ADM-ERROR".
            END.
    END.
    /* Actualiza la Boleta de Deposito */
    DEF VAR x-Tipo AS CHAR NO-UNDO.
    x-Tipo = 'BD'.
    IF LOOKUP(T-CcbCCaja.CodBco[5], 'PPO') > 0 THEN x-Tipo = T-CcbCCaja.CodBco[5].
    IF T-CcbCCaja.Voucher[5] > "" AND (T-CcbCCaja.ImpNac[5] + T-CcbCCaja.ImpUsa[5]) > 0 
        THEN DO:
        RUN proc_AplicaDoc(INPUT x-Tipo,            /*"BD",*/
                           INPUT T-CcbCCaja.Voucher[5],
                           INPUT NroDocCja,
                           INPUT T-CcbCCaja.tpocmb,
                           INPUT T-CcbCCaja.ImpNac[5],
                           INPUT T-CcbCCaja.ImpUsa[5],
                           INPUT s-CodCja,
                           OUTPUT pMensaje ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear la Boleta de Depósito".
            UNDO RLOOP, RETURN "ADM-ERROR".
        END.
    END.

    /* Aplica Nota de Credito */
    IF CAN-FIND(FIRST wrk_dcaja) THEN DO:
        FOR EACH wrk_dcaja NO-LOCK,
            FIRST CcbCDocu WHERE CcbCDocu.CodCia = wrk_dcaja.CodCia
            AND CcbCDocu.CodCli = wrk_dcaja.CodCli
            AND CcbCDocu.CodDoc = wrk_dcaja.CodRef
            AND CcbCDocu.NroDoc = wrk_dcaja.NroRef NO-LOCK:
            RUN proc_AplicaDoc(INPUT CcbCDocu.CodDoc,
                               INPUT CcbCDocu.NroDoc,
                               INPUT NroDocCja,
                               INPUT T-CcbCCaja.tpocmb,
                               INPUT (IF CcbCDocu.CodMon = 1 THEN wrk_dcaja.Imptot ELSE 0),
                               INPUT (IF CcbCDocu.CodMon = 2 THEN wrk_dcaja.Imptot ELSE 0),
                               INPUT s-CodCja,
                               OUTPUT pMensaje ).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo aplicar la Nota de Crédito".
                UNDO RLOOP, RETURN "ADM-ERROR".
            END.
        END.
    END.

    /* Aplica de Anticipo */
    IF T-CcbCCaja.Voucher[7] > "" AND (T-CcbCCaja.ImpNac[7] + T-CcbCCaja.ImpUsa[7]) > 0 
        THEN DO:
        RUN proc_AplicaDoc(INPUT "A/R",
                           INPUT T-CcbCCaja.Voucher[7],
                           INPUT NroDocCja,
                           INPUT T-CcbCCaja.tpocmb,
                           INPUT T-CcbCCaja.ImpNac[7],
                           INPUT T-CcbCCaja.ImpUsa[7],
                           INPUT s-CodCja,
                           OUTPUT pMensaje ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo aplicar el Anticipo".
            UNDO RLOOP, RETURN "ADM-ERROR".
        END.
    END.
    /* Retenciones */
    IF CAN-FIND(FIRST wrk_ret) THEN DO:
        FOR EACH wrk_ret:
            wrk_ret.NroRef = NroDocCja.
        END.
        RUN proc_CreaRetencion (OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear las Retenciones".
            UNDO RLOOP, RETURN "ADM-ERROR".
        END.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_Graba-Comprobantes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Graba-Comprobantes Procedure 
PROCEDURE proc_Graba-Comprobantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* OJO: Si un documento YA PASÓ por el e-Pos NO SE PUEDE DESAPARACER
        Hay que marcarlo como ANULADO 
*/
/* Primero Creamos los Comprobantes */
pMensaje = "".
/* Guardamos el comprobante anterior para la nueva factura por TRANSFERENCIA GRATUITA */
DEF VAR x-OldNumber AS CHAR NO-UNDO.

PRIMERO:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH T-CDOCU NO-LOCK:
        CREATE Ccbcdocu.
        BUFFER-COPY T-CDOCU TO Ccbcdocu NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "Correlativo errado o duplicado: " + T-CDOCU.coddoc + " " +  T-CDOCU.nrodoc.
            UNDO PRIMERO, RETURN 'ADM-ERROR'.
        END.
        IF Ccbcdocu.FmaPgo = '899' THEN DO:  /* Nunca va a ser el primer documento */
            IF x-OldNumber > '' THEN Ccbcdocu.Glosa = x-OldNumber.
        END.
        x-OldNumber = Ccbcdocu.CodDoc + " " + Ccbcdocu.NroDoc.
        FOR EACH T-DDOCU OF T-CDOCU NO-LOCK:
            CREATE Ccbddocu.
            BUFFER-COPY T-DDOCU TO Ccbddocu NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pMensaje = "Correlativo errado o duplicado: " + T-CDOCU.coddoc + " " +  T-CDOCU.nrodoc.
                UNDO PRIMERO, RETURN 'ADM-ERROR'.
            END.
        END.
        /* ****************************************************************************************** */
        /* 21/04/2022 Solo actualiza valores SUNAT */
        /* Importes SUNAT */
        /* ****************************************************************************************** */
        DEF VAR hProc AS HANDLE NO-UNDO.
        RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
        RUN tabla-ccbcdocu IN hProc (INPUT Ccbcdocu.CodDiv,
                                     INPUT Ccbcdocu.CodDoc,
                                     INPUT Ccbcdocu.NroDoc,
                                     OUTPUT pMensaje).
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
        IF pMensaje = "OK" THEN pMensaje = "".
        DELETE PROCEDURE hProc.
        /* ****************************************************************************************** */
        /* ACTUALIZAMOS ALMACENES */
        RUN vta2/act_almv2 ( INPUT ROWID(CcbCDocu), OUTPUT pMensaje ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > '') THEN pMensaje = "ERROR: NO se pudo actualizar el Kardex".
            UNDO PRIMERO, RETURN 'ADM-ERROR'.
        END.
    END.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_Graba-Comprobantes-SUNAT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Graba-Comprobantes-SUNAT Procedure 
PROCEDURE proc_Graba-Comprobantes-SUNAT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* OJO: Si un documento YA PASÓ por el e-Pos NO SE PUEDE DESAPARACER
        Hay que marcarlo como ANULADO 
*/
/* Primero Creamos los Comprobantes */
pMensaje = "".
/* Guardamos el comprobante anterior para la nueva factura por TRANSFERENCIA GRATUITA */
DEF VAR x-OldNumber AS CHAR NO-UNDO.

PRIMERO:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH T-CDOCU NO-LOCK:
        CREATE Ccbcdocu.
        BUFFER-COPY T-CDOCU TO Ccbcdocu NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "Correlativo errado o duplicado: " + T-CDOCU.coddoc + " " +  T-CDOCU.nrodoc.
            UNDO PRIMERO, RETURN 'ADM-ERROR'.
        END.
        IF Ccbcdocu.FmaPgo = '899' THEN DO:  /* Nunca va a ser el primer documento */
            IF x-OldNumber > '' THEN Ccbcdocu.Glosa = x-OldNumber.
        END.
        x-OldNumber = Ccbcdocu.CodDoc + " " + Ccbcdocu.NroDoc.
        FOR EACH T-DDOCU OF T-CDOCU NO-LOCK:
            CREATE Ccbddocu.
            BUFFER-COPY T-DDOCU TO Ccbddocu NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pMensaje = "Correlativo errado o duplicado: " + T-CDOCU.coddoc + " " +  T-CDOCU.nrodoc.
                UNDO PRIMERO, RETURN 'ADM-ERROR'.
            END.
        END.
        /* VALORES SUNAT */
        /* ****************************************************************************************** */
        /* Importes SUNAT */
        /* ****************************************************************************************** */
        DEF VAR hProc AS HANDLE NO-UNDO.
        RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
        RUN tabla-ccbcdocu IN hProc (INPUT Ccbcdocu.CodDiv,
                                     INPUT Ccbcdocu.CodDoc,
                                     INPUT Ccbcdocu.NroDoc,
                                     OUTPUT pMensaje).
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
        IF pMensaje = "OK" THEN pMensaje = "".
        DELETE PROCEDURE hProc.
        /* ****************************************************************************************** */
        /* ****************************************************************************************** */
        /* ACTUALIZAMOS ALMACENES */
        RUN vta2/act_almv2 ( INPUT ROWID(CcbCDocu), OUTPUT pMensaje ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > '') THEN pMensaje = "ERROR: NO se pudo actualizar el Kardex".
            UNDO PRIMERO, RETURN 'ADM-ERROR'.
        END.
    END.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_Graba-Ordenes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Graba-Ordenes Procedure 
PROCEDURE proc_Graba-Ordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH T-CODES NO-LOCK:
        CREATE FacCPedi.
        BUFFER-COPY T-CODES TO FacCPedi NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "Correlativo errado o duplicado: " + T-CODES.coddoc + " " +  T-CODES.nroped.
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
        FOR EACH T-DODES OF T-CODES NO-LOCK:
            CREATE FacDPedi.
            BUFFER-COPY T-DODES TO FacDPedi NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pMensaje = "Correlativo errado o duplicado: " + T-CODES.coddoc + " " +  T-CODES.nroped.
                UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
            END.
        END.
        /* TRACKING */
        RUN vtagn/pTracking-04 (T-CODES.CodCia,
                                T-CODES.CodDiv,
                                T-CODES.CodRef,
                                T-CODES.NroRef,
                                s-User-Id,
                                'GOD',
                                'P',
                                DATETIME(TODAY, MTIME),
                                DATETIME(TODAY, MTIME),
                                T-CODES.CodDoc,
                                T-CODES.NroPed,
                                T-CODES.CodRef,
                                T-CODES.NroRef).
    END.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_Graba-Totales-Factura) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Graba-Totales-Factura Procedure 
PROCEDURE proc_Graba-Totales-Factura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  /* Verificamos si existen items en el comprobante */
  FIND FIRST T-DDOCU OF T-CDOCU NO-LOCK NO-ERROR.
  IF NOT AVAILABLE T-DDOCU THEN DO:
      pMensaje = 'NO se ha grabado el detalle para la ' + T-CDOCU.coddoc + ' ' + T-CDOCU.nrodoc + CHR(10) +
          'Proceso Abortado'.
      RETURN 'ADM-ERROR'.
  END.

  /* Rutina General */
  {vtagn/i-total-factura.i &Cabecera="T-CDOCU" &Detalle="T-DDOCU"}

  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_Graba-Totales-Factura-SUNAT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Graba-Totales-Factura-SUNAT Procedure 
PROCEDURE proc_Graba-Totales-Factura-SUNAT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  /* Verificamos si existen items en el comprobante */
  FIND FIRST T-DDOCU OF T-CDOCU NO-LOCK NO-ERROR.
  IF NOT AVAILABLE T-DDOCU THEN DO:
      pMensaje = 'NO se ha grabado el detalle para la ' + T-CDOCU.coddoc + ' ' + T-CDOCU.nrodoc + CHR(10) +
          'Proceso Abortado'.
      RETURN 'ADM-ERROR'.
  END.

  /* Rutina General */
  {vtagn/i-total-factura-sunat.i &Cabecera="T-CDOCU" &Detalle="T-DDOCU"}

  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_IngCja) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_IngCja Procedure 
PROCEDURE proc_IngCja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER s-CodCja AS CHAR.               
    DEFINE INPUT PARAMETER s-CodTer AS CHAR.
    DEFINE INPUT PARAMETER s-SerCja AS INT.
    DEFINE INPUT PARAMETER s-Tipo AS CHAR.
    DEFINE OUTPUT PARAMETER para_nrodoccja LIKE CcbCCaja.NroDoc.
    DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    DEFINE VARIABLE x_NumDoc AS CHARACTER.

    /* FILTRO */
    IF s-CodCja <> "I/C" THEN DO:
        pMensaje = "El documento " + s-CodCja + " NO es un documento válido (debe ser I/C)".
        RETURN 'ADM-ERROR'.
    END.
    FIND FIRST Ccbdterm WHERE CcbDTerm.CodCia = s-CodCia AND 
        CcbDTerm.CodDiv = s-CodDiv AND
        CcbDTerm.CodDoc = s-CodCja AND
        CcbDTerm.CodTer = s-Codter AND
        CcbDTerm.NroSer = s-SerCja AND
        CAN-FIND(FIRST CcbCTerm OF CcbDTerm NO-LOCK)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE CcbDTerm THEN DO:
        pMensaje = "NO está configurado el documento " + s-CodCja + " en el terminal " + s-CodTer.
        RETURN 'ADM-ERROR'.
    END.

    trloop:
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        {lib\lock-genericov3.i &Tabla="FacCorre" ~
            &Alcance="FIRST"
            &Condicion="FacCorre.CodCia = s-codcia ~
            AND FacCorre.CodDiv = s-coddiv ~
            AND FacCorre.CodDoc = s-codcja ~
            AND FacCorre.NroSer = s-sercja" ~
            &Bloqueo="EXCLUSIVE-LOCK" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje" ~
            &TipoError="UNDO, RETURN 'ADM-ERROR'" }
        FIND FIRST T-CcbCCaja.
        /* Crea Cabecera de Caja */
        CREATE CcbCCaja.
        ASSIGN
            CcbCCaja.CodCia     = s-CodCia
            CcbCCaja.CodDiv     = s-CodDiv 
            CcbCCaja.CodDoc     = s-CodCja
            CcbCCaja.NroDoc     = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
            CcbCCaja.CodCaja    = s-CodTer
            CcbCCaja.usuario    = s-user-id
            CcbCCaja.CodCli     = B-CPEDM.codcli
            CcbCCaja.NomCli     = B-CPEDM.NomCli
            CcbCCaja.CodMon     = B-CPEDM.CodMon
            CcbCCaja.FchDoc     = TODAY
            CcbCCaja.CodBco[1]  = T-CcbCCaja.CodBco[1]
            CcbCCaja.CodBco[2]  = T-CcbCCaja.CodBco[2]
            CcbCCaja.CodBco[3]  = T-CcbCCaja.CodBco[3]
            CcbCCaja.CodBco[4]  = T-CcbCCaja.CodBco[4]
            CcbCCaja.CodBco[5]  = T-CcbCCaja.CodBco[5]
            CcbCCaja.CodBco[6]  = T-CcbCCaja.CodBco[6]
            CcbCCaja.CodBco[8]  = T-CcbCCaja.CodBco[8]
            CcbCCaja.ImpNac[1]  = T-CcbCCaja.ImpNac[1]
            CcbCCaja.ImpNac[2]  = T-CcbCCaja.ImpNac[2]
            CcbCCaja.ImpNac[3]  = T-CcbCCaja.ImpNac[3]
            CcbCCaja.ImpNac[4]  = T-CcbCCaja.ImpNac[4]
            CcbCCaja.ImpNac[5]  = T-CcbCCaja.ImpNac[5]
            CcbCCaja.ImpNac[6]  = T-CcbCCaja.ImpNac[6]
            CcbCCaja.ImpNac[7]  = T-CcbCCaja.ImpNac[7]            
            CcbCCaja.ImpNac[8]  = T-CcbCCaja.ImpNac[8]
            CcbCCaja.ImpNac[9]  = T-CcbCCaja.ImpNac[9]
            CcbCCaja.ImpNac[10] = T-CcbCCaja.ImpNac[10]
            CcbCCaja.ImpUsa[1]  = T-CcbCCaja.ImpUsa[1]
            CcbCCaja.ImpUsa[2]  = T-CcbCCaja.ImpUsa[2]
            CcbCCaja.ImpUsa[3]  = T-CcbCCaja.ImpUsa[3]
            CcbCCaja.ImpUsa[4]  = T-CcbCCaja.ImpUsa[4] 
            CcbCCaja.ImpUsa[5]  = T-CcbCCaja.ImpUsa[5]
            CcbCCaja.ImpUsa[6]  = T-CcbCCaja.ImpUsa[6]
            CcbCCaja.ImpUsa[7]  = T-CcbCCaja.ImpUsa[7]
            CcbCCaja.ImpUsa[8]  = T-CcbCCaja.ImpUsa[8]
            CcbCCaja.ImpUsa[9]  = T-CcbCCaja.ImpUsa[9]
            CcbCCaja.ImpUsa[10] = T-CcbCCaja.ImpUsa[10]
            CcbCCaja.Tipo       = s-Tipo
            CcbCCaja.TpoCmb     = T-CcbCCaja.TpoCmb
            CcbCCaja.Voucher[2] = T-CcbCCaja.Voucher[2]
            CcbCCaja.Voucher[3] = T-CcbCCaja.Voucher[3]
            CcbCCaja.Voucher[4] = T-CcbCCaja.Voucher[4] 
            CcbCCaja.Voucher[5] = T-CcbCCaja.Voucher[5] 
            CcbCCaja.Voucher[6] = T-CcbCCaja.Voucher[6]
            CcbCCaja.Voucher[7] = T-CcbCCaja.Voucher[7]
            CcbCCaja.Voucher[8] = T-CcbCCaja.Voucher[8]
            CcbCCaja.Voucher[9] = T-CcbCCaja.Voucher[9]
            CcbCCaja.Voucher[10] = T-CcbCCaja.Voucher[10]
            CcbCCaja.FchVto[2]  = T-CcbCCaja.FchVto[2]
            CcbCCaja.FchVto[3]  = T-CcbCCaja.FchVto[3]
            CcbCCaja.VueNac     = T-CcbCCaja.VueNac 
            CcbCCaja.VueUsa     = T-CcbCCaja.VueUsa
            CcbCCaja.FLGEST     = "C"
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "Revisar el correlativo del I/C".
            UNDO TRLOOP, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
        ASSIGN
            CcbCCaja.TarPtoNac = T-CcbCCaja.TarPtoNac
            CcbCCaja.TarPtoUsa = T-CcbCCaja.TarPtoUsa
            CcbCCaja.TarPtoBco = T-CcbCCaja.TarPtoBco 
            CcbCCaja.TarPtoNro = T-CcbCCaja.TarPtoNro 
            CcbCCaja.TarPtoTpo = T-CcbCCaja.TarPtoTpo.
        /* Crea Detalle de Caja */
        FOR EACH T-CDOCU BY T-CDOCU.NroDoc:
            CREATE CcbDCaja.
            ASSIGN
                CcbDCaja.CodCia = CcbCCaja.CodCia
                CcbdCaja.CodDiv = CcbCCaja.CodDiv
                CcbDCaja.CodDoc = CcbCCaja.CodDoc
                CcbDCaja.NroDoc = CcbCCaja.NroDoc
                CcbDCaja.CodRef = T-CDOCU.CodDoc
                CcbDCaja.NroRef = T-CDOCU.NroDoc
                CcbDCaja.CodCli = T-CDOCU.CodCli
                CcbDCaja.CodMon = T-CDOCU.CodMon
                CcbDCaja.FchDoc = CcbCCaja.FchDoc
                CcbDCaja.ImpTot = T-CDOCU.ImpTot
                CcbDCaja.TpoCmb = CcbCCaja.TpoCmb.
            ASSIGN
                T-CDOCU.FlgEst = "C"
                T-CDOCU.FchCan = TODAY
                T-CDOCU.SdoAct = 0.
        END.
        /* Cancelación por Cheque */
        IF T-CcbCCaja.Voucher[2] <> "" OR T-CcbCCaja.Voucher[3] <> "" THEN DO:
            IF T-CcbCCaja.Voucher[2] <> "" THEN x_NumDoc = T-CcbCCaja.Voucher[2].
            IF T-CcbCCaja.Voucher[3] <> "" THEN x_NumDoc = T-CcbCCaja.Voucher[3].       
            FIND CcbCDocu WHERE 
                CcbCDocu.CodCia = S-CodCia AND
                CcbCDocu.CodDiv = S-CodDiv AND
                CcbCDocu.CodDoc = "CHC" AND
                CcbCDocu.NroDoc = x_NumDoc
                EXCLUSIVE-LOCK NO-ERROR. 
            IF AVAILABLE CcbCDocu THEN
                ASSIGN
                    CcbCDocu.CodRef = CcbCCaja.CodDoc 
                    CcbCDocu.NroRef = CcbCCaja.NroDoc.               
        END.
        /* Captura Nro de Caja */
        para_nrodoccja = CcbCCaja.NroDoc.
    END.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_IngCja-SUNAT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_IngCja-SUNAT Procedure 
PROCEDURE proc_IngCja-SUNAT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER s-CodCja AS CHAR.               
    DEFINE INPUT PARAMETER s-CodTer AS CHAR.
    DEFINE INPUT PARAMETER s-SerCja AS INT.
    DEFINE INPUT PARAMETER s-Tipo AS CHAR.
    DEFINE OUTPUT PARAMETER para_nrodoccja LIKE CcbCCaja.NroDoc.
    DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    DEFINE VARIABLE x_NumDoc AS CHARACTER.

    /* FILTRO */
    IF s-CodCja <> "I/C" THEN DO:
        pMensaje = "El documento " + s-CodCja + " NO es un documento válido (debe ser I/C)".
        RETURN 'ADM-ERROR'.
    END.
    FIND FIRST Ccbdterm WHERE CcbDTerm.CodCia = s-CodCia AND 
        CcbDTerm.CodDiv = s-CodDiv AND
        CcbDTerm.CodDoc = s-CodCja AND
        CcbDTerm.CodTer = s-Codter AND
        CcbDTerm.NroSer = s-SerCja AND
        CAN-FIND(FIRST CcbCTerm OF CcbDTerm NO-LOCK)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE CcbDTerm THEN DO:
        pMensaje = "NO está configurado el documento " + s-CodCja + " en el terminal " + s-CodTer.
        RETURN 'ADM-ERROR'.
    END.

    trloop:
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        {lib\lock-genericov3.i &Tabla="FacCorre" ~
            &Alcance="FIRST"
            &Condicion="FacCorre.CodCia = s-codcia ~
            AND FacCorre.CodDiv = s-coddiv ~
            AND FacCorre.CodDoc = s-codcja ~
            AND FacCorre.NroSer = s-sercja" ~
            &Bloqueo="EXCLUSIVE-LOCK" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje" ~
            &TipoError="UNDO, RETURN 'ADM-ERROR'" }
        FIND FIRST T-CcbCCaja.
        /* Crea Cabecera de Caja */
        CREATE CcbCCaja.
        ASSIGN
            CcbCCaja.CodCia     = s-CodCia
            CcbCCaja.CodDiv     = s-CodDiv 
            CcbCCaja.CodDoc     = s-CodCja
            CcbCCaja.NroDoc     = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
            CcbCCaja.CodCaja    = s-CodTer
            CcbCCaja.usuario    = s-user-id
            CcbCCaja.CodCli     = B-CPEDM.codcli
            CcbCCaja.NomCli     = B-CPEDM.NomCli
            CcbCCaja.CodMon     = B-CPEDM.CodMon
            CcbCCaja.FchDoc     = TODAY
            CcbCCaja.CodBco[1]  = T-CcbCCaja.CodBco[1]
            CcbCCaja.CodBco[2]  = T-CcbCCaja.CodBco[2]
            CcbCCaja.CodBco[3]  = T-CcbCCaja.CodBco[3]
            CcbCCaja.CodBco[4]  = T-CcbCCaja.CodBco[4]
            CcbCCaja.CodBco[5]  = T-CcbCCaja.CodBco[5]
            CcbCCaja.CodBco[6]  = T-CcbCCaja.CodBco[6]
            CcbCCaja.CodBco[8]  = T-CcbCCaja.CodBco[8]
            CcbCCaja.ImpNac[1]  = T-CcbCCaja.ImpNac[1]
            CcbCCaja.ImpNac[2]  = T-CcbCCaja.ImpNac[2]
            CcbCCaja.ImpNac[3]  = T-CcbCCaja.ImpNac[3]
            CcbCCaja.ImpNac[4]  = T-CcbCCaja.ImpNac[4]
            CcbCCaja.ImpNac[5]  = T-CcbCCaja.ImpNac[5]
            CcbCCaja.ImpNac[6]  = T-CcbCCaja.ImpNac[6]
            CcbCCaja.ImpNac[7]  = T-CcbCCaja.ImpNac[7]            
            CcbCCaja.ImpNac[8]  = T-CcbCCaja.ImpNac[8]
            CcbCCaja.ImpNac[9]  = T-CcbCCaja.ImpNac[9]
            CcbCCaja.ImpNac[10] = T-CcbCCaja.ImpNac[10]
            CcbCCaja.ImpUsa[1]  = T-CcbCCaja.ImpUsa[1]
            CcbCCaja.ImpUsa[2]  = T-CcbCCaja.ImpUsa[2]
            CcbCCaja.ImpUsa[3]  = T-CcbCCaja.ImpUsa[3]
            CcbCCaja.ImpUsa[4]  = T-CcbCCaja.ImpUsa[4] 
            CcbCCaja.ImpUsa[5]  = T-CcbCCaja.ImpUsa[5]
            CcbCCaja.ImpUsa[6]  = T-CcbCCaja.ImpUsa[6]
            CcbCCaja.ImpUsa[7]  = T-CcbCCaja.ImpUsa[7]
            CcbCCaja.ImpUsa[8]  = T-CcbCCaja.ImpUsa[8]
            CcbCCaja.ImpUsa[9]  = T-CcbCCaja.ImpUsa[9]
            CcbCCaja.ImpUsa[10] = T-CcbCCaja.ImpUsa[10]
            CcbCCaja.Tipo       = s-Tipo
            CcbCCaja.TpoCmb     = T-CcbCCaja.TpoCmb
            CcbCCaja.Voucher[2] = T-CcbCCaja.Voucher[2]
            CcbCCaja.Voucher[3] = T-CcbCCaja.Voucher[3]
            CcbCCaja.Voucher[4] = T-CcbCCaja.Voucher[4] 
            CcbCCaja.Voucher[5] = T-CcbCCaja.Voucher[5] 
            CcbCCaja.Voucher[6] = T-CcbCCaja.Voucher[6]
            CcbCCaja.Voucher[7] = T-CcbCCaja.Voucher[7]
            CcbCCaja.Voucher[8] = T-CcbCCaja.Voucher[8]
            CcbCCaja.Voucher[9] = T-CcbCCaja.Voucher[9]
            CcbCCaja.Voucher[10] = T-CcbCCaja.Voucher[10]
            CcbCCaja.FchVto[2]  = T-CcbCCaja.FchVto[2]
            CcbCCaja.FchVto[3]  = T-CcbCCaja.FchVto[3]
            CcbCCaja.VueNac     = T-CcbCCaja.VueNac 
            CcbCCaja.VueUsa     = T-CcbCCaja.VueUsa
            CcbCCaja.FLGEST     = "C"
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "Revisar el correlativo del I/C".
            UNDO TRLOOP, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
        ASSIGN
            CcbCCaja.TarPtoNac = T-CcbCCaja.TarPtoNac
            CcbCCaja.TarPtoUsa = T-CcbCCaja.TarPtoUsa
            CcbCCaja.TarPtoBco = T-CcbCCaja.TarPtoBco 
            CcbCCaja.TarPtoNro = T-CcbCCaja.TarPtoNro 
            CcbCCaja.TarPtoTpo = T-CcbCCaja.TarPtoTpo.
        /* Crea Detalle de Caja */
        FOR EACH T-CDOCU EXCLUSIVE-LOCK, FIRST Ccbcdocu OF T-CDOCU EXCLUSIVE-LOCK BY T-CDOCU.NroDoc:
            CREATE CcbDCaja.
            ASSIGN
                CcbDCaja.CodCia = CcbCCaja.CodCia
                CcbdCaja.CodDiv = CcbCCaja.CodDiv
                CcbDCaja.CodDoc = CcbCCaja.CodDoc
                CcbDCaja.NroDoc = CcbCCaja.NroDoc
                CcbDCaja.CodRef = T-CDOCU.CodDoc
                CcbDCaja.NroRef = T-CDOCU.NroDoc
                CcbDCaja.CodCli = T-CDOCU.CodCli
                CcbDCaja.CodMon = T-CDOCU.CodMon
                CcbDCaja.FchDoc = CcbCCaja.FchDoc
                CcbDCaja.ImpTot = Ccbcdocu.ImpTot
                CcbDCaja.TpoCmb = CcbCCaja.TpoCmb.
            ASSIGN
                T-CDOCU.FlgEst = "C"
                T-CDOCU.FchCan = TODAY
                T-CDOCU.SdoAct = 0.
            ASSIGN
                Ccbcdocu.FlgEst = "C"
                Ccbcdocu.FchCan = TODAY
                Ccbcdocu.SdoAct = 0
                .
        END.
        /* Cancelación por Cheque */
        IF T-CcbCCaja.Voucher[2] <> "" OR T-CcbCCaja.Voucher[3] <> "" THEN DO:
            IF T-CcbCCaja.Voucher[2] <> "" THEN x_NumDoc = T-CcbCCaja.Voucher[2].
            IF T-CcbCCaja.Voucher[3] <> "" THEN x_NumDoc = T-CcbCCaja.Voucher[3].       
            FIND CcbCDocu WHERE 
                CcbCDocu.CodCia = S-CodCia AND
                CcbCDocu.CodDiv = S-CodDiv AND
                CcbCDocu.CodDoc = "CHC" AND
                CcbCDocu.NroDoc = x_NumDoc
                EXCLUSIVE-LOCK NO-ERROR. 
            IF AVAILABLE CcbCDocu THEN
                ASSIGN
                    CcbCDocu.CodRef = CcbCCaja.CodDoc 
                    CcbCDocu.NroRef = CcbCCaja.NroDoc.               
        END.
        /* Captura Nro de Caja */
        para_nrodoccja = CcbCCaja.NroDoc.
    END.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

