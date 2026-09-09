&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE SHARED TEMP-TABLE T-DMatriz NO-UNDO LIKE VtaDMatriz.



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
DEF SHARED VAR s-CodAlm AS CHAR.

DEF VAR pCodAlm AS CHAR NO-UNDO.

DEFINE BUFFER B-DMatriz FOR T-DMatriz.

pCodAlm = ENTRY(1, s-CodAlm).   /* Valor por defecto */

DEF VAR c-FgColor AS INT EXTENT 5.
DEF VAR c-BgColor AS INT EXTENT 5.
ASSIGN
    c-FgColor[1] = 9
    c-FgColor[2] = 0
    c-FgColor[3] = 15
    c-FgColor[4] = 15
    c-FgColor[5] = 15.
ASSIGN
    c-BgColor[1] = 10
    c-BgColor[2] = 14
    c-BgColor[3] = 1
    c-BgColor[4] = 5
    c-BgColor[5] = 13.

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
&Scoped-define EXTERNAL-TABLES VtaCMatriz
&Scoped-define FIRST-EXTERNAL-TABLE VtaCMatriz


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR VtaCMatriz.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-DMatriz

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-DMatriz.LabelFila ~
T-DMatriz.Libre-char[1] T-DMatriz.Libre-logi[1] T-DMatriz.StkAct[1] ~
T-DMatriz.StkAct[2] T-DMatriz.StkAct[3] T-DMatriz.StkAct[4] ~
T-DMatriz.StkAct[5] T-DMatriz.StkAct[6] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH T-DMatriz OF VtaCMatriz WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-DMatriz OF VtaCMatriz WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-DMatriz
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-DMatriz


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table COMBO-BOX-Almacenes 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Almacenes 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCantidad B-table-Win 
FUNCTION fCantidad RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-BOX-Almacenes AS CHARACTER FORMAT "X(256)":U 
     LABEL "ALMACENES" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 72 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-DMatriz SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-DMatriz.LabelFila FORMAT "x(60)":U WIDTH 30.43
      T-DMatriz.Libre-char[1] COLUMN-LABEL "Marca" FORMAT "x(15)":U
      T-DMatriz.Libre-logi[1] COLUMN-LABEL "Tipo" FORMAT "Propios/Terceros":U
      T-DMatriz.StkAct[1] COLUMN-LABEL "1" FORMAT ">>>,>>9.99":U
            WIDTH 8.43
      T-DMatriz.StkAct[2] COLUMN-LABEL "2" FORMAT ">>>,>>9.99":U
            WIDTH 8.43
      T-DMatriz.StkAct[3] COLUMN-LABEL "3" FORMAT ">>>,>>9.99":U
            WIDTH 8.43
      T-DMatriz.StkAct[4] COLUMN-LABEL "4" FORMAT ">>>,>>9.99":U
            WIDTH 8.43
      T-DMatriz.StkAct[5] COLUMN-LABEL "5" FORMAT ">>>,>>9.99":U
            WIDTH 8.43
      T-DMatriz.StkAct[6] COLUMN-LABEL "6" FORMAT ">>>,>>9.99":U
            WIDTH 8.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 107 BY 13.27
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     COMBO-BOX-Almacenes AT ROW 14.65 COL 30 COLON-ALIGNED WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.VtaCMatriz
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "SHARED" ? INTEGRAL FacDPedi
      TABLE: T-DMatriz T "SHARED" NO-UNDO INTEGRAL VtaDMatriz
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
         HEIGHT             = 16.31
         WIDTH              = 123.14.
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
     _TblList          = "Temp-Tables.T-DMatriz OF INTEGRAL.VtaCMatriz"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.T-DMatriz.LabelFila
"T-DMatriz.LabelFila" ? ? "character" ? ? ? ? ? ? no ? no no "30.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-DMatriz.Libre-char[1]
"T-DMatriz.Libre-char[1]" "Marca" "x(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-DMatriz.Libre-logi[1]
"T-DMatriz.Libre-logi[1]" "Tipo" "Propios/Terceros" "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-DMatriz.StkAct[1]
"T-DMatriz.StkAct[1]" "1" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-DMatriz.StkAct[2]
"T-DMatriz.StkAct[2]" "2" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-DMatriz.StkAct[3]
"T-DMatriz.StkAct[3]" "3" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-DMatriz.StkAct[4]
"T-DMatriz.StkAct[4]" "4" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-DMatriz.StkAct[5]
"T-DMatriz.StkAct[5]" "5" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-DMatriz.StkAct[6]
"T-DMatriz.StkAct[6]" "6" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-DISPLAY OF br_table IN FRAME F-Main
DO:
    IF T-DMatriz.CodMat[1] = "" THEN T-DMatriz.StkAct[1]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[2] = "" THEN T-DMatriz.StkAct[2]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[3] = "" THEN T-DMatriz.StkAct[3]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[4] = "" THEN T-DMatriz.StkAct[4]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[5] = "" THEN T-DMatriz.StkAct[5]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[6] = "" THEN T-DMatriz.StkAct[6]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[1] = "" THEN T-DMatriz.StkAct[1]:FGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[2] = "" THEN T-DMatriz.StkAct[2]:FGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[3] = "" THEN T-DMatriz.StkAct[3]:FGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[4] = "" THEN T-DMatriz.StkAct[4]:FGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[5] = "" THEN T-DMatriz.StkAct[5]:FGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[6] = "" THEN T-DMatriz.StkAct[6]:FGCOLOR IN BROWSE {&browse-name} = 8.

    /*RUN Color-Celdas.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&Scoped-define SELF-NAME COMBO-BOX-Almacenes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Almacenes B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Almacenes IN FRAME F-Main /* ALMACENES */
DO:
  ASSIGN {&self-name}.
  pCodAlm = ENTRY(1, SELF:SCREEN-VALUE, ' - ').
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "VtaCMatriz"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "VtaCMatriz"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-Stocks B-table-Win 
PROCEDURE Calcula-Stocks :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR pStkAct AS DEC NO-UNDO.

FOR EACH T-DMatriz OF INTEGRAL.VtaCMatriz:
    RUN Carga-Stock-Detalle (T-DMatriz.CodMat[1], pCodAlm, OUTPUT pStkAct).
    ASSIGN T-DMatriz.StkAct[1] = pStkAct.
    RUN Carga-Stock-Detalle (T-DMatriz.CodMat[2], pCodAlm, OUTPUT pStkAct).
    ASSIGN T-DMatriz.StkAct[2] = pStkAct.
    RUN Carga-Stock-Detalle (T-DMatriz.CodMat[3], pCodAlm, OUTPUT pStkAct).
    ASSIGN T-DMatriz.StkAct[3] = pStkAct.
    RUN Carga-Stock-Detalle (T-DMatriz.CodMat[4], pCodAlm, OUTPUT pStkAct).
    ASSIGN T-DMatriz.StkAct[4] = pStkAct.
    RUN Carga-Stock-Detalle (T-DMatriz.CodMat[5], pCodAlm, OUTPUT pStkAct).
    ASSIGN T-DMatriz.StkAct[5] = pStkAct.
    RUN Carga-Stock-Detalle (T-DMatriz.CodMat[6], pCodAlm, OUTPUT pStkAct).
    ASSIGN T-DMatriz.StkAct[6] = pStkAct.
    RUN Carga-Stock-Detalle (T-DMatriz.CodMat[7], pCodAlm, OUTPUT pStkAct).
    ASSIGN T-DMatriz.StkAct[7] = pStkAct.
    RUN Carga-Stock-Detalle (T-DMatriz.CodMat[8], pCodAlm, OUTPUT pStkAct).
    ASSIGN T-DMatriz.StkAct[8] = pStkAct.
    RUN Carga-Stock-Detalle (T-DMatriz.CodMat[9], pCodAlm, OUTPUT pStkAct).
    ASSIGN T-DMatriz.StkAct[9] = pStkAct.
    RUN Carga-Stock-Detalle (T-DMatriz.CodMat[10], pCodAlm, OUTPUT pStkAct).
    ASSIGN T-DMatriz.StkAct[10] = pStkAct.
    RUN Carga-Stock-Detalle (T-DMatriz.CodMat[11], pCodAlm, OUTPUT pStkAct).
    ASSIGN T-DMatriz.StkAct[11] = pStkAct.
    RUN Carga-Stock-Detalle (T-DMatriz.CodMat[12], pCodAlm, OUTPUT pStkAct).
    ASSIGN T-DMatriz.StkAct[12] = pStkAct.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Almacenes B-table-Win 
PROCEDURE Carga-Almacenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEF VAR k AS INT NO-UNDO.

/* CAMBIAMOS AL ALMACEN POR DEFECTO */
pCodAlm = ENTRY(1, s-CodAlm).
COMBO-BOX-Almacenes:LIST-ITEMS IN FRAME {&FRAME-NAME} = "".

DO k = 1 TO NUM-ENTRIES(s-CodAlm) WITH FRAME {&FRAME-NAME}:
    FIND Almacen WHERE Almacen.codcia = s-codcia
        AND Almacen.codalm = ENTRY(k, s-codalm)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN NEXT.
    COMBO-BOX-Almacenes:ADD-LAST(Almacen.codalm + ' - ' + Almacen.Descripcion).
    IF Almacen.codalm = pCodAlm THEN COMBO-BOX-Almacenes = Almacen.codalm + ' - ' + Almacen.Descripcion.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Stock-Detalle B-table-Win 
PROCEDURE Carga-Stock-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pAlmDes AS CHAR.
DEF OUTPUT PARAMETER pStkAct AS DEC.

DEF VAR pStkComprometido AS DEC NO-UNDO.

IF pCodMat = '' THEN RETURN.

FIND Almmmate WHERE Almmmate.codcia = s-codcia
    AND Almmmate.codmat = pCodMat
    AND Almmmate.codalm = pAlmDes
    NO-LOCK NO-ERROR.
IF AVAILABLE Almmmate THEN pStkAct = Almmmate.StkAct.
RUN vta2/Stock-Comprometido (pCodMat, 
                             pAlmDes, 
                             OUTPUT pStkComprometido).
pStkAct = pStkAct - pStkComprometido.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Color-Celdas B-table-Win 
PROCEDURE Color-Celdas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF T-DMatriz.AlmDes[1] <> '' THEN 
        ASSIGN
        T-DMatriz.StkAct[1]:FGCOLOR IN BROWSE {&browse-name} = c-FgColor[LOOKUP(T-DMatriz.AlmDes[1], s-CodAlm)]
        T-DMatriz.StkAct[1]:BGCOLOR IN BROWSE {&browse-name} = c-BgColor[LOOKUP(T-DMatriz.AlmDes[1], s-CodAlm)].
    IF T-DMatriz.AlmDes[2] <> '' THEN 
        ASSIGN
        T-DMatriz.StkAct[2]:FGCOLOR IN BROWSE {&browse-name} = c-FgColor[LOOKUP(T-DMatriz.AlmDes[2], s-CodAlm)]
        T-DMatriz.StkAct[2]:BGCOLOR IN BROWSE {&browse-name} = c-BgColor[LOOKUP(T-DMatriz.AlmDes[2], s-CodAlm)].
    IF T-DMatriz.AlmDes[3] <> '' THEN 
        ASSIGN
        T-DMatriz.StkAct[3]:FGCOLOR IN BROWSE {&browse-name} = c-FgColor[LOOKUP(T-DMatriz.AlmDes[3], s-CodAlm)]
        T-DMatriz.StkAct[3]:BGCOLOR IN BROWSE {&browse-name} = c-BgColor[LOOKUP(T-DMatriz.AlmDes[3], s-CodAlm)].
    IF T-DMatriz.AlmDes[4] <> '' THEN 
        ASSIGN
        T-DMatriz.StkAct[4]:FGCOLOR IN BROWSE {&browse-name} = c-FgColor[LOOKUP(T-DMatriz.AlmDes[4], s-CodAlm)]
        T-DMatriz.StkAct[4]:BGCOLOR IN BROWSE {&browse-name} = c-BgColor[LOOKUP(T-DMatriz.AlmDes[4], s-CodAlm)].
    IF T-DMatriz.AlmDes[5] <> '' THEN 
        ASSIGN
        T-DMatriz.StkAct[5]:FGCOLOR IN BROWSE {&browse-name} = c-FgColor[LOOKUP(T-DMatriz.AlmDes[5], s-CodAlm)]
        T-DMatriz.StkAct[5]:BGCOLOR IN BROWSE {&browse-name} = c-BgColor[LOOKUP(T-DMatriz.AlmDes[5], s-CodAlm)].
    IF T-DMatriz.AlmDes[6] <> '' THEN 
        ASSIGN
        T-DMatriz.StkAct[6]:FGCOLOR IN BROWSE {&browse-name} = c-FgColor[LOOKUP(T-DMatriz.AlmDes[6], s-CodAlm)]
        T-DMatriz.StkAct[6]:BGCOLOR IN BROWSE {&browse-name} = c-BgColor[LOOKUP(T-DMatriz.AlmDes[6], s-CodAlm)].

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Item B-table-Win 
PROCEDURE Crea-Item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER pCodMat AS CHAR.
    DEF INPUT PARAMETER pCantidad AS DEC.
    DEF INPUT PARAMETER pUndVta AS CHAR.

    IF pCodMat = "" THEN RETURN.
    IF pCantidad <= 0 THEN RETURN.

    DEF VAR x-NroItm AS INT NO-UNDO.

    x-NroItm = 1.
    FOR EACH ITEM BY ITEM.NroItm:
        x-NroItm = ITEM.NroItm + 1.
    END.
    FIND ITEM WHERE ITEM.codmat = pCodMat NO-ERROR.
    IF NOT AVAILABLE ITEM THEN CREATE ITEM. ELSE x-NroItm = ITEM.NroItm.
    ASSIGN
        ITEM.codcia = s-codcia
        ITEM.almdes = ENTRY(1, s-codalm)
        ITEM.CodMat = pCodMat
        ITEM.CanPed = pCantidad
        ITEM.Factor = 1
        ITEM.UndVta = pUndVta
        ITEM.NroItm = x-NroItm.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Registros B-table-Win 
PROCEDURE Graba-Registros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pCodMat AS CHAR NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.
DEF VAR f-PreBas AS DEC NO-UNDO.
DEF VAR f-PreVta AS DEC NO-UNDO.
DEF VAR f-Dsctos AS DEC NO-UNDO.
DEF VAR y-Dsctos AS DEC NO-UNDO.
DEF VAR z-Dsctos AS DEC NO-UNDO.
DEF VAR x-TipDto AS CHAR NO-UNDO.

FOR EACH T-DMatriz:
    RUN Crea-Item (T-DMatriz.CodMat[1], T-DMatriz.Cantidad[1], T-DMatriz.UndVta[1]).
    RUN Crea-Item (T-DMatriz.CodMat[2], T-DMatriz.Cantidad[2], T-DMatriz.UndVta[2]).
    RUN Crea-Item (T-DMatriz.CodMat[3], T-DMatriz.Cantidad[3], T-DMatriz.UndVta[3]).
    RUN Crea-Item (T-DMatriz.CodMat[4], T-DMatriz.Cantidad[4], T-DMatriz.UndVta[4]).
    RUN Crea-Item (T-DMatriz.CodMat[5], T-DMatriz.Cantidad[5], T-DMatriz.UndVta[5]).
    RUN Crea-Item (T-DMatriz.CodMat[6], T-DMatriz.Cantidad[6], T-DMatriz.UndVta[6]).
    RUN Crea-Item (T-DMatriz.CodMat[7], T-DMatriz.Cantidad[7], T-DMatriz.UndVta[7]).
    RUN Crea-Item (T-DMatriz.CodMat[8], T-DMatriz.Cantidad[8], T-DMatriz.UndVta[8]).
    RUN Crea-Item (T-DMatriz.CodMat[9], T-DMatriz.Cantidad[9], T-DMatriz.UndVta[9]).
    RUN Crea-Item (T-DMatriz.CodMat[10], T-DMatriz.Cantidad[10], T-DMatriz.UndVta[10]).
    RUN Crea-Item (T-DMatriz.CodMat[11], T-DMatriz.Cantidad[11], T-DMatriz.UndVta[11]).
    RUN Crea-Item (T-DMatriz.CodMat[12], T-DMatriz.Cantidad[12], T-DMatriz.UndVta[12]).
END.

END PROCEDURE.

/*
DEF VAR pCodMat AS CHAR NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.
DEF VAR f-PreBas AS DEC NO-UNDO.
DEF VAR f-PreVta AS DEC NO-UNDO.
DEF VAR f-Dsctos AS DEC NO-UNDO.
DEF VAR y-Dsctos AS DEC NO-UNDO.
DEF VAR z-Dsctos AS DEC NO-UNDO.
DEF VAR x-TipDto AS CHAR NO-UNDO.

FOR EACH T-DMatriz:
    IF T-DMatriz.Cantidad[1] <> 0 THEN DO:
        CREATE ITEM.
        ASSIGN
            ITEM.codcia = s-codcia
            ITEM.almdes = ENTRY(1, s-codalm)
            ITEM.CodMat = T-DMatriz.CodMat[1]
            ITEM.CanPed = T-DMatriz.Cantidad[1]
            ITEM.Factor = 1.
        pCodMat = ITEM.codmat.
        RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).
        IF pCodMat = '' THEN UNDO, NEXT.
        FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
            AND Almmmatg.codmat = ITEM.codmat
            NO-LOCK.
        IF Almmmatg.Chr__01 = "" THEN DO:
           MESSAGE "Articulo" ITEM.codmat "no tiene unidad de Oficina" VIEW-AS ALERT-BOX ERROR.
           UNDO, NEXT.
        END.
        ITEM.UndVta = Almmmatg.UndA.
        RUN vta2/PrecioMayorista-Cont (s-CodCia,
                                       s-CodDiv,
                                       s-CodCli,
                                       s-CodMon,
                                       s-TpoCmb,
                                       OUTPUT f-Factor,
                                       ITEM.codmat,
                                       s-FlgSit,
                                       ITEM.undvta,
                                       ITEM.CanPed,
                                       s-NroDec,
                                       ITEM.almdes,   /* Necesario para REMATES */
                                       OUTPUT f-PreBas,
                                       OUTPUT f-PreVta,
                                       OUTPUT f-Dsctos,
                                       OUTPUT y-Dsctos,
                                       OUTPUT x-TipDto
                                       ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, NEXT.
        ASSIGN
            ITEM.StkAct = F-PREVTA
            ITEM.Por_Dsctos[2] = z-Dsctos
            ITEM.Por_Dsctos[3] = y-Dsctos.

        ASSIGN 
            ITEM.Factor = F-FACTOR
            /*ITEM.NroItm = I-NroItm*/
            ITEM.PorDto = f-Dsctos
            ITEM.PreBas = F-PreBas 
            ITEM.AftIgv = Almmmatg.AftIgv
            ITEM.AftIsc = Almmmatg.AftIsc
            ITEM.Libre_c04 = x-TipDto.
        ASSIGN
            ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.StkAct * 
                          ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                          ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                          ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
        IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
            THEN ITEM.ImpDto = 0.
            ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.StkAct - ITEM.ImpLin.
        ASSIGN
            ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
            ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
        IF ITEM.AftIsc 
        THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
        ELSE ITEM.ImpIsc = 0.
        IF ITEM.AftIgv 
        THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
        ELSE ITEM.ImpIgv = 0.
    END.
END.
*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Carga-Almacenes.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN
      T-DMatriz.StkAct[1]:LABEL IN BROWSE {&browse-name} = VtaCMatriz.LabelColumna[1]
      T-DMatriz.StkAct[2]:LABEL IN BROWSE {&browse-name} = VtaCMatriz.LabelColumna[2]
      T-DMatriz.StkAct[3]:LABEL IN BROWSE {&browse-name} = VtaCMatriz.LabelColumna[3]
      T-DMatriz.StkAct[4]:LABEL IN BROWSE {&browse-name} = VtaCMatriz.LabelColumna[4]
      T-DMatriz.StkAct[5]:LABEL IN BROWSE {&browse-name} = VtaCMatriz.LabelColumna[5]
      T-DMatriz.StkAct[6]:LABEL IN BROWSE {&browse-name} = VtaCMatriz.LabelColumna[6].

  /*RUN Carga-Almacenes.*/
  RUN Calcula-Stocks.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

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
  {src/adm/template/snd-list.i "VtaCMatriz"}
  {src/adm/template/snd-list.i "T-DMatriz"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCantidad B-table-Win 
FUNCTION fCantidad RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

RETURN T-DMatriz.Cantidad[1] + T-DMatriz.Cantidad[2] + T-DMatriz.Cantidad[3] + 
    T-DMatriz.Cantidad[4] + T-DMatriz.Cantidad[5] + T-DMatriz.Cantidad[6] + 
    T-DMatriz.Cantidad[7] + T-DMatriz.Cantidad[8] + T-DMatriz.Cantidad[9] + 
    T-DMatriz.Cantidad[10] + T-DMatriz.Cantidad[11] + T-DMatriz.Cantidad[12].

  RETURN 0.00.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

