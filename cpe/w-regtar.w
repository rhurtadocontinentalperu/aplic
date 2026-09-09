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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

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
&Scoped-define INTERNAL-TABLES CpeTareas Almacen PL-PERS VtaTabla

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 CpeTareas.NroTarea ~
VtaTabla.Llave_c2 CpeTareas.FchInicio CpeTareas.CodPer ~
fNomPer(cpetareas.CodPer) @ PL-PERS.nomper CpeTareas.CodArea ~
CpeTareas.NroOD CpeTareas.CodAlm Almacen.Descripcion CpeTareas.CodZona 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH CpeTareas ~
      WHERE CpeTareas.CodCia = s-codcia ~
 AND CpeTareas.CodDiv = s-coddiv ~
 AND CpeTareas.FlgEst = "P" NO-LOCK, ~
      EACH Almacen OF CpeTareas OUTER-JOIN NO-LOCK, ~
      EACH PL-PERS WHERE PL-PERS.codper = CpeTareas.CodPer NO-LOCK, ~
      EACH VtaTabla WHERE VtaTabla.CodCia = CpeTareas.CodCia ~
  AND VtaTabla.Llave_c1 = CpeTareas.TpoTarea ~
      AND VtaTabla.Tabla = "CPETAREA" NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH CpeTareas ~
      WHERE CpeTareas.CodCia = s-codcia ~
 AND CpeTareas.CodDiv = s-coddiv ~
 AND CpeTareas.FlgEst = "P" NO-LOCK, ~
      EACH Almacen OF CpeTareas OUTER-JOIN NO-LOCK, ~
      EACH PL-PERS WHERE PL-PERS.codper = CpeTareas.CodPer NO-LOCK, ~
      EACH VtaTabla WHERE VtaTabla.CodCia = CpeTareas.CodCia ~
  AND VtaTabla.Llave_c1 = CpeTareas.TpoTarea ~
      AND VtaTabla.Tabla = "CPETAREA" NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 CpeTareas Almacen PL-PERS VtaTabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 CpeTareas
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-4 Almacen
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-4 PL-PERS
&Scoped-define FOURTH-TABLE-IN-QUERY-BROWSE-4 VtaTabla


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-CodPer BUTTON-1 BtnDone ~
COMBO-BOX-Tarea FILL-IN-NroPed FILL-IN-Glosa COMBO-BOX-Almacen ~
COMBO-BOX-Zona BROWSE-4 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodPer FILL-IN-NomPer FILL-IN-Area ~
COMBO-BOX-Tarea FILL-IN-NroPed FILL-IN-Glosa COMBO-BOX-Almacen ~
COMBO-BOX-Zona 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNomPer W-Win 
FUNCTION fNomPer RETURNS CHARACTER
  ( INPUT pCodPer AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 8 BY 1.88 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/plus.ico":U
     LABEL "Button 1" 
     SIZE 8 BY 1.88 TOOLTIP "Registrar".

DEFINE VARIABLE COMBO-BOX-Almacen AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacen" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 41 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Tarea AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tarea" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 41 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Zona AS CHARACTER FORMAT "X(256)":U 
     LABEL "Zona" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 30 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Area AS CHARACTER FORMAT "X(256)":U 
     LABEL "Area" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPer AS CHARACTER FORMAT "X(6)":U 
     LABEL "Personal" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Glosa AS CHARACTER FORMAT "X(256)":U 
     LABEL "Observaciones a la O/D" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPer AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroPed AS CHARACTER FORMAT "X(9)":U 
     LABEL "Orden de Despacho" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      CpeTareas, 
      Almacen, 
      PL-PERS, 
      VtaTabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      CpeTareas.NroTarea COLUMN-LABEL "# Tarea" FORMAT ">>>>>>>>9":U
            WIDTH 5.43
      VtaTabla.Llave_c2 COLUMN-LABEL "Tarea" FORMAT "x(20)":U WIDTH 17.43
      CpeTareas.FchInicio COLUMN-LABEL "Fecha" FORMAT "99/99/9999 HH:MM:SS":U
            WIDTH 15.14
      CpeTareas.CodPer FORMAT "X(6)":U WIDTH 5.72
      fNomPer(cpetareas.CodPer) @ PL-PERS.nomper COLUMN-LABEL "Nombre" FORMAT "x(40)":U
      CpeTareas.CodArea FORMAT "x(8)":U WIDTH 5.14
      CpeTareas.NroOD COLUMN-LABEL "# O/D" FORMAT "x(9)":U WIDTH 8
      CpeTareas.CodAlm COLUMN-LABEL "Alm" FORMAT "x(3)":U
      Almacen.Descripcion FORMAT "X(40)":U
      CpeTareas.CodZona COLUMN-LABEL "Zona" FORMAT "x(8)":U WIDTH 6.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 131 BY 9.69
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodPer AT ROW 1 COL 19 COLON-ALIGNED WIDGET-ID 8
     BUTTON-1 AT ROW 1.27 COL 82 WIDGET-ID 24
     BtnDone AT ROW 1.27 COL 90 WIDGET-ID 22
     FILL-IN-NomPer AT ROW 1.81 COL 19 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-Area AT ROW 2.62 COL 19 COLON-ALIGNED WIDGET-ID 12
     COMBO-BOX-Tarea AT ROW 3.42 COL 19 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-NroPed AT ROW 4.23 COL 19 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-Glosa AT ROW 5.04 COL 19 COLON-ALIGNED WIDGET-ID 28
     COMBO-BOX-Almacen AT ROW 5.85 COL 19 COLON-ALIGNED WIDGET-ID 26
     COMBO-BOX-Zona AT ROW 6.65 COL 19 COLON-ALIGNED WIDGET-ID 20
     BROWSE-4 AT ROW 7.73 COL 3 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 135.14 BY 17
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
         TITLE              = "ASIGNACION DE TAREAS A LOS TRABAJADORES"
         HEIGHT             = 17
         WIDTH              = 135.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 135.14
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 135.14
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
/* BROWSE-TAB BROWSE-4 COMBO-BOX-Zona F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-Area IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPer IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "INTEGRAL.CpeTareas,INTEGRAL.Almacen OF INTEGRAL.CpeTareas,INTEGRAL.PL-PERS WHERE INTEGRAL.CpeTareas ...,INTEGRAL.VtaTabla WHERE INTEGRAL.CpeTareas ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", OUTER,,"
     _Where[1]         = "INTEGRAL.CpeTareas.CodCia = s-codcia
 AND INTEGRAL.CpeTareas.CodDiv = s-coddiv
 AND INTEGRAL.CpeTareas.FlgEst = ""P"""
     _JoinCode[3]      = "INTEGRAL.PL-PERS.codper = INTEGRAL.CpeTareas.CodPer"
     _JoinCode[4]      = "INTEGRAL.VtaTabla.CodCia = INTEGRAL.CpeTareas.CodCia
  AND INTEGRAL.VtaTabla.Llave_c1 = INTEGRAL.CpeTareas.TpoTarea"
     _Where[4]         = "INTEGRAL.VtaTabla.Tabla = ""CPETAREA"""
     _FldNameList[1]   > INTEGRAL.CpeTareas.NroTarea
"CpeTareas.NroTarea" "# Tarea" ? "integer" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.VtaTabla.Llave_c2
"VtaTabla.Llave_c2" "Tarea" "x(20)" "character" ? ? ? ? ? ? no ? no no "17.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.CpeTareas.FchInicio
"CpeTareas.FchInicio" "Fecha" ? "datetime" ? ? ? ? ? ? no ? no no "15.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.CpeTareas.CodPer
"CpeTareas.CodPer" ? ? "character" ? ? ? ? ? ? no ? no no "5.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fNomPer(cpetareas.CodPer) @ PL-PERS.nomper" "Nombre" "x(40)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.CpeTareas.CodArea
"CpeTareas.CodArea" ? ? "character" ? ? ? ? ? ? no ? no no "5.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.CpeTareas.NroOD
"CpeTareas.NroOD" "# O/D" ? "character" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.CpeTareas.CodAlm
"CpeTareas.CodAlm" "Alm" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   = INTEGRAL.Almacen.Descripcion
     _FldNameList[10]   > INTEGRAL.CpeTareas.CodZona
"CpeTareas.CodZona" "Zona" ? "character" ? ? ? ? ? ? no ? no no "6.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ASIGNACION DE TAREAS A LOS TRABAJADORES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ASIGNACION DE TAREAS A LOS TRABAJADORES */
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
    /* Consistencias */
    FIND pl-pers WHERE pl-pers.codper = FILL-IN-CodPer:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-pers THEN DO:
        MESSAGE 'Personal NO registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    FIND cpetrased WHERE cpetrased.CodCia = s-codcia
        AND cpetrased.CodDiv = s-coddiv
        AND cpetrased.CodPer = FILL-IN-CodPer:SCREEN-VALUE
        AND cpetrased.FlgEst = 'P'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cpetrased THEN DO:
        MESSAGE 'Trabajador NO registrado en la SEDE' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF CpeTraSed.FlgTarea <> 'L' THEN DO:
        MESSAGE 'El trabajador YA tiene una tarea asignada' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF COMBO-BOX-Tarea:SCREEN-VALUE = ? THEN DO:
        MESSAGE 'Seleccione la tarea que va a realizar' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    FIND Vtatabla WHERE VtaTabla.CodCia = s-codcia
        AND VtaTabla.Tabla = 'CPETAREA'
        AND VtaTabla.Llave_c1 = ENTRY (1, COMBO-BOX-Tarea:SCREEN-VALUE, ' - ')
        NO-LOCK.
    IF VtaTabla.Libre_c01 = 'Si' THEN DO:   /* Control de O/D */
        FIND faccpedi WHERE faccpedi.codcia = s-codcia
            AND faccpedi.coddoc = 'O/D'
            AND faccpedi.divdes = s-coddiv
            AND faccpedi.flgest = 'P'
            AND faccpedi.nroped = FILL-IN-NroPed:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE faccpedi THEN DO:
            MESSAGE 'Orden de Despacho NO válida' VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
    END.

    FIND FIRST Faccorre WHERE FacCorre.CodCia = s-codcia
        AND FacCorre.CodDiv = s-coddiv
        AND FacCorre.FlgEst = YES
        AND FacCorre.CodDoc = 'CPT'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccorre THEN DO:
        MESSAGE 'NO se ha definido en control de correlativos (CPT) para esta división' SKIP
            'Proceso abortado'
            VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    MESSAGE 'Confirme la asignación de la tarea' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.
    DEF VAR s-NroSer LIKE FacCorre.NroSer.
    s-NroSer = FacCorre.NroSer.
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        FIND CURRENT CpeTraSed EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE CpeTraSed THEN UNDO, RETURN NO-APPLY.

        {vtagn/i-faccorre-01.i &Codigo = 'CPT' &Serie = s-nroser}

        CREATE Cpetareas.
        ASSIGN
            CpeTareas.CodCia = s-codcia
            CpeTareas.CodDiv = s-coddiv
            CpeTareas.CodPer = CpeTraSed.CodPer
            CpeTareas.CodArea = CpeTraSed.CodArea
            CpeTareas.FlgEst = 'P'
            CpeTareas.NroTarea = FacCorre.Correlativo
            CpeTareas.TpoTarea = ENTRY(1, COMBO-BOX-Tarea:SCREEN-VALUE, ' - ')
            CpeTareas.FchInicio = DATETIME(TODAY, MTIME)
            CpeTareas.UsuarioReg = s-user-id.
        IF VtaTabla.Libre_c01 = 'Si' THEN DO:   /* Control de O/D */
            ASSIGN
                CpeTareas.NroOD = FILL-IN-NroPed:SCREEN-VALUE
                CpeTareas.Glosa = FILL-IN-Glosa:SCREEN-VALUE
                CpeTareas.CodAlm = ENTRY(1, COMBO-BOX-Almacen:SCREEN-VALUE, ' - ')
                CpeTareas.CodZona = ENTRY(1, COMBO-BOX-Zona:SCREEN-VALUE, ' - ').
        END.
        ASSIGN
            CpeTraSed.FlgTarea = 'O'.       /* Ocupado */
        ASSIGN
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
        /* Tracking de Tareas */
        CREATE CpeTrkTar.
        BUFFER-COPY CpeTareas TO CpeTrkTar.
        ASSIGN
            CpeTrkTar.Estado = 'Tarea Asignada'
            CpeTrkTar.Fecha = DATETIME(TODAY, MTIME)
            CpeTrkTar.Usuario = s-user-id.

        IF AVAILABLE(CpeTraSed) THEN RELEASE CpeTraSed.
        IF AVAILABLE(CpeTareas) THEN RELEASE CpeTareas.
        IF AVAILABLE(Faccorre) THEN RELEASE Faccorre.
        IF AVAILABLE(CpeTrkTar) THEN RELEASE CpeTrkTar.
    END.
    ASSIGN
        FILL-IN-CodPer:SCREEN-VALUE = ''
        COMBO-BOX-Almacen:SCREEN-VALUE = ''
        COMBO-BOX-Tarea:SCREEN-VALUE = ''
        COMBO-BOX-Zona:SCREEN-VALUE = ''
        FILL-IN-Area:SCREEN-VALUE = ''
        FILL-IN-CodPer:SCREEN-VALUE = '' 
        FILL-IN-Glosa:SCREEN-VALUE = ''
        FILL-IN-NomPer:SCREEN-VALUE = ''
        FILL-IN-NroPed:SCREEN-VALUE = ''.

    {&OPEN-QUERY-{&BROWSE-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Almacen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Almacen W-Win
ON VALUE-CHANGED OF COMBO-BOX-Almacen IN FRAME F-Main /* Almacen */
DO:
    REPEAT WHILE COMBO-BOX-Zona:NUM-ITEMS > 0:
      COMBO-BOX-Zona:DELETE(1).
    END.
    FOR EACH Almtzona NO-LOCK WHERE Almtzona.codcia = s-codcia
        AND Almtzona.codalm = ENTRY(1, SELF:SCREEN-VALUE, ' - '):
        COMBO-BOX-Zona:ADD-LAST(AlmtZona.CodZona + ' - ' + AlmtZona.DesZona).
        COMBO-BOX-Zona:SCREEN-VALUE = AlmtZona.CodZona + ' - ' + AlmtZona.DesZona.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodPer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPer W-Win
ON LEAVE OF FILL-IN-CodPer IN FRAME F-Main /* Personal */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND pl-pers WHERE pl-pers.codper = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE pl-pers THEN DO:
      FILL-IN-NomPer:SCREEN-VALUE = fNomPer(SELF:SCREEN-VALUE).
      FIND cpetrased WHERE cpetrased.CodCia = s-codcia
          AND cpetrased.CodDiv = s-coddiv
          AND cpetrased.CodPer = FILL-IN-CodPer:SCREEN-VALUE
          AND cpetrased.FlgEst = 'P'
          NO-LOCK NO-ERROR.
      IF AVAILABLE cpetrased THEN DO:
          FIND Almtabla WHERE Almtabla.Tabla = 'AS'
              AND almtabla.Codigo = cpetrased.CodArea
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almtabla THEN FILL-IN-Area:SCREEN-VALUE = almtabla.Nombre.
      END.
      ELSE DO:
          MESSAGE 'Trabajador NO registrado en la SEDE' VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroPed W-Win
ON LEAVE OF FILL-IN-NroPed IN FRAME F-Main /* Orden de Despacho */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND faccpedi WHERE faccpedi.codcia = s-codcia
      AND faccpedi.coddoc = 'O/D'
      AND faccpedi.divdes = s-coddiv
      AND faccpedi.flgest = 'P'
      AND faccpedi.nroped = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE faccpedi THEN DO:
      MESSAGE 'Orden de Despacho NO válida' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  /* Almacenes de despacho */
  REPEAT WHILE COMBO-BOX-Almacen:NUM-ITEMS > 0:
    COMBO-BOX-Almacen:DELETE(1).
  END.
  FOR EACH facdpedi OF faccpedi NO-LOCK,
      FIRST Almacen NO-LOCK WHERE Almacen.codcia = facdpedi.codcia
      AND Almacen.codalm = facdpedi.almdes
      BREAK BY facdpedi.almdes:
      IF FIRST-OF(facdpedi.almdes) THEN DO:
          COMBO-BOX-Almacen:ADD-LAST(almacen.codalm + ' - '+ Almacen.Descripcion).
          COMBO-BOX-Almacen:SCREEN-VALUE = almacen.codalm + ' - '+ Almacen.Descripcion.
      END.
  END.
  APPLY 'VALUE-CHANGED' TO COMBO-BOX-Almacen.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
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
  DISPLAY FILL-IN-CodPer FILL-IN-NomPer FILL-IN-Area COMBO-BOX-Tarea 
          FILL-IN-NroPed FILL-IN-Glosa COMBO-BOX-Almacen COMBO-BOX-Zona 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-CodPer BUTTON-1 BtnDone COMBO-BOX-Tarea FILL-IN-NroPed 
         FILL-IN-Glosa COMBO-BOX-Almacen COMBO-BOX-Zona BROWSE-4 
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
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH Vtatabla NO-LOCK WHERE VtaTabla.CodCia = s-codcia
          AND VtaTabla.Tabla = 'CPETAREA':
          COMBO-BOX-Tarea:ADD-LAST(VtaTabla.Llave_c1 + ' - ' + VtaTabla.Llave_c2).
      END.
  END.

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
  {src/adm/template/snd-list.i "CpeTareas"}
  {src/adm/template/snd-list.i "Almacen"}
  {src/adm/template/snd-list.i "PL-PERS"}
  {src/adm/template/snd-list.i "VtaTabla"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNomPer W-Win 
FUNCTION fNomPer RETURNS CHARACTER
  ( INPUT pCodPer AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 
  FIND pl-pers WHERE pl-pers.codper = pCodPer NO-LOCK NO-ERROR.
  IF AVAILABLE pl-pers 
      THEN RETURN TRIM(pl-pers.patper) + ' ' + TRIM(pl-pers.matper) + ', ' + pl-pers.nomper.
    ELSE RETURN ''.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

