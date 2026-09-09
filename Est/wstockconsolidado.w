&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          estavtas         PROGRESS
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
CREATE WIDGET-POOL.
/* ***************************  Definitions  ************************** */
/* Parameters Definitions ---                                           */
DEF SHARED VAR s-codcia AS INT.
/* Local Variable Definitions ---                                       */
DEF NEW SHARED VAR input-var-1 AS CHAR.
DEF NEW SHARED VAR input-var-2 AS CHAR.
DEF NEW SHARED VAR input-var-3 AS CHAR.
DEF NEW SHARED VAR output-var-1 AS ROWID.
DEF NEW SHARED VAR output-var-2 AS CHAR.
DEF NEW SHARED VAR output-var-3 AS CHAR.

DEF TEMP-TABLE tt-txt
    FIELD Codigo AS CHAR FORMAT 'x(15)'.

DEF TEMP-TABLE tt-DimProducto LIKE DimProducto.

DEF TEMP-TABLE Detalle 
    FIELD Compania  AS CHAR LABEL "Empresa"  FORMAT 'x(60)' 
    FIELD Producto  AS CHAR FORMAT 'x(60)' 
    FIELD Linea     AS CHAR FORMAT 'x(60)'
    FIELD Sublinea  AS CHAR FORMAT 'x(60)'
    FIELD codmar    AS CHAR FORMAT 'x(5)' LABEL 'Cod.Marca'
    FIELD desmar    AS CHAR FORMAT 'x(60)' LABEL 'Descrp.Marca'
    FIELD Proveedor AS CHAR FORMAT 'x(120)'
    FIELD Unidad    AS CHAR FORMAT 'x(10)'
    FIELD Clasificacion  AS CHAR LABEL "Clasf.Gral" FORMAT 'x(3)'
    FIELD iranking  AS INT  LABEL "Rank.Gral" FORMAT '>>>,>>>,>>9'
    FIELD Clsfutlx  AS CHAR LABEL "Clasf.Utilex" FORMAT 'x(3)'
    FIELD rnkgutlx  AS INT  LABEL "Rank.Utilex" FORMAT '>>>,>>>,>>9'
    FIELD clsfmayo  AS CHAR LABEL "Clasf.Mayor" FORMAT 'x(3)'
    FIELD rnkgmayo  AS INT  LABEL "Rank.Mayor" FORMAT '>>>,>>>,>>9'
    FIELD CodAlm    AS CHAR LABEL "CodAlm" FORMAT 'x(3)'
    FIELD Almacen   AS CHAR LABEL "Almacen" FORMAT 'x(60)'
    FIELD StkAct    AS DEC  LABEL "Stock" FORMAT '->,>>>,>>>,>>9.99'
    FIELD Reservado AS DEC  LABEL "Reservado" FORMAT '->,>>>,>>>,>>9.99'
    FIELD StkMin    AS DEC LABEL 'Stk Mínimo' FORMAT '>>>,>>9.99'
    FIELD StkMax    AS DEC LABEL 'Stk Maximo' FORMAT '>>>,>>9.99'
    FIELD CostoMn   AS DEC  LABEL "Costo Repo. S/." FORMAT '->,>>>,>>>,>>9.99'
    FIELD PromedioMn AS DEC LABEL "Costo Prom. S/." FORMAT '->,>>>,>>>,>>9.99'
    FIELD TpoAlm    AS CHAR LABEL "Tipo Alm" FORMAT 'x(10)'
    FIELD AlmRem    AS CHAR LABEL "Alm Remate" FORMAT 'x(10)'
    FIELD AlmCom    AS CHAR LABEL "Alm Comercial" FORMAT 'x(10)'
    FIELD CodDiv    AS CHAR LABEL "División" FORMAT 'x(5)'
    FIELD TpoArt    AS CHAR LABEL "Estado" FORMAT "x(15)"
    FIELD Almacenes    AS CHAR LABEL "Almacenes" FORMAT "X(10)"
    FIELD CatConta AS CHAR LABEL "Cat.Conta" FORMAT "x(10)".

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
&Scoped-define INTERNAL-TABLES estavtas.DimLinea

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 estavtas.DimLinea.CodFam ~
estavtas.DimLinea.NomFam 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH estavtas.DimLinea NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH estavtas.DimLinea NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 estavtas.DimLinea
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 estavtas.DimLinea


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-6 BROWSE-3 BtnDone BUTTON-8 ~
ChkBoxSoloConti ChkBoxSoloConStock TOGGLE-Comprometido FILL-IN-CodAlm ~
BUTTON-3 FILL-IN-CodPro BUTTON-1 BUTTON-9 
&Scoped-Define DISPLAYED-OBJECTS ChkBoxSoloConti ChkBoxSoloConStock ~
TOGGLE-Comprometido FILL-IN-CodAlm FILL-IN-CodPro FILL-IN-NomPro ~
FILL-IN-Mensaje FILL-IN-filetxt 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 7 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 5 BY 1.08.

DEFINE BUTTON BUTTON-3 
     LABEL "..." 
     SIZE 4 BY .96.

DEFINE BUTTON BUTTON-8 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 8" 
     SIZE 7 BY 1.54.

DEFINE BUTTON BUTTON-9 
     LABEL "Borrar nombre de archivo de TEXTO" 
     SIZE 29 BY .96.

DEFINE VARIABLE FILL-IN-CodAlm AS CHARACTER FORMAT "X(1000)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPro AS CHARACTER FORMAT "X(11)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-filetxt AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 72 BY 1
     BGCOLOR 15 FGCOLOR 4 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 62 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 66 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 62 BY 1.73.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 1.73.

DEFINE VARIABLE ChkBoxSoloConStock AS LOGICAL INITIAL yes 
     LABEL "Solo con STOCK" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.29 BY .77 NO-UNDO.

DEFINE VARIABLE ChkBoxSoloConti AS LOGICAL INITIAL no 
     LABEL "Considerar SOLO CONTINENTAL" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.29 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Comprometido AS LOGICAL INITIAL no 
     LABEL "Considerar stock comprometido" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      estavtas.DimLinea SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      estavtas.DimLinea.CodFam COLUMN-LABEL "Linea" FORMAT "x(3)":U
      estavtas.DimLinea.NomFam COLUMN-LABEL "Descripción" FORMAT "x(30)":U
            WIDTH 54.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 62 BY 14.42
         FONT 4
         TITLE "SELECCIONE UNA O MAS LINEAS A IMPRIMIR" ROW-HEIGHT-CHARS .46 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-3 AT ROW 1.19 COL 3 HELP
          "Presione CRTL para seleccionar más de un registro" WIDGET-ID 200
     BtnDone AT ROW 1.38 COL 79 WIDGET-ID 38
     BUTTON-8 AT ROW 3.15 COL 79 WIDGET-ID 40
     ChkBoxSoloConti AT ROW 5.81 COL 66.72 WIDGET-ID 64
     ChkBoxSoloConStock AT ROW 6.96 COL 66.72 WIDGET-ID 66
     TOGGLE-Comprometido AT ROW 8.12 COL 67 WIDGET-ID 68
     FILL-IN-CodAlm AT ROW 16.38 COL 2 COLON-ALIGNED HELP
          "Separados por comas. Ejemplo: 11,10,10a,21" NO-LABEL WIDGET-ID 4
     BUTTON-3 AT ROW 16.38 COL 59 WIDGET-ID 6
     FILL-IN-CodPro AT ROW 18.31 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     FILL-IN-NomPro AT ROW 18.31 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 56
     FILL-IN-Mensaje AT ROW 19.85 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 42 NO-TAB-STOP 
     BUTTON-1 AT ROW 21.85 COL 75 WIDGET-ID 8
     FILL-IN-filetxt AT ROW 21.88 COL 3 NO-LABEL WIDGET-ID 10
     BUTTON-9 AT ROW 23 COL 26 WIDGET-ID 62
     "SELECCIONE UN PROVEEDOR" VIEW-AS TEXT
          SIZE 23 BY .5 AT ROW 17.73 COL 4 WIDGET-ID 58
          BGCOLOR 9 FGCOLOR 15 
     "Seleccione el Archivo de TEXTO con codigos de ARTICULOS" VIEW-AS TEXT
          SIZE 53.14 BY .62 AT ROW 21.19 COL 21.43 WIDGET-ID 12
          FGCOLOR 14 FONT 6
     "SELECCIONE UNO O MAS ALMACENES" VIEW-AS TEXT
          SIZE 29 BY .5 AT ROW 15.81 COL 4 WIDGET-ID 44
          BGCOLOR 9 FGCOLOR 15 
     RECT-2 AT ROW 16 COL 3 WIDGET-ID 46
     RECT-6 AT ROW 17.92 COL 3 WIDGET-ID 60
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 94.43 BY 23.69
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "STOCK CONSOLIDADO CONTI"
         HEIGHT             = 23.69
         WIDTH              = 94.43
         MAX-HEIGHT         = 24.77
         MAX-WIDTH          = 94.43
         VIRTUAL-HEIGHT     = 24.77
         VIRTUAL-WIDTH      = 94.43
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
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
/* BROWSE-TAB BROWSE-3 RECT-6 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-filetxt IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "estavtas.DimLinea"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > estavtas.DimLinea.CodFam
"DimLinea.CodFam" "Linea" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > estavtas.DimLinea.NomFam
"DimLinea.NomFam" "Descripción" ? "character" ? ? ? ? ? ? no ? no no "54.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* STOCK CONSOLIDADO CONTI */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* STOCK CONSOLIDADO CONTI */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:

    DEFINE VARIABLE X-archivo AS CHARACTER.
    DEFINE VARIABLE OKpressed AS LOGICAL.

    DISPLAY "" @ FILL-IN-filetxt WITH FRAME {&FRAME-NAME}.
    

SYSTEM-DIALOG GET-FILE x-Archivo
            FILTERS "Archivo (*.txt)" "*.txt"
            MUST-EXIST
            TITLE "Seleccione archivo..."
            UPDATE OKpressed.   
          IF OKpressed = NO THEN RETURN.  

      DISPLAY X-archivo @ FILL-IN-filetxt WITH FRAME {&FRAME-NAME}.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* ... */
DO:
    DEFINE VARIABLE x-almacenes AS CHAR NO-UNDO.
    x-almacenes = FILL-IN-CodAlm:SCREEN-VALUE.
    RUN alm/d-almacen (INPUT-OUTPUT x-almacenes).
    FILL-IN-CodAlm:SCREEN-VALUE = x-almacenes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* Button 8 */
DO:
   DEF VAR pOptions AS CHAR.
   DEF VAR pArchivo AS CHAR.
   DEF VAR cArchivo AS CHAR.
   DEF VAR zArchivo AS CHAR.
   DEF VAR cComando AS CHAR.
   DEF VAR pDirectorio AS CHAR.
   DEF VAR lOptions AS CHAR.

   ASSIGN FILL-IN-CodAlm FILL-IN-CodPro FILL-IN-filetxt chkboxSoloConti chkboxSoloConStock
       TOGGLE-Comprometido.

   IF fill-in-codalm = "" THEN DO:
       MESSAGE "Ingrse al menos un almacén" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
   END.

   RUN lib/tt-file-to-text-7zip (OUTPUT pOptions, OUTPUT pArchivo, OUTPUT pDirectorio).
   IF pOptions = "" THEN RETURN NO-APPLY.

   SESSION:SET-WAIT-STATE('GENERAL').
   SESSION:DATE-FORMAT = "mdy".
   RUN Carga-Temporal.
   SESSION:DATE-FORMAT = "dmy".
   SESSION:SET-WAIT-STATE('').

   FIND FIRST Detalle NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Detalle THEN DO:
       MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
       RETURN NO-APPLY.
   END.

   /* El archivo se va a generar en un archivo temporal de trabajo antes 
   de enviarlo a su directorio destino */
   pArchivo = REPLACE(pArchivo, '.', STRING(RANDOM(1,9999), '9999') + ".").
   cArchivo = LC(SESSION:TEMP-DIRECTORY + pArchivo).
   SESSION:SET-WAIT-STATE('GENERAL').
   SESSION:DATE-FORMAT = "mdy".
   RUN lib/tt-file (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
   SESSION:DATE-FORMAT = "dmy".
   SESSION:SET-WAIT-STATE('').

   /* Secuencia de comandos para encriptar el archivo con 7zip */
   IF INDEX(cArchivo, ".xls") > 0 THEN zArchivo = REPLACE(cArchivo, ".xls", ".zip").
   IF INDEX(cArchivo, ".txt") > 0 THEN zArchivo = REPLACE(cArchivo, ".txt", ".zip").
   cComando = '"C:\Archivos de programa\7-Zip\7z.exe" a ' + zArchivo + ' ' + cArchivo.
   OS-COMMAND 
       SILENT 
       VALUE ( cComando ).
   IF SEARCH(zArchivo) = ? THEN DO:
       MESSAGE 'NO se pudo encriptar el archivo' SKIP
           'Avise a sistemas'
           VIEW-AS ALERT-BOX ERROR.
       RETURN.
   END.
   OS-DELETE VALUE(cArchivo).

   IF INDEX(cArchivo, '.xls') > 0 THEN cArchivo = REPLACE(pArchivo, ".xls", ".zip").
   IF INDEX(cArchivo, '.txt') > 0 THEN cArchivo = REPLACE(pArchivo, ".txt", ".zip").
   cComando = "copy " + zArchivo + ' ' + TRIM(pDirectorio) + TRIM(cArchivo).
   OS-COMMAND 
       SILENT 
       VALUE(cComando).
   OS-DELETE VALUE(zArchivo).
   /* ******************************************************* */
   MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-9 W-Win
ON CHOOSE OF BUTTON-9 IN FRAME F-Main /* Borrar nombre de archivo de TEXTO */
DO:
  DISPLAY "" @ FILL-IN-filetxt WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPro W-Win
ON LEAVE OF FILL-IN-CodPro IN FRAME F-Main
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND DimProveedor WHERE DimProveedor.codpro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE DimProveedor THEN DO:
        MESSAGE 'Proveedor no registrado' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    FILL-IN-NomPro:SCREEN-VALUE = DimProveedor.nompro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPro W-Win
ON LEFT-MOUSE-DBLCLICK OF FILL-IN-CodPro IN FRAME F-Main
DO:
    RUN lkup/c-provee ('Proveedores').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE Detalle.

DEFINE VAR lRutaFile AS CHAR.

lRutaFile = FILL-IN-filetxt:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

EMPTY TEMP-TABLE TT-TXT.

IF FILL-IN-filetxt <> "" THEN DO:
    /* Cargo el TXT */
    INPUT FROM VALUE(lRutaFile).
    REPEAT:
        CREATE tt-txt.
        IMPORT tt-txt.
    END.                    
    INPUT CLOSE.
END.


/* 1ro Continental */
RUN Carga-Temporal-Conti.

/* 2do Cissac */
IF chkboxSoloConti = NO THEN DO:
    /*RUN Carga-Temporal-Cissac.*/
END.

/* limpieza */
/* IF chkboxSoloConStock = YES THEN DO:                                         */
/*     FOR EACH Detalle:                                                        */
/*         IF Detalle.StkAct = 0 AND Detalle.Reservado = 0 THEN DELETE Detalle. */
/*     END.                                                                     */
/* END.                                                                         */

/* DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:                                               */
/*     IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) IN FRAME {&FRAME-NAME} THEN DO:                                        */
/*         FOR EACH estavtas.DimProducto NO-LOCK WHERE estavtas.DimProducto.CodFam = estavtas.DimLinea.CodFam,        */
/*             FIRST estavtas.DimLinea OF estavtas.DimProducto NO-LOCK,                                               */
/*             FIRST estavtas.DimSubLinea OF estavtas.DimProducto NO-LOCK:                                            */
/*             FOR EACH INTEGRAL.Almmmate NO-LOCK WHERE INTEGRAL.Almmmate.CodCia = s-codcia                           */
/*                 AND INTEGRAL.Almmmate.codmat = estavtas.DimProducto.CodMat,                                        */
/*                 FIRST INTEGRAL.Almacen OF INTEGRAL.Almmmate NO-LOCK:                                               */
/*                 CREATE Detalle.                                                                                    */
/*                 ASSIGN                                                                                             */
/*                     Detalle.Compania = "CONTINENTAL"                                                               */
/*                     Detalle.Almacen = TRIM(INTEGRAL.Almacen.CodAlm) + ' ' + INTEGRAL.Almacen.Descripcion           */
/*                     Detalle.Producto = TRIM(estavtas.DimProducto.codmat) + ' ' + TRIM(estavtas.DimProducto.DesMat) */
/*                     Detalle.Linea = estavtas.DimProducto.codfam + ' ' + estavtas.DimLinea.NomFam                   */
/*                     Detalle.Sublinea = estavtas.DimProducto.subfam + ' ' + estavtas.DimSubLinea.NomSubFam          */
/*                     Detalle.Unidad = estavtas.DimProducto.undstk                                                   */
/*                     Detalle.StkAct = INTEGRAL.Almmmate.StkAct.                                                     */
/*                 /* Stock Comprometido */                                                                           */
/*                 RUN Stock-Comprometido (INTEGRAL.Almmmate.CodAlm,                                                  */
/*                                         estavtas.DimProducto.CodMat,                                               */
/*                                         OUTPUT x-StockComprometido).                                               */
/*                 ASSIGN                                                                                             */
/*                     Detalle.Reservado = x-StockComprometido.                                                       */
/*                 /* Costo Reposicion */                                                                             */
/*                 IF INTEGRAL.Almmmatg.monvta = 1 THEN                                                               */
/*                     ASSIGN                                                                                         */
/*                     Detalle.CostoMn = INTEGRAL.Almmmatg.CtoLis                                                     */
/*                     /*Detalle.CostoMe = INTEGRAL.Almmmatg.CtoLis / INTEGRAL.Almmmatg.TpoCmb.*/.                    */
/*                 ELSE                                                                                               */
/*                     ASSIGN                                                                                         */
/*                     /*Detalle.CostoMe = INTEGRAL.Almmmatg.CtoLis*/                                                 */
/*                     Detalle.CostoMn = INTEGRAL.Almmmatg.CtoLis * INTEGRAL.Almmmatg.TpoCmb.                         */
/*                 /* Costo Promedio */                                                                               */
/*                 FIND LAST INTEGRAL.AlmStkge WHERE INTEGRAL.AlmStkge.CodCia = s-codcia                              */
/*                     AND INTEGRAL.AlmStkge.codmat = estavtas.DimProducto.codmat                                     */
/*                     AND INTEGRAL.AlmStkge.Fecha <= TODAY                                                           */
/*                     NO-LOCK NO-ERROR.                                                                              */
/*                 IF AVAILABLE INTEGRAL.AlmStkge THEN Detalle.PromedioMn = INTEGRAL.AlmStkge.CtoUni.                 */
/*             END.                                                                                                   */
/*         END.                                                                                                       */
/*     END.                                                                                                           */
/* END.                                                                                                               */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Cissac W-Win 
PROCEDURE Carga-Temporal-Cissac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k AS INT NO-UNDO.
DEF VAR x-StockComprometido AS DEC NO-UNDO.

/*{est/istockconsolidado.i &Base="CISSAC" &Empresa="STANDFORD"}*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Conti W-Win 
PROCEDURE Carga-Temporal-Conti :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k AS INT NO-UNDO.
DEF VAR x-StockComprometido AS DEC NO-UNDO.

{est/istockconsolidado.i &Base="INTEGRAL" &Empresa="CONTINENTAL"}

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
  DISPLAY ChkBoxSoloConti ChkBoxSoloConStock TOGGLE-Comprometido FILL-IN-CodAlm 
          FILL-IN-CodPro FILL-IN-NomPro FILL-IN-Mensaje FILL-IN-filetxt 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-2 RECT-6 BROWSE-3 BtnDone BUTTON-8 ChkBoxSoloConti 
         ChkBoxSoloConStock TOGGLE-Comprometido FILL-IN-CodAlm BUTTON-3 
         FILL-IN-CodPro BUTTON-1 BUTTON-9 
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
  {src/adm/template/snd-list.i "estavtas.DimLinea"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Stock-Comprometido W-Win 
PROCEDURE Stock-Comprometido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF OUTPUT PARAMETER pComprometido AS DEC.

FIND INTEGRAL.FacCfgGn WHERE INTEGRAL.FacCfgGn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE INTEGRAL.FacCfgGn THEN RETURN.

/* Stock comprometido por PEDIDOS ACTIVOS MOSTRADOR */
DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.

/* Tiempo por defecto fuera de campaña */
TimeOut = (INTEGRAL.FacCfgGn.Dias-Res * 24 * 3600) +
          (INTEGRAL.FacCfgGn.Hora-Res * 3600) + 
          (INTEGRAL.FacCfgGn.Minu-Res * 60).

pComprometido = 0.
DEF VAR i AS INT NO-UNDO.
DEF VAR x-CodAlm AS CHAR NO-UNDO.

DO i = 1 TO NUM-ENTRIES(pCodAlm):
    x-CodAlm = ENTRY(i, pCodAlm).
    /**********   Barremos para los PEDIDOS MOSTRADOR ***********************/ 
    FOR EACH INTEGRAL.Facdpedi USE-INDEX Llave04 NO-LOCK WHERE INTEGRAL.Facdpedi.CodCia = s-codcia
        AND INTEGRAL.Facdpedi.AlmDes = x-CodAlm
        AND INTEGRAL.Facdpedi.codmat = pcodmat
        AND INTEGRAL.Facdpedi.coddoc = 'P/M'
        AND INTEGRAL.Facdpedi.FlgEst = "P" :
        FIND FIRST INTEGRAL.Faccpedi OF INTEGRAL.Facdpedi WHERE INTEGRAL.Faccpedi.FlgEst = "P" NO-LOCK NO-ERROR.
        IF NOT AVAIL INTEGRAL.Faccpedi THEN NEXT.

        TimeNow = (TODAY - INTEGRAL.Faccpedi.FchPed) * 24 * 3600.
        TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(INTEGRAL.Faccpedi.Hora, 1, 2)) * 3600) +
                  (INTEGER(SUBSTRING(INTEGRAL.Faccpedi.Hora, 4, 2)) * 60) ).
        IF TimeOut > 0 THEN DO:
            IF TimeNow <= TimeOut   /* Dentro de la valides */
            THEN DO:
                /* cantidad en reservacion */
                pComprometido = pComprometido + INTEGRAL.Facdpedi.Factor * INTEGRAL.Facdpedi.CanPed.
            END.
        END.
    END.
    /**********   Barremos para los PEDIDOS AL CREDITO   ***********************/ 
    FOR EACH INTEGRAL.Facdpedi USE-INDEX Llave04 NO-LOCK WHERE INTEGRAL.Facdpedi.codcia = s-codcia
            AND INTEGRAL.Facdpedi.almdes = x-CodAlm
            AND INTEGRAL.Facdpedi.codmat = pCodMat
            AND INTEGRAL.Facdpedi.coddoc = 'PED'
            AND INTEGRAL.Facdpedi.flgest = 'P':
        /* RHC 12.12.2011 agregamos los nuevos estados */
        FIND FIRST INTEGRAL.Faccpedi OF INTEGRAL.Facdpedi WHERE LOOKUP(INTEGRAL.Faccpedi.FlgEst, "G,X,P,W,WX,WL") > 0 NO-LOCK NO-ERROR.
        IF NOT AVAILABLE INTEGRAL.Faccpedi THEN NEXT.
        pComprometido = pComprometido + INTEGRAL.Facdpedi.Factor * (INTEGRAL.Facdpedi.CanPed - INTEGRAL.Facdpedi.canate).
    END.
    /* ORDENES DE DESPACHO CREDITO */
    FOR EACH INTEGRAL.Facdpedi USE-INDEX Llave04 NO-LOCK WHERE INTEGRAL.Facdpedi.codcia = s-codcia
            AND INTEGRAL.Facdpedi.almdes = x-CodAlm
            AND INTEGRAL.Facdpedi.codmat = pCodMat
            AND INTEGRAL.Facdpedi.coddoc = 'O/D'
            AND INTEGRAL.Facdpedi.flgest = 'P':
        FIND FIRST INTEGRAL.Faccpedi OF INTEGRAL.Facdpedi WHERE INTEGRAL.Faccpedi.flgest = 'P' NO-LOCK NO-ERROR.
        IF NOT AVAILABLE INTEGRAL.Faccpedi THEN NEXT.
        pComprometido = pComprometido + INTEGRAL.Facdpedi.Factor * (INTEGRAL.Facdpedi.CanPed - INTEGRAL.Facdpedi.canate).
    END.
    /* Stock Comprometido por Pedidos por Reposicion Automatica */
    FOR EACH INTEGRAL.Almcrepo NO-LOCK WHERE INTEGRAL.Almcrepo.codcia = s-codcia
        AND INTEGRAL.Almcrepo.TipMov = 'A'
        AND INTEGRAL.Almcrepo.AlmPed = x-CodAlm
        AND INTEGRAL.Almcrepo.FlgEst = 'P'
        AND INTEGRAL.Almcrepo.FlgSit = 'A',
        EACH INTEGRAL.Almdrepo OF INTEGRAL.Almcrepo NO-LOCK WHERE INTEGRAL.Almdrepo.codmat = pCodMat
        AND INTEGRAL.Almdrepo.CanApro > INTEGRAL.Almdrepo.CanAten:
        pComprometido = pComprometido + (INTEGRAL.Almdrepo.CanApro - INTEGRAL.Almdrepo.CanAten).
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

