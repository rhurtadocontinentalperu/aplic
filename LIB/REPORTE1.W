&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_Cancel F-Page-Number 
&Scoped-Define DISPLAYED-OBJECTS F-Page-Number 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 28 BY 1.15
     BGCOLOR 8 .

DEFINE VARIABLE F-Page-Number AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "P gina" 
      VIEW-AS TEXT 
     SIZE 9 BY .62 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Btn_Cancel AT ROW 3.85 COL 12
     F-Page-Number AT ROW 2.35 COL 24 COLON-ALIGNED
     "En proceso de Impresi¢n" VIEW-AS TEXT
          SIZE 17 BY .62 AT ROW 1.27 COL 17
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 49.57 BY 4.69
         FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Listado de Ordenes por Cliente"
         HEIGHT             = 4.69
         WIDTH              = 49.57
         MAX-HEIGHT         = 4.69
         MAX-WIDTH          = 49.57
         VIRTUAL-HEIGHT     = 4.69
         VIRTUAL-WIDTH      = 49.57
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   Default                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{aplic/lib/sp-print.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Listado de Ordenes por Cliente */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Listado de Ordenes por Cliente */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  s-Stop-report = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

s-Program-Name = PROGRAM-NAME(1).
s-Page-Width   = 132.
s-Page-Height  = 55.

/* Include custom  Main Block code for SmartWindows. */
RUN src/bin/_prnctr.r.
IF ERROR-STATUS:ERROR THEN RETURN.


{src/adm/template/windowmn.i}
RUN VISUALIZACION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
  DISPLAY F-Page-Number 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE Btn_Cancel F-Page-Number 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR W-Win 
PROCEDURE IMPRIMIR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR TOTAL     AS DECIMAL NO-UNDO.
DEF VAR TOTAL-REP AS DECIMAL NO-UNDO.

DEFINE FRAME F-REP-MAIN
                    Order-Line.Line-num 
                    Order-Line.Item-num 
                    Item.Item-Name
                    Order-Line.Qty 
                    Order-Line.Price 
                    Order-Line.Discount 
                    Order-Line.Extended-Price
          WITH NO-LABEL NO-UNDERLINE NO-BOX STREAM-IO.



Reporte:
FOR EACH CUSTOMER  NO-LOCK
       ON ERROR UNDO, LEAVE Reporte
       BREAK BY Customer.Sales-Rep
       WITH FRAME F-REP-MAIN:       

    IF FIRST-OF(Customer.Sales-Rep )
    THEN DO:
        FIND FIRST Salesrep OF Customer.
        RUN CONTROL-PAGINA.
        DISPLAY STREAM S-OUT 
                "Vendedor =>"
                Customer.Sales-Rep
                Salesrep.Rep-Name
                WITH FRAME F-SALES-REP NO-LABEL.
        TOTAL-REP = 0.
    END.            

    RUN CONTROL-PAGINA.
    DISPLAY STREAM S-OUT 
            CUSTOMER.CUST-NUM LABEL "CLIENTE"
            CUSTOMER.NAME     NO-LABEL 
                WITH FRAME F-CLIENTE SIDE-LABEL STREAM-IO.   
    
    FOR EACH ORDER OF CUSTOMER NO-LOCK
               ON ERROR UNDO, LEAVE Reporte:

                       
        RUN CONTROL-PAGINA.
        DISPLAY STREAM S-OUT 
                Order.ORDER-NUM    LABEL "ORDEN"
                Order.Order-Date   LABEL "FECHA"
                Order.Promise-Date LABEL "VENCIMIENTO"
                WITH FRAME F-ORDER SIDE-LABEL STREAM-IO.
        TOTAL = 0.
        FOR EACH ORDER-LINE OF ORDER NO-LOCK, FIRST ITEM OF ORDER-LINE NO-LOCK
                   ON ERROR UNDO, LEAVE Reporte :
            RUN CONTROL-PAGINA.
                     
            DISPLAY STREAM S-OUT 
                    Order-Line.Line-num 
                    Order-Line.Item-num 
                    Item.Item-Name
                    Order-Line.Qty 
                    Order-Line.Price 
                    Order-Line.Discount 
                    Order-Line.Extended-Price
               WITH FRAME F-REP-MAIN.
            
            DOWN STREAM S-OUT WITH FRAME F-REP-MAIN.
            TOTAL = TOTAL + Order-Line.Extended-Price.
            /* Verificamos si presiono el botón Cancelar */
            PROCESS EVENTS.
            IF s-Stop-report THEN LEAVE Reporte.
         END.
         TOTAL-REP = TOTAL-REP + TOTAL.
         RUN CONTROL-PAGINA.
         DOWN STREAM S-OUT WITH FRAME F-REP-MAIN.
         RUN CONTROL-PAGINA.
         UNDERLINE STREAM S-OUT 
                    Order-Line.Line-num 
                    Order-Line.Item-num 
                    Item.Item-Name
                    Order-Line.Qty 
                    Order-Line.Price 
                    Order-Line.Discount 
                    Order-Line.Extended-Price
                    WITH FRAME F-REP-MAIN.
         DOWN STREAM S-OUT WITH FRAME F-REP-MAIN.
         RUN CONTROL-PAGINA.
         DISPLAY  STREAM S-OUT 
                  "TOTAL" @  Order-Line.Discount
                  TOTAL   @  Order-Line.Extended-Price
                  WITH FRAME F-REP-MAIN.
           DOWN STREAM S-OUT WITH FRAME F-REP-MAIN.
     END.
    IF LAST-OF(Customer.Sales-Rep )
    THEN DO:
         RUN CONTROL-PAGINA.
         DOWN STREAM S-OUT WITH FRAME F-REP-MAIN.
         RUN CONTROL-PAGINA.
         DISPLAY STREAM S-OUT
             FILL("=", 80) FORMAT "x(78)"
             WITH FRAME F-LINEA-REP.
         RUN CONTROL-PAGINA.
         DISPLAY  STREAM S-OUT 
                  "TOTAL-REP" @  Order-Line.Discount
                   TOTAL-REP   @  Order-Line.Extended-Price
                      WITH FRAME F-REP-MAIN.
    END.    
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR-PAGINA-FIN W-Win 
PROCEDURE IMPRIMIR-PAGINA-FIN :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR-PAGINA-INICIO W-Win 
PROCEDURE IMPRIMIR-PAGINA-INICIO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DISPLAY STREAM S-Out
    TODAY                 LABEL "Fecha"
    STRING(TIME, "HH:MM") FORMAT "X(5)"
    s-Page-Number  AT 55  LABEL "P gina" FORMAT ">9" 
  SKIP
    "Listado de Ordenes por cliente" AT 15
   SKIP
"******* ******* ***************** ****** ************ ****** *** *******" SKIP
"      #    C¢d. Descripci¢n        Cant.       Precio   Dst.       Total" SKIP
"******* ******* ***************** ****** ************ ****** ***********" SKIP
        WITH SIDE-LABEL STREAM-IO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  s-Page-Header = Yes.
  s-Page-Number = 0.

  RUN IMPRIMIR-INICIO( FALSE ).
  RUN IMPRIMIR.
  RUN IMPRIMIR-FIN.
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
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


