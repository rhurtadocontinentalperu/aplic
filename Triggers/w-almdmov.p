TRIGGER PROCEDURE FOR WRITE OF AlmDMov OLD BUFFER OldAlmdmov.

/* RHC 13/05/2017 Ya no se usa

DEF VAR xRaw AS RAW NO-UNDO.
DEF VAR xTipo AS CHAR NO-UNDO.

RAW-TRANSFER Almdmov TO xRaw.
IF NEW Almdmov THEN xTipo = "C".
ELSE xTipo = "U".

RUN orange\exporta-almacenes ('Almdmov',xRaw,xTipo).
*/

/* SOLO PARA TRANSFERENCIAS */
IF Almdmov.tipmov = 'S' AND Almdmov.codmov = 03 THEN DO:
    FIND Almmmatg OF Almdmov NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN 
        Almdmov.Pesmat = Almdmov.CanDes * Almdmov.Factor * Almmmatg.PesMat.
END.

/* 25/02/2023 Calculamos Peso y Volumen de la G/R para luego ser usada en la H/R */
/* Transferencias */
IF Almdmov.tipmov = 'S' AND Almdmov.codmov = 03 THEN DO:
    DEF BUFFER B-CMOV FOR almcmov.
    DEF BUFFER B-DMOV FOR almdmov.
    DEF BUFFER B-MATG  FOR Almmmatg.
    DEF VAR x-Peso AS DECI NO-UNDO.
    DEF VAR x-Volumen AS DECI NO-UNDO.

    /* Bloqueamos cabecera */
    FIND FIRST B-CMOV WHERE B-CMOV.codcia = Almdmov.codcia AND
        B-CMOV.codalm = Almdmov.codalm AND
        B-CMOV.tipmov = Almdmov.tipmov AND
        B-CMOV.codmov = Almdmov.codmov AND
        B-CMOV.nroser = Almdmov.nroser AND
        B-CMOV.nrodoc = Almdmov.nrodoc
        EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF AVAILABLE B-CMOV THEN DO:
        x-Peso = 0.      /* Peso en kg */
        x-Volumen = 0.      /* Volumen en m3 */
        FOR EACH B-DMOV NO-LOCK WHERE B-DMOV.codcia = Almdmov.codcia AND
            B-DMOV.codalm = Almdmov.codalm AND
            B-DMOV.tipmov = Almdmov.tipmov AND
            B-DMOV.codmov = Almdmov.codmov AND
            B-DMOV.nroser = Almdmov.nroser AND
            B-DMOV.nrodoc = Almdmov.nrodoc,
            FIRST B-MATG OF B-DMOV NO-LOCK:
            x-Peso = x-Peso + (B-DMOV.candes * B-DMOV.factor * B-MATG.pesmat).
            x-Volumen = x-Volumen + (B-DMOV.candes * B-DMOV.factor * B-MATG.libre_d02 / 1000000).
        END.
        B-CMOV.libre_d01 = x-Peso.
        B-CMOV.libre_d02 = x-Volumen.
        RELEASE B-CMOV.
    END.
END.
/* Stock Comprometido */
/* 10/10/2024*/

/*

24Feb2025 - Se debe activa cuando se reinicien las pruebas para Riqra - horizontal

RUN web/p-ctrl-sku-disp-riqra (INPUT "Almdmov", 
                               INPUT (Almdmov.CodAlm + ":" +
                                      Almdmov.TipMov + ":" +
                                      STRING(Almdmov.CodMov) + ":" +
                                      STRING(Almdmov.NroSer) + ":" +
                                      STRING(Almdmov.NroDoc) + ":" +
                                      Almdmov.CodMat),
                               INPUT (Almdmov.CanDes * Almdmov.Factor),
                               INPUT (OldAlmdmov.candes * OldAlmdmov.factor),
                               "W"
                               ).


*/
