&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE TEMP-TABLE ttCarga
    FIELDS  tlinea      AS  INT     FORMAT  '>>,>>9'    COLUMN-LABEL "LINEA"
    FIELDS  tmsgerr     AS  CHAR    FORMAT  'x(60)'     COLUMN-LABEL "INFO DE CARGA" INIT ""
    FIELDS  tdesmat     AS  CHAR    FORMAT  'x(60)'     COLUMN-LABEL "DESCRIPCION"
    FIELDS  tcodmar     AS  CHAR    FORMAT  'x(5)'      COLUMN-LABEL "MARCA"
    FIELDS  tcodfam     AS  CHAR    FORMAT  'x(4)'      COLUMN-LABEL "FAMILIA"
    FIELDS  tsubfam     AS  CHAR    FORMAT  'x(4)'      COLUMN-LABEL "SUBFAMILIA"
    FIELDS  tssubfam    AS  CHAR    FORMAT  'x(4)'      COLUMN-LABEL "SUBSUBFAMILIA"
    FIELDS  tchr__02    AS  CHAR    FORMAT  'x(1)'      COLUMN-LABEL "PROP!TERC"
    FIELDS  taftigv     AS  CHAR    FORMAT  'x(2)'      COLUMN-LABEL "AFECTO!IGV"
    FIELDS  tlicencia   AS  CHAR    FORMAT  'x(4)'      COLUMN-LABEL "LICENCIA"
    FIELDS  ttpomrg     AS  CHAR    FORMAT  'x(1)'      COLUMN-LABEL "MAY/MIN"
    FIELDS  tundbas     AS  CHAR    FORMAT  'x(4)'      COLUMN-LABEL "UND!BASE"
    FIELDS  tundcmp     AS  CHAR    FORMAT  'x(4)'      COLUMN-LABEL "UND!COMPRA"
    FIELDS  tundstk     AS  CHAR    FORMAT  'x(4)'      COLUMN-LABEL "UND!STOCK"
    FIELDS  tundA       AS  CHAR    FORMAT  'x(4)'      COLUMN-LABEL "MOSTR!A"
    FIELDS  tundB       AS  CHAR    FORMAT  'x(4)'      COLUMN-LABEL "MOSTR!B"
    FIELDS  tundC       AS  CHAR    FORMAT  'x(4)'      COLUMN-LABEL "MOSTR!C"
    FIELDS  tchr__01    AS  CHAR    FORMAT  'x(4)'      COLUMN-LABEL "OFICINA"
    FIELDS  tundalt1    AS  CHAR    FORMAT  'x(4)'      COLUMN-LABEL "AL POR!MENOR"
    FIELDS  tdec__03    AS  DEC     FORMAT  '->>,>>9'   COLUMN-LABEL "MIN.VTA!MAYOR" INIT 0
    FIELDS  tstkmin     AS  DEC     FORMAT  '->>,>>9'   COLUMN-LABEL "MIN.VTA!MINOR" INIT 0
    FIELDS  tcanemp     AS  DEC     FORMAT  '->>,>>9'   COLUMN-LABEL "EMPAQ!MASTER" INIT 0
    FIELDS  tstkrep     AS  DEC     FORMAT  '->>,>>9'   COLUMN-LABEL "EMPAQ!INNER" INIT 0
    FIELDS  tcodpr1     AS  CHAR    FORMAT  'x(11)'     COLUMN-LABEL "PROVEEDOR A"
    FIELDS  tcodpr2     AS  CHAR    FORMAT  'x(11)'     COLUMN-LABEL "PROVEEDOR B"
    FIELDS  tcodintpr1  AS  CHAR    FORMAT  'x(10)'     COLUMN-LABEL "COD.INTERN!PROV-A"
    FIELDS  tcoddigesa  AS  CHAR    FORMAT  'x(20)'     COLUMN-LABEL "DIGESA"
    FIELDS  tvtodigesa  AS  DATE                        COLUMN-LABEL "VCTO!DIGESA"
    FIELDS  tlargo      AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "LARGO cm" INIT 0
    FIELDS  tancho      AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "ANCHO cm" INIT 0
    FIELDS  talto       AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "ALTO cm" INIT 0
    FIELDS  tlibre_d02  AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "VOL cm3" INIT 0
    FIELDS  tpesmat     AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "PESO kg" INIT 0
    FIELDS  tcodbrr     AS  CHAR    FORMAT  'x(13)'          COLUMN-LABEL "EAN13"
    FIELDS  tlargoinner AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "LARGO cm!INNER1" INIT 0
    FIELDS  tanchoinner AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "ANCHO cm!INNER1" INIT 0
    FIELDS  taltoinner  AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "ALTO cm!INNER1" INIT 0
    FIELDS  tvolinner   AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "VOL cm!INNER1" INIT 0
    FIELDS  tpesoinner  AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "PESO cm!INNER1" INIT 0
    FIELDS  tbarras_1   AS  CHAR    FORMAT  'x(13)'   COLUMN-LABEL "EAN14-1"
    FIELDS  tequival_1  AS  DEC     FORMAT  '->>>,>>9'   COLUMN-LABEL "CANTIDAD" INIT 0
    FIELDS  tlargoinner2 AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "LARGO cm!INNER2" INIT 0
    FIELDS  tanchoinner2 AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "ANCHO cm!INNER2" INIT 0
    FIELDS  taltoinner2  AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "ALTO cm!INNER2" INIT 0
    FIELDS  tvolinner2   AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "VOL cm!INNER2" INIT 0
    FIELDS  tpesoinner2  AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "PESO cm!INNER2" INIT 0
    FIELDS  tbarras_2   AS  CHAR    FORMAT  'x(13)'   COLUMN-LABEL "EAN14-2"
    FIELDS  tequival_2  AS  DEC     FORMAT  '->>>,>>9'   COLUMN-LABEL "CANTIDAD" INIT 0
    FIELDS  tlargomaster AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "LARGO cm!MASTER" INIT 0
    FIELDS  tanchomaster AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "ANCHO cm!MASTER" INIT 0
    FIELDS  taltomaster  AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "ALTO cm!MASTER" INIT 0
    FIELDS  tvolmaster   AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "VOL cm!MASTER" INIT 0
    FIELDS  tpesomaster  AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "PESO cm!MASTER" INIT 0
    FIELDS  tbarras_3   AS  CHAR    FORMAT  'x(13)'   COLUMN-LABEL "EAN14-3"
    FIELDS  tequival_3  AS  DEC     FORMAT  '->>>,>>9'   COLUMN-LABEL "CANTIDAD" INIT 0
    FIELDS  tflgcomercial   AS  CHAR    FORMAT 'x(10)'  COLUMN-LABEL "FLAG COMERCIAL"
    FIELDS  tcatgconta  AS  CHAR    FORMAT  'x(5)'  COLUMN-LABEL "CATG. CONTABLE"
    FIELDS  tlargopallet AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "LARGO cm!Pallet" INIT 0
    FIELDS  tanchopallet AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "ANCHO cm!Pallet" INIT 0
    FIELDS  taltopallet  AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "ALTO cm!Pallet" INIT 0
    FIELDS  tvolpallet   AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "VOL cm!Pallet" INIT 0
    FIELDS  tpesopallet  AS  DEC     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "PESO cm!Pallet" INIT 0
    FIELDS  tbarras_4   AS  CHAR    FORMAT  'x(13)'   COLUMN-LABEL "EAN14-4"
    FIELDS  tequival_4  AS  DEC     FORMAT  '->>>,>>9'   COLUMN-LABEL "CANTIDAD" INIT 0

    FIELD tRequiereSerialNr AS CHAR FORMAT 'x(8)' COLUMN-LABEL '# DE SERIE?' INIT 'No'
    FIELD tRequiereDueDate AS CHAR FORMAT 'x(8)' COLUMN-LABEL 'FECHA DE VCTO.?' INIT 'No'
    .

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
&Scoped-define INTERNAL-TABLES ttCarga

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tlinea tmsgerr tdesmat tcodmar tcodfam tsubfam tssubfam tchr__02 taftigv tlicencia ttpomrg tundbas tundcmp tundstk tundA tundB tundC tchr__01 tundalt1 tdec__03 tstkmin tcanemp tstkrep tcodpr1 tcodpr2 tcodintpr1 tcoddigesa tvtodigesa tlargo tancho talto tlibre_d02 tpesmat tcodbrr tlargoinner tanchoinner taltoinner tvolinner tpesoinner tbarras_1 tequival_1 tlargoinner2 tanchoinner2 taltoinner2 tvolinner2 tpesoinner2 tbarras_2 tequival_2 tlargomaster tanchomaster taltomaster tvolmaster tpesomaster tbarras_3 tequival_3 tflgcomercial 'x(10)' tcatgconta 'x(5)' tlargopallet tanchopallet taltopallet tvolpallet tpesopallet tbarras_4 tequival_4 tRequiereSerialNr tRequiereDueDate   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2   
&Scoped-define SELF-NAME BROWSE-2
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH ttCarga
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY {&SELF-NAME} FOR EACH ttCarga.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 ttCarga
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 ttCarga


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 BUTTON-6 BUTTON-5 BUTTON-7 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-5 
     LABEL "..." 
     SIZE 4 BY .77.

DEFINE BUTTON BUTTON-6 
     LABEL "Grabar los Articulos" 
     SIZE 19 BY 1.12.

DEFINE BUTTON BUTTON-7 
     LABEL "Exportar a Excel" 
     SIZE 18 BY .96.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      ttCarga SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _FREEFORM
  QUERY BROWSE-2 DISPLAY
      tlinea          FORMAT  '>>,>>9'    COLUMN-LABEL "LINEA"
      tmsgerr         FORMAT  'x(60)'     COLUMN-LABEL "INFO DE CARGA":U WIDTH 30
      tdesmat         FORMAT  'x(60)'     COLUMN-LABEL "DESCRIPCION":U WIDTH 30
      tcodmar         FORMAT  'x(5)'      COLUMN-LABEL "MARCA":U WIDTH 8
      tcodfam         FORMAT  'x(4)'      COLUMN-LABEL "FAMILIA"
      tsubfam         FORMAT  'x(4)'      COLUMN-LABEL "SUB!FAMILIA"
      tssubfam        FORMAT  'x(4)'      COLUMN-LABEL "SUBSUB!FAMILIA"
      tchr__02        FORMAT  'x(1)'      COLUMN-LABEL "PROP!TERC"
      taftigv         FORMAT  'x(2)'      COLUMN-LABEL "AFECTO!IGV"
      tlicencia       FORMAT  'x(4)'      COLUMN-LABEL "LICENCIA"
      ttpomrg         FORMAT  'x(1)'      COLUMN-LABEL "MAYOR!MINOR"
      tundbas         FORMAT  'x(4)'      COLUMN-LABEL "UND!BASE"
      tundcmp         FORMAT  'x(4)'      COLUMN-LABEL "UND!COMPRA"
      tundstk         FORMAT  'x(4)'      COLUMN-LABEL "UND!STK"
      tundA           FORMAT  'x(4)'      COLUMN-LABEL "MOSTR!A"
      tundB           FORMAT  'x(4)'      COLUMN-LABEL "MOSTR!B"
      tundC           FORMAT  'x(4)'      COLUMN-LABEL "MOSTR!C"
      tchr__01        FORMAT  'x(4)'      COLUMN-LABEL "OFICINA"
      tundalt1        FORMAT  'x(4)'      COLUMN-LABEL "AL POR!MENOR"
      tdec__03        FORMAT  '->>,>>9'   COLUMN-LABEL "MIN.VTA!MAYOR"
      tstkmin         FORMAT  '->>,>>9'   COLUMN-LABEL "MIN.VTA!MINOR"
      tcanemp         FORMAT  '->>,>>9'   COLUMN-LABEL "EMPAQ!MASTER"
      tstkrep         FORMAT  '->>,>>9'   COLUMN-LABEL "EMPAQ!INNER"
      tcodpr1         FORMAT  'x(11)'     COLUMN-LABEL "PROVEEDOR!A"
      tcodpr2         FORMAT  'x(11)'     COLUMN-LABEL "PROVEEDOR!B"
      tcodintpr1      FORMAT  'x(10)'     COLUMN-LABEL "COD.INTERN!PROV-A"
      tcoddigesa      FORMAT  'x(20)'     COLUMN-LABEL "DIGESA"
      tvtodigesa      COLUMN-LABEL "VCTO!DIGESA"
      tlargo          FORMAT  '->>,>>9.9999'   COLUMN-LABEL "LARGO!  cm"
      tancho          FORMAT  '->>,>>9.9999'   COLUMN-LABEL "ANCHO!  cm"
      talto           FORMAT  '->>,>>9.9999'   COLUMN-LABEL "ALTO!  cm"
      tlibre_d02      FORMAT  '->,>>>,>>9.9999'   COLUMN-LABEL "VOL!  cm3"
      tpesmat         FORMAT  '->>,>>9.9999'   COLUMN-LABEL "PESO!  Kg"
      tcodbrr         FORMAT  'x(13)'          COLUMN-LABEL "EAN13":U WIDTH 12
      tlargoinner     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "LARGO cm!INNER1"
      tanchoinner     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "ANCHO cm!INNER1"
      taltoinner      FORMAT  '->>,>>9.9999'   COLUMN-LABEL "ALTO cm!INNER1"
      tvolinner       FORMAT  '->,>>>,>>9.9999'   COLUMN-LABEL "VOL cm!INNER1"
      tpesoinner      FORMAT  '->>,>>9.9999'   COLUMN-LABEL "PESO Kg!INNER1"
      tbarras_1       FORMAT  'x(13)'   COLUMN-LABEL "EAN14-1":U WIDTH 12
      tequival_1      FORMAT  '->>>,>>9'   COLUMN-LABEL "CANTIDAD"
      tlargoinner2    FORMAT  '->>,>>9.9999'   COLUMN-LABEL "LARGO cm!INNER2"
      tanchoinner2    FORMAT  '->>,>>9.9999'   COLUMN-LABEL "ANCHO cm!INNER2"
      taltoinner2     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "ALTO cm!INNER2"
      tvolinner2      FORMAT  '->,>>>,>>9.9999'   COLUMN-LABEL "VOL cm!INNER2"
      tpesoinner2     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "PESO Kg!INNER2"
      tbarras_2       FORMAT  'x(13)'   COLUMN-LABEL "EAN14-2":U WIDTH 12
      tequival_2      FORMAT  '->>>,>>9'   COLUMN-LABEL "CANTIDAD"
      tlargomaster    FORMAT  '->>,>>9.9999'   COLUMN-LABEL "LARGO cm!MASTER"
      tanchomaster    FORMAT  '->>,>>9.9999'   COLUMN-LABEL "ANCHO cm!MASTER"
      taltomaster     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "ALTO cm!MASTER"
      tvolmaster      FORMAT  '->,>>>,>>9.9999'   COLUMN-LABEL "VOL cm!MASTER"
      tpesomaster     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "PESO Kg!MASTER"
      tbarras_3       FORMAT  'x(13)'   COLUMN-LABEL "EAN14-3":U WIDTH 12
      tequival_3      FORMAT  '->>>,>>9'   COLUMN-LABEL "CANTIDAD"
      tflgcomercial   FORMAT    'x(10)'     COLUMN-LABEL "FLAG COMERCIAL"
      tcatgconta      FORMAT    'x(5)'      COLUMN-LABEL "CATG CONTABLE"
      tlargopallet    FORMAT  '->>,>>9.9999'   COLUMN-LABEL "LARGO cm!PALLET"
      tanchopallet    FORMAT  '->>,>>9.9999'   COLUMN-LABEL "ANCHO cm!PALLET"
      taltopallet     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "ALTO cm!PALLET"
      tvolpallet      FORMAT  '->,>>>,>>9.9999'   COLUMN-LABEL "VOL cm!PALLET":U WIDTH 12
      tpesopallet     FORMAT  '->>,>>9.9999'   COLUMN-LABEL "PESO Kg!PALLET"
      tbarras_4       FORMAT  'x(13)'   COLUMN-LABEL "EAN14-4":U WIDTH 12
      tequival_4      FORMAT  '->>>,>>9'   COLUMN-LABEL "CANTIDAD"
       tRequiereSerialNr
       tRequiereDueDate
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 143 BY 21.73
         FONT 1 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-2 AT ROW 1.92 COL 2.14 WIDGET-ID 200
     BUTTON-6 AT ROW 23.96 COL 115 WIDGET-ID 8
     BUTTON-5 AT ROW 24 COL 39 WIDGET-ID 4
     BUTTON-7 AT ROW 24.08 COL 67 WIDGET-ID 10
     "Elija el archivo excel a cargar" VIEW-AS TEXT
          SIZE 29 BY .62 AT ROW 24.08 COL 10 WIDGET-ID 6
          FGCOLOR 4 FONT 12
     "CARGA MASIVA PARA LA CREACION DE NUEVOS ARTICULOS" VIEW-AS TEXT
          SIZE 82 BY .77 AT ROW 1.08 COL 35.29 WIDGET-ID 2
          BGCOLOR 9 FGCOLOR 15 FONT 11
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 146.43 BY 24.38 WIDGET-ID 100.


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
         TITLE              = "CARGA MASIVA DE ARTICULOS"
         HEIGHT             = 24.38
         WIDTH              = 146.43
         MAX-HEIGHT         = 29.19
         MAX-WIDTH          = 146.43
         VIRTUAL-HEIGHT     = 29.19
         VIRTUAL-WIDTH      = 146.43
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
/* BROWSE-TAB BROWSE-2 TEXT-2 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttCarga.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CARGA MASIVA DE ARTICULOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CARGA MASIVA DE ARTICULOS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* ... */
DO:
  RUN cargar-excel-a-tempo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Grabar los Articulos */
DO:

    FIND FIRST ttCarga NO-ERROR.
    IF NOT AVAILABLE ttCarga THEN DO:
        MESSAGE "NO EXISTE DATA PARA GRABAR!".
        RETURN NO-APPLY.
    END.

        MESSAGE 'Seguro de Grabar?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.
  
    RUN cargar-tempo-a-db.
    IF AVAILABLE Almmmatg THEN RELEASE Almmmatg.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 W-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* Exportar a Excel */
DO:
    FIND FIRST ttCarga NO-ERROR.
    IF NOT AVAILABLE ttCarga THEN DO:
        MESSAGE "NO EXISTE DATA PARA EXPORTAR!".
        RETURN NO-APPLY.
    END.

        MESSAGE 'Seguro de Exportar a Excel?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

    RUN exportar-a-excel.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ACTUALIZA-MAT-x-ALM W-Win 
PROCEDURE ACTUALIZA-MAT-x-ALM :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH Almacen NO-LOCK WHERE Almacen.CodCia = Almmmatg.codcia AND Almacen.TdoArt
    TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    /* CONSISTENCIA POR PRODUCTO Y ALMACEN */
    IF Almmmatg.TpoMrg > '' AND Almacen.Campo-c[2] > '' THEN DO:
        IF Almmmatg.TpoMrg <> Almacen.Campo-c[2] THEN NEXT.
    END.
    /* *********************************** */
    FIND Almmmate WHERE Almmmate.CodCia = Almmmatg.codcia AND 
         Almmmate.CodAlm = Almacen.CodAlm AND 
         Almmmate.CodMat = Almmmatg.CodMat NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN DO:
       CREATE Almmmate.
       ASSIGN Almmmate.CodCia = Almmmatg.codcia
              Almmmate.CodAlm = Almacen.CodAlm
              Almmmate.CodMat = Almmmatg.CodMat.
    END.
    ASSIGN Almmmate.DesMat = Almmmatg.DesMat
           Almmmate.FacEqu = Almmmatg.FacEqu
           Almmmate.UndVta = Almmmatg.UndStk
           Almmmate.CodMar = Almmmatg.CodMar.
    FIND FIRST almautmv WHERE 
         almautmv.CodCia = Almmmatg.codcia AND
         almautmv.CodFam = Almmmatg.codfam AND
         almautmv.CodMar = Almmmatg.codMar AND
         almautmv.Almsol = Almmmate.CodAlm NO-LOCK NO-ERROR.
    IF AVAILABLE almautmv THEN 
       ASSIGN Almmmate.AlmDes = almautmv.Almdes
              Almmmate.CodUbi = almautmv.CodUbi.
END.
RELEASE Almmmate.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-excel-a-tempo W-Win 
PROCEDURE cargar-excel-a-tempo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR X-archivo AS CHAR.
DEFINE VAR rpta AS LOG.

SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Excel (*.xls,*.xlsx)' '*.xls,*.xlsx'
    DEFAULT-EXTENSION '.xls'
    RETURN-TO-START-DIR
    TITLE 'Importar Excel'
    UPDATE rpta.
IF rpta = NO OR x-Archivo = '' THEN RETURN.

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.
define VAR cValue as char.
define VAR fValue as DATE.
define VAR dValue as DEC.
DEFINE VARIABLE iValue          AS INT64      NO-UNDO.
DEFINE VAR s-nroitm AS INT.

lFileXls = X-archivo.           /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = NO.        /* YES : Si va crear un nuevo archivo o abrir */

EMPTY TEMP-TABLE ttCarga.

{lib\excel-open-file.i}

chExcelApplication:Visible = FALSE.

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = YES.        /* Si permanece abierto el Excel luego de concluir el proceso */
/*cColList - Array Columnas (A,B,C...AA,AB,AC...) */

chWorkSheet = chExcelApplication:Sheets:Item(1).  

iRow = 1.
s-nroitm = 1.
SESSION:SET-WAIT-STATE('GENERAL').
REPEAT iColumn = 2 TO 65000:
    /* Descripción */
    cRange = "A" + TRIM(STRING(iColumn)).
    cValue = chWorkSheet:Range(cRange):TEXT.    

    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */

    cValue = TRIM(cValue).
    CREATE ttCarga.
        ASSIGN tlinea   = s-nroitm
            tdesmat = cValue.            
    
    cRange = "B" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    IF cValue = ? THEN cValue = "".
    ASSIGN
        tcodmar = cValue.

    cRange = "C" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    IF cValue = ? THEN cValue = "".
    ASSIGN
        tcodfam = SUBSTRING(cValue,1,3)
        tcatgconta = "".

    /* Jalar la Categ Contable */
    FIND FIRST almtfami WHERE almtfami.codcia = s-codcia AND
                                almtfami.codfam = SUBSTRING(cValue,1,3) NO-LOCK NO-ERROR.
    IF AVAILABLE almtfami THEN DO:
        ASSIGN
            tcatgconta = almtfami.libre_c01.
    END.

    cRange = "D" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    IF cValue = ? THEN cValue = "".
    ASSIGN
        tsubfam = SUBSTRING(cValue,1,3).

    cRange = "E" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    IF cValue = ? THEN cValue = "".
    ASSIGN
        tSSubFam = SUBSTRING(cValue,1,3).

    cRange = "F" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    IF cValue = ? THEN cValue = "".
    ASSIGN
        tCHR__02 = SUBSTRING(cValue,1,1).

    cRange = "G" + TRIM(STRING(iColumn)).
    cValue = CAPS(TRIM(chWorkSheet:Range(cRange):VALUE)).
    IF cValue = ? THEN cValue = "".
    ASSIGN
        tAftIGV = cValue.

    cRange = "H" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    IF cValue = ? THEN cValue = "".
    ASSIGN
        tlicencia = cValue.

    cRange = "I" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    IF cValue = ? THEN cValue = "".
    IF TRUE <> (cValue > '') THEN cValue = ''.
    ASSIGN
        tTpoMrg = SUBSTRING(cValue,1,1).

    cRange = "J" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    IF cValue = ? THEN cValue = "".
    ASSIGN
        tUndBas = SUBSTRING(cValue,1,3).

    cRange = "K" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    IF cValue = ? THEN cValue = "".
    ASSIGN
        TUndCmp = SUBSTRING(cValue,1,3).

    cRange = "L" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    IF cValue = ? THEN cValue = "".
    ASSIGN
        TUndStk = SUBSTRING(cValue,1,3).

    cRange = "M" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):TEXT).
    IF cValue = ? THEN cValue = "".
    ASSIGN
        TUndA = SUBSTRING(cValue,1,3).

    cRange = "N" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):TEXT).
    IF cValue = ? THEN cValue = "".
    ASSIGN
        TUndB = SUBSTRING(cValue,1,3).

    cRange = "O" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):TEXT).
    IF cValue = ? THEN cValue = "".
    ASSIGN
        TUndC = SUBSTRING(cValue,1,3).

    cRange = "P" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    IF cValue = ? THEN cValue = "".
    ASSIGN
        TCHR__01 = SUBSTRING(cValue,1,3).

    cRange = "Q" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    IF cValue = ? THEN cValue = "".
    ASSIGN
        TUndAlt1 = SUBSTRING(cValue,1,3).

    cRange = "R" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    IF cValue = ? THEN cValue = "".
    ASSIGN
        TDEC__03 = DEC(cValue).

    cRange = "S" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    IF cValue = ? THEN cValue = "".
    ASSIGN
        TStkMin = DEC(cValue).

    cRange = "T" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    IF cValue = ? THEN cValue = "".
    ASSIGN
        TCanEmp = DEC(cValue).

    cRange = "U" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    IF cValue = ? THEN cValue = "".
    ASSIGN
        TStkRep = DEC(cValue).

    cRange = "V" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    IF cValue = ? THEN cValue = "".
    ASSIGN
        TCodPr1 = STRING(INTEGER(cValue), '99999999').

    cRange = "W" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    IF NOT (TRUE <> (cValue > ''))  THEN cValue = STRING(INTEGER(cValue), '99999999').
    ELSE cValue = ''.
    ASSIGN
        TCodPr2 = cValue.

    cRange = "X" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):TEXT).
    IF (TRUE <> (cValue > ''))  THEN cValue = ''.
    ASSIGN
        TCodIntPr1 = cValue.

    cRange = "Y" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    IF (TRUE <> (cValue > ''))  THEN cValue = "".
    ASSIGN
        TCoddigesa = cValue.
    
    cRange = "Z" + TRIM(STRING(iColumn)).
    fValue = chWorkSheet:Range(cRange):VALUE.
    IF NOT (TRUE <> (cValue > ''))  THEN DO:
        ASSIGN
            Tvtodigesa = fValue.
    END.

    /* EAN 13 */
    cRange = "AA" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        Tlargo = dValue.
        
    cRange = "AB" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        TAncho = dValue.
        
    cRange = "AC" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        TAlto = dValue.
        
    cRange = "AD" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        Tlibre_d02 = dValue.        /* Volumen */

    cRange = "AE" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        TPesmat = dValue

    cRange = "AF" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):TEXT).
    IF cValue = ? THEN cValue = "".
    IF cValue <> "" THEN DO:
        iValue = INT64(cVALUE).
        ASSIGN
            TCodBrr = STRING(cValue).            
    END.
    /*   FIN EAN 13 --- */

    /* EAN 14 - 1 */
    cRange = "AG" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        Tlargoinner = dValue.

    cRange = "AH" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        Tanchoinner = dValue.

    cRange = "AI" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        Taltoinner = dValue.

    cRange = "AJ" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        TVolinner = dValue.

    cRange = "AK" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        TPesoinner = dValue.
    
    cRange = "AL" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):TEXT).
    IF cValue = ? THEN cValue = "".
    IF cValue <> "" THEN DO:
        iValue = INT64(cVALUE).
        ASSIGN
            Tbarras_1 = STRING(cValue).            
    END.    

    cRange = "AM" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        TEquival_1 = dValue.
    /* FIN EAN 14 - 1 */

    /* EAN 14 - 2 */
    cRange = "AN" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        Tlargoinner2 = dValue.

    cRange = "AO" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        Tanchoinner2 = dValue.

    cRange = "AP" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        Taltoinner2 = dValue.

    cRange = "AQ" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        TVolinner2 = dValue.

    cRange = "AR" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        TPesoinner2 = dValue.

    cRange = "AS" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):TEXT).
    IF cValue = ? THEN cValue = "".
    IF cValue <> "" THEN DO:
        iValue = INT64(cVALUE).
        ASSIGN
            Tbarras_2 = STRING(cValue).
    END.    

    cRange = "AT" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        TEquival_2 = dValue.
    /* FIN EAN 14 - 2 */
    
    /* EAN 14 - 3 */
    cRange = "AU" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        Tlargomaster = dValue.

    cRange = "AV" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        Tanchomaster = dValue.

    cRange = "AW" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        Taltomaster = dValue.

    cRange = "AX" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        TVolmaster = dValue.

    cRange = "AY" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        TPesomaster = dValue.

    cRange = "AZ" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):TEXT).
    IF cValue = ? THEN cValue = "".
    IF cValue <> "" THEN DO:
        iValue = INT64(cVALUE).
        ASSIGN
            Tbarras_3 = STRING(cValue).
    END.

    cRange = "BA" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        TEquival_3 = dValue.

    /*   FIN EAN 14 - 3 */

    /* Flg Comercial */
    cRange = "BB" + TRIM(STRING(iColumn)).    
    cValue = chWorkSheet:Range(cRange):TEXT.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        Tflgcomercial = cValue.

    /* EAN 14 - 4 */
    cRange = "BC" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        Tlargopallet = dValue.

    cRange = "BD" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        Tanchopallet = dValue.

    cRange = "BE" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        Taltopallet = dValue.

    cRange = "BF" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        TVolpallet = dValue.

    cRange = "BG" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        TPesopallet = dValue.

    cRange = "BH" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):TEXT).
    IF cValue = ? THEN cValue = "".
    IF cValue <> "" THEN DO:
        iValue = INT64(cVALUE).
        ASSIGN
            Tbarras_4 = STRING(cValue).
    END.

    cRange = "BI" + TRIM(STRING(iColumn)).    
    dValue = chWorkSheet:Range(cRange):VALUE.
    IF dValue = ? THEN dValue = 0.
    ASSIGN
        TEquival_4 = dValue.

    /* RHC 08/08/2020 campos nuevos */
    cRange = "BJ" + TRIM(STRING(iColumn)).    
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN
        TRequiereSerialNr = cValue.

    cRange = "BK" + TRIM(STRING(iColumn)).    
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN
        TRequiereDueDate = cValue.

    /*   FIN EAN 14 - 4 --- */

    /* ************************************ */
    s-nroitm = s-nroitm + 1.
END.

{lib\excel-close-file.i} 

RUN validar-data.

{&OPEN-QUERY-BROWSE-2}

SESSION:SET-WAIT-STATE('').

MESSAGE "Se cargaron (" + STRING(s-nroitm - 1) + ") items".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-tempo-a-db W-Win 
PROCEDURE cargar-tempo-a-db :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR i AS INT NO-UNDO.
DEF VAR x-NroCor AS INT NO-UNDO.
DEF VAR x-OrdMat AS INTEGER NO-UNDO.
DEF VAR C-ALM    AS CHAR NO-UNDO.

DEFINE VAR x-sec AS INT INIT 0.

DEFINE VAR lCodMat AS CHAR.

DEF BUFFER MATG FOR Almmmatg.
SESSION:SET-WAIT-STATE('GENERAL').

x-sec = 0.

FOR EACH ttCarga WHERE tmsgerr = "OK":
    /* Capturamos Correlativo */
    FIND LAST MATG WHERE MATG.CodCia = S-CODCIA NO-LOCK NO-ERROR.
    IF AVAILABLE MATG THEN x-NroCor = INTEGER(MATG.codmat) + 1.
    ELSE x-NroCor = 1.

    FIND LAST MATG WHERE MATG.Codcia = S-CODCIA 
                         AND  MATG.CodFam = ttCarga.tCodfam
                         USE-INDEX Matg08 NO-LOCK NO-ERROR.
    IF AVAILABLE MATG THEN x-ordmat = MATG.Orden + 3.
    ELSE x-ordmat = 1.

    CREATE almmmatg.
    ASSIGN
        almmmatg.codcia = s-codcia
        Almmmatg.codmat = STRING(x-NroCor,"999999")
        Almmmatg.orden  = x-ordmat
        Almmmatg.ordlis = x-ordmat
        Almmmatg.tpoart = 'A'     /* Activo */
        Almmmatg.FchIng = TODAY
        Almmmatg.FchAct = TODAY
        Almmmatg.Libre_C05 = s-user-id + "|" + STRING(TODAY, '99/99/9999') 
        NO-ERROR.

     IF ERROR-STATUS:ERROR THEN DO:
         ASSIGN ttCarga.tmsgerr = "OK - ERROR AL GRABAR".
         NEXT.
     END.

    ASSIGN Almmmatg.desmat = CAPS(ttCarga.tdesmat)
            Almmmatg.codmar = ttCarga.tcodmar
            Almmmatg.desmat = CAPS(ttCarga.tdesmat)
            Almmmatg.codfam = ttCarga.tcodfam
            Almmmatg.subfam = ttCarga.tsubfam
            Almmmatg.codssfam = ttCarga.tssubfam
            Almmmatg.CHR__02 = CAPS(ttCarga.tCHR__02)
            almmmatg.aftigv = IF(ttCarga.taftigv = 'SI' ) THEN YES ELSE NO
            almmmatg.licencia = CAPS(ttCarga.tlicencia)
            almmmatg.tpomrg = ttCarga.ttpomrg
            almmmatg.undbas = CAPS(ttCarga.tundbas)
            almmmatg.undcmp = CAPS(ttCarga.tundcmp)
            almmmatg.undstk = CAPS(ttCarga.tundstk)
            almmmatg.undA = CAPS(ttCarga.tundA)
            almmmatg.undB = CAPS(ttCarga.tundB)
            almmmatg.undC = CAPS(ttCarga.tundC)
            almmmatg.CHR__01 = CAPS(ttCarga.tCHR__01)
            almmmatg.undalt[1] = CAPS(ttCarga.tundalt1)
            almmmatg.DEC__03 = ttCarga.tdec__03
            almmmatg.stkmin = ttCarga.tstkmin
            almmmatg.canemp = ttCarga.tcanemp
            almmmatg.stkrep = ttCarga.tstkrep
            almmmatg.codpr1 = ttCarga.tcodpr1
            almmmatg.codpr2 = ttCarga.tcodpr2
            almmmatg.coddigesa = CAPS(ttCarga.tcoddigesa)
            almmmatg.vtodigesa = ttCarga.tvtodigesa
            almmmatg.largo = ttCarga.tlargo
            almmmatg.ancho = ttCarga.tancho
            almmmatg.alto = ttCarga.talto
            almmmatg.libre_d02 = ttCarga.tlibre_d02
            almmmatg.pesmat = ttCarga.tpesmat
            almmmatg.codbrr = ttCarga.tcodbrr 
            almmmatg.flgcomercial = ttCarga.tflgcomercial
            almmmatg.catconta[1] = ttCarga.tCatgConta
            almmmatg.RequiereSerialNr = (IF ttCarga.tRequiereSerialNr = ? THEN 'No' ELSE ttCarga.tRequiereSerialNr)
            almmmatg.RequiereDueDate = (IF ttCarga.tRequiereDueDate = ? THEN 'N' ELSE ttCarga.tRequiereDueDate)
            NO-ERROR
    .
    IF ERROR-STATUS:ERROR THEN DO:
        ASSIGN ttCarga.tmsgerr = "OK - ERROR AL GRABAR2".
        UNDO, NEXT.
    END.
    /* -------------- */
    FIND FIRST almtabla WHERE almtabla.tabla = 'MK' AND
                                    almtabla.codigo = almmmatg.codmar NO-LOCK NO-ERROR.
    IF AVAILABLE almtabla THEN DO:
        ASSIGN almmmatg.desmar = CAPS(almtabla.nombre).
    END.

    /* Actualizamos las SUBCATEGORIAS */
    FOR EACH webscmatt NO-LOCK WHERE webscmatt.CodCia = s-codcia
        AND webscmatt.codmat = almmmatg.codmat:
        CREATE webscmatg.
        ASSIGN
            webscmatg.CodCia = webscmatt.CodCia 
            webscmatg.codmat = Almmmatg.codmat
            webscmatg.Subcategoria = webscmatt.Subcategoria.
    END.
    /* Actualizamos la lista de Almacenes */ 
    /*ALM = TRIM(Almmmatg.almacenes).*/
    
    C-ALM = ''.
    FOR EACH Almacen NO-LOCK WHERE Almacen.CodCia = Almmmatg.codcia AND Almacen.TdoArt:
        /* CONSISTENCIA POR PRODUCTO Y ALMACEN */
        IF Almmmatg.TpoMrg <> '' AND Almacen.Campo-c[2] <> '' THEN DO:
            IF Almmmatg.TpoMrg <> Almacen.Campo-c[2] THEN NEXT.
        END.
        /* *********************************** */
        IF C-ALM = "" THEN C-ALM = TRIM(Almacen.CodAlm).
        IF LOOKUP(TRIM(Almacen.CodAlm),C-ALM) = 0 THEN C-ALM = C-ALM + "," + TRIM(Almacen.CodAlm).
    END.
    ASSIGN 
        Almmmatg.almacenes = C-ALM.
    /* RHC 24-09-2013 ACTUALIZAMOS MONEDA DE VENTA Y TIPO DE CAMBIO */
    FIND Almtfami OF Almmmatg NO-LOCK NO-ERROR.
    IF AVAILABLE Almtfami THEN DO:
       ASSIGN
           Almmmatg.tpocmb = Almtfami.tpocmb.
    END.
    IF NOT (Almmmatg.MonVta = 1 OR Almmmatg.MonVta = 2)
        THEN Almmmatg.MonVta = 1.

    RUN ACTUALIZA-MAT-x-ALM NO-ERROR.  
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.

    /* EAN14s */
    IF ttCarga.tbarras_1 <> "" THEN DO:
        FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND 
                                    almmmat1.codmat = almmmatg.codmat EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE almmmat1 THEN DO:
            CREATE almmmat1.
            ASSIGN almmmat1.codcia = s-codcia
                    almmmat1.codmat = almmmatg.codmat.
        END.
        ASSIGN almmmat1.barras[1] =  ttCarga.tbarras_1
                almmmat1.equival[1] = ttCarga.tequival_1.
    END.
    IF ttCarga.tbarras_2 <> "" THEN DO:
        FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND 
                                    almmmat1.codmat = almmmatg.codmat EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE almmmat1 THEN DO:
            CREATE almmmat1.
            ASSIGN almmmat1.codcia = s-codcia
                    almmmat1.codmat = almmmatg.codmat.
        END.
        ASSIGN almmmat1.barras[2] =  ttCarga.tbarras_2
                almmmat1.equival[2] = ttCarga.tequival_2.
    END.
    IF ttCarga.tbarras_3 <> "" THEN DO:
        FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND 
                                    almmmat1.codmat = almmmatg.codmat EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE almmmat1 THEN DO:
            CREATE almmmat1.
            ASSIGN almmmat1.codcia = s-codcia
                    almmmat1.codmat = almmmatg.codmat.
        END.
        ASSIGN almmmat1.barras[3] =  ttCarga.tbarras_3
                almmmat1.equival[3] = ttCarga.tequival_3.
    END.
    IF ttCarga.tbarras_4 <> "" THEN DO:
        FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND 
                                    almmmat1.codmat = almmmatg.codmat EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE almmmat1 THEN DO:
            CREATE almmmat1.
            ASSIGN almmmat1.codcia = s-codcia
                    almmmat1.codmat = almmmatg.codmat.
        END.
        ASSIGN almmmat1.barras[4] =  ttCarga.tbarras_4
                almmmat1.equival[4] = ttCarga.tequival_4.
    END.

    /* Extendido */
    FIND FIRST almmmatgExt WHERE almmmatgExt.codcia = s-codcia AND 
                                almmmatgExt.codmat = almmmatg.codmat EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE almmmatgExt THEN DO:
        CREATE almmmatgext.
        ASSIGN almmmatgext.codcia = s-codcia
                almmmatgext.codmat = almmmatg.codmat.
    END.
    ASSIGN almmmatgext.codintpr1 = ttCarga.tcodpr1
            almmmatgext.largoinner = ttCarga.tlargoinner
            almmmatgext.anchoinner = ttCarga.tanchoinner
            almmmatgext.altoinner = ttCarga.taltoinner
            almmmatgext.volinner = ttCarga.tvolinner
            almmmatgext.pesoinner = ttCarga.tpesoinner.
    ASSIGN almmmatgext.largoinner2 = ttCarga.tlargoinner2
            almmmatgext.anchoinner2 = ttCarga.tanchoinner2
            almmmatgext.altoinner2 = ttCarga.taltoinner2
            almmmatgext.volinner2 = ttCarga.tvolinner2
            almmmatgext.pesoinner2 = ttCarga.tpesoinner2.
    ASSIGN almmmatgext.largomaster = ttCarga.tlargomaster
            almmmatgext.anchomaster = ttCarga.tanchomaster
            almmmatgext.altomaster = ttCarga.taltomaster
            almmmatgext.volmaster = ttCarga.tvolmaster
            almmmatgext.pesomaster = ttCarga.tpesomaster.
    ASSIGN almmmatgext.largopallet = ttCarga.tlargopallet
            almmmatgext.anchopallet = ttCarga.tanchopallet
            almmmatgext.altopallet = ttCarga.taltopallet
            almmmatgext.volpallet = ttCarga.tvolpallet
            almmmatgext.pesopallet = ttCarga.tpesopallet
    .
    x-sec = x-sec + 1.
    ASSIGN ttCarga.tmsgerr = "OK - GRABADO".
END.
RELEASE Almmmatg.

SESSION:SET-WAIT-STATE('').

{&OPEN-QUERY-BROWSE-2}

MESSAGE "Se grabaron(" + STRING(x-sec) + ") Registros".

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
  ENABLE BROWSE-2 BUTTON-6 BUTTON-5 BUTTON-7 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportar-a-excel W-Win 
PROCEDURE exportar-a-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-archivo AS CHAR.                       
DEFINE VAR rpta AS LOG.
                       
SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Excel (*.xlsx)' '*.xlsx'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.xlsx'
    RETURN-TO-START-DIR
    SAVE-AS
    TITLE 'Exportar a Excel'
    UPDATE rpta.
IF rpta = NO OR x-Archivo = '' THEN RETURN.
                                   
                                   
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = x-archivo.

run pi-crea-archivo-csv IN hProc (input  buffer ttCarga:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer ttCarga:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.


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
  {src/adm/template/snd-list.i "ttCarga"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validar-data W-Win 
PROCEDURE validar-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR hProc AS HANDLE NO-UNDO.
DEFINE VAR x-CodError AS CHAR.
DEFINE VAR x-existe AS LOG.

/* Levantamos las rutinas a memoria Version 2 */
RUN lib\tablas-validaciones.r PERSISTENT SET hProc NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    x-CodError = "ERROR en las librerias(lib\tablas-validaciones.r) " + CHR(10) +
        "Salir del Sistema, volver a entrar y repetir el proceso".
    RETURN "ADM-ERROR".
END.

DEFINE VAR x-filer AS CHAR.

/* Validaciones */
FOR EACH ttCarga :
    /* Valido Marcas */
    RUN existe-marca IN hProc (INPUT ttCarga.tcodmar, OUTPUT x-existe).
    IF x-existe = NO THEN DO:
        ASSIGN ttCarga.tmsgerr = "MARCA NO EXISTE".
        NEXT.
    END.
    /* Valido Familia */
    RUN existe-familia IN hProc (INPUT ttCarga.tcodfam, OUTPUT x-existe).
    IF x-existe = NO THEN DO:
        ASSIGN ttCarga.tmsgerr = "FAMILIA NO EXISTE".
        NEXT.
    END.
    /* Valido SubFamilia */
    RUN existe-subfamilia IN hProc (INPUT ttCarga.tcodfam, INPUT ttCarga.tsubfam, OUTPUT x-existe).
    IF x-existe = NO THEN DO:
        ASSIGN ttCarga.tmsgerr = "SUB FAMILIA NO EXISTE".
        NEXT.
    END.
    /* Valido SUB SubFamilia */
    RUN existe-subsubfamilia IN hProc (INPUT ttCarga.tcodfam, INPUT ttCarga.tsubfam, INPUT ttCarga.tssubfam, OUTPUT x-existe).
    IF x-existe = NO THEN DO:
        ASSIGN ttCarga.tmsgerr = "SUB SUBFAMILIA NO EXISTE".
        NEXT.
    END.
    /* Valido Priopos / Terceros */
    IF NOT (tchr__02 = 'P' OR tchr__02 = 'T') THEN DO:
        ASSIGN ttCarga.tmsgerr = "PROPIOS (P) / TERCEROS (T) - ERRADOS".
        NEXT.
    END.
    /* Valido AFECTO IGV */
    IF NOT (taftigv = 'SI' OR taftigv = 'NO') THEN DO:
        ASSIGN ttCarga.tmsgerr = "AFECTO INVALIDO (SI / NO)".
        NEXT.
    END.
    /* Valido Licencia */
    IF ttCarga.tlicencia <> "" THEN DO:
        RUN existe-licencia IN hProc (INPUT ttCarga.tlicencia, OUTPUT x-existe).
        IF x-existe = NO THEN DO:
            ASSIGN ttCarga.tmsgerr = "LICENCIA NO EXISTE".
            NEXT.
        END.
    END.
    /* Valido MAYORISTA / MINORISTA / AMBOS */
    IF NOT (ttpomrg = '' OR ttpomrg = '1' OR ttpomrg = '2') THEN DO:
        ASSIGN ttCarga.tmsgerr = "MAYORISTA (1) / MINORISTA (2) / vacio:AMBOS - ERRADOS".
        NEXT.
    END.
    /* Valido UNIDAD MEDIDA BASE */
    RUN existe-umedida IN hProc (INPUT ttCarga.tundbas, OUTPUT x-existe).
    IF x-existe = NO THEN DO:
        ASSIGN ttCarga.tmsgerr = "U.MEDIDA BASE NO EXISTE".
        NEXT.
    END.
    FIND Unidades WHERE Unidades.Codunid = ttCarga.tundbas NO-LOCK NO-ERROR.
    IF Unidades.Libre_l03 = NO THEN DO:
        ASSIGN ttCarga.tmsgerr = "U.MEDIDA BASE ERRADA".
        NEXT.
    END.
    /* Valido UNIDAD MEDIDA COMPRA */
    RUN existe-umedida IN hProc (INPUT ttCarga.tundcmp, OUTPUT x-existe).
    IF x-existe = NO THEN DO:
        ASSIGN ttCarga.tmsgerr = "U.MEDIDA COMPRA NO EXISTE".
        NEXT.
    END.
    /* Valido UNIDAD STOCK */
    RUN existe-umedida IN hProc (INPUT ttCarga.tundstk, OUTPUT x-existe).
    IF x-existe = NO THEN DO:
        ASSIGN ttCarga.tmsgerr = "U.MEDIDA STOCK NO EXISTE".
        NEXT.
    END.
    /* Valido UNIDAD MOSTRADOR A */
    IF ttCarga.tundA <> "" THEN DO:
        RUN existe-umedida IN hProc (INPUT ttCarga.tundA, OUTPUT x-existe).
        IF x-existe = NO THEN DO:
            ASSIGN ttCarga.tmsgerr = "U.MEDIDA MOSTRADOR 'A' NO EXISTE".
            NEXT.
        END.
    END.
    /* Valido UNIDAD MOSTRADOR B */
    IF ttCarga.tundB <> "" THEN DO:
        RUN existe-umedida IN hProc (INPUT ttCarga.tundB, OUTPUT x-existe).
        IF x-existe = NO THEN DO:
            ASSIGN ttCarga.tmsgerr = "U.MEDIDA MOSTRADOR 'B' NO EXISTE".
            NEXT.
        END.
    END.
    /* Valido UNIDAD MOSTRADOR C */
    IF ttCarga.tundC <> "" THEN DO:
        RUN existe-umedida IN hProc (INPUT ttCarga.tundC, OUTPUT x-existe).
        IF x-existe = NO THEN DO:
            ASSIGN ttCarga.tmsgerr = "U.MEDIDA MOSTRADOR 'C' NO EXISTE".
            NEXT.
        END.
    END.
    /* Valido U.MEDIDA OFICINA */
    IF ttCarga.tchr__01 <> "" THEN DO:
        RUN existe-umedida IN hProc (INPUT ttCarga.tchr__01, OUTPUT x-existe).
        IF x-existe = NO THEN DO:
            ASSIGN ttCarga.tmsgerr = "U.MEDIDA OFICINA NO EXISTE".
            NEXT.
        END.
    END.
    FIND Unidades WHERE Unidades.Codunid = ttCarga.tchr__01 NO-LOCK NO-ERROR.
    IF Unidades.Libre_l03 = NO THEN DO:
        ASSIGN ttCarga.tmsgerr = "U.MEDIDA OFICINA ERRADA".
        NEXT.
    END.
    /* Valido U.MEDIDA AL POR MENOR */
    IF ttCarga.tundalt1 <> "" THEN DO:
        RUN existe-umedida IN hProc (INPUT ttCarga.tundalt1, OUTPUT x-existe).
        IF x-existe = NO THEN DO:
            ASSIGN ttCarga.tmsgerr = "U.MEDIDA AL POR MENOR NO EXISTE".
            NEXT.
        END.
    END.
    /* Valido MIN.VTA MAYORISTA */
    IF ttCarga.tdec__03 < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "MIN.VTA MAYORISTA ERRADO".
        NEXT.
    END.
    /* Valido MIN.VTA MINORISTA */
    IF ttCarga.tstkmin < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "MIN.VTA MINORISTA ERRADO".
        NEXT.
    END.
    /* Valido EMPAQUE MASTER */
    IF ttCarga.tcanemp < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "EMPAQUE MASTER ERRADO".
        NEXT.
    END.
    /* Valido EMPAQUE INNER */
    IF ttCarga.tstkrep < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "EMPAQUE INNER ERRADO".
        NEXT.
    END.
    /* Valido PROVEEDOR A */
    IF ttCarga.tcodpr1 <> "" THEN DO:
        RUN existe-proveedor IN hProc (INPUT ttCarga.tcodpr1, OUTPUT x-existe).
        IF x-existe = NO THEN DO:
            ASSIGN ttCarga.tmsgerr = "PROVEEDOR A NO EXISTE".
            NEXT.
        END.
    END.
    /* Valido PROVEEDOR B */
    IF ttCarga.tcodpr2 <> "" THEN DO:
        RUN existe-proveedor IN hProc (INPUT ttCarga.tcodpr2, OUTPUT x-existe).
        IF x-existe = NO THEN DO:
            ASSIGN ttCarga.tmsgerr = "PROVEEDOR B NO EXISTE".
            NEXT.
        END.
    END.
    /* Valido LARGO */
    IF ttCarga.tlargo < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "LARGO ERRADO".
        NEXT.
    END.
    /* Valido ANCHO */
    IF ttCarga.tancho < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "ANCHO ERRADO".
        NEXT.
    END.
    /* Valido ALTO */
    IF ttCarga.talto < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "ALTO ERRADO".
        NEXT.
    END.
    /* Valido VOL */
    IF ttCarga.tlibre_d02 < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "VOLUMEN ERRADO".
        NEXT.
    END.
    /* Valido PESO */
    IF ttCarga.tpesmat < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "PESO ERRADO".
        NEXT.
    END.
    /* Valido EAN13 */
    IF ttCarga.tcodbrr <> "" THEN DO:
        RUN existe-ean13 IN hProc (INPUT ttCarga.tcodbrr, OUTPUT x-filer, OUTPUT x-existe).
        IF x-existe = YES THEN DO:
            ASSIGN ttCarga.tmsgerr = "EAN13 YA EXISTE EN (" + x-filer + ")".
            NEXT.
        END.
    END.
    /* --- INNER 1 ----------------- */
    /* Valido LARGO */
    IF ttCarga.tlargoinner < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "LARGO INNER ERRADO".
        NEXT.
    END.
    /* Valido ANCHO */
    IF ttCarga.tanchoinner < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "ANCHO INNER ERRADO".
        NEXT.
    END.
    /* Valido ALTO */
    IF ttCarga.taltoinner < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "ALTO INNER ERRADO".
        NEXT.
    END.
    /* Valido VOL */
    IF ttCarga.tvolinner < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "VOLUMEN INNER ERRADO".
        NEXT.
    END.
    /* Valido PESO */
    IF ttCarga.tpesoinner < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "PESO INNER ERRADO".
        NEXT.
    END.
    /* Valido EAN14 */
    IF ttCarga.tbarras_1 <> "" THEN DO:
        RUN existe-ean14 IN hProc (INPUT ttCarga.tbarras_1, OUTPUT x-filer, OUTPUT x-existe).
        IF x-existe = YES THEN DO:
            ASSIGN ttCarga.tmsgerr = "EAN14 INNER YA EXISTE EN (" + x-filer + ")".
            NEXT.
        END.
    END.
    /* Valido CANTIDAD */
    IF ttCarga.tequival_1 < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "PESO INNER ERRADO".
        NEXT.
    END.

    /* --- INNER 2 ----------------- */
    /* Valido LARGO */
    IF ttCarga.tlargoinner2 < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "LARGO INNER 2 ERRADO".
        NEXT.
    END.
    /* Valido ANCHO */
    IF ttCarga.tanchoinner2 < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "ANCHO INNER 2 ERRADO".
        NEXT.
    END.
    /* Valido ALTO */
    IF ttCarga.taltoinner2 < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "ALTO INNER 2 ERRADO".
        NEXT.
    END.
    /* Valido VOL */
    IF ttCarga.tvolinner2 < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "VOLUMEN INNER 2 ERRADO".
        NEXT.
    END.
    /* Valido PESO */
    IF ttCarga.tpesoinner2 < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "PESO INNER 2 ERRADO".
        NEXT.
    END.
    /* Valido EAN14 */
    IF ttCarga.tbarras_2 <> "" THEN DO:
        RUN existe-ean14 IN hProc (INPUT ttCarga.tbarras_2, OUTPUT x-filer, OUTPUT x-existe).
        IF x-existe = YES THEN DO:
            ASSIGN ttCarga.tmsgerr = "EAN14 INNER 2 YA EXISTE EN (" + x-filer + ")".
            NEXT.
        END.
    END.
    /* Valido CANTIDAD */
    IF ttCarga.tequival_2 < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "PESO INNER 2 ERRADO".
        NEXT.
    END.

    /* --- MASTER ----------------- */
    /* Valido LARGO */
    IF ttCarga.tlargomaster < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "LARGO MASTER ERRADO".
        NEXT.
    END.
    /* Valido ANCHO */
    IF ttCarga.tanchomaster < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "ANCHO MASTER ERRADO".
        NEXT.
    END.
    /* Valido ALTO */
    IF ttCarga.taltomaster < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "ALTO MASTER ERRADO".
        NEXT.
    END.
    /* Valido VOL */
    IF ttCarga.tvolmaster < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "VOLUMEN MASTER ERRADO".
        NEXT.
    END.
    /* Valido PESO */
    IF ttCarga.tpesomaster < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "PESO MASTER ERRADO".
        NEXT.
    END.
    /* Valido EAN14 */
    IF ttCarga.tbarras_3 <> "" THEN DO:
        RUN existe-ean14 IN hProc (INPUT ttCarga.tbarras_3, OUTPUT x-filer, OUTPUT x-existe).
        IF x-existe = YES THEN DO:
            ASSIGN ttCarga.tmsgerr = "EAN14 MASTER YA EXISTE EN (" + x-filer + ")".
            NEXT.
        END.
    END.
    /* Valido CANTIDAD */
    IF ttCarga.tequival_3 < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "PESO MASTER ERRADO".
        NEXT.
    END.

    /* --- PALLET ----------------- */
    /* Valido LARGO */
    IF ttCarga.tlargopallet < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "LARGO PALLET ERRADO".
        NEXT.
    END.
    /* Valido ANCHO */
    IF ttCarga.tanchoPALLET < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "ANCHO PALLET ERRADO".
        NEXT.
    END.
    /* Valido ALTO */
    IF ttCarga.taltoPALLET < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "ALTO PALLET ERRADO".
        NEXT.
    END.
    /* Valido VOL */
    IF ttCarga.tvolPALLET < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "VOLUMEN PALLET ERRADO".
        NEXT.
    END.
    /* Valido PESO */
    IF ttCarga.tpesoPALLET < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "PESO PALLET ERRADO".
        NEXT.
    END.
    /* Valido EAN14 */
    IF ttCarga.tbarras_4 <> "" THEN DO:
        RUN existe-ean14 IN hProc (INPUT ttCarga.tbarras_4, OUTPUT x-filer, OUTPUT x-existe).
        IF x-existe = YES THEN DO:
            ASSIGN ttCarga.tmsgerr = "EAN14 PALLET YA EXISTE EN (" + x-filer + ")".
            NEXT.
        END.
    END.
    /* Valido CANTIDAD */
    IF ttCarga.tequival_4 < 0 THEN DO:
        ASSIGN ttCarga.tmsgerr = "PESO PALLET ERRADO".
        NEXT.
    END.

    /* ------------------------------------------------------------------------------ */
    IF ttCarga.tcodbrr <> "" THEN DO:
        IF ttCarga.tcodbrr = ttCarga.tbarras_1 OR 
            ttCarga.tcodbrr = ttCarga.tbarras_2 OR 
            ttCarga.tcodbrr = ttCarga.tbarras_3 OR 
            ttCarga.tcodbrr = ttCarga.tbarras_4 THEN DO:
            ASSIGN ttCarga.tmsgerr = "EAN13 aparece en uno de los EAN14".
            NEXT.
        END.
    END.
    IF ttCarga.tbarras_1 <> "" THEN DO:
        IF ttCarga.tbarras_1 = ttCarga.tbarras_2 OR 
            ttCarga.tbarras_1 = ttCarga.tbarras_3 OR
            ttCarga.tbarras_1 = ttCarga.tbarras_4 THEN DO:
            ASSIGN ttCarga.tmsgerr = "EAN14-1 es igual al EAN14-2 / EAN14-3 / EAN14-4".
            NEXT.            
        END.
    END.
    IF ttCarga.tbarras_2 <> "" THEN DO:
        IF ttCarga.tbarras_2 = ttCarga.tbarras_3 OR
            ttCarga.tbarras_2 = ttCarga.tbarras_4 THEN DO:
            ASSIGN ttCarga.tmsgerr = "EAN14-2 es igual al EAN14-3 / EAN14-4".
            NEXT.            
        END.
    END.
    IF ttCarga.tbarras_3 <> "" THEN DO:
        IF ttCarga.tbarras_3 = ttCarga.tbarras_4 THEN DO:
            ASSIGN ttCarga.tmsgerr = "EAN14-3 es igual al EAN14-4".
            NEXT.            
        END.
    END.

    /* Flg Comercial */
    RUN existe-flag-comercial IN hProc (INPUT ttCarga.tflgcomercial, OUTPUT x-existe).
    IF x-existe = NO THEN DO:
        ASSIGN ttCarga.tmsgerr = "INDICE COMERCIAL NO EXISTE".
        NEXT.
    END.

    /* Categoria Contable */
    RUN existe-categoria-contable IN hProc (INPUT ttCarga.tcatgconta, OUTPUT x-existe).
    IF x-existe = NO THEN DO:
        ASSIGN ttCarga.tmsgerr = "INDICE COMERCIAL NO EXISTE".
        NEXT.
    END.

    /* OK */    
    ASSIGN ttCarga.tmsgerr = "OK".
END.

DELETE PROCEDURE hProc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

