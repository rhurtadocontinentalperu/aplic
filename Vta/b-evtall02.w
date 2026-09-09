&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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

DEFINE TEMP-TABLE ttevt-all02 NO-UNDO
    FIELDS ttevt-CodCia          AS INTEGER
    FIELDS ttevt-indice          AS INTEGER
    FIELDS ttevt-criterio        AS CHARACTER
    FIELDS ttevt-coddiv          LIKE evtall02.CodDiv    
    FIELDS ttevt-codcli          LIKE evtall02.codcli
    FIELDS ttevt-codunico        LIKE evtall02.codunico
    FIELDS ttevt-CodFam          LIKE EvtALL02.CodFam
    FIELDS ttevt-NroFch          LIKE EvtALL02.NroFch
    FIELDS ttevt-Moneda          AS INTEGER
    FIELDS ttevt-AmountMes       LIKE EvtALL02.VtaxMesMn EXTENT 2
    FIELDS ttevt-AmountMesAct    LIKE EvtALL02.VtaxMesMn EXTENT 3
    FIELDS ttevt-AmountMesActMe  LIKE EvtALL02.VtaxMesMn EXTENT 3
    FIELDS ttevt-AmountMesAnt    LIKE EvtALL02.VtaxMesMn EXTENT 3
    FIELDS ttevt-AmountMesAntMe  LIKE EvtALL02.VtaxMesMn EXTENT 3
    FIELDS ttevt-AmountMesVta    LIKE EvtALL02.VtaxMesMn EXTENT 2
    FIELDS ttevt-AmountMesCto    LIKE EvtALL02.VtaxMesMn EXTENT 2
    FIELDS ttevt-AmountMesMrg    LIKE EvtALL02.VtaxMesMn EXTENT 2
    FIELDS ttevt-Accumulate      AS DECIMAL EXTENT 2 FORMAT "->>,>>>,>>>,>>9.99"
    FIELDS ttevt-AccumAct        AS DECIMAL EXTENT 3 FORMAT "->>,>>>,>>>,>>9.99"
    FIELDS ttevt-AccumAnt        AS DECIMAL EXTENT 3 FORMAT "->>,>>>,>>>,>>9.99"
    FIELDS ttevt-DifMes          AS DECIMAL EXTENT 2.

DEF VAR x-month     AS INT NO-UNDO.
DEF VAR x-year      AS INT NO-UNDO.
DEF VAR x-nrofchi   AS INT NO-UNDO.
DEF VAR k           AS INT NO-UNDO.
DEF VAR x-NroFchE   AS INT NO-UNDO.
DEF VAR iFchIni     AS INT NO-UNDO.
DEF VAR iFcha       AS INT NO-UNDO.
DEF VAR iInt        AS INT NO-UNDO.

DEFINE BUFFER bevt-divi  FOR evtdivi.
DEFINE BUFFER bevt-all02 FOR evtall02.
DEFINE BUFFER bevt-line  FOR evtline.

DEFINE VARIABLE dAcummA AS DECIMAL NO-UNDO.
DEFINE VARIABLE dAcummVta AS DECIMAL NO-UNDO.
DEFINE VARIABLE dAcummCto AS DECIMAL NO-UNDO.
DEFINE VARIABLE dAcummMrg AS DECIMAL NO-UNDO.
/*
RUN Carga-Divisiones.
RUN Carga-Totales.*/

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
&Scoped-define INTERNAL-TABLES ttevt-all02

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ttevt-all02.ttevt-Criterio ttevt-all02.ttevt-AmountMes[1] ttevt-all02.ttevt-AmountMes[2] ttevt-all02.ttevt-Accumulate[1] ttevt-all02.ttevt-Accumulate[2] ttevt-all02.ttevt-DifMes[1] ttevt-all02.ttevt-DifMes[2]   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define SELF-NAME br_table
&Scoped-define QUERY-STRING-br_table FOR EACH ttevt-all02 NO-LOCK     BREAK BY ttevt-all02.ttevt-Indice
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH ttevt-all02 NO-LOCK     BREAK BY ttevt-all02.ttevt-Indice.
&Scoped-define TABLES-IN-QUERY-br_table ttevt-all02
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ttevt-all02


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

DEFINE VARIABLE cb-anio AS INTEGER FORMAT "9999":U INITIAL 2009 
     LABEL "Año" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "2009" 
     DROP-DOWN-LIST
     SIZE 9.43 BY 1 NO-UNDO.

DEFINE VARIABLE cb-criterio AS CHARACTER FORMAT "X(256)":U INITIAL "División" 
     LABEL "Seleccionar Por" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "División","Cliente","Familia","División - Cliente","División - Familia","Familia - Cliente" 
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
     SIZE 15 BY .81
     BGCOLOR 14  NO-UNDO.

DEFINE VARIABLE txt-acum2 AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14.86 BY .81
     BGCOLOR 11  NO-UNDO.

DEFINE VARIABLE txt-amount1 AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .81
     BGCOLOR 14  NO-UNDO.

DEFINE VARIABLE txt-amount2 AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .81
     BGCOLOR 11  NO-UNDO.

DEFINE VARIABLE txt-dato AS CHARACTER FORMAT "X(256)":U 
     LABEL "*Seleccione la cantidad de Clientes" 
     VIEW-AS FILL-IN 
     SIZE 1 BY .81
     FGCOLOR 7  NO-UNDO.

DEFINE VARIABLE txt-dif1 AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7.72 BY .81 NO-UNDO.

DEFINE VARIABLE txt-dif2 AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .81 NO-UNDO.

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
      ttevt-all02 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      ttevt-all02.ttevt-Criterio     COLUMN-LABEL "Selección" FORMAT "X(50)"   
    ttevt-all02.ttevt-AmountMes[1]   COLUMN-LABEL "Año Actual"   
    ttevt-all02.ttevt-AmountMes[2]   COLUMN-LABEL "Año Anterior"
    ttevt-all02.ttevt-Accumulate[1]  COLUMN-LABEL "Acumulado Año Actual"   
    ttevt-all02.ttevt-Accumulate[2]  COLUMN-LABEL "Acumulado Año Anterior"   
    ttevt-all02.ttevt-DifMes[1]      COLUMN-LABEL "Dif. Año"   
    ttevt-all02.ttevt-DifMes[2]      COLUMN-LABEL "Dif. Acumulado"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 115 BY 13.19
         FONT 4 ROW-HEIGHT-CHARS .5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cb-anio AT ROW 1.27 COL 11.57 COLON-ALIGNED WIDGET-ID 2
     cb-mes AT ROW 1.27 COL 43.43 COLON-ALIGNED WIDGET-ID 4
     btn-Ok AT ROW 1.5 COL 85 WIDGET-ID 14
     cb-criterio AT ROW 2.35 COL 11.57 COLON-ALIGNED WIDGET-ID 40
     txt-top AT ROW 2.35 COL 43.72 COLON-ALIGNED WIDGET-ID 50
     txt-dato AT ROW 2.35 COL 76 COLON-ALIGNED WIDGET-ID 56
     cb-tipo AT ROW 3.42 COL 11.72 COLON-ALIGNED WIDGET-ID 48
     rs-moneda AT ROW 3.42 COL 45.57 NO-LABEL WIDGET-ID 42
     br_table AT ROW 4.5 COL 3
     txt-amount1 AT ROW 17.96 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     txt-amount2 AT ROW 17.96 COL 50 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     txt-acum1 AT ROW 17.96 COL 62 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     txt-acum2 AT ROW 17.96 COL 78 COLON-ALIGNED NO-LABEL WIDGET-ID 68
     txt-dif1 AT ROW 17.96 COL 94 COLON-ALIGNED NO-LABEL WIDGET-ID 70
     txt-dif2 AT ROW 17.96 COL 103 COLON-ALIGNED NO-LABEL WIDGET-ID 72
     "Totales:" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 18.12 COL 33 WIDGET-ID 74
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 3.54 COL 39 WIDGET-ID 46
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
         HEIGHT             = 18
         WIDTH              = 119.
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
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-acum2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-amount1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-amount2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-dato IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN txt-dif1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-dif2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM

OPEN QUERY {&SELF-NAME} FOR EACH ttevt-all02 NO-LOCK
    BREAK BY ttevt-all02.ttevt-Indice.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
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
    IF AVAILABLE ttevt-all02 THEN DO:
        IF (ttevt-all02.ttevt-Criterio BEGINS "Total") THEN 
            ASSIGN 
                ttevt-all02.ttevt-Criterio:FONT IN BROWSE {&BROWSE-NAME} = 6.

        IF (ttevt-all02.ttevt-DifMes[1] > 115) THEN 
            ASSIGN ttevt-all02.ttevt-DifMes[1]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 2.
        ELSE IF (ttevt-all02.ttevt-DifMes[1] <= 115 AND ttevt-all02.ttevt-DifMes[1] > 80) THEN
            ASSIGN 
                ttevt-all02.ttevt-DifMes[1]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14.
        ELSE ASSIGN 
                ttevt-all02.ttevt-DifMes[1]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.

        IF (ttevt-all02.ttevt-DifMes[2] > 115) THEN 
            ASSIGN ttevt-all02.ttevt-DifMes[2]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 2.
        ELSE IF (ttevt-all02.ttevt-DifMes[2] <= 115 AND ttevt-all02.ttevt-DifMes[2] > 80) THEN
            ASSIGN 
                ttevt-all02.ttevt-DifMes[2]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14.
        ELSE ASSIGN 
                ttevt-all02.ttevt-DifMes[2]:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.        
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
    rs-moneda.
  IF txt-top > 0 THEN
      ASSIGN txt-top.
      
  CASE cb-criterio:
      WHEN "División" THEN RUN Carga-Divisiones.
      WHEN "Cliente"  THEN RUN Carga-Clientes.
      WHEN "Familia"  THEN RUN Carga-Lines.
      WHEN "División - Familia" THEN RUN Carga-Divisiones-Familia.
      WHEN "División - Cliente" THEN RUN Carga-Divisiones-Cliente.
      WHEN "Familia - Cliente"  THEN RUN Carga-Familia-Cliente. 
/*
      WHEN "Familia - Cliente" THEN DO: 
          CASE cb-tipo:
              WHEN "Ventas" THEN RUN Carga-Fam-Clie-A.
              WHEN "Costos" THEN RUN Carga-Fam-Clie-A.
              WHEN "Margen" THEN RUN Carga-Fam-Clie-A.
          END CASE.
      END.*/
  END CASE.
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
    DEFINE VARIABLE iIndx AS INTEGER NO-UNDO.
    DEFINE BUFFER bttevt FOR ttevt-all02.

    ASSIGN 
        cb-criterio
        cb-tipo.
    
    CASE cb-criterio:
        WHEN "División" THEN DO:
            CASE cb-tipo:
                WHEN "Ventas" THEN RUN Carga-Det-Div (1). 
                WHEN "Costos" THEN RUN Carga-Det-Div (2). 
                WHEN "Margen" THEN RUN Carga-Det-Div (3). 
            END CASE.
        END.
        WHEN "Cliente" THEN DO:
            CASE cb-tipo:
                WHEN "Ventas" THEN RUN Carga-Det-Clie (1). 
                WHEN "Costos" THEN RUN Carga-Det-Clie (2). 
                WHEN "Margen" THEN RUN Carga-Det-Clie (3). 
            END CASE.
        END.
        WHEN "Familia" THEN DO:
            CASE cb-tipo:
                WHEN "Ventas" THEN RUN Carga-Det-Line (1). 
                WHEN "Costos" THEN RUN Carga-Det-Line (2). 
                WHEN "Margen" THEN RUN Carga-Det-Line (3). 
            END CASE.
        END.
        WHEN "División - Cliente" THEN DO:
            CASE cb-tipo:
                WHEN "Ventas" THEN RUN Carga-Det-Div-Clie (1). 
                WHEN "Costos" THEN RUN Carga-Det-Div-Clie (2). 
                WHEN "Margen" THEN RUN Carga-Det-Div-Clie (3). 
            END CASE.
        END.
        WHEN "División - Familia" THEN DO:
            CASE cb-tipo:
                WHEN "Ventas" THEN RUN Carga-Det-Div-Line (1). 
                WHEN "Costos" THEN RUN Carga-Det-Div-Line (2). 
                WHEN "Margen" THEN RUN Carga-Det-Div-Line (3). 
            END CASE.
        END.
        WHEN "Familia - Cliente" THEN DO:
            CASE cb-tipo:
                WHEN "Ventas" THEN RUN Carga-Det-Fam-Clie (1). 
                WHEN "Costos" THEN RUN Carga-Det-Fam-Clie (2). 
                WHEN "Margen" THEN RUN Carga-Det-Fam-Clie (3). 
            END CASE.
        END.
    END CASE.

    RUN Carga-Totales.
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
FOR EACH ttevt-all02:
    DELETE ttevt-all02.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Clie-Ax B-table-Win 
PROCEDURE Carga-Clie-Ax :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dAcum  AS DECIMAL EXTENT 2 NO-UNDO.    
    DEFINE VARIABLE cName  LIKE gn-clie.NomCli NO-UNDO.
    DEFINE VARIABLE iCount AS INTEGER NO-UNDO.    
    DEFINE VARIABLE dSuma  AS DECIMAL EXTENT 4 NO-UNDO.
    DEFINE BUFFER bttevt FOR ttevt-all02.
    
    RUN Borra-Temporal.
    
    iInt    = 0.
    iCount  = 0.
    x-NroFchI = (cb-anio * 100) + cb-mes.
    Clientes:
    FOR EACH evtall03 
        WHERE evtall03.Codcia = s-codcia :        
        
        FIND FIRST gn-clie WHERE gn-clie.CodCia = cl-CodCia 
            AND gn-clie.CodCli = evtall03.CodUnico NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN cName = gn-clie.NomCli. ELSE cName = "".

        IF iCount < txt-top THEN DO:
            FOR EACH evtall02 NO-LOCK
                WHERE evtall02.CodCia = evtall03.CodCia
                AND evtall02.CodUnico = evtall03.CodUnico
                AND evtall02.NroFch   = x-NroFchI:                
                iInt =  iInt + 1.
                FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodCia = evtall02.CodCia
                    AND ttevt-all02.ttevt-CodUnico = evtall02.CodUnico NO-LOCK NO-ERROR.       
                IF NOT AVAILABLE ttevt-all02 THEN DO:
                    iCount = iCount + 1.
                    CREATE ttevt-all02.
                    ASSIGN
                        ttevt-all02.ttevt-CodCia   = evtall02.Codcia
                        ttevt-all02.ttevt-Indice   = iInt
                        ttevt-all02.ttevt-CodUnico = evtall02.CodUnico
                        ttevt-all02.ttevt-Criterio = evtall02.CodUnico + " - " + cName.
                END.
                CASE rs-moneda:
                    WHEN 1 THEN DO:
                        ASSIGN 
                            ttevt-all02.ttevt-AmountMesAct[1] = ttevt-all02.ttevt-AmountMesAct[1] + evtall02.VtaxMesMn
                            ttevt-all02.ttevt-AmountMesAct[2] = ttevt-all02.ttevt-AmountMesAct[2] + evtall02.CtoxMesMn
                            ttevt-all02.ttevt-AmountMesAct[3] = ttevt-all02.ttevt-AmountMesAct[3] + (evtall02.VtaxMesMn - evtall02.CtoxMesMn).
                        
                    END.
                    WHEN 2 THEN DO:
                        ASSIGN 
                            ttevt-all02.ttevt-AmountMesAct[1] = ttevt-all02.ttevt-AmountMesAct[1] + evtall02.VtaxMesMe
                            ttevt-all02.ttevt-AmountMesAct[2] = ttevt-all02.ttevt-AmountMesAct[2] + evtall02.CtoxMesMe
                            ttevt-all02.ttevt-AmountMesAct[3] = ttevt-all02.ttevt-AmountMesAct[3] + (evtall02.VtaxMesMe - evtall02.CtoxMesMe). 
                    END.
                END CASE.     
                DISPLAY
                    'Espere un momento por favor...' SKIP
                    'Procesando Información para Cliente: ' evtall03.CodUnico NO-LABEL
                    WITH FRAME F-Mensaje TITLE 'Procesando informacion' CENTERED OVERLAY VIEW-AS DIALOG-BOX.                                                
            END.
        END.    
        ELSE LEAVE Clientes.
    END.

    /*Calcula monto años anteriores*/
    x-NroFchI = ((cb-anio - 1) * 100) + cb-mes.        
    FOR EACH ttevt-all02 WHERE ttevt-all02.ttevt-CodCia = s-codcia NO-LOCK 
        BREAK BY ttevt-all02.ttevt-CodUnico:
        FOR EACH evtall02 WHERE evtall02.Codcia = ttevt-all02.ttevt-CodCia
            AND evtall02.CodUnico = ttevt-all02.ttevt-CodUnico
            AND evtall02.NroFch = x-NroFchI NO-LOCK:
            CASE rs-moneda:
                WHEN 1 THEN DO:
                    ASSIGN 
                        dSuma[1] = dSuma[1] + evtall02.VtaxMesMn
                        dSuma[2] = dSuma[2] + evtall02.CtoxMesMn
                        dSuma[3] = dSuma[3] + (evtall02.VtaxMesMn - evtall02.CtoxMesMn).
                END.
                WHEN 2 THEN DO:
                    ASSIGN 
                        dSuma[1] = dSuma[1] + evtall02.VtaxMesMe
                        dSuma[2] = dSuma[2] + evtall02.CtoxMesMe
                        dSuma[3] = dSuma[3] + (evtall02.VtaxMesMe - evtall02.CtoxMesMe).
                END.
            END CASE.                
        END.
        FOR FIRST bttevt WHERE bttevt.ttevt-CodCia = ttevt-all02.ttevt-CodCia 
            AND bttevt.ttevt-CodUnico = ttevt-all02.ttevt-CodUnico NO-LOCK:
            ASSIGN 
                bttevt.ttevt-AmountMesAnt[1] = dSuma[1]
                bttevt.ttevt-AmountMesAnt[2] = dSuma[2]
                bttevt.ttevt-AmountMesAnt[3] = dSuma[3].
            dSuma[1] = 0.
            dSuma[2] = 0.
            dSuma[3] = 0.
        END.
    END.
   
    /*Calcula acumulados*/
    FOR EACH ttevt-all02:
        DO k = cb-anio - 1 TO cb-anio:
            x-Month = cb-mes.
            iFcha = k * 100 + 1. 
            x-NroFchE = k * 100 + x-Month.
            dAcummA = 0.
            dAcummVta = 0.
            dAcummCto = 0.
            dAcummMrg = 0.
            FOR EACH evtall02 NO-LOCK 
                WHERE evtall02.CodCia = ttevt-all02.ttevt-CodCia
                AND evtall02.CodUnico = ttevt-all02.ttevt-CodUnico
                AND evtall02.NroFch >= iFcha
                AND evtall02.NroFch <= x-NroFchE
                BREAK BY evtall02.CodUnico:
                CASE rs-moneda:
                    WHEN 1 THEN DO: 
                        dAcummVta = dAcummVta + evtall02.VtaxMesMn.
                        dAcummCto = dAcummCto + evtall02.CtoxMesMn.
                        dAcummMrg = dAcummMrg + (evtall02.VtaxMesMn - evtall02.CtoxMesMn).                        
                    END.
                    WHEN 2 THEN DO: 
                        dAcummVta = dAcummVta + evtall02.VtaxMesMe.
                        dAcummCto = dAcummCto + evtall02.CtoxMesMe.
                        dAcummMrg = dAcummMrg + (evtall02.VtaxMesMe - evtall02.CtoxMesMe).
                    END.
                END CASE.
            END. 

            FIND FIRST bttevt WHERE ROWID(bttevt) = ROWID(ttevt-all02) EXCLUSIVE-LOCK.
            IF AVAILABLE bttevt THEN DO:                
                IF k = (cb-anio) THEN DO: 
                    ASSIGN 
                        bttevt.ttevt-AccumAct[1] = dAcummVta
                        bttevt.ttevt-AccumAct[2] = dAcummCto
                        bttevt.ttevt-AccumAct[3] = dAcummMrg.
                END.
                IF k = (cb-anio - 1) THEN DO: 
                    ASSIGN 
                        bttevt.ttevt-AccumAnt[1] = dAcummVta
                        bttevt.ttevt-AccumAnt[2] = dAcummCto
                        bttevt.ttevt-AccumAnt[3] = dAcummMrg.
                END.
            END.
        END. /*Do...*/
    END. /*For Each..*/
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
    
    RUN Carga-Clie-Ax.
    CASE cb-tipo:
        WHEN "Ventas" THEN iIndx = 1. 
        WHEN "Costos" THEN iIndx = 2. 
        WHEN "Margen" THEN iIndx = 3. 
    END CASE.
    RUN Carga-Det-Clie (iIndx).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Det-Clie B-table-Win 
PROCEDURE Carga-Det-Clie :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER iIndice AS INTEGER NO-UNDO.
    DEFINE BUFFER bttevt FOR ttevt-all02.

    FOR EACH ttevt-all02 WHERE ttevt-all02.ttevt-Codcia = s-CodCia NO-LOCK:
        FOR FIRST bttevt WHERE bttevt.ttevt-CodCia = ttevt-all02.ttevt-Codcia 
            AND bttevt.ttevt-CodUnico = ttevt-all02.ttevt-CodUnico EXCLUSIVE-LOCK.
            ASSIGN
                bttevt.ttevt-AmountMes[1]  = ttevt-all02.ttevt-AmountMesAct[iIndice]
                bttevt.ttevt-AmountMes[2]  = ttevt-all02.ttevt-AmountMesAnt[iIndice]
                bttevt.ttevt-Accumulate[1] = ttevt-all02.ttevt-AccumAct[iIndice]
                bttevt.ttevt-Accumulate[2] = ttevt-all02.ttevt-AccumAnt[iIndice].
            /*Calcula porcentajes*/
            IF ttevt-all02.ttevt-AmountMes[2] <> 0 THEN
                bttevt.ttevt-DifMes[1] = (ttevt-all02.ttevt-AmountMes[1] / ttevt-all02.ttevt-AmountMes[2] * 100).
            ELSE bttevt.ttevt-DifMes[1] = 100.
            IF ttevt-all02.ttevt-Accumulate[2] <> 0 THEN
                bttevt.ttevt-DifMes[2] = (ttevt-all02.ttevt-Accumulate[1] / ttevt-all02.ttevt-Accumulate[2] * 100).
            ELSE bttevt.ttevt-DifMes[2] = 100.
        END.
    END.
    RUN dispatch IN THIS-PROCEDURE ('open-query').


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Det-Div B-table-Win 
PROCEDURE Carga-Det-Div :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER iIndice AS INTEGER NO-UNDO.
    DEFINE BUFFER bttevt FOR ttevt-all02.

    FOR EACH ttevt-all02 WHERE ttevt-all02.ttevt-Codcia = s-CodCia NO-LOCK
        BREAK BY ttevt-all02.ttevt-CodDiv:
        FOR FIRST bttevt WHERE bttevt.ttevt-CodCia = ttevt-all02.ttevt-Codcia 
            AND bttevt.ttevt-CodDiv = ttevt-all02.ttevt-CodDiv EXCLUSIVE-LOCK:            
            ASSIGN
                bttevt.ttevt-AmountMes[1]  = ttevt-all02.ttevt-AmountMesAct[iIndice]
                bttevt.ttevt-AmountMes[2]  = ttevt-all02.ttevt-AmountMesAnt[iIndice]
                bttevt.ttevt-Accumulate[1] = ttevt-all02.ttevt-AccumAct[iIndice]
                bttevt.ttevt-Accumulate[2] = ttevt-all02.ttevt-AccumAnt[iIndice].
            /*Calcula porcentajes*/
            IF ttevt-all02.ttevt-AmountMes[2] <> 0 THEN
                bttevt.ttevt-DifMes[1] = (ttevt-all02.ttevt-AmountMes[1] / ttevt-all02.ttevt-AmountMes[2] * 100).
            ELSE bttevt.ttevt-DifMes[1] = 100.
            IF ttevt-all02.ttevt-Accumulate[2] <> 0 THEN
                bttevt.ttevt-DifMes[2] = (ttevt-all02.ttevt-Accumulate[1] / ttevt-all02.ttevt-Accumulate[2] * 100).
            ELSE bttevt.ttevt-DifMes[2] = 100.
        END.
    END.
    RUN adm-open-query.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Det-Div-Clie B-table-Win 
PROCEDURE Carga-Det-Div-Clie :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER iIndice AS INTEGER NO-UNDO.
    DEFINE BUFFER bttevt FOR ttevt-all02.
    DEFINE VARIABLE dSuma AS DECIMAL EXTENT 4 NO-UNDO.

    FOR EACH ttevt-all02 WHERE ttevt-all02.ttevt-Codcia = s-CodCia NO-LOCK 
        BREAK BY ttevt-all02.ttevt-CodDiv:
        FOR FIRST bttevt WHERE bttevt.ttevt-CodCia = ttevt-all02.ttevt-Codcia 
            AND bttevt.ttevt-CodDiv = ttevt-all02.ttevt-CodDiv 
            AND bttevt.ttevt-CodUnico = ttevt-all02.ttevt-CodUnico EXCLUSIVE-LOCK.
            ASSIGN
                bttevt.ttevt-AmountMes[1]  = ttevt-all02.ttevt-AmountMesAct[iIndice]
                bttevt.ttevt-AmountMes[2]  = ttevt-all02.ttevt-AmountMesAnt[iIndice]
                bttevt.ttevt-Accumulate[1] = ttevt-all02.ttevt-AccumAct[iIndice]
                bttevt.ttevt-Accumulate[2] = ttevt-all02.ttevt-AccumAnt[iIndice].
            /*Calcula porcentajes*/
            IF ttevt-all02.ttevt-AmountMes[2] <> 0 THEN
                bttevt.ttevt-DifMes[1] = (ttevt-all02.ttevt-AmountMes[1] / ttevt-all02.ttevt-AmountMes[2] * 100).
            ELSE bttevt.ttevt-DifMes[1] = 100.
            IF ttevt-all02.ttevt-Accumulate[2] <> 0 THEN
                bttevt.ttevt-DifMes[2] = (ttevt-all02.ttevt-Accumulate[1] / ttevt-all02.ttevt-Accumulate[2] * 100).
            ELSE bttevt.ttevt-DifMes[2] = 100.
            dSuma[1] = dSuma[1] + bttevt.ttevt-AmountMes[1].
            dSuma[2] = dSuma[2] + bttevt.ttevt-AmountMes[2].
            dSuma[3] = dSuma[3] + bttevt.ttevt-Accumulate[1].
            dSuma[4] = dSuma[4] + bttevt.ttevt-Accumulate[2].
        END.
        IF LAST-OF(ttevt-all02.ttevt-CodDiv) AND ttevt-all02.ttevt-CodUnico = "XXX" THEN DO:
            ASSIGN
                ttevt-all02.ttevt-AmountMes[1]  = dSuma[1]
                ttevt-all02.ttevt-AmountMes[2]  = dSuma[2]
                ttevt-all02.ttevt-Accumulate[1] = dSuma[3]
                ttevt-all02.ttevt-Accumulate[2] = dSuma[4].
            /*Calcula porcentajes*/
            IF ttevt-all02.ttevt-AmountMes[2] <> 0 THEN
                ttevt-all02.ttevt-DifMes[1] = (ttevt-all02.ttevt-AmountMes[1] / ttevt-all02.ttevt-AmountMes[2] * 100).
            ELSE ttevt-all02.ttevt-DifMes[1] = 100.
            IF ttevt-all02.ttevt-Accumulate[2] <> 0 THEN
                ttevt-all02.ttevt-DifMes[2] = (ttevt-all02.ttevt-Accumulate[1] / ttevt-all02.ttevt-Accumulate[2] * 100).
            ELSE ttevt-all02.ttevt-DifMes[2] = 100.
            dSuma[1] = 0.
            dSuma[2] = 0.
            dSuma[3] = 0.
            dSuma[4] = 0.
        END.
    END.
    RUN adm-open-query.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Det-Div-Line B-table-Win 
PROCEDURE Carga-Det-Div-Line :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER iIndice AS INTEGER NO-UNDO.
    DEFINE BUFFER bttevt FOR ttevt-all02.
    DEFINE VARIABLE dSuma AS DECIMAL EXTENT 4 NO-UNDO.

    FOR EACH ttevt-all02 WHERE ttevt-all02.ttevt-Codcia = s-CodCia NO-LOCK 
        BREAK BY ttevt-all02.ttevt-CodDiv
            BY ttevt-all02.ttevt-CodFam:
        FOR FIRST bttevt WHERE bttevt.ttevt-CodCia = ttevt-all02.ttevt-Codcia 
            AND bttevt.ttevt-CodDiv = ttevt-all02.ttevt-CodDiv 
            AND bttevt.ttevt-CodFam = ttevt-all02.ttevt-CodFam EXCLUSIVE-LOCK.
            ASSIGN
                bttevt.ttevt-AmountMes[1]  = ttevt-all02.ttevt-AmountMesAct[iIndice]
                bttevt.ttevt-AmountMes[2]  = ttevt-all02.ttevt-AmountMesAnt[iIndice]
                bttevt.ttevt-Accumulate[1] = ttevt-all02.ttevt-AccumAct[iIndice]
                bttevt.ttevt-Accumulate[2] = ttevt-all02.ttevt-AccumAnt[iIndice].

            /*Calcula porcentajes*/
            IF ttevt-all02.ttevt-AmountMes[2] <> 0 THEN
                bttevt.ttevt-DifMes[1] = (ttevt-all02.ttevt-AmountMes[1] / ttevt-all02.ttevt-AmountMes[2] * 100).
            ELSE bttevt.ttevt-DifMes[1] = 100.
            IF ttevt-all02.ttevt-Accumulate[2] <> 0 THEN
                bttevt.ttevt-DifMes[2] = (ttevt-all02.ttevt-Accumulate[1] / ttevt-all02.ttevt-Accumulate[2] * 100).
            ELSE bttevt.ttevt-DifMes[2] = 100.
            dSuma[1] = dSuma[1] + bttevt.ttevt-AmountMes[1].
            dSuma[2] = dSuma[2] + bttevt.ttevt-AmountMes[2].
            dSuma[3] = dSuma[3] + bttevt.ttevt-Accumulate[1].
            dSuma[4] = dSuma[4] + bttevt.ttevt-Accumulate[2].
        END.
        IF LAST-OF(ttevt-all02.ttevt-CodDiv) AND ttevt-all02.ttevt-CodFam = "XXX" THEN DO:
            ASSIGN
                ttevt-all02.ttevt-AmountMes[1]  = dSuma[1]
                ttevt-all02.ttevt-AmountMes[2]  = dSuma[2]
                ttevt-all02.ttevt-Accumulate[1] = dSuma[3]
                ttevt-all02.ttevt-Accumulate[2] = dSuma[4].
            /*Calcula porcentajes*/
            IF ttevt-all02.ttevt-AmountMes[2] <> 0 THEN
                ttevt-all02.ttevt-DifMes[1] = (ttevt-all02.ttevt-AmountMes[1] / ttevt-all02.ttevt-AmountMes[2] * 100).
            ELSE ttevt-all02.ttevt-DifMes[1] = 100.
            IF ttevt-all02.ttevt-Accumulate[2] <> 0 THEN
                ttevt-all02.ttevt-DifMes[2] = (ttevt-all02.ttevt-Accumulate[1] / ttevt-all02.ttevt-Accumulate[2] * 100).
            ELSE ttevt-all02.ttevt-DifMes[2] = 100.
            dSuma[1] = 0.
            dSuma[2] = 0.
            dSuma[3] = 0.
            dSuma[4] = 0.
        END.
    END.
    RUN adm-open-query.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Det-Fam-Clie B-table-Win 
PROCEDURE Carga-Det-Fam-Clie :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER iIndice AS INTEGER NO-UNDO.
    DEFINE BUFFER bttevt FOR ttevt-all02.
    DEFINE VARIABLE dSuma AS DECIMAL EXTENT 4 NO-UNDO.
    
    FOR EACH ttevt-all02 WHERE ttevt-all02.ttevt-Codcia = s-CodCia NO-LOCK 
        BREAK BY ttevt-all02.ttevt-CodFam:
        FOR FIRST bttevt WHERE bttevt.ttevt-CodCia = ttevt-all02.ttevt-Codcia 
            AND bttevt.ttevt-CodFam = ttevt-all02.ttevt-CodFam 
            AND bttevt.ttevt-CodUnico = ttevt-all02.ttevt-CodUnico EXCLUSIVE-LOCK.
            ASSIGN
                bttevt.ttevt-AmountMes[1]  = ttevt-all02.ttevt-AmountMesAct[iIndice]
                bttevt.ttevt-AmountMes[2]  = ttevt-all02.ttevt-AmountMesAnt[iIndice]
                bttevt.ttevt-Accumulate[1] = ttevt-all02.ttevt-AccumAct[iIndice]
                bttevt.ttevt-Accumulate[2] = ttevt-all02.ttevt-AccumAnt[iIndice].
            /*Calcula porcentajes*/
            IF ttevt-all02.ttevt-AmountMes[2] <> 0 THEN
                bttevt.ttevt-DifMes[1] = (ttevt-all02.ttevt-AmountMes[1] / ttevt-all02.ttevt-AmountMes[2] * 100).
            ELSE bttevt.ttevt-DifMes[1] = 100.
            IF ttevt-all02.ttevt-Accumulate[2] <> 0 THEN
                bttevt.ttevt-DifMes[2] = (ttevt-all02.ttevt-Accumulate[1] / ttevt-all02.ttevt-Accumulate[2] * 100).
            ELSE bttevt.ttevt-DifMes[2] = 100.
            dSuma[1] = dSuma[1] + bttevt.ttevt-AmountMes[1].
            dSuma[2] = dSuma[2] + bttevt.ttevt-AmountMes[2].
            dSuma[3] = dSuma[3] + bttevt.ttevt-Accumulate[1].
            dSuma[4] = dSuma[4] + bttevt.ttevt-Accumulate[2].
        END.
        IF LAST-OF(ttevt-all02.ttevt-CodFam) AND ttevt-all02.ttevt-CodUnico = "XXX" THEN DO:
            ASSIGN
                ttevt-all02.ttevt-AmountMes[1]  = dSuma[1]
                ttevt-all02.ttevt-AmountMes[2]  = dSuma[2]
                ttevt-all02.ttevt-Accumulate[1] = dSuma[3]
                ttevt-all02.ttevt-Accumulate[2] = dSuma[4].
            /*Calcula porcentajes*/
            IF ttevt-all02.ttevt-AmountMes[2] <> 0 THEN
                ttevt-all02.ttevt-DifMes[1] = (ttevt-all02.ttevt-AmountMes[1] / ttevt-all02.ttevt-AmountMes[2] * 100).
            ELSE ttevt-all02.ttevt-DifMes[1] = 100.
            IF ttevt-all02.ttevt-Accumulate[2] <> 0 THEN
                ttevt-all02.ttevt-DifMes[2] = (ttevt-all02.ttevt-Accumulate[1] / ttevt-all02.ttevt-Accumulate[2] * 100).
            ELSE ttevt-all02.ttevt-DifMes[2] = 100.
            dSuma[1] = 0.
            dSuma[2] = 0.
            dSuma[3] = 0.
            dSuma[4] = 0.
        END.
    END.
    RUN adm-open-query.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Det-Line B-table-Win 
PROCEDURE Carga-Det-Line :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER iIndice AS INTEGER NO-UNDO.
    DEFINE BUFFER bttevt FOR ttevt-all02.

    FOR EACH ttevt-all02 WHERE ttevt-all02.ttevt-Codcia = s-CodCia NO-LOCK
        BREAK BY ttevt-all02.ttevt-CodFam:
        FOR FIRST bttevt WHERE ROWID(bttevt) = ROWID(ttevt-all02) EXCLUSIVE-LOCK:
        /*
        FOR FIRST bttevt WHERE bttevt.ttevt-CodCia = ttevt-all02.ttevt-Codcia 
            AND bttevt.ttevt-CodFam = ttevt-all02.ttevt-CodDiv EXCLUSIVE-LOCK:            */
            ASSIGN
                bttevt.ttevt-AmountMes[1]  = ttevt-all02.ttevt-AmountMesAct[iIndice]
                bttevt.ttevt-AmountMes[2]  = ttevt-all02.ttevt-AmountMesAnt[iIndice]
                bttevt.ttevt-Accumulate[1] = ttevt-all02.ttevt-AccumAct[iIndice]
                bttevt.ttevt-Accumulate[2] = ttevt-all02.ttevt-AccumAnt[iIndice].
            /*Calcula porcentajes*/
            IF ttevt-all02.ttevt-AmountMes[2] <> 0 THEN
                bttevt.ttevt-DifMes[1] = (ttevt-all02.ttevt-AmountMes[1] / ttevt-all02.ttevt-AmountMes[2] * 100).
            ELSE bttevt.ttevt-DifMes[1] = 100.
            IF ttevt-all02.ttevt-Accumulate[2] <> 0 THEN
                bttevt.ttevt-DifMes[2] = (ttevt-all02.ttevt-Accumulate[1] / ttevt-all02.ttevt-Accumulate[2] * 100).
            ELSE bttevt.ttevt-DifMes[2] = 100.
        END.
    END.
    RUN adm-open-query.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Div-Clie-X B-table-Win 
PROCEDURE Carga-Div-Clie-X :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dAcum AS DECIMAL EXTENT 2 NO-UNDO.    
    DEFINE VARIABLE cName LIKE gn-clie.NomCli NO-UNDO.
    DEFINE VARIABLE dTotDivDet AS DECIMAL EXTENT 2 NO-UNDO.
    DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
    DEFINE VARIABLE lValue AS LOGICAL NO-UNDO.
    DEFINE VARIABLE dSuma AS DECIMAL EXTENT 4 NO-UNDO.

    DEFINE BUFFER bttevt  FOR ttevt-all02.

    RUN Borra-Temporal.

    /*Calculando Saldos Año Actual*/
    x-NroFchI = cb-anio * 100 + cb-mes.
    FOR EACH gn-divi NO-LOCK
        WHERE gn-divi.CodCia = s-CodCia 
        BREAK BY gn-divi.CodDiv:
        lValue = FALSE.
        iCount = 0.        

        Clientes:
        FOR EACH evtall03 WHERE evtall03.CodCia = s-codcia NO-LOCK:
            FIND FIRST gn-clie WHERE gn-clie.CodCia = cl-CodCia 
                AND gn-clie.CodCli = evtall03.CodUnico NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clie THEN cName = gn-clie.NomCli. ELSE cName = "".

            dTotDivDet[1] = 0.
            FOR EACH evtall02 NO-LOCK WHERE evtall02.CodCia = evtall03.CodCia
                AND evtall02.CodUnico = evtall03.CodUnico
                AND evtaLL02.CodDiv   = gn-div.CodDiv
                AND evtall02.NroFch   = x-NroFchI USE-INDEX Indice02:
               
                FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodCia = evtall02.CodCia
                    AND ttevt-all02.ttevt-CodDiv = evtall02.CodDiv
                    AND ttevt-all02.ttevt-CodUnico = evtall02.CodUnico NO-LOCK NO-ERROR.
                
                IF NOT AVAILABLE ttevt-all02 THEN DO:
                    iCount = iCount + 1.
                    lValue = TRUE.
                    CREATE ttevt-all02.
                    ASSIGN
                        ttevt-all02.ttevt-CodCia   = evtall02.Codcia
                        ttevt-all02.ttevt-Indice   = iInt
                        ttevt-all02.ttevt-CodDiv   = evtall02.CodDiv
                        ttevt-all02.ttevt-CodUnico = evtall02.CodUnico
                        ttevt-all02.ttevt-Criterio = evtall02.CodUnico + " - " + cName.
                END.
                CASE rs-moneda:
                    WHEN 1 THEN DO: 
                        ASSIGN 
                            ttevt-all02.ttevt-AmountMesAct[1] = ttevt-all02.ttevt-AmountMesAct[1] + evtall02.VtaxMesMn
                            ttevt-all02.ttevt-AmountMesAct[2] = ttevt-all02.ttevt-AmountMesAct[2] + evtall02.CtoxMesMn
                            ttevt-all02.ttevt-AmountMesAct[3] = ttevt-all02.ttevt-AmountMesAct[3] + (evtall02.VtaxMesMn - evtall02.CtoxMesMn).
                    END.
                    WHEN 2 THEN DO: 
                        ASSIGN 
                            ttevt-all02.ttevt-AmountMesAct[1] = ttevt-all02.ttevt-AmountMesAct[1] + evtall02.VtaxMesMe
                            ttevt-all02.ttevt-AmountMesAct[2] = ttevt-all02.ttevt-AmountMesAct[2] + evtall02.CtoxMesMe
                            ttevt-all02.ttevt-AmountMesAct[3] = ttevt-all02.ttevt-AmountMesAct[3] + (evtall02.VtaxMesMe - evtall02.CtoxMesMe). 
                    END.
                END CASE.     

                DISPLAY
                    'Espere un momento por favor...' SKIP
                    'Procesando Información para División: ' gn-div.CodDiv NO-LABEL
                    WITH FRAME F-Mensaje TITLE 'Procesando informacion' CENTERED OVERLAY VIEW-AS DIALOG-BOX.
            END. /*For Each evtall02...*/
            IF iCount >= txt-top THEN LEAVE Clientes.

        END.  /*For evtall03...*/        

        IF LAST-OF(gn-divi.CodDiv) AND lValue THEN DO:
            FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodCia = gn-divi.CodCia
                AND ttevt-all02.ttevt-CodDiv = gn-divi.CodDiv
                AND ttevt-all02.ttevt-CodUnico = "XXX" NO-LOCK NO-ERROR.
            IF AVAILABLE ttevt-all02 THEN NEXT.
            iInt = iInt + 1.
            CREATE ttevt-all02.
            ASSIGN
                ttevt-all02.ttevt-CodCia = s-Codcia
                ttevt-all02.ttevt-Indice = iInt
                ttevt-all02.ttevt-Criterio = "Total División " + gn-divi.CodDiv + "-" + gn-divi.DesDiv + ":"
                ttevt-all02.ttevt-CodDiv   = gn-divi.CodDiv
                ttevt-all02.ttevt-CodUnico = "XXX". 
        END.
    END. /*Gn-Divi...*/
    
    /*Calculando Saldos Años Anteriores*/
    x-NroFchI = (cb-anio - 1) * 100 + cb-mes.
    
    FOR EACH ttevt-all02 NO-LOCK 
        BREAK BY ttevt-all02.ttevt-CodDiv:
        dSuma = 0.
        FOR EACH evtall02 WHERE evtall02.CodCia = ttevt-all02.ttevt-CodCia
            AND evtall02.NroFch   = x-NroFchI
            AND evtall02.CodDiv   = ttevt-all02.ttevt-CodDiv
            AND evtall02.CodUnico = ttevt-all02.ttevt-CodUnico
            USE-INDEX Indice02 NO-LOCK:
            CASE rs-moneda:
                WHEN 1 THEN DO:
                    ASSIGN 
                        dSuma[1] = dSuma[1] + evtall02.VtaxMesMn
                        dSuma[2] = dSuma[2] + evtall02.CtoxMesMn
                        dSuma[3] = dSuma[3] + (evtall02.VtaxMesMn - evtall02.CtoxMesMn).
                END.
                WHEN 2 THEN DO:
                    ASSIGN 
                        dSuma[1] = dSuma[1] + evtall02.VtaxMesMe
                        dSuma[2] = dSuma[2] + evtall02.CtoxMesMe
                        dSuma[3] = dSuma[3] + (evtall02.VtaxMesMe - evtall02.CtoxMesMe).
                END.
            END CASE.            
        END.
        FIND FIRST bttevt WHERE bttevt.ttevt-CodCia = ttevt-all02.ttevt-CodCia
            AND bttevt.ttevt-CodDiv   = ttevt-all02.ttevt-CodDiv
            AND bttevt.ttevt-CodUnico = ttevt-all02.ttevt-CodUnico NO-LOCK NO-ERROR.
        IF AVAILABLE bttevt THEN DO:            
            ASSIGN 
                bttevt.ttevt-AmountMesAnt[1] = dSuma[1]
                bttevt.ttevt-AmountMesAnt[2] = dSuma[2]
                bttevt.ttevt-AmountMesAnt[3] = dSuma[3].
        END.
    END.

    /*Calcula acumulados*/
    FOR EACH ttevt-all02 NO-LOCK
        BREAK BY ttevt-all02.ttevt-CodDiv:        
        DO k = cb-anio - 1 TO cb-anio:
            x-Month = cb-mes.
            iFcha = k * 100 + 1. 
            x-NroFchE = k * 100 + x-Month.
            dAcummA = 0.
            dAcummVta = 0.
            dAcummCto = 0.
            dAcummMrg = 0.

            FOR EACH evtall02 NO-LOCK 
                WHERE evtall02.CodCia = ttevt-all02.ttevt-CodCia
                AND evtall02.CodDiv   = ttevt-all02.ttevt-CodDiv
                AND evtall02.CodUnico = ttevt-all02.ttevt-CodUnico
                AND evtall02.NroFch >= iFcha
                AND evtall02.NroFch <= x-NroFchE
                USE-INDEX Indice02:
                CASE rs-moneda:
                    WHEN 1 THEN DO: 
                        dAcummVta = dAcummVta + evtall02.VtaxMesMn.
                        dAcummCto = dAcummCto + evtall02.CtoxMesMn.
                        dAcummMrg = dAcummMrg + (evtall02.VtaxMesMn - evtall02.CtoxMesMn). 
                    END.
                    WHEN 2 THEN DO: 
                        dAcummVta = dAcummVta + evtall02.VtaxMesMe.
                        dAcummCto = dAcummCto + evtall02.CtoxMesMe.
                        dAcummMrg = dAcummMrg + (evtall02.VtaxMesMe - evtall02.CtoxMesMe). 
                    END.
                END CASE.
            END.  
            FIND FIRST bttevt WHERE ROWID(bttevt) = ROWID(ttevt-all02) EXCLUSIVE-LOCK.
            IF AVAILABLE bttevt THEN DO:
                IF k = (cb-anio) THEN DO: 
                    ASSIGN 
                        bttevt.ttevt-AccumAct[1] = dAcummVta
                        bttevt.ttevt-AccumAct[2] = dAcummCto
                        bttevt.ttevt-AccumAct[3] = dAcummMrg.
                END.
                IF k = (cb-anio - 1) THEN DO: 
                    ASSIGN 
                        bttevt.ttevt-AccumAnt[1] = dAcummVta
                        bttevt.ttevt-AccumAnt[2] = dAcummCto
                        bttevt.ttevt-AccumAnt[3] = dAcummMrg.
                END.
            END.   
        END.
    END.
    HIDE FRAME f-Mensaje.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Div-Fam-A B-table-Win 
PROCEDURE Carga-Div-Fam-A :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dAcum     AS DECIMAL EXTENT 2 NO-UNDO.    
    DEFINE VARIABLE cName     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dTotalDiv AS DECIMAL EXTENT 2 NO-UNDO.
    DEFINE VARIABLE lValue    AS LOGICAL INIT NO  NO-UNDO.
    DEFINE VARIABLE dSuma     AS DECIMAL EXTENT 4 NO-UNDO.
    DEFINE BUFFER bttevt      FOR ttevt-all02.
    
    RUN Borra-Temporal.
    
    x-NroFchI = (cb-anio * 100) + cb-mes.
    iInt = 0.
    FOR EACH gn-divi NO-LOCK 
        WHERE gn-divi.CodCia = s-CodCia
        BREAK BY gn-divi.CodDiv:
        lValue = NO.                    
        FOR EACH evtLine NO-LOCK
            WHERE evtLine.CodCia = gn-divi.CodCia
            AND evtLine.CodDiv   = gn-divi.CodDiv
            AND evtLine.NroFch   = x-NroFchI
            BREAK BY evtline.CodFam:
            lValue = YES.
        
            FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodCia = evtLine.CodCia
                AND ttevt-all02.ttevt-CodDiv = evtLine.CodDiv
                AND ttevt-all02.ttevt-CodFam = evtLine.CodFam NO-LOCK NO-ERROR.

            FIND FIRST AlmtFami WHERE AlmtFami.CodCia = evtLine.CodCia 
                AND AlmtFami.CodFam = evtLine.CodFam NO-LOCK NO-ERROR.
            IF AVAIL AlmtFami THEN cName = AlmtFami.DesFam.
            ELSE cName = "".
    
            IF NOT AVAILABLE ttevt-all02 THEN DO:
                iInt = iInt + 1.
                CREATE ttevt-all02.
                ASSIGN
                    ttevt-all02.ttevt-CodCia   = evtLine.CodCia
                    ttevt-all02.ttevt-Indice   = iInt
                    ttevt-all02.ttevt-CodDiv   = gn-divi.CodDiv
                    ttevt-all02.ttevt-CodFam   = evtLine.CodFam
                    ttevt-all02.ttevt-Criterio = gn-divi.CodDiv + " - " + 
                        evtLine.CodFam + " - " + cName.
            END.
            CASE rs-moneda:
                WHEN 1 THEN DO:
                    ASSIGN 
                        ttevt-all02.ttevt-AmountMesAct[1] = ttevt-all02.ttevt-AmountMesAct[1] + evtLine.VtaxMesMn
                        ttevt-all02.ttevt-AmountMesAct[2] = ttevt-all02.ttevt-AmountMesAct[2] + evtLine.CtoxMesMn
                        ttevt-all02.ttevt-AmountMesAct[3] = ttevt-all02.ttevt-AmountMesAct[3] + (evtLine.VtaxMesMn - evtLine.CtoxMesMn).
                END.
                WHEN 2 THEN DO:
                    ASSIGN 
                        ttevt-all02.ttevt-AmountMesAct[1] = ttevt-all02.ttevt-AmountMesAct[1] + evtLine.VtaxMesMe
                        ttevt-all02.ttevt-AmountMesAct[2] = ttevt-all02.ttevt-AmountMesAct[2] + evtLine.CtoxMesMe
                        ttevt-all02.ttevt-AmountMesAct[3] = ttevt-all02.ttevt-AmountMesAct[3] + (evtLine.VtaxMesMe - evtLine.CtoxMesMe).
                END.
            END CASE.                 
        END.        
        IF LAST-OF(gn-divi.CodDiv) AND lValue THEN DO:
            iInt = iInt + 1.
            CREATE ttevt-all02.
            ASSIGN
                ttevt-all02.ttevt-CodCia = s-Codcia
                ttevt-all02.ttevt-Indice = iInt
                ttevt-all02.ttevt-Criterio = "Total División " + gn-divi.CodDiv + "-" + gn-divi.DesDiv + " :"
                ttevt-all02.ttevt-CodDiv = gn-divi.CodDiv
                ttevt-all02.ttevt-CodFam = "XXX".            
        END.
    END.
    
    /*Calculando Saldos año Anterior*/
    x-NroFchI = ((cb-anio - 1) * 100) + cb-mes.
    FOR EACH ttevt-all02 WHERE ttevt-all02.ttevt-CodCia = s-CodCia NO-LOCK
        BREAK BY ttevt-all02.ttevt-CodDiv :
        FOR EACH evtline WHERE evtline.CodCia = ttevt-all02.ttevt-CodCia 
            AND evtline.CodDiv = ttevt-all02.ttevt-CodDiv 
            AND evtline.CodFam = ttevt-all02.ttevt-CodFam 
            AND evtline.NroFch = x-NroFchI NO-LOCK:
            CASE rs-moneda:
                WHEN 1 THEN DO:
                    ASSIGN 
                        dSuma[1] = dSuma[1] + evtline.VtaxMesMn
                        dSuma[2] = dSuma[2] + evtline.CtoxMesMn
                        dSuma[3] = dSuma[3] + (evtline.VtaxMesMn - evtline.CtoxMesMn).
                END.
                WHEN 2 THEN DO:
                    ASSIGN 
                        dSuma[1] = dSuma[1] + evtline.VtaxMesMe
                        dSuma[2] = dSuma[2] + evtline.CtoxMesMe
                        dSuma[3] = dSuma[3] + (evtline.VtaxMesMe - evtline.CtoxMesMe).
                END.
            END CASE.
        END.
        FIND FIRST bttevt WHERE bttevt.ttevt-CodCia = ttevt-all02.ttevt-CodCia
            AND bttevt.ttevt-CodDiv = ttevt-all02.ttevt-CodDiv
            AND bttevt.ttevt-CodFam = ttevt-all02.ttevt-CodFam NO-LOCK NO-ERROR.
        IF AVAILABLE bttevt THEN DO:            
            ASSIGN 
                bttevt.ttevt-AmountMesAnt[1] = dSuma[1]
                bttevt.ttevt-AmountMesAnt[2] = dSuma[2]
                bttevt.ttevt-AmountMesAnt[3] = dSuma[3].
            dSuma = 0.
        END.
    END.


    /*Calcula acumulado a la fecha*/    
    FOR EACH ttevt-all02 BREAK BY ttevt-all02.ttevt-CodDiv
        BY ttevt-all02.ttevt-CodFam:
        DO k = cb-anio - 1 TO cb-anio:
            x-Month = cb-mes.
            iFcha = k * 100 + 1. 
            x-NroFchE = k * 100 + x-Month.
            dAcummA = 0.
            dAcummVta = 0.
            dAcummCto = 0.
            dAcummMrg = 0.

    
            FOR EACH bevt-line NO-LOCK 
                WHERE bevt-line.CodCia = s-CodCia
                AND bevt-line.CodDiv =  ttevt-all02.ttevt-CodDiv
                AND bevt-line.CodFam  = ttevt-all02.ttevt-CodFam
                AND bevt-line.NroFch >= iFcha
                AND bevt-line.NroFch <= x-NroFchE    
                BREAK BY bevt-line.CodDiv
                    BY bevt-line.CodFam:
                CASE rs-moneda:
                    WHEN 1 THEN DO: 
                        dAcummVta = dAcummVta + bevt-line.VtaxMesMn.
                        dAcummCto = dAcummCto + bevt-line.CtoxMesMn.
                        dAcummMrg = dAcummMrg + (bevt-line.VtaxMesMn - bevt-line.CtoxMesMn). 
                    END.
                    WHEN 2 THEN DO: 
                        dAcummVta = dAcummVta + bevt-line.VtaxMesMe.
                        dAcummCto = dAcummCto + bevt-line.CtoxMesMe.
                        dAcummMrg = dAcummMrg + (bevt-line.VtaxMesMe - bevt-line.CtoxMesMe). 
                    END.
                END CASE.
            END.
            FIND FIRST bttevt WHERE ROWID(bttevt) = ROWID(ttevt-all02) EXCLUSIVE-LOCK.
            IF AVAILABLE bttevt THEN DO:
                IF k = (cb-anio) THEN DO: 
                    ASSIGN 
                        bttevt.ttevt-AccumAct[1] = dAcummVta
                        bttevt.ttevt-AccumAct[2] = dAcummCto
                        bttevt.ttevt-AccumAct[3] = dAcummMrg.
                END.
                IF k = (cb-anio - 1) THEN DO: 
                    ASSIGN 
                        bttevt.ttevt-AccumAnt[1] = dAcummVta
                        bttevt.ttevt-AccumAnt[2] = dAcummCto
                        bttevt.ttevt-AccumAnt[3] = dAcummMrg.
                END.
            END.
        END.
    END. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Divi-A B-table-Win 
PROCEDURE Carga-Divi-A :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dAcum AS DECIMAL EXTENT 2 NO-UNDO.
    DEFINE VARIABLE dSuma AS DECIMAL EXTENT 4 NO-UNDO.
    DEFINE BUFFER bttevt FOR ttevt-all02.

    RUN Borra-Temporal.
    
    iInt = 0.
    x-NroFchI = (cb-anio * 100) + cb-mes.
    FOR EACH gn-divi NO-LOCK 
        WHERE gn-divi.CodCia = s-CodCia:
        FOR EACH evtdivi NO-LOCK
            WHERE evtdivi.CodCia = Gn-Divi.CodCia
            AND evtdivi.CodDiv = Gn-Divi.CodDiv
            AND evtdivi.NroFch = x-NroFchI:            
            FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodCia = evtdivi.CodCia
                AND ttevt-all02.ttevt-CodDiv = evtdivi.CodDiv NO-LOCK NO-ERROR.

            IF NOT AVAILABLE ttevt-all02 THEN DO:
                iInt =  iInt + 1.
                CREATE ttevt-all02.
                ASSIGN
                    ttevt-all02.ttevt-CodCia   = evtdivi.CodCia
                    ttevt-all02.ttevt-Indice   = iInt
                    ttevt-all02.ttevt-CodDiv   = evtdivi.CodDiv
                    ttevt-all02.ttevt-Criterio = evtdivi.CodDiv + " - " + INTEGRAL.GN-DIVI.DesDiv.
            END.
            CASE rs-moneda:
                WHEN 1 THEN DO:
                    ASSIGN 
                        ttevt-all02.ttevt-AmountMesAct[1] = ttevt-all02.ttevt-AmountMesAct[1] + EvtDivi.VtaxMesMn
                        ttevt-all02.ttevt-AmountMesAct[2] = ttevt-all02.ttevt-AmountMesAct[2] + EvtDivi.CtoxMesMn
                        ttevt-all02.ttevt-AmountMesAct[3] = ttevt-all02.ttevt-AmountMesAct[3] + (EvtDivi.VtaxMesMn - EvtDivi.CtoxMesMn).
                END.
                WHEN 2 THEN DO:
                    ASSIGN 
                        ttevt-all02.ttevt-AmountMesAct[1] = ttevt-all02.ttevt-AmountMesAct[1] + EvtDivi.VtaxMesMe
                        ttevt-all02.ttevt-AmountMesAct[2] = ttevt-all02.ttevt-AmountMesAct[2] + EvtDivi.CtoxMesMe
                        ttevt-all02.ttevt-AmountMesAct[3] = ttevt-all02.ttevt-AmountMesAct[3] + (EvtDivi.VtaxMesMe - EvtDivi.CtoxMesMe).
                END.
            END CASE.                                                
        END.
    END.

    /*Calculando los saldos años anteriores*/
    x-NroFchI = (cb-anio - 1) * 100 + cb-mes.
    FOR EACH ttevt-all02 NO-LOCK
        WHERE ttevt-all02.ttevt-CodCia = s-CodCia
        BREAK BY ttevt-all02.ttevt-CodDiv:        
        FOR EACH evtdivi NO-LOCK
            WHERE evtdivi.CodCia = ttevt-all02.ttevt-CodCia
            AND evtdivi.CodDiv = ttevt-all02.ttevt-CodDiv
            AND evtdivi.NroFch = x-NroFchI:
            CASE rs-moneda:
                WHEN 1 THEN DO:
                    ASSIGN 
                        dSuma[1] = dSuma[1] + evtdivi.VtaxMesMn
                        dSuma[2] = dSuma[2] + evtdivi.CtoxMesMn
                        dSuma[3] = dSuma[3] + (evtdivi.VtaxMesMn - evtdivi.CtoxMesMn).
                END.
                WHEN 2 THEN DO:
                    ASSIGN 
                        dSuma[1] = dSuma[1] + evtdivi.VtaxMesMe
                        dSuma[2] = dSuma[2] + evtdivi.CtoxMesMe
                        dSuma[3] = dSuma[3] + (evtdivi.VtaxMesMe - evtdivi.CtoxMesMe).
                END.
            END CASE.      
        END.
        FOR FIRST bttevt WHERE bttevt.ttevt-CodCia = ttevt-all02.ttevt-CodCia 
            AND bttevt.ttevt-CodDiv = ttevt-all02.ttevt-CodDiv NO-LOCK:
            ASSIGN 
                bttevt.ttevt-AmountMesAnt[1] = dSuma[1]
                bttevt.ttevt-AmountMesAnt[2] = dSuma[2]
                bttevt.ttevt-AmountMesAnt[3] = dSuma[3].
            dSuma[1] = 0.
            dSuma[2] = 0.
            dSuma[3] = 0.
        END.
    END.
    
    /*Calcula acumulado a la fecha*/
    FOR EACH ttevt-all02 NO-LOCK:
        DO k = cb-anio - 1 TO cb-anio:
            x-Month = cb-mes.
            iFcha = k * 100 + 1. 
            x-NroFchE = k * 100 + x-Month.
            dAcummA = 0.
            dAcummVta = 0.
            dAcummCto = 0.
            dAcummMrg = 0.

            FOR EACH bevt-divi NO-LOCK 
                WHERE bevt-divi.CodCia = ttevt-all02.ttevt-CodCia
                AND bevt-divi.CodDiv = ttevt-all02.ttevt-CodDiv
                AND bevt-divi.NroFch >= iFcha
                AND bevt-divi.NroFch <= x-NroFchE
                BREAK BY bevt-divi.CodDiv:
                CASE rs-moneda:
                    WHEN 1 THEN DO: 
                        dAcummVta = dAcummVta + bevt-divi.VtaxMesMn.
                        dAcummCto = dAcummCto + bevt-divi.CtoxMesMn.
                        dAcummMrg = dAcummMrg + (bevt-divi.VtaxMesMn - bevt-divi.CtoxMesMn). 
                    END.
                    WHEN 2 THEN DO: 
                        dAcummVta = dAcummVta + bevt-divi.VtaxMesMe.
                        dAcummCto = dAcummCto + bevt-divi.CtoxMesMe.
                        dAcummMrg = dAcummMrg + (bevt-divi.VtaxMesMe - bevt-divi.CtoxMesMe). 
                    END.
                END CASE.
            END.
            FIND FIRST bttevt WHERE ROWID(bttevt) = ROWID(ttevt-all02) EXCLUSIVE-LOCK.
            IF AVAILABLE bttevt THEN DO:                
                IF k = (cb-anio) THEN DO: 
                    ASSIGN 
                        bttevt.ttevt-AccumAct[1] = dAcummVta
                        bttevt.ttevt-AccumAct[2] = dAcummCto
                        bttevt.ttevt-AccumAct[3] = dAcummMrg.
                END.
                IF k = (cb-anio - 1) THEN DO: 
                    ASSIGN 
                        bttevt.ttevt-AccumAnt[1] = dAcummVta
                        bttevt.ttevt-AccumAnt[2] = dAcummCto
                        bttevt.ttevt-AccumAnt[3] = dAcummMrg.
                END.
            END.
        END.
    END.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Divi-A2 B-table-Win 
PROCEDURE Carga-Divi-A2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dSuma   AS DECIMAL EXTENT 4 NO-UNDO.
    DEFINE VARIABLE dSumaMe AS DECIMAL EXTENT 4 NO-UNDO.
    DEFINE VARIABLE iMoneda AS INTEGER NO-UNDO.
    DEFINE BUFFER bttevt    FOR ttevt-all02.


    FOR EACH ttevt-all02:
        DELETE ttevt-all02.
    END.
    iInt = 0.
    x-NroFchI = (cb-anio * 100) + cb-mes.
    FOR EACH gn-divi NO-LOCK 
        WHERE gn-divi.CodCia = s-CodCia:
        FOR EACH evtdivi NO-LOCK
            WHERE evtdivi.CodCia = Gn-Divi.CodCia
            AND evtdivi.CodDiv = Gn-Divi.CodDiv
            AND evtdivi.NroFch = x-NroFchI:            
            FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodCia = evtdivi.CodCia
                AND ttevt-all02.ttevt-CodDiv = evtdivi.CodDiv 
                AND ttevt-all02.ttevt-NroFch = evtdivi.NroFch
                AND (ttevt-all02.ttevt-Moneda = 1 OR ttevt-all02.ttevt-Moneda = 2)  NO-LOCK NO-ERROR.

            IF NOT AVAILABLE ttevt-all02 THEN DO:
                iInt =  iInt + 1.
                CREATE ttevt-all02.
                ASSIGN
                    ttevt-all02.ttevt-CodCia   = evtdivi.CodCia
                    ttevt-all02.ttevt-Indice   = iInt
                    ttevt-all02.ttevt-CodDiv   = evtdivi.CodDiv
                    ttevt-all02.ttevt-NroFch   = evtdivi.NroFch
                    ttevt-all02.ttevt-Criterio = 
                    evtdivi.CodDiv + " - " + INTEGRAL.GN-DIVI.DesDiv.
            END.
            ASSIGN 
                ttevt-all02.ttevt-AmountMesAct[1] = ttevt-all02.ttevt-AmountMesAct[1] + EvtDivi.VtaxMesMn
                ttevt-all02.ttevt-AmountMesAct[2] = ttevt-all02.ttevt-AmountMesAct[2] + EvtDivi.CtoxMesMn
                ttevt-all02.ttevt-AmountMesAct[3] = ttevt-all02.ttevt-AmountMesAct[3] + (EvtDivi.VtaxMesMn - EvtDivi.CtoxMesMn)
                ttevt-all02.ttevt-AmountMesActMe[1] = ttevt-all02.ttevt-AmountMesActMe[1] + EvtDivi.VtaxMesMe
                ttevt-all02.ttevt-AmountMesActMe[1] = ttevt-all02.ttevt-AmountMesActMe[1] + EvtDivi.CtoxMesMe
                ttevt-all02.ttevt-AmountMesActMe[1] = ttevt-all02.ttevt-AmountMesActMe[1] + (EvtDivi.VtaxMesMe - EvtDivi.CtoxMesMe).            
        END.
    END.

    /*Calculando los saldos años anteriores*/
    x-NroFchI = (cb-anio - 1) * 100 + cb-mes.
    FOR EACH ttevt-all02 NO-LOCK
        WHERE ttevt-all02.ttevt-CodCia = s-CodCia
        BREAK BY ttevt-all02.ttevt-CodDiv:        
        FOR EACH evtdivi NO-LOCK
            WHERE evtdivi.CodCia = ttevt-all02.ttevt-CodCia
            AND evtdivi.CodDiv = ttevt-all02.ttevt-CodDiv
            AND evtdivi.NroFch = x-NroFchI:
            ASSIGN 
                dSuma[1] = dSuma[1] + evtdivi.VtaxMesMn
                dSuma[2] = dSuma[2] + evtdivi.CtoxMesMn
                dSuma[3] = dSuma[3] + (evtdivi.VtaxMesMn - evtdivi.CtoxMesMn)
                dSumaMe[1] = dSumaMe[1] + evtdivi.VtaxMesMe
                dSumaMe[2] = dSumaMe[2] + evtdivi.CtoxMesMe
                dSumaMe[3] = dSumaMe[3] + (evtdivi.VtaxMesMe - evtdivi.CtoxMesMe).            
        END.
        FOR FIRST bttevt WHERE bttevt.ttevt-CodCia = ttevt-all02.ttevt-CodCia 
            AND bttevt.ttevt-CodDiv = ttevt-all02.ttevt-CodDiv NO-LOCK:
            ASSIGN 
                bttevt.ttevt-AmountMesAnt[1] = dSuma[1]
                bttevt.ttevt-AmountMesAnt[2] = dSuma[2]
                bttevt.ttevt-AmountMesAnt[3] = dSuma[3]
                bttevt.ttevt-AmountMesAntMe[1] = dSumaMe[1]
                bttevt.ttevt-AmountMesAntMe[2] = dSumaMe[2]
                bttevt.ttevt-AmountMesAntMe[3] = dSumaMe[3].
            dSuma   = 0.
            dSumaMe = 0.
        END.
    END.
    
    /*Calcula acumulado a la fecha*/
    FOR EACH ttevt-all02 NO-LOCK:
        DO k = cb-anio - 1 TO cb-anio:
            x-Month = cb-mes.
            iFcha = k * 100 + 1. 
            x-NroFchE = k * 100 + x-Month.
            dAcummA = 0.
            dAcummVta = 0.
            dAcummCto = 0.
            dAcummMrg = 0.

            FOR EACH bevt-divi NO-LOCK 
                WHERE bevt-divi.CodCia = ttevt-all02.ttevt-CodCia
                AND bevt-divi.CodDiv = ttevt-all02.ttevt-CodDiv
                AND bevt-divi.NroFch >= iFcha
                AND bevt-divi.NroFch <= x-NroFchE
                BREAK BY bevt-divi.CodDiv:
                CASE rs-moneda:
                    WHEN 1 THEN DO: 
                        dAcummVta = dAcummVta + bevt-divi.VtaxMesMn.
                        dAcummCto = dAcummCto + bevt-divi.CtoxMesMn.
                        dAcummMrg = dAcummMrg + (bevt-divi.VtaxMesMn - bevt-divi.CtoxMesMn). 
                    END.
                    WHEN 2 THEN DO: 
                        dAcummVta = dAcummVta + bevt-divi.VtaxMesMe.
                        dAcummCto = dAcummCto + bevt-divi.CtoxMesMe.
                        dAcummMrg = dAcummMrg + (bevt-divi.VtaxMesMe - bevt-divi.CtoxMesMe). 
                    END.
                END CASE.
            END.
            FIND FIRST bttevt WHERE ROWID(bttevt) = ROWID(ttevt-all02) EXCLUSIVE-LOCK.
            IF AVAILABLE bttevt THEN DO:                
                IF k = (cb-anio) THEN DO: 
                    ASSIGN 
                        bttevt.ttevt-AccumAct[1] = dAcummVta
                        bttevt.ttevt-AccumAct[2] = dAcummCto
                        bttevt.ttevt-AccumAct[3] = dAcummMrg.
                END.
                IF k = (cb-anio - 1) THEN DO: 
                    ASSIGN 
                        bttevt.ttevt-AccumAnt[1] = dAcummVta
                        bttevt.ttevt-AccumAnt[2] = dAcummCto
                        bttevt.ttevt-AccumAnt[3] = dAcummMrg.
                END.
            END.
        END.
    END.   
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

    RUN Carga-Divi-A.
    CASE cb-tipo:
        WHEN "Ventas" THEN iIndx = 1. 
        WHEN "Costos" THEN iIndx = 2. 
        WHEN "Margen" THEN iIndx = 3. 
    END CASE.

    RUN Carga-Det-Div (iIndx).

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

    RUN Carga-Div-Clie-X.
    CASE cb-tipo:
        WHEN "Ventas" THEN iIndx = 1. 
        WHEN "Costos" THEN iIndx = 2. 
        WHEN "Margen" THEN iIndx = 3. 
    END CASE.

    RUN Carga-Det-Div-Clie (iIndx).

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

    RUN Carga-Div-Fam-A.
    CASE cb-tipo:
        WHEN "Ventas" THEN iIndx = 1. 
        WHEN "Costos" THEN iIndx = 2. 
        WHEN "Margen" THEN iIndx = 3. 
    END CASE.

    RUN Carga-Det-Div-Line (iIndx).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Fam-Clie-A B-table-Win 
PROCEDURE Carga-Fam-Clie-A :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dAcum     AS DECIMAL EXTENT 2  NO-UNDO.    
    DEFINE VARIABLE cName     LIKE gn-clie.NomCli  NO-UNDO.
    DEFINE VARIABLE dTotalDiv AS DECIMAL EXTENT 2  NO-UNDO.
    DEFINE VARIABLE lValue    AS LOGICAL INIT NO   NO-UNDO.
    DEFINE VARIABLE dSuma     AS DECIMAL EXTENT 4  NO-UNDO.
    DEFINE VARIABLE iCount    AS INTEGER     NO-UNDO.

    DEFINE BUFFER bttevt FOR ttevt-all02.

    RUN Borra-Temporal.
    
    iInt = 0.
    x-NroFchI = cb-anio * 100 + x-Month.
    FOR EACH AlmtFami WHERE AlmtFami.CodCia = s-CodCia NO-LOCK 
        BREAK BY AlmtFami.CodFam:
        lValue = NO.
        Clientes:
        FOR EACH evtall03 
            WHERE evtall03.Codcia = s-codcia:
            FIND FIRST gn-clie WHERE gn-clie.CodCia = cl-CodCia 
                AND gn-clie.CodCli = evtall03.CodUnico NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clie THEN cName = gn-clie.NomCli. ELSE cName = "".

            FOR EACH evtall02 NO-LOCK WHERE evtall02.CodCia = evtall03.CodCia
                AND evtall02.CodUnico = evtall03.CodUnico
                AND evtall02.CodFam   = AlmtFami.CodFam
                AND evtall02.NroFch   = x-NroFchI:                
    
                FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodCia = evtall02.CodCia
                    AND ttevt-all02.ttevt-CodFam   = evtall02.CodFam
                    AND ttevt-all02.ttevt-CodUnico = evtall02.CodUnico NO-LOCK NO-ERROR.
    
                IF NOT AVAILABLE ttevt-all02 THEN DO:
                    iInt =  iInt + 1.
                    lValue = YES.
                    CREATE ttevt-all02.
                    ASSIGN
                        ttevt-all02.ttevt-CodCia   = evtall02.Codcia
                        ttevt-all02.ttevt-Indice   = iInt
                        ttevt-all02.ttevt-CodFam   = AlmtFami.CodFam
                        ttevt-all02.ttevt-CodUnico = evtall02.CodUnico
                        ttevt-all02.ttevt-Criterio = evtall02.CodUnico + " - " + cName.
                END.
                CASE rs-moneda:
                    WHEN 1 THEN DO:
                        ASSIGN 
                            ttevt-all02.ttevt-AmountMesAct[1] = ttevt-all02.ttevt-AmountMesAct[1] + evtall02.VtaxMesMn
                            ttevt-all02.ttevt-AmountMesAct[2] = ttevt-all02.ttevt-AmountMesAct[2] + evtall02.CtoxMesMn
                            ttevt-all02.ttevt-AmountMesAct[3] = ttevt-all02.ttevt-AmountMesAct[3] + (evtall02.VtaxMesMn - evtall02.CtoxMesMn). 
                    END.
                    WHEN 2 THEN DO:
                        ASSIGN 
                            ttevt-all02.ttevt-AmountMesAct[1] = ttevt-all02.ttevt-AmountMesAct[1] + evtall02.VtaxMesMe
                            ttevt-all02.ttevt-AmountMesAct[2] = ttevt-all02.ttevt-AmountMesAct[2] + evtall02.CtoxMesMe
                            ttevt-all02.ttevt-AmountMesAct[3] = ttevt-all02.ttevt-AmountMesAct[3] + (evtall02.VtaxMesMe - evtall02.CtoxMesMe).
                    END.
                END CASE.    
                DISPLAY
                    'Espere un momento por favor...' SKIP
                    'Procesando Información para Línea: ' AlmtFami.CodFam NO-LABEL
                    WITH FRAME F-Mensaje TITLE 'Procesando informacion' CENTERED OVERLAY VIEW-AS DIALOG-BOX.
                IF iCount >= txt-top THEN LEAVE Clientes.
            END.
        END.
        IF LAST-OF(AlmtFami.CodFam) AND lValue THEN DO:
            FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodCia = AlmtFami.CodCia
                AND ttevt-all02.ttevt-CodFam = AlmtFami.CodFam
                AND ttevt-all02.ttevt-CodUnico = "XXX" NO-LOCK NO-ERROR.
            IF NOT AVAIL ttevt-all02 THEN DO:
                iInt = iInt + 1.
                CREATE ttevt-all02.
                ASSIGN
                    ttevt-all02.ttevt-CodCia = s-Codcia
                    ttevt-all02.ttevt-Indice = iInt
                    ttevt-all02.ttevt-Criterio = "Total Línea " + Almtfami.Codfam + "-" + Almtfami.desfam + ":"
                    ttevt-all02.ttevt-CodFam   = AlmtFami.CodFam
                    ttevt-all02.ttevt-CodUnico = "XXX".
            END.
        END.           
    END.

    /*Calculando Saldos Años Anteriores*/
    x-NroFchI = (cb-anio - 1) * 100 + cb-mes.    
    FOR EACH ttevt-all02 NO-LOCK 
        BREAK BY ttevt-all02.ttevt-CodFam:
        dSuma = 0.
        FOR EACH evtall02 WHERE evtall02.CodCia = ttevt-all02.ttevt-CodCia
            AND evtall02.NroFch   = x-NroFchI
            AND evtall02.CodFam   = ttevt-all02.ttevt-CodFam
            AND evtall02.CodUnico = ttevt-all02.ttevt-CodUnico
            USE-INDEX Indice02 NO-LOCK:
            CASE rs-moneda:
                WHEN 1 THEN DO:
                    ASSIGN 
                        dSuma[1] = dSuma[1] + evtall02.VtaxMesMn
                        dSuma[2] = dSuma[2] + evtall02.CtoxMesMn
                        dSuma[3] = dSuma[3] + (evtall02.VtaxMesMn - evtall02.CtoxMesMn).
                END.
                WHEN 2 THEN DO:
                    ASSIGN 
                        dSuma[1] = dSuma[1] + evtall02.VtaxMesMe
                        dSuma[2] = dSuma[2] + evtall02.CtoxMesMe
                        dSuma[3] = dSuma[3] + (evtall02.VtaxMesMe - evtall02.CtoxMesMe).
                END.
            END CASE.            
        END.
        FIND FIRST bttevt WHERE bttevt.ttevt-CodCia = ttevt-all02.ttevt-CodCia
            AND bttevt.ttevt-CodFam   = ttevt-all02.ttevt-CodFam
            AND bttevt.ttevt-CodUnico = ttevt-all02.ttevt-CodUnico NO-LOCK NO-ERROR.
        IF AVAILABLE bttevt THEN DO:            
            ASSIGN 
                bttevt.ttevt-AmountMesAnt[1] = dSuma[1]
                bttevt.ttevt-AmountMesAnt[2] = dSuma[2]
                bttevt.ttevt-AmountMesAnt[3] = dSuma[3].
        END.
    END.

        /*Calcula acumulados*/
    FOR EACH ttevt-all02 NO-LOCK
        BREAK BY ttevt-all02.ttevt-CodDiv:        
        DO k = cb-anio - 1 TO cb-anio:
            x-Month = cb-mes.
            iFcha = k * 100 + 1. 
            x-NroFchE = k * 100 + x-Month.
            dAcummA = 0.
            dAcummVta = 0.
            dAcummCto = 0.
            dAcummMrg = 0.

            FOR EACH evtall02 NO-LOCK 
                WHERE evtall02.CodCia = ttevt-all02.ttevt-CodCia
                AND evtall02.CodFam   = ttevt-all02.ttevt-CodFam
                AND evtall02.CodUnico = ttevt-all02.ttevt-CodUnico
                AND evtall02.NroFch >= iFcha
                AND evtall02.NroFch <= x-NroFchE
                USE-INDEX Indice02:
                CASE rs-moneda:
                    WHEN 1 THEN DO: 
                        dAcummVta = dAcummVta + evtall02.VtaxMesMn.
                        dAcummCto = dAcummCto + evtall02.CtoxMesMn.
                        dAcummMrg = dAcummMrg + (evtall02.VtaxMesMn - evtall02.CtoxMesMn). 
                    END.
                    WHEN 2 THEN DO: 
                        dAcummVta = dAcummVta + evtall02.VtaxMesMe.
                        dAcummCto = dAcummCto + evtall02.CtoxMesMe.
                        dAcummMrg = dAcummMrg + (evtall02.VtaxMesMe - evtall02.CtoxMesMe). 
                    END.
                END CASE.
            END.  
            FIND FIRST bttevt WHERE ROWID(bttevt) = ROWID(ttevt-all02) EXCLUSIVE-LOCK.
            IF AVAILABLE bttevt THEN DO:
                IF k = (cb-anio) THEN DO: 
                    ASSIGN 
                        bttevt.ttevt-AccumAct[1] = dAcummVta
                        bttevt.ttevt-AccumAct[2] = dAcummCto
                        bttevt.ttevt-AccumAct[3] = dAcummMrg.
                END.
                IF k = (cb-anio - 1) THEN DO: 
                    ASSIGN 
                        bttevt.ttevt-AccumAnt[1] = dAcummVta
                        bttevt.ttevt-AccumAnt[2] = dAcummCto
                        bttevt.ttevt-AccumAnt[3] = dAcummMrg.
                END.
            END.   
        END.
    END.
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

    RUN Carga-Fam-Clie-A.
    CASE cb-tipo:
        WHEN "Ventas" THEN iIndx = 1. 
        WHEN "Costos" THEN iIndx = 2. 
        WHEN "Margen" THEN iIndx = 3. 
    END CASE.

    RUN Carga-Det-Fam-Clie (iIndx).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Linea-A B-table-Win 
PROCEDURE Carga-Linea-A :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUFFER bttevt FOR ttevt-all02.
    DEFINE VARIABLE dSuma AS DECIMAL EXTENT 4 NO-UNDO.
    
    RUN Borra-Temporal.
    
    x-NroFchI = cb-anio * 100 + cb-mes.
    iInt = 0.
    FOR EACH AlmtFami NO-LOCK 
        WHERE AlmtFami.CodCia = s-CodCia:
    
        FOR EACH evtLine NO-LOCK
            WHERE evtLine.CodCia = AlmtFami.CodCia
            AND evtLine.CodFam = AlmtFami.CodFam
            AND evtLine.NroFch = x-NroFchI:
        
            FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodCia = evtLine.CodCia
                AND ttevt-all02.ttevt-CodFam = evtLine.CodFam NO-LOCK NO-ERROR.
    
            IF NOT AVAILABLE ttevt-all02 THEN DO:
                iInt = iInt + 1.
                CREATE ttevt-all02.
                ASSIGN
                    ttevt-all02.ttevt-CodCia   = evtLine.CodCia
                    ttevt-all02.ttevt-Indice   = iInt
                    ttevt-all02.ttevt-CodFam   = evtLine.CodFam
                    ttevt-all02.ttevt-Criterio = evtLine.CodFam + " - " + INTEGRAL.AlmtFami.DesFam.
            END.
            CASE rs-moneda:
                WHEN 1 THEN DO:
                    ASSIGN 
                        ttevt-all02.ttevt-AmountMesAct[1] = ttevt-all02.ttevt-AmountMesAct[1] + evtLine.VtaxMesMn
                        ttevt-all02.ttevt-AmountMesAct[2] = ttevt-all02.ttevt-AmountMesAct[2] + evtLine.CtoxMesMn
                        ttevt-all02.ttevt-AmountMesAct[3] = ttevt-all02.ttevt-AmountMesAct[3] + (evtLine.VtaxMesMn - evtLine.CtoxMesMn).
                END.
                WHEN 2 THEN DO:
                    ASSIGN 
                        ttevt-all02.ttevt-AmountMesAct[1] = ttevt-all02.ttevt-AmountMesAct[1] + evtLine.VtaxMesMe
                        ttevt-all02.ttevt-AmountMesAct[2] = ttevt-all02.ttevt-AmountMesAct[2] + evtLine.CtoxMesMe
                        ttevt-all02.ttevt-AmountMesAct[3] = ttevt-all02.ttevt-AmountMesAct[3] + (evtLine.VtaxMesMe - evtLine.CtoxMesMe).
                END.
            END CASE.    
            DISPLAY
                'Espere un momento por favor...' SKIP
                'Procesando Información para Línea: ' evtLine.CodFam NO-LABEL
                WITH FRAME F-Mensaje TITLE 'Procesando informacion' CENTERED OVERLAY VIEW-AS DIALOG-BOX.                                                

        END.        
    END.

    /*Calculando saldos año anterior*/
    x-NroFchI = (cb-anio - 1) * 100 + cb-mes.
    FOR EACH ttevt-all02 NO-LOCK BREAK BY ttevt-all02.ttevt-codfam:
        FOR EACH evtLine WHERE evtLine.CodCia = ttevt-all02.ttevt-codCia
            AND evtLine.CodFam = ttevt-all02.ttevt-codFam
            AND evtLine.NroFch = x-NroFchI NO-LOCK:
            CASE rs-moneda:
                WHEN 1 THEN DO:
                    ASSIGN 
                        dSuma[1] = dSuma[1] + evtline.VtaxMesMn
                        dSuma[2] = dSuma[2] + evtline.CtoxMesMn
                        dSuma[3] = dSuma[3] + (evtline.VtaxMesMn - evtline.CtoxMesMn).
                END.
                WHEN 2 THEN DO:
                    ASSIGN 
                        dSuma[1] = dSuma[1] + evtline.VtaxMesMe
                        dSuma[2] = dSuma[2] + evtline.CtoxMesMe
                        dSuma[3] = dSuma[3] + (evtline.VtaxMesMe - evtline.CtoxMesMe).
                END.
            END CASE.
        END.
        IF LAST-OF(ttevt-all02.ttevt-CodFam) THEN DO:
            ASSIGN 
                ttevt-all02.ttevt-AmountMesAnt[1] = dSuma[1]
                ttevt-all02.ttevt-AmountMesAnt[2] = dSuma[2]
                ttevt-all02.ttevt-AmountMesAnt[3] = dSuma[3].
            dSuma[1] = 0.
            dSuma[2] = 0.
            dSuma[3] = 0.
        END.
    END.

    /*Calcula acumulado a la fecha*/
    
    FOR EACH ttevt-all02:
        DO k = cb-anio - 1 TO cb-anio:
            x-Month = cb-mes.
            iFcha = k * 100 + 1. 
            x-NroFchE = k * 100 + x-Month.
            dAcummVta = 0.
            dAcummCto = 0.
            dAcummMrg = 0.
    
            FOR EACH bevt-line NO-LOCK 
                WHERE bevt-line.CodCia = s-CodCia
                AND bevt-line.CodFam  = ttevt-all02.ttevt-CodFam
                AND bevt-line.NroFch >= iFcha
                AND bevt-line.NroFch <= x-NroFchE    
                BREAK BY bevt-line.CodFam:
                CASE rs-moneda:
                    WHEN 1 THEN DO: 
                        dAcummVta = dAcummVta + bevt-line.VtaxMesMn.
                        dAcummCto = dAcummCto + bevt-line.CtoxMesMn.
                        dAcummMrg = dAcummMrg + (bevt-line.VtaxMesMn - bevt-line.CtoxMesMn).
                    END.
                    WHEN 2 THEN DO:                         
                        dAcummVta = dAcummVta + bevt-line.VtaxMesMe.
                        dAcummCto = dAcummCto + bevt-line.CtoxMesMe.
                        dAcummMrg = dAcummMrg + (bevt-line.VtaxMesMe - bevt-line.CtoxMesMe).
                    END.
                END CASE.
            END.
            FIND FIRST bttevt WHERE bttevt.ttevt-CodCia = ttevt-all02.ttevt-CodCia
                AND bttevt.ttevt-CodFam = ttevt-all02.ttevt-CodFam NO-LOCK NO-ERROR.
            IF AVAILABLE bttevt THEN DO:
                IF k = (cb-anio) THEN DO: 
                    ASSIGN 
                        bttevt.ttevt-AccumAct[1] = dAcummVta
                        bttevt.ttevt-AccumAct[2] = dAcummCto
                        bttevt.ttevt-AccumAct[3] = dAcummMrg.
                END.
                IF k = (cb-anio - 1) THEN DO: 
                    ASSIGN 
                        bttevt.ttevt-AccumAnt[1] = dAcummVta
                        bttevt.ttevt-AccumAnt[2] = dAcummCto
                        bttevt.ttevt-AccumAnt[3] = dAcummMrg.
                END.
            END.
        END.
    END. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Lines B-table-Win 
PROCEDURE Carga-Lines :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iIndx AS INTEGER NO-UNDO.

    RUN Carga-Linea-A.
    CASE cb-tipo:
        WHEN "Ventas" THEN iIndx = 1. 
        WHEN "Costos" THEN iIndx = 2. 
        WHEN "Margen" THEN iIndx = 3. 
    END CASE.

    RUN Carga-Det-Line (iIndx).
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

FOR EACH ttevt-all02 NO-LOCK BREAK BY ttevt-all02.ttevt-indice:
    IF ttevt-all02.ttevt-criterio BEGINS "Total" THEN NEXT.
    ASSIGN
        txt-amount1 = txt-amount1 + ttevt-AmountMes[1]
        txt-amount2 = txt-amount2 + ttevt-AmountMes[2]
        txt-acum1   = txt-acum1   + ttevt-Accumulate[1]
        txt-acum2   = txt-acum2   + ttevt-Accumulate[2].
    IF LAST(ttevt-all02.ttevt-indice) THEN DO:
        IF txt-amount2 <> 0 THEN
            ASSIGN
                txt-dif1 = txt-amount1 / txt-amount2 * 100.
        ELSE  ASSIGN txt-dif1 = 100.
        IF txt-acum2 <> 0 THEN 
            ASSIGN
                txt-dif2 = txt-acum1 / txt-acum2 * 100.
        ELSE ASSIGN txt-dif2 = 100.
    END.
END.  

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

    DEFINE VARIABLE x-CodDiv AS CHAR.
    DEFINE VARIABLE x-CodDoc AS CHAR.
    DEFINE VARIABLE i AS INTEGER.
    DEFINE VARIABLE x-Moneda AS CHARACTER.
    DEFINE VARIABLE x-SaldoMn AS DECIMAL.
    DEFINE VARIABLE x-SaldoMe AS DECIMAL.
    DEFINE VARIABLE x-credito AS DECIMAL NO-UNDO.    

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

    FOR EACH ttevt-all02 NO-LOCK:
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-Criterio.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-all02.ttevt-AmountMes[1].
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-all02.ttevt-AmountMes[2].
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-all02.ttevt-Accumulate[1].
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-all02.ttevt-Accumulate[2].
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-all02.ttevt-DifMes[1].
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-all02.ttevt-DifMes[2].
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
      iAnioIni = YEAR(TODAY).
      DO iInt = 1 TO 10:
          iAnioIni = iAnioIni - 1.
          cb-anio:ADD-LAST(STRING(iAnioIni)). 
      END.  
      DO iInt = 2  TO 12:
          cb-mes:ADD-LAST(STRING(iInt)). 
      END.
      txt-top:VISIBLE = FALSE.
      txt-dato:VISIBLE = FALSE.
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
  {src/adm/template/snd-list.i "ttevt-all02"}

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

