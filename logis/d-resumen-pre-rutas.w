&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE dd-w-report NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
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

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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

DEFINE TEMP-TABLE ppResumen
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

DEFINE TEMP-TABLE   ppDetalle
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

DEFINE INPUT PARAMETER TABLE FOR ppResumen.
DEFINE INPUT PARAMETER TABLE FOR ppDetalle.
DEFINE OUTPUT PARAMETER pProcesar AS CHAR. 

DEFINE SHARED VAR s-codcia AS INT.

DEFINE VAR x-cuadrante AS CHAR.

pProcesar = "NO".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-4

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-w-report dd-w-report

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 tt-w-report.Campo-C[1] ~
tt-w-report.Campo-I[1] tt-w-report.Campo-I[2] tt-w-report.Campo-F[1] ~
tt-w-report.Campo-F[2] tt-w-report.Campo-F[3] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 tt-w-report


/* Definitions for BROWSE BROWSE-6                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-6 dd-w-report.Campo-C[1] ~
dd-w-report.Campo-C[2] dd-w-report.Campo-C[3] dd-w-report.Campo-D[1] ~
dd-w-report.Campo-I[1] dd-w-report.Campo-F[1] dd-w-report.Campo-F[2] ~
dd-w-report.Campo-F[3] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-6 
&Scoped-define QUERY-STRING-BROWSE-6 FOR EACH dd-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-6 OPEN QUERY BROWSE-6 FOR EACH dd-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-6 dd-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-6 dd-w-report


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-4}~
    ~{&OPEN-QUERY-BROWSE-6}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-4 BROWSE-6 Btn_Cancel Btn_OK 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-tot-od FILL-IN-tot-cli ~
FILL-IN-tot-peso FILL-IN-tot-vol FILL-IN-tot-imp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "GENERAR RUTAS" 
     SIZE 19.57 BY 1.15
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-tot-cli AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.43 BY 1
     BGCOLOR 9 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-tot-imp AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14.57 BY 1
     BGCOLOR 9 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-tot-od AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.43 BY 1
     BGCOLOR 9 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-tot-peso AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY 1
     BGCOLOR 9 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-tot-vol AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY 1
     BGCOLOR 9 FGCOLOR 15 FONT 6 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      tt-w-report SCROLLING.

DEFINE QUERY BROWSE-6 FOR 
      dd-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 D-Dialog _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      tt-w-report.Campo-C[1] COLUMN-LABEL "Cuadrante" FORMAT "X(25)":U
            WIDTH 31
      tt-w-report.Campo-I[1] COLUMN-LABEL "O/D" FORMAT ">>>,>>9":U
            WIDTH 9.43
      tt-w-report.Campo-I[2] COLUMN-LABEL "Nro.Clientes" FORMAT ">>>,>>9":U
      tt-w-report.Campo-F[1] COLUMN-LABEL "Peso" FORMAT "->>>,>>9.99":U
            WIDTH 11.43
      tt-w-report.Campo-F[2] COLUMN-LABEL "Volumen" FORMAT "->>>,>>9.99":U
            WIDTH 11.43
      tt-w-report.Campo-F[3] COLUMN-LABEL "Importe" FORMAT "->>,>>>,>>9.99":U
            WIDTH 13.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 93.57 BY 8.65 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-6 D-Dialog _STRUCTURED
  QUERY BROWSE-6 NO-LOCK DISPLAY
      dd-w-report.Campo-C[1] COLUMN-LABEL "Cod" FORMAT "X(5)":U
            WIDTH 5.43 COLUMN-FONT 0
      dd-w-report.Campo-C[2] COLUMN-LABEL "Nro.Doc" FORMAT "X(12)":U
            WIDTH 9.43 COLUMN-FONT 0
      dd-w-report.Campo-C[3] COLUMN-LABEL "Cliente" FORMAT "X(50)":U
            WIDTH 37.43 COLUMN-FONT 0
      dd-w-report.Campo-D[1] COLUMN-LABEL "Entrega" FORMAT "99/99/9999":U
            COLUMN-FONT 0
      dd-w-report.Campo-I[1] COLUMN-LABEL "Items" FORMAT ">>>,>>9":U
            COLUMN-FONT 0
      dd-w-report.Campo-F[1] COLUMN-LABEL "Peso" FORMAT "->>>,>>9.99":U
            COLUMN-FONT 0
      dd-w-report.Campo-F[2] COLUMN-LABEL "Importe" FORMAT "->,>>>,>>9.99":U
            WIDTH 9.72 COLUMN-FONT 0
      dd-w-report.Campo-F[3] COLUMN-LABEL "Volumen" FORMAT "->>>,>>9.99":U
            WIDTH 11.72 COLUMN-FONT 0
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 106 BY 14.27 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-4 AT ROW 1.38 COL 2.43 WIDGET-ID 200
     BROWSE-6 AT ROW 13.08 COL 2.29 WIDGET-ID 300
     Btn_Help AT ROW 1 COL 47
     FILL-IN-tot-od AT ROW 10.23 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     FILL-IN-tot-cli AT ROW 10.23 COL 42.57 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     FILL-IN-tot-peso AT ROW 10.23 COL 52.57 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     FILL-IN-tot-vol AT ROW 10.23 COL 64.57 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     FILL-IN-tot-imp AT ROW 10.23 COL 76.72 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     Btn_Cancel AT ROW 11.46 COL 55.29
     Btn_OK AT ROW 11.46 COL 71.57
     SPACE(20.42) SKIP(15.15)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Resumen pre-rutas para generarcion" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: dd-w-report T "?" NO-UNDO INTEGRAL w-report
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-4 1 D-Dialog */
/* BROWSE-TAB BROWSE-6 BROWSE-4 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON Btn_Help IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       Btn_Help:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-tot-cli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-tot-imp IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-tot-od IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-tot-peso IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-tot-vol IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-C[1]
"tt-w-report.Campo-C[1]" "Cuadrante" "X(25)" "character" ? ? ? ? ? ? no ? no no "31" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-I[1]
"tt-w-report.Campo-I[1]" "O/D" ">>>,>>9" "integer" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-I[2]
"tt-w-report.Campo-I[2]" "Nro.Clientes" ">>>,>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-F[1]
"tt-w-report.Campo-F[1]" "Peso" "->>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-F[2]
"tt-w-report.Campo-F[2]" "Volumen" "->>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-w-report.Campo-F[3]
"tt-w-report.Campo-F[3]" "Importe" "->>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "13.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-6
/* Query rebuild information for BROWSE BROWSE-6
     _TblList          = "Temp-Tables.dd-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.dd-w-report.Campo-C[1]
"dd-w-report.Campo-C[1]" "Cod" "X(5)" "character" ? ? 0 ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.dd-w-report.Campo-C[2]
"dd-w-report.Campo-C[2]" "Nro.Doc" "X(12)" "character" ? ? 0 ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.dd-w-report.Campo-C[3]
"dd-w-report.Campo-C[3]" "Cliente" "X(50)" "character" ? ? 0 ? ? ? no ? no no "37.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.dd-w-report.Campo-D[1]
"dd-w-report.Campo-D[1]" "Entrega" ? "date" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.dd-w-report.Campo-I[1]
"dd-w-report.Campo-I[1]" "Items" ">>>,>>9" "integer" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.dd-w-report.Campo-F[1]
"dd-w-report.Campo-F[1]" "Peso" "->>>,>>9.99" "decimal" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.dd-w-report.Campo-F[2]
"dd-w-report.Campo-F[2]" "Importe" "->,>>>,>>9.99" "decimal" ? ? 0 ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.dd-w-report.Campo-F[3]
"dd-w-report.Campo-F[3]" "Volumen" "->>>,>>9.99" "decimal" ? ? 0 ? ? ? no ? no no "11.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-6 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON END-ERROR OF FRAME D-Dialog /* Resumen pre-rutas para generarcion */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Resumen pre-rutas para generarcion */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  /*APPLY "END-ERROR":U TO SELF.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
&Scoped-define SELF-NAME BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 D-Dialog
ON ENTRY OF BROWSE-4 IN FRAME D-Dialog
DO:
  x-cuadrante = "".
  IF AVAILABLE tt-w-report THEN x-cuadrante = tt-w-report.campo-c[10].
  RUN carga-detalle.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 D-Dialog
ON VALUE-CHANGED OF BROWSE-4 IN FRAME D-Dialog
DO:
    x-cuadrante = "".
    IF AVAILABLE tt-w-report THEN x-cuadrante = tt-w-report.campo-c[10].
    
    RUN carga-detalle.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancel */
DO:
  pProcesar = "NO".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help D-Dialog
ON CHOOSE OF Btn_Help IN FRAME D-Dialog /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
MESSAGE "Help for File: {&FILE-NAME}":U VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* GENERAR RUTAS */
DO:
    pProcesar = "NO".

    btn_ok:AUTO-GO = NO.

    MESSAGE 'Seguro de Procesar?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = YES THEN DO:
        pProcesar = "SI".
        btn_ok:AUTO-GO = YES.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-detalle D-Dialog 
PROCEDURE carga-detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
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
*/

EMPTY TEMP-TABLE dd-w-report.

FOR EACH ppDetalle WHERE ppDetalle.tcuadrante = x-cuadrante:
    CREATE dd-w-report.
        ASSIGN dd-w-report.campo-c[1] = ppDetalle.tcoddoc
                dd-w-report.campo-c[2] = ppDetalle.tnroped
                dd-w-report.campo-c[3] = ppDetalle.tnomcli
                dd-w-report.campo-d[1] = ppDetalle.tfchent
                dd-w-report.campo-i[1] = ppDetalle.titems
                dd-w-report.campo-f[1] = ppDetalle.ttotpeso
                dd-w-report.campo-f[2] = ppDetalle.ttotimp
                dd-w-report.campo-f[3] = ppDetalle.ttotvol
        .
END.

{&open-query-browse-6}

END PROCEDURE.

/*
O/D , Cliente , Fecha Entrega,Items,Peso,S/,m3
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-tot-od FILL-IN-tot-cli FILL-IN-tot-peso FILL-IN-tot-vol 
          FILL-IN-tot-imp 
      WITH FRAME D-Dialog.
  ENABLE BROWSE-4 BROWSE-6 Btn_Cancel Btn_OK 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
DEFINE VAR x-tot-ord AS INT INIT 0.
DEFINE VAR x-tot-cli AS INT INIT 0.
DEFINE VAR x-tot-peso AS DEC INIT 0.
DEFINE VAR x-tot-vol AS DEC INIT 0.
DEFINE VAR x-tot-imp AS DEC INIT 0.

SESSION:SET-WAIT-STATE("GENERAL").
FOR EACH ppResumen NO-LOCK:

    FIND FIRST rut-cuadrante-cab WHERE rut-cuadrante-cab.codcia = s-codcia AND
                                          rut-cuadrante-cab.cuadrante = ppResumen.tcuadrante NO-LOCK NO-ERROR.

    CREATE tt-w-report.
        ASSIGN tt-w-report.campo-c[1] = if(AVAILABLE rut-cuadrante-cab) THEN rut-cuadrante-cab.descripcion ELSE ppResumen.tcuadrante
                  tt-w-report.campo-i[1] = ppResumen.ttotord
                  tt-w-report.campo-i[2] = ppResumen.ttotclie
                  tt-w-report.campo-f[1] = ppResumen.ttotpeso
                  tt-w-report.campo-f[2] = ppResumen.ttotvol
                  tt-w-report.campo-f[3] = ppResumen.ttotimp
                  tt-w-report.campo-c[10] = ppResumen.tcuadrante
      .
  x-tot-ord =  x-tot-ord + ppResumen.ttotord.
  x-tot-cli = x-tot-cli + ppResumen.ttotclie.
  x-tot-peso = x-tot-peso + ppResumen.ttotpeso.
  x-tot-vol = x-tot-vol + ppResumen.ttotvol.
  x-tot-imp = x-tot-imp + ppResumen.ttotimp.
END.

/*{&open-query-browe-4}.*/

SESSION:SET-WAIT-STATE("").


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  fill-in-tot-od:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-tot-ord,">>,>>9").
  fill-in-tot-cli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-tot-cli,">>,>>9").
  fill-in-tot-peso:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-tot-peso,">>>,>>9.99").
  fill-in-tot-vol:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-tot-vol,">>>,>>9.99").
  fill-in-tot-imp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-tot-imp,">>,>>>,>>9.99").

  /**/
  FIND FIRST tt-w-report NO-ERROR.
  x-cuadrante = "".
  IF AVAILABLE tt-w-report THEN x-cuadrante = tt-w-report.campo-c[1].
  RUN carga-detalle.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros D-Dialog 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
PROCEDURE recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN ASSIGN input-var-1 = "".
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "dd-w-report"}
  {src/adm/template/snd-list.i "tt-w-report"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

