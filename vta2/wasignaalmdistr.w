&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-Lista FOR GN-DIVI.
DEFINE BUFFER COTIZACION FOR FacCPedi.



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

DEFINE SHARED VAR s-user-id AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacCPedi B-Lista Almacen

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 FacCPedi.NroPed FacCPedi.CodDiv ~
FacCPedi.Libre_c01 FacCPedi.FchPed FacCPedi.CodCli FacCPedi.NomCli ~
FacCPedi.LugEnt2 FacCPedi.ImpTot fTotPeso() @ FacCPedi.Libre_d01 ~
FacCPedi.FchEnt FacCPedi.usuario 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 FacCPedi.FchEnt 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-3 FacCPedi
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-3 FacCPedi
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH FacCPedi ~
      WHERE FacCPedi.FchPed >= Desde ~
 AND FacCPedi.FchPed <= Hasta ~
 AND FacCPedi.CodCia = s-codcia ~
 AND FacCPedi.CodDoc = "COT" ~
 AND FacCPedi.FlgEst = "P" ~
 AND FacCPedi.CodDiv = x-CodDiv ~
 AND FacCPedi.NomCli BEGINS x-NomCli NO-LOCK, ~
      FIRST B-Lista WHERE B-Lista.CodCia = FacCPedi.CodCia ~
  AND B-Lista.CodDiv = FacCPedi.Libre_c01 ~
      AND B-Lista.CanalVenta = "FER" NO-LOCK, ~
      FIRST Almacen WHERE Almacen.CodCia = FacCPedi.CodCia ~
  AND Almacen.CodAlm = FacCPedi.LugEnt2 OUTER-JOIN NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH FacCPedi ~
      WHERE FacCPedi.FchPed >= Desde ~
 AND FacCPedi.FchPed <= Hasta ~
 AND FacCPedi.CodCia = s-codcia ~
 AND FacCPedi.CodDoc = "COT" ~
 AND FacCPedi.FlgEst = "P" ~
 AND FacCPedi.CodDiv = x-CodDiv ~
 AND FacCPedi.NomCli BEGINS x-NomCli NO-LOCK, ~
      FIRST B-Lista WHERE B-Lista.CodCia = FacCPedi.CodCia ~
  AND B-Lista.CodDiv = FacCPedi.Libre_c01 ~
      AND B-Lista.CanalVenta = "FER" NO-LOCK, ~
      FIRST Almacen WHERE Almacen.CodCia = FacCPedi.CodCia ~
  AND Almacen.CodAlm = FacCPedi.LugEnt2 OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 FacCPedi B-Lista Almacen
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 FacCPedi
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-3 B-Lista
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-3 Almacen


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-25 RECT-26 x-CodAlm x-CodDiv BUTTON-1 ~
Desde Hasta x-NomCli BROWSE-3 
&Scoped-Define DISPLAYED-OBJECTS x-CodAlm x-CodDiv Desde Hasta x-NomCli 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fTotPeso W-Win 
FUNCTION fTotPeso RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "ASIGNA ALMACEN DE DISTRIBUCION" 
     SIZE 31 BY 1.12.

DEFINE VARIABLE x-CodAlm AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione almacén" 
     LABEL "Almacén" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Seleccione almacén","Seleccione almacén"
     DROP-DOWN-LIST
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE x-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Origen" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 54 BY 1 NO-UNDO.

DEFINE VARIABLE Desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE Hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69 BY 3.46.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 3.46.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      FacCPedi, 
      B-Lista, 
      Almacen SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      FacCPedi.NroPed COLUMN-LABEL "Cotización" FORMAT "X(12)":U
      FacCPedi.CodDiv COLUMN-LABEL "Origen" FORMAT "x(5)":U
      FacCPedi.Libre_c01 COLUMN-LABEL "Lista Precios" FORMAT "x(5)":U
      FacCPedi.FchPed COLUMN-LABEL "Emisión" FORMAT "99/99/9999":U
            WIDTH 8.86
      FacCPedi.CodCli COLUMN-LABEL "Cliente" FORMAT "x(11)":U WIDTH 10.86
      FacCPedi.NomCli FORMAT "x(50)":U
      FacCPedi.LugEnt2 COLUMN-LABEL "Almacén!Distribución" FORMAT "x(10)":U
            WIDTH 9
      FacCPedi.ImpTot FORMAT "->>,>>>,>>9.99":U WIDTH 10.43
      fTotPeso() @ FacCPedi.Libre_d01 COLUMN-LABEL "Total Peso!Kg." FORMAT ">>>,>>9.99":U
            WIDTH 8.72
      FacCPedi.FchEnt FORMAT "99/99/9999":U
      FacCPedi.usuario COLUMN-LABEL "Usuario" FORMAT "x(10)":U
            WIDTH 10.29
  ENABLE
      FacCPedi.FchEnt
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 137 BY 18.65
         FONT 4
         TITLE "Seleccione la(s) Cotizacion(es)" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodAlm AT ROW 1.38 COL 77 COLON-ALIGNED WIDGET-ID 10
     x-CodDiv AT ROW 1.58 COL 13 COLON-ALIGNED WIDGET-ID 6
     BUTTON-1 AT ROW 2.35 COL 79 WIDGET-ID 16
     Desde AT ROW 2.54 COL 13 COLON-ALIGNED WIDGET-ID 2
     Hasta AT ROW 2.54 COL 32 COLON-ALIGNED WIDGET-ID 4
     x-NomCli AT ROW 3.5 COL 13 COLON-ALIGNED WIDGET-ID 18
     BROWSE-3 AT ROW 4.85 COL 2 WIDGET-ID 200
     "Filtros" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1 COL 3 WIDGET-ID 14
          BGCOLOR 9 FGCOLOR 15 
     RECT-25 AT ROW 1.19 COL 2 WIDGET-ID 8
     RECT-26 AT ROW 1.19 COL 71 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 139.29 BY 22.77
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-Lista B "?" ? INTEGRAL GN-DIVI
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ASIGNACION DEL ALMACEN DE DISTRIBUCION"
         HEIGHT             = 22.77
         WIDTH              = 139.29
         MAX-HEIGHT         = 22.77
         MAX-WIDTH          = 144.14
         VIRTUAL-HEIGHT     = 22.77
         VIRTUAL-WIDTH      = 144.14
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
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-3 x-NomCli F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "INTEGRAL.FacCPedi,B-Lista WHERE INTEGRAL.FacCPedi ...,INTEGRAL.Almacen WHERE INTEGRAL.FacCPedi ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST, FIRST OUTER"
     _Where[1]         = "FacCPedi.FchPed >= Desde
 AND FacCPedi.FchPed <= Hasta
 AND FacCPedi.CodCia = s-codcia
 AND FacCPedi.CodDoc = ""COT""
 AND FacCPedi.FlgEst = ""P""
 AND FacCPedi.CodDiv = x-CodDiv
 AND FacCPedi.NomCli BEGINS x-NomCli"
     _JoinCode[2]      = "B-Lista.CodCia = FacCPedi.CodCia
  AND B-Lista.CodDiv = FacCPedi.Libre_c01"
     _Where[2]         = "B-Lista.CanalVenta = ""FER"""
     _JoinCode[3]      = "INTEGRAL.Almacen.CodCia = FacCPedi.CodCia
  AND INTEGRAL.Almacen.CodAlm = FacCPedi.LugEnt2"
     _FldNameList[1]   > INTEGRAL.FacCPedi.NroPed
"INTEGRAL.FacCPedi.NroPed" "Cotización" "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCPedi.CodDiv
"INTEGRAL.FacCPedi.CodDiv" "Origen" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.Libre_c01
"INTEGRAL.FacCPedi.Libre_c01" "Lista Precios" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.FchPed
"INTEGRAL.FacCPedi.FchPed" "Emisión" ? "date" ? ? ? ? ? ? no ? no no "8.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacCPedi.CodCli
"INTEGRAL.FacCPedi.CodCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "10.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = INTEGRAL.FacCPedi.NomCli
     _FldNameList[7]   > INTEGRAL.FacCPedi.LugEnt2
"INTEGRAL.FacCPedi.LugEnt2" "Almacén!Distribución" "x(10)" "character" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.FacCPedi.ImpTot
"INTEGRAL.FacCPedi.ImpTot" ? ? "decimal" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"fTotPeso() @ FacCPedi.Libre_d01" "Total Peso!Kg." ">>>,>>9.99" ? ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.FacCPedi.FchEnt
"INTEGRAL.FacCPedi.FchEnt" ? ? "date" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.FacCPedi.usuario
"INTEGRAL.FacCPedi.usuario" "Usuario" ? "character" ? ? ? ? ? ? no ? no no "10.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ASIGNACION DEL ALMACEN DE DISTRIBUCION */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ASIGNACION DEL ALMACEN DE DISTRIBUCION */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ASIGNA ALMACEN DE DISTRIBUCION */
DO:
  ASSIGN x-CodAlm.
  IF x-CodAlm BEGINS 'Seleccione' THEN RETURN NO-APPLY.
  RUN Asigna-Almacen.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Desde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Desde W-Win
ON LEAVE OF Desde IN FRAME F-Main /* Emitidos Desde */
DO:
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Hasta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Hasta W-Win
ON LEAVE OF Hasta IN FRAME F-Main /* Hasta */
DO:
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodDiv W-Win
ON VALUE-CHANGED OF x-CodDiv IN FRAME F-Main /* Origen */
DO:
  ASSIGN {&self-name}.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-NomCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NomCli W-Win
ON ANY-PRINTABLE OF x-NomCli IN FRAME F-Main /* Cliente */
DO:
    x-nomcli = SELF:SCREEN-VALUE + LAST-EVENT:LABEL.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NomCli W-Win
ON LEAVE OF x-NomCli IN FRAME F-Main /* Cliente */
DO:
    x-nomcli = SELF:SCREEN-VALUE /*+ LAST-EVENT:LABEL.*/.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Almacen W-Win 
PROCEDURE Asigna-Almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k AS INT NO-UNDO.

DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN DO:
        {lib/lock-genericov2.i &Tabla="COTIZACION" ~
            &Condicion="ROWID(COTIZACION)=ROWID(Faccpedi)" ~
            &Accion="RETRY" ~
            &Mensaje="YES" ~
            &TipoError="NEXT"
            }
        ASSIGN
            COTIZACION.LugEnt2 = x-CodAlm.
    END.
END.
RELEASE COTIZACION.
{&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/*
  Tabla: "Almacen"
  Condicion: "Almacen.codcia = s-codcia AND Almacen.codalm = s-codalm"
  Bloqueo: "EXCLUSIVE-LOCK (NO-WAIT)"
  Accion: "RETRY" | "LEAVE"
  Mensaje: "YES" | "NO"
  TipoError: "RETURN 'ADM-ERROR'" | "RETURN ERROR" |  "NEXT"
*/

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
  DISPLAY x-CodAlm x-CodDiv Desde Hasta x-NomCli 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-25 RECT-26 x-CodAlm x-CodDiv BUTTON-1 Desde Hasta x-NomCli 
         BROWSE-3 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable W-Win 
PROCEDURE local-enable :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
      Desde = TODAY - DAY(TODAY) + 1
      Hasta = TODAY
      x-CodDiv = '00015'.
      

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      x-CodDiv:DELETE('Todos').
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:
          x-CodDiv:ADD-LAST( GN-DIVI.CodDiv + ' - ' + GN-DIVI.DesDiv, GN-DIVI.CodDiv ).
          IF gn-divi.coddiv = '00015' THEN x-CodDiv:SCREEN-VALUE = GN-DIVI.CodDiv.
      END.
      FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
          AND Almacen.Campo-c[9] <> "I"
          AND Almacen.AutMov = YES
          AND Almacen.FlgRep = YES
          AND Almacen.Campo-c[6] = "Si"
          AND Almacen.AlmCsg = NO:
          x-CodAlm:ADD-LAST( Almacen.CodAlm + ' - ' + Almacen.Descripcion, Almacen.CodAlm ).
      END.
  END.

  /**/
  DEFINE BUFFER b-factabla FOR factabla.
  DEFINE VAR lUsrFchEnt AS CHAR.  

  lUsrFchEnt = "".
  FIND FIRST b-factabla WHERE b-factabla.codcia = s-codcia AND 
                             b-factabla.tabla = 'VALIDA' AND 
                             b-factabla.codigo = 'FCHENT' NO-LOCK NO-ERROR.
 IF AVAILABLE b-factabla THEN DO:
     lUsrFchEnt = b-factabla.campo-c[1].
 END.

 RELEASE b-factabla.

 {&FIRST-TABLE-IN-QUERY-BROWSE-3}.fchent:READ-ONLY IN BROWSE BROWSE-3 = YES.

 IF LOOKUP(s-user-id,lusrFchEnt) > 0 THEN DO:
     /* El usuario esta inscrito para no validar la fecha de entrega */
     {&FIRST-TABLE-IN-QUERY-BROWSE-3}.fchent:READ-ONLY IN BROWSE BROWSE-3 = NO.
 END.


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
  {src/adm/template/snd-list.i "FacCPedi"}
  {src/adm/template/snd-list.i "B-Lista"}
  {src/adm/template/snd-list.i "Almacen"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fTotPeso W-Win 
FUNCTION fTotPeso RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

 DEF VAR xTotPeso AS DEC.
  FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
      ASSIGN
          xTotPeso = xTotPeso + Facdpedi.canPed * Facdpedi.factor * Almmmatg.PesMat.
  END.
  RETURN xTotPeso.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

