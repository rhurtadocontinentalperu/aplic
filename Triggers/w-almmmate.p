TRIGGER PROCEDURE FOR WRITE OF almmmate OLD BUFFER OldAlmmmate.

/* CODIGO DE UBICACION POR DEFECTO */
IF Almmmate.codubi = '' THEN Almmmate.CodUbi = 'G-0'.

/* SOLO PARA ECOMMERCE (LISTA EXPRESS) */
IF Almmmate.CodAlm = '506'  THEN DO:
    DEF VAR pEstado AS CHAR NO-UNDO.
    RUN gn/p-ecommerce (INPUT "aplic/gn/p-ecommerce-stocks.p",
                        INPUT STRING(Almmmate.CodCia) + ',' + Almmmate.CodAlm + ',' + Almmmate.CodMat,
                        OUTPUT pEstado).

END.

/* ************************************************************************* */
/* RHC 17/03/2021 homologación de ubicaciones */
/* Solo dispara cuando hay un cambio en la ubicación en el almacén principal */
/* ************************************************************************* */

/* 11/08/2022: Desactivado porque no se usa */
/* IF OldAlmmmate.CodUbi <> Almmmate.CodUbi THEN DO:          */
/*     RUN gn/p-homologa-ubicacion (INPUT Almmmate.CodCia,    */
/*                                  INPUT Almmmate.CodAlm,    */
/*                                  INPUT Almmmate.CodMat,    */
/*                                  INPUT Almmmate.CodUbi).   */
/*     IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN ERROR. */
/* END.                                                       */


/* 11/08/2022 Control de cambio de ubicacion */
DEF VAR x-CodUbiIni AS CHAR NO-UNDO.
DEF VAR x-CodUbiFin AS CHAR NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.

DEF SHARED VAR s-user-id AS CHAR.

IF OldAlmmmate.CodUbi <> Almmmate.CodUbi THEN DO:
    x-CodUbiIni = OldAlmmmate.CodUbi.
    x-CodUbiFin = Almmmate.CodUbi.
    FIND FIRST almubimat WHERE almubimat.CodCia = Almmmate.codcia
        AND almubimat.CodAlm = Almmmate.codalm
        AND almubimat.CodMat = Almmmate.codmat
        AND almubimat.CodUbi = x-CodUbiIni
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almubimat THEN DO:
        /* CREATE */
        CREATE almubimat.
        BUFFER-COPY Almmmate TO Almubimat.
        FIND Almtubic WHERE almtubic.CodCia = Almmmate.codcia
            AND almtubic.CodAlm = Almmmate.codalm
            AND almtubic.CodUbi = Almmmate.codubi
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtubic THEN almubimat.CodZona = Almtubic.codzona.
        CREATE Logubimat.
        BUFFER-COPY Almmmate TO Logubimat
            ASSIGN
            logubimat.Usuario = s-user-id
            logubimat.Hora = STRING(TIME, 'HH:MM:SS')
            logubimat.Fecha = TODAY
            logubimat.Evento = 'CREATE'
            logubimat.CodUbiIni = x-CodUbiFin
            logubimat.CodUbiFin = x-CodUbiFin.
        FIND Almtubic WHERE almtubic.CodCia = Almmmate.codcia
            AND almtubic.CodAlm = Almmmate.codalm
            AND almtubic.CodUbi = x-CodUbiFin
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtubic THEN
            ASSIGN
            logubimat.CodZonaIni = almtubic.CodZona
            logubimat.CodZonaFin = almtubic.CodZona.
    END.
    ELSE DO:
        /* MOVE */
        FIND CURRENT Almubimat EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje" }
            MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN ERROR.
        END.
        ASSIGN
            almubimat.CodUbi = x-CodUbiFin.
        CREATE Logubimat.
        BUFFER-COPY Almmmate TO Logubimat
            ASSIGN
            logubimat.Usuario = s-user-id
            logubimat.Hora = STRING(TIME, 'HH:MM:SS')
            logubimat.Fecha = TODAY
            logubimat.Evento = 'MOVE'
            logubimat.CodUbiIni = x-CodUbiIni
            logubimat.CodZonaIni = Almubimat.CodZona
            logubimat.CodUbiFin = x-CodUbiFin.
        FIND Almtubic WHERE almtubic.CodCia = Almmmate.codcia
            AND almtubic.CodAlm = Almmmate.codalm
            AND almtubic.CodUbi = x-CodUbiFin
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtubic THEN 
            ASSIGN
            almubimat.codzona    = Almtubic.CodZona
            logubimat.CodZonaFin = Almtubic.CodZona.
    END.
    IF AVAILABLE(logubimat) THEN RELEASE logubimat.
END.
