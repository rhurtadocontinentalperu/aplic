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
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE NEW GLOBAL SHARED VAR S-task-no AS integer.

/* Parameters Definitions ---                                           */
DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "".
GET-KEY-VALUE SECTION "Startup" KEY "Base" VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb\rbccb.prl".

DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Doc pendientes x Cliente".
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

DEFINE VAR sub-tit AS CHARACTER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-39 clienteD clienteH x-dia Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS clienteD clienteH x-dia nombreD nombreH 

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
     LABEL "Del Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE clienteH AS CHARACTER FORMAT "X(256)":U 
     LABEL "Al Cliente" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .81 NO-UNDO.

DEFINE VARIABLE nombreD AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21.57 BY .81 NO-UNDO.

DEFINE VARIABLE nombreH AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21.43 BY .81 NO-UNDO.

DEFINE VARIABLE x-dia AS DATE FORMAT "99/99/9999":U 
     LABEL "Al Dia" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-39
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45.43 BY 4.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     clienteD AT ROW 2.42 COL 12.43 COLON-ALIGNED
     clienteH AT ROW 3.54 COL 12.72 COLON-ALIGNED
     x-dia AT ROW 4.62 COL 12.57 COLON-ALIGNED
     nombreD AT ROW 2.46 COL 23.29 COLON-ALIGNED NO-LABEL
     nombreH AT ROW 3.54 COL 23.43 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 1.69 COL 49.29
     Btn_Cancel AT ROW 4.15 COL 49.72
     "Ingrese los parametros" VIEW-AS TEXT
          SIZE 16 BY .69 AT ROW 1.23 COL 5.14
     RECT-39 AT ROW 1.54 COL 2.29
     SPACE(15.41) SKIP(0.49)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Documentos pendientes por cliente".


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

/* SETTINGS FOR FILL-IN nombreD IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN nombreH IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Documentos pendientes por cliente */
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
  Assign cliented clienteh x-dia.
  IF clienteH = "" THEN clienteH = 'ZZZZZZZZ'.      
  IF x-dia = ? THEN DO:
    Message "Ingrese la fecha de corte" view-as alert-box.
    Apply "entry":U to x-dia.
    RETURN NO-APPLY.
  END.
  
  RUN IMPRIMIR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME clienteD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL clienteD D-Dialog
ON LEAVE OF clienteD IN FRAME D-Dialog /* Del Cliente */
DO:
  If ClienteD:screen-value = "" then  return. 
  IF ClienteD <> "" THEN DO:
    Find first integral.CcbCDocu where integral.CcbCDocu.CodCia = s-codcia and 
                       CcbcDocu.codcli = clienteD:screen-value No-Lock No-Error.
      If not available CcbcDocu then do:
        Message "Cliente no tiene documentos pendientes" view-as alert-box.
        Apply "Entry":U to cliented.
        return no-apply.
      End.
  
    Find gn-clie where gn-clie.codcia = 0 and
                     gn-clie.codcli = clienteD:screen-value no-lock no-error.
      If available gn-clie then
         nombreD:screen-value = gn-clie.nomcli.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME clienteH
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL clienteH D-Dialog
ON LEAVE OF clienteH IN FRAME D-Dialog /* Al Cliente */
DO:
  If ClienteH:screen-value = " " then  return. 
  IF ClienteD <> "" THEN DO:
    Find first integral.CcbCDocu where integral.CcbCDocu.CodCia = s-codcia and 
                   CcbcDocu.codcli = clienteH:screen-value  No-Lock No-Error.
      If not available CcbcDocu then do:
        Message "Cliente no tiene documentos pendientes" view-as alert-box.
        Apply "Entry":U to clienteh.
        return no-apply.
      End.
    Find gn-clie where gn-clie.codcia = 0 and gn-clie.codcli = clienteH:screen-value no-lock no-error.
      If available gn-clie then
         nombreH:screen-value = gn-clie.nomcli.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-data D-Dialog 
PROCEDURE carga-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
REPEAT:
        s-task-no = RANDOM(1,888888).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no
            NO-LOCK)
        THEN LEAVE.
END.

FOR EACH integral.ccbcDocu where integral.CcbCDocu.CodCia = s-codcia and 
                                integral.ccbcDocu.codcli >= clienteD and
                                integral.ccbcDocu.codcli <= clienteH and
                                integral.ccbcDocu.flgest = "P":
    
    FIND first w-report where w-report.Task-No = s-task-no and
                  w-report.llave-I =  integral.ccbcDocu.codcia and
                  w-report.campo-c[1] = integral.ccbcDocu.codcli and
                  w-report.campo-c[3] = ccbcdocu.coddoc and
                  w-report.campo-c[4] = ccbcDocu.nrodoc no-error.
  /*  message coddoc skip
            nrodoc skip
            codcli.         */         
    IF NOT AVAILABLE w-report THEN DO:
        create w-report.
        assign
            w-report.Task-No = s-task-no    
            w-report.llave-I =  integral.ccbcDocu.codcia 
            w-report.campo-c[1] = integral.ccbcdocu.codcli
            w-report.campo-c[3] = ccbcdocu.coddoc
            w-report.campo-c[4] = ccbcdocu.nrodoc.            
      FIND FIRST integral.gn-clie where integral.gn-clie.codcli = integral.ccbcdocu.codcli no-lock no-error.
        IF available integral.gn-clie THEN  ASSIGN w-report.campo-c[2] = integral.gn-clie.nomcli.
        ELSE ASSIGN w-report.campo-c[2] = "".     

    END.
    Assign
        w-report.campo-d[1] = integral.ccbcdocu.fchdoc
        w-report.campo-d[2] = integral.ccbcdocu.fchvto
        w-report.campo-c[5] = integral.ccbcdocu.flgsit
        w-report.campo-c[6] = integral.ccbcdocu.codcta.

 RUN VENCIMIENTO.

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
  DISPLAY clienteD clienteH x-dia nombreD nombreH 
      WITH FRAME D-Dialog.
  ENABLE RECT-39 clienteD clienteH x-dia Btn_OK Btn_Cancel 
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
 RUN  Carga-data.
    sub-tit = "Al  " + string(x-dia).

    RB-FILTER = "w-report.task-no = " + STRING(S-TASK-NO).

    RB-OTHER-PARAMETERS = "GsNomCia = " + S-NOMCIA +
                         "~nsub-tit = " + sub-tit. 



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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE vencimiento D-Dialog 
PROCEDURE vencimiento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /* Dias de atraso */
   def var dias as integer.
   dias = x-dia - ccbcdocu.fchvto .
   IF dias > 0 then
        ASSIGN 
            w-report.campo-f[7] = dias.
   ELSE
        ASSIGN
             w-report.campo-f[7] = 0.
             
   If ccbcdocu.codmon = 1 THEN 
        Assign  w-report.campo-f[5] = integral.ccbcdocu.imptot.
   Else
        Assign  w-report.campo-f[6] = integral.ccbcdocu.imptot.
      
   IF integral.ccbcdocu.fchvto < x-dia THEN DO:  /*Saldo Vencido*/
        IF integral.ccbcdocu.codmon = 1 THEN         /* Moneda = Soles */
            ASSIGN
                 w-report.campo-f[1] =  integral.ccbcdocu.sdoact.

        ELSE                                        /*Moneda = Dolares */
                 ASSIGN
                     w-report.campo-f[2] = integral.ccbcdocu.sdoact.
   END.
   ELSE DO:                                     /*saldo por vencer */
        IF integral.ccbcdocu.codmon = 1 THEN          /* Moneda = Soles */
            ASSIGN
                 w-report.campo-f[3] =  integral.ccbcdocu.sdoact.
        
        ELSE                                         /*Moneda = Dolares */
            ASSIGN
                     w-report.campo-f[4] = integral.ccbcdocu.sdoact.
   END.
   IF w-report.campo-C[3] = "N/C" THEN 
   ASSIGN
        w-report.campo-f[1] = -1 * w-report.campo-f[1]
        w-report.campo-f[2] = -1 * w-report.campo-f[2]
        w-report.campo-f[3] = -1 * w-report.campo-f[3]
        w-report.campo-f[4] = -1 * w-report.campo-f[4]
        w-report.campo-f[5] = -1 * w-report.campo-f[5]
        w-report.campo-f[6] = -1 * w-report.campo-f[6].
        
        
/*   IF w-report.campo-f[1] = 0.00 THEN w-report.campo-f[1] = ?.
   IF w-report.campo-f[2] = 0.00 THEN w-report.campo-f[2] = ?.
   IF w-report.campo-f[3] = 0.00 THEN w-report.campo-f[3] = ?.
   IF w-report.campo-f[4] = 0.00 THEN w-report.campo-f[4] = ?. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


