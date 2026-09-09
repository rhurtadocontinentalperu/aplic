&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-PikSacadores FOR PikSacadores.
DEFINE BUFFER B-Sacadores FOR PikSacadores.
DEFINE TEMP-TABLE T-PikSacadores NO-UNDO LIKE PikSacadores
       FIELD cRowid AS ROWID
       FIELD CodPed LIKE VtaCDocu.codped
       FIELD NroPed LIKE VtaCDocu.nroped
       FIELD FchInicio AS DATETIME
       FIELD FchFin    AS DATETIME
       FIELD Items     LIKE VtaCDocu.Items
       Field nomper    as char format 'x(80)'.



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
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR x-NomPer AS CHAR NO-UNDO.
DEF VAR x-CodPed LIKE PikTarea.codped NO-UNDO.
DEF VAR x-NroPed LIKE PikTarea.nroped NO-UNDO.
DEF VAR x-FchInicio LIKE PikTareas.FchInicio NO-UNDO.
DEF VAR x-FchFin    LIKE PikTareas.FchFin    NO-UNDO.
DEF VAR x-Items     LIKE Piktareas.Items     NO-UNDO.
DEF VAR x-Tiempo AS CHAR NO-UNDO.

DEF VAR pCodPed AS CHAR NO-UNDO.
DEF VAR pNroPed AS CHAR NO-UNDO.
DEF VAR pEstado AS CHAR NO-UNDO.
DEF VAR pError  AS CHAR NO-UNDO.

DEFINE VAR x-sort-direccion AS CHAR INIT "".
DEFINE VAR x-sort-column AS CHAR INIT "".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME T-PikSacadoreF-Main
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-PikSacadores PikSacadores

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 ~
(IF PikSacadores.FlgTarea = "L" THEN "LIBRE" ELSE "OCUPADO") @ T-PikSacadores.FlgTarea ~
PikSacadores.CodPer T-PikSacadores.nomper @ x-nomper PikSacadores.Sector ~
T-PikSacadores.CodPed @ x-CodPed T-PikSacadores.NroPed @ x-NroPed ~
T-PikSacadores.FchInicio @ x-FchInicio T-PikSacadores.FchFin @ x-FchFin ~
T-PikSacadores.Items @ x-Items fTiempo() @ x-Tiempo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH T-PikSacadores NO-LOCK, ~
      FIRST PikSacadores WHERE TRUE /* Join to T-PikSacadores incomplete */ ~
      AND ROWID(PikSacadores) = T-PikSacadores.cRowid NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH T-PikSacadores NO-LOCK, ~
      FIRST PikSacadores WHERE TRUE /* Join to T-PikSacadores incomplete */ ~
      AND ROWID(PikSacadores) = T-PikSacadores.cRowid NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 T-PikSacadores PikSacadores
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 T-PikSacadores
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-3 PikSacadores


/* Definitions for FRAME T-PikSacadoreF-Main                            */
&Scoped-define OPEN-BROWSERS-IN-QUERY-T-PikSacadoreF-Main ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-Refrescar BUTTON-Asignar ~
BUTTON-Reasignar BROWSE-3 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNomPer W-Win 
FUNCTION fNomPer RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSector W-Win 
FUNCTION fSector RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fTiempo W-Win 
FUNCTION fTiempo RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Asignar 
     LABEL "ASIGNAR TAREA" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Reasignar 
     LABEL "REASIGNAR TAREA" 
     SIZE 18 BY 1.12.

DEFINE BUTTON BUTTON-Refrescar 
     LABEL "REFRESCAR" 
     SIZE 15 BY 1.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      T-PikSacadores, 
      PikSacadores SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      (IF PikSacadores.FlgTarea = "L" THEN "LIBRE" ELSE "OCUPADO") @ T-PikSacadores.FlgTarea COLUMN-LABEL "Situación" FORMAT "x(10)":U
            WIDTH 9.43
      PikSacadores.CodPer FORMAT "X(10)":U
      T-PikSacadores.nomper @ x-nomper COLUMN-LABEL "Apellidos y Nombres" FORMAT "x(40)":U
      PikSacadores.Sector FORMAT "x(15)":U WIDTH 20.43
      T-PikSacadores.CodPed @ x-CodPed COLUMN-LABEL "Docum." FORMAT "x(3)":U
            WIDTH 5.43
      T-PikSacadores.NroPed @ x-NroPed COLUMN-LABEL "Número" FORMAT "x(15)":U
            WIDTH 11.43
      T-PikSacadores.FchInicio @ x-FchInicio COLUMN-LABEL "Inicio Tarea" FORMAT "99/99/9999 HH:MM:SS":U
            WIDTH 15.43
      T-PikSacadores.FchFin @ x-FchFin COLUMN-LABEL "Fin de Tarea" FORMAT "99/99/9999 HH:MM:SS":U
            WIDTH 15.43
      T-PikSacadores.Items @ x-Items COLUMN-LABEL "# Items" FORMAT ">>>,>>9":U
            WIDTH 5.86
      fTiempo() @ x-Tiempo COLUMN-LABEL "Tiempo trascurrido" FORMAT "x(20)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 141 BY 23.08
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME T-PikSacadoreF-Main
     BUTTON-Refrescar AT ROW 1.19 COL 2 WIDGET-ID 6
     BUTTON-Asignar AT ROW 1.19 COL 17 WIDGET-ID 4
     BUTTON-Reasignar AT ROW 1.19 COL 32 WIDGET-ID 14
     BROWSE-3 AT ROW 2.54 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 143.14 BY 25.12
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-PikSacadores B "?" ? INTEGRAL PikSacadores
      TABLE: B-Sacadores B "?" ? INTEGRAL PikSacadores
      TABLE: T-PikSacadores T "?" NO-UNDO INTEGRAL PikSacadores
      ADDITIONAL-FIELDS:
          FIELD cRowid AS ROWID
          FIELD CodPed LIKE VtaCDocu.codped
          FIELD NroPed LIKE VtaCDocu.nroped
          FIELD FchInicio AS DATETIME
          FIELD FchFin    AS DATETIME
          FIELD Items     LIKE VtaCDocu.Items
          Field nomper    as char format 'x(80)'
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ASIGNACION DE TAREAS A SACADORES"
         HEIGHT             = 25.12
         WIDTH              = 143.14
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 144.29
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 144.29
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
/* SETTINGS FOR FRAME T-PikSacadoreF-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-3 BUTTON-Reasignar T-PikSacadoreF-Main */
ASSIGN 
       BROWSE-3:ALLOW-COLUMN-SEARCHING IN FRAME T-PikSacadoreF-Main = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.T-PikSacadores,INTEGRAL.PikSacadores WHERE Temp-Tables.T-PikSacadores ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _Where[2]         = "ROWID(PikSacadores) = T-PikSacadores.cRowid"
     _FldNameList[1]   > "_<CALC>"
"(IF PikSacadores.FlgTarea = ""L"" THEN ""LIBRE"" ELSE ""OCUPADO"") @ T-PikSacadores.FlgTarea" "Situación" "x(10)" ? ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.PikSacadores.CodPer
     _FldNameList[3]   > "_<CALC>"
"T-PikSacadores.nomper @ x-nomper" "Apellidos y Nombres" "x(40)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.PikSacadores.Sector
"PikSacadores.Sector" ? "x(15)" "character" ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"T-PikSacadores.CodPed @ x-CodPed" "Docum." "x(3)" ? ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"T-PikSacadores.NroPed @ x-NroPed" "Número" "x(15)" ? ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"T-PikSacadores.FchInicio @ x-FchInicio" "Inicio Tarea" "99/99/9999 HH:MM:SS" ? ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"T-PikSacadores.FchFin @ x-FchFin" "Fin de Tarea" "99/99/9999 HH:MM:SS" ? ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"T-PikSacadores.Items @ x-Items" "# Items" ">>>,>>9" ? ? ? ? ? ? ? no ? no no "5.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"fTiempo() @ x-Tiempo" "Tiempo trascurrido" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ASIGNACION DE TAREAS A SACADORES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ASIGNACION DE TAREAS A SACADORES */
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
ON ROW-DISPLAY OF BROWSE-3 IN FRAME T-PikSacadoreF-Main
DO:
    CASE T-PikSacadores.FlgTarea:
        WHEN 'O' THEN DO:
            T-PikSacadores.FlgTarea:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
        END.
        WHEN 'L' THEN DO:
            T-PikSacadores.FlgTarea:BGCOLOR IN BROWSE {&BROWSE-NAME} = 2.
        END.
    END CASE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 W-Win
ON START-SEARCH OF BROWSE-3 IN FRAME T-PikSacadoreF-Main
DO:
    DEFINE VARIABLE hSortColumn AS WIDGET-HANDLE.
    DEFINE VAR lColumName AS CHAR.
    DEFINE VAR hQueryHandle AS HANDLE NO-UNDO.

    hSortColumn = BROWSE BROWSE-3:CURRENT-COLUMN.
    lColumName = hSortColumn:NAME.
    lColumName = TRIM(REPLACE(lColumName," no","")).    

    IF CAPS(lColumName)="X-CODPED"  THEN lColumName = "t-piksacadores.codped".
    IF CAPS(lColumName)="X-NROPED"  THEN lColumName = "t-piksacadores.nroped".
    IF CAPS(lColumName)="X-FCHINICIO"  THEN lColumName = "t-piksacadores.fchinicio".
    IF CAPS(lColumName)="X-FCHFIN"  THEN lColumName = "t-piksacadores.fchfin".
    IF CAPS(lColumName)="X-ITEMS"  THEN lColumName = "t-piksacadores.items".
    IF CAPS(lColumName)="X-NOMPER"  THEN lColumName = "t-piksacadores.nomper".
    IF CAPS(lColumName)="X-TIEMPO" THEN RETURN.

    IF CAPS(lColumName) <> CAPS(x-sort-column) THEN DO:
        x-sort-direccion = "".
    END.
    ELSE DO:
        IF x-sort-direccion = "" THEN DO:
            x-sort-direccion = "DESC".
        END.
        ELSE DO:            
            x-sort-direccion = "".
        END.
    END.
    x-sort-column = lColumName.

    hQueryHandle = BROWSE BROWSE-3:QUERY.
    hQueryHandle:QUERY-CLOSE().
    
    /*FOR EACH T-PikSacadores NO-LOCK, FIRST INTEGRAL.PikSacadores WHERE TRUE AND ROWID(PikSacadores) = T-PikSacadores.cRowid NO-LOCK INDEXED-REPOSITION:*/

    hQueryHandle:QUERY-PREPARE("FOR EACH T-PikSacadores NO-LOCK, FIRST INTEGRAL.PikSacadores WHERE TRUE AND ROWID(PikSacadores) = T-PikSacadores.cRowid NO-LOCK BY " + lColumName + " " + x-sort-direccion).
    hQueryHandle:QUERY-OPEN().
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Asignar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Asignar W-Win
ON CHOOSE OF BUTTON-Asignar IN FRAME T-PikSacadoreF-Main /* ASIGNAR TAREA */
DO:
  IF NOT AVAILABLE T-PikSacadores THEN RETURN.
  FIND FIRST B-PikSacadores WHERE ROWID(B-PikSacadores) = T-PikSacadores.cRowid
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-PikSacadores THEN DO:
      MESSAGE 'NO se pudo ubicar al sacador' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF B-PikSacadores.FlgTarea = "O" THEN DO:
      MESSAGE 'El Sacador está OCUPADO' VIEW-AS ALERT-BOX ERROR.
      APPLY 'CHOOSE':U TO BUTTON-Refrescar IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
  END.
  RUN alm/d-asigna-subordenes( B-PikSacadores.CodPer,
                               OUTPUT pCodPed,
                               OUTPUT pNroPed,
                               OUTPUT pEstado).
  IF pEstado = 'ADM-ERROR' THEN DO:
      APPLY 'CHOOSE':U TO BUTTON-Refrescar.
      RETURN NO-APPLY.
  END.
  pError = "".
  RUN Cierre-de-guia.
  APPLY 'CHOOSE':U TO BUTTON-Refrescar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Reasignar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Reasignar W-Win
ON CHOOSE OF BUTTON-Reasignar IN FRAME T-PikSacadoreF-Main /* REASIGNAR TAREA */
DO:
  IF NOT AVAILABLE T-PikSacadores THEN RETURN.
  FIND FIRST B-Sacadores WHERE ROWID(B-Sacadores) = T-PikSacadores.cRowid
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-Sacadores THEN DO:
      MESSAGE 'NO se pudo ubicar al sacador' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF B-Sacadores.FlgTarea <> "O" THEN DO:
      MESSAGE 'Debe seleccionar una persona OCUPADA' VIEW-AS ALERT-BOX ERROR.
      APPLY 'CHOOSE':U TO BUTTON-Refrescar IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
  END.
  /* Seleccionar una persona */
  ASSIGN
      input-var-1 = s-coddiv
      input-var-2 = "A"     /* Activo */
      input-var-3 = "L"    /* Libre */
      output-var-1 = ?.
  RUN lkup/c-sacadores ( 'SELECCIONE UN SACADOR LIBRE' ).
  IF output-var-1 = ? THEN DO:
      APPLY 'CHOOSE':U TO BUTTON-Refrescar IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
  END.
  pError = "".
  PRINCIPAL:
  DO ON ERROR UNDO, LEAVE PRINCIPAL ON STOP UNDO, LEAVE PRINCIPAL:
      /* Bloqueamos al sacador actual */
      FIND CURRENT B-Sacadores EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-Sacadores THEN DO:
          pError = 'NO se pudo bloquear el sacador actual'.
          UNDO, LEAVE PRINCIPAL.
      END.
      IF B-Sacadores.FlgTarea <> "O" THEN DO:
          pError = "El sacador " + B-Sacadores.CodPer  + " YA NO está OCUPADO".
          UNDO, LEAVE PRINCIPAL.
      END.
      /* Bloqueamos al sacador Destino */
      FIND B-PikSacadores WHERE ROWID(B-PikSacadores) = output-var-1 EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-PikSacadores THEN DO:
          pError =  'NO se pudo bloquear el sacador ' + output-var-2.
          UNDO, LEAVE PRINCIPAL.
      END.
      IF B-PikSacadores.FlgTarea <> "L" THEN DO:
          pError = 'El sacador ' + output-var-2 + ' YA NO está LIBRE'.
          UNDO, LEAVE PRINCIPAL.
      END.
      /* Verificamos que pertenesca al grupo del supervisor */
      IF NOT CAN-FIND(FIRST T-PikSacadores WHERE T-PikSacadores.codper = B-PikSacadores.codper
                      NO-LOCK) THEN DO:
          pError = 'El Sacador ' + B-PikSacadores.codper + ' NO pertenece a su grupo de trabajo'.
          UNDO, LEAVE PRINCIPAL.
      END.
      /* Buscamos la tarea activa */
      FIND VtaCDocu WHERE VtaCDocu.CodCia = B-Sacadores.codcia
          AND VtaCDocu.DivDes = B-Sacadores.CodDiv
          AND VtaCDocu.UsrSac = B-Sacadores.CodPer
          AND VtaCDocu.FlgEst = "P"
          AND VtaCDocu.FlgSit = "P"
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE VtaCDocu THEN DO:
          pError = 'NO se pudo bloquear la tarea a reasignar o la tarea ya fue reasignada'.
          UNDO, LEAVE PRINCIPAL.
      END.
      IF LOOKUP(ENTRY(2,VtaCDocu.NroPed,'-'),B-PikSacadores.Sector) = 0 THEN DO:
          pError = 'NO se puede asignar esta tarea al nuevo sacador porque' + CHR(10) +
              'NO está asignado al Sector ' + ENTRY(2,VtaCDocu.NroPed,'-').
          UNDO, LEAVE PRINCIPAL.
      END.
      /* Reasignamos */
      ASSIGN
          Vtacdocu.usrsac    = B-PikSacadores.CodPer
          Vtacdocu.ubigeo[4] = B-PikSacadores.CodPer.
      ASSIGN
          B-Sacadores.FlgTarea = "L".      /* Libre */
      ASSIGN
          B-PikSacadores.FlgTarea = "O".    /* Ocupado */
      /* TRACKING */
      RUN vtagn/pTracking-04 (s-CodCia,
                              s-CodDiv,
                              Vtacdocu.CodRef,
                              Vtacdocu.NroRef,
                              s-User-Id,
                              'RPOD',
                              'P',
                              DATETIME(TODAY, MTIME),
                              DATETIME(TODAY, MTIME),
                              Vtacdocu.CodPed,
                              Vtacdocu.NroPed,
                              Vtacdocu.CodPed,
                              ENTRY(1,Vtacdocu.NroPed,'-')).

END.
IF AVAILABLE(B-Sacadores)    THEN RELEASE B-Sacadores.
IF AVAILABLE(B-PikSacadores) THEN RELEASE B-PikSacadores.
IF AVAILABLE(VtaCDocu)       THEN RELEASE VtaCDocu.
APPLY 'CHOOSE':U TO BUTTON-Refrescar IN FRAME {&FRAME-NAME}.
IF pError > '' THEN MESSAGE pError VIEW-AS ALERT-BOX ERROR.
ELSE MESSAGE 'Asignación Exitosa' VIEW-AS ALERT-BOX INFORMATION. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Refrescar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Refrescar W-Win
ON CHOOSE OF BUTTON-Refrescar IN FRAME T-PikSacadoreF-Main /* REFRESCAR */
DO:
  RUN Carga-Temporal.
  {&OPEN-QUERY-{&BROWSE-NAME}}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-PikSacadores.
DEF VAR k AS INT NO-UNDO.

/* Buscamos configuracion del supervisor */
FIND FIRST PikSupervisores WHERE PikSupervisores.CodCia = s-codcia
    AND PikSupervisores.CodDiv = s-coddiv
    AND PikSupervisores.Usuario = s-user-id
    NO-LOCK NO-ERROR.
/* Buscamos sacadores a cargo del supervisor */
FOR EACH PikSacadores NO-LOCK WHERE PikSacadores.CodCia = s-codcia
    AND PikSacadores.CodDiv = s-coddiv
    AND PikSacadores.FlgEst = "A":  /* ACTIVO */
    IF AVAILABLE PikSupervisores AND PikSupervisores.Sector <> '' 
        THEN DO:
        DO k = 1 TO NUM-ENTRIES(PikSacadores.Sector):
            IF LOOKUP(ENTRY(k,PikSacadores.Sector),PikSupervisores.Sector) > 0 THEN DO:
                FIND T-PikSacadores WHERE T-PikSacadores.CodCia = PikSacadores.CodCia
                    AND T-PikSacadores.CodPer = PikSacadores.CodPer
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE T-PikSacadores THEN DO:
                    CREATE T-PikSacadores.
                    BUFFER-COPY PikSacadores TO T-PikSacadores ASSIGN T-PikSacadores.cRowid = ROWID(PikSacadores).
                    ASSIGN T-PikSacadores.nomper = fnomper().
                END.
            END.
        END.
    END.
    ELSE DO:
        CREATE T-PikSacadores.
        BUFFER-COPY PikSacadores TO T-PikSacadores ASSIGN T-PikSacadores.cRowid = ROWID(PikSacadores).
        ASSIGN T-PikSacadores.nomper = fnomper().
    END.
END.
/* Buscamos tarea activa */
FOR EACH T-PikSacadores:
    IF T-PikSacadores.FlgTarea = "O" THEN DO:
        TareasPendientes:
        FOR EACH VtaCDocu USE-INDEX Llave11 WHERE VtaCDocu.CodCia = T-PikSacadores.codcia
            AND VtaCDocu.DivDes = T-PikSacadores.coddiv
            AND VtaCDocu.UsrSac = T-PikSacadores.codper 
            AND VtaCDocu.FlgEst = "P"
            AND VtaCDocu.FlgSit = "P" 
            NO-LOCK:
            ASSIGN 
                T-PikSacadores.fchinicio = VtaCDocu.FchInicio 
                T-PikSacadores.fchfin    = VtaCDocu.FchFin 
                T-PikSacadores.flgest    = VtaCDocu.FlgEst 
                T-PikSacadores.codped    = VtaCDocu.CodPed 
                T-PikSacadores.nroped    = VtaCDocu.NroPed
                T-PikSacadores.items     = VtaCDocu.Items.
            LEAVE TareasPendientes.
        END.
    END.
    ELSE DO:
        TareasTrabajadas:
        FOR EACH VtaCDocu USE-INDEX Llave11 WHERE VtaCDocu.CodCia = T-PikSacadores.codcia
            AND VtaCDocu.DivDes = T-PikSacadores.coddiv
            AND VtaCDocu.UsrSac = T-PikSacadores.codper 
            AND VtaCDocu.FlgEst = "P"
            AND VtaCDocu.FlgSit = "C"
            NO-LOCK BY VtaCDocu.fchfin DESC :
            ASSIGN 
                T-PikSacadores.fchinicio = VtaCDocu.FchInicio
                T-PikSacadores.fchfin    = VtaCDocu.FchFin 
                T-PikSacadores.flgest    = VtaCDocu.FlgEst 
                T-PikSacadores.codped    = VtaCDocu.CodPed 
                T-PikSacadores.nroped    = VtaCDocu.NroPed
                T-PikSacadores.items     = VtaCDocu.Items.
            LEAVE TareasTrabajadas.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierre-de-guia W-Win 
PROCEDURE Cierre-de-guia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR lItems AS INT INIT 0.
  DEFINE VAR lImporte AS DEC INIT 0.
  DEFINE VAR lPeso AS DEC INIT 0.
  DEFINE VAR lVolumen AS DEC INIT 0.

  DEFINE VAR lCodSacador AS CHAR.

  DEFINE VAR x-codori AS CHAR.
  DEFINE VAR x-ordenes-ori AS CHAR.
  DEFINE VAR x-nroori AS CHAR.
  DEFINE VAR x-sec AS INT.

  DEFINE BUFFER x-vtacdocu FOR vtacdocu.

  CICLO:
  DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
      /* Marcar al trabajador como ocupado */
      FIND CURRENT B-PikSacadores EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-PikSacadores THEN DO:
          pError =  'NO se pudo bloquear el registro del sacador'.
          UNDO, LEAVE CICLO.
      END.
      /* Vuelvo a Verificar si el Pickeador esta LIBRE */
      IF B-PikSacadores.FlgTarea <> "L" THEN DO:
          pError = 'El Sacador está YA NO ESTA LIBRE'.
          UNDO, LEAVE CICLO.
      END.
      FIND Vtacdocu WHERE Vtacdocu.codcia = s-codcia
          AND Vtacdocu.divdes = s-CodDiv
          AND Vtacdocu.codped = pCodPed
          AND Vtacdocu.nroped = pNroPed
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Vtacdocu THEN DO:
          pError = "NO se pudo bloquear la sub-orden " + pCodPed + " " + pNroPed.
          UNDO, LEAVE CICLO.
      END.
      /* Volvemos a chequear las condiciones */
      IF NOT (Vtacdocu.flgest = 'P' AND Vtacdocu.flgsit = 'T') THEN DO:
          pError = 'ERROR en la Sub-Orden ' + pCodPed + ' ' + pNroPed + CHR(10) + 
              'Ya NO está pendiente de Pickeo'.
          UNDO, LEAVE CICLO.
      END.
      ASSIGN 
          Vtacdocu.usrsac = B-PikSacadores.CodPer
          Vtacdocu.fecsac = TODAY
          Vtacdocu.horsac = STRING(TIME,'HH:MM:SS')
          Vtacdocu.ubigeo[4] = B-PikSacadores.CodPer
          Vtacdocu.usrsacasign   = s-user-id
          Vtacdocu.fchinicio = NOW
          Vtacdocu.usuarioinicio = s-user-id
          Vtacdocu.FlgSit    = "P".     /* En Proceso de Picking (APOD) */

      ASSIGN Vtacdocu.items     = 0
        Vtacdocu.peso      = 0
        Vtacdocu.volumen   = 0.

      IF vtacdocu.codped = 'ODC' OR vtacdocu.codped = 'OTC' OR vtacdocu.codped = 'OTM'THEN DO:
          /* Ordenes consolidadas */
          x-ordenes-ori = TRIM(vtacdocu.nroori).
          x-codori = TRIM(vtacdocu.codori).

          REPEAT x-sec = 1 TO NUM-ENTRIES(x-ordenes-ori,","):
                x-nroori = ENTRY(x-sec,x-ordenes-ori,",").
                FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND 
                                            x-vtacdocu.codped = x-codori AND 
                                            x-vtacdocu.nroped = x-nroori NO-ERROR.
                IF AVAILABLE x-vtacdocu THEN DO:
                    ASSIGN x-Vtacdocu.usrsac = Vtacdocu.usrsac
                        x-Vtacdocu.fecsac = Vtacdocu.fecsac
                        x-Vtacdocu.horsac = Vtacdocu.horsac
                        x-Vtacdocu.ubigeo[4] = Vtacdocu.ubigeo[4]
                        x-Vtacdocu.usrsacasign = Vtacdocu.usrsacasign
                        x-Vtacdocu.fchinicio = Vtacdocu.fchinicio
                        x-Vtacdocu.usuarioinicio = Vtacdocu.usuarioinicio
                        x-Vtacdocu.FlgSit    = Vtacdocu.FlgSit.     /* En Proceso de Picking (APOD) */

                    /* Importes */
                    RUN ue-get-cantidades(INPUT x-VtaCDocu.codped, INPUT x-VtaCDocu.nroped,
                                           OUTPUT lItems, OUTPUT lImporte,
                                           OUTPUT lPeso, OUTPUT lVolumen).

                    /* SubOrden */ 
                    ASSIGN  x-Vtacdocu.items     = lItems
                            x-Vtacdocu.peso      = lPeso
                            x-Vtacdocu.volumen   = lVolumen.

                    /* Consolidada ??? */
                    ASSIGN  Vtacdocu.items     = Vtacdocu.items + lItems
                            Vtacdocu.peso      = Vtacdocu.peso + lPeso
                            Vtacdocu.volumen   = Vtacdocu.volumen + lVolumen.

                    /* TRACKING */
                    RUN vtagn/pTracking-04 (s-CodCia,
                                            s-CodDiv,
                                            x-Vtacdocu.CodRef,
                                            x-Vtacdocu.NroRef,
                                            s-User-Id,
                                            'APOD',
                                            'P',
                                            DATETIME(TODAY, MTIME),
                                            DATETIME(TODAY, MTIME),
                                            x-Vtacdocu.CodPed,
                                            x-Vtacdocu.NroPed,
                                            x-Vtacdocu.CodPed,
                                            ENTRY(1,x-Vtacdocu.NroPed,'-')).
                END.
          END.

      END.
      ELSE DO:
          /* Importes */
          RUN ue-get-cantidades(INPUT VtaCDocu.codped, INPUT VtaCDocu.nroped,
                                 OUTPUT lItems, OUTPUT lImporte,
                                 OUTPUT lPeso, OUTPUT lVolumen).
          ASSIGN  
              Vtacdocu.items     = lItems
              Vtacdocu.peso      = lPeso
              Vtacdocu.volumen   = lVolumen.
          /* TRACKING */
          RUN vtagn/pTracking-04 (s-CodCia,
                                  s-CodDiv,
                                  Vtacdocu.CodRef,
                                  Vtacdocu.NroRef,
                                  s-User-Id,
                                  'APOD',
                                  'P',
                                  DATETIME(TODAY, MTIME),
                                  DATETIME(TODAY, MTIME),
                                  Vtacdocu.CodPed,
                                  Vtacdocu.NroPed,
                                  Vtacdocu.CodPed,
                                  ENTRY(1,Vtacdocu.NroPed,'-')).
      END.
   /* Pickeador ocupado */
   ASSIGN  
   B-PikSacadores.FlgTarea = 'O'.    /* OCUPADO */
END.

IF AVAILABLE(B-PikSacadores) THEN RELEASE B-PikSacadores.
IF AVAILABLE(Vtacdocu)     THEN RELEASE Vtacdocu.
IF pError <> '' THEN MESSAGE pError VIEW-AS ALERT-BOX ERROR.

RETURN "OK".

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
  ENABLE BUTTON-Refrescar BUTTON-Asignar BUTTON-Reasignar BROWSE-3 
      WITH FRAME T-PikSacadoreF-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-T-PikSacadoreF-Main}
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
   RUN Carga-Temporal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "T-PikSacadores"}
  {src/adm/template/snd-list.i "PikSacadores"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-get-cantidades W-Win 
PROCEDURE ue-get-cantidades :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE OUTPUT PARAMETER pItems AS INT.
DEFINE OUTPUT PARAMETER pImporte AS DEC.
DEFINE OUTPUT PARAMETER pPeso AS DEC.
DEFINE OUTPUT PARAMETER pVolumen AS DEC.

pItems = 0.
pImporte = 0.
pPeso = 0.
pVolumen = 0.
FOR EACH VtaDDocu OF VtaCDocu NO-LOCK,
        FIRST almmmatg OF VtaDDocu NO-LOCK:
    pItems = pItems + 1.
    pImporte = pImporte + VtaDDocu.implin.
    pPeso = pPeso + ((VtaDDocu.canped * VtaDDocu.factor) * Almmmatg.pesmat).
    pVolumen = pVolumen + ((VtaDDocu.canped * VtaDDocu.factor) * Almmmatg.libre_d02).
END.

pVolumen = (pVolumen / 1000000).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNomPer W-Win 
FUNCTION fNomPer RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND Pl-pers WHERE Pl-pers.codper = PikSacadores.CodPer NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Pl-pers THEN RETURN ''.
  RETURN TRIM(PL-PERS.patper) + ' ' + TRIM(PL-PERS.matper) + ', ' + PL-PERS.nomper.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSector W-Win 
FUNCTION fSector RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND PikSupervisores WHERE PikSupervisores.CodCia = s-codcia
      AND PikSupervisores.CodDiv = s-coddiv
      AND PikSupervisores.Usuario = s-user-id
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE PikSupervisores THEN RETURN TRUE.
  IF NOT AVAILABLE T-PikSacadores THEN RETURN TRUE.
  DEF VAR k AS INT NO-UNDO.
  DO k = 1 TO NUM-ENTRIES(T-PikSacadores.Sector):
      IF LOOKUP(ENTRY(k,T-PikSacadores.Sector),PikSupervisores.Sector) > 0 THEN RETURN TRUE.
  END.
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fTiempo W-Win 
FUNCTION fTiempo RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Tiempo AS CHAR NO-UNDO.

  /* Si no tiene aún tareas asignadas */
  IF T-PikSacadores.CodPed = '' THEN DO:
      RUN lib/_time-passed (T-PikSacadores.FchInicio, DATETIME(TODAY, MTIME), OUTPUT x-Tiempo).
  END.
  ELSE DO:
      /* Se cuenta desde la última tarea */
      IF T-PikSacadores.FlgTarea = "O"      /* OCUPADO */
          THEN RUN lib/_time-passed (T-PikSacadores.FchInicio, DATETIME(TODAY, MTIME), OUTPUT x-Tiempo).
      ELSE RUN lib/_time-passed (T-PikSacadores.FchFin, DATETIME(TODAY, MTIME), OUTPUT x-Tiempo).
  END.
  RETURN x-Tiempo.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

