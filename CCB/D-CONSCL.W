&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
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

/* Definitions variables globales ---                                           */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE NEW GLOBAL SHARED VAR S-task-no AS integer.

/* Parameters Definitions ---                                           */
DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "".
GET-KEY-VALUE SECTION "Startup" KEY "Base" VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb\rbccb.prl".

DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Consolidado de saldos".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "O".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.
/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-32 clienteD clienteh tipo Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS clienteD clienteh nombred nombreh tipo 

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
     SIZE 12 BY 2
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 2
     BGCOLOR 8 .

DEFINE VARIABLE clienteD AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE clienteh AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE nombred AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21.14 BY .81 NO-UNDO.

DEFINE VARIABLE nombreh AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY .81 NO-UNDO.

DEFINE VARIABLE tipo AS DECIMAL FORMAT ">>,>>9.99":U INITIAL 0 
     LABEL "Tipo de Cambio" 
     VIEW-AS FILL-IN 
     SIZE 7.57 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45.14 BY 4.19.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     clienteD AT ROW 2.58 COL 13.29 COLON-ALIGNED
     clienteh AT ROW 3.85 COL 13.14 COLON-ALIGNED
     nombred AT ROW 2.5 COL 23.29 COLON-ALIGNED NO-LABEL
     nombreh AT ROW 3.85 COL 23.57 COLON-ALIGNED NO-LABEL
     tipo AT ROW 4.88 COL 21.14 COLON-ALIGNED
     Btn_OK AT ROW 1.42 COL 50.57
     Btn_Cancel AT ROW 3.92 COL 50.57
     "Ingrese Rango de Clientes" VIEW-AS TEXT
          SIZE 19.29 BY .58 AT ROW 1.5 COL 5.57
          BGCOLOR 1 FGCOLOR 15 
     RECT-32 AT ROW 1.77 COL 3.43
     SPACE(15.14) SKIP(1.07)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Consolidado de saldos".

 

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
   Default                                                              */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN nombred IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN nombreh IN FRAME D-Dialog
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Consolidado de saldos */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  assign cliented clienteH tipo.
  IF Cliented <> ""
  THEN DO:
    FIND gn-clie WHERE gn-clie.codcli = Cliented  and gn-clie.codcia = 0 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie
    THEN DO:
        MESSAGE "Cliente no registrado" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO Cliented.
        RETURN NO-APPLY.
    END.
  END.
  
  IF ClienteH = "" THEN ASSIGN ClienteH = 'ZZZZZZZZ'.
  
  If tipo <= 0.00 then DO:
    message " Ingrese el Tipo de Cambio " view-as alert-box.
    apply "entry":U  to tipo.
    return no-apply.
  END.
  
  Run Imprimir.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME clienteD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL clienteD D-Dialog
ON LEAVE OF clienteD IN FRAME D-Dialog /* Cliente desde */
DO:
  FIND gn-clie WHERE gn-clie.codcli = INPUT ClienteD and gn-clie.codcia = 0 NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie
  THEN Nombred:SCREEN-VALUE = gn-clie.nomcli.
  ELSE Nombred:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME clienteh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL clienteh D-Dialog
ON LEAVE OF clienteh IN FRAME D-Dialog /* Cliente hasta */
DO:
  FIND gn-clie WHERE gn-clie.codcli = INPUT ClienteH and gn-clie.codcia = 0 NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie
  THEN Nombreh:SCREEN-VALUE = gn-clie.nomcli.
  ELSE Nombreh:SCREEN-VALUE = "".
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-data D-Dialog 
PROCEDURE carga-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND first reporte.w-report where reporte.w-report.Task-No = s-task-no and
         reporte.w-report.llave-I =  integral.ccbcDocu.codcia and
         reporte.w-report.campo-c[1] = integral.ccbcDocu.codcli and                  
         reporte.w-report.campo-c[3] = integral.ccbcDocu.coddoc NO-ERROR.
    IF NOT AVAILABLE reporte.w-report THEN DO:
       CREATE reporte.w-report.
       ASSIGN
          reporte.w-report.Task-No = s-task-no    
          reporte.w-report.llave-I =  integral.ccbcDocu.codcia 
          reporte.w-report.campo-c[1] = integral.ccbcdocu.codcli
          reporte.w-report.campo-c[3] = ccbcdocu.coddoc.
            
        FIND gn-clie WHERE gn-clie.codcli =ccbcdocu.codcli NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN  
           ASSIGN reporte.w-report.campo-c[2] = integral.gn-clie.nomcli.
        ELSE
           ASSIGN reporte.w-report.campo-c[2] = "".     
    END.
    
    RUN CONSOLIDA-SALDOS.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-inicial D-Dialog 
PROCEDURE carga-inicial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    REPEAT:
        s-task-no = RANDOM(1,999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no
            NO-LOCK)
        THEN LEAVE.
    END.
    FOR EACH ccbcDocu where integral.CcbCDocu.CodCia = s-codcia AND
        ccbcDocu.codcli >= clienteD AND
        ccbcDocu.codcli <= clienteH :
        RUN carga-data.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Consolida-Saldos D-Dialog 
PROCEDURE Consolida-Saldos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR importe AS DECIMAL.
DEFINE VAR dias AS INTEGER.

IF ccbcdocu.codmon = 1 THEN 
   importe = ROUND(ccbcdocu.sdoact / tipo, 2).
ELSE 
   importe = ccbcdocu.sdoact.
   
FIND FacDocum WHERE FacDocum.CodCia = CcbCDocu.codcia AND
     FacDocum.CodDoc = CcbCDocu.CodDoc NO-ERROR.
IF AVAILABLE FacDocum THEN
   IF FacDocum.TpoDoc = No THEN importe = importe * - 1.

   
IF ccbcdocu.fchvto >= TODAY THEN
   ASSIGN
      w-report.campo-f[1] = w-report.campo-f[1] + importe.
ELSE DO:
   dias = TODAY - fchvto.
   IF dias > 90 THEN dias = 1.               /* 90-mas */  
   IF dias > 60 and dias < 91 then dias = 2.  /* 61-90 */
   IF dias > 30 and dias < 61 then dias = 3.  /* 31-60 */
   IF dias > 0 and dias < 31 then dias = 4.   /* 0-30  */
        
   CASE dias :
      WHEN 1 THEN
           ASSIGN
                w-report.campo-f[5] = w-report.campo-f[5] + importe.    
      WHEN 2 THEN
           ASSIGN
                w-report.campo-f[4] = w-report.campo-f[4] + importe.
      WHEN 3 THEN
           ASSIGN
                w-report.campo-f[3] = w-report.campo-f[3] + importe.     
      WHEN 4 THEN
           ASSIGN
                w-report.campo-f[2] = w-report.campo-f[2] + importe.     
    END CASE.
END.

ASSIGN
   w-report.campo-f[6] = tipo.     

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
  DISPLAY clienteD clienteh nombred nombreh tipo 
      WITH FRAME D-Dialog.
  ENABLE RECT-32 clienteD clienteh tipo Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir D-Dialog 
PROCEDURE imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN  Carga-inicial.

    RB-FILTER = "w-report.task-no = " + STRING(S-TASK-NO).

    RB-OTHER-PARAMETERS = "GsNomCia = " + S-NOMCIA. /* +
                         "~nGstipo = " + x-proveedor + 
                         "~nGsgiro = " + x-giro. */


    RUN lib\_imprime.r(RB-REPORT-LIBRARY, RB-REPORT-NAME,
        RB-INCLUDE-RECORDS, RB-FILTER, RB-OTHER-PARAMETERS).                            


DELETE FROM W-REPORT WHERE w-report.Task-No = S-TASK-NO.

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


