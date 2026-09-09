TRIGGER PROCEDURE FOR WRITE OF Di-RutaC OLD BUFFER OldDi-RutaC.

DEF SHARED VAR s-user-id AS CHAR.

/* ************************************************************************************* */
/* CONTROL DE TRACKING DEL PEDIDO COMERCIAL */
/* ************************************************************************************* */
/*  Salida del vehículo */
IF OldDi-RutaC.FlgEst <> "PS" AND Di-RutaC.FlgEst = "PS" THEN DO:
    FOR EACH Di-RutaD OF Di-RutaC NO-LOCK:
        FIND Ccbcdocu WHERE Ccbcdocu.codcia = di-rutad.codcia
            AND Ccbcdocu.coddoc = di-rutad.codref
            AND Ccbcdocu.nrodoc = di-rutad.nroref
            NO-LOCK NO-ERROR NO-WAIT.
        IF AVAILABLE Ccbcdocu 
            THEN RUN vtagn/pTracking-04 (Di-RutaD.CodCia,
                                         Di-RutaD.CodDiv,
                                         Ccbcdocu.CodPed,
                                         Ccbcdocu.NroPed,
                                         s-User-Id,
                                         'TR_SAL',
                                         'P',
                                         DATETIME(TODAY, MTIME),
                                         DATETIME(TODAY, MTIME),
                                         Di-RutaD.CodRef,
                                         Di-RutaD.NroRef,
                                         Di-RutaD.CodDoc + '|' + Di-RutaD.NroDoc,
                                         Di-RutaD.FlgEst + '|' + Di-RutaD.FlgEstDet).
    END.
END.
/* Retorno del vehículo */
IF OldDi-RutaC.FlgEst <> "PR" AND Di-RutaC.FlgEst = "PR" THEN DO:
    FOR EACH Di-RutaD OF Di-RutaC NO-LOCK:
        FIND Ccbcdocu WHERE Ccbcdocu.codcia = di-rutad.codcia
            AND Ccbcdocu.coddoc = di-rutad.codref
            AND Ccbcdocu.nrodoc = di-rutad.nroref
            NO-LOCK NO-ERROR NO-WAIT.
        IF AVAILABLE Ccbcdocu 
            THEN RUN vtagn/pTracking-04 (Di-RutaD.CodCia,
                                         Di-RutaD.CodDiv,
                                         Ccbcdocu.CodPed,
                                         Ccbcdocu.NroPed,
                                         s-User-Id,
                                         'TR_RET',
                                         'P',
                                         DATETIME(TODAY, MTIME),
                                         DATETIME(TODAY, MTIME),
                                         Di-RutaD.CodRef,
                                         Di-RutaD.NroRef,
                                         Di-RutaD.CodDoc + '|' + Di-RutaD.NroDoc,
                                         Di-RutaD.FlgEst + '|' + Di-RutaD.FlgEstDet).
    END.
END.
/* *********************************** */
/* RHC 10.05.2011 Hoja de Ruta Cerrada */
/* *********************************** */
DEF VAR LocalLlave AS CHAR NO-UNDO.
IF OldDi-RutaC.FlgEst <> "C" AND Di-RutaC.FlgEst = "C" THEN DO:
    /* *********************************************** */
    /* ACUMULA INFORMACION DE FLETE POR PESO Y VOLUMEN */
    /* *********************************************** */
    DEF VAR LocalProcedure AS HANDLE NO-UNDO.
    DEF VAR pMensaje AS CHAR NO-UNDO.
    /* 23/02/2023: Peso y volumen solicitado por F.Oblitas */
    DEF VAR pPeso AS DECI NO-UNDO.
    DEF VAR pVolumen AS DECI NO-UNDO.

    RUN logis/logis-librerias PERSISTENT SET LocalProcedure.
    RUN FLETE_Resumen-HR IN LocalProcedure (INPUT Di-RutaC.CodDiv,
                                            INPUT Di-RutaC.CodDoc,
                                            INPUT Di-RutaC.NroDoc,
                                            /*OUTPUT pPeso,
                                            OUTPUT pVolumen,*/
                                            OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN ERROR.
    END.
    DELETE PROCEDURE LocalProcedure.
/*     ASSIGN                             */
/*         DI-RutaC.Libre_d01 = pPeso     */
/*         DI-RutaC.Libre_d02 = pVolumen. */
    /* *********************************************** */
    /* *********************************************** */
    FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
        FIRST Ccbcdocu WHERE Ccbcdocu.codcia = di-rutad.codcia
            AND Ccbcdocu.coddoc = di-rutad.codref
            AND Ccbcdocu.nrodoc = di-rutad.nroref
            NO-LOCK:
        /* H/R Cerrada */
        RUN vtagn/pTracking-04 (Di-RutaD.CodCia,
                                     Di-RutaD.CodDiv,
                                     Ccbcdocu.CodPed,
                                     Ccbcdocu.NroPed,
                                     s-User-Id,
                                     'CHR',
                                     'P',
                                     DATETIME(TODAY, MTIME),
                                     DATETIME(TODAY, MTIME),
                                     Di-RutaD.CodRef,
                                     Di-RutaD.NroRef,
                                     Di-RutaD.CodDoc + '|' + Di-RutaD.NroDoc,
                                     Di-RutaD.FlgEst + '|' + Di-RutaD.FlgEstDet).
        LocalLlave = ''.
        CASE Di-RutaD.FlgEst:
            WHEN "T" THEN DO:   /* Dejado en Tienda */
                LocalLlave = 'HR_DT'.
            END.
            WHEN "D" THEN DO:   /* Devolución Parcial */
                LocalLlave = 'HR_DVP'.
            END.
            WHEN "N" THEN DO:   /* No Entregado */
                LocalLlave = 'HR_RE'.   /* Reprogramado */
                IF Di-RutaD.Libre_c02 = "A" THEN LocalLlave = 'HR_DVT'.  /* Devolución Total */
            END.
        END CASE.
        IF LocalLlave > '' THEN DO:
            RUN vtagn/pTracking-04 (Di-RutaD.CodCia,
                                    Di-RutaD.CodDiv,
                                    Ccbcdocu.CodPed,
                                    Ccbcdocu.NroPed,
                                    s-User-Id,
                                    LocalLlave,
                                    'P',
                                    DATETIME(TODAY, MTIME),
                                    DATETIME(TODAY, MTIME),
                                    Di-RutaD.CodRef,
                                    Di-RutaD.NroRef,
                                    Di-RutaD.CodDoc + '|' + Di-RutaD.NroDoc,
                                    Di-RutaD.FlgEst + '|' + Di-RutaD.FlgEstDet).
        END.
    END.
END.
/* ************************************************************************************* */
/* ************************************************************************************* */
/* RHC 15/10/2018 STATUS DE PEDIDOS: Renato Lira */
/* HR_DIS ConHoja de Ruta: Cuando la H/R es Confirmada */
IF OldDi-RutaC.Libre_l01 = NO AND Di-RutaC.Libre_l01 = YES THEN DO:
    /* Barremos la O/D y O/M para el tracking */
    DEF BUFFER b-Faccpedi FOR Faccpedi.
    DEF BUFFER b-Di-RutaD FOR Di-RutaD.
    DEF BUFFER b-Di-RutaG FOR Di-RutaG.
    DEF BUFFER b-Ccbcdocu FOR Ccbcdocu.
    DEF BUFFER b-Almcmov  FOR Almcmov.

    FOR EACH b-Di-RutaD OF Di-RutaC NO-LOCK,
        EACH b-Ccbcdocu NO-LOCK WHERE b-Ccbcdocu.codcia = b-Di-RutaD.codcia AND
        b-Ccbcdocu.coddoc = b-Di-RutaD.codref AND
        b-Ccbcdocu.nrodoc = b-Di-RutaD.nroref,
        EACH b-Faccpedi NO-LOCK WHERE b-Faccpedi.codcia = b-Ccbcdocu.codcia AND
        b-Faccpedi.coddoc = b-Ccbcdocu.libre_c01 AND
        b-Faccpedi.nroped = b-Ccbcdocu.libre_c02
        BREAK BY b-Faccpedi.CodDoc BY b-Faccpedi.NroPed:
        IF FIRST-OF(b-Faccpedi.CodDoc) OR FIRST-OF(b-Faccpedi.NroPed) 
            THEN DO:
            RUN gn/p-log-status-pedidos (b-Faccpedi.CodDoc,     /* O/D */
                                         b-Faccpedi.NroPed, 
                                         'TRCKPED', 
                                         'HR_DIS',
                                         '',
                                         ?).
        END.
    END.
    /* Barremos la OTR para el tracking */
    FOR EACH b-Di-RutaG OF Di-RutaC NO-LOCK,
        EACH b-Almcmov NO-LOCK WHERE b-Almcmov.codcia = b-Di-RutaG.codcia AND
        b-Almcmov.codalm = b-Di-RutaG.codalm AND
        b-Almcmov.tipmov = b-Di-RutaG.tipmov AND
        b-Almcmov.codmov = b-Di-RutaG.codmov AND 
        b-Almcmov.nroser = b-Di-RutaG.serref AND
        b-Almcmov.nrodoc = b-Di-RutaG.nroref,
        EACH b-Faccpedi NO-LOCK WHERE b-Faccpedi.codcia = b-Almcmov.codcia AND
        b-Faccpedi.coddoc = b-Almcmov.codref AND
        b-Faccpedi.nroped = b-Almcmov.nroref
        BREAK BY b-Faccpedi.CodDoc BY b-Faccpedi.NroPed:
        IF FIRST-OF(b-Faccpedi.CodDoc) OR FIRST-OF(b-Faccpedi.NroPed) 
            THEN DO:
            RUN gn/p-log-status-pedidos (b-Faccpedi.CodDoc,     /* OTR */
                                         b-Faccpedi.NroPed, 
                                         'TRCKPED', 
                                         'HR_DIS',
                                         '',
                                         ?).
        END.
    END.
END.

CREATE LogTabla.
ASSIGN
    logtabla.codcia = Di-RutaC.codcia
    logtabla.Dia = TODAY
    logtabla.Evento = 'WRITE'
    logtabla.Hora = STRING(TIME, 'HH:MM')
    logtabla.Tabla = 'Di-RutaC'
    logtabla.Usuario = s-user-id
    logtabla.ValorLlave = STRING(Di-RutaC.coddiv, 'x(5)') + '|' +
                        STRING(Di-RutaC.coddoc, 'x(3)') + '|' +
                        STRING(Di-RutaC.nrodoc, 'x(12)').
RELEASE LogTabla.

/* RHC 25/09/2019 Control de Cierre de H/R */
DEF VAR pCodigo AS CHAR NO-UNDO.

DEF VAR pClave AS CHAR INIT 'TRCKHR' NO-UNDO.

CASE TRUE:
    WHEN DI-RutaC.CodDoc = "H/R" THEN DO:
        IF OldDi-RutaC.FlgCie <> Di-RutaC.FlgCie THEN DO:
            CASE DI-RutaC.FlgCie:
                WHEN "C1" THEN pCodigo = "HR_Cierre_1".
                WHEN "C2" THEN pCodigo = "HR_Cierre_2".
                WHEN ""   THEN pCodigo = "HR_Rechazo_2".
            END CASE.
        END.
        IF pCodigo > '' THEN DO:
            CREATE LogTrkDocs.
            ASSIGN
                LogTrkDocs.CodCia = DI-RutaC.CodCia
                LogTrkDocs.Clave = pClave
                LogTrkDocs.Codigo = pCodigo
                /*LogTrkDocs.Orden = pOrden*/
                LogTrkDocs.CodDoc = DI-RutaC.CodDoc
                LogTrkDocs.NroDoc = DI-RutaC.NroDoc
                LogTrkDocs.CodDiv = DI-RutaC.CodDiv
                LogTrkDocs.Fecha = NOW
                LogTrkDocs.Usuario = s-user-id.
            RELEASE LogTrkDocs.
        END.
    END.
END CASE.
