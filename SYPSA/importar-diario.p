/* TEMPORAL CONTABLE */
DEF TEMP-TABLE T-CAB LIKE cb-cmov.
DEF TEMP-TABLE T-DET LIKE cb-dmov.

DEF VAR s-codcia AS INT INIT 001 NO-UNDO.
DEF VAR cb-codcia AS INT INIT 000 NO-UNDO.
DEF VAR s-periodo AS INT INIT 2014 NO-UNDO.     /* ??? */
DEF VAR s-nromes AS INT INIT 01 NO-UNDO.      /*  ???? */
/* ER:093, DI y CO : 005,058,059,065,070,071,075,076.080,091,092  */
DEF VAR s-codope AS CHAR INIT 'ZZZ' NO-UNDO.    /* ??? */  
DEF VAR sFiler1 AS CHARACTER.

DEF VAR s-nrodoc AS CHAR NO-UNDO.
DEFINE VARIABLE FILL-IN-file AS CHAR NO-UNDO.

/*
    059 : Salidas de Fondos
    092 : Rendicion de Gastos
    001 : Entrada de Fondos
*/
s-periodo = 2015.
s-nromes = 12.
s-codope = "001".

FILL-IN-file = "C:\Ciman\MigrarSpeedToProgres\Conti\mov_ctable_conti_speed_a_progress_Ago2015_DI_CO_ER_" + s-codope + ".XLS".
FILL-IN-file = "C:\Ciman\Atenciones\OpenOrange\Asientos\EntradaFondos_0001_12_20160113-195446.xls".

/*
DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.
DEFINE VARIABLE FILL-IN-file AS CHAR NO-UNDO.
SYSTEM-DIALOG GET-FILE FILL-IN-file
    FILTERS "Archivos Excel (*.xls?)" "*.xls?", "Todos (*.*)" "*.*"
    TITLE "Archivo(s) de Carga..."
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.
*/


/* PRIMERO BORRAMOS ASIENTOS ANTES TRANSFERIDOS */
DELETE FROM cb-cmov WHERE cb-cmov.codcia = s-codcia
    AND cb-cmov.periodo = s-periodo
    AND cb-cmov.nromes = s-nromes
    AND cb-cmov.codope = s-codope.
DELETE FROM cb-dmov WHERE cb-dmov.codcia = s-codcia
    AND cb-dmov.periodo = s-periodo
    AND cb-dmov.nromes = s-nromes
    AND cb-dmov.codope = s-codope.

/* SEGUNDO IMPORTAMOS DESDE EL EXCEL */
RUN Importar-Excel.

/*
OUTPUT TO c:\tmp\cb-dmov.d.
FOR EACH t-det NO-LOCK:
    EXPORT t-det.
END.
OUTPUT CLOSE.
*/

/* TERCERO GENERAMOS LOS ASIENTOS */
FOR EACH T-DET NO-LOCK BREAK BY T-DET.Periodo BY T-DET.NroMes BY T-DET.CodOpe BY T-DET.NroAst:
    DISPLAY t-det.codope t-det.nroast t-det.codcta.
    PAUSE 0.
    IF FIRST-OF(T-DET.Periodo) 
        OR FIRST-OF(T-DET.NroMes)
        OR FIRST-OF(T-DET.CodOpe)
        OR FIRST-OF(T-DET.NroAst) THEN DO:
        CREATE cb-cmov.
        BUFFER-COPY T-DET
            TO cb-cmov
            ASSIGN
            /*cb-cmov.FchAst = DATE(T-DET.NroMes, 01, T-DET.Periodo)*/
            cb-cmov.FchAst = T-DET.FchDoc
            cb-cmov.NroAst = SUBSTRING(T-DET.NroAst,5,6)
            cb-cmov.Usuario = "AUTO".
    END.
    CREATE cb-dmov.
    BUFFER-COPY T-DET
        TO cb-dmov
        ASSIGN
        cb-dmov.NroAst = SUBSTRING(T-DET.NroAst,5,6).
END.
FOR EACH cb-cmov WHERE cb-cmov.codcia = s-codcia
    AND cb-cmov.periodo = s-periodo
    AND cb-cmov.nromes = s-nromes
    AND cb-cmov.codope = s-codope:
    ASSIGN
        cb-cmov.HbeMn1 = 0
        cb-cmov.HbeMn2 = 0
        cb-cmov.HbeMn3 = 0
        cb-cmov.DbeMn1 = 0
        cb-cmov.DbeMn2 = 0
        cb-cmov.DbeMn3 = 0.
    FOR EACH cb-dmov OF cb-cmov:
        IF cb-dmov.TpoMov THEN     /* Tipo H */
            ASSIGN  cb-cmov.HbeMn1 = cb-cmov.HbeMn1 + cb-dmov.ImpMn1
                    cb-cmov.HbeMn2 = cb-cmov.HbeMn2 + cb-dmov.ImpMn2
                    cb-cmov.HbeMn3 = cb-cmov.HbeMn3 + cb-dmov.ImpMn3.
        ELSE 
        ASSIGN cb-cmov.DbeMn1 = cb-cmov.DbeMn1 + cb-dmov.ImpMn1
               cb-cmov.DbeMn2 = cb-cmov.DbeMn2 + cb-dmov.ImpMn2
               cb-cmov.DbeMn3 = cb-cmov.DbeMn3 + cb-dmov.ImpMn3.
        /* NUMERO DE DOCUMENTO */
        IF LENGTH(nrodoc) = 15 THEN DO:
            s-NroDoc = cb-dmov.NroDoc.
            ASSIGN
                s-NroDoc = STRING(INTEGER(SUBSTRING(cb-dmov.nrodoc,1,5)), '999') + '-' +
                TRIM(STRING(DECIMAL(SUBSTRING(cb-dmov.nrodoc,6))))
                NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                /* Fac Electronicas */
                s-nrodoc = SUBSTRING(cb-dmov.nrodoc,1,5) + "-" + TRIM(STRING(DECIMAL(SUBSTRING(cb-dmov.nrodoc,6)))).
            END.

            ASSIGN
                cb-dmov.NroDoc = s-NroDoc.
        END.
    END.

END.


PROCEDURE Importar-Excel:

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet AS COM-HANDLE.

    DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
    DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
    DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
    DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
    DEFINE VARIABLE t-Row           AS INTEGER INIT 7.
    DEFINE VARIABLE i-Column        AS INTEGER     NO-UNDO.

    CREATE "Excel.Application" chExcelApplication.
    chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-File).
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    t-Row = 1.     /* Saltamos el encabezado de los campos */
    REPEAT:
        ASSIGN
            t-column = 0
            t-Row    = t-Row + 1.
        DISPLAY t-row.
        PAUSE 0.
        /* asaeje - PERIODO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN NEXT.
        CREATE T-DET.
        ASSIGN
            T-DET.CodCia = s-codcia
            T-DET.Periodo = iValue.
        /* asaper - MES */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN NEXT.
        ASSIGN T-DET.NroMes = iValue.
        /* asacve - ASIENTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN
            T-DET.NroAst = cValue.
        /* asaseq - ITEM */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN NEXT.
        ASSIGN T-DET.NroItm  = iValue.
        /* asacta - CUENTA */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN T-DET.CodCta = cValue.
        sFiler1 = trim(cValue).
        /* asacoa - CARGO O ABONO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN T-DET.TpoMov = (IF cValue = "C" THEN NO ELSE YES).
        /* asare1 - DOCUMENTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN  T-DET.NroDoc = cValue.
        /* asare2 - TIPO DOCUMENTO*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        cValue = SUBSTRING(cValue,1,2).
        ASSIGN  T-DET.CodDoc = cValue.
        /*
        13Abr2015, desde el proceso de VFP ya viene con el codigo se SUNAT
        IF cValue <> '' THEN DO:
            IF SUBSTRING(sFiler1,1,2)='14' OR SUBSTRING(sFiler1,1,3)='422' OR SUBSTRING(sFiler1,1,3)='469' THEN DO :
                /* Cuenta 14, el tipo dcto es 34 */
                T-DET.CodDoc = '34'.
            END.
            ELSE DO:
                FIND cb-tabl WHERE cb-tabl.Tabla = "A1"
                    AND cb-tabl.Codigo = cValue
                    NO-LOCK NO-ERROR.
                IF AVAILABLE cb-tabl THEN T-DET.CodDoc = cb-tabl.Codcta.
            END.
        END.
        */
        /* asare3 */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asare4 */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asafem - FECHA DOCUMENTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO AND iValue > 0 THEN 
            ASSIGN T-DET.FchDoc = DATE(INTEGER(SUBSTRING(cValue,5,2)),
                                       INTEGER(SUBSTRING(cValue,7)),
                                       INTEGER(SUBSTRING(cValue,1,4)))
            NO-ERROR.
        /* asave - FECHA DE VENCIMIENTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO AND iValue > 0 THEN 
            ASSIGN T-DET.FchVto = DATE(INTEGER(SUBSTRING(cValue,5,2)),
                                       INTEGER(SUBSTRING(cValue,7)),
                                       INTEGER(SUBSTRING(cValue,1,4)))
            NO-ERROR.
        /* asadde - GLOSA */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN T-DET.GloDoc = cValue.
        /* asamon - MONEDA */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        ASSIGN T-DET.CodMon  = iValue + 1.
        /* asactc - ¿CODIGO TIPO DE CAMBIO? */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        /* asaimn - IMPORTE SOLES */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN dValue = DECIMAL(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO THEN ASSIGN T-DET.ImpMn1 = dValue.
        /* asaime - IMPORTE DOLARES */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN dValue = DECIMAL(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO THEN ASSIGN T-DET.ImpMn2 = dValue.
        /* asatca - T.C. */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN dValue = DECIMAL(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO THEN ASSIGN T-DET.TpoCmb = dValue.
        /* asacco - CONCEPTO CONTABLE */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /*ASSIGN T-DET.CodOpe = cValue.*/
        ASSIGN T-DET.CodOpe = s-codope.
        /* asata1 - TIPO AUXILIAR 1 */
        t-column = t-column + 1.
        cValue = trim(chWorkSheet:Cells(t-Row, t-Column):VALUE).
        T-DET.ClfAux = cvalue.
        IF cValue = "PR" THEN T-DET.ClfAux = "@PV".
        IF cValue = "TR" THEN T-DET.ClfAux = "@PV".
        /*IF cValue = "PE" THEN T-DET.ClfAux = "@PE".*/
       
        /* asaca1 - CODIGO AUXILIAR 1 */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        cvalue = TRIM(cValue).
        IF SUBSTRING(sFiler1,1,2)='14' THEN DO :
            /* Codigo de Personal debe tener 8 digitos */
            T-DET.CodAux = cValue.
            IF LENGTH(cValue) < 8 THEN DO:
                cValue = FILL('0', 8 - (LENGTH(cValue))) + cValue.
                T-DET.CodAux = cValue.
            END.            
        END.
        ELSE DO:        
            /*T-DET.CodAux = SUBSTRING(cValue,3,8).*/
            T-DET.CodAux = cValue.
        END.
        /* asata2 - TIPO AUXILIAR 2*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asaca2 - CODIGO AUXILIAR 2*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asacos - CENTRO DE COSTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.

        /* Parcheeee */
        /*FIND cb-auxi WHERE cb-auxi.codcia = cb-codcia*/
        FIND cb-auxi WHERE cb-auxi.codcia = 0
            AND cb-auxi.clfaux = 'CCO'
            AND cb-auxi.libre_c01 = cValue NO-LOCK NO-ERROR.
        IF AVAILABLE cb-auxi THEN ASSIGN T-DET.Cco = cb-auxi.codaux.
        ELSE ASSIGN T-DET.Cco = cValue.
        /* asaact - ACTIVIDAD */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asagas - TIPO DE GASTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asaid - SITUACION DEL DETALLE */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asaimo - IMPORTE MONEDA DE ORIGEN */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asatmno - VALOR DE CAMBIO MONEDA ORIGEN */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* flgdan - DEPURACION ANALISIS DE CUENTA */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asare5 - REFERENCIA 5*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asare6 - REFERENCIA 6*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asatr1 - TIPO 1*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asatr2 - TIPO 2*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* xx_cta - CUENTA REAL */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* Para OpenOrange No vaaa
        IF cValue <> '' THEN T-DET.CodCta = cValue.
        */

        IF T-DET.Cco = ? THEN T-DET.Cco = ''.
        IF T-DET.codaux = ? THEN T-DET.Codaux = ''.        
        IF T-DET.ClfAux = ? THEN T-DET.ClfAux = ''.
        IF T-DET.coddoc = '00' OR T-DET.Cco = 'DD' THEN T-DET.coddoc = ''.
        IF T-DET.nrodoc = ? THEN T-DET.nrodoc = ''.
        IF T-DET.Coddoc = ? THEN T-DET.Coddoc = ''.

    END.
    chExcelApplication:QUIT().
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet. 

END PROCEDURE.
