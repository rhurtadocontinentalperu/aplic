&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-CcbCDocu NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE tt-CcbDDocu NO-UNDO LIKE CcbDDocu.



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

DEFINE TEMP-TABLE ttExcel
    FIELD   tcoddoc     AS  CHAR
    FIELD   tnrodoc     AS  CHAR
    FIELD   tcodcli     AS  CHAR
    FIELD   tnomcli     AS  CHAR
    FIELD   tcodmon     AS  CHAR
    FIELD   tcodmat     AS  CHAR
    FIELD   tcant       AS  DEC
    FIELD   timplin     AS  DEC
.

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.

DEF VAR s-coddoc AS CHAR INIT 'N/C'.
DEF VAR L-NROSER AS CHAR NO-UNDO.
DEF VAR S-NROSER AS INTEGER.

/*
DEF TEMP-TABLE t-cdocu LIKE ccbcdocu.
DEF TEMP-TABLE t-ddocu LIKE ccbddocu.
*/

FIND FIRST Faccorre WHERE  Faccorre.CodCia = S-CODCIA 
    AND Faccorre.CodDoc = S-CODDOC 
    AND Faccorre.CodDiv = S-CODDIV 
    AND Faccorre.FlgEst = YES NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccorre THEN DO:
    MESSAGE 'Correlativo no asignado a la división' s-coddiv VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

DEFINE TEMP-TABLE z-ccbcdocu LIKE ccbcdocu.
DEFINE TEMP-TABLE z-ccbddocu LIKE ccbddocu.

DEFINE BUFFER x-tt-Ccbcdocu FOR tt-Ccbcdocu.
DEFINE BUFFER x-tt-Ccbddocu FOR tt-Ccbddocu.

DEFINE VAR x-nueva-arimetica-sunat-2021 AS LOG.

x-nueva-arimetica-sunat-2021 = YES.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-12

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-CcbCDocu tt-CcbDDocu Almmmatg

/* Definitions for BROWSE BROWSE-12                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-12 tt-CcbCDocu.CodDoc ~
tt-CcbCDocu.NroDoc tt-CcbCDocu.CodCli tt-CcbCDocu.NomCli tt-CcbCDocu.FchDoc ~
tt-CcbCDocu.Libre_c01 tt-CcbCDocu.ImpVta tt-CcbCDocu.ImpIgv ~
tt-CcbCDocu.ImpTot tt-CcbCDocu.CodRef tt-CcbCDocu.NroRef 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-12 
&Scoped-define QUERY-STRING-BROWSE-12 FOR EACH tt-CcbCDocu NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-12 OPEN QUERY BROWSE-12 FOR EACH tt-CcbCDocu NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-12 tt-CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-12 tt-CcbCDocu


/* Definitions for BROWSE BROWSE-13                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-13 tt-CcbDDocu.NroItm ~
tt-CcbDDocu.codmat Almmmatg.DesMat Almmmatg.DesMar tt-CcbDDocu.CanDes ~
tt-CcbDDocu.PreUni tt-CcbDDocu.ImpIgv tt-CcbDDocu.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-13 
&Scoped-define QUERY-STRING-BROWSE-13 FOR EACH tt-CcbDDocu ~
      WHERE tt-ccbddocu.codcia = tt-ccbcdocu.codcia and ~
tt-ccbddocu.coddoc = tt-ccbcdocu.coddoc and ~
tt-ccbddocu.nrodoc = tt-ccbcdocu.nrodoc NO-LOCK, ~
      EACH Almmmatg OF tt-CcbDDocu NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-13 OPEN QUERY BROWSE-13 FOR EACH tt-CcbDDocu ~
      WHERE tt-ccbddocu.codcia = tt-ccbcdocu.codcia and ~
tt-ccbddocu.coddoc = tt-ccbcdocu.coddoc and ~
tt-ccbddocu.nrodoc = tt-ccbcdocu.nrodoc NO-LOCK, ~
      EACH Almmmatg OF tt-CcbDDocu NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-13 tt-CcbDDocu Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-13 tt-CcbDDocu
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-13 Almmmatg


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-12}~
    ~{&OPEN-QUERY-BROWSE-13}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-NroSer BUTTON-12 BUTTON-11 x-Concepto ~
x-FchDoc BROWSE-12 BROWSE-13 
&Scoped-Define DISPLAYED-OBJECTS c-NroSer FILL-IN-1 x-Mensaje x-Concepto ~
x-NomCon x-FchDoc FILL-IN-total FILL-IN-total-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-11 
     LABEL "Importar Excel" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-12 
     LABEL "Generar N/C" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE c-NroSer AS CHARACTER FORMAT "X(3)":U 
     LABEL "Nº Serie N/C" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "XXX-XXXXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-total AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-total-2 AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1
     FONT 6 NO-UNDO.

DEFINE VARIABLE x-Concepto AS CHARACTER FORMAT "x(8)" 
     LABEL "Concepto" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81.

DEFINE VARIABLE x-FchDoc AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha para las N/C" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81 NO-UNDO.

DEFINE VARIABLE x-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCon AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 67 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-12 FOR 
      tt-CcbCDocu SCROLLING.

DEFINE QUERY BROWSE-13 FOR 
      tt-CcbDDocu, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-12 W-Win _STRUCTURED
  QUERY BROWSE-12 NO-LOCK DISPLAY
      tt-CcbCDocu.CodDoc FORMAT "x(3)":U
      tt-CcbCDocu.NroDoc FORMAT "X(12)":U WIDTH 10.43
      tt-CcbCDocu.CodCli FORMAT "x(11)":U
      tt-CcbCDocu.NomCli FORMAT "x(50)":U WIDTH 39.29
      tt-CcbCDocu.FchDoc FORMAT "99/99/9999":U
      tt-CcbCDocu.Libre_c01 COLUMN-LABEL "Moneda" FORMAT "x(10)":U
      tt-CcbCDocu.ImpVta FORMAT "->>,>>>,>>9.99":U
      tt-CcbCDocu.ImpIgv FORMAT "->>,>>>,>>9.99":U
      tt-CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U WIDTH 14.86
      tt-CcbCDocu.CodRef COLUMN-LABEL "Cod.Ref" FORMAT "x(3)":U
      tt-CcbCDocu.NroRef COLUMN-LABEL "Nro. Ref." FORMAT "X(12)":U
            WIDTH 22.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 152.86 BY 7.73 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-13 W-Win _STRUCTURED
  QUERY BROWSE-13 NO-LOCK DISPLAY
      tt-CcbDDocu.NroItm FORMAT ">>9":U
      tt-CcbDDocu.codmat FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "X(45)":U
      Almmmatg.DesMar FORMAT "X(30)":U
      tt-CcbDDocu.CanDes FORMAT ">,>>>,>>9.99":U
      tt-CcbDDocu.PreUni FORMAT ">,>>>,>>9.999999":U
      tt-CcbDDocu.ImpIgv FORMAT ">,>>>,>>9.9999":U
      tt-CcbDDocu.ImpLin FORMAT "->>,>>>,>>9.99":U WIDTH 15.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 153 BY 12.31 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     c-NroSer AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 72
     FILL-IN-1 AT ROW 1.27 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     x-Mensaje AT ROW 1.27 COL 49 COLON-ALIGNED NO-LABEL WIDGET-ID 86
     BUTTON-12 AT ROW 1.58 COL 110 WIDGET-ID 4
     BUTTON-11 AT ROW 1.58 COL 127 WIDGET-ID 2
     x-Concepto AT ROW 2.31 COL 19 COLON-ALIGNED WIDGET-ID 82
     x-NomCon AT ROW 2.31 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 88
     x-FchDoc AT ROW 3.19 COL 19 COLON-ALIGNED WIDGET-ID 84
     BROWSE-12 AT ROW 4.15 COL 2.14 WIDGET-ID 200
     FILL-IN-total AT ROW 7.23 COL 154 COLON-ALIGNED NO-LABEL WIDGET-ID 90
     FILL-IN-total-2 AT ROW 9.77 COL 154 COLON-ALIGNED NO-LABEL WIDGET-ID 94
     BROWSE-13 AT ROW 11.92 COL 2 WIDGET-ID 300
     "TOTAL $" VIEW-AS TEXT
          SIZE 15.43 BY .62 AT ROW 9.04 COL 156.57 WIDGET-ID 96
          FGCOLOR 4 FONT 11
     "TOTAL S/" VIEW-AS TEXT
          SIZE 15.43 BY .62 AT ROW 6.5 COL 156.57 WIDGET-ID 92
          FGCOLOR 4 FONT 11
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 174.86 BY 23.42 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-CcbCDocu T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: tt-CcbDDocu T "?" NO-UNDO INTEGRAL CcbDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Generacion de Notas de Credito detallado"
         HEIGHT             = 23.42
         WIDTH              = 174.86
         MAX-HEIGHT         = 24.08
         MAX-WIDTH          = 174.86
         VIRTUAL-HEIGHT     = 24.08
         VIRTUAL-WIDTH      = 174.86
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
/* BROWSE-TAB BROWSE-12 x-FchDoc F-Main */
/* BROWSE-TAB BROWSE-13 FILL-IN-total-2 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-total IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-total-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomCon IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-12
/* Query rebuild information for BROWSE BROWSE-12
     _TblList          = "Temp-Tables.tt-CcbCDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.tt-CcbCDocu.CodDoc
     _FldNameList[2]   > Temp-Tables.tt-CcbCDocu.NroDoc
"tt-CcbCDocu.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.tt-CcbCDocu.CodCli
     _FldNameList[4]   > Temp-Tables.tt-CcbCDocu.NomCli
"tt-CcbCDocu.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "39.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.tt-CcbCDocu.FchDoc
     _FldNameList[6]   > Temp-Tables.tt-CcbCDocu.Libre_c01
"tt-CcbCDocu.Libre_c01" "Moneda" "x(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = Temp-Tables.tt-CcbCDocu.ImpVta
     _FldNameList[8]   = Temp-Tables.tt-CcbCDocu.ImpIgv
     _FldNameList[9]   > Temp-Tables.tt-CcbCDocu.ImpTot
"tt-CcbCDocu.ImpTot" ? ? "decimal" ? ? ? ? ? ? no ? no no "14.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-CcbCDocu.CodRef
"tt-CcbCDocu.CodRef" "Cod.Ref" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tt-CcbCDocu.NroRef
"tt-CcbCDocu.NroRef" "Nro. Ref." ? "character" ? ? ? ? ? ? no ? no no "22.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-12 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-13
/* Query rebuild information for BROWSE BROWSE-13
     _TblList          = "Temp-Tables.tt-CcbDDocu,INTEGRAL.Almmmatg OF Temp-Tables.tt-CcbDDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "tt-ccbddocu.codcia = tt-ccbcdocu.codcia and
tt-ccbddocu.coddoc = tt-ccbcdocu.coddoc and
tt-ccbddocu.nrodoc = tt-ccbcdocu.nrodoc"
     _FldNameList[1]   = Temp-Tables.tt-CcbDDocu.NroItm
     _FldNameList[2]   = Temp-Tables.tt-CcbDDocu.codmat
     _FldNameList[3]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[4]   = INTEGRAL.Almmmatg.DesMar
     _FldNameList[5]   > Temp-Tables.tt-CcbDDocu.CanDes
"tt-CcbDDocu.CanDes" ? ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = Temp-Tables.tt-CcbDDocu.PreUni
     _FldNameList[7]   = Temp-Tables.tt-CcbDDocu.ImpIgv
     _FldNameList[8]   > Temp-Tables.tt-CcbDDocu.ImpLin
"tt-CcbDDocu.ImpLin" ? ? "decimal" ? ? ? ? ? ? no ? no no "15.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-13 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Generacion de Notas de Credito detallado */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Generacion de Notas de Credito detallado */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-12
&Scoped-define SELF-NAME BROWSE-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-12 W-Win
ON VALUE-CHANGED OF BROWSE-12 IN FRAME F-Main
DO:
    {&open-query-browse-13}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-11 W-Win
ON CHOOSE OF BUTTON-11 IN FRAME F-Main /* Importar Excel */
DO:
    ASSIGN
        c-NroSer x-Concepto x-NomCon x-FchDoc .
    /* Consistencias */
    IF x-Concepto = '' THEN DO:
        MESSAGE 'Ingrese el código del concepto'
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF x-FchDoc = ? THEN DO:
        MESSAGE 'Ingrese la fecha para las Notas de Crédito'
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                              ccbcdocu.coddoc = 'N/C' AND 
                              ccbcdocu.nrodoc BEGINS c-NroSer AND
                              ccbcdocu.fchdoc > x-FchDoc NO-LOCK NO-ERROR.
    IF AVAILABLE ccbcdocu THEN DO:
        MESSAGE 'Ya existen documentos generados con fecha superior a la indicada'
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
  
    RUN cargar-excel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-12 W-Win
ON CHOOSE OF BUTTON-12 IN FRAME F-Main /* Generar N/C */
DO:
    DEFINE VAR x-serie AS CHAR.  

    ASSIGN
        c-NroSer x-Concepto x-NomCon x-FchDoc .
    /* Consistencias */
    IF x-Concepto = '' THEN DO:
        MESSAGE 'Ingrese el código del concepto'
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF x-FchDoc = ? THEN DO:
        MESSAGE 'Ingrese la fecha para las Notas de Crédito'
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                              ccbcdocu.coddoc = 'N/C' AND 
                              ccbcdocu.nrodoc BEGINS c-NroSer AND
                              ccbcdocu.fchdoc > x-FchDoc NO-LOCK NO-ERROR.
    IF AVAILABLE ccbcdocu THEN DO:
        MESSAGE 'Ya existen documentos generados con fecha superior a la indicada'
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
  
    MESSAGE 'Se van a generar las Notas de Crédito' SKIP(1)
        'N° de Serie:' c-NroSer SKIP
        'Concepto:' x-Concepto x-NomCon SKIP
        'Fecha de las N/C' x-FchDoc SKIP(1)
        'Continuamos con la generación?'
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
        UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.

    RUN grabar-data.

    IF AVAILABLE(Faccorre) THEN RELEASE Faccorre.
    IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
    IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-NroSer W-Win
ON VALUE-CHANGED OF c-NroSer IN FRAME F-Main /* Nº Serie N/C */
DO:
  ASSIGN {&SELF-NAME}.
  FIND Faccorre WHERE codcia = s-codcia
      AND coddoc = s-coddoc
      AND nroser = INTEGER(SELF:SCREEN-VALUE)
      NO-LOCK.
  /*
/*   FILL-IN-1:SCREEN-VALUE = STRING(Faccorre.nroser,'999') + STRING(Faccorre.correlativo, '999999'). */
  FILL-IN-1:SCREEN-VALUE = STRING(Faccorre.nroser, ENTRY(1, x-Formato, '-')) +
                                  STRING(Faccorre.correlativo, ENTRY(2, x-Formato, '-')).
    */                                  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Concepto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Concepto W-Win
ON LEAVE OF x-Concepto IN FRAME F-Main /* Concepto */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia AND 
        CcbTabla.Tabla  = s-coddoc AND 
        CcbTabla.Codigo = SELF:SCREEN-VALUE AND 
        CcbTabla.Reservado = NO 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE CcbTabla THEN DO:
        MESSAGE 'Concepto no registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    x-NomCon:SCREEN-VALUE = CcbTabla.nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Concepto W-Win
ON LEFT-MOUSE-DBLCLICK OF x-Concepto IN FRAME F-Main /* Concepto */
OR F8 OF x-Concepto
DO:
    
    ASSIGN
        input-var-1 = s-coddoc
        input-var-2 = ""
        input-var-3 = "".
    RUN LKUP\C-ABOCAR-3 ('Conceptos para Notas de Crédito').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-excel W-Win 
PROCEDURE cargar-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-Archivo AS CHAR.
DEFINE VAR rpta AS LOG.
                                
SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Excel (*.xls)' '*.xls,*.xlsx'
    DEFAULT-EXTENSION '.xls'
    RETURN-TO-START-DIR
    TITLE 'Importar Excel'
    UPDATE rpta.
IF rpta = NO OR x-Archivo = '' THEN RETURN.


DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

DEFINE VAR xCaso AS CHAR.
DEFINE VAR xFamilia AS CHAR.
DEFINE VAR xSubFamilia AS CHAR.
DEFINE VAR lLinea AS INT.
DEFINE VAR dValor AS DEC.
DEFINE VAR lTpoCmb AS DEC.

DEFINE VAR x-duplicados AS INT.

DEFINE VAR x-total AS DEC INIT 0.
DEFINE VAR x-total2 AS DEC INIT 0.

lFileXls = x-Archivo.   /*"D:\xpciman\rsalas-facturasV4b.xlsx".*/
lNuevoFile = NO.                            /* Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = YES.        /* Si permanece abierto el Excel luego de concluir el proceso */

chWorkSheet = chExcelApplication:Sheets:Item(1).

iColumn = 1.
lLinea = 1.

DO WITH FRAME {&FRAME-NAME}:
   button-12:VISIBLE = FALSE.
END.


SESSION:SET-WAIT("GENERAL").

cColumn = STRING(lLinea).
REPEAT iColumn = 2 TO 65000 :
    cColumn = STRING(iColumn).

    x-mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cColumn.

    cRange = "A" + cColumn.
    xCaso = chWorkSheet:Range(cRange):TEXT.

    IF xCaso = "" OR xCaso = ? THEN LEAVE.    /* FIN DE DATOS */

    CREATE ttExcel.
        ASSIGN  ttExcel.tcoddoc = xCaso
                ttExcel.tnrodoc = chWorkSheet:Range("B" + cColumn):TEXT
                ttExcel.tcodcli = chWorkSheet:Range("E" + cColumn):TEXT.
                ttExcel.tnomcli = chWorkSheet:Range("F" + cColumn):TEXT.
                ttExcel.tcodmon = chWorkSheet:Range("M" + cColumn):TEXT.
                ttExcel.tcodmat = chWorkSheet:Range("Q" + cColumn):TEXT.
                ttExcel.tcant = DEC(TRIM(chWorkSheet:Range("U" + cColumn):TEXT)).
                ttExcel.timplin = DEC(TRIM(chWorkSheet:Range("AK" + cColumn):TEXT)).
    .
END.

{lib\excel-close-file.i}

EMPTY TEMP-TABLE tt-ccbcdocu.
EMPTY TEMP-TABLE tt-ccbddocu.

DEFINE VAR x-correlativo AS INT INIT 0.
DEFINE VAR x-item AS INT INIT 0.
DEFINE VAR x-codmon AS INT.
DEFINE VAR x-documento-ok AS LOG INIT NO.
DEFINE VAR x-ImpBrt AS DEC.
DEFINE VAR x-ImpExo AS DEC.
DEFINE VAR x-ImpIgv AS DEC.
DEFINE VAR x-ImpTot AS DEC.

DEFINE VAR x-proceso-ok AS LOG.

DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER x-ccbddocu FOR ccbddocu.

FIND FIRST Faccfggn WHERE Faccfggn.codcia = s-codcia NO-LOCK.

DEFINE VAR x-tolerancia-nc-pnc-articulo AS INT.
DEFINE VAR x-articulo-con-notas-de-credito AS INT.
DEFINE VAR x-valida1 AS LOG.

/* ----- */
DEFINE VAR hProc AS HANDLE NO-UNDO.         /* Handle Libreria */

RUN ccb\libreria-ccb.r PERSISTENT SET hProc.

/* Procedimientos */
x-tolerancia-nc-pnc-articulo = 0.
RUN maximo-nc-pnc-x-articulo IN hProc (INPUT x-Concepto, OUTPUT x-tolerancia-nc-pnc-articulo).  


x-proceso-ok = YES.
x-valida1 = YES.

FOR EACH ttExcel BREAK BY tcoddoc BY tnrodoc :
    x-mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ttExcel.tnrodoc + " / "  + ttExcel.tcodmat.
    IF FIRST-OF(ttExcel.tcoddoc) OR FIRST-OF(ttExcel.tnrodoc) THEN DO:

        x-documento-ok = NO.
        x-item = 0.
        x-ImpBrt = 0.
        x-ImpExo = 0.
        x-ImpIgv = 0.
        x-ImpTot = 0.

        FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                x-ccbcdocu.coddoc = ttExcel.tcoddoc AND
                x-ccbcdocu.nrodoc = ttExcel.tnrodoc NO-LOCK NO-ERROR.
        IF AVAILABLE x-ccbcdocu THEN DO:        

            x-correlativo = x-correlativo + 1.
            x-codmon = IF(ttExcel.tcodmon = 'SOLES') THEN 1 ELSE 2.

            CREATE tt-ccbcdocu.
            ASSIGN tt-Ccbcdocu.codcia = s-codcia
            tt-Ccbcdocu.coddiv = s-coddiv
            tt-Ccbcdocu.coddoc = 'N/C'
            tt-Ccbcdocu.nrodoc = STRING(x-correlativo,"99999999")
            tt-Ccbcdocu.fchdoc = x-FchDoc       /* OJO */
            tt-Ccbcdocu.fchvto = ADD-INTERVAL (x-FchDoc, 1, 'years')
            tt-Ccbcdocu.codcli = x-ccbcdocu.codcli
            tt-Ccbcdocu.ruccli = x-ccbcdocu.ruccli
            tt-Ccbcdocu.nomcli = x-ccbcdocu.nomcli
            tt-Ccbcdocu.dircli = x-ccbcdocu.dircli
            tt-Ccbcdocu.porigv = ( IF x-ccbcdocu.porigv > 0 THEN x-ccbcdocu.porigv ELSE FacCfgGn.PorIgv )
            tt-Ccbcdocu.codmon = x-CodMon
            tt-Ccbcdocu.usuario = s-user-id
            tt-Ccbcdocu.tpocmb = Faccfggn.tpocmb[1]
            tt-Ccbcdocu.codref = x-ccbcdocu.coddoc
            tt-Ccbcdocu.nroref = x-ccbcdocu.nrodoc
            tt-Ccbcdocu.codven = x-ccbcdocu.codven
            tt-Ccbcdocu.cndcre = 'N'
            tt-Ccbcdocu.fmapgo = x-ccbcdocu.fmapgo
            tt-Ccbcdocu.tpofac = "OTROS"
            tt-Ccbcdocu.codcta = x-Concepto
            tt-Ccbcdocu.tipo   = "CREDITO"
            tt-Ccbcdocu.codcaja= ""
            tt-Ccbcdocu.FlgEst = 'X'   /* POR APROBAR */
            tt-Ccbcdocu.ImpBrt = 0
            tt-Ccbcdocu.ImpExo = 0
            tt-Ccbcdocu.ImpDto = 0
            tt-Ccbcdocu.ImpIgv = 0
            tt-Ccbcdocu.ImpTot = 0
            tt-ccbcdocu.libre_c01 = ttExcel.tcodmon            
            NO-ERROR.

        IF ERROR-STATUS:ERROR THEN DO:
            x-documento-ok = NO.
            x-mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ttExcel.tnrodoc + " / ERROR".
            x-proceso-ok = NO.
        END.
        ELSE DO: 
            x-documento-ok = YES.
        END.

        FIND GN-VEN WHERE GN-VEN.codcia = s-codcia
            AND GN-VEN.codven = tt-Ccbcdocu.codven NO-LOCK NO-ERROR.
        IF AVAILABLE GN-VEN THEN tt-Ccbcdocu.cco = GN-VEN.cco.

      END.
    END.
    IF x-documento-ok = YES THEN DO:
        /* Detalle */

        x-item = x-item + 1.

        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                    almmmatg.codmat = ttExcel.tcodmat NO-LOCK NO-ERROR.

        FIND FIRST x-ccbddocu OF x-ccbcdocu WHERE x-ccbddocu.codmat = tcodmat NO-LOCK NO-ERROR.

        x-articulo-con-notas-de-credito = 0.
        /* Ic - 15Nov2019 - Validar cuantas N/C y/o PNC sin aprobar tiene el articulo */
        RUN articulo-con-notas-de-credito IN hProc (INPUT x-Concepto, 
                                                INPUT tcodmat,
                                                INPUT x-ccbddocu.coddoc,
                                                INPUT x-ccbddocu.nrodoc,
                                                OUTPUT x-articulo-con-notas-de-credito).
                                                
        IF x-articulo-con-notas-de-credito >= x-tolerancia-nc-pnc-articulo THEN DO:
            /* El articulo ya tiene N/C y/o PNC (pendientes x aprobar) y llego al limite */
            x-valida1 = NO.
            NEXT.            
        END.   


        CREATE tt-Ccbddocu.
        BUFFER-COPY tt-Ccbcdocu TO tt-Ccbddocu.
        ASSIGN
            tt-Ccbddocu.codmat = ttExcel.tcodmat
            tt-Ccbddocu.factor = if(AVAILABLE x-ccbddocu) THEN x-ccbddocu.factor ELSE 1
            tt-Ccbddocu.candes = ttExcel.tcant
            tt-Ccbddocu.preuni = ttExcel.timplin / ttExcel.tcant.
        ASSIGN
            tt-Ccbddocu.implin = ttExcel.timplin.
        IF almmmatg.aftigv THEN DO:
            ASSIGN
            tt-Ccbddocu.AftIgv = Yes
            tt-Ccbddocu.ImpIgv = ttExcel.timplin - (ttExcel.timplin / (1 + (tt-Ccbcdocu.PorIgv / 100))).
        END.
        ELSE DO:
            ASSIGN
            tt-Ccbddocu.AftIgv = No
            tt-Ccbddocu.ImpIgv = 0.
            tt-Ccbddocu.NroItm = x-item.
        END.
        IF tt-Ccbddocu.AftIgv = YES THEN x-ImpBrt = x-ImpBrt + ttExcel.timplin.
        IF tt-Ccbddocu.AftIgv = NO THEN x-ImpExo = x-ImpExo + ttExcel.timplin.
        x-ImpIgv = x-ImpIgv + tt-Ccbddocu.ImpIgv.
        x-ImpTot = x-ImpTot + tt-Ccbddocu.ImpLin.

        IF ttExcel.tcodmon = 'SOLES' THEN DO:
            x-total = x-total + tt-Ccbddocu.ImpLin.
        END.
        ELSE DO:
            x-total2 = x-total2 + tt-Ccbddocu.ImpLin.
        END.
        
        IF LAST-OF(ttExcel.tcoddoc) OR LAST-OF(ttExcel.tnrodoc) THEN DO:
            ASSIGN
                tt-Ccbcdocu.ImpBrt = x-impbrt
                tt-Ccbcdocu.ImpExo = x-impexo
                tt-Ccbcdocu.ImpIgv = x-ImpIgv
                tt-Ccbcdocu.ImpTot = x-ImpTot
                tt-Ccbcdocu.ImpVta = tt-Ccbcdocu.ImpBrt - tt-Ccbcdocu.ImpIgv
                tt-Ccbcdocu.ImpBrt = tt-Ccbcdocu.ImpBrt - tt-Ccbcdocu.ImpIgv
                tt-Ccbcdocu.SdoAct = tt-Ccbcdocu.ImpTot
            .
        END.
    END.
END.

DELETE PROCEDURE hProc.                 /* Release Libreria */

/* Eliminamos los importes totales en CERO */
FOR EACH tt-Ccbcdocu WHERE tt-Ccbcdocu.ImpTot = 0:
    FOR EACH tt-Ccbddocu OF tt-Ccbcdocu :
        DELETE tt-Ccbddocu.
    END.
    DELETE tt-Ccbcdocu.
END.
FOR EACH tt-Ccbcdocu :
    FOR EACH tt-Ccbddocu OF tt-Ccbcdocu :
        IF tt-Ccbddocu.implin = 0 THEN DO:
            DELETE tt-Ccbddocu.
        END.        
    END.
END.

/* Correlativo de Item */
FOR EACH tt-Ccbcdocu :
    x-item = 0.
    FOR EACH tt-Ccbddocu OF tt-Ccbcdocu :
        x-item = x-item + 1.
        ASSIGN tt-Ccbddocu.NroItm = x-item.
    END.
END.

/* Ic - 16Dic2019, validar que las referencias no esten repetidas */

DUPLICADOS:
FOR EACH tt-Ccbcdocu NO-LOCK:
    x-duplicados = 0.
    FOR EACH x-tt-Ccbcdocu WHERE x-tt-Ccbcdocu.codref = tt-Ccbcdocu.codref AND
                                    x-tt-Ccbcdocu.nroref = tt-Ccbcdocu.nroref :
        x-duplicados = x-duplicados + 1.
    END.
    IF x-duplicados > 1 THEN DO:
        x-duplicados = -99.
        LEAVE DUPLICADOS.
    END.    
END.
IF x-duplicados = -99 THEN DO:
    MESSAGE "No deben existir FACTURAS/BOLETAS referenciadas en mas de una vez" SKIP
            "Por favor, garantize la correcta informacion" SKIP
    x-valida1 = YES.
    x-proceso-ok = NO.
END.

/**/

FILL-IN-total:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-total,"->>,>>>,>>9.99").
FILL-IN-total-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-total2,"->>,>>>,>>9.99").

{&open-query-browse-12}
{&open-query-browse-13}

IF x-valida1 = NO OR x-proceso-ok = NO THEN DO:
    IF x-valida1 = YES THEN DO:
        MESSAGE "Existieron Problemas al cargar el Excel " SKIP
                "Por favor, corregir el Excel " SKIP
                "y vuelva a procesar" VIEW-AS ALERT-BOX ERROR.
    END.
    ELSE DO:
        MESSAGE "Existen articulos que nose pueden generar en mas de una N/C " SKIP
                "Por favor, corregir el Excel " SKIP
                "y vuelva a procesar" VIEW-AS ALERT-BOX ERROR.
    END.

     DO WITH FRAME {&FRAME-NAME}:
       button-12:VISIBLE = FALSE.
    END.

END.
ELSE DO:
     DO WITH FRAME {&FRAME-NAME}:
       button-12:VISIBLE = TRUE.
    END.
END.

/*
    DEFINE VAR hProc AS HANDLE NO-UNDO.

    RUN lib\Tools-to-excel PERSISTENT SET hProc.

    def var c-csv-file as char no-undo.
    def var c-xls-file as char no-undo. /* will contain the XLS file path created */

    c-xls-file = 'd:\xpciman\tt-ccbddocu.xlsx'.

    run pi-crea-archivo-csv IN hProc (input  buffer tt-Ccbcdocu:handle,
                            /*input  session:temp-directory + "file"*/ c-xls-file,
                            output c-csv-file) .

    run pi-crea-archivo-xls  IN hProc (input  buffer tt-Ccbcdocu:handle,
                            input  c-csv-file,
                            output c-xls-file) .

    DELETE PROCEDURE hProc.
*/

SESSION:SET-WAIT("").

END PROCEDURE.
/*
            tt-Ccbcdocu.nrodoc = STRING(Faccorre.nroser, ENTRY(1, x-Formato, '-')) + 
                                STRING(Faccorre.correlativo, ENTRY(2, x-Formato, '-'))

    FIELD   tcoddoc     AS  CHAR
    FIELD   tnrodoc     AS  CHAR
    FIELD   tcodcli     AS  CHAR
    FIELD   tnomcli     AS  CHAR
    FIELD   tcodmon     AS  CHAR
    FIELD   tcodmat     AS  CHAR
    FIELD   tcant       AS  DEC
    FIELD   timplin     AS  DEC

        FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
            ASSIGN
                Ccbcdocu.ImpBrt = Ccbcdocu.ImpBrt + (IF Ccbddocu.AftIgv = Yes THEN Ccbddocu.PreUni * Ccbddocu.CanDes ELSE 0)
                Ccbcdocu.ImpExo = Ccbcdocu.ImpExo + (IF Ccbddocu.AftIgv = No  THEN Ccbddocu.PreUni * Ccbddocu.CanDes ELSE 0)
                Ccbcdocu.ImpDto = Ccbcdocu.ImpDto + Ccbddocu.ImpDto
                Ccbcdocu.ImpIgv = Ccbcdocu.ImpIgv + Ccbddocu.ImpIgv
                Ccbcdocu.ImpTot = Ccbcdocu.ImpTot + Ccbddocu.ImpLin.
        END.
        ASSIGN 
            Ccbcdocu.ImpVta = Ccbcdocu.ImpBrt - Ccbcdocu.ImpIgv
            Ccbcdocu.ImpBrt = Ccbcdocu.ImpBrt - Ccbcdocu.ImpIgv + Ccbcdocu.ImpDto
            Ccbcdocu.SdoAct = Ccbcdocu.ImpTot
            Ccbcdocu.FlgEst = 'P'.   /* APROBADO */
        /* RHC 02/10/2018 PROBLEMAS EN EL PARAISO: sugerido por C.I.
            Va a necesitar un proceso posterior de aprobación */


*/

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
  DISPLAY c-NroSer FILL-IN-1 x-Mensaje x-Concepto x-NomCon x-FchDoc 
          FILL-IN-total FILL-IN-total-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE c-NroSer BUTTON-12 BUTTON-11 x-Concepto x-FchDoc BROWSE-12 BROWSE-13 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-data W-Win 
PROCEDURE grabar-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEFINE VAR x-serie AS INT.                           
DEFINE VAR x-numero AS INT.
DEFINE VAR x-retval AS CHAR.

SESSION:SET-WAIT-STATE("GENERAL").

DEFINE VAR hxProc AS HANDLE NO-UNDO.            /* Handle Libreria */
RUN ccb\libreria-ccb.r PERSISTENT SET hxProc.

FOR EACH tt-ccbcdocu :
                                                     
    RUN notas-creditos-supera-comprobante IN hxProc (INPUT tt-ccbcdocu.Codref, 
                                                 INPUT tt-ccbcdocu.nroref,
                                                 OUTPUT x-retval).
    
    /* 
        pRetVal : NO (importes de N/C NO supera al comprobante)
    */

    IF x-retval = "NO" THEN DO:    
        GRABAR_DOC:
        DO TRANSACTION ON ERROR UNDO GRABAR_DOC, LEAVE GRABAR_DOC:
            DO:
                /* Header update block */
                FIND FIRST faccorre WHERE FacCorre.codcia = s-codcia AND
                                            FacCorre.coddoc = s-coddoc AND
                                            FacCorre.nroser = INTEGER(c-NroSer)
                                            EXCLUSIVE-LOCK NO-ERROR.
                IF LOCKED faccorre THEN DO:
                    UNDO GRABAR_DOC, LEAVE GRABAR_DOC.
                END.                                  
                ELSE DO:
                    IF NOT AVAILABLE faccorre THEN DO:
                        UNDO GRABAR_DOC, LEAVE GRABAR_DOC.
                    END.
                END.
    
                x-serie = FacCorre.nroser.
                x-numero = Faccorre.correlativo.
                ASSIGN
                    Faccorre.correlativo = Faccorre.correlativo + 1.
    
                /* Reset */
                EMPTY TEMP-TABLE z-ccbcdocu.            
    
                CREATE z-ccbcdocu.
                BUFFER-COPY tt-ccbcdocu EXCEPT nrodoc TO z-ccbcdocu.
                    ASSIGN z-ccbcdocu.nrodoc = STRING(x-serie,"999") + STRING(x-numero,"99999999").
    
                /* GRABO HDR */
                CREATE ccbcdocu.
                BUFFER-COPY z-ccbcdocu TO ccbcdocu NO-ERROR.
                IF ERROR-STATUS:ERROR THEN DO:
                    UNDO GRABAR_DOC, LEAVE GRABAR_DOC.
                END.
    
            END.
            FOR EACH tt-ccbddocu OF tt-ccbcdocu ON ERROR UNDO, THROW:
    
                EMPTY TEMP-TABLE z-ccbddocu.
    
                /* Detalle update block */
                CREATE z-ccbddocu.
                BUFFER-COPY tt-ccbddocu EXCEPT nrodoc TO z-ccbddocu.
                    ASSIGN z-ccbddocu.nrodoc = STRING(x-serie,"999") + STRING(x-numero,"99999999").
    
                /* GRABO DTL */
                CREATE ccbddocu.
                BUFFER-COPY z-ccbddocu TO ccbddocu NO-ERROR.
                IF ERROR-STATUS:ERROR THEN DO:
                    UNDO GRABAR_DOC, LEAVE GRABAR_DOC.
                END.
    
            END.
    
            /**/
            ASSIGN tt-ccbcdocu.libre_c05 = "OK".
    
        END. /* TRANSACTION block */
        RELEASE ccbcdocu.
        RELEASE ccbddocu.
    END.
END.

DEF VAR hProc AS HANDLE NO-UNDO.
DEFINE VAR pMensaje AS CHAR NO-UNDO.

FOR EACH tt-ccbcdocu WHERE tt-ccbcdocu.libre_c05 = "OK" :

    /* ****************************** */
    /* Ic - 16Nov2021 - Importes Arimetica de SUNAT */
    /* ****************************** */
    IF x-nueva-arimetica-sunat-2021 = YES THEN DO:
        RUN sunat/sunat-calculo-importes.r PERSISTENT SET hProc.
        RUN tabla-ccbcdocu IN hProc (INPUT tt-Ccbcdocu.CodDiv,
                                     INPUT tt-Ccbcdocu.CodDoc,
                                     INPUT tt-Ccbcdocu.NroDoc,
                                     OUTPUT pMensaje).
        /*IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.*/
    END.    
    /* ****************************** */


    FOR EACH tt-ccbddocu OF tt-ccbcdocu:
        DELETE tt-ccbddocu.
    END.
    DELETE tt-ccbcdocu.
END.
DELETE PROCEDURE hProc.

{&open-query-browse-12}
{&open-query-browse-13}

SESSION:SET-WAIT-STATE("").

FIND FIRST tt-ccbcdocu NO-ERROR.
IF AVAILABLE tt-ccbcdocu THEN DO:
    MESSAGE "Se quedaron algunos documentos sin generar N/C" SKIP
                "Por favor vuelva a Generar N/C"
                VIEW-AS ALERT-BOX INFORMATION.
END.

DELETE PROCEDURE hxProc.                        /* Release Libreria */

END PROCEDURE.

/*
    {lib/lock-genericov3.i
        &Tabla="FacCorre"
        &Condicion="FacCorre.codcia = s-codcia ~
        AND FacCorre.coddoc = s-coddoc ~
        AND FacCorre.nroser = INTEGER(c-NroSer)" 
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, RETURN ERROR"
        }

*/

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
  L-NROSER = "".
  FOR EACH Faccorre NO-LOCK WHERE 
           Faccorre.CodCia = S-CODCIA AND
           Faccorre.CodDoc = S-CODDOC AND
           Faccorre.CodDiv = S-CODDIV AND
           Faccorre.FlgEst = YES AND
           FacCorre.ID_Pos <> "MOSTRADOR":
      IF L-NROSER = "" THEN L-NROSER = STRING(Faccorre.NroSer,"999").
      ELSE L-NROSER = L-NROSER + "," + STRING(Faccorre.NroSer,"999").
  END.
  DO WITH FRAME {&FRAME-NAME}:
     C-NroSer:LIST-ITEMS = L-NROSER.
     S-NROSER = INTEGER(ENTRY(1,C-NroSer:LIST-ITEMS)).
     C-NROSER = ENTRY(1,C-NroSer:LIST-ITEMS).
     DISPLAY C-NROSER.
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
  {src/adm/template/snd-list.i "tt-CcbDDocu"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "tt-CcbCDocu"}

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

