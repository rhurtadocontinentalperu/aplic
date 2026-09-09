&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-VtaCDocu NO-UNDO LIKE VtaCDocu
       FIELD SumaPeso AS DEC
       FIELD SUmaVolumen AS DEC
       FIELD CuentaItems as INT
       FIELD SumaImporte AS DEC
       FIELD Estado AS CHAR
       FIELD Bultos AS INT.



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

DEF VAR x-CuentaODS AS INT NO-UNDO.
DEF VAR x-CuentaHPK AS INT NO-UNDO.
DEF VAR x-CuentaClientes AS INT NO-UNDO.
DEF VAR x-SumaPeso AS DEC NO-UNDO.
DEF VAR x-SumaVolumen AS DEC NO-UNDO.
DEF VAR x-SumaImporte AS DEC NO-UNDO.
DEF VAR x-CuentaItems AS INT NO-UNDO.
DEF VAR x-Estado AS CHAR NO-UNDO.
DEF VAR x-Bultos AS INT NO-UNDO.
DEF VAR x-Clientes AS CHAR NO-UNDO.
DEF VAR x-FchEnt AS DATE NO-UNDO.

DEF VAR x-FchEnt-1 AS DATE NO-UNDO.
DEF VAR x-FchEnt-2 AS DATE NO-UNDO.

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

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES DI-RutaC
&Scoped-define FIRST-EXTERNAL-TABLE DI-RutaC


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR DI-RutaC.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-VtaCDocu VtaCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table VtaCDocu.NroPed VtaCDocu.CodTer ~
VtaCDocu.CodRef VtaCDocu.NroRef T-VtaCDocu.CuentaItems @ x-CuentaItems ~
T-VtaCDocu.SumaPeso @ x-SumaPeso T-VtaCDocu.SumaVolumen @ x-SumaVolumen ~
T-VtaCDocu.SumaImporte @ x-SumaImporte T-VtaCDocu.Estado @ x-Estado ~
T-VtaCDocu.Bultos @ x-Bultos VtaCDocu.NomCli T-VtaCDocu.FchEnt 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH T-VtaCDocu WHERE T-VtaCDocu.CodCia = DI-RutaC.CodCia ~
  AND T-VtaCDocu.CodOri = DI-RutaC.CodDoc ~
  AND T-VtaCDocu.NroOri = DI-RutaC.NroDoc ~
  AND T-VtaCDocu.CodDiv = DI-RutaC.CodDiv ~
      AND T-VtaCDocu.CodPed = "HPK" NO-LOCK, ~
      FIRST VtaCDocu WHERE VtaCDocu.CodCia = T-VtaCDocu.CodCia ~
  AND VtaCDocu.CodDiv = T-VtaCDocu.CodDiv ~
  AND VtaCDocu.CodPed = T-VtaCDocu.CodPed ~
  AND VtaCDocu.NroPed = T-VtaCDocu.NroPed NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-VtaCDocu WHERE T-VtaCDocu.CodCia = DI-RutaC.CodCia ~
  AND T-VtaCDocu.CodOri = DI-RutaC.CodDoc ~
  AND T-VtaCDocu.NroOri = DI-RutaC.NroDoc ~
  AND T-VtaCDocu.CodDiv = DI-RutaC.CodDiv ~
      AND T-VtaCDocu.CodPed = "HPK" NO-LOCK, ~
      FIRST VtaCDocu WHERE VtaCDocu.CodCia = T-VtaCDocu.CodCia ~
  AND VtaCDocu.CodDiv = T-VtaCDocu.CodDiv ~
  AND VtaCDocu.CodPed = T-VtaCDocu.CodPed ~
  AND VtaCDocu.NroPed = T-VtaCDocu.NroPed NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table T-VtaCDocu VtaCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-VtaCDocu
&Scoped-define SECOND-TABLE-IN-QUERY-br_table VtaCDocu


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroPed AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPicador B-table-Win 
FUNCTION fPicador RETURNS CHARACTER
  ( INPUT pDNI AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-VtaCDocu, 
      VtaCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      VtaCDocu.NroPed COLUMN-LABEL "HPK" FORMAT "X(12)":U WIDTH 12.43
      VtaCDocu.CodTer COLUMN-LABEL "Tipo" FORMAT "x(20)":U
      VtaCDocu.CodRef FORMAT "x(3)":U
      VtaCDocu.NroRef COLUMN-LABEL "Número" FORMAT "X(15)":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      T-VtaCDocu.CuentaItems @ x-CuentaItems COLUMN-LABEL "Items"
      T-VtaCDocu.SumaPeso @ x-SumaPeso COLUMN-LABEL "Peso"
      T-VtaCDocu.SumaVolumen @ x-SumaVolumen COLUMN-LABEL "Volumen"
      T-VtaCDocu.SumaImporte @ x-SumaImporte COLUMN-LABEL "Importe"
      T-VtaCDocu.Estado @ x-Estado COLUMN-LABEL "Estado" FORMAT "x(20)":U
            WIDTH 10
      T-VtaCDocu.Bultos @ x-Bultos COLUMN-LABEL "Bultos" FORMAT ">>,>>9":U
      VtaCDocu.NomCli FORMAT "x(60)":U
      T-VtaCDocu.FchEnt FORMAT "99/99/9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 122 BY 6.69
         FONT 4 FIT-LAST-COLUMN.


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
   External Tables: INTEGRAL.DI-RutaC
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: T-VtaCDocu T "?" NO-UNDO INTEGRAL VtaCDocu
      ADDITIONAL-FIELDS:
          FIELD SumaPeso AS DEC
          FIELD SUmaVolumen AS DEC
          FIELD CuentaItems as INT
          FIELD SumaImporte AS DEC
          FIELD Estado AS CHAR
          FIELD Bultos AS INT
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
         HEIGHT             = 6.85
         WIDTH              = 123.86.
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
     _TblList          = "Temp-Tables.T-VtaCDocu WHERE INTEGRAL.DI-RutaC <external> ...,INTEGRAL.VtaCDocu WHERE Temp-Tables.T-VtaCDocu ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _JoinCode[1]      = "Temp-Tables.T-VtaCDocu.CodCia = INTEGRAL.DI-RutaC.CodCia
  AND Temp-Tables.T-VtaCDocu.CodOri = INTEGRAL.DI-RutaC.CodDoc
  AND Temp-Tables.T-VtaCDocu.NroOri = INTEGRAL.DI-RutaC.NroDoc
  AND Temp-Tables.T-VtaCDocu.CodDiv = INTEGRAL.DI-RutaC.CodDiv"
     _Where[1]         = "Temp-Tables.T-VtaCDocu.CodPed = ""HPK"""
     _JoinCode[2]      = "INTEGRAL.VtaCDocu.CodCia = Temp-Tables.T-VtaCDocu.CodCia
  AND INTEGRAL.VtaCDocu.CodDiv = Temp-Tables.T-VtaCDocu.CodDiv
  AND INTEGRAL.VtaCDocu.CodPed = Temp-Tables.T-VtaCDocu.CodPed
  AND INTEGRAL.VtaCDocu.NroPed = Temp-Tables.T-VtaCDocu.NroPed"
     _FldNameList[1]   > INTEGRAL.VtaCDocu.NroPed
"VtaCDocu.NroPed" "HPK" ? "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.VtaCDocu.CodTer
"VtaCDocu.CodTer" "Tipo" "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.VtaCDocu.CodRef
     _FldNameList[4]   > INTEGRAL.VtaCDocu.NroRef
"VtaCDocu.NroRef" "Número" ? "character" 14 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"T-VtaCDocu.CuentaItems @ x-CuentaItems" "Items" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"T-VtaCDocu.SumaPeso @ x-SumaPeso" "Peso" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"T-VtaCDocu.SumaVolumen @ x-SumaVolumen" "Volumen" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"T-VtaCDocu.SumaImporte @ x-SumaImporte" "Importe" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"T-VtaCDocu.Estado @ x-Estado" "Estado" "x(20)" ? ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"T-VtaCDocu.Bultos @ x-Bultos" "Bultos" ">>,>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   = INTEGRAL.VtaCDocu.NomCli
     _FldNameList[12]   > Temp-Tables.T-VtaCDocu.FchEnt
"T-VtaCDocu.FchEnt" ? "99/99/9999" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "DI-RutaC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "DI-RutaC"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Filtros B-table-Win 
PROCEDURE Carga-Filtros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pFchEnt-1 AS DATE.
DEF INPUT PARAMETER pFchEnt-2 AS DATE.

x-FchEnt-1 = pFchEnt-1.
x-FchEnt-2 = pFchEnt-2.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Reflejo B-table-Win 
PROCEDURE Carga-Reflejo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-Vtacdocu.

SESSION:SET-WAIT-STATE("GENERAL").

DEFINE VAR x-tiempo-transcurrido AS CHAR.

x-tiempo-transcurrido = STRING(TIME,"HH:MM:SS").

FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = DI-RutaC.CodCia
    AND VtaCDocu.CodOri = DI-RutaC.CodDoc
    AND VtaCDocu.NroOri = DI-RutaC.NroDoc
    AND VtaCDocu.CodDiv = DI-RutaC.CodDiv
    AND VtaCDocu.CodPed = "HPK"
    AND VtaCDocu.FlgEst <> "A":    

    CREATE T-Vtacdocu.
    BUFFER-COPY Vtacdocu TO T-Vtacdocu.
    ASSIGN
        x-CuentaODS = 0
        x-CuentaHPK = 0
        x-CuentaClientes = 0
        x-SumaPeso = 0
        x-SumaVolumen = 0
        x-SumaImporte = 0
        x-CuentaItems = 0
        x-Clientes = ''
        x-Bultos = 0
        x-FchEnt = ?.

    x-CuentaClientes = NUM-ENTRIES(x-Clientes).

    x-Estado = fEstado(Vtacdocu.CodPed, Vtacdocu.NroPed).

    FOR EACH VtaDDocu OF VtaCDocu NO-LOCK, FIRST Almmmatg OF VtaDDocu NO-LOCK:
        x-SumaPeso = x-SumaPeso + (Vtaddocu.CanPed * Vtaddocu.Factor * Almmmatg.PesMat).
        x-SumaVolumen = x-SumaVolumen + (Vtaddocu.CanPed * Vtaddocu.Factor * Almmmatg.Libre_d02 / 1000000).
        x-CuentaItems = x-CuentaItems + 1.
        x-SumaImporte = x-SumaImporte + VtaDDocu.ImpLin.
    END.
    FOR EACH Ccbcbult NO-LOCK USE-INDEX llave03 WHERE CcbCBult.CodCia = Vtacdocu.codcia AND
        CcbCBult.CodDoc = Vtacdocu.codref AND
        CcbCBult.NroDoc = Vtacdocu.nroref:
        x-Bultos = x-Bultos + CcbCBult.Bultos.
    END.
    FIND FIRST Faccpedi WHERE Faccpedi.codcia = Vtacdocu.codcia AND
        Faccpedi.coddoc = Vtacdocu.codref AND
        Faccpedi.nroped = Vtacdocu.nroref
        NO-LOCK NO-ERROR.
    IF AVAILABLE Faccpedi THEN x-FchEnt = Faccpedi.FchEnt.

    IF x-FchEnt-1 <> ? AND x-FchEnt < x-FchEnt-1 THEN DO:
        DELETE T-Vtacdocu.
        NEXT.
    END.
    IF x-FchEnt-2 <> ? AND x-FchEnt > x-FchEnt-2 THEN DO:
        DELETE T-Vtacdocu.
        NEXT.
    END.
    ASSIGN
        T-Vtacdocu.SumaPeso = x-SumaPeso
        T-Vtacdocu.SumaVolumen = x-SumaVolumen
        T-Vtacdocu.CuentaItems = x-CuentaItems
        T-Vtacdocu.SumaImporte = x-SumaImporte
        T-Vtacdocu.FchEnt = x-FchEnt
        T-Vtacdocu.Estado = x-Estado
        T-Vtacdocu.Bultos = x-Bultos.
END.

SESSION:SET-WAIT-STATE("").

x-tiempo-transcurrido = x-tiempo-transcurrido + " -- " + STRING(TIME,"HH:MM:SS").

/*MESSAGE x-tiempo-transcurrido.*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime B-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Carga-Temporal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

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
  RUN Carga-Reflejo.

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
  {src/adm/template/snd-list.i "DI-RutaC"}
  {src/adm/template/snd-list.i "T-VtaCDocu"}
  {src/adm/template/snd-list.i "VtaCDocu"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroPed AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR x-Status AS CHAR.
RUN gn/p-status-hpk(pCodDoc, pNroPed, OUTPUT x-Status).
RETURN x-Status.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPicador B-table-Win 
FUNCTION fPicador RETURNS CHARACTER
  ( INPUT pDNI AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pNombre AS CHAR NO-UNDO.
  DEF VAR pOrigen AS CHAR NO-UNDO.

  RUN logis/p-busca-por-dni.p (pDNI, OUTPUT pNombre, OUTPUT pOrigen).
  RETURN pNombre.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

