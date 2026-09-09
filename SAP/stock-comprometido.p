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
         HEIGHT             = 8.5
         WIDTH              = 53.43.
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
/*x-flg-reserva-stock = "G,X,P,T,W,WX,WL,WC".*/
x-flg-reserva-stock = "G,X,P,T,W,WX,WL,WC,A".   /* Vamos a tener que tomar en cuenta los anulados */

RUN PED-Comprometido (INPUT pCodAlm,
                      INPUT pCodMat,
                      INPUT "PED",
                      INPUT x-flg-reserva-stock, 
                      INPUT x-Fecha,
                      INPUT-OUTPUT pComprometido).
/*MESSAGE 'tres' pcomprometido.*/
/* SOLO PENDIENTES */
RUN OD-Comprometido (INPUT pCodAlm,
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

&IF DEFINED(EXCLUDE-OD-Comprometido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OD-Comprometido Procedure 
PROCEDURE OD-Comprometido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pFlgReservaStock AS CHAR.
DEF INPUT PARAMETER pFecha AS DATE.
DEF INPUT-OUTPUT PARAMETER pComprometido AS DECI.

DEF VAR iFactor AS INTE INIT 0 NO-UNDO.
DEF BUFFER bFaccpedi FOR Faccpedi.
DEF BUFFER bFacdpedi FOR Facdpedi.

DEF VAR cState_Stock AS CHAR NO-UNDO.
DEF VAR cLibre_C02 AS CHAR NO-UNDO.
DEF VAR iState_Stock AS LOG NO-UNDO.
/* NOTA: 
  Aquí hay un problema, debemos barrer el histórico para ver si ha afecta el stock anteriormente 
*/
FOR EACH bFacdpedi NO-LOCK WHERE bFacdpedi.codcia = s-CodCia
        AND bFacdpedi.almdes = pCodAlm
        AND bFacdpedi.codmat = pCodMat
        AND bFacdpedi.coddoc = pCodDoc        /* PED u O/D */
        AND bFacdpedi.flgest = 'P'
        AND bFacdpedi.FchPed >= pFecha,
    FIRST bFaccpedi NO-LOCK WHERE bFaccpedi.codcia = bFacdpedi.codcia
        AND bFaccpedi.coddiv = bFacdpedi.coddiv
        AND bFaccpedi.coddoc = bFacdpedi.coddoc
        AND bFaccpedi.nroped = bFacdpedi.nroped :
    IF LOOKUP(TRIM(bFaccpedi.FlgEst), pFlgReservaStock) = 0 THEN NEXT.
    IF bFacdpedi.canate >= bFacdpedi.CanPed THEN NEXT.
    /* Analizamos el histórico de SAP */
    iState_Stock = NO.
    cState_Stock = "".
    cLibre_C02 = "".
    /* Depende de la situación del PED */
    FOR EACH Interface_SAP NO-LOCK WHERE Interface_SAP.code_key = bFaccpedi.codref AND      /* PED */
            Interface_SAP.number_key = bFaccpedi.nroref 
        BY Interface_SAP.date_create BY Interface_SAP.hour_create:
        cState_Stock = Interface_SAP.state_stock.
        cLibre_C02 = Interface_SAP.libre_c02.
        IF Interface_SAP.state_stock = "S" THEN iState_Stock = YES.     /* OJO: ya afectó stock */
    END.
    /* Veamos el último movimiento */
    iFactor = 1.
    IF cState_Stock = "S" THEN NEXT.        /* NO lo tomamos en cuenta */
    pComprometido = pComprometido + (bFacdpedi.Factor * (bFacdpedi.CanPed - bFacdpedi.canate) * iFactor).
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
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pFlgReservaStock AS CHAR.
DEF INPUT PARAMETER pFecha AS DATE.
DEF INPUT-OUTPUT PARAMETER pComprometido AS DECI.


DEF VAR iFactor AS INTE INIT 0 NO-UNDO.
DEF BUFFER bFaccpedi FOR Faccpedi.
DEF BUFFER bFacdpedi FOR Facdpedi.

DEF VAR cState_Stock AS CHAR NO-UNDO.
DEF VAR cLibre_C02 AS CHAR NO-UNDO.
DEF VAR iState_Stock AS LOG NO-UNDO.
/* NOTA: 
  Aquí hay un problema, debemos barrer el histórico para ver si ha afecta el stock anteriormente 
*/
FOR EACH bFacdpedi NO-LOCK WHERE bFacdpedi.codcia = s-CodCia
        AND bFacdpedi.almdes = pCodAlm
        AND bFacdpedi.codmat = pCodMat
        AND bFacdpedi.coddoc = pCodDoc        /* PED u O/D */
        AND bFacdpedi.flgest = 'P'
        AND bFacdpedi.FchPed >= pFecha,
    FIRST bFaccpedi NO-LOCK WHERE bFaccpedi.codcia = bFacdpedi.codcia
        AND bFaccpedi.coddiv = bFacdpedi.coddiv
        AND bFaccpedi.coddoc = bFacdpedi.coddoc
        AND bFaccpedi.nroped = bFacdpedi.nroped :
    /* OJO: se está tomando en cuenta los documentos anulados */
    IF LOOKUP(TRIM(bFaccpedi.FlgEst), pFlgReservaStock) = 0 THEN NEXT.
    IF bFaccpedi.FchVen < TODAY THEN NEXT.    /* OJO */
    IF bFacdpedi.canate >= bFacdpedi.CanPed THEN NEXT.
    /* Analizamos el histórico de SAP */
    iState_Stock = NO.
    cState_Stock = "".
    cLibre_C02 = "".
    FOR EACH Interface_SAP NO-LOCK WHERE Interface_SAP.code_key = bFaccpedi.coddoc AND
            Interface_SAP.number_key = bFaccpedi.nroped
        BY Interface_SAP.date_create BY Interface_SAP.hour_create:
        cState_Stock = Interface_SAP.state_stock.
        cLibre_C02 = Interface_SAP.libre_c02.
        IF Interface_SAP.state_stock = "S" THEN iState_Stock = YES.     /* OJO: ya afectó stock */
    END.
    /* Dos casos:
        1. Si afectó stock
        2. Si no afectó stock 
    */
    /* Veamos el último movimiento */
    iFactor = 1.
    IF cState_Stock = "S" THEN NEXT.        /* NO lo tomamos en cuenta */
    ELSE DO:
        IF iState_Stock = NO THEN DO:
            /* Nunca ha actualizado el stock NUNCA */
            IF bFaccpedi.FlgEst = "A" THEN NEXT.    /* ANULADO: NO lo tomamos en cuenta */
        END.
        ELSE DO:
            /* Ya actualizó stock anteriormente */
            IF cLibre_C02 = "UPDATE" THEN NEXT.             /* NO lo tomamos en cuenta */
            IF cLibre_C02 = "DELETE" THEN iFactor = -1.     /* Extornamos el stock afectado */
        END.
    END.
    /*MESSAGE iFactor bFacdpedi.codmat bFacdpedi.CanPed.*/
    pComprometido = pComprometido + (bFacdpedi.Factor * (bFacdpedi.CanPed - bFacdpedi.canate) * iFactor).
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

DEF VAR iFactor AS INTE INIT 0 NO-UNDO.
DEF BUFFER bCcbcdocu FOR Ccbcdocu.
DEF BUFFER bCcbddocu FOR Ccbddocu.

DEF VAR cState_Stock AS CHAR NO-UNDO.
DEF VAR cLibre_C02 AS CHAR NO-UNDO.
DEF VAR iState_Stock AS LOG NO-UNDO.

/* NOTA: 
  Aquí hay un problema, no tenemos forma de sabr cual comprobante tomar y cual no,
    por lo tanto vamos a tomar solo los que aún no han afectado stock 
*/

FOR EACH Interface_SAP NO-LOCK WHERE Interface_SAP.state_stock = "N" AND
        Interface_SAP.origin = "CONTADO" AND
        Interface_SAP.division = s-coddiv AND
        Interface_SAP.libre_c01 = "ccbcdocu" AND
        LOOKUP(TRIM(Interface_SAP.code_key), "N/C,FAC,BOL") > 0,
    FIRST bCcbcdocu NO-LOCK WHERE bCcbcdocu.codcia = s-codcia AND
        bCcbcdocu.coddoc = Interface_SAP.code_key AND
        bCcbcdocu.nrodoc = Interface_SAP.number_key AND
        bCcbcdocu.codalm = pCodAlm
    BREAK BY Interface_SAP.code_key BY Interface_SAP.number_key
            BY Interface_SAP.date_create BY Interface_SAP.hour_create:

    IF FIRST-OF(Interface_SAP.code_key) OR FIRST-OF(Interface_SAP.number_key) THEN DO:
        /* Analizamos el histórico de SAP */
        iState_Stock = NO.
        cState_Stock = "".
        cLibre_C02 = "".
    END.

    cState_Stock = Interface_SAP.state_stock.   /* Siempre va a ser "N" */
    cLibre_C02 = Interface_SAP.libre_c02.
    IF Interface_SAP.state_stock = "S" THEN iState_Stock = YES.     /* OJO: ya afectó stock */

    IF LAST-OF(Interface_SAP.code_key) OR LAST-OF(Interface_SAP.number_key) THEN DO:
        /* Dos casos:
            1. Si afectó stock
            2. Si no afectó stock 
        */
        /* Veamos el último movimiento */
        iFactor = 1.
        IF bCcbcdocu.coddoc = "N/C" THEN iFactor = -1.

        IF cState_Stock = "S" THEN NEXT.        /* NO lo tomamos en cuenta */
        ELSE DO:
            IF iState_Stock = NO THEN DO:
                /* NUNCA ha actualizado el stock */
                IF bCcbcdocu.FlgEst = "A" THEN NEXT.    /* ANULADO: NO lo tomamos en cuenta */
            END.
            ELSE DO:
                /* Ya actualizó stock anteriormente */
                IF cLibre_C02 = "DELETE" THEN iFactor = -1 * iFactor.       /* Extornamos el stock afectado */
            END.
        END.
        FOR EACH bCcbddocu OF bCcbcdocu NO-LOCK WHERE bCcbddocu.CodMat = pCodMat:
            pComprometido = pComprometido + (bCcbddocu.Factor * bCcbddocu.CanDes * iFactor).
        END.
    END.
END.

END PROCEDURE.

/*
DEF VAR iFactor AS INTE INIT 0 NO-UNDO.
DEF BUFFER bCcbcdocu FOR Ccbcdocu.
DEF BUFFER bCcbddocu FOR Ccbddocu.

/* Barremos solo los que aún no afectan el stock en SAP */
FOR EACH Interface_SAP NO-LOCK WHERE Interface_SAP.state_stock = "N" AND 
        Interface_SAP.division = s-coddiv AND
        Interface_SAP.origin = "CONTADO" AND
        LOOKUP(TRIM(Interface_SAP.CODE_key),'FAC,BOL,N/C') > 0,
    FIRST bCcbcdocu NO-LOCK WHERE bCcbcdocu.codcia = s-codcia AND
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
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

