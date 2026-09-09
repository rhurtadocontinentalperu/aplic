&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
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

  Description: from BROWSER.W - Basic SmartBrowser Object Template

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
DEFINE SHARED VAR s-nomcia AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE SHARED VAR s-Periodo AS INT.
DEFINE SHARED VAR s-NroMes AS INT.

DEFINE VARIABLE total_ingresos AS DECIMAL NO-UNDO.
DEFINE VARIABLE total_dias AS DECIMAL NO-UNDO.
DEFINE VARIABLE s-task-no AS INT INITIAL 0 NO-UNDO.

DEF TEMP-TABLE detalle
    FIELD codper LIKE INTEGRAL.pl-pers.codper
    FIELD valcal-mes AS DEC EXTENT 4000.
DEFINE STREAM REPORTE.

DEFINE SHARED VAR s-ruccia AS INT.

DEF TEMP-TABLE calculados
    FIELD CodPer AS CHAR    FORMAT 'x(6)'   LABEL 'CODIGO'
    FIELD NomPer AS CHAR    FORMAT 'x(40)'  LABEL 'NOMBRE'
    FIELD DiasLab AS DEC    FORMAT '->>>,>>>,>>9.99'    LABEL 'DIAS LABORADOS'
    FIELD RemPer  AS DEC    FORMAT '->>>,>>>,>>9.99'    LABEL 'REMUN. PERCIBIDAS'
    FIELD DiasLabT AS DEC   FORMAT '->>>,>>>,>>9.99'    LABEL 'DIAS LABOR. POR LOS TRAB.'
    FIELD RemPerT AS DEC    FORMAT '->>>,>>>,>>9.99'    LABEL 'REMUN. PERCIBIDAS POR LOS TRAB.'
    FIELD ParDias AS DEC    FORMAT '->>>,>>>,>>9.99'    LABEL 'PARTICIP. POR DIAS LABORADOS'
    FIELD ParRem AS DEC     FORMAT '->>>,>>>,>>9.99'    LABEL 'PARTICIP. POR REMUNERACIONES'
    FIELD Deduc AS DEC      FORMAT '->>>,>>>,>>9.99'    LABEL 'DEDUCCIONES'
    FIELD TOTAL AS DEC      FORMAT '->>>,>>>,>>9.99'    LABEL 'TOTAL A PAGAR'
    INDEX llave01 AS PRIMARY codper.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES w-report

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table w-report.Llave-I w-report.Campo-C[1] w-report.Campo-c[3] w-report.Campo-F[2] /*WIDTH 11.43*/ w-report.Campo-F[1] w-report.Campo-F[6] w-report.Campo-F[7] w-report.Campo-F[3] w-report.Campo-F[8]   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table CASE RADIO-SET-Orden:     WHEN 1 THEN OPEN QUERY {&SELF-NAME} FOR EACH w-report         WHERE w-report.Task-No = s-task-no         AND w-report.Llave-C = s-user-id         AND ( COMBO-BOX-Seccion = "Todas" OR w-report.campo-c[3] = COMBO-BOX-Seccion )         AND ( COMBO-BOX-Planilla = "Todos" OR               ( COMBO-BOX-Planilla = "Activos" AND w-report.campo-d[1] = ? ) OR               ( COMBO-BOX-Planilla = "Cesados" AND w-report.campo-d[1] <> ? ) )         NO-LOCK         BY w-report.llave-i         INDEXED-REPOSITION.     WHEN 2 THEN OPEN QUERY {&SELF-NAME} FOR EACH w-report         WHERE w-report.Task-No = s-task-no         AND w-report.Llave-C = s-user-id         AND ( COMBO-BOX-Seccion = "Todas" OR w-report.campo-c[3] = COMBO-BOX-Seccion )         AND ( COMBO-BOX-Planilla = "Todos" OR               ( COMBO-BOX-Planilla = "Activos" AND w-report.campo-d[1] = ? ) OR               ( COMBO-BOX-Planilla = "Cesados" AND w-report.campo-d[1] <> ? ) )         NO-LOCK         BY w-report.campo-c[1]         INDEXED-REPOSITION.     WHEN 3 THEN OPEN QUERY {&SELF-NAME} FOR EACH w-report         WHERE w-report.Task-No = s-task-no         AND w-report.Llave-C = s-user-id         AND ( COMBO-BOX-Seccion = "Todas" OR w-report.campo-c[3] = COMBO-BOX-Seccion )         AND ( COMBO-BOX-Planilla = "Todos" OR               ( COMBO-BOX-Planilla = "Activos" AND w-report.campo-d[1] = ? ) OR               ( COMBO-BOX-Planilla = "Cesados" AND w-report.campo-d[1] <> ? ) )         NO-LOCK         BY w-report.campo-c[3]         INDEXED-REPOSITION. END CASE.
&Scoped-define TABLES-IN-QUERY-br_table w-report
&Scoped-define FIRST-TABLE-IN-QUERY-br_table w-report


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RADIO-SET-Orden BUTTON-6 BUTTON-Excel ~
COMBO-BOX-Seccion COMBO-BOX-Planilla TOGGLE-Seleccion br_table 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-Orden COMBO-BOX-Periodo ~
COMBO-BOX-Seccion FILL-IN-renta COMBO-BOX-Planilla TOGGLE-Seleccion ~
f-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "img/print.ico":U
     LABEL "CERTIFICADO DE PARTICIPACION DE UTILIDADES" 
     SIZE 9 BY 1.62.

DEFINE BUTTON BUTTON-Excel 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "" 
     SIZE 9 BY 1.62.

DEFINE VARIABLE COMBO-BOX-Planilla AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Filtrar por" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Activos","Cesados" 
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Seccion AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Filtrar por Sección" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Periodo AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Ejercicio Gravable" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-renta AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     LABEL "Renta Anual" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE RADIO-SET-Orden AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Codigo", 1,
"Nombre", 2,
"Seccion", 3
     SIZE 12 BY 2.15 NO-UNDO.

DEFINE VARIABLE TOGGLE-Seleccion AS LOGICAL INITIAL no 
     LABEL "Imprimir solo el registro seleccionado" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      w-report.Llave-I COLUMN-LABEL "Código" FORMAT "999999":U
      w-report.Campo-C[1] COLUMN-LABEL "Trabajador" FORMAT "X(35)":U
            WIDTH 31.86
      w-report.Campo-c[3] COLUMN-LABEL "Seccion" FORMAT "X(25)":U
            WIDTH 25
      w-report.Campo-F[2] COLUMN-LABEL "Dias!Laborados" FORMAT "->,>>>,>>9.99":U
            /*WIDTH 11.43*/
      w-report.Campo-F[1] COLUMN-LABEL "Remuneraciones!percibidas" FORMAT "->>,>>>,>>9.99":U
            WIDTH 12.43
      w-report.Campo-F[6] COLUMN-LABEL "Participacion!por dias laborados" FORMAT "->>,>>>,>>9.99":U
      w-report.Campo-F[7] COLUMN-LABEL "Participacion!por remuneraciones" FORMAT "->>,>>>,>>9.99":U
            WIDTH 14
      w-report.Campo-F[3] COLUMN-LABEL "Deducciones 5ta" FORMAT "->>,>>>,>>9.99":U
            WIDTH 12.43
      w-report.Campo-F[8] COLUMN-LABEL "Total a pagar" FORMAT "->>,>>>,>>9.99":U
            WIDTH 10.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 142 BY 13.19
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET-Orden AT ROW 1 COL 13 NO-LABEL WIDGET-ID 10
     COMBO-BOX-Periodo AT ROW 1 COL 95 COLON-ALIGNED WIDGET-ID 2
     BUTTON-6 AT ROW 1 COL 111 WIDGET-ID 22
     BUTTON-Excel AT ROW 1 COL 120 WIDGET-ID 30
     COMBO-BOX-Seccion AT ROW 1.27 COL 39 COLON-ALIGNED WIDGET-ID 26
     FILL-IN-renta AT ROW 1.81 COL 95 COLON-ALIGNED WIDGET-ID 20
     COMBO-BOX-Planilla AT ROW 2.35 COL 39 COLON-ALIGNED WIDGET-ID 34
     TOGGLE-Seleccion AT ROW 2.62 COL 111 WIDGET-ID 28
     br_table AT ROW 3.42 COL 1
     f-Mensaje AT ROW 16.62 COL 2 NO-LABEL WIDGET-ID 8
     "Ordenado por:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 1.27 COL 2 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 16.62
         WIDTH              = 149.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table TOGGLE-Seleccion F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN COMBO-BOX-Periodo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-renta IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
CASE RADIO-SET-Orden:
    WHEN 1 THEN OPEN QUERY {&SELF-NAME} FOR EACH w-report
        WHERE w-report.Task-No = s-task-no
        AND w-report.Llave-C = s-user-id
        AND ( COMBO-BOX-Seccion = "Todas" OR w-report.campo-c[3] = COMBO-BOX-Seccion )
        AND ( COMBO-BOX-Planilla = "Todos" OR
              ( COMBO-BOX-Planilla = "Activos" AND w-report.campo-d[1] = ? ) OR
              ( COMBO-BOX-Planilla = "Cesados" AND w-report.campo-d[1] <> ? ) )
        NO-LOCK
        BY w-report.llave-i
        INDEXED-REPOSITION.
    WHEN 2 THEN OPEN QUERY {&SELF-NAME} FOR EACH w-report
        WHERE w-report.Task-No = s-task-no
        AND w-report.Llave-C = s-user-id
        AND ( COMBO-BOX-Seccion = "Todas" OR w-report.campo-c[3] = COMBO-BOX-Seccion )
        AND ( COMBO-BOX-Planilla = "Todos" OR
              ( COMBO-BOX-Planilla = "Activos" AND w-report.campo-d[1] = ? ) OR
              ( COMBO-BOX-Planilla = "Cesados" AND w-report.campo-d[1] <> ? ) )
        NO-LOCK
        BY w-report.campo-c[1]
        INDEXED-REPOSITION.
    WHEN 3 THEN OPEN QUERY {&SELF-NAME} FOR EACH w-report
        WHERE w-report.Task-No = s-task-no
        AND w-report.Llave-C = s-user-id
        AND ( COMBO-BOX-Seccion = "Todas" OR w-report.campo-c[3] = COMBO-BOX-Seccion )
        AND ( COMBO-BOX-Planilla = "Todos" OR
              ( COMBO-BOX-Planilla = "Activos" AND w-report.campo-d[1] = ? ) OR
              ( COMBO-BOX-Planilla = "Cesados" AND w-report.campo-d[1] <> ? ) )
        NO-LOCK
        BY w-report.campo-c[3]
        INDEXED-REPOSITION.
END CASE.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 B-table-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* CERTIFICADO DE PARTICIPACION DE UTILIDADES */
DO:
    ASSIGN
        TOGGLE-Seleccion.
    /* cargamos nuevo temporal */
    DEF VAR x-task-no AS INT.

    DEF BUFFER b-report FOR w-report.

    REPEAT:
        x-task-no = RANDOM(1, 999999).
        FIND FIRST w-report WHERE w-report.task-no = x-task-no NO-LOCK NO-ERROR.
        IF NOT AVAILABLE w-report THEN LEAVE.
    END.
    IF TOGGLE-Seleccion = NO THEN DO:
        GET FIRST {&BROWSE-NAME}.
        REPEAT WHILE AVAILABLE w-report:
            CREATE b-report.
            BUFFER-COPY w-report TO b-report
                ASSIGN
                    b-report.task-no = x-task-no.
            ASSIGN
                total_dias = w-report.Campo-F[4]
                TOTAL_Ingresos = w-report.Campo-F[5].
            GET NEXT {&BROWSE-NAME}.
        END.
    END.
    ELSE DO:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(1) THEN DO:
            CREATE b-report.
            BUFFER-COPY w-report TO b-report
                ASSIGN
                    b-report.task-no = x-task-no.
            ASSIGN
                total_dias = w-report.Campo-F[4]
                TOTAL_Ingresos = w-report.Campo-F[5].
        END.
    END.
    /* *********************** */
    DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
    DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
    DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
    DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
    DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

    GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'pln/reporte.prl'
        RB-REPORT-NAME = 'Certificado de Utilidades'
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER = "w-report.task-no = " + STRING(x-task-no) +
                    " AND w-report.llave-c = '" + s-user-id + "'".
    ASSIGN
        RB-OTHER-PARAMETERS = 's-nomcia=' + s-nomcia + 
                                '~ns-ruccia=' + STRING (s-ruccia) +
                                '~ns-periodo=' + STRING (COMBO-BOX-Periodo, '9999') +
                                '~ntotal-dias=' + STRING(total_dias) +
                                '~ntotal-ingresos=' + STRING( TOTAL_ingresos) +
                                '~nrenta-anual=' + STRING (FILL-IN-renta).


    RUN lib/_imprime2 ( RB-REPORT-LIBRARY,
                        RB-REPORT-NAME,
                        RB-INCLUDE-RECORDS,
                        RB-FILTER,
                        RB-OTHER-PARAMETERS).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Excel B-table-Win
ON CHOOSE OF BUTTON-Excel IN FRAME F-Main
DO:
    ASSIGN COMBO-BOX-Periodo FILL-IN-renta.

    EMPTY TEMP-TABLE Calculados.
    DEF BUFFER b-report FOR w-report.

    FOR EACH b-report NO-LOCK WHERE b-report.Task-No = s-task-no
        AND b-report.Llave-C = s-user-id:
        CREATE Calculados.
        ASSIGN
            Calculados.codper = STRING(b-report.llave-i, '999999')
            Calculados.nomper = b-report.campo-c[1]
            Calculados.diaslab = b-report.campo-f[2]
            Calculados.remper  = b-report.campo-f[1]
            Calculados.diaslabt = b-report.campo-f[4]
            Calculados.rempert = b-report.campo-f[5]
            Calculados.pardias = b-report.campo-f[6]
            Calculados.parrem = b-report.campo-f[7]
            Calculados.deduc = b-report.campo-f[3]
            Calculados.TOTAL = b-report.campo-f[8].
    END.

    DEF VAR pOptions AS CHAR INIT ''.
    DEF VAR pArchivo AS CHAR INIT ''.

    ASSIGN
        pOptions = "FileType:XLS" + CHR(1) + ~
              "ExcelAlert:false" + CHR(1) + ~
              "ExcelVisible:no" + CHR(1) + ~
              "Labels:yes".
    RUN lib/tt-file (TEMP-TABLE Calculados:HANDLE, pArchivo, pOptions).
    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Planilla
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Planilla B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Planilla IN FRAME F-Main /* Filtrar por */
DO:
    IF SELF:SCREEN-VALUE = {&self-name} THEN RETURN.
    ASSIGN {&self-name}.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Seccion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Seccion B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Seccion IN FRAME F-Main /* Filtrar por Sección */
DO:
  IF SELF:SCREEN-VALUE = {&self-name} THEN RETURN.
  ASSIGN {&self-name}.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-Orden
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-Orden B-table-Win
ON VALUE-CHANGED OF RADIO-SET-Orden IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */



&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF s-task-no <> 0 THEN RETURN.
SESSION:SET-WAIT-STATE('GENERAL').
REPEAT:
    s-task-no = RANDOM(1, 999999).
    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN LEAVE.
END.
FOR EACH pl-mov-mes NO-LOCK WHERE codcia = s-codcia
    AND periodo = s-periodo
    AND nromes = s-nromes
    AND codpln = 01
    AND codcal = 20     /* Participación de utilidades */
    AND (codmov = 900 OR codmov = 901 OR codmov = 902
         OR codmov = 903 OR codmov = 904 OR codmov = 905
         OR codmov = 906 OR codmov = 907),
    FIRST INTEGRAL.pl-pers NO-LOCK WHERE INTEGRAL.pl-pers.codper = pl-mov-mes.codper
    BREAK BY pl-mov-mes.codper:
    IF FIRST-OF(pl-mov-mes.codper) THEN DO:
        f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "*** PROCESANDO " + pl-mov-mes.codper.
        FIND LAST pl-flg-mes USE-INDEX IDX02 WHERE pl-flg-mes.codcia = s-codcia
            AND pl-flg-mes.codper = pl-mov-mes.codper
            NO-LOCK NO-ERROR.
        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no
            w-report.llave-c = s-user-id
            w-report.llave-i = INTEGER(pl-mov-mes.codper)
            w-report.campo-c[1] = TRIM (INTEGRAL.pl-pers.patper) + ' ' + 
                                TRIM (INTEGRAL.pl-pers.matper) + ', ' + INTEGRAL.pl-pers.nomper
            w-report.campo-c[2] = PL-PERS.NroDocId
            w-report.campo-c[3] = (IF AVAILABLE(pl-flg-mes) THEN PL-FLG-MES.Seccion ELSE '')
            w-report.campo-d[1] = (IF AVAILABLE(pl-flg-mes) THEN PL-FLG-MES.vcontr  ELSE ?).
    END.
    CASE pl-mov-mes.codmov:
        WHEN 900 THEN FILL-IN-renta = pl-mov-mes.valcal.
        WHEN 901 THEN w-report.campo-f[4] = pl-mov-mes.valcal.
        WHEN 902 THEN w-report.campo-f[2] = pl-mov-mes.valcal.
        WHEN 903 THEN w-report.campo-f[5] = pl-mov-mes.valcal.
        WHEN 904 THEN w-report.campo-f[1] = pl-mov-mes.valcal.
        WHEN 905 THEN w-report.campo-f[6] = pl-mov-mes.valcal.
        WHEN 906 THEN w-report.campo-f[7] = pl-mov-mes.valcal.
        WHEN 907 THEN w-report.campo-f[3] = pl-mov-mes.valcal.
    END CASE.
    w-report.campo-f[8] = w-report.campo-f[6] + w-report.campo-f[7] - w-report.campo-f[3].
END.
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      w-report.campo-f[8] = w-report.campo-f[6] + w-report.campo-f[7] - w-report.campo-f[3].
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-Periodo = s-Periodo - 1.
      FOR EACH pl-secc:
          COMBO-BOX-Seccion:ADD-LAST(PL-SECC.seccion).
      END.
      RUN Carga-Temporal.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
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
        WHEN "" THEN.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
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
        WHEN "" THEN .
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "w-report"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

