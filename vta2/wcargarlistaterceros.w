&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE E-MATG NO-UNDO LIKE Almmmatg.
DEFINE NEW SHARED TEMP-TABLE T-MATG LIKE Almmmatg.



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
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR radio-set-1 AS INT NO-UNDO.

/* VARIABLES GENERALES DEL EXCEL */
DEFINE VARIABLE FILL-IN-Archivo AS CHAR         NO-UNDO.
DEFINE VARIABLE OKpressed       AS LOG          NO-UNDO.
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

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

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
&Scoped-define INTERNAL-TABLES T-MATG

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 T-MATG.codmat T-MATG.DesMat ~
T-MATG.UndStk T-MATG.MonVta T-MATG.TpoCmb T-MATG.DesMar T-MATG.CtoTot ~
T-MATG.Prevta[1] T-MATG.Prevta[2] T-MATG.Prevta[3] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH T-MATG NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH T-MATG NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 T-MATG
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 T-MATG


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 RECT-4 RECT-5 RECT-6 RECT-7 ~
RECT-8 RECT-9 RECT-10 RECT-11 RECT-12 RECT-13 RECT-14 RECT-15 BUTTON-1 ~
TOGGLE-Borrar BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS TOGGLE-Borrar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_bcagarlistaterceros AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "CAPTURAR EXCEL" 
     SIZE 25 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "GRABAR PRECIOS" 
     SIZE 25 BY 1.12.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 5 BY 1.08
     BGCOLOR 11 FGCOLOR 0 .

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 16 BY 1.08
     BGCOLOR 11 FGCOLOR 0 .

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 10 BY 1.08
     BGCOLOR 11 FGCOLOR 0 .

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 14 BY 1.08
     BGCOLOR 11 FGCOLOR 0 .

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 14 BY 1.08
     BGCOLOR 11 FGCOLOR 0 .

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 14 BY 1.08
     BGCOLOR 11 FGCOLOR 0 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 142.43 BY 1.54
     BGCOLOR 11 FGCOLOR 0 .

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 139 BY 6.19
     BGCOLOR 15 FGCOLOR 0 .

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 7 BY 1.08
     BGCOLOR 11 FGCOLOR 0 .

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 4 BY 4.31
     BGCOLOR 11 FGCOLOR 0 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 4 BY 1.08
     BGCOLOR 11 FGCOLOR 0 .

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 36 BY 1.08
     BGCOLOR 11 FGCOLOR 0 .

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 7 BY 1.08
     BGCOLOR 11 FGCOLOR 0 .

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 8 BY 1.08
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE TOGGLE-Borrar AS LOGICAL INITIAL no 
     LABEL "Borrar lista anterior" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      T-MATG SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      T-MATG.codmat COLUMN-LABEL "CODIGO" FORMAT "X(6)":U WIDTH 6.43
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      T-MATG.DesMat FORMAT "X(45)":U WIDTH 35.43
      T-MATG.UndStk COLUMN-LABEL "Unidad" FORMAT "X(8)":U WIDTH 6.43
      T-MATG.MonVta COLUMN-LABEL "Moneda" FORMAT "9":U WIDTH 6.43
      T-MATG.TpoCmb COLUMN-LABEL "TC" FORMAT "Z9.9999":U WIDTH 5.43
      T-MATG.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U WIDTH 15.43
      T-MATG.CtoTot COLUMN-LABEL "Costo Total" FORMAT "->>>,>>9.9999":U
            WIDTH 9.43
      T-MATG.Prevta[1] COLUMN-LABEL "PRECIO LISTA 1" FORMAT ">>,>>>,>>9.9999":U
            WIDTH 13.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      T-MATG.Prevta[2] COLUMN-LABEL "PRECIO LISTA 2" FORMAT ">>,>>>,>>9.9999":U
            WIDTH 13.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      T-MATG.Prevta[3] COLUMN-LABEL "PRECIO LISTA 3" FORMAT ">>,>>>,>>9.9999":U
            WIDTH 12.72 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 133 BY 3.23
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1.19 COL 84 WIDGET-ID 2
     BUTTON-2 AT ROW 1.19 COL 109 WIDGET-ID 4
     TOGGLE-Borrar AT ROW 1.27 COL 63 WIDGET-ID 12
     BROWSE-2 AT ROW 21.73 COL 7 WIDGET-ID 200
     "D" VIEW-AS TEXT
          SIZE 3 BY .62 AT ROW 19.85 COL 60 WIDGET-ID 50
          BGCOLOR 11 FGCOLOR 0 
     "B" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 19.85 COL 28 WIDGET-ID 32
          BGCOLOR 11 FGCOLOR 0 
     "1" VIEW-AS TEXT
          SIZE 2 BY .62 AT ROW 20.92 COL 4 WIDGET-ID 34
          BGCOLOR 11 FGCOLOR 0 
     "Formato del EXCEL: Se tomarán las columnas en mayúsculas" VIEW-AS TEXT
          SIZE 43 BY .62 AT ROW 19.04 COL 3 WIDGET-ID 16
          BGCOLOR 9 FGCOLOR 15 FONT 4
     "G" VIEW-AS TEXT
          SIZE 4 BY .62 AT ROW 19.85 COL 90 WIDGET-ID 62
          BGCOLOR 11 FGCOLOR 0 
     "A" VIEW-AS TEXT
          SIZE 3 BY .62 AT ROW 19.85 COL 9 WIDGET-ID 30
          BGCOLOR 11 FGCOLOR 0 
     "H" VIEW-AS TEXT
          SIZE 4 BY .62 AT ROW 19.85 COL 102 WIDGET-ID 66
          BGCOLOR 11 FGCOLOR 0 
     "J" VIEW-AS TEXT
          SIZE 4 BY .62 AT ROW 19.85 COL 130 WIDGET-ID 74
          BGCOLOR 11 FGCOLOR 0 
     "F" VIEW-AS TEXT
          SIZE 4 BY .62 AT ROW 19.85 COL 77 WIDGET-ID 58
          BGCOLOR 11 FGCOLOR 0 
     "E" VIEW-AS TEXT
          SIZE 2 BY .62 AT ROW 19.85 COL 66 WIDGET-ID 54
          BGCOLOR 11 FGCOLOR 0 
     "I" VIEW-AS TEXT
          SIZE 4 BY .62 AT ROW 19.85 COL 116 WIDGET-ID 70
          BGCOLOR 11 FGCOLOR 0 
     "C" VIEW-AS TEXT
          SIZE 2 BY .62 AT ROW 19.85 COL 53 WIDGET-ID 46
          BGCOLOR 11 FGCOLOR 0 
     "5" VIEW-AS TEXT
          SIZE 2 BY .62 AT ROW 24.15 COL 4 WIDGET-ID 42
          BGCOLOR 11 FGCOLOR 0 
     "4" VIEW-AS TEXT
          SIZE 2 BY .62 AT ROW 23.35 COL 4 WIDGET-ID 40
          BGCOLOR 11 FGCOLOR 0 
     "3" VIEW-AS TEXT
          SIZE 2 BY .62 AT ROW 22.54 COL 4 WIDGET-ID 38
          BGCOLOR 11 FGCOLOR 0 
     "2" VIEW-AS TEXT
          SIZE 2 BY .62 AT ROW 21.73 COL 4 WIDGET-ID 36
          BGCOLOR 11 FGCOLOR 0 
     "CONTINENTAL - PRECIOS TERCEROS" VIEW-AS TEXT
          SIZE 35 BY .62 AT ROW 20.92 COL 7 WIDGET-ID 28
     RECT-2 AT ROW 1 COL 1 WIDGET-ID 10
     RECT-3 AT ROW 19.31 COL 2 WIDGET-ID 14
     RECT-4 AT ROW 19.58 COL 7 WIDGET-ID 20
     RECT-5 AT ROW 20.65 COL 3 WIDGET-ID 22
     RECT-6 AT ROW 19.58 COL 3 WIDGET-ID 24
     RECT-7 AT ROW 19.58 COL 14 WIDGET-ID 26
     RECT-8 AT ROW 19.58 COL 50 WIDGET-ID 44
     RECT-9 AT ROW 19.58 COL 57 WIDGET-ID 48
     RECT-10 AT ROW 19.58 COL 65 WIDGET-ID 52
     RECT-11 AT ROW 19.58 COL 70 WIDGET-ID 56
     RECT-12 AT ROW 19.58 COL 86 WIDGET-ID 60
     RECT-13 AT ROW 19.58 COL 96 WIDGET-ID 64
     RECT-14 AT ROW 19.58 COL 110 WIDGET-ID 68
     RECT-15 AT ROW 19.58 COL 124 WIDGET-ID 72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 142.43 BY 24.62 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: E-MATG T "?" NO-UNDO INTEGRAL Almmmatg
      TABLE: T-MATG T "NEW SHARED" ? INTEGRAL Almmmatg
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CARGA PRECIOS DE VENTA"
         HEIGHT             = 24.62
         WIDTH              = 142.43
         MAX-HEIGHT         = 27.23
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.23
         VIRTUAL-WIDTH      = 146.29
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
/* BROWSE-TAB BROWSE-2 TOGGLE-Borrar F-Main */
/* SETTINGS FOR BUTTON BUTTON-2 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.T-MATG"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.T-MATG.codmat
"T-MATG.codmat" "CODIGO" ? "character" 11 0 ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-MATG.DesMat
"T-MATG.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "35.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-MATG.UndStk
"T-MATG.UndStk" "Unidad" ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-MATG.MonVta
"T-MATG.MonVta" "Moneda" ? "integer" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-MATG.TpoCmb
"T-MATG.TpoCmb" "TC" ? "decimal" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-MATG.DesMar
"T-MATG.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-MATG.CtoTot
"T-MATG.CtoTot" "Costo Total" ? "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-MATG.Prevta[1]
"T-MATG.Prevta[1]" "PRECIO LISTA 1" ? "decimal" 11 0 ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-MATG.Prevta[2]
"T-MATG.Prevta[2]" "PRECIO LISTA 2" ? "decimal" 11 0 ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-MATG.Prevta[3]
"T-MATG.Prevta[3]" "PRECIO LISTA 3" ? "decimal" 11 0 ? ? ? ? no ? no no "12.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CARGA PRECIOS DE VENTA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CARGA PRECIOS DE VENTA */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* CAPTURAR EXCEL */
DO:
    /* RUTINA GENERAL */
    SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
        FILTERS "Archivos Excel (*.xls,*.xlsx)" "*.xls,*.xlsx", "Todos (*.*)" "*.*"
        TITLE "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = FALSE THEN RETURN NO-APPLY.
    ASSIGN TOGGLE-Borrar.

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

    /* Mensaje de error de carga */
    IF pMensaje <> "" THEN DO:
        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    ASSIGN
        BUTTON-2:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    MESSAGE 'Carga Terminada' VIEW-AS ALERT-BOX INFORMATION.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* GRABAR PRECIOS */
DO:
    ASSIGN
        TOGGLE-Borrar.
    RUN Grabar-Precios-Conti.
    ASSIGN
        BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME} = YES
        BUTTON-2:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    RUN Excel-de-Errores.
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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta2/bcagarlistaterceros.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ,
                     SortBy-Case = Familia':U ,
             OUTPUT h_bcagarlistaterceros ).
       RUN set-position IN h_bcagarlistaterceros ( 2.54 , 2.00 ) NO-ERROR.
       RUN set-size IN h_bcagarlistaterceros ( 16.35 , 140.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_bcagarlistaterceros ,
             TOGGLE-Borrar:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

DEF VAR cNombreLista AS CHAR NO-UNDO.

ASSIGN
    t-Column = 0
    t-Row = 1.    
/* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
cValue = chWorkSheet:Cells(1,1):VALUE.
IF cValue = "" OR cValue = ? THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
IF NOT (cValue = "CONTINENTAL - PRECIOS TERCEROS")
    THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
cNombreLista = cValue.
/* ******************* */
ASSIGN
    t-Row    = t-Row + 1
    t-column = t-Column + 1.
cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
IF cValue = "" OR cValue = ? OR cValue <> "CODIGO" THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
/* t-column = t-column + 1.                                                */
/* cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.                      */
/* IF cValue = "" OR cValue = ? OR cValue <> "DESCRIPCION" THEN DO:        */
/*     MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR. */
/*     RETURN.                                                             */
/* END.                                                                    */
/* CARGAMOS TEMPORALES */
RUN Carga-Temporal-Conti.
/* Filtramos solo lineas autorizadas */
FOR EACH T-MATG, FIRST Almmmatg OF T-MATG NO-LOCK:
    FIND Vtatabla WHERE Vtatabla.codcia = s-codcia
        AND Vtatabla.tabla = "LP"
        AND Vtatabla.llave_c1 = s-user-id
        AND Vtatabla.llave_c2 = Almmmatg.codfam
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtatabla THEN DELETE T-MATG.
END.
ASSIGN BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

/* RECALCULAMOS Y PINTAMOS RESULTADOS */
RUN dispatch IN h_bcagarlistaterceros ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Conti W-Win 
PROCEDURE Carga-Temporal-Conti :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-MATG.
ASSIGN
    pMensaje = ""
    t-Column = 0
    t-Row = 2.     /* Saltamos el encabezado de los campos */
REPEAT:
    ASSIGN
        t-column = 0
        t-Row    = t-Row + 1.
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
    /* CODIGO */
    CREATE T-MATG.
    ASSIGN
        T-MATG.codcia = s-codcia
        T-MATG.codmat = STRING(DECIMAL(cValue), '999999')
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Código " + cValue.
        LEAVE.
    END.
    /* DESCRIPCION */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.desmat = cValue.
    /* PRECIOS */        
    t-Column = t-Column + 6.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.Prevta[1] = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Precio de Lista #1".
        LEAVE.
    END.
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.Prevta[2] = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Precio de Lista #2".
        LEAVE.
    END.
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.Prevta[3] = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Precio de Lista #3".
        LEAVE.
    END.
END.
IF pMensaje <> "" THEN DO:
    EMPTY TEMP-TABLE T-MATG.
    RETURN.
END.
/* DEPURAMOS LOS QUE NO TIENEN PRECIO */
FOR EACH T-MATG WHERE (T-MATG.PreVta[1] + T-MATG.PreVta[2] + T-MATG.PreVta[3]) = 0:
    DELETE T-MATG.
END.
/* *********************************** */
/* Cargamos precios actuales */
FOR EACH T-MATG, 
    FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = T-MATG.codmat
    NO-LOCK:
    ASSIGN
        T-MATG.CodCia  = Almmmatg.CodCia
        T-MATG.UndBas  = Almmmatg.UndBas
        T-MATG.UndStk  = Almmmatg.UndStk
        T-MATG.DesMar  = Almmmatg.DesMar
        T-MATG.MonVta = Almmmatg.MonVta 
        T-MATG.TpoCmb = Almmmatg.TpoCmb
        T-MATG.CtoLis = Almmmatg.CtoLis
        T-MATG.CtoTot = Almmmatg.CtoTot
        T-MATG.PreVta[1] = (IF T-MATG.PreVta[1] = ? THEN 0 ELSE T-MATG.PreVta[1])
        T-MATG.PreVta[2] = (IF T-MATG.PreVta[2] = ? THEN 0 ELSE T-MATG.PreVta[2])
        T-MATG.PreVta[3] = (IF T-MATG.PreVta[3] = ? THEN 0 ELSE T-MATG.PreVta[3]).
    IF Almmmatg.MonVta = 2 THEN
        ASSIGN
        T-MATG.CtoLis = Almmmatg.CtoLis * Almmmatg.TpoCmb
        T-MATG.CtoTot = Almmmatg.CtoTot * Almmmatg.TpoCmb.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Consistencias W-Win 
PROCEDURE Consistencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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
  DISPLAY TOGGLE-Borrar 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-2 RECT-3 RECT-4 RECT-5 RECT-6 RECT-7 RECT-8 RECT-9 RECT-10 
         RECT-11 RECT-12 RECT-13 RECT-14 RECT-15 BUTTON-1 TOGGLE-Borrar 
         BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-de-Errores W-Win 
PROCEDURE Excel-de-Errores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST E-MATG NO-LOCK NO-ERROR.
IF NOT AVAILABLE E-MATG THEN RETURN.
MESSAGE 'Los siguientes producto NO se han actualizado' SKIP
    'Se mostrará una lista de errores en Excel'
    VIEW-AS ALERT-BOX WARNING.

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
DEF VAR x-CtoTot LIKE Almmmatg.ctotot NO-UNDO.
DEF VAR x-PreVta LIKE Almmmatg.prevta NO-UNDO.
DEF VAR x-PreOfi LIKE Almmmatg.preofi NO-UNDO.

ASSIGN
    chWorkSheet:Range("A1"):Value = "ERRORES - PRECIOS"
    chWorkSheet:Range("A2"):Value = "CODIGO"
    chWorkSheet:Columns("A"):NumberFormat = "@"
    chWorkSheet:Range("B2"):Value = "DESCRIPCION"
    chWorkSheet:Range("C2"):Value = "ERROR".
ASSIGN
    t-Row = 2.
FOR EACH E-MATG:
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = E-MATG.codmat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = E-MATG.desmat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = E-MATG.Libre_c01.
END.
chExcelApplication:VISIBLE = TRUE.
/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar-Precios-Conti W-Win 
PROCEDURE Grabar-Precios-Conti :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE 'Procedemos a grabar los precios?'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.

IF TOGGLE-Borrar = YES THEN DO:
    FOR EACH ListaTerceros WHERE ListaTerceros.codcia = s-codcia
        ON STOP UNDO, RETURN ON ERROR UNDO, RETURN:
        DELETE ListaTerceros.
    END.
END.
FOR EACH T-MATG ON STOP UNDO, RETURN ON ERROR UNDO, RETURN:
    FIND ListaTerceros OF T-MATG EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR AND LOCKED(ListaTerceros) THEN DO:
        CREATE E-MATG.
        BUFFER-COPY T-MATG 
            TO E-MATG
            ASSIGN E-MATG.Libre_c01 = "Bloqueado por otro usuario".
        DELETE T-MATG.
        NEXT.
    END.
    IF NOT AVAILABLE ListaTerceros THEN CREATE ListaTerceros.
    ASSIGN
        ListaTerceros.CodCia = T-MATG.CodCia
        ListaTerceros.CodMat = T-MATG.CodMat
        ListaTerceros.MonVta = T-MATG.MonVta
        ListaTerceros.TpoCmb = T-MATG.TpoCmb
        ListaTerceros.PreOfi[1] = T-MATG.PreVta[1]
        ListaTerceros.PreOfi[2] = T-MATG.Prevta[2]
        ListaTerceros.PreOfi[3] = T-MATG.Prevta[3].
    /* REGRABAMOS EN LA MONEDA DE VENTA */
    IF ListaTerceros.MonVta = 2 THEN DO:
        ASSIGN
            ListaTerceros.PreOfi[1] = ListaTerceros.PreOfi[1] / T-MATG.TpoCmb
            ListaTerceros.PreOfi[2] = ListaTerceros.PreOfi[2] / T-MATG.TpoCmb
            ListaTerceros.PreOfi[3] = ListaTerceros.PreOfi[3] / T-MATG.TpoCmb.
    END.
    ASSIGN
        ListaTerceros.Usuario = S-USER-ID
        ListaTerceros.FchAct  = TODAY.
END.
EMPTY TEMP-TABLE T-MATG.

RUN dispatch IN h_bcagarlistaterceros ('open-query':U).

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
  {src/adm/template/snd-list.i "T-MATG"}

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

