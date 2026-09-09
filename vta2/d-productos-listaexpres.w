&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-listaexpressarticulos NO-UNDO LIKE listaexpressarticulos.



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
DEFINE INPUT PARAMETER pTipoLista AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pCodProdPremium AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pNomProdPremium AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pCodProdStandard AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pNomProdStandard AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pCantidad AS DEC NO-UNDO.


/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE tlistaexpressarticulos LIKE listaexpressarticulos.

DEFINE TEMP-TABLE tCategoria
    FIELD categoria AS CHAR FORMAT 'x(100)'
    INDEX idx01 categoria.

DEFINE TEMP-TABLE tsubCategoria
    FIELD subcategoria AS CHAR FORMAT 'x(100)'
    INDEX idx01 subcategoria.

DEFINE TEMP-TABLE tetapaescolar
    FIELD etapaescolar AS CHAR FORMAT 'x(100)'
    INDEX idx01 etapaescolar.

DEFINE VAR x-cantidad AS DEC.
DEFINE VAR x-items AS INT.
DEFINE VAR x-rowid AS ROWID.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-6

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-listaexpressarticulos

/* Definitions for BROWSE BROWSE-6                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-6 tt-listaexpressarticulos.campo-f[1] ~
tt-listaexpressarticulos.producto tt-listaexpressarticulos.codprodpremium ~
tt-listaexpressarticulos.nomprodpremium tt-listaexpressarticulos.campo-c[1] ~
tt-listaexpressarticulos.codprodstandard ~
tt-listaexpressarticulos.nomprodstandard ~
tt-listaexpressarticulos.campo-c[2] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-6 ~
tt-listaexpressarticulos.campo-f[1] 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-6 tt-listaexpressarticulos
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-6 tt-listaexpressarticulos
&Scoped-define QUERY-STRING-BROWSE-6 FOR EACH tt-listaexpressarticulos NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-6 OPEN QUERY BROWSE-6 FOR EACH tt-listaexpressarticulos NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-6 tt-listaexpressarticulos
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-6 tt-listaexpressarticulos


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-6}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-categoria COMBO-BOX-subcategoria ~
COMBO-BOX-etapaescolar CMB-filtro FILL-IN-filtro BUTTON-aplicafiltro ~
BROWSE-6 Btn_OK BUTTON-limpiafiltro Btn_Cancel RECT-1 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-categoria COMBO-BOX-subcategoria ~
COMBO-BOX-etapaescolar CMB-filtro FILL-IN-filtro 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Aceptar" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-aplicafiltro 
     LABEL "Aplicar busqueda" 
     SIZE 14.57 BY 1.12.

DEFINE BUTTON BUTTON-limpiafiltro 
     LABEL "Limpiar Filtros" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE CMB-filtro AS CHARACTER FORMAT "X(256)":U INITIAL "Nombres que contengan" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Nombres que inicien con","Nombres que contengan" 
     DROP-DOWN-LIST
     SIZE 20.72 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE COMBO-BOX-categoria AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 35.29 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-etapaescolar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 35.29 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-subcategoria AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 35.29 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-categoria AS CHARACTER FORMAT "X(256)":U INITIAL "CATEGORIA" 
     LABEL "" 
      VIEW-AS TEXT 
     SIZE 16 BY .62
     BGCOLOR 7 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-etapaescolar AS CHARACTER FORMAT "X(256)":U INITIAL "ETAPA ESCOLAR" 
      VIEW-AS TEXT 
     SIZE 16 BY .62
     BGCOLOR 7 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-filtro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.57 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-subcategoria AS CHARACTER FORMAT "X(256)":U INITIAL "SUBCATEGORIA" 
      VIEW-AS TEXT 
     SIZE 16 BY .62
     BGCOLOR 7 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77.72 BY 5.15.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-6 FOR 
      tt-listaexpressarticulos SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-6 D-Dialog _STRUCTURED
  QUERY BROWSE-6 NO-LOCK DISPLAY
      tt-listaexpressarticulos.campo-f[1] COLUMN-LABEL "Cantidad" FORMAT ">>>,>>9.99":U
            WIDTH 6.14
      tt-listaexpressarticulos.producto COLUMN-LABEL "Producto" FORMAT "x(80)":U
            WIDTH 32.86
      tt-listaexpressarticulos.codprodpremium COLUMN-LABEL "Cod.Prod.!Premium" FORMAT "x(8)":U
            WIDTH 7 COLUMN-BGCOLOR 11 COLUMN-FONT 6
      tt-listaexpressarticulos.nomprodpremium COLUMN-LABEL "Nombre Prod.!Premium" FORMAT "x(80)":U
            WIDTH 45.43 COLUMN-FONT 4
      tt-listaexpressarticulos.campo-c[1] COLUMN-LABEL "Marca Prod.!Premium" FORMAT "x(30)":U
            WIDTH 18.14 COLUMN-FONT 4
      tt-listaexpressarticulos.codprodstandard COLUMN-LABEL "Cod.Prod.!Standard" FORMAT "x(8)":U
            WIDTH 7.43 COLUMN-BGCOLOR 6 COLUMN-FONT 6
      tt-listaexpressarticulos.nomprodstandard COLUMN-LABEL "nombre Prod.!Standard" FORMAT "x(80)":U
            WIDTH 40.72 COLUMN-FONT 4
      tt-listaexpressarticulos.campo-c[2] COLUMN-LABEL "Marca Prod.!Standard" FORMAT "x(30)":U
            WIDTH 18.43 COLUMN-FONT 4
  ENABLE
      tt-listaexpressarticulos.campo-f[1]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 149.72 BY 11.35
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     COMBO-BOX-categoria AT ROW 1.62 COL 18.14 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     COMBO-BOX-subcategoria AT ROW 2.62 COL 18.14 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     COMBO-BOX-etapaescolar AT ROW 3.65 COL 18.14 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     CMB-filtro AT ROW 5.5 COL 3.43 NO-LABEL WIDGET-ID 22
     FILL-IN-filtro AT ROW 5.5 COL 24.43 NO-LABEL WIDGET-ID 20
     BUTTON-aplicafiltro AT ROW 5.23 COL 63 WIDGET-ID 26
     BROWSE-6 AT ROW 6.96 COL 2.29 WIDGET-ID 200
     Btn_OK AT ROW 5.62 COL 82
     BUTTON-limpiafiltro AT ROW 2.35 COL 63.29 WIDGET-ID 28
     Btn_Help AT ROW 2.62 COL 106
     Btn_Cancel AT ROW 5.58 COL 100
     FILL-IN-categoria AT ROW 1.77 COL 1.43 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-subcategoria AT ROW 2.77 COL 1.43 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     FILL-IN-etapaescolar AT ROW 3.81 COL 1.43 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     "Busqueda por producto" VIEW-AS TEXT
          SIZE 19.43 BY .73 AT ROW 4.73 COL 3.57 WIDGET-ID 24
          FGCOLOR 9 FONT 6
     "Ejm : cuad 80 azul (cuaderno de 80 hojas color azul)" VIEW-AS TEXT
          SIZE 36 BY .5 AT ROW 4.92 COL 25 WIDGET-ID 30
          FGCOLOR 4 
     RECT-1 AT ROW 1.42 COL 2.29 WIDGET-ID 16
     SPACE(73.12) SKIP(12.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Filtro de productos" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-listaexpressarticulos T "?" NO-UNDO INTEGRAL listaexpressarticulos
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
/* BROWSE-TAB BROWSE-6 BUTTON-aplicafiltro D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON Btn_Help IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       Btn_Help:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR COMBO-BOX CMB-filtro IN FRAME D-Dialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-categoria IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-etapaescolar IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-filtro IN FRAME D-Dialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-subcategoria IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-6
/* Query rebuild information for BROWSE BROWSE-6
     _TblList          = "Temp-Tables.tt-listaexpressarticulos"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-listaexpressarticulos.campo-f[1]
"tt-listaexpressarticulos.campo-f[1]" "Cantidad" ">>>,>>9.99" "decimal" ? ? ? ? ? ? yes ? no no "6.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-listaexpressarticulos.producto
"tt-listaexpressarticulos.producto" "Producto" "x(80)" "character" ? ? ? ? ? ? no ? no no "32.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-listaexpressarticulos.codprodpremium
"tt-listaexpressarticulos.codprodpremium" "Cod.Prod.!Premium" ? "character" 11 ? 6 ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-listaexpressarticulos.nomprodpremium
"tt-listaexpressarticulos.nomprodpremium" "Nombre Prod.!Premium" "x(80)" "character" ? ? 4 ? ? ? no ? no no "45.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-listaexpressarticulos.campo-c[1]
"tt-listaexpressarticulos.campo-c[1]" "Marca Prod.!Premium" "x(30)" "character" ? ? 4 ? ? ? no ? no no "18.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-listaexpressarticulos.codprodstandard
"tt-listaexpressarticulos.codprodstandard" "Cod.Prod.!Standard" ? "character" 6 ? 6 ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-listaexpressarticulos.nomprodstandard
"tt-listaexpressarticulos.nomprodstandard" "nombre Prod.!Standard" "x(80)" "character" ? ? 4 ? ? ? no ? no no "40.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-listaexpressarticulos.campo-c[2]
"tt-listaexpressarticulos.campo-c[2]" "Marca Prod.!Standard" "x(30)" "character" ? ? 4 ? ? ? no ? no no "18.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON END-ERROR OF FRAME D-Dialog /* Filtro de productos */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Filtro de productos */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  /*APPLY "END-ERROR":U TO SELF.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-6
&Scoped-define SELF-NAME BROWSE-6
&Scoped-define SELF-NAME tt-listaexpressarticulos.campo-f[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-listaexpressarticulos.campo-f[1] BROWSE-6 _BROWSE-COLUMN D-Dialog
ON ENTRY OF tt-listaexpressarticulos.campo-f[1] IN BROWSE BROWSE-6 /* Cantidad */
DO:
    IF x-cantidad > 0 THEN DO:
        APPLY "CHOOSE" TO Btn_OK IN FRAME {&FRAME-NAME}.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-listaexpressarticulos.campo-f[1] BROWSE-6 _BROWSE-COLUMN D-Dialog
ON LEAVE OF tt-listaexpressarticulos.campo-f[1] IN BROWSE BROWSE-6 /* Cantidad */
DO:

    x-cantidad = DECIMAL(SELF:SCREEN-VALUE IN BROWSE browse-3).

    x-rowid = ROWID(tt-listaexpressarticulos).

    IF x-items = 1 AND x-cantidad > 0 THEN DO:
        APPLY "TAB" TO BROWSE BROWSE-6.
        APPLY "CHOOSE" TO Btn_OK IN FRAME {&FRAME-NAME}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancelar */
DO:
  pCantidad = -99.
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
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
            btn_ok:AUTO-GO = NO.        /* del Boton OK */      

        /*FIND FIRST tt-listaexpressarticulos WHERE tt-listaexpressarticulos.campo-f[1] > 0 NO-LOCK NO-ERROR.*/
        FIND FIRST tt-listaexpressarticulos WHERE ROWID(tt-listaexpressarticulos) = x-rowid NO-LOCK NO-ERROR.        

        IF NOT AVAILABLE tt-listaexpressarticulos THEN DO:        
           MESSAGE "Ingrese cantidad. Por favor".
        END.
        ELSE DO:
            ASSIGN pCodProdPremium = tt-listaexpressarticulos.codprodpremium
            pNomProdPremium = tt-listaexpressarticulos.NomProdPremium
            pCodProdStandard = tt-listaexpressarticulos.CodProdStandard
            pNomProdStandard = tt-listaexpressarticulos.NomProdStandard
            pCantidad = tt-listaexpressarticulos.campo-f[1].            

            IF pCantidad <= 0 THEN pCantidad = x-cantidad.

            btn_ok:AUTO-GO = YES.
        END.        
END.
/*
DEFINE OUTPUT PARAMETER pCodProdPremium AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pNomProdPremium AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pCodProdStandard AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pNomProdStandard AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pCantidad AS DEC NO-UNDO.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-aplicafiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-aplicafiltro D-Dialog
ON CHOOSE OF BUTTON-aplicafiltro IN FRAME D-Dialog /* Aplicar busqueda */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN combo-box-categoria combo-box-subcategoria combo-box-etapaescolar fill-in-filtro cmb-filtro.
    END.

    RUN carga-data.

    APPLY "ENTRY" TO BROWSE browse-6.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-limpiafiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-limpiafiltro D-Dialog
ON CHOOSE OF BUTTON-limpiafiltro IN FRAME D-Dialog /* Limpiar Filtros */
DO:


    DO WITH FRAME {&FRAME-NAME}:

        combo-box-categoria:SCREEN-VALUE = 'Todos'.
        combo-box-subcategoria:SCREEN-VALUE = 'Todos'.
        combo-box-etapaescolar:SCREEN-VALUE = 'Todos'.
        cmb-filtro:SCREEN-VALUE = 'Nombres que contengan'.
        fill-in-filtro:SCREEN-VALUE = ''.

        ASSIGN combo-box-categoria combo-box-subcategoria combo-box-etapaescolar fill-in-filtro cmb-filtro.
    END.

  RUN carga-data.

  APPLY "ENTRY" TO fill-in-filtro IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-categoria
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-categoria D-Dialog
ON VALUE-CHANGED OF COMBO-BOX-categoria IN FRAME D-Dialog
DO:
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN {&self-name} combo-box-subcategoria combo-box-etapaescolar fill-in-filtro cmb-filtro.
    END.

  RUN carga-data.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-etapaescolar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-etapaescolar D-Dialog
ON VALUE-CHANGED OF COMBO-BOX-etapaescolar IN FRAME D-Dialog
DO:
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN {&self-name} combo-box-categoria combo-box-subcategoria fill-in-filtro cmb-filtro.
    END.
  
    RUN carga-data.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-subcategoria
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-subcategoria D-Dialog
ON VALUE-CHANGED OF COMBO-BOX-subcategoria IN FRAME D-Dialog
DO:
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN {&self-name} combo-box-categoria combo-box-etapaescolar fill-in-filtro cmb-filtro.
    END.
  
    RUN carga-data.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-filtro D-Dialog
ON LEAVE OF FILL-IN-filtro IN FRAME D-Dialog
DO:
    APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

ON 'RETURN':U OF tt-listaexpressarticulos.campo-f[1] IN BROWSE BROWSE-6 DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-data D-Dialog 
PROCEDURE carga-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-listaexpressarticulos.

DEFINE VAR x-x1 AS LOG INIT YES.
DEFINE VAR x-texto AS CHAR.

x-texto = fill-in-filtro.

DEFINE VAR x-palabras AS CHAR.
DEFINE VAR x-palabra AS CHAR.
DEFINE VAR x-conteo AS INT.

REPEAT x-conteo = 1 TO NUM-ENTRIES(x-texto," "):
    x-palabra = ENTRY(x-conteo,x-texto," ") + "*".
    IF TRUE <> (x-palabras > "") THEN DO:
        x-palabras = x-palabra.
    END.
    ELSE DO:
        x-palabras = x-palabras + " & " + x-palabra.
    END.    
END.
/*      & = AND
        ! = OR
  campo  CONTAINS "ski & (gog* ! pol*)"
*/

x-items = 0.

FOR EACH tlistaexpressarticulos WHERE x-palabras = "" OR 
            (tlistaexpressarticulos.producto CONTAINS x-palabras) NO-LOCK:
    IF combo-box-categoria <> 'Todos' THEN DO:
        IF tlistaexpressarticulos.categoria <> combo-box-categoria THEN NEXT.
    END.
    IF combo-box-subcategoria <> 'Todos' THEN DO:
        IF tlistaexpressarticulos.subcategoria <> combo-box-subcategoria THEN NEXT.
    END.
    IF combo-box-etapaescolar <> 'Todos' THEN DO:
        IF tlistaexpressarticulos.etapaescolar <> combo-box-etapaescolar THEN NEXT.
    END.
    /*
    IF NOT (TRUE <> (fill-in-filtro > "")) THEN DO:
        IF cmb-filtro <> "Todos" THEN DO:
            IF cmb-filtro = "Nombres que inicien con" THEN DO:
                IF NOT (tlistaexpressarticulos.producto BEGINS fill-in-filtro) THEN NEXT.
            END.
            IF cmb-filtro = "Nombres que contengan" THEN DO:
                /*IF NOT (tlistaexpressarticulos.producto MATCHES x-texto) THEN NEXT.*/
                IF INDEX(tlistaexpressarticulos.producto,x-texto) = 0 THEN NEXT.

                x-x1 = NO.
            END.
        END.
    END.
    */

    CREATE tt-listaexpressarticulos.
    BUFFER-COPY tlistaexpressarticulos TO tt-listaexpressarticulos.
    x-items = x-items + 1.
END.

{&open-query-browse-6}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-tablas D-Dialog 
PROCEDURE carga-tablas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tCategoria.
EMPTY TEMP-TABLE tSubCategoria.
EMPTY TEMP-TABLE tetapaescolar.
EMPTY TEMP-TABLE tlistaexpressarticulos.

EMPTY TEMP-TABLE tt-listaexpressarticulos.

FOR EACH listaexpressarticulos WHERE listaexpressarticulos.codcia = 1 NO-LOCK:

    CREATE tlistaexpressarticulos.
    BUFFER-COPY listaexpressarticulos TO tlistaexpressarticulos.

    FIND FIRST tCategoria WHERE tCategoria.Categoria = listaexpressarticulos.categoria EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE tCategoria THEN DO:
        CREATE tCategoria.
        ASSIGN tCategoria.categoria = listaexpressarticulos.categoria.
    END.
    FIND FIRST tSubCategoria WHERE tSubCategoria.SubCategoria = listaexpressarticulos.Subcategoria EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE tSubCategoria THEN DO:
        CREATE tSubCategoria.
        ASSIGN tSubCategoria.Subcategoria = listaexpressarticulos.Subcategoria.
    END.
    FIND FIRST tetapaescolar WHERE tetapaescolar.etapaescolar = listaexpressarticulos.etapaescolar EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE tetapaescolar THEN DO:
        CREATE tetapaescolar.
        ASSIGN tetapaescolar.etapaescolar = listaexpressarticulos.etapaescolar.
    END.

    CREATE tt-listaexpressarticulos.
    BUFFER-COPY tlistaexpressarticulos TO tt-listaexpressarticulos.

END.

DO WITH FRAME {&FRAME-NAME}:
    COMBO-BOX-categoria:DELETE(COMBO-BOX-categoria:LIST-ITEMS).
        COMBO-BOX-categoria:ADD-LAST("Todos").
        COMBO-BOX-categoria:SCREEN-VALUE = 'Todos'.
    COMBO-BOX-subcategoria:DELETE(COMBO-BOX-subcategoria:LIST-ITEMS).
        COMBO-BOX-subcategoria:ADD-LAST("Todos").
        COMBO-BOX-subcategoria:SCREEN-VALUE = 'Todos'.
    COMBO-BOX-etapaescolar:DELETE(COMBO-BOX-etapaescolar:LIST-ITEMS).
        COMBO-BOX-etapaescolar:ADD-LAST("Todos").
        COMBO-BOX-etapaescolar:SCREEN-VALUE = 'Todos'.

    FOR EACH tcategoria NO-LOCK:
        COMBO-BOX-categoria:ADD-LAST(tCategoria.Categoria).
    END.
    FOR EACH tsubcategoria NO-LOCK:
        COMBO-BOX-subcategoria:ADD-LAST(tsubCategoria.subCategoria).
    END.
    FOR EACH tetapaescolar NO-LOCK:
        COMBO-BOX-etapaescolar:ADD-LAST(tetapaescolar.etapaescolar).
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
  DISPLAY COMBO-BOX-categoria COMBO-BOX-subcategoria COMBO-BOX-etapaescolar 
          CMB-filtro FILL-IN-filtro 
      WITH FRAME D-Dialog.
  ENABLE COMBO-BOX-categoria COMBO-BOX-subcategoria COMBO-BOX-etapaescolar 
         CMB-filtro FILL-IN-filtro BUTTON-aplicafiltro BROWSE-6 Btn_OK 
         BUTTON-limpiafiltro Btn_Cancel RECT-1 
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN carga-tablas.

  {&open-query-browse-6}

  APPLY "ENTRY" TO fill-in-filtro IN FRAME {&FRAME-NAME}.

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
  {src/adm/template/snd-list.i "tt-listaexpressarticulos"}

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

