&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win
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
DEFINE VAR lxFile AS CHAR.

DEFINE TEMP-TABLE tt-qstock
    FIELDS tt-codalm    AS CHAR FORMAT 'x(3)' COLUMN-LABEL "Cod.Alm"
    FIELDS tt-desalm    AS CHAR FORMAT 'x(50)' COLUMN-LABEL "Almacen"
    FIELDS tt-proveedor AS CHAR FORMAT 'x(80)' COLUMN-LABEL "Proveedor"
    FIELDS tt-linea     AS CHAR FORMAT 'x(60)' COLUMN-LABEL "Linea"
    FIELDS tt-sublinea  AS CHAR FORMAT 'x(60)' COLUMN-LABEL "Sub Linea"
    FIELDS tt-codmat    AS CHAR FORMAT 'x(6)' COLUMN-LABEL "Cod.Articulo"
    FIELDS tt-desmat    AS CHAR FORMAT 'x(50)' COLUMN-LABEL "Descripcion"
    FIELDS tt-marca     AS CHAR FORMAT 'x(50)' COLUMN-LABEL "Marca"
    FIELDS tt-umed      AS CHAR FORMAT 'x(7)' COLUMN-LABEL "U.Medida"
    FIELDS tt-cgrlc     AS CHAR FORMAT 'x(2)' COLUMN-LABEL "Clsf Gral Campaña"           /* x */
    FIELDS tt-cmayc     AS CHAR FORMAT 'x(2)' COLUMN-LABEL "Clsf Mayorista Campaña"      /* x */
    FIELDS tt-cutxc     AS CHAR FORMAT 'x(2)' COLUMN-LABEL "Clsf Utilex Campaña"         /* x */
    FIELDS tt-cgrlnc    AS CHAR FORMAT 'x(2)' COLUMN-LABEL "Clsf Gral NoCampaña"         /* x */
    FIELDS tt-cmaync    AS CHAR FORMAT 'x(2)' COLUMN-LABEL "Clsf Mayorista NoCampaña"    /* x */
    FIELDS tt-cutxnc    AS CHAR FORMAT 'x(2)' COLUMN-LABEL "Clsf Utilex NoCampaña"       /* x */   
    FIELDS tt-costrepo  AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Costo Reposicion S/ (G)"  /* ???????? */
    FIELDS tt-stkmax    AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Maximo (E)"
    FIELDS tt-stkseg    AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Seguridad (Z)"
    FIELDS tt-emprep    AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Empaque Reposicion"
    FIELDS tt-stkfisico AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Fisico (A)"
    FIELDS tt-stkreser  AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Reservado (B)"
    FIELDS tt-stkdispo  AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock a disponer D = (A - B)"
    FIELDS tt-stktrftra AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Trans en Transito (C)"    
    FIELDS tt-stkfalta  AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Faltante F = (E - D - C)"      /* restar la C */
    FIELDS tt-stkt11    AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Disp 11"
    FIELDS tt-stkt11max AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Maximo 11"  /* x */
    FIELDS tt-stkt11seg AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Seguridad 11"  /* x */
    FIELDS tt-stkt35    AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Disp 35"
    FIELDS tt-stkt35max AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Maximo 35" /* x */    
    FIELDS tt-stkt35seg AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Seguridad 35" /* x */    
    FIELDS tt-stkt14    AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Disp 14"        /* ???????? */
    FIELDS tt-stkt14f   AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Disp 14F"       /* ???????? */
    FIELDS tt-stkt21    AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Disp 21"
    FIELDS tt-vstkmax   AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Valorizado Stk Maximo (G * E)"
    FIELDS tt-vsfisico  AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Valorizado Stk Fisico (G * A)"
    FIELDS tt-vsdispo   AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Valorizado Stk Disponible (G * D)"     /* ?????????? */    
    FIELDS tt-vstrans   AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Valorizado Stk Transito (G * C)"     /* ?????????? */
    FIELDS tt-costfalta AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Valorizado Faltantes S/ H = (G * F)"
    FIELDS tt-vta15dant AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Vta 15 atras"          /* ???????? */
    FIELDS tt-vta30dant AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Vta 30 atras"          /* ???????? */
    FIELDS tt-vta45dant AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Vta 45 atras"          /* ???????? */
    FIELDS tt-v30daante AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Vta 30 atras"          /* ???????? */
    FIELDS tt-fv30_max  AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Vta 30 dias Atras/Maximo"          /* ???????? */
    FIELDS tt-fv30p_max AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Vta 30 dias Año pasado/Maximo".          /* ???????? */
    
    /*FIELDS tt-stkt11m   AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Disp 11m"*/
    

/*
FIELDS tt-costrepo  AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Costo Reposicion S/ (G)"  /* ???????? */
FIELDS tt-stkt14    AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Disp 14"        /* ???????? */
FIELDS tt-stkt14f   AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Disp 14F"       /* ???????? */
FIELDS tt-vsdispo   AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Valorizado Stk Disponible (G * D)"     /* ?????????? */    
FIELDS tt-vstrans   AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Valorizado Stk Transito (G * C)"     /* ?????????? */
FIELDS tt-vta15dant AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Vta 15 atras"          /* ???????? */
FIELDS tt-vta30dant AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Vta 30 atras"          /* ???????? */
FIELDS tt-vta45dant AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Vta 45 atras"          /* ???????? */
FIELDS tt-v30daante AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Vta 30 atras"          /* ???????? */
FIELDS tt-fv30_max  AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Vta 30 dias Atras/Maximo"          /* ???????? */
FIELDS tt-fv30p_max AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Vta 30 dias Año pasado/Maximo".          /* ???????? */
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-5

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almtfami almtabla

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 Almtfami.codfam Almtfami.desfam 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH Almtfami ~
      WHERE codcia = s-codcia NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH Almtfami ~
      WHERE codcia = s-codcia NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 Almtfami
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 Almtfami


/* Definitions for BROWSE BROWSE-6                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-6 almtabla.Codigo almtabla.Nombre 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-6 
&Scoped-define QUERY-STRING-BROWSE-6 FOR EACH almtabla ~
      WHERE codcia = s-codcia and tabla = 'MK' NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-6 OPEN QUERY BROWSE-6 FOR EACH almtabla ~
      WHERE codcia = s-codcia and tabla = 'MK' NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-6 almtabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-6 almtabla


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-5}~
    ~{&OPEN-QUERY-BROWSE-6}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-7 RECT-8 txtAlmacenes BROWSE-6 BROWSE-5 ~
btnFamTodos btnFamNinguno btnMarTodos btnMarNinguno CboProveedor ~
BtnProcesar txtEvaluacion 
&Scoped-Define DISPLAYED-OBJECTS txtAlmacenes CboProveedor txtEvaluacion 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fStock-disponible W-Win 
FUNCTION fStock-disponible RETURNS DECIMAL
  ( INPUT pCodMat AS CHAR, INPUT pCodAlm AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fstock-maximo W-Win 
FUNCTION fstock-maximo RETURNS DECIMAL
  ( INPUT pCodMat AS CHAR, INPUT pCodAlm AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fstock-seguridad W-Win 
FUNCTION fstock-seguridad RETURNS DECIMAL
  ( INPUT pCodMat AS CHAR, INPUT pCodAlm AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnFamNinguno 
     LABEL "Ninguno" 
     SIZE 13 BY .77.

DEFINE BUTTON btnFamTodos 
     LABEL "Todos" 
     SIZE 13 BY .77.

DEFINE BUTTON btnMarNinguno 
     LABEL "Ninguno" 
     SIZE 13 BY .77.

DEFINE BUTTON btnMarTodos 
     LABEL "Todos" 
     SIZE 13 BY .77.

DEFINE BUTTON BtnProcesar 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE CboProveedor AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 51 BY 1 NO-UNDO.

DEFINE VARIABLE txtAlmacenes AS CHARACTER FORMAT "X(80)":U 
     LABEL "Almacenes" 
     VIEW-AS FILL-IN 
     SIZE 67.43 BY 1 NO-UNDO.

DEFINE VARIABLE txtEvaluacion AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "% Evaluacion" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47.72 BY 14.04.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47.72 BY 14.04.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      Almtfami SCROLLING.

DEFINE QUERY BROWSE-6 FOR 
      almtabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      Almtfami.codfam FORMAT "X(3)":U
      Almtfami.desfam FORMAT "X(30)":U WIDTH 36
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 46 BY 11.85 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-6 W-Win _STRUCTURED
  QUERY BROWSE-6 NO-LOCK DISPLAY
      almtabla.Codigo FORMAT "x(8)":U
      almtabla.Nombre FORMAT "x(40)":U WIDTH 34.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 46 BY 11.73 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txtAlmacenes AT ROW 1.38 COL 11 COLON-ALIGNED WIDGET-ID 2
     BROWSE-6 AT ROW 4.31 COL 51.72 WIDGET-ID 300
     BROWSE-5 AT ROW 4.35 COL 3.14 WIDGET-ID 200
     btnFamTodos AT ROW 16.58 COL 7.72 WIDGET-ID 26
     btnFamNinguno AT ROW 16.58 COL 24.57 WIDGET-ID 28
     btnMarTodos AT ROW 16.58 COL 61 WIDGET-ID 32
     btnMarNinguno AT ROW 16.58 COL 77.86 WIDGET-ID 30
     CboProveedor AT ROW 18.81 COL 12 COLON-ALIGNED WIDGET-ID 12
     BtnProcesar AT ROW 19.65 COL 77 WIDGET-ID 16
     txtEvaluacion AT ROW 20.58 COL 39 COLON-ALIGNED WIDGET-ID 14
     "   Marcas" VIEW-AS TEXT
          SIZE 10 BY .62 AT ROW 3.58 COL 52 WIDGET-ID 22
          BGCOLOR 15 FGCOLOR 9 FONT 6
     "   Familias (Lineas)" VIEW-AS TEXT
          SIZE 18 BY .62 AT ROW 3.58 COL 4.57 WIDGET-ID 24
          BGCOLOR 9 FGCOLOR 15 
     "( Ejemplo 11,21,11e, .......)" VIEW-AS TEXT
          SIZE 21 BY .81 AT ROW 2.5 COL 16.29 WIDGET-ID 4
     RECT-7 AT ROW 3.92 COL 2.29 WIDGET-ID 18
     RECT-8 AT ROW 3.92 COL 51 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 102.72 BY 21.85 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Reporte de QUIEBRES de Stock"
         HEIGHT             = 21.85
         WIDTH              = 102.72
         MAX-HEIGHT         = 21.85
         MAX-WIDTH          = 102.72
         VIRTUAL-HEIGHT     = 21.85
         VIRTUAL-WIDTH      = 102.72
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
/* BROWSE-TAB BROWSE-6 txtAlmacenes F-Main */
/* BROWSE-TAB BROWSE-5 BROWSE-6 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "INTEGRAL.Almtfami"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "codcia = s-codcia"
     _FldNameList[1]   = INTEGRAL.Almtfami.codfam
     _FldNameList[2]   > INTEGRAL.Almtfami.desfam
"Almtfami.desfam" ? ? "character" ? ? ? ? ? ? no ? no no "36" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-6
/* Query rebuild information for BROWSE BROWSE-6
     _TblList          = "INTEGRAL.almtabla"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "codcia = s-codcia and tabla = 'MK'"
     _FldNameList[1]   = INTEGRAL.almtabla.Codigo
     _FldNameList[2]   > INTEGRAL.almtabla.Nombre
"almtabla.Nombre" ? ? "character" ? ? ? ? ? ? no ? no no "34.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte de QUIEBRES de Stock */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de QUIEBRES de Stock */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnFamNinguno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnFamNinguno W-Win
ON CHOOSE OF btnFamNinguno IN FRAME F-Main /* Ninguno */
DO:
  BROWSE-5:DESELECT-ROWS().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnFamTodos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnFamTodos W-Win
ON CHOOSE OF btnFamTodos IN FRAME F-Main /* Todos */
DO:
  BROWSE-5:SELECT-ALL().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnMarNinguno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnMarNinguno W-Win
ON CHOOSE OF btnMarNinguno IN FRAME F-Main /* Ninguno */
DO:
  BROWSE-6:DESELECT-ROWS().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnMarTodos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnMarTodos W-Win
ON CHOOSE OF btnMarTodos IN FRAME F-Main /* Todos */
DO:
  BROWSE-6:SELECT-ALL().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnProcesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnProcesar W-Win
ON CHOOSE OF BtnProcesar IN FRAME F-Main /* Procesar */
DO:
  ASSIGN txtAlmacenes cboProveedor txtEvaluacion.

  MESSAGE "Programa OBSOLETO, Consulte a Sistemas".
  RETURN NO-APPLY.

  IF  TRIM(txtAlmacenes) = "" THEN DO:
      MESSAGE "Ingrese Almacen(es)".
      RETURN NO-APPLY.
  END.

  IF txtEvaluacion <= 0 THEN DO:
      MESSAGE "% Evaluacion es inconsistente".
      RETURN NO-APPLY.
  END.

    RUN ue-procesar.
    RUN ue-excel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-5
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
  DISPLAY txtAlmacenes CboProveedor txtEvaluacion 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-7 RECT-8 txtAlmacenes BROWSE-6 BROWSE-5 btnFamTodos btnFamNinguno 
         btnMarTodos btnMarNinguno CboProveedor BtnProcesar txtEvaluacion 
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

          DO WITH FRAME {&FRAME-NAME}.
              /*
              cboLinea:DELIMITER = "|".
              cboSubLinea:DELIMITER = "|".
              cboMarca:DELIMITER = "|".
              */
              cboProveedor:DELIMITER = "|".
          END.

    SESSION:SET-WAIT-STATE('GENERAL').
/*
          cboLinea:DELETE(CboLinea:LIST-ITEMS) IN FRAME {&FRAME-NAME}.
          cboLinea:ADD-LAST('Todos').
          cboLinea:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Todos'.
  
        FOR EACH almtfami WHERE almtfami.codcia = s-codcia NO-LOCK:
            cboLinea:ADD-LAST(almtfami.codfam + ' - ' + AlmtFami.desfam).
        END.

    cboSubLinea:DELETE(CboSubLinea:LIST-ITEMS) IN FRAME {&FRAME-NAME}.
    cboSubLinea:ADD-LAST('Todos').
    cboSubLinea:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Todos'.

    /* Marca */
    cboMarca:DELETE(CboMarca:LIST-ITEMS) IN FRAME {&FRAME-NAME}.
    cboMarca:ADD-LAST('Todos').
    cboMarca:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Todos'.

  FOR EACH almtabla WHERE almtabla.tabla = 'MK' NO-LOCK BY nombre :
      cboMarca:ADD-LAST(almtabla.codigo + ' - ' + Almtabla.nombre).
  END.
*/
  /* Proveedores */
  cboProveedor:DELETE(CboProveedor:LIST-ITEMS) IN FRAME {&FRAME-NAME}.
  cboProveedor:ADD-LAST('Todos').
  cboProveedor:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Todos'.
  FOR EACH gn-prov WHERE gn-prov.codcia = 0 AND 
                        gn-prov.flgsit <> 'C' NO-LOCK BY nompro:
        cboProveedor:ADD-LAST(gn-prov.codpro + ' - ' + gn-prov.nompro).
  END.

  SESSION:SET-WAIT-STATE('').

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
  {src/adm/template/snd-list.i "almtabla"}
  {src/adm/template/snd-list.i "Almtfami"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-excel W-Win 
PROCEDURE ue-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST tt-qstock NO-ERROR.

IF NOT AVAILABLE tt-qstock THEN DO:
    MESSAGE "No  existe data".
    RETURN.
END.

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */


c-xls-file = lxFile.

run pi-crea-archivo-csv IN hProc (input  buffer tt-qstock:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-qstock:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.

MESSAGE "Proceso Concluido".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-procesar W-Win 
PROCEDURE ue-procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR rpta AS LOG.

SYSTEM-DIALOG GET-FILE lxFile
    FILTERS 'Excel (*.xlsx)' '*.xlsx'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.xlsx'
    RETURN-TO-START-DIR
    SAVE-AS
    TITLE 'Exportar a Excel'
    UPDATE rpta.
IF rpta = NO OR lxFile = '' THEN RETURN.


/**/

SESSION:SET-WAIT-STATE('GENERAL').

DEFINE VAR lxSec AS INT.
DEFINE VAR lxAlmacen AS CHAR.
DEFINE VAR lxLinea AS CHAR.
DEFINE VAR lxSubLinea AS CHAR.
DEFINE VAR lxMarca AS CHAR.
DEFINE VAR lxProveedor AS CHAR.

DEFINE VAR lxStkReservado AS DEC.
DEFINE VAR lxStkDisponible AS DEC.
DEFINE VAR lxStkevaluacion AS DEC.
DEFINE VAR lxTransfxrecep AS DEC.

DEFINE VAR lVtas15DiasAntes AS DEC.
DEFINE VAR lVtas30DiasAntes AS DEC.
DEFINE VAR lVtas45DiasAntes AS DEC.
DEFINE VAR lFechaDesde AS DATE.
DEFINE VAR lFechaHasta AS DATE.

DEFINE VAR lSeleRow AS INT.
DEFINE VAR lFams AS CHAR INIT "".
DEFINE VAR lMarcas AS CHAR INIT "".

EMPTY TEMP-TABLE tt-qstock.

lxProveedor = cboProveedor.

IF lxProveedor <> "Todos" THEN DO:
    lxSec = INDEX(cboProveedor," - ").
    IF lxSec > 0 THEN DO:
        lxProveedor = SUBSTRING(cboProveedor,1,lxSec - 1).
    END.
END.
    
DO lSeleRow = 1 TO BROWSE-5:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF BROWSE-5:FETCH-SELECTED-ROW(lSeleRow) IN FRAME {&FRAME-NAME} THEN DO:
        IF lFams = "" THEN DO:
            lFams = almtfami.codfam.
        END.
        ELSE lFams = lFams + "," + almtfami.codfam.                    
    END.
END.
DO lSeleRow = 1 TO BROWSE-6:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF BROWSE-6:FETCH-SELECTED-ROW(lSeleRow) IN FRAME {&FRAME-NAME} THEN DO:
        IF lMarcas = "" THEN DO:
            lMarcas = almtabla.codigo.
        END.
        ELSE lMarcas = lMarcas + "," + almtabla.codigo.                    
    END.
END.

DO lxSec = 1 TO NUM-ENTRIES(txtAlmacenes,","):
    lxAlmacen = ENTRY(lxSec,txtAlmacenes,",").

    FOR EACH almmmate WHERE almmmate.codcia = s-codcia AND
                            almmmate.codalm = lxAlmacen
                            NO-LOCK,
                FIRST almmmatg OF almmmate 
                        WHERE   almmmatg.tpoart <> 'D' AND 
                                LOOKUP(almmmatg.codfam,lFams) > 0 AND                                
                                LOOKUP(almmmatg.codmar,lMarcas) > 0 AND
                                (lxProveedor = 'Todos' OR almmmatg.codpr1 = lxProveedor)
                                NO-LOCK,                                
                FIRST almtfam OF almmmatg NO-LOCK,
                FIRST almsfam OF almmmatg NO-LOCK,
                FIRST almacen OF almmmate NO-LOCK :

        FIND FIRST gn-prov WHERE gn-prov.codcia = 0 AND 
                                gn-prov.codpro = almmmatg.codpr1 NO-LOCK NO-ERROR.

        lxStkReservado = 0.
        RUN vta2/stock-comprometido-v2.r(INPUT almmmate.codmat, INPUT lxAlmacen, OUTPUT lxStkReservado).

        lxTransfxRecep = 0.
        RUN alm/pedidoreposicionentransito.r(INPUT almmmate.codmat, INPUT lxAlmacen, OUTPUT lxTransfxRecep).

        lxStkDisponible = almmmate.stkact - lxStkReservado.
        lxStkEvaluacion = (almmmate.stkmin * txtEvaluacion ) / 100.

        /* Ranking */
        FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                                    factabla.tabla = 'RANKVTA' AND 
                                    factabla.codigo = almmmate.codmat
                                    NO-LOCK NO-ERROR.
        IF almmmate.stkmin > 0 AND lxStkDisponible <= lxStkEvaluacion THEN DO:
            CREATE tt-qstock.
                ASSIGN  tt-codalm = lxAlmacen
                     tt-desalm    = almacen.descripcion
                     tt-proveedor = IF (AVAILABLE gn-prov) THEN gn-prov.nompro ELSE ""
                     tt-linea     = almmmatg.codfam + " " + almtfam.desfam
                     tt-sublinea  = almmmatg.subfam + " " + almsfam.dessub                     
                     tt-codmat    = almmmate.codmat
                     tt-desmat    = almmmatg.desmat
                     tt-marca     = almmmatg.desmar
                     tt-umed      = almmmatg.undstk
                     tt-costrepo  = almmmatg.ctolis
                     tt-stkmax    = almmmate.VinMn1
                     tt-stkseg    = almmmate.VinMn2
                     tt-emprep    = almmmate.stkmax
                     tt-stkfisico = almmmate.stkact
                     tt-stkreser  = lxStkReservado
                     tt-stkdispo  = lxStkDisponible
                     tt-stktrftra = lxTransfxRecep.

                ASSIGN     tt-stkfalta  = almmmate.stkmin - lxStkDisponible - lxTransfxRecep.
                ASSIGN     tt-stkt11    = fStock-disponible(almmmate.codmat, "11").
                ASSIGN     tt-stkt11max  = fstock-maximo(almmmate.codmat, "11").
                ASSIGN     tt-stkt11seg  = fstock-seguridad(almmmate.codmat, "11").
                ASSIGN     tt-stkt35    = fStock-disponible(almmmate.codmat, "35").
                ASSIGN     tt-stkt35max  = fstock-maximo(almmmate.codmat, "35").
                ASSIGN     tt-stkt35seg  = fstock-seguridad(almmmate.codmat, "35").
                ASSIGN     tt-stkt14    = fStock-disponible(almmmate.codmat, "14").
                ASSIGN     tt-stkt14f   = fStock-disponible(almmmate.codmat, "14f").
                ASSIGN     tt-stkt21    = fStock-disponible(almmmate.codmat, "21").

                ASSIGN     tt-vstkmax   = almmmate.stkmin * almmmatg.ctolis
                     tt-vsfisico  = almmmate.stkact * almmmatg.ctolis
                     tt-vsdispo     = lxStkDisponible * almmmatg.ctolis
                     tt-vstrans     = lxTransfxRecep * almmmatg.ctolis                     
                     tt-costfalta   = tt-stkfalta * almmmatg.ctolis.

                    /* 11Jul2017, Max pidio que saquen esta restriccion */
                     /*IF tt-costfalta < 0 THEN tt-costfalta = 0.*/

             /* Año ACTUAL */
             lFechaDesde = TODAY - 45.
             lFechaHasta = TODAY.

             RUN ue-ventas(INPUT lxAlmacen, INPUT almmmatg.codmat, 
                            INPUT lFechaDesde, INPUT lFechaHasta,
                           OUTPUT lVtas15DiasAntes, OUTPUT lVtas30DiasAntes,
                           OUTPUT lVtas45DiasAntes).

             ASSIGN tt-vta15dant = lVtas15DiasAntes
                    tt-vta30dant = lVtas30DiasAntes
                    tt-vta45dant = lVtas45DiasAntes.

             /* Año ANTERIOR */             
             lFechaHasta = DATE(MONTH(TODAY),DAY(TODAY),YEAR(TODAY) - 1).
             lFechaDesde = lFechaHasta - 30.

             RUN ue-ventas(INPUT lxAlmacen, INPUT almmmatg.codmat, 
                            INPUT lFechaDesde, INPUT lFechaHasta,
                           OUTPUT lVtas15DiasAntes, OUTPUT lVtas30DiasAntes,
                           OUTPUT lVtas45DiasAntes).

             ASSIGN tt-v30daante = lVtas30DiasAntes.

            ASSIGN   tt-fv30_max    = if(tt-stkmax > 0) THEN tt-vta30dant / tt-stkmax ELSE 0.
            ASSIGN   tt-fv30p_max    = if(tt-stkmax > 0) THEN tt-v30daante / tt-stkmax ELSE 0.

                                                                                            .
              IF AVAILABLE factabla THEN DO:
                  ASSIGN    tt-cgrlc    = factabla.campo-c[1]
                            tt-cmayc    = factabla.campo-c[3]
                            tt-cutxc    = factabla.campo-c[2]
                            tt-cgrlnc   = factabla.campo-c[4]
                            tt-cmaync   = factabla.campo-c[6]
                            tt-cutxnc   = factabla.campo-c[5].
              END.
        END.

    END.
END.

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-ventas W-Win 
PROCEDURE ue-ventas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodAlm AS CHAR.
DEFINE INPUT PARAMETER pCodMat AS CHAR.
DEFINE INPUT PARAMETER pFechaDesde AS DATE.
DEFINE INPUT PARAMETER pFechaHasta AS DATE.
DEFINE OUTPUT PARAMETER pVtas15Dias AS DEC.
DEFINE OUTPUT PARAMETER pVtas30Dias AS DEC.
DEFINE OUTPUT PARAMETER pVtas45Dias AS DEC.

DEFINE VAR lContador AS INT INIT 0.

DEFINE VAR lFecha AS DATE.

pVtas15Dias = 0.
pVtas30Dias = 0.
pVtas45Dias = 0.

REPEAT lFecha = pFechaDesde TO pFechahasta :
    lContador = lContador + 1.
    FOR EACH almdmov USE-INDEX almd03
                        WHERE almdmov.codcia = s-codcia AND 
                                almdmov.codalm = pCodAlm AND 
                                almdmov.codmat = pCodmat AND 
                                almdmov.fchdoc = lFecha AND 
                                almdmov.tipmov = 'S' AND 
                                almdmov.codmov = 2 NO-LOCK:
        
        IF lContador <= 15 THEN pVtas15Dias = pVtas15Dias + (almdmov.candes * almdmov.factor).
        IF lContador <= 30 THEN pVtas30Dias = pVtas30Dias + (almdmov.candes * almdmov.factor).
        IF lContador <= 45 THEN pVtas45Dias = pVtas45Dias + (almdmov.candes * almdmov.factor).
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fStock-disponible W-Win 
FUNCTION fStock-disponible RETURNS DECIMAL
  ( INPUT pCodMat AS CHAR, INPUT pCodAlm AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR lRetVal AS DEC.
DEFINE VAR lStkReservado AS DEC.

lRetVal = 0.

DEFINE BUFFER ix-almmmate FOR almmmate.

FIND FIRST ix-almmmate WHERE ix-almmmate.codcia = s-codcia AND 
            ix-almmmate.codalm = pCodAlm AND 
            ix-almmmate.codmat = pCodMat NO-LOCK NO-ERROR.
IF AVAILABLE ix-almmmate  THEN DO:
    lRetVal = ix-almmmate.stkact.
END.

RELEASE ix-almmmate.

lStkReservado = 0.
RUN vta2/stock-comprometido-v2.r(INPUT pCodMat, INPUT pCodAlm, OUTPUT lStkReservado).

lRetVal = lRetVal - lStkReservado.

RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fstock-maximo W-Win 
FUNCTION fstock-maximo RETURNS DECIMAL
  ( INPUT pCodMat AS CHAR, INPUT pCodAlm AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR lRetVal AS DEC.
DEFINE VAR lStkReservado AS DEC.

lRetVal = 0.

DEFINE BUFFER ix-almmmate FOR almmmate.

FIND FIRST ix-almmmate WHERE ix-almmmate.codcia = s-codcia AND 
            ix-almmmate.codalm = pCodAlm AND 
            ix-almmmate.codmat = pCodMat NO-LOCK NO-ERROR.
IF AVAILABLE ix-almmmate  THEN DO:
    lRetVal = ix-almmmate.VInMn1.    /*ix-almmmate.stkmin.*/
END.

RELEASE ix-almmmate.

RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fstock-seguridad W-Win 
FUNCTION fstock-seguridad RETURNS DECIMAL
  ( INPUT pCodMat AS CHAR, INPUT pCodAlm AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR lRetVal AS DEC.
DEFINE VAR lStkReservado AS DEC.

lRetVal = 0.

DEFINE BUFFER ix-almmmate FOR almmmate.

FIND FIRST ix-almmmate WHERE ix-almmmate.codcia = s-codcia AND 
            ix-almmmate.codalm = pCodAlm AND 
            ix-almmmate.codmat = pCodMat NO-LOCK NO-ERROR.
IF AVAILABLE ix-almmmate  THEN DO:
    lRetVal = ix-almmmate.VInMn2. 
END.

RELEASE ix-almmmate.

RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

