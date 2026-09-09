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
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR x-sku-faltantes-col AS INT.
DEFINE VAR x-tiempo-observado-col AS CHAR.
DEFINE VAR x-cantidad-observada-col AS DEC.
DEFINE VAR x-nom-chequeador-col AS CHAR.

DEFINE VAR x-codped AS CHAR.
DEFINE VAR x-nroped AS CHAR.

&SCOPED-DEFINE CONDICION ( ~
            INTEGRAL.vtaddoc.CodCia = s-codcia AND ~
            INTEGRAL.vtaddocu.Codped = x-codped AND ~
            INTEGRAL.vtaddocu.Nroped = x-nroped AND ~
            INTEGRAL.vtaddocu.libre_c04 <> "" )

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-14

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ChkTareas FacCPedi VtaDDocu Almmmatg

/* Definitions for BROWSE BROWSE-14                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-14 ChkTareas.CodDoc ChkTareas.NroPed ~
FacCPedi.NomCli ~
sku-faltantes(chktareas.coddoc, chktareas.nroped) @ x-sku-faltantes-col ~
ChkTareas.Mesa ~
chequeador(chktareas.coddoc, chktareas.nroped) @ x-nom-chequeador-col ~
tiempo-observado(chktareas.fechainicio, chktareas.horainicio) @ x-tiempo-observado-col 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-14 
&Scoped-define QUERY-STRING-BROWSE-14 FOR EACH ChkTareas ~
      WHERE ChkTareas.codcia = s-codcia and ~
ChkTareas.FlgEst = 'O' NO-LOCK, ~
      EACH FacCPedi WHERE FacCPedi.CodCia  =  ChkTareas.CodCia and ~
 FacCPedi.CodDoc =  ChkTareas.CodDoc and ~
 FacCPedi.NroPed =  ChkTareas.NroPed NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-14 OPEN QUERY BROWSE-14 FOR EACH ChkTareas ~
      WHERE ChkTareas.codcia = s-codcia and ~
ChkTareas.FlgEst = 'O' NO-LOCK, ~
      EACH FacCPedi WHERE FacCPedi.CodCia  =  ChkTareas.CodCia and ~
 FacCPedi.CodDoc =  ChkTareas.CodDoc and ~
 FacCPedi.NroPed =  ChkTareas.NroPed NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-14 ChkTareas FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-14 ChkTareas
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-14 FacCPedi


/* Definitions for BROWSE BROWSE-15                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-15 VtaDDocu.CodMat Almmmatg.DesMat ~
cantidad-observada(vtaddocu.canped, vtaddocu.canpick) @ x-cantidad-observada-col ~
VtaDDocu.Libre_c04 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-15 
&Scoped-define QUERY-STRING-BROWSE-15 FOR EACH VtaDDocu ~
      WHERE {&CONDICION} NO-LOCK, ~
      EACH Almmmatg WHERE Almmmatg.CodCia =  VtaDDocu.CodCia AND ~
 Almmmatg.codmat  =  VtaDDocu.CodMat NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-15 OPEN QUERY BROWSE-15 FOR EACH VtaDDocu ~
      WHERE {&CONDICION} NO-LOCK, ~
      EACH Almmmatg WHERE Almmmatg.CodCia =  VtaDDocu.CodCia AND ~
 Almmmatg.codmat  =  VtaDDocu.CodMat NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-15 VtaDDocu Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-15 VtaDDocu
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-15 Almmmatg


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-14}~
    ~{&OPEN-QUERY-BROWSE-15}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-14 BROWSE-15 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cantidad-observada W-Win 
FUNCTION cantidad-observada RETURNS DECIMAL
  (INPUT pQtyTotal AS DEC, INPUT pQtyPick AS DEC )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD chequeador W-Win 
FUNCTION chequeador RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroPed AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD sku-faltantes W-Win 
FUNCTION sku-faltantes RETURNS INTEGER
  ( INPUT pCodDoc AS CHAR, INPUT pNrodoc AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tiempo-observado W-Win 
FUNCTION tiempo-observado RETURNS CHARACTER
  ( INPUT pFecha AS DATE, INPUT pHora AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-14 FOR 
      ChkTareas, 
      FacCPedi SCROLLING.

DEFINE QUERY BROWSE-15 FOR 
      VtaDDocu, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-14 W-Win _STRUCTURED
  QUERY BROWSE-14 NO-LOCK DISPLAY
      ChkTareas.CodDoc COLUMN-LABEL "Cod." FORMAT "x(3)":U WIDTH 7.43
            COLUMN-FONT 0
      ChkTareas.NroPed COLUMN-LABEL "Nro.Orden" FORMAT "X(12)":U
            WIDTH 9.43 COLUMN-FONT 0
      FacCPedi.NomCli COLUMN-LABEL "Nombre Cliente" FORMAT "x(50)":U
            WIDTH 37.86 COLUMN-FONT 0
      sku-faltantes(chktareas.coddoc, chktareas.nroped) @ x-sku-faltantes-col COLUMN-LABEL "SKU faltantes" FORMAT ">>,>>9":U
            COLUMN-FONT 0
      ChkTareas.Mesa COLUMN-LABEL "Mesa de Chequeo" FORMAT "x(8)":U
            WIDTH 16.43 COLUMN-FONT 0
      chequeador(chktareas.coddoc, chktareas.nroped) @ x-nom-chequeador-col COLUMN-LABEL "Chequeador" FORMAT "x(40)":U
            WIDTH 20 COLUMN-FONT 0
      tiempo-observado(chktareas.fechainicio, chktareas.horainicio) @ x-tiempo-observado-col COLUMN-LABEL "Tiempo Observado" FORMAT "x(25)":U
            WIDTH 19.72 COLUMN-FONT 0
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 129 BY 7.31
         TITLE "Ordenes Observadas" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-15
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-15 W-Win _STRUCTURED
  QUERY BROWSE-15 NO-LOCK DISPLAY
      VtaDDocu.CodMat COLUMN-LABEL "Cod.SKU" FORMAT "X(6)":U COLUMN-FONT 0
      Almmmatg.DesMat FORMAT "X(45)":U COLUMN-FONT 0
      cantidad-observada(vtaddocu.canped, vtaddocu.canpick) @ x-cantidad-observada-col COLUMN-LABEL "Cant.Obsv" FORMAT "->>,>>>,>>9.99":U
      VtaDDocu.Libre_c04 COLUMN-LABEL "Incidencia" FORMAT "x(25)":U
            WIDTH 15.72 COLUMN-FONT 0
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 83 BY 10.58
         TITLE "Detalle" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-14 AT ROW 1.77 COL 2 WIDGET-ID 200
     BROWSE-15 AT ROW 9.27 COL 2 WIDGET-ID 300
     "DoubleClick en Orden - Cerrar observacion" VIEW-AS TEXT
          SIZE 40.43 BY .96 AT ROW 9.31 COL 89.57 WIDGET-ID 4
          FGCOLOR 12 FONT 11
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 131.43 BY 19.15 WIDGET-ID 100.


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
         TITLE              = "Gestion de Observaciones"
         HEIGHT             = 19.15
         WIDTH              = 131.43
         MAX-HEIGHT         = 24.12
         MAX-WIDTH          = 173.86
         VIRTUAL-HEIGHT     = 24.12
         VIRTUAL-WIDTH      = 173.86
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
/* BROWSE-TAB BROWSE-14 1 F-Main */
/* BROWSE-TAB BROWSE-15 BROWSE-14 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-14
/* Query rebuild information for BROWSE BROWSE-14
     _TblList          = "INTEGRAL.ChkTareas,INTEGRAL.FacCPedi WHERE INTEGRAL.ChkTareas ..."
     _Options          = "NO-LOCK"
     _Where[1]         = "ChkTareas.codcia = s-codcia and
ChkTareas.FlgEst = 'O'"
     _JoinCode[2]      = "FacCPedi.CodCia  =  ChkTareas.CodCia and
 FacCPedi.CodDoc =  ChkTareas.CodDoc and
 FacCPedi.NroPed =  ChkTareas.NroPed"
     _FldNameList[1]   > INTEGRAL.ChkTareas.CodDoc
"ChkTareas.CodDoc" "Cod." ? "character" ? ? 0 ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.ChkTareas.NroPed
"ChkTareas.NroPed" "Nro.Orden" ? "character" ? ? 0 ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" "Nombre Cliente" ? "character" ? ? 0 ? ? ? no ? no no "37.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"sku-faltantes(chktareas.coddoc, chktareas.nroped) @ x-sku-faltantes-col" "SKU faltantes" ">>,>>9" ? ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.ChkTareas.Mesa
"ChkTareas.Mesa" "Mesa de Chequeo" ? "character" ? ? 0 ? ? ? no ? no no "16.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"chequeador(chktareas.coddoc, chktareas.nroped) @ x-nom-chequeador-col" "Chequeador" "x(40)" ? ? ? 0 ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"tiempo-observado(chktareas.fechainicio, chktareas.horainicio) @ x-tiempo-observado-col" "Tiempo Observado" "x(25)" ? ? ? 0 ? ? ? no ? no no "19.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-14 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-15
/* Query rebuild information for BROWSE BROWSE-15
     _TblList          = "INTEGRAL.VtaDDocu,INTEGRAL.Almmmatg WHERE INTEGRAL.VtaDDocu ..."
     _Options          = "NO-LOCK"
     _Where[1]         = "{&CONDICION}"
     _JoinCode[2]      = "Almmmatg.CodCia =  VtaDDocu.CodCia AND
 Almmmatg.codmat  =  VtaDDocu.CodMat"
     _FldNameList[1]   > INTEGRAL.VtaDDocu.CodMat
"VtaDDocu.CodMat" "Cod.SKU" ? "character" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? ? "character" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"cantidad-observada(vtaddocu.canped, vtaddocu.canpick) @ x-cantidad-observada-col" "Cant.Obsv" "->>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtaDDocu.Libre_c04
"VtaDDocu.Libre_c04" "Incidencia" "x(25)" "character" ? ? 0 ? ? ? no ? no no "15.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-15 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Gestion de Observaciones */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Gestion de Observaciones */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-14
&Scoped-define SELF-NAME BROWSE-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-14 W-Win
ON ENTRY OF BROWSE-14 IN FRAME F-Main /* Ordenes Observadas */
DO:
    x-codped = "".
    x-nroped = "".
    browse-15:TITLE = "".
    IF AVAILABLE chktareas THEN DO:
          x-codped = 'X' + chktareas.coddoc.
          x-nroped = chktareas.nroped.

          browse-15:TITLE = chktareas.coddoc + " " + x-nroped + " " + faccpedi.nomcli.
    END.

    {&open-query-browse-15}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-14 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-14 IN FRAME F-Main /* Ordenes Observadas */
DO:
  IF AVAILABLE chktareas THEN DO:
        MESSAGE "Seguro de Cerrar la Observacion (" + chktareas.coddoc + "-" + chktareas.nroped  + ") ?" VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.
    
    RUN actualizar-orden.

  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-14 W-Win
ON VALUE-CHANGED OF BROWSE-14 IN FRAME F-Main /* Ordenes Observadas */
DO:
  x-codped = "".
  x-nroped = "".

  browse-15:TITLE = "".

  IF AVAILABLE chktareas THEN DO:
        x-codped = 'X' + chktareas.coddoc.
        x-nroped = chktareas.nroped.

        browse-15:TITLE = chktareas.coddoc + " " + x-nroped + " " + faccpedi.nomcli.
  END.

  

  {&open-query-browse-15}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE actualizar-orden W-Win 
PROCEDURE actualizar-orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-ProcesoOK AS CHAR.

DEFINE BUFFER b-faccpedi FOR faccpedi.
DEFINE BUFFER b-chktareas FOR chktareas.

x-ProcesoOK = "Inicio de grabacion".
GRABAR_REGISTROS:
DO TRANSACTION ON ERROR UNDO, LEAVE:
  DO:
    /* Header update block */
    x-ProcesoOK = "Actualizar la orden como observada (PO)".    
    FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND 
                                    b-faccpedi.coddoc = chktareas.coddoc AND
                                    b-faccpedi.nroped = chktareas.nroped EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE b-faccpedi THEN DO:
        x-ProcesoOK = "Error al actualizar la ORDEN como Observado Liberado".
        UNDO GRABAR_REGISTROS, LEAVE GRABAR_REGISTROS.
    END.
    ASSIGN b-faccpedi.flgsit = 'POL'.

    /* Tarea Observacion */
    x-ProcesoOK = "Ponemos la tarea como Observado Liberado".
    FIND FIRST b-chktareas WHERE b-chktareas.codcia = chktareas.codcia AND
                                b-chktareas.coddiv = chktareas.coddiv AND 
                                b-chktareas.coddoc = chktareas.coddoc AND
                                b-chktareas.nroped = chktareas.nroped AND
                                b-chktareas.mesa = chktareas.mesa EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE b-chktareas THEN DO:
        x-ProcesoOK = "Error al actualizar la tarea como Observado Liberado".
        UNDO GRABAR_REGISTROS, LEAVE GRABAR_REGISTROS.
    END.
    ASSIGN b-chktareas.flgest = 'P'
        b-chktareas.fechafin = TODAY
        b-chktareas.horafin = STRING(TIME,"HH:MM:SS")
        b-chktareas.usuariofin = s-user-id 
        b-chktareas.prioridad = 'Urgente' NO-ERROR
    .
                                
  END.

  x-ProcesoOK = "OK".

END. /* TRANSACTION block */

RELEASE b-faccpedi.
RELEASE b-chktareas.

IF x-ProcesoOK = "OK" THEN DO:
    {&open-query-browse-14}
END.
ELSE DO:
    MESSAGE x-ProcesoOK.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  ENABLE BROWSE-14 BROWSE-15 
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
  {src/adm/template/snd-list.i "VtaDDocu"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "ChkTareas"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cantidad-observada W-Win 
FUNCTION cantidad-observada RETURNS DECIMAL
  (INPUT pQtyTotal AS DEC, INPUT pQtyPick AS DEC ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 
  DEFINE VAR x-retval AS DEC.

  x-retval  = pQtyTotal - pQtyPick.


  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION chequeador W-Win 
FUNCTION chequeador RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroPed AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE BUFFER x-faccpedi FOR faccpedi.
DEFINE VAR x-retval AS CHAR.

FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND 
                                x-faccpedi.coddoc = pCodDoc AND 
                                x-faccpedi.nroped = pNroPed NO-LOCK NO-ERROR.
IF AVAILABLE x-faccpedi THEN DO:
    /* buscarlo si existe en la maestra de personal */
    FIND FIRST pl-pers WHERE  pl-pers.codper = x-faccpedi.usrchq NO-LOCK NO-ERROR.
    IF  AVAILABLE pl-pers THEN DO:
        x-retval = pl-pers.patper + " " + pl-pers.matper + " " + pl-pers.nomper.
    END.

END.

RETURN x-retval.




END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION sku-faltantes W-Win 
FUNCTION sku-faltantes RETURNS INTEGER
  ( INPUT pCodDoc AS CHAR, INPUT pNrodoc AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE BUFFER x-vtaddocu FOR vtaddocu.
  DEFINE VAR x-retval AS INT INIT 0.

  FOR EACH x-vtaddocu WHERE x-vtaddocu.codcia = s-codcia AND
                                x-vtaddocu.codped = 'X' + pCodDoc AND
                                x-vtaddocu.nroped = pNrodoc NO-LOCK:
      IF NOT (TRUE <> (x-vtaddocu.libre_c04 > "")) THEN DO:
          x-retval = x-retval + 1.
      END.
  END.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tiempo-observado W-Win 
FUNCTION tiempo-observado RETURNS CHARACTER
  ( INPUT pFecha AS DATE, INPUT pHora AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR x-tiempo AS CHAR.

    x-Tiempo = STRING(pFecha,"99/99/9999") + " " + pHora.
    /*
    RUN lib/_time-passed ( DATETIME(STRING(pFecha,"99/99/9999") + ' ' + pHora),
                             DATETIME(STRING(TODAY,"99/99/9999") + ' ' + STRING(TIME,"HH:MM:SS")), OUTPUT x-Tiempo).
    
    */

    RETURN x-tiempo.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

