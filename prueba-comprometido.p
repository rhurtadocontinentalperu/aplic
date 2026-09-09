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
         HEIGHT             = 3.88
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pContado AS LOG.
DEF OUTPUT PARAMETER pComprometido AS DEC.

pComprometido = 0.  /* Valor por defecto */   

IF NUM-ENTRIES(pCodAlm) > 1 THEN pCodAlm = ENTRY(1, pCodAlm).   /* El 1er almacén */

/* CALCULO DEL STOCK COMPROMETIDO */
DEF SHARED VAR s-codcia AS INT.

FIND FIRST integral.FacCfgGn WHERE integral.faccfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE integral.Faccfggn THEN RETURN.

/* IMPSTO BOLSAS PLASTOCAS NO CONTROLA STOCK */
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

/* Stock comprometido por PEDIDOS ACTIVOS MOSTRADOR */
DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.
DEF VAR TimeLimit AS CHARACTER NO-UNDO.

/*
IF pContado = YES THEN DO:
    /* Tiempo por defecto fuera de campaña */
    TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
              (FacCfgGn.Hora-Res * 3600) + 
              (FacCfgGn.Minu-Res * 60).
    FOR EACH B-DPEDI USE-INDEX Llave04 NO-LOCK WHERE B-DPEDI.codcia = s-CodCia
        AND B-DPEDI.almdes = pCodAlm
        AND B-DPEDI.codmat = pCodMat
        AND B-DPEDI.coddoc = 'P/M'
        AND B-DPEDI.flgest = 'P',
        FIRST B-CPEDI OF B-DPEDI NO-LOCK WHERE B-CPEDI.FlgEst = "P":
        TimeNow = (TODAY - B-CPEDI.FchPed) * 24 * 3600.
        TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(B-CPEDI.Hora, 1, 2)) * 3600) +
                  (INTEGER(SUBSTRING(B-CPEDI.Hora, 4, 2)) * 60) ).
        IF TimeOut > 0 THEN DO:
            IF TimeNow <= TimeOut   /* Dentro de la valides */
            THEN DO:
                pComprometido = pComprometido + (B-DPEDI.Factor * B-DPEDI.CanPed).
            END.
        END.
    END.
END.


/* RHC 23/04/2020 Mercadería comprometida por Cotizaciones */
/* Barremos todas las divisiones que comprometen stock por COTIZACIONES */
RLOOP:
FOR EACH FacTabla NO-LOCK WHERE FacTabla.codcia = s-CodCia AND
    FacTabla.tabla = 'GN-DIVI' AND
    FacTabla.campo-l[2] = YES:
    /* RHC 21/05/2020 Ahora tiene horas y/o hora tope */
    /* Pasada esa hora NO vale la Cotización */
    TimeLimit = ''.
    IF FacTabla.campo-c[1] > '' AND FacTabla.campo-c[1] > '0000' THEN DO:
        TimeLimit = STRING(FacTabla.campo-c[1], 'XX:XX').
        IF STRING(TIME, 'HH:MM') > TimeLimit THEN NEXT RLOOP.
    END.
    TimeOut = 0.
    IF FacTabla.valor[1] > 0 THEN TimeOut = (FacTabla.Valor[1] * 3600).       /* Tiempo máximo en en segundos */
    /* Barremos todas las cotizaciones relacionadas */
    FOR EACH B-DPEDI USE-INDEX Llave04 NO-LOCK WHERE B-DPEDI.codcia = s-CodCia
        AND B-DPEDI.almdes = pCodAlm
        AND B-DPEDI.codmat = pCodMat
        AND B-DPEDI.coddoc = 'COT'
        AND B-DPEDI.flgest = 'P'
        AND B-DPEDI.coddiv = factabla.codigo,
        FIRST B-CPEDI OF B-DPEDI NO-LOCK WHERE B-CPEDI.CodDiv = FacTabla.Codigo AND 
        B-CPEDI.FlgEst = "P":
        TimeNow = (TODAY - B-CPEDI.FchPed) * 24 * 3600.
        TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(B-CPEDI.Hora, 1, 2)) * 3600) +
                  (INTEGER(SUBSTRING(B-CPEDI.Hora, 4, 2)) * 60) ).
        IF TimeOut > 0 THEN DO:
            IF TimeNow <= TimeOut   /* Dentro de la valides */
            THEN DO:
                pComprometido = pComprometido + (B-DPEDI.Factor * (B-DPEDI.CanPed - B-DPEDI.CanAte)).
            END.
        END.
    END.
END.
*/



/*
/**********   Barremos para los PEDIDOS AL CREDITO   ***********************/ 
DEF VAR LocalCodDoc AS CHAR INIT 'PED,O/D,OTR' NO-UNDO.
DEF VAR LocalItem AS INT NO-UNDO.

DO LocalItem = 1 TO 3:
    FOR EACH B-DPEDI USE-INDEX Llave04 NO-LOCK WHERE B-DPEDI.codcia = s-CodCia
        AND B-DPEDI.almdes = pCodAlm
        AND B-DPEDI.codmat = pCodMat
        AND B-DPEDI.coddoc = ENTRY(LocalItem, LocalCodDoc)
        AND B-DPEDI.flgest = 'P',
        FIRST B-CPEDI OF B-DPEDI NO-LOCK:
        IF B-CPEDI.CodDoc = 'PED' AND NOT LOOKUP(B-CPEDI.FlgEst, "G,X,P,W,WX,WL") > 0 THEN NEXT.
        IF B-CPEDI.CodDoc = 'O/D' AND NOT B-CPEDI.flgest = 'P' THEN NEXT.
        IF B-CPEDI.CodDoc = 'OTR' AND NOT B-CPEDI.flgest = 'P' THEN NEXT.
        pComprometido = pComprometido + (B-DPEDI.Factor * (B-DPEDI.CanPed - B-DPEDI.canate)).
    END.
END.
*/

/* Stock Comprometido por Pedidos por Reposicion Automatica */
/* A: R/A Automática */
/* M: R/A Manual */
/* RAN: R/A Nocturna */
/* INC: R/A por Incidencia */
/* OJO ver tambien el programa vtamay/c-conped.w */

FOR EACH B-DREPO NO-LOCK WHERE B-DREPO.codcia = s-CodCia
    AND B-DREPO.codmat = pCodMat
    AND LOOKUP(B-DREPO.TipMov, 'A,M,RAN,INC') > 0,
    FIRST B-CREPO OF B-DREPO NO-LOCK:
    IF NOT (B-CREPO.almped = pCodAlm AND B-CREPO.flgest = 'P') THEN NEXT.
    IF NOT (B-DREPO.CanApro > B-DREPO.CanAten) THEN NEXT.
    pComprometido = pComprometido + (B-DREPO.CanApro - B-DREPO.CanAten).
END.
/*
FOR EACH B-CREPO USE-INDEX Llave02 NO-LOCK WHERE B-CREPO.codcia = s-CodCia
    AND B-CREPO.almped = pCodAlm
    AND B-CREPO.flgest = 'P'
    AND LOOKUP(B-CREPO.TipMov, 'A,M,RAN,INC') > 0,
    FIRST B-DREPO OF B-CREPO NO-LOCK WHERE B-DREPO.codmat = pCodMat:
    IF NOT (B-DREPO.CanApro > B-DREPO.CanAten) THEN NEXT.
    pComprometido = pComprometido + (B-DREPO.CanApro - B-DREPO.CanAten).
END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


