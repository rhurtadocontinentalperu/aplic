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
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.

DEFINE VAR x-trabajador AS CHAR.

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
&Scoped-define INTERNAL-TABLES chkchequeador PL-PERS

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 chkchequeador.codper ~
(trim(pl-pers.patper) + " " + trim(pl-pers.matper) + " " + trim(pl-pers.nomper)) @ x-trabajador ~
chkchequeador.mesa chkchequeador.fchasignacion chkchequeador.horasignacion 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH chkchequeador ~
      WHERE chkchequeador.codcia = s-codcia and  ~
chkchequeador.coddiv = s-coddiv and ~
chkchequeador.flgest = 'A' NO-LOCK, ~
      EACH PL-PERS WHERE PL-PERS.codper =  chkchequeador.codper NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH chkchequeador ~
      WHERE chkchequeador.codcia = s-codcia and  ~
chkchequeador.coddiv = s-coddiv and ~
chkchequeador.flgest = 'A' NO-LOCK, ~
      EACH PL-PERS WHERE PL-PERS.codper =  chkchequeador.codper NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 chkchequeador PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 chkchequeador
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 PL-PERS


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-codper BROWSE-2 BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-codper 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Cerrar sesion" 
     SIZE 15 BY .96.

DEFINE BUTTON BUTTON-2 
     LABEL "Cerrar todas las sesiones" 
     SIZE 24 BY .96.

DEFINE VARIABLE FILL-IN-codper AS INTEGER FORMAT "999999":U INITIAL 0 
     LABEL "Codigo de trabajador" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      chkchequeador, 
      PL-PERS SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      chkchequeador.codper COLUMN-LABEL "Codigo" FORMAT "x(6)":U
            WIDTH 6.43
      (trim(pl-pers.patper) + " " + trim(pl-pers.matper) + " " + trim(pl-pers.nomper)) @ x-trabajador COLUMN-LABEL "Apellidos y Nombres" FORMAT "x(40)":U
      chkchequeador.mesa COLUMN-LABEL "Mesa" FORMAT "x(8)":U WIDTH 11.86
      chkchequeador.fchasignacion COLUMN-LABEL "Fecha" FORMAT "99/99/9999":U
            WIDTH 11.43
      chkchequeador.horasignacion COLUMN-LABEL "Hora" FORMAT "x(8)":U
            WIDTH 12.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 88 BY 17.88 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-codper AT ROW 1.58 COL 21 COLON-ALIGNED WIDGET-ID 2
     BROWSE-2 AT ROW 3.31 COL 3 WIDGET-ID 200
     BUTTON-1 AT ROW 21.58 COL 41 WIDGET-ID 4
     BUTTON-2 AT ROW 21.62 COL 59 WIDGET-ID 6
     "DobleClick cambiar mesa!" VIEW-AS TEXT
          SIZE 33 BY .77 AT ROW 21.69 COL 6 WIDGET-ID 8
          FGCOLOR 4 FONT 9
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 92.72 BY 22.96 WIDGET-ID 100.


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
         TITLE              = "Registro de Chequeadores"
         HEIGHT             = 22.96
         WIDTH              = 92.72
         MAX-HEIGHT         = 39.12
         MAX-WIDTH          = 274.29
         VIRTUAL-HEIGHT     = 39.12
         VIRTUAL-WIDTH      = 274.29
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
/* BROWSE-TAB BROWSE-2 FILL-IN-codper F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.chkchequeador,INTEGRAL.PL-PERS WHERE INTEGRAL.chkchequeador ..."
     _Options          = "NO-LOCK"
     _Where[1]         = "chkchequeador.codcia = s-codcia and 
chkchequeador.coddiv = s-coddiv and
chkchequeador.flgest = 'A'"
     _JoinCode[2]      = "PL-PERS.codper =  chkchequeador.codper"
     _FldNameList[1]   > INTEGRAL.chkchequeador.codper
"chkchequeador.codper" "Codigo" ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"(trim(pl-pers.patper) + "" "" + trim(pl-pers.matper) + "" "" + trim(pl-pers.nomper)) @ x-trabajador" "Apellidos y Nombres" "x(40)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.chkchequeador.mesa
"chkchequeador.mesa" "Mesa" ? "character" ? ? ? ? ? ? no ? no no "11.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.chkchequeador.fchasignacion
"chkchequeador.fchasignacion" "Fecha" ? "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.chkchequeador.horasignacion
"chkchequeador.horasignacion" "Hora" ? "character" ? ? ? ? ? ? no ? no no "12.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Registro de Chequeadores */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Registro de Chequeadores */
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
ON MOUSE-SELECT-DBLCLICK OF BROWSE-2 IN FRAME F-Main
DO:
    DEFINE VAR x-codper AS CHAR.

    IF NOT AVAILABLE ChkChequeador THEN RETURN NO-APPLY.

    x-codper = ChkChequeador.codper.

    IF INTEGER(x-codper) > 0 THEN DO:
        RUN modificar-mesa(INPUT x-codper).
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Cerrar sesion */
DO: 

    IF AVAILABLE ChkChequeador THEN DO:
        MESSAGE 'Desea cerrar Sesion del codigo(' + ChkChequeador.codper + ') ?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

        DEFINE VAR x-retval AS CHAR.
        RUN cerrar-sesion(OUTPUT x-retval, INPUT ROWID(ChkChequeador)).

        IF x-retval = "OK" THEN DO:
            {&OPEN-QUERY-BROWSE-2}
        END.
        ELSE MESSAGE x-retval.

    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Cerrar todas las sesiones */
DO:
    IF AVAILABLE ChkChequeador THEN DO:
        MESSAGE 'Desea cerrar TODAS las sesiones ?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.


        RUN cerrar-all-sesiones.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codper W-Win
ON LEAVE OF FILL-IN-codper IN FRAME F-Main /* Codigo de trabajador */
DO:
  
    DEFINE VAR x-codper AS CHAR.

    x-codper = SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    IF INTEGER(x-codper) > 0 THEN DO:
        RUN verificar-codigo.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

        ON 'RETURN':U OF  fill-in-codper
        DO:
            APPLY 'TAB'.
            RETURN NO-APPLY.
        END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cerrar-all-sesiones W-Win 
PROCEDURE cerrar-all-sesiones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-sesiones-cerradas AS INT INIT 0.
DEFINE VAR x-sesiones-no-cerradas AS INT INIT 0.
DEFINE VAR x-retval AS CHAR.
DEFINE VAR x-rowid AS ROWID.

SESSION:SET-WAIT-STATE('GENERAL').

GET FIRST {&BROWSE-NAME}.
DO  WHILE AVAILABLE ChkChequeador:
            
        x-rowid = ROWID(ChkChequeador).

        RUN cerrar-sesion(OUTPUT x-retval, INPUT x-rowid).

        IF x-retval = "OK" THEN DO:
           x-sesiones-cerradas = x-sesiones-cerradas + 1. 
        END.
        ELSE x-sesiones-no-cerradas = x-sesiones-no-cerradas + 1.  

    GET NEXT {&BROWSE-NAME}.
END.

IF x-sesiones-cerradas > 0 THEN {&OPEN-QUERY-BROWSE-2}

SESSION:SET-WAIT-STATE('').

MESSAGE "Se cerraron " + STRING(x-sesiones-cerradas) + " sesion(es) y  " + STRING(x-sesiones-no-cerradas) + " tiene(n) problema(s)".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cerrar-sesion W-Win 
PROCEDURE cerrar-sesion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pRetVal AS CHAR.
DEFINE INPUT PARAMETER pRowId AS ROWID.


DEFINE BUFFER b-ChkChequeador FOR ChkChequeador.

pRetVal = "OK".
FIND FIRST b-ChkChequeador WHERE ROWID(b-ChkChequeador) = pRowId NO-LOCK NO-ERROR.

IF AVAILABLE b-ChkChequeador THEN DO:
    /* Validar que no tenga Tarea Asignada */
    FIND FIRST ChkTareas WHERE ChkTareas.codcia = s-codcia AND
                                ChkTareas.coddiv = b-ChkChequeador.coddiv AND 
                                ChkTareas.mesa = b-ChkChequeador.mesa AND 
                                ChkTareas.flgest = 'P' NO-LOCK NO-ERROR.
    IF AVAILABLE ChkTareas THEN DO:
        pRetVal = "La mesa(" + b-ChkChequeador.mesa + ") aun tiene una tarea asignada (" + ChkTareas.coddoc + " " + ChkTareas.NroPed + ") Imposible cerrar la Sesion!!!".
        RETURN.
    END.

    /* Cerrar la Sesion */
    /*DEFINE BUFFER b-ChkChequeador FOR ChkChequeador.*/
    /*
    DEFINE VAR x-rowid AS ROWID.    

    x-rowid = ROWID(ChkChequeador).
    */
    FIND CURRENT b-ChkChequeador EXCLUSIVE-LOCK NO-ERROR.

    IF AVAILABLE b-ChkChequeador THEN DO:
        /* Libero la Mesa */
        FIND FIRST ChkMesas WHERE ChkMesas.codcia = s-codcia AND 
                                    ChkMesas.coddiv = b-ChkChequeador.coddiv AND 
                                    ChkMesas.mesa = b-ChkChequeador.mesa EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE ChkMesas THEN DO:
            ASSIGN ChkMesas.flgest = 'L'.
            /**/
            ASSIGN b-ChkChequeador.flgest = 'C'.        
        END.
        ELSE pRetVal = "No se pudo liberar la Mesa".        
    END.
    ELSE DO:
        pRetVal = "Hubo problemas al cerrar la sesion, intente de nuevo!!!".
    END.   

    RELEASE b-ChkChequeador.        
    RELEASE ChkMesas.
END.
ELSE DO:
    pRetVal = "No existe????, intente de nuevo!!!".
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
  DISPLAY FILL-IN-codper 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-codper BROWSE-2 BUTTON-1 BUTTON-2 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE modificar-mesa W-Win 
PROCEDURE modificar-mesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodigo AS CHAR.

DEFINE BUFFER x-ChkChequeador FOR ChkChequeador.
DEFINE BUFFER x-pl-pers FOR pl-pers.

DEFINE VAR x-codigo AS CHAR.
DEFINE VAR x-nueva-mesa AS CHAR.
DEFINE VAR x-anterior-mesa AS CHAR.

x-codigo = pCodigo.

FIND FIRST x-pl-pers WHERE x-pl-pers.codper = x-codigo NO-LOCK NO-ERROR.

IF NOT AVAILABLE x-pl-pers THEN DO:
    MESSAGE "Codigo de trabajador no existe".
    RETURN.
END.

FIND FIRST x-ChkChequeador WHERE x-ChkChequeador.codcia = s-codcia AND 
                                    x-ChkChequeador.coddiv = s-coddiv AND 
                                    x-ChkChequeador.codper = x-codigo AND
                                    x-ChkChequeador.flgest = 'A' NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-ChkChequeador THEN DO:
    MESSAGE "Codigo de trabajador NO tiene MESA asignada".
    RETURN.
END.
FIND FIRST ChkTareas WHERE ChkTareas.codcia = s-codcia AND
                            ChkTareas.coddiv = x-ChkChequeador.coddiv AND 
                            ChkTareas.mesa = x-ChkChequeador.mesa AND 
                            ChkTareas.flgest = 'P' NO-LOCK NO-ERROR.
IF AVAILABLE ChkTareas THEN DO:
    MESSAGE "La mesa(" + x-ChkChequeador.mesa + ") aun tiene una tarea asignada (" + ChkTareas.coddoc + " " + ChkTareas.NroPed + ") !!!".
    RETURN.
END.

RUN dist/d-chequeador-modifica-mesa.r(INPUT x-codigo, OUTPUT x-nueva-mesa).

IF x-nueva-mesa <> "" THEN DO:
    x-anterior-mesa = x-ChkChequeador.mesa.
    /* Asignamos la nueva mesa */
    FIND CURRENT x-ChkChequeador EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE x-ChkChequeador THEN DO:
        ASSIGN x-ChkChequeador.mesa = x-nueva-mesa.
    END.
    /* Liberamos la mesa anterior */
    FIND FIRST ChkMesas WHERE ChkMesas.codcia = s-codcia AND
                                ChkMesas.coddiv = s-coddiv AND 
                                ChkMesas.mesa = x-anterior-mesa
                                EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE ChkMesas THEN DO:        
        /* Mesa Liberada */
        ASSIGN ChkMesas.flgest = 'L'.
    END.

    RELEASE ChkMesas.

END.

{&OPEN-QUERY-BROWSE-2}


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
  {src/adm/template/snd-list.i "chkchequeador"}
  {src/adm/template/snd-list.i "PL-PERS"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificar-codigo W-Win 
PROCEDURE verificar-codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN FILL-IN-codper.
END.

DEFINE BUFFER x-ChkChequeador FOR ChkChequeador.
DEFINE BUFFER x-pl-pers FOR pl-pers.

DEFINE VAR x-codigo AS CHAR.

x-codigo = STRING(fill-in-codper,"999999").
FIND FIRST x-pl-pers WHERE x-pl-pers.codper = x-codigo NO-LOCK NO-ERROR.

IF NOT AVAILABLE x-pl-pers THEN DO:
    MESSAGE "Codigo de trabajador no existe".
    RETURN.
END.

FIND FIRST x-ChkChequeador WHERE x-ChkChequeador.codcia = s-codcia AND 
                                    x-ChkChequeador.coddiv = s-coddiv AND 
                                    x-ChkChequeador.codper = x-codigo AND
                                    x-ChkChequeador.flgest = 'A' NO-LOCK NO-ERROR.
IF AVAILABLE x-ChkChequeador THEN DO:
    MESSAGE "Codigo de trabajador ya tiene MESA asignada".
    RETURN.
END.

RUN dist/d-chequeador-mesa.r(INPUT x-codigo).

{&OPEN-QUERY-BROWSE-2}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

