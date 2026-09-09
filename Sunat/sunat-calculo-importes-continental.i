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

/**/
DEFINE BUFFER b-sunat_anticipos FOR sunat_anticipos.
DEFINE TEMP-TABLE t-sunat_anticipos LIKE sunat_anticipos.

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
         HEIGHT             = 8.42
         WIDTH              = 66.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculo-de-importes Include 
PROCEDURE calculo-de-importes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER z-retval AS CHAR NO-UNDO.

EMPTY TEMP-TABLE {&CabeceraTempo}.
EMPTY TEMP-TABLE {&DetalleTempo}.
 
DEFINE VAR x-factor-descuento AS DEC.
DEFINE VAR x-factor-descuento-base AS DEC.
DEFINE VAR x-exonerado AS DEC.
DEFINE VAR x-gratuito AS DEC.
DEFINE VAR x-sumaImporteTotalSinImpuesto AS DEC.
DEFINE VAR x-montoBaseIgv AS DEC.
DEFINE VAR x-sumaIGV AS DEC.
DEFINE VAR x-OtrosTributosOpGratuitas AS DEC. 

DEFINE VAR x-dcto_otros_factor  AS DEC INIT 0.
DEFINE VAR x-dcto_encarte AS DEC INIT 0.

DEFINE VAR x-fecha-emision-doc AS DATE.
DEFINE VAR x-items AS INT INIT 0.

DEFINE VAR x-filer1 AS DEC INIT 0.0000.
DEFINE VAR x-filer2 AS DEC INIT 0.0000.

x-tasaigv = 0.
RUN get-tasa-impuesto(INPUT "IGV", INPUT-OUTPUT x-tasaigv) .

IF x-tasaigv = 0 THEN DO:
    z-retval = "La tasa del impuesto(IGV) no puede ser CERO(0)" .
    RETURN "ADM-ERROR".
END.

/* Cabecera */
CREATE {&CabeceraTempo}.     
BUFFER-COPY {&CabeceraX} TO {&CabeceraTempo}.   

RUN reset-importes-sunat-cabecera.

/* Transferencia gratuita */
x-es-transferencia-gratuita = NO.
IF LOOKUP({&CabeceraX}.fmapgo,"899,900") > 0  THEN DO:
    x-es-transferencia-gratuita  = YES.
END.

z-retval = "PROCESANDO".

x-existe-icbper = NO.
x-TotalImpuestoBolsaPlastica = 0.

x-items = 0.
FOR EACH {&DetalleX} OF {&CabeceraX} NO-LOCK:
    FIND FIRST almmmatg OF {&DetalleX} NO-LOCK NO-ERROR.    
    x-items = x-items + 1.
    IF x-items > 1 THEN LEAVE.
END.

FOR EACH {&DetalleX} OF {&CabeceraX} NO-LOCK WHERE :
    FIND FIRST almmmatg OF {&DetalleX} NO-LOCK NO-ERROR.
    IF {&DetalleX}.codmat = x-articulo-ICBPER THEN DO:
        /* Ya no considerar el item ICBPER como articulo */
        NEXT.
    END.
    /* Detalle */
    CREATE {&DetalleTempo}. 
    BUFFER-COPY {&DetalleX} TO {&DetalleTempo}. 
    RUN reset-importes-sunat-detalle.
    /* *********************************************************************************************** */
    /*  1ro. Definimos el tipo de afectación */
    /* *********************************************************************************************** */
    ASSIGN {&DetalleTempo}.cTipoAfectacion = "GRAVADA".
    IF x-es-transferencia-gratuita  = YES THEN ASSIGN {&DetalleTempo}.cTipoAfectacion = "GRATUITA".
    ELSE DO:
        IF {&DetalleTempo}.aftigv = NO THEN ASSIGN {&DetalleTempo}.cTipoAfectacion = "EXONERADA".        
        IF LOOKUP({&DetalleTempo}.coddoc,"N/C,N/D") = 0 THEN DO:
            IF {&DetalleTempo}.preuni <= 0.06 THEN ASSIGN {&DetalleTempo}.cTipoAfectacion = "GRATUITA".
        END.
    END.
    x-filer1 = {&DetalleTempo}.ImpLin.
    /* *********************************************************************************************** */
    /*  2do. Definimos el tipo de afectación */
    /* *********************************************************************************************** */
    /* *********************************************************************************************** */
    /* 3ro. Factor del Descuento: en decimales */
    /* *********************************************************************************************** */
    x-factor-descuento-base = 0.
    x-factor-descuento = 0.
    IF LOOKUP({&DetalleTempo}.coddoc,"N/C,N/D") = 0 THEN DO:
        x-dcto_otros_factor  = 0.
        x-dcto_encarte = 0.     /* NO se está dando junto con por:dsctos[x] */
                                /* En caso contrario revisar la rutuina */
        &IF INDEX("{&CabeceraTempo}", "Ccbcdocu") > 0 &THEN 
            x-dcto_otros_factor = {&DetalleTempo}.dcto_otros_factor.
        &ENDIF
        IF {&DetalleTempo}.ImpDto2 > 0 THEN x-dcto_encarte = {&DetalleTempo}.ImpDto2 / {&DetalleTempo}.ImpLin * 100.
        IF {&DetalleTempo}.Por_Dsctos[1]     > 0 
            OR {&DetalleTempo}.Por_Dsctos[2] > 0 
            OR {&DetalleTempo}.Por_Dsctos[3] > 0 
            OR x-dcto_otros_factor  > 0 
            OR x-dcto_encarte > 0 THEN DO:
            x-factor-descuento-base = ( 1 -  ( 1 - {&DetalleTempo}.Por_Dsctos[1] / 100 ) *
                                        ( 1 - {&DetalleTempo}.Por_Dsctos[2] / 100 ) *
                                        ( 1 - {&DetalleTempo}.Por_Dsctos[3] / 100 ) *  
                                        ( 1 - x-dcto_encarte / 100 ) *
                                        ( 1 - x-dcto_otros_factor / 100 ) ) *  100.                        
            x-factor-descuento = ROUND(x-factor-descuento-base / 100 , 5).   /* Puede ser hasta 5 decimales */
        END.
    END.
    IF x-factor-descuento >= 1 THEN ASSIGN {&DetalleTempo}.cTipoAfectacion = "GRATUITA".
    /* *********************************************************************************************** */
    /*  4to. El cálculo es en base al tipo de afectación */
    /* *********************************************************************************************** */
    CASE {&DetalleTempo}.cTipoAfectacion:
        WHEN "GRAVADA" THEN DO:
            {&DetalleTempo}.TasaIGV = x-tasaIGV.
            {&DetalleTempo}.FactorDescuento = x-factor-descuento.
            {&DetalleTempo}.cImporteTotalConImpuesto = {&DetalleX}.ImpLin.
            {&DetalleTempo}.MontoBaseIGV = ROUND({&DetalleTempo}.cImporteTotalConImpuesto / (1 + {&DetalleTempo}.TasaIGV), 2).
            {&DetalleTempo}.ImporteIGV = {&DetalleTempo}.cImporteTotalConImpuesto - {&DetalleTempo}.MontoBaseIGV.
            {&DetalleTempo}.cSumaIGV = {&DetalleTempo}.ImporteIGV.
            {&DetalleTempo}.cMontoBaseIGV = {&DetalleTempo}.MontoBaseIGV.
            {&DetalleTempo}.ImporteTotalSinImpuesto = {&DetalleTempo}.MontoBaseIGV.
            {&DetalleTempo}.cSumaImpteTotalSinImpuesto = {&DetalleTempo}.ImporteTotalSinImpuesto.
            {&DetalleTempo}.ImporteTotalImpuesto = {&DetalleTempo}.ImporteIGV + {&DetalleTempo}.MontoTributoBolsaPlastico.
            {&DetalleTempo}.ImporteUnitarioConImpuesto = ROUND ( ({&DetalleTempo}.ImporteTotalSinImpuesto + {&DetalleTempo}.ImporteTotalImpuesto) / {&DetalleTempo}.{&cantidad}, 4).
            {&DetalleTempo}.ImporteUnitarioSinImpuesto = ROUND( {&DetalleTempo}.MontoBaseIGV / ((1 - {&DetalleTempo}.FactorDescuento) * {&DetalleX}.{&cantidad}), 4).
            {&DetalleTempo}.ImporteBaseDescuento = (IF {&DetalleTempo}.FactorDescuento > 0 THEN ROUND({&DetalleTempo}.ImporteUnitarioSinImpuesto * {&DetalleX}.{&cantidad}, 2) ELSE 0).
            {&DetalleTempo}.ImporteDescuento = ROUND({&DetalleTempo}.FactorDescuento * {&DetalleTempo}.ImporteBaseDescuento,2).
            {&DetalleTempo}.cPreUniSinImpuesto = {&DetalleTempo}.ImporteUnitarioSinImpuesto.
            x-sumaImporteTotalSinImpuesto = x-sumaImporteTotalSinImpuesto + {&DetalleTempo}.cSumaImpteTotalSinImpuesto.  /* T */        
            x-montoBaseIgv = x-montoBaseIgv + {&DetalleTempo}.cMontoBaseIGV.     /* U */
            x-sumaIGV = x-sumaIGV + {&DetalleTempo}.cSumaIGV.                /* V */
        END.
        WHEN "EXONERADA" THEN DO:
            {&DetalleTempo}.FactorDescuento = x-factor-descuento.
            {&DetalleTempo}.cImporteTotalConImpuesto = {&DetalleX}.ImpLin.
            {&DetalleTempo}.MontoBaseIGV = ROUND({&DetalleTempo}.cImporteTotalConImpuesto / (1 + {&DetalleTempo}.TasaIGV), 2).
            {&DetalleTempo}.ImporteUnitarioSinImpuesto = ROUND({&DetalleTempo}.MontoBaseIGV / ((1 - {&DetalleTempo}.FactorDescuento) * {&DetalleX}.{&cantidad}),4).
            {&DetalleTempo}.ImporteBaseDescuento = (IF {&DetalleTempo}.FactorDescuento > 0 THEN ROUND({&DetalleTempo}.ImporteUnitarioSinImpuesto * {&DetalleX}.{&cantidad}, 2) ELSE 0).
            {&DetalleTempo}.ImporteDescuento = ROUND({&DetalleTempo}.FactorDescuento * {&DetalleTempo}.ImporteBaseDescuento,2).
            {&DetalleTempo}.cImporteVentaExonerado = ROUND({&DetalleTempo}.ImporteUnitarioSinImpuesto * {&DetalleX}.{&cantidad}, 4) - {&DetalleTempo}.ImporteDescuento.
            {&DetalleTempo}.ImporteIGV = {&DetalleTempo}.cImporteTotalConImpuesto - {&DetalleTempo}.MontoBaseIGV.
            {&DetalleTempo}.ImporteTotalSinImpuesto = {&DetalleTempo}.MontoBaseIGV.
            {&DetalleTempo}.ImporteTotalImpuesto = {&DetalleTempo}.ImporteIGV + {&DetalleTempo}.MontoTributoBolsaPlastico.
            {&DetalleTempo}.ImporteUnitarioConImpuesto = ROUND ( ({&DetalleTempo}.ImporteTotalSinImpuesto + {&DetalleTempo}.ImporteTotalImpuesto) / {&DetalleTempo}.{&cantidad}, 4).
            {&DetalleTempo}.cPreUniSinImpuesto = {&DetalleTempo}.ImporteUnitarioSinImpuesto.
            {&DetalleTempo}.cSumaIGV = {&DetalleTempo}.ImporteIGV.
            x-exonerado = x-exonerado + {&DetalleTempo}.cImporteVentaExonerado.
            x-sumaIGV = x-sumaIGV + {&DetalleTempo}.cSumaIGV.                /* V */
        END.
    END CASE.
    /* Bolsa Plastica */
    IF AVAILABLE almmmatg AND almmmatg.codfam = x-linea-bolsas-plastica THEN DO:
        RUN impuesto-bolsa-plastica (INPUT {&DetalleTempo}.{&cantidad}).
        ASSIGN {&DetalleTempo}.ImporteTotalImpuesto = {&DetalleTempo}.ImporteTotalImpuesto + {&DetalleTempo}.montoTributoBolsaPlastico.
        x-existe-icbper = YES.
    END.        
END.


/* *********************************************************************************************** */
/* Totales */
/* *********************************************************************************************** */
ASSIGN 
    {&CabeceraTempo}.totalValorVentaNetoOpGravadas = x-sumaImporteTotalSinImpuesto
    {&CabeceraTempo}.totalValorVentaNetoOpGratuitas = x-gratuito
    {&CabeceraTempo}.totalTributosOpeGratuitas = x-OtrosTributosOpGratuitas
    {&CabeceraTempo}.totalValorVentaNetoOpExoneradas = x-exonerado
    {&CabeceraTempo}.totalIgv = x-sumaIGV
    {&CabeceraTempo}.totalImpuestos = {&CabeceraTempo}.totalIgv
    {&CabeceraTempo}.totalValorVenta = x-sumaImporteTotalSinImpuesto
    {&CabeceraTempo}.totalPrecioVenta = {&CabeceraTempo}.totalValorVentaNetoOpGravadas + x-sumaIGV.

/* ICBPER */
ASSIGN {&CabeceraTempo}.totalPrecioVenta = {&CabeceraTempo}.totalPrecioVenta + x-TotalImpuestoBolsaPlastica
        {&CabeceraTempo}.montoBaseICBPER = x-precio-ICBPER
        {&CabeceraTempo}.totalMontoICBPER = x-TotalImpuestoBolsaPlastica 
        .

/* EXONERADAS */
IF {&CabeceraTempo}.totalValorVentaNetoOpExoneradas > 0 THEN DO:
    ASSIGN {&CabeceraTempo}.totalPrecioVenta = {&CabeceraTempo}.totalPrecioVenta + {&CabeceraTempo}.totalValorVentaNetoOpExoneradas
            {&CabeceraTempo}.totalValorVenta = {&CabeceraTempo}.totalValorVenta + {&CabeceraTempo}.totalValorVentaNetoOpExoneradas.
END.

ASSIGN {&CabeceraTempo}.totalVenta = {&CabeceraTempo}.totalPrecioVenta.
ASSIGN 
    {&CabeceraTempo}.totalImpuestos = {&CabeceraTempo}.totalIGV.

/* + ICBPER */
ASSIGN 
    {&CabeceraTempo}.totalImpuestos = {&CabeceraTempo}.totalImpuestos + x-TotalImpuestoBolsaPlastica.   


/* ANTICIPOS */
&IF INDEX("{&CabeceraTempo}", "Ccbcdocu") > 0  &THEN
    DEFINE VAR z-vvta-anticipos AS DEC INIT 0.
    DEFINE VAR z-tot-anticipos AS DEC INIT 0.
    DEFINE VAR z-igv-anticipos AS DEC INIT 0.

    DEFINE VAR x-monto-base-dscto-global-anticipo AS DEC.
    DEFINE VAR x-total-dscto-globales-anticipo AS DEC.
    DEFINE VAR x-porcentaje-dscto-global-anticipo AS DEC.
    DEFINE VAR x-total-anticipos AS DEC INIT 0.

    IF {&CabeceraTempo}.coddoc = 'FAC' OR {&CabeceraTempo}.coddoc = 'BOL' THEN DO:
        RUN generar-anticipos(INPUT {&CabeceraTempo}.coddoc,
                                      INPUT {&CabeceraTempo}.nrodoc,
                                      INPUT {&CabeceraTempo}.codmon,
                                      INPUT {&CabeceraTempo}.tpocmb,
                                      OUTPUT z-tot-anticipos,
                                      OUTPUT z-vvta-anticipos,
                                      OUTPUT z-igv-anticipos).
    END.    

    IF z-tot-anticipos > 0 THEN DO:
        IF z-tot-anticipos >= {&CabeceraTempo}.totalVenta THEN DO:
            x-total-anticipos = z-tot-anticipos.
            x-monto-base-dscto-global-anticipo = z-vvta-anticipos.
            x-total-dscto-globales-anticipo = z-vvta-anticipos.

            IF z-tot-anticipos > {&CabeceraTempo}.totalVenta THEN DO:
                x-total-anticipos = {&CabeceraTempo}.totalVenta.
                x-monto-base-dscto-global-anticipo = {&CabeceraTempo}.totalValorVentaNetoOpGravadas.
                x-total-dscto-globales-anticipo = {&CabeceraTempo}.totalValorVentaNetoOpGravadas.
            END.
                            
            x-porcentaje-dscto-global-anticipo = 1.            

            ASSIGN 
                {&CabeceraTempo}.totalIGV = 0
                {&CabeceraTempo}.totalImpuestos = {&CabeceraTempo}.totalIGV
                /*{&CabeceraTempo}.totalPrecioVenta = 0                           /* Para verificar enviando al testing si de verdad es CERO */*/
                {&CabeceraTempo}.totalVenta = 0
                {&CabeceraTempo}.totalValorVentaNetoOpGravadas = 0.             /* Que sucede si hay Exoneradas y Gratuitas ??? */
        END.
        ELSE DO:
            z-vvta-anticipos = IF( z-vvta-anticipos >= {&CabeceraTempo}.totalValorVentaNetoOpGravadas) THEN {&CabeceraTempo}.totalValorVentaNetoOpGravadas ELSE z-vvta-anticipos.

             x-monto-base-dscto-global-anticipo = {&CabeceraTempo}.totalValorVentaNetoOpGravadas.
             x-total-dscto-globales-anticipo = z-vvta-anticipos.

             ASSIGN {&CabeceraTempo}.totalValorVentaNetoOpGravadas = {&CabeceraTempo}.totalValorVentaNetoOpGravadas - z-vvta-anticipos
                {&CabeceraTempo}.totalIGV = {&CabeceraTempo}.totalIGV - z-igv-anticipos.

             x-total-anticipos = z-tot-anticipos.
             ASSIGN /*{&CabeceraTempo}.totalPrecioVenta = {&CabeceraTempo}.totalPrecioVenta - z-tot-anticipos*/
                    {&CabeceraTempo}.totalVenta = {&CabeceraTempo}.totalVenta  - z-tot-anticipos .
             
             IF {&CabeceraTempo}.totalVenta < 0 THEN ASSIGN {&CabeceraTempo}.totalVenta = 0.
             /*ASSIGN {&CabeceraTempo}.totalVenta = {&CabeceraTempo}.totalPrecioVenta.*/
             

             IF {&CabeceraTempo}.totalIGV < 0 OR {&CabeceraTempo}.totalVenta = 0 THEN ASSIGN {&CabeceraTempo}.totalIGV = 0.
             ASSIGN {&CabeceraTempo}.totalImpuestos = {&CabeceraTempo}.totalIGV.

             x-porcentaje-dscto-global-anticipo = ROUND(x-total-dscto-globales-anticipo / x-monto-base-dscto-global-anticipo,4).    
        END.

        ASSIGN {&CabeceraTempo}.totalDocumentoAnticipo = x-total-anticipos
                {&CabeceraTempo}.montoBaseDsctoGlobalAnticipo = x-monto-base-dscto-global-anticipo
                {&CabeceraTempo}.porcentajeDsctoGlobalAnticipo = x-porcentaje-dscto-global-anticipo
                {&CabeceraTempo}.totalDsctoGlobalesAnticipo = x-total-dscto-globales-anticipo.
    END.

&ENDIF        

ASSIGN
    z-retval = "OK".

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-anticipos Include 
PROCEDURE generar-anticipos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE INPUT PARAMETER pCodMonDocDespacho AS INT.
DEFINE INPUT PARAMETER pTpoCmbDocDespacho AS DEC.
DEFINE OUTPUT PARAMETER pRetImpTot AS DEC.
DEFINE OUTPUT PARAMETER pRetImpVVTA AS DEC.
DEFINE OUTPUT PARAMETER pRetImpIGV AS DEC.

/* La factura del A/C */
DEFINE VAR x-monto-del-anticipo AS DEC.
DEFINE VAR x-vvta-del-anticipo AS DEC.
DEFINE VAR x-igv-del-anticipo AS DEC.

DEFINE VAR x-suma-de-anticipos AS DEC.
DEFINE VAR x-suma-vvta-de-anticipos AS DEC.
DEFINE VAR x-suma-igv-de-anticipos AS DEC.

DEFINE VAR x-anticipo AS CHAR.

pRetImpTot = 0.
pRetImpVVTA = 0.
pRetImpIGV = 0.

x-anticipo = "".

EMPTY TEMP-TABLE t-sunat_anticipos.

IF (pCoddoc = 'FAC' OR pCoddoc = 'BOL') THEN DO:

    DEFINE VAR x-retval AS CHAR.
    DEFINE VAR x-sec AS INT.
    DEFINE VAR x-hProc AS HANDLE NO-UNDO.

    RUN gn/master-library.r PERSISTENT SET x-hProc.

    RUN anticipos-aplicados-despacho IN x-hProc (INPUT pCoddoc,
                                                 INPUT pNrodoc,
                                                 OUTPUT x-retval).    

    DELETE PROCEDURE x-hProc.

    REPEAT x-sec = 1 TO NUM-ENTRIES(x-retval,"*"):

        x-anticipo = ENTRY(x-sec,x-retval,"*").

        x-monto-del-anticipo = DECIMAL(TRIM(ENTRY(7,x-anticipo,"|"))).
        x-vvta-del-anticipo = DECIMAL(TRIM(ENTRY(9,x-anticipo,"|"))).
        x-igv-del-anticipo = DECIMAL(TRIM(ENTRY(10,x-anticipo,"|"))).

        x-suma-de-anticipos = x-suma-de-anticipos + x-monto-del-anticipo.
        x-suma-vvta-de-anticipos = x-suma-vvta-de-anticipos + x-vvta-del-anticipo.
        x-suma-igv-de-anticipos = x-suma-igv-de-anticipos + x-igv-del-anticipo.

        CREATE t-sunat_anticipos.
            ASSIGN  t-sunat_anticipos.codcia = 1
                    t-sunat_anticipos.coddoc = pCoddoc
                    t-sunat_anticipos.nrodoc = pNrodoc
                    t-sunat_anticipos.indicador = TRIM(ENTRY(1,x-anticipo,"|"))
                    t-sunat_anticipos.numeroOrdenAnticipo = TRIM(ENTRY(2,x-anticipo,"|"))
                    t-sunat_anticipos.tipoDocumentoEmisorAnticipo = TRIM(ENTRY(3,x-anticipo,"|"))
                    t-sunat_anticipos.numeroDocumentoEmisorAnticipo = TRIM(ENTRY(4,x-anticipo,"|"))
                    t-sunat_anticipos.tipoDocumentoAnticipo = TRIM(ENTRY(5,x-anticipo,"|"))
                    t-sunat_anticipos.serieNumeroDocumentoAnticipo = TRIM(ENTRY(6,x-anticipo,"|"))
                    t-sunat_anticipos.totalPrepagadoAnticipo = DECIMAL(TRIM(ENTRY(7,x-anticipo,"|")))
                    t-sunat_anticipos.fechaPago = TRIM(ENTRY(8,x-anticipo,"|")).

    END.

    IF x-suma-de-anticipos <= 0 THEN DO:
        x-suma-de-anticipos = 0.
        x-suma-vvta-de-anticipos = 0.
        x-suma-igv-de-anticipos = 0.
    END.

    pRetImpTot = x-suma-de-anticipos.
    pRetImpVVTA = x-suma-vvta-de-anticipos.
    pRetImpIgv = x-suma-igv-de-anticipos.

END.

END PROCEDURE.

/*
        /*
        IF pRetXML = "" THEN DO :
            pRetXML = "<anticipo>".
        END.
        ELSE DO:
            pRetXML = pRetXML + "<anticipo>".
        END.
        pRetXML = pRetXML + fgenera-tag("indicador",TRIM(ENTRY(1,x-anticipo,"|"))).
        pRetXML = pRetXML + fgenera-tag("numeroOrdenAnticipo",TRIM(ENTRY(2,x-anticipo,"|"))).
        pRetXML = pRetXML + fgenera-tag("tipoDocumentoEmisorAnticipo",TRIM(ENTRY(3,x-anticipo,"|"))).
        pRetXML = pRetXML + fgenera-tag("numeroDocumentoEmisorAnticipo",TRIM(ENTRY(4,x-anticipo,"|"))).
        pRetXML = pRetXML + fgenera-tag("tipoDocumentoAnticipo",TRIM(ENTRY(5,x-anticipo,"|"))).
        pRetXML = pRetXML + fgenera-tag("serieNumeroDocumentoAnticipo",TRIM(ENTRY(6,x-anticipo,"|"))).
        pRetXML = pRetXML + fgenera-tag("totalPrepagadoAnticipo",TRIM(ENTRY(7,x-anticipo,"|"))).
        pRetXML = pRetXML + fgenera-tag("fechaPago",TRIM(ENTRY(8,x-anticipo,"|"))).

        pRetXML = pRetXML + "</anticipo>".
        
        x-es-anticipo-de-campana = YES.
        */
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-tasa-impuesto Include 
PROCEDURE get-tasa-impuesto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodImpuesto AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER pTasa AS DEC NO-UNDO.

pTasa = 0.00.

LOOPTASA:
FOR EACH sunat_fact_Electr_taxs WHERE sunat_fact_Electr_taxs.TaxTypeCode = pCodImpuesto AND 
                     sunat_fact_Electr_tax.DISABLED = NO NO-LOCK:
    IF TODAY >= sunat_fact_Electr_taxs.START_date AND TODAY <= sunat_fact_Electr_taxs.END_date THEN DO:
        pTasa = sunat_fact_Electr_taxs.tax.
        LEAVE LOOPTASA.
    END.
END.

IF pTasa < 0 THEN pTasa = 0.00.
IF pTasa > 0 THEN pTasa = pTasa / 100.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-importes Include 
PROCEDURE grabar-importes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

pRetVal = "OK".

LOOPGRABAR:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE :
    FIND FIRST {&CabeceraTempo} NO-LOCK NO-ERROR.
    /* Detalle  */
    FOR EACH {&DetalleTempo} NO-LOCK:
        FIND FIRST {&DetalleBuffer} WHERE {&DetalleBuffer}.codcia = {&DetalleTempo}.codcia AND
                                    {&DetalleBuffer}.coddoc = {&DetalleTempo}.coddoc AND
                                    {&DetalleBuffer}.{&nrodoc} = {&DetalleTempo}.{&nrodoc} AND
                                    {&DetalleBuffer}.nroitm = {&DetalleTempo}.nroitm EXCLUSIVE-LOCK NO-ERROR.
        IF LOCKED {&DetalleBuffer} THEN DO:
            pRetVal = "Al actualizar los importes de sunat al articulo " + {&DetalleTempo}.codmat + " la tabla FACDPEDI/CCBDDOCU esta bloqueada".
            UNDO LOOPGRABAR, LEAVE LOOPGRABAR.
        END.
        IF AVAILABLE {&DetalleBuffer} THEN DO:
            BUFFER-COPY {&DetalleTempo} TO {&DetalleBuffer}.
        END.
    END.
    /* Cabecera */
    FIND FIRST {&CabeceraBuffer} WHERE {&CabeceraBuffer}.codcia = {&CabeceraTempo}.codcia AND 
                                {&CabeceraBuffer}.coddiv = {&CabeceraTempo}.coddiv AND 
                                {&CabeceraBuffer}.coddoc = {&CabeceraTempo}.coddoc AND
                                {&CabeceraBuffer}.{&nrodoc} = {&CabeceraTempo}.{&nrodoc} EXCLUSIVE-LOCK NO-ERROR.
    IF LOCKED {&CabeceraBuffer} THEN DO:
        pRetVal = "Al actualizar los importes de sunat al " + {&CabeceraTempo}.coddoc + " " + {&CabeceraTempo}.{&nrodoc} + " la tabla FACCPEDI/CCBCDOCU esta bloqueada".
        UNDO LOOPGRABAR, LEAVE LOOPGRABAR.
    END.
    IF AVAILABLE {&CabeceraBuffer} THEN DO:
        BUFFER-COPY {&CabeceraTempo} TO {&CabeceraBuffer}.
    END.

    /* Anticipos */
    /* 1.- Eliminamos si es existen */
    FOR EACH sunat_anticipos WHERE sunat_anticipos.codcia = 1 AND
                                    sunat_anticipos.coddoc = {&CabeceraTempo}.coddoc AND
                                    sunat_anticipos.nrodoc = {&CabeceraTempo}.{&nrodoc} NO-LOCK:

        FIND FIRST b-sunat_anticipos WHERE ROWID(sunat_anticipos) = ROWID(b-sunat_anticipos) EXCLUSIVE-LOCK NO-ERROR.
        IF LOCKED(b-sunat_anticipos) THEN DO:
            pRetVal = "Al eliminar importes ANTICIPOS sunat del " + {&CabeceraTempo}.coddoc + " " + {&CabeceraTempo}.{&nrodoc} + " la tabla SUNAT_ANTICIPOS esta bloqueada".
            UNDO LOOPGRABAR, LEAVE LOOPGRABAR.
        END.
        IF AVAILABLE b-sunat_anticipos THEN DO:
            DELETE b-sunat_anticipos.
        END.
    END.
    /* 2.- Agrego */
    FOR EACH t-sunat_anticipos NO-LOCK:
        CREATE b-sunat_anticipos.
        BUFFER-COPY t-sunat_anticipos TO b-sunat_anticipos.
    END.

END.

RELEASE {&CabeceraBuffer} NO-ERROR.
RELEASE {&DetalleBuffer} NO-ERROR.
RELEASE b-sunat_anticipos NO-ERROR.

IF pRetVal <> "OK" THEN DO:
    RETURN "ADM-ERROR".
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE impuesto-bolsa-plastica Include 
PROCEDURE impuesto-bolsa-plastica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCantidad AS DEC.

DEFINE VAR x-implin AS DEC.

x-precio-ICBPER = 0.0.   
/*
/* Sacar el importe de bolsas plasticas */
DEFINE VAR z-hProc AS HANDLE NO-UNDO.               /* Handle Libreria */

RUN ccb\libreria-ccb.p PERSISTENT SET z-hProc.

/* Procedimientos */
RUN precio-impsto-bolsas-plastica IN z-hProc (INPUT TODAY, OUTPUT x-precio-ICBPER).

DELETE PROCEDURE z-hProc.                   /* Release Libreria */
*/

DEFINE VAR pFecha AS DATE.
DEFINE VAR pPrecioImpsto AS DEC.

DEFINE VAR x-tabla AS CHAR INIT "IMPSTO_BOL_PLASTICA".
DEFINE VAR x-fecha AS DATE.

x-fecha = TODAY.

/* Indica que la configuracion para el precio del impsto a la bolsa NO esta configurado*/
pPrecioImpsto = -9.99.

FIND FIRST factabla WHERE factabla.codcia = s-codcia AND
                            factabla.tabla = x-tabla AND
                            (x-fecha >= factabla.campo-d[1] AND x-fecha <= factabla.campo-d[2])
                             NO-LOCK NO-ERROR.
IF AVAILABLE factabla THEN DO:
    pPrecioImpsto = factabla.valor[1].
END.

x-precio-ICBPER = pPrecioImpsto.

x-implin = pCantidad * x-precio-ICBPER.
x-TotalImpuestoBolsaPlastica = x-TotalImpuestoBolsaPlastica + x-ImpLin.

ASSIGN 
    {&DetalleTempo}.impuestoBolsaPlastico = x-precio-ICBPER   /*x-implin*/
    {&DetalleTempo}.montoTributoBolsaPlastico = x-implin
    {&DetalleTempo}.cantidadBolsaPlastico = pCantidad
    {&DetalleTempo}.montoUnitarioBolsaPlastico = x-precio-ICBPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reset-importes-sunat-cabecera Include 
PROCEDURE reset-importes-sunat-cabecera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN {&CabeceraTempo}.totalValorVentaNetoOpGravadas = 0
            {&CabeceraTempo}.totalValorVentaNetoOpGratuitas = 0
            {&CabeceraTempo}.totalTributosOpeGratuitas = 0
            {&CabeceraTempo}.totalValorVentaNetoOpExoneradas = 0
            {&CabeceraTempo}.totalIGV = 0
            {&CabeceraTempo}.totalImpuestos = 0
            {&CabeceraTempo}.totalValorVenta = 0
            {&CabeceraTempo}.totalPrecioVenta = 0
            {&CabeceraTempo}.descuentosGlobales = 0
            {&CabeceraTempo}.PorcentajeDsctoGlobal = 0
            {&CabeceraTempo}.montoBaseDescuentoGlobal = 0
            {&CabeceraTempo}.totalValorVentaNetoOpNoGravada = 0
            {&CabeceraTempo}.totalDocumentoAnticipo = 0
            {&CabeceraTempo}.montoBaseDsctoGlobalAnticipo = 0
            {&CabeceraTempo}.porcentajeDsctoGlobalAnticipo = 0
            {&CabeceraTempo}.totalDsctoGlobalesAnticipo = 0
            {&CabeceraTempo}.MontoBaseICBPER = 0
            {&CabeceraTempo}.TotalMontoICBPER = 0
            {&CabeceraTempo}.totalVenta = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reset-importes-sunat-detalle Include 
PROCEDURE reset-importes-sunat-detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN {&DetalleTempo}.cTipoAfectacion = ""
        {&DetalleTempo}.cPreUniSinImpuesto = 0
        {&DetalleTempo}.FactorDescuento = 0
        {&DetalleTempo}.TasaIGV = 0
        {&DetalleTempo}.ImporteUnitarioSinImpuesto = 0
        {&DetalleTempo}.ImporteReferencial = 0
        {&DetalleTempo}.ImporteBaseDescuento = 0
        {&DetalleTempo}.ImporteDescuento = 0
        {&DetalleTempo}.ImporteTotalSinImpuesto = 0
        {&DetalleTempo}.MontoBaseIGV = 0
        {&DetalleTempo}.ImporteIGV = 0
        {&DetalleTempo}.ImporteTotalImpuesto = 0
        {&DetalleTempo}.ImporteUnitarioConImpuesto = 0
        {&DetalleTempo}.cImporteVentaExonerado = 0
        {&DetalleTempo}.cImporteVentaGratuito = 0
        {&DetalleTempo}.cSumaImpteTotalSinImpuesto = 0
        {&DetalleTempo}.cMontoBaseIGV = 0
        {&DetalleTempo}.cSumaIGV = 0
        {&DetalleTempo}.cOtrosTributosOpGratuito = 0
        {&DetalleTempo}.impuestoBolsaPlastico = 0
        {&DetalleTempo}.montoTributoBolsaPlastico = 0
        {&DetalleTempo}.cantidadBolsaPlastico = 0
        {&DetalleTempo}.montoUnitarioBolsaPlastico = 0
        {&DetalleTempo}.cimporteTotalConImpuesto = 0.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

