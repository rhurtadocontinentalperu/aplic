TRIGGER PROCEDURE FOR WRITE OF almmmatp OLD BUFFER Oldalmmmatp.

/* RHC 11/04/2019 Control de Unidades de Medida solicitada por Juan Ponte */
/* IF NEW almmmatp AND NOT (TRUE <> (almmmatp.UndBas > '')) THEN DO:    */
/*     MESSAGE 'grabando' almmmatp.undbas.                              */
/*     {gn/i-valida-unidad.i &Unidad="almmmatp.UndBas"}                 */
/* END.                                                                 */
/* IF NEW almmmatp AND NOT (TRUE <> (almmmatp.UndCmp > '')) THEN DO:    */
/*     {gn/i-valida-unidad.i &Unidad="almmmatp.UndCmp"}                 */
/* END.                                                                 */
/* IF NEW almmmatp AND NOT (TRUE <> (almmmatp.UndStk > '')) THEN DO:    */
/*     {gn/i-valida-unidad.i &Unidad="almmmatp.UndStk"}                 */
/* END.                                                                 */
/* IF NEW almmmatp AND NOT (TRUE <> (almmmatp.UndA > '')) THEN DO:      */
/*     {gn/i-valida-unidad.i &Unidad="almmmatp.UndA"}                   */
/* END.                                                                 */
/* IF NEW almmmatp AND NOT (TRUE <> (almmmatp.UndB > '')) THEN DO:      */
/*     {gn/i-valida-unidad.i &Unidad="almmmatp.UndB"}                   */
/* END.                                                                 */
/* IF NEW almmmatp AND NOT (TRUE <> (almmmatp.UndC > '')) THEN DO:      */
/*     {gn/i-valida-unidad.i &Unidad="almmmatp.UndC"}                   */
/* END.                                                                 */
/* IF NEW almmmatp AND NOT (TRUE <> (almmmatp.CHR__01 > '')) THEN DO:   */
/*     {gn/i-valida-unidad.i &Unidad="almmmatp.Chr__01"}                */
/* END.                                                                 */
/* IF NEW almmmatp AND NOT (TRUE <> (almmmatp.UndAlt[1] > '')) THEN DO: */
/*     {gn/i-valida-unidad.i &Unidad="almmmatp.UndAlt[1]"}              */
/* END.                                                                 */

DEF VAR x-Item AS INTE NO-UNDO.
DEF VAR f-PrecioLista AS DECI NO-UNDO.

FIND Almmmatg OF Almmmatp NO-LOCK NO-ERROR.
IF Almmmatp.PreOfi <> OldAlmmmatp.PreOfi THEN DO:
    f-PrecioLista = Almmmatp.PreOfi.
    /* Actualizamos Precio por Volumen */
    DO x-Item = 1 TO 10:
        IF Almmmatp.DtoVolD[x-Item] <> 0 THEN
            ASSIGN Almmmatp.DtoVolP[x-Item] = ROUND(f-PrecioLista * (1 - (Almmmatp.DtoVolD[x-Item]  / 100)), 4).
    END.
END.

