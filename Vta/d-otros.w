&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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

DEFINE INPUT PARAMETER X-ROWID AS ROWID.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.

define var x-imptot as deci .
define var x-vcto as date.
FIND CcbcDocu WHERE ROWID(Ccbcdocu) = X-ROWID NO-ERROR.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

x-imptot = ccbcdocu.imptot.
x-vcto = ccbcdocu.fchvto.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-49 RECT-22 Btn_OK f-imptot f-vcto ~
Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS f-imptot f-vcto 

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
     SIZE 12 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     IMAGE-UP FILE "img\ayuda":U
     LABEL "A&yuda" 
     SIZE 12 BY 1.65
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.62
     BGCOLOR 8 .

DEFINE VARIABLE f-imptot AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Importe" 
     VIEW-AS FILL-IN 
     SIZE 12.72 BY .81 NO-UNDO.

DEFINE VARIABLE f-vcto AS DATE FORMAT "99/99/9999":U 
     LABEL "Vencimiento" 
     VIEW-AS FILL-IN 
     SIZE 10.86 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25.72 BY 2.62.

DEFINE RECTANGLE RECT-49
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 14.29 BY 5.62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     Btn_OK AT ROW 1.81 COL 33.57
     f-imptot AT ROW 1.92 COL 26.15 RIGHT-ALIGNED
     f-vcto AT ROW 2.85 COL 12.57 COLON-ALIGNED
     Btn_Cancel AT ROW 3.58 COL 33.57
     Btn_Help AT ROW 5.35 COL 33.72
     RECT-49 AT ROW 1.58 COL 32.14
     RECT-22 AT ROW 1.58 COL 2.72
     SPACE(19.27) SKIP(3.06)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Modificaciones Especiales".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN f-imptot IN FRAME D-Dialog
   ALIGN-R                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Modificaciones Especiales */
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


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  DEF VAR X-ROU AS DECI INIT 0.09.
  FIND FACCFGGN WHERE Faccfggn.Codcia = S-CODCIA  NO-LOCK NO-ERROR.
  
  
  X-imptot = CCbcDocu.ImpTot.

  /*IF ABSOLUTE(DECIMAL(F-Imptot:SCREEN-VALUE) - CcbcDocu.ImpTot2 ) > Faccfggn.Roundocu  THEN DO: */
  /*IF ABSOLUTE(DECIMAL(F-Imptot:SCREEN-VALUE) - X-imptot ) > 0.09  THEN DO:*/
  IF ABSOLUTE(DECIMAL(F-Imptot:SCREEN-VALUE) - CcbcDocu.SdoAct ) > Faccfggn.Roundocu  THEN DO: 
      MESSAGE  "Importe Original : " +  STRING(CcbcDocu.SdoAct,">>>,>>>,>>9.99")  SKIP
               "Redondeo Máximo Autorizado " + STRING(Faccfggn.Roundocu,">>9.9999") SKIP
               "Vuelva a Intentar" VIEW-AS ALERT-BOX TITLE "Error Por Redondeo".
                F-Imptot:SCREEN-VALUE = STRING(X-imptot,"->>>,>>>,>>9.99").
                RETURN NO-APPLY.
/*       MESSAGE  "Importe Original : " +  string(CcbcDocu.ImpTot2,">>>,>>>,>>9.99")  SKIP  */
/*                "Redondeo Máximo Autorizado " + string(Faccfggn.Roundocu,">>9.9999") SKIP */
/*                "Vuelva a Intentar" VIEW-AS ALERT-BOX TITLE "Error Por Redondeo".         */
/*                 F-Imptot:SCREEN-VALUE = STRING(X-imptot,"->>>,>>>,>>9.99").              */
/*                 RETURN NO-APPLY.                                                         */
      /*          
      MESSAGE  "Importe Original : " +  string(x-imptot,">>>,>>>,>>9.99")  SKIP
               "Redondeo Máximo Autorizado " + string(X-ROU,">>9.9999") SKIP
               "Vuelva a Intentar" VIEW-AS ALERT-BOX TITLE "Error Por Redondeo".
                F-Imptot:SCREEN-VALUE = STRING(X-imptot,"->>>,>>>,>>9.99").
                RETURN NO-APPLY.
      */
  END.
  
  X-vcto = CCbcDocu.fchvto.
  
  FIND GN-CONVT WHERE GN-CONVT.CODIG = CCBCDOCU.FMAPGO NO-LOCK NO-ERROR.
 
  IF NOT AVAILABLE GN-CONVT THEN DO:
      MESSAGE  "Forma de Pago No Registrado"
               "Revise Configuracion de Formas de Pago" VIEW-AS ALERT-BOX TITLE "Error" .
                RETURN NO-APPLY.
  END.  
    
/*     IF Ccbcdocu.FchDoc + Gn-Convt.Totdias + Faccfggn.TolVen < DATE(F-vcto:SCREEN-VALUE)  THEN DO: */
/*                                                                                                   */
/* /*  IF Ccbcdocu.FchDoc + Gn-Convt.Totdias + 7 < DATE(F-vcto:SCREEN-VALUE)  THEN DO: */            */
/*                                                                                                   */
/*       MESSAGE  "Ampliacion de Vencimiento Incorrecto " SKIP                                       */
/*                "Máximo Numero de Días Autorizado " + string(Faccfggn.TolVen,"999") SKIP           */
/*                "Vuelva a Intentar" VIEW-AS ALERT-BOX TITLE "Error Por Vencimiento".               */
/*                 F-Vcto:SCREEN-VALUE = STRING(X-vcto,"99/99/9999").                                */
/*                 RETURN NO-APPLY.                                                                  */
/*       /*                                                                                          */
/*       MESSAGE  "Ampliacion de Vencimiento Incorrecto " SKIP                                       */
/*                "Máximo Numero de Días Autorizado " + string(7,"999") SKIP                         */
/*                "Vuelva a Intentar" VIEW-AS ALERT-BOX TITLE "Error Por Vencimiento".               */
/*                 F-Vcto:SCREEN-VALUE = STRING(X-vcto,"99/99/9999").                                */
/*                 RETURN NO-APPLY.                                                                  */
/*       */                                                                                          */
/*   END.                                                                                            */

  
   ASSIGN CCbcDocu.ImpTot = DECIMAL(F-Imptot:SCREEN-VALUE) 
          CCbcDocu.SdoAct = CCbcDocu.ImpTot 
          CCbcDocu.ImpVta = ( CCbcDocu.ImpTot / ( 1 + FacCfgGn.PorIgv / 100 ) )
          CCbcDocu.ImpIgv = CCbcDocu.ImpTot - CCbcDocu.ImpVta
          CCbcDocu.ImpDto = CCbcDocu.ImpBrt - CCbcDocu.ImpVta
          CCbcDocu.FchVto = DATE(F-Vcto:SCREEN-VALUE) .



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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY f-imptot f-vcto 
      WITH FRAME D-Dialog.
  ENABLE RECT-49 RECT-22 Btn_OK f-imptot f-vcto Btn_Cancel Btn_Help 
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
  DO WITH FRAME {&FRAME-NAME}:
   f-imptot:SCREEN-VALUE = string(x-imptot,"->>>,>>>,>>9.99").
   f-vcto:SCREEN-VALUE = string(x-vcto,"99/99/9999").  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
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

