&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-b2c-interfase NO-UNDO LIKE b2c-interfase.
DEFINE TEMP-TABLE t-estrac_bancario NO-UNDO LIKE estrac_bancario.
DEFINE TEMP-TABLE t-pago_efectivo NO-UNDO LIKE pago_efectivo.



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
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR x-total-a-conciliar AS DEC.

DEFINE VAR x-total AS DEC INIT 0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-11

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES t-b2c-interfase t-estrac_bancario

/* Definitions for BROWSE BROWSE-11                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-11 t-b2c-interfase.libre_log[1] ~
t-b2c-interfase.Pedido_Cliente t-b2c-interfase.Importe ~
t-b2c-interfase.Fecha_Abono t-b2c-interfase.Libre_Char[1] ~
t-b2c-interfase.Libre_Char[2] t-b2c-interfase.Libre_Deci[1] ~
t-b2c-interfase.Neto_Abonar 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-11 
&Scoped-define QUERY-STRING-BROWSE-11 FOR EACH t-b2c-interfase NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-11 OPEN QUERY BROWSE-11 FOR EACH t-b2c-interfase NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-11 t-b2c-interfase
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-11 t-b2c-interfase


/* Definitions for BROWSE BROWSE-8                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-8 t-estrac_bancario.libre_log[1] ~
t-estrac_bancario.fech_operacion t-estrac_bancario.cod_operacion ~
t-estrac_bancario.movimiento t-estrac_bancario.detalle ~
t-estrac_bancario.canal t-estrac_bancario.abono 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-8 
&Scoped-define QUERY-STRING-BROWSE-8 FOR EACH t-estrac_bancario NO-LOCK ~
    BY t-estrac_bancario.movimiento INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-8 OPEN QUERY BROWSE-8 FOR EACH t-estrac_bancario NO-LOCK ~
    BY t-estrac_bancario.movimiento INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-8 t-estrac_bancario
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-8 t-estrac_bancario


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-11}~
    ~{&OPEN-QUERY-BROWSE-8}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-fecha-operacion BUTTON-7 BROWSE-8 ~
BUTTON-documentos BROWSE-11 BUTTON-grabar 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-fecha-operacion FILL-IN-5 ~
FILL-IN-total FILL-IN-total-conciliar FILL-IN-total-conti 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ff_just_right W-Win 
FUNCTION ff_just_right RETURNS CHARACTER ( INPUT h AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ff_just_rightfrr W-Win 
FUNCTION ff_just_rightfrr RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-7 
     LABEL "Aceptar" 
     SIZE 13 BY .96.

DEFINE BUTTON BUTTON-documentos 
     LABEL "Ir a doumentos para conciliar" 
     SIZE 22 BY 1.12.

DEFINE BUTTON BUTTON-grabar 
     LABEL "Grabar Conciliacion" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(256)":U INITIAL "Fecha del estracto bancario a CONCILIAR" 
      VIEW-AS TEXT 
     SIZE 38 BY .62
     FGCOLOR 4 FONT 10 NO-UNDO.

DEFINE VARIABLE FILL-IN-fecha-operacion AS DATE FORMAT "99/99/9999":U 
     LABEL "Ingrese fecha de Operacion" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .96 NO-UNDO.

DEFINE VARIABLE FILL-IN-total AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total del estracto a conciliar" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .81
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-total-conciliar AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total Cmpbtes conciliados" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .85
     BGCOLOR 15 FGCOLOR 12 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-total-conti AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total Monto" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .81
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-11 FOR 
      t-b2c-interfase SCROLLING.

DEFINE QUERY BROWSE-8 FOR 
      t-estrac_bancario SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-11 W-Win _STRUCTURED
  QUERY BROWSE-11 NO-LOCK DISPLAY
      t-b2c-interfase.libre_log[1] COLUMN-LABEL "Elija" FORMAT "yes/no":U
            WIDTH 4.43 VIEW-AS TOGGLE-BOX
      t-b2c-interfase.Pedido_Cliente COLUMN-LABEL "Pedido!Cliente" FORMAT "x(20)":U
            WIDTH 11.43
      t-b2c-interfase.Importe COLUMN-LABEL "Importe!Niubiz" FORMAT "->>>,>>>,>>9.99":U
      t-b2c-interfase.Fecha_Abono COLUMN-LABEL "Fecha!Abono" FORMAT "99/99/9999":U
      t-b2c-interfase.Libre_Char[1] COLUMN-LABEL "Tipo!Cmpbnte" FORMAT "x(5)":U
            WIDTH 6.29
      t-b2c-interfase.Libre_Char[2] COLUMN-LABEL "Nro!Cmpbnte" FORMAT "x(15)":U
            WIDTH 13
      t-b2c-interfase.Libre_Deci[1] COLUMN-LABEL "Impte!Cmpbnte" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 11.43
      t-b2c-interfase.Neto_Abonar COLUMN-LABEL "Impte!Abonado" FORMAT "->>,>>>,>>9.99":U
            WIDTH 13.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 92 BY 8.65
         FONT 4
         TITLE "Lista de Comprobantes para la conciliacion" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-8 W-Win _STRUCTURED
  QUERY BROWSE-8 NO-LOCK DISPLAY
      t-estrac_bancario.libre_log[1] COLUMN-LABEL "Elija" FORMAT "yes/no":U
            WIDTH 3.43 VIEW-AS TOGGLE-BOX
      t-estrac_bancario.fech_operacion COLUMN-LABEL "Fecha!Operacion" FORMAT "99/99/9999":U
      t-estrac_bancario.cod_operacion COLUMN-LABEL "Cod.!Operacion" FORMAT "x(10)":U
      t-estrac_bancario.movimiento COLUMN-LABEL "Movimiento" FORMAT "x(50)":U
            WIDTH 22.86
      t-estrac_bancario.detalle COLUMN-LABEL "Tarjeta/Detalle" FORMAT "x(50)":U
            WIDTH 24.43
      t-estrac_bancario.canal COLUMN-LABEL "Canal" FORMAT "x(25)":U
            WIDTH 16.43
      t-estrac_bancario.abono COLUMN-LABEL "Abono" FORMAT "->>,>>>,>>9.99":U
            WIDTH 17.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 112 BY 5.5
         FONT 4
         TITLE "Seleccione los Items del estracto bancario para conciliar" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-fecha-operacion AT ROW 1.19 COL 66 COLON-ALIGNED WIDGET-ID 4
     BUTTON-7 AT ROW 1.23 COL 85.29 WIDGET-ID 6
     BROWSE-8 AT ROW 2.42 COL 3 WIDGET-ID 200
     BUTTON-documentos AT ROW 8.04 COL 50.29 WIDGET-ID 16
     BROWSE-11 AT ROW 10.15 COL 3 WIDGET-ID 400
     BUTTON-grabar AT ROW 11 COL 97 WIDGET-ID 14
     FILL-IN-5 AT ROW 1.38 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     FILL-IN-total AT ROW 8.12 COL 94 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-total-conciliar AT ROW 20.62 COL 76 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-total-conti AT ROW 21 COL 11 COLON-ALIGNED WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 116.14 BY 21.12
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Temp-Tables and Buffers:
      TABLE: t-b2c-interfase T "?" NO-UNDO INTEGRAL b2c-interfase
      TABLE: t-estrac_bancario T "?" NO-UNDO INTEGRAL estrac_bancario
      TABLE: t-pago_efectivo T "?" NO-UNDO INTEGRAL pago_efectivo
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CONCILIACION BANCARIA - PAGOEFECTIVO"
         HEIGHT             = 21.12
         WIDTH              = 116.14
         MAX-HEIGHT         = 21.12
         MAX-WIDTH          = 162.14
         VIRTUAL-HEIGHT     = 21.12
         VIRTUAL-WIDTH      = 162.14
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
/* BROWSE-TAB BROWSE-8 BUTTON-7 F-Main */
/* BROWSE-TAB BROWSE-11 BUTTON-documentos F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-total IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-total-conciliar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-total-conti IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-11
/* Query rebuild information for BROWSE BROWSE-11
     _TblList          = "Temp-Tables.t-b2c-interfase"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.t-b2c-interfase.libre_log[1]
"libre_log[1]" "Elija" ? "logical" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-b2c-interfase.Pedido_Cliente
"Pedido_Cliente" "Pedido!Cliente" ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.t-b2c-interfase.Importe
"Importe" "Importe!Niubiz" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.t-b2c-interfase.Fecha_Abono
"Fecha_Abono" "Fecha!Abono" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-b2c-interfase.Libre_Char[1]
"Libre_Char[1]" "Tipo!Cmpbnte" "x(5)" "character" ? ? ? ? ? ? no ? no no "6.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.t-b2c-interfase.Libre_Char[2]
"Libre_Char[2]" "Nro!Cmpbnte" "x(15)" "character" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.t-b2c-interfase.Libre_Deci[1]
"Libre_Deci[1]" "Impte!Cmpbnte" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.t-b2c-interfase.Neto_Abonar
"Neto_Abonar" "Impte!Abonado" "->>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "13.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-11 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-8
/* Query rebuild information for BROWSE BROWSE-8
     _TblList          = "Temp-Tables.t-estrac_bancario"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.t-estrac_bancario.movimiento|yes"
     _FldNameList[1]   > Temp-Tables.t-estrac_bancario.libre_log[1]
"libre_log[1]" "Elija" ? "logical" ? ? ? ? ? ? no ? no no "3.43" yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-estrac_bancario.fech_operacion
"fech_operacion" "Fecha!Operacion" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.t-estrac_bancario.cod_operacion
"cod_operacion" "Cod.!Operacion" "x(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.t-estrac_bancario.movimiento
"movimiento" "Movimiento" ? "character" ? ? ? ? ? ? no ? no no "22.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-estrac_bancario.detalle
"detalle" "Tarjeta/Detalle" "x(50)" "character" ? ? ? ? ? ? no ? no no "24.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.t-estrac_bancario.canal
"canal" "Canal" ? "character" ? ? ? ? ? ? no ? no no "16.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.t-estrac_bancario.abono
"abono" "Abono" "->>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "17.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-8 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONCILIACION BANCARIA - PAGOEFECTIVO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONCILIACION BANCARIA - PAGOEFECTIVO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-11
&Scoped-define SELF-NAME BROWSE-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-11 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-11 IN FRAME F-Main /* Lista de Comprobantes para la conciliacion */
DO:
    DEFINE VARIABLE iRowHeight   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iLastY       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iRow         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE hCell        AS HANDLE      NO-UNDO.
    DEFINE VARIABLE iTopRowY     AS INTEGER     NO-UNDO.

    DEFINE VARIABLE dRow         AS DEC     NO-UNDO.

    /* See if there are ANY rows in view... */
    IF SELF:NUM-ITERATIONS = 0 THEN 
    DO:
       /* No rows, the user clicked on an empty browse widget */ 
       RETURN NO-APPLY. 
    END.

    /* We don't know which row was clicked on, we have to calculate it from the mouse coordinates and the row heights. No really. */
    SELF:SELECT-ROW(1).               /* Select the first row so we can get the first cell. */
    hCell      = SELF:FIRST-COLUMN.   /* Get the first cell so we can get the Y coord of the first row, and the height of cells. */
    iTopRowY   = hCell:Y - 1.         /* The Y coord of the top of the top row relative to the browse widget. Had to subtract 1 pixel to get it accurate. */
    iRowHeight = hCell:HEIGHT-PIXELS. /* SELF:ROW-HEIGHT-PIXELS is not the same as hCell:HEIGHT-PIXELS for some reason */
    iLastY     = LAST-EVENT:Y.        /* The Y position of the mouse event (relative to the browse widget) */

    /* calculate which row was clicked. Truncate so that it doesn't round clicks past the middle of the row up to the next row. */
    dRow       = 1 + (iLastY - iTopRowY) / iRowHeight.
    iRow       = 1 + TRUNCATE((iLastY - iTopRowY) / iRowHeight, 0).

    IF iRow = 1  THEN DO:
        IF dRow > 1  THEN DO:
            iRow = iRow + 1.
        END.
    END.
    ELSE DO:
        iRow = iRow + 1.
    END.

    IF iRow > 0 AND iRow <= SELF:NUM-ITERATIONS THEN 
    DO:
      /* The user clicked on a populated row */
      /*Your coding here, for example:*/
        SELF:SELECT-ROW(iRow).

        IF t-b2c-interfase.libre_log[1] = YES THEN DO:
            ASSIGN t-b2c-interfase.libre_log[1] = NO.
            t-b2c-interfase.libre_log[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "NO".
            x-total-a-conciliar = x-total-a-conciliar - t-b2c-interfase.neto_abonar.
        END.
        ELSE DO:
            ASSIGN t-b2c-interfase.libre_log[1] = YES.
            t-b2c-interfase.libre_log[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "YES".
            x-total-a-conciliar = x-total-a-conciliar + t-b2c-interfase.neto_abonar.
        END.
        fill-in-total-conciliar:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-total-a-conciliar,"->>,>>>,>>9.99").
        /*ff_just_right(INPUT fill-in-total-conciliar:HANDLE IN FRAME {&FRAME-NAME}).*/

    END.
    ELSE DO:
      /* The click was on an empty row. */
      /*SELF:DESELECT-ROWS().*/

      RETURN NO-APPLY.
    END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-8
&Scoped-define SELF-NAME BROWSE-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-8 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-8 IN FRAME F-Main /* Seleccione los Items del estracto bancario para conciliar */
DO:
    DEFINE VARIABLE iRowHeight   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iLastY       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iRow         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE hCell        AS HANDLE      NO-UNDO.
    DEFINE VARIABLE iTopRowY     AS INTEGER     NO-UNDO.

    DEFINE VARIABLE dRow         AS DEC     NO-UNDO.

    /* See if there are ANY rows in view... */
    IF SELF:NUM-ITERATIONS = 0 THEN 
    DO:
       /* No rows, the user clicked on an empty browse widget */ 
       RETURN NO-APPLY. 
    END.

    /* We don't know which row was clicked on, we have to calculate it from the mouse coordinates and the row heights. No really. */
    SELF:SELECT-ROW(1).               /* Select the first row so we can get the first cell. */
    hCell      = SELF:FIRST-COLUMN.   /* Get the first cell so we can get the Y coord of the first row, and the height of cells. */
    iTopRowY   = hCell:Y - 1.         /* The Y coord of the top of the top row relative to the browse widget. Had to subtract 1 pixel to get it accurate. */
    iRowHeight = hCell:HEIGHT-PIXELS. /* SELF:ROW-HEIGHT-PIXELS is not the same as hCell:HEIGHT-PIXELS for some reason */
    iLastY     = LAST-EVENT:Y.        /* The Y position of the mouse event (relative to the browse widget) */

    /* calculate which row was clicked. Truncate so that it doesn't round clicks past the middle of the row up to the next row. */
    dRow       = 1 + (iLastY - iTopRowY) / iRowHeight.
    iRow       = 1 + TRUNCATE((iLastY - iTopRowY) / iRowHeight, 0).

    /*
    MESSAGE iRow SKIP
            dRow.
    */
    IF iRow = 1  THEN DO:
        IF dRow > 1  THEN DO:
            iRow = iRow + 1.
        END.
    END.
    ELSE DO:
        iRow = iRow + 1.
    END.
    

    IF iRow > 0 AND iRow <= SELF:NUM-ITERATIONS THEN 
    DO:
      /* The user clicked on a populated row */
      /*Your coding here, for example:*/
        SELF:SELECT-ROW(iRow).

        IF t-estrac_bancario.libre_log[1] = YES THEN DO:
            ASSIGN t-estrac_bancario.libre_log[1] = NO.
            t-estrac_bancario.libre_log[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "NO".
            x-total = x-total - t-estrac_bancario.libre_dec[1].
        END.
        ELSE DO:
            ASSIGN t-estrac_bancario.libre_log[1] = YES.
            t-estrac_bancario.libre_log[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "YES".
            x-total = x-total + t-estrac_bancario.libre_dec[1].
        END.
        fill-in-total:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-total,"->>,>>>,>>9.99").
        /*ff_just_right(INPUT fill-in-total-conciliar:HANDLE IN FRAME {&FRAME-NAME}).*/

    END.
    ELSE DO:
      /* The click was on an empty row. */
      /*SELF:DESELECT-ROWS().*/

      RETURN NO-APPLY.
    END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 W-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* Aceptar */
DO:
  
    ASSIGN fill-in-fecha-operacion.

    IF fill-in-fecha-operacion = ? THEN DO:
        MESSAGE "Por favor ingrese una fecha valida" 
            VIEW-AS ALERT-BOX INFORMATION.

        RETURN NO-APPLY.
    END.

    ENABLE browse-8 WITH FRAME {&FRAME-NAME}.
    fill-in-total:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.00".

    RUN temporal-estracto.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-documentos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-documentos W-Win
ON CHOOSE OF BUTTON-documentos IN FRAME F-Main /* Ir a doumentos para conciliar */
DO:
  
  DISABLE browse-8 WITH FRAME {&FRAME-NAME}.
  SELF:VISIBLE = NO.

  RUN temporal-documentos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-fecha-operacion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-fecha-operacion W-Win
ON ENTRY OF FILL-IN-fecha-operacion IN FRAME F-Main /* Ingrese fecha de Operacion */
DO:
    browse-8:VISIBLE = NO.
    browse-9:VISIBLE = NO.
    browse-11:VISIBLE = NO.

    fill-in-total:VISIBLE IN FRAME {&FRAME-NAME} = NO.
    fill-in-total-conti:VISIBLE IN FRAME {&FRAME-NAME} = NO.
    fill-in-total-conciliar:VISIBLE IN FRAME {&FRAME-NAME} = NO.
    button-grabar:VISIBLE = NO.
    button-documentos:VISIBLE = NO.

    /*h_b-conciliacion-de-pagoefectivo:VISIBLE = NO.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-11
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
  DISPLAY FILL-IN-fecha-operacion FILL-IN-5 FILL-IN-total 
          FILL-IN-total-conciliar FILL-IN-total-conti 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-fecha-operacion BUTTON-7 BROWSE-8 BUTTON-documentos BROWSE-11 
         BUTTON-grabar 
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  fill-in-fecha-operacion:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").


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
  {src/adm/template/snd-list.i "t-estrac_bancario"}
  {src/adm/template/snd-list.i "t-b2c-interfase"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE temporal-documentos W-Win 
PROCEDURE temporal-documentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
SESSION:SET-WAIT-STATE("GENERAL").  

DEFINE VAR x-total-conti AS DEC.

SESSION:SET-WAIT-STATE("GENERAL").  
EMPTY TEMP-TABLE t-b2c-interfase.

x-total-a-conciliar = 0.

FOR EACH b2c-interfase WHERE b2c-interfase.codcia = s-codcia AND    
                                b2c-interfase.flgest = 'PC' /*AND
                                b2c-interfase.fecha_abono = fill-in-fecha-operacion*/ NO-LOCK:
    CREATE t-b2c-interfase.
    BUFFER-COPY b2c-interfase TO t-b2c-interfase.

    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                ccbcdocu.coddoc = b2c-interfase.libre_char[3] AND 
                                ccbcdocu.nrodoc = b2c-interfase.libre_char[4] NO-LOCK NO-ERROR.

    IF AVAILABLE ccbcdocu THEN ASSIGN t-b2c-interfase.libre_dec[1] = ccbcdocu.imptot.

    x-total-conti = x-total-conti + ccbcdocu.imptot.

END.

{&open-query-browse-11}
browse-11:VISIBLE IN FRAME {&FRAME-NAME} = YES.
button-grabar:VISIBLE IN FRAME {&FRAME-NAME} = YES.

fill-in-total-conciliar:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.00".
fill-in-total-conciliar:VISIBLE IN FRAME {&FRAME-NAME} = YES.
SESSION:SET-WAIT-STATE("").  


/*
FOR EACH pago_efectivo WHERE pago_efectivo.codcia = s-codcia AND
                                pago_efectivo.flgest = "PC" /*AND
                                pago_efectivo.fecha_cancelacion = fill-in-fecha-operacion*/ NO-LOCK:
    CREATE t-pago_efectivo.
    BUFFER-COPY pago_efectivo TO t-pago_efectivo.

    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                ccbcdocu.coddoc = pago_efectivo.libre_char[3] AND 
                                ccbcdocu.nrodoc = pago_efectivo.libre_char[4] NO-LOCK NO-ERROR.

    IF AVAILABLE ccbcdocu THEN ASSIGN t-pago_efectivo.libre_dec[1] = ccbcdocu.imptot.

    x-total-conti = x-total-conti + pago_efectivo.monto.

END.


{&open-query-browse-9}


button-grabar:VISIBLE IN FRAME {&FRAME-NAME} = YES.
browse-9:VISIBLE IN FRAME {&FRAME-NAME} = YES.

/*

*/




fill-in-total-conti:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-total-conti,"->>,>>>,>>9.99").
fill-in-total-conti:VISIBLE IN FRAME {&FRAME-NAME} = YES.

fill-in-total-conciliar:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.00".
fill-in-total-conciliar:VISIBLE IN FRAME {&FRAME-NAME} = YES.

*/

/*
ff_just_right(INPUT fill-in-total:HANDLE).
ff_just_right(INPUT fill-in-total-conti:HANDLE).
ff_just_right(INPUT fill-in-total-conciliar:HANDLE).
*/
SESSION:SET-WAIT-STATE("").


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE temporal-estracto W-Win 
PROCEDURE temporal-estracto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE("GENERAL").  

DEFINE VAR x-total-conti AS DEC.

EMPTY TEMP-TABLE t-estrac_bancario.
EMPTY TEMP-TABLE t-pago_efectivo.

x-total = 0.

FOR EACH estrac_bancario WHERE estrac_bancario.codcia = s-codcia AND
                                estrac_bancario.fech_operacion = fill-in-fecha-operacion NO-LOCK:
    CREATE t-estrac_bancario.
    BUFFER-COPY estrac_bancario TO t-estrac_bancario.

    t-estrac_bancario.libre_dec[1] = estrac_bancario.abono.

    /*x-total = x-total + estrac_bancario.abono.*/
END.

{&open-query-browse-8}

fill-in-total:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-total,"->>,>>>,>>9.99").
browse-8:VISIBLE IN FRAME {&FRAME-NAME} = YES.
fill-in-total:VISIBLE IN FRAME {&FRAME-NAME} = YES.
button-documentos:VISIBLE IN FRAME {&FRAME-NAME} = YES.

/*
FOR EACH pago_efectivo WHERE pago_efectivo.codcia = s-codcia AND
                                pago_efectivo.flgest = "PC" /*AND
                                pago_efectivo.fecha_cancelacion = fill-in-fecha-operacion*/ NO-LOCK:
    CREATE t-pago_efectivo.
    BUFFER-COPY pago_efectivo TO t-pago_efectivo.

    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                ccbcdocu.coddoc = pago_efectivo.libre_char[3] AND 
                                ccbcdocu.nrodoc = pago_efectivo.libre_char[4] NO-LOCK NO-ERROR.

    IF AVAILABLE ccbcdocu THEN ASSIGN t-pago_efectivo.libre_dec[1] = ccbcdocu.imptot.

    x-total-conti = x-total-conti + pago_efectivo.monto.

END.


{&open-query-browse-9}


button-grabar:VISIBLE IN FRAME {&FRAME-NAME} = YES.
browse-9:VISIBLE IN FRAME {&FRAME-NAME} = YES.

/*

*/




fill-in-total-conti:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-total-conti,"->>,>>>,>>9.99").
fill-in-total-conti:VISIBLE IN FRAME {&FRAME-NAME} = YES.

fill-in-total-conciliar:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.00".
fill-in-total-conciliar:VISIBLE IN FRAME {&FRAME-NAME} = YES.

*/

/*
ff_just_right(INPUT fill-in-total:HANDLE).
ff_just_right(INPUT fill-in-total-conti:HANDLE).
ff_just_right(INPUT fill-in-total-conciliar:HANDLE).
*/
SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ff_just_right W-Win 
FUNCTION ff_just_right RETURNS CHARACTER ( INPUT h AS HANDLE ) :

    DEFINE VARIABLE reps AS INTEGER     NO-UNDO. 

    /*reps = (h:WIDTH-PIXELS - FONT-TABLE:GET-TEXT-WIDTH-PIXELS(TRIM(h:SCREEN-VALUE),h:FONT)) - 8 / FONT-TABLE:GET-TEXT-WIDTH-PIXELS(' ',h:FONT).*/
    /*
    reps = (h:WIDTH-PIXELS - FONT-TABLE:GET-TEXT-WIDTH-PIXELS(TRIM(h:SCREEN-VALUE),h:FONT) - 8 /* allow for 3-D borders */ ) / FONT-TABLE:GET-TEXT-WIDTH-PIXELS(' ',h:FONT).
    h:SCREEN-VALUE = FILL(' ',reps) + TRIM(h:SCREEN-VALUE).
    */
    reps = (h:WIDTH-PIXELS - FONT-TABLE:GET-TEXT-WIDTH-PIXELS(TRIM(h:SCREEN-VALUE),h:FONT) - 8 /* allow for 3-D borders */ ) / FONT-TABLE:GET-TEXT-WIDTH-PIXELS(' ',h:FONT).
    reps = reps / 2.
    h:SCREEN-VALUE = FILL(' ',reps) + TRIM(h:SCREEN-VALUE).


    RETURN 'OK'.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ff_just_rightfrr W-Win 
FUNCTION ff_just_rightfrr RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

