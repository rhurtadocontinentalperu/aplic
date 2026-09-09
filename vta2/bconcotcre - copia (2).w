&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER DETALLE FOR FacDPedi.
DEFINE BUFFER ORDENES FOR FacCPedi.
DEFINE BUFFER PEDIDOS FOR FacCPedi.
DEFINE TEMP-TABLE T-CPEDI NO-UNDO LIKE FacCPedi.



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
DEFINE SHARED VAR s-acceso-total  AS LOG NO-UNDO.

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEF VAR x-Estado AS CHAR NO-UNDO.

DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-NROPED   AS CHAR.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.

    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.
    DEF VAR zArchivo AS CHAR.
    DEF VAR cComando AS CHAR.
    DEF VAR pDirectorio AS CHAR.
    DEF VAR lOptions AS CHAR.

    DEFINE TEMP-TABLE T-Detalle
        FIELD CodDiv LIKE Faccpedi.coddiv LABEL "División"
        FIELD NroPed LIKE Faccpedi.nroped LABEL "Cotizacion"
        FIELD FchPed LIKE Faccpedi.fchped LABEL "Emision"
        FIELD FchVen LIKE Faccpedi.fchven LABEL "Vencimiento"
        FIELD FchEnt LIKE Faccpedi.fchent LABEL "Fecha Entrega"
        FIELD OrdCmp LIKE Faccpedi.ordcmp LABEL "Orden de Compra"
        FIELD CodCli LIKE gn-clie.codcli LABEL 'Cliente'
        FIELD NomCli LIKE Faccpedi.nomcli LABEL "Nombre o Razon Social"
        FIELD LugEnt AS CHAR FORMAT 'x(60)' LABEL "Destino"
        FIELD DistEnt AS CHAR FORMAT 'x(30)' LABEL "Distrito"
        FIELD ProvEnt AS CHAR FORMAT 'x(30)' LABEL "Provincia"
        FIELD CodVen AS CHAR FORMAT 'x(5)' LABEL "Vendedor"
        FIELD NomVen AS CHAR FORMAT 'x(30)' LABEL "Nombre"
        FIELD FmaPgo AS CHAR FORMAT 'x(8)' LABEL 'Forma de Pago'
        FIELD NomPgo AS CHAR FORMAT 'x(30)' LABEL 'Descripcion'
        FIELD ImpTot LIKE Faccpedi.imptot LABEL "Importe"
        FIELD Estado AS CHAR FORMAT 'x(20)' LABEL "Estado"
        FIELD Avance AS DEC LABEL "% Avance"
        FIELD Items AS INT LABEL "Total de Items"
        FIELD Peso AS DEC LABEL "Total Peso Kg."
        FIELD Atendido AS DEC LABEL "Import. Atendido"
        FIELD Pendiente AS DEC LABEL "Import. por Atender"
        FIELD NroItm LIKE Facdpedi.nroitm LABEL "No."
        FIELD CodMat LIKE Facdpedi.codmat LABEL "Articulo"
        FIELD DesMat LIKE Almmmatg.desmat LABEL "Descripcion"
        FIELD DesMar LIKE Almmmatg.desmar LABEL "Marca"
        FIELD UndVta LIKE Facdpedi.undvta LABEL "Unidad"
        FIELD CanPed LIKE Facdpedi.canped LABEL "Cantidad Aprobada"
        FIELD CanAte LIKE Facdpedi.canate LABEL "Cantidad Atendida"
        FIELD PreUni LIKE Facdpedi.preuni LABEL "Precio Unitario"
        FIELD DctoManual AS DEC LABEL "% Dscto Manual"
        FIELD DctoEvento AS DEC LABEL "% Dscto Evento"
        FIELD DctoVolProm AS DEC LABEL "% Dscto Vol/Prom"
        FIELD PesoUnit AS DEC LABEL "Peso Unit"
        FIELD CubiUnit AS DEC LABEL "Cubic Unit"
        FIELD PesoLin AS DEC LABEL "Peso por Item"
        FIELD PesoAte AS DEC LABEL "Peso Atendido"
        FIELD ImpLin  AS DEC LABEL "Importe"
        FIELD ImpAte  AS DEC LABEL "Import. Atendido"
        FIELD CantxAte AS DEC LABEL "Cantidad por Atender"
        FIELD PesoxAte AS DEC LABEL "Peso por Atender"
        FIELD ImpxAte  AS DEC LABEL "Import. por Atender"
        .

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
&Scoped-define INTERNAL-TABLES T-CPEDI FacCPedi

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacCPedi.CodDoc FacCPedi.NroPed ~
FacCPedi.FchPed FacCPedi.fchven FacCPedi.FchEnt FacCPedi.CodCli ~
FacCPedi.NomCli FacCPedi.CodVen FacCPedi.ImpTot T-CPEDI.Libre_c02 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH T-CPEDI WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST FacCPedi OF T-CPEDI NO-LOCK
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-CPEDI WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST FacCPedi OF T-CPEDI NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_table T-CPEDI FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-CPEDI
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacCPedi


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-CodDiv SELECT-FlgEst BUTTON-Excel ~
BUTTON-Filtrar COMBO-BOX-Filtro FILL-IN-NomCli BUTTON-Limpiar ~
RADIO-SET-Excel FILL-IN-CodVen FILL-IN-FchPed-1 FILL-IN-FchPed-2 br_table ~
RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodDiv x-NomDiv SELECT-FlgEst ~
COMBO-BOX-Filtro FILL-IN-NomCli RADIO-SET-Excel FILL-IN-CodVen ~
FILL-IN-NomVen FILL-IN-FchPed-1 FILL-IN-FchPed-2 

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
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fImpAtendido B-table-Win 
FUNCTION fImpAtendido RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fImpxAtender B-table-Win 
FUNCTION fImpxAtender RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPorcAvance B-table-Win 
FUNCTION fPorcAvance RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD _FlgEst B-table-Win 
FUNCTION _FlgEst RETURNS CHARACTER
  ( /*INPUT pFlgEst AS CHAR*/ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Excel 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 7" 
     SIZE 6 BY 1.54.

DEFINE BUTTON BUTTON-Filtrar 
     LABEL "APLICAR FILTRO" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Limpiar 
     LABEL "LIMPIAR FILTROS" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX-Filtro AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Filtro por Nombre de Cliente" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Nombres que inicien con","Nombres que contengan" 
     DROP-DOWN-LIST
     SIZE 21 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodVen AS CHARACTER FORMAT "X(256)":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchPed-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchPed-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Excel AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Solo Cabeceras", 1,
"Cabecera + Detalle", 2
     SIZE 16 BY 1.54 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 138 BY 3.77.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 19 BY 3.77.

DEFINE VARIABLE SELECT-FlgEst AS CHARACTER INITIAL "Todos" 
     VIEW-AS SELECTION-LIST SINGLE 
     LIST-ITEMS "Todos","Pendiente","En Proceso","Atendida en Proceso","Atendida Total" 
     SIZE 20 BY 2.96 TOOLTIP "Selecciona Estados" NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-CPEDI, 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacCPedi.CodDoc FORMAT "x(3)":U
      FacCPedi.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U WIDTH 10.57
      FacCPedi.FchPed COLUMN-LABEL "Emision" FORMAT "99/99/99":U
      FacCPedi.fchven COLUMN-LABEL "Vencimiento" FORMAT "99/99/99":U
      FacCPedi.FchEnt FORMAT "99/99/99":U
      FacCPedi.CodCli COLUMN-LABEL "Cliente" FORMAT "x(11)":U WIDTH 11
      FacCPedi.NomCli COLUMN-LABEL "Nombre o Razon Social" FORMAT "x(100)":U
            WIDTH 62.86
      FacCPedi.CodVen FORMAT "x(10)":U
      FacCPedi.ImpTot COLUMN-LABEL "Importe" FORMAT "->>,>>>,>>9.99":U
      T-CPEDI.Libre_c02 COLUMN-LABEL "Estado" FORMAT "x(20)":U
            WIDTH 17.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 157 BY 7.27
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodDiv AT ROW 1.27 COL 24 COLON-ALIGNED WIDGET-ID 94
     x-NomDiv AT ROW 1.27 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     SELECT-FlgEst AT ROW 1.27 COL 102 NO-LABEL WIDGET-ID 82
     BUTTON-Excel AT ROW 1.27 COL 146 WIDGET-ID 52
     BUTTON-Filtrar AT ROW 1.54 COL 123 WIDGET-ID 28
     COMBO-BOX-Filtro AT ROW 2.08 COL 24 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-NomCli AT ROW 2.08 COL 47 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     BUTTON-Limpiar AT ROW 2.62 COL 123 WIDGET-ID 26
     RADIO-SET-Excel AT ROW 2.81 COL 141 NO-LABEL WIDGET-ID 54
     FILL-IN-CodVen AT ROW 2.88 COL 24 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-NomVen AT ROW 2.88 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     FILL-IN-FchPed-1 AT ROW 3.69 COL 24 COLON-ALIGNED WIDGET-ID 86
     FILL-IN-FchPed-2 AT ROW 3.69 COL 48 COLON-ALIGNED WIDGET-ID 88
     br_table AT ROW 4.77 COL 2
     "Estado:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 1.27 COL 96 WIDGET-ID 84
     RECT-1 AT ROW 1 COL 2 WIDGET-ID 90
     RECT-2 AT ROW 1 COL 140 WIDGET-ID 92
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
      TABLE: DETALLE B "?" ? INTEGRAL FacDPedi
      TABLE: ORDENES B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDOS B "?" ? INTEGRAL FacCPedi
      TABLE: T-CPEDI T "?" NO-UNDO INTEGRAL FacCPedi
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
         HEIGHT             = 11.42
         WIDTH              = 160.43.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
/* BROWSE-TAB br_table FILL-IN-FchPed-2 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-CPEDI,INTEGRAL.FacCPedi OF Temp-Tables.T-CPEDI"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST"
     _FldNameList[1]   = INTEGRAL.FacCPedi.CodDoc
     _FldNameList[2]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Emision" "99/99/99" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.fchven
"FacCPedi.fchven" "Vencimiento" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacCPedi.FchEnt
"FacCPedi.FchEnt" ? "99/99/99" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacCPedi.CodCli
"FacCPedi.CodCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" "Nombre o Razon Social" ? "character" ? ? ? ? ? ? no ? no no "62.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = INTEGRAL.FacCPedi.CodVen
     _FldNameList[9]   > INTEGRAL.FacCPedi.ImpTot
"FacCPedi.ImpTot" "Importe" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-CPEDI.Libre_c02
"T-CPEDI.Libre_c02" "Estado" "x(20)" "character" ? ? ? ? ? ? no ? no no "17.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON LEFT-MOUSE-DBLCLICK OF br_table IN FRAME F-Main
DO:
    /*RUN vta/d-conpedcremos (Faccpedi.codcia, Faccpedi.coddiv, Faccpedi.coddoc, Faccpedi.nroped).*/
    /*RUN vta2/dcotizacionesypedidos (Faccpedi.coddoc, Faccpedi.nroped).*/
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
  
  IF AVAILABLE Faccpedi 
  THEN ASSIGN 
      s-CodCli = Faccpedi.codcli
      s-CodDoc = Faccpedi.coddoc
      s-NroPed = Faccpedi.nroped.
  ELSE ASSIGN
      s-CodCli = ?
      s-CodDoc = ?
      s-NroPed = ?.
  RUN Procesa-Handle IN lh_handle ('Open-Query-2':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Excel B-table-Win
ON CHOOSE OF BUTTON-Excel IN FRAME F-Main /* Button 7 */
DO:
  ASSIGN RADIO-SET-Excel.
  SESSION:SET-WAIT-STATE('GENERAL').
  CASE RADIO-SET-Excel:
      WHEN 1 THEN RUN Solo-cabecera.
      WHEN 2 THEN RUN Excel-cabecera-detalle.
  END CASE.
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Filtrar B-table-Win
ON CHOOSE OF BUTTON-Filtrar IN FRAME F-Main /* APLICAR FILTRO */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          FILL-IN-CodDiv x-NomDiv COMBO-BOX-FILTRO FILL-IN-CodVen FILL-IN-NomVen FILL-IN-NomCli 
          FILL-IN-FchPed-1 FILL-IN-FchPed-2 SELECT-FlgEst.
      RUN Carga-Temporal.
      RUN dispatch IN THIS-PROCEDURE ('open-query':U).
      RUN Procesa-Handle IN lh_handle ('Open-Query':U).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Limpiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Limpiar B-table-Win
ON CHOOSE OF BUTTON-Limpiar IN FRAME F-Main /* LIMPIAR FILTROS */
DO:
  ASSIGN
      COMBO-BOX-FILTRO = 'Todos'
      FILL-IN-CodVen = ''
      FILL-IN-NomVen = ''
      FILL-IN-NomCli = ''
      FILL-IN-FchPed-1 = TODAY - DAY(TODAY) + 1
      FILL-IN-FchPed-2 = TODAY
      SELECT-FlgEst = 'Todos'.
  DO WITH FRAME {&FRAME-NAME}:
      DISPLAY COMBO-BOX-Filtro FILL-IN-CodVen FILL-IN-NomVen FILL-IN-NomCli.
      DISPLAY FILL-IN-FchPed-1 FILL-IN-FchPed-2 SELECT-FlgEst.
      RUN Carga-Temporal.
      RUN dispatch IN THIS-PROCEDURE ('open-query':U).
      RUN Procesa-Handle IN lh_handle ('Open-Query':U).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodDiv B-table-Win
ON LEAVE OF FILL-IN-CodDiv IN FRAME F-Main /* División */
DO:
    IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
    x-NomDiv:SCREEN-VALUE = ''.
    FIND gn-divi WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-divi THEN DO:
        MESSAGE 'División errada' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    x-NomDiv:SCREEN-VALUE = GN-DIVI.DesDiv.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodVen B-table-Win
ON LEFT-MOUSE-DBLCLICK OF FILL-IN-CodVen IN FRAME F-Main /* Vendedor */
OR F8 OF FILL-IN-CodVen DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?.
    RUN lkup/c-vende ('Vendedores').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchPed-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchPed-1 B-table-Win
ON LEAVE OF FILL-IN-FchPed-1 IN FRAME F-Main /* Emitidos Desde */
DO:
    IF INPUT {&SELF-NAME} = ? THEN DO:
        MESSAGE 'Debe ingresar un afecha válida' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    IF INPUT {&SELF-NAME} < ADD-INTERVAL(TODAY,-4,'months') THEN DO:
        MESSAGE 'No se aceptan fechas menores a 4 meses' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchPed-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchPed-2 B-table-Win
ON LEAVE OF FILL-IN-FchPed-2 IN FRAME F-Main /* Emitidos Hasta */
DO:
    IF INPUT {&SELF-NAME} = ? THEN DO:
        MESSAGE 'Debe ingresar un afecha válida' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME SELECT-FlgEst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SELECT-FlgEst B-table-Win
ON VALUE-CHANGED OF SELECT-FlgEst IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
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

  {&OPEN-QUERY-{&BROWSE-NAME}}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE('GENERAL').
EMPTY TEMP-TABLE T-CPEDI.
FOR EACH Faccpedi NO-LOCK WHERE FacCPedi.CodCia = s-codcia
    AND FacCPedi.CodDoc = "COT"
    AND FacCPedi.CodDiv = FILL-IN-CodDiv
    AND (FacCPedi.FchPed >= FILL-IN-FchPed-1 AND FacCPedi.FchPed <= FILL-IN-FchPed-2):
    IF FILL-IN-CodVen > '' AND FacCPedi.CodVen <> FILL-IN-CodVen THEN NEXT.
    CASE COMBO-BOX-Filtro:
        WHEN 'Nombres que inicien con' THEN DO:
            IF NOT (FacCPedi.NomCli BEGINS FILL-IN-NomCli) THEN NEXT.
        END.
        WHEN 'Nombres que contengan' THEN DO:
            IF NOT INDEX(FacCPedi.NomCli, FILL-IN-NomCli) > 0 THEN NEXT.
        END.
    END CASE.
    CREATE T-CPEDI.
    BUFFER-COPY FacCPedi TO T-CPEDI.
    CASE TRUE:
        WHEN FacCPedi.FlgEst= "P" AND
            NOT CAN-FIND(FIRST FacDPedi OF FacCPedi WHERE FacDPedi.CanAte > 0 NO-LOCK)
            THEN T-CPEDI.Libre_c02 = "PENDIENTE".
        WHEN FacCPedi.FlgEst= "P" AND
            CAN-FIND(FIRST FacDPedi OF FacCPedi WHERE FacDPedi.CanAte > 0 NO-LOCK)
            THEN T-CPEDI.Libre_c02 = "EN PROCESO".
        WHEN FacCPedi.FlgEst = "C" THEN DO:
            T-CPEDI.Libre_c02 = "ATENDIDA TOTAL".   /* Por defecto */
            RLOOP:
            FOR EACH PEDIDOS NO-LOCK WHERE PEDIDOS.codcia = Faccpedi.codcia
                AND PEDIDOS.coddiv = Faccpedi.coddiv
                AND PEDIDOS.coddoc = "PED"
                AND PEDIDOS.codref = Faccpedi.coddoc
                AND PEDIDOS.nroref = Faccpedi.nroped
                AND PEDIDOS.flgest <> "A":
                IF PEDIDOS.FlgEst <> "C" THEN DO:
                    T-CPEDI.Libre_c02 = "ATENDIDA EN PROCESO".
                    LEAVE RLOOP.
                END.
                FOR EACH ORDENES NO-LOCK WHERE ORDENES.codcia = PEDIDOS.codcia
                    AND ORDENES.coddiv = PEDIDOS.coddiv
                    AND ORDENES.coddoc = "O/D"
                    AND ORDENES.codref = PEDIDOS.coddoc
                    AND ORDENES.nroref = PEDIDOS.nroped
                    AND ORDENES.flgest <> "A":
                    IF ORDENES.FlgEst <> "C" THEN DO:
                        T-CPEDI.Libre_c02 = "ATENDIDA EN PROCESO".
                        LEAVE RLOOP.
                    END.
                END.
            END.
        END.
        OTHERWISE DO:
            T-CPEDI.Libre_c02 = _FlgEst().
        END.
    END CASE.
    CASE TRUE:
        WHEN LOOKUP(SELECT-FlgEst, "PENDIENTE,EN PROCESO,ATENDIDA EN PROCESO,ATENDIDA TOTAL") > 0
            THEN DO:
            IF T-CPEDI.Libre_c02 <> SELECT-FlgEst THEN DO:
                DELETE T-CPEDI.
            END.
        END.
    END CASE.
END.
SESSION:SET-WAIT-STATE('').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-cabecera-detalle B-table-Win 
PROCEDURE Excel-cabecera-detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-FmaPgo AS CHAR.
DEF VAR x-CodVen AS CHAR.
    
ASSIGN
        pOptions = "".
    RUN lib/tt-file-to-text-01 (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE('GENERAL').
    EMPTY TEMP-TABLE T-Detalle.
    GET FIRST {&browse-name}.
    REPEAT WHILE AVAILABLE T-CPEDI:
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = T-CPEDI.codcli
            NO-LOCK NO-ERROR.
        x-FmaPgo = ''.
        FIND gn-ConVt WHERE gn-ConVt.Codig = Faccpedi.fmapgo NO-LOCK NO-ERROR.
        IF AVAILABLE gn-ConVt THEN x-FmaPgo = gn-ConVt.Nombr.
        x-CodVen = ''.
        FIND gn-ven WHERE gn-ven.CodCia = Faccpedi.codcia
            AND gn-ven.CodVen = Faccpedi.codven NO-LOCK NO-ERROR. 
        IF AVAILABLE gn-ven THEN x-CodVen = gn-ven.NomVen.
        FOR EACH DETALLE OF Faccpedi NO-LOCK,FIRST Almmmatg OF DETALLE NO-LOCK :
            CREATE T-Detalle.
            BUFFER-COPY Faccpedi
                TO T-Detalle
                ASSIGN
                T-Detalle.NomVen = x-CodVen
                T-Detalle.NomPgo = x-FmaPgo
                T-Detalle.Estado = T-CPEDI.Libre_C02
                T-Detalle.Avance = fPorcAvance()
                .
            ASSIGN
                T-Detalle.codmat = Detalle.codmat
                T-Detalle.desmat = Almmmatg.desmat
                T-Detalle.desmar = Almmmatg.desmar
                T-Detalle.undvta = Detalle.undvta
                T-Detalle.canped = Detalle.canped
                T-Detalle.canate = Detalle.canate
                T-Detalle.implin = Detalle.implin.
        END.
        GET NEXT {&browse-name}.
    END.
    SESSION:SET-WAIT-STATE('').

    FIND FIRST T-Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE T-Detalle THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    /* Definimos los campos a mostrar */
    ASSIGN lOptions = "FieldList:".
    lOptions = lOptions + "coddiv,nroped,fchped,fchven,fchent,codcli,nomcli," +
        "codven,nomven,fmapgo,nompgo,imptot,estado,avance," +
        "codmat,desmat,desmar,undvta,canped,canate,implin".
    pOptions = pOptions + CHR(1) + lOptions.

    /* El archivo se va a generar en un archivo temporal de trabajo antes 
    de enviarlo a su directorio destino */
    cArchivo = LC(pArchivo).
    SESSION:SET-WAIT-STATE('GENERAL').
    /*SESSION:DATE-FORMAT = "mdy".*/
    RUN lib/tt-filev2 (TEMP-TABLE T-Detalle:HANDLE, cArchivo, pOptions).
    /*SESSION:DATE-FORMAT = "dmy".*/
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    RUN Procesa-Handle IN lh_handle ('Open-Query':U).
    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-cabecera-detalle-old B-table-Win 
PROCEDURE Excel-cabecera-detalle-old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.

DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).
chWorkSheet:Range("A1"):VALUE = "Div. Origen".
chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:Range("B1"):VALUE = "Cotizacion".
chWorkSheet:COLUMNS("B"):NumberFormat = "@".
chWorkSheet:Range("C1"):VALUE = "Emisión".
chWorkSheet:COLUMNS("C"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("D1"):VALUE = "Vencimiento".
chWorkSheet:COLUMNS("D"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("E1"):VALUE = "Fecha Entrega".
chWorkSheet:COLUMNS("E"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("F1"):VALUE = "Cliente".
chWorkSheet:COLUMNS("F"):NumberFormat = "@".
chWorkSheet:Range("G1"):VALUE = "Nombre o Razón Social".
chWorkSheet:Range("H1"):VALUE = "Vendedor".
chWorkSheet:COLUMNS("H"):NumberFormat = "@".
chWorkSheet:Range("I1"):VALUE = "Nombre".
chWorkSheet:Range("J1"):VALUE = "Forma de Pago".
chWorkSheet:COLUMNS("J"):NumberFormat = "@".
chWorkSheet:Range("K1"):VALUE = "Descripcion".
chWorkSheet:Range("L1"):VALUE = "Importe".
chWorkSheet:Range("M1"):VALUE = "Estado".
chWorkSheet:Range("N1"):VALUE = "% Avance".
chWorkSheet:Range("O1"):VALUE = "Articulo".
chWorkSheet:COLUMNS("O"):NumberFormat = "@".
chWorkSheet:Range("P1"):VALUE = "Descripción".
chWorkSheet:Range("Q1"):VALUE = "Marca".
chWorkSheet:Range("R1"):VALUE = "Unidad".
chWorkSheet:Range("S1"):VALUE = "Cantidad Aprobada".
chWorkSheet:Range("T1"):VALUE = "Cantidad Atendida".
chWorkSheet:Range("U1"):VALUE = "Importe".

DEF VAR x-FmaPgo AS CHAR.
DEF VAR x-CodVen AS CHAR.
GET FIRST {&browse-name}.
REPEAT WHILE AVAILABLE T-CPEDI:
    FOR EACH DETALLE OF Faccpedi NO-LOCK,FIRST Almmmatg OF DETALLE NO-LOCK :
        x-FmaPgo = ''.
        FIND gn-ConVt WHERE gn-ConVt.Codig = Faccpedi.fmapgo NO-LOCK NO-ERROR.
        IF AVAILABLE gn-ConVt THEN x-FmaPgo = gn-ConVt.Nombr.
        x-CodVen = ''.
        FIND gn-ven WHERE gn-ven.CodCia = Faccpedi.codcia
            AND gn-ven.CodVen = Faccpedi.codven NO-LOCK NO-ERROR. 
        IF AVAILABLE gn-ven THEN x-CodVen = gn-ven.NomVen.
        t-Row = t-Row + 1.
        t-Column = 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.coddiv.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.nroped.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.fchped.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.fchven.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = T-CPEDI.fchent  /*Faccpedi.fchent*/.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.codcli.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.nomcli.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.codven.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = x-CodVen.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.fmapgo.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = x-FmaPgo.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.imptot.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = T-CPEDI.Libre_C02.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = fPorcAvance().
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.CodMat.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.DesMat.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.DesMar.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.UndVta.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.CanPed.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.CanAte.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.ImpLin.
    END.
    GET NEXT {&browse-name}.
END.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).
RUN Procesa-Handle IN lh_handle ('Open-Query':U).

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
  FILL-IN-CodDiv = s-coddiv.
  FIND gn-divi WHERE codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK.
  x-nomdiv = GN-DIVI.DesDiv. 
  ASSIGN
      FILL-IN-FchPed-1 = TODAY - DAY(TODAY) + 1
      FILL-IN-FchPed-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      IF s-acceso-total = NO THEN FILL-IN-CodDiv:SENSITIVE = NO.
      APPLY 'ENTRY':U TO FILL-IN-FchPed-1.
      APPLY 'ENTRY':U TO FILL-IN-CodDiv.
  END.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-changed B-table-Win 
PROCEDURE local-row-changed :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-changed':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  APPLY 'value-changed' TO {&browse-name} IN FRAME {&FRAME-NAME}.
  /*
  IF AVAILABLE Faccpedi THEN s-NroPed = Faccpedi.nroped.
  ELSE s-NroPed = ?.
  RUN Procesa-Handle IN lh_handle ('Open-Query-2':U).
  */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Numero-Cotizacion B-table-Win 
PROCEDURE Numero-Cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER pNroCot AS CHAR.

IF AVAILABLE Faccpedi THEN pNroCot = Faccpedi.nroped.
ELSE pNroCot = ?.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key B-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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
  {src/adm/template/snd-list.i "T-CPEDI"}
  {src/adm/template/snd-list.i "FacCPedi"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Solo-Cabecera B-table-Win 
PROCEDURE Solo-Cabecera PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN
        pOptions = "".
    RUN lib/tt-file-to-text-01 (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE('GENERAL').
    EMPTY TEMP-TABLE T-Detalle.
    GET FIRST {&browse-name}.
    REPEAT WHILE AVAILABLE T-CPEDI:
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = T-CPEDI.codcli
            NO-LOCK NO-ERROR.
        CREATE T-Detalle.
        BUFFER-COPY Faccpedi
            TO T-Detalle
            ASSIGN
            T-Detalle.Estado = T-CPEDI.Libre_C02
            T-Detalle.Avance = fPorcAvance()
            T-Detalle.Items = T-CPEDI.Items
            T-Detalle.Peso = T-CPEDI.Peso
            T-Detalle.Atendido = fImpAtendido()
            T-Detalle.Pendiente = fImpxAtender()
            T-DEtalle.OrdCmp = T-CPEDI.OrdCmp.
        IF AVAILABLE gn-clie THEN DO:
            FIND TabProvi WHERE TabProvi.CodDepto = gn-clie.CodDept
                AND TabProvi.CodProvi = gn-clie.codprov
                NO-LOCK NO-ERROR.
            FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept
                AND Tabdistr.Codprovi = gn-clie.codprov
                AND Tabdistr.Coddistr = gn-clie.coddist
                NO-LOCK NO-ERROR.
            IF T-Detalle.LugEnt = '' THEN T-Detalle.LugEnt = gn-clie.dirent.
            IF AVAILABLE Tabdistr THEN T-Detalle.DistEnt = TabDistr.NomDistr.
            IF AVAILABLE Tabprovi THEN T-Detalle.ProvEnt = TabProvi.NomProvi.
        END.

        GET NEXT {&browse-name}.
    END.
    SESSION:SET-WAIT-STATE('').

    FIND FIRST T-Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE T-Detalle THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    /* Definimos los campos a mostrar */
    ASSIGN lOptions = "FieldList:".
    lOptions = lOptions + "coddiv,nroped,fchped,fchven,fchent,ordcmp,nomcli," +
        "codven,imptot,estado,avance,items,peso,atendido,pendiente" +
        ",lugent,distent,provent".
    pOptions = pOptions + CHR(1) + lOptions.

    /* El archivo se va a generar en un archivo temporal de trabajo antes 
    de enviarlo a su directorio destino */
    cArchivo = LC(pArchivo).
    SESSION:SET-WAIT-STATE('GENERAL').
    /*SESSION:DATE-FORMAT = "mdy".*/
    RUN lib/tt-filev2 (TEMP-TABLE T-Detalle:HANDLE, cArchivo, pOptions).
    /*SESSION:DATE-FORMAT = "dmy".*/
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    RUN Procesa-Handle IN lh_handle ('Open-Query':U).
    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fImpAtendido B-table-Win 
FUNCTION fImpAtendido RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR xImpAte AS DEC NO-UNDO.

  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      ASSIGN
          xImpAte = xImpAte + (Facdpedi.ImpLin / facdpedi.CanPed) * Facdpedi.CanAte.
  END.

  RETURN xImpAte.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fImpxAtender B-table-Win 
FUNCTION fImpxAtender RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEF VAR xImpAte AS DEC NO-UNDO.
    DEF VAR xImpTot AS DEC NO-UNDO.

  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      ASSIGN
          xImpTot = xImpTot + Facdpedi.ImpLin.
          xImpAte = xImpAte + (Facdpedi.ImpLin / facdpedi.CanPed) * Facdpedi.CanAte.
  END.

  RETURN xImpTot - xImpAte.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPorcAvance B-table-Win 
FUNCTION fPorcAvance RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR xPorcAvance AS DEC NO-UNDO.
  DEF VAR xImpPed AS DEC NO-UNDO.
  DEF VAR xImpAte AS DEC NO-UNDO.

  /* 17/12/2014 Probemos por cantidades */
  FOR EACH Facdpedi OF T-CPEDI NO-LOCK:
      xImpPed = xImpPed + Facdpedi.canped.
  END.
  FOR EACH PEDIDOS NO-LOCK WHERE PEDIDOS.codcia = T-CPEDI.codcia
      AND PEDIDOS.coddiv = T-CPEDI.coddiv
      AND PEDIDOS.coddoc = "PED"
      AND PEDIDOS.codref = T-CPEDI.coddoc
      AND PEDIDOS.nroref = T-CPEDI.nroped
      AND PEDIDOS.flgest <> "A",
      EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
      AND ccbcdocu.codped = PEDIDOS.coddoc
      AND ccbcdocu.nroped = PEDIDOS.nroped
      AND LOOKUP(ccbcdocu.coddoc, 'FAC,BOL') > 0
      AND ccbcdocu.flgest <> 'A',
      EACH ccbddocu OF ccbcdocu NO-LOCK:
      ASSIGN xImpAte = xImpAte + ccbddocu.candes.
  END.

  xPorcAvance = xImpAte / xImpPed * 100.
  IF xPorcAvance < 0 THEN xPorcAvance = 0.
  IF xPorcAvance > 100 THEN xPorcAvance = 100.

  RETURN ROUND(xPorcAvance, 2).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION _FlgEst B-table-Win 
FUNCTION _FlgEst RETURNS CHARACTER
  ( /*INPUT pFlgEst AS CHAR*/ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR pEstado AS CHAR NO-UNDO.

/*RUN vta2/p-faccpedi-flgest (Faccpedi.FlgEst, Faccpedi.CodDoc, OUTPUT pEstado).*/
RUN vta2/p-faccpedi-flgestv2 (ROWID(Faccpedi), OUTPUT pEstado).

RETURN pEstado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

