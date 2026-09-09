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

/* Parámetros:
vcFields: etiquetas de los valoes separados por comas
vcValues: valores separados por comas 
*/
/* DEFINE VARIABLE vcFields AS CHARACTER NO-UNDO INITIAL "Internet Explorer,Netscape,Others":U. */
/* DEFINE VARIABLE vcValues AS CHARACTER NO-UNDO INITIAL "45%,40%,15%":U.                       */
DEF INPUT PARAMETER vcFields AS CHAR.
DEF INPUT PARAMETER vcValues AS CHAR.
DEF INPUT PARAMETER vcTitle  AS CHAR.

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

DEFINE VARIABLE vchExcel AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE vchWorkBook AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE vchWorkSheet AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE vchChart AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE viCounter AS INTEGER NO-UNDO.
DEFINE VARIABLE viRows AS INTEGER NO-UNDO.


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
    /* Exploted Pie 3D = 70 */
    vchChart:HasTitle = TRUE.

vchChart:ChartTitle:Characters:Text = vcTitle.
vchChart:SetSourceData(vchWorkSheet:Range("A1:B":U + STRING(viRows)), 2).
vchChart:ApplyDataLabels(5 /* xlDataLabelsShowLabelAndPercent = 5 */).
/*vchChart:Location(2 /* xlLocationAsObject = 2 */, "Sheet1":U).*/

IF VALID-HANDLE(vchChart)       THEN RELEASE OBJECT vchChart.
IF VALID-HANDLE(vchWorkSheet)   THEN RELEASE OBJECT vchWorkSheet.
IF VALID-HANDLE(vchWorkBook)    THEN RELEASE OBJECT vchWorkBook.
IF VALID-HANDLE(vchExcel)       THEN RELEASE OBJECT vchExcel.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


