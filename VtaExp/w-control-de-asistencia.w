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
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

&SCOPED-DEFINE CONDICION ( ExpAsist.CodCia = S-CODCIA  AND ~
             ExpAsist.CodDiv = s-CodDiv AND ~
             ExpAsist.Estado[1] = 'C' )


DEF VAR pMensaje AS CHAR NO-UNDO.


{src/bin/_prns.i}

DEF STREAM REPORTE.

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
&Scoped-define INTERNAL-TABLES ExpAsist gn-clie

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 ExpAsist.CodCli gn-clie.Ruc ~
gn-clie.DNI gn-clie.NomCli ExpAsist.FecPro ExpAsist.HoraPro ~
ExpAsist.FecAsi[1] ExpAsist.HoraAsi[1] ExpAsist.FecAsi[2] ~
ExpAsist.HoraAsi[2] ExpAsist.FecAsi[3] ExpAsist.HoraAsi[3] ~
ExpAsist.FecAsi[4] ExpAsist.HoraAsi[4] ExpAsist.FecAsi[5] ~
ExpAsist.HoraAsi[5] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH ExpAsist ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST gn-clie WHERE gn-clie.CodCli = ExpAsist.CodCli ~
      AND gn-clie.CodCia = cl-codcia NO-LOCK ~
    BY gn-clie.NomCli INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH ExpAsist ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST gn-clie WHERE gn-clie.CodCli = ExpAsist.CodCli ~
      AND gn-clie.CodCia = cl-codcia NO-LOCK ~
    BY gn-clie.NomCli INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 ExpAsist gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 ExpAsist
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 gn-clie


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-CodCli BUTTON-1 BUTTON-2 ~
FILL-IN_Descrip BUTTON_Down BUTTON_Up BUTTON_Exit BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodCli FILL-IN_Descrip 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/reload.ico":U
     LABEL "Button 1" 
     SIZE 7 BY 1.62 TOOLTIP "Actualizar".

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/plus.ico":U
     LABEL "" 
     SIZE 7 BY 1.62 TOOLTIP "Agrega Cliente Fuera de Lista".

DEFINE BUTTON BUTTON_Down 
     IMAGE-UP FILE "img/caret-down-regular-24.bmp":U
     LABEL "Button 2" 
     SIZE 4 BY 1.08 TOOLTIP "Siguiente"
     BGCOLOR 15 FGCOLOR 0 .

DEFINE BUTTON BUTTON_Exit 
     IMAGE-UP FILE "img/exit-regular-24.bmp":U
     LABEL "Button 4" 
     SIZE 4 BY 1.08 TOOLTIP "Cerrar búsqueda".

DEFINE BUTTON BUTTON_Up 
     IMAGE-UP FILE "img/caret-up-regular-24.bmp":U
     LABEL "Button 3" 
     SIZE 4 BY 1.08 TOOLTIP "Previo"
     BGCOLOR 15 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY 1.08
     FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN_Descrip AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      ExpAsist, 
      gn-clie
    FIELDS(gn-clie.Ruc
      gn-clie.DNI
      gn-clie.NomCli) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      ExpAsist.CodCli COLUMN-LABEL "Código" FORMAT "X(15)":U
      gn-clie.Ruc COLUMN-LABEL "RUC" FORMAT "x(11)":U WIDTH 11.86
      gn-clie.DNI FORMAT "x(10)":U WIDTH 10.43
      gn-clie.NomCli FORMAT "x(80)":U WIDTH 56
      ExpAsist.FecPro COLUMN-LABEL "Fecha!Programada" FORMAT "99/99/9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      ExpAsist.HoraPro COLUMN-LABEL "Hora!Programada" FORMAT "x(5)":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      ExpAsist.FecAsi[1] COLUMN-LABEL "1ra.!Asistencia" FORMAT "99/99/9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10
      ExpAsist.HoraAsi[1] COLUMN-LABEL "Hora" FORMAT "x(5)":U WIDTH 4.72
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10
      ExpAsist.FecAsi[2] COLUMN-LABEL "2da.!Asistencia" FORMAT "99/99/9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      ExpAsist.HoraAsi[2] COLUMN-LABEL "Hora" FORMAT "x(5)":U WIDTH 4.57
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      ExpAsist.FecAsi[3] COLUMN-LABEL "3ra.!Asistencia" FORMAT "99/99/9999":U
            COLUMN-FGCOLOR 14 COLUMN-BGCOLOR 12
      ExpAsist.HoraAsi[3] COLUMN-LABEL "Hora" FORMAT "x(5)":U WIDTH 4.57
            COLUMN-FGCOLOR 14 COLUMN-BGCOLOR 12
      ExpAsist.FecAsi[4] COLUMN-LABEL "4ta.!Asistencia" FORMAT "99/99/9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 8
      ExpAsist.HoraAsi[4] COLUMN-LABEL "Hora" FORMAT "x(5)":U WIDTH 4.57
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 8
      ExpAsist.FecAsi[5] COLUMN-LABEL "5ta.!Asistencia" FORMAT "99/99/9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 8
      ExpAsist.HoraAsi[5] COLUMN-LABEL "Hora" FORMAT "x(5)":U WIDTH 3.86
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 8
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 181 BY 21.54
         FONT 4
         TITLE "CONTROL DE ASISTENCIAS" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodCli AT ROW 1.54 COL 49 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     BUTTON-1 AT ROW 1.54 COL 2 WIDGET-ID 8
     BUTTON-2 AT ROW 1.54 COL 9 WIDGET-ID 10
     FILL-IN_Descrip AT ROW 1.54 COL 137 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     BUTTON_Down AT ROW 1.54 COL 161 WIDGET-ID 14
     BUTTON_Up AT ROW 1.54 COL 165 WIDGET-ID 16
     BUTTON_Exit AT ROW 1.54 COL 169 WIDGET-ID 20
     BROWSE-2 AT ROW 3.15 COL 2 WIDGET-ID 200
     "Presione F8 para abrir la ventana de búsqueda" VIEW-AS TEXT
          SIZE 39 BY .5 AT ROW 24.96 COL 51 WIDGET-ID 22
          FONT 6
     "Presione F10 para REIMPRIMIR ETIQUETAS" VIEW-AS TEXT
          SIZE 38 BY .5 AT ROW 24.96 COL 3 WIDGET-ID 12
          FONT 6
     "Escanee el código de barra:" VIEW-AS TEXT
          SIZE 33 BY 1.08 AT ROW 1.54 COL 18 WIDGET-ID 6
          FONT 9
     "Presione Crtl + D para eliminar el registro" VIEW-AS TEXT
          SIZE 39 BY .5 AT ROW 24.96 COL 101 WIDGET-ID 24
          FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 185 BY 24.85
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
         TITLE              = "CONTROL DE ASISTENCIA"
         HEIGHT             = 24.85
         WIDTH              = 185
         MAX-HEIGHT         = 26.15
         MAX-WIDTH          = 191.29
         VIRTUAL-HEIGHT     = 26.15
         VIRTUAL-WIDTH      = 191.29
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
/* BROWSE-TAB BROWSE-2 BUTTON_Exit F-Main */
ASSIGN 
       BROWSE-2:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 8
       BROWSE-2:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.ExpAsist,INTEGRAL.gn-clie WHERE INTEGRAL.ExpAsist ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED"
     _OrdList          = "INTEGRAL.gn-clie.NomCli|yes"
     _Where[1]         = "{&Condicion}"
     _JoinCode[2]      = "gn-clie.CodCli = ExpAsist.CodCli"
     _Where[2]         = "gn-clie.CodCia = cl-codcia"
     _FldNameList[1]   > INTEGRAL.ExpAsist.CodCli
"ExpAsist.CodCli" "Código" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.gn-clie.Ruc
"gn-clie.Ruc" "RUC" ? "character" ? ? ? ? ? ? no ? no no "11.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.gn-clie.DNI
"gn-clie.DNI" ? ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.gn-clie.NomCli
"gn-clie.NomCli" ? "x(80)" "character" ? ? ? ? ? ? no ? no no "56" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.ExpAsist.FecPro
"ExpAsist.FecPro" "Fecha!Programada" ? "date" 11 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.ExpAsist.HoraPro
"ExpAsist.HoraPro" "Hora!Programada" "x(5)" "character" 11 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.ExpAsist.FecAsi[1]
"ExpAsist.FecAsi[1]" "1ra.!Asistencia" ? "date" 10 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.ExpAsist.HoraAsi[1]
"ExpAsist.HoraAsi[1]" "Hora" "x(5)" "character" 10 0 ? ? ? ? no ? no no "4.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.ExpAsist.FecAsi[2]
"ExpAsist.FecAsi[2]" "2da.!Asistencia" ? "date" 14 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.ExpAsist.HoraAsi[2]
"ExpAsist.HoraAsi[2]" "Hora" "x(5)" "character" 14 0 ? ? ? ? no ? no no "4.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.ExpAsist.FecAsi[3]
"ExpAsist.FecAsi[3]" "3ra.!Asistencia" ? "date" 12 14 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.ExpAsist.HoraAsi[3]
"ExpAsist.HoraAsi[3]" "Hora" "x(5)" "character" 12 14 ? ? ? ? no ? no no "4.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > INTEGRAL.ExpAsist.FecAsi[4]
"ExpAsist.FecAsi[4]" "4ta.!Asistencia" ? "date" 8 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > INTEGRAL.ExpAsist.HoraAsi[4]
"ExpAsist.HoraAsi[4]" "Hora" "x(5)" "character" 8 0 ? ? ? ? no ? no no "4.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > INTEGRAL.ExpAsist.FecAsi[5]
"ExpAsist.FecAsi[5]" "5ta.!Asistencia" ? "date" 8 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > INTEGRAL.ExpAsist.HoraAsi[5]
"ExpAsist.HoraAsi[5]" "Hora" "x(5)" "character" 8 0 ? ? ? ? no ? no no "3.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONTROL DE ASISTENCIA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONTROL DE ASISTENCIA */
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
ON CTRL-D OF BROWSE-2 IN FRAME F-Main /* CONTROL DE ASISTENCIAS */
DO:
    IF NOT AVAILABLE ExpAsist THEN RETURN.

    MESSAGE 'Esta seguro de eliminar registro'
        VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO
        UPDATE lchoice AS LOGICAL.
    IF lchoice = NO THEN RETURN.

    DEF BUFFER b-ExpAsist FOR ExpAsist.
    FIND FIRST b-ExpAsist WHERE ROWID(b-ExpAsist) = ROWID(expasist) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF AVAIL b-ExpAsist AND b-ExpAsist.estado[2] = 'N' THEN DO:  
        ASSIGN 
            b-ExpAsist.Estado[1] = 'A'
            b-ExpAsist.Estado[5] = STRING(TODAY)
            b-ExpAsist.Hora      = STRING(TIME,"HH:MM:SS")
            b-ExpAsist.usuario   = s-user-id.
        /**/
        ASSIGN 
            b-ExpAsist.libre_d05 = "ANULADO".  
        /* LOG de control */
        CREATE LogExpAsist.
        ASSIGN
            LogExpAsist.Asistentes  =   ExpAsist.Asistentes  
            LogExpAsist.CodCia      =   ExpAsist.CodCia      
            LogExpAsist.CodCli      =   ExpAsist.CodCli      
            LogExpAsist.CodDiv      =   ExpAsist.CodDiv      
            LogExpAsist.Estado      =   ExpAsist.Estado[1]
            LogExpAsist.Fecha       =   TODAY
            LogExpAsist.FecPro      =   ExpAsist.FecPro      
            LogExpAsist.Hora        =   STRING(TIME,'HH:MM:SS')
            LogExpAsist.HoraPro     =   ExpAsist.HoraPro     
            LogExpAsist.Usuario     =   ExpAsist.Usuario.
        RELEASE LogExpAsist.
    END.
    ELSE DO:
        MESSAGE 'Cliente pertenece a listado' VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN 'adm-error'.
    END.
    IF AVAILABLE(b-ExpAsist) THEN RELEASE b-ExpAsist.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON F10 OF BROWSE-2 IN FRAME F-Main /* CONTROL DE ASISTENCIAS */
DO:
    RUN Imprime-Barras.
    APPLY 'ENTRY':U TO FILL-IN-CodCli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  {&OPEN-QUERY-{&BROWSE-NAME}}
  APPLY 'ENTRY':U TO FILL-IN-CodCli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main
DO:
    DEF VAR pRowid AS ROWID NO-UNDO.

    RUN VtaExp\d-registro-new-asistente-v2 (OUTPUT pRowid).
    IF pRowid <> ? THEN DO:
        {&OPEN-QUERY-{&BROWSE-NAME}}
        REPOSITION {&browse-name} TO ROWID pRowid NO-ERROR.
    END.
    APPLY 'ENTRY':U TO FILL-IN-CodCli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Down
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Down W-Win
ON CHOOSE OF BUTTON_Down IN FRAME F-Main /* Button 2 */
DO:
  ASSIGN FILL-IN_Descrip.
  GET NEXT {&browse-name}.
  DO WHILE AVAILABLE ExpAsist:
      IF INDEX(gn-clie.nomcli,FILL-IN_Descrip) > 0 THEN DO:
          REPOSITION {&browse-name} TO ROWID ROWID(ExpAsist) NO-ERROR.
          LEAVE.
      END.
      GET NEXT {&browse-name}.
  END.
END.


/*
  DEF BUFFER b-almmmatg FOR almmmatg.

  DEF VAR h-Query AS WIDGET-HANDLE.
  CREATE QUERY h-Query.
  h-Query:SET-BUFFERS(BUFFER b-almmmatg:HANDLE).
  h-Query:QUERY-PREPARE("FOR EACH b-almmmatg NO-LOCK BY b-almmmatg.Desmat").
  h-Query:QUERY-OPEN.
  h-Query:REPOSITION-TO-ROWID(ROWID(almmmatg)).
  h-Query:GET-NEXT().
  h-Query:GET-NEXT().
  DO WHILE h-Query:QUERY-OFF-END = NO:
      IF INDEX(b-almmmatg.Desmat, FILL-IN_Descrip) > 0 THEN DO:
          REPOSITION {&browse-name} TO ROWID ROWID(b-almmmatg) NO-ERROR.
          RUN dispatch IN THIS-PROCEDURE ('row-changed':U).
          LEAVE.
      END.
      h-Query:GET-NEXT().
  END.
  h-Query:QUERY-CLOSE().
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Exit W-Win
ON CHOOSE OF BUTTON_Exit IN FRAME F-Main /* Button 4 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      DISABLE BUTTON_Down BUTTON_Exit BUTTON_Up FILL-IN_Descrip .
      HIDE BUTTON_Down BUTTON_Exit BUTTON_Up FILL-IN_Descrip .
      ENABLE BUTTON-1 BUTTON-2 FILL-IN-CodCli.
      APPLY 'ENTRY':U TO FILL-IN-CodCli.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Up
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Up W-Win
ON CHOOSE OF BUTTON_Up IN FRAME F-Main /* Button 3 */
DO:
    ASSIGN FILL-IN_Descrip.
    GET PREV {&browse-name}.
    DO WHILE AVAILABLE ExpAsist:
        IF INDEX(gn-clie.nomcli,FILL-IN_Descrip) > 0 THEN DO:
            REPOSITION {&browse-name} TO ROWID ROWID(ExpAsist) NO-ERROR.
            LEAVE.
        END.
        GET PREV {&browse-name}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli W-Win
ON LEAVE OF FILL-IN-CodCli IN FRAME F-Main
OR RETURN OF FILL-IN-CodCli DO:
    IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
    /* Verificamos en el maestro de clientes */
    FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia AND
        gn-clie.codcli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
        MESSAGE 'Código del Cliente NO registrado en nuestro maestro'
            VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    /* 1ra vuelta */
    /* Veamos si está invitado y si pertenece a un grupo comercial */
    IF NOT CAN-FIND(FIRST ExpAsist WHERE ExpAsist.CodCia = S-CODCIA AND 
                    ExpAsist.CodDiv = s-CodDiv AND
                    ExpAsist.CodCli = SELF:SCREEN-VALUE
                    NO-LOCK)
        THEN DO:
        /* NO está invitado, veamos si pertenece a un grupo y si el principal está invitado */
        FIND FIRST pri_comclientgrp_d WHERE pri_comclientgrp_d.CodCli = SELF:SCREEN-VALUE AND
            CAN-FIND(pri_comclientgrp_h WHERE pri_comclientgrp_h.IdGroup = pri_comclientgrp_d.IdGroup NO-LOCK)
            NO-LOCK NO-ERROR.
        CASE TRUE:
            WHEN AVAILABLE pri_comclientgrp_d AND pri_comclientgrp_d.Principal = NO THEN DO:
                /* Pertenece a un grupo pero no es el principal */
                /* Busquemos el principal */
                DEF VAR cIdGroup LIKE pri_comclientgrp_h.IdGroup NO-UNDO.

                cIdGroup = pri_comclientgrp_d.IdGroup.
                FIND FIRST pri_comclientgrp_d WHERE pri_comclientgrp_d.IdGroup = cIdGroup AND
                    pri_comclientgrp_d.Principal = YES NO-LOCK NO-ERROR.
                IF NOT AVAILABLE pri_comclientgrp_d THEN DO:
                    MESSAGE 'El código del cliente pertenece al grupo comercial' CAPS(pri_comclientgrp_h.Descrip) SKIP
                        'pero el grupo NO tiene definido un PRINCIPAL' SKIP
                        'NO se puede registrar la asistencia' VIEW-AS ALERT-BOX WARNING.
                    SELF:SCREEN-VALUE = ''.
                    RETURN NO-APPLY.
                END.
                /* Se migra el código del cliente al principal, que se supone que es la persona que está invitada */
                SELF:SCREEN-VALUE = pri_comclientgrp_d.CodCli.
            END.
        END CASE.
    END.

    /* 2da vuelta*/
    IF NOT CAN-FIND(FIRST ExpAsist WHERE ExpAsist.CodCia = S-CODCIA AND 
                    ExpAsist.CodDiv = s-CodDiv AND
                    ExpAsist.CodCli = SELF:SCREEN-VALUE
                    NO-LOCK)
        THEN DO:
        MESSAGE 'Cliente NO invitado' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.

    /* 3ro NO debe estar registrado el día de hoy */
    FIND FIRST ExpAsist WHERE {&Condicion} AND ExpAsist.CodCli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE ExpAsist AND ExpAsist.Fecha = TODAY  THEN DO:
        REPOSITION {&browse-name} TO ROWID ROWID(ExpAsist) NO-ERROR.
        MESSAGE 'Cliente ya ha sido registrado el dia de hoy ' VIEW-AS ALERT-BOX WARNING BUTTONS OK.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.

    /* 4to # de asistentes */
    DEF VAR pAsistentes AS INTE NO-UNDO.

    RUN vtaexp/d-control-de-asistencia.w (INPUT SELF:SCREEN-VALUE,
                                          OUTPUT pAsistentes).
    IF pAsistentes <= 0 THEN DO:
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.

    pMensaje = "".
    RUN Registra-Asistencia (INPUT pAsistentes, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo grabar la asistencia' + CHR(10) + 'Vuelva a intentarlo'.
        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    SELF:SCREEN-VALUE = ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Descrip
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Descrip W-Win
ON END-ERROR OF FILL-IN_Descrip IN FRAME F-Main
DO:
  APPLY 'CHOOSE':U TO BUTTON_Exit.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

ON F8 ANYWHERE DO:
    DO WITH FRAME {&FRAME-NAME}:
        VIEW BUTTON_Down BUTTON_Exit BUTTON_Up FILL-IN_Descrip .
        ENABLE BUTTON_Down BUTTON_Exit BUTTON_Up FILL-IN_Descrip .
        DISABLE BUTTON-1 BUTTON-2 FILL-IN-CodCli.
        APPLY 'ENTRY':U TO FILL-IN_Descrip IN FRAME {&FRAME-NAME}.
    END.
    RETURN.
END.

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
  DISPLAY FILL-IN-CodCli FILL-IN_Descrip 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-CodCli BUTTON-1 BUTTON-2 FILL-IN_Descrip BUTTON_Down BUTTON_Up 
         BUTTON_Exit BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Barras W-Win 
PROCEDURE Imprime-Barras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT AVAILABLE ExpAsist THEN RETURN.

  DEFINE VARIABLE cNomCli AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cRucCli AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cCodCli AS CHARACTER   FORMAT "99999999999" NO-UNDO.
  DEFINE VAR lNroCorre AS CHAR.
  DEFINE VAR lClas AS CHAR.
  DEFINE VARIABLE iNumCop AS INTEGER     NO-UNDO.
  DEF VAR rpta AS LOG.  
    
  iNumCop = INT(1).

  FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = ExpAsist.CodCli NO-LOCK NO-ERROR.
  IF NOT AVAIL gn-clie THEN DO:
      MESSAGE "Cliente no registrado en el sistema"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN.
  END.
  
  ASSIGN 
      cNomCli = gn-clie.nomcli 
      /* Cliente VIP */
      cRucCli = TRIM(gn-clie.codcli).
      lClas = IF (expasist.libre_c03 <> ?) THEN TRIM(expasist.libre_c03) ELSE 'N9999'.
      IF SUBSTRING(lClas,1,1) = 'V' THEN cRucCli = TRIM(cRucCli) + "*".
      IF SUBSTRING(lClas,1,1) = 'E' THEN cRucCli = TRIM(cRucCli) + "-".
      cCodCli = gn-clie.codcli.
      lNroCorre = SUBSTRING(TRIM(lClas),2).

  RUN lib/_port-name ("Barras", OUTPUT s-port-name).
  IF s-port-name = '' THEN RETURN.
  
  DEFINE VAR x-status AS LOG.

  SYSTEM-DIALOG PRINTER-SETUP  UPDATE x-status.
  IF x-status = NO THEN RETURN.
  OUTPUT STREAM REPORTE TO PRINTER.  
  PUT STREAM REPORTE '^XA^LH50,012'               SKIP.   /* Inicia formato */
    {vtaexp/ean-clientes.i}
    PUT STREAM REPORTE '^PQ' + TRIM(STRING(iNumCop))      SKIP.  /* Cantidad a imprimir */
    PUT STREAM REPORTE '^PR' + '4'                  SKIP.   /* Velocidad de impresion Pulg/seg */
    PUT STREAM REPORTE '^XZ'                        SKIP.

OUTPUT STREAM REPORTE CLOSE.

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
      FILL-IN_Descrip:VISIBLE = NO.
      BUTTON_Down:VISIBLE = NO.
      BUTTON_Exit:VISIBLE = NO.
      BUTTON_Up:VISIBLE = NO.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Registra-Asistencia W-Win 
PROCEDURE Registra-Asistencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pAsistentes AS INTE NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR cRowid AS ROWID NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="ExpAsist" ~
        &Alcance="FIRST" ~
        &Condicion="ExpAsist.CodCia = S-CODCIA AND ~
                    ExpAsist.CodDiv = s-CodDiv AND 
                    ExpAsist.CodCli = FILL-IN-CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME}" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR NO-WAIT" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
        
    cRowid = ROWID(ExpAsist).
        
    DEFINE VAR x-fecasi2 AS DATE.
    DEFINE VAR x-fecasi3 AS DATE.

    ASSIGN
        ExpAsist.Asistentes    = pAsistentes
        ExpAsist.Estado[1]     = 'C'
        ExpAsist.Fecha         = TODAY     /*Campo Referencial*/
        ExpAsist.Hora          = STRING(TIME,"HH:MM")
        ExpAsist.usuario       = s-user-id.

    DEF VAR k AS INTE NO-UNDO.
    RLOOP:
    DO k = 1 TO 5:
        IF ExpAsist.FecAsi[k] = ? THEN DO:
            ExpAsist.FecAsi[k]  = TODAY.
            ExpAsist.HoraAsi[k] = STRING(TIME,"HH:MM:SS").
            /* LOG de control */
            CREATE LogExpAsist.
            ASSIGN
                LogExpAsist.Asistentes  =   ExpAsist.Asistentes  
                LogExpAsist.CodCia      =   ExpAsist.CodCia      
                LogExpAsist.CodCli      =   ExpAsist.CodCli      
                LogExpAsist.CodDiv      =   ExpAsist.CodDiv      
                LogExpAsist.Estado      =   ExpAsist.Estado[1]
                LogExpAsist.FecAsi      =   ExpAsist.FecAsi[k]
                LogExpAsist.Fecha       =   ExpAsist.Fecha       
                LogExpAsist.FecPro      =   ExpAsist.FecPro      
                LogExpAsist.Hora        =   ExpAsist.Hora        
                LogExpAsist.HoraAsi     =   ExpAsist.HoraAsi[k]
                LogExpAsist.HoraPro     =   ExpAsist.HoraPro     
                LogExpAsist.Usuario     =   ExpAsist.Usuario     
                .
            LEAVE RLOOP.
        END.
    END.

    ASSIGN ExpAsist.libre_d05 = "GEN3EROS".
    x-fecasi2 = ExpAsist.FecAsi[2].
    x-fecasi3 = ExpAsist.FecAsi[3].

    IF AVAILABLE(ExpAsist) THEN RELEASE ExpAsist.
    IF AVAILABLE(LogExpAsist) THEN RELEASE LogExpAsist.

    /* Nos posicionamos el el registro */
    {&OPEN-QUERY-{&BROWSE-NAME}}
    REPOSITION {&browse-name} TO ROWID cRowid NO-ERROR.
    IF ERROR-STATUS:ERROR = NO THEN DO:
        IF x-FecAsi2 = ? AND x-FecAsi3 = ? THEN RUN Imprime-Barras. 
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
  {src/adm/template/snd-list.i "ExpAsist"}
  {src/adm/template/snd-list.i "gn-clie"}

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

