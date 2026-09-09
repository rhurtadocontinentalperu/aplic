TRIGGER PROCEDURE FOR WRITE OF ccbddocu.
/* ************************************ */

/* 25/02/2023 Calculamos Peso y Volumen de la G/R para luego ser usada en la H/R */
IF LOOKUP(Ccbddocu.coddoc, "G/R,FAI") > 0 THEN DO:
    DEF BUFFER B-CDOCU FOR ccbcdocu.
    DEF BUFFER B-DDOCU FOR ccbddocu.
    DEF BUFFER B-MATG  FOR Almmmatg.
    DEF VAR x-Peso AS DECI NO-UNDO.
    DEF VAR x-Volumen AS DECI NO-UNDO.

    /* Bloqueamos cabecera */
    FIND FIRST B-CDOCU WHERE B-CDOCU.codcia = Ccbddocu.codcia AND
        B-CDOCU.coddiv = Ccbddocu.coddiv AND
        B-CDOCU.coddoc = Ccbddocu.coddoc AND
        B-CDOCU.nrodoc = Ccbddocu.nrodoc
        EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF AVAILABLE B-CDOCU THEN DO:
        x-Peso = 0.      /* Peso en kg */
        x-Volumen = 0.      /* Volumen en m3 */
        FOR EACH B-DDOCU NO-LOCK WHERE B-DDOCU.codcia = Ccbddocu.codcia AND
            B-DDOCU.coddiv = Ccbddocu.coddiv AND
            B-DDOCU.coddoc = Ccbddocu.coddoc AND
            B-DDOCU.nrodoc = Ccbddocu.nrodoc,
            FIRST B-MATG OF B-DDOCU NO-LOCK:
            x-Peso = x-Peso + (B-DDOCU.candes * B-DDOCU.factor * B-MATG.pesmat).
            x-Volumen = x-Volumen + (B-DDOCU.candes * B-DDOCU.factor * B-MATG.libre_d02 / 1000000).
        END.
        B-CDOCU.libre_d01 = x-Peso.
        B-CDOCU.libre_d02 = x-Volumen.
        RELEASE B-CDOCU.
    END.
END.

/* CALCULANDO PESOS */
IF LOOKUP(Ccbddocu.coddoc, "FAC,BOL,G/R") > 0 THEN DO:
    FIND Almmmatg OF Ccbddocu NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN CcbDDocu.Pesmat = CcbDDocu.CanDes * CcbDDocu.Factor * Almmmatg.PesMat.
END.


DEF VAR x-Cto1 AS DEC NO-UNDO.
DEF VAR x-Cto2 AS DEC NO-UNDO.

ASSIGN
    x-Cto1 = 0
    x-Cto2 = 0.

/* ACTUALIZANDO COSTOS */
IF LOOKUP(Ccbddocu.coddoc, "FAC,BOL,TCK") > 0 THEN DO:
    FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = Ccbddocu.codcia
        AND Ccbcdocu.coddoc = Ccbddocu.coddoc
        AND Ccbcdocu.nrodoc = Ccbddocu.nrodoc
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbcdocu THEN DO:
        /***********Grabando Costos **********************/
        FIND FIRST Almmmatg OF Ccbddocu NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmatg AND Almmmatg.TpoCmb > 0 THEN DO: 
            /* VERIFICAR PRIMERO EL FACTOR */
            IF Ccbddocu.Factor = ? OR Ccbddocu.Factor = 0 THEN DO:
                FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                    AND Almtconv.Codalter = Ccbddocu.undvta
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Almtconv AND Almmmatg.FacEqu > 0 THEN Ccbddocu.Factor = Almtconv.Equival / Almmmatg.FacEqu.
                ELSE Ccbddocu.Factor = 1.
                /* RHC 27-08-2012 CORREGIMOS FACTOR EN ALMACENES */
                FIND Almcmov WHERE Almcmov.codcia = Ccbcdocu.codcia
                    AND Almcmov.codalm = Ccbddocu.almdes
                    AND Almcmov.tipmov = "S"
                    AND Almcmov.codmov = Ccbcdocu.codmov
                    AND Almcmov.codref = Ccbcdocu.coddoc
                    AND Almcmov.nroref = Ccbcdocu.nrodoc
                    NO-LOCK NO-ERROR NO-WAIT.
                IF AVAILABLE Almcmov THEN DO:
                    FIND Almdmov OF Almcmov WHERE Almdmov.codmat = Ccbddocu.codmat NO-ERROR NO-WAIT.
                    IF AVAILABLE Almdmov THEN DO:
                        Almdmov.Factor = Ccbddocu.Factor.
                        RELEASE Almdmov.
                    END.
                END.
                /* ********************************************* */
            END.
            /* *************************** */
            IF almmmatg.monvta = 1 THEN DO:
                x-cto1 = ROUND( Almmmatg.Ctotot * Ccbddocu.CanDes * Ccbddocu.Factor , 2 ).
                x-cto2 = ROUND(( Almmmatg.Ctotot * Ccbddocu.CanDes * Ccbddocu.Factor ) /  Almmmatg.Tpocmb , 2 ).
            END.
            IF almmmatg.monvta = 2 THEN DO:
                x-cto1 = ROUND( Almmmatg.Ctotot * Ccbddocu.CanDes * Ccbddocu.Factor * Almmmatg.TpoCmb, 2 ).
                x-cto2 = ROUND(( Almmmatg.Ctotot * Ccbddocu.CanDes * Ccbddocu.Factor ) , 2 ).
            END.
            /*************************************************/
            /* RHC 14.03.2011 CONTRATO MARCO */
            FIND Faccpedi WHERE Faccpedi.codcia = Ccbcdocu.codcia
                AND Faccpedi.coddoc = Ccbcdocu.codped
                AND Faccpedi.nroped = Ccbcdocu.nroped
                NO-LOCK NO-ERROR.
            IF AVAILABLE Faccpedi AND Faccpedi.TpoPed = "M" THEN DO:
                FIND Almmmatp OF Ccbddocu NO-LOCK NO-ERROR.
                IF AVAILABLE Almmmatp THEN DO:
                    IF almmmatg.monvta = 1 THEN DO:
                        x-cto1 = ROUND( Almmmatp.Ctotot * Ccbddocu.CanDes * Ccbddocu.Factor , 2 ).
                        x-cto2 = ROUND(( Almmmatp.Ctotot * Ccbddocu.CanDes * Ccbddocu.Factor ) /  Almmmatg.Tpocmb , 2 ).
                    END.
                    IF almmmatg.monvta = 2 THEN DO:
                        x-cto1 = ROUND( Almmmatp.Ctotot * Ccbddocu.CanDes * Ccbddocu.Factor * Almmmatg.TpoCmb, 2 ).
                        x-cto2 = ROUND(( Almmmatp.Ctotot * Ccbddocu.CanDes * Ccbddocu.Factor ) , 2 ).
                    END.
                END.
            END.
            /*************************************************/
            ASSIGN
                Ccbddocu.ImpCto = ( IF Ccbcdocu.codmon = 1 THEN x-cto1 ELSE x-cto2 ).
        END.
    END.
END.
/* N/C POR DEVOLUCION DE MERCADERIA */
/* DEF BUFFER B-DDOCU FOR Ccbddocu. */
/* DEF BUFFER B-CDOCU FOR Ccbcdocu. */
IF Ccbddocu.coddoc = "N/C" THEN DO:
    FIND FIRST B-CDOCU WHERE B-CDOCU.codcia = Ccbddocu.codcia
        AND B-CDOCU.coddoc = Ccbddocu.coddoc
        AND B-CDOCU.nrodoc = Ccbddocu.nrodoc
        NO-LOCK NO-ERROR.
    IF AVAILABLE B-CDOCU AND B-CDOCU.CndCre = "D" THEN DO:
        FIND B-DDOCU WHERE B-DDOCU.codcia = Ccbddocu.codcia
            AND B-DDOCU.coddoc = B-CDOCU.codref
            AND B-DDOCU.nrodoc = B-CDOCU.nroref
            AND B-DDOCU.codmat = Ccbddocu.codmat
            NO-LOCK NO-ERROR.
        IF AVAILABLE B-DDOCU THEN Ccbddocu.ImpCto = B-DDOCU.ImpCto / B-DDOCU.CanDes * Ccbddocu.CanDes.
    END.
END.

