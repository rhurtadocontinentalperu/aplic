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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
DEF VAR cl-codcia AS INT.

DEF VAR RB-REPORT-LIBRARY AS CHAR.  /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.     /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR. /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.  /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     /* Otros parametros */

FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.



/*MLR* 04/Jun/2008 ***
GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb/rbccb.prl".
*MLR* ***/

DEFINE VARIABLE dImpLCred LIKE Gn-ClieL.ImpLC COLUMN-LABEL "Línea de!Crédito" NO-UNDO.
DEFINE VARIABLE lEnCampan AS LOGICAL NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-FchAct-2 BUTTON-4 Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-FchAct-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\exit":U
     LABEL "&Done" 
     SIZE 7 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img\excel":U
     LABEL "Button 4" 
     SIZE 7 BY 1.73.

DEFINE VARIABLE FILL-IN-FchAct-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Solo vigentes el día" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-FchAct-2 AT ROW 1.27 COL 17 COLON-ALIGNED
     BUTTON-4 AT ROW 3.69 COL 3
     Btn_Done AT ROW 3.69 COL 11
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 83.57 BY 17
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
         TITLE              = "CLIENTES CON LINEAS DE CREDITO ACTIVAS"
         HEIGHT             = 4.96
         WIDTH              = 74.86
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 83.57
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 83.57
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
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CLIENTES CON LINEAS DE CREDITO ACTIVAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CLIENTES CON LINEAS DE CREDITO ACTIVAS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Done */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
  ASSIGN
      FILL-IN-FchAct-2 
      
      .
  RUN Excel.
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
  DISPLAY FILL-IN-FchAct-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-FchAct-2 BUTTON-4 Btn_Done 
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
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
/*chExcelApplication:Visible = TRUE.*/

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 5.
chWorkSheet:Columns("B"):ColumnWidth = 20.
chWorkSheet:Columns("C"):ColumnWidth = 40.
chWorkSheet:Columns("D"):ColumnWidth = 20.
chWorkSheet:Columns("E"):ColumnWidth = 20.
chWorkSheet:Columns("F"):ColumnWidth = 20.
chWorkSheet:Columns("G"):ColumnWidth = 20.
chWorkSheet:Columns("H"):ColumnWidth = 20.
chWorkSheet:Columns("I"):ColumnWidth = 80.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Item".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Cliente".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Nombre o Razon Social".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Linea de Credito".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Forma de Pago".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Fecha de Vencimiento".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "División".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "Telefono".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "Observaciones".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "Departamento".
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "Provincia".
cRange = "L" + cColumn.
chWorkSheet:Range(cRange):Value = "Distrito".

chWorkSheet:Columns("B"):NumberFormat = "@".
chWorkSheet:Columns("E"):NumberFormat = "@".
chWorkSheet:Columns("G"):NumberFormat = "@".
chWorkSheet:Columns("H"):NumberFormat = "@".
chWorkSheet:Range("A1:L2"):Font:Bold = TRUE.

DEF VAR x-Item AS INT INIT 1 NO-UNDO.
DEF VAR f-fchvlc AS DATE NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').

FOR EACH gn-cliel USE-INDEX Indice01 NO-LOCK WHERE gn-cliel.codcia = cl-codcia AND
        gn-cliel.fchfin = FILL-IN-FchAct-2,
    FIRST gn-clie FIELD(codcia codcli nomcli cndvta coddiv telfnos referencias) OF gn-cliel NO-LOCK 
    BREAK BY gn-cliel.codcia BY gn-cliel.codcli BY gn-cliel.fchfin:
    /* filtros */
/*     IF gn-cliel.fchini = ? OR gn-cliel.fchfin = ? THEN NEXT.                                     */
/*     IF FILL-IN-CodDiv > '' AND LOOKUP(TRIM(gn-clie.coddiv), TRIM(FILL-IN-CodDiv)) = 0 THEN NEXT. */

    IF LAST-OF(gn-cliel.codcli) THEN DO:
        dImpLCred = Gn-ClieL.ImpLC.
        f-fchvlc = Gn-ClieL.FchFin.

        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = x-Item.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = gn-clie.codcli.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = gn-clie.nomcli.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = dImpLCred.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = gn-clie.cndvta.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = f-fchvlc.     /*gn-clie.fchvlc.*/
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = gn-clie.coddiv.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = gn-clie.Telfnos[1].
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = gn-clie.Referencias.

        FIND FIRST gn-clied OF gn-clie WHERE gn-clied.sede = "@@@" NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clied THEN DO:
            FIND TabDepto WHERE TabDepto.CodDepto = gn-clied.CodDept NO-LOCK NO-ERROR.
            IF AVAILABLE TabDepto THEN DO:
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Value = TabDepto.NomDepto.
                FIND Tabprovi WHERE Tabprovi.CodDepto = gn-clied.CodDept
                    AND Tabprovi.Codprovi = gn-clied.CodProv NO-LOCK NO-ERROR.
                IF AVAILABLE Tabprovi THEN DO:
                    cRange = "K" + cColumn.
                    chWorkSheet:Range(cRange):Value = TabProvi.NomProvi.
                    FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clied.CodDept
                        AND Tabdistr.Codprovi = gn-clied.CodProv
                        AND Tabdistr.Coddistr = gn-clied.CodDist NO-LOCK NO-ERROR.
                    IF AVAILABLE Tabdistr THEN DO:
                        cRange = "L" + cColumn.
                        chWorkSheet:Range(cRange):Value = TabDistr.NomDistr.
                    END.
                END.
            END.
        END.
        x-Item  = x-Item + 1.
    END.
END.
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

SESSION:SET-WAIT-STATE('').

MESSAGE 'Fin del Proceso'.

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
/*MLR* 05/06/2008 ***
  DEF VAR x-Divisiones AS CHAR.
  DEF VAR i AS INT.

  RB-REPORT-NAME = 'Lineas de Credito Activas'.
  RB-INCLUDE-RECORDS = "O".
  RB-FILTER = "codcia = " + STRING(cl-codcia) + 
                " AND flgsit = 'A'" +
                " AND flagaut = 'A'" +
                " AND ImpLc > 0" +
                " AND CodDept BEGINS '" + TRIM(FILL-IN-CodDept) + "'" +
                " AND CodProv BEGINS '" + TRIM(FILL-IN-CodProv) + "'" +
                " AND CodDist BEGINS '" + TRIM(FILL-IN-CodDist) + "'" +
                " AND IN-LIST(TRIM(CndVta),'000','001','002') = 0" +
                " AND Canal BEGINS '" + TRIM(x-Canal) + "'" +
                " AND CodVen BEGINS '" + TRIM(x-CodVen) + "'".

  IF FILL-IN-FchAct-1 <> ? THEN DO:
    SESSION:DATE-FORMAT = 'mdy'.
    RB-FILTER = RB-FILTER + " AND FchVlc >= " + STRING(FILL-IN-FchAct-1, '99/99/9999').
    SESSION:DATE-FORMAT = 'dmy'.
  END.
  IF FILL-IN-FchAct-2 <> ? THEN DO:
    SESSION:DATE-FORMAT = 'mdy'.
    RB-FILTER = RB-FILTER + " AND FchVlc <= " + STRING(FILL-IN-FchAct-2, '99/99/9999').
    SESSION:DATE-FORMAT = 'dmy'.
  END.
  
  IF FILL-IN-CodDiv <> '' THEN DO:
    DO i = 1 TO NUM-ENTRIES(FILL-IN-CodDiv):
        IF i = 1 
        THEN x-Divisiones = "'" + TRIM(ENTRY(i, FILL-IN-CodDiv)) + "'".
        ELSE x-Divisiones = x-Divisiones + "," + "'" + 
                            TRIM(ENTRY(i, FILL-IN-CodDiv)) + "'".
    END.
    RB-FILTER = RB-FILTER + " AND IN-LIST(TRIM(CodDiv)," + x-Divisiones + ") > 0".
  END.  

  RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia +
                        "~ns-orden = " + RADIO-SET-Orden.

    RUN lib/_Imprime2(
        RB-REPORT-LIBRARY,
        RB-REPORT-NAME,
        RB-INCLUDE-RECORDS,
        RB-FILTER,
        RB-OTHER-PARAMETERS).
***/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 60.
            WHEN 2 THEN
                OUTPUT TO PRINTER PAGED PAGE-SIZE 60. /* Impresora */
        END CASE.
        PUT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} + {&PrnD}.
        RUN Formato.
        PAGE.
        OUTPUT CLOSE.
    END.
    OUTPUT CLOSE.

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
    FILL-IN-FchAct-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
PROCEDURE recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */
    
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

