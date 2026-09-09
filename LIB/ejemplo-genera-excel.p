DEFINE VARIABLE chExcel    AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chWorksheet AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chWorkbook  AS COM-HANDLE NO-UNDO.

CREATE "excel.application" chExcel.

/* Open an Excel document  */

chExcel:Workbooks:Open("c:\test1.xls").
chExcel:visible = true.

/* Sets the number of sheets that will be
  automatically inserted into new workbooks */

chExcel:SheetsInNewWorkbook = 5.

/* Add a new workbook */

chWorkbook = chExcel:Workbooks:Add().

/* Add a new worksheet as the last sheet */

chWorksheet = chWorkbook:Worksheets(5).
chWorkbook:Worksheets:add(, chWorksheet).
RELEASE OBJECT chWorksheet.

/* Select a worksheet */

chWorkbook:Worksheets(2):Activate.
chWorksheet =  chWorkbook:Worksheets(2).

/* Rename the worksheet */

chWorkSheet:NAME = "test".

/* Modify the cell's format to Text */     

chWorksheet:Cells:NumberFormat = "@".
 

/* Modify the cell's format to Date */     

chWorksheet:Cells:NumberFormat = "m/d/yy;@".

/* Change the cell's color */

chWorksheet:Columns("A:A"):Interior:ColorIndex = 5.

/* Change the cell's format  */

ASSIGN
  chWorksheet:Columns("A:A"):Font:ColorIndex = 2
  chWorksheet:Columns("A:A"):Font:Name = "Courrier New".
  chWorksheet:Columns("A:A"):Font:Bold = TRUE.
  chWorksheet:Columns("A:A"):Font:Italic = TRUE.

/* Set underline: StyleSingle = 2 */

chWorksheet:Columns("A:A"):FONT:UNDERLINE = 2 .

/* Add data */

ASSIGN
  chWorksheet:Range("B1"):VALUE = "Value"
  chWorksheet:Range("B2"):VALUE = 255
  chWorksheet:Range("B3"):VALUE = 100
  chWorksheet:Range("B4"):VALUE = 250
  chWorksheet:Range("B5"):VALUE = 400
  chWorksheet:Range("B6"):VALUE = 100
  chWorksheet:Range("B7"):VALUE = 600.

/* Add a Formula */

chWorksheet:Range("A8"):VALUE = "Total:".

/* Set Cell's format to Number */

chWorksheet:Range("B8"):NumberFormat = 0.
chWorksheet:Range("B8"):Formula = "=SUM(B2:B7)".

/* Set horizontal alignment
  Right Alignment: -4152 / Left Alignment :-4131  */

chWorksheet:Range("B:B"):HorizontalAlignment = -4152.

/* Freeze Pane */

chWorksheet:Range("A2"):SELECT.
chExcel:ActiveWindow:FreezePanes = TRUE.

/* Save the new workbook without displaying alerts */

chExcel:DisplayAlerts = FALSE.
chWorkbook:SaveAs("c:\test2.xls",43,,,,,).

/* Quit Excel */

chExcel:quit().

/* Release Com-handle  */

RELEASE OBJECT chWorksheet.
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chExcel.
