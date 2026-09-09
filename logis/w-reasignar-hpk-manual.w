&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-VtaCDocu NO-UNDO LIKE VtaCDocu
       FIELD Nombre AS CHAR
       FIELD Origen AS CHAR.
DEFINE TEMP-TABLE tt-rut-pers-turno NO-UNDO LIKE rut-pers-turno
       fields hinicio as char
       fields htermino as char
       fields hefectivas as dec
       fields nombre-picador as char
       fields origen-picador as char
       fields total-asig as int
       FIELD hpks AS INT
       FIELD items AS INT.
DEFINE BUFFER x-vtacdocu FOR VtaCDocu.



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

DEF VAR x-Nombre AS CHAR NO-UNDO.
DEF VAR x-Origen AS CHAR NO-UNDO.

DEF VAR x-NroHPKs AS INT NO-UNDO.
DEF VAR x-NroItems AS INT NO-UNDO.

DEF VAR x-nombre-picador-col AS CHAR NO-UNDO.
DEF VAR x-origen-picador-col AS CHAR NO-UNDO.
DEF VAR x-col-total-hpk-asig AS INT NO-UNDO.
DEF VAR x-col-total-item-asig AS INT NO-UNDO.
DEF VAR x-hora-inicio-col AS CHAR NO-UNDO.
DEF VAR x-hora-termino-col AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-PERSONAL

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-rut-pers-turno rut-pers-turno

/* Definitions for BROWSE BROWSE-PERSONAL                               */
&Scoped-define FIELDS-IN-QUERY-BROWSE-PERSONAL ~
tt-rut-pers-turno.nombre-picador @ x-nombre-picador-col ~
tt-rut-pers-turno.origen-picador @ x-origen-picador-col ~
tt-rut-pers-turno.turno tt-rut-pers-turno.hpks @ x-col-total-hpk-asig ~
tt-rut-pers-turno.items @ x-col-total-item-asig 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-PERSONAL 
&Scoped-define QUERY-STRING-BROWSE-PERSONAL FOR EACH tt-rut-pers-turno NO-LOCK, ~
      FIRST rut-pers-turno WHERE rut-pers-turno.codcia = tt-rut-pers-turno.codcia ~
  AND rut-pers-turno.coddiv = tt-rut-pers-turno.coddiv ~
  AND rut-pers-turno.dni = tt-rut-pers-turno.dni ~
  AND rut-pers-turno.fchasignada = tt-rut-pers-turno.fchasignada ~
  AND rut-pers-turno.turno = tt-rut-pers-turno.turno ~
  AND rut-pers-turno.rol = tt-rut-pers-turno.rol NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-PERSONAL OPEN QUERY BROWSE-PERSONAL FOR EACH tt-rut-pers-turno NO-LOCK, ~
      FIRST rut-pers-turno WHERE rut-pers-turno.codcia = tt-rut-pers-turno.codcia ~
  AND rut-pers-turno.coddiv = tt-rut-pers-turno.coddiv ~
  AND rut-pers-turno.dni = tt-rut-pers-turno.dni ~
  AND rut-pers-turno.fchasignada = tt-rut-pers-turno.fchasignada ~
  AND rut-pers-turno.turno = tt-rut-pers-turno.turno ~
  AND rut-pers-turno.rol = tt-rut-pers-turno.rol NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-PERSONAL tt-rut-pers-turno ~
rut-pers-turno
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-PERSONAL tt-rut-pers-turno
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-PERSONAL rut-pers-turno


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-PERSONAL}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-Refrescar BUTTON-15 BROWSE-PERSONAL 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNombreOrigen W-Win 
FUNCTION fNombreOrigen RETURNS CHARACTER
  ( INPUT pDNI AS CHAR, INPUT pDato AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNroHPKs W-Win 
FUNCTION fNroHPKs RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNroItems W-Win 
FUNCTION fNroItems RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-reasignar-hpk-manual AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv10 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-15 
     LABEL "REASIGNAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Refrescar 
     LABEL "LIMPIAR HPKs A REASIGNAR" 
     SIZE 31 BY 1.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-PERSONAL FOR 
      tt-rut-pers-turno, 
      rut-pers-turno SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-PERSONAL
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-PERSONAL W-Win _STRUCTURED
  QUERY BROWSE-PERSONAL NO-LOCK DISPLAY
      tt-rut-pers-turno.nombre-picador @ x-nombre-picador-col COLUMN-LABEL "Picador" FORMAT "x(50)":U
            WIDTH 29.57
      tt-rut-pers-turno.origen-picador @ x-origen-picador-col COLUMN-LABEL "Origen" FORMAT "x(15)":U
      tt-rut-pers-turno.turno COLUMN-LABEL "TURNO" FORMAT "x(15)":U
            WIDTH 9.14
      tt-rut-pers-turno.hpks @ x-col-total-hpk-asig COLUMN-LABEL "#HPK" FORMAT ">>9":U
      tt-rut-pers-turno.items @ x-col-total-item-asig COLUMN-LABEL "#Items" FORMAT ">>>9":U
            WIDTH 12.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 72 BY 23.15
         FONT 4
         TITLE "SELECCIONE LA PERSONA A LA CUAL DESEA REASIGNAR TAREAS" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Refrescar AT ROW 1.27 COL 2 WIDGET-ID 8
     BUTTON-15 AT ROW 1.27 COL 112 WIDGET-ID 6
     BROWSE-PERSONAL AT ROW 2.62 COL 112 WIDGET-ID 400
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 186.14 BY 25.08
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t-VtaCDocu T "?" NO-UNDO INTEGRAL VtaCDocu
      ADDITIONAL-FIELDS:
          FIELD Nombre AS CHAR
          FIELD Origen AS CHAR
      END-FIELDS.
      TABLE: tt-rut-pers-turno T "?" NO-UNDO INTEGRAL rut-pers-turno
      ADDITIONAL-FIELDS:
          fields hinicio as char
          fields htermino as char
          fields hefectivas as dec
          fields nombre-picador as char
          fields origen-picador as char
          fields total-asig as int
          FIELD hpks AS INT
          FIELD items AS INT
      END-FIELDS.
      TABLE: x-vtacdocu B "?" ? INTEGRAL VtaCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "REASIGNACION DE TAREAS"
         HEIGHT             = 25.08
         WIDTH              = 186.14
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 186.14
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 186.14
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
/* BROWSE-TAB BROWSE-PERSONAL BUTTON-15 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-PERSONAL
/* Query rebuild information for BROWSE BROWSE-PERSONAL
     _TblList          = "Temp-Tables.tt-rut-pers-turno,INTEGRAL.rut-pers-turno WHERE Temp-Tables.tt-rut-pers-turno ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _JoinCode[2]      = "INTEGRAL.rut-pers-turno.codcia = Temp-Tables.tt-rut-pers-turno.codcia
  AND INTEGRAL.rut-pers-turno.coddiv = Temp-Tables.tt-rut-pers-turno.coddiv
  AND INTEGRAL.rut-pers-turno.dni = Temp-Tables.tt-rut-pers-turno.dni
  AND INTEGRAL.rut-pers-turno.fchasignada = Temp-Tables.tt-rut-pers-turno.fchasignada
  AND INTEGRAL.rut-pers-turno.turno = Temp-Tables.tt-rut-pers-turno.turno
  AND INTEGRAL.rut-pers-turno.rol = Temp-Tables.tt-rut-pers-turno.rol"
     _FldNameList[1]   > "_<CALC>"
"tt-rut-pers-turno.nombre-picador @ x-nombre-picador-col" "Picador" "x(50)" ? ? ? ? ? ? ? no ? no no "29.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"tt-rut-pers-turno.origen-picador @ x-origen-picador-col" "Origen" "x(15)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-rut-pers-turno.turno
"tt-rut-pers-turno.turno" "TURNO" ? "character" ? ? ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"tt-rut-pers-turno.hpks @ x-col-total-hpk-asig" "#HPK" ">>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"tt-rut-pers-turno.items @ x-col-total-item-asig" "#Items" ">>>9" ? ? ? ? ? ? ? no ? no no "12.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-PERSONAL */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REASIGNACION DE TAREAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REASIGNACION DE TAREAS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-15
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-15 W-Win
ON CHOOSE OF BUTTON-15 IN FRAME F-Main /* REASIGNAR */
DO:
  IF NOT AVAILABLE rut-pers-turno THEN RETURN.

  MESSAGE 'Confirmamos la reasignación?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.

  DEF VAR pError AS CHAR NO-UNDO.
  DEF VAR k AS INT NO-UNDO.

  pError = "".

  DEF BUFFER B-CDOCU FOR Vtacdocu.

  /* Buscamos la tarea activa */
  RUN Envia-Temporal IN h_b-reasignar-hpk-manual (OUTPUT TABLE t-VtaCDocu).

  DEF VAR j AS INTE NO-UNDO.
  DEF VAR NuevoValor AS CHAR NO-UNDO.
  
  FOR EACH t-Vtacdocu NO-LOCK, 
      FIRST Vtacdocu NO-LOCK WHERE Vtacdocu.codcia = t-Vtacdocu.codcia
        AND Vtacdocu.codped = t-Vtacdocu.codped
        AND Vtacdocu.nroped = t-VTacdocu.nroped:
      {lib/lock-genericov3.i ~
          &Tabla="B-CDOCU" ~
          &Condicion="ROWID(B-CDOCU) = ROWID(Vtacdocu)" ~
          &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
          &Accion="LEAVE" ~
          &Mensaje="NO" ~
          &txtMensaje="pError" ~
          &TipoError="UNDO, LEAVE"}
      /* Actualizamos el sacador */
      ASSIGN
          B-CDOCU.usrsac    = rut-pers-turno.dni
          B-CDOCU.ubigeo[4] = rut-pers-turno.dni.
      IF B-CDOCU.Libre_c03 > '' AND NUM-ENTRIES(B-CDOCU.Libre_c03,'|') >= 3 THEN DO:
          DO j = 1 TO NUM-ENTRIES(B-CDOCU.Libre_c03,'|'):
              IF j = 1 THEN NuevoValor = ENTRY(1,B-CDOCU.Libre_c03,'|').
              ELSE NuevoValor = NuevoValor + '|' + (IF j = 3 THEN rut-pers-turno.dni ELSE ENTRY(1,B-CDOCU.Libre_c03,'|')).
          END.
          B-CDOCU.Libre_c03 = NuevoValor.
      END.
  END.

  IF AVAILABLE(rut-pers-turno) THEN RELEASE rut-pers-turno.
  IF AVAILABLE(B-CDOCU)        THEN RELEASE B-CDOCU.

  IF pError > '' THEN MESSAGE pError VIEW-AS ALERT-BOX ERROR.
  APPLY 'CHOOSE':U TO BUTTON-Refrescar IN FRAME {&FRAME-NAME}.
  IF pError > '' THEN MESSAGE pError VIEW-AS ALERT-BOX ERROR.
  ELSE MESSAGE 'Asignación Exitosa' VIEW-AS ALERT-BOX INFORMATION.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Refrescar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Refrescar W-Win
ON CHOOSE OF BUTTON-Refrescar IN FRAME F-Main /* LIMPIAR HPKs A REASIGNAR */
DO:
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Carga-HPK.
    RUN Carga-Personal.

    {&OPEN-QUERY-BROWSE-PERSONAL}
    {&OPEN-QUERY-BROWSE-PHK}

    SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-PERSONAL
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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-reasignar-hpk-manual.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-reasignar-hpk-manual ).
       RUN set-position IN h_b-reasignar-hpk-manual ( 2.62 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-reasignar-hpk-manual ( 21.81 , 108.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv10.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = Multiple-Records':U ,
             OUTPUT h_p-updv10 ).
       RUN set-position IN h_p-updv10 ( 24.42 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv10 ( 1.42 , 41.72 ) NO-ERROR.

       /* Links to SmartBrowser h_b-reasignar-hpk-manual. */
       RUN add-link IN adm-broker-hdl ( h_p-updv10 , 'TableIO':U , h_b-reasignar-hpk-manual ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-reasignar-hpk-manual ,
             BUTTON-15:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv10 ,
             BROWSE-PERSONAL:HANDLE IN FRAME F-Main , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-HPK W-Win 
PROCEDURE Carga-HPK :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE t-Vtacdocu.
RUN Captura-Temporal IN h_b-reasignar-hpk-manual
    ( INPUT TABLE t-VtaCDocu).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Personal W-Win 
PROCEDURE Carga-Personal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    SESSION:SET-WAIT-STATE('GENERAL').

    /* Turnos */
    DEFINE VAR x-dia AS CHAR.
    DEFINE VAR x-dia-de-la-semana AS INT.
    DEFINE VAR x-nombre-picador AS CHAR.
    DEFINE VAR x-origen-picador AS CHAR.
    
    x-dia-de-la-semana = WEEKDAY(TODAY).
    IF x-dia-de-la-semana = 1 THEN x-dia = "Domingo".
    IF x-dia-de-la-semana = 2 THEN x-dia = "Lunes".
    IF x-dia-de-la-semana = 3 THEN x-dia = "Martes".
    IF x-dia-de-la-semana = 4 THEN x-dia = "Miercoles".
    IF x-dia-de-la-semana = 5 THEN x-dia = "Jueves".
    IF x-dia-de-la-semana = 6 THEN x-dia = "Viernes".
    IF x-dia-de-la-semana = 7 THEN x-dia = "Sabado".
    
    DEF VAR x-FlgSit AS CHAR INIT 'TI,TP' NO-UNDO.
    DEF VAR k AS INT NO-UNDO.
    
    EMPTY TEMP-TABLE tt-rut-pers-turno.
    FOR EACH rut-pers-turno WHERE rut-pers-turno.codcia = s-codcia AND
        rut-pers-turno.coddiv = s-coddiv AND
        rut-pers-turno.fchasignada = TODAY AND 
        rut-pers-turno.rol = 'PICADOR' NO-LOCK:
    
        CREATE tt-rut-pers-turno.
        BUFFER-COPY rut-pers-turno TO tt-rut-pers-turno.
        ASSIGN 
            tt-rut-pers-turno.hinicio = ""
            tt-rut-pers-turno.htermino = ""
            tt-rut-pers-turno.hefectivas = 0
            tt-rut-pers-turno.nombre-picador = ""
            tt-rut-pers-turno.origen-picador = "".
    
        /* Buscar Turno */
        FIND FIRST rut-turnos WHERE rut-turnos.codcia = s-codcia AND
                                    rut-turnos.coddiv = s-coddiv AND
                                    rut-turnos.turno = rut-pers-turno.turno AND 
                                    rut-turnos.dia = x-dia NO-LOCK NO-ERROR.
        IF AVAILABLE rut-turnos THEN DO:
            ASSIGN 
                tt-rut-pers-turno.hinicio = rut-turnos.horainicio
                tt-rut-pers-turno.htermino = rut-turnos.horafin
                tt-rut-pers-turno.hefectivas = 0.
        END.
        /* */
        RUN logis/p-busca-por-dni(INPUT tt-rut-pers-turno.dni, 
                                  OUTPUT x-nombre-picador,
                                  OUTPUT x-origen-picador).
        ASSIGN 
            tt-rut-pers-turno.nombre-picador = x-nombre-picador
            tt-rut-pers-turno.origen-picador = x-origen-picador.
    
        /* HPK e Items */
        ASSIGN
            tt-rut-pers-turno.hpks = 0
            tt-rut-pers-turno.items = 0.
        DO k = 1 TO NUM-ENTRIES(x-FlgSit):
            FOR EACH x-vtacdocu NO-LOCK WHERE x-vtacdocu.codcia = s-codcia AND
                x-vtacdocu.divdes = s-coddiv AND
                x-vtacdocu.usrsac = tt-rut-pers-turno.dni AND
                DATE(x-vtacdocu.fchinicio) >= ADD-INTERVAL(TODAY, -3, 'days'):
                IF NOT ( x-vtacdocu.flgest = 'P' AND
                         x-vtacdocu.codped = 'HPK' AND         
                         x-Vtacdocu.FlgSit = ENTRY(k, x-FlgSit) )
                    THEN NEXT.
                ASSIGN
                    tt-rut-pers-turno.hpks = tt-rut-pers-turno.hpks + 1
                    tt-rut-pers-turno.items = tt-rut-pers-turno.items + x-vtacdocu.items.
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
  ENABLE BUTTON-Refrescar BUTTON-15 BROWSE-PERSONAL 
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
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Personal.
  {&OPEN-QUERY-BROWSE-PERSONAL}
  SESSION:SET-WAIT-STATE('').

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
  {src/adm/template/snd-list.i "tt-rut-pers-turno"}
  {src/adm/template/snd-list.i "rut-pers-turno"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNombreOrigen W-Win 
FUNCTION fNombreOrigen RETURNS CHARACTER
  ( INPUT pDNI AS CHAR, INPUT pDato AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pNombre AS CHAR.
  DEF VAR pOrigen AS CHAR.

  RUN logis/p-busca-por-dni (VtaCDocu.UsrSac, OUTPUT pNombre, OUTPUT pOrigen).
  CASE pDato:
      WHEN 1 THEN RETURN pNombre.
      WHEN 2 THEN RETURN pOrigen.
  END CASE.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNroHPKs W-Win 
FUNCTION fNroHPKs RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF BUFFER B-CDOCU FOR Vtacdocu.

  DEF VAR k AS INT.
  FOR EACH B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = s-codcia AND
      B-CDOCU.coddiv = s-coddiv AND
      B-CDOCU.codped = 'HPK' AND
      B-CDOCU.flgest = 'P' AND
      LOOKUP(B-CDOCU.flgsit, 'TI,TP,TX') > 0 AND
      B-CDOCU.usrsac = rut-pers-turno.dni:
      k = k + 1.
  END.

  RETURN k.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNroItems W-Win 
FUNCTION fNroItems RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF BUFFER B-CDOCU FOR Vtacdocu.
  DEF BUFFER B-DDOCU FOR Vtaddocu.

  DEF VAR k AS INT.
  FOR EACH B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = s-codcia AND
      B-CDOCU.coddiv = s-coddiv AND
      B-CDOCU.codped = 'HPK' AND
      B-CDOCU.flgest = 'P' AND
      LOOKUP(B-CDOCU.flgsit, 'TI,TP,TX') > 0 AND
      B-CDOCU.usrsac = rut-pers-turno.dni,
      EACH B-DDOCU OF B-CDOCU NO-LOCK:
      k = k + 1.
  END.

  RETURN k.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

