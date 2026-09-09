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
/*{TRIGGERS/i-logtransactions.i &TableName="almmmatg" &Event="WRITE"}*/
    DEF SHARED VAR s-user-id AS CHAR.
    DEF SHARED VAR pRCID AS INT.

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

