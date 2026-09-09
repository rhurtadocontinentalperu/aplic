&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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

/* Local Variable Definitions ---                                       */
DEFINE VAR I-TPOREP AS INTEGER INIT 1.

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEF VAR RB-REPORT-LIBRARY AS CHAR.
RB-REPORT-LIBRARY = RUTA + "alm\rbalm.prl".

DEF VAR RB-REPORT-NAME AS CHAR INITIAL "".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "O".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".

DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-16 RECT-8 RECT-9 RECT-10 RECT-17 ~
Btn-Codigo Btn-Descripcion Btn_OK S-CodFam DesdeC DesdeD HastaD I-TipMat ~
HastaC Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS S-CodFam DesdeC DesdeD HastaD I-TipMat ~
HastaC 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-Codigo 
     LABEL "Codigo" 
     SIZE 10 BY 1.23.

DEFINE BUTTON Btn-Descripcion 
     LABEL "Descripcion" 
     SIZE 10 BY 1.23.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .69 NO-UNDO.

DEFINE VARIABLE DesdeD AS CHARACTER FORMAT "X(256)":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .69 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .69 NO-UNDO.

DEFINE VARIABLE HastaD AS CHARACTER FORMAT "X(256)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .69 NO-UNDO.

DEFINE VARIABLE S-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 4.43 BY .69 NO-UNDO.

DEFINE VARIABLE I-TipMat AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Solo con Stock", 1,
"Todos los Seleccionados", 2
     SIZE 20.43 BY 1.15 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47.14 BY 2.04.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 12.29 BY 4.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 33.72 BY 1.62.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 15.86 BY 1.23.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34.14 BY 1.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     Btn-Codigo AT ROW 2.73 COL 2.86
     Btn-Descripcion AT ROW 4.62 COL 2.86
     Btn_OK AT ROW 8.46 COL 15
     S-CodFam AT ROW 1.46 COL 21.72 COLON-ALIGNED
     DesdeC AT ROW 2.92 COL 21.72 COLON-ALIGNED
     DesdeD AT ROW 4.46 COL 19.72 COLON-ALIGNED
     HastaD AT ROW 5.31 COL 19.72 COLON-ALIGNED
     I-TipMat AT ROW 6.81 COL 26.86 NO-LABEL
     HastaC AT ROW 2.92 COL 37.86 COLON-ALIGNED
     Btn_Cancel AT ROW 8.46 COL 39
     RECT-16 AT ROW 2.27 COL 1.72
     RECT-8 AT ROW 1.19 COL 15.57
     RECT-9 AT ROW 2.65 COL 15.57
     RECT-10 AT ROW 4.23 COL 15.57
     RECT-17 AT ROW 6.58 COL 15.57
     "Articulos" VIEW-AS TEXT
          SIZE 7.57 BY .5 AT ROW 7 COL 17
     "Ordenado por" VIEW-AS TEXT
          SIZE 9.86 BY .5 AT ROW 2.04 COL 2.72
     SPACE(52.55) SKIP(8.18)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Reporte para la toma de Inventario".


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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Reporte para la toma de Inventario */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Codigo D-Dialog
ON CHOOSE OF Btn-Codigo IN FRAME D-Dialog /* Codigo */
DO:
  ASSIGN DesdeC:SENSITIVE = YES
         HastaC:SENSITIVE = YES
         DesdeD:SENSITIVE = NO
         HastaD:SENSITIVE = NO
         I-TPOREP = 1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Descripcion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Descripcion D-Dialog
ON CHOOSE OF Btn-Descripcion IN FRAME D-Dialog /* Descripcion */
DO:
  ASSIGN DesdeD:SENSITIVE = YES
         HastaD:SENSITIVE = YES
         DesdeC:SENSITIVE = NO
         HastaC:SENSITIVE = NO
         I-TPOREP = 2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN DesdeC DesdeD S-CodFam HastaC HastaD I-TipMat.
  RUN Imprime.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC D-Dialog
ON LEAVE OF DesdeC IN FRAME D-Dialog /* Desde */
DO:
  IF INPUT DesdeC = "" THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND 
                      Almmmatg.CodMat = INPUT DesdeC NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC D-Dialog
ON LEAVE OF HastaC IN FRAME D-Dialog /* Hasta */
DO:
  IF INPUT HastaC = "" THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND 
                      Almmmatg.CodMat = INPUT HastaC NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
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
  DISPLAY S-CodFam DesdeC DesdeD HastaD I-TipMat HastaC 
      WITH FRAME D-Dialog.
  ENABLE RECT-16 RECT-8 RECT-9 RECT-10 RECT-17 Btn-Codigo Btn-Descripcion 
         Btn_OK S-CodFam DesdeC DesdeD HastaD I-TipMat HastaC Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime D-Dialog 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF I-TPOREP = 1 THEN RB-REPORT-NAME = "Toma de Inventarios(Cod)".
    IF I-TPOREP = 2 THEN RB-REPORT-NAME = "Toma de Inventarios(Des)".
    
    RB-FILTER = "Almmmatg.CodCia = " + STRING(S-CODCIA) +
                " AND Almmmate.CodAlm = '" + STRING(S-CODALM) + "'".
                
    IF I-TipMat = 1 THEN
       RB-FILTER = RB-FILTER + " AND Almmmate.StkAct > 0".
    IF S-CodFam <> "" THEN 
       RB-FILTER = RB-FILTER + " AND Almmmatg.codfam = '" + S-CodFam + "'".
    IF DesdeC <> "" THEN
       RB-FILTER = RB-FILTER + " AND Almmmatg.CodMat >= '" + DesdeC + "'".
    IF HastaC <> "" THEN
       RB-FILTER = RB-FILTER + " AND Almmmatg.CodMat <= '" + HastaC + "'".
    IF DesdeD <> "" THEN
       RB-FILTER = RB-FILTER + " AND Almmmatg.DesMat >= '" + DesdeD + "'".
    IF HastaD <> "" THEN
       RB-FILTER = RB-FILTER + " AND Almmmatg.DesMat <= '" + HastaD + "¦'".

    RB-OTHER-PARAMETERS = "GsNomCia = " + S-NOMCIA + "~nGsTitulo = " + S-CODALM + "-" + S-DESALM.

    RUN lib\_imprime.r(RB-REPORT-LIBRARY, 
                       RB-REPORT-NAME,
                       RB-INCLUDE-RECORDS, 
                       RB-FILTER, 
                       RB-OTHER-PARAMETERS
                       ).

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
  ASSIGN FRAME {&FRAME-NAME}:TITLE = FRAME {&FRAME-NAME}:TITLE + " [ " + S-CODALM + " - " + S-DESALM + " ]".
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN DesdeD:SENSITIVE = NO
            HastaD:SENSITIVE = NO.
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
        WHEN "DesdeC" THEN ASSIGN input-var-1 = S-CODALM.
        WHEN "HastaC" THEN ASSIGN input-var-1 = S-CODALM.
        /*
            ASSIGN
                input-var-1 = ""
                input-var-2 = ""
                input-var-3 = "".
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


