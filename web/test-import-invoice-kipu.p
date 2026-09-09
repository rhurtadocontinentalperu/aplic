DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR pcError AS CHAR NO-UNDO.

DEF VAR s-NroDec AS INTE INIT 4 NO-UNDO.
DEF VAR s-PorIgv AS DECI INIT 18 NO-UNDO.
DEF NEW SHARED VAR s-codcia AS INTE INIT 001.
DEF NEW SHARED VAR s-coddiv AS CHAR INIT '00043'.

DISABLE TRIGGERS FOR LOAD OF ccbcdocu.
DISABLE TRIGGERS FOR LOAD OF ccbddocu.

DEF VAR hProcSunat AS HANDLE NO-UNDO.
RUN sunat/sunat-calculo-importes PERSISTENT SET hProcSunat.


FIND faccpedi WHERE codcia = 1 
    and coddiv = '00043' 
    and coddoc = 'P/M' 
    and nroped = '043000002'
    .

RUN Save_Detail (OUTPUT pMensaje).
/* ************************************************************************************** */
{vtagn/totales-cotizacion-sunat.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
/* ************************************************************************************** */
MESSAGE 'Pausa 1'.

FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia 
        AND Ccbcdocu.codped = Faccpedi.coddoc
        AND Ccbcdocu.nroped = Faccpedi.nroped
        AND LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL') > 0
        .

FOR EACH ccbddocu OF ccbcdocu:
    DELETE ccbddocu.
END.

RUN Save_Detail_Invoice (OUTPUT pcError).

/* Totales por Comprobante */
DEFINE VAR x-TotalImpuestoBolsaPlastica AS DECI.

RUN Save_Total_Invoice.


PROCEDURE SAVE_Detail:

    DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

    pMensaje = "".
    RLOOP:
    DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        FOR EACH Facdpedi OF Faccpedi ON ERROR UNDO, THROW:
            ASSIGN
                FacDPedi.ImpLin = FacDPedi.CanPed * FacDPedi.PreUni * 
                  ( 1 - FacDPedi.Por_Dsctos[1] / 100 ) *
                  ( 1 - FacDPedi.Por_Dsctos[2] / 100 ) *
                  ( 1 - FacDPedi.Por_Dsctos[3] / 100 ).
            IF FacDPedi.Por_Dsctos[1] = 0 AND FacDPedi.Por_Dsctos[2] = 0 AND FacDPedi.Por_Dsctos[3] = 0 
              THEN FacDPedi.ImpDto = 0.
              ELSE FacDPedi.ImpDto = FacDPedi.CanPed * FacDPedi.PreUni - FacDPedi.ImpLin.
            /* CON FLETE */
            IF FacDPedi.Libre_d02 > 0 THEN DO:
                /* El flete afecta el monto final */
                IF FacDPedi.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
                    ASSIGN
                        FacDPedi.PreUni = ROUND(FacDPedi.PreUni + FacDPedi.Libre_d02, s-NroDec)  /* Incrementamos el PreUni */
                        FacDPedi.ImpLin = FacDPedi.CanPed * FacDPedi.PreUni.
                END.
                ELSE DO:      /* CON descuento promocional o volumen */
                    /* El flete afecta al precio unitario resultante */
                    DEF VAR LocalPreUniFin LIKE Facdpedi.PreUni NO-UNDO.
                    DEF VAR LocalPreUniTeo LIKE Facdpedi.PreUni NO-UNDO.
                    LocalPreUniFin = FacDPedi.ImpLin / FacDPedi.CanPed.     /* Valor resultante */
                    LocalPreUniFin = LocalPreUniFin + FacDPedi.Libre_d02.    /* Unitario Afectado al Flete */
                    LocalPreUniTeo = LocalPreUniFin / ( ( 1 - FacDPedi.Por_Dsctos[1] / 100 ) * ( 1 - FacDPedi.Por_Dsctos[2] / 100 ) * ( 1 - FacDPedi.Por_Dsctos[3] / 100 ) ). 
                    IF LocalPreUniTeo = ? THEN LocalPreUniTeo = 0.
                    /* Comtemplar 100 dsctos que viene desde el pedido comercial - Susana Leon/Carla Tenazoa*/
                    IF LocalPreUniTeo <= 0 AND (FacDPedi.Por_Dsctos[1] + FacDPedi.Por_Dsctos[2] + FacDPedi.Por_Dsctos[3] ) >= 100 THEN LocalPreUniTeo = FacDPedi.PreUni.
                    ASSIGN
                        FacDPedi.PreUni = ROUND(LocalPreUniTeo, s-NroDec).
                END.
                ASSIGN
                    FacDPedi.ImpLin = ROUND ( FacDPedi.CanPed * FacDPedi.PreUni * 
                                              ( 1 - FacDPedi.Por_Dsctos[1] / 100 ) *
                                              ( 1 - FacDPedi.Por_Dsctos[2] / 100 ) *
                                              ( 1 - FacDPedi.Por_Dsctos[3] / 100 ), 2 ).
                IF FacDPedi.Por_Dsctos[1] = 0 AND FacDPedi.Por_Dsctos[2] = 0 AND FacDPedi.Por_Dsctos[3] = 0 
                    THEN FacDPedi.ImpDto = 0.
                ELSE FacDPedi.ImpDto = (FacDPedi.CanPed * FacDPedi.PreUni) - FacDPedi.ImpLin.
            END.
            /*/* ***************************************************************** */*/
            ASSIGN
                FacDPedi.ImpLin = ROUND(FacDPedi.ImpLin, 2)
                FacDPedi.ImpDto = ROUND(FacDPedi.ImpDto, 2).
            IF FacDPedi.AftIsc 
                THEN FacDPedi.ImpIsc = ROUND(FacDPedi.PreBas * FacDPedi.CanPed * (Almmmatg.PorIsc / 100), s-NroDec).
            IF FacDPedi.AftIgv 
                THEN FacDPedi.ImpIgv =  FacDPedi.ImpLin - ( FacDPedi.ImpLin  / ( 1 + (s-PorIgv / 100)) ).
            /* ***************************************************************** */
            ASSIGN
                FacDPedi.ImpIgv = ROUND(FacDPedi.ImpIgv, s-NroDec).
        END.
    END.
    IF ERROR-STATUS:ERROR THEN pMensaje = ERROR-STATUS:GET-MESSAGE(1).


END PROCEDURE.


PROCEDURE Save_Detail_Invoice:


    DEF OUTPUT PARAMETER pcError AS CHAR NO-UNDO.

    DEF VAR iCountItem AS INTE INIT 1 NO-UNDO.

    RLOOP:
    DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        FOR EACH Facdpedi OF Faccpedi NO-LOCK BY Facdpedi.NroItm:
            CREATE Ccbddocu.
            BUFFER-COPY Facdpedi TO Ccbddocu
                ASSIGN
                    Ccbddocu.CodCia = Ccbcdocu.CodCia
                    Ccbddocu.Coddoc = Ccbcdocu.Coddoc
                    Ccbddocu.NroDoc = Ccbcdocu.NroDoc 
                    Ccbddocu.FchDoc = Ccbcdocu.FchDoc
                    Ccbddocu.CodDiv = Ccbcdocu.CodDiv
                    Ccbddocu.NroItm = iCountItem
                    Ccbddocu.CanDes = Facdpedi.CanPed
                    Ccbddocu.Factor = Facdpedi.Factor
                    Ccbddocu.UndVta = Facdpedi.UndVta
                    Ccbddocu.ImpIgv = Facdpedi.ImpIgv
                    Ccbddocu.ImpIsc = Facdpedi.ImpIsc
                    Ccbddocu.ImpDto = Facdpedi.ImpDto
                    Ccbddocu.ImpLin = Facdpedi.ImpLin
                    Ccbddocu.impdcto_adelanto[4] = Facdpedi.Libre_d02   /* Flete Unitario */
                NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pcError = TRIM(ERROR-STATUS:GET-MESSAGE(1)).
                UNDO RLOOP, LEAVE RLOOP.
            END.
            iCountItem = iCountItem + 1.
        END.
    END.
    IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.
    IF ERROR-STATUS:ERROR AND pcError = "" THEN pcError = TRIM(ERROR-STATUS:GET-MESSAGE(1)).

END PROCEDURE.


PROCEDURE Save_Total_Invoice:

DEF VAR pcError AS CHAR NO-UNDO.


ASSIGN
    Ccbcdocu.ImpBrt =     Faccpedi.ImpBrt 
    Ccbcdocu.ImpDto =     Faccpedi.ImpDto 
    Ccbcdocu.ImpDto2 =    Faccpedi.ImpDto2
    Ccbcdocu.ImpIgv =     Faccpedi.ImpIgv 
    Ccbcdocu.ImpIsc =     Faccpedi.ImpIsc 
    Ccbcdocu.ImpTot =     Faccpedi.ImpTot 
    Ccbcdocu.ImpExo =     Faccpedi.ImpExo 
    Ccbcdocu.ImpVta =     Faccpedi.ImpVta 
    Ccbcdocu.AcuBon[10] = 0
    .
ASSIGN
    Ccbcdocu.ImpVta = Faccpedi.ImpVta
    Ccbcdocu.ImpBrt = Faccpedi.ImpBrt
    .

/* ************************************************** */
/* Nos aseguramos grabar bien el saldo */
/* ************************************************** */
ASSIGN
    Ccbcdocu.SdoAct = Ccbcdocu.ImpTot.

IF LOOKUP(Ccbcdocu.FmaPgo, "899,900") > 0 OR Ccbcdocu.FlgEst = "C" 
    THEN ASSIGN
            Ccbcdocu.FlgEst = "C"
            Ccbcdocu.FchCan = TODAY
            Ccbcdocu.SdoAct = 0.

MESSAGE 'Pausa 2'.

RUN tabla-ccbcdocu.       

MESSAGE 'Pausa 3'.


END PROCEDURE.

PROCEDURE tabla-ccbcdocu:
/* ********************** */

RUN reset-importes-sunat-cabecera.

/* Transferencia gratuita */
DEF VAR x-es-transferencia-gratuita AS LOG NO-UNDO.
DEF VAR x-tasaigv AS DECI NO-UNDO.
DEF VAR x-factor-descuento AS DECI NO-UNDO.
DEF VAR x-dcto_otros_factor AS DECI NO-UNDO.
DEF VAR x-dcto_encarte AS DECI NO-UNDO.

DEFINE VAR x-items AS INT INIT 0.
DEFINE VAR x-filer1 AS DEC INIT 0.0000.
DEFINE VAR x-filer2 AS DEC INIT 0.0000.

DEFINE VAR  x-linea-bolsas-plastica AS CHAR NO-UNDO.
DEFINE VAR x-articulo-ICBPER AS CHAR NO-UNDO.
DEFINE VAR x-existe-icbper AS LOG NO-UNDO.
DEFINE VAR x-exonerado AS DECI NO-UNDO.
DEFINE VAR x-gratuito AS DEC NO-UNDO.
DEFINE VAR x-sumaImporteTotalSinImpuesto AS DEC.
DEFINE VAR x-montoBaseIgv AS DEC.
DEFINE VAR x-sumaIGV AS DEC.
DEFINE VAR x-OtrosTributosOpGratuitas AS DEC. 
DEFINE VAR x-TotalImpuestos AS DEC.

x-articulo-ICBPER = "099268".
x-linea-bolsas-plastica = "086".
x-tasaigv = Ccbcdocu.PorIgv / 100.

x-items = 0.
FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
    FIND FIRST almmmatg OF Ccbddocu NO-LOCK NO-ERROR.    
    x-items = x-items + 1.
    IF x-items > 1 THEN LEAVE.
END.
x-es-transferencia-gratuita = NO.
IF LOOKUP(Ccbcdocu.fmapgo,"899,900") > 0  THEN DO:
    x-es-transferencia-gratuita  = YES.
END.

x-exonerado = 0.
x-gratuito = 0.
x-gratuito = 0.
x-sumaImporteTotalSinImpuesto = 0.
x-montoBaseIgv = 0.
x-sumaIGV = 0.
x-OtrosTributosOpGratuitas = 0.

FOR EACH Ccbddocu OF Ccbcdocu EXCLUSIVE-LOCK:
    FIND FIRST almmmatg OF Ccbddocu NO-LOCK NO-ERROR.
    IF Ccbddocu.codmat = x-articulo-ICBPER THEN DO:
        /* Ya no considerar el item ICBPER como articulo */
        NEXT.
    END.


    RUN reset-importes-sunat-detalle.
    /* Tipo de Afectación */
    ASSIGN Ccbddocu.cTipoAfectacion = "GRAVADA".
    IF x-es-transferencia-gratuita  = YES THEN DO:
        ASSIGN Ccbddocu.cTipoAfectacion = "GRATUITA".
    END.
    ELSE DO:
        IF Ccbddocu.aftigv = NO THEN ASSIGN Ccbddocu.cTipoAfectacion = "EXONERADA".        
        IF LOOKUP(Ccbddocu.coddoc,"N/C,N/D") = 0 THEN DO:
            IF Ccbddocu.preuni <= 0.06 THEN ASSIGN Ccbddocu.cTipoAfectacion = "GRATUITA".
        END.
    END.
    /* Precio Unitario SIN impuestos */
    IF Ccbddocu.cTipoAfectacion = "EXONERADA" THEN DO:
        ASSIGN Ccbddocu.cPreUniSinImpuesto = Ccbddocu.preuni.
    END.
    ELSE DO:
        ASSIGN Ccbddocu.cPreUniSinImpuesto = ROUND(Ccbddocu.preuni / (1 + x-TasaIGV),4). /*4*/
    END.
    /* Factor del Descuento: en decimales */
    x-factor-descuento = 0.
    IF LOOKUP(Ccbddocu.coddoc,"N/C,N/D") = 0 THEN DO:
        x-dcto_otros_factor  = 0.
        x-dcto_encarte = 0.     /* NO se está dando junto con por:dsctos[x] */
                                /* En caso contrario revisar la rutuina */
        x-dcto_otros_factor = Ccbddocu.dcto_otros_factor.
        IF Ccbddocu.ImpDto2 > 0 THEN x-dcto_encarte = Ccbddocu.ImpDto2 / Ccbddocu.ImpLin * 100.
        IF Ccbddocu.Por_Dsctos[1]     > 0 
            OR Ccbddocu.Por_Dsctos[2] > 0 
            OR Ccbddocu.Por_Dsctos[3] > 0 /*OR t-Ccbddocu.dcto_otros_factor > 0*/ 
            OR x-dcto_otros_factor  > 0 
            OR x-dcto_encarte > 0 THEN DO:
            x-factor-descuento = ( 1 -  ( 1 - Ccbddocu.Por_Dsctos[1] / 100 ) *
                                   ( 1 - Ccbddocu.Por_Dsctos[2] / 100 ) *
                                   ( 1 - Ccbddocu.Por_Dsctos[3] / 100 ) *  
                                   ( 1 - x-dcto_encarte / 100 ) *
                                   ( 1 - x-dcto_otros_factor / 100 ) ) *  100.                        
            x-factor-descuento = ROUND(x-factor-descuento / 100 , 5).   /* Puede ser hasta 5 decimales */
        END.
    END.
    IF x-factor-descuento >= 1 THEN DO:
        ASSIGN Ccbddocu.cTipoAfectacion = "GRATUITA".
    END.
    ASSIGN Ccbddocu.FactorDescuento = x-factor-descuento.
    /* Tasa de IGV */
    IF LOOKUP(Ccbddocu.cTipoAfectacion,"EXONERADA,INAFECTA") = 0 THEN DO:
        ASSIGN Ccbddocu.TasaIGV = x-tasaIGV.
    END.
    /* Importes Unitarios */
    IF Ccbddocu.cTipoAfectacion <> "GRATUITA" THEN DO:
        ASSIGN Ccbddocu.ImporteUnitarioSinImpuesto = Ccbddocu.cPreUniSinImpuesto.
    END.
    IF LOOKUP(Ccbddocu.cTipoAfectacion,"GRATUITA") > 0 THEN DO:
        ASSIGN Ccbddocu.ImporteReferencial = Ccbddocu.cPreUniSinImpuesto.
    END.
    /* Importe Base del Descuento */
    IF Ccbddocu.FactorDescuento > 0 THEN DO:
        ASSIGN 
            Ccbddocu.ImporteBaseDescuento = ROUND(Ccbddocu.ImporteUnitarioSinImpuesto * Ccbddocu.candes,2) 
            Ccbddocu.ImporteDescuento = ROUND(Ccbddocu.FactorDescuento * Ccbddocu.ImporteBaseDescuento,2).
    END.
    /* Importe total SIN impuestos */
    IF Ccbddocu.cTipoAfectacion = "GRATUITA" THEN DO:
        ASSIGN 
            Ccbddocu.ImporteTotalSinImpuesto = ROUND(Ccbddocu.ImporteReferencial * Ccbddocu.candes,2) 
            Ccbddocu.MontoBaseIGV = ROUND(Ccbddocu.ImporteReferencial * Ccbddocu.candes,2).
    END.
    ELSE DO:
        ASSIGN 
            Ccbddocu.ImporteTotalSinImpuesto = ROUND(Ccbddocu.ImporteUnitarioSinImpuesto * Ccbddocu.candes,2) - Ccbddocu.ImporteDescuento
            Ccbddocu.MontoBaseIGV = ROUND(Ccbddocu.ImporteUnitarioSinImpuesto * Ccbddocu.candes,2) - Ccbddocu.ImporteDescuento.
    END.
    /* Importes IMPUESTOS con y sin impuestos */
    ASSIGN 
        Ccbddocu.ImporteIGV = ROUND(Ccbddocu.MontoBaseIGV * Ccbddocu.TasaIGV,2)
        Ccbddocu.ImporteTotalImpuestos = IF (Ccbddocu.cTipoAfectacion = "GRATUITA") THEN 0 ELSE Ccbddocu.ImporteIGV.

    IF Ccbddocu.cTipoAfectacion <> "GRATUITA" THEN DO:
        Ccbddocu.ImporteUnitarioConImpuesto = ROUND((Ccbddocu.ImporteTotalSinImpuesto + Ccbddocu.ImporteTotalImpuesto) / Ccbddocu.candes,4). /*4*/
        /* Caso CyC las facturas x anticipos de campaña, la aritmetica incrementa 0.01 */
        IF Ccbcdocu.coddoc = 'FAC' OR Ccbcdocu.coddoc = 'BOL' THEN DO:
            IF x-items = 1 AND x-filer2 = 1 AND Ccbcdocu.fmapgo = '403' THEN DO:
                Ccbddocu.ImporteUnitarioConImpuesto = Ccbddocu.preuni.
            END.
        END.
    END.
    IF Ccbddocu.cTipoAfectacion = "EXONERADA" THEN DO:
        ASSIGN Ccbddocu.cImporteVentaExonerado = ROUND(Ccbddocu.ImporteUnitarioSinImpuesto * Ccbddocu.candes,4) - Ccbddocu.ImporteDescuento.
    END.
    IF Ccbddocu.cTipoAfectacion = "GRATUITA" THEN DO:
        ASSIGN Ccbddocu.cImporteVentaGratuito = ROUND(Ccbddocu.ImporteReferencial * Ccbddocu.candes,4).
    END.
    IF LOOKUP(Ccbddocu.cTipoAfectacion,"EXONERADA,GRATUITA") = 0 THEN DO:
        ASSIGN  
            Ccbddocu.cSumaImpteTotalSinImpuesto = Ccbddocu.ImporteTotalSinImpuesto
            Ccbddocu.cMontoBaseIGV = Ccbddocu.MontoBaseIGV.
    END.
    IF Ccbddocu.cTipoAfectacion <> "GRATUITA" THEN DO:
        ASSIGN Ccbddocu.cSumaIGV = Ccbddocu.ImporteIGV.
    END.
    IF Ccbddocu.cTipoAfectacion = "GRATUITA" THEN DO:
        Ccbddocu.cOtrosTributosOpGratuito = Ccbddocu.ImporteIGV.
    END.
    /* Importe Total Con Impuestos */
    IF Ccbddocu.cTipoAfectacion <> "GRATUITA" THEN DO:
        ASSIGN
            Ccbddocu.cImporteTotalConImpuesto = Ccbddocu.MontoBaseIGV + Ccbddocu.ImporteIGV.
        /* Caso CyC las facturas x anticipos de campaña, la aritmetica incrementa 0.01 */
        IF Ccbcdocu.coddoc = 'FAC' OR Ccbcdocu.coddoc = 'BOL' THEN DO:
            IF x-items = 1 AND x-filer2 = 1 AND Ccbcdocu.fmapgo = '403' THEN DO:
                ASSIGN Ccbddocu.cImporteTotalConImpuesto = Ccbddocu.ImporteUnitarioConImpuesto * Ccbddocu.candes.
            END.
        END.
    END.
    x-filer2 = Ccbddocu.candes.
    /* Bolsa Plastica */
    IF AVAILABLE almmmatg AND almmmatg.codfam = x-linea-bolsas-plastica THEN DO:
        RUN impuesto-bolsa-plastica(INPUT Ccbddocu.candes).
        ASSIGN Ccbddocu.ImporteTotalImpuesto = Ccbddocu.ImporteTotalImpuesto + Ccbddocu.montoTributoBolsaPlastico.
        x-existe-icbper = YES.        
    END.        
    /**/
    IF Ccbddocu.cTipoAfectacion = "EXONERADA" THEN DO:        
        x-exonerado = x-exonerado + Ccbddocu.cImporteVentaExonerado.  /* R */
    END.
    IF Ccbddocu.cTipoAfectacion = "GRATUITA" THEN DO:
        x-gratuito = x-gratuito + Ccbddocu.cImporteVentaGratuito.     /* S */
    END.
    IF LOOKUP(Ccbddocu.cTipoAfectacion,"EXONERADA,GRATUITA") = 0 THEN DO:
        x-sumaImporteTotalSinImpuesto = x-sumaImporteTotalSinImpuesto + Ccbddocu.cSumaImpteTotalSinImpuesto.  /* T */        
        x-montoBaseIgv = x-montoBaseIgv + Ccbddocu.cMontoBaseIGV.     /* U */
    END.
    IF Ccbddocu.cTipoAfectacion <> "GRATUITA" THEN DO:
        x-sumaIGV = x-sumaIGV + Ccbddocu.cSumaIGV.                /* V */
    END.
    IF Ccbddocu.cTipoAfectacion = "GRATUITA" THEN DO:
        x-OtrosTributosOpGratuitas = x-OtrosTributosOpGratuitas + Ccbddocu.cOtrosTributosOpGratuito.  /* W */
    END.
END.

/* Totales */
ASSIGN 
    Ccbcdocu.totalValorVentaNetoOpGravadas = x-sumaImporteTotalSinImpuesto
    Ccbcdocu.totalValorVentaNetoOpGratuitas = x-gratuito
    Ccbcdocu.totalTributosOpeGratuitas = x-OtrosTributosOpGratuitas
    Ccbcdocu.totalValorVentaNetoOpExoneradas = x-exonerado
    Ccbcdocu.totalIgv = x-sumaIGV
    Ccbcdocu.totalImpuestos = Ccbcdocu.totalIgv
    Ccbcdocu.totalValorVenta = x-sumaImporteTotalSinImpuesto
    Ccbcdocu.totalPrecioVenta = Ccbcdocu.totalValorVentaNetoOpGravadas + x-sumaIGV.

IF Ccbcdocu.coddoc = 'FAC' OR Ccbcdocu.coddoc = 'BOL' THEN DO:
    IF x-items = 1 AND x-filer2 = 1 AND Ccbcdocu.fmapgo = '403' THEN DO:
        /* Caso CyC las facturas x anticipos de campaña, la aritmetica incrementa 0.01 */
        ASSIGN Ccbcdocu.totalPrecioVenta = x-filer1.
    END.
END.
/* ICBPER */
ASSIGN Ccbcdocu.totalPrecioVenta = Ccbcdocu.totalPrecioVenta + x-TotalImpuestoBolsaPlastica
        Ccbcdocu.montoBaseICBPER = x-precio-ICBPER 
        Ccbcdocu.totalMontoICBPER = x-TotalImpuestoBolsaPlastica. 
/* EXONERADAS */
IF Ccbcdocu.totalValorVentaNetoOpExoneradas > 0 THEN DO:
    ASSIGN Ccbcdocu.totalPrecioVenta = Ccbcdocu.totalPrecioVenta + Ccbcdocu.totalValorVentaNetoOpExoneradas
            Ccbcdocu.totalValorVenta = Ccbcdocu.totalValorVenta + Ccbcdocu.totalValorVentaNetoOpExoneradas.
END.

x-TotalImpuestos = Ccbcdocu.totalIGV.   /* Jul2024 : x-OtrosTributosOpGratuitas. */
ASSIGN 
    Ccbcdocu.totalVenta = Ccbcdocu.totalPrecioVenta.
ASSIGN 
    Ccbcdocu.totalImpuestos = x-TotalImpuestos.   
/* + ICBPER */
ASSIGN 
    Ccbcdocu.totalImpuestos = Ccbcdocu.totalImpuestos + x-TotalImpuestoBolsaPlastica.   

/* ************************************************************************* */
/* AJUSTE DE IMPORTES FINALES EN CASO DE B2C / RIQRA */
/* ************************************************************************* */
DEF VAR Local_Delta AS DECI NO-UNDO.
DEF VAR Local_TipoAfectacion AS CHAR NO-UNDO.
DEF VAR importeDescuentoGlobal AS DEC.
        
importeDescuentoGlobal = Ccbcdocu.impint.
Local_Delta = Ccbcdocu.ImpTot - importeDescuentoGlobal - Ccbcdocu.TotalVenta.
{sunat/sunat-calculo-importes-ajustados.i &CabeceraAjuste="Ccbcdocu" &DetalleAjuste="Ccbddocu"}

END PROCEDURE.

PROCEDURE reset-importes-sunat-cabecera:
/* ************************************* */

ASSIGN 
    Ccbcdocu.totalValorVentaNetoOpGravadas = 0
    Ccbcdocu.totalValorVentaNetoOpGratuitas = 0
    Ccbcdocu.totalTributosOpeGratuitas = 0
    Ccbcdocu.totalValorVentaNetoOpExoneradas = 0
    Ccbcdocu.totalIGV = 0
    Ccbcdocu.totalImpuestos = 0
    Ccbcdocu.totalValorVenta = 0
    Ccbcdocu.totalPrecioVenta = 0
    Ccbcdocu.descuentosGlobales = 0
    Ccbcdocu.PorcentajeDsctoGlobal = 0
    Ccbcdocu.montoBaseDescuentoGlobal = 0
    Ccbcdocu.totalValorVentaNetoOpNoGravada = 0
    Ccbcdocu.totalDocumentoAnticipo = 0
    Ccbcdocu.montoBaseDsctoGlobalAnticipo = 0
    Ccbcdocu.porcentajeDsctoGlobalAnticipo = 0
    Ccbcdocu.totalDsctoGlobalesAnticipo = 0
    Ccbcdocu.MontoBaseICBPER = 0
    Ccbcdocu.TotalMontoICBPER = 0
    Ccbcdocu.totalVenta = 0
    .

END PROCEDURE.

PROCEDURE reset-importes-sunat-detalle:

ASSIGN Ccbddocu.cTipoAfectacion = ""
        Ccbddocu.cPreUniSinImpuesto = 0
        Ccbddocu.FactorDescuento = 0
        Ccbddocu.TasaIGV = 0
        Ccbddocu.ImporteUnitarioSinImpuesto = 0
        Ccbddocu.ImporteReferencial = 0
        Ccbddocu.ImporteBaseDescuento = 0
        Ccbddocu.ImporteDescuento = 0
        Ccbddocu.ImporteTotalSinImpuesto = 0
        Ccbddocu.MontoBaseIGV = 0
        Ccbddocu.ImporteIGV = 0
        Ccbddocu.ImporteTotalImpuesto = 0
        Ccbddocu.ImporteUnitarioConImpuesto = 0
        Ccbddocu.cImporteVentaExonerado = 0
        Ccbddocu.cImporteVentaGratuito = 0
        Ccbddocu.cSumaImpteTotalSinImpuesto = 0
        Ccbddocu.cMontoBaseIGV = 0
        Ccbddocu.cSumaIGV = 0
        Ccbddocu.cOtrosTributosOpGratuito = 0
        Ccbddocu.impuestoBolsaPlastico = 0
        Ccbddocu.montoTributoBolsaPlastico = 0
        Ccbddocu.cantidadBolsaPlastico = 0
        Ccbddocu.montoUnitarioBolsaPlastico = 0
        Ccbddocu.cimporteTotalConImpuesto = 0.

END PROCEDURE.


PROCEDURE impuesto-bolsa-plastica:

DEFINE INPUT PARAMETER pCantidad AS DEC.

DEFINE VAR x-implin AS DEC.

x-precio-ICBPER = 0.0.   

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
    Ccbddocu.impuestoBolsaPlastico = x-precio-ICBPER   /*x-implin*/
    Ccbddocu.montoTributoBolsaPlastico = x-implin
    Ccbddocu.cantidadBolsaPlastico = pCantidad
    Ccbddocu.montoUnitarioBolsaPlastico = x-precio-ICBPER.


END PROCEDURE.
