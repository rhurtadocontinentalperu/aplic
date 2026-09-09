&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-CLIE LIKE gn-clie.
DEFINE TEMP-TABLE T-CLIE-RELACIONADOS NO-UNDO LIKE gn-clie.
DEFINE TEMP-TABLE T-CLIEL NO-UNDO LIKE w-report.



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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.

DEFINE NEW GLOBAL SHARED VARIABLE s-FlgEmpaque LIKE gn-divi.FlgEmpaque.
DEFINE NEW GLOBAL SHARED VAR s-FlgRotacion LIKE gn-divi.flgrotacion.
DEFINE NEW GLOBAL SHARED VAR s-FlgEmpaque  LIKE GN-DIVI.FlgEmpaque.
DEFINE NEW GLOBAL SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEFINE NEW GLOBAL SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEFINE NEW GLOBAL SHARED VAR s-FlgTipoVenta LIKE GN-DIVI.FlgPreVta.
DEFINE NEW GLOBAL SHARED VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEFINE NEW GLOBAL SHARED VAR s-TpoPed AS CHAR.

DEF VAR pArchivo AS CHAR NO-UNDO.
DEF VAR s-Task-No AS INTE NO-UNDO.

DEF TEMP-TABLE Detalle
    FIELD CodCli AS CHAR FORMAT 'x(11)' LABEL 'Cliente'
    FIELD NomCli AS CHAR FORMAT 'x(80)' LABEL 'Nombre'
    FIELD Venta  AS DECI FORMAT '->>>,>>>,>>>.99' LABEL 'Venta Campaña 2020'
    FIELD Deuda  AS DECI FORMAT '->>>,>>>,>>>.99' LABEL 'Deuda Campaña 2020'
    FIELD DeudaTotal AS DECI FORMAT '->>>,>>>,>>>.99' LABEL 'Deuda Total al dia anterior a evaluar L.C.'
    FIELD Avance AS DECI FORMAT '->>>,>>>,>>>.99' LABEL '% Avance de Cobranza Campaña 2020'
    FIELD Ajuste AS DECI FORMAT '->>>,>>>,>>>.99' LABEL '% Ajuste de Linea'    
    FIELD LinCre AS DECI FORMAT '>>>,>>>,>>>.99' LABEL 'LC 2020'
    FIELD NuevaLC AS DECI FORMAT '->>>,>>>,>>>.99' LABEL 'LC 2021'
    /*FIELD Disponible AS DECI FORMAT '->>>,>>>,>>>.99' LABEL 'Disponibilidad LC'*/
    FIELD Agrupador AS CHAR FORMAT 'x(12)' LABEL "Agrupador Clientes"    
    FIELD LC-MANUAL AS DECI FORMAT '->>>,>>>,>>>.99' LABEL 'LC 2021 MANUAL ASIGNADA'    
    FIELD faltante AS CHAR FORMAT 'x(12)' LABEL "Observaciones".

DEFINE TEMP-TABLE tGrupos
    FIELD   codmaster AS CHAR
    FIELD   impdeuda AS DEC
    INDEX idx01 codmaster.

DEFINE TEMP-TABLE tDocVTAS
    FIELD   codmaster AS CHAR
    FIELD   codcli AS CHAR
    FIELD   coddoc AS CHAR
    FIELD   nrodoc AS CHAR
    FIELD   imptot AS DEC
    FIELD   saldo AS DEC
    FIELD   fchdoc  AS DATE
    FIELD   filer1   AS CHAR    FORMAT 'x(50)'
    INDEX idx01 codcli coddoc nrodoc.

DEFINE TEMP-TABLE tDocSaldos
    FIELD   codmaster AS CHAR
    FIELD   codcli AS CHAR
    FIELD   coddoc AS CHAR
    FIELD   nrodoc AS CHAR
    FIELD   codmon AS INT
    FIELD   imptot AS DEC
    FIELD   saldo AS DEC
    FIELD   fchdoc  AS DATE
    FIELD   filer1   AS CHAR    FORMAT 'x(50)'
    INDEX idx01 codcli coddoc nrodoc.

DEFINE TEMP-TABLE tCBCDOC LIKE ccbcdocu.   

DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.

DEFINE BUFFER x-T-CLIEL FOR T-CLIEL.
DEFINE BUFFER x-T-CLIE FOR T-CLIE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-9

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-CLIEL gn-clie

/* Definitions for BROWSE BROWSE-9                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-9 T-CLIEL.Llave-C gn-clie.NomCli ~
T-CLIEL.Campo-F[3] T-CLIEL.Campo-F[1] T-CLIEL.Campo-F[2] T-CLIEL.Campo-F[4] ~
T-CLIEL.Campo-F[5] T-CLIEL.Campo-F[8] T-CLIEL.Campo-F[6] T-CLIEL.Campo-F[7] ~
T-CLIEL.Campo-F[9] T-CLIEL.Campo-C[2] T-CLIEL.Campo-C[3] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-9 
&Scoped-define QUERY-STRING-BROWSE-9 FOR EACH T-CLIEL NO-LOCK, ~
      FIRST gn-clie WHERE gn-clie.CodCli = T-CLIEL.Llave-C ~
      AND gn-clie.CodCia = cl-codcia OUTER-JOIN NO-LOCK ~
    BY T-CLIEL.Campo-C[2] ~
       BY T-CLIEL.Llave-C
&Scoped-define OPEN-QUERY-BROWSE-9 OPEN QUERY BROWSE-9 FOR EACH T-CLIEL NO-LOCK, ~
      FIRST gn-clie WHERE gn-clie.CodCli = T-CLIEL.Llave-C ~
      AND gn-clie.CodCia = cl-codcia OUTER-JOIN NO-LOCK ~
    BY T-CLIEL.Campo-C[2] ~
       BY T-CLIEL.Llave-C.
&Scoped-define TABLES-IN-QUERY-BROWSE-9 T-CLIEL gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-9 T-CLIEL
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-9 gn-clie


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-9}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 ~
FILL-IN-Fecha BUTTON-FILTRAR BUTTON-EXPORT BUTTON-1 BROWSE-9 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 ~
FILL-IN-Fecha FILL-IN-Archivo FILL-IN-Mensaje FILL-IN-1 FILL-IN-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/search.ico":U
     LABEL "Button 1" 
     SIZE 7 BY 1.62.

DEFINE BUTTON BUTTON-EXPORT 
     LABEL "A TEXTO" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-FILTRAR 
     LABEL "APLICAR FILTROS" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(120)":U INITIAL "  Y : Su nueva LC calculada es menor a su deuda total" 
      VIEW-AS TEXT 
     SIZE 50 BY .85
     FGCOLOR 12 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(120)":U INITIAL "  X : Cliente pertenece al grupo y no estaba en la lista" 
      VIEW-AS TEXT 
     SIZE 50 BY .58
     FGCOLOR 12 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-Archivo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Archivo de clientes" 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Ventas Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha AS DATE FORMAT "99/99/9999":U 
     LABEL "LC vigente hasta el" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     LABEL "Procesando" 
     VIEW-AS FILL-IN 
     SIZE 90 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-9 FOR 
      T-CLIEL, 
      gn-clie
    FIELDS(gn-clie.NomCli) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-9 W-Win _STRUCTURED
  QUERY BROWSE-9 NO-LOCK DISPLAY
      T-CLIEL.Llave-C COLUMN-LABEL "Cliente" FORMAT "x(15)":U
      gn-clie.NomCli FORMAT "x(60)":U WIDTH 41.14
      T-CLIEL.Campo-F[3] COLUMN-LABEL "LC 2020" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 10.43
      T-CLIEL.Campo-F[1] COLUMN-LABEL "Venta!Campaña" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 12
      T-CLIEL.Campo-F[2] COLUMN-LABEL "Deuda!Campaña" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 11.43
      T-CLIEL.Campo-F[4] COLUMN-LABEL "% Avance!de Cobranza" FORMAT "->>9.99":U
      T-CLIEL.Campo-F[5] COLUMN-LABEL "%!Ajuste de Línea" FORMAT "->>9.99":U
      T-CLIEL.Campo-F[8] COLUMN-LABEL "LC 2021" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 12.57 COLUMN-BGCOLOR 10 COLUMN-FONT 6 LABEL-FONT 6
      T-CLIEL.Campo-F[6] COLUMN-LABEL "Disponibilidad LC" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 12.29 COLUMN-BGCOLOR 14
      T-CLIEL.Campo-F[7] COLUMN-LABEL "Deuda Total" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 11.43
      T-CLIEL.Campo-F[9] COLUMN-LABEL "LC 2021!MANUAL" FORMAT "->>>,>>>,>>9.99":U
      T-CLIEL.Campo-C[2] COLUMN-LABEL "Agrupador" FORMAT "X(12)":U
            WIDTH 10.14
      T-CLIEL.Campo-C[3] COLUMN-LABEL "Obs" FORMAT "X(3)":U WIDTH 6
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 167 BY 21.38
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-FchDoc-1 AT ROW 1.15 COL 19 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-FchDoc-2 AT ROW 1.19 COL 39 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-Fecha AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 16
     BUTTON-FILTRAR AT ROW 2.23 COL 91 WIDGET-ID 10
     BUTTON-EXPORT AT ROW 2.23 COL 112 WIDGET-ID 14
     BUTTON-1 AT ROW 2.27 COL 81 WIDGET-ID 8
     FILL-IN-Archivo AT ROW 3 COL 19 COLON-ALIGNED WIDGET-ID 6
     BROWSE-9 AT ROW 4.04 COL 2 WIDGET-ID 200
     FILL-IN-Mensaje AT ROW 25.77 COL 9.72 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-1 AT ROW 25.54 COL 101 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     FILL-IN-2 AT ROW 26.38 COL 101 COLON-ALIGNED NO-LABEL WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 168.57 BY 26.35
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-CLIE T "?" ? INTEGRAL gn-clie
      TABLE: T-CLIE-RELACIONADOS T "?" NO-UNDO INTEGRAL gn-clie
      TABLE: T-CLIEL T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Proceso automatizacion LC"
         HEIGHT             = 26.35
         WIDTH              = 168.57
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 168.57
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 168.57
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
/* BROWSE-TAB BROWSE-9 FILL-IN-Archivo F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Archivo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-9
/* Query rebuild information for BROWSE BROWSE-9
     _TblList          = "Temp-Tables.T-CLIEL,INTEGRAL.gn-clie WHERE Temp-Tables.T-CLIEL ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST OUTER USED"
     _OrdList          = "Temp-Tables.T-CLIEL.Campo-C[2]|yes,Temp-Tables.T-CLIEL.Llave-C|yes"
     _JoinCode[2]      = "INTEGRAL.gn-clie.CodCli = Temp-Tables.T-CLIEL.Llave-C"
     _Where[2]         = "INTEGRAL.gn-clie.CodCia = cl-codcia"
     _FldNameList[1]   > Temp-Tables.T-CLIEL.Llave-C
"T-CLIEL.Llave-C" "Cliente" "x(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.gn-clie.NomCli
"gn-clie.NomCli" ? "x(60)" "character" ? ? ? ? ? ? no ? no no "41.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-CLIEL.Campo-F[3]
"T-CLIEL.Campo-F[3]" "LC 2020" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-CLIEL.Campo-F[1]
"T-CLIEL.Campo-F[1]" "Venta!Campaña" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-CLIEL.Campo-F[2]
"T-CLIEL.Campo-F[2]" "Deuda!Campaña" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-CLIEL.Campo-F[4]
"T-CLIEL.Campo-F[4]" "% Avance!de Cobranza" "->>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-CLIEL.Campo-F[5]
"T-CLIEL.Campo-F[5]" "%!Ajuste de Línea" "->>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-CLIEL.Campo-F[8]
"T-CLIEL.Campo-F[8]" "LC 2021" "->>>,>>>,>>9.99" "decimal" 10 ? 6 ? ? 6 no ? no no "12.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-CLIEL.Campo-F[6]
"T-CLIEL.Campo-F[6]" "Disponibilidad LC" "->>>,>>>,>>9.99" "decimal" 14 ? ? ? ? ? no ? no no "12.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-CLIEL.Campo-F[7]
"T-CLIEL.Campo-F[7]" "Deuda Total" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.T-CLIEL.Campo-F[9]
"T-CLIEL.Campo-F[9]" "LC 2021!MANUAL" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.T-CLIEL.Campo-C[2]
"T-CLIEL.Campo-C[2]" "Agrupador" "X(12)" "character" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.T-CLIEL.Campo-C[3]
"T-CLIEL.Campo-C[3]" "Obs" "X(3)" "character" ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-9 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Proceso automatizacion LC */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Proceso automatizacion LC */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  DEF VAR rpta AS LOG NO-UNDO.

  SYSTEM-DIALOG GET-FILE pArchivo
      FILTERS "*.xls *.xlsx" "*.xls,*.xlsx"
      MUST-EXIST
      TITLE "Seleccione el archivo que contiene la lista de clientes"
      UPDATE rpta.
  IF rpta = NO THEN RETURN.
  DISPLAY pArchivo @ FILL-IN-Archivo WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-EXPORT
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-EXPORT W-Win
ON CHOOSE OF BUTTON-EXPORT IN FRAME F-Main /* A TEXTO */
DO:
    DEF VAR pOptions AS CHAR NO-UNDO.
    DEF VAR pArchivo AS CHAR NO-UNDO.

    DEF VAR OKpressed AS LOG.

    SYSTEM-DIALOG GET-FILE pArchivo
          FILTERS "Archivo txt" "*.txt"
          ASK-OVERWRITE 
          CREATE-TEST-FILE
          DEFAULT-EXTENSION ".txt"
          SAVE-AS
          USE-FILENAME
          UPDATE OKpressed.
    IF OKpressed = FALSE THEN RETURN NO-APPLY.

    /* Capturamos Articulos */
    SESSION:SET-WAIT-STATE('GENERAL').

    EMPTY TEMP-TABLE Detalle.
    FOR EACH T-CLIEL NO-LOCK, FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = T-CLIEL.Llave-C:
        CREATE Detalle.
        ASSIGN
            Detalle.CodCli = gn-clie.codcli
            Detalle.NomCli = gn-clie.nomcli
            Detalle.LinCre = T-CLIEL.Campo-F[3]
            Detalle.Venta  = T-CLIEL.Campo-F[1] 
            Detalle.Deuda  = T-CLIEL.Campo-F[2]
            Detalle.Avance = T-CLIEL.Campo-F[4]
            Detalle.Ajuste = T-CLIEL.Campo-F[5]
            /*Detalle.Disponible = T-CLIEL.Campo-F[6]*/
            Detalle.DeudaTotal = T-CLIEL.Campo-F[7]
            Detalle.NuevaLC = T-CLIEL.Campo-F[8]
            Detalle.LC-Manual = T-CLIEL.Campo-F[9]
            Detalle.Agrupador  = T-CLIEL.Campo-C[2]
            Detalle.faltante  = T-CLIEL.Campo-C[3]
            .
    END.

    ASSIGN
        pOptions = "FileType:TXT" + CHR(1) + ~
                "Grid:ver" + CHR(1) + ~ 
                "ExcelAlert:false" + CHR(1) + ~
                "ExcelVisible:false" + CHR(1) + ~
                "Labels:yes".

    RUN lib/tt-filev2 (TEMP-TABLE Detalle:HANDLE, pArchivo, pOptions).
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-FILTRAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-FILTRAR W-Win
ON CHOOSE OF BUTTON-FILTRAR IN FRAME F-Main /* APLICAR FILTROS */
DO:
  ASSIGN FILL-IN-Archivo FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN-Fecha.

  IF TRUE <> (FILL-IN-Archivo > "") THEN DO:
      MESSAGE "Ingrese la ruta y archivo de Clientes" 
          VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.

  RUN MASTER-TRANSACTION.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-9
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE agrupar-ventas W-Win 
PROCEDURE agrupar-ventas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-sum-vtas AS DEC.
DEFINE VAR x-sum-deuda AS DEC.
                                   
FOR EACH T-CLIEL NO-LOCK WHERE T-CLIEL.campo-c[2] > "" BREAK BY T-CLIEL.campo-c[2] :
    IF FIRST-OF(T-CLIEL.campo-c[2]) THEN DO:
        x-sum-vtas = 0.
        x-sum-deuda = 0.
    END.
    x-sum-vtas = x-sum-vtas + T-CLIEL.campo-f[1].
    x-sum-deuda = x-sum-deuda + T-CLIEL.campo-f[2].
    IF LAST-OF(T-CLIEL.campo-c[2]) THEN DO:
        /* del Mismo grupo */
        FOR EACH x-T-CLIEL WHERE x-T-CLIEL.campo-c[2] = T-CLIEL.campo-c[2]:
            ASSIGN x-T-CLIEL.campo-f[1] = x-sum-vtas
                    x-T-CLIEL.campo-f[2] = x-sum-deuda.
        END.
    END.
END.

/**/
FOR EACH T-CLIEL WHERE T-CLIEL.campo-c[3] = "X" :
    /*DELETE T-CLIEL.*/
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Final W-Win 
PROCEDURE Carga-Final :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
FOR EACH T-CLIEL:
    /* % de avance cobranza */
    IF T-CLIEL.Campo-F[1] > 0 THEN T-CLIEL.Campo-F[4] = (T-CLIEL.Campo-F[1] - T-CLIEL.Campo-F[2]) / T-CLIEL.Campo-F[1] * 100.
    IF T-CLIEL.Campo-F[4] > 100 THEN T-CLIEL.Campo-F[4] = 100.
    /* Ajuste de línea */
    FIND FIRST FacTabla WHERE FacTabla.CodCia = s-CodCia
        AND FacTabla.Tabla = 'PLC2021'
        AND (T-CLIEL.Campo-F[4] >= FacTabla.Valor[1] AND T-CLIEL.Campo-F[4] < FacTabla.Valor[2])
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacTabla THEN DO:
        T-CLIEL.Campo-F[5] = FacTabla.Valor[3].
    END.
    T-CLIEL.Campo-F[6] = T-CLIEL.Campo-F[3] * T-CLIEL.Campo-F[5] / 100.
END.
*/

              
DEFINE VAR x-lc-tempo AS DEC.              
DEFINE VAR x-lc-disponible AS DEC.
              
FOR EACH T-CLIEL:

    ASSIGN T-CLIEL.Campo-F[4] = 0
            T-CLIEL.Campo-F[5] = 0
            T-CLIEL.Campo-F[6] = 0
            T-CLIEL.Campo-F[8] = 0.

    /* % de avance cobranza */
    IF T-CLIEL.Campo-F[1] > 0 /* AND T-CLIEL.Campo-F[2] >= 0*/ THEN DO:
        IF T-CLIEL.Campo-F[2] >= 0 THEN 
            T-CLIEL.Campo-F[4] = ( 1 -  (T-CLIEL.Campo-F[2] / T-CLIEL.Campo-F[1])) * 100.

        IF T-CLIEL.Campo-F[4] > 100 THEN T-CLIEL.Campo-F[4] = 100.
        IF T-CLIEL.Campo-F[2] <= 0 THEN T-CLIEL.Campo-F[4] = 100.

        /* Ajuste de línea */
        FIND FIRST FacTabla WHERE FacTabla.CodCia = s-CodCia
            AND FacTabla.Tabla = 'PLC2021'
            AND (T-CLIEL.Campo-F[4] >= FacTabla.Valor[1] AND T-CLIEL.Campo-F[4] < FacTabla.Valor[2])
            NO-LOCK NO-ERROR.
        IF AVAILABLE FacTabla THEN DO:
            T-CLIEL.Campo-F[5] = FacTabla.Valor[3].
        END.

        x-lc-tempo = T-CLIEL.Campo-F[3] * (T-CLIEL.Campo-F[5] / 100).
        x-lc-disponible = x-lc-tempo - T-CLIEL.Campo-F[7].

        ASSIGN T-CLIEL.Campo-F[8] = x-lc-tempo.

        IF T-CLIEL.Campo-F[7] < 0 THEN x-lc-disponible = x-lc-tempo.
        

        IF x-lc-disponible >= 0 THEN DO:
            ASSIGN T-CLIEL.Campo-F[6] = x-lc-disponible.
        END.
        ELSE DO:
            ASSIGN T-CLIEL.campo-c[3] = T-CLIEL.campo-c[3] + "Y".
        END.
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Linea-Credito W-Win 
PROCEDURE Carga-Linea-Credito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR f-MonLC AS INTE NO-UNDO.
DEF VAR f-ImpLC AS DECI NO-UNDO.
DEF VAR k AS INTE NO-UNDO.
DEF VAR pCodCli AS CHAR NO-UNDO.
DEF VAR pMaster AS CHAR.
DEF VAR pRelacionados AS CHAR.
DEF VAR pAgrupados AS LOG.

DEFINE VAR x-fecha AS DATE.

FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= TODAY NO-LOCK.

FOR EACH T-CLIEL, FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = T-CLIEL.Llave-C:

    pCodCli = T-CLIEL.Llave-C.
    k = k + 1.
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(k) + ' LC ' + 
        gn-clie.codcli + ' ' + gn-clie.nomcli.

    /* ************************************* */
    /* Verificamos si es un cliente agrupado */
    /* ¿es el Master? */
    /* ************************************* */
    RUN ccb/p-cliente-master (INPUT pCodCli,
                              OUTPUT pMaster,
                              OUTPUT pRelacionados,
                              OUTPUT pAgrupados).
    IF pAgrupados = YES AND pMaster > '' THEN pCodCli = pMaster.    /* Cambiamos al Master */

    /* Linea de Credito Actual Campaña */
    ASSIGN
        f-MonLC = 0
        f-ImpLC = 0.
    FOR EACH Gn-ClieL NO-LOCK WHERE Gn-ClieL.CodCia = cl-CodCia
        AND Gn-ClieL.CodCli = pCodCli
        AND Gn-ClieL.FchIni <> ? 
        AND Gn-ClieL.FchFin <> ? 
        AND Gn-ClieL.FchFin <= FILL-IN-Fecha
        BY gn-cliel.fchini BY gn-cliel.fchfin:

        /* Linea de Credito de la Campanña segun fecha */
        IF Gn-ClieL.FchFin = FILL-IN-Fecha THEN DO:
            ASSIGN
                f-MonLC = gn-cliel.monlc
                f-ImpLC = Gn-ClieL.ImpLC.     /* VALOR POR DEFECTO => LINEA DE CREDITO TOTAL */
        END.
    END.

    IF f-MonLC = 2 THEN f-ImpLC = f-ImpLC * gn-tcmb.Compra.
    ASSIGN
        T-CLIEL.Campo-F[3] = f-ImpLC.

    /* Linea de Credito siguiente campaña segun fecha */
    x-fecha = ADD-INTERVAL(FILL-IN-Fecha,1,'year').

    ASSIGN
        f-MonLC = 0
        f-ImpLC = 0.
    FOR EACH Gn-ClieL NO-LOCK WHERE Gn-ClieL.CodCia = cl-CodCia
        AND Gn-ClieL.CodCli = pCodCli
        AND Gn-ClieL.FchIni <> ? 
        AND Gn-ClieL.FchFin <> ? 
        AND Gn-ClieL.FchFin <= x-Fecha
        BY gn-cliel.fchini BY gn-cliel.fchfin:

        /* Linea de Credito de la Campanña */
        IF Gn-ClieL.FchFin = x-Fecha THEN DO:
            ASSIGN
                f-MonLC = gn-cliel.monlc
                f-ImpLC = Gn-ClieL.ImpLC.     /* VALOR POR DEFECTO => LINEA DE CREDITO TOTAL */
        END.
    END.

    IF f-MonLC = 2 THEN f-ImpLC = f-ImpLC * gn-tcmb.Compra.
    ASSIGN
        T-CLIEL.Campo-F[9] = f-ImpLC.

END.

END PROCEDURE.

/*
FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= TODAY NO-LOCK.
FOR EACH T-CLIEL, FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = T-CLIEL.Llave-C:
    k = k + 1.
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(k) + ' ' + 
        gn-clie.codcli + ' ' + gn-clie.nomcli.
    RUN ccb/p-implc (
        cl-codcia,
        T-CLIEL.Llave-C,
        "",                       /* División a filtrar la línea de crédito */
        OUTPUT f-MonLC,
        OUTPUT f-ImpLC
        ).
    IF f-MonLC = 2 THEN f-ImpLC = f-ImpLC * gn-tcmb.Compra.
    ASSIGN
        T-CLIEL.Campo-F[3] = f-ImpLC.
END.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-ventas W-Win 
PROCEDURE Carga-ventas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pMaster AS CHAR.
DEF INPUT PARAMETER pFueraDeLaLista AS CHAR.

DEF VAR x-Factor AS INTE NO-UNDO.
DEF VAR x-TpoCmb AS DECI NO-UNDO.
DEF VAR x-ImpTot AS DECI NO-UNDO.
DEF VAR x-Saldo  AS DECI NO-UNDO.

DEFINE VAR x-desde AS DATE.
DEFINE VAR x-hasta AS DATE.

x-desde = IF (FILL-IN-FchDoc-1 = ?) THEN 01/01/1900 ELSE FILL-IN-FchDoc-1.
x-hasta = IF (FILL-IN-FchDoc-2 = ?) THEN 12/31/2080 ELSE FILL-IN-FchDoc-2.

DEFINE VAR x-fais AS INT.

DEFINE VAR x-doc-vtas AS CHAR INIT "FAC,BOL,FAI,DCO,LET".
DEFINE VAR x-doc-vtas-resta AS CHAR INIT "N/C, NCI, N/D".
DEFINE VAR x-docs-ambos AS CHAR.

x-docs-ambos = x-doc-vtas + "," + x-doc-vtas-resta.

/* Comprobantes de Cargo y Abono */
FOR EACH FacDocum NO-LOCK WHERE FacDocum.CodCia = s-codcia AND
    CAN-DO(x-doc-vtas,facdocum.coddoc) /*AND FacDocum.codcta[9] = "SI"*/ :
    /*AND FacDocum.TpoDoc <> ?:       /* YES: Cargo   NO: Abono */*/
    IF FacDocum.TpoDoc = YES THEN x-Factor = 1.
    ELSE x-Factor = -1.

    FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:
        FOR EACH Ccbcdocu NO-LOCK WHERE (Ccbcdocu.codcia = s-codcia
            AND Ccbcdocu.coddiv = gn-divi.coddiv
            AND Ccbcdocu.codcli = pCodCli
            AND Ccbcdocu.coddoc = FacDocum.CodDoc 
            /*AND LOOKUP(Ccbcdocu.FlgEst, "P,C") > 0  /* Pendientes y Cancelados */*/
            AND CAN-DO("P,C",Ccbcdocu.FlgEst))
            AND (Ccbcdocu.fchdoc >= FILL-IN-FchDoc-1 AND Ccbcdocu.fchdoc <= FILL-IN-FchDoc-2):
            
            x-ImpTot = Ccbcdocu.ImpTot.
            x-Saldo = Ccbcdocu.SdoAct.
            FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
            IF Ccbcdocu.codmon = 2 AND AVAILABLE gn-tcmb 
                THEN 
                ASSIGN
                x-TpoCmb = gn-tcmb.venta
                x-ImpTot = x-ImpTot * x-TpoCmb
                x-Saldo = x-Saldo * x-TpoCmb.
            IF Ccbcdocu.FlgEst = "C" OR Ccbcdocu.SdoAct <= 0 THEN x-Saldo = 0.
            FIND FIRST T-CLIEL WHERE T-CLIEL.Llave-C = pCodCli NO-ERROR.
            IF NOT AVAILABLE T-CLIEL THEN CREATE T-CLIEL.
            ASSIGN
                T-CLIEL.Llave-C = pCodCli
                T-CLIEL.Campo-C[1] = gn-clie.nomcli
                T-CLIEL.Campo-C[2] = pMaster
                T-CLIEL.Campo-C[3] = pFueraDeLaLista
                .

            IF LOOKUP(Ccbcdocu.coddoc,"FAC,BOL,FAI") > 0 THEN DO:           /* DCO y LET no es VENTA */
                /* Si son POR ADELANTO o SERVICIOS no son de VENTA */
                IF Ccbcdocu.coddoc = "FAC" AND LOOKUP(ccbcdocu.tpofac,"A,S") > 0 THEN DO:
                   NEXT.                                                            
                END.
                /* Si la FAC tuvo como origen FAI no considerar x que de lo contrario de duplican las ventas */
                IF Ccbcdocu.coddoc = "FAC" AND ccbcdocu.codref = 'FAI' THEN NEXT.

                ASSIGN
                      T-CLIEL.Campo-F[1] = T-CLIEL.Campo-F[1] + (x-ImpTot * x-Factor).
            END.
            ASSIGN
                T-CLIEL.Campo-F[2] = T-CLIEL.Campo-F[2] + (x-Saldo * x-Factor).

            /*  */
            CREATE tDocVTAS.
                ASSIGN tDocVTAS.coddoc = ccbcdocu.coddoc
                        tDocVTAS.codcli = ccbcdocu.codcli
                        tDocVTAS.codmaster = pMaster
                        tdocVtas.nrodoc = ccbcdocu.nrodoc
                        tDocVTAS.imptot = (x-ImpTot * x-Factor)
                        tDocVTAS.saldo  = (x-Saldo * x-Factor)
                        tDocVTAS.fchdoc = ccbcdocu.fchdoc
                    .

            IF ccbcdocu.coddoc = 'FAI' THEN x-fais = x-fais + 1.
        END.
    END.
END.

/* Resto las N/C, NCI y N/D que sean de la campaña */
FOR EACH FacDocum NO-LOCK WHERE FacDocum.CodCia = s-codcia AND
    CAN-DO(x-doc-vtas-resta,facdocum.coddoc) /*AND FacDocum.codcta[9] = "SI" */:

    IF FacDocum.TpoDoc = YES THEN x-Factor = 1.
    ELSE x-Factor = -1.

    FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:
        FOR EACH Ccbcdocu NO-LOCK WHERE (Ccbcdocu.codcia = s-codcia
            AND Ccbcdocu.coddiv = gn-divi.coddiv
            AND Ccbcdocu.codcli = pCodCli
            AND Ccbcdocu.coddoc = facdocum.coddoc
            /*AND LOOKUP(Ccbcdocu.FlgEst, "P,C") > 0*/
            AND CAN-DO("P,C",Ccbcdocu.FlgEst))
            AND Ccbcdocu.fchdoc >= FILL-IN-FchDoc-1 :
    
            /* Si el documento referenciado de la N/C es de venta de campaña */
            FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                                        x-ccbcdocu.coddoc = ccbcdocu.codref AND
                                        x-ccbcdocu.nrodoc = ccbcdocu.nroref AND
                                        (x-ccbcdocu.fchdoc >= FILL-IN-FchDoc-1 AND x-ccbcdocu.fchdoc <= FILL-IN-FchDoc-2) 
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE x-ccbcdocu THEN DO:
                x-ImpTot = Ccbcdocu.ImpTot.
                x-Saldo = Ccbcdocu.SdoAct.
                FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
                IF Ccbcdocu.codmon = 2 AND AVAILABLE gn-tcmb THEN 
                    ASSIGN
                    x-TpoCmb = gn-tcmb.venta
                    x-ImpTot = x-ImpTot * x-TpoCmb
                    x-Saldo = x-Saldo * x-TpoCmb.
                IF Ccbcdocu.FlgEst = "C" OR Ccbcdocu.SdoAct <= 0 THEN x-Saldo = 0.

                FIND FIRST T-CLIEL WHERE T-CLIEL.Llave-C = pCodCli NO-ERROR.
                IF NOT AVAILABLE T-CLIEL THEN CREATE T-CLIEL.
                ASSIGN
                    T-CLIEL.Llave-C = pCodCli
                    T-CLIEL.Campo-C[1] = gn-clie.nomcli
                    T-CLIEL.Campo-C[2] = pMaster
                    T-CLIEL.Campo-C[3] = pFueraDeLaLista
                    .

                IF LOOKUP(Ccbcdocu.coddoc,"N/C") > 0 THEN DO:           /* N/D no es parte de la venta VENTA */
                    ASSIGN
                      T-CLIEL.Campo-F[1] = T-CLIEL.Campo-F[1] + (x-ImpTot * x-Factor).
                END.
                /**/
                ASSIGN
                    T-CLIEL.Campo-F[2] = T-CLIEL.Campo-F[2] + (x-Saldo * x-Factor).

                CREATE tDocVTAS.
                    ASSIGN tDocVTAS.coddoc = ccbcdocu.coddoc
                            tDocVTAS.codcli = ccbcdocu.codcli
                            tDocVTAS.codmaster = pMaster
                            tdocVtas.nrodoc = ccbcdocu.nrodoc
                            tDocVTAS.imptot = (x-ImpTot * x-Factor)
                            tDocVTAS.saldo  = (x-Saldo * x-Factor)
                            tDocVTAS.fchdoc = ccbcdocu.fchdoc.
            END.
        END.
    END.
END.

DEFINE VAR x-es-valido AS LOG.

/* Aca solo deberian caer LET (CANJES, RENOVACIONES, REFINANCIACIONES) */
FOR EACH FacDocum NO-LOCK WHERE FacDocum.CodCia = s-codcia AND
    facdocum.coddoc = 'LET' /*AND FacDocum.codcta[9] = "SI"*/ :
    IF FacDocum.TpoDoc = YES THEN x-Factor = 1.
    ELSE x-Factor = -1.
    FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:
        FOR EACH Ccbcdocu NO-LOCK WHERE (Ccbcdocu.codcia = s-codcia
            AND Ccbcdocu.coddiv = gn-divi.coddiv
            AND Ccbcdocu.codcli = pCodCli
            AND Ccbcdocu.coddoc = FacDocum.CodDoc 
            /* AND LOOKUP(Ccbcdocu.FlgEst, "P,C") > 0  /* Pendientes y Cancelados */*/
            AND CAN-DO("P,C",Ccbcdocu.FlgEst))
            AND Ccbcdocu.fchdoc > FILL-IN-FchDoc-2 :

            x-ImpTot = Ccbcdocu.ImpTot.
            x-Saldo = Ccbcdocu.SdoAct.
            FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
            IF Ccbcdocu.codmon = 2 AND AVAILABLE gn-tcmb 
                THEN 
                ASSIGN
                x-TpoCmb = gn-tcmb.venta
                x-ImpTot = x-ImpTot * x-TpoCmb
                x-Saldo = x-Saldo * x-TpoCmb.
            IF Ccbcdocu.FlgEst = "C" OR Ccbcdocu.SdoAct <= 0 THEN x-Saldo = 0.
            FIND FIRST T-CLIEL WHERE T-CLIEL.Llave-C = pCodCli NO-ERROR.
            IF NOT AVAILABLE T-CLIEL THEN CREATE T-CLIEL.
            ASSIGN
                T-CLIEL.Llave-C = pCodCli
                T-CLIEL.Campo-C[1] = gn-clie.nomcli
                T-CLIEL.Campo-C[2] = pMaster
                T-CLIEL.Campo-C[3] = pFueraDeLaLista
                .

            /**/
            ASSIGN
                T-CLIEL.Campo-F[2] = T-CLIEL.Campo-F[2] + (x-Saldo * x-Factor).

            CREATE tDocVTAS.
                ASSIGN tDocVTAS.coddoc = ccbcdocu.coddoc
                        tDocVTAS.codcli = ccbcdocu.codcli
                        tDocVTAS.codmaster = pMaster
                        tdocVtas.nrodoc = ccbcdocu.nrodoc
                        tDocVTAS.imptot = (x-ImpTot * x-Factor)
                        tDocVTAS.saldo  = (x-Saldo * x-Factor)
                        tDocVTAS.fchdoc = ccbcdocu.fchdoc
            .
        END.
    END.
END.

/* 
    FAC,BOL, N/C, N/D de NO campaña y fueron canjeadas no entran a la deuda de campaña 
    por que ya estan incluidad en las LETRAS    
*/

FOR EACH FacDocum NO-LOCK WHERE FacDocum.CodCia = s-codcia AND
    CAN-DO("FAC,BOL,N/C,N/D",facdocum.coddoc)
    AND FacDocum.codcta[9] = "SI" :

    /* Revierten */
    IF FacDocum.TpoDoc = YES THEN x-Factor = -1.
    ELSE x-Factor = 1.

    FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:
        FOR EACH Ccbcdocu NO-LOCK WHERE (Ccbcdocu.codcia = s-codcia
            AND Ccbcdocu.coddiv = gn-divi.coddiv
            AND Ccbcdocu.codcli = pCodCli
            AND Ccbcdocu.coddoc = FacDocum.CodDoc 
            /*AND LOOKUP(Ccbcdocu.FlgEst, "P,C") > 0)  /* Pendientes y Cancelados */*/
            AND CAN-DO("P,C",Ccbcdocu.FlgEst))  /* Pendientes y Cancelados */
            AND Ccbcdocu.fchdoc > FILL-IN-FchDoc-2 :

            FIND FIRST ccbdcaja WHERE ccbdcaja.codcia = s-codcia AND
                                        ccbdcaja.codref = ccbcdocu.coddoc AND
                                        ccbdcaja.nroref = ccbcdocu.nrodoc AND 
                                        ccbdcaja.coddoc = "CJE" NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ccbdcaja THEN DO:
                NEXT.
            END.

            /**/
            IF facdocum.coddoc = 'N/C' OR facdocum.coddoc = 'N/D' THEN DO:
                /* Si el documento referenciado de la N/C es de la venta de campaña */
                FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                                            x-ccbcdocu.coddoc = ccbcdocu.codref AND
                                            x-ccbcdocu.nrodoc = ccbcdocu.nroref AND
                                            (x-ccbcdocu.fchdoc >= FILL-IN-FchDoc-1 AND x-ccbcdocu.fchdoc <= FILL-IN-FchDoc-2) 
                                            NO-LOCK NO-ERROR.
                IF AVAILABLE x-ccbcdocu THEN DO:
                    /* Solo N/C y N/D cuya referencia sea un comprobante de NO CAMPAÑA*/
                    NEXT.
                END.
            END.

            x-ImpTot = Ccbcdocu.ImpTot.
            x-Saldo = Ccbcdocu.SdoAct.
            FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
            IF Ccbcdocu.codmon = 2 AND AVAILABLE gn-tcmb 
                THEN 
                ASSIGN
                x-TpoCmb = gn-tcmb.venta
                x-ImpTot = x-ImpTot * x-TpoCmb
                x-Saldo = x-Saldo * x-TpoCmb.
            IF Ccbcdocu.FlgEst = "C" OR Ccbcdocu.SdoAct <= 0 THEN x-Saldo = 0.
            FIND FIRST T-CLIEL WHERE T-CLIEL.Llave-C = pCodCli NO-ERROR.
            IF NOT AVAILABLE T-CLIEL THEN CREATE T-CLIEL.
            ASSIGN
                T-CLIEL.Llave-C = pCodCli
                T-CLIEL.Campo-C[1] = gn-clie.nomcli
                T-CLIEL.Campo-C[2] = pMaster
                T-CLIEL.Campo-C[3] = pFueraDeLaLista
                .

            /**/
            ASSIGN
                T-CLIEL.Campo-F[2] = T-CLIEL.Campo-F[2] + (x-Saldo * x-Factor).

            CREATE tDocVTAS.
                ASSIGN tDocVTAS.coddoc = ccbcdocu.coddoc
                        tDocVTAS.codcli = ccbcdocu.codcli
                        tDocVTAS.codmaster = pMaster
                        tdocVtas.nrodoc = ccbcdocu.nrodoc
                        tDocVTAS.imptot = (x-ImpTot * x-Factor)
                        tDocVTAS.saldo  = (x-Saldo * x-Factor)
                        tDocVTAS.fchdoc = ccbcdocu.fchdoc
                        tDocVTAS.filer1 = "DOCUMENTO NO CAMPAÑA"
            .
        END.
    END.
END.

/* Si el cliente pertenece a un grupo de clientes */
/*
DEF VAR pMaster AS CHAR.
DEF VAR pRelacionados AS CHAR.
*/

DEFINE VAR hProc AS HANDLE NO-UNDO.
DEFINE VAR x-deudaSoles AS DEC.
DEFINE VAR x-deudaDolares AS DEC.

DEF VAR pAgrupados AS LOG INIT YES.

DEFINE VAR x-existe-grupo AS LOG.

IF TRUE <> (pMaster > "") THEN pAgrupados = NO.

/*
RUN ccb/p-cliente-master (pCodCli,
                          OUTPUT pMaster,
                          OUTPUT pRelacionados,
                          OUTPUT pAgrupados).
*/

IF pAgrupados = YES THEN DO:
    FIND FIRST tGrupos WHERE tGrupos.codmaster = pMaster EXCLUSIVE-LOCK NO-ERROR.

    x-existe-grupo = YES.

    IF NOT AVAILABLE tGrupos THEN DO:

        x-existe-grupo = NO.

        CREATE tGrupos.
            ASSIGN tGrupos.codmaster = pMaster
                    tGrupos.impdeuda = 0.
    END.
    ELSE DO:
        x-deudaSoles = tGrupos.impdeuda.
    END.
END.

IF pAgrupados = NO OR x-existe-grupo = NO THEN DO:
    /* Deuda Total del Cliente */

    RUN vtagn\ventas-library.p PERSISTENT SET hProc.

    RUN VTA_deuda_del_cliente_tramos IN hProc (INPUT pCodCli, 
                                        INPUT ?,
                                        INPUT ?,
                                        INPUT YES,      /* Deuda del Grupo */
                                        INPUT NO,
                                        OUTPUT x-deudaSoles,
                                        OUTPUT x-deudaDolares,
                                        INPUT-OUTPUT TABLE tCBCDOC,
                                        INPUT YES).     

    DELETE PROCEDURE hProc.                 /* Release Libreria */

    IF pAgrupados = YES THEN ASSIGN tGrupos.impdeuda = x-deudaSoles.
END.

FIND FIRST T-CLIEL WHERE T-CLIEL.Llave-C = pCodCli NO-ERROR.
IF NOT AVAILABLE T-CLIEL THEN CREATE T-CLIEL.
ASSIGN
    T-CLIEL.Llave-C = pCodCli
    T-CLIEL.Campo-C[1] = gn-clie.nomcli.

/**/
ASSIGN
    T-CLIEL.Campo-F[7] = T-CLIEL.Campo-F[7] + x-deudaSoles.


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
  DISPLAY FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN-Fecha FILL-IN-Archivo 
          FILL-IN-Mensaje FILL-IN-1 FILL-IN-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN-Fecha BUTTON-FILTRAR 
         BUTTON-EXPORT BUTTON-1 BROWSE-9 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel W-Win 
PROCEDURE Importar-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* PRIMERO BORRAMOS TODO EL DETALLE */
EMPTY TEMP-TABLE T-CLIE.

/* SEGUNDO IMPORTAMOS DESDE EL EXCEL */
DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chWorkbook AS COM-HANDLE.
DEFINE VARIABLE chWorksheet AS COM-HANDLE.

DEFINE VARIABLE cRange      AS CHARACTER NO-UNDO.
DEFINE VARIABLE iCountLine  AS INTEGER NO-UNDO.
DEFINE VARIABLE iTotalColumn AS INTEGER NO-UNDO.
DEFINE VARIABLE cValue      AS CHARACTER NO-UNDO.
DEFINE VARIABLE iValue      AS INT64 NO-UNDO.
DEFINE VARIABLE dValue      AS DECIMAL NO-UNDO.

CREATE "Excel.Application" chExcelApplication.

chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

s-Task-No = 0.
iCountLine = 1.     /* Saltamos el encabezado de los campos */
REPEAT:
    iCountLine = iCountLine + 1.
    cRange = "A" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):TEXT.
    
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */
    ASSIGN
        dValue = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Valor del código del cliente errado:' cValue VIEW-AS ALERT-BOX ERROR.
        NEXT.
    END.
    cValue = STRING(dValue, '99999999999').
    
    FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = cValue NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Cliente NO registrado:' cValue VIEW-AS ALERT-BOX ERROR.
        NEXT.
    END.

    /* CODIGO */
    cRange = "A" + TRIM(STRING(iCountLine)).
    CREATE T-CLIE.
    ASSIGN
        T-CLIE.codcia = cl-codcia
        T-CLIE.codcli = cValue
        T-CLIE.contac = ""                  /* Master caso sea grupal */
        T-CLIE.faxcli = ""                  /* No esta en la lista pero se necesita el calculo */
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, NEXT.
END.
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

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
  FILL-IN-Fecha = DATE(03,31, YEAR(TODAY)).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MASTER-TRANSACTION W-Win 
PROCEDURE MASTER-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE("GENERAL").

DEFINE VAR x-desde AS DATETIME.
DEFINE VAR x-hasta AS DATETIME.

DEFINE VAR x-excel AS LOG INIT NO.

EMPTY TEMP-TABLE tDocVTAS.
EMPTY TEMP-TABLE tCBCDOC.
EMPTY TEMP-TABLE tGrupos.


x-desde = NOW.

/* 1ro. Seleccionamos los clientes */
EMPTY TEMP-TABLE T-CLIE.
IF FILL-IN-Archivo > '' THEN DO:
    /* Cargamos del archivo T-CLIE excel */
    RUN Importar-Excel.

    x-excel = YES.
END.

/* Si el cliente pertenece a un grupo de clientes */
DEF VAR pMaster AS CHAR.
DEF VAR pRelacionados AS CHAR.
DEF VAR pAgrupados AS LOG.

DEFINE VAR x-conteo AS INT.
DEFINE VAR x-codcli AS CHAR.

/* Buscar los relacionados para clientes GRUPALES */
EMPTY TEMP-TABLE T-CLIE-RELACIONADOS.
FOR EACH T-CLIE NO-LOCK:

    pMaster = "".
    pRelacionados = "".
    pAgrupados = NO.

    RUN ccb/p-cliente-master (T-CLIE.codcli,
                              OUTPUT pMaster,
                              OUTPUT pRelacionados,
                              OUTPUT pAgrupados).

    IF pAgrupados = YES THEN DO:

        REPEAT x-conteo = 1 TO NUM-ENTRIES(pRelacionados,","):
            x-codcli = ENTRY(x-conteo,  pRelacionados,",").

            /* Que no este en la lista proporcionada */
            FIND FIRST x-T-CLIE WHERE x-T-CLIE.codcia = cl-codcia AND
                                        x-T-CLIE.codcli = x-codcli EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE x-T-CLIE THEN DO:
                /*  */
                FIND FIRST T-CLIE-RELACIONADOS WHERE T-CLIE-RELACIONADOS.codcia = cl-codcia AND
                                            T-CLIE-RELACIONADOS.codcli = x-codcli EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE T-CLIE-RELACIONADOS THEN DO:
                    CREATE T-CLIE-RELACIONADOS.
                    ASSIGN
                        T-CLIE-RELACIONADOS.codcia = cl-codcia
                        T-CLIE-RELACIONADOS.codcli = x-codcli
                        T-CLIE-RELACIONADOS.contac = pMaster                  /* Master caso sea grupal */
                        T-CLIE-RELACIONADOS.faxcli = "X"                  /* No esta en la lista pero se necesita el calculo */
                        .
                END.
            END.
            ELSE DO:
                ASSIGN T-CLIE.contac = pMaster.
            END.
        END.
    END.
END.

/* Unimos */
FOR EACH T-CLIE-RELACIONADOS NO-LOCK:
    CREATE T-CLIE.
    ASSIGN
        T-CLIE.codcia = T-CLIE-RELACIONADOS.codcia
        T-CLIE.codcli = T-CLIE-RELACIONADOS.codcli
        T-CLIE.contac = T-CLIE-RELACIONADOS.contac                  /* Master caso sea grupal */
        T-CLIE.faxcli = T-CLIE-RELACIONADOS.faxcli                  /* No esta en la lista pero se necesita el calculo */
        .
END.

/* 2do. Cargamos cuenta corriente por cliente */
DEF VAR k AS INT NO-UNDO.
EMPTY TEMP-TABLE T-CLIEL.
IF x-excel = YES /*CAN-FIND(FIRST T-CLIE NO-LOCK)*/ THEN DO:
    FOR EACH T-CLIE, FIRST gn-clie WHERE gn-clie.codcia = cl-codcia 
        AND gn-clie.codcli = T-CLIE.codcli:
        k = k + 1.
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(k) + ' ' + 
            gn-clie.codcli + ' ' + gn-clie.nomcli.
        RUN Carga-ventas (INPUT gn-clie.CodCli, INPUT T-CLIE.contac, INPUT T-CLIE.faxcli).
    END.
END.
ELSE DO:
    FOR EACH gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.flgsit = "A"
        AND LOOKUP(gn-clie.coddiv, '00024,00519,00030') = 0:
        k = k + 1.
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(k) + ' ' + 
            gn-clie.codcli + ' ' + gn-clie.nomcli.
        RUN ventas (INPUT gn-clie.CodCli, INPUT T-CLIE.contac, INPUT T-CLIE.faxcli).
    END.
END.

/* Agrupamos las ventas para clientes agrupados */
RUN agrupar-ventas.

/* 3ro Cargamos línea de crédito activa */
RUN Carga-Linea-Credito.

/* 4to Calculos finales */
RUN Carga-Final.

/*
/* Los documentos de la deuda total */
FOR EACH tCBCDOC NO-LOCK:

    CREATE tDocSaldos.
        ASSIGN tDocSaldos.codmaster = tCBCDOC.codant
                tDocSaldos.codcli = tCBCDOC.codcli
                tDocSaldos.coddoc = tCBCDOC.coddoc
                tDocSaldos.nrodoc = tCBCDOC.nrodoc
                tDocSaldos.codmon = tCBCDOC.codmon
                tDocSaldos.imptot = tCBCDOC.imptot
                tDocSaldos.saldo = tCBCDOC.sdoact
                tDocSaldos.fchdoc = tCBCDOC.fchdoc
    .
END.


DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = 'd:\xpciman\tDocVtas.xlsx'.

run pi-crea-archivo-csv IN hProc (input  buffer tDocVtas:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tDocVtas:handle,
                        input  c-csv-file,
                        output c-xls-file) .


c-xls-file = 'd:\xpciman\tDocSaldos.xlsx'.

run pi-crea-archivo-csv IN hProc (input  buffer tDocSaldos:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tDocSaldos:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.
*/

x-hasta = NOW.

SESSION:SET-WAIT-STATE("").

{&open-query-browse-9}

MESSAGE x-desde SKIP
        x-hasta.

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
  {src/adm/template/snd-list.i "T-CLIEL"}
  {src/adm/template/snd-list.i "gn-clie"}

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

