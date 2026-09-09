&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-fersmcomprobcab NO-UNDO LIKE fersmcomprobcab.



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
DEFINE INPUT PARAMETER p-accion AS CHAR.

/* 
    p-accion = 'M' : Mantenimiento, puede anular envios
    diferente de M solo consulta
 */

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR x-servidor-ip AS CHAR.
DEFINE VAR x-servidor-puerto AS CHAR.

DEFINE VAR x-ruc-emisor AS CHAR INIT "20100038146".
DEFINE VAR x-tipo-doc-emisor AS CHAR INIT "6".
DEFINE VAR x-fecha-envio AS CHAR.

DEFINE VAR x-nrorsm AS CHAR.
DEFINE VAR x-tiporsm AS CHAR.
DEFINE VAR x-col-moneda AS CHAR.

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
&Scoped-define INTERNAL-TABLES fersmcomprobcab tt-fersmcomprobcab ~
fersmcomprobdtl CcbCDocu

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 fersmcomprobcab.Libre_c01 ~
fersmcomprobcab.nrorsm fersmcomprobcab.fchgenemisor fersmcomprobcab.horagen ~
tt-fersmcomprobcab.Libre_c01 tt-fersmcomprobcab.Libre_c02 ~
tt-fersmcomprobcab.Libre_c03 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH fersmcomprobcab ~
      WHERE fersmcomprobcab.codcia = s-codcia and ~
(fersmcomprobcab.tiporsm = 'RA' or fersmcomprobcab.tiporsm = 'RC') and ~
(fersmcomprobcab.libre_c01 = "FACTURAS" or fersmcomprobcab.libre_c01 = "BOLETAS") NO-LOCK, ~
      FIRST tt-fersmcomprobcab WHERE tt-fersmcomprobcab.codcia = fersmcomprobcab.codcia and ~
tt-fersmcomprobcab.tiporsm = fersmcomprobcab.tiporsm and ~
tt-fersmcomprobcab.nrorsm = fersmcomprobcab.nrorsm OUTER-JOIN NO-LOCK ~
    BY fersmcomprobcab.nrorsm DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH fersmcomprobcab ~
      WHERE fersmcomprobcab.codcia = s-codcia and ~
(fersmcomprobcab.tiporsm = 'RA' or fersmcomprobcab.tiporsm = 'RC') and ~
(fersmcomprobcab.libre_c01 = "FACTURAS" or fersmcomprobcab.libre_c01 = "BOLETAS") NO-LOCK, ~
      FIRST tt-fersmcomprobcab WHERE tt-fersmcomprobcab.codcia = fersmcomprobcab.codcia and ~
tt-fersmcomprobcab.tiporsm = fersmcomprobcab.tiporsm and ~
tt-fersmcomprobcab.nrorsm = fersmcomprobcab.nrorsm OUTER-JOIN NO-LOCK ~
    BY fersmcomprobcab.nrorsm DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 fersmcomprobcab tt-fersmcomprobcab
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 fersmcomprobcab
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 tt-fersmcomprobcab


/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 fersmcomprobdtl.nitem ~
fersmcomprobdtl.coddoc fersmcomprobdtl.nrodoc ~
if(ccbcdocu.codmon = 2) then "USD" else "S/" @ x-col-moneda CcbCDocu.ImpTot ~
CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.FchDoc 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH fersmcomprobdtl ~
      WHERE fersmcomprobdtl.codcia = s-codcia and ~
fersmcomprobdtl.tiporsm = x-tiporsm and ~
fersmcomprobdtl.nrorsm = x-nrorsm NO-LOCK, ~
      FIRST CcbCDocu WHERE ccbcdocu.codcia = fersmcomprobdtl.codcia and ~
ccbcdocu.coddoc = fersmcomprobdtl.coddoc and ~
ccbcdocu.nrodoc = fersmcomprobdtl.nrodoc OUTER-JOIN NO-LOCK ~
    BY fersmcomprobdtl.nitem INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH fersmcomprobdtl ~
      WHERE fersmcomprobdtl.codcia = s-codcia and ~
fersmcomprobdtl.tiporsm = x-tiporsm and ~
fersmcomprobdtl.nrorsm = x-nrorsm NO-LOCK, ~
      FIRST CcbCDocu WHERE ccbcdocu.codcia = fersmcomprobdtl.codcia and ~
ccbcdocu.coddoc = fersmcomprobdtl.coddoc and ~
ccbcdocu.nrodoc = fersmcomprobdtl.nrodoc OUTER-JOIN NO-LOCK ~
    BY fersmcomprobdtl.nitem INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 fersmcomprobdtl CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 fersmcomprobdtl
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-4 CcbCDocu


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 BROWSE-4 BUTTON-31 BUTTON-30 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 FILL-IN-msg 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-30 
     LABEL "Refrescar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-31 
     LABEL "Anular Resumen" 
     SIZE 19 BY 1.12.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U INITIAL "CONSULTAR / ANULAR RESUMENES DE BAJAS" 
     VIEW-AS FILL-IN 
     SIZE 80.86 BY 1.35
     BGCOLOR 15 FGCOLOR 12 FONT 11 NO-UNDO.

DEFINE VARIABLE FILL-IN-msg AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 174.86 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      fersmcomprobcab, 
      tt-fersmcomprobcab SCROLLING.

DEFINE QUERY BROWSE-4 FOR 
      fersmcomprobdtl, 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      fersmcomprobcab.Libre_c01 COLUMN-LABEL "Tipo" FORMAT "x(10)":U
            WIDTH 9.43
      fersmcomprobcab.nrorsm COLUMN-LABEL "Nro. Envio" FORMAT "x(25)":U
            WIDTH 11.43
      fersmcomprobcab.fchgenemisor COLUMN-LABEL "Fch.Envio" FORMAT "99/99/9999":U
      fersmcomprobcab.horagen COLUMN-LABEL "Hora" FORMAT "x(12)":U
            WIDTH 7.72
      tt-fersmcomprobcab.Libre_c01 COLUMN-LABEL "BizLinks" FORMAT "x(8)":U
      tt-fersmcomprobcab.Libre_c02 COLUMN-LABEL "Sunat" FORMAT "x(8)":U
      tt-fersmcomprobcab.Libre_c03 COLUMN-LABEL "Estado" FORMAT "x(30)":U
            WIDTH 13.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 74 BY 21.23
         FONT 4
         TITLE "Envios de Resumenes" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      fersmcomprobdtl.nitem COLUMN-LABEL "Item" FORMAT ">,>>9":U
            WIDTH 3.43
      fersmcomprobdtl.coddoc COLUMN-LABEL "Cod.Doc" FORMAT "x(5)":U
      fersmcomprobdtl.nrodoc COLUMN-LABEL "No.Doc" FORMAT "x(15)":U
            WIDTH 13.86
      if(ccbcdocu.codmon = 2) then "USD" else "S/" @ x-col-moneda COLUMN-LABEL "Moneda" FORMAT "x(5)":U
      CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U WIDTH 10
      CcbCDocu.CodCli FORMAT "x(11)":U WIDTH 10.43
      CcbCDocu.NomCli FORMAT "x(50)":U
      CcbCDocu.FchDoc COLUMN-LABEL "Emision" FORMAT "99/99/9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 98.57 BY 21.31
         FONT 4
         TITLE "Detalle Facturas" ROW-HEIGHT-CHARS .65 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-2 AT ROW 2.46 COL 2 WIDGET-ID 200
     BROWSE-4 AT ROW 2.38 COL 76.43 WIDGET-ID 300
     BUTTON-31 AT ROW 1.15 COL 154 WIDGET-ID 8
     BUTTON-30 AT ROW 1.12 COL 138 WIDGET-ID 4
     FILL-IN-1 AT ROW 1.08 COL 2.14 NO-LABEL WIDGET-ID 6
     FILL-IN-msg AT ROW 23.77 COL 2.14 NO-LABEL WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 176.29 BY 23.96 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-fersmcomprobcab T "?" NO-UNDO INTEGRAL fersmcomprobcab
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta de Resumen de Boletas"
         HEIGHT             = 23.96
         WIDTH              = 176.29
         MAX-HEIGHT         = 23.96
         MAX-WIDTH          = 176.29
         VIRTUAL-HEIGHT     = 23.96
         VIRTUAL-WIDTH      = 176.29
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
/* BROWSE-TAB BROWSE-2 1 F-Main */
/* BROWSE-TAB BROWSE-4 BROWSE-2 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-msg IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.fersmcomprobcab,Temp-Tables.tt-fersmcomprobcab WHERE INTEGRAL.fersmcomprobcab ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER"
     _OrdList          = "INTEGRAL.fersmcomprobcab.nrorsm|no"
     _Where[1]         = "fersmcomprobcab.codcia = s-codcia and
(fersmcomprobcab.tiporsm = 'RA' or fersmcomprobcab.tiporsm = 'RC') and
(fersmcomprobcab.libre_c01 = ""FACTURAS"" or fersmcomprobcab.libre_c01 = ""BOLETAS"")"
     _JoinCode[2]      = "tt-fersmcomprobcab.codcia = fersmcomprobcab.codcia and
tt-fersmcomprobcab.tiporsm = fersmcomprobcab.tiporsm and
tt-fersmcomprobcab.nrorsm = fersmcomprobcab.nrorsm"
     _FldNameList[1]   > INTEGRAL.fersmcomprobcab.Libre_c01
"fersmcomprobcab.Libre_c01" "Tipo" "x(10)" "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.fersmcomprobcab.nrorsm
"fersmcomprobcab.nrorsm" "Nro. Envio" ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.fersmcomprobcab.fchgenemisor
"fersmcomprobcab.fchgenemisor" "Fch.Envio" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.fersmcomprobcab.horagen
"fersmcomprobcab.horagen" "Hora" ? "character" ? ? ? ? ? ? no ? no no "7.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-fersmcomprobcab.Libre_c01
"tt-fersmcomprobcab.Libre_c01" "BizLinks" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-fersmcomprobcab.Libre_c02
"tt-fersmcomprobcab.Libre_c02" "Sunat" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-fersmcomprobcab.Libre_c03
"tt-fersmcomprobcab.Libre_c03" "Estado" "x(30)" "character" ? ? ? ? ? ? no ? no no "13.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "INTEGRAL.fersmcomprobdtl,INTEGRAL.CcbCDocu WHERE INTEGRAL.fersmcomprobdtl ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER"
     _OrdList          = "INTEGRAL.fersmcomprobdtl.nitem|yes"
     _Where[1]         = "fersmcomprobdtl.codcia = s-codcia and
fersmcomprobdtl.tiporsm = x-tiporsm and
fersmcomprobdtl.nrorsm = x-nrorsm"
     _JoinCode[2]      = "ccbcdocu.codcia = fersmcomprobdtl.codcia and
ccbcdocu.coddoc = fersmcomprobdtl.coddoc and
ccbcdocu.nrodoc = fersmcomprobdtl.nrodoc"
     _FldNameList[1]   > INTEGRAL.fersmcomprobdtl.nitem
"fersmcomprobdtl.nitem" "Item" ">,>>9" "integer" ? ? ? ? ? ? no ? no no "3.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.fersmcomprobdtl.coddoc
"fersmcomprobdtl.coddoc" "Cod.Doc" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.fersmcomprobdtl.nrodoc
"fersmcomprobdtl.nrodoc" "No.Doc" ? "character" ? ? ? ? ? ? no ? no no "13.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"if(ccbcdocu.codmon = 2) then ""USD"" else ""S/"" @ x-col-moneda" "Moneda" "x(5)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CcbCDocu.ImpTot
"CcbCDocu.ImpTot" ? ? "decimal" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.CcbCDocu.CodCli
"CcbCDocu.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = INTEGRAL.CcbCDocu.NomCli
     _FldNameList[8]   > INTEGRAL.CcbCDocu.FchDoc
"CcbCDocu.FchDoc" "Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Consulta de Resumen de Boletas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Consulta de Resumen de Boletas */
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
ON ENTRY OF BROWSE-2 IN FRAME F-Main /* Envios de Resumenes */
DO:
  
  fill-in-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  x-nrorsm = "".

  IF AVAILABLE fersmcomprobcab THEN DO:
     fill-in-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = tt-fersmcomprobcab.libre_c05.
     x-nrorsm = fersmcomprobcab.nrorsm.
  END.

  browse-4:TITLE = "Nro de Envio " + x-nrorsm.

   {&open-query-browse-4}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON VALUE-CHANGED OF BROWSE-2 IN FRAME F-Main /* Envios de Resumenes */
DO:
  fill-in-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  x-nrorsm = "".
  x-tiporsm = "".

  IF AVAILABLE fersmcomprobcab THEN DO:
    fill-in-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = tt-fersmcomprobcab.libre_c05.
    x-nrorsm = fersmcomprobcab.nrorsm.
    x-tiporsm = fersmcomprobcab.tiporsm.
  END.

  browse-4:TITLE = "Nro de Envio " + x-nrorsm.

  {&open-query-browse-4}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-30
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-30 W-Win
ON CHOOSE OF BUTTON-30 IN FRAME F-Main /* Refrescar */
DO:
  {&open-query-browse-2}
  /* - */
  fill-in-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  x-nrorsm = "".

  IF AVAILABLE fersmcomprobcab THEN DO:
    fill-in-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = tt-fersmcomprobcab.libre_c05.
    x-nrorsm = fersmcomprobcab.nrorsm.
  END.

  browse-4:TITLE = "Nro de Envio " + x-nrorsm.

  {&open-query-browse-4}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-31
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-31 W-Win
ON CHOOSE OF BUTTON-31 IN FRAME F-Main /* Anular Resumen */
DO:

    DEFINE VAR x-msg AS CHAR INIT "".

    IF NOT AVAILABLE fersmcomprobcab THEN RETURN NO-APPLY.
    
    IF tt-fersmcomprobcab.libre_c03 = 'ANULADO' THEN RETURN NO-APPLY.

    IF tt-fersmcomprobcab.libre_c02 = 'AC_03' THEN DO:
        MESSAGE "El resumen de baja " + fersmcomprobcab.nrorsm + " esta aceptado por SUNAT, imposible ANULAR"
                VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.

    x-msg = "Seguro de ANULAR el resumen " + fersmcomprobcab.nrorsm + " ?".
    /* Si no esta rechazado por sunat */
    IF tt-fersmcomprobcab.libre_c02 <> 'RC_05' THEN DO:

        DEFINE VAR x-estado AS CHAR INIT "FIRMADO".

        IF tt-fersmcomprobcab.libre_c02 = 'ED_06' THEN x-estado = "EN PROCESO DE ENVIO A SUNAT".
        IF tt-fersmcomprobcab.libre_c02 = 'PE_02' THEN x-estado = "A LA ESPERA DE RESPUESTA DE SUNAT".

        /* Aqui podemos poner alguna autorizacion  */
        x-msg = "EL RESUMEN " + fersmcomprobcab.nrorsm + " ESTA EN LA SITUACION :" + CHR(13) + 
                x-estado + CHR(13) + 
                "Seguro de ANULAR el resumen ?".

    END.

        MESSAGE x-msg VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

    /* Anular */
    RUN anular-resumen.

    browse-2:REFRESH().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

ON FIND OF fersmcomprobcab DO:
    
    DEFINE VAR x-estado-bizlinks AS CHAR.
    DEFINE VAR x-estado-sunat AS CHAR.
    DEFINE VAR x-abreviado AS CHAR.
    DEFINE VAR x-detallado AS CHAR.
    DEFINE VAR x-estado-doc AS CHAR.

    fill-in-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

    IF x-nrorsm = "" THEN DO:
        x-tiporsm = fersmcomprobcab.tiporsm.
        x-nrorsm = fersmcomprobcab.nrorsm.
        browse-4:TITLE = "Nro de Envio " + x-nrorsm.
    END.
        

    FIND FIRST tt-fersmcomprobcab WHERE tt-fersmcomprobcab.codcia = fersmcomprobcab.codcia AND
                                        tt-fersmcomprobcab.tiporsm = fersmcomprobcab.tiporsm AND
                                        tt-fersmcomprobcab.nrorsm = fersmcomprobcab.nrorsm 
                                        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE tt-fersmcomprobcab THEN DO:
        
        CREATE tt-fersmcomprobcab.
        BUFFER-COPY fersmcomprobcab TO tt-fersmcomprobcab.            .
    END.

    /* Estado del documento electronico */
    RUN estado-envio(INPUT tt-fersmcomprobcab.tiporsm, 
                        INPUT tt-fersmcomprobcab.nrorsm, 
                        OUTPUT x-estado-bizlinks,
                        OUTPUT x-estado-sunat,
                        OUTPUT x-estado-doc).

    /*  */
    ASSIGN tt-fersmcomprobcab.libre_c01 = ENTRY(1,x-estado-bizlinks,"|")
            tt-fersmcomprobcab.libre_c02 = ENTRY(1,x-estado-sunat,"|")
            tt-fersmcomprobcab.libre_c03 = x-estado-doc /*x-Abreviado*/
            tt-fersmcomprobcab.libre_c05 = "" /*x-Detallado*/
            /*tt-fersmcomprobcab.libre_c03 = ENTRY(2,x-estado-bizlinks,"|")*/
    .
    IF NOT (TRUE <> (fersmcomprobcab.libre_c02 > "")) THEN DO:
        ASSIGN tt-fersmcomprobcab.libre_c03 = "ANULADO".
    END.

    RETURN.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE anular-resumen W-Win 
PROCEDURE anular-resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-proceso AS CHAR INIT "GRABANDO ANULACION DE RESUMEN" NO-UNDO.

DEFINE BUFFER x-fersmcomprobdtl FOR fersmcomprobdtl.
DEFINE BUFFER b-felogcomprobantes FOR felogcomprobantes.
DEFINE BUFFER b-fersmcomprobcab FOR fersmcomprobcab.

SESSION:SET-WAIT-STATE("GENERAL").

GRABAR_DATOS:
DO TRANSACTION ON ERROR UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS:
    DO:
        /* Header update block */
        FIND FIRST b-fersmcomprobcab WHERE b-fersmcomprobcab.codcia = fersmcomprobcab.codcia AND
                                            b-fersmcomprobcab.tiporsm = fersmcomprobcab.tiporsm AND
                                            b-fersmcomprobcab.nrorsm = fersmcomprobcab.nrorsm 
                                            EXCLUSIVE-LOCK NO-ERROR.
        IF LOCKED b-fersmcomprobcab THEN DO:
            x-proceso = "La tabla FERSMCOMPROBCAB esta usado por otro usario ".
            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS. 
        END.
        IF NOT AVAILABLE b-fersmcomprobcab THEN DO:
            x-proceso = "El resumen " + fersmcomprobcab.nrorsm + " No existe".
            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS. 
        END.
        ASSIGN b-fersmcomprobcab.libre_c02 = "ANULADO|" + s-user-id + "|" + STRING(TODAY,"99/99/9999") + "|" + STRING(TIME,"HH:MM:SS").
    END.
    
    FOR EACH x-fersmcomprobdtl WHERE x-fersmcomprobdtl.codcia =  fersmcomprobcab.codcia AND
                                    x-fersmcomprobdtl.tiporsm =  fersmcomprobcab.tiporsm AND
                                    x-fersmcomprobdtl.nrorsm =  fersmcomprobcab.nrorsm
                            ON ERROR UNDO, THROW:
        /* */
        
        FIND FIRST b-felogcomprobantes WHERE b-felogcomprobantes.codcia = x-fersmcomprobdtl.codcia AND
                                                b-felogcomprobantes.coddoc = x-fersmcomprobdtl.coddoc AND
                                                b-felogcomprobantes.nrodoc = x-fersmcomprobdtl.nrodoc
                                                EXCLUSIVE-LOCK NO-ERROR.
        IF LOCKED b-felogcomprobantes THEN DO:
            x-proceso = "La tabla FELOGCOMPROBANTES esta usado por otro usario " + CHR(13) +
                        "al querer eliminar a la " + x-fersmcomprobdtl.coddoc + "-" + x-fersmcomprobdtl.nrodoc + " del resumen".                        
            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS. 
        END.
        IF NOT AVAILABLE b-felogcomprobantes THEN DO:
            x-proceso = "El documento " + x-fersmcomprobdtl.coddoc + "-" + x-fersmcomprobdtl.nrodoc + CHR(13).                        
                        "No se encuentra en la tabla FELOGCOMPROBANTES".
            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS. 
        END.
        IF b-felogcomprobantes.libre_c02 = fersmcomprobcab.nrorsm THEN DO:
            ASSIGN b-felogcomprobantes.libre_c02 = "".      /* Nro de resumen de la baja */
        END.        
    
    END.

    x-proceso = "OK".
    
END. /* TRANSACTION block */

RELEASE b-felogcomprobantes.
RELEASE b-fersmcomprobcab.

SESSION:SET-WAIT-STATE("").

IF x-proceso <> "OK" THEN x-proceso = "ERROR EN EL PROCESO" + CHR(13) + x-proceso.

MESSAGE x-proceso.



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
  DISPLAY FILL-IN-1 FILL-IN-msg 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-2 BROWSE-4 BUTTON-31 BUTTON-30 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE estado-envio W-Win 
PROCEDURE estado-envio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pTipoRsm AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pNroRsm AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pEstadoBizLinks AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pEstadoSunat AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pEstadoDoc AS CHAR NO-UNDO.

DEFINE VAR x-estado-doc AS CHAR.

RUN gn/p-estado-documento-electronico(INPUT pTipoRsm,
                                      INPUT pNroRsm,
                                      INPUT "",
                                      OUTPUT pEstadoBizLinks,
                                      OUTPUT pEstadoSunat,
                                      OUTPUT pEstadoDoc).

/*
DEFINE VAR x-ws-ok AS CHAR.

x-servidor-ip = "".
x-servidor-puerto = "".

/* - */
RUN verificar-ws (OUTPUT x-ws-ok).
IF x-ws-ok <> "OK" THEN DO:
    pEstadoBizLinks = x-ws-ok.
    RETURN "ADM-ERROR".
END.

DEFIN VAR x-url-webservice AS CHAR.

DEFINE VAR x-oXmlHttp AS COM-HANDLE NO-UNDO.
DEFINE VAR x-oXMLBody AS com-HANDLE NO-UNDO.

CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.
CREATE "MSXML2.DOMDocument.6.0" x-oXMLBody.

x-url-webservice = "http://" + x-servidor-ip + ":" + x-servidor-puerto + "/einvoice/rest/" +
                    "6/" + x-ruc-emisor + "/RC/" + pNroEnvio.


x-oXmlHttp:OPEN( "GET", x-url-webservice, NO ) .    
x-oXmlHttp:setRequestHeader( "Content-Type", "application/xml" ).
/*x-oXmlHttp:setRequestHeader( "Content-Length", LENGTH(lEnvioXML)).    */

x-oXmlHttp:setOption( 2, 13056 ) .  /*SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS = 13056*/             
x-oXmlHttp:SEND() NO-ERROR.

IF ERROR-STATUS:GET-NUMBER(1) > 0 THEN DO:
    pEstadoBizLinks = "SIN CONEXION|No hay conexion con el PSE (" + ERROR-STATUS:GET-MESSAGE(1) + ")".
    RETURN.
END.

IF x-oXmlHttp:STATUS <> 200 THEN DO:
    pEstadoBizLinks = "ERROR 200|" + x-oXmlHttp:responseText.
    RETURN .
END.
  
/* Respuesta */
DEFINE var x-oMsg AS COM-HANDLE NO-UNDO.
DEFINE VAR x-oRspta AS COM-HANDLE NO-UNDO.

DEFINE VAR x-rspta AS CHAR.
DEFINE VAR x-status AS CHAR.
DEFINE VAR x-status-descripcion AS CHAR.
DEFINE VAR x-status-documento AS CHAR.
DEFINE VAR x-status-sunat AS CHAR.

CREATE "MSXML2.DOMDocument.6.0" x-oRspta.

x-rspta = x-oXmlHttp:responseText.

x-oRspta:LoadXML(x-oXmlHttp:responseText).
x-oMsg = x-oRspta:selectSingleNode( "//status" ).
x-status = TRIM(x-oMsg:TEXT) NO-ERROR.
x-oMsg = x-oRspta:selectSingleNode( "//descriptionDetail" ).
x-status-descripcion = TRIM(x-oMsg:TEXT) NO-ERROR.
/* Sunat */
x-oMsg = x-oRspta:selectSingleNode( "//statusSunat" ).
x-status-sunat = TRIM(x-oMsg:TEXT) NO-ERROR.
x-oMsg = x-oRspta:selectSingleNode( "//statusDocument" ).
x-status-documento = TRIM(x-oMsg:TEXT) NO-ERROR.

IF x-status = ? THEN x-status = "".
IF x-status-descripcion = ? THEN x-status-descripcion = "".
IF x-status-sunat = ? THEN x-status-sunat = "".
IF x-status-documento = ? THEN x-status-documento = "".

pEstadoBizLinks = x-status + "|" + x-status-descripcion.
pEstadoSunat = x-status-sunat + "|".

RELEASE OBJECT x-oXmlHttp NO-ERROR.
RELEASE OBJECT x-oXMLBody NO-ERROR.
RELEASE OBJECT x-oRspta NO-ERROR.
RELEASE OBJECT x-oMsg NO-ERROR.
*/

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
       button-31:VISIBLE = FALSE.
       IF p-accion = 'M' THEN button-31:VISIBLE = TRUE.
    END.


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
  {src/adm/template/snd-list.i "fersmcomprobdtl"}
  {src/adm/template/snd-list.i "CcbCDocu"}
  {src/adm/template/snd-list.i "fersmcomprobcab"}
  {src/adm/template/snd-list.i "tt-fersmcomprobcab"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificar-ws W-Win 
PROCEDURE verificar-ws :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pReturn  AS CHAR.

FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                            factabla.tabla = "CONFIG-FE-BIZLINKS" AND
                            factabla.codigo = "TODOS" NO-LOCK NO-ERROR.
IF NOT AVAILABLE factabla THEN DO:
    pReturn = "667|El Servidor del WebService no esta configurado".
    RETURN "ADM-ERROR".
END.

x-servidor-ip = TRIM(factabla.campo-c[1]).
x-servidor-puerto = TRIM(factabla.campo-c[2]).

IF (TRUE <> (x-servidor-ip > "")) OR (TRUE <> (x-servidor-puerto > "")) THEN DO:
    pReturn = "667|La IP y/o Puerto Servidor del WebService esta vacio".
    RETURN "ADM-ERROR".
END.

pReturn = "OK".

RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

