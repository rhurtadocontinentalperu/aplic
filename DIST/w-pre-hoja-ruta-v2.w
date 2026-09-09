&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-CDOCU LIKE CcbCDocu.
DEFINE TEMP-TABLE T-RutaD LIKE DI-RutaD.
DEFINE TEMP-TABLE T-VtaCTabla LIKE VtaCTabla.



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
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEF NEW SHARED VAR s-tabla  AS CHAR INIT 'ZGHR'.
DEF VAR s-tipmov AS CHAR INIT 'S' NO-UNDO.
DEF VAR s-codmov AS INT  INIT 03 NO-UNDO.
DEF VAR s-coddoc AS CHAR INIT 'PHR' NO-UNDO.    /* Pre Hoja de Ruta */

DEF NEW SHARED VAR lh_handle AS HANDLE.

FIND FIRST FacCorre WHERE FacCorre.CodCia = s-codcia 
    AND FacCorre.CodDiv = s-coddiv 
    AND FacCorre.CodDoc = s-coddoc 
    AND FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE 'NO configurado el correlativo para el documento:' s-coddoc SKIP
        'en la división:' s-coddiv
        VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.

DEF VAR SORTBY-NomCli    AS CHAR INIT "" NO-UNDO.
DEF VAR SORTORDER-NomCli AS INT  INIT 0  NO-UNDO.
DEF VAR SORTBY-Peso      AS CHAR INIT "" NO-UNDO.
DEF VAR SORTORDER-Peso   AS INT  INIT 0  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-CDOCU

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-CDOCU T-RutaD VtaCTabla

/* Definitions for BROWSE BROWSE-CDOCU                                  */
&Scoped-define FIELDS-IN-QUERY-BROWSE-CDOCU T-CDOCU.NomCli T-CDOCU.CodPed ~
T-CDOCU.NroPed T-CDOCU.CodDoc T-CDOCU.NroDoc T-CDOCU.Libre_d01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-CDOCU 
&Scoped-define QUERY-STRING-BROWSE-CDOCU FOR EACH T-CDOCU ~
      WHERE (COMBO-BOX-Zona = 'Todos' OR T-CDOCU.Libre_c04 = COMBO-BOX-Zona) ~
 AND T-CDOCU.FlgEst <> 'A' NO-LOCK ~
    BY T-CDOCU.NomCli ~
       BY T-CDOCU.CodPed ~
        BY T-CDOCU.NroPed INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-CDOCU OPEN QUERY BROWSE-CDOCU FOR EACH T-CDOCU ~
      WHERE (COMBO-BOX-Zona = 'Todos' OR T-CDOCU.Libre_c04 = COMBO-BOX-Zona) ~
 AND T-CDOCU.FlgEst <> 'A' NO-LOCK ~
    BY T-CDOCU.NomCli ~
       BY T-CDOCU.CodPed ~
        BY T-CDOCU.NroPed INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-CDOCU T-CDOCU
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-CDOCU T-CDOCU


/* Definitions for BROWSE BROWSE-RUTAD                                  */
&Scoped-define FIELDS-IN-QUERY-BROWSE-RUTAD T-RutaD.Libre_c03 ~
T-RutaD.Libre_c05 T-RutaD.Libre_c01 T-RutaD.Libre_c02 T-RutaD.CodRef ~
T-RutaD.NroRef 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-RUTAD 
&Scoped-define QUERY-STRING-BROWSE-RUTAD FOR EACH T-RutaD NO-LOCK, ~
      EACH VtaCTabla WHERE VtaCTabla.Llave = T-RutaD.Libre_c03 ~
      AND VtaCTabla.CodCia = s-codcia ~
 AND VtaCTabla.Tabla = s-tabla NO-LOCK ~
    BY T-RutaD.Libre_c03 ~
       BY T-RutaD.Libre_c05 ~
        BY T-RutaD.Libre_c01 ~
         BY T-RutaD.Libre_c02 INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-RUTAD OPEN QUERY BROWSE-RUTAD FOR EACH T-RutaD NO-LOCK, ~
      EACH VtaCTabla WHERE VtaCTabla.Llave = T-RutaD.Libre_c03 ~
      AND VtaCTabla.CodCia = s-codcia ~
 AND VtaCTabla.Tabla = s-tabla NO-LOCK ~
    BY T-RutaD.Libre_c03 ~
       BY T-RutaD.Libre_c05 ~
        BY T-RutaD.Libre_c01 ~
         BY T-RutaD.Libre_c02 INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-RUTAD T-RutaD VtaCTabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-RUTAD T-RutaD
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-RUTAD VtaCTabla


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-CDOCU}~
    ~{&OPEN-QUERY-BROWSE-RUTAD}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BtnDone BUTTON-Refrescar COMBO-BOX-Zona ~
BUTTON-Limpiar BUTTON-Generar BROWSE-CDOCU BROWSE-RUTAD BUTTON-Sube ~
BUTTON-Sube-2 BUTTON-Baja BUTTON-Baja-2 BUTTON-Auto 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Zona FILL-IN-Peso-2 FILL-IN-Peso ~
FILL-IN-Volumen-2 FILL-IN-Volumen FILL-IN-Importe-2 FILL-IN-Importe 

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
     SIZE 6 BY 1.35
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-Auto 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "Button 4" 
     SIZE 6 BY 1.62 TOOLTIP "Automático".

DEFINE BUTTON BUTTON-Baja 
     LABEL "<" 
     SIZE 6 BY 1.54 TOOLTIP "Migra  los seleccionados"
     FONT 8.

DEFINE BUTTON BUTTON-Baja-2 
     LABEL "<<" 
     SIZE 6 BY 1.54 TOOLTIP "Migra los que tienen el mismo cliente"
     FONT 8.

DEFINE BUTTON BUTTON-Generar 
     LABEL "GENERACION DE PRE HOJAS DE RUTA" 
     SIZE 35 BY 1.12.

DEFINE BUTTON BUTTON-Limpiar 
     LABEL "QUITAR ORDENAMIENTO" 
     SIZE 23 BY 1.12.

DEFINE BUTTON BUTTON-Refrescar 
     LABEL "CARGA TEMPORALES" 
     SIZE 18 BY 1.08 TOOLTIP "REFRESCAR".

DEFINE BUTTON BUTTON-Sube 
     LABEL ">" 
     SIZE 6 BY 1.54 TOOLTIP "Migra  los seleccionados"
     FONT 8.

DEFINE BUTTON BUTTON-Sube-2 
     LABEL ">>" 
     SIZE 6 BY 1.54 TOOLTIP "Migra los que tienen el mismo cliente"
     FONT 8.

DEFINE VARIABLE COMBO-BOX-Zona AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Filtrar por" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 58 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     LABEL "Importe (S/)" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe-2 AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     LABEL "Importe (S/)" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Peso AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Peso (kg)" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Peso-2 AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Peso (kg)" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Volumen AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Volumen (m3)" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Volumen-2 AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Volumen (m3)" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-CDOCU FOR 
      T-CDOCU SCROLLING.

DEFINE QUERY BROWSE-RUTAD FOR 
      T-RutaD, 
      VtaCTabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-CDOCU
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-CDOCU W-Win _STRUCTURED
  QUERY BROWSE-CDOCU NO-LOCK DISPLAY
      T-CDOCU.NomCli FORMAT "x(30)":U
      T-CDOCU.CodPed FORMAT "x(3)":U
      T-CDOCU.NroPed FORMAT "X(12)":U
      T-CDOCU.CodDoc FORMAT "x(3)":U
      T-CDOCU.NroDoc FORMAT "X(12)":U WIDTH 9
      T-CDOCU.Libre_d01 COLUMN-LABEL "Peso en kg" FORMAT ">>>,>>9.99":U
            WIDTH 14.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 70 BY 19.65
         FONT 4 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-RUTAD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-RUTAD W-Win _STRUCTURED
  QUERY BROWSE-RUTAD NO-LOCK DISPLAY
      T-RutaD.Libre_c03 COLUMN-LABEL "Zona" FORMAT "x(2)":U
      T-RutaD.Libre_c05 COLUMN-LABEL "Cliente" FORMAT "x(30)":U
            WIDTH 32.29
      T-RutaD.Libre_c01 FORMAT "x(3)":U
      T-RutaD.Libre_c02 FORMAT "x(12)":U
      T-RutaD.CodRef FORMAT "x(3)":U
      T-RutaD.NroRef FORMAT "X(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 60 BY 19.65
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BtnDone AT ROW 1 COL 135 WIDGET-ID 28
     BUTTON-Refrescar AT ROW 1.27 COL 71 WIDGET-ID 2
     COMBO-BOX-Zona AT ROW 2.35 COL 9 COLON-ALIGNED WIDGET-ID 10
     BUTTON-Limpiar AT ROW 2.35 COL 71 WIDGET-ID 26
     BUTTON-Generar AT ROW 2.35 COL 106 WIDGET-ID 8
     BROWSE-CDOCU AT ROW 3.69 COL 2 WIDGET-ID 200
     BROWSE-RUTAD AT ROW 3.69 COL 81 WIDGET-ID 300
     BUTTON-Sube AT ROW 4.23 COL 73 WIDGET-ID 4
     BUTTON-Sube-2 AT ROW 5.85 COL 73 WIDGET-ID 18
     BUTTON-Baja AT ROW 7.46 COL 73 WIDGET-ID 20
     BUTTON-Baja-2 AT ROW 9.08 COL 73 WIDGET-ID 22
     BUTTON-Auto AT ROW 10.69 COL 73 WIDGET-ID 24
     FILL-IN-Peso-2 AT ROW 23.62 COL 52 COLON-ALIGNED WIDGET-ID 32
     FILL-IN-Peso AT ROW 23.62 COL 119 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-Volumen-2 AT ROW 24.42 COL 52 COLON-ALIGNED WIDGET-ID 34
     FILL-IN-Volumen AT ROW 24.42 COL 119 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-Importe-2 AT ROW 25.23 COL 52 COLON-ALIGNED WIDGET-ID 30
     FILL-IN-Importe AT ROW 25.23 COL 119 COLON-ALIGNED WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 141.86 BY 25.27
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-CDOCU T "?" ? INTEGRAL CcbCDocu
      TABLE: T-RutaD T "?" ? INTEGRAL DI-RutaD
      TABLE: T-VtaCTabla T "?" ? INTEGRAL VtaCTabla
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "GENERACION DE PRE HOJAS DE RUTA"
         HEIGHT             = 25.27
         WIDTH              = 141.86
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
/* BROWSE-TAB BROWSE-CDOCU BUTTON-Generar F-Main */
/* BROWSE-TAB BROWSE-RUTAD BROWSE-CDOCU F-Main */
ASSIGN 
       BROWSE-CDOCU:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Importe IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Importe-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Peso IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Peso-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Volumen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Volumen-2 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-CDOCU
/* Query rebuild information for BROWSE BROWSE-CDOCU
     _TblList          = "Temp-Tables.T-CDOCU"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.T-CDOCU.NomCli|yes,Temp-Tables.T-CDOCU.CodPed|yes,Temp-Tables.T-CDOCU.NroPed|yes"
     _Where[1]         = "(COMBO-BOX-Zona = 'Todos' OR T-CDOCU.Libre_c04 = COMBO-BOX-Zona)
 AND Temp-Tables.T-CDOCU.FlgEst <> 'A'"
     _FldNameList[1]   > Temp-Tables.T-CDOCU.NomCli
"T-CDOCU.NomCli" ? "x(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.T-CDOCU.CodPed
     _FldNameList[3]   = Temp-Tables.T-CDOCU.NroPed
     _FldNameList[4]   = Temp-Tables.T-CDOCU.CodDoc
     _FldNameList[5]   > Temp-Tables.T-CDOCU.NroDoc
"T-CDOCU.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-CDOCU.Libre_d01
"T-CDOCU.Libre_d01" "Peso en kg" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "14.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-CDOCU */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-RUTAD
/* Query rebuild information for BROWSE BROWSE-RUTAD
     _TblList          = "Temp-Tables.T-RutaD,INTEGRAL.VtaCTabla WHERE Temp-Tables.T-RutaD ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.T-RutaD.Libre_c03|yes,Temp-Tables.T-RutaD.Libre_c05|yes,Temp-Tables.T-RutaD.Libre_c01|yes,Temp-Tables.T-RutaD.Libre_c02|yes"
     _JoinCode[2]      = "INTEGRAL.VtaCTabla.Llave = Temp-Tables.T-RutaD.Libre_c03"
     _Where[2]         = "INTEGRAL.VtaCTabla.CodCia = s-codcia
 AND INTEGRAL.VtaCTabla.Tabla = s-tabla"
     _FldNameList[1]   > Temp-Tables.T-RutaD.Libre_c03
"T-RutaD.Libre_c03" "Zona" "x(2)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-RutaD.Libre_c05
"T-RutaD.Libre_c05" "Cliente" "x(30)" "character" ? ? ? ? ? ? no ? no no "32.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-RutaD.Libre_c01
"T-RutaD.Libre_c01" ? "x(3)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-RutaD.Libre_c02
"T-RutaD.Libre_c02" ? "x(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.T-RutaD.CodRef
     _FldNameList[6]   > Temp-Tables.T-RutaD.NroRef
"T-RutaD.NroRef" ? "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-RUTAD */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* GENERACION DE PRE HOJAS DE RUTA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* GENERACION DE PRE HOJAS DE RUTA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-CDOCU
&Scoped-define SELF-NAME BROWSE-CDOCU
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-CDOCU W-Win
ON START-SEARCH OF BROWSE-CDOCU IN FRAME F-Main
DO:
    DEFINE VAR hSortColumn   AS WIDGET-HANDLE.
    DEFINE VAR lColumName    AS CHAR.
    DEFINE VAR hQueryHandle  AS HANDLE NO-UNDO.
    DEFINE VAR lQueryPrepare AS CHAR NO-UNDO.

    hSortColumn = BROWSE BROWSE-CDOCU:CURRENT-COLUMN.
    lColumName = hSortColumn:NAME.
  
    hQueryHandle = BROWSE BROWSE-CDOCU:QUERY.
    hQueryHandle:QUERY-CLOSE().

    CASE COMBO-BOX-Zona:
        WHEN 'Todos' THEN lQueryPrepare = "FOR EACH T-CDOCU NO-LOCK WHERE T-CDOCU.FlgEst <> 'A'".
        OTHERWISE lQueryPrepare = "FOR EACH T-CDOCU NO-LOCK WHERE T-CDOCU.FlgEst <> 'A' AND T-CDOCU.Libre_c04 = '" + COMBO-BOX-Zona + "'".
    END CASE.
    CASE lColumName:
        WHEN "NomCli" THEN DO:
            IF SORTORDER-NomCli = 0 THEN SORTORDER-NomCli = 1.
            CASE SORTORDER-NomCli:
                WHEN 1 THEN DO:
                    SORTBY-NomCli = " BY T-CDOCU.NomCli".
                    SORTORDER-NomCli = 2.
                END.
                WHEN 2 THEN DO:
                    SORTBY-NomCli = " BY T-CDOCU.NomCli DESC".
                    SORTORDER-NomCli = 1.
                END.
            END CASE.
        END.
        WHEN "Libre_d01" THEN DO:
            IF SORTORDER-Peso = 0 THEN SORTORDER-Peso = 1.
            CASE SORTORDER-Peso:
                WHEN 1 THEN DO:
                    SORTBY-Peso = " BY T-CDOCU.Libre_d01".
                    SORTORDER-Peso = 2.
                END.
                WHEN 2 THEN DO:
                    SORTBY-Peso = " BY T-CDOCU.Libre_d01 DESC".
                    SORTORDER-Peso = 1.
                END.
            END CASE.
        END.
    END CASE.
    hQueryHandle:QUERY-PREPARE(lQueryPrepare + SORTBY-NomCli + SORTBY-Peso).
    hQueryHandle:QUERY-OPEN().
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


&Scoped-define SELF-NAME BUTTON-Auto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Auto W-Win
ON CHOOSE OF BUTTON-Auto IN FRAME F-Main /* Button 4 */
DO:
  DEF VAR pPeso AS DEC NO-UNDO.
  DEF VAR pVolumen AS DEC NO-UNDO.
  DEF VAR pError AS LOG NO-UNDO.
  RUN dist/d-pre-hr-auto (OUTPUT pPeso, OUTPUT pVolumen, OUTPUT pError).
  IF pError = YES THEN RETURN NO-APPLY.
  RUN Pr-Automatico (pPeso, pVolumen).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Baja
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Baja W-Win
ON CHOOSE OF BUTTON-Baja IN FRAME F-Main /* < */
DO:
/*    RUN Pr-Baja IN h_b-pre-hoja-rutaf.                   */
/*    RUN dispatch IN h_b-pre-hoja-rutai ('open-query':U). */
/*    RUN dispatch IN h_b-pre-hoja-rutaf ('open-query':U). */
    RUN Pr-Baja.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Baja-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Baja-2 W-Win
ON CHOOSE OF BUTTON-Baja-2 IN FRAME F-Main /* << */
DO:
/*    RUN Pr-Baja IN h_b-pre-hoja-rutaf.                   */
/*    RUN dispatch IN h_b-pre-hoja-rutai ('open-query':U). */
/*    RUN dispatch IN h_b-pre-hoja-rutaf ('open-query':U). */
    RUN Pr-Baja-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Generar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Generar W-Win
ON CHOOSE OF BUTTON-Generar IN FRAME F-Main /* GENERACION DE PRE HOJAS DE RUTA */
DO:
   RUN Genera-PreHoja.
   APPLY 'CHOOSE':U TO BUTTON-Refrescar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Limpiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Limpiar W-Win
ON CHOOSE OF BUTTON-Limpiar IN FRAME F-Main /* QUITAR ORDENAMIENTO */
DO:
    SORTBY-NomCli = ''.
    SORTORDER-NomCli = 0.
    SORTBY-Peso = ''.
    SORTORDER-Peso = 0.
    {&OPEN-QUERY-BROWSE-CDOCU}
    RUN Totales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Refrescar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Refrescar W-Win
ON CHOOSE OF BUTTON-Refrescar IN FRAME F-Main /* CARGA TEMPORALES */
DO:
  MESSAGE 'Se van a limpiar TODAS las tablas y cargar con información actualizada' SKIP
      'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporales.
  SESSION:SET-WAIT-STATE('').
  MESSAGE 'Carga Exitosa' VIEW-AS ALERT-BOX INFORMATION.
  {&OPEN-QUERY-BROWSE-CDOCU}
  {&OPEN-QUERY-BROWSE-RUTAD}
  RUN Totales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Sube
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Sube W-Win
ON CHOOSE OF BUTTON-Sube IN FRAME F-Main /* > */
DO:
    RUN Pr-Sube.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Sube-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Sube-2 W-Win
ON CHOOSE OF BUTTON-Sube-2 IN FRAME F-Main /* >> */
DO:
    RUN Pr-Sube-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Zona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Zona W-Win
ON VALUE-CHANGED OF COMBO-BOX-Zona IN FRAME F-Main /* Filtrar por */
DO:
  ASSIGN {&self-name}.
  SORTBY-NomCli = ''.
  SORTORDER-NomCli = 0.
  SORTBY-Peso = ''.
  SORTORDER-Peso = 0.
  {&OPEN-QUERY-BROWSE-CDOCU}
  RUN Totales.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporales W-Win 
PROCEDURE Carga-Temporales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER B-CDOCU FOR Ccbcdocu.
DEF BUFFER B-ALMACEN FOR Almacen.

EMPTY TEMP-TABLE T-VtaCTabla.
EMPTY TEMP-TABLE T-CDOCU.
EMPTY TEMP-TABLE T-RUTAD.

FOR EACH VtaCTabla NO-LOCK WHERE VtaCTabla.CodCia = s-codcia
    AND VtaCTabla.Tabla = s-tabla:
    CREATE T-VtaCTabla.
    BUFFER-COPY VtaCTabla TO T-VtaCTabla.
END.

/* Cargamos Guias */
DEFINE VARIABLE pResumen AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iInt     AS INTEGER     NO-UNDO.
DEFINE VARIABLE cValor   AS CHARACTER   NO-UNDO.

/* Guias de Remisión por Ventas */
FOR EACH Ccbcdocu NO-LOCK WHERE CcbCDocu.CodCia = s-codcia 
    AND CcbCDocu.CodDiv = s-coddiv
    AND CcbCDocu.CodDoc = 'G/R'
    AND CcbCDocu.FlgEst = "F"
    AND CcbCDocu.FchDoc >= TODAY - 7:
    /* Buscamos la referencia */
    FIND B-CDOCU WHERE B-CDOCU.codcia = Ccbcdocu.codcia
          AND B-CDOCU.coddoc = Ccbcdocu.codref
          AND B-CDOCU.nrodoc = Ccbcdocu.nroref
          NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CDOCU THEN NEXT.
    /* NO CONTADO ANTICIPADO PENDIENTES DE PAGO */
    IF AVAILABLE B-CDOCU
        AND B-CDOCU.fmapgo = '002'
        AND B-CDOCU.flgest <> "C"
        THEN NEXT.
    /* Buscamos si ya ha sido registrada en una H/R */
    FIND FIRST DI-RutaD WHERE DI-RutaD.CodCia = s-codcia
        AND DI-RutaD.CodDiv = s-coddiv
        AND DI-RutaD.CodDoc = "H/R"
        AND DI-RutaD.CodRef = Ccbcdocu.coddoc
        AND DI-RutaD.NroRef = Ccbcdocu.nrodoc
        AND DI-RutaD.FlgEst = "C"
        AND CAN-FIND(FIRST Di-Rutac OF Di-rutad WHERE Di-rutac.flgest = "C" NO-LOCK)
        NO-LOCK NO-ERROR.
    IF AVAILABLE Di-rutad THEN NEXT.
    FIND FIRST DI-RutaD WHERE DI-RutaD.CodCia = s-codcia
        AND DI-RutaD.CodDiv = s-coddiv
        AND DI-RutaD.CodDoc = "H/R"
        AND DI-RutaD.CodRef = Ccbcdocu.coddoc
        AND DI-RutaD.NroRef = Ccbcdocu.nrodoc
        AND DI-RutaD.FlgEst = "P"
        AND CAN-FIND(FIRST Di-Rutac OF Di-rutad WHERE Di-rutac.flgest = "P" NO-LOCK)
        NO-LOCK NO-ERROR.
    IF AVAILABLE Di-rutad THEN NEXT.
    /* Buscamos si ya ha sido registrada en otra pre-hoja de ruta */
    FIND FIRST DI-RutaD WHERE DI-RutaD.CodCia = s-codcia
        AND DI-RutaD.CodDiv = s-coddiv
        AND DI-RutaD.CodDoc = "PHR"
        AND DI-RutaD.CodRef = Ccbcdocu.coddoc
        AND DI-RutaD.NroRef = Ccbcdocu.nrodoc
        AND DI-RutaD.FlgEst = "P"
        AND CAN-FIND(FIRST Di-Rutac OF Di-rutad WHERE Di-rutac.flgest = "P" NO-LOCK)
        NO-LOCK NO-ERROR.
    IF AVAILABLE Di-rutad THEN NEXT.
    CREATE T-CDOCU.
    ASSIGN
        T-CDOCU.CodCia = s-codcia
        T-CDOCU.CodDiv = s-coddiv
        T-CDOCU.CodDoc = CcbCDocu.CodDoc
        T-CDOCU.NroDoc = CcbCDocu.NroDoc
        T-CDOCU.CodRef = "G/R"      /* Guia por Ventas */
        T-CDOCU.CodCli = CcbCDocu.CodCli
        T-CDOCU.NomCli = CcbCDocu.NomCli
        T-CDOCU.CodPed = B-CDOCU.Libre_c01   /* O/D */
        T-CDOCU.NroPed = B-CDOCU.Libre_c02.
    /* Pesos y Volumenes */
    RUN Vta/resumen-pedido (T-CDOCU.CodDiv, T-CDOCU.CodDoc, T-CDOCU.NroDoc, OUTPUT pResumen).
    pResumen = SUBSTRING(pResumen,2,(LENGTH(pResumen) - 2)).
    cValor = ''.
    DO iint = 1 TO NUM-ENTRIES(pResumen,"/"):
        cValor = cValor + SUBSTRING(ENTRY(iint,pResumen,"/"),4) + ','.
    END.
    ASSIGN
        T-CDOCU.Libre_d01 = DEC(ENTRY(4,cValor))    /* Peso en Kg */
        T-CDOCU.Libre_d02 = DEC(ENTRY(5,cValor))    /* Volumen en m3 */
        T-CDOCU.ImpTot    = (IF Ccbcdocu.codmon = 2 THEN Ccbcdocu.TpoCmb * Ccbcdocu.ImpTot ELSE Ccbcdocu.ImpTot).
    IF T-CDOCU.Libre_d01 = ? THEN T-CDOCU.Libre_d01 = 0.
    IF T-CDOCU.Libre_d02 = ? THEN T-CDOCU.Libre_d02 = 0.
END.

/* Guias de Remisión por Transferencias */
DEFINE VAR lPesos AS DEC.
DEFINE VAR lCosto AS DEC.
DEFINE VAR lVolumen AS DEC.    
DEFINE VAR lValorizado AS LOGICAL.
FOR EACH Almacen NO-LOCK WHERE Almacen.CodCia = s-codcia
    AND Almacen.CodDiv = s-coddiv,
    EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = Almacen.codcia
    AND Almcmov.CodAlm = Almacen.codalm
    AND Almcmov.TipMov = s-tipmov
    AND Almcmov.CodMov = s-codmov
    AND Almcmov.FlgEst <> "A"
    AND Almcmov.FlgSit = "T":
    /* Buscamos si ya ha sido registrada en una H/R */
    FIND FIRST Di-RutaG WHERE Di-RutaG.CodCia = Almcmov.codcia
        AND Di-RutaG.CodAlm = Almcmov.codalm
        AND Di-RutaG.CodDiv = s-coddiv
        AND Di-RutaG.CodDoc = "H/R"
        AND Di-RutaG.FlgEst = "C"
        AND Di-RutaG.nroref = Almcmov.nrodoc
        AND Di-RutaG.serref = Almcmov.nroser
        AND Di-RutaG.Tipmov = Almcmov.tipmov
        AND Di-RutaG.Codmov = Almcmov.codmov
        AND CAN-FIND(FIRST Di-Rutac OF Di-rutad WHERE Di-rutac.flgest = "C" NO-LOCK)
        NO-LOCK NO-ERROR.
    IF AVAILABLE Di-rutag THEN NEXT.
    FIND Di-RutaG WHERE Di-RutaG.CodCia = Almcmov.codcia
        AND Di-RutaG.CodAlm = Almcmov.codalm
        AND Di-RutaG.CodDiv = s-coddiv
        AND Di-RutaG.CodDoc = "H/R"
        AND Di-RutaG.FlgEst = "P"
        AND Di-RutaG.nroref = Almcmov.nrodoc
        AND Di-RutaG.serref = Almcmov.nroser
        AND Di-RutaG.Tipmov = Almcmov.tipmov
        AND Di-RutaG.Codmov = Almcmov.codmov
        AND CAN-FIND(FIRST Di-Rutac OF Di-rutad WHERE Di-rutac.flgest = "P" NO-LOCK)
        NO-LOCK NO-ERROR.
    IF AVAILABLE Di-rutag THEN NEXT.
    /* Buscamos si ya ha sido registrada en otra pre-hoja de ruta */
    FIND Di-RutaG WHERE Di-RutaG.CodCia = Almcmov.codcia
        AND Di-RutaG.CodAlm = Almcmov.codalm
        AND Di-RutaG.CodDiv = s-coddiv
        AND Di-RutaG.CodDoc = "PHR"
        AND Di-RutaG.FlgEst = "P"
        AND Di-RutaG.nroref = Almcmov.nrodoc
        AND Di-RutaG.serref = Almcmov.nroser
        AND Di-RutaG.Tipmov = Almcmov.tipmov
        AND Di-RutaG.Codmov = Almcmov.codmov
        AND CAN-FIND(FIRST Di-Rutac OF Di-rutad WHERE Di-rutac.flgest = "P" NO-LOCK)
        NO-LOCK NO-ERROR.
    IF AVAILABLE Di-rutag THEN NEXT.
    /* RHC 16/08/2012 CONSISTENCIA DE ROTULADO */
    CASE TRUE:
        WHEN Almcmov.CodRef = "OTR" THEN DO:
            FIND FIRST CcbCBult WHERE CcbCBult.CodCia = s-codcia
                AND CcbCBult.CodDoc = Almcmov.CodRef
                AND CcbCBult.NroDoc = Almcmov.NroRef
                AND CcbCBult.CHR_01 = "P"
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Ccbcbult THEN NEXT.
        END.
        OTHERWISE DO:
            FIND FIRST CcbCBult WHERE CcbCBult.CodCia = s-codcia
                AND CcbCBult.CodDoc = "TRA"
                AND CcbCBult.NroDoc = STRING(Almcmov.NroSer) +
                                      STRING(Almcmov.NroDoc , '9999999')
                AND CcbCBult.CHR_01 = "P"
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Ccbcbult THEN NEXT.
        END.
    END CASE.
    CREATE T-CDOCU.
    ASSIGN
        T-CDOCU.CodCia = s-codcia
        T-CDOCU.CodDiv = s-coddiv
        T-CDOCU.CodDoc = "G/R"
        T-CDOCU.NroDoc = STRING(Almcmov.NroSer,'999') + STRING(Almcmov.NroDoc,'999999999')
        T-CDOCU.CodRef = "GTR"     /* Transferencia */
        T-CDOCU.CodAlm = Almcmov.CodAlm
        T-CDOCU.CodPed = Almcmov.codref     /* OTR */
        T-CDOCU.NroPed = Almcmov.nroref.

    FIND B-ALMACEN WHERE B-ALMACEN.codcia = s-codcia
        AND B-ALMACEN.codalm = Almcmov.almdes NO-LOCK NO-ERROR.
    IF AVAILABLE B-ALMACEN  THEN ASSIGN T-CDOCU.NomCli = B-ALMACEN.descripcion.
    lPesos = 0.
    lCosto = 0.
    lVolumen = 0.
    FOR EACH almdmov OF almcmov NO-LOCK:
        lPesos = lPesos + almdmov.pesmat.
        /* Costo */
        FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia AND AlmStkGe.codmat = almdmov.codmat AND
            AlmStkGe.fecha <= DI-RutaC.Fchdoc NO-LOCK NO-ERROR.
        lValorizado = NO.
        IF AVAILABLE AlmStkGe THEN DO:
            /*
            lCosto = lCosto + (AlmStkGe.CtoUni * AlmDmov.candes).
            IF AlmStkGe.CtoUni > 0 THEN lValorizado = YES.
            */
        END.
        /* Ic - 28Feb2015 : Felix Perez indico que se valorize con el precio de venta*/
        lValorizado = NO.
        /* Volumen */
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia 
            AND almmmatg.codmat = almdmov.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE almmmatg THEN DO :
            lVolumen = lVolumen + ( Almdmov.candes * ( almmmatg.libre_d02 / 1000000)).
            /* Si tiene valorizacion CERO, cargo el precio de venta */
            IF lValorizado = NO THEN DO:
                IF almmmatg.monvta = 2 THEN DO:
                    /* Dolares */
                    lCosto = lCosto + ((Almmmatg.preofi * Almmmatg.tpocmb) * AlmDmov.candes * Almdmov.factor).
                END.
                ELSE lCosto = lCosto + (Almmmatg.preofi * AlmDmov.candes * Almdmov.factor).
            END.
        END.
    END.
    ASSIGN 
        T-CDOCU.libre_d01 = lPesos
        T-CDOCU.libre_d02 = lVolumen
        T-CDOCU.imptot    = lCosto.           
    IF T-CDOCU.Libre_d01 = ? THEN T-CDOCU.Libre_d01 = 0.
    IF T-CDOCU.Libre_d02 = ? THEN T-CDOCU.Libre_d02 = 0.
END.

/* Destino Teórico: Depende del Cliente */
FOR EACH T-CDOCU:
    /* Importe el soles */
    IF T-CDOCU.CodMon = 2 THEN DO:
    END.
    ASSIGN
        T-CDOCU.Libre_c01 = '15'
        T-CDOCU.Libre_c02 = '01'      /* Lima - Lima */
        T-CDOCU.Libre_c03 = '01'.
    CASE T-CDOCU.CodRef:
        WHEN "G/R" THEN DO:
            FIND B-CDOCU WHERE B-CDOCU.codcia = T-CDOCU.codcia
                AND B-CDOCU.coddoc = T-CDOCU.coddoc
                AND B-CDOCU.nrodoc = T-CDOCU.nrodoc
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE B-CDOCU THEN NEXT.
            FIND gn-clie WHERE gn-clie.codcia = cl-codcia
                AND gn-clie.codcli = B-CDOCU.codcli
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-clie THEN NEXT.
            IF TRUE <> (gn-clie.CodDept > '')
                OR TRUE <> (gn-clie.CodProv > '') 
                OR TRUE <> (gn-clie.CodDist > '')
                THEN NEXT.
            ASSIGN
                T-CDOCU.Libre_c01 = gn-clie.CodDept 
                T-CDOCU.Libre_c02 = gn-clie.CodProv
                T-CDOCU.Libre_c03 = gn-clie.CodDist.
        END.
        WHEN "GTR" THEN DO:
            FIND FIRST Almacen WHERE Almacen.codcia = T-CDOCU.codcia
                AND Almacen.codalm = T-CDOCU.codalm
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almacen THEN DO:
                FIND FIRST gn-divi OF Almacen NO-LOCK NO-ERROR.
                IF AVAILABLE gn-divi THEN DO:
                    ASSIGN
                        T-CDOCU.Libre_c01 = GN-DIVI.Campo-Char[3]
                        T-CDOCU.Libre_c02 = GN-DIVI.Campo-Char[4]
                        T-CDOCU.Libre_c03 = GN-DIVI.Campo-Char[5].
                END.
            END.
        END.
    END CASE.
END.

/* Acumulamos */
FOR EACH T-CDOCU:
    FOR EACH VtaDTabla NO-LOCK WHERE VtaDTabla.CodCia = s-codcia
        AND VtaDTabla.Tabla = s-tabla
        AND VtaDTabla.Libre_c01 = T-CDOCU.Libre_c01
        AND VtaDTabla.Libre_c02 = T-CDOCU.Libre_c02
        AND VtaDTabla.Libre_c03 = T-CDOCU.Libre_c03,
        FIRST T-VtaCTabla OF VtaDTabla:
        ASSIGN
            T-VtaCTabla.Libre_d01 = T-VtaCTabla.Libre_d01 + 1
            T-VtaCTabla.Libre_d02 = T-VtaCTabla.Libre_d02 + T-CDOCU.libre_d01
            T-VtaCTabla.Libre_d03 = T-VtaCTabla.Libre_d03 + T-CDOCU.libre_d02
            T-VtaCTabla.Libre_d04 = T-VtaCTabla.Libre_d04 + T-CDOCU.imptot.
        ASSIGN
            T-CDOCU.Libre_c04 = T-VtaCTabla.Llave.
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
  DISPLAY COMBO-BOX-Zona FILL-IN-Peso-2 FILL-IN-Peso FILL-IN-Volumen-2 
          FILL-IN-Volumen FILL-IN-Importe-2 FILL-IN-Importe 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BtnDone BUTTON-Refrescar COMBO-BOX-Zona BUTTON-Limpiar BUTTON-Generar 
         BROWSE-CDOCU BROWSE-RUTAD BUTTON-Sube BUTTON-Sube-2 BUTTON-Baja 
         BUTTON-Baja-2 BUTTON-Auto 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-PreHoja W-Win 
PROCEDURE Genera-PreHoja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
MESSAGE 'Procedemos con la generación de la Pre Hoja de Ruta?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.

/*
  Tabla: "Almacen"
  Alcance: [{"FIRST" | "LAST" | "CURRENT" }]   Valor opcional
  Condicion: "Almacen.codcia = s-codcia AND Almacen.codalm = s-codalm"
  Bloqueo: { "NO-LOCK" | "SHARED-LOCK" | "EXCLUSIVE-LOCK" }
  Accion: { "RETRY" | "LEAVE" }
  Mensaje: { "YES" | "NO" }
  TipoError: { "[UNDO,] RETURN {'ADM-ERROR' | ERROR | }" | "NEXT" | "LEAVE" }
  &Intentos="5"
*/
DEF VAR pError AS CHAR INIT 'ERROR' NO-UNDO.

DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    {lib/lock-genericov21.i &Tabla="FacCorre" ~
        &Alcance="FIRST" ~
        &Condicion="FacCorre.CodCia = s-codcia ~
        AND FacCorre.CodDiv = s-coddiv ~
        AND FacCorre.CodDoc = s-coddoc ~
        AND FacCorre.FlgEst = YES" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="DO: pError = 'ERROR'. UNDO, LEAVE. END" ~
        }
    CREATE DI-RutaC.
    ASSIGN
        DI-RutaC.CodCia = s-codcia
        DI-RutaC.CodDiv = s-coddiv
        DI-RutaC.CodDoc = s-coddoc
        DI-RutaC.FchDoc = TODAY
        DI-RutaC.NroDoc = STRING(FacCorre.nroser, '999') + 
                            STRING(FacCorre.correlativo, '999999')
        DI-RutaC.usuario = s-user-id
        DI-RutaC.flgest  = "P".     /* Pendiente */
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    pError = DI-RutaC.CodDoc + ' ' + DI-RutaC.NroDoc.
    FOR EACH T-RUTAD:
        CASE T-RUTAD.CodDoc:
            WHEN "G/R" THEN RUN Genera-Ventas.
            WHEN "GTR" THEN RUN Genera-Transferencias.
        END CASE.
    END.
END.
IF AVAILABLE FacCorre THEN RELEASE FacCorre.
IF AVAILABLE DI-RutaC THEN RELEASE DI-RutaC.
IF pError <> 'ERROR' THEN MESSAGE 'Se generó el documento:' pError VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Transferencias W-Win 
PROCEDURE Genera-Transferencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lAlmacen AS CHAR.
DEFINE VAR lSerMovAlm AS INT.
DEFINE VAR lNroMovAlm AS INT64.

ASSIGN
    lAlmacen   = T-RUTAD.Libre_c04
    lSerMovAlm = INTEGER(SUBSTRING(T-RUTAD.NroRef,1,3))
    lNroMovAlm = INTEGER(SUBSTRING(T-RUTAD.NroRef,4)).
 
CREATE Di-RutaG.
ASSIGN 
    Di-RutaG.CodCia = Di-RutaC.CodCia
    Di-RutaG.CodDiv = Di-RutaC.CodDiv
    Di-RutaG.CodDoc = Di-RutaC.CodDoc
    Di-RutaG.NroDoc = Di-RutaC.NroDoc
    Di-RutaG.Tipmov = s-tipmov
    Di-RutaG.Codmov = s-codmov
    Di-RutaG.CodAlm = lAlmacen.
ASSIGN
    Di-RutaG.nroref = lNroMovAlm
    Di-RutaG.serref = lSerMovAlm.

/* Guardos los pesos y el costo de Mov. Almacen - Ic 10Jul2013 */
DEFINE VAR lPesos AS DEC.
DEFINE VAR lCosto AS DEC.
DEFINE VAR lVolumen AS DEC.    
DEFINE VAR lValorizado AS LOGICAL.

lPesos = 0.
lCosto = 0.
lVolumen = 0.

FOR EACH almdmov WHERE almdmov.codcia = s-codcia
    AND almdmov.codalm = lAlmacen
    AND almdmov.tipmov = s-tipmov 
    AND almdmov.codmov = s-codmov
    AND almdmov.nroser = lSerMovAlm
    AND almdmov.nrodoc = lNroMovAlm NO-LOCK:

    lPesos = lPesos + almdmov.pesmat.
    /* Costo */
    FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia AND AlmStkGe.codmat = almdmov.codmat AND
        AlmStkGe.fecha <= DI-RutaC.Fchdoc NO-LOCK NO-ERROR.
    
    lValorizado = NO.
    IF AVAILABLE AlmStkGe THEN DO:
        /*
        lCosto = lCosto + (AlmStkGe.CtoUni * AlmDmov.candes).
        IF AlmStkGe.CtoUni > 0 THEN lValorizado = YES.
        */
    END.
    /* Ic - 28Feb2015 : Felix Perez indico que se valorize con el precio de venta*/
    lValorizado = NO.
    /* Volumen */
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                almmmatg.codmat = almdmov.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmatg THEN DO :
        lVolumen = lVolumen + ( Almdmov.candes * ( almmmatg.libre_d02 / 1000000)).
        /* Si tiene valorzacion CERO, cargo el precio de venta */
        IF lValorizado = NO THEN DO:
            IF almmmatg.monvta = 2 THEN DO:
                /* Dolares */
                lCosto = lCosto + ((Almmmatg.preofi * Almmmatg.tpocmb) * AlmDmov.candes).
            END.
            ELSE lCosto = lCosto + (Almmmatg.preofi * AlmDmov.candes).
        END.
    END.
END.

ASSIGN 
    Di-RutaG.libre_d01 = lPesos
    Di-RutaG.libre_d02 = lCosto.           
    Di-RutaG.libre_d03 = lVolumen.

RELEASE Di-RutaG.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Ventas W-Win 
PROCEDURE Genera-Ventas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE pResumen AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iInt     AS INTEGER     NO-UNDO.
DEFINE VARIABLE cValor   AS CHARACTER   NO-UNDO.

CREATE DI-RutaD.
ASSIGN
    DI-RutaD.CodCia = DI-RutaC.CodCia
    DI-RutaD.CodDiv = DI-RutaC.CodDiv
    DI-RutaD.CodDoc = DI-RutaC.CodDoc
    DI-RutaD.NroDoc = DI-RutaC.NroDoc
    DI-RutaD.CodRef = T-RUTAD.CodRef
    DI-RutaD.NroRef = T-RUTAD.NroRef.
/* Pesos y Volumenes */
RUN Vta/resumen-pedido (DI-RutaD.CodDiv, DI-RutaD.CodRef, DI-RutaD.NroRef, OUTPUT pResumen).
pResumen = SUBSTRING(pResumen,2,(LENGTH(pResumen) - 2)).
DO iint = 1 TO NUM-ENTRIES(pResumen,"/"):
    cValor = cValor + SUBSTRING(ENTRY(iint,pResumen,"/"),4) + ','.
END.
DI-RutaD.Libre_c01 = cValor.

/* Grabamos el orden de impresion */
FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.coddoc = DI-RutaD.CodRef
    AND ccbcdocu.nrodoc = DI-RutaD.NroRef
    NO-LOCK NO-ERROR.
ASSIGN
    DI-RutaD.Libre_d01 = 9999.
FIND gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = ccbcdocu.codcli
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie THEN DO:
    FIND Vtaubidiv WHERE VtaUbiDiv.CodCia = s-codcia
        AND VtaUbiDiv.CodDiv = s-coddiv
        AND VtaUbiDiv.CodDept = gn-clie.CodDept 
        AND VtaUbiDiv.CodProv = gn-clie.CodProv 
        AND VtaUbiDiv.CodDist = gn-clie.CodDist
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaUbiDiv THEN DI-RutaD.Libre_d01 = VtaUbiDiv.Libre_d01.
END.
RELEASE Di-RutaD.
RETURN 'OK'.

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
      FOR EACH VtaCTabla NO-LOCK WHERE VtaCTabla.CodCia = s-codcia
          AND VtaCTabla.Tabla = s-tabla:
          COMBO-BOX-Zona:ADD-LAST(VtaCTabla.Descripcion, VtaCTabla.Llave).
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pr-Automatico W-Win 
PROCEDURE Pr-Automatico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Barremos en orden hasta cubrir la cuota
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pPeso AS DEC.
DEF INPUT PARAMETER pVolumen AS DEC.

DEF VAR x-Peso    AS DEC INIT 0 NO-UNDO.
DEF VAR x-Volumen AS DEC INIT 0 NO-UNDO.

GET FIRST BROWSE-CDOCU.
REPEAT WHILE AVAILABLE T-CDOCU:
    IF pPeso > 0 THEN DO:
        IF (x-Peso + T-CDOCU.Libre_d01) > (pPeso * 1.10) THEN LEAVE.
    END.
    IF pVolumen > 0 THEN DO:
        IF (x-Volumen + T-CDOCU.Libre_d02) > (pVolumen * 1.10) THEN LEAVE.
    END.
    FIND CURRENT T-CDOCU EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = NO THEN DO:
        CREATE T-RUTAD.
        ASSIGN
            T-RUTAD.CodCia = s-codcia
            T-RUTAD.CodDiv = s-coddiv
            T-RUTAD.Libre_c01 = T-CDOCU.CodPed
            T-RUTAD.Libre_c02 = T-CDOCU.NroPed
            T-RUTAD.CodDoc = T-CDOCU.CodRef     /* OJO: G/R o GTR */
            T-RUTAD.CodRef = T-CDOCU.CodDoc 
            T-RUTAD.NroRef = T-CDOCU.NroDoc
            T-RUTAD.Libre_c03 = T-CDOCU.Libre_C04
            T-RUTAD.Libre_c05 = T-CDOCU.NomCli
            T-RUTAD.Libre_d01 = T-CDOCU.Libre_d01   /* Peso kg */
            T-RUTAD.Libre_d02 = T-CDOCU.Libre_d02   /* Volumen m3 */
            T-RUTAD.ImpCob    = T-CDOCU.ImpTot      /* Importe S/ */
            T-RUTAD.Libre_c04 = T-CDOCU.CodAlm
            .
        ASSIGN 
            T-CDOCU.FlgEst = "A".
        ASSIGN
            x-Peso = x-Peso + T-RUTAD.Libre_d01
            x-Volumen = x-Volumen + T-RUTAD.Libre_d02.
    END.
    GET NEXT BROWSE-CDOCU.
END.
{&OPEN-QUERY-BROWSE-CDOCU}
{&OPEN-QUERY-BROWSE-RUTAD}
RUN Totales.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pr-Baja W-Win 
PROCEDURE Pr-Baja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF BROWSE-RUTAD:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} <= 0 THEN RETURN.
DEF VAR k AS INT NO-UNDO.
DO k = 1 TO BROWSE-RUTAD:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF BROWSE-RUTAD:FETCH-SELECTED-ROW(k) THEN DO:
        FIND CURRENT T-RUTAD EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE T-RUTAD THEN NEXT.
        FIND T-CDOCU WHERE T-CDOCU.coddoc = T-RutaD.CodRef 
            AND T-CDOCU.nrodoc = T-RutaD.NroRef
            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE T-CDOCU THEN NEXT.
        ASSIGN
            T-CDOCU.FlgEst = "".
        DELETE T-RUTAD.
    END.
END.
{&OPEN-QUERY-BROWSE-CDOCU}
{&OPEN-QUERY-BROWSE-RUTAD}
RUN Totales.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pr-Baja-2 W-Win 
PROCEDURE Pr-Baja-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF BROWSE-RUTAD:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} <= 0 THEN RETURN.

DEF VAR x-Llave AS CHAR NO-UNDO.
DEF VAR k AS INT NO-UNDO.
DO k = 1 TO 1:
    IF BROWSE-RUTAD:FETCH-SELECTED-ROW(k) THEN DO:
        FIND CURRENT T-RUTAD EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE T-RUTAD THEN RETURN.
        x-Llave = T-RUTAD.Libre_c05.
    END.
END.
GET FIRST BROWSE-RUTAD.
REPEAT WHILE AVAILABLE T-RUTAD:
    IF T-RUTAD.Libre_c05 = x-Llave THEN DO:
        FIND CURRENT T-RUTAD EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE T-RUTAD THEN NEXT.
        FIND T-CDOCU WHERE T-CDOCU.coddoc = T-RutaD.CodRef 
            AND T-CDOCU.nrodoc = T-RutaD.NroRef
            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE T-CDOCU THEN NEXT.
        ASSIGN
            T-CDOCU.FlgEst = "".
        DELETE T-RUTAD.
    END.
    GET NEXT BROWSE-RUTAD.
END.
{&OPEN-QUERY-BROWSE-CDOCU}
{&OPEN-QUERY-BROWSE-RUTAD}
RUN Totales.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pr-Sube W-Win 
PROCEDURE Pr-Sube :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF BROWSE-CDOCU:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} <= 0 THEN RETURN.

DEF VAR k AS INT NO-UNDO.
DO k = 1 TO BROWSE-CDOCU:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF BROWSE-CDOCU:FETCH-SELECTED-ROW(k) THEN DO:
        FIND CURRENT T-CDOCU EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE T-CDOCU THEN NEXT.
        CREATE T-RUTAD.
        ASSIGN
            T-RUTAD.CodCia = s-codcia
            T-RUTAD.CodDiv = s-coddiv
            T-RUTAD.Libre_c01 = T-CDOCU.CodPed
            T-RUTAD.Libre_c02 = T-CDOCU.NroPed
            T-RUTAD.CodDoc = T-CDOCU.CodRef     /* OJO: G/R o GTR */
            T-RUTAD.CodRef = T-CDOCU.CodDoc 
            T-RUTAD.NroRef = T-CDOCU.NroDoc
            T-RUTAD.Libre_c03 = T-CDOCU.Libre_C04
            T-RUTAD.Libre_c05 = T-CDOCU.NomCli
            T-RUTAD.Libre_d01 = T-CDOCU.Libre_d01   /* Peso kg */
            T-RUTAD.Libre_d02 = T-CDOCU.Libre_d02   /* Volumen m3 */
            T-RUTAD.ImpCob    = T-CDOCU.ImpTot      /* Importe S/ */
            T-RUTAD.Libre_c04 = T-CDOCU.CodAlm
            .
        ASSIGN 
            T-CDOCU.FlgEst = "A".
    END.
END.
{&OPEN-QUERY-BROWSE-CDOCU}
{&OPEN-QUERY-BROWSE-RUTAD}
RUN Totales.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pr-Sube-2 W-Win 
PROCEDURE Pr-Sube-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Pescamos el primero como referencia
------------------------------------------------------------------------------*/

IF BROWSE-CDOCU:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} <= 0 THEN RETURN.

DEF VAR x-Llave AS CHAR NO-UNDO.
DEF VAR k AS INT NO-UNDO.
DO k = 1 TO 1:
    IF BROWSE-CDOCU:FETCH-SELECTED-ROW(k) THEN DO:
        FIND CURRENT T-CDOCU EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE T-CDOCU THEN RETURN.
        x-Llave = T-CDOCU.NomCli.
    END.
END.
GET FIRST BROWSE-CDOCU.
REPEAT WHILE AVAILABLE T-CDOCU:
    IF T-CDOCU.NomCli = x-Llave THEN DO:
        FIND CURRENT T-CDOCU EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE T-CDOCU THEN NEXT.
        CREATE T-RUTAD.
        ASSIGN
            T-RUTAD.CodCia = s-codcia
            T-RUTAD.CodDiv = s-coddiv
            T-RUTAD.Libre_c01 = T-CDOCU.CodPed
            T-RUTAD.Libre_c02 = T-CDOCU.NroPed
            T-RUTAD.CodDoc = T-CDOCU.CodRef     /* OJO: G/R o GTR */
            T-RUTAD.CodRef = T-CDOCU.CodDoc 
            T-RUTAD.NroRef = T-CDOCU.NroDoc
            T-RUTAD.Libre_c03 = T-CDOCU.Libre_C04
            T-RUTAD.Libre_c05 = T-CDOCU.NomCli
            T-RUTAD.Libre_d01 = T-CDOCU.Libre_d01   /* Peso kg */
            T-RUTAD.Libre_d02 = T-CDOCU.Libre_d02   /* Volumen m3 */
            T-RUTAD.ImpCob    = T-CDOCU.ImpTot      /* Importe S/ */
            T-RUTAD.Libre_c04 = T-CDOCU.CodAlm
            .
        ASSIGN 
            T-CDOCU.FlgEst = "A".
    END.
    GET NEXT BROWSE-CDOCU.
END.
{&OPEN-QUERY-BROWSE-CDOCU}
{&OPEN-QUERY-BROWSE-RUTAD}
RUN Totales.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle W-Win 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pParametro AS CHAR.

CASE pParametro:
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
  {src/adm/template/snd-list.i "T-RutaD"}
  {src/adm/template/snd-list.i "VtaCTabla"}
  {src/adm/template/snd-list.i "T-CDOCU"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Totales W-Win 
PROCEDURE Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF BUFFER D-RUTAD FOR T-RUTAD.

    ASSIGN
        FILL-IN-Peso = 0
        FILL-IN-Volumen = 0
        FILL-IN-Importe = 0.
    FOR EACH D-RUTAD NO-LOCK WHERE D-RUTAD.Libre_d01 <> ? AND D-RUTAD.Libre_d02 <> ?:
        ASSIGN
            FILL-IN-Peso = FILL-IN-Peso + D-RUTAD.Libre_d01
            FILL-IN-Volumen = FILL-IN-Volumen + D-RUTAD.Libre_d02
            FILL-IN-Importe = FILL-IN-Importe + D-RUTAD.ImpCob.
    END.
    DISPLAY FILL-IN-Peso FILL-IN-Volumen FILL-IN-Importe WITH FRAME {&FRAME-NAME}.

    DEF BUFFER D-CDOCU FOR T-CDOCU.

    ASSIGN
        FILL-IN-Peso-2 = 0
        FILL-IN-Volumen-2 = 0
        FILL-IN-Importe-2 = 0.
    FOR EACH D-CDOCU NO-LOCK WHERE D-CDOCU.Libre_d01 <> ? AND D-CDOCU.Libre_d02 <> ?
        AND D-CDOCU.FlgEst <> 'A':
        ASSIGN
            FILL-IN-Peso-2 = FILL-IN-Peso-2 + D-CDOCU.Libre_d01
            FILL-IN-Volumen-2 = FILL-IN-Volumen-2 + D-CDOCU.Libre_d02
            FILL-IN-Importe-2 = FILL-IN-Importe-2 + D-CDOCU.ImpTot.
    END.
    DISPLAY FILL-IN-Peso-2 FILL-IN-Volumen-2 FILL-IN-Importe-2 WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

