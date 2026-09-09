&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-CODDIV AS CHARACTER.

/* Local Variable Definitions ---                                       */
DEF TEMP-TABLE DETALLE LIKE Ccbccaja
    INDEX Llave01 IS PRIMARY coddoc coddiv fchcie.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 x-FchCie-1 x-FchCie-2 Btn_OK ~
Btn_Cancel Btn_Excel 
&Scoped-Define DISPLAYED-OBJECTS F-Division x-FchCie-1 x-FchCie-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_Excel AUTO-GO 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE VARIABLE F-Division AS CHARACTER FORMAT "X(60)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE x-FchCie-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Cerrados desde el" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchCie-2 AS DATE FORMAT "99/99/99":U 
     LABEL "hasta el" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-Division AT ROW 1.58 COL 13 COLON-ALIGNED
     BUTTON-1 AT ROW 1.58 COL 59
     x-FchCie-1 AT ROW 2.54 COL 13 COLON-ALIGNED
     x-FchCie-2 AT ROW 3.5 COL 13 COLON-ALIGNED
     Btn_OK AT ROW 4.65 COL 4
     Btn_Cancel AT ROW 4.65 COL 16
     Btn_Excel AT ROW 4.65 COL 28 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "RESUMEN DE CIERRES DE CAJA"
         HEIGHT             = 5.77
         WIDTH              = 71.43
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN F-Division IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* RESUMEN DE CIERRES DE CAJA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* RESUMEN DE CIERRES DE CAJA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Excel W-Win
ON CHOOSE OF Btn_Excel IN FRAME F-Main /* Aceptar */
DO:
  ASSIGN f-division x-fchcie-1 x-fchcie-2.
  IF f-division = '' THEN DO:
    MESSAGE 'Ingrese al menos una division' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  RUN Carga-Temporal.
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  ASSIGN f-division x-fchcie-1 x-fchcie-2.
  IF f-division = '' THEN DO:
    MESSAGE 'Ingrese al menos una division' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  RUN IMPRIMIR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:
  DEF VAR x-Divisiones AS CHAR.
  x-Divisiones = f-Division:SCREEN-VALUE.
  RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
  f-Division:SCREEN-VALUE = x-Divisiones.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Division W-Win
ON LEAVE OF F-Division IN FRAME F-Main /* Division */
DO:
/*    Find gn-divi where gn-divi.codcia = s-codcia and gn-divi.coddiv = F-Division:screen-value no-lock no-error.
 *     If available gn-divi then
 *         F-DesDiv:screen-value = gn-divi.desdiv.
 *     else
 *         F-DesDiv:screen-value = "".*/
    ASSIGN F-Division.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR i AS INT NO-UNDO.
  DEF VAR x-CodDiv LIKE GN-DIVI.CodDiv NO-UNDO.
  
  EMPTY TEMP-TABLE Detalle.
  DO i = 1 TO NUM-ENTRIES(f-Division):
    x-CodDiv = ENTRY(i, f-Division).
    FOR EACH Ccbccaja NO-LOCK WHERE Ccbccaja.codcia = s-codcia
            AND Ccbccaja.coddiv = x-coddiv
            AND Ccbccaja.flgcie = 'C'
            AND Ccbccaja.fchcie >= x-fchcie-1
            AND Ccbccaja.fchcie <= x-fchcie-2:
        FIND Detalle WHERE Detalle.codcia = Ccbccaja.codcia
            AND Detalle.coddoc = Ccbccaja.coddoc
            AND Detalle.coddiv = Ccbccaja.coddiv
            AND Detalle.fchcie = Ccbccaja.fchcie
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Detalle THEN DO:
            CREATE Detalle.
            ASSIGN
                Detalle.codcia = Ccbccaja.codcia
                Detalle.coddoc = Ccbccaja.coddoc
                Detalle.coddiv = Ccbccaja.coddiv
                Detalle.fchcie = Ccbccaja.fchcie.
        END.
        ASSIGN
            Detalle.impnac[1] = Detalle.impnac[1] + Ccbccaja.impnac[1]
            Detalle.impnac[2] = Detalle.impnac[2] + Ccbccaja.impnac[2] 
            Detalle.impnac[3] = Detalle.impnac[3] + Ccbccaja.impnac[3]
            Detalle.impnac[5] = Detalle.impnac[5] + Ccbccaja.impnac[5]
            Detalle.impnac[6] = Detalle.impnac[6] + Ccbccaja.impnac[6]
            Detalle.impusa[1] = Detalle.impusa[1] + Ccbccaja.impusa[1]
            Detalle.impusa[2] = Detalle.impusa[2] + Ccbccaja.impusa[2]
            Detalle.impusa[3] = Detalle.impusa[3] + Ccbccaja.impusa[3]
            Detalle.impusa[5] = Detalle.impusa[5] + Ccbccaja.impusa[5]
            Detalle.impusa[6] = Detalle.impusa[6] + Ccbccaja.impusa[6]
            Detalle.vuenac    = Detalle.vuenac + Ccbccaja.vuenac.
    END.            
  END.
                  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY F-Division x-FchCie-1 x-FchCie-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 x-FchCie-1 x-FchCie-2 Btn_OK Btn_Cancel Btn_Excel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
ASSIGN
    chWorkSheet:Range("A1"):Value = CAPS(s-nomcia) + " - RESUMEN DE CIERRES DE CAJA" 
    chWorkSheet:Range("A2"):Value = "DEL " + STRING(x-FchCie-1,"99/99/9999") + " AL " + STRING(x-FchCie-2,"99/99/9999")
    chWorkSheet:Range("A3"):Value = "Doc"
    chWorkSheet:Range("B3"):Value = "División"
    chWorkSheet:Range("C3"):Value = "Cierre"
    chWorkSheet:Range("D3"):Value = "Efectivo S/."
    chWorkSheet:Range("E3"):Value = "Efectivo US$"
    chWorkSheet:Range("F3"):Value = "Cheque S/."
    chWorkSheet:Range("G3"):Value = "Cheque US$"
    chWorkSheet:Range("H3"):Value = "Cheque Diferido S/."
    chWorkSheet:Range("I3"):Value = "Cheque Diferido US$"
    chWorkSheet:Range("J3"):Value = "Depósitos S/."
    chWorkSheet:Range("K3"):Value = "Depósitos US$"
    chWorkSheet:Range("L3"):Value = "Otros S/."
    chWorkSheet:Range("M3"):Value = "Otrs US$"
    chWorkSheet:Range("N3"):Value = "Vuelto S/."
    chWorkSheet:Columns("B"):NumberFormat = "@"
    chWorkSheet:Columns("C"):NumberFormat = "dd/mm/yyyy"
    .
ASSIGN
    t-Row = 3.
FOR EACH Detalle BREAK BY Detalle.coddoc DESC BY Detalle.coddiv BY Detalle.fchdoc:
    ACCUMULATE Detalle.impnac[1] (TOTAL BY Detalle.coddoc).
    ACCUMULATE Detalle.impnac[2] (TOTAL BY Detalle.coddoc).
    ACCUMULATE Detalle.impnac[3] (TOTAL BY Detalle.coddoc).
    ACCUMULATE Detalle.impnac[5] (TOTAL BY Detalle.coddoc).
    ACCUMULATE Detalle.impnac[6] (TOTAL BY Detalle.coddoc).
    ACCUMULATE Detalle.impusa[1] (TOTAL BY Detalle.coddoc).
    ACCUMULATE Detalle.impusa[2] (TOTAL BY Detalle.coddoc).
    ACCUMULATE Detalle.impusa[3] (TOTAL BY Detalle.coddoc).
    ACCUMULATE Detalle.impusa[5] (TOTAL BY Detalle.coddoc).
    ACCUMULATE Detalle.impusa[6] (TOTAL BY Detalle.coddoc).
    ACCUMULATE Detalle.vuenac    (TOTAL BY Detalle.coddoc).
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.coddoc.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.coddiv.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.fchcie.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.impnac[1].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.impusa[1].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.impnac[2].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.impusa[2].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.impnac[3].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.impusa[3].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.impnac[5].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.impusa[5].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.impnac[6].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.impusa[6].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.vuenac.
    IF LAST-OF(Detalle.coddoc) THEN DO:
        ASSIGN
            t-Column = 3
            t-Row    = t-Row + 1.
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = ACCUM TOTAL BY Detalle.coddoc Detalle.impnac[1].
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = ACCUM TOTAL BY Detalle.coddoc Detalle.impusa[1].
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = ACCUM TOTAL BY Detalle.coddoc Detalle.impnac[2].
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = ACCUM TOTAL BY Detalle.coddoc Detalle.impusa[2].
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = ACCUM TOTAL BY Detalle.coddoc Detalle.impnac[3].
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = ACCUM TOTAL BY Detalle.coddoc Detalle.impusa[3].
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = ACCUM TOTAL BY Detalle.coddoc Detalle.impnac[5].
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = ACCUM TOTAL BY Detalle.coddoc Detalle.impusa[5].
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = ACCUM TOTAL BY Detalle.coddoc Detalle.impnac[6].
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = ACCUM TOTAL BY Detalle.coddoc Detalle.impusa[6].
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = ACCUM TOTAL BY Detalle.coddoc Detalle.vuenac.
    END.    
END.
chExcelApplication:VISIBLE = TRUE.
/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE FRAME F-Titulo
    HEADER
    S-NOMCIA FORMAT "X(45)" 
    "PAG.  : " AT 103 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
    "FECHA : " AT 115 TODAY SKIP(2)
  WITH PAGE-TOP NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN.

  DEFINE FRAME F-Detalle
    Detalle.coddoc      FORMAT 'x(3)'       COLUMN-LABEL 'Doc'
    Detalle.coddiv      FORMAT 'x(6)'       COLUMN-LABEL 'Division'
    Detalle.fchcie                          COLUMN-LABEL 'Cierre'
    Detalle.impnac[1]   FORMAT '->>>>,>>9.99' COLUMN-LABEL 'Efectivo!S/.'
    Detalle.impusa[1]   FORMAT '->>>>,>>9.99' COLUMN-LABEL 'Efectivo!US$'
    Detalle.impnac[2]   FORMAT '->>>>,>>9.99' COLUMN-LABEL 'Cheque!S/.'
    Detalle.impusa[2]   FORMAT '->>>>,>>9.99' COLUMN-LABEL 'Cheque!US$'
    Detalle.impnac[3]   FORMAT '->>>>,>>9.99' COLUMN-LABEL 'Cheque!Diferido!S/.'
    Detalle.impusa[3]   FORMAT '->>>>,>>9.99' COLUMN-LABEL 'Cheque!Diferido!US$'
    Detalle.impnac[5]   FORMAT '->>>>,>>9.99' COLUMN-LABEL 'Depósitos!S/.'
    Detalle.impusa[5]   FORMAT '->>>>,>>9.99' COLUMN-LABEL 'Depósitos!US$'
    Detalle.impnac[6]   FORMAT '->>>>,>>9.99' COLUMN-LABEL 'Otros!S/.'
    Detalle.impusa[6]   FORMAT '->>>>,>>9.99' COLUMN-LABEL 'Otros!US$'
    Detalle.vuenac      FORMAT '->>>>,>>9.99' COLUMN-LABEL 'Vuelto!S/.'
  WITH NO-BOX WIDTH 200 STREAM-IO DOWN.

 FOR EACH Detalle BREAK BY Detalle.coddoc DESC BY Detalle.coddiv BY Detalle.fchdoc:
    VIEW STREAM REPORT FRAME F-Titulo.
    DISPLAY STREAM REPORT 
        Detalle.coddoc
        Detalle.coddiv
        Detalle.fchcie
        Detalle.impnac[1]
        Detalle.impusa[1]
        Detalle.impnac[2]
        Detalle.impusa[2]
        Detalle.impnac[3]
        Detalle.impusa[3]
        Detalle.impnac[5]
        Detalle.impusa[5]
        Detalle.impnac[6]
        Detalle.impusa[6]
        Detalle.vuenac
    WITH FRAME F-Detalle.
    ACCUMULATE Detalle.impnac[1] (TOTAL BY Detalle.coddoc).
    ACCUMULATE Detalle.impnac[2] (TOTAL BY Detalle.coddoc).
    ACCUMULATE Detalle.impnac[3] (TOTAL BY Detalle.coddoc).
    ACCUMULATE Detalle.impnac[5] (TOTAL BY Detalle.coddoc).
    ACCUMULATE Detalle.impnac[6] (TOTAL BY Detalle.coddoc).
    ACCUMULATE Detalle.impusa[1] (TOTAL BY Detalle.coddoc).
    ACCUMULATE Detalle.impusa[2] (TOTAL BY Detalle.coddoc).
    ACCUMULATE Detalle.impusa[3] (TOTAL BY Detalle.coddoc).
    ACCUMULATE Detalle.impusa[5] (TOTAL BY Detalle.coddoc).
    ACCUMULATE Detalle.impusa[6] (TOTAL BY Detalle.coddoc).
    ACCUMULATE Detalle.vuenac    (TOTAL BY Detalle.coddoc).
    IF LAST-OF(Detalle.coddoc) THEN DO:
        UNDERLINE STREAM REPORT
            Detalle.impnac[1]
            Detalle.impusa[1]
            Detalle.impnac[2]
            Detalle.impusa[2]
            Detalle.impnac[3]
            Detalle.impusa[3]
            Detalle.impnac[5]
            Detalle.impusa[5]
            Detalle.impnac[6]
            Detalle.impusa[6]
            Detalle.vuenac
        WITH FRAME F-Detalle.
        DISPLAY STREAM REPORT
            ACCUM TOTAL BY Detalle.coddoc Detalle.impnac[1] @ Detalle.impnac[1]
            ACCUM TOTAL BY Detalle.coddoc Detalle.impnac[2] @ Detalle.impnac[2]
            ACCUM TOTAL BY Detalle.coddoc Detalle.impnac[3] @ Detalle.impnac[3]
            ACCUM TOTAL BY Detalle.coddoc Detalle.impnac[5] @ Detalle.impnac[5]
            ACCUM TOTAL BY Detalle.coddoc Detalle.impnac[6] @ Detalle.impnac[6]
            ACCUM TOTAL BY Detalle.coddoc Detalle.impusa[1] @ Detalle.impusa[1]
            ACCUM TOTAL BY Detalle.coddoc Detalle.impusa[2] @ Detalle.impusa[2]
            ACCUM TOTAL BY Detalle.coddoc Detalle.impusa[3] @ Detalle.impusa[3]
            ACCUM TOTAL BY Detalle.coddoc Detalle.impusa[5] @ Detalle.impusa[5]
            ACCUM TOTAL BY Detalle.coddoc Detalle.impusa[6] @ Detalle.impusa[6]
            ACCUM TOTAL BY Detalle.coddoc Detalle.vuenac    @ Detalle.vuenac
        WITH FRAME F-Detalle.
        DOWN STREAM REPORT 1 WITH FRAME F-Detalle.
    END.    
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.   

    RUN Carga-Temporal.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 60.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 60. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
        PAGE STREAM REPORT .
        OUTPUT STREAM REPORT CLOSE.
    END.
    OUTPUT STREAM REPORT CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN
    x-FchCie-1 = TODAY
    x-FchCie-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

