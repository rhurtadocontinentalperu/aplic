&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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

DEFINE SHARED VAR s-codcia AS INT.

DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nrodoc AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacDPedi

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 FacDPedi.codmat FacDPedi.AftIgv ~
FacDPedi.cTipoAfectacion FacDPedi.CanPed FacDPedi.PreUni ~
FacDPedi.Por_Dsctos[1] FacDPedi.Por_Dsctos[2] FacDPedi.Por_Dsctos[3] ~
FacDPedi.ImpDto FacDPedi.PorDto2 FacDPedi.ImpDto2 FacDPedi.ImpIgv ~
FacDPedi.ImpLin FacDPedi.cPreUniSinImpuesto FacDPedi.FactorDescuento ~
FacDPedi.TasaIGV FacDPedi.ImporteUnitarioSinImpuesto ~
FacDPedi.ImporteReferencial FacDPedi.ImporteBaseDescuento ~
FacDPedi.ImporteDescuento FacDPedi.ImporteTotalSinImpuesto ~
FacDPedi.MontoBaseIGV FacDPedi.ImporteIGV FacDPedi.ImporteTotalImpuestos ~
FacDPedi.ImporteUnitarioConImpuesto FacDPedi.cImporteVentaExonerado ~
FacDPedi.cImporteVentaGratuito FacDPedi.cSumaImpteTotalSinImpuesto ~
FacDPedi.cMontoBaseIGV FacDPedi.cSumaIGV FacDPedi.cOtrosTributosOpGratuito ~
FacDPedi.ImpuestoBolsaPlastico FacDPedi.MontoTributoBolsaPlastico ~
FacDPedi.MontoUnitarioBolsaPlastico 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH FacDPedi ~
      WHERE facdpedi.codcia = 1 and  ~
facdpedi.coddoc = x-coddoc and  ~
facdpedi.nroped = x-nrodoc NO-LOCK ~
    BY FacDPedi.codmat INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH FacDPedi ~
      WHERE facdpedi.codcia = 1 and  ~
facdpedi.coddoc = x-coddoc and  ~
facdpedi.nroped = x-nrodoc NO-LOCK ~
    BY FacDPedi.codmat INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 FacDPedi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 FacDPedi


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-NroDoc RADIO-SET-proceso ~
COMBO-BOX-coddoc BUTTON-1 BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NroDoc RADIO-SET-proceso ~
COMBO-BOX-coddoc 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-testeo-importes-sunat AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Procesar" 
     SIZE 14 BY .96.

DEFINE VARIABLE COMBO-BOX-coddoc AS CHARACTER FORMAT "X(50)":U INITIAL "COT" 
     LABEL "Tipo Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Pedido comercial","COT",
                     "Pedido logistico","PED",
                     "Pedido mostrador","P/M",
                     "Orden despacho","O/D",
                     "Orden mostrador","O/M.",
                     "Factura","FAC",
                     "Boleta","BOL",
                     "Nota de Credito","N/C",
                     "Nota de Debito","N/D"
     DROP-DOWN-LIST
     SIZE 24 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "X(15)":U 
     LABEL "No. de documento" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-proceso AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Calcular", 1,
"Visualizar", 2
     SIZE 22 BY .96 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      FacDPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      FacDPedi.codmat FORMAT "X(6)":U WIDTH 7.43
      FacDPedi.AftIgv FORMAT "Si/No":U
      FacDPedi.cTipoAfectacion FORMAT "x(25)":U WIDTH 14.86
      FacDPedi.CanPed FORMAT ">,>>>,>>9.9999":U WIDTH 8
      FacDPedi.PreUni FORMAT ">,>>>,>>9.999999":U WIDTH 9.43
      FacDPedi.Por_Dsctos[1] FORMAT "->,>>9.9999":U WIDTH 7.43
      FacDPedi.Por_Dsctos[2] FORMAT "->,>>9.9999":U WIDTH 6.43
      FacDPedi.Por_Dsctos[3] FORMAT "->,>>9.9999":U WIDTH 6.43
      FacDPedi.ImpDto FORMAT ">,>>>,>>9.99":U WIDTH 8.43
      FacDPedi.PorDto2 COLUMN-LABEL "% Dscto!Encarte." FORMAT ">>9.9999":U
      FacDPedi.ImpDto2 COLUMN-LABEL "Impte Dscto!Encarte" FORMAT ">,>>>,>>9.99":U
      FacDPedi.ImpIgv COLUMN-LABEL "Importe! Igv" FORMAT ">,>>>,>>9.99":U
            WIDTH 8.43
      FacDPedi.ImpLin FORMAT "->>,>>>,>>9.99":U WIDTH 8.43
      FacDPedi.cPreUniSinImpuesto COLUMN-LABEL "PreUni!Sin Impsto" FORMAT ">,>>>,>>9.9999":U
            WIDTH 8.14
      FacDPedi.FactorDescuento COLUMN-LABEL "Factor!Descuento" FORMAT ">>9.99999":U
            WIDTH 8.43
      FacDPedi.TasaIGV FORMAT ">>9.99999":U
      FacDPedi.ImporteUnitarioSinImpuesto COLUMN-LABEL "ImporteUnitario!SinImpuesto" FORMAT ">>>,>>>,>>9.9999":U
            WIDTH 10.14
      FacDPedi.ImporteReferencial COLUMN-LABEL "Importe!Referencial" FORMAT ">>>,>>>,>>9.99":U
            WIDTH 8.43
      FacDPedi.ImporteBaseDescuento COLUMN-LABEL "Importe Base!Descuento" FORMAT ">>>,>>>,>>9.99":U
            WIDTH 10.14
      FacDPedi.ImporteDescuento COLUMN-LABEL "Importe!Descuento" FORMAT ">>>,>>>,>>9.99":U
            WIDTH 10.43
      FacDPedi.ImporteTotalSinImpuesto COLUMN-LABEL "ImporteTotal!SinImpuesto" FORMAT ">>>,>>>,>>9.99":U
      FacDPedi.MontoBaseIGV COLUMN-LABEL "MontoBase!IGV" FORMAT ">>>,>>>,>>9.99":U
            WIDTH 9.14
      FacDPedi.ImporteIGV FORMAT ">>>,>>>,>>9.99":U WIDTH 9.43
      FacDPedi.ImporteTotalImpuestos COLUMN-LABEL "ImporteTotal!Impuestos" FORMAT ">>>,>>>,>>9.99":U
            WIDTH 9.43
      FacDPedi.ImporteUnitarioConImpuesto COLUMN-LABEL "ImporteUnitario!ConImpuesto" FORMAT ">>>,>>>,>>9.9999":U
            WIDTH 10
      FacDPedi.cImporteVentaExonerado COLUMN-LABEL "cImporteVenta!Exonerado" FORMAT ">>>,>>>,>>9.9999":U
            WIDTH 10.43
      FacDPedi.cImporteVentaGratuito COLUMN-LABEL "cImporte!VentaGratuito" FORMAT ">>>,>>>,>>9.9999":U
            WIDTH 10.43
      FacDPedi.cSumaImpteTotalSinImpuesto COLUMN-LABEL "cSumaImpte!TotalSinImpuesto" FORMAT ">>>,>>>,>>9.99":U
      FacDPedi.cMontoBaseIGV FORMAT ">>>,>>>,>>9.99":U
      FacDPedi.cSumaIGV FORMAT ">>>,>>>,>>9.99":U WIDTH 9.43
      FacDPedi.cOtrosTributosOpGratuito COLUMN-LABEL "cOtrosTributos!OpGratuito" FORMAT ">>>,>>>,>>9.99":U
      FacDPedi.ImpuestoBolsaPlastico COLUMN-LABEL "Impuesto!BolsaPlastico" FORMAT ">>>,>>>,>>9.99":U
            WIDTH 9.43
      FacDPedi.MontoTributoBolsaPlastico COLUMN-LABEL "MontoTributo!BolsaPlastico" FORMAT ">>>,>>>,>>9.99":U
            WIDTH 9.14
      FacDPedi.MontoUnitarioBolsaPlastico COLUMN-LABEL "MontoUnitario!BolsaPlastico" FORMAT ">>>,>>>,>>9.9999":U
            WIDTH 9.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 150 BY 13.85
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-NroDoc AT ROW 1.31 COL 61 COLON-ALIGNED WIDGET-ID 2
     RADIO-SET-proceso AT ROW 1.35 COL 79 NO-LABEL WIDGET-ID 6
     COMBO-BOX-coddoc AT ROW 1.38 COL 19 COLON-ALIGNED WIDGET-ID 4
     BUTTON-1 AT ROW 1.38 COL 105 WIDGET-ID 10
     BROWSE-2 AT ROW 13.69 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 152.86 BY 26.88
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Testeador"
         HEIGHT             = 26.88
         WIDTH              = 152.86
         MAX-HEIGHT         = 26.88
         MAX-WIDTH          = 152.86
         VIRTUAL-HEIGHT     = 26.88
         VIRTUAL-WIDTH      = 152.86
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 BUTTON-1 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.FacDPedi"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "INTEGRAL.FacDPedi.codmat|yes"
     _Where[1]         = "facdpedi.codcia = 1 and 
facdpedi.coddoc = x-coddoc and 
facdpedi.nroped = x-nrodoc"
     _FldNameList[1]   > INTEGRAL.FacDPedi.codmat
"FacDPedi.codmat" ? ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.FacDPedi.AftIgv
     _FldNameList[3]   > INTEGRAL.FacDPedi.cTipoAfectacion
"FacDPedi.cTipoAfectacion" ? ? "character" ? ? ? ? ? ? no ? no no "14.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacDPedi.CanPed
"FacDPedi.CanPed" ? ? "decimal" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacDPedi.PreUni
"FacDPedi.PreUni" ? ? "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacDPedi.Por_Dsctos[1]
"FacDPedi.Por_Dsctos[1]" ? "->,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.FacDPedi.Por_Dsctos[2]
"FacDPedi.Por_Dsctos[2]" ? "->,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.FacDPedi.Por_Dsctos[3]
"FacDPedi.Por_Dsctos[3]" ? "->,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.FacDPedi.ImpDto
"FacDPedi.ImpDto" ? ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.FacDPedi.PorDto2
"FacDPedi.PorDto2" "% Dscto!Encarte." ">>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.FacDPedi.ImpDto2
"FacDPedi.ImpDto2" "Impte Dscto!Encarte" ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.FacDPedi.ImpIgv
"FacDPedi.ImpIgv" "Importe! Igv" ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > INTEGRAL.FacDPedi.ImpLin
"FacDPedi.ImpLin" ? ? "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > INTEGRAL.FacDPedi.cPreUniSinImpuesto
"FacDPedi.cPreUniSinImpuesto" "PreUni!Sin Impsto" ">,>>>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "8.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > INTEGRAL.FacDPedi.FactorDescuento
"FacDPedi.FactorDescuento" "Factor!Descuento" ? "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   = INTEGRAL.FacDPedi.TasaIGV
     _FldNameList[17]   > INTEGRAL.FacDPedi.ImporteUnitarioSinImpuesto
"FacDPedi.ImporteUnitarioSinImpuesto" "ImporteUnitario!SinImpuesto" ">>>,>>>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > INTEGRAL.FacDPedi.ImporteReferencial
"FacDPedi.ImporteReferencial" "Importe!Referencial" ">>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > INTEGRAL.FacDPedi.ImporteBaseDescuento
"FacDPedi.ImporteBaseDescuento" "Importe Base!Descuento" ">>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > INTEGRAL.FacDPedi.ImporteDescuento
"FacDPedi.ImporteDescuento" "Importe!Descuento" ">>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > INTEGRAL.FacDPedi.ImporteTotalSinImpuesto
"FacDPedi.ImporteTotalSinImpuesto" "ImporteTotal!SinImpuesto" ">>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > INTEGRAL.FacDPedi.MontoBaseIGV
"FacDPedi.MontoBaseIGV" "MontoBase!IGV" ">>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > INTEGRAL.FacDPedi.ImporteIGV
"FacDPedi.ImporteIGV" ? ">>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   > INTEGRAL.FacDPedi.ImporteTotalImpuestos
"FacDPedi.ImporteTotalImpuestos" "ImporteTotal!Impuestos" ">>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   > INTEGRAL.FacDPedi.ImporteUnitarioConImpuesto
"FacDPedi.ImporteUnitarioConImpuesto" "ImporteUnitario!ConImpuesto" ">>>,>>>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[26]   > INTEGRAL.FacDPedi.cImporteVentaExonerado
"FacDPedi.cImporteVentaExonerado" "cImporteVenta!Exonerado" ? "decimal" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[27]   > INTEGRAL.FacDPedi.cImporteVentaGratuito
"FacDPedi.cImporteVentaGratuito" "cImporte!VentaGratuito" ? "decimal" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[28]   > INTEGRAL.FacDPedi.cSumaImpteTotalSinImpuesto
"FacDPedi.cSumaImpteTotalSinImpuesto" "cSumaImpte!TotalSinImpuesto" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[29]   = INTEGRAL.FacDPedi.cMontoBaseIGV
     _FldNameList[30]   > INTEGRAL.FacDPedi.cSumaIGV
"FacDPedi.cSumaIGV" ? ? "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[31]   > INTEGRAL.FacDPedi.cOtrosTributosOpGratuito
"FacDPedi.cOtrosTributosOpGratuito" "cOtrosTributos!OpGratuito" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[32]   > INTEGRAL.FacDPedi.ImpuestoBolsaPlastico
"FacDPedi.ImpuestoBolsaPlastico" "Impuesto!BolsaPlastico" ? "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[33]   > INTEGRAL.FacDPedi.MontoTributoBolsaPlastico
"FacDPedi.MontoTributoBolsaPlastico" "MontoTributo!BolsaPlastico" ? "decimal" ? ? ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[34]   > INTEGRAL.FacDPedi.MontoUnitarioBolsaPlastico
"FacDPedi.MontoUnitarioBolsaPlastico" "MontoUnitario!BolsaPlastico" ? "decimal" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Testeador */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Testeador */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Procesar */
DO:

    DEFINE VAR x-retval AS CHAR.

    ASSIGN combo-box-coddoc fill-in-nrodoc radio-set-proceso.

    x-coddoc = "combo-box-coddoc".
    x-nrodoc = "fill-in-nrodoc".
    /*
    MESSAGE "combo-box-coddoc " combo-box-coddoc SKIP
            "fill-in-nrodoc " fill-in-nrodoc.
    */
    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND 
                                faccpedi.coddoc = combo-box-coddoc AND
                                faccpedi.nroped = fill-in-nrodoc NO-LOCK NO-ERROR.
    IF AVAILABLE faccpedi  THEN DO:        
    
        x-RetVal = "OK".
        IF radio-set-proceso = 1 THEN DO:
            DEFINE VAR hProc AS HANDLE NO-UNDO.         /* Handle Libreria */

            RUN sunat\sunat-calculo-importes.p PERSISTENT SET hProc.

            /* Procedimientos */
            IF LOOKUP(combo-box-coddoc,"FAC,BOL,N/C,N/D") > 0 THEN DO:
                RUN tabla-ccbcdocu IN hProc (INPUT "", INPUT combo-box-coddoc, INPUT fill-in-nrodoc,
                                            OUTPUT x-RetVal).       
            END.
            ELSE DO:
                RUN tabla-faccpedi IN hProc (INPUT "", INPUT combo-box-coddoc, INPUT fill-in-nrodoc,
                                            OUTPUT x-RetVal).       
            END.
            DELETE PROCEDURE hProc.                     /* Release Libreria */            
        END.
        IF x-retval = "OK" THEN DO:
            RUN buscar-documento IN h_b-testeo-importes-sunat (INPUT combo-box-coddoc, INPUT fill-in-nrodoc).        
            RUN dispatch IN h_b-testeo-importes-sunat ('adm-view':U).
            browse-2:VISIBLE = YES.

            x-coddoc = combo-box-coddoc.
            x-nrodoc = fill-in-nrodoc.
        END.
        ELSE DO:
            MESSAGE "ERROR" SKIP
                    x-retval.
        END.
    END.
    ELSE DO:        
        RUN dispatch IN h_b-testeo-importes-sunat ('hide':U).
    END.

    {&OPEN-QUERY-BROWSE-2}

 
    /*
    

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN dispatch IN h_b-rbte-config-linea-movimiento ('adm-view':U)
      */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroDoc W-Win
ON ENTRY OF FILL-IN-NroDoc IN FRAME F-Main /* No. de documento */
DO:
  RUN dispatch IN h_b-testeo-importes-sunat ('hide':U).
  browse-2:VISIBLE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-proceso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-proceso W-Win
ON VALUE-CHANGED OF RADIO-SET-proceso IN FRAME F-Main
DO:
    RUN dispatch IN h_b-testeo-importes-sunat ('hide':U).
    browse-2:VISIBLE = NO.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'Sunat/b-testeo-importes-sunat.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-testeo-importes-sunat ).
       RUN set-position IN h_b-testeo-importes-sunat ( 2.31 , 2.29 ) NO-ERROR.
       /* Size in UIB:  ( 11.12 , 107.29 ) */

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-testeo-importes-sunat ,
             BUTTON-1:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY FILL-IN-NroDoc RADIO-SET-proceso COMBO-BOX-coddoc 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-NroDoc RADIO-SET-proceso COMBO-BOX-coddoc BUTTON-1 BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "FacDPedi"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

