TRIGGER PROCEDURE FOR WRITE OF Faccpedi OLD BUFFER OldFaccpedi.

DEF SHARED VAR s-user-id AS CHAR.

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
FOR EACH Facdpedi OF Faccpedi NO-LOCK,
    FIRST Almmmatg OF Facdpedi NO-LOCK,
    FIRST Almtfami OF Almmmatg NO-LOCK WHERE Almtfami.Libre_c01 <> "SV":
    ASSIGN
        Faccpedi.Items = Faccpedi.Items + 1
        Faccpedi.Peso = Faccpedi.Peso + (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.PesMat)
        Faccpedi.Volumen = Faccpedi.Volumen + (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.Libre_d02 / 1000000).
END.
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
IF NEW Faccpedi AND LOOKUP(Faccpedi.CodDoc, 'O/D,OTR,O/M') > 0 THEN DO:
    RUN gn/p-log-status-pedidos (Faccpedi.CodDoc, 
                                 Faccpedi.NroPed, 
                                 'TRCKPED', 
                                 'SE_ALM',
                                 '',
                                 ?).
END.
/* HP_ALM Con Hoja de Picking */
IF OldFaccpedi.FlgSit <> 'TG' AND Faccpedi.FlgSit = 'TG' THEN DO:
    RUN gn/p-log-status-pedidos (Faccpedi.CodDoc, 
                                 Faccpedi.NroPed, 
                                 'TRCKPED', 
                                 'HP_ALM',
                                 '',
                                 ?).
    /* RHC 01/09/2020 Tracking de Pedido Comerical */
    RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                            Faccpedi.CodDiv,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef,
                            s-User-Id,
                            'HP_ALM',
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            '',
                            '').
END.
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
/* PI_ALM Con Picking Inciado */
IF OldFaccpedi.FlgSit <> 'TI' AND Faccpedi.FlgSit = 'TI' THEN DO:
    RUN gn/p-log-status-pedidos (Faccpedi.CodDoc, 
                                 Faccpedi.NroPed, 
                                 'TRCKPED', 
                                 'PI_ALM',
                                 '',
                                 ?).
END.
/* PC_ALM Picado completo */
/* RHC 09/05/2020 PI */
IF OldFaccpedi.FlgSit <> 'PI' AND Faccpedi.FlgSit = 'PI' THEN DO:
    RUN gn/p-log-status-pedidos (Faccpedi.CodDoc, 
                                 Faccpedi.NroPed, 
                                 'TRCKPED', 
                                 'PC_ALM',
                                 '',
                                 ?).
    /* RHC 01/09/2020 Tracking de Pedido Comercial */
    RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                            Faccpedi.CodDiv,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef,
                            s-User-Id,
                            'PK_COM',
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            '',
                            '').
END.
IF OldFaccpedi.FlgSit <> 'P' AND Faccpedi.FlgSit = 'P' THEN DO:
    RUN gn/p-log-status-pedidos (Faccpedi.CodDoc, 
                                 Faccpedi.NroPed, 
                                 'TRCKPED', 
                                 'PC_ALM',
                                 '',
                                 ?).
END.
/* IC_ALM Ingreso a Chequeo */
IF OldFaccpedi.FlgSit <> 'PR' AND Faccpedi.FlgSit = 'PR' THEN DO:
    RUN gn/p-log-status-pedidos (Faccpedi.CodDoc, 
                                 Faccpedi.NroPed, 
                                 'TRCKPED', 
                                 'IC_ALM',
                                 '',
                                 ?).
END.
/* AM_ALM Cola de Chequeo */
IF OldFaccpedi.FlgSit <> 'PT' AND Faccpedi.FlgSit = 'PT' THEN DO:
    RUN gn/p-log-status-pedidos (Faccpedi.CodDoc, 
                                 Faccpedi.NroPed, 
                                 'TRCKPED', 
                                 'AM_ALM',
                                 '',
                                 ?).
END.
/* EC_ALM Proceso de Chequeo */
IF OldFaccpedi.FlgSit <> 'PK' AND Faccpedi.FlgSit = 'PK' THEN DO:
    RUN gn/p-log-status-pedidos (Faccpedi.CodDoc, 
                                 Faccpedi.NroPed, 
                                 'TRCKPED', 
                                 'EC_ALM',
                                 '',
                                 ?).
END.
/* CO_ALM Chequeo Observado */
IF OldFaccpedi.FlgSit <> 'PO' AND Faccpedi.FlgSit = 'PO' THEN DO:
    RUN gn/p-log-status-pedidos (Faccpedi.CodDoc, 
                                 Faccpedi.NroPed, 
                                 'TRCKPED', 
                                 'CO_ALM',
                                 '',
                                 ?).
END.
/* RC_ALM Observacion levantada */
IF OldFaccpedi.FlgSit <> 'POL' AND Faccpedi.FlgSit = 'POL' THEN DO:
    RUN gn/p-log-status-pedidos (Faccpedi.CodDoc, 
                                 Faccpedi.NroPed, 
                                 'TRCKPED', 
                                 'RC_ALM',
                                 '',
                                 ?).
END.
/* EM_ALM Embalado */
IF OldFaccpedi.FlgSit <> 'PE' AND Faccpedi.FlgSit = 'PE' THEN DO:
    RUN gn/p-log-status-pedidos (Faccpedi.CodDoc, 
                                 Faccpedi.NroPed, 
                                 'TRCKPED', 
                                 'EM_ALM',
                                 '',
                                 ?).
END.
/* CH_ALM Cierre de chequeo */
IF OldFaccpedi.FlgSit <> 'PC' AND Faccpedi.FlgSit = 'PC' THEN DO:
    RUN gn/p-log-status-pedidos (Faccpedi.CodDoc, 
                                 Faccpedi.NroPed, 
                                 'TRCKPED', 
                                 'CH_ALM',
                                 '',
                                 ?).
    /* RHC 01/09/2020 Tracking de Pedido Comercial */
    RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                            Faccpedi.CodDiv,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef,
                            s-User-Id,
                            'VODB',
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            '',
                            '').
END.
/* ID_DIS Ingreso a distribución */
IF OldFaccpedi.FlgSit <> 'C' AND Faccpedi.FlgSit = 'C' THEN DO:
    RUN gn/p-log-status-pedidos (Faccpedi.CodDoc, 
                                 Faccpedi.NroPed, 
                                 'TRCKPED', 
                                 'ID_DIS',
                                 '',
                                 ?).
END.
/* 27/04/2023 Con Pre Guia de Remisión Emitida */
IF OldFaccpedi.FlgSit <> 'PGRE' AND Faccpedi.FlgSit = 'PGRE' THEN DO:
    RUN gn/p-log-status-pedidos (Faccpedi.CodDoc, 
                                 Faccpedi.NroPed, 
                                 'TRCKPED', 
                                 'PGRE',
                                 '',
                                 ?).
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


