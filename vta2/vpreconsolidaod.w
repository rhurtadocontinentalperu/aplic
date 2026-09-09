&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE TEMP-TABLE ORDENES NO-UNDO LIKE FacCPedi.



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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddoc AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE lMsgRetorno AS CHAR.

DEF VAR x-nroitm AS INT.

DEFINE SHARED VAR ltxtDesde AS DATE.
DEFINE SHARED VAR ltxtHasta AS DATE.
DEFINE SHARED VAR pOrdenCompra AS CHAR INIT ''.   /* Supermercados Peruanos */
DEFINE SHARED VAR s-busqueda AS CHAR.
DEFINE SHARED VAR i-tipo-busqueda AS INT.

&SCOPED-DEFINE CONDICION faccpedi.codcia = s-codcia ~
AND faccpedi.coddoc = s-coddoc ~
AND faccpedi.divdes = s-coddiv ~
AND (faccpedi.flgest = 'P' AND faccpedi.flgsit = 'T') ~
AND (faccpedi.fchped >= ltxtDesde AND faccpedi.fchped <= ltxtHasta) ~
AND (s-busqueda = '' OR (i-tipo-busqueda = 1 AND faccpedi.nomcli BEGINS s-busqueda) ~
     OR (faccpedi.nomcli MATCHES s-busqueda))


DEF VAR x-Direccion AS CHAR.
DEF VAR x-Comprobante AS CHAR.
DEF VAR x-Ordenes AS CHAR NO-UNDO.
DEF VAR x-peso AS DEC NO-UNDO.

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
&Scoped-define INTERNAL-TABLES ORDENES FacCPedi

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ORDENES.CodDoc ORDENES.NroPed ~
ORDENES.FchPed ORDENES.Hora ORDENES.FchEnt ORDENES.Libre_c01 ORDENES.NomCli ~
ORDENES.UsrImpOD ORDENES.FchImpOD ORDENES.Libre_d01 ORDENES.Libre_c02 ~
ORDENES.Libre_c03 ORDENES.Libre_d02 FacCPedi.Glosa FacCPedi.CodRef ~
FacCPedi.NroRef ORDENES.ordcmp 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH ORDENES WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = ORDENES.CodCia ~
  AND FacCPedi.CodDoc = ORDENES.CodDoc ~
  AND FacCPedi.NroPed = ORDENES.NroPed ~
  AND FacCPedi.CodDiv = ORDENES.CodDiv NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH ORDENES WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = ORDENES.CodCia ~
  AND FacCPedi.CodDoc = ORDENES.CodDoc ~
  AND FacCPedi.NroPed = ORDENES.NroPed ~
  AND FacCPedi.CodDiv = ORDENES.CodDiv NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table ORDENES FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ORDENES
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacCPedi


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-70 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-Log 

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
FchPed|y||INTEGRAL.FacCPedi.FchPed|yes,INTEGRAL.FacCPedi.NomCli|yes
Libre_c01|||ORDENES.Libre_c01|yes,ORDENES.FchPed|yes,ORDENES.Hora|yes
NomCli|||INTEGRAL.FacCPedi.NomCli|yes,INTEGRAL.FacCPedi.FchPed|yes,INTEGRAL.FacCPedi.Hora|yes
FchEnt|||INTEGRAL.FacCPedi.FchEnt|no,INTEGRAL.FacCPedi.NomCli|yes
Libre_d01|||ORDENES.Libre_d01|no
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'FchPed,Libre_c01,NomCli,FchEnt,Libre_d01' + '",
     SortBy-Case = ':U + 'FchPed').

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/* This SmartObject is a valid SortBy-Target. */
&IF '{&user-supported-links}':U ne '':U &THEN
  &Scoped-define user-supported-links {&user-supported-links},SortBy-Target
&ELSE
  &Scoped-define user-supported-links SortBy-Target
&ENDIF

/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fAlmacen B-table-Win 
FUNCTION fAlmacen RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDistribucion B-table-Win 
FUNCTION fDistribucion RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNroItm B-table-Win 
FUNCTION fNroItm RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fOrdenCompra B-table-Win 
FUNCTION fOrdenCompra RETURNS CHARACTER
  ( INPUT pPedido AS CHAR, INPUT pFiltroOrdenCompra AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPersonal B-table-Win 
FUNCTION fPersonal RETURNS CHARACTER
     (INPUT cCodPer AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPeso B-table-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE EDITOR-Log AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 141 BY 6.69
     BGCOLOR 14 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-70
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 143 BY 7.31.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      ORDENES, 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      ORDENES.CodDoc FORMAT "x(3)":U
      ORDENES.NroPed COLUMN-LABEL "Numero" FORMAT "X(9)":U WIDTH 9.57
      ORDENES.FchPed COLUMN-LABEL "Fecha!Emisión" FORMAT "99/99/9999":U
      ORDENES.Hora FORMAT "X(5)":U WIDTH 4.72
      ORDENES.FchEnt COLUMN-LABEL "Fecha!Entrega" FORMAT "99/99/9999":U
      ORDENES.Libre_c01 COLUMN-LABEL "Origen" FORMAT "x(20)":U
      ORDENES.NomCli FORMAT "x(50)":U
      ORDENES.UsrImpOD COLUMN-LABEL "Impreso por" FORMAT "x(8)":U
      ORDENES.FchImpOD COLUMN-LABEL "Fecha y!hora de impresión" FORMAT "99/99/9999 HH:MM":U
      ORDENES.Libre_d01 COLUMN-LABEL "Peso KG" FORMAT ">>>,>>9.99":U
      ORDENES.Libre_c02 COLUMN-LABEL "ALMACEN" FORMAT "x(20)":U
            WIDTH 16.72
      ORDENES.Libre_c03 COLUMN-LABEL "DISTRIBUCION" FORMAT "x(20)":U
            WIDTH 14.72
      ORDENES.Libre_d02 COLUMN-LABEL "Items" FORMAT ">>9":U
      FacCPedi.Glosa FORMAT "X(50)":U
      FacCPedi.CodRef FORMAT "x(3)":U
      FacCPedi.NroRef FORMAT "X(12)":U
      ORDENES.ordcmp FORMAT "X(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 144 BY 15.77
         FONT 4
         TITLE "SELECCIONE LAS ORDENES QUE DESEE CONSOLIDAR" ROW-HEIGHT-CHARS .5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     EDITOR-Log AT ROW 17.54 COL 3 NO-LABEL WIDGET-ID 2
     "ORDENES SELECCIONADAS" VIEW-AS TEXT
          SIZE 28 BY .62 AT ROW 16.96 COL 3 WIDGET-ID 4
          BGCOLOR 9 FGCOLOR 15 
     RECT-70 AT ROW 17.15 COL 2 WIDGET-ID 18
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
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: ORDENES T "?" NO-UNDO INTEGRAL FacCPedi
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
         HEIGHT             = 23.96
         WIDTH              = 145.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
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
/* BROWSE-TAB br_table TEXT-1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2
       br_table:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* SETTINGS FOR EDITOR EDITOR-Log IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.ORDENES,INTEGRAL.FacCPedi WHERE Temp-Tables.ORDENES ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _JoinCode[2]      = "INTEGRAL.FacCPedi.CodCia = Temp-Tables.ORDENES.CodCia
  AND INTEGRAL.FacCPedi.CodDoc = Temp-Tables.ORDENES.CodDoc
  AND INTEGRAL.FacCPedi.NroPed = Temp-Tables.ORDENES.NroPed
  AND INTEGRAL.FacCPedi.CodDiv = Temp-Tables.ORDENES.CodDiv"
     _FldNameList[1]   = Temp-Tables.ORDENES.CodDoc
     _FldNameList[2]   > Temp-Tables.ORDENES.NroPed
"ORDENES.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ORDENES.FchPed
"ORDENES.FchPed" "Fecha!Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ORDENES.Hora
"ORDENES.Hora" ? ? "character" ? ? ? ? ? ? no ? no no "4.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ORDENES.FchEnt
"ORDENES.FchEnt" "Fecha!Entrega" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ORDENES.Libre_c01
"ORDENES.Libre_c01" "Origen" "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = Temp-Tables.ORDENES.NomCli
     _FldNameList[8]   > Temp-Tables.ORDENES.UsrImpOD
"ORDENES.UsrImpOD" "Impreso por" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.ORDENES.FchImpOD
"ORDENES.FchImpOD" "Fecha y!hora de impresión" "99/99/9999 HH:MM" "datetime" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.ORDENES.Libre_d01
"ORDENES.Libre_d01" "Peso KG" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.ORDENES.Libre_c02
"ORDENES.Libre_c02" "ALMACEN" "x(20)" "character" ? ? ? ? ? ? no ? no no "16.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.ORDENES.Libre_c03
"ORDENES.Libre_c03" "DISTRIBUCION" "x(20)" "character" ? ? ? ? ? ? no ? no no "14.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.ORDENES.Libre_d02
"ORDENES.Libre_d02" "Items" ">>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   = INTEGRAL.FacCPedi.Glosa
     _FldNameList[15]   = INTEGRAL.FacCPedi.CodRef
     _FldNameList[16]   > INTEGRAL.FacCPedi.NroRef
"FacCPedi.NroRef" ? "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   = Temp-Tables.ORDENES.ordcmp
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* SELECCIONE LAS ORDENES QUE DESEE CONSOLIDAR */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* SELECCIONE LAS ORDENES QUE DESEE CONSOLIDAR */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON START-SEARCH OF br_table IN FRAME F-Main /* SELECCIONE LAS ORDENES QUE DESEE CONSOLIDAR */
DO:
    DEFINE VARIABLE hSortColumn  AS WIDGET-HANDLE.
    DEFINE VARIABLE hQueryHandle AS HANDLE     NO-UNDO.

    hSortColumn = BROWSE {&BROWSE-NAME}:CURRENT-COLUMN.
    CASE hSortColumn:NAME:
        WHEN "FchPed" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'FchPed').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "Libre_c01" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'Libre_c01').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "NomCli" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'NomCli').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "FchEnt" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'FchEnt').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "Libre_d01" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'Libre_d01').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* SELECCIONE LAS ORDENES QUE DESEE CONSOLIDAR */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */

   RUN Carga-Log.
  DEFINE VAR lxpeso AS DEC.
  lMsgretorno = ''.

  lxPeso = fpeso().
  
  IF {&browse-name}:NUM-SELECTED-ROWS > 1 THEN DO:
      RUN Procesa-Handle IN lh_handle ('Disable-Buttons').
  END.
  ELSE RUN Procesa-Handle IN lh_handle ('Enable-Buttons').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

  RUN get-attribute ('SortBy-Case':U).
  CASE RETURN-VALUE:
    WHEN 'FchPed':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.FchPed BY FacCPedi.NomCli
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Libre_c01':U THEN DO:
      &Scope SORTBY-PHRASE BY ORDENES.Libre_c01 BY ORDENES.FchPed BY ORDENES.Hora
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'NomCli':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.NomCli BY FacCPedi.FchPed BY FacCPedi.Hora
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'FchEnt':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.FchEnt DESCENDING BY FacCPedi.NomCli
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Libre_d01':U THEN DO:
      &Scope SORTBY-PHRASE BY ORDENES.Libre_d01 DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    OTHERWISE DO:
      &Undefine SORTBY-PHRASE
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* OTHERWISE...*/
  END CASE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Log B-table-Win 
PROCEDURE Carga-Log :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k AS INT NO-UNDO.

EDITOR-Log = "".
DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) IN FRAME {&FRAME-NAME} THEN
    EDITOR-Log = EDITOR-Log + (IF TRUE <> (EDITOR-Log > "") THEN '' ELSE CHR(10)) +
        "DOCUMENTO: " +  STRING(ORDENES.CodDoc, 'x(3)') + FILL(' ' ,1) + ORDENES.NroPed + FILL(' ',10) +
        " FECHA: " + STRING(ORDENES.FchPed, '99/99/9999') + FILL(' ',10) +
        " CLIENTE: " + ORDENES.NomCli.
END.
DISPLAY EDITOR-Log WITH FRAME  {&FRAME-NAME}.

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

EMPTY TEMP-TABLE ORDENES.

DEFINE VAR lOrdenCompra AS CHAR INIT ''.
SESSION:SET-WAIT-STATE('GENERAL').
FOR EACH FacCPedi WHERE {&Condicion} USE-INDEX Llave09 NO-LOCK,
    FIRST GN-DIVI OF FacCPedi NO-LOCK:

    lOrdenCompra = "*".
    IF pOrdenCompra <> '' THEN DO:
        lOrdenCompra = fOrdenCompra(INPUT FacCPedi.NroRef, INPUT pOrdenCompra).
    END.

    IF lOrdenCompra <> '' THEN DO:
        CREATE ORDENES.
        BUFFER-COPY Faccpedi TO ORDENES
        ASSIGN
            ORDENES.Libre_c01 = gn-divi.desdiv
            ORDENES.Libre_d01 = fPeso()
            ORDENES.Libre_c02 = fAlmacen()
            ORDENES.Libre_d02 = fNroItm()
            ORDENES.Libre_c03 = fDistribucion()
            ORDENES.UsrImpOD = ENTRY(1, Faccpedi.Libre_c02, '|')
            ORDENES.FchImpOD = (IF NUM-ENTRIES(Faccpedi.Libre_c02, '|') > 1 THEN DATETIME(ENTRY(2, Faccpedi.Libre_c02, '|'))
                ELSE ?)
            /*ORDENES.OrdCmp = IF (lOrdenCompra = '*') THEN '' ELSE lOrdenCompra*/.

        CASE Faccpedi.coddoc:
            WHEN 'O/D' OR WHEN 'O/M' THEN DO:
                ORDENES.Libre_c01 = gn-divi.desdiv.
                ORDENES.NomCli:COLUMN-LABEL IN BROWSE {&browse-name} = "Cliente".
            END.
            WHEN 'OTR' THEN DO:
                ORDENES.Libre_c01 = Faccpedi.codcli.
                ORDENES.NomCli:COLUMN-LABEL IN BROWSE {&browse-name} = "Solicitante".
            END.
        END CASE.
    END.
END.
/* Limpiamos control */
DO WITH FRAME {&FRAME-NAME}:
     EDITOR-Log = ''.
     DISPLAY EDITOR-Log.
END.
SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Consolidar B-table-Win 
PROCEDURE Consolidar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR s-CodDoc AS CHAR INIT 'ODC' NO-UNDO.    /* Orden de Despacho Consolidada */
DEF VAR x-Rowid  AS ROWID NO-UNDO.
DEF VAR k AS INT NO-UNDO.
DEF VAR x-NroItm AS INT NO-UNDO.


/* Al menos debe haber selecionado mas de un registro */
IF {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} < 2 THEN DO:
    MESSAGE 'Debe seleccionar al menos 2 registros' 
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
/* Chequeo de correlativos */
FIND FIRST Faccorre WHERE FacCorre.CodCia = s-codcia
    AND FacCorre.CodDiv = s-coddiv
    AND FacCorre.CodDoc = s-coddoc
    AND FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccorre THEN DO:
    MESSAGE 'NO está definido el correlativo para el documento:' s-coddoc
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
x-Rowid = ROWID(FacCorre).

MESSAGE 'Se va a proceder a consolidar las O/D seleccionadas' SKIP
    'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.

CICLO:
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR WITH FRAME {&FRAME-NAME}:
    /* Creamos el consolidado */
    {lib/lock-genericov2.i &Tabla="FacCorre" ~
        &Condicion="ROWID(FacCorre) = x-Rowid" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="RETURN" ~
        }
    CREATE B-CPEDI.
    ASSIGN
        B-CPEDI.CodCia = s-codcia
        B-CPEDI.CodDiv = s-coddiv
        B-CPEDI.CodDoc = s-coddoc
        B-CPEDI.NroPed = STRING(FacCorre.nroser,'999') + STRING(FacCorre.correlativo, '999999')
        B-CPEDI.CodCli = '11111111111'
        B-CPEDI.NomCli = 'O/D CONSOLIDADA'
        B-CPEDI.FchPed = TODAY
        B-CPEDI.fchven = TODAY
        B-CPEDI.CodAlm = s-codalm
        B-CPEDI.CodRef = 'O/D'
        B-CPEDI.DivDes = s-coddiv
        B-CPEDI.FlgEst = 'P'
        B-CPEDI.FlgSit = 'T'    /* Por PrePickear */
        B-CPEDI.Glosa  = 'O/D CONSOLIDADA'
        B-CPEDI.usuario = s-user-id.
    ASSIGN
        FacCorre.correlativo = FacCorre.correlativo + 1.
    /* Detalle */
    x-NroItm = 0.
    DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN DO:
            IF NOT (faccpedi.flgest = 'P' AND faccpedi.flgsit = 'T')
                THEN DO:
                MESSAGE 'Documento ya NO se puede consolidar:' Faccpedi.coddoc Faccpedi.nroped SKIP
                    'Proceso ABORTADO'
                    VIEW-AS ALERT-BOX WARNING.
                UNDO CICLO, RETURN ERROR.
            END.
            /* Bloqueamos la O/D */
            FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Faccpedi THEN UNDO CICLO, RETURN ERROR.
            ASSIGN 
                Faccpedi.flgsit = 'X'.   /* CONSOLIDADA */
            ASSIGN
                B-CPEDI.NroRef = B-CPEDI.NroRef + 
                    (IF TRUE <> (B-CPEDI.NroRef > '') THEN '' ELSE ',') +
                    Faccpedi.NroPed.
            /* Acumulamos */
            FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
                FIND B-DPEDI OF B-CPEDI WHERE B-DPEDI.codmat = Facdpedi.codmat NO-ERROR.
                IF NOT AVAILABLE B-DPEDI THEN DO:
                    CREATE B-DPEDI.
                    x-NroItm = x-NroItm + 1.
                END.
                BUFFER-COPY B-CPEDI TO B-DPEDI
                    ASSIGN
                    B-DPEDI.NroItm = x-NroItm
                    B-DPEDI.codmat = Facdpedi.codmat
                    B-DPEDI.Factor = 1
                    B-DPEDI.CanPed = B-DPEDI.CanPed + (Facdpedi.canped * Facdpedi.factor)
                    B-DPEDI.UndVta = Almmmatg.undbas.
            END.
        END.
    END.
END.
IF AVAILABLE Faccpedi THEN RELEASE Faccpedi.
IF AVAILABLE B-CPEDI  THEN RELEASE B-CPEDI.
IF AVAILABLE B-DPEDI  THEN RELEASE B-DPEDI.

RUN Carga-Temporal.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  /*RUN Carga-Temporal.*/

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
  {src/adm/template/snd-list.i "ORDENES"}
  {src/adm/template/snd-list.i "FacCPedi"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fAlmacen B-table-Win 
FUNCTION fAlmacen RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF NUM-ENTRIES(Faccpedi.Libre_c02,'|') > 1 
      THEN RETURN ENTRY(2,Faccpedi.Libre_c02,'|').
  ELSE RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDistribucion B-table-Win 
FUNCTION fDistribucion RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1 
      THEN RETURN ENTRY(2,Faccpedi.Libre_c03,'|').
  ELSE RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNroItm B-table-Win 
FUNCTION fNroItm RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR i AS INT.
FOR EACH facdpedi OF faccpedi NO-LOCK:
    i = i + 1.
END.
RETURN i.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fOrdenCompra B-table-Win 
FUNCTION fOrdenCompra RETURNS CHARACTER
  ( INPUT pPedido AS CHAR, INPUT pFiltroOrdenCompra AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR lOrdenCompra AS CHAR INIT ''.
DEFINE VAR lCotizacion AS CHAR INIT ''.

DEFINE BUFFER b-faccpedi FOR faccpedi.
DEFINE BUFFER c-faccpedi FOR faccpedi.

/* Busco el PED */
FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND 
                            b-faccpedi.coddoc = 'PED' AND
                            b-faccpedi.nroped = pPedido NO-LOCK NO-ERROR.
IF AVAILABLE b-faccpedi THEN DO:
    lCotizacion = b-faccpedi.nroref.
    /* Busco la COT */
    FIND FIRST c-faccpedi WHERE c-faccpedi.codcia = s-codcia AND 
                                c-faccpedi.coddoc = 'COT' AND
                                c-faccpedi.nroped = lCotizacion NO-LOCK NO-ERROR.
    IF AVAILABLE c-faccpedi THEN DO:
        IF (c-faccpedi.ordcmp BEGINS pFiltroOrdenCompra) THEN DO:
            lOrdenCompra = TRIM(c-faccpedi.ordcmp).
        END.
    END.
END.

RELEASE b-faccpedi.
RELEASE c-faccpedi.

RETURN lOrdenCompra.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPersonal B-table-Win 
FUNCTION fPersonal RETURNS CHARACTER
     (INPUT cCodPer AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR lPersonal AS CHAR.

    lPersonal = "".
    FIND FIRST pl-pers WHERE pl-pers.codper = cCodPer NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN DO:
        lPersonal = pl-pers.patper + ' ' + pl-pers.matper + ' ' + pl-pers.nomper.
    END.

  RETURN lPersonal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPeso B-table-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR lPeso AS DEC.

    DEFINE BUFFER b-facdpedi FOR facdpedi.

    lPeso = 0.
    lMsgRetorno = ''.

    FOR EACH b-facdpedi OF faccpedi NO-LOCK,
        FIRST almmmatg OF b-facdpedi NO-LOCK :
        IF almmmatg.pesmat <> ? AND almmmatg.pesmat > 0 THEN DO:
            lPeso = lPeso + (b-facdpedi.canped * almmmatg.pesmat).
        END.       
        ELSE DO:
            IF lMsgRetorno = '' THEN DO:
                lMsgRetorno = almmmatg.codmat.
            END.
            ELSE DO:
                lMsgRetorno = lMsgRetorno + ", " + almmmatg.codmat.
            END.
        END.
    END.
    RELEASE b-facdpedi.


  RETURN lPeso.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

