TRIGGER PROCEDURE FOR WRITE OF Di-RutaD OLD BUFFER OldDi-RutaD.

DEF SHARED VAR s-user-id AS CHAR.

/* 15/12/2022: Evitar duplicidad de registros */
DEF VAR LocalCodCia AS INTE NO-UNDO.
DEF VAR LocalCodDiv AS CHAR NO-UNDO.
DEF VAR LocalCodDoc AS CHAR NO-UNDO.
DEF VAR LocalNroDoc AS CHAR NO-UNDO.
DEF VAR LocalCodRef AS CHAR NO-UNDO.
DEF VAR LocalNroRef AS CHAR NO-UNDO.
DEF VAR LocalRowid AS ROWID NO-UNDO.
DEF BUFFER LocalBuffRutaD FOR Di-RutaD.
DEF BUFFER LocalBufferGR FOR Ccbcdocu.
DEF BUFFER LocalBufferOD FOR Faccpedi.

IF Di-RutaD.CodDoc = 'PHR' AND LOOKUP(Di-RutaD.CodRef,"O/D,O/M,OTR") > 0 THEN DO:
    ASSIGN
        LocalCodCia = Di-RutaD.codcia
        LocalCodDiv = Di-RutaD.coddiv
        LocalCodDoc = Di-RutaD.coddoc
        LocalNroDoc = Di-RutaD.nrodoc
        LocalCodRef = Di-RutaD.codref
        LocalNroRef = Di-RutaD.nroref
        LocalRowid = ROWID(Di-RutaD).
    /* 1ro. duplicado en el mismo registro */
    FIND FIRST LocalBuffRutad WHERE LocalBuffRutad.codcia = Localcodcia AND
        LocalBuffRutad.coddiv = Localcoddiv AND
        LocalBuffRutad.coddoc = Localcoddoc AND
        LocalBuffRutad.nrodoc = Localnrodoc AND
        LocalBuffRutad.codref = Localcodref AND
        LocalBuffRutad.nroref = Localnroref AND
        ROWID(LocalBuffRutad) <> Localrowid
        NO-LOCK NO-ERROR.
    IF AVAILABLE LocalBuffRutad THEN DO:
        MESSAGE 'Registro' LocalCodRef LocalNroRef 'DUPLICADO' SKIP
            'en la' LocalCodDoc LocalNroDoc
            VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    /* 2do. duplicado en otro registro */
    /* F. Oblitas: verificar si está por entregar o entregado */
    /* barremos histórico y depende del último estado */
    DEF VAR LocalFlgEst AS CHAR NO-UNDO.
    DEF VAR LocalNroHR  AS CHAR NO-UNDO.

/*     FIND LocalBufferOD WHERE LocalBufferOD.codcia = Di-RutaD.codcia AND                         */
/*         LocalBufferOD.coddoc = Di-RutaD.codref AND                                              */
/*         LocalBufferOD.nroped = Di-RutaD.nroref AND                                              */
/*         LocalBufferOD.flgest <> "A"                                                             */
/*         NO-LOCK NO-ERROR.                                                                       */
/*     IF AVAILABLE LocalBufferOD THEN DO:                                                         */
/*         /* Barremos cada G/R referenciada a la O/D */                                           */
/*         FOR EACH LocalBufferGR NO-LOCK WHERE LocalBufferGR.codcia = Di-RutaD.CodCia AND         */
/*             LocalBufferGR.coddoc = "G/R" AND                                                    */
/*             LocalBufferGR.codped = LocalBufferOD.codref AND                                     */
/*             LocalBufferGR.nroped = LocalBufferOD.nroref AND                                     */
/*             LocalBufferGR.flgest <> "A":                                                        */
/*             LocalFlgEst = "".                                                                   */
/*             LocalNroHR  = "".                                                                   */
/*             /* Por cada G/R barremos su histórico */                                            */
/*             FOR EACH LocalBuffRutad NO-LOCK WHERE LocalBuffRutad.codcia = Di-RutaD.codcia AND   */
/*                 LocalBuffRutad.coddoc = "H/R" AND                                               */
/*                 LocalBuffRutad.codref = LocalBufferGR.coddoc AND                                */
/*                 LocalBuffRutad.nroref = LocalBufferGR.nrodoc AND                                */
/*                 LocalBuffRutad.coddiv = Localcoddiv AND                                         */
/*                 CAN-FIND(FIRST Di-RutaC OF LocalBuffRutad WHERE Di-RutaC.FlgEst <> "A" NO-LOCK) */
/*                 BY LocalBuffRutad.NroDoc:                                                       */
/*                 LocalFlgEst = LocalBuffRutad.FlgEst.                                            */
/*                 LocalNroHR  = LocalBuffRutad.NroDoc.                                            */
/*             END.                                                                                */
/*             IF LocalFlgEst > '' AND LOOKUP(LocalFlgEst, "P,E,C,T") > 0 THEN DO:                 */
/*                 MESSAGE 'Registro' LocalCodRef LocalNroRef SKIP                                 */
/*                     'Documento Relacionado:' LocalBufferGR.CodDoc LocalBufferGR.NroDoc SKIP     */
/*                     'YA REGISTRADO EN LA H/R' LocalNroHR 'como ENTREGADO o POR ENTREGAR'        */
/*                     VIEW-AS ALERT-BOX ERROR.                                                    */
/*                 RETURN ERROR.                                                                   */
/*             END.                                                                                */
/*         END.                                                                                    */
/*     END.                                                                                        */
    /*
            WHEN 'P' OR WHEN 'E' THEN cEstado = 'Por Entregar'.
            WHEN 'C' THEN cEstado = 'Entregado'.
            WHEN 'D' THEN cEstado = 'Devolucion Parcial'.
            WHEN 'X' THEN cEstado = 'Devolucion Total'.
            WHEN 'N' THEN cEstado = 'No Entregado'.
            WHEN 'R' THEN cEstado = 'Error de Documento'.
            WHEN 'NR' THEN cEstado = 'No Recibido'.
            WHEN 'T' THEN cEstado = 'Dejado en Tienda'.
    */    
END.

/* RHC 27/01/2019 ACUMULAMOS */
IF Di-RutaD.CodDoc = 'PHR' AND LOOKUP(Di-RutaD.CodRef,"O/D,O/M,OTR") > 0 THEN DO:
    ASSIGN
        DI-RutaD.ImpCob = 0         /* Volumen */
        DI-RutaD.Libre_d01 = 0      /* Peso */
        DI-RutaD.Libre_d02 = 0.     /* Importe en S/ */
    /* RHC 17/04/2020 Los datos ya vienen calculados,  revisar triggers/w-faccpedi.p */
    FIND Faccpedi WHERE Faccpedi.codcia = Di-Rutad.codcia AND
        Faccpedi.coddoc = Di-Rutad.codref AND
        Faccpedi.nroped = Di-Rutad.nroref NO-LOCK NO-ERROR.
    IF AVAILABLE Faccpedi THEN DO:
        DI-RutaD.ImpCob = Faccpedi.Volumen.
        DI-RutaD.Libre_d01 = Faccpedi.Peso.
        DI-RutaD.Libre_d02 = Faccpedi.AcuBon[8].
    END.
/*     FOR EACH Facdpedi NO-LOCK WHERE Facdpedi.codcia = Di-rutad.codcia                                                           */
/*         AND Facdpedi.coddoc = Di-rutad.codref                                                                                   */
/*         AND Facdpedi.nroped = Di-rutad.nroref,                                                                                  */
/*         FIRST Faccpedi OF Faccpedi NO-LOCK,                                                                                     */
/*         FIRST Almmmatg OF Facdpedi NO-LOCK:                                                                                     */
/*         ASSIGN                                                                                                                  */
/*             Di-rutad.ImpCob = Di-rutad.ImpCob + (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.Libre_d02 / 1000000)              */
/*             Di-rutad.Libre_d01 = Di-rutad.Libre_d01 + (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.PesMat)                     */
/*             Di-rutad.Libre_d02 = Di-rutad.Libre_d02 + (Facdpedi.ImpLin * (IF Faccpedi.CodMon = 2 THEN Faccpedi.TpoCmb ELSE 1)). */
/*     END.                                                                                                                        */
/*     /* Caso OTR */                                                                                                              */
/*     IF DI-RutaD.CodRef = "OTR" THEN DO:                                                                                         */
/*         Di-rutad.Libre_d02 = 0.  /* Importe */                                                                                  */
/*         FOR EACH Facdpedi WHERE Facdpedi.codcia = DI-RutaD.CodCia AND                                                           */
/*             Facdpedi.coddoc = DI-RutaD.CodRef AND                                                                               */
/*             Facdpedi.nroped = DI-RutaD.NroRef NO-LOCK,                                                                          */
/*             FIRST Almmmatg OF Facdpedi NO-LOCK:                                                                                 */
/*             ASSIGN                                                                                                              */
/*                 Di-rutad.Libre_d02 = Di-rutad.Libre_d02 +                                                                       */
/*                                     (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.CtoTot) *                                     */
/*                                     (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1).                                       */
/*         END.                                                                                                                    */
/*     END.                                                                                                                        */
END.

/* RHC 09.06.2011 CONTROL DE TRACKING */
IF NEW Di-RutaD THEN DO:
    /* HOJA DE RUTA PENDIENTE */
    FIND Ccbcdocu WHERE Ccbcdocu.codcia = di-rutad.codcia
        AND Ccbcdocu.coddoc = di-rutad.codref
        AND Ccbcdocu.nrodoc = di-rutad.nroref
        NO-LOCK NO-ERROR NO-WAIT.
    IF AVAILABLE Ccbcdocu THEN DO:
        RUN vtagn/pTracking-04 (Di-RutaD.CodCia,
                                Di-RutaD.CodDiv,
                                Ccbcdocu.CodPed,
                                Ccbcdocu.NroPed,
                                s-User-Id,
                                'RHR',
                                'P',
                                DATETIME(TODAY, MTIME),
                                DATETIME(TODAY, MTIME),
                                Di-RutaD.CodRef,
                                Di-RutaD.NroRef,
                                Di-RutaD.CodDoc + '|' + Di-RutaD.NroDoc,
                                Di-RutaD.FlgEst).
    END.
END.
ELSE DO:    /* Cambios de estado */
    IF Di-RutaD.FlgEst <> OldDi-RutaD.FlgEst OR Di-RutaD.FlgEstDet <> OldDi-RutaD.FlgEstDet 
        THEN DO:
        FIND Ccbcdocu WHERE Ccbcdocu.codcia = di-rutad.codcia
            AND Ccbcdocu.coddoc = di-rutad.codref
            AND Ccbcdocu.nrodoc = di-rutad.nroref
            NO-LOCK NO-ERROR NO-WAIT.
        IF AVAILABLE Ccbcdocu THEN DO:
            RUN vtagn/pTracking-04 (Di-RutaD.CodCia,
                                Di-RutaD.CodDiv,
                                Ccbcdocu.CodPed,
                                Ccbcdocu.NroPed,
                                s-User-Id,
                                'RHR',
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
/* *********************** */
CREATE LogTabla.
ASSIGN
    logtabla.codcia = Di-RutaD.codcia
    logtabla.Dia = TODAY
    logtabla.Evento = 'WRITE'
    logtabla.Hora = STRING(TIME, 'HH:MM')
    logtabla.Tabla = 'Di-RutaD'
    logtabla.Usuario = s-user-id
    logtabla.ValorLlave = STRING(Di-RutaD.coddiv, 'x(5)') + '|' +
                        STRING(Di-RutaD.coddoc, 'x(3)') + '|' +
                        STRING(Di-RutaD.nrodoc, 'x(12)') + '|' +
                        STRING(Di-RutaD.codref, 'x(3)') + '|' +
                        STRING(Di-RutaD.nroref, 'x(12)') + '|' +
                        STRING(Di-RutaD.horest, 'x(5)').
                    
        
RELEASE LogTabla.
