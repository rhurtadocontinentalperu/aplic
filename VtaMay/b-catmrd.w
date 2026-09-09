&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
DEF SHARED VAR s-codcia AS INT.

DEF VAR x-Moneda AS CHAR FORMAT 'x(3)' NO-UNDO.

DEF VAR s-Inicia-Busqueda AS LOGIC INIT FALSE.
DEF VAR s-Registro-Actual AS ROWID.

DEF VAR x-CtoLis AS DEC.
DEF VAR x-CtoTot AS DEC.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES MrdMMatg Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table MrdMMatg.codmat Almmmatg.DesMat ~
Almmmatg.DesMar IF Almmmatg.monvta = 1 THEN 'S/.' ELSE 'S/.' @ x-Moneda ~
Almmmatg.UndBas ~
IF Almmmatg.monvta = 1 THEN Almmmatg.CtoLis ELSE Almmmatg.CtoLis * Almmmatg.TpoCmb @ x-CtoLis ~
IF Almmmatg.monvta = 1 THEN Almmmatg.CtoTot ELSE Almmmatg.CtoTot * Almmmatg.TpoCmb @ x-CtoTot ~
MrdMMatg.PreAlt[1] MrdMMatg.PreAlt[2] MrdMMatg.PreAlt[3] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table MrdMMatg.codmat ~
MrdMMatg.PreAlt[1] MrdMMatg.PreAlt[2] MrdMMatg.PreAlt[3] 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}codmat ~{&FP2}codmat ~{&FP3}~
 ~{&FP1}PreAlt[1] ~{&FP2}PreAlt[1] ~{&FP3}~
 ~{&FP1}PreAlt[2] ~{&FP2}PreAlt[2] ~{&FP3}~
 ~{&FP1}PreAlt[3] ~{&FP2}PreAlt[3] ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table MrdMMatg
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table MrdMMatg
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH MrdMMatg WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF MrdMMatg NO-LOCK ~
    BY Almmmatg.DesMar.
&Scoped-define TABLES-IN-QUERY-br_table MrdMMatg Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table MrdMMatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table f-CodMat f-DesMat BUTTON-4 BUTTON-5 
&Scoped-Define DISPLAYED-OBJECTS f-CodMat f-DesMat 

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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-4 
     LABEL "Buscar" 
     SIZE 11 BY 1.12.

DEFINE BUTTON BUTTON-5 
     LABEL "Siguiente" 
     SIZE 11 BY 1.12.

DEFINE VARIABLE f-CodMat AS CHARACTER FORMAT "x(6)":U 
     LABEL "Buscar codigo" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE f-DesMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Buscar Descripcion" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      MrdMMatg, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      MrdMMatg.codmat COLUMN-LABEL "Articulo"
      Almmmatg.DesMat
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)"
      IF Almmmatg.monvta = 1 THEN 'S/.' ELSE 'S/.' @ x-Moneda COLUMN-LABEL "Mon"
      Almmmatg.UndBas
      IF Almmmatg.monvta = 1 THEN Almmmatg.CtoLis ELSE Almmmatg.CtoLis * Almmmatg.TpoCmb @ x-CtoLis COLUMN-LABEL "Costo!S/IGV" FORMAT "->>>,>>9.9999"
      IF Almmmatg.monvta = 1 THEN Almmmatg.CtoTot ELSE Almmmatg.CtoTot * Almmmatg.TpoCmb @ x-CtoTot COLUMN-LABEL "Costo!Total" FORMAT "->>>,>>9.9999"
      MrdMMatg.PreAlt[1] COLUMN-LABEL "Precio A" FORMAT ">,>>9.9999"
      MrdMMatg.PreAlt[2] COLUMN-LABEL "Precio B" FORMAT ">,>>9.9999"
      MrdMMatg.PreAlt[3] COLUMN-LABEL "Precio C" FORMAT ">,>>9.9999"
  ENABLE
      MrdMMatg.codmat
      MrdMMatg.PreAlt[1]
      MrdMMatg.PreAlt[2]
      MrdMMatg.PreAlt[3]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 111 BY 15.96
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 2.35 COL 1
     f-CodMat AT ROW 1.19 COL 11 COLON-ALIGNED
     f-DesMat AT ROW 1.19 COL 35 COLON-ALIGNED
     BUTTON-4 AT ROW 1 COL 88
     BUTTON-5 AT ROW 1 COL 99
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 17.42
         WIDTH              = 111.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

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
     _TblList          = "INTEGRAL.MrdMMatg,INTEGRAL.Almmmatg OF INTEGRAL.MrdMMatg"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ","
     _OrdList          = "INTEGRAL.Almmmatg.DesMar|yes"
     _FldNameList[1]   > INTEGRAL.MrdMMatg.codmat
"MrdMMatg.codmat" "Articulo" ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[2]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   > "_<CALC>"
"IF Almmmatg.monvta = 1 THEN 'S/.' ELSE 'S/.' @ x-Moneda" "Mon" ? ? ? ? ? ? ? ? no ?
     _FldNameList[5]   = INTEGRAL.Almmmatg.UndBas
     _FldNameList[6]   > "_<CALC>"
"IF Almmmatg.monvta = 1 THEN Almmmatg.CtoLis ELSE Almmmatg.CtoLis * Almmmatg.TpoCmb @ x-CtoLis" "Costo!S/IGV" "->>>,>>9.9999" ? ? ? ? ? ? ? no ?
     _FldNameList[7]   > "_<CALC>"
"IF Almmmatg.monvta = 1 THEN Almmmatg.CtoTot ELSE Almmmatg.CtoTot * Almmmatg.TpoCmb @ x-CtoTot" "Costo!Total" "->>>,>>9.9999" ? ? ? ? ? ? ? no ?
     _FldNameList[8]   > INTEGRAL.MrdMMatg.PreAlt[1]
"MrdMMatg.PreAlt[1]" "Precio A" ">,>>9.9999" "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[9]   > INTEGRAL.MrdMMatg.PreAlt[2]
"MrdMMatg.PreAlt[2]" "Precio B" ">,>>9.9999" "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[10]   > INTEGRAL.MrdMMatg.PreAlt[3]
"MrdMMatg.PreAlt[3]" "Precio C" ">,>>9.9999" "decimal" ? ? ? ? ? ? yes ?
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
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


&Scoped-define SELF-NAME MrdMMatg.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL MrdMMatg.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF MrdMMatg.codmat IN BROWSE br_table /* Articulo */
DO:
  ASSIGN
    SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE), '999999')
    NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 B-table-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Buscar */
DO:
  ASSIGN
    s-Inicia-Busqueda = YES
    s-Registro-Actual = ?
    f-DesMat.
  FOR EACH Mrdmmatg NO-LOCK WHERE Mrdmmatg.codcia = s-codcia:
    FIND Almmmatg OF Mrdmmatg NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg AND INDEX(Almmmatg.desmat, f-DesMat) > 0
    THEN DO:
        ASSIGN
            s-Registro-Actual = ROWID(Mrdmmatg).
        REPOSITION {&BROWSE-NAME} TO ROWID s-Registro-Actual NO-ERROR.
        LEAVE.
    END.
  END.      
  IF s-Registro-Actual = ? THEN MESSAGE 'Fin de búsqueda' VIEW-AS ALERT-BOX WARNING.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 B-table-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Siguiente */
DO:
  IF s-Registro-Actual = ? THEN RETURN.
/*  FOR EACH INTEGRAL.VtaDActi OF INTEGRAL.VtaCActi NO-LOCK,
 *       EACH INTEGRAL.gn-clie WHERE INTEGRAL.gn-clie.CodCli = INTEGRAL.VtaDActi.CodCli
 *       AND INTEGRAL.gn-clie.CodCia = cl-codcia NO-LOCK:
 *     IF INDEX(gn-clie.nomcli, FILL-IN-NomCli:SCREEN-VALUE) > 0
 *     THEN DO:
 *         IF s-Registro-Actual = ROWID(VtaDActi) THEN NEXT.
 *         ASSIGN
 *             s-Registro-Actual = ROWID(VTaDActi).
 *         REPOSITION {&BROWSE-NAME} TO ROWID s-Registro-Actual.
 *         LEAVE.
 *     END.
 *   END.      */
  GET NEXT {&BROWSE-NAME}.
  REPEAT WHILE AVAILABLE Mrdmmatg:
    IF INDEX(Almmmatg.desmat, f-DesMat:SCREEN-VALUE) > 0
    THEN DO:
        ASSIGN
            s-Registro-Actual = ROWID(Mrdmmatg).
            REPOSITION {&BROWSE-NAME} TO ROWID s-Registro-Actual.
            LEAVE.
    END.
    GET NEXT {&BROWSE-NAME}.
  END.
  IF NOT AVAILABLE Mrdmmatg THEN s-Registro-Actual = ?.
  IF s-Registro-Actual = ? THEN MESSAGE 'Fin de búsqueda' VIEW-AS ALERT-BOX WARNING.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-CodMat B-table-Win
ON LEAVE OF f-CodMat IN FRAME F-Main /* Buscar codigo */
DO:
  DEF VAR x-CodMat LIKE f-CodMat NO-UNDO.
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  ASSIGN
    x-CodMat = STRING(INTEGER(SELF:SCREEN-VALUE), '999999') NO-ERROR.
  SELF:SCREEN-VALUE = ''.
  IF ERROR-STATUS:ERROR THEN RETURN.
  FIND Mrdmmatg WHERE Mrdmmatg.codcia = s-codcia
    AND Mrdmmatg.codmat = x-codmat NO-LOCK NO-ERROR.
  IF AVAILABLE Mrdmmatg THEN DO:
    REPOSITION {&BROWSE-NAME} TO ROWID ROWID(Mrdmmatg) NO-ERROR.
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

ON RETURN OF MrdMMatg.codmat, MrdMMatg.PreAlt[1], MrdMMatg.PreAlt[2] DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    mrdmmatg.codcia = s-codcia.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "MrdMMatg"}
  {src/adm/template/snd-list.i "Almmmatg"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto B-table-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR x-Ok AS LOG NO-UNDO.
  
  SYSTEM-DIALOG GET-FILE x-Archivo  
    ASK-OVERWRITE 
    CREATE-TEST-FILE  
    DEFAULT-EXTENSION 'txt'  
    MUST-EXIST  
    SAVE-AS  
    TITLE 'Archivo a Guardar'   
    UPDATE x-Ok.
  
  IF x-Ok = NO THEN RETURN.
  OUTPUT TO VALUE(x-Archivo).
  FOR EACH Mrdmmatg WHERE Mrdmmatg.codcia = s-codcia NO-LOCK,
        FIRST Almmmatg OF Mrdmmatg NO-LOCK
        BY Almmmatg.desmar:
    DISPLAY 
        Mrdmmatg.codmat         COLUMN-LABEL 'Articulo'
        Almmmatg.desmat         COLUMN-LABEL 'Descripcion'
        Almmmatg.desmar         COLUMN-LABEL 'Marca'
        IF Almmmatg.monvta = 1 THEN 'S/.' ELSE 'S/.' @ x-Moneda COLUMN-LABEL "Moneda"
        Almmmatg.undbas         COLUMN-LABEL 'Unidad Basica'
        IF Almmmatg.monvta = 1 THEN Almmmatg.CtoLis ELSE Almmmatg.CtoLis * Almmmatg.TpoCmb @ x-CtoLis COLUMN-LABEL "Costo sin IGV"
        IF Almmmatg.monvta = 1 THEN Almmmatg.CtoTot ELSE Almmmatg.CtoTot * Almmmatg.TpoCmb @ x-CtoTot COLUMN-LABEL "Costo con IGV"
        MrdMMatg.PreAlt[1]      COLUMN-LABEL 'Precio A'
        MrdMMatg.PreAlt[2]      COLUMN-LABEL 'Precio B'
        MrdMMatg.PreAlt[3]      COLUMN-LABEL 'Precio C'
        WITH STREAM-IO NO-BOX WIDTH 320.
  END.
  OUTPUT CLOSE.
  MESSAGE 'Se generó el archivo' x-archivo VIEW-AS ALERT-BOX.
  
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
  FIND Almmmatg WHERE almmmatg.codcia = s-codcia
    AND almmmatg.codmat = MrdMMatg.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg
  THEN DO:
    MESSAGE 'Artículo NO registrado' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO MrdMMatg.codmat IN BROWSE {&BROWSE-NAME}.
    RETURN 'ADM-ERROR'.
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
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


