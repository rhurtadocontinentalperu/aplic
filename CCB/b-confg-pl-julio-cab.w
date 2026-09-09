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

DEF VAR s-Tabla AS CHAR INIT 'PLTJULIO' NO-UNDO.

DEF VAR x-NomFam AS CHAR NO-UNDO.

&SCOPED-DEFINE Condicion (VtaCTabla.CodCia = s-codcia AND VtaCTabla.Tabla = s-Tabla)

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
&Scoped-define INTERNAL-TABLES VtaCTabla Almtfami AlmSFami gn-ConVt

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table VtaCTabla.Libre_c01 ~
(IF AVAILABLE Almtfami THEN Almtfami.DesFam ELSE VTaCTabla.Libre_c01) @ x-NomFam ~
VtaCTabla.Libre_c02 AlmSFami.dessub VtaCTabla.Libre_c03 VtaCTabla.Libre_c04 ~
gn-ConVt.Nombr 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table VtaCTabla.Libre_c01 ~
VtaCTabla.Libre_c02 VtaCTabla.Libre_c03 VtaCTabla.Libre_c04 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table VtaCTabla
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table VtaCTabla
&Scoped-define QUERY-STRING-br_table FOR EACH VtaCTabla WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST Almtfami WHERE Almtfami.CodCia = VtaCTabla.CodCia ~
  AND Almtfami.codfam = VtaCTabla.Libre_c01 OUTER-JOIN NO-LOCK, ~
      FIRST AlmSFami WHERE AlmSFami.CodCia = VtaCTabla.CodCia ~
  AND AlmSFami.codfam = VtaCTabla.Libre_c01 ~
  AND AlmSFami.subfam = VtaCTabla.Libre_c02 OUTER-JOIN NO-LOCK, ~
      FIRST gn-ConVt WHERE gn-ConVt.Codig = VtaCTabla.Libre_c04 OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH VtaCTabla WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST Almtfami WHERE Almtfami.CodCia = VtaCTabla.CodCia ~
  AND Almtfami.codfam = VtaCTabla.Libre_c01 OUTER-JOIN NO-LOCK, ~
      FIRST AlmSFami WHERE AlmSFami.CodCia = VtaCTabla.CodCia ~
  AND AlmSFami.codfam = VtaCTabla.Libre_c01 ~
  AND AlmSFami.subfam = VtaCTabla.Libre_c02 OUTER-JOIN NO-LOCK, ~
      FIRST gn-ConVt WHERE gn-ConVt.Codig = VtaCTabla.Libre_c04 OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table VtaCTabla Almtfami AlmSFami ~
gn-ConVt
&Scoped-define FIRST-TABLE-IN-QUERY-br_table VtaCTabla
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almtfami
&Scoped-define THIRD-TABLE-IN-QUERY-br_table AlmSFami
&Scoped-define FOURTH-TABLE-IN-QUERY-br_table gn-ConVt


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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      VtaCTabla, 
      Almtfami
    FIELDS(Almtfami.DesFam), 
      AlmSFami
    FIELDS(AlmSFami.dessub), 
      gn-ConVt
    FIELDS(gn-ConVt.Nombr) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      VtaCTabla.Libre_c01 COLUMN-LABEL "Linea" FORMAT "x(8)":U
            WIDTH 7.43
      (IF AVAILABLE Almtfami THEN Almtfami.DesFam ELSE VTaCTabla.Libre_c01) @ x-NomFam COLUMN-LABEL "Descripción" FORMAT "x(30)":U
      VtaCTabla.Libre_c02 COLUMN-LABEL "Sub-Linea" FORMAT "x(8)":U
            WIDTH 8.43
      AlmSFami.dessub FORMAT "X(30)":U
      VtaCTabla.Libre_c03 COLUMN-LABEL "Tipo" FORMAT "x(8)":U WIDTH 17.29
            VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "x Condicion de Venta","CV",
                                      "x Fecha de Vencimientos","FV"
                      DROP-DOWN-LIST 
      VtaCTabla.Libre_c04 COLUMN-LABEL "Cond. de Venta" FORMAT "x(8)":U
            WIDTH 11.43
      gn-ConVt.Nombr FORMAT "X(50)":U WIDTH 5.72
  ENABLE
      VtaCTabla.Libre_c01
      VtaCTabla.Libre_c02
      VtaCTabla.Libre_c03
      VtaCTabla.Libre_c04
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 119 BY 10.5
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
         HEIGHT             = 10.81
         WIDTH              = 120.
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
     _TblList          = "INTEGRAL.VtaCTabla,INTEGRAL.Almtfami WHERE INTEGRAL.VtaCTabla ...,INTEGRAL.AlmSFami WHERE INTEGRAL.VtaCTabla ...,INTEGRAL.gn-ConVt WHERE INTEGRAL.VtaCTabla ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST OUTER USED, FIRST OUTER USED, FIRST OUTER USED"
     _Where[1]         = "{&Condicion}"
     _JoinCode[2]      = "Almtfami.CodCia = VtaCTabla.CodCia
  AND Almtfami.codfam = VtaCTabla.Libre_c01"
     _JoinCode[3]      = "AlmSFami.CodCia = VtaCTabla.CodCia
  AND AlmSFami.codfam = VtaCTabla.Libre_c01
  AND AlmSFami.subfam = VtaCTabla.Libre_c02"
     _JoinCode[4]      = "gn-ConVt.Codig = VtaCTabla.Libre_c04"
     _FldNameList[1]   > INTEGRAL.VtaCTabla.Libre_c01
"VtaCTabla.Libre_c01" "Linea" ? "character" ? ? ? ? ? ? yes ? no no "7.43" yes no no "U" "" "" "FILL-IN" "," ? ? 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"(IF AVAILABLE Almtfami THEN Almtfami.DesFam ELSE VTaCTabla.Libre_c01) @ x-NomFam" "Descripción" "x(30)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.VtaCTabla.Libre_c02
"VtaCTabla.Libre_c02" "Sub-Linea" ? "character" ? ? ? ? ? ? yes ? no no "8.43" yes no no "U" "" "" "FILL-IN" "," ? ? 0 no 0 no no
     _FldNameList[4]   = INTEGRAL.AlmSFami.dessub
     _FldNameList[5]   > INTEGRAL.VtaCTabla.Libre_c03
"VtaCTabla.Libre_c03" "Tipo" ? "character" ? ? ? ? ? ? yes ? no no "17.29" yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "x Condicion de Venta,CV,x Fecha de Vencimientos,FV" 5 no 0 no no
     _FldNameList[6]   > INTEGRAL.VtaCTabla.Libre_c04
"VtaCTabla.Libre_c04" "Cond. de Venta" ? "character" ? ? ? ? ? ? yes ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.gn-ConVt.Nombr
"gn-ConVt.Nombr" ? ? "character" ? ? ? ? ? ? no ? no no "5.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME VtaCTabla.Libre_c01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCTabla.Libre_c01 br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF VtaCTabla.Libre_c01 IN BROWSE br_table /* Linea */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  IF SELF:SCREEN-VALUE <> 'OTROS' THEN DO:
      FIND FIRST Almtfami WHERE Almtfami.codcia = s-codcia
          AND Almtfami.codfam = SELF:SCREEN-VALUE 
          AND Almtfami.SwComercial = YES NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almtfami THEN DO:
          MESSAGE 'Línea NO registrada' VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = ''.
          RETURN NO-APPLY.
      END.
      DISPLAY Almtfami.desfam @ x-NomFam WITH BROWSE {&BROWSE-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCTabla.Libre_c01 br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF VtaCTabla.Libre_c01 IN BROWSE br_table /* Linea */
OR F8 OF VtaCTabla.Libre_c01
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?.
    RUN vtagn/d-t-fami-comercial.
    IF output-var-1 <> ? THEN
        ASSIGN
        SELF:SCREEN-VALUE = output-var-2
        x-NomFam = output-var-3.
    DISPLAY x-NomFam WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCTabla.Libre_c02
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCTabla.Libre_c02 br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF VtaCTabla.Libre_c02 IN BROWSE br_table /* Sub-Linea */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  IF VtaCTabla.Libre_c01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = 'OTROS'
      THEN DO:
      SELF:SCREEN-VALUE = ''.
  END.
  ELSE DO:
      FIND Almsfami WHERE AlmSFami.CodCia = s-codcia AND
          AlmSFami.codfam = VtaCTabla.Libre_c01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} AND
          AlmSFami.subfam = VtaCTabla.Libre_c02:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almsfami THEN DO:
          MESSAGE 'Sub-línea NO registrada' VIEW-AS ALERT-BOX ERROR.
          SELF:SCREEN-VALUE = ''.
          RETURN NO-APPLY.
      END.
      DISPLAY AlmSFami.dessub WITH BROWSE {&BROWSE-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCTabla.Libre_c02 br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF VtaCTabla.Libre_c02 IN BROWSE br_table /* Sub-Linea */
OR F8 OF VtaCTabla.Libre_c02
DO:
  ASSIGN
      input-var-1 = VtaCTabla.Libre_c01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      input-var-2 = ''
      input-var-3 = ''
      output-var-1 = ?.
  RUN lkup/c-subfam ('Sub-Líneas').
  IF output-var-1 <> ? THEN DO:
      SELF:SCREEN-VALUE = output-var-2.
      DISPLAY output-var-3 @ AlmSFami.dessub WITH BROWSE {&browse-name}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCTabla.Libre_c04
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCTabla.Libre_c04 br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF VtaCTabla.Libre_c04 IN BROWSE br_table /* Cond. de Venta */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    /* Condición de Venta */
    FIND gn-convt WHERE  gn-ConVt.Codig = SELF:SCREEN-VALUE AND
        gn-convt.estado = "A" AND 
        INDEX(gn-ConVt.Nombr,'LET') > 0
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-convt THEN DO:
        MESSAGE 'Condición de Venta NO válida' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    DISPLAY gn-ConVt.Nombr WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCTabla.Libre_c04 br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF VtaCTabla.Libre_c04 IN BROWSE br_table /* Cond. de Venta */
OR F8 OF VtaCTabla.Libre_c04
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?.
    RUN vtagn/d-t-convt-letra.
    IF output-var-1 <> ? THEN DO:
        ASSIGN SELF:SCREEN-VALUE = output-var-2.
        DISPLAY output-var-3 @ gn-ConVt.Nombr WITH BROWSE {&BROWSE-NAME}.
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

ON 'RETURN':U OF VtaCTabla.Libre_c01, 
    VtaCTabla.Libre_c02, 
    VtaCTabla.Libre_c03, 
    VtaCTabla.Libre_c04
DO:
    APPLY 'TAB':U.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      VtaCTabla.CodCia = s-codcia 
      VtaCTabla.Tabla = s-Tabla
      VtaCTabla.Llave = VtaCTabla.Libre_c01 + '|' + VtaCTabla.Libre_c02
      NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
      RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
      UNDO, RETURN 'ADM-ERROR'.
  END.
  IF VtaCTabla.Libre_c01 = 'OTROS' THEN VtaCTabla.Libre_c02 = ''.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FOR EACH Vtadtabla OF Vtactabla EXCLUSIVE-LOCK:
      DELETE Vtadtabla.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields B-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN DO:
      ASSIGN 
          VtaCTabla.Libre_c01:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES
          VtaCTabla.Libre_c02:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
  END.
  ELSE DO:
      ASSIGN 
          VtaCTabla.Libre_c01:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO
          VtaCTabla.Libre_c02:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.
  END.

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
  {src/adm/template/snd-list.i "VtaCTabla"}
  {src/adm/template/snd-list.i "Almtfami"}
  {src/adm/template/snd-list.i "AlmSFami"}
  {src/adm/template/snd-list.i "gn-ConVt"}

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

IF VtaCTabla.Libre_c01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} <> 'OTROS' THEN DO:
    FIND FIRST Almtfami WHERE Almtfami.codcia = s-codcia
        AND Almtfami.codfam = VtaCTabla.Libre_c01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        AND Almtfami.SwComercial = YES NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtfami THEN DO:
        MESSAGE 'Línea NO registrada' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO VtaCTabla.Libre_c01 IN BROWSE {&BROWSE-NAME}.
        RETURN 'ADM-ERROR'.
    END.
END.
IF LOOKUP(VtaCTabla.Libre_c03:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}, 'CV,FV') = 0 THEN DO:
    MESSAGE 'Seleccione un valor para "Tipo"' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO VtaCTabla.Libre_c03 IN BROWSE {&BROWSE-NAME}.
    RETURN 'ADM-ERROR'.
END.
/* Condición de Venta */
IF VtaCTabla.Libre_c04:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} > "" THEN DO:
    IF NOT CAN-FIND(gn-convt WHERE gn-ConVt.Codig =  VtaCTabla.Libre_c04:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                    AND INDEX(gn-ConVt.Nombr, 'LET') > 0 NO-LOCK)
        THEN DO:
        MESSAGE 'Condición de Venta NO válida' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO VtaCTabla.Libre_c04 IN BROWSE {&BROWSE-NAME}.
        RETURN 'ADM-ERROR'.
    END.
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

