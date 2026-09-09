&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER buf-ccbcdocu FOR CcbCDocu.
DEFINE TEMP-TABLE tCcbCDocu NO-UNDO LIKE CcbCDocu.



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
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-coddoc AS CHAR INIT 'BD' NO-UNDO.
DEF VAR s-flgest AS CHAR INIT "E" NO-UNDO.
DEF VAR x-Moneda AS CHAR NO-UNDO.
DEF VAR x-CndPgo AS CHAR NO-UNDO.

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
&Scoped-define INTERNAL-TABLES tCcbCDocu CcbCDocu GN-DIVI gn-ConVt

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tCcbCDocu.FchAte tCcbCDocu.NroDoc ~
tCcbCDocu.CodCli tCcbCDocu.NomCli tCcbCDocu.NroRef ~
IF tCcbCDocu.CodMon = 1 THEN 'S/.' ELSE 'US$' @ x-moneda tCcbCDocu.ImpTot ~
tCcbCDocu.CodCta ~
IF tCcbCDocu.TpoFac = 'EFE' THEN 'Efectivo' ELSE 'Cheque' @ x-CndPgo ~
gn-ConVt.Codig gn-ConVt.Nombr tCcbCDocu.FchDoc tCcbCDocu.CodDiv ~
GN-DIVI.DesDiv tCcbCDocu.usuario 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tCcbCDocu NO-LOCK, ~
      FIRST CcbCDocu OF tCcbCDocu NO-LOCK, ~
      FIRST GN-DIVI OF tCcbCDocu NO-LOCK, ~
      FIRST gn-ConVt WHERE gn-ConVt.Codig = tCcbCDocu.FmaPgo NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tCcbCDocu NO-LOCK, ~
      FIRST CcbCDocu OF tCcbCDocu NO-LOCK, ~
      FIRST GN-DIVI OF tCcbCDocu NO-LOCK, ~
      FIRST gn-ConVt WHERE gn-ConVt.Codig = tCcbCDocu.FmaPgo NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tCcbCDocu CcbCDocu GN-DIVI gn-ConVt
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tCcbCDocu
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 CcbCDocu
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-2 GN-DIVI
&Scoped-define FOURTH-TABLE-IN-QUERY-BROWSE-2 gn-ConVt


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON_Anular BUTTON_Rechazar ~
BUTTON_Divisiones x-FchAte-1 x-FchAte-2 BUTTON_Aplicar_Filtro BROWSE-2 ~
BUTTON_Autorizar 
&Scoped-Define DISPLAYED-OBJECTS x-FchAte-1 x-FchAte-2 EDITOR_Divisiones 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON_Anular 
     LABEL "ANULAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON_Aplicar_Filtro 
     LABEL "APLICAR FILTRO" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON_Autorizar 
     LABEL "AUTORIZAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON_Divisiones 
     IMAGE-UP FILE "img/pvmirar.ico":U
     LABEL "Button 12" 
     SIZE 4 BY 1.08.

DEFINE BUTTON BUTTON_Rechazar 
     LABEL "RECHAZAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE EDITOR_Divisiones AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 46 BY 2.42 NO-UNDO.

DEFINE VARIABLE x-FchAte-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Depositados desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchAte-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tCcbCDocu
    FIELDS(tCcbCDocu.FchAte
      tCcbCDocu.NroDoc
      tCcbCDocu.CodCli
      tCcbCDocu.NomCli
      tCcbCDocu.NroRef
      tCcbCDocu.CodMon
      tCcbCDocu.ImpTot
      tCcbCDocu.CodCta
      tCcbCDocu.TpoFac
      tCcbCDocu.FchDoc
      tCcbCDocu.CodDiv
      tCcbCDocu.usuario), 
      CcbCDocu, 
      GN-DIVI
    FIELDS(GN-DIVI.DesDiv), 
      gn-ConVt
    FIELDS(gn-ConVt.Codig
      gn-ConVt.Nombr) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tCcbCDocu.FchAte COLUMN-LABEL "Fecha de!Depósito" FORMAT "99/99/9999":U
      tCcbCDocu.NroDoc COLUMN-LABEL "Numero!de Control" FORMAT "X(15)":U
            WIDTH 8.72
      tCcbCDocu.CodCli FORMAT "x(11)":U WIDTH 10.43
      tCcbCDocu.NomCli FORMAT "x(80)":U WIDTH 33.43
      tCcbCDocu.NroRef COLUMN-LABEL "Número!Depósito" FORMAT "X(15)":U
      IF tCcbCDocu.CodMon = 1 THEN 'S/.' ELSE 'US$' @ x-moneda COLUMN-LABEL "Mon"
            WIDTH 3.86
      tCcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U WIDTH 10.43
      tCcbCDocu.CodCta FORMAT "X(10)":U WIDTH 8.43
      IF tCcbCDocu.TpoFac = 'EFE' THEN 'Efectivo' ELSE 'Cheque' @ x-CndPgo COLUMN-LABEL "Condición!de Pago"
            WIDTH 7.43
      gn-ConVt.Codig COLUMN-LABEL "Condición!de Venta" FORMAT "X(3)":U
      gn-ConVt.Nombr FORMAT "X(50)":U WIDTH 24.29
      tCcbCDocu.FchDoc COLUMN-LABEL "Fecha!Registro" FORMAT "99/99/9999":U
      tCcbCDocu.CodDiv COLUMN-LABEL "División" FORMAT "x(8)":U
      GN-DIVI.DesDiv COLUMN-LABEL "Nombre de la división" FORMAT "X(40)":U
            WIDTH 21
      tCcbCDocu.usuario COLUMN-LABEL "Usuario" FORMAT "x(12)":U
            WIDTH 2.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 189 BY 20.46
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON_Anular AT ROW 4.5 COL 121 WIDGET-ID 32
     BUTTON_Rechazar AT ROW 3.15 COL 121 WIDGET-ID 30
     BUTTON_Divisiones AT ROW 1.81 COL 53 WIDGET-ID 10
     x-FchAte-1 AT ROW 4.77 COL 18 COLON-ALIGNED WIDGET-ID 12
     x-FchAte-2 AT ROW 4.77 COL 36.72 COLON-ALIGNED WIDGET-ID 14
     BUTTON_Aplicar_Filtro AT ROW 1.81 COL 71 WIDGET-ID 18
     EDITOR_Divisiones AT ROW 1.81 COL 6 NO-LABEL WIDGET-ID 2
     BROWSE-2 AT ROW 6.38 COL 2 WIDGET-ID 200
     BUTTON_Autorizar AT ROW 1.81 COL 121 WIDGET-ID 20
     "Seleccione las Divisiones:" VIEW-AS TEXT
          SIZE 18 BY .5 AT ROW 1.27 COL 6 WIDGET-ID 4
          BGCOLOR 9 FGCOLOR 15 
     "(1)" VIEW-AS TEXT
          SIZE 5 BY 1.35 AT ROW 1.54 COL 58 WIDGET-ID 22
          FONT 8
     "(3)" VIEW-AS TEXT
          SIZE 5 BY 1.35 AT ROW 1.54 COL 87 WIDGET-ID 24
          FONT 8
     "(4a)" VIEW-AS TEXT
          SIZE 6 BY 1.35 AT ROW 1.54 COL 137 WIDGET-ID 26
          FONT 8
     "(2)" VIEW-AS TEXT
          SIZE 5 BY 1.35 AT ROW 4.5 COL 52 WIDGET-ID 28
          FONT 8
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
      TABLE: buf-ccbcdocu B "?" ? INTEGRAL CcbCDocu
      TABLE: tCcbCDocu T "?" NO-UNDO INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "AUTORIZAR / RECHAZAR DE BOLETAS DE DEPOSITO"
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-2 EDITOR_Divisiones F-Main */
/* SETTINGS FOR EDITOR EDITOR_Divisiones IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tCcbCDocu,INTEGRAL.CcbCDocu OF Temp-Tables.tCcbCDocu,INTEGRAL.GN-DIVI OF Temp-Tables.tCcbCDocu,INTEGRAL.gn-ConVt WHERE Temp-Tables.tCcbCDocu ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = "USED, FIRST, FIRST USED, FIRST USED"
     _JoinCode[4]      = "INTEGRAL.gn-ConVt.Codig = Temp-Tables.tCcbCDocu.FmaPgo"
     _FldNameList[1]   > Temp-Tables.tCcbCDocu.FchAte
"tCcbCDocu.FchAte" "Fecha de!Depósito" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tCcbCDocu.NroDoc
"tCcbCDocu.NroDoc" "Numero!de Control" "X(15)" "character" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tCcbCDocu.CodCli
"tCcbCDocu.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tCcbCDocu.NomCli
"tCcbCDocu.NomCli" ? "x(80)" "character" ? ? ? ? ? ? no ? no no "33.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tCcbCDocu.NroRef
"tCcbCDocu.NroRef" "Número!Depósito" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"IF tCcbCDocu.CodMon = 1 THEN 'S/.' ELSE 'US$' @ x-moneda" "Mon" ? ? ? ? ? ? ? ? no ? no no "3.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tCcbCDocu.ImpTot
"tCcbCDocu.ImpTot" ? ? "decimal" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tCcbCDocu.CodCta
"tCcbCDocu.CodCta" ? ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"IF tCcbCDocu.TpoFac = 'EFE' THEN 'Efectivo' ELSE 'Cheque' @ x-CndPgo" "Condición!de Pago" ? ? ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.gn-ConVt.Codig
"gn-ConVt.Codig" "Condición!de Venta" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.gn-ConVt.Nombr
"gn-ConVt.Nombr" ? ? "character" ? ? ? ? ? ? no ? no no "24.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tCcbCDocu.FchDoc
"tCcbCDocu.FchDoc" "Fecha!Registro" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.tCcbCDocu.CodDiv
"tCcbCDocu.CodDiv" "División" "x(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > INTEGRAL.GN-DIVI.DesDiv
"GN-DIVI.DesDiv" "Nombre de la división" ? "character" ? ? ? ? ? ? no ? no no "21" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.tCcbCDocu.usuario
"tCcbCDocu.usuario" "Usuario" "x(12)" "character" ? ? ? ? ? ? no ? no no "2.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* AUTORIZAR / RECHAZAR DE BOLETAS DE DEPOSITO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* AUTORIZAR / RECHAZAR DE BOLETAS DE DEPOSITO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Anular
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Anular W-Win
ON CHOOSE OF BUTTON_Anular IN FRAME F-Main /* ANULAR */
DO:
  RUN Anular.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Aplicar_Filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Aplicar_Filtro W-Win
ON CHOOSE OF BUTTON_Aplicar_Filtro IN FRAME F-Main /* APLICAR FILTRO */
DO:
  ASSIGN  x-FchAte-1 x-FchAte-2 EDITOR_Divisiones.
  RUN Aplicar-Filtros.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  MESSAGE "Carga terminada" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Autorizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Autorizar W-Win
ON CHOOSE OF BUTTON_Autorizar IN FRAME F-Main /* AUTORIZAR */
DO:
  DEF VAR pError AS CHAR NO-UNDO.

  RUN Autorizar (OUTPUT pError).
  IF pError > '' THEN MESSAGE pError VIEW-AS ALERT-BOX WARNING.
  APPLY 'CHOOSE':U TO BUTTON_Aplicar_Filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Divisiones
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Divisiones W-Win
ON CHOOSE OF BUTTON_Divisiones IN FRAME F-Main /* Button 12 */
DO:
  DEF VAR pcDivisiones AS CHAR NO-UNDO.
  RUN gn/d-selecciona-divisiones (OUTPUT pcDivisiones).
  IF pcDivisiones > '' THEN EDITOR_Divisiones:SCREEN-VALUE = pcDivisiones.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Rechazar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Rechazar W-Win
ON CHOOSE OF BUTTON_Rechazar IN FRAME F-Main /* RECHAZAR */
DO:
  RUN Rechazar.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anular W-Win 
PROCEDURE Anular :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT AVAILABLE Ccbcdocu OR LOOKUP(Ccbcdocu.FlgEst, "E,P") = 0 THEN RETURN.

    DEFINE VARIABLE i AS INTEGER NO-UNDO.
    DEF VAR pMensaje AS CHAR NO-UNDO.
  
    MESSAGE '¿Continua con la ANULACION de los depósitos?'
        VIEW-AS ALERT-BOX QUESTION BUTTONS
        YES-NO UPDATE rpta AS LOGICAL.
    IF rpta = NO THEN RETURN.
    RLOOP:
    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN DO:
            FIND buf-Ccbcdocu WHERE ROWID(buf-Ccbcdocu) = ROWID(Ccbcdocu)
                EXCLUSIVE-LOCK NO-ERROR.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                {lib/mensaje-de-error.i &MensajeError="pMensaje"}
                MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
                LEAVE RLOOP.
            END.
            IF AVAILABLE buf-Ccbcdocu AND
                (buf-Ccbcdocu.FlgEst = "E" OR buf-Ccbcdocu.FlgEst = "P") AND
                buf-Ccbcdocu.imptot = buf-Ccbcdocu.sdoact THEN DO:
                ASSIGN 
                    buf-Ccbcdocu.UsuAnu = s-user-id
                    buf-Ccbcdocu.FchAnu = TODAY
                    buf-Ccbcdocu.FlgEst = "A"
                    buf-Ccbcdocu.SdoAct = 0.
            END.
            ELSE DO:
                MESSAGE 'La Boleta de Depósito ha sido aplicada o' SKIP
                    'No se encuentra ni AUTORIZADA ni POR APROBAR' SKIP
                    VIEW-AS ALERT-BOX ERROR.
                LEAVE RLOOP.
            END.
            RELEASE buf-Ccbcdocu.
        END.
    END.
    {&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aplicar-Filtros W-Win 
PROCEDURE Aplicar-Filtros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tCcbcdocu.

FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia AND
    Ccbcdocu.flgest = s-flgest AND
    Ccbcdocu.coddoc = s-coddoc:
    IF INDEX(EDITOR_Divisiones, Ccbcdocu.coddiv) = 0 THEN NEXT.
    IF NOT (Ccbcdocu.fchate >= x-FchAte-1 AND Ccbcdocu.fchate <= x-FchAte-2) THEN NEXT.
    CREATE tCcbcdocu.
    BUFFER-COPY Ccbcdocu TO tCcbcdocu.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Autorizar W-Win 
PROCEDURE Autorizar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

    IF NOT AVAILABLE Ccbcdocu OR Ccbcdocu.FlgEst <> "E" THEN RETURN.

    DEFINE VARIABLE i AS INTEGER NO-UNDO.
    DEFINE VARIABLE rpta2 AS LOG INIT NO NO-UNDO.

    MESSAGE '¿Continua con la AUTORIZACION de los depósitos?'
        VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOGICAL.
    IF rpta = NO THEN RETURN 'OK'.

    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN DO:
            rpta2 = NO.
            FIND gn-convt WHERE gn-ConVt.Codig = Ccbcdocu.fmapgo NO-LOCK NO-ERROR NO-WAIT.
            IF AVAILABLE gn-convt AND gn-convt.Libre_L03 = YES THEN DO:
                /* Solicita generar la factura por anticipo de campaña */
                MESSAGE 'Generamos la FACTURA POR ANTICIPO?'
                    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
                    UPDATE rpta2.
                IF rpta2 = ? THEN RETURN 'OK'.
            END.
            RUN Graba-Autorizacion (INPUT rpta2, OUTPUT pError).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                IF TRUE <> (pError > '') THEN pError = "NO se pudo completar la autorización".
                RETURN 'ADM-ERROR'.
            END.
        END.
    END.
    RETURN 'OK'.

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
  DISPLAY x-FchAte-1 x-FchAte-2 EDITOR_Divisiones 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON_Anular BUTTON_Rechazar BUTTON_Divisiones x-FchAte-1 x-FchAte-2 
         BUTTON_Aplicar_Filtro BROWSE-2 BUTTON_Autorizar 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Autorizacion W-Win 
PROCEDURE Graba-Autorizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pFacAnticipo AS LOG NO-UNDO.
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="buf-Ccbcdocu" ~
        &Condicion="ROWID(buf-Ccbcdocu) = ROWID(Ccbcdocu)" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR NO-WAIT" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pError" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        }
    IF buf-Ccbcdocu.FlgEst = "E" THEN DO:
/*         ASSIGN                                 */
/*             buf-Ccbcdocu.FlgSit = "Autorizada" */
/*             buf-Ccbcdocu.FlgUbi = s-user-id    */
/*             buf-Ccbcdocu.FchUbi = TODAY        */
/*             buf-Ccbcdocu.FlgEst = "P".         */
        /* Anticipo de campaña */
        IF pFacAnticipo = YES THEN DO:
            RUN sap/d-aprobacion-bd (BUFFER buf-Ccbcdocu, OUTPUT pError).
            IF pError > '' THEN UNDO, RETURN 'ADM-ERROR'.
            /* OJO: La BD cancela la factura por Anticipo */
        END.
        ASSIGN 
            buf-Ccbcdocu.FlgSit = "Autorizada"
            buf-Ccbcdocu.FlgUbi = s-user-id
            buf-Ccbcdocu.FchUbi = TODAY
            buf-Ccbcdocu.FlgEst = "P".
        IF pFacAnticipo = YES THEN DO:
            ASSIGN
                buf-Ccbcdocu.FlgEst = "C"
                buf-Ccbcdocu.SdoAct = 0.
        END.
    END.
    RELEASE buf-Ccbcdocu.
END.
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
  x-FchAte-1 = ADD-INTERVAL(TODAY,-1,'month').
  x-FchAte-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rechazar W-Win 
PROCEDURE Rechazar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT AVAILABLE Ccbcdocu OR Ccbcdocu.FlgEst <> "E" THEN RETURN.

    DEF BUFFER buf-ccbcdocu FOR Ccbcdocu.
    DEFINE VARIABLE i AS INTEGER NO-UNDO.

    MESSAGE
        '¿Continua con el RECHAZO de los depósitos?'
        VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOGICAL.
    IF rpta = NO THEN RETURN.
    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN DO:
            FIND buf-ccbcdocu WHERE ROWID(buf-Ccbcdocu) = ROWID(Ccbcdocu)
                EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE buf-Ccbcdocu AND buf-Ccbcdocu.FlgEst = "E" THEN DO:
                ASSIGN 
                    buf-Ccbcdocu.FlgSit = "Rechazada"
                    buf-Ccbcdocu.FlgUbi = s-user-id
                    buf-Ccbcdocu.FchUbi = TODAY
                    buf-Ccbcdocu.FlgEst = "R".
                RELEASE buf-Ccbcdocu.
            END.
        END.
    END.
    {&OPEN-QUERY-{&BROWSE-NAME}}

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
  {src/adm/template/snd-list.i "tCcbCDocu"}
  {src/adm/template/snd-list.i "CcbCDocu"}
  {src/adm/template/snd-list.i "GN-DIVI"}
  {src/adm/template/snd-list.i "gn-ConVt"}

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

