&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tw-report-pi-dtl NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE tw-report-pi-hdr NO-UNDO LIKE w-report.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS F-Frame-Win 
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

  Description: from cntnrfrm.w - ADM SmartFrame Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

 
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

DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-serie AS INT.
DEFINE VAR x-numero AS INT.

DEFINE VAR x-serie-pi AS INT.
DEFINE VAR x-numero-pi AS INT.
DEFINE VAR x-tabla-vtatabla AS CHAR INIT "PI-PNC-DIFPRECIND".

DEFINE BUFFER x-tw-report-pi-dtl FOR tw-report-pi-dtl.
DEFINE BUFFER b-vtatabla FOR vtatabla.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartFrame
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tw-report-pi-hdr tw-report-pi-dtl

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tw-report-pi-hdr.Campo-I[1] ~
tw-report-pi-hdr.Campo-I[2] tw-report-pi-hdr.Campo-D[1] ~
tw-report-pi-hdr.Campo-C[1] tw-report-pi-hdr.Campo-C[2] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tw-report-pi-hdr NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tw-report-pi-hdr NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tw-report-pi-hdr
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tw-report-pi-hdr


/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 tw-report-pi-dtl.Campo-L[1] ~
tw-report-pi-dtl.Campo-C[1] tw-report-pi-dtl.Campo-C[2] ~
tw-report-pi-dtl.Campo-F[1] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH tw-report-pi-dtl ~
      WHERE tw-report-pi-dtl.campo-i[1] = x-serie-pi and ~
tw-report-pi-dtl.campo-i[2] = x-numero-pi NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH tw-report-pi-dtl ~
      WHERE tw-report-pi-dtl.campo-i[1] = x-serie-pi and ~
tw-report-pi-dtl.campo-i[2] = x-numero-pi NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 tw-report-pi-dtl
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 tw-report-pi-dtl


/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 tw-report-pi-dtl.Campo-I[1] ~
tw-report-pi-dtl.Campo-I[2] tw-report-pi-dtl.Campo-C[1] ~
tw-report-pi-dtl.Campo-C[2] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH tw-report-pi-dtl ~
      WHERE tw-report-pi-dtl.campo-l[1] = yes NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH tw-report-pi-dtl ~
      WHERE tw-report-pi-dtl.campo-l[1] = yes NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 tw-report-pi-dtl
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 tw-report-pi-dtl


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-3}~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 BROWSE-5 BROWSE-3 BUTTON-4 BUTTON-5 ~
BUTTON-6 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-codcli FILL-IN-cliente ~
FILL-IN-emision FILL-IN-importe FILL-IN-moneda FILL-IN-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-4 
     LABEL "Grabar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-5 
     LABEL "Todos" 
     SIZE 10 BY .88.

DEFINE BUTTON BUTTON-6 
     LABEL "Ninguno" 
     SIZE 10 BY .88.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U INITIAL "DobleClick en el articulo para seleccionar" 
      VIEW-AS TEXT 
     SIZE 36.14 BY .62
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-cliente AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
      VIEW-AS TEXT 
     SIZE 49 BY .62
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-codcli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Codigo" 
      VIEW-AS TEXT 
     SIZE 13 BY .62
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-emision AS DATE FORMAT "99/99/9999":U 
     LABEL "Emision" 
      VIEW-AS TEXT 
     SIZE 11.72 BY .62
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-importe AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Importe" 
      VIEW-AS TEXT 
     SIZE 11.72 BY .62
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-moneda AS CHARACTER FORMAT "X(25)":U 
     LABEL "Moneda" 
      VIEW-AS TEXT 
     SIZE 11.72 BY .62
     FGCOLOR 9 FONT 6 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tw-report-pi-hdr SCROLLING.

DEFINE QUERY BROWSE-3 FOR 
      tw-report-pi-dtl SCROLLING.

DEFINE QUERY BROWSE-5 FOR 
      tw-report-pi-dtl SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 F-Frame-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tw-report-pi-hdr.Campo-I[1] COLUMN-LABEL "Serie" FORMAT ">>9":U
      tw-report-pi-hdr.Campo-I[2] COLUMN-LABEL "Numero" FORMAT "99999999":U
      tw-report-pi-hdr.Campo-D[1] COLUMN-LABEL "Emision" FORMAT "99/99/9999":U
      tw-report-pi-hdr.Campo-C[1] COLUMN-LABEL "Alm" FORMAT "X(5)":U
      tw-report-pi-hdr.Campo-C[2] COLUMN-LABEL "Nombre Almacen" FORMAT "X(80)":U
            WIDTH 18.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 51 BY 7
         FONT 4
         TITLE "PARTES DE INGRESOS CON N/C" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 F-Frame-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      tw-report-pi-dtl.Campo-L[1] COLUMN-LABEL "Sele" FORMAT "Si/No":U
            WIDTH 3.29 VIEW-AS TOGGLE-BOX
      tw-report-pi-dtl.Campo-C[1] COLUMN-LABEL "Cod.Mat" FORMAT "X(8)":U
            WIDTH 7.43
      tw-report-pi-dtl.Campo-C[2] COLUMN-LABEL "Descripcion" FORMAT "X(80)":U
            WIDTH 39.43
      tw-report-pi-dtl.Campo-F[1] COLUMN-LABEL "Cantidad" FORMAT "->,>>>,>>9.99":U
            WIDTH 5.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 60.86 BY 10.54
         FONT 4
         TITLE "DETALLE DEL PARTE DE INGRESO" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 F-Frame-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      tw-report-pi-dtl.Campo-I[1] COLUMN-LABEL "PI!Serie" FORMAT ">>9":U
      tw-report-pi-dtl.Campo-I[2] COLUMN-LABEL "PI!Numero" FORMAT ">>>>>>9":U
      tw-report-pi-dtl.Campo-C[1] COLUMN-LABEL "Articulo" FORMAT "X(8)":U
            WIDTH 7.72
      tw-report-pi-dtl.Campo-C[2] COLUMN-LABEL "Descripcion" FORMAT "X(80)":U
            WIDTH 34.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 56.57 BY 10.96
         FONT 4
         TITLE "ARTICULOS QUE AFECTARAN A LA PNC -  DIF.PRECIO INDIV." FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-2 AT ROW 1.31 COL 2 WIDGET-ID 200
     BROWSE-5 AT ROW 8.15 COL 63.43 WIDGET-ID 400
     BROWSE-3 AT ROW 8.54 COL 2.14 WIDGET-ID 300
     BUTTON-4 AT ROW 19.23 COL 86 WIDGET-ID 2
     BUTTON-5 AT ROW 19.27 COL 4.29 WIDGET-ID 4
     BUTTON-6 AT ROW 19.27 COL 14.29 WIDGET-ID 6
     FILL-IN-codcli AT ROW 1.65 COL 63 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-cliente AT ROW 2.27 COL 63 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-emision AT ROW 3 COL 63 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-importe AT ROW 3.04 COL 82 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-moneda AT ROW 3.04 COL 102.29 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-1 AT ROW 19.42 COL 22.86 COLON-ALIGNED NO-LABEL WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 119.72 BY 19.35
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartFrame
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: tw-report-pi-dtl T "?" NO-UNDO INTEGRAL w-report
      TABLE: tw-report-pi-hdr T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW F-Frame-Win ASSIGN
         HEIGHT             = 19.35
         WIDTH              = 119.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB F-Frame-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW F-Frame-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME                                               */
/* BROWSE-TAB BROWSE-2 1 F-Main */
/* BROWSE-TAB BROWSE-5 BROWSE-2 F-Main */
/* BROWSE-TAB BROWSE-3 BROWSE-5 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-cliente IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-codcli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-emision IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-importe IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-moneda IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tw-report-pi-hdr"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tw-report-pi-hdr.Campo-I[1]
"tw-report-pi-hdr.Campo-I[1]" "Serie" ">>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tw-report-pi-hdr.Campo-I[2]
"tw-report-pi-hdr.Campo-I[2]" "Numero" "99999999" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tw-report-pi-hdr.Campo-D[1]
"tw-report-pi-hdr.Campo-D[1]" "Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tw-report-pi-hdr.Campo-C[1]
"tw-report-pi-hdr.Campo-C[1]" "Alm" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tw-report-pi-hdr.Campo-C[2]
"tw-report-pi-hdr.Campo-C[2]" "Nombre Almacen" "X(80)" "character" ? ? ? ? ? ? no ? no no "18.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.tw-report-pi-dtl"
     _Options          = "NO-LOCK"
     _Where[1]         = "tw-report-pi-dtl.campo-i[1] = x-serie-pi and
tw-report-pi-dtl.campo-i[2] = x-numero-pi"
     _FldNameList[1]   > Temp-Tables.tw-report-pi-dtl.Campo-L[1]
"tw-report-pi-dtl.Campo-L[1]" "Sele" ? "logical" ? ? ? ? ? ? no ? no no "3.29" yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[2]   > Temp-Tables.tw-report-pi-dtl.Campo-C[1]
"tw-report-pi-dtl.Campo-C[1]" "Cod.Mat" ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tw-report-pi-dtl.Campo-C[2]
"tw-report-pi-dtl.Campo-C[2]" "Descripcion" "X(80)" "character" ? ? ? ? ? ? no ? no no "39.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tw-report-pi-dtl.Campo-F[1]
"tw-report-pi-dtl.Campo-F[1]" "Cantidad" "->,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "5.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.tw-report-pi-dtl"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "tw-report-pi-dtl.campo-l[1] = yes"
     _FldNameList[1]   > Temp-Tables.tw-report-pi-dtl.Campo-I[1]
"tw-report-pi-dtl.Campo-I[1]" "PI!Serie" ">>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tw-report-pi-dtl.Campo-I[2]
"tw-report-pi-dtl.Campo-I[2]" "PI!Numero" ">>>>>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tw-report-pi-dtl.Campo-C[1]
"tw-report-pi-dtl.Campo-C[1]" "Articulo" ? "character" ? ? ? ? ? ? no ? no no "7.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tw-report-pi-dtl.Campo-C[2]
"tw-report-pi-dtl.Campo-C[2]" "Descripcion" "X(80)" "character" ? ? ? ? ? ? no ? no no "34.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = ""
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 F-Frame-Win
ON VALUE-CHANGED OF BROWSE-2 IN FRAME F-Main /* PARTES DE INGRESOS CON N/C */
DO:
    IF AVAILABLE tw-report-pi-hdr THEN DO:
        x-serie-pi = tw-report-pi-hdr.campo-i[1].
        x-numero-pi = tw-report-pi-hdr.campo-i[2].

        {&open-query-browse-3}

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&Scoped-define SELF-NAME BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 F-Frame-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-3 IN FRAME F-Main /* DETALLE DEL PARTE DE INGRESO */
DO:
    
    DEFINE VAR x-oldvalue AS CHAR.

    x-oldvalue = {&FIRST-TABLE-IN-QUERY-browse-3}.campo-l[1]:SCREEN-VALUE IN BROWSE browse-3.
    /*MESSAGE x-oldvalue.*/

    IF x-oldvalue = "no" THEN DO:
        ASSIGN {&FIRST-TABLE-IN-QUERY-browse-3}.campo-l[1]:SCREEN-VALUE IN BROWSE browse-3 = "YES".
        ASSIGN {&FIRST-TABLE-IN-QUERY-browse-3}.campo-l[1] = YES.
    END.
    ELSE DO:
        ASSIGN {&FIRST-TABLE-IN-QUERY-browse-3}.campo-l[1]:SCREEN-VALUE IN BROWSE browse-3 = "NO".
        ASSIGN {&FIRST-TABLE-IN-QUERY-browse-3}.campo-l[1] = NO.
    END.
    
    browse-3:REFRESH().

    {&open-query-browse-5}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 F-Frame-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Grabar */
DO:
        MESSAGE 'Seguro de GRABAR?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

    RUN grabar.
    
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 F-Frame-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Todos */
DO:
  RUN todos(INPUT YES).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 F-Frame-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Ninguno */
DO:
  RUN todos(INPUT NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK F-Frame-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
   /* Now enable the interface  if in test mode - otherwise this happens when
      the object is explicitly initialized from its container. */
   RUN dispatch IN THIS-PROCEDURE ('initialize':U).
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects F-Frame-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available F-Frame-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI F-Frame-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI F-Frame-Win  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-codcli FILL-IN-cliente FILL-IN-emision FILL-IN-importe 
          FILL-IN-moneda FILL-IN-1 
      WITH FRAME F-Main.
  ENABLE BROWSE-2 BROWSE-5 BROWSE-3 BUTTON-4 BUTTON-5 BUTTON-6 
      WITH FRAME F-Main.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE extrae-info F-Frame-Win 
PROCEDURE extrae-info :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pSerie AS INT.
DEFINE INPUT PARAMETER pNumero AS INT.

x-coddoc = pCodDoc.
x-serie = pSerie.
x-numero = pNumero.

x-numero-pi = -9.
x-serie-pi = -9.

DEFINE VAR x-referencia AS CHAR.
DEFINE VAR x-tiene-dtl AS LOG.

x-referencia = STRING(x-serie,"999").
x-referencia = x-referencia + STRING(x-numero,"99999999").

EMPTY TEMP-TABLE tw-report-pi-hdr.
EMPTY TEMP-TABLE tw-report-pi-dtl.

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN  fill-in-codcli:SCREEN-VALUE = ""
            fill-in-cliente:SCREEN-VALUE = ""
            fill-in-moneda:SCREEN-VALUE = ""
            fill-in-emision:SCREEN-VALUE = "//"
            fill-in-importe:SCREEN-VALUE = "0.00".

    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                ccbcdocu.coddoc = pCodDoc AND
                                ccbcdocu.nrodoc = x-referencia NO-LOCK NO-ERROR.
    IF AVAILABLE ccbcdocu THEN DO:
        ASSIGN  fill-in-codcli:SCREEN-VALUE = ccbcdocu.codcli
                fill-in-cliente:SCREEN-VALUE = ccbcdocu.nomcli
                fill-in-moneda:SCREEN-VALUE = IF(ccbcdocu.codmon = 2) THEN "DOLARES" ELSE "SOLES"
                fill-in-emision:SCREEN-VALUE = string(ccbcdocu.fchdoc,"99/99/9999")
                fill-in-importe:SCREEN-VALUE = STRING(ccbcdocu.imptot,"->>,>>>,>>9.99").
    END.
END.

SESSION:SET-WAIT-STATE("GENERAL").

FOR EACH almcmov WHERE almcmov.codcia = s-codcia AND
                        almcmov.codref = x-coddoc AND
                        almcmov.nroref = x-referencia AND
                        almcmov.tipmov = 'i' AND
                        almcmov.codmov = 9 AND 
                        almcmov.flgest = 'C' NO-LOCK:
    x-tiene-dtl = NO.
    FOR EACH almdmov OF almcmov NO-LOCK, FIRST almmmatg OF almdmov NO-LOCK:
        x-tiene-dtl = YES.
        CREATE tw-report-pi-dtl.
            ASSIGN tw-report-pi-dtl.campo-i[1] = almcmov.nroser
                    tw-report-pi-dtl.campo-i[2] = almcmov.nrodoc
                    tw-report-pi-dtl.campo-l[1] = NO
                    tw-report-pi-dtl.campo-c[1] = almdmov.codmat
                    tw-report-pi-dtl.campo-c[2] = almmmatg.desmat
                    tw-report-pi-dtl.campo-f[1] = almdmov.candes
                    tw-report-pi-dtl.campo-c[4] = almdmov.codalm
                    tw-report-pi-dtl.campo-c[5] = almdmov.tipmov
                    tw-report-pi-dtl.campo-c[6] = STRING(almdmov.codmov)
        .
    END.
    IF x-tiene-dtl THEN DO:
        CREATE tw-report-pi-hdr.
            ASSIGN tw-report-pi-hdr.campo-i[1] = almcmov.nroser
                    tw-report-pi-hdr.campo-i[2] = almcmov.nrodoc
                    tw-report-pi-hdr.campo-d[1] = almcmov.fchdoc
                    tw-report-pi-hdr.campo-c[1] = almcmov.codalm
                .
        IF x-serie-pi = -9 THEN DO:
            x-serie-pi = almcmov.nroser.
            x-numero-pi = almcmov.nrodoc.
        END.
    END.
END.

/* Marco los ya existentes */
DEFINE VAR x-llave-c1 AS CHAR.
DEFINE VAR x-llave-c2 AS CHAR.

x-llave-c1 = x-coddoc + "-" + STRING(x-serie,"999") + "-" + STRING(x-numero,"99999999").    /* FAC, BOL - 001-0005255 */

FOR EACH x-tw-report-pi-dtl :

    x-llave-c2 = STRING(x-tw-report-pi-dtl.campo-i[1],"999") + "-" + STRING(x-tw-report-pi-dtl.campo-i[2],"99999999").               /* PI - parte de ingreso */

    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                vtatabla.tabla = x-tabla-vtatabla AND
                                vtatabla.llave_c1 = x-llave-c1 AND
                                vtatabla.llave_c2 = x-llave-c2 AND
                                vtatabla.llave_c3 = x-tw-report-pi-dtl.campo-c[1] AND       /* comat */
                                vtatabla.libre_c03 = "" NO-LOCK NO-ERROR.                   /* no usado */
    IF AVAILABLE vtatabla THEN DO:
        ASSIGN x-tw-report-pi-dtl.campo-l[1] = YES.
    END.
END.

{&open-query-browse-2}
{&open-query-browse-3}
{&open-query-browse-5}

SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar F-Frame-Win 
PROCEDURE grabar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-llave-c1 AS CHAR.
DEFINE VAR x-llave-c2 AS CHAR.

DEFINE VAR y-serie-pi AS INT.
DEFINE VAR y-numero-pi AS INT.
DEFINE VAR x-rowid AS ROWID.

x-llave-c1 = x-coddoc + "-" + STRING(x-serie,"999") + "-" + STRING(x-numero,"99999999").    /* FAC, BOL - 001-0005255 */
x-llave-c2 = STRING(x-serie-pi,"999") + "-" + STRING(x-numero-pi,"99999999").               /* PI - parte de ingreso */

SESSION:SET-WAIT-STATE("GENERAL").

GRABAR:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':

    FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND
                                vtatabla.tabla = x-tabla-vtatabla AND
                                vtatabla.llave_c1 = x-llave-c1 AND  /* FAC, BOL */
                                vtatabla.libre_c03 = "" NO-LOCK:    /* Aun pendiente */

            y-serie-pi = INTEGER(TRIM(ENTRY(1,vtatabla.llave_c2,"-"))).
            y-numero-pi = INTEGER(TRIM(ENTRY(2,vtatabla.llave_c2,"-"))).

            FIND FIRST x-tw-report-pi-dtl WHERE x-tw-report-pi-dtl.campo-i[1] = y-serie-pi AND
                                                x-tw-report-pi-dtl.campo-i[2] = y-numero-pi AND
                                                x-tw-report-pi-dtl.campo-c[1] = vtatabla.llave_c3 AND   /* Codmat */
                                                x-tw-report-pi-dtl.campo-L[1] = NO NO-LOCK NO-ERROR.
            IF AVAILABLE x-tw-report-pi-dtl THEN DO:
                /* Eliminarlo x que ya lo han desmarcado */
                FIND FIRST b-vtatabla WHERE ROWID(vtatabla) = ROWID(b-vtatabla) EXCLUSIVE-LOCK NO-ERROR.
                IF AVAILABLE b-vtatabla THEN DO:
                    DELETE b-vtatabla NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN DO:
                        SESSION:SET-WAIT-STATE("").
                        UNDO GRABAR, RETURN 'ADM-ERROR'.
                    END.
                END.
            END.
                                
    END.

    FOR EACH x-tw-report-pi-dtl WHERE x-tw-report-pi-dtl.campo-l[1] = YES NO-LOCK:

        x-llave-c2 = STRING(x-tw-report-pi-dtl.campo-i[1],"999") + "-" + STRING(x-tw-report-pi-dtl.campo-i[2],"99999999").               /* PI - parte de ingreso */

        FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                    vtatabla.tabla = x-tabla-vtatabla AND
                                    vtatabla.llave_c1 = x-llave-c1 AND
                                    vtatabla.llave_c2 = x-llave-c2 AND
                                    vtatabla.llave_c3 = x-tw-report-pi-dtl.campo-c[1] AND
                                    vtatabla.libre_c03 = "" EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAILABLE vtatabla THEN DO:
            CREATE vtatabla.
                ASSIGN vtatabla.codcia = s-codcia
                    vtatabla.tabla = x-tabla-vtatabla
                    vtatabla.llave_c1 = x-llave-c1      /* FAC, BOL */
                    vtatabla.llave_c2 = x-llave-c2      /* PI */
                    vtatabla.llave_c3 = x-tw-report-pi-dtl.campo-c[1]   /*codmat*/
                    vtatabla.llave_c4 = x-tw-report-pi-dtl.campo-c[4]   /* codalm */
                    vtatabla.llave_c5 = x-tw-report-pi-dtl.campo-c[5]   /* tipmov */
                    vtatabla.llave_c6 = x-tw-report-pi-dtl.campo-c[6]   /* codmov */
                    vtatabla.libre_c01 = USERID("DICTDB") + "|" + STRING(TODAY,"99/99/9999") + "|" + STRING(TIME,"HH:MM:SS") 
                    vtatabla.libre_c02 = ""         /* actualizacion */
                    vtatabla.libre_c03 = ""         /* PNC que lo uso */                    
                    NO-ERROR.
        END.
        ELSE DO:
            ASSIGN vtatabla.libre_c02 = USERID("DICTDB") + "|" + STRING(TODAY,"99/99/9999") + "|" + STRING(TIME,"HH:MM:SS") NO-ERROR.
        END.
        IF ERROR-STATUS:ERROR THEN DO:
            SESSION:SET-WAIT-STATE("").
            UNDO GRABAR, RETURN 'ADM-ERROR'.
        END.
    END.

END.

RELEASE vtatabla NO-ERROR.
RELEASE b-vtatabla NO-ERROR.

SESSION:SET-WAIT-STATE("").

MESSAGE "GRABACION OK"
    VIEW-AS ALERT-BOX INFORMATION.

RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records F-Frame-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tw-report-pi-dtl"}
  {src/adm/template/snd-list.i "tw-report-pi-hdr"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed F-Frame-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE todos F-Frame-Win 
PROCEDURE todos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pValue AS LOG.

FOR EACH tw-report-pi-dtl WHERE tw-report-pi-dtl.campo-i[1] = x-serie-pi AND 
                            tw-report-pi-dtl.campo-i[2] = x-numero-pi:

    ASSIGN tw-report-pi-dtl.campo-l[1] = pValue.
END.

{&open-query-browse-5}
{&open-query-browse-3}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

