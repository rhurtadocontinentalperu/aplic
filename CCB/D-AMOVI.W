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

DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Analisis de Movimiento".
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

 Define var nombre as char.
 Define var nrocli as char.
 define var tipo-doc as log.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-38 x-docu x-nrodoc Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS x-docu x-nombre x-nrodoc 

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
     LABEL "Tipo de documento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 7.86 BY 1 NO-UNDO.

DEFINE VARIABLE x-nombre AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 16.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-nrodoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nro. documento" 
     VIEW-AS FILL-IN 
     SIZE 14.29 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-38
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 42.72 BY 3.69.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     x-docu AT ROW 2.73 COL 15.14 COLON-ALIGNED
     x-nombre AT ROW 2.81 COL 24.43 COLON-ALIGNED NO-LABEL
     x-nrodoc AT ROW 4.12 COL 16.14 COLON-ALIGNED
     Btn_OK AT ROW 1.62 COL 45.57
     Btn_Cancel AT ROW 4.19 COL 45.57
     RECT-38 AT ROW 1.85 COL 2
     "Ingrese los parametros" VIEW-AS TEXT
          SIZE 17.57 BY .73 AT ROW 1.46 COL 4.72
     SPACE(38.70) SKIP(4.57)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Analisis de Movimento".

 

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

/* SETTINGS FOR FILL-IN x-nombre IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Analisis de Movimento */
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
  assign x-docu x-nrodoc.
  If x-nrodoc <> "" then do:
    find ccbcdocu where integral.ccbcdocu.CodCia = s-codcia and
         ccbcdocu.coddoc = x-docu and
         ccbcdocu.nrodoc = x-nrodoc no-lock no-error.
    if not available ccbcdocu then do:
        Message "El Nro. de documento no existe ingrese otro" view-as alert-box.
        apply "entry":U to x-nrodoc.
        return no-apply.
    end.
  end.
  else do:
    message "Ingrese el numero de documento" view-as alert-box.
    apply "entry":U to x-nrodoc.
    return no-apply.
  end.
  
  RUN IMPRIMIR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-docu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-docu D-Dialog
ON VALUE-CHANGED OF x-docu IN FRAME D-Dialog /* Tipo de documento */
DO:
  If x-docu:screen-value <> "" then do :
  Find first integral.ccbcdocu where integral.ccbcdocu.CodCia = s-codcia and 
                   ccbcdocu.coddoc = x-docu:screen-value No-Lock No-Error.
    If not available ccbcdocu then do:
        Message "Tipo de documento no existe" view-as alert-box.
        apply "entry":U to x-docu.
        return no-apply.
    end.
    Find facdocum where facdocum.codcia = s-codcia and
                        facdocum.coddoc = x-docu:screen-value no-lock no-error.
    If available facdocum then
          x-nombre:screen-value = facdocum.nomdoc.
  End.
  Else do:
    Message "Ingrese el Tipo de documento" view-as alert-box.
    return no-apply.
  end. 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-b D-Dialog 
PROCEDURE carga-b :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 Define var nombre as char.
 Define var nrocli as char.
FIND integral.ccbdcaja WHERE integral.ccbdcaja.coddoc = x-docu and
                         integral.ccbdcaja.nrodoc = x-nrodoc no-lock no-error.
      IF AVAILABLE integral.ccbdcaja THEN DO:
        FIND first reporte.w-report where reporte.w-report.Task-No = s-task-no and
                  reporte.w-report.llave-I =  integral.ccbdcaja.codcia and
                  reporte.w-report.campo-c[1] = integral.ccbdcaja.coddoc and                  
                  reporte.w-report.campo-c[2] = integral.ccbdcaja.nrodoc no-error.
          IF NOT AVAILABLE reporte.w-report THEN DO:
            create reporte.w-report.
            assign
                reporte.w-report.Task-No = s-task-no    
                reporte.w-report.llave-I =  integral.ccbdcaja.codcia 
                reporte.w-report.campo-c[1] = integral.ccbdcaja.coddoc
                reporte.w-report.campo-c[2] = integral.ccbdcaja.nrodoc
                reporte.w-report.campo-c[3] = x-docu
                reporte.w-report.campo-c[4] = x-nrodoc
/*                reporte.w-report.campo-c[3] = integral.ccbdcaja.codref
                reporte.w-report.campo-c[4] = integral.ccbdcaja.nroref */
                reporte.w-report.campo-f[1] = integral.ccbdcaja.codmon
                reporte.w-report.llave-d = integral.ccbdcaja.fchdoc
                reporte.w-report.campo-f[3] = integral.ccbdcaja.imptot  /* report = abono */
                reporte.w-report.campo-c[5] = integral.ccbdcaja.codcli  /*nrocli*/
                reporte.w-report.campo-c[6] = nombre
                reporte.w-report.campo-c[7] = integral.ccbcDocu.flgest
                reporte.w-report.campo-d[1] = integral.ccbcDocu.fchdoc
                reporte.w-report.campo-d[2] = integral.ccbcDocu.fchvto
                reporte.w-report.campo-f[4] = integral.ccbcDocu.sdoact
                reporte.w-report.campo-f[5] = integral.ccbcDocu.imptot
                reporte.w-report.campo-f[6] = integral.ccbcDocu.codmon.
          END.
      END.     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-inicial D-Dialog 
PROCEDURE Carga-inicial :
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

 FOR EACH integral.ccbcDocu where integral.CcbCDocu.CodCia = s-codcia and 
                        integral.ccbcDocu.coddoc = x-docu and
                        integral.ccbcDocu.nrodoc = x-nrodoc :
    nrocli = integral.ccbcDocu.codcli.                    

    FIND integral.facdocum WHERE integral.facdocum.coddoc = integral.ccbcDocu.coddoc no-lock no-error.
    IF AVAILABLE integral.facdocum THEN  
            tipo-doc = integral.facdocum.tpodoc.
    FIND integral.gn-clie WHERE integral.gn-clie.codcli = integral.ccbcDocu.codcli no-lock no-error.
    IF AVAILABLE integral.gn-clie THEN  
    ASSIGN nombre = integral.gn-clie.nomcli.
    
    IF tipo-doc = yes THEN DO:   /*  tipo de documento = cargo */
    
      FIND integral.ccbdcaja WHERE integral.ccbdcaja.codcia = s-codcia and
                         integral.ccbdcaja.codref = x-docu and
                         integral.ccbdcaja.nroref = x-nrodoc no-lock no-error.
      IF AVAILABLE integral.ccbdcaja THEN DO:
        FIND first reporte.w-report where reporte.w-report.Task-No = s-task-no and
                  reporte.w-report.llave-I =  integral.ccbdcaja.codcia and
                  reporte.w-report.campo-c[1] = integral.ccbdcaja.coddoc and                  
                  reporte.w-report.campo-c[2] = integral.ccbdcaja.nrodoc no-error.
          IF NOT AVAILABLE reporte.w-report THEN DO:
            create reporte.w-report.
            assign
                reporte.w-report.Task-No = s-task-no    
                reporte.w-report.llave-I =  integral.ccbdcaja.codcia 
                reporte.w-report.campo-c[1] = integral.ccbdcaja.coddoc
                reporte.w-report.campo-c[2] = integral.ccbdcaja.nrodoc
                reporte.w-report.campo-c[3] = integral.ccbdcaja.codref
                reporte.w-report.campo-c[4] = integral.ccbdcaja.nroref
                reporte.w-report.campo-f[1] = integral.ccbdcaja.codmon
                reporte.w-report.llave-d = integral.ccbdcaja.fchdoc
                reporte.w-report.campo-f[2] = integral.ccbdcaja.imptot  /* report = cargo */
                reporte.w-report.campo-c[5] = integral.ccbcDocu.codcli /*nrocli*/
                reporte.w-report.campo-c[6] = nombre
                reporte.w-report.campo-c[7] = integral.ccbcDocu.flgest
                reporte.w-report.campo-d[1] = integral.ccbcDocu.fchdoc
                reporte.w-report.campo-d[2] = integral.ccbcDocu.fchvto
                reporte.w-report.campo-f[4] = integral.ccbcDocu.sdoact
                reporte.w-report.campo-f[5] = integral.ccbcDocu.imptot
                reporte.w-report.campo-c[8] = integral.ccbcDocu.flgubi
                reporte.w-report.campo-c[9] = integral.ccbcDocu.flgsit
                reporte.w-report.campo-c[10] = integral.ccbcDocu.codcta.

          END.    
        
      END.
      ELSE   /* busca en ccbcdocu */
         RUN detalle.
      
      /* Message "Documento no cancelado" view-as alert-box.*/

    END.     /*fin  tipo de documento cargo */
    
    ELSE DO:
          RUN carga-b.  /* tipo de documento = Abono */
    END.
 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE detalle D-Dialog 
PROCEDURE detalle :
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
                reporte.w-report.campo-c[5] = integral.ccbcdocu.codcli /*nrocli*/
                reporte.w-report.campo-c[6] = nomcli
                reporte.w-report.campo-f[1] = integral.ccbcdocu.codmon
                reporte.w-report.campo-c[7] = integral.ccbcDocu.flgest
                reporte.w-report.campo-d[1] = integral.ccbcDocu.fchdoc
                reporte.w-report.campo-d[2] = integral.ccbcDocu.fchvto
                reporte.w-report.campo-f[4] = integral.ccbcDocu.sdoact
                reporte.w-report.campo-f[5] = integral.ccbcDocu.imptot
                reporte.w-report.campo-c[8] = integral.ccbcDocu.flgubi
                reporte.w-report.campo-c[9] = integral.ccbcDocu.flgsit
                reporte.w-report.campo-c[10] = integral.ccbcDocu.codcta.

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
  DISPLAY x-docu x-nombre x-nrodoc 
      WITH FRAME D-Dialog.
  ENABLE RECT-38 x-docu x-nrodoc Btn_OK Btn_Cancel 
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
        xx = x-docu:add-last(facdocum.coddoc) .
    end.  

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


