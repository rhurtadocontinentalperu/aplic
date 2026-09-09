&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-DETA FOR logisdchequeo.
DEFINE BUFFER b-Detalle FOR logisdchequeo.
DEFINE BUFFER b-VtaCDocu FOR VtaCDocu.
DEFINE TEMP-TABLE t-Detalle NO-UNDO LIKE logisdchequeo
       INDEX Idx00 AS PRIMARY CodMat.
DEFINE TEMP-TABLE T-DPEDI NO-UNDO LIKE logisdchequeo
       FIELD Kit AS LOGICAL.
DEFINE TEMP-TABLE tt-articulos-pickeados NO-UNDO LIKE w-report.



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
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR lh_handle AS HANDLE.
DEFINE SHARED VAR PrcId AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE s-generacion-multiple AS LOG NO-UNDO.

DEF VAR x-CodDoc AS CHAR NO-UNDO.
DEF VAR x-NroDoc AS CHAR NO-UNDO.
DEF VAR x-Embalado AS CHAR NO-UNDO.
DEF VAR x-CodPer AS CHAR NO-UNDO.
DEF VAR x-Mesa AS CHAR NO-UNDO.

DEFINE VAR x-bulto-rotulo AS INT.
DEFINE VAR x-graficos AS CHAR.
DEFINE VAR x-grafico-rotulo AS CHAR.
DEFINE VAR x-Rowid AS ROWID NO-UNDO.
DEFINE VAR x-fecha-inicio AS DATE.
DEFINE VAR x-hora-inicio AS CHAR.
DEFINE VAR pMensaje AS CHAR NO-UNDO.

x-fecha-inicio = TODAY.
x-hora-inicio = STRING(TIME,"HH:MM:SS").

/* Rotulo */
x-graficos = "€ƒŒ£§©µÄËÐØÞßæø±å†Š®¾½¼ÆÖÜÏ¶Ÿ¥#$%&‰".
x-bulto-rotulo = RANDOM ( 1 , LENGTH(x-graficos) ).

x-grafico-rotulo = SUBSTRING(x-graficos,x-bulto-rotulo,1).
x-bulto-rotulo = RANDOM ( 1 , 999999 ).

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
&Scoped-define INTERNAL-TABLES logisdchequeo Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table logisdchequeo.CodMat ~
Almmmatg.DesMat Almmmatg.DesMar logisdchequeo.UndVta logisdchequeo.CanChk ~
logisdchequeo.SerialNumber logisdchequeo.Factor logisdchequeo.CanPed ~
logisdchequeo.Etiqueta logisdchequeo.FechaHora 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table logisdchequeo.CodMat ~
logisdchequeo.CanChk logisdchequeo.SerialNumber 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table logisdchequeo
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table logisdchequeo
&Scoped-define QUERY-STRING-br_table FOR EACH logisdchequeo WHERE ~{&KEY-PHRASE} ~
      AND logisdchequeo.CodCia = s-CodCia ~
 AND logisdchequeo.CodDiv = s-CodDiv ~
 AND logisdchequeo.CodPed = x-CodDoc ~
 AND logisdchequeo.NroPed = x-NroDoc NO-LOCK, ~
      EACH Almmmatg OF logisdchequeo NO-LOCK ~
    BY logisdchequeo.Etiqueta ~
       BY logisdchequeo.NroItm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH logisdchequeo WHERE ~{&KEY-PHRASE} ~
      AND logisdchequeo.CodCia = s-CodCia ~
 AND logisdchequeo.CodDiv = s-CodDiv ~
 AND logisdchequeo.CodPed = x-CodDoc ~
 AND logisdchequeo.NroPed = x-NroDoc NO-LOCK, ~
      EACH Almmmatg OF logisdchequeo NO-LOCK ~
    BY logisdchequeo.Etiqueta ~
       BY logisdchequeo.NroItm.
&Scoped-define TABLES-IN-QUERY-br_table logisdchequeo Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table logisdchequeo
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS TOGGLE-Multiple BUTTON-CerrarBulto ~
BUTTON-imprimir BUTTON-Extorna-CerrarBulto br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Bultos TOGGLE-Multiple ~
FILL-IN-codplanilla 

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
DEFINE BUTTON BUTTON-CerrarBulto  NO-CONVERT-3D-COLORS
     LABEL "Cerrar Bulto" 
     SIZE 14 BY 1.12
     BGCOLOR 9 FGCOLOR 15 FONT 5.

DEFINE BUTTON BUTTON-Extorna-CerrarBulto  NO-CONVERT-3D-COLORS
     LABEL "Eliminar Bulto" 
     SIZE 14 BY 1.12
     BGCOLOR 9 FGCOLOR 15 FONT 5.

DEFINE BUTTON BUTTON-imprimir 
     LABEL "Imprimir" 
     SIZE 15 BY 1.12
     FONT 5.

DEFINE BUTTON BUTTON-Renumera 
     LABEL "RENUMERA TODOS LOS BULTOS" 
     SIZE 28 BY 1.12.

DEFINE VARIABLE FILL-IN-Bultos AS INTEGER FORMAT ">>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY 1.12
     BGCOLOR 0 FGCOLOR 14 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-codplanilla AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cod.Planilla" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE TOGGLE-Multiple AS LOGICAL INITIAL no 
     LABEL "Ingreso múltiple" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY 1.08
     BGCOLOR 14 FGCOLOR 0 FONT 5 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      logisdchequeo, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      logisdchequeo.CodMat COLUMN-LABEL "Articulo" FORMAT "X(14)":U
      Almmmatg.DesMat FORMAT "X(80)":U WIDTH 49.43
      Almmmatg.DesMar COLUMN-LABEL "!Marca" FORMAT "X(20)":U
      logisdchequeo.UndVta COLUMN-LABEL "Unidad" FORMAT "x(8)":U
      logisdchequeo.CanChk COLUMN-LABEL "Cantidad" FORMAT ">,>>>,>>9.99":U
            WIDTH 8.57 COLUMN-BGCOLOR 11
      logisdchequeo.SerialNumber COLUMN-LABEL "# de Serie" FORMAT "x(25)":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      logisdchequeo.Factor FORMAT ">>,>>9.99":U WIDTH 5.14
      logisdchequeo.CanPed COLUMN-LABEL "Cantidad!Calculada" FORMAT ">,>>>,>>9.99":U
      logisdchequeo.Etiqueta COLUMN-LABEL "Número de Etiqueta" FORMAT "x(30)":U
            WIDTH 21.14
      logisdchequeo.FechaHora FORMAT "99/99/9999 HH:MM:SS":U WIDTH 5.14
  ENABLE
      logisdchequeo.CodMat
      logisdchequeo.CanChk
      logisdchequeo.SerialNumber
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 165 BY 16.42
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Bultos AT ROW 1.23 COL 112.14 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     TOGGLE-Multiple AT ROW 1.27 COL 5 WIDGET-ID 28
     BUTTON-CerrarBulto AT ROW 1.27 COL 49.86 WIDGET-ID 8
     BUTTON-imprimir AT ROW 1.27 COL 63.86 WIDGET-ID 10
     BUTTON-Extorna-CerrarBulto AT ROW 1.27 COL 78.86 WIDGET-ID 36
     BUTTON-Renumera AT ROW 1.27 COL 134.57 WIDGET-ID 34
     FILL-IN-codplanilla AT ROW 1.38 COL 32 COLON-ALIGNED WIDGET-ID 38
     br_table AT ROW 2.58 COL 1
     "BULTOS:" VIEW-AS TEXT
          SIZE 15 BY 1.08 AT ROW 1.27 COL 97.86 WIDGET-ID 32
          BGCOLOR 0 FGCOLOR 14 FONT 8
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
   Temp-Tables and Buffers:
      TABLE: B-DETA B "?" ? INTEGRAL logisdchequeo
      TABLE: b-Detalle B "?" ? INTEGRAL logisdchequeo
      TABLE: b-VtaCDocu B "?" ? INTEGRAL VtaCDocu
      TABLE: t-Detalle T "?" NO-UNDO INTEGRAL logisdchequeo
      ADDITIONAL-FIELDS:
          INDEX Idx00 AS PRIMARY CodMat
      END-FIELDS.
      TABLE: T-DPEDI T "?" NO-UNDO INTEGRAL logisdchequeo
      ADDITIONAL-FIELDS:
          FIELD Kit AS LOGICAL
      END-FIELDS.
      TABLE: tt-articulos-pickeados T "?" NO-UNDO INTEGRAL w-report
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
         HEIGHT             = 18.04
         WIDTH              = 165.86.
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
/* BROWSE-TAB br_table FILL-IN-codplanilla F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-Renumera IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-Renumera:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Bultos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-codplanilla IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.logisdchequeo,INTEGRAL.Almmmatg OF INTEGRAL.logisdchequeo"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ","
     _OrdList          = "INTEGRAL.logisdchequeo.Etiqueta|yes,INTEGRAL.logisdchequeo.NroItm|yes"
     _Where[1]         = "logisdchequeo.CodCia = s-CodCia
 AND logisdchequeo.CodDiv = s-CodDiv
 AND logisdchequeo.CodPed = x-CodDoc
 AND logisdchequeo.NroPed = x-NroDoc"
     _FldNameList[1]   > INTEGRAL.logisdchequeo.CodMat
"logisdchequeo.CodMat" "Articulo" "X(14)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(80)" "character" ? ? ? ? ? ? no ? no no "49.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "!Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.logisdchequeo.UndVta
"logisdchequeo.UndVta" "Unidad" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.logisdchequeo.CanChk
"logisdchequeo.CanChk" "Cantidad" ">,>>>,>>9.99" "decimal" 11 ? ? ? ? ? yes ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.logisdchequeo.SerialNumber
"logisdchequeo.SerialNumber" "# de Serie" "x(25)" "character" 14 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.logisdchequeo.Factor
"logisdchequeo.Factor" ? ">>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "5.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.logisdchequeo.CanPed
"logisdchequeo.CanPed" "Cantidad!Calculada" ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.logisdchequeo.Etiqueta
"logisdchequeo.Etiqueta" "Número de Etiqueta" ? "character" ? ? ? ? ? ? no ? no no "21.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.logisdchequeo.FechaHora
"logisdchequeo.FechaHora" ? "99/99/9999 HH:MM:SS" "datetime" ? ? ? ? ? ? no ? no no "5.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME logisdchequeo.CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL logisdchequeo.CodMat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF logisdchequeo.CodMat IN BROWSE br_table /* Articulo */
DO:
  IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
  /* Vamos a buscar primero el codigo de barras, luego el codigo interno */
  DEF VAR pCodMat LIKE logisdchequeo.codmat.  
  DEF VAR pCanPed LIKE logisdchequeo.canped.
  DEF VAR pFactor LIKE logisdchequeo.factor.
  DEF VAR X-item AS INT.

  pCodMat = SELF:SCREEN-VALUE.
  pCanPed = 1.
  pFactor = 1.
  CASE TRUE:
      WHEN s-generacion-multiple = YES THEN DO:
          /* SOLO EAN 14 */
          RUN vtagn/p-codbarra-ean14.r (INPUT-OUTPUT pCodMat, INPUT-OUTPUT pFactor, s-codcia).
          IF pFactor = 0 THEN DO:
              MESSAGE 'Códigos EAN-14 NO registrado' VIEW-AS ALERT-BOX ERROR.
              logisdchequeo.canped:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '1'.
              SELF:SCREEN-VALUE = ''.
              RETURN NO-APPLY.
          END.
      END.
      OTHERWISE DO:
          /* EAN 13 o 14 */
          RUN alm/p-codbrr.r (INPUT-OUTPUT pCodMat, INPUT-OUTPUT pFactor, s-codcia).
          IF TRUE <> (pCodMat > '') THEN DO:
              MESSAGE 'Código NO registrado' VIEW-AS ALERT-BOX ERROR.
              logisdchequeo.canped:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '1'.
              SELF:SCREEN-VALUE = ''.
              RETURN NO-APPLY.
          END.
      END.
  END CASE.

  ASSIGN SELF:SCREEN-VALUE = pCodMat NO-ERROR.
  FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = SELF:SCREEN-VALUE NO-LOCK.
  FIND FIRST T-DPEDI WHERE T-DPEDI.codmat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE T-DPEDI THEN DO:
      MESSAGE 'Artículo NO registrado en el Pedido' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      logisdchequeo.canped:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '1'.
      RETURN NO-APPLY.
  END.

  /* ******************************************************************************** */
  /* RHC 12/10/2020 Los códigos con control de serie NO se ingresan en forma múltiple */
  /* Se activa o desactiva la columna de # DE SERIE */
  /* ******************************************************************************** */
  IF s-generacion-multiple = YES AND Almmmatg.RequiereSerialNr = "si" THEN DO:
      MESSAGE 'Artículo tiene control por # de SERIE' SKIP
          'NO puede ser chequeado por INGRESO MULTIPLE' SKIP
          'Debe ser chequeado uno por uno' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      logisdchequeo.canped:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '1'.
      RETURN NO-APPLY.
  END.
  /* ******************************************************************************** */
  DISPLAY
      Almmmatg.desmat 
      T-DPEDI.undvta @ logisdchequeo.undvta
      pCanPed @ logisdchequeo.CanChk
      pFactor @ logisdchequeo.Factor
      WITH BROWSE {&BROWSE-NAME}.
  /* RHC 13/10/2020 Productos con control de serie */
  IF Almmmatg.RequiereSerialNr = "si" THEN DO:
      ASSIGN
          logisdchequeo.CanPed:SCREEN-VALUE IN BROWSE {&browse-name} = 
              STRING( DECIMAL(logisdchequeo.CanChk:SCREEN-VALUE IN BROWSE {&browse-name}) *
                      DECIMAL(logisdchequeo.Factor:SCREEN-VALUE IN BROWSE {&browse-name}) ).
/*       ASSIGN                                         */
/*           logisdchequeo.SerialNumber:READ-ONLY = NO  */
/*           logisdchequeo.CanChk:READ-ONLY = YES       */
/*           NO-ERROR.                                  */
/*       APPLY 'ENTRY':U TO logisdchequeo.SerialNumber. */
  END.
  ELSE DO:
/*       ASSIGN                                         */
/*           logisdchequeo.SerialNumber:READ-ONLY = YES */
/*           logisdchequeo.CanChk:READ-ONLY = NO        */
/*           NO-ERROR.                                  */
/*       APPLY 'ENTRY':U TO logisdchequeo.CanChk.       */
  END.
  IF (LASTKEY = KEYCODE("RETURN") OR LASTKEY = KEYCODE("TAB"))
      AND Almmmatg.RequiereSerialNr = "si"
      THEN DO:
      logisdchequeo.SerialNumber:READ-ONLY = NO.
      /*APPLY 'ENTRY':U TO logisdchequeo.SerialNumber.*/
  END.
  IF (LASTKEY = KEYCODE("RETURN") OR LASTKEY = KEYCODE("TAB"))
      AND Almmmatg.RequiereSerialNr = "no"
      THEN DO:
      logisdchequeo.SerialNumber:READ-ONLY = YES.
      /*APPLY 'ENTRY':U TO logisdchequeo.CanChk.*/
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME logisdchequeo.CanChk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL logisdchequeo.CanChk br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF logisdchequeo.CanChk IN BROWSE br_table /* Cantidad */
DO:
    CASE TRUE:
        WHEN s-generacion-multiple = YES THEN DO:
            /* SOLO VALORES ENTEROS */
            IF INTEGER(SELF:SCREEN-VALUE) <> DECIMAL(SELF:SCREEN-VALUE) THEN DO:
                MESSAGE 'SOLO se acepta valores enteros, no decimales' VIEW-AS ALERT-BOX ERROR.
                SELF:SCREEN-VALUE = '1'.
                RETURN NO-APPLY.
            END.
        END.
    END CASE.
    ASSIGN
        logisdchequeo.CanPed:SCREEN-VALUE IN BROWSE {&browse-name} = 
            STRING( DECIMAL(logisdchequeo.CanChk:SCREEN-VALUE IN BROWSE {&browse-name}) *
                    DECIMAL(logisdchequeo.Factor:SCREEN-VALUE IN BROWSE {&browse-name}) ).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME logisdchequeo.SerialNumber
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL logisdchequeo.SerialNumber br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF logisdchequeo.SerialNumber IN BROWSE br_table /* # de Serie */
DO:
    /* RHC 01/03/2021 por ahora no validar para OTR */
    FIND b-vtacdocu WHERE b-vtacdocu.codcia = s-codcia
        AND b-vtacdocu.coddiv = s-coddiv
        AND b-vtacdocu.codped = x-coddoc    /* HPK */
        AND b-vtacdocu.nroped = x-nrodoc
        NO-LOCK NO-ERROR.
    IF Almmmatg.RequiereSerialNr = "no" THEN SELF:SCREEN-VALUE = ''.
    IF b-vtacdocu.codref = "OTR" THEN SELF:SCREEN-VALUE = ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-CerrarBulto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-CerrarBulto B-table-Win
ON CHOOSE OF BUTTON-CerrarBulto IN FRAME F-Main /* Cerrar Bulto */
DO:
  MESSAGE 'Seguro de Cerrar el BULTO?' VIEW-AS ALERT-BOX QUESTION
          BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  
  /* BUscamos el último Bulto */
  DEF VAR x-Bulto AS INT INIT 1 NO-UNDO.
  DEF VAR x-Llave AS CHAR NO-UNDO.

  x-Llave = x-CodDoc + "-" + x-NroDoc + "-B".

  DEF BUFFER B-DETA FOR LogisdChequeo.
  /* Limpiamos basura de los registros */
  FOR EACH B-DETA EXCLUSIVE-LOCK WHERE B-DETA.CodCia = s-CodCia
      AND B-DETA.CodDiv = s-CodDiv
      AND B-DETA.CodPed = x-CodDoc
      AND B-DETA.NroPed = x-NroDoc 
      AND (TRUE <> (B-DETA.CodMat > '') ):
      DELETE B-DETA.
  END.
  /* Buscar el último correlativo del bulto */
  FOR EACH B-DETA NO-LOCK WHERE B-DETA.CodCia = s-CodCia
      AND B-DETA.CodDiv = s-CodDiv
      AND B-DETA.CodPed = x-CodDoc
      AND B-DETA.NroPed = x-NroDoc 
      AND B-DETA.Etiqueta > ''
      BY B-DETA.Etiqueta:
      x-Bulto = INTEGER(REPLACE(B-DETA.Etiqueta,x-LLave,'')) + 1.
  END.
  /* ******************************************* */
  DEF VAR x-Rowid AS ROWID NO-UNDO.
  FOR EACH B-DETA WHERE B-DETA.CodCia = s-CodCia
      AND B-DETA.CodDiv = s-CodDiv
      AND B-DETA.CodPed = x-CodDoc
      AND B-DETA.NroPed = x-NroDoc 
      AND TRUE <> (B-DETA.Etiqueta > '')
      BY B-DETA.NroItm:
      x-Rowid = ROWID(B-DETA).
      ASSIGN
          B-DETA.Etiqueta = x-Llave + STRING(x-bulto,"9999").
  END.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  REPOSITION {&BROWSE-NAME} TO ROWID x-Rowid NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Extorna-CerrarBulto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Extorna-CerrarBulto B-table-Win
ON CHOOSE OF BUTTON-Extorna-CerrarBulto IN FRAME F-Main /* Eliminar Bulto */
DO:
  IF NOT AVAILABLE LogisDChequeo THEN RETURN.

  MESSAGE 'Seguro de Eliminar el BULTO?' VIEW-AS ALERT-BOX QUESTION
          BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  
  DEF VAR x-Rowid AS ROWID NO-UNDO.
  
  x-Rowid = ROWID(LogisDChequeo).

  {lib/lock-genericov3.i ~
      &Tabla="LogisDChequeo" ~
      &Condicion="ROWID(LogisDChequeo) = x-Rowid" ~
      &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
      &Accion="RETRY" ~
      &Mensaje="YES" ~
      &TipoError="UNDO, RETURN" }
      
  ASSIGN
      LogisDChequeo.Etiqueta = "".
  FIND CURRENT LogisDChequeo NO-LOCK NO-ERROR.
  /* ****************************************** */
  /* RHC 27/01/2020 Renumeramos automáticamente */
  /* ****************************************** */
  RUN Renumerar-Bultos.
  /* ****************************************** */

  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  REPOSITION {&BROWSE-NAME} TO ROWID x-Rowid NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-imprimir B-table-Win
ON CHOOSE OF BUTTON-imprimir IN FRAME F-Main /* Imprimir */
DO:  
    /* Buscamos si hay chequeos sin etiquetas */
    FIND FIRST b-Detalle WHERE b-Detalle.CodCia = s-CodCia
        AND b-Detalle.CodDiv = s-CodDiv
        AND b-Detalle.CodPed = x-CodDoc
        AND b-Detalle.NroPed = x-NroDoc 
        AND TRUE <> (b-Detalle.Etiqueta > '')
        NO-LOCK NO-ERROR.
    IF AVAILABLE b-Detalle THEN DO: 
        MESSAGE "Tiene que CERRAR el Bulto" VIEW-AS ALERT-BOX INFORMATION.
        REPOSITION {&browse-name} TO ROWID ROWID(b-Detalle) NO-ERROR.
        RETURN NO-APPLY.
    END.
    /* Temporal de Impresión de Bultos */
    DEF BUFFER b-Almmmatg FOR Almmmatg.
    DEFINE VAR y-bultos AS INT.

    EMPTY TEMP-TABLE tt-articulos-pickeados.
    FOR EACH b-Detalle NO-LOCK WHERE b-Detalle.CodCia = s-CodCia
        AND b-Detalle.CodDiv = s-CodDiv
        AND b-Detalle.CodPed = x-CodDoc
        AND b-Detalle.NroPed = x-NroDoc ,
        FIRST b-Almmmatg OF b-Detalle NO-LOCK
        BREAK BY b-Detalle.Etiqueta:  
        IF FIRST-OF(b-Detalle.Etiqueta) THEN DO:
            CREATE tt-articulos-pickeados.
            ASSIGN 
                tt-articulos-pickeados.campo-i[1] = b-Detalle.NroItm
                tt-articulos-pickeados.campo-c[1] = b-Detalle.CodMat
                tt-articulos-pickeados.campo-c[2] = b-almmmatg.desmat
                tt-articulos-pickeados.campo-c[3] = b-almmmatg.desmar
                tt-articulos-pickeados.campo-c[4] = b-Detalle.UndVta
                tt-articulos-pickeados.campo-f[1] = b-Detalle.CanChk
                tt-articulos-pickeados.campo-f[2] = b-Detalle.Factor
                tt-articulos-pickeados.campo-f[3] = b-Detalle.Factor * b-Detalle.CanChk
                tt-articulos-pickeados.campo-c[5] = b-Detalle.Etiqueta
                tt-articulos-pickeados.campo-c[6] = ""
                tt-articulos-pickeados.campo-c[30] = x-codper           /* El chequeador */
                /*tt-articulos-pickeados.campo-c[7] = IF(b-Detalle.MULTIPLE = YES) THEN "MULTIPLE" ELSE ""*/
                .
            y-bultos = y-bultos + 1.
        END.
    END.
    RUN logis/d-chequeo-de-ordenes-rotulos-v2.r(INPUT x-CodDoc, 
                                              INPUT x-NroDoc, 
                                              INPUT y-bultos, 
                                              INPUT x-bulto-rotulo, 
                                              INPUT x-grafico-rotulo,
                                              INPUT TABLE tt-articulos-pickeados ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Renumera
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Renumera B-table-Win
ON CHOOSE OF BUTTON-Renumera IN FRAME F-Main /* RENUMERA TODOS LOS BULTOS */
DO:
  MESSAGE 'Está seguro de renumerar todos los bultos?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE rpta AS LOG.
  IF rpta = NO  THEN RETURN NO-APPLY.
  RUN Renumerar-Bultos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-Multiple
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-Multiple B-table-Win
ON VALUE-CHANGED OF TOGGLE-Multiple IN FRAME F-Main /* Ingreso múltiple */
DO:
  /* Chequeo de activación o inactivación */
  CASE TRUE:
      WHEN INPUT {&self-name} = YES THEN DO:
          /* NO se puede activar si hay items SIN etiquetas */
          FOR EACH b-Detalle NO-LOCK WHERE b-Detalle.CodCia = s-CodCia
              AND b-Detalle.CodDiv = s-CodDiv
              AND b-Detalle.CodPed = x-CodDoc
              AND b-Detalle.NroPed = x-NroDoc 
              AND TRUE <> (b-Detalle.Etiqueta > ''):
              MESSAGE 'Debe cerrar los bultos primero' VIEW-AS ALERT-BOX ERROR.
              SELF:SCREEN-VALUE = "NO".
              REPOSITION {&browse-name} TO ROWID ROWID(b-Detalle) NO-ERROR.
              RETURN NO-APPLY.
          END.
      END.
  END CASE.
  ASSIGN {&self-name}.
  s-generacion-multiple = {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF logisdchequeo.CanChk, logisdchequeo.CodMat, logisdchequeo.SerialNumber
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

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

DEFINE INPUT PARAMETER pCoddoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE INPUT PARAMETER pChequeador AS CHAR.
DEFINE INPUT PARAMETER pCodPer AS CHAR.
DEFINE INPUT PARAMETER pPrioridad AS CHAR.
DEFINE INPUT PARAMETER pEmbalado AS CHAR.
DEFINE INPUT PARAMETER pMesa AS CHAR.

ASSIGN
    x-CodDoc = pCodDoc      /* HPK */
    x-NroDoc = pNroDoc
    x-Embalado = pEmbalado
    x-CodPer = pCodPer
    x-Mesa = pMesa
    .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-con-Kits B-table-Win 
PROCEDURE Carga-con-Kits :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-DPEDI.

/* RHC 08/02/2019 NO VAN LOS KITS, conversado con M.R.C. */
/* RHC 28/04/2020 NO van los servicios, como el FLETE */
/* RHC 11/07/2020 En este punto la HPK NO debe tener productos SERVICIOS ni DROP SHIPPING */
FOR EACH Vtaddocu NO-LOCK WHERE Vtaddocu.codcia = s-codcia
    AND Vtaddocu.coddiv = s-coddiv
    AND Vtaddocu.codped = x-coddoc      /* HPK */
    AND Vtaddocu.nroped = x-nrodoc,
    FIRST Almmmatg OF Vtaddocu NO-LOCK,
    FIRST Almtfami OF Almmmatg NO-LOCK WHERE Almtfami.Libre_c01 <> "SV":
    FIND T-DPEDI WHERE T-DPEDI.codmat = Vtaddocu.codmat NO-ERROR.
    IF NOT AVAILABLE T-DPEDI THEN DO:
        CREATE T-DPEDI.
        ASSIGN
            T-DPEDI.CodMat = Vtaddocu.codmat
            T-DPEDI.UndVta = Almmmatg.UndStk
            T-DPEDI.CanPed = (Vtaddocu.canped * Vtaddocu.factor).
    END.
    ELSE T-DPEDI.canped = T-DPEDI.canped + (Vtaddocu.canped * Vtaddocu.factor).
    ASSIGN
        T-DPEDI.Kit = NO.
END.
/*
/* 1ro Sin Kits */
FOR EACH Vtaddocu NO-LOCK WHERE Vtaddocu.codcia = s-codcia
    AND Vtaddocu.coddiv = s-coddiv
    AND Vtaddocu.codped = x-coddoc      /* HPK */
    AND Vtaddocu.nroped = x-nrodoc,
    FIRST Almmmatg OF Vtaddocu NO-LOCK:
    FIND FIRST Almckits OF Vtaddocu NO-LOCK NO-ERROR.
    IF AVAILABLE Almckits THEN NEXT.
    FIND T-DPEDI WHERE T-DPEDI.codmat = Vtaddocu.codmat NO-ERROR.
    IF NOT AVAILABLE T-DPEDI THEN DO:
        CREATE T-DPEDI.
        ASSIGN
            T-DPEDI.CodMat = Vtaddocu.codmat
            T-DPEDI.UndVta = Almmmatg.UndStk
            T-DPEDI.CanPed = Vtaddocu.canped * Vtaddocu.factor.
    END.
    ELSE T-DPEDI.canped = T-DPEDI.canped + (Vtaddocu.canped * Vtaddocu.factor).
    ASSIGN
        T-DPEDI.Kit = NO.
END.
/* 2do Con Kits */
FOR EACH Vtaddocu NO-LOCK WHERE Vtaddocu.codcia = s-codcia
    AND Vtaddocu.coddiv = s-coddiv
    AND Vtaddocu.codped = x-coddoc
    AND Vtaddocu.nroped = x-nrodoc,
    FIRST Almckits OF Vtaddocu NO-LOCK,
    EACH Almdkits OF Almckits NO-LOCK,
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = AlmDKits.codmat2:
    FIND T-DPEDI WHERE T-DPEDI.codmat = Almmmatg.codmat NO-ERROR.
    IF NOT AVAILABLE T-DPEDI THEN DO:
        CREATE T-DPEDI.
        ASSIGN
            T-DPEDI.CodMat = Almmmatg.codmat
            T-DPEDI.UndVta = Almmmatg.UndStk
            T-DPEDI.CanPed = Vtaddocu.canped * Vtaddocu.factor * AlmDKits.Cantidad.
    END.
    ELSE T-DPEDI.canped = T-DPEDI.canped + (Vtaddocu.canped * Vtaddocu.factor * AlmDKits.Cantidad).
    ASSIGN
        T-DPEDI.Kit = YES.
END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cerra-Orden B-table-Win 
PROCEDURE Cerra-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Verifica si hay alguna incosistencia en las cantidades chequeadas */
  RUN Pre-Cierre-Orden.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".     /* CONTINUA CON EL CHEQUEO */
  
  MESSAGE 'Cerramos la Orden?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN "ADM-ERROR".

  /* ********************************************************************************** */
  /* HAY DOS FORMAS DE CERRAR:
    * CON INCONSISTENCIAS: Se cierra así no estén etiquetados todos los bultos
    * SIN INCONSISTENCIAS: Se cierra siempre y cuando estén etiquetados todos los bultos
  */
  /* ********************************************************************************** */
  /* Verificamos si hay alguna inconsistencia */
  /* ********************************************************************************** */
  /* Acumulamos */
  EMPTY TEMP-TABLE t-Detalle.
  FOR EACH b-Detalle NO-LOCK WHERE b-Detalle.CodCia = s-CodCia
      AND b-Detalle.CodDiv = s-CodDiv
      AND b-Detalle.CodPed = x-CodDoc
      AND b-Detalle.NroPed = x-NroDoc:
      FIND t-Detalle WHERE t-Detalle.codmat = b-Detalle.codmat
          EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF NOT AVAILABLE t-Detalle THEN CREATE t-Detalle.
      ASSIGN
          t-Detalle.CodCia = s-CodCia
          t-Detalle.CodMat = b-Detalle.CodMat
          t-Detalle.CanChk = t-Detalle.CanChk + b-Detalle.CanPed.
  END.
  /* Cargamos contra qué comparar */
  FOR EACH T-DPEDI NO-LOCK:
      FIND t-Detalle WHERE t-Detalle.codmat = T-DPEDI.codmat
          EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF NOT AVAILABLE t-Detalle THEN CREATE t-Detalle.
      ASSIGN
          t-Detalle.CodCia = s-CodCia
          t-Detalle.CodMat = T-DPEDI.CodMat
          t-Detalle.CanPed = t-Detalle.CanPed + T-DPEDI.CanPed.
  END.
  
  /* ********************************************************************************** */
  /* CIERRE DE LA ORDEN */
  /* ********************************************************************************** */
  DEF VAR pEstado AS CHAR NO-UNDO.
  IF CAN-FIND(FIRST t-Detalle WHERE t-Detalle.CanPed <> t-Detalle.CanChk) THEN DO:
      /* ********************************************************************************** */
      /* Incosistencia: Entramos a la pantalla de verificación */
      /* ********************************************************************************** */
      RUN logis/d-cierre-bandeja-hpk (INPUT TABLE t-Detalle, 
                                      OUTPUT pEstado).
      IF pEstado = "ADM-ERROR" THEN RETURN "ADM-ERROR".     /* CONTINUA CON EL CHEQUEO */
      RUN logis/p-cierre-de-chequeo (INPUT x-CodDoc,
                                     INPUT x-NroDoc,
                                     INPUT x-Embalado,
                                     INPUT x-CodPer,
                                     INPUT x-hora-inicio,
                                     INPUT x-fecha-inicio,
                                     INPUT x-mesa,
                                     INPUT YES,  /* OJO >>> CON INCONSISTENCIAS */
                                     OUTPUT pMensaje).
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo cerrar la orden".
          MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
  END.
  ELSE DO:
      /* ********************************************************************************** */
      /* No deben haber bultos sin etiquetar */
      /* ********************************************************************************** */
      FIND FIRST b-Detalle WHERE b-Detalle.CodCia = s-CodCia
          AND b-Detalle.CodDiv = s-CodDiv
          AND b-Detalle.CodPed = x-CodDoc
          AND b-Detalle.NroPed = x-NroDoc
          AND TRUE <> (b-Detalle.Etiqueta  > '')
          NO-LOCK NO-ERROR.
      IF AVAILABLE b-Detalle THEN DO:
          MESSAGE 'Quedan Bultos SIN etiquetar' VIEW-AS ALERT-BOX ERROR.
          REPOSITION {&browse-name} TO ROWID ROWID(b-Detalle) NO-ERROR.
          RETURN 'ADM-ERROR'.
      END.
      /* Verifica la numeración de los bultos */
      DEF VAR x-Item  AS INT NO-UNDO.
      DEF VAR x-Bulto AS INT NO-UNDO.
      DEF VAR x-Llave AS CHAR NO-UNDO.
      x-Llave = x-CodDoc + "-" + x-NroDoc + "-B".
      FOR EACH b-Detalle NO-LOCK WHERE b-Detalle.CodCia = s-CodCia
          AND b-Detalle.CodDiv = s-CodDiv
          AND b-Detalle.CodPed = x-CodDoc
          AND b-Detalle.NroPed = x-NroDoc
          BREAK BY b-Detalle.Etiqueta:
          IF FIRST-OF(b-Detalle.Etiqueta) THEN x-Item = x-Item + 1.
          x-Bulto = INTEGER(REPLACE(b-Detalle.Etiqueta,x-LLave,'')).
          IF x-Item <> x-Bulto THEN DO:
              MESSAGE 'Están mal numerados los bultos, debe renumerarlos'
                  VIEW-AS ALERT-BOX ERROR.
              REPOSITION {&browse-name} TO ROWID ROWID(b-Detalle) NO-ERROR.
              RETURN 'ADM-ERROR'.
          END.
      END.
      /* ********************************************************************************** */
      /* CERRAMOS COMPLETAMENTE LA HPK */
      /* ********************************************************************************** */
      pMensaje = "".
      RUN logis/p-cierre-de-chequeo.r (INPUT x-CodDoc,
                                     INPUT x-NroDoc,
                                     INPUT x-Embalado,
                                     INPUT x-CodPer,
                                     INPUT x-hora-inicio,
                                     INPUT x-fecha-inicio,
                                     INPUT x-mesa,
                                     INPUT NO,  /* OJO >>> SIN INCONSISTENCIAS */
                                     OUTPUT pMensaje).
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo cerrar la orden".
          MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
      /* *************************************************************************** */
      /* ALERTA */
      /* *************************************************************************** */
      RUN logis/d-alerta-phr-reasign (x-CodDoc, x-NroDoc).
      /* *************************************************************************** */
      /* *************************************************************************** */
  END.
  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Control-LPN B-table-Win 
PROCEDURE Control-LPN :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ************************************************ */
/* RHC 18/11/2015 CONTROL DE LPN PARA SUPERMERCADOS */
/* ************************************************ */

DEFINE INPUT PARAMETER xCodDoc AS CHAR.
DEFINE INPUT PARAMETER xNroDoc AS CHAR.

DEFINE BUFFER pedido FOR faccpedi.
DEFINE BUFFER cotizacion FOR faccpedi.
DEFINE BUFFER x-faccpedi FOR faccpedi.

/* La Orden */
FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                            x-faccpedi.coddoc = xCodDoc AND
                            x-faccpedi.nroped = xNroDoc NO-LOCK NO-ERROR.

/* Ubicamos el registro de control de la Orden de Compra */
FIND PEDIDO WHERE PEDIDO.codcia = x-Faccpedi.codcia
                    AND PEDIDO.coddoc = x-Faccpedi.codref
                    AND PEDIDO.nroped = x-Faccpedi.nroref NO-LOCK NO-ERROR.
IF NOT AVAILABLE PEDIDO THEN RETURN.

/* La cotizacion */
FIND COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
                    AND COTIZACION.coddiv = PEDIDO.coddiv
                    AND COTIZACION.coddoc = PEDIDO.codref
                    AND COTIZACION.nroped = PEDIDO.nroref NO-LOCK NO-ERROR.
IF NOT AVAILABLE COTIZACION THEN RETURN.

/* Control para SuperMercados */
FIND SupControlOC  WHERE SupControlOC.CodCia = COTIZACION.codcia
  AND SupControlOC.CodDiv = COTIZACION.coddiv
  AND SupControlOC.CodCli = COTIZACION.codcli
  AND SupControlOC.OrdCmp = COTIZACION.OrdCmp NO-LOCK NO-ERROR.
IF NOT AVAILABLE SupControlOC THEN RETURN.

/* Comienza la Transacción */
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
  {lib/lock-genericov3.i ~
      &Tabla="SupControlOC" ~
      &Condicion="SupControlOC.CodCia = COTIZACION.codcia ~
      AND SupControlOC.CodDiv = COTIZACION.coddiv ~
      AND SupControlOC.CodCli = COTIZACION.codcli ~
      AND SupControlOC.OrdCmp = COTIZACION.OrdCmp" ~
      &Bloqueo="EXCLUSIVE-LOCK" 
      &Accion="RETRY" ~
      &Mensaje="YES" ~
      &TipoError="RETURN ERROR" ~
      }
  FOR EACH ControlOD EXCLUSIVE-LOCK WHERE ControlOD.CodCia = x-Faccpedi.codcia
      AND ControlOD.CodDiv = s-CodDiv
      AND ControlOD.CodDoc = x-Faccpedi.coddoc
      AND ControlOD.NroDoc = x-Faccpedi.nroped
      ON ERROR UNDO, THROW:
      ASSIGN
          ControlOD.LPN1 = "5000"
          ControlOD.LPN2 = FILL("0",10) + TRIM(COTIZACION.OrdCmp)
          ControlOD.LPN2 = SUBSTRING(ControlOD.LPN2, LENGTH(ControlOD.LPN2) - 10 + 1, 10)
          ControlOD.LPN    = "POR DEFINIR"
          ControlOD.OrdCmp = COTIZACION.OrdCmp
          ControlOD.Sede   = COTIZACION.Ubigeo[1].
  END.
END.
IF AVAILABLE(SupControlOC) THEN RELEASE SupControlOC.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cuenta-Bultos B-table-Win 
PROCEDURE Cuenta-Bultos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    FILL-IN-Bultos = 0.
    FOR EACH b-Detalle NO-LOCK WHERE b-Detalle.CodCia = s-CodCia
        AND b-Detalle.CodDiv = s-CodDiv
        AND b-Detalle.CodPed = x-CodDoc
        AND b-Detalle.NroPed = x-NroDoc 
        AND b-Detalle.Etiqueta > ''        
        BREAK BY b-Detalle.Etiqueta:
        IF FIRST-OF(b-Detalle.Etiqueta) THEN FILL-IN-Bultos = FILL-IN-Bultos + 1.
    END.
    DISPLAY FILL-IN-Bultos.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Etiquetar-Bulto B-table-Win 
PROCEDURE Etiquetar-Bulto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Bulto AS INT INIT 1 NO-UNDO.
DEF VAR x-Llave AS CHAR NO-UNDO.

x-Llave = x-CodDoc + "-" + x-NroDoc + "-B".

/*DEF BUFFER B-DETA FOR logisdchequeo.*/

/* 1ro. Buscar el último correlativo del bulto */
FOR EACH B-DETA NO-LOCK WHERE B-DETA.CodCia = s-CodCia
    AND B-DETA.CodDiv = s-CodDiv
    AND B-DETA.CodPed = x-CodDoc
    AND B-DETA.NroPed = x-NroDoc 
    AND B-DETA.Etiqueta > ''
    BY B-DETA.Etiqueta:
    x-Bulto = INTEGER(REPLACE(B-DETA.Etiqueta,x-LLave,'')) + 1.
END.
/* ******************************************* */
ASSIGN
    logisdchequeo.Etiqueta = x-Llave + STRING(x-bulto,"9999").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-chequeo-hpk-observado B-table-Win 
PROCEDURE grabar-chequeo-hpk-observado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pMsg AS CHAR NO-UNDO.

DEFINE VAR x-codref AS CHAR.    /* O/D */
DEFINE VAR x-nroref AS CHAR.

pMsg = "".
SESSION:SET-WAIT-STATE("GENERAL").
GRABAR_INFO:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    /* Bloqueamos la HPK */
    {lib/lock-genericov3.i ~
        &Tabla="Vtacdocu" ~
        &Condicion="Vtacdocu.codcia = s-codcia AND ~
        Vtacdocu.coddiv = s-coddiv AND ~
        Vtacdocu.codped = x-Coddoc AND ~
        Vtacdocu.nroped = x-NroDoc" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMsg" ~
        &TipoError="UNDO, LEAVE"}
    IF Vtacdocu.FlgEst <> "P" THEN DO:
        pMsg = "La HPK ya no está pendiente".
        UNDO GRABAR_INFO, LEAVE GRABAR_INFO.
    END.
    /* O/D */
    x-codref = vtacdocu.codref.
    x-nroref = vtacdocu.nroref.
    /* La O/D, OTR */
    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND 
        faccpedi.coddoc = x-codref AND
        faccpedi.nroped = x-nroref AND
        faccpedi.flgest <> 'A' NO-LOCK NO-ERROR.
    IF NOT AVAILABLE faccpedi THEN DO:
        pMsg = "La Orden ya no existe o está anulada".
        UNDO GRABAR_INFO, LEAVE GRABAR_INFO.
    END.
    /* Guardamos la cantidad Chequeada */
    pMsg = "NO pudo completar el cierre".   /* Mensaje de Error por defecto */
    FOR EACH Vtaddocu OF Vtacdocu EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
        ASSIGN Vtaddocu.CanPick = 0.
    END.
    EMPTY TEMP-TABLE t-Detalle.
    FOR EACH b-Detalle NO-LOCK WHERE b-Detalle.CodCia = s-CodCia
        AND b-Detalle.CodDiv = s-CodDiv
        AND b-Detalle.CodPed = x-CodDoc
        AND b-Detalle.NroPed = x-NroDoc:
        FIND t-Detalle WHERE t-Detalle.codmat = b-Detalle.codmat NO-ERROR.
        IF NOT AVAILABLE t-Detalle THEN CREATE t-Detalle.
        ASSIGN
            t-Detalle.codmat = b-Detalle.codmat
            t-Detalle.canped = t-Detalle.canped + b-Detalle.canped.
    END.
    FOR EACH t-Detalle NO-LOCK,
        EACH Vtaddocu OF Vtacdocu EXCLUSIVE-LOCK WHERE Vtaddocu.codmat = t-Detalle.codmat
        ON ERROR UNDO, THROW:
        ASSIGN Vtaddocu.canpick = (t-Detalle.canped / Vtaddocu.factor).
    END.
    pMsg = ''.
    /* Estado de la HPK */
    ASSIGN 
        Vtacdocu.flgsit = "PO"      /* Chequeo Observado */
        Vtacdocu.libre_c04 = x-CodPer + "|" + STRING(TODAY,"99/99/9999") + "|" + STRING(TIME,"HH:MM:SS").
    IF Vtacdocu.FecSac = ? THEN
        ASSIGN
            Vtacdocu.horsac = x-hora-inicio
            Vtacdocu.fecsac = x-fecha-inicio.
    /* Observar */    
    FIND FIRST chktareas WHERE chktareas.codcia = s-codcia AND
        chktareas.coddiv = s-coddiv AND 
        chktareas.coddoc = x-CodDoc AND
        chktareas.nroped = x-NroDoc AND
        chktareas.mesa = x-Mesa EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE chktareas THEN DO:
        pMsg = "No se pudo actualizar la tarea (ChkTareas)".
        UNDO GRABAR_INFO, LEAVE GRABAR_INFO.
    END.
    ASSIGN 
        chktareas.flgest = "O"      /* Observada */
        chktareas.fechafin = TODAY
        chktareas.horafin = STRING(TIME,"HH:MM:SS")
        chktareas.usuariofin = s-user-id.
END. /* TRANSACTION block */
IF AVAILABLE Faccpedi THEN RELEASE faccpedi.
IF AVAILABLE Vtacdocu THEN RELEASE vtacdocu.
IF AVAILABLE ChkTareas THEN RELEASE chktareas.
SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-chequeo-hpk-resto B-table-Win 
PROCEDURE grabar-chequeo-hpk-resto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pMsg AS CHAR NO-UNDO.

DEFINE VAR x-numbultos AS INT.

DEFINE VAR x-codref AS CHAR.    /* O/D */
DEFINE VAR x-nroref AS CHAR.

pMsg = "".

SESSION:SET-WAIT-STATE("GENERAL").
x-numbultos = 0.
GRABAR_INFO:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    /* Bloqueamos la HPK */
    {lib/lock-genericov3.i ~
        &Tabla="Vtacdocu" ~
        &Condicion="Vtacdocu.codcia = s-codcia AND ~
        Vtacdocu.coddiv = s-coddiv AND ~
        Vtacdocu.codped = x-Coddoc AND ~
        Vtacdocu.nroped = x-NroDoc" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMsg" ~
        &TipoError="UNDO, LEAVE"}
    IF Vtacdocu.FlgEst <> "P" THEN DO:
        pMsg = "La HPK ya no está pendiente".
        UNDO GRABAR_INFO, LEAVE GRABAR_INFO.
    END.
    /* O/D */
    x-codref = vtacdocu.codref.
    x-nroref = vtacdocu.nroref.
    /* La O/D, OTR */
    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND 
        faccpedi.coddoc = x-codref AND
        faccpedi.nroped = x-nroref AND
        faccpedi.flgest <> 'A' NO-LOCK NO-ERROR.
    IF NOT AVAILABLE faccpedi THEN DO:
        pMsg = "La Orden ya no existe o está anulada".
        UNDO GRABAR_INFO, LEAVE GRABAR_INFO.
    END.
    /* Control por O/D */
    x-numbultos = 0.
    FOR EACH LogisdChequeo NO-LOCK WHERE logisdchequeo.CodCia = s-CodCia
        AND logisdchequeo.CodDiv = s-CodDiv
        AND logisdchequeo.CodPed = x-CodDoc
        AND logisdchequeo.NroPed = x-NroDoc,
        FIRST Almmmatg OF LogisdChequeo NO-LOCK,
        FIRST Vtaddocu OF vtacdocu NO-LOCK WHERE Vtaddocu.CodMat = LogisdChequeo.Codmat
        BREAK BY logisdchequeo.Etiqueta:
        IF FIRST-OF(logisdchequeo.Etiqueta) THEN DO:
            x-numbultos = x-numbultos + 1.
        END.
        /* Control de Los bultos */
        FIND FIRST ControlOD WHERE ControlOD.codcia = s-codcia AND 
            ControlOD.coddoc = faccpedi.coddoc AND 
            ControlOD.nrodoc = faccpedi.nroped AND 
            ControlOD.coddiv = s-coddiv AND
            ControlOD.nroetq = logisdchequeo.Etiqueta NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ControlOD THEN DO:
            CREATE ControlOD.
            ASSIGN 
                ControlOD.codcia = s-codcia
                ControlOD.coddiv = s-coddiv
                ControlOD.coddoc = faccpedi.coddoc
                ControlOD.nrodoc = faccpedi.nroped
                ControlOD.nroetq = logisdchequeo.Etiqueta.
        END.
        ELSE DO:
            FIND CURRENT ControlOD EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF NOT AVAILABLE ControlOD THEN DO:
                pMsg = "Imposible actualizar la tabla ControlOD".
                UNDO GRABAR_INFO, LEAVE GRABAR_INFO.
            END.
        END.
        ASSIGN  
            ControlOD.codcli = faccpedi.codcli
            ControlOD.codalm = faccpedi.codalm
            ControlOD.fchdoc = faccpedi.fchped
            ControlOD.fchchq = TODAY
            ControlOD.horchq = STRING(TIME,"HH:MM:SS")
            ControlOD.nomcli = Faccpedi.nomcli
            ControlOD.usuario = Faccpedi.usuario
            ControlOD.cantart = ControlOD.cantart + logisdchequeo.CanPed.
        ASSIGN
            ControlOD.pesart = ControlOD.cantart * almmmatg.pesmat.
    END.
    /* Control de Bultos */
    CREATE Ccbcbult.
    ASSIGN  
        ccbcbult.codcia = s-codcia 
        ccbcbult.coddiv = s-coddiv
        ccbcbult.coddoc = faccpedi.coddoc
        ccbcbult.nrodoc = faccpedi.nroped
        ccbcbult.bultos = x-numbultos
        ccbcbult.codcli = faccpedi.codcli
        ccbcbult.fchdoc = TODAY
        ccbcbult.nomcli = faccpedi.nomcli
        ccbcbult.CHR_01 = 'P'
        ccbcbult.usuario = s-user-id.
    /* Estado de la HPK */
    ASSIGN 
        Vtacdocu.flgsit = IF(x-Embalado = 'SI') THEN 'PE' ELSE 'PC'
        Vtacdocu.libre_c04 = x-CodPer + "|" + STRING(TODAY,"99/99/9999") + "|" + STRING(TIME,"HH:MM:SS").
    IF Vtacdocu.FecSac = ? THEN
        ASSIGN
            Vtacdocu.horsac = x-hora-inicio
            Vtacdocu.fecsac = x-fecha-inicio.
    /* Control LPN Supermercados */
    RUN Control-LPN (INPUT faccpedi.coddoc, INPUT faccpedi.nroped) NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMsg = "No se pudo generar los LPNs".
        UNDO GRABAR_INFO, LEAVE GRABAR_INFO.
    END.
    /* Tarea Cerrada */    
    FIND FIRST chktareas WHERE chktareas.codcia = s-codcia AND
        chktareas.coddiv = s-coddiv AND 
        chktareas.coddoc = x-CodDoc AND
        chktareas.nroped = x-NroDoc AND
        chktareas.mesa = x-Mesa EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE chktareas THEN DO:
        pMsg = "No se pudo actualizar la tarea (ChkTareas)".
        UNDO GRABAR_INFO, LEAVE GRABAR_INFO.
    END.
    ASSIGN 
        chktareas.flgest = IF(x-Embalado = 'SI') THEN 'E' ELSE 'T'
        chktareas.fechafin = TODAY
        chktareas.horafin = STRING(TIME,"HH:MM:SS")
        chktareas.usuariofin = s-user-id.
END. /* TRANSACTION block */
IF AVAILABLE Faccpedi THEN RELEASE faccpedi.
IF AVAILABLE Vtacdocu THEN RELEASE vtacdocu.
IF AVAILABLE ChkTareas THEN RELEASE chktareas.
IF AVAILABLE Ccbcbult THEN RELEASE ccbcbult.
IF AVAILABLE CONTROLOD THEN RELEASE ControlOD.
SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('disable-buttons').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       Solamente se pueden crear registros o anularlos, no modificarlos
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR x-Item AS INT INIT 1 NO-UNDO.
  DEF VAR k AS INT NO-UNDO.
  DEF VAR x-Factor   AS DEC NO-UNDO.
  DEF VAR x-Cantidad AS DEC NO-UNDO.
  
  DEF BUFFER B-DETA FOR logisdchequeo.
  FOR EACH B-DETA NO-LOCK WHERE B-DETA.CodCia = s-CodCia
      AND B-DETA.CodDiv = s-CodDiv
      AND B-DETA.CodPed = x-CodDoc
      AND B-DETA.NroPed = x-NroDoc
      BY B-DETA.NroItm:
      x-Item = x-Item + 1.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      logisdchequeo.CanPed = DECIMAL(logisdchequeo.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      logisdchequeo.Etiqueta = logisdchequeo.Etiqueta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      logisdchequeo.Factor = DECIMAL(logisdchequeo.Factor:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      logisdchequeo.UndVta = logisdchequeo.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      .

  FIND FIRST AdmCtrlUsers WHERE AdmCtrlUsers.NumId = PrcId NO-LOCK NO-ERROR.
  ASSIGN
      logisdchequeo.codcia = s-codcia
      logisdchequeo.coddiv = s-coddiv
      logisdchequeo.codped = x-coddoc
      logisdchequeo.nroped = x-nrodoc.
  IF AVAILABLE AdmCtrlUsers THEN DO:
      ASSIGN
          logisdchequeo.IDUsuario = AdmCtrlUsers.IDUsuario 
          logisdchequeo.PCCliente = AdmCtrlUsers.PCCliente 
          logisdchequeo.PCRemoto = AdmCtrlUsers.PCRemoto 
          logisdchequeo.PCUsuario = AdmCtrlUsers.PCUsuario 
          logisdchequeo.UserCliente = AdmCtrlUsers.UserCliente.
  END.
  ASSIGN
      logisdchequeo.Multiple = s-generacion-multiple
      logisdchequeo.Usuario   = s-user-id
      logisdchequeo.FechaHora = DATETIME(TODAY, MTIME).
  /* RHC 14/07/2015 Ingreso múltiple */
  x-Factor = DECIMAL(logisdchequeo.factor:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
  x-Cantidad = logisdchequeo.CanChk.
  IF x-Factor <= 0 THEN x-Factor = 1.
  CASE TRUE:
      WHEN s-generacion-multiple = YES AND x-Factor >= 1 THEN DO:
          /* Pescamos el # de bulto */
          DEF VAR x-Bulto AS INTE INIT 0001 NO-UNDO.
          DEF VAR x-Llave AS CHAR NO-UNDO.
          x-Llave = x-CodDoc + "-" + x-NroDoc + "-B".
          FOR EACH B-DETA NO-LOCK WHERE B-DETA.CodCia = s-CodCia
              AND B-DETA.CodDiv = s-CodDiv
              AND B-DETA.CodPed = x-CodDoc
              AND B-DETA.NroPed = x-NroDoc 
              AND B-DETA.Etiqueta > ''
              BY B-DETA.Etiqueta:
              x-Bulto = INTEGER(REPLACE(B-DETA.Etiqueta,x-LLave,'')) + 1.
          END.
          /* Generamos varias líneas */
          SESSION:SET-WAIT-STATE('GENERAL').
          FIND FIRST B-DETA WHERE ROWID(B-DETA) = ROWID(LogisdChequeo) NO-LOCK.
          DO k = 1 TO x-Cantidad:
              IF k > 1 THEN DO:
                  CREATE logisdchequeo.
                  BUFFER-COPY B-DETA TO logisdchequeo.
              END.
              ASSIGN
                  logisdchequeo.nroitm = x-item
                  logisdchequeo.CanChk = 1
                  logisdchequeo.canped = logisdchequeo.CanChk * logisdchequeo.Factor.
              x-Rowid = ROWID(Logisdchequeo).
              /*RUN Etiquetar-Bulto.*/
              ASSIGN
                  logisdchequeo.Etiqueta = x-Llave + STRING(x-bulto,"9999").
              x-Item = x-Item + 1.
              x-Bulto = x-Bulto + 1.
          END.
          SESSION:SET-WAIT-STATE('').
      END.
      OTHERWISE DO:
          /* Rutina Normal */
          ASSIGN
              logisdchequeo.nroitm = x-item
              logisdchequeo.canped = logisdchequeo.CanChk * logisdchequeo.Factor.
          /* OJO: Se van a etiquetar con el botón "CERRAR BULTO" */
          /*RUN Etiquetar-Bulto.*/
      END.
  END CASE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record B-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('enable-buttons').

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
  IF AVAILABLE LogisDChequeo AND logisdchequeo.Etiqueta > '' THEN DO:
      RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Cuenta-Bultos.

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
  ENABLE BUTTON-CerrarBulto BUTTON-imprimir TOGGLE-Multiple BUTTON-Extorna-CerrarBulto WITH FRAME {&FRAME-NAME}.

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
/*   RUN GET-ATTRIBUTE('ADM-NEW-RECORD').                                    */
/*   IF RETURN-VALUE = 'YES' THEN DO:                                        */
/*       ASSIGN                                                              */
/*           logisdchequeo.CanPed:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES   */
/*           logisdchequeo.Etiqueta:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES */
/*           logisdchequeo.Factor:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES   */
/*           logisdchequeo.UndVta:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.  */
/*   END.                                                                    */
  DISABLE BUTTON-CerrarBulto BUTTON-imprimir TOGGLE-Multiple BUTTON-Extorna-CerrarBulto WITH FRAME {&FRAME-NAME}.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  fill-in-codplanilla:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-codper.

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
  RUN Carga-con-Kits.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Cuenta-Bultos.

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
  RUN Procesa-Handle IN lh_handle ('enable-campos').
  IF s-generacion-multiple = YES THEN DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          TOGGLE-Multiple = NO
          TOGGLE-Multiple:SCREEN-VALUE = 'NO'.
      RUN dispatch IN THIS-PROCEDURE ('open-query':U).
      REPOSITION {&browse-name} TO ROWID x-Rowid NO-ERROR.
  END.
  ELSE DO:
      RUN Procesa-Handle IN lh_handle ('Add-Record').
  END.
  s-generacion-multiple = NO.
  RUN Cuenta-Bultos.
  RUN Procesa-Handle IN lh_handle ('enable-buttons').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pre-Cierre-Orden B-table-Win 
PROCEDURE Pre-Cierre-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Eliminamos Inconsistencias */
  FOR EACH b-Detalle NO-LOCK WHERE b-Detalle.CodCia = s-CodCia
      AND b-Detalle.CodDiv = s-CodDiv
      AND b-Detalle.CodPed = x-CodDoc
      AND b-Detalle.NroPed = x-NroDoc
      AND TRUE <> (b-Detalle.CodMat > ''):
      DELETE b-Detalle.
  END.
  /* Acumulamos */
  EMPTY TEMP-TABLE t-Detalle.
  FOR EACH b-Detalle NO-LOCK WHERE b-Detalle.CodCia = s-CodCia
      AND b-Detalle.CodDiv = s-CodDiv
      AND b-Detalle.CodPed = x-CodDoc
      AND b-Detalle.NroPed = x-NroDoc:
      FIND t-Detalle WHERE t-Detalle.codmat = b-Detalle.codmat
          EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF NOT AVAILABLE t-Detalle THEN CREATE t-Detalle.
      ASSIGN
          t-Detalle.CodCia = s-CodCia
          t-Detalle.CodMat = b-Detalle.CodMat
          t-Detalle.CanChk = t-Detalle.CanChk + b-Detalle.CanPed.
  END.
  /* Cargamos contra qué comparar */
  FOR EACH T-DPEDI NO-LOCK:
      FIND t-Detalle WHERE t-Detalle.codmat = T-DPEDI.codmat
          EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF NOT AVAILABLE t-Detalle THEN CREATE t-Detalle.
      ASSIGN
          t-Detalle.CodCia = s-CodCia
          t-Detalle.CodMat = T-DPEDI.CodMat
          t-Detalle.CanPed = t-Detalle.CanPed + T-DPEDI.CanPed.
  END.
  /* Buscamos inconsistencias */
  DEF VAR pEstado AS CHAR NO-UNDO.
  IF CAN-FIND(FIRST t-Detalle WHERE t-Detalle.CanPed <> t-Detalle.CanChk) THEN DO:
      /* Incosistencia: Entramos a la pantalla de verificación */
      RUN logis/d-precierre-bandeja-hpk (INPUT TABLE t-Detalle, OUTPUT pEstado).
      IF pEstado = "ADM-ERROR" THEN RETURN "ADM-ERROR".     /* CONTINUA CON EL CHEQUEO */
  END.
  RETURN 'OK'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Renumerar-Bultos B-table-Win 
PROCEDURE Renumerar-Bultos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Rowid AS ROWID NO-UNDO.
DEF VAR x-Item  AS INT NO-UNDO.

IF AVAILABLE Logisdchequeo THEN x-Rowid = ROWID(Logisdchequeo).

/* Limpiamos basura de los registros */
DEF BUFFER B-DETA FOR LogisdChequeo.
FOR EACH B-DETA EXCLUSIVE-LOCK WHERE B-DETA.CodCia = s-CodCia
    AND B-DETA.CodDiv = s-CodDiv
    AND B-DETA.CodPed = x-CodDoc
    AND B-DETA.NroPed = x-NroDoc 
    AND (TRUE <> (B-DETA.CodMat > '') ):
    DELETE B-DETA.
END.

EMPTY TEMP-TABLE t-Detalle.
FOR EACH b-Detalle EXCLUSIVE-LOCK WHERE b-Detalle.CodCia = s-CodCia
    AND b-Detalle.CodDiv = s-CodDiv
    AND b-Detalle.CodPed = x-CodDoc
    AND b-Detalle.NroPed = x-NroDoc 
    AND b-Detalle.Etiqueta > '':
    /* Limpiamos basura de los registros */
    IF b-Detalle.CodMat > '' THEN DO:
        CREATE t-Detalle.
        BUFFER-COPY b-Detalle TO t-Detalle.
    END.
    DELETE b-Detalle.
END.
DEF VAR x-Bulto AS INT INIT 0 NO-UNDO.
DEF VAR x-Llave AS CHAR NO-UNDO.

x-Llave = x-CodDoc + "-" + x-NroDoc + "-B".
x-Item = 1.
FOR EACH t-Detalle BREAK BY t-Detalle.Etiqueta:
    /* Solo cambiamos de bultos cuando es múltiple (van 1 a 1) */
    IF FIRST-OF(t-Detalle.Etiqueta) THEN x-Bulto = x-Bulto + 1.
    ASSIGN
        t-Detalle.Etiqueta = x-Llave + STRING(x-bulto,"9999")
        t-Detalle.NroItm = x-Item.
    x-Item = x-Item + 1.
END.
FOR EACH t-Detalle:
    CREATE b-Detalle.
    BUFFER-COPY t-Detalle TO b-Detalle.
END.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
IF x-Rowid <> ? THEN REPOSITION {&browse-name} TO ROWID x-Rowid NO-ERROR.

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
  {src/adm/template/snd-list.i "logisdchequeo"}
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
PROCEDURE valida PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Siempre es CREAR, nunca MODIFICAR
------------------------------------------------------------------------------*/

  IF TRUE <> (logisdchequeo.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} > '') THEN DO:
      MESSAGE 'NO se aceptan códigos en blanco' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO logisdchequeo.CodMat.
      RETURN 'ADM-ERROR'.
  END.

  IF DECIMAL(logisdchequeo.CanChk:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
      MESSAGE 'NO se permiten cantidades en cero' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO logisdchequeo.CanChk.
      RETURN 'ADM-ERROR'.
  END.

  /* RHC 13/10/220 Control por # de Serie */
  DEF VAR x-CanChk AS DEC NO-UNDO.
  FIND Almmmatg WHERE Almmmatg.codcia = s-CodCia
      AND Almmmatg.codmat = logisdchequeo.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK.
  /* RHC 01/03/2021 por ahora NO validar para OTR */
  FIND b-vtacdocu WHERE b-vtacdocu.codcia = s-codcia
      AND b-vtacdocu.coddiv = s-coddiv
      AND b-vtacdocu.codped = x-coddoc    /* HPK */
      AND b-vtacdocu.nroped = x-nrodoc
      NO-LOCK NO-ERROR.
  IF b-vtacdocu.codref = "O/D" AND Almmmatg.RequiereSerialNr = "si" THEN DO:
      DEF VAR cSerialNumber AS CHAR NO-UNDO.
      cSerialNumber = logisdchequeo.SerialNumber:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
      IF TRUE <> (cSerialNumber > '') THEN DO:
          MESSAGE 'Debe ingresar el número de serie' VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO logisdchequeo.CodMat.
          RETURN 'ADM-ERROR'.
      END.
      /* Buscamos si hay dato */
      FIND fifommatg WHERE fifommatg.CodCia = Almmmatg.CodCia
          AND fifommatg.CodMat = Almmmatg.CodMat
          AND fifommatg.SerialNumber = cSerialNumber
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE fifommatg THEN DO:
          MESSAGE 'Número de serie NO registrado' VIEW-AS ALERT-BOX ERROR.
          logisdchequeo.SerialNumber:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
          APPLY 'ENTRY':U TO logisdchequeo.CodMat.
          RETURN 'ADM-ERROR'.
      END.
      /* Buscamos en el almacén de despacho */
      x-CanChk = DECIMAL(logisdchequeo.CanChk:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) *
                DECIMAL(logisdchequeo.Factor:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
      FIND Vtacdocu WHERE Vtacdocu.codcia = s-codcia AND 
          Vtacdocu.coddiv = s-coddiv AND 
          Vtacdocu.codped = x-Coddoc AND 
          Vtacdocu.nroped = x-NroDoc NO-LOCK NO-ERROR.
      FIND FIRST fifommate WHERE fifommate.CodCia = s-CodCia
          AND fifommate.CodAlm = Vtacdocu.CodAlm
          AND fifommate.CodMat = Almmmatg.CodMat
          AND fifommate.SerialNumber = cSerialNumber
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE fifommate THEN DO:
          /* Buscamos SIN almacén */
          FIND FIRST fifommate WHERE fifommate.CodCia = s-CodCia
              AND fifommate.CodMat = Almmmatg.CodMat
              AND fifommate.SerialNumber = cSerialNumber
              AND fifommate.StkAct >= x-CanChk
              NO-LOCK NO-ERROR.
      END.
      IF NOT AVAILABLE fifommate OR fifommate.StkAct < x-CanChk THEN DO:
          MESSAGE 'Número de serie NO ingresado al sistema o ya fue despachado' VIEW-AS ALERT-BOX ERROR.
          logisdchequeo.SerialNumber:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
          APPLY 'ENTRY':U TO logisdchequeo.CodMat.
          RETURN 'ADM-ERROR'.
      END.
      /* Que no esté repetido el # de serie */
      FIND FIRST b-Detalle WHERE b-Detalle.CodCia = s-CodCia
          AND b-Detalle.codmat = logisdchequeo.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
          AND b-Detalle.SerialNumber = logisdchequeo.SerialNumber:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
          AND b-Detalle.CodDiv = s-CodDiv
          AND b-Detalle.CodPed = x-CodDoc
          NO-LOCK NO-ERROR.
      IF AVAILABLE b-Detalle THEN DO:
          MESSAGE 'Número de serie YA fue registrado' SKIP
              b-Detalle.CodPed b-Detalle.NroPed
              VIEW-AS ALERT-BOX ERROR.
          logisdchequeo.SerialNumber:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
          APPLY 'ENTRY':U TO logisdchequeo.CodMat.
          RETURN 'ADM-ERROR'.
      END.
  END.
  /* Chequeamos acumulado */
  DEF VAR x-CanPed AS DEC NO-UNDO.

  FOR EACH b-Detalle NO-LOCK WHERE b-Detalle.CodCia = s-CodCia
      AND b-Detalle.CodDiv = s-CodDiv
      AND b-Detalle.CodPed = x-CodDoc
      AND b-Detalle.NroPed = x-NroDoc
      AND b-Detalle.codmat = logisdchequeo.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}:
      x-CanPed = x-CanPed + b-Detalle.canped.
  END.
  x-CanPed = x-CanPed + DECIMAL(logisdchequeo.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
  FIND T-DPEDI WHERE T-DPEDI.codmat = logisdchequeo.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF AVAILABLE T-DPEDI AND x-CanPed > T-DPEDI.canped THEN DO:
      MESSAGE 'CANTIDAD ingresada SUPERA la del pedido' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  IF AVAILABLE T-DPEDI AND x-CanPed < T-DPEDI.canped THEN DO:
      MESSAGE 'CANTIDAD ingresada ES MENOR la del pedido' VIEW-AS ALERT-BOX WARNING.
  END.

  /* RHC 05/03/2021 No debe superar los 9999 items */
  /* RHC 14/07/2015 Ingreso múltiple */
  DEF VAR x-Factor AS DECI NO-UNDO.
  DEF VAR x-Cantidad AS DECI NO-UNDO.

  x-Factor = DECIMAL(logisdchequeo.factor:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
  x-Cantidad = DECIMAL(logisdchequeo.CanChk:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
  IF x-Factor <= 0 THEN x-Factor = 1.
  CASE TRUE:
      WHEN s-generacion-multiple = YES AND x-Factor >= 1 THEN DO:
          /* Pescamos el # de bulto */
          DEF VAR x-Bulto AS INTE NO-UNDO.
          DEF VAR x-Llave AS CHAR NO-UNDO.
          x-Llave = x-CodDoc + "-" + x-NroDoc + "-B".
          FOR EACH B-DETA NO-LOCK WHERE B-DETA.CodCia = s-CodCia
              AND B-DETA.CodDiv = s-CodDiv
              AND B-DETA.CodPed = x-CodDoc
              AND B-DETA.NroPed = x-NroDoc 
              AND B-DETA.Etiqueta > ''
              BY B-DETA.Etiqueta:
              x-Bulto = INTEGER(REPLACE(B-DETA.Etiqueta,x-LLave,'')) + 1.
          END.
          IF x-Bulto + x-Cantidad >= 9999 THEN DO:
              MESSAGE 'La numeración de bultos supera el correlativo máximo 9999'
                  VIEW-AS ALERT-BOX ERROR.
              APPLY 'ENTRY':U TO logisdchequeo.CodMat.
              RETURN 'ADM-ERROR'.
          END.
      END.
  END CASE.

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

