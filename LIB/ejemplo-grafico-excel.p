DEFINE VARIABLE vchExcel AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE vchWorkBook AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE vchWorkSheet AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE vchChart AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE viCounter AS INTEGER NO-UNDO.
DEFINE VARIABLE viRows AS INTEGER NO-UNDO.
DEFINE VARIABLE vcFields AS CHARACTER NO-UNDO INITIAL "Internet Explorer,Netscape,Others":U.
DEFINE VARIABLE vcValues AS CHARACTER NO-UNDO INITIAL "45%,40%,15%":U.

CREATE "Excel.Application":U vchExcel.
ASSIGN
vchExcel:VISIBLE = TRUE
vchWorkBook = vchExcel:Workbooks:ADD
vchWorkSheet = vchExcel:Sheets:Item(1).

viRows = NUM-ENTRIES(vcFields).

REPEAT viCounter = 1 TO viRows:
vchWorkSheet:Range("A":U + STRING(viCounter)):VALUE = ENTRY(viCounter, vcFields).
vchWorkSheet:Range("B":U + STRING(viCounter)):VALUE = ENTRY(viCounter, vcValues).
END.

ASSIGN
vchChart = vchWorkBook:Charts:Add()
vchChart:ChartType = -4102 /* xl3DPie = -4102 */
vchChart:HasTitle = TRUE.

vchChart:ChartTitle:Characters:Text = "Web Browser Market":U.
vchChart:SetSourceData(vchWorkSheet:Range("A1:B":U + STRING(viRows)), 2).
vchChart:ApplyDataLabels(5 /* xlDataLabelsShowLabelAndPercent = 5 */).
vchChart:Location(2 /* xlLocationAsObject = 2 */, "Sheet1":U).

IF VALID-HANDLE(vchChart) THEN
RELEASE OBJECT vchChart.
IF VALID-HANDLE(vchWorkSheet) THEN
RELEASE OBJECT vchWorkSheet.
IF VALID-HANDLE(vchWorkBook) THEN
RELEASE OBJECT vchWorkBook.
IF VALID-HANDLE(vchExcel) THEN
RELEASE OBJECT vchExcel.
