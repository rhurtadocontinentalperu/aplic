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
{cbd/cbglobal.i}
DEF SHARED VAR s-codcia AS INT.

/* Local Variable Definitions ---                                       */
DEF VAR x-Periodo LIKE s-Periodo.
DEF VAR x-NroMes LIKE s-NroMes.

DEF TEMP-TABLE T-CMOV LIKE CB-CMOV.
DEF TEMP-TABLE T-DMOV LIKE CB-DMOV.

DISABLE TRIGGERS FOR LOAD OF CB-CMOV.
DISABLE TRIGGERS FOR LOAD OF CB-DMOV.

DEF VAR t-CodCia AS INT.

t-CodCia = 100 + s-CodCia.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 COMBO-BOX-Meses Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-1 FILL-IN-Mensage FILL-IN-Periodo ~
COMBO-BOX-Meses 

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

DEFINE VARIABLE COMBO-BOX-Meses AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 45 BY 1.35
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensage AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47 BY 1.73.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     EDITOR-1 AT ROW 4.08 COL 6 NO-LABEL
     FILL-IN-Mensage AT ROW 6.19 COL 4 COLON-ALIGNED NO-LABEL
     FILL-IN-Periodo AT ROW 1.38 COL 13 COLON-ALIGNED
     COMBO-BOX-Meses AT ROW 2.35 COL 13 COLON-ALIGNED
     Btn_OK AT ROW 1.5 COL 52
     Btn_Cancel AT ROW 2.69 COL 52
     RECT-2 AT ROW 3.88 COL 5
     SPACE(13.13) SKIP(3.19)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "DISTRIBUCION DE ASIENTOS CONTABLES POR CENTRO DE COSTO"
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

/* SETTINGS FOR EDITOR EDITOR-1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Mensage IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Periodo IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* DISTRIBUCION DE ASIENTOS CONTABLES POR CENTRO DE COSTO */
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
  ASSIGN COMBO-BOX-Meses FILL-IN-Periodo.
  RUN Traslado.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
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
  DISPLAY EDITOR-1 FILL-IN-Mensage FILL-IN-Periodo COMBO-BOX-Meses 
      WITH FRAME D-Dialog.
  ENABLE RECT-2 COMBO-BOX-Meses Btn_OK Btn_Cancel 
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
  ASSIGN
    FILL-IN-Periodo = s-periodo
    EDITOR-1 = 'LOS MOVIMIENTOS CONTABLE VAN A SER DISTRIBUIDOS EN LA COMPAÑIA ' +
                STRING(t-CodCia, '999').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Traslado D-Dialog 
PROCEDURE Traslado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Periodo AS INT NO-UNDO.
  DEF VAR x-NroMes  AS INT NO-UNDO.
  
  x-Periodo = FILL-IN-Periodo.
  x-NroMes  = LOOKUP(COMBO-BOX-Meses, COMBO-BOX-Meses:LIST-ITEMS IN FRAME {&FRAME-NAME}).
  
  MESSAGE "Procedemos al traslado del periodo" x-periodo "del mes" x-nromes "a la cia." t-codcia "?"
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN 'ADM-ERROR'.
    
  /* BORRAMOS LA INFORMACION */
  FILL-IN-Mensage:SCREEN-VALUE = "Borrando informacion de la cia. " + STRING(t-codcia, '999') + " mes " + STRING(x-nromes, '99') +
    ' periodo ' + STRING(x-periodo, '9999').
  FOR EACH CB-CMOV WHERE cb-cmov.codcia = t-codcia
        AND cb-cmov.periodo = x-periodo
        AND cb-cmov.nromes   = x-nromes EXCLUSIVE-LOCK:
    DELETE CB-CMOV.
  END.        
  FOR EACH CB-DMOV WHERE cb-dmov.codcia = t-codcia
        AND cb-dmov.periodo = x-periodo
        AND cb-dmov.nromes   = x-nromes EXCLUSIVE-LOCK:
    DELETE CB-DMOV.
  END.        
  /* DISTRIBUIMOS LA INFORMACION */
  FOR EACH CB-CMOV NO-LOCK WHERE cb-cmov.codcia = s-codcia
        AND cb-cmov.periodo = x-periodo
        AND cb-cmov.nromes  = x-nromes:
    FILL-IN-Mensage:SCREEN-VALUE = "Operacion " + cb-cmov.codope + " - " + cb-cmov.nroast + " mes " + STRING(x-nromes, '99') +
        ' periodo ' + STRING(x-periodo, '9999').
    CREATE T-CMOV.
    BUFFER-COPY CB-CMOV TO T-CMOV
        ASSIGN T-CMOV.codcia = t-codcia.
    FOR EACH CB-DMOV OF CB-CMOV NO-LOCK:
        /* VERIFICAMOS EL CODIGO DE DISTRIBUCION */
        CASE CB-DMOV.Discco:
            WHEN 000        /* SIN DISTRIBUIR */
                THEN DO:
                    CREATE T-DMOV.
                    BUFFER-COPY CB-DMOV TO T-DMOV
                        ASSIGN T-DMOV.codcia = t-codcia.
                END.
            OTHERWISE       /* DISTRIBUIDO */
                DO:
                    FOR EACH CB-DISCC WHERE cb-discc.discco = cb-dmov.discco NO-LOCK:
                        CREATE T-DMOV.
                        BUFFER-COPY CB-DMOV TO T-DMOV
                            ASSIGN T-DMOV.codcia = t-codcia
                                    T-DMOV.ImpMn1 = CB-DMOV.ImpMn1 * CB-DISCC.Factor / 100
                                    T-DMOV.ImpMn2 = CB-DMOV.ImpMn2 * CB-DISCC.Factor / 100
                                    T-DMOV.ImpMn3 = CB-DMOV.ImpMn3 * CB-DISCC.Factor / 100.
                    END.                    
                END.
        END CASE.
    END.
  END.
  /* PASAMOS LA INFORMACION */
  FILL-IN-Mensage:SCREEN-VALUE = "Trasladando informacion, un momento por favor".
  FOR EACH T-CMOV:
    CREATE CB-CMOV.
    BUFFER-COPY T-CMOV TO CB-CMOV.
  END.
  FOR EACH T-DMOV:
    CREATE CB-DMOV.
    BUFFER-COPY T-DMOV TO CB-DMOV.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


