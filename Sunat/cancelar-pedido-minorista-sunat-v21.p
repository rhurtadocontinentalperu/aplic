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
       "EL DOCUMENTO INGRESO DE CAJA NO ESTA CONFIGURADO EN ESTE TERMINAL"
       VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
s-sercja = ccbdterm.nroser.

DEFINE VAR Fac_Rowid AS ROWID NO-UNDO.     /* COntrol de Cabecera de Comprobantes */

DEF VAR pMensaje AS CHAR NO-UNDO.

/* Articulo impuesto a las bolsas plasticas */
DEFINE VAR x-articulo-ICBPER AS CHAR.

x-articulo-ICBPER = "099268".

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
         HEIGHT             = 8.77
         WIDTH              = 72.29.
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
        "DOCUMENTO" s-CodDoc "NO ESTA CONFIGURADO EN ESTE TERMINAL"
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
s-PtoVta = Ccbdterm.nroser.
FIND faccorre WHERE faccorre.codcia = s-codcia AND
    faccorre.coddoc = s-Coddoc AND
    faccorre.coddiv = s-Coddiv AND
    faccorre.NroSer = s-ptovta NO-LOCK NO-ERROR.
IF NOT AVAILABLE faccorre THEN DO:
    MESSAGE "DOCUMENTO:" s-CodDoc "SERIE:" s-ptovta SKIP
        "NO ESTA CONFIGURADO SU CORRELATIVO PARA LA DIVISION" s-coddiv
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

FIND FacDocum WHERE
    facdocum.codcia = s-codcia AND
    facdocum.coddoc = s-CodDoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum THEN DO:
    MESSAGE
        "NO ESTA DEFINIDO EL DOCUMENTO" s-CodDoc                    
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
s-CodMov = Facdocum.codmov.
FIND almtmovm WHERE
    Almtmovm.CodCia = s-codcia AND
    Almtmovm.Codmov = s-codmov AND
    Almtmovm.Tipmov = "S"
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE almtmovm THEN DO:
    MESSAGE
        "NO ESTA DEFINIDO EL MOVIMIENTO DE SALIDA" s-codmov
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
/* **************************************************** */
/* Retenciones y N/C */
RUN Temporal-de-Retenciones.

/* CALCULAMOS PERCEPCION */
RUN vta2/percepcion-por-pedido ( ROWID(B-CPEDM) ).

/* VENTANA DE CANCELACIÓN */
x-Importe-Control = B-CPEDM.ImpTot.      /* OJO */
RUN sunat\d-cancelar-pedido-minorista-sunat-v2 (
        s-PtoVta,           /* Nuevo parameytro 21/03/2017 */
        B-CPEDM.codmon,     /* Moneda Documento */
        (B-CPEDM.imptot + B-CPEDM.acubon[5]),     /* Importe Total */
        monto_ret,          /* Retención */
        B-CPEDM.NomCli,     /* Nombre Cliente */
        TRUE,               /* Venta Contado */
        B-CPEDM.FlgSit,     /* Pago con Tarjeta de Crédito */
        B-CPEDM.Libre_c03,  /* Banco */
        B-CPEDM.Libre_c04,  /* Tarjeta */
        B-CPEDM.Libre_C02,  /* Proveedor tickets */
        B-CPEDM.Atencion,   /* DNI */
        OUTPUT L-OK).       /* Flag Retorno */

IF L-OK = NO THEN RETURN "ADM-ERROR".

/* ************************************************************ */
/* NOTA: VAMOS A DIVIDIR LAS TRANSACCIONES EN SUB-TRANSACCIONES */
/* ************************************************************ */
/* 1ra. TRANSACCION: CABECERA INGRESO A CAJA Y COMPROBANTES     */
/* ************************************************************ */
pMensaje = "".  /* Si hay un mensaje => hay un error */
RUN FIRST-TRANSACTION.
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR: No se pudo generar el comprobante" .
END.
/* ERROR: liberamos tablas */
IF pMensaje > "" THEN DO:
    IF AVAILABLE(CcbCCaja) THEN RELEASE CcbCCaja.
    IF AVAILABLE(CcbDCaja) THEN RELEASE CcbDCaja.
    IF AVAILABLE(B-CPEDM) THEN RELEASE B-CPEDM.
    IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
    IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
    IF AVAILABLE(FacDPedi) THEN RELEASE FacDPedi.
    IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
    IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
    IF AVAILABLE(B-CDOCU) THEN RELEASE B-CDocu.
    IF AVAILABLE(Ccbdmov) THEN RELEASE Ccbdmov.
    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
/* ************************************************************ */
/* 2da. TRANSACCION: FACTURACION ELECTRONICA ****************** */
/* ************************************************************ */
pMensaje = "".
EMPTY TEMP-TABLE T-FELogErrores.    /* CONTROL DE ERRORES DE FACTURACION ELECTRONICA */
RUN SECOND-TRANSACTION.
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    list_docs = ''.
    FOR EACH T-CDOCU NO-LOCK:
        /* Lista de Docs para el Message */
        IF list_docs = "" THEN list_docs = T-CDOCU.coddoc + " " + T-CDOCU.nrodoc.
        ELSE list_docs = list_docs + CHR(10) + T-CDOCU.coddoc + " " + T-CDOCU.nrodoc.
    END.
    pMensaje = pMensaje + CHR(10) + CHR(10) +
        "AVISAR AL ADMINISTRADOR QUE ANULE EL I/C N° " + NroDocCja + CHR(10) + CHR(10) +
        "AVISAR A CONTABILIDAD QUE ANULE LOS SIGUIENTES COMPROBANTES:" + CHR(10) +
        list_docs.
    /*RUN Envia-Correo (pMensaje).*/
END.
/* liberamos tablas */
RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */
IF AVAILABLE(CcbCCaja) THEN RELEASE CcbCCaja.
IF AVAILABLE(CcbDCaja) THEN RELEASE CcbDCaja.
IF AVAILABLE(B-CPEDM) THEN RELEASE B-CPEDM.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
IF AVAILABLE(FacDPedi) THEN RELEASE FacDPedi.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
IF AVAILABLE(B-CDOCU) THEN RELEASE B-CDocu.
IF AVAILABLE(Ccbdmov) THEN RELEASE Ccbdmov.
IF pMensaje > "" THEN DO:
    MESSAGE pMensaje SKIP(1)
        "SE VA A CERRAR EL SISTEMA. Volver a entrar y repita el proceso."
        VIEW-AS ALERT-BOX WARNING.
    QUIT.
END.
/* *********************** */
FOR EACH T-CDOCU NO-LOCK ,
    FIRST CcbCDocu NO-LOCK WHERE CcbCDocu.CodCia = S-CodCia AND
    CcbCDocu.CodDiv = S-CodDiv AND
    CcbCDocu.CodDoc = T-CDOCU.CodDoc AND
    CcbCDocu.NroDoc = T-CDOCU.NroDoc
    BY T-CDOCU.NroPed:
    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
        gn-divi.coddiv = S-CodDiv NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN DO:
        IF gn-divi.campo-log[7] = YES THEN DO:
            /* Configurado para QR */
            DEFINE VAR x-version AS CHAR.
            DEFINE VAR x-formato-tck AS LOG.
            DEFINE VAR x-imprime-directo AS LOG.
            DEFINE VAR x-nombre-impresora AS CHAR.

            x-version = 'L'.
            x-formato-tck = YES.        /* YES : Formato Ticket,  NO : Formato A4 */
            x-imprime-directo = YES.
            x-nombre-impresora = "".

            /* pVersion: "O":ORIGINAL  "C":COPIA  "R":RE-IMPRESION  "L":CLiente  "A":Control Administrativo */

            RUN sunat\r-impresion-doc-electronico(INPUT CcbCDocu.CodDiv, 
                                                  INPUT CcbCDocu.coddoc, 
                                                  INPUT CcbCDocu.nrodoc,
                                                  INPUT x-version,
                                                  INPUT x-formato-tck,
                                                  INPUT x-imprime-directo,
                                                  INPUT x-nombre-impresora).

        END.
    END.
    ELSE DO:
        MESSAGE "La division(" + S-CodDiv + ") a la que pertenece el documento NO EXISTE".
    END.
END.
/* RHC IMPRESION DE PROMOCIONES CRUZADAS */  
RUN vta2/p-imprime-prom-cruzada (d_Rowid,
                                 x-formato-tck,
                                 x-imprime-directo,
                                 x-nombre-impresora).

RETURN 'OK'.

/* ******************************************************************************* */
/* RHC 27/04/2016 RUTINAS GENERALES DE CAJA COBRANZAS MOSTRADOR MAYORISTA Y UTILEX */
/* ******************************************************************************* */
{sunat\i-canc-mayorista-cont-v2.i}
/* ******************************************************************************* */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Actualiza-Tickets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Tickets Procedure 
PROCEDURE Actualiza-Tickets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        FOR EACH T-Tickets:
            FIND VtaDTickets OF T-Tickets NO-LOCK NO-ERROR.
            IF AVAILABLE Vtadtickets THEN DO:
                pMensaje = 'ERROR: el ticket ' + T-Tickets.NroTck + ' YA ha sido aplicado'.
                UNDO, RETURN 'ADM-ERROR'.
            END.
            CREATE Vtadtickets.
            BUFFER-COPY T-Tickets TO Vtadtickets
                ASSIGN
                    Vtadtickets.CodRef = "I/C"
                    Vtadtickets.NroRef = NroDocCja 
                    VtaDTickets.Fecha = DATETIME(TODAY, MTIME)
                    VtaDTickets.CodDiv = s-coddiv
                    VtaDTickets.Usuario = s-user-id.
        END.
    END.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CONTROL-DE-VALES) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CONTROL-DE-VALES Procedure 
PROCEDURE CONTROL-DE-VALES :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Se va a aplicar todo lo que se pueda */
DEF VAR x-Importe-Vales AS DEC NO-UNDO.
RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND FIRST T-CcbCCaja.
    x-Importe-Vales = T-CcbCCaja.ImpNac[10] + T-CcbCCaja.ImpUsa[10] * T-CcbCCaja.TpoCmb.
    FOR EACH T-VALES:
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

&IF DEFINED(EXCLUDE-FIRST-TRANSACTION) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FIRST-TRANSACTION Procedure 
PROCEDURE FIRST-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* ************************************************** */
    /* NOTA: Todos los documentos se graban en TEMPORALES */
    /* ************************************************** */
    /* FIJAMOS EL PEDIDO EN UN PUNTERO DEL BUFFER */
    pMensaje = "Pedido en uso por otro usuario".
    {lib\lock-genericov3.i ~
        &Tabla="B-CPEDM" ~
        &Condicion="ROWID(B-CPEDM) = d_rowid" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje"
        &TipoError="UNDO RLOOP, LEAVE RLOOP" }
    pMensaje = "".
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
    /* CREACION DE LAS ORDENES DE DESPACHO */
    EMPTY TEMP-TABLE T-CODES.
    EMPTY TEMP-TABLE T-DODES.
    RUN Crea-Ordenes.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear la Orden de Despacho".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* CREACION DE COMPROBANTES A PARTIR DE LAS ORDENES DE DESPACHO */
    EMPTY TEMP-TABLE T-CDOCU.
    EMPTY TEMP-TABLE T-DDOCU.
    RUN Crea-Comprobantes.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear el Comprobante Temporal".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* CREACION DEL INGRESO A CAJA EN CcbCCaja */
    NroDocCja = "".
    RUN proc_IngCja (OUTPUT NroDocCja).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear el Ingreso a Caja".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* GRABACION DE LOS COMPROBANTES: ACTUALIZA E-POS Y ALMACENES */
    RUN Graba-Comprobantes.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear el Comprobante".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* GRABA ORDENES DE DESPACHO */
    RUN Graba-Ordenes.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear las Ordenes de Despacho".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* CREACION DE OTROS DOCUMENTOS ANEXOS */
    RUN Documentos-Anexos (NroDocCja).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudieron crear los Documentos Anexos".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* CONTROL DE VALES DE COMPRA */
    RUN CONTROL-DE-VALES.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo actualizar los vales de consumo'.
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* ACTUALIZA CONTROL DE TICKETS */
    /* 04Ago2016 - NroDocCja ??? */
    FOR EACH T-Tickets:
        FIND VtaDTickets OF T-Tickets NO-LOCK NO-ERROR.
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
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "NO se pudo actualizar el control de tickets".
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
    END.
    /* CERRAMOS PEDIDO MOSTRADOR */
    ASSIGN 
        B-CPEDM.flgest = "C".        /* Pedido Mostrador CERRADO */
    FOR EACH FacDPedi OF B-CPEDM:
        FacDPedi.canate = FacDPedi.canped.  /* Atendido al 100% */
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
IF AVAILABLE(FeLogErrores) THEN RELEASE FeLogErrores.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Graba-Totales-Factura) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales-Factura Procedure 
PROCEDURE Graba-Totales-Factura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Rutina General */
  {vtagn/i-total-factura.i &Cabecera="T-CDOCU" &Detalle="T-DDOCU"} 

END PROCEDURE.

/*
    DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
    DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.

    /* RHC 06/03/2015 CALCULO CORREGIDO DE TICKETS UTILEX */
    ASSIGN
        T-CDOCU.ImpBrt = 0
        T-CDOCU.ImpDto = 0
        T-CDOCU.ImpDto2 = 0
        T-CDOCU.ImpIgv = 0
        T-CDOCU.ImpIsc = 0
        T-CDOCU.ImpTot = 0
        T-CDOCU.ImpExo = 0
        T-CDOCU.ImpVta = 0
        T-CDOCU.Libre_d01 = 0  /* Descuento SIN IGV por Encartes y Otros */
        T-CDOCU.Libre_d02 = 0  /* Descuento por Linea CON IGV */
        f-igv = 0
        f-isc = 0.
    FOR EACH T-DDOCU OF T-CDOCU NO-LOCK:        
        T-CDOCU.ImpTot = T-CDOCU.ImpTot + (T-DDOCU.ImpLin - T-DDOCU.ImpDto2).
        T-CDOCU.ImpDto2 = T-CDOCU.ImpDto2 + T-DDOCU.ImpDto2.
        IF T-DDOCU.AftIgv = YES THEN DO:
            f-Igv = f-Igv + (T-DDOCU.ImpLin - T-DDOCU.ImpDto2) / ( 1 + T-CDOCU.PorIgv / 100) * T-CDOCU.PorIgv / 100.
            T-CDOCU.Libre_d01 = T-CDOCU.Libre_d01 + ( T-DDOCU.ImpDto2 / ( 1 + T-CDOCU.PorIgv / 100) ).
        END.
        ELSE DO:
            T-CDOCU.ImpExo = T-CDOCU.ImpExo + (T-DDOCU.ImpLin - T-DDOCU.ImpDto2).
            T-CDOCU.Libre_d01 = T-CDOCU.Libre_d01 + T-DDOCU.ImpDto2.
        END.
    END.
    ASSIGN
        T-CDOCU.ImpIgv = ROUND(f-Igv, 2)
        T-CDOCU.ImpDto = ROUND(T-CDOCU.ImpDto, 2)
        T-CDOCU.Libre_d01 = ROUND(T-CDOCU.Libre_d01, 2)
        T-CDOCU.ImpVta = IF T-CDOCU.ImpIgv > 0 THEN T-CDOCU.ImpTot - T-CDOCU.ImpExo - T-CDOCU.ImpIgv ELSE 0.
    ASSIGN
        T-CDOCU.ImpBrt = T-CDOCU.ImpVta + (T-CDOCU.ImpDto + T-CDOCU.Libre_d01) /*+ T-CDOCU.ImpExo*/.
    IF T-CDOCU.PorIgv = 0.00     /* VENTA INAFECTA */
        THEN ASSIGN
            T-CDOCU.ImpIgv = 0
            T-CDOCU.ImpVta = T-CDOCU.ImpExo
            T-CDOCU.ImpBrt = T-CDOCU.ImpExo.
    ASSIGN
        T-CDOCU.SdoAct  = T-CDOCU.ImpTot.
*/

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

  /* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
  DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.

  RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    CREATE T-CDOCU.
    ASSIGN
        T-CDOCU.CodCia = s-CodCia
        T-CDOCU.CodDiv = s-CodDiv   
        T-CDOCU.DivOri = FacCPedi.CodDiv    /* OJO: division de estadisticas */
        T-CDOCU.CodDoc = s-CodDoc
        T-CDOCU.NroDoc = STRING(FacCorre.NroSer, ENTRY(1, x-Formato, '-')) +
                            STRING(FacCorre.Correlativo, ENTRY(2, x-Formato, '-'))
        T-CDOCU.FchDoc = TODAY
        T-CDOCU.CodMov = s-CodMov
        T-CDOCU.CodAlm = FacCPedi.CodAlm
        T-CDOCU.CodRef = FacCPedi.CodDoc           /* CONTROL POR DEFECTO */
        T-CDOCU.NroRef = FacCPedi.NroPed
        T-CDOCU.Libre_c01 = FacCPedi.CodDoc        /* CONTROL ADICIONAL */
        T-CDOCU.Libre_c02 = FacCPedi.NroPed
        T-CDOCU.CodPed = B-CPEDM.CodDoc           /* NUMERO DE PEDIDO */
        T-CDOCU.NroPed = B-CPEDM.NroPed
        T-CDOCU.Tipo   = s-Tipo 
        T-CDOCU.FchVto = TODAY
        T-CDOCU.CodCli = FacCPedi.CodCli
        T-CDOCU.NomCli = FacCPedi.NomCli
        T-CDOCU.RucCli = FacCPedi.RucCli
        T-CDOCU.CodAnt = FacCPedi.Atencion     /* DNI */
        T-CDOCU.DirCli = FacCPedi.DirCli
        T-CDOCU.CodVen = FacCPedi.CodVen
        T-CDOCU.TipVta = "1"
        T-CDOCU.TpoFac = "C"       /* GUIA VENTA AUTOMATICA */
        T-CDOCU.FmaPgo = FacCPedi.FmaPgo
        T-CDOCU.CodMon = FacCPedi.CodMon
        T-CDOCU.TpoCmb = FacCfgGn.TpoCmb[1]
        T-CDOCU.PorIgv = FacCPedi.PorIgv
        T-CDOCU.NroOrd = FacCPedi.ordcmp
        T-CDOCU.FlgEst = "P"       /* POR FACTURAR */
        T-CDOCU.FlgSit = "P"
        T-CDOCU.usuario = S-USER-ID
        T-CDOCU.HorCie = STRING(TIME,'hh:mm')
        T-CDOCU.Glosa     = B-CPEDM.Glosa
        T-CDOCU.TipBon[1] = B-CPEDM.TipBon[1]
        T-CDOCU.NroCard   = B-CPEDM.NroCard 
        T-CDOCU.FlgEnv    = B-CPEDM.FlgEnv /* OJO Control de envio de documento */
        T-CDOCU.Libre_c04 = FaccPedi.Cmpbnte   /*Que Documento imprimira*/
        T-CDOCU.ImpDto2    = FaccPedi.ImpDto2
        /* INFORMACION DE LA TIQUETERA */
        T-CDOCU.libre_c03 = FacCorre.NroImp
        /* INFORMACION DEL ENCARTE */
        T-CDOCU.Libre_c05 = B-CPEDM.FlgSit + '|' + B-CPEDM.Libre_c05
        T-CDOCU.Tipo    = s-Tipo       /* SUNAT */
        T-CDOCU.CodCaja = s-CodTer.
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
    /* Guarda Centro de Costo */
    FIND gn-ven WHERE
        gn-ven.codcia = s-codcia AND
        gn-ven.codven = T-CDOCU.codven
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN T-CDOCU.cco = gn-ven.cco.
    /* PUNTERO DE LA FACTURA */
    ASSIGN
        Fac_Rowid = ROWID(T-CDOCU).
    /* ********************* */
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

&IF DEFINED(EXCLUDE-SECOND-TRANSACTION) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SECOND-TRANSACTION Procedure 
PROCEDURE SECOND-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Segundo Generamos los comprobantes que faltan */
pMensaje = "".
FOR EACH T-CDOCU NO-LOCK, FIRST Ccbcdocu OF T-CDOCU NO-LOCK:
    /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
    RUN sunat\progress-to-ppll-v3  ( INPUT Ccbcdocu.coddiv,
                                     INPUT Ccbcdocu.coddoc,
                                     INPUT Ccbcdocu.nrodoc,
                                     INPUT-OUTPUT TABLE T-FELogErrores,
                                     OUTPUT pMensaje ).
    IF RETURN-VALUE <> "OK" THEN DO:
        IF TRUE <> (pMensaje > "") AND RETURN-VALUE = 'ADM-ERROR'  THEN pMensaje = "ERROR de ePos".
        IF TRUE <> (pMensaje > "") AND RETURN-VALUE = 'ERROR-EPOS' THEN pMensaje = "ERROR confirmación de ePos".
        RETURN "ADM-ERROR".
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-THIRD-TRANSACTION) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE THIRD-TRANSACTION Procedure 
PROCEDURE THIRD-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND Ccbccaja WHERE CcbCCaja.CodCia = s-CodCia
        AND CcbCCaja.CodDoc = s-CodCja
        AND CcbCCaja.NroDoc = NroDocCja
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbccaja THEN DO:
        RUN sunat/p-extorna-ic-sunat ( Ccbccaja.coddiv, Ccbccaja.coddoc, Ccbccaja.nrodoc).
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    END.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

