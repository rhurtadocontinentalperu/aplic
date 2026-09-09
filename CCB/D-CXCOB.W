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

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE NEW GLOBAL SHARED VAR S-task-no AS integer.

/* Parameters Definitions ---                                           */
DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "".
GET-KEY-VALUE SECTION "Startup" KEY "Base" VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb\rbccb.prl".

DEF VAR RB-REPORT-NAME AS CHAR INITIAL "".
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-21 RECT-22 tipo cliente x-tpocam ~
I-TpoRep Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS tipo FILL-IN-5 cliente Nombre x-tpocam ~
I-TpoRep 

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

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE VARIABLE tipo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo documento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 8.86 BY 1 NO-UNDO.

DEFINE VARIABLE cliente AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14.14 BY .81 NO-UNDO.

DEFINE VARIABLE Nombre AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22.43 BY .81 NO-UNDO.

DEFINE VARIABLE x-tpocam AS DECIMAL FORMAT ">9.99":U INITIAL 0 
     LABEL "Tipo de Cambio" 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .81 NO-UNDO.

DEFINE VARIABLE I-TpoRep AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Cliente", 1,
"Documento", 2
     SIZE 21.72 BY .85 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47.29 BY 6.27.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 25 BY 1.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     tipo AT ROW 1.77 COL 13.86 COLON-ALIGNED
     FILL-IN-5 AT ROW 1.88 COL 24.29 COLON-ALIGNED NO-LABEL
     cliente AT ROW 3.31 COL 13.86 COLON-ALIGNED
     Nombre AT ROW 3.35 COL 24.29 COLON-ALIGNED NO-LABEL
     x-tpocam AT ROW 4.46 COL 13.86 COLON-ALIGNED
     I-TpoRep AT ROW 6.04 COL 18.57 NO-LABEL
     Btn_OK AT ROW 7.73 COL 11.57
     Btn_Cancel AT ROW 7.69 COL 28.29
     RECT-21 AT ROW 1.27 COL 2.57
     RECT-22 AT ROW 5.69 COL 15.86
     "Presentacion" VIEW-AS TEXT
          SIZE 9.57 BY .5 AT ROW 6.31 COL 4.72
     SPACE(36.99) SKIP(2.76)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Cuentas por Cobrar por Vencimiento".

 

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
   Custom                                                               */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Nombre IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Cuentas por Cobrar por Vencimiento */
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
  ASSIGN  tipo cliente x-tpocam i-tporep.
                    
  IF INTEGER(x-tpocam:screen-value) = 0 THEN DO:
     MESSAGE " Ingrese el Tipo de Cambio " VIEW-AS ALERT-BOX.
     APPLY "ENTRY" TO x-tpocam.
     RETURN NO-APPLY.
  END.
  RUN imprimir.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cliente D-Dialog
ON LEAVE OF cliente IN FRAME D-Dialog /* Cliente */
DO:
  IF Cliente:screen-value = "" THEN RETURN.
  FIND FIRST CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
         CcbCDocu.Coddoc = tipo:screen-value AND
         CcbCDocu.flgest = "P" AND
         CcbcDocu.codcli = cliente:screen-value NO-LOCK NO-ERROR.
  IF NOT AVAILABLE CcbcDocu THEN DO:
    MESSAGE "Cliente sin Mov. Pendientes" VIEW-AS ALERT-BOX.
    RETURN NO-APPLY.
  END.
  
  FIND gn-clie where gn-clie.codcia = 0 and gn-clie.codcli = cliente:screen-value no-lock no-error.
  IF AVAILABLE gn-clie THEN
     nombre:screen-value = gn-clie.nomcli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME I-TpoRep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-TpoRep D-Dialog
ON VALUE-CHANGED OF I-TpoRep IN FRAME D-Dialog
DO:
/*   case radio-set-1:screen-value:
   when "1" then
     I-TPOREP = 1 .

   when "2" then
     I-TPOREP = 2 .
   end case.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tipo D-Dialog
ON VALUE-CHANGED OF tipo IN FRAME D-Dialog /* Tipo documento */
DO:
    If tipo:screen-value = "" then  return.
  Find first integral.ccbcdocu where integral.ccbcdocu.CodCia = s-codcia and 
                   ccbcdocu.coddoc = tipo:screen-value No-Lock No-Error.
  If not available ccbcdocu then do:
    Message "Tipo de documento no existe" view-as alert-box.
    return no-apply.
  End.
  find facdocum where facdocum.codcia = s-codcia and facdocum.coddoc = tipo:screen-value no-lock no-error.
  If available facdocum then
     Fill-in-5:screen-value = facdocum.nomdoc.


     
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
DEFINE VAR L-Ubica AS LOGICAL INIT YES.
REPEAT WHILE L-Ubica:
       S-TASK-NO = RANDOM(900000,999999).
       FIND FIRST w-report WHERE w-report.task-no = S-TASK-NO NO-LOCK NO-ERROR.
       IF NOT AVAILABLE w-report THEN L-Ubica = NO.
END.

FOR EACH ccbcDocu where integral.CcbCDocu.CodCia = s-codcia and 
    ccbcDocu.codcli begins cliente and 
    ccbcDocu.flgest = "P" and
    ccbcdocu.coddoc begins tipo :
    
    FIND first reporte.w-report where reporte.w-report.Task-No = s-task-no and
                  reporte.w-report.llave-I =  integral.ccbcDocu.codcia and
                  reporte.w-report.campo-c[4] = integral.ccbcDocu.nrodoc no-error.
    IF NOT AVAILABLE reporte.w-report THEN DO:
        create reporte.w-report.
        assign
            reporte.w-report.Task-No = s-task-no    
            reporte.w-report.llave-I =  integral.ccbcDocu.codcia 
            reporte.w-report.campo-c[1] = integral.ccbcdocu.codcli            
            reporte.w-report.campo-c[3] = ccbcdocu.coddoc
            reporte.w-report.campo-c[4] = ccbcdocu.nrodoc
            reporte.w-report.campo-d[1] = ccbcdocu.fchdoc
            reporte.w-report.llave-d = ccbcdocu.fchvto
            w-report.campo-f[3] = x-tpocam.            
        FIND FIRST integral.gn-clie where integral.gn-clie.codcli = integral.ccbcdocu.codcli no-lock no-error.
        IF available integral.gn-clie THEN  ASSIGN reporte.w-report.campo-c[2] = integral.gn-clie.nomcli.
        ELSE ASSIGN reporte.w-report.campo-c[2] = "".

    END.
    IF integral.ccbcdocu.codmon = 1 THEN DO:        /* Moneda = Soles */
     FIND integral.Facdocum where integral.facdocum.coddoc = integral.ccbcdocu.coddoc no-lock no-error.
        IF available integral.Facdocum THEN DO:
            If integral.Facdocum.tpodoc = NO then  /*Abono */
                 ASSIGN
                 w-report.campo-f[1] = -1 * (integral.ccbcdocu.sdoact).
            
            ELSE  ASSIGN w-report.campo-f[1] =  integral.ccbcdocu.sdoact.
        END.
    END.
    ELSE  DO:              /*Moneda = Dolares*/

     FIND integral.Facdocum where integral.facdocum.coddoc = integral.ccbcdocu.coddoc no-lock no-error.
        If available integral.Facdocum THEN DO:
            If integral.Facdocum.tpodoc = NO then  /*Abono */
                 ASSIGN
                 w-report.campo-f[2] = -1 * (integral.ccbcdocu.sdoact).
            
            ELSE  ASSIGN w-report.campo-f[2] =  integral.ccbcdocu.sdoact.
        END.


    END.

END.
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
  DISPLAY tipo FILL-IN-5 cliente Nombre x-tpocam I-TpoRep 
      WITH FRAME D-Dialog.
  ENABLE RECT-21 RECT-22 tipo cliente x-tpocam I-TpoRep Btn_OK Btn_Cancel 
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
RUN carga-data.
    IF I-TPOREP = 1 THEN RB-REPORT-NAME = "Cuentas por cobrar".   
    IF I-TPOREP = 2 THEN RB-REPORT-NAME = "Cuentas por cobrar (cod)".
   
    RB-FILTER = "w-report.task-no = " + STRING(S-TASK-NO).

    RB-OTHER-PARAMETERS = "GsNomCia = " + S-NOMCIA.

    RUN lib\_imprime.r(RB-REPORT-LIBRARY, RB-REPORT-NAME,
        RB-INCLUDE-RECORDS, RB-FILTER, RB-OTHER-PARAMETERS).                            


DELETE FROM W-REPORT WHERE w-report.Task-No = S-TASK-NO.

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
    
    Def var xx as logical.
    
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  For each facdocum with frame {&FRAME-NAME}:
    xx = tipo:add-last(facdocum.coddoc).
  End.  


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


