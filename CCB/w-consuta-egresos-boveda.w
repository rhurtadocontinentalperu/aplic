&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-CcbCCaja NO-UNDO LIKE CcbCCaja.



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
DEF INPUT PARAMETER pParametro AS CHAR.

/* Sintaxis:
    TODOS: Todas las divisiones 
    DIVISION: SOlo la división activa 
*/
IF LOOKUP(pParametro, 'TODOS,DIVISION') = 0 THEN RETURN ERROR.

/* Local Variable Definitions ---                                       */

DEFINE SHARED VAR s-codcia AS INT .
DEFINE SHARED VAR s-coddiv AS CHAR.

/*RUN ue-data.*/

DEFINE VAR x-Autorizado AS CHAR NO-UNDO.


DEFINE TEMP-TABLE Detalle
    FIELD CodDiv LIKE Ccbccaja.coddiv COLUMN-LABEL 'División'
    FIELD NroDoc AS CHAR FORMAT 'x(12)' COLUMN-LABEL 'Número'
    FIELD Usuario AS CHAR FORMAT 'x(15)' COLUMN-LABEL 'Usuario'
    FIELD FchCie LIKE Ccbccaja.fchcie COLUMN-LABEL 'Fecha de Cierre'
    FIELD FchDoc LIKE Ccbccaja.fchdoc COLUMN-LABEL 'Fecha Emisión'
    FIELD Estado AS CHAR FORMAT 'x(15)' COLUMN-LABEL 'Estado'
    FIELD Autorizado AS CHAR FORMAT 'x(15)' COLUMN-LABEL 'Autorizado por'
    FIELD ImpNac AS DEC FORMAT '->>>,>>9.99' COLUMN-LABEL 'Importe S/.'
    FIELD ImpUsa AS DEC FORMAT '->>>,>>9.99' COLUMN-LABEL 'Importe US$'
    FIELD NroDep AS CHAR FORMAT 'x(20)' COLUMN-LABEL 'Nro. Depósito'
    .

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
&Scoped-define INTERNAL-TABLES tt-CcbCCaja

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tt-CcbCCaja.CodDiv ~
tt-CcbCCaja.NroDoc tt-CcbCCaja.usuario tt-CcbCCaja.FchCie ~
tt-CcbCCaja.FchDoc fEstado(tt-Ccbccaja.flgest) @ codcli ~
tt-CcbCCaja.Codcta[10] fMoneda(tt-ccbccaja.codmon) @ NroAst ~
(tt-CcbCCaja.ImpNac[1] + tt-CcbCCaja.ImpUSA[1] ) @ Importe ~
tt-CcbCCaja.CodBco[1] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tt-CcbCCaja NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tt-CcbCCaja NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tt-CcbCCaja
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tt-CcbCCaja


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-4 BtnDone cboDivision btnAceptar ~
txtDesde txtHasta Chkpendientes Chkautorizados Chkanulados BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS cboDivision txtDesde txtHasta ~
Chkpendientes Chkautorizados Chkanulados FILL-IN-Nac FILL-IN-Usa 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado W-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT pFlag AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fMoneda W-Win 
FUNCTION fMoneda RETURNS CHARACTER
  ( INPUT pMoneda AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnAceptar 
     LABEL "Consultar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 6 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 4" 
     SIZE 6 BY 1.54.

DEFINE VARIABLE cboDivision AS CHARACTER FORMAT "X(6)":U INITIAL "0" 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Item 1","0"
     DROP-DOWN-LIST
     SIZE 57 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Nac AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "SOLES" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Usa AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "DOLARES" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE Chkanulados AS LOGICAL INITIAL no 
     LABEL "Anulados" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .77 NO-UNDO.

DEFINE VARIABLE Chkautorizados AS LOGICAL INITIAL no 
     LABEL "Autorizados" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .77 NO-UNDO.

DEFINE VARIABLE Chkpendientes AS LOGICAL INITIAL yes 
     LABEL "Pendientes" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tt-CcbCCaja SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tt-CcbCCaja.CodDiv FORMAT "x(5)":U WIDTH 8.43
      tt-CcbCCaja.NroDoc FORMAT "X(12)":U
      tt-CcbCCaja.usuario COLUMN-LABEL "Usuario" FORMAT "x(10)":U
            WIDTH 12.43
      tt-CcbCCaja.FchCie FORMAT "99/99/9999":U
      tt-CcbCCaja.FchDoc FORMAT "99/99/9999":U WIDTH 10.86
      fEstado(tt-Ccbccaja.flgest) @ codcli COLUMN-LABEL "Estado" FORMAT "x(15)":U
            WIDTH 13.43
      tt-CcbCCaja.Codcta[10] COLUMN-LABEL "Autorizado por" FORMAT "x(10)":U
      fMoneda(tt-ccbccaja.codmon) @ NroAst COLUMN-LABEL "Moneda" FORMAT "x(15)":U
            WIDTH 11.43
      (tt-CcbCCaja.ImpNac[1] + tt-CcbCCaja.ImpUSA[1] ) @ Importe COLUMN-LABEL "Importe" FORMAT "->>,>>>,>>9.99":U
      tt-CcbCCaja.CodBco[1] COLUMN-LABEL "Nro. Depósito" FORMAT "x(15)":U
            WIDTH 15.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 130 BY 16.73 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-4 AT ROW 1.38 COL 106 WIDGET-ID 20
     BtnDone AT ROW 1.38 COL 112 WIDGET-ID 22
     cboDivision AT ROW 1.46 COL 8 COLON-ALIGNED WIDGET-ID 2
     btnAceptar AT ROW 1.46 COL 79 WIDGET-ID 14
     txtDesde AT ROW 2.81 COL 8 COLON-ALIGNED WIDGET-ID 4
     txtHasta AT ROW 2.81 COL 31.43 COLON-ALIGNED WIDGET-ID 6
     Chkpendientes AT ROW 3 COL 53 WIDGET-ID 8
     Chkautorizados AT ROW 3 COL 69 WIDGET-ID 10
     Chkanulados AT ROW 3 COL 84.29 WIDGET-ID 12
     FILL-IN-Nac AT ROW 4.08 COL 8 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-Usa AT ROW 4.08 COL 34 COLON-ALIGNED WIDGET-ID 18
     BROWSE-2 AT ROW 5.23 COL 3 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 133.72 BY 21.12 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-CcbCCaja T "?" NO-UNDO INTEGRAL CcbCCaja
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Egresos por Remesas de Boveda"
         HEIGHT             = 21.12
         WIDTH              = 133.72
         MAX-HEIGHT         = 21.12
         MAX-WIDTH          = 136
         VIRTUAL-HEIGHT     = 21.12
         VIRTUAL-WIDTH      = 136
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
/* BROWSE-TAB BROWSE-2 FILL-IN-Usa F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-Nac IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Usa IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tt-CcbCCaja"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-CcbCCaja.CodDiv
"tt-CcbCCaja.CodDiv" ? ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.tt-CcbCCaja.NroDoc
     _FldNameList[3]   > Temp-Tables.tt-CcbCCaja.usuario
"tt-CcbCCaja.usuario" "Usuario" ? "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.tt-CcbCCaja.FchCie
     _FldNameList[5]   > Temp-Tables.tt-CcbCCaja.FchDoc
"tt-CcbCCaja.FchDoc" ? ? "date" ? ? ? ? ? ? no ? no no "10.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fEstado(tt-Ccbccaja.flgest) @ codcli" "Estado" "x(15)" ? ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-CcbCCaja.Codcta[10]
"tt-CcbCCaja.Codcta[10]" "Autorizado por" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"fMoneda(tt-ccbccaja.codmon) @ NroAst" "Moneda" "x(15)" ? ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"(tt-CcbCCaja.ImpNac[1] + tt-CcbCCaja.ImpUSA[1] ) @ Importe" "Importe" "->>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-CcbCCaja.CodBco[1]
"tt-CcbCCaja.CodBco[1]" "Nro. Depósito" "x(15)" "character" ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Egresos por Remesas de Boveda */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Egresos por Remesas de Boveda */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON VALUE-CHANGED OF BROWSE-2 IN FRAME F-Main
DO:
    DEFINE VARIABLE i AS INTEGER NO-UNDO.

    FILL-IN-Nac = 0.
    FILL-IN-USA = 0.

    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
        IF NOT {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN NEXT.
        /*IF CcbDMvto.FlgEst = "C" THEN NEXT.*/
        FILL-IN-Nac = FILL-IN-Nac + TT-Ccbccaja.ImpNac[1].
        FILL-IN-Usa = FILL-IN-Usa + TT-Ccbccaja.ImpUSA[1].
    END.

    DISPLAY FILL-IN-Nac FILL-IN-USA WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnAceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnAceptar W-Win
ON CHOOSE OF btnAceptar IN FRAME F-Main /* Consultar */
DO:
  ASSIGN cboDivision.

  RUN ue-data.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
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


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
  RUN Excel.
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DISPLAY cboDivision txtDesde txtHasta Chkpendientes Chkautorizados Chkanulados 
          FILL-IN-Nac FILL-IN-Usa 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-4 BtnDone cboDivision btnAceptar txtDesde txtHasta 
         Chkpendientes Chkautorizados Chkanulados BROWSE-2 
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
FOR EACH tt-Ccbccaja NO-LOCK:
    CREATE Detalle.
    BUFFER-COPY tt-Ccbccaja
        TO Detalle
        ASSIGN
        Detalle.Estado = fEstado(tt-Ccbccaja.flgest) 
        Detalle.Autorizado = tt-Ccbccaja.codcta[10]
        Detalle.ImpNac = tt-Ccbccaja.impnac[1]
        Detalle.ImpUsa = tt-Ccbccaja.impusa[1]
        Detalle.NroDep = tt-Ccbccaja.CodBco[1].
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
    txtDesde:SCREEN-VALUE = STRING(TODAY - 5,"99/99/9999").
    txtHasta:SCREEN-VALUE = STRING(TODAY,"99/99/9999").
    CASE pParametro:
        WHEN "TODOS" THEN DO:
            cboDivision:DELIMITER = "|".
            cboDivision:DELETE(cboDivision:LIST-ITEM-PAIRS).
            cboDivision:ADD-LAST('Todos','TTTTT').
            cboDivision:SCREEN-VALUE = 'TTTTT'.
            FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia AND
                            INDEX(gn-divi.desdiv,"BAJA") = 0 
                            NO-LOCK BY coddiv:
                cboDivision:ADD-LAST(gn-divi.coddiv + ' - ' + gn-divi.desdiv, gn-divi.coddiv).
            END.
        END.
        OTHERWISE DO:
            cboDivision:DELIMITER = "|".
            cboDivision:DELETE(cboDivision:LIST-ITEM-PAIRS).
            FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia AND
                            gn-divi.coddiv = s-coddiv AND
                            INDEX(gn-divi.desdiv,"BAJA") = 0 
                            NO-LOCK BY coddiv:
                cboDivision:ADD-LAST(gn-divi.coddiv + ' - ' + gn-divi.desdiv, gn-divi.coddiv).
                cboDivision:SCREEN-VALUE = gn-divi.coddiv.
            END.

        END.
    END CASE.
    APPLY 'VALUE-CHANGED':U TO cboDivision.

END.

/*RUN ue-data.*/

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
  {src/adm/template/snd-list.i "tt-CcbCCaja"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-data W-Win 
PROCEDURE ue-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    ASSIGN cboDivision txtDesde txtHasta ChkPendientes ChkAutorizados chkAnulados.
END.

SESSION:SET-WAIT-STATE('GENERAL').

EMPTY TEMP-TABLE tt-ccbccaja.

DEFINE VAR lEstados AS CHAR.

lEstados = "".

IF chkPendientes = YES THEN lEstados = "E".
IF chkAutorizados = YES THEN lEstados = lEstados + "C".
IF chkAnulados = YES THEN lEstados = lEstados + "A".

FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia 
    AND (cboDivision = 'TTTTT' OR gn-divi.coddiv = cboDivision):
    FOR EACH ccbccaja USE-INDEX llave07 NO-LOCK WHERE ccbccaja.codcia = s-codcia AND
                                    ccbccaja.coddiv = gn-div.coddiv AND  
                                    ccbccaja.coddoc = 'E/C' AND 
                                    (ccbccaja.fchdoc >= txtDesde AND ccbccaja.fchdoc <= txtHasta) AND
                                    ccbccaja.tipo = 'REMEBOV' AND
                                    INDEX(lEstados,ccbccaja.flgest) > 0:
        CREATE tt-ccbccaja.
        BUFFER-COPY ccbccaja TO tt-ccbccaja.
        FIND FIRST Ccbdmvto WHERE Ccbdmvto.codcia = Ccbccaja.codcia
            AND Ccbdmvto.coddoc = Ccbccaja.coddoc
            AND Ccbdmvto.nrodoc = Ccbccaja.nrodoc
            AND Ccbdmvto.codref = "BOV"
            NO-LOCK NO-ERROR.
        IF AVAILABLE Ccbdmvto THEN tt-CcbCCaja.CodBco[1] = CcbDMvto.NroDep.
    END.

END.

SESSION:SET-WAIT-STATE('').

{&OPEN-QUERY-BROWSE-2}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado W-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT pFlag AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR lRetVal AS CHAR.

CASE pFlag:
    WHEN 'E' THEN lRetVal = "PENDIENTE".
    WHEN 'C' THEN lRetVal = "AUTORIZADO".
    WHEN 'A' THEN lRetVal = "ANULADO".
    OTHERWISE lRetVal = "(" + pFlag + ") Otros".
END CASE.

  RETURN lRetVal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fMoneda W-Win 
FUNCTION fMoneda RETURNS CHARACTER
  ( INPUT pMoneda AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR lRetVal AS CHAR.

lRetVal = "".

CASE pMoneda :
    WHEN 1 THEN lRetVal = 'Soles (S/.)'.
    WHEN 2 THEN lRetVal = "Dolares ($)".
        OTHERWISE lRetVal = "Desconocido".
END CASE.

RETURN lRetVal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

