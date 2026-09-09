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

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE BUFFER bexpasist FOR expasist.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-CodCli FILL-IN-17 BUTTON-OK ~
BUTTON-Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodCli FILL-IN-NomCli FILL-IN-RUC ~
FILL-IN-17 FILL-IN-18 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Cancel 
     IMAGE-UP FILE "IMG/b-cancel.bmp":U
     LABEL "Button 4" 
     SIZE 15 BY 1.62.

DEFINE BUTTON BUTTON-OK AUTO-END-KEY 
     IMAGE-UP FILE "IMG/b-ok.bmp":U
     LABEL "Button 3" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE FILL-IN-17 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente de Referencia" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-18 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 50.43 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Codigo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 58 BY 1
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE FILL-IN-RUC AS CHARACTER FORMAT "X(11)":U 
     LABEL "RUC" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 8  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodCli AT ROW 1.58 COL 20 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-NomCli AT ROW 2.54 COL 20 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-RUC AT ROW 3.5 COL 20 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-17 AT ROW 4.46 COL 20 COLON-ALIGNED WIDGET-ID 62
     FILL-IN-18 AT ROW 5.42 COL 20 COLON-ALIGNED WIDGET-ID 64
     BUTTON-OK AT ROW 6.96 COL 65 WIDGET-ID 8
     BUTTON-Cancel AT ROW 6.96 COL 80 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 96.29 BY 8 WIDGET-ID 100.


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
         TITLE              = "Registra Cliente"
         HEIGHT             = 8
         WIDTH              = 96.29
         MAX-HEIGHT         = 10.5
         MAX-WIDTH          = 96.29
         VIRTUAL-HEIGHT     = 10.5
         VIRTUAL-WIDTH      = 96.29
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
/* SETTINGS FOR FILL-IN FILL-IN-18 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-RUC IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Registra Cliente */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Registra Cliente */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Cancel W-Win
ON CHOOSE OF BUTTON-Cancel IN FRAME F-Main /* Button 4 */
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


&Scoped-define SELF-NAME BUTTON-OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-OK W-Win
ON CHOOSE OF BUTTON-OK IN FRAME F-Main /* Button 3 */
DO:
    ASSIGN 
        FILL-in-codcli 
        fill-in-17.
    FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = FILL-IN-codcli NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
        MESSAGE 'Cliente NO registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY' TO FILL-in-codcli.
        RETURN NO-APPLY.
    END.
    IF FILL-IN-17 <> '' THEN DO:
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = FILL-IN-17 NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-clie THEN DO:
            MESSAGE 'Cliente NO registrado' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY' TO FILL-in-17.
            RETURN NO-APPLY.
        END.
    END.
    RUN Graba-Cliente.
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-17
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-17 W-Win
ON LEAVE OF FILL-IN-17 IN FRAME F-Main /* Cliente de Referencia */
DO:

    FIND FIRST GN-CLIE WHERE GN-CLIE.CODCIA = CL-CODCIA
        AND GN-CLIE.CODCLI = FILL-IN-17:SCREEN-VALUE IN FRAME {&FRAME-NAME}
        NO-LOCK NO-ERROR.
    IF AVAIL GN-CLIE THEN DO:
        DISPLAY
            GN-CLIE.NOMCLI @ FILL-IN-17
            WITH FRAME {&FRAME-NAME}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli W-Win
ON LEAVE OF FILL-IN-CodCli IN FRAME F-Main /* Codigo */
DO:
    FIND FIRST GN-CLIE WHERE GN-CLIE.CODCIA = CL-CODCIA
        AND GN-CLIE.CODCLI = FILL-IN-CODCLI:SCREEN-VALUE IN FRAME {&FRAME-NAME}
        NO-LOCK NO-ERROR.
    IF AVAIL GN-CLIE THEN DO:
        DISPLAY
            GN-CLIE.NOMCLI @ FILL-IN-NOMCLI 
            GN-CLIE.RUC    @ FILL-IN-RUC
            WITH FRAME {&FRAME-NAME}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

ON RETURN OF FILL-IN-CODCLI
DO:
    APPLY 'TAB':U.
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
  DISPLAY FILL-IN-CodCli FILL-IN-NomCli FILL-IN-RUC FILL-IN-17 FILL-IN-18 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-CodCli FILL-IN-17 BUTTON-OK BUTTON-Cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Cliente W-Win 
PROCEDURE Graba-Cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    
    FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = FILL-IN-codcli NO-LOCK NO-ERROR.
    IF AVAIL gn-clie THEN DO:
        FIND LAST expasist WHERE expasist.codcia = s-codcia
            AND expasist.coddiv = s-coddiv 
            AND expasist.codcli = gn-clie.codcli 
            NO-LOCK NO-ERROR. 
        IF AVAILABLE ExpAsist THEN DO:
            IF ExpAsist.FecPro >= (TODAY - 3) THEN DO:
                MESSAGE 'El cliente está programado para el día' ExpAsist.FecPro
                    VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
            IF ExpAsist.Fecha >= TODAY AND ExpAsist.Estado[1] = "C" THEN DO:
                MESSAGE 'El cliente ya fue registrado el día' ExpAsist.Fecha ExpAsist.Hora
                    VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
        END.
        CREATE ExpAsist.
        ASSIGN 
            ExpAsist.CodCia     = s-codcia
            ExpAsist.CodCli     = fill-in-codcli
            ExpAsist.CodDiv     = s-coddiv
            ExpAsist.Estado[1]  = 'C' 
            ExpAsist.Estado[2]  = 'N'          /*Para clientes nuevo de la lista*/
            ExpAsist.FecPro     = TODAY 
            ExpAsist.HoraPro    = STRING(TIME,"HH:MM:SS") 
            ExpAsist.FecAsi[1]  = TODAY
            ExpAsist.HoraAsi[1] = STRING(TIME,"HH:MM:SS") 
            ExpAsist.Fecha      = TODAY
            ExpAsist.Hora       = STRING(TIME,"HH:MM:SS") 
            ExpAsist.NomCli     = gn-clie.nomcli 
            ExpAsist.Usuario    = s-user-id
            ExpAsist.libre_c01  = fill-in-17.
        RELEASE ExpAsist.
    END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
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
    DEFINE VAR OUTPUT-var-1 AS ROWID.


    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
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
        WHEN "" THEN ASSIGN input-var-1 = "".
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

