&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tmp-CcbDDocu NO-UNDO LIKE CcbDDocu.



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

DEF VAR RB-REPORT-LIBRARY AS CHAR.  /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.     /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR. /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.  /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     /* Otros parametros */

DEFINE VARIABLE s-task-no AS INTEGER     NO-UNDO.

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VARIABLE s-User-Id AS CHARACTER.
DEFINE SHARED VARIABLE pRCID AS INT.

DEFINE VAR cCodDoc  AS CHAR INIT "VAL".
DEFINE VAR xCodDoc  AS CHAR INIT "FAI".

DEFINE VARIABLE iLin      AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCol      AS INTEGER     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-4

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tmp-CcbDDocu Almmmatg

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 tmp-CcbDDocu.codmat Almmmatg.DesMat ~
tmp-CcbDDocu.PreUni tmp-CcbDDocu.CanDes tmp-CcbDDocu.ImpLin ~
tmp-CcbDDocu.puntos tmp-CcbDDocu.ImpPro tmp-CcbDDocu.ImpDto2 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH tmp-CcbDDocu NO-LOCK, ~
      EACH Almmmatg OF tmp-CcbDDocu NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH tmp-CcbDDocu NO-LOCK, ~
      EACH Almmmatg OF tmp-CcbDDocu NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 tmp-CcbDDocu Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 tmp-CcbDDocu
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-4 Almmmatg


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 TxtSerie txtNroFactura ~
BtnAceptar BROWSE-4 btnAprobar 
&Scoped-Define DISPLAYED-OBJECTS cboProvProd txt-codpro txtProd txtTotal ~
TxtSerie txtNroFactura txtBruto txtIgv txt-nomcli txt-codcli txtFecha ~
txtTotalVta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnAceptar 
     LABEL "Aceptar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON btnAprobar 
     LABEL "Aprobar Vales" 
     SIZE 22 BY 1.12.

DEFINE VARIABLE cboProvProd AS CHARACTER FORMAT "X(256)":U INITIAL "Continental - Vales Utilex" 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1
     BGCOLOR 15 FGCOLOR 12 FONT 9 NO-UNDO.

DEFINE VARIABLE txt-codcli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .92
     BGCOLOR 8 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txt-codpro AS CHARACTER FORMAT "X(256)":U INITIAL "10003814" 
     LABEL "Prov." 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 8 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txt-nomcli AS CHARACTER FORMAT "X(30)":U 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 58 BY 1 NO-UNDO.

DEFINE VARIABLE txtBruto AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Impte Bruto" 
     VIEW-AS FILL-IN 
     SIZE 12 BY 1
     BGCOLOR 15 FGCOLOR 9 FONT 11 NO-UNDO.

DEFINE VARIABLE txtFecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 15.86 BY 1 NO-UNDO.

DEFINE VARIABLE txtIgv AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Impte IGV" 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1
     BGCOLOR 15 FGCOLOR 9 FONT 11 NO-UNDO.

DEFINE VARIABLE txtNroFactura AS INTEGER FORMAT "999999":U INITIAL 0 
     LABEL "Nro Factura" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE txtProd AS CHARACTER FORMAT "X(256)":U INITIAL "0006" 
     LABEL "Prod." 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE TxtSerie AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY 1 NO-UNDO.

DEFINE VARIABLE txtTotal AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Impte Total" 
     VIEW-AS FILL-IN 
     SIZE 12 BY 1
     BGCOLOR 15 FGCOLOR 9 FONT 11 NO-UNDO.

DEFINE VARIABLE txtTotalVta AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Impte Total" 
     VIEW-AS FILL-IN 
     SIZE 12 BY 1
     BGCOLOR 15 FGCOLOR 4 FONT 11 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 109 BY .15.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 109 BY .15.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      tmp-CcbDDocu, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      tmp-CcbDDocu.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U
            WIDTH 9.43
      Almmmatg.DesMat FORMAT "X(45)":U WIDTH 29.43
      tmp-CcbDDocu.PreUni COLUMN-LABEL "P. Unitario" FORMAT ">,>>>,>>9.99999":U
            WIDTH 9.43
      tmp-CcbDDocu.CanDes COLUMN-LABEL "Solicitado" FORMAT ">,>>>,>>9":U
            WIDTH 9.43
      tmp-CcbDDocu.ImpLin FORMAT "->>,>>>,>>9.99":U WIDTH 11.43
      tmp-CcbDDocu.puntos COLUMN-LABEL "Despachado" FORMAT "->>,>>9":U
            WIDTH 11.43
      tmp-CcbDDocu.ImpPro COLUMN-LABEL "Desde" FORMAT "->>>,>>>,>>9":U
      tmp-CcbDDocu.ImpDto2 COLUMN-LABEL "Hasta" FORMAT "->>>,>>>,>>9":U
            WIDTH 9.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 108 BY 9.73 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cboProvProd AT ROW 2.5 COL 19 COLON-ALIGNED WIDGET-ID 84
     txt-codpro AT ROW 2.62 COL 67 COLON-ALIGNED WIDGET-ID 10
     txtProd AT ROW 2.62 COL 89 COLON-ALIGNED WIDGET-ID 24
     txtTotal AT ROW 3.85 COL 93 COLON-ALIGNED WIDGET-ID 82
     TxtSerie AT ROW 3.88 COL 7 COLON-ALIGNED WIDGET-ID 68
     txtNroFactura AT ROW 3.88 COL 25 COLON-ALIGNED WIDGET-ID 72
     txtBruto AT ROW 3.88 COL 47 COLON-ALIGNED WIDGET-ID 78
     txtIgv AT ROW 3.88 COL 70 COLON-ALIGNED WIDGET-ID 80
     BtnAceptar AT ROW 5.19 COL 95 WIDGET-ID 74
     txt-nomcli AT ROW 5.23 COL 32 COLON-ALIGNED WIDGET-ID 18
     txt-codcli AT ROW 5.31 COL 7 COLON-ALIGNED WIDGET-ID 16
     BROWSE-4 AT ROW 6.92 COL 1.86 WIDGET-ID 200
     btnAprobar AT ROW 17.12 COL 33.43 WIDGET-ID 88
     txtFecha AT ROW 17.19 COL 12.14 COLON-ALIGNED WIDGET-ID 94
     txtTotalVta AT ROW 17.23 COL 72.29 COLON-ALIGNED WIDGET-ID 86
     "Aprobacion y asignacion de numero de VALES UTILEX" VIEW-AS TEXT
          SIZE 70 BY .96 AT ROW 1.04 COL 19 WIDGET-ID 90
          FGCOLOR 4 FONT 9
     RECT-1 AT ROW 6.62 COL 1 WIDGET-ID 76
     RECT-2 AT ROW 2.08 COL 1 WIDGET-ID 92
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1.04
         SIZE 111.43 BY 20.08 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tmp-CcbDDocu T "?" NO-UNDO INTEGRAL CcbDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Tickets Utilex"
         HEIGHT             = 18.12
         WIDTH              = 111.43
         MAX-HEIGHT         = 20.12
         MAX-WIDTH          = 111.43
         VIRTUAL-HEIGHT     = 20.12
         VIRTUAL-WIDTH      = 111.43
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
/* BROWSE-TAB BROWSE-4 txt-codcli F-Main */
/* SETTINGS FOR FILL-IN cboProvProd IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-codcli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-codpro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-nomcli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtBruto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtFecha IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtIgv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtProd IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtTotal IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtTotalVta IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.tmp-CcbDDocu,INTEGRAL.Almmmatg OF Temp-Tables.tmp-CcbDDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tmp-CcbDDocu.codmat
"tmp-CcbDDocu.codmat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "29.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tmp-CcbDDocu.PreUni
"tmp-CcbDDocu.PreUni" "P. Unitario" ? "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tmp-CcbDDocu.CanDes
"tmp-CcbDDocu.CanDes" "Solicitado" ">,>>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tmp-CcbDDocu.ImpLin
"tmp-CcbDDocu.ImpLin" ? ? "decimal" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tmp-CcbDDocu.puntos
"tmp-CcbDDocu.puntos" "Despachado" "->>,>>9" "decimal" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tmp-CcbDDocu.ImpPro
"tmp-CcbDDocu.ImpPro" "Desde" "->>>,>>>,>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tmp-CcbDDocu.ImpDto2
"tmp-CcbDDocu.ImpDto2" "Hasta" "->>>,>>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Tickets Utilex */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Tickets Utilex */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnAceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnAceptar W-Win
ON CHOOSE OF BtnAceptar IN FRAME F-Main /* Aceptar */
DO:
    ASSIGN 
        txt-codpro
        txtProd       
        txt-codcli
        txt-nomcli
        cboProvProd
        txtSerie
        txtNroFactura.

    
  DISABLE btnAprobar WITH FRAME {&FRAME-NAME}.

  RUN ue-valida.

  IF RETURN-VALUE = "ADM-ERROR" THEN DO:
      RETURN NO-APPLY.
  END.
  
  /*
            Vale de 10 Soles
    055399  Vale de 20 Soles
    055400  Vale de 25 Soles
    074396  Vale de 30 Soles
    055401  Vale de 50 Soles
    055402  Vale de 100 Soles
  */

  DEFINE VAR cDenoMinaciones AS CHAR.
  DEFINE VAR cCodMat AS CHAR.
  DEFINE VAR cDenoMinacion AS CHAR.
  DEFINE VAR lPosi AS INT.
  DEFINE VAR lDisponibles AS INT.
  DEFINE VAR lSuma AS DEC.

  cDenoMinaciones   = "0001000,0002000,0002500,0003000,0005000,0010000".
  cCodMat           = "XXXXXX,055399,055400,074396,055401,055402".

  lSuma = 0.
  FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
      lPosi = LOOKUP(ccbddocu.codmat,cCodMat,",").
      /*MESSAGE ccbddocu.codmat cCodMat lPosi.*/
      IF lPosi  > 0 THEN DO:
          CREATE tmp-ccbddocu.
          BUFFER-COPY ccbddocu TO tmp-ccbddocu.
          
          cDenominacion = ENTRY(lPosi,cDenominaciones,",").
          ASSIGN tmp-ccbddocu.almdes = cDenominacion.

          /* Buscar si hay vales disponible  */
          FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                                    vtatabla.tabla = 'VUTILEX' AND 
                                    vtatabla.llave_c2 = txt-codpro AND 
                                    vtatabla.llave_c3 = txtProd AND
                                    vtatabla.llave_c4 = cDenominacion AND
                                    vtatabla.libre_c03 = 'DETALLE' NO-LOCK NO-ERROR.
          IF AVAILABLE vtatabla THEN DO:              
              lDisponibles = vtatabla.rango_valor[2] - vtatabla.rango_valor[1] .

              IF ccbddocu.candes <= lDisponibles THEN DO:
                    ASSIGN tmp-ccbddocu.puntos = ccbddocu.candes
                            tmp-ccbddocu.impPro = vtatabla.rango_valor[1]
                            tmp-ccbddocu.impDto2 = vtatabla.rango_valor[1] + (ccbddocu.candes - 1).

              END.
              ELSE DO:
                  ASSIGN tmp-ccbddocu.puntos = lDisponibles
                          tmp-ccbddocu.impPro = vtatabla.rango_valor[1]
                          tmp-ccbddocu.impDto2 = vtatabla.rango_valor[1] + (lDisponibles - 1).
              END.
              lSuma = lSuma + (tmp-ccbddocu.puntos * tmp-ccbddocu.preuni).
          END.
          ELSE DO:
              ASSIGN tmp-ccbddocu.puntos = 0
                      tmp-ccbddocu.impPro = 0
                      tmp-ccbddocu.impDto2 = 0.
          END.
      END.
      
  END.
  /*
  codcia = 1 and tabla = 'VUTILEX' and llave_c2 = '10003814' 
  and llave_c3 = '0005' and libre_c03 = 'DETALLE'
  */

  DISPLAY ccbcdocu.impbrt @ txtBruto WITH FRAME {&FRAME-NAME}.
  DISPLAY ccbcdocu.ImpIgv @ txtIgv WITH FRAME {&FRAME-NAME}.
  DISPLAY ccbcdocu.ImpTot @ txtTotal WITH FRAME {&FRAME-NAME}.

  DISPLAY lSuma @ txtTotalVta WITH FRAME {&FRAME-NAME}.

  {&OPEN-QUERY-BROWSE-4}
  
  ENABLE btnAprobar WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnAprobar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnAprobar W-Win
ON CHOOSE OF btnAprobar IN FRAME F-Main /* Aprobar Vales */
DO:
  ASSIGN txtTotal txtTotalVta.
  IF txtTotal <> txtTotalVta THEN DO:
      MESSAGE "Monto total de la Factura es diferente al monto Calculado".
      RETURN NO-APPLY.
  END.

  MESSAGE 'Seguro de Aprobar la FACTURA de Vales Utilex?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.

  RUN ue-procesar.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-codcli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-codcli W-Win
ON LEAVE OF txt-codcli IN FRAME F-Main /* Cliente */
DO:
    ASSIGN {&SELF-NAME}.
    FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = txt-codcli NO-LOCK NO-ERROR.
    IF AVAIL gn-clie THEN 
        DISPLAY gn-clie.nomcli @ txt-nomcli WITH FRAME {&FRAME-NAME}.
    ELSE 
        DISPLAY "" @ txt-nomcli WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtNroFactura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtNroFactura W-Win
ON LEAVE OF txtNroFactura IN FRAME F-Main /* Nro Factura */
DO:
  DISABLE btnAprobar WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TxtSerie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TxtSerie W-Win
ON LEAVE OF TxtSerie IN FRAME F-Main /* Serie */
DO:
  DISABLE btnAprobar WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Datos W-Win 
PROCEDURE Carga-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Tipo de fuente C39HrP48DhTt      
------------------------------------------------------------------------------*/
/*
  DEFINE VARIABLE iInt      AS INTEGER     NO-UNDO.
  DEFINE VARIABLE iLin      AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cVar01    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cVar02    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cVar03    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cNroSec01 AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cNroSec02 AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cNroSec03 AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE cLlave    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cFecha    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cImpTot   AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iDigVer   AS INTEGER     NO-UNDO.

  DEFINE VARIABLE cNroTck   AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cNomCli   AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE cCodPrd   AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cCodPrv   AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE iNroVls   AS INTEGER     NO-UNDO.
  DEFINE VARIABLE iCol      AS INTEGER     NO-UNDO.

  DEFINE VARIABLE lNroTck AS INT.

  REPEAT:
    s-task-no = RANDOM(1,999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK)
    THEN LEAVE.
  END.

  /*Busca Cliente*/
  cNomCli = txt-nomcli.

  /* Datos del Proveedor */
  cCodPrv = substring(cboProvProd,1,8).
  cCodPrd = substring(cboProvProd,10,4).
/*
   FIND FIRST VtaCTickets WHERE VtaCTickets.CodCia = s-codcia
      AND VtaCTickets.CodPro = txt-codpro NO-LOCK NO-ERROR.
*/      
  FIND FIRST VtaCTickets WHERE VtaCTickets.CodCia = s-codcia
     AND VtaCTickets.CodPro = cCodPrv AND VtaCTickets.Producto = cCodPrd NO-LOCK NO-ERROR.

  IF NOT AVAIL VtaCTickets THEN DO:
      MESSAGE "Producto y/o Proveedor no tiene registrado" SKIP
              "    Estructura de Ticket     "
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN "adm-error".
  END.

  ASSIGN 
      cLlave  = VtaCTickets.Producto
      cFecha  = SUBSTRING(STRING(YEAR(txt-fecha),"9999"),3) + 
                STRING(MONTH(txt-fecha),"99") + STRING(DAY(txt-fecha),"99")
      cImptot = STRING((txt-nrototal * 100),"9999999").
      
  IF (txt-importe MODULO txt-nrototal) > 0 THEN DO:
      MESSAGE "Importe Total debe ser multipo de Valor Nominal"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      APPLY "entry" TO txt-importe IN FRAME {&FRAME-NAME}.
      RETURN "adm-error".
  END.
  ELSE DO:
      ASSIGN 
          iLin = 1
          iCol = 1. 

      /*lNroTck = 114677.  /*114984 114969.*/*/

      DO iInt = 1 TO (txt-importe / txt-nrototal):

          lNroTck = lNroTck + 1.

          FIND LAST FacCorre WHERE 
              FacCorre.CodCia = S-CODCIA AND
              FacCorre.CodDoc = cCodDoc AND
              FacCorre.CodDiv = S-CODDIV EXCLUSIVE-LOCK NO-ERROR.
          IF AVAILABLE FacCorre THEN DO: 
              
              ASSIGN 
                  cNroTck = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
                  FacCorre.Correlativo = FacCorre.Correlativo + 1.
                           
          END.
          cNroTck = "000" + STRING(lNroTck,"999999").
          cVar01 = cLlave + cFecha + cNroTck + cImptot.
          
          RUN vtagn\edenred-01 (cVar01,OUTPUT iDigVer).
          
          cVar01 = cVar01 + STRING(iDigVer,"9") + "0".
          cNroSec01 = cNroTck.

          IF ((iInt - 1) MODULO 3) = 0 THEN
              ASSIGN 
                iLin = iLin + 1
                iCol = 1.
            
          FIND FIRST w-report WHERE w-report.task-no = s-task-no 
              AND w-report.llave-i = iLin NO-ERROR.
          IF NOT AVAIL w-report THEN DO:
              CREATE w-report.
              ASSIGN
                  task-no    = s-task-no
                  llave-i    = iLin
                  campo-c[5] = cNomCli
                  campo-d[1] = txt-fecha            /*Fecha Vencimiento*/
                  campo-f[1] = txt-nrototal.         /*Importe Vale*/ 
          END.
          campo-c[14 + iCol] = cVar01.         /* Cod Barra antes de la encriptacion */

          RUN lib\_strto128c(cVar01, OUTPUT cVar01).
          
          ASSIGN 
              campo-c[iCol] = cVar01
              campo-i[iCol] = INTEGER(cNroSec01)
              iCol          = iCol + 1.      
      END.
  END.

  

  /***
  DO iInt = 1 TO INT(txt-nrototal) :
      /*Primera Parte */
      FIND LAST FacCorre WHERE 
          FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = cCodDoc AND
          FacCorre.CodDiv = S-CODDIV EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE FacCorre THEN DO: 
          ASSIGN 
              cNroTck = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
              FacCorre.Correlativo = FacCorre.Correlativo + 1.
      END.
      cVar01 = cLlave + cFecha + cNroTck + cImptot.
      RUN vtagn\edenred-01 (cVar01,OUTPUT iDigVer).
      cVar01 = cVar01 + STRING(iDigVer,"9") + "0".
      cNroSec01 = cNroTck.

      /*Segunda Parte */
      FIND LAST FacCorre WHERE 
          FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = cCodDoc AND
          FacCorre.CodDiv = S-CODDIV EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE FacCorre THEN DO: 
          ASSIGN 
              cNroTck = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
              FacCorre.Correlativo = FacCorre.Correlativo + 1.
      END.
      iInt = iInt + 1.
      cVar02 = cLlave + cFecha + cNroTck + cImptot.
      RUN vtagn\edenred-01 (cVar02,OUTPUT iDigVer).
      cVar02 = cVar02 + STRING(iDigVer,"9") + "0".
      cNroSec02 = cNroTck.


      /*Tercera Parte */
      FIND LAST FacCorre WHERE 
          FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = cCodDoc AND
          FacCorre.CodDiv = S-CODDIV EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE FacCorre THEN DO: 
          ASSIGN 
              cNroTck = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
              FacCorre.Correlativo = FacCorre.Correlativo + 1.
      END.
      iInt = iInt + 1.
      cVar03 = cLlave + cFecha + cNroTck + cImptot.
      RUN vtagn\edenred-01 (cVar03,OUTPUT iDigVer).
      cVar03 = cVar03 + STRING(iDigVer,"9") + "0".
      cNroSec03 = cNroTck.


      RUN lib\_strto128c(cVar01, OUTPUT cVar01).
      RUN lib\_strto128c(cVar02, OUTPUT cVar02).
      RUN lib\_strto128c(cVar03, OUTPUT cVar03).

      FIND FIRST w-report WHERE w-report.task-no = s-task-no 
          AND w-report.llave-i = iLin NO-LOCK NO-ERROR.
      IF NOT AVAIL w-report THEN DO:
          CREATE w-report.
          ASSIGN
              task-no    = s-task-no
              llave-i    = iLin
              campo-c[1] = cVar01
              campo-i[1] = INTEGER(cNroSec01)
              campo-c[2] = cVar02
              campo-i[2] = INTEGER(cNroSec02)
              campo-c[3] = cVar03
              campo-i[3] = INTEGER(cNroSec03)
              campo-c[5] = cNomCli
              campo-d[1] = txt-fecha            /*Fecha Vencimiento*/
              campo-f[1] = txt-importe.         /*Importe Vale*/ 
      END.
      iLin = iLin + 1.
  END.
         
         *****/   
*/         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cargar-vales W-Win 
PROCEDURE Cargar-vales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Tipo de fuente C39HrP48DhTt      
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chr_to_asc W-Win 
PROCEDURE chr_to_asc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER tcCodBarra AS CHAR.
DEF OUTPUT PARAMETER lcRetASc AS CHAR.
    
DEFINE VAR lLen AS INT.
DEFINE VAR lValores AS CHAR.
DEFINE VAR lChar AS CHAR.
DEFINE VAR lAsc AS INT.
DEFINE VAR lStr AS CHAR.
DEFINE VAR i AS INT.
DEFINE VAR lGuion AS CHAR.

lLen = LENGTH(tcCodBarra).
lGuion = "".
lValores = "".
REPEAT i = 1 TO lLen :
    lChar = SUBSTRING(tcCodBarra,i,1).
    lAsc = ASC(lChar).
    lStr = STRING(lAsc).
    lValores = lValores + lGuion + lStr.
    lGuion = "_".
END.

lcRetASc = lValores.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE crear-etiquetas W-Win 
PROCEDURE crear-etiquetas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
DEFINE INPUT PARAMETER pCuantos AS INT   NO-UNDO.
DEFINE INPUT PARAMETER pDeCuanto AS DEC  NO-UNDO.

DEFINE VARIABLE cLlave    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cFecha    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cImpTot   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iDigVer   AS INTEGER     NO-UNDO.

DEFINE VARIABLE cNroTck   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cVar01    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNroSec01 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNomCli   AS CHARACTER   NO-UNDO.

DEFINE VARIABLE cCodPrd   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCodPrv   AS CHARACTER   NO-UNDO.

DEFINE VARIABLE iInt   AS INTEGER     NO-UNDO.

DEFINE VARIABLE lNroTck AS INT.
DEFINE VAR lInicio AS LOGICAL.

ASSIGN 
      cLlave  = VtaCTickets.Producto
      cFecha  = SUBSTRING(STRING(YEAR(txt-fecha),"9999"),3) + 
                STRING(MONTH(txt-fecha),"99") + STRING(DAY(txt-fecha),"99")
      /*cImptot = STRING((txt-nrototal * 100),"9999999").*/
      cImptot = STRING((pDeCuanto * 100),"9999999").

  /*Busca Cliente*/
  cNomCli = txt-nomcli.

/* Por el TIcket de INICIO */
    IF ((iCol - 1) MODULO 3) = 0 THEN DO :
        ASSIGN iLin = iLin + 1
                 iCol = 1.
    END.
    FIND FIRST w-report WHERE w-report.task-no = s-task-no 
         AND w-report.llave-i = iLin NO-ERROR.
    IF NOT AVAIL w-report THEN DO:
        CREATE w-report.
        ASSIGN
            task-no    = s-task-no
            llave-i    = iLin.
    END.
    campo-c[5] = cNomCli.
    campo-d[iCol] = txt-fecha.           /*Fecha Vencimiento*/
    campo-f[iCol] = pDeCuanto.           /*Importe Vale*/
    campo-c[14 + iCol] = " " .      /* Cod Barra antes de la encriptacion */
    ASSIGN 
         campo-c[iCol] = ""
         campo-i[iCol] = 0 
         campo-c[27 + iCol] = "".
         iCol          = iCol + 1.      

/* -------------------------- */

DO iInt = 1 TO pCuantos :
          
    FIND LAST FacCorre WHERE 
              FacCorre.CodCia = S-CODCIA AND
              FacCorre.CodDoc = cCodDoc AND
              FacCorre.CodDiv = S-CODDIV EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE FacCorre THEN DO:  
        
        ASSIGN 
             cNroTck = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
             FacCorre.Correlativo = FacCorre.Correlativo + 1.                            
       
        /*cNroTck = "000" + STRING(112336,"999999").*/
    END.
    
    cVar01 = cLlave + cFecha + cNroTck + cImptot.
    
    RUN vtagn\edenred-01 (cVar01,OUTPUT iDigVer).
          
    cVar01 = cVar01 + STRING(iDigVer,"9") + "0".
    cNroSec01 = cNroTck.

    IF ((iCol - 1) MODULO 3) = 0 THEN DO :
        ASSIGN iLin = iLin + 1
                 iCol = 1.
    END.
    FIND FIRST w-report WHERE w-report.task-no = s-task-no 
         AND w-report.llave-i = iLin NO-ERROR.
    IF NOT AVAIL w-report THEN DO:
        CREATE w-report.
        ASSIGN
            task-no    = s-task-no
            llave-i    = iLin.
    END.
    ASSIGN 
            campo-c[5] = cNomCli
            campo-d[iCol] = txt-fecha            /*Fecha Vencimiento*/
            campo-f[iCol] = pDeCuanto.          /*Importe Vale*/     
    campo-c[14 + iCol] = cVar01.         /* Cod Barra antes de la encriptacion */

    RUN lib\_strto128c(cVar01, OUTPUT cVar01).
          
    ASSIGN 
         campo-c[iCol] = cVar01
         campo-i[iCol] = INTEGER(cNroSec01)
         campo-c[27 + iCol] = "" /*cVar01 Codigo de Barra Encriptada  */.
         iCol          = iCol + 1.      
END.
*/

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
  DISPLAY cboProvProd txt-codpro txtProd txtTotal TxtSerie txtNroFactura 
          txtBruto txtIgv txt-nomcli txt-codcli txtFecha txtTotalVta 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 TxtSerie txtNroFactura BtnAceptar BROWSE-4 btnAprobar 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /*RUN Carga-Datos.*/
  RUN Cargar-vales.

  IF RETURN-VALUE = 'adm-error' THEN RETURN "adm-error".

  GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
  ASSIGN
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'vta\rbvta.prl'       
    RB-REPORT-NAME = 'Vales Utilex 02 Prueba'       /* A LA MONEDA DEL DOCUMENTO */
    RB-INCLUDE-RECORDS = 'O'
    RB-FILTER = 'w-report.task-no = ' + STRING(s-task-no).

/*     RB-OTHER-PARAMETERS = 's-nomcia = ' + s-nomcia +                  */
/*                             '~ns-codcli = ' + gn-clie.codcli +        */
/*                              '~ns-nomcli = ' + gn-clie.nomcli +       */
/*                              '~np-saldo-mn = ' + STRING(x-saldo-mn) + */
/*                              '~np-saldo-me = ' + STRING(x-saldo-me).  */


  RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                    RB-REPORT-NAME,
                    RB-INCLUDE-RECORDS,
                    RB-FILTER,
                    RB-OTHER-PARAMETERS).

  /*RUN to_excel (s-task-no).*/

  FOR EACH w-report WHERE task-no = s-task-no:
      DELETE w-report.
  END.


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
  
  DO WITH FRAME {&FRAME-NAME} :
      ASSIGN txtfecha = TODAY.
      DISPLAY txtfecha.

  END.
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DISABLE btnAprobar WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
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
  {src/adm/template/snd-list.i "tmp-CcbDDocu"}
  {src/adm/template/snd-list.i "Almmmatg"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE to_excel W-Win 
PROCEDURE to_excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER tcTask AS INT.

DEFINE VAR lCodBarra AS CHAR.
DEFINE VAR lCodBarraAsc AS CHAR.

FOR EACH w-report WHERE task-no = tcTask:    
    lCodBarra = w-report.campo-c[1].
    RUN chr_to_asc(lCodBarra,OUTPUT  lCodBarraAsc).
    ASSIGN w-report.campo-c[11]=lCodBarraAsc.
    /**/
    lCodBarra = w-report.campo-c[2].
    RUN chr_to_asc(lCodBarra,OUTPUT  lCodBarraAsc).
    ASSIGN w-report.campo-c[12]=lCodBarraAsc.
    /**/
    lCodBarra = w-report.campo-c[3].
    RUN chr_to_asc(lCodBarra,OUTPUT  lCodBarraAsc).
    ASSIGN w-report.campo-c[13]=lCodBarraAsc.

END.

/* A excel */
        DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
        DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
        DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

        DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

        DEFINE VARIABLE iCount                  AS INTEGER init 1.
        DEFINE VARIABLE iIndex                  AS INTEGER.
        DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
        DEFINE VARIABLE cColumn                 AS CHARACTER.
        DEFINE VARIABLE cRange                  AS CHARACTER.
        DEFINE VARIABLE x-signo                 AS DECI.

        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication.

        /* launch Excel so it is visible to the user */
        chExcelApplication:Visible = TRUE.

        /* Para crear a new Workbook */
        chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(1).

iColumn = 1.
FOR EACH w-report WHERE task-no = tcTask:    
     iColumn = iColumn + 1.
     cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[15].

    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[1].

    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[11].

    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[16].

    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[2].

    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[12].

    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[17].

    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[3].

    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[13].

END.

    chWorkSheet:SaveAs("c:\ciman\tickes_veri.xls").
        chExcelApplication:DisplayAlerts = False.
        chExcelApplication:Quit().

        /* release com-handles */
        RELEASE OBJECT chExcelApplication NO-ERROR.      
        RELEASE OBJECT chWorkbook NO-ERROR.
        RELEASE OBJECT chWorksheet NO-ERROR.
        RELEASE OBJECT chWorksheetRange NO-ERROR. 


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
/*
EMPTY TEMP-TABLE tmp-ccbddocu.

DEFINE VAR lNroDoc AS CHAR.

lNroDoc = STRING(txtSerie,"999") + STRING(txtNroFactura,"999").

FOR EACH ccbddocu WHERE ccbddocu.codcia = s-codcia AND ccbddocu.coddoc = xCodDoc AND 
                        ccbddocu.nrodoc = lNroDoc NO-LOCK : 
END.
*/
DEFINE VAR lNroDcto AS CHAR.
DEFINE VAR cCodMat AS CHAR.
DEFINE VAR rRowId AS ROWID.
DEFINE VAR rRowId2 AS ROWID.
DEFINE VAR cLogMov AS CHAR.
DEFINE VAR cDenominacion AS CHAR.

lNroDcto = STRING(txtSerie,"999") + STRING(txtNroFactura,"999999").

FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                        ccbcdocu.coddoc = xCodDoc AND 
                        ccbcdocu.nrodoc = lNroDcto  AND 
                        ccbcdocu.flgest <> 'A' NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN DO:
    MESSAGE "El Nro de Factura no existe".
    RETURN "ADM-ERROR".
END.
IF ccbcdocu.flgest <> 'E' THEN DO:
    MESSAGE "La factura ya fue APROBADO o CANCELADA".
    RETURN "ADM-ERROR".
END.

SESSION:SET-WAIT-STATE('GENERAL').

DEFINE BUFFER b-ccbddocu FOR ccbddocu.
DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.

/* 09Feb2017, segun Ruben que la replica haga la transferencia*/
/*DISABLE TRIGGERS FOR LOAD OF vtatabla.*/

/* Grabo el inicio y fin del numero del vale en la factura */
FOR EACH ccbddocu OF ccbcdocu NO-LOCK : 
    cCodMat = ccbddocu.codmat.
    rRowId = ROWID(ccbddocu).
    FIND FIRST tmp-ccbddocu WHERE tmp-ccbddocu.codmat = cCodMat NO-ERROR.
    IF AVAILABLE tmp-ccbddocu THEN DO:
        FIND FIRST b-ccbddocu WHERE ROWID(b-ccbddocu)=rRowId NO-ERROR.
        IF AVAILABLE b-ccbddocu THEN DO:
            ASSIGN b-ccbddocu.impdcto_adelanto[1] = tmp-ccbddocu.imppro     /* Inicio Nro Vale */
                    b-ccbddocu.impdcto_adelanto[2] = tmp-ccbddocu.impdto2.  /* Final Nro Vale */
        END.

        /* Actualizo el ultimo vale guardado x cada denominacion  */
        cDenominacion = tmp-ccbddocu.almdes.
        FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                                vtatabla.tabla = 'VUTILEX' AND 
                                vtatabla.llave_c2 = txt-codpro AND
                                vtatabla.llave_c3 = txtProd AND 
                                vtatabla.libre_c03 = 'DETALLE' AND
                                vtatabla.llave_c4 = cDenominacion 
                                EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE vtatabla THEN DO:
            ASSIGN vtatabla.rango_valor[1] = tmp-ccbddocu.impdto2 + 1.
        END.
        
    END.
END.

/*
codcia = 1 and tabla = 'VUTILEX' and llave_c3 = '0005' and libre_c03 = 'DETALLE'
*/
  
/* APROBAR a la factura (FAI) */
rRowId2 = ROWID(ccbcdocu).
FIND FIRST b-ccbcdocu WHERE ROWID(b-ccbcdocu) = rRowId2 EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE b-ccbcdocu THEN DO:
    cLogMov = S-USER-ID + "|" + STRING(TODAY,"99/99/9999") + "|" + STRING(TIME,"HH:MM:SS").
    ASSIGN b-ccbcdocu.flgest = 'P'
            b-ccbcdocu.sede = cLogMov.
END.

RELEASE vtatabla.
RELEASE b-ccbddocu.
RELEASE b-ccbcdocu.

SESSION:SET-WAIT-STATE('').

DISABLE btnAprobar WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-valida W-Win 
PROCEDURE ue-valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tmp-ccbddocu.
{&OPEN-QUERY-BROWSE-4}

DISPLAY "" @ txt-codcli WITH FRAME {&FRAME-NAME}.
DISPLAY "" @ txt-nomcli WITH FRAME {&FRAME-NAME}.

DISPLAY "0.00" @ txtBruto WITH FRAME {&FRAME-NAME}.
DISPLAY "0.00" @ txtIgv WITH FRAME {&FRAME-NAME}.
DISPLAY "0.00" @ txtTotal WITH FRAME {&FRAME-NAME}.


/* Consistencias */
IF cboProvProd = '' OR cboProvProd = ? THEN DO:
    MESSAGE "Seleccione el Producto".
    RETURN "ADM-ERROR".
END.
IF txtProd = '' OR txtProd = ? THEN DO:
    MESSAGE "Ingrese el Producto".
    RETURN "ADM-ERROR".
END.
IF txtNroFactura = 0 OR txtNroFactura = ? THEN DO:
    MESSAGE "Ingrese el Nro de Factura".
    RETURN "ADM-ERROR".
END.

/* Validaciones */
DEFINE VAR lNroDcto AS CHAR.

lNroDcto = STRING(txtSerie,"999") + STRING(txtNroFactura,"999999").

FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                        ccbcdocu.coddoc = xCodDoc AND 
                        ccbcdocu.nrodoc = lNroDcto  AND 
                        ccbcdocu.flgest <> 'A' NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN DO:
    MESSAGE "El Nro de Factura no existe".
    RETURN "ADM-ERROR".
END.
IF ccbcdocu.flgest <> 'E' THEN DO:
    MESSAGE "La factura ya fue APROBADO o CANCELADA".
    RETURN "ADM-ERROR".
END.

txt-CodCli = ccbcdocu.codcli.

FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = txt-codcli NO-LOCK NO-ERROR.
IF AVAIL gn-clie THEN  DO:
    DISPLAY gn-clie.codcli @ txt-codcli WITH FRAME {&FRAME-NAME}.
    DISPLAY gn-clie.nomcli @ txt-nomcli WITH FRAME {&FRAME-NAME}.
END.
ELSE DO:
    DISPLAY "" @ txt-codcli WITH FRAME {&FRAME-NAME}.
    DISPLAY "" @ txt-nomcli WITH FRAME {&FRAME-NAME}.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um-suma W-Win 
PROCEDURE um-suma :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

