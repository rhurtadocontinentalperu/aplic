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

DEFINE SHARED VAR s-codcia AS INT.

/* Local Variable Definitions ---                                       */

DEFINE STREAM Reporte.

DEFINE VARIABLE Rpta-1 AS LOGICAL     NO-UNDO.
DEFINE VARIABLE x-file AS CHARACTER   NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS rs-tipo txt-desde txt-codper FILL-IN-2 ~
btn-save BUTTON-7 BUTTON-8 
&Scoped-Define DISPLAYED-OBJECTS rs-tipo txt-desde txt-codper FILL-IN-2 ~
txt-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-save 
     LABEL "..." 
     SIZE 4 BY 1.08.

DEFINE BUTTON BUTTON-7 
     IMAGE-UP FILE "adeicon/admin%.ico":U
     LABEL "Button 7" 
     SIZE 8 BY 1.88.

DEFINE BUTTON BUTTON-8 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 8" 
     SIZE 8 BY 1.88.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Archivo" 
     VIEW-AS FILL-IN 
     SIZE 63 BY 1 NO-UNDO.

DEFINE VARIABLE txt-codper AS CHARACTER FORMAT "X(256)":U 
     LABEL "Personal" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Inicio de Contrato" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 64 BY 1 NO-UNDO.

DEFINE VARIABLE rs-tipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Trabajadores", 1,
"Contratos", 2
     SIZE 31 BY 1.08
     FONT 6 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     rs-tipo AT ROW 1.23 COL 27 NO-LABEL WIDGET-ID 80
     txt-desde AT ROW 2.62 COL 25 COLON-ALIGNED WIDGET-ID 2
     txt-hasta AT ROW 3.69 COL 25 COLON-ALIGNED WIDGET-ID 4
     txt-codper AT ROW 4.77 COL 12 COLON-ALIGNED WIDGET-ID 86
     FILL-IN-2 AT ROW 5.85 COL 12 COLON-ALIGNED WIDGET-ID 70
     btn-save AT ROW 5.85 COL 78 WIDGET-ID 72
     BUTTON-7 AT ROW 9.08 COL 69 WIDGET-ID 74
     BUTTON-8 AT ROW 9.08 COL 78 WIDGET-ID 76
     txt-mensaje AT ROW 9.62 COL 4 NO-LABEL WIDGET-ID 78
     "Tipo de Listado" VIEW-AS TEXT
          SIZE 15 BY .62 AT ROW 1.54 COL 10 WIDGET-ID 84
          FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 86.29 BY 10.5 WIDGET-ID 100.


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
         TITLE              = "Archivo Renov. Trabajadores"
         HEIGHT             = 10.5
         WIDTH              = 86.29
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 100.29
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 100.29
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

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN txt-hasta IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       txt-hasta:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN txt-mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Archivo Renov. Trabajadores */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Archivo Renov. Trabajadores */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-save W-Win
ON CHOOSE OF btn-save IN FRAME F-Main /* ... */
DO:
    SYSTEM-DIALOG GET-FILE x-File FILTERS '*.txt' '*.txt' 
        INITIAL-FILTER 1 ASK-OVERWRITE CREATE-TEST-FILE 
        DEFAULT-EXTENSION 'txt' 
        RETURN-TO-START-DIR SAVE-AS 
        TITLE 'Guardar en' USE-FILENAME
        UPDATE Rpta-1.
    
    IF Rpta-1 = NO THEN RETURN.

    DISPLAY x-file @ FILL-IN-2 WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 W-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* Button 7 */
DO:
  
    ASSIGN rs-tipo txt-desde txt-hasta txt-codper FILL-IN-2.
    RUN Procesa-Datos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* Button 8 */
DO:

  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF

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
  DISPLAY rs-tipo txt-desde txt-codper FILL-IN-2 txt-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE rs-tipo txt-desde txt-codper FILL-IN-2 btn-save BUTTON-7 BUTTON-8 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Datos W-Win 
PROCEDURE Procesa-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cLinea   AS CHARACTER   NO-UNDO FORMAT "X(500)".
    DEFINE VARIABLE cFchNac  AS INTEGER     NO-UNDO FORMAT "99999999".
    DEFINE VARIABLE cFchIni  AS INTEGER     NO-UNDO FORMAT "99999999".
    DEFINE VARIABLE cFchFin  AS INTEGER     NO-UNDO FORMAT "99999999".
    DEFINE VARIABLE dSueldo  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dFecha   AS DECIMAL     NO-UNDO.
    
    x-file = FILL-IN-2.
    OUTPUT STREAM Report TO VALUE(x-file) .

    FOR EACH pl-flg-mes WHERE pl-flg-mes.codcia = s-codcia
        AND (txt-codper = '' OR pl-flg-mes.codper = txt-codper)
        AND pl-flg-mes.FchIniCont = txt-desde
        /*AND pl-flg-mes.FchFinCont <= txt-hasta*/ NO-LOCK,
        LAST pl-pers WHERE pl-pers.codcia = s-codcia
            AND pl-pers.codper = pl-flg-mes.codper NO-LOCK:

        IF pl-flg-mes.fecing = pl-flg-mes.FchIniCont THEN NEXT.

        cFchNac = DAY(PL-PERS.fecnac) * 1000000 + 
                    MONTH(PL-PERS.fecnac) * 10000 +
                    YEAR(PL-PERS.fecnac).
        cFchIni = DAY(pl-flg-mes.FchIniCont) * 1000000 + 
                    MONTH(pl-flg-mes.FchIniCont) * 10000 +
                    YEAR(pl-flg-mes.FchIniCont) .
        cFchFin = DAY(pl-flg-mes.FchFinCont) * 1000000 + 
                    MONTH(pl-flg-mes.FchFinCont) * 10000 +
                    YEAR(pl-flg-mes.FchFinCont) .

        /*Busca Sueldo*/
        FIND LAST pl-mov-mes OF pl-flg-mes WHERE pl-mov-mes.codpln = 01
            AND pl-mov-mes.codcal = 000
            AND pl-mov-mes.codmov = 101 NO-LOCK NO-ERROR.
        IF AVAIL pl-mov-mes THEN dSueldo = pl-mov-mes.valcal-mes. ELSE dSueldo = 0.

        CASE rs-tipo:
            WHEN 1 THEN
                cLinea = PL-PERS.NroDocId + '|' + '03|' + PL-PERS.patper + '|' + 
                         PL-PERS.matper   + '|' + PL-PERS.nomper + '|' + 
                         PL-PERS.sexper   + '|' + STRING(cFchNac,"99999999").
            WHEN 2 THEN
                cLinea = '20100038146|-1|' + PL-PERS.NroDocId + '|1|N|N|1|58|R|9|' +
                    STRING(cFchIni,"99999999") + '|' + STRING(cFchIni,"99999999") + 
                    '|' + STRING(cFchFin,"99999999") + '|01|' + STRING(dSueldo) + '|3||0|'.

        END CASE.
        
        PUT STREAM Report cLinea SKIP. 

        DISPLAY "Procesando " + pl-pers.patper + " " + pl-pers.matper + " " +
            pl-pers.nomper @ txt-mensaje WITH FRAME {&FRAME-NAME}.
        
    END.

    OUTPUT STREAM Report CLOSE.
    DISPLAY "" @ txt-mensaje WITH FRAME {&FRAME-NAME}.

    MESSAGE "Proceso Terminado"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

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

