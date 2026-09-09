&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-GENER FOR TabGener.
DEFINE BUFFER B-MATE FOR Almmmate.
DEFINE NEW SHARED TEMP-TABLE T-DREPO LIKE almdrepo
       FIELD SolStkAct AS DEC
       FIELD SolStkCom AS DEC
       FIELD SolStkDis AS DEC
       FIELD SolStkMax AS DEC
       FIELD SolStkTra AS DEC
       FIELD DesStkAct AS DEC
       FIELD DesStkCom AS DEC
       FIELD DesStkDis AS DEC
       FIELD DesStkMax AS DEC
       FIELD PorcReposicion AS DEC
       FIELD FSGrupo AS DEC
       FIELD GrpStkDis AS DEC
       FIELD ControlDespacho AS LOG INITIAL NO
       FIELD VtaGrp30 AS DEC
       FIELD VtaGrp60 AS DEC
       FIELD VtaGrp90 AS DEC
       FIELD VtaGrp30y AS DEC
       FIELD DesCmpTra AS DEC
       FIELD VtaGrp60y AS DEC
       FIELD VtaGrp90y AS DEC
       FIELD DesStkTra AS DEC
       FIELD ClfGral AS CHAR
       FIELD ClfMayo AS CHAR
       FIELD ClfUtil AS CHAR
       FIELD SolCmpTra AS DEC.
DEFINE TEMP-TABLE T-GENER NO-UNDO LIKE TabGener.
DEFINE TEMP-TABLE T-MATE NO-UNDO LIKE Almmmate
       FIELD CmpTra AS DEC.
DEFINE TEMP-TABLE T-MATE-2 NO-UNDO LIKE Almmmate
       FIELD DesStkMax AS DEC
       FIELD DesStkDis AS DEC
       FIELD DesCmpTra AS DEC.
DEFINE TEMP-TABLE T-MATG NO-UNDO LIKE Almmmatg.
DEFINE TEMP-TABLE t-report NO-UNDO LIKE w-report.



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

DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF VAR pCodDiv AS CHAR NO-UNDO.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR pv-codcia AS INT.

DEF VAR s-coddoc AS CHAR INIT 'R/A' NO-UNDO.
DEF VAR s-tipmov AS CHAR INIT 'A' NO-UNDO.

DEF VAR x-Clasificaciones AS CHAR NO-UNDO.


DEF BUFFER MATE FOR Almmmate.

DEF NEW SHARED VAR s-nivel-acceso AS INT INIT 0.
DEF NEW SHARED VAR s-Reposicion AS LOG.     /* Campaña Yes, No Campaña No */
DEF NEW SHARED VAR lh_handle AS HANDLE.


DEF VAR X-REP AS CHAR NO-UNDO.
DEF VAR x-Claves AS CHAR INIT 'nivel1,nivel2' NO-UNDO.

/* RUN lib/_clave3 (x-claves, OUTPUT x-rep). */
/* s-nivel-acceso = LOOKUP(x-rep, x-Claves). */
s-nivel-acceso = 1.

FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = s-codalm
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almacen THEN DO:
    MESSAGE 'Almacén:' s-codalm 'NO definido' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
pCodDiv = Almacen.coddiv.

DEFINE TEMP-TABLE tmp-tabla
    FIELD t-CodAlm LIKE Almacen.codalm  FORMAT 'x(3)'
    FIELD t-CodDoc LIKE FacDPedi.CodDoc FORMAT "XXX"
    FIELD t-Nroped LIKE FacDPedi.NroPed FORMAT "XXX-XXXXXXXX"
    FIELD t-CodDiv LIKE FacCPedi.CodDiv FORMAT 'x(5)'
    FIELD t-FchPed LIKE FacDPedi.FchPed
    FIELD t-NomCli LIKE FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(35)"
    FIELD t-CodMat LIKE FacDPedi.codmat
    FIELD t-Canped LIKE FacDPedi.CanPed.

DEF TEMP-TABLE T-DREPO-2 LIKE T-DREPO.
DEF TEMP-TABLE T-DREPO-3 LIKE T-DREPO.
DEF TEMP-TABLE T-DREPO-4 LIKE T-DREPO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-9 RECT-1 RECT-11 BUTTON-4 BUTTON-7 ~
COMBO-BOX-Tipo SELECT-Clasificacion FILL-IN-CodPro FILL-IN-PorRep ~
FILL-IN-Marca FILL-IN-PorStkMax BUTTON-20 BUTTON-1 BUTTON-5 ~
BUTTON-IMPORTAR-EXCEL 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Tipo FILL-IN-Temporada ~
FILL-IN-Almacen FILL-IN-CodFam FILL-IN-Total COMBO-BOX-Tipo FILL-IN-SubFam ~
FILL-IN-Peso SELECT-Clasificacion FILL-IN-CodPro FILL-IN-NomPro ~
FILL-IN-PorRep FILL-IN-Volumen FILL-IN-Marca FILL-IN-PorStkMax ~
FILL-IN-Stock FILL-IN-Texto FILL-IN-Venta30d FILL-IN-Venta30dy ~
FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fClfGral W-Win 
FUNCTION fClfGral RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR, INPUT pReposicion AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fClfMayo W-Win 
FUNCTION fClfMayo RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR, INPUT pReposicion AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fClfUtil W-Win 
FUNCTION fClfUtil RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR, INPUT pReposicion AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fStockTransito W-Win 
FUNCTION fStockTransito RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_bcompraautomatica AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv08 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "CALCULO COMPRA AUTOMATICA" 
     SIZE 27 BY 1.12.

DEFINE BUTTON BUTTON-20 
     IMAGE-UP FILE "img/b-buscar.ico":U
     LABEL "Button 20" 
     SIZE 4 BY 1.08.

DEFINE BUTTON BUTTON-4 
     LABEL "..." 
     SIZE 4 BY .81.

DEFINE BUTTON BUTTON-5 
     LABEL "GENERAR EXCEL" 
     SIZE 21 BY 1.12.

DEFINE BUTTON BUTTON-6 
     LABEL "..." 
     SIZE 4 BY .81.

DEFINE BUTTON BUTTON-7 
     LABEL "Limpiar Filtros" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-IMPORTAR-EXCEL 
     LABEL "IMPORTAR EXCEL" 
     SIZE 20 BY 1.12.

DEFINE VARIABLE COMBO-BOX-Tipo AS CHARACTER FORMAT "X(256)":U INITIAL "General" 
     LABEL "Clasificación" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "General","Mayorista","Utilex" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Almacen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1
     BGCOLOR 11 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Familias" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPro AS CHARACTER FORMAT "x(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Marca AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 64 BY .85 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Peso AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Total kg" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-PorRep AS DECIMAL FORMAT ">>9.99":U INITIAL 100 
     LABEL "% de Compra" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-PorStkMax AS DECIMAL FORMAT ">>9.99":U INITIAL 100 
     LABEL "% de Stock Máximo" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Stock AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Total Stock S/" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-SubFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "SubFamilias" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-Temporada AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1.15
     BGCOLOR 0 FGCOLOR 14 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-Texto AS CHARACTER FORMAT "X(256)":U 
     LABEL "Archivo Texto" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Tipo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1.15
     BGCOLOR 0 FGCOLOR 14 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-Total AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Total S/" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Venta30d AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Vta 30d atras S/" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Venta30dy AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Vta 30d adel S/" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Volumen AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Total m3" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 141 BY 1.73
     BGCOLOR 11 .

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 28 BY 5.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 113 BY 5.92.

DEFINE VARIABLE SELECT-Clasificacion AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE 
     LIST-ITEM-PAIRS "Sin Clasificacion","",
                     "A","A",
                     "B","B",
                     "C","C",
                     "D","D",
                     "E","E",
                     "F","F" 
     SIZE 13 BY 3.81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Tipo AT ROW 1.27 COL 68 COLON-ALIGNED NO-LABEL WIDGET-ID 86
     FILL-IN-Temporada AT ROW 1.27 COL 115 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     FILL-IN-Almacen AT ROW 1.38 COL 7 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     FILL-IN-CodFam AT ROW 3.15 COL 16 COLON-ALIGNED WIDGET-ID 14
     BUTTON-4 AT ROW 3.15 COL 67 WIDGET-ID 12
     BUTTON-7 AT ROW 3.15 COL 71 WIDGET-ID 58
     FILL-IN-Total AT ROW 3.15 COL 129 COLON-ALIGNED WIDGET-ID 94
     COMBO-BOX-Tipo AT ROW 3.42 COL 96 COLON-ALIGNED WIDGET-ID 88
     FILL-IN-SubFam AT ROW 3.96 COL 16 COLON-ALIGNED WIDGET-ID 54
     BUTTON-6 AT ROW 3.96 COL 67 WIDGET-ID 52
     FILL-IN-Peso AT ROW 3.96 COL 129 COLON-ALIGNED WIDGET-ID 96
     SELECT-Clasificacion AT ROW 4.23 COL 98 NO-LABEL WIDGET-ID 46
     FILL-IN-CodPro AT ROW 4.77 COL 16 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-NomPro AT ROW 4.77 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     FILL-IN-PorRep AT ROW 4.77 COL 86 COLON-ALIGNED WIDGET-ID 42
     FILL-IN-Volumen AT ROW 4.77 COL 129 COLON-ALIGNED WIDGET-ID 98
     FILL-IN-Marca AT ROW 5.58 COL 16 COLON-ALIGNED WIDGET-ID 28
     FILL-IN-PorStkMax AT ROW 5.58 COL 86 COLON-ALIGNED WIDGET-ID 84
     FILL-IN-Stock AT ROW 5.85 COL 129 COLON-ALIGNED WIDGET-ID 100
     FILL-IN-Texto AT ROW 6.38 COL 16 COLON-ALIGNED WIDGET-ID 64
     BUTTON-20 AT ROW 6.38 COL 67 WIDGET-ID 66
     FILL-IN-Venta30d AT ROW 6.65 COL 129 COLON-ALIGNED WIDGET-ID 102
     BUTTON-1 AT ROW 7.46 COL 3 WIDGET-ID 2
     BUTTON-5 AT ROW 7.46 COL 30 WIDGET-ID 34
     BUTTON-IMPORTAR-EXCEL AT ROW 7.46 COL 51 WIDGET-ID 50
     FILL-IN-Venta30dy AT ROW 7.46 COL 129 COLON-ALIGNED WIDGET-ID 104
     FILL-IN-Mensaje AT ROW 25.77 COL 51 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     "Filtros" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.73 COL 5 WIDGET-ID 20
          BGCOLOR 1 FGCOLOR 15 
     RECT-9 AT ROW 2.88 COL 2 WIDGET-ID 26
     RECT-1 AT ROW 1 COL 2 WIDGET-ID 40
     RECT-11 AT ROW 2.88 COL 115 WIDGET-ID 92
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 143.86 BY 26.08
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-GENER B "?" ? INTEGRAL TabGener
      TABLE: B-MATE B "?" ? INTEGRAL Almmmate
      TABLE: T-DREPO T "NEW SHARED" ? INTEGRAL almdrepo
      ADDITIONAL-FIELDS:
          FIELD SolStkAct AS DEC
          FIELD SolStkCom AS DEC
          FIELD SolStkDis AS DEC
          FIELD SolStkMax AS DEC
          FIELD SolStkTra AS DEC
          FIELD DesStkAct AS DEC
          FIELD DesStkCom AS DEC
          FIELD DesStkDis AS DEC
          FIELD DesStkMax AS DEC
          FIELD PorcReposicion AS DEC
          FIELD FSGrupo AS DEC
          FIELD GrpStkDis AS DEC
          FIELD ControlDespacho AS LOG INITIAL NO
          FIELD VtaGrp30 AS DEC
          FIELD VtaGrp60 AS DEC
          FIELD VtaGrp90 AS DEC
          FIELD VtaGrp30y AS DEC
          FIELD DesCmpTra AS DEC
          FIELD VtaGrp60y AS DEC
          FIELD VtaGrp90y AS DEC
          FIELD DesStkTra AS DEC
          FIELD ClfGral AS CHAR
          FIELD ClfMayo AS CHAR
          FIELD ClfUtil AS CHAR
          FIELD SolCmpTra AS DEC
      END-FIELDS.
      TABLE: T-GENER T "?" NO-UNDO INTEGRAL TabGener
      TABLE: T-MATE T "?" NO-UNDO INTEGRAL Almmmate
      ADDITIONAL-FIELDS:
          FIELD CmpTra AS DEC
      END-FIELDS.
      TABLE: T-MATE-2 T "?" NO-UNDO INTEGRAL Almmmate
      ADDITIONAL-FIELDS:
          FIELD DesStkMax AS DEC
          FIELD DesStkDis AS DEC
          FIELD DesCmpTra AS DEC
      END-FIELDS.
      TABLE: T-MATG T "?" NO-UNDO INTEGRAL Almmmatg
      TABLE: t-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "PEDIDO PARA COMPRAS AUTOMATICA"
         HEIGHT             = 26.08
         WIDTH              = 143.86
         MAX-HEIGHT         = 32.46
         MAX-WIDTH          = 205.72
         VIRTUAL-HEIGHT     = 32.46
         VIRTUAL-WIDTH      = 205.72
         MAX-BUTTON         = no
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
/* SETTINGS FOR BUTTON BUTTON-6 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Almacen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Peso IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Stock IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-SubFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Temporada IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Texto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Tipo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Total IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Venta30d IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Venta30dy IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Volumen IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* PEDIDO PARA COMPRAS AUTOMATICA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PEDIDO PARA COMPRAS AUTOMATICA */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* CALCULO COMPRA AUTOMATICA */
DO:        
  DEF VAR k AS INT NO-UNDO.
  DEF VAR j AS INT NO-UNDO.

  ASSIGN
      FILL-IN-CodFam FILL-IN-SubFam FILL-IN-CodPro FILL-IN-Marca 
      FILL-IN-PorRep FILL-IN-Texto FILL-IN-PorStkMax
      COMBO-BOX-Tipo
      .
  x-Clasificaciones = ''.
  j = 0.
  DO k = 1 TO NUM-ENTRIES(SELECT-Clasificacion:LIST-ITEM-PAIRS):
      IF SELECT-Clasificacion:IS-SELECTED(k) THEN DO:
          j = j + 1.
          x-Clasificaciones = x-Clasificaciones + (IF j = 1 THEN '' ELSE ',') +
              SELECT-Clasificacion:ENTRY(k).

      END.
  END.
  IF j = 0 THEN DO:
      MESSAGE 'Debe al menos seleccionar una clasificación' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  
  ASSIGN
      BUTTON-4:SENSITIVE = NO
      BUTTON-6:SENSITIVE = NO
      BUTTON-20:SENSITIVE = NO
      FILL-IN-CodPro:SENSITIVE = NO
      FILL-IN-Marca:SENSITIVE = NO
      FILL-IN-Texto:SENSITIVE = NO.

  /* Verificamos que sea una ALMACEN PRINCIPAL */
  DEF VAR pOk AS LOG NO-UNDO.
  RUN gn/fAlmPrincipal (INPUT s-CodAlm, OUTPUT pOk).
  IF pOk = NO THEN DO:
      MESSAGE 'Solo funciona si es un almacén principal' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.

  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal.
  FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  SESSION:SET-WAIT-STATE('').
  MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-20
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-20 W-Win
ON CHOOSE OF BUTTON-20 IN FRAME F-Main /* Button 20 */
DO:
  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR x-Ok      AS LOG NO-UNDO.
  SYSTEM-DIALOG GET-FILE x-Archivo 
      FILTERS "Texto: *.prn *.txt" "*.prn,*.txt"
      TITLE "SELECCIONE EL ARCHIVO TEXTO"
      UPDATE x-Ok.
  IF x-Ok = NO THEN RETURN NO-APPLY.
  FILL-IN-Texto:SCREEN-VALUE = x-Archivo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* ... */
DO:
    DEFINE VARIABLE x-Familias AS CHAR NO-UNDO.
    x-Familias = FILL-IN-CodFam:SCREEN-VALUE.
    RUN alm/d-familias (INPUT-OUTPUT x-familias).
    IF x-Familias <> FILL-IN-CodFam:SCREEN-VALUE THEN FILL-IN-SubFam:SCREEN-VALUE = ''.
    FILL-IN-CodFam:SCREEN-VALUE = x-familias.
    IF NUM-ENTRIES(x-familias) = 1 THEN BUTTON-6:SENSITIVE = YES.
    ELSE ASSIGN BUTTON-6:SENSITIVE = NO FILL-IN-SubFam:SCREEN-VALUE = ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* GENERAR EXCEL */
DO:
   RUN Excel IN h_bcompraautomatica.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* ... */
DO:
    DEFINE VARIABLE x-SubFamilias AS CHAR NO-UNDO.
    /*x-SubFamilias = FILL-IN-CodFam:SCREEN-VALUE.*/
    RUN alm/d-subfamilias (INPUT FILL-IN-CodFam:SCREEN-VALUE, INPUT-OUTPUT x-SubFamilias).
    FILL-IN-SubFam:SCREEN-VALUE = x-SubFamilias.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 W-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* Limpiar Filtros */
DO:
  RUN Limpiar-Filtros.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-IMPORTAR-EXCEL
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-IMPORTAR-EXCEL W-Win
ON CHOOSE OF BUTTON-IMPORTAR-EXCEL IN FRAME F-Main /* IMPORTAR EXCEL */
DO:
   RUN Importar-Excel IN h_bcompraautomatica.
   /* Renumeramos */
   DEF VAR x-Item  AS INT INIT 1 NO-UNDO.
   FOR EACH T-DREPO BY T-DREPO.CodMat:
       T-DREPO.ITEM    = x-Item.
       x-Item = x-Item + 1.
   END.
   RUN dispatch IN h_bcompraautomatica ('open-query':U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodFam W-Win
ON LEAVE OF FILL-IN-CodFam IN FRAME F-Main /* Familias */
DO:
  ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPro W-Win
ON LEAVE OF FILL-IN-CodPro IN FRAME F-Main /* Proveedor */
DO:
  FILL-IN-NomPro:SCREEN-VALUE = ''.
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND gn-prov WHERE codcia = pv-codcia
      AND codpro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-prov THEN DO:
      MESSAGE 'Proveedor NO registrado' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  ASSIGN {&self-name}.
  FILL-IN-NomPro:SCREEN-VALUE = gn-prov.nompro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Marca W-Win
ON LEAVE OF FILL-IN-Marca IN FRAME F-Main /* Marca */
DO:
    ASSIGN {&self-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Marca W-Win
ON LEFT-MOUSE-DBLCLICK OF FILL-IN-Marca IN FRAME F-Main /* Marca */
OR F8 OF FILL-IN-Marca
    DO:
        ASSIGN 
            input-var-1 = 'MK'
            input-var-2 = ''
            input-var-3 = ''.
        RUN lkup/c-almtab ('Marcas').
        IF output-var-1 <> ? THEN DO:
            SELF:SCREEN-VALUE = output-var-3.
        END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-PorRep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-PorRep W-Win
ON LEAVE OF FILL-IN-PorRep IN FRAME F-Main /* % de Compra */
DO:
    ASSIGN {&self-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-PorStkMax
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-PorStkMax W-Win
ON LEAVE OF FILL-IN-PorStkMax IN FRAME F-Main /* % de Stock Máximo */
DO:
    ASSIGN {&self-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-SubFam W-Win
ON LEAVE OF FILL-IN-SubFam IN FRAME F-Main /* SubFamilias */
DO:
    ASSIGN {&self-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME SELECT-Clasificacion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SELECT-Clasificacion W-Win
ON VALUE-CHANGED OF SELECT-Clasificacion IN FRAME F-Main
DO:
    ASSIGN {&self-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
lh_handle = THIS-PROCEDURE.

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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'ALM/bcompraautomatica.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ,
                     SortBy-Case = Codigo':U ,
             OUTPUT h_bcompraautomatica ).
       RUN set-position IN h_bcompraautomatica ( 8.81 , 2.00 ) NO-ERROR.
       RUN set-size IN h_bcompraautomatica ( 16.65 , 141.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv08.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv08 ).
       RUN set-position IN h_p-updv08 ( 25.50 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv08 ( 1.42 , 49.86 ) NO-ERROR.

       /* Links to SmartBrowser h_bcompraautomatica. */
       RUN add-link IN adm-broker-hdl ( h_p-updv08 , 'TableIO':U , h_bcompraautomatica ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_bcompraautomatica ,
             FILL-IN-Venta30dy:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv08 ,
             h_bcompraautomatica , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ARTICULOS-A-SOLICITAR W-Win 
PROCEDURE ARTICULOS-A-SOLICITAR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodPro AS CHAR.
DEF INPUT PARAMETER pMarca  AS CHAR.
DEF INPUT PARAMETER pCodFam AS CHAR.
DEF INPUT PARAMETER pSubFam AS CHAR.

/* *********************************************************************** */
/* 1ro. CARGAMOS LOS PRODUCTOS ******************************************* */
/* *********************************************************************** */
DEF VAR x-Linea AS CHAR NO-UNDO.

EMPTY TEMP-TABLE T-MATG.
IF NOT TRUE <> (FILL-IN-Texto > '') THEN DO:
    FILE-INFO:FILE-NAME = FILL-IN-Texto.
    IF FILE-INFO:FILE-NAME = ? THEN DO:
        MESSAGE 'Error en el archivo texto' VIEW-AS ALERT-BOX WARNING.
        RETURN 'ADM-ERROR'.
    END.
    INPUT FROM VALUE(FILL-IN-Texto).
    REPEAT:
        IMPORT UNFORMATTED x-Linea.
        IF x-Linea = '' THEN LEAVE.
        FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
            AND Almmmatg.codmat = x-Linea
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmatg THEN DO:
            FIND FIRST T-MATG OF Almmmatg EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE T-MATG THEN CREATE T-MATG.
            BUFFER-COPY Almmmatg TO T-MATG.
        END.
    END.
    INPUT CLOSE.
END.
ELSE DO:
    FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.tpoart = "A"
        AND LOOKUP(Almmmatg.TipRot[1], x-Clasificaciones) > 0
        AND (pCodFam = "" OR LOOKUP(Almmmatg.codfam, pCodFam) > 0)
        AND (pSubFam = "" OR LOOKUP(Almmmatg.subfam, pSubFam) > 0)
        AND (pCodPro = "" OR Almmmatg.codpr1 = pCodPro)
        AND (pMarca = "" OR Almmmatg.desmar BEGINS pMarca):
        FIND FIRST FacTabla WHERE FacTabla.codcia = Almmmatg.codcia 
            AND FacTabla.tabla = 'RANKVTA' 
            AND FacTabla.codigo = Almmmatg.codmat
            NO-LOCK NO-ERROR.
        IF AVAILABLE FacTabla THEN DO:
            IF s-Reposicion = YES /* Campaña */ THEN DO:
                IF COMBO-BOX-Tipo = "General" AND LOOKUP(factabla.campo-c[1],x-Clasificaciones) = 0 THEN NEXT.
                IF COMBO-BOX-Tipo = "Utilex" AND LOOKUP(factabla.campo-c[2],x-Clasificaciones) = 0 THEN NEXT.
                IF COMBO-BOX-Tipo = "Mayorista" AND LOOKUP(factabla.campo-c[3],x-Clasificaciones) = 0 THEN NEXT.
            END.
            ELSE DO:
                /* No Campaña */
                IF COMBO-BOX-Tipo = "General" AND LOOKUP(factabla.campo-c[4],x-Clasificaciones) = 0 THEN NEXT.
                IF COMBO-BOX-Tipo = "Utilex" AND LOOKUP(factabla.campo-c[5],x-Clasificaciones) = 0 THEN NEXT.
                IF COMBO-BOX-Tipo = "Mayorista" AND LOOKUP(factabla.campo-c[6],x-Clasificaciones) = 0 THEN NEXT.
            END.
        END.
        FIND FIRST T-MATG OF Almmmatg EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE T-MATG THEN CREATE T-MATG.
        BUFFER-COPY Almmmatg TO T-MATG.
    END.
END.
/* *********************************************************************** */
/* 2do DEFINIMOS LA CANTIDAD A REPONER *********************************** */
/* *********************************************************************** */
DEF VAR pCodigo AS CHAR NO-UNDO.

EMPTY TEMP-TABLE T-MATE.
FIND FIRST TabGener WHERE TabGener.CodCia = s-codcia
    AND TabGener.Clave = "ZG"
    AND TabGener.Libre_c01 = s-CodAlm
    AND TabGener.Libre_l01 = YES
    NO-LOCK.
pCodigo = TabGener.Codigo.  /* Zona Geografica que nos interesa Ej. ATE */
/* Barremos producto por producto */
FOR EACH T-MATG NO-LOCK:
    /* Barremos todos los almacenes de la sede por cada producto */
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "PROCESANDO CD: " + T-MATG.codmat + " " + T-MATG.desmat.
    FOR EACH TabGener NO-LOCK WHERE TabGener.CodCia = s-CodCia
        AND TabGener.Clave = "ZG"
        AND TabGener.Codigo = pCodigo,
        FIRST Almtabla NO-LOCK WHERE Almtabla.tabla = Tabgener.clave
        AND Almtabla.codigo = Tabgener.codigo:
        FIND FIRST Almmmate WHERE Almmmate.CodCia = s-CodCia
            AND Almmmate.CodAlm = TabGener.Libre_c01
            AND Almmmate.codmat = T-MATG.CodMat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmate THEN NEXT.
        FIND FIRST T-MATE WHERE T-MATE.CodMat = T-MATG.CodMat EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE T-MATE THEN DO:
            CREATE T-MATE.
            BUFFER-COPY Almmmate
                EXCEPT Almmmate.StkAct Almmmate.StkMin Almmmate.StkRep Almmmate.StkComprometido
                TO T-MATE
                ASSIGN T-MATE.CodAlm = s-CodAlm.    /* OJO */
        END.
        ASSIGN
            /* Stock Disponible Solicitante */
            T-MATE.StkAct = T-MATE.StkAct + (Almmmate.StkAct - Almmmate.StkComprometido)
            /* Stock Comprometido */
            T-MATE.StkComprometido = T-MATE.StkComprometido + Almmmate.StkComprometido
            /* Stock Maximo + Seguridad */
            T-MATE.StkMin = T-MATE.StkMin + Almmmate.StkMin
            /* Stock en Tránsito Solicitante */
            T-MATE.StkRep = T-MATE.StkRep + fStockTransito().
        /* Stock en transito compra */
        FIND OOComPend WHERE OOComPend.CodAlm = Almmmate.codalm
            AND OOComPend.CodMat = Almmmate.codmat
            NO-LOCK NO-ERROR.
        IF AVAILABLE OOComPend THEN
            ASSIGN
            T-MATE.CmpTra = T-MATE.CmpTra + (OOComPend.CanPed - OOComPend.CanAte ).
    END.    /* EACH TabGener */   
END.    /* EACH T-MATG */
/* Depuración final */
FOR EACH T-MATE:
    /* RHC 04/0/17 Primero lo afectamos por el "% de Stock Maximo" */
    T-MATE.StkMin = T-MATE.StkMin * FILL-IN-PorStkMax / 100.
    IF T-MATE.StkMin - (T-MATE.StkAct + T-MATE.StkRep + T-MATE.CmpTra) <= 0 THEN DELETE T-MATE.
END.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-1-Registro W-Win 
PROCEDURE Carga-1-Registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        CREATE T-DREPO.
        ASSIGN
            T-DREPO.Origen = 'AUT'
            T-DREPO.CodCia = s-codcia 
            T-DREPO.CodAlm = s-codalm 
            T-DREPO.Item = 1
            T-DREPO.AlmPed = '11'
            T-DREPO.CodMat = '000150'
            T-DREPO.CanReq = 100
            T-DREPO.CanGen = 100
            T-DREPO.StkAct = 100.
        RUN adm-open-query-cases IN h_bcompraautomatica.
        /*RUN adm-row-available IN h_b-pedrepaut.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CARGA-REPOSICION W-Win 
PROCEDURE CARGA-REPOSICION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* *************************************************************** */
/* 1ra parte: DETERMINAMOS SI EL PRODUCTO NECESITA REPOSICION O NO */
/* *************************************************************** */
DEF VAR x-StockMaximo   AS DEC NO-UNDO.
DEF VAR x-EmpaqueInner  AS DEC NO-UNDO.
DEF VAR x-EmpaqueMaster AS DEC NO-UNDO.
DEF VAR x-Empaque       AS DEC NO-UNDO.
DEF VAR x-StkAct AS DEC NO-UNDO.
DEF VAR x-CompraTransito AS DEC NO-UNDO.
DEF VAR pAReponer   AS DEC NO-UNDO.
DEF VAR pReposicion AS DEC NO-UNDO.
DEF VAR dFactor AS DEC NO-UNDO.
DEF VAR p      AS INT NO-UNDO.
DEF VAR k      AS INT NO-UNDO.

/* Stock Minimo */
ASSIGN
    x-StockMaximo   = T-MATE.StkMin
    x-EmpaqueInner  = T-MATG.StkRep     /* Empaque Inner */
    x-EmpaqueMaster = T-MATG.CanEmp     /* Empaque Master */
    x-CompraTransito = T-MATE.CmpTra
    x-StkAct        = T-MATE.StkAct + T-MATE.StkRep.      /* Stock Actual - Stock Comprometido + Tránsito */
IF x-StkAct < 0 THEN x-StkAct = 0.
/* ********************* Cantidad de Reposicion ******************* */
/* Definimos el stock maximo */
/* RHC 05/06/2014 Cambio de filosofía, ahora es el % del stock mínimo */
IF x-StkAct >= (x-StockMaximo * FILL-IN-PorRep / 100) THEN RETURN.    /* NO VA */
/* Compras en tránsito */
/* FIND OOComPend WHERE OOComPend.CodMat = T-MATG.codmat                               */
/*     AND OOComPend.CodAlm = s-CodAlm                                                 */
/*     NO-LOCK NO-ERROR.                                                               */
/* IF AVAILABLE OOComPend THEN x-CompraTransito = OOComPend.CanPed - OOComPend.CanAte. */
/* A Comprar */
pAReponer = (x-StockMaximo - x-CompraTransito) - x-StkAct.
pReposicion = pAReponer.
IF pReposicion <= 0 THEN RETURN.    /* NO VA */
/* ***************************************************************************** */
/* 2da parte: DISTRIBUIMOS LA CANTIDAD A COMPRAR ENTRE LOS ALMACENES DE DESPACHO */
/* ***************************************************************************** */
DEF VAR pComprometido AS DEC NO-UNDO.
DEF VAR x-TipMat AS CHAR NO-UNDO.
DEF VAR x-StockDisponible AS DEC NO-UNDO.
DEF VAR x-CanReq AS DEC NO-UNDO.
DEF VAR x-Item AS INT NO-UNDO.
DEF VAR x-StkMax AS DEC NO-UNDO.
DEF VAR pCodigo AS CHAR NO-UNDO.
DEF VAR pAlmDes AS CHAR NO-UNDO.

FIND FIRST TabGener WHERE TabGener.CodCia = s-codcia
    AND TabGener.Clave = "ZG"
    AND TabGener.Libre_c01 = s-CodAlm
    NO-LOCK NO-ERROR.
pCodigo = TabGener.Codigo.  /* Zona Geografica que nos interesa Ej. ATE */
FOR EACH TabGener NO-LOCK WHERE TabGener.CodCia = s-codcia
    AND TabGener.Clave = "CDCZG"
    AND TabGener.Codigo = pCodigo
    BY TabGener.ValorIni:
    pAlmDes = TabGener.Libre_c01.   /* Almacén Despacho Reposición Compras Ej. 35 */
    FIND FIRST Almacen WHERE Almacen.codcia = s-CodCia
        AND Almacen.codalm = pAlmDes NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN NEXT.
    /* CARGAMOS T-MATE-2 CON EL RESUMEN POR CD */
    RUN RESUMEN-POR-DESPACHO (INPUT pAlmDes, INPUT T-MATE.CodMat).    /* Almacén Principal del CD de despacho */
    FIND FIRST T-MATE-2 WHERE T-MATE-2.codcia = s-codcia
        AND T-MATE-2.codalm = pAlmDes
        AND T-MATE-2.codmat = T-MATE.CodMat NO-LOCK NO-ERROR.
    IF NOT AVAILABLE T-MATE-2 THEN NEXT.
    x-StockDisponible = (T-MATE-2.StkAct + T-MATE-2.StkRep + T-MATE-2.DesCmpTra) - T-MATE-2.StkMin.
    IF x-StockDisponible <= 0 THEN NEXT.
    /* Mínimo Entero del Stock Disponible en base al empaque */
    x-Empaque = T-MATE-2.StkMax.
    IF x-Empaque = 0 OR x-Empaque = ? THEN x-Empaque = 1.
    x-StockDisponible = TRUNCATE(x-StockDisponible / x-Empaque, 0) * x-Empaque.
    IF x-StockDisponible <= 0 THEN NEXT.
    /* El almacén despacho cubre lo que necesita a comprar */
    x-CanReq = MINIMUM(x-StockDisponible, pReposicion).
    /* Vamos arrastrando el saldo a comprar */
    pReposicion = pReposicion - x-CanReq.
    IF pReposicion <= 0 THEN LEAVE.
END.
IF pReposicion <= 0 THEN RETURN.    /* No hay nada que comprar */

DEF VAR x-CanReqInner AS DEC NO-UNDO.
DEF VAR x-CanReqMaster AS DEC NO-UNDO.
DEF VAR x-CanMinima AS DEC NO-UNDO.
DEF VAR x-CanMaxima AS DEC NO-UNDO.
DEF VAR x-Factor    AS DEC NO-UNDO.

ASSIGN
    x-CanReq       = pReposicion.
IF (x-EmpaqueInner = 0 OR x-EmpaqueMaster = 0 OR x-EmpaqueInner = ? OR x-EmpaqueMaster = ?) THEN DO:
    /* La cantidad a comprar no se modifica */
END.
ELSE DO:
    IF x-EmpaqueInner  <= 0 OR x-EmpaqueInner  = ? THEN x-EmpaqueInner  = 1.   /* RHC 29/02/2016 */
    IF x-EmpaqueMaster <= 0 OR x-EmpaqueMaster = ? THEN x-EmpaqueMaster = 1.   /* RHC 29/02/2016 */
    /* Depende del empaque inner o master */
    ASSIGN
        x-CanReqInner  = pReposicion / x-EmpaqueInner
        x-CanReqMaster = pReposicion / x-EmpaqueMaster.
    IF x-CanReqInner <> TRUNCATE(x-CanReqInner,0) THEN x-CanReqInner = TRUNCATE(x-CanReqInner,0) + 1.
    IF x-CanReqMaster <> TRUNCATE(x-CanReqMaster,0) THEN x-CanReqMaster = TRUNCATE(x-CanReqMaster,0) + 1.
    ASSIGN
        x-CanReqInner = x-CanReqInner * x-EmpaqueInner
        x-CanReqMaster = x-CanReqMaster * x-EmpaqueMaster.
    x-CanMinima = MINIMUM(x-CanReqInner,x-CanReqMaster).
    x-CanMaxima = MAXIMUM(x-CanReqInner,x-CanReqMaster).
    x-Factor = ((x-CanMaxima / x-CanMinima) - 1) * 100.
    IF x-Factor <= 10 THEN x-CanReq = x-CanMaxima.
    ELSE x-CanReq = x-CanMinima.
END.
/* ****************************************************************************************** */
CREATE T-DREPO.
ASSIGN
    T-DREPO.Origen = 'AUT'
    T-DREPO.CodCia = s-codcia 
    T-DREPO.CodAlm = s-codalm 
    T-DREPO.Item = x-Item
    T-DREPO.AlmPed = s-codalm
    T-DREPO.CodMat = T-MATE.codmat
    /*T-DREPO.CanReq = pAReponer*/
    T-DREPO.CanReq = pReposicion
    T-DREPO.CanGen = x-CanReq.
ASSIGN                 
    T-DREPO.SolStkAct = T-MATE.StkAct + T-MATE.StkComprometido
    T-DREPO.SolStkCom = T-MATE.StkComprometido
    T-DREPO.SolStkDis = T-MATE.StkAct
    T-DREPO.SolStkMax = T-MATE.StkMin
    T-DREPO.SolStkTra = T-MATE.StkRep
    T-DREPO.DesCmpTra = T-MATE.CmpTra.
ASSIGN
    T-DREPO.PorcReposicion = (IF T-DREPO.CanReq <> 0 THEN (T-DREPO.CanGen / T-DREPO.CanReq * 100) ELSE 0).
FIND FIRST T-MATE-2 WHERE T-MATE-2.codcia = s-codcia
    AND T-MATE-2.codmat = T-MATE.CodMat 
    NO-LOCK NO-ERROR.
/* Compras en Tránsito del GRUPO */
IF AVAILABLE T-MATE-2 THEN ASSIGN T-DREPO.DesStkMax = T-MATE-2.DesStkMax.
/* Stock Maximo y Tránsito Principal */
FIND Almmmate WHERE Almmmate.codcia = s-codcia
    AND Almmmate.codalm = s-codalm
    AND Almmmate.codmat = T-MATE.codmat
    NO-LOCK NO-ERROR.
T-DREPO.DesStkMax = (IF Almcfggn.Temporada = "C" THEN Almmmate.VCtMn1 ELSE Almmmate.VCtMn2).
T-DREPO.DesStkTra = fStockTransito().

/* Clasificacion */
T-DREPO.ClfGral = fClfGral(T-DREPO.CodMat,s-Reposicion).
T-DREPO.ClfMayo = fClfMayo(T-DREPO.CodMat,s-Reposicion).
T-DREPO.ClfUtil = fClfUtil(T-DREPO.CodMat,s-Reposicion).

/* Cargamos Ventas */
DEF VAR dToday AS DATE NO-UNDO.
DEF VAR iFactor AS INT NO-UNDO.

dToday = TODAY.
FOR EACH Almdmov NO-LOCK WHERE almdmov.codcia = s-codcia
    AND Almdmov.codmat = T-DREPO.CodMat
    AND Almdmov.fchdoc >= ADD-INTERVAL(dToday,  -3, 'months')
    AND Almdmov.fchdoc <= dToday,
    FIRST TabGener NO-LOCK WHERE TabGener.CodCia = s-codcia
    AND TabGener.Clave = "ZG"
    AND TabGener.Codigo = pCodigo
    AND TabGener.Libre_c01= Almdmov.codalm:
    IF Almdmov.tipmov = "S" AND Almdmov.codmov <> 02 THEN NEXT.     /* Salida por ventas */
    IF Almdmov.tipmov = "I" AND Almdmov.codmov <> 09  THEN NEXT.    /* Ingreso devolucion clientes */
    iFactor = (IF Almdmov.TipMov = "S" THEN 1 ELSE -1).
    T-DREPO.VtaGrp90 = T-DREPO.VtaGrp90 + (Almdmov.candes * Almdmov.factor) * iFactor.
    IF ABS(dTODAY - Almdmov.fchdoc) <= 60 THEN T-DREPO.VtaGrp60 = T-DREPO.VtaGrp60 + (Almdmov.candes * Almdmov.factor) * iFactor.
    IF ABS(dTODAY - Almdmov.fchdoc) <= 30 THEN T-DREPO.VtaGrp30 = T-DREPO.VtaGrp30 + (Almdmov.candes * Almdmov.factor) * iFactor.
END.
dToday = ADD-INTERVAL(TODAY,-1,'year').
FOR EACH Almdmov NO-LOCK WHERE almdmov.codcia = s-codcia
    AND Almdmov.codmat = T-DREPO.CodMat
    AND Almdmov.fchdoc >= dToday
    AND Almdmov.fchdoc <= ADD-INTERVAL(dToday,3,'month'),
    FIRST TabGener NO-LOCK WHERE TabGener.CodCia = s-codcia
    AND TabGener.Clave = "ZG"
    AND TabGener.Codigo = pCodigo
    AND TabGener.Libre_c01= Almdmov.codalm:
    IF Almdmov.tipmov = "S" AND Almdmov.codmov <> 02 THEN NEXT.     /* Salida por ventas */
    IF Almdmov.tipmov = "I" AND Almdmov.codmov <> 09  THEN NEXT.    /* Ingreso devolucion clientes */
    iFactor = (IF Almdmov.TipMov = "S" THEN 1 ELSE -1).
    T-DREPO.VtaGrp90y = T-DREPO.VtaGrp90y + (Almdmov.candes * Almdmov.factor) * iFactor.
    IF ABS(dTODAY - Almdmov.fchdoc) <= 60 THEN T-DREPO.VtaGrp60y = T-DREPO.VtaGrp60y + (Almdmov.candes * Almdmov.factor) * iFactor.
    IF ABS(dTODAY - Almdmov.fchdoc) <= 30 THEN T-DREPO.VtaGrp30y = T-DREPO.VtaGrp30y + (Almdmov.candes * Almdmov.factor) * iFactor.
END.

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

/* Buscamos los valores generales */
FIND FIRST AlmCfgGn WHERE almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcfggn THEN DO:
    MESSAGE 'Debe configurar los parámetros generales' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
x-Clasificaciones = REPLACE(x-Clasificaciones, 'N', 'XA,XB,XC,XD,XE,XF,NA,NB,NC,ND,NE,NF,,').

/* ******************************************************************************** */
/* RHC 08/05/2017 SE VA A GENERAR UNA TABLA CON LA INFORMACION DE ALMMMATE PERO CON 
    LOS VALORES DEL CD (EJ.ATE) SI FUERA EL CASO */
/* ******************************************************************************** */
RUN ARTICULOS-A-SOLICITAR (
    INPUT FILL-IN-CodPro,
    INPUT FILL-IN-Marca,
    INPUT FILL-IN-CodFam,
    INPUT FILL-IN-SubFam
    ).
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN.

/* ******************************************************************************** */
/* ******************************************************************************** */

/* ******************************************************************************** */
/* CARGAMOS LA CANTIDAD A REPONER ************************************************* */
/* ******************************************************************************** */
EMPTY TEMP-TABLE T-DREPO.
FOR EACH T-MATG NO-LOCK, 
    EACH T-MATE OF T-MATG NO-LOCK:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "PROCESANDO: " + T-MATG.codmat + " " + T-MATG.desmat.
    RUN CARGA-REPOSICION.
END.
/* ******************************************************************************** */
/* ******************************************************************************** */

/* RHC 02/08/2016 Datos adicionales */
DEF VAR x-Total AS DEC NO-UNDO.
DEF VAR x-Item  AS INT INIT 1 NO-UNDO.
DEF VAR pComprometido AS DEC NO-UNDO.

FILL-IN-Mensaje:VISIBLE IN FRAME {&FRAME-NAME} = YES.
FOR EACH T-DREPO BY T-DREPO.CodMat:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "DATOS ADICIONALES: " + T-DREPO.codmat.
    T-DREPO.ITEM    = x-Item.
    x-Item = x-Item + 1.
END.

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
FILL-IN-Mensaje:VISIBLE IN FRAME {&FRAME-NAME} = NO.
RUN dispatch IN h_bcompraautomatica ('open-query':U).

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
  DISPLAY FILL-IN-Tipo FILL-IN-Temporada FILL-IN-Almacen FILL-IN-CodFam 
          FILL-IN-Total COMBO-BOX-Tipo FILL-IN-SubFam FILL-IN-Peso 
          SELECT-Clasificacion FILL-IN-CodPro FILL-IN-NomPro FILL-IN-PorRep 
          FILL-IN-Volumen FILL-IN-Marca FILL-IN-PorStkMax FILL-IN-Stock 
          FILL-IN-Texto FILL-IN-Venta30d FILL-IN-Venta30dy FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-9 RECT-1 RECT-11 BUTTON-4 BUTTON-7 COMBO-BOX-Tipo 
         SELECT-Clasificacion FILL-IN-CodPro FILL-IN-PorRep FILL-IN-Marca 
         FILL-IN-PorStkMax BUTTON-20 BUTTON-1 BUTTON-5 BUTTON-IMPORTAR-EXCEL 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Limpiar-Filtros W-Win 
PROCEDURE Limpiar-Filtros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        FILL-IN-CodFam = ''
        FILL-IN-CodPro = ''
        FILL-IN-Marca  = ''
        FILL-IN-NomPro = ''
        FILL-IN-SubFam = ''
        FILL-IN-PorStkMax = 100
        SELECT-Clasificacion = ''
        FILL-IN-Texto = ''
        .
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
    EMPTY TEMP-TABLE T-DREPO.
    RUN dispatch IN h_bcompraautomatica ('open-query':U).
    DISPLAY
        FILL-IN-CodFam
        FILL-IN-CodPro
        FILL-IN-Marca 
        FILL-IN-NomPro
        FILL-IN-SubFam
        FILL-IN-PorRep
        FILL-IN-Texto
        .
    ASSIGN
        SELECT-Clasificacion:SCREEN-VALUE = ""
        BUTTON-4:SENSITIVE = YES
        BUTTON-6:SENSITIVE = YES
        BUTTON-20:SENSITIVE = YES
        FILL-IN-CodPro:SENSITIVE = YES
        FILL-IN-Marca:SENSITIVE = YES
        .
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
  FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = s-codalm NO-LOCK.
  FILL-IN-Almacen = "ALMACÉN: " + Almacen.codalm + " " + CAPS(Almacen.Descripcion).

  FOR EACH VtaTabla NO-LOCK WHERE VtaTabla.codcia = s-codcia
      AND VtaTabla.Tabla = "%REPOSICION"
      AND VtaTabla.Llave_c1 = pCodDiv
      BY VtaTabla.Rango_Fecha[1]:
      IF TODAY >= VtaTabla.Rango_Fecha[1] THEN FILL-IN-PorRep = VtaTabla.Rango_Valor[1].
  END.
  FIND Almcfggn WHERE Almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
  CASE TRUE:
      WHEN NOT AVAILABLE Almcfggn OR AlmCfgGn.Temporada = '' THEN FILL-IN-Temporada = "NO DEFINIDA".
      WHEN Almcfggn.Temporada = "C" THEN ASSIGN FILL-IN-Temporada = "CAMPAÑA" s-Reposicion = YES.
      WHEN Almcfggn.Temporada = "NC" THEN ASSIGN FILL-IN-Temporada = "NO CAMPAÑA" s-Reposicion = NO.
  END CASE.
  DEF VAR pOk AS LOG NO-UNDO.
  RUN gn/fAlmPrincipal (INPUT s-CodAlm, OUTPUT pOk).
  IF pOk = YES THEN FILL-IN-Tipo = "CALCULO DE GRUPO".
  ELSE FILL-IN-Tipo = "CALCULO DE TIENDA".
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle W-Win 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pParametro AS CHAR.

CASE ENTRY(1,pParametro,'|'):
    WHEN 'Totales' THEN DO:
        DISPLAY
            DEC(ENTRY(2,pParametro,'|')) @ FILL-IN-Total
            DEC(ENTRY(3,pParametro,'|')) @ FILL-IN-Peso
            DEC(ENTRY(4,pParametro,'|')) @ FILL-IN-Volumen
            DEC(ENTRY(5,pParametro,'|')) @ FILL-IN-Stock
            DEC(ENTRY(6,pParametro,'|')) @ FILL-IN-Venta30d
            DEC(ENTRY(7,pParametro,'|')) @ FILL-IN-Venta30dy
            WITH FRAME {&FRAME-NAME}.
    END.
END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RESUMEN-POR-DESPACHO W-Win 
PROCEDURE RESUMEN-POR-DESPACHO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Se supone que es un ALMACEN PRINCIPAL
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pAlmDes AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.

DEF VAR pCodigo AS CHAR NO-UNDO.

EMPTY TEMP-TABLE T-GENER.
EMPTY TEMP-TABLE T-MATE-2.

FIND B-MATE WHERE B-MATE.codcia = s-codcia
    AND B-MATE.codalm = pAlmDes
    AND B-MATE.codmat = pCodMat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-MATE THEN RETURN.
FIND FIRST B-GENER WHERE B-GENER.CodCia = s-codcia
    AND B-GENER.Clave = "ZG"
    AND B-GENER.Libre_c01 = pAlmDes
    AND B-GENER.Libre_l01 = YES
    NO-LOCK.
pCodigo = B-GENER.Codigo.  /* Zona Geografica que nos interesa, ej. HUANTA */
FOR EACH B-GENER NO-LOCK WHERE B-GENER.CodCia = s-CodCia
    AND B-GENER.Clave = "ZG"
    AND B-GENER.Codigo = pCodigo,
    FIRST Almtabla NO-LOCK WHERE Almtabla.tabla = "ZG"
    AND Almtabla.codigo = B-GENER.codigo:
    FIND Almmmate WHERE Almmmate.codcia = s-codcia
        AND Almmmate.codalm = B-GENER.Libre_c01
        AND Almmmate.codmat = B-MATE.codmat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN NEXT.
    FIND FIRST T-MATE-2 OF B-MATE EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE T-MATE-2 THEN DO:
        CREATE T-MATE-2.
        BUFFER-COPY B-MATE
            EXCEPT B-MATE.StkAct B-MATE.StkMin B-MATE.StkRep B-MATE.StkComprometido
            TO T-MATE-2.
    END.
    ASSIGN
        /* Stock Disponible Despachante */
        T-MATE-2.StkAct = T-MATE-2.StkAct + (Almmmate.StkAct - Almmmate.StkComprometido)
        /* Stock Comprometido */
        T-MATE-2.StkComprometido = T-MATE-2.StkComprometido + Almmmate.StkComprometido
        /* Stock Maximo Despachante CD: (Stock Maximo + Seguridad) Tienda: Stock Maximo */
        T-MATE-2.StkMin = T-MATE-2.StkMin + Almmmate.StkMin
        /* Stock en Tránsito Solicitante */
        T-MATE-2.StkRep = T-MATE-2.StkRep + fStockTransito()
        .
    /* Compras en tránsito */
    FIND OOComPend WHERE OOComPend.CodMat = Almmmate.codmat
        AND OOComPend.CodAlm = Almmmate.CodAlm
        NO-LOCK NO-ERROR.
    IF AVAILABLE OOComPend 
        THEN T-MATE-2.DesCmpTra = T-MATE-2.DesCmpTra + (OOComPend.CanPed - OOComPend.CanAte).
END.

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fClfGral W-Win 
FUNCTION fClfGral RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR, INPUT pReposicion AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF BUFFER B-MATG FOR Almmmatg.

  FIND B-MATG WHERE B-MATG.codcia = s-codcia
      AND B-MATG.codmat = pCodMat
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-MATG THEN RETURN ''.
  FIND FIRST factabla WHERE factabla.codcia = s-codcia 
      AND factabla.tabla = 'RANKVTA' 
      AND factabla.codigo = B-MATG.codmat
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacTabla THEN RETURN ''.
  CASE Preposicion:
      WHEN YES /* Campaña */    THEN RETURN FacTabla.campo-c[1].
      WHEN NO /* No Campaña */  THEN RETURN FacTabla.campo-c[4].
  END CASE.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fClfMayo W-Win 
FUNCTION fClfMayo RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR, INPUT pReposicion AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF BUFFER B-MATG FOR Almmmatg.

  FIND B-MATG WHERE B-MATG.codcia = s-codcia
      AND B-MATG.codmat = pCodMat
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-MATG THEN RETURN ''.
  FIND FIRST factabla WHERE factabla.codcia = s-codcia 
      AND factabla.tabla = 'RANKVTA' 
      AND factabla.codigo = B-MATG.codmat
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacTabla THEN RETURN ''.
  CASE Preposicion:
      WHEN YES /* Campaña */    THEN RETURN FacTabla.campo-c[3].
      WHEN NO /* No Campaña */  THEN RETURN FacTabla.campo-c[6].
  END CASE.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fClfUtil W-Win 
FUNCTION fClfUtil RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR, INPUT pReposicion AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF BUFFER B-MATG FOR Almmmatg.

  FIND B-MATG WHERE B-MATG.codcia = s-codcia
      AND B-MATG.codmat = pCodMat
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-MATG THEN RETURN ''.
  FIND FIRST factabla WHERE factabla.codcia = s-codcia 
      AND factabla.tabla = 'RANKVTA' 
      AND factabla.codigo = B-MATG.codmat
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacTabla THEN RETURN ''.
  CASE Preposicion:
      WHEN YES /* Campaña */    THEN RETURN FacTabla.campo-c[2].
      WHEN NO /* No Campaña */  THEN RETURN FacTabla.campo-c[5].
  END CASE.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fStockTransito W-Win 
FUNCTION fStockTransito RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    /* En Tránsito */
    DEF VAR x-Total AS DEC NO-UNDO.
    RUN alm\p-articulo-en-transito (
        Almmmate.CodCia,
        Almmmate.CodAlm,
        Almmmate.CodMat,
        INPUT-OUTPUT TABLE tmp-tabla,
        OUTPUT x-Total).

    RETURN x-Total.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

