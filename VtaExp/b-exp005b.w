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
DEF SHARED VAR s-codcia   AS INT.
DEF SHARED VAR s-user-id  AS CHAR.

DEF VAR cl-codcia AS INT NO-UNDO.
DEF VAR x-Estado  AS CHAR NO-UNDO.

FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.

DEF SHARED VAR lh_handle AS HANDLE.

DEF VAR x-HorIni AS CHAR NO-UNDO.
DEF VAR x-HorFin AS CHAR NO-UNDO.

DEFINE BUFFER B-TAREA FOR ExpTarea.
DEFINE BUFFER BB-TAREA FOR ExpTarea.
DEFINE TEMP-TABLE T-TAREA LIKE ExpTarea.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES ExpDigit
&Scoped-define FIRST-EXTERNAL-TABLE ExpDigit


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ExpDigit.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ExpTarea gn-ven gn-clie

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ExpTarea.NroSec ExpTarea.Tipo ~
ExpTarea.Block ExpTarea.CodVen ExpTarea.Turno ExpTarea.NroDig gn-ven.NomVen ~
ExpTarea.CodCli gn-clie.NomCli x-HorIni @ x-HorIni x-HorFin @ x-HorFin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table ExpTarea.Tipo ~
ExpTarea.Block ExpTarea.Turno ExpTarea.NroDig 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table ExpTarea
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table ExpTarea
&Scoped-define QUERY-STRING-br_table FOR EACH ExpTarea OF ExpDigit WHERE ~{&KEY-PHRASE} ~
      AND ExpTarea.Estado = "P" NO-LOCK, ~
      EACH gn-ven OF ExpTarea NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.CodCli = ExpTarea.CodCli ~
  AND gn-clie.CodCia = cl-codcia NO-LOCK ~
    BY ExpTarea.NroSec ~
       BY ExpTarea.Block ~
        BY ExpTarea.Turno
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH ExpTarea OF ExpDigit WHERE ~{&KEY-PHRASE} ~
      AND ExpTarea.Estado = "P" NO-LOCK, ~
      EACH gn-ven OF ExpTarea NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.CodCli = ExpTarea.CodCli ~
  AND gn-clie.CodCia = cl-codcia NO-LOCK ~
    BY ExpTarea.NroSec ~
       BY ExpTarea.Block ~
        BY ExpTarea.Turno.
&Scoped-define TABLES-IN-QUERY-br_table ExpTarea gn-ven gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ExpTarea
&Scoped-define SECOND-TABLE-IN-QUERY-br_table gn-ven
&Scoped-define THIRD-TABLE-IN-QUERY-br_table gn-clie


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table BUTTON-6 BUTTON-7 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fHora B-table-Win 
FUNCTION fHora RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-F-Main 
       MENU-ITEM m_Liberar      LABEL "Liberar"       .


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-6 
     LABEL "Subir" 
     SIZE 9 BY 1.12.

DEFINE BUTTON BUTTON-7 
     LABEL "Bajar" 
     SIZE 9 BY 1.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      ExpTarea, 
      gn-ven, 
      gn-clie SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      ExpTarea.NroSec COLUMN-LABEL "Secuencia" FORMAT ">,>>>,>>9":U
      ExpTarea.Tipo FORMAT "X":U
      ExpTarea.Block FORMAT "x":U
      ExpTarea.CodVen COLUMN-LABEL "Vendedor" FORMAT "X(3)":U
      ExpTarea.Turno FORMAT ">>>9":U
      ExpTarea.NroDig COLUMN-LABEL "Digita" FORMAT ">,>>>,>>9":U
      gn-ven.NomVen FORMAT "X(30)":U
      ExpTarea.CodCli COLUMN-LABEL "<<<Cliente>>>" FORMAT "x(11)":U
      gn-clie.NomCli FORMAT "x(40)":U
      x-HorIni @ x-HorIni COLUMN-LABEL "<Inicio>" FORMAT "XX:XX":U
      x-HorFin @ x-HorFin COLUMN-LABEL "<Final>" FORMAT "XX:XX":U
  ENABLE
      ExpTarea.Tipo HELP "[V] venta [I] interconsulta"
      ExpTarea.Block
      ExpTarea.Turno
      ExpTarea.NroDig
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 114 BY 8.08
         FONT 4
         TITLE "TAREAS PENDIENTES".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     BUTTON-6 AT ROW 3.15 COL 116 WIDGET-ID 2
     BUTTON-7 AT ROW 4.23 COL 116 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.ExpDigit
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
         HEIGHT             = 8.35
         WIDTH              = 136.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:POPUP-MENU       = MENU POPUP-MENU-F-Main:HANDLE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.ExpTarea OF INTEGRAL.ExpDigit,INTEGRAL.gn-ven OF INTEGRAL.ExpTarea,INTEGRAL.gn-clie WHERE INTEGRAL.ExpTarea ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ",,"
     _OrdList          = "INTEGRAL.ExpTarea.NroSec|yes,INTEGRAL.ExpTarea.Block|yes,INTEGRAL.ExpTarea.Turno|yes"
     _Where[1]         = "ExpTarea.Estado = ""P"""
     _JoinCode[3]      = "INTEGRAL.gn-clie.CodCli = INTEGRAL.ExpTarea.CodCli
  AND INTEGRAL.gn-clie.CodCia = cl-codcia"
     _FldNameList[1]   > INTEGRAL.ExpTarea.NroSec
"ExpTarea.NroSec" "Secuencia" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.ExpTarea.Tipo
"ExpTarea.Tipo" ? ? "character" ? ? ? ? ? ? yes "[V] venta [I] interconsulta" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.ExpTarea.Block
"ExpTarea.Block" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.ExpTarea.CodVen
"ExpTarea.CodVen" "Vendedor" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.ExpTarea.Turno
"ExpTarea.Turno" ? ? "integer" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.ExpTarea.NroDig
"ExpTarea.NroDig" "Digita" ? "integer" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.gn-ven.NomVen
"gn-ven.NomVen" ? "X(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.ExpTarea.CodCli
"ExpTarea.CodCli" "<<<Cliente>>>" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.gn-clie.NomCli
"gn-clie.NomCli" ? "x(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"x-HorIni @ x-HorIni" "<Inicio>" "XX:XX" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"x-HorFin @ x-HorFin" "<Final>" "XX:XX" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* TAREAS PENDIENTES */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* TAREAS PENDIENTES */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* TAREAS PENDIENTES */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ExpTarea.Tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ExpTarea.Tipo br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ExpTarea.Tipo IN BROWSE br_table /* Tipo */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ExpTarea.Tipo br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF ExpTarea.Tipo IN BROWSE br_table /* Tipo */
OR F8 OF ExpTarea.Tipo DO:
  ASSIGN
    output-var-2 = ''.
  RUN vtaexp/c-exp001 (OUTPUT output-var-2).
  IF Output-var-2 <> '' THEN SELF:SCREEN-VALUE = output-var-2.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ExpTarea.Block
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ExpTarea.Block br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ExpTarea.Block IN BROWSE br_table /* Terminal */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ExpTarea.Turno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ExpTarea.Turno br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ExpTarea.Turno IN BROWSE br_table /* Turno */
DO:
  FIND LAST ExpTurno WHERE ExpTurno.codcia = ExpDigit.codcia
    AND ExpTurno.coddiv = ExpDigit.coddiv
    AND ExpTurno.block  = ExpTarea.Block:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    AND ExpTurno.fecha <= TODAY
    AND ExpTurno.tipo = ExpTarea.Tipo:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    AND ExpTurno.turno = INTEGER(ExpTarea.Turno:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    NO-LOCK NO-ERROR.
  IF AVAILABLE ExpTurno THEN DO:
    ASSIGN
        ExpTarea.codven:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ExpTurno.codven
        ExpTarea.codcli:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ExpTurno.codcli.
  END.
            
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 B-table-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Subir */
DO:
  RUN Subir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 B-table-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* Bajar */
DO:
  RUN Bajar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Liberar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Liberar B-table-Win
ON CHOOSE OF MENU-ITEM m_Liberar /* Liberar */
DO:
    RUN Liberar.
    RUN adm-open-query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF ExpTarea.Block, ExpTarea.Tipo, ExpTarea.Turno DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

ON FIND OF ExpTarea DO:
    ASSIGN
        x-HorIni = SUBSTRING(ExpTarea.HorIni, 9,4)
        x-HorFin = SUBSTRING(ExpTarea.HorFin, 9,4).
END.

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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "ExpDigit"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ExpDigit"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Bajar B-table-Win 
PROCEDURE Bajar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DEFINE VAR x-row01 AS ROWID NO-UNDO.
    DEFINE VAR x-row02 AS ROWID NO-UNDO.
    DEFINE VAR num AS INT INIT 1.
    
    DEFINE VARIABLE i-NroSec01 AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-NroSec02 AS INTEGER     NO-UNDO.
    
    x-row01 = ROWID(ExpTarea). 
    REPOSITION {&BROWSE-NAME} FORWARDS 0.
    /*GET PREV {&BROWSE-NAME}.*/
    IF NOT AVAIL (ExpTarea) THEN DO:
        REPOSITION {&BROWSE-NAME} BACKWARDS 1.
        GET NEXT {&BROWSE-NAME}.
        RETURN.
    END.
    x-row02 = ROWID(ExpTarea).
    
    /*Captura los numeros de serie*/
    FIND FIRST b-tarea WHERE ROWID(b-tarea) = x-row01 NO-LOCK NO-ERROR.
    IF AVAIL b-tarea THEN i-NroSec01 = b-tarea.NroSec.
    FIND FIRST b-tarea WHERE ROWID(b-tarea) = x-row02 NO-LOCK NO-ERROR.
    IF AVAIL b-tarea THEN i-NroSec02 = b-tarea.NroSec.

    /*Asigna las nuevas secuencias*/
    FIND FIRST b-tarea WHERE ROWID(b-tarea) = x-row01 EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL b-tarea THEN b-tarea.NroSec = i-NroSec02.
    FIND FIRST b-tarea WHERE ROWID(b-tarea) = x-row02 EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL b-tarea THEN b-tarea.NroSec = i-NroSec01.
    
    RUN dispatch IN THIS-PROCEDURE ('open-query').
    FIND ExpTarea WHERE ROWID(ExpTarea) = x-row01.
    REPOSITION {&BROWSE-NAME} TO ROWID ROWID(ExpTarea).
    RUN dispatch IN THIS-PROCEDURE ('row-changed').



/*     DEF VAR iOrden AS INT NO-UNDO.                                                     */
/*     DEF VAR xOrden AS INT NO-UNDO.                                                     */
/*     DEF VAR rRecord AS RAW NO-UNDO.                                                    */
/*                                                                                        */
/*     FIND FIRST B-TAREA WHERE ROWID(B-TAREA) = ROWID(ExpTarea) EXCLUSIVE-LOCK NO-ERROR. */
/*     IF NOT AVAILABLE B-TAREA THEN RETURN.                                              */
/*                                                                                        */
/*     iOrden = B-TAREA.NroSec.                                                           */
/*     FIND LAST BB-TAREA.                                                                */
/*     IF iOrden = BB-TAREA.NroSec THEN RETURN.                                           */
/*     RAW-TRANSFER B-TAREA TO rRecord.                                                   */
/*     DELETE B-TAREA.                                                                    */
/*                                                                                        */
/*     FIND B-TAREA WHERE B-TAREA.NroSec = iOrden + 1.                                    */
/*     B-TAREA.NroSec = iOrden.                                                           */
/*     CREATE B-TAREA.                                                                    */
/*     RAW-TRANSFER rRecord TO B-TAREA.                                                   */
/*     B-TAREA.NroSec = iOrden + 1.                                                       */
/*                                                                                        */
/*     RUN dispatch IN THIS-PROCEDURE ('open-query').                                     */
/*     FIND ExpTarea WHERE ExpTarea.NroSec = iOrden + 1.                                  */
/*     REPOSITION {&BROWSE-NAME} TO ROWID ROWID(ExpTarea).                                */
/*     RUN dispatch IN THIS-PROCEDURE ('row-changed').                                    */


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Liberar B-table-Win 
PROCEDURE Liberar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FIND b-tarea WHERE ROWID(b-tarea) = ROWID(exptarea) EXCLUSIVE-LOCK NO-ERROR.
  IF AVAIL b-tarea THEN DO:
      ASSIGN
          B-Tarea.Estado = 'C'
          B-Tarea.HorFin = STRING(YEAR(TODAY), '9999') +
                            STRING(MONTH(TODAY), '99') +
                            STRING(DAY(TODAY), '99') +
                            SUBSTRING(STRING(TIME, 'HH:MM'),1,2) +
                            SUBSTRING(STRING(TIME, 'HH:MM'),4,2).
    RELEASE B-Tarea.
    RETURN 'OK'.
    
  END.
  ELSE RETURN 'ADM-ERROR'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF CAN-FIND(FIRST ExpTarea OF ExpDigit WHERE ExpTarea.Estado = 'P' NO-LOCK)
  THEN DO:
    MESSAGE 'Debe LIBERAR una tarea antes de asignar otra' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       Solo se puede crear, mas no modificar
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    ExpTarea.CodCia  = ExpDigit.codcia
    ExpTarea.CodDig  = ExpDigit.coddig
    ExpTarea.CodDiv  = ExpDigit.coddiv
    ExpTarea.NroSec  = NEXT-VALUE(ExpTurnoDigitacion)
    ExpTarea.Fecha   = TODAY 
    ExpTarea.Estado  = 'P'
    ExpTarea.CodCli  = ExpTurno.codcli
    ExpTarea.CodVen  = ExpTurno.codven
    ExpTarea.Usuario = s-user-id
    ExpTarea.HorIni  = STRING(YEAR(TODAY), '9999') +
                        STRING(MONTH(TODAY), '99') +
                        STRING(DAY(TODAY), '99') +
                        SUBSTRING(STRING(TIME, 'HH:MM'),1,2) +
                        SUBSTRING(STRING(TIME, 'HH:MM'),4,2).
  /*Fecha Registro*/
  FIND ExpTurno WHERE ExpTurno.CodCia = s-codcia
      AND ExpTurno.CodDiv = ExpDigit.coddiv
      AND ExpTurno.CodCli = ExpTarea.CodCli
      AND ExpTurno.BLOCK  = ExpTarea.Block
      AND ExpTurno.Turno  = ExpTarea.Turno
      AND ExpTurno.NroDig = ExpTarea.NroDig NO-ERROR.
  IF AVAIL ExpTurno THEN DO: 
      ASSIGN 
          ExpTarea.Libre_f01 = ExpTurno.Fecha
          ExpTurno.EstDig    = "C". 
  END.  
  IF AVAILABLE(ExpTurno) THEN RELEASE ExpTurno.

  RUN Case-Procedure IN lh_handle ('Pinta-Cabecera').
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
/*   IF ExpTarea.Estado = 'P' THEN DO:                        */
/*     MESSAGE 'Debe LIBERAR las tareas antes de eliminarlas' */
/*         VIEW-AS ALERT-BOX ERROR.                           */
/*     RETURN 'ADM-ERROR'.                                    */
/*   END.                                                     */

    /*Busca Pre-Pedidos*/
    FIND LAST VtaCDocu WHERE VtaCDocu.CodCia = s-codcia
        AND VtaCDocu.CodDiv = ExpTarea.CodDiv
        AND VtaCDocu.CodCli = ExpTarea.CodCli
        AND TO-ROWID(VtaCDocu.Libre_c01) = ROWID(ExpTarea)
        NO-LOCK NO-ERROR.
    IF AVAIL VtaCDocu AND VtaCDocu.FlgEst <> "A" THEN DO:
        MESSAGE "Existe una Pre-Cotización para este Cliente"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "adm-error".
    END.

    FIND ExpTurno WHERE ExpTurno.CodCia = s-codcia
        AND ExpTurno.CodDiv = ExpDigit.coddiv
        AND ExpTurno.CodCli = ExpTarea.CodCli
        AND ExpTurno.BLOCK  = ExpTarea.Block
        AND ExpTurno.Turno  = ExpTarea.Turno
        AND ExpTurno.NroDig = ExpTarea.NroDig NO-ERROR.
    IF AVAIL ExpTurno THEN DO: 
        ASSIGN 
            ExpTarea.Libre_f01 = ?
            ExpTurno.EstDig    = "P". 
    END.  
    IF AVAILABLE(ExpTurno) THEN RELEASE ExpTurno.

    RUN Case-Procedure IN lh_handle ('Pinta-Cabecera').


  /**
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  **/
  /* Code placed here will execute AFTER standard behavior.    */

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
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
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
  {src/adm/template/snd-list.i "ExpDigit"}
  {src/adm/template/snd-list.i "ExpTarea"}
  {src/adm/template/snd-list.i "gn-ven"}
  {src/adm/template/snd-list.i "gn-clie"}

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

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Subir B-table-Win 
PROCEDURE Subir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR x-row01 AS ROWID NO-UNDO.
    DEFINE VAR x-row02 AS ROWID NO-UNDO.
    
    DEFINE VARIABLE i-NroSec01 AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-NroSec02 AS INTEGER     NO-UNDO.
    
    x-row01 = ROWID(ExpTarea). 
    REPOSITION {&BROWSE-NAME} BACKWARD 1 NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        GET NEXT {&BROWSE-NAME}.
        RETURN.
    END.
    GET PREV {&BROWSE-NAME}.
    x-row02 = ROWID(ExpTarea).
    
    /*Captura los numeros de serie*/
    FIND FIRST b-tarea WHERE ROWID(b-tarea) = x-row01 NO-LOCK NO-ERROR.
    IF AVAIL b-tarea THEN i-NroSec01 = b-tarea.NroSec.
    FIND FIRST b-tarea WHERE ROWID(b-tarea) = x-row02 NO-LOCK NO-ERROR.
    IF AVAIL b-tarea THEN i-NroSec02 = b-tarea.NroSec.
    
    /*Asigna las nuevas secuencias*/
    FIND FIRST b-tarea WHERE ROWID(b-tarea) = x-row01 EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL b-tarea THEN b-tarea.NroSec = i-NroSec02.
    FIND FIRST b-tarea WHERE ROWID(b-tarea) = x-row02 EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL b-tarea THEN b-tarea.NroSec = i-NroSec01.
    
    RUN dispatch IN THIS-PROCEDURE ('open-query').
    FIND ExpTarea WHERE ROWID(ExpTarea) = x-row01.
    REPOSITION {&BROWSE-NAME} TO ROWID ROWID(ExpTarea).
    RUN dispatch IN THIS-PROCEDURE ('row-changed').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  EN CASO DE ERROR RETORNAR : RETURN "ADM-ERROR"
------------------------------------------------------------------------------*/

  IF LOOKUP(ExpTarea.Tipo:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}, 'V,I') = 0
      THEN DO:
      MESSAGE 'El Tipo debe ser V o I' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ExpTarea.Tipo IN BROWSE {&BROWSE-NAME}.
      RETURN 'ADM-ERROR'.
  END.

  FIND LAST ExpTurno WHERE ExpTurno.codcia = ExpDigit.codcia
      AND ExpTurno.coddiv = ExpDigit.coddiv
      AND ExpTurno.block  = ExpTarea.Block:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      AND ExpTurno.fecha >= TODAY - 1
      AND ExpTurno.fecha <= TODAY
      AND ExpTurno.tipo   = ExpTarea.Tipo:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      AND ExpTurno.turno  = INTEGER(ExpTarea.Turno:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      AND ExpTurno.NroDig = INTEGER(ExpTarea.NroDig:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) /*Nro Digitacion*/
      NO-LOCK NO-ERROR.
  
  IF NOT AVAILABLE ExpTurno THEN DO:
      MESSAGE 'No hay registrado ningun turno' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.  
  ELSE DO:
      IF ExpTurno.EstDig = 'C' THEN DO:
          MESSAGE 'Cliente ya tiene turno de Digitación' VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
  END.

  IF ExpTurno.Estado = 'A' THEN DO:
      MESSAGE 'Este turno ha sido ANULADO' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.

  IF ExpTurno.Estado = 'C' THEN DO:
      MESSAGE 'Este turno ha sido CERRADO' SKIP
          'Continuamos con la asignación de tarea?'
          VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE Rpta-1 AS LOG.
      IF Rpta-1 = NO THEN RETURN 'ADM-ERROR'.
  END.
  RETURN "OK".
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Consistenciar la modificacion de la fila
  Parameters:  Retornar "ADM-ERROR" en caso de bloquear la modificacion
  Notes:       
------------------------------------------------------------------------------*/
RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  CASE ExpTarea.Estado:
    WHEN 'P' THEN RETURN 'EN PROCESO'.
    WHEN 'C' THEN RETURN 'CERRADO'.
  END CASE.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fHora B-table-Win 
FUNCTION fHora RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

