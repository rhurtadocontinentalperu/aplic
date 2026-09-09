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
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR x-divdesp AS CHAR.

x-divdesp = "00040".
/*
x-divdesp = "00035".
*/

DEFINE VAR x-emision-desde AS DATE.
DEFINE VAR x-emision-hasta AS DATE.
DEFINE VAR x-tot-ordenes AS INT INIT 0.
DEFINE VAR x-tot-ordenes-generadas AS INT INIT 0.

/* Si adiciona un campo a esta tabla tambien hacerlo en logis/d-resumen-pre-rutas.w y d-pre-rutas-x-distrito.w*/
DEFINE TEMP-TABLE ttResumen
    FIELD   tcuadrante     AS  CHAR    FORMAT 'x(5)'
    FIELD   ttotclie    AS  INT     INIT 0
    FIELD   ttotpeso    AS  DEC     INIT 0
    FIELD   ttotvol     AS  DEC     INIT 0
    FIELD   ttotimp     AS  DEC     INIT 0
    FIELD   ttotord     AS  INT     INIT 0
    FIELD   tnro-phruta AS CHAR     FORMAT 'x(15)'
    FIELD   tobserva    AS CHAR     FORMAT 'x(15)'
    FIELD   tswok       AS CHAR     FORMAT 'x(1)' INIT ""
.
/* Si adiciona un campo a esta tabla tambien hacerlo en d-pre-rutas-x-distrito*/
DEFINE TEMP-TABLE   ttDetalle
    FIELD   tcuadrante     AS  CHAR    FORMAT 'x(5)'
    FIELD   tcoddoc     AS  CHAR    FORMAT '(5)'
    FIELD   tnroped     AS  CHAR    FORMAT 'x(15)'
    FIELD   tcodcli     AS  CHAR    FORMAT 'x(12)'
    FIELD   ttotpeso    AS  DEC     INIT 0
    FIELD   ttotvol     AS  DEC     INIT 0
    FIELD   ttotimp     AS  DEC     INIT 0
    FIELD   tubigeo     AS  CHAR    FORMAT 'x(8)'
    FIELD   titems      AS  INT     INIT 0
    FIELD   tfchped     AS  DATE
    FIELD   tfchent     AS  DATE
    FIELD   tnomcli     AS  CHAR
.
/*
O/D , Cliente , Fecha Entrega,Items,Peso,S/,m3
*/
DEFINE TEMP-TABLE ttCliente
    FIELD   tcuadrante     AS  CHAR    FORMAT 'X(5)'
    FIELD   tcodcli     AS  CHAR    FORMAT 'x(11)'.
    .

DEF VAR s-coddoc AS CHAR INIT 'PHR' NO-UNDO.    /* Pre Hoja de Ruta */


DEFINE TEMP-TABLE x-di-rutaC LIKE di-rutaC.
DEFINE TEMP-TABLE x-di-rutaD LIKE di-rutaD.

DEFINE VAR x-numero-orden AS INT .
DEFINE VAR x-serie-orden AS INT .

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
&Scoped-define INTERNAL-TABLES GN-DIVI

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 GN-DIVI.CodDiv GN-DIVI.DesDiv 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH GN-DIVI ~
      WHERE gn-divi.codcia = s-codcia NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH GN-DIVI ~
      WHERE gn-divi.codcia = s-codcia NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 GN-DIVI
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 GN-DIVI


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-11 RECT-12 COMBO-BOX-despacho BROWSE-2 ~
BUTTON-1 BUTTON-2 FILL-IN-desde FILL-IN-hasta COMBO-BOX-corte BUTTON-3 ~
FILL-IN-entrega-desde FILL-IN-entrega-hasta 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-despacho FILL-IN-desde ~
FILL-IN-hasta COMBO-BOX-corte FILL-IN-entrega-desde FILL-IN-entrega-hasta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD evalua-condicion W-Win 
FUNCTION evalua-condicion RETURNS LOGICAL
  ( INPUT pValor1 AS DEC, INPUT pValor2 AS DEC, INPUT pDato AS DEC, INPUT pCondLogica AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Todos" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "Ninguno" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-3 
     LABEL "Calcular Pre-Rutas" 
     SIZE 27 BY 1.12
     FONT 9.

DEFINE VARIABLE COMBO-BOX-corte AS CHARACTER FORMAT "X(15)":U 
     LABEL "Hora de Corte" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-despacho AS CHARACTER FORMAT "X(8)":U 
     LABEL "Division de despacho" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 38.43 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-entrega-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-entrega-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 1.58.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46 BY 1.58.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      GN-DIVI SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      GN-DIVI.CodDiv COLUMN-LABEL "Codigo" FORMAT "x(8)":U
      GN-DIVI.DesDiv FORMAT "X(40)":U WIDTH 49.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 61 BY 15.58
         TITLE "Seleccione la lista de Precios" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-despacho AT ROW 1.38 COL 20.86 COLON-ALIGNED WIDGET-ID 2
     BROWSE-2 AT ROW 2.92 COL 2.14 WIDGET-ID 200
     BUTTON-1 AT ROW 4.65 COL 64.57 WIDGET-ID 4
     BUTTON-2 AT ROW 6.19 COL 64.57 WIDGET-ID 6
     FILL-IN-desde AT ROW 19.54 COL 8.14 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-hasta AT ROW 19.54 COL 31 COLON-ALIGNED WIDGET-ID 16
     COMBO-BOX-corte AT ROW 19.58 COL 58.86 COLON-ALIGNED WIDGET-ID 8
     BUTTON-3 AT ROW 21.38 COL 49 WIDGET-ID 12 NO-TAB-STOP 
     FILL-IN-entrega-desde AT ROW 21.58 COL 8 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-entrega-hasta AT ROW 21.58 COL 30.86 COLON-ALIGNED WIDGET-ID 24
     " Fecha de emision de las Ordenes" VIEW-AS TEXT
          SIZE 33.14 BY .62 AT ROW 18.88 COL 3.86 WIDGET-ID 20
          FGCOLOR 9 FONT 0
     " Fecha de ENTREGA de las Ordenes" VIEW-AS TEXT
          SIZE 33.14 BY .62 AT ROW 20.88 COL 3.86 WIDGET-ID 28
          FGCOLOR 4 FONT 0
     RECT-11 AT ROW 19.23 COL 2 WIDGET-ID 18
     RECT-12 AT ROW 21.23 COL 2 WIDGET-ID 26
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.72 BY 23.23 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Generacion de Pre-Rutas"
         HEIGHT             = 22.12
         WIDTH              = 81
         MAX-HEIGHT         = 27.12
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 27.12
         VIRTUAL-WIDTH      = 195.14
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
/* BROWSE-TAB BROWSE-2 COMBO-BOX-despacho F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.GN-DIVI"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "gn-divi.codcia = s-codcia"
     _FldNameList[1]   > INTEGRAL.GN-DIVI.CodDiv
"GN-DIVI.CodDiv" "Codigo" "x(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.GN-DIVI.DesDiv
"GN-DIVI.DesDiv" ? ? "character" ? ? ? ? ? ? no ? no no "49.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Generacion de Pre-Rutas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Generacion de Pre-Rutas */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Todos */
DO:
  BROWSE-2:SELECT-ALL().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Ninguno */
DO:
  BROWSE-2:DESELECT-ROWS ( ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Calcular Pre-Rutas */
DO:
  ASSIGN fill-in-desde fill-in-hasta combo-box-despacho combo-box-corte
       FILL-IN-entrega-desde fill-in-entrega-hasta.

  IF fill-in-desde > fill-in-hasta THEN DO:
      MESSAGE "Rango de fechas de emision esta errada!!" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF fill-in-entrega-desde > fill-in-entrega-hasta THEN DO:
      MESSAGE "Rango de fechas de emision esta errada!!" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.

  SESSION:SET-WAIT-STATE("GENERAL").
  RUN procesar.
  SESSION:SET-WAIT-STATE("").

  DEFINE VAR x-procesar AS CHAR.

  /* Visualizar el Resumen */
  x-procesar = "".
  RUN logis/d-resumen-pre-rutas(INPUT TABLE ttResumen, INPUT TABLE ttDetalle, OUTPUT x-procesar).

  IF x-procesar = 'SI' THEN DO:
      RUN generar-pre-rutas.
  END.

  BROWSE-2:SELECT-ALL().
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
  DISPLAY COMBO-BOX-despacho FILL-IN-desde FILL-IN-hasta COMBO-BOX-corte 
          FILL-IN-entrega-desde FILL-IN-entrega-hasta 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-11 RECT-12 COMBO-BOX-despacho BROWSE-2 BUTTON-1 BUTTON-2 
         FILL-IN-desde FILL-IN-hasta COMBO-BOX-corte BUTTON-3 
         FILL-IN-entrega-desde FILL-IN-entrega-hasta 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-pre-rutas W-Win 
PROCEDURE generar-pre-rutas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-peso-desde AS DEC INIT 0.
DEFINE VAR x-peso-hasta AS DEC INIT 0.
DEFINE VAR x-vol-desde AS DEC INIT 0.
DEFINE VAR x-vol-hasta AS DEC INIT 0.
DEFINE VAR x-imp-desde AS DEC INIT 0.
DEFINE VAR x-imp-hasta AS DEC INIT 0.

DEFINE VAR x-condicion AS LOG.
DEFINE VAR x-procesado AS CHAR.

x-tot-ordenes = 0.
x-tot-ordenes-generadas = 0.

EMPTY TEMP-TABLE x-di-rutaC.
EMPTY TEMP-TABLE x-di-rutaD.

SESSION:SET-WAIT-STATE("GENERAL").

x-numero-orden = 0.
x-serie-orden = 0.

FOR EACH ttResumen :
    FIND FIRST rut-cuadrante-cab WHERE rut-cuadrante-cab.codcia = s-codcia AND
                                        rut-cuadrante-cab.cuadrante = ttResumen.tcuadrante NO-LOCK NO-ERROR.
    /* Solo aquellos que tengan ubicado el CUADRANTE */
    IF NOT AVAILABLE rut-cuadrante-cab THEN NEXT.
    /**/
    CONFIGURACION:
    FOR EACH vtaCtabla WHERE vtaCtabla.codcia = s-codcia AND 
                                vtaCtabla.tabla = 'COND-PRE-HRUTA' NO-LOCK BY vtactabla.libre_d03:

        x-condicion = NO.
        x-procesado = "".
        /* Camiones */
        CAMIONES:        
        FOR EACH rut-conf-phr WHERE rut-conf-phr.codcia = s-codcia AND 
                                        rut-conf-phr.tabla = vtaCtabla.tabla AND
                                        rut-conf-phr.llave = vtactabla.llave NO-LOCK BY rut-conf-phr.libre_d10 :
            x-condicion = NO.

            x-peso-hasta = rut-conf-phr.libre_d01.
            x-peso-desde = x-peso-hasta * ((100 - rut-conf-phr.libre_d04) / 100).

            x-condicion = evalua-condicion(x-peso-desde, x-peso-hasta, ttResumen.ttotpeso, TRIM(rut-conf-phr.libre_c01)).
            /* Si la condicion es FALSO siguiente CAMION */
            IF x-condicion = NO THEN NEXT.

            x-vol-hasta = rut-conf-phr.libre_d02.
            x-vol-desde = x-vol-hasta * ((100 - rut-conf-phr.libre_d05) / 100).

            x-condicion = evalua-condicion(x-vol-desde, x-vol-hasta, ttResumen.ttotvol, TRIM(rut-conf-phr.libre_c02)).
            /* Si la condicion es FALSO siguiente CAMION */
            IF x-condicion = NO THEN NEXT.

            x-imp-hasta = rut-conf-phr.libre_d03.
            x-imp-desde = x-imp-hasta * ((100 - rut-conf-phr.libre_d06) / 100).

            x-condicion = evalua-condicion(x-imp-desde, x-imp-hasta, ttResumen.ttotimp, TRIM(rut-conf-phr.libre_c03)).
            /* Si la condicion es FALSO siguiente CAMION */
            IF x-condicion = YES THEN DO:
                /*  */      
                x-procesado = "".
                RUN grabar-ordenes-en-pre-ruta(INPUT ttResumen.tcuadrante, OUTPUT x-procesado, INPUT STRING(rut-conf-phr.libre_d10)).
                LEAVE CONFIGURACION.
            END.
        END.
        IF x-condicion = NO AND x-procesado = "" THEN DO:
            /* Carros en TRANSITO */
            x-procesado = "".
            RUN grabar-ordenes-en-pre-ruta(INPUT ttResumen.tcuadrante, OUTPUT x-procesado, INPUT "CARRO DE TRANSITO").
            IF x-procesado = "OK" THEN DO:
                /**/
            END.
        END.
        ELSE DO:
            /* Hubo problemas al crear las PRE-RUTAS */
        END.
    END.
END.
/* Elimino los cuadrante que no generaron Pre-Ruta */
FOR EACH ttResumen WHERE ttResumen.tswok = '' :
    FOR EACH ttDetalle WHERE ttDetalle.tcuadrante = ttResumen.tcuadrante :
        DELETE ttDetalle.
    END.
    DELETE ttResumen.
END.

SESSION:SET-WAIT-STATE("").

/* A mostrar la Pre-Rutas x distrito */
x-procesado = "".
RUN logis/d-pre-rutas-x-distrito.r(INPUT TABLE ttResumen, INPUT TABLE ttDetalle, OUTPUT x-procesado).

IF x-procesado = 'SI' THEN DO:
    /* La siguiente pantalla UNIR pre-RUtas*/
    x-procesado = "".
    RUN logis/d-modificacion-pre-rutas.r(INPUT TABLE ttResumen, 
                                         INPUT TABLE ttDetalle, 
                                         INPUT TABLE x-di-rutaC,
                                         INPUT TABLE x-di-rutaD,
                                         OUTPUT x-procesado).

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-ordenes-en-pre-ruta W-Win 
PROCEDURE grabar-ordenes-en-pre-ruta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCuadrante AS CHAR.
DEFINE OUTPUT PARAMETER pProcesado AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pObserva AS CHAR.

pProcesado = "".

IF NOT CAN-FIND(FIRST Faccorre WHERE FacCorre.CodCia = s-codcia 
                AND FacCorre.CodDiv = s-coddiv 
                AND FacCorre.CodDoc = s-coddoc 
                AND FacCorre.FlgEst = YES
                NO-LOCK) THEN DO:
    pProcesado = "NO definido el correlativo para el documento:" +  s-coddoc.
    RETURN.
END.

DEFINE BUFFER b-ttResumen FOR ttResumen.

pProcesado = "".
GRABAR_DATOS:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    x-numero-orden = x-numero-orden + 1.
    DO:
        /* Header update block */
        CREATE x-DI-RutaC.
        ASSIGN
            x-DI-RutaC.CodCia = s-codcia
            x-DI-RutaC.CodDiv = s-coddiv
            x-DI-RutaC.CodDoc = s-coddoc
            x-DI-RutaC.FchDoc = TODAY
            x-DI-RutaC.NroDoc = STRING(x-serie-orden, '999') + 
                                STRING(x-numero-orden, '999999')
            x-DI-RutaC.codrut = "AUTOMATICO"    /*pGlosa*/
            x-DI-RutaC.observ = pObserva
            x-DI-RutaC.usuario = s-user-id
            x-DI-RutaC.flgest  = "PX".     /* Pendiente x Pickear*/
        /* Datos de Topes Máximos */
        ASSIGN
            x-DI-RutaC.Libre_d01 = ttResumen.ttotclie
            x-DI-RutaC.Libre_d02 = ttResumen.ttotpeso
            x-DI-RutaC.Libre_d03 = ttResumen.ttotvol.
        ASSIGN
            x-DI-RutaC.Libre_f01 = FILL-IN-Desde 
            x-DI-RutaC.Libre_f02 = FILL-IN-Hasta
            x-DI-RutaC.Libre_c01 = COMBO-BOX-corte    /* Hora de Corte */
            x-DI-RutaC.Libre_c02 = ""                 /* FILL-IN_NroPed */ 
            x-DI-RutaC.Libre_c03 = ""                 /* FILL-IN_Cliente. */
            NO-ERROR
        .
        IF ERROR-STATUS:ERROR = YES  THEN DO:
            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
        END.
    END.
    /* Detalle de Ordenes */
    FOR EACH ttDetalle WHERE ttDetalle.tcuadrante = pCuadrante :
        CREATE x-DI-RutaD.
        ASSIGN
            x-DI-RutaD.CodCia = x-DI-RutaC.CodCia
            x-DI-RutaD.CodDiv = x-DI-RutaC.CodDiv
            x-DI-RutaD.CodDoc = x-DI-RutaC.CodDoc
            x-DI-RutaD.NroDoc = x-DI-RutaC.NroDoc
            x-DI-RutaD.CodRef = ttDetalle.tcoddoc
            x-DI-RutaD.NroRef = ttDetalle.tnroped.
        
        ASSIGN
            x-DI-RutaD.ImpCob    = ttDetalle.ttotvol
            x-DI-RutaD.Libre_d01 = ttDetalle.ttotpeso
            x-DI-RutaD.Libre_d02 = ttDetalle.ttotimp
            x-DI-RutaD.Libre_c01 = "0"                         /* STRING(T-RUTAD.Bultos). */
            NO-ERROR
        .
        IF ERROR-STATUS:ERROR = YES  THEN DO:
            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
        END.

    END.
    /*  */
    FIND FIRST b-ttResumen WHERE b-ttResumen.tcuadrante = pCuadrante EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE b-ttResumen THEN DO:
        /*MESSAGE x-DI-RutaC.NroDoc.*/
        ASSIGN b-ttResumen.tnro-phruta = x-DI-RutaC.NroDoc
                b-ttResumen.tobserva = pObserva
                b-ttResumen.tswok = 'S'.
    END.
    ELSE DO:
        UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
    END.
    pProcesado = "OK".
END. /* TRANSACTION block */
RELEASE b-ttResumen.

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
  DEFINE VAR x-filer AS CHAR INIT "".
  COMBO-BOX-despacho:DELETE(COMBO-BOX-despacho:NUM-ITEMS) IN FRAME {&FRAME-NAME}.
          
  DO WITH FRAME {&FRAME-NAME}.
       COMBO-BOX-despacho:DELIMITER = "|".
  END.

  FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia NO-LOCK:
      COMBO-BOX-despacho:ADD-LAST(gn-divi.coddiv + ' - ' + gn-divi.desdiv, gn-divi.coddiv).
  END.  

  COMBO-BOX-despacho:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-divdesp.

  /**/
  COMBO-BOX-corte:DELETE(COMBO-BOX-corte:LIST-ITEMS).
  DEFINE VAR x-sec AS INT.
  REPEAT x-sec = 0 TO 23:
        COMBO-BOX-corte:ADD-LAST(STRING(x-sec,"99") + ":" + "00").
        COMBO-BOX-corte:ADD-LAST(STRING(x-sec,"99") + ":" + "15").
        COMBO-BOX-corte:ADD-LAST(STRING(x-sec,"99") + ":" + "30").
        COMBO-BOX-corte:ADD-LAST(STRING(x-sec,"99") + ":" + "45").
  END.
   COMBO-BOX-Corte:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '17:00'.

   fill-in-desde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 15 , "99/99/9999").
   fill-in-hasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY , "99/99/9999").

   fill-in-entrega-desde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 5 , "99/99/9999").
   fill-in-entrega-hasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY + 15, "99/99/9999").

   BROWSE-2:SELECT-ALL().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar W-Win 
PROCEDURE procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-sec AS INT.
DEFINE VAR x-coddiv AS CHAR.

EMPTY TEMP-TABLE ttResumen.
EMPTY TEMP-TABLE ttDetalle.
EMPTY TEMP-TABLE ttCliente.

DO WITH FRAME {&FRAME-NAME}:
    
    DO x-sec = 1 TO browse-2:NUM-SELECTED-ROWS :
        IF browse-2:FETCH-SELECTED-ROW(x-sec) THEN DO:
            x-coddiv = {&first-table-in-query-browse-2}.coddiv.
            RUN procesar-ordenes (INPUT x-coddiv).
        END.
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-orden W-Win 
PROCEDURE procesar-orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE OUTPUT PARAMETER pMsg AS CHAR.

DEFINE VAR x-codped AS CHAR INIT "".
DEFINE VAR x-nroped AS CHAR INIT "".

DEFINE BUFFER x-faccpedi FOR faccpedi.
DEFINE BUFFER x-pedido FOR faccpedi.

DEFINE VAR x-hora-emision AS CHAR.

FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                            x-faccpedi.coddoc = pCoddoc AND
                            x-faccpedi.nroped = pNroDoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-faccpedi THEN DO:
    pMsg = "Orden no existe " + pCoddoc + " " + pNroDoc.
    RETURN "ADM-ERROR".
END.

/* Validar la HORA de corte vs la emision */
x-hora-emision = x-faccpedi.hora.
IF TRUE <> (x-hora-emision > "") THEN DO:
    x-hora-emision = "00:00".
END.
IF LENGTH(x-hora-emision) > 5 THEN x-hora-emision = SUBSTRING(x-hora-emision,1,5).

IF x-faccpedi.fchped = fill-in-hasta AND x-hora-emision <= combo-box-corte  THEN DO:
    pMsg = "La HORA esta fuera del CORTE " + pCoddoc + " " + pNroDoc.
    RETURN "ADM-ERROR".
END.

/* Pedido */
x-codped = x-faccpedi.codref.
x-nroped = x-faccpedi.nroref.

FIND FIRST x-pedido WHERE x-pedido.codcia = s-codcia AND
                            x-pedido.coddoc = x-codped AND 
                            x-pedido.nroped = x-nroped NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-pedido THEN DO:
    pMsg = "Pedido no existe " + x-codped + " " + x-nroped.
    RETURN "ADM-ERROR".
END.

/* Ubicacion de coordenadas */
DEFINE VAR x-ubigeo AS CHAR INIT "".
DEFINE VAR x-longuitud AS DEC INIT 0.
DEFINE VAR x-latitud AS DEC INIT 0.
DEFINE VAR x-filer AS DEC INIT 0.
DEFINE VAR x-cuadrante AS CHAR INIT "".

DEFINE VAR x-items AS INT.

RUN logis/p-datos-sede-auxiliar(INPUT x-pedido.ubigeo[2], 
                                INPUT x-pedido.ubigeo[3],
                                INPUT x-pedido.ubigeo[1],
                                OUTPUT x-ubigeo,
                                OUTPUT x-longuitud,
                                OUTPUT x-latitud).
IF x-ubigeo = "" THEN DO:
    /*
    pMsg = "Imposible ubicar ubigeo de la Orden " + pCoddoc + " " + pNroDoc.
    RETURN "ADM-ERROR".
    */
    x-cuadrante = "ERR".
    /*
        A pedido de MAX RAMOS el dia 23/01/2019 a las 16:20pm, indico que los ERR pasarlos a P0
    */
    /*x-cuadrante = "P0".*/
END.
ELSE DO:
    /*MESSAGE x-pedido.ubigeo[3] pNroDoc SKIP x-ubigeo SKIP x-longuitud SKIP x-latitud.*/
    /*
    x-filer = x-longuitud.
    x-longuitud = x-latitud.
    x-latitud = x-filer.
    */
    RUN logis/p-cuadrante(INPUT x-longuitud, INPUT x-latitud, OUTPUT x-cuadrante).
    IF x-cuadrante = "" THEN x-cuadrante = "P0".  /*XYZ*/
END.


pMsg = "".
/* Resumen */
FIND FIRST ttResumen WHERE ttResumen.tcuadrante = x-cuadrante NO-ERROR.
IF NOT AVAILABLE ttResumen THEN DO:
    CREATE ttResumen.
        ASSIGN ttResumen.tcuadrante = x-cuadrante.
END.
ASSIGN ttResumen.ttotord = ttResumen.ttotord + 1.

/* Ordenes x Cuadrante */
FIND FIRST ttDetalle WHERE ttDetalle.tcuadrante = x-cuadrante AND
                            ttDetalle.tcoddoc = pCodDoc AND
                            ttDetalle.tnroped = pNroDoc NO-ERROR.
IF NOT AVAILABLE ttDEtalle THEN DO:
    CREATE ttDetalle.
        ASSIGN ttDetalle.tcuadrante = x-cuadrante
                ttDetalle.tcoddoc = pCodDoc
                ttDetalle.tnroped = pNroDoc
                ttDetalle.tubigeo = x-ubigeo
                ttDetalle.tcodcli = x-faccpedi.codcli
                ttDetalle.tfchped  = x-faccpedi.fchped
                ttDetalle.tfchent  = x-faccpedi.fchent
                ttDetalle.tnomcli = x-faccpedi.nomcli
        .
END.

/* Clientes x Cuadrante */
FIND FIRST ttCliente WHERE ttCliente.tcuadrante = x-cuadrante AND
                            ttCliente.tcodcli = x-faccpedi.codcli NO-ERROR.
IF NOT AVAILABLE ttCliente THEN DO:
    ASSIGN ttResumen.ttotcli = ttResumen.ttotcli + 1.
    /**/
    CREATE ttCliente.
        ASSIGN ttCliente.tcuadrante = x-cuadrante
                ttCliente.tcodcli = x-faccpedi.codcli
    .
END.


FOR EACH facdpedi WHERE facdpedi.codcia = s-codcia AND
                            facdpedi.coddoc = pCodDoc AND
                            facdpedi.nroped = pNroDoc NO-LOCK:
    FIND FIRST almmmatg OF facdpedi NO-LOCK NO-ERROR.
    
    /* Totales x Resumen */
    ASSIGN ttResumen.ttotpeso = ttResumen.ttotpeso + ((facdpedi.canped * facdpedi.factor) * almmmatg.pesmat)
            ttResumen.ttotvol = ttResumen.ttotvol + ((facdpedi.canped * facdpedi.factor) * (almmmatg.libre_d02 / 10000000))
            ttResumen.ttotimp = ttResumen.ttotimp + facdpedi.implin
    .
    /* Totales de la Orden */
    ASSIGN ttDetalle.ttotpeso = ttDetalle.ttotpeso + ((facdpedi.canped * facdpedi.factor) * almmmatg.pesmat)
            ttDetalle.ttotvol = ttDetalle.ttotvol + ((facdpedi.canped * facdpedi.factor) * (almmmatg.libre_d02 / 10000000))
            ttDetalle.ttotimp = ttDetalle.ttotimp + facdpedi.implin
            ttDetalle.titems = ttDetalle.titems + 1

    .
END.

/*  */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-ordenes W-Win 
PROCEDURE procesar-ordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCoddiv AS CHAR.

/* RHC 28/01/2019 Solo cuando Faccpedi.FlgEst = "P" y Faccpedi.FlgSit = "T" */
/* Lógica solo para TAPICEROS (00040) */
DEFINE VAR x-msg AS CHAR.
FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia AND
        faccpedi.divdes = combo-box-despacho AND
        faccpedi.coddoc = 'O/D' AND
        faccpedi.flgest = 'P' AND 
        faccpedi.flgsit = "T" AND
        (faccpedi.fchped >= fill-in-desde AND faccpedi.fchped <= fill-in-hasta) AND
        faccpedi.coddiv = pCoddiv NO-LOCK :
    IF (faccpedi.fchent >= fill-in-entrega-desde AND faccpedi.fchent <= fill-in-entrega-hasta) THEN DO:
        /* Grabar */
        x-msg = "".
        RUN procesar-orden(INPUT faccpedi.coddoc, INPUT faccpedi.nroped, OUTPUT x-msg).
        IF x-msg = 'OK' THEN DO:
            x-tot-ordenes-generadas = x-tot-ordenes-generadas + 1.
        END.
    END.
END.
/*
FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia AND
                            faccpedi.divdes = combo-box-despacho AND
                            faccpedi.coddoc = 'O/D' AND
                            faccpedi.flgest = 'P' AND
                            (faccpedi.fchped >= fill-in-desde AND faccpedi.fchped <= fill-in-hasta) AND
                            faccpedi.coddiv = pCoddiv NO-LOCK :

    IF (faccpedi.fchent >= fill-in-entrega-desde AND faccpedi.fchent <= fill-in-entrega-hasta) THEN DO:
        /* Verifica si la orden aun no esta trajada */
        x-tot-ordenes = x-tot-ordenes + 1.
        RUN validar-orden(INPUT faccpedi.coddoc, INPUT faccpedi.nroped).

        IF RETURN-VALUE = "ADM-ERROR" THEN NEXT.
        /* Grabar */
        x-msg = "".
        RUN procesar-orden(INPUT faccpedi.coddoc, INPUT faccpedi.nroped, OUTPUT x-msg).

        IF x-msg = 'OK' THEN DO:
            x-tot-ordenes-generadas = x-tot-ordenes-generadas + 1.
        END.
    END.
END.
*/
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
  {src/adm/template/snd-list.i "GN-DIVI"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validar-orden W-Win 
PROCEDURE validar-orden PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.

DEF BUFFER B-RutaC FOR Di-RutaC.
DEF BUFFER B-RUTAD FOR Di-RutaD.
DEF BUFFER B-RUTAG FOR Di-RutaG.
DEFINE BUFFER x-faccpedi FOR faccpedi.

FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                               x-faccpedi.coddoc = pCoddoc AND 
                                x-faccpedi.nroped = pNroDoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-faccpedi THEN RETURN "ADM-ERROR".

{dist/valida-od-para-phr.i}

/* ****************
/* Está en una PHR en trámite => NO va */
FIND FIRST DI-RutaD WHERE DI-RutaD.CodCia = s-CodCia AND
    DI-RutaD.CodDiv = s-CodDiv AND
    DI-RutaD.CodDoc = "PHR" AND
    DI-RutaD.CodRef = pCodDoc AND
    DI-RutaD.NroRef = pNroDoc AND
    CAN-FIND(DI-RutaC OF DI-RutaD WHERE DI-RutaC.FlgEst BEGINS "P" NO-LOCK)
    NO-LOCK NO-ERROR.
IF AVAILABLE DI-RutaD THEN RETURN 'ADM-ERROR'.

/* Si tiene una reprogramación por aprobar => No va  */
FIND FIRST Almcdocu WHERE AlmCDocu.CodCia = s-CodCia AND
  AlmCDocu.CodLlave = s-CodDiv AND
  AlmCDocu.CodDoc = pCodDoc AND 
  AlmCDocu.NroDoc = pNroDoc AND
  AlmCDocu.FlgEst = "P" NO-LOCK NO-ERROR.
IF AVAILABLE Almcdocu THEN RETURN 'ADM-ERROR'.

/* Si ya fue entregado o tiene una devolución parcial NO va */
FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
  AND CcbCDocu.CodPed = x-Faccpedi.codref       /* PED */
  AND CcbCDocu.NroPed = x-Faccpedi.nroref
  AND Ccbcdocu.Libre_c01 = x-Faccpedi.coddoc    /* O/D */
  AND Ccbcdocu.Libre_c02 = x-Faccpedi.nroped
  AND Ccbcdocu.FlgEst <> "A":
  IF NOT (Ccbcdocu.coddiv = s-coddiv AND Ccbcdocu.coddoc = "G/R") THEN NEXT.
  FOR EACH B-RutaD NO-LOCK WHERE B-RutaD.CodCia = s-codcia
      AND B-RutaD.CodDiv = s-CodDiv
      AND B-RutaD.CodDoc = "H/R"
      AND B-RutaD.CodRef = Ccbcdocu.coddoc
      AND B-RutaD.NroRef = Ccbcdocu.nrodoc,
      FIRST B-RutaC OF B-RutaD NO-LOCK WHERE B-RutaC.FlgEst = 'C':
      IF B-RutaD.FlgEst = "C" THEN RETURN 'ADM-ERROR'.  /* Entregado */
      IF B-RutaD.FlgEst = "D" THEN RETURN 'ADM-ERROR'.  /* Devolución Parcial */

      /* Verificamos que haya pasado por PHR */
      IF NOT CAN-FIND(FIRST DI-RutaD WHERE DI-RutaD.CodCia = s-CodCia AND
                      DI-RutaD.CodDiv = s-CodDiv AND
                      DI-RutaD.CodDoc = "PHR" AND
                      DI-RutaD.CodRef = x-Faccpedi.CodDoc AND
                      DI-RutaD.NroRef = x-Faccpedi.NroPed AND
                      CAN-FIND(DI-RutaC OF DI-RutaD WHERE DI-RutaC.FlgEst = "C" NO-LOCK)
                      NO-LOCK)
          THEN RETURN 'ADM-ERROR'.
  END.
END.

FOR EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = s-CodCia AND 
  Almcmov.CodRef = x-Faccpedi.CodDoc AND 
  Almcmov.NroRef = x-Faccpedi.NroPed AND
  Almcmov.FlgEst <> 'A':
  FOR EACH B-RutaG NO-LOCK WHERE B-RutaG.CodCia = s-codcia
      AND B-RutaG.CodDiv = s-CodDiv
      AND B-RutaG.CodDoc = "H/R"
      AND B-RutaG.CodAlm = Almcmov.CodAlm
      AND B-RutaG.Tipmov = Almcmov.TipMov
      AND B-RutaG.Codmov = Almcmov.CodMov
      AND B-RutaG.SerRef = Almcmov.NroSer
      AND B-RutaG.NroRef = Almcmov.NroDoc,
      FIRST B-RutaC OF B-RutaG NO-LOCK WHERE B-RutaC.FlgEst = 'C':
      IF B-RutaG.FlgEst = "C" THEN RETURN 'ADM-ERROR'.  /* Entregado */
      IF B-RutaG.FlgEst = "D" THEN RETURN 'ADM-ERROR'.  /* Devolución Parcial */
  END.
END.

/* Si está en una H/R en trámite => No va */
FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
  AND CcbCDocu.CodPed = x-Faccpedi.codref       /* PED */
  AND CcbCDocu.NroPed = x-Faccpedi.nroref
  AND Ccbcdocu.Libre_c01 = x-Faccpedi.coddoc    /* O/D */
  AND Ccbcdocu.Libre_c02 = x-Faccpedi.nroped
  AND Ccbcdocu.FlgEst <> "A":
  IF NOT (Ccbcdocu.coddiv = s-coddiv AND Ccbcdocu.coddoc = "G/R") THEN NEXT.
  FOR EACH B-RutaD NO-LOCK WHERE B-RutaD.CodCia = s-codcia
      AND B-RutaD.CodDiv = s-CodDiv
      AND B-RutaD.CodDoc = "H/R"
      AND B-RutaD.CodRef = Ccbcdocu.coddoc
      AND B-RutaD.NroRef = Ccbcdocu.nrodoc,
      FIRST B-RutaC OF B-RutaD NO-LOCK WHERE B-RutaC.FlgEst = 'P':
      RETURN 'ADM-ERROR'.
  END.
END.
FOR EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = s-CodCia AND 
  Almcmov.CodRef = Faccpedi.CodDoc AND 
  Almcmov.NroRef = Faccpedi.NroPed AND
  Almcmov.FlgEst <> 'A':
  FOR EACH B-RutaG NO-LOCK WHERE B-RutaG.CodCia = s-codcia
      AND B-RutaG.CodDiv = s-CodDiv
      AND B-RutaG.CodDoc = "H/R"
      AND B-RutaG.CodAlm = Almcmov.CodAlm
      AND B-RutaG.Tipmov = Almcmov.TipMov
      AND B-RutaG.Codmov = Almcmov.CodMov
      AND B-RutaG.SerRef = Almcmov.NroSer
      AND B-RutaG.NroRef = Almcmov.NroDoc,
      FIRST B-RutaC OF B-RutaG NO-LOCK WHERE B-RutaC.FlgEst BEGINS 'P':
      RETURN 'ADM-ERROR'.
  END.
END.
**************** */

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION evalua-condicion W-Win 
FUNCTION evalua-condicion RETURNS LOGICAL
  ( INPUT pValor1 AS DEC, INPUT pValor2 AS DEC, INPUT pDato AS DEC, INPUT pCondLogica AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VAR x-retval AS LOG INIT NO.

    IF (pDato >= pValor1 AND pDato <= pValor2) THEN x-retval = YES.

    /*
    IF pCondLogica = '>' THEN DO:
        x-retval = IF (pValor1 > pValor2) THEN YES ELSE NO.
    END.
    IF pCondLogica = '<' THEN DO:
        x-retval = IF (pValor1 < pValor2) THEN YES ELSE NO.
    END.
    IF pCondLogica = '=' THEN DO:
        x-retval = IF (pValor1 = pValor2) THEN YES ELSE NO.
    END.
    IF pCondLogica = '>=' THEN DO:
        x-retval = IF (pValor1 >= pValor2) THEN YES ELSE NO.
    END.
    IF pCondLogica = '<=' THEN DO:            
        x-retval = IF (pValor1 <= pValor2) THEN YES ELSE NO.
    END.
    */

    RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

