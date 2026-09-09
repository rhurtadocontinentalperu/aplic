&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
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
DEFINE INPUT  PARAMETER F-Codmat AS CHAR.
DEFINE INPUT  PARAMETER F-Codmon AS INTEGER.
DEFINE OUTPUT PARAMETER F-PreNet AS DECIMAL.

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-TIPVTA AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND
     Almmmatg.codmat = F-Codmat NO-LOCK NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almmmatg

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH Almmmatg SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog Almmmatg


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 F-Peso-Tn Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_codmat FILL-IN_UndStk ~
FILL-IN_Pesmat FILL-IN_MrgUti F-Peso-Tn FILL-IN_DesMat FILL-IN_Prevta ~
FILL-IN_Prevta-2 

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

DEFINE VARIABLE F-Peso-Tn AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Precio x Tn US$" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_codmat AS CHARACTER FORMAT "X(6)" 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .81
     FONT 1.

DEFINE VARIABLE FILL-IN_DesMat AS CHARACTER FORMAT "X(45)" 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 40.72 BY .81.

DEFINE VARIABLE FILL-IN_MrgUti AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Mrg de Utilidad" 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .81.

DEFINE VARIABLE FILL-IN_Pesmat AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Peso" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81.

DEFINE VARIABLE FILL-IN_Prevta AS DECIMAL FORMAT "->>>,>>9.99" INITIAL 0 
     LABEL "Precio Neto" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .81.

DEFINE VARIABLE FILL-IN_Prevta-2 AS DECIMAL FORMAT "->>>,>>9.99" INITIAL 0 
     LABEL "Precio Neto" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .81.

DEFINE VARIABLE FILL-IN_UndStk AS CHARACTER FORMAT "X(4)" 
     LABEL "Unidad" 
     VIEW-AS FILL-IN 
     SIZE 4.29 BY .81.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 66.57 BY 4.12.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 66.14 BY 2.19.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN_codmat AT ROW 1.92 COL 11.43 COLON-ALIGNED
     FILL-IN_UndStk AT ROW 2.73 COL 11.43 COLON-ALIGNED HELP
          "Unidad de stock"
     FILL-IN_Pesmat AT ROW 3.54 COL 11.43 COLON-ALIGNED
     FILL-IN_MrgUti AT ROW 4.27 COL 11.43 COLON-ALIGNED
     F-Peso-Tn AT ROW 7 COL 17.57 COLON-ALIGNED
     Btn_OK AT ROW 8.62 COL 18.43
     FILL-IN_DesMat AT ROW 1.92 COL 22 COLON-ALIGNED HELP
          "Descripción del material"
     Btn_Cancel AT ROW 8.65 COL 38.14
     FILL-IN_Prevta AT ROW 4.27 COL 46.43 COLON-ALIGNED
     FILL-IN_Prevta-2 AT ROW 6.85 COL 46.43 COLON-ALIGNED
     " PRECIO ACTUAL" VIEW-AS TEXT
          SIZE 15.86 BY .5 AT ROW 1.04 COL 5.57
          FONT 1
     RECT-1 AT ROW 1.38 COL 1
     " PRECIO POR TONELADAS" VIEW-AS TEXT
          SIZE 25.57 BY .5 AT ROW 5.88 COL 5.57
          FONT 1
     RECT-2 AT ROW 6.04 COL 1.29
     "Killos" VIEW-AS TEXT
          SIZE 4 BY .5 AT ROW 3.69 COL 24.14
     "(sin IGV)" VIEW-AS TEXT
          SIZE 6.43 BY .5 AT ROW 7.15 COL 29.29
     SPACE(32.13) SKIP(2.72)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Calculo de Precio".


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

/* SETTINGS FOR FILL-IN FILL-IN_codmat IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DesMat IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_MrgUti IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Pesmat IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Prevta IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Prevta-2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_UndStk IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "integral.Almmmatg"
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Calculo de Precio */
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
   ASSIGN 
      FILL-IN_Prevta-2.
   F-Prenet = FILL-IN_Prevta-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Peso-Tn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Peso-Tn D-Dialog
ON LEAVE OF F-Peso-Tn IN FRAME D-Dialog /* Precio x Tn US$ */
DO:
  ASSIGN FILL-IN_Prevta F-Peso-Tn.
  DO WITH FRAME {&FRAME-NAME}:
     IF F-Codmon = 1 THEN DO:
        IF S-Tipvta = 'SIN IGV' THEN 
           DISPLAY 
              ROUND(F-Peso-Tn * FacCfgGn.Tpocmb[1] / 1000 * Almmmatg.pesmat, 2) @ FILL-IN_Prevta-2.
        ELSE 
           DISPLAY 
              ROUND(F-Peso-Tn * FacCfgGn.Tpocmb[1] / 1000 * Almmmatg.pesmat * (1 + FacCfgGn.PorIgv / 100) , 2) @ FILL-IN_Prevta-2.
        END.
     ELSE DO:
        IF S-Tipvta = 'SIN IGV' THEN
           DISPLAY 
              ROUND(F-Peso-Tn / 1000 * Almmmatg.pesmat, 2) @ FILL-IN_Prevta-2.
        ELSE 
           DISPLAY 
              ROUND(F-Peso-Tn / 1000 * Almmmatg.pesmat * (1 + FacCfgGn.PorIgv / 100), 2) @ FILL-IN_Prevta-2.
     END.
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
  DISPLAY FILL-IN_codmat FILL-IN_UndStk FILL-IN_Pesmat FILL-IN_MrgUti F-Peso-Tn 
          FILL-IN_DesMat FILL-IN_Prevta FILL-IN_Prevta-2 
      WITH FRAME D-Dialog.
  ENABLE RECT-1 RECT-2 F-Peso-Tn Btn_OK Btn_Cancel 
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
  IF AVAILABLE Almmmatg THEN DO WITH FRAME {&FRAME-NAME}:
     DISPLAY
        Almmmatg.codmat @ FILL-IN_codmat 
        Almmmatg.DesMat @ FILL-IN_DesMat 
        Almmmatg.UndStk @ FILL-IN_UndStk
        Almmmatg.Pesmat @ FILL-IN_Pesmat 
        Almmmatg.MrgUti @ FILL-IN_MrgUti.
     IF Almmmatg.monvta = F-Codmon THEN DO:
        DISPLAY       
           Almmmatg.Prevta[1] @ FILL-IN_Prevta.
        END.
     ELSE DO:
        IF F-Codmon = 1 THEN 
           DISPLAY 
              ROUND(Almmmatg.Prevta[1] * FacCfgGn.Tpocmb[1],2) @ FILL-IN_Prevta.
        ELSE
           DISPLAY 
              ROUND(Almmmatg.Prevta[1] / FacCfgGn.Tpocmb[1],2) @ FILL-IN_Prevta.
     END.
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "Almmmatg"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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


