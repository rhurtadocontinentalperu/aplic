&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tw-report NO-UNDO LIKE w-report.



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

DEF SHARED VAR s-codcia AS INTE.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\Coti.ico" SIZE 12 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

DEF TEMP-TABLE Detalle NO-UNDO
    FIELD CodMat        AS CHAR     FORMAT 'x(10)'                  LABEL 'ARTICULO'
    FIELD DesMat        AS CHAR     FORMAT 'x(100)'                 LABEL 'DESCRIPCION'
    FIELD UndBas        AS CHAR     FORMAT 'x(8)'                   LABEL 'UNIDAD'
    FIELD SdoIni        AS DECI     FORMAT '->>>,>>>,>>9.9999'      LABEL 'SALDO INICIAL'
    FIELD Ingresos      AS DECI     FORMAT '->>>,>>>,>>9.9999'      LABEL 'INGRESOS'
    FIELD Salidas       AS DECI     FORMAT '->>>,>>>,>>9.9999'      LABEL 'SALIDAS'
    FIELD Saldo         AS DECI     FORMAT '->>>,>>>,>>9.9999'      LABEL 'SALDO FINAL'
    FIELD SaldoEGC      AS DECI     FORMAT '->>>,>>>,>>9.9999'      LABEL 'SALDO EGC'
    FIELD CatContab     AS CHAR     FORMAT 'x(6)'                   LABEL 'CAT.CONTAB.'
    FIELD Campana       AS CHAR     FORMAT 'x(6)'                   LABEL 'CAMPAÑA'
    FIELD NoCampana     AS CHAR     FORMAT 'x(6)'                   LABEL 'NO CAMPAÑA'
    FIELD CtoUni        AS DECI     FORMAT '->>>,>>>,>>9.9999'      LABEL 'CTO.PROM.'
    .

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
&Scoped-define INTERNAL-TABLES tw-report

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tw-report.Campo-C[1] ~
tw-report.Campo-C[2] tw-report.Campo-C[3] tw-report.Campo-F[1] ~
tw-report.Campo-F[2] tw-report.Campo-F[3] tw-report.Campo-F[4] ~
tw-report.Campo-F[5] tw-report.Campo-C[4] tw-report.Campo-C[5] ~
tw-report.Campo-C[6] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tw-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tw-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tw-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tw-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-70 RECT-71 COMBO-BOX_CodFam BtnDone ~
BUTTON_Procesar COMBO-BOX_CatConta FILL-IN_CodMat_1 FILL-IN_CodMat_2 ~
BUTTON_Texto FILL-IN_Fecha_1 FILL-IN_Fecha_2 BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX_CodFam COMBO-BOX_CatConta ~
FILL-IN_CodMat_1 FILL-IN_CodMat_2 FILL-IN_Fecha_1 FILL-IN_Fecha_2 

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
     SIZE 7 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON_Procesar 
     LABEL "PROCESAR" 
     SIZE 15 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON_Texto 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "Button 5" 
     SIZE 7 BY 1.62 TOOLTIP "Exportar a Texto".

DEFINE VARIABLE COMBO-BOX_CatConta AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Categoria contable" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Todas","Todas"
     DROP-DOWN-LIST
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_CodFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Línea" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Todas","Todas"
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodMat_1 AS CHARACTER FORMAT "X(10)":U 
     LABEL "Desde al artículo" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodMat_2 AS CHARACTER FORMAT "X(10)":U 
     LABEL "Hasta al artículo" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Fecha_1 AS DATE FORMAT "99/99/9999":U 
     LABEL "EGC al" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Fecha_2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Movimientos hasta el" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-70
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 132 BY 5.92.

DEFINE RECTANGLE RECT-71
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 13 BY 5.92.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tw-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tw-report.Campo-C[1] COLUMN-LABEL "Artículo" FORMAT "X(12)":U
      tw-report.Campo-C[2] COLUMN-LABEL "Descripción" FORMAT "X(80)":U
      tw-report.Campo-C[3] COLUMN-LABEL "Unidad" FORMAT "X(10)":U
      tw-report.Campo-F[1] COLUMN-LABEL "Saldo Inicial" FORMAT "->>>,>>>,>>9.9999":U
      tw-report.Campo-F[2] COLUMN-LABEL "Ingresos" FORMAT "->>>,>>>,>>9.9999":U
      tw-report.Campo-F[3] COLUMN-LABEL "Salidas" FORMAT "->>>,>>>,>>9.9999":U
      tw-report.Campo-F[4] COLUMN-LABEL "Saldo Final" FORMAT "->>>,>>>,>>9.9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      tw-report.Campo-F[5] COLUMN-LABEL "Saldo EGC" FORMAT "->>>,>>>,>>9.9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      tw-report.Campo-C[4] COLUMN-LABEL "Cat. Contab." FORMAT "X(8)":U
      tw-report.Campo-C[5] COLUMN-LABEL "Campaña" FORMAT "X(8)":U
      tw-report.Campo-C[6] COLUMN-LABEL "No Campaña" FORMAT "X(8)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 145 BY 19.65
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX_CodFam AT ROW 1.54 COL 19 COLON-ALIGNED WIDGET-ID 2
     BtnDone AT ROW 1.81 COL 139 WIDGET-ID 30
     BUTTON_Procesar AT ROW 2.08 COL 119 WIDGET-ID 16
     COMBO-BOX_CatConta AT ROW 2.62 COL 19 COLON-ALIGNED WIDGET-ID 6
     FILL-IN_CodMat_1 AT ROW 3.69 COL 19 COLON-ALIGNED WIDGET-ID 8
     FILL-IN_CodMat_2 AT ROW 3.69 COL 44 COLON-ALIGNED WIDGET-ID 10
     BUTTON_Texto AT ROW 3.69 COL 139 WIDGET-ID 20
     FILL-IN_Fecha_1 AT ROW 4.77 COL 19 COLON-ALIGNED WIDGET-ID 12
     FILL-IN_Fecha_2 AT ROW 5.85 COL 19 COLON-ALIGNED WIDGET-ID 14
     BROWSE-2 AT ROW 6.92 COL 3 WIDGET-ID 200
     "<<< Si ingresa ambos campos NO se va a tomar en cuenta los filtros anteriores" VIEW-AS TEXT
          SIZE 65 BY .81 AT ROW 3.69 COL 59 WIDGET-ID 18
          BGCOLOR 14 FGCOLOR 0 FONT 6
     RECT-70 AT ROW 1 COL 3 WIDGET-ID 22
     RECT-71 AT ROW 1 COL 135 WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 149.72 BY 26.15
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tw-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "INCONSISTENCIA DE LAS EXISTENCIAS GENERALES CONTABLES"
         HEIGHT             = 26.15
         WIDTH              = 149.72
         MAX-HEIGHT         = 26.15
         MAX-WIDTH          = 191.29
         VIRTUAL-HEIGHT     = 26.15
         VIRTUAL-WIDTH      = 191.29
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
/* BROWSE-TAB BROWSE-2 FILL-IN_Fecha_2 F-Main */
ASSIGN 
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

ASSIGN 
       BROWSE-2:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tw-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tw-report.Campo-C[1]
"tw-report.Campo-C[1]" "Artículo" "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tw-report.Campo-C[2]
"tw-report.Campo-C[2]" "Descripción" "X(80)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tw-report.Campo-C[3]
"tw-report.Campo-C[3]" "Unidad" "X(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tw-report.Campo-F[1]
"tw-report.Campo-F[1]" "Saldo Inicial" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tw-report.Campo-F[2]
"tw-report.Campo-F[2]" "Ingresos" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tw-report.Campo-F[3]
"tw-report.Campo-F[3]" "Salidas" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tw-report.Campo-F[4]
"tw-report.Campo-F[4]" "Saldo Final" ? "decimal" 14 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tw-report.Campo-F[5]
"tw-report.Campo-F[5]" "Saldo EGC" ? "decimal" 11 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tw-report.Campo-C[4]
"tw-report.Campo-C[4]" "Cat. Contab." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tw-report.Campo-C[5]
"tw-report.Campo-C[5]" "Campaña" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tw-report.Campo-C[6]
"tw-report.Campo-C[6]" "No Campaña" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* INCONSISTENCIA DE LAS EXISTENCIAS GENERALES CONTABLES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* INCONSISTENCIA DE LAS EXISTENCIAS GENERALES CONTABLES */
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


&Scoped-define SELF-NAME BUTTON_Procesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Procesar W-Win
ON CHOOSE OF BUTTON_Procesar IN FRAME F-Main /* PROCESAR */
DO:
  ASSIGN
      COMBO-BOX_CatConta COMBO-BOX_CodFam FILL-IN_CodMat_1 FILL-IN_CodMat_2 
      FILL-IN_Fecha_1 FILL-IN_Fecha_2.
  IF FILL-IN_Fecha_1 = ? OR FILL-IN_Fecha_2 = ? THEN DO:
      MESSAGE 'Debe ingresar ambas fechas' VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO FILL-IN_Fecha_1.
      RETURN NO-APPLY.
  END.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal.
  SESSION:SET-WAIT-STATE('').
  MESSAGE "Proceso Terminado" VIEW-AS ALERT-BOX INFORMATION.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  IF NOT CAN-FIND(FIRST tw-report NO-LOCK) THEN DO:
      MESSAGE "NO se han encontrado inconsistencias" VIEW-AS ALERT-BOX MESSAGE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Texto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Texto W-Win
ON CHOOSE OF BUTTON_Texto IN FRAME F-Main /* Button 5 */
DO:
    MESSAGE 'Procedemos con la exportación a Texto?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.

    /* Pantalla de Impresión */
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.

    RUN lib/tt-file-to-onlytext (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    /* Cargamos la informacion al temporal */
    SESSION:SET-WAIT-STATE('GENERAL').

    RUN Texto.

    /* Programas que generan el Excel */
    DISPLAY "GENERANDO TEXTO" @ fi-Mensaje WITH FRAME f-Proceso.

    cArchivo = LC(pArchivo).
    IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
    RUN lib/tt-filev2 (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
    SESSION:DATE-FORMAT = "dmy".
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    SESSION:SET-WAIT-STATE('').
    HIDE FRAME f-Proceso.
    {&OPEN-QUERY-{&BROWSE-NAME}}
    MESSAGE 'Proceso Concluido' VIEW-AS ALERT-BOX INFORMATION.
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

EMPTY TEMP-TABLE tw-report.

CASE TRUE:
    WHEN FILL-IN_CodMat_1 > '' AND FILL-IN_CodMat_2 > '' THEN DO:
        FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
            AND Almmmatg.codmat >= FILL-IN_CodMat_1
            AND Almmmatg.codmat <= FILL-IN_CodMat_2:
            Fi-Mensaje = "CARGANDO DETALLE: " + almmmatg.codmat.
            DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
            CREATE tw-report.
            ASSIGN
                tw-report.Campo-C[1] = Almmmatg.codmat
                tw-report.Campo-C[2] = Almmmatg.desmat
                tw-report.Campo-C[3] = Almmmatg.undstk.
        END.
    END.
    WHEN FILL-IN_CodMat_1 > '' THEN DO:
        FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
            AND (COMBO-BOX_CodFam = 'Todas' OR Almmmatg.codfam = COMBO-BOX_CodFam) 
            AND Almmmatg.codmat >= FILL-IN_CodMat_1:
            IF COMBO-BOX_CatConta <> "Todas" 
                AND Almmmatg.CatConta[1] <> COMBO-BOX_CatConta THEN NEXT.
            Fi-Mensaje = "CARGANDO DETALLE: " + almmmatg.codmat.
            DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
            CREATE tw-report.
            ASSIGN
                tw-report.Campo-C[1] = Almmmatg.codmat
                tw-report.Campo-C[2] = Almmmatg.desmat
                tw-report.Campo-C[3] = Almmmatg.undstk.
        END.
    END.
    WHEN FILL-IN_CodMat_2 > '' THEN DO:
        FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
            AND (COMBO-BOX_CodFam = 'Todas' OR Almmmatg.codfam = COMBO-BOX_CodFam) 
            AND Almmmatg.codmat <= FILL-IN_CodMat_2:
            IF COMBO-BOX_CatConta <> "Todas" 
                AND Almmmatg.CatConta[1] <> COMBO-BOX_CatConta THEN NEXT.
            Fi-Mensaje = "CARGANDO DETALLE: " + almmmatg.codmat.
            DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
            CREATE tw-report.
            ASSIGN
                tw-report.Campo-C[1] = Almmmatg.codmat
                tw-report.Campo-C[2] = Almmmatg.desmat
                tw-report.Campo-C[3] = Almmmatg.undstk.
        END.
    END.
    OTHERWISE DO:
        FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
            AND (COMBO-BOX_CodFam = 'Todas' OR Almmmatg.codfam = COMBO-BOX_CodFam):
            IF COMBO-BOX_CatConta <> "Todas" 
                AND Almmmatg.CatConta[1] <> COMBO-BOX_CatConta THEN NEXT.
            Fi-Mensaje = "CARGANDO DETALLE: " + almmmatg.codmat.
            DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
            CREATE tw-report.
            ASSIGN
                tw-report.Campo-C[1] = Almmmatg.codmat
                tw-report.Campo-C[2] = Almmmatg.desmat
                tw-report.Campo-C[3] = Almmmatg.undstk.
        END.
    END.
END CASE.

DEF VAR xIngresos AS DECI NO-UNDO.
DEF VAR xSalidas AS DECI NO-UNDO.

FOR EACH tw-report EXCLUSIVE-LOCK,
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia 
        AND Almmmatg.codmat = tw-report.Campo-C[1]
    BY tw-report.campo-c[1]:
    Fi-Mensaje = "CERRANDO: " + tw-report.campo-c[1].
    DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
    ASSIGN xIngresos = 0 xSalidas = 0.
    FIND LAST almstkge USE-INDEX llave01 WHERE almstkge.codcia = s-codcia
        AND almstkge.codmat = tw-report.campo-c[1]
        AND almstkge.fecha <= FILL-IN_Fecha_1
        NO-LOCK NO-ERROR.
    IF AVAILABLE almstkge THEN tw-report.Campo-F[1] = AlmStkge.StkAct.
    FIND LAST almstkge USE-INDEX llave01 WHERE almstkge.codcia = s-codcia
        AND almstkge.codmat = tw-report.campo-c[1]
        AND almstkge.fecha <= FILL-IN_Fecha_2
        NO-LOCK NO-ERROR.
    IF AVAILABLE almstkge THEN tw-report.Campo-F[5] = AlmStkge.StkAct.
    FOR EACH almdmov NO-LOCK WHERE almdmov.codcia = s-codcia 
        AND almdmov.codmat = tw-report.campo-c[1]
        AND almdmov.fchdoc > FILL-IN_Fecha_1
        AND almdmov.fchdoc <= FILL-IN_Fecha_2,
        FIRST almacen NO-LOCK WHERE almacen.codcia = s-codcia
        AND almacen.codalm = almdmov.codalm,
        FIRST almtmovm NO-LOCK WHERE almtmovm.codcia = s-codcia
        AND almtmovm.tipmov = almdmov.tipmov
        AND almtmovm.codmov = almdmov.codmov:
        /* No van los movimientos de transferencia */
        IF almtmovm.movtrf = YES THEN NEXT.
        /* 24/02/2020: Almacenes NO propios */
        IF Almacen.FlgRep = NO THEN NEXT.
        IF Almacen.AlmCsg = YES THEN NEXT.

        IF almdmov.tipmov = "I" THEN xIngresos = xIngresos + (almdmov.candes * almdmov.factor).
        ELSE xSalidas = xSalidas + (almdmov.candes * almdmov.factor).
    END.
    tw-report.Campo-F[2] = xIngresos.
    tw-report.Campo-F[3] = xSalidas.
    tw-report.Campo-F[4] = tw-report.Campo-F[1] + tw-report.Campo-F[2] - tw-report.Campo-F[3].
    IF tw-report.Campo-F[4] = tw-report.Campo-F[5] THEN DO:
        DELETE tw-report.
        NEXT.
    END.
    /* Datos adicionales */
    tw-report.Campo-C[4] = Almmmatg.catconta[1]. 
    FIND LAST Almstkge USE-INDEX llave01 WHERE Almstkge.codcia = s-codcia
        AND Almstkge.codmat = Almmmatg.codmat
        AND Almstkge.fecha <= FILL-IN_Fecha_2
        NO-LOCK NO-ERROR NO-WAIT.
    IF AVAILABLE Almstkge THEN tw-report.Campo-F[6] = AlmStkge.CtoUni.
    /* CLASIFICACION GENERAL */
    FIND FacTabla WHERE FacTabla.codcia = s-codcia AND
        FacTabla.tabla = 'RANKVTA' AND
        FacTabla.codigo = Almmmatg.codmat
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacTabla THEN DO:
        tw-report.Campo-C[5] = FacTabla.Campo-C[1].
        tw-report.Campo-C[6] = FacTabla.Campo-C[4].
    END.

END.
HIDE FRAME F-Proceso.

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
  DISPLAY COMBO-BOX_CodFam COMBO-BOX_CatConta FILL-IN_CodMat_1 FILL-IN_CodMat_2 
          FILL-IN_Fecha_1 FILL-IN_Fecha_2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-70 RECT-71 COMBO-BOX_CodFam BtnDone BUTTON_Procesar 
         COMBO-BOX_CatConta FILL-IN_CodMat_1 FILL-IN_CodMat_2 BUTTON_Texto 
         FILL-IN_Fecha_1 FILL-IN_Fecha_2 BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  VIEW FRAME F-Main IN WINDOW W-Win.
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
      /*COMBO-BOX_CodFam:DELETE(1).*/
      COMBO-BOX_CodFam:DELIMITER = ":".
      FOR EACH almtfami NO-LOCK WHERE almtfami.codcia = s-codcia /*BY codfam DESC*/:
          COMBO-BOX_CodFam:ADD-LAST(Almtfami.codfam + " - " + Almtfami.desfam, Almtfami.codfam).
          /*COMBO-BOX_CodFam = almtfami.codfam.*/
      END.
      COMBO-BOX_CatConta:DELIMITER = ":".
      FOR EACH almtabla NO-LOCK WHERE almtabla.tabla = "CC":
          COMBO-BOX_CatConta:ADD-LAST(almtabla.Codigo + " - " + almtabla.Nombre, almtabla.Codigo).
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "tw-report"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto W-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE Detalle.

FOR EACH tw-report NO-LOCK:
    CREATE Detalle.
    ASSIGN
        Detalle.CodMat      = tw-report.Campo-C[1] 
        Detalle.DesMat      = tw-report.Campo-C[2] 
        Detalle.UndBas      = tw-report.Campo-C[3] 
        Detalle.SdoIni      = tw-report.Campo-F[1] 
        Detalle.Ingresos    = tw-report.Campo-F[2] 
        Detalle.Salidas     = tw-report.Campo-F[3] 
        Detalle.Saldo       = tw-report.Campo-F[4] 
        Detalle.SaldoEGC    = tw-report.Campo-F[5]
        Detalle.CatContab   = tw-report.Campo-C[4] 
        Detalle.Campana     = tw-report.Campo-C[5] 
        Detalle.NoCampana   = tw-report.Campo-C[6]
        Detalle.CtoUni      = tw-report.Campo-F[6]
        .
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

