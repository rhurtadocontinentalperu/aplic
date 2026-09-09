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
         HEIGHT             = 4.96
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE LocalImpIgv AS DECIMAL NO-UNDO.
DEFINE VARIABLE LocalImpIsc AS DECIMAL NO-UNDO.
DEFINE VARIABLE LocalDto2xExonerados AS DEC NO-UNDO.
DEFINE VARIABLE LocalDto2xAfectosIgv AS DEC NO-UNDO.
  
ASSIGN
    {&Cabecera}.ImpDto = 0
    {&Cabecera}.ImpDto2 = 0
    {&Cabecera}.ImpIgv = 0
    {&Cabecera}.ImpIsc = 0
    {&Cabecera}.ImpTot = 0
    {&Cabecera}.ImpExo = 0
    {&Cabecera}.Importe[3] = 0
    LocalImpIgv = 0
    LocalImpIsc = 0
    LocalDto2xExonerados = 0
    LocalDto2xAfectosIgv = 0.
/* RHC 15/08/19 pedido por G.P.: Impuesto a la bolsa plástica */
ASSIGN
    {&Cabecera}.AcuBon[10] = 0.

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
    LocalImpIgv = LocalImpIgv + {&Detalle}.ImpIgv.
    LocalImpIsc = LocalImpIsc + {&Detalle}.ImpIsc.

    {&Cabecera}.ImpTot = {&Cabecera}.ImpTot + {&Detalle}.ImpLin.
    {&Cabecera}.ImpDto2 = {&Cabecera}.ImpDto2 + {&Detalle}.ImpDto2.

     IF {&Detalle}.AftIgv = YES
     THEN {&Cabecera}.ImpDto = {&Cabecera}.ImpDto + ROUND({&Detalle}.ImpDto / (1 + {&Cabecera}.PorIgv / 100), 2).
     ELSE {&Cabecera}.ImpDto = {&Cabecera}.ImpDto + {&Detalle}.ImpDto.

    /* BOLSAS PLASTICAS */
    IF {&Detalle}.codmat = x-articulo-ICBPER THEN DO:
        /* Inafecto */
        ASSIGN {&Cabecera}.AcuBon[10] = {&Cabecera}.AcuBon[10] + {&Detalle}.implin.
    END.
    ELSE DO:
        IF NOT {&Detalle}.AftIgv THEN {&Cabecera}.ImpExo = {&Cabecera}.ImpExo + {&Detalle}.ImpLin.

        IF NOT {&Detalle}.AftIgv THEN LocalDto2xExonerados = LocalDto2xExonerados + {&Detalle}.ImpDto2.
        ELSE LocalDto2xAfectosIgv = LocalDto2xAfectosIgv + {&Detalle}.ImpDto2.
    END.

END.

ASSIGN
    {&Cabecera}.ImpIgv = ROUND(LocalImpIgv,2)
    {&Cabecera}.ImpIsc = ROUND(LocalImpIsc,2).
ASSIGN
    {&Cabecera}.ImpVta = {&Cabecera}.ImpTot - {&Cabecera}.ImpExo - {&Cabecera}.ImpIgv - {&Cabecera}.AcuBon[10].
ASSIGN
    {&Cabecera}.ImpBrt = {&Cabecera}.ImpVta + {&Cabecera}.ImpDto
    {&Cabecera}.Importe[1] = {&Cabecera}.ImpTot.    /* Guardamos el importe original */
/* RHC 06/05/2014 En caso tenga descuento por Encarte */
IF {&Cabecera}.ImpDto2 > 0 THEN DO:
    ASSIGN
        {&Cabecera}.ImpTot = {&Cabecera}.ImpTot - {&Cabecera}.ImpDto2
        {&Cabecera}.ImpIgv = {&Cabecera}.ImpIgv -  ~
            ROUND(LocalDto2xAfectosIgv / ( 1 + {&Cabecera}.PorIgv / 100) * {&Cabecera}.PorIgv / 100, 2)
        {&Cabecera}.ImpExo = {&Cabecera}.ImpExo - LocalDto2xExonerados
        {&Cabecera}.ImpVta = {&Cabecera}.ImpTot - {&Cabecera}.ImpExo - {&Cabecera}.ImpIgv - {&Cabecera}.AcuBon[10]
        {&Cabecera}.ImpBrt = {&Cabecera}.ImpVta + {&Cabecera}.ImpDto.
END.
/* ******************************************** */
/* RHC 15/08/19 IMPUESTO A LA BOLSA DE PLASTICO */
/* ******************************************** */
ASSIGN
    {&Cabecera}.ImpTot = {&Cabecera}.ImpTot /*+ {&Cabecera}.AcuBon[10]*/.

/* PERCEPCION */
RUN vta2/percepcion-por-pedido ( ROWID({&Cabecera}) ).

/* *************************************** */
FIND CURRENT {&Cabecera} EXCLUSIVE-LOCK.
/* *************************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


