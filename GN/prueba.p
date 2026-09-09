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
    FOR EACH B-DPEDI NO-LOCK USE-INDEX llave05 WHERE B-DPEDI.codcia = s-CodCia
        AND B-DPEDI.codmat = pCodMat
        AND B-DPEDI.coddoc = 'P/M'
        AND B-DPEDI.flgest = 'P'
        AND B-DPEDI.almdes = pCodAlm
        AND (B-DPEDI.fchped >= fDesde 
        AND B-DPEDI.fchped <= TODAY),
        FIRST B-CPEDI OF B-DPEDI NO-LOCK WHERE B-CPEDI.FlgEst = "P":
        IF B-DPEDI.fchped = fDesde AND B-DPEDI.hora < cHora THEN NEXT.
        /* cantidad en reservacion */
        pComprometido = pComprometido + (B-DPEDI.Factor * B-DPEDI.CanPed).
    END.
END.
/* ********************************************************************************************* */
/**********   Barremos para los PEDIDOS AL CREDITO   ***********************/ 
/* ********************************************************************************************* */
RUN PED-Comprometido (pCodAlm,pCodMat,"O/D","P",INPUT-OUTPUT pComprometido).

RUN PED-Comprometido (pCodAlm,pCodMat,"OTR","P",INPUT-OUTPUT pComprometido).

DEF VAR LocalDiasComprometido AS DECI INIT 30 NO-UNDO.      /* Exagerando */

FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-codcia AND 
    VtaTabla.Tabla = 'CONFIG-VTAS' AND 
    VtaTabla.Llave_c1 = 'STOCK-COMPROMETIDO'
    NO-LOCK NO-ERROR.
IF AVAILABLE VtaTabla AND VtaTabla.Valor[01] > 0 THEN LocalDiasComprometido = VtaTabla.Valor[01].

x-flg-reserva-stock = "G,X,P,W,WX,WL".

DEFINE VAR x-sec AS INT.
DEFINE VAR x-fecha AS DATE.

x-fecha = (TODAY - LocalDiasComprometido).

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
    IF B-DPEDI.canate >= B-DPEDI.CanPed THEN NEXT.
    pComprometido = pComprometido + (B-DPEDI.Factor * (B-DPEDI.CanPed - B-DPEDI.canate)).
END.

DEF VAR j AS INTE NO-UNDO.
DEF VAR x-FlgEst AS CHAR INIT 'P,X' NO-UNDO.

DO j = 1 TO 2:
    FOR EACH B-CREPO NO-LOCK WHERE B-CREPO.codcia = s-codcia AND
        B-CREPO.almped = pCodAlm AND
        B-CREPO.flgest = ENTRY(j, x-FlgEst) AND
        LOOKUP(B-CREPO.tipmov, 'A,M,RAN,INC') > 0,
        FIRST B-DREPO OF B-CREPO NO-LOCK WHERE B-DREPO.codmat = pCodMat AND
        B-DREPO.flgest = "P":
        IF B-DREPO.CanApro < B-DREPO.CanAten THEN NEXT.
        pComprometido = pComprometido + (B-DREPO.CanApro - B-DREPO.CanAten).
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
    FOR EACH B-DPEDI NO-LOCK USE-INDEX Llave05 WHERE B-DPEDI.codcia = s-CodCia
        AND B-DPEDI.codmat = pCodMat
        AND B-DPEDI.coddoc = 'COT'
        AND B-DPEDI.flgest = 'P' 
        AND B-DPEDI.almdes = pCodAlm
        AND (B-DPEDI.fchped >= fDesde 
        AND B-DPEDI.fchped <= TODAY),
        FIRST B-CPEDI OF B-DPEDI NO-LOCK WHERE B-CPEDI.CodDiv = FacTabla.Codigo:
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

x-flg-reserva-stock = pFlgEst.

IF pCodDoc = "COT" THEN DO:   
    /*  Ic - 10Feb2021
        Divisiones que tienen que reservar Stock con un flgest en particular
     
        Correo de Daniel Llican, meet con Karim Mujica y Hiroshi Salcedo
        3. Una programación excepcional (si es posible que sea configurable) que rompa la actual regla del 
            canal mayorista para que no sea necesario aprobaciones de administrador y supervisor antes de 
            reservar stock, ya que en el canal de venta minorista whatsapp quien registra el pedido comercial 
            es un administrador, comparativamente con un vendedor la posibilidad de error es mucho menor 
            (pedido comercial OK en SKU y Cantidad al primer intento).        
     */
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
END.

DEF VAR k AS INTE NO-UNDO.
/*
DO k = 1 TO NUM-ENTRIES(x-flg-reserva-stock):
    FOR EACH B-DPEDI NO-LOCK WHERE B-DPEDI.codcia = s-CodCia
        AND B-DPEDI.codmat = pCodMat
        AND B-DPEDI.coddoc = pCodDoc 
        AND B-DPEDI.flgest = 'P'    
        AND B-DPEDI.almdes = pCodAlm 
        AND B-DPEDI.CanPed > B-DPEDI.canate:
        FIND FIRST B-CPEDI OF B-DPEDI WHERE B-CPEDI.FlgEst = ENTRY(k, x-flg-reserva-stock) NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-CPEDI THEN NEXT.
        pComprometido = pComprometido + (B-DPEDI.Factor * (B-DPEDI.CanPed - B-DPEDI.canate)).
    END.
END.
*/
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


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

