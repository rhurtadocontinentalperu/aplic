&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER ORDENES FOR FacCPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE SHARED TEMP-TABLE T-CALMD NO-UNDO LIKE AlmCDocu
       FIELD CodDiv AS CHAR.



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
DEF SHARED VAR s-codcia AS INT.
/* Local Variable Definitions ---                                       */

DEF VAR x-CodPed AS CHAR NO-UNDO.
DEF VAR x-CodDiv AS CHAR NO-UNDO.

&SCOPED-DEFINE Condicion ( T-CALMD.CodCia = s-codcia ~
AND T-CALMD.CodDoc = x-CodPed ~
AND ( TRUE <> (x-CodDiv > '') OR T-CALMD.CodDiv = x-CodDiv ) )

DEF VAR x-NroRep AS INT NO-UNDO.        /* Nro. de reprogramaciones */

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
&Scoped-define INTERNAL-TABLES T-CALMD FacCPedi PEDIDO CcbCBult

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-CALMD.Libre_d05 T-CALMD.CodLlave ~
fNroRep() @ x-NroRep PEDIDO.CodRef PEDIDO.NroRef PEDIDO.CodDoc ~
PEDIDO.NroPed T-CALMD.CodDoc T-CALMD.NroDoc FacCPedi.FchEnt FacCPedi.NomCli ~
T-CALMD.Libre_c01 T-CALMD.Libre_c02 T-CALMD.Libre_d01 T-CALMD.Libre_d02 ~
T-CALMD.Libre_d03 fEstadoDet() @ T-CALMD.Libre_c03 ~
fNombre() @ T-CALMD.UsrCreacion CcbCBult.Bultos 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH T-CALMD WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      EACH FacCPedi WHERE FacCPedi.CodCia = T-CALMD.CodCia ~
  AND FacCPedi.CodDoc = T-CALMD.CodDoc ~
  AND FacCPedi.NroPed = T-CALMD.NroDoc NO-LOCK, ~
      EACH PEDIDO WHERE PEDIDO.CodCia = FacCPedi.CodCia ~
  AND PEDIDO.CodDoc = FacCPedi.CodRef ~
  AND PEDIDO.NroPed = FacCPedi.NroRef NO-LOCK, ~
      FIRST CcbCBult WHERE CcbCBult.CodCia = T-CALMD.CodCia ~
  AND CcbCBult.CodDoc = T-CALMD.CodDoc ~
  AND CcbCBult.NroDoc = T-CALMD.NroDoc OUTER-JOIN NO-LOCK ~
    BY T-CALMD.Libre_d05
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-CALMD WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      EACH FacCPedi WHERE FacCPedi.CodCia = T-CALMD.CodCia ~
  AND FacCPedi.CodDoc = T-CALMD.CodDoc ~
  AND FacCPedi.NroPed = T-CALMD.NroDoc NO-LOCK, ~
      EACH PEDIDO WHERE PEDIDO.CodCia = FacCPedi.CodCia ~
  AND PEDIDO.CodDoc = FacCPedi.CodRef ~
  AND PEDIDO.NroPed = FacCPedi.NroRef NO-LOCK, ~
      FIRST CcbCBult WHERE CcbCBult.CodCia = T-CALMD.CodCia ~
  AND CcbCBult.CodDoc = T-CALMD.CodDoc ~
  AND CcbCBult.NroDoc = T-CALMD.NroDoc OUTER-JOIN NO-LOCK ~
    BY T-CALMD.Libre_d05.
&Scoped-define TABLES-IN-QUERY-br_table T-CALMD FacCPedi PEDIDO CcbCBult
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-CALMD
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define THIRD-TABLE-IN-QUERY-br_table PEDIDO
&Scoped-define FOURTH-TABLE-IN-QUERY-br_table CcbCBult


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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstadoDet B-table-Win 
FUNCTION fEstadoDet RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNombre B-table-Win 
FUNCTION fNombre RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNroRep B-table-Win 
FUNCTION fNroRep RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-CALMD, 
      FacCPedi
    FIELDS(FacCPedi.FchEnt
      FacCPedi.NomCli), 
      PEDIDO
    FIELDS(PEDIDO.CodRef
      PEDIDO.NroRef
      PEDIDO.CodDoc
      PEDIDO.NroPed), 
      CcbCBult
    FIELDS(CcbCBult.Bultos) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-CALMD.Libre_d05 COLUMN-LABEL "Nro" FORMAT ">>>,>>9":U WIDTH 4.43
      T-CALMD.CodLlave COLUMN-LABEL "División" FORMAT "x(8)":U
      fNroRep() @ x-NroRep COLUMN-LABEL "Reprog." FORMAT ">>9":U
      PEDIDO.CodRef COLUMN-LABEL "Doc." FORMAT "x(3)":U WIDTH 5.43
      PEDIDO.NroRef COLUMN-LABEL "Nro. Cotiz." FORMAT "X(12)":U
            WIDTH 9.43
      PEDIDO.CodDoc COLUMN-LABEL "Doc." FORMAT "x(3)":U WIDTH 3.43
      PEDIDO.NroPed COLUMN-LABEL "Nro. Pedido" FORMAT "X(12)":U
            WIDTH 8.43
      T-CALMD.CodDoc COLUMN-LABEL "Doc." FORMAT "x(3)":U WIDTH 3.43
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      T-CALMD.NroDoc COLUMN-LABEL "Nro. Orden" FORMAT "X(12)":U
            WIDTH 9.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      FacCPedi.FchEnt FORMAT "99/99/9999":U WIDTH 10.43
      FacCPedi.NomCli COLUMN-LABEL "Nombre del Cliente" FORMAT "x(50)":U
            WIDTH 37.43
      T-CALMD.Libre_c01 COLUMN-LABEL "Doc." FORMAT "x(3)":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      T-CALMD.Libre_c02 COLUMN-LABEL "Nro. H/R" FORMAT "x(12)":U
            WIDTH 9.86 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      T-CALMD.Libre_d01 COLUMN-LABEL "Importe" FORMAT "->>,>>9.99":U
      T-CALMD.Libre_d02 COLUMN-LABEL "Peso" FORMAT "->>,>>9.99":U
      T-CALMD.Libre_d03 COLUMN-LABEL "m3" FORMAT "->>,>>9.99":U
      fEstadoDet() @ T-CALMD.Libre_c03 COLUMN-LABEL "Motivo de no entregado" FORMAT "x(30)":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 13
      fNombre() @ T-CALMD.UsrCreacion COLUMN-LABEL "Primer Responsable Ruta" FORMAT "x(40)":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 13
      CcbCBult.Bultos FORMAT ">>>9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 142 BY 14.54
         FONT 4
         TITLE "PEDIDOS".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: ORDENES B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: T-CALMD T "SHARED" NO-UNDO INTEGRAL AlmCDocu
      ADDITIONAL-FIELDS:
          FIELD CodDiv AS CHAR
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
         HEIGHT             = 15.46
         WIDTH              = 143.14.
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

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 1.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-CALMD,INTEGRAL.FacCPedi WHERE Temp-Tables.T-CALMD ...,PEDIDO WHERE INTEGRAL.FacCPedi ...,INTEGRAL.CcbCBult WHERE Temp-Tables.T-CALMD ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", USED, USED, FIRST OUTER USED"
     _OrdList          = "Temp-Tables.T-CALMD.Libre_d05|yes"
     _Where[1]         = "{&Condicion}"
     _JoinCode[2]      = "INTEGRAL.FacCPedi.CodCia = Temp-Tables.T-CALMD.CodCia
  AND INTEGRAL.FacCPedi.CodDoc = Temp-Tables.T-CALMD.CodDoc
  AND INTEGRAL.FacCPedi.NroPed = Temp-Tables.T-CALMD.NroDoc"
     _JoinCode[3]      = "PEDIDO.CodCia = INTEGRAL.FacCPedi.CodCia
  AND PEDIDO.CodDoc = INTEGRAL.FacCPedi.CodRef
  AND PEDIDO.NroPed = INTEGRAL.FacCPedi.NroRef"
     _JoinCode[4]      = "INTEGRAL.CcbCBult.CodCia = Temp-Tables.T-CALMD.CodCia
  AND INTEGRAL.CcbCBult.CodDoc = Temp-Tables.T-CALMD.CodDoc
  AND INTEGRAL.CcbCBult.NroDoc = Temp-Tables.T-CALMD.NroDoc"
     _FldNameList[1]   > Temp-Tables.T-CALMD.Libre_d05
"Temp-Tables.T-CALMD.Libre_d05" "Nro" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-CALMD.CodLlave
"Temp-Tables.T-CALMD.CodLlave" "División" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fNroRep() @ x-NroRep" "Reprog." ">>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.PEDIDO.CodRef
"Temp-Tables.PEDIDO.CodRef" "Doc." ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.PEDIDO.NroRef
"Temp-Tables.PEDIDO.NroRef" "Nro. Cotiz." ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.PEDIDO.CodDoc
"Temp-Tables.PEDIDO.CodDoc" "Doc." ? "character" ? ? ? ? ? ? no ? no no "3.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.PEDIDO.NroPed
"Temp-Tables.PEDIDO.NroPed" "Nro. Pedido" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-CALMD.CodDoc
"Temp-Tables.T-CALMD.CodDoc" "Doc." ? "character" 11 0 ? ? ? ? no ? no no "3.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-CALMD.NroDoc
"Temp-Tables.T-CALMD.NroDoc" "Nro. Orden" "X(12)" "character" 11 0 ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.FacCPedi.FchEnt
"INTEGRAL.FacCPedi.FchEnt" ? ? "date" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.FacCPedi.NomCli
"INTEGRAL.FacCPedi.NomCli" "Nombre del Cliente" ? "character" ? ? ? ? ? ? no ? no no "37.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.T-CALMD.Libre_c01
"Temp-Tables.T-CALMD.Libre_c01" "Doc." "x(3)" "character" 14 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.T-CALMD.Libre_c02
"Temp-Tables.T-CALMD.Libre_c02" "Nro. H/R" "x(12)" "character" 14 0 ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.T-CALMD.Libre_d01
"Temp-Tables.T-CALMD.Libre_d01" "Importe" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.T-CALMD.Libre_d02
"Temp-Tables.T-CALMD.Libre_d02" "Peso" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.T-CALMD.Libre_d03
"Temp-Tables.T-CALMD.Libre_d03" "m3" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"fEstadoDet() @ T-CALMD.Libre_c03" "Motivo de no entregado" "x(30)" ? 13 15 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > "_<CALC>"
"fNombre() @ T-CALMD.UsrCreacion" "Primer Responsable Ruta" "x(40)" ? 13 15 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > INTEGRAL.CcbCBult.Bultos
"INTEGRAL.CcbCBult.Bultos" ? ">>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* PEDIDOS */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* PEDIDOS */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* PEDIDOS */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
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

DEF INPUT PARAMETER pCodPed AS CHAR.
DEF INPUT PARAMETER pCodDiv AS CHAR.

x-CodPed = pCodPed.
x-CodDiv = pCodDiv.

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
  {src/adm/template/snd-list.i "T-CALMD"}
  {src/adm/template/snd-list.i "FacCPedi"}
  {src/adm/template/snd-list.i "PEDIDO"}
  {src/adm/template/snd-list.i "CcbCBult"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstadoDet B-table-Win 
FUNCTION fEstadoDet RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

FIND AlmTabla WHERE AlmTabla.Tabla = 'HR'
    AND AlmTabla.Codigo = T-CALMD.Libre_c03
    AND almtabla.NomAnt = 'N'
    NO-LOCK NO-ERROR.
IF AVAILABLE AlmTabla THEN RETURN almtabla.Nombre.
RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNombre B-table-Win 
FUNCTION fNombre RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR pNombre AS CHAR.

/* Dede ser el primer responsable de la hoja de ruta */
FIND DI-RutaC WHERE DI-RutaC.CodCia = s-CodCia AND
    DI-RutaC.CodDiv = T-CALMD.CodLlave AND 
    DI-RutaC.CodDoc = T-CALMD.Libre_c01 AND 
    DI-RutaC.NroDoc = T-CALMD.Libre_c02
    NO-LOCK NO-ERROR.
IF AVAILABLE DI-RutaC THEN RUN gn/nombre-personal (s-CodCia, DI-RutaC.responsable, OUTPUT pNombre).
/*RUN gn/nombre-usuario (T-CALMD.UsrCreacion, OUTPUT pNombre).*/
RETURN pNombre.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNroRep B-table-Win 
FUNCTION fNroRep RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pNroRep AS INT NO-UNDO.

  FOR EACH logtabla NO-LOCK WHERE logtabla.codcia = s-codcia
      AND logtabla.Evento = "REPROGRAMACION"
      AND logtabla.Tabla = 'ALMCDOCU'
      AND logtabla.ValorLlave BEGINS T-CALMD.CodLlave + '|' + T-CALMD.CodDoc + '|' + T-CALMD.NroDoc:
      pNroRep = pNroRep + 1.
  END.
  RETURN pNroRep.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

