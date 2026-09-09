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

DEFINE INPUT PARAMETER rwParaRowID AS ROWID.
DEFINE INPUT PARAMETER pTipoGuia   AS CHAR.
DEFINE INPUT PARAMETER pOrigen AS CHAR.
DEFINE INPUT PARAMETER pCodTer AS CHAR.
DEFINE INPUT PARAMETER pSerie AS CHAR.
DEFINE OUTPUT PARAMETER pNroCmpteGenerado   AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pRetval   AS CHAR NO-UNDO.

/* pTipoGuia
    A: automática
    M: manual
    FA: FAI automático
    FM: FAI manual
*/

/* pOrigen
    MOSTRADOR: Solo emisión de Factura
      CREDITO: Factura y Guias de Remisión
*/

DEFINE SHARED VARIABLE s-CodCia AS INTEGER.
DEFINE SHARED VARIABLE s-NomCia AS CHARACTER.
DEFINE SHARED VARIABLE s-CodDiv AS CHARACTER.
DEFINE SHARED VARIABLE s-User-Id AS CHARACTER.
DEFINE SHARED VARIABLE cl-codcia AS INTEGER.
DEFINE SHARED VARIABLE pv-codcia AS INTEGER.

DEFINE VARIABLE cCodDoc AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodAlm AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodMov AS INTEGER NO-UNDO.
DEFINE VARIABLE iCountGuide AS INTEGER NO-UNDO.
DEFINE VARIABLE cObser  AS CHARACTER   NO-UNDO.

FIND FacCPedi WHERE ROWID(FacCPedi) = rwParaRowID NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCPedi THEN DO:
    pRetval = "Registro de O/D no disponible".
    RETURN ERROR.
END.
IF NOT (FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = 'C') THEN DO:
    pRetval = "Registro de O/D ya no está 'PENDIENTE'".
    RETURN ERROR.
END.
ASSIGN
    cCodAlm = FacCPedi.Codalm       /* <<< OJO <<< */
    cObser  = FacCPedi.Glosa
    cCodDoc = FacCPedi.Cmpbnte.     /* <<< OJO <<< */
/* Consistencia del tipo de guia */
CASE TRUE:
    WHEN pTipoGuia = "FM" THEN ASSIGN cCodDoc = "FAI" pTipoGuia = "M".
    WHEN pTipoGuia = "FA" THEN ASSIGN cCodDoc = "FAI" pTipoGuia = "A".
END CASE.
IF LOOKUP(cCodDoc, 'FAC,BOL,FAI') = 0 THEN DO:
    pRetval = "Tipo de comprobante a generar debe ser FAC,BOL,FAI, se envio(" + cCodDoc + ")".
    RETURN ERROR.
END.
    
FIND FacDocum WHERE FacDocum.CodCia = s-CodCia 
    AND FacDocum.CodDoc = cCodDoc 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum OR FacDocum.CodMov = 0 THEN DO:
    pRetval = "Codigo de Documento " + cCodDoc + " no existe en la maestra FACDOCUM".
    RETURN ERROR.
END.
cCodMov = FacDocum.CodMov.

DEF VAR cOk AS LOG NO-UNDO.
cOk = NO.
FOR EACH FacCorre NO-LOCK WHERE 
    FacCorre.CodCia = s-CodCia AND
    FacCorre.CodDiv = s-CodDiv AND 
    FacCorre.CodDoc = cCodDoc AND
    FacCorre.ID_Pos = pOrigen AND
    FacCorre.FlgEst = YES:
    IF pOrigen = "CREDITO" THEN DO:
        /* SOLO ACEPTA LOS QUE NO ESTEN ASIGNADOS A UNA CAJA COBRANZA */
        FIND CcbDTerm WHERE CcbDTerm.CodCia = s-codcia
            AND CcbDTerm.CodDiv = s-coddiv
            AND CcbDTerm.CodDoc = cCodDoc
            AND CcbDTerm.NroSer = FacCorre.NroSer
            NO-LOCK NO-ERROR.
        IF AVAILABLE CcbDTerm THEN DO:
            /* Verificamos la cabecera */
            FIND FIRST CcbCTerm OF CcbDTerm NO-LOCK NO-ERROR.
            IF AVAILABLE CcbCTerm THEN NEXT.
        END.
        cOk = YES.
    END.
    ELSE cOk = YES.
END.
IF cOk = NO THEN DO:
    pRetVal = "Código de Documento " + cCodDoc + " no configurado " + CHR(10) +
        "division " + s-CodDiv  + CHR(10) +
        "Origen(MOSTRADOR/CREDITO) " + pOrigen.
    RETURN ERROR.
END.


/* GRE */
DEFINE VAR lGRE_ONLINE AS LOG.

RUN gn/gre-online.r(OUTPUT lGRE_ONLINE).

IF lGRE_ONLINE = NO THEN DO:
    pRetval = "No esta ACTIVO la Guia de Remision Electronica".
    RETURN ERROR.
END.

IF pOrigen = "CREDITO" AND lGRE_ONLINE = NO THEN DO:    /* GRE */
    FIND FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia 
        AND FacCorre.CodDiv = s-CodDiv 
        AND FacCorre.CodDoc = "G/R"
        AND FacCorre.FlgEst = YES
        /*AND NOT (FacCorre.Tipmov = "S" AND FacCorre.Codmov <> 00)*/
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCorre THEN DO:        
        pRetVal = "Correlativo del Documento G/R NO configurado".
        pOrigen = "MOSTRADOR".  /* Artificio para NO generar Guias de Remisión */
        RETURN ERROR.
    END.
END.

/* TEMPORALES */
DEFINE TEMP-TABLE Reporte NO-UNDO
    FIELD CodCia LIKE CcbCDocu.CodCia
    FIELD CodDiv LIKE CcbCDOcu.CodDiv 
    FIELD CodDoc LIKE CcbCDocu.CodDoc
    FIELD NroDoc LIKE CcbCDocu.Nrodoc
    INDEX Llave01 codcia coddiv coddoc nrodoc.

DEFINE TEMP-TABLE t-FELogErrores LIKE FELogErrores.
DEFINE TEMP-TABLE PEDI LIKE facdpedi.
DEFINE TEMP-TABLE ITEM LIKE facdpedi.
DEF TEMP-TABLE T-CDOCU LIKE Ccbcdocu.
DEF TEMP-TABLE T-DDOCU LIKE Ccbddocu.


/* BUFFERs */
DEF BUFFER B-CDOCU FOR Ccbcdocu.
DEF BUFFER B-DDOCU FOR Ccbddocu.
DEFINE BUFFER b-gre_cmpte FOR gre_cmpte.
DEFINE BUFFER PEDIDO FOR faccpedi.
DEFINE BUFFER COTIZACION FOR faccpedi.
DEFINE BUFFER B-ADOCU FOR CCBADOCU.

DEF BUFFER x-faccpedi FOR faccpedi.

/* -------------------------------------------------------------- */
DEF VAR s-FechaI AS DATETIME NO-UNDO.
DEF VAR s-FechaT AS DATETIME NO-UNDO.

s-FechaI = DATETIME(TODAY, MTIME).

/* Ic - 28Ene2016, Para factura ValesUtilex */
DEFINE VAR pEsValesUtilex AS LOG INIT NO.

/* Ic - 01Mar2016, para ListaExpress */
DEF NEW SHARED VAR s-codcja AS CHAR INITIAL "I/C".
DEF NEW SHARED VAR s-sercja AS INT.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-FormatoFAC  AS CHAR INIT '999-99999999' NO-UNDO.
DEF VAR x-FormatoGUIA AS CHAR INIT '999-999999' NO-UNDO.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
RUN sunat\p-formato-doc (INPUT cCodDoc, OUTPUT x-FormatoFAC).
RUN sunat\p-formato-doc (INPUT "G/R", OUTPUT x-FormatoGUIA).

/*DEF VAR pMensaje AS CHAR NO-UNDO.*/
DEF VAR pMensaje-2 AS CHAR NO-UNDO.

/* Ic - 01Feb2017, es serie comprobante DIFERIDO */
DEFINE VAR pEsSerieDiferido AS LOG INIT NO.

/* ----------------------------------------------------------------- */
DEFINE TEMP-TABLE T-CcbADocu LIKE CcbADocu.

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

DEFINE VAR FILL-IN-LugEnt AS CHAR.
DEFINE VAR FILL-IN-items AS INT.
DEFINE VAR FILL-IN-Glosa AS CHAR.
DEFINE VAR COMBO-NroSer AS CHAR.
DEFINE VAR toggle-genera-pgre AS LOG.
DEFINE VAR iCantidadItems AS INT.

DEFINE VAR hProc AS HANDLE NO-UNDO.           /* Handle Libreria */
DEFINE VAR x-DeliveryGroup AS CHAR.
DEFINE VAR x-InvoiCustomerGroup AS CHAR.

RUN debe-generar-gre(OUTPUT toggle-genera-pgre).

RUN logis\logis-librerias.r PERSISTENT SET hProc.

/* Ic - 26Jul2023 - VALIDACIONES  */
FOR EACH FacDPedi OF FacCPedi NO-LOCK:
    iCantidadItems = iCantidadItems + 1.
END.
IF iCantidadItems = 0 THEN DO:
    pRetval = "No hay items por despachar".
    RETURN.
END.

/* Empresas NO requiere G/R */
IF pOrigen = "CREDITO" THEN DO:
   IF FacCPedi.CodCli = "20100047218" THEN DO:
       IF cCodDoc <> "FAI" THEN DO:
           pRetval = "Para el BCP solo se emiten FAI, consulte con COMERCIAL".
           RETURN "ADM-ERROR".
       END.

       RUN Grupo-reparto IN hProc (INPUT Faccpedi.codref, INPUT Faccpedi.nroref, /* PED */
                                 OUTPUT x-DeliveryGroup, OUTPUT x-InvoiCustomerGroup).     
       DELETE PROCEDURE hProc.

       IF NOT (TRUE <> (x-DeliveryGroup > "")) THEN DO:
           /* Con Grupo de Reparto */
           IF cCodDoc = "FAI" AND toggle-genera-pgre = YES THEN DO:
               pRetval = "La O/D pertence a pedido PLANIFICADO, la FAI debe generarse sin G/R".
               RETURN "ADM-ERROR".
           END.
       END.

   END.
END.

/* */
COMBO-NroSer = pSerie.

/* Rutina Lugar de Entrega */
RUN logis/p-lugar-de-entrega (INPUT Faccpedi.CodDoc,
                            INPUT Faccpedi.NroPed,
                            OUTPUT FILL-IN-LugEnt).
IF NUM-ENTRIES(FILL-IN-LugEnt, '|') > 1 THEN FILL-IN-LugEnt = ENTRY(2, FILL-IN-LugEnt, '|').

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.

FILL-IN-Glosa = FacCPedi.Glosa.

CASE cCodDoc:
  WHEN "FAC" THEN ASSIGN FILL-IN-items = FacCfgGn.Items_Factura.
  WHEN "BOL" THEN ASSIGN FILL-IN-items = FacCfgGn.Items_Boleta.
  WHEN "FAI" THEN ASSIGN FILL-IN-items = FacCfgGn.Items_Boleta.
END CASE.
RUN sunat\p-nro-items (cCodDoc, INTEGER(COMBO-NroSer), OUTPUT FILL-IN-items).
RUN sunat\p-formato-doc (INPUT cCodDoc, OUTPUT x-FormatoFAC).

/* CORRELATIVO DE GUIAS DE REMISION */
IF lGRE_ONLINE = NO THEN DO:    /* G/R Fisica */
    /* No COMTEMPLADO */
END.
      
/* RHC Cargamos TRANSPORTISTA por defecto */
EMPTY TEMP-TABLE T-CcbADocu.
FIND Ccbadocu WHERE Ccbadocu.codcia = Faccpedi.codcia
      AND Ccbadocu.coddiv = Faccpedi.coddiv
      AND Ccbadocu.coddoc = Faccpedi.coddoc
      AND Ccbadocu.nrodoc = Faccpedi.nroped
      NO-LOCK NO-ERROR.
IF AVAILABLE CcbADocu THEN DO:
  CREATE T-CcbADocu.
  BUFFER-COPY CcbADocu TO T-CcbADocu
      ASSIGN
      T-CcbADocu.CodDiv = CcbADocu.CodDiv
      T-CcbADocu.CodDoc = CcbADocu.CodDoc
      T-CcbADocu.NroDoc = CcbADocu.NroDoc.
  RELEASE T-CcbADocu.
END.      

/* UN SOLO PROCESO */
RUN MASTER-TRANSACTION.

RETURN RETURN-VALUE.

/*IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Aplicacion-de-Adelantos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aplicacion-de-Adelantos Procedure 
PROCEDURE Aplicacion-de-Adelantos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF FacCPedi.TpoLic = NO THEN RETURN "OK".
IF LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL') = 0 THEN RETURN "OK".
RUN vtagn/p-aplica-factura-adelantada.r(ROWID(Ccbcdocu)).

RETURN 'OK'.

/*
/* RHC 09/02/17 OBSERVADO POR SUSANA LEON */
IF Ccbcdocu.FlgEst = "C" THEN RETURN "OK".

DEF VAR x-Saldo-Actual AS DEC NO-UNDO.
DEF VAR x-Monto-Aplicar AS DEC NO-UNDO.
DEF VAR x-TpoCmb-Compra AS DEC INIT 1 NO-UNDO.
DEF VAR x-TpoCmb-Venta  AS DEC INIT 1 NO-UNDO.

pMensaje = ''.
RLOOP:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    /* Aplicamos los anticipos que encontremos por fecha */
    ASSIGN
        x-Saldo-Actual = Ccbcdocu.ImpTot
        x-Monto-Aplicar = 0.
    ASSIGN
        x-TpoCmb-Compra = 1
        x-TpoCmb-Venta  = 1.
    FIND LAST gn-tcmb WHERE gn-tcmb.Fecha <= TODAY NO-LOCK NO-ERROR.
    IF AVAILABLE gn-tcmb
        THEN ASSIGN
                x-TpoCmb-Compra = gn-tcmb.Compra
                x-TpoCmb-Venta  = gn-tcmb.Venta.
    /* Buscamos saldos de anticipos pendientes de aplicar */
    FOR EACH ANTICIPOS EXCLUSIVE-LOCK WHERE ANTICIPOS.codcia = Ccbcdocu.codcia
        AND ANTICIPOS.coddoc = "A/C"
        AND ANTICIPOS.codcli = Ccbcdocu.codcli
        AND ANTICIPOS.flgest = "P"
        AND ANTICIPOS.sdoact > 0
        AND ANTICIPOS.pordto > 0
        BY ANTICIPOS.FchDoc:
        IF Ccbcdocu.CodMon = ANTICIPOS.CodMon 
            THEN x-Monto-Aplicar = MINIMUM(x-Saldo-Actual,ANTICIPOS.SdoAct).
            ELSE IF Ccbcdocu.CodMon = 1 
                THEN x-Monto-Aplicar  = ROUND(MINIMUM(ANTICIPOS.SdoAct * x-TpoCmb-Compra, x-Saldo-Actual),2).
            ELSE x-Monto-Aplicar  = ROUND(MINIMUM(ANTICIPOS.SdoAct / x-TpoCmb-Venta , x-Saldo-Actual),2).
        IF x-Monto-Aplicar <= 0 THEN LEAVE.
        RUN Genera-NC (
            "00014",        /* Aplicación Anticipo de Campaña */
            x-Monto-Aplicar,
            "ADELANTO",
            x-TpoCmb-Compra,
            x-TpoCmb-Venta,
            OUTPUT pMensaje
            ).
        IF RETURN-VALUE = "ADM-ERROR" THEN DO:
            IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudieron generar las N/C x Aplicación de Anticipos".
            UNDO RLOOP, LEAVE RLOOP.
        END.
        RUN Genera-NC (
            "00001",        /* Descuento pronto pago */
            ROUND(x-Monto-Aplicar * ANTICIPOS.PorDto / 100, 2),
            "DESCUENTO",
            x-TpoCmb-Compra,
            x-TpoCmb-Venta,
            OUTPUT pMensaje
            ).
        IF RETURN-VALUE = "ADM-ERROR" THEN DO:
            IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudieron generar las N/C x Descuento de Anticipos".
            UNDO RLOOP, LEAVE RLOOP.
        END.
        x-Saldo-Actual = x-Saldo-Actual - x-Monto-Aplicar.
        IF x-Saldo-Actual <= 0 THEN LEAVE.
    END.
END.
IF AVAILABLE(ANTICIPOS) THEN RELEASE ANTICIPOS.
IF pMensaje > '' THEN RETURN 'ADM-ERROR'.
ELSE RETURN 'OK'.

*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-carga-inicial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-inicial Procedure 
PROCEDURE carga-inicial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


  EMPTY TEMP-TABLE ITEM.

  IF pTipoGuia = "A" THEN DO:
      FOR EACH facdpedi OF faccpedi NO-LOCK WHERE (facdpedi.canped - facdpedi.canate) > 0 BY Facdpedi.NroItm:
          CREATE ITEM.
          BUFFER-COPY facdpedi TO ITEM
              ASSIGN
                ITEM.canped = facdpedi.canped - facdpedi.canate
                ITEM.canate = facdpedi.canped - facdpedi.canate.
      END.
  END.
  ELSE DO:
      FOR EACH PEDI WHERE PEDI.CanAte > 0:
          CREATE ITEM.
          BUFFER-COPY PEDI TO ITEM.
      END.
  END.

/*
  /* Solo para el pintado inicial de la pantalla */
  EMPTY TEMP-TABLE PEDI.
  FOR EACH ITEM:
      CREATE PEDI.
      BUFFER-COPY ITEM TO PEDI.
  END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-carga-temporal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal Procedure 
PROCEDURE carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 EMPTY TEMP-TABLE PEDI.
 DEF VAR iCountItem AS INT INIT 0 NO-UNDO.

  FOR EACH ITEM BY ITEM.NroItm:
      CREATE PEDI.
      BUFFER-COPY ITEM TO PEDI.
      iCountItem = iCountItem + 1.
      IF iCountItem >= FILL-IN-items THEN LEAVE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Crea-Comprobantes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Comprobantes Procedure 
PROCEDURE Crea-Comprobantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iCountItem AS INTEGER INITIAL 1 NO-UNDO.

    ASSIGN
        iCountGuide = 1.
        /*pMensaje = "".*/
    EMPTY TEMP-TABLE T-CDOCU.
    EMPTY TEMP-TABLE T-DDOCU.


    pRetVal = "Procesando CREA-COMPROBANTES".

    RLOOP02:
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        /* Correlativo */
        {lib\lock-genericov3.i ~
            &Tabla="FacCorre" ~
            &Condicion="FacCorre.CodCia = s-CodCia ~
            AND FacCorre.CodDiv = s-CodDiv ~
            AND FacCorre.CodDoc = cCodDoc ~
            AND FacCorre.NroSer = INTEGER(COMBO-NroSer)" ~
            &Bloqueo= "EXCLUSIVE-LOCK" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &tMensaje="pRetVal" ~
            &TipoError="UNDO RLOOP02, RETURN 'ADM-ERROR'" ~
            }
        /* Cabecera de Guía */
        RUN proc_CreaCabecera.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP02, RETURN 'ADM-ERROR'.

        /* Detalle */
        FOR EACH PEDI, FIRST ITEM WHERE ITEM.CodMat = PEDI.CodMat,
            FIRST Almmmatg OF PEDI NO-LOCK
            BREAK BY PEDI.CodCia BY PEDI.Libre_c05 BY PEDI.Libre_c04 BY PEDI.CodMat:
            CREATE T-DDOCU.
            BUFFER-COPY PEDI TO T-DDOCU.
            ASSIGN
                T-DDOCU.NroItm = iCountItem
                T-DDOCU.CodCia = T-CDOCU.CodCia
                T-DDOCU.CodDiv = T-CDOCU.CodDiv
                T-DDOCU.Coddoc = T-CDOCU.Coddoc
                T-DDOCU.NroDoc = T-CDOCU.NroDoc 
                T-DDOCU.FchDoc = T-CDOCU.FchDoc
                T-DDOCU.CanDes = PEDI.CanAte
                T-DDOCU.impdcto_adelanto[4] = PEDI.Libre_d02.  /* Flete Unitario */
            ASSIGN
                T-DDOCU.Pesmat = Almmmatg.Pesmat * (T-DDOCU.Candes * T-DDOCU.Factor).

            {sunat/sunat-calculo-importes-sku.i &Cabecera="T-CDOCU" &Detalle="T-DDOCU"}

            /* Actualiza Detalle de la Orden de Despacho */
            FIND FIRST Facdpedi WHERE Facdpedi.codcia = ITEM.codcia
                AND Facdpedi.coddiv = ITEM.coddiv
                AND Facdpedi.coddoc = ITEM.coddoc
                AND Facdpedi.nroped = ITEM.nroped
                AND Facdpedi.codmat = ITEM.codmat
                AND Facdpedi.libre_c05 = ITEM.libre_c05    /* Campo de control adicional */
                EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            /* En caso de Lista Express puede que no este registrado el producto */
            IF NOT AVAILABLE Facdpedi THEN DO:
                pRetVal = 'NO se pudo bloquear el código ' + PEDI.codmat + ' de la O/D'.
                UNDO RLOOP02, RETURN 'ADM-ERROR'.
            END.
            ASSIGN
                Facdpedi.canate = Facdpedi.canate + PEDI.canate.
            iCountItem = iCountItem + 1.
            /* LLEVAMOS EL SALDO EN EL ARCHIVO DE CONTROL */
            DELETE ITEM.
        END. /* FOR EACH FacDPedi... */
/*         IF COTIZACION.TpoPed = "LF" THEN DO:   /* LISTA EXPRESS */                       */
/*             FOR EACH PEDI, FIRST ITEM WHERE ITEM.CodMat = PEDI.CodMat,                   */
/*                 FIRST Almmmatg OF PEDI NO-LOCK /*,                                       */
/*                 FIRST Almmmate NO-LOCK WHERE Almmmate.CodCia = s-CodCia                  */
/*                     AND Almmmate.CodAlm = PEDI.AlmDes                                    */
/*                     AND Almmmate.CodMat = PEDI.CodMat */                                 */
/*                 BREAK BY PEDI.CodCia BY PEDI.NroItm:                                     */
/*                                                                                          */
/*                 {sunat\igeneracionfactcredito-v4.i}                                      */
/*                                                                                          */
/*             END. /* FOR EACH FacDPedi... */                                              */
/*         END.                                                                             */
/*         ELSE DO:                                                                         */
/*             FOR EACH PEDI, FIRST ITEM WHERE ITEM.CodMat = PEDI.CodMat,                   */
/*                 FIRST Almmmatg OF PEDI NO-LOCK /*,                                       */
/*                 FIRST Almmmate NO-LOCK WHERE Almmmate.CodCia = s-CodCia                  */
/*                     AND Almmmate.CodAlm = PEDI.AlmDes                                    */
/*                     AND Almmmate.CodMat = PEDI.CodMat*/                                  */
/*                 BREAK BY PEDI.CodCia BY PEDI.Libre_c05 BY PEDI.Libre_c04 BY PEDI.CodMat: */
/*                                                                                          */
/*                 {sunat\igeneracionfactcredito-v4.i}                                      */
/*                                                                                          */
/*             END. /* FOR EACH FacDPedi... */                                              */
/*         END.                                                                             */
        RUN proc_GrabaTotales.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP02, RETURN 'ADM-ERROR'.

        /* EN CASO DE CERRAR LAS FACTURAS APLICAMOS EL REDONDEO */
        IF Faccpedi.Importe[2] <> 0 THEN DO:
            /* NOS ASEGURAMOS QUE SEA EL ULTIMO REGISTRO */
            IF NOT CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0
                            NO-LOCK) THEN DO:
                ASSIGN 
                    T-CDOCU.ImpTot = T-CDOCU.ImpTot + Faccpedi.Importe[2]
                    T-CDOCU.Libre_d02 = Faccpedi.Importe[2]
                    T-CDOCU.ImpVta = ROUND ( (T-CDOCU.ImpTot - T-CDOCU.AcuBon[5])/ ( 1 + T-CDOCU.PorIgv / 100 ) , 2)
                    T-CDOCU.ImpIgv = (T-CDOCU.ImpTot - T-CDOCU.AcuBon[5]) - T-CDOCU.ImpVta
                    T-CDOCU.ImpBrt = T-CDOCU.ImpVta + T-CDOCU.ImpDto + T-CDOCU.ImpExo
                    T-CDOCU.SdoAct = T-CDOCU.ImpTot.
            END.
        END.
        /* FIN DE REDONDEO */
    END.

    pRetVal = "OK".

    RETURN 'OK'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-debe-generar-gre) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE debe-generar-gre Procedure 
PROCEDURE debe-generar-gre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pGenerarGRE AS LOG NO-UNDO.

DEFINE VAR cNroPedidoComercial AS CHAR.
   
IF cCodDoc = "FAI" THEN DO:
    /*
    /* FAI no genera GRE */
    pGenerarGRE = NO.
    RETURN.
    */
END.

pGenerarGRE = YES.

FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = faccpedi.codcia AND 
                          x-faccpedi.coddiv = faccpedi.coddiv AND   /* la division de la O/D */
                          x-faccpedi.coddoc = 'PED' AND 
                          x-faccpedi.nroped = faccpedi.nroref NO-LOCK NO-ERROR.
IF AVAILABLE x-faccpedi THEN DO:
    /* Ic - 13Jul2023, Cliente Recoje/Tramite documentario NO genera GRE */
    IF x-faccpedi.cliente_recoge = YES OR x-faccpedi.TipVta = 'si' THEN DO:
        pGenerarGRE = NO.
    END.
    ELSE DO:
        /* Buscamos la Cotizacion */
        cNroPedidoComercial = x-faccpedi.nroref.
        FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = faccpedi.codcia AND 
                                  x-faccpedi.coddiv = faccpedi.coddiv AND   /* la division de la O/D */
                                  x-faccpedi.coddoc = 'COT' AND 
                                  x-faccpedi.nroped = cNroPedidoComercial NO-LOCK NO-ERROR.
        IF AVAILABLE x-faccpedi THEN DO:
            /* Ic - 28Ene2016 - Para O/D - Vales Utilex no generar Guia */
            IF x-faccpedi.tpoped = 'VU' THEN DO:
                pGenerarGRE = NO.
            END.
        END.
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Facturas-Adelantadas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Facturas-Adelantadas Procedure 
PROCEDURE Facturas-Adelantadas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Control de Facturas Adelantadas */
  DEFINE VARIABLE x-saldo-mn AS DEC NO-UNDO.
  DEFINE VARIABLE x-saldo-me AS DEC NO-UNDO.

  ASSIGN
      x-saldo-mn = 0
      x-saldo-me = 0.
  FOR EACH Ccbcdocu USE-INDEX Llave06 NO-LOCK WHERE Ccbcdocu.codcia = Faccpedi.codcia
      AND Ccbcdocu.codcli = Faccpedi.CodCli
      AND Ccbcdocu.flgest = "P"
      AND Ccbcdocu.coddoc = "A/C":
      IF Ccbcdocu.CodMon = 1 THEN x-saldo-mn = x-saldo-mn + Ccbcdocu.SdoAct.
      ELSE x-saldo-me = x-saldo-me + Ccbcdocu.SdoAct.
  END.
  IF x-saldo-mn > 0 OR x-saldo-me > 0 THEN DO:
      /*
      MESSAGE 'Hay un SALDO de Factura(s) Adelantada(s) por aplicar' SKIP
          'Por aplicar NUEVOS SOLES:' x-saldo-mn SKIP
          'Por aplicar DOLARES:' x-saldo-me SKIP
          'AVISAR AL AREA DE VENTAS' VIEW-AS ALERT-BOX WARNING.
    */
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-FIRST-TRANSACTION) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FIRST-TRANSACTION Procedure 
PROCEDURE FIRST-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RLOOP01:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* 1ro. Generamos las TEMPORALES PARA FAC/BOL */
    RUN Crea-Comprobantes.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pRetval = "" THEN pRetVal = "NO se pudo crear el Comprobante Temporal".
        UNDO RLOOP01, RETURN "ADM-ERROR".
    END.
    
    /* 2do. GRABACION DE LOS COMPROBANTES: ACTUALIZA ALMACENES */
    RUN Graba-Comprobantes.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pRetval = "" THEN pRetval = "NO se pudo crear el Comprobante".
        UNDO RLOOP01, RETURN 'ADM-ERROR'.
    END.
    
    /* 3ro. PARTE: CANCELACION AUTOMATICA LISTA EXPRESS */
/*     RUN Generacion-Canc-Auto.                                                                          */
/*     IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                                             */
/*         IF pMensaje = "" THEN pMensaje = "NO se pudo generar la Cancelación Automática Lista Express". */
/*         UNDO RLOOP, RETURN 'ADM-ERROR'.                                                                */
/*     END.                                                                                               */
    /* 3ro. Generacion de G/R */
    RUN Generacion-de-GR.
    
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pRetval = "" THEN pRetVal = "NO se pudo generar la G/R".
        UNDO RLOOP01, RETURN 'ADM-ERROR'.
    END.

END.
RETURN 'OK'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generacion-de-GR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generacion-de-GR Procedure 
PROCEDURE generacion-de-GR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iCountItem AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE lCreaHeader AS LOGICAL NO-UNDO.

    DEF VAR pCodDpto AS CHAR NO-UNDO.
    DEF VAR pCodProv AS CHAR NO-UNDO.
    DEF VAR pCodDist AS CHAR NO-UNDO.
    DEF VAR pZona    AS CHAR NO-UNDO.
    DEF VAR pSubZona AS CHAR NO-UNDO.
    DEF VAR pCodPos  AS CHAR NO-UNDO.

    /*IF NOT (pEsValesUtilex = NO AND COMBO-BOX-Guias = "SI") THEN RETURN "OK".  */

    IF NOT (pEsValesUtilex = NO AND toggle-genera-pgre = YES) THEN RETURN "OK".

    RETURN "OK".    /* GRE no genera Guia Fisica */
/*
    FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.

    /* **************************************************************************** */
    /* 04/07/2022 Registros por cada GR */
    /* **************************************************************************** */
    DEF VAR x-Items_Guias AS INTE NO-UNDO.

    x-Items_Guias = FacCfgGn.Items_Guias.       /* Valor por defecto */
    FIND FIRST FacTabla WHERE FacTabla.codcia = s-codcia AND
        FacTabla.tabla = 'CFG_FMT_GR' AND
        FacTabla.codigo = s-coddiv 
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacTabla AND FacTabla.Campo-C[1] > '' THEN DO:
        ASSIGN x-Items_Guias = INTEGER(FacTabla.Campo-C[1]) NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN x-Items_Guias = FacCfgGn.Items_Guias.
    END.
    /* **************************************************************************** */
    /* **************************************************************************** */

    ASSIGN
        lCreaHeader = TRUE.
    pRetVal = "Procesando generacion de GR".
    trloop:
    DO TRANSACTION ON ERROR UNDO trloop, RETURN 'ADM-ERROR' ON STOP UNDO trloop, RETURN 'ADM-ERROR':
        /* Correlativo */
        {lib\lock-genericov3.i &Tabla="FacCorre" ~
            &Condicion="FacCorre.CodCia = s-CodCia ~
            AND FacCorre.CodDoc = 'G/R' ~
            AND FacCorre.CodDiv = s-CodDiv ~
            AND FacCorre.NroSer = INTEGER(COMBO-NroSer-Guia)" ~
            &Bloqueo= "EXCLUSIVE-LOCK NO-ERROR" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje="pRetval" ~
            &TipoError="UNDO TRLOOP, RETURN 'ADM-ERROR'" ~
            }

        /* *************************************** */
        /* RHC 11/05/2020 NO va el flete en la G/R */
        /* RHC 13/07/2020 NO va productos DROP SHIPPING */
        /* *************************************** */
        EMPTY TEMP-TABLE T-DDOCU.
        FOR EACH Reporte NO-LOCK WHERE LOOKUP(Reporte.CodDoc, 'FAC,BOL,FAI') > 0, 
            FIRST B-CDOCU OF Reporte NO-LOCK, 
            EACH B-DDOCU OF B-CDOCU NO-LOCK,
            FIRST Almmmatg OF B-DDOCU NO-LOCK,
            FIRST Almtfami OF Almmmatg NO-LOCK:
            CASE TRUE:
                WHEN Almtfami.Libre_c01 = "SV" THEN NEXT.
                OTHERWISE DO:
                    FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
                        VtaTabla.Tabla = "DROPSHIPPING" AND
                        VtaTabla.Llave_c1 = B-DDOCU.CodMat 
                        NO-LOCK NO-ERROR.
/*                     FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND */
/*                         VtaTabla.Tabla = "DROPSHIPPING" AND                  */
/*                         VtaTabla.Llave_c1 = B-CDOCU.DivOri AND               */
/*                         VtaTabla.Llave_c2 = B-DDOCU.CodMat                   */
/*                         NO-LOCK NO-ERROR.                                    */
                    IF AVAILABLE VtaTabla THEN NEXT.
                END.
            END CASE.
            CREATE T-DDOCU.
            BUFFER-COPY B-DDOCU TO T-DDOCU.
        END.

        FOR EACH Reporte NO-LOCK WHERE LOOKUP(Reporte.CodDoc, 'FAC,BOL,FAI') > 0, 
            FIRST B-CDOCU OF Reporte NO-LOCK, 
            EACH T-DDOCU OF B-CDOCU NO-LOCK,
            FIRST Almmmatg OF T-DDOCU NO-LOCK
            BREAK BY Reporte.CodCia BY Reporte.NroDoc BY T-DDOCU.NroItm:
            /* Cabecera */
            IF lCreaHeader THEN DO:
                CREATE CcbCDocu.
                BUFFER-COPY B-CDOCU
                    TO CcbCDocu
                    ASSIGN
                    CcbCDocu.CodDiv = s-CodDiv
                    CcbCDocu.CodDoc = "G/R"
                    CcbCDocu.NroDoc =  STRING(FacCorre.NroSer,ENTRY(1,x-FormatoGUIA,'-')) + 
                                        STRING(FacCorre.Correlativo,ENTRY(2,x-FormatoGUIA,'-')) 
                    CcbCDocu.FchDoc = TODAY
                    CcbCDocu.CodRef = B-CDOCU.CodDoc
                    CcbCDocu.NroRef = B-CDOCU.NroDoc
                    CcbCDocu.FlgEst = "F"   /* FACTURADO */
                    CcbCDocu.usuario = S-USER-ID
                    CcbCDocu.TpoFac = "A"     /* AUTOMATICA (No descarga stock) */
                    NO-ERROR.
                IF ERROR-STATUS:ERROR THEN DO:
                    pRetVal = "Mal configurado el correlativo de la G/R o duplicado".
                    UNDO trloop, RETURN 'ADM-ERROR'.
                END.
                ASSIGN
                    FacCorre.Correlativo = FacCorre.Correlativo + 1.
                /* ************************************************************* */
                /* RHC De acuerdo a la sede le cambiamos la dirección de entrega */
                /* ************************************************************* */
                RUN logis/p-lugar-de-entrega (INPUT Faccpedi.CodDoc,
                                              INPUT Faccpedi.NroPed,
                                              OUTPUT FILL-IN-LugEnt).
                ASSIGN
                    CcbCDocu.LugEnt  = FILL-IN-LugEnt.
                RUN gn/fUbigeo (INPUT Faccpedi.CodDiv,
                                INPUT Faccpedi.CodDoc,
                                INPUT Faccpedi.NroPed,
                                OUTPUT pCodDpto,
                                OUTPUT pCodProv,
                                OUTPUT pCodDist,
                                OUTPUT pCodPos,
                                OUTPUT pZona,
                                OUTPUT pSubZona).

                ASSIGN
                    CcbCDocu.CodDpto = pCodDpto
                    CcbCDocu.CodProv = pCodProv
                    CcbCDocu.CodDist = pCodDist.
                /* ************************************************************* */
                /* ************************************************************* */
                /* RHC 22/07/2015 COPIAMOS DATOS DEL TRANSPORTISTA */
                FIND FIRST T-CcbADocu NO-LOCK NO-ERROR.
                IF AVAILABLE T-CcbADocu THEN DO:
                    FIND FIRST B-ADOCU WHERE B-ADOCU.codcia = Ccbcdocu.codcia
                        AND B-ADOCU.coddiv = Ccbcdocu.coddiv
                        AND B-ADOCU.coddoc = Ccbcdocu.coddoc
                        AND B-ADOCU.nrodoc = Ccbcdocu.nrodoc
                        NO-ERROR.
                    IF NOT AVAILABLE B-ADOCU THEN CREATE B-ADOCU.
                    BUFFER-COPY T-CcbADocu 
                        TO B-ADOCU
                        ASSIGN
                            B-ADOCU.CodCia = Ccbcdocu.CodCia
                            B-ADOCU.CodDiv = Ccbcdocu.CodDiv
                            B-ADOCU.CodDoc = Ccbcdocu.CodDoc
                            B-ADOCU.NroDoc = Ccbcdocu.NroDoc.
                    FIND gn-provd WHERE gn-provd.CodCia = pv-codcia AND
                        gn-provd.CodPro = B-ADOCU.Libre_C[9] AND
                        gn-provd.Sede   = B-ADOCU.Libre_C[20] AND
                        CAN-FIND(FIRST gn-prov OF gn-provd NO-LOCK)
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE gn-provd THEN
                        ASSIGN
                        CcbCDocu.CodAge  = gn-provd.CodPro
                        CcbCDocu.CodDpto = gn-provd.CodDept 
                        CcbCDocu.CodProv = gn-provd.CodProv 
                        CcbCDocu.CodDist = gn-provd.CodDist 
                        CcbCDocu.LugEnt2 = gn-provd.DirPro.
                END.
                ASSIGN
                    lCreaHeader = FALSE.
            END.
            /* Detalle */
            CREATE Ccbddocu.
            BUFFER-COPY T-DDOCU 
                TO Ccbddocu
                ASSIGN
                    CcbDDocu.NroItm = iCountItem
                    Ccbddocu.coddiv = Ccbcdocu.coddiv
                    Ccbddocu.coddoc = Ccbcdocu.coddoc
                    Ccbddocu.nrodoc = Ccbcdocu.nrodoc.                        
            iCountItem = iCountItem + 1.
            /*IF iCountItem > FacCfgGn.Items_Guias OR LAST-OF(Reporte.CodCia) OR LAST-OF(Reporte.NroDoc)*/
            IF iCountItem > x-Items_Guias OR LAST-OF(Reporte.CodCia) OR LAST-OF(Reporte.NroDoc)
                THEN DO:
                RUN proc_GrabaTotalesGR.
                iCountItem = 1.
                lCreaHeader = TRUE.
            END.
        END.

        pRetVal = "OK".
    END.
*/
    RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-graba-comprobantes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE graba-comprobantes Procedure 
PROCEDURE graba-comprobantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
pRetVal = "".

PRIMERO:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH T-CDOCU NO-LOCK:
        CREATE Ccbcdocu.
        BUFFER-COPY T-CDOCU TO Ccbcdocu NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pRetVal = "Correlativo errado o duplicado: " + T-CDOCU.coddoc + " " +  T-CDOCU.nrodoc.
            UNDO PRIMERO, RETURN 'ADM-ERROR'.
        END.
        FOR EACH T-DDOCU OF T-CDOCU NO-LOCK:
            CREATE Ccbddocu.
            BUFFER-COPY T-DDOCU TO Ccbddocu NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pRetVal = "Correlativo errado o duplicado: " + T-CDOCU.coddoc + " " +  T-CDOCU.nrodoc.
                UNDO PRIMERO, RETURN 'ADM-ERROR'.
            END.
        END.
        /* ****************************************************************************************** */
        CREATE Reporte.
        BUFFER-COPY Ccbcdocu TO Reporte.    /* OJO: Control de Comprobantes Generados */
        /* *********************************************************************** */
        /* RHC 12/10/2020 CONTROL MR: Control KPI de despacho por O/D */
        /* *********************************************************************** */
        DEFINE VAR hMaster AS HANDLE NO-UNDO.
        RUN gn/master-library.r PERSISTENT SET hMaster.
        RUN ML_Actualiza-FAC-Control IN hMaster (INPUT ROWID(Ccbcdocu),     /* FAC */
                                                 OUTPUT pRetVal).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRIMERO, RETURN 'ADM-ERROR'.
        DELETE PROCEDURE hMaster.
        /* *********************************************************************** */
        /* CALCULO DE PERCEPCIONES */
        /* *********************************************************************** */
        RUN vta2/calcula-percepcion.r( ROWID(Ccbcdocu) ).
        FIND CURRENT Ccbcdocu EXCLUSIVE-LOCK.

        /* ******************************* */
        /* RHC 22/11/2019 OTROS DESCUENTOS */
        /* ******************************* */
        DEFINE VAR z-hProc AS HANDLE NO-UNDO.           /* Handle Libreria */
        RUN sunat\p-otros-descuentos-sunat.p PERSISTENT SET z-hProc.
        /* *********************************************************************** */
        /* Otros descuentos */
        /* *********************************************************************** */
        RUN descuento-logistico IN z-hProc (INPUT Ccbcdocu.coddiv,
                                            INPUT Ccbcdocu.coddoc,
                                            INPUT Ccbcdocu.nrodoc,
                                            OUTPUT pRetVal).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            DELETE PROCEDURE z-hProc.                   /* Release Libreria */
            UNDO PRIMERO, RETURN 'ADM-ERROR'.
        END.
        /* *********************************************************************** */
        /* Descuentos por PRONTO PAGO/DESPACHO (A/C) */
        /* *********************************************************************** */
        IF FacCPedi.TpoLic = YES THEN DO:
            /* Otros descuentos */
            SESSION:SET-WAIT-STATE("GENERAL").
            RUN descuento-por-pronto-pago IN z-hProc (INPUT Ccbcdocu.coddiv,
                                          INPUT Ccbcdocu.coddoc,
                                          INPUT Ccbcdocu.nrodoc,
                                          OUTPUT pRetVal).
            SESSION:SET-WAIT-STATE("").

            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                DELETE PROCEDURE z-hProc.                   /* Release Libreria */
                UNDO PRIMERO, RETURN 'ADM-ERROR'.
            END.
        END.
        DELETE PROCEDURE z-hProc.                       /* Release Libreria */
        /* *********************************************************************** */
        /* RHC 30-11-2006 Transferencia Gratuita */
        /* *********************************************************************** */
        IF LOOKUP(Ccbcdocu.FmaPgo, '900,899') > 0 THEN Ccbcdocu.sdoact = 0.
        IF Ccbcdocu.sdoact <= 0 
        THEN ASSIGN
                Ccbcdocu.fchcan = TODAY
                Ccbcdocu.flgest = 'C'.
        /* ****************************************************************************************** */
        /* Importes SUNAT */
        /* 05/08/2022: Pre-calculo para ser usado en APLICACION DE ANTICIPOS */
        /* ****************************************************************************************** */
        DEF VAR hProc AS HANDLE NO-UNDO.
        RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
        RUN tabla-ccbcdocu IN hProc (INPUT Ccbcdocu.CodDiv,
                                     INPUT Ccbcdocu.CodDoc,
                                     INPUT Ccbcdocu.NroDoc,
                                     OUTPUT pRetVal).
        /*IF pMensaje = "OK" THEN pMensaje = "".*/
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
        /* ****************************************************************************************** */
        /* *********************************************************************** */
        /* APLICACION DE ADELANTOS */
        /* *********************************************************************** */
        RUN Aplicacion-de-Adelantos.
        IF RETURN-VALUE = "ADM-ERROR" THEN DO:
            IF TRUE <> (pRetVal > '') THEN pRetVal = "NO se pudo generar las N/C por aplicación de A/C".
            UNDO PRIMERO, RETURN 'ADM-ERROR'.
        END.
        /* ****************************************************************************************** */
        /* Importes SUNAT */
        /* ****************************************************************************************** */
        RUN tabla-ccbcdocu IN hProc (INPUT Ccbcdocu.CodDiv,
                                     INPUT Ccbcdocu.CodDoc,
                                     INPUT Ccbcdocu.NroDoc,
                                     OUTPUT pRetVal).
        /*IF pMensaje = "OK" THEN pMensaje = "".*/
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
        DELETE PROCEDURE hProc.
        /* ****************************************************************************************** */
        /* *********************************************************************** */
        /* RHC 12.07.2012 limpiamos campos para G/R */
        /* *********************************************************************** */
        ASSIGN
            Ccbcdocu.codref = ""
            Ccbcdocu.nroref = "".
        /* solo va a sevir para el mismo día */
        IF pOrigen = "MOSTRADOR" THEN DO:
            FIND FIRST w-report WHERE w-report.Llave-I = Ccbcdocu.codcia
                AND w-report.Campo-C[1] = Ccbcdocu.coddoc
                AND w-report.Campo-C[2] = Ccbcdocu.nrodoc      
                AND w-report.Llave-C = "IMPCAJA"
                AND w-report.Llave-D = Ccbcdocu.fchdoc
                AND w-report.Task-No = INTEGER(Ccbcdocu.coddiv)
                NO-ERROR.
            IF NOT AVAILABLE w-report THEN CREATE w-report.
            ASSIGN
            w-report.Llave-I = Ccbcdocu.codcia
            w-report.Campo-C[1] = Ccbcdocu.coddoc
            w-report.Campo-C[2] = Ccbcdocu.nrodoc      
            w-report.Llave-C = "IMPCAJA"
            w-report.Llave-D = Ccbcdocu.fchdoc
            w-report.Task-No = INTEGER(Ccbcdocu.coddiv).
        END.
        /* *********************************************************************** */
        /* ACTUALIZAMOS ALMACENES */
        /* *********************************************************************** */
        RUN vta2/act_almv2.r ( INPUT ROWID(CcbCDocu), OUTPUT pRetVal ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pRetVal > "") THEN pRetVal = "ERROR: NO se pudo actualizar el Kardex".
            UNDO PRIMERO, RETURN 'ADM-ERROR'.
        END.
        /* *********************************************************************** */
        /* RHC 14/10/2020 Control FIFO productos por # de Serie */
        /* *********************************************************************** */
        RUN gn/master-library PERSISTENT SET hMaster.
        RUN ML_Actualiza-FIFO-Control IN hMaster (INPUT ROWID(Ccbcdocu),     /* FAC */
                                                  OUTPUT pRetVal).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRIMERO, RETURN 'ADM-ERROR'.
        DELETE PROCEDURE hMaster.
        /* *********************************************************************** */
        /* RHC 29/03/2021 Control de Descuentos FAC y BOL */
        /* *********************************************************************** */
/*         RUN vtagn/p-control-descuentos-fac ( ROWID(CcbCDocu) ).              */
/*         IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRIMERO, RETURN 'ADM-ERROR'. */
    END.
END.

pRetVal = "OK".

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-graba-temp-FeLogErrores) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE graba-temp-FeLogErrores Procedure 
PROCEDURE graba-temp-FeLogErrores :
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
IF AVAILABLE(FeLogErrores) THEN RELEASE FeLogErrores.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-MASTER-TRANSACTION) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MASTER-TRANSACTION Procedure 
PROCEDURE MASTER-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR cFlujo AS CHAR NO-UNDO.

pMensaje-2 = "".

/* Ic - 01Feb2017, Macchiu, verifica si la serie es comprobantes DIFERIDOS */
pEsSerieDiferido = NO.
FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia 
    AND vtatabla.tabla = 'NSERIE_DIFERIDO' 
    AND vtatabla.llave_c1 = COMBO-NroSer NO-LOCK NO-ERROR.
IF AVAILABLE vtatabla THEN DO:
    /* Maximo 7 dias */
    IF MONTH(TODAY - 7) = MONTH(TODAY)  THEN DO:
        pRetVal = "Imposible generar Comprobante con la serie seleccionada esta fuera de fecha".
        RETURN 'ADM-ERROR'.
    END.
    /* Buscamos la O/D diferida a generar */
    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                            vtatabla.tabla = 'ORDEN_DIFERIDO' AND
                            vtatabla.llave_c1 = faccpedi.coddoc AND
                            vtatabla.llave_c2 = faccpedi.nroped NO-LOCK NO-ERROR.
    IF NOT AVAILABLE vtatabla THEN DO:
        pRetval ="La serie del comprobante es DIFERIDA, Pero el " + faccpedi.coddoc + "  no esta como DIFERIDA...ERROR".
        RETURN 'ADM-ERROR'.
    END.
    pEsSerieDiferido = YES.
END.  
ELSE DO:
    /* Buscamos la O/D diferida a generar */
    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                            vtatabla.tabla = 'ORDEN_DIFERIDO' AND
                            vtatabla.llave_c1 = faccpedi.coddoc AND
                            vtatabla.llave_c2 = faccpedi.nroped NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN DO:
        pRetval = "La " + faccpedi.coddoc + " " + faccpedi.nroped + " esta inscrita como DIFERIDA, pero no le corresponde esta serie de Comprobante".
        RETURN 'ADM-ERROR'.
    END.
END.

/* Si es una venta MANUAL la tabla PEDI ya viene pre-cargada */
RUN Carga-Inicial.   /* Carga la tabla ITEM */
FIND FIRST ITEM NO-LOCK NO-ERROR.
IF NOT AVAILABLE ITEM THEN DO:
    pRetVal = "Ya no hay Items para generar comprobantes".
    RETURN 'ADM-ERROR'.
END.


/* Ic - 01Feb2017, FIN */
SESSION:SET-WAIT-STATE('GENERAL').
EMPTY TEMP-TABLE T-FELogErrores.    /* CONTROL DE ERRORES DE FACTURACION ELECTRONICA */

DEFINE VAR x-veces AS INT.

x-veces = 0.

pRetVal = "Procesandooo".

RLOOP:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    EMPTY TEMP-TABLE Reporte.           /* Documentos Creados en la transacción */
    cFlujo = "1".
    /* FIJAMOS EL PUNTERO DEL BUFFER EN LA O/D */
    {lib\lock-genericov3.i ~
        &Tabla="FacCPedi" ~
        &Condicion="ROWID(FacCPedi) = rwParaRowID" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="LEAVE" ~
        &Mensaje="NO" ~
        &txtMensaje="pRetval"
        &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'" ~
        }
    /* ******************************************************************************************** */
    /* TABLAS RELACIONADAS */
    /* ******************************************************************************************** */
    cFlujo = "2".
    FIND FIRST PEDIDO WHERE PEDIDO.codcia = Faccpedi.codcia
        AND PEDIDO.coddoc = Faccpedi.codref
        AND PEDIDO.nroped = Faccpedi.nroref
        NO-LOCK NO-ERROR.
    cFlujo = "3".
    FIND FIRST COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
        AND COTIZACION.coddoc = PEDIDO.codref
        AND COTIZACION.nroped = PEDIDO.nroref
        NO-LOCK NO-ERROR.
    /* ******************************************************************************************** */
    /* CARGAMOS SALDOS DE LA  O/D */
    /* ******************************************************************************************** */
    cFlujo = "4".
    RUN Carga-Temporal.
    cFlujo = "5".
    FIND FIRST PEDI NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PEDI THEN DO:
        pRetVal = "Ya no hay Items para generar comprobantes".
        UNDO RLOOP, LEAVE.
    END.
    cFlujo = "6".
    /* ZONAS Y UBICACIONES, DESCUENTOS LISTA EXPRESS */
    RUN Resumen-Temporal.
    cFlujo = "7".
    /* ******************************************************************************************** */
    /* FILTRO DE CONTROL */
    /* ******************************************************************************************** */
    IF NOT (FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = "C") THEN DO:
        pRetVal = "Registro de O/D ya no está 'PENDIENTE'".
        UNDO RLOOP, LEAVE.
    END.

    /* ******************************************************************************************** */
    /* 1ra. TRANSACCION: COMPROBANTES */
    /* ******************************************************************************************** */
    cFlujo = "8".
    RUN FIRST-TRANSACTION.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pRetVal > "") THEN pRetVal = "ERROR: No se pudo generar el comprobante" .
        UNDO RLOOP, LEAVE.
    END.
    cFlujo = "9".
    /* ******************************************************************************************** */
    /* 2da. TRANSACCION: E-POS */
    /* ******************************************************************************************** */
    RUN SECOND-TRANSACTION.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, LEAVE.
    cFlujo = "10".
    /* ******************************************************************************************** */
    /* 3ro. GRABACIONES FINALES:  Cierra la O/D */
    /* ******************************************************************************************** */
    FIND FIRST Facdpedi OF Faccpedi WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Facdpedi THEN FacCPedi.FlgEst = "C".
    /* RHC 07/02/2017 Lista Express */
    IF COTIZACION.TpoPed = "LF" THEN FacCPedi.FlgEst = "C".
    FOR EACH Reporte NO-LOCK, FIRST Ccbcdocu OF Reporte NO-LOCK:
        pMensaje-2 = pMensaje-2 + Ccbcdocu.coddoc + ' ' + Ccbcdocu.nrodoc + " (" + faccpedi.coddoc + " " + faccpedi.nroped + ")" + CHR(10).
    END.
    cFlujo = "11".
    FIND CURRENT FacCPedi NO-LOCK.
    IF AVAILABLE(Ccbcdocu) THEN FIND CURRENT Ccbcdocu NO-LOCK.  /* Para no peder el puntero */
    cFlujo = "12".
    IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
    IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
    IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.
    IF AVAILABLE(Ccbadocu) THEN RELEASE Ccbadocu.
    IF AVAILABLE(B-ADOCU)  THEN RELEASE B-ADOCU.
    IF AVAILABLE(w-repor)  THEN RELEASE w-report.
    IF AVAILABLE(Gn-clie)  THEN RELEASE Gn-clie.
    IF AVAILABLE(Ccbccaja) THEN RELEASE Ccbccaja.
    cFlujo = "13".
    x-veces = x-veces + 1.
    pRetVal = "OK".

END.

IF ERROR-STATUS:ERROR THEN DO:
    /*pRetVal = ERROR-STATUS:GET-MESSAGE(1).*/
END.

SESSION:SET-WAIT-STATE('').

/* liberamos tablas */
RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */

IF NOT (pRetVal = "" OR pRetVal = "OK") THEN DO:
    /*
    MESSAGE "Hubo Problemas para generar comprobante" SKIP
        pMensaje VIEW-AS ALERT-BOX ERROR.
    pMensaje = "".
    */
    RETURN 'ADM-ERROR'.
END.

pNroCmpteGenerado = pMensaje-2.      /* Numero de comprobante generado */

/* 3ro. CONTROL DE FACTURAS ADELANTADAS */
IF pOrigen = "MOSTRADOR" THEN DO:
    RUN Facturas-Adelantadas.
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
/* Ic - 01Feb2017, es serie de Comprobante diferido */                                  

DEFINE VAR x-fechaemision AS DATE.
DEFINE VAR cDivOri AS CHAR NO-UNDO.
DEFINE VAR x-fecha-vcto AS DATE.

cDivOri = FacCPedi.CodDiv.  /* Por defecto */
IF AVAILABLE COTIZACION THEN cDivOri = COTIZACION.CodDiv.
/* IF Faccpedi.CrossDocking = YES THEN DO: */
/*     /* Buscamos la división origen */   */
/*     cDivOri = PEDIDO.CodDiv.            */
/* END.                                    */

x-fechaemision = TODAY.
IF pEsSerieDiferido = YES THEN DO:
    /* Ic - 01Feb2017, la fecha de emision el ultimo dia del mes anterior */
    x-fechaemision = DATE(MONTH(TODAY),1,YEAR(TODAY)) - 1.
END.

pRetval = "PROCESANDO PROC_CREACABECERA".
GRABA_CABECERA:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* ******************************************* */
    /* RHC 24/11/2015 Control de LISTA DE TERCEROS */
    /* ******************************************* */
    IF AVAILABLE COTIZACION AND COTIZACION.TipBon[10] > 0 THEN DO:
        FIND Gn-clie WHERE Gn-clie.codcia = cl-codcia
            AND Gn-clie.codcli = Faccpedi.codcli
            EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR AND LOCKED(Gn-clie) THEN DO:
            pRetVal = 'NO se pudo actualizar el control de LISTA DE TERCEROS en el cliente'.
            UNDO GRABA_CABECERA, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            Gn-clie.Libre_d01 = MAXIMUM(Gn-clie.Libre_d01, COTIZACION.TipBon[10]).
    END.
    FIND Gn-clie WHERE Gn-clie.codcia = cl-codcia
        AND Gn-clie.codcli = Faccpedi.codcli
        NO-LOCK NO-ERROR.
    /* ******************************************* */
    CREATE T-CDOCU.
    BUFFER-COPY FacCPedi 
        EXCEPT Faccpedi.ImpDto2 Faccpedi.PorDto Faccpedi.Importe
        TO T-CDOCU
        ASSIGN
        T-CDOCU.CodDiv = s-CodDiv
        T-CDOCU.DivOri = cDivOri    /* OJO: division de estadisticas */
        T-CDOCU.CodAlm = FacCPedi.CodAlm   /* OJO: Almacén despacho */
        T-CDOCU.CodDoc = cCodDoc
        T-CDOCU.NroDoc =  STRING(FacCorre.NroSer,ENTRY(1,x-FormatoFAC,'-')) + 
                            STRING(FacCorre.Correlativo,ENTRY(2,x-FormatoFAC,'-')) 
        T-CDOCU.FchDoc = x-fechaemision /* TODAY , Ic - 01Feb2017 */
        T-CDOCU.CodMov = cCodMov
        T-CDOCU.CodRef = FacCPedi.CodDoc           /* CONTROL POR DEFECTO */
        T-CDOCU.NroRef = FacCPedi.NroPed
        T-CDOCU.Libre_c01 = FacCPedi.CodDoc        /* CONTROL ADICIONAL */
        T-CDOCU.Libre_c02 = FacCPedi.NroPed
        T-CDOCU.Libre_c04 = (IF cCodDoc = "TCK" AND AVAILABLE gn-clie AND gn-clie.libre_c01 = "J" THEN "FAC" ELSE "")     /* Para TCK */
        T-CDOCU.CodPed = FacCPedi.CodRef
        T-CDOCU.NroPed = FacCPedi.NroRef
        T-CDOCU.FchVto = x-fechaemision /* TODAY , Ic - 01Feb2017 */
        T-CDOCU.CodAnt = FacCPedi.Atencion     /* DNI */
        T-CDOCU.TpoCmb = FacCfgGn.TpoCmb[1]
        T-CDOCU.NroOrd = FacCPedi.ordcmp
        T-CDOCU.FlgEst = IF (pEsValesUtilex = YES ) THEN "E" ELSE "P"
        T-CDOCU.TpoFac = "CR"                  /* CREDITO */
        T-CDOCU.Tipo   = "CREDITO"  /*pOrigen*/
        T-CDOCU.CodCaja= pCodTer
        T-CDOCU.usuario = S-USER-ID
        T-CDOCU.HorCie = STRING(TIME,'hh:mm')
        T-CDOCU.LugEnt = FILL-IN-LugEnt     /* OJO */
        T-CDOCU.LugEnt2 = FacCPedi.LugEnt2
        T-CDOCU.Glosa = FILL-IN-Glosa
        T-CDOCU.FlgCbd = FacCPedi.FlgIgv
        T-CDOCU.Sede   = FacCPedi.Sede.     /* <<< SEDE DEL CLIENTE <<< */
    /* RHC 18/02/2016 LISTA EXPRESS WEB */          
    IF COTIZACION.TpoPed = "LF" 
        THEN ASSIGN
                T-CDOCU.ImpDto2   = COTIZACION.ImpDto2       /* Descuento TOTAL CON IGV */
                T-CDOCU.Libre_d01 = COTIZACION.Importe[3].   /* Descuento TOTAL SIN IGV */
    /* **************************** */
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    FIND FIRST gn-convt WHERE gn-convt.Codig = T-CDOCU.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN DO:
        T-CDOCU.TipVta = IF gn-ConVt.TotDias = 0 THEN "1" ELSE "2".
        /*T-CDOCU.FchVto = T-CDOCU.FchDoc + INTEGER(ENTRY(NUM-ENTRIES(gn-ConVt.Vencmtos),gn-ConVt.Vencmtos)).*/
    END.
    /* Ic - 29Set2018, a pedido de jukiisa calderon */
    RUN gn/fecha-vencimiento-cond-vta.r(INPUT T-CDOCU.FmaPgo, INPUT T-CDOCU.FchDoc, OUTPUT x-fecha-vcto).
    ASSIGN T-CDOCU.FchVto = x-fecha-vcto.

    FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
        AND gn-clie.CodCli = T-CDOCU.CodCli 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie  THEN DO:
        ASSIGN
            T-CDOCU.CodDpto = gn-clie.CodDept 
            T-CDOCU.CodProv = gn-clie.CodProv 
            T-CDOCU.CodDist = gn-clie.CodDist.
    END.
    /* Guarda Centro de Costo */
    FIND gn-ven WHERE
        gn-ven.codcia = s-codcia AND
        gn-ven.codven = T-CDOCU.codven
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN T-CDOCU.cco = gn-ven.cco.
    /* RHC 22/07/2015 COPIAMOS DATOS DEL TRANSPORTISTA */
    FIND FIRST T-CcbADocu NO-LOCK NO-ERROR.
    IF AVAILABLE T-CcbADocu THEN DO:
        FIND FIRST B-ADOCU WHERE B-ADOCU.codcia = T-CDOCU.codcia
            AND B-ADOCU.coddiv = T-CDOCU.coddiv
            AND B-ADOCU.coddoc = T-CDOCU.coddoc
            AND B-ADOCU.nrodoc = T-CDOCU.nrodoc
            NO-ERROR.
        IF NOT AVAILABLE B-ADOCU THEN CREATE B-ADOCU.
        BUFFER-COPY T-CcbADocu 
            TO B-ADOCU
            ASSIGN
                B-ADOCU.CodCia = T-CDOCU.CodCia
                B-ADOCU.CodDiv = T-CDOCU.CodDiv
                B-ADOCU.CodDoc = T-CDOCU.CodDoc
                B-ADOCU.NroDoc = T-CDOCU.NroDoc.
        /* ACTUALIZAMOS ORDEN DE DESPACHO */
        /* RHC 18/09/2019 Solo si NO va es un DEJADO EN TIENDA */
        IF FacCPedi.DT = NO AND B-ADOCU.Libre_C[9] > '' THEN DO:  /* AGENCIA DE TRANSPORTE */
            FIND gn-provd WHERE gn-provd.CodCia = pv-codcia AND 
                gn-provd.CodPro = B-ADOCU.Libre_C[9] AND 
                gn-provd.Sede   = B-ADOCU.Libre_C[20]
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-provd THEN DO:
                FIND TabDistr WHERE TabDistr.CodDepto = gn-provd.CodDept 
                    AND TabDistr.CodProvi = gn-provd.CodProv 
                    AND TabDistr.CodDistr = gn-provd.CodDist
                    NO-LOCK NO-ERROR.
                IF AVAILABLE TabDistr THEN DO:
                    ASSIGN
                        FacCPedi.Ubigeo[1] = gn-provd.Sede
                        FacCPedi.Ubigeo[2] = "@PV"
                        FacCPedi.Ubigeo[3] = gn-provd.CodPro.
            END.
          END.
      END.
    END.
    /* ******************************** */
    /* TRACKING GUIAS */
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
    s-FechaT = DATETIME(TODAY, MTIME).
END.

pRetval = "OK".

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_GrabaTotales) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_GrabaTotales Procedure 
PROCEDURE proc_GrabaTotales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Rutina General */
    /*{vtagn/i-total-factura.i &Cabecera="T-CDOCU" &Detalle="T-DDOCU"}*/
    {vtagn/i-total-factura-sunat.i &Cabecera="T-CDOCU" &Detalle="T-DDOCU"}

    /* Caso Lista Express */
    IF COTIZACION.TpoPed = "LF"  THEN ASSIGN T-CDOCU.SdoAct = 0 T-CDOCU.FlgEst = "C".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_GrabaTotalesGR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_GrabaTotalesGR Procedure 
PROCEDURE proc_GrabaTotalesGR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/graba-totales-factura-cred.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resumen-temporal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resumen-temporal Procedure 
PROCEDURE resumen-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Cargamos informacion de Zonas y Ubicaciones */
FOR EACH PEDI:
    ASSIGN
        PEDI.Libre_c04 = "G-0"
        PEDI.Libre_c05 = "G-0".
    FIND FIRST Almmmate WHERE Almmmate.CodCia = s-CodCia
        AND Almmmate.CodAlm = PEDI.AlmDes
        AND Almmmate.CodMat = PEDI.CodMat
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmate THEN DO:
        ASSIGN 
            PEDI.Libre_c04 = Almmmate.CodUbi.
        FIND Almtubic WHERE Almtubic.codcia = s-codcia
            AND Almtubic.codubi = Almmmate.codubi
            AND Almtubic.codalm = Almmmate.codalm
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtubic THEN PEDI.Libre_c05 = Almtubic.CodZona.
    END.
END.
/* RHC 15/03/17 DESCUENTO POR LISTA EXPRESS */
IF COTIZACION.TpoPed = "LF" THEN DO:      /* LISTA EXPRESS */
    FOR EACH PEDI:
        FIND Facdpedi OF Faccpedi WHERE Facdpedi.codmat = PEDI.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE Facdpedi THEN PEDI.ImpDto2 = Facdpedi.ImpDto2.
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-SECOND-TRANSACTION) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SECOND-TRANSACTION Procedure 
PROCEDURE SECOND-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR iNumOrden AS INT INIT 0 NO-UNDO.   /* COntrola la cantidad de comprobantes procesados */
pRetVal = "".
FOR EACH Reporte NO-LOCK, FIRST Ccbcdocu OF Reporte NO-LOCK:
    iNumOrden = iNumOrden + 1.
    /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
    RUN sunat\progress-to-ppll-v3  ( INPUT Ccbcdocu.coddiv,
                                     INPUT Ccbcdocu.coddoc,
                                     INPUT Ccbcdocu.nrodoc,
                                     INPUT-OUTPUT TABLE T-FELogErrores,
                                     OUTPUT pRetVal ).
      /* GRE - Grabar los comprobantes para la generacion de la GRE  */
    IF RETURN-VALUE = "OK" OR RETURN-VALUE = "PLAN-B" THEN DO:
        
        CREATE b-gre_cmpte.
            ASSIGN b-gre_cmpte.coddoc = Ccbcdocu.coddoc
                    b-gre_cmpte.nrodoc = Ccbcdocu.nrodoc
                    b-gre_cmpte.coddivvta = Ccbcdocu.divori
                    b-gre_cmpte.coddivdesp = Ccbcdocu.coddiv
                    b-gre_cmpte.fechaemision = Ccbcdocu.fchdoc.
        IF Ccbcdocu.coddoc = 'FAI' THEN DO:
            ASSIGN b-gre_cmpte.estado_sunat = "ACEPTADO POR SUNAT".
        END.
        IF toggle-genera-pgre = NO THEN DO:
            ASSIGN b-gre_cmpte.estado = "NO GENERA PGRE".
        END.

        RELEASE b-gre_cmpte NO-ERROR.
    END.

    IF RETURN-VALUE <> "OK" THEN DO:
        IF RETURN-VALUE = 'ADM-ERROR' THEN IF TRUE <> (pRetVal > "") THEN pRetVal = "ERROR conexión de ePos".
        IF RETURN-VALUE = 'ERROR-EPOS' THEN IF TRUE <> (pRetVal > "") THEN pRetVal = "ERROR grabación de ePos".
        IF RETURN-VALUE = 'PLAN-B' THEN DO:
            pRetVal = 'OK'.
            RETURN "PLAN-B".
        END.
        RETURN 'ADM-ERROR'.
    END.

END.

pRetVal = "OK".

RETURN 'OK'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

