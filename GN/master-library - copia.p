&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-ALM FOR Almacen.
DEFINE BUFFER b-AlmCIncidencia FOR AlmCIncidencia.
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE BUFFER B-CREPO FOR almcrepo.
DEFINE BUFFER B-DREPO FOR almdrepo.
DEFINE BUFFER B-MATG FOR Almmmatg.
DEFINE TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE T-DINCI NO-UNDO LIKE AlmDIncidencia.
DEFINE TEMP-TABLE t-LogisDChequeo NO-UNDO LIKE logisdchequeo.



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

DEF SHARED VAR s-codcia  AS INTE.
DEF SHARED VAR cl-codcia AS INTE. 
DEF SHARED VAR s-user-id AS CHAR.   
 
DEF SHARED VAR s-coddiv AS CHAR.       

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VAR cRucEmpresa AS CHAR.

cRucEmpresa = "20100038146".   

DEFINE BUFFER x-factabla FOR factabla.
DEFINE BUFFER x-vtatabla FOR vtatabla.

DEFINE TEMP-TABLE tw-report LIKE w-report.      /* Ic */
DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER x-ccbddocu FOR ccbddocu.

/* Sintaxis:

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN <libreria> PERSISTENT SET hProc.

RUN <libreria>.rutina_interna IN hProc (input  buffer tt-excel:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-excel:handle,
                        input  c-csv-file,
                        output c-xls-file) .

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


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fget-doc-original) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-doc-original Procedure 
FUNCTION fget-doc-original RETURNS CHARACTER
  ( INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-prefijo-de-la-serie) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-prefijo-de-la-serie Procedure 
FUNCTION fget-prefijo-de-la-serie RETURNS CHARACTER
  (INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR, INPUT pDivision AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetEsAlfabetico) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetEsAlfabetico Procedure 
FUNCTION GetEsAlfabetico RETURNS LOGICAL
  ( INPUT pCaracter AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetEsNumerico) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetEsNumerico Procedure 
FUNCTION GetEsNumerico RETURNS LOGICAL
  ( INPUT pCaracter AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-InicioCaracteresValidos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD InicioCaracteresValidos Procedure 
FUNCTION InicioCaracteresValidos RETURNS LOGICAL
  ( INPUT pTexto AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-TieneCaracteresNoValido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD TieneCaracteresNoValido Procedure 
FUNCTION TieneCaracteresNoValido RETURNS LOGICAL
  ( INPUT pTexto AS CHAR, INPUT pLlave AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-ALM B "?" ? INTEGRAL Almacen
      TABLE: b-AlmCIncidencia B "?" ? INTEGRAL AlmCIncidencia
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: B-CREPO B "?" ? INTEGRAL almcrepo
      TABLE: B-DREPO B "?" ? INTEGRAL almdrepo
      TABLE: B-MATG B "?" ? INTEGRAL Almmmatg
      TABLE: PEDI T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: T-DINCI T "?" NO-UNDO INTEGRAL AlmDIncidencia
      TABLE: t-LogisDChequeo T "?" NO-UNDO INTEGRAL logisdchequeo
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 22.31
         WIDTH              = 60.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Actualiza-Saldo-Referencia) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Saldo-Referencia Procedure 
PROCEDURE Actualiza-Saldo-Referencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pTipo  AS CHAR.     /* D: descarga(-)  C: carga(+) */
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

/* ACTUALIZA LA COTIZACION EN BASE AL PEDIDO AL CREDITO */
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE BUFFER B-CPEDI FOR FacCPedi.

/* Se supone que el puntero está en el registro correcto */
FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN 'ADM-ERROR'.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Bloqueamos la cotizacion */
    {lib/lock-genericov3.i ~
        &Tabla="B-CPEDI" ~
        &Condicion="B-CPedi.CodCia=FacCPedi.CodCia ~
                AND B-CPedi.CodDoc=FacCPedi.CodRef ~
                AND B-CPedi.NroPed=FacCPedi.NroRef" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pError" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        }
    /* NO ACTUALIZAMOS LAS PROMOCIONES */
    FOR EACH Facdpedi OF Faccpedi NO-LOCK,
        EACH B-DPedi OF B-CPedi EXCLUSIVE-LOCK WHERE B-DPedi.CodMat = Facdpedi.CodMat
        AND B-DPEDI.Libre_c05 = Facdpedi.Libre_c05    /* Nuevo campo de control */
        ON ERROR UNDO, THROW:
        /* En estos casos NO tomar en cuenta OF */
        IF LOOKUP(Faccpedi.CodDoc, 'PED') > 0 AND Facdpedi.Libre_c05 = "OF" THEN NEXT.
        /* ************************************ */
        CASE pTipo:
            WHEN "D" THEN DO:
                B-DPedi.CanAte = B-DPedi.CanAte - Facdpedi.CanPed.
                IF B-DPEDI.CanAte < 0 THEN DO:
                    pError = 'Se ha detectado un error al extornar el producto ' + B-DPEDI.codmat + CHR(10) +
                    'Los despachos superan a lo cotizado' + CHR(10) +
                    'Cant. cotizada: ' + STRING(B-DPEDI.CanPed, '->>>,>>9.99') + CHR(10) +
                    'Total pedidos : ' + STRING(B-DPEDI.CanAte, '->>>,>>9.99') + CHR(10) +
                    'FIN DEL PROCESO'.
                    UNDO PRINCIPAL, RETURN "ADM-ERROR".
                END.
            END.
            WHEN "C" THEN DO:
                B-DPedi.CanAte = B-DPedi.CanAte + Facdpedi.CanPed.
                /* CONTROL DE ATENCIONES */
                IF B-DPEDI.CanAte > B-DPEDI.CanPed THEN DO:
                    pError = 'Se ha detectado un error al actualizar el producto ' + B-DPEDI.codmat + CHR(10) +
                    'Los despachos superan a lo cotizado' + CHR(10) +
                    'Cant. cotizada: ' + STRING(B-DPEDI.CanPed, '->>>,>>9.99') + CHR(10) +
                    'Total pedidos : ' + STRING(B-DPEDI.CanAte, '->>>,>>9.99') + CHR(10) +
                    'FIN DEL PROCESO'.
                    UNDO PRINCIPAL, RETURN "ADM-ERROR".
                END.
            END.
        END CASE.
    END.
    /* ACTUALIZAMOS FLAG DE LA COTIZACION */
    B-CPedi.FlgEst = "C".
    /* Si aun tiene cantidades x despachar lo mantenemos como pendiente */
    FIND FIRST B-DPedi OF B-CPedi WHERE B-DPedi.CanAte < B-DPedi.CanPed NO-LOCK NO-ERROR.
    IF AVAILABLE B-DPedi THEN B-CPedi.FlgEst = "P".
    /* RHC 06/02/2017 Cerramos la cotización de lista express             */
    IF B-CPEDI.TpoPed = "LF" AND pTipo = "C" THEN B-CPEDI.FlgEst = "C".
    /* ****************************************************************** */
END.
IF AVAILABLE B-CPEDI THEN RELEASE B-CPEDI.
IF AVAILABLE B-DPEDI THEN RELEASE B-DPEDI.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-anticipos-aplicados-despacho) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE anticipos-aplicados-despacho Procedure 
PROCEDURE anticipos-aplicados-despacho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Retorna lista de todos las FACTURAS de anticipos, que se usaron para
                la cancelacion del comprobante de despacho.
  Estructura :
                indicador|numeroOrdenAnticipo|tipoDocumentoEmisorAnticipo|numeroDocumentoEmisorAnticipo|
                tipoDocumentoAnticipo|serieNumeroDocumentoAnticipo|totalPrepagadoAnticipo|fechaPago|
                impteValorVentaAnticipo|impteIgvAnticipo*
                
  (*) : Indica fin de linea, ejemplo.
  A|1|
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE OUTPUT PARAMETER pRetTXT AS CHAR.

DEFINE VAR x-CodMonDocDespacho AS INT.
DEFINE VAR x-TpoCmbDocDespacho AS DEC.

/* La factura del A/C */
DEFINE VAR x-coddoc-ac AS CHAR.
DEFINE VAR x-nrodoc-ac AS CHAR.

DEFINE VAR x-monto-del-anticipo AS DEC.
DEFINE VAR x-vvta-del-anticipo AS DEC.
DEFINE VAR x-igv-del-anticipo AS DEC.

DEFINE VAR x-suma-de-anticipos AS DEC.
DEFINE VAR x-suma-vvta-de-anticipos AS DEC.
DEFINE VAR x-suma-igv-de-anticipos AS DEC.

DEFINE VAR x-orden-anticipo AS INT.
DEFINE VAR x-serie-numero-anticipo AS CHAR.
DEFINE VAR x-fecha-pago AS CHAR.

DEFINE BUFFER x-ccbdcaja FOR ccbdcaja.
DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER z-ccbcdocu FOR ccbcdocu.

pRetTxt = "".
x-orden-anticipo = 0.
x-CodMonDocDespacho = 1.
x-TpoCmbDocDespacho = 1.

/* La moneda y tipo de cambio del comprobante de despacho de mercaderia */
FIND FIRST z-ccbcdocu WHERE z-ccbcdocu.codcia = s-codcia AND
                            z-ccbcdocu.coddoc = pCodDoc AND
                            z-ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.
IF AVAILABLE z-ccbcdocu THEN DO:
    x-CodMonDocDespacho = z-ccbcdocu.codmon.
    x-TpoCmbDocDespacho = z-ccbcdocu.tpocmb.
END.

/* Todas las A/C comprometidas en el comprobante electronico del despacho */
FOR EACH x-ccbdcaja WHERE x-ccbdcaja.codcia = s-codcia AND
                            x-ccbdcaja.codref = pCodDoc AND
                            x-ccbdcaja.nroref = pNroDoc AND
                            x-ccbdcaja.coddoc = 'A/C' NO-LOCK:

    /* Verificamos que la A/C no este anulado */
    FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                                x-ccbcdocu.coddoc = x-ccbdcaja.coddoc AND
                                x-ccbcdocu.nrodoc = x-ccbdcaja.nrodoc AND 
                                x-ccbcdocu.flgest <> 'A' NO-LOCK NO-ERROR.

    IF (AVAILABLE x-ccbcdocu) THEN DO:
        x-coddoc-ac = x-ccbcdocu.codref.
        x-nrodoc-ac = x-ccbcdocu.nroref.
        
        /* Ubicamos la factura del A/C */
        FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                                    x-ccbcdocu.coddoc = x-coddoc-ac AND
                                    x-ccbcdocu.nrodoc = x-nrodoc-ac AND 
                                    x-ccbcdocu.flgest <> 'A' NO-LOCK NO-ERROR.
        IF (AVAILABLE x-ccbcdocu) AND x-ccbcdocu.imptot > 0 THEN DO:
            /* Montos usados del A/C para cancelar el documento */
            x-monto-del-anticipo = x-ccbdcaja.imptot.
            x-vvta-del-anticipo = ROUND(x-monto-del-anticipo /  ( 1 + (x-ccbcdocu.porigv / 100)),2).
            x-igv-del-anticipo = x-monto-del-anticipo - x-vvta-del-anticipo.

            IF x-CodMonDocDespacho <> x-ccbdcaja.codmon THEN DO:
                IF x-CodMonDocDespacho = 2 THEN DO:
                    /* La factura del despacho esta en DOLARES y el anticipo en SOLES */
                    x-monto-del-anticipo = x-monto-del-anticipo / x-ccbdcaja.tpocmb.
                    x-vvta-del-anticipo = x-vvta-del-anticipo / x-ccbdcaja.tpocmb.
                    x-igv-del-anticipo = x-igv-del-anticipo / x-ccbdcaja.tpocmb.
                END.
                ELSE DO:
                    /* La factura del despacho esta SOLES y el anticipo en DOLARES */
                    x-monto-del-anticipo = x-monto-del-anticipo * x-ccbdcaja.tpocmb.
                    x-vvta-del-anticipo = x-vvta-del-anticipo * x-ccbdcaja.tpocmb.
                    x-igv-del-anticipo = x-igv-del-anticipo * x-ccbdcaja.tpocmb.
                END.
            END.
            x-suma-de-anticipos = x-suma-de-anticipos + x-monto-del-anticipo.
            x-suma-vvta-de-anticipos = x-suma-vvta-de-anticipos + x-vvta-del-anticipo.
            x-suma-igv-de-anticipos = x-suma-igv-de-anticipos + x-igv-del-anticipo.

            x-orden-anticipo = x-orden-anticipo + 1.

            IF NOT (pRetTXT = "") THEN pRetTXT = pRetTXT + "*".  /* Otra Linea */

            pRetTXT = pRetTXT + "A|".                               /* ("indicador","A") */
            pRetTXT = pRetTXT + STRING(x-orden-anticipo) + "|".     /* ("numeroOrdenAnticipo",STRING(x-orden-anticipo) */
            pRetTXT = pRetTXT + "6|".                               /* ("tipoDocumentoEmisorAnticipo","6") */
            pRetTXT = pRetTXT + cRucEmpresa + "|".                  /* ("numeroDocumentoEmisorAnticipo",cRucEmpresa) */
            pRetTXT = pRetTXT + "02|".                              /* ("tipoDocumentoAnticipo","02") */

            x-serie-numero-anticipo = fget-prefijo-de-la-serie(x-ccbcdocu.coddoc,x-ccbcdocu.nrodoc,"") +
                                SUBSTRING(x-ccbcdocu.nrodoc,1,3) + "-" + SUBSTRING(x-ccbcdocu.nrodoc,4).

            /* AAAA-MM-DD */
            x-fecha-pago = STRING(YEAR(x-ccbdcaja.fchdoc),"9999") + "-" + STRING(MONTH(x-ccbdcaja.fchdoc),"99") + "-" + STRING(DAY(x-ccbdcaja.fchdoc),"99").

            pRetTXT = pRetTXT + x-serie-numero-anticipo + "|".                      /* ("serieNumeroDocumentoAnticipo",x-serie-numero-anticipo) */
            pRetTXT = pRetTXT + STRING(x-monto-del-anticipo,">>>>>>>9.99") + "|".   /* ("totalPrepagadoAnticipo",STRING(x-monto-del-anticipo,">>>>>>>9.99")) */
            pRetTXT = pRetTXT + x-fecha-pago + "|".                                 /* ("fechaPago",x-fecha-pago) */
            pRetTXT = pRetTXT + STRING(x-vvta-del-anticipo,">>>>>>>9.99") + "|".    /* ValorVenta anticipo*/
            pRetTXT = pRetTXT + STRING(x-igv-del-anticipo,">>>>>>>9.99").           /* Igv Anticipo */

        END.
    END.
END.

IF x-suma-de-anticipos <= 0 THEN DO:
    x-suma-de-anticipos = 0.
    x-suma-vvta-de-anticipos = 0.
    x-suma-igv-de-anticipos = 0.
    pRetTXT = "".
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-B2B_Sede-Cliente) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE B2B_Sede-Cliente Procedure 
PROCEDURE B2B_Sede-Cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pDireccion AS CHAR.
DEF INPUT PARAMETER pNomDepto AS CHAR.
DEF INPUT PARAMETER pNomProvi AS CHAR.
DEF INPUT PARAMETER pNomDistr AS CHAR.
DEF INPUT PARAMETER pReferenceAddress AS CHAR.
DEF INPUT PARAMETER pTelephoneContactReceptor AS CHAR.
DEF INPUT PARAMETER pContactReceptorName AS CHAR.
DEF OUTPUT PARAMETER pSede AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* Consistencia del ubigeo */
DEF VAR pCodDepto AS CHAR NO-UNDO.
DEF VAR pCodProvi AS CHAR NO-UNDO.
DEF VAR pCodDistr AS CHAR NO-UNDO.

DEF VAR x-Cuenta AS INTE NO-UNDO.

ASSIGN
    pSede = ''.
RLOOP:
FOR EACH TabDepto NO-LOCK WHERE TabDepto.NomDepto BEGINS pNomDepto:
    FOR EACH TabProvi NO-LOCK WHERE TabProvi.CodDepto = TabDepto.CodDepto
        AND TabProvi.NomProvi BEGINS pNomProvi:
        FOR EACH TabDistr NO-LOCK WHERE TabDistr.CodDepto = TabDepto.CodDepto
            AND TabDistr.CodProvi = TabProvi.CodProvi
            AND INDEX(TabDistr.NomDistr, pNomDistr) > 0:
            /* Lo encontré */
            ASSIGN
                pCodDepto = TabDistr.CodDepto 
                pCodProvi = TabDistr.CodProvi 
                pCodDistr = TabDistr.CodDistr.
            LEAVE RLOOP.
        END.
    END.
END.
/* Si no hay información entonces NO se registra */
IF TRUE <> (pCodDepto > '') THEN RETURN.
/* ********************************************* */

DEF VAR x-correlativo AS INT INIT 0.

DEF BUFFER x-gn-clied FOR gn-clied.

/* RHC Control de Sede del Cliente */
FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = pCodCli NO-LOCK NO-ERROR.
/* Buscamos por la dirección, no hay el dato de la sede */
FIND FIRST gn-clied OF gn-clie WHERE gn-clied.DirCli = pDireccion NO-LOCK NO-ERROR.

IF NOT AVAILABLE gn-clied THEN DO:
    /* Sede NO registrada */
    FOR EACH x-gn-clieD OF gn-clie NO-LOCK:
        IF x-gn-clieD.sede <> '@@@' THEN DO:
            ASSIGN 
                x-correlativo = MAXIMUM(INTEGER(TRIM(x-gn-clieD.sede)),x-correlativo)
                NO-ERROR.
        END.
    END.
    CREATE gn-clied.
    ASSIGN
        Gn-ClieD.CodCia = gn-clie.codcia
        Gn-ClieD.CodCli = gn-clie.codcli
        Gn-ClieD.FchCreacion = TODAY
        Gn-ClieD.Sede = STRING(x-correlativo + 1,"9999")
        /*Gn-ClieD.SedeClie = pIDCustomer*/
        Gn-ClieD.UsrCreacion = s-user-id
        Gn-ClieD.DomFiscal = NO
        Gn-ClieD.SwSedeSunat = "M"   /* MANUAL */
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
        UNDO, RETURN.
    END.
END.
ELSE DO:
    FIND CURRENT gn-clied EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR THEN DO:
        {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
        UNDO, RETURN.
    END.
END.
ASSIGN
    Gn-ClieD.CodDept = pCodDepto
    Gn-ClieD.CodDist = pCodDistr
    Gn-ClieD.CodProv = pCodProvi
    Gn-ClieD.DirCli  = pDireccion
    Gn-ClieD.Referencias = pReferenceAddress
    Gn-ClieD.Libre_c04 = pTelephoneContactReceptor 
    Gn-ClieD.Libre_c05 = pContactReceptorName.
FIND TabDistr WHERE TabDistr.CodDepto = Gn-ClieD.CodDept AND
    TabDistr.CodProvi = Gn-ClieD.CodProv AND
    TabDistr.CodDistr = Gn-ClieD.CodDist
    NO-LOCK NO-ERROR.
IF AVAILABLE TabDistr THEN DO:
    ASSIGN
        Gn-ClieD.Codpos = TabDistr.CodPos NO-ERROR.
END.
ASSIGN
    pSede = Gn-ClieD.Sede.      /* OJO */
RELEASE gn-clied.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Carga-Tempo-por-RA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Tempo-por-RA Procedure 
PROCEDURE Carga-Tempo-por-RA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAMETER s-CodDoc AS CHAR.         /* OTR */
  DEF INPUT PARAMETER lAlmDespacho AS CHAR.
  DEF INPUT PARAMETER lDivDespacho AS CHAR.

  DEFINE VARIABLE I-NPEDI AS INTEGER NO-UNDO.
  DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
  DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE s-StkComprometido AS DEC.
  DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.
  DEFINE VARIABLE F-CANPED AS DECIMAL NO-UNDO.
  DEFINE VARIABLE x-StkAct AS DEC NO-UNDO.
  DEFINE VARIABLE x-CodAlm AS CHAR NO-UNDO.
  DEFINE VARIABLE i AS INT NO-UNDO.

  i-NPedi = 0.
  /* ************************************************* */
  /* RHC 23/08/17 Simplificación del proceso Max Ramos */
  /* ************************************************* */
  DEF VAR t-AlmDes AS CHAR NO-UNDO.
  DEF VAR t-CanPed AS DEC NO-UNDO.

  FIND B-ALM WHERE B-ALM.codcia = s-codcia AND B-ALM.codalm = B-CREPO.codalm NO-LOCK.
  FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = B-ALM.coddiv NO-LOCK.
  EMPTY TEMP-TABLE PEDI.
  FOR EACH B-DREPO OF B-CREPO NO-LOCK WHERE (B-DREPO.CanApro - B-DREPO.CanAten) > 0,
      FIRST Almmmatg OF B-DREPO NO-LOCK:
      f-Factor = 1.
      t-AlmDes = ''.
      t-CanPed = 0.
      F-CANPED = (B-DREPO.CanApro - B-DREPO.CanAten).     /* OJO */
      x-CodAlm = lAlmDespacho.
      /* DEFINIMOS LA CANTIDAD */
      x-CanPed = f-CanPed * f-Factor.
      IF f-CanPed <= 0 THEN NEXT.
      IF f-CanPed > t-CanPed THEN DO:
          t-CanPed = f-CanPed.
          t-AlmDes = x-CodAlm.
      END.
      /* ******************************************************** */
      /* FILTRAMOS EL PRODUCTO DE ACUERDO AL ALMACEN SOLICITANTES */
      /* ******************************************************** */
      CASE TRUE:
          WHEN GN-DIVI.CanalVenta = "MIN" THEN DO:    /* UTILEX */
              IF NOT ( (TRUE <> (Almmmatg.TpoMrg > '')) OR Almmmatg.TpoMrg = "2" ) THEN NEXT.
          END.
          OTHERWISE DO:   /* MAYORISTAS */
/*               IF NOT ( (TRUE <> (Almmmatg.TpoMrg > '')) OR Almmmatg.TpoMrg = "1" ) THEN DO: */
/*                   NEXT.                                                                     */
/*               END.                                                                          */
          END.
      END CASE.
      /* ******************************************************** */
      /* GRABACION */
      I-NPEDI = I-NPEDI + 1.
      CREATE PEDI.
      BUFFER-COPY B-DREPO 
          EXCEPT B-DREPO.CanReq B-DREPO.CanApro
          TO PEDI
          ASSIGN 
              PEDI.CodCia = s-codcia
              PEDI.CodDiv = lDivDespacho
              PEDI.CodDoc = s-coddoc
              PEDI.NroPed = ''
              PEDI.ALMDES = t-AlmDes  /* *** OJO *** */
              PEDI.NroItm = I-NPEDI
              PEDI.CanPed = t-CanPed            /* << OJO << */
              PEDI.CanAte = 0
              PEDI.Factor = 1.                  /* Importante */
      ASSIGN
          PEDI.Libre_d01 = (B-DREPO.CanApro - B-DREPO.CanAten)
          PEDI.Libre_d02 = t-CanPed
          PEDI.Libre_c01 = '*'.
      ASSIGN
          PEDI.UndVta = Almmmatg.UndBas.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Genera-INC) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-INC Procedure 
PROCEDURE Genera-INC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER TABLE FOR T-DINCI.
DEF INPUT PARAMETER COMBO-BOX-ResponDistribucion AS CHAR. 
DEF INPUT PARAMETER pFlgEst AS CHAR.        /* G: por aprobar  P: listo */
DEF INPUT PARAMETER pUsrChq AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* ************************************************************************************** */
/* Consistencia de información */
/* ************************************************************************************** */
FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN DO:
    pMensaje = "NO se pudo ubicar la OTR".
    RETURN 'ADM-ERROR'.
END.
IF NOT CAN-FIND(FIRST Faccorre WHERE FacCorre.CodCia = s-CodCia AND 
                FacCorre.CodDiv = s-CodDiv AND 
                FacCorre.CodDoc = 'INC' AND 
                FacCorre.FlgEst = YES NO-LOCK)
    THEN DO:
    pMensaje = "NO configurado el correlativo del INC para la división " + s-coddiv.
    RETURN 'ADM-ERROR'.
END.
/* ************************************************************************************** */
/* Cargamos Valores */
/* ************************************************************************************** */
DEF VAR FILL-IN_ChkAlmOri AS CHAR    NO-UNDO.
DEF VAR FILL-IN_FchChkAlmOri AS DATE NO-UNDO.
DEF VAR FILL-IN_HorChkAlmOri AS CHAR NO-UNDO.
DEF VAR FILL-IN_CrossDocking AS LOG  NO-UNDO.
DEF VAR FILL-IN_AlmOri AS CHAR       NO-UNDO.
DEF VAR FILL-IN_AlmDes AS CHAR       NO-UNDO.
DEF VAR x-CodRef AS CHAR NO-UNDO.
DEF VAR x-NroRef AS CHAR NO-UNDO.
ASSIGN
    x-CodRef = ''
    x-NroRef = ''.
/* ************************************************************************************** */
/* Chequeador Origen: El que chequeó la OTR */
/* ************************************************************************************** */
ASSIGN
    FILL-IN_AlmOri       = Faccpedi.CodAlm
    FILL-IN_ChkAlmOri    = Faccpedi.usrchq
    FILL-IN_FchChkAlmOri = Faccpedi.fchchq 
    FILL-IN_HorChkAlmOri = Faccpedi.horchq.
ASSIGN
    FILL-IN_CrossDocking = FacCPedi.CrossDocking
    FILL-IN_AlmDes = Faccpedi.CodCli.
ASSIGN
    x-CodRef = Faccpedi.CodDoc    /* OTR */
    x-NroRef = Faccpedi.NroPed.
/* ************************************************************************************** */
/* Chqueador Destino: Chequeo módulo BarrCode */
/* ************************************************************************************** */
DEF VAR FILL-IN_ChkAlmDes AS CHAR    NO-UNDO.
DEF VAR FILL-IN_FchChkAlmDes AS DATE NO-UNDO.
DEF VAR FILL-IN_HorChkAlmDes AS CHAR NO-UNDO.
ASSIGN
    FILL-IN_ChkAlmDes = pUsrChq
    FILL-IN_FchChkAlmDes = TODAY
    FILL-IN_HorChkAlmDes = STRING(TIME, 'HH:MM:SS').
/* FIND logtabla WHERE logtabla.codcia = s-codcia AND                                        */
/*     logtabla.Tabla = "FACCPEDI" AND                                                       */
/*     logtabla.Evento = "CHKDESTINO" AND                                                    */
/*     logtabla.ValorLlave BEGINS (s-coddiv + '|' + Faccpedi.CodDoc + '|' + Faccpedi.NroPed) */
/*     NO-LOCK NO-ERROR.                                                                     */
/* IF AVAILABLE LogTabla THEN DO:                                                            */
/*     ASSIGN                                                                                */
/*         FILL-IN_ChkAlmDes = ENTRY(6, LogTabla.ValorLlave, '|')                            */
/*         FILL-IN_FchChkAlmDes = DATE(ENTRY(4, LogTabla.ValorLlave, '|'))                   */
/*         FILL-IN_HorChkAlmDes = ENTRY(5, LogTabla.ValorLlave, '|')                         */
/*         .                                                                                 */
/* END.                                                                                      */
/* ********************************************************************* */
/* DEFINIMOS EL ORIGEN: ES O NO CROSS DOCKING */
/* ********************************************************************* */
IF Faccpedi.TpoPed = "XD" AND Faccpedi.CodRef = "R/A" THEN DO:
    /* Segundo tramo del Cross Docking */
    FIND FIRST B-CPEDI WHERE B-CPEDI.CodCia = s-CodCia
        AND B-CPEDI.CodDoc = Faccpedi.CodDoc      /* OTR */
        AND B-CPEDI.CodRef = Faccpedi.CodRef      /* R/A */
        AND B-CPEDI.NroRef = Faccpedi.NroRef
        AND B-CPEDI.FlgEst = "C"
        AND B-CPEDI.CodDiv <> Faccpedi.CodDiv
        AND B-CPEDI.CrossDocking = YES
        AND B-CPEDI.AlmacenXD = Faccpedi.CodCli   /* Destino Final */
        NO-LOCK NO-ERROR.
    IF AVAILABLE B-CPEDI THEN DO:
        ASSIGN
            FILL-IN_ChkAlmOri = B-CPEDI.usrchq 
            FILL-IN_FchChkAlmOri = B-CPEDI.fchchq 
            FILL-IN_HorChkAlmOri = B-CPEDI.horchq
            FILL-IN_CrossDocking = B-CPEDI.CrossDocking 
            FILL-IN_AlmOri = B-CPEDI.CodAlm
            x-CodRef = B-CPEDI.CodDoc     /* OTR */
            x-NroRef = B-CPEDI.NroPed.
    END.
END.
DEF VAR FILL-IN_ResponAlmacen AS CHAR NO-UNDO.
FIND gn-users WHERE gn-users.CodCia = s-CodCia AND
    gn-users.User-Id = s-user-id
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-users THEN FILL-IN_ResponAlmacen = gn-users.CodPer.
/* ************************************************************************************** */
/* LOGICA PRINCIPAL */
/* ************************************************************************************** */
RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* ************************************************************************************** */
    /* Revisamos la tabla T-DINCI */
    /* ************************************************************************************** */
    FOR EACH T-DINCI:
        ASSIGN
              T-DINCI.AlmOri = FILL-IN_AlmOri
              T-DINCI.CodCia = s-CodCia
              T-DINCI.CodDiv = s-CodDiv.
        /* En cuál G/R está? */
        FOR EACH Almcmov NO-LOCK WHERE Almcmov.codcia = s-codcia AND
            Almcmov.CodRef = Faccpedi.coddoc AND
            Almcmov.NroRef = Faccpedi.nroped AND
            Almcmov.TipMov = "S" AND
            Almcmov.FlgEst <> 'A' AND 
            Almcmov.FlgSit = "R", 
            EACH Almdmov OF Almcmov NO-LOCK WHERE Almdmov.CodMat = T-DINCI.CodMat:
            T-DINCI.NroGR = STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc, '99999999').
        END.
    END.
    /* ************************************************************************************** */
    /* INICIO DE GRABACION */
    /* ************************************************************************************** */
    {lib/lock-genericov3.i ~
        &Tabla="FacCorre" ~
        &Alcance="FIRST" ~
        &Condicion="FacCorre.CodCia = s-CodCia AND ~
            FacCorre.CodDiv = s-CodDiv AND ~
            FacCorre.CodDoc = 'INC' AND ~
            FacCorre.FlgEst = YES" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        }
    /* GENERAMOS LA CABECERA Y DETALLE POR ESTE TIPO DE INCIDENCIA */
    CREATE AlmCIncidencia.
    ASSIGN
        AlmCIncidencia.CodCia = s-CodCia
        AlmCIncidencia.CodDiv = s-CodDiv
        AlmCIncidencia.NroControl = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '99999999')
        AlmCIncidencia.CodDoc = Faccpedi.CodDoc     /* OTR */
        AlmCIncidencia.NroDoc = Faccpedi.NroPed
        AlmCIncidencia.ChkAlmDes = FILL-IN_ChkAlmDes
        AlmCIncidencia.ChkAlmOri = FILL-IN_ChkAlmOri
        AlmCIncidencia.CrossDocking = FILL-IN_CrossDocking
        AlmCIncidencia.FchChkAlmDes = FILL-IN_FchChkAlmDes
        AlmCIncidencia.FchChkAlmOri = FILL-IN_FchChkAlmOri
        AlmCIncidencia.Fecha = TODAY
        AlmCIncidencia.Hora = STRING(TIME, 'HH:MM:SS')
        AlmCIncidencia.HorChkAlmDes = FILL-IN_HorChkAlmDes
        AlmCIncidencia.HorChkAlmOri = FILL-IN_HorChkAlmOri
        AlmCIncidencia.ResponAlmacen = FILL-IN_ResponAlmacen
        AlmCIncidencia.ResponDistribucion = COMBO-BOX-ResponDistribucion
        AlmCIncidencia.Usuario = s-User-Id
        AlmCIncidencia.AlmOri = FILL-IN_AlmOri
        AlmCIncidencia.AlmDes = FILL-IN_AlmDes
        AlmCIncidencia.FlgEst = pFlgEst     /* OJO */
        NO-ERROR
        .
    IF ERROR-STATUS:ERROR THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* Grabamos la División del Almacén Origen */
    FIND Almacen WHERE Almacen.codcia = s-CodCia 
        AND Almacen.CodAlm = AlmCIncidencia.AlmOri
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN DO:
        pMensaje = "Almacén ORIGEN " + AlmCIncidencia.AlmOri + " no válido".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        AlmCIncidencia.DivOri = Almacen.CodDiv.     /* Para control de aprobación */

    ASSIGN  
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /* GENERAMOS EL DETALLE */
    DEF VAR x-NroItem AS INT NO-UNDO.
    FOR EACH T-DINCI NO-LOCK WHERE T-DINCI.CanInc > 0 BY T-DINCI.NroItem:
        CREATE AlmDIncidencia.
        BUFFER-COPY T-DINCI   
            TO AlmDIncidencia
            ASSIGN
            AlmDIncidencia.CodCia = AlmCIncidencia.CodCia 
            AlmDIncidencia.CodDiv = AlmCIncidencia.CodDiv 
            AlmDIncidencia.NroControl = AlmCIncidencia.NroControl
            AlmDIncidencia.NroItem = x-NroItem + 1.
            .
        x-NroItem = x-NroItem + 1.
    END.
    /* GRABACIONES FINALES */
    RUN lib/logtabla ( "FACCPEDI", 
                       s-coddiv + '|' + faccpedi.coddoc + '|' + faccpedi.nroped + '|' + ~
                       STRING(FILL-IN_FchChkAlmDes,'99/99/9999') + '|' + FILL-IN_HorChkAlmDes + '|' + ~
                       FILL-IN_ChkAlmDes, "CHKDESTINO" ).
    /* *************************************************************************************** */
    /* SI ES POR APROBAR REGRESAMOS */
    /* *************************************************************************************** */
    IF AlmCIncidencia.FlgEst = "G" THEN LEAVE.
    /* *************************************************************************************** */
END.
IF AVAILABLE(AlmCIncidencia) THEN RELEASE AlmCIncidencia.
IF AVAILABLE(AlmDIncidencia) THEN RELEASE AlmDIncidencia.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Genera-OTR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-OTR Procedure 
PROCEDURE Genera-OTR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Rutina General de genberación de OTR */
/* Se puede originar a partir de 3 documentos:
    R/A
    O/D
    O/M
*/

DEF INPUT PARAMETER pCodDoc AS CHAR.                    /* Documento Origen */
DEF INPUT PARAMETER pRowid AS ROWID.                    /* ROWID del documento */
DEF INPUT PARAMETER pCrossDocking AS LOG.               /* Datos del cross docking */
DEF INPUT PARAMETER pAlmacenXD AS CHAR.
DEF OUTPUT PARAMETER pFechaEntrega AS DATE.             /* Devuelve la Fecha de Entrega Programado */
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.          
DEF OUTPUT PARAMETER pMensaje2 AS CHAR NO-UNDO.

DEF VAR s-CodDoc AS CHAR INIT 'OTR' NO-UNDO.
DEF VAR s-CodRef AS CHAR NO-UNDO.
DEF VAR s-NroSer AS INTE NO-UNDO.
DEF VAR s-NroDoc AS CHAR NO-UNDO.
DEF VAR lDivDespacho LIKE Almacen.CodDiv NO-UNDO.
DEF VAR lAlmDespacho LIKE B-CREPO.almped NO-UNDO.

/* PARAMETROS DE PEDIDOS PARA LA DIVISION */
DEF VAR s-FlgEmpaque LIKE GN-DIVI.FlgEmpaque.
DEF VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEF VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.

CASE pCodDoc:
    WHEN "R/A" THEN DO:
        FIND B-CREPO WHERE ROWID(B-CREPO) = pRowid NO-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE B-CREPO THEN DO:
            pMensaje = "NO se pudo ubicar la R/A".
            RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            s-CodRef = "R/A".   /* OJO */
        /* ************************************************************************************** */
        /* Almacén Destino */
        /* ************************************************************************************** */
        FIND FIRST Almacen WHERE Almacen.codcia = s-codcia
            AND Almacen.codalm = B-CREPO.CodAlm NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almacen THEN DO:
            pMensaje = 'Almacén ' + B-CREPO.CodAlm + ' NO existe'.
            RETURN "ADM-ERROR".
        END.
        FIND gn-divi WHERE gn-divi.codcia = s-codcia
            AND gn-divi.coddiv = Almacen.CodDiv
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-divi THEN DO:
            pMensaje = 'División ' + Almacen.CodDiv + ' del almacén destino NO configurada'.
            RETURN "ADM-ERROR".
        END.
        /* ************************************************************************************** */
        /* El almacén de Despacho */
        /* ************************************************************************************** */
        FIND FIRST Almacen WHERE Almacen.codcia = s-codcia
            AND Almacen.codalm = B-CREPO.almped NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almacen THEN DO:
            pMensaje = 'Almacen de despacho ' + B-CREPO.almped + ' No existe'.
            RETURN "ADM-ERROR".
        END.
        lDivDespacho = Almacen.CodDiv.
        lAlmDespacho = B-CREPO.almped.
        /* ************************************************************************************** */
        /* Control del correlativo  de la OTR */
        /* ************************************************************************************** */
        FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
            FacCorre.CodDiv = lDivDespacho AND
            FacCorre.CodDoc = S-CODDOC AND
            FacCorre.FlgEst = YES
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE FacCorre THEN DO:
            pMensaje = "Codigo de Documento " + s-coddoc + " No configurado para la division " + lDivDespacho.
            RETURN "ADM-ERROR".
        END.
        /* La serie segun el almacén de donde se desea despachar(B-CREPO.almped) segun la R/A */
        s-NroSer = FacCorre.NroSer.
        /* Datos de la División de Despacho */
        FIND gn-divi WHERE gn-divi.codcia = s-codcia
            AND gn-divi.coddiv = lDivDespacho
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-divi THEN DO:
            pMensaje = 'División ' + lDivDespacho + ' NO configurada'.
            RETURN "ADM-ERROR".
        END.
        ASSIGN
            s-DiasVtoPed = GN-DIVI.DiasVtoPed
            s-FlgEmpaque = GN-DIVI.FlgEmpaque
            s-VentaMayorista = GN-DIVI.VentaMayorista.
        /* RHC 19/10/18 Renato Lira: dividir la OTR en 2 de acuerdo al empaque Master */
        /* 1ro. Determinamos los artículos a despachar */
        RUN Carga-Tempo-por-RA (INPUT s-CodDoc,
                                INPUT lAlmDespacho,
                                INPUT lDivDespacho).
        IF NOT CAN-FIND(FIRST PEDI NO-LOCK) THEN DO:
            pMensaje = "NO hay items para generar la OTR".
            RETURN 'ADM-ERROR'.
        END.
        /* ************************************************************************************** */
        /* ************************************************************************************** */
        RUN Rutina-Master-RA (INPUT s-CodDoc,
                              INPUT s-NroSer,
                              INPUT s-CodRef,
                              INPUT lDivDespacho,
                              INPUT lAlmDespacho,
                              INPUT pCrossDocking,
                              INPUT pAlmacenXD,
                              OUTPUT pMensaje,
                              OUTPUT pMensaje2,
                              OUTPUT pFechaEntrega).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar la OTR'.
            RETURN 'ADM-ERROR'.
        END.
        /* ************************************************************************************** */
    END.
    WHEN "O/D" OR WHEN "O/M" THEN DO:
    END.
    OTHERWISE DO:
        pMensaje = "El primer parámetro debe ser R/A, O/D u O/M".
    END.
END CASE.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(B-CREPO)  THEN RELEASE B-CREPO.
IF pMensaje > '' THEN DO:
    pMensaje2 = ''.
    RETURN 'ADM-ERROR'.
END.
ELSE RETURN 'OK'.

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Genera-Pedido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pedido Procedure 
PROCEDURE Genera-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE I-NPEDI AS INTEGER NO-UNDO INIT 0.
  DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
  DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE s-StkComprometido AS DEC.
  DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.

  DEF VAR f-PreBas AS DEC NO-UNDO.
  DEF VAR f-PreVta AS DEC NO-UNDO.
  DEF VAR f-Dsctos AS DEC NO-UNDO.
  DEF VAR y-Dsctos AS DEC NO-UNDO.
  DEF VAR SW-LOG1  AS LOGI NO-UNDO.
  DEF VAR x-StkAct AS DEC NO-UNDO.

  /* POR CADA PEDI VOLVEMOS A VERIFICAR EL STOCK DISPONIBLE */
  /* Borramos data sobrante */
  FOR EACH PEDI WHERE PEDI.CanPed <= 0:
      DELETE PEDI.
  END.

  /* AHORA SÍ GRABAMOS EL PEDIDO */
  FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK BY PEDI.NroItm: 
      I-NPEDI = I-NPEDI + 1.
      /* RHC No hay límite de items 
      IF I-NPEDI > 52 THEN LEAVE.
      */
      CREATE Facdpedi.
      BUFFER-COPY PEDI 
          TO Facdpedi
          ASSIGN
              Facdpedi.CodCia = Faccpedi.CodCia
              Facdpedi.CodDiv = Faccpedi.CodDiv
              Facdpedi.AlmDes = Faccpedi.CodAlm
              Facdpedi.coddoc = Faccpedi.coddoc
              Facdpedi.NroPed = Faccpedi.NroPed
              Facdpedi.FchPed = Faccpedi.FchPed
              Facdpedi.Hora   = Faccpedi.Hora 
              Facdpedi.FlgEst = "P"     /*Faccpedi.FlgEst*/
              FacDPedi.CanPick = FacDPedi.CanPed
              Facdpedi.NroItm = I-NPEDI.
      DELETE PEDI.
  END.
  IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
  /* verificamos que al menos exista 1 item grabado */
  FIND FIRST Facdpedi OF Faccpedi NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Facdpedi 
  THEN RETURN 'ADM-ERROR'.
  ELSE RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Genera-RA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-RA Procedure 
PROCEDURE Genera-RA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pFchEnt AS DATE.
DEF INPUT PARAMETER pCodDiv AS CHAR.    /* Almacén solicitante */
DEF INPUT PARAMETER pCodAlm AS CHAR.    /* Almacén solicitante */
DEF INPUT PARAMETER pIncidencia AS CHAR.    /* Tipo de Incidencia */
DEF INPUT PARAMETER pAlmPed AS CHAR.    /* Almacén Despacho */        
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR s-CodDoc AS CHAR INIT 'R/A' NO-UNDO.
DEF VAR s-TipMov AS CHAR INIT "INC" NO-UNDO.

FIND FIRST Faccorre WHERE Faccorre.codcia = s-codcia
    AND Faccorre.coddoc = s-coddoc
    AND Faccorre.flgest = YES
    AND Faccorre.coddiv = pCodDiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccorre THEN DO:
    pMensaje = 'No se encuentra el correlativo para la división ' + s-coddoc + ' ' + pCodDiv.
    RETURN "ADM-ERROR".
END.

/* OJO con la hora */
/* RUN gn/p-fchent (TODAY, STRING(TIME,'HH:MM:SS'), pFchEnt, pCodDiv, pCodAlm, OUTPUT pMensaje). */
/* IF pMensaje <> '' THEN RETURN 'ADM-ERROR'.                                                    */

/* RHC 30.07.2014 Se va a limitar a 52 itesm por pedido */
DEF VAR n-Items AS INT NO-UNDO.
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i
        &Tabla="FacCorre"
        &Alcance="FIRST"
        &Condicion="Faccorre.codcia = s-codcia ~
            AND Faccorre.coddoc = s-coddoc ~
            AND Faccorre.flgest = YES ~
            AND Faccorre.coddiv = pCodDiv"
        &Bloqueo="EXCLUSIVE-LOCK"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"
        }
    CREATE Almcrepo.
    ASSIGN
        almcrepo.CodCia = s-CodCia
        almcrepo.CodAlm = pCodAlm
        almcrepo.TipMov = s-TipMov          /* OJO: Manual Automático */
        almcrepo.NroSer = Faccorre.nroser
        almcrepo.NroDoc = Faccorre.correlativo
        almcrepo.AlmPed = pAlmPed
        almcrepo.FchDoc = TODAY
        almcrepo.FchVto = TODAY + 7
        almcrepo.Fecha = pFchEnt    /* Ic 13May2015*/
        almcrepo.Hora = STRING(TIME, 'HH:MM')
        almcrepo.Usuario = s-user-id
        almcrepo.CodRef = "INC"                         /* OJO */
        almcrepo.NroRef = b-AlmCIncidencia.NroControl     /* OJO */
        almcrepo.Incidencia = pIncidencia
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "ERROR el el correlativo de " + s-CodDoc.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        Faccorre.correlativo = Faccorre.correlativo + 1
        n-Items = 0.
    /* RHC 21/04/2016 Almacén de despacho CD? */
    ASSIGN
        Almcrepo.FlgSit = "G".   /* Por Autorizar por Abastecimientos */
    /* ************************************** */
    n-Items = 0.
    FOR EACH T-DINCI NO-LOCK WHERE T-DINCI.Incidencia = pIncidencia AND T-DINCI.CanInc > 0,
        FIRST Almmmatg OF T-DINCI NO-LOCK BY T-DINCI.NroItem:
        CREATE Almdrepo.
        ASSIGN
            almdrepo.ITEM   = n-Items + 1
            almdrepo.CodCia = almcrepo.codcia
            almdrepo.CodAlm = almcrepo.codalm
            almdrepo.TipMov = almcrepo.tipmov
            almdrepo.NroSer = almcrepo.nroser
            almdrepo.NroDoc = almcrepo.nrodoc
            almdrepo.AlmPed = almcrepo.almped
            almdrepo.Origen = "AUT"
            almdrepo.CodMat = T-DINCI.CodMat 
            almdrepo.CanGen = T-DINCI.CanInc * T-DINCI.Factor 
            almdrepo.CanReq = almdrepo.cangen
            almdrepo.CanApro = almdrepo.cangen
            .
        n-Items = n-Items + 1.
    END.
END.
IF AVAILABLE(Faccorre) THEN RELEASE Faccorre.
IF AVAILABLE(Almcrepo) THEN RELEASE Almcrepo.
IF AVAILABLE(Almdrepo) THEN RELEASE Almdrepo.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Genera-SubOrden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-SubOrden Procedure 
PROCEDURE Genera-SubOrden :
/*------------------------------------------------------------------------------
  Purpose:     Generar SUBORDENES para O/D y OTR 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pDivDespacho AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* Se supone que el puntero está en el registro correcto */
DEF BUFFER b-Faccpedi FOR Faccpedi.
FIND b-Faccpedi WHERE ROWID(b-Faccpedi) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE b-Faccpedi THEN RETURN 'ADM-ERROR'.

DEFINE VAR lSector AS CHAR.

DEFINE VAR lSectorG0 AS LOG.
DEFINE VAR lSectorOK AS LOG.
DEFINE VAR lUbic AS CHAR.

/* 
    Para aquellos articulos cuya ubicacion no sea correcta SSPPMMN
    SS : Sector
    PP : Pasaje
    MM : Modulo
    N  : Nivel (A,B,C,D,E,F)
*/
lSectorG0 = NO.

FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = pDivDespacho NO-LOCK.

/*CASE gn-divi.Campo-Char[6]:*/
CASE TRUE:
    /* Picking por Sectores */
    WHEN gn-divi.Campo-Char[6] = "SE" OR WHEN b-Faccpedi.CodDiv = "00017"   /* Canal Moderno */
        THEN DO:
        /*IF b-Faccpedi.FlgSit <> "T" THEN RETURN 'OK'.     /* NO pasa nada */*/
        RLOOP:
        DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
            /* El SECTOR forma parte del código de ubicación */
            FOR EACH Facdpedi OF b-Faccpedi NO-LOCK,
                FIRST almmmate NO-LOCK WHERE Almmmate.CodCia = facdpedi.codcia
                    AND Almmmate.CodAlm = facdpedi.almdes
                    AND Almmmate.codmat = facdpedi.codmat
                BREAK BY SUBSTRING(Almmmate.CodUbi,1,2):
                IF FIRST-OF(SUBSTRING(Almmmate.CodUbi,1,2)) THEN DO:
                    /* Ic - 29Nov2016, G- = G0 */
                    lSector = CAPS(SUBSTRING(Almmmate.CodUbi,1,2)).
                    lUbic = TRIM(Almmmate.CodUbi).
                    lSectorOK = NO.
                    /* Si el sector es Correcto y el codigo de la ubicacion esta OK */
                    /* 18May2017 Felix Perez creo una nueva ZONA (07) */
                    IF (lSector >= '01' AND lSector <= '07') AND LENGTH(lUbic) = 7 THEN DO:
                        /* Ubic Ok */
                        lSectorOK = YES.
                    END.
                    ELSE DO:
                        lSector = "G0".
                    END.        
                    /* Ic - 29Nov2016, FIN  */
                    IF lSectorOK = YES OR lSectorG0 = NO THEN DO:
                        CREATE vtacdocu.
                        BUFFER-COPY b-Faccpedi TO vtacdocu
                            ASSIGN 
                            VtaCDocu.CodCia = b-Faccpedi.codcia
                            VtaCDocu.CodDiv = b-Faccpedi.coddiv
                            VtaCDocu.CodPed = b-Faccpedi.coddoc
                            VtaCDocu.NroPed = b-Faccpedi.nroped + '-' + lSector
                            VtaCDocu.FlgEst = 'P'   /* APROBADO */
                            NO-ERROR.
                        IF ERROR-STATUS:ERROR = YES THEN DO:
                            pMensaje = "Error al grabar la suborden " + b-Faccpedi.nroped + '-' + SUBSTRING(Almmmate.CodUbi,1,2).
                            UNDO RLOOP, RETURN 'ADM-ERROR'.
                        END.
                        ASSIGN
                            Vtacdocu.Glosa = b-Faccpedi.Glosa.    /* OJO */
                        IF lSector = 'G0' THEN lSectorG0 = YES.
                    END.
                END.
                CREATE vtaddocu.
                BUFFER-COPY facdpedi TO vtaddocu
                    ASSIGN
                    VtaDDocu.CodCia = VtaCDocu.codcia
                    VtaDDocu.CodDiv = VtaCDocu.coddiv
                    VtaDDocu.CodPed = VtaCDocu.codped
                    VtaDDocu.NroPed = b-Faccpedi.nroped + '-' + lSector /*VtaCDocu.nroped*/
                    VtaDDocu.CodUbi = Almmmate.CodUbi.
            END.
        END.
    END.
    /* Picking por Rutas */
    WHEN gn-divi.Campo-Char[6]= "PR" THEN DO:
    END.
END CASE.
IF AVAILABLE vtacdocu THEN RELEASE vtacdocu.
IF AVAILABLE vtaddocu THEN RELEASE vtaddocu.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-INC_Generacion_RAs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE INC_Generacion_RAs Procedure 
PROCEDURE INC_Generacion_RAs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER  pRowid AS ROWID.
DEF INPUT PARAMETER TABLE FOR T-DINCI.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.    

FIND b-AlmCIncidencia WHERE ROWID(b-AlmCIncidencia) = pRowid NO-LOCK.
/* *************************************************************************************** */
/* GENERACION DE LA R/A */
/* TANTAS R/A COMO INCIDENCIAS HAYA */
/* *************************************************************************************** */
DEF VAR pCodDiv AS CHAR NO-UNDO.
DEF VAR pCodAlm AS CHAR NO-UNDO.
DEF VAR pAlmPed AS CHAR NO-UNDO.
DEF VAR pIncidencia AS CHAR NO-UNDO.

pMensaje = ''.
FOR EACH AlmDIncidencia OF b-AlmCIncidencia NO-LOCK BREAK BY AlmDIncidencia.Incidencia:
    IF FIRST-OF(AlmDIncidencia.Incidencia) THEN DO:
        pIncidencia = AlmDIncidencia.Incidencia.
        CASE pIncidencia:
            WHEN 'S' THEN DO:   /* Sobrante */
                pCodAlm = b-AlmCIncidencia.AlmDes. 
                pAlmPed = b-AlmCIncidencia.AlmOri.
                FIND Almacen WHERE Almacen.codcia = s-CodCia 
                    AND Almacen.CodAlm = pCodAlm
                    NO-LOCK.
                pCodDiv = Almacen.CodDiv.
                RUN Genera-RA (TODAY + 1,
                               pCodDiv,
                               pCodAlm,
                               pIncidencia,
                               pAlmPed,
                               OUTPUT pMensaje).
                IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                    IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo generar la R/A".
                    UNDO, RETURN 'ADM-ERROR'.
                END.
            END.
            WHEN 'F' OR WHEN 'M'THEN DO:   /* Faltante o Mal Estado */
                pCodAlm = b-AlmCIncidencia.AlmOri.
                pAlmPed = b-AlmCIncidencia.AlmDes.
                FIND Almacen WHERE Almacen.codcia = s-CodCia 
                    AND Almacen.CodAlm = pCodAlm
                    NO-LOCK.
                pCodDiv = Almacen.CodDiv.
                RUN Genera-RA (TODAY + 1,
                               pCodDiv,
                               pCodAlm,
                               pIncidencia,
                               pAlmPed,
                               OUTPUT pMensaje).
                IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                    IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo generar la R/A".
                    UNDO, RETURN 'ADM-ERROR'.
                END.
            END.
        END CASE.
    END.
END.
RETURN 'OK'.
/* *************************************************************************************** */
/* *************************************************************************************** */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-LF_Comision) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LF_Comision Procedure 
PROCEDURE LF_Comision :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAMETER pCodCli AS CHAR.
  DEF INPUT PARAMETER pImpTot AS DEC.
  DEF INPUT PARAMETER pCodMon AS INT.
  DEF OUTPUT PARAMETER pComision AS DEC.

  DEF VAR xTCCompra AS DEC NO-UNDO.
  DEF VAR xTCVenta AS DEC NO-UNDO.
  
  FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= TODAY NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb THEN
      ASSIGN
      xTCCompra = gn-tcmb.compra 
      xTCVenta  = gn-tcmb.venta.

  FIND VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
      VtaTabla.Tabla = "%COMIECOM" AND
      VtaTabla.Llave_c1 = pCodCli
      NO-LOCK NO-ERROR.
  IF AVAILABLE VtaTabla AND (VtaTabla.Valor[2] + VtaTabla.Valor[3]) > 0 THEN DO:
      /* Comision porcentual */
      pComision = pImpTot * VtaTabla.Valor[3] / 100.
      /* Comision fija */
      IF VtaTabla.Valor[1] = pCodMon THEN DO:
          pComision = pComision + VtaTabla.Valor[2].
      END.
      ELSE DO:
          IF pCodMon = 1 THEN DO:
              pComision = pComision + ROUND(VtaTabla.Valor[2] * xTCVenta, 2).
          END.
          ELSE DO:
              pComision = pComision + ROUND(VtaTabla.Valor[2] / xTCCompra, 2).
          END.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ML_Actualiza-FAC-Control) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ML_Actualiza-FAC-Control Procedure 
PROCEDURE ML_Actualiza-FAC-Control :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Con el dato de la factura actualizamos el control por O/D
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER pRowid AS ROWID.        /* FAC */
    DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    DEF BUFFER B-CDOCU FOR Ccbcdocu.
    DEF BUFFER B-DDOCU FOR Ccbddocu.

    FIND B-CDOCU WHERE ROWID(B-CDOCU) = pRowid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CDOCU THEN RETURN 'OK'.
    IF LOOKUP(B-CDOCU.Libre_c01, 'O/D,OTR') = 0 THEN RETURN 'OK'.

    DEF BUFFER B-OD-CONTROLC FOR Faccpedi.
    DEF BUFFER B-OD-CONTROLD FOR Facdpedi.

    pMensaje = ''.
    RLOOP:
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        FIND B-OD-CONTROLC WHERE B-OD-CONTROLC.CodCia = s-CodCia
            AND B-OD-CONTROLC.CodDoc = (IF B-CDOCU.Libre_c01 = "O/D" THEN "ODP" ELSE "OTP")
            AND B-OD-CONTROLC.NroPed = B-CDOCU.Libre_c02
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-OD-CONTROLC THEN RETURN 'OK'.
        FOR EACH B-DDOCU OF B-CDOCU NO-LOCK:
            FIND FIRST B-OD-CONTROLD OF B-OD-CONTROLC WHERE B-OD-CONTROLD.CodMat = B-DDOCU.CodMat
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE B-OD-CONTROLD THEN NEXT.
            FIND CURRENT B-OD-CONTROLD EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF ERROR-STATUS:ERROR THEN DO:
                {lib/mensaje-de-error.i &MensajeError="pMensaje"}
                 UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
            ASSIGN
                B-OD-CONTROLD.CanAte = B-OD-CONTROLD.CanAte + (B-DDOCU.CanDes * B-DDOCU.Factor).
        END.
    END.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ML_Actualiza-Fifo-Control) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ML_Actualiza-Fifo-Control Procedure 
PROCEDURE ML_Actualiza-Fifo-Control :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Buscamos las O/D y los # de Serie para actualizar el FIFO
------------------------------------------------------------------------------*/

/* NOTA: esta rutina debe correr una vez que ya se haya actualizado el almacén */

    DEF INPUT PARAMETER pRowid AS ROWID.        /* FAC */
    DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    DEF BUFFER B-CDOCU FOR Ccbcdocu.
    DEF BUFFER B-DDOCU FOR Ccbddocu.
    

    FIND B-CDOCU WHERE ROWID(B-CDOCU) = pRowid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CDOCU THEN RETURN 'OK'.
    IF LOOKUP(B-CDOCU.Libre_c01, 'O/D,OTR') = 0 THEN RETURN 'OK'.

    pMensaje = ''.
    RLOOP:
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        /* Barremos todos los artículos que han descargado almacén */
        FOR EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = B-CDOCU.CodCia
                AND Almcmov.CodRef = B-CDOCU.CodDoc     /* FAC */
                AND Almcmov.NroRef = B-CDOCU.NroDoc
                AND Almcmov.TipMov = "S"                /* Salida por venta */
                AND Almcmov.FlgEst <> "A",
            EACH Almdmov OF Almcmov NO-LOCK:
            /* Barremos todas la HPK relacionadas */
            FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-CodCia
                    AND VtaCDocu.CodRef = B-CDOCU.Libre_c01     /* O/D */
                    AND VtaCDocu.NroRef = B-CDOCU.Libre_c02
                    /*AND VtaCDocu.CodDiv = s-CodDiv*/
                    AND VtaCDocu.CodPed = "HPK"
                    AND VtaCDocu.FlgEst <> "A",
                EACH logisdchequeo NO-LOCK WHERE logisdchequeo.CodCia = VtaCDocu.CodCia
                    AND logisdchequeo.CodDiv = VtaCDocu.CodDiv
                    AND logisdchequeo.CodPed = VtaCDocu.CodPed
                    AND logisdchequeo.NroPed = VtaCDocu.NroPed
                    AND logisdchequeo.CodMat = Almdmov.CodMat   /* OJO */
                    AND logisdchequeo.SerialNumber > '':
                /* Ubicamos los punteros */
                FIND FIRST fifommatg WHERE fifommatg.CodCia = s-CodCia
                    AND fifommatg.CodMat = Almdmov.CodMat
                    AND fifommatg.SerialNumber = logisdchequeo.SerialNumber
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE fifommatg THEN NEXT.
                FIND FIRST fifommate WHERE fifommate.CodCia = s-CodCia
                    AND fifommate.CodAlm = Almcmov.CodAlm
                    AND fifommate.CodMat = Almdmov.CodMat
                    AND fifommate.SerialNumber = logisdchequeo.SerialNumber
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE fifommate THEN DO:
                    FIND FIRST fifommate WHERE fifommate.CodCia = s-CodCia
                        AND fifommate.CodMat = Almdmov.CodMat
                        AND fifommate.SerialNumber = logisdchequeo.SerialNumber
                        /*AND fifommate.StkAct >= (logisdchequeo.CanChk * logisdchequeo.Factor)*/
                        NO-LOCK NO-ERROR.
                END.
                IF NOT AVAILABLE fifommate THEN DO:
                    pMensaje = "NO se puede actualizar el control de series del artículo: " + Almdmov.CodMat.
                     UNDO RLOOP, RETURN 'ADM-ERROR'.
                END.
                FIND CURRENT fifommate EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                IF NOT AVAILABLE fifommate THEN DO:
                    {lib/mensaje-de-error.i &MensajeError="pMensaje"}
                     UNDO RLOOP, RETURN 'ADM-ERROR'.
                END.
                ASSIGN
                    fifommate.StkAct = fifommate.StkAct - (logisdchequeo.CanChk * logisdchequeo.Factor).
                CREATE fifodmov.
                BUFFER-COPY Almdmov TO fifodmov
                ASSIGN
                    fifodmov.CanDes = logisdchequeo.CanChk 
                    fifodmov.Factor = logisdchequeo.Factor
                    fifodmov.FchDoc = TODAY
                    fifodmov.SerialNumber = logisdchequeo.SerialNumber.
            END.
        END.
    END.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ML_Actualiza-TRF-Control) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ML_Actualiza-TRF-Control Procedure 
PROCEDURE ML_Actualiza-TRF-Control :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER pRowid AS ROWID.        /* TRF Almcmov */
    DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    DEF BUFFER B-CMOV FOR Almcmov.
    DEF BUFFER B-DMOV FOR Almdmov.

    FIND B-CMOV WHERE ROWID(B-CMOV) = pRowid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CMOV THEN RETURN 'OK'.
    IF LOOKUP(B-CMOV.CodRef, 'O/D,OTR') = 0 THEN RETURN 'OK'.

    DEF BUFFER B-OD-CONTROLC FOR Faccpedi.
    DEF BUFFER B-OD-CONTROLD FOR Facdpedi.

    pMensaje = ''.
    RLOOP:
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        FIND B-OD-CONTROLC WHERE B-OD-CONTROLC.CodCia = s-CodCia
            AND B-OD-CONTROLC.CodDoc = (IF B-CMOV.CodRef = "O/D" THEN "ODP" ELSE "OTP")
            AND B-OD-CONTROLC.NroPed = B-CMOV.NroRef
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-OD-CONTROLC THEN RETURN 'OK'.
        FOR EACH B-DMOV OF B-CMOV NO-LOCK:
            FIND FIRST B-OD-CONTROLD OF B-OD-CONTROLC WHERE B-OD-CONTROLD.CodMat = B-DMOV.CodMat
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE B-OD-CONTROLD THEN NEXT.
            FIND CURRENT B-OD-CONTROLD EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF ERROR-STATUS:ERROR THEN DO:
                {lib/mensaje-de-error.i &MensajeError="pMensaje"}
                 UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
            ASSIGN
                B-OD-CONTROLD.CanAte = B-OD-CONTROLD.CanAte + (B-DMOV.CanDes * B-DMOV.Factor).
        END.
    END.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ML_Extorna-FAC-Control) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ML_Extorna-FAC-Control Procedure 
PROCEDURE ML_Extorna-FAC-Control :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER pRowid AS ROWID.        /* FAC */
    DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    DEF BUFFER B-CDOCU FOR Ccbcdocu.
    DEF BUFFER B-DDOCU FOR Ccbddocu.

    FIND B-CDOCU WHERE ROWID(B-CDOCU) = pRowid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CDOCU THEN RETURN 'OK'.
    IF LOOKUP(B-CDOCU.Libre_c01, 'O/D,OTR') = 0 THEN RETURN 'OK'.

    DEF BUFFER B-OD-CONTROLC FOR Faccpedi.
    DEF BUFFER B-OD-CONTROLD FOR Facdpedi.

    pMensaje = ''.
    RLOOP:
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        FIND FIRST B-OD-CONTROLC WHERE B-OD-CONTROLC.CodCia = s-CodCia
            AND B-OD-CONTROLC.CodDoc = (IF B-CDOCU.Libre_c01 = "O/D" THEN "ODP" ELSE "OTP")
            AND B-OD-CONTROLC.NroPed = B-CDOCU.Libre_c02
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-OD-CONTROLC THEN RETURN 'OK'.
        FOR EACH B-DDOCU OF B-CDOCU NO-LOCK:
            FIND FIRST B-OD-CONTROLD OF B-OD-CONTROLC WHERE B-OD-CONTROLD.CodMat = B-DDOCU.CodMat
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE B-OD-CONTROLD THEN NEXT.

            FIND CURRENT B-OD-CONTROLD EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF ERROR-STATUS:ERROR THEN DO:
                {lib/mensaje-de-error.i &MensajeError="pMensaje"}
                 UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
            
            ASSIGN
                B-OD-CONTROLD.CanAte = B-OD-CONTROLD.CanAte - (B-DDOCU.CanDes * B-DDOCU.Factor).
            
        END.
    END.

    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ML_Extorna-Fifo-Control) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ML_Extorna-Fifo-Control Procedure 
PROCEDURE ML_Extorna-Fifo-Control :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* NOTA: ejecutarlo antes de anular los movimientos de almacén */

    DEF INPUT PARAMETER pRowid AS ROWID.        /* FAC */
    DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    DEF BUFFER B-CDOCU FOR Ccbcdocu.
    DEF BUFFER B-DDOCU FOR Ccbddocu.
    

    FIND B-CDOCU WHERE ROWID(B-CDOCU) = pRowid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CDOCU THEN RETURN 'OK'.
    IF LOOKUP(B-CDOCU.Libre_c01, 'O/D,OTR') = 0 THEN RETURN 'OK'.

    pMensaje = ''.
    RLOOP:
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        /* Barremos todos los artículos que han descargado almacén */
        FOR EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = B-CDOCU.CodCia
                AND Almcmov.CodRef = B-CDOCU.CodDoc     /* FAC */
                AND Almcmov.NroRef = B-CDOCU.NroDoc
                AND Almcmov.TipMov = "S"                /* Salida por venta */
                AND Almcmov.FlgEst <> "A",
            EACH Almdmov OF Almcmov NO-LOCK:
            /* Buscamos su reflejo FIFO */
            FOR EACH fifodmov EXCLUSIVE-LOCK WHERE fifodmov.CodCia = Almdmov.CodCia
                AND fifodmov.CodAlm = Almdmov.CodAlm
                AND fifodmov.TipMov = Almdmov.TipMov
                AND fifodmov.CodMov = Almdmov.CodMov
                AND fifodmov.NroSer = Almdmov.NroSer
                AND fifodmov.NroDoc = Almdmov.NroDoc
                AND fifodmov.CodMat = Almdmov.CodMat:
                /* Ubicamos los punteros */
                FIND FIRST fifommatg WHERE fifommatg.CodCia = s-CodCia
                    AND fifommatg.CodMat = Almdmov.CodMat
                    AND fifommatg.SerialNumber = fifodmov.SerialNumber
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE fifommatg THEN NEXT.
                FIND FIRST fifommate WHERE fifommate.CodCia = s-CodCia
                    AND fifommate.CodAlm = Almcmov.CodAlm
                    AND fifommate.CodMat = Almdmov.CodMat
                    AND fifommate.SerialNumber = fifodmov.SerialNumber
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE fifommate THEN DO:
                    FIND FIRST fifommate WHERE fifommate.CodCia = s-CodCia
                        AND fifommate.CodMat = Almdmov.CodMat
                        AND fifommate.SerialNumber = fifodmov.SerialNumber
                        /*AND fifommate.StkAct >= (logisdchequeo.CanChk * logisdchequeo.Factor)*/
                        NO-LOCK NO-ERROR.
                END.
                IF NOT AVAILABLE fifommate THEN DO:
                    pMensaje = "NO se puede actualizar el control de series del artículo: " + Almdmov.CodMat.
                     UNDO RLOOP, RETURN 'ADM-ERROR'.
                END.
                FIND CURRENT fifommate EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                IF NOT AVAILABLE fifommate THEN DO:
                    {lib/mensaje-de-error.i &MensajeError="pMensaje"}
                     UNDO RLOOP, RETURN 'ADM-ERROR'.
                END.
                ASSIGN
                    fifommate.StkAct = fifommate.StkAct + (fifodmov.CanDes * fifodmov.Factor).

                DELETE fifodmov.
            END.
        END.
    END.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ML_Extorna-TRF-Control) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ML_Extorna-TRF-Control Procedure 
PROCEDURE ML_Extorna-TRF-Control :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER pRowid AS ROWID.        /* TRF Almcmov */
    DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    DEF BUFFER B-CMOV FOR Almcmov.
    DEF BUFFER B-DMOV FOR Almdmov.

    FIND B-CMOV WHERE ROWID(B-CMOV) = pRowid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CMOV THEN RETURN 'OK'.
    IF LOOKUP(B-CMOV.CodRef, 'O/D,OTR') = 0 THEN RETURN 'OK'.

    DEF BUFFER B-OD-CONTROLC FOR Faccpedi.
    DEF BUFFER B-OD-CONTROLD FOR Facdpedi.

    pMensaje = ''.
    RLOOP:
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        FIND B-OD-CONTROLC WHERE B-OD-CONTROLC.CodCia = s-CodCia
            AND B-OD-CONTROLC.CodDoc = (IF B-CMOV.CodRef = "O/D" THEN "ODP" ELSE "OTP")
            AND B-OD-CONTROLC.NroPed = B-CMOV.NroRef
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-OD-CONTROLC THEN RETURN 'OK'.
        FOR EACH B-DMOV OF B-CMOV NO-LOCK:
            FIND FIRST B-OD-CONTROLD OF B-OD-CONTROLC WHERE B-OD-CONTROLD.CodMat = B-DMOV.CodMat
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE B-OD-CONTROLD THEN NEXT.
            FIND CURRENT B-OD-CONTROLD EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF ERROR-STATUS:ERROR THEN DO:
                {lib/mensaje-de-error.i &MensajeError="pMensaje"}
                 UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
            ASSIGN
                B-OD-CONTROLD.CanAte = B-OD-CONTROLD.CanAte - (B-DMOV.CanDes * B-DMOV.Factor).
        END.
    END.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ML_Genera-OD-Control) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ML_Genera-OD-Control Procedure 
PROCEDURE ML_Genera-OD-Control :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER B-ORDENES FOR Faccpedi.        
DEF BUFFER B-ORDENESD FOR Facdpedi.
DEF BUFFER B-OD-CONTROLC FOR Faccpedi.
DEF BUFFER B-OD-CONTROLD FOR Facdpedi.

    DEF INPUT PARAMETER pRowid AS ROWID.
    DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    FIND B-ORDENES WHERE ROWID(B-ORDENES) = pRowid NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RETURN 'OK'.
    IF LOOKUP(B-ORDENES.CodDoc, 'O/D,OTR') = 0 THEN RETURN 'OK'.
    pMensaje = ''.
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        CREATE B-OD-CONTROLC.
        BUFFER-COPY B-ORDENES TO B-OD-CONTROLC 
            ASSIGN B-OD-CONTROLC.CodDoc = (IF B-ORDENES.CodDoc = "O/D" THEN "ODP" ELSE "OTP")
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje"}
             UNDO, RETURN 'ADM-ERROR'.
        END.
        FOR EACH B-ORDENESD OF B-ORDENES NO-LOCK:
            CREATE B-OD-CONTROLD.
            BUFFER-COPY B-ORDENESD TO B-OD-CONTROLD
                ASSIGN 
                B-OD-CONTROLD.CodDoc = B-OD-CONTROLC.CodDoc
                B-OD-CONTROLD.CanAte = 0.   /* OJO */
        END.
    END.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Rutina-Master-RA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rutina-Master-RA Procedure 
PROCEDURE Rutina-Master-RA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER s-CodDoc AS CHAR.
DEF INPUT PARAMETER s-NroSer AS INT.
DEF INPUT PARAMETER s-CodRef AS CHAR.
DEF INPUT PARAMETER lDivDespacho AS CHAR.
DEF INPUT PARAMETER lAlmDespacho AS CHAR.
DEF INPUT PARAMETER pCrossDocking AS LOG.
DEF INPUT PARAMETER pAlmacenXD AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pMensaje2 AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pFechaEntrega AS DATE.

DEF VAR iNroSKU      AS INT NO-UNDO.
DEF VAR iPeso        AS DEC NO-UNDO.
DEF VAR lFechaPedido AS DATE NO-UNDO.
DEF VAR s-TpoPed     AS CHAR NO-UNDO.
DEF VAR s-FlgPicking LIKE GN-DIVI.FlgPicking.
DEF VAR s-FlgBarras  LIKE GN-DIVI.FlgBarras.

pMensaje = ''.
PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Paso 02 : Adiciono el Registro en la Cabecera */
    {lib/lock-genericov3.i
        &Tabla="FacCorre"
        &Condicion="Faccorre.codcia = s-codcia
        AND Faccorre.coddoc = s-coddoc
        AND Faccorre.nroser = s-nroser"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"
        }
    /* ***************************************************************** */
    /* Determino la fecha de entrega del pedido */
    /* ***************************************************************** */
    ASSIGN
        iNroSKU = 0
        iPeso = 0.
    FOR EACH PEDI NO-LOCK, FIRST Almmmatg OF PEDI NO-LOCK:
        iNroSKU = iNroSKU + 1.
        iPeso = iPeso + (PEDI.CanPed * PEDI.Factor) * Almmmatg.PesMat.
    END.
    /* **************************************************************************** */
    /* Se toma el mayor valor de HOY y la fecha de entrega proyectada B-CREPO.Fecha */
    /* **************************************************************************** */
    lFechaPedido = MAXIMUM(TODAY, B-CREPO.Fecha).
    IF lFechaPedido = ? THEN lFechaPedido = TODAY.
    /* **************************************************************************** */
    /* Destino */
    /* **************************************************************************** */
    FIND Almacen WHERE Almacen.codcia = s-codcia AND 
        Almacen.codalm = B-CREPO.codalm NO-LOCK NO-ERROR.
    /* **************************************************************************** */
    CREATE Faccpedi.
    ASSIGN 
        Faccpedi.CodCia = S-CODCIA
        Faccpedi.CodDoc = s-coddoc 
        Faccpedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        Faccpedi.CodRef = s-codref      /* R/A */
        Faccpedi.FchPed = TODAY
        Faccpedi.CodDiv = lDivDespacho
        FacCPedi.CodAlm = lAlmDespacho
        Faccpedi.FlgEst = "X"       /* EN PROCESO */
        FacCPedi.TpoPed = s-TpoPed
        FacCPedi.FlgEnv = YES
        FacCPedi.Libre_c01 = s-User-id + '|' + STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM')
        FacCPedi.FchEnt = lFechaPedido
        Faccpedi.FchVen = lFechaPedido + 7
        Faccpedi.CodCli = B-CREPO.CodAlm
        Faccpedi.NomCli = Almacen.Descripcion
        Faccpedi.Dircli = Almacen.DirAlm
        FacCPedi.NroRef = STRING(B-CREPO.nroser,"999") + STRING(B-CREPO.nrodoc,"999999")
        FacCPedi.Glosa  = B-CREPO.Glosa
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = 'Error en el correlativo' + CHR(10) + 'No se pudo grabar la ' + s-coddoc.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* *************************************************************************** */
    /* RHC 26/10/2020 PEDIDO COMERCIAL (Cotizacion) que viene de la R/A */
    /* *************************************************************************** */
    ASSIGN
        Faccpedi.Libre_c03 = B-CREPO.Libre_c03.
    /* *************************************************************************** */
    /* RHC 21/03/2019 Motivo de la INCIDENCIA */
    /* *************************************************************************** */
    IF B-CREPO.TipMov = "INC" THEN DO:
        Faccpedi.Glosa  = "INCIDENCIA: ".
        CASE B-CREPO.Incidencia:
            WHEN "F" THEN ASSIGN Faccpedi.Glosa  = Faccpedi.Glosa + "FALTANTE".
            WHEN "S" THEN ASSIGN Faccpedi.Glosa  = Faccpedi.Glosa + "SOBRANTE".
            WHEN "M" THEN ASSIGN Faccpedi.Glosa  = Faccpedi.Glosa + "MAL ESTADO".
        END CASE.
        Faccpedi.Glosa  = Faccpedi.Glosa + " / " + s-user-id + ' ' + STRING(NOW, '99/99/9999 HH:MM:SS').
        Faccpedi.Observa = Faccpedi.Glosa.
        Faccpedi.CodOrigen = B-CREPO.CodRef.    /* INC */
        Faccpedi.NroOrigen = B-CREPO.NroRef.    /* AlmCIncidencia.NroControl */
    END.
    /* *************************************************************************** */
    /* *************************************************************************** */
    /* RHC 20/12/17 Cross Docking */
    IF pCrossDocking = YES THEN DO:
        Faccpedi.CrossDocking = YES.
        Faccpedi.AlmacenXD    = Faccpedi.CodCli.    /* Destino Final */
        Faccpedi.CodCli       = pAlmacenXD.         /* Almacén de Tránsito */
        FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = pAlmacenXD NO-LOCK NO-ERROR.
        Faccpedi.NomCli = Almacen.Descripcion.
        Faccpedi.Dircli = Almacen.DirAlm.
    END.
    /* *************************************************************************** */
    /* Ubicación del Almacén Destino */
    /* *************************************************************************** */
    ASSIGN
        FacCPedi.Ubigeo[1] = ""
        FacCPedi.Ubigeo[2] = "@ALM"
        FacCPedi.Ubigeo[3] = Faccpedi.CodCli.
    /* *************************************************************************** */
    /* Motivo */
    /* *************************************************************************** */
    ASSIGN FacCPedi.MotReposicion = B-CREPO.MotReposicion.
    ASSIGN FacCPedi.VtaPuntual = B-CREPO.VtaPuntual.
    ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /* Actualizamos la hora cuando lo vuelve a modificar */
    ASSIGN
        Faccpedi.Usuario = S-USER-ID
        Faccpedi.Hora   = STRING(TIME,"HH:MM:SS").
    /* Division destino */
    FIND Almacen OF Faccpedi NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN FacCPedi.DivDes = Almacen.CodDiv.
    /* CONTROL DE OTROS PROCESOS POR DIVISION */
    FIND gn-divi WHERE gn-divi.codcia = Faccpedi.codcia
        AND gn-divi.coddiv = Faccpedi.divdes
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN
        ASSIGN
            s-FlgPicking = GN-DIVI.FlgPicking
            s-FlgBarras  = GN-DIVI.FlgBarras.
    IF s-FlgPicking = YES THEN FacCPedi.FlgSit = "T".    /* Por Pre-Pickear */
    IF s-FlgPicking = NO AND s-FlgBarras = NO THEN FacCPedi.FlgSit = "C".    /* Barras OK */
    IF s-FlgPicking = NO AND s-FlgBarras = YES THEN FacCPedi.FlgSit = "P".   /* Pre-Picking OK */
    /* *************************************************************************** */
    /* DETALLE DE LA OTR */
    /* *************************************************************************** */
    RUN Genera-Pedido.    /* Detalle del pedido */
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = 'NO se pudo generar la OTR' + CHR(10) + 'NO hay stock suficiente en los almacenes'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* *********************************************************** */
    /* FECHA DE ENTREGA */
    /* *********************************************************** */
    RUN logis/p-fecha-de-entrega (INPUT Faccpedi.CodDoc,
                                  INPUT Faccpedi.NroPed,
                                  INPUT-OUTPUT lFechaPedido,
                                  OUTPUT pMensaje).
    IF pMensaje > '' THEN DO:
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        FacCPedi.FchEnt = lFechaPedido
        Faccpedi.FchVen = lFechaPedido + 7
        Faccpedi.FlgEst = "P".                  /* OJO >>> APROBADO */
    pFechaEntrega = lFechaPedido.               /* OJO: FECHA REPROGRAMADA */
    ASSIGN
        pMensaje2 = "ORDEN DE TRANSFERENCIA N° " + Faccpedi.NroPed + CHR(10) +
                    "Fecha de entrega: " + STRING(lFechaPedido).
    /* *********************************************************** */
    /* RHC Calculamos totales */
    /* *********************************************************** */
    ASSIGN
        Faccpedi.Items = 0          /* Items */
        Faccpedi.Peso = 0           /* Peso */
        Faccpedi.Volumen = 0.       /* Volumen */
    FOR EACH Facdpedi OF Faccpedi NO-LOCK,FIRST Almmmatg OF Facdpedi NO-LOCK:
        ASSIGN
            Faccpedi.Items = Faccpedi.Items + 1
            Faccpedi.Peso = Faccpedi.Peso + (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.PesMat)
            Faccpedi.Volumen = Faccpedi.Volumen + (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.Libre_d02 / 10000000).
    END.
    /* IMPORTES en S/ */
    ASSIGN
        Faccpedi.AcuBon[8] = Faccpedi.ImpTot * (IF Faccpedi.CodMon = 2 THEN Faccpedi.TpoCmb ELSE 1).   /* Importes */
    IF Faccpedi.CodDoc = "OTR" THEN DO:
        ASSIGN
            Faccpedi.AcuBon[8] = 0.
        FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
            ASSIGN 
                Faccpedi.AcuBon[8] = Faccpedi.AcuBon[8] + 
                    (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.CtoTot) * 
                    (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1).
        END.
    END.
    /* ************************************************************** */
    /* *********************************************************** */
    /* ACTUALIZAMOS SALDO DE LA R/A */
    /* *********************************************************** */
    RUN alm/pactualizareposicion ( ROWID(Faccpedi), "C", OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo extornar la R/A'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* *********************************************************** */
    /* TRACKING */
    RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                            Faccpedi.CodDiv,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef,
                            s-User-Id,
                            'GOT',    /* Generación OTR */
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef)
        NO-ERROR.
    /* *********************************************************** */
    RUN Genera-SubOrden (ROWID(Faccpedi),
                         INPUT Faccpedi.CodDiv,
                         OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar la sub-orden'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* *************************************************************************** */
    /* RHC 22/09/2020 Control por M.R. */
    /* *************************************************************************** */
    RUN ML_Genera-OD-Control (INPUT ROWID(Faccpedi),    /* O/D */
                              OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "ERROR: No se pudo generar el registro de control".
        UNDO, RETURN 'ADM-ERROR'.
    END.
END.
IF AVAILABLE (Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE (Facdpedi) THEN RELEASE Facdpedi.
IF AVAILABLE (Faccorre) THEN RELEASE Faccorre.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-VALIDA_AP_PATERNO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VALIDA_AP_PATERNO Procedure 
PROCEDURE VALIDA_AP_PATERNO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pApPaterno AS CHAR.
DEFINE OUTPUT PARAMETER pMensaje AS CHAR.

pMensaje = "OK".

IF InicioCaracteresValidos(SUBSTRING(pApPaterno,1,2)) = NO THEN DO:
    pMensaje = "Los primeros dos(2) digitos del Apellidos Paterno debe ser caracteres ALFABETICOS".
END.
IF LENGTH(pApPaterno) < 2 THEN DO:
    pMensaje = "El apellido paterno es invalido (demasiado corto) ".
END.

IF TieneCaracteresNoValido(pApPaterno,"CHAR.NO.VALIDO-AP") = YES THEN DO:
    pMensaje = "El Apellido Paterno tiene caracteres no validos".
END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-VALIDA_NOMBRE) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VALIDA_NOMBRE Procedure 
PROCEDURE VALIDA_NOMBRE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pNombre AS CHAR.
DEFINE OUTPUT PARAMETER pMensaje AS CHAR. 

pMensaje = "OK".

IF InicioCaracteresValidos(SUBSTRING(pNombre,1,2)) = NO THEN DO:
    pMensaje = "Los primeros dos(2) digitos del nombre debe ser caracteres ALFABETICOS".
END.
IF LENGTH(pNombre) < 2 THEN DO:
    pMensaje = "El nombre es invalido (demasiado corto) ".
END.

IF TieneCaracteresNoValido(pNombre,"CHAR.NO.VALIDO-NOM") = YES THEN DO:
    pMensaje = "El Nombre tiene caracteres no validos".
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-VALIDA_RAZON_SOCIAL) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VALIDA_RAZON_SOCIAL Procedure 
PROCEDURE VALIDA_RAZON_SOCIAL :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pRazonSocial AS CHAR.
DEFINE OUTPUT PARAMETER pMensaje AS CHAR.

pMensaje = "OK".

IF InicioCaracteresValidos(SUBSTRING(pRazonSocial,1,1)) = NO THEN DO:
    pMensaje = "El primier digito de la razon social no es valido".
END.
IF LENGTH(pRazonSocial) < 3 THEN DO:
    pMensaje = "El nombre de la razon social es invalido".
END.
IF TieneCaracteresNoValido(pRazonSocial,"CHAR.NO.VALIDO-RS") = YES THEN DO:
    pMensaje = "La Razon Social tiene caracteres no validos".
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-VTA_cmpte_linea) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VTA_cmpte_linea Procedure 
PROCEDURE VTA_cmpte_linea :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.     /*FAC,Bol,...*/
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE OUTPUT PARAMETER TABLE FOR tw-report.
DEFINE INPUT PARAMETER pGrabarEnDB AS LOG.
DEFINE OUTPUT PARAMETER pRetMsg AS CHAR.

pRetMsg = "OK".

IF LOOKUP(pCodDoc,"FAC,BOL") = 0 THEN DO:
    RETURN "OK".
END.

EMPTY TEMP-TABLE tw-report.

DEFINE VAR x-total-cmpte AS DEC INIT 0.
DEFINE VAR x-suma AS DEC INIT 0.
DEFINE VAR x-suma2 AS DEC INIT 0.

DEFINE VAR x-total-regs AS INT INIT 0.
DEFINE VAR x-reg AS INT INIT 0.

FOR EACH x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                            x-ccbcdocu.coddoc = pCodDoc AND
                            x-ccbcdocu.nrodoc = pNroDoc NO-LOCK:

    /*x-total-cmpte = x-total-cmpte + x-ccbcdocu.imptot*/    
    FOR EACH x-ccbddocu OF x-ccbcdocu NO-LOCK:
        FIND FIRST almmmatg OF x-ccbddocu NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almmmatg THEN DO:
            /* ERROR */
            EMPTY TEMP-TABLE tw-report.
            pRetMsg = "El articulo " + x-ccbddocu.codmat + " no se encuentra en el maestro ALMMMATG".
            RETURN "ADM-ERROR".
        END.

        x-total-cmpte = x-total-cmpte + x-ccbddocu.implin.

        FIND FIRST tw-report WHERE tw-report.llave-c = almmmatg.codfam AND
                                    tw-report.campo-c[1] = almmmatg.subfam EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE tw-report THEN DO:
            CREATE tw-report.
            ASSIGN tw-report.llave-c = almmmatg.codfam
                    tw-report.campo-c[1] = almmmatg.subfam.

            x-total-regs = x-total-regs + 1.
        END.
        ASSIGN tw-report.campo-f[1] = tw-report.campo-f[1] + x-ccbddocu.implin.
        x-suma2 = x-suma2 + x-ccbddocu.implin.
    END.
END.

/* Distribuyo en proporcion */
x-reg = 1.
x-suma = 0.
FOR EACH tw-report :
    IF x-reg = x-total-regs THEN DO:
        ASSIGN tw-report.campo-f[2] = 100 - x-suma.  /* 100% */
    END.
    ELSE DO:
        ASSIGN tw-report.campo-f[2] = ROUND((tw-report.campo-f[1] / x-suma2) * 100,4).
        x-suma = x-suma + tw-report.campo-f[2].
        x-reg = x-reg + 1.
    END.
END.

IF pGrabarEnDB = NO THEN DO:
    RETURN "OK".
END.

/* Grabar en base de datos */
pRetMsg = "PROCESANDO".

DEFINE BUFFER b-cdocu-linea FOR cdocu-linea.

TRAZABILIDAD:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH cdocu-linea WHERE cdocu-linea.codcia = s-codcia AND
                                cdocu-linea.coddoc = pCodDoc AND
                                cdocu-linea.nrodoc = pNroDoc NO-LOCK:
        FIND FIRST b-cdocu-linea WHERE ROWID(b-cdocu-linea) = ROWID(cdocu-linea) EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE b-cdocu-linea THEN DO:
            DELETE b-cdocu-linea NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pRetMsg = "ERROR vta_cmpte_linea: " + cdocu-linea.codfam + " " + cdocu-linea.subfam + CHR(10) + CHR(13) +
                        "Comprobante :" + pCodDoc + " " + pNroDoc + CHR(10) + CHR(13) +
                        "MSG : " + ERROR-STATUS:GET-MESSAGE(1).

                UNDO TRAZABILIDAD, RETURN 'ADM-ERROR'.
            END.
        END.
    END.
    FOR EACH tw-report:
        CREATE b-cdocu-linea.
            ASSIGN b-cdocu-linea.codcia = s-codcia
                    b-cdocu-linea.coddoc = pCodDoc
                    b-cdocu-linea.nrodoc = pNroDoc
                    b-cdocu-linea.codfam = tw-report.llave-c
                    b-cdocu-linea.subfam = tw-report.campo-c[1]   
                    b-cdocu-linea.impfam = tw-report.campo-f[1]
                    b-cdocu-linea.factor = tw-report.campo-f[2]
                    b-cdocu-linea.usrcrea = USERID("DICTDB")
                    b-cdocu-linea.fchcrea = TODAY
                    b-cdocu-linea.horacrea = STRING(TIME,"HH:MM:SS")
                NO-ERROR.

        IF ERROR-STATUS:ERROR THEN DO:
            pRetMsg = "ERROR vta_cmpte_linea: " + tw-report.llave-c + " " + tw-report.campo-c[1] + CHR(10) + CHR(13) +
                    "Comprobante :" + pCodDoc + " " + pNroDoc + CHR(10) + CHR(13) +
                    "MSG : " + ERROR-STATUS:GET-MESSAGE(1).
    
            UNDO TRAZABILIDAD, RETURN 'ADM-ERROR'.
        END.
    
    END.
END.
RELEASE b-cdocu-linea NO-ERROR.

pRetMsg = "OK".

RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-VTA_lista_precio_segun_div_vta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VTA_lista_precio_segun_div_vta Procedure 
PROCEDURE VTA_lista_precio_segun_div_vta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDivVta AS CHAR.
DEFINE INPUT PARAMETER pTipoPed AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR.

pRetVal = "".

DEFINE VAR x-tabla AS CHAR INIT "CONFIG-VTAS".
DEFINE VAR x-llave_c1 AS CHAR INIT "DIV.VTA-LISTA.PRECIO".
DEFINE VAR x-llave_c2 AS CHAR INIT "".

FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                            x-vtatabla.tabla = x-tabla AND
                            x-vtatabla.llave_c1 = x-llave_c1 AND
                            x-vtatabla.llave_c2 = pCodDivVta NO-LOCK NO-ERROR.
IF AVAILABLE x-vtatabla THEN pRetVal = TRIM(x-vtatabla.llave_c3).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fget-doc-original) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-doc-original Procedure 
FUNCTION fget-doc-original RETURNS CHARACTER
  ( INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Se debe enviar N/C o N/D
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VAR lRetVal AS CHAR.

    DEFINE VAR lDocFactura AS CHAR.
    DEFINE VAR lDocBoleta AS CHAR.
    DEFINE VAR lDocLetra AS CHAR.

    lRetVal = ?.

    DEFINE BUFFER fx-ccbcdocu FOR ccbcdocu.
    DEFINE BUFFER fx-ccbdmvto FOR ccbdmvto.

    FIND FIRST fx-ccbcdocu USE-INDEX llave01 WHERE fx-ccbcdocu.codcia = s-codcia AND 
                                    fx-ccbcdocu.coddoc = pTipoDoc AND 
                                    fx-ccbcdocu.nrodoc = pNroDoc 
                                    NO-LOCK NO-ERROR.
    IF AVAILABLE fx-ccbcdocu THEN DO:    
        /*DISPLAY fx-ccbcdocu.coddoc fx-ccbcdocu.nrodoc fx-ccbcdocu.codref fx-ccbcdocu.nroref.*/
        IF fx-ccbcdocu.codref = 'FAC' OR fx-ccbcdocu.codref = 'BOL' OR 
                fx-ccbcdocu.codref = 'TCK' THEN DO:

            IF fx-ccbcdocu.codref = 'FAC' THEN lRetVal = 'F' + fx-ccbcdocu.nroref.
            IF fx-ccbcdocu.codref = 'BOL' OR fx-ccbcdocu.codref = 'TCK' THEN lRetVal = 'B' + fx-ccbcdocu.nroref.        

        END.
        ELSE DO:            
            IF fx-ccbcdocu.codref = 'LET' THEN DO:
                /* Como Referencia - LETRA */
                lRetVal = fget-doc-original(fx-ccbcdocu.codref, fx-ccbcdocu.nroref).
            END.
            ELSE DO:
                IF fx-ccbcdocu.codref = 'CJE' OR fx-ccbcdocu.codref = 'RNV' OR fx-ccbcdocu.codref = 'REF' THEN DO:
                    /* Si en CANJE, RENOVACION y REFINANCIACION */
                    lDocFactura = "".
                    lDocBoleta = "".
                    lDocLetra = "".
                    /*DISPLAY pTipoDoc pNroDoc.*/                    
                    FOR EACH fx-ccbdmvto WHERE fx-ccbdmvto.codcia = s-codcia AND 
                                                fx-ccbdmvto.coddoc = fx-ccbcdocu.codref AND 
                                                fx-ccbdmvto.nrodoc = fx-ccbcdocu.nroref NO-LOCK:                        
                                                
                        IF fx-ccbdmvto.nroref <> pnroDoc THEN DO:
                            IF fx-ccbdmvto.codref = 'FAC' OR fx-ccbdmvto.codref = 'BOL' THEN DO:
                                IF fx-ccbdmvto.codref = 'FAC' AND lDocFactura = "" THEN lDocFactura = "F" + fx-ccbdmvto.nroref.
                                IF fx-ccbdmvto.codref = 'BOL' AND lDocBoleta = "" THEN lDocBoleta = "B" + fx-ccbdmvto.nroref.
                                LEAVE.
                            END.
                            ELSE DO:
                                IF fx-ccbdmvto.codref = 'LET' THEN  DO:                                    
                                    lRetVal = fget-doc-original("LET", fx-ccbdmvto.nroref).
                                    /*DISPLAY fx-ccbdmvto.codref fx-ccbdmvto.nroref lRetVal.*/
                                    IF SUBSTRING(lRetVal,1,1) = 'F' OR SUBSTRING(lRetVal,1,1) = 'B' THEN DO:
                                        IF SUBSTRING(lRetVal,1,1)='F' AND lDocFactura = "" THEN lDocFactura = lRetVal.
                                        IF SUBSTRING(lRetVal,1,1)="B" AND lDocBoleta = "" THEN lDocBoleta = lRetVal.
                                        LEAVE.
                                    END.
                                END.
                            END.
                        END.
                    END.
                    
                    IF lDocFactura  = "" AND lDocBoleta = "" AND lDocLetra <> "" THEN DO:
                        /* es una LETRA */
                        /*lRetVal = fget-doc-original("LET", lDocLetra).*/
                    END.
                    ELSE DO:
                        IF lDocBoleta  <> "" THEN lRetVal = lDocBoleta.
                        IF lDocFactura  <> "" THEN lRetVal = lDocFactura.
                    END.
                END.
                /* 
                    Puede que hayan CLA : Canje x letra adelantada, pero el dia que salte ese error
                    ya se programa...
                */
                IF fx-ccbcdocu.codref = 'CLA' THEN DO:
                    /* Buscar el A/R */
                    DEFINE BUFFER zx-ccbcdocu FOR ccbcdocu.
                    FIND FIRST zx-ccbcdocu WHERE  zx-ccbcdocu.codcia = s-codcia AND 
                                                zx-ccbcdocu.coddoc = 'A/R' AND 
                                                zx-ccbcdocu.codref = "CLA" AND
                                                zx-ccbcdocu.nroref = fx-ccbcdocu.nroref 
                                                NO-LOCK NO-ERROR.
                    IF AVAILABLE zx-ccbcdocu THEN DO:
                        /**/
                        DEFINE BUFFER zx-ccbdmov FOR ccbdmov.
                        FIND FIRST zx-ccbdmov WHERE zx-ccbdmov.codcia = s-codcia AND 
                                                zx-ccbdmov.coddoc = 'A/R' AND 
                                                zx-ccbdmov.nrodoc = zx-ccbcdocu.nrodoc
                                                NO-LOCK NO-ERROR.
                        IF AVAILABLE zx-ccbdmov THEN DO:
                            /* Caja */
                            DEFINE BUFFER zx-ccbdcaja FOR ccbdcaja.
                            FOR EACH zx-ccbdcaja WHERE zx-ccbdcaja.codcia = s-codcia AND 
                                                        zx-ccbdcaja.coddoc = zx-ccbdmov.codref AND 
                                                        zx-ccbdcaja.nrodoc = zx-ccbdmov.nroref
                                                        NO-LOCK:
                                IF zx-ccbdcaja.codref = 'FAC' OR zx-ccbdcaja.codref = 'BOL' THEN DO:
                                    IF zx-ccbdcaja.codref = 'FAC' THEN lRetVal = "F" + zx-ccbdcaja.nroref.
                                    IF zx-ccbdcaja.codref = 'BOL' THEN lRetVal = "B" + zx-ccbdcaja.nroref.
                                    LEAVE.
                                END.
                            END.
                            RELEASE zx-ccbdcaja.
                        END.
                        RELEASE zx-ccbdmov.
                    END.
                    RELEASE zx-ccbcdocu.
                END.
            END.
        END.
    END.

    RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-prefijo-de-la-serie) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-prefijo-de-la-serie Procedure 
FUNCTION fget-prefijo-de-la-serie RETURNS CHARACTER
  (INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR, INPUT pDivision AS CHAR) :

    /* pDivision : Puede ser vacio */

    DEFINE VAR lxRet AS CHAR.

    lxRet = '?'.

    IF pTipoDoc = 'N/C' OR pTipoDoc = 'N/D' THEN DO:

        DEFINE BUFFER z-ccbcdocu FOR ccbcdocu.            

        IF pDivision <> "" THEN DO:
            FIND FIRST z-ccbcdocu WHERE z-ccbcdocu.codcia = s-codcia AND 
                                        z-ccbcdocu.coddiv = pDivision AND
                                        z-ccbcdocu.coddoc = pTipoDoc AND 
                                        z-ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.
        END.
        ELSE DO:
            FIND FIRST z-ccbcdocu WHERE z-ccbcdocu.codcia = s-codcia AND 
                                        z-ccbcdocu.coddoc = pTipoDoc AND 
                                        z-ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.
        END.

        IF AVAILABLE z-ccbcdocu THEN DO:
            IF z-ccbcdocu.codref = 'LET' THEN DO:
                /* la Referencia es una LETRA, es un CANJE */
                /* Devuelve el documento Original F001001255 o B145001248 */
                lxRet = fget-doc-original(z-ccbcdocu.codref, z-ccbcdocu.nroref).                
                lxRet = SUBSTRING(lxRet,1,1).
            END.
            ELSE lxRet = fGet-Prefijo-de-la-Serie(z-ccbcdocu.codref, z-ccbcdocu.nroref, "").
        END.
        ELSE lxRet = '?'.

        /*RELEASE z-ccbcdocu.*/
    END.
    ELSE DO:
        IF pTipoDoc = 'FAC' THEN lxRet = 'F'.
        IF pTipoDoc = 'BOL' OR pTipoDoc = 'TCK' THEN lxRet = 'B'.        
    END.


  RETURN lxRet.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetEsAlfabetico) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetEsAlfabetico Procedure 
FUNCTION GetEsAlfabetico RETURNS LOGICAL
  ( INPUT pCaracter AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR x-alfabetico AS CHAR.
    DEFINE VAR x-retval AS LOG INIT NO.
    DEFINE VAR x-tabla AS CHAR.

    x-alfabetico = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZabcdefghijklmnñopqrstuvwxyz".
    x-tabla = "VALIDA-CONTENIDO".

    FIND FIRST x-factabla WHERE x-factabla.codcia = s-codcia AND
                                x-factabla.tabla = x-tabla AND
                                x-factabla.codigo = "ALFABETICO" NO-LOCK NO-ERROR.
    IF AVAILABLE x-factabla THEN x-alfabetico = TRIM(x-factabla.campo-c[1]).

    IF INDEX(x-alfabetico,pCaracter) > 0 THEN x-retval = YES.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetEsNumerico) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetEsNumerico Procedure 
FUNCTION GetEsNumerico RETURNS LOGICAL
  ( INPUT pCaracter AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR x-valores AS CHAR.
    DEFINE VAR x-retval AS LOG INIT NO.

    x-valores = "0123456789.".
    
    IF INDEX(x-valores,pCaracter) > 0 THEN x-retval = YES.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-InicioCaracteresValidos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION InicioCaracteresValidos Procedure 
FUNCTION InicioCaracteresValidos RETURNS LOGICAL
  ( INPUT pTexto AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR x-caracter AS CHAR.
    DEFINE VAR x-retval AS LOG INIT YES.
    DEFINE VAR x-sec AS INT.

    VALIDACION:
    REPEAT x-sec = 1 TO LENGTH(pTexto):
        x-caracter = SUBSTRING(pTexto,x-sec,1).
        x-retval = getEsAlfabetico(x-caracter).
        IF x-retval = NO THEN DO:
            LEAVE VALIDACION.
        END.
    END.

    RETURN x-retval.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-TieneCaracteresNoValido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION TieneCaracteresNoValido Procedure 
FUNCTION TieneCaracteresNoValido RETURNS LOGICAL
  ( INPUT pTexto AS CHAR, INPUT pLlave AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR x-caract-no-validos AS CHAR.
    DEFINE VAR x-retval AS LOG INIT NO.
    DEFINE VAR x-tabla AS CHAR.
    DEFINE VAR x-caracter AS CHAR.
    DEFINE VAR x-sec AS INT.

    x-caract-no-validos = "".
    x-tabla = "VALIDA-CONTENIDO".

    FIND FIRST x-factabla WHERE x-factabla.codcia = s-codcia AND
                                x-factabla.tabla = x-tabla AND
                                x-factabla.codigo = pLlave NO-LOCK NO-ERROR.
    IF AVAILABLE x-factabla THEN x-caract-no-validos = TRIM(x-factabla.campo-c[1]).

    VALIDACION:
    REPEAT x-sec = 1 TO LENGTH(pTexto):
        x-caracter = SUBSTRING(pTexto,x-sec,1).
        
        IF INDEX(x-caract-no-validos, x-caracter) > 0 THEN DO:
            /* Tiene Caracteres NO validos */
            x-retval = YES.
            LEAVE VALIDACION.
        END.
    END.

    RETURN x-retval.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

