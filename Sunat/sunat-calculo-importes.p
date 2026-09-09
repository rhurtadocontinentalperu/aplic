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


DEFINE SHARED VAR s-codcia AS INTE.


/* Tablas a usar */
DEFINE BUFFER x-faccpedi FOR faccpedi.
DEFINE BUFFER x-facdpedi FOR facdpedi.
DEFINE BUFFER x-ccbcdocu FOR ccbcdocu. 
DEFINE BUFFER x-ccbddocu FOR ccbddocu.

DEFINE BUFFER b-faccpedi FOR faccpedi.
DEFINE BUFFER b-facdpedi FOR facdpedi.
DEFINE BUFFER b-ccbcdocu FOR ccbcdocu. 
DEFINE BUFFER b-ccbddocu FOR ccbddocu.


/* Temporales */
DEFINE TEMP-TABLE t-faccpedi LIKE faccpedi.
DEFINE TEMP-TABLE t-facdpedi LIKE facdpedi.

DEFINE TEMP-TABLE t-ccbcdocu LIKE ccbcdocu.
DEFINE TEMP-TABLE t-ccbddocu LIKE ccbddocu.

/* Impuesto a la bolsas plasticas */
DEFINE VAR x-articulo-ICBPER AS CHAR.
DEFINE VAR x-linea-bolsas-plastica AS CHAR.
DEFINE VAR x-precio-ICBPER AS DEC.
DEFINE VAR x-TotalImpuestoBolsaPlastica AS DECI INIT 0 NO-UNDO.

x-articulo-ICBPER = "099268".
x-linea-bolsas-plastica = "086".

/**/
DEFINE VAR x-es-transferencia-gratuita AS LOG.
DEFINE VAR x-tasaigv AS DEC.
DEFINE VAR x-existe-icbper AS LOG.

/**/
DEFINE VAR x-tabla AS CHAR.

/*def VAR pRetVal AS CHAR.*/

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
         HEIGHT             = 9.92
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-calculo-importes-faccpedi-borrar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculo-importes-faccpedi-borrar Procedure 
PROCEDURE calculo-importes-faccpedi-borrar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.    

EMPTY TEMP-TABLE t-faccpedi.
EMPTY TEMP-TABLE t-facdpedi.

DEFINE VAR x-factor-descuento AS DEC.
DEFINE VAR x-exonerado AS DEC.
DEFINE VAR x-gratuito AS DEC.
DEFINE VAR x-sumaImporteTotalSinImpuesto AS DEC.
DEFINE VAR x-montoBaseIgv AS DEC.
DEFINE VAR x-sumaIGV AS DEC.
DEFINE VAR x-OtrosTributosOpGratuitas AS DEC.

x-tasaigv = 0.
RUN get-tasa-impuesto(INPUT "IGV", INPUT-OUTPUT x-tasaigv) .

IF x-tasaigv = 0 THEN DO:
    pRetVal = "La tasa del impuesto(IGV) no puede ser CERO(0)" .
    RETURN "ADM-ERROR".
END.

/* Cabecera */
CREATE t-faccpedi.
BUFFER-COPY x-faccpedi TO t-faccpedi.

/* Reset */
RUN reset-faccpedi-importes-sunat.

/* Transferencia gratuita */
x-es-transferencia-gratuita = NO.
IF LOOKUP(x-faccpedi.fmapgo,"899,900") > 0  THEN DO:
    x-es-transferencia-gratuita  = YES.
END.

x-existe-icbper = NO.
x-TotalImpuestoBolsaPlastica = 0.

FOR EACH x-facdpedi OF x-faccpedi NO-LOCK:
    FIND FIRST almmmatg OF x-facdpedi NO-LOCK NO-ERROR.

    IF x-facdpedi.codmat = x-articulo-ICBPER THEN DO:
        /* Ya no considerar el item ICBPER como articulo */
        NEXT.
    END.

    /* Detalle */
    CREATE t-facdpedi.
    BUFFER-COPY x-facdpedi TO t-facdpedi.

    /* Reset */
    RUN reset-facdpedi-importes-sunat.

    /* Tipo de Afectación */
    ASSIGN t-facdpedi.cTipoAfectacion = "GRAVADA".
    IF x-es-transferencia-gratuita  = YES THEN DO:
        ASSIGN t-facdpedi.cTipoAfectacion = "GRATUITA".
    END.
    ELSE DO:
        IF t-facdpedi.aftigv = NO THEN ASSIGN t-facdpedi.cTipoAfectacion = "EXONERADA".        
        IF t-facdpedi.preuni <= 0.06 THEN ASSIGN t-facdpedi.cTipoAfectacion = "GRATUITA".
    END.
    /* Precio Unitario SIN impuestos */
    IF t-facdpedi.cTipoAfectacion = "EXONERADA" THEN DO:
        ASSIGN t-facdpedi.cPreUniSinImpuesto = x-facdpedi.preuni.
    END.
    ELSE DO:
        ASSIGN t-facdpedi.cPreUniSinImpuesto = ROUND(x-facdpedi.preuni / (1 + x-TasaIGV),10).
    END.
    /* Factor del Descuento: en decimales */
    x-factor-descuento = 0.
    IF t-facdpedi.Por_Dsctos[1] > 0 
        OR t-facdpedi.Por_Dsctos[2] > 0 
        OR t-facdpedi.Por_Dsctos[3] > 0 /*OR t-facdpedi.dcto_otros_factor > 0*/ 
        OR t-facdpedi.Pordto2 > 0 THEN DO:
        x-factor-descuento = ( 1 -  ( 1 - t-facdpedi.Por_Dsctos[1] / 100 ) *
                               ( 1 - t-facdpedi.Por_Dsctos[2] / 100 ) *
                               ( 1 - t-facdpedi.Por_Dsctos[3] / 100 ) * 
                               ( 1 - t-facdpedi.Pordto2 / 100 ) /* *
                               ( 1 - t-facdpedi.dcto_otros_factor / 100 )*/ ) * 100.                        
        x-factor-descuento = ROUND(x-factor-descuento / 100 , 5).   /* Puede ser hasta 5 decimales */
    END.
    ASSIGN t-facdpedi.FactorDescuento = x-factor-descuento.
    /* Tasa de IGV */
    IF LOOKUP(t-facdpedi.cTipoAfectacion,"EXONERADA,INAFECTA") = 0 THEN DO:
        ASSIGN t-facdpedi.TasaIGV = x-tasaIGV.
    END.
    /* Importes Unitarios */
    IF t-facdpedi.cTipoAfectacion <> "GRATUITA" THEN DO:
        ASSIGN t-facdpedi.ImporteUnitarioSinImpuesto = t-facdpedi.cPreUniSinImpuesto.
    END.
    IF LOOKUP(t-facdpedi.cTipoAfectacion,"GRATUITA") > 0 THEN DO:
        ASSIGN t-facdpedi.ImporteReferencial = t-facdpedi.cPreUniSinImpuesto.
    END.
    /* Importe Base del Descuento */
    IF t-facdpedi.FactorDescuento > 0 THEN DO:
        ASSIGN 
            t-facdpedi.ImporteBaseDescuento = ROUND(t-facdpedi.ImporteUnitarioSinImpuesto * t-facdpedi.canped,2)
            t-facdpedi.ImporteDescuento = ROUND(t-facdpedi.FactorDescuento * t-facdpedi.ImporteBaseDescuento,2).
    END.
    /* Importe total SIN impuestos */
    IF t-facdpedi.cTipoAfectacion = "GRATUITA" THEN DO:
        ASSIGN 
            t-facdpedi.ImporteTotalSinImpuesto = ROUND(t-facdpedi.ImporteReferencial * t-facdpedi.canped,2)
            t-facdpedi.MontoBaseIGV = ROUND(t-facdpedi.ImporteReferencial * t-facdpedi.canped,2).
    END.
    ELSE DO:
        ASSIGN 
            t-facdpedi.ImporteTotalSinImpuesto = ROUND(t-facdpedi.ImporteUnitarioSinImpuesto * t-facdpedi.canped,2) - t-facdpedi.ImporteDescuento
            t-facdpedi.MontoBaseIGV = ROUND(t-facdpedi.ImporteUnitarioSinImpuesto * t-facdpedi.canped,2) - t-facdpedi.ImporteDescuento.
    END.
    /* Importes con y sin impuestos */
    ASSIGN 
        t-facdpedi.ImporteIGV = ROUND(t-facdpedi.MontoBaseIGV * t-facdpedi.TasaIGV,2)
        t-facdpedi.ImporteTotalImpuesto = t-facdpedi.ImporteIGV.

    IF t-facdpedi.cTipoAfectacion <> "GRATUITA" THEN DO:
        t-facdpedi.ImporteUnitarioConImpuesto = ROUND((t-facdpedi.ImporteTotalSinImpuesto + t-facdpedi.ImporteTotalImpuesto) / t-facdpedi.canped,4).
        /*t-facdpedi.ImporteUnitarioConImpuesto = ROUND(t-facdpedi.PreUni,4).     /* Por verificar en el tester */*/
    END.
    IF t-facdpedi.cTipoAfectacion = "EXONERADA" THEN DO:
        ASSIGN t-facdpedi.cImporteVentaExonerado = ROUND(t-facdpedi.ImporteUnitarioSinImpuesto * t-facdpedi.canped,4) - t-facdpedi.ImporteDescuento.
    END.
    IF t-facdpedi.cTipoAfectacion = "GRATUITA" THEN DO:
        ASSIGN t-facdpedi.cImporteVentaGratuito = ROUND(t-facdpedi.ImporteReferencial * t-facdpedi.canped,4).
    END.
    IF LOOKUP(t-facdpedi.cTipoAfectacion,"EXONERADA,GRATUITA") = 0 THEN DO:
        ASSIGN  
            t-facdpedi.cSumaImpteTotalSinImpuesto = t-facdpedi.ImporteTotalSinImpuesto
            t-facdpedi.cMontoBaseIGV = t-facdpedi.MontoBaseIGV.
    END.
    IF t-facdpedi.cTipoAfectacion <> "GRATUITA" THEN DO:
        ASSIGN t-facdpedi.cSumaIGV = t-facdpedi.ImporteIGV.
    END.
    IF t-facdpedi.cTipoAfectacion = "GRATUITA" THEN DO:
        t-facdpedi.cOtrosTributosOpGratuito = t-facdpedi.ImporteIGV.
    END.
    /* Importe Total Con Impuestos */
    ASSIGN
        t-FacDPedi.cImporteTotalConImpuesto = t-facdpedi.cMontoBaseIGV + t-facdpedi.cSumaIGV.

    /* Bolsa Plastica */
     IF AVAILABLE almmmatg AND almmmatg.codfam = x-linea-bolsas-plastica THEN DO:
        
        RUN impuesto-bolsa-plastica(INPUT t-facdpedi.canped).

        ASSIGN t-facdpedi.ImporteTotalImpuesto = t-facdpedi.ImporteTotalImpuesto + t-facdpedi.montoTributoBolsaPlastico.

        x-existe-icbper = YES.
        
    END.        
    /**/
    IF t-facdpedi.cTipoAfectacion = "EXONERADA" THEN DO:        
        x-exonerado = x-exonerado + t-facdpedi.cImporteVentaExonerado.  /* R */
    END.
    IF t-facdpedi.cTipoAfectacion = "GRATUITA" THEN DO:
        x-gratuito = x-gratuito + t-facdpedi.cImporteVentaGratuito.     /* S */
    END.
    IF LOOKUP(t-facdpedi.cTipoAfectacion,"EXONERADA,GRATUITA") = 0 THEN DO:
        x-sumaImporteTotalSinImpuesto = x-sumaImporteTotalSinImpuesto + t-facdpedi.cSumaImpteTotalSinImpuesto.  /* T */        
        x-montoBaseIgv = x-montoBaseIgv + t-facdpedi.cMontoBaseIGV.     /* U */
    END.
    IF t-facdpedi.cTipoAfectacion <> "GRATUITA" THEN DO:
        x-sumaIGV = x-sumaIGV + t-facdpedi.cSumaIGV.                /* V */
    END.
    IF t-facdpedi.cTipoAfectacion = "GRATUITA" THEN DO:
        x-OtrosTributosOpGratuitas = x-OtrosTributosOpGratuitas + t-facdpedi.cOtrosTributosOpGratuito.  /* W */
    END.

END.

/* Totales */
ASSIGN 
    t-faccpedi.totalValorVentaNetoOpGravadas = x-sumaImporteTotalSinImpuesto
    t-faccpedi.totalValorVentaNetoOpGratuitas = x-gratuito
    t-faccpedi.totalTributosOpeGratuitas = x-OtrosTributosOpGratuitas
    t-faccpedi.totalValorVentaNetoOpExoneradas = x-exonerado
    t-faccpedi.totalIgv = x-sumaIGV
    t-faccpedi.totalImpuestos = t-faccpedi.totalIgv
    t-faccpedi.totalValorVenta = x-sumaImporteTotalSinImpuesto /* + x-exonerado*/
    t-faccpedi.totalPrecioVenta = t-faccpedi.totalValorVentaNetoOpGravadas
    /*t-faccpedi.totalPrecioVenta = (t-faccpedi.totalValorVentaNetoOpGravadas * ( 1 + x-tasaigv)) + t-faccpedi.totalValorVentaNetoOpExoneradas.*/
    t-faccpedi.totalPrecioVenta = t-faccpedi.totalValorVentaNetoOpGravadas + x-sumaIGV.
/* Descuento Globales */
/*
IF t-faccpedi.impdto2 > 0 THEN DO:
    ASSIGN t-faccpedi.totalValorVenta = t-faccpedi.totalValorVenta - (t-faccpedi.impdto2 / (1 + x-TasaIGV)).
END.
*/
/* ICBPER */
ASSIGN /*t-faccpedi.totalPrecioVenta = t-faccpedi.totalValorVenta + x-TotalImpuestoBolsaPlastica + ROUND(t-faccpedi.totalValorVenta * x-TasaIGV,2) */
        t-faccpedi.totalPrecioVenta = t-faccpedi.totalPrecioVenta + x-TotalImpuestoBolsaPlastica
        t-faccpedi.montoBaseICBPER = x-precio-ICBPER
        t-faccpedi.totalMontoICBPER = x-TotalImpuestoBolsaPlastica 
        .

/* EXONERADAS */
IF t-faccpedi.totalValorVentaNetoOpExoneradas > 0 THEN DO:
    ASSIGN t-faccpedi.totalPrecioVenta = t-faccpedi.totalPrecioVenta + t-faccpedi.totalValorVentaNetoOpExoneradas
            t-faccpedi.totalValorVenta = t-faccpedi.totalValorVenta + t-faccpedi.totalValorVentaNetoOpExoneradas.
END.

ASSIGN t-faccpedi.totalVenta = t-faccpedi.totalPrecioVenta.
      /*
/*IF t-faccpedi.coddoc = 'BOL' OR t-faccpedi.coddoc = 'FAC' THEN DO:*/
    /* Descuento GLOBAL */
    IF t-faccpedi.impdto2 > 0 THEN DO:
        ASSIGN  t-faccpedi.montoBaseDescuentoGlobal = x-sumaImporteTotalSinImpuesto
                t-faccpedi.descuentosGlobales = ROUND(t-faccpedi.impdto2 / (1 + x-TasaIGV),2)
                t-faccpedi.PorcentajeDsctoGlobal = ROUND(t-faccpedi.descuentosGlobales / x-sumaImporteTotalSinImpuesto,4)
                t-faccpedi.totalValorVentaNetoOpGravadas = t-faccpedi.montoBaseDescuentoGlobal - t-faccpedi.descuentosGlobales
                t-faccpedi.totalIGV = ROUND(t-faccpedi.totalValorVentaNetoOpGravadas * x-tasaIGV,2)
                t-faccpedi.totalVenta = t-faccpedi.totalValorVentaNetoOpGravadas + t-faccpedi.totalIGV
            .                
    END.
/*END.*/
    */


ASSIGN 
    t-faccpedi.totalImpuestos = t-faccpedi.totalIGV
    t-faccpedi.totalImpuestos = t-faccpedi.totalImpuestos + x-TotalImpuestoBolsaPlastica   /* + ICBPER */
        .

pRetVal = "OK".

RETURN "OK".
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-tasa-impuesto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-tasa-impuesto Procedure 
PROCEDURE get-tasa-impuesto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
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
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-grabar-importes-faccpedi) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-importes-faccpedi Procedure 
PROCEDURE grabar-importes-faccpedi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

pRetVal = "OK".

LOOPGRABAR:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE :
    FIND FIRST t-faccpedi NO-LOCK NO-ERROR.
    /* Detalle  */
    FOR EACH t-facdpedi NO-LOCK:
        FIND FIRST b-facdpedi WHERE b-facdpedi.codcia = t-facdpedi.codcia AND
                                    b-facdpedi.coddoc = t-facdpedi.coddoc AND
                                    b-facdpedi.nroped = t-facdpedi.nroped AND
                                    b-facdpedi.nroitm = t-facdpedi.nroitm EXCLUSIVE-LOCK NO-ERROR.
        IF LOCKED b-facdpedi THEN DO:
            pRetVal = "Al actualizar los importes de sunat al articulo " + t-facdpedi.codmat + " la tabla FACDPEDI esta bloqueada".
            UNDO LOOPGRABAR, LEAVE LOOPGRABAR.
        END.
        IF AVAILABLE b-facdpedi THEN DO:
            BUFFER-COPY t-facdpedi TO b-facdpedi.
        END.
    END.
    /* Cabecera */
    FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = t-faccpedi.codcia AND 
                                b-faccpedi.coddiv = t-faccpedi.coddiv AND 
                                b-faccpedi.coddoc = t-faccpedi.coddoc AND
                                b-faccpedi.nroped = t-faccpedi.nroped EXCLUSIVE-LOCK NO-ERROR.
    IF LOCKED b-faccpedi THEN DO:
        pRetVal = "Al actualizar los importes de sunat al " + t-faccpedi.coddoc + " " + t-faccpedi.nroped + " la tabla FACCPEDI esta bloqueada".
        UNDO LOOPGRABAR, LEAVE LOOPGRABAR.
    END.
    IF AVAILABLE b-faccpedi THEN DO:
        BUFFER-COPY t-faccpedi TO b-faccpedi.
    END.


END.

RELEASE b-faccpedi NO-ERROR.
RELEASE b-facdpedi NO-ERROR.

IF pRetVal <> "OK" THEN DO:
    RETURN "ADM-ERROR".
END.

RETURN "OK".

/*
DO TRANSACTION ON ERROR UNDO, LEAVE:
    DO:
            /* Header update block */
    END.
    FOR EACH OrderLine ON ERROR UNDO, THROW:
            /* Detalle update block */
    END.
END. /* TRANSACTION block */

IF NOT ERROR-STATUS:ERROR THEN  ERROR-STATUS:GET-MESSAGE(1)
*/
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-impuesto-bolsa-plastica) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE impuesto-bolsa-plastica Procedure 
PROCEDURE impuesto-bolsa-plastica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
DEFINE INPUT PARAMETER pCantidad AS DEC.

DEFINE VAR x-implin AS DEC.

x-precio-ICBPER = 0.0.   

/* Sacar el importe de bolsas plasticas */
DEFINE VAR z-hProc AS HANDLE NO-UNDO.               /* Handle Libreria */

RUN ccb\libreria-ccb.p PERSISTENT SET z-hProc.

/* Procedimientos */
RUN precio-impsto-bolsas-plastica IN z-hProc (INPUT TODAY, OUTPUT x-precio-ICBPER).

DELETE PROCEDURE z-hProc.                   /* Release Libreria */

x-implin = pCantidad * x-precio-ICBPER.
x-TotalImpuestoBolsaPlastica = x-TotalImpuestoBolsaPlastica + x-ImpLin.

ASSIGN 
    t-facdpedi.impuestoBolsaPlastico = x-precio-ICBPER   /*x-implin*/
    t-facdpedi.montoTributoBolsaPlastico = x-implin
    t-facdpedi.cantidadBolsaPlastico = pCantidad
    t-facdpedi.montoUnitarioBolsaPlastico = x-precio-ICBPER.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-reset-faccpedi-importes-sunat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reset-faccpedi-importes-sunat Procedure 
PROCEDURE reset-faccpedi-importes-sunat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    ASSIGN t-faccpedi.totalValorVentaNetoOpGravadas = 0
            t-faccpedi.totalValorVentaNetoOpGratuitas = 0
            t-faccpedi.totalTributosOpeGratuitas = 0
            t-faccpedi.totalValorVentaNetoOpExoneradas = 0
            t-faccpedi.totalIGV = 0
            t-faccpedi.totalImpuestos = 0
            t-faccpedi.totalValorVenta = 0
            t-faccpedi.totalPrecioVenta = 0
            t-faccpedi.descuentosGlobales = 0
            t-faccpedi.PorcentajeDsctoGlobal = 0
            t-faccpedi.montoBaseDescuentoGlobal = 0
            t-faccpedi.totalValorVentaNetoOpNoGravada = 0
            t-faccpedi.totalDocumentoAnticipo = 0
            t-faccpedi.montoBaseDsctoGlobalAnticipo = 0
            t-faccpedi.porcentajeDsctoGlobalAnticipo = 0
            t-faccpedi.totalDsctoGlobalesAnticipo = 0
            t-faccpedi.MontoBaseICBPER = 0
            t-faccpedi.TotalMontoICBPER = 0
            t-faccpedi.totalVenta = 0
    .
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-reset-facdpedi-importes-sunat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reset-facdpedi-importes-sunat Procedure 
PROCEDURE reset-facdpedi-importes-sunat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
        ASSIGN t-facdpedi.cTipoAfectacion = ""
                t-facdpedi.cPreUniSinImpuesto = 0
                t-facdpedi.FactorDescuento = 0
                t-facdpedi.TasaIGV = 0
                t-facdpedi.ImporteUnitarioSinImpuesto = 0
                t-facdpedi.ImporteReferencial = 0
                t-facdpedi.ImporteBaseDescuento = 0
                t-facdpedi.ImporteDescuento = 0
                t-facdpedi.ImporteTotalSinImpuesto = 0
                t-facdpedi.MontoBaseIGV = 0
                t-facdpedi.ImporteIGV = 0
                t-facdpedi.ImporteTotalImpuesto = 0
                t-facdpedi.ImporteUnitarioConImpuesto = 0
                t-facdpedi.cImporteVentaExonerado = 0
                t-facdpedi.cImporteVentaGratuito = 0
                t-facdpedi.cSumaImpteTotalSinImpuesto = 0
                t-facdpedi.cMontoBaseIGV = 0
                t-facdpedi.cSumaIGV = 0
                t-facdpedi.cOtrosTributosOpGratuito = 0
                t-facdpedi.impuestoBolsaPlastico = 0
                t-facdpedi.montoTributoBolsaPlastico = 0
                t-facdpedi.cantidadBolsaPlastico = 0
                t-facdpedi.montoUnitarioBolsaPlastico = 0
                /*t-facdpedi.importeTotalConImpuesto = 0*/
            .
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tabla-ccbcdocu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tabla-ccbcdocu Procedure 
PROCEDURE tabla-ccbcdocu :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDiv AS CHAR NO-UNDO.     /* Puede ser vacio tambien */
DEFINE INPUT PARAMETER pCoddoc AS CHAR NO-UNDO.     /* COT,PED,P/M,O/M,O/D */
DEFINE INPUT PARAMETER pNroDoc AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

pRetVal = "OK".

x-tabla = "CCBCDOCU".

RUN sunat/sunat-calculo-importes-ccbcdocu.r (INPUT pCodDiv,
                                           INPUT pCoddoc,
                                           INPUT pNroDoc,
                                           OUTPUT pRetVal).
IF pRetVal <> "OK" THEN DO:
    RETURN "ADM-ERROR".
END.
pRetVal = "".
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tabla-faccpedi) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tabla-faccpedi Procedure 
PROCEDURE tabla-faccpedi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDiv AS CHAR NO-UNDO.     /* Puede ser vacio tambien */
DEFINE INPUT PARAMETER pCoddoc AS CHAR NO-UNDO.     /* COT,PED,P/M,O/M,O/D */
DEFINE INPUT PARAMETER pNroDoc AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

RUN sunat/sunat-calculo-importes-faccpedi.r (INPUT pCodDiv,
                                          INPUT pCoddoc,
                                          INPUT pNroDoc,
                                          OUTPUT pRetVal).
IF pRetVal <> "OK" THEN DO:
    RETURN "ADM-ERROR".
END.
pRetVal = "OK".

RETURN 'OK'.

END PROCEDURE.

/*
pRetVal = "OK".

IF TRUE <> (pCodDiv > "") THEN DO:
    /* Sin division */
    FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                x-faccpedi.coddoc = pCodDoc AND
                                x-faccpedi.nroped = pNroDOc NO-LOCK NO-ERROR.
    IF NOT AVAILABLE x-faccpedi THEN DO:
        pRetVal = pCodDoc + "-" + pNroDOc + " No existe".
        RETURN "ADM-ERROR".
    END.
    IF x-faccpedi.flgest = 'A' THEN DO:
        pRetVal = pCodDoc + "-" + pNroDOc + " Esta ANULADO".
        RETURN "ADM-ERROR".
    END.
END.
ELSE DO:
    /* Con division */
    FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                x-faccpedi.coddiv = pCodDiv AND
                                x-faccpedi.coddoc = pCodDoc AND
                                x-faccpedi.nroped = pNroDOc NO-LOCK NO-ERROR.
    IF NOT AVAILABLE x-faccpedi THEN DO:
        pRetVal = pCodDoc + "-" + pNroDOc + " Division :" + pCodDiv + " No existe".
        RETURN "ADM-ERROR".
    END.
    IF x-faccpedi.flgest = 'A' THEN DO:
        pRetVal = pCodDoc + "-" + pNroDOc + " Division :" + pCodDiv + " Esta ANULADO".
        RETURN "ADM-ERROR".
    END.
END.

/* Calculos */
x-tabla = "FACCPEDI".
/*RUN calculo-importes-faccpedi(OUTPUT pRetVal).*/
RUN calculo-de-importes(OUTPUT pRetVal, INPUT 'FACCPEDI').

IF pRetVal <> "OK" THEN DO:
    RETURN "ADM-ERROR".
END.

/* GRABAR DATA */
/*RUN grabar-importes-faccpedi(OUTPUT pRetVal). */

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

