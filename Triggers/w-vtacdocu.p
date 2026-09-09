TRIGGER PROCEDURE FOR WRITE OF VtaCDocu OLD BUFFER OldVtacdocu.

/* RHC 27/01/2019 ACUMULAMOS */
DEF VAR fPeso AS DECI NO-UNDO.

IF LOOKUP(Vtacdocu.CodPed,'HPK') > 0 THEN DO:
    /* ****************************************************** */
    /* 07/04/2022: Esta parte se duplica en batchs/qreposicionautomatica.p */
    /* ****************************************************** */
    ASSIGN
        Vtacdocu.Libre_d01 = 0      /* Importe */
        Vtacdocu.Items = 0          /* Items */
        Vtacdocu.Peso = 0           /* Peso */
        Vtacdocu.Volumen = 0.       /* Volumen */
    FOR EACH Vtaddocu OF Vtacdocu NO-LOCK,FIRST Almmmatg OF Vtaddocu NO-LOCK:
        fPeso = fPeso + (Vtaddocu.CanPed * Vtaddocu.Factor * Almmmatg.PesMat).
        ASSIGN
            Vtacdocu.Libre_d01 = Vtacdocu.Libre_d01 + Vtaddocu.ImpLin
            Vtacdocu.Items = Vtacdocu.Items + 1
            /*Vtacdocu.Peso = Vtacdocu.Peso + (Vtaddocu.CanPed * Vtaddocu.Factor * Almmmatg.PesMat)*/
            Vtacdocu.Volumen = Vtacdocu.Volumen + (Vtaddocu.CanPed * Vtaddocu.Factor * Almmmatg.Libre_d02 / 1000000).
    END.
    ASSIGN
        Vtacdocu.Peso = ROUND(fPeso,2).
END.
/* SOLO ASIGNADO: Se asigna la tarea */
CASE TRUE:
    WHEN LOOKUP(VtaCDocu.CodPed, 'O/D,O/M,OTR') > 0 THEN DO:
        IF OldVtacdocu.FlgSit = 'T' AND Vtacdocu.FlgSit = 'P' THEN DO:
            RUN gn/p-log-status-pedidos (Vtacdocu.CodPed, 
                                         ENTRY(1,Vtacdocu.NroPed,'-'), 
                                         'TRCKPED', 
                                         'SA_ALM',      /* SOLO ASIGNADOS */
                                         Vtacdocu.UsuarioInicio,
                                         Vtacdocu.FchInicio).
        END.
        /* AVANCE PARCIAL */
        IF OldVtacdocu.FlgSit <> 'C' AND Vtacdocu.FlgSit = 'C' THEN DO:
            RUN gn/p-log-status-pedidos (Vtacdocu.CodPed, 
                                         ENTRY(1,Vtacdocu.NroPed,'-'), 
                                         'TRCKPED', 
                                         'AP_ALM',      /* AVANCE PARCIAL */
                                         Vtacdocu.UsuarioFin,
                                         Vtacdocu.FchFin).
            /* PC_ALM PICADO COMPLETO */
            IF Vtacdocu.Libre_c05 = 'COMPLETADO' THEN
                RUN gn/p-log-status-pedidos (Vtacdocu.CodPed,
                                             ENTRY(1,Vtacdocu.NroPed,'-'),
                                             'TRCKPED',
                                             'PC_ALM',
                                             Vtacdocu.UsuarioInicio,
                                             Vtacdocu.FchInicio).
        END.
    END.
    WHEN LOOKUP(VtaCDocu.CodPed, 'HPK') > 0 THEN DO:
        /* PK_SEM Sin Empezar */
        IF NEW VtaCDocu THEN DO:
            RUN gn/p-log-status-pedidos (Vtacdocu.CodPed,
                                         Vtacdocu.NroPed,
                                         'TRCKHPK',
                                         'PK_SEM',
                                         '',
                                         ?).
        END.
        /* PK_SIMP Impreso */
        IF TRUE <> (OldVtaCDocu.UsrImpOD > '') AND VtaCDocu.UsrImpOD > '' THEN DO:
            RUN gn/p-log-status-pedidos (Vtacdocu.CodPed,
                                         Vtacdocu.NroPed,
                                         'TRCKHPK',
                                         'PK_SIMP',
                                         Vtacdocu.UsrImpOD,
                                         Vtacdocu.FchImpOD).
        END.
        /* PK_ASG Picking Asignado */
        IF (OldVtacdocu.flgsit <> 'TI' AND Vtacdocu.flgsit = 'TI') OR
            (OldVtacdocu.flgsit = 'TI' AND Vtacdocu.flgsit = 'TI' AND 
             OldVtacdocu.usrsac <> Vtacdocu.usrsac)
            THEN DO:
            RUN gn/p-log-status-pedidos (Vtacdocu.CodPed,
                                         Vtacdocu.NroPed,
                                         'TRCKHPK',
                                         'PK_ASG',
                                         '',
                                         ?).
        END.
        /* PK_INI Picking Iniciado */
        IF OldVtacdocu.flgsit <> 'TP' AND Vtacdocu.flgsit = 'TP' THEN DO:
            RUN gn/p-log-status-pedidos (Vtacdocu.CodPed,
                                         Vtacdocu.NroPed,
                                         'TRCKHPK',
                                         'PK_INI',
                                         '',
                                         ?).
        END.
        /* PK_OBS Picking Observado */
        IF OldVtacdocu.flgsit <> 'TX' AND Vtacdocu.flgsit = 'TX' THEN DO:
            RUN gn/p-log-status-pedidos (Vtacdocu.CodPed,
                                         Vtacdocu.NroPed,
                                         'TRCKHPK',
                                         'PK_OBS',
                                         '',
                                         ?).
        END.
        /* PK_COM Picking Completo */
        IF OldVtacdocu.flgsit <> 'P' AND Vtacdocu.flgsit = 'P' THEN DO:
            RUN gn/p-log-status-pedidos (Vtacdocu.CodPed,
                                         Vtacdocu.NroPed,
                                         'TRCKHPK',
                                         'PK_COM',
                                         '',
                                         ?).
        END.
        /* CK_IN En Chequeo */
/*         IF (OldVtacdocu.flgest = 'P' AND OldVtacdocu.flgsit = 'P') AND */
/*             Vtacdocu.flgsit = 'PR' THEN DO:                            */
        IF OldVtacdocu.flgsit <> 'PR' AND Vtacdocu.flgsit = 'PR' THEN DO:
            RUN gn/p-log-status-pedidos (Vtacdocu.CodPed,
                                         Vtacdocu.NroPed,
                                         'TRCKHPK',
                                         'CK_IN',
                                         '',
                                         ?).
        END.
        /* CK_AS Asignado a mesa */
/*         IF (OldVtacdocu.flgest = 'P' AND OldVtacdocu.flgsit = 'PR') AND */
/*             Vtacdocu.flgsit = 'PT' THEN DO:                             */
        IF OldVtacdocu.flgest <> 'PT' AND Vtacdocu.flgsit = 'PT' THEN DO:
            RUN gn/p-log-status-pedidos (Vtacdocu.CodPed,
                                         Vtacdocu.NroPed,
                                         'TRCKHPK',
                                         'CK_AS',
                                         '',
                                         ?).
        END.
        /* CK_CI Chequeo Iniciado */
        IF OldVtacdocu.flgsit <> "PK" AND Vtacdocu.flgsit = 'PK' THEN DO:
            RUN gn/p-log-status-pedidos (Vtacdocu.CodPed,
                                         Vtacdocu.NroPed,
                                         'TRCKHPK',
                                         'CK_CI',
                                         '',
                                         ?).
        END.
        /* CK_CO Chequeo Observado */
        IF OldVtacdocu.flgsit <> "PO" AND Vtacdocu.flgsit = 'PO' THEN DO:
            RUN gn/p-log-status-pedidos (Vtacdocu.CodPed,
                                         Vtacdocu.NroPed,
                                         'TRCKHPK',
                                         'CK_CO',
                                         '',
                                         ?).
        END.
        /* CK_EM Embalado Especial */
        IF OldVtacdocu.flgsit <> "PE" AND Vtacdocu.flgsit = 'PE' THEN DO:
            RUN gn/p-log-status-pedidos (Vtacdocu.CodPed,
                                         Vtacdocu.NroPed,
                                         'TRCKHPK',
                                         'CK_EM',
                                         '',
                                         ?).
        END.
        /* CK_CH Chequeado */
        IF OldVtacdocu.flgsit <> "PC" AND Vtacdocu.flgsit = 'PC' THEN DO:
            RUN gn/p-log-status-pedidos (Vtacdocu.CodPed,
                                         Vtacdocu.NroPed,
                                         'TRCKHPK',
                                         'CK_CH',
                                         '',
                                         ?).
        END.
        /* CK_DI En Distribución */
        IF OldVtacdocu.flgsit <> "C" AND Vtacdocu.flgsit = 'C' THEN DO:
            RUN gn/p-log-status-pedidos (Vtacdocu.CodPed,
                                         Vtacdocu.NroPed,
                                         'TRCKHPK',
                                         'CK_DI',
                                         '',
                                         ?).
        END.
    END.
END CASE.

