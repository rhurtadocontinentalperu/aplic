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

DEFINE SHARED VARIABLE s-codcia AS INTEGER INIT 1.
DEFINE SHARED VARIABLE cl-codcia AS INTEGER INIT 0.

DEFINE TEMP-TABLE ttevt-all02
    FIELDS ttevt-CodCia          AS INTEGER
    FIELDS ttevt-indice          AS INTEGER
    FIELDS ttevt-criterio        AS CHARACTER
    FIELDS ttevt-coddiv          LIKE estavtas.evtall01.CodDiv    
    FIELDS ttevt-codcli          LIKE estavtas.evtall01.codcli
    FIELDS ttevt-codunico        LIKE estavtas.evtall01.codunico
    FIELDS ttevt-CodFam          LIKE Almtfami.CodFam
    FIELDS ttevt-CanalVenta      LIKE estavtas.EvtALL01.CanalVenta
    FIELDS ttevt-NroFch          LIKE estavtas.EvtALL01.NroFch    
    FIELDS ttevt-AmountMesAct    LIKE estavtas.EvtALL01.VtaxMesMn EXTENT 20
    FIELDS ttevt-AmountMesAnt    LIKE estavtas.EvtALL01.VtaxMesMn EXTENT 20
    FIELDS ttevt-AmountMesVta    LIKE estavtas.EvtALL01.VtaxMesMn EXTENT 20
    FIELDS ttevt-AmountMesCto    LIKE estavtas.EvtALL01.VtaxMesMn EXTENT 20
    FIELDS ttevt-AmountMesMrg    LIKE estavtas.EvtALL01.VtaxMesMn EXTENT 20
    FIELDS ttevt-AccumAct        AS DECIMAL EXTENT 20 FORMAT "->>,>>>,>>>,>>9.99"
    FIELDS ttevt-AccumAnt        AS DECIMAL EXTENT 20 FORMAT "->>,>>>,>>>,>>9.99"
    FIELDS ttevt-DifMes          AS DECIMAL EXTENT 2
    INDEX  Indx01 ttevt-CodCia ttevt-indice.

DEF VAR x-nrofchi   AS INT NO-UNDO.
DEF VAR x-NroFchE   AS INT NO-UNDO.
DEF VAR iInt        AS INT NO-UNDO.

DEFINE VARIABLE dAcummVta AS DECIMAL NO-UNDO.
DEFINE VARIABLE dAcummCto AS DECIMAL NO-UNDO.
DEFINE VARIABLE dAcummMrg AS DECIMAL NO-UNDO.

DEFINE VARIABLE dPorcentaje AS DECIMAL NO-UNDO.

DEF VAR s-Task-No AS INT NO-UNDO.

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
&Scoped-define INTERNAL-TABLES w-report

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table w-report.Campo-C[1] w-report.Campo-F[1] w-report.Campo-F[2] w-report.Campo-F[3] w-report.Campo-F[4] w-report.Campo-F[5] w-report.Campo-F[6]   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define SELF-NAME br_table
&Scoped-define QUERY-STRING-br_table FOR EACH w-report WHERE task-no = s-task-no     NO-LOCK USE-INDEX REPO02
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH w-report WHERE task-no = s-task-no     NO-LOCK USE-INDEX REPO02.
&Scoped-define TABLES-IN-QUERY-br_table w-report
&Scoped-define FIRST-TABLE-IN-QUERY-br_table w-report


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cb-anio cb-mes btn-Ok cb-criterio txt-top ~
cb-tipo rs-moneda br_table 
&Scoped-Define DISPLAYED-OBJECTS cb-anio cb-mes cb-criterio txt-top cb-tipo ~
rs-moneda txt-amount1 txt-amount2 txt-acum1 txt-acum2 txt-dif1 txt-dif2 

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
DEFINE BUTTON btn-Ok 
     IMAGE-UP FILE "IMG/pvbrowd.bmp":U
     LABEL "Actualizar" 
     SIZE 10 BY 1.88.

DEFINE VARIABLE cb-anio AS INTEGER FORMAT "9999":U INITIAL 2010 
     LABEL "Año" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "2011" 
     DROP-DOWN-LIST
     SIZE 9.43 BY .81 NO-UNDO.

DEFINE VARIABLE cb-criterio AS CHARACTER FORMAT "X(256)":U INITIAL "División" 
     LABEL "Seleccionar Por" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "División","Cliente","Familia","División - Cliente","División - Familia","Familia - Cliente","Canal Venta" 
     DROP-DOWN-LIST
     SIZE 19.43 BY 1 NO-UNDO.

DEFINE VARIABLE cb-mes AS INTEGER FORMAT "99":U INITIAL 1 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "01" 
     DROP-DOWN-LIST
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo AS CHARACTER FORMAT "X(256)":U INITIAL "Ventas" 
     LABEL "Tipo de Reporte" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Ventas","Costos","Margen" 
     DROP-DOWN-LIST
     SIZE 16.29 BY 1 NO-UNDO.

DEFINE VARIABLE txt-acum1 AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81 NO-UNDO.

DEFINE VARIABLE txt-acum2 AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .81 NO-UNDO.

DEFINE VARIABLE txt-amount1 AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

DEFINE VARIABLE txt-amount2 AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

DEFINE VARIABLE txt-dato AS CHARACTER FORMAT "X(256)":U 
     LABEL "*Seleccione la cantidad de Clientes" 
     VIEW-AS FILL-IN 
     SIZE 1 BY .81
     FGCOLOR 7  NO-UNDO.

DEFINE VARIABLE txt-dif1 AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE txt-dif2 AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE txt-top AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 100 
     LABEL "Top" 
     VIEW-AS FILL-IN 
     SIZE 6.29 BY .81.

DEFINE VARIABLE rs-moneda AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dólares", 2
     SIZE 18.29 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      w-report.Campo-C[1] COLUMN-LABEL "Selección"      FORMAT "X(50)"       
    w-report.Campo-F[1]   COLUMN-LABEL "Año Actual"     FORMAT "->>,>>>,>>>,>>9.99"  
    w-report.Campo-F[2]   COLUMN-LABEL "Año Anterior"   FORMAT "->>,>>>,>>>,>>9.99"
    w-report.Campo-F[3]   COLUMN-LABEL "Acumulado Año Actual"   FORMAT "->>,>>>,>>>,>>9.99"
    w-report.Campo-F[4]   COLUMN-LABEL "Acumulado Año Anterior" FORMAT "->>,>>>,>>>,>>9.99"  
    w-report.Campo-F[5]   COLUMN-LABEL "Dif. Año"        FORMAT "->>>,>>9.99"
    w-report.Campo-F[6]   COLUMN-LABEL "Dif. Acumulado"  FORMAT "->>>>,>>9.99"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 120 BY 13.73
         FONT 4 ROW-HEIGHT-CHARS .54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cb-anio AT ROW 1.27 COL 11.57 COLON-ALIGNED WIDGET-ID 60
     cb-mes AT ROW 1.27 COL 43.43 COLON-ALIGNED WIDGET-ID 64
     btn-Ok AT ROW 1.5 COL 85 WIDGET-ID 58
     cb-criterio AT ROW 2.35 COL 11.57 COLON-ALIGNED WIDGET-ID 62
     txt-top AT ROW 2.35 COL 43.72 COLON-ALIGNED WIDGET-ID 76
     txt-dato AT ROW 2.35 COL 76 COLON-ALIGNED WIDGET-ID 74
     cb-tipo AT ROW 3.42 COL 11.72 COLON-ALIGNED WIDGET-ID 66
     rs-moneda AT ROW 3.42 COL 45.57 NO-LABEL WIDGET-ID 68
     br_table AT ROW 5.04 COL 2
     txt-amount1 AT ROW 19.04 COL 51 RIGHT-ALIGNED NO-LABEL WIDGET-ID 84
     txt-amount2 AT ROW 19.04 COL 65 RIGHT-ALIGNED NO-LABEL WIDGET-ID 86
     txt-acum1 AT ROW 19.04 COL 81 RIGHT-ALIGNED NO-LABEL WIDGET-ID 80
     txt-acum2 AT ROW 19.04 COL 98 RIGHT-ALIGNED NO-LABEL WIDGET-ID 82
     txt-dif1 AT ROW 19.04 COL 100 NO-LABEL WIDGET-ID 88
     txt-dif2 AT ROW 19.04 COL 109 NO-LABEL WIDGET-ID 90
     "Totales:" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 19.19 COL 31.72 WIDGET-ID 78
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 3.54 COL 39 WIDGET-ID 72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


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
         HEIGHT             = 19.35
         WIDTH              = 121.72.
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
/* BROWSE-TAB br_table rs-moneda F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN txt-acum1 IN FRAME F-Main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN txt-acum2 IN FRAME F-Main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN txt-amount1 IN FRAME F-Main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN txt-amount2 IN FRAME F-Main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN txt-dato IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN txt-dif1 IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN txt-dif2 IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH w-report WHERE task-no = s-task-no
    NO-LOCK USE-INDEX REPO02.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
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
    IF AVAILABLE w-report THEN DO:
        IF (w-report.Campo-C[1] BEGINS "Total") THEN 
            ASSIGN 
               w-report.Campo-C[1]:FONT IN BROWSE {&BROWSE-NAME} = 6.

        IF (w-report.Campo-F[5] > 115) THEN 
            ASSIGN w-report.Campo-F[5]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 2.
        ELSE IF (w-report.Campo-F[5] <= 115 AND w-report.Campo-F[5] > 80) THEN
            ASSIGN 
                w-report.Campo-F[5]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14.
        ELSE ASSIGN 
                w-report.Campo-F[5]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.

        IF (w-report.Campo-F[6] > 115) THEN 
            ASSIGN w-report.Campo-F[6]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 2.
        ELSE IF (w-report.Campo-F[6] <= 115 AND w-report.Campo-F[6] > 80) THEN
            ASSIGN 
                w-report.Campo-F[6]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14.
        ELSE ASSIGN 
                w-report.Campo-F[6]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.        
    END.
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


&Scoped-define SELF-NAME btn-Ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-Ok B-table-Win
ON CHOOSE OF btn-Ok IN FRAME F-Main /* Actualizar */
DO:
  ASSIGN
    cb-anio
    cb-mes
    cb-criterio
    cb-tipo
    rs-moneda
    txt-top.

  IF s-task-no <> 0 THEN RUN Borra-Registros.  
  RUN Borra-Temporal.
      
  CASE cb-criterio:
      WHEN "División" THEN RUN Carga-Divisiones.
      WHEN "Cliente"  THEN RUN Carga-Clientes.
      WHEN "Familia"  THEN RUN Carga-Familia.  
      WHEN "División - Familia" THEN RUN Carga-Divisiones-Familia.
      WHEN "División - Cliente" THEN RUN Carga-Divisiones-Cliente.
      WHEN "Familia - Cliente"  THEN RUN Carga-Familia-Cliente. 
      WHEN "Canal Venta"  THEN RUN Carga-Canal-Venta. 
  END CASE.
  /*
  RUN Carga-Detalle.  */
  RUN Carga-Totales.
  RUN dispatch IN THIS-PROCEDURE ('open-query').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-criterio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-criterio B-table-Win
ON VALUE-CHANGED OF cb-criterio IN FRAME F-Main /* Seleccionar Por */
DO:
    ASSIGN cb-criterio.
    IF cb-criterio = "Cliente" OR cb-criterio = "División - Cliente" 
        OR cb-criterio = "Familia - Cliente" THEN DO:
        ENABLE txt-top WITH FRAME {&FRAME-NAME}.
        txt-dato:VISIBLE IN FRAME {&FRAME-NAME} = TRUE.
        DISPLAY txt-top WITH FRAME {&FRAME-NAME}.
    END.        
    ELSE DO: 
        txt-top:VISIBLE  = FALSE.
        txt-dato:VISIBLE = FALSE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo B-table-Win
ON VALUE-CHANGED OF cb-tipo IN FRAME F-Main /* Tipo de Reporte */
DO:
    ASSIGN 
        cb-criterio
        cb-tipo
        rs-moneda.
    RUN Selecciona-Moneda.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-moneda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-moneda B-table-Win
ON VALUE-CHANGED OF rs-moneda IN FRAME F-Main
DO:  
    ASSIGN
        cb-criterio
        rs-moneda
        cb-tipo.
    RUN Selecciona-Moneda.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Registros B-table-Win 
PROCEDURE Borra-Registros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUFFER bwreport FOR w-report.

    FOR EACH bwreport WHERE task-no = s-task-no EXCLUSIVE-LOCK:
        DELETE bwreport.
    END.
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
/* FOR EACH ttevt-all02:   */
/*     DELETE ttevt-all02. */
/* END.                    */
    EMPTY TEMP-TABLE ttevt-all02.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Canal-Venta B-table-Win 
PROCEDURE Canal-Venta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE x-NroFchR AS DECIMAL     NO-UNDO.

    iInt = 0.
    FOR EACH vtamcanal WHERE vtamcanal.codcia = s-codcia NO-LOCK:
        FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CanalVenta = vtamcanal.CanalVenta
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ttevt-all02 THEN DO:
            iInt =  iInt + 1.
            CREATE ttevt-all02.
            ASSIGN
                ttevt-all02.ttevt-CodCia   = vtamcanal.CodCia
                ttevt-all02.ttevt-Indice   = iInt
                ttevt-all02.ttevt-CanalVenta = vtamcanal.CanalVenta
                ttevt-all02.ttevt-Criterio = vtamcanal.CanalVenta + " - " + INTEGRAL.vtamcanal.Descrip.
        END.
    END.
    
    x-NroFchR = ((cb-anio - 1) * 100) + cb-mes.   
    x-NroFchE = (cb-anio  * 100) + cb-mes.
    FOR EACH ttevt-all02 NO-LOCK:
        FOR EACH estavtas.evtcnvta NO-LOCK WHERE 
            estavtas.evtcnvta.CodCia = ttevt-CodCia AND 
            estavtas.evtcnvta.CodDiv = ttevt-CodDiv AND 
            estavtas.evtcnvta.CanalVenta = ttevt-CanalVenta AND 
            ((estavtas.evtcnvta.NroFch >= ((cb-anio - 1) * 100 + 01) AND
             estavtas.evtcnvta.NroFch <= x-NroFchR) OR 
             (estavtas.evtcnvta.NroFch >= (cb-anio * 100 + 01) AND
             estavtas.evtcnvta.NroFch <= x-NroFchE)): 

            IF estavtas.evtcnvta.NroFch = x-NroFchR THEN DO:
                ttevt-AmountMesAnt[1] = ttevt-AmountMesAnt[1] + estavtas.evtcnvta.VtaxMesMn.
                ttevt-AmountMesAnt[2] = ttevt-AmountMesAnt[2] + estavtas.evtcnvta.CtoxMesMn.
                ttevt-AmountMesAnt[3] = ttevt-AmountMesAnt[3] + (estavtas.evtcnvta.VtaxMesMn - estavtas.evtcnvta.CtoxMesMn).

                ttevt-AmountMesAnt[11] = ttevt-AmountMesAnt[11] + estavtas.evtcnvta.VtaxMesMe.
                ttevt-AmountMesAnt[12] = ttevt-AmountMesAnt[12] + estavtas.evtcnvta.CtoxMesMe.
                ttevt-AmountMesAnt[13] = ttevt-AmountMesAnt[13] + (estavtas.evtcnvta.VtaxMesMe - estavtas.evtcnvta.CtoxMesMe).
            END.

            IF estavtas.evtcnvta.NroFch = x-NroFchE THEN DO:                    
                ttevt-AmountMesAct[1] = ttevt-AmountMesAct[1] + estavtas.evtcnvta.VtaxMesMn.
                ttevt-AmountMesAct[2] = ttevt-AmountMesAct[2] + estavtas.evtcnvta.CtoxMesMn.
                ttevt-AmountMesAct[3] = ttevt-AmountMesAct[3] +(estavtas.evtcnvta.VtaxMesMn - estavtas.evtcnvta.CtoxMesMn).

                ttevt-AmountMesAct[11] = ttevt-AmountMesAct[11] + estavtas.evtcnvta.VtaxMesMe.
                ttevt-AmountMesAct[12] = ttevt-AmountMesAct[12] + estavtas.evtcnvta.CtoxMesMe.
                ttevt-AmountMesAct[13] = ttevt-AmountMesAct[13] +(estavtas.evtcnvta.VtaxMesMe - estavtas.evtcnvta.CtoxMesMe).
            END.

            IF (estavtas.evtcnvta.NroFch >= ((cb-anio - 1) * 100 + 01) AND estavtas.evtcnvta.NroFch <= x-NroFchR) THEN DO:
                ttevt-AccumAnt[1] = ttevt-AccumAnt[1] + estavtas.evtcnvta.VtaxMesMn.
                ttevt-AccumAnt[2] = ttevt-AccumAnt[2] + estavtas.evtcnvta.CtoxMesMn.
                ttevt-AccumAnt[3] = ttevt-AccumAnt[3] + (estavtas.evtcnvta.VtaxMesMn - estavtas.evtcnvta.CtoxMesMn).

                ttevt-AccumAnt[11] = ttevt-AccumAnt[11] + estavtas.evtcnvta.VtaxMesMe.
                ttevt-AccumAnt[12] = ttevt-AccumAnt[12] + estavtas.evtcnvta.CtoxMesMe.
                ttevt-AccumAnt[13] = ttevt-AccumAnt[13] + (estavtas.evtcnvta.VtaxMesMe - estavtas.evtcnvta.CtoxMesMe).
            END.                    

            IF (estavtas.evtcnvta.NroFch >= (cb-anio * 100 + 01) AND estavtas.evtcnvta.NroFch <= x-NroFchE) THEN DO:
                ttevt-AccumAct[1] = ttevt-AccumAct[1] + estavtas.evtcnvta.VtaxMesMn.
                ttevt-AccumAct[2] = ttevt-AccumAct[2] + estavtas.evtcnvta.CtoxMesMn.
                ttevt-AccumAct[3] = ttevt-AccumAct[3] + (estavtas.evtcnvta.VtaxMesMn - estavtas.evtcnvta.CtoxMesMn).

                ttevt-AccumAct[11] = ttevt-AccumAct[11] + estavtas.evtcnvta.VtaxMesMe.
                ttevt-AccumAct[12] = ttevt-AccumAct[12] + estavtas.evtcnvta.CtoxMesMe.
                ttevt-AccumAct[13] = ttevt-AccumAct[13] + (estavtas.evtcnvta.VtaxMesMe - estavtas.evtcnvta.CtoxMesMe).
            END.                    
            PAUSE 0.
        END.
        DISPLAY
            'Espere un momento por favor...' SKIP
            'Procesando Información División: ' ttevt-all02.ttevt-CodDiv NO-LABEL
            WITH FRAME F-Mensaje TITLE 'Procesando informacion' CENTERED OVERLAY VIEW-AS DIALOG-BOX.
    END.
    HIDE FRAME f-Mensaje.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Canal-Venta B-table-Win 
PROCEDURE Carga-Canal-Venta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iIndx AS INTEGER NO-UNDO.
    
    RUN Canal-Venta.
    CASE cb-tipo:
        WHEN "Ventas" THEN iIndx = 1. 
        WHEN "Costos" THEN iIndx = 2. 
        WHEN "Margen" THEN iIndx = 3. 
    END CASE.
    RUN Carga-Detalle (iIndx).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Clie B-table-Win 
PROCEDURE Carga-Clie :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE VARIABLE dVtaAct   AS DECIMAL EXTENT 20 NO-UNDO.    
    DEFINE VARIABLE dVtaAnt   AS DECIMAL EXTENT 20 NO-UNDO.    
    DEFINE VARIABLE dAcumAct  AS DECIMAL EXTENT 20 NO-UNDO.    
    DEFINE VARIABLE dAcumAnt  AS DECIMAL EXTENT 20 NO-UNDO.    
    DEFINE VARIABLE cName     LIKE gn-clie.NomCli  NO-UNDO.        
    DEFINE VARIABLE x-NroFchR AS DECIMAL           NO-UNDO.
    
    iInt    = 0.
    Clientes:
    FOR EACH estavtas.evtall03 NO-LOCK USE-INDEX Indice02 WHERE estavtas.evtall03.Codcia = s-codcia 
        BY estavtas.evtall03.VtaxMesMe DESC:        
        FIND FIRST gn-cliex WHERE gn-cliex.CodCia = cl-codcia
            AND gn-cliex.CodUnico = estavtas.evtall03.CodUnico NO-LOCK NO-ERROR.
        IF AVAILABLE gn-cliex THEN NEXT Clientes.        
        FIND FIRST gn-clie WHERE gn-clie.CodCia = cl-CodCia 
            AND gn-clie.CodCli = estavtas.evtall03.CodUnico NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN cName = gn-clie.NomCli. ELSE cName = "".
        FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodCia = estavtas.evtall03.CodCia
            AND ttevt-all02.ttevt-CodUnico = estavtas.evtall03.CodUnico NO-LOCK NO-ERROR.       
        IF NOT AVAILABLE ttevt-all02 THEN DO:
            iInt =  iInt + 1.
            CREATE ttevt-all02.
            ASSIGN
                ttevt-all02.ttevt-CodCia   = estavtas.evtall03.Codcia
                ttevt-all02.ttevt-Indice   = iInt
                ttevt-all02.ttevt-CodUnico = estavtas.evtall03.CodUnico
                ttevt-all02.ttevt-Criterio = estavtas.evtall03.CodUnico + " - " + cName.  
        END.
        IF iInt >= txt-top THEN LEAVE Clientes.
    END.

    x-NroFchI = ((cb-anio - 1) * 100) + 01.
    x-NroFchR = ((cb-anio - 1) * 100) + cb-mes.   
    x-NroFchE = (cb-anio  * 100) + cb-mes.

    FOR EACH ttevt-all02 NO-LOCK:
        dVtaAct = 0.
        dVtaAnt = 0.
        dAcumAct = 0.
        dAcumAnt = 0.

        FOR EACH estavtas.evtclie NO-LOCK WHERE 
            estavtas.evtclie.CodCia = ttevt-all02.ttevt-CodCia AND 
            estavtas.evtclie.CodUnico = ttevt-all02.ttevt-CodUnico AND 
            ((estavtas.evtclie.NroFch  >= x-NroFchI AND
            estavtas.evtclie.NroFch   <= ((cb-anio - 1) * 100 + cb-mes)) OR
            ( estavtas.evtclie.NroFch >= (cb-anio * 100 + 01) AND 
            estavtas.evtclie.NroFch   <= x-NroFchE)):  

            IF estavtas.evtclie.NroFch = x-NroFchR THEN DO:
                dVtaAnt[1] = dVtaAnt[1] + estavtas.evtclie.VtaxMesMn.
                dVtaAnt[2] = dVtaAnt[2] + estavtas.evtclie.CtoxMesMn.
                dVtaAnt[3] = dVtaAnt[3] + (estavtas.evtclie.VtaxMesMn - estavtas.evtclie.CtoxMesMn).

                dVtaAnt[11] = dVtaAnt[11] + estavtas.evtclie.VtaxMesMe.
                dVtaAnt[12] = dVtaAnt[12] + estavtas.evtclie.CtoxMesMe.
                dVtaAnt[13] = dVtaAnt[13] + (estavtas.evtclie.VtaxMesMe - estavtas.evtclie.CtoxMesMe).
            END.

            IF estavtas.evtclie.NroFch = x-NroFchE THEN DO:                    
                dVtaAct[1] = dVtaAct[1] + estavtas.evtclie.VtaxMesMn.
                dVtaAct[2] = dVtaAct[2] + estavtas.evtclie.CtoxMesMn.
                dVtaAct[3] = dVtaAct[3] +(estavtas.evtclie.VtaxMesMn - estavtas.evtclie.CtoxMesMn).

                dVtaAct[11] = dVtaAct[11] + estavtas.evtclie.VtaxMesMe.
                dVtaAct[12] = dVtaAct[12] + estavtas.evtclie.CtoxMesMe.
                dVtaAct[13] = dVtaAct[13] +(estavtas.evtclie.VtaxMesMe - estavtas.evtclie.CtoxMesMe).
            END.

            IF (estavtas.evtclie.NroFch >= ((cb-anio - 1) * 100 + 01) AND estavtas.evtclie.NroFch <= x-NroFchR) THEN DO:
                dAcumAnt[1] = dAcumAnt[1] + estavtas.evtclie.VtaxMesMn.
                dAcumAnt[2] = dAcumAnt[2] + estavtas.evtclie.CtoxMesMn.
                dAcumAnt[3] = dAcumAnt[3] + (estavtas.evtclie.VtaxMesMn - estavtas.evtclie.CtoxMesMn).

                dAcumAnt[11] = dAcumAnt[11] + estavtas.evtclie.VtaxMesMe.
                dAcumAnt[12] = dAcumAnt[12] + estavtas.evtclie.CtoxMesMe.
                dAcumAnt[13] = dAcumAnt[13] + (estavtas.evtclie.VtaxMesMe - estavtas.evtclie.CtoxMesMe).
            END.                    

            IF (estavtas.evtclie.NroFch >= (cb-anio * 100 + 01) AND estavtas.evtclie.NroFch <= x-NroFchE) THEN DO:
                dAcumAct[1] = dAcumAct[1] + estavtas.evtclie.VtaxMesMn.
                dAcumAct[2] = dAcumAct[2] + estavtas.evtclie.CtoxMesMn.
                dAcumAct[3] = dAcumAct[3] + (estavtas.evtclie.VtaxMesMn - estavtas.evtclie.CtoxMesMn).

                dAcumAct[11] = dAcumAct[11] + estavtas.evtclie.VtaxMesMe.
                dAcumAct[12] = dAcumAct[12] + estavtas.evtclie.CtoxMesMe.
                dAcumAct[13] = dAcumAct[13] + (estavtas.evtclie.VtaxMesMe - estavtas.evtclie.CtoxMesMe).
            END.                    
            PAUSE 0.
            ASSIGN
                ttevt-AmountMesAct[1] = dVtaAct[1]
                ttevt-AmountMesAct[2] = dVtaAct[2]
                ttevt-AmountMesAct[3] = dVtaAct[3]
                ttevt-AmountMesAct[11] = dVtaAct[11]
                ttevt-AmountMesAct[12] = dVtaAct[12]
                ttevt-AmountMesAct[13] = dVtaAct[13]

                ttevt-AmountMesAnt[1] = dVtaAnt[1] 
                ttevt-AmountMesAnt[2] = dVtaAnt[2] 
                ttevt-AmountMesAnt[3] = dVtaAnt[3]
                ttevt-AmountMesAnt[11] = dVtaAnt[11] 
                ttevt-AmountMesAnt[12] = dVtaAnt[12] 
                ttevt-AmountMesAnt[13] = dVtaAnt[13]
    
                ttevt-AccumAct[1] = dAcumAct[1]
                ttevt-AccumAct[2] = dAcumAct[2]
                ttevt-AccumAct[3] = dAcumAct[3]
                ttevt-AccumAct[11] = dAcumAct[11]
                ttevt-AccumAct[12] = dAcumAct[12]
                ttevt-AccumAct[13] = dAcumAct[13]
   
                ttevt-AccumAnt[1] = dAcumAnt[1]
                ttevt-AccumAnt[2] = dAcumAnt[2]
                ttevt-AccumAnt[3] = dAcumAnt[3]
                ttevt-AccumAnt[11] = dAcumAnt[11]
                ttevt-AccumAnt[12] = dAcumAnt[12]
                ttevt-AccumAnt[13] = dAcumAnt[13].

            DISPLAY
                    'Espere un momento por favor...' SKIP
                    'Procesando Información Cliente: ' ttevt-all02.ttevt-Indice NO-LABEL
                    WITH FRAME F-Mensaje TITLE 'Procesando informacion' CENTERED OVERLAY VIEW-AS DIALOG-BOX.
        END.
    END.
    HIDE FRAME f-Mensaje.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Clientes B-table-Win 
PROCEDURE Carga-Clientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iIndx AS INTEGER NO-UNDO.
    
    RUN Carga-Clie.
    CASE cb-tipo:
        WHEN "Ventas" THEN iIndx = 1. 
        WHEN "Costos" THEN iIndx = 2. 
        WHEN "Margen" THEN iIndx = 3. 
    END CASE.
    RUN Carga-Detalle (iIndx).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle B-table-Win 
PROCEDURE Carga-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER iIndice AS INTEGER NO-UNDO.

    IF s-task-no <> 0 THEN RUN Borra-Registros.
    REPEAT:
        s-task-no = RANDOM(1,999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK)
        THEN LEAVE.
    END.
    data:
    FOR EACH ttevt-all02 NO-LOCK USE-INDEX Indx01 BREAK BY ttevt-all02.ttevt-Indice:
        IF (ttevt-AccumAct[iIndice] = 0 AND ttevt-AccumAnt[iIndice] = 0) THEN NEXT data.
        FIND w-report WHERE w-report.task-no = s-task-no 
            AND w-report.Llave-I = ttevt-all02.ttevt-indice EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE w-report THEN DO:
            CREATE w-report.
            ASSIGN
                w-report.task-no    = s-task-no
                w-report.Llave-I    = ttevt-Indice
                w-report.Campo-C[1] = ttevt-Criterio
                w-report.Campo-F[1] = ttevt-AmountMesAct[iIndice]
                w-report.Campo-F[2] = ttevt-AmountMesAnt[iIndice]
                w-report.Campo-F[3] = ttevt-AccumAct[iIndice] 
                w-report.Campo-F[4] = ttevt-AccumAnt[iIndice].

            IF ttevt-AmountMesAnt[iIndice] = 0 AND ttevt-AmountMesAct[iIndice] = 0
                THEN dPorcentaje = 0.
            ELSE IF ttevt-AmountMesAnt[iIndice] = 0 AND ttevt-AmountMesAct[iIndice] <> 0 
                THEN dPorcentaje = 100.
            ELSE DO:
                dPorcentaje = (ttevt-AmountMesAct[iIndice] / ttevt-AmountMesAnt[iIndice]) * 100.
            END.
            IF ttevt-AmountMesAct[iIndice] > 0 AND dPorcentaje < 0
                THEN dPorcentaje = dPorcentaje * -1.
            w-report.Campo-F[5] = dPorcentaje.

            IF ttevt-AccumAnt[iIndice] = 0 AND ttevt-AccumAct[iIndice] = 0
                THEN dPorcentaje = 0.
            ELSE IF ttevt-AccumAnt[iIndice] = 0 AND ttevt-AccumAct[iIndice] <> 0 
                THEN dPorcentaje = 100.
            ELSE DO:
                dPorcentaje = (ttevt-AccumAct[iIndice] / ttevt-AccumAnt[iIndice]) * 100.
            END.
            IF ttevt-AccumAct[iIndice] > 0 AND dPorcentaje < 0
                THEN dPorcentaje = dPorcentaje * -1.
            w-report.Campo-F[6] = dPorcentaje.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle2 B-table-Win 
PROCEDURE Carga-Detalle2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER iIndice AS INTEGER NO-UNDO.
    DEFINE VARIABLE dTotal AS DECIMAL EXTENT 4 NO-UNDO.

    IF s-task-no <> 0 THEN RUN Borra-Registros.
    REPEAT:
        s-task-no = RANDOM(1,999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK)
        THEN LEAVE.
    END.
    data:
    FOR EACH ttevt-all02 NO-LOCK USE-INDEX Indx01 BREAK BY ttevt-all02.ttevt-Indice:
        IF (ttevt-AccumAct[iIndice] = 0 AND ttevt-AccumAnt[iIndice] = 0) 
            AND NOT ttevt-Criterio BEGINS "Total" THEN NEXT data.
        FIND w-report WHERE w-report.task-no = s-task-no 
            AND w-report.Llave-I = ttevt-all02.ttevt-indice
            AND NOT ttevt-criterio BEGINS "Total" EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE w-report AND NOT ttevt-Criterio BEGINS "Total" THEN DO:            
            CREATE w-report.
            ASSIGN
                w-report.task-no    = s-task-no
                w-report.Llave-I    = ttevt-Indice
                w-report.Campo-C[1] = ttevt-Criterio
                w-report.Campo-F[1] = ttevt-AmountMesAct[iIndice]
                w-report.Campo-F[2] = ttevt-AmountMesAnt[iIndice]
                w-report.Campo-F[3] = ttevt-AccumAct[iIndice] 
                w-report.Campo-F[4] = ttevt-AccumAnt[iIndice].

            IF ttevt-AmountMesAnt[iIndice] = 0 AND ttevt-AmountMesAct[iIndice] = 0
                THEN dPorcentaje = 0.
            ELSE IF ttevt-AmountMesAnt[iIndice] = 0 AND ttevt-AmountMesAct[iIndice] <> 0 
                THEN dPorcentaje = 100.
            ELSE DO:
                dPorcentaje = (ttevt-AmountMesAct[iIndice] / ttevt-AmountMesAnt[iIndice]) * 100.
            END.
            IF ttevt-AmountMesAct[iIndice] > 0 AND dPorcentaje < 0 
                THEN dPorcentaje = dPorcentaje * -1.
            w-report.Campo-F[5] = dPorcentaje.

            IF ttevt-AccumAnt[iIndice] = 0 AND ttevt-AccumAct[iIndice] = 0
                THEN dPorcentaje = 0.
            ELSE IF ttevt-AccumAnt[iIndice] = 0 AND ttevt-AccumAct[iIndice] <> 0 
                THEN dPorcentaje = 100.
            ELSE DO:
                dPorcentaje = (ttevt-AccumAct[iIndice] / ttevt-AccumAnt[iIndice]) * 100.
            END.
            IF ttevt-AccumAct[iIndice] > 0 AND dPorcentaje < 0 
                THEN dPorcentaje = dPorcentaje * -1.
            w-report.Campo-F[6] = dPorcentaje.

            dTotal[1] = dTotal[1] + ttevt-AmountMesAct[iIndice].
            dTotal[2] = dTotal[2] + ttevt-AmountMesAnt[iIndice].
            dTotal[3] = dTotal[3] + ttevt-AccumAct[iIndice].
            dTotal[4] = dTotal[4] + ttevt-AccumAnt[iIndice].
        END.
        ELSE IF ttevt-Criterio BEGINS "Total" AND
            (dTotal[3] <> 0 OR dTotal[4] <> 0) THEN DO:
            CREATE w-report.
            ASSIGN
                w-report.task-no    = s-task-no
                w-report.Llave-I    = ttevt-Indice
                w-report.Campo-C[1] = ttevt-Criterio
                w-report.Campo-F[1] = dTotal[1]
                w-report.Campo-F[2] = dTotal[2]
                w-report.Campo-F[3] = dTotal[3]
                w-report.Campo-F[4] = dTotal[4].

            IF dTotal[2] = 0 AND dTotal[1] = 0
                THEN dPorcentaje = 0.
            ELSE IF dTotal[2] = 0 AND dTotal[1] <> 0 
                THEN dPorcentaje = 100.
            ELSE DO:
                dPorcentaje = (dTotal[1] / dTotal[2]) * 100.
            END.
            IF dTotal[1] > 0 AND dPorcentaje < 0 
                THEN dPorcentaje = dPorcentaje * -1.           
            w-report.Campo-F[5] = dPorcentaje.
            
            IF dTotal[4] = 0 AND dTotal[3] = 0
                THEN dPorcentaje = 0.
            ELSE IF dTotal[4] = 0 AND dTotal[3] <> 0 
                THEN dPorcentaje = 100.
            ELSE DO:
                dPorcentaje = (dTotal[3] / dTotal[4]) * 100.
            END.
            IF dTotal[4] > 0 AND dPorcentaje < 0 
                THEN dPorcentaje = dPorcentaje * -1.           
            w-report.Campo-F[6] = dPorcentaje.

            dTotal = 0.
        END.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Div B-table-Win 
PROCEDURE Carga-Div :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE x-NroFchR AS DECIMAL     NO-UNDO.

    iInt = 0.
    FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia NO-LOCK:
        FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodCia = gn-divi.CodCia
            AND ttevt-all02.ttevt-CodDiv = gn-divi.CodDiv NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ttevt-all02 THEN DO:
            iInt =  iInt + 1.
            CREATE ttevt-all02.
            ASSIGN
                ttevt-all02.ttevt-CodCia   = gn-divi.CodCia
                ttevt-all02.ttevt-Indice   = iInt
                ttevt-all02.ttevt-CodDiv   = gn-divi.CodDiv
                ttevt-all02.ttevt-Criterio = gn-divi.CodDiv + " - " + INTEGRAL.GN-DIVI.DesDiv.
        END.
    END.
    
    x-NroFchR = ((cb-anio - 1) * 100) + cb-mes.   
    x-NroFchE = (cb-anio  * 100) + cb-mes.
    FOR EACH ttevt-all02 NO-LOCK:
        FOR EACH estavtas.evtdivi NO-LOCK WHERE 
            estavtas.evtdivi.CodCia = ttevt-CodCia AND 
            estavtas.evtdivi.CodDiv = ttevt-CodDiv AND 
            ((estavtas.evtdivi.NroFch >= ((cb-anio - 1) * 100 + 01) AND
             estavtas.evtdivi.NroFch <= x-NroFchR) OR 
             (estavtas.evtdivi.NroFch >= (cb-anio * 100 + 01) AND
             estavtas.evtdivi.NroFch <= x-NroFchE)): 

            IF estavtas.evtdivi.NroFch = x-NroFchR THEN DO:
                ttevt-AmountMesAnt[1] = ttevt-AmountMesAnt[1] + estavtas.evtdivi.VtaxMesMn.
                ttevt-AmountMesAnt[2] = ttevt-AmountMesAnt[2] + estavtas.evtdivi.CtoxMesMn.
                ttevt-AmountMesAnt[3] = ttevt-AmountMesAnt[3] + (estavtas.evtdivi.VtaxMesMn - estavtas.evtdivi.CtoxMesMn).

                ttevt-AmountMesAnt[11] = ttevt-AmountMesAnt[11] + estavtas.evtdivi.VtaxMesMe.
                ttevt-AmountMesAnt[12] = ttevt-AmountMesAnt[12] + estavtas.evtdivi.CtoxMesMe.
                ttevt-AmountMesAnt[13] = ttevt-AmountMesAnt[13] + (estavtas.evtdivi.VtaxMesMe - estavtas.evtdivi.CtoxMesMe).
            END.

            IF estavtas.evtdivi.NroFch = x-NroFchE THEN DO:                    
                ttevt-AmountMesAct[1] = ttevt-AmountMesAct[1] + estavtas.evtdivi.VtaxMesMn.
                ttevt-AmountMesAct[2] = ttevt-AmountMesAct[2] + estavtas.evtdivi.CtoxMesMn.
                ttevt-AmountMesAct[3] = ttevt-AmountMesAct[3] +(estavtas.evtdivi.VtaxMesMn - estavtas.evtdivi.CtoxMesMn).

                ttevt-AmountMesAct[11] = ttevt-AmountMesAct[11] + estavtas.evtdivi.VtaxMesMe.
                ttevt-AmountMesAct[12] = ttevt-AmountMesAct[12] + estavtas.evtdivi.CtoxMesMe.
                ttevt-AmountMesAct[13] = ttevt-AmountMesAct[13] +(estavtas.evtdivi.VtaxMesMe - estavtas.evtdivi.CtoxMesMe).
            END.

            IF (estavtas.evtdivi.NroFch >= ((cb-anio - 1) * 100 + 01) AND estavtas.evtdivi.NroFch <= x-NroFchR) THEN DO:
                ttevt-AccumAnt[1] = ttevt-AccumAnt[1] + estavtas.evtdivi.VtaxMesMn.
                ttevt-AccumAnt[2] = ttevt-AccumAnt[2] + estavtas.evtdivi.CtoxMesMn.
                ttevt-AccumAnt[3] = ttevt-AccumAnt[3] + (estavtas.evtdivi.VtaxMesMn - estavtas.evtdivi.CtoxMesMn).

                ttevt-AccumAnt[11] = ttevt-AccumAnt[11] + estavtas.evtdivi.VtaxMesMe.
                ttevt-AccumAnt[12] = ttevt-AccumAnt[12] + estavtas.evtdivi.CtoxMesMe.
                ttevt-AccumAnt[13] = ttevt-AccumAnt[13] + (estavtas.evtdivi.VtaxMesMe - estavtas.evtdivi.CtoxMesMe).
            END.                    

            IF (estavtas.evtdivi.NroFch >= (cb-anio * 100 + 01) AND estavtas.evtdivi.NroFch <= x-NroFchE) THEN DO:
                ttevt-AccumAct[1] = ttevt-AccumAct[1] + estavtas.evtdivi.VtaxMesMn.
                ttevt-AccumAct[2] = ttevt-AccumAct[2] + estavtas.evtdivi.CtoxMesMn.
                ttevt-AccumAct[3] = ttevt-AccumAct[3] + (estavtas.evtdivi.VtaxMesMn - estavtas.evtdivi.CtoxMesMn).

                ttevt-AccumAct[11] = ttevt-AccumAct[11] + estavtas.evtdivi.VtaxMesMe.
                ttevt-AccumAct[12] = ttevt-AccumAct[12] + estavtas.evtdivi.CtoxMesMe.
                ttevt-AccumAct[13] = ttevt-AccumAct[13] + (estavtas.evtdivi.VtaxMesMe - estavtas.evtdivi.CtoxMesMe).
            END.                    
            PAUSE 0.
        END.
        DISPLAY
            'Espere un momento por favor...' SKIP
            'Procesando Información División: ' ttevt-all02.ttevt-CodDiv NO-LABEL
            WITH FRAME F-Mensaje TITLE 'Procesando informacion' CENTERED OVERLAY VIEW-AS DIALOG-BOX.
    END.
    HIDE FRAME f-Mensaje.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Div-Cli B-table-Win 
PROCEDURE Carga-Div-Cli :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dVtaAct    AS DECIMAL EXTENT 20 NO-UNDO.    
    DEFINE VARIABLE dVtaAnt    AS DECIMAL EXTENT 20 NO-UNDO.    
    DEFINE VARIABLE dAcumAct   AS DECIMAL EXTENT 20 NO-UNDO.    
    DEFINE VARIABLE dAcumAnt   AS DECIMAL EXTENT 20 NO-UNDO.    
    DEFINE VARIABLE cName  LIKE gn-clie.NomCli NO-UNDO.
    DEFINE VARIABLE iCount AS INTEGER NO-UNDO.       
    DEFINE VARIABLE x-NroFchR  AS DECIMAL     NO-UNDO.
    
    iInt    = 0.
    
    FOR EACH gn-divi WHERE gn-divi.CodCia = s-CodCia NO-LOCK:
        iCount = 0.
        Clientes:
        FOR EACH estavtas.evtall03 NO-LOCK USE-INDEX Indice02 WHERE estavtas.evtall03.Codcia = gn-divi.CodCia
            BY estavtas.evtall03.VtaxMesMe DESC:

            FIND FIRST gn-cliex WHERE gn-cliex.CodCia = cl-codcia
                AND gn-cliex.CodUnico = estavtas.evtall03.CodUnico NO-LOCK NO-ERROR.
            IF AVAILABLE gn-cliex THEN NEXT Clientes.            
            FIND FIRST gn-clie WHERE gn-clie.CodCia = cl-CodCia 
                AND gn-clie.CodCli = estavtas.evtall03.CodUnico NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clie THEN cName = gn-clie.NomCli. ELSE cName = "".
    
            FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodCia = estavtas.evtall03.CodCia
                AND ttevt-all02.ttevt-CodDiv   = gn-divi.CodDiv   
                AND ttevt-all02.ttevt-CodUnico = estavtas.evtall03.CodUnico NO-LOCK NO-ERROR.           
            IF NOT AVAILABLE ttevt-all02 THEN DO:
                iInt =  iInt + 1.
                iCount = iCount + 1.
                CREATE ttevt-all02.
                ASSIGN
                    ttevt-all02.ttevt-CodCia   = estavtas.evtall03.Codcia
                    ttevt-all02.ttevt-Indice   = iInt
                    ttevt-all02.ttevt-CodDiv   = gn-divi.CodDiv
                    ttevt-all02.ttevt-CodUnico = estavtas.evtall03.CodUnico
                    ttevt-all02.ttevt-Criterio = estavtas.evtall03.CodUnico + " - " + cName. 
            END.                
            IF iCount >= txt-top THEN LEAVE Clientes.
        END.
        FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodCia = estavtas.evtall03.CodCia
            AND ttevt-all02.ttevt-CodDiv   = gn-divi.CodDiv   
            AND ttevt-all02.ttevt-CodUnico = "XXX" NO-LOCK NO-ERROR.       
        IF NOT AVAILABLE ttevt-all02 THEN DO:
            iInt =  iInt + 1.                
            CREATE ttevt-all02.
            ASSIGN
                ttevt-all02.ttevt-CodCia   = estavtas.evtall03.Codcia
                ttevt-all02.ttevt-Indice   = iInt
                ttevt-all02.ttevt-CodDiv   = gn-divi.CodDiv
                ttevt-all02.ttevt-CodUnico = "XXX"
                ttevt-all02.ttevt-Criterio = "Total División " + gn-divi.CodDiv + " - " + GN-DIVI.DesDiv. 
        END.                
    END.

    x-NroFchI = ((cb-anio - 1) * 100) + 01.    
    x-NroFchR = ((cb-anio - 1) * 100) + cb-mes.    
    x-NroFchE = (cb-anio  * 100) + cb-mes.

    FOR EACH ttevt-all02 NO-LOCK USE-INDEX Indx01:
        dVtaAct = 0.
        dVtaAnt = 0.
        dAcumAct = 0.
        dAcumAnt = 0.
        FOR EACH estavtas.evtclie NO-LOCK WHERE 
            estavtas.evtclie.CodCia   = ttevt-CodCia   AND 
            estavtas.evtclie.CodDiv   = ttevt-CodDiv   AND 
            estavtas.evtclie.CodUnico = ttevt-CodUnico AND 
            ((estavtas.evtclie.NroFch >= x-NroFchI AND
            estavtas.evtclie.NroFch  <= ((cb-anio - 1) * 100 + cb-mes)) OR
            (estavtas.evtclie.NroFch >= (cb-anio * 100 + 01) AND 
            estavtas.evtclie.NroFch  <= x-NroFchE)): 

            IF estavtas.evtclie.NroFch = x-NroFchR THEN DO:
                dVtaAnt[1] = dVtaAnt[1] + estavtas.evtclie.VtaxMesMn.
                dVtaAnt[2] = dVtaAnt[2] + estavtas.evtclie.CtoxMesMn.
                dVtaAnt[3] = dVtaAnt[3] + (estavtas.evtclie.VtaxMesMn - estavtas.evtclie.CtoxMesMn).

                dVtaAnt[11] = dVtaAnt[11] + estavtas.evtclie.VtaxMesMe.
                dVtaAnt[12] = dVtaAnt[12] + estavtas.evtclie.CtoxMesMe.
                dVtaAnt[13] = dVtaAnt[13] + (estavtas.evtclie.VtaxMesMe - estavtas.evtclie.CtoxMesMe).
            END.

            IF estavtas.evtclie.NroFch = x-NroFchE THEN DO:                    
                dVtaAct[1] = dVtaAct[1] + estavtas.evtclie.VtaxMesMn.
                dVtaAct[2] = dVtaAct[2] + estavtas.evtclie.CtoxMesMn.
                dVtaAct[3] = dVtaAct[3] +(estavtas.evtclie.VtaxMesMn - estavtas.evtclie.CtoxMesMn).

                dVtaAct[11] = dVtaAct[11] + estavtas.evtclie.VtaxMesMe.
                dVtaAct[12] = dVtaAct[12] + estavtas.evtclie.CtoxMesMe.
                dVtaAct[13] = dVtaAct[13] +(estavtas.evtclie.VtaxMesMe - estavtas.evtclie.CtoxMesMe).
            END.

            IF (estavtas.evtclie.NroFch >= ((cb-anio - 1) * 100 + 01) AND estavtas.evtclie.NroFch <= x-NroFchR) THEN DO:
                dAcumAnt[1] = dAcumAnt[1] + estavtas.evtclie.VtaxMesMn.
                dAcumAnt[2] = dAcumAnt[2] + estavtas.evtclie.CtoxMesMn.
                dAcumAnt[3] = dAcumAnt[3] + (estavtas.evtclie.VtaxMesMn - estavtas.evtclie.CtoxMesMn).

                dAcumAnt[11] = dAcumAnt[11] + estavtas.evtclie.VtaxMesMe.
                dAcumAnt[12] = dAcumAnt[12] + estavtas.evtclie.CtoxMesMe.
                dAcumAnt[13] = dAcumAnt[13] + (estavtas.evtclie.VtaxMesMe - estavtas.evtclie.CtoxMesMe).
            END.                    

            IF (estavtas.evtclie.NroFch >= (cb-anio * 100 + 01) AND estavtas.evtclie.NroFch <= x-NroFchE) THEN DO:
                dAcumAct[1] = dAcumAct[1] + estavtas.evtclie.VtaxMesMn.
                dAcumAct[2] = dAcumAct[2] + estavtas.evtclie.CtoxMesMn.
                dAcumAct[3] = dAcumAct[3] + (estavtas.evtclie.VtaxMesMn - estavtas.evtclie.CtoxMesMn).

                dAcumAct[11] = dAcumAct[11] + estavtas.evtclie.VtaxMesMe.
                dAcumAct[12] = dAcumAct[12] + estavtas.evtclie.CtoxMesMe.
                dAcumAct[13] = dAcumAct[13] + (estavtas.evtclie.VtaxMesMe - estavtas.evtclie.CtoxMesMe).
            END.    
            PAUSE 0.
            ASSIGN
                ttevt-AmountMesAct[1] = dVtaAct[1]
                ttevt-AmountMesAct[2] = dVtaAct[2]
                ttevt-AmountMesAct[3] = dVtaAct[3]
                ttevt-AmountMesAct[11] = dVtaAct[11]
                ttevt-AmountMesAct[12] = dVtaAct[12]
                ttevt-AmountMesAct[13] = dVtaAct[13]

                ttevt-AmountMesAnt[1] = dVtaAnt[1] 
                ttevt-AmountMesAnt[2] = dVtaAnt[2] 
                ttevt-AmountMesAnt[3] = dVtaAnt[3]
                ttevt-AmountMesAnt[11] = dVtaAnt[11] 
                ttevt-AmountMesAnt[12] = dVtaAnt[12] 
                ttevt-AmountMesAnt[13] = dVtaAnt[13]

                ttevt-AccumAct[1] = dAcumAct[1]
                ttevt-AccumAct[2] = dAcumAct[2]
                ttevt-AccumAct[3] = dAcumAct[3]
                ttevt-AccumAct[11] = dAcumAct[11]
                ttevt-AccumAct[12] = dAcumAct[12]
                ttevt-AccumAct[13] = dAcumAct[13]

                ttevt-AccumAnt[1] = dAcumAnt[1]
                ttevt-AccumAnt[2] = dAcumAnt[2]
                ttevt-AccumAnt[3] = dAcumAnt[3]
                ttevt-AccumAnt[11] = dAcumAnt[11]
                ttevt-AccumAnt[12] = dAcumAnt[12]
                ttevt-AccumAnt[13] = dAcumAnt[13].

            DISPLAY
                    'Espere un momento por favor...' SKIP
                    'Procesando Información Cliente: ' ttevt-CodUnico NO-LABEL
                    WITH FRAME F-Mensaje TITLE 'Procesando informacion' CENTERED OVERLAY VIEW-AS DIALOG-BOX.
            
        END.
    END.      
    HIDE FRAME f-Mensaje.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Div-Fam B-table-Win 
PROCEDURE Carga-Div-Fam :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE x-NroFchR AS INTEGER NO-UNDO.
    
    x-NroFchI = (cb-anio * 100) + cb-mes.
    iInt = 0.
    FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia NO-LOCK:
        FOR EACH AlmtFami WHERE AlmtFami.CodCia = gn-divi.CodCia NO-LOCK:
            FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodCia = gn-divi.CodCia
                AND ttevt-all02.ttevt-CodDiv = gn-divi.CodDiv
                AND ttevt-all02.ttevt-CodFam = AlmtFami.CodFam NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ttevt-all02 THEN DO:
                iInt =  iInt + 1.
                CREATE ttevt-all02.
                ASSIGN
                    ttevt-all02.ttevt-CodCia   = AlmtFami.CodCia
                    ttevt-all02.ttevt-Indice   = iInt
                    ttevt-all02.ttevt-CodDiv   = gn-divi.CodDiv
                    ttevt-all02.ttevt-CodFam   = AlmtFami.CodFam
                    ttevt-all02.ttevt-Criterio = AlmtFami.CodFam + " - " + AlmtFami.DesFam.
            END.        
        END.
        FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodCia = gn-divi.CodCia
            AND ttevt-all02.ttevt-CodDiv = gn-divi.CodDiv
            AND ttevt-all02.ttevt-CodFam = "XXX" NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ttevt-all02 THEN DO:
            iInt =  iInt + 1.
            CREATE ttevt-all02.
            ASSIGN
                ttevt-all02.ttevt-CodCia   = gn-divi.CodCia
                ttevt-all02.ttevt-Indice   = iInt
                ttevt-all02.ttevt-CodDiv   = gn-divi.CodDiv
                ttevt-all02.ttevt-CodFam   = "XXX"
                ttevt-all02.ttevt-Criterio = "Total División " + gn-divi.CodDiv + " - " + GN-DIVI.DesDiv.
        END.        
    END.

    x-NroFchI = ((cb-anio - 1) * 100) + 01.    
    x-NroFchR = ((cb-anio - 1) * 100) + cb-mes.    
    x-NroFchE = (cb-anio  * 100) + cb-mes.

    FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia,
        EACH estavtas.EvtArtDv USE-INDEX Indice03 NO-LOCK WHERE 
            estavtas.EvtArtDv.CodCia = s-CodCia AND 
            estavtas.EvtArtDv.CodMat = Almmmatg.codmat AND 
            ((estavtas.EvtArtDv.NroFch >= ((cb-anio - 1) * 100 + 01) AND
             estavtas.EvtArtDv.NroFch <= x-NroFchR) OR 
             (estavtas.EvtArtDv.NroFch >= (cb-anio * 100 + 01) AND
             estavtas.EvtArtDv.NroFch <= x-NroFchE)): 
        FIND ttevt-all02 WHERE ttevt-all02.ttevt-CodCia = s-CodCia
            AND ttevt-all02.ttevt-CodDiv = estavtas.EvtArtDv.CodDiv
            AND ttevt-all02.ttevt-CodFam = Almmmatg.CodFam.
        IF estavtas.EvtArtDv.NroFch = x-NroFchR THEN DO:
            ttevt-AmountMesAnt[1] = ttevt-AmountMesAnt[1] + estavtas.EvtArtDv.VtaxMesMn.
            ttevt-AmountMesAnt[2] = ttevt-AmountMesAnt[2] + estavtas.EvtArtDv.CtoxMesMn.
            ttevt-AmountMesAnt[3] = ttevt-AmountMesAnt[3] + (estavtas.EvtArtDv.VtaxMesMn - estavtas.EvtArtDv.CtoxMesMn).

            ttevt-AmountMesAnt[11] = ttevt-AmountMesAnt[11] + estavtas.EvtArtDv.VtaxMesMe.
            ttevt-AmountMesAnt[12] = ttevt-AmountMesAnt[12] + estavtas.EvtArtDv.CtoxMesMe.
            ttevt-AmountMesAnt[13] = ttevt-AmountMesAnt[13] + (estavtas.EvtArtDv.VtaxMesMe - estavtas.EvtArtDv.CtoxMesMe).
        END.

        IF estavtas.EvtArtDv.NroFch = x-NroFchE THEN DO:                    
            ttevt-AmountMesAct[1] = ttevt-AmountMesAct[1] + estavtas.EvtArtDv.VtaxMesMn.
            ttevt-AmountMesAct[2] = ttevt-AmountMesAct[2] + estavtas.EvtArtDv.CtoxMesMn.
            ttevt-AmountMesAct[3] = ttevt-AmountMesAct[3] +(estavtas.EvtArtDv.VtaxMesMn - estavtas.EvtArtDv.CtoxMesMn).

            ttevt-AmountMesAct[11] = ttevt-AmountMesAct[11] + estavtas.EvtArtDv.VtaxMesMe.
            ttevt-AmountMesAct[12] = ttevt-AmountMesAct[12] + estavtas.EvtArtDv.CtoxMesMe.
            ttevt-AmountMesAct[13] = ttevt-AmountMesAct[13] +(estavtas.EvtArtDv.VtaxMesMe - estavtas.EvtArtDv.CtoxMesMe).
        END.

        IF (estavtas.EvtArtDv.NroFch >= ((cb-anio - 1) * 100 + 01) AND estavtas.EvtArtDv.NroFch <= x-NroFchR) THEN DO:
            ttevt-AccumAnt[1] = ttevt-AccumAnt[1] + estavtas.EvtArtDv.VtaxMesMn.
            ttevt-AccumAnt[2] = ttevt-AccumAnt[2] + estavtas.EvtArtDv.CtoxMesMn.
            ttevt-AccumAnt[3] = ttevt-AccumAnt[3] + (estavtas.EvtArtDv.VtaxMesMn - estavtas.EvtArtDv.CtoxMesMn).

            ttevt-AccumAnt[11] = ttevt-AccumAnt[11] + estavtas.EvtArtDv.VtaxMesMe.
            ttevt-AccumAnt[12] = ttevt-AccumAnt[12] + estavtas.EvtArtDv.CtoxMesMe.
            ttevt-AccumAnt[13] = ttevt-AccumAnt[13] + (estavtas.EvtArtDv.VtaxMesMe - estavtas.EvtArtDv.CtoxMesMe).
        END.                    

        IF (estavtas.EvtArtDv.NroFch >= (cb-anio * 100 + 01) AND estavtas.EvtArtDv.NroFch <= x-NroFchE) THEN DO:
            ttevt-AccumAct[1] = ttevt-AccumAct[1] + estavtas.EvtArtDv.VtaxMesMn.
            ttevt-AccumAct[2] = ttevt-AccumAct[2] + estavtas.EvtArtDv.CtoxMesMn.
            ttevt-AccumAct[3] = ttevt-AccumAct[3] + (estavtas.EvtArtDv.VtaxMesMn - estavtas.EvtArtDv.CtoxMesMn).

            ttevt-AccumAct[11] = ttevt-AccumAct[11] + estavtas.EvtArtDv.VtaxMesMe.
            ttevt-AccumAct[12] = ttevt-AccumAct[12] + estavtas.EvtArtDv.CtoxMesMe.
            ttevt-AccumAct[13] = ttevt-AccumAct[13] + (estavtas.EvtArtDv.VtaxMesMe - estavtas.EvtArtDv.CtoxMesMe).
        END.                    
        DISPLAY
            'Espere un momento por favor...' SKIP
            'Procesando Información Linea: ' Almmmatg.CodMat NO-LABEL
            WITH FRAME F-Mensaje TITLE 'Procesando informacion' CENTERED OVERLAY VIEW-AS DIALOG-BOX.
        PAUSE 0.
    END.
    HIDE FRAME f-Mensaje.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Divisiones B-table-Win 
PROCEDURE Carga-Divisiones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iIndx AS INTEGER NO-UNDO.
    
    RUN Carga-Div.
    CASE cb-tipo:
        WHEN "Ventas" THEN iIndx = 1. 
        WHEN "Costos" THEN iIndx = 2. 
        WHEN "Margen" THEN iIndx = 3. 
    END CASE.
    RUN Carga-Detalle (iIndx).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Divisiones-Cliente B-table-Win 
PROCEDURE Carga-Divisiones-Cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iIndx AS INTEGER NO-UNDO.

    RUN Carga-Div-Cli.
    CASE cb-tipo:
        WHEN "Ventas" THEN iIndx = 1. 
        WHEN "Costos" THEN iIndx = 2. 
        WHEN "Margen" THEN iIndx = 3. 
    END CASE.
    RUN Carga-Detalle2 (iIndx).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Divisiones-Familia B-table-Win 
PROCEDURE Carga-Divisiones-Familia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iIndx AS INTEGER NO-UNDO.

    RUN Carga-Div-Fam.
    CASE cb-tipo:
        WHEN "Ventas" THEN iIndx = 1. 
        WHEN "Costos" THEN iIndx = 2. 
        WHEN "Margen" THEN iIndx = 3. 
    END CASE.

    RUN Carga-Detalle2 (iIndx).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Fam-Cli B-table-Win 
PROCEDURE Carga-Fam-Cli :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE dVtaAct    AS DECIMAL EXTENT 20 NO-UNDO.    
    DEFINE VARIABLE dVtaAnt    AS DECIMAL EXTENT 20 NO-UNDO.    
    DEFINE VARIABLE dAcumAct   AS DECIMAL EXTENT 20 NO-UNDO.    
    DEFINE VARIABLE dAcumAnt   AS DECIMAL EXTENT 20 NO-UNDO. 
    DEFINE VARIABLE cName     LIKE gn-clie.NomCli  NO-UNDO.
    DEFINE VARIABLE iCount    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE x-NroFchR AS INTEGER     NO-UNDO.

    FOR EACH AlmtFami WHERE AlmtFami.CodCia = s-CodCia NO-LOCK:
        iCount = 0.
        Clientes:
        FOR EACH estavtas.evtall03 NO-LOCK USE-INDEX Indice02 WHERE estavtas.evtall03.Codcia = AlmtFami.CodCia
            BY estavtas.evtall03.VtaxMesMe DESC:

            FIND FIRST gn-cliex WHERE gn-cliex.CodCia = cl-codcia
                AND gn-cliex.CodUnico = estavtas.evtall03.CodUnico NO-LOCK NO-ERROR.
            IF AVAILABLE gn-cliex THEN NEXT Clientes.            
            FIND FIRST gn-clie WHERE gn-clie.CodCia = cl-CodCia 
                AND gn-clie.CodCli = estavtas.evtall03.CodUnico NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clie THEN cName = gn-clie.NomCli. ELSE cName = "".
    
            FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodCia = estavtas.evtall03.CodCia
                AND ttevt-all02.ttevt-CodFam   = AlmtFami.CodFam
                AND ttevt-all02.ttevt-CodUnico = estavtas.evtall03.CodUnico NO-LOCK NO-ERROR.           
            IF NOT AVAILABLE ttevt-all02 THEN DO:
                iInt =  iInt + 1.
                iCount = iCount + 1.
                CREATE ttevt-all02.
                ASSIGN
                    ttevt-all02.ttevt-CodCia   = estavtas.evtall03.Codcia
                    ttevt-all02.ttevt-Indice   = iInt
                    ttevt-all02.ttevt-CodFam   = AlmtFami.CodFam
                    ttevt-all02.ttevt-CodUnico = estavtas.evtall03.CodUnico
                    ttevt-all02.ttevt-Criterio = estavtas.evtall03.CodUnico + " - " + cName. 
            END.                
            IF iCount >= txt-top THEN LEAVE Clientes.
        END.
        FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodCia = s-CodCia
            AND ttevt-all02.ttevt-CodFam   = AlmtFami.CodFam 
            AND ttevt-all02.ttevt-CodUnico = "XXX" NO-LOCK NO-ERROR.       
        IF NOT AVAILABLE ttevt-all02 THEN DO:
            iInt =  iInt + 1.                
            CREATE ttevt-all02.
            ASSIGN
                ttevt-all02.ttevt-CodCia   = s-Codcia
                ttevt-all02.ttevt-Indice   = iInt
                ttevt-all02.ttevt-CodFam   = AlmtFami.CodFam
                ttevt-all02.ttevt-CodUnico = "XXX"
                ttevt-all02.ttevt-Criterio = "Total Línea " + AlmtFami.CodFam + " - " + Almtfami.desfam. 
        END.                
    END.

    
    x-NroFchI = ((cb-anio - 1) * 100) + 01.    
    x-NroFchR = ((cb-anio - 1) * 100) + cb-mes.    
    x-NroFchE = (cb-anio  * 100) + cb-mes.

    FOR EACH ttevt-all02 NO-LOCK USE-INDEX Indx01:
        dVtaAct  = 0.
        dVtaAnt  = 0.
        dAcumAct = 0.
        dAcumAnt = 0.
        FOR EACH estavtas.evtclarti USE-INDEX Indice03 NO-LOCK WHERE 
            estavtas.evtclarti.CodCia   = ttevt-CodCia   AND 
            estavtas.evtclarti.CodUnico = ttevt-CodUnico AND 
            ((estavtas.evtclarti.NroFch >= x-NroFchI AND
            estavtas.evtclarti.NroFch  <= ((cb-anio - 1) * 100 + cb-mes)) OR
            (estavtas.evtclarti.NroFch >= (cb-anio * 100 + 01) AND 
            estavtas.evtclarti.NroFch  <= x-NroFchE)),
            FIRST Almmmatg OF estavtas.evtclarti NO-LOCK WHERE Almmmatg.codfam = ttevt-CodFam: 

            IF estavtas.evtclarti.NroFch = x-NroFchR THEN DO:
                dVtaAnt[1] = dVtaAnt[1] + estavtas.evtclarti.VtaxMesMn.
                dVtaAnt[2] = dVtaAnt[2] + estavtas.evtclarti.CtoxMesMn.
                dVtaAnt[3] = dVtaAnt[3] + (estavtas.evtclarti.VtaxMesMn - estavtas.evtclarti.CtoxMesMn).

                dVtaAnt[11] = dVtaAnt[11] + estavtas.evtclarti.VtaxMesMe.
                dVtaAnt[12] = dVtaAnt[12] + estavtas.evtclarti.CtoxMesMe.
                dVtaAnt[13] = dVtaAnt[13] + (estavtas.evtclarti.VtaxMesMe - estavtas.evtclarti.CtoxMesMe).
            END.

            IF estavtas.evtclarti.NroFch = x-NroFchE THEN DO:                    
                dVtaAct[1] = dVtaAct[1] + estavtas.evtclarti.VtaxMesMn.
                dVtaAct[2] = dVtaAct[2] + estavtas.evtclarti.CtoxMesMn.
                dVtaAct[3] = dVtaAct[3] +(estavtas.evtclarti.VtaxMesMn - estavtas.evtclarti.CtoxMesMn).

                dVtaAct[11] = dVtaAct[11] + estavtas.evtclarti.VtaxMesMe.
                dVtaAct[12] = dVtaAct[12] + estavtas.evtclarti.CtoxMesMe.
                dVtaAct[13] = dVtaAct[13] +(estavtas.evtclarti.VtaxMesMe - estavtas.evtclarti.CtoxMesMe).
            END.

            IF (estavtas.evtclarti.NroFch >= ((cb-anio - 1) * 100 + 01) AND estavtas.evtclarti.NroFch <= x-NroFchR) THEN DO:
                dAcumAnt[1] = dAcumAnt[1] + estavtas.evtclarti.VtaxMesMn.
                dAcumAnt[2] = dAcumAnt[2] + estavtas.evtclarti.CtoxMesMn.
                dAcumAnt[3] = dAcumAnt[3] + (estavtas.evtclarti.VtaxMesMn - estavtas.evtclarti.CtoxMesMn).

                dAcumAnt[11] = dAcumAnt[11] + estavtas.evtclarti.VtaxMesMe.
                dAcumAnt[12] = dAcumAnt[12] + estavtas.evtclarti.CtoxMesMe.
                dAcumAnt[13] = dAcumAnt[13] + (estavtas.evtclarti.VtaxMesMe - estavtas.evtclarti.CtoxMesMe).
            END.                    

            IF (estavtas.evtclarti.NroFch >= (cb-anio * 100 + 01) AND estavtas.evtclarti.NroFch <= x-NroFchE) THEN DO:
                dAcumAct[1] = dAcumAct[1] + estavtas.evtclarti.VtaxMesMn.
                dAcumAct[2] = dAcumAct[2] + estavtas.evtclarti.CtoxMesMn.
                dAcumAct[3] = dAcumAct[3] + (estavtas.evtclarti.VtaxMesMn - estavtas.evtclarti.CtoxMesMn).

                dAcumAct[11] = dAcumAct[11] + estavtas.evtclarti.VtaxMesMe.
                dAcumAct[12] = dAcumAct[12] + estavtas.evtclarti.CtoxMesMe.
                dAcumAct[13] = dAcumAct[13] + (estavtas.evtclarti.VtaxMesMe - estavtas.evtclarti.CtoxMesMe).
            END.    
            PAUSE 0.
            ASSIGN
                ttevt-AmountMesAct[1] = dVtaAct[1]
                ttevt-AmountMesAct[2] = dVtaAct[2]
                ttevt-AmountMesAct[3] = dVtaAct[3]
                ttevt-AmountMesAct[11] = dVtaAct[11]
                ttevt-AmountMesAct[12] = dVtaAct[12]
                ttevt-AmountMesAct[13] = dVtaAct[13]

                ttevt-AmountMesAnt[1] = dVtaAnt[1] 
                ttevt-AmountMesAnt[2] = dVtaAnt[2] 
                ttevt-AmountMesAnt[3] = dVtaAnt[3]
                ttevt-AmountMesAnt[11] = dVtaAnt[11] 
                ttevt-AmountMesAnt[12] = dVtaAnt[12] 
                ttevt-AmountMesAnt[13] = dVtaAnt[13]

                ttevt-AccumAct[1] = dAcumAct[1]
                ttevt-AccumAct[2] = dAcumAct[2]
                ttevt-AccumAct[3] = dAcumAct[3]
                ttevt-AccumAct[11] = dAcumAct[11]
                ttevt-AccumAct[12] = dAcumAct[12]
                ttevt-AccumAct[13] = dAcumAct[13]

                ttevt-AccumAnt[1] = dAcumAnt[1]
                ttevt-AccumAnt[2] = dAcumAnt[2]
                ttevt-AccumAnt[3] = dAcumAnt[3]
                ttevt-AccumAnt[11] = dAcumAnt[11]
                ttevt-AccumAnt[12] = dAcumAnt[12]
                ttevt-AccumAnt[13] = dAcumAnt[13].

            DISPLAY
                    'Espere un momento por favor...' SKIP
                    'Procesando Información Cliente: ' ttevt-CodUnico NO-LABEL
                    WITH FRAME F-Mensaje TITLE 'Procesando informacion' CENTERED OVERLAY VIEW-AS DIALOG-BOX.
            
        END.
    END.      
    HIDE FRAME f-Mensaje.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Familia B-table-Win 
PROCEDURE Carga-Familia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iIndx AS INTEGER NO-UNDO.

    RUN Carga-Line.
    CASE cb-tipo:
        WHEN "Ventas" THEN iIndx = 1. 
        WHEN "Costos" THEN iIndx = 2. 
        WHEN "Margen" THEN iIndx = 3. 
    END CASE.
    RUN Carga-Detalle (iIndx).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Familia-Cliente B-table-Win 
PROCEDURE Carga-Familia-Cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iIndx AS INTEGER NO-UNDO.

    RUN Carga-Fam-Cli.
    CASE cb-tipo:
        WHEN "Ventas" THEN iIndx = 1. 
        WHEN "Costos" THEN iIndx = 2. 
        WHEN "Margen" THEN iIndx = 3. 
    END CASE.

    RUN Carga-Detalle2 (iIndx).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Line B-table-Win 
PROCEDURE Carga-Line :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE x-NroFchR AS DECIMAL     NO-UNDO.

    x-NroFchI = cb-anio * 100 + cb-mes.
    iInt = 0.
    FOR EACH AlmtFami WHERE AlmtFami.CodCia = s-codcia NO-LOCK:
        FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodCia = AlmtFami.CodCia
            AND ttevt-all02.ttevt-CodFam = AlmtFami.CodFam NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ttevt-all02 THEN DO:
            iInt =  iInt + 1.
            CREATE ttevt-all02.
            ASSIGN
                ttevt-all02.ttevt-CodCia   = AlmtFami.CodCia
                ttevt-all02.ttevt-Indice   = iInt
                ttevt-all02.ttevt-CodFam   = AlmtFami.CodFam
                ttevt-all02.ttevt-Criterio = AlmtFami.CodFam + " - " + AlmtFami.DesFam.
        END.        
    END.

    x-NroFchR = ((cb-anio - 1) * 100) + cb-mes.   
    x-NroFchE = (cb-anio  * 100) + cb-mes.

    FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia,
        EACH estavtas.evtarti USE-INDEX Indice03 NO-LOCK WHERE 
            estavtas.evtarti.CodCia = ttevt-CodCia AND 
            estavtas.evtarti.CodMat = Almmmatg.CodMat AND 
            ((estavtas.evtarti.NroFch >= ((cb-anio - 1) * 100 + 01) AND
              estavtas.evtarti.NroFch <= x-NroFchR) OR 
             (estavtas.evtarti.NroFch >= (cb-anio * 100 + 01) AND
              estavtas.evtarti.NroFch <= x-NroFchE)):
        FIND ttevt-all02 WHERE ttevt-all02.ttevt-codcia = estavtas.evtarti.codcia
            AND ttevt-all02.ttevt-codfam = Almmmatg.codfam.
        IF estavtas.evtarti.NroFch = x-NroFchR THEN DO:
            ttevt-AmountMesAnt[1] = ttevt-AmountMesAnt[1] + estavtas.evtarti.VtaxMesMn.
            ttevt-AmountMesAnt[2] = ttevt-AmountMesAnt[2] + estavtas.evtarti.CtoxMesMn.
            ttevt-AmountMesAnt[3] = ttevt-AmountMesAnt[3] + (estavtas.evtarti.VtaxMesMn - estavtas.evtarti.CtoxMesMn).

            ttevt-AmountMesAnt[11] = ttevt-AmountMesAnt[11] + estavtas.evtarti.VtaxMesMe.
            ttevt-AmountMesAnt[12] = ttevt-AmountMesAnt[12] + estavtas.evtarti.CtoxMesMe.
            ttevt-AmountMesAnt[13] = ttevt-AmountMesAnt[13] + (estavtas.evtarti.VtaxMesMe - estavtas.evtarti.CtoxMesMe).
        END.

        IF estavtas.evtarti.NroFch = x-NroFchE THEN DO:                    
            ttevt-AmountMesAct[1] = ttevt-AmountMesAct[1] + estavtas.evtarti.VtaxMesMn.
            ttevt-AmountMesAct[2] = ttevt-AmountMesAct[2] + estavtas.evtarti.CtoxMesMn.
            ttevt-AmountMesAct[3] = ttevt-AmountMesAct[3] +(estavtas.evtarti.VtaxMesMn - estavtas.evtarti.CtoxMesMn).

            ttevt-AmountMesAct[11] = ttevt-AmountMesAct[11] + estavtas.evtarti.VtaxMesMe.
            ttevt-AmountMesAct[12] = ttevt-AmountMesAct[12] + estavtas.evtarti.CtoxMesMe.
            ttevt-AmountMesAct[13] = ttevt-AmountMesAct[13] +(estavtas.evtarti.VtaxMesMe - estavtas.evtarti.CtoxMesMe).
        END.

        IF (estavtas.evtarti.NroFch >= ((cb-anio - 1) * 100 + 01) AND estavtas.evtarti.NroFch <= x-NroFchR) THEN DO:
            ttevt-AccumAnt[1] = ttevt-AccumAnt[1] + estavtas.evtarti.VtaxMesMn.
            ttevt-AccumAnt[2] = ttevt-AccumAnt[2] + estavtas.evtarti.CtoxMesMn.
            ttevt-AccumAnt[3] = ttevt-AccumAnt[3] + (estavtas.evtarti.VtaxMesMn - estavtas.evtarti.CtoxMesMn).

            ttevt-AccumAnt[11] = ttevt-AccumAnt[11] + estavtas.evtarti.VtaxMesMe.
            ttevt-AccumAnt[12] = ttevt-AccumAnt[12] + estavtas.evtarti.CtoxMesMe.
            ttevt-AccumAnt[13] = ttevt-AccumAnt[13] + (estavtas.evtarti.VtaxMesMe - estavtas.evtarti.CtoxMesMe).
        END.                    

        IF (estavtas.evtarti.NroFch >= (cb-anio * 100 + 01) AND estavtas.evtarti.NroFch <= x-NroFchE) THEN DO:
            ttevt-AccumAct[1] = ttevt-AccumAct[1] + estavtas.evtarti.VtaxMesMn.
            ttevt-AccumAct[2] = ttevt-AccumAct[2] + estavtas.evtarti.CtoxMesMn.
            ttevt-AccumAct[3] = ttevt-AccumAct[3] + (estavtas.evtarti.VtaxMesMn - estavtas.evtarti.CtoxMesMn).

            ttevt-AccumAct[11] = ttevt-AccumAct[11] + estavtas.evtarti.VtaxMesMe.
            ttevt-AccumAct[12] = ttevt-AccumAct[12] + estavtas.evtarti.CtoxMesMe.
            ttevt-AccumAct[13] = ttevt-AccumAct[13] + (estavtas.evtarti.VtaxMesMe - estavtas.evtarti.CtoxMesMe).
            PAUSE 0.
        END.                    
        DISPLAY
            'Espere un momento por favor...' SKIP
            'Procesando Información Linea: ' estavtas.evtarti.codmat NO-LABEL
            WITH FRAME F-Mensaje TITLE 'Procesando informacion' CENTERED OVERLAY VIEW-AS DIALOG-BOX.
    END.
    HIDE FRAME f-Mensaje.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Totales B-table-Win 
PROCEDURE Carga-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dTot1 AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dTot2 AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dTot3 AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dTot4 AS DECIMAL     NO-UNDO.
    
    ASSIGN 
        txt-amount1 = 0
        txt-amount2 = 0
        txt-acum1   = 0
        txt-acum2   = 0
        txt-dif1    = 0
        txt-dif2    = 0.

    FOR EACH w-report WHERE task-no = s-task-no NO-LOCK:
        IF w-report.Campo-C[1] BEGINS "Total" THEN NEXT.
        dTot1 = dTot1 + w-report.Campo-F[1]. 
        dTot2 = dTot2 + w-report.Campo-F[2]. 
        dTot3 = dTot3 + w-report.Campo-F[3]. 
        dTot4 = dTot4 + w-report.Campo-F[4]. 
    END.
    ASSIGN 
        txt-amount1 = dTot1
        txt-amount2 = dTot2
        txt-acum1   = dTot3
        txt-acum2   = dTot4.

    IF txt-amount2 <> 0 THEN ASSIGN txt-dif1 = txt-amount1 / txt-amount2 * 100.
        ELSE  ASSIGN txt-dif1 = 100.
    IF txt-acum2 <> 0 THEN ASSIGN txt-dif2 = txt-acum1 / txt-acum2 * 100.
        ELSE ASSIGN txt-dif2 = 100.

IF (txt-dif1 > 115) THEN ASSIGN txt-dif1:BGCOLOR IN FRAME {&FRAME-NAME} = 2.
ELSE IF (txt-dif1 <= 115 AND txt-dif1 > 80) THEN
    ASSIGN txt-dif1:BGCOLOR IN FRAME {&FRAME-NAME} = 14.
ELSE ASSIGN txt-dif1:BGCOLOR IN FRAME {&FRAME-NAME} = 12.

IF (txt-dif2 > 115) THEN ASSIGN txt-dif2:BGCOLOR IN FRAME {&FRAME-NAME} = 2.
ELSE IF (txt-dif2 <= 115 AND txt-dif2 > 80) THEN
    ASSIGN txt-dif2:BGCOLOR IN FRAME {&FRAME-NAME} = 14.
ELSE ASSIGN txt-dif2:BGCOLOR IN FRAME {&FRAME-NAME} = 12.

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
    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i AS INTEGER.
    

    DEFINE VARIABLE wh AS HANDLE NO-UNDO.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* Encabezado */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "REPORTE DE ESTADISTICAS DE VENTAS". 

    iCount = iCount + 2.
    /* set the column names for the Worksheet */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Selección".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Año Actual".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Año Anterior".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Acumulado Año Actual".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Acumulado Año Anterior".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Dif. Año".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Dif. Acumulado".
    iCount = iCount + 1.

    FOR EACH w-report NO-LOCK WHERE task-no = s-task-no USE-INDEX REPO02:
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-C[1].
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[1].
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[2].
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[3].
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[4].
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[5].
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[6].
        iCount = iCount + 1.
    END.

  /* launch Excel so it is visible to the user */
  chExcelApplication:Visible = TRUE.

  /* release com-handles */
  RELEASE OBJECT chExcelApplication.      
  RELEASE OBJECT chWorkbook.
  RELEASE OBJECT chWorksheet.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */  
  DEFINE VARIABLE iInt     AS INTEGER NO-UNDO INIT 1.
  DEFINE VARIABLE iAnioIni AS INTEGER NO-UNDO.
  DO WITH FRAME {&FRAME-NAME}:
      iAnioIni = YEAR(TODAY) .
      DO iInt = 1 TO 5:
          iAnioIni = iAnioIni - 1.
          cb-anio:ADD-LAST(STRING(iAnioIni)). 
      END.  
      DO iInt = 2  TO 12:
          cb-mes:ADD-LAST(STRING(iInt)). 
      END.
      txt-top:VISIBLE  = FALSE.
      txt-dato:VISIBLE = FALSE.
      cb-mes = MONTH(TODAY).
      cb-anio = YEAR(TODAY).
  END.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Selecciona-Moneda B-table-Win 
PROCEDURE Selecciona-Moneda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iIndx AS INTEGER NO-UNDO.    
    CASE rs-moneda:
        WHEN 1 THEN DO:
            CASE cb-tipo:
                WHEN "Ventas" THEN iIndx = 1. 
                WHEN "Costos" THEN iIndx = 2. 
                WHEN "Margen" THEN iIndx = 3. 
            END CASE.
        END.
        WHEN 2 THEN DO:
            CASE cb-tipo:
                WHEN "Ventas" THEN iIndx = 11. 
                WHEN "Costos" THEN iIndx = 12. 
                WHEN "Margen" THEN iIndx = 13. 
            END CASE.
        END.
    END CASE.

    CASE cb-criterio:
        WHEN "División" OR WHEN "Cliente" OR WHEN "Familia" THEN RUN Carga-Detalle (iIndx).
        WHEN "División - Cliente" OR WHEN "División - Familia" OR WHEN "Familia - Cliente" THEN RUN Carga-Detalle2 (iIndx).
    END CASE.
    RUN Carga-Totales.
    RUN dispatch IN THIS-PROCEDURE ('open-query').
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
  {src/adm/template/snd-list.i "w-report"}

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

