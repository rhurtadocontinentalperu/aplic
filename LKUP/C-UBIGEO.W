&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME C-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Dialog 
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

/* Definicion de variables compartidas */
DEFINE SHARED VARIABLE input-var-1 AS CHARACTER.
DEFINE SHARED VARIABLE input-var-2 AS CHARACTER.
DEFINE SHARED VARIABLE input-var-3 AS CHARACTER.
DEFINE SHARED VARIABLE output-var-1 AS ROWID.
DEFINE SHARED VARIABLE output-var-2 AS CHARACTER.
DEFINE SHARED VARIABLE output-var-3 AS CHARACTER.

DEFINE VARIABLE cRegion AS CHARACTER NO-UNDO.
DEFINE VARIABLE cProvincia AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDistrito AS CHARACTER NO-UNDO.
DEFINE VARIABLE lOk AS LOGICAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartConsulta

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME C-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-region COMBO-BOX-provincia ~
COMBO-BOX-distrito Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-region COMBO-BOX-provincia ~
COMBO-BOX-distrito 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX-distrito AS CHARACTER FORMAT "X(256)":U 
     LABEL "Distrito" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS " "
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-provincia AS CHARACTER FORMAT "X(256)":U 
     LABEL "Provincia" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS " "
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-region AS CHARACTER FORMAT "X(256)":U 
     LABEL "Región" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS " "
     SIZE 32 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME C-Dialog
     COMBO-BOX-region AT ROW 1.77 COL 9 COLON-ALIGNED
     COMBO-BOX-provincia AT ROW 2.73 COL 9 COLON-ALIGNED
     COMBO-BOX-distrito AT ROW 3.69 COL 9 COLON-ALIGNED
     Btn_OK AT ROW 1.77 COL 47
     Btn_Cancel AT ROW 4.08 COL 47
     SPACE(1.56) SKIP(0.41)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "UBIGEO".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartConsulta
   Allow: Basic,Browse,DB-Fields,Smart,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX C-Dialog
                                                                        */
ASSIGN 
       FRAME C-Dialog:SCROLLABLE       = FALSE
       FRAME C-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX C-Dialog
/* Query rebuild information for DIALOG-BOX C-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX C-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Dialog C-Dialog
ON WINDOW-CLOSE OF FRAME C-Dialog /* UBIGEO */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK C-Dialog
ON CHOOSE OF Btn_OK IN FRAME C-Dialog /* Aceptar */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        OUTPUT-VAR-2 = cRegion + cProvincia + cdistrito.
        OUTPUT-VAR-3 =
            TRIM(ENTRY(2,COMBO-BOX-region:SCREEN-VALUE,"-")) + "," +
            TRIM(ENTRY(2,COMBO-BOX-provincia:SCREEN-VALUE,"-")) + "," +
            TRIM(ENTRY(2,COMBO-BOX-distrito:SCREEN-VALUE,"-")).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-distrito
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-distrito C-Dialog
ON VALUE-CHANGED OF COMBO-BOX-distrito IN FRAME C-Dialog /* Distrito */
DO:
    cDistrito = TRIM(ENTRY(1,SELF:SCREEN-VALUE,"-")).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-provincia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-provincia C-Dialog
ON VALUE-CHANGED OF COMBO-BOX-provincia IN FRAME C-Dialog /* Provincia */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        cProvincia = TRIM(ENTRY(1,SELF:SCREEN-VALUE,"-")).
        cDistrito = "01".
        /* Distrito */
        COMBO-BOX-distrito:LIST-ITEMS = "".
        FOR EACH TabDistr WHERE
            TabDistr.CodDepto = cRegion AND
            TabDistr.CodProvi = cProvincia NO-LOCK:
            lOk = COMBO-BOX-distrito:ADD-LAST(
                TabDistr.CodDistr + " - " + TabDistr.NomDistr).
            IF cDistrito = TabDistr.CodDistr THEN
                COMBO-BOX-distrito = TabDistr.CodDistr + " - " + TabDistr.NomDistr.
        END.
        DISPLAY COMBO-BOX-distrito.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-region
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-region C-Dialog
ON VALUE-CHANGED OF COMBO-BOX-region IN FRAME C-Dialog /* Región */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        cRegion = TRIM(ENTRY(1,SELF:SCREEN-VALUE,"-")).
        cProvincia = "01".
        cDistrito = "01".
        /* Provincia */
        COMBO-BOX-provincia:LIST-ITEMS = "".
        FOR EACH TabProvi WHERE
            TabProvi.CodDepto = cRegion NO-LOCK:
            lOk = COMBO-BOX-provincia:ADD-LAST(
                TabProvi.CodProvi + " - " + TabProvi.NomProvi).
            IF cProvincia = TabProvi.CodProvi THEN
                COMBO-BOX-provincia = TabProvi.CodProvi + " - " + TabProvi.NomProvi.
        END.
        COMBO-BOX-distrito:LIST-ITEMS = "".
        /* Distrito */
        FOR EACH TabDistr WHERE
            TabDistr.CodDepto = cRegion AND
            TabDistr.CodProvi = cProvincia NO-LOCK:
            lOk = COMBO-BOX-distrito:ADD-LAST(
                TabDistr.CodDistr + " - " + TabDistr.NomDistr).
            IF cDistrito = TabDistr.CodDistr THEN
                COMBO-BOX-distrito = TabDistr.CodDistr + " - " + TabDistr.NomDistr.
        END.
        DISPLAY
            COMBO-BOX-provincia
            COMBO-BOX-distrito.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects C-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available C-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Dialog _DEFAULT-DISABLE
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
  HIDE FRAME C-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Dialog _DEFAULT-ENABLE
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
  DISPLAY COMBO-BOX-region COMBO-BOX-provincia COMBO-BOX-distrito 
      WITH FRAME C-Dialog.
  ENABLE COMBO-BOX-region COMBO-BOX-provincia COMBO-BOX-distrito Btn_OK 
         Btn_Cancel 
      WITH FRAME C-Dialog.
  VIEW FRAME C-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-C-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize C-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    /* Code placed here will execute AFTER standard behavior.    */

    IF CAN-FIND(FIRST TabDistr WHERE
        TabDistr.CodDepto = SUBSTRING(input-var-1,1,2) AND
        TabDistr.CodProvi = SUBSTRING(input-var-1,3,2) AND
        TabDistr.CodDistr = SUBSTRING(input-var-1,5,2)) THEN DO:
        cRegion = SUBSTRING(input-var-1,1,2).
        cProvincia = SUBSTRING(input-var-1,3,2).
        cDistrito = SUBSTRING(input-var-1,5,2).
    END.
    ELSE DO:
        cRegion = "15".
        cProvincia = "01".
        cDistrito = "01".
    END.
    DO WITH FRAME {&FRAME-NAME}:
        /* Region */
        FOR EACH TabDepto NO-LOCK:
            lOk = COMBO-BOX-region:ADD-LAST(
                TabDepto.CodDepto + " - " + TabDepto.NomDepto).
            IF cRegion = TabDepto.CodDepto THEN
                COMBO-BOX-region = TabDepto.CodDepto + " - " + TabDepto.NomDepto.
        END.
        /* Provincia */
        FOR EACH TabProvi WHERE
            TabProvi.CodDepto = cRegion NO-LOCK:
            lOk = COMBO-BOX-provincia:ADD-LAST(
                TabProvi.CodProvi + " - " + TabProvi.NomProvi).
            IF cProvincia = TabProvi.CodProvi THEN
                COMBO-BOX-provincia = TabProvi.CodProvi + " - " + TabProvi.NomProvi.
        END.
        /* Distrito */
        FOR EACH TabDistr WHERE
            TabDistr.CodDepto = cRegion AND
            TabDistr.CodProvi = cProvincia NO-LOCK:
            lOk = COMBO-BOX-distrito:ADD-LAST(
                TabDistr.CodDistr + " - " + TabDistr.NomDistr).
            IF cDistrito = TabDistr.CodDistr THEN
                COMBO-BOX-distrito = TabDistr.CodDistr + " - " + TabDistr.NomDistr.
        END.
        DISPLAY
            COMBO-BOX-region
            COMBO-BOX-provincia
            COMBO-BOX-distrito.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE p-aceptar C-Dialog 
PROCEDURE p-aceptar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    APPLY "CHOOSE" TO Btn_OK IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records C-Dialog _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartConsulta, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed C-Dialog 
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


