TRIGGER PROCEDURE FOR WRITE OF VtaTabla OLD BUFFER OldVtaTabla.

IF LOOKUP(VtaTabla.Tabla, "DTOPROLIMA,DTOPROUTILEX") > 0 THEN RETURN.

/* RHC 04/03/2019 Log General */
DEF VAR pEvento AS CHAR NO-UNDO.
/* IF VtaTabla.Tabla = "BREVETE" THEN DO:                                         */
/*     IF NEW vtatabla THEN DO:                                                   */
/*         pEvento = "CREATE".                                                    */
/*     END.                                                                       */
/*     ELSE DO:                                                                   */
/*         pEvento = "WRITE".                                                     */
/*     END.                                                                       */
/*     {TRIGGERS/i-logtransactions.i &TableName="vtatabla" &TipoEvento="pEvento"} */
/* END.                                                                           */

/* ************************************************************************************** */
/* RHC 21/10/2021 Grabar importe sin igv */
/* ************************************************************************************** */
FIND FIRST Sunat_Fact_Electr_Taxs  WHERE Sunat_Fact_Electr_Taxs.TaxTypeCode = "IGV"
    AND Sunat_Fact_Electr_Taxs.Disabled = NO
    AND TODAY >= Sunat_Fact_Electr_Taxs.Start_Date 
    AND TODAY <= Sunat_Fact_Electr_Taxs.End_Date 
    AND Sunat_Fact_Electr_Taxs.Tax > 0
    NO-LOCK NO-ERROR.

DEF VAR k AS INTE NO-UNDO.
CASE VtaTabla.Tabla:
    WHEN "REMATES" THEN DO:
        IF AVAILABLE Sunat_Fact_Electr_Taxs AND VtaTabla.Valor[1] <> OldVTaTabla.Valor[1] THEN DO:
            ASSIGN
                VtaTabla.TasaImpuesto = Sunat_Fact_Electr_Taxs.Tax
                VtaTabla.ImporteUnitarioSinImpuesto = ROUND(VtaTabla.Valor[1] / ( 1 + Sunat_Fact_Electr_Taxs.Tax / 100), 4)
                VtaTabla.ImporteUnitarioImpuesto = VtaTabla.Valor[1] - VtaTabla.ImporteUnitarioSinImpuesto
                .
        END.
    END.
END CASE.

/* 21/01/2021 Log de control */
/*DEF VAR pEvento AS CHAR NO-UNDO.*/
IF NEW VtaTabla THEN pEvento = 'CREATE'.
ELSE pEvento = 'UPDATE'.
DEF SHARED VAR s-user-id AS CHAR.

CREATE LogVtaTabla.
BUFFER-COPY VtaTabla TO LogVtaTabla
    ASSIGN
    LogVtaTabla.LogDate = TODAY
    LogVtaTabla.LogEvento = pEvento
    LogVtaTabla.LogTime = STRING(TIME, 'HH:MM:SS')
    LogVtaTabla.LogUser = s-user-id.
RELEASE LogVtaTabla.

