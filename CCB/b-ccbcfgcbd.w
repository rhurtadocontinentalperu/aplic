&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CfgCbd FOR CcbCfgCbd.



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
DEF SHARED VAR cb-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-tabla AS CHAR.

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
&Scoped-define INTERNAL-TABLES CcbCfgCbd FacDocum

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbCfgCbd.CodDoc CcbCfgCbd.CodCbd ~
FacDocum.NomDoc CcbCfgCbd.CtaDbeMn[1] CcbCfgCbd.CtaDbeMe[1] ~
CcbCfgCbd.CtaHbeMn[1] CcbCfgCbd.CtaHbeMe[1] CcbCfgCbd.CtaDbeMn[2] ~
CcbCfgCbd.CtaDbeMe[2] CcbCfgCbd.CtaHbeMn[2] CcbCfgCbd.CtaHbeMe[2] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table CcbCfgCbd.CodDoc ~
CcbCfgCbd.CodCbd CcbCfgCbd.CtaDbeMn[1] CcbCfgCbd.CtaDbeMe[1] ~
CcbCfgCbd.CtaHbeMn[1] CcbCfgCbd.CtaHbeMe[1] CcbCfgCbd.CtaDbeMn[2] ~
CcbCfgCbd.CtaDbeMe[2] CcbCfgCbd.CtaHbeMn[2] CcbCfgCbd.CtaHbeMe[2] 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table CcbCfgCbd
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table CcbCfgCbd
&Scoped-define QUERY-STRING-br_table FOR EACH CcbCfgCbd WHERE ~{&KEY-PHRASE} ~
      AND CcbCfgCbd.CodCia = s-codcia ~
 AND CcbCfgCbd.Tabla = s-tabla NO-LOCK, ~
      EACH FacDocum OF CcbCfgCbd OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CcbCfgCbd WHERE ~{&KEY-PHRASE} ~
      AND CcbCfgCbd.CodCia = s-codcia ~
 AND CcbCfgCbd.Tabla = s-tabla NO-LOCK, ~
      EACH FacDocum OF CcbCfgCbd OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table CcbCfgCbd FacDocum
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbCfgCbd
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacDocum


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
      CcbCfgCbd, 
      FacDocum SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CcbCfgCbd.CodDoc COLUMN-LABEL "Documento" FORMAT "x(3)":U
            VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "FAC","BOL","N/C","N/D","CHQ","LET","DCO" 
                      DROP-DOWN-LIST 
      CcbCfgCbd.CodCbd COLUMN-LABEL "Equivalencia!Contable" FORMAT "x(8)":U
      FacDocum.NomDoc COLUMN-LABEL "Detalle" FORMAT "X(30)":U
      CcbCfgCbd.CtaDbeMn[1] COLUMN-LABEL "Debe S/." FORMAT "x(8)":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 7
      CcbCfgCbd.CtaDbeMe[1] COLUMN-LABEL "Debe US$" FORMAT "x(8)":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 7
      CcbCfgCbd.CtaHbeMn[1] COLUMN-LABEL "Haber S/." FORMAT "x(8)":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 7
      CcbCfgCbd.CtaHbeMe[1] COLUMN-LABEL "Haber US$" FORMAT "x(8)":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 7
      CcbCfgCbd.CtaDbeMn[2] COLUMN-LABEL "Debe S/." FORMAT "x(8)":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
      CcbCfgCbd.CtaDbeMe[2] COLUMN-LABEL "Debe US$" FORMAT "x(8)":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
      CcbCfgCbd.CtaHbeMn[2] COLUMN-LABEL "Haber S/." FORMAT "x(8)":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
      CcbCfgCbd.CtaHbeMe[2] COLUMN-LABEL "Haber US$" FORMAT "x(8)":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
  ENABLE
      CcbCfgCbd.CodDoc
      CcbCfgCbd.CodCbd
      CcbCfgCbd.CtaDbeMn[1]
      CcbCfgCbd.CtaDbeMe[1]
      CcbCfgCbd.CtaHbeMn[1]
      CcbCfgCbd.CtaHbeMe[1]
      CcbCfgCbd.CtaDbeMn[2]
      CcbCfgCbd.CtaDbeMe[2]
      CcbCfgCbd.CtaHbeMn[2]
      CcbCfgCbd.CtaHbeMe[2]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 106 BY 7.27
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
      TABLE: B-CfgCbd B "?" ? INTEGRAL CcbCfgCbd
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
         HEIGHT             = 8.19
         WIDTH              = 116.14.
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
     _TblList          = "INTEGRAL.CcbCfgCbd,INTEGRAL.FacDocum OF INTEGRAL.CcbCfgCbd"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", OUTER"
     _Where[1]         = "INTEGRAL.CcbCfgCbd.CodCia = s-codcia
 AND INTEGRAL.CcbCfgCbd.Tabla = s-tabla"
     _FldNameList[1]   > INTEGRAL.CcbCfgCbd.CodDoc
"CcbCfgCbd.CodDoc" "Documento" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "DROP-DOWN-LIST" "," "FAC,BOL,N/C,N/D,CHQ,LET,DCO" ? 5 no 0 no no
     _FldNameList[2]   > INTEGRAL.CcbCfgCbd.CodCbd
"CcbCfgCbd.CodCbd" "Equivalencia!Contable" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacDocum.NomDoc
"FacDocum.NomDoc" "Detalle" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.CcbCfgCbd.CtaDbeMn[1]
"CcbCfgCbd.CtaDbeMn[1]" "Debe S/." ? "character" 7 15 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CcbCfgCbd.CtaDbeMe[1]
"CcbCfgCbd.CtaDbeMe[1]" "Debe US$" ? "character" 7 15 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.CcbCfgCbd.CtaHbeMn[1]
"CcbCfgCbd.CtaHbeMn[1]" "Haber S/." ? "character" 7 15 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.CcbCfgCbd.CtaHbeMe[1]
"CcbCfgCbd.CtaHbeMe[1]" "Haber US$" ? "character" 7 15 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.CcbCfgCbd.CtaDbeMn[2]
"CcbCfgCbd.CtaDbeMn[2]" "Debe S/." ? "character" 12 15 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.CcbCfgCbd.CtaDbeMe[2]
"CcbCfgCbd.CtaDbeMe[2]" "Debe US$" ? "character" 12 15 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.CcbCfgCbd.CtaHbeMn[2]
"CcbCfgCbd.CtaHbeMn[2]" "Haber S/." ? "character" 12 15 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.CcbCfgCbd.CtaHbeMe[2]
"CcbCfgCbd.CtaHbeMe[2]" "Haber US$" ? "character" 12 15 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME CcbCfgCbd.CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCfgCbd.CodDoc br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF CcbCfgCbd.CodDoc IN BROWSE br_table /* Documento */
DO:
  FIND Facdocum WHERE Facdocum.codcia = s-codcia
      AND Facdocum.coddoc = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Facdocum AND FacDocum.CodCbd <> '' THEN DO:
      DISPLAY FacDocum.CodCbd @ CcbCfgCbd.CodCbd
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
      CcbCfgCbd.CodCia = s-codcia
      CcbCfgCbd.Tabla = s-tabla
      CcbCfgCbd.Fecha = DATETIME(TODAY, MTIME)
      CcbCfgCbd.Usuario = s-user-id.

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
  {src/adm/template/snd-list.i "CcbCfgCbd"}
  {src/adm/template/snd-list.i "FacDocum"}

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

FIND FacDocum WHERE Facdocum.codcia = s-codcia
    AND Facdocum.coddoc = CcbCfgCbd.CodDoc:SCREEN-VALUE IN BROWSE {&browse-name}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum THEN DO:
    MESSAGE 'Documento no registrado en la tabla general de documentos' 
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO CcbCfgCbd.CodDoc.
    RETURN "ADM-ERROR".
END.
FIND Cb-tabl WHERE Cb-tabl.tabla = '02' 
    AND Cb-tabl.codigo = CcbCfgCbd.CodCbd:SCREEN-VALUE IN BROWSE {&browse-name}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Cb-tabl THEN DO:
    MESSAGE 'Documento no registrado en la tabla general contable' 
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO CcbCfgCbd.CodCbd.
    RETURN "ADM-ERROR".
END.
/* CONSISTENCIA DE CUENTAS */
IF CcbCfgCbd.CtaDbeMn[1]:SCREEN-VALUE IN BROWSE {&browse-name} <> '' THEN DO:
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia
        AND cb-ctas.codcta = CcbCfgCbd.CtaDbeMn[1]:SCREEN-VALUE IN BROWSE {&browse-name}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'Cuenta' CcbCfgCbd.CtaDbeMn[1]:SCREEN-VALUE IN BROWSE {&browse-name}
            'no registrada' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry' TO CcbCfgCbd.CtaDbeMn[1] IN BROWSE {&browse-name}.
        RETURN "ADM-ERROR".
    END.
    IF cb-ctas.Codmon <> 3 AND cb-ctas.codmon <> 1 THEN DO:
        MESSAGE 'La cuenta' CcbCfgCbd.CtaDbeMn[1]:SCREEN-VALUE IN BROWSE {&browse-name}
            'está registrada como una cuenta en dólares' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry' TO CcbCfgCbd.CtaDbeMn[1] IN BROWSE {&browse-name}.
        RETURN "ADM-ERROR".
    END.
END.
IF CcbCfgCbd.CtaDbeMn[2]:SCREEN-VALUE IN BROWSE {&browse-name} <> '' THEN DO:
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia
        AND cb-ctas.codcta = CcbCfgCbd.CtaDbeMn[2]:SCREEN-VALUE IN BROWSE {&browse-name}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'Cuenta' CcbCfgCbd.CtaDbeMn[2]:SCREEN-VALUE IN BROWSE {&browse-name}
            'no registrada' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry' TO CcbCfgCbd.CtaDbeMn[2] IN BROWSE {&browse-name}.
        RETURN "ADM-ERROR".
    END.
    IF cb-ctas.Codmon <> 3 AND cb-ctas.codmon <> 1 THEN DO:
        MESSAGE 'La cuenta' CcbCfgCbd.CtaDbeMn[2]:SCREEN-VALUE IN BROWSE {&browse-name}
            'está registrada como una cuenta en dólares' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry' TO CcbCfgCbd.CtaDbeMn[2] IN BROWSE {&browse-name}.
        RETURN "ADM-ERROR".
    END.
END.
IF CcbCfgCbd.CtaDbeMe[1]:SCREEN-VALUE IN BROWSE {&browse-name} <> '' THEN DO:
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia
        AND cb-ctas.codcta = CcbCfgCbd.CtaDbeMe[1]:SCREEN-VALUE IN BROWSE {&browse-name}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'Cuenta' CcbCfgCbd.CtaDbeMe[1]:SCREEN-VALUE IN BROWSE {&browse-name}
            'no registrada' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry' TO CcbCfgCbd.CtaDbeMe[1] IN BROWSE {&browse-name}.
        RETURN "ADM-ERROR".
    END.
    IF cb-ctas.Codmon <> 3 AND cb-ctas.codmon <> 2 THEN DO:
        MESSAGE 'La cuenta' CcbCfgCbd.CtaDbeMe[1]:SCREEN-VALUE IN BROWSE {&browse-name}
            'está registrada como una cuenta en soles' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry' TO CcbCfgCbd.CtaDbeMe[1] IN BROWSE {&browse-name}.
        RETURN "ADM-ERROR".
    END.
END.
IF CcbCfgCbd.CtaDbeMe[2]:SCREEN-VALUE IN BROWSE {&browse-name} <> '' THEN DO:
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia
        AND cb-ctas.codcta = CcbCfgCbd.CtaDbeMe[2]:SCREEN-VALUE IN BROWSE {&browse-name}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'Cuenta' CcbCfgCbd.CtaDbeMe[2]:SCREEN-VALUE IN BROWSE {&browse-name}
            'no registrada' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry' TO CcbCfgCbd.CtaDbeMe[2] IN BROWSE {&browse-name}.
        RETURN "ADM-ERROR".
    END.
    IF cb-ctas.Codmon <> 3 AND cb-ctas.codmon <> 2 THEN DO:
        MESSAGE 'La cuenta' CcbCfgCbd.CtaDbeMe[2]:SCREEN-VALUE IN BROWSE {&browse-name}
            'está registrada como una cuenta en soles' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry' TO CcbCfgCbd.CtaDbeMe[2] IN BROWSE {&browse-name}.
        RETURN "ADM-ERROR".
    END.
END.

IF CcbCfgCbd.CtaHbeMn[1]:SCREEN-VALUE IN BROWSE {&browse-name} <> '' THEN DO:
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia
        AND cb-ctas.codcta = CcbCfgCbd.CtaHbeMn[1]:SCREEN-VALUE IN BROWSE {&browse-name}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'Cuenta' CcbCfgCbd.CtaHbeMn[1]:SCREEN-VALUE IN BROWSE {&browse-name}
            'no registrada' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry' TO CcbCfgCbd.CtaDbeMn[1] IN BROWSE {&browse-name}.
        RETURN "ADM-ERROR".
    END.
    IF cb-ctas.Codmon <> 3 AND cb-ctas.codmon <> 1 THEN DO:
        MESSAGE 'La cuenta' CcbCfgCbd.CtaHbeMn[1]:SCREEN-VALUE IN BROWSE {&browse-name}
            'está registrada como una cuenta en dólares' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry' TO CcbCfgCbd.CtaHbeMn[1] IN BROWSE {&browse-name}.
        RETURN "ADM-ERROR".
    END.
END.
IF CcbCfgCbd.CtaHbeMn[2]:SCREEN-VALUE IN BROWSE {&browse-name} <> '' THEN DO:
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia
        AND cb-ctas.codcta = CcbCfgCbd.CtaHbeMn[2]:SCREEN-VALUE IN BROWSE {&browse-name}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'Cuenta' CcbCfgCbd.CtaHbeMn[2]:SCREEN-VALUE IN BROWSE {&browse-name}
            'no registrada' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry' TO CcbCfgCbd.CtaDbeMn[2] IN BROWSE {&browse-name}.
        RETURN "ADM-ERROR".
    END.
    IF cb-ctas.Codmon <> 3 AND cb-ctas.codmon <> 1 THEN DO:
        MESSAGE 'La cuenta' CcbCfgCbd.CtaHbeMn[2]:SCREEN-VALUE IN BROWSE {&browse-name}
            'está registrada como una cuenta en dólares' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry' TO CcbCfgCbd.CtaHbeMn[2] IN BROWSE {&browse-name}.
        RETURN "ADM-ERROR".
    END.
END.
IF CcbCfgCbd.CtaHbeMe[1]:SCREEN-VALUE IN BROWSE {&browse-name} <> '' THEN DO:
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia
        AND cb-ctas.codcta = CcbCfgCbd.CtaHbeMe[1]:SCREEN-VALUE IN BROWSE {&browse-name}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'Cuenta' CcbCfgCbd.CtaHbeMe[1]:SCREEN-VALUE IN BROWSE {&browse-name}
            'no registrada' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry' TO CcbCfgCbd.CtaHbeMe[1] IN BROWSE {&browse-name}.
        RETURN "ADM-ERROR".
    END.
    IF cb-ctas.Codmon <> 3 AND cb-ctas.codmon <> 2 THEN DO:
        MESSAGE 'La cuenta' CcbCfgCbd.CtaHbeMe[1]:SCREEN-VALUE IN BROWSE {&browse-name}
            'está registrada como una cuenta en soles' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry' TO CcbCfgCbd.CtaHbeMe[1] IN BROWSE {&browse-name}.
        RETURN "ADM-ERROR".
    END.
END.
IF CcbCfgCbd.CtaHbeMe[2]:SCREEN-VALUE IN BROWSE {&browse-name} <> '' THEN DO:
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia
        AND cb-ctas.codcta = CcbCfgCbd.CtaHbeMe[2]:SCREEN-VALUE IN BROWSE {&browse-name}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'Cuenta' CcbCfgCbd.CtaHbeMe[2]:SCREEN-VALUE IN BROWSE {&browse-name}
            'no registrada' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry' TO CcbCfgCbd.CtaHbeMe[2] IN BROWSE {&browse-name}.
        RETURN "ADM-ERROR".
    END.
    IF cb-ctas.Codmon <> 3 AND cb-ctas.codmon <> 2 THEN DO:
        MESSAGE 'La cuenta' CcbCfgCbd.CtaHbeMe[2]:SCREEN-VALUE IN BROWSE {&browse-name}
            'está registrada como una cuenta en soles' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry' TO CcbCfgCbd.CtaHbeMe[2] IN BROWSE {&browse-name}.
        RETURN "ADM-ERROR".
    END.
END.


/* CONSISTENCIA DE DUPLICIDAD */
RUN GET-ATTRIBUTE ('ADM-NEW-RECORD').
IF RETURN-VALUE = 'YES' THEN DO:
    FIND B-CfgCbd WHERE B-CfgCbd.codcia = s-codcia
        AND B-CfgCbd.tabla = s-tabla
        AND B-CfgCbd.coddoc = CcbCfgCbd.CodDoc:SCREEN-VALUE IN BROWSE {&browse-name}
        NO-LOCK NO-ERROR.
END.
ELSE DO:
    FIND B-CfgCbd WHERE B-CfgCbd.codcia = s-codcia
        AND B-CfgCbd.tabla = s-tabla
        AND B-CfgCbd.coddoc = CcbCfgCbd.CodDoc:SCREEN-VALUE IN BROWSE {&browse-name}
        AND ROWID(B-CfgCbd) <> ROWID(CcbCfgCbd)
        NO-LOCK NO-ERROR.
END.
IF AVAILABLE B-CfgCbd THEN DO:
    MESSAGE 'Documento' CcbCfgCbd.CodDoc:SCREEN-VALUE IN BROWSE {&browse-name}
        'repetido' VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO CcbCfgCbd.CodDoc.
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

