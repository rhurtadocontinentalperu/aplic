&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
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
DEFINE INPUT PARAMETER pCodDoc AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pNroDoc AS CHAR NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-codcia AS INT.
DEFINE VAR x-oc AS CHAR INIT "".
DEFINE VAR x-oldvalue AS CHAR INIT "".

DEFINE BUFFER x-tt-w-report FOR tt-w-report.
DEFINE TEMP-TABLE rr-w-report LIKE w-report.

DEF STREAM REPORTE.

DEFINE VAR x-total-bultos AS INT INIT 0.

{src/bin/_prns.i}

DEFINE VAR s-task-no AS INT.

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "aplic/vta2/rbvta2.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Hoja Ruta2".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

/* capturamos ruta inicial */
DEF VAR S-REPORT-LIBRARY AS CHAR.
GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE s-report-library.
RB-REPORT-LIBRARY = s-report-library + "vta2\rbvta2.prl".


DEFINE TEMP-TABLE tt-bcp-extraordinarios
    FIELD Trimestre         AS CHAR FORMAT 'X(200)'
    FIELD GrupoReparto      AS CHAR FORMAT 'X(200)'
    FIELD Pedidocompra      AS CHAR FORMAT 'X(200)'
    FIELD Posicionpedido    AS CHAR FORMAT 'X(200)'
    FIELD SolicitudPedido   AS CHAR FORMAT 'X(200)'
    FIELD CodigoCentro      AS CHAR FORMAT 'X(200)'
    FIELD NombreCentro      AS CHAR FORMAT 'X(200)'
    FIELD CodigoAlmacen     AS CHAR FORMAT 'X(200)'
    FIELD NombreAlmacen     AS CHAR FORMAT 'X(200)'
    FIELD CentroCostos      AS CHAR FORMAT 'X(200)'
    FIELD Direccion         AS CHAR FORMAT 'X(200)'
    FIELD Departamento      AS CHAR FORMAT 'X(200)'
    FIELD Provincia         AS CHAR FORMAT 'X(200)'
    FIELD Distrito          AS CHAR FORMAT 'X(200)'
    FIELD Telefono          AS CHAR FORMAT 'X(200)'
    FIELD NombreReceptor    AS CHAR FORMAT 'X(200)'
    FIELD FechaEntrega      AS CHAR FORMAT 'X(200)'
    FIELD CodigoMaterial    AS CHAR FORMAT 'X(200)'
    FIELD CodmaterialAntiguo    AS CHAR FORMAT 'X(200)'
    FIELD DescripcionMaterial   AS CHAR FORMAT 'X(200)'
    FIELD Cantidad          AS CHAR FORMAT 'X(200)'
    FIELD UM                AS CHAR FORMAT 'X(200)'
    FIELD DescripcionUM     AS CHAR FORMAT 'X(200)'
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-w-report

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tt-w-report.Campo-I[1] ~
tt-w-report.Campo-L[1] tt-w-report.Campo-C[7] tt-w-report.Campo-C[1] ~
tt-w-report.Campo-C[2] tt-w-report.Campo-C[3] tt-w-report.Campo-C[4] ~
tt-w-report.Campo-F[1] tt-w-report.Campo-C[5] tt-w-report.Campo-C[6] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 tt-w-report.Campo-L[1] ~
tt-w-report.Campo-C[3] tt-w-report.Campo-C[4] 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-2 tt-w-report
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-2 tt-w-report
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tt-w-report NO-LOCK ~
    BY tt-w-report.Campo-C[7] ~
       BY tt-w-report.Campo-C[1]
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tt-w-report NO-LOCK ~
    BY tt-w-report.Campo-C[7] ~
       BY tt-w-report.Campo-C[1].
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tt-w-report


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-savesap FILL-IN-codorden ~
FILL-IN-nroorden FILL-IN-oc BROWSE-2 Btn_OK Btn_Cancel BUTTON-todos ~
BUTTON-ninguno FILL-IN-total-bultos 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-codorden FILL-IN-nroorden ~
FILL-IN-oc FILL-IN-total-bultos 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Salir" 
     SIZE 10 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Imprimir Rotulos Supermercados" 
     SIZE 23 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-ninguno 
     LABEL "Ninguno" 
     SIZE 14 BY .96.

DEFINE BUTTON BUTTON-savesap  NO-FOCUS FLAT-BUTTON
     LABEL "Grabar codigos de SAP" 
     SIZE 18 BY .96.

DEFINE BUTTON BUTTON-todos 
     LABEL "Todos" 
     SIZE 14 BY .96.

DEFINE VARIABLE FILL-IN-codorden AS CHARACTER FORMAT "X(5)":U 
     LABEL "Cod.Orden" 
     VIEW-AS FILL-IN 
     SIZE 5 BY 1
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-nroorden AS CHARACTER FORMAT "X(12)":U 
     LABEL "Nro. Orden" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-oc AS CHARACTER FORMAT "X(20)":U 
     LABEL "O/C" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-total-bultos AS CHARACTER FORMAT "X(25)":U INITIAL "0" 
     LABEL "Total Bultos" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1.12
     BGCOLOR 15 FGCOLOR 9 FONT 11 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 D-Dialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tt-w-report.Campo-I[1] COLUMN-LABEL "Item" FORMAT "->>,>>9":U
            WIDTH 4.29
      tt-w-report.Campo-L[1] COLUMN-LABEL "Imprimir" FORMAT "Si/No":U
            VIEW-AS TOGGLE-BOX
      tt-w-report.Campo-C[7] COLUMN-LABEL "Bulto" FORMAT "X(25)":U
            WIDTH 22
      tt-w-report.Campo-C[1] COLUMN-LABEL "Articulo" FORMAT "X(8)":U
      tt-w-report.Campo-C[2] COLUMN-LABEL "Descripcion" FORMAT "X(60)":U
            WIDTH 39.29
      tt-w-report.Campo-C[3] COLUMN-LABEL "SAP" FORMAT "X(15)":U
            WIDTH 17.29
      tt-w-report.Campo-C[4] COLUMN-LABEL "U.Medida" FORMAT "X(15)":U
            WIDTH 7.43
      tt-w-report.Campo-F[1] COLUMN-LABEL "Peso" FORMAT "->>,>>9.99":U
      tt-w-report.Campo-C[5] COLUMN-LABEL "Cantidad" FORMAT "X(12)":U
            WIDTH 8.29
      tt-w-report.Campo-C[6] COLUMN-LABEL "EAN" FORMAT "X(15)":U
            WIDTH 16.86
  ENABLE
      tt-w-report.Campo-L[1]
      tt-w-report.Campo-C[3]
      tt-w-report.Campo-C[4]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 141.86 BY 11.81
         FONT 4 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     Btn_Help AT ROW 1.19 COL 81
     BUTTON-savesap AT ROW 15.04 COL 31.29 WIDGET-ID 12
     FILL-IN-codorden AT ROW 1.38 COL 13 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-nroorden AT ROW 1.38 COL 29 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-oc AT ROW 1.38 COL 49 COLON-ALIGNED WIDGET-ID 6
     BROWSE-2 AT ROW 2.65 COL 2.14 WIDGET-ID 200
     Btn_OK AT ROW 14.81 COL 101
     Btn_Cancel AT ROW 14.85 COL 126
     BUTTON-todos AT ROW 15.04 COL 2 WIDGET-ID 8
     BUTTON-ninguno AT ROW 15.04 COL 16.43 WIDGET-ID 10
     FILL-IN-total-bultos AT ROW 15.04 COL 56.14 COLON-ALIGNED WIDGET-ID 14
     SPACE(80.14) SKIP(0.95)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Rotulo de SUPERMERCADOS" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
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
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 FILL-IN-oc D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

ASSIGN 
       tt-w-report.Campo-L[1]:VISIBLE IN BROWSE BROWSE-2 = FALSE.

/* SETTINGS FOR BUTTON Btn_Help IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       Btn_Help:HIDDEN IN FRAME D-Dialog           = TRUE.

ASSIGN 
       FILL-IN-codorden:READ-ONLY IN FRAME D-Dialog        = TRUE.

ASSIGN 
       FILL-IN-nroorden:READ-ONLY IN FRAME D-Dialog        = TRUE.

ASSIGN 
       FILL-IN-oc:READ-ONLY IN FRAME D-Dialog        = TRUE.

ASSIGN 
       FILL-IN-total-bultos:READ-ONLY IN FRAME D-Dialog        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-w-report.Campo-C[7]|yes,Temp-Tables.tt-w-report.Campo-C[1]|yes"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-I[1]
"tt-w-report.Campo-I[1]" "Item" "->>,>>9" "integer" ? ? ? ? ? ? no ? no no "4.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-L[1]
"tt-w-report.Campo-L[1]" "Imprimir" ? "logical" ? ? ? ? ? ? yes ? no no ? no no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[7]
"tt-w-report.Campo-C[7]" "Bulto" "X(25)" "character" ? ? ? ? ? ? no ? no no "22" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-C[1]
"tt-w-report.Campo-C[1]" "Articulo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-C[2]
"tt-w-report.Campo-C[2]" "Descripcion" "X(60)" "character" ? ? ? ? ? ? no ? no no "39.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-w-report.Campo-C[3]
"tt-w-report.Campo-C[3]" "SAP" "X(15)" "character" ? ? ? ? ? ? yes ? no no "17.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-w-report.Campo-C[4]
"tt-w-report.Campo-C[4]" "U.Medida" "X(15)" "character" ? ? ? ? ? ? yes ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-w-report.Campo-F[1]
"tt-w-report.Campo-F[1]" "Peso" "->>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-w-report.Campo-C[5]
"tt-w-report.Campo-C[5]" "Cantidad" "X(12)" "character" ? ? ? ? ? ? no ? no no "8.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-w-report.Campo-C[6]
"tt-w-report.Campo-C[6]" "EAN" "X(15)" "character" ? ? ? ? ? ? no ? no no "16.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
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
ON END-ERROR OF FRAME D-Dialog /* Rotulo de SUPERMERCADOS */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Rotulo de SUPERMERCADOS */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  /*APPLY "END-ERROR":U TO SELF.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&Scoped-define SELF-NAME tt-w-report.Campo-C[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-w-report.Campo-C[3] BROWSE-2 _BROWSE-COLUMN D-Dialog
ON ENTRY OF tt-w-report.Campo-C[3] IN BROWSE BROWSE-2 /* SAP */
DO:
  x-oldvalue = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-w-report.Campo-C[3] BROWSE-2 _BROWSE-COLUMN D-Dialog
ON LEAVE OF tt-w-report.Campo-C[3] IN BROWSE BROWSE-2 /* SAP */
DO:
  DEFINE VAR x-codsap AS CHAR.
  DEFINE VAR x-codmat AS CHAR.

  DEFINE VAR x-cont AS INT INIT 0.

  DEFINE VAR x-rowid AS ROWID.

  x-codmat = tt-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} .

  x-codsap = SELF:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} .
  IF x-codsap <> x-oldvalue THEN DO:
      SESSION:SET-WAIT-STATE("GENERAL").
      
      
      x-rowid = ROWID(tt-w-report).

      FOR EACH x-tt-w-report WHERE x-tt-w-report.campo-c[1] = x-codmat :
          ASSIGN x-tt-w-report.campo-c[3] = x-codsap.
      END.
      
      {&open-query-browse-2}

      BROWSE-2:REFRESH() IN FRAME {&FRAME-NAME}.

      SESSION:SET-WAIT-STATE("").

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-w-report.Campo-C[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-w-report.Campo-C[4] BROWSE-2 _BROWSE-COLUMN D-Dialog
ON ENTRY OF tt-w-report.Campo-C[4] IN BROWSE BROWSE-2 /* U.Medida */
DO:
  x-oldvalue = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-w-report.Campo-C[4] BROWSE-2 _BROWSE-COLUMN D-Dialog
ON LEAVE OF tt-w-report.Campo-C[4] IN BROWSE BROWSE-2 /* U.Medida */
DO:
    DEFINE VAR x-undvta AS CHAR.
    DEFINE VAR x-codmat AS CHAR.

    DEFINE VAR x-cont AS INT INIT 0.

    x-codmat = tt-w-report.campo-c[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} .

    x-undvta = SELF:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} .
    IF x-undvta <> x-oldvalue THEN DO:
        SESSION:SET-WAIT-STATE("GENERAL").

        FOR EACH x-tt-w-report WHERE x-tt-w-report.campo-c[1] = x-codmat :
            ASSIGN x-tt-w-report.campo-c[4] = x-undvta.
        END.

        {&open-query-browse-2}

        BROWSE-2:REFRESH() IN FRAME {&FRAME-NAME}.

        SESSION:SET-WAIT-STATE("").

    END.
  
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
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Imprimir Rotulos Supermercados */
DO:
  btn_ok:AUTO-GO = NO.

  RUN imprimir-rotulo-supermercado.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-ninguno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-ninguno D-Dialog
ON CHOOSE OF BUTTON-ninguno IN FRAME D-Dialog /* Ninguno */
DO:
    /*
    SESSION:SET-WAIT-STATE("GENERAL").
    FOR EACH tt-w-report :
        ASSIGN tt-w-report.campo-l[1] = NO.
    END.
    {&OPEN-query-browse-2}
    SESSION:SET-WAIT-STATE("").
    */

    BROWSE-2:DESELECT-ROWS ( ).
    
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-savesap
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-savesap D-Dialog
ON CHOOSE OF BUTTON-savesap IN FRAME D-Dialog /* Grabar codigos de SAP */
DO:
        MESSAGE 'Seguro de GRABAR los codigo SAP del cliente?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

    RUN grabar-sap.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-todos D-Dialog
ON CHOOSE OF BUTTON-todos IN FRAME D-Dialog /* Todos */
DO:
    /*
  SESSION:SET-WAIT-STATE("GENERAL").
  FOR EACH tt-w-report :
      ASSIGN tt-w-report.campo-l[1] = YES.
  END.
  {&OPEN-query-browse-2}
  SESSION:SET-WAIT-STATE("").
  */
    BROWSE-2:SELECT-ALL().
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal D-Dialog 
PROCEDURE carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE("GENERAL").

DEFINE VAR xRegistros AS INT.
DEFINE VAR xCantidad AS DEC.
DEFINE VAR xPeso AS DEC.

EMPTY TEMP-TABLE tt-w-report.

DEFINE VAR x-test AS INT INIT 0.

FOR EACH Vtaddocu NO-LOCK WHERE VtaDDocu.CodCia =  s-codcia
    /*AND VtaDDocu.CodDiv = s-CodDiv*/
    AND VtaDDocu.CodPed = pCodDoc
    AND VtaDDocu.NroPed = pNroDOc,
    FIRST Almmmatg OF Vtaddocu NO-LOCK
    BREAK BY VtaDDocu.Libre_c01 BY VtaDDocu.NroItm:

    FIND FIRST tt-w-report WHERE tt-w-report.campo-c[7] = vtaddocu.libre_c01 /*AND
                                    tt-w-report.campo-c[1] = vtaddocu.codmat*/ NO-LOCK NO-ERROR.
    IF NOT AVAILABLE tt-w-report THEN DO:
        CREATE tt-w-report.
        ASSIGN  tt-w-report.campo-l[1] = NO
                tt-w-report.campo-c[1] = vtaddocu.codmat
                tt-w-report.campo-c[2] = almmmatg.desmat
                tt-w-report.campo-c[3] = ""                
                tt-w-report.campo-c[4] = vtaddocu.undvta
                tt-w-report.campo-c[5] = STRING(vtaddocu.canped,">>,>>9.99") 
                tt-w-report.campo-c[6] = almmmatg.codbrr
                tt-w-report.campo-c[7] = vtaddocu.libre_c01
                tt-w-report.campo-c[8] = x-oc
                tt-w-report.campo-c[9] = vtaddocu.codcli
                tt-w-report.campo-f[1] = 0
                tt-w-report.campo-i[1] = x-test + 1.

        xRegistros = xRegistros + 1.

        FIND FIRST supmmatg WHERE supmmatg.codcia = s-codcia AND
                                    supmmatg.codcli = vtaddocu.codcli AND
                                    supmmatg.codmat = vtaddocu.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE supmmatg THEN DO:
            ASSIGN tt-w-report.campo-c[3] = supmmatg.libre_c01.
            /* */
            IF NOT (TRUE <> (supmmatg.libre_c02 > "")) THEN DO:
                ASSIGN tt-w-report.campo-c[4] = supmmatg.libre_c02.
            END.
        END.
        x-test = x-test + 1.
    END.
    tt-w-report.campo-f[1] = tt-w-report.campo-f[1] + vtaddocu.pesmat.

END.

IF xRegistros = 0 THEN DO:
    /* Picking por Rutas */
    x-test = 0.
    FIND FIRST vtacdocu WHERE vtacdocu.codcia = 1 AND vtacdocu.codref = pCodDoc AND vtacdocu.nroref = pNroDoc
                            NO-LOCK NO-ERROR.
    IF AVAILABLE vtacdocu THEN DO:
        FOR EACH logisdchequeo WHERE logisdchequeo.codcia = 1 AND logisdchequeo.coddiv = vtacdocu.coddiv AND
                                    logisdchequeo.codped = vtacdocu.codped AND
                                    logisdchequeo.nroped = vtacdocu.nroped NO-LOCK :

            FIND FIRST Almmmatg WHERE Almmmatg.codcia = 1 AND Almmmatg.codmat = logisdchequeo.codmat NO-LOCK NO-ERROR.

            IF NOT AVAILABLE almmmatg THEN NEXT.

            FIND FIRST tt-w-report WHERE tt-w-report.campo-c[7] = logisdchequeo.etiqueta /*AND
                                            tt-w-report.campo-c[1] = vtaddocu.codmat*/ NO-LOCK NO-ERROR.
            
            IF NOT AVAILABLE tt-w-report THEN DO:

                xCantidad = logisdchequeo.canchk * logisdchequeo.factor.
                xPeso = xCantidad * almmmatg.pesmat.

                CREATE tt-w-report.
                ASSIGN  tt-w-report.campo-l[1] = NO
                        tt-w-report.campo-c[1] = logisdchequeo.codmat
                        tt-w-report.campo-c[2] = almmmatg.desmat
                        tt-w-report.campo-c[3] = ""                
                        tt-w-report.campo-c[4] = logisdchequeo.undvta
                        tt-w-report.campo-c[5] = "" /*STRING(logisdchequeo.canchk * logisdchequeo.factor,">>,>>9.99") */
                        tt-w-report.campo-c[6] = almmmatg.codbrr
                        tt-w-report.campo-c[7] = logisdchequeo.etiqueta
                        tt-w-report.campo-c[8] = x-oc
                        tt-w-report.campo-c[9] = vtacdocu.codcli
                        tt-w-report.campo-f[1] = 0
                        tt-w-report.campo-i[1] = x-test + 1.

                FIND FIRST supmmatg WHERE supmmatg.codcia = 1 AND
                                            supmmatg.codcli = vtacdocu.codcli AND
                                            supmmatg.codmat = logisdchequeo.codmat NO-LOCK NO-ERROR.
                IF AVAILABLE supmmatg THEN DO:
                    ASSIGN tt-w-report.campo-c[3] = supmmatg.libre_c01.
                    /* */
                    IF NOT (TRUE <> (supmmatg.libre_c02 > "")) THEN DO:
                        ASSIGN tt-w-report.campo-c[4] = supmmatg.libre_c02.
                    END.
                END.
                x-test = x-test + 1.

            END.
            ELSE DO:
                xCantidad = xCantidad + (logisdchequeo.canchk * logisdchequeo.factor).
                xPeso = xPeso + ((logisdchequeo.canchk * logisdchequeo.factor) * almmmatg.pesmat).
            END.
            ASSIGN tt-w-report.campo-f[1] = xPeso
                    tt-w-report.campo-c[5] = STRING(xCantidad,">>,>>9.99").
        END.
    END.
END.

x-total-bultos = x-test.

{&open-query-browwse-2}


SESSION:SET-WAIT-STATE("").

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
  DISPLAY FILL-IN-codorden FILL-IN-nroorden FILL-IN-oc FILL-IN-total-bultos 
      WITH FRAME D-Dialog.
  ENABLE BUTTON-savesap FILL-IN-codorden FILL-IN-nroorden FILL-IN-oc BROWSE-2 
         Btn_OK Btn_Cancel BUTTON-todos BUTTON-ninguno FILL-IN-total-bultos 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-sap D-Dialog 
PROCEDURE grabar-sap :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    SESSION:SET-WAIT-STATE("GENERAL").

    FOR EACH x-tt-w-report NO-LOCK:
        FIND FIRST supmmatg WHERE supmmatg.codcia = s-codcia AND
                                    supmmatg.codcli = x-tt-w-report.campo-c[9] AND
                                    supmmatg.codmat = x-tt-w-report.campo-c[1] EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE supmmatg THEN DO:
            CREATE supmmatg.
                ASSIGN supmmatg.codcia = s-codcia
                        supmmatg.codcli = x-tt-w-report.campo-c[9]
                        supmmatg.codmat = x-tt-w-report.campo-c[1]
                    .
        END.
        ASSIGN  supmmatg.libre_c01 = x-tt-w-report.campo-c[3]
               supmmatg.libre_c02 = x-tt-w-report.campo-c[4].
        RELEASE supmmatg.

    END.

    SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir-rotulo-bcp-extraordinario D-Dialog 
PROCEDURE imprimir-rotulo-bcp-extraordinario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                                        
/**/
FIND FIRST x-tt-w-report WHERE x-tt-w-report.campo-l[1] = YES NO-LOCK NO-ERROR.
    
IF NOT AVAILABLE rr-w-report THEN DO:
    MESSAGE "Elija Rotulos para imprimir".
    RETURN.
END.

SESSION:SET-WAIT-STATE('GENERAL').
/* creo el temporal */ 
REPEAT:
    s-task-no = RANDOM(1, 999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no
                    AND w-report.llave-c = USERID("DICTDB") NO-LOCK)
        THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no.
        LEAVE.
    END.
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir-rotulo-supermercado D-Dialog 
PROCEDURE imprimir-rotulo-supermercado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


EMPTY TEMP-TABLE rr-w-report.

DEFINE VAR x-seleccioandos AS INT.
DEFINE VAR x-current AS INT.

  DO WITH FRAME {&FRAME-NAME}:
    /*DO iCont = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:*/
    x-seleccioandos = {&BROWSE-NAME}:NUM-SELECTED-ROWS.
    DO x-current = 1 TO x-seleccioandos :
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(x-current) THEN DO:
            CREATE rr-w-report.
             ASSIGN         
                 /*rr-w-report.Llave-C  = "01" + faccpedi.nroped*/
                 rr-w-report.Campo-C[1] = ""
                 rr-w-report.Campo-C[2] = x-oc
                 rr-w-report.Campo-C[3] = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[3]
                 rr-w-report.Campo-C[4] = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[2]
                 rr-w-report.Campo-C[5] = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[4]
                 rr-w-report.Campo-C[6] = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[6]
                 rr-w-report.Campo-C[10] = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Campo-C[1]       /* CodMat */
                 rr-w-report.Campo-F[1] = DECIMAL(TRIM({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[5])).

             /*
             MESSAGE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Campo-C[7]  SKIP
                    {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Campo-C[1]  SKIP
                 {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Campo-C[2]  .
             */
        END.
    END.
  END.
/*
FOR EACH x-tt-w-report WHERE x-tt-w-report.campo-l[1] = YES NO-LOCK:
    CREATE rr-w-report.
     ASSIGN         
         /*rr-w-report.Llave-C  = "01" + faccpedi.nroped*/
         rr-w-report.Campo-C[1] = ""
         rr-w-report.Campo-C[2] = x-oc
         rr-w-report.Campo-C[3] = x-tt-w-report.campo-c[3]
         rr-w-report.Campo-C[4] = x-tt-w-report.campo-c[2]
         rr-w-report.Campo-C[5] = x-tt-w-report.campo-c[4]
         rr-w-report.Campo-C[6] = x-tt-w-report.campo-c[6]
         rr-w-report.Campo-C[10] = x-tt-w-report.Campo-C[1]       /* CodMat */
         rr-w-report.Campo-F[1] = DECIMAL(TRIM(x-tt-w-report.campo-c[5]))
         .                                               
END.
*/    
                                        
/**/
FIND FIRST rr-w-report NO-LOCK NO-ERROR.
IF NOT AVAILABLE rr-w-report THEN DO:
    MESSAGE "Elija Rotulos para imprimir".
    RETURN.
END.

OUTPUT STREAM REPORTE CLOSE.

DEFINE VAR rpta AS LOG.
DEFINE VAR x-ean13 AS CHAR.


SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.

OUTPUT STREAM REPORTE TO PRINTER.

/*
DEFINE VAR x-file-zpl AS CHAR.

x-file-zpl = "d:\tmp\" + REPLACE(pCoddoc,"/","") + "-" + pNroDOc + ".txt".

OUTPUT STREAM REPORTE TO VALUE(x-file-zpl).
*/
FOR EACH rr-w-report WHERE NO-LOCK:

    x-ean13 = if(rr-w-report.Campo-C[6] = "") THEN rr-w-report.Campo-C[10] ELSE rr-w-report.Campo-C[6].

    PUT STREAM REPORTE "^XA^LH010,010" SKIP.

    PUT STREAM REPORTE "^XA^LH010,010" SKIP.
    PUT STREAM REPORTE "^FO020,100" SKIP.
    PUT STREAM REPORTE "^GB780,470,3" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO020,160" SKIP.
    PUT STREAM REPORTE "^GB780,0,2" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO020,200" SKIP.
    PUT STREAM REPORTE "^GB780,0,2" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO020,240" SKIP.
    PUT STREAM REPORTE "^GB780,0,2" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO020,280" SKIP.
    PUT STREAM REPORTE "^GB780,0,2" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO020,360" SKIP.
    PUT STREAM REPORTE "^GB780,0,2" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO230,200" SKIP.
    PUT STREAM REPORTE "^GB0,370,2" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /*
    PUT STREAM REPORTE "^FO035,020" SKIP.
    PUT STREAM REPORTE "^AVN,0,0" SKIP.
    PUT STREAM REPORTE "^FDBULTO : " + rr-w-report.campo-c[1] FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */
    PUT STREAM REPORTE "^FO130,114" SKIP.
    PUT STREAM REPORTE "^ARN,05,05" SKIP.
    PUT STREAM REPORTE "^FDCONTINENTAL S.A.C.    R.U.C. 20100038146" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FO300,165" SKIP.
    PUT STREAM REPORTE "^ARN,05,05" SKIP.
    PUT STREAM REPORTE "^FDO/C " + rr-w-report.Campo-C[2] FORMAT 'x(20)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FO030,205" SKIP.
    PUT STREAM REPORTE "^ARN,05,05" SKIP.
    PUT STREAM REPORTE "^FDCODIGO SAP" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO350,205" SKIP.
    PUT STREAM REPORTE "^ARN,05,05" SKIP.
    PUT STREAM REPORTE "^FD" + rr-w-report.Campo-C[3] FORMAT 'x(15)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FO030,245" SKIP.
    PUT STREAM REPORTE "^ARN,05,05" SKIP.
    PUT STREAM REPORTE "^FDDESCRIPCION" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO250,245" SKIP.
    PUT STREAM REPORTE "^ARN,05,05" SKIP.
    PUT STREAM REPORTE "^FD" + rr-w-report.Campo-C[4] FORMAT 'x(35)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FO030,285" SKIP.
    PUT STREAM REPORTE "^ARN,05,05" SKIP.
    PUT STREAM REPORTE "^FDCANTIDAD /" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO250,305" SKIP.
    PUT STREAM REPORTE "^ARN,05,05" SKIP.
    PUT STREAM REPORTE "^FD" + STRING(rr-w-report.Campo-f[1],">>>,>>9.99") + " " + rr-w-report.Campo-C[5] FORMAT 'X(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FO030,325" SKIP.
    PUT STREAM REPORTE "^ARN,05,05" SKIP.
    PUT STREAM REPORTE "^FDUNIDADES" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FO045,425" SKIP.
    PUT STREAM REPORTE "^AUN,05,05" SKIP.
    PUT STREAM REPORTE "^FDEAN 13" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /*
    PUT STREAM REPORTE "^FO250,380" SKIP.
    PUT STREAM REPORTE "^A0N,50,25" SKIP.
    PUT STREAM REPORTE "^FDPAPEL FOTOCOPIA ATLAS" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */
    PUT STREAM REPORTE "^FO350,400" SKIP.
    PUT STREAM REPORTE "^BY3" SKIP.
    PUT STREAM REPORTE "^BEN,100,Y,N" SKIP.    
    PUT STREAM REPORTE "^FD" + x-ean13 FORMAT 'x(15)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^XZ" SKIP.

END.

OUTPUT STREAM REPORTE CLOSE.

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
  FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                              faccpedi.coddoc = pCodDoc AND 
                              faccpedi.nroped = pNroDOc NO-LOCK NO-ERROR.
  IF AVAILABLE faccpedi THEN DO:
      x-oc = faccpedi.ordcmp.
  END.
  
  RUN carga-temporal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    fill-in-oc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-oc.  
    fill-in-codorden:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pCodDoc.  
    fill-in-nroorden:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pNroDoc.  
    fill-in-total-bultos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-total-bultos).

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

