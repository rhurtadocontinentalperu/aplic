&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-Almcmov NO-UNDO LIKE Almcmov.



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
DEFINE SHARED VAR s-codalm AS CHAR.
DEFINE SHARED VAR s-CodDiv AS CHAR.
DEFINE SHARED VAR s-userid AS CHAR.

/*s-codalm = '11'.*/

DEFINE VAR x-tipmov AS CHAR INIT '9'.
DEFINE VAR x-codmov AS INT INIT 99.
DEFINE VAR x-nroser AS INT INIT 999.
DEFINE VAR x-nrodoc AS INT INIT 999999.

DEFINE VAR x-nrootr AS CHAR INIT "".
DEFINE VAR x-cliente AS CHAR INIT "".

DEFINE VAR x-sele AS CHAR INIT ''.

DEF VAR n_cols_browse AS INT NO-UNDO.
DEF VAR celda_br AS WIDGET-HANDLE EXTENT 100 NO-UNDO.

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
&Scoped-define INTERNAL-TABLES Almdmov Almmmatg tt-Almcmov

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 Almdmov.codmat Almmmatg.DesMat ~
Almdmov.CodUnd Almdmov.CanDes 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH Almdmov ~
      WHERE almdmov.codcia = s-codcia and  ~
almdmov.codalm = s-codalm and  ~
almdmov.tipmov = x-tipmov and  ~
almdmov.codmov = x-codmov and  ~
almdmov.nroser = x-nroser and ~
almdmov.nrodoc = x-nrodoc NO-LOCK, ~
      EACH Almmmatg OF Almdmov  NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH Almdmov ~
      WHERE almdmov.codcia = s-codcia and  ~
almdmov.codalm = s-codalm and  ~
almdmov.tipmov = x-tipmov and  ~
almdmov.codmov = x-codmov and  ~
almdmov.nroser = x-nroser and ~
almdmov.nrodoc = x-nrodoc NO-LOCK, ~
      EACH Almmmatg OF Almdmov  NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 Almdmov Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 Almdmov
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-4 Almmmatg


/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 tt-Almcmov.CodAlm tt-Almcmov.NroSer ~
tt-Almcmov.NroDoc tt-Almcmov.FchDoc tt-Almcmov.CodRef tt-Almcmov.NroRef ~
tt-Almcmov.CodCli tt-Almcmov.NomRef tt-Almcmov.Observ 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7 
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH tt-Almcmov ~
      WHERE x-sele = '' or (x-sele = 'X' and tt-almcmov.flgsit = 'X') NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY BROWSE-7 FOR EACH tt-Almcmov ~
      WHERE x-sele = '' or (x-sele = 'X' and tt-almcmov.flgsit = 'X') NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 tt-Almcmov
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 tt-Almcmov


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-4}~
    ~{&OPEN-QUERY-BROWSE-7}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-65 RECT-66 BUTTON-4 txtNroOrden ~
txtCliente rsOrdenes BROWSE-7 BROWSE-4 BUTTON-1 BUTTON-2 BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS txtNroOrden txtCliente rsOrdenes f-CodAge ~
f-NomTra f-RucAge f-NroLicencia F-cert-inscripcion f-carreta f-Placa ~
f-Marca f-Traslado f-Chofer 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Todos" 
     SIZE 10 BY .96.

DEFINE BUTTON BUTTON-2 
     LABEL "Seleccionados" 
     SIZE 15.29 BY .96.

DEFINE BUTTON BUTTON-3 
     LABEL "TRANSPORTISTA" 
     SIZE 17.72 BY 1.12.

DEFINE BUTTON BUTTON-4 
     LABEL "Refrescar" 
     SIZE 12.72 BY 1.12.

DEFINE BUTTON BUTTON-5 
     LABEL "Excel" 
     SIZE 12 BY 1.12.

DEFINE VARIABLE f-carreta AS CHARACTER FORMAT "X(10)":U 
     LABEL "Carreta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE F-cert-inscripcion AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cert.Inscripcion" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-Chofer AS CHARACTER FORMAT "X(50)":U 
     LABEL "Chofer" 
     VIEW-AS FILL-IN 
     SIZE 28 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-CodAge AS CHARACTER FORMAT "X(11)":U 
     LABEL "Transportista" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-Marca AS CHARACTER FORMAT "X(20)":U 
     LABEL "Vehículo Marca" 
     VIEW-AS FILL-IN 
     SIZE 24 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-NomTra AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.86 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-NroLicencia AS CHARACTER FORMAT "X(10)":U 
     LABEL "Nº de Licencia" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-Placa AS CHARACTER FORMAT "X(10)":U 
     LABEL "Nº Placa" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-RucAge AS CHARACTER FORMAT "x(11)":U 
     LABEL "RUC" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE f-Traslado AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Traslado" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE txtCliente AS CHARACTER FORMAT "X(80)":U 
     LABEL "Cliente (que contenga)" 
     VIEW-AS FILL-IN 
     SIZE 36.57 BY 1 NO-UNDO.

DEFINE VARIABLE txtNroOrden AS CHARACTER FORMAT "X(12)":U 
     LABEL "Orden" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY 1 NO-UNDO.

DEFINE VARIABLE rsOrdenes AS CHARACTER INITIAL "*" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", "*",
"Transferencia.", "OTR",
"Despacho", "O/D"
     SIZE 39.57 BY .96 NO-UNDO.

DEFINE RECTANGLE RECT-65
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 55 BY 8.69.

DEFINE RECTANGLE RECT-66
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29 BY 1.73.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      Almdmov, 
      Almmmatg SCROLLING.

DEFINE QUERY BROWSE-7 FOR 
      tt-Almcmov SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      Almdmov.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U WIDTH 10.43
      Almmmatg.DesMat FORMAT "X(45)":U WIDTH 38.86
      Almdmov.CodUnd FORMAT "X(10)":U
      Almdmov.CanDes FORMAT "(ZZZ,ZZZ,ZZ9.9999)":U WIDTH 12.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 77 BY 10.77
         TITLE "Detalle".

DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 W-Win _STRUCTURED
  QUERY BROWSE-7 NO-LOCK DISPLAY
      tt-Almcmov.CodAlm COLUMN-LABEL "Alm" FORMAT "x(5)":U WIDTH 4.43
      tt-Almcmov.NroSer COLUMN-LABEL "Serie" FORMAT "999":U WIDTH 6.43
      tt-Almcmov.NroDoc COLUMN-LABEL "Nro Guia" FORMAT "999999999":U
            WIDTH 11.43
      tt-Almcmov.FchDoc COLUMN-LABEL "Fecha" FORMAT "99/99/9999":U
            WIDTH 10.43
      tt-Almcmov.CodRef COLUMN-LABEL "Ref" FORMAT "x(11)":U WIDTH 7.72
      tt-Almcmov.NroRef COLUMN-LABEL "No.Ref" FORMAT "X(9)":U WIDTH 12.29
      tt-Almcmov.CodCli COLUMN-LABEL "Destino" FORMAT "x(11)":U
      tt-Almcmov.NomRef COLUMN-LABEL "Destino Nombre" FORMAT "x(50)":U
            WIDTH 37.72
      tt-Almcmov.Observ FORMAT "X(50)":U WIDTH 22.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 133.14 BY 10.27 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-4 AT ROW 1.38 COL 123 WIDGET-ID 62
     txtNroOrden AT ROW 1.42 COL 47 COLON-ALIGNED WIDGET-ID 64
     txtCliente AT ROW 1.42 COL 81.86 COLON-ALIGNED WIDGET-ID 66
     rsOrdenes AT ROW 1.5 COL 2.43 NO-LABEL WIDGET-ID 70
     BROWSE-7 AT ROW 3.08 COL 2.43 WIDGET-ID 400
     BROWSE-4 AT ROW 13.46 COL 3 WIDGET-ID 300
     BUTTON-5 AT ROW 13.69 COL 117 WIDGET-ID 74
     BUTTON-1 AT ROW 13.92 COL 82 WIDGET-ID 2
     BUTTON-2 AT ROW 13.92 COL 93 WIDGET-ID 4
     f-CodAge AT ROW 15.96 COL 94.57 COLON-ALIGNED WIDGET-ID 40
     f-NomTra AT ROW 16.81 COL 94.72 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     f-RucAge AT ROW 17.77 COL 94.57 COLON-ALIGNED WIDGET-ID 42
     BUTTON-3 AT ROW 18.08 COL 115 WIDGET-ID 6
     f-NroLicencia AT ROW 18.62 COL 94.57 COLON-ALIGNED WIDGET-ID 54
     F-cert-inscripcion AT ROW 19.54 COL 94.72 COLON-ALIGNED WIDGET-ID 36
     f-carreta AT ROW 20.35 COL 112.57 COLON-ALIGNED WIDGET-ID 68
     f-Placa AT ROW 20.42 COL 94.86 COLON-ALIGNED WIDGET-ID 46
     f-Marca AT ROW 21.35 COL 94.86 COLON-ALIGNED WIDGET-ID 48
     f-Traslado AT ROW 22.27 COL 94.86 COLON-ALIGNED WIDGET-ID 50
     f-Chofer AT ROW 23.12 COL 94.86 COLON-ALIGNED WIDGET-ID 56
     " Mostrar" VIEW-AS TEXT
          SIZE 9 BY .58 AT ROW 13.31 COL 82.14 WIDGET-ID 60
          FGCOLOR 4 FONT 2
     "DATOS DEL TRANSPORTISTA / CONDUCTOR" VIEW-AS TEXT
          SIZE 45 BY .5 AT ROW 15.35 COL 83 WIDGET-ID 38
     RECT-65 AT ROW 15.54 COL 81 WIDGET-ID 52
     RECT-66 AT ROW 13.5 COL 80.72 WIDGET-ID 58
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 135.57 BY 24.19 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-Almcmov T "?" NO-UNDO INTEGRAL Almcmov
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "TRANSPORTISTA PARA TRANSFERENCIAS"
         HEIGHT             = 24.19
         WIDTH              = 135.57
         MAX-HEIGHT         = 24.19
         MAX-WIDTH          = 135.57
         VIRTUAL-HEIGHT     = 24.19
         VIRTUAL-WIDTH      = 135.57
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
/* BROWSE-TAB BROWSE-7 rsOrdenes F-Main */
/* BROWSE-TAB BROWSE-4 BROWSE-7 F-Main */
ASSIGN 
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR BUTTON BUTTON-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-carreta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-cert-inscripcion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-Chofer IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-CodAge IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-Marca IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NomTra IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NroLicencia IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-Placa IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-RucAge IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-Traslado IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "INTEGRAL.Almdmov,INTEGRAL.Almmmatg OF INTEGRAL.Almdmov "
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ","
     _Where[1]         = "almdmov.codcia = s-codcia and 
almdmov.codalm = s-codalm and 
almdmov.tipmov = x-tipmov and 
almdmov.codmov = x-codmov and 
almdmov.nroser = x-nroser and
almdmov.nrodoc = x-nrodoc"
     _JoinCode[2]      = "almcmov.codcia = almdmov.codcia and
almcmov.codalm = almdmov.codalm and
almcmov.tipmov = almdmov.tipmov and
almcmov.codmov = almdmov.codmov and
almcmov.nroser = almdmov.nroser and
almcmov.nrodoc = almdmov.nrodoc"
     _FldNameList[1]   > INTEGRAL.Almdmov.codmat
"Almdmov.codmat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "38.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.Almdmov.CodUnd
     _FldNameList[4]   > INTEGRAL.Almdmov.CanDes
"Almdmov.CanDes" ? ? "decimal" ? ? ? ? ? ? no ? no no "12.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _TblList          = "Temp-Tables.tt-Almcmov"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "x-sele = '' or (x-sele = 'X' and tt-almcmov.flgsit = 'X')"
     _FldNameList[1]   > Temp-Tables.tt-Almcmov.CodAlm
"tt-Almcmov.CodAlm" "Alm" ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-Almcmov.NroSer
"tt-Almcmov.NroSer" "Serie" ? "integer" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-Almcmov.NroDoc
"tt-Almcmov.NroDoc" "Nro Guia" ? "integer" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-Almcmov.FchDoc
"tt-Almcmov.FchDoc" "Fecha" ? "date" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-Almcmov.CodRef
"tt-Almcmov.CodRef" "Ref" "x(11)" "character" ? ? ? ? ? ? no ? no no "7.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-Almcmov.NroRef
"tt-Almcmov.NroRef" "No.Ref" ? "character" ? ? ? ? ? ? no ? no no "12.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-Almcmov.CodCli
"tt-Almcmov.CodCli" "Destino" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-Almcmov.NomRef
"tt-Almcmov.NomRef" "Destino Nombre" ? "character" ? ? ? ? ? ? no ? no no "37.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-Almcmov.Observ
"tt-Almcmov.Observ" ? ? "character" ? ? ? ? ? ? no ? no no "22.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* TRANSPORTISTA PARA TRANSFERENCIAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* TRANSPORTISTA PARA TRANSFERENCIAS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-7
&Scoped-define SELF-NAME BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-7 W-Win
ON ENTRY OF BROWSE-7 IN FRAME F-Main
DO:
    x-tipmov = '9'.
    x-codmov = 9.
    x-nroser = 999.
    x-nrodoc = 9999999.
  
    IF AVAILABLE tt-almcmov THEN DO:
        x-tipmov = tt-almcmov.tipmov.
        x-codmov = tt-almcmov.codmov.
        x-nroser = tt-almcmov.nroser.
        x-nrodoc = tt-almcmov.nrodoc.
    END.

    {&OPEN-QUERY-BROWSE-4}

    BROWSE-4:TITLE = STRING(x-nroser,"9999") + "-" + STRING(x-nrodoc,"99999999").  

    RUN datos-conductor.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-7 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-7 IN FRAME F-Main
DO:
    
   IF AVAILABLE tt-almcmov THEN DO:
       DEFINE VAR x-val AS CHAR.

       x-val = tt-almcmov.flgsit.

       IF x-val = "" THEN DO:
           /* Verificar si ya tiene ingresado el TRANSPORTISTA */
           DEFINE VAR lNroDoc AS CHAR.

           FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND 
                                       faccpedi.coddoc = tt-almcmov.codref AND 
                                       faccpedi.nroped = tt-almcmov.nroref NO-LOCK NO-ERROR.
           IF AVAILABLE faccpedi THEN DO:
               lNroDoc = STRING(tt-almcmov.nroser,"999") + STRING(tt-almcmov.nrodoc,"999999").

               /* Datos del transportista */
               FIND Ccbadocu WHERE Ccbadocu.codcia = s-codcia
                   AND Ccbadocu.coddiv = faccpedi.coddiv
                   AND Ccbadocu.coddoc = 'G/R'
                   AND Ccbadocu.nrodoc = lNroDoc NO-LOCK NO-ERROR.

               IF NOT AVAILABLE Ccbadocu THEN DO:
                   /*
                   x-val = tt-almcmov.flgsit.        

                  IF x-val = 'X' THEN DO:
                        x-val = ''.
                  END.
                  ELSE x-val = 'X'.

                  ASSIGN tt-almcmov.flgsit = x-val.

                  RUN rowdisplay(INPUT x-val).
                  */
                   x-val = 'X'.
               END.
               ELSE DO:
                   MESSAGE "Guia ya tiene TRANSPORTISTA asignado".
               END.
           END.           
            ELSE DO:
                MESSAGE "Imposible ubicar la OTR".
            END.
       END.
       ELSE DO:
            x-val = ''.
       END.
        
       ASSIGN tt-almcmov.flgsit = x-val.
       /* Pintar el Registro */
       RUN rowdisplay(INPUT x-val).
   END.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-7 W-Win
ON ROW-DISPLAY OF BROWSE-7 IN FRAME F-Main
DO:
    DEFINE VAR x-val AS CHAR.

    x-val = "".

    IF AVAILABLE tt-almcmov THEN x-val = tt-almcmov.flgsit.

    RUN rowDisplay (INPUT x-val). /*( INPUT SELF, INPUT "*" ).  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-7 W-Win
ON VALUE-CHANGED OF BROWSE-7 IN FRAME F-Main
DO:
    x-tipmov = '9'.
    x-codmov = 9.
    x-nroser = 999.
    x-nrodoc = 9999999.
  
    IF AVAILABLE tt-almcmov THEN DO:
        x-tipmov = tt-almcmov.tipmov.
        x-codmov = tt-almcmov.codmov.
        x-nroser = tt-almcmov.nroser.
        x-nrodoc = tt-almcmov.nrodoc.
    END.

    {&OPEN-QUERY-BROWSE-4}

    BROWSE-4:TITLE = STRING(x-nroser,"9999") + "-" + STRING(x-nrodoc,"99999999").  

    /* Datos del Conductor */
    RUN datos-conductor.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Todos */
DO:
    x-sele = ''.
    {&OPEN-QUERY-BROWSE-7}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Seleccionados */
DO:
    x-sele = 'X'.
    {&OPEN-QUERY-BROWSE-7}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* TRANSPORTISTA */
DO:
    FIND FIRST tt-almcmov WHERE tt-almcmov.flgsit = 'X' NO-LOCK NO-ERROR.
    IF NOT AVAILABLE tt-almcmov THEN DO:
        MESSAGE "Elija al menos una Guia de Remision".
        RETURN NO-APPLY.
    END.

    DEFINE VAR lNroDoc AS CHAR.

    lNroDoc = STRING(tt-almcmov.nroser,"999") + STRING(tt-almcmov.nrodoc,"999999").

    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND 
                                faccpedi.coddoc = tt-almcmov.codref AND 
                                faccpedi.nroped = tt-almcmov.nroref NO-LOCK NO-ERROR.

    IF AVAILABLE faccpedi THEN DO:

        DEFINE VAR pCodTransportista AS CHAR.
        DEFINE VAR pNomTransportista AS CHAR.
        DEFINE VAR pRUC AS CHAR.
        DEFINE VAR pLicConducir AS CHAR.
        DEFINE VAR pCertInscripcion AS CHAR.
        DEFINE VAR pVehiculoMarca AS CHAR.
        DEFINE VAR pPlaca AS CHAR.
        DEFINE VAR pInicioTraslado AS DATE.
        DEFINE VAR pChofer AS CHAR.
        DEFINE VAR pCarreta AS CHAR.

        DEFINE VAR lNroActualizaciones AS INT.

        RUN alm/w-transportista-guia-transferencia.r(INPUT tt-almcmov.codcia,
                                        INPUT faccpedi.coddiv, INPUT 'G/R',
                                        INPUT lNroDoc,
                                        OUTPUT pCodTransportista, OUTPUT pNomTransportista,
                                        OUTPUT pRUC, OUTPUT pLicConducir,
                                        OUTPUT pCertInscripcion, OUTPUT pVehiculoMarca, 
                                        OUTPUT pPlaca, OUTPUT pInicioTraslado,
                                        OUTPUT pChofer, OUTPUT pCarreta).

        IF pPlaca <> "" AND pCodTransportista <> "" THEN DO:

            lNroActualizaciones = 0.

            FOR EACH tt-almcmov WHERE tt-almcmov.flgsit = 'X' :
                /* Busco la DIVISION de la ORDEN */
                FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND 
                                            faccpedi.coddoc = tt-almcmov.codref AND 
                                            faccpedi.nroped = tt-almcmov.nroref NO-LOCK NO-ERROR.
                IF NOT AVAILABLE faccpedi THEN NEXT.

                lNroDoc = STRING(tt-almcmov.nroser,"999") + STRING(tt-almcmov.nrodoc,"999999").
                /* Datos del transportista */
                FIND Ccbadocu WHERE Ccbadocu.codcia = s-codcia
                    AND Ccbadocu.coddiv = faccpedi.coddiv
                    AND Ccbadocu.coddoc = 'G/R'
                    AND Ccbadocu.nrodoc = lNroDoc
                    EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE Ccbadocu THEN DO:
                    CREATE Ccbadocu.
                    ASSIGN
                        Ccbadocu.codcia = s-codcia
                        Ccbadocu.coddoc = 'G/R'
                        Ccbadocu.nrodoc = lNroDoc
                        Ccbadocu.coddiv = faccpedi.coddiv.
                END.

                ASSIGN
                    CcbADocu.Libre_C[1] = pPlaca
                    CcbADocu.Libre_C[2] = pVehiculoMarca
                    CcbADocu.Libre_C[3] = pCodTransportista
                    CcbADocu.Libre_C[4] = pNomTransportista
                    CcbADocu.Libre_C[5] = pRUC
                    CcbADocu.Libre_C[6] = pLicConducir
                    CcbADocu.Libre_C[7] = pChofer
                    CcbADocu.Libre_C[8] = pLicConducir
                    CcbADocu.Libre_F[1] = pInicioTraslado
                    CcbADocu.Libre_C[17] = pCertInscripcion.
                    CcbADocu.Libre_C[18] = pCarreta.

                    lNroActualizaciones = lNroActualizaciones  + 1.

                RELEASE Ccbadocu.

                ASSIGN tt-almcmov.flgsit = ''.
            END.

            MESSAGE "Se actualizaron " + STRING(lNroActualizaciones,">>,>>9") + 
                    " GUIA(S) DE REMISION con el transportista ingresado".

            {&OPEN-QUERY-BROWSE-7}

        END.
    END.
    ELSE DO:
        MESSAGE "Imposibe Ubicar la ORDEN " + tt-almcmov.codref + "-" + tt-almcmov.nroref + " de la GUIA DE REMISION".
        RETURN NO-APPLY.
    END.
  

/*
      FIND Ccbadocu WHERE Ccbadocu.codcia = pcodcia
          AND Ccbadocu.coddiv = pcoddiv
          AND Ccbadocu.coddoc = pcoddoc
          AND Ccbadocu.nrodoc = pnrodoc
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Ccbadocu THEN CREATE Ccbadocu.
      ASSIGN
          Ccbadocu.codcia = pcodcia
          Ccbadocu.coddoc = pcoddoc
          Ccbadocu.nrodoc = pnrodoc
          Ccbadocu.coddiv = pcoddiv.
      ASSIGN
          CcbADocu.Libre_C[1] = f-Placa:SCREEN-VALUE 
          CcbADocu.Libre_C[2] = f-Marca:SCREEN-VALUE 
          CcbADocu.Libre_C[3] = f-CodAge:SCREEN-VALUE 
          CcbADocu.Libre_C[4] = f-NomTra:SCREEN-VALUE 
          CcbADocu.Libre_C[5] = f-RucAge:SCREEN-VALUE 
          CcbADocu.Libre_C[6] = f-NroLicencia:SCREEN-VALUE 
          CcbADocu.Libre_C[7] = f-Chofer:SCREEN-VALUE 
          CcbADocu.Libre_C[8] = f-NroLicencia:SCREEN-VALUE 
          CcbADocu.Libre_F[1] = INPUT f-Traslado
          CcbADocu.Libre_C[11] = f-Ruc:SCREEN-VALUE
          CcbADocu.Libre_C[16] = f-cert-inscripcion:SCREEN-VALUE
          /*
          CcbADocu.Libre_C[9] = f-CodTran:SCREEN-VALUE 
          CcbADocu.Libre_C[10] = f-Nombre:SCREEN-VALUE 
          CcbADocu.Libre_C[11] = f-Ruc:SCREEN-VALUE 
          CcbADocu.Libre_C[12] = f-Direccion:SCREEN-VALUE 
          CcbADocu.Libre_C[13] = f-Lugar:SCREEN-VALUE 
          CcbADocu.Libre_C[14] = f-Contacto:SCREEN-VALUE 
          CcbADocu.Libre_C[15] = f-Horario:SCREEN-VALUE 
          CcbADocu.Libre_C[16] = f-Observ:SCREEN-VALUE           
          CcbADocu.Libre_F[2] = INPUT f-Fecha.
          */
      RELEASE Ccbadocu.

*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Refrescar */
DO:

  ASSIGN txtNroOrden txtCliente rsOrdenes.

  RUN cargar-data.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Excel */
DO:    
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-data W-Win 
PROCEDURE cargar-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE tt-almcmov.

  DEFINE VAR x-dcmntos AS CHAR.

  x-dcmntos = rsOrdenes.
  IF x-dcmntos = '*' THEN x-dcmntos = "O/D,OTR".

  SESSION:SET-WAIT-STATE('GENERAL').
  IF LOOKUP("OTR",x-dcmntos) > 0  THEN RUN cargar_otr.
  IF LOOKUP("O/D",x-dcmntos) > 0  THEN RUN cargar_od.
  
  {&OPEN-QUERY-BROWSE-7}

    DO n_cols_browse = 1 TO browse-7:NUM-COLUMNS  IN FRAME {&FRAME-NAME} :
        celda_br[n_cols_browse] = browse-7:GET-BROWSE-COLUMN(n_cols_browse). 
    END.

    n_cols_browse = browse-7:NUM-COLUMNS  IN FRAME {&FRAME-NAME}.

    SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar_od W-Win 
PROCEDURE cargar_od :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-quecliente AS CHAR.

DEFINE VAR x-desde AS DATE.
DEFINE VAR x-hasta AS DATE.
DEFINE VAR x-fecha AS DATE.

x-desde = TODAY - 90.
x-hasta = TODAY.

REPEAT x-fecha = x-desde TO x-hasta:
    FOR EACH ccbcdocu USE-INDEX llave05 WHERE ccbcdocu.codcia = s-codcia AND 
                                CcbCDocu.CodDiv = s-CodDiv AND
                                CcbCDocu.TpoFac = 'A' AND
                                CcbCDocu.fchdoc = x-fecha AND
                                ccbcdocu.coddoc = "G/R" NO-LOCK:
                                
        IF ccbcdocu.flgest = 'A' THEN NEXT.
        IF LOOKUP(ccbcdocu.libre_c01,"O/D,O/M") = 0 THEN NEXT.
        IF txtNroOrden <> "" AND txtNroOrden <> ccbcdocu.libre_c02 THEN NEXT.
    
        IF txtCliente <> "" THEN DO:
            x-quecliente = "*" + TRIM(txtCliente) + "*".
            IF NOT (ccbcdocu.nomcli MATCHES x-quecliente) THEN NEXT.
        END.
        /* Que no esten en hoja de Ruta */
        FIND FIRST di-rutaD USE-INDEX llave02
                      WHERE di-rutaD.codcia = s-codcia AND 
                                di-rutaD.coddoc = 'H/R' AND 
                                di-rutaD.codref = ccbcdocu.coddoc AND 
                                di-rutaD.nroref = ccbcdocu.nrodoc NO-LOCK NO-ERROR.
    
        IF NOT AVAILABLE di-rutaD THEN DO:
            CREATE tt-almcmov.
                ASSIGN tt-almcmov.codalm = ccbcdocu.codalm
                        tt-almcmov.nroser = INT(SUBSTRING(ccbcdocu.nrodoc,1,3))
                        tt-almcmov.nrodoc = INT(SUBSTRING(ccbcdocu.nrodoc,4))
                        tt-almcmov.fchdoc = ccbcdocu.fchdoc
                        tt-almcmov.codref = ccbcdocu.libre_c01
                        tt-almcmov.nroref = ccbcdocu.libre_c02
                        tt-almcmov.codcli = ccbcdocu.codcli
                        tt-almcmov.nomref = ccbcdocu.nomcli
                        tt-almcmov.observ = ccbcdocu.glosa
                        tt-almcmov.flgsit = ''.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar_otr W-Win 
PROCEDURE cargar_otr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-quecliente AS CHAR.

FOR EACH Almcmov USE-INDEX almc04
                WHERE Almcmov.codcia = s-codcia and 
                        Almcmov.codalm = s-codalm and 
                        Almcmov.tipmov = 'S' and 
                        Almcmov.codmov = 3 and 
                        almcmov.fchdoc >= 01/01/2017 AND
                        Almcmov.flgest <> 'A' and 
                        Almcmov.flgsit = 'T' and
                        Almcmov.codref = 'OTR' NO-LOCK :

  IF txtNroOrden <> "" AND txtNroOrden <> Almcmov.nroref THEN NEXT.

  IF txtCliente <> "" THEN DO:
      FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND 
                                faccpedi.coddoc = Almcmov.codref AND 
                                faccpedi.nroped = almcmov.nroref NO-LOCK NO-ERROR.
      IF NOT AVAILABLE faccpedi THEN NEXT.

      x-quecliente = "*" + TRIM(txtCliente) + "*".
      IF NOT (faccpedi.nomcli MATCHES x-quecliente) THEN NEXT.
  END.

  /* Que no esten en hoja de Ruta */
  FIND FIRST di-rutaG USE-INDEX llave02
                WHERE di-rutaG.codcia = s-codcia AND di-rutaG.coddoc = 'H/R' AND 
                        di-rutaG.codalm = almcmov.codalm AND di-rutaG.tipmov = almcmov.tipmov AND
                        di-rutaG.codmov = almcmov.codmov AND di-rutaG.serref = almcmov.nroser AND
                        di-rutaG.nroref = almcmov.nrodoc NO-LOCK NO-ERROR.

  IF NOT AVAILABLE di-rutaG THEN DO:
      CREATE tt-almcmov.
      BUFFER-COPY almcmov TO tt-almcmov.
      ASSIGN tt-almcmov.flgsit = ''
            tt-almcmov.codcli = almcmov.almdes.
  END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE datos-conductor W-Win 
PROCEDURE datos-conductor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    f-CodAge:SCREEN-VALUE = "".
    f-NomTra:SCREEN-VALUE = "".
    f-RucAge:SCREEN-VALUE = "".
    f-NroLicencia:SCREEN-VALUE = "".
    f-cert-inscripcion:SCREEN-VALUE = "".
    f-Marca:SCREEN-VALUE = "".
    f-Placa:SCREEN-VALUE = "".
    f-Traslado:SCREEN-VALUE = "".
    f-Chofer:SCREEN-VALUE = "".
    f-Carreta:SCREEN-VALUE = "".
    
    DEFINE VAR lNroDoc AS CHAR.
    
    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND 
                                faccpedi.coddoc = tt-almcmov.codref AND 
                                faccpedi.nroped = tt-almcmov.nroref NO-LOCK NO-ERROR.
    IF NOT AVAILABLE faccpedi THEN RETURN.
    
    lNroDoc = STRING(tt-almcmov.nroser,"999") + STRING(tt-almcmov.nrodoc,"999999").
    
    /* Datos del transportista */
    FIND Ccbadocu WHERE Ccbadocu.codcia = s-codcia
        AND Ccbadocu.coddiv = faccpedi.coddiv
        AND Ccbadocu.coddoc = 'G/R'
        AND Ccbadocu.nrodoc = lNroDoc NO-LOCK NO-ERROR.
    
    IF AVAILABLE Ccbadocu THEN DO:
        f-CodAge:SCREEN-VALUE = CcbADocu.Libre_C[3].
        f-NomTra:SCREEN-VALUE = CcbADocu.Libre_C[4].
        f-RucAge:SCREEN-VALUE = CcbADocu.Libre_C[5].
        f-NroLicencia:SCREEN-VALUE = CcbADocu.Libre_C[6].
        f-cert-inscripcion:SCREEN-VALUE = CcbADocu.Libre_C[17].
        f-Marca:SCREEN-VALUE = CcbADocu.Libre_C[2].
        f-Placa:SCREEN-VALUE = CcbADocu.Libre_C[1].
        f-carreta:SCREEN-VALUE = CcbADocu.Libre_C[18].
        f-Traslado:SCREEN-VALUE = STRING(CcbADocu.Libre_F[1],"99/99/9999").
        f-Chofer:SCREEN-VALUE = CcbADocu.Libre_C[7].
    END.
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
  DISPLAY txtNroOrden txtCliente rsOrdenes f-CodAge f-NomTra f-RucAge 
          f-NroLicencia F-cert-inscripcion f-carreta f-Placa f-Marca f-Traslado 
          f-Chofer 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-65 RECT-66 BUTTON-4 txtNroOrden txtCliente rsOrdenes BROWSE-7 
         BROWSE-4 BUTTON-1 BUTTON-2 BUTTON-3 
      WITH FRAME F-Main IN WINDOW W-Win.
  VIEW FRAME F-Main IN WINDOW W-Win.
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

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = 'c:\ciman\tt-almcmov.xlsx'.

run pi-crea-archivo-csv IN hProc (input  buffer tt-almcmov:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-almcmov:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.

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
RUN cargar-data.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowdisplay W-Win 
PROCEDURE rowdisplay :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pVal AS CHAR.

DEF VAR cual_celda AS WIDGET-HANDLE NO-UNDO.
DEF VAR col_act AS INT NO-UNDO.
DEF VAR t_col_br AS INT NO-UNDO INITIAL 10.
DEF VAR vg_col_eti_b AS INT NO-UNDO INITIAL 28.

DEFINE VAR x-val AS CHAR.

x-val = pVal.

IF  x-val = 'X' THEN DO:
    DO col_act = 1 TO n_cols_browse:
        cual_celda = celda_br[col_act].
        cual_celda:BGCOLOR = t_col_br.
    END.
END.
ELSE DO:
    DO col_act = 1 TO n_cols_browse:
        cual_celda = celda_br[col_act].
        cual_celda:BGCOLOR = 15.
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
  {src/adm/template/snd-list.i "tt-Almcmov"}
  {src/adm/template/snd-list.i "Almdmov"}
  {src/adm/template/snd-list.i "Almmmatg"}

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

