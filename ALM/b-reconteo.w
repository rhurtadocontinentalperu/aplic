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
DEFINE SHARED VAR s-codalm  AS CHARACTER.

DEFINE VARIABLE cConfi  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dQtyDif AS DECIMAL     NO-UNDO.
DEFINE VARIABLE iCant   AS INTEGER     NO-UNDO INIT 0.
DEFINE VARIABLE cArti   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dQtyCon AS DECIMAL     NO-UNDO.
DEFINE VARIABLE cFiltro AS CHARACTER   NO-UNDO.

DEFINE VARIABLE s-task-no AS INTEGER  NO-UNDO.

DEFINE BUFFER tmp-tt-AlmDInv FOR tt-AlmDInv.
DEFINE TEMP-TABLE tt-Datos LIKE tmp-tt-AlmDInv.

&SCOPED-DEFINE FILTRO1 (((tt-AlmDInv.QtyConteo - tt-AlmDInv.QtyFisico) <> 0 AND ~
            (tt-AlmDInv.QtyReconteo - tt-AlmDInv.QtyFisico) <> 0) OR ~
            ((tt-AlmDInv.QtyConteo - tt-AlmDInv.QtyFisico) <> 0 AND tt-AlmDInv.QtyFisico = 0))
&SCOPED-DEFINE FILTRO2 (tt-AlmDInv.CodCia = s-CodCia )

DEFINE VARIABLE lSave AS LOGICAL  NO-UNDO.

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
&Scoped-define FIELDS-IN-QUERY-br_table tt-AlmDInv.NroSecuencia ~
tt-AlmDInv.CodUbi tt-AlmDInv.codmat Almmmatg.DesMat Almmmatg.DesMar ~
Almmmatg.UndBas tt-AlmDInv.QtyConteo tt-AlmDInv.QtyReconteo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table tt-AlmDInv.QtyReconteo 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table tt-AlmDInv
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table tt-AlmDInv
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
&Scoped-Define ENABLED-OBJECTS RECT-67 RECT-68 RECT-69 txt-page ~
btn-consulta txt-codalmac br_table btn-exit-2 btn-ingresa btn-lista ~
btn-grabar btn-cancelar 
&Scoped-Define DISPLAYED-OBJECTS txt-codalm txt-desalm txt-page ~
txt-codalmac txt-totpag 

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
DEFINE BUTTON btn-cancelar 
     IMAGE-UP FILE "IMG/b-cancel.bmp":U
     LABEL "Ingresa Cantidades" 
     SIZE 14 BY 1.46.

DEFINE BUTTON btn-consulta 
     IMAGE-UP FILE "IMG/pvbrowd.bmp":U
     LABEL "Button 10" 
     SIZE 9 BY 1.88.

DEFINE BUTTON btn-dif 
     LABEL "Ver Diferencias" 
     SIZE 14 BY 1.46.

DEFINE BUTTON btn-exit-2 
     IMAGE-UP FILE "IMG/exit.ico":U
     LABEL "btn exit 2" 
     SIZE 10 BY 1.62.

DEFINE BUTTON btn-grabar 
     IMAGE-UP FILE "IMG/save.bmp":U
     LABEL "Ingresa Cantidades" 
     SIZE 14 BY 1.46.

DEFINE BUTTON btn-ingresa 
     LABEL "Modificar Dif." 
     SIZE 14 BY 1.46.

DEFINE BUTTON btn-lista 
     LABEL "Ver Lista Completa" 
     SIZE 14 BY 1.46.

DEFINE VARIABLE txt-codalm AS CHARACTER FORMAT "X(3)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE txt-codalmac AS CHARACTER FORMAT "X(8)":U 
     LABEL "Re-Contado por" 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE txt-desalm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE txt-page AS INTEGER FORMAT ">>99":U INITIAL 0 
     LABEL "Nro. Pág." 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE txt-totpag AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 6.43 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-67
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 108 BY 2.42.

DEFINE RECTANGLE RECT-68
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 108 BY 15.62.

DEFINE RECTANGLE RECT-69
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 108 BY 2.35.

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
      tt-AlmDInv.NroSecuencia COLUMN-LABEL "Nro." FORMAT ">>9":U
            WIDTH 3
      tt-AlmDInv.CodUbi FORMAT "x(6)":U
      tt-AlmDInv.codmat COLUMN-LABEL "Código" FORMAT "X(6)":U WIDTH 7
      Almmmatg.DesMat FORMAT "X(40)":U WIDTH 35
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U WIDTH 18
      Almmmatg.UndBas COLUMN-LABEL "Unidad" FORMAT "X(4)":U WIDTH 3.57
      tt-AlmDInv.QtyConteo FORMAT "->>>,>>>,>>9.99":U
      tt-AlmDInv.QtyReconteo FORMAT "->>>,>>>,>>9.99":U
  ENABLE
      tt-AlmDInv.QtyReconteo
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 105 BY 14.54
         FONT 4
         TITLE "Inventario de Artículos".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-codalm AT ROW 1.5 COL 12.86 COLON-ALIGNED WIDGET-ID 4
     txt-desalm AT ROW 1.5 COL 21.86 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     txt-page AT ROW 1.54 COL 81 COLON-ALIGNED WIDGET-ID 36
     btn-consulta AT ROW 1.54 COL 99.72 WIDGET-ID 8
     txt-codalmac AT ROW 2.46 COL 12.86 COLON-ALIGNED WIDGET-ID 24
     txt-totpag AT ROW 2.5 COL 81 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     br_table AT ROW 4.23 COL 3
     btn-exit-2 AT ROW 19.54 COL 79 WIDGET-ID 52
     btn-dif AT ROW 19.58 COL 3 WIDGET-ID 56
     btn-ingresa AT ROW 19.58 COL 18 WIDGET-ID 50
     btn-lista AT ROW 19.58 COL 33 WIDGET-ID 46
     btn-grabar AT ROW 19.58 COL 48 WIDGET-ID 54
     btn-cancelar AT ROW 19.58 COL 63 WIDGET-ID 48
     "Total Pág:" VIEW-AS TEXT
          SIZE 8.72 BY .5 AT ROW 2.62 COL 74.29 WIDGET-ID 60
          FONT 6
     RECT-67 AT ROW 1.27 COL 2 WIDGET-ID 32
     RECT-68 AT ROW 3.69 COL 2 WIDGET-ID 34
     RECT-69 AT ROW 19.31 COL 2 WIDGET-ID 58
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
         HEIGHT             = 20.65
         WIDTH              = 109.86.
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
/* BROWSE-TAB br_table txt-totpag F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 4.

/* SETTINGS FOR BUTTON btn-dif IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-codalm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-desalm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-totpag IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.tt-AlmDInv,INTEGRAL.Almmmatg OF Temp-Tables.tt-AlmDInv"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _FldNameList[1]   > Temp-Tables.tt-AlmDInv.NroSecuencia
"tt-AlmDInv.NroSecuencia" "Nro." ">>9" "integer" ? ? ? ? ? ? no ? no no "3" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.tt-AlmDInv.CodUbi
     _FldNameList[3]   > Temp-Tables.tt-AlmDInv.codmat
"tt-AlmDInv.codmat" "Código" ? "character" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(40)" "character" ? ? ? ? ? ? no ? no no "35" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no "18" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.Almmmatg.UndBas
"Almmmatg.UndBas" "Unidad" ? "character" ? ? ? ? ? ? no ? no no "3.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = Temp-Tables.tt-AlmDInv.QtyConteo
     _FldNameList[8]   > Temp-Tables.tt-AlmDInv.QtyReconteo
"tt-AlmDInv.QtyReconteo" ? ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME tt-AlmDInv.QtyConteo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-AlmDInv.QtyConteo br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF tt-AlmDInv.QtyConteo IN BROWSE br_table /* Conteo */
DO:
    /*
    dQtyCon = DECIMAL(tt-AlmDInv.QtyConteo:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
    ASSIGN
        dQtyDif = (tt-AlmDInv.QtyFisico - dQtyCon).
    DISPLAY dQtyDif @ dQtyDif WITH BROWSE {&BROWSE-NAME}.

    MESSAGE "Qty " dQtyDif
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

    IF DECIMAL(dQtyDif:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <> 0 THEN DO:
        iCant = iCant + 1.        
        cArti = cArti + tt-AlmDInv.CodMat + ','.
    END.
    IF tt-AlmDInv.NroSecuencia = 40 THEN DO:
        IF iCant > 0 THEN DO:
            MESSAGE "Existe Diferencia en los siguientes Articulos: " SKIP
                cArti
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
        ELSE DO:
            MESSAGE "Toda la información es correcta"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
    END.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-cancelar B-table-Win
ON CHOOSE OF btn-cancelar IN FRAME F-Main /* Ingresa Cantidades */
DO:
  /*
  FOR EACH tt-Datos:
      FIND FIRST tt-AlmDInv OF tt-Datos NO-LOCK NO-ERROR.
      IF NOT AVAILABLE tt-AlmDInv THEN DO:
          CREATE tt-AlmDInv.
          BUFFER-COPY tt-Datos TO tt-AlmDInv.
      END.
  END.
  RUN adm-open-query.*/
  {&BROWSE-NAME}:READ-ONLY = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-consulta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-consulta B-table-Win
ON CHOOSE OF btn-consulta IN FRAME F-Main /* Button 10 */
DO:
    ASSIGN
        txt-codalmac 
        txt-codalm        
        txt-page.
    {&BROWSE-NAME}:READ-ONLY = YES.
    RUN Carga-Temporal.
    RUN set-attribute-list('Key-Name=' + 'Diferencia').
    RUN dispatch IN THIS-PROCEDURE('open-query':U).  
    FIND FIRST tt-AlmDInv WHERE tt-AlmDInv.CodCia = s-CodCia NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-AlmDInv THEN MESSAGE 'No existe Diferencias'.

    cFiltro = "Dif".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-dif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-dif B-table-Win
ON CHOOSE OF btn-dif IN FRAME F-Main /* Ver Diferencias */
DO:
    cFiltro = "Dif".
    RUN set-attribute-list('Key-Name=' + 'Diferencia').
    RUN dispatch IN THIS-PROCEDURE('open-query':U).  
    {&BROWSE-NAME}:READ-ONLY = YES.
    ENABLE btn-lista WITH FRAME {&FRAME-NAME}.
    cFiltro = "Dif".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-exit-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-exit-2 B-table-Win
ON CHOOSE OF btn-exit-2 IN FRAME F-Main /* btn exit 2 */
DO:
    IF NOT lSave THEN DO:
        MESSAGE 'Si no guarda los cambios estos se perderan.' SKIP
                '           ¿Desea Continuar?               '
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            TITLE '' UPDATE choice AS LOGICAL.
        CASE choice:
            WHEN YES THEN RUN adm-exit.
            OTHERWISE RETURN 'ADM-ERROR'.        
        END CASE.  
    END.
    ELSE RUN adm-exit.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-grabar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-grabar B-table-Win
ON CHOOSE OF btn-grabar IN FRAME F-Main /* Ingresa Cantidades */
DO: 
    ASSIGN
        txt-codalmac 
        txt-codalm        
        txt-page.

    IF txt-codalmac = "" THEN DO:
        MESSAGE 'Ingrese nombre del RECONTEADOR'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        APPLY 'ENTRY' TO txt-codalmac.
        RETURN 'ADM-ERROR'.
    END.
    
    RUN Actualiza_Tabla.
    RUN Borra-Temporal.
    FOR EACH AlmDInv WHERE AlmDInv.CodCia = s-CodCia
        AND AlmDInv.CodAlm = txt-codalm
        AND AlmDInv.NroPagina = txt-page NO-LOCK:
        CREATE tt-AlmDInv.
        BUFFER-COPY AlmDInv TO tt-AlmDInv.
        IF (AlmDInv.QtyConteo - AlmDInv.QtyFisico) <> 0 AND (AlmDInv.QtyReConteo <> 0) THEN
            ASSIGN tt-AlmDInv.DifQty = (AlmDInv.QtyReconteo - AlmDInv.QtyFisico).
        ELSE ASSIGN tt-AlmDInv.DifQty = (AlmDInv.QtyConteo - AlmDInv.QtyFisico).
    END.
    lSave = YES.
    RUN adm-open-query.
    {&BROWSE-NAME}:READ-ONLY = YES.
    ENABLE btn-grabar WITH FRAME {&FRAME-NAME}.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-ingresa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-ingresa B-table-Win
ON CHOOSE OF btn-ingresa IN FRAME F-Main /* Modificar Dif. */
DO:
    DEFINE VAR dCant AS DECIMAL NO-UNDO.
    DEFINE VAR cLine AS INTEGER NO-UNDO.
    dCant = 0.
    IF cFiltro = "Todo" THEN DO:
        RUN Alm\w-lineamod.w (txt-codalm, txt-page, OUTPUT cLine, OUTPUT dCant).    
        FIND FIRST tmp-tt-AlmDInv WHERE tmp-tt-AlmDInv.CodCia = s-CodCia
            AND tmp-tt-AlmDInv.CodAlm       = txt-CodAlm
            AND tmp-tt-AlmDInv.NroPagina    = txt-page
            AND tmp-tt-AlmDInv.NroSecuencia = cLine.
        IF AVAILABLE tmp-tt-AlmDInv THEN DO:
            ASSIGN tmp-tt-AlmDInv.QtyReconteo = dCant. 
        END.
        RUN dispatch IN THIS-PROCEDURE('open-query':U).         
    END.
    ELSE IF cFiltro = "Dif" THEN DO:
       {&BROWSE-NAME}:READ-ONLY = NO.  
       APPLY 'ENTRY' TO tt-AlmDInv.QtyReConteo IN BROWSE {&BROWSE-NAME}. 
    END.
    lSave = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-lista
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-lista B-table-Win
ON CHOOSE OF btn-lista IN FRAME F-Main /* Ver Lista Completa */
DO:
    RUN set-attribute-list('Key-Name=' + 'Todos').
    RUN dispatch IN THIS-PROCEDURE('open-query':U). 
    cFiltro = "Todo".
    {&BROWSE-NAME}:READ-ONLY = YES.    
    ENABLE btn-dif WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-codalm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-codalm B-table-Win
ON LEAVE OF txt-codalm IN FRAME F-Main /* Almacen */
DO:
  ASSIGN
      txt-codalm.
  FIND FIRST Almacen WHERE Almacen.CodCia = s-CodCia
      AND Almacen.CodAlm = INPUT txt-codalm NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen THEN 
      DISPLAY 
        Almacen.Descripcion @ txt-desalm 
      WITH FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza_Tabla B-table-Win 
PROCEDURE Actualiza_Tabla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE dDif  AS DECIMAL NO-UNDO INIT 0.
DEFINE VARIABLE iHour AS INTEGER INITIAL 3600000 NO-UNDO. 
DEFINE VARIABLE lSave AS LOGICAL INITIAL NO      NO-UNDO.

FOR EACH AlmCInv WHERE AlmCInv.CodCia = s-CodCia
    AND AlmCInv.CodAlm    = txt-CodAlm
    AND AlmCInv.NroPagina = txt-page
    AND AlmCInv.SwConteo  = YES EXCLUSIVE-LOCK :
    ASSIGN
        AlmCInv.SwReconteo    = YES
        AlmCInv.CodUser     = s-user-id        
        AlmCInv.CodUserRec  = txt-codalmac.        
    IF dDif > 0 THEN ASSIGN AlmCInv.SwDiferencia = TRUE.
    lSave = YES.
END. 
IF lSave = YES THEN
    FOR EACH tt-AlmDInv NO-LOCK:
        FIND FIRST AlmDInv OF tt-AlmDInv EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE AlmDInv THEN DO:
            IF tt-AlmDInv.DifQty = 0 AND tt-AlmDInv.QtyReconteo = 0 THEN NEXT.
            ASSIGN
                AlmDInv.QtyReconteo  = tt-AlmDInv.QtyReconteo
                AlmDInv.CodUserRec   = txt-codalmac
                AlmDInv.FecRec       = NOW + (24 * iHour).
            dDif = dDif + (AlmDInv.QtyConteo - AlmDInv.QtyFisico).
        END.   
    END.
RELEASE AlmCInv.
RELEASE AlmDInv.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Datos B-table-Win 
PROCEDURE Carga-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-datos NO-LOCK:
        FIND FIRST tt-AlmDInv OF tt-datos NO-LOCK NO-ERROR.
        IF NOT AVAILABLE tt-AlmDInv THEN DO:
            CREATE tt-AlmDInv.
            BUFFER-COPY tt-datos TO tt-AlmDInv.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Diferencias B-table-Win 
PROCEDURE Carga-Diferencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dQtyDife AS DECIMAL     NO-UNDO.

    FOR EACH tmp-tt-AlmDInv:
        IF tmp-tt-AlmDInv.QtyReconteo = 0 THEN DO:
            IF tmp-tt-AlmDInv.QtyFisico <> 0 THEN 
                dQtyDife = (tmp-tt-AlmDInv.QtyConteo - tmp-tt-AlmDInv.QtyFisico).
            ELSE dQtyDife = 0.
        END.
        ELSE dQtyDife = (tmp-tt-AlmDInv.QtyReconteo - tmp-tt-AlmDInv.QtyFisico).
        ASSIGN tmp-tt-AlmDInv.DifQty = dQtyDife.

        IF tmp-tt-AlmDInv.DifQty = 0 THEN DO:
            FIND FIRST tt-datos OF tmp-tt-AlmDInv NO-LOCK NO-ERROR.
            IF NOT AVAILABLE tt-datos THEN DO:
                CREATE tt-datos.
                BUFFER-COPY tmp-tt-AlmDInv TO tt-datos.
            END.
            DELETE tmp-tt-AlmDInv.    
            NEXT.
        END.              
    END.    
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
    RUN Borra-Temporal.  

    FIND FIRST AlmCInv WHERE AlmCInv.CodCia = s-CodCia
        AND AlmCInv.CodAlm    = txt-CodAlm 
        AND AlmCInv.NroPagina = txt-page
        AND AlmCInv.NomCia    = "CONTI"
        AND AlmCInv.SwConteo  = YES NO-LOCK NO-ERROR.
    IF NOT AVAILABLE AlmCInv THEN DO: 
        MESSAGE 'Este Almacén y Número de Página' SKIP
                '  aún no han registrado Conteo.'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        APPLY 'ENTRY' TO txt-codalm IN FRAME {&FRAME-NAME}.
        RETURN 'ADM-ERROR'.
    END.
    lReconteo = AlmCInv.SwReconteo.
    ASSIGN txt-codalmac = AlmDInv.CodUserRec .

    FOR EACH AlmDInv WHERE AlmDInv.CodCia = s-CodCia
        AND AlmDInv.CodAlm    = txt-codalm
        AND AlmDInv.NroPagina = txt-page
        AND AlmDInv.NomCia    = "CONTI" NO-LOCK:
        CREATE tt-AlmDInv.
        BUFFER-COPY AlmDInv TO tt-AlmDInv.
        IF NOT SwReconteo THEN
            ASSIGN tt-AlmDInv.DifQty = (AlmDInv.QtyConteo - AlmDInv.QtyFisico).
        ELSE DO: 
            IF (AlmDInv.QtyConteo - AlmDInv.QtyFisico) <> 0 AND (AlmDInv.QtyReconteo <> 0) 
                THEN ASSIGN tt-AlmDInv.DifQty = (AlmDInv.QtyReconteo - AlmDInv.QtyFisico).
            ELSE ASSIGN tt-AlmDInv.DifQty = (AlmDInv.QtyConteo - AlmDInv.QtyFisico).
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
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN txt-codalm = s-codalm.
      FIND FIRST Almacen WHERE Almacen.CodCia = s-codcia
          AND Almacen.CodAlm = s-codalm NO-LOCK NO-ERROR.
      IF AVAIL Almacen THEN DO:
          DISPLAY
              s-codalm @ txt-codalm
              Almacen.Descripcion @ txt-desalm.
      END.

      /*Hallando el total de paginas*/
      FIND LAST AlmDInv WHERE AlmDInv.CodCia = s-CodCia
          AND AlmDInv.CodAlm = s-CodAlm
          AND AlmDInv.NroPagina < 9000 NO-LOCK NO-ERROR.
      IF AVAIL AlmDInv THEN DO:
          ASSIGN txt-totpag = AlmDInv.NroPagina.
          DISPLAY AlmDInv.NroPagina @ txt-totpag. 
      END.
  END.

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
  
  DEF VAR key-value AS CHAR NO-UNDO.

  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
      WHEN 'Diferencia':U THEN DO:
          &Scope KEY-PHRASE ( {&Filtro1} )
          {&OPEN-QUERY-{&BROWSE-NAME}}
      END.
      WHEN 'Todos':U THEN DO:      
          &Scope KEY-PHRASE ( {&Filtro2} )
          {&OPEN-QUERY-{&BROWSE-NAME}}
      END.
  END CASE.
  
  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .*/

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

