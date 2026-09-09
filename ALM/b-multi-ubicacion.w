&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-almubimat NO-UNDO LIKE almubimat.



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
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR x-CodAlm AS CHAR NO-UNDO.
DEF VAR x-CodUbi AS CHAR NO-UNDO.
DEF VAR x-CodMat AS CHAR NO-UNDO.

x-CodAlm = s-CodAlm.

&SCOPED-DEFINE Condicion ( almubimat.codcia = s-codcia AND ~
almubimat.CodAlm = x-CodAlm AND ~
( TRUE <> (x-CodMat > '') OR Almubimat.CodMat = x-CodMat ) AND ~
( TRUE <> (x-CodUbi > '') OR almubimat.codubi = x-CodUbi ) )


&SCOPED-DEFINE Condicion2 ( TRUE )

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
&Scoped-define INTERNAL-TABLES almubimat Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table almubimat.CodMat almubimat.CodUbi ~
almubimat.CodZona Almmmatg.DesMar 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table almubimat.CodMat ~
almubimat.CodUbi 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table almubimat
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table almubimat
&Scoped-define QUERY-STRING-br_table FOR EACH almubimat WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST Almmmatg OF almubimat NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH almubimat WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST Almmmatg OF almubimat NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table almubimat Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table almubimat
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON_Filtrar COMBO-BOX_CodAlm ~
BUTTON_Limpiar FILL-IN_CodMat br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX_CodAlm COMBO-BOX_CodUbi ~
FILL-IN_CodMat FILL-IN_DesMat x-DesMat 

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
DEFINE BUTTON BUTTON_Filtrar 
     LABEL "APLICAR FILTRO" 
     SIZE 19 BY 1.31.

DEFINE BUTTON BUTTON_Limpiar 
     LABEL "LIMPIAR FILTROS" 
     SIZE 19 BY 1.31.

DEFINE VARIABLE COMBO-BOX_CodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacén" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 30 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_CodUbi AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Ubicación" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 23 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodMat AS CHARACTER FORMAT "X(15)":U 
     LABEL "Artículo" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_DesMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1 NO-UNDO.

DEFINE VARIABLE x-DesMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 63 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      almubimat, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      almubimat.CodMat COLUMN-LABEL "Artículo" FORMAT "x(8)":U
      almubimat.CodUbi COLUMN-LABEL "Ubicación" FORMAT "x(15)":U
            WIDTH 14.86
      almubimat.CodZona COLUMN-LABEL "Zona" FORMAT "x(8)":U
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U WIDTH 22
  ENABLE
      almubimat.CodMat
      almubimat.CodUbi
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 63 BY 17.23
         FONT 11 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON_Filtrar AT ROW 1 COL 46 WIDGET-ID 8
     COMBO-BOX_CodAlm AT ROW 1.54 COL 12 COLON-ALIGNED WIDGET-ID 4
     BUTTON_Limpiar AT ROW 2.35 COL 46 WIDGET-ID 14
     COMBO-BOX_CodUbi AT ROW 2.62 COL 12 COLON-ALIGNED WIDGET-ID 6
     FILL-IN_CodMat AT ROW 3.69 COL 12 COLON-ALIGNED WIDGET-ID 10
     FILL-IN_DesMat AT ROW 3.69 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     br_table AT ROW 5.04 COL 2
     x-DesMat AT ROW 22.27 COL 2 NO-LABEL WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 11 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: t-almubimat T "?" NO-UNDO INTEGRAL almubimat
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
         HEIGHT             = 24.12
         WIDTH              = 64.57.
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
/* BROWSE-TAB br_table FILL-IN_DesMat F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX COMBO-BOX_CodUbi IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-DesMat IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.almubimat,INTEGRAL.Almmmatg OF INTEGRAL.almubimat"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > INTEGRAL.almubimat.CodMat
"almubimat.CodMat" "Artículo" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.almubimat.CodUbi
"almubimat.CodUbi" "Ubicación" ? "character" ? ? ? ? ? ? yes ? no no "14.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.almubimat.CodZona
"almubimat.CodZona" "Zona" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no "22" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
  DEFINE VAR hLibAlm AS HANDLE NO-UNDO.

  RUN alm/almacen-library PERSISTENT SET hLibAlm.

  IF AVAILABLE AlmUbiMat THEN DO:
      RUN ALM_Tipo-MultiUbic IN hLibAlm (almubimat.CodAlm,
                                         almubimat.CodMat,
                                         almubimat.CodUbi).
      IF RETURN-VALUE = 'PRINCIPAL' THEN DO:
          Almmmatg.DesMar:FGCOLOR IN BROWSE {&browse-name} = 0.
          almubimat.CodMat:FGCOLOR IN BROWSE {&browse-name} = 0.
          almubimat.CodUbi:FGCOLOR IN BROWSE {&browse-name} = 0.
          almubimat.CodZona:FGCOLOR IN BROWSE {&browse-name} = 0.
          Almmmatg.DesMar:BGCOLOR IN BROWSE {&browse-name} = 10.
          almubimat.CodMat:BGCOLOR IN BROWSE {&browse-name} = 10.
          almubimat.CodUbi:BGCOLOR IN BROWSE {&browse-name} = 10.
          almubimat.CodZona:BGCOLOR IN BROWSE {&browse-name} = 10.
      END.
  END.
  DELETE PROCEDURE hLibAlm.
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

  IF AVAILABLE Almmmatg THEN x-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Almmmatg.desmat.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almubimat.CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almubimat.CodMat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF almubimat.CodMat IN BROWSE br_table /* Artículo */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.

    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vta2/p-codigo-producto.r (INPUT-OUTPUT pCodMat, YES).
    IF pCodMat = '' THEN DO:
        ASSIGN SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
        
    SELF:SCREEN-VALUE = pCodMat.
    FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE
        NO-LOCK.
    DISPLAY Almmmatg.DesMar WITH BROWSE {&browse-name}.
    DISPLAY Almmmatg.DesMat @ x-Desmat WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almubimat.CodUbi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almubimat.CodUbi br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF almubimat.CodUbi IN BROWSE br_table /* Ubicación */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Filtrar B-table-Win
ON CHOOSE OF BUTTON_Filtrar IN FRAME F-Main /* APLICAR FILTRO */
DO:
  ASSIGN
      COMBO-BOX_CodAlm 
      COMBO-BOX_CodUbi 
      FILL-IN_CodMat.
  RUN Captura-Parametros 
    ( INPUT COMBO-BOX_CodAlm /* CHARACTER */,
      INPUT COMBO-BOX_CodUbi /* CHARACTER */,
      INPUT FILL-IN_CodMat /* CHARACTER */).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Limpiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Limpiar B-table-Win
ON CHOOSE OF BUTTON_Limpiar IN FRAME F-Main /* LIMPIAR FILTROS */
DO:
    ASSIGN
        COMBO-BOX_CodAlm = s-CodAlm
        COMBO-BOX_CodUbi = 'Todas'
        FILL-IN_CodMat = ''
        FILL-IN_DesMat = ''.
    DISPLAY  COMBO-BOX_CodAlm COMBO-BOX_CodUbi FILL-IN_CodMat FILL-IN_DesMat
        WITH FRAME {&FRAME-NAME}.
    RUN Captura-Parametros
      ( INPUT COMBO-BOX_CodAlm /* CHARACTER */,
        INPUT COMBO-BOX_CodUbi /* CHARACTER */,
        INPUT FILL-IN_CodMat /* CHARACTER */).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_CodAlm B-table-Win
ON VALUE-CHANGED OF COMBO-BOX_CodAlm IN FRAME F-Main /* Almacén */
DO:
/*     COMBO-BOX_CodUbi:DELETE(COMBO-BOX_CodUbi:LIST-ITEMS).      */
/*     COMBO-BOX_CodUbi:ADD-LAST('Todas').                        */
/*     FOR EACH Almtubic NO-LOCK WHERE Almtubic.codcia = s-codcia */
/*         AND Almtubic.codalm = s-CodAlm:                        */
/*         COMBO-BOX_CodUbi:ADD-LAST(Almtubic.codubi).            */
/*     END.                                                       */
/*     COMBO-BOX_CodUbi:SCREEN-VALUE = 'Todas'.                   */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodMat B-table-Win
ON LEAVE OF FILL-IN_CodMat IN FRAME F-Main /* Artículo */
DO:
    FILL-IN_DesMat:SCREEN-VALUE = ''.
    IF SELF:SCREEN-VALUE = "" THEN RETURN.

    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).
    IF pCodMat = '' THEN DO:
        ASSIGN SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    SELF:SCREEN-VALUE = pCodMat.
    FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE
        NO-LOCK.
    FILL-IN_DesMat:SCREEN-VALUE = Almmmatg.desmat.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Parametros B-table-Win 
PROCEDURE Captura-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pCodUbi AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.

x-CodAlm = pCodAlm.
x-CodUbi = pCodUbi.
IF pCodUbi = 'Todas' THEN x-CodUbi = ''.
x-CodMat = pCodMat.
IF x-CodMat > '' THEN x-CodUbi = ''.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Depurar B-table-Win 
PROCEDURE Depurar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE 'Está seguro de DEPURAR (eliminar no multiubicaciones) la información?'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
    UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.

EMPTY TEMP-TABLE t-almubimat.

FOR EACH almubimat NO-LOCK WHERE almubimat.codcia = s-codcia AND 
    almubimat.CodAlm = x-CodAlm
    BREAK BY almubimat.codmat:
    IF FIRST-OF(almubimat.codmat) THEN DO:
        CREATE t-almubimat.
        BUFFER-COPY almubimat TO t-almubimat.
    END.
    IF LAST-OF(almubimat.codmat) THEN DO:
        IF almubimat.codubi = t-almubimat.codubi THEN DELETE t-almubimat.
    END.
END.

SESSION:SET-WAIT-STATE('GENERAL').
FOR EACH almubimat EXCLUSIVE-LOCK WHERE almubimat.codcia = s-codcia AND 
    almubimat.CodAlm = x-CodAlm:
    FIND FIRST t-almubimat WHERE t-almubimat.CodCia = almubimat.CodCia AND
        t-almubimat.CodAlm = almubimat.CodAlm AND
        t-almubimat.CodMat = almubimat.CodMat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE t-almubimat THEN DO:
        x-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "DEPURANDO: " + almubimat.CodMat.
        DELETE almubimat.
    END.
END.
SESSION:SET-WAIT-STATE('').

 RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Devuelve-Parametros B-table-Win 
PROCEDURE Devuelve-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pRowid AS ROWID.

pRowid = ?.
IF AVAILABLE Almubimat THEN pRowid = ROWID(Almubimat).

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
      almubimat.CodCia = s-CodCia
      almubimat.CodAlm = x-CodAlm.
  FIND Almtubic WHERE almtubic.CodCia = s-codcia
      AND almtubic.CodAlm = x-codalm
      AND almtubic.CodUbi = almubimat.CodUbi
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almtubic THEN ASSIGN almubimat.CodZona = almtubic.CodZona.

  /* Solo es crear */
  CREATE logubimat.
  BUFFER-COPY Almubimat TO Logubimat
      ASSIGN
      logubimat.CodUbiFin = almubimat.CodUbi
      logubimat.CodZonaFin = almubimat.CodZona
      logubimat.CodUbiIni = almubimat.CodUbi
      logubimat.CodZonaIni = almubimat.CodZona
      logubimat.Evento = "CREATE"
      logubimat.Fecha = TODAY
      logubimat.Hora = STRING(TIME, 'HH:MM:SS')
      logubimat.Usuario = s-user-id.
  RELEASE Logubimat.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF NOT AVAILABLE almubimat THEN RETURN 'ADM-ERROR'.

  DEFINE VAR hLibAlm AS HANDLE NO-UNDO.

  RUN alm/almacen-library PERSISTENT SET hLibAlm.
  RUN ALM_Tipo-MultiUbic IN hLibAlm (almubimat.CodAlm,
                                     almubimat.CodMat,
                                     almubimat.CodUbi).
  IF RETURN-VALUE = 'PRINCIPAL' THEN DO:
      MESSAGE 'NO se puede eliminar ubicación principal'
          VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  DELETE PROCEDURE hLibAlm.

  CREATE logubimat.
  BUFFER-COPY Almubimat TO Logubimat
      ASSIGN
      logubimat.CodUbiFin = almubimat.CodUbi
      logubimat.CodZonaFin = almubimat.CodZona
      logubimat.CodUbiIni = almubimat.CodUbi
      logubimat.CodZonaIni = almubimat.CodZona
      logubimat.Evento = "DELETE"
      logubimat.Fecha = TODAY
      logubimat.Hora = STRING(TIME, 'HH:MM:SS')
      logubimat.Usuario = s-user-id.
  RELEASE Logubimat.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields B-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      BUTTON_Filtrar:SENSITIVE = YES.
      BUTTON_Limpiar:SENSITIVE = YES.
      COMBO-BOX_CodAlm:SENSITIVE = YES. 
      /*COMBO-BOX_CodUbi:SENSITIVE = YES.*/
      FILL-IN_CodMat:SENSITIVE = YES.
      
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields B-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Almmmatg THEN x-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Almmmatg.desmat.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields B-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      BUTTON_Filtrar:SENSITIVE = NO.
      BUTTON_Limpiar:SENSITIVE = NO.
      COMBO-BOX_CodAlm:SENSITIVE = NO. 
      COMBO-BOX_CodUbi:SENSITIVE = NO.
      FILL-IN_CodMat:SENSITIVE = NO.
      FILL-IN_DesMat:SENSITIVE = NO.
  END.

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
      COMBO-BOX_CodAlm:DELIMITER = '|'.
      COMBO-BOX_CodAlm:DELETE(1).
      FOR EACH almacen NO-LOCK WHERE almacen.codcia = 1
          AND almacen.coddiv = s-coddiv
          AND almacen.campo-c[9] <> "I":
          COMBO-BOX_CodAlm:ADD-LAST(Almacen.CodAlm + ' - '  + Almacen.Descripcion,Almacen.CodAlm ).
      END.
      COMBO-BOX_CodAlm = s-CodAlm.
      COMBO-BOX_CodUbi:DELIMITER = '|'.
      FOR EACH Almtubic NO-LOCK WHERE Almtubic.codcia = s-codcia
          AND Almtubic.codalm = s-CodAlm:
          COMBO-BOX_CodUbi:ADD-LAST(Almtubic.codubi).
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
  SESSION:SET-WAIT-STATE('GENERAL').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  SESSION:SET-WAIT-STATE('').

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
  {src/adm/template/snd-list.i "almubimat"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ubica-Registro B-table-Win 
PROCEDURE Ubica-Registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pRowid AS ROWID.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).
REPOSITION {&browse-name} TO ROWID pRowid NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Siempre es CREATE
------------------------------------------------------------------------------*/

IF TRUE <> (almubimat.CodMat:SCREEN-VALUE IN BROWSE {&browse-name}> '') 
    THEN DO:
    MESSAGE 'Ingrese el código del artículo' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO almubimat.CodMat.
    RETURN 'ADM-ERROR'.
END.
IF NOT CAN-FIND(Almmmatg WHERE Almmmatg.CodCia = s-codcia
                AND Almmmatg.codmat = almubimat.CodMat:SCREEN-VALUE IN BROWSE {&browse-name}
                NO-LOCK)
    THEN DO:
    MESSAGE 'Artículo no registrado en el catálogo de productos'
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO almubimat.CodMat.
    RETURN 'ADM-ERROR'.
END.
IF NOT CAN-FIND(Almmmate WHERE Almmmate.CodCia = s-codcia
                AND Almmmate.codalm = x-CodAlm
                AND Almmmate.codmat = almubimat.CodMat:SCREEN-VALUE IN BROWSE {&browse-name}
                NO-LOCK)
    THEN DO:
    MESSAGE 'Artículo no registrado en el almacén' x-CodAlm
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO almubimat.CodMat.
    RETURN 'ADM-ERROR'.
END.
IF NOT CAN-FIND(Almtubic WHERE almtubic.CodCia = s-codcia
                AND almtubic.CodAlm = x-codalm
                AND almtubic.CodUbi = almubimat.CodUbi:SCREEN-VALUE IN BROWSE {&browse-name}
                NO-LOCK)
    THEN DO:
    MESSAGE 'Código de Ubicación no registrado en el almacén' x-CodAlm
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO almubimat.CodUbi.
    RETURN 'ADM-ERROR'.
END.

IF CAN-FIND(FIRST almubimat WHERE almubimat.CodCia = s-codcia
            AND almubimat.CodAlm = x-codalm
            AND almubimat.CodMat = almubimat.CodMat:SCREEN-VALUE IN BROWSE {&browse-name}
            AND almubimat.CodUbi = almubimat.CodUbi:SCREEN-VALUE IN BROWSE {&browse-name}
            NO-LOCK)
    THEN DO:
    MESSAGE 'Artículo YA registrado en esa ubicación' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO almubimat.CodMat.
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
RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

