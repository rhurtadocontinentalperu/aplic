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

DEF VAR x-UsrChq AS CHAR NO-UNDO.
DEF VAR x-UsrImpOD AS CHAR NO-UNDO.
DEF VAR x-FchImpOD AS DATETIME NO-UNDO.
DEF VAR x-FchPicking AS DATE INIT TODAY NO-UNDO.

&SCOPED-DEFINE Condicion VtaCDocu.CodCia = s-codcia ~
    AND VtaCDocu.DivDes = s-coddiv ~
    AND LOOKUP(VtaCDocu.CodPed, "O/D,OTR") > 0 ~
    AND VtaCDocu.FlgEst = "P" ~
    AND VtaCDocu.FlgSit = "T" ~
    AND Vtacdocu.FecSac = x-FchPicking

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
&Scoped-define INTERNAL-TABLES VtaCDocu

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 VtaCDocu.CodPed VtaCDocu.NroPed ~
VtaCDocu.FchPed VtaCDocu.Hora VtaCDocu.NomCli fNomPer() @ x-UsrImpOD ~
VtaCDocu.FecSac VtaCDocu.HorSac 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH VtaCDocu ~
      WHERE {&Condicion} NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH VtaCDocu ~
      WHERE {&Condicion} NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 VtaCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 VtaCDocu


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RADIO-SET-CodDoc FILL-IN-NroPed COMBO-BOX-2 ~
BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-CodDoc FILL-IN-NroPed ~
COMBO-BOX-2 

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


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-BOX-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Hoy" 
     LABEL "Del dìa de" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Hoy","Ayer" 
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroPed AS CHARACTER FORMAT "X(256)":U 
     LABEL "# de Sub-Orden" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-CodDoc AS CHARACTER INITIAL "O/D" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "SUB-ORDEN DE DESPACHO", "O/D",
"SUB-ORDEN DE TRANSFERENCIA", "OTR"
     SIZE 54 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      VtaCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      VtaCDocu.CodPed FORMAT "x(3)":U
      VtaCDocu.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U WIDTH 11.14
      VtaCDocu.FchPed COLUMN-LABEL "Fecha!Emisión" FORMAT "99/99/9999":U
      VtaCDocu.Hora FORMAT "X(5)":U WIDTH 5.57
      VtaCDocu.NomCli COLUMN-LABEL "Cliente" FORMAT "x(80)":U WIDTH 49.14
      fNomPer() @ x-UsrImpOD COLUMN-LABEL "Asignado a" FORMAT "x(60)":U
            WIDTH 33.29
      VtaCDocu.FecSac FORMAT "99/99/9999":U
      VtaCDocu.HorSac FORMAT "x(8)":U WIDTH 6.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 134 BY 20.96
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET-CodDoc AT ROW 1.19 COL 19 NO-LABEL WIDGET-ID 6
     FILL-IN-NroPed AT ROW 2.35 COL 17 COLON-ALIGNED WIDGET-ID 2
     COMBO-BOX-2 AT ROW 3.31 COL 17 COLON-ALIGNED WIDGET-ID 4
     BROWSE-2 AT ROW 4.65 COL 2 WIDGET-ID 200
     "Documento:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.38 COL 10 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.29 BY 25.85
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
         TITLE              = "ASIGNACION DE TAREAS - PICKING SUBORDENES"
         HEIGHT             = 25.85
         WIDTH              = 144.29
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

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 COMBO-BOX-2 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.VtaCDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   = INTEGRAL.VtaCDocu.CodPed
     _FldNameList[2]   > INTEGRAL.VtaCDocu.NroPed
"VtaCDocu.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.VtaCDocu.FchPed
"VtaCDocu.FchPed" "Fecha!Emisión" "99/99/9999" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtaCDocu.Hora
"VtaCDocu.Hora" ? ? "character" ? ? ? ? ? ? no ? no no "5.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.VtaCDocu.NomCli
"VtaCDocu.NomCli" "Cliente" "x(80)" "character" ? ? ? ? ? ? no ? no no "49.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fNomPer() @ x-UsrImpOD" "Asignado a" "x(60)" ? ? ? ? ? ? ? no ? no no "33.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.VtaCDocu.FecSac
"VtaCDocu.FecSac" ? "99/99/9999" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.VtaCDocu.HorSac
"VtaCDocu.HorSac" ? ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ASIGNACION DE TAREAS - PICKING SUBORDENES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ASIGNACION DE TAREAS - PICKING SUBORDENES */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-2 W-Win
ON VALUE-CHANGED OF COMBO-BOX-2 IN FRAME F-Main /* Del dìa de */
DO:
  ASSIGN {&SELF-NAME}.
  CASE {&SELF-NAME}:
      WHEN 'Hoy' THEN x-FchPicking = TODAY.
      WHEN 'Ayer' THEN x-FchPicking = TODAY - 1.
  END CASE.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroPed W-Win
ON LEAVE OF FILL-IN-NroPed IN FRAME F-Main /* # de Sub-Orden */
OR RETURN OF FILL-IN-NroPed DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.

    SELF:SCREEN-VALUE = REPLACE(SELF:SCREEN-VALUE,"'","-").    

    ASSIGN {&SELF-NAME}.    
    IF LENGTH(FILL-IN-NroPed) > 12 THEN DO:
        /* TRansformamos el número */
        FIND Facdocum WHERE Facdocum.codcia = s-codcia AND 
            Facdocum.codcta[8] = SUBSTRING(FILL-IN-NroPed,1,3)
            NO-LOCK NO-ERROR.
        IF AVAILABLE FacDocum THEN DO:
            /*MESSAGE SUBSTRING(FILL-IN-NroPed,1,3) Facdocum.coddoc.*/
            RADIO-SET-CodDoc = Facdocum.coddoc.
            FILL-IN-NroPed = SUBSTRING(FILL-IN-NroPed,4).
            DISPLAY FILL-IN-NroPed RADIO-SET-CodDoc WITH FRAME {&FRAME-NAME}.            
        END.
    END.
    ASSIGN FILL-IN-NroPed RADIO-SET-CodDoc.
    /* Buscamos Sub-Orden */
    FIND Vtacdocu WHERE Vtacdocu.codcia = s-codcia 
        AND Vtacdocu.codped = RADIO-SET-CodDoc
        AND Vtacdocu.nroped = FILL-IN-NroPed
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtacdocu THEN DO:
        MESSAGE 'Sub-Orden NO registrada ' RADIO-SET-CodDoc FILL-IN-NroPed VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    /*RD01- Verifica si la orden ya ha sido chequeado*/
    IF NOT (Vtacdocu.flgest = 'P' AND Vtacdocu.flgsit = 'T') THEN DO:
        MESSAGE 'Sub-Orden YA fue cerrada' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    IF VtaCDocu.FecSac <> ? THEN DO:
        MESSAGE 'Sub-Orden YA asignada para sacado' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    IF VtaCDocu.UsrImpOd = '' THEN DO:
        MESSAGE 'Sub-Orden aún NO ha sido impresa' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    IF Vtacdocu.DivDes <> s-CodDiv THEN DO:
        MESSAGE "NO tiene almacenes de despacho pertenecientes a esta división"
            VIEW-AS ALERT-BOX WARNING.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    /* Verificamos que esté bajo el control del supervisor */
    FIND PikSupervisores WHERE PikSupervisores.CodCia = s-codcia
        AND PikSupervisores.CodDiv = s-coddiv
        AND PikSupervisores.Usuario = s-user-id
        NO-LOCK NO-ERROR.
    IF AVAILABLE PikSupervisores THEN DO:
        IF LOOKUP(ENTRY(2,VtaCDocu.nroped,"-"),PikSupervisores.Sector) = 0 THEN DO:
            MESSAGE 'El supervisor NO tiene asignado este sector a su cargo'
                VIEW-AS ALERT-BOX ERROR.
            SELF:SCREEN-VALUE = ''.
            RETURN NO-APPLY.
        END.
    END.

    /* *************************************************** */
    RUN vta2\d-ASIGNA-picking-sub-ordenes ( ROWID(Vtacdocu),
                                            OUTPUT x-UsrChq).
    IF x-UsrChq <> "" THEN DO:
        RUN Cierre-de-guia.
        IF RETURN-VALUE = 'ADM-ERROR' 
            THEN MESSAGE 'NO se pudo Asignar la sub-orden' VIEW-AS ALERT-BOX ERROR.
    END.

    ASSIGN
        COMBO-BOX-2 = 'Hoy'
        FILL-IN-NroPed = ''.
    DISPLAY COMBO-BOX-2 FILL-IN-NroPed WITH FRAME {&FRAME-NAME}.
    APPLY 'VALUE-CHANGED':U TO COMBO-BOX-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-CodDoc W-Win
ON VALUE-CHANGED OF RADIO-SET-CodDoc IN FRAME F-Main
DO:
  ASSIGN {&SELF-NAME}.
  APPLY 'LEAVE':U TO  FILL-IN-NroPed.
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

  CICLO:
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND Vtacdocu WHERE Vtacdocu.codcia = s-codcia
          AND Vtacdocu.codped = RADIO-SET-CodDoc
          AND Vtacdocu.nroped = FILL-IN-NroPed
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Vtacdocu THEN UNDO, RETURN 'ADM-ERROR'.
      /* Volvemos a chequear las condiciones */
      IF NOT (Vtacdocu.flgest = 'P' AND Vtacdocu.flgsit = 'T') THEN DO:
          MESSAGE 'ERROR en la Sub-Orden' SKIP
              'Ya NO está pendiente de Pickeo'
              VIEW-AS ALERT-BOX ERROR.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      IF Vtacdocu.fecsac <> ? THEN DO:
          MESSAGE 'La Sub-Orden YA fue asignada al responsable con código:' Vtacdocu.usrsac
              VIEW-AS ALERT-BOX ERROR.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      ASSIGN 
          Vtacdocu.usrsac = x-usrchq
          Vtacdocu.fecsac = TODAY
          Vtacdocu.horsac = STRING(TIME,'HH:MM:SS')
          Vtacdocu.ubigeo[4] = x-UsrChq
          Vtacdocu.usrsacasign = s-user-id.

      /* Importes */
      RUN ue-get-cantidades(INPUT VtaCDocu.codped, INPUT VtaCDocu.nroped,
                             OUTPUT lItems, OUTPUT lImporte,
                             OUTPUT lPeso, OUTPUT lVolumen).

      /* Crear la Tarea asignada */
      CREATE Piktareas.
        ASSIGN  Piktareas.Codcia    = s-codcia
                Piktareas.Coddiv    = s-coddiv
                Piktareas.codped    = VtaCDocu.codped
                Piktareas.nroped    = VtaCDocu.nroped
                Piktareas.codper    = x-usrchq
                Piktareas.fchinicio = NOW
                Piktareas.usuarioinicio = s-user-id
                Piktareas.items     = lItems
                Piktareas.importe   = lImporte
                piktareas.peso      = lPeso
                Piktareas.volumen   = lVolumen.

        /* Marcar al trabajador como ocupado */
        FIND FIRST PikSacadores WHERE PikSacadores.codcia = s-codcia AND 
                                      PikSacadores.coddiv = s-coddiv AND 
                                      PikSacadores.codper = x-usrchq AND 
                                      PikSacadores.flgtarea = 'L' AND 
                                      PikSacadores.flgest = 'A' NO-ERROR.
        IF NOT AVAILABLE piksacadores THEN DO:
            RELEASE Piktareas.
            RELEASE piksacadores.
            MESSAGE 'Pickeador no esta disponible código:' x-usrchq
                VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        /* Si destinado a ese sector */
        IF LOOKUP(ENTRY(2,VtaCDocu.nroped,"-"),Piksacadores.sector) = 0 THEN DO:
            RELEASE Piktareas.
            RELEASE piksacadores.
            MESSAGE 'Pickeador no esta disponible para este SECTOR'
                VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        ASSIGN  piksacadores.flgtarea = 'O'.    /* OCUPADO */
  END.
  IF AVAILABLE Vtacdocu THEN RELEASE Vtacdocu.
  IF AVAILABLE Faccpedi THEN RELEASE Faccpedi.
  IF AVAILABLE Piktareas THEN RELEASE Piktareas.
  IF AVAILABLE piksacadores THEN RELEASE piksacadores.

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
  DISPLAY RADIO-SET-CodDoc FILL-IN-NroPed COMBO-BOX-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RADIO-SET-CodDoc FILL-IN-NroPed COMBO-BOX-2 BROWSE-2 
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
  {src/adm/template/snd-list.i "VtaCDocu"}

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
  
  FIND Pl-pers WHERE Pl-pers.codper = VtaCDocu.UsrSac NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Pl-pers THEN RETURN ''.
  RETURN TRIM(PL-PERS.patper) + ' ' + TRIM(PL-PERS.matper) + ', ' + PL-PERS.nomper.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

