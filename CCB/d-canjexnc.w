&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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
DEF OUTPUT PARAMETER pNroSerNC  LIKE Faccorre.Correlativo.
DEF OUTPUT PARAMETER pCodMat    AS CHAR.
DEF OUTPUT PARAMETER pNroSerFAC LIKE Faccorre.Correlativo.

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

pNroSerNC = 0.
pNroSerFAC = 0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-NroSer-NC COMBO-BOX-CodMat ~
COMBO-BOX-NroSer-FAC Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-NroSer-NC FILL-IN-Correlativo-NC ~
COMBO-BOX-CodMat COMBO-BOX-NroSer-FAC FILL-IN-Correlativo-FAC 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Cancel" 
     SIZE 15 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "OK" 
     SIZE 15 BY 1.73
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX-CodMat AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione el concepto" 
     LABEL "Concepto" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Seleccione el concepto","Seleccione el concepto"
     DROP-DOWN-LIST
     SIZE 70 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-NroSer-FAC AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Serie FAC" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-NroSer-NC AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Serie N/C" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Correlativo-FAC AS INTEGER FORMAT "99999999":U INITIAL 0 
     LABEL "Correlativo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Correlativo-NC AS INTEGER FORMAT "99999999":U INITIAL 0 
     LABEL "Correlativo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     COMBO-BOX-NroSer-NC AT ROW 1.96 COL 16 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-Correlativo-NC AT ROW 3.12 COL 16 COLON-ALIGNED WIDGET-ID 4
     COMBO-BOX-CodMat AT ROW 4.27 COL 16 COLON-ALIGNED WIDGET-ID 6
     COMBO-BOX-NroSer-FAC AT ROW 6.58 COL 16 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-Correlativo-FAC AT ROW 7.73 COL 16 COLON-ALIGNED WIDGET-ID 12
     Btn_OK AT ROW 7.92 COL 59
     Btn_Cancel AT ROW 7.92 COL 74
     "Parámetros para la FAC" VIEW-AS TEXT
          SIZE 21 BY .62 AT ROW 5.62 COL 3 WIDGET-ID 14
          BGCOLOR 9 FGCOLOR 15 
     "Parámetros para la N/C" VIEW-AS TEXT
          SIZE 21 BY .62 AT ROW 1.19 COL 3 WIDGET-ID 8
          BGCOLOR 9 FGCOLOR 15 
     SPACE(70.28) SKIP(8.68)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "SELECCIONE UNA SERIE"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


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

/* SETTINGS FOR FILL-IN FILL-IN-Correlativo-FAC IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Correlativo-NC IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* SELECCIONE UNA SERIE */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancel */
DO:
  pNroSerNC = 0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
  ASSIGN COMBO-BOX-NroSer-NC COMBO-BOX-CodMat.
  IF COMBO-BOX-CodMat BEGINS 'Seleccione' THEN DO:
      MESSAGE 'Debe seleccionar un concepto' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO COMBO-BOX-CodMat.
      RETURN NO-APPLY.
  END.
  pNroSerNC  = COMBO-BOX-NroSer-NC.
  pNroSerFAC = COMBO-BOX-NroSer-FAC.
  pCodMat    = COMBO-BOX-CodMat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-NroSer-FAC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-NroSer-FAC D-Dialog
ON VALUE-CHANGED OF COMBO-BOX-NroSer-FAC IN FRAME D-Dialog /* Serie FAC */
DO:
  ASSIGN {&self-name}.
  
  FIND FacCorre WHERE FacCorre.CodCia = s-codcia
      AND FacCorre.CodDiv = s-coddiv
      AND FacCorre.CodDoc = "FAC"
      AND FacCorre.NroSer = COMBO-BOX-NroSer-FAC
      NO-LOCK NO-ERROR.
  IF AVAILABLE FacCorre THEN DO:
      FILL-IN-Correlativo-FAC = FacCorre.Correlativo.
      DISPLAY FILL-IN-Correlativo-FAC WITH FRAME {&FRAME-NAME}.
  END.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-NroSer-NC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-NroSer-NC D-Dialog
ON VALUE-CHANGED OF COMBO-BOX-NroSer-NC IN FRAME D-Dialog /* Serie N/C */
DO:
  ASSIGN {&self-name}.
  
  FIND FacCorre WHERE FacCorre.CodCia = s-codcia
      AND FacCorre.CodDiv = s-coddiv
      AND FacCorre.CodDoc = "N/C"
      AND FacCorre.NroSer = COMBO-BOX-NroSer-NC
      NO-LOCK NO-ERROR.
  IF AVAILABLE FacCorre THEN DO:
      FILL-IN-Correlativo-NC = FacCorre.Correlativo.
      DISPLAY FILL-IN-Correlativo-NC WITH FRAME {&FRAME-NAME}.
  END.
      
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
  DISPLAY COMBO-BOX-NroSer-NC FILL-IN-Correlativo-NC COMBO-BOX-CodMat 
          COMBO-BOX-NroSer-FAC FILL-IN-Correlativo-FAC 
      WITH FRAME D-Dialog.
  ENABLE COMBO-BOX-NroSer-NC COMBO-BOX-CodMat COMBO-BOX-NroSer-FAC Btn_OK 
         Btn_Cancel 
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
       COMBO-BOX-NroSer-NC:DELETE(1).
       FOR EACH FacCorre WHERE FacCorre.CodCia = s-codcia
           AND FacCorre.CodDiv = s-coddiv
           AND FacCorre.CodDoc = "N/C"
           AND FacCorre.FlgEst = YES
           BREAK BY FacCorre.CodCia BY FacCorre.NroSer DESCENDING:
           COMBO-BOX-NroSer-NC:ADD-LAST(STRING(FacCorre.NroSer,'999')).
           IF LAST-OF(FacCorre.CodCia) THEN
               ASSIGN
               COMBO-BOX-NroSer-NC:SCREEN-VALUE = STRING(FacCorre.NroSer,'999').
       END.
       APPLY 'VALUE-CHANGED':U TO COMBO-BOX-NroSer-NC.
       FOR EACH Ccbtabla NO-LOCK WHERE CcbTabla.CodCia = s-codcia
           AND CcbTabla.Tabla = "N/C":
           COMBO-BOX-CodMat:ADD-LAST(CcbTabla.Nombre, CcbTabla.Codigo).
       END.
       COMBO-BOX-NroSer-FAC:DELETE(1).
       FOR EACH FacCorre WHERE FacCorre.CodCia = s-codcia
           AND FacCorre.CodDiv = s-coddiv
           AND FacCorre.CodDoc = "FAC"
           AND FacCorre.FlgEst = YES
           BREAK BY FacCorre.CodCia BY FacCorre.NroSer DESCENDING:
           COMBO-BOX-NroSer-FAC:ADD-LAST(STRING(FacCorre.NroSer,'999')).
           IF LAST-OF(FacCorre.CodCia) THEN
               ASSIGN
               COMBO-BOX-NroSer-FAC:SCREEN-VALUE = STRING(FacCorre.NroSer,'999').
       END.
       APPLY 'VALUE-CHANGED':U TO COMBO-BOX-NroSer-FAC.
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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

