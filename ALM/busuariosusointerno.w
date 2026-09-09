&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
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
DEF SHARED VAR s-tabla AS CHAR.
DEF SHARED VAR cb-codcia AS INT.

DEF VAR x-User-Name LIKE integral._User._User-Name NO-UNDO.
DEF VAR x-Nom-Cco AS CHAR NO-UNDO.

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

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES VtaTabla Almacen

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table VtaTabla.Llave_c1 ~
fUsername() @ x-User-Name VtaTabla.LLave_c3 VtaTabla.Llave_c2 ~
fCcoName(VtaTabla.Llave_c2)  @ x-Nom-Cco VtaTabla.Llave_c4 ~
Almacen.Descripcion 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table VtaTabla.Llave_c1 ~
VtaTabla.LLave_c3 VtaTabla.Llave_c2 VtaTabla.Llave_c4 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table VtaTabla
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table VtaTabla
&Scoped-define QUERY-STRING-br_table FOR EACH VtaTabla WHERE ~{&KEY-PHRASE} ~
      AND VtaTabla.CodCia = s-codcia ~
 AND VtaTabla.Tabla = s-tabla NO-LOCK, ~
      FIRST Almacen WHERE Almacen.CodCia = VtaTabla.CodCia ~
  AND Almacen.CodAlm = VtaTabla.Llave_c4 NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH VtaTabla WHERE ~{&KEY-PHRASE} ~
      AND VtaTabla.CodCia = s-codcia ~
 AND VtaTabla.Tabla = s-tabla NO-LOCK, ~
      FIRST Almacen WHERE Almacen.CodCia = VtaTabla.CodCia ~
  AND Almacen.CodAlm = VtaTabla.Llave_c4 NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table VtaTabla Almacen
&Scoped-define FIRST-TABLE-IN-QUERY-br_table VtaTabla
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almacen


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCcoName B-table-Win 
FUNCTION fCcoName RETURNS CHARACTER
  ( INPUT pCco AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fUserName B-table-Win 
FUNCTION fUserName RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      VtaTabla, 
      Almacen SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      VtaTabla.Llave_c1 COLUMN-LABEL "Usuario" FORMAT "x(15)":U
            WIDTH 8.43
      fUsername() @ x-User-Name COLUMN-LABEL "Nombre" FORMAT "x(30)":U
      VtaTabla.LLave_c3 COLUMN-LABEL "Tipo de Usuario" FORMAT "x(8)":U
            VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "Normal","",
                                      "Supervisor","S"
                      DROP-DOWN-LIST 
      VtaTabla.Llave_c2 COLUMN-LABEL "CCO" FORMAT "x(50)":U WIDTH 24.43
      fCcoName(VtaTabla.Llave_c2)  @ x-Nom-Cco COLUMN-LABEL "Descripción" FORMAT "x(256)":U
            WIDTH 43.43
      VtaTabla.Llave_c4 COLUMN-LABEL "Almacen" FORMAT "x(3)":U
            WIDTH 8.43
      Almacen.Descripcion FORMAT "X(40)":U WIDTH 28.72
  ENABLE
      VtaTabla.Llave_c1
      VtaTabla.LLave_c3
      VtaTabla.Llave_c2 HELP "Ejemplo: 04,3F,02"
      VtaTabla.Llave_c4
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 166 BY 21.92
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


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
         HEIGHT             = 23.23
         WIDTH              = 166.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

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
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.VtaTabla,INTEGRAL.Almacen WHERE INTEGRAL.VtaTabla ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST, FIRST OUTER"
     _Where[1]         = "VtaTabla.CodCia = s-codcia
 AND VtaTabla.Tabla = s-tabla"
     _JoinCode[2]      = "Almacen.CodCia = VtaTabla.CodCia
  AND Almacen.CodAlm = VtaTabla.Llave_c4"
     _FldNameList[1]   > INTEGRAL.VtaTabla.Llave_c1
"VtaTabla.Llave_c1" "Usuario" "x(15)" "character" ? ? ? ? ? ? yes ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fUsername() @ x-User-Name" "Nombre" "x(30)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.VtaTabla.LLave_c3
"VtaTabla.LLave_c3" "Tipo de Usuario" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "Normal,,Supervisor,S" 5 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtaTabla.Llave_c2
"VtaTabla.Llave_c2" "CCO" "x(50)" "character" ? ? ? ? ? ? yes "Ejemplo: 04,3F,02" no no "24.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fCcoName(VtaTabla.Llave_c2)  @ x-Nom-Cco" "Descripción" "x(256)" ? ? ? ? ? ? ? no ? no no "43.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.VtaTabla.Llave_c4
"VtaTabla.Llave_c4" "Almacen" "x(3)" "character" ? ? ? ? ? ? yes ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.Almacen.Descripcion
"Almacen.Descripcion" ? ? "character" ? ? ? ? ? ? no ? no no "28.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME VtaTabla.Llave_c1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaTabla.Llave_c1 br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF VtaTabla.Llave_c1 IN BROWSE br_table /* Usuario */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaTabla.Llave_c2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaTabla.Llave_c2 br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF VtaTabla.Llave_c2 IN BROWSE br_table /* CCO */
DO:
    DISPLAY fCcoName(SELF:SCREEN-VALUE) @ x-nom-cco WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaTabla.Llave_c2 br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF VtaTabla.Llave_c2 IN BROWSE br_table /* CCO */
DO:
    ASSIGN
        input-var-1 = "CCO"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?.
    RUN alm/c-ccomultiple ("SELECCIONE UNO MAS CENTROS DE COSTOS").
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaTabla.Llave_c4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaTabla.Llave_c4 br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF VtaTabla.Llave_c4 IN BROWSE br_table /* Almacen */
DO:
    /* ALMACEN */
    FIND almacen WHERE almacen.codcia = s-codcia
        AND almacen.codalm = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE almacen THEN DISPLAY almacen.descrip WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF VtaTabla.Llave_c1, VtaTabla.Llave_c2, VtaTabla.LLave_c3, VtaTabla.Llave_c4
DO:
    APPLY "TAB":U.
    RETURN NO-APPLY.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR x-Rowid AS ROWID NO-UNDO.
  DEF VAR x-Llave_c1 AS CHAR.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      VtaTabla.CodCia = s-codcia
      VtaTabla.Tabla = s-tabla
      x-Rowid = ROWID(VtaTabla)
      x-Llave_c1 = VtaTabla.Llave_c1.
  IF CAN-FIND(FIRST Vtatabla WHERE Vtatabla.codcia = s-codcia
              AND Vtatabla.tabla = s-tabla
              AND Vtatabla.llave_c1 = x-Llave_c1
              AND ROWID(VtaTabla) <> x-Rowid NO-LOCK)
      THEN DO:
      MESSAGE "Usuario duplicado" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY":U TO VtaTabla.Llave_c1 IN BROWSE {&browse-name}.
      RETURN "ADM-ERROR".
  END.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  
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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
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
        WHEN "Llave_c2" THEN DO:
            ASSIGN
                input-var-1 = "CCO"
                input-var-2 = ""
                input-var-3 = "".
        END.
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
  {src/adm/template/snd-list.i "VtaTabla"}
  {src/adm/template/snd-list.i "Almacen"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* USUARIO */
FIND integral._User WHERE integral._User._UserId = VtaTabla.Llave_c1:SCREEN-VALUE IN BROWSE {&browse-name}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE integral._User THEN DO:
    MESSAGE "Usuario no registrado" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY":U TO VtaTabla.Llave_c1.
    RETURN "ADM-ERROR".
END.
/* CCO */
DEF VAR pCco AS CHAR NO-UNDO.
DEF VAR k AS INT NO-UNDO.

pCco = VtaTabla.Llave_c2:SCREEN-VALUE IN BROWSE {&browse-name}.
IF NUM-ENTRIES(pCco) = 0 THEN DO:
    MESSAGE 'Debe registrar un centro de costo' VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY":U TO VtaTabla.Llave_c1.
    RETURN "ADM-ERROR".
END.
IF VtaTabla.LLave_c3:SCREEN-VALUE IN BROWSE {&browse-name} <> "S" AND NUM-ENTRIES(pCco) > 1 THEN DO:
    MESSAGE 'Solo SUPERVISOR puede manejar más de un centro de costo'
        VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY":U TO VtaTabla.Llave_c1.
    RETURN "ADM-ERROR".
END.
DO k = 1 TO NUM-ENTRIES(pCco):
    FIND cb-auxi WHERE cb-auxi.codcia = cb-codcia
        AND cb-auxi.clfaux = "CCO"
        AND cb-auxi.codaux = ENTRY(k, pCco)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-auxi THEN DO:
        MESSAGE "Centro de costo" ENTRY(k, pCco) "no registrado" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO VtaTabla.Llave_c1.
        RETURN "ADM-ERROR".
    END.
END.
/* ALMACEN */
FIND almacen WHERE almacen.codcia = s-codcia
    AND almacen.codalm = VtaTabla.Llave_c4:SCREEN-VALUE IN BROWSE {&browse-name}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE almacen THEN DO:
    MESSAGE "Almacén no registrado" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY":U TO VtaTabla.Llave_c1.
    RETURN "ADM-ERROR".
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCcoName B-table-Win 
FUNCTION fCcoName RETURNS CHARACTER
  ( INPUT pCco AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR k AS INT NO-UNDO.
  DEF VAR x-NomCco AS CHAR NO-UNDO.

  DO k = 1 TO NUM-ENTRIES(pCco):
      FIND cb-auxi WHERE cb-auxi.codcia = cb-codcia
          AND cb-auxi.clfaux = "CCO"
          AND cb-auxi.codaux = ENTRY(k, pCco)
          NO-LOCK NO-ERROR.
      IF AVAILABLE cb-auxi THEN x-NomCco = x-NomCco + (IF x-NomCco = '' THEN '' ELSE ',') + TRIM(cb-auxi.nomaux).
  END.
  RETURN x-NomCco.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fUserName B-table-Win 
FUNCTION fUserName RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND FIRST integral._User WHERE integral._User._UserId = VtaTabla.Llave_c1 NO-LOCK NO-ERROR.
  IF AVAILABLE integral._User THEN RETURN integral._User._User-Name.
  ELSE RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

