&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE ITEM NO-UNDO LIKE FacDPedi.
DEFINE NEW SHARED TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.
DEFINE TEMP-TABLE T-CDOCU NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE T-DDOCU NO-UNDO LIKE CcbDDocu.
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.
DEFINE NEW SHARED TEMP-TABLE T-VVALE NO-UNDO LIKE VtaVVale.
DEFINE NEW SHARED TEMP-TABLE wrk_dcaja NO-UNDO LIKE CcbDCaja.



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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-tpoped AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-codter LIKE ccbcterm.codter.
DEF SHARED VAR s-codcja AS CHAR.    /* I/C */
DEF SHARED VAR s-ptovta AS INT.

DEF SHARED VAR s-sercja AS INT.
DEF SHARED VAR s-tipo   AS CHAR.    /* MOSTRADOR */


/* Librerias

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
      TABLE: ITEM T "NEW SHARED" NO-UNDO INTEGRAL FacDPedi
      TABLE: T-CcbCCaja T "NEW SHARED" ? INTEGRAL CcbCCaja
      TABLE: T-CDOCU T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: T-DDOCU T "?" NO-UNDO INTEGRAL CcbDDocu
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
      TABLE: T-VVALE T "NEW SHARED" NO-UNDO INTEGRAL VtaVVale
      TABLE: wrk_dcaja T "NEW SHARED" NO-UNDO INTEGRAL CcbDCaja
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 7.92
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Cancel_Invoice) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cancel_Invoice Procedure 
PROCEDURE Cancel_Invoice :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF PARAMETER BUFFER B-CPEDM FOR Faccpedi.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

pMensaje = "".
RUN Validate_Time (BUFFER B-CPEDM, OUTPUT pMensaje).
IF pMensaje > '' THEN RETURN.

/* *************************************************************************************** */
/* Valores Iniciales */
/* *************************************************************************************** */
ASSIGN s-CodDoc = B-CPEDM.Cmpbnte.

DEF VAR d_rowid  AS ROWID NO-UNDO.
DEF VAR s-CodMov AS INTE NO-UNDO.
DEF VAR list_docs AS CHAR NO-UNDO.

d_rowid = ROWID(B-CPEDM).

/* *************************************************************************************** */
/* Verifica SENCILLO EN CAJA */
/* *************************************************************************************** */
/* Busca I/C tipo "Sencillo" Activo */
DEFINE VARIABLE lFoundIC AS LOGICAL NO-UNDO.

IF NOT s-codter BEGINS "ATE" THEN DO:
    lFoundIC = FALSE.
    FOR EACH ccbccaja WHERE ccbccaja.codcia = s-codcia AND
        ccbccaja.coddiv = s-coddiv AND 
        ccbccaja.tipo = "SENCILLO" AND
        ccbccaja.codcaja = s-codter AND
        ccbccaja.usuario = s-user-id AND
        ccbccaja.coddoc = "I/C" AND
        ccbccaja.flgcie = "P" NO-LOCK:
        IF CcbCCaja.FlgEst <> "A" THEN lFoundIC = TRUE.
    END.
    IF NOT lFoundIC THEN pMensaje = "Se debe ingresar el I/C SENCILLO como primer movimiento".
END.
IF s-user-id = 'ADMIN' AND pMensaje > "" THEN pMensaje = "".
IF pMensaje > "" THEN RETURN.
/* *************************************************************************************** */
/* Verifica Terminal */
/* *************************************************************************************** */
FIND FIRST ccbdterm WHERE CcbDTerm.CodCia = s-codcia AND
    CcbDTerm.CodDiv = s-coddiv AND
    CcbDTerm.CodDoc = s-CodDoc AND
    CcbDTerm.CodTer = s-codter NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbdterm THEN DO:
    pMensaje = "DOCUMENTO " + s-CodDoc + " NO ESTA CONFIGURADO EN ESTE TERMINAL: " + s-CodTer.
    RETURN.
END.
ASSIGN
    s-PtoVta = Ccbdterm.nroser.     /* Serie configurada para este terminal */
FIND faccorre WHERE faccorre.codcia = s-codcia AND
    faccorre.coddoc = s-Coddoc AND
    faccorre.coddiv = s-Coddiv AND
    faccorre.NroSer = s-ptovta AND
    faccorre.flgest = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE faccorre THEN DO:
    pMensaje = "DOCUMENTO: " + s-CodDoc + "SERIE: " + STRING(s-ptovta,'999') + CHR(10) +
        "NO ESTA CONFIGURADO SU CORRELATIVO PARA LA DIVISION " + s-coddiv.
    RETURN.
END.
FIND FacDocum WHERE facdocum.codcia = s-codcia AND facdocum.coddoc = s-CodDoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum THEN DO:
    pMensaje = "NO ESTA DEFINIDO EL DOCUMENTO " + s-CodDoc.
    RETURN.
END.
ASSIGN
    s-CodMov = Facdocum.codmov.     /* MOvimiento de salida del almacén, normalmente 02 */
FIND almtmovm WHERE Almtmovm.CodCia = s-codcia AND
    Almtmovm.Codmov = s-codmov AND
    Almtmovm.Tipmov = "S"
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE almtmovm THEN DO:
    pMensaje = "NO ESTA DEFINIDO EL MOVIMIENTO DE SALIDA " + STRING(s-codmov,'99').
    RETURN.
END.

/* *************************************************************************************** */
/* VENTANA DE CANCELACIÓN */
/* *************************************************************************************** */
DEF VAR x-Importe-Control AS DECI NO-UNDO.
DEF VAR monto_ret AS DECI NO-UNDO.
DEF VAR L-OK AS LOG NO-UNDO.

ASSIGN
    x-Importe-Control = B-CPEDM.ImpTot.      /* OJO */

RUN ccb\d-canc-mayorista-cont-v21 (
    B-CPEDM.codmon,     /* Moneda Documento */
    (B-CPEDM.imptot + B-CPEDM.acubon[5]),     /* Importe Total */
    monto_ret,          /* Retención */
    B-CPEDM.NomCli,     /* Nombre Cliente */
    TRUE,               /* Venta Contado */
    B-CPEDM.FlgSit,     /* Pago con Tarjeta de Crédito */
    OUTPUT L-OK).       /* Flag Retorno */

IF L-OK = NO THEN RETURN "OK".

/* *************************************************************************************** */
/* RUTINA PRINCIPAL */
/* Llamamos a la libreria de grabación */
/* *************************************************************************************** */
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN cja/cja-library PERSISTENT SET hProc.       /* Librerias a memoria */

EMPTY TEMP-TABLE T-FELogErrores.    /* CONTROL DE ERRORES DE FACTURACION ELECTRONICA */
EMPTY TEMP-TABLE T-CDOCU.           /* CONTROL DE COMPROBANTES GENERADOS */

RUN CJC_Canc-May-Contado-SUNAT IN hProc (INPUT s-CodDoc,            /* BOL o FAC */                                        
                                         INPUT s-CodMov,             /* Normalmente 02 (Ventas) */
                                         INPUT s-PtoVta,             /* Nro de Serie del Comprobante */
                                         INPUT s-Tipo,              /* MOSTRADOR */
                                         INPUT s-CodTer,               /* Terminal de Caja */
                                         INPUT s-SerCja,
                                         INPUT d_Rowid,            /* Rowid del P/M */
                                         INPUT x-Importe-Control,    /* Importe Base del P/M */
                                         INPUT TABLE ITEM,
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
/* *************************************************************************************** */
/* *************************************************************************************** */
list_docs = ''.
FOR EACH T-CDOCU NO-LOCK:
    /* Lista de Docs para el Message */
    IF list_docs = "" THEN list_docs = T-CDOCU.coddoc + " " + T-CDOCU.nrodoc.
    ELSE list_docs = list_docs + CHR(10) + T-CDOCU.coddoc + " " + T-CDOCU.nrodoc.
END.
MESSAGE list_docs SKIP "CONFIRMAR IMPRESION DE DOCUMENTO(S)" VIEW-AS ALERT-BOX INFORMATION.
/* *************************************************************************************** */
/* IMPRIME FACTURAS O BOLETAS Y SUS ORDENES DE DESPACHO */
/* Configurado para QR */
/* *************************************************************************************** */
DEFINE VAR x-version AS CHAR.
DEFINE VAR x-formato-tck AS LOG.
DEFINE VAR x-imprime-directo AS LOG.
DEFINE VAR x-nombre-impresora AS CHAR.

DEF VAR hPrinter AS HANDLE NO-UNDO.
RUN sunat\r-print-electronic-doc-sunat PERSISTENT SET hPrinter.

DEF VAR hPrinterOM AS HANDLE NO-UNDO.
RUN vtagn/r-print-pedido-ventas PERSISTENT SET hPrinterOM.

DEF VAR pMsgPrint AS CHAR NO-UNDO.
FOR EACH T-CDOCU NO-LOCK, FIRST CcbCDocu OF T-CDOCU NO-LOCK BY T-CDOCU.NroDoc:
    x-version = 'L'.
    x-formato-tck = NO.        /* YES : Formato Ticket,  NO : Formato A4 */
    x-imprime-directo = YES.
    x-nombre-impresora = "".
    /* pVersion: "O": ORIGINAL "C": COPIA "R": RE-IMPRESION "L" : CLiente "A" : Control Administrativo */
    /* CLIENTE */
    {gn/i-print-electronic-doc-sunat.i}
    /* Si la venta no es al contado, emitir CONTROL ADMINISTRATIVO */
    IF ccbcdocu.fmapgo <> '000' THEN DO:
        /* CONTROL ADMINISTRATIVO */
        x-version = 'A'.
        x-formato-tck = NO.        /* YES : Formato Ticket,  NO : Formato A4 */
        {gn/i-print-electronic-doc-sunat.i}
    END.
    /*-----------------------------------------------*/
    /* Orden de Despacho */
    FIND FIRST Ccbddocu OF Ccbcdocu NO-LOCK NO-ERROR.
    IF AVAIL CcbDdocu THEN DO:
        RUN PED_Print_Document IN hPrinterOM (ROWID(Ccbcdocu),
                                              "ORIGINAL",
                                              OUTPUT pMsgPrint).
        IF pMsgPrint <> "OK" AND pMsgPrint > "" THEN MESSAGE pMsgPrint VIEW-AS ALERT-BOX WARNING.
    END.
END.
DELETE PROCEDURE hPrinter.
DELETE PROCEDURE hPrinterOM.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Descuentos_Finales) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos_Finales Procedure 
PROCEDURE Descuentos_Finales PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF PARAMETER BUFFER B-CPEDI FOR Faccpedi.
  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  /* ************************************************************************************** */
  /* DESCUENTOS APLICADOS A TODO EL PEDIDO */
  /* ************************************************************************************** */
  /*05/03/2024: C.Camus */
  DEF VAR hProc AS HANDLE NO-UNDO.
  RUN vtagn/ventas-library PERSISTENT SET hProc.

  {web/i-descuentos-finales-v2.i &Tabla="B-CPEDI" &Condicion="IF FacTabla.Campo-L[2] = NO THEN NEXT."}

  DELETE PROCEDURE hProc.

  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Validate_Time) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Validate_Time Procedure 
PROCEDURE Validate_Time :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF PARAMETER BUFFER bFaccpedi FOR Faccpedi.
DEF OUTPUT PARAMETER pcError AS CHAR NO-UNDO.

pcError = "".

/* *************************************************************************************** */
/* 09.09.09 Control de Vigencia del Pedido Mostrador */
/* Tiempo por defecto fuera de campaña */
/* *************************************************************************************** */
DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.

FIND FacCfgGn WHERE Faccfggn.codcia = s-codcia NO-LOCK.
TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
    (FacCfgGn.Hora-Res * 3600) + 
    (FacCfgGn.Minu-Res * 60).
/* Tiempo dentro de campaña */
FIND FIRST FacCfgVta WHERE Faccfgvta.codcia = s-codcia
    AND Faccfgvta.coddoc = bFaccpedi.CodDoc
    AND TODAY >= Faccfgvta.fechad
    AND TODAY <= Faccfgvta.fechah
    NO-LOCK NO-ERROR.
IF AVAILABLE FacCfgVta 
    THEN TimeOut = (FacCfgVta.Dias-Res * 24 * 3600) +
                    (FacCfgVta.Hora-Res * 3600) + 
                    (FacCfgVta.Minu-Res * 60).
IF TimeOut > 0 THEN DO:
    TimeNow = (TODAY - bFaccpedi.FchPed) * 24 * 3600.
    TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(bFaccpedi.Hora, 1, 2)) * 3600) +
                                 (INTEGER(SUBSTRING(bFaccpedi.Hora, 4, 2)) * 60) ).
    IF TimeNow > TimeOut THEN DO:       
        pcError = 'El Pedido ' + bFaccpedi.NroPed + ' está VENCIDO' + CHR(10) +
            'Fue generado el ' +  STRING(bFaccpedi.FchPed) + ' a las ' + bFaccpedi.Hora + ' horas'.
        RETURN.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Write_Header) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Write_Header Procedure 
PROCEDURE Write_Header :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF PARAMETER BUFFER bFaccpedi FOR Faccpedi.
DEF OUTPUT PARAMETER pcError AS CHAR NO-UNDO.

DEF BUFFER bFacdpedi FOR Facdpedi.
DEF VAR iCuenta AS INTE NO-UNDO.

DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    /* BLOQUEAMOS CABECERA NUEVAMENTE: Se supone que solo un vendedor está manipulando la cotización */
    FIND CURRENT bFaccpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES  THEN DO:
        {lib/mensaje-de-error.i &CuentaError="iCuenta" &MensajeError="pcError"}
        UNDO, LEAVE.
    END.

    /* ************************************************************************** */
    /* NOTA: Descuento por Encarte y Descuento por Vol. x Linea SON EXCLUYENTES,
            es decir, NO pueden darse a la vez, o es uno o es el otro */
    /* ************************************************************************** */
    RUN Descuentos_Finales (BUFFER bFaccpedi, OUTPUT pcError).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pcError > '') THEN pcError = 'ERROR al aplicar los descuentos totales a la cotización'.
        UNDO, LEAVE.
    END.

    /* ****************************************************************************************** */
    /* Grabamos Totales */
    /* ****************************************************************************************** */
    RUN Write_Totals (BUFFER bFaccpedi, OUTPUT pcError).
    IF pcError > '' THEN UNDO, LEAVE.
    /* ****************************************************************************************** */
/*     /* Cancelamos el comprobante */                                                                                       */
/*     ASSIGN s-CodDoc = bFacCPedi.Cmpbnte.                                                                                  */
/*     RUN Cancel_Invoice (BUFFER bFaccpedi,                                                                                 */
/*                         OUTPUT pcError).                                                                                  */
/*     IF pcError = "CANCELACION ANULADA POR EL USUARIO" THEN DO:                                                            */
/*         MESSAGE pcError SKIP(1)                                                                                           */
/*             "Desea seguir registrado más artículos?" VIEW-AS ALERT-BOX QUESTION                                           */
/*             BUTTONS YES-NO UPDATE rpta AS LOG.                                                                            */
/*         IF rpta = YES THEN pcError = "CANCEL".                                                                            */
/*     END.                                                                                                                  */
/*     IF pcError > "" AND pcError <> "CANCEL" THEN bFaccpedi.FlgEst = "A".    /* Cualquier error o si se cancela el pago */ */
END.
IF ERROR-STATUS:ERROR AND pcError = "" THEN DO:
    {lib/mensaje-de-error.i &CuentaError="iCuenta" &MensajeError="pcError"}
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Write_Totals) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Write_Totals Procedure 
PROCEDURE Write_Totals PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEF PARAMETER BUFFER B-CPEDI FOR Faccpedi.
  DEF OUTPUT PARAMETER pcError AS CHAR NO-UNDO.

  DEF BUFFER B-DPEDI FOR Facdpedi.


  {vtagn/totales-cotizacion-sunat.i &Cabecera="B-CPEDI" &Detalle="B-DPEDI"}

  /* ****************************************************************************************** */
  /* Importes SUNAT */
  /* ****************************************************************************************** */
  DEF VAR hProc AS HANDLE NO-UNDO.

  pcError = "".
  RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
  RUN tabla-Faccpedi IN hProc (INPUT B-CPEDI.CodDiv,
                               INPUT B-CPEDI.CodDoc,
                               INPUT B-CPEDI.NroPed,
                               OUTPUT pcError).
  DELETE PROCEDURE hProc.
  IF pcError = "OK" THEN pcError = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

