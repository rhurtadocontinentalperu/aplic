&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
/* Procedure Description
"Ventana de dialogo para la generaci¢n de reportes en REPORT BUILDER"
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 04/07/94 -  6:19 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                          */
&IF "{&NEW}" = "" &THEN 
    DEFINE INPUT PARAMETER R-library AS CHARACTER.
    DEFINE INPUT PARAMETER R-RunTime AS LOGICAL.
    DEFINE INPUT PARAMETER R-tipo    AS INTEGER.
    DEFINE INPUT PARAMETER R-NomRep  AS CHARACTER.
&ELSE
    DEFINE VARIABLE R-library AS CHARACTER INITIAL "liquida".
    DEFINE VARIABLE R-RunTime AS LOGICAL INITIAL TRUE.
    DEFINE VARIABLE R-tipo    AS INTEGER INITIAL 2.
    DEFINE VARIABLE R-NomRep  AS CHARACTER INITIAL "Planilla de liquidaciones".
&ENDIF
{bin/s-global.i}
{pln/s-global.i}

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE lDispError   AS LOGICAL.
DEFINE VARIABLE lStatus      AS LOGICAL.
DEFINE VARIABLE R-Database   AS CHARACTER. 
DEFINE VARIABLE cPathintegral AS CHARACTER.
DEFINE VARIABLE cArchivolk   AS CHARACTER.  
DEFINE VARIABLE lk           AS CHARACTER.
  
FILE-INFO:FILE-NAME = ".".

GET-KEY-VALUE SECTION "Planillas" KEY "Directorio de programas" VALUE cPathintegral.

CASE R-TIPO :
    WHEN 1 THEN
        R-library = cPathintegral + "Reporte\SEM\" + R-Library + ".prl".
    WHEN 2 THEN
        R-library = cPathintegral + "Reporte\MES\" + R-Library + ".prl".
    WHEN 3 THEN
        R-library = cPathintegral + "Reporte\S-M\" + R-Library + ".prl".
END CASE.

/* R-Database = PDBNAME("DB-WORK"). */
R-Database = SESSION:TEMP-DIRECTORY + "db-work.db".

IF CONNECTED("db-work") THEN DISCONNECT db-work.
lk = R-Database + ".lk".
FILE-INFO:FILE-NAME = lk.
cArchivolk = FILE-INFO:FULL-PATHNAME.
IF lk = cArchivolk THEN OS-DELETE VALUE(lk).
IF NOT R-RunTime THEN DO:
    RUN Run-Developer.
    RETURN.
END.

DEFINE VARIABLE cPrinter-list AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPort-list AS CHARACTER NO-UNDO.
DEFINE VARIABLE iPrinter-count AS INTEGER NO-UNDO.
DEFINE VARIABLE lOk AS LOGICAL NO-UNDO.
DEFINE VARIABLE cPrinter-Port AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-1 RECT-1 R-Report RS-Printer ~
F-NumberCopies R-PageBeg R-PageEnd COMBO-print R-OutputFile B-Output Exit ~
R-Run R-Include 
&Scoped-Define DISPLAYED-OBJECTS R-Report RS-Printer F-NumberCopies ~
R-PageBeg R-PageEnd COMBO-print R-OutputFile R-Include 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-Output 
     LABEL "Archivo ...":L 
     SIZE 10 BY .81.

DEFINE BUTTON Exit 
     IMAGE-UP FILE "img/b-cancel":U
     LABEL "":L 
     SIZE 12 BY 1.81.

DEFINE BUTTON R-Run 
     IMAGE-UP FILE "img/b-ok":U
     LABEL "":L 
     SIZE 12 BY 1.81.

DEFINE VARIABLE COMBO-print AS CHARACTER FORMAT "X(256)":U 
     LABEL "Impresoras" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 44 BY 1 NO-UNDO.

DEFINE VARIABLE R-Report AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre del Reporte" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 59 BY 1
     BGCOLOR 15 .

DEFINE VARIABLE F-NumberCopies AS INTEGER FORMAT "->>,>>9":U INITIAL 0 
     LABEL "No. Copias" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81
     BGCOLOR 15 .

DEFINE VARIABLE R-OutputFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "Archivo" 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81
     BGCOLOR 15 .

DEFINE VARIABLE R-PageBeg AS INTEGER FORMAT "->>,>>9":U INITIAL 0 
     LABEL "Desde P gina" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81
     BGCOLOR 15 .

DEFINE VARIABLE R-PageEnd AS INTEGER FORMAT "->>,>>9":U INITIAL 0 
     LABEL "Hasta P gina" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81
     BGCOLOR 15 .

DEFINE IMAGE IMAGE-1
     FILENAME "img\continental":U CONVERT-3D-COLORS
     SIZE 48 BY 3.46.

DEFINE VARIABLE R-Include AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Usar el filtro configurado", 1,
"Usar el Filtro de ejecución", 4
     SIZE 20.86 BY 1.38.

DEFINE VARIABLE RS-Printer AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 1,
"Impresora", 2,
"Archivo", 3
     SIZE 9.72 BY 2.69.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75.86 BY 11.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     R-Report AT ROW 4.85 COL 15.57 COLON-ALIGNED
     RS-Printer AT ROW 6.77 COL 3 NO-LABEL
     F-NumberCopies AT ROW 6.77 COL 19
     R-PageBeg AT ROW 6.77 COL 34.29
     R-PageEnd AT ROW 6.85 COL 51.15
     COMBO-print AT ROW 7.73 COL 20 COLON-ALIGNED
     R-OutputFile AT ROW 8.69 COL 16
     B-Output AT ROW 8.69 COL 67
     Exit AT ROW 10.62 COL 64.57
     R-Run AT ROW 10.65 COL 50.86
     R-Include AT ROW 10.77 COL 3.43 NO-LABEL
     " Opciones de Impresi¢n:" VIEW-AS TEXT
          SIZE 74 BY .65 AT ROW 5.96 COL 3
          BGCOLOR 1 FGCOLOR 15 
     " Opciones del Reporte:" VIEW-AS TEXT
          SIZE 74 BY .65 AT ROW 9.85 COL 3
          BGCOLOR 1 FGCOLOR 15 
     IMAGE-1 AT ROW 1.38 COL 15
     RECT-1 AT ROW 1.23 COL 1.86
     SPACE(0.70) SKIP(0.26)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS THREE-D  SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 FONT 4
         TITLE "Reportes de Planilla":L.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DIALOG-1
   FRAME-NAME UNDERLINE                                                 */
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN F-NumberCopies IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN R-OutputFile IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN R-PageBeg IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN R-PageEnd IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DIALOG-1 DIALOG-1
ON WINDOW-CLOSE OF FRAME DIALOG-1 /* Reportes de Planilla */
DO:
    APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Output
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Output DIALOG-1
ON CHOOSE OF B-Output IN FRAME DIALOG-1 /* Archivo ... */
DO:
    DEFINE VARIABLE name    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE bPicked AS LOGICAL NO-UNDO.

    SYSTEM-DIALOG GET-FILE
        NAME
        FILTERS           "*.txt" "*.txt" /* Filter                 */
        DEFAULT-EXTENSION "*.txt"         /* default-extensions     */
        TITLE             "Archivo(s) de Reporte"
        MUST-EXIST
        UPDATE bPicked.

    IF bPicked THEN R-OutputFile:SCREEN-VALUE = NAME.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-Run
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-Run DIALOG-1
ON CHOOSE OF R-Run IN FRAME DIALOG-1
DO:
    DEFINE VARIABLE cPrinter   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iCopies    AS INTEGER NO-UNDO.
    DEFINE VARIABLE iBegPage   AS INTEGER NO-UNDO.
    DEFINE VARIABLE iEndPage   AS INTEGER NO-UNDO.
    DEFINE VARIABLE lDispError AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lStatus    AS LOGICAL NO-UNDO.
    DEFINE VARIABLE cInclude   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cConnect   AS CHARACTER NO-UNDO.

    cPrinter = IF (RS-Printer:SCREEN-VALUE = "1") THEN "D"
        ELSE IF (RS-Printer:SCREEN-VALUE = "2") THEN " " ELSE "A".
    iCopies = INTEGER (F-NumberCopies:SCREEN-VALUE).
    iBegPage = INTEGER (R-PageBeg:SCREEN-VALUE).
    iEndPage = INTEGER (R-PageEnd:SCREEN-VALUE).
    lDispError = TRUE.
    lStatus = TRUE.
    cInclude = IF (R-Include:SCREEN-VALUE = "1") THEN "S"
        ELSE IF (R-Include:SCREEN-VALUE = "2") THEN "O"
            ELSE if (R-Include:SCREEN-VALUE = "3") THEN "E" ELSE "?".

    cConnect = "-db " + R-Database + " -1 -ld db-work -d dmy".
    
    DEFINE VAR X-UIT AS DECI INIT 0.
    FIND LAST integral.PL-VAR-MES WHERE
         integral.PL-VAR-MES.Periodo = s-Periodo AND
         integral.PL-VAR-MES.NroMes  = S-NROMES NO-LOCK.    
    X-UIT = integral.PL-VAR-MES.ValVar-Mes[2] * 7 .
    /* OJO CON ESTE PARCHE RHC 01.12.04 */
    IF R-Report:SCREEN-VALUE = 'BOLETA BENEFICIOS SOCIALES NEW'
    THEN cConnect = "db-work = -db " + R-Database + " -1 -ld db-work -d dmy".
    /* ******************************** */
/*MLR* 17/12/07 ***
    RUN aderb/_printrb.p(
        R-library,                   /* RB-REPORT-LIBRARY    */
        R-Report:SCREEN-VALUE,       /* RB-REPORT-NAME       */
        cConnect,                    /* RB-DB-CONNECTION     */
        cInclude,                    /* RB-INCLUDE-RECORDS   */
        "",                          /* RB-FILTER            */
        "",                          /* RB-MEMO-FILE         */
        cPrinter,                    /* RB-PRINT-DESTINATION */
        ?,                           /* RB-PRINTER-NAME      */
        "",                          /* RB-PRINTER-PORT      */
        R-OutputFile:SCREEN-VALUE,   /* RB-OUTPUT-FILE       */
        iCopies,                     /* RB-NUMBER-COPIES     */
        iBegPage,                    /* RB-BEGIN-PAGE        */
        iEndPage,                    /* RB-END-PAGE          */
        FALSE,                       /* RB-TEST-PATTERN      */
        R-Report:SCREEN-VALUE,       /* RB-WINDOW-TITLE      */
        lDispError,                  /* RB-DISPLAY-ERRORS    */
        lStatus,                     /* RB-DISPLAY-STATUS    */
        FALSE,                       /* RB-NO-WAIT           */
        "s-periodo = " + string(s-periodo,"9999") +         /* RB-OTHER-PARAMETERS  */
        "~nx-uit = " + string(x-uit)   /*string(x-uit,">,>>>,>>9.99")*/
        ).
* ***/
/*MLR* 17/12/07 */
    ASSIGN COMBO-print.
    IF COMBO-print <> "" THEN DO:
        cPrinter-port = ENTRY(LOOKUP(COMBO-print,cPrinter-list),cPort-list).
    END.
    RUN aderb/_prntrb2.p(
        R-library,                   /* RB-REPORT-LIBRARY    */
        R-Report:SCREEN-VALUE,       /* RB-REPORT-NAME       */
        cConnect,                    /* RB-DB-CONNECTION     */
        cInclude,                    /* RB-INCLUDE-RECORDS   */
        "",                          /* RB-FILTER            */
        "",                          /* RB-MEMO-FILE         */
        cPrinter,                    /* RB-PRINT-DESTINATION */
        "",                          /* RB-PRINTER-NAME      */
        cPrinter-Port,               /* RB-PRINTER-PORT      */
        R-OutputFile:SCREEN-VALUE,   /* RB-OUTPUT-FILE       */
        iCopies,                     /* RB-NUMBER-COPIES     */
        iBegPage,                    /* RB-BEGIN-PAGE        */
        iEndPage,                    /* RB-END-PAGE          */
        FALSE,                       /* RB-TEST-PATTERN      */
        R-Report:SCREEN-VALUE,       /* RB-WINDOW-TITLE      */
        lDispError,                  /* RB-DISPLAY-ERRORS    */
        lStatus,                     /* RB-DISPLAY-STATUS    */
        FALSE,                       /* RB-NO-WAIT           */
        "s-periodo = " + string(s-periodo,"9999") +     /* RB-OTHER-PARAMETERS  */
        "~nx-uit = " + string(x-uit),
        ""
        ).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RS-Printer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RS-Printer DIALOG-1
ON VALUE-CHANGED OF RS-Printer IN FRAME DIALOG-1
DO:
    IF RS-Printer:SCREEN-VALUE = '1' THEN  /* output to screen */
        ASSIGN
            F-NumberCopies:sensitive = FALSE
            R-PageBeg:sensitive      = TRUE
            R-PageEnd:sensitive      = TRUE
            R-OutputFile:sensitive   = FALSE
            B-Output:sensitive       = FALSE
            COMBO-print:sensitive    = TRUE.
    ELSE
        IF RS-Printer:SCREEN-VALUE = '2' THEN /* Output to Printer */
            ASSIGN
                F-NumberCopies:sensitive = TRUE
                R-PageBeg:sensitive      = TRUE
                R-PageEnd:sensitive      = TRUE
                R-OutputFile:sensitive   = FALSE
                B-Output:sensitive       = FALSE
                COMBO-print:sensitive    = TRUE.
        ELSE                                      /* Output to File */
            ASSIGN
                F-NumberCopies:sensitive = FALSE
                R-PageBeg:sensitive      = FALSE
                R-PageEnd:sensitive      = FALSE   
                R-PageEnd:SCREEN-VALUE   = "0"
                R-PageBeg:SCREEN-VALUE   = "0"
                R-OutputFile:sensitive   = TRUE
                B-Output:sensitive       = TRUE
                COMBO-print:sensitive    = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DIALOG-1 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent    */
IF VALID-HANDLE(ACTIVE-WINDOW)AND FRAME {&FRAME-NAME}:PARENT eq ?
  THEN  FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN enable_UI.
    RUN fill-report-list.
    WAIT-FOR CHOOSE OF Exit IN FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DIALOG-1  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME DIALOG-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DIALOG-1  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY R-Report RS-Printer F-NumberCopies R-PageBeg R-PageEnd COMBO-print 
          R-OutputFile R-Include 
      WITH FRAME DIALOG-1.
  ENABLE IMAGE-1 RECT-1 R-Report RS-Printer F-NumberCopies R-PageBeg R-PageEnd 
         COMBO-print R-OutputFile B-Output Exit R-Run R-Include 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fill-report-list DIALOG-1 
PROCEDURE fill-report-list :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE VARIABLE cName AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iCount AS INTEGER NO-UNDO.

    DO WITH FRAME DIALOG-1:
        RUN aderb/_getname.p(R-Library, output cName, output iCount).
        R-Report:SENSITIVE    = yes.
        R-Report:LIST-ITEMS   = cName.
        R-Report:SCREEN-VALUE = ENTRY (1,cName).
        IF r-NomRep <> "" AND LOOKUP( r-NomRep, cName ) <> 0 THEN
            R-Report:SCREEN-VALUE = r-NomRep.
        APPLY 'VALUE-CHANGED':U TO RS-Printer.
        RUN aderb/_prlist(
            OUTPUT cPrinter-list,
            OUTPUT cPort-list,
            OUTPUT iPrinter-count).
        IF iPrinter-count = 0 THEN DO:
            MESSAGE
                "No existen impresoras configuradas"
                VIEW-AS ALERT-BOX WARNING.
        END.
        ELSE DO:
            DO iPrinter-count = 1 TO NUM-ENTRIES(cPrinter-list):
                lOk = COMBO-print:ADD-LAST(ENTRY(iPrinter-count,cPrinter-list)).
            END.
            /* Captura Impresora por Defecto */
            RUN aderb/_prdef.p(
                OUTPUT COMBO-print,
                OUTPUT cPrinter-port,
                OUTPUT lOk
                ).
            IF NOT lOk THEN DO:
                COMBO-print = ENTRY(1,COMBO-print:LIST-ITEMS).
                cPrinter-port = ENTRY(1,cPort-list).
            END.
            DISPLAY COMBO-print.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Run-Developer DIALOG-1 
PROCEDURE Run-Developer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cProgName AS CHARACTER.
    DEFINE VARIABLE cConnect  AS CHARACTER.
    DEFINE VARIABLE cPath     AS CHARACTER.
    PUT-KEY-VALUE SECTION "ReportBuilderSaveList" KEY "Library" VALUE R-Library.
    PUT-KEY-VALUE SECTION "ReportBuilderSaveList" KEY "Report" VALUE "".
    FILE-INFO:FILE-NAME = ".".
    cPath = FILE-INFO:FULL-PATHNAME.

    cConnect = " -db " + R-Database + " -1 -ld db-work -ininame " + cPath + "\ON_AT_CO_213.INI -d dmy".
    cProgName = "PRORB32 " + cConnect.
    RUN ProExec (cProgName, INPUT 1, 1, INPUT 5). /* 1=normal 2=minimized */
END PROCEDURE.

PROCEDURE ProExec EXTERNAL "PROEXEC.DLL": 
    DEFINE INPUT PARAMETER prog_name AS CHARACTER. 
    DEFINE INPUT PARAMETER prog_style AS SHORT. 
    DEFINE INPUT PARAMETER wait_for_me as SHORT.
    DEFINE INPUT PARAMETER num_seconds as SHORT.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

