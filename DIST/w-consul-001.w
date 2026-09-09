&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-RutaC NO-UNDO LIKE DI-RutaC.



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
DEF SHARED VAR pv-codcia AS INT.

DEF VAR x-Chofer AS CHAR NO-UNDO.

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
&Scoped-define INTERNAL-TABLES T-RutaC DI-RutaC gn-prov

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 T-RutaC.NroDoc DI-RutaC.FchSal ~
DI-RutaC.CodPro gn-prov.NomPro DI-RutaC.CodVeh DI-RutaC.Libre_c01 ~
fChofer() @ x-Chofer 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH T-RutaC NO-LOCK, ~
      FIRST DI-RutaC OF T-RutaC NO-LOCK, ~
      FIRST gn-prov WHERE gn-prov.CodPro = T-RutaC.CodPro ~
      AND gn-prov.CodCia = pv-codcia NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH T-RutaC NO-LOCK, ~
      FIRST DI-RutaC OF T-RutaC NO-LOCK, ~
      FIRST gn-prov WHERE gn-prov.CodPro = T-RutaC.CodPro ~
      AND gn-prov.CodCia = pv-codcia NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 T-RutaC DI-RutaC gn-prov
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 T-RutaC
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 DI-RutaC
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-2 gn-prov


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Division BUTTON-1 FILL-IN-CodVeh ~
FILL-IN-CodPro FILL-IN-FchSal BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Division FILL-IN-CodVeh ~
FILL-IN-Marca FILL-IN-CodPro txtDTrans FILL-IN-FchSal 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fChofer W-Win 
FUNCTION fChofer RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Aplicar Filtros" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX-Division AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 58 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPro AS CHARACTER FORMAT "X(256)":U 
     LABEL "Empresa de Transporte" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodVeh AS CHARACTER FORMAT "X(256)":U 
     LABEL "Placa" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchSal AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Salida" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Marca AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 18 BY .81 NO-UNDO.

DEFINE VARIABLE txtDTrans AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      T-RutaC, 
      DI-RutaC, 
      gn-prov
    FIELDS(gn-prov.NomPro) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      T-RutaC.NroDoc COLUMN-LABEL "H/R" FORMAT "X(9)":U WIDTH 9.43
      DI-RutaC.FchSal COLUMN-LABEL "Salida" FORMAT "99/99/9999":U
            WIDTH 10
      DI-RutaC.CodPro COLUMN-LABEL "Transportista" FORMAT "x(11)":U
      gn-prov.NomPro FORMAT "x(50)":U
      DI-RutaC.CodVeh COLUMN-LABEL "Placa" FORMAT "X(10)":U WIDTH 7.29
      DI-RutaC.Libre_c01 COLUMN-LABEL "Licencia" FORMAT "x(8)":U
            WIDTH 8.43
      fChofer() @ x-Chofer COLUMN-LABEL "Nombre" FORMAT "x(50)":U
            WIDTH 26.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 113 BY 21
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Division AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 4
     BUTTON-1 AT ROW 1.27 COL 81 WIDGET-ID 12
     FILL-IN-CodVeh AT ROW 2.35 COL 19 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-Marca AT ROW 2.35 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     FILL-IN-CodPro AT ROW 3.42 COL 19 COLON-ALIGNED WIDGET-ID 6
     txtDTrans AT ROW 3.42 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     FILL-IN-FchSal AT ROW 4.5 COL 19 COLON-ALIGNED WIDGET-ID 10
     BROWSE-2 AT ROW 5.58 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 114.86 BY 25.85
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-RutaC T "?" NO-UNDO INTEGRAL DI-RutaC
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Monitoreo de Unidades de Transporte"
         HEIGHT             = 25.85
         WIDTH              = 114.86
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
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 FILL-IN-FchSal F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-Marca IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtDTrans IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.T-RutaC,INTEGRAL.DI-RutaC OF Temp-Tables.T-RutaC,INTEGRAL.gn-prov WHERE Temp-Tables.T-RutaC ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST, FIRST USED,"
     _JoinCode[3]      = "INTEGRAL.gn-prov.CodPro = Temp-Tables.T-RutaC.CodPro"
     _Where[3]         = "INTEGRAL.gn-prov.CodCia = pv-codcia"
     _FldNameList[1]   > Temp-Tables.T-RutaC.NroDoc
"Temp-Tables.T-RutaC.NroDoc" "H/R" ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.DI-RutaC.FchSal
"INTEGRAL.DI-RutaC.FchSal" "Salida" ? "date" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.DI-RutaC.CodPro
"INTEGRAL.DI-RutaC.CodPro" "Transportista" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = INTEGRAL.gn-prov.NomPro
     _FldNameList[5]   > INTEGRAL.DI-RutaC.CodVeh
"INTEGRAL.DI-RutaC.CodVeh" "Placa" "X(10)" "character" ? ? ? ? ? ? no ? no no "7.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.DI-RutaC.Libre_c01
"INTEGRAL.DI-RutaC.Libre_c01" "Licencia" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fChofer() @ x-Chofer" "Nombre" "x(50)" ? ? ? ? ? ? ? no ? no no "26.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Monitoreo de Unidades de Transporte */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Monitoreo de Unidades de Transporte */
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
ON LEFT-MOUSE-DBLCLICK OF BROWSE-2 IN FRAME F-Main
DO:
  RUN dist/d-consul-001.w(ROWID(Di-RutaC)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Aplicar Filtros */
DO:
  ASSIGN
      COMBO-BOX-Division FILL-IN-CodPro FILL-IN-CodVeh FILL-IN-FchSal.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal.
  SESSION:SET-WAIT-STATE('').
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodVeh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodVeh W-Win
ON LEAVE OF FILL-IN-CodVeh IN FRAME F-Main /* Placa */
DO:
  ASSIGN
      SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE)
      FILL-IN-Marca:SCREEN-VALUE = ''
      txtDTrans:SCREEN-VALUE = ''
      .
  FIND gn-vehic WHERE gn-vehic.codcia = s-codcia
      AND gn-vehic.placa = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-vehic THEN FILL-IN-Marca:SCREEN-VALUE = gn-vehic.marca.
  FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia 
      AND vtatabla.tabla = 'VEHICULO' 
      AND vtatabla.llave_c2 = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE vtatabla THEN DO:
      FIND gn-prov WHERE gn-prov.codcia = pv-codcia
          AND gn-prov.codpro = vtatabla.llave_c1 NO-LOCK NO-ERROR.
      IF AVAILABLE gn-prov THEN DO:        
          ASSIGN 
              FILL-IN-CodPro:SCREEN-VALUE = vtatabla.llave_c1
              txtDTrans:SCREEN-VALUE = gn-prov.nompro.
      END.
  END.
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
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-RutaC.

FOR EACH Di-RutaC NO-LOCK WHERE DI-RutaC.CodCia = s-codcia
    AND DI-RutaC.CodDoc = "H/R"
    AND DI-RutaC.FchSal = FILL-IN-FchSal
    AND DI-RutaC.CodDiv = COMBO-BOX-Division
    AND DI-RutaC.FlgEst <> "A":
    IF FILL-IN-CodVeh > '' AND DI-RutaC.CodVeh <> FILL-IN-CodVeh THEN NEXT.
    IF FILL-IN-CodPro > '' AND DI-RutaC.CodPro <> FILL-IN-CodPro THEN NEXT.
    CREATE T-RutaC.
    BUFFER-COPY Di-RutaC TO T-RutaC.
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
  DISPLAY COMBO-BOX-Division FILL-IN-CodVeh FILL-IN-Marca FILL-IN-CodPro 
          txtDTrans FILL-IN-FchSal 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-Division BUTTON-1 FILL-IN-CodVeh FILL-IN-CodPro 
         FILL-IN-FchSal BROWSE-2 
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
  FILL-IN-FchSal = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-Division:DELIMITER = "|".
      COMBO-BOX-Division:DELETE(1).
      FOR EACH gn-divi NO-LOCK WHERE GN-DIVI.CodCia = s-codcia
          AND GN-DIVI.Campo-Log[5] = TRUE
          BREAK BY gn-divi.coddiv:
          COMBO-BOX-Division:ADD-LAST(GN-DIVI.CodDiv + ' ' + GN-DIVI.DesDiv,GN-DIVI.CodDiv).
          IF FIRST(gn-divi.coddiv) THEN COMBO-BOX-Division:SCREEN-VALUE = GN-DIVI.CodDiv.
      END.
  END.

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

    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

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
  {src/adm/template/snd-list.i "T-RutaC"}
  {src/adm/template/snd-list.i "DI-RutaC"}
  {src/adm/template/snd-list.i "gn-prov"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fChofer W-Win 
FUNCTION fChofer RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia 
    AND vtatabla.tabla = 'BREVETE' 
    AND vtatabla.llave_c1 = DI-RutaC.libre_c01 NO-LOCK NO-ERROR.
IF AVAILABLE vtatabla THEN RETURN  vtatabla.libre_C01 + " " + vtatabla.libre_C02 + " " + vtatabla.libre_C03.  
ELSE RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

