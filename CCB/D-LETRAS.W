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
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE NEW GLOBAL SHARED VAR S-task-no AS integer.

DEFINE VAR I-TPOREP AS INTEGER INIT 1.

/* Parameters Definitions ---                                           */

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "".
GET-KEY-VALUE SECTION "Startup" KEY "Base" VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb\rbccb.prl".

DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Reporte de Letras".
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
DEFINE VAR sub-tit1 AS CHARACTER.
DEFINE VAR sub-tit2 AS CHARACTER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-22 RECT-23 RECT-31 x-estado fechaD ~
fechaH x-ubicacion x-tipo Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS x-estado fechaD fechaH x-ubicacion X-Banco ~
x-tipo 

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
     SIZE 12 BY 1.58
     BGCOLOR 8 .

DEFINE VARIABLE fechaD AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Fecha Desde" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .81 NO-UNDO.

DEFINE VARIABLE fechaH AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Fecha Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE X-Banco AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .81 NO-UNDO.

DEFINE VARIABLE x-tipo AS DECIMAL FORMAT ">>,>>9.99":U INITIAL 0 
     LABEL "Tipo de Cambio" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-estado AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Letras Vencidas", 1,
"Letras por Vencer", 2
     SIZE 33.29 BY .81 NO-UNDO.

DEFINE VARIABLE x-ubicacion AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Cartera", "C",
"Banco", "B"
     SIZE 22.72 BY .85 NO-UNDO.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 48.57 BY 5.62.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 39.72 BY 1.85.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 48.43 BY 1.73.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     x-estado AT ROW 2.04 COL 10.86 NO-LABEL
     fechaD AT ROW 4.04 COL 12.57 COLON-ALIGNED
     fechaH AT ROW 4.04 COL 35.86 COLON-ALIGNED
     x-ubicacion AT ROW 6.27 COL 7.29 NO-LABEL
     X-Banco AT ROW 6.19 COL 31.14 COLON-ALIGNED NO-LABEL
     x-tipo AT ROW 7.85 COL 15.86 COLON-ALIGNED
     Btn_OK AT ROW 9.5 COL 12.57
     Btn_Cancel AT ROW 9.5 COL 31.14
     RECT-22 AT ROW 3.42 COL 2.72
     RECT-23 AT ROW 1.5 COL 7.14
     RECT-31 AT ROW 5.77 COL 2.72
     "Tipo de Reporte" VIEW-AS TEXT
          SIZE 18.86 BY .73 AT ROW 1.19 COL 8.43
          FONT 0
     SPACE(26.27) SKIP(9.58)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "".

 

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

/* SETTINGS FOR FILL-IN X-Banco IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog
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
  ASSIGN fechaD fechaH x-estado x-tipo x-banco.
  IF FechaD = ? OR FechaH = ?
  THEN DO:
    MESSAGE "Ingrese completo el rango de fechas" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY":U TO FechaD.
    RETURN NO-APPLY.
  END.
  IF FechaH < FechaD
  THEN DO:
    MESSAGE "Rango de fechas mal registrado" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY":U TO FechaD.
    RETURN NO-APPLY.
  END.
  
  IF x-tipo <= 0.00 THEN DO:
    MESSAGE "Ingrese el tipo de cambio" VIEW-AS ALERT-BOX.
    APPLY "ENTRY":U TO x-tipo.
    RETURN NO-APPLY.
  END.

  RUN imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME X-Banco
&Scoped-define SELF-NAME x-estado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-estado D-Dialog
ON VALUE-CHANGED OF x-estado IN FRAME D-Dialog
DO:
  case x-estado:screen-value:
   when "1" then
     I-TPOREP = 1 .

   when "2" then
     I-TPOREP = 2 .
  end case.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-ubicacion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-ubicacion D-Dialog
ON VALUE-CHANGED OF x-ubicacion IN FRAME D-Dialog
DO:
  assign x-ubicacion. 
  if x-ubicacion = "B" then 
   x-banco:sensitive = yes.
  else 
   x-banco:sensitive = no.
  
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

FOR EACH ccbcDocu WHERE CcbCDocu.CodCia = s-codcia AND
            ccbcdocu.coddoc = "LET" AND
            ccbcDocu.fchvto >= fechaD AND
            ccbcDocu.fchvto <= fechaH AND 
            ccbcDocu.flgest = "P" AND
            ccbcDocu.flgubi = x-ubicacion :
            
  CASE I-TPOREP : 
    WHEN 1 THEN do:

        IF ccbcdocu.fchvto < TODAY  THEN
        RUN proceso1.
    END.
    WHEN 2 THEN do:

       IF ccbcdocu.fchvto > TODAY THEN
       run proceso1.
    END.   
  END CASE.      
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
  DISPLAY x-estado fechaD fechaH x-ubicacion X-Banco x-tipo 
      WITH FRAME D-Dialog.
  ENABLE RECT-22 RECT-23 RECT-31 x-estado fechaD fechaH x-ubicacion x-tipo 
         Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir D-Dialog 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN carga-data.
    
/*FIND reporte.w-report where reporte.w-report.task-no = s-task-no AND
        reporte.w-report.llave-I = s-codcia  no-lock no-error.
if not available reporte.w-report then do:
    Message "No existen registros" view-as alert-box error.
    return "adm-error".
end.*/

    IF I-TPOREP = 1 then 
        sub-tit1 = "VENCIDAS".
    ELSE      
        sub-tit1 = "POR VENCER".

    sub-tit2 = "del  " + STRING(fechaD) + "  al  " + STRING(fechah).    
    
    
    RB-FILTER = "w-report.task-no = " + STRING(S-TASK-NO) +
                " AND w-report.llave-I = " + STRING(s-codcia) +
                " AND w-report.campo-c[6] = '" + x-ubicacion + "'". 
    
    IF X-BANCO <> "" THEN
    RB-FILTER = RB-FILTER + " AND w-report.campo-c[8] = '" + X-BANCO + "'".
                    

    RB-OTHER-PARAMETERS = "GsNomCia = " + S-NOMCIA +
                          "~nsub-tit1 = " + sub-tit1 +
                          "~nsub-tit2 = " + sub-tit2 .
                          

    RUN lib\_imprime.r(RB-REPORT-LIBRARY, RB-REPORT-NAME,
        RB-INCLUDE-RECORDS, RB-FILTER, RB-OTHER-PARAMETERS).            
                        
DELETE FROM reporte.W-Report WHERE reporte.w-report.Task-No = S-task-no.


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
  ASSIGN

    FechaD:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY)
    fechaH:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY).
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proceso1 D-Dialog 
PROCEDURE proceso1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND  reporte.w-report where reporte.w-report.Task-No = s-task-no and
                  reporte.w-report.llave-I = integral.ccbcDocu.codcia and
                  reporte.w-report.campo-c[4] = integral.ccbcDocu.nrodoc no-error.
    IF NOT AVAILABLE reporte.w-report THEN DO:
  
        create reporte.w-report.
        assign
            reporte.w-report.Task-No = s-task-no    
            reporte.w-report.llave-I =  ccbcDocu.codcia 
            reporte.w-report.campo-c[1] = ccbcdocu.codcli            
            reporte.w-report.campo-c[3] = ccbcdocu.coddoc
            reporte.w-report.campo-c[4] = ccbcdocu.nrodoc
            reporte.w-report.campo-d[1] = ccbcdocu.fchdoc
            reporte.w-report.llave-d = ccbcdocu.fchvto
            reporte.w-report.campo-c[5] = ccbcdocu.flgsit
            reporte.w-report.campo-c[6] = ccbcdocu.flgubi
            reporte.w-report.campo-c[7] = ccbcdocu.coddoc
            w-report.campo-f[3] = x-tipo.            
            
            IF X-BANCO <> "" THEN
            reporte.w-report.campo-c[8] = ccbcdocu.codcta.

        FIND FIRST integral.gn-clie where integral.gn-clie.codcli = integral.ccbcdocu.codcli no-lock no-error.
        IF available integral.gn-clie THEN  ASSIGN reporte.w-report.campo-c[2] = integral.gn-clie.nomcli.
        ELSE ASSIGN reporte.w-report.campo-c[2] = "".
    
    END.
    IF integral.ccbcdocu.codmon = 1 THEN         /* Moneda = Soles */
        ASSIGN w-report.campo-f[1] =  ccbcdocu.sdoact.
    ELSE                                        /*Moneda = Dolares*/
        ASSIGN w-report.campo-f[2] =  ccbcdocu.sdoact.
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
        WHEN "x-banco" THEN ASSIGN input-var-1 = "104".
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


