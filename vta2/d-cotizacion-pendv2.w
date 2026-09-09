&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
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
DEF OUTPUT PARAMETER pCodAlm AS CHAR.
DEF OUTPUT PARAMETER pNroCot AS CHAR.

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-CodCia AS INT.
DEF SHARED VAR s-CodDiv AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.

DEF VAR s-coddoc AS CHAR INIT "COT".
DEF VAR s-flgest AS CHAR INIT "P".

ASSIGN
    pCodAlm = ""
    pNroCot = "".

&SCOPED-DEFINE Condicion ( FacCPedi.CodCia = s-codcia ~
AND FacCPedi.CodDoc = s-coddoc ~
AND FacCPedi.CodDiv = s-coddiv ~
AND FacCPedi.FlgEst = s-flgest ~
AND (FILL-IN-CodCli = '' OR FacCPedi.CodCli = FILL-IN-CodCli) ~
AND (FILL-IN-NomCli = '' OR INDEX(FacCPedi.NomCli, FILL-IN-NomCli) > 0) ~
AND (txtOrdenCompra = '' OR Faccpedi.ordcmp BEGINS txtOrdenCompra) ~
)

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
&Scoped-define INTERNAL-TABLES FacCPedi

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 FacCPedi.CodDoc FacCPedi.NroPed ~
FacCPedi.FchPed FacCPedi.fchven FacCPedi.FchEnt FacCPedi.CodCli ~
FacCPedi.NomCli FacCPedi.ImpTot FacCPedi.FmaPgo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH FacCPedi ~
      WHERE {&Condicion} NO-LOCK ~
    BY FacCPedi.FchPed DESCENDING ~
       BY FacCPedi.NroPed DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH FacCPedi ~
      WHERE {&Condicion} NO-LOCK ~
    BY FacCPedi.FchPed DESCENDING ~
       BY FacCPedi.NroPed DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 FacCPedi


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-54 RECT-55 RECT-56 txtOrdenCompra ~
BUTTON-11 FILL-IN-CodCli FILL-IN-NomCli BROWSE-4 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX_CodAlm COMBO-BOX_CodAlm_010 ~
COMBO-BOX_CodAlm_011 COMBO-BOX_CodAlm_017 COMBO-BOX_CodAlm_Otras ~
txtOrdenCompra FILL-IN-CodCli FILL-IN-NomCli 

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

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "OK" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-11 
     LABEL "Aplicar Filtro" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX_CodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Despacho" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_CodAlm_010 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Despacho Caso A" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_CodAlm_011 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Despacho Caso B" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_CodAlm_017 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Despacho Caso C" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_CodAlm_Otras AS CHARACTER FORMAT "X(256)":U 
     LABEL "Despacho Caso D" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Filtrar por Código del cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Filtrar por Nombre del Cliente" 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE txtOrdenCompra AS CHARACTER FORMAT "X(15)":U 
     LABEL "Filtrar por O/C Sup.Mercados Peruanos" 
     VIEW-AS FILL-IN 
     SIZE 13.86 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-54
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 57 BY 4.31
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE RECT-55
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 66 BY 4.31
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE RECT-56
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 123 BY 2.42
     BGCOLOR 8 FGCOLOR 0 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 D-Dialog _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      FacCPedi.CodDoc COLUMN-LABEL "Doc" FORMAT "x(3)":U
      FacCPedi.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U WIDTH 9.14
      FacCPedi.FchPed COLUMN-LABEL "Fecha de!Emisión" FORMAT "99/99/9999":U
            WIDTH 10.43
      FacCPedi.fchven COLUMN-LABEL "Fecha de!Vencimiento" FORMAT "99/99/99":U
            WIDTH 11.43
      FacCPedi.FchEnt COLUMN-LABEL "Fecha de!Entrega" FORMAT "99/99/9999":U
            WIDTH 11.43
      FacCPedi.CodCli COLUMN-LABEL "Cliente" FORMAT "x(11)":U WIDTH 10.43
      FacCPedi.NomCli FORMAT "x(50)":U
      FacCPedi.ImpTot FORMAT "->>,>>>,>>9.99":U WIDTH 12.86
      FacCPedi.FmaPgo COLUMN-LABEL "Condicion!de Venta" FORMAT "X(8)":U
            WIDTH 9
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 123 BY 15.08
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     COMBO-BOX_CodAlm AT ROW 2.08 COL 12 COLON-ALIGNED WIDGET-ID 2
     COMBO-BOX_CodAlm_010 AT ROW 2.08 COL 79 COLON-ALIGNED WIDGET-ID 4
     COMBO-BOX_CodAlm_011 AT ROW 2.88 COL 79 COLON-ALIGNED WIDGET-ID 6
     COMBO-BOX_CodAlm_017 AT ROW 3.69 COL 79 COLON-ALIGNED WIDGET-ID 8
     COMBO-BOX_CodAlm_Otras AT ROW 4.5 COL 79 COLON-ALIGNED WIDGET-ID 10
     txtOrdenCompra AT ROW 6.12 COL 66.14 COLON-ALIGNED WIDGET-ID 24
     BUTTON-11 AT ROW 6.12 COL 83 WIDGET-ID 28
     FILL-IN-CodCli AT ROW 6.19 COL 26 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-NomCli AT ROW 7 COL 26 COLON-ALIGNED WIDGET-ID 22
     BROWSE-4 AT ROW 8.27 COL 2 WIDGET-ID 200
     Btn_OK AT ROW 23.62 COL 2
     Btn_Cancel AT ROW 23.62 COL 17
     "Venta Normal" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 1.27 COL 3 WIDGET-ID 12
          BGCOLOR 9 FGCOLOR 15 
     "Condición de Venta Unica" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 1.27 COL 61 WIDGET-ID 14
          BGCOLOR 9 FGCOLOR 15 
     RECT-54 AT ROW 1.54 COL 2 WIDGET-ID 16
     RECT-55 AT ROW 1.54 COL 59 WIDGET-ID 18
     RECT-56 AT ROW 5.85 COL 2 WIDGET-ID 26
     SPACE(1.13) SKIP(17.37)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "SELECCIONE LA COTIZACION Y EL ALMACEN DE DESPACHO"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
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
/* BROWSE-TAB BROWSE-4 FILL-IN-NomCli D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX COMBO-BOX_CodAlm IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX_CodAlm_010 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX_CodAlm_011 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX_CodAlm_017 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX_CodAlm_Otras IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "INTEGRAL.FacCPedi"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "INTEGRAL.FacCPedi.FchPed|no,INTEGRAL.FacCPedi.NroPed|no"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > INTEGRAL.FacCPedi.CodDoc
"FacCPedi.CodDoc" "Doc" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Fecha de!Emisión" ? "date" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.fchven
"FacCPedi.fchven" "Fecha de!Vencimiento" ? "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacCPedi.FchEnt
"FacCPedi.FchEnt" "Fecha de!Entrega" ? "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacCPedi.CodCli
"FacCPedi.CodCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = INTEGRAL.FacCPedi.NomCli
     _FldNameList[8]   > INTEGRAL.FacCPedi.ImpTot
"FacCPedi.ImpTot" ? ? "decimal" ? ? ? ? ? ? no ? no no "12.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.FacCPedi.FmaPgo
"FacCPedi.FmaPgo" "Condicion!de Venta" ? "character" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* SELECCIONE LA COTIZACION Y EL ALMACEN DE DESPACHO */
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
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
    ASSIGN
        COMBO-BOX_CodAlm 
        COMBO-BOX_CodAlm_010 
        COMBO-BOX_CodAlm_011 
        COMBO-BOX_CodAlm_017 
        COMBO-BOX_CodAlm_Otras
        .
    /* Hay dos casos:
        Cotizaciones Ferias 
        Las otras cotizaciones
        */
    FIND GN-DIVI WHERE GN-DIVI.CodCia = FacCpedi.CodCia AND GN-DIVI.CodDiv = FacCPedi.Libre_c01 NO-LOCK.    /* Lista de Precios */
    /* RHC 05/10/17 Consistencia */
    /* Ic - 27Oct2017, se Cambio por la rutina
    IF GN-DIVI.CanalVenta = "FER" AND FacCPedi.Libre_c02 <> "PROCESADO" THEN DO:
        MESSAGE 'COTIZACION aun no ha sido programada por ABASTECIMIENTOS' SKIP
            'Proceso Abortado' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    */

    DEFINE VAR x-chequeado AS LOG.

    RUN chequeado-x-abastecimiento(INPUT Faccpedi.NroPed, OUTPUT x-chequeado).

    IF x-chequeado = NO THEN DO:
        MESSAGE 'COTIZACION aun no ha sido programada por ABASTECIMIENTOS' SKIP
            'Proceso Abortado' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.

    CASE TRUE:
        WHEN GN-DIVI.CanalVenta = "FER" AND NUM-ENTRIES(FacCPedi.LugEnt2) = 4 THEN
            pCodAlm = ENTRY(1, COMBO-BOX_CodAlm_010, " - ") + ',' +
                        ENTRY(1, COMBO-BOX_CodAlm_011, " - ") + ',' +
                        ENTRY(1, COMBO-BOX_CodAlm_017, " - ") + ',' +
                        ENTRY(1, COMBO-BOX_CodAlm_Otras, " - ").
        OTHERWISE pCodAlm = ENTRY(1, COMBO-BOX_CodAlm, " - ").
    END CASE.
    ASSIGN
        pNroCot = Faccpedi.NroPed.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-11 D-Dialog
ON CHOOSE OF BUTTON-11 IN FRAME D-Dialog /* Aplicar Filtro */
DO:
    ASSIGN
        FILL-IN-CodCli FILL-IN-NomCli txtOrdenCompra.
    {&OPEN-QUERY-{&BROWSE-NAME}}
    APPLY 'VALUE-CHANGED' TO {&browse-name}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chequeado-x-abastecimiento D-Dialog 
PROCEDURE chequeado-x-abastecimiento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCotizacion AS CHAR.
DEFINE OUTPUT PARAMETER pRet AS LOG.

DEFINE VAR lDivisiones AS CHAR.
DEFINE VAR lFechaControl AS DATE.

DEFINE BUFFER b-faccpedi FOR faccpedi.

/* Ic - 11Ene2017, solo para expos de LIMA segun MAcchiu */
FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND
                            b-faccpedi.coddoc = 'COT' AND 
                            b-faccpedi.nroped = pCotizacion
                            NO-LOCK NO-ERROR.
IF AVAILABLE b-faccpedi THEN DO:
    lDivisiones = "20015,00015,10015,50015".
    IF LOOKUP(b-faccpedi.libre_c01,lDivisiones) = 0 THEN DO:
        /* La cotizacion no es PREVENTA/EXPO */
        pRet = YES.
        RETURN .
    END.
END.

/* Ic - Que usuarios no validar fecha de entrega */
DEFINE VAR lUsrFchEnt AS CHAR.
DEFINE VAR lValFecEntrega AS CHAR.

DEFINE BUFFER r-factabla FOR factabla.

lUsrFchEnt = "".
lValFecEntrega = ''.
FIND FIRST r-factabla WHERE r-factabla.codcia = s-codcia AND 
                           r-factabla.tabla = 'VALIDA' AND 
                           r-factabla.codigo = 'FCHENT' NO-LOCK NO-ERROR.
IF AVAILABLE r-factabla THEN DO:
   lUsrFchEnt      = r-factabla.campo-c[1].  /* Usuarios Exceptuados de la Validacion */
   lValFecEntrega  = r-factabla.campo-c[2].  /* Valida Si o NO */
END.

RELEASE r-factabla.

IF lValFecEntrega = 'NO' OR LOOKUP(s-user-id,lusrFchEnt) > 0 THEN DO:
   /* 
       No requiere validacion la fecha de entrega ò
       El usuario esta inscrito para no validar la fecha de entrega
   */
   pRet = YES.
   RETURN .
END.

DEFINE BUFFER b-vtatabla FOR vtatabla.
DEFINE BUFFER z-gn-divi FOR gn-divi.

pRet = YES.

/* Ubicar la fecha de control de la programacion de LUCY */
FIND FIRST b-vtatabla WHERE b-vtatabla.codcia = s-codcia AND 
                           b-vtatabla.tabla = 'DSTRB' AND 
                           b-vtatabla.llave_c1 = '2016' NO-LOCK NO-ERROR.
IF AVAILABLE b-vtatabla THEN DO:
    lFechaControl = b-vtatabla.rango_fecha[2].
    /* Ubicar la Cotizacion */
    FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND
                                b-faccpedi.coddoc = 'COT' AND 
                                b-faccpedi.nroped = pCotizacion
                                NO-LOCK NO-ERROR.
    IF AVAILABLE b-faccpedi THEN DO:
        /* Preguntar si la Cotizacion es de PREVENTA segun su lista de precio */
        IF b-faccpedi.libre_c01 <> ? THEN DO:
            FIND FIRST z-gn-divi WHERE z-gn-divi.coddiv = b-faccpedi.libre_c01 NO-LOCK NO-ERROR.
            IF AVAILABLE z-gn-divi THEN DO:
                /* Si es FERIA */
                IF z-gn-divi.canalventa = 'FER' THEN DO:
                    IF b-faccpedi.libre_c02 <> "PROCESADO" THEN DO:
                        IF b-faccpedi.fchent > lFechaControl THEN pRet = NO.
                    END.                    
                END.
            END.
        END.
    END.
END.

RELEASE b-vtatabla.
RELEASE b-faccpedi.
RELEASE z-gn-divi.


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
  DISPLAY COMBO-BOX_CodAlm COMBO-BOX_CodAlm_010 COMBO-BOX_CodAlm_011 
          COMBO-BOX_CodAlm_017 COMBO-BOX_CodAlm_Otras txtOrdenCompra 
          FILL-IN-CodCli FILL-IN-NomCli 
      WITH FRAME D-Dialog.
  ENABLE RECT-54 RECT-55 RECT-56 txtOrdenCompra BUTTON-11 FILL-IN-CodCli 
         FILL-IN-NomCli BROWSE-4 Btn_OK Btn_Cancel 
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
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX_CodAlm:DELIMITER = '|'.
      COMBO-BOX_CodAlm_010:DELIMITER = '|'.
      COMBO-BOX_CodAlm_011:DELIMITER = '|'.
      COMBO-BOX_CodAlm_017:DELIMITER = '|'.
      COMBO-BOX_CodAlm_Otras:DELIMITER = '|'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  APPLY 'VALUE-CHANGED':U TO {&BROWSE-NAME}.

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
  {src/adm/template/snd-list.i "FacCPedi"}

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

