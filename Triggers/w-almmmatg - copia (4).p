TRIGGER PROCEDURE FOR WRITE OF almmmatg OLD BUFFER OldAlmmmatg.

/* RHC 11/04/2019 Control de Unidades de Medida solicitada por Juan Ponte */
IF NEW Almmmatg AND NOT (TRUE <> (Almmmatg.UndBas > '')) THEN DO:
    {gn/i-valida-unidad.i &Unidad="Almmmatg.UndBas"}
END.
IF NEW Almmmatg AND NOT (TRUE <> (Almmmatg.UndCmp > '')) THEN DO:
    {gn/i-valida-unidad.i &Unidad="Almmmatg.UndCmp"}
END.
IF NEW Almmmatg AND NOT (TRUE <> (Almmmatg.UndStk > '')) THEN DO:
    {gn/i-valida-unidad.i &Unidad="Almmmatg.UndStk"}
END.
IF NEW Almmmatg AND NOT (TRUE <> (Almmmatg.UndA > '')) THEN DO:
    {gn/i-valida-unidad.i &Unidad="Almmmatg.UndA"}
END.
IF NEW Almmmatg AND NOT (TRUE <> (Almmmatg.UndB > '')) THEN DO:
    {gn/i-valida-unidad.i &Unidad="Almmmatg.UndB"}
END.
IF NEW Almmmatg AND NOT (TRUE <> (Almmmatg.UndC > '')) THEN DO:
    {gn/i-valida-unidad.i &Unidad="Almmmatg.UndC"}
END.
IF NEW Almmmatg AND NOT (TRUE <> (Almmmatg.CHR__01 > '')) THEN DO:
    {gn/i-valida-unidad.i &Unidad="Almmmatg.Chr__01"}
END.
IF NEW Almmmatg AND NOT (TRUE <> (Almmmatg.UndAlt[1] > '')) THEN DO:
    {gn/i-valida-unidad.i &Unidad="Almmmatg.UndAlt[1]"}
END.

/* RHC 04/03/2019 Log General */
{TRIGGERS/i-logtransactions.i &TableName="almmmatg" &Event="WRITE"}

DEF VAR x-CtoTot AS DEC NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.
DEF VAR pRowid AS ROWID NO-UNDO.

/* PARCHE */
IF Almmmatg.Libre_c04   = '' THEN Almmmatg.Libre_c04   = Almmmatg.CodMat.
IF Almmmatg.CodigoPadre = '' THEN Almmmatg.CodigoPadre = Almmmatg.CodMat.
IF Almmmatg.FactorPadre = 0  THEN Almmmatg.FactorPadre = 1.
IF Almmmatg.MonVta = 0 THEN Almmmatg.MonVta = 1.

/* ************************************************************************************** */
/* RHC 15/06/2021: Modificacion del TC */
/* ************************************************************************************** */
{TRIGGERS/i-almmmatg.i}
/*{TRIGGERS/i-almmmatg-old.i}*/
/* ************************************************************************************** */

/* RHC 30.01.2013 AGREGAMOS LOG DE CONTROL PARA OPENORANGE */
IF OldAlmmmatg.codmat <> '' THEN DO:
    /* LOG de control */
    CREATE Logmmatg.
    BUFFER-COPY Almmmatg TO Logmmatg
        ASSIGN
            Logmmatg.LogDate = TODAY
            Logmmatg.LogTime = STRING(TIME, 'HH:MM:SS')
            Logmmatg.LogUser = s-user-id
            Logmmatg.FlagFechaHora = DATETIME(TODAY, MTIME)
            Logmmatg.FlagUsuario = s-user-id
            Logmmatg.flagestado = "U".
    /* ** CUALQUIER CAMBIO DEBE REFLEJARSE EN LA OTRAS LISTAS DE PRECIOS ** */
    IF Almmmatg.UndBas <>  OldAlmmmatg.UndBas
        OR Almmmatg.UndStk <> OldAlmmmatg.UndStk
        OR Almmmatg.DesMat <> OldAlmmmatg.DesMat
        OR Almmmatg.CodBrr <> OldAlmmmatg.CodBrr
        OR Almmmatg.MonVta <>  OldAlmmmatg.MonVta
        OR Almmmatg.PreOfi <> OldAlmmmatg.PreOfi
        OR Almmmatg.TpoCmb <> OldAlmmmatg.TpoCmb
        OR Almmmatg.CtoLis <> OldAlmmmatg.CtoLis
        OR Almmmatg.PreVta[1] <> OldAlmmmatg.PreVta[1]
        OR Almmmatg.PreVta[2] <> OldAlmmmatg.PreVta[2]
        OR Almmmatg.PreVta[3] <> OldAlmmmatg.PreVta[3]
        OR Almmmatg.PreVta[4] <> OldAlmmmatg.PreVta[4]
        OR Almmmatg.DtoVolD[1] <> OldAlmmmatg.DtoVolD[1] 
        OR Almmmatg.DtoVolD[2] <> OldAlmmmatg.DtoVolD[2]  
        OR Almmmatg.DtoVolD[3] <> OldAlmmmatg.DtoVolD[3] 
        OR Almmmatg.DtoVolD[4] <> OldAlmmmatg.DtoVolD[4] 
        OR Almmmatg.DtoVolD[5] <> OldAlmmmatg.DtoVolD[5] 
        OR Almmmatg.DtoVolD[6] <> OldAlmmmatg.DtoVolD[6] 
        OR Almmmatg.DtoVolD[7] <> OldAlmmmatg.DtoVolD[7] 
        OR Almmmatg.DtoVolD[8] <> OldAlmmmatg.DtoVolD[8] 
        OR Almmmatg.DtoVolD[9] <> OldAlmmmatg.DtoVolD[9] 
        OR Almmmatg.DtoVolD[10] <> OldAlmmmatg.DtoVolD[10] 
        OR Almmmatg.DtoVolR[1] <> OldAlmmmatg.DtoVolR[1] 
        OR Almmmatg.DtoVolR[2] <> OldAlmmmatg.DtoVolR[2]
        OR Almmmatg.DtoVolR[3] <> OldAlmmmatg.DtoVolR[3]
        OR Almmmatg.DtoVolR[4] <> OldAlmmmatg.DtoVolR[4]
        OR Almmmatg.DtoVolR[5] <> OldAlmmmatg.DtoVolR[5]
        OR Almmmatg.DtoVolR[6] <> OldAlmmmatg.DtoVolR[6]
        OR Almmmatg.DtoVolR[7] <> OldAlmmmatg.DtoVolR[7]
        OR Almmmatg.DtoVolR[8] <> OldAlmmmatg.DtoVolR[8]
        OR Almmmatg.DtoVolR[9] <> OldAlmmmatg.DtoVolR[9]
        OR Almmmatg.DtoVolR[10] <> OldAlmmmatg.DtoVolR[10] 
        OR Almmmatg.PromDivi[1] <> OldAlmmmatg.PromDivi[1]
        OR Almmmatg.PromDivi[2] <> OldAlmmmatg.PromDivi[2]
        OR Almmmatg.PromDivi[3] <> OldAlmmmatg.PromDivi[3]
        OR Almmmatg.PromDivi[4] <> OldAlmmmatg.PromDivi[4]
        OR Almmmatg.PromDivi[5] <> OldAlmmmatg.PromDivi[5]
        OR Almmmatg.PromDivi[6] <> OldAlmmmatg.PromDivi[6]
        OR Almmmatg.PromDivi[7] <> OldAlmmmatg.PromDivi[7]
        OR Almmmatg.PromDivi[8] <> OldAlmmmatg.PromDivi[8]
        OR Almmmatg.PromDivi[9] <> OldAlmmmatg.PromDivi[9]
        OR Almmmatg.PromDivi[10] <> OldAlmmmatg.PromDivi[10]
        OR Almmmatg.PromDto[1] <> OldAlmmmatg.PromDto[1]
        OR Almmmatg.PromDto[2] <> OldAlmmmatg.PromDto[2]
        OR Almmmatg.PromDto[3] <> OldAlmmmatg.PromDto[3]
        OR Almmmatg.PromDto[4] <> OldAlmmmatg.PromDto[4]
        OR Almmmatg.PromDto[5] <> OldAlmmmatg.PromDto[5]
        OR Almmmatg.PromDto[6] <> OldAlmmmatg.PromDto[6]
        OR Almmmatg.PromDto[7] <> OldAlmmmatg.PromDto[7]
        OR Almmmatg.PromDto[8] <> OldAlmmmatg.PromDto[8]
        OR Almmmatg.PromDto[9] <> OldAlmmmatg.PromDto[9]
        OR Almmmatg.PromDto[10] <> OldAlmmmatg.PromDto[10]
        OR Almmmatg.PromFchD[1] <> OldAlmmmatg.PromFchD[1]
        OR Almmmatg.PromFchD[2] <> OldAlmmmatg.PromFchD[2]
        OR Almmmatg.PromFchD[3] <> OldAlmmmatg.PromFchD[3]
        OR Almmmatg.PromFchD[4] <> OldAlmmmatg.PromFchD[4]
        OR Almmmatg.PromFchD[5] <> OldAlmmmatg.PromFchD[5]
        OR Almmmatg.PromFchD[6] <> OldAlmmmatg.PromFchD[6]
        OR Almmmatg.PromFchD[7] <> OldAlmmmatg.PromFchD[7]
        OR Almmmatg.PromFchD[8] <> OldAlmmmatg.PromFchD[8]
        OR Almmmatg.PromFchD[9] <> OldAlmmmatg.PromFchD[9]
        OR Almmmatg.PromFchD[10]<> OldAlmmmatg.PromFchD[10] 
        OR Almmmatg.PromFchH[1] <> OldAlmmmatg.PromFchH[1]
        OR Almmmatg.PromFchH[2] <> OldAlmmmatg.PromFchH[2]
        OR Almmmatg.PromFchH[3] <> OldAlmmmatg.PromFchH[3]
        OR Almmmatg.PromFchH[4] <> OldAlmmmatg.PromFchH[4]
        OR Almmmatg.PromFchH[5] <> OldAlmmmatg.PromFchH[5]
        OR Almmmatg.PromFchH[6] <> OldAlmmmatg.PromFchH[6]
        OR Almmmatg.PromFchH[7] <> OldAlmmmatg.PromFchH[7]
        OR Almmmatg.PromFchH[8] <> OldAlmmmatg.PromFchH[8]
        OR Almmmatg.PromFchH[9] <> OldAlmmmatg.PromFchH[9]
        OR Almmmatg.PromFchH[10] <> OldAlmmmatg.PromFchH[10]
        THEN DO:
        pRowid = ROWID(Almmmatg).
        RUN alm/p-logmmatg-cissac (pRowid, "U", s-user-id) NO-ERROR.
        /* ***** RHC NUEVO DESCUENTOS PROMOCIONAL X DIVISION ***** */
        DEF VAR f-Precio AS DEC NO-UNDO.
        f-Precio = Almmmatg.PreVta[1].
        IF Almmmatg.MonVta = 2 THEN F-PRECIO = Almmmatg.Prevta[1] * Almmmatg.TpoCmb.
        FOR EACH VtaTabla WHERE VtaTabla.codcia = Almmmatg.codcia
            AND VtaTabla.Tabla = "DTOPROLIMA"
            AND VtaTabla.llave_c1 = Almmmatg.codmat:
            VtaTabla.Valor[2] = ROUND(F-PRECIO * ( 1 - ( VtaTabla.Valor[1] / 100 ) ),4).
        END.
        /* ********* RHC MARGENES LISTAS DE PRECIOS ************** */
        IF Almmmatg.UndBas <>  OldAlmmmatg.UndBas
            OR Almmmatg.MonVta <>  OldAlmmmatg.MonVta
            OR Almmmatg.TpoCmb <> OldAlmmmatg.TpoCmb
            OR Almmmatg.CtoTot <> OldAlmmmatg.CtoTot
            THEN DO:
            /* LISTA MINORISTA GENERAL (UTILEX) */
            FOR EACH vtalistaminGn WHERE vtalistaminGn.codcia = Almmmatg.CodCia
                AND vtalistaminGn.codmat = Almmmatg.codmat:
                x-CtoTot = Almmmatg.ctotot.
                f-Factor = 1.
                FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                    AND Almtconv.Codalter = vtalistaminGn.Chr__01
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Almtconv THEN DO:
                    F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
                END.  
                ASSIGN
                    vtalistaminGn.Dec__01 = ( (vtalistaminGn.PreOfi / (x-Ctotot * f-Factor) ) - 1 ) * 100. 
            END.
            /* LISTA MAYORISTA POR DIVISION */
            /* RHC 06/11/2013 LA MONEDA Y TIPO DE CAMBIO ESTAN EL ALMMMATG */
            FOR EACH VtaListaMay WHERE VtaListaMay.codcia = Almmmatg.codcia
                AND VtaListaMay.codmat = Almmmatg.codmat:
                ASSIGN
                    VtaListaMay.MonVta = Almmmatg.MonVta
                    VtaListaMay.TpoCmb = Almmmatg.TpoCmb
                    x-CtoTot           = Almmmatg.CtoTot
                    f-Factor = 1.
                FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                    AND Almtconv.Codalter = VtaListaMay.Chr__01
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
                ASSIGN
                    VtaListaMay.Dec__01 = ( (VtaListaMay.PreOfi / (x-Ctotot * f-Factor) ) - 1 ) * 100. 
            END.
        END.
    END.
END.
ELSE DO:
    /* LOG de control */
    CREATE Logmmatg.
    BUFFER-COPY Almmmatg TO Logmmatg
        ASSIGN
            Logmmatg.LogDate = TODAY
            Logmmatg.LogTime = STRING(TIME, 'HH:MM:SS')
            Logmmatg.LogUser = s-user-id
            Logmmatg.FlagFechaHora = DATETIME(TODAY, MTIME)
            Logmmatg.FlagUsuario = s-user-id
            Logmmatg.flagestado = "I".
    pRowid = ROWID(Almmmatg).
    RUN alm/p-logmmatg-cissac (pRowid, "I", s-user-id) NO-ERROR.
END.

