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

/* ICBPER */
DEFINE VAR x-articulo-ICBPER AS CHAR.

x-articulo-ICBPER = '099268'.

DEFINE BUFFER x-vtatabla FOR vtatabla.

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
         HEIGHT             = 6.62
         WIDTH              = 50.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pContado AS LOG.
DEF OUTPUT PARAMETER pComprometido AS DEC NO-UNDO.

DEFINE VAR x-flg-reserva-stock AS CHAR.

pComprometido = 0.  /* Valor por defecto */   

IF NUM-ENTRIES(pCodAlm) > 1 THEN pCodAlm = ENTRY(1, pCodAlm).   /* El 1er almacén */

/* CALCULO DEL STOCK COMPROMETIDO */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.        /* División de venta */

FIND FIRST FacCfgGn WHERE Faccfggn.codcia = s-codcia NO-LOCK NO-ERROR. 
IF NOT AVAILABLE Faccfggn THEN RETURN.
/* **************************** */
/* IMPSTO BOLSAS PLASTICAS NO CONTROLA STOCK */ 
IF x-articulo-ICBPER = pCodMat THEN RETURN.
/* **************************************************************************** */
/* RHC 12/06/2020 Líneas de Productos con Cat. Contab. = "SV" no controla stock */
/* **************************************************************************** */
FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia AND
    Almmmatg.codmat = pCodMat NO-LOCK NO-ERROR.
IF AVAILABLE Almmmatg THEN DO:
    FIND FIRST Almtfami OF Almmmatg NO-LOCK NO-ERROR.
    IF AVAILABLE Almtfami AND Almtfami.Libre_c01 = "SV" THEN RETURN.
END.
/* **************************************************************************** */
/* Buffers de trabajo */
DEF BUFFER B-DPEDI FOR integral.Facdpedi.
DEF BUFFER B-CPEDI FOR integral.Faccpedi.
DEF BUFFER B-CREPO FOR integral.Almcrepo.
DEF BUFFER B-DREPO FOR integral.Almdrepo.
DEFINE BUFFER x-gre_detail FOR gre_detail.
DEFINE BUFFER x-gre_header FOR gre_header.

/* ********************************************************************************************* */
/* Stock comprometido por PEDIDOS ACTIVOS MOSTRADOR */
/* ********************************************************************************************* */
RUN PM-Comprometido.
/*MESSAGE 'uno' pcomprometido.*/
/* ********************************************************************************************* */

/* ********************************************************************************************* */
/* Comprobantes VENTA MOSTRADOR */
/* ********************************************************************************************* */
RUN VTA-MOSTRADOR.
/*MESSAGE 'dos' pcomprometido.*/
/* ********************************************************************************************* */

/**********   Barremos para los O/D y OTR   ***********************/ 
/* OJO: Solo los que aún no han sido migrados al SAT */
/* ********************************************************************************************* */
DEFINE VAR x-fecha AS DATE.
DEFINE VAR LocalDiasComprometido AS DECI INIT 30 NO-UNDO.      /* Exagerando */
DEFINE VAR LocalDiasComprometidoRAN AS DECI INIT 60 NO-UNDO.      /* Exagerando */

FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-codcia AND 
    VtaTabla.Tabla = 'CONFIG-VTAS' AND 
    VtaTabla.Llave_c1 = 'STOCK-COMPROMETIDO'
    NO-LOCK NO-ERROR.
IF AVAILABLE VtaTabla AND VtaTabla.Valor[01] > 0 THEN LocalDiasComprometido = VtaTabla.Valor[01].
x-fecha = (TODAY - LocalDiasComprometido).

/* ********************************************************************************************* */
/**********   Barremos para los PEDIDOS AL CREDITO   ***********************/ 
/* OJO: Solo los que aún no han sido migrados al SAT */
/* ********************************************************************************************* */
x-flg-reserva-stock = "G,X,P,T,W,WX,WL,WC".

RUN PED-Comprometido (INPUT pCodAlm,
                      INPUT pCodMat,
                      INPUT "PED",
                      INPUT x-flg-reserva-stock, 
                      INPUT x-Fecha,
                      INPUT-OUTPUT pComprometido).
/*MESSAGE 'tres' pcomprometido.-*/
RUN PED-Comprometido (INPUT pCodAlm,
                      INPUT pCodMat,
                      INPUT "O/D",
                      INPUT "P", 
                      INPUT x-Fecha,
                      INPUT-OUTPUT pComprometido).
/*MESSAGE 'cuatro' pcomprometido.*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-GRE-Comprometido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRE-Comprometido Procedure 
PROCEDURE GRE-Comprometido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT-OUTPUT PARAMETER pComprometido AS DECI.

FOR EACH x-gre_detail WHERE x-gre_detail.reserva_stock = "SI" AND 
        x-gre_detail.codmat = pCodMat NO-LOCK,
    FIRST x-gre_header WHERE x-gre_detail.ncorrelativo = x-gre_header.ncorrelatio AND
        x-gre_header.m_codalm = pCodAlm NO-LOCK :
    pComprometido = pComprometido + (x-gre_detail.candes * x-gre_detail.factor).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PED-Comprometido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PED-Comprometido Procedure 
PROCEDURE PED-Comprometido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Dos casos de pedidos: 
                            PED: Pedido Logístico
                            O/D: Orden de Despacho
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pFlgReservaStock AS CHAR.
DEF INPUT PARAMETER pFecha AS DATE.
DEF INPUT-OUTPUT PARAMETER pComprometido AS DECI.

FOR EACH B-DPEDI NO-LOCK WHERE B-DPEDI.codcia = s-CodCia
        AND B-DPEDI.almdes = pCodAlm
        AND B-DPEDI.codmat = pCodMat
        AND B-DPEDI.coddoc = pCodDoc        /* PED u O/D */
        AND B-DPEDI.flgest = 'P'
        AND B-DPEDI.FchPed >= pFecha,
    FIRST B-CPEDI NO-LOCK WHERE B-CPEDI.codcia = B-DPEDI.codcia
        AND B-CPEDI.coddiv = B-DPEDI.coddiv
        AND B-CPEDI.coddoc = B-DPEDI.coddoc
        AND B-CPEDI.nroped = B-DPEDI.nroped :
    IF LOOKUP(TRIM(B-CPEDI.FlgEst), pFlgReservaStock) = 0 THEN NEXT.
    IF B-CPEDI.FchVen < TODAY THEN NEXT.    /* OJO */
    IF B-DPEDI.canate >= B-DPEDI.CanPed THEN NEXT.

    CASE pCodDoc:
        WHEN "PED" THEN DO:
            /* Pedido NO tiene aún O/D generada */
        END.
        WHEN "O/D" THEN DO:
            IF CAN-FIND(FIRST Interface_SAP WHERE Interface_SAP.code_key = B-CPEDI.coddoc AND 
                        Interface_SAP.number_key = B-CPEDI.nroped AND 
                        Interface_SAP.state = 'S' NO-LOCK)
                THEN NEXT.
        END.
    END CASE.
    /* Buscamos movimientos el la Interface_SAP */
    /* OJO: En caso de PED puede haber más de 1 (CREATE y UPDATE) */
    FOR EACH Interface_SAP NO-LOCK WHERE Interface_SAP.code_key = B-CPEDI.coddoc AND
            Interface_SAP.number_key = B-CPEDI.nroped
        BY Interface_SAP.date_create DESC BY Interface_SAP.hour_create DESC:
        IF Interface_SAP.state_stock = "N" THEN DO:
            /* Tomamos el último */
            pComprometido = pComprometido + (B-DPEDI.Factor * (B-DPEDI.CanPed - B-DPEDI.canate)).
            LEAVE.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PM-Comprometido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PM-Comprometido Procedure 
PROCEDURE PM-Comprometido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF pContado = YES THEN DO:
    /* ********************************************************************************************* */
    /* Stock comprometido por PEDIDOS ACTIVOS MOSTRADOR */
    /* ********************************************************************************************* */
    DEF VAR TimeOut AS INTEGER NO-UNDO.
    DEF VAR TimeNow AS INTEGER NO-UNDO.
    DEF VAR TimeLimit AS CHARACTER NO-UNDO.

    /* Definimos rango de fecha y hora */
    DEF VAR dtDesde AS DATETIME NO-UNDO.
    DEF VAR fDesde AS DATE NO-UNDO.
    DEF VAR cHora  AS CHAR NO-UNDO.

    /* 07/03/2023 Tiempos de Reserva */
    FIND FIRST FacCfgVta WHERE FacCfgVta.CodCia = s-codcia AND
        FacCfgVta.CodDoc = "P/M" AND
        (TODAY >= FacCfgVta.FechaD AND TODAY <= FacCfgVta.FechaH)
        NO-LOCK NO-ERROR.

    /* Tiempo por defecto fuera de campaña (segundos) */
    TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
              (FacCfgGn.Hora-Res * 3600) + 
              (FacCfgGn.Minu-Res * 60).
    IF AVAILABLE FacCfgVta THEN TimeOut = (FacCfgVta.Dias-Res * 24 * 3600) +
              (FacCfgVta.Hora-Res * 3600) + 
              (FacCfgVta.Minu-Res * 60).

    dtDesde = ADD-INTERVAL(NOW, (-1 * TimeOut) , 'seconds').
    fDesde = DATE(dtDesde).
    cHora  = ENTRY(2,STRING(dtDesde, '99/99/9999 HH:MM'), ' ').

    /* Se toman en cuenta todos los P/M PENDIENTES y NO FACTURADOS dentro del rango de fecha y hora */
    FOR EACH B-DPEDI NO-LOCK WHERE B-DPEDI.codcia = s-CodCia
        AND B-DPEDI.codmat = pCodMat
        AND B-DPEDI.coddoc = 'P/M'
        AND B-DPEDI.flgest = 'P'
        AND B-DPEDI.almdes = pCodAlm
        AND B-DPEDI.fchped >= fDesde,
        FIRST B-CPEDI OF B-DPEDI NO-LOCK WHERE B-CPEDI.FlgEst = "P":
        IF B-DPEDI.fchped > TODAY THEN NEXT.
        IF B-DPEDI.fchped = fDesde AND B-DPEDI.hora < cHora THEN NEXT.
        /* El control es totalmente por Progress */
        pComprometido = pComprometido + (B-DPEDI.Factor * B-DPEDI.CanPed).
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-VTA-MOSTRADOR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VTA-MOSTRADOR Procedure 
PROCEDURE VTA-MOSTRADOR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* NOTA:
    - NO tomar en cuenta los ANULADOS 
*/
    
DEF VAR iFactor AS INTE INIT 0 NO-UNDO.
DEF BUFFER bCcbcdocu FOR Ccbcdocu.
DEF BUFFER bCcbddocu FOR Ccbddocu.

/* Barremos solo los que aún no afectan el stock en SAP */
FOR EACH Interface_SAP NO-LOCK WHERE Interface_SAP.state_stock = "N" AND 
        Interface_SAP.division = s-coddiv AND
        Interface_SAP.origin = "CONTADO" AND
        LOOKUP(TRIM(Interface_SAP.CODE_key),'FAC,BOL,N/C') > 0,
    FIRST bCcbcdocu WHERE bCcbcdocu.codcia = s-codcia AND
        bCcbcdocu.coddoc = Interface_SAP.code_key AND
        bCcbcdocu.nrodoc = Interface_SAP.number_key AND
        bCcbcdocu.codalm = pCodAlm AND
        bCcbcdocu.flgest <> "A",
    EACH bCcbddocu OF bCcbcdocu NO-LOCK WHERE bCcbddocu.CodMat = pCodMat
    /* Solo consideramos la última ocurrencia */
    BREAK BY Interface_SAP.CODE_key BY Interface_SAP.number_key 
            BY Interface_SAP.DATE_create DESC BY Interface_SAP.hour_create DESC:
    IF FIRST-OF(Interface_SAP.CODE_key) OR FIRST-OF(Interface_SAP.number_key) THEN DO:
        iFactor = 1.
        IF bCcbcdocu.CodDoc = "N/C" THEN iFactor = -1.
        pComprometido = pComprometido + (bCcbddocu.Factor * bCcbddocu.CanDes) * iFactor.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

