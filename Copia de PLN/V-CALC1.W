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
&Scoped-define EXTERNAL-TABLES integral.PL-CALC
&Scoped-define FIRST-EXTERNAL-TABLE integral.PL-CALC


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR integral.PL-CALC.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS INTEGRAL.PL-CALC.Main-Block-Cal-IN ~
INTEGRAL.PL-CALC.CodMov 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}CodMov ~{&FP2}CodMov ~{&FP3}
&Scoped-define ENABLED-TABLES INTEGRAL.PL-CALC
&Scoped-define FIRST-ENABLED-TABLE INTEGRAL.PL-CALC
&Scoped-Define ENABLED-OBJECTS RECT-3 
&Scoped-Define DISPLAYED-FIELDS INTEGRAL.PL-CALC.Main-Block-Cal-IN ~
INTEGRAL.PL-CALC.CodMov 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Menu Definitions                                                     */
DEFINE SUB-MENU m_Isertar 
       MENU-ITEM m_Conceptos    LABEL "&Conceptos"    
       MENU-ITEM m_Variables    LABEL "&Variables"    
       MENU-ITEM m_Formulas     LABEL "&Formulas"     
       MENU-ITEM m_Campos       LABEL "Cam&pos"       .

DEFINE MENU POPUP-MENU-Main-Block-Cal-IN 
       MENU-ITEM m_Verificar_Sintaxis LABEL "&Verificar Sintaxis"
       SUB-MENU  m_Isertar      LABEL "&Insertar"     
       RULE
       MENU-ITEM m_Cortar       LABEL "Cor&tar"       
       MENU-ITEM m_Copiar       LABEL "&Copiar"       
       MENU-ITEM m_Pegar        LABEL "&Pegar"        
       RULE
       MENU-ITEM m_Ayuda        LABEL "&Ayuda"        .


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 95 BY 14.62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     INTEGRAL.PL-CALC.Main-Block-Cal-IN AT ROW 1.23 COL 2 NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 93 BY 12.85
          BGCOLOR 15 FGCOLOR 0 FONT 2
     INTEGRAL.PL-CALC.CodMov AT ROW 14.46 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.14 BY .81
     RECT-3 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.PL-CALC
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
         HEIGHT             = 14.69
         WIDTH              = 95.72.
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

ASSIGN 
       INTEGRAL.PL-CALC.Main-Block-Cal-IN:RETURN-INSERTED IN FRAME F-Main  = TRUE
       INTEGRAL.PL-CALC.Main-Block-Cal-IN:POPUP-MENU IN FRAME F-Main       = MENU POPUP-MENU-Main-Block-Cal-IN:HANDLE.

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

&Scoped-define SELF-NAME INTEGRAL.PL-CALC.Main-Block-Cal-IN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-CALC.Main-Block-Cal-IN V-table-Win
ON BACK-TAB OF INTEGRAL.PL-CALC.Main-Block-Cal-IN IN FRAME F-Main /* Main-Block */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-CALC.Main-Block-Cal-IN V-table-Win
ON TAB OF INTEGRAL.PL-CALC.Main-Block-Cal-IN IN FRAME F-Main /* Main-Block */
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
  {src/adm/template/row-list.i "integral.PL-CALC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
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
        "",
        integral.PL-CALC.Main-Block-Cal-IN,
        0,
        "MAIN-BLOCK",
        OUTPUT integral.PL-CALC.Main-Block-Cal-OK ,
        OUTPUT integral.PL-CALC.ERROR-MSG-CaL      ).
    END.
    IF PL-PLAN.tippln = NO THEN DO:
        RUN PLN/p-chk-fm.p ( 
        "",
        integral.PL-CALC.Main-Block-Cal-IN,
        0,
        "MAIN-BLOCK",
        OUTPUT integral.PL-CALC.Main-Block-Cal-OK ,
        OUTPUT integral.PL-CALC.ERROR-MSG-CaL      ).
    END.
  END.

  integral.PL-CALC.ERROR-Cal = ( integral.PL-CALC.ERROR-MSG-Cal <> "" ).

  IF integral.PL-CALC.ERROR-MSG-Cal <> ""
  THEN MESSAGE integral.PL-CALC.ERROR-MSG-Cal VIEW-AS ALERT-BOX ERROR TITLE "ERRORES DE INTERPRETACION".

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


