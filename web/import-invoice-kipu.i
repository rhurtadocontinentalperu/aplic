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

/* Transferencia gratuita */
DEF VAR x-es-transferencia-gratuita AS LOG NO-UNDO.
DEF VAR x-tasaigv AS DECI NO-UNDO.
DEF VAR x-factor-descuento AS DECI NO-UNDO.
DEF VAR x-dcto_otros_factor AS DECI NO-UNDO.
DEF VAR x-dcto_encarte AS DECI NO-UNDO.

DEFINE VAR x-items AS INT INIT 0.
DEFINE VAR x-filer1 AS DEC INIT 0.0000.
DEFINE VAR x-filer2 AS DEC INIT 0.0000.

DEFINE VAR x-linea-bolsas-plastica AS CHAR NO-UNDO.
DEFINE VAR x-articulo-ICBPER AS CHAR NO-UNDO.
DEFINE VAR x-existe-icbper AS LOG NO-UNDO.
DEFINE VAR x-exonerado AS DECI NO-UNDO.
DEFINE VAR x-gratuito AS DEC NO-UNDO.
DEFINE VAR x-sumaImporteTotalSinImpuesto AS DEC.
DEFINE VAR x-montoBaseIgv AS DEC.
DEFINE VAR x-sumaIGV AS DEC.
DEFINE VAR x-OtrosTributosOpGratuitas AS DEC. 
DEFINE VAR x-TotalImpuestos AS DEC.
DEFINE VAR x-CanDes LIKE Ccbddocu.CanDes NO-UNDO.

x-precio-ICBPER = 0.
x-TotalImpuestoBolsaPlastica = 0.

x-articulo-ICBPER = "099268".
x-linea-bolsas-plastica = "086".
x-tasaigv = {&Cabecera}.PorIgv / 100.

x-items = 0.
FOR EACH {&Detalle} OF {&Cabecera} NO-LOCK:
    FIND FIRST almmmatg OF {&Detalle} NO-LOCK NO-ERROR.    
    x-items = x-items + 1.
    IF x-items > 1 THEN LEAVE.
END.
x-es-transferencia-gratuita = NO.
IF LOOKUP({&Cabecera}.fmapgo,"899,900") > 0  THEN DO:
    x-es-transferencia-gratuita  = YES.
END.

x-exonerado = 0.
x-gratuito = 0.
x-gratuito = 0.
x-sumaImporteTotalSinImpuesto = 0.
x-montoBaseIgv = 0.
x-sumaIGV = 0.
x-OtrosTributosOpGratuitas = 0.

FOR EACH {&Detalle} OF {&Cabecera} EXCLUSIVE-LOCK:
    FIND FIRST almmmatg OF {&Detalle} NO-LOCK NO-ERROR.
    IF {&Detalle}.codmat = x-articulo-ICBPER THEN DO:
        /* Ya no considerar el item ICBPER como articulo */
        NEXT.
    END.
    /* Tipo de Afectación */
    ASSIGN {&Detalle}.cTipoAfectacion = "GRAVADA".
    IF x-es-transferencia-gratuita  = YES THEN DO:
        ASSIGN {&Detalle}.cTipoAfectacion = "GRATUITA".
    END.
    ELSE DO:
        IF {&Detalle}.aftigv = NO THEN ASSIGN {&Detalle}.cTipoAfectacion = "EXONERADA".        
        IF LOOKUP({&Detalle}.coddoc,"N/C,N/D") = 0 THEN DO:
            IF {&Detalle}.preuni <= 0.06 THEN ASSIGN {&Detalle}.cTipoAfectacion = "GRATUITA".
        END.
    END.
    x-filer1 = {&Detalle}.ImpLin.
    /* Precio Unitario SIN impuestos */
    IF {&Detalle}.cTipoAfectacion = "EXONERADA" THEN DO:
        ASSIGN {&Detalle}.cPreUniSinImpuesto = {&Detalle}.preuni.
    END.
    ELSE DO:
        ASSIGN {&Detalle}.cPreUniSinImpuesto = ROUND({&Detalle}.preuni / (1 + x-TasaIGV), 4). 
    END.
    /* Factor del Descuento: en decimales */
    x-factor-descuento = 0.
    IF LOOKUP({&Detalle}.coddoc,"N/C,N/D") = 0 THEN DO:
        x-dcto_otros_factor  = 0.
        x-dcto_encarte = 0.     /* NO se está dando junto con por:dsctos[x] */
                                /* En caso contrario revisar la rutuina */
        &IF INDEX("{&Cabecera}", "Ccbcdocu") > 0 &THEN 
        x-dcto_otros_factor = {&Detalle}.dcto_otros_factor.
        &ENDIF
        IF {&Detalle}.ImpDto2 > 0 AND {&Detalle}.ImpLin <> 0 
            THEN x-dcto_encarte = {&Detalle}.ImpDto2 / {&Detalle}.ImpLin * 100.
        IF {&Detalle}.Por_Dsctos[1]     > 0 
            OR {&Detalle}.Por_Dsctos[2] > 0 
            OR {&Detalle}.Por_Dsctos[3] > 0 /*OR t-{&Detalle}.dcto_otros_factor > 0*/ 
            OR x-dcto_otros_factor  > 0 
            OR x-dcto_encarte > 0 THEN DO:
            x-factor-descuento = ( 1 -  ( 1 - {&Detalle}.Por_Dsctos[1] / 100 ) *
                                   ( 1 - {&Detalle}.Por_Dsctos[2] / 100 ) *
                                   ( 1 - {&Detalle}.Por_Dsctos[3] / 100 ) *  
                                   ( 1 - x-dcto_encarte / 100 ) *
                                   ( 1 - x-dcto_otros_factor / 100 ) ) *  100.                        
            x-factor-descuento = ROUND(x-factor-descuento / 100 , 5).   /* Puede ser hasta 5 decimales */
        END.
    END.
    IF x-factor-descuento >= 1 THEN DO:
        ASSIGN {&Detalle}.cTipoAfectacion = "GRATUITA".
    END.
    ASSIGN {&Detalle}.FactorDescuento = x-factor-descuento.
    /* Tasa de IGV */
    IF LOOKUP({&Detalle}.cTipoAfectacion,"EXONERADA,INAFECTA") = 0 THEN DO:
        ASSIGN {&Detalle}.TasaIGV = x-tasaIGV.
    END.
    /* Importes Unitarios */
    IF {&Detalle}.cTipoAfectacion <> "GRATUITA" THEN DO:
        ASSIGN {&Detalle}.ImporteUnitarioSinImpuesto = {&Detalle}.cPreUniSinImpuesto.
    END.
    IF LOOKUP({&Detalle}.cTipoAfectacion,"GRATUITA") > 0 THEN DO:
        ASSIGN {&Detalle}.ImporteReferencial = {&Detalle}.cPreUniSinImpuesto.
    END.
    /* Importe Base del Descuento */
    &IF INDEX("{&Cabecera}", "Ccbcdocu") > 0 &THEN 
    x-CanDes = {&Detalle}.candes.
    &ELSE
    x-CanDes = {&Detalle}.canped.
    &ENDIF

    IF {&Detalle}.FactorDescuento > 0 THEN DO:
        ASSIGN 
            {&Detalle}.ImporteBaseDescuento = ROUND({&Detalle}.ImporteUnitarioSinImpuesto * x-CanDes, 2) 
            {&Detalle}.ImporteDescuento = ROUND({&Detalle}.FactorDescuento * {&Detalle}.ImporteBaseDescuento, 2).
    END.
    /* Importe total SIN impuestos */
    IF {&Detalle}.cTipoAfectacion = "GRATUITA" THEN DO:
/*         ASSIGN                                                                                         */
/*             {&Detalle}.ImporteTotalSinImpuesto = ROUND({&Detalle}.ImporteReferencial * {&Detalle}.candes, 2) */
/*             {&Detalle}.MontoBaseIGV = ROUND({&Detalle}.ImporteReferencial * {&Detalle}.candes, 2).           */
        ASSIGN
            {&Detalle}.ImporteTotalSinImpuesto = {&Detalle}.ImpLin - {&Detalle}.ImpIgv
            {&Detalle}.MontoBaseIGV = {&Detalle}.ImpLin - {&Detalle}.ImpIgv.
    END.
    ELSE DO:
/*         ASSIGN                                                                                                                               */
/*             {&Detalle}.ImporteTotalSinImpuesto = ROUND(({&Detalle}.ImporteUnitarioSinImpuesto * {&Detalle}.candes) - {&Detalle}.ImporteDescuento, 2) */
/*             {&Detalle}.MontoBaseIGV = ROUND(({&Detalle}.ImporteUnitarioSinImpuesto * {&Detalle}.candes) - {&Detalle}.ImporteDescuento, 2).           */
        ASSIGN
            {&Detalle}.ImporteTotalSinImpuesto = ROUND(({&Detalle}.ImpLin - {&Detalle}.ImpIgv) - {&Detalle}.ImpDto, 2)
            {&Detalle}.MontoBaseIGV = ROUND(({&Detalle}.ImpLin - {&Detalle}.ImpIgv) - {&Detalle}.ImpDto, 2).
    END.
    /* Importes IMPUESTOS con y sin impuestos */
/*     ASSIGN                                                                                                           */
/*         {&Detalle}.ImporteIGV = ROUND({&Detalle}.MontoBaseIGV * {&Detalle}.TasaIGV, 2)                                     */
/*         {&Detalle}.ImporteTotalImpuestos = IF ({&Detalle}.cTipoAfectacion = "GRATUITA") THEN 0 ELSE {&Detalle}.ImporteIGV. */
    ASSIGN 
        {&Detalle}.ImporteIGV = ROUND({&Detalle}.ImpIgv, 2)
        {&Detalle}.ImporteTotalImpuestos = IF ({&Detalle}.cTipoAfectacion = "GRATUITA") THEN 0 ELSE {&Detalle}.ImporteIGV.

    IF {&Detalle}.cTipoAfectacion <> "GRATUITA" THEN DO:
        /*{&Detalle}.ImporteUnitarioConImpuesto = ROUND(({&Detalle}.ImporteTotalSinImpuesto + {&Detalle}.ImporteTotalImpuesto) / {&Detalle}.candes, 4).*/
        {&Detalle}.ImporteUnitarioConImpuesto = ROUND({&Detalle}.PreUni, 4). /*4*/
    END.
    IF {&Detalle}.cTipoAfectacion = "EXONERADA" THEN DO:
        /*ASSIGN {&Detalle}.cImporteVentaExonerado = ROUND(({&Detalle}.ImporteUnitarioSinImpuesto * {&Detalle}.candes) - {&Detalle}.ImporteDescuento, 4).*/
        ASSIGN {&Detalle}.cImporteVentaExonerado = ROUND(({&Detalle}.ImpLin - {&Detalle}.ImpIgv) - {&Detalle}.ImpDto, 4).
    END.
    IF {&Detalle}.cTipoAfectacion = "GRATUITA" THEN DO:
        ASSIGN {&Detalle}.cImporteVentaGratuito = ROUND({&Detalle}.ImporteReferencial * x-CanDes, 4).
    END.
    IF LOOKUP({&Detalle}.cTipoAfectacion,"EXONERADA,GRATUITA") = 0 THEN DO:
/*         ASSIGN                                                                     */
/*             {&Detalle}.cSumaImpteTotalSinImpuesto = {&Detalle}.ImporteTotalSinImpuesto */
/*             {&Detalle}.cMontoBaseIGV = {&Detalle}.MontoBaseIGV.                        */
        ASSIGN  
            {&Detalle}.cSumaImpteTotalSinImpuesto = ROUND({&Detalle}.ImpLin - {&Detalle}.ImpIgv, 2)
            {&Detalle}.cMontoBaseIGV = {&Detalle}.MontoBaseIGV.
    END.
    IF {&Detalle}.cTipoAfectacion <> "GRATUITA" THEN DO:
        ASSIGN {&Detalle}.cSumaIGV = {&Detalle}.ImporteIGV.
    END.
    IF {&Detalle}.cTipoAfectacion = "GRATUITA" THEN DO:
        {&Detalle}.cOtrosTributosOpGratuito = {&Detalle}.ImporteIGV.
    END.
    /* Importe Total Con Impuestos */
    IF {&Detalle}.cTipoAfectacion <> "GRATUITA" THEN DO:
        /*ASSIGN {&Detalle}.cImporteTotalConImpuesto = {&Detalle}.MontoBaseIGV + {&Detalle}.ImporteIGV.*/
        ASSIGN {&Detalle}.cImporteTotalConImpuesto = {&Detalle}.ImpLin.
    END.
    x-filer2 = x-CanDes.
    /* Bolsa Plastica */
    IF AVAILABLE almmmatg AND almmmatg.codfam = x-linea-bolsas-plastica THEN DO:
        RUN impuesto-bolsa-plastica (INPUT x-CanDes).
        ASSIGN 
            {&Detalle}.ImporteTotalImpuesto = {&Detalle}.ImporteTotalImpuesto + {&Detalle}.montoTributoBolsaPlastico.
        x-existe-icbper = YES.        
    END.        


    /* ************************************************************************************************************ */
    /* SUB-TOTALES */
    /* ************************************************************************************************************ */
    IF {&Detalle}.cTipoAfectacion = "EXONERADA" THEN DO:        
        /*x-exonerado = x-exonerado + {&Detalle}.cImporteVentaExonerado.*/
        x-exonerado = x-exonerado + ({&Detalle}.ImpLin - {&Detalle}.ImpIgv).
    END.
    IF {&Detalle}.cTipoAfectacion = "GRATUITA" THEN DO:
        /*x-gratuito = x-gratuito + {&Detalle}.cImporteVentaGratuito.*/
        x-gratuito = x-gratuito + {&Detalle}.ImpLin.
    END.
    IF LOOKUP({&Detalle}.cTipoAfectacion,"EXONERADA,GRATUITA") = 0 THEN DO:
        /*x-sumaImporteTotalSinImpuesto = x-sumaImporteTotalSinImpuesto + {&Detalle}.cSumaImpteTotalSinImpuesto.*/
        x-sumaImporteTotalSinImpuesto = x-sumaImporteTotalSinImpuesto + ({&Detalle}.ImpLin - {&Detalle}.ImpIgv).
        x-montoBaseIgv = x-montoBaseIgv + {&Detalle}.cMontoBaseIGV.     /* U */
    END.
    IF {&Detalle}.cTipoAfectacion <> "GRATUITA" THEN DO:
        /*x-sumaIGV = x-sumaIGV + {&Detalle}.cSumaIGV.*/
        x-sumaIGV = x-sumaIGV + {&Detalle}.ImpIgv.
    END.
    IF {&Detalle}.cTipoAfectacion = "GRATUITA" THEN DO:
        /*x-OtrosTributosOpGratuitas = x-OtrosTributosOpGratuitas + {&Detalle}.cOtrosTributosOpGratuito.*/
        x-OtrosTributosOpGratuitas = x-OtrosTributosOpGratuitas + {&Detalle}.ImpIgv.
    END.
END.

/* ************************************************************************************************************ */
/* TOTALES */
/* ************************************************************************************************************ */
ASSIGN 
    {&Cabecera}.totalValorVentaNetoOpGravadas     = x-sumaImporteTotalSinImpuesto
    {&Cabecera}.totalValorVentaNetoOpGratuitas    = x-gratuito
    {&Cabecera}.totalTributosOpeGratuitas         = x-OtrosTributosOpGratuitas
    {&Cabecera}.totalValorVentaNetoOpExoneradas   = x-exonerado
    {&Cabecera}.totalIgv                          = x-sumaIGV
    {&Cabecera}.totalImpuestos                    = {&Cabecera}.totalIgv
    {&Cabecera}.totalValorVenta                   = x-sumaImporteTotalSinImpuesto
    {&Cabecera}.totalPrecioVenta                  = {&Cabecera}.totalValorVentaNetoOpGravadas + x-sumaIGV.
/* ICBPER */
ASSIGN 
    {&Cabecera}.totalPrecioVenta = {&Cabecera}.totalPrecioVenta + x-TotalImpuestoBolsaPlastica
    {&Cabecera}.montoBaseICBPER = x-precio-ICBPER 
    {&Cabecera}.totalMontoICBPER = x-TotalImpuestoBolsaPlastica. 
/* EXONERADAS */
IF {&Cabecera}.totalValorVentaNetoOpExoneradas > 0 THEN DO:
    ASSIGN 
        {&Cabecera}.totalPrecioVenta = {&Cabecera}.totalPrecioVenta + {&Cabecera}.totalValorVentaNetoOpExoneradas
        {&Cabecera}.totalValorVenta = {&Cabecera}.totalValorVenta + {&Cabecera}.totalValorVentaNetoOpExoneradas.
END.
x-TotalImpuestos = {&Cabecera}.totalIGV.   /* Jul2024 : x-OtrosTributosOpGratuitas. */
ASSIGN 
    {&Cabecera}.totalVenta = {&Cabecera}.totalPrecioVenta.
ASSIGN 
    {&Cabecera}.totalImpuestos = x-TotalImpuestos.   
/* + ICBPER */
ASSIGN 
    {&Cabecera}.totalImpuestos = {&Cabecera}.totalImpuestos + x-TotalImpuestoBolsaPlastica.   

/* ************************************************************************************************************ */
/* TOTALES AJUSTADOS */
/* ************************************************************************************************************ */
/* ASSIGN                                                             */
/*     {&Cabecera}.totalValorVentaNetoOpGravadas     = {&Cabecera}.ImpVta */
/*     {&Cabecera}.totalIgv                          = {&Cabecera}.ImpIgv */
/*     {&Cabecera}.totalImpuestos                    = {&Cabecera}.ImpIgv */
/*     {&Cabecera}.totalValorVenta                   = {&Cabecera}.ImpVta */
/*     {&Cabecera}.totalPrecioVenta                  = {&Cabecera}.ImpTot */
/*     .                                                              */

/* ************************************************************************* */
/* AJUSTE DE IMPORTES FINALES EN CASO DE B2C / RIQRA */
/* ************************************************************************* */
/* DEF VAR Local_Delta AS DECI NO-UNDO.                                                             */
/* DEF VAR Local_TipoAfectacion AS CHAR NO-UNDO.                                                    */
/* DEF VAR importeDescuentoGlobal AS DEC.                                                           */
/*                                                                                                  */
/* importeDescuentoGlobal = {&Cabecera}.impint.                                                       */
/* Local_Delta = {&Cabecera}.ImpTot - importeDescuentoGlobal - {&Cabecera}.TotalVenta.                  */
/* {sunat/sunat-calculo-importes-ajustados.i &CabeceraAjuste="{&Cabecera}" &DetalleAjuste="{&Detalle}"} */

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
         HEIGHT             = 7.19
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


