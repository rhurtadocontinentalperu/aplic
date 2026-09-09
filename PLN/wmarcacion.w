&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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
DEF SHARED VAR s-periodo AS INT.
DEF SHARED VAR s-nromes AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEFINE SHARED VAR pRCID AS INT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-CodPer FILL-IN-Password BUTTON-4 ~
RECT-4 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodPer FILL-IN-Password ~
FILL-IN-Nombre FILL-IN-Hora 

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
DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 4" 
     SIZE 31 BY 2.88.

DEFINE VARIABLE FILL-IN-CodPer AS CHARACTER FORMAT "X(6)":U 
     LABEL "Código" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1.73 NO-UNDO.

DEFINE VARIABLE FILL-IN-Hora AS CHARACTER FORMAT "X(256)":U 
     LABEL "Hora" 
     VIEW-AS FILL-IN 
     SIZE 30.29 BY 1.73 NO-UNDO.

DEFINE VARIABLE FILL-IN-Nombre AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 74 BY 1.73 NO-UNDO.

DEFINE VARIABLE FILL-IN-Password AS CHARACTER FORMAT "X(11)":U 
     LABEL "Password" 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1.73 NO-UNDO.

DEFINE IMAGE IMAGE-1
     STRETCH-TO-FIT
     SIZE 34 BY 11.35.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 6 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 11.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodPer AT ROW 14.27 COL 32 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-Password AT ROW 16.19 COL 32 COLON-ALIGNED WIDGET-ID 6 PASSWORD-FIELD 
     FILL-IN-Nombre AT ROW 18.12 COL 32 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-Hora AT ROW 20.04 COL 32 COLON-ALIGNED WIDGET-ID 18
     BUTTON-4 AT ROW 21.96 COL 34 WIDGET-ID 16
     IMAGE-1 AT ROW 1.96 COL 35 WIDGET-ID 2
     RECT-4 AT ROW 1.58 COL 34 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 115.72 BY 24.19
         FONT 8 WIDGET-ID 100.


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
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 24.19
         WIDTH              = 115.72
         MAX-HEIGHT         = 24.19
         MAX-WIDTH          = 115.72
         VIRTUAL-HEIGHT     = 24.19
         VIRTUAL-WIDTH      = 115.72
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
/* SETTINGS FOR FILL-IN FILL-IN-Hora IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Nombre IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR IMAGE IMAGE-1 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME F-Main:HANDLE
       ROW             = 4.46
       COLUMN          = 78
       HEIGHT          = 3.85
       WIDTH           = 14.29
       WIDGET-ID       = 20
       HIDDEN          = yes
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */
      CtrlFrame:MOVE-AFTER(BUTTON-4:HANDLE IN FRAME F-Main).

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
  /* Consistencia final */
    FIND pl-pers WHERE pl-pers.codper = FILL-IN-CodPer:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-pers THEN DO:
        MESSAGE "Código Errado" VIEW-AS ALERT-BOX ERROR.
        IMAGE-1:LOAD-IMAGE("adeicon\blank.bmp").
        FILL-IN-CodPer:SCREEN-VALUE = ''.
        APPLY 'ENTRY':U TO FILL-IN-CodPer.
        RETURN NO-APPLY.
    END.
    FIND pl-flg-mes WHERE pl-flg-mes.codcia = s-codcia
        AND pl-flg-mes.periodo = s-periodo
        AND pl-flg-mes.nromes = s-nromes
        AND pl-flg-mes.codper = FILL-IN-CodPer:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-flg-mes OR pl-flg-mes.SitAct <> "Activo" THEN DO:
        MESSAGE "Código Inactivo" VIEW-AS ALERT-BOX ERROR.
        IMAGE-1:LOAD-IMAGE("adeicon\blank.bmp").
        FILL-IN-CodPer:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    IF pl-pers.NroDocID <> FILL-IN-Password:SCREEN-VALUE THEN DO:
        MESSAGE "Password Errado" VIEW-AS ALERT-BOX ERROR.
        FILL-IN-Password:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    CREATE AS-MARC.
    ASSIGN
        AS-MARC.CodCia = s-codcia
        AS-MARC.CodPer = FILL-IN-CodPer:SCREEN-VALUE
        AS-MARC.FchMar = TODAY
        AS-MARC.HorMar = STRING(TIME, 'HH:MM:SS')
        AS-MARC.Usuario = s-user-id
        AS-marc.id-session = pRCID.
    RELEASE AS-MARC.
    ASSIGN
        FILL-IN-CodPer:SCREEN-VALUE = '' 
        FILL-IN-Hora:SCREEN-VALUE = '' 
        FILL-IN-Nombre:SCREEN-VALUE = '' 
        FILL-IN-Password:SCREEN-VALUE = ''.
    IMAGE-1:LOAD-IMAGE("adeicon\blank.bmp").
    APPLY "ENTRY":U TO FILL-IN-CodPer.
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

DISPLAY STRING(TIME, 'HH:MM:SS') @ FILL-IN-Hora WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodPer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPer W-Win
ON LEAVE OF FILL-IN-CodPer IN FRAME F-Main /* Código */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND pl-pers WHERE pl-pers.codper = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-pers THEN DO:
        MESSAGE "Código Errado" VIEW-AS ALERT-BOX ERROR.
        IMAGE-1:LOAD-IMAGE("adeicon\blank.bmp").
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    FIND pl-flg-mes WHERE pl-flg-mes.codcia = s-codcia
        AND pl-flg-mes.periodo = s-periodo
        AND pl-flg-mes.nromes = s-nromes
        AND pl-flg-mes.codper = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-flg-mes THEN DO:
        IMAGE-1:LOAD-IMAGE("adeicon\blank.bmp").
        SELF:SCREEN-VALUE = ''.
        BELL.
        RETURN NO-APPLY.
    END.
    IF SEARCH("\\inf251\Fotos_Ate\" + PL-PERS.Codper + ".bmp") <> ? THEN
        IMAGE-1:LOAD-IMAGE("\\inf251\Fotos_Ate\" + PL-PERS.Codper + ".bmp").
    ELSE
        IMAGE-1:LOAD-IMAGE("adeicon\blank.bmp").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Password
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Password W-Win
ON LEAVE OF FILL-IN-Password IN FRAME F-Main /* Password */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND pl-pers WHERE pl-pers.codper = FILL-IN-CodPer:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-pers THEN DO:
        MESSAGE "Código Errado" VIEW-AS ALERT-BOX ERROR.
        IMAGE-1:LOAD-IMAGE("adeicon\blank.bmp").
        FILL-IN-CodPer:SCREEN-VALUE = ''.
        SELF:SCREEN-VALUE = ''.
        APPLY 'ENTRY':U TO FILL-IN-CodPer.
        RETURN NO-APPLY.
    END.
    IF pl-pers.NroDocID <> SELF:SCREEN-VALUE THEN DO:
        MESSAGE "Password Errado" VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    DISPLAY
        pl-pers.patper + ' ' + pl-pers.matper + ', ' + pl-pers.nomper
        @ FILL-IN-Nombre WITH FRAME {&FRAME-NAME}.
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

OCXFile = SEARCH( "wmarcacion.wrx":U ).
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
ELSE MESSAGE "wmarcacion.wrx":U SKIP(1)
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
  DISPLAY FILL-IN-CodPer FILL-IN-Password FILL-IN-Nombre FILL-IN-Hora 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-CodPer FILL-IN-Password BUTTON-4 RECT-4 
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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

