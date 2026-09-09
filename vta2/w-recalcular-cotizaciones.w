&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tFacCPedi NO-UNDO LIKE FacCPedi.



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

DEF NEW SHARED VAR s-Tabla AS CHAR INIT 'CFGLP'.
DEFINE SHARED VAR s-codcia AS INT.
DEF VAR s-tpoped  AS CHAR   INIT "E"        NO-UNDO.
DEF VAR pcoddiv  AS CHAR   INIT ''    NO-UNDO.    /* Division */

DEF NEW SHARED VAR s-codmon AS INT NO-UNDO.
DEF NEW SHARED VAR s-CodCli AS CHAR NO-UNDO.
DEF NEW SHARED VAR s-tpocmb AS DEC NO-UNDO.
DEF NEW SHARED VAR s-cndvta AS CHAR NO-UNDO.
DEF NEW SHARED VAR s-porigv AS DEC NO-UNDO.
DEF NEW SHARED VAR s-nrodec AS INT NO-UNDO.
DEF NEW SHARED VAR s-flgigv AS LOG NO-UNDO.
DEF NEW SHARED VAR s-coddiv AS CHAR NO-UNDO.
DEF SHARED VAR cl-codcia AS INT.
DEFINE NEW SHARED VARIABLE s-Cmpbnte AS CHAR NO-UNDO.

DEF NEW SHARED VAR lh_handle AS HANDLE.

DEFINE VAR x-filtro AS INT INIT 1.

DEF TEMP-TABLE ResumenxLinea
    FIELD codmat LIKE almmmatg.codmat
    FIELD codfam LIKE almmmatg.codfam
    FIELD subfam LIKE almmmatg.subfam
    FIELD canped LIKE facdpedi.canped
    INDEX Llave01 AS PRIMARY /*UNIQUE*/ codmat codfam subfam.

DEFINE TEMP-TABLE ITEM LIKE FacDPedi.
DEF TEMP-TABLE ErroresxLinea LIKE ResumenxLinea.

/* Impuesto Bolsa Plastica */
DEFINE VAR x-articulo-ICBPER AS CHAR.
x-articulo-ICBPER = "099268".

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
&Scoped-define INTERNAL-TABLES tFacCPedi

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tFacCPedi.CodDoc tFacCPedi.NroPed ~
tFacCPedi.CodCli tFacCPedi.FchPed tFacCPedi.NomCli tFacCPedi.CodDiv ~
tFacCPedi.CodVen tFacCPedi.Libre_c04 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tFacCPedi ~
      WHERE x-filtro = 1 or ~
(x-filtro = 2 and (tfaccpedi.libre_c04 <> "" or ~
                  tfaccpedi.libre_c05 <> "")) ~
 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tFacCPedi ~
      WHERE x-filtro = 1 or ~
(x-filtro = 2 and (tfaccpedi.libre_c04 <> "" or ~
                  tfaccpedi.libre_c05 <> "")) ~
 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tFacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tFacCPedi


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-LP FILL-IN-desde FILL-IN-hasta ~
BUTTON-1 FILL-IN-division BUTTON-2 BUTTON-3 RADIO-SET-filtro BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 COMBO-BOX-LP FILL-IN-desde ~
FILL-IN-hasta FILL-IN-division FILL-IN-ddivision RADIO-SET-filtro 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Aceptar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "Recalcular COTIZACIONES" 
     SIZE 21 BY 1.12.

DEFINE BUTTON BUTTON-3 
     LABEL "Cancelar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX-LP AS CHARACTER FORMAT "X(50)":U 
     LABEL "Lista de Precios" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 53 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U INITIAL "RECALCULO DE COTIZACIONES" 
     VIEW-AS FILL-IN 
     SIZE 37 BY 1.73
     BGCOLOR 15 FGCOLOR 9 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-ddivision AS CHARACTER FORMAT "X(256)":U INITIAL "<TODAS LAS DIVISIONES>" 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-division AS CHARACTER FORMAT "X(6)":U INITIAL "*" 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 7.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-filtro AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Mostrar Todo", 1,
"Los a recalcular", 2
     SIZE 17 BY 1.54
     BGCOLOR 15  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tFacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tFacCPedi.CodDoc COLUMN-LABEL "C.DOC" FORMAT "x(3)":U
      tFacCPedi.NroPed COLUMN-LABEL "Numero!Cotizacion" FORMAT "X(12)":U
      tFacCPedi.CodCli FORMAT "x(11)":U WIDTH 10
      tFacCPedi.FchPed FORMAT "99/99/9999":U
      tFacCPedi.NomCli FORMAT "x(50)":U WIDTH 46
      tFacCPedi.CodDiv FORMAT "x(5)":U WIDTH 7
      tFacCPedi.CodVen FORMAT "x(10)":U WIDTH 10.14
      tFacCPedi.Libre_c04 COLUMN-LABEL "Accion" FORMAT "x(50)":U
            WIDTH 16
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 118 BY 18.85
         BGCOLOR 8 FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-1 AT ROW 1.19 COL 104.29 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     COMBO-BOX-LP AT ROW 1.15 COL 12 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-desde AT ROW 2.27 COL 12 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-hasta AT ROW 2.27 COL 32.57 COLON-ALIGNED WIDGET-ID 8
     BUTTON-1 AT ROW 1.08 COL 81 WIDGET-ID 4
     FILL-IN-division AT ROW 2.23 COL 56 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-ddivision AT ROW 2.27 COL 65.57 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     BUTTON-2 AT ROW 8.88 COL 122 WIDGET-ID 22
     BUTTON-3 AT ROW 10.81 COL 127 WIDGET-ID 24
     RADIO-SET-filtro AT ROW 19.08 COL 126 NO-LABEL WIDGET-ID 26
     BROWSE-2 AT ROW 3.31 COL 3 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 143.57 BY 21.85
         BGCOLOR 15 FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tFacCPedi T "?" NO-UNDO INTEGRAL FacCPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "RECALCULO DE COTIZACIONES DE EVENTOS"
         HEIGHT             = 21.85
         WIDTH              = 143.57
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 144.29
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 144.29
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
/* BROWSE-TAB BROWSE-2 RADIO-SET-filtro F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ddivision IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tFacCPedi"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "x-filtro = 1 or
(x-filtro = 2 and (tfaccpedi.libre_c04 <> """" or
                  tfaccpedi.libre_c05 <> """"))
"
     _FldNameList[1]   > Temp-Tables.tFacCPedi.CodDoc
"tFacCPedi.CodDoc" "C.DOC" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tFacCPedi.NroPed
"tFacCPedi.NroPed" "Numero!Cotizacion" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tFacCPedi.CodCli
"tFacCPedi.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.tFacCPedi.FchPed
     _FldNameList[5]   > Temp-Tables.tFacCPedi.NomCli
"tFacCPedi.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "46" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tFacCPedi.CodDiv
"tFacCPedi.CodDiv" ? ? "character" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tFacCPedi.CodVen
"tFacCPedi.CodVen" ? ? "character" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tFacCPedi.Libre_c04
"tFacCPedi.Libre_c04" "Accion" "x(50)" "character" ? ? ? ? ? ? no ? no no "16" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* RECALCULO DE COTIZACIONES DE EVENTOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* RECALCULO DE COTIZACIONES DE EVENTOS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-2 IN FRAME F-Main
DO:


  DO WITH FRAME {&FRAME-NAME} :
      IF AVAILABLE tfaccpedi THEN DO:

          DEFINE VAR x-llave AS CHAR.

          x-llave = "RECALCULO COT" + '|' +
                    STRING(tfaccpedi.codcia) + '|' +
                    TRIM(tfaccpedi.coddoc) + '|' +
                    TRIM(tfaccpedi.nroped) + '|'.

          FIND FIRST logtabla WHERE logtabla.codcia = s-codcia AND
                                        logtabla.tabla = "FACCPEDI" AND
                                        logtabla.valorllave BEGINS x-llave NO-LOCK NO-ERROR.

          IF AVAILABLE logtabla THEN DO:
              /*
              MESSAGE "La cotizacion ya se le reasigno la division y/o vendedor"
                        VIEW-AS ALERT-BOX INFORMATION.
              RETURN NO-APPLY.
              */
          END.


              IF tfaccpedi.libre_c03 = "X2XX" THEN DO:
                  ASSIGN tfaccpedi.libre_c04:SCREEN-VALUE IN BROWSE {&browse-name} = "".
                  ASSIGN    tfaccpedi.libre_c03 = ""
                            tfaccpedi.libre_c04 = "".
              END.
              ELSE DO:
                  ASSIGN tfaccpedi.libre_c04:SCREEN-VALUE IN BROWSE {&browse-name} = "RECALCULAR".

                  ASSIGN    tfaccpedi.libre_c03 = "X2XX"
                            tfaccpedi.libre_c04 = "RECALCULAR".
              END.

      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Aceptar */
DO:

  ASSIGN combo-box-lp fill-in-desde fill-in-hasta fill-in-division.

  IF fill-in-desde > fill-in-hasta THEN DO:
      MESSAGE "Rango de Fechas ERRADAS".
      RETURN NO-APPLY.
  END.
  
  IF fill-in-division <> "*" THEN DO:
      FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND
                                gn-divi.coddiv = fill-in-division NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-divi THEN DO:
          MESSAGE "Division no existe".
          RETURN NO-APPLY.
      END.

  END.

  FIND FIRST factabla WHERE factabla.codcia = s-codcia AND
                            factabla.tabla = "RECAL-COT" AND
                            factabla.codigo = combo-box-lp NO-LOCK NO-ERROR.

  IF NOT AVAILABLE factabla THEN DO:
      MESSAGE "Aun no esta configurado el limite de fecha " SKIP 
                "para el recalculo de la cotizaciones " SKIP 
                "para la lista de precios (" + COMBO-BOX-lp + ")".
      RETURN NO-APPLY.
  END.

  IF TODAY > factabla.campo-d[1]  THEN DO:
      MESSAGE "La configuracion de la fecha para el recalculo" SKIP 
                "de cotizaciones ya esta vencida".
      RETURN NO-APPLY.
  END.

  RUN cargar-cotizaciones(INPUT combo-box-lp).

  RUN mostrar-cot(INPUT YES).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Recalcular COTIZACIONES */
DO:
        MESSAGE 'Seguro de RECALCULAR las COTIZACIONES?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.


    DEFINE VAR x-retval AS CHAR.

    RUN recalcular-cotizaciones(OUTPUT x-retval).

    IF x-retval = 'OK' THEN DO:
        RUN mostrar-cot(INPUT NO). 
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Cancelar */
DO:
    RUN mostrar-cot(INPUT NO).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-LP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-LP W-Win
ON ENTRY OF COMBO-BOX-LP IN FRAME F-Main /* Lista de Precios */
DO:
  RUN mostrar-cot(INPUT NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-division W-Win
ON LEAVE OF FILL-IN-division IN FRAME F-Main /* Division */
DO:
    DEFINE VAR x-dato AS CHAR.

    x-dato = SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    fill-in-ddivision:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

    IF x-dato = "*" THEN DO:
        fill-in-ddivision:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "<TODAS LAS DIVISIONES>".
    END.
    ELSE DO:
        FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND
                                  gn-divi.coddiv = x-dato NO-LOCK NO-ERROR.
        IF AVAILABLE gn-divi THEN DO:
            fill-in-ddivision:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-divi.desdiv.
        END.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-filtro W-Win
ON VALUE-CHANGED OF RADIO-SET-filtro IN FRAME F-Main
DO:

  ASSIGN radio-set-filtro.

  x-filtro = radio-set-filtro.

  {&open-query-browse-2}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-cotizaciones W-Win 
PROCEDURE cargar-cotizaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pListaPrecio AS CHAR.

SESSION:SET-WAIT-STATE("GENERAL").

EMPTY TEMP-TABLE tfaccpedi.

FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia AND                        
                        faccpedi.coddoc = 'COT' AND
                        (fill-in-division = "*" OR faccpedi.coddiv = fill-in-division) AND
                        faccpedi.libre_c01 = pListaPrecio AND
                        (faccpedi.fchped >= fill-in-desde AND faccpedi.fchped <= fill-in-hasta) AND
                        faccpedi.tpoped = 'E' AND
                        faccpedi.flgest = 'P' NO-LOCK:
    CREATE tfaccpedi.
    BUFFER-COPY faccpedi TO tfaccpedi.

    ASSIGN tfaccpedi.libre_c04 = ""
            tfaccpedi.libre_c05 = "".

END.

{&open-query-browse-2}

SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-lp W-Win 
PROCEDURE cargar-lp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR x-nombre AS CHAR INIT "".

  DO WITH FRAME {&FRAME-NAME} :

      IF NOT (TRUE <> (COMBO-BOX-LP:LIST-ITEM-PAIRS > "")) THEN COMBO-BOX-LP:DELETE(COMBO-BOX-LP:LIST-ITEM-PAIRS).

      FOR EACH VtaCTabla WHERE VtaCTabla.codcia = s-codcia AND 
                                VtaCTabla.tabla = s-tabla NO-LOCK,
                    FIRST GN-DIVI WHERE GN-DIVI.CodCia = VtaCTabla.CodCia
                    AND GN-DIVI.CodDiv = VtaCTabla.Llave NO-LOCK :
          COMBO-BOX-LP:ADD-LAST(gn-divi.desdiv + " - (" + VtaCTabla.Llave + ")", vtactabla.llave).
          IF TRUE <> (COMBO-BOX-LP:SCREEN-VALUE > "") THEN DO:
              x-nombre = vtactabla.llave.
              ASSIGN COMBO-BOX-LP:SCREEN-VALUE = x-nombre.
          END.

      END.
      APPLY 'VALUE-CHANGED':U TO COMBO-BOX-LP.
      
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos-Finales-01 W-Win 
PROCEDURE Descuentos-Finales-01 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/descuentoxvolumenxlinearesumida.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos-Finales-02 W-Win 
PROCEDURE Descuentos-Finales-02 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/descuentoxvolumenxsaldosresumidav2.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos-Finales-04 W-Win 
PROCEDURE Descuentos-Finales-04 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/expodtoxvolxsaldoresumido.i}

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
  DISPLAY FILL-IN-1 COMBO-BOX-LP FILL-IN-desde FILL-IN-hasta FILL-IN-division 
          FILL-IN-ddivision RADIO-SET-filtro 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-LP FILL-IN-desde FILL-IN-hasta BUTTON-1 FILL-IN-division 
         BUTTON-2 BUTTON-3 RADIO-SET-filtro BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Lista-Terceros W-Win 
PROCEDURE Lista-Terceros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE f-FleteUnitario AS DEC DECIMALS 6 NO-UNDO.
    DEFINE VARIABLE S-UNDVTA AS CHAR NO-UNDO.
    DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
    DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
    DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
    DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.
    DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
    DEFINE VARIABLE x-TipDto AS CHAR NO-UNDO.

    /* 1er Filtro: La lista de precios NO debe ser precios de FERIA */
    FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = pCodDiv NO-LOCK.
    IF GN-DIVI.CanalVenta = 'FER' THEN RETURN.
    /* 2do Filtro: La venta debe ser una venta Normal o Provincias */
    IF LOOKUP(s-TpoPed, 'P,N') = 0 THEN RETURN.
    /* Verificamos el cliente de acuerdo a la división de origen */
    /*IF LOOKUP(s-CodDiv, '00018,00019') = 0 THEN DO:     /* NI PROVINCIAS NI MESA REDONDA */*/
    /* RHC 29/02/2016 Quitamos */
    IF LOOKUP(s-CodDiv, '00018') = 0 THEN DO:     /* NO PROVINCIAS  */
        /* Buscamos clientes VIP */
        FIND FacTabla WHERE FacTabla.CodCia = s-codcia
            AND FacTabla.Tabla = "VIP3ROS"
            AND FacTabla.Codigo = Faccpedi.CodCli
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE FacTabla THEN RETURN.
    END.
    /* ************************************************************* */
    /* SE VA A DAR HASTA DOS VUELTAS PARA DETERMINAR LA LISTA A USAR */
    /* ************************************************************* */
    /* Actualizamos datos del temporal */
    EMPTY TEMP-TABLE ITEM.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.Libre_c05 <> "OF":
        CREATE ITEM.
        BUFFER-COPY Facdpedi TO ITEM.
    END.
    /* ******************************* */
    DEF VAR x-Ciclos AS INT NO-UNDO.
    DEF VAR x-ImpTot AS DEC NO-UNDO.
    DEF VAR x-ListaTerceros AS INT INIT 0 NO-UNDO.  /* Lista por defecto */
    DEF VAR x-ListaAnterior AS INT NO-UNDO.
    DEF VAR F-PREBAS AS DEC NO-UNDO.
    DEF VAR S-TPOCMB AS DEC NO-UNDO.
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = Faccpedi.codcli
        NO-LOCK.
    x-ListaAnterior = gn-clie.Libre_d01.
    /* *********** */
    IF x-ListaAnterior > 3 THEN x-ListaAnterior = 3.    /* Valor Máximo */
    /* RHC 14/12/2015 Tomamos el valor por defecto en el cliente, puede ser de 0 a 3 */
    x-ListaTerceros = x-ListaAnterior.
    /* ***************************************************************************** */
    FIND FIRST FacTabla WHERE FacTabla.CodCia = s-codcia
        AND FacTabla.Tabla = 'RLP3ROS' NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacTabla THEN RETURN.
    DO x-Ciclos = 1 TO 2:
        /* Tomamos el importe final */
        x-ImpTot = 0.
        FOR EACH ITEM:
            x-ImpTot = x-ImpTot + ITEM.ImpLin.
        END.
        IF Faccpedi.codmon = 2 THEN x-ImpTot = x-ImpTot * Faccpedi.TpoCmb.
        /* Decidimos cual lista tomar */
        DEF VAR k AS INT NO-UNDO.
        DO k = 1 TO 3:
            IF k < 3 AND x-ImpTot >= FacTabla.Valor[k] AND x-ImpTot < FacTabla.Valor[k + 1] THEN DO:
                x-ListaTerceros = k.
                LEAVE.
            END.
            IF k = 3 AND x-ImpTot >= FacTabla.Valor[k] THEN x-ListaTerceros = k.
        END.
        /* Tomamos el mejor */
        x-ListaTerceros = MAXIMUM(x-ListaAnterior,x-ListaTerceros).
        IF x-ListaTerceros = 0 THEN RETURN. /* El importe de venta NO llega al mínimo necesario */
        IF x-ListaTerceros > 3 THEN x-ListaTerceros = 3.    /* Valor Máximo */
        /* Actualizamos Precios de Venta */
        FOR EACH ITEM WHERE ITEM.Libre_c05 <> "OF", 
            FIRST Almmmatg OF ITEM NO-LOCK,
            FIRST ListaTerceros OF ITEM NO-LOCK:
            IF ListaTerceros.PreOfi[x-ListaTerceros] = 0 THEN NEXT.
            F-PREBAS = ListaTerceros.PreOfi[x-ListaTerceros].
            S-TPOCMB = Almmmatg.TpoCmb.
            IF Faccpedi.CodMon = 1 THEN DO:
                IF Almmmatg.MonVta = 1 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
                ELSE ASSIGN F-PREBAS = F-PREBAS * S-TPOCMB /** F-FACTOR*/.
            END.
            IF Faccpedi.CodMon = 2 THEN DO:
                IF Almmmatg.MonVta = 2 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
                ELSE ASSIGN F-PREBAS = (F-PREBAS / S-TPOCMB) /** F-FACTOR*/.
            END.
            ASSIGN
                ITEM.Por_Dsctos[1] = 0
                ITEM.Por_Dsctos[2] = 0
                ITEM.Por_Dsctos[3] = 0
                ITEM.PreBas = F-PREBAS
                ITEM.PreUni = F-PREBAS
                ITEM.Libre_c04 = "LP3ROS"
                ITEM.Libre_d01 = x-ListaTerceros.
            /* Recalculamos registro */
            /*MESSAGE 'la cagada' f-prebas.*/
            ASSIGN
                ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                              ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                              ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                              ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
            /* ****************************************** */
            /* RHC 15/12/2015 AGREGAMOS EL FLETE UNITARIO */
            /* ****************************************** */
            ASSIGN
                ITEM.ImpDto = 0
                ITEM.Libre_d02 = 0
                f-FleteUnitario = 0.
            RUN vta2/PrecioMayorista-Cred-v2 (
                Faccpedi.TpoPed,
                pCodDiv,
                Faccpedi.CodCli,
                Faccpedi.CodMon,
                INPUT-OUTPUT s-UndVta,
                OUTPUT f-Factor,
                ITEM.CodMat,
                Faccpedi.FmaPgo,
                ITEM.CanPed,
                Faccpedi.Libre_d01,
                OUTPUT f-PreBas,
                OUTPUT f-PreVta,
                OUTPUT f-Dsctos,
                OUTPUT y-Dsctos,
                OUTPUT z-Dsctos,
                OUTPUT x-TipDto,
                OUTPUT f-FleteUnitario,
                ITEM.TipVta,
                NO
                ).
            IF RETURN-VALUE <> 'ADM-ERROR' AND f-FleteUnitario > 0 THEN DO:
                ASSIGN
                    ITEM.Libre_d02 = f-FleteUnitario.
                /* El flete afecta el monto final */
                IF ITEM.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
                    ASSIGN
                        ITEM.PreUni = ROUND(ITEM.PreUni + ITEM.Libre_d02, s-NroDec)  /* Incrementamos el PreUni */
                        ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni.
                END.
                ELSE DO:      /* CON descuento promocional o volumen */
                    ASSIGN
                        ITEM.ImpLin = ITEM.ImpLin + (ITEM.CanPed * f-FleteUnitario)
                        ITEM.PreUni = ROUND( (ITEM.ImpLin + ITEM.ImpDto) / ITEM.CanPed, s-NroDec).
                END.
            END.
            /* ****************************************** */
            /* ****************************************** */
            ASSIGN
                ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
                ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
            IF ITEM.AftIsc 
            THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
            ELSE ITEM.ImpIsc = 0.
            IF ITEM.AftIgv 
            THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
            ELSE ITEM.ImpIgv = 0.
        END.
    END.
    IF x-ListaTerceros = 0 THEN RETURN.
    /* Ahora sí grabamos la información */
    DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
        FOR EACH ITEM WHERE ITEM.Libre_c04 = "LP3ROS", FIRST Almmmatg OF ITEM NO-LOCK,
            FIRST Almsfami OF Almmmatg NO-LOCK:
            FIND Facdpedi OF Faccpedi WHERE Facdpedi.codmat = ITEM.codmat
                AND Facdpedi.Libre_c05 <> "OF" EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Facdpedi THEN DO:
                MESSAGE 'NO se pudo bloquear el registro del código:' ITEM.codmat
                    VIEW-AS ALERT-BOX ERROR.
                UNDO, RETURN ERROR.
            END.
            BUFFER-COPY ITEM TO Facdpedi.
            /* RHC 07/11/2013 CALCULO DE PERCEPCION */
            DEF VAR s-PorPercepcion AS DEC INIT 0 NO-UNDO.
            ASSIGN
                Facdpedi.CanSol = 0
                Facdpedi.CanApr = 0.
            FIND FIRST Vtatabla WHERE Vtatabla.codcia = s-codcia
                AND Vtatabla.tabla = 'CLNOPER'
                AND VtaTabla.Llave_c1 = s-CodCli
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Vtatabla THEN DO:
                IF gn-clie.Libre_L01 = YES AND gn-clie.RucOld <> "SI" THEN s-Porpercepcion = 0.5.
                IF gn-clie.Libre_L01 = NO AND gn-clie.RucOld <> "SI" THEN s-Porpercepcion = 2.
                /* Ic 04 Julio 2013 
                    gn-clie.Libre_L01   : PERCEPCTOR
                    gn-clie.RucOld      : RETENEDOR
                */
                IF s-Cmpbnte = "BOL" THEN s-Porpercepcion = 2.
                IF Almsfami.Libre_c05 = "SI" THEN
                    ASSIGN
                    Facdpedi.CanSol = s-PorPercepcion
                    Facdpedi.CanApr = ROUND(Facdpedi.implin * s-PorPercepcion / 100, 2).
            END.
        END.
        ASSIGN
            FacCPedi.TipBon[10] = x-ListaTerceros.      /* Control de Lista de Terceros */
    END.


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

  RUN mostrar-cot(INPUT NO).

    fill-in-desde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 180,"99/99/9999").
    fill-in-hasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").

    COMBO-BOX-LP:DELETE(COMBO-BOX-LP:NUM-ITEMS) IN FRAME {&FRAME-NAME}.


    RUN cargar-lp.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mostrar-cot W-Win 
PROCEDURE mostrar-cot :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pOnOff AS LOG.

browse-2:VISIBLE IN FRAME {&FRAME-NAME} = pOnOff .
/*radio-set-cambiar:VISIBLE IN FRAME {&FRAME-NAME} = pOnOff .*/
radio-set-filtro:VISIBLE IN FRAME {&FRAME-NAME} = pOnOff .
button-2:VISIBLE IN FRAME {&FRAME-NAME} = pOnOff .
button-3:VISIBLE IN FRAME {&FRAME-NAME} = pOnOff .

DO WITH FRAME {&FRAME-NAME} :
    IF pOnOff = NO THEN DO:
        ENABLE fill-in-division.
        /*ENABLE fill-in-vendedor.*/
        ENABLE fill-in-desde.
        ENABLE fill-in-hasta.
        ENABLE combo-box-lp.
    END.
    ELSE DO:
        DISABLE fill-in-division.
        /*DISABLE fill-in-vendedor.*/
        DISABLE fill-in-desde.
        DISABLE fill-in-hasta.
        DISABLE combo-box-lp.
    END.
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
DEF INPUT PARAMETER pParam AS CHAR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recalcula-cotizacion W-Win 
PROCEDURE recalcula-cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETE pDivCot AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pCoddoc AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pNroDoc AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

DEFINE VAR x-retval AS CHAR NO-UNDO.

/* SOLO PARA EVENTOS */
DISABLE TRIGGERS FOR LOAD OF faccpedi.
DISABLE TRIGGERS FOR LOAD OF facdpedi.

EMPTY TEMP-TABLE ITEM.
EMPTY TEMP-TABLE ErroresxLinea.

DEFINE VARIABLE X-CANPED AS DECI NO-UNDO.
DEFINE VARIABLE S-UNDVTA AS CHAR NO-UNDO.
DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE x-tipdto AS CHAR NO-UNDO.
DEFINE VARIABLE x-imptot LIKE faccpedi.imptot NO-UNDO.
DEFINE VARIABLE f-FleteUnitario AS DEC DECIMALS 6 NO-UNDO.
DEFINE VAR x-fecha-desde AS DATE.
DEF VAR x-cl-codcia AS INT    INIT 000        NO-UNDO.
DEF VAR x-PorPercepcion AS  DEC INIT 0      NO-UNDO.
DEF VAR p-pcoddiv   AS CHAR   INIT ''    NO-UNDO.    /* Lista de Precio */

/*
DEF VAR s-coddoc  AS CHAR   INIT "COT"      NO-UNDO.
*/

p-pcoddiv = combo-box-lp.

x-retval = "OK".

GRABAR_DATOS:            
DO TRANSACTION ON ERROR UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS:
    DO:
        FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND 
                                    faccpedi.coddiv = pDivCot AND
                                    faccpedi.coddoc = pCodDoc AND
                                    faccpedi.nroped = pNroDoc EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE faccpedi THEN DO:
            x-retval = ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
        END.
        IF ERROR-STATUS:ERROR THEN DO:     
            x-retval = ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
        END.                    

        x-ImpTot = Faccpedi.ImpTot.
        /* FILTROS */
        FIND gn-clie WHERE gn-clie.codcia = x-cl-codcia
            AND gn-clie.codcli = faccpedi.codcli
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-clie THEN DO:
            IF ERROR-STATUS:ERROR THEN DO:     
                x-retval = ERROR-STATUS:GET-MESSAGE(1).
                UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
            END.                    
        END.
        /* ************ */
        ASSIGN
            s-CODMON = FacCPedi.CodMon
            s-CODCLI = FacCPedi.CodCli
            s-TPOCMB = FacCPedi.TpoCmb
            s-CNDVTA = FacCPedi.FmaPgo
            s-PorIgv = Faccpedi.porigv
            s-NroDec = (IF Faccpedi.Libre_d01 <= 0 THEN 4 ELSE Faccpedi.Libre_d01)
            s-FlgIgv = Faccpedi.FlgIgv
            pcoddiv = faccpedi.coddiv
            s-coddiv = faccpedi.coddiv
            s-Cmpbnte = Faccpedi.cmpbnte.

       FOR EACH Facdpedi OF Faccpedi WHERE Facdpedi.Libre_c05 <> "OF", 
           FIRST Almmmatg OF Facdpedi NO-LOCK:
           ASSIGN
               x-CanPed = Facdpedi.CanPed
               s-UndVta = Facdpedi.UndVta.

           RUN vtagn/precio-venta-general-v01.r(
               faccpedi.tpoped  /*s-TpoPed*/,
               faccpedi.libre_c01  /* pCodDiv*/,
               s-CodCli,
               s-CodMon,
               INPUT-OUTPUT s-UndVta,
               OUTPUT f-Factor,
               Almmmatg.CodMat,
               s-CndVta,
               x-CanPed,
               s-NroDec,
               OUTPUT f-PreBas,
               OUTPUT f-PreVta,
               OUTPUT f-Dsctos,
               OUTPUT y-Dsctos,
               OUTPUT z-Dsctos,
               OUTPUT x-TipDto,
               "",
               OUTPUT f-FleteUnitario,
               "",
               FALSE
               ) NO-ERROR.

           IF ERROR-STATUS:ERROR THEN DO:     
               x-retval = ERROR-STATUS:GET-MESSAGE(1).
               UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
           END.                    

           ASSIGN 
               Facdpedi.Factor = F-FACTOR
               Facdpedi.PorDto = F-DSCTOS      /* Ambos descuentos afectan */
               Facdpedi.PorDto2 = 0            /* el precio unitario */
               Facdpedi.PreBas = F-PreBas 
               Facdpedi.PreVta[1] = F-PreVta     /* CONTROL DE PRECIO DE LISTA */
               Facdpedi.UndVta = s-UndVta
               Facdpedi.PreUni = F-PREVTA
               Facdpedi.Libre_d02 = f-FleteUnitario    /* Flete Unitario */
               Facdpedi.Por_Dsctos[1] = 0
               Facdpedi.Por_Dsctos[2] = z-Dsctos
               Facdpedi.Por_Dsctos[3] = y-Dsctos
               /*Facdpedi.AftIgv = (IF s-CndVta = '900' THEN NO ELSE Almmmatg.AftIgv)*/
               Facdpedi.AftIgv = Almmmatg.AftIgv
               Facdpedi.AftIsc = Almmmatg.AftIsc
               Facdpedi.Libre_c04 = x-TipDto
               Facdpedi.ImpIsc = 0
               Facdpedi.ImpIgv = 0 NO-ERROR.

           IF ERROR-STATUS:ERROR THEN DO:     
               x-retval = ERROR-STATUS:GET-MESSAGE(1).
               UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
           END.                    

           ASSIGN
               Facdpedi.ImpLin = ROUND ( Facdpedi.CanPed * Facdpedi.PreUni * 
                             ( 1 - Facdpedi.Por_Dsctos[1] / 100 ) *
                             ( 1 - Facdpedi.Por_Dsctos[2] / 100 ) *
                             ( 1 - Facdpedi.Por_Dsctos[3] / 100 ), 2 ) NO-ERROR.

           IF ERROR-STATUS:ERROR THEN DO:     
               x-retval = ERROR-STATUS:GET-MESSAGE(1).
               UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
           END.                    

           IF Facdpedi.Por_Dsctos[1] = 0 AND Facdpedi.Por_Dsctos[2] = 0 AND Facdpedi.Por_Dsctos[3] = 0 
               THEN Facdpedi.ImpDto = 0.
               ELSE Facdpedi.ImpDto = Facdpedi.CanPed * Facdpedi.PreUni - Facdpedi.ImpLin NO-ERROR.

            IF ERROR-STATUS:ERROR THEN DO:     
                x-retval = ERROR-STATUS:GET-MESSAGE(1).
                UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
            END.                    

           /* RHC 04/08/2015 Si existe f-FleteUnitario se recalcula el Descuento */
           IF f-FleteUnitario > 0 THEN DO:
               /* El flete afecta el monto final */
               IF Facdpedi.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
                   ASSIGN
                       Facdpedi.PreUni = ROUND(f-PreVta + f-FleteUnitario, s-NroDec)  /* Incrementamos el PreUni */
                       Facdpedi.ImpLin = Facdpedi.CanPed * Facdpedi.PreUni NO-ERROR.

                   IF ERROR-STATUS:ERROR THEN DO:     
                       x-retval = ERROR-STATUS:GET-MESSAGE(1).
                       UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
                   END.                    

               END.
               ELSE DO:      /* CON descuento promocional o volumen */
                   ASSIGN
                       Facdpedi.ImpLin = Facdpedi.ImpLin + (Facdpedi.CanPed * f-FleteUnitario)
                       Facdpedi.PreUni = ROUND( (Facdpedi.ImpLin + Facdpedi.ImpDto) / Facdpedi.CanPed, s-NroDec) NO-ERROR.

                   IF ERROR-STATUS:ERROR THEN DO:     
                       x-retval = ERROR-STATUS:GET-MESSAGE(1).
                       UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
                   END.                    

               END.
           END.
           /* ***************************************************************** */
           ASSIGN
               Facdpedi.ImpLin = ROUND(Facdpedi.ImpLin, 2)
               Facdpedi.ImpDto = ROUND(Facdpedi.ImpDto, 2).
           IF Facdpedi.AftIsc 
           THEN Facdpedi.ImpIsc = ROUND(Facdpedi.PreBas * Facdpedi.CanPed * (Almmmatg.PorIsc / 100),4).
           ELSE Facdpedi.ImpIsc = 0.
           IF Facdpedi.AftIgv 
           THEN Facdpedi.ImpIgv = Facdpedi.ImpLin - ROUND( Facdpedi.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
           ELSE Facdpedi.ImpIgv = 0.

            /* ********* */
            /* RHC 07/11/2013 CALCULO DE PERCEPCION */
            ASSIGN
                Facdpedi.CanSol = 0
                Facdpedi.CanApr = 0.
            FIND FIRST Vtatabla WHERE Vtatabla.codcia = s-codcia
                AND Vtatabla.tabla = 'CLNOPER'
                AND VtaTabla.Llave_c1 = s-CodCli
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Vtatabla THEN DO:
                IF gn-clie.Libre_L01 = YES AND gn-clie.RucOld <> "SI" THEN x-Porpercepcion = 0.5.
                IF gn-clie.Libre_L01 = NO AND gn-clie.RucOld <> "SI" THEN x-Porpercepcion = 2.
                /* Ic 04 Julio 2013 
                    gn-clie.Libre_L01   : PERCEPCTOR
                    gn-clie.RucOld      : RETENEDOR
                */
                IF s-Cmpbnte = "BOL" THEN x-Porpercepcion = 2.
                FIND Almsfami OF Almmmatg NO-LOCK NO-ERROR.
                IF AVAILABLE Almsfami AND Almsfami.Libre_c05 = "SI" THEN
                    ASSIGN
                    Facdpedi.CanSol = x-PorPercepcion
                    Facdpedi.CanApr = ROUND(Facdpedi.implin * x-PorPercepcion / 100, 2).
            END.
       END.
       /**/
       RUN Descuentos-Finales-01.

       RUN Descuentos-Finales-02.

       /* RHC 06/07/17 Descuentos por saldo resumido solo para Expolibreria */
       RUN Descuentos-Finales-04.        

       /* **************************************************************** */
       /* RHC 18/11/2015 RUTINA ESPECIAL PARA LISTA DE PRECIOS DE TERCEROS */
       /* **************************************************************** */
       /*
       RUN Lista-Terceros NO-ERROR.
       IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
       */

       /* **************************************************************** */
       {vta2/graba-totales-cotizacion-cred.i}
    END.

   IF x-retval = 'OK' THEN DO:
       /* LOG */
       CREATE LogTabla.
       ASSIGN
         logtabla.codcia = s-codcia
         logtabla.Dia = TODAY
         logtabla.Evento = 'WRITE'
         logtabla.Hora = STRING(TIME, 'HH:MM')
         logtabla.Tabla = 'FACCPEDI'
         logtabla.Usuario = USERID("DICTDB")
         logtabla.ValorLlave =   "RECALCULO-COTIZACION" + '|' +
                                 STRING(s-codcia) + '|' +
                                 TRIM(pDivCot) + '|' +
                                 TRIM(pCodDoc) + '|' +
                                 TRIM(pNroDoc) NO-ERROR.
   END.

END.

pRetVal = x-retval.

RELEASE faccpedi.
RELEASE facdpedi.
RELEASE logtabla.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recalcular-cotizaciones W-Win 
PROCEDURE recalcular-cotizaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

    pRetVal = "PROCESANDO".

    SESSION:SET-WAIT-STATE("GENERAL").

    DEFINE VAR x-retval AS CHAR.
    DEFINE VAR x-total-cot AS INT.
    DEFINE VAR x-total-cot-ok AS INT.

    FOR EACH tfaccpedi :
        IF NOT (TRUE <> (tfaccpedi.libre_c04 > "")) THEN DO:
            RUN recalcula-cotizacion(INPUT tfaccpedi.coddiv, INPUT tfaccpedi.coddoc,
                                    INPUT tfaccpedi.nroped, OUTPUT x-retval).

            x-total-cot = x-total-cot + 1.
            IF x-retval = 'OK' THEN DO:
                x-total-cot-ok = x-total-cot-ok + 1.
                ASSIGN tfaccpedi.libre_c04 = "".
            END.
            ELSE DO:
                ASSIGN tfaccpedi.libre_c04 = x-retval.
            END.

        END.
    END.

    {&open-query-browse-2}

    SESSION:SET-WAIT-STATE("").

    MESSAGE "Se recalcularon " + STRING(x-total-cot-ok) + " de " + STRING(x-total-cot) + " Cotizacion(es)"
            VIEW-AS ALERT-BOX INFORMATION.

    IF x-total-cot > 0 AND x-total-cot = x-total-cot-ok THEN pRetVal = "OK".

END PROCEDURE.

/*                                                                                
DEFINE OUTPUT PARAMETER pMsg AS CHAR NO-UNDO.
           
DEFINE VAR x-msg AS CHAR.

x-msg = "OK".

SESSION:SET-WAIT-STATE("GENERAL").

GRABAR_DATOS:            
DO TRANSACTION ON ERROR UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS:
    DO:
        FOR EACH tfaccpedi :
            IF NOT (TRUE <> (tfaccpedi.libre_c04 > "")) OR 
                NOT (TRUE <> (tfaccpedi.libre_c05 > ""))
                    THEN DO:
                
                FIND FIRST faccpedi OF tfaccpedi EXCLUSIVE-LOCK NO-ERROR.
                IF ERROR-STATUS:ERROR THEN DO:     
                    x-msg = ERROR-STATUS:GET-MESSAGE(1).
                    UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
                END.                    
                IF NOT AVAILABLE faccpedi THEN DO:
                    x-msg = "La tabla FACCPEDI esta usado por otro usuario".
                    UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
                END.

                /* Actualizamos */
                IF NOT (TRUE <> (tfaccpedi.libre_c04 > "")) THEN DO:
                    ASSIGN faccpedi.coddiv = tfaccpedi.libre_c04.
                END.
                IF NOT (TRUE <> (tfaccpedi.libre_c05 > "")) THEN DO:
                    ASSIGN faccpedi.codven = tfaccpedi.libre_c05.
                END.

                /* LOG */
                CREATE LogTabla.
                ASSIGN
                  logtabla.codcia = s-codcia
                  logtabla.Dia = TODAY
                  logtabla.Evento = 'WRITE'
                  logtabla.Hora = STRING(TIME, 'HH:MM')
                  logtabla.Tabla = 'FACCPEDI'
                  logtabla.Usuario = USERID("DICTDB")
                  logtabla.ValorLlave =   "REASIGNAR DIV_VEN" + '|' +
                                          STRING(tfaccpedi.codcia) + '|' +
                                          TRIM(tfaccpedi.coddoc) + '|' +
                                          TRIM(tfaccpedi.nroped) + '|' +
                                          TRIM(tfaccpedi.coddiv) + '|' +
                                          TRIM(tfaccpedi.codven) NO-ERROR.
                IF ERROR-STATUS:ERROR THEN DO:     
                    x-msg = ERROR-STATUS:GET-MESSAGE(1).
                    UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
                END.                    

            END.
        END.
    END.
END. /* TRANSACTION block */

RELEASE faccpedi.
RELEASE logtabla.

pMsg = x-msg.

SESSION:SET-WAIT-STATE("").

IF x-msg = "OK" THEN DO:
    MESSAGE "Se RECALCULARON CON EXITO las cotizaciones"
            VIEW-AS ALERT-BOX INFORMATION.
END.
ELSE DO:
    MESSAGE "Hubo problemas al recalcular la cotizaciones" SKIP
            x-msg
            VIEW-AS ALERT-BOX INFORMATION.

END.

END PROCEDURE.
*/

/*

  CREATE LogTabla.
  ASSIGN
    logtabla.codcia = s-codcia
    logtabla.Dia = TODAY
    logtabla.Evento = 'WRITE'
    logtabla.Hora = STRING(TIME, 'HH:MM')
    logtabla.Tabla = 'GN-CLIE'
    logtabla.Usuario = s-user-id
    logtabla.ValorLlave = STRING(gn-clie.codcia, '999') + '|' +
                            STRING(gn-clie.codcli, 'x(11)').
 RELEASE LogTabla. 


*/

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
  {src/adm/template/snd-list.i "tFacCPedi"}

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

