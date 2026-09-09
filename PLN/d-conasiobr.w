&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
DEF SHARED VAR s-periodo AS INT.
/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE        VAR C-OP     AS CHAR.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE        VAR F-PESALM AS DECIMAL NO-UNDO.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.
DEFINE BUFFER T-MATE FOR Almmmate.

/*******/
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.

/* Local Variable Definitions ---                                       */
DEFINE VAR F-Ingreso AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-PreIng  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-TotIng  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-Salida  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-PreSal  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-TotSal  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-Saldo   AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-VALCTO  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-STKGEN  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-PRECIO  AS DECIMAL FORMAT "(>>>,>>9.99)" NO-UNDO.
DEFINE VAR S-SUBTIT  AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VAR F-SPeso   AS DECIMAL FORMAT "(>,>>>,>>9.99)" NO-UNDO.

DEFINE BUFFER DMOV FOR Almdmov. 

DEFINE VAR I-NROITM  AS INTEGER.

DEFINE TEMP-TABLE  tmp-report LIKE w-report.


DEFINE VAR T-Ingreso AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR T-Salida  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.


DEFINE VARIABLE F-PREUSSA AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUSSB AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUSSC AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUSSD AS DECIMAL NO-UNDO.

DEFINE VARIABLE F-PRESOLA AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PRESOLB AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PRESOLC AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PRESOLD AS DECIMAL NO-UNDO.

DEFINE VARIABLE mensaje AS CHARACTER.

DEFINE VARIABLE F-DSCTOS  AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREVTA  AS DECIMAL NO-UNDO.
DEFINE VARIABLE Y-DSCTOS  AS DECIMAL NO-UNDO.
DEFINE VARIABLE X-Factor  AS DECIMAL NO-UNDO.

DEFINE VAR J AS INTEGER INIT 0.
DEFINE VAR X-VOLUM  AS INTEGER INIT 0.
DEFINE VAR X-DSCTOS AS decimal INIT 0.
DEFINE VAR X-PREVTA AS decimal INIT 0.
DEFINE VAR X-PREVTA1 AS decimal INIT 0.
DEFINE VAR X-PREVTA2 AS decimal INIT 0.
DEFINE VAR X-VENTA   AS decimal INIT 0.
DEFINE VAR X-TMONE   AS CHAR.

DEFINE VAR X-NOMPER AS CHAR.

DEFINE TEMP-TABLE Tempo LIKE PL-FLG-MES.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-58 RECT-59 RECT-64 Btn_OK DesdeC ~
Btn_Cancel Btn_Help HastaC BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS DesdeC HastaC 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     IMAGE-UP FILE "img\b-ayuda":U
     LABEL "A&yuda" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img\excel":U
     LABEL "Button 3" 
     SIZE 11 BY 1.5.

DEFINE VARIABLE DesdeC AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10.43 BY .69 NO-UNDO.

DEFINE VARIABLE HastaC AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 58.43 BY 3.92.

DEFINE RECTANGLE RECT-59
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 58.29 BY 2.12.

DEFINE RECTANGLE RECT-64
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41.57 BY 2.69.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Btn_OK AT ROW 5.54 COL 4.29
     DesdeC AT ROW 2.65 COL 16.29 COLON-ALIGNED
     Btn_Cancel AT ROW 5.54 COL 18.43
     Btn_Help AT ROW 5.54 COL 32.86
     HastaC AT ROW 2.69 COL 36.29 COLON-ALIGNED
     BUTTON-3 AT ROW 5.54 COL 47.72
     RECT-58 AT ROW 1.08 COL 1.86
     RECT-59 AT ROW 5.23 COL 2.14
     "Rango de Fechas" VIEW-AS TEXT
          SIZE 20.57 BY .5 AT ROW 1.46 COL 10.86
          FGCOLOR 9 
     RECT-64 AT ROW 1.73 COL 10.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 59.57 BY 6.62
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
         TITLE              = "Reloj Marcador"
         HEIGHT             = 6.38
         WIDTH              = 60.14
         MAX-HEIGHT         = 27.85
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.85
         VIRTUAL-WIDTH      = 146.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

IF NOT W-Win:LOAD-ICON("img\climnu3":U) THEN
    MESSAGE "Unable to load icon: img\climnu3"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reloj Marcador */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reloj Marcador */
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
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help W-Win
ON CHOOSE OF Btn_Help IN FRAME F-Main /* Ayuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
MESSAGE "Help for File: {&FILE-NAME}":U VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Excel.
  RUN Habilita.
  RUN Inicializa-Variables.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables W-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN DesdeC HastaC .
/*  IF Desdec = ?  THEN Desdec = "01/01/1900".
  IF Hastac = ?  THEN Hastac = "01/01/3000".*/

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
  DISPLAY DesdeC HastaC 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-58 RECT-59 RECT-64 Btn_OK DesdeC Btn_Cancel Btn_Help HastaC 
         BUTTON-3 
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
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE x-ccosto                AS CHARACTER.
DEFINE VARIABLE xlCenter  AS CHAR.
DEFINE VARIABLE xlBottom  AS CHAR.



/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A:G"):Font:Size = 8.

/* set the column names for the Worksheet */

chWorkSheet:Columns("A"):ColumnWidth = 6.
chWorkSheet:Columns("B"):ColumnWidth = 15.
chWorkSheet:Columns("C"):ColumnWidth = 6.
chWorkSheet:Columns("D"):ColumnWidth = 30.
chWorkSheet:Columns("E"):ColumnWidth = 10.
chWorkSheet:Columns("F"):ColumnWidth = 5.
chWorkSheet:Columns("G"):ColumnWidth = 5.

chWorkSheet:Columns("A:A"):NumberFormat = "@".
chWorkSheet:Columns("B:B"):NumberFormat = "@".
chWorkSheet:Columns("C:C"):NumberFormat = "@".
chWorkSheet:Columns("D:D"):NumberFormat = "@".
chWorkSheet:Columns("E:E"):NumberFormat = "dd-mm-yyyy".
chWorkSheet:Columns("F:F"):NumberFormat = "h:mm".
chWorkSheet:Columns("G:G"):NumberFormat = "0.00".



chWorkSheet:Range("A1:G2"):Font:Bold = TRUE.

chWorkSheet:Range("F1"):Value = "Hora ".
chWorkSheet:Range("G1"):Value = "Hora ".

chWorkSheet:Range("A2"):Value = "C.Costo".
chWorkSheet:Range("B2"):Value = "Descripcion".
chWorkSheet:Range("C2"):Value = "Codigo".
chWorkSheet:Range("D2"):Value = "Nombre".
chWorkSheet:Range("E2"):Value = "Fecha ".
chWorkSheet:Range("F2"):Value = "Cronologica".
chWorkSheet:Range("G2"):Value = "Sexagecimal".


/* Iterate through the salesrep table and populate
   the Worksheet appropriately */

iColumn = 2.

FOR EACH as-marc no-lock where as-marc.codcia =  S-CODCIA AND
                               as-marc.fchmar >= DESDEC AND
                               as-marc.fchmar <= HASTAC                               
                       break by as-marc.codcia 
                             by as-marc.codper
                             by as-marc.fchmar
                             by as-marc.hormar:
    if first-of(as-marc.codper) then do:
        x-ccosto = "".                        
        x-nomper = "".
        find  pl-pers where pl-pers.codper = as-marc.codper
                            no-lock no-error.
        
        if avail pl-pers then x-nomper = trim(pl-pers.patper) + " " + trim(pl-pers.matper) + " " + trim(pl-pers.nomper).
        
        find last pl-flg-mes where pl-flg-mes.codcia = 1 and pl-flg-mes.codper = as-marc.codper
                             no-lock no-error.
        if available pl-flg-mes then x-ccosto = pl-flg-mes.ccosto.                      
        
        find cb-auxi WHERE cb-auxi.CodCia = 0 and 
                           cb-auxi.CLFAUX = "CCO" and
                           cb-auxi.CodAUX = x-ccosto
                           no-lock no-error.
      
        iColumn = iColumn + 1.
    
        cColumn = STRING(iColumn).
        
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = x-ccosto.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = cb-auxi.nomaux.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = STRING(as-marc.codper,"999999").
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = x-nomper.
    
    end.

    iColumn = iColumn + 1.

    cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = x-ccosto.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = as-marc.codper.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = as-marc.fchmar.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = as-marc.hormar.

    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = DECI(substring(as-marc.hormar,1,2)) + DECI(substring(as-marc.hormar,4,2)) / 60.

end.

chWorkSheet:Range("A3:" + cRange):Select().
chWorksheetRange = chWorksheet:Range("A3").



/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(2).

chWorkSheet:Range("A:G"):Font:Size = 8.
chWorkSheet:Range("A1:G2"):Font:Bold = TRUE.

chWorkSheet:Columns("A"):ColumnWidth = 6.
chWorkSheet:Columns("B"):ColumnWidth = 15.
chWorkSheet:Columns("C"):ColumnWidth = 6.
chWorkSheet:Columns("D"):ColumnWidth = 30.
chWorkSheet:Columns("E"):ColumnWidth = 10.

chWorkSheet:Columns("A:A"):NumberFormat = "@".
chWorkSheet:Columns("B:B"):NumberFormat = "@".
chWorkSheet:Columns("C:C"):NumberFormat = "@".
chWorkSheet:Columns("D:D"):NumberFormat = "@".
chWorkSheet:Columns("E:E"):NumberFormat = "dd-mm-yyyy".


chWorkSheet:Range("C1"):Value = "Listado de Faltas".

chWorkSheet:Range("A2"):Value = "C.Costo".
chWorkSheet:Range("B2"):Value = "Descripcion".
chWorkSheet:Range("C2"):Value = "Codigo".
chWorkSheet:Range("D2"):Value = "Nombre".
chWorkSheet:Range("E2"):Value = "Fecha ".


iColumn = 2.

FOR EACH as-marc no-lock where as-marc.codcia =  S-CODCIA AND
                               as-marc.fchmar >= DESDEC AND
                               as-marc.fchmar <= HASTAC                               
                       break by as-marc.codcia 
                             by as-marc.fchmar
                             by as-marc.codper:
    IF FIRST-OF(as-marc.fchmar) THEN DO:
       FOR EACH Tempo:
           DELETE Tempo.
       END.
       FOR EACH PL-FLG-MES NO-LOCK WHERE PL-FLG-MES.CODCIA = S-CODCIA AND
                                         PL-FLG-MES.PERIODO = YEAR(as-marc.fchmar) AND
                                         PL-FLG-MES.NROMES  = MONTH(as-marc.fchmar):
           CREATE Tempo.
           RAW-TRANSFER PL-FLG-MES TO Tempo.                              
       END.                                  
                                    
    END.
    IF LAST-OF(as-marc.codper) THEN DO:
       FIND Tempo WHERE Tempo.Codcia = S-CODCIA  AND
                        Tempo.CodPer = as-marc.codper
                        NO-ERROR.
       IF AVAILABLE Tempo THEN DELETE  Tempo.                 
    END.
    IF LAST-OF(as-marc.fchmar) THEN DO:
       FOR EACH Tempo WHERE Tempo.SitAct = "Activo":
           x-ccosto = Tempo.ccosto.                        
           x-nomper = "".
           find  pl-pers where pl-pers.codper = tempo.codper
                               no-lock no-error.
        
           if avail pl-pers then x-nomper = trim(pl-pers.patper) + " " + trim(pl-pers.matper) + " " + trim(pl-pers.nomper).
        
        
           find cb-auxi WHERE cb-auxi.CodCia = 0 and 
                              cb-auxi.CLFAUX = "CCO" and
                              cb-auxi.CodAUX = x-ccosto
                              no-lock no-error.
      
           iColumn = iColumn + 1.
    
           cColumn = STRING(iColumn).
        
           cRange = "A" + cColumn.
           chWorkSheet:Range(cRange):Value = x-ccosto.
           cRange = "B" + cColumn.
           chWorkSheet:Range(cRange):Value = cb-auxi.nomaux.
           cRange = "C" + cColumn.
           chWorkSheet:Range(cRange):Value = STRING(Tempo.codper,"999999").
           cRange = "D" + cColumn.
           chWorkSheet:Range(cRange):Value = x-nomper.
           cRange = "E" + cColumn.
           chWorkSheet:Range(cRange):Value = as-marc.fchmar.
    
        END.
       
    END.
    
       
END.
/*
chWorkSheet:Range("A3:" + cRange):Select().
chWorksheetRange = chWorksheet:Range("A3").


chWorkSheet = chExcelApplication:Sheets:Item(1).
*/

/* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.
RELEASE OBJECT chWorkbook         NO-ERROR.
RELEASE OBJECT chWorksheet       NO-ERROR.
RELEASE OBJECT chWorksheetRange  NO-ERROR.


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
               
DEFINE FRAME F-REPORTE
          PL-PERS.codper 
          PL-PERS.patper 
          PL-PERS.matper 
          PL-PERS.nomper
          as-marc.fchmar
          as-marc.hormar
 
WITH WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
               
  
DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA  FORMAT "X(50)" AT 1 SKIP
         "REGISTRO DE MARCACION" AT 62
         "Pagina :" TO 125 PAGE-NUMBER(REPORT) TO 137 FORMAT "ZZZZZ9" SKIP
         "Fecha  :" TO 125 TODAY TO 137 FORMAT "99/99/9999" SKIP
         "Hora   :" TO 125 STRING(TIME,"HH:MM") TO 137 SKIP
         mensaje FORMAT "X(28)" SKIP
        "------------------------------------------------------------------------------------------------" SKIP
        "Codigo A p e l l i d o s        y         N o m b r e s                        Fecha       Hora " SKIP
        "------------------------------------------------------------------------------------------------" SKIP
      WITH PAGE-TOP WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

for each pl-flg-sem no-lock where pl-flg-sem.codcia = s-codcia and
                                  pl-flg-sem.codpln = 002,
first pl-pers of pl-flg-sem, each as-marc of pl-pers no-lock where 
                             pl-pers.codper = as-marc.codper and
                             as-marc.codcia = s-codcia and
                             as-marc.fchmar >= desdec and
                             as-marc.fchmar <= hastac 
                             by as-marc.codcia
                             by as-marc.codper
                             by as-marc.fchmar
                             by as-marc.hormar.

/*FOR EACH as-marc no-lock where as-marc.codcia =  S-CODCIA AND
 *                                as-marc.fchmar >= DESDEC AND
 *                                as-marc.fchmar <= HASTAC
 *                        break by as-marc.codcia 
 *                              by as-marc.codper
 *                              by as-marc.fchmar
 *                              by as-marc.hormar.*/

             
/*    if first-of(as-marc.codper) then do:
 *         x-nomper = "".*/

/*        find  pl-pers where pl-pers.codper = as-marc.codper
 *                             no-lock no-error.*/
                            
                   
        
        if avail pl-pers then x-nomper = trim(pl-pers.patper) + " " + trim(pl-pers.matper) + " " + trim(pl-pers.nomper).
    
    
      DISPLAY PL-PERS.codper @ Fi-Mensaje LABEL "Codigo de Personal "
              FORMAT "X(11)" WITH FRAME F-Proceso.


      VIEW STREAM REPORT FRAME F-HEADER.
      DISPLAY STREAM REPORT
          PL-PERS.codper 
          PL-PERS.patper 
          PL-PERS.matper 
          PL-PERS.nomper
          AS-MARC.fchmar
          As-MARC.hormar
      WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      
END.

HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Habilita W-Win 
PROCEDURE Habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    ENABLE ALL.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime W-Win 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.
   
  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
  
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
  s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").


  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY + "report.prn".

  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY + "report.prn".
  
  CASE s-salida-impresion:
        WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
        WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
        WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
  END CASE.
  
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .
  
  RUN Formato.
  
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.
  
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN LIB/W-README.R(s-print-file).
  END CASE. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inhabilita W-Win 
PROCEDURE Inhabilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    DISABLE ALL.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inicializa-Variables W-Win 
PROCEDURE Inicializa-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN DesdeC HastaC .
  
END.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ DESDEC
             TODAY @ HASTAC.
  END.
  
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

    CASE HANDLE-CAMPO:name:
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
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


