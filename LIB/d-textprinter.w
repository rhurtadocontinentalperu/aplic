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

/* Local Variable Definitions ---                                       */

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
&Scoped-Define ENABLED-OBJECTS SELECT-PrinterList BUTTON-3 BUTTON-4 ~
BUTTON-5 BUTTON-6 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS SELECT-PrinterList SELECT-PortLIst ~
FILL-IN-OpSys FILL-IN-1 FILL-IN-DefaultPrinter FILL-IN-DefaultPort 

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

DEFINE BUTTON BUTTON-3 
     LABEL "OUTPUT TO PRINTER VALUE(Printer List)" 
     SIZE 43 BY 1.12.

DEFINE BUTTON BUTTON-4 
     LABEL "OUTPUT TO PRINTER VALUE(Port List)" 
     SIZE 43 BY 1.12 TOOLTIP "Imprime con el PortList respectivo de la impresora".

DEFINE BUTTON BUTTON-5 
     LABEL "OUTPUT TO PRINTER VALUE(Printer List)" 
     SIZE 43 BY 1.12.

DEFINE BUTTON BUTTON-6 
     LABEL "OUTPUT TO PRINTER VALUE(Port List)" 
     SIZE 43 BY 1.12.

DEFINE VARIABLE FILL-IN-1 AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Printer Count" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-DefaultPort AS CHARACTER FORMAT "X(256)":U 
     LABEL "Default Port" 
     VIEW-AS FILL-IN 
     SIZE 55 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-DefaultPrinter AS CHARACTER FORMAT "X(256)":U 
     LABEL "Default Printer" 
     VIEW-AS FILL-IN 
     SIZE 55 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-OpSys AS CHARACTER FORMAT "X(256)":U 
     LABEL "OS" 
     VIEW-AS FILL-IN 
     SIZE 28 BY 1 NO-UNDO.

DEFINE VARIABLE SELECT-PortLIst AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 56 BY 14.27 NO-UNDO.

DEFINE VARIABLE SELECT-PrinterList AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 56 BY 14.27 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     SELECT-PrinterList AT ROW 2.08 COL 4 NO-LABEL WIDGET-ID 30
     SELECT-PortLIst AT ROW 2.08 COL 62 NO-LABEL WIDGET-ID 28
     BUTTON-3 AT ROW 16.62 COL 9 WIDGET-ID 34
     BUTTON-4 AT ROW 16.62 COL 69 WIDGET-ID 36
     FILL-IN-OpSys AT ROW 18.23 COL 18 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-1 AT ROW 19.31 COL 18 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-DefaultPrinter AT ROW 20.38 COL 18 COLON-ALIGNED WIDGET-ID 18
     BUTTON-5 AT ROW 20.38 COL 75 WIDGET-ID 38
     FILL-IN-DefaultPort AT ROW 21.46 COL 18 COLON-ALIGNED WIDGET-ID 20
     BUTTON-6 AT ROW 21.46 COL 75 WIDGET-ID 40
     Btn_OK AT ROW 23.62 COL 2
     Btn_Cancel AT ROW 23.62 COL 19
     "Printer List: MS-WINXP" VIEW-AS TEXT
          SIZE 22 BY .62 AT ROW 1.27 COL 4 WIDGET-ID 32
     "Port List: MS-WIN95" VIEW-AS TEXT
          SIZE 17 BY .62 AT ROW 1.27 COL 62 WIDGET-ID 10
     SPACE(42.56) SKIP(23.64)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
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

/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DefaultPort IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DefaultPrinter IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-OpSys IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR SELECTION-LIST SELECT-PortLIst IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* <insert SmartDialog title> */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 D-Dialog
ON CHOOSE OF BUTTON-3 IN FRAME D-Dialog /* OUTPUT TO PRINTER VALUE(Printer List) */
DO:
    ASSIGN SELECT-PrinterList.
    OUTPUT TO PRINTER VALUE(SELECT-PrinterList).
    PUT 'OUTPUT TO PRINTER VALUE(' SELECT-PrinterList ')' SKIP.
    OUTPUT CLOSE.
    MESSAGE 'Test finalizado'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 D-Dialog
ON CHOOSE OF BUTTON-4 IN FRAME D-Dialog /* OUTPUT TO PRINTER VALUE(Port List) */
DO:
    ASSIGN SELECT-PortList SELECT-PrinterList.
    DEF VAR cPortName AS CHAR NO-UNDO.
    cPortName = SELECT-PortList:ENTRY(SELECT-PrinterList:LOOKUP(SELECT-PrinterList)). 
    IF NOT cPortName BEGINS 'LPT' THEN cPortName = REPLACE(cPortName,':','').
    OUTPUT TO PRINTER VALUE(cPortName).
    PUT 'OUTPUT TO PRINTER VALUE(' cPortName ')' SKIP.
    OUTPUT CLOSE.
    MESSAGE 'Test finalizado'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 D-Dialog
ON CHOOSE OF BUTTON-5 IN FRAME D-Dialog /* OUTPUT TO PRINTER VALUE(Printer List) */
DO:
    ASSIGN FILL-IN-DefaultPrinter.
    OUTPUT TO PRINTER VALUE(FILL-IN-DefaultPrinter).
    PUT 'OUTPUT TO PRINTER VALUE(' FILL-IN-DefaultPrinter ')' SKIP.
    OUTPUT CLOSE.
    MESSAGE 'Test finalizado'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 D-Dialog
ON CHOOSE OF BUTTON-6 IN FRAME D-Dialog /* OUTPUT TO PRINTER VALUE(Port List) */
DO:
    ASSIGN FILL-IN-DefaultPort.
    OUTPUT TO PRINTER VALUE(FILL-IN-DefaultPort).
    PUT 'OUTPUT TO PRINTER VALUE(' FILL-IN-DefaultPort ')' SKIP.
    OUTPUT CLOSE.
    MESSAGE 'Test finalizado'.
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
  DISPLAY SELECT-PrinterList SELECT-PortLIst FILL-IN-OpSys FILL-IN-1 
          FILL-IN-DefaultPrinter FILL-IN-DefaultPort 
      WITH FRAME D-Dialog.
  ENABLE SELECT-PrinterList BUTTON-3 BUTTON-4 BUTTON-5 BUTTON-6 Btn_OK 
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
  /* Capturo la impresora por defecto */
  DEF VAR success AS LOG NO-UNDO.
  RUN lib/_default_printer.p (OUTPUT FILL-IN-DefaultPrinter, OUTPUT FILL-IN-DefaultPort, OUTPUT success).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DEF VAR s-printer-list  AS CHAR NO-UNDO.
  DEF VAR s-port-list     AS CHAR NO-UNDO.
  DEF VAR s-printer-count AS INT  NO-UNDO.

  /* Definimos impresoras */
  RUN aderb/_prlist ( OUTPUT s-printer-list,
                      OUTPUT s-port-list,
                      OUTPUT s-printer-count ).
  DO WITH FRAME {&FRAME-NAME}:
      SELECT-PrinterList:ADD-LAST(s-printer-list).
      SELECT-PortLIst:ADD-LAST(s-port-list).
      FILL-IN-1:SCREEN-VALUE = STRING(s-printer-count).
      FILL-IN-OpSys:SCREEN-VALUE = SESSION:WINDOW-SYSTEM.
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

