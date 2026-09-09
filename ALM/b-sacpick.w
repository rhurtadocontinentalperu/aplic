&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
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

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR x-CodUbic AS CHAR INIT 'SMA' NO-UNDO.           /* Sacar mercaderia de almacén */
DEF VAR x-CodDoc AS CHAR INIT 'PED' NO-UNDO.
DEF VAR x-NomCli AS CHAR FORMAT 'x(40)' NO-UNDO.
DEF VAR x-NomPer AS CHAR FORMAT 'x(40)' NO-UNDO.
DEF VAR x-Estado AS CHAR FORMAT 'x(10)' NO-UNDO.

DEF VAR s-local-new-record AS CHAR INIT 'NO' NO-UNDO.   /* Add Multiple Record = NO */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES VtaTrack04 PL-PERS

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table VtaTrack04.FechaI VtaTrack04.FechaT ~
VtaTrack04.usuario VtaTrack04.CodDoc VtaTrack04.NroPed fNomCli() @ x-NomCli ~
VtaTrack04.codper fNomPer(PL-PERS.codper) @ x-NomPer ~
fEstado(VtaTrack04.Libre_c01) @ x-Estado 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table VtaTrack04.CodDoc ~
VtaTrack04.NroPed VtaTrack04.codper 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table VtaTrack04
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table VtaTrack04
&Scoped-define QUERY-STRING-br_table FOR EACH VtaTrack04 WHERE ~{&KEY-PHRASE} ~
      AND VtaTrack04.CodCia = s-codcia ~
 AND VtaTrack04.CodAlm = s-codalm ~
 AND STRING(VtaTrack04.FechaI, '99/99/9999') = STRING(fill-in-fecha, '99/99/9999') NO-LOCK, ~
      EACH PL-PERS OF VtaTrack04 NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH VtaTrack04 WHERE ~{&KEY-PHRASE} ~
      AND VtaTrack04.CodCia = s-codcia ~
 AND VtaTrack04.CodAlm = s-codalm ~
 AND STRING(VtaTrack04.FechaI, '99/99/9999') = STRING(fill-in-fecha, '99/99/9999') NO-LOCK, ~
      EACH PL-PERS OF VtaTrack04 NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table VtaTrack04 PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-br_table VtaTrack04
&Scoped-define SECOND-TABLE-IN-QUERY-br_table PL-PERS


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-Fecha br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Fecha 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT pFlgEst AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNomCli B-table-Win 
FUNCTION fNomCli RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNomPer B-table-Win 
FUNCTION fNomPer RETURNS CHARACTER
  ( INPUT pCodPer AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-br_table 
       MENU-ITEM m_Tarea_Terminada LABEL "Tarea Terminada".


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-Fecha AS DATE FORMAT "99/99/99":U 
     LABEL "Filtrar por" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      VtaTrack04, 
      PL-PERS SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      VtaTrack04.FechaI COLUMN-LABEL "Inicio" FORMAT "99/99/9999 HH:MM:SS":U
      VtaTrack04.FechaT COLUMN-LABEL "Término" FORMAT "99/99/9999 HH:MM:SS.SSS":U
      VtaTrack04.usuario COLUMN-LABEL "Usuario" FORMAT "x(10)":U
      VtaTrack04.CodDoc COLUMN-LABEL "Cod" FORMAT "x(8)":U VIEW-AS COMBO-BOX INNER-LINES 3
                      LIST-ITEMS "PED","O/D","P/M" 
                      DROP-DOWN-LIST 
      VtaTrack04.NroPed COLUMN-LABEL "Numero" FORMAT "xxxxxxxxx":U
            WIDTH 10
      fNomCli() @ x-NomCli COLUMN-LABEL "Cliente" FORMAT "x(45)":U
      VtaTrack04.codper COLUMN-LABEL "Sacador" FORMAT "X(6)":U
      fNomPer(PL-PERS.codper) @ x-NomPer COLUMN-LABEL "Nombre" FORMAT "x(45)":U
      fEstado(VtaTrack04.Libre_c01) @ x-Estado COLUMN-LABEL "Estado" FORMAT "x(15)":U
  ENABLE
      VtaTrack04.CodDoc HELP "Ingrese P/M (Pedido Mostrador) o PED (Pedido Crédito) u O/D (Orden de Despacho)"
      VtaTrack04.NroPed
      VtaTrack04.codper
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 146 BY 15.35
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Fecha AT ROW 1.27 COL 129 COLON-ALIGNED WIDGET-ID 2
     br_table AT ROW 2.35 COL 1
     "PULSAR BOTON DERECHO PARA CERRAR EL CICLO" VIEW-AS TEXT
          SIZE 50 BY .62 AT ROW 17.96 COL 4 WIDGET-ID 4
          BGCOLOR 7 FGCOLOR 15 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 17.73
         WIDTH              = 157.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table FILL-IN-Fecha F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-br_table:HANDLE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.VtaTrack04,INTEGRAL.PL-PERS OF INTEGRAL.VtaTrack04"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "VtaTrack04.CodCia = s-codcia
 AND VtaTrack04.CodAlm = s-codalm
 AND STRING(VtaTrack04.FechaI, '99/99/9999') = STRING(fill-in-fecha, '99/99/9999')"
     _FldNameList[1]   > INTEGRAL.VtaTrack04.FechaI
"VtaTrack04.FechaI" "Inicio" "99/99/9999 HH:MM:SS" "datetime" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.VtaTrack04.FechaT
"VtaTrack04.FechaT" "Término" ? "datetime" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.VtaTrack04.usuario
"VtaTrack04.usuario" "Usuario" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtaTrack04.CodDoc
"VtaTrack04.CodDoc" "Cod" "x(8)" "character" ? ? ? ? ? ? yes "Ingrese P/M (Pedido Mostrador) o PED (Pedido Crédito) u O/D (Orden de Despacho)" no no ? yes no no "U" "" "" "DROP-DOWN-LIST" "," "PED,O/D,P/M" ? 3 no 0 no no
     _FldNameList[5]   > INTEGRAL.VtaTrack04.NroPed
"VtaTrack04.NroPed" "Numero" "xxxxxxxxx" "character" ? ? ? ? ? ? yes ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fNomCli() @ x-NomCli" "Cliente" "x(45)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.VtaTrack04.codper
"VtaTrack04.codper" "Sacador" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"fNomPer(PL-PERS.codper) @ x-NomPer" "Nombre" "x(45)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"fEstado(VtaTrack04.Libre_c01) @ x-Estado" "Estado" "x(15)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
/*    IF VtaTrack04.CodDoc:SCREEN-VALUE IN BROWSE {&browse-name} = ''             */
/*       THEN VtaTrack04.CodDoc:SCREEN-VALUE IN BROWSE {&browse-name} = x-coddoc. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaTrack04.CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaTrack04.CodDoc br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF VtaTrack04.CodDoc IN BROWSE br_table /* Cod */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  IF s-local-new-record = 'NO' THEN RETURN.
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  IF LOOKUP(SELF:SCREEN-VALUE, 'PED,P/M,O/D') = 0 THEN DO:
      MESSAGE 'Debe ingresar P/M (pedido mostrador) o PED (pedido al crédito)' SKIP
          'u O/D (orden de despacho)'
          VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaTrack04.NroPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaTrack04.NroPed br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF VtaTrack04.NroPed IN BROWSE br_table /* Numero */
DO:
/*     FIND Faccpedi WHERE Faccpedi.codcia = s-codcia                                    */
/*         AND Faccpedi.coddoc = x-coddoc                                                */
/*         AND Faccpedi.nroped = VtaTrack04.NroPed:SCREEN-VALUE IN BROWSE {&browse-name} */
/*         AND Faccpedi.codalm = s-codalm                                                */
/*         NO-LOCK NO-ERROR.                                                             */
/*     IF AVAILABLE Faccpedi THEN DO:                                                    */
/*         DISPLAY                                                                       */
/*             FacCPedi.NomCli WITH BROWSE {&browse-name}.                               */
/*     END.                                                                              */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaTrack04.NroPed br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF VtaTrack04.NroPed IN BROWSE br_table /* Numero */
OR F8 OF VTaTRack04.NroPed
DO:
  CASE VtaTrack04.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}:
      WHEN 'PED' THEN DO:
          ASSIGN
              input-var-1 = s-codalm
              input-var-2 = 'PED'
              input-var-3 = 'C,P'.
          RUN lkup/c-pedpen-4 ('PEDIDOS PENDIENTES x ALMACEN').
          IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
      END.
      WHEN 'P/M' THEN DO:
          ASSIGN
              input-var-1 = s-codalm
              input-var-2 = 'P/M'
              input-var-3 = 'C'.
          RUN lkup/c-pedpen-4b ('PEDIDOS PENDIENTES x ALMACEN').
      END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaTrack04.codper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaTrack04.codper br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF VtaTrack04.codper IN BROWSE br_table /* Sacador */
OR f8 OF Vtatrack04.codper
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?.
    RUN pln/c-plnper.
    IF output-var-1 <> ? 
    THEN ASSIGN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Fecha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Fecha B-table-Win
ON LEAVE OF FILL-IN-Fecha IN FRAME F-Main /* Filtrar por */
DO:
  IF fill-in-Fecha <> INPUT {&self-name} THEN DO:
      ASSIGN {&self-name}.
      RUN dispatch IN THIS-PROCEDURE ('open-query').
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Tarea_Terminada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Tarea_Terminada B-table-Win
ON CHOOSE OF MENU-ITEM m_Tarea_Terminada /* Tarea Terminada */
DO:
  IF NOT AVAILABLE Vtatrack04 THEN RETURN.
  IF AVAILABLE Vtatrack04 AND VtaTrack04.Libre_c01 = 'C' THEN RETURN.

  MESSAGE 'Ya terminó de sacar la mercadería?'
      VIEW-AS ALERT-BOX QUESTION 
      BUTTONS YES-NO
      UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN.

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND CURRENT Vtatrack04 EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Vtatrack04 THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN
          VtaTrack04.Libre_c01 = 'C'
          VtaTrack04.Libre_c02 = s-user-id
          VtaTrack04.FechaT = DATETIME(TODAY, MTIME).
/*       CASE VtaTrack04.CodDoc:                                              */
/*           WHEN 'P/M' THEN DO:                                              */
/*               FIND Faccpedm WHERE Faccpedm.codcia = s-codcia               */
/*                   AND Faccpedm.coddoc = Vtatrack04.coddoc                  */
/*                   AND Faccpedm.nroped = Vtatrack04.nroped                  */
/*                   NO-LOCK.                                                 */
/*               RUN gn/pTracking-01 (s-CodCia,                               */
/*                                 s-CodDiv,                                  */
/*                                 Faccpedm.CodDoc,                           */
/*                                 Faccpedm.NroPed,                           */
/*                                 s-User-Id,                                 */
/*                                 'TSM',                                     */
/*                                 'P',                                       */
/*                                 DATETIME(TODAY, MTIME),                    */
/*                                 DATETIME(TODAY, MTIME),                    */
/*                                 Faccpedm.CodDoc,                           */
/*                                 Faccpedm.NroPed,                           */
/*                                 Faccpedm.CodDoc,                           */
/*                                 Faccpedm.NroPed).                          */
/*               IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
/*           END.                                                             */
/*           WHEN 'PED' THEN DO:                                              */
/*               FIND Faccpedi WHERE Faccpedi.codcia = s-codcia               */
/*                   AND Faccpedi.coddoc = Vtatrack04.coddoc                  */
/*                   AND Faccpedi.nroped = Vtatrack04.nroped                  */
/*                   NO-LOCK.                                                 */
/*               RUN gn/pTracking-01 (s-CodCia,                               */
/*                                 s-CodDiv,                                  */
/*                                 Faccpedi.CodDoc,                           */
/*                                 Faccpedi.NroPed,                           */
/*                                 s-User-Id,                                 */
/*                                 'TSM',                                     */
/*                                 'P',                                       */
/*                                 DATETIME(TODAY, MTIME),                    */
/*                                 DATETIME(TODAY, MTIME),                    */
/*                                 Faccpedi.CodDoc,                           */
/*                                 Faccpedi.NroPed,                           */
/*                                 Faccpedi.CodDoc,                           */
/*                                 Faccpedi.NroPed).                          */
/*               IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
/*           END.                                                             */
/*           WHEN 'O/D' THEN DO:                                              */
/*               FIND Faccpedi WHERE Faccpedi.codcia = s-codcia               */
/*                   AND Faccpedi.coddoc = Vtatrack04.coddoc                  */
/*                   AND Faccpedi.nroped = Vtatrack04.nroped                  */
/*                   NO-LOCK.                                                 */
/*               RUN gn/pTracking-01 (s-CodCia,                               */
/*                                 s-CodDiv,                                  */
/*                                 'PED',                                     */
/*                                 Faccpedi.NroRef,                           */
/*                                 s-User-Id,                                 */
/*                                 'TSM',                                     */
/*                                 'P',                                       */
/*                                 DATETIME(TODAY, MTIME),                    */
/*                                 DATETIME(TODAY, MTIME),                    */
/*                                 Faccpedi.CodDoc,                           */
/*                                 Faccpedi.NroPed,                           */
/*                                 Faccpedi.CodDoc,                           */
/*                                 Faccpedi.NroPed).                          */
/*               IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
/*           END.                                                             */
/*       END CASE.                                                            */
      FIND CURRENT Vtatrack04 NO-LOCK NO-ERROR.
      RUN dispatch IN THIS-PROCEDURE ('display-fields').
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF


ON 'RETURN':U OF VtaTrack04.CodDoc, VtaTrack04.NroPed
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FILL-IN-Fecha:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  s-local-new-record = 'YES'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       Solo se puede crear registro, no modificar
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      VtaTrack04.CodAlm = s-codalm
      VtaTrack04.CodCia = s-codcia
      VtaTrack04.CodDiv = s-coddiv
      VtaTrack04.CodUbic = x-codubic
      VtaTrack04.FechaI = DATETIME(TODAY, MTIME)
      VtaTrack04.usuario = s-user-id.
/*   CASE VtaTrack04.CodDoc:                                                      */
/*       WHEN 'P/M' THEN DO:                                                      */
/*           RUN gn/pTracking-01 (s-CodCia,                                       */
/*                             s-CodDiv,                                          */
/*                             Faccpedm.CodDoc,                                   */
/*                             Faccpedm.NroPed,                                   */
/*                             s-User-Id,                                         */
/*                             x-CodUbic,                                         */
/*                             'P',                                               */
/*                             DATETIME(TODAY, MTIME),                            */
/*                             DATETIME(TODAY, MTIME),                            */
/*                             Faccpedm.CodDoc,                                   */
/*                             Faccpedm.NroPed,                                   */
/*                             Faccpedm.CodDoc,                                   */
/*                             Faccpedm.NroPed).                                  */
/*           IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.         */
/*       END.                                                                     */
/*       WHEN 'PED' THEN DO:                                                      */
/*           IF LOOKUP(Faccpedi.coddiv, '00000,00015') > 0 THEN DO:               */
/*               RUN gn/pTracking-01 (s-CodCia,                                   */
/*                                 s-CodDiv,                                      */
/*                                 Faccpedi.CodDoc,                               */
/*                                 Faccpedi.NroPed,                               */
/*                                 s-User-Id,                                     */
/*                                 x-CodUbic,                                     */
/*                                 'P',                                           */
/*                                 DATETIME(TODAY, MTIME),                        */
/*                                 DATETIME(TODAY, MTIME),                        */
/*                                 Faccpedi.CodDoc,                               */
/*                                 Faccpedi.NroPed,                               */
/*                                 Faccpedi.CodDoc,                               */
/*                                 Faccpedi.NroPed).                              */
/*               IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.     */
/*           END.                                                                 */
/*           ELSE DO:                                                             */
/*               FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia       */
/*                   AND LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL') > 0                   */
/*                   AND Ccbcdocu.codcli = Faccpedi.codcli                        */
/*                   AND Ccbcdocu.flgest <> 'A'                                   */
/*                   AND Ccbcdocu.codalm = s-codalm                               */
/*                   AND Ccbcdocu.codped = Faccpedi.coddoc                        */
/*                   AND Ccbcdocu.nroped = Faccpedi.nroped:                       */
/*                   RUN gn/pTracking-01 (s-CodCia,                               */
/*                                     s-CodDiv,                                  */
/*                                     Faccpedi.CodDoc,                           */
/*                                     Faccpedi.NroPed,                           */
/*                                     s-User-Id,                                 */
/*                                     x-CodUbic,                                 */
/*                                     'P',                                       */
/*                                     DATETIME(TODAY, MTIME),                    */
/*                                     DATETIME(TODAY, MTIME),                    */
/*                                     Faccpedi.CodDoc,                           */
/*                                     Faccpedi.NroPed,                           */
/*                                     Ccbcdocu.CodDoc,                           */
/*                                     Ccbcdocu.NroDoc).                          */
/*                   IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
/*               END.                                                             */
/*           END.                                                                 */
/*       END.                                                                     */
/*       WHEN 'O/D' THEN DO:                                                      */
/*           RUN gn/pTracking-01 (s-CodCia,                                       */
/*                             s-CodDiv,                                          */
/*                             'PED',                                             */
/*                             Faccpedi.NroRef,                                   */
/*                             s-User-Id,                                         */
/*                             x-CodUbic,                                         */
/*                             'P',                                               */
/*                             DATETIME(TODAY, MTIME),                            */
/*                             DATETIME(TODAY, MTIME),                            */
/*                             Faccpedi.CodDoc,                                   */
/*                             Faccpedi.NroPed,                                   */
/*                             Faccpedi.CodDoc,                                   */
/*                             Faccpedi.NroPed).                                  */
/*           IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.         */
/*       END.                                                                     */
/*   END CASE.                                                                    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record B-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  s-local-new-record = 'NO'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FILL-IN-Fecha:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

IF VtaTrack04.Libre_c01 = 'C' THEN DO:
    MESSAGE 'Ya se cerró el ciclo' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

  /* Code placed here will execute PRIOR to standard behavior. */
/*   DEF VAR x-Rowid AS ROWID NO-UNDO.                                                    */
/*   DEF VAR x-CodDoc LIKE Vtatrack04.coddoc NO-UNDO.                                     */
/*   DEF VAR x-NroPed LIKE vtatrack04.nroped NO-UNDO.                                     */
/*   DEF VAR x-ActualizaTracking AS LOG NO-UNDO.                                          */
/*                                                                                        */
/*   ASSIGN                                                                               */
/*       x-Rowid = ROWID(VtaTrack04)                                                      */
/*       x-CodDoc = Vtatrack04.coddoc                                                     */
/*       x-NroPed = Vtatrack04.nroped.                                                    */
/*   IF NOT CAN-FIND(FIRST VtaTrack04 WHERE VtaTrack04.CodCia = s-codcia                  */
/*                   AND VtaTrack04.CodDiv = s-coddiv                                     */
/*                   AND VtaTrack04.CodUbic = x-codubic                                   */
/*                   AND VtaTrack04.CodDoc = x-coddoc                                     */
/*                   AND VtaTrack04.NroPed = x-nroped                                     */
/*                   AND ROWID(VtaTrack04) <> x-Rowid NO-LOCK)                            */
/*   THEN x-ActualizaTracking = YES.                                                      */
/*   ELSE x-ActualizaTracking = NO.                                                       */
/*   IF x-ActualizaTracking = YES THEN DO:                                                */
/*       IF VtaTrack04.Libre_c01 = 'C' THEN DO:                                           */
/*           CASE VtaTrack04.CodDoc:                                                      */
/*               WHEN 'PED' THEN DO:                                                      */
/*                   FIND Faccpedi WHERE Faccpedi.codcia = s-codcia                       */
/*                       AND Faccpedi.coddoc = Vtatrack04.coddoc                          */
/*                       AND FAccpedi.nroped = Vtatrack04.nroped NO-LOCK.                 */
/*                   IF AVAILABLE Faccpedi THEN DO:                                       */
/*                       RUN gn/pTracking-01 (s-CodCia,                                   */
/*                                         s-CodDiv,                                      */
/*                                         Faccpedi.CodDoc,                               */
/*                                         Faccpedi.NroPed,                               */
/*                                         s-User-Id,                                     */
/*                                         'TSM',                                         */
/*                                         'A',                                           */
/*                                         ?,                                             */
/*                                         DATETIME(TODAY, MTIME),                        */
/*                                         Faccpedi.CodDoc,                               */
/*                                         Faccpedi.NroPed,                               */
/*                                         Faccpedi.CodDoc,                               */
/*                                         Faccpedi.NroPed).                              */
/*                       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.     */
/*                   END.                                                                 */
/*               END.                                                                     */
/*               WHEN 'O/D' THEN DO:                                                      */
/*                   FIND Faccpedi WHERE Faccpedi.codcia = s-codcia                       */
/*                       AND Faccpedi.coddoc = Vtatrack04.coddoc                          */
/*                       AND Faccpedi.nroped = Vtatrack04.nroped NO-LOCK.                 */
/*                   IF AVAILABLE Faccpedi THEN DO:                                       */
/*                       RUN gn/pTracking-01 (s-CodCia,                                   */
/*                                         s-CodDiv,                                      */
/*                                         'PED',                                         */
/*                                         Faccpedi.NroRef,                               */
/*                                         s-User-Id,                                     */
/*                                         'TSM',                                         */
/*                                         'A',                                           */
/*                                         ?,                                             */
/*                                         DATETIME(TODAY, MTIME),                        */
/*                                         Faccpedi.CodDoc,                               */
/*                                         Faccpedi.NroPed,                               */
/*                                         Faccpedi.CodDoc,                               */
/*                                         Faccpedi.NroPed).                              */
/*                       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.     */
/*                   END.                                                                 */
/*               END.                                                                     */
/*               WHEN 'P/M' THEN DO:                                                      */
/*                   FIND Faccpedm WHERE Faccpedm.codcia = s-codcia                       */
/*                       AND Faccpedm.coddoc = Vtatrack04.coddoc                          */
/*                       AND FAccpedm.nroped = Vtatrack04.nroped NO-LOCK NO-ERROR.        */
/*                   IF AVAILABLE Faccpedm THEN DO:                                       */
/*                       RUN gn/pTracking-01 (s-CodCia,                                   */
/*                                         s-CodDiv,                                      */
/*                                         Faccpedm.CodDoc,                               */
/*                                         Faccpedm.NroPed,                               */
/*                                         s-User-Id,                                     */
/*                                         'TSM',                                         */
/*                                         'A',                                           */
/*                                         ?,                                             */
/*                                         DATETIME(TODAY, MTIME),                        */
/*                                         Faccpedm.CodDoc,                               */
/*                                         Faccpedm.NroPed,                               */
/*                                         Faccpedm.CodDoc,                               */
/*                                         Faccpedm.NroPed).                              */
/*                       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.     */
/*                   END.                                                                 */
/*               END.                                                                     */
/*           END CASE.                                                                    */
/*       END.                                                                             */
/*       CASE VtaTrack04.CodDoc:                                                          */
/*           WHEN 'PED' THEN DO:                                                          */
/*               FIND Faccpedi WHERE Faccpedi.codcia = s-codcia                           */
/*                       AND Faccpedi.coddoc = Vtatrack04.coddoc                          */
/*                       AND FAccpedi.nroped = Vtatrack04.nroped NO-LOCK.                 */
/*               IF AVAILABLE Faccpedi THEN DO:                                           */
/*                   IF LOOKUP(Faccpedi.coddiv, '00000,00015') > 0 THEN DO:               */
/*                       RUN gn/pTracking-01 (s-CodCia,                                   */
/*                                         s-CodDiv,                                      */
/*                                         Faccpedi.CodDoc,                               */
/*                                         Faccpedi.NroPed,                               */
/*                                         s-User-Id,                                     */
/*                                         x-CodUbic,                                     */
/*                                         'A',                                           */
/*                                         ?,                                             */
/*                                         DATETIME(TODAY, MTIME),                        */
/*                                         Faccpedi.CodDoc,                               */
/*                                         Faccpedi.NroPed,                               */
/*                                         Faccpedi.CodDoc,                               */
/*                                         Faccpedi.NroPed).                              */
/*                       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.     */
/*                   END.                                                                 */
/*                   ELSE DO:                                                             */
/*                       FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia       */
/*                           AND LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL') > 0                   */
/*                           AND Ccbcdocu.codcli = Faccpedi.codcli                        */
/*                           AND Ccbcdocu.flgest <> 'A'                                   */
/*                           AND Ccbcdocu.codalm = s-codalm                               */
/*                           AND Ccbcdocu.codped = Faccpedi.coddoc                        */
/*                           AND Ccbcdocu.nroped = Faccpedi.nroped:                       */
/*                           RUN gn/pTracking-01 (s-CodCia,                               */
/*                                             s-CodDiv,                                  */
/*                                             Faccpedi.CodDoc,                           */
/*                                             Faccpedi.NroPed,                           */
/*                                             s-User-Id,                                 */
/*                                             x-CodUbic,                                 */
/*                                             'A',                                       */
/*                                             ?,                                         */
/*                                             DATETIME(TODAY, MTIME),                    */
/*                                             Faccpedi.CodDoc,                           */
/*                                             Faccpedi.NroPed,                           */
/*                                             Ccbcdocu.CodDoc,                           */
/*                                             Ccbcdocu.NroDoc).                          */
/*                           IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
/*                       END.                                                             */
/*                   END.                                                                 */
/*                                                                                        */
/*               END.                                                                     */
/*           END.                                                                         */
/*           WHEN 'O/D' THEN DO:                                                          */
/*               FIND Faccpedi WHERE Faccpedi.codcia = s-codcia                           */
/*                       AND Faccpedi.coddoc = Vtatrack04.coddoc                          */
/*                       AND FAccpedi.nroped = Vtatrack04.nroped NO-LOCK.                 */
/*               IF AVAILABLE Faccpedi THEN DO:                                           */
/*                   RUN gn/pTracking-01 (s-CodCia,                                       */
/*                                     s-CodDiv,                                          */
/*                                     'PED',                                             */
/*                                     Faccpedi.NroRef,                                   */
/*                                     s-User-Id,                                         */
/*                                     x-CodUbic,                                         */
/*                                     'A',                                               */
/*                                     ?,                                                 */
/*                                     DATETIME(TODAY, MTIME),                            */
/*                                     Faccpedi.CodDoc,                                   */
/*                                     Faccpedi.NroPed,                                   */
/*                                     Faccpedi.CodDoc,                                   */
/*                                     Faccpedi.NroPed).                                  */
/*                   IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.         */
/*               END.                                                                     */
/*           END.                                                                         */
/*           WHEN 'P/M' THEN DO:                                                          */
/*               FIND Faccpedm WHERE Faccpedm.codcia = s-codcia                           */
/*                       AND Faccpedm.coddoc = Vtatrack04.coddoc                          */
/*                       AND FAccpedm.nroped = Vtatrack04.nroped NO-LOCK NO-ERROR.        */
/*               IF AVAILABLE Faccpedm THEN DO:                                           */
/*                   RUN gn/pTracking-01 (s-CodCia,                                       */
/*                                     s-CodDiv,                                          */
/*                                     Faccpedm.CodDoc,                                   */
/*                                     Faccpedm.NroPed,                                   */
/*                                     s-User-Id,                                         */
/*                                     x-CodUbic,                                         */
/*                                     'A',                                               */
/*                                     ?,                                                 */
/*                                     DATETIME(TODAY, MTIME),                            */
/*                                     Faccpedm.CodDoc,                                   */
/*                                     Faccpedm.NroPed,                                   */
/*                                     Faccpedm.CodDoc,                                   */
/*                                     Faccpedm.NroPed).                                  */
/*                   IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.         */
/*               END.                                                                     */
/*           END.                                                                         */
/*       END CASE.                                                                        */
/*   END.                                                                                 */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FILL-IN-Fecha = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FILL-in-Fecha = TODAY.
  FILL-IN-Fecha:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
  DISPLAY FILL-in-Fecha WITH FRAME {&FRAME-NAME}.
  s-local-new-record = 'NO'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
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
        WHEN "" THEN.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
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
        WHEN "" THEN .
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "VtaTrack04"}
  {src/adm/template/snd-list.i "PL-PERS"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF LOOKUP(VtaTrack04.CodDoc:SCREEN-VALUE IN BROWSE {&Browse-name}, 'PED,P/M,O/D') = 0 THEN DO:
      MESSAGE 'Debe ingresar P/M (pedido mostrador) o PED (pedido al crédito)' SKIP
          'u O/D (orden de despacho)'
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO VtaTrack04.CodDoc IN BROWSE {&browse-name}.
      RETURN 'ADM-ERROR'.
  END.
  x-coddoc = VtaTrack04.CodDoc:SCREEN-VALUE IN BROWSE {&Browse-name}.
  CASE x-coddoc:
      WHEN 'P/M' THEN DO:
          {alm/i-sacpick.i &Tabla=Faccpedm}.
      END.
      WHEN 'PED' OR WHEN 'O/D' THEN DO:
          {alm/i-sacpick.i &Tabla=Faccpedi}.
      END.
  END CASE.
  FIND pl-pers WHERE pl-pers.codcia = s-codcia
      AND pl-pers.codper = VtaTrack04.codper:SCREEN-VALUE IN BROWSE {&BROWSE-name}
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE pl-pers OR VtaTrack04.codper:SCREEN-VALUE IN BROWSE {&browse-name} = '' 
      THEN DO:
      MESSAGE 'Código del personal no registrado'
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO VtaTrack04.codper IN BROWSE {&browse-name}.
      RETURN 'ADM-ERROR'.
  END.
  IF CAN-FIND(FIRST Vtatrack04 WHERE VtaTrack04.CodAlm = s-codalm
              AND VtaTrack04.CodCia = s-codcia
            AND VtaTrack04.CodDoc = x-coddoc
            AND VtaTrack04.NroPed = VtaTrack04.NroPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
            AND VtaTrack04.CodUbic = x-codubic
            NO-LOCK) THEN DO:
      MESSAGE 'Ya registró este pedido' SKIP
          'Continuamos?'
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
          UPDATE rpta AS LOG.
      IF rpta = NO THEN DO:
          APPLY 'ENTRY':U TO VtaTrack04.NroPed IN BROWSE {&browse-name}.
          RETURN 'ADM-ERROR'.
      END.
  END.


RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT pFlgEst AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

CASE pFlgEst:
    WHEN 'C' THEN RETURN 'CERRADO'.
    OTHERWISE RETURN 'PENDIENTE'.
END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNomCli B-table-Win 
FUNCTION fNomCli RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE VtaTrack04.coddoc:
      WHEN 'P/M' THEN DO:
          FIND Faccpedm WHERE Faccpedm.codcia = s-codcia
              AND Faccpedm.coddoc = VtaTrack04.coddoc
              AND Faccpedm.nroped = VtaTrack04.NroPed
              NO-LOCK NO-ERROR.
          IF AVAILABLE Faccpedm THEN RETURN Faccpedm.nomcli.
      END.
      WHEN 'PED' THEN DO:
          FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
              AND Faccpedi.coddoc = VtaTrack04.coddoc
              AND Faccpedi.nroped = VtaTrack04.NroPed
              NO-LOCK NO-ERROR.
          IF AVAILABLE Faccpedi THEN RETURN Faccpedi.nomcli.
      END.
  END.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNomPer B-table-Win 
FUNCTION fNomPer RETURNS CHARACTER
  ( INPUT pCodPer AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR pNomPer AS CHAR NO-UNDO.
RUN gn/nombre-personal (s-codcia, pCodPer, OUTPUT pNomPer).
RETURN pNomPer.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

