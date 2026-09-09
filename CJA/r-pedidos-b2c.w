&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER ORDEN FOR FacCPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.
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

DEFINE IMAGE IMAGE-1 FILENAME "IMG\AUXILIAR" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR NO-UNDO.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
    SKIP
    Fi-Mensaje FORMAT 'x(50)' NO-LABEL FONT 6
    SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
    BGCOLOR 15 FGCOLOR 0 
    TITLE "Procesando ..." FONT 7.

DEFINE TEMP-TABLE Detalle
    FIELD OrdCmp    AS CHAR     FORMAT 'x(15)'          LABEL '# Orden'
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
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tw-report.Campo-C[5] ~
tw-report.Campo-D[1] tw-report.Campo-C[7] tw-report.Campo-C[2] ~
tw-report.Campo-C[3] tw-report.Campo-C[4] tw-report.Campo-F[1] ~
tw-report.Campo-D[10] tw-report.Campo-C[11] tw-report.Campo-F[10] ~
tw-report.Campo-D[12] tw-report.Campo-C[13] tw-report.Campo-F[12] ~
tw-report.Campo-D[15] tw-report.Campo-C[15] tw-report.Campo-C[16] ~
tw-report.Campo-F[15] tw-report.Campo-F[30] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tw-report NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tw-report NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tw-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tw-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX_CodDiv BUTTON-1 BUTTON_Texto ~
BtnDone FILL-IN_FchPed-1 FILL-IN_PorCom FILL-IN_FchPed-2 BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX_CodDiv FILL-IN_FchPed-1 ~
FILL-IN_PorCom FILL-IN_FchPed-2 

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
     SIZE 9 BY 2.15 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/auditor.ico":U
     LABEL "Button 1" 
     SIZE 9 BY 2.15 TOOLTIP "Recopilar Información".

DEFINE BUTTON BUTTON_Texto 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "Button 5" 
     SIZE 9 BY 2.15 TOOLTIP "Exportar a Texto".

DEFINE VARIABLE COMBO-BOX_CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Seleccione la división" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_FchPed-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Pedido Comercial Emitido Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_FchPed-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_PorCom AS DECIMAL FORMAT ">>9.99":U INITIAL 15 
     LABEL "% de Comisión" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tw-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tw-report.Campo-C[5] COLUMN-LABEL "# Orden" FORMAT "X(20)":U
      tw-report.Campo-D[1] COLUMN-LABEL "Fecha!Pedido Comercial" FORMAT "99/99/9999":U
      tw-report.Campo-C[7] COLUMN-LABEL "Estado" FORMAT "X(20)":U
            WIDTH 19.29
      tw-report.Campo-C[2] COLUMN-LABEL "# Pedido Comercial" FORMAT "X(15)":U
      tw-report.Campo-C[3] COLUMN-LABEL "Cliente" FORMAT "X(15)":U
      tw-report.Campo-C[4] COLUMN-LABEL "Nombre" FORMAT "X(100)":U
            WIDTH 43.14
      tw-report.Campo-F[1] COLUMN-LABEL "Importe!Pedido Comercial" FORMAT "->>>,>>>,>>9.9999":U
      tw-report.Campo-D[10] COLUMN-LABEL "Fecha!Pedido Logístico" FORMAT "99/99/9999":U
      tw-report.Campo-C[11] COLUMN-LABEL "# Pedido Logístico" FORMAT "X(15)":U
      tw-report.Campo-F[10] COLUMN-LABEL "Importe!Pedido Logístico" FORMAT "->>>,>>>,>>9.9999":U
      tw-report.Campo-D[12] COLUMN-LABEL "Fecha!Orden de Despacho" FORMAT "99/99/9999":U
      tw-report.Campo-C[13] COLUMN-LABEL "# Orden de Despacho" FORMAT "X(15)":U
      tw-report.Campo-F[12] COLUMN-LABEL "Importe!Orden de Despacho" FORMAT "->>>,>>>,>>9.9999":U
      tw-report.Campo-D[15] COLUMN-LABEL "Fecha de Comprobante" FORMAT "99/99/9999":U
      tw-report.Campo-C[15] COLUMN-LABEL "Cod. Comprobante" FORMAT "X(8)":U
      tw-report.Campo-C[16] COLUMN-LABEL "# de Comprobante" FORMAT "X(15)":U
      tw-report.Campo-F[15] COLUMN-LABEL "Importe Comprobante" FORMAT "->>>,>>>,>>9.9999":U
      tw-report.Campo-F[30] COLUMN-LABEL "Comisión" FORMAT "->>>,>>>,>>9.9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 189 BY 21.27
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX_CodDiv AT ROW 1.54 COL 29 COLON-ALIGNED WIDGET-ID 4
     BUTTON-1 AT ROW 1.54 COL 93 WIDGET-ID 10
     BUTTON_Texto AT ROW 1.54 COL 172 WIDGET-ID 18
     BtnDone AT ROW 1.54 COL 182 WIDGET-ID 16
     FILL-IN_FchPed-1 AT ROW 2.62 COL 29 COLON-ALIGNED WIDGET-ID 6
     FILL-IN_PorCom AT ROW 2.88 COL 59 COLON-ALIGNED WIDGET-ID 20
     FILL-IN_FchPed-2 AT ROW 3.69 COL 29 COLON-ALIGNED WIDGET-ID 8
     BROWSE-2 AT ROW 5.31 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 191.29 BY 26.15
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ORDEN B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: tw-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 26.15
         WIDTH              = 191.29
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
/* BROWSE-TAB BROWSE-2 FILL-IN_FchPed-2 F-Main */
ASSIGN 
       BROWSE-2:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 7.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tw-report"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tw-report.Campo-C[5]
"tw-report.Campo-C[5]" "# Orden" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tw-report.Campo-D[1]
"tw-report.Campo-D[1]" "Fecha!Pedido Comercial" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tw-report.Campo-C[7]
"tw-report.Campo-C[7]" "Estado" "X(20)" "character" ? ? ? ? ? ? no ? no no "19.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tw-report.Campo-C[2]
"tw-report.Campo-C[2]" "# Pedido Comercial" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tw-report.Campo-C[3]
"tw-report.Campo-C[3]" "Cliente" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tw-report.Campo-C[4]
"tw-report.Campo-C[4]" "Nombre" "X(100)" "character" ? ? ? ? ? ? no ? no no "43.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tw-report.Campo-F[1]
"tw-report.Campo-F[1]" "Importe!Pedido Comercial" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tw-report.Campo-D[10]
"tw-report.Campo-D[10]" "Fecha!Pedido Logístico" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tw-report.Campo-C[11]
"tw-report.Campo-C[11]" "# Pedido Logístico" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tw-report.Campo-F[10]
"tw-report.Campo-F[10]" "Importe!Pedido Logístico" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tw-report.Campo-D[12]
"tw-report.Campo-D[12]" "Fecha!Orden de Despacho" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tw-report.Campo-C[13]
"tw-report.Campo-C[13]" "# Orden de Despacho" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.tw-report.Campo-F[12]
"tw-report.Campo-F[12]" "Importe!Orden de Despacho" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.tw-report.Campo-D[15]
"tw-report.Campo-D[15]" "Fecha de Comprobante" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.tw-report.Campo-C[15]
"tw-report.Campo-C[15]" "Cod. Comprobante" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.tw-report.Campo-C[16]
"tw-report.Campo-C[16]" "# de Comprobante" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.tw-report.Campo-F[15]
"tw-report.Campo-F[15]" "Importe Comprobante" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.tw-report.Campo-F[30]
"tw-report.Campo-F[30]" "Comisión" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* <insert SmartWindow title> */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  ASSIGN COMBO-BOX_CodDiv FILL-IN_FchPed-1 FILL-IN_FchPed-2.
  ASSIGN FILL-IN_PorCom.
  RUN Carga-Temporal.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Texto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Texto W-Win
ON CHOOSE OF BUTTON_Texto IN FRAME F-Main /* Button 5 */
DO:
    /* Pantalla de Impresión */
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.

    RUN lib/tt-file-to-onlytext (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    /* Cargamos la informacion al temporal */
    SESSION:SET-WAIT-STATE('GENERAL').

    RUN Carga-Reporte.

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

FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia AND
    Faccpedi.coddiv = COMBO-BOX_CodDiv AND
    Faccpedi.coddoc = "COT" AND
    Faccpedi.fchped >= FILL-IN_FchPed-1 AND
    Faccpedi.fchped <= FILL-IN_FchPed-2:
    Fi-Mensaje = STRING(Faccpedi.fchped, '99/99/9999') + " " + Faccpedi.coddoc + " " + Faccpedi.nroped.
    DISPLAY Fi-Mensaje WITH FRAME F-proceso.
    CREATE tw-report.
    ASSIGN
        tw-report.Campo-C[1] = Faccpedi.coddoc
        tw-report.Campo-C[2] = Faccpedi.nroped
        tw-report.Campo-C[3] = Faccpedi.codcli
        tw-report.Campo-C[4] = Faccpedi.nomcli
        tw-report.Campo-C[5] = Faccpedi.ordcmp
        tw-report.Campo-C[6] = Faccpedi.flgest
    .
    ASSIGN
        tw-report.Campo-D[1] = Faccpedi.fchped
        tw-report.Campo-i[1] = Faccpedi.codmon
        tw-report.Campo-F[1] = Faccpedi.imptot
        .
    RUN vta2/p-faccpedi-flgest.r(Faccpedi.flgest, Faccpedi.coddoc, OUTPUT tw-report.Campo-C[7]).

    /* Buscamos pedido logístico */
    FIND FIRST PEDIDO WHERE PEDIDO.codcia = s-codcia AND
        PEDIDO.codref = Faccpedi.coddoc AND
        PEDIDO.nroref = Faccpedi.nroped AND
        PEDIDO.coddiv = COMBO-BOX_CodDiv AND
        PEDIDO.coddoc = "PED" AND
        PEDIDO.flgest <> "A" NO-LOCK NO-ERROR.
    IF AVAILABLE PEDIDO THEN DO:
        ASSIGN
            tw-report.Campo-C[10] = PEDIDO.coddoc
            tw-report.Campo-C[11] = PEDIDO.nroped
            tw-report.Campo-D[10] = PEDIDO.fchped
            tw-report.Campo-i[10] = Faccpedi.codmon
            tw-report.Campo-F[10] = Faccpedi.imptot
            .
        /* Buscamos la O/D */
        /* Suponemos que solo hay una O/D por cada PED */
        FIND FIRST ORDEN WHERE ORDEN.codcia = s-codcia AND
            ORDEN.codref = PEDIDO.coddoc AND
            ORDEN.nroref = PEDIDO.nroped AND
            ORDEN.coddiv = COMBO-BOX_CodDiv AND
            ORDEN.coddoc = "O/D" AND
            ORDEN.flgest <> "A" NO-LOCK NO-ERROR.
        IF AVAILABLE ORDEN THEN
            ASSIGN
                tw-report.Campo-C[12] = ORDEN.coddoc
                tw-report.Campo-C[13] = ORDEN.nroped
                tw-report.Campo-D[12] = ORDEN.fchped
                tw-report.Campo-i[12] = Faccpedi.codmon
                tw-report.Campo-F[12] = Faccpedi.imptot
            .
        /* Suponemos que hay una FAC por cada O/D */
        FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia AND
            Ccbcdocu.codped = PEDIDO.coddoc AND
            Ccbcdocu.nroped = PEDIDO.nroped AND
            LOOKUP(TRIM(Ccbcdocu.coddoc), 'FAC,BOL') > 0 AND
            Ccbcdocu.flgest <> 'A'
            NO-LOCK NO-ERROR.
        IF AVAILABLE Ccbcdocu THEN
            ASSIGN
                tw-report.Campo-C[15] = Ccbcdocu.coddoc
                tw-report.Campo-C[16] = Ccbcdocu.nrodoc
                tw-report.Campo-D[15] = Ccbcdocu.fchdoc
                tw-report.Campo-i[15] = Ccbcdocu.codmon
                tw-report.Campo-F[15] = Ccbcdocu.imptot
            .
    END.
    /* Comisión */
    ASSIGN
        tw-report.Campo-F[30] = tw-report.Campo-F[15] * FILL-IN_PorCom / 100.

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
  DISPLAY COMBO-BOX_CodDiv FILL-IN_FchPed-1 FILL-IN_PorCom FILL-IN_FchPed-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX_CodDiv BUTTON-1 BUTTON_Texto BtnDone FILL-IN_FchPed-1 
         FILL-IN_PorCom FILL-IN_FchPed-2 BROWSE-2 
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
      COMBO-BOX_CodDiv:DELETE(1).
      COMBO-BOX_CodDiv:DELIMITER = ":".
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND
          GN-DIVI.CanalVenta = "B2C" AND
          GN-DIVI.Campo-Log[1] = NO:
          COMBO-BOX_CodDiv:ADD-LAST(GN-DIVI.CodDiv + " - " + GN-DIVI.DesDiv,GN-DIVI.CodDiv).
          IF TRUE <> (COMBO-BOX_CodDiv > '') THEN COMBO-BOX_CodDiv = gn-divi.coddiv.
      END.
      ASSIGN
          FILL-IN_FchPed-1 = TODAY - DAY(TODAY) + 1
          FILL-IN_FchPed-2 = TODAY.
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

