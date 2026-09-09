&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ORDENES NO-UNDO LIKE FacCPedi
       field cZona as char
       field xZona as char
       field csubzona as char
       field xsubzona as char
       field cdistrito as char.



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
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-nro-orden AS CHAR.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE lMsgRetorno AS CHAR.

/*DEF VAR s-coddoc AS CHAR INIT 'O/D,O/M'.*/
DEF SHARED VAR s-coddoc AS CHAR.
DEF VAR x-nroitm AS INT.

DEF VAR x-DestinoFinal AS CHAR NO-UNDO.

DEFINE SHARED VAR ltxtDesde AS DATE.
DEFINE SHARED VAR ltxtHasta AS DATE.
/*
DEFINE SHARED VAR lChequeados AS LOGICAL.
DEFINE SHARED VAR pSoloImpresos AS LOGICAL.
*/
DEFINE SHARED VAR x-pendientes-impresion AS INT.
DEFINE SHARED VAR x-pickeado AS INT.
DEFINE SHARED VAR pOrdenCompra AS CHAR.
DEFINE SHARED VAR i-tipo-busqueda AS INT.
DEFINE SHARED VAR i-dias AS INT.

DEFINE VAR s-task-no AS INT.

/*
&SCOPED-DEFINE CONDICION faccpedi.codcia = s-codcia ~
AND (s-CodDoc = "Todos" OR faccpedi.coddoc = s-coddoc) ~
AND LOOKUP(Faccpedi.CodDoc, 'O/D,O/M,OTR') > 0 ~
AND faccpedi.divdes = s-coddiv ~
AND faccpedi.flgest <> 'A' ~
AND (faccpedi.fchped >= ltxtDesde AND faccpedi.fchped <= ltxtHasta) ~
AND (s-nro-orden = "" OR faccpedi.nroped = s-nro-orden)
*/

DEFINE VAR z-cliente AS CHAR INIT ''.
DEFINE VAR z-canal AS CHAR INIT 'Todos'.

&SCOPED-DEFINE CONDICION2 (ordenes.codcia = s-codcia ~
AND (z-canal = 'Todos' OR ordenes.coddiv = z-canal) ~
AND (z-cliente = "" OR ordenes.nomcli MATCHES z-cliente))

DEFINE TEMP-TABLE Reporte
    FIELD CodDoc    LIKE FacCPedi.CodDoc
    FIELDS NroPed   LIKE FacCPedi.NroPed
    FIELD  CodRef    LIKE FacCPedi.CodRef
    FIELDS NroRef   LIKE FacCPedi.NroRef
    FIELDS CodAlm   LIKE Facdpedi.almdes
    FIELDS CodMat   LIKE FacDPedi.CodMat
    FIELDS DesMat   LIKE Almmmatg.DesMat
    FIELDS DesMar   LIKE Almmmatg.DesMar
    FIELDS UndBas   LIKE Almmmatg.UndBas
    FIELDS CanPed   LIKE FacDPedi.CanPed
    FIELDS CodUbi   LIKE Almmmate.CodUbi
    FIELDS CodZona  LIKE Almtubic.CodZona
    FIELDS X-TRANS  LIKE FacCPedi.Libre_c01
    FIELDS X-DIREC  LIKE FACCPEDI.Libre_c02
    FIELDS X-LUGAR  LIKE FACCPEDI.Libre_c03
    FIELDS X-CONTC  LIKE FACCPEDI.Libre_c04
    FIELDS X-HORA   LIKE FACCPEDI.Libre_c05
    FIELDS X-FECHA  LIKE FACCPEDI.Libre_f01
    FIELDS X-OBSER  LIKE FACCPEDI.Observa
    FIELDS X-Glosa  LIKE FACCPEDI.Glosa
    FIELDS X-codcli LIKE FACCPEDI.CodCli
    FIELDS X-NomCli LIKE FACCPEDI.NomCli
    FIELDS X-fchent LIKE faccpedi.fchent
    FIELDS X-peso   AS DEC INIT 0
    FIELDS x-empaques AS CHAR FORMAT 'x(25)'
    FIELDS x-corrrsector AS INT INIT 0
    FIELD EmpaqEspec LIKE FacCPedi.EmpaqEspec 
    .

/* Guardo las sub-ordenes para la actualizacion */
DEFINE TEMP-TABLE tt-subordenes
    FIELD CodDoc    LIKE FacCPedi.CodDoc
    FIELDS NroPed   LIKE FacCPedi.NroPed.

/*   */
DEFINE TEMP-TABLE Resumen
    FIELD CodMat LIKE Facdpedi.codmat
    FIELD DesMat LIKE Almmmatg.desmat
    FIELD DesMar LIKE Almmmatg.desmar
    FIELD UndBas LIKE Almmmatg.undbas
    FIELD NroPed AS CHAR EXTENT 100
    FIELD CanPed AS DEC  EXTENT 100
    INDEX Idx00 AS PRIMARY CodMat.

DEFINE TEMP-TABLE Resumen2
    FIELDS X-codcli LIKE FACCPEDI.CodCli
    FIELDS X-NomCli LIKE FACCPEDI.NomCli
    FIELD CodDoc    LIKE FacCPedi.CodDoc
    FIELDS NroPed   LIKE FacCPedi.NroPed
    FIELDS X-FECHA  LIKE FACCPEDI.Libre_f01
    FIELDS X-fchent LIKE faccpedi.fchent
    FIELDS x-qtyitm AS INT INIT 0
    FIELDS x-peso   AS DEC INIT 0

    INDEX Idx00 AS PRIMARY x-codcli coddoc Nroped.


DEF VAR x-Direccion AS CHAR.
DEF VAR x-Comprobante AS CHAR.
DEF VAR x-Ordenes AS CHAR NO-UNDO.
DEF VAR x-peso AS DEC NO-UNDO.

define stream REPORTE.

/* Def REPORTE */
DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "aplic/alm/rbalm.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Hoja Ruta2".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

/* capturamos ruta inicial */
DEF VAR S-REPORT-LIBRARY AS CHAR.
GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE s-report-library.
RB-REPORT-LIBRARY = s-report-library + "alm\rbalm.prl".

/* ---- */

DEFINE VAR x-canal AS CHAR.
DEFINE VAR x-zona AS CHAR.
DEFINE VAR x-subzona AS CHAR.
DEFINE VAR x-distrito AS CHAR.

/* SORT */
define var x-sort-direccion as char init "".
define var x-sort-column as char init "".
define var x-sort-command as char init "".

DEFINE VAR x-sort-acumulativo AS LOG INIT NO.
DEFINE VAR x-sort-color-reset AS LOG INIT YES.
DEFINE VAR x-desde AS DATE.
DEFINE VAR x-hasta AS DATE.

&SCOPED-DEFINE CONDICION faccpedi.codcia = s-codcia ~
AND (s-CodDoc = "Todos" OR faccpedi.coddoc = s-coddoc) ~
AND LOOKUP(Faccpedi.CodDoc, 'O/D,O/M,OTR') > 0 ~
AND faccpedi.divdes = s-coddiv ~
AND faccpedi.flgest <> 'A' ~
AND (faccpedi.fchped >= x-desde AND faccpedi.fchped <= x-hasta) ~
AND (s-nro-orden = "" OR faccpedi.nroped = s-nro-orden)

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
&Scoped-define FIELDS-IN-QUERY-br_table FacCPedi.CrossDocking ~
ORDENES.Libre_c01 ordenes.cdistrito @ x-distrito ORDENES.CodDoc ~
ORDENES.NroPed ORDENES.FchPed ORDENES.Hora ORDENES.NomCli ORDENES.FchEnt ~
fDestinoFinal() @ x-DestinoFinal ORDENES.AcuBon[1] FacCPedi.UsrImpOD ~
FacCPedi.FchImpOD FacCPedi.Glosa 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH ORDENES WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION2} NO-LOCK, ~
      FIRST FacCPedi OF ORDENES NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH ORDENES WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION2} NO-LOCK, ~
      FIRST FacCPedi OF ORDENES NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table ORDENES FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ORDENES
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacCPedi


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
FchPed|y||INTEGRAL.FacCPedi.FchPed|no,INTEGRAL.FacCPedi.Hora|no
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDestinoFinal B-table-Win 
FUNCTION fDestinoFinal RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDistribucion B-table-Win 
FUNCTION fDistribucion RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fgen-empaques B-table-Win 
FUNCTION fgen-empaques RETURNS CHARACTER
  ( INPUT pCantidad AS dec )  FORWARD.

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
      FacCPedi.CrossDocking COLUMN-LABEL "CrossDock" FORMAT "SI/NO":U
            WIDTH 8.43
      ORDENES.Libre_c01 COLUMN-LABEL "Canal" FORMAT "x(30)":U WIDTH 11.43
      ordenes.cdistrito @ x-distrito COLUMN-LABEL "Distrito" FORMAT "x(40)":U
            WIDTH 23.43 COLUMN-FONT 0
      ORDENES.CodDoc FORMAT "x(3)":U WIDTH 5.43
      ORDENES.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U WIDTH 8.43
      ORDENES.FchPed COLUMN-LABEL "Emisión" FORMAT "99/99/9999":U
      ORDENES.Hora FORMAT "X(5)":U WIDTH 4.72
      ORDENES.NomCli COLUMN-LABEL "Cliente" FORMAT "x(100)":U WIDTH 35.57
      ORDENES.FchEnt FORMAT "99/99/9999":U
      fDestinoFinal() @ x-DestinoFinal COLUMN-LABEL "Destino Final" FORMAT "x(40)":U
      ORDENES.AcuBon[1] COLUMN-LABEL "Sectores" FORMAT "99":U WIDTH 6
      FacCPedi.UsrImpOD COLUMN-LABEL "Impreso por" FORMAT "x(8)":U
            WIDTH 8.14
      FacCPedi.FchImpOD COLUMN-LABEL "Fecha y!hora de impresión" FORMAT "99/99/9999 HH:MM":U
            WIDTH 13.43
      FacCPedi.Glosa FORMAT "X(50)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 153 BY 9.15
         FONT 4 ROW-HEIGHT-CHARS .5.


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
      TABLE: ORDENES T "?" NO-UNDO INTEGRAL FacCPedi
      ADDITIONAL-FIELDS:
          field cZona as char
          field xZona as char
          field csubzona as char
          field xsubzona as char
          field cdistrito as char
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
         HEIGHT             = 11.38
         WIDTH              = 153.72.
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
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2
       br_table:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.ORDENES,INTEGRAL.FacCPedi OF Temp-Tables.ORDENES"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST,,,"
     _Where[1]         = "{&CONDICION2}"
     _FldNameList[1]   > INTEGRAL.FacCPedi.CrossDocking
"FacCPedi.CrossDocking" "CrossDock" "SI/NO" "logical" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.ORDENES.Libre_c01
"ORDENES.Libre_c01" "Canal" "x(30)" "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"ordenes.cdistrito @ x-distrito" "Distrito" "x(40)" ? ? ? 0 ? ? ? no ? no no "23.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ORDENES.CodDoc
"ORDENES.CodDoc" ? ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ORDENES.NroPed
"ORDENES.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ORDENES.FchPed
"ORDENES.FchPed" "Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ORDENES.Hora
"ORDENES.Hora" ? ? "character" ? ? ? ? ? ? no ? no no "4.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ORDENES.NomCli
"ORDENES.NomCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "35.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   = Temp-Tables.ORDENES.FchEnt
     _FldNameList[10]   > "_<CALC>"
"fDestinoFinal() @ x-DestinoFinal" "Destino Final" "x(40)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.ORDENES.AcuBon[1]
"ORDENES.AcuBon[1]" "Sectores" "99" "decimal" ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.FacCPedi.UsrImpOD
"FacCPedi.UsrImpOD" "Impreso por" ? "character" ? ? ? ? ? ? no ? no no "8.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > INTEGRAL.FacCPedi.FchImpOD
"FacCPedi.FchImpOD" "Fecha y!hora de impresión" "99/99/9999 HH:MM" "datetime" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   = INTEGRAL.FacCPedi.Glosa
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
ON START-SEARCH OF br_table IN FRAME F-Main
DO:
    /*
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
    */

    DEFINE VARIABLE hSortColumn AS WIDGET-HANDLE.
    DEFINE VAR lColumName AS CHAR.
    DEFINE VAR hQueryHandle AS HANDLE NO-UNDO.

    DEFINE VAR n_cols_browse AS INT NO-UNDO.
    DEFINE VAR n_celda AS WIDGET-HANDLE NO-UNDO.

    hSortColumn = BROWSE br_table:CURRENT-COLUMN.
    lColumName = hSortColumn:NAME.
    lColumName = TRIM(REPLACE(lColumName," no","")).

    IF lColumName = 'acubon' THEN DO:
        MESSAGE "Columna imposible de Ordenar".
        RETURN NO-APPLY.
    END.

    IF lColumName = 'x-subzona' THEN lColumName = 'csubzona'.
    IF lColumName = 'x-zona' THEN lColumName = 'czona'.

    x-sort-command = "BY " + lColumName.

    IF x-sort-acumulativo = NO THEN DO:
        IF CAPS(x-sort-command) = CAPS(x-sort-column) THEN DO:
            x-sort-command = "BY " + lColumName + " DESC".
        END.
        ELSE DO:
            x-sort-command = "BY " + lColumName + " DESC".
            IF CAPS(x-sort-command) = CAPS(x-sort-column) THEN DO:
                x-sort-command = "BY " + lColumName.
            END.
            ELSE x-sort-command = "BY " + lColumName.
        END.
        x-sort-column = x-sort-command.

        x-sort-color-reset = YES.
    END.
    ELSE DO:
        x-sort-command = "BY " + lColumName + " DESC".

        IF INDEX(x-sort-column,x-sort-command) > 0 THEN DO:
            x-sort-column = REPLACE(x-sort-column,x-sort-command,"BY " + lColumName).
        END.
        ELSE DO:
            x-sort-command = "BY " + lColumName.
            IF INDEX(x-sort-column,x-sort-command) > 0 THEN DO:
                x-sort-column = REPLACE(x-sort-column,x-sort-command,"BY " + lColumName + " DESC").
            END.
            ELSE DO:
                x-sort-column = x-sort-column + " " + x-sort-command.
            END.
        END.
        x-sort-command = x-sort-column.
    END.
    
    hQueryHandle = BROWSE br_table:QUERY.
    hQueryHandle:QUERY-CLOSE().
    /* *--- Este valor debe ser el QUERY que esta definido en el BROWSE. */   
    hQueryHandle:QUERY-PREPARE("FOR EACH ORDENES WHERE " + "{& " + "CONDICION" + "} NO-LOCK, FIRST INTEGRAL.FacCPedi OF ORDENES NO-LOCK " + x-sort-command).
    hQueryHandle:QUERY-OPEN().

    /* Color SortCol */
    IF x-sort-color-reset = YES THEN DO:
        /* Color normal */
        DO n_cols_browse = 1 TO br_table:NUM-COLUMNS.
            n_celda = br_table:GET-BROWSE-COLUMN(n_cols_browse).
            n_celda:COLUMN-BGCOLOR = 15.
        END.        

        x-sort-color-reset = NO.
    END.
    hSortColumn:COLUMN-BGCOLOR = 11.   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */

    IF NOT AVAILABLE ordenes THEN RETURN NO-APPLY.
       
    /*RUN ue-guia-hruta IN lh_Handle(INPUT ordenes.coddoc , INPUT ordenes.nroped ).*/

    /* SubOrdenes */
    RUN ue-muestra-subordenes IN lh_Handle(INPUT ordenes.coddoc , INPUT ordenes.nroped ).

    /* --------------------------------------- */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE A-Distribucion B-table-Win 
PROCEDURE A-Distribucion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF Faccpedi.Libre_c02 = '' OR Faccpedi.Libre_c03 <> '' THEN RETURN.
  /* Ic - 20Mar2015 - Felix Perez debe pedir codigo del trabajador
  MESSAGE 'Enviamos la Orden de Despacho a Distribución?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN.
  */

  DEF VAR x-UsrChq LIKE Faccpedi.usrchq NO-UNDO.
  RUN vtamay/d-chqped (OUTPUT x-UsrChq).
  IF x-UsrChq = '' THEN RETURN 'ADM-ERROR'.

  FIND CURRENT FacCPedi EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccpedi THEN DO:
      MESSAGE 'No se pudo bloquear la Orden' VIEW-AS ALERT-BOX ERROR.
      RETURN.
  END.
  ASSIGN
      FacCPedi.Libre_c03 = s-user-id + '|' + STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS') + '|' + x-UsrChq
      FacCpedi.ubigeo[4] = x-UsrChq.

  FIND CURRENT Faccpedi NO-LOCK NO-ERROR.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
      &Scope SORTBY-PHRASE BY FacCPedi.FchPed DESCENDING BY FacCPedi.Hora DESCENDING
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE capturar-sectores B-table-Win 
PROCEDURE capturar-sectores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroped AS CHAR.
DEFINE OUTPUT PARAMETER pSectoresImprimir AS CHAR.
DEFINE OUTPUT PARAMETER pTodosLosSectores AS CHAR.

DEFINE VAR lSectores AS CHAR.
DEFINE VAR nSectores AS INT INIT 0.

SESSION:SET-WAIT-STATE('GENERAL').

lSectores = "".
FOR EACH VtaCDocu WHERE VtaCDocu.codcia = s-codcia AND 
                        VtaCDocu.CodPed = pCodDoc AND
                        ENTRY(1,VtaCDocu.nroped,"-") = pNroPed
                        NO-LOCK:
    lSectores = lSectores + IF(lSectores <> "") THEN "," ELSE "".
    lSectores = lSectores + ENTRY(2,VtaCDocu.nroped,"-").
    nSectores = nSectores + 1.
END.

pSectoresImprimir = lSectores.
pTodosLosSectores = lSectores.

SESSION:SET-WAIT-STATE('').


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
DEFINE VAR lUserImpresion AS CHAR.

DEFINE VAR lSectores AS INT.
DEFINE VAR lSecImp AS INT.
DEFINE VAR lSecAsig AS INT.
DEFINE VAR lSecDev AS INT.
DEFINE VAR lSecxAsig AS INT.

DEFINE VAR pCodDpto AS CHAR.
DEFINE VAR pCodProv AS CHAR.
DEFINE VAR pCodDist AS CHAR.
DEFINE VAR pCodPos AS CHAR.
DEFINE VAR pZona AS CHAR.
DEFINE VAR pSubZona AS CHAR.

DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR y-coddoc AS CHAR.
DEFINE VAR x-sec AS INT.

x-coddoc = s-CodDoc.
IF s-CodDoc = "Todos" THEN x-coddoc = 'O/D,O/M,OTR'.

DEFINE VAR x-desde AS DATE.
DEFINE VAR x-hasta AS DATE.

SESSION:SET-WAIT-STATE('GENERAL').
/*
&SCOPED-DEFINE CONDICION faccpedi.codcia = s-codcia ~
AND (s-CodDoc = "Todos" OR faccpedi.coddoc = s-coddoc) ~
AND LOOKUP(Faccpedi.CodDoc, 'O/D,O/M,OTR') > 0 ~
AND faccpedi.divdes = s-coddiv ~
AND faccpedi.flgest <> 'A' ~
AND (faccpedi.fchped >= ltxtDesde AND faccpedi.fchped <= ltxtHasta) ~
AND (s-nro-orden = "" OR faccpedi.nroped = s-nro-orden)
*/

/*REPEAT x-sec = 1 TO NUM-ENTRIES(x-coddoc,","):*/
    /*
    FOR EACH FacCPedi WHERE {&Condicion} USE-INDEX Llave09 NO-LOCK,
    */
    /*
    y-coddoc = ENTRY(x-sec,x-coddoc,",").    
    x-hasta = TODAY.
    x-desde = x-hasta - 15.
    

    FOR EACH faccpedi USE-INDEX Llave08 WHERE faccpedi.codcia = s-codcia AND 
                            faccpedi.divdes = s-coddiv AND
                            faccpedi.coddoc = y-coddoc AND 
                            faccpedi.flgest <> 'A' AND
                            (faccpedi.fchped >= x-desde AND faccpedi.fchped <= x-hasta) AND
                            (s-nro-orden = "" OR faccpedi.nroped = s-nro-orden)  NO-LOCK,
                            FIRST GN-DIVI OF FacCPedi NO-LOCK:
    */

/*
   CASE TRUE:
        WHEN lChequeados = YES THEN DO:
            IF Faccpedi.FlgImpOD = YES THEN NEXT.
            IF NOT (faccpedi.flgest = 'P' AND faccpedi.flgsit = 'T') THEN NEXT.
        END.
        WHEN pSoloImpresos = YES AND Faccpedi.FlgImpOD = NO THEN NEXT.
    END CASE.
*/
    x-hasta = TODAY.
    x-desde = x-hasta - i-dias.

/*
&SCOPED-DEFINE CONDICION faccpedi.codcia = s-codcia ~
AND (s-CodDoc = "Todos" OR faccpedi.coddoc = s-coddoc) ~
AND LOOKUP(Faccpedi.CodDoc, 'O/D,O/M,OTR') > 0 ~
AND faccpedi.divdes = s-coddiv ~
AND faccpedi.flgest <> 'A' ~
AND (faccpedi.fchped >= x-desde AND faccpedi.fchped <= x-hasta) ~
AND (s-nro-orden = "" OR faccpedi.nroped = s-nro-orden)
*/
DEFINE VAR z-coddoc AS CHAR.
DEFINE VAR z-docmntos AS CHAR.
DEFINE VAR z-sec AS INT.
    
z-docmntos = "O/D,O/M,OTR".
IF s-CodDoc <> "Todos" THEN z-docmntos = s-coddoc.

REPEAT z-sec = 1 TO NUM-ENTRIES(z-docmntos,","):

    z-coddoc = ENTRY(z-sec,z-docmntos,",").

    FOR EACH FacCPedi WHERE  FacCPedi.codcia = s-codcia AND
        FacCPedi.divdes = s-coddiv AND
        FacCPedi.coddoc = z-coddoc AND
        FacCPedi.flgest <> 'A' AND 
        (faccpedi.fchped >= x-desde AND faccpedi.fchped <= x-hasta) NO-LOCK:
        IF (s-nro-orden <> "" AND faccpedi.nroped <> s-nro-orden) THEN NEXT.
        FIND FIRST GN-DIVI OF FacCPedi NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-divi THEN NEXT.
        IF NOT (faccpedi.fchent >= ltxtDesde AND faccpedi.fchent <= ltxtHasta) THEN NEXT.

        /* Pendientes x imprimir y ya esta impreso NO VA */
        IF x-pendientes-impresion = 1 THEN DO:
            IF Faccpedi.FlgImpOD = YES THEN NEXT.
            IF NOT (faccpedi.flgest = 'P' AND faccpedi.flgsit = 'T') THEN NEXT.            
        END.
        /* Impresos y esta pendiente x imprimir NO VA */
        IF x-pendientes-impresion = 2 THEN DO:
            IF Faccpedi.FlgImpOD = NO THEN NEXT.
        END.            

        IF x-pendientes-impresion = 1 OR 
            x-pendientes-impresion = 3 THEN DO:
            /* PIR o PHR */
        END.
            

        /* x Pickear */
        IF x-pickeado = 1 THEN DO:
            /* Esta Pickeado NO VA*/            
            IF NOT (faccpedi.flgest = 'P' AND faccpedi.flgsit = 'T') THEN NEXT.
        END.

        /* Pickeados */
        IF x-pickeado = 2 THEN DO:
            IF faccpedi.flgest = 'P' AND faccpedi.flgsit = 'T' THEN NEXT.
        END.
        lOrdenCompra = "*".
        IF pOrdenCompra <> '' THEN DO:
            lOrdenCompra = fOrdenCompra(INPUT FacCPedi.NroRef, INPUT pOrdenCompra).
        END.
    
        /*lFechaImpresion = IF (NUM-ENTRIES(Faccpedi.Libre_c02, '|') > 1) THEN ENTRY(2, Faccpedi.Libre_c02, '|') ELSE ''.*/
        lUserImpresion = Faccpedi.usrImpOD.
        lUserImpresion = IF (lUserImpresion = ?) THEN '' ELSE TRIM(lUserImpresion).
    
        RUN ue-sectores(INPUT faccpedi.coddoc, 
                        INPUT faccpedi.nroped,
                        OUTPUT lSectores, 
                        OUTPUT lSecImp, 
                        OUTPUT lSecAsig,
                        OUTPUT lSecDev).
    
        /* x Asignar */
        IF i-tipo-busqueda = 2 AND (lSectores = lSecAsig ) THEN NEXT.

        /* x Recepcionar */
        IF i-tipo-busqueda = 3 AND (lSecAsig = 0 OR lSecAsig = lSecDev  ) THEN NEXT.

        /* Todos Asignados */
        IF i-tipo-busqueda = 4 AND (lSectores <> lSecAsig ) THEN NEXT.

    
        CREATE ORDENES.
        BUFFER-COPY Faccpedi TO ORDENES.
        ASSIGN
            ORDENES.Libre_c01 = gn-divi.desdiv
            ORDENES.Libre_c02 = "".
        ASSIGN 
            ORDENES.UsrImpOD = ENTRY(1, Faccpedi.Libre_c02, '|')
            ORDENES.FchImpOD = (IF NUM-ENTRIES(Faccpedi.Libre_c02, '|') > 1 THEN DATETIME(ENTRY(2, Faccpedi.Libre_c02, '|'))
                ELSE ?).

        CASE s-CodDoc:
            WHEN 'O/D' OR WHEN 'O/M' OR WHEN "ODC" THEN DO:
                ORDENES.Libre_c01 = gn-divi.desdiv.
                /*ORDENES.NomCli:COLUMN-LABEL IN BROWSE {&browse-name} = "Cliente".*/
            END.
            WHEN 'OTR' THEN DO:
                ORDENES.Libre_c01 = Faccpedi.codcli.
                /*ORDENES.NomCli:COLUMN-LABEL IN BROWSE {&browse-name} = "Solicitante".*/
            END.
        END CASE.
        ASSIGN  
            Ordenes.acubon[1] = lSectores
            Ordenes.acubon[2] = lSecImp
            Ordenes.acubon[3] = lSecAsig
            Ordenes.acubon[4] = lSecDev
            Ordenes.acubon[5] = lSectores - lSecAsig.
    
        IF lSectores = lSecDev THEN ORDENES.Libre_c02 = "COMPLETADO".
        IF lSecImp > 0 AND lSecAsig = 0 THEN ORDENES.Libre_c02 = "SOLO IMPRESOS".
        IF lSecAsig > 0 AND lSecAsig = lSecDev AND lSecDev <> lSectores THEN ORDENES.Libre_c02 = "PARCIAL".
    
        /* Cesar Camus */
        RUN gn/fUbigeo (ordenes.CodDiv, 
                        ordenes.CodDoc,
                        ordenes.NroPed,
                        OUTPUT pCodDpto,
                        OUTPUT pCodProv,
                        OUTPUT pCodDist,
                        OUTPUT pCodPos,
                        OUTPUT pZona,
                        OUTPUT pSubZona
                        ).

        /* Ic - 20Set2018, correo de juan almonte 19Set2018 - Agregar Columna en "Impresión de Picking" */
        FIND FIRST TabDistr WHERE TabDistr.CodDepto = pCodDpto 
            AND TabDistr.CodProvi = pCodProv 
            AND TabDistr.CodDistr = pCodDist
            NO-LOCK NO-ERROR.
        ASSIGN  Ordenes.cdistrito = "".
        IF AVAILABLE TabDistr THEN DO:
            ASSIGN  Ordenes.cdistrito = tabdistr.nomdistr.
        END.

    
        /* Zona */
        FIND FIRST vtaCtabla WHERE vtaCtabla.codcia = s-codcia AND
                        vtaCtabla.tabla = 'ZGHR' AND 
                        vtaCtabla.llave = pZona NO-LOCK NO-ERROR.    
        
        /* SubZona */
        FIND FIRST vtaDtabla WHERE vtaDtabla.codcia = s-codcia AND
                        vtaDtabla.tabla = 'SZGHR' AND 
                        vtaDtabla.llave = pZona AND 
                        vtaDtabla.tipo = pSubZona NO-LOCK NO-ERROR.
        ASSIGN 
            ordenes.xZona = pZona
            ordenes.xSubZona = pSubZona
            ordenes.cZona = IF (AVAILABLE vtaCtabla) THEN vtaCtabla.descripcion ELSE "< No existte >"
            ordenes.cSubZona = IF (AVAILABLE vtaDtabla) THEN vtaDtabla.libre_c02 ELSE "< No existe >".
    
        RUN carga-combos IN lh_Handle (INPUT "CANAL", INPUT ordenes.coddiv, INPUT gn-divi.desdiv).
        RUN carga-combos IN lh_Handle (INPUT "ZONA", INPUT pZona, INPUT ordenes.cSubZona).

        /*RUN carga-combos IN lh_Handle (INPUT "SUBZONA", INPUT pSubZona).*/
        
    END.
END.

DEFINE VAR n_cols_browse AS INT NO-UNDO.
DEFINE VAR n_celda AS WIDGET-HANDLE NO-UNDO.

DO WITH FRAME {&FRAME-NAME}.
    DO n_cols_browse = 1 TO br_table:NUM-COLUMNS.
        n_celda = br_table:GET-BROWSE-COLUMN(n_cols_browse).
        n_celda:COLUMN-BGCOLOR = 15.
    END.        
END.

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Rb B-table-Win 
PROCEDURE Carga-Temporal-Rb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE Reporte.
EMPTY TEMP-TABLE Resumen.
EMPTY TEMP-TABLE Resumen2.
x-Ordenes = "".

DEF VAR k AS INT NO-UNDO.

SESSION:SET-WAIT-STATE('').

DO k = 1 TO {&browse-name}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF NOT {&browse-name}:FETCH-SELECTED-ROW(k) THEN NEXT.
    x-Ordenes = x-Ordenes + (IF x-Ordenes = '' THEN '' ELSE ',') + Faccpedi.NroPed.
    /* NO KITS */
    FOR EACH FacDPedi OF FacCPedi NO-LOCK,
        FIRST Almmmatg NO-LOCK WHERE Almmmatg.CodCia = FacDPedi.CodCia
        AND Almmmatg.CodMat = FacDPedi.CodMat:
        FIND FIRST Almckits OF Facdpedi NO-LOCK NO-ERROR.
        IF AVAILABLE Almckits THEN NEXT.
        FIND Reporte WHERE Reporte.CodMat = Facdpedi.codmat NO-ERROR.
        IF NOT AVAILABLE Reporte THEN CREATE Reporte.
        ASSIGN 
            Reporte.CodDoc = FacCPedi.CodDoc
            Reporte.NroPed = FacCPedi.NroPed
            Reporte.CodRef = FacCPedi.CodRef
            Reporte.NroRef = FacCPedi.NroRef
            Reporte.CodMat = FacDPedi.CodMat
            Reporte.DesMat = Almmmatg.DesMat
            Reporte.DesMar = Almmmatg.DesMar
            Reporte.UndBas = Almmmatg.UndBas
            Reporte.CanPed = Reporte.CanPed + ( FacDPedi.CanPed * FacDPedi.Factor )
            Reporte.CodAlm = FacCPedi.CodAlm
            Reporte.CodUbi = "G-0"
            Reporte.CodZona = "G-0"
            Reporte.x-peso = almmmatg.pesmat.
        FIND FIRST Almmmate WHERE Almmmate.CodCia = FacCPedi.CodCia
            AND Almmmate.CodAlm = FacDPedi.AlmDes
            AND Almmmate.CodMat = FacDPedi.CodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN DO:
            ASSIGN 
                Reporte.CodUbi = Almmmate.CodUbi.
            FIND Almtubic WHERE Almtubic.codcia = s-codcia
                AND Almtubic.codubi = Almmmate.codubi
                AND Almtubic.codalm = Almmmate.codalm
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtubic THEN Reporte.CodZona = Almtubic.CodZona.
        END.
        /* Cargamos Resumen */
        FIND Resumen WHERE Resumen.codmat = Facdpedi.codmat NO-ERROR.
        IF NOT AVAILABLE Resumen THEN CREATE Resumen.
        ASSIGN
            Resumen.codmat = Almmmatg.codmat
            Resumen.desmat = Almmmatg.desmat
            Resumen.undbas = Almmmatg.undbas
            Resumen.desmar = Almmmatg.desmar
            Resumen.nroped[k] = Faccpedi.nroped
            Resumen.canped[k] =  FacDPedi.CanPed * FacDPedi.Factor.

        /* Cargamos Resumen2 */
        FIND Resumen2 WHERE Resumen2.x-codcli = Faccpedi.codcli AND 
                        resumen2.coddoc = FacCPedi.CodDoc AND  
                        resumen2.nroped = FacCPedi.NroPed NO-ERROR.
        IF NOT AVAILABLE Resumen2 THEN DO : 
            CREATE Resumen2.
                ASSIGN
                    Resumen2.x-codcli = FACCPEDI.CodCli
                    Resumen2.X-NomCli = FACCPEDI.NomCli
                    resumen2.CodDoc   = FacCPedi.CodDoc
                    resumen2.NroPed   = FacCPedi.NroPed
                    resumen2.X-FECHA  = FACCPEDI.fchped
                    resumen2.X-fchent = faccpedi.fchent
                    resumen2.x-qtyitm = 0
                    resumen2.x-peso   = 0.
        END.
        ASSIGN resumen2.x-qtyitm = resumen2.x-qtyitm + 1.
               resumen2.x-peso  = resumen2.x-peso + (( FacDPedi.CanPed * FacDPedi.Factor ) * almmmatg.pesmat).

    END.
    /* SOLO KITS */
    FOR EACH FacDPedi OF FacCPedi NO-LOCK,
        FIRST Almckits OF Facdpedi NO-LOCK,
        EACH Almdkits OF Almckits NO-LOCK,
        FIRST Almmmatg NO-LOCK WHERE Almmmatg.CodCia = FacCPedi.CodCia
        AND Almmmatg.CodMat = AlmDKits.codmat2:
        FIND Reporte WHERE Reporte.codmat = Facdpedi.codmat NO-ERROR.
        IF NOT AVAILABLE Reporte THEN CREATE Reporte.
        ASSIGN 
            Reporte.CodDoc = FacCPedi.CodDoc
            Reporte.NroPed = FacCPedi.NroPed
            Reporte.CodRef = FacCPedi.CodRef
            Reporte.NroRef = FacCPedi.NroRef
            Reporte.CodMat = Almmmatg.CodMat
            Reporte.DesMat = TRIM(Almmmatg.DesMat) + ' (KIT ' + TRIM(Facdpedi.codmat) + ')'
            Reporte.DesMar = Almmmatg.DesMar
            Reporte.UndBas = Almmmatg.UndBas
            Reporte.CanPed = Reporte.CanPed + ( FacDPedi.CanPed * FacDPedi.Factor *  AlmDKits.Cantidad )
            Reporte.CodAlm = FacCPedi.CodAlm
            Reporte.CodUbi = "G-0"
            Reporte.CodZona = "G-0"
            Reporte.x-peso = almmmatg.pesmat.
        FIND FIRST Almmmate WHERE Almmmate.CodCia = FacCPedi.CodCia
            AND Almmmate.CodAlm = FacDPedi.AlmDes
            AND Almmmate.CodMat = Almmmatg.CodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN DO:
            ASSIGN 
                Reporte.CodUbi = Almmmate.CodUbi.
            FIND Almtubic WHERE Almtubic.codcia = s-codcia
                AND Almtubic.codubi = Almmmate.codubi
                AND Almtubic.codalm = Almmmate.codalm
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtubic THEN Reporte.CodZona = Almtubic.CodZona.
        END.
        /* Cargamos Resumen */
        FIND Resumen WHERE Resumen.codmat = Facdpedi.codmat NO-ERROR.
        IF NOT AVAILABLE Resumen THEN CREATE Resumen.
        ASSIGN
            Resumen.codmat = Almmmatg.codmat
            Resumen.desmat = TRIM(Almmmatg.DesMat) + ' (KIT ' + TRIM(Facdpedi.codmat) + ')'
            Resumen.undbas = Almmmatg.undbas
            Resumen.desmat = Almmmatg.desmat
            Resumen.nroped[k] = Faccpedi.nroped
            Resumen.canped[k] = ( FacDPedi.CanPed * FacDPedi.Factor *  AlmDKits.Cantidad ).

        /* Cargamos Resumen2 */
        FIND Resumen2 WHERE Resumen2.x-codcli = Faccpedi.codcli AND 
                        resumen2.coddoc = FacCPedi.CodDoc AND  
                        resumen2.nroped = FacCPedi.NroPed NO-ERROR.
        IF NOT AVAILABLE Resumen2 THEN DO : 
            CREATE Resumen2.
                ASSIGN
                    Resumen2.x-codcli = FACCPEDI.CodCli
                    Resumen2.X-NomCli = FACCPEDI.NomCli
                    resumen2.CodDoc   = FacCPedi.CodDoc
                    resumen2.NroPed   = FacCPedi.NroPed
                    resumen2.X-FECHA  = FACCPEDI.Libre_f01
                    resumen2.X-fchent = faccpedi.fchent
                    resumen2.x-qtyitm = 0
                    resumen2.x-peso   = 0.
        END.
        ASSIGN resumen2.x-qtyitm = resumen2.x-qtyitm + 1.
               resumen2.x-peso  = resumen2.x-peso + ((FacDPedi.CanPed * FacDPedi.Factor *  AlmDKits.Cantidad ) * almmmatg.pesmat).

    END.
END.

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Control-de-Impresion B-table-Win 
PROCEDURE Control-de-Impresion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR k AS INT NO-UNDO.

  DO k = 1 TO {&browse-name}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
      IF NOT {&browse-name}:FETCH-SELECTED-ROW(k) THEN NEXT.
      IF FacCPedi.FlgImpOD = YES THEN NEXT.
      FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE Faccpedi THEN DO:
          ASSIGN
              FacCPedi.FlgImpOD = YES
              FacCPedi.UsrImpOD = s-user-id
              FacCPedi.FchImpOD = DATETIME(TODAY, MTIME).
              /*FacCPedi.Libre_c02 = s-user-id + '|' + STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS').*/
      END.
      FIND CURRENT Faccpedi NO-LOCK NO-ERROR.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE envia-excel B-table-Win 
PROCEDURE envia-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE x-signo                 AS DECI.

DEFINE VARIABLE lsFechaEmision          AS CHARACTER.
DEFINE VARIABLE lsHoraEmision           AS CHARACTER.

DEFINE VARIABLE ldtFechaEmision         AS DATETIME.
DEFINE VARIABLE ldtFechaDistribucion    AS DATETIME.
DEFINE VARIABLE lsDifTempo_VtaAlm       AS CHARACTER.
DEFINE VARIABLE lsDifTempo_AlmDist      AS CHARACTER.
DEFINE VARIABLE lsDifTempo_VtaDist      AS CHARACTER.

DEFINE VAR lPeso AS DEC.
DEFINE VAR lNomUser AS CHAR.
DEFINE VAR lCodUser AS CHAR.

DEFINE VAR lGuiasHRutas AS CHAR.

SESSION:SET-WAIT-STATE('GENERAL').

        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication.

        /* launch Excel so it is visible to the user */
        chExcelApplication:Visible = FALSE.

        /* Para crear a new Workbook */
        chWorkbook = chExcelApplication:Workbooks:Add().

        /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(1).

        /* set the column names for the Worksheet */

        chWorkSheet:Range("A1:R1"):Font:Bold = TRUE.
        chWorkSheet:Range("A1"):Value = "Codigo".
        chWorkSheet:Range("B1"):Value = "Numero".
        chWorkSheet:Range("C1"):Value = "Emision".
        chWorkSheet:Range("D1"):Value = "Hora".
        chWorkSheet:Range("E1"):Value = "Origen".
        chWorkSheet:Range("F1"):Value = "Cliente".
        chWorkSheet:Range("G1"):Value = "Impreso por".
        chWorkSheet:Range("H1"):Value = "Fecha/Hora Impresion".
        chWorkSheet:Range("I1"):Value = "Fecha/Hora Distribucion".      /* Nueva columna */
        chWorkSheet:Range("J1"):Value = "Items".
        chWorkSheet:Range("K1"):Value = "Glosa".
        chWorkSheet:Range("L1"):Value = "De Venta a Almacén".      /* Nueva columna */
        chWorkSheet:Range("M1"):Value = "De Almacén a Distribución".      /* Nueva columna */
        chWorkSheet:Range("N1"):Value = "De Venta a Distribución".      /* Nueva columna */
        chWorkSheet:Range("O1"):Value = "Fech.Entrega".      /* Nueva columna */
        chWorkSheet:Range("P1"):Value = "Peso".      /* Nueva columna */
        chWorkSheet:Range("Q1"):Value = "Usuario envio a distribucion".
        chWorkSheet:Range("R1"):Value = "Nombre Usuario".
        chWorkSheet:Range("S1"):Value = "Guias".
        chWorkSheet:Range("T1"):Value = "Hoja de Rutas".
        chWorkSheet:Range("U1"):Value = "Orden Compra".

        iColumn = 1.

    GET FIRST {&BROWSE-NAME}.
    DO  WHILE AVAILABLE faccpedi:
            FIND FIRST gn-div OF faccpedi NO-LOCK.
             iColumn = iColumn + 1.
             cColumn = STRING(iColumn).

             chWorkSheet:Range("A" + cColumn):Value = "'" + faccpedi.coddoc.
             chWorkSheet:Range("B" + cColumn):Value = "'" + faccpedi.nroped.             
             chWorkSheet:Range("C" + cColumn):Value = faccpedi.fchped.             
             chWorkSheet:Range("D" + cColumn):Value = faccpedi.hora.
             cRange = "E" + cColumn.
             chWorkSheet:Range(cRange):Value = IF(AVAILABLE gn-divi) THEN gn-divi.desdiv ELSE "".
             cRange = "F" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.nomcli.
             cRange = "G" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.usrimpod.
             cRange = "H" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.fchimpod.

             cRange = "I" + cColumn.
             chWorkSheet:Range(cRange):Value = IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1) THEN ENTRY(2,Faccpedi.Libre_c03,'|') ELSE "".

         iCount = 0.
         FOR EACH facdpedi OF faccpedi NO-LOCK:
            iCount = iCount + 1.
         END.
             cRange = "J" + cColumn.
             chWorkSheet:Range(cRange):Value = iCount.
        
             cRange = "K" + cColumn.
             chWorkSheet:Range(cRange):Value = faccpedi.glosa.


         lsFechaEmision = STRING(faccpedi.fchped, '99-99-9999').
         lsHoraEmision  = faccpedi.hora.
         
         ldtFechaEmision      = DATETIME(lsFechaEmision + ' ' + lsHoraEmision).
         ldtFechaDistribucion = DATETIME(IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1) THEN ENTRY(2,Faccpedi.Libre_c03,'|') ELSE "").

         RUN lib\_time-passed.p (ldtFechaEmision, faccpedi.fchimpod, OUTPUT lsDifTempo_VtaAlm).
         RUN lib\_time-passed.p (faccpedi.fchimpod, ldtFechaDistribucion, OUTPUT lsDifTempo_AlmDist).
         RUN lib\_time-passed.p (ldtFechaEmision, ldtFechaDistribucion, OUTPUT lsDifTempo_VtaDist).
         
         chWorkSheet:Range("L" + cColumn):Value = lsDifTempo_VtaAlm.
         chWorkSheet:Range("M" + cColumn):Value = lsDifTempo_AlmDist.
         chWorkSheet:Range("N" + cColumn):Value = lsDifTempo_VtaDist.
         chWorkSheet:Range("O" + cColumn):Value = faccpedi.fchent.

         lPeso = fPeso().
         chWorkSheet:Range("P" + cColumn):Value = lpeso.
         cRange = "Q" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 2) THEN ENTRY(3,Faccpedi.Libre_c03,'|') ELSE "".

         lCodUser = IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 2) THEN ENTRY(3,Faccpedi.Libre_c03,'|') ELSE "".
         lNomUser = fPersonal(lCodUser).
         cRange = "R" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + lNomUser.

         lGuiasHRutas = "".
         RUN um-get-guias-rutas(INPUT faccpedi.coddoc, INPUT faccpedi.nroped, OUTPUT lGuiasHrutas).

         cRange = "S" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + lGuiasHRutas.
        
         lGuiasHRutas = "".
         RUN um-get-rutas(INPUT faccpedi.coddoc, INPUT faccpedi.nroped, OUTPUT lGuiasHrutas).

         cRange = "T" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + lGuiasHRutas.

         cRange = "U" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + faccpedi.ordcmp NO-ERROR.
         
         GET NEXT {&BROWSE-NAME}.
    END.

    SESSION:SET-WAIT-STATE('').
        
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication NO-ERROR.      
    RELEASE OBJECT chWorkbook NO-ERROR.
    RELEASE OBJECT chWorksheet NO-ERROR.
    RELEASE OBJECT chWorksheetRange NO-ERROR. 

    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE envia-excel-detalle B-table-Win 
PROCEDURE envia-excel-detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE x-signo                 AS DECI.

DEFINE VARIABLE lsFechaEmision          AS CHARACTER.
DEFINE VARIABLE lsHoraEmision           AS CHARACTER.

DEFINE VARIABLE ldtFechaEmision         AS DATETIME.
DEFINE VARIABLE ldtFechaDistribucion    AS DATETIME.
DEFINE VARIABLE lsDifTempo_VtaAlm       AS CHARACTER.
DEFINE VARIABLE lsDifTempo_AlmDist      AS CHARACTER.
DEFINE VARIABLE lsDifTempo_VtaDist      AS CHARACTER.

DEFINE VAR lPeso AS DEC.

SESSION:SET-WAIT-STATE('GENERAL').

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = FALSE.

/* Para crear a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */

chWorkSheet:Range("A1:R1"):Font:Bold = TRUE.
chWorkSheet:Range("A1"):Value = "Codigo".
chWorkSheet:Range("B1"):Value = "Numero".
chWorkSheet:COLUMNS("B"):NumberFormat = "@".
chWorkSheet:Range("C1"):Value = "Emision".
chWorkSheet:COLUMNS("C"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("D1"):Value = "Hora".
chWorkSheet:Range("E1"):Value = "Origen".
chWorkSheet:COLUMNS("E"):NumberFormat = "@".
chWorkSheet:Range("F1"):Value = "Cliente".
chWorkSheet:COLUMNS("F"):NumberFormat = "@".
chWorkSheet:Range("G1"):Value = "Impreso por".
chWorkSheet:Range("H1"):Value = "Fecha/Hora Impresion".
chWorkSheet:Range("I1"):Value = "Fecha/Hora Distribucion".      /* Nueva columna */
chWorkSheet:Range("J1"):Value = "Items".
chWorkSheet:Range("K1"):Value = "Glosa".
chWorkSheet:Range("L1"):Value = "De Venta a Almacén".      /* Nueva columna */
chWorkSheet:Range("M1"):Value = "De Almacén a Distribución".      /* Nueva columna */
chWorkSheet:Range("N1"):Value = "De Venta a Distribución".      /* Nueva columna */
chWorkSheet:Range("O1"):Value = "Fech.Entrega".      /* Nueva columna */
chWorkSheet:COLUMNS("O"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("P1"):Value = "Peso".      /* Nueva columna */
chWorkSheet:Range("Q1"):Value = "Articulo".
chWorkSheet:COLUMNS("Q"):NumberFormat = "@".
chWorkSheet:Range("R1"):Value = "Descripcion".
chWorkSheet:Range("S1"):Value = "Peso Unit".
chWorkSheet:Range("T1"):Value = "Marca".
chWorkSheet:Range("U1"):Value = "Cantidad".
chWorkSheet:Range("V1"):Value = "Unidad".
chWorkSheet:Range("W1"):Value = "Almacen".
chWorkSheet:COLUMNS("W"):NumberFormat = "@".
chWorkSheet:Range("X1"):Value = "Zona".
chWorkSheet:Range("Y1"):Value = "Ubicacion".
chWorkSheet:Range("z1"):Value = "Peso Tot".
chWorkSheet:Range("AA1"):Value = "Usuario envio a Distribucion".
chWorkSheet:Range("AB1"):Value = "Nombre Usuario".

iColumn = 1.

DEFINE VAR lNomUser AS CHAR.
DEFINE VAR lCodUser AS CHAR.

GET FIRST {&BROWSE-NAME}.
DO  WHILE AVAILABLE faccpedi:
    FIND FIRST gn-div OF faccpedi NO-LOCK.
    iCount = 0.
    FOR EACH facdpedi OF faccpedi NO-LOCK:
       iCount = iCount + 1.
    END.
    FOR EACH facdpedi OF faccpedi NO-LOCK :        
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).

        chWorkSheet:Range("A" + cColumn):Value = faccpedi.coddoc.
        chWorkSheet:Range("B" + cColumn):Value = faccpedi.nroped.             
        chWorkSheet:Range("C" + cColumn):Value = faccpedi.fchped.             
        chWorkSheet:Range("D" + cColumn):Value = faccpedi.hora.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = IF(AVAILABLE gn-divi) THEN gn-divi.desdiv ELSE "".        
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.nomcli.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.usrimpod.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.fchimpod.

        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1) THEN ENTRY(2,Faccpedi.Libre_c03,'|') ELSE "".

        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = iCount.

        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.glosa.


        lsFechaEmision = STRING(faccpedi.fchped, '99-99-9999').
        lsHoraEmision  = faccpedi.hora.

        ldtFechaEmision      = DATETIME(lsFechaEmision + ' ' + lsHoraEmision).
        ldtFechaDistribucion = DATETIME(IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1) THEN ENTRY(2,Faccpedi.Libre_c03,'|') ELSE "").

        RUN lib\_time-passed.p (ldtFechaEmision, faccpedi.fchimpod, OUTPUT lsDifTempo_VtaAlm).
        RUN lib\_time-passed.p (faccpedi.fchimpod, ldtFechaDistribucion, OUTPUT lsDifTempo_AlmDist).
        RUN lib\_time-passed.p (ldtFechaEmision, ldtFechaDistribucion, OUTPUT lsDifTempo_VtaDist).

        chWorkSheet:Range("L" + cColumn):Value = lsDifTempo_VtaAlm.
        chWorkSheet:Range("M" + cColumn):Value = lsDifTempo_AlmDist.
        chWorkSheet:Range("N" + cColumn):Value = lsDifTempo_VtaDist.
        chWorkSheet:Range("O" + cColumn):Value = faccpedi.fchent.

        lPeso = fPeso().
        chWorkSheet:Range("P" + cColumn):Value = lpeso.

        /* Detalle */
        FIND FIRST almmmatg OF facdpedi NO-LOCK NO-ERROR.
        chWorkSheet:Range("Q" + cColumn):Value = facdpedi.codmat.
        chWorkSheet:Range("R" + cColumn):Value = almmmatg.desmat.
        chWorkSheet:Range("S" + cColumn):Value = almmmatg.pesmat.
        chWorkSheet:Range("T" + cColumn):Value = almmmatg.desmar.
        chWorkSheet:Range("U" + cColumn):Value = facdpedi.canped.
        chWorkSheet:Range("V" + cColumn):Value = facdpedi.undvta.
        chWorkSheet:Range("W" + cColumn):Value = facdpedi.almdes.

        FIND FIRST Almmmate WHERE Almmmate.CodCia = FacDPedi.CodCia
            AND Almmmate.CodAlm = FacDPedi.AlmDes
            AND Almmmate.codmat = FacDPedi.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN DO:
            FIND FIRST almtubic OF Almmmate NO-LOCK NO-ERROR.
            IF AVAILABLE almtubic THEN chWorkSheet:Range("X" + cColumn):Value = almtubic.CodZona.
            chWorkSheet:Range("Y" + cColumn):Value = Almmmate.CodUbi.
        END.
        chWorkSheet:Range("Z" + cColumn):VALUE = (FacDPedi.CanPed * Almmmatg.Pesmat ).
        chWorkSheet:Range("AA" + cColumn):Value = "'" + IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 2) THEN ENTRY(3,Faccpedi.Libre_c03,'|') ELSE "".

         lCodUser = IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 2) THEN ENTRY(3,Faccpedi.Libre_c03,'|') ELSE "".
         lNomUser = fPersonal(lCodUser).
         cRange = "AB" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + lNomUser.

    END.
    GET NEXT {&BROWSE-NAME}.
END.

SESSION:SET-WAIT-STATE('').
    
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR. 

MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE filtar-datos B-table-Win 
PROCEDURE filtar-datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCliente AS CHAR.
DEFINE INPUT PARAMETER pCanal AS CHAR.

z-cliente   = pCliente.
z-canal     = pCanal.

IF z-cliente <> '' THEN z-cliente = "*" + z-cliente + "*".

{&OPEN-QUERY-br_table}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Rb-500 B-table-Win 
PROCEDURE Formato-Rb-500 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1.    
DEFINE VARIABLE c-items        AS INTEGER  NO-UNDO.
DEFINE VARIABLE npage          AS INTEGER  NO-UNDO.
DEFINE VAR lpeso AS DEC.

lpeso = fPeso().

c-items = 13.       /* por pagina */
npage = 0.          /* # de paginas */
conta = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    conta = conta + 1.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        npage = npage + 1.
        conta = 1.
    END.
END.

x-Direccion = gn-clie.dircli.
FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
IF AVAILABLE TabDepto THEN DO:
    x-Direccion = TRIM(x-Direccion) + " - " + TRIM(TabDepto.NomDepto).
    FIND TabProvi WHERE TabProvi.CodDepto = gn-clie.CodDept 
        AND TabProvi.CodProvi = gn-clie.CodProv
        NO-LOCK NO-ERROR.
    IF AVAILABLE TabProvi THEN DO:
        x-Direccion = x-Direccion + ' - '+ TRIM(TabProvi.NomProvi).
        FIND TabDistr WHERE TabDistr.CodDepto = gn-clie.CodDept
            AND TabDistr.CodProvi = gn-clie.CodProv
            AND TabDistr.CodDistr = gn-clie.CodDist
            NO-LOCK NO-ERROR.
        IF AVAILABLE TabDistr THEN x-Direccion = x-Direccion + ' - ' + TabDistr.NomDistr.
    END.
END.
x-Comprobante = ''.
FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.codped = Faccpedi.codref
    AND Ccbcdocu.nroped = Faccpedi.nroref
    AND Ccbcdocu.flgest <> 'A'
    NO-LOCK NO-ERROR.
IF AVAILABLE Ccbcdocu THEN x-Comprobante = Ccbcdocu.coddoc + ' ' + Ccbcdocu.nrodoc.
    

DEFINE FRAME f-cab
        Reporte.CodUbi FORMAT "x(10)"
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + s-NomCia + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN4} + {&PRN7A} + {&PRN6B} + "        Pagina: " + STRING(PAGE-NUMBER(REPORT), "ZZ9") + "/" + STRING(npage, "ZZ9") + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(40)" AT 80 SKIP
        {&PRN4} + {&PRN6A} + "      Fecha: " + STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(27)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "      N° ORDEN: " + Reporte.CodDoc + ' ' + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "     Origen: " + GN-DIVI.DesDiv + {&PRN6B} + {&PRN3} FORMAT "X(50)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "     N° PEDIDO: " + Reporte.CodRef + ' ' + Reporte.NroRef + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "   Vendedor: " + gn-ven.NomVen + {&PRN6B} + {&PRN3} FORMAT "X(50)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° COMPROBANTE: " + x-Comprobante + {&PRN6B} + {&PRN7B} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "    Cliente: " + Faccpedi.nomcli + {&PRN6B} FORMAT "X(50)"        
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Fec. Despacho : " + STRING(faccpedi.fchent,"99/99/9999") + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "       Hora: " + STRING(TIME,"HH:MM") + {&PRN6B} FORMAT "X(22)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "         Peso : " + STRING(lPeso,">>>,>>9.99") + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "  Dirección: " + x-Direccion + {&PRN6B} FORMAT "X(120)" SKIP
        "Ubicación  Código  Descripción                                                    Marca                  Unidad      Cantidad Observaciones            " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     1234567890 9999999 123456789012345678901234567890123456789012345678901234567890 123456789012345678901234 1234 >>,>>>,>>9.9999 ________________________ */
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

conta = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY SUBSTRING(Reporte.CodUbi,1,2) BY Reporte.CodUbi BY Reporte.CodMat:
    DISPLAY STREAM Report 
        Reporte.CodUbi
        Reporte.CodMat 
        Reporte.DesMat
        Reporte.DesMar
        Reporte.UndBas
        Reporte.CanPed
        "________________________"
        WITH FRAME f-cab.
    conta = conta + 1.
    IF LAST-OF(SUBSTRING(Reporte.CodUbi,1,2)) THEN DO:
        DOWN STREAM Report 1 WITH FRAME f-cab.
    END.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        PAGE STREAM Report.
        conta = 1.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Rb-Multi B-table-Win 
PROCEDURE Formato-Rb-Multi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1.    
DEFINE VARIABLE c-items AS INTEGER NO-UNDO.
DEFINE VARIABLE npage   AS INTEGER NO-UNDO.
DEFINE VARIABLE n-Item  AS INTEGER NO-UNDO.
DEFINE VARIABLE t-Items AS INTEGER NO-UNDO.

DEFINE VAR lPeso AS DEC.
lPeso = fPeso().

c-items = 13.       /* por pagina */
npage = 0.          /* # de paginas */
conta = 1.
t-Items = 0.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    conta = conta + 1.
    t-Items = t-Items + 1.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        npage = npage + 1.
        conta = 1.
    END.
END.

DEFINE FRAME f-cab
        n-Item         FORMAT '>9'
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        HEADER
        {&PRN2} + {&PRN7A} + s-NOMCIA + {&PRN7B} + {&PRN2} FORMAT "X(45)" SKIP
        {&PRN3} + {&PRN7A} + "Pagina: " + STRING(PAGE-NUMBER(REPORT), "Z9") + "/" + STRING(npage, "Z9") + {&PRN7B} + {&PRN3} FORMAT 'x(20)' AT 70 SKIP
        {&PRN4} + "      Fecha: " + STRING(TODAY,"99/99/9999") AT 1 FORMAT "X(30)"
        {&PRN3} + "   N° DE ITEMS: " + STRING(t-Items, '>>>9') AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + "       Hora: " + STRING(TIME,"HH:MM") FORMAT "X(20)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Fec. Despacho : " + STRING(faccpedi.fchent,"99/99/9999") + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + "    Ordenes: " + x-Ordenes  FORMAT "X(120)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "         Peso : " + STRING(lPeso,">>>,>>9.99") + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP        
        {&PRN4} + {&PRN6B} + "It Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     12 999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

conta = 1.
n-Item = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    DISPLAY STREAM Report 
        n-Item
        Reporte.CodMat 
        Reporte.DesMat
        Reporte.DesMar
        Reporte.UndBas
        Reporte.CanPed
        Reporte.CodUbi
        "________________________"
        WITH FRAME f-cab.
    conta = conta + 1.
    n-Item = n-Item + 1.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        PAGE STREAM Report.
        conta = 1.
        n-Item = 1.
    END.
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Rb-Multi-Resumen B-table-Win 
PROCEDURE Formato-Rb-Multi-Resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE npage   AS INTEGER NO-UNDO.
DEFINE VARIABLE n-Item  AS INTEGER NO-UNDO.
DEFINE VARIABLE k AS INT NO-UNDO.
DEFINE VARIABLE j AS INT NO-UNDO.
DEFINE VARIABLE z AS INT NO-UNDO.
DEFINE VARIABLE x-Cabecera   AS CHAR NO-UNDO.
DEFINE VARIABLE x-Linea      AS CHAR NO-UNDO.
DEFINE VARIABLE x-CanPed     AS DEC  NO-UNDO.

/* Imprimimos por cada 7 ordenes de despacho */
j = 0.
x-Cabecera = "Codigo Descripcion                                  Marca           Unidad ".
            /*123456 123456789012345678901234567890123456789012345678901234567890 123456 */
DO k = 1 TO NUM-ENTRIES(x-Ordenes):
    j = j + 1.
    x-Cabecera = x-Cabecera + ' ' + STRING(ENTRY(k, x-Ordenes), 'x(9)') .
    DEFINE FRAME f-cab
        x-Linea FORMAT 'x(160)'
        HEADER
        {&PRN2} + {&PRN7A} + s-NOMCIA + {&PRN7B} + {&PRN2} FORMAT "X(45)" SKIP
        {&PRN3} + {&PRN7A} + "Pagina: " + STRING(PAGE-NUMBER(REPORT), "Z9") + {&PRN7B} + {&PRN3} FORMAT 'x(20)' AT 70 SKIP
        {&PRN4} + "      Fecha: " + STRING(TODAY,"99/99/9999") AT 1 FORMAT "X(30)"
        {&PRN4} + "       Hora: " + STRING(TIME,"HH:MM") FORMAT "X(20)" SKIP
        {&PRN4} + "    Ordenes: " + x-Ordenes  FORMAT "X(120)" SKIP
        x-Cabecera FORMAT 'x(160)'
        WITH WIDTH 160 NO-BOX NO-LABELS STREAM-IO DOWN.
    IF j = 8 THEN DO:
        FOR EACH Resumen:
            /* Veamos si tienen cantidades */
            x-CanPed = 0.
            DO z = k - 7 TO k:
                x-CanPed = x-CanPed + Resumen.CanPed[z].
            END.
            IF x-CanPed > 0 THEN DO:
                /* Impresion de linea */
                x-Linea = Resumen.codmat + ' ' + STRING(Resumen.desmat, 'x(44)') + ' ' + 
                    STRING(Resumen.desmar, 'x(15)') + ' ' +
                    STRING(Resumen.UndBas, 'x(6)').
                DO z = k - 7 TO k:
                    x-Linea = x-Linea + ' ' + STRING(Resumen.CanPed[z], '>>,>>9.99').
                END.
                DISPLAY STREAM Report 
                    x-Linea 
                    WITH FRAME f-Cab.
            END.
        END.
        x-Cabecera = "Codigo Descripcion                                  Marca           Unidad ".
        j = 0.
    END.
END.

k = k - 1.
IF j > 0  THEN DO:
    PAGE STREAM REPORT.
    DEFINE FRAME f-cab-2
        x-Linea FORMAT 'x(160)'
        HEADER
        {&PRN2} + {&PRN7A} + s-NOMCIA + {&PRN7B} + {&PRN2} FORMAT "X(45)" SKIP
        {&PRN3} + {&PRN7A} + "Pagina: " + STRING(PAGE-NUMBER(REPORT), "Z9") + {&PRN7B} + {&PRN3} FORMAT 'x(20)' AT 70 SKIP
        {&PRN4} + "      Fecha: " + STRING(TODAY,"99/99/9999") AT 1 FORMAT "X(30)"
        {&PRN4} + "       Hora: " + STRING(TIME,"HH:MM") FORMAT "X(20)" SKIP
        {&PRN4} + "    Ordenes: " + x-Ordenes  FORMAT "X(120)" SKIP
        x-Cabecera FORMAT 'x(160)'
        WITH WIDTH 160 NO-BOX NO-LABELS STREAM-IO DOWN.
    FOR EACH Resumen:
        /* Veamos si tienen cantidades */
        x-CanPed = 0.
        DO z = k - j + 1 TO k:
            x-CanPed = x-CanPed + Resumen.CanPed[z].
        END.
        IF x-CanPed > 0 THEN DO:
            /* Impresion de linea */
            x-Linea = Resumen.codmat + ' ' + STRING(Resumen.desmat, 'x(44)') + ' ' + 
                STRING(Resumen.desmar, 'x(15)') + ' ' +
                STRING(Resumen.UndBas, 'x(6)').
            DO z = k - j + 1 TO k:
                x-Linea = x-Linea + ' ' + STRING(Resumen.CanPed[z], '>>,>>9.99').
            END.
            DISPLAY STREAM Report 
                x-Linea
                WITH FRAME f-Cab-2.
        END.
    END.
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formato-rb-multi-resumen2 B-table-Win 
PROCEDURE formato-rb-multi-resumen2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1.    
DEFINE VARIABLE c-items AS INTEGER NO-UNDO.
DEFINE VARIABLE n-item AS INTEGER NO-UNDO.

c-items = 13.       /* por pagina */

DEFINE FRAME f-cab         
        resumen2.X-codcli   FORMAT 'X(11)'
        resumen2.X-NomCli   FORMAT 'x(60)'
        resumen2.CodDoc     FORMAT 'x(4)'
        resumen2.NroPed     FORMAT 'x(10)'
        resumen2.X-FECHA     
        resumen2.X-fchent     
        resumen2.x-qtyitm FORMAT ">>>>9"
        resumen2.x-peso FORMAT ">>>,>>>,>>9.99"
        HEADER
        {&PRN2} + {&PRN7A} + s-NOMCIA + {&PRN7B} + {&PRN2} FORMAT "X(45)" SKIP
        {&PRN3} + {&PRN7A} + "Pagina: " + STRING(PAGE-NUMBER(REPORT), "Z9") + {&PRN7B} + {&PRN3} FORMAT 'x(20)' AT 70 SKIP
        {&PRN4} + "      Fecha: " + STRING(TODAY,"99/99/9999") AT 1 FORMAT "X(30)"
        {&PRN4} + "       Hora: " + STRING(TIME,"HH:MM") FORMAT "X(30)" SKIP
        {&PRN4} + {&PRN6B} + "Codigo      Nombre del Cliente                                           Nro de Orden   Emision    Entrega    Itms  Peso         " FORMAT 'x(160)' SKIP
        "---------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.        
/**     "99999999999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx X/X xxxxxxxxxx xx/xx/xxxx xx/xx/xxxx 99999 999,999,999.99 */

conta = 1.
n-Item = 1.
FOR EACH resumen2:
    DISPLAY STREAM Report 
        resumen2.X-codcli
        resumen2.X-NomCli
        resumen2.CodDoc
        resumen2.NroPed
        resumen2.X-FECHA     
        resumen2.X-fchent     
        resumen2.x-qtyitm
        resumen2.x-peso
        WITH FRAME f-cab.
    conta = conta + 1.
    n-Item = n-Item + 1.
    IF conta > c-items  THEN DO:
        PAGE STREAM Report.
        conta = 1.
        n-Item = 1.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Rb-OD B-table-Win 
PROCEDURE Formato-Rb-OD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1.    
DEFINE VARIABLE c-items AS INTEGER NO-UNDO.
DEFINE VARIABLE npage   AS INTEGER NO-UNDO.
DEFINE VARIABLE n-Item  AS INTEGER NO-UNDO.
DEFINE VARIABLE t-Items AS INTEGER NO-UNDO.

DEFINE VAR lpeso AS DEC.

lPeso = 0.
lpeso = fpeso().

c-items = 13.       /* por pagina */
npage = 0.          /* # de paginas */
conta = 1.
t-Items = 0.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    conta = conta + 1.
    t-Items = t-Items + 1.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        npage = npage + 1.
        conta = 1.
    END.
END.

FIND gn-divi OF Faccpedi NO-LOCK NO-ERROR.
FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = Faccpedi.codcli NO-LOCK NO-ERROR.
FIND gn-ven OF Faccpedi NO-LOCK NO-ERROR.
x-Direccion = gn-clie.dircli.
FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
IF AVAILABLE TabDepto THEN DO:
    x-Direccion = TRIM(x-Direccion) + " - " + TRIM(TabDepto.NomDepto).
    FIND TabProvi WHERE TabProvi.CodDepto = gn-clie.CodDept 
        AND TabProvi.CodProvi = gn-clie.CodProv
        NO-LOCK NO-ERROR.
    IF AVAILABLE TabProvi THEN DO:
        x-Direccion = x-Direccion + ' - '+ TRIM(TabProvi.NomProvi).
        FIND TabDistr WHERE TabDistr.CodDepto = gn-clie.CodDept
            AND TabDistr.CodProvi = gn-clie.CodProv
            AND TabDistr.CodDistr = gn-clie.CodDist
            NO-LOCK NO-ERROR.
        IF AVAILABLE TabDistr THEN x-Direccion = x-Direccion + ' - ' + TabDistr.NomDistr.
    END.
END.
x-Comprobante = ''.
FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.codped = Faccpedi.codref
    AND Ccbcdocu.nroped = Faccpedi.nroref
    AND Ccbcdocu.flgest <> 'A'
    NO-LOCK NO-ERROR.
IF AVAILABLE Ccbcdocu THEN x-Comprobante = Ccbcdocu.coddoc + ' ' + Ccbcdocu.nrodoc.
    
DEF VAR x-NomCli AS CHAR NO-UNDO.

x-NomCli = Faccpedi.nomcli.
RUN lib/limpiar-texto ( x-NomCli, '', OUTPUT x-NomCli).
DEFINE FRAME f-cab
        n-Item         FORMAT '>9'
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + s-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " + STRING(PAGE-NUMBER(REPORT), "Z9") + "/" + STRING(npage, "Z9") FORMAT 'x(20)' AT 75 SKIP
        {&PRN4} + {&PRN6A} + "      Fecha: " AT 1 FORMAT "X(17)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "      N° ORDEN: " + Reporte.CodDoc + ' ' + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "     N° PEDIDO: " + Reporte.CodRef + ' ' + Reporte.NroRef + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° COMPROBANTE: " + x-Comprobante + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "   N° DE ITEMS: " + STRING(t-Items, '>>>9') + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "     Origen: " + GN-DIVI.DesDiv + {&PRN6B} + {&PRN3} FORMAT "X(50)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Fec. Despacho : " + STRING(faccpedi.fchent,"99/99/9999") + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "   Vendedor: " + gn-ven.NomVen + {&PRN6B} + {&PRN3} FORMAT "X(50)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "         Peso : " + STRING(lPeso,">>>,>>9.99") + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "    Cliente: " + x-NomCli + {&PRN6B} + {&PRN3} FORMAT "X(50)" SKIP
        {&PRN4} + {&PRN6B} + "       Hora: " STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP
        {&PRN4} + {&PRN6B} + "  Dirección: " + x-Direccion FORMAT "X(120)" SKIP
        {&PRN4} + {&PRN6B} + "Observación: " + Faccpedi.glosa  FORMAT "X(80)" SKIP
        "It Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     12 999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

conta = 1.
n-Item = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    DISPLAY STREAM Report 
        n-Item
        Reporte.CodMat 
        Reporte.DesMat
        Reporte.DesMar
        Reporte.UndBas
        Reporte.CanPed
        Reporte.CodUbi
        "________________________"
        WITH FRAME f-cab.
    conta = conta + 1.
    n-Item = n-Item + 1.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        PAGE STREAM Report.
        conta = 1.
        n-Item = 1.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Rb-OTR B-table-Win 
PROCEDURE Formato-Rb-OTR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1.    
DEFINE VARIABLE c-items AS INTEGER NO-UNDO.
DEFINE VARIABLE npage   AS INTEGER NO-UNDO.
DEFINE VARIABLE n-Item  AS INTEGER NO-UNDO.
DEFINE VARIABLE t-Items AS INTEGER NO-UNDO.

DEFINE VAR x-pesotot AS DEC.

c-items = 13.       /* por pagina */
npage = 0.          /* # de paginas */
conta = 1.
t-Items = 0.
x-pesotot = 0.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    conta = conta + 1.
    t-Items = t-Items + 1.
    x-pesotot = x-pesotot + (Reporte.canped * reporte.X-peso).
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        npage = npage + 1.
        conta = 1.
    END.
END.

/* Glosa desde las SOLICTUDES DE R/A  */
DEFINE VAR lxSer AS INT.
DEFINE VAR lxNroDcto AS INT.
DEFINE VAR lxGlosa AS CHAR INIT ''.

lxGlosa = Faccpedi.glosa.

IF Faccpedi.glosa = ? OR Faccpedi.glosa = '' THEN DO:
    IF faccpedi.codref = 'R/A' THEN DO:
        lxSer = INT(SUBSTRING(faccpedi.nroref,1,3)).
        lxNroDcto = INT(SUBSTRING(faccpedi.nroref,4)).

        FIND FIRST almcrepo WHERE almcrepo.codcia = s-codcia AND 
                                    almcrepo.codalm = faccpedi.codcli AND 
                                    almcrepo.nroser = lxSer AND 
                                    almcrepo.nrodoc = lxNroDcto NO-LOCK NO-ERROR.
        IF AVAILABLE almcrepo THEN DO:
            lxGlosa = almcrepo.glosa.
        END.
    END.
END.

DEFINE FRAME f-cab
        n-Item         FORMAT '>9'
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + s-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " + STRING(PAGE-NUMBER(REPORT), "Z9") + "/" + STRING(npage, "Z9") FORMAT 'x(20)' AT 75 SKIP
        {&PRN4} + {&PRN6A} + "      Fecha: " AT 1 FORMAT "X(17)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "      N° ORDEN: " + Reporte.CodDoc + ' ' + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "  N° SOLICITUD: " + Reporte.CodRef + ' ' + Reporte.NroRef + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "   N° DE ITEMS: " + STRING(t-Items, '>>>9') + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "          PESO: " + STRING(x-pesotot, '>>>,>>9.99') + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        /*{&PRN4} + {&PRN6A} + "    Destino: " + Faccpedi.codcli + ' ' + Faccpedi.nomcli + {&PRN6B} + {&PRN3} FORMAT "X(50)" SKIP*/       
        {&PRN3} + {&PRN7A} + {&PRN6B} + " F. Entrega: " + STRING(faccpedi.fchent,"99/99/9999") + {&PRN6B} + {&PRN7B} + {&PRN3} AT 90 FORMAT "X(40)" SKIP        
        {&PRN4} + {&PRN6A} + "    Destino: " + Faccpedi.codcli + ' ' + trim(Faccpedi.nomcli) + {&PRN6B} + {&PRN3} FORMAT "X(60)" SKIP    
        {&PRN4} + {&PRN6B} + "       Hora: " STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP
        {&PRN4} + {&PRN6B} + "Observación: " + lxGlosa  FORMAT "X(80)" SKIP
        "It Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     12 999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

conta = 1.
n-Item = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    DISPLAY STREAM Report 
        n-Item
        Reporte.CodMat 
        Reporte.DesMat
        Reporte.DesMar
        Reporte.UndBas
        Reporte.CanPed
        Reporte.CodUbi
        "________________________"
        WITH FRAME f-cab.
    conta = conta + 1.
    n-Item = n-Item + 1.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        PAGE STREAM Report.
        conta = 1.
        n-Item = 1.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Rb2-OD B-table-Win 
PROCEDURE Formato-Rb2-OD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1.    
DEFINE VARIABLE c-items        AS INTEGER  NO-UNDO.
DEFINE VARIABLE npage          AS INTEGER  NO-UNDO.
DEFINE VARIABLE t-Items AS INTEGER NO-UNDO.

DEFINE VAR lPeso AS DEC.

lPeso = fpeso().

c-items = 13.       /* por pagina */
npage = 0.          /* # de paginas */
conta = 1.
t-Items = 0.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    conta = conta + 1.
    t-Items = t-Items + 1.
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        npage = npage + 1.
        conta = 1.
    END.
END.
FIND gn-divi OF Faccpedi NO-LOCK NO-ERROR.
FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = Faccpedi.codcli NO-LOCK NO-ERROR.
FIND gn-ven OF Faccpedi NO-LOCK NO-ERROR.
x-Direccion = gn-clie.dircli.
FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
IF AVAILABLE TabDepto THEN DO:
    x-Direccion = TRIM(x-Direccion) + " - " + TRIM(TabDepto.NomDepto).
    FIND TabProvi WHERE TabProvi.CodDepto = gn-clie.CodDept 
        AND TabProvi.CodProvi = gn-clie.CodProv
        NO-LOCK NO-ERROR.
    IF AVAILABLE TabProvi THEN DO:
        x-Direccion = x-Direccion + ' - '+ TRIM(TabProvi.NomProvi).
        FIND TabDistr WHERE TabDistr.CodDepto = gn-clie.CodDept
            AND TabDistr.CodProvi = gn-clie.CodProv
            AND TabDistr.CodDistr = gn-clie.CodDist
            NO-LOCK NO-ERROR.
        IF AVAILABLE TabDistr THEN x-Direccion = x-Direccion + ' - ' + TabDistr.NomDistr.
    END.
END.
x-Comprobante = ''.
FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.codped = Faccpedi.codref
    AND Ccbcdocu.nroped = Faccpedi.nroref
    AND Ccbcdocu.flgest <> 'A'
    NO-LOCK NO-ERROR.
IF AVAILABLE Ccbcdocu THEN x-Comprobante = Ccbcdocu.coddoc + ' ' + Ccbcdocu.nrodoc.
FIND gn-divi OF Faccpedi NO-LOCK NO-ERROR.    

DEFINE FRAME f-cab
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + s-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " AT 80 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9"
        {&PRN4} + {&PRN7A} + {&PRN6B} + "/" + STRING(npage) AT 104 FORMAT "X(15)" SKIP(1)
        {&PRN4} + {&PRN6A} + "      Fecha: " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "      N° ORDEN: " + Reporte.CodDoc + ' ' + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "     N° PEDIDO: " + Reporte.CodRef + ' ' + Reporte.NroRef + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° COMPROBANTE: " + x-Comprobante + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "     Origen: " + GN-DIVI.DesDiv + {&PRN6B} + {&PRN3} FORMAT "X(50)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Fec. Despacho : " + STRING(faccpedi.fchent,"99/99/9999") + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "   Vendedor: " + SUBSTRING(gn-ven.NomVen,1,30) + {&PRN6B} + {&PRN3} FORMAT "X(50)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "         Peso : " + STRING(lPeso,">>>,>>9.99") + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "    Cliente: " + Faccpedi.nomcli + {&PRN6B} + {&PRN3} FORMAT "X(50)" SKIP
        {&PRN4} + {&PRN6B} + "       Hora: " + STRING(TIME,"HH:MM") FORMAT "X(25)"  
        {&PRN4} + {&PRN6B} + " Nro Items : " + STRING(t-Items, '>>>9') AT 80 FORMAT "X(30)" SKIP
        {&PRN4} + {&PRN6B} + "  Dirección: " + x-Direccion FORMAT "X(120)" SKIP
        {&PRN4} + {&PRN6B} + "Observación: " + Faccpedi.glosa  FORMAT "X(80)" SKIP  
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

/* DEFINE FRAME f-cab                                                                                                                                                     */
/*         Reporte.CodMat FORMAT 'X(7)'                                                                                                                                   */
/*         Reporte.DesMat FORMAT 'x(60)'                                                                                                                                  */
/*         Reporte.DesMar FORMAT 'X(24)'                                                                                                                                  */
/*         Reporte.UndBas                                                                                                                                                 */
/*         Reporte.CanPed FORMAT ">>,>>>,>>9.9999"                                                                                                                        */
/*         Reporte.CodUbi FORMAT "x(10)"                                                                                                                                  */
/*         HEADER                                                                                                                                                         */
/*         {&PRN2} + {&PRN7A} + {&PRN6A} + s-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)"                                                                        */
/*         {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " AT 85 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9"                                                               */
/*         {&PRN4} + {&PRN7A} + {&PRN6B} + "/" + string(npage) AT 104 FORMAT "X(15)" SKIP(1)                                                                              */
/*         {&PRN4} + {&PRN6A} + " Fecha : " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"                                                                 */
/*         {&PRN3} + {&PRN7A} + {&PRN6B} + "N° ORDEN: " + Reporte.CodDoc + ' ' + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 90 FORMAT "X(30)" SKIP                 */
/*         {&PRN4} + {&PRN6A} + "Cliente: " + Faccpedi.nomcli + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(50)" SKIP                                                               */
/*         {&PRN4} + {&PRN6B} + "Hora  : " AT 1 FORMAT "X(15)" STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP                                                                   */
/*         "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP */
/*         "Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP */
/*         "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP */
/* /***     999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/            */
/*          WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.                                                                                                  */

conta = 1.
FOR EACH Reporte BY Reporte.DesMat:
    DISPLAY STREAM Report 
        Reporte.CodMat 
        Reporte.DesMat
        Reporte.DesMar
        Reporte.UndBas
        Reporte.CanPed
        Reporte.CodUbi
        "________________________"
        WITH FRAME f-cab.
    conta = conta + 1.
    IF conta > c-items THEN DO:
        PAGE STREAM Report.
        conta = 1.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Rb2-OTR B-table-Win 
PROCEDURE Formato-Rb2-OTR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1.    
DEFINE VARIABLE c-items        AS INTEGER  NO-UNDO.
DEFINE VARIABLE npage          AS INTEGER  NO-UNDO.

DEFINE VAR x-pesotot AS DEC.

c-items = 13.       /* por pagina */
npage = 0.          /* # de paginas */
x-pesotot = 0.
conta = 1.
FOR EACH Reporte BREAK BY Reporte.CodZon BY Reporte.CodUbi BY Reporte.CodMat:
    conta = conta + 1.
    x-pesotot = x-pesotot + (Reporte.canped * reporte.X-peso).
    IF conta > c-items OR LAST-OF(Reporte.CodZon) THEN DO:
        npage = npage + 1.
        conta = 1.
    END.
END.
/* Glosa desde las SOLICTUDES DE R/A  */
DEFINE VAR lxSer AS INT.
DEFINE VAR lxNroDcto AS INT.
DEFINE VAR lxGlosa AS CHAR INIT ''.

lxGlosa = Faccpedi.glosa.

IF Faccpedi.glosa = ? OR Faccpedi.glosa = '' THEN DO:
    IF faccpedi.codref = 'R/A' THEN DO:
        lxSer = INT(SUBSTRING(faccpedi.nroref,1,3)).
        lxNroDcto = INT(SUBSTRING(faccpedi.nroref,4)).

        FIND FIRST almcrepo WHERE almcrepo.codcia = s-codcia AND 
                                    almcrepo.codalm = faccpedi.codcli AND 
                                    almcrepo.nroser = lxSer AND 
                                    almcrepo.nrodoc = lxNroDcto NO-LOCK NO-ERROR.
        IF AVAILABLE almcrepo THEN DO:
            lxGlosa = almcrepo.glosa.
        END.
    END.
END.

DEFINE FRAME f-cab
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + s-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " + STRING(PAGE-NUMBER(REPORT), "Z9") + "/" + STRING(npage, "Z9") FORMAT 'x(20)' AT 75 SKIP
        /*
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " AT 80 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9"
         {&PRN3} + {&PRN7A} + {&PRN6B} + "/" + STRING(npage) {&PRN6B} + {&PRN7B} + {&PRN3} AT 104 FORMAT "X(15)" SKIP /*(1)*/
         */
        /*
        {&PRN4} + {&PRN7A} + {&PRN6B} + "/" + STRING(npage) AT 104 FORMAT "X(15)" SKIP(1)
        */
        {&PRN4} + {&PRN6A} + "      Fecha: " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "      N° ORDEN: " + Reporte.CodDoc + ' ' + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "  N° SOLICITUD: " + Reporte.CodRef + ' ' + Reporte.NroRef + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + "          PESO: " + STRING(x-pesotot,">>>,>>9.99")  + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP
        {&PRN3} + {&PRN7A} + {&PRN6B} + " F. Entrega: " + STRING(faccpedi.fchent,"99/99/9999") + {&PRN6B} + {&PRN7B} + {&PRN3} AT 90 FORMAT "X(40)" SKIP
        {&PRN4} + {&PRN6A} + "    Destino: " + Faccpedi.codcli + ' ' + trim(Faccpedi.nomcli) + {&PRN6B} + {&PRN3} FORMAT "X(60)" SKIP        
        {&PRN4} + {&PRN6B} + "       Hora: " STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP
        {&PRN4} + {&PRN6B} + "Observación: " + lxGlosa  FORMAT "X(80)" SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

conta = 1.
FOR EACH Reporte BY Reporte.DesMat:
    DISPLAY STREAM Report 
        Reporte.CodMat 
        Reporte.DesMat
        Reporte.DesMar
        Reporte.UndBas
        Reporte.CanPed
        Reporte.CodUbi
        "________________________"
        WITH FRAME f-cab.
    conta = conta + 1.
    IF conta > c-items THEN DO:
        PAGE STREAM Report.
        conta = 1.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir-Formato-OD B-table-Win 
PROCEDURE Imprimir-Formato-OD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pOrden AS CHAR.
/*
ZONA: por zona
ALFABETICO: por descripción
*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Impresión por Zonas y Ubicaciones */
  DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

  RUN lib/Imprimir2.
  IF s-salida-impresion = 0 THEN RETURN.

  RUN Carga-Temporal-Rb.

  IF s-salida-impresion = 1 THEN 
      s-print-file = SESSION:TEMP-DIRECTORY +
      STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

  DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
      CASE s-salida-impresion:
          WHEN 1 OR WHEN 3 THEN
              OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 30.
          WHEN 2 THEN
              OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 30. /* Impresora */
      END CASE.
      PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(33) + {&Prn4} .
      CASE TRUE:
          WHEN s-CodDiv = '00500' AND pOrden = "ZONA" THEN RUN Formato-Rb-500.
          WHEN pOrden = "ZONA" AND {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 1
              THEN RUN Formato-Rb-OD.
          WHEN pOrden = "ZONA" AND {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} > 1
              THEN DO: 
              RUN Formato-Rb-Multi.
              RUN Formato-Rb-Multi-Resumen.
              RUN Formato-Rb-Multi-Resumen2.
              RUN dispatch IN THIS-PROCEDURE ('open-query':U).
          END.
          WHEN pOrden = "ALFABETICO" THEN RUN Formato-Rb2-OD.
      END CASE.
      PAGE STREAM REPORT.
      OUTPUT STREAM REPORT CLOSE.
  END.
  OUTPUT CLOSE.
  CASE s-salida-impresion:
      WHEN 1 OR WHEN 3 THEN DO:
          RUN LIB/W-README.R(s-print-file).
          IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
      END.
  END CASE.
  /* SE ENVIA AL ALMACEN */
  RUN Control-de-Impresion.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir-Formato-OTR B-table-Win 
PROCEDURE Imprimir-Formato-OTR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pOrden AS CHAR.
/*
ZONA: por zona
ALFABETICO: por descripción
*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Impresión por Zonas y Ubicaciones */
  DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

  RUN lib/Imprimir2.
  IF s-salida-impresion = 0 THEN RETURN.

  RUN Carga-Temporal-Rb.

  IF s-salida-impresion = 1 THEN 
      s-print-file = SESSION:TEMP-DIRECTORY +
      STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

  DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
      CASE s-salida-impresion:
          WHEN 1 OR WHEN 3 THEN
              OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 30.
          WHEN 2 THEN
              OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 30. /* Impresora */
      END CASE.
      PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(33) + {&Prn4} .
      CASE TRUE:
          WHEN s-CodDiv = '00500' AND pOrden = "ZONA" THEN RUN Formato-Rb-500.
          WHEN pOrden = "ZONA" AND {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 1
              THEN RUN Formato-Rb-OTR.
          WHEN pOrden = "ZONA" AND {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} > 1
              THEN DO: 
              RUN Formato-Rb-Multi.
              RUN Formato-Rb-Multi-Resumen2.
              RUN dispatch IN THIS-PROCEDURE ('open-query':U).
          END.
          WHEN pOrden = "ALFABETICO" THEN RUN Formato-Rb2-OTR.
      END CASE.
      PAGE STREAM REPORT.
      OUTPUT STREAM REPORT CLOSE.
  END.
  OUTPUT CLOSE.
   

  CASE s-salida-impresion:
      WHEN 1 OR WHEN 3 THEN DO:
          RUN LIB/W-README.R(s-print-file).
          IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
      END.
  END CASE.

  

  /* SE ENVIA AL ALMACEN */
  RUN Control-de-Impresion.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir-ordenes-masa B-table-Win 
PROCEDURE imprimir-ordenes-masa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR lSectoresImprimir AS CHAR.
DEFINE VAR lTodosLosSectores AS CHAR.

RUN bin/_prnctr.p.
IF s-salida-impresion = 0 THEN RETURN.

DEFINE VAR iTCont AS INT.
DEFINE VAR lCodDoc AS CHAR.
DEFINE VAR lNroPed AS CHAR.
DEFINE VAR iCont AS INT.

DO WITH FRAME {&FRAME-NAME}:
    /*DO iCont = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:*/
    iTCont = {&BROWSE-NAME}:NUM-SELECTED-ROWS.
    DO iCont = 1 TO iTCont :
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(icont) THEN DO:

                lcoddoc = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.coddoc.
                lNroPed = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nroped.

                RUN capturar-sectores(INPUT lCoddoc, lNroPed, 
                                      OUTPUT lSectoresImprimir, 
                                      OUTPUT lTodosLosSectores).

                RUN ue-imprimir-subordenes(INPUT lSectoresImprimir, INPUT lTodosLosSectores, INPUT 2).


        END.
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime B-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF Faccpedi.FlgImpOD = NO THEN DO:
      FIND CURRENT FacCPedi EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Faccpedi THEN DO:
          RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
          RETURN.
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* Impresión por Zonas y Ubicaciones */
  DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

  RUN lib/Imprimir2.
  IF s-salida-impresion = 0 THEN RETURN.

  RUN Carga-Temporal-Rb.

  FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccpedi THEN RETURN.

  IF s-salida-impresion = 1 THEN 
      s-print-file = SESSION:TEMP-DIRECTORY +
      STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

  DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
      CASE s-salida-impresion:
          WHEN 1 OR WHEN 3 THEN
              OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 30.
          WHEN 2 THEN
              OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 30. /* Impresora */
      END CASE.
      PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(33) + {&Prn4} .
      RUN Formato-Rb.
      PAGE STREAM REPORT.
      OUTPUT STREAM REPORT CLOSE.
  END.
  OUTPUT CLOSE.

  CASE s-salida-impresion:
      WHEN 1 OR WHEN 3 THEN DO:
          RUN LIB/W-README.R(s-print-file).
          IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
      END.
  END CASE.


  IF FacCPedi.FlgImpOD = NO 
      THEN ASSIGN
            FacCPedi.FlgImpOD = YES
            FacCPedi.UsrImpOD = s-user-id
            FacCPedi.FchImpOD = DATETIME(TODAY, MTIME).
  FIND CURRENT Faccpedi NO-LOCK NO-ERROR.

  RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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
  RUN Carga-Temporal.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE muestra-totales B-table-Win 
PROCEDURE muestra-totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lTotOrd AS INT INIT 0.
DEFINE VAR ltotPeso AS DEC INIT 0.
DEFINE VAR lTotSku AS INT INIT 0.
    
GET FIRST {&BROWSE-NAME}.
DO  WHILE AVAILABLE ordenes:
    lTotOrd = lTotOrd + 1.
    lTotPeso = lTotPeso + ordenes.libre_d01.
    lTotSku = lTotSku + ordenes.libre_d02.
    GET NEXT {&BROWSE-NAME}.
END.

/* txtTotSkus:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(lTotSku,">,>>>,>>9").     */
/* txtTotPeso:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(lTotPeso,">,>>>,>>9.99"). */
/* txtTotOrdenes:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(lTotOrd,">,>>>,>>9").  */

GET FIRST {&BROWSE-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pget-peso-items B-table-Win 
PROCEDURE pget-peso-items :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pPeso AS DEC.
DEFINE OUTPUT PARAMETER pItems AS INT.

DEFINE VAR lPeso AS DEC.
DEFINE VAR lItems AS INT.

DEFINE BUFFER b-vtaddocu FOR vtaddocu.

lPeso = 0.
lItems = 0.

FOR EACH b-vtaddocu OF vtacdocu NO-LOCK,
    FIRST almmmatg OF b-vtaddocu NO-LOCK :
    lItems = lItems + 1.
    IF almmmatg.pesmat <> ? AND almmmatg.pesmat > 0 THEN DO:
        lPeso = lPeso + (b-vtaddocu.canped * almmmatg.pesmat).
    END.       
END.
RELEASE b-vtaddocu.

pPeso = lpeso.
pItems = lItems.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sort-acumulativo B-table-Win 
PROCEDURE sort-acumulativo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETE pSortAcumulativo AS LOG.

x-sort-acumulativo = pSortAcumulativo.
x-sort-color-reset = YES.
x-sort-column = "".

DEFINE VAR n_cols_browse AS INT NO-UNDO.
DEFINE VAR n_celda AS WIDGET-HANDLE NO-UNDO.

DO WITH FRAME {&FRAME-NAME}.
    DO n_cols_browse = 1 TO br_table:NUM-COLUMNS.
        n_celda = br_table:GET-BROWSE-COLUMN(n_cols_browse).
        n_celda:COLUMN-BGCOLOR = 15.
    END.        
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-cargar-data-a-imprimir B-table-Win 
PROCEDURE ue-cargar-data-a-imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pListaSectoresImprimir AS CHAR.
DEFINE INPUT PARAMETER pFaccpedi_coddoc AS CHAR.
DEFINE INPUT PARAMETER pFaccpedi_nroped AS CHAR.

EMPTY TEMP-TABLE Reporte.
EMPTY TEMP-TABLE tt-subordenes.

SESSION:SET-WAIT-STATE('GENERAL').

FOR EACH VtaCDocu WHERE VtaCDocu.codcia = s-codcia AND 
        VtaCDocu.codped = pfaccpedi_coddoc AND 
        ENTRY(1,VtaCDocu.nroped,"-") = pfaccpedi_nroped AND
        LOOKUP(ENTRY(2,VtaCDocu.nroped,"-"),pListaSectoresImprimir) > 0
        NO-LOCK:

    FOR EACH VtaDDocu OF VtaCDocu NO-LOCK,
        FIRST Almmmatg NO-LOCK WHERE Almmmatg.CodCia = VtaDDocu.CodCia
        AND Almmmatg.CodMat = VtaDDocu.CodMat:
        FIND FIRST Almckits OF VtaDDocu NO-LOCK NO-ERROR.
        IF AVAILABLE Almckits THEN NEXT.
        FIND Reporte WHERE Reporte.CodMat = VtaDDocu.codmat NO-ERROR.
        IF NOT AVAILABLE Reporte THEN CREATE Reporte.
        ASSIGN 
            Reporte.CodDoc = VtaCDocu.CodPed
            Reporte.NroPed = VtaCDocu.NroPed
            Reporte.CodRef = VtaCDocu.CodRef
            Reporte.NroRef = VtaCDocu.NroRef
            Reporte.CodMat = VtaDDocu.CodMat
            Reporte.DesMat = Almmmatg.DesMat
            Reporte.DesMar = Almmmatg.DesMar
            Reporte.UndBas = Almmmatg.UndBas
            Reporte.CanPed = Reporte.CanPed + ( VtaDDocu.CanPed * VtaDDocu.Factor )
            Reporte.CodAlm = VtaCDocu.CodAlm
            Reporte.CodUbi = "G-0"
            Reporte.CodZona = "G-0"
            Reporte.x-peso = almmmatg.pesmat
            Reporte.x-empaque = fGen-Empaques(Reporte.CanPed)
            Reporte.EmpaqEspec = VtaCDocu.EmpaqEspec
            .
        FIND FIRST Almmmate WHERE Almmmate.CodCia = VtaCDocu.CodCia
            AND Almmmate.CodAlm = VtaDDocu.AlmDes
            AND Almmmate.CodMat = VtaDDocu.CodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN DO:
            ASSIGN 
                Reporte.CodUbi = Almmmate.CodUbi.
            FIND Almtubic WHERE Almtubic.codcia = s-codcia
                AND Almtubic.codubi = Almmmate.codubi
                AND Almtubic.codalm = Almmmate.codalm
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtubic THEN Reporte.CodZona = Almtubic.CodZona.
        END.    
        /* para la actualizacion */
        FIND FIRST tt-subordenes WHERE tt-subordenes.coddoc = vtacdocu.codped AND 
                                        tt-subordenes.nroped = vtacdocu.nroped NO-ERROR.
        IF NOT AVAILABLE tt-subordenes THEN DO:
            CREATE tt-subordenes.
                ASSIGN  tt-subordenes.coddoc = vtacdocu.codped
                        tt-subordenes.nroped = vtacdocu.nroped.
        END.
    END.
    /* SOLO KITS */
    FOR EACH VtaDDocu OF VtaCDocu NO-LOCK,
        FIRST Almckits OF VtaDDocu NO-LOCK,
        EACH Almdkits OF Almckits NO-LOCK,
        FIRST Almmmatg NO-LOCK WHERE Almmmatg.CodCia = VtaCDocu.CodCia
        AND Almmmatg.CodMat = AlmDKits.codmat2:
        FIND Reporte WHERE Reporte.codmat = AlmDKits.codmat2 no-error. /*VtaDDocu.codmat NO-ERROR*/
        IF NOT AVAILABLE Reporte THEN CREATE Reporte.
        ASSIGN 
            Reporte.CodDoc = VtaCDocu.CodPed
            Reporte.NroPed = VtaCDocu.NroPed
            Reporte.CodRef = VtaCDocu.CodRef
            Reporte.NroRef = VtaCDocu.NroRef
            Reporte.CodMat = Almmmatg.CodMat
            Reporte.DesMat = TRIM(Almmmatg.DesMat) + ' (KIT ' + TRIM(Vtaddocu.codmat) + ')'
            Reporte.DesMar = Almmmatg.DesMar
            Reporte.UndBas = Almmmatg.UndBas
            Reporte.CanPed = Reporte.CanPed + ( VtaDDocu.CanPed * VtaDDocu.Factor *  AlmDKits.Cantidad )
            Reporte.CodAlm = VtaCDocu.CodAlm
            Reporte.CodUbi = "G-0"
            Reporte.CodZona = "G-0"
            Reporte.x-peso = almmmatg.pesmat
            Reporte.x-empaque = fGen-Empaques(Reporte.CanPed)
            Reporte.EmpaqEspec = VtaCDocu.EmpaqEspec
            .
        FIND FIRST Almmmate WHERE Almmmate.CodCia = VtaCDocu.CodCia
            AND Almmmate.CodAlm = VtaDDocu.AlmDes
            AND Almmmate.CodMat = Almmmatg.CodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN DO:
            ASSIGN 
                Reporte.CodUbi = Almmmate.CodUbi.
            FIND Almtubic WHERE Almtubic.codcia = s-codcia
                AND Almtubic.codubi = Almmmate.codubi
                AND Almtubic.codalm = Almmmate.codalm
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtubic THEN Reporte.CodZona = Almtubic.CodZona.
        END.

        /* para la actualizacion */
        FIND FIRST tt-subordenes WHERE tt-subordenes.coddoc = vtacdocu.codped AND 
                                        tt-subordenes.nroped = vtacdocu.nroped NO-ERROR.
        IF NOT AVAILABLE tt-subordenes THEN DO:
            CREATE tt-subordenes.
                ASSIGN  tt-subordenes.coddoc = vtacdocu.codped
                        tt-subordenes.nroped = vtacdocu.nroped.
        END.
    END.
END.

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-cargar-w-report B-table-Win 
PROCEDURE ue-cargar-w-report :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pTotalSectores AS CHAR.

REPEAT:
    s-task-no = RANDOM(1, 999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no
                    /*AND w-report.llave-c = x-nrodoc*/ NO-LOCK)
        THEN DO:
        /*
        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no
            w-report.llave-c = x-nrodoc.
        */
        LEAVE.
    END.
END.

DEFINE VAR lPeso AS DEC.
DEFINE VAR lItems AS INT.
DEFINE VAR lNoItm AS INT.
DEFINE VAR x-direccion AS CHAR INIT "".
DEFINE VAR lxGlosa AS CHAR INIT "".
DEFINE VAR lSeqSector AS INT.

DEFINE VAR lTipoDocBarra AS CHAR.

FIND FIRST facdocum WHERE facdocum.codcia = s-codcia AND
                        facdocum.coddoc = reporte.coddoc
                        NO-LOCK NO-ERROR.
IF NOT AVAILABLE facdocum THEN DO:
    MESSAGE "Tipo Documento para el Codigo de Barra no existe".
    RETURN.
END.
lTipoDocbarra = TRIM(facdocum.codcta[8]).

lSeqSector = 0.
FOR EACH Reporte BREAK BY reporte.nroped BY Reporte.codubi:

    IF FIRST-OF(reporte.nroped) THEN DO:
        lPeso = 0.
        lNoItm = 0.
        lItems = 0.
        lSeqSector = lSeqSector + 1.

        FIND FIRST VtaCDocu WHERE VtaCDocu.codcia = s-codcia AND 
                                    VtaCDocu.codped = reporte.coddoc AND 
                                    VtaCDocu.nroped = reporte.nroped NO-LOCK NO-ERROR.

        RUN pget-peso-items(OUTPUT lPeso, OUTPUT lItems).

        FIND gn-divi OF VtaCDocu NO-LOCK NO-ERROR.
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = VtaCDocu.codcli NO-LOCK NO-ERROR.
        FIND gn-ven OF VtaCDocu NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            x-Direccion = if( AVAILABLE gn-clie) THEN gn-clie.dircli ELSE "". 
            FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
            IF AVAILABLE TabDepto THEN DO:
                x-Direccion = TRIM(x-Direccion) + " - " + TRIM(TabDepto.NomDepto).
                FIND TabProvi WHERE TabProvi.CodDepto = gn-clie.CodDept 
                    AND TabProvi.CodProvi = gn-clie.CodProv
                    NO-LOCK NO-ERROR.
                IF AVAILABLE TabProvi THEN DO:
                    x-Direccion = x-Direccion + ' - '+ TRIM(TabProvi.NomProvi).
                    FIND TabDistr WHERE TabDistr.CodDepto = gn-clie.CodDept
                        AND TabDistr.CodProvi = gn-clie.CodProv
                        AND TabDistr.CodDistr = gn-clie.CodDist
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE TabDistr THEN x-Direccion = x-Direccion + ' - ' + TabDistr.NomDistr.
                END.
            END.
        END.
        lxGlosa = VtaCDocu.glosa.

        IF VtaCDocu.codped = 'OTR' THEN DO:
            x-direccion = VtaCDocu.dircli.

            /* Glosa desde las SOLICTUDES DE R/A  */
            DEFINE VAR lxSer AS INT.
            DEFINE VAR lxNroDcto AS INT.

            IF VtaCDocu.glosa = ? OR VtaCDocu.glosa = '' THEN DO:
                IF VtaCDocu.codref = 'R/A' THEN DO:
                    lxSer = INT(SUBSTRING(VtaCDocu.nroref,1,3)).
                    lxNroDcto = INT(SUBSTRING(VtaCDocu.nroref,4)).

                    FIND FIRST almcrepo WHERE almcrepo.codcia = s-codcia AND 
                                                almcrepo.codalm = VtaCDocu.codcli AND 
                                                almcrepo.nroser = lxSer AND 
                                                almcrepo.nrodoc = lxNroDcto NO-LOCK NO-ERROR.
                    IF AVAILABLE almcrepo THEN DO:
                        lxGlosa = almcrepo.glosa.
                    END.
                END.
            END.
        END.
    END.
    
    /* -------------------------------------------------------------*/
    lNoItm = lNoItm + 1.
    CREATE w-report.
    ASSIGN
        w-report.task-no = s-task-no
        w-report.llave-c = reporte.nroped
        w-report.campo-c[20] = "*" + lTipoDocbarra + TRIM(reporte.Nroped) + "*". /* BARRA */
        w-report.campo-c[21] = "Sector " + ENTRY(2,VtaCDocu.Nroped,"-") + 
                                " de " + pTotalSectores.
        w-report.campo-c[21] = "Sector " + STRING(lSeqSector) + " de " + 
                                STRING (NUM-ENTRIES(pTotalSectores)).        

        /* Cabecera */
        ASSIGN  w-report.campo-c[6] = reporte.Coddoc + " " + reporte.Nroped
                w-report.campo-c[7] = "Nro. " + VtaCDocu.CodRef + " " + VtaCDocu.NroRef
                w-report.campo-c[8] = "ORIGEN   : " + if(AVAILABLE gn-divi) THEN gn-divi.desdiv ELSE ""
                w-report.campo-c[9] = "Nro. DE ITEMS : " + string(lItems,">>>,>>9")
                w-report.campo-c[10] = "F." + IF(VtaCDocu.codped='OTR') THEN "DESPACHO :" ELSE "ENTREGA :"
                w-report.campo-c[10] = w-report.campo-c[10] + STRING(VtaCDocu.Fchent,"99/99/9999")
                w-report.campo-c[11] = IF(VtaCDocu.codped='OTR') THEN "" ELSE IF (AVAILABLE gn-ven) THEN ("VENDEDOR : " + gn-ven.nomven) ELSE ""
                w-report.campo-c[12] = "PESO :" + STRING(lPeso,"-ZZ,ZZZ,ZZ9.99")
                w-report.campo-c[13] = IF(VtaCDocu.Codped = 'OTR') THEN "DESTINO  : " ELSE "CLIENTE   : "
                w-report.campo-c[13] = w-report.campo-c[13] + IF(VtaCDocu.Codped = 'OTR') THEN VtaCDocu.Codcli + " " ELSE ""
                w-report.campo-c[13] = w-report.campo-c[13] + VtaCDocu.nomcli
                w-report.campo-c[14] = "Direccion   : " + x-direccion
                w-report.campo-c[15] = "Observacion : " + lxGlosa
                w-report.campo-c[16] = (IF vtacdocu.codped = "ODC" THEN "CONSOLIDADA" ELSE "").
        ASSIGN
            w-report.Campo-L[1] = Reporte.EmpaqEspec.
        /* Detalle */
        ASSIGN  w-report.campo-i[1] = lNoItm
                w-report.campo-c[1] = Reporte.CodMat
                w-report.campo-c[2] = Reporte.DesMat
                w-report.campo-c[3] = Reporte.DesMar
                w-report.campo-c[4] = Reporte.UndBas
                w-report.campo-f[1] = Reporte.CanPed
                w-report.campo-c[5] = Reporte.CodUbi
                w-report.campo-c[22] = Reporte.x-empaques.

        /*MESSAGE Reporte.CodMat Reporte.CodUbi Reporte.CodZona.*/

END.

IF AVAILABLE VtacDocu THEN DO:
    lNoItm = lNoItm + 1.
    CREATE w-report.
    ASSIGN
        w-report.task-no = s-task-no
        w-report.llave-c = VtaCDocu.nroped + "XXX"
        w-report.campo-c[6] = VtaCDocu.Codped + " " + VtaCDocu.Nroped
        w-report.campo-i[1] = lNoItm.

    DELETE w-report.

END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-envia-txt-detalle B-table-Win 
PROCEDURE ue-envia-txt-detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-Archivo AS CHAR.
DEFINE VAR x-rpta AS LOG.

x-Archivo = 'PagSinIngreso.txt'.
SYSTEM-DIALOG GET-FILE x-Archivo
FILTERS 'Texto' '*.txt'
ASK-OVERWRITE
CREATE-TEST-FILE
DEFAULT-EXTENSION '.txt'
INITIAL-DIR 'c:\tmp'
RETURN-TO-START-DIR 
USE-FILENAME
SAVE-AS
UPDATE x-rpta.
IF x-rpta = NO THEN RETURN.

OUTPUT STREAM REPORTE TO VALUE(x-Archivo).

PUT STREAM REPORTE
    "Codigo|"
    "Numero|"
    "Emision|"
    "Hora|"
    "Origen|"
    "Cliente|"
    "Impreso por|"
    "Fecha/Hora Impresion|"
    "Fecha/Hora Distribucion|"
    "Items|"
    "Glosa|"
    "De Venta a Almacén|"
    "De Almacén a Distribución|"
    "De Venta a Distribución|"
    "Fech.Entrega|"
    "Peso|"
    "Articulo|"
    "Descripcion|"
    "Peso Unit|"
    "Marca|"
    "Cantidad|"
    "Unidad|"
    "Almacen|"
    "Zona|"
    "Ubicacion|"
    "Peso Tot|"
    "Usuario envio a Distribucion|"
    "Nombre Usuario" SKIP.

DEFINE VAR lNomUser AS CHAR.
DEFINE VAR lCodUser AS CHAR.
DEFINE VAR iCount1 AS INT.

DEFINE VARIABLE lsFechaEmision          AS CHARACTER.
DEFINE VARIABLE lsHoraEmision           AS CHARACTER.

DEFINE VARIABLE ldtFechaEmision         AS DATETIME.
DEFINE VARIABLE ldtFechaDistribucion    AS DATETIME.
DEFINE VARIABLE lsDifTempo_VtaAlm       AS CHARACTER.
DEFINE VARIABLE lsDifTempo_AlmDist      AS CHARACTER.
DEFINE VARIABLE lsDifTempo_VtaDist      AS CHARACTER.

DEFINE VAR lPeso AS DEC.

GET FIRST {&BROWSE-NAME}.
DO  WHILE AVAILABLE faccpedi:
    iCount1 = 0.
    FOR EACH facdpedi OF faccpedi NO-LOCK:
       iCount1 = iCount1 + 1.
    END.
    FOR EACH facdpedi OF faccpedi NO-LOCK :        
        lsFechaEmision = STRING(faccpedi.fchped, '99-99-9999').
        lsHoraEmision  = faccpedi.hora.

        ldtFechaEmision      = DATETIME(lsFechaEmision + ' ' + lsHoraEmision).
        ldtFechaDistribucion = DATETIME(IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1) THEN ENTRY(2,Faccpedi.Libre_c03,'|') ELSE "").

        RUN lib\_time-passed.p (ldtFechaEmision, faccpedi.fchimpod, OUTPUT lsDifTempo_VtaAlm).
        RUN lib\_time-passed.p (faccpedi.fchimpod, ldtFechaDistribucion, OUTPUT lsDifTempo_AlmDist).
        RUN lib\_time-passed.p (ldtFechaEmision, ldtFechaDistribucion, OUTPUT lsDifTempo_VtaDist).

        lPeso = fPeso().

        /* Detalle */
        FIND FIRST almmmatg OF facdpedi NO-LOCK NO-ERROR.

        DEFINE VAR lUbicacion AS CHAR.
        DEFINE VAR lZona AS CHAR.
        lUbicacion = ''.
        lZona = ''.
        FIND FIRST Almmmate WHERE Almmmate.CodCia = FacDPedi.CodCia
            AND Almmmate.CodAlm = FacDPedi.AlmDes
            AND Almmmate.codmat = FacDPedi.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN DO:
            FIND FIRST almtubic OF Almmmate NO-LOCK NO-ERROR.
            IF AVAILABLE almtubic THEN lZona = almtubic.CodZona.
            lUbicacion = Almmmate.CodUbi.
        END.

        lCodUser = IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 2) THEN ENTRY(3,Faccpedi.Libre_c03,'|') ELSE "".
        lNomUser = fPersonal(lCodUser).

        PUT STREAM REPORT
                faccpedi.coddoc "|"
                faccpedi.nroped "|"
                faccpedi.fchped "|"
                faccpedi.hora "|"
                gn-divi.desdiv "|"
                faccpedi.nomcli "|"
                faccpedi.usrimpod  "|"
                faccpedi.fchimpod "|"
                IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1) THEN ENTRY(2,Faccpedi.Libre_c03,'|') ELSE ""  "|"
                iCount1 "|"
                faccpedi.glosa "|"
                lsDifTempo_VtaAlm "|"
                lsDifTempo_AlmDist "|"
                lsDifTempo_VtaDist "|"
                faccpedi.fchent "|"
                lpeso "|"
                facdpedi.codmat "|"
                almmmatg.desmat "|"
                almmmatg.pesmat "|"
                almmmatg.desmar "|"
                facdpedi.canped "|"
                facdpedi.undvta "|"
                facdpedi.almdes "|"
                lzona "|"
                lUbicacion "|"
                (FacDPedi.CanPed * Almmmatg.Pesmat ) "|"
                IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 2) THEN ENTRY(3,Faccpedi.Libre_c03,'|') ELSE ""  "|"
                lNomUser SKIP.

    END.
END.
/*
FOR EACH tmp-datos:
  PUT STREAM REPORT
      tmp-datos.codalm "|"
      tmp-datos.desalm "|"
      tmp-datos.nropag "|"
      tmp-datos.codres SKIP.
END.
*/
OUTPUT STREAM REPORTE CLOSE.
MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.


/* -------------------------------------------------------------------------- */
/*
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE x-signo                 AS DECI.

DEFINE VARIABLE lsFechaEmision          AS CHARACTER.
DEFINE VARIABLE lsHoraEmision           AS CHARACTER.

DEFINE VARIABLE ldtFechaEmision         AS DATETIME.
DEFINE VARIABLE ldtFechaDistribucion    AS DATETIME.
DEFINE VARIABLE lsDifTempo_VtaAlm       AS CHARACTER.
DEFINE VARIABLE lsDifTempo_AlmDist      AS CHARACTER.
DEFINE VARIABLE lsDifTempo_VtaDist      AS CHARACTER.

DEFINE VAR lPeso AS DEC.

SESSION:SET-WAIT-STATE('GENERAL').

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = FALSE.

/* Para crear a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */

chWorkSheet:Range("A1:R1"):Font:Bold = TRUE.
chWorkSheet:Range("A1"):Value = "Codigo".
chWorkSheet:Range("B1"):Value = "Numero".
chWorkSheet:COLUMNS("B"):NumberFormat = "@".
chWorkSheet:Range("C1"):Value = "Emision".
chWorkSheet:COLUMNS("C"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("D1"):Value = "Hora".
chWorkSheet:Range("E1"):Value = "Origen".
chWorkSheet:COLUMNS("E"):NumberFormat = "@".
chWorkSheet:Range("F1"):Value = "Cliente".
chWorkSheet:COLUMNS("F"):NumberFormat = "@".
chWorkSheet:Range("G1"):Value = "Impreso por".
chWorkSheet:Range("H1"):Value = "Fecha/Hora Impresion".
chWorkSheet:Range("I1"):Value = "Fecha/Hora Distribucion".      /* Nueva columna */
chWorkSheet:Range("J1"):Value = "Items".
chWorkSheet:Range("K1"):Value = "Glosa".
chWorkSheet:Range("L1"):Value = "De Venta a Almacén".      /* Nueva columna */
chWorkSheet:Range("M1"):Value = "De Almacén a Distribución".      /* Nueva columna */
chWorkSheet:Range("N1"):Value = "De Venta a Distribución".      /* Nueva columna */
chWorkSheet:Range("O1"):Value = "Fech.Entrega".      /* Nueva columna */
chWorkSheet:COLUMNS("O"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("P1"):Value = "Peso".      /* Nueva columna */
chWorkSheet:Range("Q1"):Value = "Articulo".
chWorkSheet:COLUMNS("Q"):NumberFormat = "@".
chWorkSheet:Range("R1"):Value = "Descripcion".
chWorkSheet:Range("S1"):Value = "Peso Unit".
chWorkSheet:Range("T1"):Value = "Marca".
chWorkSheet:Range("U1"):Value = "Cantidad".
chWorkSheet:Range("V1"):Value = "Unidad".
chWorkSheet:Range("W1"):Value = "Almacen".
chWorkSheet:COLUMNS("W"):NumberFormat = "@".
chWorkSheet:Range("X1"):Value = "Zona".
chWorkSheet:Range("Y1"):Value = "Ubicacion".
chWorkSheet:Range("z1"):Value = "Peso Tot".
chWorkSheet:Range("AA1"):Value = "Usuario envio a Distribucion".
chWorkSheet:Range("AB1"):Value = "Nombre Usuario".

iColumn = 1.

DEFINE VAR lNomUser AS CHAR.
DEFINE VAR lCodUser AS CHAR.

GET FIRST {&BROWSE-NAME}.
DO  WHILE AVAILABLE faccpedi:
    iCount = 0.
    FOR EACH facdpedi OF faccpedi NO-LOCK:
       iCount = iCount + 1.
    END.
    FOR EACH facdpedi OF faccpedi NO-LOCK :        
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).

        chWorkSheet:Range("A" + cColumn):Value = faccpedi.coddoc.
        chWorkSheet:Range("B" + cColumn):Value = faccpedi.nroped.             
        chWorkSheet:Range("C" + cColumn):Value = faccpedi.fchped.             
        chWorkSheet:Range("D" + cColumn):Value = faccpedi.hora.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = gn-divi.desdiv.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.nomcli.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.usrimpod.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.fchimpod.

        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1) THEN ENTRY(2,Faccpedi.Libre_c03,'|') ELSE "".

        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = iCount.

        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = faccpedi.glosa.


        lsFechaEmision = STRING(faccpedi.fchped, '99-99-9999').
        lsHoraEmision  = faccpedi.hora.

        ldtFechaEmision      = DATETIME(lsFechaEmision + ' ' + lsHoraEmision).
        ldtFechaDistribucion = DATETIME(IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 1) THEN ENTRY(2,Faccpedi.Libre_c03,'|') ELSE "").

        RUN lib\_time-passed.p (ldtFechaEmision, faccpedi.fchimpod, OUTPUT lsDifTempo_VtaAlm).
        RUN lib\_time-passed.p (faccpedi.fchimpod, ldtFechaDistribucion, OUTPUT lsDifTempo_AlmDist).
        RUN lib\_time-passed.p (ldtFechaEmision, ldtFechaDistribucion, OUTPUT lsDifTempo_VtaDist).

        chWorkSheet:Range("L" + cColumn):Value = lsDifTempo_VtaAlm.
        chWorkSheet:Range("M" + cColumn):Value = lsDifTempo_AlmDist.
        chWorkSheet:Range("N" + cColumn):Value = lsDifTempo_VtaDist.
        chWorkSheet:Range("O" + cColumn):Value = faccpedi.fchent.

        lPeso = fPeso().
        chWorkSheet:Range("P" + cColumn):Value = lpeso.

        /* Detalle */
        FIND FIRST almmmatg OF facdpedi NO-LOCK NO-ERROR.
        chWorkSheet:Range("Q" + cColumn):Value = facdpedi.codmat.
        chWorkSheet:Range("R" + cColumn):Value = almmmatg.desmat.
        chWorkSheet:Range("S" + cColumn):Value = almmmatg.pesmat.
        chWorkSheet:Range("T" + cColumn):Value = almmmatg.desmar.
        chWorkSheet:Range("U" + cColumn):Value = facdpedi.canped.
        chWorkSheet:Range("V" + cColumn):Value = facdpedi.undvta.
        chWorkSheet:Range("W" + cColumn):Value = facdpedi.almdes.

        FIND FIRST Almmmate WHERE Almmmate.CodCia = FacDPedi.CodCia
            AND Almmmate.CodAlm = FacDPedi.AlmDes
            AND Almmmate.codmat = FacDPedi.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN DO:
            FIND FIRST almtubic OF Almmmate NO-LOCK NO-ERROR.
            IF AVAILABLE almtubic THEN chWorkSheet:Range("X" + cColumn):Value = almtubic.CodZona.
            chWorkSheet:Range("Y" + cColumn):Value = Almmmate.CodUbi.
        END.
        chWorkSheet:Range("Z" + cColumn):VALUE = (FacDPedi.CanPed * Almmmatg.Pesmat ).
        chWorkSheet:Range("AA" + cColumn):Value = "'" + IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 2) THEN ENTRY(3,Faccpedi.Libre_c03,'|') ELSE "".

         lCodUser = IF(NUM-ENTRIES(Faccpedi.Libre_c03,'|') > 2) THEN ENTRY(3,Faccpedi.Libre_c03,'|') ELSE "".
         lNomUser = fPersonal(lCodUser).
         cRange = "AB" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + lNomUser.

    END.
    GET NEXT {&BROWSE-NAME}.
END.

SESSION:SET-WAIT-STATE('').
    
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR. 

MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-enviar-a-impresora B-table-Win 
PROCEDURE ue-enviar-a-impresora :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RB-INCLUDE-RECORDS = "O".

RB-FILTER = " w-report.task-no = " + STRING(s-task-no).
/*
RB-FILTER = " w-report.task-no = " + STRING(s-task-no) +  
              " AND w-report.llave-c = '" + x-nrodoc + "'".

RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia +
                        "~ns-division = " + IF(AVAILABLE gn-divi) THEN gn-divi.desdiv ELSE "".
*/

DEFINE VARIABLE cDatabaseName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cHostName        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNetworkProto    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPortNumber      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cOtherParams     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNewConnString   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDelimeter       AS CHARACTER NO-UNDO.

GET-KEY-VALUE SECTION "RBParametros" KEY "cDatabaseName" VALUE cDatabaseName.
GET-KEY-VALUE SECTION "RBParametros" KEY "cHostName" VALUE cHostName.
GET-KEY-VALUE SECTION "RBParametros" KEY "cNetworkProto" VALUE cNetworkProto.
GET-KEY-VALUE SECTION "RBParametros" KEY "cPortNumber" VALUE cPortNumber.
GET-KEY-VALUE SECTION "RBParametros" KEY "cOtherParams" VALUE cOtherParams.

ASSIGN cDelimeter = CHR(32).
IF NOT (cDatabaseName = ? OR
   cHostName = ? OR
   cNetworkProto = ? OR
   cPortNumber = ?) THEN DO:

    DEFINE VAR x-rb-user AS CHAR.
    DEFINE VAR x-rb-pass AS CHAR.

    RUN lib/RB_credenciales(OUTPUT x-rb-user, OUTPUT x-rb-pass).

    IF x-rb-user = "**NOUSER**" THEN DO:
        MESSAGE "No se pudieron ubicar las credenciales para" SKIP
                "la conexion del REPORTBUILDER" SKIP
                "--------------------------------------------" SKIP
                "Comunicarse con el area de sistemas - desarrollo"
            VIEW-AS ALERT-BOX INFORMATION.

        RETURN "ADM-ERROR".
    END.

   ASSIGN
       cNewConnString =
       "-db" + cDelimeter + cDatabaseName + cDelimeter +
       "-H" + cDelimeter + cHostName + cDelimeter +
       "-N" + cDelimeter + cNetworkProto + cDelimeter +
       "-S" + cDelimeter + cPortNumber + cDelimeter +
       "-U " + x-rb-user  + cDelimeter + cDelimeter +
       "-P " + x-rb-pass + cDelimeter + cDelimeter.

   /*
   ASSIGN
       cNewConnString =
       "-db" + cDelimeter + cDatabaseName + cDelimeter +
       "-H" + cDelimeter + cHostName + cDelimeter +
       "-N" + cDelimeter + cNetworkProto + cDelimeter +
       "-S" + cDelimeter + cPortNumber + cDelimeter +
       "-U usrddigger"  + cDelimeter + cDelimeter +
       "-P udd1456" + cDelimeter + cDelimeter.
   */
   RB-DB-CONNECTION = cNewConnString.
END.

/* Motivo Reposicion Automatica */

DEFINE VAR cMotivo AS CHAR INIT "".

FIND FIRST VtaCDocu WHERE VtaCDocu.codcia = s-codcia AND 
                        VtaCDocu.codped = faccpedi.coddoc AND 
                        ENTRY(1,VtaCDocu.nroped,"-") = faccpedi.nroped                        
                        NO-LOCK NO-ERROR.
IF AVAILABLE VtaCDocu THEN DO:
    FIND FIRST Almcrepo WHERE Almcrepo.codcia = s-codcia and 
                                Almcrepo.codalm = Vtacdocu.codcli and 
                                Almcrepo.nroser = INTEGER(SUBSTRING(vtacdocu.nroref,1,3)) and 
                                Almcrepo.nrodoc = INTEGER(SUBSTRING(vtacdocu.nroref,4)) NO-LOCK NO-ERROR.
    IF AVAILABLE almcrepo THEN DO:
        FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                                    factabla.tabla = 'REPOMOTIVO' AND 
                                    factabla.codigo = vtacdocu.motrepos NO-LOCK NO-ERROR.
        IF AVAILABLE factabla THEN DO:
            cMotivo = "MOTIVO :" + factabla.codigo + " " + factabla.nombre.
        END.
    END.
END.

/* CrossDocking */
DEFINE VAR x-cross AS CHAR INIT 'NO'.
DEFINE VAR x-dstfinal AS CHAR INIT ''.

IF faccpedi.crossdocking = YES THEN DO:
    x-cross = 'SI'.

    DEFINE BUFFER xb-almacen FOR almacen.
    DEFINE BUFFER xb-gn-clie FOR gn-clie.

    x-dstfinal = TRIM(faccpedi.almacenXD).
    IF LENGTH(x-dstfinal) > 6 THEN DO:
        /* Cliente */
        FIND FIRST xb-gn-clie WHERE xb-gn-clie.codcia = 0 AND 
                                xb-gn-clie.codcli = x-dstfinal 
                                NO-LOCK NO-ERROR.
        IF AVAILABLE xb-gn-clie THEN x-dstfinal = x-dstfinal + " " + TRIM(xb-gn-clie.nomcli).
    END.
    ELSE DO:
        /* Almacen */
        FIND FIRST xb-almacen WHERE xb-almacen.codcia = s-codcia AND
                                        xb-almacen.codalm = faccpedi.almacenXD
                                        NO-LOCK NO-ERROR.
        IF AVAILABLE xb-almacen THEN x-dstfinal = x-dstfinal + " " + TRIM(xb-almacen.descripcion).
    END.
END.

RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia +
                        "~nmotrepo = " + cMotivo +
                        "~npCross = " + x-cross +
                        "~npDstFinal = " + x-dstfinal .


ASSIGN
      RB-REPORT-NAME = "impresion-subordenes"
      RB-BEGIN-PAGE = s-pagina-inicial
      RB-END-PAGE = s-pagina-final
      RB-PRINTER-NAME = s-printer-name
      RB-OUTPUT-FILE = s-print-file
      RB-NUMBER-COPIES = s-nro-copias.
  CASE s-salida-impresion:
      WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
      WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
      WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
  END CASE.
  RUN aderb/_prntrb2 (RB-REPORT-LIBRARY,
                      RB-REPORT-NAME,
                      RB-DB-CONNECTION,
                      RB-INCLUDE-RECORDS,
                      RB-FILTER,
                      RB-MEMO-FILE,
                      RB-PRINT-DESTINATION,
                      RB-PRINTER-NAME,
                      RB-PRINTER-PORT,
                      RB-OUTPUT-FILE,
                      RB-NUMBER-COPIES,
                      RB-BEGIN-PAGE,
                      RB-END-PAGE,
                      RB-TEST-PATTERN,
                      RB-WINDOW-TITLE,
                      RB-DISPLAY-ERRORS,
                      RB-DISPLAY-STATUS,
                      RB-NO-WAIT,
                      RB-OTHER-PARAMETERS,
                      "").

/* Borar el temporal */
DEF BUFFER B-w-report FOR w-report.
DEFINE VAR lRowId AS ROWID.

FOR EACH w-report WHERE w-report.task-no = s-task-no NO-LOCK:
    lRowId = ROWID(w-report).
    FIND FIRST b-w-report WHERE ROWID(b-w-report) = lRowid EXCLUSIVE NO-ERROR.
    IF AVAILABLE b-w-report THEN DO:
        DELETE b-w-report.            
    END.    
END.
RELEASE B-w-report.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-imprimir-subordenes B-table-Win 
PROCEDURE ue-imprimir-subordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pListaDeSectores-a-imprimir AS CHAR.
DEFINE INPUT PARAMETER pTotalSectores AS CHAR.
DEFINE INPUT PARAMETER pModoImpresion AS INT.   /* 1 : Solo UNO,  2 : En Masa */

RUN ue-cargar-data-a-imprimir(INPUT pListaDeSectores-a-imprimir, INPUT faccpedi.coddoc, INPUT faccpedi.nroped).

FIND FIRST reporte NO-ERROR.

IF NOT AVAILABLE reporte THEN DO:
    /* No existe data a imprimir */
    MESSAGE "No existe data a imprimir".
    RETURN .
END.

/* Actualizo datos */
DEFINE BUFFER b-vtacdocu FOR vtacdocu.
DEFINE BUFFER ic-faccpedi FOR faccpedi.

DEFINE VAR cMsgError AS CHAR NO-UNDO.

LoopActualizar:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE :
    /* Actualizo el usuario que imprimio las subordenes */
    FOR EACH tt-subordenes NO-LOCK :
        FIND FIRST b-vtacdocu WHERE b-vtacdocu.codcia = s-codcia
            AND b-vtacdocu.codped = tt-subordenes.coddoc 
            AND b-vtacdocu.nroped = tt-subordenes.nroped EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE b-vtacdocu THEN DO:
            cMsgError = 'Problemas al actualizar suborden ' + tt-subordenes.nroped + CHR(10) + 
                        "Intente de nuevo...gracias".
            UNDO LoopActualizar, LEAVE.
        END.
        IF (TRUE <> (b-vtacdocu.UsrImpOD > '')) THEN DO:
            ASSIGN 
                b-vtacdocu.FlgImpOD = YES
                b-vtacdocu.UsrImpOD = s-user-id
                b-vtacdocu.FchImpOD = DATETIME(TODAY, MTIME).
            cMsgError = "".
        END.
    END.   
    /* La O/D completa */
    IF (TRUE <> (Faccpedi.UsrImpOD > '')) THEN DO:
        FIND FIRST ic-faccpedi OF Faccpedi EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE ic-Faccpedi THEN DO:
          ASSIGN
              ic-FacCPedi.FlgImpOD = YES
              ic-FacCPedi.UsrImpOD = s-user-id
              ic-FacCPedi.FchImpOD = DATETIME(TODAY, MTIME).
        END.
        ELSE DO:
            cMsgError = 'Problemas al actualizar ' + faccpedi.coddoc + " " + faccpedi.nroped + CHR(10) +
               'Intente de nuevo....gracias'.
            UNDO LoopActualizar, LEAVE.
        END.
    END.
END.
RELEASE b-vtacdocu.
RELEASE ic-faccpedi.

IF cMsgError = "" THEN DO:
    /* Imprimir */
    RUN ue-cargar-w-report(INPUT pTotalSectores).

    IF pModoImpresion = 1 THEN DO:
        RUN bin/_prnctr.p.
        IF s-salida-impresion = 0 THEN RETURN.
    END.

    RUN ue-enviar-a-impresora.
END.
ELSE DO:
    MESSAGE cMsgError VIEW-AS ALERT-BOX ERROR.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-sectores B-table-Win 
PROCEDURE ue-sectores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE OUTPUT PARAMETER pSectores AS INT.
DEFINE OUTPUT PARAMETER pSecImp AS INT.
DEFINE OUTPUT PARAMETER pSecAsig AS INT.
DEFINE OUTPUT PARAMETER pSecDev AS INT.

DEFINE VAR nSectores AS INT INIT 0.
DEFINE VAR nSectoresImp AS INT  INIT 0.
DEFINE VAR nSectoresAsig AS INT  INIT 0.
DEFINE VAR nSectoresReto AS INT  INIT 0.
DEFINE VAR nSectoresSinAsig AS INT  INIT 0.

DEFINE VAR x-nroped AS CHAR.

x-nroped = pNroDoc + "-".

FOR EACH VtaCDocu NO-LOCK WHERE VtaCDocu.codcia = s-codcia 
    AND VtaCDocu.codped = pCodDoc 
    AND VtaCDocu.nroped BEGINS x-nroped
    AND Vtacdocu.flgest <> 'X':
    nSectores = nSectores + 1.
    IF NOT (TRUE <> (VtaCDocu.UsrImpOD > ""))   THEN DO:
        nSectoresImp = nSectoresImp + 1.
    END.
    IF NOT (TRUE <> (VtaCDocu.UsrSac > ""))   THEN DO:
        nSectoresAsig = nSectoresAsig + 1.
    END.
    IF NOT (TRUE <> (VtaCDocu.UsrSacRecep > ""))   THEN DO:
        nSectoresReto = nSectoresReto + 1.
    END.
END.

pSectores = nSectores.
pSecImp = nSectoresImp.
pSecAsig = nSectoresAsig.
pSecDev = nSectoresReto.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um-get-guias-rutas B-table-Win 
PROCEDURE um-get-guias-rutas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-CodDoc AS CHAR    NO-UNDO.
DEFINE INPUT PARAMETER p-NroDoc AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER p-RetVal AS CHAR.

DEFINE BUFFER i-faccpedi FOR faccpedi.
DEFINE BUFFER i-ccbcdocu FOR ccbcdocu.

DEFINE VAR lRetVal AS CHAR INIT ''.

/*FIND FIRST i-faccpedi WHERE ROWID(i-faccpedi) = p-RowId NO-LOCK NO-ERROR.*/
FIND FIRST i-faccpedi WHERE i-faccpedi.codcia = s-codcia AND 
                            i-faccpedi.coddoc = p-CodDoc AND
                             i-faccpedi.nroped = p-NroDoc NO-LOCK NO-ERROR.
IF AVAILABLE i-faccpedi THEN DO:
    /* Guias de la orden de despacho */
    IF i-faccpedi.coddoc = 'O/D' THEN DO:
        FOR EACH i-ccbcdocu USE-INDEX llave15 WHERE i-ccbcdocu.codcia = s-codcia AND 
                                i-ccbcdocu.codped = i-faccpedi.codref AND 
                                i-ccbcdocu.nroped = i-faccpedi.nroref AND 
                                i-ccbcdocu.flgest <> 'A' NO-LOCK :
            IF i-ccbcdocu.coddoc = 'G/R' AND 
                i-ccbcdocu.libre_c01 = i-faccpedi.coddoc AND 
                i-ccbcdocu.libre_c02 = i-faccpedi.nroped THEN DO:

                IF lRetVal <> '' THEN lRetVal = lRetVal + ", ".
                lRetVal = lRetVal + i-ccbcdocu.coddoc + "-" +  i-ccbcdocu.nrodoc.
                /* Hoja de Ruta */
                /*
                FIND FIRST di-rutaD USE-INDEX llave02 WHERE di-rutaD.codcia = s-codcia AND 
                                            di-rutaD.coddoc = 'H/R' AND 
                                            di-rutaD.codref = i-ccbcdocu.coddoc AND 
                                            di-rutaD.nroref = i-ccbcdocu.nrodoc NO-LOCK NO-ERROR.
                IF AVAILABLE di-rutaD THEN DO:
                    lRetVal = lRetVal + "  H/R-" + di-rutaD.nrodoc.
                END.
                */
            END.
        END.
    END.

    /* Guias de Transferencias */
    IF i-faccpedi.coddoc = 'OTR' THEN DO:
        FOR EACH almcmov WHERE almcmov.codcia = s-codcia AND 
                                almcmov.codref = 'OTR' AND 
                                almcmov.nroref = i-faccpedi.nroped AND
                                almcmov.flgest <> 'A' NO-LOCK :
            IF lRetVal <> '' THEN lRetVal = lRetVal + ", ".
            lRetVal = lRetVal + "G/R" + "-" + STRING(almcmov.nroser,"999") + STRING(almcmov.nrodoc,"999999").
            /*
            FIND FIRST di-rutaG WHERE DI-RutaG.codcia  = almcmov.codcia  AND                 
                                di-rutaG.codalm = almcmov.codalm  AND
                                di-rutaG.tipmov = almcmov.tipmov AND
                                di-rutaG.codmov = almcmov.codmov AND                                
                                di-rutaG.serref = almcmov.nroser AND
                                di-rutaG.nroref = almcmov.nrodoc NO-LOCK NO-ERROR.
            IF AVAILABLE di-rutaG THEN DO:
                lRetVal = lRetVal + "  H/R-" + di-rutaG.nrodoc.
            END.
            */
        END.
    END.
END.

p-RetVal = lRetVal.

RELEASE i-faccpedi.
RELEASE i-ccbcdocu.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um-get-rutas B-table-Win 
PROCEDURE um-get-rutas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-CodDoc AS CHAR    NO-UNDO.
DEFINE INPUT PARAMETER p-NroDoc AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER p-RetVal AS CHAR.

DEFINE BUFFER i-faccpedi FOR faccpedi.
DEFINE BUFFER i-ccbcdocu FOR ccbcdocu.

DEFINE VAR lRetVal AS CHAR INIT ''.

/*FIND FIRST i-faccpedi WHERE ROWID(i-faccpedi) = p-RowId NO-LOCK NO-ERROR.*/
FIND FIRST i-faccpedi WHERE i-faccpedi.codcia = s-codcia AND 
                            i-faccpedi.coddoc = p-CodDoc AND
                             i-faccpedi.nroped = p-NroDoc NO-LOCK NO-ERROR.
IF AVAILABLE i-faccpedi THEN DO:
    /* Guias de la orden de despacho */
    IF i-faccpedi.coddoc = 'O/D' THEN DO:
        FOR EACH i-ccbcdocu USE-INDEX llave15 WHERE i-ccbcdocu.codcia = s-codcia AND 
                                i-ccbcdocu.codped = i-faccpedi.codref AND 
                                i-ccbcdocu.nroped = i-faccpedi.nroref AND 
                                i-ccbcdocu.flgest <> 'A' NO-LOCK :
            IF i-ccbcdocu.coddoc = 'G/R' AND 
                i-ccbcdocu.libre_c01 = i-faccpedi.coddoc AND 
                i-ccbcdocu.libre_c02 = i-faccpedi.nroped THEN DO:

                /*IF lRetVal <> '' THEN lRetVal = lRetVal + ", ".*/
                /*lRetVal = lRetVal + i-ccbcdocu.coddoc + "-" +  i-ccbcdocu.nrodoc.*/
                /* Hoja de Ruta */
                FIND FIRST di-rutaD USE-INDEX llave02 WHERE di-rutaD.codcia = s-codcia AND 
                                            di-rutaD.coddoc = 'H/R' AND 
                                            di-rutaD.codref = i-ccbcdocu.coddoc AND 
                                            di-rutaD.nroref = i-ccbcdocu.nrodoc NO-LOCK NO-ERROR.
                IF AVAILABLE di-rutaD THEN DO:
                    IF lRetVal <> '' THEN lRetVal = lRetVal + ", ".
                    lRetVal = lRetVal + di-rutaD.nrodoc.
                END.
            END.
        END.
    END.

    /* Guias de Transferencias */
    IF i-faccpedi.coddoc = 'OTR' THEN DO:
        FOR EACH almcmov WHERE almcmov.codcia = s-codcia AND 
                                almcmov.codref = 'OTR' AND 
                                almcmov.nroref = i-faccpedi.nroped AND
                                almcmov.flgest <> 'A' NO-LOCK :
            /*
            IF lRetVal <> '' THEN lRetVal = lRetVal + ", ".
            lRetVal = lRetVal + "G/R" + "-" + STRING(almcmov.nroser,"999") + STRING(almcmov.nrodoc,"999999").
            */

            FIND FIRST di-rutaG WHERE DI-RutaG.codcia  = almcmov.codcia  AND                 
                                di-rutaG.codalm = almcmov.codalm  AND
                                di-rutaG.tipmov = almcmov.tipmov AND
                                di-rutaG.codmov = almcmov.codmov AND                                
                                di-rutaG.serref = almcmov.nroser AND
                                di-rutaG.nroref = almcmov.nrodoc NO-LOCK NO-ERROR.
            IF AVAILABLE di-rutaG THEN DO:
                IF lRetVal <> '' THEN lRetVal = lRetVal + ", ".
                lRetVal = lRetVal + di-rutaG.nrodoc.
            END.

        END.
    END.
END.

p-RetVal = lRetVal.

RELEASE i-faccpedi.
RELEASE i-ccbcdocu.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDestinoFinal B-table-Win 
FUNCTION fDestinoFinal RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF Faccpedi.CrossDocking = YES THEN DO:
      FIND Almacen WHERE Almacen.CodCia = s-codcia AND
          Almacen.CodAlm = FacCPedi.AlmacenXD NO-LOCK NO-ERROR.
      IF AVAILABLE Almacen THEN RETURN Almacen.Descripcion.
      FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND
          gn-clie.codcli = FacCPedi.AlmacenXD NO-LOCK NO-ERROR.
      IF AVAILABLE gn-clie THEN RETURN gn-clie.nomcli.
  END.
  RETURN "".   /* Function return value. */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fgen-empaques B-table-Win 
FUNCTION fgen-empaques RETURNS CHARACTER
  ( INPUT pCantidad AS dec ) :

    DEFINE VAR lRetVal AS CHAR INIT "".
    DEFINE VAR lSaldo AS DEC.
    DEFINE VAR lValor AS INT.

    lSaldo = pCantidad.
    IF lSaldo > 0 AND almmmatg.canemp > 0 THEN DO:
        lValor = TRUNCATE(lSaldo / almmmatg.canemp,0).
        IF lValor > 0 THEN DO:
            lRetVal = "M(" + STRING(lValor) + "/" + STRING(almmmatg.canemp) + " )".
        END.
        lSaldo = lSaldo - (lValor * almmmatg.canemp).
    END.
    IF lSaldo > 0 AND almmmatg.StkRep > 0 THEN DO:
        lValor = TRUNCATE(lSaldo / almmmatg.StkRep,0).
        IF lValor > 0 THEN DO:
            lRetVal = lRetVal + IF(lRetVal = "") THEN "" ELSE " ".
            lRetVal = lRetVal + "I(" + STRING(lValor) + "/" + STRING(almmmatg.StkRep) + ")".
        END.
        lSaldo = lSaldo - (lValor * almmmatg.StkRep).
    END.
    IF lSaldo > 0 THEN DO:
        lRetVal = lRetVal + IF(lRetVal = "") THEN "" ELSE " ".
        lRetVal = lRetVal + "U(" + STRING(lSaldo) + ")".
    END.


  RETURN lRetVal.   /* Function return value. */

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

