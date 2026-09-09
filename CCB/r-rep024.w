&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
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

{src/adm2/widgetprto.i}

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR cl-codcia AS INT.

DEF VAR x-CodDiv AS CHAR NO-UNDO.

x-CodDiv = s-coddiv.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME BROWSE-5

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almacen Almcmov gn-clie

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 Almcmov.FchDoc Almcmov.CodAlm ~
Almcmov.NroSer Almcmov.NroDoc Almcmov.CodCli gn-clie.NomCli 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH Almacen ~
      WHERE Almacen.CodCia = s-codcia ~
 AND Almacen.CodDiv begins x-coddiv NO-LOCK, ~
      EACH Almcmov OF Almacen ~
      WHERE Almcmov.TipMov = "I" ~
 AND Almcmov.CodMov = 9 ~
 AND Almcmov.FlgEst = "P"  NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.CodCli = Almcmov.CodCli ~
      AND gn-clie.CodCia = cl-codcia NO-LOCK ~
    BY Almcmov.FchDoc DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH Almacen ~
      WHERE Almacen.CodCia = s-codcia ~
 AND Almacen.CodDiv begins x-coddiv NO-LOCK, ~
      EACH Almcmov OF Almacen ~
      WHERE Almcmov.TipMov = "I" ~
 AND Almcmov.CodMov = 9 ~
 AND Almcmov.FlgEst = "P"  NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.CodCli = Almcmov.CodCli ~
      AND gn-clie.CodCia = cl-codcia NO-LOCK ~
    BY Almcmov.FchDoc DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 Almacen Almcmov gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 Almacen
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-5 Almcmov
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-5 gn-clie


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-5 COMBO-BOX-Division BROWSE-5 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Division 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 5" 
     SIZE 6 BY 1.62.

DEFINE VARIABLE COMBO-BOX-Division AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 60 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      Almacen, 
      Almcmov, 
      gn-clie SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 wWin _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      Almcmov.FchDoc COLUMN-LABEL "Emisión" FORMAT "99/99/9999":U
      Almcmov.CodAlm FORMAT "x(3)":U
      Almcmov.NroSer COLUMN-LABEL "Serie" FORMAT "999":U
      Almcmov.NroDoc COLUMN-LABEL "Numero" FORMAT "999999":U
      Almcmov.CodCli COLUMN-LABEL "Cliente" FORMAT "x(11)":U
      gn-clie.NomCli FORMAT "x(50)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 100 BY 15.08 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BUTTON-5 AT ROW 1 COL 74 WIDGET-ID 4
     COMBO-BOX-Division AT ROW 1.27 COL 10 COLON-ALIGNED WIDGET-ID 2
     BROWSE-5 AT ROW 2.62 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 109 BY 17 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "PARTES DE INGRESO PENDIENTES DE EMITIR NOTA DE CREDITO"
         HEIGHT             = 17
         WIDTH              = 109
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.14
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-5 COMBO-BOX-Division fMain */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "INTEGRAL.Almacen,INTEGRAL.Almcmov OF INTEGRAL.Almacen,INTEGRAL.gn-clie WHERE INTEGRAL.Almcmov ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ",,"
     _OrdList          = "INTEGRAL.Almcmov.FchDoc|no"
     _Where[1]         = "Almacen.CodCia = s-codcia
 AND Almacen.CodDiv begins x-coddiv"
     _Where[2]         = "Almcmov.TipMov = ""I""
 AND Almcmov.CodMov = 9
 AND Almcmov.FlgEst = ""P"" "
     _JoinCode[3]      = "gn-clie.CodCli = Almcmov.CodCli"
     _Where[3]         = "gn-clie.CodCia = cl-codcia"
     _FldNameList[1]   > INTEGRAL.Almcmov.FchDoc
"Almcmov.FchDoc" "Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.Almcmov.CodAlm
     _FldNameList[3]   > INTEGRAL.Almcmov.NroSer
"Almcmov.NroSer" "Serie" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almcmov.NroDoc
"Almcmov.NroDoc" "Numero" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almcmov.CodCli
"Almcmov.CodCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = INTEGRAL.gn-clie.NomCli
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* PARTES DE INGRESO PENDIENTES DE EMITIR NOTA DE CREDITO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* PARTES DE INGRESO PENDIENTES DE EMITIR NOTA DE CREDITO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 wWin
ON CHOOSE OF BUTTON-5 IN FRAME fMain /* Button 5 */
DO:
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Division wWin
ON VALUE-CHANGED OF COMBO-BOX-Division IN FRAME fMain /* Division */
DO:
  IF SELF:SCREEN-VALUE = 'Todas' THEN x-CodDiv = ''.
  ELSE DO:
      x-CodDiv = ENTRY(1, SELF:SCREEN-VALUE, ' ').
  END.
{&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-5
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY COMBO-BOX-Division 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE BUTTON-5 COMBO-BOX-Division BROWSE-5 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel wWin 
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
    DEFINE VARIABLE t-Column                AS INTEGER INIT 1.

    DEFINE VAR x-ImpLin AS DEC NO-UNDO.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "EMISION".
    cRange = "B" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "ALMACEN".
    cRange = "C" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "SERIE".
    cRange = "D" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "NUMERO".
    cRange = "E" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "CLIENTE".
    cRange = "F" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "NOMBRE".
    cRange = "G" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "IMPORTE".
    GET FIRST {&BROWSE-NAME}.
    REPEAT WHILE AVAILABLE almcmov:
        t-column = t-column + 1.                                                                                                                               
        cColumn = STRING(t-Column).                                                                                        
        cRange = "A" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = almcmov.fchdoc.
        cRange = "B" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = "'" + almcmov.codalm.
        cRange = "C" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = "'" + STRING(almcmov.nroser, '999').
        cRange = "D" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = "'" + STRING(almcmov.nrodoc, '999999').
        cRange = "E" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = "'" + almcmov.codcli.
        cRange = "F" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = gn-clie.nomcli.
        x-ImpLin = 0.
        FOR EACH Almdmov OF Almcmov NO-LOCK:
            x-ImpLin = x-ImpLin + Almdmov.ImpLin.
        END.
        cRange = "G" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = x-ImpLin.
        GET NEXT {&BROWSE-NAME}.
    END.

    /* launch Excel so it is visible to the user */
    chExcelApplication:VISIBLE = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FOR EACH GN-DIVI NO-LOCK WHERE gn-divi.codcia = s-codcia:
      COMBO-BOX-Division:ADD-LAST(gn-divi.coddiv + ' ' + gn-divi.desdiv)  IN FRAME {&FRAME-NAME} .
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FIND gn-divi WHERE gn-divi.codcia = s-codcia
          AND gn-divi.coddiv = s-coddiv NO-LOCK.
      COMBO-BOX-Division:SCREEN-VALUE = gn-divi.coddiv + ' ' + gn-divi.desdiv.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

