&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttvtas_b2b_dtl NO-UNDO LIKE vtas_b2b_dtl.
DEFINE TEMP-TABLE ttvtas_b2b_hdr NO-UNDO LIKE vtas_b2b_hdr.



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
&Scoped-define INTERNAL-TABLES ttvtas_b2b_hdr ttvtas_b2b_dtl

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 ttvtas_b2b_hdr.proveedor ~
ttvtas_b2b_hdr.nomproveedor ttvtas_b2b_hdr.trimestre ~
ttvtas_b2b_hdr.gruporeparto ttvtas_b2b_hdr.numorden 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH ttvtas_b2b_hdr NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH ttvtas_b2b_hdr NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 ttvtas_b2b_hdr
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 ttvtas_b2b_hdr


/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 ttvtas_b2b_dtl.item ~
ttvtas_b2b_dtl.posicionpedido ttvtas_b2b_dtl.solicitudpedido ~
ttvtas_b2b_dtl.codigocentro ttvtas_b2b_dtl.nombrecentro ~
ttvtas_b2b_dtl.codigoalmacen ttvtas_b2b_dtl.nombrealmacen ~
ttvtas_b2b_dtl.centrocostos ttvtas_b2b_dtl.direccion ~
ttvtas_b2b_dtl.departamento ttvtas_b2b_dtl.provincia ~
ttvtas_b2b_dtl.distrito ttvtas_b2b_dtl.telefono ttvtas_b2b_dtl.receptor ~
ttvtas_b2b_dtl.fechaentrega ttvtas_b2b_dtl.codigomaterial ~
ttvtas_b2b_dtl.codigoantiguo ttvtas_b2b_dtl.descripcionmaterial ~
ttvtas_b2b_dtl.cantidad ttvtas_b2b_dtl.UM ttvtas_b2b_dtl.descripcion_um 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH ttvtas_b2b_dtl NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH ttvtas_b2b_dtl NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 ttvtas_b2b_dtl
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 ttvtas_b2b_dtl


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 button-grabar BROWSE-3 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON button-grabar 
     LABEL "Grabar" 
     SIZE 15 BY 1.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      ttvtas_b2b_hdr SCROLLING.

DEFINE QUERY BROWSE-3 FOR 
      ttvtas_b2b_dtl SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      ttvtas_b2b_hdr.proveedor COLUMN-LABEL "Proveedor" FORMAT "x(11)":U
      ttvtas_b2b_hdr.nomproveedor COLUMN-LABEL "Nombre del Proveedor" FORMAT "x(100)":U
            WIDTH 38.86
      ttvtas_b2b_hdr.trimestre COLUMN-LABEL "Trimestre" FORMAT "x(10)":U
      ttvtas_b2b_hdr.gruporeparto COLUMN-LABEL "Grupo!Reparto" FORMAT "x(5)":U
      ttvtas_b2b_hdr.numorden COLUMN-LABEL "Pedido!Compra" FORMAT "x(15)":U
            WIDTH 14.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 87 BY 7.31
         FONT 4 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      ttvtas_b2b_dtl.item COLUMN-LABEL "Item" FORMAT ">,>>9":U
      ttvtas_b2b_dtl.posicionpedido COLUMN-LABEL "Posicion!Pedido" FORMAT "->,>>>,>>9":U
            WIDTH 6.43
      ttvtas_b2b_dtl.solicitudpedido COLUMN-LABEL "Solicitud de!Pedido" FORMAT "x(25)":U
            WIDTH 9.43
      ttvtas_b2b_dtl.codigocentro COLUMN-LABEL "Codigo!Centro" FORMAT "x(10)":U
            WIDTH 6.43
      ttvtas_b2b_dtl.nombrecentro COLUMN-LABEL "Nombre!Centro" FORMAT "x(100)":U
            WIDTH 28.43
      ttvtas_b2b_dtl.codigoalmacen COLUMN-LABEL "Codigo!Almacen" FORMAT "x(15)":U
            WIDTH 7.43
      ttvtas_b2b_dtl.nombrealmacen COLUMN-LABEL "Nombre!Almacen" FORMAT "x(100)":U
            WIDTH 25.86
      ttvtas_b2b_dtl.centrocostos COLUMN-LABEL "Centro!Costos" FORMAT "x(15)":U
            WIDTH 8.43
      ttvtas_b2b_dtl.direccion COLUMN-LABEL "Direccion" FORMAT "x(150)":U
            WIDTH 38.43
      ttvtas_b2b_dtl.departamento COLUMN-LABEL "Departamento" FORMAT "x(100)":U
            WIDTH 20
      ttvtas_b2b_dtl.provincia COLUMN-LABEL "Provincia" FORMAT "x(100)":U
            WIDTH 21.29
      ttvtas_b2b_dtl.distrito COLUMN-LABEL "Distrito" FORMAT "x(100)":U
            WIDTH 18.86
      ttvtas_b2b_dtl.telefono COLUMN-LABEL "Telefono" FORMAT "x(50)":U
            WIDTH 14.43
      ttvtas_b2b_dtl.receptor COLUMN-LABEL "Nombre!Receptor" FORMAT "x(100)":U
            WIDTH 26.29
      ttvtas_b2b_dtl.fechaentrega COLUMN-LABEL "Fecha!entrega" FORMAT "x(25)":U
            WIDTH 10.43
      ttvtas_b2b_dtl.codigomaterial COLUMN-LABEL "Codigo!Material" FORMAT "x(25)":U
            WIDTH 12.43
      ttvtas_b2b_dtl.codigoantiguo COLUMN-LABEL "Cod.Material!Antiguo" FORMAT "x(25)":U
            WIDTH 10.43
      ttvtas_b2b_dtl.descripcionmaterial COLUMN-LABEL "Descripcion!Material" FORMAT "x(100)":U
            WIDTH 35.86
      ttvtas_b2b_dtl.cantidad COLUMN-LABEL "Cantidad" FORMAT "->>,>>>,>>9.99":U
            WIDTH 9.43
      ttvtas_b2b_dtl.UM COLUMN-LABEL "U.M." FORMAT "x(8)":U WIDTH 6
      ttvtas_b2b_dtl.descripcion_um COLUMN-LABEL "Descripcion!U.M." FORMAT "x(50)":U
            WIDTH 29.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 146 BY 12.31
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-2 AT ROW 1.19 COL 2 WIDGET-ID 200
     button-grabar AT ROW 6.96 COL 124 WIDGET-ID 2
     BROWSE-3 AT ROW 8.69 COL 2 WIDGET-ID 300
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 147.57 BY 20.42
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Temp-Tables and Buffers:
      TABLE: ttvtas_b2b_dtl T "?" NO-UNDO INTEGRAL vtas_b2b_dtl
      TABLE: ttvtas_b2b_hdr T "?" NO-UNDO INTEGRAL vtas_b2b_hdr
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Cargar Excel pedidos B2B"
         HEIGHT             = 20.42
         WIDTH              = 147.57
         MAX-HEIGHT         = 26.58
         MAX-WIDTH          = 147.57
         VIRTUAL-HEIGHT     = 26.58
         VIRTUAL-WIDTH      = 147.57
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartWindowCues" W-Win _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* SmartWindow,ab,49271
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
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
/* BROWSE-TAB BROWSE-2 1 F-Main */
/* BROWSE-TAB BROWSE-3 button-grabar F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.ttvtas_b2b_hdr"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.ttvtas_b2b_hdr.proveedor
"proveedor" "Proveedor" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.ttvtas_b2b_hdr.nomproveedor
"nomproveedor" "Nombre del Proveedor" ? "character" ? ? ? ? ? ? no ? no no "38.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ttvtas_b2b_hdr.trimestre
"trimestre" "Trimestre" "x(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ttvtas_b2b_hdr.gruporeparto
"gruporeparto" "Grupo!Reparto" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ttvtas_b2b_hdr.numorden
"numorden" "Pedido!Compra" ? "character" ? ? ? ? ? ? no ? no no "14.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.ttvtas_b2b_dtl"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.ttvtas_b2b_dtl.item
"item" "Item" ">,>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.ttvtas_b2b_dtl.posicionpedido
"posicionpedido" "Posicion!Pedido" ? "integer" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ttvtas_b2b_dtl.solicitudpedido
"solicitudpedido" "Solicitud de!Pedido" ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ttvtas_b2b_dtl.codigocentro
"codigocentro" "Codigo!Centro" ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ttvtas_b2b_dtl.nombrecentro
"nombrecentro" "Nombre!Centro" ? "character" ? ? ? ? ? ? no ? no no "28.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ttvtas_b2b_dtl.codigoalmacen
"codigoalmacen" "Codigo!Almacen" ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ttvtas_b2b_dtl.nombrealmacen
"nombrealmacen" "Nombre!Almacen" ? "character" ? ? ? ? ? ? no ? no no "25.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ttvtas_b2b_dtl.centrocostos
"centrocostos" "Centro!Costos" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.ttvtas_b2b_dtl.direccion
"direccion" "Direccion" ? "character" ? ? ? ? ? ? no ? no no "38.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.ttvtas_b2b_dtl.departamento
"departamento" "Departamento" ? "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.ttvtas_b2b_dtl.provincia
"provincia" "Provincia" ? "character" ? ? ? ? ? ? no ? no no "21.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.ttvtas_b2b_dtl.distrito
"distrito" "Distrito" ? "character" ? ? ? ? ? ? no ? no no "18.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.ttvtas_b2b_dtl.telefono
"telefono" "Telefono" ? "character" ? ? ? ? ? ? no ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.ttvtas_b2b_dtl.receptor
"receptor" "Nombre!Receptor" ? "character" ? ? ? ? ? ? no ? no no "26.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.ttvtas_b2b_dtl.fechaentrega
"fechaentrega" "Fecha!entrega" ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.ttvtas_b2b_dtl.codigomaterial
"codigomaterial" "Codigo!Material" ? "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.ttvtas_b2b_dtl.codigoantiguo
"codigoantiguo" "Cod.Material!Antiguo" ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.ttvtas_b2b_dtl.descripcionmaterial
"descripcionmaterial" "Descripcion!Material" ? "character" ? ? ? ? ? ? no ? no no "35.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > Temp-Tables.ttvtas_b2b_dtl.cantidad
"cantidad" "Cantidad" "->>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > Temp-Tables.ttvtas_b2b_dtl.UM
"UM" "U.M." ? "character" ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > Temp-Tables.ttvtas_b2b_dtl.descripcion_um
"descripcion_um" "Descripcion!U.M." ? "character" ? ? ? ? ? ? no ? no no "29.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Cargar Excel pedidos B2B */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Cargar Excel pedidos B2B */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
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
  ENABLE BROWSE-2 button-grabar BROWSE-3 
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
  {src/adm/template/snd-list.i "ttvtas_b2b_hdr"}
  {src/adm/template/snd-list.i "ttvtas_b2b_dtl"}

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

