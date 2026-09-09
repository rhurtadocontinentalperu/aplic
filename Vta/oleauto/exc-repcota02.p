/* 
 * This sample extracts data from a Progress database
 * and graphs the information using the Automation Objects
 * from the Excel server in Office 95/97.
 * You must connect to a sports database before running this.
 * This sample program leaves Excel open.  You should close it manually
 * when the program completes.
 */

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iTotalNumberOfOrders    AS INTEGER.
DEFINE VARIABLE iMonth                  AS INTEGER.
DEFINE VARIABLE dAnnualQuota            AS DECIMAL.
DEFINE VARIABLE dTotalSalesAmount       AS DECIMAL.
DEFINE VARIABLE t-Column                AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER INIT 1.
DEFINE SHARED VARIABLE S-CODDIV   AS char INIT "00-000".
DEFINE VARIABLE f-Column                AS char INITIAL "".
DEFINE VARIABLE x-valor                 AS DECIMAL init 0.




def temp-table t-codven01 field codven as char init ""
                          field desven as char init ""
                          field acc-soles as deci init 0
                          field acc-dolar as deci init 0
                          field acc-dolar-pen as deci init 0
                          field acc-dolar-anu as deci init 0
                          field acc-dolar-ate as deci init 0
                          field iColumn as integer init 0.

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
chWorkSheet:Columns("B"):ColumnWidth = 30.
chWorkSheet:Columns("C"):ColumnWidth = 20.
chWorkSheet:Columns("D"):ColumnWidth = 20.
chWorkSheet:Columns("E"):ColumnWidth = 20.
chWorkSheet:Columns("F"):ColumnWidth = 20.


chWorkSheet:Range("A1:E1"):Font:Bold = TRUE.
chWorkSheet:Range("A1"):Value = "Codigo".
chWorkSheet:Range("B1"):Value = "Nombre".
chWorkSheet:Range("C1"):Value = "Acum US$ Todas".
chWorkSheet:Range("D1"):Value = "Acum US$ Ate".
chWorkSheet:Range("E1"):Value = "Acum US$ Pen".
chWorkSheet:Range("F1"):Value = "Acum US$ Anu".

/* Iterate through the salesrep table and populate
   the Worksheet appropriately */

FOR EACH faccpedi where codcia = 1
                    and coddiv = "00000"
                    and coddoc = "COT"
                    and fchped = today
                    :
                    
find  t-codven01 where t-codven01.codven = faccpedi.codven no-lock no-error.

if not avail t-codven01 then do: 
    find gn-ven  where gn-ven.codcia = 1
                  and  gn-ven.codven = faccpedi.codven no-lock no-error.
    if not avail gn-ven then        
    message "ERROR CODIGO DE VENDEDOR NO REGISTRADO" skip
            faccpedi.codven    skip
            "CONSULTE A LA DIVSIÓN DE SISTEMAS"
            view-as alert-box . 

    create t-codven01.
    t-codven01.codven = faccpedi.codven.
    t-codven01.desven =  gn-ven.NomVen.
    t-Column = t-Column + 1.
    iColumn = t-Column.
    end.

 x-valor = Imptot.
 if codmon = 1 then x-valor = x-valor / tpocmb.
 acc-dolar = acc-dolar + x-valor.

 case flgest:
   when "A" then  acc-dolar-anu = acc-dolar-anu + x-valor.
   when "P" then  acc-dolar-pen = acc-dolar-pen + x-valor.
   when "C" then  acc-dolar-ate = acc-dolar-ate + x-valor.
   otherwise 
   message "ERROR TIPO DE ESTADO NO REGISTRADO" skip
            faccpedi.codcia coddiv coddoc nroped FLGEST   skip
            "CONSULTE A LA DIVSIÓN DE SISTEMAS"
            view-as alert-box . 
  
 end.
    
if lookup(string(codmon),"1,2") = 0 then
    message "ERROR TIPO DE MONEDA NO REGISTRADO" skip
            faccpedi.codcia coddiv coddoc nroped codmon   skip
            "CONSULTE A LA DIVSIÓN DE SISTEMAS"
            view-as alert-box.  
            
                
end.


f-Column = "F" + string(t-Column).

for each t-codven01:
    cColumn = STRING(iColumn).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = t-codven01.Codven.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = t-codven01.Desven.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = acc-dolar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = acc-dolar-ate.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = acc-dolar-pen.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = acc-dolar-anu.
    

END.

chWorkSheet:Range("C2:" + f-column):Select().
/*chExcelApplication:Selection:Style = "Currency".*/

/* create embedded chart using the data in the Worksheet */
chWorksheetRange = chWorksheet:Range("B1:" + f-Column).
chWorksheet:ChartObjects:Add(10,150,425,300):Activate.
chExcelApplication:ActiveChart:ChartWizard(chWorksheetRange, 3, 1, 2, 1, 1, TRUE,
    "Reporte De Cotizaciones", "Vendedores", "Venta Dolares").

/* create chart using the data in the Worksheet */
chChart=chExcelApplication:Charts:Add().
chChart:Name = "Grafico 1".
chChart:Type = 11.
chExcelApplication:ActiveChart:ChartWizard(chWorksheetRange, 11,,,1,, TRUE,
    "Reporte De Cotizaciones", "Vendedores", "Venta Dolares").


/*chChart:Title = "  ".*/
/*chExcelApplication:ActiveChart:ChartWizard(chWorksheetRange, 11, 1, 2, 1, 3, TRUE,
 *     "Reporte De Cotizaciones", "Vendedores", "Venta Dolares").*/

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.
RELEASE OBJECT chChart.
RELEASE OBJECT chWorksheetRange. 

