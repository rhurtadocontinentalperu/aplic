&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*------------------------------------------------------------------------

  File:  

  Description: from BROWSER.W - Basic SmartBrowser Object Template

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

DEF SHARED VAR cb-codcia AS INTE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES INTEGRAL.PL-SECC INTEGRAL.PL-TABLA ~
INTEGRAL.cb-auxi

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table integral.PL-SECC.seccion ~
integral.PL-SECC.CodAnt integral.PL-SECC.Libre_c01 INTEGRAL.PL-TABLA.Nombre ~
INTEGRAL.PL-SECC.Libre_c02 INTEGRAL.cb-auxi.Nomaux 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table integral.PL-SECC.seccion ~
integral.PL-SECC.CodAnt integral.PL-SECC.Libre_c01 ~
INTEGRAL.PL-SECC.Libre_c02 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table integral.PL-SECC
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table integral.PL-SECC
&Scoped-define QUERY-STRING-br_table FOR EACH INTEGRAL.PL-SECC NO-LOCK, ~
      FIRST INTEGRAL.PL-TABLA WHERE PL-TABLA.Codigo = PL-SECC.Libre_c01 ~
      AND PL-TABLA.Tabla = "GE" OUTER-JOIN NO-LOCK, ~
      FIRST INTEGRAL.cb-auxi WHERE cb-auxi.codaux = PL-SECC.Libre_c02 ~
      AND cb-auxi.CodCia = cb-codcia OUTER-JOIN NO-LOCK
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH INTEGRAL.PL-SECC NO-LOCK, ~
      FIRST INTEGRAL.PL-TABLA WHERE PL-TABLA.Codigo = PL-SECC.Libre_c01 ~
      AND PL-TABLA.Tabla = "GE" OUTER-JOIN NO-LOCK, ~
      FIRST INTEGRAL.cb-auxi WHERE cb-auxi.codaux = PL-SECC.Libre_c02 ~
      AND cb-auxi.CodCia = cb-codcia OUTER-JOIN NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_table INTEGRAL.PL-SECC INTEGRAL.PL-TABLA ~
INTEGRAL.cb-auxi
&Scoped-define FIRST-TABLE-IN-QUERY-br_table INTEGRAL.PL-SECC
&Scoped-define SECOND-TABLE-IN-QUERY-br_table INTEGRAL.PL-TABLA
&Scoped-define THIRD-TABLE-IN-QUERY-br_table INTEGRAL.cb-auxi


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      INTEGRAL.PL-SECC, 
      INTEGRAL.PL-TABLA
    FIELDS(INTEGRAL.PL-TABLA.Nombre), 
      INTEGRAL.cb-auxi
    FIELDS(INTEGRAL.cb-auxi.Nomaux) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      integral.PL-SECC.seccion FORMAT "X(60)":U WIDTH 35
      integral.PL-SECC.CodAnt COLUMN-LABEL "Equivalente SUNAT" FORMAT "x(60)":U
      integral.PL-SECC.Libre_c01 COLUMN-LABEL "Gerencia" FORMAT "x(5)":U
      INTEGRAL.PL-TABLA.Nombre FORMAT "x(40)":U WIDTH 33.29
      INTEGRAL.PL-SECC.Libre_c02 COLUMN-LABEL "Centro!de Costo" FORMAT "x(5)":U
      INTEGRAL.cb-auxi.Nomaux COLUMN-LABEL "Descripción" FORMAT "x(50)":U
            WIDTH 29.14
  ENABLE
      integral.PL-SECC.seccion
      integral.PL-SECC.CodAnt
      integral.PL-SECC.Libre_c01
      INTEGRAL.PL-SECC.Libre_c02
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 160 BY 17.19
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
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
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 18.12
         WIDTH              = 164.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.PL-SECC,INTEGRAL.PL-TABLA WHERE INTEGRAL.PL-SECC ...,INTEGRAL.cb-auxi WHERE INTEGRAL.PL-SECC ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST OUTER USED, FIRST OUTER USED"
     _JoinCode[2]      = "PL-TABLA.Codigo = PL-SECC.Libre_c01"
     _Where[2]         = "PL-TABLA.Tabla = ""GE"""
     _JoinCode[3]      = "cb-auxi.codaux = PL-SECC.Libre_c02"
     _Where[3]         = "cb-auxi.CodCia = cb-codcia"
     _FldNameList[1]   > integral.PL-SECC.seccion
"PL-SECC.seccion" ? "X(60)" "character" ? ? ? ? ? ? yes ? no no "35" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.PL-SECC.CodAnt
"PL-SECC.CodAnt" "Equivalente SUNAT" "x(60)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.PL-SECC.Libre_c01
"PL-SECC.Libre_c01" "Gerencia" "x(5)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.PL-TABLA.Nombre
"INTEGRAL.PL-TABLA.Nombre" ? ? "character" ? ? ? ? ? ? no ? no no "33.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.PL-SECC.Libre_c02
"PL-SECC.Libre_c02" "Centro!de Costo" "x(5)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.cb-auxi.Nomaux
"cb-auxi.Nomaux" "Descripción" ? "character" ? ? ? ? ? ? no ? no no "29.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME integral.PL-SECC.Libre_c01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-SECC.Libre_c01 br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF integral.PL-SECC.Libre_c01 IN BROWSE br_table /* Gerencia */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  FIND pl-tabla WHERE PL-TABLA.CodCia = 000 AND
      PL-TABLA.Codigo = SELF:SCREEN-VALUE AND
      PL-TABLA.Tabla = "GE"
      NO-LOCK NO-ERROR.
  IF AVAILABLE PL-TABLA THEN DISPLAY PL-TABLA.Nombre WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-SECC.Libre_c01 br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF integral.PL-SECC.Libre_c01 IN BROWSE br_table /* Gerencia */
OR F8 OF PL-SECC.Libre_c01 DO:
    input-var-1 = "GE".
    input-var-2 = ''.
    input-var-3 = ''.
    output-var-1 = ?.
    RUN lkup/c-pltabla.w('GERENCIA').
    IF output-var-1 <> ? THEN DO:
        SELF:SCREEN-VALUE = output-var-2.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.PL-SECC.Libre_c02
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-SECC.Libre_c02 br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF INTEGRAL.PL-SECC.Libre_c02 IN BROWSE br_table /* Centro!de Costo */
DO:
  FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia AND
      cb-auxi.clfaux = "CCO" AND
      cb-auxi.codaux = SELF:SCREEN-VALUE 
      NO-LOCK NO-ERROR.
  IF AVAILABLE cb-auxi THEN DISPLAY cb-auxi.Nomaux WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.PL-SECC.Libre_c02 br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF INTEGRAL.PL-SECC.Libre_c02 IN BROWSE br_table /* Centro!de Costo */
OR F8 OF PL-SECC.Libre_c02 DO:
    input-var-1 = "CCO".
    input-var-2 = ''.
    input-var-3 = ''.
    output-var-1 = ?.
    RUN lkup/c-auxil.w('CENTRO DE COSTO').
    IF output-var-1 <> ? THEN DO:
        SELF:SCREEN-VALUE = output-var-2.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Valida.
  IF RETURN-VALUE = 'ADM-ERROR'  THEN UNDO, RETURN 'ADM-ERROR'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "INTEGRAL.PL-SECC"}
  {src/adm/template/snd-list.i "INTEGRAL.PL-TABLA"}
  {src/adm/template/snd-list.i "INTEGRAL.cb-auxi"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
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
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida B-table-Win 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF PL-SECC.Libre_c01:SCREEN-VALUE IN BROWSE {&browse-name} > '' THEN DO:
    IF NOT CAN-FIND(FIRST pl-tabla WHERE INTEGRAL.PL-TABLA.CodCia = 000 AND
                    PL-TABLA.Codigo = PL-SECC.Libre_c01:SCREEN-VALUE IN BROWSE {&browse-name} AND
                    PL-TABLA.Tabla = "GE"
                    NO-LOCK)
        THEN DO:
        MESSAGE 'Código de Gerencia no definido' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO PL-SECC.Libre_c01.
        RETURN 'ADM-ERROR'.
    END.
END.

IF PL-SECC.Libre_c02:SCREEN-VALUE IN BROWSE {&browse-name} > '' THEN DO:
    IF NOT CAN-FIND(FIRST cb-auxi WHERE cb-auxi.CodCia = cb-codcia AND
                    cb-auxi.Clfaux = "CCO" AND 
                    cb-auxi.Codaux = PL-SECC.Libre_c02:SCREEN-VALUE IN BROWSE {&browse-name} AND
                    cb-auxi.Libre_L01 = YES NO-LOCK)
        THEN DO:
        MESSAGE 'Centro de Costo no válido' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO PL-SECC.Libre_c02.
        RETURN 'ADM-ERROR'.
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

