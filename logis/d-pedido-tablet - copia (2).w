&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE BUFFER PCO FOR FacCPedi.
DEFINE TEMP-TABLE PEDI LIKE FacDPedi.
DEFINE TEMP-TABLE PEDI-2 NO-UNDO LIKE FacDPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE TEMP-TABLE Reporte NO-UNDO LIKE FacCPedi.
DEFINE TEMP-TABLE t-FacTabla NO-UNDO LIKE FacTabla
       FIELD ImpLin AS DECI EXTENT 5
       FIELD AlmDes AS CHAR EXTENT 5
       FIELD DesAlm AS CHAR EXTENT 5
       FIELD FchEnt AS DATE EXTENT 5
       FIELD Peso   AS DECI EXTENT 5.
DEFINE TEMP-TABLE t-logtabla NO-UNDO LIKE logtabla.



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
DEF INPUT PARAMETER s-CodRef AS CHAR.   /* COT */
DEF INPUT PARAMETER s-NroCot AS CHAR.
DEF OUTPUT PARAMETER pCodAlm AS CHAR.

pCodAlm = "".       /* Valor por defecto */

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR S-TPOPED AS CHAR.

DEF VAR s-PorIgv LIKE Ccbcdocu.PorIgv.
DEF VAR s-CodDoc AS CHAR INIT "PED" NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO. 
DEF VAR pCuenta AS INTE NO-UNDO.
DEF VAR pMensajeFinal AS CHAR NO-UNDO.
DEF VAR pFchEnt AS DATE NO-UNDO.
DEF VAR s-FlgEnv AS LOG NO-UNDO.
DEF VAR xNroPCO AS CHAR NO-UNDO.

/* ICBPER */
DEFINE VAR x-articulo-ICBPER AS CHAR.

x-articulo-ICBPER = '099268'.


/* COTIZACION */
FIND B-CPEDI WHERE B-CPEDI.codcia = s-codcia
    AND B-CPEDI.coddiv = s-CodDiv
    AND B-CPEDI.coddoc = s-CodRef
    AND B-CPEDI.nroped = s-NroCot
    NO-LOCK.
ASSIGN
    pFchEnt  = B-CPEDI.FchEnt
    s-FlgEnv = NO
    s-PorIgv = B-CPEDI.PorIgv.

/* Revisamos almacenes de despacho */
/* RHC 24/12/2019 VAMOS CON LA LISTA DE PRECIOS */
/* IF NOT CAN-FIND(FIRST VtaAlmDiv WHERE Vtaalmdiv.codcia = s-codcia                                                    */
/*                 AND Vtaalmdiv.coddiv = B-CPEDI.Lista_de_Precios                                                      */
/*                 AND CAN-FIND(FIRST Almacen OF Vtaalmdiv WHERE Almacen.Campo-C[3] <> 'Si' NO-LOCK)   /* NO Remates */ */
/*                 NO-LOCK)                                                                                             */
/*     THEN DO:                                                                                                         */
/*     MESSAGE 'NO hay almacenes de despacho definidos para la división' s-coddiv VIEW-AS ALERT-BOX INFORMATION.        */
/*     RETURN ERROR.                                                                                                    */
/* END.                                                                                                                 */
/* IF NOT CAN-FIND(FIRST VtaAlmDiv WHERE Vtaalmdiv.codcia = s-codcia                                                    */
/*                 AND Vtaalmdiv.coddiv = s-CodDiv                                                                      */
/*                 AND CAN-FIND(FIRST Almacen OF Vtaalmdiv WHERE Almacen.Campo-C[3] <> 'Si' NO-LOCK)   /* NO Remates */ */
/*                 NO-LOCK)                                                                                             */
/*     THEN DO:                                                                                                         */
/*     MESSAGE 'NO hay almacenes de despacho definidos para la división' s-coddiv VIEW-AS ALERT-BOX INFORMATION.        */
/*     RETURN ERROR.                                                                                                    */
/* END.                                                                                                                 */

/* Revisamo el correlativo */
DEF VAR s-NroSer AS INTEGER.

FIND FIRST FacCorre WHERE FacCorre.CodCia = s-codcia AND
    FacCorre.CodDiv = s-coddiv AND 
    FacCorre.CodDoc = "PED" AND
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE 'Correlativo de PED no configurado' VIEW-AS ALERT-BOX ERROR.
    UNDO, RETURN ERROR.
END.
s-NroSer = FacCorre.NroSer.
FIND FIRST FacCorre WHERE FacCorre.CodCia = s-codcia AND
    FacCorre.CodDiv = s-coddiv AND 
    FacCorre.CodDoc = "O/D" AND
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE 'Correlativo de O/D no configurado' VIEW-AS ALERT-BOX ERROR.
    UNDO, RETURN ERROR.
END.

DEF VAR s-CodAlm AS CHAR NO-UNDO.
DEF VAR s-FlgEmpaque LIKE GN-DIVI.FlgEmpaque.
DEF VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEF VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.

/* RHC 31/01/2018 Valores por defecto pero dependen de la COTIZACION */
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

/* ********************************************* */
/* Determinamos hasta 5 almacenes para despachar */
/* RHC 31/01/2018 PARAMETROS DE ACUERDO A LA COTIZACION */
/* **************************************************** */
DEF BUFFER B-DIVI FOR gn-divi.
FIND B-DIVI WHERE B-DIVI.codcia = s-codcia AND B-DIVI.coddiv = B-CPEDI.Libre_c01 NO-LOCK NO-ERROR.
IF AVAILABLE B-DIVI THEN DO:
    ASSIGN
        s-DiasVtoPed = B-DIVI.DiasVtoPed
        s-FlgEmpaque = B-DIVI.FlgEmpaque
        s-VentaMayorista = B-DIVI.VentaMayorista.
END.
/* **************************************************** */
/* Lista de almacenes válidos de despacho, en orden de prioridad */
/* Tope 5 almacenes */
DEF VAR j AS INTE INIT 0 NO-UNDO.
s-CodAlm = ''.
/* RHC 24/12/2019 VAMOS CON LA LISTA DE PRECIOS */
FOR EACH VtaAlmDiv NO-LOCK WHERE Vtaalmdiv.codcia = s-codcia
    AND Vtaalmdiv.coddiv = B-CPEDI.Lista_de_Precios,
    FIRST Almacen OF Vtaalmdiv NO-LOCK WHERE Almacen.Campo-C[3] <> 'Si'     /* NO Remates */
    BY VtaAlmDiv.Orden:
    j = j + 1.
    IF j > 5 THEN LEAVE.
    IF TRUE <> (s-CodAlm > "") THEN s-CodAlm = TRIM(VtaAlmDiv.CodAlm).
    ELSE s-CodAlm = s-CodAlm + "," + TRIM(VtaAlmDiv.CodAlm).
END.
/* RHC 24/12/2019 VAMOS CON LA DIVISION */
IF TRUE <> (s-CodAlm > '') THEN DO:
    FOR EACH VtaAlmDiv NO-LOCK WHERE Vtaalmdiv.codcia = s-codcia
        AND Vtaalmdiv.coddiv = s-CodDiv,
        FIRST Almacen OF Vtaalmdiv NO-LOCK WHERE Almacen.Campo-C[3] <> 'Si'     /* NO Remates */
        BY VtaAlmDiv.Orden:
        j = j + 1.
        IF j > 5 THEN LEAVE.
        IF TRUE <> (s-CodAlm > "") THEN s-CodAlm = TRIM(VtaAlmDiv.CodAlm).
        ELSE s-CodAlm = s-CodAlm + "," + TRIM(VtaAlmDiv.CodAlm).
    END.
END.
/* ************************************************************************************** */
/* Si Abastecimientos ha configurado su almacén de despacho por defecto (solo un almacén) */
/* ************************************************************************************** */
/* ASSIGN                                */
/*     COMBO-BOX_CodAlm:SENSITIVE = YES. */
IF B-CPEDI.LugEnt2 > '' 
    AND CAN-FIND(Almacen NO-LOCK WHERE Almacen.codcia = s-codcia AND 
                 Almacen.codalm = B-CPEDI.LugEnt2) 
    THEN s-CodAlm = B-CPEDI.LugEnt2.
/* ************************************************************************************** */
/* Si es EXPOBODEGAS */
/* ************************************************************************************** */
IF B-CPEDI.Cliente_Recoge = YES THEN s-CodAlm = B-CPEDI.CodAlm.

IF TRUE <> (s-CodAlm > '') THEN DO:
    MESSAGE 'NO hay almacenes de despacho definidos para la división' s-coddiv VIEW-AS ALERT-BOX INFORMATION.
    RETURN ERROR.
END.

/* ************************************************************************************** */
/* CARGAMOS PEDI EN EL ORDEN DE LOS ALMACENES DE DESPACHO */
/* ************************************************************************************** */
/* RHC 17/10/2019 Seleccionamos los almacenes que quiere calcular */
/* ************************************************************************************** */
RUN logis/d-selecc-alm-despacho (INPUT-OUTPUT s-CodAlm).
IF TRUE <> (s-CodAlm > '') THEN RETURN ERROR.
/* ************************************************************************************** */
/* ************************************************************************************** */

SESSION:SET-WAIT-STATE('GENERAL').
RUN Carga-Temporal.
SESSION:SET-WAIT-STATE('').
FIND FIRST t-FacTabla NO-LOCK NO-ERROR.
IF NOT AVAILABLE t-FacTabla THEN DO:
    MESSAGE 'NO hay artículos disponibles para generar el pedido' SKIP
        'Proceso Abortado'
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN ERROR.
END.

FIND FIRST PEDI NO-LOCK NO-ERROR.
IF NOT AVAILABLE PEDI THEN DO:
    MESSAGE 'No hay stock suficente' SKIP 'Proceso Abortado' VIEW-AS ALERT-BOX INFORMATION.
    RETURN ERROR.
END.

/* MENSAJE GENERAL */
DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

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
&Scoped-define INTERNAL-TABLES t-FacTabla

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 t-FacTabla.Codigo t-FacTabla.Nombre ~
t-FacTabla.Campo-C[10] t-FacTabla.Valor[1] t-FacTabla.Valor[2] ~
t-FacTabla.Valor[3] t-FacTabla.Valor[4] t-FacTabla.Valor[5] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH t-FacTabla NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH t-FacTabla NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 t-FacTabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 t-FacTabla


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 Btn_OK Btn_Cancel RADIO-SET-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 FILL-IN-2 FILL-IN-3 FILL-IN-4 ~
FILL-IN-5 FILL-IN-Peso-1 FILL-IN-Peso-2 FILL-IN-Peso-3 FILL-IN-Peso-4 ~
FILL-IN-Peso-5 RADIO-SET-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/delete.ico":U
     LABEL "Cancel" 
     SIZE 15 BY 1.69
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/ok.ico":U
     LABEL "OK" 
     SIZE 15 BY 1.69
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-1 AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Importes" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-Peso-1 AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Pesos (kg)" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 1 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-Peso-2 AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 1 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-Peso-3 AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 1 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-Peso-4 AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 1 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-Peso-5 AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 1 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "1", 1,
"2", 2,
"3", 3,
"4", 4,
"5", 5
     SIZE 71 BY .85
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      t-FacTabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 D-Dialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      t-FacTabla.Codigo FORMAT "x(8)":U
      t-FacTabla.Nombre COLUMN-LABEL "Descripción" FORMAT "x(40)":U
            WIDTH 45.14
      t-FacTabla.Campo-C[10] COLUMN-LABEL "Unidad" FORMAT "x(8)":U
            WIDTH 6.43
      t-FacTabla.Valor[1] FORMAT "->>,>>9.9999":U WIDTH 13.43
      t-FacTabla.Valor[2] FORMAT "->>,>>9.9999":U WIDTH 13.43
      t-FacTabla.Valor[3] FORMAT "->>,>>9.9999":U WIDTH 13.43
      t-FacTabla.Valor[4] FORMAT "->>,>>9.9999":U WIDTH 12.43
      t-FacTabla.Valor[5] FORMAT "->>,>>9.9999":U WIDTH 13.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 131 BY 16.42
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-2 AT ROW 1.27 COL 2 WIDGET-ID 200
     FILL-IN-1 AT ROW 17.69 COL 60 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-2 AT ROW 17.69 COL 74 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     FILL-IN-3 AT ROW 17.69 COL 88 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     FILL-IN-4 AT ROW 17.69 COL 102 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     FILL-IN-5 AT ROW 17.69 COL 116 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     Btn_OK AT ROW 18.5 COL 2
     Btn_Cancel AT ROW 18.5 COL 18
     FILL-IN-Peso-1 AT ROW 18.5 COL 60 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-Peso-2 AT ROW 18.5 COL 74 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     FILL-IN-Peso-3 AT ROW 18.5 COL 88 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     FILL-IN-Peso-4 AT ROW 18.5 COL 102 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     FILL-IN-Peso-5 AT ROW 18.5 COL 116 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     RADIO-SET-1 AT ROW 19.31 COL 62 NO-LABEL WIDGET-ID 12
     "Seleccione Despacho:" VIEW-AS TEXT
          SIZE 16 BY .5 AT ROW 19.31 COL 46 WIDGET-ID 18
     SPACE(72.13) SKIP(0.68)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "PROYECTADO DE DESPACHO"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: PCO B "?" ? INTEGRAL FacCPedi
      TABLE: PEDI T "?" ? INTEGRAL FacDPedi
      TABLE: PEDI-2 T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: Reporte T "?" NO-UNDO INTEGRAL FacCPedi
      TABLE: t-FacTabla T "?" NO-UNDO INTEGRAL FacTabla
      ADDITIONAL-FIELDS:
          FIELD ImpLin AS DECI EXTENT 5
          FIELD AlmDes AS CHAR EXTENT 5
          FIELD DesAlm AS CHAR EXTENT 5
          FIELD FchEnt AS DATE EXTENT 5
          FIELD Peso   AS DECI EXTENT 5
      END-FIELDS.
      TABLE: t-logtabla T "?" NO-UNDO INTEGRAL logtabla
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
/* BROWSE-TAB BROWSE-2 TEXT-1 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Peso-1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Peso-2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Peso-3 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Peso-4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Peso-5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.t-FacTabla"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.t-FacTabla.Codigo
     _FldNameList[2]   > Temp-Tables.t-FacTabla.Nombre
"t-FacTabla.Nombre" "Descripción" ? "character" ? ? ? ? ? ? no ? no no "45.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.t-FacTabla.Campo-C[10]
"t-FacTabla.Campo-C[10]" "Unidad" ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.t-FacTabla.Valor[1]
"t-FacTabla.Valor[1]" ? ? "decimal" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-FacTabla.Valor[2]
"t-FacTabla.Valor[2]" ? ? "decimal" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.t-FacTabla.Valor[3]
"t-FacTabla.Valor[3]" ? ? "decimal" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.t-FacTabla.Valor[4]
"t-FacTabla.Valor[4]" ? ? "decimal" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.t-FacTabla.Valor[5]
"t-FacTabla.Valor[5]" ? ? "decimal" ? ? ? ? ? ? no ? no no "13.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* PROYECTADO DE DESPACHO */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
  ASSIGN RADIO-SET-1 FILL-IN-1 FILL-IN-2 FILL-IN-3 FILL-IN-4 FILL-IN-5.
  DEF VAR x-Ok AS LOGICAL INIT YES NO-UNDO.
  CASE RADIO-SET-1:
      WHEN 1 THEN DO:
          IF FILL-IN-1 <= 0 THEN x-Ok = NO.
      END.
      WHEN 2 THEN DO:
          IF FILL-IN-2 <= 0 THEN x-Ok = NO.
      END.
      WHEN 3 THEN DO:
          IF FILL-IN-3 <= 0 THEN x-Ok = NO.
      END.
      WHEN 4 THEN DO:
          IF FILL-IN-4 <= 0 THEN x-Ok = NO.
      END.
      WHEN 5 THEN DO:
          IF FILL-IN-5 <= 0 THEN x-Ok = NO.
      END.
  END CASE.
  IF x-OK = NO THEN DO:
      MESSAGE 'El almacén seleccionado NO tiene items' VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.
  MESSAGE 'Procedemos a generar el pedido?' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE rpta AS LOG.
  IF rpta = NO THEN UNDO, RETURN NO-APPLY.

  RUN Genera-Pedido.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Fecha-Entrega D-Dialog 
PROCEDURE Carga-Fecha-Entrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-CodAlm AS CHAR NO-UNDO.
DEF VAR k AS INTE NO-UNDO.
DEF VAR x-NroPed AS CHAR NO-UNDO.
DEF VAR pNroSku AS INT NO-UNDO.
DEF VAR pPeso AS DEC NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.

VIEW FRAME F-Proceso.
DO k = 1 TO NUM-ENTRIES(s-CodAlm):
    x-CodAlm = ENTRY(k, s-CodAlm).
    Fi-Mensaje = "(3) >>> Almacén: " + x-CodAlm.
    DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
    /* Creamos un PED FALSO */
    REPEAT:
        RUN lib/_gen_password ( INPUT 12, OUTPUT x-NroPed).
        IF NOT CAN-FIND(FIRST PEDIDO WHERE PEDIDO.codcia = s-codcia
                        AND PEDIDO.coddiv = s-coddiv
                        AND PEDIDO.coddoc = "PED"
                        AND PEDIDO.nroped = x-NroPed
                        NO-LOCK)
            THEN LEAVE.
    END.
    CREATE PEDIDO.
    BUFFER-COPY B-CPEDI TO PEDIDO
        ASSIGN
            PEDIDO.CodDoc = "PED"
            PEDIDO.NroPed = x-NroPed
            PEDIDO.CodAlm = x-CodAlm
            PEDIDO.FchPed = TODAY.
    ASSIGN
        PEDIDO.FlgEst = "X".    /* NO VALIDO */
    /* ****************************************************************************** */
    /* Reactualizamos la Fecha de Entrega                                             */
    /* ****************************************************************************** */
    ASSIGN 
        pNroSku = 0 
        pPeso = 0.
    FOR EACH PEDI WHERE PEDI.AlmDes = x-CodAlm NO-LOCK, FIRST Almmmatg OF PEDI NO-LOCK:
        pPeso = pPeso + (PEDI.CanPed * PEDI.Factor * Almmmatg.PesMat).
        pNroSku = pNroSku + 1.
    END.
    pFchEnt = PEDIDO.FchEnt.
    IF pFchEnt = ? THEN pFchEnt = TODAY.

    /* RHC 17/10/2019 Se calcula al grabar el pedido */
    pMensaje = ''.
    RUN logis/p-fecha-de-entrega (PEDIDO.CodDoc,
                                  PEDIDO.NroPed,
                                  INPUT-OUTPUT pFchEnt,
                                  OUTPUT pMensaje).

    FOR EACH t-FacTabla:
        t-FacTabla.FchEnt[k] = pFchEnt.
    END.
    DELETE PEDIDO.
END.
HIDE FRAME F-Proceso.

END PROCEDURE.

/*     RUN gn/p-fchent-v3.p (                                                                                      */
/*         PEDIDO.CodAlm,              /* Almacén de despacho */                                                   */
/*         TODAY,                        /* Fecha base */                                                          */
/*         STRING(TIME,'HH:MM:SS'),      /* Hora base */                                                           */
/*         PEDIDO.CodCli,              /* Cliente */                                                               */
/*         PEDIDO.CodDiv,              /* División solicitante */                                                  */
/*         (IF PEDIDO.TipVta = "Si" THEN "CR" ELSE PEDIDO.CodPos),   /* Ubigeo: CR es cuando el cliente recoje  */ */
/*         PEDIDO.CodDoc,              /* Documento actual */                                                      */
/*         PEDIDO.NroPed,                                                                                          */
/*         pNroSKU,                                                                                                */
/*         pPeso,                                                                                                  */
/*         INPUT-OUTPUT pFchEnt,                                                                                   */
/*         OUTPUT pMensaje).                                                                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Producto D-Dialog 
PROCEDURE Carga-Producto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT        PARAMETER x-CodAlm AS CHAR.
DEF INPUT-OUTPUT PARAMETER I-NPEDI  AS INTE NO-UNDO.

DEF VAR f-Factor AS DEC NO-UNDO.
DEF VAR t-AlmDes AS CHAR NO-UNDO.
DEF VAR t-CanPed AS DEC NO-UNDO.
DEF VAR F-CANPED AS DECIMAL NO-UNDO.
DEF VAR x-StkAct AS DEC NO-UNDO.
DEF VAR s-StkComprometido AS DEC.
DEF VAR s-StkDis AS DEC NO-UNDO.
DEF VAR x-CanPed AS DEC NO-UNDO.
DEF VAR pSugerido AS DEC NO-UNDO.
DEF VAR pEmpaque AS DEC NO-UNDO.
DEF VAR pAlmSug AS CHAR NO-UNDO.
DEF VAR pRetirar AS LOG NO-UNDO.

DEF VAR x-CuentaItems AS INT NO-UNDO.

/* RHC 12/06/2020 las líneas con Categoria Contable SV NO verifican stock */
/* 1ro. Cargamos Productos que NO sean SV */
/* RHC 09/07/2020 Productos Drop Shipping NO verifican stock */
ALMACENES:
FOR EACH Facdpedi OF B-CPEDI NO-LOCK WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0,
    FIRST Almmmatg OF Facdpedi NO-LOCK, 
    FIRST Almtfami OF Almmmatg NO-LOCK:
    /* ************************************************************************* */
    CASE TRUE:
        WHEN Almtfami.Libre_c01 = "SV" THEN NEXT.
        OTHERWISE DO:
            /* ************************************************************************* */
            /* Buscamos si es Drop Shipping */
            /* ************************************************************************* */
            FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
                VtaTabla.Tabla = "DROPSHIPPING" AND
                VtaTabla.Llave_c1 = Facdpedi.CodMat 
                NO-LOCK NO-ERROR.
/*             FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND */
/*                 VtaTabla.Tabla = "DROPSHIPPING" AND                  */
/*                 VtaTabla.Llave_c1 = B-CPEDI.CodDiv AND               */
/*                 VtaTabla.Llave_c2 = Facdpedi.CodMat                  */
/*                 NO-LOCK NO-ERROR.                                    */
            IF AVAILABLE VtaTabla THEN NEXT.
        END.
    END CASE.
    /* ************************************************************************* */
    Fi-Mensaje = "(1) >>> Almacén: " + x-CodAlm + " Producto: " + Facdpedi.codmat.
    x-CuentaItems = x-CuentaItems + 1.
    IF x-CuentaItems = 1 OR (x-CuentaItems MODULO 10) = 0 
        THEN DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
    ASSIGN
        f-Factor = Facdpedi.Factor
        t-AlmDes = ''
        t-CanPed = 0.
    F-CANPED = (FacDPedi.CanPed - FacDPedi.CanAte).
    /* FILTROS */
    FIND FIRST Almmmate WHERE Almmmate.codcia = s-codcia
        AND Almmmate.codalm = x-CodAlm  /* *** OJO *** */
        AND Almmmate.codmat = Facdpedi.CodMat
        NO-LOCK NO-ERROR.
/*     IF x-articulo-ICBPER <> Facdpedi.CodMat THEN DO:                      */
/*         IF NOT AVAILABLE Almmmate THEN NEXT.    /* Siguiente Producto **/ */
/*     END.                                                                  */
    /* ******************************************************************** */
    /* Stock Disponible */
    /* ******************************************************************** */
    x-StkAct = 0.
    IF AVAILABLE Almmmate THEN x-StkAct = Almmmate.StkAct.
    IF x-articulo-ICBPER <> Facdpedi.CodMat THEN DO:
        /* Si es un "SV" el stock comprometido es cero */
        RUN gn/Stock-Comprometido-v2 (Facdpedi.CodMat, x-CodAlm, YES, OUTPUT s-StkComprometido).
        /* RHC 29/04/2020 Tener cuidado, las COT también comprometen mercadería */
        FIND FacTabla WHERE FacTabla.CodCia = B-CPEDI.CodCia AND
            FacTabla.Tabla = "GN-DIVI" AND
            FacTabla.Codigo = B-CPEDI.CodDiv AND
            FacTabla.Campo-L[2] = YES AND   /* Reserva Stock? */
            FacTabla.Valor[1] > 0           /* Horas de reserva */
            NO-LOCK NO-ERROR.
        IF AVAILABLE FacTabla THEN DO:
            /* Si ha llegado hasta acá es que está dentro de las horas de reserva */
            /* Afectamos lo comprometido: extornamos el comprometido */
            s-StkComprometido = s-StkComprometido - (Facdpedi.Factor * (Facdpedi.CanPed - Facdpedi.CanAte)).
        END.
        s-StkDis = x-StkAct - s-StkComprometido.
        IF s-StkDis <= 0 THEN NEXT.     /* Siquiente Producto */
    END.
    /* ******************************************************************** */
    /* DEFINIMOS LA CANTIDAD */
    /* ******************************************************************** */
    x-CanPed = f-CanPed * f-Factor.   /* En unidades de stock */
    IF s-StkDis < x-CanPed THEN DO:
        /* Se ajusta la Cantidad Pedida al Saldo Disponible del Almacén */
        f-CanPed = ((S-STKDIS - (S-STKDIS MODULO f-Factor)) / f-Factor).
    END.
    f-CanPed = f-CanPed * f-Factor.   /* En unidades de Stock */
    /* ******************************************************************** */
    /* EMPAQUE SUPERMERCADOS */
    /* ******************************************************************** */
    FIND FIRST supmmatg WHERE supmmatg.codcia = B-CPedi.CodCia
        AND supmmatg.codcli = B-CPedi.CodCli
        AND supmmatg.codmat = FacDPedi.codmat 
        NO-LOCK NO-ERROR.
    IF AVAILABLE supmmatg AND supmmatg.Libre_d01 <> 0 THEN DO:
        f-CanPed = (TRUNCATE((f-CanPed / supmmatg.Libre_d01),0) * supmmatg.Libre_d01).
    END.
    ELSE DO:    /* EMPAQUE OTROS */
        IF s-FlgEmpaque = YES THEN DO:
            RUN vtagn/p-cantidad-sugerida-pco.p (Facdpedi.CodMat, 
                                                 f-CanPed, 
                                                 OUTPUT pSugerido, 
                                                 OUTPUT pEmpaque).
            f-CanPed = pSugerido.
        END.
    END.
    f-CanPed = ((f-CanPed - (f-CanPed MODULO f-Factor)) / f-Factor).  /* En unidades de venta */
    IF f-CanPed <= 0 THEN NEXT ALMACENES.
    IF f-CanPed > t-CanPed THEN DO:
        t-CanPed = f-CanPed.
        t-AlmDes = x-CodAlm.
    END.

    IF t-CanPed > 0 THEN DO:
        /* ******************************* */
        /* GRABACION */
        I-NPEDI = I-NPEDI + 1.
        CREATE PEDI.
        BUFFER-COPY FacDPedi 
            EXCEPT Facdpedi.CanSol Facdpedi.CanApr
            TO PEDI
            ASSIGN 
                PEDI.CodCia = s-codcia
                PEDI.CodDiv = s-coddiv
                PEDI.CodDoc = s-coddoc
                PEDI.NroPed = ''
                PEDI.CodCli = B-CPEDI.CodCli
                PEDI.ALMDES = t-AlmDes  /* *** OJO *** */
                PEDI.NroItm = I-NPEDI
                PEDI.CanPed = t-CanPed    /* << OJO << */
                PEDI.CanAte = 0.
        ASSIGN
            PEDI.Libre_d01 = (FacDPedi.CanPed - FacDPedi.CanAte)
            PEDI.Libre_d02 = t-CanPed
            PEDI.Libre_c01 = '*'.
        /* RHC 28/04/2016 Caso extraño */
        IF PEDI.CanPed > PEDI.Libre_d01 
            THEN ASSIGN 
                    PEDI.CanPed = PEDI.Libre_d01 
                    PEDI.Libre_d02 = PEDI.Libre_d01.
        /* *************************** */
        IF PEDI.CanPed <> facdPedi.CanPed THEN DO:
            {vta2/calcula-linea-detalle.i &Tabla="PEDI"}.
        END.
        /* FIN DE CARGA */
    END.
END.
/* ******************************************************************** */
/* 2do. Cargamos Productos que SI sean SV */
/* ******************************************************************** */
SERVICIOS:
FOR EACH Facdpedi OF B-CPEDI NO-LOCK WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0,
    FIRST Almmmatg OF Facdpedi NO-LOCK, 
    FIRST Almtfami OF Almmmatg NO-LOCK WHERE Almtfami.Libre_c01 = "SV":
    /* ************************************************************************* */
    /* Buscamos si es Drop Shipping */
    /* ************************************************************************* */
    FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
        VtaTabla.Tabla = "DROPSHIPPING" AND
        VtaTabla.Llave_c1 = Facdpedi.CodMat 
        NO-LOCK NO-ERROR.
/*     FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND */
/*         VtaTabla.Tabla = "DROPSHIPPING" AND                  */
/*         VtaTabla.Llave_c1 = B-CPEDI.CodDiv AND               */
/*         VtaTabla.Llave_c2 = Facdpedi.CodMat                  */
/*         NO-LOCK NO-ERROR.                                    */
    IF AVAILABLE VtaTabla THEN NEXT.
    /* ************************************************************************* */
    Fi-Mensaje = "(1) >>> Almacén: " + x-CodAlm + " Producto: " + Facdpedi.codmat.
    x-CuentaItems = x-CuentaItems + 1.
    IF x-CuentaItems = 1 OR (x-CuentaItems MODULO 10) = 0 
        THEN DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
    /* ******************************* */
    /* GRABACION */
    I-NPEDI = I-NPEDI + 1.
    CREATE PEDI.
    BUFFER-COPY FacDPedi 
        EXCEPT Facdpedi.CanSol Facdpedi.CanApr
        TO PEDI
        ASSIGN 
            PEDI.CodCia = s-codcia
            PEDI.CodDiv = s-coddiv
            PEDI.CodDoc = s-coddoc
            PEDI.NroPed = ''
            PEDI.CodCli = B-CPEDI.CodCli
            PEDI.ALMDES = x-CodAlm  /* *** OJO *** */
            PEDI.NroItm = I-NPEDI
            PEDI.CanPed = (Facdpedi.CanPed - Facdpedi.CanAte)
            PEDI.CanAte = 0.
    ASSIGN
        PEDI.Libre_d01 = (FacDPedi.CanPed - FacDPedi.CanAte)
        PEDI.Libre_d02 = (FacDPedi.CanPed - FacDPedi.CanAte)
        PEDI.Libre_c01 = '*'.
    /* FIN DE CARGA */
END.
/* ******************************************************************** */
/* 3ro. Cargamos Productos que SI sean Drop Shipping */
/* ******************************************************************** */
DROPSHIPPING:
FOR EACH Facdpedi OF B-CPEDI NO-LOCK WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0,
    FIRST Almmmatg OF Facdpedi NO-LOCK, 
    FIRST Almtfami OF Almmmatg NO-LOCK WHERE Almtfami.Libre_c01 <> "SV":
    /* ************************************************************************* */
    /* Buscamos si es Drop Shipping */
    /* ************************************************************************* */
    FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
        VtaTabla.Tabla = "DROPSHIPPING" AND
        VtaTabla.Llave_c1 = Facdpedi.CodMat 
        NO-LOCK NO-ERROR.
/*     FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND */
/*         VtaTabla.Tabla = "DROPSHIPPING" AND                  */
/*         VtaTabla.Llave_c1 = B-CPEDI.CodDiv AND               */
/*         VtaTabla.Llave_c2 = Facdpedi.CodMat                  */
/*         NO-LOCK NO-ERROR.                                    */
    IF NOT AVAILABLE VtaTabla THEN NEXT.
    /* ************************************************************************* */
    /* ************************************************************************* */
    Fi-Mensaje = "(1) >>> Almacén: " + x-CodAlm + " Producto: " + Facdpedi.codmat.
    x-CuentaItems = x-CuentaItems + 1.
    IF x-CuentaItems = 1 OR (x-CuentaItems MODULO 10) = 0 
        THEN DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
    /* ******************************* */
    /* GRABACION */
    I-NPEDI = I-NPEDI + 1.
    CREATE PEDI.
    BUFFER-COPY FacDPedi 
        EXCEPT Facdpedi.CanSol Facdpedi.CanApr
        TO PEDI
        ASSIGN 
            PEDI.CodCia = s-codcia
            PEDI.CodDiv = s-coddiv
            PEDI.CodDoc = s-coddoc
            PEDI.NroPed = ''
            PEDI.CodCli = B-CPEDI.CodCli
            PEDI.ALMDES = x-CodAlm  /* *** OJO *** */
            PEDI.NroItm = I-NPEDI
            PEDI.CanPed = (Facdpedi.CanPed - Facdpedi.CanAte)
            PEDI.CanAte = 0.
    ASSIGN
        PEDI.Libre_d01 = (FacDPedi.CanPed - FacDPedi.CanAte)
        PEDI.Libre_d02 = (FacDPedi.CanPed - FacDPedi.CanAte)
        PEDI.Libre_c01 = '*'.
    /* FIN DE CARGA */
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Determinamos hasta 5 almacenes para despachar */
DEF VAR I-NPEDI  AS INTE NO-UNDO.

/* CARGAMOS PRODUCTO POR PRODUCTO */
DEF VAR k AS INT NO-UNDO.

DO TRANSACTION:
    EMPTY TEMP-TABLE PEDI.
    VIEW FRAME F-PROCESO.
    DO k = 1 TO NUM-ENTRIES(s-CodAlm):
        RUN Carga-Producto (ENTRY(k,s-CodAlm), INPUT-OUTPUT I-NPEDI).
    END.
    HIDE FRAME F-PROCESO.
END.

/* CARGAMOS RESUMEN POR CADA ALMACEN DE DESPACHO */
DEF VAR i AS INTE INIT 0 NO-UNDO.
DEF VAR x-CodAlm AS CHAR NO-UNDO.
DEF VAR x-CuentaItems AS INT NO-UNDO.
DO TRANSACTION:
    VIEW FRAME F-PROCESO.
    EMPTY TEMP-TABLE t-FacTabla.
    DO i = 1 TO NUM-ENTRIES(s-CodAlm):
        x-CodAlm = ENTRY(i, s-CodAlm).
        x-CuentaItems = 0.
        FOR EACH PEDI NO-LOCK WHERE PEDI.AlmDes = x-CodAlm, 
            FIRST Almmmatg OF PEDI NO-LOCK:
            Fi-Mensaje = "(2) >>> Almacén: " + x-CodAlm + " Producto: " + PEDI.codmat.
            x-CuentaItems = x-CuentaItems + 1.
            IF x-CuentaItems = 1 OR (x-CuentaItems MODULO 10) = 0 
                THEN DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
            FIND FIRST t-FacTabla WHERE t-FacTabla.Codigo = PEDI.CodMat NO-ERROR.
            IF NOT AVAILABLE t-FacTabla THEN CREATE t-FacTabla.
            ASSIGN
                t-FacTabla.Codigo = PEDI.CodMat
                t-FacTabla.Nombre = Almmmatg.DesMat
                t-FacTabla.Campo-C[10] = PEDI.UndVta
                t-FacTabla.AlmDes[i] = PEDI.AlmDes
                t-FacTabla.Valor[i]  = PEDI.CanPed
                t-FacTabla.Peso[i]   = PEDI.CanPed * PEDI.Factor * Almmmatg.PesMat
                t-FacTabla.ImpLin[i] = PEDI.ImpLin.
        END.
    END.
    HIDE FRAME F-PROCESO.
END.

/*  CALCULAMOS LA FECHA DE ENTREGA POR CADA PEDIDO */
RUN Carga-Fecha-Entrega.

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
  DISPLAY FILL-IN-1 FILL-IN-2 FILL-IN-3 FILL-IN-4 FILL-IN-5 FILL-IN-Peso-1 
          FILL-IN-Peso-2 FILL-IN-Peso-3 FILL-IN-Peso-4 FILL-IN-Peso-5 
          RADIO-SET-1 
      WITH FRAME D-Dialog.
  ENABLE BROWSE-2 Btn_OK Btn_Cancel RADIO-SET-1 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Fecha-Entrega D-Dialog 
PROCEDURE Fecha-Entrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pFchEnt    AS DATE.
DEF OUTPUT PARAMETER pMensaje   AS CHAR.

/* ****************************************************************************** */
/* Reactualizamos la Fecha de Entrega                                             */
/* ****************************************************************************** */
DEF VAR pNroSku AS INT NO-UNDO.
DEF VAR pPeso AS DEC NO-UNDO.

ASSIGN 
    pNroSku = 0 
    pPeso = 0.
FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
  pPeso = pPeso + (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.PesMat).
  pNroSku = pNroSku + 1.
END.
pFchEnt = FacCPedi.FchEnt.
IF pFchEnt = ? THEN pFchEnt = TODAY.
pMensaje = ''.
RUN gn/p-fchent-v3.p (
    FacCPedi.CodAlm,              /* Almacén de despacho */
    TODAY,                        /* Fecha base */
    STRING(TIME,'HH:MM:SS'),      /* Hora base */
    FacCPedi.CodCli,              /* Cliente */
    FacCPedi.CodDiv,              /* División solicitante */
    (IF FacCPedi.TipVta = "Si" THEN "CR" ELSE FacCPedi.CodPos),   /* Ubigeo: CR es cuando el cliente recoje  */
    FacCPedi.CodDoc,              /* Documento actual */
    FacCPedi.NroPed,
    pNroSKU,
    pPeso,
    INPUT-OUTPUT pFchEnt,
    OUTPUT pMensaje).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle D-Dialog 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE I-NPEDI AS INTEGER NO-UNDO INIT 0.
  DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
  DEFINE VARIABLE f-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE s-StkComprometido AS DEC.
  DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.

  DEF VAR f-PreBas AS DEC NO-UNDO.
  DEF VAR f-PreVta AS DEC NO-UNDO.
  DEF VAR f-Dsctos AS DEC NO-UNDO.
  DEF VAR y-Dsctos AS DEC NO-UNDO.
  DEF VAR SW-LOG1  AS LOGI NO-UNDO.
  DEF VAR x-StkAct AS DEC NO-UNDO.

  DEF VAR pSugerido AS DEC NO-UNDO.
  DEF VAR pEmpaque AS DEC NO-UNDO.

  DETALLES:
  FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK BY PEDI.NroItm: 
      /* **************************************************************************************** */
      /* VERIFICAMOS STOCK DISPONIBLE DE ALMACEN */
      /* **************************************************************************************** */
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = PEDI.AlmDes
          AND Almmmate.codmat = PEDI.CodMat
          NO-LOCK NO-ERROR .
      x-StkAct = 0.
      IF x-articulo-ICBPER <> Facdpedi.CodMat THEN DO:
          x-StkAct = Almmmate.StkAct.
          RUN gn/stock-comprometido-v2.p (Almmmate.CodMat, Almmmate.CodAlm, YES, OUTPUT s-StkComprometido).
          s-StkDis = x-StkAct - s-StkComprometido.
          IF s-StkDis <= 0 THEN DO:
              pMensajeFinal = pMensajeFinal + CHR(10) +
                  'El STOCK esta en CERO para el producto ' + PEDI.codmat + 
                  'en el almacén ' + PEDI.AlmDes + CHR(10).
              /* OJO: NO DESPACHAR */
              DELETE PEDI.      /* << OJO << */
              NEXT DETALLES.    /* << OJO << */
          END.
      END.

      /* **************************************************************************************** */
      f-Factor = PEDI.Factor.
      x-CanPed = PEDI.CanPed * f-Factor.
      IF s-StkDis < x-CanPed THEN DO:
          /* Ajustamos de acuerdo a los multiplos */
          PEDI.CanPed = ( s-StkDis - ( s-StkDis MODULO f-Factor ) ) / f-Factor.
          IF PEDI.CanPed <= 0 THEN DO:
              DELETE PEDI.
              NEXT DETALLES.
          END.
      END.
      /* EMPAQUE SUPERMERCADOS */
      FIND FIRST supmmatg WHERE supmmatg.codcia = FacCPedi.CodCia
          AND supmmatg.codcli = FacCPedi.CodCli
          AND supmmatg.codmat = PEDI.codmat 
          NO-LOCK NO-ERROR.
      f-CanPed = PEDI.CanPed * f-Factor.
      IF AVAILABLE supmmatg AND supmmatg.Libre_d01 <> 0 THEN DO:
          f-CanPed = (TRUNCATE((f-CanPed / supmmatg.Libre_d01),0) * supmmatg.Libre_d01).
      END.
      ELSE DO:    /* EMPAQUE OTROS */
          IF s-FlgEmpaque = YES THEN DO:
              RUN vtagn/p-cantidad-sugerida-pco.p (PEDI.CodMat, 
                                                   f-CanPed, 
                                                   OUTPUT pSugerido, 
                                                   OUTPUT pEmpaque).
              f-CanPed = pSugerido.
          END.
      END.
      PEDI.CanPed = ( f-CanPed - ( f-CanPed MODULO f-Factor ) ) / f-Factor.
      IF PEDI.CanPed <= 0 THEN DO:
          DELETE PEDI.
      END.
  END.
  /* RECALCULAMOS */
  FOR EACH PEDI:
      ASSIGN
          PEDI.ImpLin = ROUND ( PEDI.CanPed * PEDI.PreUni * 
                        ( 1 - PEDI.Por_Dsctos[1] / 100 ) *
                        ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
                        ( 1 - PEDI.Por_Dsctos[3] / 100 ), 2 ).
      IF PEDI.Por_Dsctos[1] = 0 AND PEDI.Por_Dsctos[2] = 0 AND PEDI.Por_Dsctos[3] = 0 
      THEN PEDI.ImpDto = 0.
      ELSE PEDI.ImpDto = PEDI.CanPed * PEDI.PreUni - PEDI.ImpLin.
      ASSIGN
          PEDI.ImpLin = ROUND(PEDI.ImpLin, 2)
          PEDI.ImpDto = ROUND(PEDI.ImpDto, 2).
      IF PEDI.AftIsc 
          THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
      IF PEDI.AftIgv 
          THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
      IF PEDI.CanPed <= 0 THEN DELETE PEDI.
  END.
  /* AHORA SÍ GRABAMOS EL PEDIDO */
  FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK BY PEDI.NroItm: 
      I-NPEDI = I-NPEDI + 1.
      CREATE Facdpedi.
      BUFFER-COPY PEDI 
          EXCEPT PEDI.TipVta    /* Campo con valor A, B, C o D */
          TO Facdpedi
          ASSIGN
              Facdpedi.CodCia = Faccpedi.CodCia
              Facdpedi.CodDiv = Faccpedi.CodDiv
              Facdpedi.coddoc = Faccpedi.coddoc
              Facdpedi.NroPed = Faccpedi.NroPed
              Facdpedi.FchPed = Faccpedi.FchPed
              Facdpedi.Hora   = Faccpedi.Hora 
              Facdpedi.FlgEst = Faccpedi.FlgEst
              Facdpedi.NroItm = I-NPEDI.
      /* Ic - 24May2019, se uso este campo para la eliminacion masiva de item */
        ASSIGN Facdpedi.aftisc = NO.
  END.
  /* verificamos que al menos exista 1 item grabado */
  FIND FIRST Facdpedi OF Faccpedi NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Facdpedi 
  THEN RETURN 'ADM-ERROR'.
  ELSE RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pedido D-Dialog 
PROCEDURE Genera-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Generamos el pedido del almacén seleccionado */
DEF VAR x-CodAlm AS CHAR NO-UNDO.

x-CodAlm = ENTRY(RADIO-SET-1, s-CodAlm).

/* Borramos todos los almacenes que no son */
FOR EACH PEDI WHERE PEDI.AlmDes <> x-CodAlm:
    DELETE PEDI.
END.
IF NOT CAN-FIND(FIRST PEDI) THEN DO:
    MESSAGE 'NO hay registros que procesar' SKIP 'Proceso Abortado'
        VIEW-AS ALERT-BOX WARNING.
    UNDO, RETURN 'ADM-ERROR'.
END.

pCodAlm = x-CodAlm.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales D-Dialog 
PROCEDURE Graba-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/graba-totales-cotizacion-cred.i}

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

    /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND FIRST t-FacTabla NO-LOCK NO-ERROR.
  IF AVAILABLE t-FacTabla THEN DO:
      DEF VAR k AS INT NO-UNDO.
      DO k = 1 TO NUM-ENTRIES(s-CodAlm):
          FIND Almacen WHERE Almacen.codcia = s-codcia
              AND Almacen.codalm = ENTRY(k,s-codalm)
              NO-LOCK.
          CASE k:
              WHEN 1 THEN t-FacTabla.Valor[1]:LABEL IN BROWSE {&BROWSE-NAME} = "Almacén " + Almacen.codalm + "!" + ENTRY(1,Almacen.Descripcion,'-') + "!" + STRING(t-FacTabla.FchEnt[1]).
              WHEN 2 THEN t-FacTabla.Valor[2]:LABEL IN BROWSE {&BROWSE-NAME} = "Almacén " + Almacen.codalm + "!" + ENTRY(1,Almacen.Descripcion,'-') + "!" + STRING(t-FacTabla.FchEnt[2]).
              WHEN 3 THEN t-FacTabla.Valor[3]:LABEL IN BROWSE {&BROWSE-NAME} = "Almacén " + Almacen.codalm + "!" + ENTRY(1,Almacen.Descripcion,'-') + "!" + STRING(t-FacTabla.FchEnt[3]).
              WHEN 4 THEN t-FacTabla.Valor[4]:LABEL IN BROWSE {&BROWSE-NAME} = "Almacén " + Almacen.codalm + "!" + ENTRY(1,Almacen.Descripcion,'-') + "!" + STRING(t-FacTabla.FchEnt[4]).
              WHEN 5 THEN t-FacTabla.Valor[5]:LABEL IN BROWSE {&BROWSE-NAME} = "Almacén " + Almacen.codalm + "!" + ENTRY(1,Almacen.Descripcion,'-') + "!" + STRING(t-FacTabla.FchEnt[5]).
          END CASE.
      END.
  END.
  RUN Totales.
  {&OPEN-QUERY-{&BROWSE-NAME}}


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
  {src/adm/template/snd-list.i "t-FacTabla"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Totales D-Dialog 
PROCEDURE Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN
    FILL-IN-1 = 0
    FILL-IN-2 = 0
    FILL-IN-3 = 0
    FILL-IN-4 = 0
    FILL-IN-5 = 0.
ASSIGN
    FILL-IN-Peso-1 = 0
    FILL-IN-Peso-2 = 0
    FILL-IN-Peso-3 = 0
    FILL-IN-Peso-4 = 0
    FILL-IN-Peso-5 = 0.
FOR EACH t-FacTabla:
    FILL-IN-1 = FILL-IN-1 + t-FacTabla.ImpLin[1].
    FILL-IN-2 = FILL-IN-2 + t-FacTabla.ImpLin[2].
    FILL-IN-3 = FILL-IN-3 + t-FacTabla.ImpLin[3].
    FILL-IN-4 = FILL-IN-4 + t-FacTabla.ImpLin[4].
    FILL-IN-5 = FILL-IN-5 + t-FacTabla.ImpLin[5].
    FILL-IN-Peso-1 = FILL-IN-Peso-1 + t-FacTabla.Peso[1].
    FILL-IN-Peso-2 = FILL-IN-Peso-2 + t-FacTabla.Peso[2].
    FILL-IN-Peso-3 = FILL-IN-Peso-3 + t-FacTabla.Peso[3].
    FILL-IN-Peso-4 = FILL-IN-Peso-4 + t-FacTabla.Peso[4].
    FILL-IN-Peso-5 = FILL-IN-Peso-5 + t-FacTabla.Peso[5].
END.
DISPLAY
    FILL-IN-1 
    FILL-IN-2 
    FILL-IN-3 
    FILL-IN-4 
    FILL-IN-5 
    FILL-IN-Peso-1 FILL-IN-Peso-2 FILL-IN-Peso-3 FILL-IN-Peso-4 FILL-IN-Peso-5
    WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

