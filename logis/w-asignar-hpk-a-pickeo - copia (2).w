&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-rut-pers-turno NO-UNDO LIKE rut-pers-turno
       fields hinicio as char
       fields htermino as char
       fields hefectivas as dec
       fields nombre-picador as char
       fields origen-picador as char
       fields total-asig as int
       FIELD hpks AS INT
       FIELD items AS INT
       field peso as deci.
DEFINE TEMP-TABLE tt-VtaCDocu NO-UNDO LIKE VtaCDocu.



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
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR s-codalm AS CHAR.

DEFINE VAR x-coddoc AS CHAR INIT 'HPK'.

DEFINE VAR x-hora-inicio-col AS CHAR.
DEFINE VAR x-hora-termino-col AS CHAR.
DEFINE VAR x-horas-efectivas-col AS DEC.

DEFINE VAR x-nombre-picador-col AS CHAR.
DEFINE VAR x-origen-picador-col AS CHAR.

DEFINE VAR x-segundos-phk-disponibles-picador AS INT.
DEFINE VAR x-segundos-phk-seleccionados-picador AS INT.

DEFINE VAR x-segundos-phk-disponibles-chequeador AS INT.
DEFINE VAR x-segundos-phk-seleccionados-chequeador AS INT.

DEFINE VAR x-Peso AS DECI NO-UNDO.

DEFINE TEMP-TABLE ttOrdenes NO-UNDO
    FIELD   tcoddoc     AS  CHAR    FORMAT 'X(5)'
    FIELD   tnrodoc     AS  CHAR    FORMAT 'x(12)'
    FIELD   tcodref     AS  CHAR    FORMAT 'X(5)'
    FIELD   tnroref     AS  CHAR    FORMAT 'x(12)'
    FIELD   titems      AS  INT INIT 0
    FIELD   tpeso       AS  DEC INIT 0
    FIELD   tvolumen    AS  DEC INIT 0
.

DEFINE VAR x-col-total-hpk-asig AS INT.
DEFINE VAR x-col-total-item-asig AS INT.

DEFINE BUFFER x-vtacdocu FOR vtacdocu.
DEFINE BUFFER y-vtacdocu FOR vtacdocu.

IF USERID("DICTDB") = "MASTER" THEN DO:
    s-coddiv = '00000'.
END.

DEFINE VAR x-nombre-picador AS CHAR INIT "".

DEFINE TEMP-TABLE t-vtacdocu NO-UNDO LIKE vtacdocu.

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
&Scoped-define INTERNAL-TABLES tt-VtaCDocu tt-rut-pers-turno

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 tt-VtaCDocu.NroPed ~
tt-VtaCDocu.NroOri tt-VtaCDocu.FchPed tt-VtaCDocu.Hora tt-VtaCDocu.FchEnt ~
tt-VtaCDocu.ZonaPickeo tt-VtaCDocu.Items tt-VtaCDocu.Peso ~
tt-VtaCDocu.CodRef tt-VtaCDocu.NroRef tt-VtaCDocu.NomCli 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH tt-VtaCDocu ~
      WHERE tt-VtaCDocu.Libre_c02 = "" NO-LOCK ~
    BY tt-VtaCDocu.FchEnt DESCENDING ~
       BY tt-VtaCDocu.NomCli ~
        BY tt-VtaCDocu.CodRef ~
         BY tt-VtaCDocu.NroRef ~
          BY tt-VtaCDocu.CodPed ~
           BY tt-VtaCDocu.NroPed
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH tt-VtaCDocu ~
      WHERE tt-VtaCDocu.Libre_c02 = "" NO-LOCK ~
    BY tt-VtaCDocu.FchEnt DESCENDING ~
       BY tt-VtaCDocu.NomCli ~
        BY tt-VtaCDocu.CodRef ~
         BY tt-VtaCDocu.NroRef ~
          BY tt-VtaCDocu.CodPed ~
           BY tt-VtaCDocu.NroPed.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 tt-VtaCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 tt-VtaCDocu


/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 ~
tt-rut-pers-turno.nombre-picador @ x-nombre-picador-col ~
tt-rut-pers-turno.origen-picador @ x-origen-picador-col ~
tt-rut-pers-turno.turno tt-rut-pers-turno.hpks @ x-col-total-hpk-asig ~
tt-rut-pers-turno.items @ x-col-total-item-asig ~
tt-rut-pers-turno.peso @ x-peso ~
tt-rut-pers-turno.hinicio @ x-hora-inicio-col ~
tt-rut-pers-turno.htermino @ x-hora-termino-col 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH tt-rut-pers-turno ~
      WHERE (TRUE <> (FILL-IN-Nombre-Picador > '')) OR INDEX(tt-rut-pers-turno.nombre-picador, FILL-IN-Nombre-Picador) > 0 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH tt-rut-pers-turno ~
      WHERE (TRUE <> (FILL-IN-Nombre-Picador > '')) OR INDEX(tt-rut-pers-turno.nombre-picador, FILL-IN-Nombre-Picador) > 0 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 tt-rut-pers-turno
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 tt-rut-pers-turno


/* Definitions for BROWSE BROWSE-6                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-6 tt-VtaCDocu.CodPed ~
tt-VtaCDocu.NroPed tt-VtaCDocu.NroOri tt-VtaCDocu.FchPed tt-VtaCDocu.Hora ~
tt-VtaCDocu.CodTer tt-VtaCDocu.ZonaPickeo tt-VtaCDocu.Items ~
tt-VtaCDocu.Peso tt-VtaCDocu.Libre_c01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-6 
&Scoped-define QUERY-STRING-BROWSE-6 FOR EACH tt-VtaCDocu ~
      WHERE tt-VtaCDocu.Libre_c02 = "ASIGNAR" NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-6 OPEN QUERY BROWSE-6 FOR EACH tt-VtaCDocu ~
      WHERE tt-VtaCDocu.Libre_c02 = "ASIGNAR" NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-6 tt-VtaCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-6 tt-VtaCDocu


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}~
    ~{&OPEN-QUERY-BROWSE-5}~
    ~{&OPEN-QUERY-BROWSE-6}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 FILL-IN-FchEnt-1 FILL-IN-FchEnt-2 ~
BUTTON-FILTRAR COMBO-BOX-Tipo COMBO-BOX-Sector BUTTON-3 ~
FILL-IN-Nombre-Picador BUTTON-4 BROWSE-3 BROWSE-5 BROWSE-6 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-FchEnt-1 FILL-IN-FchEnt-2 ~
COMBO-BOX-Tipo COMBO-BOX-Sector FILL-IN-Nombre-Picador FILL-IN-Items ~
FILL-IN-Peso 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-total-hpk-asig W-Win 
FUNCTION f-total-hpk-asig RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-total-item-asig W-Win 
FUNCTION f-total-item-asig RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-BROWSE-3 
       MENU-ITEM m_Detalle_HPK  LABEL "Detalle HPK"   .


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     LABEL "Asignar HPK a picador" 
     SIZE 22 BY 1.12.

DEFINE BUTTON BUTTON-4 
     LABEL "Filtrar" 
     SIZE 7 BY .81.

DEFINE BUTTON BUTTON-FILTRAR 
     LABEL "APLICAR FILTROS" 
     SIZE 16 BY 1.12.

DEFINE VARIABLE COMBO-BOX-Sector AS CHARACTER FORMAT "X(256)":U INITIAL "TODOS" 
     LABEL "Sector" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "TODOS" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Tipo AS CHARACTER FORMAT "X(256)":U INITIAL "TODOS" 
     LABEL "Tipo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "TODOS","RACK","ESTANTERIA" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Total tiempo PICADOR" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1
     FGCOLOR 9 FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U INITIAL "Total tiempo CHEQUEADOR" 
     VIEW-AS FILL-IN 
     SIZE 37.29 BY 1
     FGCOLOR 4 FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-chequeador AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.29 BY 1
     BGCOLOR 15 FGCOLOR 4 FONT 11 NO-UNDO.

DEFINE VARIABLE FILL-IN-chequeador2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.14 BY 1
     BGCOLOR 15 FGCOLOR 4 FONT 11 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchEnt-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde Fecha Entrega" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchEnt-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Items AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Items" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Nombre-Picador AS CHARACTER FORMAT "X(256)":U 
     LABEL "Filtrar por Picador" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Peso AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Peso" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-picador AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.29 BY 1
     BGCOLOR 15 FGCOLOR 9 FONT 11 NO-UNDO.

DEFINE VARIABLE FILL-IN-picador2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.14 BY 1
     BGCOLOR 15 FGCOLOR 9 FONT 11 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 2.15.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      tt-VtaCDocu SCROLLING.

DEFINE QUERY BROWSE-5 FOR 
      tt-rut-pers-turno SCROLLING.

DEFINE QUERY BROWSE-6 FOR 
      tt-VtaCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      tt-VtaCDocu.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U
            WIDTH 10.43
      tt-VtaCDocu.NroOri COLUMN-LABEL "PHR" FORMAT "x(15)":U WIDTH 9.29
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      tt-VtaCDocu.FchPed COLUMN-LABEL "Emision" FORMAT "99/99/9999":U
      tt-VtaCDocu.Hora FORMAT "X(5)":U WIDTH 5.72
      tt-VtaCDocu.FchEnt FORMAT "99/99/9999":U WIDTH 10.57
      tt-VtaCDocu.ZonaPickeo COLUMN-LABEL "Sector" FORMAT "x(10)":U
            WIDTH 6.43
      tt-VtaCDocu.Items FORMAT ">>>,>>9":U WIDTH 4.43
      tt-VtaCDocu.Peso FORMAT "->>>,>>9.99":U WIDTH 5.29
      tt-VtaCDocu.CodRef COLUMN-LABEL "Refer." FORMAT "x(3)":U
            WIDTH 4.29
      tt-VtaCDocu.NroRef COLUMN-LABEL "Numero" FORMAT "X(15)":U
            WIDTH 8.43
      tt-VtaCDocu.NomCli FORMAT "x(60)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 81.72 BY 18.31
         FONT 4
         TITLE "HPK sin mesa para asignar".

DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      tt-rut-pers-turno.nombre-picador @ x-nombre-picador-col COLUMN-LABEL "Picador" FORMAT "x(50)":U
            WIDTH 29.57
      tt-rut-pers-turno.origen-picador @ x-origen-picador-col COLUMN-LABEL "Origen" FORMAT "x(15)":U
            WIDTH 7.43
      tt-rut-pers-turno.turno COLUMN-LABEL "TURNO" FORMAT "x(15)":U
            WIDTH 9.14
      tt-rut-pers-turno.hpks @ x-col-total-hpk-asig COLUMN-LABEL "#HPK" FORMAT ">>9":U
            WIDTH 5.43
      tt-rut-pers-turno.items @ x-col-total-item-asig COLUMN-LABEL "#Items" FORMAT ">>>9":U
      tt-rut-pers-turno.peso @ x-peso COLUMN-LABEL "Peso"
      tt-rut-pers-turno.hinicio @ x-hora-inicio-col COLUMN-LABEL "Inicio"
            WIDTH 9.43
      tt-rut-pers-turno.htermino @ x-hora-termino-col COLUMN-LABEL "Termino"
            WIDTH 16.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89.14 BY 10.35
         FONT 4
         TITLE "Personal disponible" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-6 W-Win _STRUCTURED
  QUERY BROWSE-6 NO-LOCK DISPLAY
      tt-VtaCDocu.CodPed COLUMN-LABEL "Codi." FORMAT "x(3)":U
      tt-VtaCDocu.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U
            WIDTH 11.29
      tt-VtaCDocu.NroOri COLUMN-LABEL "PHR" FORMAT "x(15)":U WIDTH 9.14
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      tt-VtaCDocu.FchPed COLUMN-LABEL "Emision" FORMAT "99/99/9999":U
      tt-VtaCDocu.Hora FORMAT "X(5)":U WIDTH 5.72
      tt-VtaCDocu.CodTer COLUMN-LABEL "Tipo" FORMAT "x(15)":U WIDTH 12.14
      tt-VtaCDocu.ZonaPickeo COLUMN-LABEL "Sector" FORMAT "x(10)":U
            WIDTH 5.57
      tt-VtaCDocu.Items FORMAT ">>>,>>9":U
      tt-VtaCDocu.Peso FORMAT "->>>,>>9.99":U WIDTH 6.57
      tt-VtaCDocu.Libre_c01 COLUMN-LABEL "Tiempo" FORMAT "x(50)":U
            WIDTH 12.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 88.86 BY 7.77
         FONT 4
         TITLE "Ordenes seleccionadas para la asignacion" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-FchEnt-1 AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 40
     FILL-IN-FchEnt-2 AT ROW 1.27 COL 45 COLON-ALIGNED WIDGET-ID 42
     BUTTON-FILTRAR AT ROW 1.27 COL 67 WIDGET-ID 6
     COMBO-BOX-Tipo AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 36
     COMBO-BOX-Sector AT ROW 2.08 COL 45 COLON-ALIGNED WIDGET-ID 38
     BUTTON-3 AT ROW 2.08 COL 89.72 WIDGET-ID 22
     FILL-IN-Nombre-Picador AT ROW 2.35 COL 127.72 COLON-ALIGNED WIDGET-ID 30
     BUTTON-4 AT ROW 2.35 COL 150.72 WIDGET-ID 32
     BROWSE-3 AT ROW 3.15 COL 2 WIDGET-ID 200
     BROWSE-5 AT ROW 3.31 COL 84.86 WIDGET-ID 300
     BROWSE-6 AT ROW 13.73 COL 85.14 WIDGET-ID 400
     FILL-IN-Items AT ROW 21.46 COL 142.72 COLON-ALIGNED WIDGET-ID 24
     FILL-IN-Peso AT ROW 21.46 COL 159 COLON-ALIGNED WIDGET-ID 44
     FILL-IN-2 AT ROW 21.62 COL 6 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     FILL-IN-picador AT ROW 21.62 COL 40.43 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     FILL-IN-picador2 AT ROW 22.54 COL 84.72 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     FILL-IN-chequeador2 AT ROW 22.54 COL 125.72 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     FILL-IN-3 AT ROW 22.65 COL 2.72 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     FILL-IN-chequeador AT ROW 22.65 COL 40.43 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     RECT-1 AT ROW 1 COL 2 WIDGET-ID 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 177.43 BY 22.85
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-rut-pers-turno T "?" NO-UNDO INTEGRAL rut-pers-turno
      ADDITIONAL-FIELDS:
          fields hinicio as char
          fields htermino as char
          fields hefectivas as dec
          fields nombre-picador as char
          fields origen-picador as char
          fields total-asig as int
          FIELD hpks AS INT
          FIELD items AS INT
          field peso as deci
      END-FIELDS.
      TABLE: tt-VtaCDocu T "?" NO-UNDO INTEGRAL VtaCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Asignacion de HOJA DE PICKING a PICADOR"
         HEIGHT             = 22.85
         WIDTH              = 177.43
         MAX-HEIGHT         = 22.85
         MAX-WIDTH          = 177.43
         VIRTUAL-HEIGHT     = 22.85
         VIRTUAL-WIDTH      = 177.43
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
/* BROWSE-TAB BROWSE-3 BUTTON-4 F-Main */
/* BROWSE-TAB BROWSE-5 BROWSE-3 F-Main */
/* BROWSE-TAB BROWSE-6 BROWSE-5 F-Main */
ASSIGN 
       BROWSE-3:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-BROWSE-3:HANDLE
       BROWSE-3:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2.

/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN-2:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN-3:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-chequeador IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN-chequeador:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-chequeador2 IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN-chequeador2:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Items IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Peso IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-picador IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN-picador:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-picador2 IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN-picador2:HIDDEN IN FRAME F-Main           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.tt-VtaCDocu"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-VtaCDocu.FchEnt|no,Temp-Tables.tt-VtaCDocu.NomCli|yes,Temp-Tables.tt-VtaCDocu.CodRef|yes,Temp-Tables.tt-VtaCDocu.NroRef|yes,Temp-Tables.tt-VtaCDocu.CodPed|yes,Temp-Tables.tt-VtaCDocu.NroPed|yes"
     _Where[1]         = "Temp-Tables.tt-VtaCDocu.Libre_c02 = """""
     _FldNameList[1]   > Temp-Tables.tt-VtaCDocu.NroPed
"tt-VtaCDocu.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-VtaCDocu.NroOri
"tt-VtaCDocu.NroOri" "PHR" ? "character" 11 0 ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-VtaCDocu.FchPed
"tt-VtaCDocu.FchPed" "Emision" "99/99/9999" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-VtaCDocu.Hora
"tt-VtaCDocu.Hora" ? ? "character" ? ? ? ? ? ? no ? no no "5.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-VtaCDocu.FchEnt
"tt-VtaCDocu.FchEnt" ? "99/99/9999" "date" ? ? ? ? ? ? no ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-VtaCDocu.ZonaPickeo
"tt-VtaCDocu.ZonaPickeo" "Sector" ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-VtaCDocu.Items
"tt-VtaCDocu.Items" ? ? "integer" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-VtaCDocu.Peso
"tt-VtaCDocu.Peso" ? ? "decimal" ? ? ? ? ? ? no ? no no "5.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-VtaCDocu.CodRef
"tt-VtaCDocu.CodRef" "Refer." ? "character" ? ? ? ? ? ? no ? no no "4.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-VtaCDocu.NroRef
"tt-VtaCDocu.NroRef" "Numero" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   = Temp-Tables.tt-VtaCDocu.NomCli
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.tt-rut-pers-turno"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "(TRUE <> (FILL-IN-Nombre-Picador > '')) OR INDEX(tt-rut-pers-turno.nombre-picador, FILL-IN-Nombre-Picador) > 0"
     _FldNameList[1]   > "_<CALC>"
"tt-rut-pers-turno.nombre-picador @ x-nombre-picador-col" "Picador" "x(50)" ? ? ? ? ? ? ? no ? no no "29.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"tt-rut-pers-turno.origen-picador @ x-origen-picador-col" "Origen" "x(15)" ? ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-rut-pers-turno.turno
"tt-rut-pers-turno.turno" "TURNO" ? "character" ? ? ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"tt-rut-pers-turno.hpks @ x-col-total-hpk-asig" "#HPK" ">>9" ? ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"tt-rut-pers-turno.items @ x-col-total-item-asig" "#Items" ">>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"tt-rut-pers-turno.peso @ x-peso" "Peso" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"tt-rut-pers-turno.hinicio @ x-hora-inicio-col" "Inicio" ? ? ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"tt-rut-pers-turno.htermino @ x-hora-termino-col" "Termino" ? ? ? ? ? ? ? ? no ? no no "16.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-6
/* Query rebuild information for BROWSE BROWSE-6
     _TblList          = "Temp-Tables.tt-VtaCDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "Temp-Tables.tt-VtaCDocu.Libre_c02 = ""ASIGNAR"""
     _FldNameList[1]   > Temp-Tables.tt-VtaCDocu.CodPed
"tt-VtaCDocu.CodPed" "Codi." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-VtaCDocu.NroPed
"tt-VtaCDocu.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "11.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-VtaCDocu.NroOri
"tt-VtaCDocu.NroOri" "PHR" ? "character" 11 0 ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-VtaCDocu.FchPed
"tt-VtaCDocu.FchPed" "Emision" "99/99/9999" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-VtaCDocu.Hora
"tt-VtaCDocu.Hora" ? ? "character" ? ? ? ? ? ? no ? no no "5.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-VtaCDocu.CodTer
"tt-VtaCDocu.CodTer" "Tipo" "x(15)" "character" ? ? ? ? ? ? no ? no no "12.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-VtaCDocu.ZonaPickeo
"tt-VtaCDocu.ZonaPickeo" "Sector" ? "character" ? ? ? ? ? ? no ? no no "5.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = Temp-Tables.tt-VtaCDocu.Items
     _FldNameList[9]   > Temp-Tables.tt-VtaCDocu.Peso
"tt-VtaCDocu.Peso" ? ? "decimal" ? ? ? ? ? ? no ? no no "6.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-VtaCDocu.Libre_c01
"tt-VtaCDocu.Libre_c01" "Tiempo" "x(50)" "character" ? ? ? ? ? ? no ? no no "12.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Asignacion de HOJA DE PICKING a PICADOR */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Asignacion de HOJA DE PICKING a PICADOR */
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
ON MOUSE-SELECT-DBLCLICK OF BROWSE-3 IN FRAME F-Main /* HPK sin mesa para asignar */
DO:
    DEFINE VAR x-rows-seleccionados AS INT.
    x-rows-seleccionados = browse-3:NUM-SELECTED-ROWS.  
    IF x-rows-seleccionados < 1 THEN DO:
        MESSAGE "Seleccione Registro, por favor!!" VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.

/*     IF tt-vtacdocu.libre_c01 = "Sin Configuracion" THEN DO:                                                    */
/*         MESSAGE "Seleccione Registro que tenga tiempo configurado, por favor!!" VIEW-AS ALERT-BOX INFORMATION. */
/*         RETURN NO-APPLY.                                                                                       */
/*     END.                                                                                                       */

    x-segundos-phk-disponibles-picador = x-segundos-phk-disponibles-picador - tt-vtacdocu.importe[1].
    x-segundos-phk-disponibles-chequeador = x-segundos-phk-disponibles-chequeador - tt-vtacdocu.importe[2].

    x-segundos-phk-seleccionados-picador = x-segundos-phk-seleccionados-picador + tt-vtacdocu.importe[1].
    x-segundos-phk-seleccionados-chequeador = x-segundos-phk-seleccionados-chequeador + tt-vtacdocu.importe[2].

    ASSIGN tt-vtacdocu.libre_c02 = "ASIGNAR".

    {&open-query-browse-3}
    {&open-query-browse-6}

    RUN refrescar-totales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-6
&Scoped-define SELF-NAME BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-6 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-6 IN FRAME F-Main /* Ordenes seleccionadas para la asignacion */
DO:
    DEFINE VAR x-rows-seleccionados AS INT.
    x-rows-seleccionados = browse-6:NUM-SELECTED-ROWS.  
    IF x-rows-seleccionados < 1 THEN DO:
        MESSAGE "Seleccione el Registro, por favor!!" VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.
  
    x-segundos-phk-disponibles-picador = x-segundos-phk-disponibles-picador + tt-vtacdocu.importe[1].
    x-segundos-phk-seleccionados-picador = x-segundos-phk-seleccionados-picador - tt-vtacdocu.importe[1].

    x-segundos-phk-disponibles-chequeador = x-segundos-phk-disponibles-chequeador + tt-vtacdocu.importe[2].
    x-segundos-phk-seleccionados-chequeador = x-segundos-phk-seleccionados-chequeador - tt-vtacdocu.importe[2].

    ASSIGN tt-vtacdocu.libre_c02 = "".
    {&open-query-browse-3}
    {&open-query-browse-6}

    RUN refrescar-totales.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Asignar HPK a picador */
DO:
  RUN asignar-orden.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Filtrar */
DO:
  ASSIGN FILL-IN-Nombre-Picador.

  FILL-IN-Nombre-Picador = TRIM(FILL-IN-Nombre-Picador).

  x-nombre-picador = "".
  IF FILL-IN-Nombre-Picador > "" THEN x-nombre-picador = "*" + FILL-IN-Nombre-Picador + "*".

  {&OPEN-QUERY-BROWSE-5}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-FILTRAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-FILTRAR W-Win
ON CHOOSE OF BUTTON-FILTRAR IN FRAME F-Main /* APLICAR FILTROS */
DO:
  ASSIGN 
      COMBO-BOX-Sector COMBO-BOX-Tipo 
      FILL-IN-FchEnt-1 FILL-IN-FchEnt-2.
  SESSION:SET-WAIT-STATE("GENERAL").
  RUN refrescar.
  SESSION:SET-WAIT-STATE("").
  MESSAGE 'Carga Terminada' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Detalle_HPK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Detalle_HPK W-Win
ON CHOOSE OF MENU-ITEM m_Detalle_HPK /* Detalle HPK */
DO:
    IF AVAILABLE tt-Vtacdocu THEN RUN logis/d-asignar-hpk-a-pickeo (tt-VtaCDocu.CodPed, tt-VtaCDocu.NroPed).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}


/* ON ROW-DISPLAY OF browse-5                                                               */
/* DO:                                                                                      */
/*     x-col-total-hpk-asig = 0.                                                            */
/*                                                                                          */
/*     FOR EACH x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND                           */
/*                                 x-vtacdocu.codped = 'HPK' AND                            */
/*                                 x-vtacdocu.flgest = 'P' and x-vtacdocu.flgsit = 'TP' AND */
/*                                 x-vtacdocu.usrsac = tt-rut-pers-turno.dni NO-LOCK:       */
/*         x-col-total-hpk-asig = x-col-total-hpk-asig + 1.                                 */
/*     END.                                                                                 */
/*                                                                                          */
/*                                                                                          */
/* END.                                                                                     */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE asignar-orden W-Win 
PROCEDURE asignar-orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-rows-seleccionados AS INT.
DEFINE VAR x-error AS CHAR NO-UNDO.

DEFINE VAR x-picador AS CHAR.
DEFINE VAR x-dni AS CHAR.

x-rows-seleccionados = browse-5:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}.  
IF x-rows-seleccionados < 1 THEN DO:
    MESSAGE "Seleccione un personal disponible, por favor!!" VIEW-AS ALERT-BOX INFORMATION.
    RETURN NO-APPLY.
END.

MESSAGE 'Seguro de asignar las ordenes seleccionadas?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.

x-picador = tt-rut-pers-turno.nombre-picador .
x-dni = tt-rut-pers-turno.dni.

MESSAGE 'El PICADOR es el correcto ' + x-picador + "?" VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta2 AS LOG.
IF rpta2 = NO THEN RETURN NO-APPLY.

SESSION:SET-WAIT-STATE("GENERAL").

/* Totalizar cantidades */
RUN preparo-ordenes.

x-Error = "Inicio de Grabaciones".

GRABAR_DATOS:
DO TRANSACTION ON ERROR UNDO GRABAR_DATOS, LEAVE ON STOP UNDO, LEAVE GRABAR_DATOS:
    FOR EACH tt-vtacdocu WHERE tt-vtacdocu.libre_c02 = 'ASIGNAR' NO-LOCK:

        FIND FIRST Vtacdocu WHERE Vtacdocu.codcia = s-codcia
            AND Vtacdocu.coddiv = tt-vtacdocu.coddiv
            AND Vtacdocu.codped = tt-vtacdocu.codped
            AND Vtacdocu.nroped = tt-vtacdocu.nroped
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Vtacdocu THEN DO:
            x-Error = "NO se pudo bloquear la HPK " + tt-vtacdocu.codped + " " + tt-vtacdocu.nroped.
            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
        END.
        ASSIGN 
            Vtacdocu.usrsac = x-dni
            Vtacdocu.fecsac = TODAY
            Vtacdocu.horsac = STRING(TIME,'HH:MM:SS')
            Vtacdocu.ubigeo[4] = x-dni
            Vtacdocu.usrsacasign   = s-user-id
            Vtacdocu.fchinicio = NOW
            Vtacdocu.usuarioinicio = s-user-id
            Vtacdocu.FlgSit    = "TI"   /*"TP"     /* En Proceso de Picking (APOD) */            */
            Vtacdocu.items     = 0
            Vtacdocu.peso      = 0
            Vtacdocu.volumen   = 0
        .
        FIND FIRST ttOrdenes WHERE ttOrdenes.tcoddoc = tt-vtacdocu.codped AND
                                    ttOrdenes.tnrodoc = tt-vtacdocu.nroped NO-ERROR.
        IF AVAILABLE ttOrdenes THEN DO:
            ASSIGN  Vtacdocu.items     = ttordenes.titems
                    Vtacdocu.peso      = ttordenes.tpeso
                    Vtacdocu.volumen   = ttordenes.tvolumen
            .
        END.
    END.
    x-Error = "OK".
END.

RUN refrescar.

SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cantidades-de-la-orden W-Win 
PROCEDURE cantidades-de-la-orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE OUTPUT PARAMETER pItems AS INT.
DEFINE OUTPUT PARAMETER pImporte AS DEC.
DEFINE OUTPUT PARAMETER pPeso AS DEC.
DEFINE OUTPUT PARAMETER pVolumen AS DEC.

pItems = 0.
pImporte = 0.
pPeso = 0.
pVolumen = 0.
FOR EACH VtaDDocu OF tt-VtaCDocu NO-LOCK,
        FIRST almmmatg OF VtaDDocu NO-LOCK:
    pItems = pItems + 1.
    pImporte = pImporte + VtaDDocu.implin.
    pPeso = pPeso + ((VtaDDocu.canped * VtaDDocu.factor) * Almmmatg.pesmat).
    pVolumen = pVolumen + ((VtaDDocu.canped * VtaDDocu.factor) * Almmmatg.libre_d02).
END.

pVolumen = (pVolumen / 1000000).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cantidades-del-acumulativo W-Win 
PROCEDURE cantidades-del-acumulativo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE OUTPUT PARAMETER pItems AS INT.
DEFINE OUTPUT PARAMETER pImporte AS DEC.
DEFINE OUTPUT PARAMETER pPeso AS DEC.
DEFINE OUTPUT PARAMETER pVolumen AS DEC.

DEFINE VAR x-llave AS CHAR.

x-llave = pCodDoc + "," + pNroDoc.

pItems = 0.
pImporte = 0.
pPeso = 0.
pVolumen = 0.
FOR EACH almddocu WHERE almddocu.codcia = s-codcia AND almddocu.codllave = x-llave NO-LOCK:
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                almmmatg.codmat = almddocu.codigo NO-LOCK NO-ERROR.
    IF AVAILABLE almmmatg THEN DO:
        pItems = pItems + 1.
        pImporte = pImporte + 0.
        pPeso = pPeso + ((almddocu.libre_d01 * almddocu.libre_d02) * Almmmatg.pesmat).
        pVolumen = pVolumen + ((almddocu.libre_d01 * almddocu.libre_d02) * Almmmatg.libre_d02).
    END.
END.

pVolumen = (pVolumen / 1000000).


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
  DISPLAY FILL-IN-FchEnt-1 FILL-IN-FchEnt-2 COMBO-BOX-Tipo COMBO-BOX-Sector 
          FILL-IN-Nombre-Picador FILL-IN-Items FILL-IN-Peso 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 FILL-IN-FchEnt-1 FILL-IN-FchEnt-2 BUTTON-FILTRAR COMBO-BOX-Tipo 
         COMBO-BOX-Sector BUTTON-3 FILL-IN-Nombre-Picador BUTTON-4 BROWSE-3 
         BROWSE-5 BROWSE-6 
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

  DO WITH FRAME {&FRAME-NAME}:
      fill-in-fchent-1:SCREEN-VALUE = STRING(TODAY - 7, "99/99/9999").
      fill-in-fchent-2:SCREEN-VALUE = STRING(TODAY + 7, "99/99/9999").
      FOR EACH AlmtZona NO-LOCK WHERE AlmtZona.CodCia = s-CodCia AND
          AlmtZona.CodAlm = s-CodAlm:
          COMBO-BOX-Sector:ADD-LAST(AlmtZona.CodZona).
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preparo-ordenes W-Win 
PROCEDURE preparo-ordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE ttOrdenes.

DEFINE VAR x-items AS INT.
DEFINE VAR x-Importe AS DEC.
DEFINE VAR x-peso AS DEC.
DEFINE VAR x-volumen AS DEC.

/* Preparo las Ordenes */
FOR EACH tt-vtacdocu WHERE tt-vtacdocu.libre_c02 = 'ASIGNAR' NO-LOCK:
    x-items = 0.
    x-importe = 0.
    x-peso = 0.
    x-volumen = 0.
    IF tt-vtacdocu.codter = "ACUMULATIVO" THEN DO:
        RUN cantidades-del-acumulativo(INPUT tt-vtacdocu.codped, 
                                    INPUT tt-vtacdocu.nroped, 
                                   OUTPUT x-items, OUTPUT x-importe,
                                   OUTPUT x-peso, OUTPUT x-volumen).
    END.
    IF (tt-vtacdocu.codter = "RACK") OR (tt-vtacdocu.codter = "ESTANTERIA") THEN DO:
        RUN cantidades-de-la-orden(INPUT tt-vtacdocu.codped, 
                                    INPUT tt-vtacdocu.nroped, 
                                   OUTPUT x-items, OUTPUT x-importe,
                                   OUTPUT x-peso, OUTPUT x-volumen).
    END.
    CREATE ttOrdenes.
        ASSIGN ttOrdenes.tcoddoc = tt-vtacdocu.codped
                ttOrdenes.tnrodoc = tt-vtacdocu.nroped
                ttOrdenes.titems = x-items
                ttOrdenes.tpeso = x-peso
                ttOrdenes.tvolumen = x-volumen
    .
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refrescar W-Win 
PROCEDURE refrescar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-rowid AS ROWID.
DEFINE VAR x-segundos-Chequeador AS DEC.
DEFINE VAR x-segundos-Pickeador AS DEC.
DEFINE VAR x-mensaje AS CHAR.

DEFINE VAR x-hora AS INT.
DEFINE VAR x-minuto AS INT.
DEFINE VAR x-segundo AS INT.
DEFINE VAR x-tiempo AS CHAR.

DEFINE VAR x-filer AS INT.

x-segundos-phk-disponibles-picador = 0.
x-segundos-phk-disponibles-chequeador = 0.

x-segundos-phk-seleccionados-picador = 0.
x-segundos-phk-seleccionados-chequeador = 0.

DEFINE VAR x-tiempo-procesado AS CHAR.

x-tiempo-procesado = STRING(TIME,"HH:MM:SS").

EMPTY TEMP-TABLE tt-vtacdocu.
EMPTY TEMP-TABLE tt-rut-pers-turno.
EMPTY TEMP-TABLE t-vtacdocu.
FOR EACH Vtacdocu NO-LOCK WHERE vtacdocu.codcia = s-codcia AND 
    /*vtacdocu.coddiv = s-coddiv AND*/
    vtacdocu.divdes = s-coddiv AND
    vtacdocu.flgest = 'P' AND 
    Vtacdocu.FlgSit = "T" AND
    vtacdocu.codped = 'HPK':
    /* Para control */
    CREATE t-vtacdocu.
    BUFFER-COPY Vtacdocu TO t-vtacdocu.

    IF Vtacdocu.FlgSit <> "T" THEN NEXT.
    IF COMBO-BOX-Tipo <> 'TODOS' AND Vtacdocu.CodTer <> COMBO-BOX-Tipo THEN NEXT.
    IF COMBO-BOX-Sector <> 'TODOS' AND Vtacdocu.ZonaPickeo <> COMBO-BOX-Sector THEN NEXT.
    IF FILL-IN-FchEnt-1 <> ? AND Vtacdocu.FchEnt < FILL-IN-FchEnt-1 THEN NEXT.
    IF FILL-IN-FchEnt-2 <> ? AND Vtacdocu.FchEnt > FILL-IN-FchEnt-2 THEN NEXT.

    CREATE tt-vtacdocu.
    BUFFER-COPY vtacdocu 
        TO tt-vtacdocu
        ASSIGN 
        tt-vtacdocu.observa = ""
        tt-vtacdocu.libre_c01 = ""
        tt-vtacdocu.libre_c02 = "".

    x-rowid = ROWID(vtacdocu).
    x-segundos-chequeador = 0.
    x-segundos-pickeador = 0.
    x-mensaje = "".
    tt-vtacdocu.importe[1] = x-segundos-pickeador.
    tt-vtacdocu.importe[2] = x-segundos-chequeador.
    x-segundos-phk-disponibles-picador = x-segundos-phk-disponibles-picador + x-segundos-pickeador.
    x-segundos-phk-disponibles-chequeador = x-segundos-phk-disponibles-chequeador + x-segundos-chequeador.

    IF TRUE <> (x-mensaje > '') THEN DO:
        x-tiempo = "".
        x-hora = TRUNCATE((x-segundos-pickeador / 3600),0).
        x-minuto = TRUNCATE(((x-segundos-pickeador - (x-hora *  3600 )) / 60),0).
        x-segundo = x-segundos-pickeador - (( x-hora * 3600) + (x-minuto * 60)).
        IF x-hora > 0 THEN x-tiempo = STRING(x-hora) + " hora(s)".
        IF x-minuto > 0 THEN DO:
            IF x-tiempo <> "" THEN x-tiempo = x-tiempo + " con ".
            x-tiempo = x-tiempo + STRING(x-minuto) + " minuto(s)".
        END.
        IF x-tiempo <> "" THEN x-tiempo = x-tiempo + " y ".
        x-tiempo = x-tiempo + STRING(x-segundo) + " segundo(s)".
        ASSIGN tt-vtacdocu.libre_c01 = x-tiempo.
    END.
    ELSE ASSIGN tt-vtacdocu.libre_c01 = "Sin Configuracion".
END.

/* Turnos */
DEFINE VAR x-dia AS CHAR.
DEFINE VAR x-dia-de-la-semana AS INT.
DEFINE VAR x-nombre-picador AS CHAR.
DEFINE VAR x-origen-picador AS CHAR.

x-dia-de-la-semana = WEEKDAY(TODAY).
IF x-dia-de-la-semana = 1 THEN x-dia = "Domingo".
IF x-dia-de-la-semana = 2 THEN x-dia = "Lunes".
IF x-dia-de-la-semana = 3 THEN x-dia = "Martes".
IF x-dia-de-la-semana = 4 THEN x-dia = "Miercoles".
IF x-dia-de-la-semana = 5 THEN x-dia = "Jueves".
IF x-dia-de-la-semana = 6 THEN x-dia = "Viernes".
IF x-dia-de-la-semana = 7 THEN x-dia = "Sabado".

/*DEF VAR x-FlgSit AS CHAR INIT 'TI,TP,TX' NO-UNDO.*/
DEF VAR x-FlgSit AS CHAR INIT 'TI,TP' NO-UNDO.
DEF VAR k AS INT NO-UNDO.
FOR EACH rut-pers-turno WHERE rut-pers-turno.codcia = s-codcia AND
    rut-pers-turno.coddiv = s-coddiv AND
    rut-pers-turno.fchasignada = TODAY AND 
    rut-pers-turno.rol = 'PICADOR' NO-LOCK:

    CREATE tt-rut-pers-turno.
    BUFFER-COPY rut-pers-turno TO tt-rut-pers-turno.
    ASSIGN 
        tt-rut-pers-turno.hinicio = ""
        tt-rut-pers-turno.htermino = ""
        tt-rut-pers-turno.hefectivas = 0
        tt-rut-pers-turno.nombre-picador = ""
        tt-rut-pers-turno.origen-picador = ""
        tt-rut-pers-turno.peso = 0.

    /* Buscar Turno */
    FIND FIRST rut-turnos WHERE rut-turnos.codcia = s-codcia AND
                                rut-turnos.coddiv = s-coddiv AND
                                rut-turnos.turno = rut-pers-turno.turno AND 
                                rut-turnos.dia = x-dia NO-LOCK NO-ERROR.
    IF AVAILABLE rut-turnos THEN DO:
        ASSIGN 
            tt-rut-pers-turno.hinicio = rut-turnos.horainicio
            tt-rut-pers-turno.htermino = rut-turnos.horafin
            tt-rut-pers-turno.hefectivas = 0.
    END.
    /* */
    RUN logis/p-busca-por-dni(INPUT tt-rut-pers-turno.dni, 
                              OUTPUT x-nombre-picador,
                              OUTPUT x-origen-picador).
    ASSIGN 
        tt-rut-pers-turno.nombre-picador = x-nombre-picador
        tt-rut-pers-turno.origen-picador = x-origen-picador.

    /* HPK e Items */
    ASSIGN
        tt-rut-pers-turno.hpks = 0
        tt-rut-pers-turno.items = 0.
    DO k = 1 TO NUM-ENTRIES(x-FlgSit):
        FOR EACH x-vtacdocu NO-LOCK WHERE x-vtacdocu.codcia = s-codcia AND
            x-vtacdocu.divdes = s-coddiv AND
            x-vtacdocu.usrsac = tt-rut-pers-turno.dni AND
            DATE(x-vtacdocu.fchinicio) >= ADD-INTERVAL(TODAY, -3, 'days'):
            IF NOT ( x-vtacdocu.flgest = 'P' AND
                     x-vtacdocu.codped = 'HPK' AND         
                     x-Vtacdocu.FlgSit = ENTRY(k, x-FlgSit) )
                THEN NEXT.
            ASSIGN
                tt-rut-pers-turno.hpks = tt-rut-pers-turno.hpks + 1
                tt-rut-pers-turno.items = tt-rut-pers-turno.items + x-vtacdocu.items
                tt-rut-pers-turno.peso = tt-rut-pers-turno.peso + x-vtacdocu.peso.
        END.
/*         FOR EACH x-vtacdocu NO-LOCK WHERE x-vtacdocu.codcia = s-codcia AND            */
/*             x-vtacdocu.coddiv = s-coddiv AND                                          */
/*             x-vtacdocu.flgest = 'P' and                                               */
/*             x-vtacdocu.codped = 'HPK' AND                                             */
/*             x-Vtacdocu.FlgSit = ENTRY(k, x-FlgSit) AND                                */
/*             x-vtacdocu.usrsac = tt-rut-pers-turno.dni:                                */
/*             ASSIGN                                                                    */
/*                 tt-rut-pers-turno.hpks = tt-rut-pers-turno.hpks + 1                   */
/*                 tt-rut-pers-turno.items = tt-rut-pers-turno.items + x-vtacdocu.items. */
/*         END.                                                                          */
    END.
END.

{&open-query-browse-3}
{&open-query-browse-5}
{&open-query-browse-6}

RUN refrescar-totales.

x-tiempo-procesado = x-tiempo-procesado + "  -  " + STRING(TIME,"HH:MM:SS").
IF USERID("DICTDB") = "MASTER" THEN DO:
    MESSAGE x-tiempo-procesado.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refrescar-totales W-Win 
PROCEDURE refrescar-totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-hora AS INT.
DEFINE VAR x-minuto AS INT.
DEFINE VAR x-segundo AS INT.
DEFINE VAR x-tiempo AS CHAR.

/* Picador - disponibles */
x-tiempo = "".

x-hora = TRUNCATE(x-segundos-phk-disponibles-picador / 3600,0).
x-minuto = TRUNCATE((x-segundos-phk-disponibles-picador - (x-hora * 3600) ) / 60,0).
x-segundo = x-segundos-phk-disponibles-picador - ( x-hora * 3600 + x-minuto * 60).

IF x-hora > 0 THEN x-tiempo = STRING(x-hora) + " hora(s)".
IF x-minuto > 0 THEN DO:
    IF x-tiempo <> "" THEN x-tiempo = x-tiempo + " con ".
    x-tiempo = x-tiempo + STRING(x-minuto) + " minuto(s)".
END.
IF x-tiempo <> "" THEN x-tiempo = x-tiempo + " y ".
x-tiempo = x-tiempo + STRING(x-segundo) + " segundo(s)".

fill-in-picador:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-tiempo.

/* Picador - seleccioados */
x-tiempo = "".

x-hora = truncate(x-segundos-phk-seleccionados-picador / 3600,0).
x-minuto = TRUNCATE((x-segundos-phk-seleccionados-picador - (x-hora * 3600) ) / 60,0).
x-segundo = x-segundos-phk-seleccionados-picador - ( x-hora * 3600 + x-minuto * 60).

IF x-hora > 0 THEN x-tiempo = STRING(x-hora) + " hora(s)".
IF x-minuto > 0 THEN DO:
    IF x-tiempo <> "" THEN x-tiempo = x-tiempo + " con ".
    x-tiempo = x-tiempo + STRING(x-minuto) + " minuto(s)".
END.
IF x-tiempo <> "" THEN x-tiempo = x-tiempo + " y ".
x-tiempo = x-tiempo + STRING(x-segundo) + " segundo(s)".

fill-in-picador2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-tiempo.

/* Chequeador - disponibles */
x-tiempo = "".

x-hora = truncate(x-segundos-phk-disponibles-chequeador / 3600,0).
x-minuto = TRUNCATE((x-segundos-phk-disponibles-chequeador - (x-hora * 3600) ) / 60,0).
x-segundo = x-segundos-phk-disponibles-chequeador - ( x-hora * 3600 + x-minuto * 60).

IF x-hora > 0 THEN x-tiempo = STRING(x-hora) + " hora(s)".
IF x-minuto > 0 THEN DO:
    IF x-tiempo <> "" THEN x-tiempo = x-tiempo + " con ".
    x-tiempo = x-tiempo + STRING(x-minuto) + " minuto(s)".
END.
IF x-tiempo <> "" THEN x-tiempo = x-tiempo + " y ".
x-tiempo = x-tiempo + STRING(x-segundo) + " segundo(s)".

fill-in-chequeador:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-tiempo.

/* Picador - seleccioados */
x-tiempo = "".

x-hora = truncate(x-segundos-phk-seleccionados-chequeador / 3600,0).
x-minuto = TRUNCATE((x-segundos-phk-seleccionados-chequeador - (x-hora * 3600) ) / 60,0).
x-segundo = x-segundos-phk-seleccionados-chequeador - ( x-hora * 3600 + x-minuto * 60).

IF x-hora > 0 THEN x-tiempo = STRING(x-hora) + " hora(s)".
IF x-minuto > 0 THEN DO:
    IF x-tiempo <> "" THEN x-tiempo = x-tiempo + " con ".
    x-tiempo = x-tiempo + STRING(x-minuto) + " minuto(s)".
END.
IF x-tiempo <> "" THEN x-tiempo = x-tiempo + " y ".
x-tiempo = x-tiempo + STRING(x-segundo) + " segundo(s)".

fill-in-chequeador2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-tiempo.

DEF BUFFER bt-Vtacdocu FOR tt-Vtacdocu.
FILL-IN-Items = 0.
FILL-IN-Peso = 0.
FOR EACH bt-VtaCDocu NO-LOCK WHERE bt-VtaCDocu.Libre_c02 = "ASIGNAR":
    FILL-IN-Items = FILL-IN-Items + bt-VtaCDocu.Items.
    FILL-IN-Peso  = FILL-IN-Peso  + bt-VtaCDocu.Peso.
END.
DISPLAY FILL-IN-Items FILL-IN-Peso WITH FRAME {&FRAME-NAME}.

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
  {src/adm/template/snd-list.i "tt-VtaCDocu"}
  {src/adm/template/snd-list.i "tt-rut-pers-turno"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-total-hpk-asig W-Win 
FUNCTION f-total-hpk-asig RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEF VAR x-col-total-hpk-asig AS INT.

    x-col-total-hpk-asig = 0.
    
    FOR EACH x-vtacdocu USE-INDEX llave07 WHERE x-vtacdocu.codcia = s-codcia AND
        x-vtacdocu.coddiv = s-coddiv AND
        x-vtacdocu.flgest = 'P' and 
        x-vtacdocu.codped = 'HPK' AND         
        /*LOOKUP(x-vtacdocu.flgsit, 'TI,TP,TX') > 0 AND*/
        CAN-DO("TI,TP,TX", x-Vtacdocu.FlgSit) AND
        x-vtacdocu.usrsac = tt-rut-pers-turno.dni NO-LOCK:
        x-col-total-hpk-asig = x-col-total-hpk-asig + 1.
    END.
    
/*     FOR EACH t-vtacdocu USE-INDEX llave07 WHERE LOOKUP(t-vtacdocu.flgsit, 'TI,TP,TX') > 0 AND */
/*         t-vtacdocu.usrsac = tt-rut-pers-turno.dni NO-LOCK:                                    */
/*                                                                                               */
/*         x-col-total-hpk-asig = x-col-total-hpk-asig + 1.                                      */
/*     END.                                                                                      */

    RETURN x-col-total-hpk-asig.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-total-item-asig W-Win 
FUNCTION f-total-item-asig RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEF VAR x-col-total-item-asig AS INT.

    x-col-total-item-asig = 0.
    
    FOR EACH x-vtacdocu USE-INDEX llave07 WHERE x-vtacdocu.codcia = s-codcia AND
        x-vtacdocu.coddiv = s-coddiv AND
        x-vtacdocu.flgest = 'P' and
        x-vtacdocu.codped = 'HPK' AND
        CAN-DO("TI,TP,TX", x-Vtacdocu.FlgSit) AND
        x-vtacdocu.usrsac = tt-rut-pers-turno.dni NO-LOCK:
        x-col-total-item-asig = x-col-total-item-asig + x-vtacdocu.items.
    END.

/*     FOR EACH t-vtacdocu WHERE LOOKUP(t-vtacdocu.flgsit, 'TI,TP,TX') > 0 AND */
/*         t-vtacdocu.usrsac = tt-rut-pers-turno.dni NO-LOCK /* ,              */
/*         EACH vtaddocu OF x-vtacdocu NO-LOCK */ :                            */
/*                                                                             */
/*         /*x-col-total-item-asig = x-col-total-item-asig + 1.*/              */
/*         x-col-total-item-asig = x-col-total-item-asig + t-vtacdocu.items.   */
/*     END.                                                                    */


    RETURN x-col-total-item-asig.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

