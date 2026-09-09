&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-Lista FOR GN-DIVI.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE TEMP-TABLE T-CPEDI NO-UNDO LIKE FacCPedi.



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

DEF SHARED VAR s-codcia AS INT.

DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE VAR cNroCotizacion AS CHAR.
DEF VAR x-FlgSit AS CHAR INIT 'Todos' NO-UNDO.

DEFINE TEMP-TABLE tt-cotiza
    FIELD   Situacion   AS CHAR FORMAT 'x(10)'  COLUMN-LABEL "Situación"
    FIELD   Estado      AS CHAR FORMAT 'x(10)'  COLUMN-LABEL "Estado"
    FIELD   cotizacion  AS CHAR FORMAT 'x(15)'  COLUMN-LABEL "Cotizacion"
    FIELD   Origen      AS CHAR FORMAT 'x(10)'  COLUMN-LABEL "Origen"
    FIELD   ListaPrecio AS CHAR FORMAT 'x(10)'  COLUMN-LABEL "Lista Precio"
    FIELD   Emision     AS DATE                 COLUMN-LABEL "Emision"
    FIELD   Fechent     AS DATE                 COLUMN-LABEL "Fecha Entrega"
    FIELD   Cliente     AS CHAR FORMAT 'x(11)'  COLUMN-LABEL "Cliente"
    FIELD   nombre      AS CHAR FORMAT 'x(60)'  COLUMN-LABEL "Nombre"
    FIELD   CasoA       AS CHAR FORMAT 'X(5)'   COLUMN-LABEL "Caso A"
    FIELD   CasoB       AS CHAR FORMAT 'X(5)'   COLUMN-LABEL "Caso B"
    FIELD   CasoC       AS CHAR FORMAT 'X(5)'   COLUMN-LABEL "Caso C"
    FIELD   CasoD       AS CHAR FORMAT 'X(5)'   COLUMN-LABEL "Caso D"
    FIELD   pestot      AS DEC  FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Peso Total kg"
    FIELD   pespend     AS DEC  FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Peso Pendiente kg"
    FIELD   PesDis      AS DEC  FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Disponible x Atender kg"
    FIELD   usuario     AS CHAR FORMAT 'x(12)'  COLUMN-LABEL "Usuario"
    FIELD   imptot      AS DEC  FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Importe Total"
    .
DEFINE TEMP-TABLE Detalle
    FIELD Situacion     LIKE tt-cotiza.Situacion
    FIELD Estado        LIKE tt-cotiza.Estado
    FIELD cotizacion    LIKE tt-cotiza.Cotizacion
    FIELD Origen        LIKE tt-cotiza.Origen
    FIELD ListaPrecio   LIKE tt-cotiza.ListaPrecio
    FIELD Emision       LIKE tt-cotiza.Emision
    FIELD Fechent       LIKE tt-cotiza.FechEnt
    FIELD Cliente       LIKE tt-cotiza.Cliente
    FIELD nombre        LIKE tt-cotiza.Nombre
    FIELD TipVta        AS CHAR FORMAT 'x(2)'   COLUMN-LABEL 'Caso'
    FIELD CodAlm        AS CHAR FORMAT 'x(6)'   COLUMN-LABEL 'Alm'
    FIELD CodMat        AS CHAR FORMAT 'x(6)'   COLUMN-LABEL 'Código'
    FIELD DesMat        AS CHAR FORMAT 'x(100)' COLUMN-LABEL 'Descripción'
    FIELD DesMar        AS CHAR FORMAT 'x(20)'  COLUMN-LABEL 'Marca'
    FIELD UndVta        AS CHAR FORMAT 'x(6)'   COLUMN-LABEL 'Unidad'
    FIELD CanPed        AS DEC FORMAT '->>>,>>9.99' COLUMN-LABEL 'Solicitada'
    FIELD CanAte        AS DEC FORMAT '->>>,>>9.99' COLUMN-LABEL 'Solicitada'
    FIELD Saldo         AS DEC FORMAT '->>>,>>9.99' COLUMN-LABEL 'Por atender'
    FIELD StkAct        AS DEC FORMAT '->>>,>>9.99' COLUMN-LABEL 'Disponible Almacén'
    .

DEFINE VAR x-sort-direccion AS CHAR INIT "".
DEFINE VAR x-sort-column    AS CHAR INIT "".

DEFINE VAR xEsFeriaLaListaPrecio AS LOG INIT NO.

DEFINE VAR xCasoA AS CHAR NO-UNDO.
DEFINE VAR xCasoB AS CHAR NO-UNDO.
DEFINE VAR xCasoC AS CHAR NO-UNDO.
DEFINE VAR xCasoD AS CHAR NO-UNDO.
DEFINE VAR xPesoDispoAlm AS DEC NO-UNDO.

&SCOPED-DEFINE Condicion ( ~
FacCPedi.CodCia = s-codcia ~
AND (TRUE <> (x-CodDiv > "") OR LOOKUP(FacCPedi.CodDiv, x-CodDiv) > 0) ~
AND FacCPedi.CodDoc = "COT" ~
AND (TRUE <> (txtCotizacion > "") OR faccpedi.nroped BEGINS txtCotizacion) ~
AND FacCPedi.FchPed >= Desde AND FacCPedi.FchPed <= Hasta ~
AND FacCPedi.FlgEst = "P" ~
AND (TRUE <> (x-NomCli > "") OR INDEX(FacCPedi.NomCli, x-NomCli) > 0 ) ~
AND ( TRUE <> (x-Lista > "")  OR LOOKUP(FacCPedi.Libre_c01, x-Lista) > 0 ) ~
AND ( FacCPedi.fchent >= desde-2 AND FacCpedi.fchent <= hasta-2 ) ~
AND ( x-FlgSit = "Todos" OR FacCPedi.Libre_c02 = x-FlgSit ) ~
)

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-CPEDI FacCPedi

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 FacCPedi.NroPed FacCPedi.Libre_c02 ~
T-CPEDI.FlgEst FacCPedi.CodDiv FacCPedi.Libre_c01 FacCPedi.CodCli ~
FacCPedi.NomCli fGetAlmCaso(faccpedi.lugent2,1) @ xCasoA ~
fGetAlmCaso(faccpedi.lugent2,2) @ xCasoB ~
fGetAlmCaso(faccpedi.lugent2,3) @ xCasoC ~
fGetAlmCaso(faccpedi.lugent2,4) @ xCasoD fTotPeso() @ FacCPedi.Libre_d01 ~
fTotPesoPendiente() @ FacCPedi.Libre_d02 ~
fPesoDispoAlm(faccpedi.lugent2) @ xPesoDispoAlm FacCPedi.FchEnt ~
FacCPedi.usuario FacCPedi.ImpTot FacCPedi.FchPed 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 FacCPedi.FchEnt 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-3 FacCPedi
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-3 FacCPedi
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH T-CPEDI NO-LOCK, ~
      FIRST FacCPedi OF T-CPEDI NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH T-CPEDI NO-LOCK, ~
      FIRST FacCPedi OF T-CPEDI NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 T-CPEDI FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 T-CPEDI
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-3 FacCPedi


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-Procesado BUTTON-5 ~
COMBO-BOX-Situacion FILL-IN-CodMat txtCotizacion Desde Hasta Desde-2 ~
Hasta-2 x-NomCli x-CodAlm BUTTON-1 BUTTON-2 BUTTON-4 BROWSE-3 x-CodAlmB ~
x-CodAlmC x-CodAlmD BUTTON-6 COMBO-BOX-Estado BUTTON-7 RECT-26 RECT-55 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Situacion FILL-IN-CodMat ~
x-CodDiv txtCotizacion Desde Hasta Desde-2 Hasta-2 x-NomCli x-CodAlm ~
x-CodAlmB x-CodAlmC x-CodAlmD x-Lista COMBO-BOX-Estado 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fAlmDes W-Win 
FUNCTION fAlmDes RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fGetAlmCaso W-Win 
FUNCTION fGetAlmCaso RETURNS CHARACTER
  ( pCasoAlmCasos AS CHAR, pNumCaso AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPesoDispoAlm W-Win 
FUNCTION fPesoDispoAlm RETURNS DECIMAL
  ( pCasoAlmCasos AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fStkAct W-Win 
FUNCTION fStkAct RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fTotPeso W-Win 
FUNCTION fTotPeso RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fTotPesoPendiente W-Win 
FUNCTION fTotPesoPendiente RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "ASIGNA ALMACEN DE DISTRIBUCION" 
     SIZE 31 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "EXCEL CABECERA" 
     SIZE 16 BY 1.12.

DEFINE BUTTON BUTTON-4 
     LABEL "CONSULTAR" 
     SIZE 15 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img/find.bmp":U
     LABEL "Button 5" 
     SIZE 5 BY 1.12.

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "img/find.bmp":U
     LABEL "Button 6" 
     SIZE 5 BY 1.12.

DEFINE BUTTON BUTTON-7 
     LABEL "EXCEL DETALLE" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Procesado 
     LABEL "CAMBIAR SITUACION" 
     SIZE 22 BY 1.12.

DEFINE VARIABLE COMBO-BOX-Estado AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Estado" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Pendiente","En Proceso" 
     DROP-DOWN-LIST
     SIZE 13 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Situacion AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Situación" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todos","Todos",
                     "Procesado","PROCESADO",
                     "No Procesado","NP"
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-CodAlm AS CHARACTER FORMAT "X(256)":U INITIAL "Dejar como esta" 
     LABEL "CASO A" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Dejar como esta","Dejar como esta"
     DROP-DOWN-LIST
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE x-CodAlmB AS CHARACTER FORMAT "X(256)":U INITIAL "Dejar como esta" 
     LABEL "CASO B" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Dejar como esta","Dejar como esta"
     DROP-DOWN-LIST
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE x-CodAlmC AS CHARACTER FORMAT "X(256)":U INITIAL "Dejar como esta" 
     LABEL "CASO C" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Dejar como esta","Dejar como esta"
     DROP-DOWN-LIST
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE x-CodAlmD AS CHARACTER FORMAT "X(256)":U INITIAL "Dejar como esta" 
     LABEL "CASO D" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Dejar como esta","Dejar como esta"
     DROP-DOWN-LIST
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE x-CodDiv AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 55 BY 1.62
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE x-Lista AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 55 BY 1.62
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE Desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE Desde-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Entregas Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodMat AS CHARACTER FORMAT "X(6)":U 
     LABEL "Artículo" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE Hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE Hasta-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txtCotizacion AS CHARACTER FORMAT "X(12)":U 
     LABEL "Nro. Cotización" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 29 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 53 BY 6.19
     BGCOLOR 15 FGCOLOR 0 .

DEFINE RECTANGLE RECT-55
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 145 BY 6.19.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      T-CPEDI, 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      FacCPedi.NroPed COLUMN-LABEL "Cotización" FORMAT "X(12)":U
      FacCPedi.Libre_c02 COLUMN-LABEL "Situacion" FORMAT "x(10)":U
            WIDTH 10.29
      T-CPEDI.FlgEst FORMAT "x(10)":U WIDTH 10.43
      FacCPedi.CodDiv COLUMN-LABEL "Origen" FORMAT "x(5)":U
      FacCPedi.Libre_c01 COLUMN-LABEL "Lista!Precios" FORMAT "x(5)":U
            WIDTH 5.72
      FacCPedi.CodCli COLUMN-LABEL "Cliente" FORMAT "x(11)":U WIDTH 10
      FacCPedi.NomCli FORMAT "x(50)":U WIDTH 29.43
      fGetAlmCaso(faccpedi.lugent2,1) @ xCasoA COLUMN-LABEL "  A" FORMAT "x(5)":U
            WIDTH 4.29 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      fGetAlmCaso(faccpedi.lugent2,2) @ xCasoB COLUMN-LABEL "  B" FORMAT "x(5)":U
            WIDTH 4.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      fGetAlmCaso(faccpedi.lugent2,3) @ xCasoC COLUMN-LABEL "  C" FORMAT "x(5)":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      fGetAlmCaso(faccpedi.lugent2,4) @ xCasoD COLUMN-LABEL "  D" FORMAT "x(5)":U
            WIDTH 3.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      fTotPeso() @ FacCPedi.Libre_d01 COLUMN-LABEL "Total Peso!Kg." FORMAT ">>>,>>9.99":U
            WIDTH 8.72
      fTotPesoPendiente() @ FacCPedi.Libre_d02 COLUMN-LABEL "Peso!pendiente" FORMAT "->>,>>>,>>9.99":U
            WIDTH 9.14
      fPesoDispoAlm(faccpedi.lugent2) @ xPesoDispoAlm COLUMN-LABEL "Disponible por!atender Kgs."
      FacCPedi.FchEnt FORMAT "99/99/9999":U COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 13
      FacCPedi.usuario COLUMN-LABEL "Usuario" FORMAT "x(10)":U
            WIDTH 7.29
      FacCPedi.ImpTot FORMAT "->>,>>>,>>9.99":U WIDTH 10
      FacCPedi.FchPed COLUMN-LABEL "Emisión" FORMAT "99/99/9999":U
            WIDTH 8.86
  ENABLE
      FacCPedi.FchEnt
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 145 BY 17.15
         FONT 4
         TITLE "Seleccione la(s) Cotizacion(es)".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Procesado AT ROW 24.69 COL 81 WIDGET-ID 62
     BUTTON-5 AT ROW 1.54 COL 71 WIDGET-ID 48
     COMBO-BOX-Situacion AT ROW 5.58 COL 56 COLON-ALIGNED WIDGET-ID 58
     FILL-IN-CodMat AT ROW 6.38 COL 56 COLON-ALIGNED WIDGET-ID 60
     x-CodDiv AT ROW 1.54 COL 15 NO-LABEL WIDGET-ID 44
     txtCotizacion AT ROW 6.38 COL 13 COLON-ALIGNED WIDGET-ID 32
     Desde AT ROW 4.77 COL 13 COLON-ALIGNED WIDGET-ID 2
     Hasta AT ROW 4.77 COL 31 COLON-ALIGNED WIDGET-ID 4
     Desde-2 AT ROW 4.77 COL 56 COLON-ALIGNED WIDGET-ID 30
     Hasta-2 AT ROW 4.77 COL 78 COLON-ALIGNED WIDGET-ID 28
     x-NomCli AT ROW 5.58 COL 13 COLON-ALIGNED WIDGET-ID 18
     x-CodAlm AT ROW 1.62 COL 100 COLON-ALIGNED WIDGET-ID 10
     BUTTON-1 AT ROW 5.85 COL 102 WIDGET-ID 16
     BUTTON-2 AT ROW 24.69 COL 103 WIDGET-ID 22
     BUTTON-4 AT ROW 1.54 COL 78 WIDGET-ID 26
     BROWSE-3 AT ROW 7.46 COL 2 WIDGET-ID 200
     x-CodAlmB AT ROW 2.62 COL 100 COLON-ALIGNED WIDGET-ID 38
     x-CodAlmC AT ROW 3.62 COL 100 COLON-ALIGNED WIDGET-ID 40
     x-CodAlmD AT ROW 4.69 COL 100 COLON-ALIGNED WIDGET-ID 42
     x-Lista AT ROW 3.15 COL 15 NO-LABEL WIDGET-ID 52
     BUTTON-6 AT ROW 3.15 COL 71 WIDGET-ID 54
     COMBO-BOX-Estado AT ROW 5.58 COL 78 COLON-ALIGNED WIDGET-ID 64
     BUTTON-7 AT ROW 24.69 COL 119 WIDGET-ID 66
     "Filtros" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1 COL 3 WIDGET-ID 14
          BGCOLOR 9 FGCOLOR 15 
     "Origen:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 1.54 COL 9 WIDGET-ID 46
     "Lista de Precios:" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 3.15 COL 3 WIDGET-ID 50
     "DobleClick en COTIZACION para mirar el detalle" VIEW-AS TEXT
          SIZE 63 BY 1 AT ROW 25 COL 14 WIDGET-ID 36
          BGCOLOR 15 FGCOLOR 9 FONT 11
     RECT-26 AT ROW 1.27 COL 94 WIDGET-ID 12
     RECT-55 AT ROW 1.27 COL 2 WIDGET-ID 56
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 148.14 BY 25.27
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-Lista B "?" ? INTEGRAL GN-DIVI
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: T-CPEDI T "?" NO-UNDO INTEGRAL FacCPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ASIGNACION DEL ALMACEN DE DISTRIBUCION"
         HEIGHT             = 25.27
         WIDTH              = 148.14
         MAX-HEIGHT         = 31.35
         MAX-WIDTH          = 164.57
         VIRTUAL-HEIGHT     = 31.35
         VIRTUAL-WIDTH      = 164.57
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-3 BUTTON-4 F-Main */
ASSIGN 
       BROWSE-3:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 7
       BROWSE-3:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* SETTINGS FOR EDITOR x-CodDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR x-Lista IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.T-CPEDI,INTEGRAL.FacCPedi OF Temp-Tables.T-CPEDI"
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST, FIRST USED"
     _FldNameList[1]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Cotización" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCPedi.Libre_c02
"FacCPedi.Libre_c02" "Situacion" "x(10)" "character" ? ? ? ? ? ? no ? no no "10.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-CPEDI.FlgEst
"T-CPEDI.FlgEst" ? "x(10)" "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.CodDiv
"FacCPedi.CodDiv" "Origen" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacCPedi.Libre_c01
"FacCPedi.Libre_c01" "Lista!Precios" "x(5)" "character" ? ? ? ? ? ? no ? no no "5.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacCPedi.CodCli
"FacCPedi.CodCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "29.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"fGetAlmCaso(faccpedi.lugent2,1) @ xCasoA" "  A" "x(5)" ? 14 0 ? ? ? ? no ? no no "4.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"fGetAlmCaso(faccpedi.lugent2,2) @ xCasoB" "  B" "x(5)" ? 14 0 ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"fGetAlmCaso(faccpedi.lugent2,3) @ xCasoC" "  C" "x(5)" ? 14 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"fGetAlmCaso(faccpedi.lugent2,4) @ xCasoD" "  D" "x(5)" ? 14 0 ? ? ? ? no ? no no "3.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"fTotPeso() @ FacCPedi.Libre_d01" "Total Peso!Kg." ">>>,>>9.99" ? ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"fTotPesoPendiente() @ FacCPedi.Libre_d02" "Peso!pendiente" "->>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"fPesoDispoAlm(faccpedi.lugent2) @ xPesoDispoAlm" "Disponible por!atender Kgs." ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > INTEGRAL.FacCPedi.FchEnt
"FacCPedi.FchEnt" ? ? "date" 13 15 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > INTEGRAL.FacCPedi.usuario
"FacCPedi.usuario" "Usuario" ? "character" ? ? ? ? ? ? no ? no no "7.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > INTEGRAL.FacCPedi.ImpTot
"FacCPedi.ImpTot" ? ? "decimal" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Emisión" ? "date" ? ? ? ? ? ? no ? no no "8.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ASIGNACION DEL ALMACEN DE DISTRIBUCION */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ASIGNACION DEL ALMACEN DE DISTRIBUCION */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&Scoped-define SELF-NAME BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-3 IN FRAME F-Main /* Seleccione la(s) Cotizacion(es) */
DO:
    IF AVAILABLE faccpedi THEN DO:
        RUN vta2/w-cotizacion-consulta(INPUT faccpedi.nroped).  
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 W-Win
ON START-SEARCH OF BROWSE-3 IN FRAME F-Main /* Seleccione la(s) Cotizacion(es) */
DO:
    DEFINE VARIABLE hSortColumn AS WIDGET-HANDLE.
    DEFINE VAR lColumName AS CHAR.
    DEFINE VAR hQueryHandle AS HANDLE NO-UNDO.

    hSortColumn = BROWSE BROWSE-3:CURRENT-COLUMN.
    lColumName = hSortColumn:NAME.
    lColumName = TRIM(REPLACE(lColumName," no","")).

    IF lColumName BEGINS 'x' THEN RETURN.

    IF CAPS(lColumName) <> CAPS(x-sort-column) THEN DO:
        x-sort-direccion = "".
    END.
    ELSE DO:
        IF x-sort-direccion = "" THEN DO:
            x-sort-direccion = "DESC".
        END.
        ELSE DO:            
            x-sort-direccion = "".
        END.
    END.
    x-sort-column = lColumName.

    DEFINE VAR lSQL AS LONGCHAR.

    hQueryHandle = BROWSE BROWSE-3:QUERY.
    hQueryHandle:QUERY-CLOSE().
    /**--- Este valor debe ser el QUERY que esta definido en el BROWSE.*/
    lSQL = "FOR EACH T-CPEDI NO-LOCK, FIRST FacCPedi OF T-CPEDI NO-LOCK ".
    lSQL = lSQL + " BY " + lColumName + " " + x-sort-direccion.

    hQueryHandle:QUERY-PREPARE(STRING(lSQL)).
    hQueryHandle:QUERY-OPEN().  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ASIGNA ALMACEN DE DISTRIBUCION */
DO:
  MESSAGE 'Procedemos a ASIGNAR LOS ALMACENES?' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.

  ASSIGN x-CodAlm x-CodAlmB x-CodAlmC x-CodAlmD.
  IF x-CodAlm BEGINS 'Seleccione' THEN RETURN NO-APPLY.
  IF x-CodAlmB BEGINS 'Seleccione' THEN RETURN NO-APPLY.
  IF x-CodAlmC BEGINS 'Seleccione' THEN RETURN NO-APPLY.
  IF x-CodAlmD BEGINS 'Seleccione' THEN RETURN NO-APPLY.
  RUN Asigna-Almacen.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* EXCEL CABECERA */
DO:
  RUN ue-excel.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* CONSULTAR */
DO:
    ASSIGN x-coddiv x-lista desde hasta x-nomcli desde-2 hasta-2 txtCotizacion.
    ASSIGN COMBO-BOX-Situacion.
    ASSIGN FILL-IN-CodMat.
    ASSIGN COMBO-BOX-Estado.
    x-FlgSit = COMBO-BOX-Situacion.
    IF COMBO-BOX-Situacion = 'NP' THEN x-FlgSit = ''.
    /* Consistencias */
    IF TRUE <> (x-Lista > '') THEN DO:
        MESSAGE 'Debe seleccionar al menos una lista de precios' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Carga-Temporal.
    {&OPEN-QUERY-{&BROWSE-NAME}}
    SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 5 */
DO:
  DEF VAR pDivisiones AS CHAR NO-UNDO.
  pDivisiones = x-CodDiv:SCREEN-VALUE.
  RUN gn/d-filtro-divisiones (INPUT-OUTPUT pDivisiones, "SELECCIONE LA DIVISION ORIGEN").
  x-CodDiv:SCREEN-VALUE = pDivisiones.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Button 6 */
DO:
  DEF VAR pDivisiones AS CHAR NO-UNDO.
  pDivisiones = x-Lista:SCREEN-VALUE.
  /*RUN gn/d-filtro-listaprecios (INPUT-OUTPUT pDivisiones, "SELECCIONE LA LISTA DE PRECIOS").*/
  RUN gn/d-filtro-divisiones (INPUT-OUTPUT pDivisiones, "SELECCIONE LA DIVISION").
  x-Lista:SCREEN-VALUE = pDivisiones.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 W-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* EXCEL DETALLE */
DO:
  RUN ue-excel-detalle.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Procesado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Procesado W-Win
ON CHOOSE OF BUTTON-Procesado IN FRAME F-Main /* CAMBIAR SITUACION */
DO:
  RUN Marca-Procesado.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Desde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Desde W-Win
ON LEAVE OF Desde IN FRAME F-Main /* Emitidos Desde */
DO:
    ASSIGN {&self-name}.
    /*{&OPEN-QUERY-{&BROWSE-NAME}}*/
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Desde-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Desde-2 W-Win
ON LEAVE OF Desde-2 IN FRAME F-Main /* Entregas Desde */
DO:
    ASSIGN {&self-name}.
    /*{&OPEN-QUERY-{&BROWSE-NAME}}*/
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Hasta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Hasta W-Win
ON LEAVE OF Hasta IN FRAME F-Main /* Hasta */
DO:
    ASSIGN {&self-name}.
    /*{&OPEN-QUERY-{&BROWSE-NAME}}*/
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Hasta-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Hasta-2 W-Win
ON LEAVE OF Hasta-2 IN FRAME F-Main /* Hasta */
DO:
    ASSIGN {&self-name}.
    /*{&OPEN-QUERY-{&BROWSE-NAME}}*/
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-NomCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NomCli W-Win
ON ANY-PRINTABLE OF x-NomCli IN FRAME F-Main /* Cliente */
DO:
    x-nomcli = SELF:SCREEN-VALUE + LAST-EVENT:LABEL.
    /*
    {&OPEN-QUERY-{&BROWSE-NAME}}
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NomCli W-Win
ON LEAVE OF x-NomCli IN FRAME F-Main /* Cliente */
DO:
    x-nomcli = SELF:SCREEN-VALUE /*+ LAST-EVENT:LABEL.*/.
    /*{&OPEN-QUERY-{&BROWSE-NAME}}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Almacen W-Win 
PROCEDURE Asigna-Almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k AS INT NO-UNDO.

DEFINE VAR xAlmActual AS CHAR.
DEFINE VAR xAlmNuevo AS CHAR.

DEFINE VAR xAlmCasoA AS CHAR.
DEFINE VAR xAlmCasoB AS CHAR.
DEFINE VAR xAlmCasoC AS CHAR.
DEFINE VAR xAlmCasoD AS CHAR.

DEFINE VAR xAlmActualCasoA AS CHAR.
DEFINE VAR xAlmActualCasoB AS CHAR.
DEFINE VAR xAlmActualCasoC AS CHAR.
DEFINE VAR xAlmActualCasoD AS CHAR.

/*

      x-CodAlm:ADD-LAST('Dejar como esta' , 'Dejar como esta' ).
      x-CodAlm:ADD-LAST('Blanquear' , 'Blanquear' ).
*/
SESSION:SET-WAIT-STATE('GENERAL').
DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN DO:
        {lib/lock-genericov2.i &Tabla="COTIZACION" ~
            &Condicion="ROWID(COTIZACION)=ROWID(Faccpedi)" ~
            &Accion="RETRY" ~
            &Mensaje="YES" ~
            &TipoError="NEXT"
            }

        xAlmActual = COTIZACION.LugEnt2.

        xAlmActualCasoA = "".
        xAlmActualCasoB = "".
        xAlmActualCasoC = "".
        xAlmActualCasoD = "".

        IF NUM-ENTRIES(xAlmActual,",") >= 1 THEN xAlmActualCasoA = ENTRY(1,xAlmActual,",").
        IF NUM-ENTRIES(xAlmActual,",") >= 2 THEN xAlmActualCasoB = ENTRY(2,xAlmActual,",").
        IF NUM-ENTRIES(xAlmActual,",") >= 3 THEN xAlmActualCasoC = ENTRY(3,xAlmActual,",").
        IF NUM-ENTRIES(xAlmActual,",") >= 4 THEN xAlmActualCasoD = ENTRY(4,xAlmActual,",").

        xAlmCasoA = x-CodAlm.
        xAlmCasoB = x-CodAlmB.
        xAlmCasoC = x-CodAlmC.
        xAlmCasoD = x-CodAlmD.        

        IF xAlmCasoA = "Dejar como esta" THEN xAlmCasoA = xAlmActualCasoA.
        IF xAlmCasoA = "Blanquear" THEN xAlmCasoA = "".
        IF xAlmCasoB = "Dejar como esta" THEN xAlmCasoB = xAlmActualCasoB.
        IF xAlmCasoB = "Blanquear" THEN xAlmCasoB = "".
        IF xAlmCasoC = "Dejar como esta" THEN xAlmCasoC = xAlmActualCasoC.
        IF xAlmCasoC = "Blanquear" THEN xAlmCasoC = "".
        IF xAlmCasoD = "Dejar como esta" THEN xAlmCasoD = xAlmActualCasoD.
        IF xAlmCasoD = "Blanquear" THEN xAlmCasoD = "".

        /*x-CodAlm = xAlmCasoA.*/
        IF xEsFeriaLaListaPrecio = YES THEN DO:
            xAlmNuevo = xAlmCasoA + "," + xAlmCasoB + "," + xAlmCasoC + "," + xAlmCasoD.
        END.
        ELSE xAlmNuevo =  xAlmCasoA.

        ASSIGN
            COTIZACION.LugEnt2 = xAlmNuevo.
    END.
END.
RELEASE COTIZACION.
{&OPEN-QUERY-{&BROWSE-NAME}}

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/*
  Tabla: "Almacen"
  Condicion: "Almacen.codcia = s-codcia AND Almacen.codalm = s-codalm"
  Bloqueo: "EXCLUSIVE-LOCK (NO-WAIT)"
  Accion: "RETRY" | "LEAVE"
  Mensaje: "YES" | "NO"
  TipoError: "RETURN 'ADM-ERROR'" | "RETURN ERROR" |  "NEXT"
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER B-DPEDI FOR Facdpedi.                   
EMPTY TEMP-TABLE T-CPEDI.                                
FOR EACH Faccpedi NO-LOCK WHERE {&Condicion}, 
    FIRST Facdpedi OF Faccpedi NO-LOCK WHERE (TRUE <> (FILL-IN-CodMat > '') OR FacDPedi.codmat = FILL-IN-CodMat):
    IF COMBO-BOX-Estado = "Pendiente" THEN DO:
        FIND FIRST B-DPEDI OF Faccpedi WHERE B-DPEDI.CanAte > 0 NO-LOCK NO-ERROR.
        IF AVAILABLE B-DPEDI THEN NEXT.
    END.
    IF COMBO-BOX-Estado = "En Proceso" THEN DO:
        FIND FIRST B-DPEDI OF Faccpedi WHERE B-DPEDI.CanAte > 0 NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-DPEDI THEN NEXT.
    END.
    CREATE T-CPEDI.
    BUFFER-COPY Faccpedi TO T-CPEDI.
    FIND FIRST B-DPEDI OF Faccpedi WHERE B-DPEDI.CanAte > 0 NO-LOCK NO-ERROR.
    IF AVAILABLE B-DPEDI THEN T-CPEDI.FlgEst = "En Proceso".
    ELSE T-CPEDI.FlgEst = "Pendiente".

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
  DISPLAY COMBO-BOX-Situacion FILL-IN-CodMat x-CodDiv txtCotizacion Desde Hasta 
          Desde-2 Hasta-2 x-NomCli x-CodAlm x-CodAlmB x-CodAlmC x-CodAlmD 
          x-Lista COMBO-BOX-Estado 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-Procesado BUTTON-5 COMBO-BOX-Situacion FILL-IN-CodMat 
         txtCotizacion Desde Hasta Desde-2 Hasta-2 x-NomCli x-CodAlm BUTTON-1 
         BUTTON-2 BUTTON-4 BROWSE-3 x-CodAlmB x-CodAlmC x-CodAlmD BUTTON-6 
         COMBO-BOX-Estado BUTTON-7 RECT-26 RECT-55 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable W-Win 
PROCEDURE local-enable :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  ASSIGN
      Desde = TODAY - DAY(TODAY) + 1
      Hasta = TODAY
      Desde-2 = TODAY - DAY(TODAY) + 1
      Hasta-2 = TODAY
      x-CodDiv = ''.
      

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
/*       x-CodDiv:DELETE('Todos').                                                         */
/*       FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:                         */
/*           x-CodDiv:ADD-LAST( GN-DIVI.CodDiv + ' - ' + GN-DIVI.DesDiv, GN-DIVI.CodDiv ). */
/*           IF gn-divi.coddiv = '00015' THEN x-CodDiv:SCREEN-VALUE = GN-DIVI.CodDiv.      */
/*       END.                                                                              */
/*       x-Lista:DELETE('Todos').                                                         */
/*       FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:                        */
/*           x-Lista:ADD-LAST( GN-DIVI.CodDiv + ' - ' + GN-DIVI.DesDiv, GN-DIVI.CodDiv ). */
/*           IF gn-divi.coddiv = '00015' THEN x-Lista:SCREEN-VALUE = GN-DIVI.CodDiv.      */
/*       END.                                                                             */

      /* Almacenes */
      /*
      x-CodAlm:ADD-LAST('Dejar como esta' , 'Dejar como esta' ).
      x-CodAlmB:ADD-LAST('Dejar como esta' , 'Dejar como esta' ).
      x-CodAlmC:ADD-LAST('Dejar como esta' , 'Dejar como esta').
      x-CodAlmD:ADD-LAST('Dejar como esta' , 'Dejar como esta').
      */
      x-CodAlm:ADD-LAST('Blanquear' , 'Blanquear' ).
      x-CodAlmB:ADD-LAST('Blanquear' , 'Blanquear' ).
      x-CodAlmC:ADD-LAST('Blanquear' , 'Blanquear' ).
      x-CodAlmD:ADD-LAST('Blanquear' , 'Blanquear' ).

      FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
          AND Almacen.Campo-c[9] <> "I"
          AND Almacen.AutMov = YES
          AND Almacen.FlgRep = YES
          AND Almacen.Campo-c[6] = "Si"
          AND Almacen.AlmCsg = NO:
          x-CodAlm:ADD-LAST( Almacen.CodAlm + ' - ' + Almacen.Descripcion, Almacen.CodAlm ).
          x-CodAlmB:ADD-LAST( Almacen.CodAlm + ' - ' + Almacen.Descripcion, Almacen.CodAlm ).
          x-CodAlmC:ADD-LAST( Almacen.CodAlm + ' - ' + Almacen.Descripcion, Almacen.CodAlm ).
          x-CodAlmD:ADD-LAST( Almacen.CodAlm + ' - ' + Almacen.Descripcion, Almacen.CodAlm ).
      END.
  END.

  /**/
  DEFINE BUFFER b-factabla FOR factabla.
  DEFINE VAR lUsrFchEnt AS CHAR.  

  lUsrFchEnt = "".
  FIND FIRST b-factabla WHERE b-factabla.codcia = s-codcia AND 
                             b-factabla.tabla = 'VALIDA' AND 
                             b-factabla.codigo = 'FCHENT' NO-LOCK NO-ERROR.
 IF AVAILABLE b-factabla THEN DO:
     lUsrFchEnt = b-factabla.campo-c[1].
 END.

 RELEASE b-factabla.

 Faccpedi.fchent:READ-ONLY IN BROWSE BROWSE-3 = YES.

 IF LOOKUP(s-user-id,lusrFchEnt) > 0 THEN DO:
     /* El usuario esta inscrito para no validar la fecha de entrega */
     Faccpedi.fchent:READ-ONLY IN BROWSE BROWSE-3 = NO.
 END.

/*  */
xEsFeriaLaListaPrecio = YES.
/* DEFINE VAR xListaPrecio AS CHAR.                             */
/* xListaPrecio = x-Lista:SCREEN-VALUE.                         */
/* DO WITH FRAME {&FRAME-NAME}:                                 */
/*     x-CodAlmB:VISIBLE = FALSE.                               */
/*     x-CodAlmC:VISIBLE = FALSE.                               */
/*     x-CodAlmD:VISIBLE = FALSE.                               */
/* END.                                                         */
/* xEsFeriaLaListaPrecio = NO.                                  */
/* FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND       */
/*     gn-divi.coddiv = xListaPrecio NO-LOCK NO-ERROR.          */
/* IF AVAILABLE gn-divi AND gn-divi.canalventa = 'FER' THEN DO: */
/*     xEsFeriaLaListaPrecio = YES.                             */
/*     DO WITH FRAME {&FRAME-NAME}:                             */
/*         x-CodAlmB:VISIBLE = TRUE.                            */
/*         x-CodAlmC:VISIBLE = TRUE.                            */
/*         x-CodAlmD:VISIBLE = TRUE.                            */
/*     END.                                                     */
/* END.                                                         */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Marca-Procesado W-Win 
PROCEDURE Marca-Procesado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR K AS INT NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').
DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN DO:
        {lib/lock-genericov2.i &Tabla="COTIZACION" ~
            &Condicion="ROWID(COTIZACION)=ROWID(Faccpedi)" ~
            &Accion="RETRY" ~
            &Mensaje="YES" ~
            &TipoError="NEXT"
            }
        IF COTIZACION.Libre_c02 = "PROCESADO" THEN COTIZACION.Libre_c02 = "".
        ELSE COTIZACION.Libre_c02 = "PROCESADO".
        RELEASE COTIZACION.
    END.
END.
SESSION:SET-WAIT-STATE('').
{&OPEN-QUERY-{&BROWSE-NAME}}

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
  {src/adm/template/snd-list.i "T-CPEDI"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-excel W-Win 
PROCEDURE ue-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-archivo AS CHAR.                       
DEFINE VAR rpta AS LOG.
                       
SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Texto (*.xlsx)' '*.xlsx'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.xlsx'
    RETURN-TO-START-DIR
    SAVE-AS
    TITLE 'Exportar a Excel'
    UPDATE rpta.
IF rpta = NO OR x-Archivo = '' THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').
EMPTY TEMP-TABLE tt-cotiza.
GET FIRST {&BROWSE-NAME}.
DO WHILE AVAILABLE faccpedi:
    CREATE tt-cotiza.
    ASSIGN  
        tt-cotiza.situacion   = faccpedi.libre_c02
        tt-cotiza.estado      = T-CPEDI.flgest
        tt-cotiza.cotizacion  = faccpedi.nroped
        tt-cotiza.origen      = faccpedi.coddiv
        tt-cotiza.ListaPrecio = faccpedi.libre_c01
        tt-cotiza.emision     = faccpedi.fchped
        tt-cotiza.fechent     = faccpedi.fchent
        tt-cotiza.cliente     = faccpedi.codcli
        tt-cotiza.nombre      = faccpedi.nomcli
        tt-cotiza.CasoA       = fGetAlmCaso(Faccpedi.LugEnt2, 1)
        tt-cotiza.CasoB       = fGetAlmCaso(Faccpedi.LugEnt2, 2)
        tt-cotiza.CasoC       = fGetAlmCaso(Faccpedi.LugEnt2, 3)
        tt-cotiza.CasoD       = fGetAlmCaso(Faccpedi.LugEnt2, 4)
        tt-cotiza.pestot      = fTotPeso()
        tt-cotiza.pespend     = fTotPesopendiente()
        tt-cotiza.usuario     = faccpedi.usuario
        tt-cotiza.imptot      = faccpedi.imptot
        .
    GET NEXT {&BROWSE-NAME}.
END.

/* Enviamos a Excel */
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = x-archivo.

run pi-crea-archivo-csv IN hProc (input  buffer tt-cotiza:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-cotiza:handle,
                        input  c-csv-file,
                        output c-xls-file) .
DELETE PROCEDURE hProc.
SESSION:SET-WAIT-STATE('').

MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX WARNING.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-excel-detalle W-Win 
PROCEDURE ue-excel-detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-archivo AS CHAR.                       
DEFINE VAR rpta AS LOG.
                       
SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Texto (*.xlsx)' '*.xlsx'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.xlsx'
    RETURN-TO-START-DIR
    SAVE-AS
    TITLE 'Exportar a Excel'
    UPDATE rpta.
IF rpta = NO OR x-Archivo = '' THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').
EMPTY TEMP-TABLE Detalle.
GET FIRST {&BROWSE-NAME}.
DO WHILE AVAILABLE faccpedi:
    FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
        CREATE Detalle.
        ASSIGN  
            Detalle.situacion   = faccpedi.libre_c02
            Detalle.estado      = T-CPEDI.flgest
            Detalle.cotizacion  = faccpedi.nroped
            Detalle.origen      = faccpedi.coddiv
            Detalle.ListaPrecio = faccpedi.libre_c01
            Detalle.emision     = faccpedi.fchped
            Detalle.fechent     = faccpedi.fchent
            Detalle.cliente     = faccpedi.codcli
            Detalle.nombre      = faccpedi.nomcli
            Detalle.TipVta      = Facdpedi.tipvta
            Detalle.CodAlm      = fAlmDes()
            Detalle.CodMat      = Almmmatg.codmat
            Detalle.DesMat      = Almmmatg.desmat
            Detalle.DesMar      = Almmmatg.desmar
            Detalle.UndVta      = Facdpedi.undvta
            Detalle.CanPed      = Facdpedi.canped
            Detalle.CanAte      = Facdpedi.canate
            Detalle.Saldo       = (FacDPedi.CanPed - FacDPedi.canate)
            Detalle.StkACt      = fStkAct()
            .
    END.
    GET NEXT {&BROWSE-NAME}.
END.
GET FIRST {&BROWSE-NAME}.

/* Enviamos a Excel */
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = x-archivo.

run pi-crea-archivo-csv IN hProc (input  buffer Detalle:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer Detalle:handle,
                        input  c-csv-file,
                        output c-xls-file) .
DELETE PROCEDURE hProc.
SESSION:SET-WAIT-STATE('').

MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX WARNING.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fAlmDes W-Win 
FUNCTION fAlmDes RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF NUM-ENTRIES(Faccpedi.LugEnt2) NE 4 THEN RETURN FacDPedi.AlmDes.
  CASE FacDPedi.TipVta:
      WHEN "A" THEN RETURN ENTRY(1,Faccpedi.LugEnt2).
      WHEN "B" THEN RETURN ENTRY(2,Faccpedi.LugEnt2).
      WHEN "C" THEN RETURN ENTRY(3,Faccpedi.LugEnt2).
      WHEN "D" THEN RETURN ENTRY(4,Faccpedi.LugEnt2).
  END CASE.

  RETURN FacDPedi.AlmDes.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fGetAlmCaso W-Win 
FUNCTION fGetAlmCaso RETURNS CHARACTER
  ( pCasoAlmCasos AS CHAR, pNumCaso AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VAR lRetVal AS CHAR.

lRetVal = "".

IF NUM-ENTRIES(pCasoAlmCasos,",") >= pNumCaso THEN DO:
    lRetVal = ENTRY(pNumCaso,pCasoAlmCasos,",").
END.


RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPesoDispoAlm W-Win 
FUNCTION fPesoDispoAlm RETURNS DECIMAL
  ( pCasoAlmCasos AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF TRUE <> (pCasoAlmCasos > '') THEN RETURN 0.

  DEF VAR xTotPeso AS DEC INIT 0 NO-UNDO.
  DEF VAR xSdoAct  AS DEC INIT 0 NO-UNDO.
  DEF VAR xCanAte  AS DEC NO-UNDO.
  DEF VAR k AS INT NO-UNDO.
  DEF VAR xListaProcesada AS CHAR NO-UNDO.

  RLOOP:
  FOR EACH Facdpedi OF Faccpedi NO-LOCK,FIRST Almmmatg OF Facdpedi NO-LOCK:
      /* Por cada producto vemos si los almacenes cubren su saldo por atender */
      IF (Facdpedi.canPed - Facdpedi.canAte) > 0 THEN DO:
          xSdoAct = (Facdpedi.CanPed - Facdpedi.CanAte) * Facdpedi.Factor.
          xListaProcesada = "".
          DO k = 1 TO 4:
              IF NUM-ENTRIES(pCasoAlmCasos,',') >= k THEN DO:
                  FIND Almmmate WHERE Almmmate.CodCia = s-codcia
                      AND Almmmate.CodAlm = ENTRY(k,pCasoAlmCasos,',')
                      AND Almmmate.codmat = Facdpedi.codmat
                      NO-LOCK NO-ERROR.
                  IF AVAILABLE Almmmate AND Almmmate.StkAct > 0 THEN DO:
                      IF LOOKUP(Almmmate.codalm, xListaProcesada) = 0 THEN DO:
                          xListaProcesada = xListaprocesada +
                              (IF TRUE <> (xListaprocesada > '') THEN '' ELSE ',') +
                               Almmmate.codalm.
                          xCanAte = MINIMUM(xSdoAct, (Almmmate.StkAct - Almmmate.StkComprometido)).
                          xSdoAct = xSdoAct - xCanAte.
                          xTotPeso = xTotPeso + (xCanAte * Almmmatg.Pesmat).
                          IF xSdoAct <= 0 THEN NEXT RLOOP.
                      END.
                  END.
              END.
          END.
      END.
  END.
  RETURN xTotPeso.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fStkAct W-Win 
FUNCTION fStkAct RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pAlmDes AS CHAR NO-UNDO.
  pAlmDes = fAlmDes().
  IF pAlmDes > '' THEN DO:
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = pAlmDes
          AND Almmmate.codmat = Facdpedi.codmat
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almmmate THEN RETURN (Almmmate.StkAct - Almmmate.StkComprometido).
  END.
  RETURN 0.00.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fTotPeso W-Win 
FUNCTION fTotPeso RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

 DEF VAR xTotPeso AS DEC.
  FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
      ASSIGN
          xTotPeso = xTotPeso + Facdpedi.canPed * Facdpedi.factor * Almmmatg.PesMat.
  END.
  RETURN xTotPeso.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fTotPesoPendiente W-Win 
FUNCTION fTotPesoPendiente RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

 DEF VAR xTotPeso AS DEC INIT 0.

  FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
    IF (Facdpedi.canPed - Facdpedi.canAte) > 0 THEN DO:
        ASSIGN
            xTotPeso = xTotPeso + (((Facdpedi.canPed - Facdpedi.canAte) * Facdpedi.factor) * Almmmatg.PesMat).
        
    END.
  END.
  RETURN xTotPeso.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

