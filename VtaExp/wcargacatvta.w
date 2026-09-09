&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE C-CatVta LIKE AlmCatVtaC.
DEFINE NEW SHARED TEMP-TABLE D-CatVta LIKE AlmCatVtaD.
DEFINE TEMP-TABLE T-CatVtaD NO-UNDO LIKE AlmCatVtaD.



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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEFINE TEMP-TABLE tt-paginas
    FIELDS tt-nropag AS INT
    FIELDS tt-despag AS CHAR FORMAT 'x(80)'
    INDEX idx01 IS PRIMARY tt-nropag.


RUN Carga-Formato.

DEF VAR pError AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-9

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-CatVtaD

/* Definitions for BROWSE BROWSE-9                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-9 T-CatVtaD.Libre_c01 ~
T-CatVtaD.NroPag T-CatVtaD.NroSec T-CatVtaD.codmat T-CatVtaD.DesMat ~
T-CatVtaD.Libre_d01 T-CatVtaD.Libre_d02 T-CatVtaD.Libre_c02 ~
T-CatVtaD.Libre_c04 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-9 
&Scoped-define QUERY-STRING-BROWSE-9 FOR EACH T-CatVtaD NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-9 OPEN QUERY BROWSE-9 FOR EACH T-CatVtaD NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-9 T-CatVtaD
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-9 T-CatVtaD


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-9}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 COMBO-BOX-Division FILL-IN-CodPro ~
BUTTON-1 BUTTON-3 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Division FILL-IN-CodPro ~
FILL-IN-NomPro FILL-IN-Archivo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_bcargacatvtac AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bcargacatvtad AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 7 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 4 BY .77.

DEFINE BUTTON BUTTON-3 
     LABEL "IMPORTAR EXCEL" 
     SIZE 18 BY 1.12.

DEFINE BUTTON BUTTON-4 
     LABEL "GRABAR EN TABLAS" 
     SIZE 18 BY 1.12.

DEFINE VARIABLE COMBO-BOX-Division AS CHARACTER FORMAT "X(256)":U 
     LABEL "Eventos" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 55 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Archivo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Archivo Excel" 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81
     BGCOLOR 12 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPro AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 95 BY 5.77
     BGCOLOR 15 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-9 FOR 
      T-CatVtaD SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-9 W-Win _STRUCTURED
  QUERY BROWSE-9 NO-LOCK DISPLAY
      T-CatVtaD.Libre_c01 COLUMN-LABEL "1" FORMAT "x(3)":U WIDTH 2.43
      T-CatVtaD.NroPag COLUMN-LABEL "A     !Pagina" FORMAT "9999":U
      T-CatVtaD.NroSec COLUMN-LABEL "B         !Nro.Sec" FORMAT "9999":U
      T-CatVtaD.codmat COLUMN-LABEL "C       !Articulo" FORMAT "X(6)":U
            WIDTH 11
      T-CatVtaD.DesMat COLUMN-LABEL "D             !Descripción" FORMAT "X(45)":U
            WIDTH 21.29
      T-CatVtaD.Libre_d01 COLUMN-LABEL "E      !Mín de Venta" FORMAT ">>>,>>9.99":U
            WIDTH 9.43
      T-CatVtaD.Libre_d02 COLUMN-LABEL "F     !Empaque" FORMAT ">>>,>>9.99":U
            WIDTH 6.72
      T-CatVtaD.Libre_c02 COLUMN-LABEL "G                  !GodGrupo" FORMAT "x(60)":U
            WIDTH 7.43
      T-CatVtaD.Libre_c04 COLUMN-LABEL "H                 !Descripcion Grupo" FORMAT "x(60)":U
            WIDTH 16.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 92.86 BY 4.23
         FONT 4
         TITLE "FORMATO DEL ARCHIVO EXCEL" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Division AT ROW 1.19 COL 10 COLON-ALIGNED WIDGET-ID 32
     FILL-IN-CodPro AT ROW 2.15 COL 10.14 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-NomPro AT ROW 2.15 COL 22.14 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-Archivo AT ROW 3.12 COL 10.14 COLON-ALIGNED WIDGET-ID 4
     BUTTON-1 AT ROW 3.12 COL 68.14 WIDGET-ID 6
     BUTTON-3 AT ROW 5.62 COL 72.72 WIDGET-ID 16
     BUTTON-4 AT ROW 6.77 COL 72.72 WIDGET-ID 18
     BtnDone AT ROW 7.92 COL 72.72 WIDGET-ID 20
     BROWSE-9 AT ROW 18.85 COL 3.14 WIDGET-ID 200
     "LA PRIMERA LINEA SOLO DEBE CONTENER LOS ENCABEZADOS DE LOS CAMPOS" VIEW-AS TEXT
          SIZE 61 BY .5 AT ROW 23.38 COL 4.14 WIDGET-ID 10
          BGCOLOR 1 FGCOLOR 15 
     RECT-2 AT ROW 18.46 COL 2 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 108.29 BY 23.69
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 3
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: C-CatVta T "NEW SHARED" ? INTEGRAL AlmCatVtaC
      TABLE: D-CatVta T "NEW SHARED" ? INTEGRAL AlmCatVtaD
      TABLE: T-CatVtaD T "?" NO-UNDO INTEGRAL AlmCatVtaD
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CARGAR CATALOGO DEL PROVEEDOR"
         HEIGHT             = 23.69
         WIDTH              = 108.29
         MAX-HEIGHT         = 24.77
         MAX-WIDTH          = 114.57
         VIRTUAL-HEIGHT     = 24.77
         VIRTUAL-WIDTH      = 114.57
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
/* BROWSE-TAB BROWSE-9 BtnDone F-Main */
/* SETTINGS FOR BROWSE BROWSE-9 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Archivo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-9
/* Query rebuild information for BROWSE BROWSE-9
     _TblList          = "Temp-Tables.T-CatVtaD"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.T-CatVtaD.Libre_c01
"T-CatVtaD.Libre_c01" "1" "x(3)" "character" ? ? ? ? ? ? no ? no no "2.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-CatVtaD.NroPag
"T-CatVtaD.NroPag" "A     !Pagina" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-CatVtaD.NroSec
"T-CatVtaD.NroSec" "B         !Nro.Sec" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-CatVtaD.codmat
"T-CatVtaD.codmat" "C       !Articulo" ? "character" ? ? ? ? ? ? no ? no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-CatVtaD.DesMat
"T-CatVtaD.DesMat" "D             !Descripción" ? "character" ? ? ? ? ? ? no ? no no "21.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-CatVtaD.Libre_d01
"T-CatVtaD.Libre_d01" "E      !Mín de Venta" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-CatVtaD.Libre_d02
"T-CatVtaD.Libre_d02" "F     !Empaque" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "6.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-CatVtaD.Libre_c02
"T-CatVtaD.Libre_c02" "G                  !GodGrupo" ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-CatVtaD.Libre_c04
"T-CatVtaD.Libre_c04" "H                 !Descripcion Grupo" ? "character" ? ? ? ? ? ? no ? no no "16.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-9 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CARGAR CATALOGO DEL PROVEEDOR */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CARGAR CATALOGO DEL PROVEEDOR */
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:
    DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.
    DEFINE VARIABLE FILL-IN-file AS CHAR NO-UNDO.

    SYSTEM-DIALOG GET-FILE FILL-IN-file
        FILTERS "Archivos Excel (*.xls)" "*.xls", "Todos (*.*)" "*.*"
        TITLE "Archivo(s) de Carga..."
        MUST-EXIST
        RETURN-TO-START-DIR 
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = FALSE THEN RETURN.
    FILL-IN-Archivo:SCREEN-VALUE = FILL-IN-file.
    ASSIGN FILL-IN-Archivo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* IMPORTAR EXCEL */
DO:
    ASSIGN
        FILL-IN-Archivo FILL-IN-CodPro COMBO-BOX-Division.
    FIND gn-prov WHERE codcia = pv-codcia
        AND codpro = FILL-IN-CodPro
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-prov THEN DO:
        MESSAGE 'Proveedor NO registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF FILL-IN-Archivo = '' OR SEARCH(FILL-IN-Archivo) = ? THEN DO:
        MESSAGE 'NO se encontró el archivo Excel'
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    RUN Carga-Temporal.
    /*RUN Carga-Temporal2.*/
    COMBO-BOX-Division:SENSITIVE = NO.
    FILL-IN-CodPro:SENSITIVE = NO.
    BUTTON-1:SENSITIVE = NO.
    BUTTON-3:SENSITIVE = NO.
    /*BUTTON-4:SENSITIVE = YES.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* GRABAR EN TABLAS */
DO:

    SESSION:SET-WAIT-STATE("GENERAL").

    RUN Carga-Tablas.

    SESSION:SET-WAIT-STATE("").

    IF RETURN-VALUE = 'ADM-ERROR' THEN MESSAGE 'NO grabó la información' SKIP pError VIEW-AS ALERT-BOX ERROR.
    COMBO-BOX-Division:SENSITIVE = YES.
    FILL-IN-CodPro:SENSITIVE = YES.
    BUTTON-1:SENSITIVE = YES.
    BUTTON-3:SENSITIVE = YES.
    BUTTON-4:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Division W-Win
ON VALUE-CHANGED OF COMBO-BOX-Division IN FRAME F-Main /* Eventos */
DO:
  ASSIGN {&self-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPro W-Win
ON LEAVE OF FILL-IN-CodPro IN FRAME F-Main /* Proveedor */
DO:
  FIND gn-prov WHERE codcia = pv-codcia
      AND codpro = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN FILL-IN-NomPro:SCREEN-VALUE = nompro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-9
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
             INPUT  'aplic/vtaexp/bcargacatvtac.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bcargacatvtac ).
       RUN set-position IN h_bcargacatvtac ( 4.38 , 3.00 ) NO-ERROR.
       RUN set-size IN h_bcargacatvtac ( 6.69 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtaexp/bcargacatvtad.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bcargacatvtad ).
       RUN set-position IN h_bcargacatvtad ( 11.31 , 1.43 ) NO-ERROR.
       RUN set-size IN h_bcargacatvtad ( 6.69 , 107.00 ) NO-ERROR.

       /* Links to SmartBrowser h_bcargacatvtad. */
       RUN add-link IN adm-broker-hdl ( h_bcargacatvtac , 'Record':U , h_bcargacatvtad ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_bcargacatvtac ,
             BUTTON-1:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_bcargacatvtad ,
             BtnDone:HANDLE IN FRAME F-Main , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Formato W-Win 
PROCEDURE Carga-Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

CREATE T-CatVtaD.
ASSIGN
    T-CatVtaD.codmat = '000001'
    T-CatVtaD.DesMat = 'PRODUCTO 1'
    T-CatVtaD.NroPag = 0001
    T-CatVtaD.NroSec = 0001
    T-CatVtaD.UndBas = "UNI"
    T-CatVtaD.Libre_c01 = "2".
CREATE T-CatVtaD.
ASSIGN
    T-CatVtaD.codmat = '000002'
    T-CatVtaD.DesMat = 'PRODUCTO 2'
    T-CatVtaD.NroPag = 0001
    T-CatVtaD.NroSec = 0002
    T-CatVtaD.UndBas = "UNI"
    T-CatVtaD.Libre_c01 = "3".
CREATE T-CatVtaD.
ASSIGN
    T-CatVtaD.codmat = '000003'
    T-CatVtaD.DesMat = 'PRODUCTO 3'
    T-CatVtaD.NroPag = 0002
    T-CatVtaD.NroSec = 0001
    T-CatVtaD.UndBas = "UNI"
    T-CatVtaD.Libre_c01 = "4".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Tablas W-Win 
PROCEDURE Carga-Tablas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR CuentaError AS INT NO-UNDO.

pError = ''.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Es su primera vez? */
    FIND VtaCatVenta WHERE VtaCatVenta.CodCia = s-codcia
        AND VtaCatVenta.CodDiv = COMBO-BOX-Division 
        AND VtaCatVenta.CodPro = FILL-IN-CodPro
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaCatVenta THEN DO:
        /* BORRAR TODO LO ANTERIOR */
        /* Borramos cabecera y detalles */
        FIND VtaCatVenta WHERE VtaCatVenta.CodCia = s-codcia
            AND VtaCatVenta.CodDiv = COMBO-BOX-Division 
            AND VtaCatVenta.CodPro = FILL-IN-CodPro
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE VtaCatVenta THEN DO:
            RELEASE VtaCatVenta.
            {lib/mensaje-de-error.i &CuentaError="CuentaError" &MensajeError="pError"}
            UNDO, RETURN 'ADM-ERROR'.
        END.
        DELETE VtaCatVenta.
    END.
    FOR EACH AlmCatVtaC EXCLUSIVE-LOCK WHERE AlmCatVtaC.CodCia = s-codcia
        AND AlmCatVtaC.CodDiv = COMBO-BOX-Division
        AND AlmCatVtaC.CodPro = FILL-IN-CodPro
        ON ERROR UNDO, THROW:
        FOR EACH AlmCatVtaD OF AlmCatVtaC EXCLUSIVE-LOCK,
            FIRST Almmmatg OF AlmCatVtaD EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
            DELETE AlmCatVtaD.
            ASSIGN
                Almmmatg.StkMax = 0             /* Mínimo de ventas Expo */
                Almmmatg.Libre_d03 = 0.         /* Empaque Expo */
        END.
        DELETE AlmCatVtaC.
    END.
    RELEASE Almmmatg.
    /* Generamos nuevamente cabecera y detalle */
    CREATE VtaCatVenta.
    ASSIGN
        VtaCatVenta.CodCia = s-codcia
        VtaCatVenta.CodDiv = COMBO-BOX-Division
        VtaCatVenta.CodPro = FILL-IN-CodPro
        VtaCatVenta.Libre_c01 = s-User-Id + '|' + STRING(NOW).
    FOR EACH C-CatVta EXCLUSIVE-LOCK:
        CREATE AlmCatVtaC.
        BUFFER-COPY C-CatVta TO AlmCatVtaC.
        DELETE C-CatVta.
    END.
    FOR EACH D-CatVta EXCLUSIVE-LOCK,
        FIRST Almmmatg OF D-CatVta EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
        CREATE AlmCatVtaD.
        BUFFER-COPY D-CatVta 
            TO AlmCatVtaD
            ASSIGN AlmCatVtaD.CanEmp =  D-CatVta.Libre_d03.     /* OJO */
        /* Actualizamos el Catalogo */
        ASSIGN
            Almmmatg.StkMax =  AlmCatVtaD.Libre_d02 
            Almmmatg.Libre_d03 = AlmCatVtaD.Libre_d03.
        DELETE D-CatVta.
    END.
    RELEASE Almmmatg.
    RELEASE AlmCatVtaC NO-ERROR.
    RELEASE AlmCatVtaD NO-ERROR.
END.
CLEAR FRAME {&frame-name} ALL NO-PAUSE.
RUN dispatch IN h_bcargacatvtac ('open-query':U).
RUN dispatch IN h_bcargacatvtad ('open-query':U).

MESSAGE 'Grabación en Tablas terminada' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-tablas2 W-Win 
PROCEDURE carga-tablas2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
Cesar Iman Namuche - 17Dic2012
------------------------------------------------------------------------------*/

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


/* PRIMERO BORRAMOS TODO EL DETALLE */
EMPTY TEMP-TABLE C-CatVta.
EMPTY TEMP-TABLE D-CatVta.
EMPTY TEMP-TABLE tt-paginas.

/* SEGUNDO IMPORTAMOS DESDE EL EXCEL */
DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chWorkbook AS COM-HANDLE.
DEFINE VARIABLE chWorksheet AS COM-HANDLE.

DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.
DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
DEFINE VARIABLE t-Row           AS INTEGER INIT 7.

DEFINE VARIABLE i-Column        AS INTEGER     NO-UNDO.

DEFINE VAR iCodGrupo AS INT.
DEFINE VAR iDesGrupo AS INT.

CREATE "Excel.Application" chExcelApplication.

chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

t-Row = 1.     /* Saltamos el encabezado de los campos */

SESSION:SET-WAIT-STATE('GENERAL').

REPEAT:
    ASSIGN
        t-column = 0
        t-Row    = t-Row + 1.
    /* PAGINA */
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
    ASSIGN
        iValue = INTEGER(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN NEXT.


    CREATE D-CatVta.
    ASSIGN
        D-CatVta.NroPag = iValue.

    /* Descripcion de Pagina  */
    FIND FIRST tt-paginas WHERE tt-paginas.tt-nropag = iValue  NO-ERROR.
    IF NOT AVAILABLE tt-paginas THEN DO:
        CREATE tt-paginas.
            ASSIGN tt-paginas.tt-nropag = iValue
                    tt-paginas.tt-despag = "Pagina Nro. " + STRING(iValue,"99999").
    END.

    /* SECUENCIA */
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        iValue = INTEGER(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN NEXT.
    ASSIGN
        D-CatVta.NroSec = iValue.
    /* PRODUCTO */
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        iValue = INTEGER(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN NEXT.
    ASSIGN
        D-CatVta.CodMat = STRING(iValue, '999999').
    /* DESCRIPCION */
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        D-CatVta.DesMat = cValue.
    /* MINIMO DE VENTAS */
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        dValue = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN D-CatVta.Libre_d02 = 0.
    ELSE D-CatVta.Libre_d02 = dValue.
    /* MULTIPLOS */
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        dValue = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN D-CatVta.Libre_d03 = dValue.
    ELSE D-CatVta.Libre_d03 = dValue.

    /* CodGrupo */
     t-column = t-column + 1.
     cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
     /* Indica que es Nulo o esta Vacio*/
    IF TRUE <> (cValue > "") THEN iCodGrupo = iCodGrupo + 1.

     ASSIGN
         cValue = TRIM(cValue)
         NO-ERROR.
     IF ERROR-STATUS:ERROR THEN D-CatVta.Libre_c04 = "CodErrado : " + cValue.
     ELSE D-CatVta.Libre_c04 = cValue.

    /* Descripcion de Grupo */
      t-column = t-column + 1.
      cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
     /* Indica que es Nulo o esta Vacio*/
    IF TRUE <> (cValue > "") THEN iDesGrupo = iDesGrupo + 1.

      ASSIGN
          cValue = TRIM(cValue)
          NO-ERROR.
      IF ERROR-STATUS:ERROR THEN D-CatVta.Libre_c05 = "CodErrado : " + cValue.
      ELSE D-CatVta.Libre_c05 = cValue.

END.
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 


/* Consistencias */

FOR EACH D-CatVta:
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = D-CatVta.codmat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        DELETE D-CatVta.        
        NEXT.
    END.
    IF D-CatVta.DesMat = '' OR D-CatVta.DesMat = ? THEN D-CatVta.DesMat = Almmmatg.DesMat.
    IF D-CatVta.UndBas = '' OR D-CatVta.UndBas = ? THEN D-CatVta.UndBas = Almmmatg.UndStk.
    ASSIGN
        D-CatVta.CodCia = s-codcia
        D-CatVta.CodDiv = COMBO-BOX-Division /*s-coddiv*/
        D-CatVta.CodPro = FILL-IN-CodPro.
END.
/* Cargamos cabeceras */
FOR EACH D-CatVta BREAK BY D-CatVta.NroPag:
    IF FIRST-OF(D-CatVta.NroPag) THEN DO:
        CREATE C-CatVta.
        ASSIGN
            C-CatVta.CodCia = s-codcia
            C-CatVta.CodDiv = COMBO-BOX-Division /*s-coddiv*/
            C-CatVta.CodPro = FILL-IN-CodPro
            C-CatVta.NroPag = D-CatVta.NroPag
            /*C-CatVta.DesPag = "Pagina " + STRING(C-CatVta.NroPag, "99")*/.
        FIND FIRST tt-paginas WHERE tt-nropag =  D-CatVta.NroPag NO-ERROR.
        IF AVAILABLE tt-paginas THEN DO:
            ASSIGN C-CatVta.DesPag = tt-paginas.tt-despag.
        END.
    END.
END.
RUN dispatch IN h_bcargacatvtac ('open-query':U).
RUN dispatch IN h_bcargacatvtad ('open-query':U).

SESSION:SET-WAIT-STATE('').

IF iCodGrupo <> 0 OR iDesGrupo <> 0 THEN DO:
    MESSAGE "Algunos Articulos NO tienen CODIGOGRUPO y/o DESCRIPCIO DE GRUPO".
END.

MESSAGE 'Importación terminada OK.' VIEW-AS ALERT-BOX INFORMATION.

BUTTON-4:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal2 W-Win 
PROCEDURE carga-temporal2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
  Cesar Iman Namuche - 17Dic2012
------------------------------------------------------------------------------*/
DEFINE VAR lListaOk AS LOGICAL.
DEFINE VAR lSecOk AS LOGICAL.
DEFINE VAR lSecError AS INT.
DEFINE VAR lPagAnt AS INT.
DEFINE VAR lPagAct AS INT.
DEFINE VAR lSecAnt AS INT.

/* PRIMERO BORRAMOS TODO EL DETALLE */
EMPTY TEMP-TABLE C-CatVta.
EMPTY TEMP-TABLE D-CatVta.

/* SEGUNDO IMPORTAMOS DESDE EL EXCEL */
DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chWorkbook AS COM-HANDLE.
DEFINE VARIABLE chWorksheet AS COM-HANDLE.

DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.
DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
DEFINE VARIABLE t-Row           AS INTEGER INIT 11.

DEFINE VARIABLE i-Column        AS INTEGER     NO-UNDO.

CREATE "Excel.Application" chExcelApplication.

chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

t-Row = 10.     /* Saltamos el encabezado de los campos */
lSecOk = YES.
lPagAnt = 0.
lSecAnt = 0.
REPEAT:
    ASSIGN
        t-column = 0
        t-Row    = t-Row + 1.
    /*
    /* PAGINA */
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
    ASSIGN
        iValue = INTEGER(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN NEXT.
    CREATE D-CatVta.
    ASSIGN
        D-CatVta.NroPag = iValue.       
    */
    
    /* Pagina  */ 
    cValue = chWorkSheet:Cells(t-Row, 11):VALUE.
    IF cValue = "" OR cValue = ? THEN DO:
        iValue = 001.
    END.
    ELSE DO:    
        ASSIGN
            iValue = INTEGER(cValue)
            NO-ERROR.
    END.
    lPagAct = iValue.

    /* SECUENCIA */
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, 1):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */
    ASSIGN
        iValue = INTEGER(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN NEXT.


    CREATE D-CatVta.    
    ASSIGN
       D-CatVta.NroPag = lPagAct.
    

    ASSIGN
        D-CatVta.NroSec = iValue.
    
    /* Verifico que el correlativo sea el correcto x pagina */
    IF lPagAnt <> lPagAct THEN DO:
        /* Reseteo valores */
        lPagAnt = lPagAct.
        lSecAnt = 1.
    END.
    ELSE lSecAnt = lSecAnt +  1.

/*    IF (t-row - 10) <> iValue THEN DO:*/
    IF lSecAnt <> iValue THEN DO:
        lSecOk = NO.
    END.

    /* PRODUCTO */
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row,10):VALUE.
    ASSIGN
        iValue = INTEGER(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN NEXT.
    ASSIGN
        D-CatVta.CodMat = STRING(iValue, '999999').
       
    /* DESCRIPCION */
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, 4):VALUE.
    ASSIGN
        D-CatVta.DesMat = cValue.

    /* SubTitulo */
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, 2):VALUE.
    IF cValue = "" OR cValue = ? THEN cValue = ''.
    ASSIGN
        D-CatVta.libre_c02 = cValue.

    /* UNIDAD */
     t-column = t-column + 1.                           
     cValue = chWorkSheet:Cells(t-Row, 6):VALUE. 
     IF cValue = "" OR cValue = ? THEN cValue = "UNI".
     ASSIGN                                             
         D-CatVta.UndBas = cValue.                      

    /* EMPAQUE */
/*     t-column = t-column + 1.                           */
/*     cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE. */
/*     ASSIGN                                             */
/*         dValue = DECIMAL(cValue)                       */
/*         NO-ERROR.                                      */
/*     IF ERROR-STATUS:ERROR THEN NEXT.                   */
/*     ASSIGN                                             */
/*         D-CatVta.CanEmp = dValue.                      */

    /* MINIMO DE VENTAS */
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, 7):VALUE.
    IF cValue = "" OR cValue = ? THEN cValue = "1.00".
    ASSIGN
        dValue = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN D-CatVta.Libre_d02 = 0.
    ELSE D-CatVta.Libre_d02 = dValue.

    /* MULTIPLOS */
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, 8):VALUE.
    IF cValue = "" OR cValue = ? THEN cValue = "1.00".
    ASSIGN
        dValue = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN D-CatVta.Libre_d03 = dValue.
    ELSE D-CatVta.Libre_d03 = dValue.
END.
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

IF lSecOk = NO THEN DO:
    MESSAGE 'El correlativo NO ESTA CORRECTO, proceso CANCELADO.' VIEW-AS ALERT-BOX INFORMATION.
    DO WITH FRAME {&FRAME-NAME}:
     BUTTON-4:ENABLED = NO.
     BUTTON-4:SENSITIVE = NO.
    END.
    RETURN "ADM-ERROR".
END.

/* Consistencias */
lListaOk = YES.
FOR EACH D-CatVta:
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = D-CatVta.codmat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        lSecError =  D-CatVta.NroSec.
        DELETE D-CatVta.        
        lListaOk = NO.
        NEXT.
    END.
    IF D-CatVta.DesMat = '' OR D-CatVta.DesMat = ? THEN D-CatVta.DesMat = Almmmatg.DesMat.
    IF D-CatVta.UndBas = '' OR D-CatVta.UndBas = ? THEN D-CatVta.UndBas = Almmmatg.UndStk.
    ASSIGN
        D-CatVta.CodCia = s-codcia
        D-CatVta.CodDiv = s-coddiv
        D-CatVta.CodPro = FILL-IN-CodPro.
END.
/* Cargamos cabeceras */
FOR EACH D-CatVta BREAK BY D-CatVta.NroPag:
    IF FIRST-OF(D-CatVta.NroPag) THEN DO:
        CREATE C-CatVta.
        ASSIGN
            C-CatVta.CodCia = s-codcia
            C-CatVta.CodDiv = s-coddiv
            C-CatVta.CodPro = FILL-IN-CodPro
            C-CatVta.NroPag = D-CatVta.NroPag
            C-CatVta.DesPag = "Pagina " + STRING(C-CatVta.NroPag, "99").
    END.
END.
RUN dispatch IN h_bcargacatvtac ('open-query':U).
RUN dispatch IN h_bcargacatvtad ('open-query':U).

IF lListaOk = NO THEN DO:
    MESSAGE 'Existen Articulos en la LISTA que no estan en el MAESTRO - Sec' lSecError VIEW-AS ALERT-BOX INFORMATION.
    BUTTON-4:SENSITIVE = NO.
    BUTTON-4:ENABLED = NO.
END.
ELSE DO:
    MESSAGE 'Importación terminada OK.' VIEW-AS ALERT-BOX INFORMATION.
    BUTTON-4:SENSITIVE = YES.
    BUTTON-4:ENABLED = YES.

END.


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
  DISPLAY COMBO-BOX-Division FILL-IN-CodPro FILL-IN-NomPro FILL-IN-Archivo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-2 COMBO-BOX-Division FILL-IN-CodPro BUTTON-1 BUTTON-3 BtnDone 
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
      COMBO-BOX-Division:DELETE(1).
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia 
          AND GN-DIVI.VentaMayorista = 2
          AND GN-DIVI.CanalVenta = 'FER'
          /*AND LOOKUP(GN-DIVI.Campo-Char[1], 'D,A') > 0*/
          AND GN-DIVI.Campo-Log[1] = NO
          BREAK BY gn-divi.codcia:
          COMBO-BOX-Division:ADD-LAST( GN-DIVI.CodDiv + ' - ' + GN-DIVI.DesDiv, GN-DIVI.CodDiv ).
/*           IF FIRST-OF(gn-divi.codcia) THEN COMBO-BOX-Division = gn-divi.coddiv. */
      END.
      COMBO-BOX-Division = s-coddiv.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
PROCEDURE recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.

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
  {src/adm/template/snd-list.i "T-CatVtaD"}

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

