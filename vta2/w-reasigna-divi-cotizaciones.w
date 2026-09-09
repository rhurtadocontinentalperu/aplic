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

DEF NEW SHARED VAR lh_handle AS HANDLE.

DEFINE VAR x-filtro AS INT INIT 1.

DEFINE BUFFER b-facdpedi FOR facdpedi.

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
tFacCPedi.CodVen tFacCPedi.Libre_c04 tFacCPedi.Libre_c05 
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
BUTTON-1 FILL-IN-division FILL-IN-vendedor RADIO-SET-cambiar BUTTON-2 ~
BUTTON-3 RADIO-SET-filtro BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-LP FILL-IN-desde FILL-IN-hasta ~
FILL-IN-division FILL-IN-vendedor FILL-IN-ddivision FILL-IN-dvendedor ~
RADIO-SET-cambiar RADIO-SET-filtro 

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
     LABEL "Grabar CAMBIOS?" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-3 
     LABEL "Cancelar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX-LP AS CHARACTER FORMAT "X(50)":U 
     LABEL "Lista de Precios" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 53 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-ddivision AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-division AS CHARACTER FORMAT "X(6)":U 
     LABEL "Nueva division" 
     VIEW-AS FILL-IN 
     SIZE 7.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-dvendedor AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-vendedor AS CHARACTER FORMAT "X(5)":U 
     LABEL "Nuevo vendedor" 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-cambiar AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Division/Vendedor", 1,
"Solo Division", 2,
"Solo Vendedor", 3
     SIZE 19 BY 3
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE RADIO-SET-filtro AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Mostrar Todo", 1,
"Solo Cambios", 2
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
      tFacCPedi.Libre_c04 COLUMN-LABEL "Nueva!Division" FORMAT "x(6)":U
      tFacCPedi.Libre_c05 COLUMN-LABEL "Nuevo!Vendedor" FORMAT "x(6)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 116 BY 18.85
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-LP AT ROW 1.15 COL 12 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-desde AT ROW 2.27 COL 12 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-hasta AT ROW 2.27 COL 32.57 COLON-ALIGNED WIDGET-ID 8
     BUTTON-1 AT ROW 2.08 COL 52.43 WIDGET-ID 4
     FILL-IN-division AT ROW 1.23 COL 91.14 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-vendedor AT ROW 2.15 COL 91.14 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-ddivision AT ROW 1.19 COL 102 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-dvendedor AT ROW 2.15 COL 102 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     RADIO-SET-cambiar AT ROW 3.88 COL 121 NO-LABEL WIDGET-ID 18
     BUTTON-2 AT ROW 8.88 COL 121 WIDGET-ID 22
     BUTTON-3 AT ROW 10.12 COL 121.29 WIDGET-ID 24
     RADIO-SET-filtro AT ROW 19.08 COL 122 NO-LABEL WIDGET-ID 26
     BROWSE-2 AT ROW 3.31 COL 3 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 143.14 BY 21.85
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "REASIGNA COTIZACIONES DE PRE-VENTA - DIVISIONES"
         HEIGHT             = 21.85
         WIDTH              = 143.14
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
/* SETTINGS FOR FILL-IN FILL-IN-ddivision IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-dvendedor IN FRAME F-Main
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
"tFacCPedi.Libre_c04" "Nueva!Division" "x(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tFacCPedi.Libre_c05
"tFacCPedi.Libre_c05" "Nuevo!Vendedor" "x(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REASIGNA COTIZACIONES DE PRE-VENTA - DIVISIONES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REASIGNA COTIZACIONES DE PRE-VENTA - DIVISIONES */
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


  ASSIGN radio-set-cambiar.

  DO WITH FRAME {&FRAME-NAME} :
      IF AVAILABLE tfaccpedi THEN DO:

          DEFINE VAR x-llave AS CHAR.

          x-llave = "REASIGNAR DIV_VEN" + '|' +
                    STRING(tfaccpedi.codcia) + '|' +
                    TRIM(tfaccpedi.coddoc) + '|' +
                    TRIM(tfaccpedi.nroped) + '|'.

          FIND FIRST logtabla WHERE logtabla.codcia = s-codcia AND
                                        logtabla.tabla = "FACCPEDI" AND
                                        logtabla.valorllave BEGINS x-llave NO-LOCK NO-ERROR.

          IF AVAILABLE logtabla THEN DO:
              MESSAGE "La cotizacion ya se le reasigno la division y/o vendedor"
                        VIEW-AS ALERT-BOX INFORMATION.
              RETURN NO-APPLY.
          END.

          IF radio-set-cambiar = 1 THEN DO:
              IF tfaccpedi.libre_c03 = "X2XX" THEN DO:
                  ASSIGN tfaccpedi.libre_c04:SCREEN-VALUE IN BROWSE {&browse-name} = ""
                            tfaccpedi.libre_c05:SCREEN-VALUE IN BROWSE {&browse-name} = "".

                  ASSIGN    tfaccpedi.libre_c03 = ""
                            tfaccpedi.libre_c04 = ""
                            tfaccpedi.libre_c05 = "".
              END.
              ELSE DO:
                  ASSIGN tfaccpedi.libre_c04:SCREEN-VALUE IN BROWSE {&browse-name} = FILL-in-division
                            tfaccpedi.libre_c05:SCREEN-VALUE IN BROWSE {&browse-name} = FILL-in-vendedor.

                  ASSIGN    tfaccpedi.libre_c03 = "X2XX"
                            tfaccpedi.libre_c04 = FILL-in-division
                            tfaccpedi.libre_c05 = FILL-in-vendedor.
              END.
          END.
          IF radio-set-cambiar = 2 THEN DO:
              IF tfaccpedi.libre_c03 = "X2XX" THEN DO:
                  ASSIGN tfaccpedi.libre_c04:SCREEN-VALUE IN BROWSE {&browse-name} = ""
                        tfaccpedi.libre_c05:SCREEN-VALUE IN BROWSE {&browse-name} = "".
                  ASSIGN tfaccpedi.libre_c04 = ""
                        tfaccpedi.libre_c05 = ""
                        tfaccpedi.libre_c03 = "".
              END.
              ELSE DO:
                  ASSIGN tfaccpedi.libre_c04:SCREEN-VALUE IN BROWSE {&browse-name} = FILL-in-division.
                  ASSIGN tfaccpedi.libre_c04 = FILL-in-division
                        tfaccpedi.libre_c03 = "X2XX".
              END.
          END.
          IF radio-set-cambiar = 3 THEN DO:
              IF tfaccpedi.libre_c03 = "X2XX" THEN DO:
                  ASSIGN tfaccpedi.libre_c04:SCREEN-VALUE IN BROWSE {&browse-name} = ""
                        tfaccpedi.libre_c05:SCREEN-VALUE IN BROWSE {&browse-name} = "".
                  ASSIGN tfaccpedi.libre_c04 = ""
                        tfaccpedi.libre_c05 = ""
                        tfaccpedi.libre_c03 = "".
              END.
              ELSE DO:
                  ASSIGN tfaccpedi.libre_c05:SCREEN-VALUE IN BROWSE {&browse-name} = FILL-in-vendedor.
                  ASSIGN tfaccpedi.libre_c05 = FILL-in-vendedor
                        tfaccpedi.libre_c03 = "X2XX".
              END.
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

  ASSIGN combo-box-lp fill-in-desde fill-in-hasta fill-in-vendedor fill-in-division.

  IF fill-in-desde > fill-in-hasta THEN DO:
      MESSAGE "Rango de Fechas ERRADAS".
      RETURN NO-APPLY.
  END.
  
  FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND
                            gn-divi.coddiv = fill-in-division NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-divi THEN DO:
      MESSAGE "Division no existe".
      RETURN NO-APPLY.
  END.

  FIND FIRST gn-ven WHERE gn-ven.codcia = s-codcia AND
                            gn-ven.codven = fill-in-vendedor NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-ven THEN DO:
      MESSAGE "Vendedor no existe".
      RETURN NO-APPLY.
  END.


  RUN cargar-cotizaciones(INPUT combo-box-lp).

  RUN mostrar-cot(INPUT YES).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Grabar CAMBIOS? */
DO:
        MESSAGE 'Seguro de GRABAR los CAMBIOS?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.


    DEFINE VAR x-retval AS CHAR.

    RUN grabar-cambios(OUTPUT x-retval).

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
ON LEAVE OF FILL-IN-division IN FRAME F-Main /* Nueva division */
DO:
    DEFINE VAR x-dato AS CHAR.

    x-dato = SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    fill-in-ddivision:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND
                              gn-divi.coddiv = x-dato NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN DO:
        fill-in-ddivision:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-divi.desdiv.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-vendedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-vendedor W-Win
ON LEAVE OF FILL-IN-vendedor IN FRAME F-Main /* Nuevo vendedor */
DO:
    DEFINE VAR x-dato AS CHAR.

    x-dato = SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    fill-in-dvendedor:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

    FIND FIRST gn-ven WHERE gn-ven.codcia = s-codcia AND
                              gn-ven.codven = x-dato NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN DO:
        fill-in-dvendedor:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-ven.nomven.
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
                        faccpedi.libre_c01 = pListaPrecio AND
                        (faccpedi.fchped >= fill-in-desde AND faccpedi.fchped <= fill-in-hasta) AND
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
  DISPLAY COMBO-BOX-LP FILL-IN-desde FILL-IN-hasta FILL-IN-division 
          FILL-IN-vendedor FILL-IN-ddivision FILL-IN-dvendedor RADIO-SET-cambiar 
          RADIO-SET-filtro 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-LP FILL-IN-desde FILL-IN-hasta BUTTON-1 FILL-IN-division 
         FILL-IN-vendedor RADIO-SET-cambiar BUTTON-2 BUTTON-3 RADIO-SET-filtro 
         BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-cambios W-Win 
PROCEDURE grabar-cambios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pMsg AS CHAR NO-UNDO.
           
DEFINE VAR x-msg AS CHAR.
DEFINE VAR x-rowid AS ROWID.

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

                    /* Cambiamos la division en el detalle */
                    FOR EACH facdpedi WHERE facdpedi.codcia = faccpedi.codcia AND
                                        facdpedi.coddoc = faccpedi.coddoc AND
                                        facdpedi.nroped = faccpedi.nroped NO-LOCK:
                        x-rowid = ROWID(facdpedi).
                        FIND FIRST b-facdpedi WHERE ROWID(b-facdpedi) = x-rowid EXCLUSIVE-LOCK NO-ERROR.
                        IF ERROR-STATUS:ERROR THEN DO:     
                            x-msg = ERROR-STATUS:GET-MESSAGE(1).
                            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
                        END.                    
                        IF AVAILABLE b-facdpedi THEN DO:
                            ASSIGN b-facdpedi.coddiv = tfaccpedi.libre_c04.
                        END.
                        ELSE DO:
                            IF ERROR-STATUS:ERROR THEN DO:     
                                x-msg = "No existe el documento (" + faccpedi.coddiv + ")" .
                                UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
                            END.                    
                        END.
                    END.
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
    MESSAGE "Se grabaron los cambios correctamente"
            VIEW-AS ALERT-BOX INFORMATION.
END.
ELSE DO:
    MESSAGE "Hubo problemas al grabar los cambios" SKIP
            x-msg
            VIEW-AS ALERT-BOX INFORMATION.

END.

END PROCEDURE.

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
radio-set-cambiar:VISIBLE IN FRAME {&FRAME-NAME} = pOnOff .
radio-set-filtro:VISIBLE IN FRAME {&FRAME-NAME} = pOnOff .
button-2:VISIBLE IN FRAME {&FRAME-NAME} = pOnOff .
button-3:VISIBLE IN FRAME {&FRAME-NAME} = pOnOff .

DO WITH FRAME {&FRAME-NAME} :
    IF pOnOff = NO THEN DO:
        ENABLE fill-in-division.
        ENABLE fill-in-vendedor.
        ENABLE fill-in-desde.
        ENABLE fill-in-hasta.
        ENABLE combo-box-lp.
    END.
    ELSE DO:
        DISABLE fill-in-division.
        DISABLE fill-in-vendedor.
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

