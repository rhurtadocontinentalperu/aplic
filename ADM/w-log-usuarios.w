&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE topcionesmenu NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE tsessiones NO-UNDO LIKE w-report.



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
DEFINE SHARED VAR s-codcia AS INT.

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
&Scoped-define INTERNAL-TABLES tsessiones topcionesmenu

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tsessiones.Campo-D[1] ~
tsessiones.Campo-C[1] tsessiones.Campo-D[2] tsessiones.Campo-C[2] ~
tsessiones.Campo-C[3] tsessiones.Campo-C[5] tsessiones.Campo-C[4] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tsessiones NO-LOCK ~
    BY tsessiones.Campo-D[1] DESCENDING ~
       BY tsessiones.Campo-C[1] DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tsessiones NO-LOCK ~
    BY tsessiones.Campo-D[1] DESCENDING ~
       BY tsessiones.Campo-C[1] DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tsessiones
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tsessiones


/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 topcionesmenu.Campo-C[1] ~
topcionesmenu.Campo-C[2] topcionesmenu.Campo-D[1] topcionesmenu.Campo-C[3] ~
topcionesmenu.Campo-C[4] topcionesmenu.Campo-C[5] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH topcionesmenu NO-LOCK ~
    BY topcionesmenu.Campo-D[1] DESCENDING ~
       BY topcionesmenu.Campo-C[3] DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH topcionesmenu NO-LOCK ~
    BY topcionesmenu.Campo-D[1] DESCENDING ~
       BY topcionesmenu.Campo-C[3] DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 topcionesmenu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 topcionesmenu


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-fecha FILL-IN-usuario BUTTON-1 ~
BROWSE-2 BROWSE-3 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-fecha FILL-IN-usuario ~
FILL-IN-nombre 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Consultar" 
     SIZE 13 BY .96.

DEFINE VARIABLE FILL-IN-fecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de log" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-nombre AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre del usario :" 
      VIEW-AS TEXT 
     SIZE 68 BY .62
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-usuario AS CHARACTER FORMAT "X(25)":U 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tsessiones SCROLLING.

DEFINE QUERY BROWSE-3 FOR 
      topcionesmenu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tsessiones.Campo-D[1] COLUMN-LABEL "Ingreso!Fecha" FORMAT "99/99/9999":U
      tsessiones.Campo-C[1] COLUMN-LABEL "Ingreso!Hora" FORMAT "X(12)":U
      tsessiones.Campo-D[2] COLUMN-LABEL "Termino!Dia" FORMAT "99/99/9999":U
      tsessiones.Campo-C[2] COLUMN-LABEL "Termino!Hora" FORMAT "X(12)":U
      tsessiones.Campo-C[3] COLUMN-LABEL "Nombre!de la PC" FORMAT "X(30)":U
            WIDTH 14.86
      tsessiones.Campo-C[5] COLUMN-LABEL "Usuario!de la PC" FORMAT "X(30)":U
            WIDTH 15.43
      tsessiones.Campo-C[4] COLUMN-LABEL "Terminal!Server" FORMAT "X(30)":U
            WIDTH 14.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 94 BY 6.54
         FONT 4
         TITLE "INGRESOS AL SISTEMA" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      topcionesmenu.Campo-C[1] COLUMN-LABEL "Cod!Modulo" FORMAT "X(8)":U
      topcionesmenu.Campo-C[2] COLUMN-LABEL "Nombre del modulo" FORMAT "X(50)":U
            WIDTH 27.72
      topcionesmenu.Campo-D[1] COLUMN-LABEL "Fecha" FORMAT "99/99/9999":U
      topcionesmenu.Campo-C[3] COLUMN-LABEL "Hora" FORMAT "X(8)":U
            WIDTH 8.72
      topcionesmenu.Campo-C[4] COLUMN-LABEL "Opcion del menu" FORMAT "X(60)":U
            WIDTH 45
      topcionesmenu.Campo-C[5] COLUMN-LABEL "Programa" FORMAT "X(60)":U
            WIDTH 4.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 109 BY 14.23
         FONT 4
         TITLE "OPCIONES DEL MENU USADOS" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-fecha AT ROW 1.77 COL 16 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-usuario AT ROW 1.77 COL 40 COLON-ALIGNED WIDGET-ID 4
     BUTTON-1 AT ROW 1.77 COL 60 WIDGET-ID 6
     BROWSE-2 AT ROW 3.88 COL 3 WIDGET-ID 200
     BROWSE-3 AT ROW 11 COL 3 WIDGET-ID 300
     FILL-IN-nombre AT ROW 2.92 COL 41 COLON-ALIGNED WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 114.29 BY 24.65
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: topcionesmenu T "?" NO-UNDO INTEGRAL w-report
      TABLE: tsessiones T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Log de usuarios"
         HEIGHT             = 24.65
         WIDTH              = 114.29
         MAX-HEIGHT         = 24.65
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 24.65
         VIRTUAL-WIDTH      = 114.29
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
/* BROWSE-TAB BROWSE-2 BUTTON-1 F-Main */
/* BROWSE-TAB BROWSE-3 BROWSE-2 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-nombre IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tsessiones"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.tsessiones.Campo-D[1]|no,Temp-Tables.tsessiones.Campo-C[1]|no"
     _FldNameList[1]   > Temp-Tables.tsessiones.Campo-D[1]
"Campo-D[1]" "Ingreso!Fecha" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tsessiones.Campo-C[1]
"Campo-C[1]" "Ingreso!Hora" "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tsessiones.Campo-D[2]
"Campo-D[2]" "Termino!Dia" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tsessiones.Campo-C[2]
"Campo-C[2]" "Termino!Hora" "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tsessiones.Campo-C[3]
"Campo-C[3]" "Nombre!de la PC" "X(30)" "character" ? ? ? ? ? ? no ? no no "14.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tsessiones.Campo-C[5]
"Campo-C[5]" "Usuario!de la PC" "X(30)" "character" ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tsessiones.Campo-C[4]
"Campo-C[4]" "Terminal!Server" "X(30)" "character" ? ? ? ? ? ? no ? no no "14.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.topcionesmenu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.topcionesmenu.Campo-D[1]|no,Temp-Tables.topcionesmenu.Campo-C[3]|no"
     _FldNameList[1]   > Temp-Tables.topcionesmenu.Campo-C[1]
"Campo-C[1]" "Cod!Modulo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.topcionesmenu.Campo-C[2]
"Campo-C[2]" "Nombre del modulo" "X(50)" "character" ? ? ? ? ? ? no ? no no "27.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.topcionesmenu.Campo-D[1]
"Campo-D[1]" "Fecha" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.topcionesmenu.Campo-C[3]
"Campo-C[3]" "Hora" ? "character" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.topcionesmenu.Campo-C[4]
"Campo-C[4]" "Opcion del menu" "X(60)" "character" ? ? ? ? ? ? no ? no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.topcionesmenu.Campo-C[5]
"Campo-C[5]" "Programa" "X(60)" "character" ? ? ? ? ? ? no ? no no "4.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Log de usuarios */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Log de usuarios */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Consultar */
DO:
    ASSIGN fill-in-fecha fill-in-usuario.

    IF TRUE > (fill-in-usuario > "") THEN RETURN NO-APPLY.

    RUN carga-info.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-info W-Win 
PROCEDURE carga-info :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE("GENERAL").

EMPTY TEMP-TABLE tsessiones.
EMPTY TEMP-TABLE topcionesmenu.

FIND FIRST _user WHERE _user._userid = FILL-in-usuario NO-LOCK NO-ERROR.
fill-in-nombre:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
IF AVAILABLE _user THEN fill-in-nombre:SCREEN-VALUE IN FRAME {&FRAME-NAME} = _user._user-name.

FOR EACH admctrlUsers WHERE admctrlUsers.userdb = fill-in-usuario AND
                        admctrlUsers.fechinicio = fill-in-fecha NO-LOCK:
    CREATE tsessiones.
        ASSIGN tsessiones.campo-d[1] = admctrlUsers.fechinicio
                tsessiones.campo-c[1] = admctrlUsers.horainicio
                tsessiones.campo-d[2] = admctrlUsers.fechtermino
                tsessiones.campo-c[2] = admctrlUsers.horatermino
                tsessiones.campo-c[3] = admctrlUsers.PCremoto
                tsessiones.campo-c[4] = admctrlUsers.pccliente
                tsessiones.campo-c[5] = admctrlUsers.userCliente
            .
END.

/*
FOR EACH logtabla WHERE logtabla.codcia = s-codcia AND
                            logtabla.evento = "RUN-PROGRAM" AND
                            logtabla.dia = fill-in-fecha AND
                            logtabla.usuario = fill-in-usuario NO-LOCK:

    FIND FIRST pf-g002 WHERE pf-g002.aplic-id = logtabla.tabla AND 
                            pf-g002.programa = logtabla.valorllave NO-LOCK NO-ERROR.

    FIND FIRST pf-g003 WHERE pf-g003.aplic-id = logtabla.tabla NO-LOCK NO-ERROR.

    CREATE topcionesmenu.
        ASSIGN topcionesmenu.campo-c[1] = logtabla.tabla
                topcionesmenu.campo-c[1] = IF (AVAILABLE pf-g003) THEN pf-g003.detalle ELSE ""
                topcionesmenu.campo-d[1] = logtabla.dia
                topcionesmenu.campo-c[2] = logtabla.hora
                topcionesmenu.campo-c[3] = IF (AVAILABLE pf-g002) THEN pf-g002.etiqueta ELSE ""
                topcionesmenu.campo-c[4] = logtabla.valorllave
            .
END.
*/

FOR EACH pf-g003 NO-LOCK:
    FOR EACH logtabla WHERE logtabla.codcia = s-codcia AND
                                logtabla.tabla = pf-g003.aplic-id AND
                                logtabla.dia = fill-in-fecha AND
                                logtabla.usuario = fill-in-usuario NO-LOCK:

        FIND FIRST pf-g002 WHERE pf-g002.aplic-id = logtabla.tabla AND 
                                pf-g002.programa = logtabla.valorllave NO-LOCK NO-ERROR.

        CREATE topcionesmenu.
            ASSIGN topcionesmenu.campo-c[1] = logtabla.tabla
                    topcionesmenu.campo-c[2] = IF (AVAILABLE pf-g003) THEN pf-g003.detalle ELSE ""
                    topcionesmenu.campo-d[1] = logtabla.dia
                    topcionesmenu.campo-c[3] = logtabla.hora
                    topcionesmenu.campo-c[4] = IF (AVAILABLE pf-g002) THEN pf-g002.etiqueta ELSE ""
                    topcionesmenu.campo-c[5] = logtabla.valorllave
                .
    END.
END.
/*
FOR EACH logtabla WHERE logtabla.codcia = s-codcia AND
                            logtabla.evento = "RUN-PROGRAM" AND
                            logtabla.dia = fill-in-fecha AND
                            logtabla.usuario = fill-in-usuario NO-LOCK:

    FIND FIRST pf-g002 WHERE pf-g002.aplic-id = logtabla.tabla AND 
                            pf-g002.programa = logtabla.valorllave NO-LOCK NO-ERROR.

    FIND FIRST pf-g003 WHERE pf-g003.aplic-id = logtabla.tabla NO-LOCK NO-ERROR.

END.
*/

{&open-query-browse-2}
{&open-query-browse-3}

SESSION:SET-WAIT-STATE("").

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
  DISPLAY FILL-IN-fecha FILL-IN-usuario FILL-IN-nombre 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-fecha FILL-IN-usuario BUTTON-1 BROWSE-2 BROWSE-3 
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  fill-in-fecha:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").

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
  {src/adm/template/snd-list.i "topcionesmenu"}
  {src/adm/template/snd-list.i "tsessiones"}

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

