&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Importe total para FacCPedi (COT PED O/D P/M)

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

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
         HEIGHT             = 4.04
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE Local_Importe_Igv AS DECIMAL NO-UNDO.
DEFINE VARIABLE Local_Importe_Isc AS DECIMAL NO-UNDO.
DEFINE VARIABLE Local_Dto2xExonerados AS DEC NO-UNDO.
DEFINE VARIABLE Local_Dto2xAfectosIgv AS DEC NO-UNDO.
DEFINE VAR x-Precio-ICBPER AS DECI NO-UNDO.
  
ASSIGN
    {&Cabecera}.ImpDto = 0
    {&Cabecera}.ImpDto2 = 0
    {&Cabecera}.ImpIgv = 0
    {&Cabecera}.ImpIsc = 0
    {&Cabecera}.ImpTot = 0
    {&Cabecera}.ImpExo = 0
    {&Cabecera}.Importe[3] = 0
    Local_Importe_Igv = 0
    Local_Importe_Isc = 0
    Local_Dto2xExonerados = 0
    Local_Dto2xAfectosIgv = 0.
/* RHC 15/08/19 pedido por G.P.: Impuesto a la bolsa plástica */
ASSIGN
    {&Cabecera}.AcuBon[10] = 0.

/* ********************************************************************************** */
/* Sacar el importe de bolsas plasticas */
/* ********************************************************************************** */
x-precio-ICBPER = 0.0.   

DEFINE VAR z-hProc AS HANDLE NO-UNDO.               /* Handle Libreria */

RUN ccb/libreria-ccb.p PERSISTENT SET z-hProc.

RUN precio-impsto-bolsas-plastica IN z-hProc (INPUT TODAY, OUTPUT x-precio-ICBPER).

DELETE PROCEDURE z-hProc.                   /* Release Libreria */
/* ********************************************************************************** */
/* ********************************************************************************** */
/* VENTAS INAFECTAS A IGV */
IF {&Cabecera}.FlgIgv = NO THEN DO:
    {&Cabecera}.PorIgv = 0.00.
    FOR EACH {&Detalle} OF {&Cabecera} EXCLUSIVE-LOCK:
        ASSIGN
            {&Detalle}.AftIgv = NO
            {&Detalle}.ImpIgv = 0.00.
    END.
END.

FOR EACH {&Detalle} OF {&Cabecera} NO-LOCK, FIRST Almmmatg OF {&Detalle} NO-LOCK:
    Local_Importe_Isc = Local_Importe_Isc + {&Detalle}.ImpIsc.

    {&Cabecera}.ImpTot = {&Cabecera}.ImpTot + {&Detalle}.ImpLin.
    {&Cabecera}.ImpDto2 = {&Cabecera}.ImpDto2 + {&Detalle}.ImpDto2.

     IF NOT {&Detalle}.AftIgv THEN {&Cabecera}.ImpExo = {&Cabecera}.ImpExo + {&Detalle}.ImpLin.

     IF {&Detalle}.AftIgv = YES THEN DO:
         Local_Importe_Igv = Local_Importe_Igv + {&Detalle}.ImpIgv.
         {&Cabecera}.ImpDto = {&Cabecera}.ImpDto + ROUND({&Detalle}.ImpDto / (1 + {&Cabecera}.PorIgv / 100), 2).
         Local_Dto2xAfectosIgv = Local_Dto2xAfectosIgv + {&Detalle}.ImpDto2.
     END.
     ELSE DO:
         {&Cabecera}.ImpDto = {&Cabecera}.ImpDto + {&Detalle}.ImpDto.
         Local_Dto2xExonerados = Local_Dto2xExonerados + {&Detalle}.ImpDto2.
     END.
     IF Almmmatg.CodFam = '086' 
         THEN {&Cabecera}.AcuBon[10] = {&Cabecera}.AcuBon[10] + ({&Detalle}.CanPed * {&Detalle}.Factor * x-precio-ICBPER).
END.
ASSIGN
    {&Cabecera}.Importe[1] = {&Cabecera}.ImpTot.    /* Guardamos el importe original */
/* RHC 06/05/2014 En caso tenga descuento por Encarte */
IF {&Cabecera}.ImpDto2 > 0 THEN DO:
    ASSIGN
        {&Cabecera}.ImpIsc = ROUND(Local_Importe_Isc,2).
    ASSIGN
        {&Cabecera}.ImpTot = {&Cabecera}.ImpTot - {&Cabecera}.ImpDto2
        {&Cabecera}.ImpExo = {&Cabecera}.ImpExo - Local_Dto2xExonerados.
    IF Local_Importe_Igv > 0 THEN
        ASSIGN
            {&Cabecera}.ImpIgv = Local_Importe_Igv -  ~
            ( Local_Dto2xAfectosIgv / ( 1 + {&Cabecera}.PorIgv / 100) * {&Cabecera}.PorIgv / 100 ).
    ASSIGN
        {&Cabecera}.ImpIgv = ROUND({&Cabecera}.ImpIgv,2).
END.
ELSE DO:
    ASSIGN
        {&Cabecera}.ImpIgv = ROUND(Local_Importe_Igv,2)
        {&Cabecera}.ImpIsc = ROUND(Local_Importe_Isc,2).
END.
ASSIGN
    {&Cabecera}.ImpVta = {&Cabecera}.ImpTot - {&Cabecera}.ImpExo - {&Cabecera}.ImpIgv - {&Cabecera}.AcuBon[10]
    {&Cabecera}.ImpBrt = {&Cabecera}.ImpVta + {&Cabecera}.ImpDto.
/* ******************************************** */
/* RHC 15/08/19 IMPUESTO A LA BOLSA DE PLASTICO */
/* ******************************************** */
ASSIGN
    {&Cabecera}.ImpTot = {&Cabecera}.ImpTot /*+ {&Cabecera}.AcuBon[10]*/.

/* PERCEPCION */
RUN vta2/percepcion-por-pedido.r ( ROWID({&Cabecera}) ).

/* RHC 22/07/2016 TRANSFERENCIAS GRATUITAS */
/* IF {&Cabecera}.FmaPgo = "900" THEN           */
/*     ASSIGN                                */
/*         {&Cabecera}.ImpBrt = 0               */
/*         {&Cabecera}.ImpExo = {&Cabecera}.ImpTot */
/*         {&Cabecera}.ImpDto = 0               */
/*         {&Cabecera}.ImpVta = 0               */
/*         {&Cabecera}.ImpIgv = 0.              */

/* *************************************** */
FIND CURRENT {&Cabecera} EXCLUSIVE-LOCK.
/* *************************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


