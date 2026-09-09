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
DEFINE INPUT PARAMETER X-DSCTO   AS DECIMAL.
DEFINE INPUT PARAMETER X-PREUNI  AS DECIMAL.
DEFINE INPUT PARAMETER X-CHR__02 LIKE Almmmatg.Chr__02.
DEFINE INPUT PARAMETER X-UNIBAS  AS CHAR.
DEFINE INPUT PARAMETER X-UNIVTA  AS CHARACTER.
DEFINE INPUT PARAMETER X-MAXDSC  AS DECIMAL.
DEFINE INPUT PARAMETER X-VALVTA  AS DECIMAL.
DEFINE INPUT PARAMETER X-MONVTA  LIKE Almmmatg.MonVta.
DEFINE INPUT PARAMETER X-TPOCMB  LIKE Almmmatg.TpoCmb.
DEFINE INPUT PARAMETER X-NIV     AS CHAR.
DEFINE INPUT PARAMETER X-CLFCLI  LIKE gn-clie.clfCli.
DEFINE OUTPUT PARAMETER X-NEWDSC AS DECIMAL.
DEFINE OUTPUT PARAMETER X-NEWPRE AS DECIMAL.

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-CODMON  AS INTEGER.

X-NEWDSC = X-DSCTO.
X-NEWPRE = X-PREUNI.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VARIABLE F-FACTOR     AS DECIMAL   NO-UNDO.

DEFINE SHARED VARIABLE S-CNDVTA  AS CHAR.

DEFINE VARIABLE MaxCat LIKE ClfClie.PorDsc.
DEFINE VARIABLE MaxVta LIKE Dsctos.PorDto.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-28 F-DSCTO 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-2 FILL-IN-3 F-DSCTO 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE F-DSCTO AS DECIMAL FORMAT "->>9.99":U INITIAL 0 
     LABEL "% Dscto. Adic." 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS DECIMAL FORMAT "->>9.99":U INITIAL 0 
     LABEL "% Dscto. Max." 
     VIEW-AS FILL-IN NATIVE 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS DECIMAL FORMAT "->>9.99":U INITIAL 0 
     LABEL "% Dsct. Efec." 
     VIEW-AS FILL-IN NATIVE 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 31.86 BY 3.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-2 AT ROW 1.23 COL 11.14 COLON-ALIGNED
     FILL-IN-3 AT ROW 2.04 COL 11.14 COLON-ALIGNED
     F-DSCTO AT ROW 2.88 COL 11.14 COLON-ALIGNED
     RECT-28 AT ROW 1 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Descuentos".


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

/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Descuentos */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DSCTO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DSCTO D-Dialog
ON LEAVE OF F-DSCTO IN FRAME D-Dialog /* % Dscto. Adic. */
DO:
    APPLY "RETURN" TO F-DSCTO.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DSCTO D-Dialog
ON RETURN OF F-DSCTO IN FRAME D-Dialog /* % Dscto. Adic. */
DO:
  DEFINE VARIABLE pre1 AS DECIMAL.
  DEFINE VARIABLE pre2 AS DECIMAL.
  
  pre1 = 0.
  pre2 = 0.
  
  ASSIGN
    F-DSCTO.

  CASE X-NIV:
    WHEN "1" THEN DO:
        IF F-DSCTO > FacCfgGn.DtoMax THEN DO:
            MESSAGE "Ud. no puede excederse del " FacCfgGn.DtoMax
                    VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-DSCTO IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
        END.
    END.
    WHEN "2" THEN 
        IF F-DSCTO > FacCfgGn.DtoDis THEN DO:
            MESSAGE "Ud. no puede excederse del " FacCfgGn.DtoDis
                    VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-DSCTO IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
        END.
    WHEN "3" THEN
        IF F-DSCTO > FacCfgGn.DtoMay THEN DO:
            MESSAGE "Ud. no puede excederse del " FacCfgGn.DtoMay
                    VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-DSCTO IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
        END.
  END CASE.

    /****   Halla los descuentos por categorias y condicones de venta   ****/
    MaxCat = 0.
    MaxVta = 0.

    FIND ClfClie WHERE ClfClie.Categoria = X-CLFCLI
                 NO-LOCK NO-ERROR.
    IF AVAIL ClfClie THEN DO:
        IF x-Chr__02 = "P" THEN 
            MaxCat = ClfClie.PorDsc.
        ELSE 
            MaxCat = ClfClie.PorDsc1.
    END.

    FIND Dsctos WHERE Dsctos.CndVta = S-CNDVTA
                 AND  Dsctos.clfCli = x-Chr__02
                NO-LOCK NO-ERROR.
    IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.

    IF NOT AVAIL ClfClie THEN
        X-NEWDSC = (1 - (1 - MaxVta / 100)) * 100.
    ELSE
        X-NEWDSC = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100) ) * 100.
    /*************************************************************************/
    
    X-NEWDSC = X-NEWDSC + F-DSCTO.
    
    IF X-NEWDSC > X-MAXDSC THEN DO:
        MESSAGE "Ud. no puede hacer un descuento" SKIP
                "mayor al " X-MAXDSC "%"
                VIEW-AS ALERT-BOX ERROR.
        X-NEWDSC = X-DSCTO.
        APPLY "ENTRY" TO F-DSCTO IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.

    /****   Busca el Factor de conversion   ****/
    F-FACTOR = 1.
    IF X-UNIVTA <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = X-UNIBAS
                       AND  Almtconv.Codalter = X-UNIVTA
                      NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN DO:
           MESSAGE "Codigo de unidad no exixte" VIEW-AS ALERT-BOX ERROR.
           RETURN NO-APPLY.
        END.
        F-FACTOR = Almtconv.Equival /* / Almmmatg.FacEqu*/.
    END.
    /*******************************************/

    IF S-CODMON = 1 THEN DO:
        IF X-MonVta = 1 THEN
            ASSIGN X-NEWPRE = X-VALVTA / F-FACTOR.
        ELSE
            ASSIGN X-NEWPRE = (X-VALVTA / F-FACTOR) * X-TpoCmb.
    END.
    IF S-CODMON = 2 THEN DO:
        IF X-MonVta = 2 THEN
            ASSIGN X-NEWPRE = X-VALVTA / F-FACTOR.
        ELSE
            ASSIGN X-NEWPRE = (X-VALVTA / F-FACTOR) / X-TpoCmb.
    END.

    X-NEWPRE = X-NEWPRE * (1 - X-NEWDSC / 100).

/*********/
  APPLY "END-ERROR":U TO SELF.
  RETURN NO-APPLY.
  
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
  DISPLAY FILL-IN-2 FILL-IN-3 F-DSCTO 
      WITH FRAME D-Dialog.
  ENABLE RECT-28 F-DSCTO 
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
    DISPLAY X-MAXDSC @ FILL-IN-2
            X-DSCTO @ FILL-IN-3.
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


