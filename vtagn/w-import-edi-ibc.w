&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE CPEDI NO-UNDO LIKE FacCPedi.
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE TEMP-TABLE ITEM-2 LIKE FacDPedi.



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
DEF INPUT PARAMETER pParam AS CHAR.

IF NUM-ENTRIES(pParam) <> 2 THEN RETURN ERROR.
/* Sintaxi: S,1 
    S: s-TpoPed, en este caso Canal Moderno
    1: Tipo, dominio de valores = (1,3)
*/    

DEF VAR s-TpoPed     AS CHAR NO-UNDO.
DEF VAR s-Import-IBC AS LOG  INIT NO NO-UNDO.
DEF VAR s-Import-B2B AS LOG  INIT NO NO-UNDO.

s-TpoPed = ENTRY(1,pParam).
CASE TRUE:
    WHEN ENTRY(2,pParam) = "1" THEN s-Import-IBC = YES.   /* Archivo Excel Plaza Vea */
    WHEN ENTRY(2,pParam) = "3" THEN s-Import-B2B = YES.   /* Archivo Texto Tottus (OC y Packing List) */
    OTHERWISE RETURN ERROR.
END CASE.

/* Parameters Definitions ---                                           */
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-CodDiv AS CHAR.
DEF VAR pCodDiv AS CHAR NO-UNDO.

pCodDiv = s-CodDiv.

DEF NEW SHARED VAR s-CodCli AS CHAR.
DEF NEW SHARED VAR s-CodMon AS INTE.
DEF NEW SHARED VAR s-TpoCmb AS DECI.

DEF VAR s-CodAlm AS CHAR NO-UNDO.
DEF VAR s-CodDoc AS CHAR INIT 'COT' NO-UNDO.
DEF VAR s-NroSer AS INTE NO-UNDO.
DEF VAR s-cndvta-validos AS CHAR NO-UNDO.
DEF VAR s-FmaPgo AS CHAR NO-UNDO.
DEF VAR S-CMPBNTE AS CHAR NO-UNDO.
DEF VAR s-PorIgv AS DECI NO-UNDO.
DEF VAR s-FlgIgv AS LOG NO-UNDO.
DEF VAR s-NroDec AS INTE NO-UNDO.
DEF VAR s-CodVen AS CHAR NO-UNDO.

DEF NEW SHARED VAR lh_handle AS HANDLE.

/* NO Almacenes de Remate */
FOR EACH VtaAlmDiv NO-LOCK WHERE Vtaalmdiv.codcia = s-codcia
    AND Vtaalmdiv.coddiv = pCodDiv,
    FIRST Almacen OF Vtaalmdiv NO-LOCK WHERE Almacen.Campo-C[3] <> 'Si'
    BY VtaAlmDiv.Orden:
    IF s-CodAlm = "" THEN s-CodAlm = TRIM(VtaAlmDiv.CodAlm).
    ELSE s-CodAlm = s-CodAlm + "," + TRIM(VtaAlmDiv.CodAlm).
END.

/* **************************************** */
/* RHC 22/07/2020 Nuevo bloqueo de clientes */
/* **************************************** */
/* RUN pri/p-verifica-cliente.r (INPUT s-CodCli,    */
/*                               INPUT s-CodDoc,    */
/*                               INPUT s-CodDiv).   */
/* IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN ERROR. */
/* **************************************** */


DEF VAR s-DiasVtoCot AS INTE NO-UNDO.
DEF VAR s-MinimoDiasDespacho AS INTE NO-UNDO.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = pCodDiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    MESSAGE 'División' pCodDiv 'NO configurada' VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.
ASSIGN
    s-DiasVtoCot = GN-DIVI.DiasVtoCot
    s-MinimoDiasDespacho = GN-DIVI.Campo-Dec[3]
    .

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK.
ASSIGN
    s-CodMon = 1
    s-NroDec = 5
    s-PorIgv = FacCfgGn.PorIgv
    s-FlgIgv = YES.

DEF VAR x-articulo-ICBPer AS CHAR INIT '099268'.


/* ************************************************************************* */
/* VARIABLES PARA SUPERMERCADOS */
/* ************************************************************************* */
/* 03Oct2014 - Plaza Vea cambio B2B*/
DEF TEMP-TABLE tt-OrdenesPlazVea
    FIELD tt-nroorden AS CHAR FORMAT 'x(15)'
    FIELD tt-codclie AS CHAR FORMAT 'x(11)'
    FIELD tt-locentrega AS CHAR FORMAT 'x(8)'.

DEFINE TEMP-TABLE OrdenCompra-tienda
    FIELDS nro-oc   AS CHAR
    FIELDS clocal-destino AS CHAR
    FIELDS dlocal-Destino AS CHAR
    FIELDS clocal-entrega AS CHAR
    FIELDS dlocal-entrega AS CHAR
    FIELDS fecha-entrega  AS DATE
    FIELDS CodClie AS CHAR
    INDEX llave01 AS PRIMARY nro-oc clocal-destino.

/* VARIABLES PARA EL EXCEL */
DEFINE VARIABLE chExcelApplication  AS COM-HANDLE.
DEFINE VARIABLE chWorkbook          AS COM-HANDLE.
DEFINE VARIABLE chWorksheet         AS COM-HANDLE.
DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacCPedi

/* Definitions for FRAME F-Main                                         */
&Scoped-define QUERY-STRING-F-Main FOR EACH FacCPedi SHARE-LOCK
&Scoped-define OPEN-QUERY-F-Main OPEN QUERY F-Main FOR EACH FacCPedi SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-F-Main FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-F-Main FacCPedi


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-37 RECT-38 RECT-39 RECT-40 RECT-41 ~
RECT-42 BUTTON-Import BUTTON-22 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_Edi FILL-IN_Excel ~
FILL-IN_PackingList FILL-IN_CodCli RADIO-SET_Cmpbnte FILL-IN_ordcmp ~
FILL-IN_RucCli FILL-IN_Atencion FILL-IN_NomCli FILL-IN_DirCli FILL-IN_Sede ~
f-Sede FILL-IN_CodPos f-CodPos FILL-IN_FmaPgo F-CndVta FILL-IN_CodVen ~
f-NomVen FILL-IN_Glosa 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_t-import-edi-ibc-sede AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-import-edi-ibc-sedec AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-import-edi-ibc-unif AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-22 
     LABEL "LIMPIAR TODO" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-COT 
     LABEL "GENERAR PEDIDO COMERCIAL" 
     SIZE 25 BY 1.12.

DEFINE BUTTON BUTTON-EDI 
     IMAGE-UP FILE "img/search.ico":U
     IMAGE-INSENSITIVE FILE "img/block.ico":U
     LABEL "Button 3" 
     SIZE 6 BY 1.62.

DEFINE BUTTON BUTTON-Excel 
     IMAGE-UP FILE "img/search.ico":U
     IMAGE-INSENSITIVE FILE "img/block.ico":U
     LABEL "Button 25" 
     SIZE 6 BY 1.62.

DEFINE BUTTON BUTTON-Import 
     LABEL "IMPORTAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-PackingList 
     IMAGE-UP FILE "img/search.ico":U
     IMAGE-INSENSITIVE FILE "img/block.ico":U
     LABEL "Button 4" 
     SIZE 6 BY 1.62.

DEFINE VARIABLE F-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE f-CodPos AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .81 NO-UNDO.

DEFINE VARIABLE f-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE f-Sede AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 63 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Atencion AS CHARACTER FORMAT "X(8)" 
     LABEL "DNI" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81.

DEFINE VARIABLE FILL-IN_CodCli AS CHARACTER FORMAT "x(11)" 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_CodPos AS CHARACTER FORMAT "x(3)" 
     LABEL "Código Postal" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81
     BGCOLOR 14 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_CodVen AS CHARACTER FORMAT "x(10)" 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_DirCli AS CHARACTER FORMAT "x(256)" 
     LABEL "Dirección" 
     VIEW-AS FILL-IN 
     SIZE 77 BY .81
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_Edi AS CHARACTER FORMAT "X(256)":U 
     LABEL "Archivo EDI" 
     VIEW-AS FILL-IN 
     SIZE 39 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_Excel AS CHARACTER FORMAT "X(256)":U 
     LABEL "Archivo Excel" 
     VIEW-AS FILL-IN 
     SIZE 39 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_FmaPgo AS CHARACTER FORMAT "X(8)" 
     LABEL "Condición de Venta" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_Glosa AS CHARACTER FORMAT "X(256)" 
     LABEL "Glosa" 
     VIEW-AS FILL-IN 
     SIZE 69 BY .81
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "x(256)" 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 77 BY .81.

DEFINE VARIABLE FILL-IN_ordcmp AS CHARACTER FORMAT "X(25)" 
     LABEL "Orden de Compra" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .81
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_PackingList AS CHARACTER FORMAT "X(256)":U 
     LABEL "Archivo Packing List" 
     VIEW-AS FILL-IN 
     SIZE 39 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_RucCli AS CHARACTER FORMAT "x(20)" 
     LABEL "Ruc" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81.

DEFINE VARIABLE FILL-IN_Sede AS CHARACTER FORMAT "x(5)" 
     LABEL "Lugar de Entrega" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81
     BGCOLOR 14 FGCOLOR 0 .

DEFINE VARIABLE RADIO-SET_Cmpbnte AS CHARACTER INITIAL "FAC" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "FAC", "FAC":U,
"BOL", "BOL":U
     SIZE 17 BY .81
     BGCOLOR 11 FGCOLOR 0 .

DEFINE RECTANGLE RECT-37
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 187 BY 3.77.

DEFINE RECTANGLE RECT-38
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 122 BY 7.81.

DEFINE RECTANGLE RECT-39
     EDGE-PIXELS 2 GRAPHIC-EDGE    ROUNDED 
     SIZE 5 BY 1.62
     BGCOLOR 14 FGCOLOR 0 .

DEFINE RECTANGLE RECT-40
     EDGE-PIXELS 2 GRAPHIC-EDGE    ROUNDED 
     SIZE 5 BY 1.62
     BGCOLOR 14 FGCOLOR 0 .

DEFINE RECTANGLE RECT-41
     EDGE-PIXELS 2 GRAPHIC-EDGE    ROUNDED 
     SIZE 5 BY 1.62
     BGCOLOR 14 FGCOLOR 0 .

DEFINE RECTANGLE RECT-42
     EDGE-PIXELS 2 GRAPHIC-EDGE    ROUNDED 
     SIZE 5 BY 1.62
     BGCOLOR 14 FGCOLOR 0 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY F-Main FOR 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-EDI AT ROW 1.54 COL 60 WIDGET-ID 174
     FILL-IN_Edi AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 172
     BUTTON-Excel AT ROW 2.35 COL 129 WIDGET-ID 206
     BUTTON-Import AT ROW 2.35 COL 148 WIDGET-ID 180
     BUTTON-22 AT ROW 2.35 COL 163 WIDGET-ID 186
     FILL-IN_Excel AT ROW 2.88 COL 88 COLON-ALIGNED WIDGET-ID 208
     BUTTON-PackingList AT ROW 3.15 COL 60 WIDGET-ID 176
     FILL-IN_PackingList AT ROW 3.69 COL 19 COLON-ALIGNED WIDGET-ID 178
     FILL-IN_CodCli AT ROW 5.31 COL 19 COLON-ALIGNED WIDGET-ID 38
     RADIO-SET_Cmpbnte AT ROW 5.31 COL 38 NO-LABEL WIDGET-ID 102
     BUTTON-COT AT ROW 5.58 COL 89 WIDGET-ID 196
     FILL-IN_ordcmp AT ROW 5.85 COL 66 COLON-ALIGNED WIDGET-ID 118
     FILL-IN_RucCli AT ROW 6.12 COL 19 COLON-ALIGNED WIDGET-ID 60
     FILL-IN_Atencion AT ROW 6.12 COL 36 COLON-ALIGNED WIDGET-ID 88
     FILL-IN_NomCli AT ROW 6.92 COL 19 COLON-ALIGNED WIDGET-ID 54
     FILL-IN_DirCli AT ROW 7.73 COL 19 COLON-ALIGNED WIDGET-ID 44
     FILL-IN_Sede AT ROW 8.54 COL 19 COLON-ALIGNED WIDGET-ID 62
     f-Sede AT ROW 8.54 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     FILL-IN_CodPos AT ROW 9.35 COL 19 COLON-ALIGNED WIDGET-ID 170
     f-CodPos AT ROW 9.35 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 128
     FILL-IN_FmaPgo AT ROW 10.15 COL 19 COLON-ALIGNED WIDGET-ID 50
     F-CndVta AT ROW 10.15 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 90
     FILL-IN_CodVen AT ROW 10.96 COL 19 COLON-ALIGNED WIDGET-ID 42
     f-NomVen AT ROW 10.96 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 94
     FILL-IN_Glosa AT ROW 11.77 COL 19 COLON-ALIGNED WIDGET-ID 110
     "4" VIEW-AS TEXT
          SIZE 3 BY 1.08 AT ROW 5.58 COL 116 WIDGET-ID 212
          BGCOLOR 14 FGCOLOR 0 FONT 8
     "2" VIEW-AS TEXT
          SIZE 3 BY 1.08 AT ROW 2.62 COL 136 WIDGET-ID 200
          BGCOLOR 14 FGCOLOR 0 FONT 8
     "3" VIEW-AS TEXT
          SIZE 3 BY 1.08 AT ROW 2.35 COL 180 WIDGET-ID 216
          BGCOLOR 14 FGCOLOR 0 FONT 8
     "Pedido Comercial" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 4.77 COL 3 WIDGET-ID 190
          BGCOLOR 9 FGCOLOR 15 
     "1" VIEW-AS TEXT
          SIZE 3 BY 1.08 AT ROW 2.62 COL 67 WIDGET-ID 192
          BGCOLOR 14 FGCOLOR 0 FONT 8
     "Archivo de intercambio" VIEW-AS TEXT
          SIZE 17 BY .5 AT ROW 1 COL 2 WIDGET-ID 188
          BGCOLOR 9 FGCOLOR 15 
     RECT-37 AT ROW 1.27 COL 1 WIDGET-ID 182
     RECT-38 AT ROW 5.04 COL 1 WIDGET-ID 184
     RECT-39 AT ROW 2.35 COL 66 WIDGET-ID 194
     RECT-40 AT ROW 2.35 COL 135 WIDGET-ID 198
     RECT-41 AT ROW 5.31 COL 115 WIDGET-ID 210
     RECT-42 AT ROW 2.08 COL 179 WIDGET-ID 214
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 188 BY 26.15
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: CPEDI T "?" NO-UNDO INTEGRAL FacCPedi
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
      TABLE: ITEM-2 T "?" ? INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "IMPORTAR ARCHIVO EDI - IBC"
         HEIGHT             = 26.15
         WIDTH              = 188
         MAX-HEIGHT         = 26.15
         MAX-WIDTH          = 191.29
         VIRTUAL-HEIGHT     = 26.15
         VIRTUAL-WIDTH      = 191.29
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
ASSIGN 
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR BUTTON BUTTON-COT IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-EDI IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-Excel IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-PackingList IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-CodPos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-Sede IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Atencion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodPos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DirCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Edi IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Excel IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_FmaPgo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Glosa IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ordcmp IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_PackingList IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_RucCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Sede IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET RADIO-SET_Cmpbnte IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _TblList          = "INTEGRAL.FacCPedi"
     _Query            is OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* IMPORTAR ARCHIVO EDI - IBC */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* IMPORTAR ARCHIVO EDI - IBC */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-22
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-22 W-Win
ON CHOOSE OF BUTTON-22 IN FRAME F-Main /* LIMPIAR TODO */
DO:
  CLEAR FRAME {&FRAME-NAME} ALL NO-PAUSE.

  EMPTY TEMP-TABLE ITEM.
  EMPTY TEMP-TABLE ITEM-2.
  EMPTY TEMP-TABLE CPEDI.

  FILL-IN_CodCli:SENSITIVE = NO.
  FILL-IN_Sede:SENSITIVE = NO.
  FILL-IN_FmaPgo:SENSITIVE = NO.
  FILL-IN_CodVen:SENSITIVE = NO.
  FILL-IN_Glosa:SENSITIVE = NO.

  BUTTON-EDI:SENSITIVE = NO.
  BUTTON-PackingList:SENSITIVE = NO.
  BUTTON-Excel:SENSITIVE = NO.
  BUTTON-Import:SENSITIVE = YES.
  BUTTON-COT:SENSITIVE = NO.

  RUN Captura-Tabla IN h_t-import-edi-ibc-unif
    ( INPUT TABLE ITEM).
  RUN Captura-Tabla IN h_t-import-edi-ibc-sede
    ( INPUT TABLE ITEM-2).
  RUN Captura-Tabla IN h_t-import-edi-ibc-sedec
    ( INPUT TABLE CPEDI).

  RUN dispatch IN THIS-PROCEDURE ('initialize':U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-COT
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-COT W-Win
ON CHOOSE OF BUTTON-COT IN FRAME F-Main /* GENERAR PEDIDO COMERCIAL */
DO:
    MESSAGE 'Procedemos a Generar los Pedidos Comerciales?'
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
        UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.

    /* Consistencias */
    IF TRUE <> ( FILL-IN_CodCli:SCREEN-VALUE > '' ) THEN DO:
        MESSAGE 'Debe ingresar el Cliente' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FILL-IN_CodCli.
        RETURN NO-APPLY.
    END.
    IF TRUE <> ( FILL-IN_FmaPgo:SCREEN-VALUE > '' ) THEN DO:
        MESSAGE 'Debe ingresar la Forma de Pago' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FILL-IN_FmaPgo.
        RETURN NO-APPLY.
    END.
    FIND gn-convt WHERE gn-ConVt.Codig = FILL-IN_FmaPgo:SCREEN-VALUE
        AND gn-ConVt.libre_l01 = YES
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-convt THEN DO:
        MESSAGE 'Condición de venta NO válida' SKIP
            'Debe ser por FAI' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FILL-IN_FmaPgo.
        RETURN NO-APPLY.
    END.
    IF TRUE <> ( FILL-IN_Sede:SCREEN-VALUE > '' ) THEN DO:
        MESSAGE 'Debe ingresar el Lugar de Entrega' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FILL-IN_Sede.
        RETURN NO-APPLY.
    END.
    /* Lógica Principal */
    IF CAN-FIND(FIRST Faccpedi WHERE Faccpedi.codcia = s-codcia
                AND Faccpedi.coddiv = s-coddiv
                AND Faccpedi.coddoc = s-coddoc
                AND Faccpedi.ordcmp = FILL-IN_ordcmp:SCREEN-VALUE
                AND Faccpedi.flgest <> 'A' NO-LOCK)
        THEN DO:
        MESSAGE "La Orden de Compra YA ha sido procesada anteriormente"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    ASSIGN 
        FILL-IN_Atencion FILL-IN_CodCli FILL-IN_CodPos 
        FILL-IN_CodVen FILL-IN_DirCli FILL-IN_FmaPgo 
        FILL-IN_Glosa FILL-IN_NomCli FILL-IN_ordcmp 
        FILL-IN_RucCli FILL-IN_Sede
        RADIO-SET_Cmpbnte
        F-CndVta f-CodPos f-NomVen f-Sede
        .
    DEF VAR pMensaje AS CHAR NO-UNDO.
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Genera-Cotizaciones (OUTPUT pMensaje).
    SESSION:SET-WAIT-STATE('').
    IF pMensaje > '' THEN DO:
        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    APPLY "CHOOSE":U TO BUTTON-22.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-EDI
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-EDI W-Win
ON CHOOSE OF BUTTON-EDI IN FRAME F-Main /* Button 3 */
DO:
  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR x-Ok AS LOG NO-UNDO.
  SYSTEM-DIALOG GET-FILE x-Archivo
      FILTERS "*.txt" "*.txt"
      TITLE "Seleccione el archivo EDI"
      UPDATE x-Ok
      .
  IF x-Ok = NO THEN RETURN NO-APPLY.
  FILL-IN_Edi:SCREEN-VALUE = x-Archivo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Excel W-Win
ON CHOOSE OF BUTTON-Excel IN FRAME F-Main /* Button 25 */
DO:
  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR x-Ok AS LOG NO-UNDO.
  SYSTEM-DIALOG GET-FILE x-Archivo
      FILTERS "*.xls,*.xlsx" "*.xls,*.xlsx"
      TITLE "Seleccione el archivo EXCEL"
      UPDATE x-Ok
      .
  IF x-Ok = NO THEN RETURN NO-APPLY.
  FILL-IN_Excel:SCREEN-VALUE = x-Archivo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Import W-Win
ON CHOOSE OF BUTTON-Import IN FRAME F-Main /* IMPORTAR */
DO:
  DEF VAR x-NroControl-1 AS CHAR NO-UNDO.
  DEF VAR x-NroControl-2 AS CHAR NO-UNDO.
  DEF VAR pMensaje AS CHAR NO-UNDO.

  CASE TRUE:
      WHEN s-Import-IBC = YES THEN DO:
          IF TRUE <> (INPUT FILL-IN_Edi:SCREEN-VALUE > '') THEN DO:
              MESSAGE 'Ingrese el archivo EDI' VIEW-AS ALERT-BOX ERROR.
              APPLY 'ENTRY':U TO FILL-IN_Edi.
              RETURN NO-APPLY.
          END.
          IF TRUE <> (INPUT FILL-IN_PackingList:SCREEN-VALUE > '') THEN DO:
              MESSAGE 'Ingrese el archivo Packing List' VIEW-AS ALERT-BOX ERROR.
              APPLY 'ENTRY':U TO FILL-IN_PackingList.
              RETURN NO-APPLY.
          END.
          /* 1ro. Importamos datos del EDI sin distribuir por tiendas */
          RUN Import-EDI (INPUT FILL-IN_Edi:SCREEN-VALUE, OUTPUT x-NroControl-1, OUTPUT pMensaje).
          IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
              MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
              RETURN NO-APPLY.
          END.
          /* 2do. Importamos la distribución por tiendas */
          RUN Import-PackingList (INPUT FILL-IN_PackingList:SCREEN-VALUE, OUTPUT x-NroControl-2, OUTPUT pMensaje).
          IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
              MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
              RETURN NO-APPLY.
          END.
          IF INDEX(x-NroControl-1, x-NroControl-2) = 0 THEN DO:
              MESSAGE 'El Packing List NO corresponde a esta orden de compra' VIEW-AS ALERT-BOX ERROR.
              RETURN NO-APPLY.
          END.
      END.
      WHEN s-Import-B2B = YES THEN DO:
          IF TRUE <> (INPUT FILL-IN_Excel:SCREEN-VALUE > '') THEN DO:
              MESSAGE 'Ingrese el archivo Excel' VIEW-AS ALERT-BOX ERROR.
              APPLY 'ENTRY':U TO FILL-IN_Excel.
              RETURN NO-APPLY.
          END.
          RUN Import-Carvajal (INPUT FILL-IN_Excel:SCREEN-VALUE, OUTPUT pMensaje).
          IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
              MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
              RETURN NO-APPLY.
          END.
      END.
  END CASE.

  /* Pintamos Resumen */
  RUN Captura-Tabla IN h_t-import-edi-ibc-unif ( INPUT TABLE ITEM).
  RUN Captura-Tabla IN h_t-import-edi-ibc-sede ( INPUT TABLE ITEM-2).
  RUN Captura-Tabla IN h_t-import-edi-ibc-sedec ( INPUT TABLE CPEDI).


  /* Habilitamos/Deshabilitamos campos */
  IF TRUE <> (FILL-IN_CodCli:SCREEN-VALUE > '') THEN FILL-IN_CodCli:SENSITIVE = YES.
  FILL-IN_Sede:SENSITIVE = YES.
  FILL-IN_Glosa:SENSITIVE = YES.

  BUTTON-EDI:SENSITIVE = NO.
  BUTTON-PackingList:SENSITIVE = NO.
  BUTTON-Excel:SENSITIVE = NO.
  BUTTON-Import:SENSITIVE = NO.
  BUTTON-COT:SENSITIVE = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-PackingList
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-PackingList W-Win
ON CHOOSE OF BUTTON-PackingList IN FRAME F-Main /* Button 4 */
DO:
  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR x-Ok AS LOG NO-UNDO.
  SYSTEM-DIALOG GET-FILE x-Archivo
      FILTERS "*.txt" "*.txt"
      TITLE "Seleccione el archivo Packing List"
      UPDATE x-Ok
      .
  IF x-Ok = NO THEN RETURN NO-APPLY.
  FILL-IN_PackingList:SCREEN-VALUE = x-Archivo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodCli W-Win
ON LEAVE OF FILL-IN_CodCli IN FRAME F-Main /* Cliente */
DO:
  IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = SELF:SCREEN-VALUE
      AND gn-clie.flgsit = 'A'
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:
      MESSAGE 'Cliente NO válido' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  ASSIGN
      s-CodCli = SELF:SCREEN-VALUE.
  /* ****************************************** */
  /* Cargamos las condiciones de venta válidas */
  /* Tomamos la primera */
  /* ****************************************** */
  FIND gn-clie WHERE gn-clie.codcia  = cl-codcia AND gn-clie.codcli = s-codcli NO-LOCK.

  RUN vtagn/p-fmapgo-valido.r (s-codcli, s-tpoped, pCodDiv, OUTPUT s-cndvta-validos).

  IF TRUE <> (FILL-IN_FmaPgo:SCREEN-VALUE > "") THEN s-FmaPgo = ENTRY(1, s-cndvta-validos).
  ELSE s-FmaPgo = FILL-IN_FmaPgo:SCREEN-VALUE.
  /* ****************************************** */
  /* DATOS DEL CLIENTE */
  /* ****************************************** */
  DISPLAY 
      gn-clie.NomCli @ FILL-IN_NomCli 
      gn-clie.Ruc    @ FILL-IN_RucCli
      gn-clie.DirCli @ FILL-IN_DirCli
      s-FmaPgo       @ FILL-IN_FmaPgo 
      gn-clie.CodVen WHEN (TRUE <> (FILL-IN_CodVen:SCREEN-VALUE > '')) @ FILL-IN_CodVen 
      "@@@"          WHEN (TRUE <> (FILL-IN_Sede:SCREEN-VALUE > ''))   @ FILL-IN_Sede
      WITH FRAME {&FRAME-NAME}.
   APPLY 'LEAVE':U TO FILL-IN_Sede.
  /* ****************************************** */
  /* Ubica la Condicion Venta */
  /* ****************************************** */
  FIND FIRST gn-convt WHERE gn-convt.Codig = FILL-IN_FmaPgo:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt 
  THEN DO:
       F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
  END.  
  ELSE F-CndVta:SCREEN-VALUE = "".

  /* Vendedor */
  F-NomVen:SCREEN-VALUE = "".
  FIND FIRST gn-ven WHERE gn-ven.CodCia = S-CODCIA 
      AND  gn-ven.CodVen = FILL-IN_CodVen:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ven THEN F-NomVen:SCREEN-VALUE = gn-ven.NomVen.

  /* Determina si es boleta o factura */
  IF TRUE <> (FILL-IN_RucCli:SCREEN-VALUE > '')
  THEN RADIO-SET_Cmpbnte:SCREEN-VALUE = 'BOL'.
  ELSE RADIO-SET_Cmpbnte:SCREEN-VALUE = 'FAC'.

  APPLY 'VALUE-CHANGED' TO RADIO-SET_Cmpbnte.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodCli W-Win
ON LEFT-MOUSE-DBLCLICK OF FILL-IN_CodCli IN FRAME F-Main /* Cliente */
OR f8 OF FILL-IN_CodCli
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?
        output-var-2 = ''
        output-var-3 = ''.
    RUN vtagn/c-gn-clie-01 ('Clientes').
    IF output-var-1 <> ? THEN FILL-IN_CodCli:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodPos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodPos W-Win
ON LEAVE OF FILL-IN_CodPos IN FRAME F-Main /* Código Postal */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  FIND Almtabla WHERE almtabla.Tabla = "CP"
      AND almtabla.Codigo = FILL-IN_CodPos:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almtabla THEN f-CodPos:SCREEN-VALUE = almtabla.Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodVen W-Win
ON LEAVE OF FILL-IN_CodVen IN FRAME F-Main /* Vendedor */
DO:
  F-NomVen:SCREEN-VALUE = "".
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
    AND  gn-ven.CodVen = FILL-IN_CodVen:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-ven THEN DO:
      MESSAGE "Vendedor NO válido" VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = "".
      RETURN NO-APPLY.
  END.
  F-NomVen:SCREEN-VALUE = gn-ven.NomVen.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodVen W-Win
ON LEFT-MOUSE-DBLCLICK OF FILL-IN_CodVen IN FRAME F-Main /* Vendedor */
OR f8 OF FILL-IN_CodVen
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''.
    RUN lkup/c-vende ('Vendedor').
    IF output-var-1 <> ? THEN FILL-IN_CodVen:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_FmaPgo W-Win
ON LEAVE OF FILL-IN_FmaPgo IN FRAME F-Main /* Condición de Venta */
DO:
    F-CndVta:SCREEN-VALUE = ''.
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND FIRST gn-convt WHERE gn-convt.Codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-convt THEN DO:
        MESSAGE 'Condición de venta NO válida' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
    /* Filtrado de las condiciones de venta */
    IF LOOKUP(SELF:SCREEN-VALUE, s-cndvta-validos) = 0 THEN DO:
        MESSAGE 'Condición de venta NO autorizada para este cliente'
            VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    s-FmaPgo = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_FmaPgo W-Win
ON LEFT-MOUSE-DBLCLICK OF FILL-IN_FmaPgo IN FRAME F-Main /* Condición de Venta */
OR f8 OF FILL-IN_FmaPgo
DO:
    ASSIGN
        input-var-1 = s-cndvta-validos
        input-var-2 = ''
        input-var-3 = ''.
    RUN vta/d-cndvta.r.
    IF output-var-1 <> ? THEN FILL-IN_FmaPgo:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Sede
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Sede W-Win
ON LEAVE OF FILL-IN_Sede IN FRAME F-Main /* Lugar de Entrega */
DO:
    f-Sede:SCREEN-VALUE = ''.
    FIND gn-clied WHERE gn-clied.codcia = cl-codcia
       AND gn-clied.codcli = FILL-IN_CodCli:SCREEN-VALUE
       AND gn-clied.sede = FILL-IN_Sede:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clied THEN DO:
        f-Sede:SCREEN-VALUE = GN-ClieD.dircli. 
        FILL-IN_CodPos:SCREEN-VALUE = Gn-ClieD.Codpos.
        APPLY 'LEAVE':U TO FILL-IN_CodPos.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Sede W-Win
ON LEFT-MOUSE-DBLCLICK OF FILL-IN_Sede IN FRAME F-Main /* Lugar de Entrega */
OR f8 OF FILL-IN_Sede
DO:
    ASSIGN
      input-var-1 = FILL-IN_CodCli:SCREEN-VALUE
      input-var-2 = ""
      input-var-3 = ''
      output-var-1 = ?
      output-var-2 = ''
      output-var-3 = ''.
    RUN lkup/c-gn-clied-todo.r ('SEDES').
    IF output-var-1 <> ?
        THEN ASSIGN 
              f-Sede:SCREEN-VALUE = output-var-3
              FILL-IN_Sede:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET_Cmpbnte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET_Cmpbnte W-Win
ON VALUE-CHANGED OF RADIO-SET_Cmpbnte IN FRAME F-Main
DO:
    DO WITH FRAM {&FRAME-NAME}:
        IF SELF:SCREEN-VALUE = 'FAC' 
            AND FILL-IN_CodCli:SCREEN-VALUE <> '11111111112'
            THEN DO:
            FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                AND gn-clie.CodCli = FILL-IN_CodCli:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
            ASSIGN
                FILL-IN_DirCli:SENSITIVE = NO
                FILL-IN_NomCli:SENSITIVE = NO
                FILL-IN_Atencion:SENSITIVE = NO.
            IF AVAILABLE gn-clie THEN DO:
                ASSIGN
                    FILL-IN_DirCli:SCREEN-VALUE = GN-CLIE.DirCli
                    FILL-IN_NomCli:SCREEN-VALUE = GN-CLIE.NomCli
                    FILL-IN_RucCli:SCREEN-VALUE = gn-clie.Ruc.
            END.
        END.
        ELSE DO:
            ASSIGN
                FILL-IN_DirCli:SENSITIVE = YES
                FILL-IN_NomCli:SENSITIVE = YES
                FILL-IN_Atencion:SENSITIVE = YES.
            IF FILL-IN_CodCli:SCREEN-VALUE = '11111111112' THEN FILL-IN_RucCli:SENSITIVE = YES.
        END.
        S-CMPBNTE = SELF:SCREEN-VALUE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
lh_handle = THIS-PROCEDURE.

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
             INPUT  'aplic/vtagn/t-import-edi-ibc-sedec.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-import-edi-ibc-sedec ).
       RUN set-position IN h_t-import-edi-ibc-sedec ( 5.04 , 126.00 ) NO-ERROR.
       RUN set-size IN h_t-import-edi-ibc-sedec ( 7.54 , 62.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtagn/t-import-edi-ibc-unif.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-import-edi-ibc-unif ).
       RUN set-position IN h_t-import-edi-ibc-unif ( 12.85 , 1.00 ) NO-ERROR.
       RUN set-size IN h_t-import-edi-ibc-unif ( 13.19 , 132.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtagn/t-import-edi-ibc-sede.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-import-edi-ibc-sede ).
       RUN set-position IN h_t-import-edi-ibc-sede ( 12.85 , 134.00 ) NO-ERROR.
       RUN set-size IN h_t-import-edi-ibc-sede ( 12.85 , 54.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-import-edi-ibc-sedec ,
             FILL-IN_PackingList:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-import-edi-ibc-unif ,
             FILL-IN_Glosa:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-import-edi-ibc-sede ,
             h_t-import-edi-ibc-unif , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Control-OC W-Win 
PROCEDURE Control-OC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAMETER lOrdenGrabada AS CHAR.
  DEF INPUT PARAMETER lCodCli AS CHAR.
  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  DEF VAR pCuenta AS INTE NO-UNDO.

  /* Guardar la ORDEN DE COMPRA DE PLAZA VEA  */
  DISABLE TRIGGERS FOR LOAD OF FacTabla.

  FIND FIRST FacTabla WHERE FacTabla.codcia = s-codcia AND 
      FacTabla.tabla = 'OC PLAZA VEA' AND 
      FacTabla.codigo = lOrdenGrabada NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacTabla THEN DO:
      CREATE FacTabla.
      ASSIGN 
          FacTabla.codcia = s-codcia
          FacTabla.tabla = 'OC PLAZA VEA'
          FacTabla.codigo = lOrdenGrabada
          FacTabla.campo-c[2] = STRING(NOW,"99/99/9999 HH:MM:SS")
          NO-ERROR.
      IF ERROR-STATUS:ERROR = YES THEN DO:
          {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="pCuenta"}
          UNDO, RETURN 'ADM-ERROR'.
      END.
      RELEASE FacTabla.
  END.
  /* CONTROL PARA EL LPN */
  FIND FIRST SupControlOC WHERE SupControlOC.codcia = s-codcia AND 
      SupControlOC.CodDiv = s-CodDiv AND
      SupControlOC.CodCli = lCodCli  AND 
      SupControlOC.OrdCmp = lOrdenGrabada NO-LOCK NO-ERROR.
  IF NOT AVAILABLE SupControlOC THEN DO:
      CREATE SupControlOC.
      ASSIGN 
          SupControlOC.Codcia = s-codcia
          SupControlOC.CodCli = lCodCli 
          SupControlOC.Ordcmp = lOrdenGrabada
          SupControlOC.FchPed = TODAY
          SupControlOC.coddiv = S-CODDIV
          SupControlOC.usuario = S-USER-ID
          SupControlOC.correlativo = 0
          SupControlOC.hora = string(TIME,"HH:MM:SS")
          NO-ERROR.
      IF ERROR-STATUS:ERROR = YES THEN DO:
          {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="pCuenta"}
          UNDO, RETURN 'ADM-ERROR'.
      END.
      RELEASE SupControl.
  END.

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

  {&OPEN-QUERY-F-Main}
  GET FIRST F-Main.
  DISPLAY FILL-IN_Edi FILL-IN_Excel FILL-IN_PackingList FILL-IN_CodCli 
          RADIO-SET_Cmpbnte FILL-IN_ordcmp FILL-IN_RucCli FILL-IN_Atencion 
          FILL-IN_NomCli FILL-IN_DirCli FILL-IN_Sede f-Sede FILL-IN_CodPos 
          f-CodPos FILL-IN_FmaPgo F-CndVta FILL-IN_CodVen f-NomVen FILL-IN_Glosa 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-37 RECT-38 RECT-39 RECT-40 RECT-41 RECT-42 BUTTON-Import 
         BUTTON-22 
      WITH FRAME F-Main IN WINDOW W-Win.
  VIEW FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Cotizaciones W-Win 
PROCEDURE Genera-Cotizaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR pCuenta AS INTE NO-UNDO.

DEF VAR I-NITEM AS INTE NO-UNDO.
FIND FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia
    AND FacCorre.CodDiv = s-CodDiv
    AND FacCorre.CodDoc = s-CodDoc
    AND FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    pMensaje = 'NO configurado correlativo para el código ' + s-CodDoc + ' para la división ' + s-CodDiv.
    RETURN 'ADM-ERROR'.
END.
s-NroSer = FacCorre.NroSer.

PRINCIPAL:  
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Bloqueamos Correlativo */
    {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}

    ASSIGN
        s-CodCli = FILL-IN_CodCli
        s-FmaPgo = FILL-IN_FmaPgo
        s-TpoCmb = 1
        s-CodVen = FILL-IN_CodVen
        .
    FIND TcmbCot WHERE  TcmbCot.Codcia = 0
        AND (TcmbCot.Rango1 <= TODAY - TODAY + 1
             AND   TcmbCot.Rango2 >= TODAY - TODAY + 1)
        NO-LOCK NO-ERROR.
    IF AVAIL TcmbCot THEN S-TPOCMB = TcmbCot.TpoCmb.  
    /* RHC 11.08.2014 TC Caja Compra */
    FOR EACH gn-tccja NO-LOCK BY Fecha:
        IF TODAY >= Fecha THEN s-TpoCmb = Gn-TCCja.Compra.
    END.
    /* Quebramos por cada SEDE */
    FOR EACH ITEM-2 NO-LOCK BREAK BY ITEM-2.Libre_c01 BY ITEM-2.NroItm:
        IF FIRST-OF(ITEM-2.Libre_c01) THEN DO:
            /* Creamos Cabecera */
            ASSIGN I-NITEM = 1.
            /* Adiciono el NUEVO REGISTRO */
            CREATE FacCPedi.
            ASSIGN 
                FacCPedi.CodCia = S-CODCIA
                FacCPedi.CodDiv = S-CODDIV
                FacCPedi.CodDoc = s-coddoc 
                FacCPedi.CodAlm = s-CodAlm    /* Lista de Almacenes Válidos de Venta */
                FacCPedi.FchPed = TODAY 
                FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
                FacCPedi.TpoPed = s-TpoPed
                FacCPedi.FlgEst = "P".    /* APROBADO */
            IF ERROR-STATUS:ERROR = YES THEN DO:
                {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="pCuenta"}
                UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
            END.
            ASSIGN
                FacCorre.Correlativo = FacCorre.Correlativo + 1.
            FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
                AND gn-clie.codcli = FILL-IN_CodCli
                NO-LOCK.
            ASSIGN
                Faccpedi.codcli = FILL-IN_CodCli
                Faccpedi.sede = FILL-IN_Sede
                FacCPedi.LugEnt = f-Sede
                FacCPedi.FmaPgo = FILL-IN_FmaPgo
                Faccpedi.NomCli = FILL-IN_NomCli
                Faccpedi.DirCli = FILL-IN_DirCli
                Faccpedi.RucCli = FILL-IN_RucCli
                Faccpedi.Atencion = FILL-IN_Atencion
                Faccpedi.FaxCli = SUBSTRING(TRIM(gn-clie.clfcli) + "00",1,2) +
                                    SUBSTRING(TRIM(gn-clie.clfcli2) + "00",1,2)
                Faccpedi.Cmpbnte = RADIO-SET_Cmpbnte
                FacCPedi.PorIgv = s-PorIgv
                FacCPedi.Hora = STRING(TIME,"HH:MM")
                FacCPedi.Usuario = S-USER-ID
                /*FacCPedi.Observa = FILL-IN_Glosa*/
                FacCPedi.Libre_c01 = pCodDiv
                FacCPedi.CodMon = s-CodMon
                FacCPedi.Libre_d01  = s-NroDec
                FacCPedi.FlgIgv = s-FlgIgv
                FacCPedi.TpoCmb = s-tpocmb
                FacCPedi.FchVen = TODAY + s-DiasVtoCot
                FacCPedi.FchEnt = (TODAY + s-MinimoDiasDespacho)
                Faccpedi.codven = s-CodVen
                Faccpedi.ImpDto2 = 0
                FacCPedi.Glosa  = ITEM-2.Libre_c01 + " - " + ITEM-2.Libre_c02
                FacCPedi.ordcmp = FILL-IN_ordcmp
                FacCPedi.ubigeo[1] = (IF s-Import-IBC = YES THEN ITEM-2.Libre_c01 + " " + ITEM-2.Libre_c02 ELSE '')
                .
            CASE TRUE:
                WHEN s-Import-IBC = YES THEN Faccpedi.Libre_c05 = "1".
                WHEN s-Import-B2B = YES THEN Faccpedi.Libre_c05 = "3".
            END CASE.
            /* ******************************************** */
            /* RHC 19/050/2021 Datos para HOMOLOGAR las COT */
            /* ******************************************** */
            IF TRUE <> (FacCPedi.CustomerPurchaseOrder  > '') THEN FacCPedi.CustomerPurchaseOrder = Faccpedi.OrdCmp.
            /* ******************************************** */
        END.
        /* Creamos Detalle */
        CREATE FacDPedi.
        BUFFER-COPY ITEM-2 
            TO FacDPedi
            ASSIGN
            FacDPedi.CodCia = FacCPedi.CodCia
            FacDPedi.CodDiv = FacCPedi.CodDiv
            FacDPedi.coddoc = FacCPedi.coddoc
            FacDPedi.NroPed = FacCPedi.NroPed
            FacDPedi.FchPed = FacCPedi.FchPed
            FacDPedi.Hora   = FacCPedi.Hora 
            FacDPedi.CodCli = FacCPedi.CodCli
            FacDPedi.FlgEst = FacCPedi.FlgEst
            FacDPedi.NroItm = I-NITEM.
        ASSIGN 
            I-NITEM = I-NITEM + 1.
        IF LAST-OF(ITEM-2.Libre_c01) THEN DO:
            /* ****************************************************************************************** */
            /*{vtagn/totales-cotizacion-unificada.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}*/
            {vtagn/totales-cotizacion-sunat.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
            /* ****************************************************************************************** */
            /* ****************************************************************************************** */
            /* Importes SUNAT */
            /* ****************************************************************************************** */
            DEF VAR hProc AS HANDLE NO-UNDO.
            RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
            RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                                         INPUT Faccpedi.CodDoc,
                                         INPUT Faccpedi.NroPed,
                                         OUTPUT pMensaje).
            IF RETURN-VALUE = "ADM-ERROR" THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
            DELETE PROCEDURE hProc.
            /* ****************************************************************************************** */
            /* ****************************************************************************************** */
            CASE TRUE:
                WHEN s-Import-B2B = YES THEN DO:
                    RUN Control-OC (FILL-IN_ordcmp,
                                    FILL-IN_CodCli,
                                    OUTPUT pMensaje).
                    IF RETURN-VALUE ='ADM-ERROR' THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
                END.
            END CASE.
        END.
    END.
END.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(FacCPedi) THEN RELEASE FacCPedi.
IF AVAILABLE(FacDPedi) THEN RELEASE FacDPedi.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Import-Carvajal W-Win 
PROCEDURE Import-Carvajal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER x-Archivo AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR pCuenta AS INTE NO-UNDO.

DEFINE VARIABLE cNro-oc AS CHAR .
DEFINE VARIABLE clocal AS CHAR.

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

DEFINE VAR lOrden AS CHAR.
DEFINE VAR lCodEan AS CHAR.

lFileXls = x-Archivo.           /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = NO.        /* YES : Si va crear un nuevo archivo o abrir */
{lib\excel-open-file.i}
chExcelApplication:Visible = FALSE.
lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = YES.        /* Si permanece abierto el Excel luego de concluir el proceso */

/* Limpiamos archivos de control */
EMPTY TEMP-TABLE tt-OrdenesPlazVea.
EMPTY TEMP-TABLE OrdenCompra-Tienda.
/* ************************************************************************************************ */
/* Cuantas ORDENES tiene el Excel */
/* Solo se va a aceptar una orden por cada excel */
/* ************************************************************************************************ */
iColumn = 1.
DO iColumn = 2 TO 65000:
    cRange = "B" + TRIM(STRING(iColumn)).
    cValue = TRIM(STRING(chWorkSheet:Range(cRange):VALUE,">>>>>>>>>>>9")).
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */
    /* O/C */
    ASSIGN
        cNro-oc = cValue.
    /* Local destino */
    cRange = "U" + TRIM(STRING(iColumn)).
    cLocal = TRIM(chWorkSheet:Range(cRange):VALUE).     /* OFICINA */
    /* LAS ORDENES DE COMPRA */
/*     FIND FIRST factabla WHERE factabla.codcia = s-codcia AND    */
/*             factabla.tabla = 'OC PLAZA VEA' AND                 */
/*             factabla.codigo = cNro-Oc NO-LOCK NO-ERROR.         */
/*     IF AVAILABLE FacTabla THEN DO:                              */
/*         pMensaje = "ERROR: La OC ya tiene Pedidos Comerciales". */
/*         /* Cerrar el Excel  */                                  */
/*         {lib\excel-close-file.i}                                */
/*         RETURN 'ADM-ERROR'.                                     */
/*     END.                                                        */
    FIND FIRST tt-OrdenesPlazVea NO-LOCK NO-ERROR.
    IF NOT AVAILABLE tt-OrdenesPlazVea THEN DO:
        CREATE tt-OrdenesPlazVea.
        ASSIGN 
            tt-OrdenesPlazVea.tt-nroorden = cNro-Oc
            cRange = "A" + TRIM(STRING(iColumn))
            tt-OrdenesPlazVea.tt-CodClie = TRIM(chWorkSheet:Range(cRange):VALUE)                    
            cRange = "D" + TRIM(STRING(iColumn))
            tt-OrdenesPlazVea.tt-locentrega = TRIM(chWorkSheet:Range(cRange):VALUE).
    END.  
    ELSE DO:
        IF tt-OrdenesPlazVea.tt-nroorden <> cNro-Oc THEN DO:
            pMensaje = "ERROR: El archivo contiene más de una Orden de Compra".
            /* Cerrar el Excel  */
            {lib\excel-close-file.i}
            RETURN 'ADM-ERROR'.
        END.
    END.
    /* ORDENES DE COMPRA X LOCAL */
    FIND FIRST OrdenCompra-Tienda WHERE nro-oc = cNro-oc 
        AND clocal-destino = cLocal NO-LOCK NO-ERROR.
    IF NOT AVAILABLE OrdenCompra-Tienda THEN DO:
        CREATE OrdenCompra-Tienda.
        ASSIGN  
            OrdenCompra-Tienda.nro-oc = cNro-oc
            OrdenCompra-Tienda.clocal-destino = cLocal
            cRange = "V" + TRIM(STRING(iColumn))
            OrdenCompra-Tienda.dlocal-destino = TRIM(chWorkSheet:Range(cRange):VALUE)
            cRange = "D" + TRIM(STRING(iColumn))
            OrdenCompra-Tienda.clocal-entrega = TRIM(chWorkSheet:Range(cRange):VALUE)
            cRange = "E" + TRIM(STRING(iColumn))
            OrdenCompra-Tienda.dlocal-entrega = TRIM(chWorkSheet:Range(cRange):VALUE)
            cRange = "A" + TRIM(STRING(iColumn))
            OrdenCompra-Tienda.CodClie = TRIM(chWorkSheet:Range(cRange):VALUE).
        /* Fecha de Entrega - En el excel debe estar asi : 24-02-2017  (dd-mm-aaaa)*/
        cRange = "H" + TRIM(STRING(iColumn)).
        ASSIGN  
            OrdenCompra-tienda.fecha-entrega = DATE(TRIM(chWorkSheet:Range(cRange):TEXT)) NO-ERROR.
    END.
END.
ASSIGN 
    FILL-IN_ordcmp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cNro-Oc.
/* IF CAN-FIND(FIRST Faccpedi WHERE Faccpedi.codcia = s-codcia                          */
/*             AND Faccpedi.coddiv = s-coddiv                                           */
/*             AND Faccpedi.coddoc = s-coddoc                                           */
/*             AND Faccpedi.ordcmp = cNro-Oc                                            */
/*             AND Faccpedi.flgest <> 'A' NO-LOCK)                                      */
/*     THEN DO:                                                                         */
/*     pMensaje = "Orden de Compra " + cNro-Oc + " YA ha sido procesada anteriormente". */
/*     RETURN 'ADM-ERROR'.                                                              */
/* END.                                                                                 */
/* ************************************************************************************************ */
/* RHC 15/08/2017 Control de errores del excel */
/* ************************************************************************************************ */
DEF VAR x-CodMat LIKE ITEM.codmat NO-UNDO.
DEF VAR pCodMat AS CHAR NO-UNDO.

DO iColumn = 2 TO 65000:
    ASSIGN 
        x-CodMat = ''.
    /* Orden */
    cRange = "B" + TRIM(STRING(iColumn)).
    cValue = TRIM(STRING(chWorkSheet:Range(cRange):VALUE,">>>>>>>>>>>9")).
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */
    /* Articulo de la misma Orden  */
    cRange = "J" + TRIM(STRING(iColumn)).
    lCodEan = TRIM(chWorkSheet:Range(cRange):VALUE).                
    x-CodMat = lCodEan.
    pCodMat = x-CodMat.
    RUN vta2/p-codigo-producto.r (INPUT-OUTPUT pCodMat, NO).
    IF TRUE <> ( pCodMat > '') THEN DO:
        pMensaje = 'ERROR línea ' + STRING(iColumn) + CHR(10) + 'EAN ' + lCodEan + ' NO REGISTRADO'.
        /* Cerrar el Excel  */
        {lib\excel-close-file.i}
        RETURN 'ADM-ERROR'.
    END.
    x-CodMat = pCodMat.
    /* Se ubicó el Código Interno  */
    FIND Almmmatg WHERE almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = x-codmat
        AND Almmmatg.tpoart <> 'D'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        pMensaje = 'ERROR línea ' + STRING(iColumn) + CHR(10) + 'EAN ' + lCodEan + ' DESACTIVADO'.
        /* Cerrar el Excel  */
        {lib\excel-close-file.i}
        RETURN 'ADM-ERROR'.
    END.
END.
/* ************************************************************************************************ */
DEFINE VARIABLE cSede   AS CHAR NO-UNDO.
DEFINE VARIABLE cNomSede AS CHAR NO-UNDO.
DEFINE VARIABLE cCodCli AS CHAR NO-UNDO.
DEF VAR x-NroItm AS INT INIT 0.
DEF VAR x-CanPed LIKE ITEM.canped NO-UNDO.
DEF VAR x-ImpLin LIKE ITEM.implin NO-UNDO.
DEF VAR x-ImpIgv LIKE ITEM.impigv NO-UNDO.
DEFINE VAR x-precio AS DEC.
DEFINE VAR x-precio-sin-igv AS DEC.

EMPTY TEMP-TABLE ITEM-2.
PRINCIPAL:  /* Se supone que es solo una orden de compra a la vez */
FOR EACH tt-OrdenesPlazVea WITH FRAME {&FRAME-NAME}:
    lOrden = tt-OrdenesPlazVea.tt-nroorden.
    FOR EACH OrdenCompra-tienda WHERE lOrden = OrdenCompra-Tienda.nro-oc :
        ASSIGN
            cCodCli = TRIM(OrdenCompra-Tienda.CodClie)
            cSede = OrdenCompra-Tienda.clocal-entrega
            lOrden = OrdenCompra-Tienda.nro-oc
            FILL-IN_Glosa :SCREEN-VALUE = TRIM(OrdenCompra-tienda.clocal-entrega) + " " + TRIM(OrdenCompra-tienda.dlocal-entrega)
            .
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = cCodCli
            AND gn-clie.flgsit = 'A'
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            ASSIGN
                s-codcli = gn-clie.codcli
                FILL-IN_CodCli:SCREEN-VALUE = cCodCli.
            FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.sede = cSede NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clied THEN DO:
                ASSIGN
                    FILL-IN_Sede:SCREEN-VALUE = Gn-ClieD.Sede
                    f-Sede:SCREEN-VALUE = Gn-ClieD.DirCli
                    cNomSede = Gn-ClieD.DirCli.
            END.
        END.
        /* ************************************************************************************************ */
        /* Leer el Detalle: Carga si pertenece al local */
        /* ************************************************************************************************ */
        x-NroItm = 0.
        /* El Detalle de la Orden */
        DO iColumn = 2 TO 65000:
            ASSIGN 
                x-CodMat = ''
                x-CanPed = 0
                x-ImpLin = 0
                x-ImpIgv = 0
                x-precio = 0.
            /* Orden */
            cRange = "B" + TRIM(STRING(iColumn)).
            cValue = TRIM(STRING(chWorkSheet:Range(cRange):VALUE,">>>>>>>>>>>9")).
    
            IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */
    
            /* O/C */
            cNro-oc = cValue.
            /* Local destino */
            cRange = "U" + TRIM(STRING(iColumn)).
            cLocal = TRIM(chWorkSheet:Range(cRange):VALUE).

            IF NOT (cNro-oc = OrdenCompra-Tienda.nro-oc AND cLocal = OrdenCompra-Tienda.clocal-destino)
                THEN NEXT.  /* Siguiente registro */
    
            /* Articulo de la misma Orden  */
            cRange = "J" + TRIM(STRING(iColumn)).
            lCodEan = TRIM(chWorkSheet:Range(cRange):VALUE).                
            x-CodMat = lCodEan.
            pCodMat = x-CodMat.
            RUN vta2/p-codigo-producto.r (INPUT-OUTPUT pCodMat, NO).
            x-CodMat = pCodMat.
            /* Se ubico el Codigo Interno  */
            FIND Almmmatg WHERE almmmatg.codcia = s-codcia AND Almmmatg.codmat = x-codmat NO-LOCK.
            /* Cantidad pedida */
            cRange = "W" + TRIM(STRING(iColumn)).
            x-CanPed = chWorkSheet:Range(cRange):VALUE.
            /* El precio final */
            cRange = "T" + TRIM(STRING(iColumn)).
            x-precio =  chWorkSheet:Range(cRange):VALUE.
            /* Precio sin IGV */
            cRange = "S" + TRIM(STRING(iColumn)).
            x-precio-sin-igv = chWorkSheet:Range(cRange):VALUE.
            /**/
            x-ImpLin = x-CanPed * x-precio.
            /* Verificar el IGV */
            IF x-precio > x-precio-sin-igv THEN DO:
                x-ImpIgv = x-ImpLin - (x-CanPed * x-precio-sin-igv).
            END.                        
            x-NroItm = x-NroItm + 1.
            CREATE ITEM-2.
            ASSIGN
                ITEM-2.CodCia = s-CodCia
                ITEM-2.NroPed = OrdenCompra-Tienda.clocal-destino
                ITEM-2.NroItm = x-NroItm
                ITEM-2.codmat = x-CodMat
                ITEM-2.CanPed = x-CanPed
                ITEM-2.Factor = 1
                ITEM-2.Libre_c01 = OrdenCompra-Tienda.clocal-destino
                ITEM-2.Libre_c02 = OrdenCompra-Tienda.dlocal-destino
                ITEM-2.UndVta = (IF AVAILABLE Almmmatg THEN Almmmatg.Chr__01 ELSE '')
                ITEM-2.ALMDES = S-CODALM
                ITEM-2.AftIgv = (IF x-ImpIgv > 0 THEN YES ELSE NO)
                NO-ERROR
                .
            IF ERROR-STATUS:ERROR = YES THEN DO:
                {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="pCuenta"}
                /* Cerrar el Excel  */
                {lib\excel-close-file.i}
                RETURN 'ADM-ERROR'.
            END.
            /* RHC 09.08.06 IGV de acuerdo al cliente */
            IF LOOKUP(TRIM(s-CodCli), '20100070970,20109072177,20100106915,20504912851') > 0
            THEN ASSIGN
                    ITEM-2.ImpIgv = x-ImpIgv 
                    ITEM-2.ImpLin = x-ImpLin
                    ITEM-2.PreUni = x-precio.  /* (ITEM.ImpLin / ITEM.CanPed).*/
            ELSE ASSIGN
                    ITEM-2.ImpIgv = x-ImpIgv 
                    ITEM-2.ImpLin = x-ImpLin /*+ x-ImpIgv*/
                    ITEM-2.PreUni = x-precio. /* (ITEM.ImpLin / ITEM.CanPed) */
        END.        
    END.
END.
/* Cerrar el Excel  */
{lib\excel-close-file.i}

/* Cargamos Resumen de la Cotización */
EMPTY TEMP-TABLE ITEM.
FOR EACH ITEM-2 NO-LOCK, 
    FIRST Almmmatg OF ITEM-2 NO-LOCK, FIRST Almsfami OF Almmmatg NO-LOCK:
    FIND ITEM WHERE ITEM.codmat = ITEM-2.codmat NO-ERROR.
    IF NOT AVAILABLE ITEM THEN DO:
        CREATE ITEM.
    END.
    BUFFER-COPY ITEM-2 TO ITEM
        ASSIGN ITEM.CanPed = ITEM.CanPed + ITEM-2.CanPed.
    /* ***************************************************************** */
    {vtagn/CalculoDetalleMayorCredito.i &Tabla="ITEM" }
    /* ***************************************************************** */
END.
/* PACKING LIST POR SEDE */
EMPTY TEMP-TABLE CPEDI.
FOR EACH ITEM-2 NO-LOCK BREAK BY ITEM-2.Libre_c01:
    IF FIRST-OF(ITEM-2.Libre_c01) THEN DO:
        CREATE CPEDI.
        ASSIGN
            CPEDI.NroPed = ITEM-2.Libre_c02
            CPEDI.Sede   = ITEM-2.Libre_c01
            CPEDI.LugEnt = ITEM-2.Libre_c02.
    END.
    ASSIGN
        CPEDI.ImpTot = CPEDI.ImpTot + ITEM-2.ImpLin.
END.

APPLY 'LEAVE':U TO FILL-IN_CodCli.
APPLY 'LEAVE':U TO FILL-IN_Sede.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Import-EDI W-Win 
PROCEDURE Import-EDI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER x-Archivo AS CHAR.
DEF OUTPUT PARAMETER x-NroControl AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR pCuenta AS INTE NO-UNDO.

DEF VAR x-Linea  AS CHAR FORMAT 'x(200)' NO-UNDO.
DEF VAR x-CodMat LIKE ITEM.codmat NO-UNDO.
DEF VAR x-CanPed LIKE ITEM.canped NO-UNDO.
DEF VAR x-ImpLin LIKE ITEM.implin NO-UNDO.
DEF VAR x-ImpIgv LIKE ITEM.impigv NO-UNDO.
DEF VAR x-Encabezado AS LOG INIT FALSE.
DEF VAR x-Detalle    AS LOG INIT FALSE.
DEF VAR x-NroItm AS INT INIT 0.
DEF VAR x-Ok AS LOG.
DEF VAR x-Item AS CHAR NO-UNDO.
  
DEFINE VARIABLE cSede   AS CHAR NO-UNDO.
DEFINE VARIABLE cCodCli AS CHAR NO-UNDO.

/* Limpiamos Detalle */
EMPTY TEMP-TABLE ITEM.

DEFINE VAR x-len AS INT.
DEFINE VAR x-pos AS INT.
DEFINE VAR x-len-oc AS INT INIT 12.         /* Caracteres de la O/C */
DEFINE VAR pCodMat AS CHAR NO-UNDO.
    
INPUT FROM VALUE(x-Archivo).
TEXTO:
REPEAT WITH FRAME {&FRAME-NAME}:
    IMPORT UNFORMATTED x-Linea.
    /* ************************************************************************************* */
    /* ENCABEZADO */
    /* ************************************************************************************* */
    IF x-Linea BEGINS 'ENC' THEN DO:
        ASSIGN
            x-Encabezado = YES
            x-Detalle    = NO
            x-CodMat = ''
            x-CanPed = 0
            x-ImpLin = 0
            x-ImpIgv = 0.
        ASSIGN
            x-Item = TRIM(ENTRY(6,x-Linea)).
        /* Ic - 26Set2018, correo pilar vega CASO 65407, 12 penultimos digitos (el ultimo NO) */
        IF LENGTH(x-item) > x-len-oc THEN DO:
            x-len = LENGTH(x-item) - 1.
            x-pos = (x-len - x-len-oc) + 1.
            x-item = SUBSTRING(x-item,x-pos,x-len-oc).
        END.
        /* Orden de Compra */
        FILL-IN_ordcmp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-Item.
/*         IF CAN-FIND(FIRST Faccpedi WHERE Faccpedi.codcia = s-codcia                         */
/*                     AND Faccpedi.coddiv = s-coddiv                                          */
/*                     AND Faccpedi.coddoc = s-coddoc                                          */
/*                     AND Faccpedi.ordcmp = x-Item                                            */
/*                     AND Faccpedi.flgest <> 'A' NO-LOCK)                                     */
/*             THEN DO:                                                                        */
/*             pMensaje = "Orden de Compra " + x-Item + " YA ha sido procesada anteriormente". */
/*             RETURN 'ADM-ERROR'.                                                             */
/*         END.                                                                                */
        /* Nro. de Control */
        x-NroControl = TRIM(ENTRY(4,x-Linea)).
    END.
    /* Sede y Lugar de Entrega en formato IBC */
    IF x-Linea BEGINS 'DPGR' AND NUM-ENTRIES(x-Linea) > 1 THEN DO:
        cSede = TRIM(ENTRY(2,x-Linea)).
    END.
    /* Cliente en formato IBC */
    IF x-Linea BEGINS 'IVAD' AND NUM-ENTRIES(x-Linea) > 1 THEN DO:
        cCodCli = TRIM(ENTRY(2,x-Linea)).
        /* BUSCAMOS CLIENTE POR SU CODIGO IBC */
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codibc = cCodCli    /* OJO */
            AND gn-clie.flgsit = 'A'
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            /* Si encontramos el cliente entonces lo actualizamos */
            ASSIGN
                s-codcli = gn-clie.codcli.
                FILL-IN_CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-clie.codcli.
            APPLY 'LEAVE':U TO FILL-IN_CodCli.
            FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.Libre_c01 = cSede NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clied THEN DO WITH FRAME {&FRAME-NAME}:
                /* Si encontramos la sede por código IBC entonces la actualizamos */
                ASSIGN
                    FILL-IN_Sede:SCREEN-VALUE = Gn-ClieD.Sede.
                ASSIGN 
                    f-Sede:SCREEN-VALUE = Gn-ClieD.DirCli
                    FILL-IN_Glosa:SCREEN-VALUE = (IF FILL-IN_Glosa:SCREEN-VALUE = '' THEN Gn-ClieD.DirCli ELSE FILL-IN_Glosa:SCREEN-VALUE).
                APPLY 'LEAVE':U TO FILL-IN_Sede.
            END.
        END.
    END.
    /* ************************************************************************************* */
    /* DETALLE */
    /* ************************************************************************************* */
    IF x-Linea BEGINS 'LIN' 
    THEN ASSIGN
            x-Encabezado = FALSE
            x-Detalle = YES.
    IF x-Detalle = YES THEN DO:
        IF x-Linea BEGINS 'LIN' 
        THEN DO:
            x-Item = ENTRY(2,x-Linea).
            IF NUM-ENTRIES(x-Linea) = 6
            THEN ASSIGN x-CodMat = STRING(INTEGER(ENTRY(6,x-Linea)), '999999') NO-ERROR.
            ELSE ASSIGN x-CodMat = ENTRY(3,x-Linea) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN x-CodMat = ENTRY(3,x-Linea).
        END.
        pCodMat = x-CodMat.
        RUN vta2/p-codigo-producto.r (INPUT-OUTPUT pCodMat, NO).
        IF TRUE <> ( pCodMat > '') THEN DO:
            pMensaje = "El Item " + STRING(x-Item) + ": " + x-codmat + " no esta registrado en el catálogo".
            RETURN 'ADM-ERROR'.
        END.
        x-CodMat = pCodMat.
        /* Se ubicó el Código Interno  */
        FIND Almmmatg WHERE almmmatg.codcia = s-codcia
            AND Almmmatg.codmat = x-codmat
            AND Almmmatg.tpoart <> 'D'
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg THEN DO:
            pMensaje = "El Item " + STRING(x-Item) + ": " + x-codmat + " no está activo en el catálogo".
            RETURN 'ADM-ERROR'.
        END.
        IF x-Linea BEGINS 'QTY' THEN x-CanPed = DECIMAL(ENTRY(2,x-Linea)).
        IF x-Linea BEGINS 'MOA' THEN x-ImpLin = DECIMAL(ENTRY(2,x-Linea)).
        IF x-Linea BEGINS 'TAX' THEN DO:
            ASSIGN
                x-ImpIgv = DECIMAL(ENTRY(3,x-Linea))
                x-NroItm = x-NroItm + 1.
            /* consistencia de duplicidad */
            FIND FIRST ITEM WHERE ITEM.codmat = x-CodMat NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ITEM THEN DO:
                CREATE ITEM.
                ASSIGN 
                    ITEM.CodCia = s-codcia
                    ITEM.codmat = x-CodMat
                    ITEM.Factor = 1 
                    ITEM.CanPed = x-CanPed
                    ITEM.NroItm = x-NroItm 
                    ITEM.UndVta = (IF AVAILABLE Almmmatg THEN Almmmatg.Chr__01 ELSE '')
                    ITEM.ALMDES = S-CODALM
                    ITEM.AftIgv = (IF x-ImpIgv > 0 THEN YES ELSE NO)
                    NO-ERROR.
                IF ERROR-STATUS:ERROR = YES THEN DO:
                    {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="pCuenta"}
                    RETURN 'ADM-ERROR'.
                END.
                /* RHC 09.08.06 IGV de acuerdo al cliente */
                IF LOOKUP(TRIM(s-CodCli), '20100070970,20109072177,20100106915,20504912851') > 0
                THEN ASSIGN
                        ITEM.ImpIgv = x-ImpIgv 
                        ITEM.ImpLin = x-ImpLin
                        ITEM.PreUni = ROUND(ITEM.ImpLin / ITEM.CanPed, s-NroDec).
                ELSE ASSIGN
                        ITEM.ImpIgv = x-ImpIgv 
                        ITEM.ImpLin = x-ImpLin + x-ImpIgv
                        ITEM.PreUni = ROUND(ITEM.ImpLin / ITEM.CanPed, s-NroDec).
            END.    /* fin de grabacion del detalle */
        END.
    END.
END.
INPUT CLOSE.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Import-PackingList W-Win 
PROCEDURE Import-PackingList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER x-Archivo AS CHAR.
DEF OUTPUT PARAMETER x-NroControl AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR pCuenta AS INTE NO-UNDO.

DEF VAR x-Linea   AS CHAR FORMAT 'x(200)' NO-UNDO.
DEF VAR x-CodMat LIKE ITEM.codmat NO-UNDO.
DEF VAR x-CanPed LIKE ITEM.canped NO-UNDO.
DEF VAR x-Factor AS DEC NO-UNDO.
DEF VAR x-NroItm AS INT INIT 0.
  
DEFINE VARIABLE cSede    AS CHAR NO-UNDO.
DEFINE VARIABLE cNomSede AS CHAR NO-UNDO.
DEFINE VARIABLE pCodMat AS CHAR NO-UNDO.

/* Limpiamos Detalle */
EMPTY TEMP-TABLE ITEM-2.

DEFINE VAR x-pos AS INT.
    
INPUT FROM VALUE(x-Archivo).
x-Pos = 0.
x-NroItm = -1.
REPEAT WITH FRAME {&FRAME-NAME}:
    IMPORT UNFORMATTED x-Linea.
    IF TRUE <> (x-Linea > '') THEN LEAVE.
    x-Pos = x-Pos + 1.
    x-NroItm = x-NroItm + 1.
    /* La primera línea es el encabezado */
    IF x-Pos = 1 AND
        x-Linea <> "|DV_RUT|RAZON_SOCIAL|FECHA_EMISION|UPC|SKU|DESCRIPCION_LARGA|MODELO|TALLA|COLOR|NRO_LOCAL|LOCAL|UNIDADES|EMPAQUES"
        THEN LEAVE.
    IF x-Pos = 1 THEN NEXT.
    /* ********************************* */
    x-NroControl = TRIM(ENTRY(1,x-Linea,'|')).
    ASSIGN
        x-CodMat = TRIM(ENTRY(5,x-Linea,'|'))
        x-CanPed = DECIMAL(TRIM(ENTRY(13,x-Linea,'|')))
        x-Factor = DECIMAL(TRIM(ENTRY(14,x-Linea,'|')))
        cSede = TRIM(ENTRY(11,x-Linea,'|'))
        cNomSede = TRIM(ENTRY(12,x-Linea,'|'))
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = 'Error en el Packing List línea ' + STRING(x-Pos).
        INPUT CLOSE.
        RETURN 'ADM-ERROR'.
    END.
    pCodMat = x-CodMat.
    RUN vta2/p-codigo-producto.r (INPUT-OUTPUT pCodMat, NO).
    IF TRUE <> (pCodMat > '') THEN DO:
        pMensaje = 'Error en el código del artículo ' + x-CodMat + ' en la línea ' + STRING(x-Pos).
        INPUT CLOSE.
        RETURN 'ADM-ERROR'.
    END.
    x-CodMat = pCodMat.

    CREATE ITEM-2.
    ASSIGN
        ITEM-2.CodCia = s-CodCia
        ITEM-2.NroPed = cSede
        ITEM-2.NroItm = x-NroItm
        ITEM-2.codmat = x-CodMat
        ITEM-2.CanPed = x-CanPed
        ITEM-2.Factor = 1
        ITEM-2.Libre_c01 = cSede
        ITEM-2.Libre_c02 = cNomSede
        NO-ERROR
        .
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="pCuenta"}
        RETURN 'ADM-ERROR'.
    END.
END.
INPUT CLOSE.
/* CALCULAMOS IMPORTES */
FOR EACH ITEM-2 EXCLUSIVE-LOCK, 
    FIRST Almmmatg OF ITEM-2 NO-LOCK,
    FIRST Almsfami OF Almmmatg NO-LOCK,
    FIRST ITEM NO-LOCK WHERE ITEM.CodMat = ITEM-2.CodMat:
    ASSIGN 
        ITEM-2.AftIgv = ITEM.AftIgv
        ITEM-2.PreUni = ITEM.PreUni.
    /* ***************************************************************** */
    {vtagn/CalculoDetalleMayorCredito.i &Tabla="ITEM-2" }
    /* ***************************************************************** */
END.
/* PACKING LIST POR SEDE */
EMPTY TEMP-TABLE CPEDI.
FOR EACH ITEM-2 NO-LOCK BREAK BY ITEM-2.Libre_c01:
    IF FIRST-OF(ITEM-2.Libre_c01) THEN DO:
        CREATE CPEDI.
        ASSIGN
            CPEDI.NroPed = ITEM-2.Libre_c02
            CPEDI.Sede   = ITEM-2.Libre_c01
            CPEDI.LugEnt = ITEM-2.Libre_c02.
    END.
    ASSIGN
        CPEDI.ImpTot = CPEDI.ImpTot + ITEM-2.ImpLin.
END.

RETURN "OK".

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      CASE TRUE:
          WHEN s-Import-IBC = YES THEN DO:
              BUTTON-EDI:SENSITIVE = YES.
              BUTTON-PackingList:SENSITIVE = YES.
          END.
          WHEN s-Import-B2B = YES THEN DO:
              BUTTON-Excel:SENSITIVE = YES.
          END.
      END CASE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle W-Win 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodMat AS CHAR.

RUN Captura-Parametro IN h_t-import-edi-ibc-sede
    ( INPUT pCodMat /* CHARACTER */).


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
  {src/adm/template/snd-list.i "FacCPedi"}

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

