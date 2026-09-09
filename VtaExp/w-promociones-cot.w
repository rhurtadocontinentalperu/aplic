&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE TEMP-TABLE t-report NO-UNDO LIKE w-report.



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

DEF VAR s-task-no AS INT NO-UNDO.

DEF TEMP-TABLE Detalle
    FIELD CodDiv AS CHAR FORMAT 'x(5)' COLUMN-LABEL 'División'
    FIELD ListaPrecio AS CHAR FORMAT 'x(5)' COLUMN-LABEL 'Lista Precio'
    FIELD FchPed AS DATE FORMAT '99/99/9999' COLUMN-LABEL 'Emisión'
    FIELD CodPed AS CHAR FORMAT 'x(3)' COLUMN-LABEL 'Doc'
    FIELD NroPed AS CHAR FORMAT 'x(12)' COLUMN-LABEL 'Numero'
    FIELD CodCli AS CHAR FORMAT 'x(12)' COLUMN-LABEL 'Cliente'
    FIELD NomCli AS CHAR FORMAT 'x(60)' COLUMN-LABEL 'Nombre'
    FIELD CodMat AS CHAR FORMAT 'x(8)' COLUMN-LABEL 'Articulo'
    FIELD DesMat AS CHAR FORMAT 'x(60)' COLUMN-LABEL 'Descripcion'
    FIELD UndVta AS CHAR FORMAT 'x(10)' COLUMN-LABEL 'Unidad'
    FIELD CanDes AS DEC FORMAT '->>>,>>9.99' COLUMN-LABEL 'Cantidad'
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
&Scoped-define INTERNAL-TABLES t-report

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 t-report.Campo-C[1] ~
t-report.Campo-C[2] t-report.Campo-D[1] t-report.Campo-C[3] ~
t-report.Campo-C[4] t-report.Campo-C[5] t-report.Campo-C[6] ~
t-report.Campo-C[7] t-report.Campo-C[8] t-report.Campo-C[9] ~
t-report.Campo-F[1] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH t-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH t-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 t-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 t-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-CodDiv BUTTON-5 BUTTON-Filtrar ~
COMBO-BOX-Lista FILL-IN-FchPed-1 FILL-IN-FchPed-2 BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodDiv COMBO-BOX-Lista ~
FILL-IN-FchPed-1 FILL-IN-FchPed-2 FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 5" 
     SIZE 6 BY 1.35.

DEFINE BUTTON BUTTON-Filtrar 
     LABEL "APLICAR FILTROS" 
     SIZE 16 BY 1.12.

DEFINE VARIABLE COMBO-BOX-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Divisiones" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Lista AS CHARACTER FORMAT "X(256)":U 
     LABEL "Lista de Precios" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchPed-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchPed-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      t-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      t-report.Campo-C[1] COLUMN-LABEL "División" FORMAT "X(8)":U
      t-report.Campo-C[2] COLUMN-LABEL "Lista Precios" FORMAT "X(8)":U
      t-report.Campo-D[1] COLUMN-LABEL "Emisión" FORMAT "99/99/9999":U
      t-report.Campo-C[3] COLUMN-LABEL "Doc" FORMAT "X(3)":U
      t-report.Campo-C[4] COLUMN-LABEL "Número" FORMAT "X(12)":U
      t-report.Campo-C[5] COLUMN-LABEL "Cliente" FORMAT "X(11)":U
            WIDTH 9.57
      t-report.Campo-C[6] COLUMN-LABEL "Nombre" FORMAT "X(40)":U
      t-report.Campo-C[7] COLUMN-LABEL "Artículo" FORMAT "X(8)":U
      t-report.Campo-C[8] COLUMN-LABEL "Descripción" FORMAT "X(40)":U
            WIDTH 33
      t-report.Campo-C[9] COLUMN-LABEL "Unidad" FORMAT "X(10)":U
      t-report.Campo-F[1] COLUMN-LABEL "Cantidad" FORMAT "->>>,>>9.99":U
            WIDTH 9
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 136 BY 20.73
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-CodDiv AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 2
     BUTTON-5 AT ROW 1.81 COL 91 WIDGET-ID 14
     BUTTON-Filtrar AT ROW 2.08 COL 72 WIDGET-ID 10
     COMBO-BOX-Lista AT ROW 2.35 COL 19 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-FchPed-1 AT ROW 3.42 COL 19 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-FchPed-2 AT ROW 3.42 COL 39 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-Mensaje AT ROW 3.42 COL 69 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     BROWSE-2 AT ROW 4.5 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 140.43 BY 24.81
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
      TABLE: t-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "PROYECCION DE PROMOCIONES DE LOS EVENTOS"
         HEIGHT             = 24.81
         WIDTH              = 140.43
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
/* BROWSE-TAB BROWSE-2 FILL-IN-Mensaje F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.t-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.t-report.Campo-C[1]
"t-report.Campo-C[1]" "División" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-report.Campo-C[2]
"t-report.Campo-C[2]" "Lista Precios" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.t-report.Campo-D[1]
"t-report.Campo-D[1]" "Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.t-report.Campo-C[3]
"t-report.Campo-C[3]" "Doc" "X(3)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-report.Campo-C[4]
"t-report.Campo-C[4]" "Número" "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.t-report.Campo-C[5]
"t-report.Campo-C[5]" "Cliente" "X(11)" "character" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.t-report.Campo-C[6]
"t-report.Campo-C[6]" "Nombre" "X(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.t-report.Campo-C[7]
"t-report.Campo-C[7]" "Artículo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.t-report.Campo-C[8]
"t-report.Campo-C[8]" "Descripción" "X(40)" "character" ? ? ? ? ? ? no ? no no "33" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.t-report.Campo-C[9]
"t-report.Campo-C[9]" "Unidad" "X(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.t-report.Campo-F[1]
"t-report.Campo-F[1]" "Cantidad" "->>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* PROYECCION DE PROMOCIONES DE LOS EVENTOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PROYECCION DE PROMOCIONES DE LOS EVENTOS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 5 */
DO:
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Filtrar W-Win
ON CHOOSE OF BUTTON-Filtrar IN FRAME F-Main /* APLICAR FILTROS */
DO:
  ASSIGN
      COMBO-BOX-CodDiv COMBO-BOX-Lista FILL-IN-FchPed-1 FILL-IN-FchPed-2.
  RUN Carga-Temporal.
  {&OPEN-QUERY-BROWSE-2}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE t-report.

DEF VAR pMensaje AS CHAR NO-UNDO.
SESSION:SET-WAIT-STATE('GENERAL').
FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
    AND Faccpedi.coddiv = COMBO-BOX-CodDiv
    AND Faccpedi.Libre_c01 = COMBO-BOX-Lista
    AND Faccpedi.fchped >= FILL-IN-FchPed-1
    AND Faccpedi.fchped <= FILL-IN-FchPed-2
    AND Faccpedi.flgest <> "A":
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
        "PROCESANDO: " + Faccpedi.coddoc + ' ' + Faccpedi.nroped.
    /* Por cada COT calculamos su Promoción Proyectada */
    EMPTY TEMP-TABLE ITEM.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.Libre_c05 <> "OF":
        CREATE ITEM.
        BUFFER-COPY Facdpedi TO ITEM.
    END.
    RUN vta2/promocion-generalv3 (Faccpedi.Libre_c01,   /* División Lista Precio */
                                  Faccpedi.Coddoc,
                                  Faccpedi.TpoPed,
                                  Faccpedi.CodCli,
                                  Faccpedi.CodAlm,
                                  Faccpedi.FmaPgo,
                                  Faccpedi.CodMon,
                                  Faccpedi.Libre_d01,
                                  Faccpedi.PorIgv,
                                  INPUT-OUTPUT TABLE ITEM,
                                  OUTPUT pMensaje,
                                  Faccpedi.FchPed,
                                  NO).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        /* Línea con el error */
        CREATE t-report.
        ASSIGN
            t-report.Campo-C[1] = Faccpedi.CodDiv
            t-report.Campo-C[2] = Faccpedi.Libre_c01
            t-report.Campo-C[3] = Faccpedi.CodDoc
            t-report.Campo-C[4] = Faccpedi.NroPed
            t-report.Campo-C[5] = Faccpedi.CodCli
            t-report.Campo-C[6] = Faccpedi.NomCli
            t-report.Campo-C[7] = ""
            t-report.Campo-C[8] = pMensaje
            t-report.Campo-C[9] = ""
            t-report.Campo-F[1] = 0
            t-report.Campo-D[1] = Faccpedi.FchPed.
    END.
    ELSE DO:
        /* Grabamos solo las promociones */
        FOR EACH ITEM NO-LOCK WHERE ITEM.Libre_c05 = "OF", 
            FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
            AND Almmmatg.codmat = ITEM.codmat:
            CREATE t-report.
            ASSIGN
                t-report.Campo-C[1] = Faccpedi.CodDiv
                t-report.Campo-C[2] = Faccpedi.Libre_c01
                t-report.Campo-C[3] = Faccpedi.CodDoc
                t-report.Campo-C[4] = Faccpedi.NroPed
                t-report.Campo-C[5] = Faccpedi.CodCli
                t-report.Campo-C[6] = Faccpedi.NomCli
                t-report.Campo-C[7] = ITEM.CodMat
                t-report.Campo-C[8] = Almmmatg.DesMat
                t-report.Campo-C[9] = ITEM.UndVta
                t-report.Campo-F[1] = ITEM.CanPed
                t-report.Campo-D[1] = Faccpedi.FchPed.
            IF TRUE <> (t-report.Campo-C[9] > '') THEN 
                ASSIGN 
                t-report.Campo-C[9] = Almmmatg.UndBas.
        END.
    END.
END.
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
SESSION:SET-WAIT-STATE('').
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
  DISPLAY COMBO-BOX-CodDiv COMBO-BOX-Lista FILL-IN-FchPed-1 FILL-IN-FchPed-2 
          FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-CodDiv BUTTON-5 BUTTON-Filtrar COMBO-BOX-Lista 
         FILL-IN-FchPed-1 FILL-IN-FchPed-2 BROWSE-2 
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
DEF VAR c-xls-file AS CHAR INIT 'PromocionProyectada' NO-UNDO.
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

FOR EACH t-report NO-LOCK:
    CREATE Detalle.
    ASSIGN
        Detalle.CodDiv = t-report.Campo-C[1]
        Detalle.ListaPrecio = t-report.Campo-C[2]
        Detalle.CodPed = t-report.Campo-C[3]
        Detalle.NroPed = t-report.Campo-C[4]
        Detalle.CodCli = t-report.Campo-C[5]
        Detalle.NomCli = t-report.Campo-C[6]
        Detalle.CodMat = t-report.Campo-C[7]
        Detalle.DesMat = t-report.Campo-C[8]
        Detalle.UndVta = t-report.Campo-C[9]
        Detalle.CanDes = t-report.Campo-F[1]
        Detalle.FchPed = t-report.Campo-D[1]
        .
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
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-CodDiv:DELIMITER = "|".
      COMBO-BOX-CodDiv:DELETE(1).
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia
          AND LOOKUP(GN-DIVI.Campo-Char[1], 'D,A') > 0
          AND GN-DIVI.Campo-Log[1] = NO
          AND GN-DIVI.CanalVenta = "FER"
          BREAK BY gn-divi.codcia BY gn-divi.coddiv:
          IF FIRST-OF(gn-divi.codcia) THEN COMBO-BOX-CodDiv = GN-DIVI.CodDiv.
          COMBO-BOX-CodDiv:ADD-LAST(GN-DIVI.CodDiv + ' ' + GN-DIVI.DesDiv, GN-DIVI.CodDiv).
      END.
      COMBO-BOX-Lista:DELIMITER = "|".
      COMBO-BOX-Lista:DELETE(1).
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia
          AND LOOKUP(GN-DIVI.Campo-Char[1], 'L,A') > 0
          AND GN-DIVI.Campo-Log[1] = NO
          AND GN-DIVI.CanalVenta = "FER"
          BREAK BY gn-divi.codcia BY gn-divi.coddiv:
          IF FIRST-OF(gn-divi.codcia) THEN COMBO-BOX-Lista = GN-DIVI.CodDiv.
          COMBO-BOX-Lista:ADD-LAST(GN-DIVI.CodDiv + ' ' + GN-DIVI.DesDiv, GN-DIVI.CodDiv).
      END.
      ASSIGN
          FILL-IN-FchPed-1 = ADD-INTERVAL(TODAY , -1, 'month')
          FILL-IN-FchPed-2 = TODAY.
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "t-report"}

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

