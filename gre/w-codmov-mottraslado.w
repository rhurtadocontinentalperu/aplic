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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Sunat_Fact_Electr_Detail Almtmovm ~
gre_movalm_mottraslado

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 Sunat_Fact_Electr_Detail.Code ~
Sunat_Fact_Electr_Detail.Description 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH Sunat_Fact_Electr_Detail ~
      WHERE Sunat_Fact_Electr_Detail.Catalogue = 20 and ~
Sunat_Fact_Electr_Detail.disabled = no NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH Sunat_Fact_Electr_Detail ~
      WHERE Sunat_Fact_Electr_Detail.Catalogue = 20 and ~
Sunat_Fact_Electr_Detail.disabled = no NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 Sunat_Fact_Electr_Detail
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 Sunat_Fact_Electr_Detail


/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 Almtmovm.Codmov Almtmovm.Desmov ~
Almtmovm.Indicador[6] Almtmovm.ReqGuia Almtmovm.Indicador[1] ~
Almtmovm.MovVal gre_movalm_mottraslado.codmotivotraslado ~
Sunat_Fact_Electr_Detail.Description 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH Almtmovm ~
      WHERE Almtmovm.CodCia = 1 and  ~
Almtmovm.Tipmov = 'S' and ~
almtmovm.codmov > 0 and ~
index(almtmovm.desmov,"inactivo") = 0 and ~
index(almtmovm.desmov,"no usar") = 0 and ~
index(almtmovm.desmov,"desact") = 0 NO-LOCK, ~
      FIRST gre_movalm_mottraslado WHERE Almtmovm.Codmov = gre_movalm_mottraslado.codmov OUTER-JOIN NO-LOCK, ~
      FIRST Sunat_Fact_Electr_Detail WHERE Sunat_Fact_Electr_Detail.Catalogue = 20 and ~
 Sunat_Fact_Electr_Detail.Code =  gre_movalm_mottraslado.codmotivotraslado OUTER-JOIN NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH Almtmovm ~
      WHERE Almtmovm.CodCia = 1 and  ~
Almtmovm.Tipmov = 'S' and ~
almtmovm.codmov > 0 and ~
index(almtmovm.desmov,"inactivo") = 0 and ~
index(almtmovm.desmov,"no usar") = 0 and ~
index(almtmovm.desmov,"desact") = 0 NO-LOCK, ~
      FIRST gre_movalm_mottraslado WHERE Almtmovm.Codmov = gre_movalm_mottraslado.codmov OUTER-JOIN NO-LOCK, ~
      FIRST Sunat_Fact_Electr_Detail WHERE Sunat_Fact_Electr_Detail.Catalogue = 20 and ~
 Sunat_Fact_Electr_Detail.Code =  gre_movalm_mottraslado.codmotivotraslado OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 Almtmovm gre_movalm_mottraslado ~
Sunat_Fact_Electr_Detail
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 Almtmovm
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-4 gre_movalm_mottraslado
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-4 Sunat_Fact_Electr_Detail


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-5 BROWSE-4 BROWSE-3 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-3 FILL-IN-2 FILL-IN-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U INITIAL "DobleClick en el registro para quitar el motivo de traslado" 
      VIEW-AS TEXT 
     SIZE 49 BY .81
     BGCOLOR 15 FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U INITIAL "DobleClick para asignar el motivo de traslado" 
      VIEW-AS TEXT 
     SIZE 38 BY .81
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(2)":U INITIAL "<" 
     VIEW-AS FILL-IN 
     SIZE 2 BY .88
     FGCOLOR 9 FONT 10 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 21.86 BY 3.5.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      Sunat_Fact_Electr_Detail SCROLLING.

DEFINE QUERY BROWSE-4 FOR 
      Almtmovm, 
      gre_movalm_mottraslado, 
      Sunat_Fact_Electr_Detail SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      Sunat_Fact_Electr_Detail.Code COLUMN-LABEL "Codigo" FORMAT "x(8)":U
            WIDTH 6.43
      Sunat_Fact_Electr_Detail.Description COLUMN-LABEL "Descripcion" FORMAT "x(100)":U
            WIDTH 31.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 41.43 BY 11.42
         FONT 3
         TITLE "MOTIVOS DE TRASLADO / SUNAT" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      Almtmovm.Codmov COLUMN-LABEL "Cod!Mov" FORMAT "99":U WIDTH 3.43
      Almtmovm.Desmov FORMAT "X(60)":U WIDTH 30.43
      Almtmovm.Indicador[6] COLUMN-LABEL "Desactivado" FORMAT "yes/no":U
            WIDTH 11.43
      Almtmovm.ReqGuia COLUMN-LABEL "Genera!G/R" FORMAT "yes/no":U
            WIDTH 6.43
      Almtmovm.Indicador[1] COLUMN-LABEL "Mov!Rsvdo" FORMAT "yes/no":U
      Almtmovm.MovVal COLUMN-LABEL "Afecta!Mov.Alm" FORMAT "Si/No":U
            WIDTH 7.86
      gre_movalm_mottraslado.codmotivotraslado COLUMN-LABEL "Motivo!Traslado" FORMAT "x(3)":U
            WIDTH 8.43
      Sunat_Fact_Electr_Detail.Description COLUMN-LABEL "Descripcion Mot. Traslado" FORMAT "x(100)":U
            WIDTH 36.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 92 BY 18.65
         FONT 3
         TITLE "MOVIMIENTOS DE SALIDA QUE GENERAN GUIA DE REMISION".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-4 AT ROW 1.23 COL 2 WIDGET-ID 300
     FILL-IN-3 AT ROW 4.58 COL 92.14 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     BROWSE-3 AT ROW 8.42 COL 94.72 WIDGET-ID 200
     FILL-IN-2 AT ROW 7.58 COL 94 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     FILL-IN-1 AT ROW 20.12 COL 11 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     RECT-5 AT ROW 5.04 COL 93.14 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 136 BY 20.38
         FONT 3 WIDGET-ID 100.


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
         TITLE              = "Movimientos de salidas / Motivos de traslado"
         HEIGHT             = 20.38
         WIDTH              = 136
         MAX-HEIGHT         = 20.38
         MAX-WIDTH          = 151.86
         VIRTUAL-HEIGHT     = 20.38
         VIRTUAL-WIDTH      = 151.86
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
/* BROWSE-TAB BROWSE-4 RECT-5 F-Main */
/* BROWSE-TAB BROWSE-3 FILL-IN-3 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "INTEGRAL.Sunat_Fact_Electr_Detail"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "Sunat_Fact_Electr_Detail.Catalogue = 20 and
Sunat_Fact_Electr_Detail.disabled = no"
     _FldNameList[1]   > INTEGRAL.Sunat_Fact_Electr_Detail.Code
"Sunat_Fact_Electr_Detail.Code" "Codigo" ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Sunat_Fact_Electr_Detail.Description
"Sunat_Fact_Electr_Detail.Description" "Descripcion" ? "character" ? ? ? ? ? ? no ? no no "31.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "INTEGRAL.Almtmovm,INTEGRAL.gre_movalm_mottraslado WHERE INTEGRAL.Almtmovm ...,INTEGRAL.Sunat_Fact_Electr_Detail WHERE INTEGRAL.gre_movalm_mottraslado ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER, FIRST OUTER"
     _Where[1]         = "Almtmovm.CodCia = 1 and 
Almtmovm.Tipmov = 'S' and
almtmovm.codmov > 0 and
index(almtmovm.desmov,""inactivo"") = 0 and
index(almtmovm.desmov,""no usar"") = 0 and
index(almtmovm.desmov,""desact"") = 0"
     _JoinCode[2]      = "Almtmovm.Codmov = gre_movalm_mottraslado.codmov"
     _JoinCode[3]      = "Sunat_Fact_Electr_Detail.Catalogue = 20 and
 Sunat_Fact_Electr_Detail.Code =  gre_movalm_mottraslado.codmotivotraslado"
     _FldNameList[1]   > INTEGRAL.Almtmovm.Codmov
"Almtmovm.Codmov" "Cod!Mov" ? "integer" ? ? ? ? ? ? no ? no no "3.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almtmovm.Desmov
"Almtmovm.Desmov" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "30.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almtmovm.Indicador[6]
"Almtmovm.Indicador[6]" "Desactivado" ? "logical" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almtmovm.ReqGuia
"Almtmovm.ReqGuia" "Genera!G/R" ? "logical" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almtmovm.Indicador[1]
"Almtmovm.Indicador[1]" "Mov!Rsvdo" ? "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.Almtmovm.MovVal
"Almtmovm.MovVal" "Afecta!Mov.Alm" ? "logical" ? ? ? ? ? ? no ? no no "7.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.gre_movalm_mottraslado.codmotivotraslado
"gre_movalm_mottraslado.codmotivotraslado" "Motivo!Traslado" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.Sunat_Fact_Electr_Detail.Description
"Sunat_Fact_Electr_Detail.Description" "Descripcion Mot. Traslado" ? "character" ? ? ? ? ? ? no ? no no "36.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Movimientos de salidas / Motivos de traslado */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Movimientos de salidas / Motivos de traslado */
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
ON MOUSE-SELECT-DBLCLICK OF BROWSE-3 IN FRAME F-Main /* MOTIVOS DE TRASLADO / SUNAT */
DO:

DEFINE VAR iRowsSelecionados AS INT.

DEFINE VAR iCodMov AS INT.
DEFINE VAR cDesMov AS CHAR.
DEFINE VAR lGeneraGR AS LOG.

DEFINE VAR cMotTraslado AS CHAR.
DEFINE VAR cDesMotTraslado AS CHAR.
DEFINE VAR rRowid AS ROWID.

iRowsSelecionados = browse-4:NUM-SELECTED-ROWS.

IF iRowsSelecionados <= 0 THEN DO:
    MESSAGE "Debe seleccionar un registro en Movimientos de salida / almacen"
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN NO-APPLY.
END.

iRowsSelecionados = browse-3:NUM-SELECTED-ROWS.

IF iRowsSelecionados <= 0 THEN DO:
    MESSAGE "Debe seleccionar un registro en Motivos de traslados / Sunat"
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN NO-APPLY.
END.


DEFINE VARIABLE iRowHeight   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iLastY       AS INTEGER     NO-UNDO.
DEFINE VARIABLE iRow         AS INTEGER     NO-UNDO.
DEFINE VARIABLE hCell        AS HANDLE      NO-UNDO.
DEFINE VARIABLE iTopRowY     AS INTEGER     NO-UNDO.

DEFINE VARIABLE dRow         AS DEC     NO-UNDO.
DEFINE VAR addRow AS INT.

/* See if there are ANY rows in view... */
IF SELF:NUM-ITERATIONS = 0 THEN 
DO:
   /* No rows, the user clicked on an empty browse widget */ 
   RETURN NO-APPLY. 
END.

/* We don't know which row was clicked on, we have to calculate it from the mouse coordinates and the row heights. No really. */
SELF:SELECT-ROW(1).               /* Select the first row so we can get the first cell. */
hCell      = SELF:FIRST-COLUMN.   /* Get the first cell so we can get the Y coord of the first row, and the height of cells. */
iTopRowY   = hCell:Y - 1.         /* The Y coord of the top of the top row relative to the browse widget. Had to subtract 1 pixel to get it accurate. */
iRowHeight = hCell:HEIGHT-PIXELS. /* SELF:ROW-HEIGHT-PIXELS is not the same as hCell:HEIGHT-PIXELS for some reason */
iLastY     = LAST-EVENT:Y.        /* The Y position of the mouse event (relative to the browse widget) */

/* calculate which row was clicked. Truncate so that it doesn't round clicks past the middle of the row up to the next row. */
dRow       = 1 + (iLastY - iTopRowY) / iRowHeight.
iRow       = 1 + TRUNCATE((iLastY - iTopRowY) / iRowHeight, 0).


/* Si tiene activo la barra de titulo en el browse cambia a 1 el addRow*/
addRow = 1.

IF iRow = 1  THEN DO:
    IF dRow > 1  THEN DO:
        iRow = iRow + addRow.
    END.
END.
ELSE DO:
    iRow = iRow + addRow.
END.


IF iRow > 0 AND iRow <= SELF:NUM-ITERATIONS THEN 
DO:
  /* The user clicked on a populated row */
   /*Your coding here, for example:*/
    SELF:SELECT-ROW(iRow).

    cMotTraslado = sunat_fact_electr_detail.CODE.
    cDesMotTraslado = sunat_fact_electr_detail.DESCRIPTION.
    
    IF browse-4:FETCH-SELECTED-ROW(1) THEN DO:
        iCodMov = almtmovm.codmov.
        cDesMov = almtmovm.desmov.
        lGeneraGR = almtmovm.ReqGuia.

        IF lGeneraGR = NO THEN DO:
            MESSAGE "El tipo de movimiento " SKIP
                    cMotTraslado " " cDesMotTraslado SKIP
                    "No genera guia de remision"
                VIEW-AS ALERT-BOX INFORMATION.
            RETURN NO-APPLY.
        END.

        MESSAGE "Seguro de ASIGNAR el motivo de traslado" SKIP
                cMotTraslado " " cDesMotTraslado SKIP
                "al movimiento de almacen" SKIP
                iCodMov " " cDesmov
                VIEW-AS ALERT-BOX QUESTION
                    BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = YES THEN DO:

            rRowId = ROWID(almtmovm).

            FIND FIRST gre_movalm_mottraslado 
                WHERE gre_movalm_mottraslado.codmov = iCodMov EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE gre_movalm_mottraslado THEN DO:
                CREATE gre_movalm_mottraslado.
            END.
            ASSIGN gre_movalm_mottraslado.codmov = iCodMov
                    gre_movalm_mottraslado.codmotivotraslado = cMotTraslado.
            RELEASE gre_movalm_mottraslado.
            {&OPEN-QUERY-BROWSE-4}
            REPOSITION browse-4  TO ROWID rRowId.
        END.                
    END.
    ELSE DO:
        MESSAGE "ERROR".
    END.

END.
ELSE DO:
  /* The click was on an empty row. */
  /*SELF:DESELECT-ROWS().*/

  RETURN NO-APPLY.
END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
&Scoped-define SELF-NAME BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-4 IN FRAME F-Main /* MOVIMIENTOS DE SALIDA QUE GENERAN GUIA DE REMISION */
DO:
    DEFINE VAR iRowsSelecionados AS INT.

    DEFINE VAR iCodMov AS INT.
    DEFINE VAR cDesMov AS CHAR.

    DEFINE VAR cMotTraslado AS CHAR.
    DEFINE VAR cDesMotTraslado AS CHAR.
    DEFINE VAR rRowid AS ROWID.

    iRowsSelecionados = browse-4:NUM-SELECTED-ROWS.

    IF iRowsSelecionados <= 0 THEN DO:
        MESSAGE "Debe seleccionar un registro en Movimientos de salida / almacen"
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.

    DEFINE VARIABLE iRowHeight   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iLastY       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iRow         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE hCell        AS HANDLE      NO-UNDO.
    DEFINE VARIABLE iTopRowY     AS INTEGER     NO-UNDO.

    DEFINE VARIABLE dRow         AS DEC     NO-UNDO.
    DEFINE VAR addRow AS INT.

    /* See if there are ANY rows in view... */
    IF SELF:NUM-ITERATIONS = 0 THEN 
    DO:
       /* No rows, the user clicked on an empty browse widget */ 
       RETURN NO-APPLY. 
    END.

    /* We don't know which row was clicked on, we have to calculate it from the mouse coordinates and the row heights. No really. */
    SELF:SELECT-ROW(1).               /* Select the first row so we can get the first cell. */
    hCell      = SELF:FIRST-COLUMN.   /* Get the first cell so we can get the Y coord of the first row, and the height of cells. */
    iTopRowY   = hCell:Y - 1.         /* The Y coord of the top of the top row relative to the browse widget. Had to subtract 1 pixel to get it accurate. */
    iRowHeight = hCell:HEIGHT-PIXELS. /* SELF:ROW-HEIGHT-PIXELS is not the same as hCell:HEIGHT-PIXELS for some reason */
    iLastY     = LAST-EVENT:Y.        /* The Y position of the mouse event (relative to the browse widget) */

    /* calculate which row was clicked. Truncate so that it doesn't round clicks past the middle of the row up to the next row. */
    dRow       = 1 + (iLastY - iTopRowY) / iRowHeight.
    iRow       = 1 + TRUNCATE((iLastY - iTopRowY) / iRowHeight, 0).


    /* Si tiene activo la barra de titulo en el browse cambia a 1 el addRow*/
    addRow = 1.

    IF iRow = 1  THEN DO:
        IF dRow > 1  THEN DO:
            iRow = iRow + addRow.
        END.
    END.
    ELSE DO:
        iRow = iRow + addRow.
    END.


    IF iRow > 0 AND iRow <= SELF:NUM-ITERATIONS THEN 
    DO:
      /* The user clicked on a populated row */
       /*Your coding here, for example:*/
        SELF:SELECT-ROW(iRow).

        iCodMov = almtmovm.codmov.
        cDesMov = almtmovm.desmov.

        cMotTraslado = sunat_fact_electr_detail.CODE.
        cDesMotTraslado = sunat_fact_electr_detail.DESCRIPTION.

        IF cMotTraslado <> ? THEN DO:
            MESSAGE "Seguro de QUITAR el motivo de traslado" SKIP
                    cMotTraslado " " cDesMotTraslado SKIP
                    "del movimiento de almacen" SKIP
                    iCodMov " " cDesmov
                    VIEW-AS ALERT-BOX QUESTION
                        BUTTONS YES-NO UPDATE rpta AS LOG.
            IF rpta = YES THEN DO:
                rRowId = ROWID(almtmovm).
                FIND FIRST gre_movalm_mottraslado 
                    WHERE gre_movalm_mottraslado.codmov = iCodMov EXCLUSIVE-LOCK NO-ERROR.
                IF AVAILABLE gre_movalm_mottraslado THEN DO:
                    DELETE gre_movalm_mottraslado.
                END.
                RELEASE gre_movalm_mottraslado.
                {&OPEN-QUERY-BROWSE-4}
                REPOSITION browse-4  TO ROWID rRowId.
            END.
        END.
    END.
    ELSE DO:
      RETURN NO-APPLY.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
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
  DISPLAY FILL-IN-3 FILL-IN-2 FILL-IN-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-5 BROWSE-4 BROWSE-3 
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
  {src/adm/template/snd-list.i "Almtmovm"}
  {src/adm/template/snd-list.i "gre_movalm_mottraslado"}
  {src/adm/template/snd-list.i "Sunat_Fact_Electr_Detail"}

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

