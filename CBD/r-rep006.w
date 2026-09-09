&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
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
DEF SHARED VAR cb-codcia AS INT.

DEF TEMP-TABLE Detalle
    FIELD codcta AS CHAR FORMAT 'x(60)'
    FIELD cco    AS CHAR FORMAT 'x(60)'
    FIELD codaux LIKE cb-auxi.codaux
    FIELD periodo AS CHAR FORMAT 'x(6)'
    FIELD impmn1 LIKE cb-dmov.impmn1.

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

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Periodo BUTTON-1 BtnDone ~
COMBO-BOX-NroMes-1 COMBO-BOX-NroMes-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Periodo COMBO-BOX-NroMes-1 ~
COMBO-BOX-NroMes-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 7 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 7 BY 1.62.

DEFINE VARIABLE COMBO-BOX-NroMes-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Enero" 
     LABEL "Desde el Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-NroMes-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Diciembre" 
     LABEL "Hasta el Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Periodo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     COMBO-BOX-Periodo AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 2
     BUTTON-1 AT ROW 2.08 COL 64 WIDGET-ID 6
     BtnDone AT ROW 2.08 COL 71 WIDGET-ID 10
     COMBO-BOX-NroMes-1 AT ROW 3.15 COL 19 COLON-ALIGNED WIDGET-ID 4
     COMBO-BOX-NroMes-2 AT ROW 4.23 COL 19 COLON-ALIGNED WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 5.04 WIDGET-ID 100.


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
         TITLE              = "REPORTE POR CENTROS DE COSTOS"
         HEIGHT             = 5.04
         WIDTH              = 80
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* REPORTE POR CENTROS DE COSTOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* REPORTE POR CENTROS DE COSTOS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone wWin
ON CHOOSE OF BtnDone IN FRAME fMain /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wWin
ON CHOOSE OF BUTTON-1 IN FRAME fMain /* Button 1 */
DO:
    ASSIGN
        COMBO-BOX-NroMes-1 COMBO-BOX-NroMes-2 COMBO-BOX-Periodo.

  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal wWin 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Periodo AS INT.
DEF VAR x-NroMes-1 AS INT.
DEF VAR x-NroMes-2 AS INT.

x-Periodo = INTEGER(COMBO-BOX-Periodo).
x-NroMes-1 = LOOKUP(COMBO-BOX-NroMes-1, 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,~
                  Setiembre,Octubre,Noviembre,Diciembre').
x-NroMes-2 = LOOKUP(COMBO-BOX-NroMes-2, 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,~
                  Setiembre,Octubre,Noviembre,Diciembre').

EMPTY TEMP-TABLE Detalle.
FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = s-codcia
    AND cb-dmov.periodo = x-periodo
    AND cb-dmov.nromes >= x-NroMes-1
    AND cb-dmov.nromes <= x-nroMes-2
    AND cb-dmov.codcta BEGINS '6',
    FIRST cb-ctas NO-LOCK WHERE cb-ctas.codcia = cb-codcia
        AND cb-ctas.codcta = cb-dmov.codcta:
    CREATE Detalle.
    ASSIGN
        detalle.codcta = cb-ctas.codcta + ' ' + cb-ctas.nomcta
        detalle.codaux = cb-dmov.cco
        detalle.cco    = '0000000'.                     /* Valor por defecto */
    IF detalle.codaux = '' THEN detalle.codaux = "00".  /* Valor por defecto */
    /* Centro de Costo a 2 dígitos */
    FIND FIRST cb-auxi WHERE cb-auxi.codcia = cb-codcia
        AND cb-auxi.clfaux = 'CCO'
        AND cb-auxi.codaux = detalle.codaux
        NO-LOCK NO-ERROR.
    IF AVAILABLE cb-auxi THEN detalle.codaux = cb-auxi.Codaux.
    ELSE detalle.codaux = "00".
    /* Centro de Costo a 7 dígitos */
    IF AVAILABLE cb-auxi THEN detalle.cco = cb-auxi.Libre_c01.
    FIND gn-ccos WHERE gn-ccos.codcia = s-codcia
        AND gn-ccos.Cco = detalle.cco
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ccos THEN detalle.cco = gn-ccos.Cco + ' ' + gn-ccos.DesCco.
    ELSE detalle.cco = "0000000 Por Distribuir".
    ASSIGN
        detalle.periodo = STRING(cb-dmov.Periodo * 100 + cb-dmov.NroMes, '999999')
        detalle.impmn1 = cb-dmov.ImpMn1 * (IF cb-dmov.tpomov = YES THEN -1 ELSE 1).
END.

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
  DISPLAY COMBO-BOX-Periodo COMBO-BOX-NroMes-1 COMBO-BOX-NroMes-2 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE COMBO-BOX-Periodo BUTTON-1 BtnDone COMBO-BOX-NroMes-1 
         COMBO-BOX-NroMes-2 
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

SESSION:SET-WAIT-STATE('GENERAL').

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

/* Titulos */
chWorkSheet:Range("A1"):VALUE = "Cuenta".
chWorkSheet:Range("B1"):VALUE = "Centro de Costo 7".
chWorkSheet:Range("C1"):VALUE = "Centro de costo 2".
chWorkSheet:Range("D1"):VALUE = "AAAAMM".
chWorkSheet:Range("E1"):VALUE = "Importe".
/*chWorkSheet:COLUMNS("B"):NumberFormat = "dd/MM/yyyy".*/
chWorkSheet:COLUMNS("D"):NumberFormat = "@".
chWorkSheet:COLUMNS("C"):NumberFormat = "@".

chWorkSheet = chExcelApplication:Sheets:Item(1).

RUN Carga-Temporal.
FOR EACH detalle NO-LOCK:
    t-Row = t-Row + 1.
    t-Column = 1.
    chWorkSheet:Cells(t-Row, t-Column) = detalle.codcta.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = detalle.Cco.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = detalle.Codaux.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = detalle.Periodo.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = detalle.ImpMn1.
END.
/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

SESSION:SET-WAIT-STATE('').


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
  FOR EACH cb-peri NO-LOCK WHERE codcia = s-codcia:
      COMBO-BOX-Periodo:ADD-LAST( STRING (CB-PERI.Periodo, '9999')) IN FRAME {&FRAME-NAME}.
      COMBO-BOX-Periodo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(CB-PERI.Periodo, '9999') .
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

