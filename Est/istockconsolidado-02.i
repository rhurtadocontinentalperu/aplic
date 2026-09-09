&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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

/*
    Ic - 17Set2014 :
    estavtas.DimProducto.CodMat se cambio por tt-DimProducto.CodMat
*/

FIND {&Base}.FacCfgGn WHERE {&Base}.FacCfgGn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE {&Base}.FacCfgGn THEN RETURN.

/* Stock comprometido por PEDIDOS ACTIVOS MOSTRADOR */
DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.

/* Tiempo por defecto fuera de campaña */
TimeOut = ({&Base}.FacCfgGn.Dias-Res * 24 * 3600) +
          ({&Base}.FacCfgGn.Hora-Res * 3600) + 
          ({&Base}.FacCfgGn.Minu-Res * 60).

x-StockComprometido = 0.
DEF VAR i AS INT NO-UNDO.
DEF VAR x-CodAlm AS CHAR NO-UNDO.

DO i = 1 TO NUM-ENTRIES({&Base}.Almmmate.CodAlm):
    x-CodAlm = ENTRY(i, {&Base}.Almmmate.CodAlm).
    /**********   Barremos para los PEDIDOS MOSTRADOR ***********************/ 
    FOR EACH {&Base}.Facdpedi USE-INDEX Llave04 NO-LOCK WHERE {&Base}.Facdpedi.CodCia = s-codcia
        AND {&Base}.Facdpedi.AlmDes = x-CodAlm
        AND {&Base}.Facdpedi.codmat = tt-DimProducto.CodMat /*estavtas.DimProducto.CodMat*/
        AND {&Base}.Facdpedi.coddoc = 'P/M'
        AND {&Base}.Facdpedi.FlgEst = "P" :
        FIND FIRST {&Base}.Faccpedi OF {&Base}.Facdpedi WHERE {&Base}.Faccpedi.FlgEst = "P" NO-LOCK NO-ERROR.
        IF NOT AVAIL {&Base}.Faccpedi THEN NEXT.

        TimeNow = (TODAY - {&Base}.Faccpedi.FchPed) * 24 * 3600.
        TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING({&Base}.Faccpedi.Hora, 1, 2)) * 3600) +
                  (INTEGER(SUBSTRING({&Base}.Faccpedi.Hora, 4, 2)) * 60) ).
        IF TimeOut > 0 THEN DO:
            IF TimeNow <= TimeOut   /* Dentro de la valides */
            THEN DO:
                /* cantidad en reservacion */
                x-StockComprometido = x-StockComprometido + {&Base}.Facdpedi.Factor * {&Base}.Facdpedi.CanPed.
            END.
        END.
    END.
    /**********   Barremos para los PEDIDOS AL CREDITO   ***********************/ 
    FOR EACH {&Base}.Facdpedi USE-INDEX Llave04 NO-LOCK WHERE {&Base}.Facdpedi.codcia = s-codcia
            AND {&Base}.Facdpedi.almdes = x-CodAlm
            AND {&Base}.Facdpedi.codmat = tt-DimProducto.CodMat  /*estavtas.DimProducto.CodMat*/
            AND {&Base}.Facdpedi.coddoc = 'PED'
            AND {&Base}.Facdpedi.flgest = 'P':
        /* RHC 12.12.2011 agregamos los nuevos estados */
        FIND FIRST {&Base}.Faccpedi OF {&Base}.Facdpedi WHERE LOOKUP({&Base}.Faccpedi.FlgEst, "G,X,P,W,WX,WL") > 0 NO-LOCK NO-ERROR.
        IF NOT AVAILABLE {&Base}.Faccpedi THEN NEXT.
        x-StockComprometido = x-StockComprometido + {&Base}.Facdpedi.Factor * ({&Base}.Facdpedi.CanPed - {&Base}.Facdpedi.canate).
    END.
    /* ORDENES DE DESPACHO CREDITO */
    FOR EACH {&Base}.Facdpedi USE-INDEX Llave04 NO-LOCK WHERE {&Base}.Facdpedi.codcia = s-codcia
            AND {&Base}.Facdpedi.almdes = x-CodAlm
            AND {&Base}.Facdpedi.codmat = tt-DimProducto.CodMat /*estavtas.DimProducto.CodMat*/
            AND {&Base}.Facdpedi.coddoc = 'O/D'
            AND {&Base}.Facdpedi.flgest = 'P':
        FIND FIRST {&Base}.Faccpedi OF {&Base}.Facdpedi WHERE {&Base}.Faccpedi.flgest = 'P' NO-LOCK NO-ERROR.
        IF NOT AVAILABLE {&Base}.Faccpedi THEN NEXT.
        x-StockComprometido = x-StockComprometido + {&Base}.Facdpedi.Factor * ({&Base}.Facdpedi.CanPed - {&Base}.Facdpedi.canate).
    END.
    /* Stock Comprometido por Pedidos por Reposicion Automatica */
    FOR EACH {&Base}.Almcrepo NO-LOCK WHERE {&Base}.Almcrepo.codcia = s-codcia
        AND {&Base}.Almcrepo.AlmPed = x-CodAlm
        AND {&Base}.Almcrepo.FlgEst = 'P'
        AND LOOKUP({&Base}.Almcrepo.FlgSit, 'A,P') > 0,
        EACH {&Base}.Almdrepo OF {&Base}.Almcrepo NO-LOCK WHERE {&Base}.Almdrepo.codmat = tt-DimProducto.CodMat /*estavtas.DimProducto.CodMat*/
        AND {&Base}.Almdrepo.CanApro > {&Base}.Almdrepo.CanAten:
        x-StockComprometido = x-StockComprometido + ({&Base}.Almdrepo.CanApro - {&Base}.Almdrepo.CanAten).
    END.
    /* POR ORDENES DE TRANSFERENCIA */
    FOR EACH {&Base}.Facdpedi USE-INDEX Llave04 NO-LOCK WHERE {&Base}.Facdpedi.codcia = s-codcia
            AND {&Base}.Facdpedi.almdes = x-CodAlm
            AND {&Base}.Facdpedi.codmat = tt-DimProducto.CodMat
            AND {&Base}.Facdpedi.coddoc = 'OTR'
            AND {&Base}.Facdpedi.flgest = 'P':
        FIND FIRST {&Base}.Faccpedi OF {&Base}.Facdpedi WHERE Faccpedi.flgest = 'P' NO-LOCK NO-ERROR.
        IF NOT AVAILABLE {&Base}.Faccpedi THEN NEXT.
        x-StockComprometido = x-StockComprometido + {&Base}.FacDPedi.Factor * ({&Base}.FacDPedi.CanPed - {&Base}.FacDPedi.CanAte).
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 4.92
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


