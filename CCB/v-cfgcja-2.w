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

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEF SHARED VAR cb-codcia AS INT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES cb-cfgcja
&Scoped-define FIRST-EXTERNAL-TABLE cb-cfgcja


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cb-cfgcja.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cb-cfgcja.CodDiv cb-cfgcja.CodOpe ~
cb-cfgcja.CodCta1[1] cb-cfgcja.CodCta2[1] cb-cfgcja.CodCta1[2] ~
cb-cfgcja.CodCta2[2] cb-cfgcja.CodCta1[3] cb-cfgcja.CodCta2[3] ~
cb-cfgcja.CodCta1[4] cb-cfgcja.CodCta2[4] cb-cfgcja.CodCta1[5] ~
cb-cfgcja.CodCta2[5] cb-cfgcja.CodCta1[6] cb-cfgcja.CodCta2[6] ~
cb-cfgcja.CodCta1[7] cb-cfgcja.CodCta2[7] cb-cfgcja.CodCta1[8] ~
cb-cfgcja.CodCta2[8] cb-cfgcja.CodCta1[9] cb-cfgcja.CodCta2[9] ~
cb-cfgcja.CodCta1[10] cb-cfgcja.CodCta2[10] cb-cfgcja.CodCta_1[1] ~
cb-cfgcja.CodCta_2[1] cb-cfgcja.CodCta_1[2] cb-cfgcja.CodCta_2[2] 
&Scoped-define ENABLED-TABLES cb-cfgcja
&Scoped-define FIRST-ENABLED-TABLE cb-cfgcja
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 
&Scoped-Define DISPLAYED-FIELDS cb-cfgcja.CodDiv cb-cfgcja.CodOpe ~
cb-cfgcja.CodCta1[1] cb-cfgcja.CodCta2[1] cb-cfgcja.CodCta1[2] ~
cb-cfgcja.CodCta2[2] cb-cfgcja.CodCta1[3] cb-cfgcja.CodCta2[3] ~
cb-cfgcja.CodCta1[4] cb-cfgcja.CodCta2[4] cb-cfgcja.CodCta1[5] ~
cb-cfgcja.CodCta2[5] cb-cfgcja.CodCta1[6] cb-cfgcja.CodCta2[6] ~
cb-cfgcja.CodCta1[7] cb-cfgcja.CodCta2[7] cb-cfgcja.CodCta1[8] ~
cb-cfgcja.CodCta2[8] cb-cfgcja.CodCta1[9] cb-cfgcja.CodCta2[9] ~
cb-cfgcja.CodCta1[10] cb-cfgcja.CodCta2[10] cb-cfgcja.CodCta_1[1] ~
cb-cfgcja.CodCta_2[1] cb-cfgcja.CodCta_1[2] cb-cfgcja.CodCta_2[2] 
&Scoped-define DISPLAYED-TABLES cb-cfgcja
&Scoped-define FIRST-DISPLAYED-TABLE cb-cfgcja
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 F-DesOpe 

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
DEFINE VARIABLE F-DesOpe AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35.86 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 62 BY 2.42.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 62 BY 9.42.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 62 BY 2.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cb-cfgcja.CodDiv AT ROW 1.38 COL 11 COLON-ALIGNED
          LABEL "División"
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .81
     FILL-IN-1 AT ROW 1.38 COL 20 COLON-ALIGNED NO-LABEL
     cb-cfgcja.CodOpe AT ROW 2.35 COL 11 COLON-ALIGNED
          LABEL "Operación"
          VIEW-AS FILL-IN 
          SIZE 8.14 BY .81
     F-DesOpe AT ROW 2.35 COL 20 COLON-ALIGNED NO-LABEL
     cb-cfgcja.CodCta1[1] AT ROW 4.65 COL 23 COLON-ALIGNED
          LABEL "EFECTIVO"
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     cb-cfgcja.CodCta2[1] AT ROW 4.65 COL 44 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     cb-cfgcja.CodCta1[2] AT ROW 5.46 COL 23 COLON-ALIGNED
          LABEL "CHEQUES DEL DIA"
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     cb-cfgcja.CodCta2[2] AT ROW 5.46 COL 44 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     cb-cfgcja.CodCta1[3] AT ROW 6.27 COL 23 COLON-ALIGNED
          LABEL "CHEQUES DIFERIDO"
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     cb-cfgcja.CodCta2[3] AT ROW 6.27 COL 44 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     cb-cfgcja.CodCta1[4] AT ROW 7.08 COL 23 COLON-ALIGNED
          LABEL "TARJETA CREDITO"
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     cb-cfgcja.CodCta2[4] AT ROW 7.08 COL 44 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     cb-cfgcja.CodCta1[5] AT ROW 7.88 COL 23 COLON-ALIGNED
          LABEL "BOLETA DEPOSITO"
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     cb-cfgcja.CodCta2[5] AT ROW 7.88 COL 44 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     cb-cfgcja.CodCta1[6] AT ROW 8.69 COL 23 COLON-ALIGNED
          LABEL "NOTA DE CREDITO"
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     cb-cfgcja.CodCta2[6] AT ROW 8.69 COL 44 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     cb-cfgcja.CodCta1[7] AT ROW 9.5 COL 23 COLON-ALIGNED
          LABEL "ANTICIPO"
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     cb-cfgcja.CodCta2[7] AT ROW 9.5 COL 44 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     cb-cfgcja.CodCta1[8] AT ROW 10.31 COL 23 COLON-ALIGNED
          LABEL "COMISION FACTORING"
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     cb-cfgcja.CodCta2[8] AT ROW 10.31 COL 44 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     cb-cfgcja.CodCta1[9] AT ROW 11.12 COL 23 COLON-ALIGNED
          LABEL "RETENCION"
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     cb-cfgcja.CodCta2[9] AT ROW 11.12 COL 44 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     cb-cfgcja.CodCta1[10] AT ROW 11.92 COL 23 COLON-ALIGNED
          LABEL "VALES DE CONSUMO"
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     cb-cfgcja.CodCta2[10] AT ROW 11.92 COL 44 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     cb-cfgcja.CodCta_1[1] AT ROW 13.69 COL 23 COLON-ALIGNED
          LABEL "REMESA A BOVEDA"
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     cb-cfgcja.CodCta_2[1] AT ROW 13.69 COL 44 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     cb-cfgcja.CodCta_1[2] AT ROW 14.5 COL 23 COLON-ALIGNED
          LABEL "REMESA A CAJA CENTRAL"
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     cb-cfgcja.CodCta_2[2] AT ROW 14.5 COL 44 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .81
     " Movimientos" VIEW-AS TEXT
          SIZE 11.57 BY .5 AT ROW 13.12 COL 5
          BGCOLOR 1 FGCOLOR 15 FONT 6
     " Formas de pago" VIEW-AS TEXT
          SIZE 14.14 BY .5 AT ROW 3.5 COL 5
          BGCOLOR 1 FGCOLOR 15 FONT 6
     "DOLARES" VIEW-AS TEXT
          SIZE 9.57 BY .5 AT ROW 3.92 COL 48
          FONT 1
     "SOLES" VIEW-AS TEXT
          SIZE 7.43 BY .5 AT ROW 3.88 COL 29
          FONT 1
     RECT-1 AT ROW 1.08 COL 1
     RECT-2 AT ROW 3.69 COL 1
     RECT-3 AT ROW 13.31 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.cb-cfgcja
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
         HEIGHT             = 14.81
         WIDTH              = 62.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN cb-cfgcja.CodCta1[10] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cfgcja.CodCta1[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cfgcja.CodCta1[2] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cfgcja.CodCta1[3] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cfgcja.CodCta1[4] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cfgcja.CodCta1[5] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cfgcja.CodCta1[6] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cfgcja.CodCta1[7] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cfgcja.CodCta1[8] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cfgcja.CodCta1[9] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cfgcja.CodCta_1[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cfgcja.CodCta_1[2] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cfgcja.CodDiv IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cfgcja.CodOpe IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN F-DesOpe IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME cb-cfgcja.CodOpe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfgcja.CodOpe V-table-Win
ON LEAVE OF cb-cfgcja.CodOpe IN FRAME F-Main /* Operación */
DO:
    FIND cb-oper WHERE
        cb-oper.codcia = cb-codcia AND
        cb-oper.codope = SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-oper THEN DO:
        MESSAGE
            'Operación no existe'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO cb-cfgcja.codope.
        RETURN NO-APPLY.
    END.
    DO WITH FRAME {&FRAME-NAME}:
        DISPLAY cb-oper.nomope @ F-DesOpe.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

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
  {src/adm/template/row-list.i "cb-cfgcja"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cb-cfgcja"}

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
  INTEGRAL.cb-cfgcja.Codcia = s-codcia.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    IF AVAILABLE Cb-cfgcja THEN DO WITH FRAME {&FRAME-NAME}:
        FIND gn-divi WHERE
            gn-divi.CodCia = S-CODCIA AND
            gn-divi.Coddiv = Cb-cfgcja.Coddiv 
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-divi THEN
            DISPLAY gn-divi.Desdiv @ FILL-IN-1.
        ELSE DISPLAY "" @ FILL-IN-1.
        FIND cb-oper WHERE
            cb-oper.codcia = cb-codcia AND
            cb-oper.codope = cb-cfgcja.codope
            NO-LOCK NO-ERROR.
        IF AVAILABLE cb-oper THEN DISPLAY cb-oper.nomope @ F-DesOpe.
        ELSE DISPLAY "" @ F-DesOpe.

  END.

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "cb-cfgcja"}

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

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

