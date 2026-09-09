&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME C-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Dialog 
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
 
DEFINE &IF "{&NEW}" = "" &THEN INPUT PARAMETER &ELSE VARIABLE &ENDIF titulo AS CHARACTER.
DEFINE &IF "{&NEW}" = "" &THEN INPUT PARAMETER &ELSE VARIABLE &ENDIF pCodMat AS CHARACTER.
DEFINE &IF "{&NEW}" = "" &THEN INPUT PARAMETER &ELSE VARIABLE &ENDIF pCodAlm AS CHAR.

DEF NEW SHARED VAR s-CodMat AS CHAR.
DEF NEW SHARED VAR s-CodAlm AS CHAR.


ASSIGN
    /*pCodAlm = ENTRY(1, pCodAlm)*/
    s-CodMat = pCodMat
    s-CodAlm = pCodAlm.

DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.

DEFINE BUFFER B-Almmmatg FOR Almmmatg.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartConsulta
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME C-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK RECT-33 RECT-28 
&Scoped-Define DISPLAYED-OBJECTS F-descuento 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_l-solo-stock AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Aceptar" 
     SIZE 10.14 BY 1.54
     BGCOLOR 8 .

DEFINE VARIABLE F-descuento AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51.86 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 11.14 BY 5.38.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63.72 BY 3.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME C-Dialog
     F-descuento AT ROW 8.69 COL 3 NO-LABEL
     Btn_OK AT ROW 1.27 COL 55
     "            F9 - Consulta Descuentos X Volumen" VIEW-AS TEXT
          SIZE 62.86 BY .5 AT ROW 7.92 COL 2
          FONT 6
     "            F8 - Consulta de Stocks por Almacen" VIEW-AS TEXT
          SIZE 62.86 BY .5 AT ROW 7.31 COL 2.29
          FONT 6
     RECT-33 AT ROW 6.65 COL 2
     RECT-28 AT ROW 1.27 COL 54.57
     SPACE(0.85) SKIP(3.96)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "<Título de Consulta>".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartConsulta
   Allow: Basic,Browse,DB-Fields,Smart,Query
   Container Links: 
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX C-Dialog
   NOT-VISIBLE FRAME-NAME Custom                                        */
ASSIGN 
       FRAME C-Dialog:SCROLLABLE       = FALSE
       FRAME C-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-descuento IN FRAME C-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX C-Dialog
/* Query rebuild information for DIALOG-BOX C-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX C-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Dialog C-Dialog
ON WINDOW-CLOSE OF FRAME C-Dialog /* <Título de Consulta> */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Dialog 


IF titulo <> "" THEN ASSIGN FRAME {&FRAME-NAME}:TITLE = titulo.

    /************Descuento Promocional ************/
FIND FIRST B-Almmmatg WHERE B-Almmmatg.CodCia = S-CODCIA
/*     AND  LOOKUP(ENTRY(1,s-CodAlm), B-Almmmatg.almacenes) <> 0 */
/*     AND  B-Almmmatg.FchCes = ?                                */
    AND  B-Almmmatg.codmat = pCodMat
    NO-LOCK NO-ERROR.
IF AVAILABLE B-Almmmatg THEN DO:
    DEFINE VAR J AS INTEGER .
    DEFINE VAR X-PROMO AS CHAR INIT "".
    DO J = 1 TO 10 :
       IF TODAY >= B-Almmmatg.PromFchD[J] AND 
          TODAY <= B-Almmmatg.PromFchH[J] THEN X-PROMO = "Promocional " .
    END.
    /************************************************/
    /***************Descuento Volumen****************/                    
     DEFINE VAR X-VOLU AS CHAR INIT "".
     DO J = 1 TO 10 :
        IF  B-Almmmatg.DtoVolD[J] > 0  THEN X-VOLU = "Volumen " .                 
     END.        
    /************************************************/
    DO WITH FRAME {&FRAME-NAME}:
       F-DESCUENTO = "". 
       IF X-PROMO <> "" THEN F-DESCUENTO = "Producto con Descuento " + X-VOLU. 
       IF X-VOLU  <> "" THEN F-DESCUENTO = "Producto con Descuento " + X-VOLU.
       IF X-PROMO <> "" AND X-VOLU <> "" THEN F-DESCUENTO = "Producto con Descuento " + X-PROMO + " y " + X-VOLU.
       F-DESCUENTO:BGCOLOR = 8 .
       F-DESCUENTO:FGCOLOR = 8 .
       IF F-DESCUENTO <> "" THEN DO WITH FRAME {&FRAME-NAME}:
          F-DESCUENTO:BGCOLOR = 12 .
          F-DESCUENTO:FGCOLOR = 15 .
          DISPLAY F-DESCUENTO @ F-DESCUENTO.
       END. 
    END.
END.

/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects C-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'web/l-solo-stock.w':U ,
             INPUT  FRAME C-Dialog:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_l-solo-stock ).
       RUN set-position IN h_l-solo-stock ( 1.27 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 5.38 , 52.29 ) */

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_l-solo-stock ,
             F-descuento:HANDLE , 'BEFORE':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available C-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME C-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Dialog  _DEFAULT-ENABLE
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
  DISPLAY F-descuento 
      WITH FRAME C-Dialog.
  ENABLE Btn_OK RECT-33 RECT-28 
      WITH FRAME C-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-C-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize C-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
/*
    RUN toma-handle IN {&l-lookup} ( THIS-PROCEDURE ).
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE p-aceptar C-Dialog 
PROCEDURE p-aceptar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    APPLY "CHOOSE" TO Btn_OK IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records C-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartConsulta, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed C-Dialog 
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

