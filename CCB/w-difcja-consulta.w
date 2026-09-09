&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win
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

DEF VAR s-coddoc AS CHAR INIT "DCC" NO-UNDO.

&SCOPED-DEFINE Condicion Ccbpendep.codcia = s-codcia ~
AND (COMBO-BOX-CodDiv = 'Todas' OR Ccbpendep.coddiv = COMBO-BOX-CodDiv) ~
AND Ccbpendep.coddoc = s-coddoc ~
AND Ccbpendep.flgest = "C" ~
AND Ccbpendep.fchcie >= FILL-IN-FchIni ~
AND Ccbpendep.fchcie <= FILL-IN-FchFin

DEF TEMP-TABLE Detalle
    FIELD CodDiv LIKE Ccbpendep.coddiv      COLUMN-LABEL 'Division' FORMAT 'x(5)'
    FIELD NomDiv AS CHAR                    COLUMN-LABEL 'Nombre'   FORMAT 'x(40)'
    FIELD Usuario LIKE Ccbpendep.usuario    COLUMN-LABEL 'Cajero' FORMAT 'x(10)'
    FIELD FchCie LIKE Ccbpendep.fchcie      COLUMN-LABEL 'Fecha de Cierre' FORMAT '99/99/9999'
    FIELD HorCie LIKE Ccbpendep.horci       COLUMN-LABEL 'Hora de Cierre' FORMAT 'x(8)'
    FIELD Codigo AS CHAR FORMAT 'x(8)'      COLUMN-LABEL 'Sustento'
    FIELD Descripcion AS CHAR FORMAT 'x(40)'    COLUMN-LABEL 'Descripcion'
    FIELD Comentario AS CHAR FORMAT 'x(40)'     COLUMN-LABEL 'Comentario'
    FIELD DifNac AS DEC                     COLUMN-LABEL 'Diferencia S/'  FORMAT '(>>>,>>9.99)'
    FIELD DifUsa AS DEC                     COLUMN-LABEL 'Diferencia US$' FORMAT '(>>>,>>9.99)'
    .

DEF VAR x-DifNac AS DEC NO-UNDO.
DEF VAR x-DifUsa AS DEC NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbPenDep GN-DIVI CcbTabla

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 CcbPenDep.CodDiv GN-DIVI.DesDiv ~
CcbPenDep.usuario CcbPenDep.FchCie CcbPenDep.HorCie CcbPenDep.Libre_c01 ~
CcbTabla.Nombre CcbPenDep.Libre_c02 ~
CcbPenDep.SdoNac  - CcbPenDep.ImpNac @ x-DifNac ~
CcbPenDep.SdoUsa - CcbPenDep.ImpUsa  @ x-DifUsa 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH CcbPenDep ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST GN-DIVI OF CcbPenDep NO-LOCK, ~
      FIRST CcbTabla WHERE CcbTabla.CodCia = CcbPenDep.CodCia ~
  AND CcbTabla.Tabla = CcbPenDep.CodDoc ~
  AND CcbTabla.Codigo = CcbPenDep.Libre_c01 OUTER-JOIN NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH CcbPenDep ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST GN-DIVI OF CcbPenDep NO-LOCK, ~
      FIRST CcbTabla WHERE CcbTabla.CodCia = CcbPenDep.CodCia ~
  AND CcbTabla.Tabla = CcbPenDep.CodDoc ~
  AND CcbTabla.Codigo = CcbPenDep.Libre_c01 OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 CcbPenDep GN-DIVI CcbTabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 CcbPenDep
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 GN-DIVI
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-2 CcbTabla


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-CodDiv BUTTON-9 FILL-IN-FchIni ~
FILL-IN-FchFin BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodDiv FILL-IN-FchIni ~
FILL-IN-FchFin 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-9 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 9" 
     SIZE 7 BY 1.54.

DEFINE VARIABLE COMBO-BOX-CodDiv AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "División" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Todas","Todas"
     DROP-DOWN-LIST
     SIZE 52 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchFin AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchIni AS DATE FORMAT "99/99/9999":U 
     LABEL "Cerradas desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      CcbPenDep, 
      GN-DIVI, 
      CcbTabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      CcbPenDep.CodDiv COLUMN-LABEL "División" FORMAT "x(5)":U
      GN-DIVI.DesDiv FORMAT "X(40)":U WIDTH 23.57
      CcbPenDep.usuario COLUMN-LABEL "Cajero" FORMAT "x(10)":U
      CcbPenDep.FchCie COLUMN-LABEL "Fecha de!Cierre" FORMAT "99/99/9999":U
      CcbPenDep.HorCie COLUMN-LABEL "Hora de!Cierre" FORMAT "x(8)":U
      CcbPenDep.Libre_c01 COLUMN-LABEL "Sustento" FORMAT "x(8)":U
      CcbTabla.Nombre COLUMN-LABEL "Descripcion" FORMAT "x(40)":U
            WIDTH 25.29
      CcbPenDep.Libre_c02 COLUMN-LABEL "Comentario" FORMAT "x(40)":U
            WIDTH 28.43
      CcbPenDep.SdoNac  - CcbPenDep.ImpNac @ x-DifNac COLUMN-LABEL "Diferencia S/" FORMAT "->>>,>>9.99":U
            WIDTH 10.57
      CcbPenDep.SdoUsa - CcbPenDep.ImpUsa  @ x-DifUsa COLUMN-LABEL "Diferencia US$" FORMAT "->>>,>>9.99":U
            WIDTH 10.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 140 BY 21.73
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-CodDiv AT ROW 1.19 COL 13 COLON-ALIGNED WIDGET-ID 2
     BUTTON-9 AT ROW 1.19 COL 134 WIDGET-ID 8
     FILL-IN-FchIni AT ROW 2.15 COL 13 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-FchFin AT ROW 2.15 COL 33 COLON-ALIGNED WIDGET-ID 6
     BROWSE-2 AT ROW 3.31 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 141.86 BY 24.42
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "CONSULTA SUSTENTO DIFERENCIA CIERRE DE CAJA"
         HEIGHT             = 24.42
         WIDTH              = 141.86
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 144.29
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 144.29
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
/* BROWSE-TAB BROWSE-2 FILL-IN-FchFin F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.CcbPenDep,INTEGRAL.GN-DIVI OF INTEGRAL.CcbPenDep,INTEGRAL.CcbTabla WHERE INTEGRAL.CcbPenDep ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST, FIRST OUTER"
     _Where[1]         = "{&Condicion}"
     _JoinCode[3]      = "CcbTabla.CodCia = CcbPenDep.CodCia
  AND CcbTabla.Tabla = CcbPenDep.CodDoc
  AND CcbTabla.Codigo = CcbPenDep.Libre_c01"
     _FldNameList[1]   > INTEGRAL.CcbPenDep.CodDiv
"CcbPenDep.CodDiv" "División" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.GN-DIVI.DesDiv
"GN-DIVI.DesDiv" ? ? "character" ? ? ? ? ? ? no ? no no "23.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.CcbPenDep.usuario
"CcbPenDep.usuario" "Cajero" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.CcbPenDep.FchCie
"CcbPenDep.FchCie" "Fecha de!Cierre" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CcbPenDep.HorCie
"CcbPenDep.HorCie" "Hora de!Cierre" "x(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.CcbPenDep.Libre_c01
"CcbPenDep.Libre_c01" "Sustento" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.CcbTabla.Nombre
"CcbTabla.Nombre" "Descripcion" ? "character" ? ? ? ? ? ? no ? no no "25.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.CcbPenDep.Libre_c02
"CcbPenDep.Libre_c02" "Comentario" "x(40)" "character" ? ? ? ? ? ? no ? no no "28.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"CcbPenDep.SdoNac  - CcbPenDep.ImpNac @ x-DifNac" "Diferencia S/" "->>>,>>9.99" ? ? ? ? ? ? ? no ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"CcbPenDep.SdoUsa - CcbPenDep.ImpUsa  @ x-DifUsa" "Diferencia US$" "->>>,>>9.99" ? ? ? ? ? ? ? no ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONSULTA SUSTENTO DIFERENCIA CIERRE DE CAJA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONSULTA SUSTENTO DIFERENCIA CIERRE DE CAJA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-9 W-Win
ON CHOOSE OF BUTTON-9 IN FRAME F-Main /* Button 9 */
DO:
    /* Archivo de Salida */
    DEF VAR c-csv-file AS CHAR NO-UNDO.
    DEF VAR c-xls-file AS CHAR INIT 'Archivo_Excel' NO-UNDO.
    DEF VAR rpta AS LOG INIT NO NO-UNDO.

    SYSTEM-DIALOG GET-FILE c-xls-file
        FILTERS 'Libro de Excel' '*.xlsx'
        INITIAL-FILTER 1
        ASK-OVERWRITE
        CREATE-TEST-FILE
        DEFAULT-EXTENSION ".xlsx"
        SAVE-AS
        TITLE "Guardar como"
        USE-FILENAME
        UPDATE rpta.
    IF rpta = NO THEN RETURN.

    SESSION:SET-WAIT-STATE('GENERAL').
    /* Variable de memoria */
    DEFINE VAR hProc AS HANDLE NO-UNDO.
    /* Levantamos la libreria a memoria */
    RUN lib\Tools-to-excel PERSISTENT SET hProc.

    /* Cargamos la informacion al temporal */
    EMPTY TEMP-TABLE Detalle.
    FOR EACH Ccbpendep NO-LOCK WHERE {&Condicion},
        FIRST GN-DIVI OF CcbPenDep NO-LOCK:
        CREATE Detalle.
        ASSIGN
            Detalle.CodDiv = Ccbpendep.coddiv
            Detalle.NomDiv = GN-DIVI.DesDiv
            Detalle.Usuario = Ccbpendep.usuario
            Detalle.FchCie = Ccbpendep.fchcie
            Detalle.HorCie = Ccbpendep.horcie
            Detalle.DifNac = CcbPenDep.SdoNac - CcbPenDep.ImpNac
            Detalle.DifUsa = CcbPenDep.SdoUsa - CcbPenDep.ImpUsa
            Detalle.Codigo = Ccbpendep.libre_c01
            Detalle.Comentario = CcbPenDep.Libre_c02.
        FIND FIRST CcbTabla WHERE CcbTabla.CodCia = CcbPenDep.CodCia
            AND CcbTabla.Tabla = CcbPenDep.CodDoc
            AND CcbTabla.Codigo = CcbPenDep.Libre_c01 
            NO-LOCK NO-ERROR.
        IF AVAILABLE CcbTabla THEN Detalle.Descripcion = CcbTabla.Nombre.
    END.

    /* Programas que generan el Excel */
    RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER Detalle:HANDLE,
                                      INPUT c-xls-file,
                                      OUTPUT c-csv-file) .

    RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER Detalle:handle,
                                      INPUT  c-csv-file,
                                      OUTPUT c-xls-file) .

    /* Borramos librerias de la memoria */
    DELETE PROCEDURE hProc.
    SESSION:SET-WAIT-STATE('').
    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX WARNING.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodDiv W-Win
ON VALUE-CHANGED OF COMBO-BOX-CodDiv IN FRAME F-Main /* División */
DO:
  ASSIGN {&self-name}.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchFin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchFin W-Win
ON LEAVE OF FILL-IN-FchFin IN FRAME F-Main /* Hasta */
DO:
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchIni
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchIni W-Win
ON LEAVE OF FILL-IN-FchIni IN FRAME F-Main /* Cerradas desde */
DO:
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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
  DISPLAY COMBO-BOX-CodDiv FILL-IN-FchIni FILL-IN-FchFin 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-CodDiv BUTTON-9 FILL-IN-FchIni FILL-IN-FchFin BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
      FILL-IN-FchFin = TODAY
      FILL-IN-FchIni = TODAY - DAY(TODAY) + 1.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-CodDiv:DELIMITER = '|'.
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:
          COMBO-BOX-CodDiv:ADD-LAST(gn-divi.coddiv + ' - ' + gn-divi.desdiv,gn-divi.coddiv).
      END.
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
  {src/adm/template/snd-list.i "CcbPenDep"}
  {src/adm/template/snd-list.i "GN-DIVI"}
  {src/adm/template/snd-list.i "CcbTabla"}

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

