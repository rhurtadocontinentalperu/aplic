&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
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

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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

&SCOPED-DEFINE precio-venta-general web/PrecioFinalContadoMayorista.p

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia AS INTE.

DEF INPUT PARAMETER s-codmat AS CHAR.
DEF INPUT PARAMETER s-codalm AS CHAR.
DEF INPUT PARAMETER s-coddiv AS CHAR.
DEF INPUT PARAMETER s-CodCli AS CHAR.
DEF INPUT PARAMETER s-TpoCmb AS DECI.
DEF INPUT PARAMETER s-FlgSit AS CHAR.
DEF INPUT PARAMETER s-NroDec AS INTE.
DEF INPUT PARAMETER s-AlmDes AS CHAR.
DEF INPUT PARAMETER s-UndVta AS CHAR.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND
    Almmmatg.codmat = s-codmat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almmmatg

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define FIELDS-IN-QUERY-D-Dialog Almmmatg.codmat Almmmatg.UndBas ~
Almmmatg.DesMat 
&Scoped-define QUERY-STRING-D-Dialog FOR EACH Almmmatg SHARE-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH Almmmatg SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog Almmmatg


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-68 RECT-66 RECT-67 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-FIELDS Almmmatg.codmat Almmmatg.UndBas ~
Almmmatg.DesMat 
&Scoped-define DISPLAYED-TABLES Almmmatg
&Scoped-define FIRST-DISPLAYED-TABLE Almmmatg
&Scoped-Define DISPLAYED-OBJECTS F-fec1 F-Fec2 F-Porcentaje F-Precio 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE VARIABLE F-fec1 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-Fec2 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-Porcentaje AS DECIMAL FORMAT "->>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-Precio AS DECIMAL FORMAT "->>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE RECTANGLE RECT-66
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53.72 BY 2.19.

DEFINE RECTANGLE RECT-67
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53.72 BY 2.54.

DEFINE RECTANGLE RECT-68
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53.57 BY 1.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     Almmmatg.codmat AT ROW 1.46 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .69
          BGCOLOR 15 FGCOLOR 1 
     Almmmatg.UndBas AT ROW 1.46 COL 18.14 COLON-ALIGNED NO-LABEL WIDGET-ID 22 FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 1 
     Almmmatg.DesMat AT ROW 2.27 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 51.14 BY .69
          BGCOLOR 15 FGCOLOR 1 
     F-fec1 AT ROW 4.77 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     F-Fec2 AT ROW 4.77 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     F-Porcentaje AT ROW 4.77 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     F-Precio AT ROW 4.77 COL 42 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     Btn_OK AT ROW 6.38 COL 2
     Btn_Cancel AT ROW 6.38 COL 19
     "Precio S/" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 3.69 COL 46 WIDGET-ID 26
     "Hasta" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.69 COL 19 WIDGET-ID 18
     "Desde" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.69 COL 4 WIDGET-ID 20
     "%" VIEW-AS TEXT
          SIZE 3 BY .5 AT ROW 3.69 COL 37 WIDGET-ID 2
     RECT-68 AT ROW 3.42 COL 1.72 WIDGET-ID 16
     RECT-66 AT ROW 1.12 COL 1.57 WIDGET-ID 14
     RECT-67 AT ROW 3.42 COL 1.72 WIDGET-ID 28
     SPACE(2.98) SKIP(2.07)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "<insert SmartDialog title>"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN Almmmatg.codmat IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DesMat IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-fec1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Fec2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Porcentaje IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Precio IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.UndBas IN FRAME D-Dialog
   NO-ENABLE EXP-FORMAT                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "INTEGRAL.Almmmatg"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* <insert SmartDialog title> */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY F-fec1 F-Fec2 F-Porcentaje F-Precio 
      WITH FRAME D-Dialog.
  IF AVAILABLE Almmmatg THEN 
    DISPLAY Almmmatg.codmat Almmmatg.UndBas Almmmatg.DesMat 
      WITH FRAME D-Dialog.
  ENABLE RECT-68 RECT-66 RECT-67 Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR f-PreUni AS DECI NO-UNDO.
  DEF VAR s-CodMon AS INTE INIT 1 NO-UNDO.
  DEF VAR f-Factor AS DECI NO-UNDO.
  DEF VAR f-PreBas AS DECI NO-UNDO.
  DEF VAR f-PreVta AS DECI NO-UNDO.
  DEF VAR f-Dsctos AS DECI NO-UNDO.
  DEF VAR y-Dsctos AS DECI NO-UNDO.
  DEF VAR x-TipDto AS CHAR NO-UNDO.
  DEF VAR f-FleteUnitario AS DECI NO-UNDO.
  DEF VAR pMensaje AS CHAR NO-UNDO.


  RUN {&precio-venta-general} (s-CodCia,
                               s-CodDiv,
                               s-CodCli,
                               s-CodMon,
                               s-TpoCmb,
                               OUTPUT f-Factor,
                               s-CodMat,
                               s-FlgSit,
                               s-UndVta,
                               1,
                               s-NroDec,
                               s-AlmDes,   /* Necesario para REMATES */
                               OUTPUT f-PreBas,
                               OUTPUT f-PreVta,
                               OUTPUT f-Dsctos,
                               OUTPUT y-Dsctos,
                               OUTPUT x-TipDto,
                               OUTPUT f-FleteUnitario,
                               OUTPUT pMensaje
                               ).
  IF RETURN-VALUE = 'ADM-ERROR' THEN f-PreBas = 0.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Almmmatg THEN DO WITH FRAME {&FRAME-NAME}:
      DEF VAR x-PorBas AS DECI NO-UNDO.

      /* Mayor descuento */
      FOR EACH VtaDctoProm NO-LOCK WHERE VtaDctoProm.CodCia = Almmmatg.codcia AND
          VtaDctoProm.CodDiv = s-coddiv AND 
          VtaDctoProm.CodMat = Almmmatg.codmat AND
          TODAY >= VtaDctoProm.FchIni AND
          TODAY <= VtaDctoProm.FchFin:
          IF VtaDctoProm.Descuento > x-PorBas THEN DO:
              f-Porcentaje = VtaDctoProm.Descuento.
              f-Fec1 = VtaDctoProm.FchIni.
              f-Fec2 = VtaDctoProm.FchFin.
              x-PorBas = VtaDctoProm.Descuento.
          END.
      END.
      DISPLAY 
          f-Porcentaje 
          f-Fec1 
          f-Fec2
          ROUND((1 - x-PorBas / 100) * f-PreBas, 2) WHEN x-PorBas > 0 @ f-Precio
          .
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "Almmmatg"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

