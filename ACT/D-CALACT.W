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

DEFINE SHARED VAR s-CodCia  AS INTEGER.
DEFINE SHARED VAR s-Periodo AS INTEGER.
DEFINE SHARED VAR s-NroMes  AS INTEGER.
DEFINE SHARED VAR cb-CodCia AS INTEGER.

DEFINE VAR i       AS INTEGER.
DEFINE VAR vFactor AS DECIMAL EXTENT 12.
DEFINE VAR vFacAnt As DECIMAL.

DEFINE VAR x-Indice AS DECIMAL.
DEFINE VAR LINEA AS CHAR NO-UNDO.
DEFINE VAR OK-STATUS AS LOGICAL NO-UNDO.

  IF s-NroMes = 0 OR s-NroMes = 13 THEN DO :
     MESSAGE ' No se puede realizar este proceso ' VIEW-AS ALERT-BOX.
     RETURN ERROR.
  END.
  
  FIND FIRST aj-inme WHERE aj-inme.Periodo = s-Periodo NO-LOCK NO-ERROR.  
  IF NOT AVAILABLE aj-inme THEN DO :
     MESSAGE "No se ha Registrado los Indices " SKIP
             "para el a¤o " + STRING (s-periodo,"9,999")
             VIEW-AS ALERT-BOX.
     RETURN ERROR.
  END.
    
  IF aj-inme.Indice[s-NroMes] = 0 THEN DO :
     MESSAGE "No se ha Registrado el Indice " SKIP
             "del Mes " + STRING (s-NroMes,"99") + " A¤o " + STRING (s-periodo,"9,999")
             VIEW-AS ALERT-BOX.                
     RETURN ERROR.
  END.
     
  vfactor[s-NroMes] = 1.
  x-Indice          = aj-inme.Indice[s-NroMes].
  
  DO i = 1 TO s-NroMes - 1 :     
     IF aj-inme.Indice[i] = 0 THEN DO :
        MESSAGE "No se ha Registrado el Indice " SKIP
                "del Mes " + STRING (i,"99") + " A¤o " + STRING (s-periodo,"9,999")
                VIEW-AS ALERT-BOX.                
        RETURN ERROR.
     END.
     vfactor[i] = ROUND ( x-Indice / aj-inme.Indice[i] , 3 ).
  END.
  
  /* CALCULANDO EL INDICE DEL A¥O ANTERIOR                     */
  
  FIND aj-inme WHERE aj-inme.Periodo = s-Periodo - 1 AND 
          aj-inme.Indice[12] <> 0
          NO-LOCK NO-ERROR.    
  IF NOT AVAILABLE aj-inme THEN DO :
     MESSAGE "No se ha Registrado el Indice " SKIP
             "del Mes " + STRING (12,"99") + " A¤o " + STRING (s-periodo - 1,"9,999")
             VIEW-AS ALERT-BOX.                
     RETURN ERROR.
  END.
  
  vFacAnt = ROUND ( x-Indice / aj-inme.Indice[12] , 3 ).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 E-EDITOR B-Procesa Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-1 E-EDITOR F-NroMes F-periodo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-Procesa 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Procesa" 
     SIZE 12 BY 1.54.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE VARIABLE E-EDITOR AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 59 BY 4.81 NO-UNDO.

DEFINE VARIABLE EDITOR-1 AS CHARACTER INITIAL "Este proceso tiene por finalidad procesar las partidas registradas y asi calcular su Ajuste y su Depreciaci¢n. Este proceso debe ser el unico que se este ejecutando." 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 60 BY 1.35 NO-UNDO.

DEFINE VARIABLE F-NroMes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81
     FONT 0 NO-UNDO.

DEFINE VARIABLE F-periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 6.43 BY .81
     FONT 0 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 60 BY 5.19.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     EDITOR-1 AT ROW 3.12 COL 2.43 NO-LABEL
     E-EDITOR AT ROW 4.65 COL 3 NO-LABEL
     F-NroMes AT ROW 2.15 COL 6.86 COLON-ALIGNED
     F-periodo AT ROW 2.15 COL 28.29 COLON-ALIGNED
     B-Procesa AT ROW 9.85 COL 37
     Btn_Cancel AT ROW 9.85 COL 50.86
     "Calculo de Ajuste y Depreciaci¢n de Activos" VIEW-AS TEXT
          SIZE 51.43 BY .77 AT ROW 1.19 COL 1.72
          FONT 0
     RECT-2 AT ROW 4.46 COL 2.43
     SPACE(1.70) SKIP(2.03)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Activos Fijos".

 

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

ASSIGN 
       E-EDITOR:AUTO-RESIZE IN FRAME D-Dialog      = TRUE
       E-EDITOR:READ-ONLY IN FRAME D-Dialog        = TRUE.

/* SETTINGS FOR EDITOR EDITOR-1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NroMes IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-periodo IN FRAME D-Dialog
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Activos Fijos */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Procesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Procesa D-Dialog
ON CHOOSE OF B-Procesa IN FRAME D-Dialog /* Procesa */
DO:
  RUN PROCESA.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AJUS-DEPR D-Dialog 
PROCEDURE AJUS-DEPR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR nFactor   AS DECIMAL.
DEFINE VAR x-ValAjt  AS DECIMAL.
DEFINE VAR x-ValAjtA AS DECIMAL.
DEFINE VAR x-ValAjtM AS DECIMAL.
DEFINE VAR x-DpHisA  AS DECIMAL.
DEFINE VAR x-DpHisM  AS DECIMAL.
DEFINE VAR x-DpAjtA  AS DECIMAL.
DEFINE VAR x-DpAjtM  AS DECIMAL.
DEFINE VAR x-Rei     AS DECIMAL.
DEFINE VAR x-Tasa    AS DECIMAL.
DEFINE VAR x-NMeses  AS INTEGER.
DEFINE VAR x-ValAct  AS DECIMAL.
DEFINE VAR x-DpAcum  AS DECIMAL.
DEFINE VAR x-DpAcAju AS DECIMAL.

DEFINE VAR x-CodCta  AS CHAR.
DEFINE VAR x-CodPar  AS CHAR.
DEFINE VAR x-CodDiv  AS CHAR.
DEFINE VAR x-CodMov  AS CHAR.

FOR EACH AC-PARTI WHERE AC-PARTI.CodCia = s-CodCia BY AC-PARTI.CodPar :
    
    IF AC-PARTI.FchIngr < TODAY  AND AC-PARTI.TpoCal < 3  THEN DO :

        LINEA = ac-parti.CodPar + " >> " + ac-parti.DesPar + CHR(10).
        OK-STATUS = E-EDITOR:INSERT-STRING( LINEA ) IN FRAME {&FRAME-NAME}.
            
        x-ValAjt  = 0.
        x-ValAjtA = 0.
        x-ValAjtM = 0.
        x-DpHisA  = 0.
        x-DpHisM  = 0.
        x-DpAjtA  = 0.
        x-DpAjtM  = 0.
        x-Rei     = 0.
        x-Tasa    = 0.
        x-NMeses  = 0.
        x-ValAct  = 0.
        x-DpAcum  = 0.
        x-DpAcAju = 0.
        
        x-CodCta = AC-PARTI.CodCta. 
        x-CodPar = AC-PARTI.CodPar.
        x-CodDiv = AC-PARTI.CodDiv.
        x-CodMov = AC-PARTI.CodMov.
        
        IF YEAR ( AC-PARTI.FchIngr ) < s-Periodo THEN DO :
           nFactor   = vFacAnt.
           x-ValAct  = AC-PARTI.ValAjusMn1.       
           x-ValAjt  = nFactor  * x-ValAct.
           x-ValAjtA = x-ValAjt - x-ValAct.
           IF MONTH ( AC-PARTI.FchCese ) = s-NroMes THEN DO :
              x-ValAjt = 0.
           END.       
        END.
        ELSE DO :
           nFactor   = vFactor[ MONTH(AC-PARTI.FchIngr) ].
           x-ValAct  = AC-PARTI.ValCmpMn1.
           x-ValAjt  = nFactor  * x-ValAct.
           x-ValAjtA = x-ValAjt - x-ValAct.
           IF MONTH ( AC-PARTI.FchCese ) = s-NroMes THEN DO :
              x-ValAjt = 0.
           END.       
        END.
    
        IF AC-PARTI.TpoCal <> 2 THEN DO :
            
            /* CALCULANDO LA DEPRECIACION       */
            
            IF AC-PARTI.FchDepr < TODAY THEN DO :
               IF YEAR (AC-PARTI.FchDepr) < s-periodo THEN DO :
                  x-NMeses = s-NroMes.
               END.   
               ELSE DO :
                  x-NMeses = s-NroMes - MONTH ( AC-PARTI.FchDepr ) + 1.
               END.   
            END.
            
            x-Tasa = x-NMeses * ( AC-PARTI.PorDep / 1200 ).
                
            x-DpHisA = ROUND ( x-ValAct * x-Tasa, 2 ).
                
            x-DpAjtA = ROUND ( x-ValAjt * x-Tasa, 2 ).
    
        END.
        
        /* Buscando Los Calculos Anteriores    */
        
        FIND LAST AC-RPAR WHERE AC-RPAR.CodCia = s-CodCia AND AC-RPAR.CodDiv = x-CodDiv AND
                                AC-RPAR.CodCta = x-CodCta AND AC-RPAR.CodPar = x-CodPar AND
                                AC-RPAR.CodMov = x-CodMov AND AC-RPAR.NroMes < s-NroMes 
                                NO-LOCK NO-ERROR.
        
        IF AVAILABLE AC-RPAR THEN DO :
           x-ValAjtM = x-ValAjtA - AC-RPAR.ValAjtA.
           x-DpHisM  = x-DpHisA  - AC-RPAR.DpHisA.
           x-DpAjtM  = x-DpAjtA  - AC-RPAR.DpAjtA.
        END.   
        ELSE DO :
           x-ValAjtM = x-ValAjtA.
           x-DpHisM  = x-DpHisA.
           x-DpAjtM  = x-DpAjtA.
        END.   
                            
        CREATE AC-RPAR.
        
        AC-RPAR.CodCia  = s-CodCia. 
        AC-RPAR.NroMes  = s-NroMes. 
        AC-RPAR.MesPro  = x-NMeses.
        AC-RPAR.Periodo = s-Periodo. 
        AC-RPAR.CodCta  = x-CodCta. 
        AC-RPAR.CodPar  = x-CodPar.
        AC-RPAR.CodDiv  = x-CodDiv.
        AC-RPAR.CodMov  = x-CodMov.
        AC-RPAR.Factor  = nFactor.
        AC-RPAR.ValHis  = x-ValAct.
        AC-RPAR.ValAjt  = x-ValAjt.
        AC-RPAR.ValAjtA = x-ValAjtA.    
        AC-RPAR.ValAjtM = x-ValAjtM.
        AC-RPAR.DpHisA  = x-DpHisA.
        AC-RPAR.DpHisM  = x-DpHisM.
        AC-RPAR.DpAjtA  = x-DpAjtA.    
        AC-RPAR.DpAjtM  = x-DpAjtM.
        AC-RPAR.DpAcum  = x-DpAcum. 
        AC-RPAR.DpAcAju = x-DpAcAju.
        AC-RPAR.Rei     = x-ValAjtM.
        
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
  DISPLAY EDITOR-1 E-EDITOR F-NroMes F-periodo 
      WITH FRAME D-Dialog.
  ENABLE RECT-2 E-EDITOR B-Procesa Btn_Cancel 
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  /* Calculando los Indices y los Factores a Calcular          */
  
  F-NroMes:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = STRING(s-NroMes).
  F-Periodo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(s-Periodo).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESA D-Dialog 
PROCEDURE PROCESA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* BARREMOS LAS PARTIDAS EXISTENTES EN LA BASE DE DATOS   */

/* BORRAMOS LOS CAMPOS PARA VOLVER A CALCULAR  */

LINEA = LINEA + "Eliminando Movimientos generados del Mes ... " + CHR(10).
OK-STATUS = E-EDITOR:INSERT-STRING( LINEA ) IN FRAME {&FRAME-NAME}.
  
FOR EACH AC-RPAR WHERE AC-RPAR.CodCia  = s-CodCia  AND 
                       AC-RPAR.periodo = s-periodo AND 
                       AC-RPAR.NroMes  = s-NroMes :    
    DELETE AC-RPAR.
END.

RUN AJUS-DEPR.

LINEA = LINEA + "Proceso Concluido ... " + CHR(10).
OK-STATUS = E-EDITOR:INSERT-STRING( LINEA ) IN FRAME {&FRAME-NAME}.

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


