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
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-periodo AS INT.
DEFINE SHARED VAR s-nromes AS INT.
DEFINE SHARED VAR s-nomcia AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.

/* Local Variable Definitions ---                                       */


/* VARIABLES DE IMPRESION */
DEFINE VARIABLE RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
DEFINE VARIABLE RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
DEFINE VARIABLE RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
DEFINE VARIABLE RB-FILTER AS CHAR.                      /* Filtro de impresion */
DEFINE VARIABLE RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

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
    WITH OVERLAY CENTERED KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.


DEFINE TEMP-TABLE tmp-Datos
    FIELDS tmp-codper  LIKE  pl-pers.codper                                        
    FIELDS tmp-patper  LIKE  pl-pers.patper                                        
    FIELDS tmp-matper  LIKE  pl-pers.matper                                        
    FIELDS tmp-nomper  LIKE  pl-pers.nomper                                        
    FIELDS tmp-cargos  LIKE  pl-flg-mes.cargos                                     
    FIELDS tmp-seccion LIKE  pl-flg-mes.seccion                                    
    FIELDS tmp-senati  AS DEC DECIMALS 4 FORMAT '>>.9999'
    FIELDS tmp-remuneracion  AS DEC
    FIELDS tmp-valcal-mes   LIKE  pl-mov-mes.valcal-mes.                            


DEF BUFFER b-mes FOR pl-mov-mes.
DEF VAR x-senati AS DEC DECIMALS 4 FORMAT '>>.9999'.
DEF VAR x-remuneracion AS DEC.

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
&Scoped-Define ENABLED-OBJECTS cb-Mes BUTTON-1 BUTTON-2 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS cb-Mes 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 15 BY 1.5.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Button 2" 
     SIZE 15 BY 1.5.

DEFINE VARIABLE cb-Mes AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Enero","01",
                     "Febrero","02",
                     "Marzo","03",
                     "Abril","04",
                     "Mayo","05",
                     "Junio","06",
                     "Julio","07",
                     "Agosto","08",
                     "Setiembre","09",
                     "Octubre","10",
                     "Noviembre","11",
                     "Diciembre","12"
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 64 BY 3.77.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cb-Mes AT ROW 1.81 COL 15 COLON-ALIGNED
     BUTTON-1 AT ROW 3.15 COL 35
     BUTTON-2 AT ROW 3.15 COL 50
     RECT-2 AT ROW 1.27 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 65.86 BY 4.38
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
         TITLE              = "Reporte SENATI"
         HEIGHT             = 4.38
         WIDTH              = 65.86
         MAX-HEIGHT         = 4.38
         MAX-WIDTH          = 65.86
         VIRTUAL-HEIGHT     = 4.38
         VIRTUAL-WIDTH      = 65.86
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


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte SENATI */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte SENATI */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
    ASSIGN cb-mes.

    RUN Excel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
    RUN dispatch IN THIS-PROCEDURE ('exit':U).
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

FIND pl-var-mes WHERE periodo = s-periodo
    AND nromes = INTEGER(cb-mes)
    NO-LOCK.
x-senati = valvar-mes[14]. 

FOR EACH pl-mov-mes NO-LOCK WHERE pl-mov-mes.codcia = s-codcia
    AND pl-mov-mes.periodo = s-periodo
    AND pl-mov-mes.nromes = INTEGER(cb-mes)
    AND pl-mov-mes.codcal = 001
    AND pl-mov-mes.codmov = 306
    AND pl-mov-mes.valcal-mes > 0,
    FIRST pl-flg-mes OF pl-mov-mes NO-LOCK,
    FIRST pl-pers WHERE pl-pers.codper = pl-mov-mes.codper:
    FIND b-mes WHERE b-mes.codcia = 1
        AND b-mes.periodo = s-periodo
        AND b-mes.nromes = INTEGER(cb-mes)
        AND b-mes.codper = pl-mov-mes.codper
        AND b-mes.codcal = 001
        AND b-mes.codmov = 018 NO-LOCK.
    x-remuneracion = pl-mov-mes.valcal-mes.
    IF b-mes.valcal-mes = 2 THEN x-remuneracion = x-remuneracion / 0.5.
    x-remuneracion = x-remuneracion * 100 / x-senati.
    CREATE tmp-Datos.
    ASSIGN        
        tmp-codper  =  pl-pers.codper 
        tmp-patper  =  pl-pers.patper 
        tmp-matper  =  pl-pers.matper 
        tmp-nomper  =  pl-pers.nomper
        tmp-cargos  =  pl-flg-mes.cargos
        tmp-seccion =  pl-flg-mes.seccion
        tmp-senati  =  x-senati * (IF b-mes.valcal-mes = 1 THEN 1 ELSE 0.5) 
        tmp-remuneracion = x-remuneracion
        tmp-valcal-mes   = pl-mov-mes.valcal-mes.
    VIEW FRAME F-Proceso.
END.

HIDE FRAME F-Proceso.

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
  DISPLAY cb-Mes 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE cb-Mes BUTTON-1 BUTTON-2 RECT-2 
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

DEFINE VARIABLE i AS INTEGER INIT 0 NO-UNDO.

RUN Carga-Temporal.
/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Nº".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Codigo".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Apellido Paterno".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Apellido Materno".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Nombres".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Cargo".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Seccion".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "Tasa".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "Imponible".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "Valor".


FOR EACH tmp-Datos NO-LOCK
    BREAK BY tmp-senati DESC
          BY tmp-seccion :
    ACCUMULATE tmp-remuneracion (SUB-TOTAL BY tmp-senati).
    ACCUMULATE tmp-valcal-mes (SUB-TOTAL BY tmp-senati).
    ACCUMULATE tmp-remuneracion (TOTAL).
    ACCUMULATE tmp-valcal-mes (TOTAL).

    i = i + 1.
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = i.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tmp-codper.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-patper.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-matper.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-nomper.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-cargos.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-seccion.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-senati.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-remuneracion.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-valcal-mes.
    IF LAST-OF(tmp-senati) THEN DO:
        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = "Total Personal".
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = i.
        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = "SubTotal - " + STRING(tmp-senati,"9.999").
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY tmp-senati tmp-remuneracion.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY tmp-senati tmp-valcal-mes.
        i = 0.
    END.
    IF LAST(tmp-senati) THEN DO:
        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = "TOTAL" .
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL tmp-remuneracion.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL tmp-valcal-mes.
    END.
END.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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

   DEFINE VARIABLE pto AS LOGICAL NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
    DO WITH FRAME {&FRAME-NAME}:
        /*MESSAGE "NroMes " s-nromes
            VIEW-AS ALERT-BOX INFO BUTTONS OK.*/
        ASSIGN cb-mes = STRING((s-nromes - 1),"99").        
    END.

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

