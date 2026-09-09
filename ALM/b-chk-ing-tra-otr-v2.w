&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CMOV FOR Almcmov.
DEFINE BUFFER b-Detalle FOR logisdchequeo.
DEFINE BUFFER B-DMOV FOR Almdmov.
DEFINE TEMP-TABLE t-Detalle NO-UNDO LIKE logisdchequeo.
DEFINE TEMP-TABLE T-DINCI NO-UNDO LIKE AlmDIncidencia.
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
DEF SHARED VAR s-codalm AS CHAR.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE s-generacion-multiple AS LOG NO-UNDO.

DEF VAR x-Tipo   AS CHAR NO-UNDO.
DEF VAR x-CodDoc AS CHAR NO-UNDO.
DEF VAR x-NroDoc AS CHAR NO-UNDO.
DEF VAR x-UsrChq AS CHAR NO-UNDO.
DEF VAR s-CodMov AS INT INIT 03 NO-UNDO.

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
logisdchequeo.Factor logisdchequeo.CanPed logisdchequeo.FechaHora 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table logisdchequeo.CodMat ~
logisdchequeo.UndVta logisdchequeo.CanChk logisdchequeo.Factor ~
logisdchequeo.CanPed 
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
&Scoped-Define ENABLED-OBJECTS br_table 

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
      Almmmatg.DesMat FORMAT "X(80)":U WIDTH 52.43
      Almmmatg.DesMar COLUMN-LABEL "!Marca" FORMAT "X(20)":U
      logisdchequeo.UndVta COLUMN-LABEL "Unidad" FORMAT "x(8)":U
      logisdchequeo.CanChk COLUMN-LABEL "Cantidad" FORMAT ">,>>>,>>9.9999":U
      logisdchequeo.Factor FORMAT ">>,>>9.9999":U
      logisdchequeo.CanPed COLUMN-LABEL "Cantidad!Calculada" FORMAT ">,>>>,>>9.9999":U
      logisdchequeo.FechaHora FORMAT "99/99/9999 HH:MM:SS":U WIDTH 21.86
  ENABLE
      logisdchequeo.CodMat
      logisdchequeo.UndVta
      logisdchequeo.CanChk
      logisdchequeo.Factor
      logisdchequeo.CanPed
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 143 BY 18.31
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
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
      TABLE: B-CMOV B "?" ? INTEGRAL Almcmov
      TABLE: b-Detalle B "?" ? INTEGRAL logisdchequeo
      TABLE: B-DMOV B "?" ? INTEGRAL Almdmov
      TABLE: t-Detalle T "?" NO-UNDO INTEGRAL logisdchequeo
      TABLE: T-DINCI T "?" NO-UNDO INTEGRAL AlmDIncidencia
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
         HEIGHT             = 18.42
         WIDTH              = 144.43.
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
"Almmmatg.DesMat" ? "X(80)" "character" ? ? ? ? ? ? no ? no no "52.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "!Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.logisdchequeo.UndVta
"logisdchequeo.UndVta" "Unidad" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.logisdchequeo.CanChk
"logisdchequeo.CanChk" "Cantidad" ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.logisdchequeo.Factor
"logisdchequeo.Factor" ? ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.logisdchequeo.CanPed
"logisdchequeo.CanPed" "Cantidad!Calculada" ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.logisdchequeo.FechaHora
"logisdchequeo.FechaHora" ? "99/99/9999 HH:MM:SS" "datetime" ? ? ? ? ? ? no ? no no "21.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
          RUN vtagn/p-codbarra-ean14 (INPUT-OUTPUT pCodMat, INPUT-OUTPUT pFactor, s-codcia).
          IF pFactor = 0 THEN DO:
              MESSAGE 'Códigos EAN-14 NO registrado' VIEW-AS ALERT-BOX ERROR.
              logisdchequeo.canped:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '1'.
              SELF:SCREEN-VALUE = ''.
              RETURN NO-APPLY.
          END.
      END.
      OTHERWISE DO:
          /* EAN 13 o 14 */
          RUN alm/p-codbrr (INPUT-OUTPUT pCodMat, INPUT-OUTPUT pFactor, s-codcia).
          IF TRUE <> (pCodMat > '') THEN DO:
              MESSAGE 'Código NO registrado' VIEW-AS ALERT-BOX ERROR.
              logisdchequeo.canped:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '1'.
              SELF:SCREEN-VALUE = ''.
              RETURN NO-APPLY.
          END.
      END.
  END CASE.

  ASSIGN SELF:SCREEN-VALUE = pCodMat NO-ERROR.
  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = SELF:SCREEN-VALUE NO-LOCK.
  FIND FIRST T-DPEDI WHERE T-DPEDI.codmat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
/*   IF NOT AVAILABLE T-DPEDI THEN DO:                                          */
/*       MESSAGE 'Artículo NO registrado en el Pedido' VIEW-AS ALERT-BOX ERROR. */
/*       SELF:SCREEN-VALUE = ''.                                                */
/*       logisdchequeo.canped:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '1'.      */
/*       RETURN NO-APPLY.                                                       */
/*   END.                                                                       */

  DISPLAY
      Almmmatg.desmat 
      (IF AVAILABLE T-DPEDI THEN T-DPEDI.undvta ELSE Almmmatg.UndStk) @ logisdchequeo.undvta
      pCanPed @ logisdchequeo.CanChk
      pFactor @ logisdchequeo.Factor
      WITH BROWSE {&BROWSE-NAME}.
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
    logisdchequeo.CanPed:SCREEN-VALUE IN BROWSE {&browse-name} = 
        STRING( DECIMAL(logisdchequeo.CanChk:SCREEN-VALUE IN BROWSE {&browse-name}) *
                DECIMAL(logisdchequeo.Factor:SCREEN-VALUE IN BROWSE {&browse-name}) ).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF logisdchequeo.CanChk, logisdchequeo.CodMat
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

DEFINE INPUT PARAMETER pTipo   AS CHAR.     /* M o BC */
DEFINE INPUT PARAMETER pCoddoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.

ASSIGN
    x-Tipo   = pTipo
    x-CodDoc = pCodDoc      /* OTR */
    x-NroDoc = pNroDoc
    .
FIND Faccpedi WHERE Faccpedi.codcia = s-codcia 
    AND Faccpedi.coddoc = x-CodDoc
    AND Faccpedi.nroped = x-NroDoc
    NO-LOCK NO-ERROR.
/* IF NOT AVAILABLE Faccpedi THEN DO:                                      */
/*     MESSAGE pCodDoc pNroDoc ' NO encontrada' VIEW-AS ALERT-BOX WARNING. */
/*     RETURN.                                                             */
/* END.                                                                    */

RUN dispatch IN THIS-PROCEDURE ('open-query':U).
IF TRUE <> (x-NroDoc > '') THEN RETURN.

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

/* RHC 13.07.2012 CARGAMOS TODO EN UNIDADES DE STOCK 
    NO LE AFECTA A LAS VENTAS AL CREDITO 
*/
IF NOT AVAILABLE Faccpedi THEN RETURN.
FOR EACH Facdpedi OF Faccpedi NO-LOCK,
    FIRST Almmmatg OF Facdpedi NO-LOCK:
    FIND FIRST T-DPEDI WHERE T-DPEDI.codmat = Facdpedi.codmat NO-ERROR.
    IF NOT AVAILABLE T-DPEDI THEN DO:
        CREATE T-DPEDI.
        ASSIGN
            T-DPEDI.CodCia = Facdpedi.codcia
            T-DPEDI.CodMat = Facdpedi.codmat
            T-DPEDI.UndVta = Almmmatg.UndStk
            T-DPEDI.CanPed = Facdpedi.canped * Facdpedi.factor
            T-DPEDI.Factor = 1.     
    END.
    ELSE T-DPEDI.canped = T-DPEDI.canped + (Facdpedi.canate * Facdpedi.factor).
    ASSIGN T-DPEDI.Kit = NO.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Inicial B-table-Win 
PROCEDURE Carga-Inicial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF x-Tipo <> "M" THEN RETURN.
IF CAN-FIND(FIRST logisdchequeo WHERE logisdchequeo.CodCia = s-CodCia AND
            logisdchequeo.CodDiv = s-CodDiv AND
            logisdchequeo.CodPed = x-CodDoc AND
            logisdchequeo.NroPed = x-NroDoc NO-LOCK)
    THEN RETURN.
FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
    CREATE logisdchequeo.
    ASSIGN
        logisdchequeo.CodCia = s-codcia
        logisdchequeo.CodDiv = s-coddiv
        logisdchequeo.CodPed = Facdpedi.coddoc
        logisdchequeo.NroPed = Facdpedi.nroped
        logisdchequeo.NroItm = Facdpedi.nroitm
        logisdchequeo.CodMat = Facdpedi.codmat
        logisdchequeo.CanChk = Facdpedi.canped * Facdpedi.factor
        logisdchequeo.CanPed = Facdpedi.canped * Facdpedi.factor
        logisdchequeo.Factor = 1
        logisdchequeo.FechaHora = NOW
        logisdchequeo.Multiple = NO
        logisdchequeo.UndVta = Almmmatg.UndStk
        logisdchequeo.Usuario = s-user-id.
    FIND AdmCtrlUsers WHERE AdmCtrlUsers.NumId = PrcId NO-LOCK NO-ERROR.
    IF AVAILABLE AdmCtrlUsers THEN DO:
        ASSIGN
            logisdchequeo.IDUsuario = AdmCtrlUsers.IDUsuario 
            logisdchequeo.PCCliente = AdmCtrlUsers.PCCliente 
            logisdchequeo.PCRemoto = AdmCtrlUsers.PCRemoto 
            logisdchequeo.PCUsuario = AdmCtrlUsers.PCUsuario 
            logisdchequeo.UserCliente = AdmCtrlUsers.UserCliente.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cerrar-Orden B-table-Win 
PROCEDURE Cerrar-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Verificamos si hay alguna inconsistencia */
  
  /* Acumulamos */
  EMPTY TEMP-TABLE t-Detalle.
  FOR EACH b-Detalle NO-LOCK WHERE b-Detalle.CodCia = s-CodCia
      AND b-Detalle.CodDiv = s-CodDiv
      AND b-Detalle.CodPed = x-CodDoc
      AND b-Detalle.NroPed = x-NroDoc,
      FIRST Almmmatg OF b-Detalle NO-LOCK:
      FIND t-Detalle WHERE t-Detalle.codmat = b-Detalle.codmat
          EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF NOT AVAILABLE t-Detalle THEN CREATE t-Detalle.
      ASSIGN
          t-Detalle.CodCia = s-CodCia
          t-Detalle.CodMat = b-Detalle.CodMat
          t-Detalle.UndVta = Almmmatg.UndStk
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
          t-Detalle.UndVta = T-DPEDI.UndVta
          t-Detalle.CanPed = t-Detalle.CanPed + T-DPEDI.CanPed.
  END.
  /* ***************************************************************************************** */
  /* Buscamos inconsistencias */
  /* ***************************************************************************************** */
  DEF VAR pEstado AS CHAR NO-UNDO.
  IF CAN-FIND(FIRST t-Detalle WHERE t-Detalle.CanPed <> t-Detalle.CanChk) THEN DO:
      /* Incosistencia: Entramos a la pantalla de verificación */
      pEstado = "".
      RUN alm/d-cierre-chk-ing-tra-otr (INPUT-OUTPUT TABLE t-Detalle, OUTPUT pEstado).
      IF pEstado = "ADM-ERROR" THEN DO:
          RETURN "ADM-ERROR".     /* CONTINUA CON EL CHEQUEO */
      END.
      /* Rutina: Genera la INCIDENCIA */
      /* SOlicitamos Chequeador */
      RUN vtamay/d-chqped (OUTPUT x-UsrChq).
      IF x-UsrChq = '' THEN RETURN 'ADM-ERROR'.
      RUN Cierre-Con-INC.
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo cerrar la orden".
          MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
  END.
  ELSE DO:
      /* SOlicitamos Chequeador */
      RUN vtamay/d-chqped (OUTPUT x-UsrChq).
      IF x-UsrChq = '' THEN RETURN 'ADM-ERROR'.
      pMensaje = "".
      RUN alm/p-genera-ingtransf-otr-v2.p (INPUT x-CodDoc,
                                           INPUT x-NroDoc,
                                           INPUT x-UsrChq,
                                           OUTPUT pMensaje).
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
  END.
  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierre-Con-INC B-table-Win 
PROCEDURE Cierre-Con-INC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Generamos un registro de INCIDENCIA que pasa al supervisor */

/* Preparamos la tabla de incidencia */
/* Cargamos la incidencia */
EMPTY TEMP-TABLE T-DINCI.
FOR EACH t-Detalle NO-LOCK WHERE t-Detalle.CanPed <> t-Detalle.CanChk:
    CREATE T-DINCI.
    ASSIGN
        T-DINCI.CodMat = t-Detalle.CodMat
        T-DINCI.UndVta = t-Detalle.UndVta
        T-DINCI.Factor = 1
        T-DINCI.CanPed = t-Detalle.CanPed
        T-DINCI.CanInc = ABS(t-Detalle.CanPed - t-Detalle.CanChk).
    T-DINCI.Incidencia = t-Detalle.Etiqueta.
END.
RELEASE T-DINCI.

/* ***************************************************************************************** */
/* CARGAMOS LIBRERIAS */
/* ***************************************************************************************** */
DEFINE VAR hProc AS HANDLE NO-UNDO.
RUN gn/master-library.p PERSISTENT SET hProc.
pMensaje = "".
RUN Genera-INC IN hProc (INPUT ROWID(Faccpedi),     /* OTR */
                         INPUT TABLE T-DINCI,
                         INPUT "",                  /* Responsable de Distribución */
                         INPUT "G",                 /* FlgEst: Pasa al Supervisor para resolver la INC */
                         INPUT x-UsrChq,
                         OUTPUT pMensaje).
DELETE PROCEDURE hProc.
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar la Incidencia'.
    UNDO, RETURN 'ADM-ERROR'.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FIRST-TRANSACTION B-table-Win 
PROCEDURE FIRST-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-CrossDocking AS LOG INIT NO NO-UNDO.
DEF VAR x-MsgCrossDocking AS CHAR NO-UNDO.
DEF VAR R-ROWID AS ROWID NO-UNDO.

DEF BUFFER ORDEN  FOR FacCPedi.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    CREATE Almcmov.
    ASSIGN
        Almcmov.FchDoc = TODAY
        Almcmov.CodAlm = B-CMOV.AlmDes
        Almcmov.AlmDes = B-CMOV.CodAlm
        Almcmov.NroRf1 = STRING(B-CMOV.NroSer, '999') + STRING(B-CMOV.NroDoc)
        Almcmov.NroRf3 = B-CMOV.NroRf3
        Almcmov.AlmacenXD = B-CMOV.AlmacenXD
        Almcmov.CrossDocking = B-CMOV.CrossDocking.
    /* NO se aceptan Cross Docking */
    RUN Rutina-Normal.
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
    x-CrossDocking = NO.
/*     IF B-CMOV.CrossDocking = YES THEN DO:                            */
/*         RUN Rutina-Cross-Docking.                                    */
/*         IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR". */
/*         x-CrossDocking = YES.                                        */
/*     END.                                                             */
/*     ELSE DO:                                                         */
/*         RUN Rutina-Normal.                                           */
/*         IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR". */
/*         x-CrossDocking = NO.                                         */
/*     END.                                                             */
    /* ****************************************** */
    /* RHC 18/08/18 Almacenamos la OTR del ORIGEN */
    /* ****************************************** */
    ASSIGN
        Almcmov.CodRef = B-CMOV.CodRef
        Almcmov.NroRef = B-CMOV.NroRef.
    /* ************************************************************************************ */
    /* Detalle */
    /* ************************************************************************************ */
    FOR EACH B-DMOV OF B-CMOV NO-LOCK WHERE B-DMOV.codmat > "" ON ERROR UNDO, THROW:
        CREATE almdmov.
        ASSIGN 
            Almdmov.CodCia = Almcmov.CodCia 
            Almdmov.CodAlm = Almcmov.CodAlm 
            Almdmov.TipMov = Almcmov.TipMov 
            Almdmov.CodMov = Almcmov.CodMov 
            Almdmov.NroSer = Almcmov.NroSer 
            Almdmov.NroDoc = Almcmov.NroDoc 
            Almdmov.CodMon = Almcmov.CodMon 
            Almdmov.FchDoc = Almcmov.FchDoc 
            Almdmov.TpoCmb = Almcmov.TpoCmb 
            Almdmov.codmat = B-DMOV.codmat 
            Almdmov.CanDes = B-DMOV.CanDes 
            Almdmov.CodUnd = B-DMOV.CodUnd 
            Almdmov.Factor = B-DMOV.Factor 
            Almdmov.ImpCto = B-DMOV.ImpCto 
            Almdmov.PreUni = B-DMOV.PreUni 
            Almdmov.AlmOri = Almcmov.AlmDes 
            Almdmov.CodAjt = '' 
            Almdmov.HraDoc = Almcmov.HorRcp
            R-ROWID = ROWID(Almdmov).
        RUN ALM\ALMACSTK (R-ROWID).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, RETURN 'ADM-ERROR'.
        RUN alm/almacpr1 (R-ROWID, 'U').
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        Almcmov.Libre_L02 = B-CMOV.Libre_L02    /* URGENTE */
        Almcmov.Libre_C05 = B-CMOV.Libre_C05.   /* MOTIVO */
    /* ************************************************************************************ */
    /* Recepcionamos la G/R de origen */
    /* ************************************************************************************ */
    ASSIGN 
        B-CMOV.FlgSit  = "R" 
        B-CMOV.HorRcp  = STRING(TIME,"HH:MM:SS")
        B-CMOV.NroRf2  = STRING(Almcmov.NroDoc).
    /* ********************************************************************* */
    /* RHC 21/12/2017 MIGRACION DE ORDENES DE DESPACHO DEL ORIGEN AL DESTINO */
    /* SOLO PARA CROSSDOCKING */
    /* ********************************************************************* */
/*     DEFINE VAR hProc AS HANDLE NO-UNDO.                              */
/*     RUN gn/xd-library PERSISTEN SET hProc.                           */
/*     RUN XD_Cierre-IngTra-OTR (INPUT ROWID(B-CMOV), OUTPUT pMensaje). */
/*     DELETE PROCEDURE hProc.                                          */
/*     IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.     */
    /* ********************************************************************* */
    /* ********************************************************************* */
    /* RHC 01/12/17 Log para e-Commerce */
    DEF VAR pOk AS LOG NO-UNDO.
    RUN gn/log-inventory-qty.p (ROWID(Almcmov),
                                "C",      /* CREATE */
                                OUTPUT pOk).
    IF pOk = NO THEN DO:
        pMensaje = "NO se pudo actualizar el log de e-Commerce".
        UNDO, RETURN 'ADM-ERROR'.
    END.
END.
IF AVAILABLE(Almcmov) THEN RELEASE Almcmov.
IF AVAILABLE(Almdmov) THEN RELEASE Almdmov.
RETURN 'OK'.

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
  FOR EACH B-DETA NO-LOCK WHERE B-DETA.CodCia = s-CodCia AND
      B-DETA.CodDiv = s-CodDiv AND
      B-DETA.CodPed = x-CodDoc AND
      B-DETA.NroPed = x-NroDoc
      BY B-DETA.NroItm:
      x-Item = x-Item + 1.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND AdmCtrlUsers WHERE AdmCtrlUsers.NumId = PrcId NO-LOCK NO-ERROR.
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
          /* Generamos varias líneas */
          FIND B-DETA WHERE ROWID(B-DETA) = ROWID(LogisdChequeo) NO-LOCK.
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
              RUN Etiquetar-Bulto.
              x-Item = x-Item + 1.
          END.
      END.
      OTHERWISE DO:
          /* Rutina Normal */
          ASSIGN
              logisdchequeo.nroitm = x-item
              logisdchequeo.canped = logisdchequeo.CanChk * logisdchequeo.Factor.
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
  ASSIGN
      logisdchequeo.CanPed:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES
      logisdchequeo.Factor:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES
      logisdchequeo.UndVta:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN DO:
      ASSIGN 
        logisdchequeo.CodMat:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
      APPLY 'ENTRY':U TO logisdchequeo.CanChk IN BROWSE {&BROWSE-NAME}.
  END.
  ELSE 
      ASSIGN 
        logisdchequeo.CodMat:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.

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
  RUN Carga-Inicial.

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
  RUN Procesa-Handle IN lh_handle ('enable-campos').
  RUN Procesa-Handle IN lh_handle ('Add-Record').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MASTER-TRANSACTION B-table-Win 
PROCEDURE MASTER-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Por cada G/R relacionada a la OTR se va a generar un movimie I-03
------------------------------------------------------------------------------*/

  CICLO:
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      pMensaje = 'Orden de Transferencia NO registrada o anulada'.
      {lib/lock-genericov3.i ~
          &Tabla="Faccpedi" ~
          &Condicion="Faccpedi.codcia = s-codcia ~
                        AND Faccpedi.coddoc = x-CodDoc ~
                        AND Faccpedi.nroped = x-NroDoc" ~
          &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
          &Accion="RETRY" ~
          &Mensaje="NO" ~
          &txtMensaje="pMensaje" ~
          &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
          }
      /* Verificamos la salida del almacén */
      IF NOT CAN-FIND(FIRST B-CMOV WHERE B-CMOV.codcia = s-codcia
                      AND B-CMOV.TipMov = "S" 
                      AND B-CMOV.CodMov = 03
                      AND B-CMOV.CodRef = Faccpedi.coddoc
                      AND B-CMOV.NroRef = Faccpedi.nroped
                      AND B-CMOV.FlgEst <> 'A'
                      AND B-CMOV.FlgSit = "T" NO-LOCK)
          THEN DO:
          pMensaje = 'NO tiene ninguna G/R pendiente de recepcionar' + CHR(10) +
              'Proceso Abortado'.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      /* Barremos todas las G/R relacionadas a la OTR que aún no han sido recepcionadas */
      FOR EACH B-CMOV EXCLUSIVE-LOCK WHERE B-CMOV.codcia = s-codcia
          AND B-CMOV.TipMov = "S" 
          AND B-CMOV.CodMov = 03
          AND B-CMOV.CodRef = Faccpedi.coddoc
          AND B-CMOV.NroRef = Faccpedi.nroped
          AND B-CMOV.FlgEst <> 'A'
          AND B-CMOV.FlgSit = "T" ON ERROR UNDO, THROW:
          RUN FIRST-TRANSACTION.    /* Crea I-03 */
          IF RETURN-VALUE = "ADM-ERROR" THEN DO:
              IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo generar el ingreso por transferencia" + CHR(10) +
                  "para la G/R " + STRING(B-CMOV.NroSer, '999') + STRING(B-CMOV.NroDoc, '99999999').
              UNDO CICLO, LEAVE CICLO.
          END.
      END.
      /* GRABACIONES FINALES */
      RUN lib/logtabla ( "FACCPEDI", 
                         s-coddiv + '|' + faccpedi.coddoc + '|' + faccpedi.nroped + '|' + ~
                         STRING(TODAY,'99/99/9999') + '|' + STRING(TIME,'HH:MM:SS') + '|' + ~
                         x-UsrChq, "CHKDESTINO" ).
  END.
  IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
  IF AVAILABLE(B-CMOV)   THEN RELEASE B-CMOV.
  IF pMensaje > '' THEN RETURN 'ADM-ERROR'.
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

EMPTY TEMP-TABLE t-Detalle.

FOR EACH b-Detalle EXCLUSIVE-LOCK WHERE b-Detalle.CodCia = s-CodCia
    AND b-Detalle.CodDiv = s-CodDiv
    AND b-Detalle.CodPed = x-CodDoc
    AND b-Detalle.NroPed = x-NroDoc 
    AND b-Detalle.Etiqueta > '':
    CREATE t-Detalle.
    BUFFER-COPY b-Detalle TO t-Detalle.
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
        t-Detalle.Etiqueta = x-Llave + STRING(x-bulto,"999")
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rutina-Cross-Docking B-table-Win 
PROCEDURE Rutina-Cross-Docking :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Nrodoc LIKE Almtdocm.NroDoc NO-UNDO.

pMensaje = ''.
FIND FIRST Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.coddiv = s-coddiv
    AND Almacen.campo-c[1] = "XD"
    AND Almacen.campo-c[9] <> 'I'
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almacen THEN DO:
    pMensaje = "NO definido el almacén de Cross Docking".
    RETURN "ADM-ERROR".
END.
IF NOT CAN-FIND(FIRST Almtdocm WHERE Almtdocm.CodCia = s-CodCia AND
                Almtdocm.CodAlm = Almacen.CodAlm AND
                Almtdocm.TipMov = 'I' AND
                Almtdocm.CodMov = s-CodMov)
    THEN DO:
    pMensaje = "NO definido el movimiento de ingreso por transferencia en el almacén " +
        Almacen.CodAlm.
    RETURN "ADM-ERROR".
END.
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="Almtdocm" ~
        &Condicion="Almtdocm.CodCia = S-CODCIA AND ~
            Almtdocm.CodAlm = Almacen.CodAlm AND ~
            Almtdocm.TipMov = 'I' AND ~
            Almtdocm.CodMov = S-CODMOV" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        }
    ASSIGN x-Nrodoc = Almtdocm.NroDoc.
    REPEAT:
        IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia
                        AND Almcmov.CodAlm = Almtdocm.CodAlm 
                        AND Almcmov.TipMov = Almtdocm.TipMov
                        AND Almcmov.CodMov = Almtdocm.CodMov
                        AND Almcmov.NroSer = 000
                        AND Almcmov.NroDoc = x-NroDoc
                        NO-LOCK)
            THEN LEAVE.
        ASSIGN
            x-NroDoc = x-NroDoc + 1.
    END.
    ASSIGN
        Almcmov.CodCia  = Almtdocm.CodCia 
        Almcmov.CodAlm  = Almacen.CodAlm      /* Almacén de Cross Docking */
        Almcmov.TipMov  = Almtdocm.TipMov 
        Almcmov.CodMov  = Almtdocm.CodMov 
        Almcmov.NroSer  = 000
        Almcmov.NroDoc  = x-NroDoc
        Almcmov.FlgSit  = ""
        Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS")
        Almcmov.usuario = S-USER-ID
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        Almtdocm.NroDoc = x-NroDoc + 1.
END.
IF AVAILABLE(Almtdocm) THEN RELEASE Almtdocm.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rutina-Normal B-table-Win 
PROCEDURE Rutina-Normal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Nrodoc LIKE Almtdocm.NroDoc NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="Almtdocm" ~
        &Condicion="Almtdocm.CodCia = S-CODCIA AND ~
        Almtdocm.CodAlm = s-CodAlm AND ~
        Almtdocm.TipMov = 'I' AND ~
        Almtdocm.CodMov = S-CODMOV" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        }
    ASSIGN 
        x-Nrodoc  = Almtdocm.NroDoc.
    REPEAT:
        IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia
                        AND Almcmov.CodAlm = Almtdocm.CodAlm 
                        AND Almcmov.TipMov = Almtdocm.TipMov
                        AND Almcmov.CodMov = Almtdocm.CodMov
                        AND Almcmov.NroSer = 000
                        AND Almcmov.NroDoc = x-NroDoc
                        NO-LOCK)
            THEN LEAVE.
        ASSIGN
            x-NroDoc = x-NroDoc + 1.
    END.
    ASSIGN
        Almcmov.CodCia  = Almtdocm.CodCia 
        Almcmov.TipMov  = Almtdocm.TipMov 
        Almcmov.CodMov  = Almtdocm.CodMov 
        Almcmov.NroSer  = 000
        Almcmov.NroDoc  = x-NroDoc
        Almcmov.FlgSit  = ""
        Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS")
        Almcmov.usuario = S-USER-ID
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje"}
        RETURN "ADM-ERROR".
    END.
    ASSIGN
        Almtdocm.NroDoc = x-NroDoc + 1.
END.
IF AVAILABLE(Almtdocm) THEN RELEASE Almtdocm.

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
  Notes:       Simempre es CREAR, nunca MODIFICAR
------------------------------------------------------------------------------*/

  /* CHequeamos acumulado */
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
      MESSAGE 'CANTIDAD ingresada SUPERA la del pedido' SKIP
          'Se continúa con el proceso' VIEW-AS ALERT-BOX WARNING.
  END.
/*   IF AVAILABLE T-DPEDI AND x-CanPed > T-DPEDI.canped THEN DO: */
/*       MESSAGE 'CANTIDAD ingresada SUPERA la del pedido'       */
/*           VIEW-AS ALERT-BOX ERROR.                            */
/*       RETURN 'ADM-ERROR'.                                     */
/*   END.                                                        */
  
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

  IF x-Tipo = "BC" THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX INFORMATION.
      RETURN "ADM-ERROR".
  END.
  RETURN 'OK'.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

