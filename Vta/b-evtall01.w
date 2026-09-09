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
/*
&SCOPED-DEFINE CONDICION ( EVTALL02.CodCia = S-CODCIA AND ~
                           EVTALL02.CodDiv BEGINS txt-Division AND ~
                           EVTALL02.CodCli BEGINS txt-cliente AND ~
                           INTEGER(SUBSTRING(EVTALL02.NroFch),1,4) = cb-anio AND ~
                           INTEGER(SUBSTRING(EVTALL02.NroFch),1,4) = cb-anio - 1 AND ~
                           INTEGER(SUBSTRING(EVTALL02.NroFch),5) = cb-mes)*/


/* Local Variable Definitions ---                                       */

DEFINE SHARED VARIABLE s-codcia AS INTEGER INIT 1.
DEFINE SHARED VARIABLE cl-codcia AS INTEGER INIT 1.

DEFINE VARIABLE dAmountAnioMn_1 AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dAmountAnioMe_1 AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dAmountAnioMn_2 AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dAmountAnioMe_2 AS DECIMAL     NO-UNDO.

DEFINE TEMP-TABLE ttevt-all02 NO-UNDO
    FIELDS ttevt-coddiv        LIKE evtall02.CodDiv    
    FIELDS ttevt-nromes        AS DECIMAL FORMAT "99"
    FIELDS ttevt-codcli        LIKE evtall02.codcli
    FIELDS ttevt-codunico      LIKE evtall02.codunico
    FIELDS ttevt-nomcli        LIKE gn-clie.nomcli
    FIELDS ttevt-CodFam        LIKE EvtALL02.CodFam
    FIELDS ttevt-AmountMesMn   LIKE EvtALL02.VtaxMesMn EXTENT 2
    FIELDS ttevt-AmountMesMe   LIKE EvtALL02.VtaxMesMe EXTENT 2
    FIELDS ttevt-AccumMn       LIKE EvtALL02.VtaxMesMn EXTENT 2
    FIELDS ttevt-AccumMe       LIKE EvtALL02.VtaxMesMe EXTENT 2
    FIELDS ttevt-DifAmntMn     AS DECIMAL EXTENT 2
    FIELDS ttevt-DifAmntMe     AS DECIMAL EXTENT 2.

DEFINE TEMP-TABLE ttevt-all NO-UNDO
    FIELDS ttevt-coddiv        LIKE evtall02.CodDiv    
    FIELDS ttevt-nromes        AS DECIMAL FORMAT "99"
    FIELDS ttevt-codcli        LIKE evtall02.codcli
    FIELDS ttevt-codunico      LIKE evtall02.codunico
    FIELDS ttevt-nomcli        LIKE gn-clie.nomcli
    FIELDS ttevt-CodFam        LIKE EvtALL02.CodFam
    FIELDS ttevt-AmountMesMn   LIKE EvtALL02.VtaxMesMn EXTENT 2
    FIELDS ttevt-AmountMesMe   LIKE EvtALL02.VtaxMesMe EXTENT 2
    FIELDS ttevt-DifAmntMn     AS DECIMAL EXTENT 2
    FIELDS ttevt-DifAmntMe     AS DECIMAL EXTENT 2.

DEF VAR x-month AS INT NO-UNDO.
DEF VAR x-year AS INT NO-UNDO.
DEF VAR x-nrofchi AS INT NO-UNDO.
DEF VAR k AS INT NO-UNDO.
DEF VAR x-MonthEnd AS INT NO-UNDO.

RUN Carga-Detalle-Division.

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
&Scoped-define FIELDS-IN-QUERY-br_table ttevt-CodDiv ttevt-nromes ttevt-CodUnico ttevt-codcli ttevt-nomcli ttevt-codfam ttevt-AmountMesMn[1] ttevt-AmountMesMe[1] ttevt-AmountMesMn[2] ttevt-AmountMesMe[2] ttevt-AccumMn[1] ttevt-AccumMe[1] ttevt-AccumMn[2] ttevt-AccumMe[2] ttevt-DifAmntMn[1] ttevt-DifAmntMe[1] ttevt-DifAmntMn[2] ttevt-DifAmntMe[2]   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define SELF-NAME br_table
&Scoped-define QUERY-STRING-br_table FOR EACH ttevt-all02 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH ttevt-all02 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table ttevt-all02
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ttevt-all02


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cb-anio cb-mes cb-mes-2 btn-Ok BUTTON-1 ~
txt-Cliente BUTTON-6 txt-CodFam tg-divi tg-client tg-fami br_table 
&Scoped-Define DISPLAYED-OBJECTS cb-anio cb-mes cb-mes-2 txt-Division ~
txt-Cliente txt-nomcli txt-CodFam tg-divi tg-client tg-fami 

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

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 6" 
     SIZE 4.43 BY 1.

DEFINE VARIABLE cb-anio AS INTEGER FORMAT "9999":U INITIAL 2009 
     LABEL "Año" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "2009" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-mes AS INTEGER FORMAT "99":U INITIAL 1 
     LABEL "Mes Inicio" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "01" 
     DROP-DOWN-LIST
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE cb-mes-2 AS INTEGER FORMAT "99":U INITIAL 1 
     LABEL "Mes Fin" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "01" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE txt-Cliente AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE txt-CodFam AS CHARACTER FORMAT "X(60)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE txt-Division AS CHARACTER FORMAT "X(60)":U INITIAL "00000" 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE txt-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81 NO-UNDO.

DEFINE VARIABLE tg-client AS LOGICAL INITIAL no 
     LABEL "Cliente" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

DEFINE VARIABLE tg-divi AS LOGICAL INITIAL yes 
     LABEL "División" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

DEFINE VARIABLE tg-fami AS LOGICAL INITIAL no 
     LABEL "Familia" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      ttevt-all02 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      ttevt-CodDiv         COLUMN-LABEL "Div" FORMAT "9999999"   
    ttevt-nromes         COLUMN-LABEL "Mes" FORMAT ">99"    
    ttevt-CodUnico       COLUMN-LABEL "Cód Unico" FORMAT "X(14)"
    ttevt-codcli         COLUMN-LABEL "Código" FORMAT "X(14)"    
    ttevt-nomcli         COLUMN-LABEL "Cliente" FORMAT "X(45)" 
    ttevt-codfam         COLUMN-LABEL "Fam" FORMAT "X(5)" 
    ttevt-AmountMesMn[1] COLUMN-LABEL "Mes Año1 S/." 
    ttevt-AmountMesMe[1] COLUMN-LABEL "Mes Año1 $" 
    ttevt-AmountMesMn[2] COLUMN-LABEL "Mes Año2 S/." 
    ttevt-AmountMesMe[2] COLUMN-LABEL "Mes Año2 $" 
    ttevt-AccumMn[1]     COLUMN-LABEL "Acumulado Año1 S/."  
    ttevt-AccumMe[1]     COLUMN-LABEL "Acumulado Año1 $" 
    ttevt-AccumMn[2]     COLUMN-LABEL "Acumulado Año2 S/."  
    ttevt-AccumMe[2]     COLUMN-LABEL "Acumulado Año2 $" 
    ttevt-DifAmntMn[1]   COLUMN-LABEL "Dif. Mes S/." FORMAT "->>>,>99.99"
    ttevt-DifAmntMe[1]   COLUMN-LABEL "Dif. Mes $ " FORMAT "->>>,>99.99"
    ttevt-DifAmntMn[2]   COLUMN-LABEL "Dif. Acum S/." FORMAT "->>>,>99.99"
    ttevt-DifAmntMe[2]   COLUMN-LABEL "Dif. Acum $ " FORMAT "->>>,>99.99"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 99 BY 9.62
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cb-anio AT ROW 1.27 COL 9.57 COLON-ALIGNED WIDGET-ID 2
     cb-mes AT ROW 1.27 COL 39 COLON-ALIGNED WIDGET-ID 4
     cb-mes-2 AT ROW 1.27 COL 57 COLON-ALIGNED WIDGET-ID 38
     btn-Ok AT ROW 1.27 COL 91.29 WIDGET-ID 14
     BUTTON-1 AT ROW 2.35 COL 55.57 WIDGET-ID 6
     txt-Division AT ROW 2.42 COL 9.57 COLON-ALIGNED WIDGET-ID 8
     txt-Cliente AT ROW 3.42 COL 9.57 COLON-ALIGNED WIDGET-ID 10
     txt-nomcli AT ROW 3.42 COL 21.57 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     BUTTON-6 AT ROW 4.42 COL 55 WIDGET-ID 32
     txt-CodFam AT ROW 4.5 COL 9.72 COLON-ALIGNED WIDGET-ID 34
     tg-divi AT ROW 5.58 COL 12 WIDGET-ID 24
     tg-client AT ROW 5.58 COL 25 WIDGET-ID 26
     tg-fami AT ROW 5.58 COL 38 WIDGET-ID 28
     br_table AT ROW 6.65 COL 3
     "Agrupar por:" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 5.69 COL 2.86 WIDGET-ID 30
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
         HEIGHT             = 15.62
         WIDTH              = 101.57.
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
/* BROWSE-TAB br_table tg-fami F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN txt-Division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-nomcli IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM

OPEN QUERY {&SELF-NAME} FOR EACH ttevt-all02 NO-LOCK INDEXED-REPOSITION.
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
      cb-mes-2
      txt-Division
      txt-Cliente
      txt-CodFam
      tg-divi
      tg-client
      tg-fami.

  IF tg-divi THEN 
      RUN Carga-Detalle-Division.
  IF tg-client THEN
      RUN Carga-Detalle-Cliente.
  IF tg-fami THEN
      RUN Carga-Detalle-Familia.
  IF tg-divi AND tg-client THEN
      RUN Carga-Detalle-Div-Cli.
  IF tg-divi AND tg-fami THEN
      RUN Carga-Detalle-Div-Fam.
  IF tg-client AND tg-fami THEN
      RUN Carga-Detalle-Cli-Fam.
  IF tg-divi AND tg-client AND tg-fami THEN
      RUN Carga-Detalle.

  RUN adm-open-query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:

    DEF VAR x-Divisiones AS CHAR.
    x-Divisiones = txt-Division:SCREEN-VALUE.
    RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
    txt-Division:SCREEN-VALUE = x-Divisiones.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 B-table-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Button 6 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "".
    output-var-2 = "".
    RUN lkup\C-Famili02.r("Familias").
    IF output-var-2 <> ? THEN DO:
        txt-CODFAM = output-var-2.
        DISPLAY txt-CODFAM.
        IF NUM-ENTRIES(txt-CODFAM) = 1 THEN 
        APPLY "ENTRY" TO txt-CODFAM .
        RETURN NO-APPLY.
    END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-CodFam B-table-Win
ON LEAVE OF txt-CodFam IN FRAME F-Main /* Familia */
DO:
   ASSIGN txt-CodFam.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-Division B-table-Win
ON LEAVE OF txt-Division IN FRAME F-Main /* División */
DO:
    ASSIGN txt-Division.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */
ON FIND OF EVTALL02
DO:
    IF INTEGER(SUBSTRING(STRING(EVTALL02.NroFch),1,4)) = cb-anio THEN DO:
        dAmountAnioMn_1 = EvtALL02.VtaxMesMe.
        dAmountAnioMe_1 = EvtALL02.VtaxMesMn.
        dAmountAnioMn_2 = 0.
        dAmountAnioMe_2 = 0.
    END.
    ELSE DO:
        dAmountAnioMn_1 = 0.
        dAmountAnioMe_1 = 0.
        dAmountAnioMn_2 = EvtALL02.VtaxMesMe.
        dAmountAnioMe_2 = EvtALL02.VtaxMesMe.
    END.
    
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle B-table-Win 
PROCEDURE Carga-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE dAmountMn AS DECIMAL EXTENT 2 NO-UNDO.
DEFINE VARIABLE dAmountMe AS DECIMAL EXTENT 2 NO-UNDO.

FOR EACH ttevt-all02:
    DELETE ttevt-all02.
END.

FOR EACH gn-divi NO-LOCK WHERE gn-divi.CodCia = s-CodCia 
    AND LOOKUP(gn-divi.CodDiv,txt-Division) > 0:

    FOR EACH gn-clie NO-LOCK WHERE gn-clie.CodCia = cl-CodCia 
        AND (gn-clie.CodCli BEGINS txt-Cliente OR txt-Cliente = "")
        AND gn-clie.CodUnico <> "":

        FOR EACH AlmtFami NO-LOCK WHERE AlmtFami.CodCia = s-CodCia 
            AND (LOOKUP(AlmtFami.CodFam,txt-CodFam) > 0 
            OR txt-CodFam = ""):
            DO k = cb-anio - 1 TO cb-anio:
                x-Year = k.
                x-Month = cb-mes.
                x-MonthEnd = cb-mes-2.
                IF x-Year = YEAR(TODAY) AND cb-mes-2 > MONTH(TODAY) 
                    THEN x-MonthEnd = MONTH(TODAY).
                REPEAT WHILE x-Month <= x-MonthEnd:
                    x-NroFchI = x-Year * 100 + x-Month.
                    FOR EACH EVTALL02 WHERE EVTALL02.codcia = s-CodCia
                        AND EVTALL02.NroFch = x-NroFchI
                        AND EVTALL02.CodDiv = gn-divi.CodDiv
                        AND EVTALL02.CodUnico = gn-clie.CodUnico 
                        AND EVTALL02.CodFam   = AlmtFami.CodFam NO-LOCK
                        BREAK BY EVTALL02.CodDiv
                             BY EVTALL02.CodUnico
                             BY EVTALL02.CodFam:
        
                        IF x-Year = cb-anio THEN DO:
                            dAmountMn[1] = dAmountMn[1] + EvtALL02.VtaxMesMn.
                            dAmountMe[1] = dAmountMe[1] + EvtALL02.VtaxMesMe.
                        END.
                        ELSE IF x-Year = (cb-anio - 1) THEN DO:
                            dAmountMn[2] = dAmountMn[2] + EvtALL02.VtaxMesMn.
                            dAmountMe[2] = dAmountMe[2] + EvtALL02.VtaxMesMe.
                        END.
        
                        IF FIRST-OF(EVTALL02.CodUnico) THEN DO:
                            FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodDiv = EVTALL02.CodDiv
                                AND ttevt-all02.ttevt-CodUnico = EVTALL02.CodUnico
                                AND ttevt-all02.ttevt-CodFam   = EVTALL02.CodFam
                                AND ttevt-all02.ttevt-NroMes = x-Month
                                NO-LOCK NO-ERROR.
                            IF NOT AVAILABLE ttevt-all02 THEN DO:
                                CREATE ttevt-all02.
                                ASSIGN
                                    ttevt-all02.ttevt-CodDiv = EVTALL02.CodDiv
                                    ttevt-all02.ttevt-CodUnico = EVTALL02.CodUnico
                                    ttevt-all02.ttevt-CodFam = EVTALL02.CodFam
                                    ttevt-all02.ttevt-nromes = x-Month
                                    ttevt-all02.ttevt-CodCli = EVTALL02.CodCli
                                    ttevt-all02.ttevt-NomCli = gn-clie.NomCli.
                            END.                        
                        END.
        
                        IF LAST-OF(EVTALL02.CodUnico) THEN DO: 
                            FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodDiv = EVTALL02.CodDiv
                                AND ttevt-all02.ttevt-CodUnico = EVTALL02.CodUnico
                                AND ttevt-all02.ttevt-CodFam   = EVTALL02.CodFam
                                AND ttevt-all02.ttevt-NroMes = x-Month
                                NO-LOCK NO-ERROR.
                            IF AVAILABLE ttevt-all02 THEN DO:
                                IF k = cb-anio THEN
                                    ASSIGN
                                        ttevt-all02.ttevt-AmountMesMn[1] = dAmountMn[1]
                                        ttevt-all02.ttevt-AmountMesMe[1] = dAmountMe[1].
                                ELSE IF (k = cb-anio - 1) THEN
                                    ASSIGN
                                        ttevt-all02.ttevt-AmountMesMn[2] = dAmountMn[2]
                                        ttevt-all02.ttevt-AmountMesMe[2] = dAmountMe[2].
                                ASSIGN
                                    ttevt-all02.ttevt-DifAmntMn[1] = (dAmountMn[1] / dAmountMn[2]) * 100
                                    ttevt-all02.ttevt-DifAmntMe[1] = (dAmountMe[1] / dAmountMe[2]) * 100.
                                IF ttevt-all02.ttevt-DifAmntMn[1] = ? THEN ttevt-all02.ttevt-DifAmntMn[1] =  100.
                                IF ttevt-all02.ttevt-DifAmntMe[1] = ? THEN ttevt-all02.ttevt-DifAmntMe[1] =  100.
                            END.
                            dAmountMn[1] = 0.
                            dAmountMe[1] = 0.
                            dAmountMn[2] = 0.
                            dAmountMe[2] = 0.                            
                        END.
                    END. /*For each evtall02...*/
                    x-Month = x-Month + 1.
                END. /*REPEAT WHILE x-Month <= x-MonthEnd...*/
            END. /*DO k = cb-anio ...*/
        END. /*FOR EACH AlmtFami ...*/
    END. /*FOR EACH gn-clie...*/
END. /*FOR EACH gn-divi...*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle-Cli-Fam B-table-Win 
PROCEDURE Carga-Detalle-Cli-Fam :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE dAmountMn AS DECIMAL EXTENT 2 NO-UNDO.
DEFINE VARIABLE dAmountMe AS DECIMAL EXTENT 2 NO-UNDO.

FOR EACH ttevt-all02:
    DELETE ttevt-all02.
END.

FOR EACH gn-clie NO-LOCK WHERE gn-clie.CodCia = cl-CodCia 
    AND (gn-clie.CodCli BEGINS txt-Cliente 
    OR txt-Cliente = "")
    AND gn-clie.CodUnico <> "":
    
    FOR EACH AlmtFami NO-LOCK WHERE AlmtFami.CodCia = s-CodCia 
        AND (LOOKUP(AlmtFami.CodFam,txt-CodFam) > 0 
        OR txt-CodFam = ""):
        DO k = cb-anio - 1 TO cb-anio:
            x-Year = k.
            x-Month = cb-mes.
            x-MonthEnd = cb-mes-2.
            IF x-Year = YEAR(TODAY) AND cb-mes-2 > MONTH(TODAY) 
                THEN x-MonthEnd = MONTH(TODAY).
            REPEAT WHILE x-Month <= x-MonthEnd:
                x-NroFchI = x-Year * 100 + x-Month.
                FOR EACH EVTALL02 WHERE EVTALL02.codcia = s-CodCia
                    AND EVTALL02.NroFch = x-NroFchI
                    AND EVTALL02.CodUnico = gn-clie.CodUnico
                    AND EVTALL02.CodFam = AlmtFami.CodFam NO-LOCK
                    BREAK BY EVTALL02.CodUnico 
                        BY EVTALL02.CodFam :
    
                    IF x-Year = cb-anio THEN DO:
                        dAmountMn[1] = dAmountMn[1] + EvtALL02.VtaxMesMn.
                        dAmountMe[1] = dAmountMe[1] + EvtALL02.VtaxMesMe.
                    END.
                    ELSE IF x-Year = (cb-anio - 1) THEN DO:
                        dAmountMn[2] = dAmountMn[2] + EvtALL02.VtaxMesMn.
                        dAmountMe[2] = dAmountMe[2] + EvtALL02.VtaxMesMe.
                    END.
    
                    IF FIRST-OF(EVTALL02.CodUnico) THEN DO:
                        FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodUnico = EVTALL02.CodUnico
                            AND ttevt-all02.ttevt-CodFam = EVTALL02.CodFam
                            AND ttevt-all02.ttevt-NroMes = x-Month
                            NO-LOCK NO-ERROR.
                        IF NOT AVAILABLE ttevt-all02 THEN DO:
                            CREATE ttevt-all02.
                            ASSIGN
                                ttevt-all02.ttevt-CodUnico = EVTALL02.CodUnico
                                ttevt-all02.ttevt-CodFam   = EVTALL02.CodFam
                                ttevt-all02.ttevt-nromes   = x-Month.
                        END.                        
                    END.
    
                    IF LAST-OF(EVTALL02.CodFam) THEN DO: 
                        FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodUnico = EVTALL02.CodUnico
                            AND ttevt-all02.ttevt-CodFam = EVTALL02.CodFam
                            AND ttevt-all02.ttevt-NroMes = x-Month
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE ttevt-all02 THEN DO:
                            IF k = cb-anio  THEN
                                ASSIGN
                                    ttevt-all02.ttevt-AmountMesMn[1] = dAmountMn[1]
                                    ttevt-all02.ttevt-AmountMesMe[1] = dAmountMe[1].
                            ELSE IF (k = cb-anio - 1) THEN
                                ASSIGN
                                    ttevt-all02.ttevt-AmountMesMn[2] = dAmountMn[2]
                                    ttevt-all02.ttevt-AmountMesMe[2] = dAmountMe[2].
                            ASSIGN
                                ttevt-all02.ttevt-DifAmntMn[1] = (dAmountMn[1] / dAmountMn[2]) * 100
                                ttevt-all02.ttevt-DifAmntMe[1] = (dAmountMe[1] / dAmountMe[2]) * 100.
                            IF ttevt-all02.ttevt-DifAmntMn[1] = ? THEN ttevt-all02.ttevt-DifAmntMn[1] =  100.
                            IF ttevt-all02.ttevt-DifAmntMe[1] = ? THEN ttevt-all02.ttevt-DifAmntMe[1] =  100.
                        END.
                        dAmountMn[1] = 0.
                        dAmountMe[1] = 0.
                        dAmountMn[2] = 0.
                        dAmountMe[2] = 0.
                    END.
                END. /*For each evtall02...*/
                x-Month = x-Month + 1.
            END. /*REPEAT WHILE x-Month ...*/
        END. /* DO k = cb-anio - 1 ...*/
    END. /*FOR EACH AlmtFami...*/
END. /*FOR EACH gn-clie...*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle-Cliente B-table-Win 
PROCEDURE Carga-Detalle-Cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE dAmountMn AS DECIMAL EXTENT 2 NO-UNDO.
DEFINE VARIABLE dAmountMe AS DECIMAL EXTENT 2 NO-UNDO.

FOR EACH ttevt-all02:
    DELETE ttevt-all02.
END.

FOR EACH gn-clie NO-LOCK WHERE gn-clie.CodCia = cl-CodCia 
    AND (gn-clie.CodCli BEGINS txt-Cliente 
    OR txt-Cliente = "")
    AND gn-clie.CodUnico <> "":
    dAmountMn[1] = 0.
    dAmountMe[1] = 0.
    dAmountMn[2] = 0.
    dAmountMe[2] = 0.
    DO k = cb-anio - 1 TO cb-anio:
        x-Year = k.
        x-Month = cb-mes.
        x-MonthEnd = cb-mes-2.
        IF x-Year = YEAR(TODAY) AND cb-mes-2 > MONTH(TODAY) 
            THEN x-MonthEnd = MONTH(TODAY).
        REPEAT WHILE x-Month <= x-MonthEnd:
            x-NroFchI = x-Year * 100 + x-Month.
            FOR EACH EVTALL02 WHERE EVTALL02.codcia = s-CodCia
                AND EVTALL02.NroFch = x-NroFchI
                AND EVTALL02.CodUnico = gn-clie.CodUnico NO-LOCK
                BREAK BY EVTALL02.CodUnico:
                IF x-Year = cb-anio THEN DO:
                    dAmountMn[1] = dAmountMn[1] + EvtALL02.VtaxMesMn.
                    dAmountMe[1] = dAmountMe[1] + EvtALL02.VtaxMesMe.
                END.
                ELSE IF x-Year = (cb-anio - 1) THEN DO:
                    dAmountMn[2] = dAmountMn[2] + EvtALL02.VtaxMesMn.
                    dAmountMe[2] = dAmountMe[2] + EvtALL02.VtaxMesMe.
                END.

                IF FIRST-OF(EVTALL02.CodUnico) THEN DO:
                    FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodUnico = EVTALL02.CodUnico
                        AND ttevt-all02.ttevt-NroMes = x-Month
                        NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE ttevt-all02 THEN DO:
                        CREATE ttevt-all02.
                        ASSIGN
                            ttevt-all02.ttevt-CodUnico = EVTALL02.CodUnico
                            ttevt-all02.ttevt-nromes = x-Month
                            ttevt-all02.ttevt-CodCli = EVTALL02.CodCli
                            ttevt-all02.ttevt-NomCli = gn-clie.NomCli.
                    END.                        
                END.

                IF LAST-OF(EVTALL02.CodUnico) THEN DO:
                    FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodUnico = EVTALL02.CodUnico
                        AND ttevt-all02.ttevt-NroMes = x-Month
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE ttevt-all02 THEN DO:
                        IF k = cb-anio THEN
                            ASSIGN
                                ttevt-all02.ttevt-AmountMesMn[1] = dAmountMn[1]
                                ttevt-all02.ttevt-AmountMesMe[1] = dAmountMe[1].
                        ELSE IF (k = cb-anio - 1) THEN
                            ASSIGN 
                                ttevt-all02.ttevt-AmountMesMn[2] = dAmountMn[2]
                                ttevt-all02.ttevt-AmountMesMe[2] = dAmountMe[2].
                        ASSIGN
                            ttevt-all02.ttevt-DifAmntMn[1] = (dAmountMn[1] / dAmountMn[2]) * 100
                            ttevt-all02.ttevt-DifAmntMe[1] = (dAmountMe[1] / dAmountMe[2]) * 100.
                        IF ttevt-all02.ttevt-DifAmntMn[1] = ? THEN ttevt-all02.ttevt-DifAmntMn[1] =  100.
                        IF ttevt-all02.ttevt-DifAmntMe[1] = ? THEN ttevt-all02.ttevt-DifAmntMe[1] =  100.
                    END.
                END.
            END. /*For each evtall02...*/
            x-Month = x-Month + 1.
        END.
    END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle-Div-Cli B-table-Win 
PROCEDURE Carga-Detalle-Div-Cli :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE dAmountMn AS DECIMAL EXTENT 2 NO-UNDO.
DEFINE VARIABLE dAmountMe AS DECIMAL EXTENT 2 NO-UNDO.

FOR EACH ttevt-all02:
    DELETE ttevt-all02.
END.

FOR EACH gn-divi NO-LOCK WHERE gn-divi.CodCia = s-CodCia 
    AND LOOKUP(gn-divi.CodDiv,txt-Division) > 0:
    
    FOR EACH gn-clie NO-LOCK WHERE gn-clie.CodCia = cl-CodCia 
        AND (gn-clie.CodCli BEGINS txt-Cliente OR txt-Cliente = "")
        AND gn-clie.CodUnico <> "":

        DO k = cb-anio - 1 TO cb-anio:
            x-Year = k.
            x-Month = cb-mes.
            x-MonthEnd = cb-mes-2.
            IF x-Year = YEAR(TODAY) AND cb-mes-2 > MONTH(TODAY) 
                THEN x-MonthEnd = MONTH(TODAY).
            REPEAT WHILE x-Month <= x-MonthEnd:
                x-NroFchI = x-Year * 100 + x-Month.
                FOR EACH EVTALL02 WHERE EVTALL02.codcia = s-CodCia
                    AND EVTALL02.NroFch = x-NroFchI
                    AND EVTALL02.CodDiv = gn-divi.CodDiv
                    AND EVTALL02.CodUnico = gn-clie.CodUnico NO-LOCK
                    BREAK BY EVTALL02.CodDiv
                         BY EVTALL02.CodUnico:
    
                    IF x-Year = cb-anio THEN DO:
                        dAmountMn[1] = dAmountMn[1] + EvtALL02.VtaxMesMn.
                        dAmountMe[1] = dAmountMe[1] + EvtALL02.VtaxMesMe.
                    END.
                    ELSE IF x-Year = (cb-anio - 1) THEN DO:
                        dAmountMn[2] = dAmountMn[2] + EvtALL02.VtaxMesMn.
                        dAmountMe[2] = dAmountMe[2] + EvtALL02.VtaxMesMe.
                    END.
    
                    IF FIRST-OF(EVTALL02.CodUnico) THEN DO:
                        FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodDiv = EVTALL02.CodDiv
                            AND ttevt-all02.ttevt-CodUnico = EVTALL02.CodUnico
                            AND ttevt-all02.ttevt-NroMes = x-Month
                            NO-LOCK NO-ERROR.
                        IF NOT AVAILABLE ttevt-all02 THEN DO:
                            CREATE ttevt-all02.
                            ASSIGN
                                ttevt-all02.ttevt-CodDiv = EVTALL02.CodDiv
                                ttevt-all02.ttevt-CodUnico = EVTALL02.CodUnico
                                ttevt-all02.ttevt-nromes = x-Month
                                ttevt-all02.ttevt-CodCli = EVTALL02.CodCli
                                ttevt-all02.ttevt-NomCli = gn-clie.NomCli.
                        END.                        
                    END.
    
                    IF LAST-OF(EVTALL02.CodUnico) THEN DO: 
                        FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodDiv = EVTALL02.CodDiv
                            AND ttevt-all02.ttevt-CodUnico = EVTALL02.CodUnico
                            AND ttevt-all02.ttevt-NroMes = x-Month
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE ttevt-all02 THEN DO:
                            IF k = cb-anio THEN
                                ASSIGN
                                    ttevt-all02.ttevt-AmountMesMn[1] = dAmountMn[1]
                                    ttevt-all02.ttevt-AmountMesMe[1] = dAmountMe[1].
                            ELSE IF (k = cb-anio - 1) THEN
                                ASSIGN
                                    ttevt-all02.ttevt-AmountMesMn[2] = dAmountMn[2]
                                    ttevt-all02.ttevt-AmountMesMe[2] = dAmountMe[2].
                            ASSIGN
                                ttevt-all02.ttevt-DifAmntMn[1] = (dAmountMn[1] / dAmountMn[2]) * 100
                                ttevt-all02.ttevt-DifAmntMe[1] = (dAmountMe[1] / dAmountMe[2]) * 100.
                            IF ttevt-all02.ttevt-DifAmntMn[1] = ? THEN ttevt-all02.ttevt-DifAmntMn[1] =  100.
                            IF ttevt-all02.ttevt-DifAmntMe[1] = ? THEN ttevt-all02.ttevt-DifAmntMe[1] =  100.
                        END.
                        dAmountMn[1] = 0.
                        dAmountMe[1] = 0.
                        dAmountMn[2] = 0.
                        dAmountMe[2] = 0.
                    END.
                END. /*For each evtall02...*/
                x-Month = x-Month + 1.
            END.
        END.
    END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle-Div-Fam B-table-Win 
PROCEDURE Carga-Detalle-Div-Fam :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE dAmountMn AS DECIMAL EXTENT 2 NO-UNDO.
DEFINE VARIABLE dAmountMe AS DECIMAL EXTENT 2 NO-UNDO.

FOR EACH ttevt-all02:
    DELETE ttevt-all02.
END.

FOR EACH gn-divi NO-LOCK WHERE gn-divi.CodCia = s-CodCia 
    AND LOOKUP(gn-divi.CodDiv,txt-Division) > 0:

    FOR EACH AlmtFam NO-LOCK WHERE AlmtFam.CodCia = gn-divi.CodCia 
        AND LOOKUP(AlmtFam.CodFam,txt-CodFam) > 0 :
        DO k = cb-anio - 1 TO cb-anio:
            x-Year = k.
            x-Month = cb-mes.
            x-MonthEnd = cb-mes-2.
            IF x-Year = YEAR(TODAY) AND cb-mes-2 > MONTH(TODAY) 
                THEN x-MonthEnd = MONTH(TODAY).
    
            REPEAT WHILE x-Month <= x-MonthEnd:
                x-NroFchI = x-Year * 100 + x-Month.
                FOR EACH EVTALL02 WHERE EVTALL02.codcia = s-CodCia
                    AND EVTALL02.NroFch = x-NroFchI
                    AND EVTALL02.CodDiv = gn-divi.CodDiv
                    AND EVTALL02.CodFam = AlmtFam.CodFam NO-LOCK
                    BREAK BY EVTALL02.CodDiv
                         BY EVTALL02.CodFam:
    
                    IF x-Year = cb-anio THEN DO:
                        dAmountMn[1] = dAmountMn[1] + EvtALL02.VtaxMesMn.
                        dAmountMe[1] = dAmountMe[1] + EvtALL02.VtaxMesMe.
                    END.
                    ELSE IF x-Year = (cb-anio - 1) THEN DO:
                        dAmountMn[2] = dAmountMn[2] + EvtALL02.VtaxMesMn.
                        dAmountMe[2] = dAmountMe[2] + EvtALL02.VtaxMesMe.
                    END.
    
                    IF FIRST-OF(EVTALL02.CodFam) THEN DO:
                        FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodDiv = EVTALL02.CodDiv
                            AND ttevt-all02.ttevt-CodFam = EVTALL02.CodFam
                            AND ttevt-all02.ttevt-NroMes = x-Month NO-LOCK NO-ERROR.
                        IF NOT AVAILABLE ttevt-all02 THEN DO:
                            CREATE ttevt-all02.
                            ASSIGN
                                ttevt-all02.ttevt-CodDiv = EVTALL02.CodDiv
                                ttevt-all02.ttevt-CodFam = EVTALL02.CodFam
                                ttevt-all02.ttevt-nromes = x-Month.
                        END.                        
                    END.
    
                    IF LAST-OF(EVTALL02.CodFam) THEN DO: 
                        FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodDiv = EVTALL02.CodDiv
                            AND ttevt-all02.ttevt-CodFam = EVTALL02.CodFam
                            AND ttevt-all02.ttevt-NroMes = x-Month NO-LOCK NO-ERROR.
                        IF AVAILABLE ttevt-all02 THEN DO:
                            IF k = cb-anio THEN
                                ASSIGN
                                    ttevt-all02.ttevt-AmountMesMn[1] = dAmountMn[1]
                                    ttevt-all02.ttevt-AmountMesMe[1] = dAmountMe[1].
                            ELSE IF (k = cb-anio - 1) THEN
                                ASSIGN
                                    ttevt-all02.ttevt-AmountMesMn[2] = dAmountMn[2]
                                    ttevt-all02.ttevt-AmountMesMe[2] = dAmountMe[2].
                            ASSIGN
                                ttevt-all02.ttevt-DifAmntMn[1] = (dAmountMn[1] / dAmountMn[2]) * 100
                                ttevt-all02.ttevt-DifAmntMe[1] = (dAmountMe[1] / dAmountMe[2]) * 100.
                            IF ttevt-all02.ttevt-DifAmntMn[1] = ? THEN ttevt-all02.ttevt-DifAmntMn[1] =  100.
                            IF ttevt-all02.ttevt-DifAmntMe[1] = ? THEN ttevt-all02.ttevt-DifAmntMe[1] =  100.
                        END.
                        dAmountMn[1] = 0.
                        dAmountMe[1] = 0.
                        dAmountMn[2] = 0.
                        dAmountMe[2] = 0.
                    END.
                END. /*For each evtall02...*/
                x-Month = x-Month + 1.
            END.
        END.
    END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle-Division B-table-Win 
PROCEDURE Carga-Detalle-Division :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE dAmountMn AS DECIMAL EXTENT 2 NO-UNDO.
DEFINE VARIABLE dAmountMe AS DECIMAL EXTENT 2 NO-UNDO.
DEFINE VARIABLE dAmAcumMn AS DECIMAL NO-UNDO.
DEFINE VARIABLE dAmAcumMe AS DECIMAL NO-UNDO.

FOR EACH ttevt-all02:
    DELETE ttevt-all02.
END.

FOR EACH gn-divi NO-LOCK WHERE gn-divi.CodCia = s-CodCia 
    AND LOOKUP(gn-divi.CodDiv,txt-Division) > 0:
    dAmountMn[1] = 0.
    dAmountMe[1] = 0.
    dAmountMn[2] = 0.
    dAmountMe[2] = 0.    

    DO k = cb-anio - 1 TO cb-anio:
        x-Year = k.
        x-Month = cb-mes.
        x-MonthEnd = cb-mes-2.
        IF x-Year = YEAR(TODAY) AND cb-mes-2 > MONTH(TODAY) 
            THEN x-MonthEnd = MONTH(TODAY).

        REPEAT WHILE x-Month <= x-MonthEnd:
            x-NroFchI = x-Year * 100 + x-Month.
            dAmAcumMn = 0.
            dAmAcumMe = 0.
            FOR EACH EVTDIVI WHERE EVTDIVI.CodCia = gn-divi.CodCia
                AND EVTDIVI.CodDiv = gn-divi.CodDiv 
                AND EVTDIVI.NroFch <= x-NroFchI 
                AND EVTDIVI.NroFch >= ((x-Year - 3 ) * 100)  NO-LOCK:
                dAmAcumMn = dAmAcumMn + EVTDIVI.VtaxMesMn.
                dAmAcumMe = dAmAcumMe + EVTDIVI.VtaxMesMe.
            END.

            FOR EACH EVTALL02 WHERE EVTALL02.codcia = gn-divi.CodCia
                AND EVTALL02.NroFch = x-NroFchI
                AND EVTALL02.CodDiv = gn-div.CodDiv NO-LOCK
                BREAK BY EVTALL02.CodDiv:

                IF x-Year = cb-anio THEN DO:
                    dAmountMn[1] = dAmountMn[1] + EvtALL02.VtaxMesMn.
                    dAmountMe[1] = dAmountMe[1] + EvtALL02.VtaxMesMe.
                END.
                ELSE IF x-Year = (cb-anio - 1) THEN DO:
                    dAmountMn[2] = dAmountMn[2] + EvtALL02.VtaxMesMn.
                    dAmountMe[2] = dAmountMe[2] + EvtALL02.VtaxMesMe.
                END.

                IF FIRST-OF(EVTALL02.CodDiv) THEN DO:
                    FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodDiv = EVTALL02.CodDiv
                        AND ttevt-all02.ttevt-NroMes = x-Month
                        NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE ttevt-all02 THEN DO:
                        CREATE ttevt-all02.
                        ASSIGN
                            ttevt-all02.ttevt-coddiv = EVTALL02.CodDiv
                            ttevt-all02.ttevt-nromes = x-Month.
                    END.                        
                END.

                IF LAST-OF(EVTALL02.CodDiv) THEN DO: 
                    /*Busca Temporal*/       
                    FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodDiv = EVTALL02.CodDiv
                        AND ttevt-all02.ttevt-NroMes = x-Month NO-LOCK NO-ERROR.        
                    IF AVAILABLE ttevt-all02 THEN DO:  
                        IF k = cb-anio THEN
                            ASSIGN
                                ttevt-all02.ttevt-AmountMesMn[1] = dAmountMn[1]
                                ttevt-all02.ttevt-AmountMesMe[1] = dAmountMe[1]
                                ttevt-all02.ttevt-AccumMn[1] = dAmAcumMn
                                ttevt-all02.ttevt-AccumMe[1] = dAmAcumMe.
                        ELSE IF (k = cb-anio - 1) THEN
                            ASSIGN 
                                ttevt-all02.ttevt-AmountMesMn[2] = dAmountMn[2]
                                ttevt-all02.ttevt-AmountMesMe[2] = dAmountMe[2]
                                ttevt-all02.ttevt-AccumMn[2] = dAmAcumMn
                                ttevt-all02.ttevt-AccumMe[2] = dAmAcumMe.
                        ASSIGN                            
                            ttevt-all02.ttevt-DifAmntMn[1] = (dAmountMn[1] / dAmountMn[2]) * 100
                            ttevt-all02.ttevt-DifAmntMe[1] = (dAmountMe[1] / dAmountMe[2]) * 100
                            ttevt-all02.ttevt-DifAmntMn[2] = 
                                (ttevt-all02.ttevt-AccumMn[1] / ttevt-all02.ttevt-AccumMn[2]) * 100
                            ttevt-all02.ttevt-DifAmntMe[2] = 
                                (ttevt-all02.ttevt-AccumMe[1] / ttevt-all02.ttevt-AccumMe[2]) * 100.

                        IF ttevt-all02.ttevt-DifAmntMn[1] = ? THEN ttevt-all02.ttevt-DifAmntMn[1] =  100.
                        IF ttevt-all02.ttevt-DifAmntMe[1] = ? THEN ttevt-all02.ttevt-DifAmntMe[1] =  100.
                        IF ttevt-all02.ttevt-DifAmntMn[2] = ? THEN ttevt-all02.ttevt-DifAmntMn[2] =  100.
                        IF ttevt-all02.ttevt-DifAmntMe[2] = ? THEN ttevt-all02.ttevt-DifAmntMe[2] =  100.
                    END.
                END.
            END. /*For each evtall02...*/
            x-Month = x-Month + 1.
        END.
    END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle-Familia B-table-Win 
PROCEDURE Carga-Detalle-Familia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE dAmountMn AS DECIMAL EXTENT 2 NO-UNDO.
DEFINE VARIABLE dAmountMe AS DECIMAL EXTENT 2 NO-UNDO.

FOR EACH ttevt-all02:
    DELETE ttevt-all02.
END.

FOR EACH AlmtFami NO-LOCK WHERE AlmtFami.CodCia = s-CodCia 
    AND (LOOKUP(AlmtFami.CodFam,txt-CodFam) > 0 
    OR txt-CodFam = ""):
    dAmountMn[1] = 0.
    dAmountMe[1] = 0.
    dAmountMn[2] = 0.
    dAmountMe[2] = 0.
    DO k = cb-anio - 1 TO cb-anio:
        x-Year = k.
        x-Month = cb-mes.
        x-MonthEnd = cb-mes-2.
        IF x-Year = YEAR(TODAY) AND cb-mes-2 > MONTH(TODAY) 
            THEN x-MonthEnd = MONTH(TODAY).
        REPEAT WHILE x-Month <= x-MonthEnd:
            x-NroFchI = x-Year * 100 + x-Month.
            FOR EACH EVTALL02 WHERE EVTALL02.codcia = s-CodCia
                AND EVTALL02.NroFch = x-NroFchI
                AND EVTALL02.CodFam = AlmtFami.CodFam NO-LOCK
                BREAK BY EVTALL02.CodFam:
                IF x-Year = cb-anio THEN DO:
                    dAmountMn[1] = dAmountMn[1] + EvtALL02.VtaxMesMn.
                    dAmountMe[1] = dAmountMe[1] + EvtALL02.VtaxMesMe.
                END.
                ELSE IF x-Year = (cb-anio - 1) THEN DO:
                    dAmountMn[2] = dAmountMn[2] + EvtALL02.VtaxMesMn.
                    dAmountMe[2] = dAmountMe[2] + EvtALL02.VtaxMesMe.
                END.

                IF FIRST-OF(EVTALL02.CodFam) THEN DO:
                    FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodFam = EVTALL02.CodFam 
                        AND ttevt-all02.ttevt-NroMes = x-Month
                        NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE ttevt-all02 THEN DO:
                        CREATE ttevt-all02.
                        ASSIGN
                            ttevt-all02.ttevt-CodFam = EVTALL02.CodFam
                            ttevt-all02.ttevt-nromes = x-Month.
                    END.                        
                END.

                IF LAST-OF(EVTALL02.CodFam) THEN DO: 
                    FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodFam = EVTALL02.CodFam 
                        AND ttevt-all02.ttevt-NroMes = x-Month
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE ttevt-all02 THEN DO:
                        IF k = cb-anio THEN
                            ASSIGN
                                ttevt-all02.ttevt-AmountMesMn[1] = dAmountMn[1]
                                ttevt-all02.ttevt-AmountMesMe[1] = dAmountMe[1].
                        ELSE IF (k = cb-anio - 1) THEN
                            ASSIGN
                                ttevt-all02.ttevt-AmountMesMn[2] = dAmountMn[2]
                                ttevt-all02.ttevt-AmountMesMe[2] = dAmountMe[2].
                        ASSIGN
                            ttevt-all02.ttevt-DifAmntMn[1] = (dAmountMn[1] / dAmountMn[2]) * 100
                            ttevt-all02.ttevt-DifAmntMe[1] = (dAmountMe[1] / dAmountMe[2]) * 100.
                        IF ttevt-all02.ttevt-DifAmntMn[1] = ? THEN ttevt-all02.ttevt-DifAmntMn[1] =  100.
                        IF ttevt-all02.ttevt-DifAmntMe[1] = ? THEN ttevt-all02.ttevt-DifAmntMe[1] =  100.
                    END.
                END.
            END. /*For each evtall02...*/
            x-Month = x-Month + 1.
        END.
    END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Divi B-table-Win 
PROCEDURE Carga-Divi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE dAmountMn AS DECIMAL EXTENT 2 NO-UNDO.
DEFINE VARIABLE dAmountMe AS DECIMAL EXTENT 2 NO-UNDO.
DEFINE VARIABLE dAmAcumMn AS DECIMAL NO-UNDO.
DEFINE VARIABLE dAmAcumMe AS DECIMAL NO-UNDO.

FOR EACH ttevt-all02:
    DELETE ttevt-all02.
END.

FOR EACH gn-divi NO-LOCK WHERE gn-divi.CodCia = s-CodCia 
    AND LOOKUP(gn-divi.CodDiv,txt-Division) > 0:
    dAmountMn[1] = 0.
    dAmountMe[1] = 0.
    dAmountMn[2] = 0.
    dAmountMe[2] = 0.    

    DO k = cb-anio - 1 TO cb-anio:
        x-Year = k.
        x-Month = cb-mes.
        x-MonthEnd = cb-mes-2.
        IF x-Year = YEAR(TODAY) AND cb-mes-2 > MONTH(TODAY) 
            THEN x-MonthEnd = MONTH(TODAY).

        REPEAT WHILE x-Month <= x-MonthEnd:
            x-NroFchI = x-Year * 100 + x-Month.
            dAmAcumMn = 0.
            dAmAcumMe = 0.
            FOR EACH EVTDIVI WHERE EVTDIVI.CodCia = gn-divi.CodCia
                AND EVTDIVI.CodDiv = gn-divi.CodDiv 
                AND EVTDIVI.NroFch <= x-NroFchI 
                AND EVTDIVI.NroFch >= ((x-Year - 3 ) * 100)  NO-LOCK:
                dAmAcumMn = dAmAcumMn + EVTDIVI.VtaxMesMn.
                dAmAcumMe = dAmAcumMe + EVTDIVI.VtaxMesMe.
            END.

            FOR EACH EVTDIVI WHERE EVTDIVI.CodCia = gn-divi.CodCia
                AND EVTDIVI.CodDiv = gn-divi.CodDiv 
                AND EVTDIVI.NroFch <= x-NroFchI NO-LOCK:
                CREATE ttevt-all02.
                ASSIGN
                    ttevt-all02.ttevt-coddiv = EVTALL02.CodDiv
                    ttevt-all02.ttevt-nromes = x-Month.
/*
                IF k = cb-anio THEN
                    ASSIGN
                        ttevt-all02.ttevt-AmountMesMn[1] = dAmountMn[1]
                        ttevt-all02.ttevt-AmountMesMe[1] = dAmountMe[1]
                        ttevt-all02.ttevt-AccumMn[1] = dAmAcumMn
                        ttevt-all02.ttevt-AccumMe[1] = dAmAcumMe.
                    ELSE IF (k = cb-anio - 1) THEN
                    ASSIGN 
                        ttevt-all02.ttevt-AmountMesMn[2] = dAmountMn[2]
                        ttevt-all02.ttevt-AmountMesMe[2] = dAmountMe[2]
                        ttevt-all02.ttevt-AccumMn[2] = dAmAcumMn
                        ttevt-all02.ttevt-AccumMe[2] = dAmAcumMe.
                    ASSIGN                            
                        ttevt-all02.ttevt-DifAmntMn[1] = (dAmountMn[1] / dAmountMn[2]) * 100
                        ttevt-all02.ttevt-DifAmntMe[1] = (dAmountMe[1] / dAmountMe[2]) * 100
                        ttevt-all02.ttevt-DifAmntMn[2] = 
                        ttevt-all02.ttevt-AccumMn[1] / ttevt-all02.ttevt-AccumMn[2]) * 100
                        ttevt-all02.ttevt-DifAmntMe[2] = 
                        (ttevt-all02.ttevt-AccumMe[1] / ttevt-all02.ttevt-AccumMe[2]) * 100.
                
                                        IF ttevt-all02.ttevt-DifAmntMn[1] = ? THEN ttevt-all02.ttevt-DifAmntMn[1] =  100.
                                        IF ttevt-all02.ttevt-DifAmntMe[1] = ? THEN ttevt-all02.ttevt-DifAmntMe[1] =  100.
                                        IF ttevt-all02.ttevt-DifAmntMn[2] = ? THEN ttevt-all02.ttevt-DifAmntMn[2] =  100.
                                        IF ttevt-all02.ttevt-DifAmntMe[2] = ? THEN ttevt-all02.ttevt-DifAmntMe[2] =  100.*/
                                
                            END.



/*
            FOR EACH EVTALL02 WHERE EVTALL02.codcia = gn-divi.CodCia
                AND EVTALL02.NroFch = x-NroFchI
                AND EVTALL02.CodDiv = gn-div.CodDiv NO-LOCK
                BREAK BY EVTALL02.CodDiv:

                IF x-Year = cb-anio THEN DO:
                    dAmountMn[1] = dAmountMn[1] + EvtALL02.VtaxMesMn.
                    dAmountMe[1] = dAmountMe[1] + EvtALL02.VtaxMesMe.
                END.
                ELSE IF x-Year = (cb-anio - 1) THEN DO:
                    dAmountMn[2] = dAmountMn[2] + EvtALL02.VtaxMesMn.
                    dAmountMe[2] = dAmountMe[2] + EvtALL02.VtaxMesMe.
                END.

                IF FIRST-OF(EVTALL02.CodDiv) THEN DO:
                    FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodDiv = EVTALL02.CodDiv
                        AND ttevt-all02.ttevt-NroMes = x-Month
                        NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE ttevt-all02 THEN DO:
                        CREATE ttevt-all02.
                        ASSIGN
                            ttevt-all02.ttevt-coddiv = EVTALL02.CodDiv
                            ttevt-all02.ttevt-nromes = x-Month.
                    END.                        
                END.

                IF LAST-OF(EVTALL02.CodDiv) THEN DO: 
                    /*Busca Temporal*/       
                    FIND FIRST ttevt-all02 WHERE ttevt-all02.ttevt-CodDiv = EVTALL02.CodDiv
                        AND ttevt-all02.ttevt-NroMes = x-Month NO-LOCK NO-ERROR.        
                    IF AVAILABLE ttevt-all02 THEN DO:  
                        IF k = cb-anio THEN
                            ASSIGN
                                ttevt-all02.ttevt-AmountMesMn[1] = dAmountMn[1]
                                ttevt-all02.ttevt-AmountMesMe[1] = dAmountMe[1]
                                ttevt-all02.ttevt-AccumMn[1] = dAmAcumMn
                                ttevt-all02.ttevt-AccumMe[1] = dAmAcumMe.
                        ELSE IF (k = cb-anio - 1) THEN
                            ASSIGN 
                                ttevt-all02.ttevt-AmountMesMn[2] = dAmountMn[2]
                                ttevt-all02.ttevt-AmountMesMe[2] = dAmountMe[2]
                                ttevt-all02.ttevt-AccumMn[2] = dAmAcumMn
                                ttevt-all02.ttevt-AccumMe[2] = dAmAcumMe.
                        ASSIGN                            
                            ttevt-all02.ttevt-DifAmntMn[1] = (dAmountMn[1] / dAmountMn[2]) * 100
                            ttevt-all02.ttevt-DifAmntMe[1] = (dAmountMe[1] / dAmountMe[2]) * 100
                            ttevt-all02.ttevt-DifAmntMn[2] = 
                                (ttevt-all02.ttevt-AccumMn[1] / ttevt-all02.ttevt-AccumMn[2]) * 100
                            ttevt-all02.ttevt-DifAmntMe[2] = 
                                (ttevt-all02.ttevt-AccumMe[1] / ttevt-all02.ttevt-AccumMe[2]) * 100.

                        IF ttevt-all02.ttevt-DifAmntMn[1] = ? THEN ttevt-all02.ttevt-DifAmntMn[1] =  100.
                        IF ttevt-all02.ttevt-DifAmntMe[1] = ? THEN ttevt-all02.ttevt-DifAmntMe[1] =  100.
                        IF ttevt-all02.ttevt-DifAmntMn[2] = ? THEN ttevt-all02.ttevt-DifAmntMn[2] =  100.
                        IF ttevt-all02.ttevt-DifAmntMe[2] = ? THEN ttevt-all02.ttevt-DifAmntMe[2] =  100.
                    END.
                END.
            END. /*For each evtall02...*/   */
            x-Month = x-Month + 1.
        END.
    END.
END.
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
    chWorkSheet:Range(cRange):Value = "División".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Mes".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod. Unico".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod. Cliente".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nombre".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Familia".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Monto Mes Año1 (S/.)".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Monto Mes Año1 ($)".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Monto Mes Año2 (S/.)".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Monto Mes Año2 ($)".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Acumulado Año1 (S/.)".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "Acumulado Año1 ($)".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "Acumulado Año2 (S/.)".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "Acumulado Año2 ($)".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "Dif. Mes Año1 (S/.)".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "Dif. Mes Año2 ($)".
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = "Dif. Acum Año1 ($)".
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = "Dif. Acum Año2 ($)".
    iCount = iCount + 1.

    FOR EACH ttevt-all02 NO-LOCK:
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-CodDiv.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-nromes.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-CodUnico.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-codcli.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-nomcli.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-codfam.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-AmountMesMn[1].
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-AmountMesMe[1].
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-AmountMesMn[2].
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-AmountMesMe[2].
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-AccumMn[1].
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-AccumMe[1].
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-AccumMn[2].
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-AccumMe[2].
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-DifAmntMn[1].
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-DifAmntMe[1].
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-DifAmntMe[2].
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):Value = ttevt-DifAmntMe[2].
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

      DO iInt = 2  TO 12:
          cb-mes-2:ADD-LAST(STRING(iInt)). 
      END.
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

