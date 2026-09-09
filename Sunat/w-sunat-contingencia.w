&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE T-Comprobantes NO-UNDO LIKE FELogComprobantes
       field sactualizar as char init ''
       field fchdoc as date
       field sestado as char
       field imptot as dec.
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.



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
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE SHARED VAR hSocket AS HANDLE NO-UNDO.
DEFINE SHARED VAR hWebService AS HANDLE NO-UNDO.
DEFINE SHARED VAR hPortType AS HANDLE NO-UNDO.
DEFINE VAR hProc AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-excel
    FIELD   tt-coddiv   AS CHAR     FORMAT 'x(6)'       COLUMN-LABEL "Division"
    FIELD   tt-coddoc   AS CHAR     FORMAT 'x(4)'       COLUMN-LABEL "Tipo Doc."
    FIELD   tt-nrodoc   AS CHAR     FORMAT 'x(15)'      COLUMN-LABEL "Nro.Doc"
    FIELD   tt-estado   AS CHAR     FORMAT 'x(5)'       COLUMN-LABEL "Estado"
    FIELD   tt-fchdoc   AS DATE                         COLUMN-LABEL "F.Emision"
    FIELD   tt-codcli   AS CHAR     FORMAT 'x(11)'      COLUMN-LABEL "Cod.Cliente"
    FIELD   tt-nomcli   AS CHAR     FORMAT 'x(80)'      COLUMN-LABEL "Nombre del Cliente"
    FIELD   tt-ruc      AS CHAR     FORMAT 'x(11)'      COLUMN-LABEL "R.U.C."
    FIELD   tt-mone     AS CHAR     FORMAT 'x(10)'      COLUMN-LABEL "Moneda"
    FIELD   tt-impte    AS DEC      FORMAT '->>,>>>,>>9.99'     COLUMN-LABEL "Importe"
    FIELD   tt-tcmb     AS DEC      FORMAT '->>,>>9.9999'       COLUMN-LABEL "Tipo Cambio"
    FIELD   tt-flgppll  AS INT      FORMAT '>99'        COLUMN-LABEL "Flag PPLL"
    FIELD   tt-ppll     AS CHAR     FORMAT 'x(150)'     COLUMN-LABEL "Mensaje PPLL"
    FIELD   tt-flgsunat AS INT      FORMAT '>99'        COLUMN-LABEL "SUNAT / 1=Aceptado"
    FIELD   tt-sunat    AS CHAR     FORMAT 'x(150)'     COLUMN-LABEL "Mensaje SUNAT".

DEFINE VAR x-dobleclick AS LOG INIT NO.

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
&Scoped-define INTERNAL-TABLES T-Comprobantes

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 T-Comprobantes.CodDiv ~
T-Comprobantes.CodDoc T-Comprobantes.NroDoc sestado @ sestado ~
fchdoc @ fchdoc imptot @ imptot T-Comprobantes.LogDate ~
T-Comprobantes.LogEstado T-Comprobantes.FlagEstado 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH T-Comprobantes NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH T-Comprobantes NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 T-Comprobantes
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 T-Comprobantes


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-26 BUTTON-22 BUTTON-Division txtDesde ~
txtHasta ChkFac ChkBol ChkN_C ChkN_D BUTTON-19 txtEmpieze BROWSE-4 
&Scoped-Define DISPLAYED-OBJECTS chbReprocesa x-CodDiv txtDesde txtHasta ~
ChkFac ChkBol ChkN_C ChkN_D txtEmpieze FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-19 
     LABEL "Aceptar" 
     SIZE 15.14 BY .92.

DEFINE BUTTON BUTTON-20 
     LABEL "Actualizar el Estado SUNAT en DB" 
     SIZE 26.57 BY .96.

DEFINE BUTTON BUTTON-21 
     LABEL "Validar con SUNAT" 
     SIZE 23 BY 1.04.

DEFINE BUTTON BUTTON-22 
     LABEL "Re-enviar documentos Faltantes a SUNAT" 
     SIZE 29.72 BY 1.04.

DEFINE BUTTON BUTTON-24 
     LABEL "Enviar a Excel" 
     SIZE 23 BY 1.08.

DEFINE BUTTON BUTTON-25 
     LABEL "Obtener el CDR de SUNAT" 
     SIZE 23 BY 1.04.

DEFINE BUTTON BUTTON-26 
     LABEL "..." 
     SIZE 4 BY .73.

DEFINE BUTTON BUTTON-Division 
     LABEL "..." 
     SIZE 4 BY .77 TOOLTIP "Selecciona Divisiones".

DEFINE VARIABLE x-CodDiv AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 62 BY 1.92 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 137.86 BY .81
     BGCOLOR 15 FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .81 NO-UNDO.

DEFINE VARIABLE txtEmpieze AS CHARACTER FORMAT "X(256)":U 
     LABEL "Que empiezen en" 
     VIEW-AS FILL-IN 
     SIZE 39 BY .81 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .81 NO-UNDO.

DEFINE VARIABLE chbReprocesa AS LOGICAL INITIAL no 
     LABEL "Reprocesar los OK" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .77 NO-UNDO.

DEFINE VARIABLE ChkBol AS LOGICAL INITIAL yes 
     LABEL "Boletas" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

DEFINE VARIABLE ChkFac AS LOGICAL INITIAL yes 
     LABEL "Facturas" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

DEFINE VARIABLE ChkN_C AS LOGICAL INITIAL no 
     LABEL "Nota Credito" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.57 BY .77 NO-UNDO.

DEFINE VARIABLE ChkN_D AS LOGICAL INITIAL no 
     LABEL "Nota Debito" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.57 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      T-Comprobantes SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      T-Comprobantes.CodDiv FORMAT "x(5)":U WIDTH 6.57
      T-Comprobantes.CodDoc FORMAT "x(3)":U
      T-Comprobantes.NroDoc FORMAT "X(12)":U WIDTH 10.14
      sestado @ sestado COLUMN-LABEL "Estado" FORMAT "x(3)":U
      fchdoc @ fchdoc COLUMN-LABEL "Emitido" FORMAT "99/99/9999":U
            WIDTH 10.43
      imptot @ imptot COLUMN-LABEL "Importe" FORMAT ">>>,>>9.99":U
      T-Comprobantes.LogDate FORMAT "99/99/9999 HH:MM:SS.SSS":U
      T-Comprobantes.LogEstado COLUMN-LABEL "Log PPLL" FORMAT "x(60)":U
            WIDTH 14.43
      T-Comprobantes.FlagEstado COLUMN-LABEL "Log SUNAT (Doble Click para ver mas detalle)" FORMAT "x(60)":U
            WIDTH 30.86 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11 LABEL-FGCOLOR 15 LABEL-BGCOLOR 9
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 110.14 BY 19.81
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-26 AT ROW 24.92 COL 140 WIDGET-ID 136
     chbReprocesa AT ROW 26.08 COL 25.57 WIDGET-ID 134
     BUTTON-21 AT ROW 25.92 COL 2.43 WIDGET-ID 114
     BUTTON-22 AT ROW 25.92 COL 73 WIDGET-ID 116
     x-CodDiv AT ROW 1.96 COL 2 NO-LABEL WIDGET-ID 92
     BUTTON-Division AT ROW 1.96 COL 64.86 WIDGET-ID 78
     txtDesde AT ROW 1.23 COL 76.86 COLON-ALIGNED WIDGET-ID 98
     txtHasta AT ROW 1.23 COL 95.86 COLON-ALIGNED WIDGET-ID 100
     ChkFac AT ROW 2.31 COL 73.14 WIDGET-ID 102
     ChkBol AT ROW 2.31 COL 84.43 WIDGET-ID 104
     ChkN_C AT ROW 2.31 COL 96.72 WIDGET-ID 106
     ChkN_D AT ROW 2.31 COL 110.29 WIDGET-ID 108
     BUTTON-19 AT ROW 3.88 COL 127 WIDGET-ID 86
     BUTTON-20 AT ROW 25.96 COL 103.29 WIDGET-ID 88
     txtEmpieze AT ROW 3.23 COL 79.14 COLON-ALIGNED WIDGET-ID 110
     FILL-IN-Mensaje AT ROW 24.92 COL 2.14 NO-LABEL WIDGET-ID 90
     BROWSE-4 AT ROW 5.04 COL 1.86 WIDGET-ID 200
     BUTTON-24 AT ROW 25.88 COL 130.43 WIDGET-ID 124
     BUTTON-25 AT ROW 25.92 COL 49.43 WIDGET-ID 132
     "División:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 1.38 COL 2.43 WIDGET-ID 94
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 154 BY 26.08
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-Comprobantes T "NEW SHARED" NO-UNDO INTEGRAL FELogComprobantes
      ADDITIONAL-FIELDS:
          field sactualizar as char init ''
          field fchdoc as date
          field sestado as char
          field imptot as dec
      END-FIELDS.
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "SUNAT - DOCUMENTOS DE CONTINGENCIA"
         HEIGHT             = 26.08
         WIDTH              = 154
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 154
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 154
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-4 FILL-IN-Mensaje F-Main */
/* SETTINGS FOR BUTTON BUTTON-20 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-20:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-21 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-21:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-24 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-24:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-25 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-25:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX chbReprocesa IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       chbReprocesa:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR EDITOR x-CodDiv IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.T-Comprobantes"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.T-Comprobantes.CodDiv
"CodDiv" ? ? "character" ? ? ? ? ? ? no ? no no "6.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.T-Comprobantes.CodDoc
     _FldNameList[3]   > Temp-Tables.T-Comprobantes.NroDoc
"NroDoc" ? "X(12)" "character" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"sestado @ sestado" "Estado" "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fchdoc @ fchdoc" "Emitido" "99/99/9999" ? ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"imptot @ imptot" "Importe" ">>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = Temp-Tables.T-Comprobantes.LogDate
     _FldNameList[8]   > Temp-Tables.T-Comprobantes.LogEstado
"LogEstado" "Log PPLL" "x(60)" "character" ? ? ? ? ? ? no ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-Comprobantes.FlagEstado
"FlagEstado" "Log SUNAT (Doble Click para ver mas detalle)" "x(60)" "character" 11 0 ? 9 15 ? no ? no no "30.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* SUNAT - DOCUMENTOS DE CONTINGENCIA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* SUNAT - DOCUMENTOS DE CONTINGENCIA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
&Scoped-define SELF-NAME BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 W-Win
ON LEFT-MOUSE-DBLCLICK OF BROWSE-4 IN FRAME F-Main
DO:
  IF NOT AVAILABLE T-Comprobantes THEN RETURN.
  /*RUN sunat\d-verifica-sunat ( INPUT ROWID(T-Comprobantes) ).*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-4 IN FRAME F-Main
DO:

    ASSIGN fill-in-mensaje.

    IF TRUE <> (fill-in-mensaje > "") THEN DO:
        MESSAGE "Por favor ingrese la ruta donde grabar los archivos" VIEW-AS ALERT-BOX WARNING.
    END.
    ELSE DO:
        /*
        IF AVAILABLE T-Comprobantes THEN DO:
            IF t-comprobantes.codhash = ? OR t-comprobantes.codhash = "" THEN DO:
                IF t-comprobantes.sactualizar = 'X' THEN DO:
                    MESSAGE 'Seguro de envia a PPL (' + T-Comprobantes.coddoc + ' ' + T-Comprobantes.nrodoc + ')?' VIEW-AS ALERT-BOX QUESTION
                            BUTTONS YES-NO UPDATE rpta AS LOG.
                    IF rpta = YES THEN DO:
                       IF s-user-id = 'ADMIN' THEN s-user-id = 'PRUEBAS'.
                        x-dobleclick = YES.
                        RUN envio-a-ppl.
                        x-dobleclick = NO.
                        s-user-id = 'ADMIN'.
                    END.
                END.
            END.
        END.
        */
        MESSAGE 'Seguro de generar archivo de (' + T-Comprobantes.coddoc + ' ' + T-Comprobantes.nrodoc + ')?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.

        IF rpta = YES THEN DO:
            x-dobleclick = YES.
            RUN generar-file-txt.
            x-dobleclick = NO.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 W-Win
ON VALUE-CHANGED OF BROWSE-4 IN FRAME F-Main
DO:
  /*FILL-IN-mensaje:SCREEN-VALUE = t-comprobantes.flagestado.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-19
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-19 W-Win
ON CHOOSE OF BUTTON-19 IN FRAME F-Main /* Aceptar */
DO:
  ASSIGN  x-CodDiv txtDesde txtHasta /*rdFiltro rbReferencia*/.
  ASSIGN chkFac ChkBol ChkN_C chkN_D.

  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal.
  SESSION:SET-WAIT-STATE('').
  {&OPEN-QUERY-{&BROWSE-NAME}}
  MESSAGE "Proceso Terminado" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-20
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-20 W-Win
ON CHOOSE OF BUTTON-20 IN FRAME F-Main /* Actualizar el Estado SUNAT en DB */
DO:
  RUN Actualizar-Base.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-21
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-21 W-Win
ON CHOOSE OF BUTTON-21 IN FRAME F-Main /* Validar con SUNAT */
DO:
    ASSIGN chbReprocesa.
  RUN estado-sunat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-22
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-22 W-Win
ON CHOOSE OF BUTTON-22 IN FRAME F-Main /* Re-enviar documentos Faltantes a SUNAT */
DO:
  RUN ue-enviar-a-ppl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-24
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-24 W-Win
ON CHOOSE OF BUTTON-24 IN FRAME F-Main /* Enviar a Excel */
DO:
  RUN ue-excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-25
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-25 W-Win
ON CHOOSE OF BUTTON-25 IN FRAME F-Main /* Obtener el CDR de SUNAT */
DO:
  RUN ue-cdr-sunat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-26
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-26 W-Win
ON CHOOSE OF BUTTON-26 IN FRAME F-Main /* ... */
DO:
	DEFINE VAR lDirectorio AS CHAR.

	lDirectorio = "".

	SYSTEM-DIALOG GET-DIR lDirectorio  
	   RETURN-TO-START-DIR 
	   TITLE 'Directorio Files'.
	IF lDirectorio <> "" THEN DO:
        fill-in-mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = lDirectorio.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Division W-Win
ON CHOOSE OF BUTTON-Division IN FRAME F-Main /* ... */
DO:
    ASSIGN x-CodDiv.
    RUN gn/d-filtro-divisiones (INPUT-OUTPUT x-CodDiv, "SELECCIONE LAS DIVISIONES").
    DISPLAY x-CodDiv WITH FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualizar-Base W-Win 
PROCEDURE Actualizar-Base :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE 'Seguro de realizar proceso?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.

SESSION:SET-WAIT-STATE('GENERAL').

FOR EACH T-Comprobantes WHERE t-comprobantes.sactualizar = 'SUNAT',
    FIRST FELogComprobantes WHERE FELogComprobantes.CodCia = T-Comprobantes.CodCia
    AND FELogComprobantes.Coddiv = T-Comprobantes.Coddiv
    AND FELogComprobantes.CodDoc = T-Comprobantes.CodDoc
    AND FELogComprobantes.NroDoc = T-Comprobantes.NroDoc:
    ASSIGN
        FELogComprobantes.FlagEstado = T-Comprobantes.FlagEstado
        FELogComprobantes.EstadoSunat = T-Comprobantes.EstadoSunat
        FELogComprobantes.FlagSunat = T-Comprobantes.FlagSunat.
END.
EMPTY TEMP-TABLE T-Comprobantes.
{&OPEN-QUERY-{&BROWSE-NAME}}

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

/* Cargamos Temporal con la base de datos */
DEF VAR k AS INT NO-UNDO.
DEF VAR Desde AS DATE NO-UNDO.
DEF VAR Hasta AS DATE NO-UNDO.

DEFINE VAR lDocumentos AS CHAR NO-UNDO INIT "".
DEF VAR lSecDoc AS INT NO-UNDO.
DEFINE VAR lCodDocto AS CHAR.
DEFINE VAR lFecha AS DATE.
DEFINE VAR lSerie AS INT.
DEFINE VAR lRef AS CHAR.

/*RUN src\bin\_dateif ( COMBO-BOX-NroMes, FILL-IN-Periodo, OUTPUT Desde, OUTPUT Hasta).*/

IF ChkFac = YES THEN lDocumentos = "FAC".

IF ChkBol = YES THEN DO:
    IF lDocumentos <> "" THEN lDocumentos = lDocumentos + ",".
    lDocumentos = lDocumentos + "BOL".
END.
IF Chkn_c = YES THEN DO:
    IF lDocumentos <> "" THEN lDocumentos = lDocumentos + ",".
    lDocumentos = lDocumentos + "N/C".
END.
IF Chkn_d = YES THEN DO:
    IF lDocumentos <> "" THEN lDocumentos = lDocumentos + ",".
    lDocumentos = lDocumentos + "N/D".
END.    

EMPTY TEMP-TABLE T-Comprobantes.

SESSION:SET-WAIT-STATE('GENERAL').

DO lFecha = txtDesde TO txtHasta:
    DO k = 1 TO NUM-ENTRIES(x-CodDiv):
        FIND gn-divi WHERE gn-divi.codcia = s-codcia
            AND gn-divi.coddiv = ENTRY(k,x-CodDiv)
            NO-LOCK.

        DO lSecDoc = 1 TO NUM-ENTRIES(lDocumentos):
            lCodDocto = ENTRY(lSecDoc,lDocumentos).
            FOR EACH Ccbcdocu NO-LOCK USE-INDEX llave10 WHERE CcbCDocu.CodCia = s-codcia
                AND CcbCDocu.CodDiv = ENTRY(k,x-CodDiv)
                AND CcbCDocu.FchDoc = lFecha
                AND CcbCDocu.CodDoc = lCodDocto
                AND (txtEmpieze = "" OR CcbCDocu.NroDoc BEGINS txtEmpieze )
                /*AND CcbCDocu.FlgEst <> "A":*/:
        
                IF Ccbcdocu.FchDoc < GN-DIVI.Libre_f01 THEN NEXT.

                lSerie = INTEGER(SUBSTRING(CcbCDocu.NroDoc,1,3)) NO-ERROR.
                FIND FIRST faccorre USE-INDEX llave02 WHERE faccorre.codcia = s-codcia AND
                                faccorre.coddiv = ccbcdocu.coddiv AND 
                                faccorre.coddoc = ccbcdocu.coddoc AND
                                faccorre.nroser = lSerie NO-LOCK NO-ERROR.

                /*
                FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
                    "VERIFICANDO: " + ccbcdocu.coddiv + ' '  +
                    ccbcdocu.coddoc + ' ' + ccbcdocu.nrodoc + ' ' +
                    STRING(ccbcdocu.fchdoc).
                */
                /*
                FIND FELogComprobantes WHERE FELogComprobantes.CodCia = CcbCDocu.CodCia
                    AND FELogComprobantes.CodDiv = CcbCDocu.Coddiv
                    AND FELogComprobantes.CodDoc = CcbCDocu.CodDoc
                    AND FELogComprobantes.NroDoc = CcbCDocu.NroDoc
                    NO-LOCK NO-ERROR.
                */
                IF AVAILABLE faccorre THEN DO:
                    /*IF faccorre.id_pos = 'MANUAL' AND NOT AVAILABLE FELogComprobantes THEN NEXT.*/
                    IF faccorre.id_pos <> 'MANUAL' THEN NEXT.
                END.
                
                /* Referencia */
                lRef = ''.
                /*
                IF ccbcdocu.coddoc = 'N/C' OR ccbcdocu.coddoc = 'N/D' THEN DO:
                    IF rbReferencia <> 3 THEN DO:
                        IF ccbcdocu.codref <> ? THEN lRef = TRIM(ccbcdocu.codref).                    
                        IF lRef = "" THEN DO:
                            IF AVAILABLE FElogComprobantes THEN DO:
                                IF FELogComprobante.numdocumento <> ? THEN lRef = TRIM(FELogComprobante.numdocumento).
                            END.
                        END.
                    END.
                    lRef = CAPS(lRef).
                    IF lRef = "" THEN lRef = " ".
                    IF rbReferencia = 1 AND SUBSTRING(lRef,1,1) <> "B" THEN NEXT.
                    IF rbReferencia = 2 AND SUBSTRING(lRef,1,1) <> "F" THEN NEXT.
                END.
                */

                CREATE T-Comprobantes.
                ASSIGN
                    T-Comprobantes.CodCia = CcbCDocu.CodCia
                    T-Comprobantes.CodDiv = CcbCDocu.CodDiv
                    T-Comprobantes.CodDoc = CcbCDocu.CodDoc
                    T-Comprobantes.NroDoc = CcbCDocu.NroDoc
                    T-Comprobantes.LogEstado = "Comprobante NO registrado en el log de control"
                    t-comprobantes.sactualizar = 'X'
                    t-comprobantes.fchdoc = CcbCDocu.FchDoc
                    t-comprobantes.sestado = CcbCDocu.flgest
                    t-comprobantes.imptot = ccbcdocu.imptot
                    .
                    
            
                /*
                IF NOT AVAILABLE FELogComprobantes THEN DO:
                    IF rdFiltro = 1 OR rdFiltro = 3 THEN DO:
                        CREATE T-Comprobantes.
                        ASSIGN
                            T-Comprobantes.CodCia = CcbCDocu.CodCia
                            T-Comprobantes.CodDiv = CcbCDocu.CodDiv
                            T-Comprobantes.CodDoc = CcbCDocu.CodDoc
                            T-Comprobantes.NroDoc = CcbCDocu.NroDoc
                            T-Comprobantes.LogEstado = "Comprobante NO registrado en el log de control"
                            t-comprobantes.sactualizar = 'X'
                            t-comprobantes.fchdoc = CcbCDocu.FchDoc
                            t-comprobantes.sestado = CcbCDocu.flgest.
                    END.
                END.
                ELSE DO:
                    IF rdFiltro = 1 OR (rdFiltro = 2 AND FELogComprobantes.flagSunat = 0 ) THEN DO:
                        /* 1:Todos  2:Sin Validacion de SUNAT */
                        CREATE T-Comprobantes.
                        BUFFER-COPY FELogComprobantes TO T-Comprobantes.
                        ASSIGN t-comprobantes.sactualizar = 'OK'
                                t-comprobantes.fchdoc = CcbCDocu.FchDoc
                                t-comprobantes.sestado = CcbCDocu.flgest.
                    END.
                    ELSE DO:
                        IF rdFiltro = 4 AND FELogComprobantes.estadoSunat > 1 THEN DO:
                            /* Rechazados x SUNAT */
                            CREATE T-Comprobantes.
                            BUFFER-COPY FELogComprobantes TO T-Comprobantes.
                            ASSIGN t-comprobantes.sactualizar = 'OK'
                                    t-comprobantes.fchdoc = CcbCDocu.FchDoc
                                    t-comprobantes.sestado = CcbCDocu.flgest.
                        END.
                    END.
                END.
                */
            END.
        END.
    END.
END.

SESSION:SET-WAIT-STATE('').

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
  DISPLAY chbReprocesa x-CodDiv txtDesde txtHasta ChkFac ChkBol ChkN_C ChkN_D 
          txtEmpieze FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-26 BUTTON-22 BUTTON-Division txtDesde txtHasta ChkFac ChkBol 
         ChkN_C ChkN_D BUTTON-19 txtEmpieze BROWSE-4 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE envio-a-ppl W-Win 
PROCEDURE envio-a-ppl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR pMensaje AS CHAR.

IF AVAILABLE T-Comprobantes THEN DO:
    IF t-comprobantes.codhash = ? OR t-comprobantes.codhash = "" THEN DO:
        IF t-comprobantes.sactualizar = 'X' THEN DO:
            /* Solo aquellos que no esten en FELOGCOMPROBANTES */
            FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                        ccbcdocu.coddiv = t-comprobantes.coddiv AND
                                        ccbcdocu.coddoc = t-comprobantes.coddoc AND
                                        ccbcdocu.nrodoc = t-comprobantes.nrodoc AND
                                        ccbcdocu.flgest <> "A" NO-LOCK NO-ERROR.
            IF AVAILABLE ccbcdocu THEN DO:
                
                RUN sunat\progress-to-ppll-v3( INPUT Ccbcdocu.coddiv,
                                               INPUT Ccbcdocu.coddoc,
                                               INPUT Ccbcdocu.nrodoc,
                                               INPUT-OUTPUT TABLE T-FELogErrores,
                                               OUTPUT pMensaje ).
            END.
            ELSE DO:
                pMensaje = "El comprobante no existe o esta ANULADO".
            END.
        END.
        ELSE DO:
            /* 
                El comprobante existe en FELOGCOMPROBANTES sin HASH
                hay que reenviarlo con el mismo IDpos y IPpos
            */
        END.
    END.
    ELSE DO:
        pMensaje = "El comprobante ya tiene HASH".
    END.
END.
ELSE DO:
    pMensaje = "No existe comprobante".
END.
IF x-dobleclick = YES THEN DO:
    MESSAGE pMensaje.
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE estado-sunat W-Win 
PROCEDURE estado-sunat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Levantamos las rutinas a memoria */
DEFINE VAR hProc AS HANDLE NO-UNDO.
DEFINE VAR cRetVal AS CHAR.
DEFINE VAR lPreFijoDocmnto AS CHAR.
DEFINE VAR cTipoDocmnto AS CHAR.
DEFINE VAR lNroDocmnto AS CHAR.

MESSAGE 'Seguro de realizar proceso?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.

SESSION:SET-WAIT-STATE('GENERAL').
RUN sunat\facturacion-electronica.p PERSISTENT SET hProc.

/*
IF ERROR-STATUS:ERROR = YES THEN DO:
    pCodError = "ERROR en las librerias de la Facturación Electrónica" + CHR(10) +
        "Salir del Sistema, volver a entrar y repetir el proceso".
    RETURN "ADM-ERROR".
END.

cRetVal = "".
RUN pget-estado-doc-eserver IN hProc (INPUT cTipoDocmnto, INPUT lNroDocmnto, OUTPUT cRetVal).

cTipoDocmnto = DYNAMIC-FUNCTION('fget-tipo-documento':U IN hProc, INPUT t-comprobantes.coddoc) .  

*/


RUN pcrea-obj-xml IN hProc.

FOR EACH T-Comprobantes 
    WHERE T-Comprobantes.estadosunat = 0 OR T-Comprobantes.estadosunat > 1
            OR (chbReprocesa = YES AND T-Comprobantes.estadosunat = 1) :
    /*
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
        "SUNAT: " + T-Comprobantes.coddiv + ' '  +
        T-Comprobantes.coddoc + ' ' + T-Comprobantes.nrodoc.
    */
    cRetVal = "".
    RUN pestado-documento-sunat IN hProc 
        (INPUT T-Comprobantes.coddoc, 
         INPUT T-Comprobantes.nrodoc, 
         INPUT T-Comprobantes.coddiv,
         OUTPUT cRetVal).

    IF cRetVal <> "" THEN DO:
        ASSIGN T-Comprobantes.flagsunat = 1
                T-Comprobantes.estadosunat = DEC(ENTRY(1,cretval,"|"))
                T-Comprobantes.flagestado = ENTRY(1,cretval,"|") + " - " + ENTRY(2,cretval,"|").
        ASSIGN t-comprobantes.sactualizar = 'SUNAT'.
    END.

END.

RUN pelimina-obj-xml IN hProc.


DELETE PROCEDURE hProc.
SESSION:SET-WAIT-STATE('').

{&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-file-txt W-Win 
PROCEDURE generar-file-txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-mensaje AS CHAR.

IF AVAILABLE T-Comprobantes THEN DO:
            /* Solo aquellos que no esten en FELOGCOMPROBANTES */
    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                ccbcdocu.coddiv = t-comprobantes.coddiv AND
                                ccbcdocu.coddoc = t-comprobantes.coddoc AND
                                ccbcdocu.nrodoc = t-comprobantes.nrodoc AND
                                ccbcdocu.flgest <> "A" NO-LOCK NO-ERROR.
    IF AVAILABLE ccbcdocu THEN DO:
        
        RUN sunat\facturacion-electronicav2.p PERSISTENT SET hProc NO-ERROR.

        IF ERROR-STATUS:ERROR = YES THEN DO:
            MESSAGE "ERROR en las librerias de la Facturación Electrónica" + CHR(10) +
                "Salir del Sistema, volver a entrar y repetir el proceso".
            RETURN "ADM-ERROR".
        END.

        RUN generar-file-contingencia IN hProc ( INPUT Ccbcdocu.coddoc,
                                       INPUT Ccbcdocu.nrodoc,
                                       INPUT Ccbcdocu.coddiv,
                                       INPUT fill-in-mensaje,
                                       OUTPUT x-mensaje ).

        DELETE PROCEDURE hProc.

        IF x-mensaje = 'OK' THEN DO:
            MESSAGE "Generacion OK" VIEW-AS ALERT-BOX INFORMATION.
        END.
        ELSE DO:
            MESSAGE "Hubo ERROR : " + x-mensaje VIEW-AS ALERT-BOX ERROR.
        END.
    END.
    ELSE DO:
        x-mensaje = "El comprobante no existe o esta ANULADO".
    END.
END.

END PROCEDURE.

/*
DEFINE INPUT PARAMETER pTipoDocmto AS CHAR.
DEFINE INPUT PARAMETER pNroDocmto AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE INPUT PARAMETER pRutaContingencia AS CHAR.
DEFINE OUTPUT PARAMETER pReturn AS CHAR NO-UNDO.

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

  ASSIGN txtDesde = TODAY - 2
        txtHasta = TODAY.

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
  {src/adm/template/snd-list.i "T-Comprobantes"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-cdr-sunat W-Win 
PROCEDURE ue-cdr-sunat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


MESSAGE 'Seguro de GENERAR el CDR de la SUNAT?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.

DEFINE VAR lDirectorio AS CHAR. 
    
SYSTEM-DIALOG GET-DIR lDirectorio  
   RETURN-TO-START-DIR 
   TITLE 'Elija el directorio'.

IF lDirectorio = "" OR lDirectorio = ? THEN RETURN.

lDirectorio = lDirectorio + "\".

DEFINE VAR hProc AS HANDLE NO-UNDO.
DEFINE VAR cRetVal AS CHAR.
DEFINE VAR lRowSele AS INT.
DEFINE VAR lRowSeleTot AS INT.

SESSION:SET-WAIT-STATE('GENERAL').
RUN sunat\facturacion-electronica.p PERSISTENT SET hProc.

/*
IF ERROR-STATUS:ERROR = YES THEN DO:
    pCodError = "ERROR en las librerias de la Facturación Electrónica" + CHR(10) +
        "Salir del Sistema, volver a entrar y repetir el proceso".
    RETURN "ADM-ERROR".
END.

*/

RUN pcrea-obj-xml IN hProc.

/*FOR EACH T-Comprobantes WHERE T-Comprobantes.estadosunat = 0 OR T-Comprobantes.estadosunat = 3:  /* Paper Less OK */*/
DO WITH FRAME {&FRAME-NAME}.
    lRowSeleTot = {&BROWSE-NAME}:NUM-SELECTED-ROWS.
    DO lRowSele = 1 TO lRowSeleTot:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(lRowSele) THEN DO:
            cRetVal = "".
            
            RUN pobtener-cdr-sunat IN hProc 
                (INPUT T-Comprobantes.coddoc, 
                 INPUT T-Comprobantes.nrodoc, 
                 INPUT T-Comprobantes.coddiv,
                 INPUT lDirectorio,
                 OUTPUT cRetVal).
            /*
            IF cRetVal <> "" THEN DO:
                ASSIGN T-Comprobantes.flagsunat = 1
                        T-Comprobantes.estadosunat = DEC(ENTRY(1,cretval,"|"))
                        T-Comprobantes.flagestado = ENTRY(1,cretval,"|") + " - " + ENTRY(2,cretval,"|").
                ASSIGN t-comprobantes.sactualizar = 'SUNAT'.
            END.
            */
        END.
    END.
END.
/*END.*/

RUN pelimina-obj-xml IN hProc.


DELETE PROCEDURE hProc.
SESSION:SET-WAIT-STATE('').

{&OPEN-QUERY-{&BROWSE-NAME}}



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-confirmar-documento W-Win 
PROCEDURE ue-confirmar-documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFIN VAR lRetVal AS CHAR NO-UNDO.
DEFINE VAR iFlagPPLL AS INT.
DEFINE VAR iEstadoPPLL AS INT.
DEFINE VAR hProc AS HANDLE NO-UNDO.

MESSAGE 'Seguro de realizar el proceso de CONFIRMACION de documento?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.
        
SESSION:SET-WAIT-STATE('GENERAL').

/* Levantamos las rutinas a memoria */
RUN sunat\facturacion-electronica.p PERSISTENT SET hProc NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    MESSAGE "ERROR en las librerias de la Facturación Electrónica" + CHR(10) +
        "Salir del Sistema, volver a entrar y repetir el proceso".
    RETURN "ADM-ERROR".
END.

IF VALID-HANDLE(hSocket) THEN DELETE OBJECT hSocket.
CREATE SOCKET hSocket.

FOR EACH T-Comprobantes :
    IF t-comprobantes.codhash <> ? AND t-comprobantes.codhash <> "" THEN DO:
        IF t-comprobantes.FlagPPLL = 2 THEN DO:
            iFlagPPLL = t-comprobantes.FlagPPLL.
            lRetVal = "".
            
            RUN pconfirmar-documento-preanulado IN hProc (INPUT t-comprobantes.CodDoc,
                                               INPUT t-comprobantes.NroDoc,
                                               INPUT t-comprobantes.CodDiv,
                                               OUTPUT lRetVal).
            MESSAGE t-comprobantes.CodDoc t-comprobantes.NroDoc lRetVal.
            /* Si los 3 primeros digitos del cRetVal = "000" */
            IF SUBSTRING(lRetVal,1,3) = "000" THEN DO:
                iEstadoPPLL = INTEGER(ENTRY(1,lRetVal,'|')) NO-ERROR.
                FIND FIRST FELogComprobantes WHERE FELogComprobantes.codcia = s-codcia AND
                            FELogComprobantes.coddiv = t-comprobantes.coddiv AND
                            FELogComprobantes.coddoc = t-comprobantes.coddoc AND 
                            FELogComprobantes.nrodoc = t-comprobantes.nrodoc NO-ERROR.
                IF AVAILABLE FELogComprobantes THEN DO:
                    ASSIGN FELogComprobantes.FlagPPLL   = (IF SUBSTRING(lRetVal,1,3) = "000" THEN 1 ELSE iFlagPPLL)
                            FELogComprobantes.EstadoPPLL = iEstadoPPLL.
                END.
                RELEASE FELogComprobantes.
                ASSIGN t-Comprobantes.FlagPPLL   = (IF SUBSTRING(lRetVal,1,3) = "000" THEN 1 ELSE iFlagPPLL)
                        t-Comprobantes.EstadoPPLL = iEstadoPPLL.

            END.
        END.
    END.
END.
SESSION:SET-WAIT-STATE('').

FIND FIRST T-Comprobantes NO-ERROR.

/*
EMPTY TEMP-TABLE T-Comprobantes.
{&OPEN-QUERY-{&BROWSE-NAME}}
*/
END PROCEDURE.

/*
    cRetVal = "".
    RUN pconfirmar-documento IN hProc (INPUT B-CDOCU.CodDoc,
                                       INPUT B-CDOCU.NroDoc,
                                       INPUT B-CDOCU.CodDiv,
                                       OUTPUT cRetVal).
    /* Si los 3 primeros digitos del cRetVal = "000" */
    IF SUBSTRING(cRetVal,1,3) <> "000" THEN DO:
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-enviar-a-ppl W-Win 
PROCEDURE ue-enviar-a-ppl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/      

DEFINE VAR lRetVal AS CHAR NO-UNDO.
DEFINE VAR pMensaje AS CHAR NO-UNDO.
DEFINE VAR lRowSeleTot AS INT.
DEFINE VAR lRowSele AS INT.

MESSAGE 'Seguro de realizar el proceso de envio a SUNAT?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.
        
SESSION:SET-WAIT-STATE('GENERAL').
/*
DO WITH FRAME {&FRAME-NAME}.
    lRowSeleTot = BROWSE-4:NUM-SELECTED-ROWS.
    DO lRowSele = 1 TO lRowSeleTot:
        IF BROWSE-4:FETCH-SELECTED-ROW(lRowSele) THEN DO:
            IF t-comprobantes.codhash = ? OR t-comprobantes.codhash = "" THEN DO:

                FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                            ccbcdocu.coddiv = t-comprobantes.coddiv AND
                                            ccbcdocu.coddoc = t-comprobantes.coddoc AND
                                            ccbcdocu.nrodoc = t-comprobantes.nrodoc
                                            NO-LOCK NO-ERROR.

                MESSAGE Ccbcdocu.nrodoc VIEW-AS ALERT-BOX QUESTION
                        BUTTONS YES-NO UPDATE rpta2 AS LOG.
                IF rpta2 = YES THEN DO:
                    RUN sunat\progress-to-ppll-v3( INPUT Ccbcdocu.coddiv,
                                                   INPUT Ccbcdocu.coddoc,
                                                   INPUT Ccbcdocu.nrodoc,
                                                   INPUT-OUTPUT TABLE T-FELogErrores,
                                                   OUTPUT pMensaje ).
                END.
            END.
        END.
    END.
END.
*/


FOR EACH T-Comprobantes :
    IF t-comprobantes.codhash = ? OR t-comprobantes.codhash = "" THEN DO:
        IF t-comprobantes.sactualizar = 'X' THEN DO:

            RUN envio-a-ppl.
            /*
            /* Solo aquellos que no esten en FELOGCOMPROBANTES */
            FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                        ccbcdocu.coddiv = t-comprobantes.coddiv AND
                                        ccbcdocu.coddoc = t-comprobantes.coddoc AND
                                        ccbcdocu.nrodoc = t-comprobantes.nrodoc
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE ccbcdocu THEN DO:
                lRetVal = "".
/*                 RUN sunat/progress-to-ppll-v21(ROWID(ccbcdocu), INPUT-OUTPUT TABLE T-FELogErrores, OUTPUT lRetVal). */
                RUN sunat\progress-to-ppll-v3( INPUT Ccbcdocu.coddiv,
                                               INPUT Ccbcdocu.coddoc,
                                               INPUT Ccbcdocu.nrodoc,
                                               INPUT-OUTPUT TABLE T-FELogErrores,
                                               OUTPUT pMensaje ).
                /*MESSAGE lRetVal.*/
            END.
            */
        END.
        ELSE DO:
            /* 
                El comprobante existe en FELOGCOMPROBANTES sin HASH
                hay que reenviarlo con el mismo IDpos y IPpos
            */
        END.
    END.
END.


SESSION:SET-WAIT-STATE('').
EMPTY TEMP-TABLE T-Comprobantes.
{&OPEN-QUERY-{&BROWSE-NAME}}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-excel W-Win 
PROCEDURE ue-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE 'Seguro de GENERAR el EXCEL?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.

DEFINE VAR x-Archivo    AS CHAR.

SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Excel (*.xlsx)' '*.xlsx'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.xlsx'
    RETURN-TO-START-DIR
    SAVE-AS
    TITLE 'Exportar a Excel'
    UPDATE rpta.
IF rpta = NO OR x-Archivo = '' THEN RETURN.


DEFINE BUFFER b-ccdoc FOR ccbcdocu.

SESSION:SET-WAIT-STATE('GENERAL').

FOR EACH t-comprobantes :
    FIND FIRST b-ccdoc WHERE    b-ccdoc.codcia = s-codcia AND
                                b-ccdoc.coddiv = t-comprobantes.coddiv AND 
                                b-ccdoc.coddoc = t-comprobantes.coddoc AND 
                                b-ccdoc.nrodoc = t-comprobantes.nrodoc NO-LOCK NO-ERROR.

    CREATE tt-excel.
    ASSIGN  tt-coddiv   = t-comprobantes.coddiv
            tt-coddoc   = t-comprobantes.coddoc
            tt-nrodoc   = t-comprobantes.nrodoc
            tt-fchdoc   = IF(AVAILABLE b-ccdoc) THEN b-ccdoc.fchdoc ELSE ?
            tt-codcli   = IF(AVAILABLE b-ccdoc) THEN b-ccdoc.codcli ELSE ""
            tt-nomcli   = IF(AVAILABLE b-ccdoc) THEN b-ccdoc.nomcli ELSE ""
            tt-ruc      = IF(AVAILABLE b-ccdoc) THEN b-ccdoc.ruc ELSE ""
            tt-impte    = IF(AVAILABLE b-ccdoc) THEN b-ccdoc.imptot ELSE 0
            tt-tcmb     = IF(AVAILABLE b-ccdoc) THEN b-ccdoc.tpocmb ELSE 0
            tt-flgppll  = t-comprobantes.flagppll
            tt-ppll     = t-comprobantes.logestado
            tt-flgsunat = t-comprobantes.estadosunat
            tt-sunat    = t-comprobantes.flagestado
            tt-estado   = t-comprobantes.sestado.
    IF AVAILABLE b-ccdoc THEN DO:
        ASSIGN tt-mone  = IF b-ccdoc.codmon = 2 THEN "USD" ELSE "SOLES".
    END.
            
END.

RELEASE b-ccdoc.

SESSION:SET-WAIT-STATE('').

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = x-Archivo.

run pi-crea-archivo-csv IN hProc (input  buffer tt-excel:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-excel:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

