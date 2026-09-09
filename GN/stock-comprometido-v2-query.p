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

/* ************************************************************************************************************** */
/* DEFINIMOS LOS QUERYS */
/* ************************************************************************************************************** */
DEFINE VAR h-Query AS HANDLE NO-UNDO.

CREATE QUERY h-Query.
/* ************************************************************************************************************** */

IF pContado = YES THEN DO:
    h-Query:SET-BUFFERS(BUFFER Facdpedi:HANDLE, BUFFER Faccpedi:HANDLE).
    h-Query:QUERY-PREPARE("FOR EACH Facdpedi NO-LOCK WHERE Facdpedi.codcia = " + STRING(s-CodCia) +
        " AND Facdpedi.codmat = '" + pCodMat + "'" +
        " AND Facdpedi.coddoc = 'P/M' " +
        " AND Facdpedi.flgest = 'P' " +
        " AND Facdpedi.almdes = '" + pCodAlm + "'" +
        " AND (Facdpedi.fchped >= " + STRING(fDesde) + " AND Facdpedi.fchped <= " + STRING(TODAY) + ") , " +
        " FIRST Faccpedi OF Facdpedi NO-LOCK WHERE Faccpedi.FlgEst = 'P' ").
    h-Query:QUERY-OPEN().
    h-Query:GET-FIRST().
    DO WHILE NOT h-Query:QUERY-OFF-END:
        IF NOT (Facdpedi.fchped = fDesde AND Facdpedi.hora < cHora) THEN DO:
            pComprometido = pComprometido + (Facdpedi.Factor * Facdpedi.CanPed).
        END.
        h-Query:GET-NEXT().
    END.
    /*h-Query:QUERY-CLOSE().*/
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

h-Query:SET-BUFFERS(BUFFER Facdpedi:HANDLE, BUFFER Faccpedi:HANDLE).
h-Query:QUERY-PREPARE("FOR EACH Facdpedi NO-LOCK WHERE Facdpedi.codcia = " + STRING(s-CodCia) +
                      " AND Facdpedi.codmat = '" + pCodMat + "'" +
                      " AND Facdpedi.coddoc = 'PED' " +
                      " AND Facdpedi.flgest = 'P' " +
                      " AND Facdpedi.almdes = '" + pCodAlm + "'" +
                      " AND Facdpedi.fchped >= " + STRING(x-Fecha) + ", " +
                      " FIRST Faccpedi OF Facdpedi NO-LOCK").
h-Query:QUERY-OPEN().
h-Query:GET-FIRST().
DO WHILE NOT h-Query:QUERY-OFF-END:
    IF LOOKUP(Faccpedi.FlgEst,x-flg-reserva-stock) > 0 THEN DO:
        IF Facdpedi.CanAte < Facdpedi.canped 
            THEN pComprometido = pComprometido + (Facdpedi.Factor * (Facdpedi.CanPed - Facdpedi.canate)).
    END.
    h-Query:GET-NEXT().
END.
h-Query:QUERY-CLOSE().

DEF VAR j AS INTE NO-UNDO.
DEF VAR x-FlgEst AS CHAR INIT 'P,X' NO-UNDO.

DO j = 1 TO 2:
    h-Query:SET-BUFFERS(BUFFER Almcrepo:HANDLE, BUFFER Almdrepo:HANDLE).
    h-Query:QUERY-PREPARE("FOR EACH Almcrepo NO-LOCK WHERE Almcrepo.codcia = " + STRING(s-CodCia) +
                          " AND Almcrepo.almped = '" + pCodAlm + "'" +
                          " AND Almcrepo.flgest = ENTRY(" + STRING(j) + ", '" + x-FlgEst + "')" +
                          " AND LOOKUP(Almcrepo.tipmov, 'A,M,RAN,INC') > 0, " +
                          " FIRST Almdrepo OF Almcrepo NO-LOCK WHERE Almdrepo.codmat = '" + pCodMat + "'" +
                          " AND Almdrepo.flgest = 'P'").
    h-Query:QUERY-OPEN().
    h-Query:GET-FIRST().
    DO WHILE NOT h-Query:QUERY-OFF-END:
        IF Almdrepo.CanApro >= Almdrepo.CanAten 
            THEN pComprometido = pComprometido + (Almdrepo.CanApro - Almdrepo.CanAten).        
        h-Query:GET-NEXT().
    END.
    h-Query:QUERY-CLOSE().
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
    h-Query:SET-BUFFERS(BUFFER Facdpedi:HANDLE, BUFFER Faccpedi:HANDLE).
    h-Query:QUERY-PREPARE("FOR EACH Facdpedi NO-LOCK WHERE Facdpedi.codcia = " + STRING(s-CodCia) +
                          " AND Facdpedi.codmat = '" + pCodMat + "'" +
                          " AND Facdpedi.coddoc = 'COT' " +
                          " AND Facdpedi.flgest = 'P' " +
                          " AND Facdpedi.almdes = '" + pCodAlm + "'" +
                          " AND (Facdpedi.fchped >= " + STRING(fDesde) + " AND Facdpedi.fchped <= " + STRING(TODAY) + "), " +
                          " FIRST Faccpedi OF Facdpedi NO-LOCK WHERE Faccpedi.CodDiv = '" + FacTabla.Codigo + "'").
    h-Query:QUERY-OPEN().
    h-Query:GET-FIRST().
    DO WHILE NOT h-Query:QUERY-OFF-END:
        /* cantidad en reserva */
        IF LOOKUP(Faccpedi.FlgEst,x-Flg-Reserva-Stock) > 0 THEN DO:
            IF Facdpedi.CanAte < Facdpedi.CanPed THEN DO:
                IF NOT (Facdpedi.fchped = fDesde AND Facdpedi.hora < cHora) 
                    THEN  pComprometido = pComprometido + (Facdpedi.Factor * (Facdpedi.CanPed - Facdpedi.CanAte)).
            END.
        END.
        h-Query:GET-NEXT().
    END.
    h-Query:QUERY-CLOSE().
END.
/* ********************************************************************************************* */
/*h-Query:QUERY-CLOSE().*/
DELETE OBJECT h-Query.

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
        h-Query:SET-BUFFERS(BUFFER Facdpedi:HANDLE, BUFFER Faccpedi:HANDLE).
        h-Query:QUERY-PREPARE("FOR EACH Facdpedi NO-LOCK WHERE Facdpedi.codcia = " + STRING(s-CodCia) +
            " AND Facdpedi.codmat = '" + pCodMat + "'" +
            " AND Facdpedi.coddoc = '" + pCodDoc + "' " +
            " AND Facdpedi.flgest = 'P' " +
            " AND Facdpedi.almdes = '" + pCodAlm + "' ," +
            " FIRST Faccpedi OF Facdpedi NO-LOCK").
    END.
    OTHERWISE DO:   /* OTR y O/D */
        h-Query:SET-BUFFERS(BUFFER Facdpedi:HANDLE, BUFFER Faccpedi:HANDLE).
        h-Query:QUERY-PREPARE("FOR EACH Facdpedi NO-LOCK WHERE Facdpedi.codcia = " + STRING(s-CodCia) +
            " AND Facdpedi.codmat = '" + pCodMat + "'" +
            " AND Facdpedi.coddoc = '" + pCodDoc + "' " +
            " AND Facdpedi.flgest = 'P', " +
            " FIRST Faccpedi OF Facdpedi NO-LOCK WHERE Faccpedi.codalm = '" + pCodAlm  + "'").
    END.
END CASE.

h-Query:QUERY-OPEN().
h-Query:GET-FIRST().
DO WHILE NOT h-Query:QUERY-OFF-END:
    IF LOOKUP(Faccpedi.FlgEst,x-flg-reserva-stock) > 0 THEN DO:
        IF Facdpedi.CanAte < Facdpedi.canped 
            THEN pComprometido = pComprometido + (Facdpedi.Factor * (Facdpedi.CanPed - Facdpedi.canate)).
    END.
    h-Query:GET-NEXT().
END.
/*h-Query:QUERY-CLOSE().*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

