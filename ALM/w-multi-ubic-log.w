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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-codalm AS CHAR.

&SCOPED-DEFINE Condicion ( logubimat.CodCia = s-codcia AND ~
( TRUE <> (FILL-IN_CodMat > '') OR logubimat.CodMat = FILL-IN_CodMat ) AND ~
( TRUE <> (COMBO-BOX_CodAlm > '') OR logubimat.CodAlm = COMBO-BOX_CodAlm ) )

DEF TEMP-TABLE Reporte
    FIELD CodAlm LIKE logubimat.CodAlm LABEL 'Almacén'
    FIELD CodMat LIKE logubimat.CodMat LABEL 'Artículo'
    FIELD CodUbiIni LIKE logubimat.CodUbiIni LABEL 'Ubicación Inicial'
    FIELD CodZonaIni LIKE logubimat.CodZonaIni LABEL 'Zona Inicial'
    FIELD CodUbiFin LIKE logubimat.CodUbiFin LABEL 'Ubicación Final'
    FIELD CodZonaFin LIKE logubimat.CodZonaFin LABEL 'Zona Final'
    FIELD Evento LIKE logubimat.Evento LABEL 'Evento'
    FIELD Fecha LIKE logubimat.Fecha 
    FIELD Hora LIKE logubimat.Hora 
    FIELD Usuario LIKE logubimat.Usuario
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
&Scoped-define INTERNAL-TABLES logubimat

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 logubimat.CodAlm logubimat.CodMat ~
logubimat.CodUbiIni logubimat.CodZonaIni logubimat.CodUbiFin ~
logubimat.CodZonaFin logubimat.Evento logubimat.Fecha logubimat.Hora ~
logubimat.Usuario 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH logubimat ~
      WHERE {&Condicion} NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH logubimat ~
      WHERE {&Condicion} NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 logubimat
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 logubimat


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON_Filtrar COMBO-BOX_CodAlm ~
FILL-IN_CodMat BUTTON_Limpiar BROWSE-2 BUTTON_Texto 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX_CodAlm FILL-IN_CodMat ~
FILL-IN_DesMat 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON_Filtrar 
     LABEL "APLICAR FILTRO" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON_Limpiar 
     LABEL "LIMPIAR FILTROS" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON_Texto 
     LABEL "EXPORTAR A TEXTO" 
     SIZE 18 BY 1.12.

DEFINE VARIABLE COMBO-BOX_CodAlm AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Almacén" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodMat AS CHARACTER FORMAT "X(15)":U 
     LABEL "Artículo" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_DesMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      logubimat SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      logubimat.CodAlm COLUMN-LABEL "Almacén" FORMAT "x(8)":U
      logubimat.CodMat COLUMN-LABEL "Artículo" FORMAT "x(8)":U
      logubimat.CodUbiIni COLUMN-LABEL "Ubicación!Inicial" FORMAT "x(15)":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14 LABEL-FGCOLOR 0 LABEL-BGCOLOR 14
      logubimat.CodZonaIni COLUMN-LABEL "Zona!Inicial" FORMAT "x(8)":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14 LABEL-FGCOLOR 0 LABEL-BGCOLOR 14
      logubimat.CodUbiFin COLUMN-LABEL "Ubicación!Final" FORMAT "x(15)":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10 LABEL-FGCOLOR 0 LABEL-BGCOLOR 10
      logubimat.CodZonaFin COLUMN-LABEL "Zona!Final" FORMAT "x(8)":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10 LABEL-FGCOLOR 0 LABEL-BGCOLOR 10
      logubimat.Evento FORMAT "x(12)":U
      logubimat.Fecha FORMAT "99/99/9999":U
      logubimat.Hora FORMAT "x(8)":U WIDTH 9.86
      logubimat.Usuario FORMAT "x(15)":U WIDTH 10.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 99 BY 14.27
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON_Filtrar AT ROW 1 COL 83 WIDGET-ID 4
     COMBO-BOX_CodAlm AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 2
     FILL-IN_CodMat AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 6
     FILL-IN_DesMat AT ROW 2.08 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     BUTTON_Limpiar AT ROW 2.08 COL 83 WIDGET-ID 10
     BROWSE-2 AT ROW 3.42 COL 2 WIDGET-ID 200
     BUTTON_Texto AT ROW 17.69 COL 2 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 109 BY 17.92
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
         TITLE              = "CONSULTA DEL LOG DE MULTIUBICACIONES"
         HEIGHT             = 17.92
         WIDTH              = 109
         MAX-HEIGHT         = 17.92
         MAX-WIDTH          = 109
         VIRTUAL-HEIGHT     = 17.92
         VIRTUAL-WIDTH      = 109
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
/* BROWSE-TAB BROWSE-2 BUTTON_Limpiar F-Main */
/* SETTINGS FOR FILL-IN FILL-IN_DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.logubimat"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > INTEGRAL.logubimat.CodAlm
"logubimat.CodAlm" "Almacén" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.logubimat.CodMat
"logubimat.CodMat" "Artículo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.logubimat.CodUbiIni
"logubimat.CodUbiIni" "Ubicación!Inicial" ? "character" 14 0 ? 14 0 ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.logubimat.CodZonaIni
"logubimat.CodZonaIni" "Zona!Inicial" ? "character" 14 0 ? 14 0 ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.logubimat.CodUbiFin
"logubimat.CodUbiFin" "Ubicación!Final" ? "character" 10 0 ? 10 0 ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.logubimat.CodZonaFin
"logubimat.CodZonaFin" "Zona!Final" ? "character" 10 0 ? 10 0 ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = INTEGRAL.logubimat.Evento
     _FldNameList[8]   = INTEGRAL.logubimat.Fecha
     _FldNameList[9]   > INTEGRAL.logubimat.Hora
"logubimat.Hora" ? ? "character" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.logubimat.Usuario
"logubimat.Usuario" ? ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONSULTA DEL LOG DE MULTIUBICACIONES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONSULTA DEL LOG DE MULTIUBICACIONES */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Filtrar W-Win
ON CHOOSE OF BUTTON_Filtrar IN FRAME F-Main /* APLICAR FILTRO */
DO:
  ASSIGN COMBO-BOX_CodAlm FILL-IN_CodMat.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Limpiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Limpiar W-Win
ON CHOOSE OF BUTTON_Limpiar IN FRAME F-Main /* LIMPIAR FILTROS */
DO:
    ASSIGN
        COMBO-BOX_CodAlm = s-CodAlm
        FILL-IN_CodMat = ''
        FILL-IN_DesMat = ''.
    DISPLAY  COMBO-BOX_CodAlm FILL-IN_CodMat FILL-IN_DesMat
        WITH FRAME {&FRAME-NAME}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Texto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Texto W-Win
ON CHOOSE OF BUTTON_Texto IN FRAME F-Main /* EXPORTAR A TEXTO */
DO:
    /* Pantalla de Impresión */
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.

    RUN lib/tt-file-to-text-01 (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE('GENERAL').
    EMPTY TEMP-TABLE Reporte.
    FOR EACH logubimat NO-LOCK WHERE {&Condicion}:
        CREATE Reporte.
        BUFFER-COPY logubimat TO Reporte.
    END.
    SESSION:SET-WAIT-STATE('').
    FIND FIRST Reporte NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Reporte THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    cArchivo = LC(pArchivo).
    SESSION:SET-WAIT-STATE('GENERAL').
    IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
    RUN lib/tt-filev2 (TEMP-TABLE Reporte:HANDLE, cArchivo, pOptions).
    SESSION:DATE-FORMAT = "dmy".
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodMat W-Win
ON LEAVE OF FILL-IN_CodMat IN FRAME F-Main /* Artículo */
DO:
    FILL-IN_DesMat:SCREEN-VALUE = ''.
    IF SELF:SCREEN-VALUE = "" THEN RETURN.

    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).
    IF pCodMat = '' THEN DO:
        ASSIGN SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    SELF:SCREEN-VALUE = pCodMat.
    FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE
        NO-LOCK.
    FILL-IN_DesMat:SCREEN-VALUE = Almmmatg.desmat.
  
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
  DISPLAY COMBO-BOX_CodAlm FILL-IN_CodMat FILL-IN_DesMat 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON_Filtrar COMBO-BOX_CodAlm FILL-IN_CodMat BUTTON_Limpiar BROWSE-2 
         BUTTON_Texto 
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
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX_CodAlm:DELIMITER = '|'.
      FOR EACH almacen NO-LOCK WHERE almacen.codcia = 1
          AND almacen.campo-c[9] <> "I":
          COMBO-BOX_CodAlm:ADD-LAST(Almacen.CodAlm + ' - '  + Almacen.Descripcion,Almacen.CodAlm ).
      END.
      COMBO-BOX_CodAlm = s-CodAlm.
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
  {src/adm/template/snd-list.i "logubimat"}

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

