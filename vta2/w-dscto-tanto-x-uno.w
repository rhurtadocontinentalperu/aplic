&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE FacTabla-tt NO-UNDO LIKE FacTabla.
DEFINE TEMP-TABLE tt-FacTabla NO-UNDO LIKE FacTabla.



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
DEFINE SHARED VAR s-codcia AS INT.

DEFINE TEMP-TABLE tVentas
    FIELD   tcodmat     AS CHAR     FORMAT 'x(6)'   COLUMN-LABEL "Codigo"
    FIELD   tdesmat     AS CHAR     FORMAT 'x(80)'  COLUMN-LABEL "Descripcion"
    FIELD   tmarca      AS CHAR     FORMAT 'x(60)'  COLUMN-LABEL "Marca"
    FIELD   tfchdoc     AS DATE     COLUMN-LABEL "Fecha de Transaccion"
    FIELD   tcandes     AS DEC      COLUMN-LABEL "Cantidad"
    FIELD   tcandes1    AS DEC      COLUMN-LABEL "Cantidad Dscto Aplicado"
    FIELD   tpreuni     AS DEC      COLUMN-LABEL "Precio Unitario"
    FIELD   timplin     AS DEC      COLUMN-LABEL "Importe"
    FIELD   timpdto     AS DEC      COLUMN-LABEL "Imp. Dscto"                                                          
    FIELD   tcoddoc     AS CHAR     FORMAT 'x(5)'   COLUMN-LABEL "CodDoc"
    FIELD   tnrodoc     AS CHAR     FORMAT 'x(15)'  COLUMN-LABEL "Nro Doc".

DEFINE TEMP-TABLE tfacdpedi LIKE facdpedi.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-FacTabla FacTabla-tt

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 tt-FacTabla.Codigo ~
tt-FacTabla.Nombre tt-FacTabla.Campo-C[1] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH tt-FacTabla NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH tt-FacTabla NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 tt-FacTabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 tt-FacTabla


/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 FacTabla-tt.Valor[1] ~
FacTabla-tt.Codigo FacTabla-tt.Nombre FacTabla-tt.Campo-C[1] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH FacTabla-tt NO-LOCK ~
    BY FacTabla-tt.Valor[1] INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH FacTabla-tt NO-LOCK ~
    BY FacTabla-tt.Valor[1] INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 FacTabla-tt
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 FacTabla-tt


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-25 RECT-26 txtNombre txtDesde txtHasta ~
txtUnidades txtpordscto BUTTON-1 BROWSE-3 BROWSE-4 BUTTON-3 BUTTON-2 ~
ChkEliminarAnteriores 
&Scoped-Define DISPLAYED-OBJECTS txtCodigo txtNombre txtDesde txtHasta ~
txtUnidad2 txtUnidades txtpordscto ChkEliminarAnteriores 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 4 BY .77.

DEFINE BUTTON BUTTON-2 
     LABEL "GRABAR LOS ARTICULOS DE LA PROMOCION" 
     SIZE 46 BY 1.12.

DEFINE BUTTON BUTTON-3 
     LABEL "Generar ventas a Excel" 
     SIZE 28 BY 1.12.

DEFINE VARIABLE txtCodigo AS CHARACTER FORMAT "X(50)":U INITIAL "DSCTO_TANTO_X_UNO" 
     LABEL "Codigo" 
     VIEW-AS FILL-IN 
     SIZE 33 BY 1
     BGCOLOR 15 FGCOLOR 9 FONT 11 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtNombre AS CHARACTER FORMAT "X(50)":U INITIAL "Descuentos para productos HP" 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 64 BY 1
     BGCOLOR 15 FGCOLOR 0 FONT 11 NO-UNDO.

DEFINE VARIABLE txtpordscto AS DECIMAL FORMAT ">>9.9999":U INITIAL 0 
     LABEL "% Descuento" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     FGCOLOR 9 FONT 11 NO-UNDO.

DEFINE VARIABLE txtUnidad2 AS INTEGER FORMAT ">,>>9":U INITIAL 1 
     LABEL "Cargar % Descuento a" 
     VIEW-AS FILL-IN 
     SIZE 4.29 BY 1
     FONT 11 NO-UNDO.

DEFINE VARIABLE txtUnidades AS INTEGER FORMAT ">,>>9":U INITIAL 2 
     LABEL "Por la compra de" 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY 1
     FONT 11 NO-UNDO.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 1.73.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69 BY 2.65.

DEFINE VARIABLE ChkEliminarAnteriores AS LOGICAL INITIAL no 
     LABEL "¿ Eliminar los articulos anteriores ?" 
     VIEW-AS TOGGLE-BOX
     SIZE 38 BY .77
     BGCOLOR 15 FGCOLOR 9 FONT 10 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      tt-FacTabla SCROLLING.

DEFINE QUERY BROWSE-4 FOR 
      FacTabla-tt SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      tt-FacTabla.Codigo FORMAT "x(8)":U WIDTH 7.57
      tt-FacTabla.Nombre FORMAT "x(60)":U WIDTH 34
      tt-FacTabla.Campo-C[1] COLUMN-LABEL "Marca" FORMAT "x(30)":U
            WIDTH 21.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 67.72 BY 17.69 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      FacTabla-tt.Valor[1] COLUMN-LABEL "Sec" FORMAT ">>>9":U
      FacTabla-tt.Codigo FORMAT "x(8)":U
      FacTabla-tt.Nombre FORMAT "x(60)":U WIDTH 37.14
      FacTabla-tt.Campo-C[1] COLUMN-LABEL "Marca" FORMAT "x(30)":U
            WIDTH 12.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 66.72 BY 17.69 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txtCodigo AT ROW 1.23 COL 19 COLON-ALIGNED WIDGET-ID 2
     txtNombre AT ROW 2.27 COL 19 COLON-ALIGNED WIDGET-ID 4
     txtDesde AT ROW 3.85 COL 9.86 COLON-ALIGNED WIDGET-ID 6
     txtHasta AT ROW 3.85 COL 32 COLON-ALIGNED WIDGET-ID 8
     txtUnidad2 AT ROW 3.85 COL 106.14 COLON-ALIGNED WIDGET-ID 16
     txtUnidades AT ROW 3.88 COL 67.14 COLON-ALIGNED WIDGET-ID 14
     txtpordscto AT ROW 5.04 COL 86.43 COLON-ALIGNED WIDGET-ID 18
     BUTTON-1 AT ROW 6.42 COL 124 WIDGET-ID 28
     BROWSE-3 AT ROW 7.27 COL 1.86 WIDGET-ID 200
     BROWSE-4 AT ROW 7.31 COL 70.14 WIDGET-ID 300
     BUTTON-3 AT ROW 25.23 COL 6 WIDGET-ID 38
     BUTTON-2 AT ROW 25.23 COL 45 WIDGET-ID 30
     ChkEliminarAnteriores AT ROW 25.42 COL 92 WIDGET-ID 32
     "Und(s)" VIEW-AS TEXT
          SIZE 6 BY .62 AT ROW 4.04 COL 113 WIDGET-ID 36
     "Und(s)" VIEW-AS TEXT
          SIZE 6 BY .62 AT ROW 4.04 COL 79.72 WIDGET-ID 34
     "  ARTICULOS A CARGAR - EXCEL" VIEW-AS TEXT
          SIZE 45.86 BY .81 AT ROW 6.42 COL 77.14 WIDGET-ID 26
          BGCOLOR 2 FGCOLOR 15 FONT 11
     "  ARTICULOS ANTERIORES" VIEW-AS TEXT
          SIZE 36 BY .81 AT ROW 6.38 COL 14.86 WIDGET-ID 24
          BGCOLOR 9 FGCOLOR 15 FONT 11
     "  Condiciones" VIEW-AS TEXT
          SIZE 15 BY .62 AT ROW 3.31 COL 53 WIDGET-ID 22
          FGCOLOR 4 FONT 2
     "  Vigencia" VIEW-AS TEXT
          SIZE 12 BY .62 AT ROW 3.23 COL 5 WIDGET-ID 12
          FGCOLOR 4 FONT 2
     RECT-25 AT ROW 3.54 COL 4 WIDGET-ID 10
     RECT-26 AT ROW 3.54 COL 52 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 137 BY 25.96 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: FacTabla-tt T "?" NO-UNDO INTEGRAL FacTabla
      TABLE: tt-FacTabla T "?" NO-UNDO INTEGRAL FacTabla
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Carga promociones TANTO x UNO"
         HEIGHT             = 26.04
         WIDTH              = 137.29
         MAX-HEIGHT         = 26.04
         MAX-WIDTH          = 137.29
         VIRTUAL-HEIGHT     = 26.04
         VIRTUAL-WIDTH      = 137.29
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
/* BROWSE-TAB BROWSE-3 BUTTON-1 F-Main */
/* BROWSE-TAB BROWSE-4 BROWSE-3 F-Main */
/* SETTINGS FOR FILL-IN txtCodigo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtUnidad2 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.tt-FacTabla"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-FacTabla.Codigo
"tt-FacTabla.Codigo" ? ? "character" ? ? ? ? ? ? no ? no no "7.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-FacTabla.Nombre
"tt-FacTabla.Nombre" ? "x(60)" "character" ? ? ? ? ? ? no ? no no "34" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-FacTabla.Campo-C[1]
"tt-FacTabla.Campo-C[1]" "Marca" "x(30)" "character" ? ? ? ? ? ? no ? no no "21.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.FacTabla-tt"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.FacTabla-tt.Valor[1]|yes"
     _FldNameList[1]   > Temp-Tables.FacTabla-tt.Valor[1]
"FacTabla-tt.Valor[1]" "Sec" ">>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.FacTabla-tt.Codigo
     _FldNameList[3]   > Temp-Tables.FacTabla-tt.Nombre
"FacTabla-tt.Nombre" ? "x(60)" "character" ? ? ? ? ? ? no ? no no "37.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.FacTabla-tt.Campo-C[1]
"FacTabla-tt.Campo-C[1]" "Marca" "x(30)" "character" ? ? ? ? ? ? no ? no no "12.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Carga promociones TANTO x UNO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Carga promociones TANTO x UNO */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:
  RUN cargar-excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* GRABAR LOS ARTICULOS DE LA PROMOCION */
DO:
  ASSIGN txtNombre txtDesde txtHasta txtUnidades txtUnidad2 txtPorDscto chkEliminarAnteriores.

MESSAGE '¿ esea grabar los articulos ?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.


  RUN grabar-articulos.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Generar ventas a Excel */
DO:
  ASSIGN txtNombre txtDesde txtHasta txtUnidades txtUnidad2 txtPorDscto chkEliminarAnteriores.

  RUN enviar-vtas-excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-excel W-Win 
PROCEDURE cargar-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-archivo AS CHAR.                       
DEFINE VAR okPressed AS LOG.
                       
SYSTEM-DIALOG GET-FILE x-Archivo
FILTERS "Archivo Excel" "*.xlsx,*.xls"
MUST-EXIST
TITLE "Seleccione archivo..."
UPDATE OKpressed.   
IF OKpressed = NO THEN RETURN.

/*MESSAGE x-archivo.*/

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

DEFINE VAR xCaso AS CHAR.
DEFINE VAR xFamilia AS CHAR.
DEFINE VAR xSubFamilia AS CHAR.
DEFINE VAR lLinea AS INT.
DEFINE VAR dValor AS DEC.
DEFINE VAR lTpoCmb AS DEC.

DEFINE VAR x-sec AS INT.

lFileXls = x-archivo.           /* Nombre el archivo a abrir o crear, vacio solo para nuevos */
lNuevoFile = NO.                            /* Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = YES.        /* Si permanece abierto el Excel luego de concluir el proceso */

iColumn = 1.
lLinea = 1.

EMPTY TEMP-TABLE factabla-tt.

SESSION:SET-WAIT-STATE('GENERAL').

cColumn = STRING(lLinea).

x-sec = 0.

REPEAT iColumn = 2 TO 65000 :
    cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    xCaso = chWorkSheet:Range(cRange):TEXT.

    IF xCaso = "" OR xCaso = ? THEN LEAVE.    /* FIN DE DATOS */

    x-sec = x-sec + 1.

    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                almmmatg.codmat = xCaso NO-LOCK NO-ERROR.
    CREATE factabla-tt.
    ASSIGN factabla-tt.codigo = xcaso
            factabla-tt.valor[1] = x-sec.

    IF AVAILABLE almmmatg THEN DO:
        ASSIGN factabla-tt.nombre = almmmatg.desmat
                factabla-tt.campo-c[1] = almmmatg.desmar.
    END.
    ELSE DO:
        ASSIGN factabla-tt.nombre = "< ERROR - NO EXISTE >"
                    factabla-tt.campo-c[1] = "ERROR".
    END.
    
END.

SESSION:SET-WAIT-STATE('').
{&OPEN-QUERY-BROWSE-4}

{lib\excel-close-file.i}

MESSAGE "Se cargaron " + STRING(x-sec) + " Articulos".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE data-actual W-Win 
PROCEDURE data-actual :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-codigo AS CHAR.

x-codigo = txtCodigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

EMPTY TEMP-TABLE tt-factabla.

FOR EACH factabla WHERE factabla.codcia = s-codcia and 
                        factabla.tabla = x-codigo AND
                        factabla.codigo <> 'VIGENCIA' NO-LOCK.
    CREATE tt-factabla.
    ASSIGN tt-factabla.codigo = factabla.codigo.

    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                almmmatg.codmat = factabla.codigo NO-LOCK NO-ERROR.
    IF AVAILABLE almmmatg THEN DO:
        ASSIGN tt-factabla.nombre = almmmatg.desmat
                    tt-factabla.campo-c[1] = almmmatg.desmar.
    END.
    ELSE DO:
        ASSIGN tt-factabla.nombre = "< ERROR - NO EXISTE >"
                    tt-factabla.campo-c[1] = "".
    END.
END.

{&OPEN-QUERY-BROWSE-3}


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
  DISPLAY txtCodigo txtNombre txtDesde txtHasta txtUnidad2 txtUnidades 
          txtpordscto ChkEliminarAnteriores 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-25 RECT-26 txtNombre txtDesde txtHasta txtUnidades txtpordscto 
         BUTTON-1 BROWSE-3 BROWSE-4 BUTTON-3 BUTTON-2 ChkEliminarAnteriores 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enviar-vtas-excel W-Win 
PROCEDURE enviar-vtas-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-archivo AS CHAR.
DEFINE VAR rpta AS LOG.
                       
SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Excel (*.xlsx)' '*.xlsx'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.xlsx'
    RETURN-TO-START-DIR
    SAVE-AS
    TITLE 'Exportar a Excel'
    UPDATE rpta.
IF rpta = NO OR x-Archivo = '' THEN RETURN.


DEFINE VAR lDocs AS CHAR.
DEFINE VAR lDoc AS CHAR.
DEFINE VAR lSec AS INT.

DEFINE VAR lFechaDesde AS DATE.
DEFINE VAR lFechaHasta AS DATE.
DEFINE VAR lFecha AS DATE.

lDocs = 'FAC,BOL'.    
lFechaDesde = txtDesde.
lFechaHasta = txtHasta.

EMPTY TEMP-TABLE tVentas.

SESSION:SET-WAIT-STATE('GENERAL').

FOR EACH facdpedi WHERE facdpedi.codcia = 1 AND
                    facdpedi.fchped >= lFEchaDesde and
                    facdpedi.fchped <= lFechaHasta and 
                    facdpedi.libre_c04 BEGINS txtCodigo  NO-LOCK,
    FIRST faccpedi OF facdpedi NO-LOCK WHERE faccpedi.flgest <> 'A':

    CREATE tfacdpedi.
        BUFFER-COPY facdpedi TO tfacdpedi.
END.


REPEAT lFecha = lFechaDesde TO lFechaHasta:
    REPEAT lSec = 1 TO NUM-ENTRIES(lDocs,","):
        lDoc = ENTRY(lSec,lDocs,",").
        FOR EACH ccbcdocu USE-INDEX llave13 WHERE ccbcdocu.codcia = 1 AND 
                                ccbcdocu.fchdoc = lFecha AND 
                                ccbcdocu.coddoc = lDoc AND 
                                ccbcdocu.flgest <> 'A' NO-LOCK:
            FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
                FIND FIRST almmmatg OF ccbddocu NO-LOCK NO-ERROR.
                /**/
                FIND FIRST tfacdpedi WHERE tfacdpedi.coddoc = ccbcdocu.codped AND
                                            tfacdpedi.nroped = ccbcdocu.nroped AND
                                            tfacdpedi.codmat = ccbddocu.codmat NO-ERROR.
                IF AVAILABLE tfacdpedi THEN DO:
                    CREATE tventas.
                        ASSIGN  tcodmat = ccbddocu.codmat
                                tdesmat = almmmatg.desmat
                                tmarca  = almmmatg.desmar
                                tfchdoc = ccbcdocu.fchdoc
                                tcandes = ccbddocu.candes
                                tcandes1 = DEC(ENTRY(2,tfacdpedi.libre_c04,"|"))
                                tpreuni = ccbddocu.preuni
                                timplin = ccbddocu.implin
                                timpdto = ccbddocu.impdto2
                                tcoddoc = ccbcdocu.coddoc
                                tnrodoc = ccbcdocu.nrodoc.
                END.
            END.
        END.
    END.
END.
                                             
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = x-archivo.

run pi-crea-archivo-csv IN hProc (input  buffer tventas:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tventas:handle,
                        input  c-csv-file,
                        output c-xls-file) .

/* -------------------- */

/*
c-xls-file = x-archivo.

run pi-crea-archivo-csv IN hProc (input  buffer tfacdpedi:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tfacdpedi:handle,
                        input  c-csv-file,
                        output c-xls-file) .

*/

DELETE PROCEDURE hProc.

SESSION:SET-WAIT-STATE('').

MESSAGE "Proceso concluido".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-articulos W-Win 
PROCEDURE grabar-articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST factabla-tt NO-ERROR.

IF NOT AVAILABLE factabla-tt THEN DO:
    MESSAGE "No existen datos a cargar".
    RETURN "ADM-ERROR".
END.

IF CAPS(txtNombre) = "INGRESE EL NOMBRE DE LA PROMOCION" THEN DO:
    MESSAGE "Ingrese un nombre CORRECTO para la Promocion".
    RETURN "ADM-ERROR".
END.

IF txtDesde > txtHasta THEN DO:
    MESSAGE "Vigencia no esta correctamente ingresada".
    RETURN "ADM-ERROR".
END.
IF txtUnidades <= 0 THEN DO:
    MESSAGE "Las unidades de 'Por la compra de' esta erradas!!!".
    RETURN "ADM-ERROR".
END.
IF txtUnidad2 <= 0 THEN DO:
    MESSAGE "Las unidades de 'Cargar % descuento a' esta erradas!!!".
    RETURN "ADM-ERROR".
END.
IF txtPorDscto <= 0 THEN DO:
    MESSAGE "% Descuento esta errado".
    RETURN "ADM-ERROR".
END.

SESSION:SET-WAIT-STATE('GENERAL').

DEFINE VAR x-codigo AS CHAR.
DEFINE VAR x-num-arts AS INT INIT 0.

/* La cabecera */
x-codigo = txtCodigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

FIND FIRST factabla WHERE factabla.codcia = s-codcia and 
                      factabla.tabla = x-codigo AND
                      factabla.codigo = 'VIGENCIA' EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE factabla THEN DO:
    CREATE factabla.
            ASSIGN  factabla.codcia = s-codcia
                    factabla.tabla = x-codigo.
                    factabla.codigo = "VIGENCIA".
END.
ASSIGN  factabla.nombre = txtNombre
        factabla.campo-d[1] = txtDesde
        factabla.campo-d[2] = txtHasta
        factabla.valor[1] = txtUnidades
        factabla.valor[2] = txtUnidad2
        factabla.valor[3] = txtPorDscto.

/* Eliminar los anteriores */
IF chkEliminarAnteriores = YES THEN DO:

    DEFINE BUFFER b-factabla FOR factabla.
    DEFINE VAR x-rowid AS ROWID.

    FOR EACH factabla WHERE factabla.codcia = s-codcia and 
                          factabla.tabla = x-codigo AND
                          factabla.codigo <> 'VIGENCIA' NO-LOCK.
        x-rowid = ROWID(factabla).
        FIND FIRST b-factabla WHERE ROWID(b-factabla) = x-rowid EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE b-factabla THEN DO:
            DELETE b-factabla.
        END.
    END.
END.

/* Grabo los datos del Excel */
FOR EACH factabla-tt WHERE factabla-tt.campo-c[1] <> "ERROR" :

    FIND FIRST factabla WHERE factabla.codcia = s-codcia and 
                          factabla.tabla = x-codigo AND
                          factabla.codigo = factabla-tt.codigo EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE factabla THEN DO:
        CREATE factabla.
        ASSIGN  factabla.codcia = s-codcia
                factabla.tabla = x-codigo
                factabla.codigo = factabla-tt.codigo NO-ERROR.

        IF ERROR-STATUS:ERROR = NO THEN DO:
            ASSIGN factabla-tt.campo-c[1] = "*****".
            x-num-arts = x-num-arts + 1.
        END.

    END.
END.

FOR EACH factabla-tt WHERE factabla-tt.campo-c[1] = "*****" :
    DELETE factabla-tt.
END.

{&OPEN-QUERY-BROWSE-3}
{&OPEN-QUERY-BROWSE-4}

SESSION:SET-WAIT-STATE('').

MESSAGE "Se GRABARON " + STRING(x-num-arts) + " Articulos".

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").
  txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY + 7,"99/99/9999").
  txtNombre:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Ingrese el nombre de la PROMOCION".
  txtUnidades:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "2".
  txtUnidad2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1".
  txtPorDscto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".

  DEFINE VAR x-codigo AS CHAR.

  x-codigo = txtCodigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  
  FIND FIRST factabla WHERE factabla.codcia = s-codcia and 
                          factabla.tabla = x-codigo AND
                          factabla.codigo = 'VIGENCIA' NO-LOCK NO-ERROR.
  IF AVAILABLE factabla THEN DO:
        txtNombre:SCREEN-VALUE IN FRAME {&FRAME-NAME} = factabla.nombre.
        txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(factabla.campo-d[1],"99/99/9999").
        txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(factabla.campo-d[2],"99/99/9999").
        txtUnidades:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(factabla.valor[1],"999").
        txtUnidad2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(factabla.valor[2],"999").
        txtPorDscto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(factabla.valor[3],"999.9999").
  END.

 RUN data-actual.

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
  {src/adm/template/snd-list.i "FacTabla-tt"}
  {src/adm/template/snd-list.i "tt-FacTabla"}

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

