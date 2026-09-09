&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE Docu NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE Docu-2 NO-UNDO LIKE CcbCDocu.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-coddoc AS CHAR INIT 'N/C'.
DEF VAR L-NROSER AS CHAR NO-UNDO.
DEF VAR S-NROSER AS INTEGER.

DEF TEMP-TABLE t-cdocu LIKE ccbcdocu.
DEF TEMP-TABLE t-ddocu LIKE ccbddocu.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-5

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Docu Docu-2

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 Docu.CodDoc Docu.NroDoc Docu.FchDoc ~
Docu.NomCli Docu.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH Docu NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH Docu NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 Docu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 Docu


/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 Docu-2.CodDoc Docu-2.NroDoc ~
Docu-2.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7 
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH Docu-2 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY BROWSE-7 FOR EACH Docu-2 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 Docu-2
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 Docu-2


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-5}~
    ~{&OPEN-QUERY-BROWSE-7}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 c-NroSer BUTTON-Excel x-CodMon ~
BUTTON-NC x-Concepto x-FchDoc BROWSE-5 BROWSE-7 
&Scoped-Define DISPLAYED-OBJECTS c-NroSer FILL-IN-1 x-Mensaje x-CodMon ~
x-Concepto x-NomCon x-FchDoc FILL-IN-ImpTot 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Excel 
     LABEL "IMPORTAR EXCEL" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-NC 
     LABEL "GENERAR NOTAS DE CREDITO" 
     SIZE 25 BY 1.12.

DEFINE VARIABLE c-NroSer AS CHARACTER FORMAT "X(3)":U 
     LABEL "Nº Serie N/C" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "XXX-XXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpTot AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     LABEL "IMPORTE TOTAL >>>" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 12 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-Concepto AS CHARACTER FORMAT "x(8)" 
     LABEL "Concepto" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81.

DEFINE VARIABLE x-FchDoc AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha para las N/C" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCon AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 67 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 12 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 99 BY 4.04.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      Docu SCROLLING.

DEFINE QUERY BROWSE-7 FOR 
      Docu-2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      Docu.CodDoc FORMAT "x(3)":U
      Docu.NroDoc FORMAT "X(9)":U WIDTH 9.14
      Docu.FchDoc COLUMN-LABEL "Fecha Emisión" FORMAT "99/99/9999":U
            WIDTH 11.43
      Docu.NomCli FORMAT "x(60)":U WIDTH 54.29
      Docu.ImpTot COLUMN-LABEL "Importe del Rebade" FORMAT "->>,>>>,>>9.99":U
            WIDTH 13.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 99 BY 8.08
         FONT 4 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 W-Win _STRUCTURED
  QUERY BROWSE-7 NO-LOCK DISPLAY
      Docu-2.CodDoc FORMAT "x(3)":U
      Docu-2.NroDoc FORMAT "X(9)":U
      Docu-2.ImpTot COLUMN-LABEL "Importe Rebade" FORMAT "->>,>>>,>>9.99":U
            WIDTH 14.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 34 BY 3.23
         FONT 4
         TITLE "A    |B             |C                                     |" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     c-NroSer AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 72
     FILL-IN-1 AT ROW 1.27 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     x-Mensaje AT ROW 1.27 COL 49 COLON-ALIGNED NO-LABEL WIDGET-ID 86
     BUTTON-Excel AT ROW 1.27 COL 101 WIDGET-ID 96
     x-CodMon AT ROW 2.08 COL 21 NO-LABEL WIDGET-ID 78
     BUTTON-NC AT ROW 2.35 COL 101 WIDGET-ID 100
     x-Concepto AT ROW 2.88 COL 19 COLON-ALIGNED WIDGET-ID 82
     x-NomCon AT ROW 2.88 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 88
     x-FchDoc AT ROW 3.69 COL 19 COLON-ALIGNED WIDGET-ID 84
     BROWSE-5 AT ROW 4.77 COL 7 WIDGET-ID 200
     FILL-IN-ImpTot AT ROW 13.12 COL 89 COLON-ALIGNED WIDGET-ID 98
     BROWSE-7 AT ROW 15.27 COL 13 WIDGET-ID 300
     "<<-- La primera línea debe contener los encabezados de las columnas" VIEW-AS TEXT
          SIZE 48 BY .5 AT ROW 16.08 COL 49 WIDGET-ID 92
     "FORMATO DEL ARCHIVO EXCEL" VIEW-AS TEXT
          SIZE 25 BY .5 AT ROW 14.46 COL 9 WIDGET-ID 90
          BGCOLOR 7 FGCOLOR 15 
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 2.35 COL 15 WIDGET-ID 76
     RECT-1 AT ROW 14.73 COL 7 WIDGET-ID 94
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 126.14 BY 18.65
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: Docu T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: Docu-2 T "?" NO-UNDO INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "GENERACION DE NOTAS DE CREDITO POR REBATE"
         HEIGHT             = 18.65
         WIDTH              = 126.14
         MAX-HEIGHT         = 19
         MAX-WIDTH          = 128.86
         VIRTUAL-HEIGHT     = 19
         VIRTUAL-WIDTH      = 128.86
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-5 x-FchDoc F-Main */
/* BROWSE-TAB BROWSE-7 FILL-IN-ImpTot F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomCon IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.Docu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.Docu.CodDoc
     _FldNameList[2]   > Temp-Tables.Docu.NroDoc
"Docu.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.Docu.FchDoc
"Docu.FchDoc" "Fecha Emisión" ? "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.Docu.NomCli
"Docu.NomCli" ? "x(60)" "character" ? ? ? ? ? ? no ? no no "54.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.Docu.ImpTot
"Docu.ImpTot" "Importe del Rebade" ? "decimal" ? ? ? ? ? ? no ? no no "13.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _TblList          = "Temp-Tables.Docu-2"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.Docu-2.CodDoc
     _FldNameList[2]   = Temp-Tables.Docu-2.NroDoc
     _FldNameList[3]   > Temp-Tables.Docu-2.ImpTot
"Docu-2.ImpTot" "Importe Rebade" ? "decimal" ? ? ? ? ? ? no ? no no "14.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* GENERACION DE NOTAS DE CREDITO POR REBATE */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* GENERACION DE NOTAS DE CREDITO POR REBATE */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Excel W-Win
ON CHOOSE OF BUTTON-Excel IN FRAME F-Main /* IMPORTAR EXCEL */
DO:
  RUN Importar-Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-NC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-NC W-Win
ON CHOOSE OF BUTTON-NC IN FRAME F-Main /* GENERAR NOTAS DE CREDITO */
DO:
  ASSIGN
      c-NroSer x-CodMon x-Concepto x-NomCon x-FchDoc FILL-IN-ImpTot.
  /* Consistencias */
  IF x-Concepto = '' THEN DO:
      MESSAGE 'Ingrese el código del concepto'
          VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF x-FchDoc = ? THEN DO:
      MESSAGE 'Ingrese la fecha para las Notas de Crédito'
          VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF FILL-IN-ImpTot = 0 THEN DO:
      MESSAGE 'No se ha cargado la información del EXCEL'
          VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  
  MESSAGE 'Se van a generar las Notas de Crédito' SKIP(1)
      'N° de Serie:' c-NroSer SKIP
      'Moneda:' (IF x-CodMon = 1 THEN 'Soles' ELSE 'Dólares') SKIP
      'Concepto:' x-Concepto x-NomCon SKIP
      'Fecha de las N/C' x-FchDoc SKIP(1)
      'Continuamos con la generación?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
      UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  RUN Generar-NC.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-NroSer W-Win
ON VALUE-CHANGED OF c-NroSer IN FRAME F-Main /* Nº Serie N/C */
DO:
  FIND Faccorre WHERE codcia = s-codcia
      AND coddoc = s-coddoc
      AND nroser = INTEGER(SELF:SCREEN-VALUE)
      NO-LOCK.
  FILL-IN-1:SCREEN-VALUE = STRING(Faccorre.nroser,'999') + STRING(Faccorre.correlativo, '999999').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Concepto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Concepto W-Win
ON LEAVE OF x-Concepto IN FRAME F-Main /* Concepto */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia AND 
        CcbTabla.Tabla  = s-coddoc AND 
        CcbTabla.Codigo = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE CcbTabla THEN DO:
        MESSAGE 'Concepto no registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    x-NomCon:SCREEN-VALUE = CcbTabla.nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Concepto W-Win
ON LEFT-MOUSE-DBLCLICK OF x-Concepto IN FRAME F-Main /* Concepto */
OR F8 OF x-Concepto
DO:
    ASSIGN
        input-var-1 = s-coddoc
        input-var-2 = ""
        input-var-3 = "".
    RUN LKUP\C-ABOCAR-2 ('Conceptos para Notas de Crédito').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-5
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Series W-Win 
PROCEDURE Carga-Series :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  L-NROSER = "".
  FOR EACH Faccorre NO-LOCK WHERE 
           Faccorre.CodCia = S-CODCIA AND
           Faccorre.CodDoc = S-CODDOC AND
           Faccorre.CodDiv = S-CODDIV AND
           Faccorre.FlgEst = YES:
      IF L-NROSER = "" THEN L-NROSER = STRING(Faccorre.NroSer,"999").
      ELSE L-NROSER = L-NROSER + "," + STRING(Faccorre.NroSer,"999").
  END.
  DO WITH FRAME {&FRAME-NAME}:
     C-NroSer:LIST-ITEMS = L-NROSER.
     S-NROSER = INTEGER(ENTRY(1,C-NroSer:LIST-ITEMS)).
     C-NROSER = ENTRY(1,C-NroSer:LIST-ITEMS).
     DISPLAY C-NROSER.
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
  DISPLAY c-NroSer FILL-IN-1 x-Mensaje x-CodMon x-Concepto x-NomCon x-FchDoc 
          FILL-IN-ImpTot 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 c-NroSer BUTTON-Excel x-CodMon BUTTON-NC x-Concepto x-FchDoc 
         BROWSE-5 BROWSE-7 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generar-NC W-Win 
PROCEDURE Generar-NC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


FIND FIRST Faccfggn WHERE codcia = s-codcia NO-LOCK.
FIND CURRENT Faccorre EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN RETURN 'ADM-ERROR'.

x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** GENERANDO NOTAS DE CREDITO **'.

EMPTY TEMP-TABLE t-cdocu.
EMPTY TEMP-TABLE t-ddocu.

FOR EACH DOCU:
    FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.coddoc = DOCU.coddoc
        AND ccbcdocu.nrodoc = DOCU.nrodoc
        NO-LOCK.
    CREATE t-cdocu.
    ASSIGN
        t-cdocu.codcia = s-codcia
        t-cdocu.coddoc = 'N/C'
        t-cdocu.coddiv = s-coddiv
        t-cdocu.nrodoc = STRING(Faccorre.nroser, '999') + STRING(Faccorre.correlativo, '999999')
        t-cdocu.fchdoc = x-FchDoc       /* OJO */
        t-cdocu.fchvto = x-FchDoc
        t-cdocu.codcli = ccbcdocu.codcli
        t-cdocu.ruccli = ccbcdocu.ruccli
        t-cdocu.nomcli = ccbcdocu.nomcli
        t-cdocu.dircli = ccbcdocu.dircli
        t-cdocu.porigv = ( IF ccbcdocu.porigv > 0 THEN ccbcdocu.porigv ELSE FacCfgGn.PorIgv )
        t-cdocu.codmon = x-CodMon
        t-cdocu.usuario = s-user-id
        t-cdocu.tpocmb = Faccfggn.tpocmb[1]
        t-cdocu.codref = ccbcdocu.coddoc
        t-cdocu.nroref = ccbcdocu.nrodoc
        t-cdocu.codven = ccbcdocu.codven
        t-cdocu.cndcre = 'N'
        t-cdocu.fmapgo = ccbcdocu.fmapgo.
    /* ACTUALIZAMOS EL CENTRO DE COSTO */
    FIND GN-VEN WHERE GN-VEN.codcia = s-codcia
        AND GN-VEN.codven = t-cdocu.codven NO-LOCK NO-ERROR.
    IF AVAILABLE GN-VEN THEN t-cdocu.cco = GN-VEN.cco.
    /*t-cdocu.glosa = 'DESCUENTO POR VOLUMEN'.*/
    ASSIGN
        Faccorre.correlativo = Faccorre.correlativo + 1.
    FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia
        AND CcbTabla.Tabla  = 'N/C' 
        AND CcbTabla.Codigo = x-Concepto NO-LOCK.
    CREATE t-ddocu.
    BUFFER-COPY t-cdocu TO t-ddocu.
    ASSIGN
        t-ddocu.codmat = CcbTabla.Codigo
        t-ddocu.factor = 1
        t-ddocu.candes = 1
        t-ddocu.preuni = DOCU.ImpTot
        t-ddocu.implin = t-ddocu.CanDes * t-ddocu.PreUni.
    IF CcbTabla.Afecto THEN
        ASSIGN
        t-ddocu.AftIgv = Yes
        t-ddocu.ImpIgv = (t-ddocu.CanDes * t-ddocu.PreUni) * ((t-cdocu.PorIgv / 100) / (1 + (t-cdocu.PorIgv / 100))).
    ELSE
        ASSIGN
        t-ddocu.AftIgv = No
        t-ddocu.ImpIgv = 0.
    t-ddocu.NroItm = 1.
    ASSIGN
      t-cdocu.ImpBrt = 0
      t-cdocu.ImpExo = 0
      t-cdocu.ImpDto = 0
      t-cdocu.ImpIgv = 0
      t-cdocu.ImpTot = 0.
    FOR EACH t-ddocu OF t-cdocu NO-LOCK:
      ASSIGN
            t-cdocu.ImpBrt = t-cdocu.ImpBrt + (IF t-ddocu.AftIgv = Yes THEN t-ddocu.PreUni * t-ddocu.CanDes ELSE 0)
            t-cdocu.ImpExo = t-cdocu.ImpExo + (IF t-ddocu.AftIgv = No  THEN t-ddocu.PreUni * t-ddocu.CanDes ELSE 0)
            t-cdocu.ImpDto = t-cdocu.ImpDto + t-ddocu.ImpDto
            t-cdocu.ImpIgv = t-cdocu.ImpIgv + t-ddocu.ImpIgv
            t-cdocu.ImpTot = t-cdocu.ImpTot + t-ddocu.ImpLin.
    END.
    ASSIGN 
        t-cdocu.ImpVta = t-cdocu.ImpBrt - t-cdocu.ImpIgv
        t-cdocu.ImpBrt = t-cdocu.ImpBrt - t-cdocu.ImpIgv + t-cdocu.ImpDto
        t-cdocu.SdoAct = t-cdocu.ImpTot
        t-cdocu.FlgEst = 'P'.
END.

FOR EACH t-cdocu:
    CREATE ccbcdocu.
    BUFFER-COPY t-cdocu TO ccbcdocu.
    FOR EACH t-ddocu OF t-cdocu:
        CREATE ccbddocu.
        BUFFER-COPY t-ddocu TO ccbddocu.
    END.
    /* RHC 02-07-2012 ASIENTO DE TRANSFERENCIA PARA SPEED */
    RUN aplic/sypsa/registroventas (INPUT ROWID(ccbcdocu), INPUT "I", YES).
    /* ************************************************** */
END.

EMPTY TEMP-TABLE DOCU.

IF AVAILABLE(Faccorre) THEN RELEASE Faccorre.
IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.

{&OPEN-QUERY-{&BROWSE-NAME}}

x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** PROCESO TERMINADO **'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel W-Win 
PROCEDURE Importar-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.
DEFINE VARIABLE FILL-IN-file AS CHAR NO-UNDO.

SYSTEM-DIALOG GET-FILE FILL-IN-file
    FILTERS "Archivos Excel (*.xls)" "*.xls", "Todos (*.*)" "*.*"
    TITLE "Archivo(s) de Carga..."
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

/* PRIMERO BORRAMOS TODO EL DETALLE */
EMPTY TEMP-TABLE DOCU.

/* SEGUNDO IMPORTAMOS DESDE EL EXCEL */
DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chWorkbook AS COM-HANDLE.
DEFINE VARIABLE chWorksheet AS COM-HANDLE.

DEFINE VARIABLE cRange AS CHARACTER NO-UNDO.
DEFINE VARIABLE iCountLine AS INTEGER NO-UNDO.
DEFINE VARIABLE iTotalColumn AS INTEGER NO-UNDO.
DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.

CREATE "Excel.Application" chExcelApplication.

chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-file).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

iCountLine = 1.     /* Saltamos el encabezado de los campos */
REPEAT:
    iCountLine = iCountLine + 1.
    cRange = "A" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */
    CREATE DOCU.
    /* CODIGO */
    cRange = "A" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN
        DOCU.CodDoc = cValue.
    /* NUMERO */
    cRange = "B" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN
        DOCU.NroDoc = cValue.
    DISPLAY "** IMPORTANDO ** " + DOCU.CodDoc + ' ' + DOCU.NroDoc @ x-mensaje WITH FRAME {&FRAME-NAME}.
    /* IMPORTE */
    cRange = "C" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN
        DOCU.ImpTot = DECIMAL (cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Valor' cValue 'no reconocido:' cValue SKIP
            'Campo: Importe Rebade' VIEW-AS ALERT-BOX ERROR.
        NEXT.
    END.
END.
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

/* Depurando */
FILL-IN-ImpTot = 0.
FOR EACH DOCU:
    FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.coddoc = DOCU.coddoc
        AND Ccbcdocu.nrodoc = DOCU.nrodoc
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbcdocu THEN DOCU.nomcli = Ccbcdocu.nomcli.
    ELSE DO:
        DELETE DOCU.
        NEXT.
    END.
    FILL-IN-ImpTot = FILL-IN-ImpTot + DOCU.ImpTot.
END.
DISPLAY
    "** IMPORTACION TERMINADA **" @ x-Mensaje
    FILL-IN-ImpTot
    WITH FRAME {&FRAME-NAME}.

{&OPEN-QUERY-{&BROWSE-NAME}}

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
      x-FchDoc = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Carga-Series.
  APPLY 'VALUE-CHANGED' TO c-NroSer IN FRAME {&FRAME-NAME}.

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "Docu-2"}
  {src/adm/template/snd-list.i "Docu"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

