&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Importar uno o varios archivos texto a multiplas paginas en 
                  una hoja excel
    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pFilesToImport AS CHAR.
DEF INPUT PARAMETER pSheetTitles AS CHAR.
DEF INPUT PARAMETER pDeleteFiles AS LOG.

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

/* CARGAMOS EL EXCEL */
DEFINE VARIABLE  chExcelApplication AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE  chWorkbook         AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE  chWorksheet        AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE  chQueryTable       AS COM-HANDLE NO-UNDO.

DEFINE VARIABLE cConnection         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lResult             AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cFilesToImport      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSheetTitles        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iNumberOfFiles      AS INTEGER    NO-UNDO.

/* Initialize Excel, File and Title Lists */
SESSION:SET-WAIT-STATE('GENERAL').
CREATE "Excel.Application" chExcelApplication.
chExcelApplication:Workbooks:ADD.
ASSIGN
    cFilesToImport = pFilesToImport.
    cSheetTitles   = pSheetTitles.
    chWorkbook     = chExcelApplication:WorkBooks:Item(1).
   
/* Import ecah file's data into a new sheet of the workbook */
DO iNumberOfFiles = 1 TO NUM-ENTRIES(cFilesToImport).
    ASSIGN
        FILE-INFO:FILE-NAME = ENTRY(iNumberOfFiles, cFilesToImport)
        cConnection = "TEXT;" + FILE-INFO:FULL-PATHNAME
        chWorkSheet = chExcelApplication:Sheets:Item(iNumberOfFiles)
        chWorkSheet:Name = ENTRY(iNumberOfFiles, cSheetTitles)
        lResult     = chWorkSheet:QueryTables:Add(cConnection, chWorkSheet:cells(1,1)).

    ASSIGN
        chQueryTable = chWorkSheet:QueryTables(1)
        chQueryTable:FieldNames = TRUE
        chQueryTable:RowNumbers = False
        chQueryTable:FillAdjacentFormulas = False
        chQueryTable:PreserveFormatting = FALSE
        chQueryTable:RefreshOnFileOpen = FALSE
        chQueryTable:RefreshStyle = 1
        chQueryTable:SavePassword = False
        chQueryTable:SaveData = True
        chQueryTable:AdjustColumnWidth = True
        chQueryTable:RefreshPeriod = 0
        chQueryTable:TextFilePromptOnRefresh = FALSE
        chQueryTable:TextFilePlatform = 437
        chQueryTable:TextFileStartRow = 1
        chQueryTable:TextFileParseType = 1
        chQueryTable:TextFileTextQualifier = 1
        chQueryTable:TextFileConsecutiveDelimiter = False
        chQueryTable:TextFileTabDelimiter = True
        chQueryTable:TextFileSemicolonDelimiter = False
        chQueryTable:TextFileCommaDelimiter = False
        chQueryTable:TextFileSpaceDelimiter = False
        chQueryTable:TextFileTrailingMinusNumbers = True
        lResult = chQueryTable:Refresh
        chQueryTable:BackgroundQuery = False.
END.
SESSION:SET-WAIT-STATE('').
/* Make Spreadsheet Visible */
chExcelApplication:Visible = TRUE.
 
 /* Release All Objects */
 RELEASE OBJECT chQueryTable  NO-ERROR.
 RELEASE OBJECT chWorkSheet  NO-ERROR.
 RELEASE OBJECT chWorkBook   NO-ERROR.
 RELEASE OBJECT chExcelApplication NO-ERROR.

 IF pDeleteFiles THEN DO:
     DO iNumberOfFiles = 1 TO NUM-ENTRIES(cFilesToImport):
         ASSIGN
             FILE-INFO:FILE-NAME = ENTRY(iNumberOfFiles, cFilesToImport)
             cConnection = FILE-INFO:FULL-PATHNAME.
         OS-DELETE VALUE(cConnection).
     END.
 END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


