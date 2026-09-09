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
         HEIGHT             = 6.92
         WIDTH              = 61.72.
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

FIND FIRST FacCfgGn WHERE Faccfggn.codcia = s-codcia NO-LOCK NO-ERROR. 
IF NOT AVAILABLE Faccfggn THEN RETURN.
/* 07/03/2023 Tiempos de Reserva */
FIND FIRST FacCfgVta WHERE FacCfgVta.CodCia = s-codcia AND
    FacCfgVta.CodDoc = "P/M" AND
    (TODAY >= FacCfgVta.FechaD AND TODAY <= FacCfgVta.FechaH)
    NO-LOCK NO-ERROR.
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
DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.
DEF VAR TimeLimit AS CHARACTER NO-UNDO.

/* Definimos rango de fecha y hora */
DEF VAR dtDesde AS DATETIME NO-UNDO.
DEF VAR fDesde AS DATE NO-UNDO.
DEF VAR cHora  AS CHAR NO-UNDO. 

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

IF pContado = YES THEN DO:
    FOR EACH B-DPEDI NO-LOCK WHERE B-DPEDI.codcia = s-CodCia
        AND B-DPEDI.codmat = pCodMat
        AND B-DPEDI.coddoc = 'P/M'
        AND B-DPEDI.flgest = 'P'
        AND B-DPEDI.almdes = pCodAlm
        AND B-DPEDI.fchped >= fDesde,
        FIRST B-CPEDI OF B-DPEDI NO-LOCK WHERE B-CPEDI.FlgEst = "P":
        IF B-DPEDI.fchped > TODAY THEN NEXT.
        IF B-DPEDI.fchped = fDesde AND B-DPEDI.hora < cHora THEN NEXT.
        /* cantidad en reservacion */
        pComprometido = pComprometido + (B-DPEDI.Factor * B-DPEDI.CanPed).
    END.
END.
/* ********************************************************************************************* */
/**********   Barremos para los O/D y OTR   ***********************/ 
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

RUN PED-Comprometido (pCodAlm,pCodMat,"O/D","P", x-Fecha,INPUT-OUTPUT pComprometido).

RUN PED-Comprometido (pCodAlm,pCodMat,"OTR","P", x-Fecha,INPUT-OUTPUT pComprometido).

/* Guia de remision electronica PGRE */
RUN GRE-Comprometido (pCodAlm,pCodMat,INPUT-OUTPUT pComprometido).

/* ********************************************************************************************* */
/**********   Barremos para los PEDIDOS AL CREDITO   ***********************/ 
/* ********************************************************************************************* */
x-flg-reserva-stock = "G,X,P,T,W,WX,WL,WC".

DEFINE VAR x-sec AS INT.

FOR EACH B-DPEDI NO-LOCK WHERE B-DPEDI.codcia = s-CodCia
    AND B-DPEDI.almdes = pCodAlm
    AND B-DPEDI.codmat = pCodMat
    AND B-DPEDI.coddoc = "PED"
    AND B-DPEDI.flgest = 'P'
    AND B-DPEDI.FchPed >= x-fecha,
    FIRST B-CPEDI NO-LOCK WHERE B-CPEDI.codcia = B-DPEDI.codcia
        AND B-CPEDI.coddiv = B-DPEDI.coddiv
        AND B-CPEDI.coddoc = B-DPEDI.coddoc
        AND B-CPEDI.nroped = B-DPEDI.nroped :
    IF LOOKUP(B-CPEDI.FlgEst, x-flg-reserva-stock) = 0 THEN NEXT.
    IF B-CPEDI.FchVen < TODAY THEN NEXT.    /* OJO */
    IF B-DPEDI.canate >= B-DPEDI.CanPed THEN NEXT.
    pComprometido = pComprometido + (B-DPEDI.Factor * (B-DPEDI.CanPed - B-DPEDI.canate)).
END.

DEF VAR j AS INTE NO-UNDO.
DEF VAR k AS INTE NO-UNDO.

DEF VAR x-FlgEst AS CHAR INIT 'P,X' NO-UNDO.
DEF VAR x-TipMov AS CHAR INIT 'A,M,RAN,INC' NO-UNDO.

/* ********************************************************************************************* */
/**********   REPOSICIONES   ***********************/ 
/* ********************************************************************************************* */
DO j = 1 TO 2:
    DO k = 1 TO 4:
        FOR EACH B-CREPO NO-LOCK WHERE B-CREPO.codcia = s-codcia
                AND B-CREPO.almped = pCodAlm
                AND B-CREPO.flgest = ENTRY(j, x-FlgEst)
                AND B-CREPO.tipmov = ENTRY(k, x-TipMov)
                AND B-CREPO.fchdoc >= (TODAY - LocalDiasComprometidoRAN),    /* OJO: No mas de 60 días */
            EACH B-DREPO NO-LOCK WHERE B-DREPO.codcia = s-codcia
                AND B-DREPO.codalm = B-CREPO.codalm
                AND B-DREPO.tipmov = B-CREPO.tipmov
                AND B-DREPO.nroser = B-CREPO.nroser
                AND B-DREPO.nrodoc = B-CREPO.nrodoc
                AND B-DREPO.codmat = pCodMat
                AND B-DREPO.flgest = 'P':
            pComprometido = pComprometido + (B-DREPO.CanApro - B-DREPO.CanAten).
        END.
    END.
END. 

/* ********************************************************************************************* */
/* RHC 23/04/2020 Mercadería comprometida por Cotizaciones */
/* ********************************************************************************************* */
/* Barremos todas las divisiones que comprometen stock por COTIZACIONES */
RLOOP:
FOR EACH FacTabla NO-LOCK WHERE FacTabla.codcia = s-CodCia AND
    FacTabla.tabla = 'GN-DIVI' AND
    FacTabla.campo-l[2] = YES AND
    FacTabla.Valor[1] > 0:
    /* RHC 21/05/2020 Ahora tiene horas y/o hora tope */
    /* Pasada esa hora NO vale la Cotización */
    TimeLimit = ''.
    IF FacTabla.campo-c[1] > '' AND FacTabla.campo-c[1] > '0000' THEN DO:
        TimeLimit = STRING(FacTabla.campo-c[1], 'XX:XX').
        IF STRING(TIME, 'HH:MM') > TimeLimit THEN NEXT RLOOP.
    END.
    TimeOut = 0.
    IF FacTabla.valor[1] > 0 THEN TimeOut = (FacTabla.Valor[1] * 3600).       /* Tiempo máximo en segundos */
    dtDesde = ADD-INTERVAL(NOW, (-1 * TimeOut) , 'seconds').
    fDesde = DATE(dtDesde).
    cHora  = ENTRY(2,STRING(dtDesde, '99/99/9999 HH:MM'), ' ').
    /* Estados Válidos */
    x-flg-reserva-stock = "P".
    FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                                x-vtatabla.tabla = "CONFIG-VTAS" AND
                                x-vtatabla.llave_c1 = "PEDIDO.COMERCIAL" AND
                                x-vtatabla.llave_c2 = "FLG.RESERVA.STOCK" AND
                                x-vtatabla.llave_c3 = FacTabla.Codigo NO-LOCK NO-ERROR.     /* division */
    IF AVAILABLE x-vtatabla THEN DO:
       IF NOT (TRUE <> (x-vtatabla.llave_c4 > "")) THEN DO:
            x-flg-reserva-stock = TRIM(x-vtatabla.llave_c4).
       END.
    END.
    /* Barremos todas las cotizaciones relacionadas */
    FOR EACH B-DPEDI NO-LOCK /*USE-INDEX Llave05*/ WHERE B-DPEDI.codcia = s-CodCia
        AND B-DPEDI.codmat = pCodMat
        AND B-DPEDI.coddoc = 'COT'
        AND B-DPEDI.flgest = 'P' 
        AND B-DPEDI.almdes = pCodAlm
        AND B-DPEDI.fchped >= fDesde,
        FIRST B-CPEDI OF B-DPEDI NO-LOCK WHERE B-CPEDI.CodDiv = FacTabla.Codigo:
        IF B-DPEDI.fchped > TODAY THEN NEXT.
        IF LOOKUP(B-CPEDI.FlgEst,x-Flg-Reserva-Stock) = 0 THEN NEXT.
        IF B-DPEDI.CanAte >= B-DPEDI.CanPed THEN NEXT.
        IF B-DPEDI.fchped = fDesde AND B-DPEDI.hora < cHora THEN NEXT.
        /* cantidad en reserva */
        pComprometido = pComprometido + (B-DPEDI.Factor * (B-DPEDI.CanPed - B-DPEDI.CanAte)).
    END.
END.
/* ********************************************************************************************* */

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
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pFlgEst AS CHAR.
DEF INPUT PARAMETER pFecha AS DATE.
DEF INPUT-OUTPUT PARAMETER pComprometido AS DECI.

DEFINE VAR x-flg-reserva-stock AS CHAR.
DEF VAR k AS INTE NO-UNDO.

DEFINE VAR lEncontrado AS LOGICAL NO-UNDO INITIAL FALSE.
DEFINE VAR xfechaOld AS DATE.
DEFINE VAR xfecha AS DATE.

xfecha = TODAY.

/* Recorremos el detalle ordenado por fecha de menor a mayor */
FOR EACH facdpedi WHERE facdpedi.codcia = s-codcia
                    AND facdpedi.codmat = pCodMat 
                    AND facdpedi.coddoc = pCodDoc 
                    AND facdpedi.flgest = "P" 
                    AND facdpedi.almdes = pCodAlm 
                    /*AND facdpedi.fchped >= 01/01/2024 */
                    AND facdpedi.CanAte < facdpedi.canped 
                    AND facdpedi.fchped <= xfecha
                  NO-LOCK
                  BY facdpedi.fchped: /* <--- Garantiza que empiece por el más antiguo */

    /* Validamos inmediatamente la cabecera correspondiente */
    FIND FIRST faccpedi WHERE faccpedi.codcia = facdpedi.codcia
                          AND faccpedi.coddoc = facdpedi.coddoc
                          AND faccpedi.nroped = facdpedi.nroped
                          AND faccpedi.flgest <> "A"
    NO-LOCK NO-ERROR.

    /* Si la cabecera existe y NO está anulada, este es nuestro registro más antiguo */
    IF AVAILABLE faccpedi THEN DO:
        /*MESSAGE "El más antiguo es del: " facdpedi.fchped VIEW-AS ALERT-BOX INFO BUTTONS OK.*/
        lEncontrado = TRUE.
        xfechaOld = facdpedi.fchped.
        LEAVE. /* Rompe el bucle inmediatamente para no seguir buscando */
    END.
END.

IF lEncontrado THEN DO:
    x-flg-reserva-stock = pFlgEst.
    pFecha = xfechaOld.
    /* 03/02/2023 L.Mesia la OTR reserva stock de otra manera */
    FOR EACH B-DPEDI NO-LOCK WHERE B-DPEDI.codcia = s-codcia
        AND B-DPEDI.codmat = pCodMat
        AND B-DPEDI.coddoc = pCodDoc
        AND B-DPEDI.flgest = "P"
        AND B-DPEDI.almdes = pCodAlm       
        AND B-DPEDI.FchPed >= pFecha,
        FIRST B-CPEDI OF B-DPEDI NO-LOCK:
        IF B-DPEDI.CanAte >= B-DPEDI.canped THEN NEXT.
        IF LOOKUP(B-CPEDI.FlgEst, x-flg-reserva-stock) = 0 THEN NEXT.
        pComprometido = pComprometido + (B-DPEDI.Factor * (B-DPEDI.CanPed - B-DPEDI.canate)).
    END.
END.

/*
CASE pCodDoc:
    WHEN "COT" THEN DO:
        FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                                    x-vtatabla.tabla = "CONFIG-VTAS" AND
                                    x-vtatabla.llave_c1 = "PEDIDO.COMERCIAL" AND
                                    x-vtatabla.llave_c2 = "FLG.RESERVA.STOCK" AND
                                    x-vtatabla.llave_c3 = FacTabla.Codigo NO-LOCK NO-ERROR.     /* division */
        IF AVAILABLE x-vtatabla THEN DO:
           IF NOT (TRUE <> (x-vtatabla.llave_c4 > "")) THEN DO:
                x-flg-reserva-stock = TRIM(x-vtatabla.llave_c4).
           END.
        END.
        FOR EACH B-DPEDI NO-LOCK WHERE B-DPEDI.codcia = s-CodCia
            AND B-DPEDI.codmat = pCodMat
            AND B-DPEDI.coddoc = pCodDoc 
            AND B-DPEDI.flgest = 'P'    
            AND B-DPEDI.almdes = pCodAlm ,
            FIRST B-CPEDI WHERE B-CPEDI.codcia = B-DPEDI.codcia
                                        AND B-CPEDI.coddiv = B-DPEDI.coddiv
                                        AND B-CPEDI.coddoc = B-DPEDI.coddoc
                                        AND B-CPEDI.nroped = B-DPEDI.nroped NO-LOCK :

            IF LOOKUP(B-CPEDI.FlgEst,x-flg-reserva-stock) = 0 THEN NEXT.
            IF B-DPEDI.CanAte >= B-DPEDI.canped THEN NEXT.

            pComprometido = pComprometido + (B-DPEDI.Factor * (B-DPEDI.CanPed - B-DPEDI.canate)).
        END.
    END.
    OTHERWISE DO:   /* OTR y O/D */
        FOR EACH B-DPEDI NO-LOCK WHERE B-DPEDI.codcia = s-CodCia
                AND B-DPEDI.codmat = pCodMat
                AND B-DPEDI.coddoc = pCodDoc 
                AND B-DPEDI.flgest = 'P',
            FIRST B-CPEDI NO-LOCK WHERE B-CPEDI.codcia = B-DPEDI.codcia
                AND B-CPEDI.coddiv = B-DPEDI.coddiv
                AND B-CPEDI.coddoc = B-DPEDI.coddoc
                AND B-CPEDI.nroped = B-DPEDI.nroped 
                AND B-CPEDI.codalm = pCodAlm:       /* OJO: Almacén que despacha */
            IF LOOKUP(B-CPEDI.FlgEst,x-flg-reserva-stock) = 0 THEN NEXT.
            IF B-DPEDI.CanAte >= B-DPEDI.canped THEN NEXT.
            pComprometido = pComprometido + (B-DPEDI.Factor * (B-DPEDI.CanPed - B-DPEDI.canate)).
        END.
    END.
END CASE.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PED-Comprometido-Old) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PED-Comprometido-Old Procedure 
PROCEDURE PED-Comprometido-Old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pFlgEst AS CHAR.
DEF INPUT-OUTPUT PARAMETER pComprometido AS DECI.

DEFINE VAR x-flg-reserva-stock AS CHAR.
DEF VAR k AS INTE NO-UNDO.

x-flg-reserva-stock = pFlgEst.
/* 03/02/2023 L.Mesia la OTR reserva stock de otra manera */
CASE pCodDoc:
    WHEN "COT" THEN DO:
        FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                                    x-vtatabla.tabla = "CONFIG-VTAS" AND
                                    x-vtatabla.llave_c1 = "PEDIDO.COMERCIAL" AND
                                    x-vtatabla.llave_c2 = "FLG.RESERVA.STOCK" AND
                                    x-vtatabla.llave_c3 = FacTabla.Codigo NO-LOCK NO-ERROR.     /* division */
        IF AVAILABLE x-vtatabla THEN DO:
           IF NOT (TRUE <> (x-vtatabla.llave_c4 > "")) THEN DO:
                x-flg-reserva-stock = TRIM(x-vtatabla.llave_c4).
           END.
        END.
        FOR EACH B-DPEDI NO-LOCK WHERE B-DPEDI.codcia = s-CodCia
            AND B-DPEDI.codmat = pCodMat
            AND B-DPEDI.coddoc = pCodDoc 
            AND B-DPEDI.flgest = 'P'    
            AND B-DPEDI.almdes = pCodAlm ,
            FIRST B-CPEDI WHERE B-CPEDI.codcia = B-DPEDI.codcia
                                        AND B-CPEDI.coddiv = B-DPEDI.coddiv
                                        AND B-CPEDI.coddoc = B-DPEDI.coddoc
                                        AND B-CPEDI.nroped = B-DPEDI.nroped NO-LOCK :

            IF LOOKUP(B-CPEDI.FlgEst,x-flg-reserva-stock) = 0 THEN NEXT.
            IF B-DPEDI.CanAte >= B-DPEDI.canped THEN NEXT.

            pComprometido = pComprometido + (B-DPEDI.Factor * (B-DPEDI.CanPed - B-DPEDI.canate)).
        END.
    END.
    OTHERWISE DO:   /* OTR y O/D */
        FOR EACH B-DPEDI NO-LOCK WHERE B-DPEDI.codcia = s-CodCia
                AND B-DPEDI.codmat = pCodMat
                AND B-DPEDI.coddoc = pCodDoc 
                AND B-DPEDI.flgest = 'P',
            FIRST B-CPEDI NO-LOCK WHERE B-CPEDI.codcia = B-DPEDI.codcia
                AND B-CPEDI.coddiv = B-DPEDI.coddiv
                AND B-CPEDI.coddoc = B-DPEDI.coddoc
                AND B-CPEDI.nroped = B-DPEDI.nroped 
                AND B-CPEDI.codalm = pCodAlm:       /* OJO: Almacén que despacha */
            IF LOOKUP(B-CPEDI.FlgEst,x-flg-reserva-stock) = 0 THEN NEXT.
            IF B-DPEDI.CanAte >= B-DPEDI.canped THEN NEXT.
            pComprometido = pComprometido + (B-DPEDI.Factor * (B-DPEDI.CanPed - B-DPEDI.canate)).
        END.
    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

