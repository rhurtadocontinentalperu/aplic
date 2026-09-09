&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-DMvto-1 NO-UNDO LIKE CcbDMvto.
DEFINE TEMP-TABLE T-DMvto-2 NO-UNDO LIKE CcbDMvto.



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

DEF VAR S-NROSER AS INTEGER.
DEF VAR s-coddoc AS CHAR INIT 'N/C' NO-UNDO.
DEF VAR L-NROSER AS CHAR NO-UNDO.

/* CORRELATIVO */
FIND FIRST FacCorre WHERE codcia = s-codcia
    AND coddiv = s-coddiv
    AND coddoc = s-coddoc
    AND flgest = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE "Correlativo del Documento no configurado" VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

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
&Scoped-define INTERNAL-TABLES T-DMvto-1 T-DMvto-2 CcbCDocu

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 T-DMvto-1.NroMes T-DMvto-1.FchEmi ~
T-DMvto-1.CodRef T-DMvto-1.NroRef T-DMvto-1.ImpDoc T-DMvto-1.DepNac[1] ~
T-DMvto-1.ImpInt T-DMvto-1.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH T-DMvto-1 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH T-DMvto-1 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 T-DMvto-1
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 T-DMvto-1


/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 T-DMvto-2.NroMes T-DMvto-2.FchEmi ~
T-DMvto-2.CodRef T-DMvto-2.NroRef T-DMvto-2.ImpDoc T-DMvto-2.ImpInt ~
T-DMvto-2.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH T-DMvto-2 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH T-DMvto-2 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 T-DMvto-2
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 T-DMvto-2


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-3}
&Scoped-define QUERY-STRING-F-Main FOR EACH CcbCDocu SHARE-LOCK
&Scoped-define OPEN-QUERY-F-Main OPEN QUERY F-Main FOR EACH CcbCDocu SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-F-Main CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-F-Main CcbCDocu


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-NroSer x-CodCli BUTTON-2 x-Fecha-1 ~
x-Fecha-2 x-PorReb x-CodMon x-Concepto BROWSE-2 BROWSE-3 BUTTON-3 BUTTON-4 ~
BtnDone-2 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS c-NroSer FILL-IN-1 x-Mensaje x-CodCli ~
x-NomCli x-Fecha-1 x-Fecha-2 x-PorReb x-CodMon x-Concepto x-NomCon F-ImpTot 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     LABEL "&SALIR" 
     SIZE 15 BY 1.12
     BGCOLOR 8 .

DEFINE BUTTON BtnDone-2 DEFAULT 
     LABEL "&GENERA NOTAS DE CREDITO" 
     SIZE 26 BY 1.12
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     LABEL "FILTRAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-3 
     LABEL ">>" 
     SIZE 7 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON-4 
     LABEL "<<" 
     SIZE 7 BY 1.12
     FONT 6.

DEFINE VARIABLE c-NroSer AS CHARACTER FORMAT "X(3)":U 
     LABEL "Nº Serie N/C" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE F-ImpTot AS DECIMAL FORMAT "ZZZ,ZZ9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 6.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "XXX-XXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-Concepto AS CHARACTER FORMAT "x(8)" 
     LABEL "Concepto" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81.

DEFINE VARIABLE x-Fecha-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Emitidos desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-Fecha-2 AS DATE FORMAT "99/99/99":U 
     LABEL "hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCon AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 67 BY .81 NO-UNDO.

DEFINE VARIABLE x-PorReb AS DECIMAL FORMAT ">>9.99":U INITIAL 2 
     LABEL "% Rebade" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 12 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      T-DMvto-1 SCROLLING.

DEFINE QUERY BROWSE-3 FOR 
      T-DMvto-2 SCROLLING.

DEFINE QUERY F-Main FOR 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      T-DMvto-1.NroMes COLUMN-LABEL "Item" FORMAT ">>9":U
      T-DMvto-1.FchEmi COLUMN-LABEL "Emision" FORMAT "99/99/99":U
      T-DMvto-1.CodRef FORMAT "x(3)":U
      T-DMvto-1.NroRef FORMAT "X(9)":U WIDTH 10.57
      T-DMvto-1.ImpDoc COLUMN-LABEL "Importe" FORMAT ">>>,>>9.99":U
            WIDTH 9.43
      T-DMvto-1.DepNac[1] COLUMN-LABEL "N/Credito" FORMAT "->>>,>>9.99":U
            WIDTH 9.43
      T-DMvto-1.ImpInt COLUMN-LABEL "% Rebade" FORMAT ">>9.99":U
      T-DMvto-1.ImpTot COLUMN-LABEL "Importe Rebate" FORMAT ">>>,>>9.99":U
            WIDTH 11.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 69 BY 13.19
         FONT 4
         TITLE "DOCUMENTOS ACEPTADOS" ROW-HEIGHT-CHARS .46 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      T-DMvto-2.NroMes COLUMN-LABEL "Item" FORMAT ">>9":U
      T-DMvto-2.FchEmi COLUMN-LABEL "Emision" FORMAT "99/99/99":U
      T-DMvto-2.CodRef FORMAT "x(3)":U
      T-DMvto-2.NroRef FORMAT "X(9)":U WIDTH 10.57
      T-DMvto-2.ImpDoc COLUMN-LABEL "Importe" FORMAT ">>>,>>9.99":U
      T-DMvto-2.ImpInt COLUMN-LABEL "% Rebade" FORMAT ">>9.99":U
      T-DMvto-2.ImpTot COLUMN-LABEL "Importe Rebate" FORMAT ">>>,>>9.99":U
            WIDTH 11.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 58 BY 13.19
         FONT 4
         TITLE "DOCUMENTOS RECHAZADOS" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     c-NroSer AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 60
     FILL-IN-1 AT ROW 1.27 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     x-Mensaje AT ROW 1.27 COL 49 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     x-CodCli AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 2
     x-NomCli AT ROW 2.08 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     BUTTON-2 AT ROW 2.08 COL 101 WIDGET-ID 12
     x-Fecha-1 AT ROW 2.88 COL 19 COLON-ALIGNED WIDGET-ID 6
     x-Fecha-2 AT ROW 2.88 COL 38 COLON-ALIGNED WIDGET-ID 8
     x-PorReb AT ROW 3.69 COL 19 COLON-ALIGNED WIDGET-ID 10
     x-CodMon AT ROW 4.5 COL 21 NO-LABEL WIDGET-ID 50
     x-Concepto AT ROW 5.31 COL 19 COLON-ALIGNED WIDGET-ID 46
     x-NomCon AT ROW 5.31 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     BROWSE-2 AT ROW 6.65 COL 3 WIDGET-ID 200
     BROWSE-3 AT ROW 6.65 COL 81 WIDGET-ID 300
     BUTTON-3 AT ROW 9.08 COL 73 WIDGET-ID 14
     BUTTON-4 AT ROW 10.69 COL 73 WIDGET-ID 16
     F-ImpTot AT ROW 20.12 COL 56 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     BtnDone-2 AT ROW 21.19 COL 4 WIDGET-ID 58
     BtnDone AT ROW 21.19 COL 31 WIDGET-ID 56
     "F8: muestra detalle de las notas de credito" VIEW-AS TEXT
          SIZE 30 BY .5 AT ROW 20.12 COL 3 WIDGET-ID 66
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 4.77 COL 15 WIDGET-ID 54
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 139.57 BY 21.65
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-DMvto-1 T "?" NO-UNDO INTEGRAL CcbDMvto
      TABLE: T-DMvto-2 T "?" NO-UNDO INTEGRAL CcbDMvto
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "GENERACION DE NOTAS DE CREDITO AUTOMATOCAS POR REBATE"
         HEIGHT             = 21.65
         WIDTH              = 139.57
         MAX-HEIGHT         = 21.65
         MAX-WIDTH          = 141.72
         VIRTUAL-HEIGHT     = 21.65
         VIRTUAL-WIDTH      = 141.72
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
/* BROWSE-TAB BROWSE-2 x-NomCon F-Main */
/* BROWSE-TAB BROWSE-3 BROWSE-2 F-Main */
/* SETTINGS FOR FILL-IN F-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomCon IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.T-DMvto-1"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.T-DMvto-1.NroMes
"T-DMvto-1.NroMes" "Item" ">>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-DMvto-1.FchEmi
"T-DMvto-1.FchEmi" "Emision" "99/99/99" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.T-DMvto-1.CodRef
     _FldNameList[4]   > Temp-Tables.T-DMvto-1.NroRef
"T-DMvto-1.NroRef" ? ? "character" ? ? ? ? ? ? no ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-DMvto-1.ImpDoc
"T-DMvto-1.ImpDoc" "Importe" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-DMvto-1.DepNac[1]
"T-DMvto-1.DepNac[1]" "N/Credito" ? "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-DMvto-1.ImpInt
"T-DMvto-1.ImpInt" "% Rebade" ">>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-DMvto-1.ImpTot
"T-DMvto-1.ImpTot" "Importe Rebate" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.T-DMvto-2"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.T-DMvto-2.NroMes
"T-DMvto-2.NroMes" "Item" ">>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-DMvto-2.FchEmi
"T-DMvto-2.FchEmi" "Emision" "99/99/99" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.T-DMvto-2.CodRef
     _FldNameList[4]   > Temp-Tables.T-DMvto-2.NroRef
"T-DMvto-2.NroRef" ? ? "character" ? ? ? ? ? ? no ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-DMvto-2.ImpDoc
"T-DMvto-2.ImpDoc" "Importe" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-DMvto-2.ImpInt
"T-DMvto-2.ImpInt" "% Rebade" ">>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-DMvto-2.ImpTot
"T-DMvto-2.ImpTot" "Importe Rebate" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "11.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _TblList          = "INTEGRAL.CcbCDocu"
     _Query            is OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* GENERACION DE NOTAS DE CREDITO AUTOMATOCAS POR REBATE */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* GENERACION DE NOTAS DE CREDITO AUTOMATOCAS POR REBATE */
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
ON F8 OF BROWSE-2 IN FRAME F-Main /* DOCUMENTOS ACEPTADOS */
DO:
 RUN ccb/c-notcrepen (T-DMvto-1.CodRef, T-DMvto-1.NroRef).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* SALIR */
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


&Scoped-define SELF-NAME BtnDone-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone-2 W-Win
ON CHOOSE OF BtnDone-2 IN FRAME F-Main /* GENERA NOTAS DE CREDITO */
DO:
    ASSIGN
        c-NroSer
        x-codcli x-codmon x-concepto
        x-Fecha-1 x-Fecha-2 x-PorReb.
    /* CONSISTENCIA */
    IF x-codcli = '' OR x-Fecha-1 = ? OR x-Fecha-2 = ?
        OR x-PorReb <= 0 OR x-Concepto = '' THEN DO:
        MESSAGE 'Ingreso los datos completos' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    FIND FIRST T-Dmvto-1 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE T-Dmvto-1 THEN DO:
        MESSAGE 'NO hay facturas a quien aplicar el Rebate. Debe FILTRAR la información' 
            VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    MESSAGE 'Generamos las Notas de Credito?' 
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.
     RUN Genera-Documentos.
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
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* FILTRAR */
DO:
  ASSIGN
      c-NroSer
      x-codcli x-codmon x-concepto
      x-Fecha-1 x-Fecha-2 x-PorReb.
  /* CONSISTENCIA */
  IF x-codcli = '' OR x-Fecha-1 = ? OR x-Fecha-2 = ? OR x-PorReb <= 0 THEN DO:
      MESSAGE 'Ingreso los datos completos' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.

  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Filtrar.
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* >> */
DO:
  IF AVAILABLE T-Dmvto-1 THEN DO:
      CREATE T-Dmvto-2.
      BUFFER-COPY T-Dmvto-1 TO T-Dmvto-2.
      DELETE T-Dmvto-1.
      {&OPEN-QUERY-BROWSE-2}
      {&OPEN-QUERY-BROWSE-3}
          RUN Imp-Total.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* << */
DO:
    IF AVAILABLE T-Dmvto-2 THEN DO:
        CREATE T-Dmvto-1.
        BUFFER-COPY T-Dmvto-2 TO T-Dmvto-1.
        DELETE T-Dmvto-2.
        {&OPEN-QUERY-BROWSE-2}
        {&OPEN-QUERY-BROWSE-3}
            RUN Imp-Total.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-NroSer W-Win
ON VALUE-CHANGED OF c-NroSer IN FRAME F-Main /* Nº Serie N/C */
DO:
  FIND Faccorre WHERE codcia = s-codcia
      AND coddoc = s-coddoc
      AND nroser = INTEGER(SELF:SCREEN-VALUE)
      NO-LOCK.
  FILL-IN-1:SCREEN-VALUE = STRING(Faccorre.nroser,'999') + STRING(Faccorre.correlativo, '999999').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodCli W-Win
ON LEAVE OF x-CodCli IN FRAME F-Main /* Cliente */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    IF LENGTH(SELF:SCREEN-VALUE) < 11 THEN DO:
        MESSAGE "Codigo tiene menos de 11 dígitos" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
      AND  gn-clie.CodCli = SELF:SCREEN-VALUE 
      NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
       MESSAGE "Codigo de cliente no existe" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    /* BLOQUEO DEL CLIENTE */
    IF gn-clie.FlgSit = "I" THEN DO:
        MESSAGE "Cliente esta Inactivo" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF gn-clie.FlgSit = "C" THEN DO:
        MESSAGE "Cliente esta Cesado" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    x-NomCli:SCREEN-VALUE = gn-clie.nomcli.
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
        CcbTabla.Codigo = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE CcbTabla THEN DO:
        MESSAGE 'Concepto no registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    x-NomCon:SCREEN-VALUE = CcbTabla.nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-PorReb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-PorReb W-Win
ON LEAVE OF x-PorReb IN FRAME F-Main /* % Rebade */
DO:
  IF INPUT {&self-name} = 0 THEN RETURN NO-APPLY.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Series W-Win 
PROCEDURE Carga-Series :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  L-NROSER = "".
  FOR EACH Faccorre NO-LOCK WHERE 
           Faccorre.CodCia = S-CODCIA AND
           Faccorre.CodDoc = S-CODDOC AND
           Faccorre.CodDiv = S-CODDIV AND
           Faccorre.FlgEst = YES:
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

  {&OPEN-QUERY-F-Main}
  GET FIRST F-Main.
  DISPLAY c-NroSer FILL-IN-1 x-Mensaje x-CodCli x-NomCli x-Fecha-1 x-Fecha-2 
          x-PorReb x-CodMon x-Concepto x-NomCon F-ImpTot 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE c-NroSer x-CodCli BUTTON-2 x-Fecha-1 x-Fecha-2 x-PorReb x-CodMon 
         x-Concepto BROWSE-2 BROWSE-3 BUTTON-3 BUTTON-4 BtnDone-2 BtnDone 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Filtrar W-Win 
PROCEDURE Filtrar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-Item AS INT INIT 1 NO-UNDO.

FOR EACH T-Dmvto-1:
    DELETE T-Dmvto-1.
END.
FOR EACH T-Dmvto-2:
    DELETE T-Dmvto-2.
END.

FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
    AND ( ccbcdocu.coddoc = 'FAC' OR ccbcdocu.coddoc = 'BOL' )
    AND ccbcdocu.codcli = x-codcli
    AND ccbcdocu.fchdoc >= x-fecha-1
    AND ccbcdocu.fchdoc <= x-fecha-2
    AND ccbcdocu.flgest <> 'A'
    AND ccbcdocu.codmon = x-codmon
    AND LOOKUP ( ccbcdocu.tpofac, 'A,S') = 0:
    CREATE T-Dmvto-1.
    ASSIGN
        T-DMvto-1.NroMes = x-Item
        T-DMvto-1.CodCia = ccbcdocu.codcia
        T-DMvto-1.CodCli = ccbcdocu.codcli
        T-DMvto-1.CodDiv = ccbcdocu.coddiv
        T-DMvto-1.CodRef = ccbcdocu.coddoc
        T-DMvto-1.NroRef = ccbcdocu.nrodoc
        T-DMvto-1.FchEmi = ccbcdocu.fchdoc
        T-DMvto-1.ImpDoc = ccbcdocu.imptot
        T-DMvto-1.ImpInt = x-porreb.
        /*T-DMvto-1.ImpTot = ccbcdocu.imptot *  x-porreb / 100.*/
    x-Item = x-Item + 1.
END.

/* CARGAMOS LAS NOTAS DE CREDITO */
FOR EACH T-DMvto-1:
    FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.coddoc = 'N/C'
        AND Ccbcdocu.codref = T-DMvto-1.codref
        AND Ccbcdocu.nroref = T-DMvto-1.nroref
        AND Ccbcdocu.flgest <> "A":
        ASSIGN
            T-DMvto-1.DepNac[1] = T-DMvto-1.DepNac[1] + Ccbcdocu.SdoAct.
    END.
    IF T-DMvto-1.DepNac[1] < T-DMvto-1.ImpDoc 
    THEN T-DMvto-1.ImpTot = ( T-DMvto-1.ImpDoc - T-DMvto-1.DepNac[1] ) *  x-porreb / 100.
END.
{&OPEN-QUERY-BROWSE-2}
{&OPEN-QUERY-BROWSE-3}
    RUN Imp-Total.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Documentos W-Win 
PROCEDURE Genera-Documentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    FIND Faccfggn WHERE Faccfggn.codcia = s-codcia NO-LOCK.
    FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia AND 
        CcbTabla.Tabla  = s-coddoc AND 
        CcbTabla.Codigo = x-Concepto NO-LOCK.
    FIND Faccorre WHERE Faccorre.codcia = s-codcia
        AND Faccorre.coddoc = s-coddoc
        AND Faccorre.nroser = INTEGER(c-NroSer)
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccorre THEN DO:
      MESSAGE 'No se pudo bloquear el control de correlativos'
          VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
    END.
    FOR EACH T-Dmvto-1 WHERE T-DMvto-1.ImpTot > 0:
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = x-codcli NO-LOCK.
        CREATE Ccbcdocu.
        ASSIGN
            Ccbcdocu.codcia = s-codcia
            Ccbcdocu.coddoc = s-coddoc
            Ccbcdocu.coddiv = s-coddiv
            Ccbcdocu.nrodoc = STRING(Faccorre.nroser, '999') +
                                STRING(Faccorre.correlativo, '999999')
            CcbCDocu.FlgEst = "P"
            CcbCDocu.PorIgv = FacCfgGn.PorIgv
            CcbCDocu.CndCre = 'N'
            CcbCDocu.codref = T-Dmvto-1.codref
            CcbCDocu.nroref = T-Dmvto-1.nroref
            CcbCDocu.codcli = gn-clie.codcli
            CcbCDocu.nomcli = gn-clie.nomcli
            CcbCDocu.dircli = gn-clie.dircli
            Ccbcdocu.ruccli = gn-clie.ruc
            CCbcdocu.fchdoc = TODAY
            Ccbcdocu.fchvto = TODAY
            Ccbcdocu.porigv =  FacCfgGn.PorIgv
            Ccbcdocu.TpoCmb = FacCfgGn.TpoCmb[1]
            Ccbcdocu.usuario = S-USER-ID.
        ASSIGN
            Faccorre.correlativo = Faccorre.correlativo + 1.
        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "*** GENERANDO " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc + " ***".
        /* DETALLE */
        CREATE Ccbddocu.
        BUFFER-COPY Ccbcdocu TO Ccbddocu
            ASSIGN
            Ccbddocu.codmat = x-Concepto
            Ccbddocu.Factor = 1
            Ccbddocu.ImpLin = T-Dmvto-1.ImpTot
            CcbDDocu.CanDes = 1
            Ccbddocu.PreUni = T-Dmvto-1.ImpTot.
                
        IF CcbTabla.Afecto THEN
          ASSIGN
              Ccbddocu.AftIgv = Yes
              Ccbddocu.ImpIgv = Ccbddocu.ImpLin / (1 + (FacCfgGn.PorIgv / 100) ) * (FacCfgGn.PorIgv / 100) .
        ELSE
          ASSIGN
              Ccbddocu.AftIgv = No
              Ccbddocu.ImpIgv = 0.
        Ccbddocu.NroItm = 1.
        /* TOTALES */
        ASSIGN
          Ccbcdocu.ImpBrt = 0
          Ccbcdocu.ImpExo = 0
          Ccbcdocu.ImpDto = 0
          Ccbcdocu.ImpIgv = 0
          Ccbcdocu.ImpTot = 0.
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
            Ccbcdocu.SdoAct = Ccbcdocu.ImpTot.
    END.
    RELEASE Faccorre.                        
    RELEASE Ccbcdocu.
    RELEASE Ccbddocu.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imp-Total W-Win 
PROCEDURE Imp-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN
    F-ImpTot = 0.
FOR EACH  T-DMVTO-1:
    f-ImpTot = f-ImpTot + T-DMvto-1.ImpTot. 
END.
DISPLAY
    f-ImpTot WITH FRAME {&FRAME-NAME}.

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
  ASSIGN
      x-Fecha-1 = TODAY - DAY(TODAY) + 1
      x-Fecha-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Carga-Series.
  APPLY 'VALUE-CHANGED' TO c-NroSer IN FRAME {&FRAME-NAME}.

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
        WHEN "x-Concepto" THEN 
            ASSIGN
                input-var-1 = s-coddoc
                input-var-2 = ""
                input-var-3 = "".
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
  {src/adm/template/snd-list.i "CcbCDocu"}
  {src/adm/template/snd-list.i "T-DMvto-2"}
  {src/adm/template/snd-list.i "T-DMvto-1"}

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

