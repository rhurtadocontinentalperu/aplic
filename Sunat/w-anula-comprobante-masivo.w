&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE DETA LIKE CcbDDocu.
DEFINE TEMP-TABLE ttCcbCDocu NO-UNDO LIKE CcbCDocu.



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
DEF INPUT PARAMETER pParametro AS CHAR.

DEF NEW SHARED VAR s-permiso-anulacion AS LOG.

ASSIGN s-permiso-anulacion = LOGICAL(pParametro) NO-ERROR.
IF s-permiso-anulacion = ? THEN DO:
    MESSAGE 'El parámetro debe ser un YES o NO' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR S-USER-ID AS CHAR.

DEFINE NEW SHARED VARIABLE s-CodDiv   AS CHAR.
DEFINE NEW SHARED VARIABLE S-CODDOC   AS CHAR INITIAL "FAC".
DEFINE NEW SHARED VARIABLE S-TPOFAC   AS CHAR INITIAL "C,CR,A,F".     /* CONTADO, CREDITO Y ADELANTADAS */
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE NEW SHARED VARIABLE S-NROSER   AS INTEGER.
DEFINE NEW SHARED VARIABLE s-Sunat-Activo AS LOG INIT YES.

DEFINE VARIABLE L-NROSER   AS CHAR NO-UNDO.

DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.

RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

DEFINE VAR x-estado AS LOG INIT YES.

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
&Scoped-define INTERNAL-TABLES CcbCDocu

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 CcbCDocu.CodDoc CcbCDocu.NroDoc ~
CcbCDocu.FchDoc CcbCDocu.FlgEst CcbCDocu.CodCli CcbCDocu.NomCli 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH CcbCDocu ~
      WHERE ccbcdocu.codcia = s-codcia and ~
ccbcdocu.coddiv = s-coddiv and ~
ccbcdocu.coddoc = s-coddoc and ~
lookup(ccbcdocu.tpofac, s-tpofac) > 0 and ~
ccbcdocu.nrodoc begins string(s-nroser, entry(1,x-formato,"-")) and ~
((x-estado = yes and ccbcdocu.flgest = 'P') or (x-estado = no and ccbcdocu.flgest <> 'A')) NO-LOCK ~
    BY CcbCDocu.NroDoc DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH CcbCDocu ~
      WHERE ccbcdocu.codcia = s-codcia and ~
ccbcdocu.coddiv = s-coddiv and ~
ccbcdocu.coddoc = s-coddoc and ~
lookup(ccbcdocu.tpofac, s-tpofac) > 0 and ~
ccbcdocu.nrodoc begins string(s-nroser, entry(1,x-formato,"-")) and ~
((x-estado = yes and ccbcdocu.flgest = 'P') or (x-estado = no and ccbcdocu.flgest <> 'A')) NO-LOCK ~
    BY CcbCDocu.NroDoc DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 CcbCDocu


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-67 RECT-72 RECT-73 BROWSE-2 C-CodDoc ~
C-NroSer TOGGLE-pendientes COMBO-BOX-1 BUTTON-1 
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.ImpBrt CcbCDocu.ImpDto ~
CcbCDocu.PorIgv CcbCDocu.ImpTot CcbCDocu.ImpExo CcbCDocu.ImpVta ~
CcbCDocu.ImpIgv CcbCDocu.SdoAct 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS C-CodDoc C-NroSer TOGGLE-pendientes ~
COMBO-BOX-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-divi-comprobantes AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-factura-cred AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Eliminar documentos seleccionados" 
     SIZE 28 BY 1.12.

DEFINE VARIABLE C-CodDoc AS CHARACTER FORMAT "X(256)":U INITIAL "FAC" 
     LABEL "Comprobante" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "FAC","BOL","FAI","TCK" 
     DROP-DOWN-LIST
     SIZE 7.14 BY 1 NO-UNDO.

DEFINE VARIABLE C-NroSer AS CHARACTER FORMAT "X(3)":U INITIAL "0" 
     LABEL "Serie" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 6.72 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione un motivo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Seleccione un motivo" 
     DROP-DOWN-LIST
     SIZE 32.29 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-67
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 119 BY 7.81.

DEFINE RECTANGLE RECT-72
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 119 BY 2.15.

DEFINE RECTANGLE RECT-73
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53.86 BY 2.04.

DEFINE VARIABLE TOGGLE-pendientes AS LOGICAL INITIAL yes 
     LABEL "Solo pendientes" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      CcbCDocu.CodDoc FORMAT "x(3)":U
      CcbCDocu.NroDoc FORMAT "X(12)":U WIDTH 10.72
      CcbCDocu.FchDoc FORMAT "99/99/9999":U
      CcbCDocu.FlgEst FORMAT "X":U
      CcbCDocu.CodCli FORMAT "x(11)":U WIDTH 10.43
      CcbCDocu.NomCli FORMAT "x(50)":U WIDTH 49.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 99.57 BY 9.62
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-2 AT ROW 1.19 COL 55.43 WIDGET-ID 200
     C-CodDoc AT ROW 1.54 COL 2 WIDGET-ID 6
     C-NroSer AT ROW 1.58 COL 20.85 WIDGET-ID 8
     TOGGLE-pendientes AT ROW 1.58 COL 36 WIDGET-ID 58
     COMBO-BOX-1 AT ROW 15.42 COL 121 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     BUTTON-1 AT ROW 17.08 COL 125.57 WIDGET-ID 56
     CcbCDocu.ImpBrt AT ROW 19.12 COL 19 COLON-ALIGNED WIDGET-ID 40
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     CcbCDocu.ImpDto AT ROW 19.12 COL 46 COLON-ALIGNED WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     CcbCDocu.PorIgv AT ROW 19.12 COL 69 COLON-ALIGNED WIDGET-ID 52
          VIEW-AS FILL-IN 
          SIZE 6.43 BY .81
     CcbCDocu.ImpTot AT ROW 19.12 COL 94 COLON-ALIGNED WIDGET-ID 48
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     CcbCDocu.ImpExo AT ROW 19.92 COL 19 COLON-ALIGNED WIDGET-ID 44
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     CcbCDocu.ImpVta AT ROW 19.92 COL 46 COLON-ALIGNED WIDGET-ID 50
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     CcbCDocu.ImpIgv AT ROW 19.92 COL 69 COLON-ALIGNED WIDGET-ID 46
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     CcbCDocu.SdoAct AT ROW 19.92 COL 94 COLON-ALIGNED WIDGET-ID 54
          LABEL "Saldo Actual"
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     "tengan la misma fecha de emision" VIEW-AS TEXT
          SIZE 32.43 BY .96 AT ROW 12.15 COL 122.57 WIDGET-ID 64
          BGCOLOR 15 FGCOLOR 9 FONT 10
     "Motivo de la anulacion" VIEW-AS TEXT
          SIZE 22 BY .5 AT ROW 14.85 COL 123.29 WIDGET-ID 60
     "Seleccione comprobantes que" VIEW-AS TEXT
          SIZE 28.29 BY .96 AT ROW 11.15 COL 124.86 WIDGET-ID 62
          BGCOLOR 15 FGCOLOR 9 FONT 10
     RECT-67 AT ROW 11.04 COL 2 WIDGET-ID 18
     RECT-72 AT ROW 18.88 COL 2 WIDGET-ID 20
     RECT-73 AT ROW 8.96 COL 2.14 WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 155.43 BY 20.42
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: DETA T "NEW SHARED" ? INTEGRAL CcbDDocu
      TABLE: ttCcbCDocu T "?" NO-UNDO INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ANULACION DE COMPROBANTES VENTAS AL CREDITO"
         HEIGHT             = 20.42
         WIDTH              = 155.43
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 155.43
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 155.43
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
/* BROWSE-TAB BROWSE-2 RECT-73 F-Main */
/* SETTINGS FOR COMBO-BOX C-CodDoc IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX C-NroSer IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN CcbCDocu.ImpBrt IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.ImpDto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.ImpExo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.ImpIgv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.ImpVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.PorIgv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.SdoAct IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.CcbCDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "INTEGRAL.CcbCDocu.NroDoc|no"
     _Where[1]         = "ccbcdocu.codcia = s-codcia and
ccbcdocu.coddiv = s-coddiv and
ccbcdocu.coddoc = s-coddoc and
lookup(ccbcdocu.tpofac, s-tpofac) > 0 and
ccbcdocu.nrodoc begins string(s-nroser, entry(1,x-formato,""-"")) and
((x-estado = yes and ccbcdocu.flgest = 'P') or (x-estado = no and ccbcdocu.flgest <> 'A'))"
     _FldNameList[1]   = INTEGRAL.CcbCDocu.CodDoc
     _FldNameList[2]   > INTEGRAL.CcbCDocu.NroDoc
"CcbCDocu.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "10.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.CcbCDocu.FchDoc
     _FldNameList[4]   = INTEGRAL.CcbCDocu.FlgEst
     _FldNameList[5]   > INTEGRAL.CcbCDocu.CodCli
"CcbCDocu.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.CcbCDocu.NomCli
"CcbCDocu.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "49.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ANULACION DE COMPROBANTES VENTAS AL CREDITO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ANULACION DE COMPROBANTES VENTAS AL CREDITO */
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
ON VALUE-CHANGED OF BROWSE-2 IN FRAME F-Main
DO:

    RUN display-documento.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Eliminar documentos seleccionados */
DO:  

    IF BROWSE-2:NUM-SELECTED-ROWS <= 0 THEN DO:
        MESSAGE "Elija al menos un documento" VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.
    IF BROWSE-2:NUM-SELECTED-ROWS > 20 THEN DO:
        MESSAGE "Por favor el proceso es de 20 en 20" VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.

    DEFINE VAR x-fecha-emision AS DATE.
    DEFINE VAR x-fecha AS DATE.
    DEFINE VAR x-tot AS INT.
    DEFINE VAR x-sec AS INT.
    DEFINE VAR x-registros-ok AS LOG.

    x-fecha-emision = ?.

  DO WITH FRAME {&FRAME-NAME}:
    x-tot = BROWSE-2:NUM-SELECTED-ROWS.
    x-registros-ok = YES.
    DO x-sec = 1 TO x-tot :
        IF BROWSE-2:FETCH-SELECTED-ROW(x-sec) THEN DO:
            x-fecha = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.fchdoc.
            IF x-fecha-emision = ? THEN x-fecha-emision = x-fecha.
            IF x-fecha-emision <> x-fecha THEN DO:
                x-registros-ok = NO.
                LEAVE.
            END.
        END.
    END.
  END.

  IF x-registros-ok = NO THEN DO:
      MESSAGE "La fecha de emision de los documentos deben ser del mismo dia" 
          VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.

  ASSIGN
      COMBO-BOX-1.
  IF combo-box-1 BEGINS 'Seleccione' THEN DO:
      MESSAGE 'Debe seleccionar un motivo de anulación' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.

    MESSAGE 'Seguro de Anular los ' + STRING(BROWSE-2:NUM-SELECTED-ROWS) + ' documentos ?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.

    /* Realizamos el proceso de ANULACION */
    DEFINE VAR x-coddiv AS CHAR.
    DEFINE VAR x-coddoc AS CHAR.
    DEFINE VAR x-nrodoc AS CHAR.
    DEFINE VAR x-motivo-anulacion AS CHAR.
    DEFINE VAR x-msg-error AS CHAR NO-UNDO.
    DEFINE VAR x-error AS LOG.

    x-motivo-anulacion = SUBSTRING(combo-box-1, 1, INDEX(combo-box-1, " ") - 1 ).

    SESSION:SET-WAIT-STATE("GENERAL").
    x-error = NO.
    DO x-sec = 1 TO x-tot :
        IF BROWSE-2:FETCH-SELECTED-ROW(x-sec) THEN DO:

            x-coddiv = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.coddiv.
            x-coddoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.coddoc.
            x-nrodoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nrodoc.

            x-msg-error = "".

            RUN gn/p-anula-comprobante-sunat (INPUT Ccbcdocu.codcia,
                                              INPUT Ccbcdocu.coddoc,
                                              INPUT Ccbcdocu.nrodoc,
                                              INPUT s-User-Id,
                                              OUTPUT x-msg-error).

/*             RUN anular-registro-masivo IN h_v-factura-cred (INPUT x-coddiv, */
/*                                         INPUT x-coddoc,                     */
/*                                         INPUT x-nrodoc,                     */
/*                                         INPUT x-motivo-anulacion,           */
/*                                         OUTPUT x-msg-error                  */
/*                                         ).                                  */
            IF RETURN-VALUE =  "ADM-ERROR" THEN DO:
                MESSAGE x-msg-error VIEW-AS ALERT-BOX INFORMATION.
                x-error = YES.
            END.
        END.
    END.

    SESSION:SET-WAIT-STATE("").

    IF x-error = YES THEN DO:
        MESSAGE "Hubo inconvenientes en la anulacion" SKIP
                "Por favor revisar"
                VIEW-AS ALERT-BOX INFORMATION.

    END.
    ELSE DO:
        MESSAGE "Proceso OK" VIEW-AS ALERT-BOX INFORMATION.
    END.

    {&open-query-browse-2}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-CodDoc W-Win
ON VALUE-CHANGED OF C-CodDoc IN FRAME F-Main /* Comprobante */
DO:
   FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
       AND FacCorre.CodDoc = C-CODDOC:SCREEN-VALUE 
       AND FacCorre.CodDiv = S-CODDIV NO-LOCK NO-ERROR.
   IF NOT AVAILABLE FacCorre THEN DO:
       MESSAGE "Codigo de Documento no configurado" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
   END.
   ASSIGN 
       C-CODDOC toggle-pendientes.
   ASSIGN
       S-CODDOC = C-CODDOC.
   RUN Carga-Series.

   x-estado = toggle-pendientes.

   SESSION:SET-WAIT-STATE("GENERAL").                          
   {&OPEN-query-browse-2}
   SESSION:SET-WAIT-STATE("").


    RUN display-documento.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-NroSer W-Win
ON VALUE-CHANGED OF C-NroSer IN FRAME F-Main /* Serie */
DO:
  ASSIGN C-NroSer toggle-pendientes.
  S-NROSER = INTEGER(ENTRY(LOOKUP(C-NroSer,C-NroSer:LIST-ITEMS),C-NroSer:LIST-ITEMS)).
  /*RUN dispatch IN h_q-comprobantes-divi ('open-query':U).*/

  x-estado = toggle-pendientes.

  SESSION:SET-WAIT-STATE("GENERAL").                          
  {&OPEN-query-browse-2}
  SESSION:SET-WAIT-STATE("").  

    RUN display-documento.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-pendientes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-pendientes W-Win
ON VALUE-CHANGED OF TOGGLE-pendientes IN FRAME F-Main /* Solo pendientes */
DO:
    ASSIGN toggle-pendientes C-CODDOC C-NroSer.

    S-NROSER = INTEGER(ENTRY(LOOKUP(C-NroSer,C-NroSer:LIST-ITEMS),C-NroSer:LIST-ITEMS)).
    S-CODDOC = C-CODDOC.

    x-estado = toggle-pendientes.    

    SESSION:SET-WAIT-STATE("GENERAL").                          
    {&OPEN-query-browse-2}
    SESSION:SET-WAIT-STATE("").  

      RUN display-documento.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
  lh_Handle = THIS-PROCEDURE.

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
             INPUT  'aplic/sunat/b-divi-comprobantes.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-divi-comprobantes ).
       RUN set-position IN h_b-divi-comprobantes ( 2.92 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-divi-comprobantes ( 6.69 , 53.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/v-factura-cred.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-factura-cred ).
       RUN set-position IN h_v-factura-cred ( 11.31 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 7.35 , 117.00 ) */

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-divi-comprobantes ,
             TOGGLE-pendientes:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-factura-cred ,
             h_b-divi-comprobantes , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Series W-Win 
PROCEDURE Carga-Series :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  L-NROSER = "".
  FOR EACH FacCorre NO-LOCK WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.CodDiv = S-CODDIV
      AND FacCorre.FlgEst = YES:
      IF L-NROSER = "" THEN L-NROSER = STRING(FacCorre.NroSer,"999").
      ELSE L-NROSER = L-NROSER + "," + STRING(FacCorre.NroSer,"999").
  END.
  DO WITH FRAME {&FRAME-NAME}:
     C-NroSer:LIST-ITEMS = L-NROSER.
     S-NROSER = INTEGER(ENTRY(1,C-NroSer:LIST-ITEMS)).
     C-NROSER = ENTRY(1,C-NroSer:LIST-ITEMS).
     DISPLAY C-NROSER.
  END.
  
  /*RUN dispatch IN h_q-comprobantes-divi ('open-query':U).*/
  RUN dispatch IN h_v-factura-cred ('display-fields':U).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE display-documento W-Win 
PROCEDURE display-documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    IF AVAILABLE ccbcdocu THEN DO:
        RUN buscar-documento IN h_v-factura-cred (INPUT ccbcdocu.coddiv,
                                                INPUT ccbcdocu.coddoc,
                                                INPUT ccbcdocu.nrodoc
                                                ).
        DISPLAY ccbcdocu.impbrt WITH FRAME {&FRAME-NAME}.
        DISPLAY ccbcdocu.impdto WITH FRAME {&FRAME-NAME}.
        DISPLAY ccbcdocu.porigv WITH FRAME {&FRAME-NAME}.
        DISPLAY ccbcdocu.imptot WITH FRAME {&FRAME-NAME}.
        DISPLAY ccbcdocu.impexo WITH FRAME {&FRAME-NAME}.
        DISPLAY ccbcdocu.impvta WITH FRAME {&FRAME-NAME}.
        DISPLAY ccbcdocu.impigv WITH FRAME {&FRAME-NAME}.
        DISPLAY ccbcdocu.sdoact WITH FRAME {&FRAME-NAME}.

    END.
    ELSE DO:
        RUN buscar-documento IN h_v-factura-cred (INPUT "ZZZZZ",
                                             INPUT "ZXXX",
                                             INPUT "90800"
                                             ).
    END.


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
  DISPLAY C-CodDoc C-NroSer TOGGLE-pendientes COMBO-BOX-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  IF AVAILABLE CcbCDocu THEN 
    DISPLAY CcbCDocu.ImpBrt CcbCDocu.ImpDto CcbCDocu.PorIgv CcbCDocu.ImpTot 
          CcbCDocu.ImpExo CcbCDocu.ImpVta CcbCDocu.ImpIgv CcbCDocu.SdoAct 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-67 RECT-72 RECT-73 BROWSE-2 C-CodDoc C-NroSer TOGGLE-pendientes 
         COMBO-BOX-1 BUTTON-1 
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Captura-Division IN  h_b-divi-comprobantes (OUTPUT s-CodDiv).
  C-CodDoc = S-CODDOC.
  DISPLAY C-CodDoc WITH FRAME {&FRAME-NAME}.
  RUN Carga-Series.

  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH ccbtabla NO-LOCK WHERE ccbtabla.codcia = s-codcia
          AND ccbtabla.tabla = 'MA':
          COMBO-BOX-1:ADD-LAST(ccbtabla.codigo + ' ' + ccbtabla.nombre).
      END.
  END.

  /**/
  RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

  SESSION:SET-WAIT-STATE("GENERAL").                          
  {&OPEN-query-browse-2}
  SESSION:SET-WAIT-STATE("").

  RUN display-documento.
  

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

DEF INPUT PARAMETER pParam AS CHAR.

CASE pParam:
    WHEN "initialize" THEN DO:
        DO WITH FRAME {&FRAME-NAME}:
            RUN Captura-Division IN  h_b-divi-comprobantes (OUTPUT s-CodDiv).
            C-CodDoc = S-CODDOC.
            DISPLAY C-CodDoc WITH FRAME {&FRAME-NAME}.
            RUN Carga-Series.

        END.

        SESSION:SET-WAIT-STATE("GENERAL").                          
        {&OPEN-query-browse-2}
        SESSION:SET-WAIT-STATE("").

        RUN display-documento.

    END.

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

