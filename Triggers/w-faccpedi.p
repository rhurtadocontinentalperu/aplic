TRIGGER PROCEDURE FOR WRITE OF Faccpedi OLD BUFFER OldFaccpedi.

DEF NEW SHARED VAR s-codcia AS INTE INIT 1.
DEF NEW SHARED VAR s-user-id AS CHAR INIT "TRIGGER".

DEF VAR cl-codcia AS INT INIT 000.
DEF VAR x-Clave AS CHAR INIT "2" NO-UNDO.

IF LOOKUP(Faccpedi.CodDoc, 'O/D,OTR,O/M') > 0 THEN DO:
    IF OldFaccpedi.Libre_f01 <> Faccpedi.Libre_f01 THEN DO:
        ASSIGN Faccpedi.fchchq = Faccpedi.Libre_f01.
    END.
END.

/* ************************************************************** */
/* COMPLETAR DATOS */
IF Faccpedi.DivDes = "" THEN Faccpedi.DivDes = Faccpedi.CodDiv.
IF Faccpedi.FchVen = ? THEN Faccpedi.FchVen = TODAY.

/* ******************************************** */
/* RHC 28/04/2020 NO tomar en cuenta los fletes */
/* ******************************************** */
ASSIGN
    Faccpedi.Items = 0          /* Items */
    Faccpedi.Peso = 0           /* Peso */
    Faccpedi.Volumen = 0.       /* Volumen */

DEF VAR fPeso AS DECI NO-UNDO.

FOR EACH Facdpedi OF Faccpedi NO-LOCK,
    FIRST Almmmatg OF Facdpedi NO-LOCK,
    FIRST Almtfami OF Almmmatg NO-LOCK WHERE Almtfami.Libre_c01 <> "SV":
    fPeso = fPeso + (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.PesMat).
    ASSIGN
        Faccpedi.Items = Faccpedi.Items + 1
        /*Faccpedi.Peso = Faccpedi.Peso + (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.PesMat)*/
        Faccpedi.Volumen = Faccpedi.Volumen + (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.Libre_d02 / 1000000).
END.
ASSIGN
    Faccpedi.Peso = ROUND(fPeso,2).

/* BULTOS */
ASSIGN
    Faccpedi.AcuBon[9] = 0.     /* Bultos */
FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = Faccpedi.codcia AND
    CcbCBult.CodDiv = Faccpedi.divdes AND   /* OJO */
    CcbCBult.CodDoc = Faccpedi.coddoc AND
    CcbCBult.NroDoc = Faccpedi.nroped:
    Faccpedi.AcuBon[9] = Faccpedi.AcuBon[9] + CcbCBult.Bultos.
END.
IF Faccpedi.AcuBon[9] = 0 THEN DO:
    FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = Faccpedi.codcia AND
        CcbCBult.CodDoc = Faccpedi.coddoc AND
        CcbCBult.NroDoc = Faccpedi.nroped:
        Faccpedi.AcuBon[9] = Faccpedi.AcuBon[9] + CcbCBult.Bultos.
    END.
END.
/* IMPORTES en S/ */
DEF VAR LocalTC AS DECI NO-UNDO.
LocalTC = Faccpedi.TpoCmb.
FIND LAST Gn-tccja WHERE Gn-tccja.fecha <= Faccpedi.FchPed NO-LOCK NO-ERROR.
IF AVAILABLE Gn-tccja THEN LocalTC = Gn-tccja.venta.
ASSIGN
    Faccpedi.AcuBon[8] = Faccpedi.ImpTot * (IF Faccpedi.CodMon = 2 THEN LocalTC ELSE 1).   /* Importes */
IF Faccpedi.CodDoc = "OTR" THEN DO:
    ASSIGN
        Faccpedi.AcuBon[8] = 0.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
        ASSIGN 
            Faccpedi.AcuBon[8] = Faccpedi.AcuBon[8] + 
                                (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.CtoTot) * 
                                (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1).
    END.
END.
/* ************************************************************** */

/* LISTA DE PRECIOS */
IF LOOKUP(Faccpedi.CodDoc, 'COT,P/M') > 0 THEN DO:
    IF TRUE <> (Faccpedi.Lista_de_Precios > '') THEN DO:
        IF Faccpedi.CodDoc = 'COT'  AND Faccpedi.Libre_c01 > ''
            THEN Faccpedi.Lista_de_Precios = Faccpedi.Libre_c01.
        IF Faccpedi.CodDoc = 'P/M' 
            THEN Faccpedi.Lista_de_Precios = Faccpedi.CodDiv.
        IF TRUE <> (Faccpedi.Lista_de_Precios > '') 
            THEN Faccpedi.Lista_de_Precios = Faccpedi.CodDiv.
    END.
END.

IF Faccpedi.coddoc = "COT" THEN DO:
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = Faccpedi.codcli
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN DO:
        ASSIGN
            FacCPedi.FaxCli = SUBSTRING(TRIM(gn-clie.clfcli) + "00",1,2) +
                            SUBSTRING(TRIM(gn-clie.clfcli2) + "00",1,2).
        IF Faccpedi.coddiv = '00018' THEN DO:    /* Provincias */
            FOR EACH VtaTabla WHERE VtaTabla.CodCia = Faccpedi.codcia
                AND VtaTabla.Tabla = "PL1":
                IF VtaTabla.Llave_c1 = Faccpedi.codcli THEN DO:
                    x-Clave = "1".
                    LEAVE.
                END.
            END.
            Faccpedi.FaxCli = Faccpedi.FaxCli + x-Clave.
        END.
        FOR EACH Facdpedi OF Faccpedi NO-LOCK:
            IF Facdpedi.codaux = "*" THEN DO:
                Faccpedi.FaxCli = Faccpedi.FaxCli + Facdpedi.CodAux.
                LEAVE.
            END.
        END.
    END.
END.
/* ************************************************************************ */
/* RHC 19/03/2021 Control de Descuentos */
/* ************************************************************************ */
/* IF Faccpedi.CodDoc = "COT" THEN DO:                         */
/*     FIND VtaCDctos WHERE VtaCDctos.CodCia = Faccpedi.CodCia */
/*         AND VtaCDctos.CodDiv = Faccpedi.CodDiv              */
/*         AND VtaCDctos.CodPed = Faccpedi.CodDoc              */
/*         AND VtaCDctos.NroPed = Faccpedi.NroPed              */
/*         NO-LOCK NO-ERROR.                                   */
/*     IF NOT AVAILABLE VtaCDctos THEN DO:                     */
/*         CREATE VtaCDctos.                                   */
/*         ASSIGN                                              */
/*             VtaCDctos.CodCia = Faccpedi.CodCia              */
/*             VtaCDctos.CodDiv = Faccpedi.CodDiv              */
/*             VtaCDctos.CodPed = Faccpedi.CodDoc              */
/*             VtaCDctos.NroPed = Faccpedi.NroPed              */
/*             NO-ERROR.                                       */
/*         IF ERROR-STATUS:ERROR = YES THEN RETURN ERROR.      */
/*         RELEASE VtaCDctos.                                  */
/*     END.                                                    */
/* END.                                                        */


/* ************************************************************************ */
/* RHC 15/10/2018 STATUS DE PEDIDOS: Renato Lira */
/* ************************************************************************ */
/* SE_ALM Nuevo Documento */
/* IF NEW Faccpedi AND LOOKUP(Faccpedi.CodDoc, 'O/D,OTR,O/M') > 0 THEN DO: */
/*     RUN gn/p-log-status-pedidos (Faccpedi.CodDoc,                       */
/*                                  Faccpedi.NroPed,                       */
/*                                  'TRCKPED',                             */
/*                                  'SE_ALM',                              */
/*                                  '',                                    */
/*                                  ?).                                    */
/* END.                                                                    */
/* SI_ALM Primera impresión */
IF OldFaccpedi.FlgImpOD = NO AND Faccpedi.FlgImpOD = YES THEN DO:
    IF FaccPedi.UsrImpOD > '' AND Faccpedi.FchImpOD <> ?
        THEN RUN gn/p-log-status-pedidos (Faccpedi.CodDoc, 
                                          Faccpedi.NroPed, 
                                          'TRCKPED', 
                                          'SI_ALM',
                                          Faccpedi.UsrImpOD,
                                          Faccpedi.FchImpOD).
END.

/* GR_DIS Guiado/Facturado */
IF OldFaccpedi.FlgEst = 'P' AND Faccpedi.FlgEst = 'C' THEN DO:
    RUN gn/p-log-status-pedidos (Faccpedi.CodDoc, 
                                 Faccpedi.NroPed, 
                                 'TRCKPED', 
                                 'GR_DIS',
                                 '',
                                 ?).
END.

{TRIGGERS/i-faccpedi.i}


/* Stock Comprometido */
/* 10/10/2024 */
/* IF Faccpedi.FlgEst = "A" THEN DO:                                                 */
/*     FOR EACH Facdpedi OF Faccpedi NO-LOCK:                                        */
/*         RUN web/p-ctrl-sku-disp-riqra (INPUT "FacDPedi",                          */
/*                                        INPUT (Facdpedi.CodDoc + ":" +             */
/*                                               Facdpedi.NroPed + ":" +             */
/*                                               Facdpedi.CodMat + ":" +             */
/*                                               Facdpedi.AlmDes),                   */
/*                                        INPUT (Facdpedi.CanPed * Facdpedi.Factor), */
/*                                        INPUT 0,                                   */
/*                                        "D"                                        */
/*                                        ).                                         */
/*     END.                                                                          */
/* END.                                                                              */

/* 
    Sincronizacion con Riqra, NO contado 
    Queda pendiente para que, solo actualize la linea de credito
    para pedidos comerciales NO RIQRA
*/


/* 11/08/2025: Bloqueado 
IF Faccpedi.CodDoc = "COT" AND LOOKUP(Faccpedi.fmapgo,'000,899,900') = 0 THEN DO:
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

    IF NEW Faccpedi THEN DO:
        dImpteActual = faccpedi.totalprecioventa.
    END.
    ELSE DO:
        dImpteActual = faccpedi.totalprecioventa.
        dImpteActual = OldFaccpedi.totalprecioventa.
    END.

    IF dImpteActual <> 0 AND dImpteAnterior <> dImpteActual THEN DO:
        FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = cTabla AND
                                vtatabla.llave_c1 = cllave_c1 AND vtatabla.llave_c2 = cllave_c2 AND
                                vtatabla.llave_c3 = cLlave_c3 NO-LOCK NO-ERROR.

        IF AVAILABLE vtatabla THEN DO:
            cURL = TRIM(vtatabla.llave_c4).
            cURL = cURL + "/customer/registerchangescreditline2synchronizeriqra?codcli=" + TRIM(faccpedi.codcli).
    
            RUN lib/http-get-contenido.r(cURL,output v-result,output v-response,output v-content).
        END.
    END.
END.
**** */

/* ************************************************************************************ */
/* 06/02/2026 RUTINAS PARA EL SAP */
/* ************************************************************************************ */
/* CONTROL SAP */
&SCOPED-DEFINE SAP_ENABLE YES

&IF {&SAP_ENABLE} &THEN
{sap/interface_sap.i &input_table=faccpedi}
&ENDIF
/* ************************************************************************************ */
/* ************************************************************************************ */

/*
CASE Faccpedi.coddoc:
    WHEN "COT" THEN DO:
        IF OldFaccpedi.FlgEst <> "P" AND Faccpedi.FlgEst = "P" THEN DO:
            {sap/interface_sap.i &input_table=faccpedi}
        END.
    END.
    WHEN "PED" THEN DO:
        IF OldFaccpedi.FlgEst <> "C" AND Faccpedi.FlgEst = "C" THEN DO:
            {sap/interface_sap.i &input_table=faccpedi}
        END.
    END.
    WHEN "O/D" THEN DO:
        IF NEW Faccpedi AND Faccpedi.flgest BEGINS "P" THEN DO:
            {sap/interface_sap.i &input_table=faccpedi}
        END.
    END.
END CASE.
*/

