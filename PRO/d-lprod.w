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

DEFINE
&IF "{&NEW}" = "" &THEN INPUT PARAMETER
&ELSE VARIABLE
&ENDIF x-NumOrd AS CHARACTER.

DEFINE
&IF "{&NEW}" = "" &THEN INPUT PARAMETER
&ELSE VARIABLE
&ENDIF P-ESTADO AS CHARACTER.

DEFINE
&IF "{&NEW}" = "" &THEN OUTPUT PARAMETER
&ELSE VARIABLE
&ENDIF ROWID-RETURN AS ROWID.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE x-codigo AS CHARACTER.
DEFINE VARIABLE ROWID-BROWSE-1 AS ROWID NO-UNDO.

DEFINE SHARED VARIABLE s-CodCia AS INTEGER.
/*DEFINE INPUT PARAMETER p-Estado LIKE LPRCLPRO.Estado.*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES LPRCLPRO

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 x-codigo @ x-codigo LPRCLPRO.NumOrd ~
LPRCLPRO.FchDoc LPRCLPRO.Estado 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-3
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH LPRCLPRO ~
      WHERE LPRCLPRO.CodCia = s-CodCia ~
 AND LPRCLPRO.NumOrd BEGINS x-NumOrd ~
 AND LPRCLPRO.Estado BEGINS p-Estado NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 LPRCLPRO
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 LPRCLPRO


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-21 BROWSE-3 x-codmaq x-busca Btn_OK ~
Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS x-codmaq x-busca 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     IMAGE-UP FILE "img\b-ayuda":U
     LABEL "A&yuda" 
     SIZE 12 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE VARIABLE x-busca AS CHARACTER FORMAT "X(10)":U 
     LABEL "Buscar por Nº Lote" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81 NO-UNDO.

DEFINE VARIABLE x-codmaq AS CHARACTER FORMAT "X(4)":U 
     LABEL "Buscar por Máquina" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45 BY 2.69.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      LPRCLPRO SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 D-Dialog _STRUCTURED
  QUERY BROWSE-3 DISPLAY
      x-codigo @ x-codigo COLUMN-LABEL "Número de Lote" FORMAT "x(14)"
      LPRCLPRO.NumOrd COLUMN-LABEL "Orden de trabajo"
      LPRCLPRO.FchDoc COLUMN-LABEL "<<Fecha>>"
      LPRCLPRO.Estado
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 45 BY 11.35
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-3 AT ROW 4.08 COL 2
     x-codmaq AT ROW 1.58 COL 16 COLON-ALIGNED
     x-busca AT ROW 2.73 COL 16 COLON-ALIGNED
     Btn_OK AT ROW 1.38 COL 48
     Btn_Cancel AT ROW 3.31 COL 48
     Btn_Help AT ROW 5.04 COL 48
     RECT-21 AT ROW 1.19 COL 2
     SPACE(14.42) SKIP(11.80)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Lotes de Producción"
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
/* BROWSE-TAB BROWSE-3 RECT-21 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "INTEGRAL.LPRCLPRO"
     _Where[1]         = "LPRCLPRO.CodCia = s-CodCia
 AND LPRCLPRO.NumOrd BEGINS x-NumOrd
 AND LPRCLPRO.Estado BEGINS p-Estado"
     _FldNameList[1]   > "_<CALC>"
"x-codigo @ x-codigo" "Número de Lote" "x(14)" ? ? ? ? ? ? ? no ?
     _FldNameList[2]   > INTEGRAL.LPRCLPRO.NumOrd
"LPRCLPRO.NumOrd" "Orden de trabajo" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > INTEGRAL.LPRCLPRO.FchDoc
"LPRCLPRO.FchDoc" "<<Fecha>>" ? "date" ? ? ? ? ? ? no ?
     _FldNameList[4]   = INTEGRAL.LPRCLPRO.Estado
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
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
ON GO OF FRAME D-Dialog /* Lotes de Producción */
DO:
  &IF "{&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}" <> "" &THEN
      ROWID-RETURN = ROWID( {&TABLES-IN-QUERY-{&BROWSE-NAME}} ).
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Lotes de Producción */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help D-Dialog
ON CHOOSE OF Btn_Help IN FRAME D-Dialog /* Ayuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
MESSAGE "Help for File: {&FILE-NAME}":U VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-busca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-busca D-Dialog
ON LEAVE OF x-busca IN FRAME D-Dialog /* Buscar por Nº Lote */
DO:

  IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND FIRST LPRCLPRO WHERE
        LPRCLPRO.CodMaq BEGINS SUBSTRING(INPUT x-busca,1,4) AND
        LPRCLPRO.NroDoc BEGINS SUBSTRING(INPUT x-busca,5) AND
        LPRCLPRO.NumOrd BEGINS X-NumORd AND
        LPRCLPRO.Estado BEGINS p-Estado
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE LPRCLPRO THEN DO:
        MESSAGE "REGISTRO NO ENCONTRADO" VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = "".
        RETURN.
    END.
  
    REPEAT:
        FIND FIRST LPRCLPRO WHERE
            LPRCLPRO.CodCia = s-CodCia AND 
            LPRCLPRO.CodMaq = SUBSTRING(INPUT x-busca,1,4) AND
            LPRCLPRO.NumOrd BEGINS X-NumORd AND
            LPRCLPRO.Estado BEGINS p-Estado            
            NO-LOCK NO-ERROR.
        IF AVAILABLE LPRCLPRO THEN LEAVE.
        FIND NEXT LPRCLPRO WHERE
            LPRCLPRO.CodMaq BEGINS SUBSTRING(INPUT x-busca,1,4) AND
            LPRCLPRO.NumOrd BEGINS X-NumORd NO-LOCK NO-ERROR.
    END.
    SELF:SCREEN-VALUE = "".
    IF NOT AVAILABLE LPRCLPRO THEN DO:
        BELL.
        MESSAGE "REGISTRO NO ENCONTRADO" VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    
    ROWID-BROWSE-1 = ROWID( integral.LPRCLPRO ).
    REPOSITION {&BROWSE-NAME} TO ROWID ROWID-BROWSE-1 NO-ERROR.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-codmaq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-codmaq D-Dialog
ON LEAVE OF x-codmaq IN FRAME D-Dialog /* Buscar por Máquina */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND FIRST LPRCLPRO WHERE
        LPRCLPRO.CodMaq BEGINS INPUT x-codmaq AND
        LPRCLPRO.NumOrd BEGINS X-NumORd AND
        LPRCLPRO.Estado BEGINS p-Estado
        NO-LOCK NO-ERROR.

    IF NOT AVAILABLE LPRCLPRO THEN DO:
        MESSAGE "Código de máquina no existe" VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = "".
        RETURN.
    END.
     
    REPEAT:
        FIND FIRST LPRCLPRO WHERE
            LPRCLPRO.CodCia = s-CodCia AND 
            LPRCLPRO.CodMaq = SUBSTRING(INPUT x-busca,1,4) AND
            LPRCLPRO.NumOrd BEGINS X-NumORd AND
            LPRCLPRO.Estado BEGINS p-Estado
            NO-LOCK NO-ERROR.
        IF AVAILABLE LPRCLPRO THEN LEAVE.
        FIND NEXT LPRCLPRO WHERE
            LPRCLPRO.CodMaq BEGINS SUBSTRING(INPUT x-busca,1,4) AND
            LPRCLPRO.NumOrd BEGINS X-NumORd NO-LOCK NO-ERROR.
    END.
    SELF:SCREEN-VALUE = "".
    IF NOT AVAILABLE LPRCLPRO THEN DO:
        BELL.
        MESSAGE "REGISTRO NO ENCONTRADO" VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    
    ROWID-BROWSE-1 = ROWID( integral.LPRCLPRO ).
    REPOSITION {&BROWSE-NAME} TO ROWID ROWID-BROWSE-1 NO-ERROR.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

ON FIND OF LPRCLPRO DO:
    IF AVAILABLE LPRCLPRO THEN
        ASSIGN
            x-codigo = LPRCLPRO.CodMaq + LPRCLPRO.NroDoc.
    ELSE ASSIGN x-Codigo = "".
END.

&IF "{&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}" <> ""
&THEN &UNDEFINE OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}
&ENDIF

{&OPEN-QUERY-{&BROWSE-NAME}}

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
  DISPLAY x-codmaq x-busca 
      WITH FRAME D-Dialog.
  ENABLE RECT-21 BROWSE-3 x-codmaq x-busca Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
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
  {src/adm/template/snd-list.i "LPRCLPRO"}

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


