&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE dtl-w-report NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE rsm-w-report NO-UNDO LIKE w-report.



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
/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER TABLE FOR ppResumen.
DEFINE INPUT PARAMETER TABLE FOR ppDetalle.
DEFINE OUTPUT PARAMETER pProcesar AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-codcia AS INT.

DEFINE TEMP-TABLE   ttClientes
    FIELD   tcuadrante     AS  CHAR    FORMAT 'x(5)'
    FIELD   tubigeo     AS  CHAR    FORMAT 'x(8)'
    FIELD   tcodcli     AS  CHAR    FORMAT 'x(12)'
.

DEFINE VAR x-cuadrante AS CHAR INIT "".

&SCOPED-DEFINE CONDICION ( ~
            dtl-w-report.campo-c[1] = x-cuadrante)

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-7

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES rsm-w-report dtl-w-report

/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 rsm-w-report.Campo-C[4] ~
rsm-w-report.Campo-C[1] rsm-w-report.Campo-C[2] rsm-w-report.Campo-I[1] ~
rsm-w-report.Campo-I[2] rsm-w-report.Campo-F[1] rsm-w-report.Campo-F[2] ~
rsm-w-report.Campo-F[3] rsm-w-report.Campo-C[3] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7 
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH rsm-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY BROWSE-7 FOR EACH rsm-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 rsm-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 rsm-w-report


/* Definitions for BROWSE BROWSE-8                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-8 dtl-w-report.Campo-C[2] ~
dtl-w-report.Campo-C[3] dtl-w-report.Campo-I[1] dtl-w-report.Campo-I[2] ~
dtl-w-report.Campo-F[1] dtl-w-report.Campo-F[2] dtl-w-report.Campo-F[3] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-8 
&Scoped-define QUERY-STRING-BROWSE-8 FOR EACH dtl-w-report ~
      WHERE {&CONDICION} NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-8 OPEN QUERY BROWSE-8 FOR EACH dtl-w-report ~
      WHERE {&CONDICION} NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-8 dtl-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-8 dtl-w-report


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-7}~
    ~{&OPEN-QUERY-BROWSE-8}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-7 BROWSE-8 Btn_OK Btn_Cancel 

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
     LABEL "Continuar" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-7 FOR 
      rsm-w-report SCROLLING.

DEFINE QUERY BROWSE-8 FOR 
      dtl-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 D-Dialog _STRUCTURED
  QUERY BROWSE-7 NO-LOCK DISPLAY
      rsm-w-report.Campo-C[4] COLUMN-LABEL "No. Pre-Ruta" FORMAT "X(11)":U
            COLUMN-FONT 0
      rsm-w-report.Campo-C[1] COLUMN-LABEL "Cod." FORMAT "X(5)":U
            WIDTH 6.43 COLUMN-FONT 0
      rsm-w-report.Campo-C[2] COLUMN-LABEL "Cuadrante" FORMAT "X(40)":U
            WIDTH 24.86 COLUMN-FONT 0
      rsm-w-report.Campo-I[1] COLUMN-LABEL "O/D" FORMAT ">>,>>9":U
            COLUMN-FONT 0
      rsm-w-report.Campo-I[2] COLUMN-LABEL "Clientes" FORMAT ">>,>>9":U
            WIDTH 9.57 COLUMN-FONT 0
      rsm-w-report.Campo-F[1] COLUMN-LABEL "Peso" FORMAT ">>>,>>9.99":U
            WIDTH 12.43 COLUMN-FONT 0
      rsm-w-report.Campo-F[2] COLUMN-LABEL "Volumen" FORMAT ">>>,>>9.99":U
            COLUMN-FONT 0
      rsm-w-report.Campo-F[3] COLUMN-LABEL "Importe" FORMAT ">,>>>,>>9.99":U
            WIDTH 12.29 COLUMN-FONT 0
      rsm-w-report.Campo-C[3] COLUMN-LABEL "Observacion" FORMAT "X(25)":U
            WIDTH 37 COLUMN-FONT 0
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 124.14 BY 8.62
         TITLE "Resumen de Cuadrantes" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-8 D-Dialog _STRUCTURED
  QUERY BROWSE-8 NO-LOCK DISPLAY
      dtl-w-report.Campo-C[2] COLUMN-LABEL "Ubigeo" FORMAT "X(8)":U
            COLUMN-FONT 0
      dtl-w-report.Campo-C[3] COLUMN-LABEL "Distrito" FORMAT "X(40)":U
            WIDTH 38.86 COLUMN-FONT 0
      dtl-w-report.Campo-I[1] COLUMN-LABEL "O/D" FORMAT ">>>,>>9":U
            WIDTH 9.14 COLUMN-FONT 0
      dtl-w-report.Campo-I[2] COLUMN-LABEL "Clientes" FORMAT "->>>,>>>,>>9":U
            COLUMN-FONT 0
      dtl-w-report.Campo-F[1] COLUMN-LABEL "Peso" FORMAT ">>>,>>9.99":U
            WIDTH 10.14 COLUMN-FONT 0
      dtl-w-report.Campo-F[2] COLUMN-LABEL "Volumen" FORMAT ">>>,>>9.99":U
            WIDTH 11.43 COLUMN-FONT 0
      dtl-w-report.Campo-F[3] COLUMN-LABEL "Importe" FORMAT ">>,>>>,>>9.99":U
            WIDTH 12.29 COLUMN-FONT 0
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 107 BY 13.46
         TITLE "Detalle del cuadrante por distrito" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     Btn_Help AT ROW 1 COL 78
     BROWSE-7 AT ROW 1.23 COL 1.86 WIDGET-ID 200
     BROWSE-8 AT ROW 10.04 COL 2 WIDGET-ID 300
     Btn_OK AT ROW 13.5 COL 111
     Btn_Cancel AT ROW 15.04 COL 111
     SPACE(1.28) SKIP(7.61)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Lista de Pre-Rutas por distrito" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: dtl-w-report T "?" NO-UNDO INTEGRAL w-report
      TABLE: rsm-w-report T "?" NO-UNDO INTEGRAL w-report
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
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-7 Btn_Help D-Dialog */
/* BROWSE-TAB BROWSE-8 BROWSE-7 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON Btn_Help IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       Btn_Help:HIDDEN IN FRAME D-Dialog           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _TblList          = "Temp-Tables.rsm-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.rsm-w-report.Campo-C[4]
"rsm-w-report.Campo-C[4]" "No. Pre-Ruta" "X(11)" "character" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.rsm-w-report.Campo-C[1]
"rsm-w-report.Campo-C[1]" "Cod." "X(5)" "character" ? ? 0 ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.rsm-w-report.Campo-C[2]
"rsm-w-report.Campo-C[2]" "Cuadrante" "X(40)" "character" ? ? 0 ? ? ? no ? no no "24.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.rsm-w-report.Campo-I[1]
"rsm-w-report.Campo-I[1]" "O/D" ">>,>>9" "integer" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.rsm-w-report.Campo-I[2]
"rsm-w-report.Campo-I[2]" "Clientes" ">>,>>9" "integer" ? ? 0 ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.rsm-w-report.Campo-F[1]
"rsm-w-report.Campo-F[1]" "Peso" ">>>,>>9.99" "decimal" ? ? 0 ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.rsm-w-report.Campo-F[2]
"rsm-w-report.Campo-F[2]" "Volumen" ">>>,>>9.99" "decimal" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.rsm-w-report.Campo-F[3]
"rsm-w-report.Campo-F[3]" "Importe" ">,>>>,>>9.99" "decimal" ? ? 0 ? ? ? no ? no no "12.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.rsm-w-report.Campo-C[3]
"rsm-w-report.Campo-C[3]" "Observacion" "X(25)" "character" ? ? 0 ? ? ? no ? no no "37" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-8
/* Query rebuild information for BROWSE BROWSE-8
     _TblList          = "Temp-Tables.dtl-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "{&CONDICION}"
     _FldNameList[1]   > Temp-Tables.dtl-w-report.Campo-C[2]
"dtl-w-report.Campo-C[2]" "Ubigeo" ? "character" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.dtl-w-report.Campo-C[3]
"dtl-w-report.Campo-C[3]" "Distrito" "X(40)" "character" ? ? 0 ? ? ? no ? no no "38.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.dtl-w-report.Campo-I[1]
"dtl-w-report.Campo-I[1]" "O/D" ">>>,>>9" "integer" ? ? 0 ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.dtl-w-report.Campo-I[2]
"dtl-w-report.Campo-I[2]" "Clientes" ? "integer" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.dtl-w-report.Campo-F[1]
"dtl-w-report.Campo-F[1]" "Peso" ">>>,>>9.99" "decimal" ? ? 0 ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.dtl-w-report.Campo-F[2]
"dtl-w-report.Campo-F[2]" "Volumen" ">>>,>>9.99" "decimal" ? ? 0 ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.dtl-w-report.Campo-F[3]
"dtl-w-report.Campo-F[3]" "Importe" ">>,>>>,>>9.99" "decimal" ? ? 0 ? ? ? no ? no no "12.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-8 */
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
ON END-ERROR OF FRAME D-Dialog /* Lista de Pre-Rutas por distrito */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Lista de Pre-Rutas por distrito */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  /* APPLY "END-ERROR":U TO SELF.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-7
&Scoped-define SELF-NAME BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-7 D-Dialog
ON VALUE-CHANGED OF BROWSE-7 IN FRAME D-Dialog /* Resumen de Cuadrantes */
DO:
    x-cuadrante = "".
    
    IF AVAILABLE rsm-w-report THEN x-cuadrante = rsm-w-report.campo-c[1].

    {&open-query-browse-8}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancel */
DO:
  pProcesar = 'NO'.
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
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Continuar */
DO:
  pProcesar = 'SI'.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-info D-Dialog 
PROCEDURE cargar-info :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE("GENERAL").

FOR EACH ppResumen :
    /* create  */
    CREATE rsm-w-report.
        ASSIGN rsm-w-report.campo-c[1] = ppResumen.tcuadrante
                rsm-w-report.campo-c[2] = ""      /* Nombre del cuadrante */
                rsm-w-report.campo-i[1] = ppResumen.ttotord
                rsm-w-report.campo-i[2] = ppResumen.ttotclie
                rsm-w-report.campo-f[1] = ppResumen.ttotpeso
                rsm-w-report.campo-f[2] = ppResumen.ttotvol
                rsm-w-report.campo-f[3] = ppResumen.ttotimp
                rsm-w-report.campo-c[3] = ppResumen.tobserva
                rsm-w-report.campo-c[4] = ppResumen.tnro-phruta
        .
        FIND FIRST rut-cuadrante-cab WHERE rut-cuadrante-cab.codcia = s-codcia AND
                                                rut-cuadrante-cab.cuadrante = ppResumen.tcuadrante 
                                                NO-LOCK NO-ERROR.
        IF AVAILABLE rut-cuadrante-cab THEN 
                    ASSIGN rsm-w-report.campo-c[2] = rut-cuadrante-cab.descripcion.

    FOR EACH ppDetalle WHERE ppDetalle.tcuadrante = ppResumen.tcuadrante :
        FIND FIRST dtl-w-report WHERE dtl-w-report.campo-c[1] = ppDetalle.tcuadrante AND
                                        dtl-w-report.campo-c[2] = ppDetalle.tubigeo NO-ERROR.
        IF NOT AVAILABLE dtl-w-report THEN DO:
            CREATE dtl-w-report.
                ASSIGN dtl-w-report.campo-c[1] = ppDetalle.tcuadrante
                dtl-w-report.campo-c[2] = ppDetalle.tubigeo
                dtl-w-report.campo-c[3] = ""        /* Descripcion ubigeo */
                dtl-w-report.campo-i[2] = 0     /* Clientes */
            .
            IF LENGTH(ppDetalle.tubigeo) >= 6 THEN DO:
                FIND FIRST tabdistr WHERE tabdistr.coddepto = SUBSTRING(ppDetalle.tubigeo,1,2) AND
                                            tabdistr.codprovi = SUBSTRING(ppDetalle.tubigeo,3,2) AND
                                            tabdistr.coddistr = SUBSTRING(ppDetalle.tubigeo,5,2) 
                                            NO-LOCK NO-ERROR.
                IF AVAILABLE tabdistr THEN dtl-w-report.campo-c[3] = tabdistr.nomdistr.
            END.
        END.
        ASSIGN dtl-w-report.campo-i[1] = dtl-w-report.campo-i[1] + 1                
                dtl-w-report.campo-f[1] = dtl-w-report.campo-f[1] + ppDetalle.ttotpeso
                dtl-w-report.campo-f[2] = dtl-w-report.campo-f[2] + ppDetalle.ttotvol
                dtl-w-report.campo-f[3] = dtl-w-report.campo-f[3] + ppDetalle.ttotimp
        .
        FIND FIRST ttClientes WHERE ttClientes.tcuadrante = ppDetalle.tcuadrante AND
                                        ttClientes.tubigeo = ppDetalle.tubigeo AND
                                        ttClientes.tcodcli = ppDetalle.tcodcli NO-ERROR.
        IF NOT AVAILABLE ttClientes THEN DO:
            CREATE ttClientes.
                ASSIGN ttClientes.tcuadrante = ppDetalle.tcuadrante
                            ttClientes.tubigeo = ppDetalle.tubigeo
                            ttClientes.tcodcli = ppDetalle.tcodcli.
            dtl-w-report.campo-i[2] = dtl-w-report.campo-i[2] + 1.
        END.
    END.
END.

x-cuadrante = "".
FIND FIRST rsm-w-report NO-ERROR.
IF AVAILABLE rsm-w-report THEN x-cuadrante = rsm-w-report.campo-c[1].

{&open-query-browse-7}
{&open-query-browse-8}

SESSION:SET-WAIT-STATE("GENERAL").
/*


DEFINE TEMP-TABLE ppResumen
    FIELD   tcuadrante     AS  CHAR    FORMAT 'x(5)'
    FIELD   ttotclie    AS  INT     INIT 0
    FIELD   ttotpeso    AS  DEC     INIT 0
    FIELD   ttotvol     AS  DEC     INIT 0
    FIELD   ttotimp     AS  DEC     INIT 0
    FIELD   ttotord     AS  INT     INIT 0
    FIELD   tnro-phruta AS CHAR     FORMAT 'x(15)'
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
.
*/

END PROCEDURE.

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
  ENABLE BROWSE-7 BROWSE-8 Btn_OK Btn_Cancel 
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
  RUN cargar-info.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "dtl-w-report"}
  {src/adm/template/snd-list.i "rsm-w-report"}

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

