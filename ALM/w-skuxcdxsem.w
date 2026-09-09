&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE TEMP-TABLE T-TABLA NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE T-TABLA2 NO-UNDO LIKE w-report.



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

DEF VAR cCodDiv AS CHAR NO-UNDO.

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
&Scoped-define INTERNAL-TABLES T-TABLA GN-DIVI T-TABLA2

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 T-TABLA.Llave-C T-TABLA.Campo-F[1] ~
T-TABLA.Campo-F[2] T-TABLA.Campo-F[3] T-TABLA.Campo-F[4] T-TABLA.Campo-F[5] ~
T-TABLA.Campo-F[6] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH T-TABLA NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH T-TABLA NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 T-TABLA
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 T-TABLA


/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 GN-DIVI.CodDiv GN-DIVI.DesDiv 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH GN-DIVI ~
      WHERE GN-DIVI.CodCia = s-codcia ~
 AND GN-DIVI.Campo-Log[1] = FALSE ~
 AND GN-DIVI.Campo-Log[5] = TRUE NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH GN-DIVI ~
      WHERE GN-DIVI.CodCia = s-codcia ~
 AND GN-DIVI.Campo-Log[1] = FALSE ~
 AND GN-DIVI.Campo-Log[5] = TRUE NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 GN-DIVI
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 GN-DIVI


/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 T-TABLA2.Llave-C ~
T-TABLA2.Campo-F[1] T-TABLA2.Campo-F[2] T-TABLA2.Campo-F[3] ~
T-TABLA2.Campo-F[4] T-TABLA2.Campo-F[5] T-TABLA2.Campo-F[6] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH T-TABLA2 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH T-TABLA2 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 T-TABLA2
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 T-TABLA2


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-3}~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-3 BROWSE-2 BROWSE-4 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Desde FILL-IN-Hasta FILL-IN-1 ~
FILL-IN-2 FILL-IN-3 FILL-IN-4 FILL-IN-5 FILL-IN-6 FILL-IN-7 FILL-IN-8 ~
FILL-IN-9 FILL-IN-10 FILL-IN-11 FILL-IN-12 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-1 AS INTEGER FORMAT "ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-10 AS INTEGER FORMAT "ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-11 AS INTEGER FORMAT "ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-12 AS INTEGER FORMAT "ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS INTEGER FORMAT "ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS INTEGER FORMAT "ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS INTEGER FORMAT "ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS INTEGER FORMAT "ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-6 AS INTEGER FORMAT "ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-7 AS INTEGER FORMAT "ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-8 AS INTEGER FORMAT "ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-9 AS INTEGER FORMAT "ZZZ,ZZ9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Semana desde el" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      T-TABLA SCROLLING.

DEFINE QUERY BROWSE-3 FOR 
      GN-DIVI SCROLLING.

DEFINE QUERY BROWSE-4 FOR 
      T-TABLA2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      T-TABLA.Llave-C COLUMN-LABEL "DOCUMENTO" FORMAT "x(8)":U
            WIDTH 12.43
      T-TABLA.Campo-F[1] COLUMN-LABEL "LUNES" FORMAT ">>>,>>9":U
            WIDTH 13
      T-TABLA.Campo-F[2] COLUMN-LABEL "MARTES" FORMAT ">>>,>>9":U
            WIDTH 13
      T-TABLA.Campo-F[3] COLUMN-LABEL "MIERCOLES" FORMAT ">>>,>>9":U
            WIDTH 13
      T-TABLA.Campo-F[4] COLUMN-LABEL "JUEVES" FORMAT ">>>,>>9":U
            WIDTH 13
      T-TABLA.Campo-F[5] COLUMN-LABEL "VIERNES" FORMAT ">>>,>>9":U
            WIDTH 13
      T-TABLA.Campo-F[6] COLUMN-LABEL "SABADO" FORMAT ">>>,>>9":U
            WIDTH 13.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 98 BY 4.04
         TITLE "NUMERO DE SKUs" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      GN-DIVI.CodDiv FORMAT "x(5)":U
      GN-DIVI.DesDiv FORMAT "X(40)":U WIDTH 84.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 94 BY 6.19
         TITLE "CENTRO DE DISTRIBUCION".

DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      T-TABLA2.Llave-C COLUMN-LABEL "DOCUMENTO" FORMAT "x(8)":U
            WIDTH 12.43
      T-TABLA2.Campo-F[1] COLUMN-LABEL "LUNES" FORMAT ">>>,>>9":U
            WIDTH 13
      T-TABLA2.Campo-F[2] COLUMN-LABEL "MARTES" FORMAT ">>>,>>9":U
            WIDTH 13
      T-TABLA2.Campo-F[3] COLUMN-LABEL "MIERCOLES" FORMAT ">>>,>>9":U
            WIDTH 13
      T-TABLA2.Campo-F[4] COLUMN-LABEL "JUEVES" FORMAT ">>>,>>9":U
            WIDTH 13
      T-TABLA2.Campo-F[5] COLUMN-LABEL "VIERNES" FORMAT ">>>,>>9":U
            WIDTH 13
      T-TABLA2.Campo-F[6] COLUMN-LABEL "SABADO" FORMAT ">>>,>>9":U
            WIDTH 13.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 98 BY 4.04
         TITLE "NUMERO DE PEDIDOS" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-3 AT ROW 1.27 COL 3 WIDGET-ID 300
     FILL-IN-Desde AT ROW 7.73 COL 25 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-Hasta AT ROW 7.73 COL 48 COLON-ALIGNED WIDGET-ID 4
     BROWSE-2 AT ROW 9.35 COL 3 WIDGET-ID 200
     FILL-IN-1 AT ROW 13.65 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     FILL-IN-2 AT ROW 13.65 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     FILL-IN-3 AT ROW 13.65 COL 44 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     FILL-IN-4 AT ROW 13.65 COL 57 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-5 AT ROW 13.65 COL 70 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     FILL-IN-6 AT ROW 13.65 COL 83 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     BROWSE-4 AT ROW 15 COL 3 WIDGET-ID 400
     FILL-IN-7 AT ROW 19.31 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     FILL-IN-8 AT ROW 19.31 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     FILL-IN-9 AT ROW 19.31 COL 44 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     FILL-IN-10 AT ROW 19.31 COL 57 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     FILL-IN-11 AT ROW 19.31 COL 70 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     FILL-IN-12 AT ROW 19.31 COL 83 COLON-ALIGNED NO-LABEL WIDGET-ID 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 102.86 BY 21.5 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: T-TABLA T "?" NO-UNDO INTEGRAL w-report
      TABLE: T-TABLA2 T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CONSULTA DE SKUs"
         HEIGHT             = 21.5
         WIDTH              = 102.86
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
/* BROWSE-TAB BROWSE-3 1 F-Main */
/* BROWSE-TAB BROWSE-2 FILL-IN-Hasta F-Main */
/* BROWSE-TAB BROWSE-4 FILL-IN-6 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-10 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-11 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-12 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-6 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-7 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-8 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-9 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Desde IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Hasta IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.T-TABLA"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.T-TABLA.Llave-C
"T-TABLA.Llave-C" "DOCUMENTO" ? "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-TABLA.Campo-F[1]
"T-TABLA.Campo-F[1]" "LUNES" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-TABLA.Campo-F[2]
"T-TABLA.Campo-F[2]" "MARTES" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-TABLA.Campo-F[3]
"T-TABLA.Campo-F[3]" "MIERCOLES" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-TABLA.Campo-F[4]
"T-TABLA.Campo-F[4]" "JUEVES" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-TABLA.Campo-F[5]
"T-TABLA.Campo-F[5]" "VIERNES" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-TABLA.Campo-F[6]
"T-TABLA.Campo-F[6]" "SABADO" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "13.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "INTEGRAL.GN-DIVI"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "GN-DIVI.CodCia = s-codcia
 AND GN-DIVI.Campo-Log[1] = FALSE
 AND GN-DIVI.Campo-Log[5] = TRUE"
     _FldNameList[1]   > INTEGRAL.GN-DIVI.CodDiv
"GN-DIVI.CodDiv" ? "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.GN-DIVI.DesDiv
"GN-DIVI.DesDiv" ? ? "character" ? ? ? ? ? ? no ? no no "84.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.T-TABLA2"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.T-TABLA2.Llave-C
"T-TABLA2.Llave-C" "DOCUMENTO" ? "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-TABLA2.Campo-F[1]
"T-TABLA2.Campo-F[1]" "LUNES" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-TABLA2.Campo-F[2]
"T-TABLA2.Campo-F[2]" "MARTES" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-TABLA2.Campo-F[3]
"T-TABLA2.Campo-F[3]" "MIERCOLES" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-TABLA2.Campo-F[4]
"T-TABLA2.Campo-F[4]" "JUEVES" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-TABLA2.Campo-F[5]
"T-TABLA2.Campo-F[5]" "VIERNES" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-TABLA2.Campo-F[6]
"T-TABLA2.Campo-F[6]" "SABADO" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "13.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME F-Main:HANDLE
       ROW             = 7.73
       COLUMN          = 67
       HEIGHT          = 1
       WIDTH           = 8
       WIDGET-ID       = 6
       HIDDEN          = no
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {EAF26C8F-9586-101B-9306-0020AF234C9D} type: CSSpin */
      CtrlFrame:MOVE-AFTER(FILL-IN-Hasta:HANDLE IN FRAME F-Main).

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONSULTA DE SKUs */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONSULTA DE SKUs */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&Scoped-define SELF-NAME BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 W-Win
ON VALUE-CHANGED OF BROWSE-3 IN FRAME F-Main /* CENTRO DE DISTRIBUCION */
DO:
  IF AVAILABLE gn-divi THEN DO:
      cCodDiv = gn-divi.CodDiv.
      RUN Carga-Temporal.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame W-Win OCX.SpinDown
PROCEDURE CtrlFrame.CSSpin.SpinDown .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN FILL-IN-Desde FILL-IN-Hasta.
    FILL-IN-Desde = FILL-IN-Desde - 7.
    FILL-IN-Hasta = FILL-IN-Desde + 5.
    DISPLAY FILL-IN-Desde FILL-IN-Hasta.
    RUN Carga-Temporal.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame W-Win OCX.SpinUp
PROCEDURE CtrlFrame.CSSpin.SpinUp .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN FILL-IN-Desde FILL-IN-Hasta.
    FILL-IN-Desde = FILL-IN-Desde + 7.
    FILL-IN-Hasta = FILL-IN-Desde + 5.
    DISPLAY FILL-IN-Desde FILL-IN-Hasta.
    RUN Carga-Temporal.
END.

END PROCEDURE.

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


DEF VAR k AS INT NO-UNDO.
DEF VAR fFchProg AS DATE NO-UNDO.
DEF VAR iNroSKU AS INT NO-UNDO.

ASSIGN
    FILL-IN-1 = 0
    FILL-IN-2 = 0
    FILL-IN-3 = 0
    FILL-IN-4 = 0
    FILL-IN-5 = 0
    FILL-IN-6 = 0.
ASSIGN
    FILL-IN-7 = 0
    FILL-IN-8 = 0
    FILL-IN-9 = 0
    FILL-IN-10 = 0
    FILL-IN-11 = 0
    FILL-IN-12 = 0.

SESSION:SET-WAIT-STATE('GENERAL').
EMPTY TEMP-TABLE T-TABLA.
EMPTY TEMP-TABLE T-TABLA2.
DO WITH FRAME {&FRAME-NAME}:
    ASSIGN FILL-IN-Desde FILL-IN-Hasta.
    fFchProg = FILL-IN-Desde.
    DO k = 1 TO 6:
        RUN Graba-Linea ("O/D", fFchProg, k).
        RUN Graba-Linea ("O/M", fFchProg, k).
        RUN Graba-Linea ("OTR", fFchProg, k).
        fFchProg = fFchProg + 1.
    END.
    FOR EACH T-TABLA NO-LOCK:
        FILL-IN-1 = FILL-IN-1 + T-TABLA.Campo-F[1].
        FILL-IN-2 = FILL-IN-2 + T-TABLA.Campo-F[2].
        FILL-IN-3 = FILL-IN-3 + T-TABLA.Campo-F[3].
        FILL-IN-4 = FILL-IN-4 + T-TABLA.Campo-F[4].
        FILL-IN-5 = FILL-IN-5 + T-TABLA.Campo-F[5].
        FILL-IN-6 = FILL-IN-6 + T-TABLA.Campo-F[6].
    END.
    DISPLAY FILL-IN-1 FILL-IN-2 FILL-IN-3 FILL-IN-4 FILL-IN-5 FILL-IN-6.
    FOR EACH T-TABLA2 NO-LOCK:
        FILL-IN-7 = FILL-IN-7 + T-TABLA2.Campo-F[1].
        FILL-IN-8 = FILL-IN-8 + T-TABLA2.Campo-F[2].
        FILL-IN-9 = FILL-IN-9 + T-TABLA2.Campo-F[3].
        FILL-IN-10 = FILL-IN-10 + T-TABLA2.Campo-F[4].
        FILL-IN-11 = FILL-IN-11 + T-TABLA2.Campo-F[5].
        FILL-IN-12 = FILL-IN-12 + T-TABLA2.Campo-F[6].
    END.
    DISPLAY FILL-IN-7 FILL-IN-8 FILL-IN-9 FILL-IN-10 FILL-IN-11 FILL-IN-12.
END.
SESSION:SET-WAIT-STATE('').
{&OPEN-QUERY-BROWSE-2}
{&OPEN-QUERY-BROWSE-4}

END PROCEDURE.

PROCEDURE Graba-Linea:

    DEF INPUT PARAMETER pCodDoc AS CHAR.
    DEF INPUT PARAMETER pFchProg AS DATE.
    DEF INPUT PARAMETER pDia AS INT.

    DEF VAR iNroSKU AS INT NO-UNDO.
    DEF VAR iNroPed AS INT NO-UNDO.

    DEF BUFFER B-DIVI FOR gn-divi.
    FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.divdes = cCodDiv
        AND Faccpedi.coddoc = pCodDoc
        AND Faccpedi.fchent = pFchProg
        AND Faccpedi.flgest = 'P':
        /* ************************************************************************** */
        /* RHC 22/01/18 Control de pedidos por FERias (Expolibreria) */
        /* ************************************************************************** */
        iNroPed = iNroPed + 1.
/*         IF pCodDoc = "O/D" THEN DO:                                                               */
/*             FIND FIRST PEDIDO WHERE PEDIDO.codcia = Faccpedi.codcia                               */
/*                 AND PEDIDO.coddiv = Faccpedi.coddiv                                               */
/*                 AND PEDIDO.coddoc = Faccpedi.codref                                               */
/*                 AND PEDIDO.nroped = Faccpedi.nroref                                               */
/*                 NO-LOCK NO-ERROR.                                                                 */
/*             IF AVAILABLE PEDIDO THEN DO:                                                          */
/*                 FIND FIRST COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia                     */
/*                     AND COTIZACION.coddiv = PEDIDO.coddiv                                         */
/*                     AND COTIZACION.coddoc = PEDIDO.codref                                         */
/*                     AND COTIZACION.nroped = PEDIDO.nroref                                         */
/*                     NO-LOCK NO-ERROR.                                                             */
/*                 IF AVAILABLE COTIZACION THEN DO:                                                  */
/*                     FIND B-DIVI WHERE B-DIVI.codcia = s-codcia                                    */
/*                         AND B-DIVI.coddiv = COTIZACION.Libre_c01      /* Lista de Precios */      */
/*                         NO-LOCK NO-ERROR.                                                         */
/*                     IF AVAILABLE B-DIVI AND B-DIVI.CanalVenta = "FER" THEN iNroPed = iNroPed + 1. */
/*                 END.                                                                              */
/*             END.                                                                                  */
/*         END.                                                                                      */
        FOR EACH Facdpedi OF Faccpedi NO-LOCK:
            iNroSKU = iNroSKU + 1.
        END.
    END.
    FIND FIRST T-TABLA WHERE T-TABLA.Llave-C = pCodDoc NO-ERROR.
    IF NOT AVAILABLE T-TABLA THEN CREATE T-TABLA.
    ASSIGN
        T-TABLA.Llave-C = pCodDoc
        T-TABLA.Campo-F[pDia] = iNroSKU.
    FIND FIRST T-TABLA2 WHERE T-TABLA2.Llave-C = pCodDoc NO-ERROR.
    IF iNroPed > 0 THEN DO:
        IF NOT AVAILABLE T-TABLA2 THEN CREATE T-TABLA2.
        ASSIGN
            T-TABLA2.Llave-C = pCodDoc
            T-TABLA2.Campo-F[pDia] = iNroPed.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load W-Win  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "w-skuxcdxsem.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
  .
  RUN DISPATCH IN THIS-PROCEDURE("initialize-controls":U) NO-ERROR.
END.
ELSE MESSAGE "w-skuxcdxsem.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

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
  DISPLAY FILL-IN-Desde FILL-IN-Hasta FILL-IN-1 FILL-IN-2 FILL-IN-3 FILL-IN-4 
          FILL-IN-5 FILL-IN-6 FILL-IN-7 FILL-IN-8 FILL-IN-9 FILL-IN-10 
          FILL-IN-11 FILL-IN-12 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-3 BROWSE-2 BROWSE-4 
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
  FILL-IN-Desde = TODAY.
  FILL-IN-Hasta = TODAY.

  REPEAT:
      IF WEEKDAY(FILL-IN-Desde) = 2 THEN LEAVE.
      FILL-IN-Desde = FILL-IN-Desde - 1.
  END.
  FILL-IN-Hasta = FILL-IN-Desde + 5.

  FOR EACH GN-DIVI WHERE GN-DIVI.CodCia = s-codcia
      AND GN-DIVI.Campo-Log[1] = FALSE
      AND GN-DIVI.Campo-Log[5] = TRUE NO-LOCK:
      cCodDiv = GN-DIVI.CodDiv.
      LEAVE.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Carga-Temporal.

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
  {src/adm/template/snd-list.i "T-TABLA2"}
  {src/adm/template/snd-list.i "GN-DIVI"}
  {src/adm/template/snd-list.i "T-TABLA"}

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

