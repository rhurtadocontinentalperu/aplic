&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.
DEFINE NEW SHARED TEMP-TABLE T-Tickets NO-UNDO LIKE VtaDTickets.
DEFINE NEW SHARED TEMP-TABLE T-VALES NO-UNDO LIKE VtaVales.
DEFINE NEW SHARED TEMP-TABLE T-VVALE NO-UNDO LIKE VtaVVale.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT PARAMETER d_Rowid AS ROWID.

DEFINE VARIABLE s-PtoVta AS INT NO-UNDO.
DEFINE NEW SHARED VARIABLE s-codcli LIKE gn-clie.codcli.
DEFINE NEW SHARED TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.

DEF NEW SHARED VAR s-tipo   AS CHAR INITIAL "MOSTRADOR".
DEF NEW SHARED VAR s-CodMov LIKE Almtmovm.Codmov.
DEF NEW SHARED VAR s-codcja AS CHAR INITIAL "I/C".
DEF NEW SHARED VAR s-sercja AS INT.
   
DEFINE BUFFER B-CPEDM FOR FacCPedi. 
DEFINE BUFFER B-DPEDM FOR Facdpedi. 

DEFINE SHARED VAR s-User-Id AS CHAR.
DEFINE SHARED VAR s-CodCia AS INT.
DEFINE SHARED VAR CL-CodCia AS INT.
DEFINE SHARED VAR s-CodDiv AS CHAR.
DEFINE SHARED VAR s-CodTer LIKE ccbcterm.codter.
DEFINE SHARED VAR S-CODALM AS CHAR.

DEFINE NEW SHARED VAR S-CodDoc AS CHAR.

DEFINE SHARED VARIABLE s-Sunat-Activo AS LOG.

DEFINE VAR x-cto1 AS DECI INIT 0 NO-UNDO.
DEFINE VAR x-cto2 AS DECI INIT 0 NO-UNDO.

DEFINE VAR l-Ok AS LOG NO-UNDO.
DEFINE VAR i AS INTEGER INITIAL 1 NO-UNDO.

DEFINE VARIABLE monto_ret AS DECIMAL NO-UNDO.
DEFINE VARIABLE dTpoCmb LIKE CcbcCaja.TpoCmb NO-UNDO.
DEFINE VARIABLE cNomcli AS CHAR NO-UNDO.
DEFINE VARIABLE NroDocCja AS CHARACTER NO-UNDO.

DEFINE TEMP-TABLE T-CPEDM LIKE FacCPedi.
DEFINE TEMP-TABLE T-DPEDM LIKE FacDPedi.

/* Se usa para las retenciones */
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

/* Se usa para las N/C */
DEFINE NEW SHARED TEMP-TABLE wrk_dcaja NO-UNDO LIKE ccbdcaja.

/* VARIABLES PARA LA CANCELACION */
DEFINE VARIABLE list_docs   AS CHARACTER.

DEF VAR s-FechaI AS DATETIME NO-UNDO.
DEF VAR s-FechaT AS DATETIME NO-UNDO.
DEF VAR cMess   AS CHAR    NO-UNDO.
DEFINE VAR cCodAlm AS CHAR NO-UNDO.

/* TEMPORALES DE ORDENES DE DESPACHO */
DEFINE TEMP-TABLE T-CODES LIKE FacCPedi.
DEFINE TEMP-TABLE T-DODES LIKE FacDPedi.

/* TEMPORALES DE COMPROBANTES */
DEFINE TEMP-TABLE T-CDOCU LIKE CcbCDocu.
DEFINE TEMP-TABLE T-DDOCU LIKE CcbDDocu.

{ccb\i-ChqUser.i}

/* Control del documento Ingreso Caja por terminal */
FIND FIRST ccbdterm WHERE
    CcbDTerm.CodCia = s-codcia AND
    CcbDTerm.CodDiv = s-coddiv AND
    CcbDTerm.CodDoc = s-codcja AND
    CcbDTerm.CodTer = s-codter NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbdterm THEN DO:
    MESSAGE
       "EL DOCUMENTO INGRESO DE CAJA NO ESTA CONFIGURADO EN ESTE TERMINAL(" + s-codter + ")"
       VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
s-sercja = ccbdterm.nroser.

DEFINE VAR Fac_Rowid AS ROWID NO-UNDO.     /* COntrol de Cabecera de Comprobantes */

DEF VAR pMensaje AS CHAR NO-UNDO.

/* Articulo impuesto a las bolsas plasticas */
/* DEFINE VAR x-articulo-ICBPER AS CHAR. */
/*                                       */
/* x-articulo-ICBPER = "099268".         */

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
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
      TABLE: T-Tickets T "NEW SHARED" NO-UNDO INTEGRAL VtaDTickets
      TABLE: T-VALES T "NEW SHARED" NO-UNDO INTEGRAL VtaVales
      TABLE: T-VVALE T "NEW SHARED" NO-UNDO INTEGRAL VtaVVale
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 6.65
         WIDTH              = 62.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* PEDIDOS ACTIVOS MOSTRADOR */
DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.
DEFINE VARIABLE cliename    LIKE Gn-Clie.Nomcli.
DEFINE VARIABLE clieruc     LIKE Gn-Clie.Ruc.

/* Importe del pedido en pantalla */
DEFINE VARIABLE x-Importe-Control   AS DEC NO-UNDO. 

FIND Faccpedi WHERE ROWID(Faccpedi) = D_ROWID NO-LOCK NO-ERROR. 
IF NOT AVAILABLE Faccpedi THEN RETURN 'ADM-ERROR'.

/* AVISO DEL ADMINISTRADOR */
DEF VAR pRpta AS CHAR.
RUN ccb/d-msgblo (Faccpedi.codcli, Faccpedi.nrocard, OUTPUT pRpta).
IF pRpta = 'ADM-ERROR' THEN RETURN.
/* *********************** */

/* Verifica I/C */
RUN proc_verifica_ic.
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
FIND B-CPEDM WHERE ROWID(B-CPEDM) = d_rowid NO-LOCK NO-ERROR.

/* NUMERO DE SERIE DEL COMPROBANTE PARA TERMINAL */
s-CodDoc = B-CPEDM.Cmpbnte.
IF LOOKUP(s-CodDoc, 'FAC,BOL') = 0 THEN DO:
    MESSAGE "DOCUMENTO s-CodDoc='" s-CodDoc "'" SKIP "Debe ser FAC o BOL" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

FIND FIRST ccbdterm WHERE
    CcbDTerm.CodCia = s-codcia AND
    CcbDTerm.CodDiv = s-coddiv AND
    CcbDTerm.CodDoc = s-CodDoc AND
    CcbDTerm.CodTer = s-codter NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbdterm THEN DO:
    MESSAGE
        "DOCUMENTO" s-CodDoc "NO ESTA CONFIGURADO EN ESTE TERMINAL (" + s-codter + ")"
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
ASSIGN
    s-PtoVta = Ccbdterm.nroser.
FIND FIRST faccorre WHERE faccorre.codcia = s-codcia AND
    faccorre.coddoc = s-Coddoc AND
    faccorre.coddiv = s-Coddiv AND
    faccorre.NroSer = s-ptovta NO-LOCK NO-ERROR.
IF NOT AVAILABLE faccorre THEN DO:
    MESSAGE "DOCUMENTO:" s-CodDoc "SERIE:" s-ptovta SKIP
        "NO ESTA CONFIGURADO SU CORRELATIVO PARA LA DIVISION" s-coddiv
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
FIND FIRST FacDocum WHERE facdocum.codcia = s-codcia AND
    facdocum.coddoc = s-CodDoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum THEN DO:
    MESSAGE "NO ESTA DEFINIDO EL DOCUMENTO" s-CodDoc                    
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
ASSIGN
    s-CodMov = Facdocum.codmov.
FIND FIRST almtmovm WHERE Almtmovm.CodCia = s-codcia AND
    Almtmovm.Codmov = s-codmov AND
    Almtmovm.Tipmov = "S"
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE almtmovm THEN DO:
    MESSAGE "NO ESTA DEFINIDO EL MOVIMIENTO DE SALIDA" s-codmov
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
s-codCli = B-CPEDM.CodCli.
/* 09.09.09 Control de Vigencia del Pedido Mostrador */
/* Tiempo por defecto fuera de campaña */
FIND FacCfgGn WHERE Faccfggn.codcia = s-codcia NO-LOCK.
TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
          (FacCfgGn.Hora-Res * 3600) + 
          (FacCfgGn.Minu-Res * 60).
/* Tiempo dentro de campaña */
FIND FIRST FacCfgVta WHERE Faccfgvta.codcia = s-codcia
    AND Faccfgvta.coddoc = B-CPEDM.CodDoc
    AND TODAY >= Faccfgvta.fechad
    AND TODAY <= Faccfgvta.fechah
    NO-LOCK NO-ERROR.
IF AVAILABLE FacCfgVta 
THEN TimeOut = (FacCfgVta.Dias-Res * 24 * 3600) +
                (FacCfgVta.Hora-Res * 3600) + 
                (FacCfgVta.Minu-Res * 60).
IF TimeOut > 0 THEN DO:
    TimeNow = (TODAY - B-CPEDM.FchPed) * 24 * 3600.
    TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(B-CPEDM.Hora, 1, 2)) * 3600) +
              (INTEGER(SUBSTRING(B-CPEDM.Hora, 4, 2)) * 60) ).
    IF TimeNow > TimeOut THEN DO:
        MESSAGE 'El Pedido' B-CPEDM.NroPed 'está VENCIDO' SKIP
            'Fue generado el' B-CPEDM.FchPed 'a las' B-CPEDM.Hora 'horas'
            VIEW-AS ALERT-BOX WARNING.
        RETURN 'ADM-ERROR'.
    END.
END.
/* *************************************************************************************** */
/* Retenciones y N/C */
/* NO HACE NADA */
/* *************************************************************************************** */
RUN Temporal-de-Retenciones.
/* *************************************************************************************** */
/* CALCULAMOS PERCEPCION 
   Carga los siguiente campos:
    Faccpedi.AcuBon[4] = s-PorPercepcion
    Faccpedi.AcuBon[5] = pPercepcion.
*/
/* *************************************************************************************** */
RUN vta2/percepcion-por-pedido ( ROWID(B-CPEDM) ).
/* *************************************************************************************** */
/* VENTANA DE CANCELACIÓN */
/* *************************************************************************************** */

DEFINE VAR x-libre_c02_01 AS CHAR.

/* B-CPEDM.Libre_C01 Lista de Precio Caso RAPPI */
x-libre_c02_01 = B-CPEDM.Libre_C02.
IF TRUE <> (B-CPEDM.Libre_C02 > "") THEN x-libre_c02_01 = "".
x-libre_c02_01 = x-libre_c02_01 + "|" + TRIM(B-CPEDM.Libre_C01).
/* Caso Calidda */
IF B-CPEDM.CodOrigen = "PPO" 
    THEN x-Libre_c02_01 = B-CPEDM.CodOrigen + '|' + B-CPEDM.NroOrigen.

ASSIGN
    x-Importe-Control = B-CPEDM.ImpTot.      /* OJO */

RUN sunat\d-cancelar-pedido-minorista-sunat-v2.r (
        s-PtoVta,           /* Nuevo parameytro 21/03/2017 */
        B-CPEDM.codmon,     /* Moneda Documento */
        (B-CPEDM.imptot + B-CPEDM.acubon[5]),     /* Importe Total */
        monto_ret,          /* Retención */
        B-CPEDM.NomCli,     /* Nombre Cliente */
        TRUE,               /* Venta Contado */
        B-CPEDM.FlgSit,     /* Pago con Tarjeta de Crédito */
        B-CPEDM.Libre_c03,  /* Banco */
        B-CPEDM.Libre_c04,  /* Tarjeta */
        /*B-CPEDM.Libre_C02 + "|" + TRIM(B-CPEDM.Libre_C01),  */
        x-libre_c02_01,     /* Proveedor tickets + ListaPrecio RAPPI */
        B-CPEDM.Atencion,   /* DNI */
        OUTPUT L-OK).       /* Flag Retorno */
IF L-OK = NO THEN RETURN "ADM-ERROR".
/* *************************************************************************************** */
/* RUTINA PRINCIPAL */
/* Llamamos a la libreria de grabación */
/* *************************************************************************************** */
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN cja/cja-library PERSISTENT SET hProc.       /* Librerias a memoria */

EMPTY TEMP-TABLE T-FELogErrores.    /* CONTROL DE ERRORES DE FACTURACION ELECTRONICA */
EMPTY TEMP-TABLE T-CDOCU.           /* CONTROL DE COMPROBANTES GENERADOS */
RUN CJC_Canc-Min-Contado-SUNAT IN hProc (INPUT s-CodDoc,            /* BOL o FAC */                                        
                                         INPUT s-CodMov,             /* Normalmente 02 (Ventas) */
                                         INPUT s-PtoVta,             /* Nro de Serie del Comprobante */
                                         INPUT s-Tipo,              /* MOSTRADOR */
                                         INPUT s-CodTer,               /* Terminal de Caja */
                                         INPUT s-SerCja,
                                         INPUT d_Rowid,            /* Rowid del P/M */
                                         INPUT x-Importe-Control,    /* Importe Base del P/M */
                                         INPUT TABLE T-Tickets,
                                         INPUT TABLE T-Vales,
                                         INPUT TABLE wrk_dcaja,
                                         INPUT TABLE wrk_ret,
                                         INPUT TABLE T-CcbCCaja,
                                         INPUT-OUTPUT TABLE T-CDOCU,
                                         OUTPUT pMensaje).
DELETE PROCEDURE hProc.
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    pMensaje = pMensaje + (IF pMensaje > '' THEN CHR(10) ELSE '') + "Proceso Abortado. Vuelta a intentarlo en un momento".
    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
IF pMensaje > '' AND pMensaje <> 'OK' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX INFORMATION.

/* Configurado para QR */
RUN proc_impresion.

/* DEFINE VAR x-version AS CHAR.                                                                          */
/* DEFINE VAR x-formato-tck AS LOG.                                                                       */
/* DEFINE VAR x-imprime-directo AS LOG.                                                                   */
/* DEFINE VAR x-nombre-impresora AS CHAR.                                                                 */
/*                                                                                                        */
/* FOR EACH T-CDOCU NO-LOCK, FIRST CcbCDocu OF T-CDOCU NO-LOCK BY T-CDOCU.NroDoc:                         */
/*     x-version = 'L'.                                                                                   */
/*     x-formato-tck = YES.        /* YES : Formato Ticket,  NO : Formato A4 */                           */
/*     x-imprime-directo = YES.                                                                           */
/*     x-nombre-impresora = "".                                                                           */
/*     /* pVersion: "O":ORIGINAL  "C":COPIA  "R":RE-IMPRESION  "L":CLiente  "A":Control Administrativo */ */
/*     RUN sunat\r-impresion-doc-electronico-sunat (INPUT CcbCDocu.CodDiv,                                */
/*                                                  INPUT CcbCDocu.coddoc,                                */
/*                                                  INPUT CcbCDocu.nrodoc,                                */
/*                                                  INPUT x-version,                                      */
/*                                                  INPUT x-formato-tck,                                  */
/*                                                  INPUT x-imprime-directo,                              */
/*                                                  INPUT x-nombre-impresora).                            */
/* END.                                                                                                   */
/* /* RHC IMPRESION DE PROMOCIONES CRUZADAS */                                                            */
/* RUN vta2/p-imprime-prom-cruzada (d_Rowid,                                                              */
/*                                  x-formato-tck,                                                        */
/*                                  x-imprime-directo,                                                    */
/*                                  x-nombre-impresora).                                                  */

RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-proc_impresion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_impresion Procedure 
PROCEDURE proc_impresion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Configurado para QR */
DEFINE VAR x-version AS CHAR.
DEFINE VAR x-formato-tck AS LOG.
DEFINE VAR x-imprime-directo AS LOG.
DEFINE VAR x-nombre-impresora AS CHAR.

FOR EACH T-CDOCU NO-LOCK, FIRST CcbCDocu OF T-CDOCU NO-LOCK BY T-CDOCU.NroDoc:
    x-version = 'L'.
    x-formato-tck = YES.        /* YES : Formato Ticket,  NO : Formato A4 */
    x-imprime-directo = YES.
    x-nombre-impresora = "".
    /* pVersion: "O":ORIGINAL  "C":COPIA  "R":RE-IMPRESION  "L":CLiente  "A":Control Administrativo */
    RUN sunat\r-impresion-doc-electronico-sunat (INPUT CcbCDocu.CodDiv, 
                                                 INPUT CcbCDocu.coddoc, 
                                                 INPUT CcbCDocu.nrodoc,
                                                 INPUT x-version,
                                                 INPUT x-formato-tck,
                                                 INPUT x-imprime-directo,
                                                 INPUT x-nombre-impresora).
END.
/* RHC IMPRESION DE PROMOCIONES CRUZADAS */  
RUN vta2/p-imprime-prom-cruzada (d_Rowid,
                                 x-formato-tck,
                                 x-imprime-directo,
                                 x-nombre-impresora).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_verifica_ic) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_verifica_ic Procedure 
PROCEDURE proc_verifica_ic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lFoundIC AS LOGICAL NO-UNDO.

    /* Busca I/C tipo "Sencillo" Activo */
    lFoundIC = FALSE.
    FOR EACH ccbccaja WHERE
        ccbccaja.codcia = s-codcia AND
        ccbccaja.coddiv = s-coddiv AND 
        ccbccaja.tipo = "SENCILLO" AND
        ccbccaja.codcaja = s-codter AND
        ccbccaja.usuario = s-user-id AND
        ccbccaja.coddoc = "I/C" AND
        ccbccaja.flgcie = "P" NO-LOCK:
        IF CcbCCaja.FlgEst <> "A" THEN lFoundIC = TRUE.
    END.
    IF NOT lFoundIC THEN DO:
        MESSAGE
            "Se debe ingresar el I/C SENCILLO como primer movimiento"
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Temporal-de-Retenciones) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Temporal-de-Retenciones Procedure 
PROCEDURE Temporal-de-Retenciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE dTpoCmb     LIKE CcbcCaja.TpoCmb NO-UNDO.

/* Retenciones */
EMPTY TEMP-TABLE wrk_ret.
/* N/C */
EMPTY TEMP-TABLE wrk_dcaja.
/* RHC 19/12/2015 Bloqueado a solicitud de Susana Leon */
RETURN.
/* *************************************************** */
/*
    IF B-CPEDM.CodDoc = "FAC" AND       /* Solo Facturas */
        B-CPEDM.ImpTot > 0 THEN DO:
        /* Tipo de Cambio Caja */
        dTpoCmb = 1.
        FIND LAST Gn-tccja WHERE Gn-tccja.Fecha <= TODAY NO-LOCK NO-ERROR.
        IF AVAILABLE Gn-tccja THEN DO:
            IF B-CPEDM.Codmon = 1 THEN dTpoCmb = Gn-tccja.Compra.
            ELSE dTpoCmb = Gn-tccja.Venta.
        END.
        FIND gn-clie WHERE
            gn-clie.codcia = cl-codcia AND
            gn-clie.codcli = B-CPEDM.CodCli
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie AND gn-clie.rucold = "Si" THEN DO:     /* AGENTE RETENEDOR */
            CREATE wrk_ret.
            ASSIGN
                wrk_ret.CodCia = B-CPEDM.Codcia
                wrk_ret.CodCli = B-CPEDM.CodCli
                wrk_ret.CodDoc = B-CPEDM.CodDoc
                wrk_ret.NroDoc = B-CPEDM.NroPed
                wrk_ret.FchDoc = B-CPEDM.FchPed
                wrk_ret.CodRef = s-CodCja                    
                wrk_ret.NroRef = ""
                wrk_ret.CodMon = "S/."
                cNomcli = gn-clie.nomcli.
            /* OJO: Cálculo de Retenciones Siempre en Soles */
            IF B-CPEDM.Codmon = 1 THEN DO:
                wrk_ret.ImpTot = B-CPEDM.imptot.
                wrk_ret.ImpRet = ROUND((wrk_ret.ImpTot * (6 / 100)),2).
            END.
            ELSE DO:
                wrk_ret.ImpTot = ROUND((B-CPEDM.imptot * dTpoCmb),2).
                wrk_ret.ImpRet = ROUND((wrk_ret.ImpTot * (6 / 100)),2).
            END.
        END.
    END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

