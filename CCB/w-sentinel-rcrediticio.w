&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-deudas-actual NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE tt-deudas-anteriores NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE tt-deudas-finan NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE tt-lineas-credito NO-UNDO LIKE w-report.



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
DEFINE INPUT PARAMETER pDatosConsulta AS CHAR.

DEFINE VAR pTipoDoc AS CHAR INIT "".
DEFINE VAR pNroDoc AS CHAR INIT "".

IF NUM-ENTRIES(pDatosConsulta,"|") > 0 THEN DO:
    pTipoDoc = ENTRY(1,pDatosConsulta,"|").
    IF pTipoDoc = "!" THEN pTipoDoc = "".
    IF NUM-ENTRIES(pDatosConsulta,"|") > 1 THEN pNroDoc = ENTRY(2,pDatosConsulta,"|").
END.

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR sXMLData AS LONGCHAR.
DEFINE VAR sXMLDataWrk AS LONGCHAR.

DEFINE VAR x-tipodoc AS CHAR.
DEFINE VAR x-nrodoc AS CHAR.
DEFINE VAR x-usuario AS CHAR.
DEFINE VAR x-password AS CHAR.

DEFINE NEW SHARED VAR s-texto AS LONGCHAR.
DEFINE VAR x-mes-proceso AS INT.

IF USERID("DICTDB") = "MASTER" THEN DO:
    s-user-id = 'ADMIN'.
END.

x-tipodoc = "".
x-nrodoc = "".
x-usuario = "".
x-password = "".

/* Verifica si el usuario tiene permiso */
IF s-user-id <> 'ADMIN' THEN DO:
    FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                                factabla.tabla = 'SENTINEL' AND 
                                factabla.codigo = s-user-id NO-LOCK NO-ERROR.
    IF NOT AVAILABLE factabla THEN DO:
        MESSAGE "Usuario no esta autorizado".
        RETURN "ADM-ERROR".
    END.
END.

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
&Scoped-define INTERNAL-TABLES tt-deudas-finan tt-lineas-credito ~
tt-deudas-actual tt-deudas-anteriores

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tt-deudas-finan.Campo-C[1] ~
tt-deudas-finan.Campo-C[2] tt-deudas-finan.Campo-C[3] ~
tt-deudas-finan.Campo-C[4] tt-deudas-finan.Campo-C[5] ~
tt-deudas-finan.Campo-C[6] tt-deudas-finan.Campo-C[7] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tt-deudas-finan NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tt-deudas-finan NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tt-deudas-finan
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tt-deudas-finan


/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 tt-lineas-credito.Campo-C[1] ~
tt-lineas-credito.Campo-C[2] tt-lineas-credito.Campo-C[3] ~
tt-lineas-credito.Campo-C[4] tt-lineas-credito.Campo-C[5] ~
tt-lineas-credito.Campo-C[6] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH tt-lineas-credito NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH tt-lineas-credito NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 tt-lineas-credito
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 tt-lineas-credito


/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 tt-deudas-actual.Campo-C[1] ~
tt-deudas-actual.Campo-C[2] tt-deudas-actual.Campo-C[3] ~
tt-deudas-actual.Campo-C[4] tt-deudas-actual.Campo-C[5] ~
tt-deudas-actual.Campo-C[6] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH tt-deudas-actual NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH tt-deudas-actual NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 tt-deudas-actual
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 tt-deudas-actual


/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 tt-deudas-anteriores.Campo-C[1] ~
tt-deudas-anteriores.Campo-C[2] tt-deudas-anteriores.Campo-C[3] ~
tt-deudas-anteriores.Campo-C[4] tt-deudas-anteriores.Campo-C[5] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH tt-deudas-anteriores NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH tt-deudas-anteriores NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 tt-deudas-anteriores
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 tt-deudas-anteriores


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-3}~
    ~{&OPEN-QUERY-BROWSE-4}~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cboTipoDoc txtnrodocumento BROWSE-5 BROWSE-4 ~
BUTTON-1 RECT-1 BROWSE-3 BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS m01 txtMes01 cboTipoDoc txtnrodocumento ~
txtUsuario txtPassword txtNombre txtFechaProceso txtMes02 txtMes03 txtMes04 ~
txtMes05 txtMes06 txtMes07 txtMes08 txtMes09 txtMes10 txtMes11 txtMes12 m02 ~
m03 m04 m05 m06 m07 m08 m09 m10 m11 m12 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-calificacion W-Win 
FUNCTION get-calificacion RETURNS CHARACTER
  (INPUT pCodCalf AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-color-semaforo W-Win 
FUNCTION get-color-semaforo RETURNS INTEGER
  (INPUT pSemaforo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-tipo-cuenta W-Win 
FUNCTION get-tipo-cuenta RETURNS CHARACTER
  (INPUT pTipoCuenta AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Consultar" 
     SIZE 12.14 BY 1.12.

DEFINE VARIABLE cboTipoDoc AS CHARACTER FORMAT "X(256)":U INITIAL "R" 
     LABEL "Tipo documento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "DOC.TRIB.NO.DOM.SIN.RUC","0",
                     "CARNET DE IDENTIDAD","3",
                     "CARNET DE EXTRANJERIA","4",
                     "PASAPORTE","5",
                     "CARNET IDENTIDAD FF PP","6",
                     "CARNET IDENTIDAD FF AA","7",
                     "LIBRETA TRIBUTARIA","8",
                     "DOCUMENTO PROVISIONAL IDENTIDAD","9",
                     "CED. DIPLOMATICA DE IDENTIDAD","A",
                     "DOC. TRIB. NO DOM. SIN RUC","B",
                     "DNI","D",
                     "RUC","R"
     DROP-DOWN-LIST
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE m01 AS CHARACTER FORMAT "X(2)":U INITIAL "01" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .62
     FONT 3 NO-UNDO.

DEFINE VARIABLE m02 AS CHARACTER FORMAT "X(2)":U INITIAL "01" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .62
     FONT 3 NO-UNDO.

DEFINE VARIABLE m03 AS CHARACTER FORMAT "X(2)":U INITIAL "01" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .62
     FONT 3 NO-UNDO.

DEFINE VARIABLE m04 AS CHARACTER FORMAT "X(2)":U INITIAL "01" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .62
     FONT 3 NO-UNDO.

DEFINE VARIABLE m05 AS CHARACTER FORMAT "X(2)":U INITIAL "01" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .62
     FONT 3 NO-UNDO.

DEFINE VARIABLE m06 AS CHARACTER FORMAT "X(2)":U INITIAL "01" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .62
     FONT 3 NO-UNDO.

DEFINE VARIABLE m07 AS CHARACTER FORMAT "X(2)":U INITIAL "01" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .62
     FONT 3 NO-UNDO.

DEFINE VARIABLE m08 AS CHARACTER FORMAT "X(2)":U INITIAL "01" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .62
     FONT 3 NO-UNDO.

DEFINE VARIABLE m09 AS CHARACTER FORMAT "X(2)":U INITIAL "01" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .62
     FONT 3 NO-UNDO.

DEFINE VARIABLE m10 AS CHARACTER FORMAT "X(2)":U INITIAL "01" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .62
     FONT 3 NO-UNDO.

DEFINE VARIABLE m11 AS CHARACTER FORMAT "X(2)":U INITIAL "01" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .62
     FONT 3 NO-UNDO.

DEFINE VARIABLE m12 AS CHARACTER FORMAT "X(2)":U INITIAL "01" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .62
     FONT 3 NO-UNDO.

DEFINE VARIABLE txtFechaProceso AS CHARACTER FORMAT "X(50)":U 
     LABEL "Fecha Proceso" 
     VIEW-AS FILL-IN 
     SIZE 18.43 BY 1
     BGCOLOR 15 FGCOLOR 0 FONT 11 NO-UNDO.

DEFINE VARIABLE txtMes01 AS CHARACTER FORMAT "X(1)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY 1
     FONT 11 NO-UNDO.

DEFINE VARIABLE txtMes02 AS CHARACTER FORMAT "X(1)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY 1
     FONT 11 NO-UNDO.

DEFINE VARIABLE txtMes03 AS CHARACTER FORMAT "X(1)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY 1
     FONT 11 NO-UNDO.

DEFINE VARIABLE txtMes04 AS CHARACTER FORMAT "X(1)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY 1
     FONT 11 NO-UNDO.

DEFINE VARIABLE txtMes05 AS CHARACTER FORMAT "X(1)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY 1
     FONT 11 NO-UNDO.

DEFINE VARIABLE txtMes06 AS CHARACTER FORMAT "X(1)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY 1
     FONT 11 NO-UNDO.

DEFINE VARIABLE txtMes07 AS CHARACTER FORMAT "X(1)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY 1
     FONT 11 NO-UNDO.

DEFINE VARIABLE txtMes08 AS CHARACTER FORMAT "X(1)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY 1
     FONT 11 NO-UNDO.

DEFINE VARIABLE txtMes09 AS CHARACTER FORMAT "X(1)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY 1
     FONT 11 NO-UNDO.

DEFINE VARIABLE txtMes10 AS CHARACTER FORMAT "X(1)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY 1
     FONT 11 NO-UNDO.

DEFINE VARIABLE txtMes11 AS CHARACTER FORMAT "X(1)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY 1
     FONT 11 NO-UNDO.

DEFINE VARIABLE txtMes12 AS CHARACTER FORMAT "X(1)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY 1
     FONT 11 NO-UNDO.

DEFINE VARIABLE txtNombre AS CHARACTER FORMAT "X(120)":U 
     VIEW-AS FILL-IN 
     SIZE 73.14 BY 1
     BGCOLOR 15 FGCOLOR 9 FONT 10 NO-UNDO.

DEFINE VARIABLE txtnrodocumento AS CHARACTER FORMAT "X(15)":U 
     LABEL "Nro. documento" 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1
     FONT 11 NO-UNDO.

DEFINE VARIABLE txtPassword AS CHARACTER FORMAT "X(50)":U 
     LABEL "Password" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE txtSemaforo AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 34.43 BY 1
     BGCOLOR 15 FGCOLOR 0 FONT 11 NO-UNDO.

DEFINE VARIABLE txtUsuario AS CHARACTER FORMAT "X(256)":U 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 126.86 BY 2.46.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tt-deudas-finan SCROLLING.

DEFINE QUERY BROWSE-3 FOR 
      tt-lineas-credito SCROLLING.

DEFINE QUERY BROWSE-4 FOR 
      tt-deudas-actual SCROLLING.

DEFINE QUERY BROWSE-5 FOR 
      tt-deudas-anteriores SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tt-deudas-finan.Campo-C[1] COLUMN-LABEL "Año" FORMAT "X(4)":U
      tt-deudas-finan.Campo-C[2] COLUMN-LABEL "Mes" FORMAT "X(2)":U
      tt-deudas-finan.Campo-C[3] COLUMN-LABEL "Entidad" FORMAT "X(60)":U
            WIDTH 40.57
      tt-deudas-finan.Campo-C[4] COLUMN-LABEL "Deuda" FORMAT "X(15)":U
      tt-deudas-finan.Campo-C[5] COLUMN-LABEL "Dias!vencidos" FORMAT "X(8)":U
            WIDTH 8.86
      tt-deudas-finan.Campo-C[6] COLUMN-LABEL "Calificacion" FORMAT "X(15)":U
            WIDTH 30.72
      tt-deudas-finan.Campo-C[7] COLUMN-LABEL "Fecha Rpte" FORMAT "X(12)":U
            WIDTH 16.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 126.29 BY 6.54
         FONT 2
         TITLE "Deudas Financieras" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      tt-lineas-credito.Campo-C[1] COLUMN-LABEL "Entidad" FORMAT "X(60)":U
            WIDTH 30.57
      tt-lineas-credito.Campo-C[2] COLUMN-LABEL "Tipo!Cuenta" FORMAT "X(50)":U
            WIDTH 35.43
      tt-lineas-credito.Campo-C[3] COLUMN-LABEL "Linea!Credito" FORMAT "X(20)":U
            WIDTH 11.43
      tt-lineas-credito.Campo-C[4] COLUMN-LABEL "Linea!No utilizada" FORMAT "X(20)":U
            WIDTH 13.43
      tt-lineas-credito.Campo-C[5] COLUMN-LABEL "Linea!Utilizada" FORMAT "X(20)":U
      tt-lineas-credito.Campo-C[6] COLUMN-LABEL "% Linea!Utilizada" FORMAT "X(12)":U
            WIDTH 9.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 126.14 BY 5.73
         FONT 2
         TITLE "Lineas de Credito" ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      tt-deudas-actual.Campo-C[1] COLUMN-LABEL "Fuente" FORMAT "X(30)":U
            WIDTH 23.43 COLUMN-FONT 2 LABEL-FONT 6
      tt-deudas-actual.Campo-C[2] COLUMN-LABEL "Entidad" FORMAT "X(60)":U
            WIDTH 42.43 COLUMN-FONT 2 LABEL-FONT 6
      tt-deudas-actual.Campo-C[3] COLUMN-LABEL "Cantidad!Documentos" FORMAT "X(8)":U
            WIDTH 10 COLUMN-FONT 2 LABEL-FONT 6
      tt-deudas-actual.Campo-C[4] COLUMN-LABEL "Monto" FORMAT "X(20)":U
            COLUMN-FONT 2 LABEL-FONT 6
      tt-deudas-actual.Campo-C[5] COLUMN-LABEL "Dias!Vencidos" FORMAT "X(8)":U
            COLUMN-FONT 2 LABEL-FONT 6
      tt-deudas-actual.Campo-C[6] COLUMN-LABEL "Cantidad" FORMAT "X(8)":U
            WIDTH .14 COLUMN-FONT 2 LABEL-FONT 6
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 110.14 BY 4.69
         FONT 3
         TITLE "Deudas actuales" ROW-HEIGHT-CHARS .65 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      tt-deudas-anteriores.Campo-C[1] COLUMN-LABEL "Año" FORMAT "X(4)":U
      tt-deudas-anteriores.Campo-C[2] COLUMN-LABEL "Mes" FORMAT "X(2)":U
      tt-deudas-anteriores.Campo-C[3] COLUMN-LABEL "Fuente" FORMAT "X(50)":U
            WIDTH 45.86
      tt-deudas-anteriores.Campo-C[4] COLUMN-LABEL "Monto" FORMAT "X(20)":U
      tt-deudas-anteriores.Campo-C[5] COLUMN-LABEL "Dias!vencidos" FORMAT "X(8)":U
            WIDTH 9
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 88 BY 5.31
         FONT 2
         TITLE "Deudas anteriores" ROW-HEIGHT-CHARS .46 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     m01 AT ROW 22.5 COL 89 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     txtMes01 AT ROW 23.12 COL 89 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     cboTipoDoc AT ROW 1.35 COL 18 COLON-ALIGNED WIDGET-ID 4
     txtnrodocumento AT ROW 1.31 COL 69.29 COLON-ALIGNED WIDGET-ID 6
     txtUsuario AT ROW 2.31 COL 18 COLON-ALIGNED WIDGET-ID 16
     txtPassword AT ROW 2.31 COL 50.14 COLON-ALIGNED WIDGET-ID 18 PASSWORD-FIELD 
     BROWSE-5 AT ROW 21.92 COL 2 WIDGET-ID 500
     BROWSE-4 AT ROW 17.19 COL 1.86 WIDGET-ID 400
     txtNombre AT ROW 3.65 COL 1.72 NO-LABEL WIDGET-ID 12
     BUTTON-1 AT ROW 1.23 COL 96.86 WIDGET-ID 8
     txtFechaProceso AT ROW 3.65 COL 87 WIDGET-ID 14
     txtMes02 AT ROW 23.12 COL 91.86 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     txtMes03 AT ROW 23.12 COL 94.72 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     txtMes04 AT ROW 23.12 COL 97.57 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     txtMes05 AT ROW 23.12 COL 100.43 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     txtMes06 AT ROW 23.12 COL 103.29 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     txtMes07 AT ROW 23.12 COL 106.14 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     txtMes08 AT ROW 23.12 COL 109 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     txtMes09 AT ROW 23.12 COL 112 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     txtMes10 AT ROW 23.12 COL 114.72 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     txtMes11 AT ROW 23.12 COL 117.57 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     txtMes12 AT ROW 23.12 COL 120.43 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     m02 AT ROW 22.5 COL 91.86 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     m03 AT ROW 22.5 COL 94.72 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     m04 AT ROW 22.5 COL 97.57 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     m05 AT ROW 22.5 COL 100.43 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     m06 AT ROW 22.5 COL 103.29 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     m07 AT ROW 22.5 COL 106.14 COLON-ALIGNED NO-LABEL WIDGET-ID 56
     m08 AT ROW 22.5 COL 109 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     m09 AT ROW 22.5 COL 111.86 COLON-ALIGNED NO-LABEL WIDGET-ID 68
     m10 AT ROW 22.5 COL 114.72 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     m11 AT ROW 22.5 COL 117.57 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     m12 AT ROW 22.5 COL 120.43 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     txtSemaforo AT ROW 24.92 COL 91.72 NO-LABEL WIDGET-ID 70
     BROWSE-3 AT ROW 11.42 COL 1.86 WIDGET-ID 300
     BROWSE-2 AT ROW 4.69 COL 1.72 WIDGET-ID 200
     RECT-1 AT ROW 1.04 COL 1.43 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 127.86 BY 26.5 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-deudas-actual T "?" NO-UNDO INTEGRAL w-report
      TABLE: tt-deudas-anteriores T "?" NO-UNDO INTEGRAL w-report
      TABLE: tt-deudas-finan T "?" NO-UNDO INTEGRAL w-report
      TABLE: tt-lineas-credito T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "SENTINEL - Riesgo crediticio"
         HEIGHT             = 26.5
         WIDTH              = 127.86
         MAX-HEIGHT         = 27.96
         MAX-WIDTH          = 131.72
         VIRTUAL-HEIGHT     = 27.96
         VIRTUAL-WIDTH      = 131.72
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
/* BROWSE-TAB BROWSE-5 txtPassword F-Main */
/* BROWSE-TAB BROWSE-4 BROWSE-5 F-Main */
/* BROWSE-TAB BROWSE-3 RECT-1 F-Main */
/* BROWSE-TAB BROWSE-2 BROWSE-3 F-Main */
/* SETTINGS FOR FILL-IN m01 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN m02 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN m03 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN m04 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN m05 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN m06 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN m07 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN m08 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN m09 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN m10 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN m11 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN m12 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtFechaProceso IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN txtMes01 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtMes02 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtMes03 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtMes04 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtMes05 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtMes06 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtMes07 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtMes08 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtMes09 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtMes10 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtMes11 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtMes12 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtNombre IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN txtPassword IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       txtPassword:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN txtSemaforo IN FRAME F-Main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       txtSemaforo:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN txtUsuario IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       txtUsuario:HIDDEN IN FRAME F-Main           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tt-deudas-finan"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-deudas-finan.Campo-C[1]
"tt-deudas-finan.Campo-C[1]" "Año" "X(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-deudas-finan.Campo-C[2]
"tt-deudas-finan.Campo-C[2]" "Mes" "X(2)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-deudas-finan.Campo-C[3]
"tt-deudas-finan.Campo-C[3]" "Entidad" "X(60)" "character" ? ? ? ? ? ? no ? no no "40.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-deudas-finan.Campo-C[4]
"tt-deudas-finan.Campo-C[4]" "Deuda" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-deudas-finan.Campo-C[5]
"tt-deudas-finan.Campo-C[5]" "Dias!vencidos" ? "character" ? ? ? ? ? ? no ? no no "8.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-deudas-finan.Campo-C[6]
"tt-deudas-finan.Campo-C[6]" "Calificacion" "X(15)" "character" ? ? ? ? ? ? no ? no no "30.72" yes no no "U" "" "" "FILL-IN" "," ? ? 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-deudas-finan.Campo-C[7]
"tt-deudas-finan.Campo-C[7]" "Fecha Rpte" "X(12)" "character" ? ? ? ? ? ? no ? no no "16.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.tt-lineas-credito"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-lineas-credito.Campo-C[1]
"tt-lineas-credito.Campo-C[1]" "Entidad" "X(60)" "character" ? ? ? ? ? ? no ? no no "30.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-lineas-credito.Campo-C[2]
"tt-lineas-credito.Campo-C[2]" "Tipo!Cuenta" "X(50)" "character" ? ? ? ? ? ? no ? no no "35.43" yes no no "U" "" "" "FILL-IN" "," ? ? 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-lineas-credito.Campo-C[3]
"tt-lineas-credito.Campo-C[3]" "Linea!Credito" "X(20)" "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-lineas-credito.Campo-C[4]
"tt-lineas-credito.Campo-C[4]" "Linea!No utilizada" "X(20)" "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-lineas-credito.Campo-C[5]
"tt-lineas-credito.Campo-C[5]" "Linea!Utilizada" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-lineas-credito.Campo-C[6]
"tt-lineas-credito.Campo-C[6]" "% Linea!Utilizada" "X(12)" "character" ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.tt-deudas-actual"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-deudas-actual.Campo-C[1]
"tt-deudas-actual.Campo-C[1]" "Fuente" "X(30)" "character" ? ? 2 ? ? 6 no ? no no "23.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-deudas-actual.Campo-C[2]
"tt-deudas-actual.Campo-C[2]" "Entidad" "X(60)" "character" ? ? 2 ? ? 6 no ? no no "42.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-deudas-actual.Campo-C[3]
"tt-deudas-actual.Campo-C[3]" "Cantidad!Documentos" ? "character" ? ? 2 ? ? 6 no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-deudas-actual.Campo-C[4]
"tt-deudas-actual.Campo-C[4]" "Monto" "X(20)" "character" ? ? 2 ? ? 6 no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-deudas-actual.Campo-C[5]
"tt-deudas-actual.Campo-C[5]" "Dias!Vencidos" ? "character" ? ? 2 ? ? 6 no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-deudas-actual.Campo-C[6]
"tt-deudas-actual.Campo-C[6]" "Cantidad" ? "character" ? ? 2 ? ? 6 no ? no no ".14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.tt-deudas-anteriores"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-deudas-anteriores.Campo-C[1]
"tt-deudas-anteriores.Campo-C[1]" "Año" "X(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-deudas-anteriores.Campo-C[2]
"tt-deudas-anteriores.Campo-C[2]" "Mes" "X(2)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-deudas-anteriores.Campo-C[3]
"tt-deudas-anteriores.Campo-C[3]" "Fuente" "X(50)" "character" ? ? ? ? ? ? no ? no no "45.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-deudas-anteriores.Campo-C[4]
"tt-deudas-anteriores.Campo-C[4]" "Monto" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-deudas-anteriores.Campo-C[5]
"tt-deudas-anteriores.Campo-C[5]" "Dias!vencidos" ? "character" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* SENTINEL - Riesgo crediticio */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* SENTINEL - Riesgo crediticio */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Consultar */
DO:
  ASSIGN cboTipoDoc txtnrodocumento txtUsuario txtPassword.
  IF txtnrodocumento = "" THEN DO:
      MESSAGE "Ingrese el Nro de documento".
      RETURN NO-APPLY.
  END.
  /*
  IF txtUsuario = "" THEN DO:
      MESSAGE "Ingrese el Usuario".
      RETURN NO-APPLY.
  END.
  IF txtPassword = "" THEN DO:
      MESSAGE "Ingrese el Password".
      RETURN NO-APPLY.
  END.
  */

  x-tipodoc = cboTipoDoc.
  x-nrodoc  = txtnrodocumento.
  x-usuario = txtUsuario.
  x-password = txtPassword.

  /* Invocar el WebService */
  RUN get-xml-webservice.

   /*  */
   RUN procesar-xml.
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
  DISPLAY m01 txtMes01 cboTipoDoc txtnrodocumento txtUsuario txtPassword 
          txtNombre txtFechaProceso txtMes02 txtMes03 txtMes04 txtMes05 txtMes06 
          txtMes07 txtMes08 txtMes09 txtMes10 txtMes11 txtMes12 m02 m03 m04 m05 
          m06 m07 m08 m09 m10 m11 m12 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE cboTipoDoc txtnrodocumento BROWSE-5 BROWSE-4 BUTTON-1 RECT-1 BROWSE-3 
         BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gen-deudas-actuales W-Win 
PROCEDURE gen-deudas-actuales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-tagini AS CHAR.
DEFINE VAR x-tagfin AS CHAR.
DEFINE VAR x-tramo AS CHAR.
DEFINE VAR x-conteo AS INT.
DEFINE VAR x-conteo1 AS INT.
DEFINE VAR x-conteo2 AS INT.
DEFINE VAR x-valor AS CHAR.

DEFINE VAR x-xmlwrk AS LONGCHAR.

DEFINE VAR lCantidad AS INT.
DEFINE VAR lImporte AS DEC.

/* XMLwrk : de trabajo */
sXMLDataWrk = TRIM(sXMLData). /* XML original */
x-tagini = "<SDT_RepVenMesAct ".   /* El espacio en blanco al final es obligatorio */
x-tagfin = "</SDT_RepVenMesAct>".

/*MESSAGE "Deudas actuales".*/
/* SDT_LinCreMesAct */
REPEAT x-conteo = 1 TO 50:
    RUN GET-tramo-xml(INPUT x-tagini, INPUT x-tagfin, OUTPUT x-tramo).
    IF x-tramo = "" THEN DO:
        LEAVE.
    END.
    /*MESSAGE x-tramo.*/
    CREATE tt-deudas-actual.

    RUN GET-texto-tag(INPUT "<Fuente>", INPUT "</Fuente>", INPUT x-tramo, OUTPUT x-valor).
    ASSIGN tt-deudas-actual.campo-c[1] = x-valor.
    RUN GET-texto-tag(INPUT "<Entidad>", INPUT "</Entidad>", INPUT x-tramo, OUTPUT x-valor).
    ASSIGN tt-deudas-actual.campo-c[2] = x-valor.
    RUN GET-texto-tag(INPUT "<CantidadDocs>", INPUT "</CantidadDocs>", INPUT x-tramo, OUTPUT x-valor).
    ASSIGN tt-deudas-actual.campo-c[3] = x-valor.
    RUN GET-texto-tag(INPUT "<Monto>", INPUT "</Monto>", INPUT x-tramo, OUTPUT x-valor).
    x-valor = STRING(DEC(TRIM(x-valor)),">>>,>>>,>>9.99").    
    ASSIGN tt-deudas-actual.campo-c[4] = x-valor.
    RUN GET-texto-tag(INPUT "<DiasVencidos>", INPUT "</DiasVencidos>", INPUT x-tramo, OUTPUT x-valor).
    ASSIGN tt-deudas-actual.campo-c[5] = x-valor.
    RUN GET-texto-tag(INPUT "<Cantidad>", INPUT "</Cantidad>", INPUT x-tramo, OUTPUT x-valor).
    ASSIGN tt-deudas-actual.campo-c[6] = x-valor.
END.

{&OPEN-QUERY-BROWSE-3}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gen-deudas-anteriores W-Win 
PROCEDURE gen-deudas-anteriores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-tagini AS CHAR.
DEFINE VAR x-tagfin AS CHAR.
DEFINE VAR x-tramo AS CHAR.
DEFINE VAR x-conteo AS INT.
DEFINE VAR x-conteo1 AS INT.
DEFINE VAR x-conteo2 AS INT.
DEFINE VAR x-valor AS CHAR.

DEFINE VAR x-xmlwrk AS LONGCHAR.

/* XMLwrk : de trabajo */
sXMLDataWrk = TRIM(sXMLData). /* XML original */
x-tagini = "<SDT_RepVenMesAnt ".   /* El espacio en blanco al final es obligatorio */
x-tagfin = "</SDT_RepVenMesAnt>".

/*MESSAGE "DEUDAS ANTERIORES".*/
/* <SDT_RepVenMesAnt */
REPEAT x-conteo = 1 TO 50:
    RUN GET-tramo-xml(INPUT x-tagini, INPUT x-tagfin, OUTPUT x-tramo).
    /*MESSAGE x-tramo.*/
    IF x-tramo = "" THEN DO:
        LEAVE.
    END.
    x-xmlwrk = sXMLDataWrk.

    CREATE tt-deudas-anteriores.
    /* Periodo */
    RUN GET-texto-tag(INPUT "<RepVenAnio>", INPUT "</RepVenAnio>", INPUT x-tramo, OUTPUT x-valor).
    ASSIGN tt-deudas-anteriores.campo-c[1] = x-valor.    
    RUN GET-texto-tag(INPUT "<RepVenMes>", INPUT "</RepVenMes>", INPUT x-tramo, OUTPUT x-valor).
    ASSIGN tt-deudas-anteriores.campo-c[2] = x-valor.

    /* <SDT_RepVenMesAntDet> */
    sXMLDataWrk = x-tramo.
    RUN GET-tramo-xml(INPUT "<SDT_RepVenMesAntDet>", INPUT "</SDT_RepVenMesAntDet>", OUTPUT x-tramo).

    sXMLDataWrk = x-tramo.
    REPEAT x-conteo1 = 1 TO 50:  
        /* <SDT_RepVenMesAntDetItem> */
        RUN GET-tramo-xml(INPUT "<SDT_RepVenMesAntDetItem>", INPUT "</SDT_RepVenMesAntDetItem>", OUTPUT x-tramo).
        IF x-tramo = "" THEN DO:
            LEAVE.
        END.
        IF x-conteo1 > 1 THEN DO:
            CREATE tt-deudas-anteriores.
        END.
        /*  */
        RUN GET-texto-tag(INPUT "<RepVenTipDeu>", INPUT "</RepVenTipDeu>", INPUT x-tramo, OUTPUT x-valor).        
        ASSIGN tt-deudas-anteriores.campo-c[3] = x-valor.
        RUN GET-texto-tag(INPUT "<RepVenMont>", INPUT "</RepVenMont>", INPUT x-tramo, OUTPUT x-valor).
        x-valor = STRING(DEC(TRIM(x-valor)),">>>,>>>,>>9.99").
        ASSIGN tt-deudas-anteriores.campo-c[4] = x-valor.
        RUN GET-texto-tag(INPUT "<RepVenDiaVen>", INPUT "</RepVenDiaVen>", INPUT x-tramo, OUTPUT x-valor).
        ASSIGN tt-deudas-anteriores.campo-c[5] = x-valor.

    END.

    /**/
    sXMLDataWrk= x-xmlwrk.
END.

{&OPEN-QUERY-BROWSE-4}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gen-deudas-financieras W-Win 
PROCEDURE gen-deudas-financieras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-tagini AS CHAR.
DEFINE VAR x-tagfin AS CHAR.
DEFINE VAR x-tramo AS CHAR.
DEFINE VAR x-conteo AS INT.
DEFINE VAR x-conteo1 AS INT.
DEFINE VAR x-conteo2 AS INT.
DEFINE VAR x-valor AS CHAR.

DEFINE VAR x-xmlwrk AS LONGCHAR.

/* XMLwrk : de trabajo */
sXMLDataWrk = TRIM(sXMLData). /* XML original */
x-tagini = "<SDT_RepSBS12M ".   /* El espacio en blanco al final es obligatorio */
x-tagfin = "</SDT_RepSBS12M>".

/*MESSAGE "Deudas Financieras".*/
/* <SDT_RepSBS12M */
REPEAT x-conteo = 1 TO 50:
    RUN GET-tramo-xml(INPUT x-tagini, INPUT x-tagfin, OUTPUT x-tramo).
    IF x-tramo = "" THEN DO:
        LEAVE.
    END.
    /*MESSAGE x-tramo.*/
    x-xmlwrk = sXMLDataWrk.

    CREATE tt-deudas-finan.
    /* Periodo */
    RUN GET-texto-tag(INPUT "<RepSBSAnioPro>", INPUT "</RepSBSAnioPro>", INPUT x-tramo, OUTPUT x-valor).
    ASSIGN tt-deudas-finan.campo-c[1] = x-valor.
    RUN GET-texto-tag(INPUT "<RepSBSMesPro>", INPUT "</RepSBSMesPro>", INPUT x-tramo, OUTPUT x-valor).
    ASSIGN tt-deudas-finan.campo-c[2] = x-valor.

    /* <SDT_RepSBS12MEnt> */
    sXMLDataWrk = x-tramo.
    RUN GET-tramo-xml(INPUT "<SDT_RepSBS12MEnt>", INPUT "</SDT_RepSBS12MEnt>", OUTPUT x-tramo).

    sXMLDataWrk = x-tramo.
    REPEAT x-conteo1 = 1 TO 50:  
        /* <SDT_RepSBS12MEntItem> */
        RUN GET-tramo-xml(INPUT "<SDT_RepSBS12MEntItem>", INPUT "</SDT_RepSBS12MEntItem>", OUTPUT x-tramo).
        IF x-tramo = "" THEN DO:
            LEAVE.
        END.
        IF x-conteo1 > 1 THEN DO:
            CREATE tt-deudas-finan.
        END.
        /*  */
        RUN GET-texto-tag(INPUT "<FechaReporte>", INPUT "</FechaReporte>", INPUT x-tramo, OUTPUT x-valor).
        ASSIGN tt-deudas-finan.campo-c[7] = x-valor.
        RUN GET-texto-tag(INPUT "<NomRazSocEnt>", INPUT "</NomRazSocEnt>", INPUT x-tramo, OUTPUT x-valor).
        ASSIGN tt-deudas-finan.campo-c[3] = x-valor.
        RUN GET-texto-tag(INPUT "<MontoDeuda>", INPUT "</MontoDeuda>", INPUT x-tramo, OUTPUT x-valor).
        x-valor = STRING(DEC(TRIM(x-valor)),">>>,>>>,>>9.99").
        ASSIGN tt-deudas-finan.campo-c[4] = x-valor.
        RUN GET-texto-tag(INPUT "<DiasVencidos>", INPUT "</DiasVencidos>", INPUT x-tramo, OUTPUT x-valor).
        ASSIGN tt-deudas-finan.campo-c[5] = x-valor.
        RUN GET-texto-tag(INPUT "<Calificacion>", INPUT "</Calificacion>", INPUT x-tramo, OUTPUT x-valor).
        ASSIGN tt-deudas-finan.campo-c[6] = get-calificacion(x-valor).
    END.

    /**/
    sXMLDataWrk= x-xmlwrk.
END.

{&OPEN-QUERY-BROWSE-2}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gen-lineas-credito W-Win 
PROCEDURE gen-lineas-credito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-tagini AS CHAR.
DEFINE VAR x-tagfin AS CHAR.
DEFINE VAR x-tramo AS CHAR.
DEFINE VAR x-conteo AS INT.
DEFINE VAR x-conteo1 AS INT.
DEFINE VAR x-conteo2 AS INT.
DEFINE VAR x-valor AS CHAR.

DEFINE VAR x-xmlwrk AS LONGCHAR.

/* XMLwrk : de trabajo */
sXMLDataWrk = TRIM(sXMLData). /* XML original */
x-tagini = "<SDT_LinCreMesAct ".   /* El espacio en blanco al final es obligatorio */
x-tagfin = "</SDT_LinCreMesAct>".

/*MESSAGE "Lineas de Credito".*/
/* SDT_LinCreMesAct */
REPEAT x-conteo = 1 TO 50:
    RUN GET-tramo-xml(INPUT x-tagini, INPUT x-tagfin, OUTPUT x-tramo).
    IF x-tramo = "" THEN DO:
        LEAVE.
    END.
    /*MESSAGE x-tramo.*/
    CREATE tt-lineas-credito.

    RUN GET-texto-tag(INPUT "<CnsEntNomRazLN>", INPUT "</CnsEntNomRazLN>", INPUT x-tramo, OUTPUT x-valor).
    ASSIGN tt-lineas-credito.campo-c[1] = x-valor.
    RUN GET-texto-tag(INPUT "<TipoCuenta>", INPUT "</TipoCuenta>", INPUT x-tramo, OUTPUT x-valor).
    ASSIGN tt-lineas-credito.campo-c[2] = get-tipo-cuenta(x-valor).
    RUN GET-texto-tag(INPUT "<LinCred>", INPUT "</LinCred>", INPUT x-tramo, OUTPUT x-valor).
    x-valor = STRING(DEC(TRIM(x-valor)),">>>,>>>,>>9.99").
    ASSIGN tt-lineas-credito.campo-c[3] = x-valor.
    RUN GET-texto-tag(INPUT "<LinNoUtil>", INPUT "</LinNoUtil>", INPUT x-tramo, OUTPUT x-valor).
    x-valor = STRING(DEC(TRIM(x-valor)),">>>,>>>,>>9.99").
    ASSIGN tt-lineas-credito.campo-c[4] = x-valor.
    RUN GET-texto-tag(INPUT "<LinUtil>", INPUT "</LinUtil>", INPUT x-tramo, OUTPUT x-valor).
    x-valor = STRING(DEC(TRIM(x-valor)),">>>,>>>,>>9.99").
    ASSIGN tt-lineas-credito.campo-c[5] = x-valor.
    RUN GET-texto-tag(INPUT "<PorLinUti>", INPUT "</PorLinUti>", INPUT x-tramo, OUTPUT x-valor).
    ASSIGN tt-lineas-credito.campo-c[6] = x-valor.
END.

{&OPEN-QUERY-BROWSE-2}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-texto-tag W-Win 
PROCEDURE get-texto-tag :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM pTagIni AS CHAR.
DEFINE INPUT PARAM pTagFin AS CHAR.
DEFINE INPUT PARAM pTramo AS CHAR.
DEFINE OUTPUT PARAM pValor AS CHAR.

DEFINE VAR x-tramo AS CHAR.
DEFINE VAR x-tagini AS CHAR.
DEFINE VAR x-tagfin AS CHAR.
DEFINE VAR x-posini AS INT.
DEFINE VAR x-posfin AS INT.
DEFINE VAR x-porcion AS INT.

pValor = "".

x-tramo = TRIM(pTramo). 
x-posini = 0.
x-posfin = 0.

x-tagini = pTagIni.   
x-tagfin = pTagFin.

x-posini = INDEX(pTramo,x-tagini).
IF x-posini <= 0 THEN DO:
    RETURN.
END.
x-posfin = INDEX(pTramo,x-tagfin,x-posini + 1).
IF x-posfin <= 0 THEN DO:
    RETURN.
END.
x-porcion = x-posfin - (x-posini + LENGTH(x-tagini)).
pValor = SUBSTRING(pTramo,x-posini + LENGTH(x-tagini),x-porcion).


RETURN.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-tramo-xml W-Win 
PROCEDURE get-tramo-xml :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM pTagIni AS CHAR.
DEFINE INPUT PARAM pTagFin AS CHAR.
DEFINE OUTPUT PARAM pTramo AS CHAR.

DEFINE VAR x-xmldata AS LONGCHAR.
DEFINE VAR x-tagini AS CHAR.
DEFINE VAR x-tagfin AS CHAR.
DEFINE VAR x-posini AS INT.
DEFINE VAR x-posfin AS INT.
DEFINE VAR x-porcion AS INT.

pTramo = "".

x-xmldata = TRIM(sXMLDataWrk). /* XML inicial */
x-posini = 0.
x-posfin = 0.

x-tagini = pTagIni.   /* El espacio en blanco al final es obligatorio */
x-tagfin = pTagFin.

x-posini = INDEX(sXMLDataWrk,x-tagini).
IF x-posini <= 0 THEN DO:
    RETURN.
END.
x-posfin = INDEX(sXMLDataWrk,x-tagfin,x-posini + 1).
IF x-posfin <= 0 THEN DO:
    RETURN.
END.
x-porcion = x-posfin - x-posini + LENGTH(x-tagfin).
pTramo = SUBSTRING(sXMLDataWrk,x-posini,x-porcion).

/* - */
sXMLDataWrk = SUBSTRING(sXMLDataWrk,1,x-posini - 1) + 
              SUBSTRING(sXMLDataWrk,x-posfin + LENGTH(x-tagfin) ).


RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-xml-webservice W-Win 
PROCEDURE get-xml-webservice :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* WS sentinel */
  DEFINE VAR hProc AS HANDLE NO-UNDO.

  RUN lib\sentinel_ws.r PERSISTENT SET hProc.

  DEFINE VAR lMSGData AS CHAR.
  DEFINE VAR lCodigoWS AS CHAR.

  /* x-usuario y x-password van vacio, el WS determina el DEFAULT de esos valores */
  RUN GET-info-crediticia IN hProc (INPUT x-tipodoc, INPUT x-nrodoc,
                                    INPUT x-usuario, INPUT x-password,
                                    OUTPUT lMSGdata, OUTPUT lCodigoWS).
  
  IF TRIM(lCodigoWS) <> '0'  THEN DO:
      IF SUBSTRING(lCodigoWS,1,1) <> "-" THEN DO:
        /* Si el error no es negativo, es propio de sentinel */
        CASE TRIM(lCodigoWS):
            WHEN '1' THEN lMSGdata = "Usuario incorrecto".
            WHEN '2' THEN lMSGdata = "Servicio invalido".
            WHEN '3' THEN lMSGdata = "CPT invalido (no existe)".
            WHEN '4' THEN lMSGdata = "No tiene autorizacion a ver dicho CPT".
            WHEN '5' THEN lMSGdata = "Error 5".
            WHEN '6' THEN lMSGdata = "El usuario no tiene permiso de Insertar/Ver CPT".
            WHEN '7' THEN lMSGdata = "El servicio está suspendido".
            WHEN '8' THEN lMSGdata = "El usuario está suspendido".
            WHEN '9' THEN lMSGdata = "El usuario está bloqueado".
            WHEN '10' THEN lMSGdata = "El servicio no tiene disponible este producto.".
            WHEN '11' THEN lMSGdata = "Error 11".
            WHEN '12' THEN lMSGdata = "Usuario no se encuentra en servicio.".
        END CASE.
      END.

      sXMLData = "".
      MESSAGE TRIM(lMSGData).

      RETURN NO-APPLY.
  END.

  SESSION:SET-WAIT-STATE('GENERAL').
  DEFINE VARIABLE mPointer     AS MEMPTR      NO-UNDO.
  DEFINE VARIABLE mPointerSize AS INTEGER     NO-UNDO.
  /*
  ASSIGN
      FILE-INFO:FILE-NAME = lMSGData
      mPointerSize        = FILE-INFO:FILE-SIZE
      SET-SIZE(mPointer)    = mPointerSize.

   /* Read the XML data from a file into a memptr */
   INPUT FROM VALUE(lMSGData) BINARY NO-MAP NO-CONVERT.
   IMPORT mPointer.
   INPUT CLOSE.

   sXMLData = GET-STRING(mPointer,1).
   */

    sXMLData = s-texto.

   SESSION:SET-WAIT-STATE('').


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
  IF pTipoDoc <> "" THEN DO:
      x-tipodoc = pTipoDoc.
      x-nrodoc = pNroDoc.

      /* Invocar el WebService */
      RUN get-xml-webservice.
      
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF pTipoDoc <> "" THEN DO:

      RUN procesar-xml.

      cboTipoDoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-tipodoc .
      txtnrodocumento:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-nrodoc .

      DISABLE cboTipoDoc WITH FRAME {&FRAME-NAME}.
      DISABLE txtnrodocumento WITH FRAME {&FRAME-NAME}.
      DISABLE txtUsuario WITH FRAME {&FRAME-NAME}.
      DISABLE txtPassword WITH FRAME {&FRAME-NAME}.

      DISABLE BUTTON-1 WITH FRAME {&FRAME-NAME}.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-xml W-Win 
PROCEDURE procesar-xml :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE('GENERAL').                           

EMPTY TEMP-TABLE tt-deudas-finan.
EMPTY TEMP-TABLE tt-lineas-credito.
EMPTY TEMP-TABLE tt-deudas-actual.
EMPTY TEMP-TABLE tt-deudas-anteriores.

FOR EACH tt-deudas-finan:
    DELETE tt-deudas-finan.
END.
FOR EACH tt-lineas-credito:
    DELETE tt-lineas-credito.
END.
FOR EACH tt-deudas-actual:
    DELETE tt-deudas-actual.
END.
FOR EACH tt-deudas-anteriores:
    DELETE tt-deudas-anteriores.
END.

/* Invocar el WebService */
/*RUN get-xml-webservice.*/

/**/
DEFINE VAR x-valor AS CHAR.
DEFINE VAR x-tramo AS CHAR.

x-tramo = SUBSTRING(sXMLData,1,512).

RUN GET-texto-tag(INPUT "<NombreRazSocCPT>", INPUT "</NombreRazSocCPT>", INPUT x-tramo, OUTPUT x-valor).
txtnombre:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-valor .
RUN GET-texto-tag(INPUT "<Semaforos12M>", INPUT "</Semaforos12M>", INPUT x-tramo, OUTPUT x-valor).
txtsemaforo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-valor .
RUN GET-texto-tag(INPUT "<FechaProceso>", INPUT "</FechaProceso>", INPUT x-tramo, OUTPUT x-valor).
txtfechaproceso:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-valor .

x-mes-proceso = INTEGER(SUBSTRING(x-valor,6,2)).

{&OPEN-QUERY-BROWSE-2 IN FRAME {&FRAME-NAME}} 
{&OPEN-QUERY-BROWSE-3 IN FRAME {&FRAME-NAME}}
{&OPEN-QUERY-BROWSE-4 IN FRAME {&FRAME-NAME}}
{&OPEN-QUERY-BROWSE-5 IN FRAME {&FRAME-NAME}}

RUN gen-deudas-financieras.
RUN gen-lineas-credito.
RUN gen-deudas-actuales.
RUN gen-deudas-anteriores.

{&OPEN-QUERY-BROWSE-2}
{&OPEN-QUERY-BROWSE-3}
{&OPEN-QUERY-BROWSE-4}
{&OPEN-QUERY-BROWSE-5}

SESSION:SET-WAIT-STATE('').

/* Colores de los Semaforos */
DEFINE VAR lMeses AS INT.
DEFINE VAR lsec AS INT.
DEFINE VAR lSemaforo AS CHAR.
DEFINE VAR lSemaforos AS CHAR.

/*  */
txtMes01:SCREEN-VALUE  = ''.
M01:SCREEN-VALUE  = ''.
txtMes01:FGCOLOR  = 15.
txtMes02:SCREEN-VALUE  = ''.
M02:SCREEN-VALUE  = ''.
txtMes02:FGCOLOR  = 15.
txtMes03:SCREEN-VALUE  = ''.
M03:SCREEN-VALUE  = ''.
txtMes03:FGCOLOR  = 15.
txtMes04:SCREEN-VALUE  = ''.
M04:SCREEN-VALUE  = ''.
txtMes04:FGCOLOR  = 15.
txtMes05:SCREEN-VALUE  = ''.
M05:SCREEN-VALUE  = ''.
txtMes05:FGCOLOR  = 15.
txtMes06:SCREEN-VALUE  = ''.
M06:SCREEN-VALUE  = ''.
txtMes06:FGCOLOR  = 15.
txtMes07:SCREEN-VALUE  = ''.
M07:SCREEN-VALUE  = ''.
txtMes07:FGCOLOR  = 15.
txtMes08:SCREEN-VALUE  = ''.
M08:SCREEN-VALUE  = ''.
txtMes08:FGCOLOR  = 15.
txtMes09:SCREEN-VALUE  = ''.
M09:SCREEN-VALUE  = ''.
txtMes09:FGCOLOR  = 15.
txtMes10:SCREEN-VALUE  = ''.
M10:SCREEN-VALUE  = ''.
txtMes10:FGCOLOR  = 15.
txtMes11:SCREEN-VALUE  = ''.
M11:SCREEN-VALUE  = ''.
txtMes11:FGCOLOR  = 15.
txtMes12:SCREEN-VALUE  = ''.
M12:SCREEN-VALUE  = ''.
txtMes12:FGCOLOR  = 15.

lSemaforos = TRIM(txtSemaforo:SCREEN-VALUE).
lMeses = LENGTH(lSemaforos).
REPEAT lsec = 1 TO lMeses:

    IF lSec > 12 THEN LEAVE.

    lSemaforo = SUBSTRING(lSemaforos,(12 - (lSec - 1)),1).
    IF lSec = 1 THEN DO:
        txtMes01:SCREEN-VALUE  = lSemaforo.
        txtMes01:FGCOLOR  = get-color-semaforo(lSemaforo).
        /* --  */
        M01:SCREEN-VALUE = STRING(x-mes-proceso,"99").
        x-mes-proceso = x-mes-proceso - 1.
        IF x-mes-proceso <= 0 THEN x-mes-proceso = 12.
    END.
    IF lSec = 2 THEN DO:
        txtMes02:SCREEN-VALUE  = lSemaforo.
        txtMes02:FGCOLOR  = get-color-semaforo(lSemaforo).
        /* --  */
        M02:SCREEN-VALUE = STRING(x-mes-proceso,"99").
        x-mes-proceso = x-mes-proceso - 1.
        IF x-mes-proceso <= 0 THEN x-mes-proceso = 12.
    END.
    IF lSec = 3 THEN DO:
        txtMes03:SCREEN-VALUE  = lSemaforo.
        txtMes03:FGCOLOR  = get-color-semaforo(lSemaforo).
        /* --  */
        M03:SCREEN-VALUE = STRING(x-mes-proceso,"99").
        x-mes-proceso = x-mes-proceso - 1.
        IF x-mes-proceso <= 0 THEN x-mes-proceso = 12.
    END.
    IF lSec = 4 THEN DO:
        txtMes04:SCREEN-VALUE  = lSemaforo.
        txtMes04:FGCOLOR  = get-color-semaforo(lSemaforo).
        /* --  */
        M04:SCREEN-VALUE = STRING(x-mes-proceso,"99").
        x-mes-proceso = x-mes-proceso - 1.
        IF x-mes-proceso <= 0 THEN x-mes-proceso = 12.
    END.
    IF lSec = 5 THEN DO:
        txtMes05:SCREEN-VALUE  = lSemaforo.
        txtMes05:FGCOLOR  = get-color-semaforo(lSemaforo).
        /* --  */
        M05:SCREEN-VALUE = STRING(x-mes-proceso,"99").
        x-mes-proceso = x-mes-proceso - 1.
        IF x-mes-proceso <= 0 THEN x-mes-proceso = 12.
    END.
    IF lSec = 6 THEN DO:
        txtMes06:SCREEN-VALUE  = lSemaforo.
        txtMes06:FGCOLOR  = get-color-semaforo(lSemaforo).
        /* --  */
        M06:SCREEN-VALUE = STRING(x-mes-proceso,"99").
        x-mes-proceso = x-mes-proceso - 1.
        IF x-mes-proceso <= 0 THEN x-mes-proceso = 12.
    END.
    IF lSec = 7 THEN DO:
        txtMes07:SCREEN-VALUE  = lSemaforo.
        txtMes07:FGCOLOR  = get-color-semaforo(lSemaforo).
        /* --  */
        M07:SCREEN-VALUE = STRING(x-mes-proceso,"99").
        x-mes-proceso = x-mes-proceso - 1.
        IF x-mes-proceso <= 0 THEN x-mes-proceso = 12.
    END.
    IF lSec = 8 THEN DO:
        txtMes08:SCREEN-VALUE  = lSemaforo.
        txtMes08:FGCOLOR  = get-color-semaforo(lSemaforo).
        /* --  */
        M08:SCREEN-VALUE = STRING(x-mes-proceso,"99").
        x-mes-proceso = x-mes-proceso - 1.
        IF x-mes-proceso <= 0 THEN x-mes-proceso = 12.
    END.
    IF lSec = 9 THEN DO:
        txtMes09:SCREEN-VALUE  = lSemaforo.
        txtMes09:FGCOLOR  = get-color-semaforo(lSemaforo).
        /* --  */
        M09:SCREEN-VALUE = STRING(x-mes-proceso,"99").
        x-mes-proceso = x-mes-proceso - 1.
        IF x-mes-proceso <= 0 THEN x-mes-proceso = 12.
    END.
    IF lSec = 10 THEN DO:
        txtMes10:SCREEN-VALUE  = lSemaforo.
        txtMes10:FGCOLOR  = get-color-semaforo(lSemaforo).
        /* --  */
        M10:SCREEN-VALUE = STRING(x-mes-proceso,"99").
        x-mes-proceso = x-mes-proceso - 1.
        IF x-mes-proceso <= 0 THEN x-mes-proceso = 12.
    END.
    IF lSec = 11 THEN DO:
        txtMes11:SCREEN-VALUE  = lSemaforo.
        txtMes11:FGCOLOR  = get-color-semaforo(lSemaforo).
        /* --  */
        M11:SCREEN-VALUE = STRING(x-mes-proceso,"99").
        x-mes-proceso = x-mes-proceso - 1.
        IF x-mes-proceso <= 0 THEN x-mes-proceso = 12.
    END.
    IF lSec = 12 THEN DO:
        txtMes12:SCREEN-VALUE  = lSemaforo.
        txtMes12:FGCOLOR  = get-color-semaforo(lSemaforo).
        /* --  */
        M12:SCREEN-VALUE = STRING(x-mes-proceso,"99").
        x-mes-proceso = x-mes-proceso - 1.
        IF x-mes-proceso <= 0 THEN x-mes-proceso = 12.
    END.
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
  {src/adm/template/snd-list.i "tt-deudas-anteriores"}
  {src/adm/template/snd-list.i "tt-deudas-actual"}
  {src/adm/template/snd-list.i "tt-lineas-credito"}
  {src/adm/template/snd-list.i "tt-deudas-finan"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-calificacion W-Win 
FUNCTION get-calificacion RETURNS CHARACTER
  (INPUT pCodCalf AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR lRetVal AS CHAR.

lRetVal = pCodCalf.

CASE pCodCalf :
    WHEN "NOR" THEN lRetVal = "Normal".
    WHEN "CPP" THEN lRetVal = "Con perdidas potenciales".
    WHEN "DEF" THEN lRetVal = "Deficiente".
    WHEN "DUD" THEN lRetVal = "Dudoso".
    WHEN "PER" THEN lRetVal = "Perdida".
    WHEN "SCAL" THEN lRetVal = "Sin Calificacion".
END CASE.

RETURN lRetVal.

END FUNCTION.

/*
Normal,NOR,
Con perdidas potenciales,CPP,
Deficiente,DEF,
Dudoso,DUD,
Perdida,PER,
Sin Calificacion,SCAL
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-color-semaforo W-Win 
FUNCTION get-color-semaforo RETURNS INTEGER
  (INPUT pSemaforo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR lRetVal AS INT.

lRetVal = 0.

IF CAPS(pSemaforo) = "A" THEN lRetval = 14.
IF CAPS(pSemaforo) = "R" THEN lRetval = 12.
IF CAPS(pSemaforo) = "G" THEN lRetval = 8.
IF CAPS(pSemaforo) = "V" THEN lRetval = 2.

RETURN lRetVal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-tipo-cuenta W-Win 
FUNCTION get-tipo-cuenta RETURNS CHARACTER
  (INPUT pTipoCuenta AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VAR lPos AS INT.
DEFINE VAR lRetVal AS CHAR.

lRetVal = pTipoCuenta.

CASE pTipoCuenta :
    WHEN "TCO" THEN lRetVal = "Tarjetas de Credito de Consumo".
    WHEN "COR" THEN lRetVal = "Cuenta Corriente".
    WHEN "DES" THEN lRetVal = "Descuentos".
    WHEN "PRE" THEN lRetVal = "Prestamos".
    WHEN "AVF" THEN lRetVal = "Avales y Fianzas".
    WHEN "CCR" THEN lRetVal = "Cartas de Credito".
    WHEN "TOT" THEN lRetVal = "Otras Tarjetas de Credito".
END CASE.

/*
Tarjetas de Credito de Consumo,TCO,
Cuenta Corriente,COR,
Descuentos,DES,
Prestamos,PRE,
Avales y Fianzas,AVF,
Cartas de Credito,CCR,
Otras Tarjetas de Credito,TOT
*/


  RETURN lRetval.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

