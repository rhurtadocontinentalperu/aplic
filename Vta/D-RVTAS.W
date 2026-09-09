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
DEFINE SHARED VAR S-CODDIV AS CHARACTER.

DEFINE NEW GLOBAL SHARED VAR S-task-no AS integer.

/* Parameters Definitions ---                                           */
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEF VAR RB-REPORT-LIBRARY AS CHAR.
RB-REPORT-LIBRARY = RUTA + "vta\rbvta.prl".


DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Registro de Venta.".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "O".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".



/* Local Variable Definitions ---                                       */
Define var tipo-doc as log.
DEF VAR subtit as char.
Define var x-nombre as char.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-40 x-docu Fechad numerod fechah numeroh ~
Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS x-docu Fechad numerod fechah numeroh 

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

DEFINE VARIABLE x-docu AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo documento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos ","N/C","N/D","FAC","BOL" 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE Fechad AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Periodo desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE fechah AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE numerod AS CHARACTER FORMAT "X(256)":U 
     LABEL "Documentos del" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE numeroh AS CHARACTER FORMAT "X(256)":U 
     LABEL "al" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-40
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45.29 BY 4.81.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     x-docu AT ROW 2.46 COL 17 COLON-ALIGNED
     Fechad AT ROW 3.69 COL 16.72 COLON-ALIGNED
     numerod AT ROW 5 COL 16.72 COLON-ALIGNED
     fechah AT ROW 3.69 COL 33.72 COLON-ALIGNED
     numeroh AT ROW 5 COL 33.72 COLON-ALIGNED
     Btn_OK AT ROW 1.69 COL 50
     Btn_Cancel AT ROW 4.19 COL 50
     RECT-40 AT ROW 1.65 COL 4
     "  Ingrese parametros" VIEW-AS TEXT
          SIZE 14.72 BY .62 AT ROW 1.23 COL 6.29
          BGCOLOR 1 FGCOLOR 15 
     SPACE(42.70) SKIP(5.22)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Registro de Ventas".

 

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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Registro de Ventas */
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
  ASSIGN x-docu fechad fechah numerod numeroh.
  IF x-docu = "" THEN DO:
  Message "Ingrese el tipo de documento" view-as alert-box.
  APPLY "ENTRY":U to x-docu.
  RETURN NO-APPLY.
  END.

  If fechad > fechah then do:
  Message "Rango de fechas mal ingresado" view-as alert-box.
  APPLY "ENTRY":U to fechad.
  RETURN NO-APPLY.
  END.

  RUN IMPRIMIR.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-inicial D-Dialog 
PROCEDURE carga-inicial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

Define var nrocli as char.
REPEAT:
        s-task-no = RANDOM(1,999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no
            NO-LOCK)
        THEN LEAVE.
END.

IF numerod <> ""  and numeroh <> "" THEN DO:
 FOR EACH integral.ccbcDocu where integral.CcbCDocu.CodCia = s-codcia and 
                        integral.ccbcDocu.coddoc = x-docu and
                        integral.ccbcDocu.fchdoc >= fechad and
                        integral.ccbcDocu.fchdoc <= fechah and
                        integral.ccbcDocu.nrodoc >= numerod and
                        integral.ccbcDocu.nrodoc <= numeroh AND
                        integral.ccbcDocu.flgest <> "A" :

    FIND integral.facdocum WHERE integral.facdocum.coddoc = integral.ccbcDocu.coddoc no-lock no-error.
    IF AVAILABLE integral.facdocum THEN  
            tipo-doc = integral.facdocum.tpodoc.
    FIND integral.gn-clie WHERE integral.gn-clie.codcli = integral.ccbcDocu.codcli no-lock no-error.
    IF AVAILABLE integral.gn-clie THEN  x-nombre = integral.gn-clie.nomcli.
    
    RUN CARGA1 .
 END.   
END.    

ELSE DO:
 FOR EACH integral.ccbcDocu where integral.CcbCDocu.CodCia = s-codcia and 
                        integral.ccbcDocu.coddoc = x-docu and
                        integral.ccbcDocu.fchdoc >= fechad and
                        integral.ccbcDocu.fchdoc <= fechah  and
                        integral.ccbcDocu.flgest <> "A" :
    FIND integral.facdocum WHERE integral.facdocum.coddoc = integral.ccbcDocu.coddoc no-lock no-error.
    IF AVAILABLE integral.facdocum THEN  
            tipo-doc = integral.facdocum.tpodoc.
    FIND integral.gn-clie WHERE integral.gn-clie.codcli = integral.ccbcDocu.codcli no-lock no-error.
    IF AVAILABLE integral.gn-clie THEN  x-nombre = integral.gn-clie.nomcli.
    
    RUN CARGA1 .
    
 END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga1 D-Dialog 
PROCEDURE Carga1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

     FIND first reporte.w-report where reporte.w-report.Task-No = s-task-no and
              reporte.w-report.llave-I =  integral.ccbcdocu.codcia and
              reporte.w-report.campo-c[1] = integral.ccbcdocu.coddoc and                  
              reporte.w-report.campo-c[2] = integral.ccbcdocu.nrodoc no-error.
     IF NOT AVAILABLE reporte.w-report THEN DO:
     create reporte.w-report.
        assign
            reporte.w-report.Task-No = s-task-no    
            reporte.w-report.llave-I =  integral.ccbcdocu.codcia 
            reporte.w-report.campo-c[1] = integral.ccbcdocu.coddoc
            reporte.w-report.campo-c[2] = integral.ccbcdocu.nrodoc
            reporte.w-report.campo-f[1] = integral.ccbcdocu.codmon
            reporte.w-report.llave-d = integral.ccbcdocu.fchdoc
            reporte.w-report.campo-c[3] = x-nombre.
     END.      
     IF ccbcdocu.codmon = 1 THEN DO:
      Assign             
            reporte.w-report.campo-f[2] = integral.ccbcdocu.impbrt  /* report = abono */
            reporte.w-report.campo-f[3] = integral.ccbcdocu.impdto
            reporte.w-report.campo-f[4] = integral.ccbcdocu.impigv
            reporte.w-report.campo-f[5] = integral.ccbcdocu.impvta
            reporte.w-report.campo-f[6] = integral.ccbcdocu.impbrt / integral.ccbcdocu.tpocmb  /* report = abono */
            reporte.w-report.campo-f[7] = integral.ccbcdocu.impdto / integral.ccbcdocu.tpocmb
            reporte.w-report.campo-f[8] = integral.ccbcdocu.impigv / integral.ccbcdocu.tpocmb
            reporte.w-report.campo-f[9] = integral.ccbcdocu.impvta / integral.ccbcdocu.tpocmb 
            reporte.w-report.campo-f[10] = integral.ccbcdocu.tpocmb .
    END.    
    ELSE DO:
    Assign
        reporte.w-report.campo-f[2] = integral.ccbcdocu.impbrt * ccbcdocu.tpocmb
        reporte.w-report.campo-f[3] = integral.ccbcdocu.impdto * ccbcdocu.tpocmb
        reporte.w-report.campo-f[4] = integral.ccbcdocu.impigv * ccbcdocu.tpocmb
        reporte.w-report.campo-f[5] = integral.ccbcdocu.impvta * ccbcdocu.tpocmb
        reporte.w-report.campo-f[6] = integral.ccbcdocu.impbrt  
        reporte.w-report.campo-f[7] = integral.ccbcdocu.impdto
        reporte.w-report.campo-f[8] = integral.ccbcdocu.impigv
        reporte.w-report.campo-f[9] = integral.ccbcdocu.impvta .

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
  DISPLAY x-docu Fechad numerod fechah numeroh 
      WITH FRAME D-Dialog.
  ENABLE RECT-40 x-docu Fechad numerod fechah numeroh Btn_OK Btn_Cancel 
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
  SUBTIT = "AL" + STRING(TODAY).

RUN  Carga-inicial.

    RB-FILTER = "w-report.task-no = " + STRING(S-TASK-NO).

    RB-OTHER-PARAMETERS = "GsNomCia = " + S-NOMCIA +
                         "~nGssubtit = " + subtit. /* + 
                         "~nGsgiro = " + x-giro. */


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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
assign
      FechaD:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(today).
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


