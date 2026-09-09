&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES FacCfgGn
&Scoped-define FIRST-EXTERNAL-TABLE FacCfgGn


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FacCfgGn.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS FacCfgGn.Tpocmb[2] FacCfgGn.tolven ~
FacCfgGn.roundocu FacCfgGn.FacPor FacCfgGn.BrrPed FacCfgGn.Cla_Compra ~
FacCfgGn.Items_PedMos FacCfgGn.Cla_Venta FacCfgGn.clvmod FacCfgGn.CliVar ~
FacCfgGn.Tpocmb[1] FacCfgGn.Dias-Res FacCfgGn.Hora-Res FacCfgGn.Minu-Res ~
FacCfgGn.PorIgv FacCfgGn.MrgPub FacCfgGn.Items_Factura ~
FacCfgGn.Items_Boleta FacCfgGn.Items_Pedido FacCfgGn.Items_N_Debito ~
FacCfgGn.Items_N_Credito FacCfgGn.Items_Guias FacCfgGn.MrgMin ~
FacCfgGn.MrgMay FacCfgGn.MrgDis 
&Scoped-define ENABLED-TABLES FacCfgGn
&Scoped-define FIRST-ENABLED-TABLE FacCfgGn
&Scoped-Define ENABLED-OBJECTS RECT-20 RECT-21 RECT-22 RECT-23 RECT-69 ~
RECT-70 
&Scoped-Define DISPLAYED-FIELDS FacCfgGn.Tpocmb[2] FacCfgGn.tolven ~
FacCfgGn.roundocu FacCfgGn.FacPor FacCfgGn.BrrPed FacCfgGn.Cla_Compra ~
FacCfgGn.Items_PedMos FacCfgGn.Cla_Venta FacCfgGn.clvmod FacCfgGn.CliVar ~
FacCfgGn.Tpocmb[1] FacCfgGn.Dias-Res FacCfgGn.Hora-Res FacCfgGn.Minu-Res ~
FacCfgGn.PorIgv FacCfgGn.DtoMax FacCfgGn.DtoDis FacCfgGn.DtoMay ~
FacCfgGn.DtoPro FacCfgGn.MrgPub FacCfgGn.Items_Factura ~
FacCfgGn.Items_Boleta FacCfgGn.Items_Pedido FacCfgGn.Items_N_Debito ~
FacCfgGn.Items_N_Credito FacCfgGn.Items_Guias FacCfgGn.MrgMin ~
FacCfgGn.MrgMay FacCfgGn.MrgDis 
&Scoped-define DISPLAYED-TABLES FacCfgGn
&Scoped-define FIRST-DISPLAYED-TABLE FacCfgGn


/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65.29 BY 5.46.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65.29 BY 4.65.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65.29 BY 4.38.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65.29 BY 1.35.

DEFINE RECTANGLE RECT-69
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY 2.42.

DEFINE RECTANGLE RECT-70
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY 1.35.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCfgGn.Tpocmb[2] AT ROW 4.42 COL 54 COLON-ALIGNED
          LABEL "T. Caja (Compra)"
          VIEW-AS FILL-IN 
          SIZE 8.72 BY .81
     FacCfgGn.tolven AT ROW 5.31 COL 18.14 COLON-ALIGNED
          LABEL "Tolerancia de Venctos." FORMAT ">>9"
          VIEW-AS FILL-IN 
          SIZE 3.57 BY .81
     FacCfgGn.roundocu AT ROW 5.31 COL 54.14 COLON-ALIGNED
          LABEL "Máximo Redondeo Permitido"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     FacCfgGn.FacPor AT ROW 3.62 COL 18 COLON-ALIGNED
          LABEL "% Dscto. Ofic. Mostrador" FORMAT "ZZZZZZ9.99999"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     FacCfgGn.BrrPed AT ROW 1.19 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .81
     FacCfgGn.Cla_Compra AT ROW 15.81 COL 14.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .81
     FacCfgGn.Items_PedMos AT ROW 12.96 COL 16 COLON-ALIGNED
          LABEL "Pedido Mostrador" FORMAT ">>>>>9"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     FacCfgGn.Cla_Venta AT ROW 15.81 COL 41.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .81
     FacCfgGn.clvmod AT ROW 1.92 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.57 BY .81
     FacCfgGn.CliVar AT ROW 2.81 COL 18 COLON-ALIGNED FORMAT "X(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FacCfgGn.Tpocmb[1] AT ROW 4.42 COL 18 COLON-ALIGNED
          LABEL "T.Cambio Comercial"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     FacCfgGn.Dias-Res AT ROW 1.19 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FacCfgGn.Hora-Res AT ROW 2 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FacCfgGn.Minu-Res AT ROW 2.81 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FacCfgGn.PorIgv AT ROW 3.62 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     FacCfgGn.DtoMax AT ROW 7.73 COL 16 COLON-ALIGNED
          LABEL "% Dsct.Max. D1"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     FacCfgGn.DtoDis AT ROW 8.54 COL 16 COLON-ALIGNED
          LABEL "% Dsct.Max. D2"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     FacCfgGn.DtoMay AT ROW 9.35 COL 16 COLON-ALIGNED
          LABEL "% Dsct.Max. D3"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     FacCfgGn.DtoPro AT ROW 10.15 COL 16 COLON-ALIGNED
          LABEL "Dcto.Max. D4" FORMAT "->>9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     FacCfgGn.MrgPub AT ROW 7.62 COL 56.72 COLON-ALIGNED
          LABEL "% Mrg.Publico"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     FacCfgGn.Items_Factura AT ROW 13.77 COL 16 COLON-ALIGNED
          LABEL "Facturas" FORMAT ">>>>>9"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     FacCfgGn.Items_Boleta AT ROW 14.62 COL 16 COLON-ALIGNED
          LABEL "Boletas" FORMAT ">>>>>9"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     FacCfgGn.Items_Pedido AT ROW 12.19 COL 16 COLON-ALIGNED
          LABEL "Pedidos Oficina" FORMAT ">>>>>9"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     FacCfgGn.Items_N_Debito AT ROW 12.19 COL 51 COLON-ALIGNED
          LABEL "Nota de Debito" FORMAT ">>>>>9"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     FacCfgGn.Items_N_Credito AT ROW 12.96 COL 51 COLON-ALIGNED
          LABEL "Nota de Credito" FORMAT ">>>>>9"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     FacCfgGn.Items_Guias AT ROW 13.77 COL 51 COLON-ALIGNED
          LABEL "Guias de Remision" FORMAT ">>>>>9"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     FacCfgGn.MrgMin AT ROW 17.96 COL 39 COLON-ALIGNED WIDGET-ID 14
          LABEL "Mínimo de venta" FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCfgGn.MrgMay AT ROW 18.77 COL 39 COLON-ALIGNED WIDGET-ID 12
          LABEL "Máximo importe que requiere aprobación" FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCfgGn.MrgDis AT ROW 20.12 COL 39 COLON-ALIGNED WIDGET-ID 18
          LABEL "FACTOR AJUSTE POR VARIACION IGV" FORMAT ">>9.9999999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 12 FGCOLOR 15 
     "% Descuentos Globales" VIEW-AS TEXT
          SIZE 22.72 BY .73 AT ROW 6.65 COL 2.29
          BGCOLOR 1 FGCOLOR 15 FONT 1
     "GERENTE GENERAL" VIEW-AS TEXT
          SIZE 18 BY .5 AT ROW 9.62 COL 25 WIDGET-ID 6
     "JEFE DE VENTAS" VIEW-AS TEXT
          SIZE 18 BY .5 AT ROW 10.42 COL 25 WIDGET-ID 8
     "Numero de Items por Documento" VIEW-AS TEXT
          SIZE 31 BY .73 AT ROW 11.38 COL 2
          BGCOLOR 1 FGCOLOR 15 FONT 1
     "ADMINISTRADOR" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 8 COL 25 WIDGET-ID 2
     "GERENTE DE VENTAS" VIEW-AS TEXT
          SIZE 18 BY .5 AT ROW 8.81 COL 25 WIDGET-ID 4
     "TOPES POR VENTAS DELIVERY" VIEW-AS TEXT
          SIZE 30 BY .5 AT ROW 17.15 COL 2 WIDGET-ID 10
          BGCOLOR 7 FGCOLOR 15 
     "<=== VER TABLAS GENERALES (CODIGO NA)" VIEW-AS TEXT
          SIZE 40 BY .5 AT ROW 6.77 COL 26 WIDGET-ID 22
          BGCOLOR 12 FGCOLOR 15 FONT 6
     RECT-20 AT ROW 1 COL 1
     RECT-21 AT ROW 6.58 COL 1.29
     RECT-22 AT ROW 11.23 COL 1
     RECT-23 AT ROW 15.69 COL 1
     RECT-69 AT ROW 17.42 COL 1 WIDGET-ID 16
     RECT-70 AT ROW 19.85 COL 1 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.FacCfgGn
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 20.69
         WIDTH              = 66.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FacCfgGn.CliVar IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FacCfgGn.DtoDis IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCfgGn.DtoMax IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCfgGn.DtoMay IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCfgGn.DtoPro IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCfgGn.FacPor IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCfgGn.Items_Boleta IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCfgGn.Items_Factura IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCfgGn.Items_Guias IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCfgGn.Items_N_Credito IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCfgGn.Items_N_Debito IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCfgGn.Items_Pedido IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCfgGn.Items_PedMos IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCfgGn.MrgDis IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCfgGn.MrgMay IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCfgGn.MrgMin IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCfgGn.MrgPub IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCfgGn.roundocu IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCfgGn.tolven IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCfgGn.Tpocmb[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCfgGn.Tpocmb[2] IN FRAME F-Main
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "FacCfgGn"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "FacCfgGn"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  ASSIGN FacCfgGn.CodCia = S-CODCIA.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
/*
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
     RUN VALIDA.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros V-table-Win 
PROCEDURE procesa-parametros :
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
        WHEN "" THEN.
    END CASE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros V-table-Win 
PROCEDURE recoge-parametros :
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
        WHEN "" THEN .
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "FacCfgGn"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     Validacion de datos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME} :
   /* IF CAMPO:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Campo no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CAMPO.
         RETURN "ADM-ERROR".   
   
      END.
   */

END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

