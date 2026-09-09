&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-ClieL LIKE Gn-ClieL.
DEFINE TEMP-TABLE T-ClieL-2 NO-UNDO LIKE Gn-ClieL.



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
DEF SHARED VAR s-user-id AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-ClieL gn-clie Gn-ClieL T-ClieL-2

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 T-ClieL.CodCli gn-clie.NomCli ~
T-ClieL.FchIni T-ClieL.FchFin T-ClieL.ImpLC Gn-ClieL.ImpLC 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH T-ClieL NO-LOCK, ~
      FIRST gn-clie OF T-ClieL NO-LOCK, ~
      LAST Gn-ClieL OF gn-clie OUTER-JOIN NO-LOCK ~
    BY Gn-ClieL.FchIni ~
       BY Gn-ClieL.FchFin INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH T-ClieL NO-LOCK, ~
      FIRST gn-clie OF T-ClieL NO-LOCK, ~
      LAST Gn-ClieL OF gn-clie OUTER-JOIN NO-LOCK ~
    BY Gn-ClieL.FchIni ~
       BY Gn-ClieL.FchFin INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 T-ClieL gn-clie Gn-ClieL
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 T-ClieL
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-1 gn-clie
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-1 Gn-ClieL


/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 T-ClieL-2.CodCli T-ClieL-2.FchFin ~
T-ClieL-2.ImpLC 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7 
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH T-ClieL-2 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY BROWSE-7 FOR EACH T-ClieL-2 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 T-ClieL-2
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 T-ClieL-2


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}~
    ~{&OPEN-QUERY-BROWSE-7}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-34 BUTTON-Excel BUTTON-2 BtnDone ~
BROWSE-1 BROWSE-7 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-FlgAut FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 7 BY 1.35
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     LABEL "ACEPTAR NUEVAS LINEAS" 
     SIZE 22 BY 1.35.

DEFINE BUTTON BUTTON-Excel 
     LABEL "IMPORTAR EXCEL" 
     SIZE 16 BY 1.35.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 113 BY .81
     BGCOLOR 8 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RADIO-SET-FlgAut AS CHARACTER INITIAL "A" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Autorizado", "A",
"Sin Autorizar", " "
     SIZE 22 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 113 BY 4.04.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56 BY 1.35.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      T-ClieL, 
      gn-clie, 
      Gn-ClieL SCROLLING.

DEFINE QUERY BROWSE-7 FOR 
      T-ClieL-2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      T-ClieL.CodCli FORMAT "x(11)":U WIDTH 9.43
      gn-clie.NomCli FORMAT "x(250)":U WIDTH 47.43
      T-ClieL.FchIni COLUMN-LABEL "Fecha de Inicio" FORMAT "99/99/9999":U
            WIDTH 11.43
      T-ClieL.FchFin COLUMN-LABEL "Fecha de Termino" FORMAT "99/99/9999":U
            WIDTH 13.43
      T-ClieL.ImpLC COLUMN-LABEL "Linea de Credito!Propuesta S/." FORMAT ">>>,>>>,>>9.99":U
            WIDTH 12.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      Gn-ClieL.ImpLC COLUMN-LABEL "Linea de Credito!Actual S/." FORMAT ">>>,>>>,>>9.99":U
            WIDTH 12.72 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 113 BY 11.35
         FONT 4 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 W-Win _STRUCTURED
  QUERY BROWSE-7 NO-LOCK DISPLAY
      T-ClieL-2.CodCli COLUMN-LABEL "Cliente" FORMAT "x(11)":U
      T-ClieL-2.FchFin COLUMN-LABEL "Fecha de Termino" FORMAT "99/99/9999":U
            WIDTH 12.86
      T-ClieL-2.ImpLC FORMAT ">>>,>>>,>>9.99":U WIDTH 18.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 44 BY 3.35
         FONT 4
         TITLE "    A            |B                    |C                                |" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Excel AT ROW 1.19 COL 3 WIDGET-ID 96
     BUTTON-2 AT ROW 1.19 COL 19 WIDGET-ID 100
     BtnDone AT ROW 1.27 COL 109 WIDGET-ID 98
     RADIO-SET-FlgAut AT ROW 1.54 COL 74 NO-LABEL WIDGET-ID 104
     BROWSE-1 AT ROW 2.73 COL 3 WIDGET-ID 200
     BROWSE-7 AT ROW 14.96 COL 5 WIDGET-ID 300
     FILL-IN-Mensaje AT ROW 18.69 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 102
     "Seleccione la AUTORIZACION por defecto:" VIEW-AS TEXT
          SIZE 30 BY .5 AT ROW 1.62 COL 43 WIDGET-ID 108
     "FORMATO DEL ARCHIVO EXCEL" VIEW-AS TEXT
          SIZE 25 BY .5 AT ROW 14.27 COL 5 WIDGET-ID 90
          BGCOLOR 7 FGCOLOR 15 
     "<<-- La primera línea debe contener los encabezados de las columnas" VIEW-AS TEXT
          SIZE 48 BY .5 AT ROW 15.81 COL 53 WIDGET-ID 92
     RECT-1 AT ROW 14.54 COL 3 WIDGET-ID 94
     RECT-34 AT ROW 1.27 COL 41 WIDGET-ID 110
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 117.86 BY 18.65
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-ClieL T "?" ? INTEGRAL Gn-ClieL
      TABLE: T-ClieL-2 T "?" NO-UNDO INTEGRAL Gn-ClieL
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ACTUALIZACION DE LAS LINEAS DE CREDITO"
         HEIGHT             = 18.65
         WIDTH              = 117.86
         MAX-HEIGHT         = 19
         MAX-WIDTH          = 128.86
         VIRTUAL-HEIGHT     = 19
         VIRTUAL-WIDTH      = 128.86
         MAX-BUTTON         = no
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
/* BROWSE-TAB BROWSE-1 RADIO-SET-FlgAut F-Main */
/* BROWSE-TAB BROWSE-7 BROWSE-1 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET RADIO-SET-FlgAut IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "Temp-Tables.T-ClieL,INTEGRAL.gn-clie OF Temp-Tables.T-ClieL,INTEGRAL.Gn-ClieL OF INTEGRAL.gn-clie"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST, LAST OUTER"
     _OrdList          = "INTEGRAL.Gn-ClieL.FchIni|yes,INTEGRAL.Gn-ClieL.FchFin|yes"
     _FldNameList[1]   > Temp-Tables.T-ClieL.CodCli
"T-ClieL.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.gn-clie.NomCli
"gn-clie.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "47.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-ClieL.FchIni
"T-ClieL.FchIni" "Fecha de Inicio" "99/99/9999" "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-ClieL.FchFin
"T-ClieL.FchFin" "Fecha de Termino" "99/99/9999" "date" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-ClieL.ImpLC
"T-ClieL.ImpLC" "Linea de Credito!Propuesta S/." ? "decimal" 11 0 ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.Gn-ClieL.ImpLC
"Gn-ClieL.ImpLC" "Linea de Credito!Actual S/." ? "decimal" 14 0 ? ? ? ? no ? no no "12.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _TblList          = "Temp-Tables.T-ClieL-2"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.T-ClieL-2.CodCli
"T-ClieL-2.CodCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-ClieL-2.FchFin
"T-ClieL-2.FchFin" "Fecha de Termino" "99/99/9999" "date" ? ? ? ? ? ? no ? no no "12.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-ClieL-2.ImpLC
"T-ClieL-2.ImpLC" ? ? "decimal" ? ? ? ? ? ? no ? no no "18.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ACTUALIZACION DE LAS LINEAS DE CREDITO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ACTUALIZACION DE LAS LINEAS DE CREDITO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
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


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* ACEPTAR NUEVAS LINEAS */
DO:
   MESSAGE 'Procedemos a actualizar las lineas de crédito?'
       VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
       UPDATE rpta AS LOG.
   IF rpta = YES THEN DO:
       ASSIGN RADIO-SET-FlgAut.
       SESSION:SET-WAIT-STATE('COMPILER').
       RUN Aceptar-Lineas.
       SESSION:SET-WAIT-STATE('').
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Excel W-Win
ON CHOOSE OF BUTTON-Excel IN FRAME F-Main /* IMPORTAR EXCEL */
DO:
  SESSION:SET-WAIT-STATE('COMPILER').
  RUN Importar-Excel.
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aceptar-Lineas W-Win 
PROCEDURE Aceptar-Lineas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER B-CLIEL FOR Gn-ClieL.
DEF VAR FILL-IN-Campana AS CHAR NO-UNDO.

FOR EACH T-CLIEL, FIRST gn-clie OF T-ClieL EXCLUSIVE-LOCK
    TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':

    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
        "PROCESANDO: " + gn-clie.codcli + " " + gn-clie.nomcli.

    /* rastreamos ultima linea de credito */
    FOR LAST B-CLIEL OF gn-clie BY B-CLIEL.fchini BY B-CLIEL.fchfin:
        IF B-CLIEL.fchfin >= TODAY THEN B-CLIEL.fchfin = TODAY - 1.
    END.
    /* creamos la nueva linea de credito */
    CREATE B-CLIEL.
    ASSIGN
        B-CLIEL.CodCia = gn-clie.codcia
        B-CLIEL.CodCli = gn-clie.codcli
        B-CLIEL.fchaut[1] = TODAY
        B-CLIEL.fchini = TODAY
        B-CLIEL.fchfin = T-CLIEL.fchfin
        B-CLIEL.monlc  = 1
        B-CLIEL.implc  = T-CLIEL.implc
        B-CLIEL.usrlc  = s-user-id.
    ASSIGN
        gn-clie.FlagAut = RADIO-SET-FlgAut
        gn-clie.MonLC   = 1.
    IF gn-clie.FlagAut = "A" THEN DO:
        FILL-IN-Campana = "".
        FIND FIRST Vtatabla WHERE VtaTabla.CodCia = s-codcia
            AND VtaTabla.Tabla = "CAMPAÑAS"
            AND TODAY >= VtaTabla.Rango_fecha[1]
            AND TODAY <= VtaTabla.Rango_fecha[2]
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaTabla THEN FILL-IN-Campana = VtaTabla.Llave_c1.
        ASSIGN
            gn-clie.UsrAut = S-USER-ID
            gn-clie.FchAut[1] = TODAY.
        RUN lib/logtabla ("gn-clie",
                          gn-clie.codcli + '|' + FILL-IN-Campana,
                          "AUTORIZA-LIN-CRED").
    END.
    CREATE LogTabla.
    ASSIGN
        logtabla.codcia = s-codcia
        logtabla.Dia = TODAY
        logtabla.Evento = 'LINEA-CREDITO'
        logtabla.Hora = STRING(TIME, 'HH:MM')
        logtabla.Tabla = 'GN-CLIEL'
        logtabla.Usuario = s-user-id
        logtabla.ValorLlave = STRING(gn-clie.codcli, 'x(11)') + '|' +
                            STRING(gn-clie.nomcli, 'x(50)') + '|' +
                            STRING(B-CLIEL.MonLC, '9') + '|' +
                            STRING(B-CLIEL.ImpLC, '->>>>>>>>9.99') + '|' +
                            STRING(gn-clie.CndVta, 'x(4)').
    DELETE T-CLIEL.
END.
IF AVAILABLE(gn-clie) THEN RELEASE gn-clie.
IF AVAILABLE(LogTabla) THEN RELEASE LogTabla.

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
{&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  DISPLAY RADIO-SET-FlgAut FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-34 BUTTON-Excel BUTTON-2 BtnDone BROWSE-1 BROWSE-7 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
EMPTY TEMP-TABLE T-CLIEL.

/* SEGUNDO IMPORTAMOS DESDE EL EXCEL */
DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chWorkbook AS COM-HANDLE.
DEFINE VARIABLE chWorksheet AS COM-HANDLE.

DEFINE VARIABLE cRange AS CHARACTER NO-UNDO.
DEFINE VARIABLE iCountLine AS INTEGER NO-UNDO.
DEFINE VARIABLE iTotalColumn AS INTEGER NO-UNDO.
DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
DEFINE VARIABLE iValue AS int64 NO-UNDO.
DEFINE VARIABLE dValue AS DECIMAL NO-UNDO.

CREATE "Excel.Application" chExcelApplication.

chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-file).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

iCountLine = 1.     /* Saltamos el encabezado de los campos */
REPEAT:
    iCountLine = iCountLine + 1.
    cRange = "A" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */
    ASSIGN
        dValue = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Valor del código del cliente errado:' cValue VIEW-AS ALERT-BOX ERROR.
        NEXT.
    END.
    cValue = STRING(dValue, '99999999999').
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = cValue NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Cliente NO registrado:' cValue VIEW-AS ALERT-BOX ERROR.
        NEXT.
    END.

    CREATE T-CLIEL.
    /* CODIGO */
    cRange = "A" + TRIM(STRING(iCountLine)).
    ASSIGN
        T-CLIEL.CodCia = cl-codcia
        T-CLIEL.CodCli = cValue
        T-CLIEL.FchIni = TODAY
        T-CLIEL.MonLC  = 1.

    /* FECHA */
    cRange = "B" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN
        T-CLIEL.FchFin = DATE(cValue).
    /* IMPORTE */
    cRange = "C" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN
        T-CLIEL.ImpLC = DECIMAL (cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Valor' cValue 'no reconocido:' cValue SKIP
            'Campo: Importe Linea de Credito' VIEW-AS ALERT-BOX ERROR.
        NEXT.
    END.
END.
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

/* RHC 04/11/2013 VERIFICAMOS LIMITE DEL USUARIO */
DEFINE VAR wcambio AS DECIMAL NO-UNDO.
DEFINE VAR lvalido AS LOG INIT YES NO-UNDO.

FIND gn-LinUsr WHERE gn-LinUsr.Usuario = S-USER-ID NO-LOCK NO-ERROR.
FIND FIRST FacCfgGn  WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
wcambio = FacCfgGn.Tpocmb[1].

FOR EACH T-CLIEL:
    IF T-CLIEL.ImpLC <= 0 THEN DO:
        DELETE T-CLIEL.
        NEXT.
    END.
END.

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
  {src/adm/template/snd-list.i "T-ClieL-2"}
  {src/adm/template/snd-list.i "T-ClieL"}
  {src/adm/template/snd-list.i "gn-clie"}
  {src/adm/template/snd-list.i "Gn-ClieL"}

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

