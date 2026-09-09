&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE chExcel    AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chWorksheet AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chWorkbook  AS COM-HANDLE NO-UNDO.

CREATE "excel.application" chExcel.

/* Open an Excel document  */
chExcel:Workbooks:Open("c:\temp\test1.xlsx"). 

/* Open Excel maximized */
chExcel:WindowState = -4137.

chExcel:visible = true.

/* Sets the number of sheets that will be   automatically inserted into new workbooks */
chExcel:SheetsInNewWorkbook = 5.

/* Add a new workbook */
chWorkbook = chExcel:Workbooks:Add().

/* Add a new worksheet as the last sheet */
chWorksheet = chWorkbook:Worksheets(5).
chWorkbook:Worksheets:add(, chWorksheet).
RELEASE OBJECT chWorksheet.

/* Select a worksheet */
chWorkbook:Worksheets(2):Activate.
chWorksheet = chWorkbook:Worksheets(2).

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
chWorksheet:Range("B8"):NumberFormat = 0.
chWorksheet:Range("B8"):Formula = "=SUM(B2:B7)".

/* Set horizontal alignment. Right Alignment: -4152 / Left Alignment :-4131  */
chWorksheet:Range("B:B"):HorizontalAlignment = -4152.

/* Freeze Pane */
chWorksheet:Range("A2"):SELECT.
chExcel:ActiveWindow:FreezePanes = TRUE.

/* Save the new workbook without displaying alerts */
chExcel:DisplayAlerts = FALSE.
/*chWorkbook:SaveAs("c:\temp\test2.xls",43,,,,,).*/ /* Excel 2016 no longer supports format 43 (Excel 95 & 97 .xls file) */
chWorkbook:SaveAs("c:\temp\test2.xlsx",51,,,,,). /* file format 51 = OpenXML format without macros */

/* Quit Excel */
chExcel:quit().

/* Release Com-handles used  */
RELEASE OBJECT chWorksheet.
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chExcel.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


