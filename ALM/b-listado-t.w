&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-AlmDInv NO-UNDO LIKE AlmDInv
       fields DifQty  as decimal.



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

DEFINE SHARED VAR s-codcia  AS INTEGER INIT 1.
DEFINE SHARED VAR s-user-id AS CHARACTER.
DEFINE SHARED VAR s-nomcia  AS CHARACTER.

DEFINE VARIABLE cConfi  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dQtyDif AS DECIMAL     NO-UNDO.
DEFINE VARIABLE iCant   AS INTEGER     NO-UNDO INIT 0.
DEFINE VARIABLE cArti   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dQtyCon AS DECIMAL     NO-UNDO.
DEFINE VARIABLE cFiltro AS CHARACTER   NO-UNDO.

DEFINE VARIABLE s-task-no AS INTEGER  NO-UNDO.

DEFINE BUFFER tmp-tt-AlmDInv FOR tt-AlmDInv.
DEFINE TEMP-TABLE tt-Datos LIKE tmp-tt-AlmDInv.

DEFINE VARIABLE Imp AS INTEGER NO-UNDO.

/*Mensaje de Proceso*/
DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

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
&Scoped-define INTERNAL-TABLES tt-AlmDInv Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table tt-AlmDInv.NroPagina ~
tt-AlmDInv.NroSecuencia tt-AlmDInv.CodUbi tt-AlmDInv.codmat Almmmatg.DesMat ~
Almmmatg.DesMar Almmmatg.UndBas tt-AlmDInv.QtyFisico tt-AlmDInv.QtyConteo ~
tt-AlmDInv.QtyReconteo fDifQty() @ DifQty 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH tt-AlmDInv WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF tt-AlmDInv NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH tt-AlmDInv WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF tt-AlmDInv NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table tt-AlmDInv Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table tt-AlmDInv
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS txt-almvirtual txt-codmat tg-dif ~
btn-consulta btn-Excel btn-print btn-exit-2 br_table txt-page-1 txt-page-2 ~
RECT-67 RECT-68 
&Scoped-Define DISPLAYED-OBJECTS txt-almvirtual txt-codmat tg-dif ~
txt-page-1 txt-page-2 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDifQty B-table-Win 
FUNCTION fDifQty RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-consulta 
     IMAGE-UP FILE "IMG/pvbrowd.bmp":U
     LABEL "Button 10" 
     SIZE 9 BY 1.88.

DEFINE BUTTON btn-Excel 
     IMAGE-UP FILE "IMG/excel.bmp":U
     LABEL "Button 1" 
     SIZE 9 BY 1.88.

DEFINE BUTTON btn-exit-2 
     IMAGE-UP FILE "IMG/exit.ico":U
     LABEL "btn exit 2" 
     SIZE 9 BY 1.88.

DEFINE BUTTON btn-print 
     IMAGE-UP FILE "IMG/print.ico":U
     LABEL "btn consulta 2" 
     SIZE 9 BY 1.88.

DEFINE VARIABLE txt-almvirtual AS CHARACTER FORMAT "X(4)":U 
     LABEL "Almacen Virtual" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE txt-codmat AS CHARACTER FORMAT "X(6)":U 
     LABEL "Artículo" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE txt-page-1 AS INTEGER FORMAT "9999":U INITIAL 1 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE txt-page-2 AS INTEGER FORMAT "9999":U INITIAL 9999 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-67
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 119 BY 2.42.

DEFINE RECTANGLE RECT-68
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 119 BY 15.62.

DEFINE VARIABLE tg-dif AS LOGICAL INITIAL no 
     LABEL "Solo diferencias" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      tt-AlmDInv, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      tt-AlmDInv.NroPagina FORMAT "->,>>>,>>9":U
      tt-AlmDInv.NroSecuencia COLUMN-LABEL "Nro." FORMAT ">>9":U
            WIDTH 3
      tt-AlmDInv.CodUbi FORMAT "x(6)":U
      tt-AlmDInv.codmat COLUMN-LABEL "Código" FORMAT "X(6)":U WIDTH 7
      Almmmatg.DesMat FORMAT "X(40)":U WIDTH 35
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U WIDTH 18
      Almmmatg.UndBas COLUMN-LABEL "Unidad" FORMAT "X(4)":U WIDTH 3.57
      tt-AlmDInv.QtyFisico COLUMN-LABEL "Sistema" FORMAT "->>>,>>>,>>9.99":U
      tt-AlmDInv.QtyConteo FORMAT "->>>,>>>,>>9.99":U
      tt-AlmDInv.QtyReconteo FORMAT "->>>,>>>,>>9.99":U
      fDifQty() @ DifQty COLUMN-LABEL "Diferencia" FORMAT "-ZZZ,ZZZ,ZZ9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 116 BY 14.77
         FONT 4
         TITLE "Inventario de Artículos".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-almvirtual AT ROW 1.96 COL 15.43 COLON-ALIGNED WIDGET-ID 62
     txt-codmat AT ROW 2.62 COL 32.43 COLON-ALIGNED WIDGET-ID 54
     tg-dif AT ROW 2.62 COL 50.43 WIDGET-ID 56
     btn-consulta AT ROW 1.54 COL 80.86 WIDGET-ID 8
     btn-Excel AT ROW 1.54 COL 91 WIDGET-ID 20
     btn-print AT ROW 1.54 COL 101 WIDGET-ID 42
     btn-exit-2 AT ROW 1.54 COL 111 WIDGET-ID 52
     br_table AT ROW 4.04 COL 4
     txt-page-1 AT ROW 1.54 COL 32.43 COLON-ALIGNED WIDGET-ID 58
     txt-page-2 AT ROW 1.54 COL 48.43 COLON-ALIGNED WIDGET-ID 60
     RECT-67 AT ROW 1.27 COL 2 WIDGET-ID 32
     RECT-68 AT ROW 3.69 COL 2 WIDGET-ID 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-AlmDInv T "?" NO-UNDO INTEGRAL AlmDInv
      ADDITIONAL-FIELDS:
          fields DifQty  as decimal
      END-FIELDS.
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
         HEIGHT             = 18.46
         WIDTH              = 120.72.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
/* BROWSE-TAB br_table btn-exit-2 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 4.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.tt-AlmDInv,INTEGRAL.Almmmatg OF Temp-Tables.tt-AlmDInv"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _FldNameList[1]   = Temp-Tables.tt-AlmDInv.NroPagina
     _FldNameList[2]   > Temp-Tables.tt-AlmDInv.NroSecuencia
"tt-AlmDInv.NroSecuencia" "Nro." ">>9" "integer" ? ? ? ? ? ? no ? no no "3" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.tt-AlmDInv.CodUbi
     _FldNameList[4]   > Temp-Tables.tt-AlmDInv.codmat
"tt-AlmDInv.codmat" "Código" ? "character" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(40)" "character" ? ? ? ? ? ? no ? no no "35" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no "18" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.Almmmatg.UndBas
"Almmmatg.UndBas" "Unidad" ? "character" ? ? ? ? ? ? no ? no no "3.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-AlmDInv.QtyFisico
"tt-AlmDInv.QtyFisico" "Sistema" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   = Temp-Tables.tt-AlmDInv.QtyConteo
     _FldNameList[10]   = Temp-Tables.tt-AlmDInv.QtyReconteo
     _FldNameList[11]   > "_<CALC>"
"fDifQty() @ DifQty" "Diferencia" "-ZZZ,ZZZ,ZZ9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-DISPLAY OF br_table IN FRAME F-Main /* Inventario de Artículos */
DO:
    IF tt-almdinv.difqty <> 0 THEN
        ASSIGN tt-almdinv.difqty:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main /* Inventario de Artículos */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* Inventario de Artículos */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* Inventario de Artículos */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-consulta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-consulta B-table-Win
ON CHOOSE OF btn-consulta IN FRAME F-Main /* Button 10 */
DO:
    ASSIGN txt-codmat tg-dif txt-page-1 txt-page-2 txt-almvirtual.   
    IF NOT tg-dif THEN RUN Carga-Temporal.
    ELSE RUN Carga-TemporalDif.
    RUN adm-open-query.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-Excel B-table-Win
ON CHOOSE OF btn-Excel IN FRAME F-Main /* Button 1 */
DO: 
    RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-exit-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-exit-2 B-table-Win
ON CHOOSE OF btn-exit-2 IN FRAME F-Main /* btn exit 2 */
DO:
  RUN adm-exit.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-print B-table-Win
ON CHOOSE OF btn-print IN FRAME F-Main /* btn consulta 2 */
DO:    
    RUN Alm\d-tipimp.w (OUTPUT imp).
    
    RUN Imprimir.   
        
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal B-table-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-AlmdInv:
        DELETE tt-AlmdInv.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Impresion B-table-Win 
PROCEDURE Carga-Impresion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR L-Ubica   AS LOGICAL INIT YES.   

    REPEAT WHILE L-Ubica:
           s-task-no = RANDOM(900000,999999).
           FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
           IF NOT AVAILABLE w-report THEN L-Ubica = NO.
    END.

    FOR EACH tt-AlmDInv NO-LOCK
        BREAK BY tt-AlmDInv.NroPagina 
            BY tt-AlmDInv.NroSecuencia:
        CREATE w-report.
        ASSIGN
            w-report.Task-No    = s-task-no
            w-report.Llave-I    = tt-AlmDInv.CodCia
            w-report.Campo-I[1] = tt-AlmDInv.NroPagina
            w-report.Campo-I[2] = tt-AlmDInv.NroSecuencia
            w-report.Campo-C[1] = tt-AlmDInv.CodAlm
            w-report.Campo-C[2] = tt-AlmDInv.CodUbi
            w-report.Campo-C[3] = tt-AlmDInv.CodMat            
            w-report.Campo-C[5] = "CONSOLIDADO CONTI-CISSAC"
            w-report.Campo-F[1] = tt-AlmDInv.QtyFisico
            w-report.Campo-F[2] = tt-AlmDInv.QtyConteo
            w-report.Campo-F[3] = tt-AlmDInv.QtyReconteo.
        /*Diferencia*/
        ASSIGN w-report.Campo-F[4] = (tt-AlmDInv.Libre_d01 - tt-AlmDInv.QtyFisico).
        IF tt-AlmDInv.CodUserRec = '' THEN w-report.Campo-C[4] = tt-AlmDInv.CodUserCon.
        ELSE w-report.Campo-C[4] = tt-AlmDInv.CodUserRec.

        DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
    END.
    HIDE FRAME f-proceso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lReconteo AS LOGICAL NO-UNDO.
    DEFINE VARIABLE cAlmc     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cNomCia   AS CHARACTER   NO-UNDO.

    RUN Borra-Temporal.  

    cNomCia = "CONTISTAND".
    cAlmc   = txt-almvirtual.   /*"11x".*/

    FOR EACH AlmCInv WHERE AlmCInv.CodCia = s-codcia
        AND AlmCInv.NomCia = cNomCia 
        AND AlmCInv.NroPagina >= txt-page-1
        AND AlmCInv.NroPagina <= txt-page-2
        AND AlmCInv.CodAlm = cAlmc NO-LOCK:
        FOR EACH AlmDInv OF AlmCInv
            WHERE AlmDInv.CodMat BEGINS txt-CodMat NO-LOCK:
            CREATE tt-AlmDInv.
            BUFFER-COPY AlmDInv TO tt-AlmDInv.
            /*Calcula Diferencias*/
            /*tt-AlmDInv.DifQty = (AlmDInv.Libre_d01 - AlmDInv.QtyFisico).*/
            tt-AlmDInv.DifQty = (AlmDInv.QtyConteo - AlmDInv.QtyFisico).
            IF AlmCInv.SwReconteo THEN ASSIGN tt-AlmDInv.CodUserCon =  AlmDInv.CodUserRec.
            DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
        END.
    END.           
    HIDE FRAME f-proceso.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-TemporalDif B-table-Win 
PROCEDURE Carga-TemporalDif :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lReconteo AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lDif      AS LOGICAL NO-UNDO.
    DEFINE VARIABLE cNomCia   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cAlmc     AS CHARACTER NO-UNDO.

    RUN Borra-Temporal.  

    cNomCia = "CONTISTAND".
    cAlmc   = txt-almvirtual.   /*"11x".*/

    FOR EACH AlmCInv WHERE AlmCInv.CodCia = s-codcia
        AND AlmCInv.CodAlm = cAlmc
        AND AlmCInv.NroPagina >= txt-page-1
        AND AlmCInv.NroPagina <= txt-page-2
        AND AlmCInv.NomCia = cNomCia NO-LOCK:
        FOR EACH AlmDInv OF AlmCInv 
            WHERE AlmDInv.CodMat BEGINS txt-CodMat NO-LOCK:
            /*IF (AlmDInv.libre_d01 - AlmDInv.QtyFisico) = 0 THEN NEXT.*/
            IF (AlmDInv.QtyConteo - AlmDInv.QtyFisico) = 0 THEN NEXT.
            CREATE tt-AlmDInv.
            BUFFER-COPY AlmDInv TO tt-AlmDInv.
            ASSIGN /*tt-AlmDInv.DifQty = (AlmDInv.Libre_d01 - AlmDInv.QtyFisico).*/
                    tt-AlmDInv.DifQty = (AlmDInv.QtyConteo - AlmDInv.QtyFisico).
            IF AlmCInv.SwReconteo THEN ASSIGN tt-AlmDInv.CodUserCon =  AlmDInv.CodUserRec.

            DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
        END.
    END.
    HIDE FRAME f-proceso.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel B-table-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 5.
DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.

DEFINE VARIABLE x-DesMat AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-DesMar AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-Und    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-ctopro AS DECIMAL     NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/*Header del Excel */
cRange = "E" + '2'.
chWorkSheet:Range(cRange):Value = "LISTADO DE INVENTARIO CONTI-CISSAC".
cRange = "K" + '2'.
chWorkSheet:Range(cRange):Value = TODAY.

/*Formato*/
chWorkSheet:Columns("C"):NumberFormat = "@".
chWorkSheet:Columns("D"):NumberFormat = "@".

/* set the column names for the Worksheet */
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Nro.Pag".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Nro.Sec".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Ubicación".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Código".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripción".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Marca".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Unidad".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "Costo Kardex".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "Cantidad Sistema".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "Cantidad Conteo".
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "Cantidad Reconteo".
cRange = "L" + cColumn.
chWorkSheet:Range(cRange):Value = "Diferencia".
cRange = "M" + cColumn.
chWorkSheet:Range(cRange):Value = "Responsable".


FOR EACH tt-AlmDInv NO-LOCK
    BREAK BY tt-AlmDInv.NroPagina 
        BY tt-AlmDInv.NroSecuencia:
    FIND FIRST Almmmatg WHERE Almmmatg.CodCia = s-CodCia
        AND Almmmatg.CodMat = tt-AlmDInv.codmat NO-LOCK NO-ERROR.
    IF AVAIL Almmmatg THEN 
        ASSIGN 
            x-DesMat = Almmmatg.DesMat
            x-DesMar = Almmmatg.DesMar
            x-Und    = Almmmatg.UndBas.

    /*Costo Promedio Kardex*/
    x-ctopro = 0.
    FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia
        AND AlmStkGe.codmat = Almmmatg.codmat
        AND AlmStkGe.fecha <= tt-AlmDInv.Libre_f01
        NO-LOCK NO-ERROR.
    IF AVAILABLE AlmStkGe THEN x-ctopro = AlmStkge.CtoUni. 

    t-Column = t-Column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-AlmDInv.NroPagina.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-AlmDInv.NroSecuencia.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-AlmDInv.CodUbi.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-AlmDInv.codmat.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = x-Desmat.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = x-DesMar.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = x-Und.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = x-ctopro.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-AlmDInv.QtyFisico.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-AlmDInv.QtyConteo.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-AlmDInv.QtyReconteo.
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-AlmDInv.libre_d01 - tt-AlmDInv.qtyfisico.  /*DifQty.*/
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-AlmDInv.CodUserCon.
    DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
END.

HIDE FRAME F-Proceso.

/* launch Excel so it is visible to the user */
 chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir B-table-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */
   
  RUN Carga-Impresion.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
  RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'alm/rbalm.prl'.
  IF imp = 1 THEN RB-REPORT-NAME = 'Listado Final Inventario'.
  ELSE RB-REPORT-NAME = 'Listado Final Inventario Draft'.
  RB-INCLUDE-RECORDS = 'O'.
  RB-FILTER = "w-report.task-no = " + STRING(S-TASK-NO).

  RB-OTHER-PARAMETERS = "s-nomcia=" + s-nomcia.               

  RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                     RB-REPORT-NAME,
                     RB-INCLUDE-RECORDS,
                     RB-FILTER,
                     RB-OTHER-PARAMETERS).

    
  /*Borrando Temporal*/
  FOR EACH w-report WHERE task-no = s-task-no:
      DELETE w-report.
  END.
  s-task-no = 0.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

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
  {src/adm/template/snd-list.i "tt-AlmDInv"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDifQty B-table-Win 
FUNCTION fDifQty RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

/* Ic 12 Nov 2012*/
  RETURN (tt-AlmDInv.libre_d01 - tt-AlmDInv.qtyfisico).

  /*RETURN tt-AlmDInv.DifQty.   /* Function return value. */*/

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

