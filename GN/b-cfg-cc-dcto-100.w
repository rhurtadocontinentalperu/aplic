&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE b-AlmSFami NO-UNDO LIKE AlmSFami.
DEFINE BUFFER b-almtabla FOR almtabla.
DEFINE BUFFER b-Almtfami FOR Almtfami.



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

DEF SHARED VAR s-codcia AS INTE.

DEF VAR s-Tabla AS CHAR INIT 'CFG_CC_DCT_100' NO-UNDO.

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
&Scoped-define INTERNAL-TABLES FacTabla almtabla Almtfami AlmSFami

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacTabla.Campo-C[1] almtabla.Nombre ~
FacTabla.Campo-C[2] Almtfami.desfam FacTabla.Campo-C[3] AlmSFami.dessub 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table FacTabla.Campo-C[1] ~
FacTabla.Campo-C[2] FacTabla.Campo-C[3] 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table FacTabla
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table FacTabla
&Scoped-define QUERY-STRING-br_table FOR EACH FacTabla WHERE ~{&KEY-PHRASE} ~
      AND FacTabla.CodCia = s-codcia ~
 AND FacTabla.Tabla = s-tabla NO-LOCK, ~
      FIRST almtabla WHERE almtabla.Codigo = FacTabla.Campo-C[1] ~
      AND almtabla.Tabla = "CC" NO-LOCK, ~
      FIRST Almtfami WHERE Almtfami.codfam = FacTabla.Campo-C[2] ~
      AND Almtfami.CodCia = s-codcia NO-LOCK, ~
      FIRST AlmSFami WHERE AlmSFami.codfam = FacTabla.Campo-C[2] ~
  AND AlmSFami.subfam = FacTabla.Campo-C[3] ~
      AND AlmSFami.CodCia = s-codcia NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacTabla WHERE ~{&KEY-PHRASE} ~
      AND FacTabla.CodCia = s-codcia ~
 AND FacTabla.Tabla = s-tabla NO-LOCK, ~
      FIRST almtabla WHERE almtabla.Codigo = FacTabla.Campo-C[1] ~
      AND almtabla.Tabla = "CC" NO-LOCK, ~
      FIRST Almtfami WHERE Almtfami.codfam = FacTabla.Campo-C[2] ~
      AND Almtfami.CodCia = s-codcia NO-LOCK, ~
      FIRST AlmSFami WHERE AlmSFami.codfam = FacTabla.Campo-C[2] ~
  AND AlmSFami.subfam = FacTabla.Campo-C[3] ~
      AND AlmSFami.CodCia = s-codcia NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table FacTabla almtabla Almtfami AlmSFami
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacTabla
&Scoped-define SECOND-TABLE-IN-QUERY-br_table almtabla
&Scoped-define THIRD-TABLE-IN-QUERY-br_table Almtfami
&Scoped-define FOURTH-TABLE-IN-QUERY-br_table AlmSFami


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
      FacTabla, 
      almtabla
    FIELDS(almtabla.Nombre), 
      Almtfami
    FIELDS(Almtfami.desfam), 
      AlmSFami
    FIELDS(AlmSFami.dessub) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacTabla.Campo-C[1] COLUMN-LABEL "Cat. Contable" FORMAT "x(8)":U
      almtabla.Nombre FORMAT "x(40)":U WIDTH 48.72
      FacTabla.Campo-C[2] COLUMN-LABEL "Línea" FORMAT "x(8)":U
      Almtfami.desfam FORMAT "X(30)":U WIDTH 30.57
      FacTabla.Campo-C[3] COLUMN-LABEL "Sub-Línea" FORMAT "x(8)":U
      AlmSFami.dessub FORMAT "X(30)":U WIDTH 30.14
  ENABLE
      FacTabla.Campo-C[1]
      FacTabla.Campo-C[2]
      FacTabla.Campo-C[3]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 140 BY 14
         FONT 4.


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
   Temp-Tables and Buffers:
      TABLE: b-AlmSFami T "?" NO-UNDO INTEGRAL AlmSFami
      TABLE: b-almtabla B "?" ? INTEGRAL almtabla
      TABLE: b-Almtfami B "?" ? INTEGRAL Almtfami
   END-TABLES.
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
         HEIGHT             = 14.85
         WIDTH              = 152.29.
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
     _TblList          = "INTEGRAL.FacTabla,INTEGRAL.almtabla WHERE INTEGRAL.FacTabla  ...,INTEGRAL.Almtfami WHERE INTEGRAL.FacTabla ...,INTEGRAL.AlmSFami WHERE INTEGRAL.FacTabla ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST USED, FIRST USED, FIRST USED"
     _Where[1]         = "FacTabla.CodCia = s-codcia
 AND FacTabla.Tabla = s-tabla"
     _JoinCode[2]      = "almtabla.Codigo = FacTabla.Campo-C[1]"
     _Where[2]         = "almtabla.Tabla = ""CC"""
     _JoinCode[3]      = "Almtfami.codfam = FacTabla.Campo-C[2]"
     _Where[3]         = "Almtfami.CodCia = s-codcia"
     _JoinCode[4]      = "AlmSFami.codfam = FacTabla.Campo-C[2]
  AND AlmSFami.subfam = FacTabla.Campo-C[3]"
     _Where[4]         = "AlmSFami.CodCia = s-codcia"
     _FldNameList[1]   > INTEGRAL.FacTabla.Campo-C[1]
"FacTabla.Campo-C[1]" "Cat. Contable" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.almtabla.Nombre
"almtabla.Nombre" ? ? "character" ? ? ? ? ? ? no ? no no "48.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacTabla.Campo-C[2]
"FacTabla.Campo-C[2]" "Línea" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almtfami.desfam
"Almtfami.desfam" ? ? "character" ? ? ? ? ? ? no ? no no "30.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacTabla.Campo-C[3]
"FacTabla.Campo-C[3]" "Sub-Línea" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.AlmSFami.dessub
"AlmSFami.dessub" ? ? "character" ? ? ? ? ? ? no ? no no "30.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME FacTabla.Campo-C[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacTabla.Campo-C[1] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF FacTabla.Campo-C[1] IN BROWSE br_table /* Cat. Contable */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  FIND b-Almtabla WHERE b-Almtabla.tabla = 'CC' AND
      b-Almtabla.codigo = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE b-Almtabla THEN DISPLAY b-almtabla.Nombre @ almtabla.Nombre WITH BROWSE {&browse-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacTabla.Campo-C[1] br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF FacTabla.Campo-C[1] IN BROWSE br_table /* Cat. Contable */
OR F8 OF FacTabla.Campo-c[1]
    DO:
        input-var-1 = 'CC'.
        input-var-2 = ''.
        input-var-3 = ?.
        RUN lkup/c-almtab02.w('Seleccione la Cat. Contable').
        IF output-var-3 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacTabla.Campo-C[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacTabla.Campo-C[2] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF FacTabla.Campo-C[2] IN BROWSE br_table /* Línea */
DO:
  FIND b-Almtfami WHERE  b-Almtfami.CodCia = s-codcia AND
      b-Almtfami.codfam = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE b-Almtfami THEN 
      DISPLAY b-Almtfami.desfam @  Almtfami.desfam WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacTabla.Campo-C[2] br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF FacTabla.Campo-C[2] IN BROWSE br_table /* Línea */
OR F8 OF FacTabla.Campo-C[2]
    DO:
        input-var-1 = ''.
        input-var-2 = ''.
        output-var-1 = ?.
        RUN lkup/c-famili.w ('Seleccione la línea').
        IF output-var-1 <> ? THEN DO:
            SELF:SCREEN-VALUE = output-var-2.
            DISPLAY
                output-var-3 @  Almtfami.desfam
                WITH BROWSE {&browse-name}.
        END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacTabla.Campo-C[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacTabla.Campo-C[3] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF FacTabla.Campo-C[3] IN BROWSE br_table /* Sub-Línea */
DO:
  FIND b-Almsfami WHERE b-AlmSFami.CodCia = s-codcia AND
      b-AlmSFami.codfam = FacTabla.Campo-C[3]:SCREEN-VALUE IN BROWSE {&browse-name} AND 
      b-AlmSFami.subfam = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE b-Almsfami THEN 
      DISPLAY b-AlmSFami.dessub @ AlmSFami.dessub WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacTabla.Campo-C[3] br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF FacTabla.Campo-C[3] IN BROWSE br_table /* Sub-Línea */
OR F8 OF FacTabla.Campo-C[3]
    DO:
        input-var-1 = FacTabla.Campo-C[2]:SCREEN-VALUE IN BROWSE {&browse-name}.
        input-var-2 = ''.
        input-var-3 = ''.
        output-var-1 = ?.
        RUN lkup/c-subfam.w ('Seleccione la sub-línea').
        IF output-var-1 <> ? THEN DO:
            SELF:SCREEN-VALUE = output-var-2.
            DISPLAY
                output-var-3 @  AlmSFami.dessub
                WITH BROWSE {&browse-name}.
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

ON 'RETURN':U OF  FacTabla.Campo-C[1], FacTabla.Campo-C[2], FacTabla.Campo-C[3]
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record B-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DEF VAR x-Codigo AS CHAR NO-UNDO.
  x-Codigo = FacTabla.Campo-C[1]:SCREEN-VALUE IN BROWSE {&browse-name} + ":" +
        FacTabla.Campo-C[2]:SCREEN-VALUE IN BROWSE {&browse-name} + ":" +
        FacTabla.Campo-C[3]:SCREEN-VALUE IN BROWSE {&browse-name}.
  ASSIGN
      FacTabla.CodCia = s-codcia
      FacTabla.Tabla = s-tabla
      FacTabla.Codigo = x-Codigo
      .

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
  {src/adm/template/snd-list.i "FacTabla"}
  {src/adm/template/snd-list.i "almtabla"}
  {src/adm/template/snd-list.i "Almtfami"}
  {src/adm/template/snd-list.i "AlmSFami"}

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

DEF VAR x-Codigo AS CHAR NO-UNDO.

RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = 'YES' THEN DO:
    x-Codigo = FacTabla.Campo-C[1]:SCREEN-VALUE IN BROWSE {&browse-name} + ":" +
        FacTabla.Campo-C[2]:SCREEN-VALUE IN BROWSE {&browse-name} + ":" +
        FacTabla.Campo-C[3]:SCREEN-VALUE IN BROWSE {&browse-name}.

    IF CAN-FIND(FacTabla WHERE FacTabla.CodCia = s-codcia AND
                FacTabla.Tabla = s-tabla AND
                FacTabla.codigo = x-Codigo
                NO-LOCK)
        THEN DO:
        MESSAGE 'Registro duplicado' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO FacTabla.Campo-C[1].
        RETURN 'ADM-ERROR'.
    END.
END.

IF NOT CAN-FIND(Almtabla WHERE Almtabla.tabla = 'CC' AND
                Almtabla.codigo = FacTabla.Campo-C[1]:SCREEN-VALUE IN BROWSE {&browse-name}
                NO-LOCK)
    THEN DO:
    MESSAGE 'Cat. Contable no válida' VIEW-AS ALERT-BOX WARNING.
    APPLY 'ENTRY':U TO FacTabla.Campo-C[1].
    RETURN 'ADM-ERROR'.
END.
IF NOT CAN-FIND(FIRST Almtfami WHERE Almtfami.codcia = s-codcia AND
                Almtfami.codfam = FacTabla.Campo-C[2]:SCREEN-VALUE IN BROWSE {&browse-name}
                NO-LOCK)
    THEN DO:
    MESSAGE 'Línea no válida' VIEW-AS ALERT-BOX WARNING.
    APPLY 'ENTRY':U TO FacTabla.Campo-C[2].
    RETURN 'ADM-ERROR'.
END.

IF NOT CAN-FIND(FIRST Almsfami WHERE Almsfami.codcia = s-codcia AND
                Almsfami.codfam = FacTabla.Campo-C[2]:SCREEN-VALUE IN BROWSE {&browse-name} AND
                Almsfami.subfam = FacTabla.Campo-C[3]:SCREEN-VALUE IN BROWSE {&browse-name}
                NO-LOCK)
    THEN DO:
    MESSAGE 'Sub-Línea no válida' VIEW-AS ALERT-BOX WARNING.
    APPLY 'ENTRY':U TO FacTabla.Campo-C[3].
    RETURN 'ADM-ERROR'.
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

MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX WARNING.
RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

