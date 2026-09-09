&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-gn-clie NO-UNDO LIKE gn-clie.



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

DEFINE VAR x-tabla AS CHAR.

DEFINE NEW SHARED VAR input-var-1 AS CHAR.
DEFINE NEW SHARED VAR input-var-2 AS CHAR.
DEFINE NEW SHARED VAR input-var-3 AS CHAR.
DEFINE NEW SHARED VAR output-var-1 AS ROWID.
DEFINE NEW SHARED VAR output-var-2 AS CHAR.
DEFINE NEW SHARED VAR output-var-3 AS CHAR.

DEFINE VAR x-codclie AS CHAR.

x-tabla = 'CLIENTE_VIP_CONTI'.

DEFINE BUFFER x-vtatabla FOR vtatabla.

DEF VAR pMensaje AS CHAR NO-UNDO.

DEFINE VARIABLE chExcelApplication          AS COM-HANDLE.
DEFINE VARIABLE chWorkbook                  AS COM-HANDLE.
DEFINE VARIABLE chWorksheet                 AS COM-HANDLE.
DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.
DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.

DEFINE VAR x-total AS INT.
DEFINE VAR x-validos AS INT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-4

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES VtaTabla gn-clie t-gn-clie

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 VtaTabla.Llave_c1 gn-clie.Ruc ~
gn-clie.NomCli gn-clie.DirCli 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH VtaTabla ~
      WHERE VtaTabla.CodCia = s-codcia and  ~
VtaTabla.Tabla = x-tabla  NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.codcia = 0 and ~
gn-clie.CodCli =  VtaTabla.Llave_c1 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH VtaTabla ~
      WHERE VtaTabla.CodCia = s-codcia and  ~
VtaTabla.Tabla = x-tabla  NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.codcia = 0 and ~
gn-clie.CodCli =  VtaTabla.Llave_c1 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 VtaTabla gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 VtaTabla
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-4 gn-clie


/* Definitions for BROWSE BROWSE-9                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-9 t-gn-clie.CodCli 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-9 
&Scoped-define QUERY-STRING-BROWSE-9 FOR EACH t-gn-clie NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-9 OPEN QUERY BROWSE-9 FOR EACH t-gn-clie NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-9 t-gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-9 t-gn-clie


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-4}~
    ~{&OPEN-QUERY-BROWSE-9}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 RECT-4 BUTTON-1 BROWSE-4 ~
BUTTON-4 BROWSE-9 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/b-buscar.ico":U
     LABEL "Button 1" 
     SIZE 4 BY 1.12.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/import-excel.bmp":U
     LABEL "Button 4" 
     SIZE 19 BY 1.62.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 34 BY 1.08
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 5 BY 3.15
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 5 BY 1.08
     BGCOLOR 7 FGCOLOR 0 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      VtaTabla, 
      gn-clie SCROLLING.

DEFINE QUERY BROWSE-9 FOR 
      t-gn-clie SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      VtaTabla.Llave_c1 COLUMN-LABEL "Codigo" FORMAT "x(11)":U
            WIDTH 12.72
      gn-clie.Ruc COLUMN-LABEL "R.U.C." FORMAT "x(11)":U WIDTH 12.14
      gn-clie.NomCli FORMAT "x(80)":U WIDTH 43.72
      gn-clie.DirCli FORMAT "x(100)":U WIDTH 40.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 114.29 BY 19.23
         FONT 4
         TITLE "Clientes VIP" ROW-HEIGHT-CHARS .58.

DEFINE BROWSE BROWSE-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-9 W-Win _STRUCTURED
  QUERY BROWSE-9 NO-LOCK DISPLAY
      t-gn-clie.CodCli COLUMN-LABEL "Codigo Cliente" FORMAT "x(11)":U
            WIDTH 30.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 34 BY 3.15
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1.15 COL 22 WIDGET-ID 4
     BROWSE-4 AT ROW 2.35 COL 1.72 WIDGET-ID 200
     BUTTON-4 AT ROW 22.73 COL 69 WIDGET-ID 52
     BROWSE-9 AT ROW 22.77 COL 7 WIDGET-ID 300
     "PARA LA CARGA MASIVA" VIEW-AS TEXT
          SIZE 20 BY .77 AT ROW 23.58 COL 43.29 WIDGET-ID 48
          FGCOLOR 9 
     "FORMATO DE ARCHIVO EXCEL" VIEW-AS TEXT
          SIZE 24 BY .77 AT ROW 22.81 COL 42 WIDGET-ID 46
          FGCOLOR 9 
     "A" VIEW-AS TEXT
          SIZE 32 BY .62 AT ROW 21.96 COL 8 WIDGET-ID 36
          BGCOLOR 8 FGCOLOR 0 
     "1" VIEW-AS TEXT
          SIZE 2 BY .62 AT ROW 23.04 COL 4 WIDGET-ID 38
          BGCOLOR 8 FGCOLOR 0 
     "2" VIEW-AS TEXT
          SIZE 2 BY .62 AT ROW 23.85 COL 4 WIDGET-ID 40
          BGCOLOR 8 FGCOLOR 0 
     "3" VIEW-AS TEXT
          SIZE 2 BY .62 AT ROW 24.65 COL 4 WIDGET-ID 42
          BGCOLOR 8 FGCOLOR 0 
     "DobleClick en CODIGO para eliminar" VIEW-AS TEXT
          SIZE 26 BY .77 AT ROW 1.35 COL 36 WIDGET-ID 8
          FGCOLOR 4 
     "Agregar cliente :" VIEW-AS TEXT
          SIZE 14 BY .96 AT ROW 1.19 COL 7.29 WIDGET-ID 6
          BGCOLOR 15 FGCOLOR 9 FONT 6
     RECT-2 AT ROW 21.69 COL 7 WIDGET-ID 26
     RECT-3 AT ROW 22.77 COL 2 WIDGET-ID 28
     RECT-4 AT ROW 21.69 COL 2 WIDGET-ID 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 115.86 BY 26.73
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t-gn-clie T "?" NO-UNDO INTEGRAL gn-clie
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CLIENTES VIP"
         HEIGHT             = 25.04
         WIDTH              = 115.86
         MAX-HEIGHT         = 30.58
         MAX-WIDTH          = 126
         VIRTUAL-HEIGHT     = 30.58
         VIRTUAL-WIDTH      = 126
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
/* BROWSE-TAB BROWSE-4 BUTTON-1 F-Main */
/* BROWSE-TAB BROWSE-9 BUTTON-4 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "INTEGRAL.VtaTabla,INTEGRAL.gn-clie WHERE INTEGRAL.VtaTabla ... ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "VtaTabla.CodCia = s-codcia and 
VtaTabla.Tabla = x-tabla "
     _JoinCode[2]      = "gn-clie.codcia = 0 and
gn-clie.CodCli =  VtaTabla.Llave_c1"
     _FldNameList[1]   > INTEGRAL.VtaTabla.Llave_c1
"VtaTabla.Llave_c1" "Codigo" "x(11)" "character" ? ? ? ? ? ? no ? no no "12.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.gn-clie.Ruc
"gn-clie.Ruc" "R.U.C." ? "character" ? ? ? ? ? ? no ? no no "12.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.gn-clie.NomCli
"gn-clie.NomCli" ? "x(80)" "character" ? ? ? ? ? ? no ? no no "43.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.gn-clie.DirCli
"gn-clie.DirCli" ? ? "character" ? ? ? ? ? ? no ? no no "40.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-9
/* Query rebuild information for BROWSE BROWSE-9
     _TblList          = "Temp-Tables.t-gn-clie"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.t-gn-clie.CodCli
"t-gn-clie.CodCli" "Codigo Cliente" ? "character" ? ? ? ? ? ? no ? no no "30.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-9 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CLIENTES VIP */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CLIENTES VIP */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
&Scoped-define SELF-NAME BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-4 IN FRAME F-Main /* Clientes VIP */
DO:

    IF AVAILABLE vtatabla THEN DO:
        MESSAGE 'Seguro de ELIMINAR el codigo ' + vtatabla.llave_c1 SKIP
                gn-clie.nomcli 
                  VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

        FIND FIRST x-vtatabla  WHERE rowid(x-vtatabla) = ROWID(vtatabla) EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE x-vtatabla THEN DO:
            DELETE vtatabla.

            RELEASE vtatabla.

            {&open-query-browse-4}
        END.

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  /*RUN dispatch IN THIS-PROCEDURE ('qbusca':U).*/
  RUN buscar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
  RUN Captura-Excel .
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscar W-Win 
PROCEDURE buscar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").


  /* Code placed here will execute AFTER standard behavior.    */
  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
      RUN lkup/c-client ("Clientes").
      IF OUTPUT-VAR-1 <> ? THEN DO:
          FIND FIRST gn-clie WHERE ROWID(gn-clie) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
          IF AVAILABLE gn-clie THEN DO:
              FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                                            x-vtatabla.tabla = x-tabla AND
                                            x-vtatabla.llave_c1 = gn-clie.codcli EXCLUSIVE-LOCK NO-ERROR.
              IF NOT AVAILABLE x-vtatabla THEN DO:
                  CREATE x-vtatabla.
                    ASSIGN x-vtatabla.codcia = s-codcia
                            x-vtatabla.tabla = x-tabla
                            x-vtatabla.llave_c1 = gn-clie.codcli
                        .
                    RELEASE x-vtatabla.

                    {&open-query-browse-4}
              END.
              ELSE DO:
                  MESSAGE "Cliente " + gn-clie.nomcli SKIP
                        "Ya existe"
                      VIEW-AS ALERT-BOX INFORMATION.
              END.

          END.
      END.

      /*
      IF OUTPUT-VAR-1 <> ? THEN DO:
           FIND {&FIRST-TABLE-IN-QUERY-BROWSE-2} WHERE
                ROWID({&FIRST-TABLE-IN-QUERY-BROWSE-2}) = OUTPUT-VAR-1
                NO-LOCK NO-ERROR.
           IF AVAIL {&FIRST-TABLE-IN-QUERY-BROWSE-2} THEN DO:
               /*
               FILL-IN-CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
                   {&FIRST-TABLE-IN-QUERY-BROWSE-2}.codcli.
               FILL-IN_NomCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
                   {&FIRST-TABLE-IN-QUERY-BROWSE-2}.nomcli.
               */
               REPOSITION {&FIRST-TABLE-IN-QUERY-BROWSE-2}  TO ROWID OUTPUT-VAR-1 NO-ERROR.
               IF NOT ERROR-STATUS:ERROR THEN RUN dispatch IN THIS-PROCEDURE ('get-next':U).
           END.
      END.
      */
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE captura-Excel W-Win 
PROCEDURE captura-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR OKpressed AS LOG.                         
    DEFINE VAR fill-in-archivo AS CHAR.
    
    SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
        FILTERS "Archivos Excel (*.xls,*.xlsx)" "*.xls,*.xlsx", "Todos (*.*)" "*.*"
        TITLE "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = FALSE THEN RETURN 'ADM-ERROR'.

    /* CREAMOS LA HOJA EXCEL */
    CREATE "Excel.Application" chExcelApplication.
    chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Carga-Temporal.
    SESSION:SET-WAIT-STATE('').

    /* CERRAMOS EL EXCEL */
    chExcelApplication:QUIT().
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet. 

    MESSAGE "Se cargaron " + STRING(x-validos) + " de " + STRING(x-total) + " Clientes".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-clientes W-Win 
PROCEDURE carga-clientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal W-Win 
PROCEDURE carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

x-total = 0.
x-validos = 0.

ASSIGN
    pMensaje = ""
    t-Column = 0
    t-Row = 1.     /* Saltamos el encabezado de los campos */
REPEAT:

    t-column = 0.
    t-Row    = t-Row + 1.
    /* Cliente */
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):TEXT.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 

    x-total = x-total + 1.

    FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND 
        gn-clie.codcli = cValue NO-LOCK NO-ERROR.

    IF AVAILABLE gn-clie THEN DO:
        FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                                      x-vtatabla.tabla = x-tabla AND
                                      x-vtatabla.llave_c1 = gn-clie.codcli EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE x-vtatabla THEN DO:
            CREATE x-vtatabla.
              ASSIGN x-vtatabla.codcia = s-codcia
                      x-vtatabla.tabla = x-tabla
                      x-vtatabla.llave_c1 = gn-clie.codcli
                  .
              RELEASE x-vtatabla.

              x-validos = x-validos + 1.
        END.
    END.
END.

{&open-query-browse-4}


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
  ENABLE RECT-2 RECT-3 RECT-4 BUTTON-1 BROWSE-4 BUTTON-4 BROWSE-9 
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
  DEFINE VAR k AS INT.

  FOR EACH gn-clie NO-LOCK WHERE gn-clie.codcia = 0
      AND gn-clie.libre_c01 = "J"
      AND LENGTH(gn-clie.codcli) = 11
      AND gn-clie.flgsit = "A":
      k = k + 1.
      CREATE t-gn-clie.
      BUFFER-COPY gn-clie TO t-gn-clie.
      IF k = 3 THEN LEAVE.
  END.
  
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */    
  RUN carga-clientes.

  {&open-query-browse-4}


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
  {src/adm/template/snd-list.i "t-gn-clie"}
  {src/adm/template/snd-list.i "VtaTabla"}
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

