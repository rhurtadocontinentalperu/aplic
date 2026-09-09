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
DEFINE SHARED VAR s-codalm AS CHAR.
DEFINE SHARED VAR S-DESALM AS CHAR.

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
&Scoped-Define ENABLED-OBJECTS txtZonaAntigua txtZonaAntigua-2 txtZona ~
chkbx-quienes BtnProc 
&Scoped-Define DISPLAYED-OBJECTS txtAlmacen txtDesAlm txtZonaAntigua ~
txtDesZona-2 txtZonaAntigua-2 txtDesZona-3 txtZona txtDesZona chkbx-quienes 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnProc 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtAlmacen AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesZona AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesZona-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesZona-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE txtZona AS CHARACTER FORMAT "X(10)":U 
     LABEL "Nueva Zona" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtZonaAntigua AS CHARACTER FORMAT "X(10)":U 
     LABEL "Zona a CAMBIAR Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtZonaAntigua-2 AS CHARACTER FORMAT "X(10)":U 
     LABEL "Zona a CAMBIAR Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE chkbx-quienes AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todos los Articulos", 1,
"Solo con Stock CERO", 2,
"Solo los que tienen STOCK", 3
     SIZE 28 BY 3 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txtAlmacen AT ROW 2.65 COL 11.29 COLON-ALIGNED WIDGET-ID 2
     txtDesAlm AT ROW 2.69 COL 18.29 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     txtZonaAntigua AT ROW 4.65 COL 22 COLON-ALIGNED WIDGET-ID 16
     txtDesZona-2 AT ROW 4.65 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     txtZonaAntigua-2 AT ROW 5.77 COL 22 COLON-ALIGNED WIDGET-ID 26
     txtDesZona-3 AT ROW 5.77 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     txtZona AT ROW 6.96 COL 22 COLON-ALIGNED WIDGET-ID 10
     txtDesZona AT ROW 6.96 COL 37.14 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     chkbx-quienes AT ROW 9.04 COL 27 NO-LABEL WIDGET-ID 12
     BtnProc AT ROW 11.38 COL 60 WIDGET-ID 24
     "Cambio de Zonas" VIEW-AS TEXT
          SIZE 38.86 BY 1.15 AT ROW 1.08 COL 23.14 WIDGET-ID 22
          BGCOLOR 1 FGCOLOR 15 FONT 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 12.92 WIDGET-ID 100.


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
         TITLE              = "Blanqueo de Zonas"
         HEIGHT             = 12.92
         WIDTH              = 80
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
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
/* SETTINGS FOR FILL-IN txtAlmacen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtDesAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtDesZona IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtDesZona-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtDesZona-3 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Blanqueo de Zonas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Blanqueo de Zonas */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnProc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnProc W-Win
ON CHOOSE OF BtnProc IN FRAME F-Main /* Procesar */
DO:
    ASSIGN txtZonaAntigua txtZonaAntigua-2 txtZona txtDesZona-2 txtDesZona-3 txtZona chkbx-quienes.

    IF txtZonaAntigua = txtZona AND txtZona <> "" THEN DO:
        MESSAGE "La zonas deben ser diferentes.." VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
    END.

    txtDesZona-2:SCREEN-VALUE = "".
    IF txtZonaAntigua <> "" AND txtZonaAntigua <> "G-0" THEN DO:
        FIND FIRST almtubic WHERE almtubic.codcia = s-codcia AND almtubic.codalm = s-codalm AND
              almtubic.codubi = txtZonaAntigua NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almtubic THEN DO:
            MESSAGE "La zona a cambiar NO-EXISTE.." VIEW-AS ALERT-BOX.
            RETURN NO-APPLY.
        END.
        txtDesZona-2:SCREEN-VALUE = txtZonaAntigua + " Ubicado en " + almtubic.codzona.
    END.

    txtDesZona-3:SCREEN-VALUE = "".
    IF txtZonaAntigua-2 <> "" AND txtZonaAntigua-2 <> "G-0" THEN DO:
        FIND FIRST almtubic WHERE almtubic.codcia = s-codcia AND almtubic.codalm = s-codalm AND
              almtubic.codubi = txtZonaAntigua-2 NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almtubic THEN DO:
            MESSAGE "La zona a cambiar NO-EXISTE.." VIEW-AS ALERT-BOX.
            RETURN NO-APPLY.
        END.
        txtDesZona-3:SCREEN-VALUE = txtZonaAntigua-2 + " Ubicado en " + almtubic.codzona.
    END.


    txtDesZona:SCREEN-VALUE = "".
    IF txtZona <> "" AND txtZona <> "G-0" THEN DO:
        FIND FIRST almtubic WHERE almtubic.codcia = s-codcia AND almtubic.codalm = s-codalm AND
              almtubic.codubi = txtZona NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almtubic THEN DO:
            MESSAGE "La NUEVA zona NO-EXISTE.." VIEW-AS ALERT-BOX.
            RETURN NO-APPLY.
        END.
        txtDesZona:SCREEN-VALUE = txtZona + " Ubicado en " + almtubic.codzona.
    END.

    IF (txtZonaAntigua > txtZonaAntigua-2) THEN DO:
        MESSAGE "Rango de Zonas a Cambiar Erradas" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
    END.

        MESSAGE 'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.
  
    RUN ue-procesar.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtZona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtZona W-Win
ON LEAVE OF txtZona IN FRAME F-Main /* Nueva Zona */
DO:
    ASSIGN txtZonaAntigua txtZona txtDesZona-2 txtZona.

    txtDesZona:SCREEN-VALUE = "".
    IF txtZona <> "" AND txtZona <> "G-0" THEN DO:
        FIND FIRST almtubic WHERE almtubic.codcia = s-codcia AND almtubic.codalm = s-codalm AND
              almtubic.codubi = txtZona NO-LOCK NO-ERROR.
        IF AVAILABLE almtubic THEN DO:
             txtDesZona:SCREEN-VALUE = txtZona + " Ubicado en " + almtubic.codzona.
        END.         
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtZonaAntigua
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtZonaAntigua W-Win
ON LEAVE OF txtZonaAntigua IN FRAME F-Main /* Zona a CAMBIAR Desde */
DO:
  ASSIGN txtZonaAntigua txtZona txtDesZona-2 txtZona.
    
  txtDesZona-2:SCREEN-VALUE = "".
  IF txtZonaAntigua <> "" AND txtZonaAntigua <> "G-0" THEN DO:
      FIND FIRST almtubic WHERE almtubic.codcia = s-codcia AND almtubic.codalm = s-codalm AND
            almtubic.codubi = txtZonaAntigua NO-LOCK NO-ERROR.
      IF AVAILABLE almtubic THEN DO:
          txtDesZona-2:SCREEN-VALUE = txtZonaAntigua + " Ubicado en " + almtubic.codzona.
      END.       
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtZonaAntigua-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtZonaAntigua-2 W-Win
ON LEAVE OF txtZonaAntigua-2 IN FRAME F-Main /* Zona a CAMBIAR Hasta */
DO:
  ASSIGN txtZonaAntigua txtZona txtDesZona-2 txtZona txtZonaAntigua-2 txtDesZona-3.
    
  txtDesZona-3:SCREEN-VALUE = "".
  IF txtZonaAntigua-2 <> "" AND txtZonaAntigua-2 <> "G-0" THEN DO:
      FIND FIRST almtubic WHERE almtubic.codcia = s-codcia AND almtubic.codalm = s-codalm AND
            almtubic.codubi = txtZonaAntigua-2 NO-LOCK NO-ERROR.
      IF AVAILABLE almtubic THEN DO:
          txtDesZona-3:SCREEN-VALUE = txtZonaAntigua-2 + " Ubicado en " + almtubic.codzona.
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
  DISPLAY txtAlmacen txtDesAlm txtZonaAntigua txtDesZona-2 txtZonaAntigua-2 
          txtDesZona-3 txtZona txtDesZona chkbx-quienes 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txtZonaAntigua txtZonaAntigua-2 txtZona chkbx-quienes BtnProc 
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

  txtAlmacen:SCREEN-VALUE IN FRAME {&FRAME-NAME} = s-codalm.
  txtDesAlm:SCREEN-VALUE IN FRAME {&FRAME-NAME} = s-desalm.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-procesar W-Win 
PROCEDURE ue-procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER B-Almmmate FOR Almmmate.
DEFINE VAR lRowId AS ROWID.

DEFINE VAR lZonaDesde AS CHAR.
DEFINE VAR lZonaHasta AS CHAR.

lZonaDesde = txtZonaAntigua.
/*IF txtZonaAntigua = "" THEN lZonaDesde = "11111".*/
lZonaHasta = txtZonaAntigua-2.
/*IF txtZonaAntigua-2 = "" THEN lZonaDesde = "ZZZZZ".  */

SESSION:SET-WAIT-STATE('GENERAL').

FOR EACH Almmmate WHERE codcia = 1 AND 
    Almmmate.codalm = s-codalm NO-LOCK :

    /*IF txtZonaAntigua = "" OR almmmate.codubi = txtZonaAntigua THEN DO:*/
    IF (lZonaDesde = "" AND lZonaHasta = "") OR (almmmate.codubi >= lZonaDesde AND almmmate.codubi <= lZonaHasta) THEN DO:
        IF (chkbx-quienes = 1) OR 
            (chkbx-quienes = 2 AND almmmate.stkact = 0) OR
            (chkbx-quienes = 3 AND almmmate.stkact <> 0) THEN DO:

            ASSIGN lRowId = ROWID(Almmmate).

            FIND FIRST b-almmmate WHERE ROWID(b-almmmate) = lRowId EXCLUSIVE NO-ERROR.
            IF AVAILABLE b-almmmate THEN DO:
                    ASSIGN b-Almmmate.CodUbi = txtZona.
            END.

        END.
        
    END.
END.
SESSION:SET-WAIT-STATE('').

MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

