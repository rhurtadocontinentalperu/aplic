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
       fields total-asig as int.
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


DEFINE TEMP-TABLE ttOrdenes   
    FIELD   tcoddoc     AS  CHAR    FORMAT 'X(5)'
    FIELD   tnrodoc     AS  CHAR    FORMAT 'x(12)'
    FIELD   tcodref     AS  CHAR    FORMAT 'X(5)'
    FIELD   tnroref     AS  CHAR    FORMAT 'x(12)'
    FIELD   titems      AS  INT INIT 0
    FIELD   tpeso       AS  DEC INIT 0
    FIELD   tvolumen    AS  DEC INIT 0
.

DEFINE VAR x-col-total-hpk-asig AS INT.

DEFINE BUFFER x-vtacdocu FOR vtacdocu.

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
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 tt-VtaCDocu.CodPed ~
tt-VtaCDocu.NroPed tt-VtaCDocu.NroOri tt-VtaCDocu.FchPed tt-VtaCDocu.Hora ~
tt-VtaCDocu.CodTer tt-VtaCDocu.ZonaPickeo tt-VtaCDocu.Items ~
tt-VtaCDocu.Libre_c01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH tt-VtaCDocu ~
      WHERE tt-VtaCDocu.Libre_c02 = "" NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH tt-VtaCDocu ~
      WHERE tt-VtaCDocu.Libre_c02 = "" NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 tt-VtaCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 tt-VtaCDocu


/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 ~
tt-rut-pers-turno.nombre-picador @ x-nombre-picador-col ~
tt-rut-pers-turno.origen-picador @ x-origen-picador-col ~
tt-rut-pers-turno.rol tt-rut-pers-turno.turno ~
x-col-total-hpk-asig @ x-col-total-hpk-asig ~
tt-rut-pers-turno.hinicio @ x-hora-inicio-col ~
tt-rut-pers-turno.htermino @ x-hora-termino-col 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH tt-rut-pers-turno NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH tt-rut-pers-turno NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 tt-rut-pers-turno
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 tt-rut-pers-turno


/* Definitions for BROWSE BROWSE-6                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-6 tt-VtaCDocu.CodPed ~
tt-VtaCDocu.NroPed tt-VtaCDocu.NroOri tt-VtaCDocu.FchPed tt-VtaCDocu.Hora ~
tt-VtaCDocu.CodTer tt-VtaCDocu.ZonaPickeo tt-VtaCDocu.Items ~
tt-VtaCDocu.Libre_c01 
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
&Scoped-Define ENABLED-OBJECTS BUTTON-2 BUTTON-3 FILL-IN-desde ~
FILL-IN-hasta FILL-IN-phr BROWSE-5 BROWSE-3 BROWSE-6 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-pickeador-2 FILL-IN-desde ~
FILL-IN-hasta FILL-IN-phr FILL-IN-2 FILL-IN-picador FILL-IN-Items FILL-IN-3 ~
FILL-IN-chequeador FILL-IN-picador2 FILL-IN-chequeador2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 
     LABEL "Refrescar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-3 
     LABEL "Asignar HPK a picador" 
     SIZE 22 BY 1.12.

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

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Items AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Items" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-phr AS CHARACTER FORMAT "X(15)":U 
     LABEL "PHR" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-picador AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.29 BY 1
     BGCOLOR 15 FGCOLOR 9 FONT 11 NO-UNDO.

DEFINE VARIABLE FILL-IN-picador2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.14 BY 1
     BGCOLOR 15 FGCOLOR 9 FONT 11 NO-UNDO.

DEFINE VARIABLE FILL-IN-pickeador-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.43 BY 1
     BGCOLOR 15 FGCOLOR 4 FONT 9 NO-UNDO.

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
      tt-VtaCDocu.CodPed COLUMN-LABEL "Codi." FORMAT "x(3)":U
      tt-VtaCDocu.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U
            WIDTH 11.29
      tt-VtaCDocu.NroOri COLUMN-LABEL "PHR" FORMAT "x(15)":U WIDTH 9.29
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      tt-VtaCDocu.FchPed COLUMN-LABEL "Emision" FORMAT "99/99/9999":U
      tt-VtaCDocu.Hora FORMAT "X(5)":U WIDTH 5.72
      tt-VtaCDocu.CodTer COLUMN-LABEL "Tipo" FORMAT "x(15)":U WIDTH 12.29
      tt-VtaCDocu.ZonaPickeo COLUMN-LABEL "Sector" FORMAT "x(10)":U
            WIDTH 6.43
      tt-VtaCDocu.Items FORMAT ">>>,>>9":U
      tt-VtaCDocu.Libre_c01 COLUMN-LABEL "Tiempo" FORMAT "x(50)":U
            WIDTH 11.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 81.72 BY 16.96
         FONT 4
         TITLE "Ordenes disponibles para asignar" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      tt-rut-pers-turno.nombre-picador @ x-nombre-picador-col COLUMN-LABEL "Picador" FORMAT "x(50)":U
            WIDTH 24.29
      tt-rut-pers-turno.origen-picador @ x-origen-picador-col COLUMN-LABEL "Origen" FORMAT "x(15)":U
            WIDTH 7.43
      tt-rut-pers-turno.rol COLUMN-LABEL "ROL" FORMAT "x(15)":U
            WIDTH 8.72
      tt-rut-pers-turno.turno COLUMN-LABEL "TURNO" FORMAT "x(15)":U
            WIDTH 9.14
      x-col-total-hpk-asig @ x-col-total-hpk-asig COLUMN-LABEL "Cant.Asig" FORMAT ">>>,>>9":U
            COLUMN-BGCOLOR 14
      tt-rut-pers-turno.hinicio @ x-hora-inicio-col COLUMN-LABEL "Inicio"
            WIDTH 9.43
      tt-rut-pers-turno.htermino @ x-hora-termino-col COLUMN-LABEL "Termino"
            WIDTH 7.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82.86 BY 10.35
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
      tt-VtaCDocu.Libre_c01 COLUMN-LABEL "Tiempo" FORMAT "x(50)":U
            WIDTH 12.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 81.72 BY 7.77
         FONT 4
         TITLE "Ordenes seleccionadas para la asignacion" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-2 AT ROW 1.08 COL 68.29 WIDGET-ID 6
     BUTTON-3 AT ROW 1.08 COL 94 WIDGET-ID 22
     FILL-IN-pickeador-2 AT ROW 1.12 COL 129 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     FILL-IN-desde AT ROW 1.15 COL 29 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-hasta AT ROW 1.15 COL 49.72 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-phr AT ROW 1.19 COL 8 COLON-ALIGNED WIDGET-ID 28
     BROWSE-5 AT ROW 2.23 COL 85.14 WIDGET-ID 300
     BROWSE-3 AT ROW 2.31 COL 2.29 WIDGET-ID 200
     BROWSE-6 AT ROW 12.65 COL 85.43 WIDGET-ID 400
     FILL-IN-2 AT ROW 19.42 COL 6.29 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     FILL-IN-picador AT ROW 19.42 COL 40.72 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     FILL-IN-Items AT ROW 20.38 COL 134 COLON-ALIGNED WIDGET-ID 24
     FILL-IN-3 AT ROW 20.46 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     FILL-IN-chequeador AT ROW 20.46 COL 40.72 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-picador2 AT ROW 21.46 COL 85 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     FILL-IN-chequeador2 AT ROW 21.46 COL 126 COLON-ALIGNED NO-LABEL WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 168 BY 21.65
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
         TITLE              = "Asignacion de PRE-PICKING a Picking"
         HEIGHT             = 21.65
         WIDTH              = 168
         MAX-HEIGHT         = 22.58
         MAX-WIDTH          = 174.29
         VIRTUAL-HEIGHT     = 22.58
         VIRTUAL-WIDTH      = 174.29
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
/* BROWSE-TAB BROWSE-5 FILL-IN-phr F-Main */
/* BROWSE-TAB BROWSE-3 BROWSE-5 F-Main */
/* BROWSE-TAB BROWSE-6 BROWSE-3 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-chequeador IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-chequeador2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Items IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-picador IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-picador2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-pickeador-2 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.tt-VtaCDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "Temp-Tables.tt-VtaCDocu.Libre_c02 = """""
     _FldNameList[1]   > Temp-Tables.tt-VtaCDocu.CodPed
"tt-VtaCDocu.CodPed" "Codi." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-VtaCDocu.NroPed
"tt-VtaCDocu.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "11.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-VtaCDocu.NroOri
"tt-VtaCDocu.NroOri" "PHR" ? "character" 11 0 ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-VtaCDocu.FchPed
"tt-VtaCDocu.FchPed" "Emision" "99/99/9999" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-VtaCDocu.Hora
"tt-VtaCDocu.Hora" ? ? "character" ? ? ? ? ? ? no ? no no "5.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-VtaCDocu.CodTer
"tt-VtaCDocu.CodTer" "Tipo" "x(15)" "character" ? ? ? ? ? ? no ? no no "12.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-VtaCDocu.ZonaPickeo
"tt-VtaCDocu.ZonaPickeo" "Sector" ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = Temp-Tables.tt-VtaCDocu.Items
     _FldNameList[9]   > Temp-Tables.tt-VtaCDocu.Libre_c01
"tt-VtaCDocu.Libre_c01" "Tiempo" "x(50)" "character" ? ? ? ? ? ? no ? no no "11.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.tt-rut-pers-turno"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"tt-rut-pers-turno.nombre-picador @ x-nombre-picador-col" "Picador" "x(50)" ? ? ? ? ? ? ? no ? no no "24.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"tt-rut-pers-turno.origen-picador @ x-origen-picador-col" "Origen" "x(15)" ? ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-rut-pers-turno.rol
"rol" "ROL" ? "character" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-rut-pers-turno.turno
"turno" "TURNO" ? "character" ? ? ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"x-col-total-hpk-asig @ x-col-total-hpk-asig" "Cant.Asig" ">>>,>>9" ? 14 ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"tt-rut-pers-turno.hinicio @ x-hora-inicio-col" "Inicio" ? ? ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"tt-rut-pers-turno.htermino @ x-hora-termino-col" "Termino" ? ? ? ? ? ? ? ? no ? no no "7.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
     _FldNameList[9]   > Temp-Tables.tt-VtaCDocu.Libre_c01
"tt-VtaCDocu.Libre_c01" "Tiempo" "x(50)" "character" ? ? ? ? ? ? no ? no no "12.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Asignacion de PRE-PICKING a Picking */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Asignacion de PRE-PICKING a Picking */
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
ON MOUSE-SELECT-DBLCLICK OF BROWSE-3 IN FRAME F-Main /* Ordenes disponibles para asignar */
DO:
    DEFINE VAR x-rows-seleccionados AS INT.
    x-rows-seleccionados = browse-3:NUM-SELECTED-ROWS.  
    IF x-rows-seleccionados < 1 THEN DO:
        MESSAGE "Seleccione Registro, por favor!!" VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.

    IF tt-vtacdocu.libre_c01 = "Sin Configuracion" THEN DO:
        MESSAGE "Seleccione Registro que tenga tiempo configurado, por favor!!" VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.

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


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Refrescar */
DO:

  ASSIGN fill-in-phr.

  RUN refrescar.
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


&Scoped-define BROWSE-NAME BROWSE-3
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}


ON ROW-DISPLAY OF browse-5
DO:
    x-col-total-hpk-asig = 0.

    FOR EACH x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                                x-vtacdocu.codped = 'HPK' AND 
                                x-vtacdocu.flgest = 'P' and x-vtacdocu.flgsit = 'TP' AND
                                x-vtacdocu.usrsac = tt-rut-pers-turno.dni NO-LOCK:
        x-col-total-hpk-asig = x-col-total-hpk-asig + 1.
    END.

    
END.

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
            Vtacdocu.FlgSit    = "TP"     /* En Proceso de Picking (APOD) */            
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
  DISPLAY FILL-IN-pickeador-2 FILL-IN-desde FILL-IN-hasta FILL-IN-phr FILL-IN-2 
          FILL-IN-picador FILL-IN-Items FILL-IN-3 FILL-IN-chequeador 
          FILL-IN-picador2 FILL-IN-chequeador2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-2 BUTTON-3 FILL-IN-desde FILL-IN-hasta FILL-IN-phr BROWSE-5 
         BROWSE-3 BROWSE-6 
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
      fill-in-desde:SCREEN-VALUE = STRING(TODAY - 15,"99/99/9999").
      fill-in-hasta:SCREEN-VALUE = STRING(TODAY ,"99/99/9999").
  END.

  RUN refrescar.

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

EMPTY TEMP-TABLE tt-vtacdocu.
EMPTY TEMP-TABLE tt-rut-pers-turno.

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fill-in-desde fill-in-hasta.
END.

DEFINE VAR x-rowid AS ROWID.
DEFINE VAR x-segundos-Chequeador AS DEC.
DEFINE VAR x-segundos-Pickeador AS DEC.
/*
DEFINE VAR x-total-segundos-Chequeador AS DEC.
DEFINE VAR x-total-segundos-Pickeador AS DEC.
*/
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


SESSION:SET-WAIT-STATE("GENERAL").
FOR EACH vtacdocu WHERE vtacdocu.codcia = s-codcia AND 
                            vtacdocu.coddiv = s-coddiv AND
                            vtacdocu.codped = 'HPK' AND
                            (vtacdocu.fchped >= fill-in-desde AND vtacdocu.fchped <= fill-in-hasta) AND
                            (vtacdocu.flgest = 'P' AND vtacdocu.flgsit = 'T') AND 
                            (fill-in-phr = "" OR vtacdocu.nroori = fill-in-phr) NO-LOCK:

    CREATE tt-vtacdocu.
    BUFFER-COPY vtacdocu TO tt-vtacdocu.
      ASSIGN tt-Vtacdocu.items     = 0
                tt-Vtacdocu.peso      = 0
                tt-Vtacdocu.volumen   = 0
                tt-vtacdocu.observa = ""
                tt-vtacdocu.libre_c01 = ""
                tt-vtacdocu.libre_c02 = "".

      x-rowid = ROWID(vtacdocu).
      x-segundos-chequeador = 0.
      x-segundos-pickeador = 0.
      x-mensaje = "".

      FOR EACH Vtaddocu OF Vtacdocu NO-LOCK:
          tt-Vtacdocu.Items = tt-Vtacdocu.Items + 1.
      END.

      RUN logis/p-calc-time-hpk.r(INPUT x-rowid, INPUT "",
                                  OUTPUT x-segundos-pickeador, 
                                  OUTPUT x-segundos-chequeador,
                                  OUTPUT x-mensaje).
      
      /*MESSAGE x-mensaje.*/
      /*
      IF x-mensaje <> "" THEN DO:
          /* Temporal */
          x-filer = RANDOM(1,10).
          IF (x-filer MODULO 2) = 0  THEN DO:
                x-filer = RANDOM(1,9999).
                x-segundos-pickeador = x-filer.
                x-filer = RANDOM(1,9999).
                x-segundos-chequeador = x-filer.
                x-mensaje = "".
          END.
      END.
      */
      ASSIGN tt-vtacdocu.importe[1] = x-segundos-pickeador.
      tt-vtacdocu.importe[2] = x-segundos-chequeador.

      x-segundos-phk-disponibles-picador = x-segundos-phk-disponibles-picador + x-segundos-pickeador.
      x-segundos-phk-disponibles-chequeador = x-segundos-phk-disponibles-chequeador + x-segundos-chequeador.
              
      IF x-mensaje = "" THEN DO:
            /*
            x-total-segundos-pickeador = x-total-segundos-pickeador + x-segundos-pickeador.
            x-total-segundos-chequeador = x-total-segundos-chequeador + x-segundos-chequeador.
            */
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
/*
hor=num/3600;
        min=(num-(3600*hor))/60;
        seg=num-((hor*3600)+(min*60));
*/

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

FOR EACH rut-pers-turno WHERE rut-pers-turno.codcia = s-codcia AND
                                rut-pers-turno.coddiv = s-coddiv AND
                                rut-pers-turno.fchasignada = TODAY AND 
                                rut-pers-turno.rol = 'PICADOR' NO-LOCK:

    CREATE tt-rut-pers-turno.
        BUFFER-COPY rut-pers-turno TO tt-rut-pers-turno.
        ASSIGN tt-rut-pers-turno.hinicio = ""
                tt-rut-pers-turno.htermino = ""
                tt-rut-pers-turno.hefectivas = 0
                tt-rut-pers-turno.nombre-picador = ""
                tt-rut-pers-turno.origen-picador = "".
    /* Buscar Turno */
    FIND FIRST rut-turnos WHERE rut-turnos.codcia = s-codcia AND
                                rut-turnos.coddiv = s-coddiv AND
                                rut-turnos.turno = rut-pers-turno.turno AND 
                                rut-turnos.dia = x-dia NO-LOCK NO-ERROR.
    IF AVAILABLE rut-turnos THEN DO:
        ASSIGN tt-rut-pers-turno.hinicio = rut-turnos.horainicio
                tt-rut-pers-turno.htermino = rut-turnos.horafin
                tt-rut-pers-turno.hefectivas = 0.
    END.
    /* */
    RUN logis/p-busca-por-dni(INPUT tt-rut-pers-turno.dni, 
                              OUTPUT x-nombre-picador,
                              OUTPUT x-origen-picador).

    ASSIGN tt-rut-pers-turno.nombre-picador = x-nombre-picador
        tt-rut-pers-turno.origen-picador = x-origen-picador.

END.

SESSION:SET-WAIT-STATE("").

RUN refrescar-totales.

{&open-query-browse-3}
{&open-query-browse-5}
{&open-query-browse-6}

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
FOR EACH bt-VtaCDocu NO-LOCK WHERE bt-VtaCDocu.Libre_c02 = "ASIGNAR":
    FILL-IN-Items = FILL-IN-Items + bt-VtaCDocu.Items.
END.
DISPLAY FILL-IN-Items WITH FRAME {&FRAME-NAME}.

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

