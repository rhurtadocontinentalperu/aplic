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

DEFINE SHARED VAR s-codcia AS INT.

/* Local Variable Definitions ---                                       */

DEFINE VAR x-divi-ori AS CHAR.

DEFINE VAR x-fecha-ini AS DATE.
DEFINE VAR x-fecha-fin AS DATE.
DEFINE VAR x-fecha-entrega-ini AS DATE.
DEFINE VAR x-fecha-entrega-fin AS DATE.
DEFINE VAR x-solo-pendientes AS LOG INIT YES.
DEFINE VAR x-tabla AS CHAR.
DEFINE VAR x-es-query AS LOG INIT YES.

DEFINE VAR x-col-fentrega AS DATE.
DEFINE VAR x-col-lugent AS CHAR.

x-divi-ori = '00101'.

x-fecha-ini = TODAY - 5.
x-fecha-fin = TODAY.
x-fecha-entrega-ini = TODAY - 5.
x-fecha-entrega-fin = TODAY + 5.
x-tabla = "COURIER-URBANO".

DEFINE TEMP-TABLE ttPacking
    FIELD   tcodsegui   AS  CHAR    FORMAT 'x(25)'   COLUMN-LABEL "Codigo Seguimiento"
    FIELD   tdocref     AS  CHAR    FORMAT 'x(25)'  COLUMN-LABEL "Doc. Referencia"
    FIELD   tcodadic    AS  CHAR    FORMAT 'x(25)'  COLUMN-LABEL "Codigo adicional"
    FIELD   tcontenido  AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Contenido"
    FIELD   tpeso       AS  DEC     FORMAT '->,>>>,>>9.9999'    COLUMN-LABEL "Peso"
    FIELD   tpiezas     AS  INT     FORMAT '>>>,>>9'    COLUMN-LABEL "Piezas"
    FIELD   tcodcli     AS  CHAR    FORMAT 'x(12)'  COLUMN-LABEL "Codigo cliente"
    FIELD   tnomcli     AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Nombre destinatario"
    FIELD   tempresa    AS  CHAR    FORMAT 'x(3)'   COLUMN-LABEL "Empresa/Centro de negocio"
    FIELD   tdireccion  AS  CHAR    FORMAT 'x(150)' COLUMN-LABEL "Direccion"
    FIELD   tdirrefe    AS  CHAR    FORMAT 'x(150)' COLUMN-LABEL "Referencia direccion"
    FIELD   tdistrito   AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Distrito"
    FIELD   tprovincia  AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Provincia"
    FIELD   tdepto      AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Departamento"
    FIELD   tubigeo     AS  CHAR    FORMAT 'x(10)'  COLUMN-LABEL "Ubigeo"
    FIELD   ttelefono   AS  CHAR    FORMAT 'x(15)'  COLUMN-LABEL "Telefono"
    .

DEFINE BUFFER x-faccpedi FOR faccpedi.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-20

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCDocu FacCPedi

/* Definitions for BROWSE BROWSE-20                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-20 CcbCDocu.CodDoc CcbCDocu.NroDoc ~
CcbCDocu.FchDoc ~
get-fentrega(CcbCDocu.codped, ccbcdocu.nroped) @ x-col-fentrega ~
CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.Libre_c01 CcbCDocu.Libre_c02 ~
CcbCDocu.ImpTot ~
lugar-entrega(CcbCDocu.codped, ccbcdocu.nroped) @ x-col-lugent ~
CcbCDocu.CodPed CcbCDocu.NroPed 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-20 
&Scoped-define QUERY-STRING-BROWSE-20 FOR EACH CcbCDocu ~
      WHERE ccbcdocu.codcia = s-codcia and ~
ccbcdocu.divori = x-divi-ori and ~
(ccbcdocu.fchdoc >= x-fecha-ini and ccbcdocu.fchdoc <= x-fecha-fin) and ~
CAN-DO("FAC,BOL",ccbcdocu.coddoc) and ~
ccbcdocu.flgest <> "A" NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = ccbcdocu.codcia and ~
faccpedi.coddoc = ccbcdocu.codped and ~
faccpedi.nroped = ccbcdocu.nroped and ~
(faccpedi.fchent >= x-fecha-entrega-ini and faccpedi.fchent <= x-fecha-entrega-fin) NO-LOCK ~
    BY FacCPedi.FchEnt INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-20 OPEN QUERY BROWSE-20 FOR EACH CcbCDocu ~
      WHERE ccbcdocu.codcia = s-codcia and ~
ccbcdocu.divori = x-divi-ori and ~
(ccbcdocu.fchdoc >= x-fecha-ini and ccbcdocu.fchdoc <= x-fecha-fin) and ~
CAN-DO("FAC,BOL",ccbcdocu.coddoc) and ~
ccbcdocu.flgest <> "A" NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = ccbcdocu.codcia and ~
faccpedi.coddoc = ccbcdocu.codped and ~
faccpedi.nroped = ccbcdocu.nroped and ~
(faccpedi.fchent >= x-fecha-entrega-ini and faccpedi.fchent <= x-fecha-entrega-fin) NO-LOCK ~
    BY FacCPedi.FchEnt INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-20 CcbCDocu FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-20 CcbCDocu
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-20 FacCPedi


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-20}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-divi-ori FILL-IN-desde FILL-IN-hasta ~
FILL-IN-entrega-desde FILL-IN-entrega-hasta TOGGLE-pendientes ~
BUTTON-refrescar BROWSE-20 BUTTON-generar 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-divi-ori FILL-IN-desde ~
FILL-IN-hasta FILL-IN-entrega-desde FILL-IN-entrega-hasta TOGGLE-pendientes ~
FILL-IN-nomdivi FILL-IN-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-fentrega W-Win 
FUNCTION get-fentrega RETURNS DATE
  ( INPUT pCodPed AS CHAR, INPUT pNroPed AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-nomdivi W-Win 
FUNCTION get-nomdivi RETURNS CHARACTER
  ( INPUT pCodDiv AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD lugar-entrega W-Win 
FUNCTION lugar-entrega RETURNS CHARACTER
  ( INPUT pCodPed AS CHAR, INPUT pNroPed AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-generar 
     LABEL "Generar Packing" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-refrescar 
     LABEL "Refrescar" 
     SIZE 13 BY 1.08.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(100)":U INITIAL "Use CTRL + Click para seleccionar los comprobantes que se van incluir en el PackingList" 
     VIEW-AS FILL-IN 
     SIZE 62 BY .81
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos Desde" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-divi-ori AS CHARACTER FORMAT "X(6)":U INITIAL "00001" 
     LABEL "Division de venta" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-entrega-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Cuyas fechas para entregar sean Desde" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .81
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-entrega-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .81
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-hr AS CHARACTER FORMAT "X(15)":U 
     LABEL "Nro de H/R" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-nomdivi AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 52 BY .81
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE TOGGLE-pendientes AS LOGICAL INITIAL yes 
     LABEL "Solo pendientes de enviar" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-20 FOR 
      CcbCDocu, 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-20
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-20 W-Win _STRUCTURED
  QUERY BROWSE-20 NO-LOCK DISPLAY
      CcbCDocu.CodDoc COLUMN-LABEL "Cod!Cmpte" FORMAT "x(3)":U
            WIDTH 5.43
      CcbCDocu.NroDoc COLUMN-LABEL "Numero!Cmpte" FORMAT "X(12)":U
            WIDTH 10.57
      CcbCDocu.FchDoc COLUMN-LABEL "Fecha!Emision" FORMAT "99/99/9999":U
      get-fentrega(CcbCDocu.codped, ccbcdocu.nroped) @ x-col-fentrega COLUMN-LABEL "Fecha!Entrega" FORMAT "99/99/9999":U
      CcbCDocu.CodCli FORMAT "x(11)":U WIDTH 13.43
      CcbCDocu.NomCli FORMAT "x(50)":U WIDTH 32
      CcbCDocu.Libre_c01 COLUMN-LABEL "Cod!Orden" FORMAT "x(5)":U
      CcbCDocu.Libre_c02 COLUMN-LABEL "Nro!Orden" FORMAT "x(11)":U
            WIDTH 9.14
      CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U WIDTH 9.86
      lugar-entrega(CcbCDocu.codped, ccbcdocu.nroped) @ x-col-lugent COLUMN-LABEL "Lugar de entrega" FORMAT "x(120)":U
            WIDTH 26.29
      CcbCDocu.CodPed FORMAT "x(10)":U
      CcbCDocu.NroPed FORMAT "X(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 136 BY 15.85
         FONT 4
         TITLE "Comprobantes".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-divi-ori AT ROW 1.19 COL 12.72 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-desde AT ROW 1.15 COL 31.14 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-hasta AT ROW 1.15 COL 48 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-entrega-desde AT ROW 2.12 COL 31.14 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-entrega-hasta AT ROW 2.12 COL 48 COLON-ALIGNED WIDGET-ID 18
     TOGGLE-pendientes AT ROW 2.35 COL 63 WIDGET-ID 20
     BUTTON-refrescar AT ROW 1.08 COL 63 WIDGET-ID 8
     FILL-IN-nomdivi AT ROW 1.19 COL 82.57 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-hr AT ROW 2.15 COL 95 COLON-ALIGNED WIDGET-ID 22
     BROWSE-20 AT ROW 3.54 COL 2 WIDGET-ID 200
     BUTTON-generar AT ROW 19.5 COL 119.57 WIDGET-ID 10
     FILL-IN-1 AT ROW 19.73 COL 13 COLON-ALIGNED NO-LABEL WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 139.57 BY 20.15
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "Packing List - Courier"
         HEIGHT             = 20.15
         WIDTH              = 139.57
         MAX-HEIGHT         = 27.23
         MAX-WIDTH          = 186.29
         VIRTUAL-HEIGHT     = 27.23
         VIRTUAL-WIDTH      = 186.29
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
/* BROWSE-TAB BROWSE-20 FILL-IN-hr F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-hr IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN-hr:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-nomdivi IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-20
/* Query rebuild information for BROWSE BROWSE-20
     _TblList          = "INTEGRAL.CcbCDocu,INTEGRAL.FacCPedi WHERE INTEGRAL.CcbCDocu ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST, FIRST"
     _OrdList          = "INTEGRAL.FacCPedi.FchEnt|yes"
     _Where[1]         = "ccbcdocu.codcia = s-codcia and
ccbcdocu.divori = x-divi-ori and
(ccbcdocu.fchdoc >= x-fecha-ini and ccbcdocu.fchdoc <= x-fecha-fin) and
CAN-DO(""FAC,BOL"",ccbcdocu.coddoc) and
ccbcdocu.flgest <> ""A"""
     _JoinCode[2]      = "FacCPedi.CodCia = ccbcdocu.codcia and
faccpedi.coddoc = ccbcdocu.codped and
faccpedi.nroped = ccbcdocu.nroped and
(faccpedi.fchent >= x-fecha-entrega-ini and faccpedi.fchent <= x-fecha-entrega-fin)"
     _FldNameList[1]   > INTEGRAL.CcbCDocu.CodDoc
"CcbCDocu.CodDoc" "Cod!Cmpte" ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.CcbCDocu.NroDoc
"CcbCDocu.NroDoc" "Numero!Cmpte" ? "character" ? ? ? ? ? ? no ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.CcbCDocu.FchDoc
"CcbCDocu.FchDoc" "Fecha!Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"get-fentrega(CcbCDocu.codped, ccbcdocu.nroped) @ x-col-fentrega" "Fecha!Entrega" "99/99/9999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CcbCDocu.CodCli
"CcbCDocu.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.CcbCDocu.NomCli
"CcbCDocu.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "32" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.CcbCDocu.Libre_c01
"CcbCDocu.Libre_c01" "Cod!Orden" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.CcbCDocu.Libre_c02
"CcbCDocu.Libre_c02" "Nro!Orden" "x(11)" "character" ? ? ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.CcbCDocu.ImpTot
"CcbCDocu.ImpTot" ? ? "decimal" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"lugar-entrega(CcbCDocu.codped, ccbcdocu.nroped) @ x-col-lugent" "Lugar de entrega" "x(120)" ? ? ? ? ? ? ? no ? no no "26.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   = INTEGRAL.CcbCDocu.CodPed
     _FldNameList[12]   = INTEGRAL.CcbCDocu.NroPed
     _Query            is OPENED
*/  /* BROWSE BROWSE-20 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Packing List - Courier */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Packing List - Courier */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-20
&Scoped-define SELF-NAME BROWSE-20
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-20 W-Win
ON VALUE-CHANGED OF BROWSE-20 IN FRAME F-Main /* Comprobantes */
DO:

    DEFINE VAR x-coddoc AS CHAR.
    DEFINE VAR x-nrodoc AS CHAR.


  IF AVAILABLE ccbcdocu THEN DO:
      x-coddoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.coddoc.
      x-nrodoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nrodoc.

      FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                  vtatabla.tabla = x-tabla AND
                                  vtatabla.llave_c1 = x-coddoc AND
                                  vtatabla.llave_c2 = x-nrodoc
                                  NO-LOCK NO-ERROR.
      IF AVAILABLE vtatabla THEN DO:
          MESSAGE 'Comprobante ' + x-coddoc + ' ' + x-nrodoc + ' ya fue enviado' SKIP
                  'Desea reenviarlo?' VIEW-AS ALERT-BOX QUESTION
                  BUTTONS YES-NO UPDATE rpta AS LOG.
          IF rpta = NO THEN DO:
            browse-20:DESELECT-FOCUSED-ROW().
            RETURN NO-APPLY.
          END.
               
          
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-generar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-generar W-Win
ON CHOOSE OF BUTTON-generar IN FRAME F-Main /* Generar Packing */
DO:
  RUN procesar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-refrescar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-refrescar W-Win
ON CHOOSE OF BUTTON-refrescar IN FRAME F-Main /* Refrescar */
DO:
  ASSIGN fill-in-divi-ori fill-in-desde fill-in-hasta fill-in-entrega-desde fill-in-entrega-hasta.
  ASSIGN toggle-pendientes.

  IF TRUE <> (fill-in-divi-ori > "") THEN DO:
      MESSAGE "Ingrese la division de venta" VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.
  IF fill-in-desde = ? OR fill-in-hasta = ? THEN DO:
      MESSAGE "Ingrese rango de fechas emision que sean correctas"
          VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.
  IF fill-in-desde > fill-in-hasta THEN DO:
      MESSAGE "Ingrese rango de fechas emision que sean correctas(*)"
          VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.

  IF fill-in-entrega-desde = ? OR fill-in-entrega-hasta = ? THEN DO:
      MESSAGE "Ingrese rango de fechas entregas que sean correctas"
          VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.
  IF fill-in-entrega-desde > fill-in-entrega-hasta THEN DO:
      MESSAGE "Ingrese rango de fechas emision que sean correctas(**)"
          VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.

  FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND
                            gn-divi.coddiv = fill-in-divi-ori NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-divi THEN DO:
      MESSAGE "Division de ventas no existe"
          VIEW-AS ALERT-BOX INFORMATION.
  END.

  x-divi-ori = fill-in-divi-ori.
  x-fecha-ini = fill-in-desde.
  x-fecha-fin = fill-in-hasta.
  x-fecha-entrega-ini = fill-in-entrega-desde.
  x-fecha-entrega-fin = fill-in-entrega-hasta.
  x-solo-pendientes = toggle-pendientes.

  SESSION:SET-WAIT-STATE("GENERAL").
  {&open-query-browse-20}
  SESSION:SET-WAIT-STATE("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-divi-ori
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-divi-ori W-Win
ON LEAVE OF FILL-IN-divi-ori IN FRAME F-Main /* Division de venta */
DO:
  FILL-in-nomdivi:SCREEN-VALUE IN FRAME {&FRAME-NAME} = get-nomdivi(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

ON FIND OF ccbcdocu DO:
        
    IF x-es-query = YES THEN DO:
        IF x-solo-pendientes = YES THEN DO:
            FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                        vtatabla.tabla = x-tabla AND
                                        vtatabla.llave_c1 = ccbcdocu.coddoc AND
                                        vtatabla.llave_c2 = ccbcdocu.nrodoc NO-LOCK NO-ERROR.
            IF AVAILABLE vtatabla THEN DO:
                RETURN ERROR.
            END.
        END.
    END.

    RETURN.
END.

DEF VAR celda_br AS WIDGET-HANDLE EXTENT 150 NO-UNDO.
 DEF VAR cual_celda AS WIDGET-HANDLE NO-UNDO.
 DEF VAR n_cols_browse AS INT NO-UNDO.
 DEF VAR col_act AS INT NO-UNDO.
 DEF VAR t_col_br AS INT NO-UNDO INITIAL 11.            /* Color del background de la celda ( 2 : Verde)*/
 DEF VAR vg_col_eti_b AS INT NO-UNDO INITIAL 28.        /* Color del la letra de la celda (15 : Blanco) */      

ON ROW-DISPLAY OF browse-20
DO:
    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                vtatabla.tabla = x-tabla AND
                                vtatabla.llave_c1 = ccbcdocu.coddoc AND
                                vtatabla.llave_c2 = ccbcdocu.nrodoc NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN DO:
        cual_celda = celda_br[2].
        /*
        cual_celda:BGCOLOR = 12.
        cual_celda:FGCOLOR = 15.
        */
    END.

    /*
  IF CURRENT-RESULT-ROW("browse-20") / 2 <> INT (CURRENT-RESULT-ROW("browse-1") / 2) THEN RETURN.
  o asi
  IF table.field <> 'XYZ' THEN return.

  DO col_act = 1 TO n_cols_browse.
      
     cual_celda = celda_br[col_act].
     cual_celda:BGCOLOR = t_col_br.
  END.
  */
END.

DO n_cols_browse = 1 TO browse-20:NUM-COLUMNS.
   celda_br[n_cols_browse] = browse-20:GET-BROWSE-COLUMN(n_cols_browse).
   cual_celda = celda_br[n_cols_browse].
     
   IF vg_col_eti_b <> 0 THEN cual_celda:LABEL-BGCOLOR = vg_col_eti_b.
   /*IF n_cols_browse = 15 THEN LEAVE.*/
END.

n_cols_browse = browse-20:NUM-COLUMNS.
/* IF n_cols_browse > 15 THEN n_cols_browse = 15. */

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
  DISPLAY FILL-IN-divi-ori FILL-IN-desde FILL-IN-hasta FILL-IN-entrega-desde 
          FILL-IN-entrega-hasta TOGGLE-pendientes FILL-IN-nomdivi FILL-IN-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-divi-ori FILL-IN-desde FILL-IN-hasta FILL-IN-entrega-desde 
         FILL-IN-entrega-hasta TOGGLE-pendientes BUTTON-refrescar BROWSE-20 
         BUTTON-generar 
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

  fill-in-divi-ori:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-divi-ori.
  fill-in-desde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-fecha-ini,"99/99/9999").
  fill-in-hasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-fecha-fin,"99/99/9999").
  fill-in-entrega-desde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-fecha-entrega-ini,"99/99/9999").
  fill-in-entrega-hasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-fecha-entrega-fin,"99/99/9999").

  FILL-in-nomdivi:SCREEN-VALUE IN FRAME {&FRAME-NAME} = get-nomdivi(fill-in-divi-ori:SCREEN-VALUE).

  RUN refrescar.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lugar-de-entrega W-Win 
PROCEDURE lugar-de-entrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodPed AS CHAR. /* PED,O/D, OTR */
DEFINE INPUT PARAMETER pNroPed AS CHAR.
DEFINE OUTPUT PARAMETER pLugEnt AS CHAR.
DEFINE OUTPUT PARAMETER pUbigeo AS CHAR.
DEFINE OUTPUT PARAMETER pRefer AS CHAR.

pLugEnt = lugar-entrega(pCodPed, pNroped).
pUbigeo = "||".
pRefer = "".

FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                    x-faccpedi.coddoc = pCodPed AND
                    x-faccpedi.nroped = pNroped NO-LOCK NO-ERROR.
IF AVAILABLE x-faccpedi THEN DO:
    FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND
        gn-clie.codcli = x-Faccpedi.codcli NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN DO:       
        FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.Sede = x-Faccpedi.Ubigeo[1]
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clied THEN DO:
            pRefer = TRIM(gn-clieD.referencias).
            pUbigeo = TRIM(gn-clied.coddept) + "|" + TRIM(gn-clied.codprov) + "|" + TRIM(gn-clied.coddist).
        END.            
    END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE peso-piezas W-Win 
PROCEDURE peso-piezas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodOrden AS CHAR.
DEFINE INPUT PARAMETER pNroOrden AS CHAR.
DEFINE OUTPUT PARAMETER pPeso AS DEC.
DEFINE OUTPUT PARAMETER pPiezas AS INT.

pPeso = 0.
pPiezas = 0.
FOR EACH ControlOD WHERE ControlOD.codcia = s-codcia AND
                        ControlOD.coddoc = pCodOrden AND
                        ControlOD.nrodoc = pNroOrden NO-LOCK:
    pPeso = pPeso + ControlOD.pesart.
    pPiezas = pPiezas + 1.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar W-Win 
PROCEDURE procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE ttPacking.

DEFINE VAR x-totregs AS INT.
DEFINE VAR x-cont AS INT.
DEFINE VAR x-peso AS DEC.
DEFINE VAR x-piezas AS INT.
DEFINE VAR x-codorden AS CHAR.
DEFINE VAR x-nroorden AS CHAR.
DEFINE VAR x-codcli AS CHAR.
DEFINE VAR x-lugent AS CHAR.
DEFINE VAR x-ubigeo AS CHAR.
DEFINE VAR x-refer AS CHAR.
DEFINE VAR x-dpto AS CHAR.
DEFINE VAR x-prov AS CHAR.
DEFINE VAR x-dist AS CHAR.
DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nrodoc AS CHAR.
DEFINE VAR x-total-regs AS INT.

DEFINE VAR x-duplicados AS INT.

SESSION:SET-WAIT-STATE("GENERAL").

DO WITH FRAME {&FRAME-NAME}:
    x-totregs = {&BROWSE-NAME}:NUM-SELECTED-ROWS.
    DO x-Cont = 1 TO x-totregs :        
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(x-cont) THEN DO:
            x-coddoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.coddoc.
            x-nrodoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nrodoc.

            FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                        vtatabla.tabla = x-tabla AND
                                        vtatabla.llave_c1 = x-coddoc AND
                                        vtatabla.llave_c2 = x-nrodoc
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE vtatabla THEN DO:
                x-duplicados = x-duplicados + 1.
            END.

            x-total-regs = x-total-regs + 1.

        END.
    END.
END.

SESSION:SET-WAIT-STATE("").

IF x-duplicados > 0 THEN DO:
        MESSAGE 'Hay ' + STRING(x-duplicados) + ' comprobante(s) que se esta enviando mas de una vez' SKIP
            'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN.

END.

MESSAGE 'Se van a enviar ' + STRING(x-total-regs) + ' comprobante(s) para el reparto' SKIP
    'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta2 AS LOG.
IF rpta2 = NO THEN RETURN.

/* ------------ */
DEFINE VAR lDirectorio AS CHAR.

lDirectorio = "".

SYSTEM-DIALOG GET-DIR lDirectorio  
   RETURN-TO-START-DIR 
   TITLE 'Directorio Files'.
IF lDirectorio = "" THEN DO :
    MESSAGE "Proceso cancelado" VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

SESSION:SET-WAIT-STATE("GENERAL").

DO WITH FRAME {&FRAME-NAME}:
    /*DO iCont = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:*/
    x-totregs = {&BROWSE-NAME}:NUM-SELECTED-ROWS.
    DO x-Cont = 1 TO x-totregs :
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(x-cont) THEN DO:

            x-peso = 0.
            x-piezas = 0.
            x-codorden = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.libre_c01.
            x-nroorden = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.libre_c02.
            x-codcli = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codcli.

            RUN peso-piezas(INPUT x-codorden, INPUT x-nroorden,
                            OUTPUT x-peso, OUTPUT x-piezas).

            /* Con datos del pedido */
            RUN lugar-de-entrega(INPUT {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codped,
                                 INPUT {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nroped,
                                 OUTPUT x-lugent, OUTPUT x-ubigeo, OUTPUT x-refer).

            x-dpto = ENTRY(1,x-ubigeo,"|").
            x-prov = ENTRY(2,x-ubigeo,"|").
            x-dist = ENTRY(3,x-ubigeo,"|").

            FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND
                                    gn-clie.codcli = x-codcli NO-LOCK NO-ERROR.
            FIND FIRST tabdistr WHERE tabdistr.coddepto = x-dpto AND
                                    tabdistr.codprov = x-prov AND
                                    tabdistr.coddistr = x-dist NO-LOCK NO-ERROR.
            FIND FIRST tabprov WHERE tabprov.coddepto = x-dpto AND
                                    tabprov.codprov = x-prov  NO-LOCK NO-ERROR.
            FIND FIRST tabdepto WHERE tabdepto.coddepto = x-dpto NO-LOCK NO-ERROR.

            x-coddoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.coddoc.
            x-nrodoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nrodoc.

            FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                        vtatabla.tabla = x-tabla AND
                                        vtatabla.llave_c1 = x-coddoc AND
                                        vtatabla.llave_c2 = x-nrodoc
                                        EXCLUSIVE-LOCK NO-ERROR.
            IF NOT LOCKED vtatabla THEN DO:
                IF NOT AVAILABLE vtatabla THEN DO:
                    CREATE vtatabla.
                    ASSIGN vtatabla.codcia = s-codcia 
                            vtatabla.tabla = x-tabla
                            vtatabla.llave_c1 = x-coddoc
                            vtatabla.llave_c2 = x-nrodoc.
                END.
                ASSIGN vtatabla.libre_c01 = USERID("DICTDB")
                    vtatabla.libre_c02 = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"HH:MM:SS").            

                RELEASE vtatabla NO-ERROR.

                CREATE ttPacking.
                    ASSIGN tcodsegui    = x-coddoc + "-" + x-nrodoc
                    tdocref     = x-coddoc + "-" + x-nrodoc
                    tcodadic    = ""
                    tcontenido  = "UTILES DE OFICINA"
                    tpeso       = x-peso
                    tpiezas     = x-piezas
                    tcodcli     = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codcli
                    tnomcli     = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nomcli
                    tempresa    = ""   /*IF (gn-clie.libre_c01 = 'J') THEN "SI" ELSE "NO"*/
                    tdireccion  = x-lugent
                    tdirrefe    = ""
                    tdistrito   = IF(AVAILABLE tabdistr) THEN tabdistr.nomdistr ELSE ""
                    tprovincia  = IF(AVAILABLE tabprov) THEN tabprov.nomprov ELSE ""
                    tdepto      = IF(AVAILABLE tabdepto) THEN tabdepto.nomdepto ELSE ""
                    tubigeo     = REPLACE(x-ubigeo,"|","")
                    ttelefono   = gn-clie.telfnos[1]
            .
            END.
        END.
    END.
END.

DEFINE VAR hProc AS HANDLE NO-UNDO.
DEFINE VAR x-tiempo AS CHAR.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

x-tiempo = STRING(TODAY,"99/99/9999") + "-" + STRING(TIME,"HH:MM:SS").
x-tiempo = REPLACE(x-tiempo,"/","").
x-tiempo = REPLACE(x-tiempo,":","").

c-xls-file = lDirectorio + "\courier-" + x-tiempo + ".xlsx".

run pi-crea-archivo-csv IN hProc (input  buffer ttPacking:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer ttPacking:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.

SESSION:SET-WAIT-STATE("").

/* Refrescar */
SESSION:SET-WAIT-STATE("GENERAL").
{&open-query-browse-20}
SESSION:SET-WAIT-STATE("").


MESSAGE "Se creo y grabo el archivo en " SKIP
        c-xls-file VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/*
DEFINE TEMP-TABLE ttPacking
    FIELD   tcodsegui   AS  CHAR    FORMAT 'x(25)'   COLUMN-LABEL "Codigo Segmento"
    FIELD   tdocref     AS  CHAR    FORMAT 'x(25)'  COLUMN-LABEL "Doc. Referencia"
    FIELD   tcodadic    AS  CHAR    FORMAT 'x(25)'  COLUMN-LABEL "Codigo adicional"
    FIELD   tcontenido  AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Contenido"
    FIELD   tpeso       AS  DEC     FORMAT '->,>>>,>>9.9999'    COLUMN-LABEL "Peso"
    FIELD   tpiezas     AS  INT     FORMAT '>>>,>>9'    COLUMN-LABEL "Piezas"
    FIELD   tcodcli     AS  CHAR    FORMAT 'x(12)'  COLUMN-LABEL "Codigo cliente"
    FIELD   tnomcli     AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Nombre destinatario"
    FIELD   tempresa    AS  CHAR    FORMAT 'x(3)'   COLUMN-LABEL "Empresa/Centro de negocio"
    FIELD   tdireccion  AS  CHAR    FORMAT 'x(150)' COLUMN-LABEL "Direccion"
    FIELD   tdirrefe    AS  CHAR    FORMAT 'x(150)' COLUMN-LABEL "Referencia direccion"
    FIELD   tdistrito   AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Distrito"
    FIELD   tprovincia  AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Provincia"
    FIELD   tdepto      AS  CHAR    FORMAT 'x(100)' COLUMN-LABEL "Departamento"
    FIELD   tubigeo     AS  CHAR    FORMAT 'x(10)'  COLUMN-LABEL "Ubigeo"
    FIELD   ttelefono   AS  CHAR    FORMAT 'x(15)'  COLUMN-LABEL "Telefono"
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refrescar W-Win 
PROCEDURE refrescar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  SESSION:SET-WAIT-STATE("GENERAL").
  {&open-query-browse-20}
  SESSION:SET-WAIT-STATE("").


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
  {src/adm/template/snd-list.i "FacCPedi"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-fentrega W-Win 
FUNCTION get-fentrega RETURNS DATE
  ( INPUT pCodPed AS CHAR, INPUT pNroPed AS CHAR ) :

    DEFINE VAR x-retval AS DATE INIT ?.

    FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                            x-faccpedi.coddoc = pCodPed AND
                            x-faccpedi.nroped = pNroped NO-LOCK NO-ERROR.

    IF AVAILABLE x-faccpedi THEN DO:
        x-retval = x-faccpedi.fchent.
    END.

  RETURN x-retval.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-nomdivi W-Win 
FUNCTION get-nomdivi RETURNS CHARACTER
  ( INPUT pCodDiv AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VAR x-retval AS CHAR.

  x-retval = "** Division no existe **".

  FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND
                        gn-divi.coddiv = pCodDiv NO-LOCK NO-ERROR.

  IF AVAILABLE gn-divi THEN x-retval = TRIM(gn-divi.desdiv).

  RETURN x-retval.    /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION lugar-entrega W-Win 
FUNCTION lugar-entrega RETURNS CHARACTER
  ( INPUT pCodPed AS CHAR, INPUT pNroPed AS CHAR ) :

    DEFINE VAR x-retval AS CHAR INIT "".

    FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                            x-faccpedi.coddoc = pCodPed AND
                            x-faccpedi.nroped = pNroped NO-LOCK NO-ERROR.

    IF AVAILABLE x-faccpedi THEN DO:
    
        FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND
            gn-clie.codcli = x-Faccpedi.codcli
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            x-retval = "".  /*gn-clie.dircli.*/
            FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.Sede = x-Faccpedi.Ubigeo[1]
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clied THEN x-retval = Gn-ClieD.DirCli.
        END.
    END.

  RETURN x-retval.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

