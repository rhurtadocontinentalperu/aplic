&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-AlmDInv NO-UNDO LIKE AlmDInv
       fields dQtyDif    as decimal.



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
DEFINE SHARED VAR s-codalm  AS CHARACTER.

DEFINE VARIABLE cConfi  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dQtyDif AS DECIMAL     NO-UNDO.
DEFINE VARIABLE iCant   AS INTEGER     NO-UNDO INIT 0.
DEFINE VARIABLE cArti   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dQtyCon AS DECIMAL     NO-UNDO.
DEFINE VARIABLE iConta  AS INTEGER     NO-UNDO.
DEFINE VARIABLE lLogic  AS LOGICAL     NO-UNDO INIT YES.
DEFINE VARIABLE iTime   AS INTEGER     NO-UNDO INIT 0.
DEFINE VARIABLE lState  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE lRecon  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE xClave  AS CHARACTER   NO-UNDO.

DEFINE BUFFER tmp-tt-AlmDInv FOR tt-AlmDInv.
DEFINE TEMP-TABLE tt-Datos LIKE tmp-tt-AlmDInv.

&SCOPED-DEFINE FILTRO1 ((tt-AlmDInv.QtyConteo - tt-AlmDInv.QtyFisico) <> 0 )
&SCOPED-DEFINE FILTRO2 (tt-AlmDInv.CodCia = s-CodCia )

DEF VAR lSave AS LOGICAL NO-UNDO INIT NO.
DEF VAR cSuperv AS CHARACTER NO-UNDO.
DEF VAR cConta  AS CHARACTER NO-UNDO.

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
tt-AlmDInv.codmat Almmmatg.DesMat Almmmatg.UndBas tt-AlmDInv.QtyConteo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table tt-AlmDInv.QtyConteo 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table tt-AlmDInv
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table tt-AlmDInv
&Scoped-define QUERY-STRING-br_table FOR EACH tt-AlmDInv WHERE ~{&KEY-PHRASE} ~
      AND tt-AlmDInv.Codcia = s-codcia NO-LOCK, ~
      FIRST Almmmatg OF tt-AlmDInv NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH tt-AlmDInv WHERE ~{&KEY-PHRASE} ~
      AND tt-AlmDInv.Codcia = s-codcia NO-LOCK, ~
      FIRST Almmmatg OF tt-AlmDInv NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table tt-AlmDInv Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table tt-AlmDInv
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-67 RECT-68 txt-almvirtual txt-page ~
btn-consulta txt-codalmac txt-codinv br_table btn_ingresa btn-dif btn-lista ~
btn-grabar btn-cancelar btn-exit 
&Scoped-Define DISPLAYED-OBJECTS txt-almvirtual txt-page txt-totpag ~
txt-codalmac txt-nombre1 txt-codinv 

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
     SIZE 16 BY 1.38.

DEFINE BUTTON btn-consulta 
     IMAGE-UP FILE "IMG/pvbrowd.bmp":U
     LABEL "Button 10" 
     SIZE 9 BY 1.88.

DEFINE BUTTON btn-dif 
     LABEL "Ver Diferencias" 
     SIZE 16 BY 1.38.

DEFINE BUTTON btn-exit 
     IMAGE-UP FILE "IMG/exit.ico":U
     LABEL "Button 1" 
     SIZE 10 BY 1.62.

DEFINE BUTTON btn-grabar 
     IMAGE-UP FILE "IMG/save.bmp":U
     LABEL "Ingresa Cantidades" 
     SIZE 16 BY 1.38.

DEFINE BUTTON btn-lista 
     LABEL "Ver Lista Completa" 
     SIZE 16 BY 1.38.

DEFINE BUTTON btn_ingresa 
     LABEL "Ingresa Cantidades" 
     SIZE 16 BY 1.38.

DEFINE VARIABLE txt-almvirtual AS CHARACTER FORMAT "X(4)":U 
     LABEL "Almacen Virtual" 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .81 NO-UNDO.

DEFINE VARIABLE txt-codalmac AS CHARACTER FORMAT "X(8)":U 
     LABEL "Supervisado por" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE txt-codinv AS CHARACTER FORMAT "X(40)":U 
     LABEL "Contador por" 
     VIEW-AS FILL-IN 
     SIZE 54.14 BY .81 NO-UNDO.

DEFINE VARIABLE txt-nombre1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE txt-page AS INTEGER FORMAT ">>99":U INITIAL 0 
     LABEL "Nro. Pág." 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE txt-totpag AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-67
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 103 BY 3.54.

DEFINE RECTANGLE RECT-68
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 103 BY 15.88.

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
            WIDTH 5
      tt-AlmDInv.codmat FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "X(50)":U WIDTH 40
      Almmmatg.UndBas COLUMN-LABEL "UndBas" FORMAT "X(4)":U WIDTH 6
      tt-AlmDInv.QtyConteo FORMAT "->>,>>>,>>>,>>9.99":U COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 11
  ENABLE
      tt-AlmDInv.QtyConteo
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 82 BY 15.35
         FONT 4
         TITLE "Inventario de Artículos".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-almvirtual AT ROW 1.73 COL 14.29 COLON-ALIGNED WIDGET-ID 52
     txt-page AT ROW 1.73 COL 79 COLON-ALIGNED WIDGET-ID 36
     btn-consulta AT ROW 1.77 COL 95 WIDGET-ID 8
     txt-totpag AT ROW 2.58 COL 79 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     txt-codalmac AT ROW 2.77 COL 14 COLON-ALIGNED WIDGET-ID 24
     txt-nombre1 AT ROW 2.77 COL 23.72 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     txt-codinv AT ROW 3.73 COL 14 COLON-ALIGNED WIDGET-ID 28
     br_table AT ROW 5.58 COL 4
     btn_ingresa AT ROW 6.92 COL 87 WIDGET-ID 12
     btn-dif AT ROW 8.38 COL 87 WIDGET-ID 42
     btn-lista AT ROW 9.88 COL 87.14 WIDGET-ID 46
     btn-grabar AT ROW 11.42 COL 87.14 WIDGET-ID 44
     btn-cancelar AT ROW 12.96 COL 87.14 WIDGET-ID 40
     btn-exit AT ROW 14.62 COL 90 WIDGET-ID 38
     "Total Pág:" VIEW-AS TEXT
          SIZE 8.86 BY .5 AT ROW 2.42 COL 72.14 WIDGET-ID 48
          FONT 6
     RECT-67 AT ROW 1.35 COL 2 WIDGET-ID 32
     RECT-68 AT ROW 5.31 COL 2 WIDGET-ID 34
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
          fields dQtyDif    as decimal
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
         HEIGHT             = 20.62
         WIDTH              = 105.
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
/* BROWSE-TAB br_table txt-codinv F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN txt-nombre1 IN FRAME F-Main
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
     _Where[1]         = "Temp-Tables.tt-AlmDInv.Codcia = s-codcia"
     _FldNameList[1]   > Temp-Tables.tt-AlmDInv.NroSecuencia
"tt-AlmDInv.NroSecuencia" "Nro." ">>9" "integer" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.tt-AlmDInv.codmat
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(50)" "character" ? ? ? ? ? ? no ? no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.UndBas
"Almmmatg.UndBas" "UndBas" ? "character" ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-AlmDInv.QtyConteo
"tt-AlmDInv.QtyConteo" ? "->>,>>>,>>>,>>9.99" "decimal" 11 9 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME btn-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-cancelar B-table-Win
ON CHOOSE OF btn-cancelar IN FRAME F-Main /* Ingresa Cantidades */
DO:
  {&BROWSE-NAME}:READ-ONLY = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-consulta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-consulta B-table-Win
ON CHOOSE OF btn-consulta IN FRAME F-Main /* Button 10 */
DO:
    DEFINE VARIABLE lVal AS LOGICAL NO-UNDO.
    ASSIGN
        txt-codalmac 
        txt-codinv
        txt-page
        txt-almvirtual.

    /*Carga Temporal*/
    RUN Borra-Temporal. 
    RUN Carga-Temporal.
    
    lVal = YES.
    IF LRecon THEN DO:
        MESSAGE '  Ya se realizo el CONTEO y ' SKIP
                '  RECONTE para este almacén ' SKIP
                '     y número de página.    ' SKIP
                ' Información solo de consulta '
            VIEW-AS ALERT-BOX INFO BUTTONS OK.  
        RUN Inhabilita-Botones.
        lVal = NO.
    END.

    /*Muestra Detalle Editable*/
    IF lVal THEN DO:
        IF lState THEN DO:
            MESSAGE ' Ya se registro el conteo para' SKIP
                'este almacén y número de página'
                VIEW-AS ALERT-BOX INFO BUTTONS OK.        
            RUN Inhabilita-Botones.
            ENABLE btn_ingresa WITH FRAME {&FRAME-NAME}.
            btn_ingresa:LABEL = 'Modificar'. 
            ENABLE btn-grabar WITH FRAME {&FRAME-NAME}.
        END.         
        ELSE DO: 
            RUN Habilita-Botones.
            ENABLE btn-dif WITH FRAME {&FRAME-NAME}.
            btn_ingresa:LABEL = 'Ingresa Cantidades'. 
        END.
    END.
    DISPLAY cSuperv @ txt-codalmac WITH FRAME {&FRAME-NAME}.
    DISPLAY cConta  @ txt-codinv   WITH FRAME {&FRAME-NAME}.

    RUN adm-open-query. 
    {&BROWSE-NAME}:READ-ONLY = YES.
    lLogic = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-dif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-dif B-table-Win
ON CHOOSE OF btn-dif IN FRAME F-Main /* Ver Diferencias */
DO:
    RUN set-attribute-list('Key-Name=' + 'Diferencia').
    RUN dispatch IN THIS-PROCEDURE('open-query':U).  
    {&BROWSE-NAME}:READ-ONLY = YES.
    btn_ingresa:LABEL = 'Modificar'.
    ENABLE  btn-lista WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-exit B-table-Win
ON CHOOSE OF btn-exit IN FRAME F-Main /* Button 1 */
DO:
    IF NOT lSave THEN DO:
        MESSAGE 'Asegurese de haber grabado' SKIP
                'para no perder los cambios' SKIP
                '     ¿Desea Continuar?    '
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            TITLE "" UPDATE choice AS LOGICAL.
        CASE choice:
            WHEN YES THEN RUN adm-exit.
            OTHERWISE RETURN "ADM-ERROR".
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
        txt-codinv
        txt-page.

    IF txt-codalmac = "" THEN DO:
        MESSAGE 'Ingrese Supervisor'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        APPLY 'ENTRY' TO txt-codalmac.
        RETURN 'ADM-ERROR'.
    END.

    IF txt-codinv = "" THEN DO:
        MESSAGE 'Ingrese Contador'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        APPLY 'ENTRY' TO txt-codinv.
        RETURN 'ADM-ERROR'.
    END.    

    RUN Actualiza_Tabla.    

    RUN adm-open-query.
    {&BROWSE-NAME}:READ-ONLY = YES.
    RUN Inhabilita-Botones.
    ENABLE btn_ingresa WITH FRAME {&FRAME-NAME}.
    btn_ingresa:LABEL = 'Modificar'. 
    ENABLE btn-grabar WITH FRAME {&FRAME-NAME}.
    ENABLE btn-dif WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-lista
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-lista B-table-Win
ON CHOOSE OF btn-lista IN FRAME F-Main /* Ver Lista Completa */
DO:
    RUN set-attribute-list('Key-Name=' + 'Todos').
    RUN dispatch IN THIS-PROCEDURE('open-query':U). 
    {&BROWSE-NAME}:READ-ONLY = YES.
    lLogic = YES.
    btn_ingresa:LABEL = 'Modificar'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_ingresa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_ingresa B-table-Win
ON CHOOSE OF btn_ingresa IN FRAME F-Main /* Ingresa Cantidades */
DO:
    DEF VAR RPTA AS CHAR NO-UNDO.
    IF lState THEN DO:
        xClave = '2009'.
        RUN vta/g-CLAVE (xClave,OUTPUT RPTA).
        IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".    
    END.
    IF NOT lState OR RPTA <> "ERROR" THEN DO: 
        {&BROWSE-NAME}:READ-ONLY = NO.    
        APPLY 'ENTRY' TO tt-AlmDInv.QtyConteo IN BROWSE {&BROWSE-NAME}. 
    END.
    lSave = NO.
    
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

    DEFINE VARIABLE dDif AS DECIMAL NO-UNDO INIT 0.
    DEFINE VARIABLE iHour AS INTEGER INITIAL 3600000 NO-UNDO. 
    DEFINE VARIABLE lDif  AS LOGICAL INITIAL YES     NO-UNDO.
    
    FOR EACH tt-AlmDInv NO-LOCK:
        FIND FIRST AlmDInv OF tt-AlmDInv EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE AlmDInv THEN DO:
            ASSIGN
                AlmDInv.QtyConteo  = tt-AlmDInv.QtyConteo
                AlmDInv.Libre_d01  = tt-AlmDInv.QtyConteo
                AlmDInv.CodUserCon = txt-codalmac
                AlmDInv.FecCon     = DATETIME(TODAY,MTIME).
            IF (AlmDInv.QtyConteo - AlmDInv.QtyFisico) <> 0 AND lDif = NO 
                THEN lDif = YES.
        END.   
    END.
    
    FOR FIRST AlmCInv WHERE AlmCInv.CodCia = s-CodCia
        AND AlmCInv.CodAlm    = txt-almvirtual /*"11x"*/
        AND AlmCInv.NroPagina = txt-page
        AND AlmCInv.NomCia    = "CONTISTAND"
        /*AND AlmCInv.SwConteo  = NO*/ EXCLUSIVE-LOCK :
        ASSIGN
            AlmCInv.SwConteo     = YES
            AlmCInv.CodUser      = s-user-id
            AlmCInv.CodAlma      = txt-codalmac
            AlmCInv.CodUserCon   = txt-codinv            
            AlmCInv.SwDiferencia = lDif.
        lState = YES.
    END. 
    lSave = YES.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cNomCia AS CHARACTER NO-UNDO.
    cNomCia = "CONTISTAND".
    
    FIND FIRST AlmCInv WHERE AlmCInv.CodCia = s-CodCia
        AND AlmCInv.CodAlm    = txt-almvirtual  /*"11x" */
        AND AlmCInv.Nropagina = INT(txt-page:SCREEN-VALUE IN FRAME {&FRAME-NAME})
        AND AlmCInv.NomCia    = cNomCia NO-LOCK NO-ERROR.
    IF NOT AVAIL AlmCInv THEN DO:
        MESSAGE 'No exite número de página para ese Almacen'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        APPLY 'ENTRY' TO txt-page IN FRAME {&FRAME-NAME}.
        RETURN 'ADM-ERROR'.        
    END.

    /*Variables de validacion*/
    lState  = AlmCInv.SwConteo.
    lRecon  = AlmCInv.SwReconteo.
    cSuperv = AlmCInv.CodAlma.
    cConta  = AlmCInv.CodUserCon.

    ASSIGN 
        txt-codalmac = cSuperv
        txt-codinv  = cConta.
    
    FOR EACH AlmDInv OF AlmCInv NO-LOCK:
        FIND FIRST tt-AlmDInv WHERE tt-AlmDInv.CodCia = AlmDInv.CodCia
            AND tt-AlmDInv.CodAlm    = AlmDInv.CodAlm
            AND tt-AlmDInv.NroPagina = AlmDInv.NroPagina
            AND tt-AlmDInv.NomCia    = AlmDInv.NomCia
            AND tt-AlmDInv.CodMat    = AlmDInv.CodMat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE tt-AlmDInv THEN DO:
            CREATE tt-AlmDInv.
            BUFFER-COPY AlmDInv TO tt-AlmDInv.
            /*
            ASSIGN
                tt-AlmDInv.CodCia       = AlmDInv.CodCia
                tt-AlmDInv.CodAlm       = AlmDInv.CodAlm
                tt-AlmDInv.CodUbi       = AlmDInv.CodUbi
                tt-AlmDInv.NroPagina    = AlmDInv.NroPagina
                tt-AlmDInv.NroSecuencia = AlmDInv.NroSecuencia
                tt-AlmDInv.codmat       = AlmDInv.CodMat
                tt-AlmDInv.QtyFisico    = AlmDInv.QtyFisico
                tt-AlmDInv.QtyConteo    = AlmDInv.QtyConteo.
            */    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Habilita-Botones B-table-Win 
PROCEDURE Habilita-Botones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
      ENABLE 
          btn_ingresa
          btn-dif
          btn-grabar
          btn-lista.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inhabilita-Botones B-table-Win 
PROCEDURE Inhabilita-Botones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
      DISABLE 
          btn_ingresa
          btn-dif
          btn-lista
          btn-grabar.
  END.
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
      /*Hallando el Total de Páginas*/
      FIND LAST invconfig WHERE invconfig.codcia = s-codcia
          AND invconfig.codalm = txt-almvirtual NO-LOCK NO-ERROR.
      IF AVAIL invconfig THEN DO:
          FIND LAST AlmCInv WHERE AlmCInv.CodCia = s-codcia
              AND AlmCInv.CodAlm = txt-almvirtual /*"11x"*/
              AND AlmCInv.NomCia = "CONTISTAND"
              AND date(AlmCInv.fecupdate) = InvConfig.FchInv
              AND AlmCInv.NroPagina < 9000 NO-LOCK NO-ERROR.
          IF AVAIL AlmCInv THEN DO:
              ASSIGN txt-totpag = AlmCInv.NroPagina.
              DISPLAY AlmCInv.NroPagina @ txt-totpag.
          END.
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

