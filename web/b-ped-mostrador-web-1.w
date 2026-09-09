&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.



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

/*&SCOPED-DEFINE precio-venta-general pri/PrecioVentaMayorContadoFlash.p*/
&SCOPED-DEFINE precio-venta-general web/PrecioFinalContadoMayorista.p

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codcli AS CHAR.
DEF SHARED VAR s-codmon AS INTE.
DEF SHARED VAR s-tpocmb AS DECI.
DEF SHARED VAR s-flgsit AS CHAR.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-nrodec AS INTE.
DEF SHARED VAR s-porigv AS DECI.
DEF SHARED VAR s-FlgEmpaque AS LOG.
DEF SHARED VAR s-FlgMinVenta AS LOG.
DEF SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEF SHARED VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEF SHARED VAR s-tpoped AS CHAR.

DEF VAR x-CodAlm AS CHAR NO-UNDO.

DEF VAR LocalCadena AS CHAR NO-UNDO.

&SCOPED-DEFINE Condicion ( Almmmatg.CodCia = s-CodCia AND ~
( TRUE <> (LocalCadena > '') OR Almmmatg.DesMat CONTAINS LocalCadena ) ) AND ~
    Almmmatg.tpoart = "A" AND ~
    (COMBO-BOX-CodFam BEGINS 'Seleccione' OR Almmmatg.codfam = COMBO-BOX-CodFam) AND ~
    (TRUE <> (Almmmatg.TpoMrg > '') OR Almmmatg.TpoMrg = '1')

DEF VAR x-Texto AS CHAR FORMAT 'x(10)' NO-UNDO.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\Coti.ico" SIZE 12 BY 1.5.
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


DEF VAR x-Detalle AS CHAR FORMAT 'x(20)' NO-UNDO.
DEF BUFFER B-ITEM FOR ITEM.

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
&Scoped-define INTERNAL-TABLES Almmmatg Almmmate ITEM

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Almmmatg.codmat Almmmatg.DesMat ~
Almmmatg.DesMar ~
(IF Almmmate.StkAct <= 0 THEN 'SIN STOCK' ELSE 'CON STOCK') @ x-Texto ~
'Alm:' + STRING(ITEM.AlmDes,'x(8)') + TRIM(STRING(ITEM.CanPed,'>>>,>>>,>>9.99') + ' ' + ITEM.UndVta)  @ x-Detalle 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH Almmmatg WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST Almmmate OF Almmmatg ~
      WHERE Almmmate.CodAlm = x-CodAlm ~
 /*AND Almmmate.StkAct > 0*/ NO-LOCK, ~
      FIRST ITEM WHERE ITEM.CodCia = Almmmatg.CodCia ~
  AND ITEM.codmat = Almmmatg.codmat OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Almmmatg WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST Almmmate OF Almmmatg ~
      WHERE Almmmate.CodAlm = x-CodAlm ~
 /*AND Almmmate.StkAct > 0*/ NO-LOCK, ~
      FIRST ITEM WHERE ITEM.CodCia = Almmmatg.CodCia ~
  AND ITEM.codmat = Almmmatg.codmat OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table Almmmatg Almmmate ITEM
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmate
&Scoped-define THIRD-TABLE-IN-QUERY-br_table ITEM


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE_Producto RECT-1 COMBO-BOX-CodAlm ~
BUTTON-Refresh COMBO-BOX-CodFam FILL-IN-DesMat br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodAlm COMBO-BOX-CodFam ~
FILL-IN-DesMat FILL-IN_UndA FILL-IN_PreUniA FILL-IN_UndB FILL-IN_PreUniB ~
FILL-IN_UndC FILL-IN_PreUniC FILL-IN_ImpTot 

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
DEFINE BUTTON BUTTON-Refresh 
     LABEL "REFRESCAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX-CodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacén" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-CodFam AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione línea" 
     LABEL "Línea" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Seleccione línea","Seleccione línea"
     DROP-DOWN-LIST
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Buscar" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpTot AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY 1.35
     FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN_PreUniA AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Precio Unitario" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_PreUniB AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Precio Unitario" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_PreUniC AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Precio Unitario" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_UndA AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unidad" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_UndB AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unidad" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_UndC AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unidad" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     FONT 6 NO-UNDO.

DEFINE IMAGE IMAGE_Producto
     FILENAME "productos/002906.jpg":U
     STRETCH-TO-FIT
     SIZE 36 BY 8.35.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 13.46
     BGCOLOR 15 FGCOLOR 0 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Almmmatg, 
      Almmmate
    FIELDS(Almmmate.StkAct), 
      ITEM SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Almmmatg.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U WIDTH 8.43
      Almmmatg.DesMat FORMAT "X(100)":U WIDTH 60.43
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U WIDTH 22.43
      (IF Almmmate.StkAct <= 0 THEN 'SIN STOCK' ELSE 'CON STOCK') @ x-Texto COLUMN-LABEL "Observaciones"
            WIDTH 13.43
      'Alm:' + STRING(ITEM.AlmDes,'x(8)') + TRIM(STRING(ITEM.CanPed,'>>>,>>>,>>9.99') + ' ' + ITEM.UndVta)  @ x-Detalle COLUMN-LABEL "Cantidad"
            WIDTH 20.72 COLUMN-FONT 6
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 131 BY 15.88
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-CodAlm AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 148
     BUTTON-Refresh AT ROW 1.54 COL 102 WIDGET-ID 150
     COMBO-BOX-CodFam AT ROW 2.35 COL 19 COLON-ALIGNED WIDGET-ID 126
     FILL-IN-DesMat AT ROW 3.42 COL 19 COLON-ALIGNED WIDGET-ID 128
     br_table AT ROW 4.5 COL 2
     FILL-IN_UndA AT ROW 13.92 COL 143 COLON-ALIGNED WIDGET-ID 132
     FILL-IN_PreUniA AT ROW 13.92 COL 163 COLON-ALIGNED WIDGET-ID 134
     FILL-IN_UndB AT ROW 15 COL 143 COLON-ALIGNED WIDGET-ID 138
     FILL-IN_PreUniB AT ROW 15 COL 163 COLON-ALIGNED WIDGET-ID 136
     FILL-IN_UndC AT ROW 16.08 COL 143 COLON-ALIGNED WIDGET-ID 142
     FILL-IN_PreUniC AT ROW 16.08 COL 163 COLON-ALIGNED WIDGET-ID 140
     FILL-IN_ImpTot AT ROW 18.77 COL 159 COLON-ALIGNED NO-LABEL WIDGET-ID 146
     "TOTAL S/:" VIEW-AS TEXT
          SIZE 17 BY 1.35 AT ROW 18.77 COL 143 WIDGET-ID 6
          FONT 8
     IMAGE_Producto AT ROW 5.31 COL 141 WIDGET-ID 130
     RECT-1 AT ROW 4.5 COL 136 WIDGET-ID 144
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
   Temp-Tables and Buffers:
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
   END-TABLES.
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
         HEIGHT             = 20.23
         WIDTH              = 190.14.
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
/* BROWSE-TAB br_table FILL-IN-DesMat F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR FILL-IN FILL-IN_ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_PreUniA IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_PreUniB IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_PreUniC IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_UndA IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_UndB IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_UndC IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.Almmmatg,INTEGRAL.Almmmate OF INTEGRAL.Almmmatg,Temp-Tables.ITEM WHERE INTEGRAL.Almmmatg ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST USED, FIRST OUTER"
     _Where[1]         = "{&Condicion}"
     _Where[2]         = "Almmmate.CodAlm = x-CodAlm
 /*AND Almmmate.StkAct > 0*/"
     _JoinCode[3]      = "Temp-Tables.ITEM.CodCia = Almmmatg.CodCia
  AND Temp-Tables.ITEM.codmat = Almmmatg.codmat"
     _FldNameList[1]   > INTEGRAL.Almmmatg.codmat
"INTEGRAL.Almmmatg.codmat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"INTEGRAL.Almmmatg.DesMat" ? "X(100)" "character" ? ? ? ? ? ? no ? no no "60.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"INTEGRAL.Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no "22.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"(IF Almmmate.StkAct <= 0 THEN 'SIN STOCK' ELSE 'CON STOCK') @ x-Texto" "Observaciones" ? ? ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"'Alm:' + STRING(ITEM.AlmDes,'x(8)') + TRIM(STRING(ITEM.CanPed,'>>>,>>>,>>9.99') + ' ' + ITEM.UndVta)  @ x-Detalle" "Cantidad" ? ? ? ? 6 ? ? ? no ? no no "20.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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

  RUN Pinta_Precio_Unidades.
  
  DEF VAR x-Imagen AS CHAR NO-UNDO.

  x-Imagen = "Productos\" + TRIM(Almmmatg.codmat) + ".jpg".

  IF SEARCH(x-Imagen) <> ? THEN IMAGE_Producto:LOAD-IMAGE(x-Imagen).
  ELSE DO:
      x-Imagen = "Productos\ProdImg.bmp".
      IF SEARCH(x-Imagen) <> ? THEN IMAGE_Producto:LOAD-IMAGE(x-Imagen).
  END.

  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Refresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Refresh B-table-Win
ON CHOOSE OF BUTTON-Refresh IN FRAME F-Main /* REFRESCAR */
DO:
    /* Armamos la cadena */
    DEF VAR LocalOrden AS INTE NO-UNDO.

    LocalCadena = "".
    DO LocalOrden = 1 TO NUM-ENTRIES(FILL-IN-DesMat:SCREEN-VALUE, " "):
        LocalCadena = LocalCadena + (IF TRUE <> (LocalCadena > '') THEN "" ELSE " ") + 
            TRIM(ENTRY(LocalOrden,FILL-IN-DesMat:SCREEN-VALUE, " ")) + "*".
    END.
    LocalCadena = REPLACE(LocalCadena, 'z*', '*').
    
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodAlm B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-CodAlm IN FRAME F-Main /* Almacén */
DO:
  ASSIGN {&self-name}.
  x-CodAlm = SELF:SCREEN-VALUE.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodFam B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-CodFam IN FRAME F-Main /* Línea */
DO:
  ASSIGN {&self-name}.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-DesMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-DesMat B-table-Win
ON ANY-PRINTABLE OF FILL-IN-DesMat IN FRAME F-Main /* Buscar */
DO:
  ASSIGN {&self-name}.

  /* Armamos la cadena */
  DEF VAR LocalOrden AS INTE NO-UNDO.

  LocalCadena = "".
  DO LocalOrden = 1 TO NUM-ENTRIES(SELF:SCREEN-VALUE, " "):
      LocalCadena = LocalCadena + (IF TRUE <> (LocalCadena > '') THEN "" ELSE " ") + 
          TRIM(ENTRY(LocalOrden,SELF:SCREEN-VALUE, " ")) + "*".
  END.
  LocalCadena = REPLACE(LocalCadena, 'z*', '*').
  IF Localcadena > '' THEN RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-DesMat B-table-Win
ON LEAVE OF FILL-IN-DesMat IN FRAME F-Main /* Buscar */
DO:
  ASSIGN {&SELF-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RECT-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RECT-1 B-table-Win
ON MOUSE-SELECT-CLICK OF RECT-1 IN FRAME F-Main
DO:
  IF AVAILABLE Almmmatg AND Almmmate.StkAct > 0 THEN DO:
      RUN web/d-ped-mostrador-web-1 (INPUT Almmmatg.codmat, INPUT x-CodAlm, INPUT-OUTPUT TABLE ITEM).
      x-Detalle = ''.
      FIND FIRST ITEM WHERE ITEM.codmat = Almmmatg.codmat NO-LOCK NO-ERROR.
      IF AVAILABLE ITEM THEN x-Detalle = 'Alm:' + STRING(ITEM.AlmDes,'x(8)') + TRIM(STRING(ITEM.CanPed,'>>>,>>>,>>9.99') + " " + ITEM.UndVta).
      DISPLAY x-Detalle WITH BROWSE {&browse-name}.
      RUN Pinta-Total.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

/* ON FIND OF Almmmatg DO:                                                                                                                      */
/*     x-Detalle = ''.                                                                                                                          */
/*     FIND FIRST ITEM WHERE ITEM.codcia = s-codcia AND                                                                                         */
/*         ITEM.codmat = Almmmatg.codmat NO-LOCK NO-ERROR.                                                                                      */
/*                                                                                                                                              */
/*     IF AVAILABLE ITEM THEN x-Detalle = 'Alm:' + STRING(ITEM.AlmDes,'x(8)') + TRIM(STRING(ITEM.CanPed,'>>>,>>>,>>9.99') + " " + ITEM.UndVta). */
/* END.                                                                                                                                         */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Devuelve-Temp-Table B-table-Win 
PROCEDURE Devuelve-Temp-Table :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER TABLE FOR ITEM.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Import-Temp-Table B-table-Win 
PROCEDURE Import-Temp-Table :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER TABLE FOR ITEM.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).
/*{&OPEN-QUERY-{&BROWSE-NAME}}*/

RUN Pinta-Total.

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
      DEF VAR X AS CHAR NO-UNDO.
      DEF VAR i AS INTE NO-UNDO.
      DEF VAR j AS INTE NO-UNDO.

      COMBO-BOX-CodAlm:DELIMITER = CHR(9).
      COMBO-BOX-CodAlm:DELETE(1).
      DO i = 1 TO NUM-ENTRIES(s-CodAlm):
          X = ENTRY(i, s-CodAlm).
          FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = X NO-LOCK NO-ERROR.
          IF AVAILABLE Almacen THEN DO:
              COMBO-BOX-CodAlm:ADD-LAST(Almacen.Descripcion, Almacen.CodAlm).
              IF j = 0 THEN ASSIGN COMBO-BOX-CodAlm = Almacen.CodAlm x-CodAlm = Almacen.CodAlm.
              j = j + 1.
          END.
      END.
      COMBO-BOX-CodFam:DELIMITER = CHR(9).
      FOR EACH Almtfami NO-LOCK WHERE Almtfami.CodCia = s-codcia AND Almtfami.SwComercial = YES:
          COMBO-BOX-CodFam:ADD-LAST(Almtfami.desfam, Almtfami.codfam).
      END.

  END.
  x-codalm = '03'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pinta-Total B-table-Win 
PROCEDURE Pinta-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
     FILL-IN_ImpTot = 0.
     FOR EACH ITEM:
         FILL-IN_ImpTot = FILL-IN_ImpTot + ITEM.ImpLin.
     END.
     DISPLAY  FILL-IN_ImpTot.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pinta_Precio_Unidades B-table-Win 
PROCEDURE Pinta_Precio_Unidades :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Almmmatg THEN RETURN.

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        FILL-IN_PreUniA = 0
        FILL-IN_PreUniB = 0
        FILL-IN_PreUniC = 0
        FILL-IN_UndA = ''
        FILL-IN_UndB = ''
        FILL-IN_UndC = ''.
    DISPLAY FILL-IN_UndA FILL-IN_UndB FILL-IN_UndC.
    DISPLAY FILL-IN_PreUniA FILL-IN_PreUniB FILL-IN_PreUniC.
    ASSIGN
        FILL-IN_UndA = Almmmatg.UndA 
        FILL-IN_UndB = Almmmatg.UndB 
        FILL-IN_UndC = Almmmatg.UndC.
    /* Precios */
  /* ***************************************************************************************************************** */
  /* 22/05/2023 PRECIO UNITARIO */
  /* ***************************************************************************************************************** */
  DEF VAR f-Factor LIKE Facdpedi.factor NO-UNDO.
  DEF VAR f-CanPed LIKE Facdpedi.canped NO-UNDO.
  DEF VAR f-PreBas AS DECI NO-UNDO.
  DEF VAR f-PreVta AS DECI NO-UNDO.
  DEF VAR f-Dsctos AS DECI NO-UNDO.
  DEF VAR y-Dsctos AS DECI NO-UNDO.
  DEF VAR x-TipDto AS CHAR NO-UNDO.
  DEF VAR f-FleteUnitario AS DECI NO-UNDO.
  DEF VAR pMensaje AS CHAR NO-UNDO.
  DEF VAR s-UndVta AS CHAR NO-UNDO.
  DEF VAR x-Factor AS DECI NO-UNDO.
  /* Unidad A */
  f-CanPed = 1.
  IF Almmmatg.UndA > '' THEN DO:
      s-UndVta = Almmmatg.UndA.
      RUN {&precio-venta-general} (s-CodCia,
                                   s-CodDiv,
                                   s-CodCli,
                                   s-CodMon,
                                   s-TpoCmb,
                                   OUTPUT f-Factor,
                                   Almmmatg.codmat,
                                   s-FlgSit,
                                   s-UndVta,
                                   f-CanPed,
                                   s-NroDec,
                                   x-CodAlm,
                                   OUTPUT f-PreBas,
                                   OUTPUT f-PreVta,
                                   OUTPUT f-Dsctos,
                                   OUTPUT y-Dsctos,
                                   OUTPUT x-TipDto,
                                   OUTPUT f-FleteUnitario,
                                   OUTPUT pMensaje
                                   ).
      IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN.
      x-Factor = f-Factor.
      IF f-PreVta > 0 THEN FILL-IN_PreUniA = f-PreVta.
      /* Unidad B */
      IF Almmmatg.UndB > '' THEN DO:
          FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas AND
              Almtconv.Codalter = Almmmatg.UndB NO-LOCK NO-ERROR.
          IF AVAILABLE Almtconv THEN DO:
              FILL-IN_PreUniB = f-PreVta / x-factor * Almtconv.Equival.
          END.
      END.
      /* Unidad C */
      IF Almmmatg.UndC > '' THEN DO:
          FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas AND
              Almtconv.Codalter = Almmmatg.UndC NO-LOCK NO-ERROR.
          IF AVAILABLE Almtconv THEN DO:
              FILL-IN_PreUniC = f-PreVta / x-factor * Almtconv.Equival.
          END.
      END.
  END.
/*   IF Almmmatg.UndB > '' THEN DO:                           */
/*       s-UndVta = Almmmatg.UndB.                            */
/*       RUN {&precio-venta-general} (s-CodCia,               */
/*                                    s-CodDiv,               */
/*                                    s-CodCli,               */
/*                                    s-CodMon,               */
/*                                    s-TpoCmb,               */
/*                                    OUTPUT f-Factor,        */
/*                                    Almmmatg.codmat,        */
/*                                    s-FlgSit,               */
/*                                    s-UndVta,               */
/*                                    f-CanPed,               */
/*                                    s-NroDec,               */
/*                                    x-CodAlm,               */
/*                                    OUTPUT f-PreBas,        */
/*                                    OUTPUT f-PreVta,        */
/*                                    OUTPUT f-Dsctos,        */
/*                                    OUTPUT y-Dsctos,        */
/*                                    OUTPUT x-TipDto,        */
/*                                    OUTPUT f-FleteUnitario, */
/*                                    OUTPUT pMensaje         */
/*                                    ).                      */
/*       IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN.           */
/*       IF f-PreVta > 0 THEN FILL-IN_PreUniB = f-PreVta.     */
/*   END.                                                     */
/*   IF Almmmatg.UndC > '' THEN DO:                           */
/*       s-UndVta = Almmmatg.UndC.                            */
/*       RUN {&precio-venta-general} (s-CodCia,               */
/*                                    s-CodDiv,               */
/*                                    s-CodCli,               */
/*                                    s-CodMon,               */
/*                                    s-TpoCmb,               */
/*                                    OUTPUT f-Factor,        */
/*                                    Almmmatg.codmat,        */
/*                                    s-FlgSit,               */
/*                                    s-UndVta,               */
/*                                    f-CanPed,               */
/*                                    s-NroDec,               */
/*                                    x-CodAlm,               */
/*                                    OUTPUT f-PreBas,        */
/*                                    OUTPUT f-PreVta,        */
/*                                    OUTPUT f-Dsctos,        */
/*                                    OUTPUT y-Dsctos,        */
/*                                    OUTPUT x-TipDto,        */
/*                                    OUTPUT f-FleteUnitario, */
/*                                    OUTPUT pMensaje         */
/*                                    ).                      */
/*       IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN.           */
/*       IF f-PreVta > 0 THEN FILL-IN_PreUniC = f-PreVta.     */
/*   END.                                                     */
  DISPLAY FILL-IN_UndA FILL-IN_UndB FILL-IN_UndC.
  DISPLAY FILL-IN_PreUniA FILL-IN_PreUniB FILL-IN_PreUniC.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Precios B-table-Win 
PROCEDURE Recalcular-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

               
DEF VAR F-FACTOR AS DECI NO-UNDO.
DEF VAR F-PREVTA AS DECI NO-UNDO.
DEF VAR F-PreBas AS DECI NO-UNDO.
DEF VAR F-DSCTOS AS DECI NO-UNDO.
DEF VAR z-Dsctos AS DECI NO-UNDO.
DEF VAR Y-DSCTOS AS DECI NO-UNDO.
DEF VAR x-TipDto AS CHAR NO-UNDO.
DEF VAR f-FleteUnitario AS DECI NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.

/* ARTIFICIO */
Fi-Mensaje = "RECALCULANDO PRECIOS".
DISPLAY Fi-Mensaje WITH FRAME F-Proceso.

FOR EACH ITEM WHERE ITEM.Libre_c05 <> "OF",     /* NO promociones */
    FIRST Almmmatg OF ITEM NO-LOCK:
    ASSIGN
        F-FACTOR = ITEM.Factor
        f-PreVta = ITEM.PreUni
        f-PreBas = ITEM.PreBas
        f-Dsctos = ITEM.PorDto
        z-Dsctos = ITEM.Por_Dsctos[2]
        y-Dsctos = ITEM.Por_Dsctos[3].
    RUN {&precio-venta-general} (s-CodCia,
                                 s-CodDiv,
                                 s-CodCli,
                                 s-CodMon,
                                 s-TpoCmb,
                                 OUTPUT f-Factor,
                                 ITEM.codmat,
                                 s-FlgSit,
                                 ITEM.undvta,
                                 ITEM.CanPed,
                                 s-NroDec,
                                 ITEM.almdes,   /* Necesario para REMATES */
                                 OUTPUT f-PreBas,
                                 OUTPUT f-PreVta,
                                 OUTPUT f-Dsctos,
                                 OUTPUT y-Dsctos,
                                 OUTPUT x-TipDto,
                                 OUTPUT f-FleteUnitario,
                                 OUTPUT pMensaje
                                 ).
    ASSIGN 
        ITEM.Factor = f-Factor
        ITEM.PreUni = F-PREVTA
        ITEM.PreBas = F-PreBas 
        ITEM.PreVta[1] = F-PreVta     /* CONTROL DE PRECIO DE LISTA */
        ITEM.PorDto = F-DSCTOS  /* Ambos descuentos afectan */
        ITEM.PorDto2 = 0        /* el precio unitario */
        ITEM.Por_Dsctos[2] = z-Dsctos
        ITEM.Por_Dsctos[3] = Y-DSCTOS 
        ITEM.AftIgv = Almmmatg.AftIgv
        ITEM.AftIsc = Almmmatg.AftIsc
        ITEM.ImpIsc = 0
        ITEM.ImpIgv = 0.
    ASSIGN
        ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                    ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
    IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
        THEN ITEM.ImpDto = 0.
    ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.

    ASSIGN 
        ITEM.Libre_d02 = f-FleteUnitario. 
    IF f-FleteUnitario > 0 THEN DO:
        /* El flete afecta el monto final */
        IF ITEM.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
            ASSIGN
                ITEM.PreUni = ROUND(f-PreVta + f-FleteUnitario, s-NroDec)  /* Incrementamos el PreUni */
                ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni.
        END.
        ELSE DO:      /* CON descuento promocional o volumen */
          /* El flete afecta al precio unitario resultante */
          DEF VAR x-PreUniFin LIKE Facdpedi.PreUni NO-UNDO.
          DEF VAR x-PreUniTeo LIKE Facdpedi.PreUni NO-UNDO.

          x-PreUniFin = ITEM.ImpLin / ITEM.CanPed.          /* Valor resultante */
          x-PreUniFin = x-PreUniFin + f-FleteUnitario.      /* Unitario Afectado al Flete */

          x-PreUniTeo = x-PreUniFin / ( ( 1 - ITEM.Por_Dsctos[1] / 100 ) * ( 1 - ITEM.Por_Dsctos[2] / 100 ) * ( 1 - ITEM.Por_Dsctos[3] / 100 ) ).

          ASSIGN
              ITEM.PreUni = ROUND(x-PreUniTeo, s-NroDec).
        END.
      ASSIGN
          ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                        ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                        ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                        ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
      IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
          THEN ITEM.ImpDto = 0.
          ELSE ITEM.ImpDto = (ITEM.CanPed * ITEM.PreUni) - ITEM.ImpLin.
    END.
    /* ***************************************************************** */
    ASSIGN
        ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
        ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
    IF ITEM.AftIsc THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
    ELSE ITEM.ImpIsc = 0.
    IF ITEM.AftIgv THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND(ITEM.ImpLin  / (1 + (s-PorIgv / 100)),4).
    ELSE ITEM.ImpIgv = 0.
END.

HIDE FRAME F-Proceso.

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
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "Almmmate"}
  {src/adm/template/snd-list.i "ITEM"}

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

