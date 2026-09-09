&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
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
DEFINE INPUT PARAMETER F-Codcli AS CHAR.
DEFINE INPUT PARAMETER F-Codmat AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODCLI AS CHAR.
DEFINE NEW SHARED VAR S-CODMAT AS CHAR.
S-Codmat = F-Codmat.

DEFINE TEMP-TABLE T-DETA LIKE CcbDDocu.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacDPedi FacCPedi

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH FacDPedi SHARE-LOCK, ~
      EACH FacCPedi OF FacDPedi SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog FacDPedi FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog FacDPedi


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-12 FILL-IN_FchPed FILL-IN_CanPed ~
FILL-IN_FmaPgo FILL-IN_PreUni F-Descnd FILL-IN_PorDto FILL-IN_PorDto2 ~
Btn_OK FILL-IN_ImpLin RADIO-SET_CodMon Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_FchPed FILL-IN_CanPed ~
FILL-IN_FmaPgo FILL-IN_PreUni F-Descnd FILL-IN_PorDto FILL-IN_PorDto2 ~
FILL-IN_ImpLin RADIO-SET_CodMon 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Aceptar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE VARIABLE F-Descnd AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27.72 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_CanPed AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69.

DEFINE VARIABLE FILL-IN_FchPed AS DATE FORMAT "99/99/9999" INITIAL 10/01/99 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69.

DEFINE VARIABLE FILL-IN_FmaPgo AS CHARACTER FORMAT "X(8)" 
     LABEL "Cnd.Venta" 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .69.

DEFINE VARIABLE FILL-IN_ImpLin AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .69.

DEFINE VARIABLE FILL-IN_PorDto AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .69.

DEFINE VARIABLE FILL-IN_PorDto2 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .69.

DEFINE VARIABLE FILL-IN_PreUni AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .69.

DEFINE VARIABLE RADIO-SET_CodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 6.43 BY 1.04.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 71.57 BY 3.73.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      FacDPedi, 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN_FchPed AT ROW 2.23 COL 7.57 COLON-ALIGNED
     FILL-IN_CanPed AT ROW 4.31 COL 13.43 COLON-ALIGNED HELP
          "Cantidad despachada" NO-LABEL
     FILL-IN_FmaPgo AT ROW 2.23 COL 28.14 COLON-ALIGNED
     FILL-IN_PreUni AT ROW 4.31 COL 24.14 COLON-ALIGNED NO-LABEL
     F-Descnd AT ROW 2.23 COL 34.29 COLON-ALIGNED NO-LABEL
     FILL-IN_PorDto AT ROW 4.31 COL 35.29 COLON-ALIGNED NO-LABEL
     FILL-IN_PorDto2 AT ROW 4.35 COL 42.72 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 6.12 COL 48.86
     FILL-IN_ImpLin AT ROW 4.35 COL 50 COLON-ALIGNED NO-LABEL
     RADIO-SET_CodMon AT ROW 2.31 COL 65.86 NO-LABEL
     Btn_Cancel AT ROW 6.08 COL 62
     "Ultima Cotización Rechazada" VIEW-AS TEXT
          SIZE 28.86 BY .5 AT ROW 1.31 COL 4.57
          FONT 1
     RECT-12 AT ROW 1.96 COL 2.29
     "Ultimas Ventas" VIEW-AS TEXT
          SIZE 16.72 BY .5 AT ROW 6.46 COL 4.29
          FONT 1
     "Cantidad" VIEW-AS TEXT
          SIZE 6.72 BY .5 AT ROW 3.62 COL 16.86
     "Pre.Unitario" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.62 COL 27.29
     "% Dscto." VIEW-AS TEXT
          SIZE 6.43 BY .5 AT ROW 3.62 COL 37.29
     "% Dscto." VIEW-AS TEXT
          SIZE 6.43 BY .5 AT ROW 3.65 COL 44.57
     "Importe" VIEW-AS TEXT
          SIZE 5.72 BY .5 AT ROW 3.62 COL 55.43
     SPACE(14.27) SKIP(9.18)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Ult.Movimientos"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
                                                                        */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "integral.FacDPedi,integral.FacCPedi OF integral.FacDPedi"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Ult.Movimientos */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Ventas D-Dialog 
PROCEDURE Captura-Ventas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH CcbDDocu WHERE 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
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
  DISPLAY FILL-IN_FchPed FILL-IN_CanPed FILL-IN_FmaPgo FILL-IN_PreUni F-Descnd 
          FILL-IN_PorDto FILL-IN_PorDto2 FILL-IN_ImpLin RADIO-SET_CodMon 
      WITH FRAME D-Dialog.
  ENABLE RECT-12 FILL-IN_FchPed FILL-IN_CanPed FILL-IN_FmaPgo FILL-IN_PreUni 
         F-Descnd FILL-IN_PorDto FILL-IN_PorDto2 Btn_OK FILL-IN_ImpLin 
         RADIO-SET_CodMon Btn_Cancel 
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
     FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND
          Almmmatg.codmat = F-Codmat NO-LOCK NO-ERROR.
     IF AVAILABLE Almmmatg THEN 
        {&WINDOW-NAME}:TITLE = F-Codmat + " " + Almmmatg.Desmat.
        
     FIND LAST FacDPedi WHERE FacDPedi.CodCia = s-codcia AND
          FacDPedi.codmat = F-Codmat AND FacDPedi.Codcli = F-Codcli AND
          FacDPedi.flgest = 'R' NO-LOCK NO-ERROR.
     IF AVAILABLE FacDPedi THEN
        DISPLAY
           FacDPedi.canped  @ FILL-IN_CanPed 
           FacDPedi.fchped  @ FILL-IN_FchPed 
           FacDPedi.implin  @ FILL-IN_ImpLin 
           FacDPedi.pordto  @ FILL-IN_PorDto 
           FacDPedi.pordto2 @ FILL-IN_PorDto2 
           FacDPedi.preuni  @ FILL-IN_PreUni WITH FRAME {&FRAME-NAME}.
        FIND FacCPedi OF FacDPedi NO-LOCK NO-ERROR.
        IF AVAILABLE FacCPedi THEN DO:
           RADIO-SET_CodMon = FacCPedi.codmon.
           DISPLAY 
              FacCPedi.fmapgo @ FILL-IN_FmaPgo  
              RADIO-SET_CodMon WITH FRAME {&FRAME-NAME}.
        END.
     RUN Captura-Ventas.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
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

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "FacDPedi"}
  {src/adm/template/snd-list.i "FacCPedi"}

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


