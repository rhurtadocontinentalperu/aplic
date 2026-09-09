&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-MATE LIKE Almmmate.



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
DEF SHARED VAR s-codalm AS CHAR.

DEF VAR s-adm-new-record AS LOG INIT NO NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-CodUbi FILL-IN-CodMat BtnDone ~
BUTTON-21 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodUbi FILL-IN-CodMat ~
EDITOR-DesMat 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 6 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-21 
     LABEL "CAMBIAR UBICACION" 
     SIZE 38 BY 1.31.

DEFINE BUTTON BUTTON-Grabar 
     LABEL "GRABAR" 
     SIZE 18 BY 1.35.

DEFINE VARIABLE COMBO-BOX-CodUbi AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione" 
     LABEL "UBICACION" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "Seleccione" 
     DROP-DOWN-LIST
     SIZE 23 BY 1 NO-UNDO.

DEFINE VARIABLE EDITOR-DesMat AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 45 BY 5.19
     BGCOLOR 14 FGCOLOR 0 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodMat AS CHARACTER FORMAT "X(13)":U 
     LABEL "ARTICULO" 
     VIEW-AS FILL-IN 
     SIZE 23 BY 1.35 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-CodUbi AT ROW 1.19 COL 22 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-CodMat AT ROW 2.92 COL 22 COLON-ALIGNED WIDGET-ID 6 AUTO-RETURN 
     EDITOR-DesMat AT ROW 4.65 COL 3 NO-LABEL WIDGET-ID 4
     BUTTON-Grabar AT ROW 10.04 COL 3 WIDGET-ID 16
     BtnDone AT ROW 11.38 COL 42 WIDGET-ID 10
     BUTTON-21 AT ROW 11.58 COL 3 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 49.29 BY 12.04
         FONT 8 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-MATE T "?" ? INTEGRAL Almmmate
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ZONIFICACION"
         HEIGHT             = 12.04
         WIDTH              = 49.29
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 144.29
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 144.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
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
/* SETTINGS FOR BUTTON BUTTON-Grabar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR EDITOR-DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ZONIFICACION */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ZONIFICACION */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Main
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Main W-Win
ON GO OF FRAME F-Main
DO:
   COMBO-BOX-CodUbi:SENSITIVE = YES.
   APPLY 'ENTRY':U TO COMBO-BOX-CodUbi.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
    /* Control de lo ya ingresado */
    IF CAN-FIND(FIRST T-MATE NO-LOCK) THEN DO:
        MESSAGE 'Aún no ha grabado la información registrada' SKIP
            'Continuamos?'
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.
    END.
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


&Scoped-define SELF-NAME BUTTON-21
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-21 W-Win
ON CHOOSE OF BUTTON-21 IN FRAME F-Main /* CAMBIAR UBICACION */
DO:
  /* Control de lo ya ingresado */
  IF CAN-FIND(FIRST T-MATE NO-LOCK) THEN DO:
      MESSAGE 'Aún no ha grabado la información registrada' SKIP
          'Continuamos con otra ubicación?'
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
          UPDATE rpta AS LOG.
      IF rpta = NO THEN RETURN NO-APPLY.
  END.
  COMBO-BOX-CodUbi:SENSITIVE = YES.
  COMBO-BOX-CodUbi = 'Seleccione'.
  COMBO-BOX-CodUbi:SCREEN-VALUE = 'Seleccione'.
  APPLY 'ENTRY':U TO COMBO-BOX-CodUbi.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Grabar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Grabar W-Win
ON CHOOSE OF BUTTON-Grabar IN FRAME F-Main /* GRABAR */
DO:
   IF NOT CAN-FIND(FIRST T-MATE NO-LOCK) THEN RETURN NO-APPLY.
   MESSAGE 'Se va a grabar todo lo registrado' SKIP
       'Procedemos?' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
       UPDATE rpta AS LOG.
   IF rpta = NO THEN RETURN NO-APPLY.
   RUN Grabar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodUbi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodUbi W-Win
ON VALUE-CHANGED OF COMBO-BOX-CodUbi IN FRAME F-Main /* UBICACION */
DO:
  ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMat W-Win
ON LEAVE OF FILL-IN-CodMat IN FRAME F-Main /* ARTICULO */
OR ENTER OF FILL-IN-CodMat
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    IF COMBO-BOX-CodUbi = 'Seleccione' THEN DO:
        BELL.
        MESSAGE 'Seleccione una UBICACION' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO COMBO-BOX-CodUbi.
        RETURN NO-APPLY.
    END.
    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).
    IF pCodMat = '' THEN DO:
        BELL.
        MESSAGE 'Código errado' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    SELF:SCREEN-VALUE = pCodMat.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE
        NO-LOCK.
    EDITOR-DesMat:SCREEN-VALUE = Almmmatg.desmat.
    FIND Almmmate WHERE Almmmate.CodCia = Almmmatg.codcia
        AND Almmmate.CodAlm = s-codalm
        AND Almmmate.codmat = Almmmatg.codmat
        NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        BELL.
        MESSAGE 'No registrado en el almacén' s-codalm VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    FIND T-MATE WHERE T-MATE.codcia = Almmmatg.codcia
        AND T-MATE.codalm = s-codalm
        AND T-MATE.codmat = Almmmatg.codmat
        NO-LOCK NO-ERROR.
    IF AVAILABLE T-MATE AND T-MATE.codubi <> COMBO-BOX-CodUbi 
        THEN DO:
        BELL.
        MESSAGE 'Este artículo está ya registrado' SKIP
            'en la ubicación' T-MATE.codubi
            VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    IF NOT AVAILABLE T-MATE THEN DO:
        CREATE T-MATE.
        ASSIGN
            T-MATE.codcia = Almmmatg.codcia
            T-MATE.codalm = s-codalm
            T-MATE.codmat = Almmmatg.codmat
            T-MATE.codubi = COMBO-BOX-CodUbi.
    END.
    s-adm-new-record = YES.
    PAUSE 2 NO-MESSAGE.
    
    ASSIGN
        COMBO-BOX-CodUbi:SENSITIVE = NO
        BUTTON-Grabar:SENSITIVE = YES
        EDITOR-DesMat:SCREEN-VALUE = ''
        FILL-IN-CodMat:SCREEN-VALUE = ''.
    APPLY 'ENTRY':U TO FILL-IN-CodMat.
    RETURN NO-APPLY.
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
  DISPLAY COMBO-BOX-CodUbi FILL-IN-CodMat EDITOR-DesMat 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-CodUbi FILL-IN-CodMat BtnDone BUTTON-21 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar W-Win 
PROCEDURE Grabar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH T-MATE:
    {lib/lock-genericov2.i &Tabla="Almmmate" ~
        &Condicion="Almmmate.codcia = T-MATE.codcia AND Almmmate.codmat = T-MATE.codmat ~
        AND Almmmate.codalm = T-MATE.codalm" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-WAIT" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="RETURN"
        }
    ASSIGN
        Almmmate.codubi = T-MATE.codubi.
    DELETE T-MATE.
END.
DO WITH FRAME {&FRAME-NAME}:
    /* Control de lo ya ingresado */
    COMBO-BOX-CodUbi:SENSITIVE = YES.
    BUTTON-Grabar:SENSITIVE = NO.
    COMBO-BOX-CodUbi = 'Seleccione'.
    COMBO-BOX-CodUbi:SCREEN-VALUE = 'Seleccione'.
    APPLY 'ENTRY':U TO COMBO-BOX-CodUbi.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  EMPTY TEMP-TABLE T-MATE.
  s-adm-new-record = NO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH almtubic NO-LOCK WHERE almtubic.CodCia = s-codcia
          AND almtubic.CodAlm = s-codalm:
           COMBO-BOX-CodUbi:ADD-LAST(almtubic.CodUbi).
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

