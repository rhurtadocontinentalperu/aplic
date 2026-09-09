&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE TEMP-TABLE BONIFICACION LIKE FacDPedi.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE TEMP-TABLE ITEM-2 LIKE FacDPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE TEMP-TABLE RESUMEN NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE RESUMEN-2 NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE T-CDOCU NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE T-CLIE NO-UNDO LIKE gn-clie.
DEFINE TEMP-TABLE T-DDOCU NO-UNDO LIKE CcbDDocu.



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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.

DEF TEMP-TABLE DETALLE
    FIELD CodCli AS CHAR FORMAT 'x(11)' LABEL 'CLIENTE'
    FIELD NomCli AS CHAR FORMAT 'x(60)' LABEL 'NOMBRE DEL CLIENTE'
    FIELD CodMat AS CHAR FORMAT 'x(6)' LABEL 'ARTICULO'
    FIELD DesMat AS CHAR FORMAT 'x(60)' LABEL 'DESCRIPCION DE LA BONIFICACION'
    FIELD Cantidad AS DEC FORMAT '>>>,>>>,>>9.99' LABEL 'CALCULADO'
    FIELD Realizado AS DEC FORMAT '>>>,>>>,>>9.99' LABEL 'REALIZADO'
    FIELD Unidad AS CHAR FORMAT 'x(10)' LABEL 'UNIDAD'
    FIELD NroProm AS CHAR FORMAT 'x(20)' LABEL 'NUMERO DE PROMOCION'
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-Bonificaciones

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES RESUMEN T-CDOCU ITEM Almmmatg

/* Definitions for BROWSE BROWSE-Bonificaciones                         */
&Scoped-define FIELDS-IN-QUERY-BROWSE-Bonificaciones RESUMEN.Campo-C[30] ~
RESUMEN.Campo-C[1] RESUMEN.Campo-C[2] RESUMEN.Campo-C[3] RESUMEN.Campo-F[1] ~
RESUMEN.Campo-F[2] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-Bonificaciones 
&Scoped-define QUERY-STRING-BROWSE-Bonificaciones FOR EACH RESUMEN NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-Bonificaciones OPEN QUERY BROWSE-Bonificaciones FOR EACH RESUMEN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-Bonificaciones RESUMEN
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-Bonificaciones RESUMEN


/* Definitions for BROWSE BROWSE-Comprobantes                           */
&Scoped-define FIELDS-IN-QUERY-BROWSE-Comprobantes T-CDOCU.CodDoc ~
T-CDOCU.NroDoc T-CDOCU.FchDoc T-CDOCU.CodCli T-CDOCU.NomCli T-CDOCU.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-Comprobantes 
&Scoped-define QUERY-STRING-BROWSE-Comprobantes FOR EACH T-CDOCU NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-Comprobantes OPEN QUERY BROWSE-Comprobantes FOR EACH T-CDOCU NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-Comprobantes T-CDOCU
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-Comprobantes T-CDOCU


/* Definitions for BROWSE BROWSE-Resumen                                */
&Scoped-define FIELDS-IN-QUERY-BROWSE-Resumen ITEM.codmat Almmmatg.DesMat ~
ITEM.CanPed ITEM.UndVta 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-Resumen 
&Scoped-define QUERY-STRING-BROWSE-Resumen FOR EACH ITEM NO-LOCK, ~
      FIRST Almmmatg OF ITEM NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-Resumen OPEN QUERY BROWSE-Resumen FOR EACH ITEM NO-LOCK, ~
      FIRST Almmmatg OF ITEM NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-Resumen ITEM Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-Resumen ITEM
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-Resumen Almmmatg


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-Bonificaciones}~
    ~{&OPEN-QUERY-BROWSE-Comprobantes}~
    ~{&OPEN-QUERY-BROWSE-Resumen}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 COMBO-BOX-Division BUTTON-Texto ~
COMBO-BOX-ListaPrecios BUTTON-Cliente FILL-IN-CodCli BUTTON-Procesar ~
FILL-IN-Desde FILL-IN-Hasta BROWSE-Comprobantes BROWSE-Resumen ~
BROWSE-Bonificaciones 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Division COMBO-BOX-ListaPrecios ~
FILL-IN-CodCli FILL-IN-NomCli FILL-IN-Desde FILL-IN-Hasta FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Cliente 
     IMAGE-UP FILE "img/find.bmp":U
     LABEL "" 
     SIZE 4 BY 1.12 TOOLTIP "Buscar Cliente".

DEFINE BUTTON BUTTON-Procesar 
     LABEL "PROCESAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Texto 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "Button 1" 
     SIZE 7 BY 1.62 TOOLTIP "Exportar a TEXTO".

DEFINE VARIABLE COMBO-BOX-Division AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 20
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-ListaPrecios AS CHARACTER FORMAT "X(256)":U 
     LABEL "Lista de Precios" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 20
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Comprobantes Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 107 BY 4.58.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-Bonificaciones FOR 
      RESUMEN SCROLLING.

DEFINE QUERY BROWSE-Comprobantes FOR 
      T-CDOCU SCROLLING.

DEFINE QUERY BROWSE-Resumen FOR 
      ITEM, 
      Almmmatg
    FIELDS(Almmmatg.DesMat) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-Bonificaciones
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-Bonificaciones W-Win _STRUCTURED
  QUERY BROWSE-Bonificaciones NO-LOCK DISPLAY
      RESUMEN.Campo-C[30] COLUMN-LABEL "Promocion" FORMAT "X(15)":U
      RESUMEN.Campo-C[1] COLUMN-LABEL "Codigo" FORMAT "X(8)":U
      RESUMEN.Campo-C[2] COLUMN-LABEL "Descripción" FORMAT "X(60)":U
            WIDTH 53.57
      RESUMEN.Campo-C[3] COLUMN-LABEL "Unidad" FORMAT "X(8)":U
      RESUMEN.Campo-F[1] COLUMN-LABEL "Bonificación!Calculada" FORMAT "->>>,>>>,>>9.99":U
      RESUMEN.Campo-F[2] COLUMN-LABEL "Bonificación!Realizada" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 9.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 107 BY 6.73
         FONT 4
         TITLE "BONIFICACIONES" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-Comprobantes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-Comprobantes W-Win _STRUCTURED
  QUERY BROWSE-Comprobantes NO-LOCK DISPLAY
      T-CDOCU.CodDoc FORMAT "x(3)":U
      T-CDOCU.NroDoc FORMAT "X(12)":U WIDTH 10.14
      T-CDOCU.FchDoc FORMAT "99/99/9999":U
      T-CDOCU.CodCli FORMAT "x(11)":U WIDTH 11.14
      T-CDOCU.NomCli FORMAT "x(60)":U WIDTH 52.43
      T-CDOCU.ImpTot FORMAT "->>,>>>,>>9.99":U WIDTH 14.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 107 BY 5.65
         FONT 4
         TITLE "COMPROBANTES" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-Resumen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-Resumen W-Win _STRUCTURED
  QUERY BROWSE-Resumen NO-LOCK DISPLAY
      ITEM.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U WIDTH 7.43
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 78.43
      ITEM.CanPed FORMAT "->,>>>,>>9.99":U
      ITEM.UndVta COLUMN-LABEL "Unidad" FORMAT "x(8)":U WIDTH 5.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 107 BY 7.54
         FONT 4
         TITLE "RESUMEN DE PRODUCTOS" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Division AT ROW 1.54 COL 19 COLON-ALIGNED WIDGET-ID 22
     BUTTON-Texto AT ROW 1.54 COL 101 WIDGET-ID 26
     COMBO-BOX-ListaPrecios AT ROW 2.62 COL 19 COLON-ALIGNED WIDGET-ID 2
     BUTTON-Cliente AT ROW 3.42 COL 11 WIDGET-ID 6
     FILL-IN-CodCli AT ROW 3.69 COL 19 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-NomCli AT ROW 3.69 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     BUTTON-Procesar AT ROW 4.5 COL 50 WIDGET-ID 16
     FILL-IN-Desde AT ROW 4.77 COL 19 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-Hasta AT ROW 4.77 COL 35 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-Mensaje AT ROW 4.77 COL 63 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     BROWSE-Comprobantes AT ROW 5.85 COL 2 WIDGET-ID 200
     BROWSE-Resumen AT ROW 11.77 COL 2 WIDGET-ID 400
     BROWSE-Bonificaciones AT ROW 19.58 COL 2 WIDGET-ID 300
     "Filtros" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 1 COL 3 WIDGET-ID 20
          BGCOLOR 9 FGCOLOR 15 
     RECT-2 AT ROW 1.27 COL 2 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 110.72 BY 25.85
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: BONIFICACION T "?" ? INTEGRAL FacDPedi
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
      TABLE: ITEM-2 T "?" ? INTEGRAL FacDPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: RESUMEN T "?" NO-UNDO INTEGRAL w-report
      TABLE: RESUMEN-2 T "?" NO-UNDO INTEGRAL w-report
      TABLE: T-CDOCU T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: T-CLIE T "?" NO-UNDO INTEGRAL gn-clie
      TABLE: T-DDOCU T "?" NO-UNDO INTEGRAL CcbDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 25.85
         WIDTH              = 110.72
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 144.29
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 144.29
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-Comprobantes FILL-IN-Mensaje F-Main */
/* BROWSE-TAB BROWSE-Resumen BROWSE-Comprobantes F-Main */
/* BROWSE-TAB BROWSE-Bonificaciones BROWSE-Resumen F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-Bonificaciones
/* Query rebuild information for BROWSE BROWSE-Bonificaciones
     _TblList          = "Temp-Tables.RESUMEN"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.RESUMEN.Campo-C[30]
"RESUMEN.Campo-C[30]" "Promocion" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.RESUMEN.Campo-C[1]
"RESUMEN.Campo-C[1]" "Codigo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.RESUMEN.Campo-C[2]
"RESUMEN.Campo-C[2]" "Descripción" "X(60)" "character" ? ? ? ? ? ? no ? no no "53.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.RESUMEN.Campo-C[3]
"RESUMEN.Campo-C[3]" "Unidad" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.RESUMEN.Campo-F[1]
"RESUMEN.Campo-F[1]" "Bonificación!Calculada" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.RESUMEN.Campo-F[2]
"RESUMEN.Campo-F[2]" "Bonificación!Realizada" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-Bonificaciones */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-Comprobantes
/* Query rebuild information for BROWSE BROWSE-Comprobantes
     _TblList          = "Temp-Tables.T-CDOCU"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.T-CDOCU.CodDoc
     _FldNameList[2]   > Temp-Tables.T-CDOCU.NroDoc
"T-CDOCU.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.T-CDOCU.FchDoc
     _FldNameList[4]   > Temp-Tables.T-CDOCU.CodCli
"T-CDOCU.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-CDOCU.NomCli
"T-CDOCU.NomCli" ? "x(60)" "character" ? ? ? ? ? ? no ? no no "52.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-CDOCU.ImpTot
"T-CDOCU.ImpTot" ? ? "decimal" ? ? ? ? ? ? no ? no no "14.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-Comprobantes */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-Resumen
/* Query rebuild information for BROWSE BROWSE-Resumen
     _TblList          = "Temp-Tables.ITEM,INTEGRAL.Almmmatg OF Temp-Tables.ITEM"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED"
     _FldNameList[1]   > Temp-Tables.ITEM.codmat
"Temp-Tables.ITEM.codmat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"INTEGRAL.Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "78.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ITEM.CanPed
"Temp-Tables.ITEM.CanPed" ? "->,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ITEM.UndVta
"Temp-Tables.ITEM.UndVta" "Unidad" ? "character" ? ? ? ? ? ? no ? no no "5.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-Resumen */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Cliente W-Win
ON CHOOSE OF BUTTON-Cliente IN FRAME F-Main
DO:
  ASSIGN
      input-var-1 = ''
      input-var-2 = ''
      input-var-3 = ''
      output-var-1 = ?.
  RUN lkup/c-cliente-activo ('SELECCIONE EL CLIENTE').
  IF output-var-1 <> ? THEN DO:
      FILL-IN-CodCli:SCREEN-VALUE = output-var-2.
      FILL-IN-NomCli:SCREEN-VALUE = output-var-3.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Procesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Procesar W-Win
ON CHOOSE OF BUTTON-Procesar IN FRAME F-Main /* PROCESAR */
DO:
  MESSAGE 'Confirmar el inicio del proceso' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  ASSIGN COMBO-BOX-Division COMBO-BOX-ListaPrecios FILL-IN-CodCli FILL-IN-Desde FILL-IN-Hasta.
  IF TRUE <> (FILL-IN-CodCli > '') THEN DO:
      MESSAGE 'Se van a procesar TODOS los clientes' SKIP
          'Confirmar el inicio del proceso' VIEW-AS ALERT-BOX QUESTION
          BUTTONS YES-NO UPDATE rpta2 AS LOG.
      IF rpta2 = NO THEN RETURN NO-APPLY.
  END.
  RUN Proceso-Principal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Texto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Texto W-Win
ON CHOOSE OF BUTTON-Texto IN FRAME F-Main /* Button 1 */
DO:
    DEF VAR pOptions AS CHAR NO-UNDO.
    DEF VAR pArchivo AS CHAR NO-UNDO.

    ASSIGN
        pOptions = "".
    RUN lib/tt-file-to-text-01 (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE('GENERAL').

    EMPTY TEMP-TABLE DETALLE.
    FOR EACH T-CLIE NO-LOCK,
        EACH RESUMEN NO-LOCK WHERE RESUMEN.Llave-C = T-CLIE.CodCli:
        CREATE DETALLE.
        ASSIGN
            DETALLE.CodCli = T-CLIE.CodCli
            DETALLE.NomCli = T-CLIE.NomCli
            DETALLE.CodMat = RESUMEN.Campo-C[1] 
            DETALLE.DesMat = RESUMEN.Campo-C[2] 
            DETALLE.Cantidad = RESUMEN.Campo-F[1]
            DETALLE.Realizado = RESUMEN.Campo-F[2]
            DETALLE.Unidad = RESUMEN.Campo-C[3]
            DETALLE.NroPro = RESUMEN.Campo-C[30]
            .
    END.

    SESSION:SET-WAIT-STATE('').

    FIND FIRST DETALLE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE DETALLE THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.

    DEF VAR cArchivo AS CHAR NO-UNDO.
    /* El archivo se va a generar en un archivo temporal de trabajo antes 
    de enviarlo a su directorio destino */
    cArchivo = LC(pArchivo).
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN lib/tt-filev2 (TEMP-TABLE DETALLE:HANDLE, cArchivo, pOptions).
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli W-Win
ON LEAVE OF FILL-IN-CodCli IN FRAME F-Main /* Cliente */
DO:
  IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND
      gn-clie.codcli = SELF:SCREEN-VALUE AND
      gn-clie.flgsit = "A" NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:
      MESSAGE 'Debe ingresar un cliente válido' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
   FILL-IN-NomCli:SCREEN-VALUE = gn-clie.nomcli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-Bonificaciones
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Bonificaciones W-Win 
PROCEDURE Carga-Bonificaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* BONIFICACIONES */
DEF VAR pMensaje AS CHAR NO-UNDO.
RUN vtagn/p-promocion-general (INPUT COMBO-BOX-ListaPrecios,
                               INPUT "&",       /* El '&' indica solo bonificaciones */
                               INPUT "",
                               INPUT TABLE ITEM,
                               OUTPUT TABLE BONIFICACION,
                               OUTPUT pMensaje).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Comprobantes W-Win 
PROCEDURE Carga-Comprobantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Factor AS INT NO-UNDO.

/* FAC y BOL */
x-Factor = 1.
FOR EACH GN-DIVI NO-LOCK WHERE GN-DIVI.CodCia = s-codcia AND
        GN-DIVI.CodDiv = COMBO-BOX-Division,
    EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia AND
        Ccbcdocu.DivOri = GN-DIVI.CodDiv AND
        ( TRUE <> (FILL-IN-CodCli > '') OR Ccbcdocu.codcli = FILL-IN-CodCli ) AND
        Ccbcdocu.flgest <> 'A' AND
        Ccbcdocu.fchdoc >= FILL-IN-Desde AND 
        Ccbcdocu.fchdoc <= FILL-IN-Hasta:
    /* Filtramos los comprobantes */
    IF LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL') = 0 THEN NEXT.
    IF LOOKUP(Ccbcdocu.fmapgo, '899,900') > 0 THEN NEXT.
    /* Cargamos informacion */
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "COMPROBANTE: " +
        Ccbcdocu.coddoc + " " + Ccbcdocu.nrodoc.
    CREATE T-CDOCU.
    BUFFER-COPY Ccbcdocu TO T-CDOCU.
    FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
        CREATE T-DDOCU.
        BUFFER-COPY Ccbddocu TO T-DDOCU.
        ASSIGN
            T-DDOCU.candes = T-DDOCU.candes * x-Factor.
    END.
END.
/* N/C */
x-Factor = -1.
FOR EACH GN-DIVI NO-LOCK WHERE GN-DIVI.CodCia = s-codcia AND
        GN-DIVI.CodDiv = COMBO-BOX-Division,
    EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia AND
        Ccbcdocu.DivOri = GN-DIVI.CodDiv AND
        Ccbcdocu.coddoc = "N/C" AND
        ( TRUE <> (FILL-IN-CodCli > '') OR Ccbcdocu.codcli = FILL-IN-CodCli ) AND
        Ccbcdocu.flgest <> 'A' AND
        Ccbcdocu.fchdoc >= FILL-IN-Desde AND 
        Ccbcdocu.fchdoc <= FILL-IN-Hasta,
    FIRST B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = Ccbcdocu.codcia AND
        B-CDOCU.coddoc = Ccbcdocu.codref AND
        B-CDOCU.nrodoc = Ccbcdocu.nroref:
    /* Filtramos los comprobantes */
    IF Ccbcdocu.cndcre <> "D" THEN NEXT.
    IF LOOKUP(B-CDOCU.fmapgo, '899,900') > 0 THEN NEXT.
    /* Cargamos informacion */
    CREATE T-CDOCU.
    BUFFER-COPY Ccbcdocu TO T-CDOCU.
    ASSIGN
        T-CDOCU.codped = B-CDOCU.codped
        T-CDOCU.nroped = B-CDOCU.nroped.
    FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
        CREATE T-DDOCU.
        BUFFER-COPY Ccbddocu TO T-DDOCU.
        ASSIGN
            T-DDOCU.candes = T-DDOCU.candes * x-Factor.
    END.
END.
/* Borramos lo que esta fuera de lista */
FOR EACH T-CDOCU EXCLUSIVE-LOCK,
    FIRST PEDIDO NO-LOCK WHERE PEDIDO.codcia = s-codcia AND
    PEDIDO.coddoc = T-CDOCU.codped AND
    PEDIDO.nroped = T-CDOCU.nroped,
    FIRST COTIZACION NO-LOCK WHERE COTIZACION.codcia = s-codcia AND
    COTIZACION.coddoc = PEDIDO.codref AND
    COTIZACION.nroped = PEDIDO.nroref:
    IF COTIZACION.lista_de_precios <> COMBO-BOX-ListaPrecios THEN DELETE T-CDOCU.
END.

FOR EACH T-CDOCU NO-LOCK:
    IF NOT CAN-FIND(FIRST T-CLIE WHERE T-CLIE.codcli = T-CDOCU.codcli NO-LOCK)
        THEN DO:
        CREATE T-CLIE.
        ASSIGN
            T-CLIE.codcia = cl-codcia 
            T-CLIE.codcli = T-CDOCU.codcli
            T-CLIE.nomcli = T-CDOCU.nomcli.
    END.
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

/* Resumimos en uno solo */
FOR EACH BONIFICACION NO-LOCK, FIRST Almmmatg OF BONIFICACION NO-LOCK:
        CREATE RESUMEN.
        ASSIGN
            RESUMEN.Llave-I = BONIFICACION.CodCia
            RESUMEN.Campo-C[30] = BONIFICACION.NroPed
            RESUMEN.Campo-C[1] = BONIFICACION.CodMat
            RESUMEN.Campo-C[2] = BONIFICACION.DesMat
            RESUMEN.Campo-C[3] = BONIFICACION.UndVta.
    ASSIGN
        RESUMEN.Campo-F[1] = RESUMEN.Campo-F[1] + BONIFICACION.CanPed.
END.

END PROCEDURE.

/*
FOR EACH BONIFICACION NO-LOCK, FIRST Almmmatg OF BONIFICACION NO-LOCK:
    FIND FIRST RESUMEN WHERE RESUMEN.Campo-C[1] = BONIFICACION.codmat AND
        RESUMEN.Campo-C[2] = BONIFICACION.desmat
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE RESUMEN THEN DO:
        CREATE RESUMEN.
        ASSIGN
            RESUMEN.Llave-I = BONIFICACION.CodCia
            RESUMEN.Campo-C[1] = BONIFICACION.CodMat
            RESUMEN.Campo-C[2] = BONIFICACION.DesMat
            RESUMEN.Campo-C[3] = BONIFICACION.UndVta.
    END.
    ASSIGN
        RESUMEN.Campo-F[1] = RESUMEN.Campo-F[1] + BONIFICACION.CanPed.
END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Realizado W-Win 
PROCEDURE Carga-Realizado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Comprobantes con condición de venta 899 o 900
------------------------------------------------------------------------------*/

DEF VAR x-Factor AS INT NO-UNDO.

/* FAC y BOL */
FOR EACH GN-DIVI NO-LOCK WHERE GN-DIVI.CodCia = s-codcia AND GN-DIVI.CodDiv = COMBO-BOX-Division,
    EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia AND
        Ccbcdocu.DivOri = GN-DIVI.CodDiv AND
        Ccbcdocu.codcli = T-CLIE.CodCli AND
        Ccbcdocu.flgest <> 'A' AND
        (Ccbcdocu.fchdoc >= FILL-IN-Desde AND Ccbcdocu.fchdoc <= FILL-IN-Hasta),
    FIRST PEDIDO NO-LOCK WHERE PEDIDO.codcia = s-codcia AND
        PEDIDO.coddoc = Ccbcdocu.codped AND
        PEDIDO.nroped = Ccbcdocu.nroped,
    FIRST COTIZACION NO-LOCK WHERE COTIZACION.codcia = s-codcia AND
        COTIZACION.coddoc = PEDIDO.codref AND
        COTIZACION.nroped = PEDIDO.nroref:
    /* Filtramos los comprobantes */
    IF LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL') = 0 THEN NEXT.
    IF LOOKUP(Ccbcdocu.fmapgo, '899,900') = 0 THEN NEXT.
    IF COTIZACION.lista_de_precios <> COMBO-BOX-ListaPrecios THEN NEXT.
    /* Cargamos Detalle */
    FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
        /* Cargamos informacion */
        FIND FIRST RESUMEN WHERE RESUMEN.Campo-C[1] = Ccbddocu.codmat AND
            NOT RESUMEN.Campo-C[2] BEGINS 'BONIFICACION MULTIPLE'
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE RESUMEN THEN DO:
            CREATE RESUMEN.
            ASSIGN
                RESUMEN.Llave-I = s-CodCia
                RESUMEN.Campo-C[1] = Ccbddocu.CodMat
                RESUMEN.Campo-C[2] = Almmmatg.DesMat
                RESUMEN.Campo-C[3] = Almmmatg.UndBas.
        END.
        ASSIGN
            RESUMEN.Campo-F[2] = RESUMEN.Campo-F[2] + (Ccbddocu.CanDes * Ccbddocu.Factor).
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Resumen W-Win 
PROCEDURE Carga-Resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Cargamos resumen */
FOR EACH T-CDOCU NO-LOCK WHERE T-CDOCU.CodCli = T-CLIE.CodCli,
    EACH T-DDOCU OF T-CDOCU NO-LOCK, 
    FIRST Almmmatg OF T-DDOCU NO-LOCK:
    FIND FIRST ITEM WHERE ITEM.codmat = T-DDOCU.codmat EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE ITEM THEN DO:
        CREATE ITEM.
        ASSIGN
            ITEM.CodCia = s-CodCia
            ITEM.codmat = T-DDOCU.CodMat.
    END.
    ASSIGN
        ITEM.canped = ITEM.canped + (T-DDOCU.candes * T-DDOCU.factor)
        ITEM.implin = ITEM.implin + T-DDOCU.implin
        ITEM.undvta = Almmmatg.undbas
        ITEM.factor = 1.
END.

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
  DISPLAY COMBO-BOX-Division COMBO-BOX-ListaPrecios FILL-IN-CodCli 
          FILL-IN-NomCli FILL-IN-Desde FILL-IN-Hasta FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-2 COMBO-BOX-Division BUTTON-Texto COMBO-BOX-ListaPrecios 
         BUTTON-Cliente FILL-IN-CodCli BUTTON-Procesar FILL-IN-Desde 
         FILL-IN-Hasta BROWSE-Comprobantes BROWSE-Resumen BROWSE-Bonificaciones 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-Division:DELETE(1).
      COMBO-BOX-Division:DELIMITER = '|'.
      FOR EACH gn-divi NO-LOCK WHERE GN-DIVI.CodCia = s-CodCia AND
          GN-DIVI.Campo-Log[1] = NO AND
          GN-DIVI.CanalVenta = "FER" AND
          LOOKUP(GN-DIVI.Campo-Char[1], 'A,D') > 0
          BY GN-DIVI.CodDiv DESC:
          COMBO-BOX-Division:ADD-LAST(GN-DIVI.CodDiv + ' - ' + GN-DIVI.DesDiv, GN-DIVI.CodDiv).
          COMBO-BOX-Division = GN-DIVI.CodDiv.
      END.

      COMBO-BOX-ListaPrecios:DELETE(1).
      COMBO-BOX-ListaPrecios:DELIMITER = '|'.
      FOR EACH gn-divi NO-LOCK WHERE GN-DIVI.CodCia = s-CodCia AND
          GN-DIVI.Campo-Log[1] = NO AND
          GN-DIVI.CanalVenta = "FER" AND
          LOOKUP(GN-DIVI.Campo-Char[1], 'A,L') > 0
          BY GN-DIVI.CodDiv DESC:
          COMBO-BOX-ListaPrecios:ADD-LAST(GN-DIVI.CodDiv + ' - ' + GN-DIVI.DesDiv, GN-DIVI.CodDiv).
          COMBO-BOX-ListaPrecios = GN-DIVI.CodDiv.
      END.
      FILL-IN-Desde = ADD-INTERVAL(TODAY, -1, 'month').
      FILL-IN-Hasta = TODAY.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Proceso-Principal W-Win 
PROCEDURE Proceso-Principal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE('GENERAL').

EMPTY TEMP-TABLE T-CDOCU.
EMPTY TEMP-TABLE T-DDOCU.
EMPTY TEMP-TABLE ITEM-2.
EMPTY TEMP-TABLE RESUMEN-2.
EMPTY TEMP-TABLE T-CLIE.

/* Comprobantes válidos de todos los clientes relacionados */
/* Cargamos T-CDOCU T-DDOCU y T-CLIE */
RUN Carga-Comprobantes.

/* Por cada cliente calculamos su bonificacion */
FOR EACH T-CLIE NO-LOCK:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CLIENTE: " + T-CLIE.codcli + " " + 
        T-CLIE.nomcli.
    /* Cargamos ITEM con las ventas resumidas por cliente */
    EMPTY TEMP-TABLE ITEM.
    RUN Carga-Resumen.
    /* Cargamos las bonificaciones */
    EMPTY TEMP-TABLE BONIFICACION.
    RUN Carga-Bonificaciones.
    /* Resumimos Bonificaciones por producto */
    EMPTY TEMP-TABLE RESUMEN.
    RUN Carga-Final.
    /* Acumulamos las Bonificaciones Entregadas en la tabla RESUMEN */
    RUN Carga-Realizado.
    /* Resumen por Cliente */
    FOR EACH ITEM NO-LOCK:
        CREATE ITEM-2.
        BUFFER-COPY ITEM TO ITEM-2 ASSIGN ITEM-2.CodCli = T-CLIE.CodCli.
    END.
    FOR EACH RESUMEN NO-LOCK:
        CREATE RESUMEN-2.                       
        BUFFER-COPY RESUMEN TO RESUMEN-2 ASSIGN RESUMEN-2.Llave-C = T-CLIE.CodCli.
    END.
END.

/* Ahora Cargamos las tablas a mostrar */
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "RESUMIENDO".
EMPTY TEMP-TABLE ITEM.
FOR EACH ITEM-2 NO-LOCK:
    CREATE ITEM.
    BUFFER-COPY ITEM-2 TO ITEM.
END.
EMPTY TEMP-TABLE RESUMEN.
FOR EACH RESUMEN-2 NO-LOCK:
    CREATE RESUMEN.
    BUFFER-COPY RESUMEN-2 TO RESUMEN.
END.
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

SESSION:SET-WAIT-STATE('').

{&OPEN-QUERY-BROWSE-Comprobantes}
{&OPEN-QUERY-BROWSE-Resumen}
{&OPEN-QUERY-BROWSE-Bonificaciones}

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
  {src/adm/template/snd-list.i "ITEM"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "T-CDOCU"}
  {src/adm/template/snd-list.i "RESUMEN"}

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

