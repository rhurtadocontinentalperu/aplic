TRIGGER PROCEDURE FOR WRITE OF ccbcdocu OLD BUFFER Oldccbcdocu.

DEF VAR cl-codcia AS INT.

/* RHC 21/10/2020 Capturamos lista de precios */
DEF BUFFER PEDIDOS FOR Faccpedi.
DEF BUFFER COTIZACIONES FOR Faccpedi.
FIND PEDIDOS WHERE PEDIDOS.codcia = Ccbcdocu.codcia
    AND PEDIDOS.coddoc = Ccbcdocu.codped
    AND PEDIDOS.nroped = Ccbcdocu.nroped
    NO-LOCK NO-ERROR.
IF AVAILABLE PEDIDOS THEN DO:
    FIND COTIZACIONES WHERE COTIZACIONES.codcia = PEDIDOS.codcia
        AND COTIZACIONES.coddoc = PEDIDOS.codref
        AND COTIZACIONES.nroped = PEDIDOS.nroref
        NO-LOCK NO-ERROR.
    IF AVAILABLE COTIZACIONES AND COTIZACIONES.Lista_de_Precios > ''
        THEN Ccbcdocu.Lista_de_Precios = COTIZACIONES.Lista_de_Precios.
END.

/* AJUSTE DE MONTOS */
IF Ccbcdocu.ImpDto < 0 AND (Ccbcdocu.ImpBrt + ABS(Ccbcdocu.ImpDto) = Ccbcdocu.ImpVta) 
    THEN ASSIGN
            Ccbcdocu.ImpBrt = Ccbcdocu.ImpBrt + ABS(Ccbcdocu.ImpDto)
            Ccbcdocu.ImpDto = 0.

/* CUANDO MARCAMOS COMO ANULADAS LAS GUIAS DE REMISION */
IF CcbCDocu.coddoc = 'G/R' AND CcbCDocu.flgest = 'A' THEN DO:
    /* buscamos si se encuentra activa en una hoja de ruta */
    FOR EACH Di-Rutad NO-LOCK WHERE di-rutad.codcia = ccbcdocu.codcia
        AND di-rutad.coddoc = 'H/R'
        AND di-rutad.codref = ccbcdocu.coddoc
        AND di-rutad.nroref = ccbcdocu.nrodoc,
        FIRST di-rutac OF di-rutad NO-LOCK WHERE di-rutac.flgest <> 'A':
        IF di-rutac.flgest = 'E' OR di-rutac.flgest = 'P' THEN DO:
            MESSAGE 'La guia está aún en tránsito en la Hoja de Ruta' di-rutac.nrodoc SKIP
                'No se puede anular la guía'
                VIEW-AS ALERT-BOX ERROR.
            RETURN ERROR.
        END.
        IF di-rutac.flgest = 'C' THEN DO:   /* H/R CERRADA */
            IF di-rutad.flgest = 'C' THEN DO:      /* ENTREGADA */
                MESSAGE 'La guía ya fue entregada con la Hoja de Ruta' di-rutad.nrodoc SKIP
                    'No se puede anular la guía'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN ERROR.
            END.
        END.
    END.
END.
/* REGISTRO DE MIGRACION AL SPEED */
IF NEW ccbcdocu THEN DO:
    ASSIGN
        ccbcdocu.FchCobranza = ccbcdocu.FchVto.
    /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
    FIND GN-VEN WHERE gn-ven.codcia = ccbcdocu.codcia
        AND gn-ven.codven = ccbcdocu.codven
        NO-LOCK NO-ERROR.
    IF AVAILABLE GN-VEN THEN ccbcdocu.cco = gn-ven.cco.
END.

DEF VAR x-FchCan LIKE Ccbcdocu.FchCan NO-UNDO.
DEF VAR x-ProPro AS DEC NO-UNDO.
DEF VAR x-ProFot AS DEC NO-UNDO.
DEF VAR x-ProOtr AS DEC NO-UNDO.
/* SOLO CUANDO EL DOCUMENTO ES CANCELADO */
FIND FacDocum WHERE FacDocum.codcia = Ccbcdocu.codcia
    AND FacDocum.coddoc = Ccbcdocu.coddoc
    NO-LOCK NO-ERROR.
IF Ccbcdocu.FlgEst = 'C' THEN DO:
    x-FchCan = Ccbcdocu.FchDoc.
    IF AVAILABLE FacDocum THEN DO:
        IF FacDocum.TpoDoc = YES THEN DO:   /* CARGOS */
            FOR EACH CcbDCaja NO-LOCK WHERE CcbDCaja.CodCia = CcbCDocu.CodCia
                AND CcbDCaja.CodRef = CcbCDocu.CodDoc
                AND CcbDCaja.NroRef = CcbCDocu.NroDoc 
                BY Ccbdcaja.FchDoc:
                x-FchCan = Ccbdcaja.FchDoc.
            END.
            Ccbcdocu.FchCan = x-FchCan.
        END.
        IF FacDocum.TpoDoc = NO THEN DO:   /* ABONOS */
            FOR EACH CCBDMOV NO-LOCK WHERE CCBDMOV.CodCia = CcbCDocu.CodCia
                AND CCBDMOV.CodDoc = CcbCDocu.CodDoc
                AND CCBDMOV.NroDoc = CcbCDocu.NroDoc
                BY Ccbdmov.fchmov:
                x-FchCan = Ccbdmov.FchMov.
            END.
            Ccbcdocu.FchCan = x-FchCan.
        END.
    END.
END.
/* SOLO CUANDO NO ES CANCELADO */
IF Ccbcdocu.FlgEst <> 'C' THEN DO:
    IF AVAILABLE FacDocum THEN DO:
        IF FacDocum.TpoDoc = YES THEN DO:   /* CARGOS */
            Ccbcdocu.FchCan = ?.
        END.
        IF FacDocum.TpoDoc = NO THEN DO:   /* ABONOS */
            Ccbcdocu.FchCan = ?.
        END.
    END.
END.
/* ************************************************************************************ */
/* COMPLETAR DATOS */
/* ************************************************************************************ */
DEF BUFFER B-CDOCU FOR Ccbcdocu.
DEF BUFFER B-DCAJA FOR Ccbdcaja.
DEF BUFFER B-CcbTabla FOR CcbTabla.
/* La división en donde se origina el Comprobante */
IF Ccbcdocu.DivOri = "" THEN Ccbcdocu.DivOri = Ccbcdocu.CodDiv.
CASE Ccbcdocu.coddoc:
    WHEN "N/C" OR WHEN "N/D" THEN DO:
        FIND FIRST B-CDOCU WHERE B-CDOCU.codcia = Ccbcdocu.codcia
            AND B-CDOCU.coddoc = Ccbcdocu.codref
            AND B-CDOCU.nrodoc = Ccbcdocu.nroref
            NO-LOCK NO-ERROR.
        IF AVAILABLE B-CDOCU AND B-CDOCU.DivOri > '' THEN Ccbcdocu.DivOri = B-CDOCU.DivOri.
        IF AVAILABLE B-CDOCU AND B-CDOCU.CodVen > '' THEN Ccbcdocu.CodVen = B-CDOCU.CodVen.
        IF AVAILABLE B-CDOCU AND B-CDOCU.FmaPgo > '' AND TRUE <> (Ccbcdocu.FmaPgo > '')
            THEN Ccbcdocu.FmaPgo = B-CDOCU.FmaPgo.
        IF TRUE <> (Ccbcdocu.glosa > "") THEN DO:
            /* RHC 14/06/2016 Siempre debe tener aunque sea un caracter en la glosa */
            CASE Ccbcdocu.CndCre:
                WHEN "D" THEN DO:   /* Por Devolución de mercaderia */
                    Ccbcdocu.glosa = "Devolución de Mercadería".
                END.
                OTHERWISE DO:
                    Ccbcdocu.glosa = "Por otros conceptos".
                    FIND FIRST Ccbddocu OF Ccbcdocu NO-LOCK NO-ERROR.
                    IF AVAILABLE Ccbddocu THEN DO:
                        FIND B-CcbTabla WHERE B-CcbTabla.CodCia = Ccbcdocu.codcia
                            AND B-CcbTabla.Codigo = Ccbddocu.codmat
                            AND B-CcbTabla.Tabla  = Ccbcdocu.coddoc
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-CcbTabla THEN Ccbcdocu.glosa = B-CcbTabla.Nombre.
                    END.
                END.
            END CASE.
        END.
    END.
    WHEN "A/C" THEN DO:
        FIND FIRST B-CDOCU WHERE B-CDOCU.codcia = Ccbcdocu.codcia
            AND B-CDOCU.coddoc = Ccbcdocu.codref
            AND B-CDOCU.nrodoc = Ccbcdocu.nroref
            NO-LOCK NO-ERROR.
        IF AVAILABLE B-CDOCU AND B-CDOCU.DivOri > '' THEN Ccbcdocu.DivOri = B-CDOCU.DivOri.
        IF AVAILABLE B-CDOCU AND B-CDOCU.CodVen > '' THEN Ccbcdocu.CodVen = B-CDOCU.CodVen.
        IF AVAILABLE B-CDOCU AND B-CDOCU.FmaPgo > '' AND TRUE <> (Ccbcdocu.FmaPgo > '')
            THEN Ccbcdocu.FmaPgo = B-CDOCU.FmaPgo.
    END.
    WHEN "LET" THEN DO:
        FOR EACH B-DCAJA NO-LOCK WHERE B-DCAJA.codcia = Ccbcdocu.codcia
            AND B-DCAJA.coddoc = Ccbcdocu.codref    /* CJE */
            AND B-DCAJA.nrodoc = Ccbcdocu.nroref,
            FIRST B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = B-DCAJA.codcia 
            AND B-CDOCU.coddoc = B-DCAJA.codref
            AND B-CDOCU.nrodoc = B-DCAJA.nroref:
            IF AVAILABLE B-CDOCU AND B-CDOCU.DivOri > '' THEN Ccbcdocu.DivOri = B-CDOCU.DivOri.
            IF AVAILABLE B-CDOCU AND B-CDOCU.CodVen > '' THEN Ccbcdocu.CodVen = B-CDOCU.CodVen.
            IF AVAILABLE B-CDOCU AND B-CDOCU.FmaPgo > '' AND TRUE <> (Ccbcdocu.FmaPgo > '')
                THEN Ccbcdocu.FmaPgo = B-CDOCU.FmaPgo.
            LEAVE.
        END.
    END.
END CASE.
IF Ccbcdocu.NomCli = "" THEN DO:
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = Ccbcdocu.codcli
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN Ccbcdocu.nomcli = gn-clie.nomcli.
END.
IF LOOKUP(Ccbcdocu.Tipo, 'MOSTRADOR,CREDITO') = 0 THEN Ccbcdocu.Tipo = 'CREDITO'.
IF Ccbcdocu.codmon = 2 AND Ccbcdocu.tpocmb = 0 THEN DO:
    FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
    IF AVAILABLE gn-tcmb THEN Ccbcdocu.tpocmb = gn-tcmb.venta.
END.
/* RHC 12/04/17 Caso 61147 */
IF LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL,N/C,N/D,LET,A/R,A/C,BD') > 0 AND Ccbcdocu.sdoact < 0 THEN DO:
    MESSAGE 'Comprobante' Ccbcdocu.coddoc Ccbcdocu.nrodoc 'con saldo negativo' SKIP(1)
        'Proceso abortado' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
/* RHC Caso 66280 26/11/2018 */
IF NEW Ccbcdocu AND Ccbcdocu.CodDoc = "N/C" THEN DO:
    /* Buscamos la referencia */
    FIND B-CDOCU WHERE B-CDOCU.CodCia = Ccbcdocu.CodCia AND
        B-CDOCU.CodDoc = Ccbcdocu.CodRef AND
        B-CDOCU.NroDoc = Ccbcdocu.NroRef NO-LOCK NO-ERROR.
    /* Solo transferencia gratuita */
    IF AVAILABLE B-CDOCU AND LOOKUP(B-CDOCU.FmaPgo, '899,900') > 0 THEN DO:
        Ccbcdocu.FlgEst = "C".
        Ccbcdocu.SdoAct = 0.
        Ccbcdocu.FchCan = TODAY.
    END.
END.

/* Sincronizar con Riqra la linea de credito - verificar las condicion de venta */
IF LOOKUP(ccbcdocu.coddoc,'FAC,BOL,N/C,N/D,LET,A/R,A/C,BD') > 0 AND LOOKUP(ccbcdocu.fmapgo,'000,899,900') > 0 THEN DO:

    DEFINE VAR dImpteAnterior AS DEC INIT 0.
    DEFINE VAR dImpteActual AS DEC INIT 0.

    DEFINE VAR cTabla AS CHAR INIT "CONFIG-RIQRA" NO-UNDO.
    DEFINE VAR cLlave_c1 AS CHAR INIT "SINCRONIZACION" NO-UNDO.
    DEFINE VAR cLlave_c2 AS CHAR INIT "URL" NO-UNDO.
    DEFINE VAR cLlave_c3 AS CHAR INIT "" NO-UNDO.

    /* El contenido de la web */
    define var v-result as char no-undo.
    define var v-response as LONGCHAR no-undo.
    define var v-content as LONGCHAR no-undo.
    DEFINE VAR cURL AS CHAR NO-UNDO.

    IF NEW ccbcdocu THEN DO:
        dImpteActual = ccbcdocu.sdoact.
    END.
    ELSE DO:
        dImpteActual = ccbcdocu.sdoact.
        dImpteActual = oldccbcdocu.sdoact.
    END.

    IF dImpteActual <> 0 AND dImpteAnterior <> dImpteActual THEN DO:
        FIND FIRST vtatabla WHERE vtatabla.codcia = 1 AND vtatabla.tabla = cTabla AND
                                vtatabla.llave_c1 = cllave_c1 AND vtatabla.llave_c2 = cllave_c2 AND
                                vtatabla.llave_c3 = cLlave_c3 NO-LOCK NO-ERROR.

        IF AVAILABLE vtatabla THEN DO:
            cURL = TRIM(vtatabla.llave_c4).
            cURL = cURL + "/customer/registerchangescreditline2synchronizeriqra?codcli=" + TRIM(ccbcdocu.codcli).
    
            RUN lib/http-get-contenido.r(cURL,output v-result,output v-response,output v-content).

        END.
    END.
END.

/* ************************************************************************************ */
/* 06/02/2026 RUTINAS PARA EL SAP */
/* ************************************************************************************ */
/* CONTROL SAP */
&SCOPED-DEFINE SAP_ENABLE YES

&IF {&SAP_ENABLE} &THEN
{sap/interface_sap.i &input_table=ccbcdocu}
&ENDIF
/* ************************************************************************************ */
/* ************************************************************************************ */
/*
IF NEW Ccbcdocu AND LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL') > 0 THEN DO:
    {sap/interface_sap.i &input_table=ccbcdocu}
END.
*/

