&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-ChkTareas NO-UNDO LIKE ChkTareas
       field tCrossdocking as log
       field tDestino as char
       field tDestinofinal as char
       field tNroItems as int
       field tFchent as date.



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
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR x-codper AS CHAR INIT "".
DEFINE VAR x-mesa AS CHAR.
/* --- */
DEFINE VAR x-fecha-logeo AS DATE.
DEFINE VAR x-hora-logeo AS CHAR.


/* Segun usuario de progress ubicar el codigo de personal */
FIND FIRST gn-users WHERE gn-users.codcia = s-codcia AND 
                        gn-users.USER-ID = s-user-id NO-LOCK NO-ERROR.

IF NOT AVAILABLE gn-users THEN DO:
    MESSAGE "El usuario " + s-user-id + " fue imposible ubicar el codigo de personal".
    RETURN ERROR.
END.

x-codper = gn-users.codper.
IF TRUE <> (x-codper > "") THEN DO:
    MESSAGE "El usuario " + s-user-id + " fue imposible conocer su codigo de trabajador".
    RETURN ERROR.
END.
/*
x-codper = '006178'.
*/

/* buscarlo si existe en la maestra de personal */
FIND FIRST pl-pers WHERE  pl-pers.codper = x-codper NO-LOCK NO-ERROR.
IF NOT AVAILABLE pl-pers THEN DO:
    MESSAGE "El codigo de trabajador " + x-codper + " NO exsite en personal".
    RETURN ERROR.
END.

/* Verificar si tiene mesa asignada */
FIND FIRST ChkChequeador WHERE ChkChequeador.codcia = s-codcia AND 
                                ChkChequeador.coddiv = s-coddiv AND 
                                ChkChequeador.codper = x-codper AND
                                ChkChequeador.flgest = 'A' NO-LOCK NO-ERROR.
IF NOT AVAILABLE ChkChequeador THEN DO:
    MESSAGE "El trabajador " + x-codper + " no tiene mesa asignada".
    RETURN ERROR.
END.

x-fecha-logeo = ChkChequeador.fchasignacion.
x-hora-logeo =  ChkChequeador.horasignacion.

x-mesa = ChkChequeador.mesa.

/**/
DEFINE VAR x-tCrossdocking as CHAR.
DEFINE VAR x-tDestino as char.
DEFINE VAR x-tDestinoFinal as char.
DEFINE VAR x-tNroItems as int.
DEFINE VAR x-tFchent as date.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-10

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ChkTareas

/* Definitions for BROWSE BROWSE-10                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-10 ~
if (tt-ChkTareas.tCrossDocking = yes) then "SI" else "NO" @ x-tcrossdocking ~
tt-ChkTareas.CodDoc tt-ChkTareas.NroPed tDestino @ x-tdestino ~
tDestinoFinal @ x-tDestinoFinal tNroItems @ x-tNroItems ~
tt-ChkTareas.Prioridad tt-ChkTareas.Embalaje tFchEnt @ x-tfchent 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-10 
&Scoped-define QUERY-STRING-BROWSE-10 FOR EACH tt-ChkTareas NO-LOCK ~
    BY tt-ChkTareas.UsuarioFin ~
       BY tt-ChkTareas.FechaFin INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-10 OPEN QUERY BROWSE-10 FOR EACH tt-ChkTareas NO-LOCK ~
    BY tt-ChkTareas.UsuarioFin ~
       BY tt-ChkTareas.FechaFin INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-10 tt-ChkTareas
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-10 tt-ChkTareas


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-10}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-5 BROWSE-10 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-chequeador FILL-IN-mesa ~
FILL-IN-ordenes FILL-IN-tiempo FILL-IN-items 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-5 
     LABEL "Refrescar" 
     SIZE 15 BY .96.

DEFINE VARIABLE FILL-IN-chequeador AS CHARACTER FORMAT "X(60)":U 
     LABEL "Chequeador" 
     VIEW-AS FILL-IN 
     SIZE 73 BY 1
     BGCOLOR 15 FGCOLOR 9 FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-items AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "ITEMS CHEQUEADAS DESDE EL LOGEO" 
     VIEW-AS FILL-IN 
     SIZE 7.57 BY 1
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-mesa AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY 1
     BGCOLOR 15 FGCOLOR 12 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-ordenes AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "ORDENES CHEQUEADAS DESDE EL LOGEO" 
     VIEW-AS FILL-IN 
     SIZE 7.57 BY 1
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-tiempo AS CHARACTER FORMAT "X(20)":U 
     LABEL "TIEMPO TRANSCURRIDO DESDE EL LOGEO" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY 1
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-10 FOR 
      tt-ChkTareas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-10 W-Win _STRUCTURED
  QUERY BROWSE-10 NO-LOCK DISPLAY
      if (tt-ChkTareas.tCrossDocking = yes) then "SI" else "NO" @ x-tcrossdocking COLUMN-LABEL "CrossDocking"
      tt-ChkTareas.CodDoc COLUMN-LABEL "Doc." FORMAT "x(3)":U
      tt-ChkTareas.NroPed COLUMN-LABEL "Orden" FORMAT "X(12)":U
      tDestino @ x-tdestino COLUMN-LABEL "Destino" FORMAT "x(40)":U
            WIDTH 30 COLUMN-FONT 7
      tDestinoFinal @ x-tDestinoFinal COLUMN-LABEL "Destino Final" FORMAT "x(15)":U
            WIDTH 15.57
      tNroItems @ x-tNroItems COLUMN-LABEL "Items" FORMAT ">>>9":U
            WIDTH 6.72
      tt-ChkTareas.Prioridad FORMAT "x(8)":U
      tt-ChkTareas.Embalaje FORMAT "SI/NO":U WIDTH 12.72
      tFchEnt @ x-tfchent COLUMN-LABEL "Entrega" FORMAT "99/99/9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 120.43 BY 14.73 ROW-HEIGHT-CHARS .58 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-chequeador AT ROW 1.42 COL 12 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-mesa AT ROW 1.46 COL 89.14 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     BUTTON-5 AT ROW 2.54 COL 63 WIDGET-ID 14
     FILL-IN-ordenes AT ROW 2.62 COL 42.43 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-tiempo AT ROW 3.54 COL 101.86 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-items AT ROW 3.69 COL 42.43 COLON-ALIGNED WIDGET-ID 8
     BROWSE-10 AT ROW 4.88 COL 2.57 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 123 BY 19 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-ChkTareas T "?" NO-UNDO INTEGRAL ChkTareas
      ADDITIONAL-FIELDS:
          field tCrossdocking as log
          field tDestino as char
          field tDestinofinal as char
          field tNroItems as int
          field tFchent as date
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Inicio del Chequeo"
         HEIGHT             = 19
         WIDTH              = 123
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
/* BROWSE-TAB BROWSE-10 FILL-IN-items F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-chequeador IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-items IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-mesa IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ordenes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-tiempo IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-10
/* Query rebuild information for BROWSE BROWSE-10
     _TblList          = "Temp-Tables.tt-ChkTareas"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.tt-ChkTareas.UsuarioFin|yes,Temp-Tables.tt-ChkTareas.FechaFin|yes"
     _FldNameList[1]   > "_<CALC>"
"if (tt-ChkTareas.tCrossDocking = yes) then ""SI"" else ""NO"" @ x-tcrossdocking" "CrossDocking" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-ChkTareas.CodDoc
"tt-ChkTareas.CodDoc" "Doc." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-ChkTareas.NroPed
"tt-ChkTareas.NroPed" "Orden" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"tDestino @ x-tdestino" "Destino" "x(40)" ? ? ? 7 ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"tDestinoFinal @ x-tDestinoFinal" "Destino Final" "x(15)" ? ? ? ? ? ? ? no ? no no "15.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"tNroItems @ x-tNroItems" "Items" ">>>9" ? ? ? ? ? ? ? no ? no no "6.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = Temp-Tables.tt-ChkTareas.Prioridad
     _FldNameList[8]   > Temp-Tables.tt-ChkTareas.Embalaje
"tt-ChkTareas.Embalaje" ? ? "logical" ? ? ? ? ? ? no ? no no "12.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"tFchEnt @ x-tfchent" "Entrega" "99/99/9999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-10 */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME F-Main:HANDLE
       ROW             = 14.85
       COLUMN          = 109
       HEIGHT          = 3.85
       WIDTH           = 14.29
       WIDGET-ID       = 12
       HIDDEN          = yes
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */
      CtrlFrame:MOVE-AFTER(BROWSE-10:HANDLE IN FRAME F-Main).

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Inicio del Chequeo */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Inicio del Chequeo */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-10
&Scoped-define SELF-NAME BROWSE-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-10 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-10 IN FRAME F-Main
DO:
    IF NOT AVAILABLE tt-Chktareas THEN RETURN NO-APPLY.

    DEFINE VAR x-coddoc AS CHAR.
    DEFINE VAR x-orden AS CHAR.
    DEFINE VAR x-chequeador AS CHAR.
    DEFINE VAR x-prioridad AS CHAR.
    DEFINE VAR x-embalado AS CHAR.
    DEFINE VAR x-mesa AS CHAR.

    DEFINE VAR x-procesado AS LOG INIT NO.
    DEFINE VAR x-items AS INT INIT 0.
  
    MESSAGE 'Seguro de empezar la Orden ' + tt-ChkTareas.coddoc + "-" + tt-ChkTareas.nroped VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.

    ASSIGN FILL-IN-chequeador.

    x-coddoc = tt-ChkTareas.coddoc.
    x-orden = tt-ChkTareas.nroped.
    x-mesa = tt-ChkTareas.mesa.

    /* Verifico que la tarea este Pendiente */
    FIND FIRST ChkTareas WHERE ChkTareas.codcia = s-codcia AND 
                                ChkTareas.coddiv = s-coddiv AND 
                                ChkTareas.mesa = x-mesa AND 
                                ChkTareas.coddoc = x-coddoc AND 
                                ChkTareas.nroped = x-orden AND 
                                ChkTareas.flgest = 'P' NO-LOCK NO-ERROR.

    IF NOT AVAILABLE ChkTareas THEN DO:
        MESSAGE "La orden NO esta pendiente en Tareas".
        RETURN NO-APPLY.
    END.
    
    x-chequeador = FILL-IN-chequeador.
    x-prioridad = tt-ChkTareas.prioridad.
    x-embalado = IF(tt-Chktareas.Embalaje = YES) THEN "SI" ELSE "NO".

    RUN dist/d-chequeo-de-ordenes.r (INPUT x-coddoc, INPUT x-orden,
                                     INPUT x-chequeador, INPUT x-codper,
                                     INPUT x-prioridad, INPUT x-embalado, INPUT x-mesa,
                                     OUTPUT x-procesado, OUTPUT x-items) NO-ERROR.
    IF x-procesado = YES THEN DO:
        /* Refrescar */
        RUN cargar-temporal.

        {&OPEN-QUERY-BROWSE-10}

    END.
    ELSE DO:
        FIND CURRENT ChkTareas EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE ChkTareas THEN DO:
            ASSIGN ChkTareas.flgest = 'P'.
        END.
        /**/
        FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND 
                                faccpedi.coddoc = x-Coddoc AND 
                                faccpedi.nroped = x-Orden
                                EXCLUSIVE-LOCK NO-ERROR.

        IF AVAILABLE faccpedi THEN DO:
            ASSIGN faccpedi.flgsit = 'PT'.
        END.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Refrescar */
DO:
    RUN cargar-temporal.

    {&OPEN-QUERY-BROWSE-10}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame W-Win OCX.Tick
PROCEDURE CtrlFrame.PSTimer.Tick .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-tiempo AS CHAR.

x-Tiempo = ''.

RUN lib/_time-passed ( DATETIME(STRING(x-fecha-logeo,"99/99/9999") + ' ' + x-hora-logeo),
                         DATETIME(STRING(TODAY,"99/99/9999") + ' ' + STRING(TIME,"HH:MM:SS")), OUTPUT x-Tiempo).


fill-in-tiempo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-tiempo.

END PROCEDURE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-temporal W-Win 
PROCEDURE cargar-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-ChkTareas.    
    
SESSION:SET-WAIT-STATE('GENERAL').

FOR EACH ChkTareas WHERE ChkTareas.codcia = s-codcia AND 
                            ChkTareas.coddiv = s-coddiv AND 
                            ChkTareas.mesa = x-mesa AND 
                            ChkTareas.flgest = 'P' NO-LOCK:

    /* El Control */
    FIND FIRST ChkControl WHERE ChkControl.codcia = s-codcia AND 
                                ChkControl.coddiv = s-coddiv AND 
                                ChkControl.coddoc = ChkTarea.coddoc AND 
                                ChkControl.nroped = ChkTarea.nroped AND
                                ChkControl.flgest = 'T' NO-LOCK NO-ERROR.
    IF AVAILABLE ChkControl THEN DO:
        CREATE tt-ChkTareas.
        BUFFER-COPY ChkTareas TO tt-ChkTareas.
        ASSIGN tCrossdocking = ChkControl.crossdocking                
                tDestinoFinal = ChkControl.almacenXD
                tNroItems = ChkControl.nroitems
                tt-ChkTareas.UsuarioFin = IF(ChkTareas.prioridad = "Urgente") THEN "000000" ELSE "111111"
                tFchent = TODAY.
        /*  */
        FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                                    faccpedi.coddoc = ChkTarea.coddoc AND 
                                    faccpedi.nroped = ChkTarea.nroped NO-LOCK NO-ERROR.
        IF AVAILABLE faccpedi THEN DO:
            ASSIGN tDestino = if(ChkTarea.coddoc = 'O/D') THEN "CLIENTE" ELSE faccpedi.codcli
                    tFchent = faccpedi.fchent
                    tt-ChkTareas.fechafin = faccpedi.fchent.
            IF (ChkTarea.coddoc = 'OTR') THEN DO:
                FIND FIRST almacen WHERE almacen.codcia = s-codcia AND 
                                            almacen.codalm = faccpedi.codcli 
                                            NO-LOCK NO-ERROR.
                IF AVAILABLE almacen THEN tDestino = tDestino + " " + almacen.descripcion.
            END.
        END.
        /* Verificar que hay que mostrar aca cuando es Crossdocking, ya me olvide.... */
        FIND FIRST almacen WHERE almacen.codcia = s-codcia AND 
                                    almacen.codalm = ChkControl.almacenXD 
                                    NO-LOCK NO-ERROR.
        IF AVAILABLE almacen THEN tDestinoFinal = tDestinoFinal + " " + almacen.descripcion.

    END. 
END.
SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load W-Win  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "w-inicio-chequeo.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
  .
  RUN DISPATCH IN THIS-PROCEDURE("initialize-controls":U) NO-ERROR.
END.
ELSE MESSAGE "w-inicio-chequeo.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

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
  DISPLAY FILL-IN-chequeador FILL-IN-mesa FILL-IN-ordenes FILL-IN-tiempo 
          FILL-IN-items 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-5 BROWSE-10 
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
    FILL-in-chequeador:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(pl-pers.patper) + " " + 
                        TRIM(pl-pers.matper) + " " + TRIM(pl-pers.nomper).

    fill-in-mesa:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "   " + x-mesa.

    RUN cargar-temporal.

    {&OPEN-QUERY-BROWSE-10}


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
  {src/adm/template/snd-list.i "tt-ChkTareas"}

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

