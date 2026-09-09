&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-MATE FOR Almmmate.
DEFINE BUFFER B-MATE2 FOR Almmmate.
DEFINE BUFFER B-MATG FOR Almmmatg.
DEFINE NEW SHARED TEMP-TABLE T-DREPO LIKE RepAutomDetail
       FIELD VtaGrp30 AS DEC
       FIELD VtaGrp60 AS DEC
       FIELD VtaGrp90 AS DEC
       FIELD VtaGrp30y AS DEC
       FIELD VtaGrp60y AS DEC
       FIELD VtaGrp90y AS DEC
       FIELD DesStkTra AS DEC
       .
DEFINE TEMP-TABLE T-GENER NO-UNDO LIKE TabGener.
DEFINE TEMP-TABLE T-MATE NO-UNDO LIKE Almmmate.
DEFINE TEMP-TABLE T-MATE-2 NO-UNDO LIKE Almmmate
       FIELD DesStkMax AS DEC
       FIELD DesStkDis AS DEC
       FIELD DesStkTra AS DEC.
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
DEF INPUT PARAMETER pParametro AS CHAR NO-UNDO.
IF LOOKUP(pParametro, 'YES,NO') = 0 THEN RETURN ERROR.

DEFINE VAR s-acceso-total  AS LOG.
s-acceso-total = LOGICAL(pParametro).

/*DEF VAR s-acceso-total AS LOG INIT YES.*/

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR pv-codcia AS INT.

DEF NEW SHARED VAR pCodDiv AS CHAR.
DEF NEW SHARED VAR s-coddoc AS CHAR INIT 'R/A'.
DEF NEW SHARED VAR s-tipmov AS CHAR INIT 'A'.

DEF VAR x-Clasificaciones AS CHAR NO-UNDO.


DEF BUFFER MATE FOR Almmmate.

DEF NEW SHARED VAR s-nivel-acceso AS INT INIT 0.
DEF NEW SHARED VAR lh_handle AS HANDLE.
DEF NEW SHARED VAR s-Reposicion AS LOG.     /* Campaña Yes, No Campaña No */

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

IF almacen.campo-c[9] = 'I' THEN DO:
    MESSAGE 'Almacén esta INACTIVO' VIEW-AS ALERT-BOX ERROR.
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
DEF TEMP-TABLE T-DREPO-5 LIKE T-DREPO.

DEF NEW SHARED VAR s-TipoCalculo AS CHAR.
DEF VAR pOk AS LOG NO-UNDO.
RUN gn/fAlmPrincipal (INPUT s-CodAlm, OUTPUT pOk).
IF pOk = YES THEN s-TipoCalculo = "GRUPO".
ELSE s-TipoCalculo = "TIENDA".

DEF VAR Stop-It AS LOG INIT FALSE NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-9 RECT-1 RECT-27 RECT-28 BUTTON-1 ~
BUTTON-5 BUTTON-IMPORTAR-EXCEL BUTTON-2 BUTTON-4 FILL-IN-Marca ~
FILL-IN-CodPro BUTTON-20 BUTTON-7 COMBO-BOX-Tipo SELECT-Clasificacion ~
FILL-IN-PorRep FILL-IN-PorStkMax FILL-IN-ImpMin FILL-IN_PorcTolerancia ~
COMBO-BOX-Motivo FILL-IN-Glosa TOGGLE-VtaPuntual txtFechaEntrega ~
FILL-IN-Cotizacion 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Almacen FILL-IN-Tipo ~
FILL-IN-Temporada FILL-IN-CodFam FILL-IN-SubFam FILL-IN-Marca ~
FILL-IN-CodPro FILL-IN-NomPro FILL-IN-Texto COMBO-BOX-Tipo ~
SELECT-Clasificacion FILL-IN-PorRep FILL-IN-PorStkMax FILL-IN-ImpMin ~
FILL-IN_PorcTolerancia COMBO-BOX-Motivo FILL-IN-Glosa TOGGLE-VtaPuntual ~
txtFechaEntrega FILL-IN-Cotizacion FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-ra-generacion AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv08 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "CALCULO DE REPOSICION AUTOMATICA" 
     SIZE 33 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "GENERAR PEDIDO DE REPOSICION" 
     SIZE 33 BY 1.12.

DEFINE BUTTON BUTTON-20 
     LABEL "..." 
     SIZE 4 BY .81.

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
     SIZE 15 BY 1.08.

DEFINE BUTTON BUTTON-IMPORTAR-EXCEL 
     LABEL "IMPORTAR EXCEL" 
     SIZE 20 BY 1.12.

DEFINE BUTTON BUTTON-Stop-It 
     IMAGE-UP FILE "img/pvparar.ico":U
     LABEL "Button 1" 
     SIZE 4 BY .81.

DEFINE VARIABLE COMBO-BOX-Motivo AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione un motivo" 
     LABEL "Motivo" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Seleccione un motivo","Seleccione un motivo"
     DROP-DOWN-LIST
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Tipo AS CHARACTER FORMAT "X(256)":U INITIAL "General" 
     LABEL "Clasificación" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "General","Mayorista","Utilex" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Almacen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 105 BY 1
     BGCOLOR 11 FGCOLOR 0 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Familias" 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPro AS CHARACTER FORMAT "x(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Cotizacion AS CHARACTER FORMAT "X(12)":U 
     LABEL "Pedido Comercial" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 TOOLTIP "Reserva la mercadería"
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Glosa AS CHARACTER FORMAT "X(60)":U 
     LABEL "Glosa" 
     VIEW-AS FILL-IN 
     SIZE 34 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpMin AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     LABEL "Import Mín Repos S/." 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Marca AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .85
     FONT 10 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-PorRep AS DECIMAL FORMAT ">>9.99":U INITIAL 100 
     LABEL "% de Reposición" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-PorStkMax AS DECIMAL FORMAT ">>9.99":U INITIAL 100 
     LABEL "% de Stock Máximo" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-SubFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "SubFamilias" 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-Temporada AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1.15
     BGCOLOR 0 FGCOLOR 14 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-Texto AS CHARACTER FORMAT "X(256)":U 
     LABEL "Archivo Texto" 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Tipo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1.15
     BGCOLOR 0 FGCOLOR 14 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN_PorcTolerancia AS DECIMAL FORMAT ">9.99":U INITIAL 10 
     LABEL "% de Tolerancia" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE txtFechaEntrega AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Entrega" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 174 BY 1.62
     BGCOLOR 11 .

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 7.81.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 5.65.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 7.81.

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

DEFINE VARIABLE TOGGLE-VtaPuntual AS LOGICAL INITIAL no 
     LABEL "URGENTE" 
     VIEW-AS TOGGLE-BOX
     SIZE 11 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Almacen AT ROW 1.27 COL 3 NO-LABEL WIDGET-ID 38
     FILL-IN-Tipo AT ROW 1.27 COL 107 COLON-ALIGNED NO-LABEL WIDGET-ID 86
     FILL-IN-Temporada AT ROW 1.27 COL 148 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     BUTTON-1 AT ROW 2.62 COL 53 WIDGET-ID 2
     BUTTON-5 AT ROW 2.62 COL 86 WIDGET-ID 34
     BUTTON-IMPORTAR-EXCEL AT ROW 2.62 COL 107 WIDGET-ID 50
     BUTTON-2 AT ROW 2.62 COL 127 WIDGET-ID 4
     FILL-IN-CodFam AT ROW 3.42 COL 11 COLON-ALIGNED WIDGET-ID 14
     BUTTON-4 AT ROW 3.42 COL 44 WIDGET-ID 12
     FILL-IN-SubFam AT ROW 4.23 COL 11 COLON-ALIGNED WIDGET-ID 54
     BUTTON-6 AT ROW 4.5 COL 44 WIDGET-ID 52
     FILL-IN-Marca AT ROW 5.04 COL 11 COLON-ALIGNED WIDGET-ID 28
     FILL-IN-CodPro AT ROW 5.85 COL 11 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-NomPro AT ROW 6.65 COL 11 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     FILL-IN-Texto AT ROW 7.46 COL 11 COLON-ALIGNED WIDGET-ID 64
     BUTTON-20 AT ROW 7.46 COL 44 WIDGET-ID 66
     BUTTON-7 AT ROW 8.54 COL 13 WIDGET-ID 58
     COMBO-BOX-Tipo AT ROW 11.5 COL 17 COLON-ALIGNED WIDGET-ID 88
     SELECT-Clasificacion AT ROW 11.5 COL 36 NO-LABEL WIDGET-ID 114
     FILL-IN-PorRep AT ROW 12.31 COL 17 COLON-ALIGNED WIDGET-ID 42
     FILL-IN-PorStkMax AT ROW 13.12 COL 17 COLON-ALIGNED WIDGET-ID 84
     FILL-IN-ImpMin AT ROW 13.92 COL 17 COLON-ALIGNED WIDGET-ID 44
     FILL-IN_PorcTolerancia AT ROW 14.73 COL 17 COLON-ALIGNED WIDGET-ID 142
     COMBO-BOX-Motivo AT ROW 16.88 COL 15 COLON-ALIGNED WIDGET-ID 70
     FILL-IN-Glosa AT ROW 17.69 COL 15 COLON-ALIGNED WIDGET-ID 32
     TOGGLE-VtaPuntual AT ROW 18.5 COL 17 WIDGET-ID 68
     txtFechaEntrega AT ROW 19.31 COL 15 COLON-ALIGNED WIDGET-ID 56
     FILL-IN-Cotizacion AT ROW 20.38 COL 15 COLON-ALIGNED WIDGET-ID 138
     FILL-IN-Mensaje AT ROW 24.15 COL 2 NO-LABEL WIDGET-ID 60
     BUTTON-Stop-It AT ROW 24.15 COL 47 WIDGET-ID 134
     "Parámetros" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 10.42 COL 3 WIDGET-ID 140
          BGCOLOR 1 FGCOLOR 15 FONT 10
     "Filtros" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.62 COL 3 WIDGET-ID 20
          BGCOLOR 1 FGCOLOR 15 FONT 10
     "Datos Cabecera" VIEW-AS TEXT
          SIZE 18 BY .5 AT ROW 16.08 COL 3 WIDGET-ID 128
          BGCOLOR 1 FGCOLOR 15 FONT 10
     RECT-9 AT ROW 2.88 COL 2 WIDGET-ID 26
     RECT-1 AT ROW 1 COL 2 WIDGET-ID 40
     RECT-27 AT ROW 16.35 COL 2 WIDGET-ID 130
     RECT-28 AT ROW 10.69 COL 2 WIDGET-ID 132
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 190.72 BY 26.23
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 2
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-MATE B "?" ? INTEGRAL Almmmate
      TABLE: B-MATE2 B "?" ? INTEGRAL Almmmate
      TABLE: B-MATG B "?" ? INTEGRAL Almmmatg
      TABLE: T-DREPO T "NEW SHARED" ? INTEGRAL RepAutomDetail
      ADDITIONAL-FIELDS:
          FIELD VtaGrp30 AS DEC
          FIELD VtaGrp60 AS DEC
          FIELD VtaGrp90 AS DEC
          FIELD VtaGrp30y AS DEC
          FIELD VtaGrp60y AS DEC
          FIELD VtaGrp90y AS DEC
          FIELD DesStkTra AS DEC
          
      END-FIELDS.
      TABLE: T-GENER T "?" NO-UNDO INTEGRAL TabGener
      TABLE: T-MATE T "?" NO-UNDO INTEGRAL Almmmate
      TABLE: T-MATE-2 T "?" NO-UNDO INTEGRAL Almmmate
      ADDITIONAL-FIELDS:
          FIELD DesStkMax AS DEC
          FIELD DesStkDis AS DEC
          FIELD DesStkTra AS DEC
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
         TITLE              = "GENERACION DE PEDIDOS R/A - ABASTECIMIENTOS"
         HEIGHT             = 25.92
         WIDTH              = 190.72
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
/* SETTINGS FOR BUTTON BUTTON-Stop-It IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-Stop-It:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Almacen IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-CodFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-SubFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Temporada IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Texto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Tipo IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* GENERACION DE PEDIDOS R/A - ABASTECIMIENTOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* GENERACION DE PEDIDOS R/A - ABASTECIMIENTOS */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* CALCULO DE REPOSICION AUTOMATICA */
DO:        

  MESSAGE 'Continuamos con el CALCULO DE REPOSICION AUTOMATICA?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.

  DEF VAR k AS INT NO-UNDO.
  DEF VAR j AS INT NO-UNDO.

  ASSIGN
      FILL-IN-CodFam FILL-IN-SubFam FILL-IN-CodPro FILL-IN-Marca FILL-IN-Glosa
      FILL-IN-ImpMin FILL-IN-PorRep FILL-IN-Texto COMBO-BOX-Motivo FILL-IN-PorStkMax
      COMBO-BOX-Tipo.
  ASSIGN
      FILL-IN_PorcTolerancia.
  
  /* ************************************ */
  /* LIMPIAR referencia de PRE-REPOSICION */
  /* ************************************ */
/*   FILL-IN-CodRef = ''.                                            */
/*   FILL-IN-NroRef = ''.                                            */
/*   DISPLAY FILL-IN-CodRef FILL-IN-NroRef WITH FRAME {&FRAME-NAME}. */
  /* ************************************ */
  /* ************************************ */

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

  /*SESSION:SET-WAIT-STATE('GENERAL').*/
  Stop-It = FALSE.
  BUTTON-Stop-It:VISIBLE IN FRAME {&FRAME-NAME} = YES.
  BUTTON-Stop-It:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
  RUN Carga-Temporal.
  FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  /*SESSION:SET-WAIT-STATE('').*/
  BUTTON-Stop-It:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  BUTTON-Stop-It:VISIBLE IN FRAME {&FRAME-NAME} = NO.
  MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.
  RUN select-page("2").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* GENERAR PEDIDO DE REPOSICION */
DO:
    MESSAGE 'Continuamos con GENERAR PEDIDO DE REPOSICION?'
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.

  SESSION:SET-WAIT-STATE('GENERAL').
  ASSIGN
      FILL-IN-Glosa txtFechaEntrega COMBO-BOX-Motivo TOGGLE-VtaPuntual. 
  ASSIGN
      FILL-IN-Cotizacion.
  /* RHC 04/10/2016 CONSISTENCIA DE FECHA DE ENTREGA */
  DEF VAR pMensaje AS CHAR NO-UNDO.
  pMensaje = "".
  DEF VAR pFchEnt AS DATE NO-UNDO.
  pFchEnt = txtFechaEntrega.
  /* OJO con la hora */
  RUN gn/p-fchent (TODAY, STRING(TIME,'HH:MM:SS'), pFchEnt, s-CodDiv, s-CodAlm, OUTPUT pMensaje).
  IF pMensaje <> '' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO txtFechaEntrega.
      RETURN NO-APPLY.
  END.

  IF txtFechaEntrega < TODAY THEN DO:
      MESSAGE "Fecha de Entrega no puede ser anterior a la Actual" VIEW-AS ALERT-BOX.
      RETURN NO-APPLY.
  END.
  IF COMBO-BOX-Motivo = "Seleccione un motivo" THEN DO:
      MESSAGE 'Debe seleccionar un motivo' VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO COMBO-BOX-Motivo.
      RETURN NO-APPLY.
  END.
  
  RUN Generar-Pedidos IN h_b-ra-generacion
    ( INPUT txtFechaEntrega /* DATE */,
      INPUT FILL-IN-Glosa /* CHARACTER */,
      INPUT TOGGLE-VtaPuntual /* LOGICAL */,
      INPUT COMBO-BOX-Motivo /* CHARACTER */,
      '',
      '',
      FILL-IN-Cotizacion
      ).

  SESSION:SET-WAIT-STATE('').

  ASSIGN FILL-IN-Cotizacion = ''.
  DISPLAY FILL-IN-Cotizacion WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-20
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-20 W-Win
ON CHOOSE OF BUTTON-20 IN FRAME F-Main /* ... */
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
   RUN Excel IN h_b-ra-generacion.
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
   RUN Importar-Excel IN h_b-ra-generacion.
   IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
   /* Renumeramos */
   DEF VAR x-Item  AS INT INIT 1 NO-UNDO.
   FOR EACH T-DREPO BY T-DREPO.CodMat:
       T-DREPO.ITEM    = x-Item.
       x-Item = x-Item + 1.
   END.
   /*RUN Limpiar-Filtros.*/
   RUN Carga-Filtros IN h_b-ra-generacion.
   RUN dispatch IN h_b-ra-generacion ('open-query':U).
   RUN select-page("2").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Stop-It
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Stop-It W-Win
ON CHOOSE OF BUTTON-Stop-It IN FRAME F-Main /* Button 1 */
DO:
  Stop-It = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Motivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Motivo W-Win
ON VALUE-CHANGED OF COMBO-BOX-Motivo IN FRAME F-Main /* Motivo */
DO:
    ASSIGN {&self-name}.
  
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


&Scoped-define SELF-NAME FILL-IN-Cotizacion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Cotizacion W-Win
ON LEAVE OF FILL-IN-Cotizacion IN FRAME F-Main /* Pedido Comercial */
DO:
  /* Verificamos que este almacén sea uno de los almacenes de despacho de este pedido */
  FIND Faccpedi WHERE FacCPedi.CodCia = s-CodCia
      AND FacCPedi.CodDoc = "COT"
      AND FacCPedi.NroPed = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCPedi THEN DO:
      MESSAGE 'Pedido Comercial NO registrado' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  IF Faccpedi.FlgEst <> 'P' THEN DO:
      MESSAGE 'El Pedido Comercial NO está pendiente de despacho' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  FIND VtaAlmDiv WHERE VtaAlmDiv.CodCia = s-CodCia
      AND VtaAlmDiv.CodAlm = s-CodAlm
      AND VtaAlmDiv.CodDiv = Faccpedi.CodDiv
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE VtaAlmDiv THEN DO:
      MESSAGE 'Este almacén no está habilitado para despachar este Pedido Comercial' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Glosa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Glosa W-Win
ON LEAVE OF FILL-IN-Glosa IN FRAME F-Main /* Glosa */
DO:
    ASSIGN {&self-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-ImpMin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-ImpMin W-Win
ON LEAVE OF FILL-IN-ImpMin IN FRAME F-Main /* Import Mín Repos S/. */
DO:
    ASSIGN {&self-name}.
  
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
ON LEAVE OF FILL-IN-PorRep IN FRAME F-Main /* % de Reposición */
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


&Scoped-define SELF-NAME TOGGLE-VtaPuntual
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-VtaPuntual W-Win
ON VALUE-CHANGED OF TOGGLE-VtaPuntual IN FRAME F-Main /* URGENTE */
DO:
  ASSIGN {&SELF-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtFechaEntrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtFechaEntrega W-Win
ON LEAVE OF txtFechaEntrega IN FRAME F-Main /* Fecha Entrega */
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


/*{alm/i-reposicionautomaticav51.i}*/
/*{alm/i-ra-ran-rutinas.i}*/
{alm/i-reposicionautomaticav51.i}

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
             INPUT  'ALM/b-ra-generacion.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ,
                     SortBy-Case = Codigo':U ,
             OUTPUT h_b-ra-generacion ).
       RUN set-position IN h_b-ra-generacion ( 3.69 , 52.72 ) NO-ERROR.
       RUN set-size IN h_b-ra-generacion ( 22.92 , 138.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv08 ).
       RUN set-position IN h_p-updv08 ( 25.50 , 54.00 ) NO-ERROR.
       RUN set-size IN h_p-updv08 ( 1.42 , 49.86 ) NO-ERROR.

       /* Links to SmartBrowser h_b-ra-generacion. */
       RUN add-link IN adm-broker-hdl ( h_p-updv08 , 'TableIO':U , h_b-ra-generacion ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-ra-generacion ,
             BUTTON-4:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv08 ,
             BUTTON-Stop-It:HANDLE IN FRAME F-Main , 'AFTER':U ).
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
        RUN adm-open-query-cases IN h_b-ra-generacion.

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
DEF VAR x-StockMaximo AS DEC NO-UNDO.
DEF VAR x-Empaque AS DEC NO-UNDO.
DEF VAR x-StkAct AS DEC NO-UNDO.
DEF VAR pAReponer   AS DEC NO-UNDO.
DEF VAR pReposicion AS DEC NO-UNDO.
DEF VAR dFactor AS DEC NO-UNDO.
DEF VAR p      AS INT NO-UNDO.
DEF VAR k      AS INT NO-UNDO.

ASSIGN
    x-StockMaximo   = T-MATE.StkMin     /* Stock Maximo + Seguridad */
    x-Empaque       = T-MATE.StkMax     /* Empaque */
    x-StkAct        = T-MATE.StkAct.    /* Stock Actual - Stock Comprometido */

IF x-Empaque <= 0 OR x-Empaque = ? THEN x-Empaque = 1.   /* RHC 29/02/2016 */
/* INCREMENTAMOS LOS PEDIDOS POR REPOSICION EN TRANSITO + TRANSITO COMPRAS  */
x-StkAct = x-StkAct + T-MATE.StkRep + T-MATE.StkActCbd.

IF x-StkAct < 0 THEN x-StkAct = 0.
IF x-StkAct >= x-StockMaximo THEN RETURN.   /* NO VA */

/* ********************* Cantidad de Reposicion ******************* */
/* Definimos el stock maximo */
/* RHC 05/06/2014 Cambio de filosofía, ahora es el % del stock mínimo */
IF x-StkAct >= (x-StockMaximo * FILL-IN-PorRep / 100) THEN RETURN.    /* NO VA */

/* Se va a reponer en cantidades múltiplo del valor T-MATE.StkMax (EMPAQUE) */
pAReponer = x-StockMaximo - x-StkAct.
pReposicion = pAReponer.    /* RHC 16/06/2017 */
IF pReposicion <= 0 THEN RETURN.    /* NO VA */
pAReponer = pReposicion.    /* OJO */

/* ***************************************************************************** */
/* 2da parte: DISTRIBUIMOS LA CANTIDAD A REPONER ENTRE LOS ALMACENES DE DESPACHO */
/* ***************************************************************************** */
DEF VAR pComprometido AS DEC NO-UNDO.
DEF VAR x-TipMat AS CHAR NO-UNDO.
DEF VAR x-StockDisponible AS DEC NO-UNDO.
DEF VAR x-CanReq AS DEC NO-UNDO.
DEF VAR x-Tolerancia AS DEC NO-UNDO.
DEF VAR x-Item AS INT INIT 1 NO-UNDO.
DEF VAR x-StkMax AS DEC NO-UNDO.

DEF VAR x-ControlDespacho AS LOG INIT NO NO-UNDO.

/* RHC 05/09/2017 Acumulado de CANTIDAD GENERADA */
DEF VAR x-Total-CanGen AS DEC NO-UNDO.
x-Total-CanGen = 0.

IF T-MATG.Chr__02 = "P" THEN x-TipMat = "P". 
ELSE x-TipMat = "T".
FOR EACH Almrepos NO-LOCK WHERE Almrepos.CodCia = s-codcia
    AND Almrepos.CodAlm = T-MATE.codalm 
    AND Almrepos.AlmPed > ''
    AND Almrepos.AlmPed <> T-MATE.codalm
    AND Almrepos.TipMat = x-TipMat      /* Propios o Terceros */
    AND pReposicion > 0 /* <<< OJO <<< */
    BY Almrepos.Orden:
    FIND FIRST Almacen WHERE Almacen.codcia = Almrepos.codcia AND Almacen.codalm = Almrepos.almped
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN NEXT.

    /* CARGAMOS T-MATE-2 CON EL RESUMEN POR CD O SOLO EL DE LA TIENDA */
    RUN RESUMEN-POR-DESPACHO (Almrepos.almped, T-MATE.codmat).
    FIND FIRST T-MATE-2 WHERE T-MATE-2.codcia = s-codcia
        AND T-MATE-2.codalm = Almrepos.AlmPed
        AND T-MATE-2.codmat = T-MATE.CodMat NO-LOCK NO-ERROR.
    IF NOT AVAILABLE T-MATE-2 THEN NEXT.

    /* Incluye Transferencias en Tránsito y Compras en Tránsito */
    x-StockDisponible = T-MATE-2.StkAct - T-MATE-2.StkMin + T-MATE-2.StkRep + T-MATE-2.StkActCbd.
    IF x-StockDisponible <= 0 THEN NEXT.
    /* Se solicitará la reposición de acuerdo al empaque del producto */
    x-CanReq = MINIMUM(x-StockDisponible, pReposicion).
    /* redondeamos al entero superior */
    IF x-CanReq <> TRUNCATE(x-CanReq,0) THEN x-CanReq = TRUNCATE(x-CanReq,0) + 1.
    /* *************************************************** */
    /* RHC 06/07/17 Corregido                              */
    /* *************************************************** */
    IF (x-CanReq / x-Empaque) <> TRUNCATE(x-CanReq / x-Empaque,0) 
        THEN x-CanReq = (TRUNCATE(x-CanReq / x-Empaque,0) + 1) * x-Empaque.
    /*x-Tolerancia = x-StockMaximo * 1.1.     /* Maximo Solicitante + 10% Tolerancia */*/
    x-Tolerancia = x-StockMaximo * (1 + FILL-IN_PorcTolerancia / 100).     /* Maximo Solicitante + 10% Tolerancia */
    REPEAT WHILE ( (x-CanReq + x-Total-CanGen) + x-StkAct) > x-Tolerancia:
        x-CanReq = x-CanReq - x-Empaque.
    END.
    /* No debe superar el stock disponible */
    REPEAT WHILE x-CanReq > x-StockDisponible:
        x-CanReq = x-CanReq - x-Empaque.
    END.
    IF x-CanReq <= 0 AND x-StockDisponible > 0 THEN x-ControlDespacho = YES.
    IF x-CanReq <= 0 THEN NEXT.    /* Menos que la cantidad por empaque */
    /* ******************** RHC 18/02/2014 FILTRO POR IMPORTE DE REPOSICION ********************* */
    IF T-MATG.MonVta = 2 THEN DO:
        IF x-CanReq * T-MATG.CtoTot * T-MATG.TpoCmb < FILL-IN-ImpMin THEN NEXT.
    END.
    ELSE IF x-CanReq * T-MATG.CtoTot < FILL-IN-ImpMin THEN NEXT.
    IF x-CanReq = ? THEN NEXT.
    /* ****************************************************************************************** */
    CREATE T-DREPO.
    ASSIGN
        T-DREPO.Origen = 'AUT'
        T-DREPO.CodCia = s-codcia 
        T-DREPO.CodAlm = s-codalm 
        T-DREPO.Item = x-Item
        T-DREPO.AlmPed = Almrepos.almped
        T-DREPO.CodMat = T-MATE.codmat
        T-DREPO.CanReq = pAReponer
        T-DREPO.CanGen = x-CanReq.
    /* RHC 03/07/17 Redondear al empaque */
    IF T-DREPO.CanGen MODULO x-Empaque > 0 THEN DO:
        T-DREPO.CanGen = ( TRUNCATE(T-DREPO.CanGen / x-Empaque, 0) + 1 ) * x-Empaque.
    END.
    /* RHC Acumulamos */
    x-Total-CanGen = x-Total-CanGen + T-DREPO.CanGen.
    /* Del Almacén Solicitante */
    ASSIGN                 
        T-DREPO.SolStkAct = T-MATE.StkAct + T-MATE.StkComprometido
        T-DREPO.SolStkCom = T-MATE.StkComprometido
        T-DREPO.SolStkDis = T-MATE.StkAct
        T-DREPO.SolStkMax = T-MATE.StkMin
        T-DREPO.SolStkTra = T-MATE.StkRep
        T-DREPO.SolCmpTra = T-MATE.StkActCbd
        .
    /* Del Almacén de Despacho */
    ASSIGN
/*         T-DREPO.DesStkAct = T-MATE-2.StkAct + T-MATE-2.StkComprometido */
/*         T-DREPO.DesStkCom = T-MATE-2.StkComprometido                   */
        T-DREPO.DesStkDis = T-MATE-2.StkAct
/*         T-DREPO.DesStkMax = T-MATE-2.StkMin    */
/*         T-DREPO.DesCmpTra = T-MATE-2.StkActCbd */
        T-DREPO.PorcReposicion = (IF T-DREPO.CanReq <> 0 THEN (T-DREPO.CanGen / T-DREPO.CanReq * 100) ELSE 0).
    /* Datos Adicionales */
/*     ASSIGN                                                                              */
/*         T-DREPO.GrpStkDis = T-MATE-2.DesStkDis                                          */
/*         T-DREPO.FSGrupo = T-MATE-2.DesStkDis - T-MATE-2.DesStkMax + T-MATE-2.DesStkTra. */
    ASSIGN
        T-DREPO.ClfGral = fClasificacion(T-DREPO.CodMat).
    ASSIGN
        x-Item = x-Item + 1
        pReposicion = pReposicion - T-DREPO.CanGen.
    IF pReposicion <= 0 THEN LEAVE.
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

/* *********************************************************************** */
/* 1ro. CARGAMOS LOS PRODUCTOS ******************************************* */
/* Tabla: T-MATG ********************************************************* */
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
        AND Almmmatg.tpoart <> "D"
        AND (FILL-IN-CodFam = "" OR LOOKUP(Almmmatg.codfam, FILL-IN-CodFam) > 0)
        AND (FILL-IN-SubFam = "" OR LOOKUP(Almmmatg.subfam, FILL-IN-SubFam) > 0)
        AND (FILL-IN-CodPro = "" OR Almmmatg.codpr1 = FILL-IN-CodPro)
        AND (FILL-IN-Marca = "" OR Almmmatg.desmar BEGINS FILL-IN-Marca):
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "SELECCIONANDO: " + Almmmatg.codmat + " " + Almmmatg.desmat.
        /* Filtro por Clasificación */
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
        PROCESS EVENTS.
        IF Stop-It = YES THEN RETURN 'ADM-ERROR'.
    END.
END.
/* *********************************************************************** */
/* FILTRAMOS DE ACUERDO AL TIPO DE ALMACEN */
/* *********************************************************************** 
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = pCodDiv NO-LOCK.
FOR EACH T-MATG EXCLUSIVE-LOCK:
    CASE TRUE:
        WHEN GN-DIVI.CanalVenta = "MIN" THEN DO:    /* UTILEX */
            IF NOT ( (TRUE <> (T-MATG.TpoMrg > '')) OR T-MATG.TpoMrg = "2" )
                THEN DELETE T-MATG.
        END.
        OTHERWISE DO:   /* MAYORISTAS */
/*             IF NOT ( (TRUE <> (T-MATG.TpoMrg > '')) OR T-MATG.TpoMrg = "1" ) */
/*                 THEN DELETE T-MATG.                                          */
        END.
    END CASE.
END.
*********************************************************************** */

/* 2do DEFINIMOS LA CANTIDAD A REPONER *********************************** */
/* Tabla: T-MATE ********************************************************* */
/* *********************************************************************** */
EMPTY TEMP-TABLE T-MATE.
/* Barremos producto por producto */
FOR EACH T-MATG NO-LOCK:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "PROCESANDO CD: " + T-MATG.codmat + " " + T-MATG.desmat.
    /* ******************************************************************************** */
    /* RHC 08/05/2017 SE VA A GENERAR UNA TABLA CON LA INFORMACION DE ALMMMATE PERO CON 
        LOS VALORES DEL CD (EJ.ATE) SI FUERA EL CASO */
    /* ******************************************************************************** */
    RUN ARTICULOS-A-SOLICITAR (INPUT T-MATG.CodMat, "AUT").
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN.
    PROCESS EVENTS.
    IF Stop-It = YES THEN RETURN 'ADM-ERROR'.
END.
/* Depuración final */
/* FOR EACH T-MATE EXCLUSIVE-LOCK, FIRST B-MATE OF T-MATE NO-LOCK:                                    */
/*     /* RHC 04/0/17 Primero lo afectamos por el "% de Stock Maximo" */                              */
/*     T-MATE.StkMin = T-MATE.StkMin * FILL-IN-PorStkMax / 100.                                       */
/*     T-MATE.StkMax = B-MATE.StkMax.    /* Empaque */                                                */
/*     IF T-MATE.StkMin - (T-MATE.StkAct + T-MATE.StkRep + T-MATE.StkActCbd) <= 0 THEN DELETE T-MATE. */
/* END.                                                                                               */
/* ******************************************************************************** */
/* ******************************************************************************** */
/* ******************************************************************************** */
/* CARGAMOS LA CANTIDAD A REPONER ************************************************* */
/* ******************************************************************************** */
EMPTY TEMP-TABLE T-DREPO.
FILL-IN-Mensaje:VISIBLE IN FRAME {&FRAME-NAME} = YES.
FOR EACH T-MATG NO-LOCK, 
    EACH T-MATE OF T-MATG NO-LOCK:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "PROCESANDO: " + T-MATG.codmat + " " + T-MATG.desmat.
    RUN CARGA-REPOSICION.
    PROCESS EVENTS.
    IF Stop-It = YES THEN RETURN 'ADM-ERROR'.
END.

FOR EACH T-DREPO WHERE T-DREPO.canreq <= 0 AND LOOKUP(T-DREPO.AlmPed, '997,998') = 0:
    DELETE T-DREPO.
END.

DEF VAR x-Item AS INT INIT 1 NO-UNDO.
FOR EACH T-DREPO BY T-DREPO.CodMat:
    T-DREPO.ITEM = x-Item.
    x-Item = x-Item + 1.
END.
/* No mas de los items de la reposición */
FIND FIRST AlmCfgGn WHERE almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
/* IF AVAILABLE AlmCfgGn AND AlmCfgGn.Libre_d01 > 0 THEN DO:         */
/*     FOR EACH T-DREPO:                                             */
/*         IF T-DREPO.ITEM > AlmCfgGn.Libre_d01 THEN DELETE T-DREPO. */
/*     END.                                                          */
/* END.                                                              */

FOR EACH T-DREPO, FIRST B-MATG OF T-DREPO NO-LOCK:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "DATOS ADICIONALES: " + T-DREPO.codmat.
    RUN DATOS-FINALES.
    PROCESS EVENTS.
    IF Stop-It = YES THEN RETURN 'ADM-ERROR'.
END.
/* ******************************************************************************** */
/* ******************************************************************************** */

/* RHC 02/08/2016 Datos adicionales */
DEF VAR x-Total AS DEC NO-UNDO.
DEF VAR pComprometido AS DEC NO-UNDO.

x-Item = 1.
FOR EACH T-DREPO BY T-DREPO.CodMat:
    T-DREPO.ITEM    = x-Item.
    x-Item = x-Item + 1.
END.

/* ******************************************************************************** */
/* 01-09-2023: Separa los artículos en Master y Saldos */
/* ******************************************************************************** */
RUN Separa-Articulos.
/* ******************************************************************************** */
/* ******************************************************************************** */

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
FILL-IN-Mensaje:VISIBLE IN FRAME {&FRAME-NAME} = NO.

RUN Carga-Filtros IN h_b-ra-generacion.

RUN dispatch IN h_b-ra-generacion ('open-query':U).

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
  DISPLAY FILL-IN-Almacen FILL-IN-Tipo FILL-IN-Temporada FILL-IN-CodFam 
          FILL-IN-SubFam FILL-IN-Marca FILL-IN-CodPro FILL-IN-NomPro 
          FILL-IN-Texto COMBO-BOX-Tipo SELECT-Clasificacion FILL-IN-PorRep 
          FILL-IN-PorStkMax FILL-IN-ImpMin FILL-IN_PorcTolerancia 
          COMBO-BOX-Motivo FILL-IN-Glosa TOGGLE-VtaPuntual txtFechaEntrega 
          FILL-IN-Cotizacion FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-9 RECT-1 RECT-27 RECT-28 BUTTON-1 BUTTON-5 BUTTON-IMPORTAR-EXCEL 
         BUTTON-2 BUTTON-4 FILL-IN-Marca FILL-IN-CodPro BUTTON-20 BUTTON-7 
         COMBO-BOX-Tipo SELECT-Clasificacion FILL-IN-PorRep FILL-IN-PorStkMax 
         FILL-IN-ImpMin FILL-IN_PorcTolerancia COMBO-BOX-Motivo FILL-IN-Glosa 
         TOGGLE-VtaPuntual txtFechaEntrega FILL-IN-Cotizacion 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-OTR W-Win 
PROCEDURE Genera-OTR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* RHC 30.07.2014 Se va a limitar a 52 itesm por pedido */
DEF VAR n-Items AS INT NO-UNDO.

EMPTY TEMP-TABLE T-DREPO-2.     /* Acumula temporalmente los items */
EMPTY TEMP-TABLE T-DREPO-3.     /* Acumula los que #Items >= 10 */
EMPTY TEMP-TABLE T-DREPO-4.     /* Acumula los que #Items < 10  */
DEF BUFFER B-MATG FOR Almmmatg.

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FIND FIRST Faccorre WHERE Faccorre.codcia = s-codcia
        AND Faccorre.coddoc = s-coddoc
        AND Faccorre.flgest = YES
        AND Faccorre.coddiv = pCodDiv
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccorre THEN DO:
        MESSAGE 'No se encuentra el correlativo para la división' s-coddoc pCodDiv
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN "ADM-ERROR".
    END.
    /* Depuramos el temporal */
    FOR EACH T-DREPO WHERE T-DREPO.AlmPed = '998':
        DELETE T-DREPO.
    END.

    /* RHC 12/05/2017 SI UNA MARCA ESPECIFICA TIENE IGUAL O MAS DE 10 ITEMS => GENERA UN REPOSICION */
    RUN Resumimos-por-Marca.

    /* Parte 1: Los resumidos por MARCA */
    EMPTY TEMP-TABLE T-DREPO.
    FOR EACH T-DREPO-3 NO-LOCK:
        CREATE T-DREPO.
        BUFFER-COPY T-DREPO-3 TO T-DREPO.
    END.
    RUN Graba-OTR-Marca (INPUT 52).   /* Tope de pedidos */

    /* Parte 2: El resto */
    EMPTY TEMP-TABLE T-DREPO.
    FOR EACH T-DREPO-4 NO-LOCK:
        CREATE T-DREPO.
        BUFFER-COPY T-DREPO-4 TO T-DREPO.
    END.
    RUN Graba-OTR (INPUT 52).   /* Tope de pedidos */
END.
EMPTY TEMP-TABLE T-DREPO.
RELEASE Faccorre.
RELEASE almcrepo.
RELEASE almdrepo.

RUN adm-open-query IN h_b-ra-generacion.

END PROCEDURE.

/*
PROCEDURE Graba-OTR:
/* ************** */

    {alm/i-reposicionautomatica-genotr.i ~
        &Orden="T-DREPO.AlmPed BY Almmmatg.DesMar BY Almmmatg.DesMat" ~
        &Quiebre="FIRST-OF(T-DREPO.AlmPed) OR n-Items >= pTope"}
        
END PROCEDURE.

PROCEDURE Graba-OTR-Marca:
/* ******************** */

    {alm/i-reposicionautomatica-genotr.i ~
    &Orden="T-DREPO.AlmPed BY Almmmatg.DesMar BY Almmmatg.DesMat" ~
    &Quiebre="FIRST-OF(T-DREPO.AlmPed) OR FIRST-OF(Almmmatg.DesMar) OR n-Items >= pTope"}

END PROCEDURE.

*/

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
        FILL-IN-Glosa  = ''
        FILL-IN-Marca  = ''
        FILL-IN-NomPro = ''
        FILL-IN-SubFam = ''
        FILL-IN-ImpMin = 0
        FILL-IN-PorStkMax = 100
        SELECT-Clasificacion = ''
        FILL-IN-Texto = ''
        TOGGLE-VtaPuntual = NO
        COMBO-BOX-Motivo = 'Seleccione un motivo'
        COMBO-BOX-Tipo = 'General'
        .
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
    EMPTY TEMP-TABLE T-DREPO.
    RUN dispatch IN h_b-ra-generacion ('open-query':U).
    DISPLAY
        FILL-IN-CodFam
        FILL-IN-CodPro
        FILL-IN-Glosa 
        FILL-IN-Marca 
        FILL-IN-NomPro
        FILL-IN-SubFam
        FILL-IN-ImpMin
        FILL-IN-PorRep
        FILL-IN-Texto
        TOGGLE-VtaPuntual
        COMBO-BOX-Motivo 
        COMBO-BOX-Tipo
        .
    ASSIGN
        SELECT-Clasificacion:SCREEN-VALUE = ""
        BUTTON-4:SENSITIVE = YES
        BUTTON-6:SENSITIVE = YES
        BUTTON-20:SENSITIVE = YES
        FILL-IN-CodPro:SENSITIVE = YES
        FILL-IN-Marca:SENSITIVE = YES
        COMBO-BOX-Motivo = 'Seleccione un motivo'.
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
  DO WITH FRAME {&FRAME-NAME}:
      txtFechaEntrega:SCREEN-VALUE  = STRING(TODAY + 2,"99/99/9999").
      COMBO-BOX-Motivo:DELIMITER = '|'.
      FOR EACH FacTabla NO-LOCK WHERE FacTabla.CodCia = s-codcia
          AND FacTabla.Tabla = 'REPOMOTIVO':
          COMBO-BOX-Motivo:ADD-LAST(FacTabla.Nombre, FacTabla.Codigo).
      END.
      IF s-acceso-total = NO THEN BUTTON-1:SENSITIVE = NO.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumimos-por-Marca W-Win 
PROCEDURE Resumimos-por-Marca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR n-Items AS INT NO-UNDO.

    FOR EACH T-DREPO, FIRST Almmmatg OF T-DREPO NO-LOCK
        BREAK BY T-DREPO.AlmPed BY Almmmatg.DesMar:
        IF FIRST-OF(T-DREPO.AlmPed) OR FIRST-OF(Almmmatg.DesMar) 
            THEN DO:
            /* Inicializamos */
            EMPTY TEMP-TABLE T-DREPO-2.
        END.
        CREATE T-DREPO-2.
        BUFFER-COPY T-DREPO TO T-DREPO-2.
        IF LAST-OF(T-DREPO.AlmPed) OR LAST-OF(Almmmatg.DesMar) 
            THEN DO:
            IF s-acceso-total = YES THEN DO:    /* ABASTECIMIENTOS: SI CUENTA */
                /* Contamos */
                n-Items = 0.
                FOR EACH T-DREPO-2:
                    n-Items = n-Items + 1.
                END.
                /* Grabamos en tablas diferentes */
                IF n-Items >= 10 THEN DO:
                    FOR EACH T-DREPO-2 NO-LOCK:
                        CREATE T-DREPO-3.
                        BUFFER-COPY T-DREPO-2 TO T-DREPO-3.
                    END.
                END.
                ELSE DO:
                    FOR EACH T-DREPO-2 NO-LOCK:
                        CREATE T-DREPO-4.
                        BUFFER-COPY T-DREPO-2 TO T-DREPO-4.
                    END.
                END.
            END.
            ELSE DO:                            /* ALMACENES: NO CUENTA */
                FOR EACH T-DREPO-2 NO-LOCK:
                    CREATE T-DREPO-4.
                    BUFFER-COPY T-DREPO-2 TO T-DREPO-4.
                END.
            END.
        END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Separa-Articulos W-Win 
PROCEDURE Separa-Articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-DREPO-2.

FOR EACH T-DREPO:
    CREATE T-DREPO-2.
    BUFFER-COPY T-DREPO TO T-DREPO-2.
END.
EMPTY TEMP-TABLE T-DREPO.

DEF VAR x-CanGen AS DECI NO-UNDO.
DEF VAR x-CanMaster AS DECI NO-UNDO.

FOR EACH T-DREPO-2 WHERE NO-LOCK, FIRST Almmmatg OF T-DREPO-2 NO-LOCK:
    IF Almmmatg.CanEmp <= 0 OR T-DREPO-2.CanGen < Almmmatg.CanEmp THEN DO:
        CREATE T-DREPO.
        BUFFER-COPY T-DREPO-2 TO T-DREPO
            ASSIGN T-DREPO.Origen = "Saldo".
    END.
    ELSE DO:
        x-CanGen = T-DREPO-2.CanGen.
        /* Se va a fraccionar en 2 partes: Una en Master y lo que queda en Saldo */
        x-CanMaster = TRUNCATE(x-CanGen / Almmmatg.CanEmp, 0).
        /* Primero el Master */
        CREATE T-DREPO.
        BUFFER-COPY T-DREPO-2 TO T-DREPO
            ASSIGN 
            T-DREPO.CanGen = x-CanMaster * Almmmatg.CanEmp
            T-DREPO.Origen = "Master".
        x-CanGen = x-CanGen - T-DREPO.CanGen.
        /* Segundo el Saldo */
        IF x-CanGen > 0 THEN DO:
            /* Marcamos el anterior */
            T-DREPO.Sector = "*".
            CREATE T-DREPO.
            BUFFER-COPY T-DREPO-2 TO T-DREPO
                ASSIGN 
                T-DREPO.CanGen = x-CanGen
                T-DREPO.Origen = "Saldo".
            /* Marcamos el actual */
            T-DREPO.Sector = "*".
        END.
    END.
END.
EMPTY TEMP-TABLE T-DREPO-2.

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

