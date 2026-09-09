&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-RUTAD LIKE DI-RutaD
       FIELD LugEnt AS CHAR
       FIELD SKU AS INT
       FIELD FchEnt AS DATE
       FIELD Docs AS INT
       FIELD Estado AS CHAR
       FIELD Reprogramado AS LOG INITIAL NO
       FIELD PtoDestino as char
       FIELD Departamento AS CHAR.
DEFINE BUFFER X-DI-RutaC FOR DI-RutaC.



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
DEF SHARED VAR S-CODCIA AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR lh_handle AS HANDLE.

DEF VAR x-Distrito AS CHAR NO-UNDO.
DEF VAR x-SKU AS INT NO-UNDO.
DEF VAR x-Docs AS INT NO-UNDO.
DEF VAR x-Estado AS CHAR NO-UNDO.
DEF VAR x-lugar-ent AS CHAR NO-UNDO.

DEF VAR x-Reprogramado AS LOGICAL FORMAT "SI/NO" NO-UNDO.
DEFINE VAR x-Departamento AS CHAR.

DEF TEMP-TABLE TT-RUTAD LIKE T-RUTAD.
DEF TEMP-TABLE TTT-RUTAD LIKE T-RUTAD.

/* SORT */
define var x-sort-direccion as char init "".
define var x-sort-column as char init "".
define var x-sort-command as char init "".

DEFINE VAR x-sort-acumulativo AS LOG INIT NO.           /* Indica si add columna */
DEFINE VAR x-sort-color-reset AS LOG INIT YES.

DEFINE VAR x-rowid AS ROWID.

x-rowid = ?.

DEF VAR x-Liquidacion AS CHAR NO-UNDO.

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
&Scoped-define INTERNAL-TABLES T-RUTAD FacCPedi GN-DIVI DI-RutaD gn-ConVt

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-RUTAD.CodRef T-RUTAD.NroRef ~
FacCPedi.Cliente_Recoge FacCPedi.EmpaqEspec ~
T-RUTAD.Reprogramado @ x-Reprogramado FacCPedi.CrossDocking GN-DIVI.DesDiv ~
t-RutaD.Departamento @ x-Departamento T-RUTAD.ptodestino @ x-Distrito ~
FacCPedi.NomCli FacCPedi.FchPed FacCPedi.Hora FacCPedi.FchEnt ~
T-RUTAD.Estado @ x-Estado T-RUTAD.Libre_c01 T-RUTAD.SKU @ x-SKU ~
T-RUTAD.ImpCob T-RUTAD.Libre_d01 T-RUTAD.Libre_d02 FacCPedi.FmaPgo ~
fDescripcion() @ gn-ConVt.Nombr fLiquidacion() @ x-Liquidacion ~
T-RUTAD.Libre_c02 FacCPedi.Glosa t-rutad.lugent @ x-lugar-ent ~
FacCPedi.CodRef FacCPedi.NroRef T-RUTAD.FlgEst T-RUTAD.Docs @ x-Docs 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-RUTAD.CodRef ~
T-RUTAD.NroRef 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-RUTAD
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-RUTAD
&Scoped-define QUERY-STRING-br_table FOR EACH T-RUTAD WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = T-RUTAD.CodCia ~
  AND FacCPedi.CodDoc = T-RUTAD.CodRef ~
  AND FacCPedi.NroPed = T-RUTAD.NroRef NO-LOCK, ~
      FIRST GN-DIVI OF FacCPedi NO-LOCK, ~
      FIRST DI-RutaD WHERE DI-RutaD.CodCia = T-RUTAD.CodCia ~
  AND DI-RutaD.CodDiv = T-RUTAD.CodDiv ~
  AND DI-RutaD.CodDoc = T-RUTAD.CodDoc ~
  AND DI-RutaD.CodRef = T-RUTAD.CodRef ~
  AND DI-RutaD.NroRef = T-RUTAD.NroRef ~
  AND DI-RutaD.NroDoc = T-RUTAD.NroDoc NO-LOCK, ~
      FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-RUTAD WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = T-RUTAD.CodCia ~
  AND FacCPedi.CodDoc = T-RUTAD.CodRef ~
  AND FacCPedi.NroPed = T-RUTAD.NroRef NO-LOCK, ~
      FIRST GN-DIVI OF FacCPedi NO-LOCK, ~
      FIRST DI-RutaD WHERE DI-RutaD.CodCia = T-RUTAD.CodCia ~
  AND DI-RutaD.CodDiv = T-RUTAD.CodDiv ~
  AND DI-RutaD.CodDoc = T-RUTAD.CodDoc ~
  AND DI-RutaD.CodRef = T-RUTAD.CodRef ~
  AND DI-RutaD.NroRef = T-RUTAD.NroRef ~
  AND DI-RutaD.NroDoc = T-RUTAD.NroDoc NO-LOCK, ~
      FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-RUTAD FacCPedi GN-DIVI DI-RutaD ~
gn-ConVt
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-RUTAD
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define THIRD-TABLE-IN-QUERY-br_table GN-DIVI
&Scoped-define FOURTH-TABLE-IN-QUERY-br_table DI-RutaD
&Scoped-define FIFTH-TABLE-IN-QUERY-br_table gn-ConVt


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX_FmaPgo br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX_FmaPgo FILL-IN-Importe ~
FILL-IN-Peso FILL-IN-Volumen 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fBultos B-table-Win 
FUNCTION fBultos RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDescripcion B-table-Win 
FUNCTION fDescripcion RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDocumentos B-table-Win 
FUNCTION fDocumentos RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fImporte B-table-Win 
FUNCTION fImporte RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fLiquidacion B-table-Win 
FUNCTION fLiquidacion RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fLugarEnt B-table-Win 
FUNCTION fLugarEnt RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPeso B-table-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSKU B-table-Win 
FUNCTION fSKU RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fVolumen B-table-Win 
FUNCTION fVolumen RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-br_table 
       MENU-ITEM m_Detalle_de_la_orden LABEL "Detalle de la orden".


/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-BOX_FmaPgo AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Filtrar por" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 49 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Importe" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Peso AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Peso (kg)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Volumen AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Volumen (m3)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-RUTAD, 
      FacCPedi, 
      GN-DIVI
    FIELDS(GN-DIVI.DesDiv), 
      DI-RutaD, 
      gn-ConVt
    FIELDS(gn-ConVt.Nombr) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-RUTAD.CodRef FORMAT "x(3)":U WIDTH 6 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "O/D","OTR","O/M" 
                      DROP-DOWN-LIST 
      T-RUTAD.NroRef FORMAT "X(9)":U WIDTH 10
      FacCPedi.Cliente_Recoge COLUMN-LABEL "Cliente!Recoge" FORMAT "Si/No":U
            WIDTH 5.86
      FacCPedi.EmpaqEspec COLUMN-LABEL "Embalaje!Especial" FORMAT "Si/No":U
            WIDTH 6.43
      T-RUTAD.Reprogramado @ x-Reprogramado COLUMN-LABEL "Rep."
      FacCPedi.CrossDocking FORMAT "SI/NO":U WIDTH 10.72
      GN-DIVI.DesDiv COLUMN-LABEL "Canal" FORMAT "X(25)":U
      t-RutaD.Departamento @ x-Departamento COLUMN-LABEL "Departamento" FORMAT "x(80)":U
            WIDTH 15.14
      T-RUTAD.ptodestino @ x-Distrito COLUMN-LABEL "Distrito" FORMAT "x(25)":U
      FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(30)":U WIDTH 23.72
      FacCPedi.FchPed COLUMN-LABEL "Fecha de!Pedido" FORMAT "99/99/9999":U
      FacCPedi.Hora FORMAT "X(8)":U
      FacCPedi.FchEnt FORMAT "99/99/9999":U WIDTH 11.29
      T-RUTAD.Estado @ x-Estado COLUMN-LABEL "Estado" FORMAT "x(20)":U
      T-RUTAD.Libre_c01 COLUMN-LABEL "Bultos" FORMAT "x(6)":U
      T-RUTAD.SKU @ x-SKU COLUMN-LABEL "SKU" FORMAT ">>,>>9":U
      T-RUTAD.ImpCob COLUMN-LABEL "Importe" FORMAT ">>>,>>9.99":U
            WIDTH 6.86
      T-RUTAD.Libre_d01 COLUMN-LABEL "Peso" FORMAT ">>>,>>9.99":U
      T-RUTAD.Libre_d02 COLUMN-LABEL "Volumen" FORMAT ">>>,>>9.99":U
      FacCPedi.FmaPgo COLUMN-LABEL "Término!de pago" FORMAT "X(6)":U
      fDescripcion() @ gn-ConVt.Nombr COLUMN-LABEL "Descripcion" FORMAT "X(30)":U
      fLiquidacion() @ x-Liquidacion COLUMN-LABEL "Liquidación" FORMAT "x(40)":U
      T-RUTAD.Libre_c02 COLUMN-LABEL "Tipo!BCP" FORMAT "x(20)":U
      FacCPedi.Glosa COLUMN-LABEL "Glosa O/D" FORMAT "X(50)":U
      t-rutad.lugent @ x-lugar-ent COLUMN-LABEL "Lugar de entrega" FORMAT "x(60)":U
      FacCPedi.CodRef FORMAT "x(3)":U
      FacCPedi.NroRef FORMAT "X(12)":U
      T-RUTAD.FlgEst COLUMN-LABEL "Estado 2" FORMAT "x(15)":U VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "Por Entregar","P",
                                      "Cerrado","C",
                                      "Anulado","A",
                                      "Reprogramado","R"
                      DROP-DOWN-LIST 
      T-RUTAD.Docs @ x-Docs COLUMN-LABEL "# Docs." FORMAT ">>9":U
  ENABLE
      T-RUTAD.CodRef
      T-RUTAD.NroRef
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 140 BY 11.65
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX_FmaPgo AT ROW 1 COL 19 COLON-ALIGNED WIDGET-ID 24
     br_table AT ROW 2.08 COL 1.14
     FILL-IN-Importe AT ROW 14.19 COL 84 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-Peso AT ROW 14.19 COL 103 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-Volumen AT ROW 14.19 COL 125 COLON-ALIGNED WIDGET-ID 14
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
      TABLE: T-RUTAD T "?" ? INTEGRAL DI-RutaD
      ADDITIONAL-FIELDS:
          FIELD LugEnt AS CHAR
          FIELD SKU AS INT
          FIELD FchEnt AS DATE
          FIELD Docs AS INT
          FIELD Estado AS CHAR
          FIELD Reprogramado AS LOG INITIAL NO
          FIELD PtoDestino as char
          FIELD Departamento AS CHAR
      END-FIELDS.
      TABLE: X-DI-RutaC B "?" ? INTEGRAL DI-RutaC
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
         HEIGHT             = 15
         WIDTH              = 140.86.
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
/* BROWSE-TAB br_table COMBO-BOX_FmaPgo F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-br_table:HANDLE.

/* SETTINGS FOR FILL-IN FILL-IN-Importe IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Peso IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Volumen IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-RUTAD,INTEGRAL.FacCPedi WHERE Temp-Tables.T-RUTAD ...,INTEGRAL.GN-DIVI OF INTEGRAL.FacCPedi,INTEGRAL.DI-RutaD WHERE Temp-Tables.T-RUTAD ...,INTEGRAL.gn-ConVt WHERE INTEGRAL.FacCPedi ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST, FIRST USED, FIRST, FIRST OUTER USED"
     _JoinCode[2]      = "INTEGRAL.FacCPedi.CodCia = Temp-Tables.T-RUTAD.CodCia
  AND INTEGRAL.FacCPedi.CodDoc = Temp-Tables.T-RUTAD.CodRef
  AND INTEGRAL.FacCPedi.NroPed = Temp-Tables.T-RUTAD.NroRef"
     _JoinCode[4]      = "INTEGRAL.DI-RutaD.CodCia = Temp-Tables.T-RUTAD.CodCia
  AND INTEGRAL.DI-RutaD.CodDiv = Temp-Tables.T-RUTAD.CodDiv
  AND INTEGRAL.DI-RutaD.CodDoc = Temp-Tables.T-RUTAD.CodDoc
  AND INTEGRAL.DI-RutaD.CodRef = Temp-Tables.T-RUTAD.CodRef
  AND INTEGRAL.DI-RutaD.NroRef = Temp-Tables.T-RUTAD.NroRef
  AND INTEGRAL.DI-RutaD.NroDoc = Temp-Tables.T-RUTAD.NroDoc"
     _JoinCode[5]      = "INTEGRAL.gn-ConVt.Codig = INTEGRAL.FacCPedi.FmaPgo"
     _FldNameList[1]   > Temp-Tables.T-RUTAD.CodRef
"T-RUTAD.CodRef" ? ? "character" ? ? ? ? ? ? yes ? no no "6" yes no no "U" "" "" "DROP-DOWN-LIST" "," "O/D,OTR,O/M" ? 5 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-RUTAD.NroRef
"T-RUTAD.NroRef" ? ? "character" ? ? ? ? ? ? yes ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.Cliente_Recoge
"FacCPedi.Cliente_Recoge" "Cliente!Recoge" "Si/No" "logical" ? ? ? ? ? ? no ? no no "5.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.EmpaqEspec
"FacCPedi.EmpaqEspec" "Embalaje!Especial" "Si/No" "logical" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"T-RUTAD.Reprogramado @ x-Reprogramado" "Rep." ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacCPedi.CrossDocking
"FacCPedi.CrossDocking" ? "SI/NO" "logical" ? ? ? ? ? ? no ? no no "10.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.GN-DIVI.DesDiv
"GN-DIVI.DesDiv" "Canal" "X(25)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"t-RutaD.Departamento @ x-Departamento" "Departamento" "x(80)" ? ? ? ? ? ? ? no ? no no "15.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"T-RUTAD.ptodestino @ x-Distrito" "Distrito" "x(25)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" "Cliente" "x(30)" "character" ? ? ? ? ? ? no ? no no "23.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Fecha de!Pedido" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.FacCPedi.Hora
"FacCPedi.Hora" ? "X(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > INTEGRAL.FacCPedi.FchEnt
"FacCPedi.FchEnt" ? ? "date" ? ? ? ? ? ? no ? no no "11.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"T-RUTAD.Estado @ x-Estado" "Estado" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.T-RUTAD.Libre_c01
"T-RUTAD.Libre_c01" "Bultos" "x(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"T-RUTAD.SKU @ x-SKU" "SKU" ">>,>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.T-RUTAD.ImpCob
"T-RUTAD.ImpCob" "Importe" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "6.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.T-RUTAD.Libre_d01
"T-RUTAD.Libre_d01" "Peso" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > Temp-Tables.T-RUTAD.Libre_d02
"T-RUTAD.Libre_d02" "Volumen" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > INTEGRAL.FacCPedi.FmaPgo
"FacCPedi.FmaPgo" "Término!de pago" "X(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > "_<CALC>"
"fDescripcion() @ gn-ConVt.Nombr" "Descripcion" "X(30)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > "_<CALC>"
"fLiquidacion() @ x-Liquidacion" "Liquidación" "x(40)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > Temp-Tables.T-RUTAD.Libre_c02
"T-RUTAD.Libre_c02" "Tipo!BCP" "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   > INTEGRAL.FacCPedi.Glosa
"FacCPedi.Glosa" "Glosa O/D" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   > "_<CALC>"
"t-rutad.lugent @ x-lugar-ent" "Lugar de entrega" "x(60)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[26]   = INTEGRAL.FacCPedi.CodRef
     _FldNameList[27]   = INTEGRAL.FacCPedi.NroRef
     _FldNameList[28]   > Temp-Tables.T-RUTAD.FlgEst
"T-RUTAD.FlgEst" "Estado 2" "x(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "Por Entregar,P,Cerrado,C,Anulado,A,Reprogramado,R" 5 no 0 no no
     _FldNameList[29]   > "_<CALC>"
"T-RUTAD.Docs @ x-Docs" "# Docs." ">>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
  IF AVAILABLE T-RUTAD THEN DO:
      IF T-RUTAD.Libre_d01 = 0 THEN DO: /* No Documentado */
          T-RUTAD.CodRef:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
          T-RUTAD.NroRef:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
          T-RUTAD.CodRef:FGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
          T-RUTAD.NroRef:FGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
      END.
  END.
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
ON START-SEARCH OF br_table IN FRAME F-Main
DO:
    DEFINE VARIABLE hSortColumn AS WIDGET-HANDLE.
    DEFINE VARIABLE hColumnIndex AS WIDGET-HANDLE.
    DEFINE VAR lColumName AS CHAR.
    DEFINE VAR hQueryHandle AS HANDLE NO-UNDO.

    DEFINE VAR n_cols_browse AS INT NO-UNDO.
    DEFINE VAR n_celda AS WIDGET-HANDLE NO-UNDO.

    hSortColumn = BROWSE br_table:CURRENT-COLUMN.
    lColumName = hSortColumn:NAME.
    lColumName = TRIM(REPLACE(lColumName," no","")).

    /* ARRAYYYYYY */
    IF lColumName = 'acubon' THEN DO:
        MESSAGE "Columna imposible de Ordenar".
        RETURN NO-APPLY.
    END.

    /* Funciones CALCULADAS  */
    IF lColumName = 'x-reprogramado' THEN lColumName = 'T-RUTAD.reprogramado'.
    IF lColumName = 'x-lugar-ent' THEN lColumName = 'T-RUTAD.LugEnt'.
    IF lColumName = 'x-estado' THEN lColumName = 'T-RUTAD.Estado'.
    IF lColumName = 'x-docs' THEN lColumName = 'T-RUTAD.docs'.
    IF lColumName = 'x-sku' THEN lColumName = 'T-RUTAD.SKU'.
    IF lColumName = 'x-Departamento' THEN lColumName = 't-RutaD.Departamento'.
    IF lColumName = 'x-Distrito' THEN lColumName = 'T-RUTAD.ptodestino'.

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

    /* Clear Sort Imagen */
    BROWSE br_table:CLEAR-SORT-ARROWS().

    DO n_cols_browse = 1 TO br_table:NUM-COLUMNS.
        hColumnIndex = br_table:GET-BROWSE-COLUMN(n_cols_browse).
        IF hSortColumn = hColumnIndex  THEN DO:
            IF INDEX(x-sort-command," DESC") > 0 THEN DO:
                BROWSE br_table:SET-SORT-ARROW(n_cols_browse,TRUE).
            END.
            ELSE DO:
                BROWSE br_table:SET-SORT-ARROW(n_cols_browse,FALSE).
            END.            
        END.
    END.
    
    DEFINE VAR x-sql AS CHAR.

x-sql = "FOR EACH T-RUTAD WHERE TRUE NO-LOCK, " + 
      "FIRST INTEGRAL.FacCPedi WHERE INTEGRAL.FacCPedi.CodCia = T-RUTAD.CodCia " + 
  "AND INTEGRAL.FacCPedi.CodDoc = T-RUTAD.CodRef " + 
  "AND INTEGRAL.FacCPedi.NroPed = T-RUTAD.NroRef NO-LOCK, " + 
      "FIRST INTEGRAL.GN-DIVI OF INTEGRAL.FacCPedi NO-LOCK, " + 
      "FIRST INTEGRAL.DI-RutaD WHERE INTEGRAL.DI-RutaD.CodCia = T-RUTAD.CodCia " + 
  "AND INTEGRAL.DI-RutaD.CodDiv = T-RUTAD.CodDiv " + 
  "AND INTEGRAL.DI-RutaD.CodDoc = T-RUTAD.CodDoc " + 
  "AND INTEGRAL.DI-RutaD.CodRef = T-RUTAD.CodRef " + 
  "AND INTEGRAL.DI-RutaD.NroRef = T-RUTAD.NroRef " + 
  "AND INTEGRAL.DI-RutaD.NroDoc = T-RUTAD.NroDoc NO-LOCK ". 
       

    hQueryHandle = BROWSE br_table:QUERY.
    hQueryHandle:QUERY-CLOSE().
    /* *--- Este valor debe ser el QUERY que esta definido en el BROWSE. */   
    hQueryHandle:QUERY-PREPARE(x-sql + x-sort-command).
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
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-RUTAD.CodRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-RUTAD.CodRef br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF T-RUTAD.CodRef IN BROWSE br_table /* Codigo */
DO:
  IF SELF:SCREEN-VALUE = '' THEN SELF:SCREEN-VALUE = "OTR".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_FmaPgo B-table-Win
ON VALUE-CHANGED OF COMBO-BOX_FmaPgo IN FRAME F-Main /* Filtrar por */
DO:
  ASSIGN COMBO-BOX_FmaPgo.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  RUN Totales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Detalle_de_la_orden
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Detalle_de_la_orden B-table-Win
ON CHOOSE OF MENU-ITEM m_Detalle_de_la_orden /* Detalle de la orden */
DO:
  IF AVAILABLE Faccpedi THEN RUN logis/d-detalle-orden (Faccpedi.CodDoc, Faccpedi.NroPed).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF T-RUTAD.CodRef, T-RUTAD.NroRef
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Temporal B-table-Win 
PROCEDURE Captura-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
DEF INPUT-OUTPUT PARAMETER TABLE FOR TT-RUTAD.

FIND FIRST X-DI-RUTAC OF DI-RUTAC NO-LOCK NO-ERROR.

EMPTY TEMP-TABLE TT-RUTAD.
FOR EACH T-RUTAD OF DI-RutaC NO-LOCK,
    FIRST FacCPedi WHERE FacCPedi.CodCia = T-RUTAD.CodCia
    AND FacCPedi.CodDoc = T-RUTAD.CodRef
    AND FacCPedi.NroPed = T-RUTAD.NroRef NO-LOCK,
    FIRST GN-DIVI OF FacCPedi NO-LOCK,
    FIRST DI-RutaD WHERE DI-RutaD.CodCia = T-RUTAD.CodCia
    AND DI-RutaD.CodDiv = T-RUTAD.CodDiv
    AND DI-RutaD.CodDoc = T-RUTAD.CodDoc
    AND DI-RutaD.CodRef = T-RUTAD.CodRef
    AND DI-RutaD.NroRef = T-RUTAD.NroRef
    AND DI-RutaD.NroDoc = T-RUTAD.NroDoc NO-LOCK:
    CREATE TT-RUTAD.
    BUFFER-COPY T-RUTAD TO TT-RUTAD.
END.
*/
/***/
DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT-OUTPUT PARAMETER TABLE FOR TT-RUTAD.

EMPTY TEMP-TABLE TT-RUTAD.

DEF BUFFER B-RutaC FOR Di-RutaC.

FIND B-RutaC WHERE ROWID(B-RutaC) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-RutaC THEN RETURN.
FIND FIRST x-di-rutac WHERE ROWID(x-di-rutac) = pRowid NO-LOCK NO-ERROR.

RUN Carga-Temporal (INPUT-OUTPUT TABLE TT-RUTAD, INPUT pRowid).
/*RUN refrescar (INPUT pRowid).*/

/*
FOR EACH T-RUTAD OF B-RutaC NO-LOCK,
    FIRST FacCPedi WHERE FacCPedi.CodCia = T-RUTAD.CodCia
    AND FacCPedi.CodDoc = T-RUTAD.CodRef
    AND FacCPedi.NroPed = T-RUTAD.NroRef NO-LOCK,
    FIRST GN-DIVI OF FacCPedi NO-LOCK,
    FIRST DI-RutaD WHERE DI-RutaD.CodCia = T-RUTAD.CodCia
    AND DI-RutaD.CodDiv = T-RUTAD.CodDiv
    AND DI-RutaD.CodDoc = T-RUTAD.CodDoc
    AND DI-RutaD.CodRef = T-RUTAD.CodRef
    AND DI-RutaD.NroRef = T-RUTAD.NroRef
    AND DI-RutaD.NroDoc = T-RUTAD.NroDoc NO-LOCK:
    CREATE TT-RUTAD.
    BUFFER-COPY T-RUTAD TO TT-RUTAD.
END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-temporal B-table-Win 
PROCEDURE Carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT-OUTPUT PARAMETER TABLE FOR TTT-RUTAD.
DEFINE INPUT PARAMETER pRowId AS ROWID NO-UNDO.

EMPTY TEMP-TABLE TTT-RUTAD.

FIND FIRST DI-RUTAC WHERE ROWID(DI-RUTAC) = pRowId NO-LOCK NO-ERROR.
IF NOT AVAILABLE Di-RutaC THEN RETURN.

DEF VAR pUbigeo AS CHAR NO-UNDO.
DEF VAR pLongitud AS DEC NO-UNDO.
DEF VAR pLatitud AS DEC NO-UNDO.
DEF VAR pCuadrante AS CHAR NO-UNDO.

DEFINE VAR x-DeliveryGroup AS CHAR.
DEFINE VAR x-InvoiCustomerGroup AS CHAR.

DEFINE VAR hProc AS HANDLE NO-UNDO.             /* Handle Libreria */

RUN logis\logis-librerias.p PERSISTENT SET hProc.

FOR EACH Di-RutaD OF Di-RutaC NO-LOCK, 
    FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = Di-RutaD.codcia
    AND Faccpedi.coddoc = Di-RutaD.codref
    AND Faccpedi.nroped = Di-RutaD.nroref:
    
    CREATE TTT-RUTAD.
    BUFFER-COPY Di-RutaD EXCEPT Di-RutaD.ImpCob TO TTT-RUTAD.     /* OJO */

    /**/
    RUN logis/p-datos-sede-auxiliar.r (
        FacCPedi.Ubigeo[2],   /* ClfAux @CL @PV */
        FacCPedi.Ubigeo[3],   /* Auxiliar */
        FacCPedi.Ubigeo[1],   /* Sede */
        OUTPUT pUbigeo,
        OUTPUT pLongitud,
        OUTPUT pLatitud
        ).
    
    FIND TabDistr WHERE TabDistr.CodDepto = SUBSTRING(pUbigeo,1,2)
        AND TabDistr.CodProvi = SUBSTRING(pUbigeo,3,2)
        AND TabDistr.CodDistr = SUBSTRING(pUbigeo,5,2)
        NO-LOCK NO-ERROR.
    
    IF AVAILABLE TabDistr THEN tTT-rutad.ptodestino = TabDistr.NomDistr.

    FIND TabDepto WHERE TabDepto.CodDepto = SUBSTRING(pUbigeo,1,2) NO-LOCK NO-ERROR.
    
    IF AVAILABLE TabDepto THEN tTT-RutaD.Departamento = TabDepto.NomDepto.
    /**/
    
    TTT-RUTAD.LugEnt = fLugarEnt().
    
    TTT-RUTAD.Docs   = fDocumentos().
    TTT-RUTAD.Libre_c01 = string(Faccpedi.AcuBon[9]).   /*STRING(fBultos()).*/
    TTT-RUTAD.Libre_d01 = 0.
    TTT-RUTAD.Libre_d02 = 0.
    /*T-RUTAD.Libre_c01 = "".*/
    /* RHC 12/08/2021 Importes al TC venta de caja cobranzas */
    TTT-RUTAD.SKU = Faccpedi.Items.
    TTT-Rutad.Libre_d01 = Faccpedi.Peso.
    TTT-Rutad.Libre_d02 = Faccpedi.Volumen. /*Faccpedi.AcuBon[8].*/
    TTT-RUTAD.ImpCob = Faccpedi.AcuBon[8]. /*fImporte().*/
    
    /*
    FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
        T-RUTAD.SKU = T-RUTAD.SKU + 1.
        T-RUTAD.Libre_d01 = T-RUTAD.Libre_d01 + (Facdpedi.canped * Facdpedi.factor * almmmatg.pesmat).
        IF almmmatg.libre_d02 <> ? THEN T-RUTAD.Libre_d02 = T-RUTAD.Libre_d02 + (Facdpedi.canped * Facdpedi.Factor * (Almmmatg.libre_d02 / 1000000)).
    END.
    */
    TTT-RUTAD.Estado = fEstado().
    
    IF faccpedi.codcli = '20100047218' THEN DO:
        /* Es Grupo de Reparto */
        RUN Grupo-reparto IN hProc (INPUT Faccpedi.coddoc, 
                                    INPUT Faccpedi.nroped, /* O/D */
                                    OUTPUT x-DeliveryGroup, 
                                    OUTPUT x-InvoiCustomerGroup).       
        IF TRUE <> (x-DeliveryGroup > "") THEN DO:
            ttt-Rutad.libre_c02 = "ExtraOrdinario".
        END.
        ELSE DO:
            ttt-Rutad.libre_c02 = "Planificado".
        END.        
    END.

    IF CAN-FIND(LAST AlmCDocu WHERE AlmCDocu.CodCia = TTT-RUTAD.codcia AND
                AlmCDocu.CodLlave = s-CodDiv AND 
                AlmCDocu.CodDoc = TTT-RUTAD.Codref AND
                AlmCDocu.NroDoc = TTT-RUTAD.NroRef AND 
                AlmCDocu.FlgEst = "C" NO-LOCK)
        THEN TTT-RUTAD.Reprogramado = YES.
END.

DELETE PROCEDURE hProc.

DO WITH FRAME {&FRAME-NAME}:
    COMBO-BOX_FmaPgo:DELETE(COMBO-BOX_FmaPgo:LIST-ITEM-PAIRS).
    COMBO-BOX_FmaPgo:ADD-LAST('Todos','Todos').
    COMBO-BOX_FmaPgo = 'Todos'.
    FOR EACH ttT-RUTAD NO-LOCK,
        FIRST FacCPedi WHERE FacCPedi.CodCia = ttT-RUTAD.CodCia
        AND FacCPedi.CodDoc = ttT-RUTAD.CodRef
        AND FacCPedi.NroPed = ttT-RUTAD.NroRef NO-LOCK,
        FIRST gn-ConVt NO-LOCK WHERE gn-ConVt.Codig = Faccpedi.fmapgo
        BREAK BY Faccpedi.FmaPgo:
        IF FIRST-OF(Faccpedi.FmaPgo) THEN DO:
            COMBO-BOX_FmaPgo:ADD-LAST(gn-ConVt.Codig + " - " + gn-ConVt.Nombr , gn-ConVt.Codig).
        END.
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-borrar B-table-Win 
PROCEDURE Carga-Temporal-borrar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-RUTAD.

IF NOT AVAILABLE Di-RutaC THEN RETURN.

DEF VAR pUbigeo AS CHAR NO-UNDO.
DEF VAR pLongitud AS DEC NO-UNDO.
DEF VAR pLatitud AS DEC NO-UNDO.
DEF VAR pCuadrante AS CHAR NO-UNDO.

DEFINE VAR x-DeliveryGroup AS CHAR.
DEFINE VAR x-InvoiCustomerGroup AS CHAR.

DEFINE VAR hProc AS HANDLE NO-UNDO.             /* Handle Libreria */

RUN logis\logis-librerias.p PERSISTENT SET hProc.

FOR EACH Di-RutaD OF Di-RutaC NO-LOCK, 
    FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = Di-RutaD.codcia
    AND Faccpedi.coddoc = Di-RutaD.codref
    AND Faccpedi.nroped = Di-RutaD.nroref:
    CREATE T-RUTAD.
    BUFFER-COPY Di-RutaD EXCEPT Di-RutaD.ImpCob TO T-RUTAD.     /* OJO */

    /**/
    RUN logis/p-datos-sede-auxiliar.r (
        FacCPedi.Ubigeo[2],   /* ClfAux @CL @PV */
        FacCPedi.Ubigeo[3],   /* Auxiliar */
        FacCPedi.Ubigeo[1],   /* Sede */
        OUTPUT pUbigeo,
        OUTPUT pLongitud,
        OUTPUT pLatitud
        ).

    FIND TabDistr WHERE TabDistr.CodDepto = SUBSTRING(pUbigeo,1,2)
        AND TabDistr.CodProvi = SUBSTRING(pUbigeo,3,2)
        AND TabDistr.CodDistr = SUBSTRING(pUbigeo,5,2)
        NO-LOCK NO-ERROR.
    IF AVAILABLE TabDistr THEN t-rutad.ptodestino = TabDistr.NomDistr.
    FIND TabDepto WHERE TabDepto.CodDepto = SUBSTRING(pUbigeo,1,2) NO-LOCK NO-ERROR.
    IF AVAILABLE TabDepto THEN t-RutaD.Departamento = TabDepto.NomDepto.
    /**/
    T-RUTAD.LugEnt = fLugarEnt().
    T-RUTAD.Docs   = fDocumentos().
    T-RUTAD.Libre_c01 = string(Faccpedi.AcuBon[9]).   /*STRING(fBultos()).*/
    T-RUTAD.Libre_d01 = 0.
    T-RUTAD.Libre_d02 = 0.
    /*T-RUTAD.Libre_c01 = "".*/
    /* RHC 12/08/2021 Importes al TC venta de caja cobranzas */
    T-RUTAD.SKU = Faccpedi.Items.
    t-Rutad.Libre_d01 = Faccpedi.Peso.
    t-Rutad.Libre_d02 = Faccpedi.Volumen. /*Faccpedi.AcuBon[8].*/
    T-RUTAD.ImpCob = Faccpedi.AcuBon[8]. /*fImporte().*/
    /*
    FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
        T-RUTAD.SKU = T-RUTAD.SKU + 1.
        T-RUTAD.Libre_d01 = T-RUTAD.Libre_d01 + (Facdpedi.canped * Facdpedi.factor * almmmatg.pesmat).
        IF almmmatg.libre_d02 <> ? THEN T-RUTAD.Libre_d02 = T-RUTAD.Libre_d02 + (Facdpedi.canped * Facdpedi.Factor * (Almmmatg.libre_d02 / 1000000)).
    END.
    */
    T-RUTAD.Estado = fEstado().

    IF faccpedi.codcli = '20100047218' THEN DO:
        /* Es Grupo de Reparto */
        RUN Grupo-reparto IN hProc (INPUT Faccpedi.coddoc, 
                                    INPUT Faccpedi.nroped, /* O/D */
                                    OUTPUT x-DeliveryGroup, 
                                    OUTPUT x-InvoiCustomerGroup).       
        IF TRUE <> (x-DeliveryGroup > "") THEN DO:
            t-Rutad.libre_c02 = "ExtraOrdinario".
        END.
        ELSE DO:
            t-Rutad.libre_c02 = "Planificado".
        END.        
    END.

    IF CAN-FIND(LAST AlmCDocu WHERE AlmCDocu.CodCia = T-RUTAD.codcia AND
                AlmCDocu.CodLlave = s-CodDiv AND 
                AlmCDocu.CodDoc = T-RUTAD.Codref AND
                AlmCDocu.NroDoc = T-RUTAD.NroRef AND 
                AlmCDocu.FlgEst = "C" NO-LOCK)
        THEN T-RUTAD.Reprogramado = YES.
END.

DELETE PROCEDURE hProc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Disable-Columns B-table-Win 
PROCEDURE Disable-Columns :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR hBrowse AS HANDLE NO-UNDO.
DEF VAR hColumn AS HANDLE NO-UNDO.
DEF VAR iCounter AS INT NO-UNDO.

ASSIGN hBrowse = BROWSE {&BROWSE-NAME}:HANDLE.

DO iCounter = 1 TO hBrowse:NUM-COLUMNS:
    hColumn = hBrowse:GET-BROWSE-COLUMN(iCounter).
    hColumn:READ-ONLY = TRUE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF LOOKUP(DI-RutaC.FlgEst, 'C,A,L,PK') > 0 THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  

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
  DEF VAR s-Add-Record AS CHAR NO-UNDO.

  /* Bloqueamos DI-RutaC */
  FIND CURRENT DI-RutaC EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
  IF NOT AVAILABLE DI-RutaC THEN DO:
      RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
      UNDO, RETURN 'ADM-ERROR'.
  END.
  ASSIGN
      DI-RutaC.Libre_c05 = s-user-id
      DI-RutaC.Libre_f05 = TODAY.
  FIND CURRENT DI-RutaC NO-LOCK NO-ERROR.

  DEF BUFFER B-RutaD FOR DI-RutaD.
  DEF BUFFER B-RutaC FOR DI-RutaC.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  s-Add-Record = RETURN-VALUE.      /* 'YES' o 'NO' */
  IF s-Add-Record = 'YES' THEN DO:
      CREATE DI-RutaD.
  END.
  ELSE DO:
      FIND CURRENT DI-RutaD EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF NOT AVAILABLE DI-RutaD THEN DO:
          RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
          UNDO, RETURN 'ADM-ERROR'.
      END.
  END.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      T-RutaD.CodCia = DI-RutaC.CodCia
      T-RutaD.CodDiv = DI-RutaC.CodDiv
      T-RutaD.CodDoc = DI-RutaC.CodDoc
      T-RutaD.NroDoc = DI-RutaC.NroDoc
      NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
      RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
      UNDO, RETURN 'ADM-ERROR'.
  END.
  IF s-Add-Record = 'YES' THEN DO:  /* REGISTRO NUEVO */
      FIND FIRST FacCPedi WHERE FacCPedi.CodCia = T-RUTAD.CodCia
          AND FacCPedi.CodDoc = T-RUTAD.CodRef
          AND FacCPedi.NroPed = T-RUTAD.NroRef
          NO-LOCK NO-ERROR.
      T-RUTAD.LugEnt = fLugarEnt().
      T-RUTAD.Docs = fDocumentos().
      T-RUTAD.Libre_c01 = STRING(fBultos()).
      T-RUTAD.ImpCob = (IF Faccpedi.codmon = 2 THEN Faccpedi.TpoCmb * Faccpedi.ImpTot ELSE Faccpedi.ImpTot).
      ASSIGN
          T-RUTAD.SKU = 0
          T-RUTAD.Libre_d01 = 0
          T-RUTAD.Libre_d02 = 0.
      FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
          T-RUTAD.SKU = T-RUTAD.SKU + 1.
          T-RUTAD.Libre_d01 = T-RUTAD.Libre_d01 + (Facdpedi.canped * Facdpedi.factor * almmmatg.pesmat).
          IF almmmatg.libre_d02 <> ? THEN T-RUTAD.Libre_d02 = T-RUTAD.Libre_d02 + (Facdpedi.canped * Facdpedi.Factor * (Almmmatg.libre_d02 / 1000000)).
      END.
      IF Faccpedi.CodDoc = "OTR" THEN DO:
          ASSIGN
              T-RUTAD.ImpCob = 0.
          FOR EACH Facdpedi OF Faccpedi NO-LOCK:
              FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia 
                  AND AlmStkGe.codmat = Facdpedi.codmat 
                  AND AlmStkGe.fecha <= TODAY NO-LOCK NO-ERROR.
              T-RUTAD.ImpCob = T-RUTAD.ImpCob + (IF AVAILABLE AlmStkGe THEN 
                  AlmStkGe.CtoUni * Facdpedi.canped * Facdpedi.factor
                  ELSE 0).
          END.
      END.
      T-RUTAD.Estado = fEstado().
  END.
  /* ACTUALIZAMOS LA TABLA */
  BUFFER-COPY T-RutaD TO DI-RutaD.  
  FIND CURRENT DI-RutaD NO-LOCK NO-ERROR.
  /* NO debe estar repetido */
  FIND FIRST B-RutaD WHERE B-RutaD.CodCia = DI-RutaD.CodCia
      AND B-RutaD.CodDiv = DI-RutaD.CodDiv
      AND B-RutaD.CodDoc = DI-RutaD.CodDoc
      AND B-RutaD.NroDoc = DI-RutaD.NroDoc
      AND B-RutaD.CodRef = DI-RutaD.CodRef
      AND B-RutaD.NroRef = DI-RutaD.NroRef
      AND ROWID(B-RutaD)<> ROWID(DI-RutaD) 
      NO-LOCK NO-ERROR.
  IF AVAILABLE B-RutaD THEN DO:
      MESSAGE 'Documento repetido' VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  /* RHC 01/12/17 Validación de los topes */
  RUN Valida-Limites.
  IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
  
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
  DEF BUFFER B-RutaD FOR DI-RutaD.
  IF LOOKUP(DI-RutaC.FlgEst, 'C,A,L,PK') > 0 THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  /* Bloqueamos DI-RutaC */
  FIND CURRENT DI-RutaC EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE DI-RutaC THEN UNDO, RETURN 'ADM-ERROR'.
  ASSIGN
      DI-RutaC.Libre_c05 = s-user-id
      DI-RutaC.Libre_f05 = TODAY.
  /* Bloqueamos DI-RutaD */
  FIND B-RutaD WHERE ROWID(B-RutaD) = ROWID(DI-RutaD) EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE B-RutaD THEN UNDO, RETURN 'ADM-ERROR'.
  DELETE B-RutaD.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND CURRENT DI-RutaC NO-LOCK NO-ERROR.

  RUN Procesa-handle IN lh_handle ('Pinta-Cabecera').
  RUN Totales.

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
  RUN Carga-Temporal(INPUT-OUTPUT TABLE T-RUTAD, INPUT x-RowId).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Totales.

END PROCEDURE.

/*
FIND FIRST DI-RUTAC WHERE ROWID(DI-RUTAC) = pRowId NO-LOCK NO-ERROR.

/*RUN Carga-Temporal.*/
RUN Carga-Temporal (INPUT-OUTPUT TABLE T-RUTAD, INPUT pRowId).

*/

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
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-handle IN lh_handle ('Pinta-Cabecera').
  RUN Totales.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refrescar B-table-Win 
PROCEDURE refrescar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pRowId AS ROWID NO-UNDO.

FIND FIRST DI-RUTAC WHERE ROWID(DI-RUTAC) = pRowId NO-LOCK NO-ERROR.

/*RUN Carga-Temporal.*/
x-rowid = pRowId.
RUN Carga-Temporal (INPUT-OUTPUT TABLE T-RUTAD, INPUT pRowId).

RUN Totales.

{&open-query-br_table}

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
  {src/adm/template/snd-list.i "T-RUTAD"}
  {src/adm/template/snd-list.i "FacCPedi"}
  {src/adm/template/snd-list.i "GN-DIVI"}
  {src/adm/template/snd-list.i "DI-RutaD"}
  {src/adm/template/snd-list.i "gn-ConVt"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Totales B-table-Win 
PROCEDURE Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF BUFFER BT-RUTAD FOR T-RUTAD.

    FILL-IN-Importe = 0.
    FILL-IN-Peso = 0.
    FILL-IN-Volumen = 0.

    FOR EACH BT-RUTAD NO-LOCK,
        FIRST FacCPedi NO-LOCK WHERE FacCPedi.CodCia = BT-RUTAD.CodCia
        AND FacCPedi.CodDoc = BT-RUTAD.CodRef
        AND FacCPedi.NroPed = BT-RUTAD.NroRef
        AND (COMBO-BOX_FmaPgo = 'Todos' OR FacCPedi.FmaPgo = COMBO-BOX_FmaPgo):
        FILL-IN-Peso = FILL-IN-Peso + BT-RUTAD.Libre_d01.
        FILL-IN-Volumen = FILL-IN-Volumen + BT-RUTAD.Libre_d02.
        FILL-IN-Importe = FILL-IN-Importe + BT-RUTAD.ImpCob.
    END.
    DISPLAY
        FILL-IN-Importe FILL-IN-Peso FILL-IN-Volumen WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Solo se CREAN registro, NO se modifican
------------------------------------------------------------------------------*/

DEF BUFFER B-CPEDI FOR Faccpedi.
DEF BUFFER B-DIVI  FOR GN-DIVI.

/* Consistencia de la O/D OTR */
FIND B-CPEDI WHERE B-CPEDI.codcia = s-codcia
    AND B-CPEDI.coddoc = T-RUTAD.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    AND B-CPEDI.nroped = T-RUTAD.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    AND LOOKUP(B-CPEDI.FlgEst, 'P,C') > 0
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CPEDI THEN DO:
    MESSAGE 'Documento NO válido, debe tener el estado en P o C' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO T-RUTAD.CodRef.
    RETURN 'ADM-ERROR'.
END.
FIND FIRST B-DIVI WHERE B-DIVI.CodCia = s-codcia 
    AND B-DIVI.CodDiv = B-CPEDI.CodDiv
    AND B-DIVI.Campo-Log[1] = NO
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-DIVI THEN DO:
    MESSAGE 'Documento NO válido, revise la division' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO T-RUTAD.CodRef.
    RETURN 'ADM-ERROR'.
END.
/* **************************************************************** */
/* SOLO SE VAN A ACEPTAR O/D OTR QUE NO TENGAN HISTORIAL EN UNA PHR */
/* **************************************************************** */
DEF BUFFER B-RutaD FOR Di-RutaD.
DEF BUFFER B-RutaC FOR Di-RutaC.
FOR EACH B-RutaD NO-LOCK WHERE B-RutaD.codcia = s-codcia AND
    B-RutaD.coddiv = s-coddiv AND
    B-RutaD.coddoc = "PHR" AND
    B-RutaD.codref = B-CPEDI.coddoc AND
    B-RutaD.nroref = B-CPEDI.nroped,
    FIRST B-RutaC OF B-RutaD NO-LOCK WHERE B-RutaC.FlgEst <> "A":
    /* Cabecera */
    IF B-RutaC.FlgEst BEGINS "P" THEN DO:   /* NO debe estar en una PHR en PROCESO */
        MESSAGE 'Documento NO válido, se encuentra en esta H/R ' + B-RutaC.nrodoc VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO T-RUTAD.CodRef.
        RETURN 'ADM-ERROR'.
    END.
    /* Detalle */
    IF B-RutaD.FlgEst = "A" THEN NEXT.      /* ANulado en otra PHR */
    /* Si está REPROGRAMADO se acepta, caso contrario no pasa */
    IF B-RutaD.FlgEst <> "R" THEN DO:  /* Otra Orden */
        MESSAGE "Documento NO válido, el documento (" + B-RutaD.codref + "-" + B-RutaD.nroref + ") no  esta REPROGRAMADO" VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO T-RUTAD.CodRef.
        RETURN 'ADM-ERROR'.
    END.
END.


RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-Limites B-table-Win 
PROCEDURE Valida-Limites :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   IF DI-RutaC.Libre_d01 = 0 AND DI-RutaC.Libre_d02 = 0 AND DI-RutaC.Libre_d03 = 0 
       THEN RETURN "OK".
   
   /* Consistencia de límites */
   DEF VAR x-Peso AS DEC NO-UNDO.
   DEF VAR x-Volumen AS DEC NO-UNDO.
   DEF VAR x-Destinos AS DEC NO-UNDO.

   ASSIGN
       x-Peso = 0
       x-Volumen = 0
       x-Destinos = 0.

   DEF BUFFER BT-RUTAD FOR T-RUTAD.
   DEF BUFFER B-CPEDI  FOR Faccpedi.

   FOR EACH BT-RUTAD NO-LOCK, FIRST B-CPEDI NO-LOCK WHERE B-CPEDI.codcia = BT-RUTAD.codcia
       AND B-CPEDI.coddoc = BT-RUTAD.codref
       AND B-CPEDI.nroped = BT-RUTAD.nroref
       BREAK BY B-CPEDI.CodCli:
       x-Peso = x-Peso + BT-RUTAD.Libre_d01.
       x-Volumen = x-Volumen + BT-RUTAD.Libre_d02.
       IF FIRST-OF(B-CPEDI.CodCli) THEN x-Destinos = x-Destinos + 1.
   END.
   IF DI-RutaC.Libre_d02 > 0 AND x-Peso > DI-RutaC.Libre_d02 THEN DO:
       MESSAGE 'Supera el tope máximo de peso' VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
   END.
   IF DI-RutaC.Libre_d03 > 0 AND x-Volumen > DI-RutaC.Libre_d03 THEN DO:
       MESSAGE 'Supera el tope máximo de volumen' VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
   END.
   IF DI-RutaC.Libre_d01 > 0 AND x-Destinos > DI-RutaC.Libre_d01 THEN DO:
       MESSAGE 'Supera el tope máximo de clientes' VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
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
MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fBultos B-table-Win 
FUNCTION fBultos RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Bultos AS INT NO-UNDO.

  RUN logis/p-numero-de-bultos (s-CodDiv, Faccpedi.CodDoc, Faccpedi.NroPed, OUTPUT x-Bultos).

/*   FIND FIRST CcbCBult WHERE CcbCBult.CodCia = Faccpedi.codcia                */
/*       AND CcbCBult.CodDoc = Faccpedi.CodDoc                                  */
/*       AND CcbCBult.NroDoc = Faccpedi.NroPed                                  */
/*       AND CcbCBult.CHR_01 = "P"                     /* H/R Aún NO cerrada */ */
/*       NO-LOCK NO-ERROR.                                                      */
/*   IF AVAILABLE CcbCBult THEN x-Bultos = CcbCBult.Bultos.                     */
  RETURN x-Bultos.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDescripcion B-table-Win 
FUNCTION fDescripcion RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF NOT AVAILABLE gn-ConVt THEN RETURN 'TRANSFERENCIA'.
  
  RETURN gn-ConVt.Nombr.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDocumentos B-table-Win 
FUNCTION fDocumentos RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-NroDocs AS INT NO-UNDO.
  DEF BUFFER PEDIDO FOR Faccpedi.

  CASE FacCPedi.CodDoc:
      WHEN "O/M" OR WHEN "O/D" THEN DO:
          /* Buscamos del PEDido: Puede ser del cliente o del 1er. tramo */
          FIND PEDIDO WHERE PEDIDO.codcia = FacCPedi.codcia
              AND PEDIDO.coddoc = FacCPedi.codref
              AND PEDIDO.nroped = FacCPedi.nroref
              AND PEDIDO.codpos > ''
              NO-LOCK NO-ERROR.
          IF AVAILABLE PEDIDO THEN DO:
              /* Contamos cuantas guias de remisión están relacionadas */
              FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Faccpedi.codcia
                  AND Ccbcdocu.codped = PEDIDO.coddoc
                  AND Ccbcdocu.nroped = PEDIDO.nroped:
                  IF Ccbcdocu.coddiv = s-coddiv
                      AND Ccbcdocu.coddoc = 'G/R'
                      AND Ccbcdocu.flgest <> 'A'
                      THEN x-NroDocs = x-NroDocs + 1.
              END.
          END.
      END.
      WHEN "OTR" THEN DO:
          /* Contamos cuantas guias de remisión están relacionadas */
          FOR EACH Almcmov NO-LOCK WHERE Almcmov.codcia = 1 
              AND Almcmov.codref = FacCPedi.coddoc
              AND Almcmov.nroref = FacCPedi.nroped:
              IF Almcmov.tipmov = 'S' 
                  AND Almcmov.codmov = 03
                  AND Almcmov.flgest <> 'A'
                  THEN x-NroDocs = x-NroDocs + 1.
          END.
      END.
  END CASE.
  RETURN x-NroDocs.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR cEstado AS CHAR NO-UNDO.

  cEstado = 'Aprobado'.
  CASE Faccpedi.CodDoc:
      WHEN "O/D" OR WHEN "O/M" OR WHEN "OTR" THEN DO:
          IF Faccpedi.usrImpOD > '' THEN cEstado = 'Impreso'.
          IF Faccpedi.FlgSit = "P" THEN cEstado = "Picking Terminado".
          IF Faccpedi.FlgSit = "C" THEN cEstado = "Checking Terminado".
          IF Faccpedi.FlgEst = "C" THEN cEstado = "Documentado".
      END.
  END CASE.
  RETURN cEstado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fImporte B-table-Win 
FUNCTION fImporte RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR x-Importe AS DEC NO-UNDO.

      IF Faccpedi.CodDoc = "OTR" THEN DO:
          FOR EACH Facdpedi OF Faccpedi NO-LOCK:
              FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia 
                  AND AlmStkGe.codmat = Facdpedi.codmat 
                  AND AlmStkGe.fecha <= TODAY NO-LOCK NO-ERROR.
              IF AVAILABLE AlmStkGe THEN
                  x-Importe = x-Importe + (AlmStkGe.CtoUni * Facdpedi.canped * Facdpedi.factor).
          END.
      END.
      ELSE DO:
          /* RHC 12/08/2021: Se va a tomar el tipo de cambio venta de caja cobranza */
          FIND LAST Gn-tccja WHERE Gn-tccja.fecha <= Faccpedi.FchPed NO-LOCK NO-ERROR.
          IF AVAILABLE Gn-tccja THEN
              x-Importe = x-Importe + (IF Faccpedi.codmon = 2 THEN Gn-tccja.venta * Faccpedi.ImpTot ELSE Faccpedi.ImpTot).
          ELSE 
              x-Importe = x-Importe + (IF Faccpedi.codmon = 2 THEN Faccpedi.TpoCmb * Faccpedi.ImpTot ELSE Faccpedi.ImpTot).
      END.
  RETURN x-Importe.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fLiquidacion B-table-Win 
FUNCTION fLiquidacion RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF Faccpedi.coddoc = "OTR" THEN RETURN "".

  DEF VAR x-Texto AS CHAR NO-UNDO.
  DEF VAR x-Importe AS  DECI NO-UNDO.

  /* Buscamos comprobantes */
  DEF BUFFER COMPROBANTES FOR Ccbcdocu.
  FOR EACH COMPROBANTES NO-LOCK WHERE COMPROBANTES.codcia = s-codcia AND
      COMPROBANTES.codped = Faccpedi.codref AND
      COMPROBANTES.nroped = Faccpedi.nroref AND
      COMPROBANTES.flgest <> "A",
      EACH Ccbdcaja NO-LOCK WHERE Ccbdcaja.codcia = s-codcia AND
      Ccbdcaja.codref = COMPROBANTES.coddoc AND
      Ccbdcaja.nroref = COMPROBANTES.nrodoc:
      x-Importe = x-Importe + Ccbdcaja.imptot.
      x-Texto = (IF COMPROBANTES.FlgEst = "C" THEN "CANCELADO, " ELSE "NO CANCELADO, ") +
                "LIQUIDADO " + TRIM(STRING(x-Importe, '-ZZZ,ZZZ,ZZ9.99')).
  END.

  RETURN x-Texto.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fLugarEnt B-table-Win 
FUNCTION fLugarEnt RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
/*
  DEF VAR pCodDpto AS CHAR NO-UNDO.
  DEF VAR pCodProv AS CHAR NO-UNDO.
  DEF VAR pCodDist AS CHAR NO-UNDO.
  DEF VAR pCodPos  AS CHAR NO-UNDO.
  DEF VAR pZona    AS CHAR NO-UNDO.
  DEF VAR pSubZona AS CHAR NO-UNDO.

  RUN gn/fUbigeo (
      Faccpedi.CodDiv, 
      Faccpedi.CodDoc,
      Faccpedi.NroPed,
      OUTPUT pCodDpto,
      OUTPUT pCodProv,
      OUTPUT pCodDist,
      OUTPUT pCodPos,
      OUTPUT pZona,
      OUTPUT pSubZona
      ).
  FIND TabDistr WHERE TabDistr.CodDepto = pCodDpto
      AND TabDistr.CodProvi = pCodProv
      AND TabDistr.CodDistr = pCodDist
      NO-LOCK NO-ERROR.
    IF AVAILABLE TabDistr THEN RETURN TabDistr.NomDistr.
    ELSE RETURN "".
*/
    DEF VAR x-LugEnt AS CHAR NO-UNDO.

    IF NOT AVAILABLE Faccpedi THEN RETURN x-LugEnt.

    RUN logis/p-lugar-de-entrega (FacCPedi.CodDoc,
                                  FacCPedi.NroPed,
                                  OUTPUT x-LugEnt).
    IF NUM-ENTRIES(x-LugEnt,'|') > 1 THEN x-LugEnt = ENTRY(2,x-LugEnt,'|').

    RETURN x-LugEnt.

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

  DEF VAR x-Pesos AS DEC NO-UNDO.

  FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
      x-Pesos = x-Pesos + (Facdpedi.canped * Facdpedi.factor * almmmatg.pesmat).
  END.
  RETURN x-Pesos.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSKU B-table-Win 
FUNCTION fSKU RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-SKU AS INT NO-UNDO.

  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      x-SKU = x-SKU + 1.
  END.
  RETURN x-SKU.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fVolumen B-table-Win 
FUNCTION fVolumen RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Volumen AS DEC NO-UNDO.

  FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
      IF almmmatg.libre_d02 <> ? THEN x-Volumen = x-Volumen + (Facdpedi.canped * Facdpedi.Factor * (Almmmatg.libre_d02 / 1000000)).
  END.
  RETURN x-Volumen.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

