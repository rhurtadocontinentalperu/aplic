&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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
DEFINE SHARED VAR s-CodCia  AS INTEGER.
DEFINE SHARED VAR cl-codcia AS INTEGER.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE lCarga AS LOGICAL INIT NO NO-UNDO.
DEF SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VARIABLE cPeriodos AS CHARACTER   NO-UNDO INIT '01,02,03'.
DEFINE VARIABLE x-Periodo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cMeses AS CHARACTER NO-UNDO EXTENT 13.
cMeses[1]  =  "Enero".
cMeses[2]  =  "Febrero".
cMeses[3]  =  "Marzo".
/*cMeses[4] = "Total".*/
cMeses[4]  =  "Abril".
cMeses[5]  =  "Mayo".
cMeses[6]  =  "Junio".
cMeses[7]  =  "Julio".
cMeses[8]  =  "Agosto".
cMeses[9]  =  "Setiembre".
cMeses[10] =  "Octubre".
cMeses[11] =  "Noviembre".
cMeses[12] =  "Diciembre".
cMeses[13] =  "Total".


/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE tmp-EvtAll99 NO-UNDO
    FIELDS tmp-periodo   LIKE evtall99.codmes
    FIELDS tmp-codmes    LIKE evtall99.codmes
    FIELDS tmp-nommes    AS CHARACTER
    FIELDS tmp-Amount    AS DECIMAL EXTENT 5
    FIELDS tmp-AmountMe  AS DECIMAL EXTENT 5
    FIELDS tmp-Porcen    AS DECIMAL EXTENT 5
    FIELDS tmp-PorcenMe  AS DECIMAL EXTENT 5.

DEFINE TEMP-TABLE tm-Clientes NO-UNDO
    FIELDS tm-codcli   LIKE evtall99.codcli    
    FIELDS tm-nomcli   LIKE gn-clie.nomcli
    FIELDS tm-Amount    AS DECIMAL EXTENT 5
    FIELDS tm-AmountMe  AS DECIMAL EXTENT 5
    FIELDS tm-Porcen    AS DECIMAL EXTENT 5
    FIELDS tm-PorcenMe  AS DECIMAL EXTENT 5.

DEFINE TEMP-TABLE ttm-Familia NO-UNDO
    FIELDS ttm-codfam    LIKE evtall99.codfam    
    FIELDS ttm-desfam    LIKE AlmtFam.DesFam
    FIELDS ttm-Amount    AS DECIMAL EXTENT 5
    FIELDS ttm-AmountMe  AS DECIMAL EXTENT 5
    FIELDS ttm-Porcen    AS DECIMAL EXTENT 5
    FIELDS ttm-PorcenMe  AS DECIMAL EXTENT 5.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tmp-EvtAll99 tm-Clientes ttm-Familia

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tmp-NomMes tmp-Amount[1] tmp-Amount[2] tmp-Porcen[1] tmp-Amount[3] tmp-Porcen[2] tmp-Amount[4] tmp-Porcen[3] tmp-Amount[5]   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2   
&Scoped-define SELF-NAME BROWSE-2
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tmp-EvtAll99 BREAK BY tmp-EvtAll99.tmp-codmes
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY {&SELF-NAME} FOR EACH tmp-EvtAll99 BREAK BY tmp-EvtAll99.tmp-codmes.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tmp-EvtAll99
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tmp-EvtAll99


/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 tm-CodCli tm-nomcli tm-Amount[1] tm-Amount[2] tm-Amount[3] tm-Amount[4]   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4   
&Scoped-define SELF-NAME BROWSE-4
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH tm-Clientes
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY {&SELF-NAME} FOR EACH tm-Clientes .
&Scoped-define TABLES-IN-QUERY-BROWSE-4 tm-Clientes
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 tm-Clientes


/* Definitions for BROWSE BROWSE-6                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-6 ttm-CodFam ttm-desfam ttm-Amount[1] ttm-Porcen[1] ttm-Amount[2] ttm-Porcen[2] ttm-Amount[3] ttm-Porcen[3] ttm-Amount[4] ttm-Porcen[4]   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-6   
&Scoped-define SELF-NAME BROWSE-6
&Scoped-define QUERY-STRING-BROWSE-6 FOR EACH ttm-Familia BREAK BY ttm-codfam
&Scoped-define OPEN-QUERY-BROWSE-6 OPEN QUERY {&SELF-NAME} FOR EACH ttm-Familia BREAK BY ttm-codfam.
&Scoped-define TABLES-IN-QUERY-BROWSE-6 ttm-Familia
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-6 ttm-Familia


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-4}~
    ~{&OPEN-QUERY-BROWSE-6}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-2 btn-Excel BUTTON-5 txt-cliente ~
cb-periodos b-busca BROWSE-2 BROWSE-6 
&Scoped-Define DISPLAYED-OBJECTS txt-cliente txt-nomcli cb-periodos 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-busca 
     LABEL "..." 
     SIZE 3 BY .81.

DEFINE BUTTON btn-Excel 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 6" 
     SIZE 8 BY 2.15.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "adeicon/admin%.ico":U
     LABEL "Button 2" 
     SIZE 8 BY 2.15.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "IMG/exit.ico":U
     LABEL "Button 5" 
     SIZE 8 BY 2.15.

DEFINE VARIABLE cb-periodos AS CHARACTER FORMAT "X(256)":U INITIAL "01,02,03" 
     LABEL "Meses" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE txt-cliente AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txt-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tmp-EvtAll99 SCROLLING.

DEFINE QUERY BROWSE-4 FOR 
      tm-Clientes SCROLLING.

DEFINE QUERY BROWSE-6 FOR 
      ttm-Familia SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _FREEFORM
  QUERY BROWSE-2 DISPLAY
      tmp-NomMes       COLUMN-LABEL "Mes" FORMAT "X(10)"
    tmp-Amount[1] COLUMN-LABEL "2006"  FORMAT "->>,>>>,>>>,>>9.99"    
    tmp-Amount[2] COLUMN-LABEL "2007"  FORMAT "->>,>>>,>>>,>>9.99"
    tmp-Porcen[1] COLUMN-LABEL "%"     FORMAT "->>,>>9.99"
    tmp-Amount[3] COLUMN-LABEL "2008"  FORMAT "->>,>>>,>>>,>>9.99"
    tmp-Porcen[2] COLUMN-LABEL "%"     FORMAT "->>,>>9.99"
    tmp-Amount[4] COLUMN-LABEL "2009"  FORMAT "->>,>>>,>>>,>>9.99"
    tmp-Porcen[3] COLUMN-LABEL "%"     FORMAT "->>,>>9.99"
    tmp-Amount[5] COLUMN-LABEL "Total" FORMAT "->>,>>>,>>>,>>9.99"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 104 BY 5.38
         FONT 1
         TITLE "Clientes" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _FREEFORM
  QUERY BROWSE-4 DISPLAY
      tm-CodCli       COLUMN-LABEL "Codigo" FORMAT "X(13)"
    tm-nomcli    COLUMN-LABEL "Cliente" FORMAT "X(40)"
    tm-Amount[1] COLUMN-LABEL "2006"  FORMAT "->,>>>,>>>,>>9.99"
    tm-Amount[2] COLUMN-LABEL "2007"  FORMAT "->,>>>,>>>,>>9.99"
    tm-Amount[3] COLUMN-LABEL "2008"  FORMAT "->,>>>,>>>,>>9.99"
    tm-Amount[4] COLUMN-LABEL "2009"  FORMAT "->,>>>,>>>,>>9.99"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 91 BY 7.96
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-6 W-Win _FREEFORM
  QUERY BROWSE-6 DISPLAY
      ttm-CodFam       COLUMN-LABEL "Fam" FORMAT "X(3)"
    ttm-desfam    COLUMN-LABEL "Descripción" FORMAT "X(35)"
    ttm-Amount[1] COLUMN-LABEL "2006" FORMAT "->>>,>>>,>>9.99"
    ttm-Porcen[1] COLUMN-LABEL "%"    FORMAT "->>9.9999"
    ttm-Amount[2] COLUMN-LABEL "2007" FORMAT "->>>,>>>,>>9.99"
    ttm-Porcen[2] COLUMN-LABEL "%"    FORMAT "->>9.9999"
    ttm-Amount[3] COLUMN-LABEL "2008" FORMAT "->>>,>>>,>>9.99"
    ttm-Porcen[3] COLUMN-LABEL "%"    FORMAT "->>9.9999"
    ttm-Amount[4] COLUMN-LABEL "2009" FORMAT "->>>,>>>,>>9.99"
    ttm-Porcen[4] COLUMN-LABEL "%"    FORMAT "->>9.9999"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 108 BY 7.96
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-2 AT ROW 1.08 COL 84.72 WIDGET-ID 2
     btn-Excel AT ROW 1.08 COL 93 WIDGET-ID 12
     BUTTON-5 AT ROW 1.08 COL 101.29 WIDGET-ID 10
     txt-cliente AT ROW 1.35 COL 7.57 COLON-ALIGNED WIDGET-ID 6
     txt-nomcli AT ROW 1.35 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     cb-periodos AT ROW 2.35 COL 7.57 COLON-ALIGNED WIDGET-ID 30
     b-busca AT ROW 2.35 COL 53.57 WIDGET-ID 28
     BROWSE-2 AT ROW 3.46 COL 3 WIDGET-ID 200
     BROWSE-6 AT ROW 10.54 COL 5 WIDGET-ID 400
     BROWSE-4 AT ROW 10.54 COL 5 WIDGET-ID 300
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 117.29 BY 18.35
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Estadistica de Ventas - Campaña"
         HEIGHT             = 18.35
         WIDTH              = 117.29
         MAX-HEIGHT         = 18.35
         MAX-WIDTH          = 117.29
         VIRTUAL-HEIGHT     = 18.35
         VIRTUAL-WIDTH      = 117.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 b-busca F-Main */
/* BROWSE-TAB BROWSE-6 BROWSE-2 F-Main */
/* BROWSE-TAB BROWSE-4 BROWSE-6 F-Main */
/* SETTINGS FOR BROWSE BROWSE-4 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BROWSE-4:HIDDEN  IN FRAME F-Main                = TRUE.

/* SETTINGS FOR FILL-IN txt-nomcli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tmp-EvtAll99 BREAK BY tmp-EvtAll99.tmp-codmes.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tm-Clientes .
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-6
/* Query rebuild information for BROWSE BROWSE-6
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttm-Familia BREAK BY ttm-codfam.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Estadistica de Ventas - Campaña */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Estadistica de Ventas - Campaña */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-busca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-busca W-Win
ON CHOOSE OF b-busca IN FRAME F-Main /* ... */
DO:
    RUN vta/d-periodos (INPUT-OUTPUT x-periodo).
    cPeriodos = x-periodo. 
    cb-periodos = x-periodo.
    DISPLAY cPeriodos @ cb-periodos WITH FRAME {&FRAME-NAME}.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-Excel W-Win
ON CHOOSE OF btn-Excel IN FRAME F-Main /* Button 6 */
DO:
  ASSIGN txt-cliente.
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO: 
    
    RUN Borra-Temporales.
    ASSIGN 
        txt-cliente.
    IF txt-cliente <> '' THEN DO:
        RUN Carga-Temporal.
        {&OPEN-QUERY-BROWSE-2}

        /*Familia*/
        RUN Carga-Temporalc.
        {&OPEN-QUERY-BROWSE-6}

        /*Cliente*/
        RUN Carga-Temporalb.
        {&OPEN-QUERY-BROWSE-4}
    END.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 5 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-periodos
&Scoped-define SELF-NAME txt-cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-cliente W-Win
ON LEAVE OF txt-cliente IN FRAME F-Main /* Cliente */
DO:
  FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.CodUnico = INPUT {&SELF-NAME} NO-LOCK NO-ERROR.
  IF AVAIL gn-clie THEN DISPLAY gn-clie.NomCli @ txt-nomcli WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm/objects/folder.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'FOLDER-LABELS = ':U + 'Familia|Clientes' + ',
                     FOLDER-TAB-TYPE = 1':U ,
             OUTPUT h_folder ).
       RUN set-position IN h_folder ( 9.19 , 3.00 ) NO-ERROR.
       RUN set-size IN h_folder ( 9.85 , 112.00 ) NO-ERROR.

       /* Links to SmartFolder h_folder. */
       RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
             BROWSE-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporales W-Win 
PROCEDURE Borra-Temporales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tmp-evtall99:
        DELETE tmp-evtall99.
    END.
    FOR EACH tm-Clientes:
        DELETE tm-Clientes.
    END.
    FOR EACH ttm-Familia:
        DELETE ttm-Familia.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE PeriodoInicio AS INTEGER   NO-UNDO.
    DEFINE VARIABLE dTotal        AS DECIMAL   NO-UNDO EXTENT 5.

    FIND FIRST EvtAll99 WHERE EvtAll99.CodCia = s-codcia NO-LOCK NO-ERROR.
    IF AVAIL EvtAll99 THEN PeriodoInicio = EvtAll99.CodAno.

    FOR EACH EvtAll99 WHERE EvtAll99.CodCia = s-CodCia
        AND EvtAll99.CodUnico = txt-cliente
/*RD01 - Selección Múltiple Periodos*/
        AND LOOKUP(STRING(EvtAll99.CodMes,"99"),cPeriodos) > 0 NO-LOCK
        BREAK BY EvtAll99.Codano
              BY EvtAll99.CodMes:
        FIND FIRST tmp-EvtAll99 WHERE tmp-Evtall99.tmp-codmes = EvtAll99.Codmes NO-LOCK NO-ERROR.
        IF NOT AVAILABLE tmp-EvtAll99 THEN DO:
            CREATE tmp-EvtAll99.
            ASSIGN 
                tmp-codmes  = evtall99.codmes
                tmp-nommes  = cMeses[evtall99.codmes].
        END.
        CASE (EvtAll99.CodAno):
            WHEN (PeriodoInicio) THEN DO: 
                ASSIGN tmp-Amount[1] = tmp-Amount[1] + EvtAll99.VtaxMesMn.          
                dTotal[1] = dTotal[1] + EvtAll99.VtaxMesMn.
            END.
            WHEN (PeriodoInicio + 1 ) THEN DO: 
                ASSIGN tmp-Amount[2] = tmp-Amount[2] + EvtAll99.VtaxMesMn.
                dTotal[2] = dTotal[2] + EvtAll99.VtaxMesMn.
            END.
            WHEN (PeriodoInicio + 2 ) THEN DO: 
                ASSIGN tmp-Amount[3] = tmp-Amount[3] + EvtAll99.VtaxMesMn.
                dTotal[3] = dTotal[3] + EvtAll99.VtaxMesMn.
            END.
            WHEN (PeriodoInicio + 3 ) THEN DO: 
                ASSIGN tmp-Amount[4] = tmp-Amount[4] + EvtAll99.VtaxMesMn.
                dTotal[4] = dTotal[4] + EvtAll99.VtaxMesMn.
            END.
        END CASE.

        IF LAST-OF(EvtAll99.CodMes) THEN DO:
            ASSIGN 
                tmp-nommes  = cMeses[tmp-codmes]
                tmp-Amount[5] = tmp-Amount[1] + tmp-Amount[2] + tmp-Amount[3] + tmp-Amount[4]
                tmp-Porcen[1] = tmp-Amount[2] / tmp-Amount[1] * 100
                tmp-Porcen[2] = tmp-Amount[3] / tmp-Amount[2] * 100
                tmp-Porcen[3] = tmp-Amount[4] / tmp-Amount[3] * 100.
                dTotal[5] = (dTotal[1] + dTotal[2] + dTotal[3] + dTotal[4]).
        END.

        IF LAST(EvtAll99.Codano) THEN DO:
            CREATE tmp-evtall99.
            ASSIGN 
                tmp-codmes  = 13
                tmp-nommes  = cMeses[tmp-codmes]
                tmp-Amount[1] = dTotal[1]
                tmp-Amount[2] = dTotal[2]
                tmp-Amount[3] = dTotal[3]
                tmp-Amount[4] = dTotal[4]
                tmp-Amount[5] = dTotal[5]
                tmp-Porcen[1] = dTotal[2] / dTotal[1] * 100
                tmp-Porcen[2] = dTotal[3] / dTotal[2] * 100
                tmp-Porcen[3] = dTotal[4] / dTotal[3] * 100.
        END.            
    END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporalb W-Win 
PROCEDURE Carga-Temporalb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i AS INTEGER     NO-UNDO.
    DEFINE VARIABLE PeriodoInicio AS INTEGER     NO-UNDO.

    FIND FIRST EvtAll99 WHERE EvtAll99.CodCia = s-codcia NO-LOCK NO-ERROR.
    IF AVAIL EvtAll99 THEN PeriodoInicio = EvtAll99.CodAno.
    
    FOR EACH EvtAll99 WHERE EvtAll99.CodCia = s-CodCia
/*RD01 - Selección Múltiple Periodos*/
        AND LOOKUP(STRING(EvtAll99.CodMes,"99"),cPeriodos) > 0 
        AND EvtAll99.CodUnico = txt-cliente NO-LOCK
        BREAK BY EvtAll99.CodCli 
            BY EvtAll99.Codano:
        FIND FIRST tm-Clientes WHERE tm-Clientes.tm-codcli = EvtAll99.Codcli NO-LOCK NO-ERROR.
        IF NOT AVAILABLE tm-Clientes THEN DO:
            FIND FIRST gn-clie WHERE gn-clie.CodCia = cl-codcia
                AND gn-clie.CodCli = evtall99.codcli NO-LOCK NO-ERROR.
            CREATE tm-Clientes.
            ASSIGN 
                tm-codcli  = evtall99.codcli
                tm-nomcli  = gn-clie.nomcli.
        END.
        CASE (EvtAll99.CodAno):
            WHEN (PeriodoInicio) 
                THEN ASSIGN tm-Amount[1] = tm-Amount[1] + EvtAll99.VtaxMesMn.                
            WHEN (PeriodoInicio + 1 ) 
                THEN ASSIGN tm-Amount[2] = tm-Amount[2] + EvtAll99.VtaxMesMn.                
            WHEN (PeriodoInicio + 2 ) 
                THEN ASSIGN tm-Amount[3] = tm-Amount[3] + EvtAll99.VtaxMesMn.                
            WHEN (PeriodoInicio + 3 ) 
                THEN ASSIGN tm-Amount[4] = tm-Amount[4] + EvtAll99.VtaxMesMn.                
        END CASE.
    END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporalc W-Win 
PROCEDURE Carga-Temporalc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE PeriodoInicio AS INTEGER   NO-UNDO.
    DEFINE VARIABLE dTotal        AS DECIMAL   NO-UNDO EXTENT 5.
    DEFINE VARIABLE i             AS INTEGER   NO-UNDO INIT 1.

    FIND FIRST EvtAll99 WHERE EvtAll99.CodCia = s-codcia NO-LOCK NO-ERROR.
    IF AVAIL EvtAll99 THEN PeriodoInicio = EvtAll99.CodAno.
    
    FOR EACH EvtAll99 WHERE EvtAll99.CodCia = s-CodCia
        AND EvtAll99.CodUnico = txt-Cliente 
/*RD01 - Selección Múltiple Periodos*/
        AND LOOKUP(STRING(EvtAll99.CodMes,"99"),cPeriodos) > 0 NO-LOCK
        BREAK BY EvtAll99.CodCli 
            BY EvtAll99.Codano
            BY EvtAll99.CodFam:
        FIND FIRST ttm-Familia WHERE ttm-Familia.ttm-codfam = EvtAll99.Codfam NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ttm-Familia THEN DO:
            FIND FIRST AlmtFami WHERE AlmtFami.CodCia = s-codcia
                AND AlmtFami.CodFam = evtall99.codfam NO-LOCK NO-ERROR.
            CREATE ttm-Familia.
            ASSIGN 
                ttm-codfam  = evtall99.codfam
                ttm-desfam  = AlmtFami.DesFam.
        END.

        FIND FIRST tmp-evtall99 WHERE tmp-evtall99.tmp-nommes = "Total" NO-LOCK NO-ERROR.

        CASE (EvtAll99.CodAno):
            WHEN (PeriodoInicio) THEN DO:
                ASSIGN ttm-Amount[1] = ttm-Amount[1] + EvtAll99.VtaxMesMn.
                dTotal[1] = dTotal[1] + EvtAll99.VtaxMesMn.                
            END.                 
            WHEN (PeriodoInicio + 1 ) THEN DO: 
                ASSIGN ttm-Amount[2] = ttm-Amount[2] + EvtAll99.VtaxMesMn.
                dTotal[2] = dTotal[2] + EvtAll99.VtaxMesMn.
            END.
            WHEN (PeriodoInicio + 2 ) THEN DO: 
                ASSIGN ttm-Amount[3] = ttm-Amount[3] + EvtAll99.VtaxMesMn.
                dTotal[3] = dTotal[3] + EvtAll99.VtaxMesMn.
            END.
            WHEN (PeriodoInicio + 3 ) THEN DO: 
                ASSIGN ttm-Amount[4] = ttm-Amount[4] + EvtAll99.VtaxMesMn.                
                dTotal[4] = dTotal[4] + EvtAll99.VtaxMesMn.
            END.
        END CASE.         

        IF LAST-OF(EvtAll99.CodFam) THEN DO:
            FIND FIRST tmp-evtall99 WHERE tmp-evtall99.tmp-nommes = "Total" NO-LOCK NO-ERROR.
            IF AVAILABLE tmp-evtall99 THEN DO:
                CASE (EvtAll99.CodAno):
                    WHEN (PeriodoInicio) 
                        THEN ASSIGN ttm-Porcen[1] = ttm-Amount[1] / tmp-evtall99.tmp-Amount[1] * 100.
                    WHEN (PeriodoInicio + 1 ) 
                        THEN ASSIGN ttm-Porcen[2] = ttm-Amount[2] / tmp-evtall99.tmp-Amount[2] * 100.
                    WHEN (PeriodoInicio + 2 ) 
                        THEN ASSIGN ttm-Porcen[3] = ttm-Amount[3] / tmp-evtall99.tmp-Amount[3] * 100.
                    WHEN (PeriodoInicio + 3 ) 
                        THEN ASSIGN ttm-Porcen[4] = ttm-Amount[4] / tmp-evtall99.tmp-Amount[4] * 100. 
                END CASE.                       
            END.
      
        END.

        IF LAST(EvtAll99.CodCli) THEN DO:
            CREATE ttm-Familia.
            ASSIGN 
                ttm-codfam  = "999"
                ttm-desfam  = "Total"
                ttm-Amount[1] = dTotal[1]
                ttm-Amount[2] = dTotal[2]
                ttm-Amount[3] = dTotal[3]
                ttm-Amount[4] = dTotal[4]
                ttm-Porcen[1] = dTotal[1] / tmp-evtall99.tmp-Amount[1] * 100
                ttm-Porcen[2] = dTotal[2] / tmp-evtall99.tmp-Amount[2] * 100
                ttm-Porcen[3] = dTotal[3] / tmp-evtall99.tmp-Amount[3] * 100
                ttm-Porcen[4] = dTotal[4] / tmp-evtall99.tmp-Amount[4] * 100.
        END.
    END. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY txt-cliente txt-nomcli cb-periodos 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-2 btn-Excel BUTTON-5 txt-cliente cb-periodos b-busca BROWSE-2 
         BROWSE-6 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
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
    chWorkSheet:Range(cRange):Value = "ESTADISTICAS DE VENTAS - CAMPAÑA".

    /* set the column names for the Worksheet */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod.Unico".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod.Cliente".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nombre o Razón Social".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Año".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Mes".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod.Fam".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Ventas S/.".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Ventas $".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cantidad x Mes".
    iCount = iCount + 1.

    /*Formato*/
    chWorkSheet:Columns("A"):NumberFormat = "@".
    chWorkSheet:Columns("B"):NumberFormat = "@".
    chWorkSheet:Columns("D"):NumberFormat = "@".
    chWorkSheet:Columns("E"):NumberFormat = "@".
    chWorkSheet:Columns("F"):NumberFormat = "@".

    FOR EACH EvtAll99 WHERE Evtall99.CodCia = s-CodCia
        AND EvtAll99.CodUnico = txt-cliente NO-LOCK:
        FIND FIRST gn-clie WHERE gn-clie.CodCia = cl-CodCia
            AND gn-clie.CodCli = txt-Cliente NO-LOCK NO-ERROR.

        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = evtall99.codunico.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = evtall99.codcli.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = gn-clie.nomcli.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = EvtALL99.Codano.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = EvtALL99.Codmes.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = EvtALL99.CodFam.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = EvtALL99.VtaxMesMn.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = EvtALL99.VtaxMesMe.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = EvtALL99.CanxMes.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-change-page W-Win 
PROCEDURE local-change-page :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page AS INTEGER     NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'change-page':U ) .

  /* Code placed here will execute AFTER standard behavior.    */  

  RUN GET-ATTRIBUTE IN THIS-PROCEDURE ('current-page':U ) .
  adm-current-page = INTEGER(RETURN-VALUE).
  CASE adm-current-page:
      WHEN 1 THEN DO:
          
          ENABLE BROWSE-6 WITH FRAME {&FRAME-NAME}.
          BROWSE-4:HIDDEN IN FRAME {&FRAME-NAME} = FALSE.
          {&OPEN-QUERY-BROWSE-6} 
          DISABLE BROWSE-4 WITH FRAME {&FRAME-NAME}.
          BROWSE-4:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.
      END.
      WHEN 2 THEN DO:
          
          ENABLE BROWSE-4 WITH FRAME {&FRAME-NAME}.
          BROWSE-4:HIDDEN IN FRAME {&FRAME-NAME} = FALSE.
          {&OPEN-QUERY-BROWSE-4}
          DISABLE BROWSE-6 WITH FRAME {&FRAME-NAME}.
          BROWSE-6:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.
      END.
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle W-Win 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER L-Handle AS CHAR.
    /*
    CASE L-Handle:
        WHEN "Pagina1"  THEN DO WITH FRAME {&FRAME-NAME}:
             RUN select-page(1).
             RUN Carga-Datos IN h_b-estvtas-2.
             RUN adm-open-query IN h_b-estvtas-2.
          END.
        WHEN "Pagina2"  THEN DO WITH FRAME {&FRAME-NAME}:
             RUN select-page(2).
             RUN Carga-Data IN h_b-estfam-2.
             RUN adm-open-query IN h_b-estfam-2.
          END.
        WHEN "disable" THEN DO:
    /*         RUN adm-disable IN h_p-updv04. */
          END.
        WHEN "enable" THEN DO:
    /*         RUN adm-enable IN h_p-updv04. */
          END.
    END CASE.*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
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
        WHEN "" THEN .
    END CASE.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "ttm-Familia"}
  {src/adm/template/snd-list.i "tm-Clientes"}
  {src/adm/template/snd-list.i "tmp-EvtAll99"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

