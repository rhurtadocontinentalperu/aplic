&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES integral.PL-BOLE integral.PL-CALC
&Scoped-define FIRST-EXTERNAL-TABLE integral.PL-BOLE


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR integral.PL-BOLE, integral.PL-CALC.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS INTEGRAL.PL-BOLE.FORMULA-MOV-IN 
&Scoped-define FIELD-PAIRS
&Scoped-define ENABLED-TABLES INTEGRAL.PL-BOLE
&Scoped-define FIRST-ENABLED-TABLE INTEGRAL.PL-BOLE
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-FIELDS INTEGRAL.PL-BOLE.FORMULA-MOV-IN ~
INTEGRAL.PL-BOLE.CodMov 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-DESMOV 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Menu Definitions                                                     */
DEFINE SUB-MENU m_Insertar 
       MENU-ITEM m_Conceptos    LABEL "&Conceptos"    
       MENU-ITEM m_Variables    LABEL "&Variables"    
       MENU-ITEM m_Campos       LABEL "C&ampos"       
       MENU-ITEM m_Funciones    LABEL "&Funciones"    .

DEFINE MENU POPUP-MENU-FORMULA-MOV-IN 
       MENU-ITEM m_Verificar_sintaxis LABEL "&Verificar sintaxis"
       SUB-MENU  m_Insertar     LABEL "&Insertar"     
       RULE
       MENU-ITEM m_Cortar       LABEL "Cor&tar"       
       MENU-ITEM m_Copiar       LABEL "&Copiar"       
       MENU-ITEM m_Pegar        LABEL "&Pegar"        
       RULE
       MENU-ITEM m_Ayuda        LABEL "&Ayuda"        .


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-DESMOV AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44.72 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 72 BY 10.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     INTEGRAL.PL-BOLE.FORMULA-MOV-IN AT ROW 2.54 COL 1.72 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 70.29 BY 8.27
          FONT 2
     INTEGRAL.PL-BOLE.CodMov AT ROW 1.23 COL 7.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .81
     FILL-IN-DESMOV AT ROW 1.23 COL 13.29 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 1 COL 1
     " F¢rmula:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 1.92 COL 2.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.PL-BOLE,integral.PL-CALC
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 10.04
         WIDTH              = 72.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN INTEGRAL.PL-BOLE.CodMov IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DESMOV IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       INTEGRAL.PL-BOLE.FORMULA-MOV-IN:RETURN-INSERTED IN FRAME F-Main  = TRUE
       INTEGRAL.PL-BOLE.FORMULA-MOV-IN:POPUP-MENU IN FRAME F-Main       = MENU POPUP-MENU-FORMULA-MOV-IN:HANDLE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME INTEGRAL.PL-BOLE.FORMULA-MOV-IN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-BOLE.FORMULA-MOV-IN V-table-Win
ON BACK-TAB OF INTEGRAL.PL-BOLE.FORMULA-MOV-IN IN FRAME F-Main /* FORMULA!REGISTRADA */
DO:
  DEFINE VAR Tab_Char AS CHAR    INIT " " NO-UNDO.
  DEFINE VAR Tab_Stop AS INTEGER INIT 4   NO-UNDO.
  DEFINE VAR Tab_Over AS INTEGER NO-UNDO.
  DEFINE VAR Tab_Back AS INTEGER NO-UNDO.
  DEFINE VAR Temp AS LOGICAL NO-UNDO.

  Tab_Over = ( Tab_Stop - 
             ( SELF:CURSOR-CHAR MOD Tab_Stop ) ) + 1.
  Tab_Back = ( Tab_Stop - ( Tab_Over MOD Tab_Stop ) ).
  IF ( SELF:CURSOR-CHAR - Tab_Back < 1 )
  THEN ASSIGN SELF:CURSOR-CHAR = 1 NO-ERROR.   
  ELSE ASSIGN SELF:CURSOR-CHAR = ( SELF:CURSOR-CHAR - Tab_Back ) NO-ERROR.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-BOLE.FORMULA-MOV-IN V-table-Win
ON TAB OF INTEGRAL.PL-BOLE.FORMULA-MOV-IN IN FRAME F-Main /* FORMULA!REGISTRADA */
DO:
   
  DEFINE VAR Tab_Char AS CHAR    INIT " " NO-UNDO.
  DEFINE VAR Tab_Stop AS INTEGER INIT 4   NO-UNDO.
  DEFINE VAR Tab_Over AS INTEGER NO-UNDO.
  DEFINE VAR Temp     AS LOGICAL NO-UNDO.
  
  IF ( SELF:TEXT-SELECTED )
  THEN ASSIGN Tab_Over = Tab_Stop
              Temp = SELF:REPLACE-SELECTION-TEXT( 
                     FILL(Tab_Char , Tab_Over) ) .
  ELSE ASSIGN Tab_Over = ( Tab_Stop - 
                   ( SELF:CURSOR-CHAR MOD Tab_Stop ) ) + 1
              Temp = SELF:INSERT-STRING( FILL(Tab_Char , Tab_Over) ).
 
  RETURN NO-APPLY.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "integral.PL-BOLE"}
  {src/adm/template/row-list.i "integral.PL-CALC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "integral.PL-BOLE"}
  {src/adm/template/row-find.i "integral.PL-CALC"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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

  /* ACTUALIZANDO LA INTERPREACION PROGRESS */
  FIND FIRST PL-PLAN WHERE PL-PLAN.codpln = PL-CALC.codpln NO-LOCK NO-ERROR.
  IF AVAILABLE PL-PLAN THEN DO:
    IF PL-PLAN.tippln = YES THEN DO:
        RUN PLN/p-ck2-fm.p ( 
          integral.PL-CALC.Main-Block-Cal-OK,
          integral.PL-BOLE.FORMULA-MOV-IN,
          integral.PL-BOLE.CODMOV,
          integral.PL-BOLE.TPOBOL,
        OUTPUT integral.PL-BOLE.FORMULA-MOV-OK,
        OUTPUT integral.PL-BOLE.ERROR-MSG-MOV      ).
    END.
    IF PL-PLAN.tippln = NO THEN DO:
        RUN PLN/p-chk-fm.p ( 
          integral.PL-CALC.Main-Block-Cal-OK,
          integral.PL-BOLE.FORMULA-MOV-IN,
          integral.PL-BOLE.CODMOV,
          integral.PL-BOLE.TPOBOL,
        OUTPUT integral.PL-BOLE.FORMULA-MOV-OK,
        OUTPUT integral.PL-BOLE.ERROR-MSG-MOV      ).
    END.
  END.
  integral.PL-BOLE.ERROR-MOV = ( integral.PL-BOLE.ERROR-MSG-MOV <> "" ).

  IF integral.PL-BOLE.ERROR-MSG-MOV <> ""
  THEN MESSAGE integral.PL-BOLE.ERROR-MSG-MOV VIEW-AS ALERT-BOX ERROR TITLE "ERRORES DE INTERPRETACION".

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

  /* Code placed here will execute AFTER standard behavior.    */
  FIND PL-CONC WHERE PL-CONC.CodMov = PL-BOLE.CodMov NO-LOCK NO-ERROR.
  FILL-IN-DESMOV:SCREEN-VALUE IN FRAME F-Main
     = IF AVAILABLE PL-CONC THEN PL-CONC.DesMov ELSE "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "integral.PL-BOLE"}
  {src/adm/template/snd-list.i "integral.PL-CALC"}

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


