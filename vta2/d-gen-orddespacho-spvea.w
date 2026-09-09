&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-FacCPedi NO-UNDO LIKE FacCPedi.
DEFINE TEMP-TABLE w-report-tmp NO-UNDO LIKE w-report.



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
/*
DEF OUTPUT PARAMETER pCodAlm AS CHAR.
DEF OUTPUT PARAMETER pNroCot AS CHAR.
*/
  
/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-CodCia AS INT.
DEF SHARED VAR s-CodDiv AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.

DEFINE NEW SHARED VARIABLE s-coddoc   AS CHAR INITIAL "O/D".
DEFINE NEW SHARED VARIABLE s-NroSer AS INTEGER.
DEFINE NEW SHARED VARIABLE s-flgest   AS CHAR INITIAL "W".

DEF NEW SHARED VAR s-FlgEmpaque LIKE GN-DIVI.FlgEmpaque.
DEF NEW SHARED VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEF NEW SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEFINE NEW SHARED VARIABLE s-PorIgv LIKE Ccbcdocu.PorIgv.
DEFINE NEW SHARED VARIABLE s-FlgIgv LIKE Faccpedi.FlgIgv.
DEFINE NEW SHARED VARIABLE s-FmaPgo AS CHAR.
DEFINE NEW SHARED VARIABLE S-CODMON   AS INTEGER INITIAL 1.
DEFINE NEW SHARED VARIABLE s-TpoPed AS CHAR.
DEFINE NEW SHARED VARIABLE s-TpoPed2 AS CHAR.
DEFINE NEW SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE NEW SHARED VARIABLE s-NroDec AS INT INIT 4.

DEFINE BUFFER B-CPEDI FOR faccpedi.         /* La cotizacion */
/*DEFINE BUFFER COTIZACION FOR faccpedi.      /* La cotizacion a bloquear */*/
DEFINE TEMP-TABLE B-DPEDI LIKE facdpedi.       /* El detalle de las cotizaciones */
DEFINE BUFFER x-faccpedi FOR faccpedi.      /* Para jalar las cotizaciones segun parametros */

FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV 
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
   MESSAGE "Codigo de Documento no configurado" VIEW-AS ALERT-BOX WARNING.
   RETURN ERROR.
END.

define var pCodAlm as char.
define var pNroCot as char.

ASSIGN
    pCodAlm = ""
    pNroCot = "".

DEF NEW SHARED VAR s-CodAlm AS CHAR. /* NOTA: Puede contener mas de un almacen */

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    MESSAGE 'División' s-coddiv 'NO configurada' VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.

ASSIGN
    s-DiasVtoPed = GN-DIVI.DiasVtoPed
    s-FlgEmpaque = GN-DIVI.FlgEmpaque
    s-VentaMayorista = GN-DIVI.VentaMayorista.

FIND FIRST VtaAlmDiv WHERE Vtaalmdiv.codcia = s-codcia
    AND Vtaalmdiv.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaAlmDiv THEN DO:
    MESSAGE 'NO se han definido los almacenes de ventas para la división' s-coddiv VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.

&SCOPED-DEFINE Condicion ( x-FacCPedi.CodCia = s-codcia ~
AND x-FacCPedi.CodDoc = 'PED' ~
AND x-FacCPedi.CodDiv = s-coddiv ~
AND x-FacCPedi.FlgEst = s-flgest ~
AND (x-FacCPedi.CodCli = FILL-IN-CodCli) ~
AND (x-Faccpedi.ordcmp = txtOrdenCompra) ~
)

/* CONTROL ALMACEN DE DESPACHO SI ES O NO UN CENTRO DE DISTRIBUCION */
DEF VAR s-CentroDistribucion AS LOG INIT NO NO-UNDO.
/* SI: La Fecha de Entrega es "sugerida" por el sistema y NO se puede modificar
   NO: La Fecha de Entrega se puede modificar
*/


/*
&SCOPED-DEFINE Condicion ( FacCPedi.CodCia = s-codcia ~
AND FacCPedi.CodDoc = s-coddoc ~
AND FacCPedi.CodDiv = s-coddiv ~
AND FacCPedi.FlgEst = s-flgest ~
AND (FILL-IN-CodCli = '' OR FacCPedi.CodCli = FILL-IN-CodCli) ~
AND (FILL-IN-NomCli = '' OR INDEX(FacCPedi.NomCli, FILL-IN-NomCli) > 0) ~
AND (txtOrdenCompra = '' OR Faccpedi.ordcmp BEGINS txtOrdenCompra) ~
)
*/

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
&Scoped-define INTERNAL-TABLES tt-FacCPedi w-report-tmp

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 tt-FacCPedi.CodDoc ~
tt-FacCPedi.NroPed tt-FacCPedi.FchPed tt-FacCPedi.fchven tt-FacCPedi.FchEnt ~
tt-FacCPedi.CodCli tt-FacCPedi.NomCli tt-FacCPedi.ImpTot tt-FacCPedi.FmaPgo ~
tt-FacCPedi.Ubigeo[1] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH tt-FacCPedi NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH tt-FacCPedi NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 tt-FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 tt-FacCPedi


/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 w-report-tmp.Campo-C[1] ~
w-report-tmp.Campo-C[2] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7 
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH w-report-tmp NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY BROWSE-7 FOR EACH w-report-tmp NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 w-report-tmp
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 w-report-tmp


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-4}~
    ~{&OPEN-QUERY-BROWSE-7}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-7 BUTTON-12 FILL-IN-CodCli ~
txtOrdenCompra BUTTON-11 BROWSE-4 Btn_Cancel RECT-56 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodCli txtOrdenCompra 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Cancel" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-11 
     LABEL "Aplicar Filtro" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-12 
     LABEL "Generar O/D" 
     SIZE 15 BY 1.54.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Filtrar por Código del cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txtOrdenCompra AS CHARACTER FORMAT "X(15)":U 
     LABEL "Filtrar por O/C Sup.Mercados Peruanos" 
     VIEW-AS FILL-IN 
     SIZE 13.86 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-56
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 123 BY 2.42
     BGCOLOR 8 FGCOLOR 0 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      tt-FacCPedi SCROLLING.

DEFINE QUERY BROWSE-7 FOR 
      w-report-tmp SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 D-Dialog _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      tt-FacCPedi.CodDoc COLUMN-LABEL "T.Doc" FORMAT "x(3)":U
      tt-FacCPedi.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U
            WIDTH 9.57
      tt-FacCPedi.FchPed COLUMN-LABEL "Fch.Emision" FORMAT "99/99/9999":U
      tt-FacCPedi.fchven COLUMN-LABEL "Vcto" FORMAT "99/99/99":U
            WIDTH 8
      tt-FacCPedi.FchEnt COLUMN-LABEL "Entrega" FORMAT "99/99/9999":U
            WIDTH 9.43
      tt-FacCPedi.CodCli FORMAT "x(11)":U
      tt-FacCPedi.NomCli FORMAT "x(50)":U WIDTH 30.14
      tt-FacCPedi.ImpTot COLUMN-LABEL "Imp.Total" FORMAT "->>,>>>,>>9.99":U
      tt-FacCPedi.FmaPgo COLUMN-LABEL "Cnd.Vta" FORMAT "X(8)":U
      tt-FacCPedi.Ubigeo[1] COLUMN-LABEL "Tienda" FORMAT "x(50)":U
            WIDTH 34.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-COLUMN-SCROLLING SEPARATORS SIZE 123 BY 16.23
         FONT 4.

DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 D-Dialog _STRUCTURED
  QUERY BROWSE-7 NO-LOCK DISPLAY
      w-report-tmp.Campo-C[1] COLUMN-LABEL "Cotizacion" FORMAT "X(15)":U
      w-report-tmp.Campo-C[2] COLUMN-LABEL "Error" FORMAT "X(150)":U
            WIDTH 73.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 88.29 BY 3.85
         FONT 4 ROW-HEIGHT-CHARS .65.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-7 AT ROW 21.77 COL 2 WIDGET-ID 300
     BUTTON-12 AT ROW 23.35 COL 95 WIDGET-ID 32
     FILL-IN-CodCli AT ROW 3.27 COL 26 COLON-ALIGNED WIDGET-ID 20
     txtOrdenCompra AT ROW 3.19 COL 66.14 COLON-ALIGNED WIDGET-ID 24
     BUTTON-11 AT ROW 3.19 COL 83 WIDGET-ID 28
     BROWSE-4 AT ROW 5.35 COL 2 WIDGET-ID 200
     Btn_Cancel AT ROW 23.31 COL 110
     " GENERACION DE O/D PLAZA VEA" VIEW-AS TEXT
          SIZE 91 BY 1.73 AT ROW 1.04 COL 16 WIDGET-ID 34
          BGCOLOR 15 FGCOLOR 9 FONT 8
     RECT-56 AT ROW 2.92 COL 2 WIDGET-ID 26
     SPACE(1.56) SKIP(20.65)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "GENERACION DE O/D PLAZA VEA"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-FacCPedi T "?" NO-UNDO INTEGRAL FacCPedi
      TABLE: w-report-tmp T "?" NO-UNDO INTEGRAL w-report
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
/* BROWSE-TAB BROWSE-7 1 D-Dialog */
/* BROWSE-TAB BROWSE-4 BUTTON-11 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.tt-FacCPedi"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-FacCPedi.CodDoc
"tt-FacCPedi.CodDoc" "T.Doc" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-FacCPedi.NroPed
"tt-FacCPedi.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-FacCPedi.FchPed
"tt-FacCPedi.FchPed" "Fch.Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-FacCPedi.fchven
"tt-FacCPedi.fchven" "Vcto" ? "date" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-FacCPedi.FchEnt
"tt-FacCPedi.FchEnt" "Entrega" ? "date" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = Temp-Tables.tt-FacCPedi.CodCli
     _FldNameList[7]   > Temp-Tables.tt-FacCPedi.NomCli
"tt-FacCPedi.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "30.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-FacCPedi.ImpTot
"tt-FacCPedi.ImpTot" "Imp.Total" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-FacCPedi.FmaPgo
"tt-FacCPedi.FmaPgo" "Cnd.Vta" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-FacCPedi.Ubigeo[1]
"tt-FacCPedi.Ubigeo[1]" "Tienda" "x(50)" "character" ? ? ? ? ? ? no ? no no "34.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _TblList          = "Temp-Tables.w-report-tmp"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.w-report-tmp.Campo-C[1]
"w-report-tmp.Campo-C[1]" "Cotizacion" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.w-report-tmp.Campo-C[2]
"w-report-tmp.Campo-C[2]" "Error" "X(150)" "character" ? ? ? ? ? ? no ? no no "73.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* GENERACION DE O/D PLAZA VEA */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
&Scoped-define SELF-NAME BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 D-Dialog
ON VALUE-CHANGED OF BROWSE-4 IN FRAME D-Dialog
DO:
    /*
    DEF VAR j AS INT.
    DEF VAR x-codalm AS CHAR NO-UNDO.

    /* los almacenes de despacho salen de la cotizacion */
    IF NOT AVAILABLE Faccpedi THEN RETURN.

    /* Almacenes por Defecto de acuerdo a la División */
    ASSIGN
        COMBO-BOX_CodAlm:SENSITIVE = NO
        COMBO-BOX_CodAlm_010:SENSITIVE = NO
        COMBO-BOX_CodAlm_011:SENSITIVE = NO
        COMBO-BOX_CodAlm_017:SENSITIVE = NO
        COMBO-BOX_CodAlm_Otras:SENSITIVE = NO.
    x-CodAlm = ''.
    IF FacCPedi.TpoPed = "R"  THEN x-CodAlm = Faccpedi.CodAlm.  /* SOLO REMATES */
    ELSE DO:
        /* Lista de almacenes válidos de despacho, en orden de prioridad */
        FOR EACH VtaAlmDiv NO-LOCK WHERE Vtaalmdiv.codcia = s-codcia
            AND Vtaalmdiv.coddiv = s-CodDiv,
            FIRST Almacen OF Vtaalmdiv NO-LOCK WHERE Almacen.Campo-C[3] <> 'Si'     /* NO Remates */
            BY VtaAlmDiv.Orden:
            IF TRUE <> (x-CodAlm > "") THEN x-CodAlm = TRIM(VtaAlmDiv.CodAlm).
            ELSE x-CodAlm = x-CodAlm + "," + TRIM(VtaAlmDiv.CodAlm).
        END.
    END.
    /* Hay dos casos:
        Cotizaciones Ferias 
        Las otras cotizaciones
        */
    FIND GN-DIVI WHERE GN-DIVI.CodCia = FacCpedi.CodCia AND GN-DIVI.CodDiv = FacCPedi.Libre_c01 NO-LOCK.    /* Lista de Precios */
    
    DO  WITH FRAME {&FRAME-NAME}:
    CASE TRUE:
        WHEN GN-DIVI.CanalVenta = "FER" AND NUM-ENTRIES(FacCPedi.LugEnt2) = 4 THEN DO:
            /* ************************************************************************************** */
            /* Cotizaciones de FER */
            /* ************************************************************************************** */
            /* La sintaxis del campo es la siguiente:
                aa,bb,cc,dd
                aa: Almacén despacho línea 010
                bb: Almacén despacho línea 011
                cc: Almacén despacho línea 017
                dd: Almacén despacho otras líneas
                */
            /* ************************************************************************************** */
            /* Grupo A */
            DEF VAR cAlm010 AS CHAR NO-UNDO.
            cAlm010 = ENTRY(1,FacCPedi.LugEnt2).
            IF TRUE <> (cAlm010 > '') THEN cAlm010 = x-CodAlm.
            COMBO-BOX_CodAlm_010:DELETE(COMBO-BOX_CodAlm_010:LIST-ITEMS).
            
            DO j = 1 TO NUM-ENTRIES(cAlm010):
                FIND almacen WHERE almacen.codcia = s-codcia AND almacen.codalm = ENTRY(j, cAlm010)
                    NO-LOCK NO-ERROR.
                IF AVAILABLE almacen THEN COMBO-BOX_CodAlm_010:ADD-LAST(almacen.codalm + ' - ' + Almacen.Descripcion).
                IF j = 1 THEN COMBO-BOX_CodAlm_010 = almacen.codalm + ' - ' + Almacen.Descripcion.
            END.
            DISPLAY COMBO-BOX_CodAlm_010.
            /* Grupo B */
            DEF VAR cAlm011 AS CHAR NO-UNDO.
            cAlm011 = ENTRY(2,FacCPedi.LugEnt2).
            IF TRUE <> (cAlm011 > '') THEN cAlm011 = x-CodAlm.
            COMBO-BOX_CodAlm_011:DELETE(COMBO-BOX_CodAlm_011:LIST-ITEMS).
            DO j = 1 TO NUM-ENTRIES(cAlm011):
                FIND almacen WHERE almacen.codcia = s-codcia AND almacen.codalm = ENTRY(j, cAlm011)
                    NO-LOCK NO-ERROR.
                IF AVAILABLE almacen THEN COMBO-BOX_CodAlm_011:ADD-LAST(almacen.codalm + ' - ' + Almacen.Descripcion).
                IF j = 1 THEN COMBO-BOX_CodAlm_011 = almacen.codalm + ' - ' + Almacen.Descripcion.
            END.
            DISPLAY COMBO-BOX_CodAlm_011.
            /* Grupo C */
            DEF VAR cAlm017 AS CHAR NO-UNDO.
            cAlm017 = ENTRY(3,FacCPedi.LugEnt2).
            IF TRUE <> (cAlm017 > '') THEN cAlm017 = x-CodAlm.
            COMBO-BOX_CodAlm_017:DELETE(COMBO-BOX_CodAlm_017:LIST-ITEMS).
            DO j = 1 TO NUM-ENTRIES(cAlm017):
                FIND almacen WHERE almacen.codcia = s-codcia AND almacen.codalm = ENTRY(j, cAlm017)
                    NO-LOCK NO-ERROR.
                IF AVAILABLE almacen THEN COMBO-BOX_CodAlm_017:ADD-LAST(almacen.codalm + ' - ' + Almacen.Descripcion).
                IF j = 1 THEN COMBO-BOX_CodAlm_017 = almacen.codalm + ' - ' + Almacen.Descripcion.
            END.
            DISPLAY COMBO-BOX_CodAlm_017.
            /* Otras Lineas */
            DEF VAR cAlmOtras AS CHAR NO-UNDO.
            cAlmOtras = ENTRY(4,FacCPedi.LugEnt2).
            IF TRUE <> (cAlmOtras > '') THEN cAlmOtras = x-CodAlm.
            COMBO-BOX_CodAlm_Otras:DELETE(COMBO-BOX_CodAlm_Otras:LIST-ITEMS).
            DO j = 1 TO NUM-ENTRIES(cAlmOtras):
                FIND almacen WHERE almacen.codcia = s-codcia AND almacen.codalm = ENTRY(j, cAlmOtras)
                    NO-LOCK NO-ERROR.
                IF AVAILABLE almacen THEN COMBO-BOX_CodAlm_Otras:ADD-LAST(almacen.codalm + ' - ' + Almacen.Descripcion).
                IF j = 1 THEN COMBO-BOX_CodAlm_Otras = almacen.codalm + ' - ' + Almacen.Descripcion.
            END.
            DISPLAY COMBO-BOX_CodAlm_Otras.
            /* Revision Final */
            DEF VAR lHay010 AS LOG INIT YES NO-UNDO.
            DEF VAR lHay011 AS LOG INIT YES NO-UNDO.
            DEF VAR lHay017 AS LOG INIT YES NO-UNDO.
            DEF VAR lHayOtras AS LOG INIT YES NO-UNDO.
            
/*             DEF VAR lHay010 AS LOG INIT NO NO-UNDO.                                                              */
/*             DEF VAR lHay011 AS LOG INIT NO NO-UNDO.                                                              */
/*             DEF VAR lHay017 AS LOG INIT NO NO-UNDO.                                                              */
/*             DEF VAR lHayOtras AS LOG INIT NO NO-UNDO.                                                            */
/*             IF CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0                 */
/*                         AND CAN-FIND(FIRST Almmmatg OF Facdpedi WHERE Almmmatg.CodFam = '010' NO-LOCK)           */
/*                         NO-LOCK) THEN DO:                                                                        */
/*                 lHay010 = YES.                                                                                   */
/*             END.                                                                                                 */
/*             IF CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0                 */
/*                         AND CAN-FIND(FIRST Almmmatg OF Facdpedi WHERE Almmmatg.CodFam = '011' NO-LOCK)           */
/*                         NO-LOCK) THEN DO:                                                                        */
/*                 lHay011 = YES.                                                                                   */
/*             END.                                                                                                 */
/*             IF CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0                 */
/*                         AND CAN-FIND(FIRST Almmmatg OF Facdpedi WHERE Almmmatg.CodFam = '017' NO-LOCK)           */
/*                         NO-LOCK) THEN DO:                                                                        */
/*                 lHay017 = YES.                                                                                   */
/*             END.                                                                                                 */
/*             IF CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0                 */
/*                         AND CAN-FIND(FIRST Almmmatg OF Facdpedi WHERE LOOKUP(Almmmatg.CodFam, '010,011,017') = 0 */
/*                                      NO-LOCK)                                                                    */
/*                         NO-LOCK) THEN DO:                                                                        */
/*                 lHayOtras = YES.                                                                                 */
/*             END.                                                                                                 */
            ASSIGN
                COMBO-BOX_CodAlm_010:SENSITIVE = lHay010
                COMBO-BOX_CodAlm_011:SENSITIVE = lHay011
                COMBO-BOX_CodAlm_017:SENSITIVE = lHay017
                COMBO-BOX_CodAlm_Otras:SENSITIVE = lHayOtras.
        END.
        OTHERWISE DO:
            /* ************************************************************************************** */
            /* Si Abastecimientos ha configurado su almacén de despacho por defecto (solo un almacén) */
            /* ************************************************************************************** */
            ASSIGN
                COMBO-BOX_CodAlm:SENSITIVE = YES.
            IF FacCPedi.LugEnt2 > '' 
                AND CAN-FIND(Almacen NO-LOCK WHERE Almacen.codcia = s-codcia AND Almacen.codalm = Faccpedi.LugEnt2) 
                THEN x-codalm = Faccpedi.LugEnt2.
            /* ************************************************************************************** */
            /* LOS almacen SE ORDENAN DE ACUERDO AL ORDEN DE PRIORIDAD */
            COMBO-BOX_CodAlm:DELETE(COMBO-BOX_CodAlm:LIST-ITEMS).
            DO j = 1 TO NUM-ENTRIES(x-codalm):
                FIND almacen WHERE almacen.codcia = s-codcia
                    AND almacen.codalm = ENTRY(j, x-codalm)
                    NO-LOCK NO-ERROR.
                IF AVAILABLE almacen THEN COMBO-BOX_CodAlm:ADD-LAST(almacen.codalm + ' - ' + INTEGRAL.Almacen.Descripcion)
                    IN FRAME {&FRAME-NAME}.
                IF j = 1 THEN COMBO-BOX_CodAlm = almacen.codalm + ' - ' + INTEGRAL.Almacen.Descripcion.
                /* Muestra el almacén por defecto asignado por Abastecimientos */
                IF Faccpedi.LugEnt2 <> '' AND LOOKUP(Faccpedi.LugEnt2, x-CodAlm) > 0
                    AND AVAILABLE Almacen AND Faccpedi.LugEnt2 = Almacen.CodAlm 
                    THEN COMBO-BOX_CodAlm = almacen.codalm + ' - ' + INTEGRAL.Almacen.Descripcion.
            END.
            DISPLAY COMBO-BOX_CodAlm.
        END.
    END CASE.
    END.
  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-11 D-Dialog
ON CHOOSE OF BUTTON-11 IN FRAME D-Dialog /* Aplicar Filtro */
DO:

    ASSIGN
        FILL-IN-CodCli txtOrdenCompra.

    IF FILL-IN-Codcli = "" OR txtOrdenCompra = "" THEN DO:
        MESSAGE "Ingrese codigo Cliente y Orden de Compra".
            RETURN NO-APPLY.
    END.
    
    RUN cargar-pedidos.

    {&OPEN-QUERY-{&BROWSE-NAME}}
    APPLY 'VALUE-CHANGED' TO {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-12 D-Dialog
ON CHOOSE OF BUTTON-12 IN FRAME D-Dialog /* Generar O/D */
DO:
                
        MESSAGE 'Seguro de GENERAR las ORDENES?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.    

    /* --- */
    RUN generar-ordenes.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-pedidos D-Dialog 
PROCEDURE cargar-pedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-faccpedi.

FOR EACH x-faccpedi WHERE {&condicion} NO-LOCK:
    CREATE tt-faccpedi.
    BUFFER-COPY x-faccpedi TO tt-faccpedi.

    /*  */
    FIND FIRST faccpedi WHERE faccpedi.codcia = tt-Faccpedi.codcia
                            AND faccpedi.coddiv = tt-Faccpedi.coddiv
                            AND faccpedi.coddoc = tt-Faccpedi.codref
                            AND faccpedi.nroped = tt-Faccpedi.nroref
                            NO-LOCK NO-ERROR.
    IF AVAILABLE faccpedi THEN DO:
        tt-Faccpedi.ubigeo[1] = Faccpedi.ubigeo[1].
    END.
END.

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
  DISPLAY FILL-IN-CodCli txtOrdenCompra 
      WITH FRAME D-Dialog.
  ENABLE BROWSE-7 BUTTON-12 FILL-IN-CodCli txtOrdenCompra BUTTON-11 BROWSE-4 
         Btn_Cancel RECT-56 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-ordenes D-Dialog 
PROCEDURE generar-ordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ---- */

EMPTY TEMP-TABLE w-report-tmp.
{&OPEN-QUERY-BROWSE-7}

SESSION:SET-WAIT-STATE('GENERAL').

FOR EACH tt-faccpedi :
    /**/
    CREATE w-report-tmp.
      ASSIGN  w-report-tmp.campo-c[1] = tt-faccpedi.nroped
              w-report-tmp.campo-c[2] = "Inicio".       

    /* --- */
    RUN nueva-orden.

    CREATE w-report-tmp.
      ASSIGN  w-report-tmp.campo-c[1] = tt-faccpedi.nroped
              w-report-tmp.campo-c[2] = "FIN".           

    /*IF RETURN-VALUE = "ADM-ERROR" THEN LEAVE LoopCotizaciones.*/
        
END.

RUN cargar-pedidos.

{&OPEN-QUERY-BROWSE-7}
{&OPEN-QUERY-BROWSE-4}

SESSION:SET-WAIT-STATE('').

IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

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


  DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO.
  /*
  FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
  FOR EACH FacCorre NO-LOCK WHERE 
      FacCorre.CodCia = s-CodCia AND
      FacCorre.CodDoc = s-CodDoc AND
      FacCorre.CodDiv = s-CodDiv:
      IF cListItems = "" THEN cListItems = STRING(FacCorre.NroSer,"999").
      ELSE cListItems = cListItems + "," + STRING(FacCorre.NroSer,"999").
  END.
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-NroSer:LIST-ITEMS = cListItems.
      COMBO-NroSer = ENTRY(1,COMBO-NroSer:LIST-ITEMS).
      s-NroSer = INTEGER(COMBO-NroSer).
  END.
  */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nueva-orden D-Dialog 
PROCEDURE nueva-orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE I-NPEDI AS INTEGER NO-UNDO.
DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
DEFINE VARIABLE s-StkComprometido AS DEC.
DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.
DEFINE VARIABLE F-CANPED AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-StkAct AS DEC NO-UNDO.
DEFINE VARIABLE x-CodAlm AS CHAR NO-UNDO.
DEFINE VAR pMensaje AS CHAR.

DEF VAR t-AlmDes AS CHAR NO-UNDO.
DEF VAR t-CanPed AS DEC NO-UNDO.
DEFINE VAR pFchEnt AS DATE.

/*
/* Cargar el detalle de la cotizacion */
RUN cargar-detalle-pedido.
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    RETURN "ADM-ERROR".
END.
*/
  
GenerarOrden:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR' :
    
    FIND faccpedi OF tt-faccpedi EXCLUSIVE NO-ERROR.

    IF NOT AVAILABLE faccpedi THEN DO:
        CREATE w-report-tmp.
          ASSIGN  w-report-tmp.campo-c[1] = tt-faccpedi.nroped
                  w-report-tmp.campo-c[2] = "Imposible bloquear PEDIDO".       

        RELEASE faccpedi.

        UNDO GenerarOrden, RETURN "ADM-ERROR".
    END.

    IF faccpedi.flgest <> 'G' THEN DO:
        CREATE w-report-tmp.
          ASSIGN  w-report-tmp.campo-c[1] = tt-faccpedi.nroped
                  w-report-tmp.campo-c[2] = "Pedido ya fue aprobado : " + 
                                                tt-FacCPedi.UsrAprobacion + " - " +
                                                STRING(tt-faccpedi.fchaprobacion,"99/99/9999").

        UNDO GenerarOrden, RETURN "ADM-ERROR".
    END.

    /* VERIFICAMOS DEUDA DEL CLIENTE */
    {vta2/verifica-cliente-01.i &VarMensaje = pMensaje}
    
    IF Faccpedi.FlgEst = "X" THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO pasó la línea de crédito".
        CREATE w-report-tmp.
          ASSIGN  w-report-tmp.campo-c[1] = tt-faccpedi.nroped
                  w-report-tmp.campo-c[2] = pMensaje.

        UNDO GenerarOrden, RETURN "ADM-ERROR".

    END.

    DEF VAR x-FlgSit AS CHAR INIT "" NO-UNDO.

    /* VERIFICAMOS MARGEN DE UTILIDAD */
    IF LOOKUP(s-CodDiv, '00000,00017,00018') > 0 THEN DO:
        {vta2/i-verifica-margen-utilidad-1.i}
        IF Faccpedi.FlgEst = "W" THEN DO:
            pMensaje = FacCPedi.Libre_c05.
            CREATE w-report-tmp.
              ASSIGN  w-report-tmp.campo-c[1] = tt-faccpedi.nroped
                      w-report-tmp.campo-c[2] = "Margen de Utilidad :" + pMensaje .

            UNDO GenerarOrden, RETURN "ADM-ERROR".
        END.
    END.

    RUN vta2/pcreaordendesp ( ROWID(Faccpedi), OUTPUT pMensaje ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        CREATE w-report-tmp.
          ASSIGN  w-report-tmp.campo-c[1] = tt-faccpedi.nroped
                  w-report-tmp.campo-c[2] = "No se pudo crear la O/D" .

        UNDO GenerarOrden, RETURN "ADM-ERROR".
    END.
    x-FlgSit = "".
    /* MARCAMOS EL PEDIDO */
    ASSIGN
        Faccpedi.FlgSit = x-FlgSit.
    FIND CURRENT Faccpedi NO-LOCK.

END.

RETURN "OK".

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
  {src/adm/template/snd-list.i "w-report-tmp"}
  {src/adm/template/snd-list.i "tt-FacCPedi"}

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

