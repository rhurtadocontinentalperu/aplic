
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE S-CODCIA                AS INTEGER INIT 1.
DEFINE VARIABLE X-NOMPER                AS CHAR FORMAT "X(50)".

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 6.
chWorkSheet:Columns("B"):ColumnWidth = 40.
chWorkSheet:Columns("C"):ColumnWidth = 15.
chWorkSheet:Columns("D"):ColumnWidth = 20.
chWorkSheet:Columns("A:A"):NumberFormat = "@".
chWorkSheet:Columns("B:B"):NumberFormat = "@".
chWorkSheet:Columns("C:C"):NumberFormat = "dd-mm-yyyy".
chWorkSheet:Columns("D:D"):NumberFormat = "@".



chWorkSheet:Range("A1:D1"):Font:Bold = TRUE.
chWorkSheet:Range("A1"):Value = "Codigo".
chWorkSheet:Range("B1"):Value = "Nombre".
chWorkSheet:Range("C1"):Value = "Fecha ".
chWorkSheet:Range("D1"):Value = "Hora  ".

/* Iterate through the salesrep table and populate
   the Worksheet appropriately */

FOR EACH as-marc no-lock where as-marc.codcia =  S-CODCIA 
                       break by as-marc.codcia 
                             by as-marc.codper
                             by as-marc.fchmar
                             by as-marc.hormar:
                    
    if first-of(as-marc.codper) then do:
        x-nomper = "".
        find  pl-pers where pl-pers.codper = as-marc.codper
                            no-lock no-error.
        
        if avail pl-pers then x-nomper = trim(pl-pers.patper) + " " + trim(pl-pers.matper) + " " + trim(pl-pers.nomper).

        iColumn = iColumn + 2.
    
        cColumn = STRING(iColumn).

        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = STRING(as-marc.codper,"999999").
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = x-nomper.
    
    end.
/*
    if first-of(as-marc.fchmar) then do:
    
    end.
*/    

    iColumn = iColumn + 1.

    cColumn = STRING(iColumn).
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = as-marc.fchmar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = as-marc.hormar.

end.


/* release com-handles */



