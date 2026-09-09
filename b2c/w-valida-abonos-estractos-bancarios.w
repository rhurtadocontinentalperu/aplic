&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE TEMP-TABLE T-CPEDI LIKE FacCPedi.
DEFINE TEMP-TABLE T-INTERFASE LIKE b2c-interfase.



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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEFINE VAR x-cuales AS INT INIT 1.

&SCOPED-DEFINE CONDICION ( ~
            (x-cuales = 1 ) OR  ~
            (x-cuales = 2 AND T-CPEDI.Libre_c03 = "ABONADO") OR ~
            (x-cuales = 3 AND T-CPEDI.Libre_c03 = "NO ABONADO"))

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
&Scoped-define INTERNAL-TABLES T-CPEDI T-INTERFASE

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 T-CPEDI.ordcmp ~
T-INTERFASE.Fecha_de_Proceso T-CPEDI.Libre_c01 T-CPEDI.Libre_c02 ~
T-CPEDI.Libre_f01 T-CPEDI.Libre_d01 T-INTERFASE.Tarjeta ~
T-INTERFASE.Tipo_Tarjeta T-INTERFASE.Moneda T-INTERFASE.Importe ~
T-INTERFASE.Comision T-INTERFASE.Neto_Abonar T-INTERFASE.Estado ~
T-INTERFASE.Fecha_Abono T-INTERFASE.Id_Unico T-INTERFASE.Cuenta ~
T-INTERFASE.Banco T-CPEDI.NroPed T-CPEDI.NomCli 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH T-CPEDI ~
      WHERE {&CONDICION} NO-LOCK, ~
      FIRST T-INTERFASE WHERE T-INTERFASE.CodCia = T-CPEDI.CodCia ~
  AND T-INTERFASE.Pedido_Cliente = T-CPEDI.ordcmp OUTER-JOIN NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH T-CPEDI ~
      WHERE {&CONDICION} NO-LOCK, ~
      FIRST T-INTERFASE WHERE T-INTERFASE.CodCia = T-CPEDI.CodCia ~
  AND T-INTERFASE.Pedido_Cliente = T-CPEDI.ordcmp OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 T-CPEDI T-INTERFASE
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 T-CPEDI
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 T-INTERFASE


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-34 RECT-35 FILL-IN-1 BUTTON-filtrar ~
FILL-IN-FchDoc FILL-IN-FchDoc-2 BUTTON-Procesar BUTTON-Aprobar ~
BUTTON-buscar RADIO-SET-cuales FILL-IN-pedido BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 FILL-IN-FchDoc FILL-IN-FchDoc-2 ~
RADIO-SET-cuales FILL-IN-pedido 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Aprobar 
     LABEL "LIQUIDAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-buscar 
     LABEL "Buscar" 
     SIZE 8 BY .96.

DEFINE BUTTON BUTTON-filtrar 
     LABEL "Filtrar" 
     SIZE 9 BY 1.15.

DEFINE BUTTON BUTTON-Procesar 
     LABEL "MOSTRAR  INFORMACION" 
     SIZE 21 BY 1.12.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U INITIAL "VALIDA ABONOS DE NIUBIZ CON LOS ESTRACTOS BANCARIOS" 
     VIEW-AS FILL-IN 
     SIZE 55 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Venta Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-pedido AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Pedido Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-cuales AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"Con Abono", 2,
"Sin Abono", 3
     SIZE 33 BY .96 NO-UNDO.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.43 BY 1.38.

DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33.29 BY 1.35.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      T-CPEDI, 
      T-INTERFASE SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      T-CPEDI.ordcmp COLUMN-LABEL "Pedido!del Cliente" FORMAT "X(12)":U
            WIDTH 9.43
      T-INTERFASE.Fecha_de_Proceso COLUMN-LABEL "Fecha Pedido!Cliente" FORMAT "99/99/9999":U
            WIDTH 11.43
      T-CPEDI.Libre_c01 COLUMN-LABEL "Doc.!Cmpte" FORMAT "x(3)":U
            WIDTH 4.57
      T-CPEDI.Libre_c02 COLUMN-LABEL "Número!Cmpte" FORMAT "x(12)":U
            WIDTH 11.29
      T-CPEDI.Libre_f01 COLUMN-LABEL "Fecha!Cmpte" FORMAT "99/99/9999":U
      T-CPEDI.Libre_d01 COLUMN-LABEL "Importe!Cmpte" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 10.57
      T-INTERFASE.Tarjeta FORMAT "x(20)":U
      T-INTERFASE.Tipo_Tarjeta FORMAT "x(20)":U
      T-INTERFASE.Moneda FORMAT "x(8)":U
      T-INTERFASE.Importe COLUMN-LABEL "Importe!Transaccion" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 10.43
      T-INTERFASE.Comision FORMAT "->>>,>>>,>>9.99":U WIDTH 8
      T-INTERFASE.Neto_Abonar COLUMN-LABEL "Neto!Abonar" FORMAT "->>>,>>>,>>9.99":U
      T-INTERFASE.Estado FORMAT "x(15)":U
      T-INTERFASE.Fecha_Abono COLUMN-LABEL "Fecha de!Abono" FORMAT "99/99/9999":U
            WIDTH 8.86
      T-INTERFASE.Id_Unico FORMAT "x(20)":U
      T-INTERFASE.Cuenta FORMAT "x(30)":U WIDTH 20.72
      T-INTERFASE.Banco FORMAT "x(40)":U WIDTH 22.43
      T-CPEDI.NroPed COLUMN-LABEL "Cotización" FORMAT "X(12)":U
      T-CPEDI.NomCli FORMAT "x(40)":U WIDTH 27.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 189 BY 20.92
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-1 AT ROW 1.04 COL 71 NO-LABEL WIDGET-ID 24
     BUTTON-filtrar AT ROW 2.04 COL 129 WIDGET-ID 16
     FILL-IN-FchDoc AT ROW 2.15 COL 19 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-FchDoc-2 AT ROW 2.15 COL 37 COLON-ALIGNED WIDGET-ID 8
     BUTTON-Procesar AT ROW 2.15 COL 54.29 WIDGET-ID 4
     BUTTON-Aprobar AT ROW 2.15 COL 76 WIDGET-ID 6
     BUTTON-buscar AT ROW 2.15 COL 173.72 WIDGET-ID 18
     RADIO-SET-cuales AT ROW 2.23 COL 95 NO-LABEL WIDGET-ID 10
     FILL-IN-pedido AT ROW 2.23 COL 159.14 COLON-ALIGNED WIDGET-ID 14
     BROWSE-2 AT ROW 4.69 COL 2 WIDGET-ID 200
     RECT-34 AT ROW 1.96 COL 93.57 WIDGET-ID 20
     RECT-35 AT ROW 2 COL 149.72 WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 191.29 BY 24.73
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: T-CPEDI T "?" ? INTEGRAL FacCPedi
      TABLE: T-INTERFASE T "?" ? INTEGRAL b2c-interfase
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Validar Abonos de NIUBIZ con las ventas"
         HEIGHT             = 24.73
         WIDTH              = 191.29
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

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 FILL-IN-pedido F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.T-CPEDI,Temp-Tables.T-INTERFASE WHERE Temp-Tables.T-CPEDI ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER"
     _Where[1]         = "{&CONDICION}"
     _JoinCode[2]      = "Temp-Tables.T-INTERFASE.CodCia = Temp-Tables.T-CPEDI.CodCia
  AND Temp-Tables.T-INTERFASE.Pedido_Cliente = Temp-Tables.T-CPEDI.ordcmp"
     _FldNameList[1]   > Temp-Tables.T-CPEDI.ordcmp
"T-CPEDI.ordcmp" "Pedido!del Cliente" ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-INTERFASE.Fecha_de_Proceso
"T-INTERFASE.Fecha_de_Proceso" "Fecha Pedido!Cliente" ? "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-CPEDI.Libre_c01
"T-CPEDI.Libre_c01" "Doc.!Cmpte" "x(3)" "character" ? ? ? ? ? ? no ? no no "4.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-CPEDI.Libre_c02
"T-CPEDI.Libre_c02" "Número!Cmpte" "x(12)" "character" ? ? ? ? ? ? no ? no no "11.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-CPEDI.Libre_f01
"T-CPEDI.Libre_f01" "Fecha!Cmpte" "99/99/9999" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-CPEDI.Libre_d01
"T-CPEDI.Libre_d01" "Importe!Cmpte" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = Temp-Tables.T-INTERFASE.Tarjeta
     _FldNameList[8]   = Temp-Tables.T-INTERFASE.Tipo_Tarjeta
     _FldNameList[9]   = Temp-Tables.T-INTERFASE.Moneda
     _FldNameList[10]   > Temp-Tables.T-INTERFASE.Importe
"T-INTERFASE.Importe" "Importe!Transaccion" ? "decimal" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.T-INTERFASE.Comision
"T-INTERFASE.Comision" ? ? "decimal" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.T-INTERFASE.Neto_Abonar
"T-INTERFASE.Neto_Abonar" "Neto!Abonar" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   = Temp-Tables.T-INTERFASE.Estado
     _FldNameList[14]   > Temp-Tables.T-INTERFASE.Fecha_Abono
"T-INTERFASE.Fecha_Abono" "Fecha de!Abono" ? "date" ? ? ? ? ? ? no ? no no "8.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   = Temp-Tables.T-INTERFASE.Id_Unico
     _FldNameList[16]   > Temp-Tables.T-INTERFASE.Cuenta
"T-INTERFASE.Cuenta" ? ? "character" ? ? ? ? ? ? no ? no no "20.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.T-INTERFASE.Banco
"T-INTERFASE.Banco" ? ? "character" ? ? ? ? ? ? no ? no no "22.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.T-CPEDI.NroPed
"T-CPEDI.NroPed" "Cotización" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > Temp-Tables.T-CPEDI.NomCli
"T-CPEDI.NomCli" ? "x(40)" "character" ? ? ? ? ? ? no ? no no "27.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Validar Abonos de NIUBIZ con las ventas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Validar Abonos de NIUBIZ con las ventas */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Aprobar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Aprobar W-Win
ON CHOOSE OF BUTTON-Aprobar IN FRAME F-Main /* LIQUIDAR */
DO:
  MESSAGE 'Seguro de Proceder a validar los abonos?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  DEF VAR pMensaje AS CHAR NO-UNDO.
  RUN Aprobar (OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  EMPTY TEMP-TABLE T-CPEDI.
  EMPTY TEMP-TABLE T-INTERFASE.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-buscar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-buscar W-Win
ON CHOOSE OF BUTTON-buscar IN FRAME F-Main /* Buscar */
DO:
  ASSIGN fill-in-pedido.

  DEFINE VAR x-rowid AS ROWID.
  DEFINE VAR x-nropedido AS CHAR.
  DEFINE VAR x-old-rowid AS ROWID.

  IF AVAILABLE t-cpedi THEN x-old-rowid = ROWID(t-cpedi).

  IF fill-in-pedido > 0 THEN DO:
      x-nropedido = STRING(fill-in-pedido,"99999999").
      FIND FIRST t-cpedi WHERE t-cpedi.ordcmp = x-nropedido NO-LOCK NO-ERROR.
      IF NOT AVAILABLE t-cpedi THEN DO:
        RETURN NO-APPLY.        
      END.
      /**/
      x-rowid = ROWID(t-cpedi).
      FIND FIRST {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
            ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = x-rowid
            NO-LOCK NO-ERROR.
      IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
          REPOSITION {&BROWSE-NAME}  TO ROWID x-rowid NO-ERROR.
          IF ERROR-STATUS:ERROR THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID x-old-rowid NO-ERROR.
            MESSAGE "El pedido que esta buscando no se encuentra en el GRID" SKIP
                "Asegurarse que el filtro se por todos"
                VIEW-AS ALERT-BOX INFORMATION.
          END.
      END.

  END.

END.

/*
	FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
	    AND Almmmatg.codmat = VtaDList.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
	    NO-LOCK NO-ERROR.

	IF NOT CAN-FIND(FIRST customer WHERE customer.code = ordhdr.customer) THEN

        FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
        IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
        END.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-filtrar W-Win
ON CHOOSE OF BUTTON-filtrar IN FRAME F-Main /* Filtrar */
DO:
  ASSIGN radio-set-cuales.

  x-cuales = radio-set-cuales.

  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Procesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Procesar W-Win
ON CHOOSE OF BUTTON-Procesar IN FRAME F-Main /* MOSTRAR  INFORMACION */
DO:
  ASSIGN FILL-IN-FchDoc FILL-IN-FchDoc-2.
  RUN Carga-Temporal.
  {&OPEN-QUERY-{&BROWSE-NAME}}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aprobar W-Win 
PROCEDURE Aprobar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR x-NroOrd AS CHAR NO-UNDO.

/* Aprobación */
RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH T-CPEDI:
        /* Buscamos su par */
        FIND FIRST b2c-interfase WHERE b2c-interfase.CodCia = s-CodCia AND
            b2c-interfase.Pedido_Cliente = T-CPEDI.OrdCmp
            NO-LOCK NO-ERROR.
        IF AVAILABLE b2c-interfase THEN DO:
            {lib/lock-genericov3.i ~
                &Tabla="b2c-interfase" ~
                &Alcance="FIRST" ~
                &Condicion="b2c-interfase.CodCia = s-CodCia AND ~
                b2c-interfase.Pedido_Cliente = T-CPEDI.OrdCmp" ~
                &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
                &Accion="RETRY" ~
                &Mensaje="NO" ~
                &txtMensaje="pMensaje" ~
                &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'"}
            ASSIGN
                b2c-interfase.FchAprobacion = TODAY
                b2c-interfase.HoraAprobacion = STRING(TIME, 'HH:MM:SS')
                b2c-interfase.FlgEst = "C"
                b2c-interfase.UsrAprobacion = s-User-Id.
        END.
    END.
    EMPTY TEMP-TABLE T-CPEDI.
    EMPTY TEMP-TABLE T-INTERFASE.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-CPEDI.
EMPTY TEMP-TABLE T-INTERFASE.

DEF VAR x-NroOrd AS CHAR NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').

/* Cotizaciones Facturadas */
FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia AND
    Faccpedi.coddoc = 'COT' AND
    Faccpedi.coddiv = s-coddiv AND
    Faccpedi.fchped >= FILL-IN-FchDoc AND
    Faccpedi.fchped <= FILL-IN-FchDoc-2 AND
    Faccpedi.flgest <> 'A',
    FIRST PEDIDO NO-LOCK WHERE PEDIDO.codcia = s-codcia AND
    PEDIDO.coddoc = 'PED' AND
    PEDIDO.coddiv = s-coddiv AND
    PEDIDO.codref = Faccpedi.coddoc AND
    PEDIDO.nroref = Faccpedi.nroped AND
    PEDIDO.flgest <> 'A',
    FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia AND
    Ccbcdocu.codped = PEDIDO.coddoc AND
    Ccbcdocu.nroped = PEDIDO.nroped AND
    Ccbcdocu.flgest <> 'A' AND
    LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL') > 0:

    /* Verificamos que aun no este validado contra el ESTRACTO BANCARIO  */
    x-NroOrd = Faccpedi.OrdCmp.
    FIND FIRST b2c-interfase WHERE b2c-interfase.CodCia = s-codcia AND
        b2c-interfase.Pedido_Cliente = x-NroOrd
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE b2c-interfase THEN NEXT.   /* El pedido de cliente no EXISTE */

    /* Verificamos que el pedido aun tenga asignado un ESTRACTO BANCARIO */


    CREATE T-CPEDI.
    BUFFER-COPY Faccpedi TO T-CPEDI.
    /* Agregamos dato de facturación */
    ASSIGN
        T-CPEDI.Libre_c01 = Ccbcdocu.coddoc
        T-CPEDI.Libre_c02 = Ccbcdocu.nrodoc
        T-CPEDI.Libre_c03 = "NO ABONADO"
        T-CPEDI.Libre_f01 = Ccbcdocu.fchdoc
        T-CPEDI.Libre_d01 = Ccbcdocu.imptot.
    /* Agregamos datos de Niubiz */
    x-NroOrd = Faccpedi.OrdCmp.
    ASSIGN
        x-NroOrd = STRING(INTEGER(x-NroOrd), '99999999')
        NO-ERROR.
    FIND FIRST b2c-interfase WHERE b2c-interfase.CodCia = s-codcia AND
        b2c-interfase.Pedido_Cliente = x-NroOrd
        NO-LOCK NO-ERROR.
    IF AVAILABLE b2c-interfase THEN DO:
        /* RHC 24/06/2020 NO debe tomarse los YA CONCILIADOS */
        IF b2c-interfase.FlgEst = "C" THEN DO:
            DELETE T-CPEDI.
            NEXT.
        END.
        /* NO repetido */
        IF CAN-FIND(FIRST T-INTERFASE OF b2c-interfase NO-LOCK) THEN NEXT.
        CREATE T-INTERFASE.
        BUFFER-COPY b2c-interfase TO T-INTERFASE.
        ASSIGN
            T-CPEDI.OrdCmp = x-NroOrd
            T-CPEDI.Libre_c03 = "ABONADO".
    END.
END.

SESSION:SET-WAIT-STATE('').

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
  DISPLAY FILL-IN-1 FILL-IN-FchDoc FILL-IN-FchDoc-2 RADIO-SET-cuales 
          FILL-IN-pedido 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-34 RECT-35 FILL-IN-1 BUTTON-filtrar FILL-IN-FchDoc 
         FILL-IN-FchDoc-2 BUTTON-Procesar BUTTON-Aprobar BUTTON-buscar 
         RADIO-SET-cuales FILL-IN-pedido BROWSE-2 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

 
  /* Code placed here will execute PRIOR to standard behavior. */
  FILL-IN-FchDoc = TODAY - DAY(TODAY) + 1.
  FILL-IN-FchDoc-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "T-INTERFASE"}

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

