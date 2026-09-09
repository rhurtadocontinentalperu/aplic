&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME sW-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-MATE FOR Almmmate.
DEFINE NEW SHARED TEMP-TABLE T-DREPO LIKE almdrepo.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sW-Win 
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
/*DEF SHARED VAR s-coddiv AS CHAR.*/
DEF VAR pCodDiv AS CHAR NO-UNDO.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR pv-codcia AS INT.

DEF VAR s-coddoc AS CHAR INIT 'R/A' NO-UNDO.
DEF VAR s-tipmov AS CHAR INIT 'A' NO-UNDO.

DEF VAR x-Clasificaciones AS CHAR NO-UNDO.


DEF BUFFER MATE FOR Almmmate.

DEF NEW SHARED VAR s-nivel-acceso AS INT INIT 0.
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
&Scoped-Define ENABLED-OBJECTS RECT-9 RECT-1 BUTTON-4 BUTTON-7 ~
FILL-IN-PorRep FILL-IN-ImpMin SELECT-Clasificacion FILL-IN-CodPro ~
FILL-IN-Marca FILL-IN-Glosa txtFechaEntrega BUTTON-20 BUTTON-1 BUTTON-5 ~
BUTTON-IMPORTAR-EXCEL BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Temporada FILL-IN-Almacen ~
FILL-IN-CodFam FILL-IN-PorRep FILL-IN-SubFam FILL-IN-ImpMin FILL-IN-CodAlm ~
SELECT-Clasificacion FILL-IN-CodPro FILL-IN-NomPro FILL-IN-Marca ~
FILL-IN-Glosa txtFechaEntrega FILL-IN-Texto FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR sW-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-pedrepaut AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv08 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "CALCULO DE REPOSICION AUTOMATICA" 
     SIZE 33 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "GENERAR PEDIDO DE REPOSICION" 
     SIZE 33 BY 1.12.

DEFINE BUTTON BUTTON-20 
     IMAGE-UP FILE "img/b-buscar.ico":U
     LABEL "Button 20" 
     SIZE 4 BY .81.

DEFINE BUTTON BUTTON-3 
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
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-IMPORTAR-EXCEL 
     LABEL "IMPORTAR EXCEL" 
     SIZE 20 BY 1.12.

DEFINE VARIABLE FILL-IN-Almacen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1
     BGCOLOR 11 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Considerar stock de" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Familias" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPro AS CHARACTER FORMAT "x(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Glosa AS CHARACTER FORMAT "X(60)":U 
     LABEL "Glosa" 
     VIEW-AS FILL-IN 
     SIZE 63 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpMin AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     LABEL "Importe Mínimo de Reposición S/." 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Marca AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 68 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-PorRep AS DECIMAL FORMAT ">>9.99":U INITIAL 100 
     LABEL "% de Reposición" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

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
     SIZE 63 BY .81 NO-UNDO.

DEFINE VARIABLE txtFechaEntrega AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Entrega" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 141 BY 1.73
     BGCOLOR 11 .

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 141 BY 7.12.

DEFINE VARIABLE SELECT-Clasificacion AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE 
     LIST-ITEM-PAIRS "Sin Clasificacion","N",
                     "A","A",
                     "B","B",
                     "C","C",
                     "D","D",
                     "E","E",
                     "F","F" 
     SIZE 15 BY 3.85 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Temporada AT ROW 1.19 COL 115 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     FILL-IN-Almacen AT ROW 1.38 COL 6 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     FILL-IN-CodFam AT ROW 3.12 COL 16 COLON-ALIGNED WIDGET-ID 14
     BUTTON-4 AT ROW 3.12 COL 67 WIDGET-ID 12
     BUTTON-7 AT ROW 3.12 COL 78 WIDGET-ID 58
     FILL-IN-PorRep AT ROW 3.69 COL 118 COLON-ALIGNED WIDGET-ID 42
     FILL-IN-SubFam AT ROW 3.88 COL 16 COLON-ALIGNED WIDGET-ID 54
     BUTTON-6 AT ROW 3.88 COL 67 WIDGET-ID 52
     FILL-IN-ImpMin AT ROW 4.46 COL 118 COLON-ALIGNED WIDGET-ID 44
     FILL-IN-CodAlm AT ROW 4.65 COL 16 COLON-ALIGNED WIDGET-ID 18
     BUTTON-3 AT ROW 4.65 COL 67 WIDGET-ID 16
     SELECT-Clasificacion AT ROW 5.23 COL 120 NO-LABEL WIDGET-ID 46
     FILL-IN-CodPro AT ROW 5.42 COL 16 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-NomPro AT ROW 5.42 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     FILL-IN-Marca AT ROW 6.19 COL 16 COLON-ALIGNED WIDGET-ID 28
     FILL-IN-Glosa AT ROW 6.96 COL 16 COLON-ALIGNED WIDGET-ID 32
     txtFechaEntrega AT ROW 6.96 COL 92 COLON-ALIGNED WIDGET-ID 56
     FILL-IN-Texto AT ROW 7.73 COL 16 COLON-ALIGNED WIDGET-ID 64
     BUTTON-20 AT ROW 7.73 COL 81 WIDGET-ID 66
     BUTTON-1 AT ROW 8.69 COL 6 WIDGET-ID 2
     BUTTON-5 AT ROW 8.69 COL 39 WIDGET-ID 34
     BUTTON-IMPORTAR-EXCEL AT ROW 8.69 COL 60 WIDGET-ID 50
     BUTTON-2 AT ROW 8.69 COL 80 WIDGET-ID 4
     FILL-IN-Mensaje AT ROW 25.23 COL 73 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     "Clasificación:" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 5.42 COL 111 WIDGET-ID 48
     "Filtros" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.73 COL 5 WIDGET-ID 20
          BGCOLOR 1 FGCOLOR 15 
     RECT-9 AT ROW 2.92 COL 2 WIDGET-ID 26
     RECT-1 AT ROW 1 COL 2 WIDGET-ID 40
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 143.14 BY 25.77
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-MATE B "?" ? INTEGRAL Almmmate
      TABLE: T-DREPO T "NEW SHARED" ? INTEGRAL almdrepo
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW sW-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "PEDIDO PARA REPOSICION AUTOMATICA"
         HEIGHT             = 26.08
         WIDTH              = 143.14
         MAX-HEIGHT         = 26.08
         MAX-WIDTH          = 144.57
         VIRTUAL-HEIGHT     = 26.08
         VIRTUAL-WIDTH      = 144.57
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sW-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sW-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON BUTTON-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-6 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Almacen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-SubFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Temporada IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Texto IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(sW-Win)
THEN sW-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME sW-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sW-Win sW-Win
ON END-ERROR OF sW-Win /* PEDIDO PARA REPOSICION AUTOMATICA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sW-Win sW-Win
ON WINDOW-CLOSE OF sW-Win /* PEDIDO PARA REPOSICION AUTOMATICA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 sW-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* CALCULO DE REPOSICION AUTOMATICA */
DO:        
  DEF VAR k AS INT NO-UNDO.
  DEF VAR j AS INT NO-UNDO.

  ASSIGN
      FILL-IN-CodAlm FILL-IN-CodFam FILL-IN-SubFam FILL-IN-CodPro FILL-IN-Marca FILL-IN-Glosa
      FILL-IN-ImpMin FILL-IN-PorRep.
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
      BUTTON-3:SENSITIVE = NO
      BUTTON-4:SENSITIVE = NO
      BUTTON-6:SENSITIVE = NO
      FILL-IN-CodPro:SENSITIVE = NO.

  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal (FILL-IN-CodPro, 
                      FILL-IN-Marca, 
                      FILL-IN-CodFam, 
                      FILL-IN-SubFam,
                      FILL-IN-CodAlm).
  SESSION:SET-WAIT-STATE('').
  MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 sW-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* GENERAR PEDIDO DE REPOSICION */
DO:
  SESSION:SET-WAIT-STATE('GENERAL').
  ASSIGN
    FILL-IN-Glosa txtFechaEntrega.

  IF txtFechaEntrega < TODAY THEN DO:
      MESSAGE "Fecha de Entrega no puede ser anterior a la Actual" VIEW-AS ALERT-BOX.
      RETURN NO-APPLY.
  END.

  RUN Generar-Pedidos.
  SESSION:SET-WAIT-STATE('').

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-20
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-20 sW-Win
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


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 sW-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* ... */
DO:
    DEFINE VARIABLE x-almacenes AS CHAR NO-UNDO.
    x-almacenes = FILL-IN-CodAlm:SCREEN-VALUE.
    RUN alm/d-almacen (INPUT-OUTPUT x-almacenes).
    FILL-IN-CodAlm:SCREEN-VALUE = x-almacenes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 sW-Win
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 sW-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* GENERAR EXCEL */
DO:
   RUN Excel IN h_b-pedrepaut.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 sW-Win
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 sW-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* Limpiar Filtros */
DO:
  RUN Limpiar-Filtros.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-IMPORTAR-EXCEL
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-IMPORTAR-EXCEL sW-Win
ON CHOOSE OF BUTTON-IMPORTAR-EXCEL IN FRAME F-Main /* IMPORTAR EXCEL */
DO:
   RUN Importar-Excel IN h_b-pedrepaut.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPro sW-Win
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
  FILL-IN-NomPro:SCREEN-VALUE = gn-prov.nompro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Marca sW-Win
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sW-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects sW-Win  _ADM-CREATE-OBJECTS
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
             INPUT  'aplic/alm/b-pedrepaut.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ,
                     SortBy-Case = Codigo':U ,
             OUTPUT h_b-pedrepaut ).
       RUN set-position IN h_b-pedrepaut ( 10.23 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-pedrepaut ( 14.92 , 141.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv08.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv08 ).
       RUN set-position IN h_p-updv08 ( 25.19 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv08 ( 1.42 , 49.86 ) NO-ERROR.

       /* Links to SmartBrowser h_b-pedrepaut. */
       RUN add-link IN adm-broker-hdl ( h_p-updv08 , 'TableIO':U , h_b-pedrepaut ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-pedrepaut ,
             BUTTON-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv08 ,
             h_b-pedrepaut , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available sW-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-1-Registro sW-Win 
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
        RUN adm-open-query-cases IN h_b-pedrepaut.
        /*RUN adm-row-available IN h_b-pedrepaut.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal sW-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodPro AS CHAR.
DEF INPUT PARAMETER pMarca  AS CHAR.
DEF INPUT PARAMETER pCodFam AS CHAR.
DEF INPUT PARAMETER pSubFam AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.

EMPTY TEMP-TABLE t-drepo.
/* EL CALCULO DEPENDE DEL TIPO DE REPOSICION DEL ALMACEN */
/* FIND Almacen WHERE Almacen.codcia = s-codcia                                                  */
/*     AND Almacen.codalm = s-codalm                                                             */
/*     NO-LOCK.                                                                                  */
/* CASE Almacen.Campo[7]:                                                                        */
/*     WHEN "" THEN RUN Por-Rotacion (pCodPro, pMarca, pCodFam, pCodAlm).                        */
/*     WHEN "REU" THEN RUN Por-Reposicion (Almacen.Campo[7], pCodPro, pMarca, pCodFam, pCodAlm). */
/*     WHEN "REE" THEN RUN Por-Reposicion (Almacen.Campo[7], pCodPro, pMarca, pCodFam, pCodAlm). */
/*     WHEN "RUT" THEN RUN Por-Utilex (pCodPro, pMarca, pCodFam, pCodAlm).                       */
/* END CASE.                                                                                     */
RUN Por-Utilex (pCodPro, pMarca, pCodFam, pSubFam, pCodAlm).
RUN dispatch IN h_b-pedrepaut ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sW-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(sW-Win)
  THEN DELETE WIDGET sW-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI sW-Win  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-Temporada FILL-IN-Almacen FILL-IN-CodFam FILL-IN-PorRep 
          FILL-IN-SubFam FILL-IN-ImpMin FILL-IN-CodAlm SELECT-Clasificacion 
          FILL-IN-CodPro FILL-IN-NomPro FILL-IN-Marca FILL-IN-Glosa 
          txtFechaEntrega FILL-IN-Texto FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW sW-Win.
  ENABLE RECT-9 RECT-1 BUTTON-4 BUTTON-7 FILL-IN-PorRep FILL-IN-ImpMin 
         SELECT-Clasificacion FILL-IN-CodPro FILL-IN-Marca FILL-IN-Glosa 
         txtFechaEntrega BUTTON-20 BUTTON-1 BUTTON-5 BUTTON-IMPORTAR-EXCEL 
         BUTTON-2 
      WITH FRAME F-Main IN WINDOW sW-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW sW-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generar-Pedidos sW-Win 
PROCEDURE Generar-Pedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* RHC 30.07.2014 Se va a limitra a 100 itesm por pedido */
DEF VAR n-Items AS INT NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FIND FIRST Faccorre WHERE Faccorre.codcia = s-codcia
        AND Faccorre.coddoc = s-coddoc
        AND Faccorre.flgest = YES
        /*AND Faccorre.codalm = s-codalm*/
        /*AND Faccorre.coddiv = s-coddiv*/
        AND Faccorre.coddiv = pCodDiv
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccorre THEN DO:
        /*MESSAGE 'No se encuentra el correlativo para la división' s-coddoc s-coddiv*/
        MESSAGE 'No se encuentra el correlativo para la división' s-coddoc pCodDiv
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN "ADM-ERROR".
    END.
    FOR EACH T-DREPO WHERE T-DREPO.AlmPed <> '998' BREAK BY T-DREPO.AlmPed BY T-DREPO.Origen:
        IF FIRST-OF(AlmPed) OR FIRST-OF(Origen) OR n-Items >= 52 THEN DO:
            s-TipMov = "A".
            IF T-DREPO.Origen = "MAN" THEN s-TipMov = "M".
            CREATE Almcrepo.
            ASSIGN
                almcrepo.AlmPed = T-DREPO.Almped
                almcrepo.CodAlm = s-codalm
                almcrepo.CodCia = s-codcia
                almcrepo.FchDoc = TODAY
                almcrepo.FchVto = TODAY + 7
                /*almcrepo.Fecha = TODAY*/          /* Ic 13May2015*/
                almcrepo.Fecha = txtFechaEntrega    /* Ic 13May2015*/
                almcrepo.Hora = STRING(TIME, 'HH:MM')
                almcrepo.NroDoc = Faccorre.correlativo
                almcrepo.NroSer = Faccorre.nroser
                almcrepo.TipMov = s-TipMov          /* OJO: Manual Automático */
                almcrepo.Usuario = s-user-id
                almcrepo.Glosa = fill-in-Glosa.
            ASSIGN
                Faccorre.correlativo = Faccorre.correlativo + 1
                n-Items = 0.
            /* RHC 21/04/2016 Almacén de despacho CD? */
            IF CAN-FIND(FIRST TabGener WHERE TabGener.CodCia = s-codcia
                        AND TabGener.Clave = "ZG"
                        AND TabGener.Libre_c01 = Almcrepo.AlmPed    /* Almacén de Despacho */
                        AND TabGener.Libre_l01 = YES                /* CD */
                        NO-LOCK)
                THEN Almcrepo.FlgSit = "G".   /* Por Autorizar por Abastecimientos */
            /* ************************************** */
        END.
        CREATE Almdrepo.
        BUFFER-COPY T-DREPO TO Almdrepo
            ASSIGN
            almdrepo.CodCia = almcrepo.codcia
            almdrepo.CodAlm = almcrepo.codalm
            almdrepo.TipMov = almcrepo.tipmov
            almdrepo.NroSer = almcrepo.nroser
            almdrepo.NroDoc = almcrepo.nrodoc
            almdrepo.CanReq = almdrepo.cangen
            almdrepo.CanApro = almdrepo.cangen.
        DELETE T-DREPO.
        n-Items = n-Items + 1.
    END.
    EMPTY TEMP-TABLE T-DREPO.
    RELEASE Faccorre.
    RELEASE almcrepo.
    RELEASE almdrepo.
END.
RUN adm-open-query IN h_b-pedrepaut.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Limpiar-Filtros sW-Win 
PROCEDURE Limpiar-Filtros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        FILL-IN-CodAlm = ''
        FILL-IN-CodFam = ''
        FILL-IN-CodPro = ''
        FILL-IN-Glosa  = ''
        FILL-IN-Marca  = ''
        FILL-IN-NomPro = ''
        FILL-IN-SubFam = ''
        FILL-IN-ImpMin = 0
        SELECT-Clasificacion = 'N'
        FILL-IN-Texto = ''.
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
    EMPTY TEMP-TABLE T-DREPO.
    RUN dispatch IN h_b-pedrepaut ('open-query':U).
    DISPLAY
        FILL-IN-CodAlm
        FILL-IN-CodFam
        FILL-IN-CodPro
        FILL-IN-Glosa 
        FILL-IN-Marca 
        FILL-IN-NomPro
        FILL-IN-SubFam
        FILL-IN-ImpMin
        FILL-IN-PorRep
        FILL-IN-Texto.
    ASSIGN
        SELECT-Clasificacion:SCREEN-VALUE = "N"
        BUTTON-3:SENSITIVE = YES
        BUTTON-4:SENSITIVE = YES
        BUTTON-6:SENSITIVE = YES
        FILL-IN-CodPro:SENSITIVE = YES.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit sW-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize sW-Win 
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
      WHEN Almcfggn.Temporada = "C" THEN FILL-IN-Temporada = "CAMPAÑA".
      WHEN Almcfggn.Temporada = "NC" THEN FILL-IN-Temporada = "NO CAMPAÑA".
  END CASE.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  txtFechaEntrega:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY + 2,"99/99/9999").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Por-Reposicion sW-Win 
PROCEDURE Por-Reposicion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Puede ser en Unidades o en Empaques
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pTipRot AS CHAR.
DEF INPUT PARAMETER pCodPro AS CHAR.
DEF INPUT PARAMETER pMarca AS CHAR.
DEF INPUT PARAMETER pCodFam AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.

DEF VAR x-StockMinimo AS DEC NO-UNDO.
DEF VAR x-StkAct AS DEC NO-UNDO.
DEF VAR k AS INT NO-UNDO.
DEF VAR pReposicion AS DEC NO-UNDO.
DEF VAR x-Item AS INT NO-UNDO.
DEF VAR x-TipMat AS CHAR NO-UNDO.
DEF VAR pComprometido AS DEC NO-UNDO.
DEF VAR x-StockDisponible AS DEC NO-UNDO.
DEF VAR x-CanReq AS DEC NO-UNDO.

/* Buscamos los valores generales */
FIND FIRST AlmCfgGn WHERE almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcfggn THEN DO:
    MESSAGE 'Debe configurar los parámetros generales' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

EMPTY TEMP-TABLE t-drepo.
/*f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Buscando información, un momento por favor'.*/

FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.tpoart <> "D"
    AND (pCodFam = "" OR LOOKUP(Almmmatg.codfam, pCodFam) > 0)
    AND (pCodPro = "" OR Almmmatg.codpr1 = pCodPro)
    AND (pMarca = "" OR Almmmatg.desmar BEGINS pMarca),
    EACH Almmmate OF Almmmatg NO-LOCK WHERE Almmmate.codalm = s-codalm
    AND Almmmate.StkRep > 0:
    /*f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Procesando ' + Almmmate.codmat.*/

    /* Stock Minimo */
    ASSIGN
        x-StockMinimo = Almmmate.StkRep
        x-StkAct = Almmmate.StkAct.
    IF x-StkAct >= x-StockMinimo THEN NEXT.
    /* Cantidad de Reposicion */
    pReposicion = x-StockMinimo - x-StkAct.
    /* distribuimos el pedido entre los almacenes de despacho */
    IF Almmmatg.Chr__02 = "P" THEN x-TipMat = "P". ELSE x-TipMat = "T".
    FOR EACH Almrepos NO-LOCK WHERE  almrepos.CodCia = s-codcia
        AND almrepos.CodAlm = Almmmate.codalm 
        AND almrepos.AlmPed <> Almmmate.codalm
        AND almrepos.TipMat = x-TipMat      /* Propios o Terceros */
        AND pReposicion > 0 /* <<< OJO <<< */
        BY almrepos.Orden:
        FIND B-MATE WHERE B-MATE.codcia = s-codcia
            AND B-MATE.codmat = Almmmate.codmat
            AND B-MATE.codalm = Almrepos.almped
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-MATE THEN NEXT.
/*         RUN vta2/Stock-Comprometido (Almmmate.CodMat, Almrepos.AlmPed, OUTPUT pComprometido). */
        RUN vta2/Stock-Comprometido-v2 (Almmmate.CodMat, Almrepos.AlmPed, OUTPUT pComprometido).
        x-StockDisponible = B-MATE.StkAct - x-StockMinimo - pComprometido.
        IF x-StockDisponible <= 0 THEN NEXT.
        /* Se solicitará la reposición de acuerdo al empaque del producto */
        x-CanReq = MINIMUM(x-StockDisponible, pReposicion).
        IF pTipRot = "REE" AND Almmmatg.CanEmp > 0 THEN DO:
            x-CanReq = ROUND(x-CanReq / Almmmatg.CanEmp, 0) * Almmmatg.CanEmp.
        END.
        IF x-CanReq <= 0 THEN NEXT.    /* Menos que la cantidad por empaque */
        /* Redondeamos la cantidad a enteros */
        IF TRUNCATE(x-CanReq,0) <> x-CanReq THEN DO:
            x-CanReq = TRUNCATE(x-CanReq,0) + 1.
        END.
        /* ********************************* */
        CREATE T-DREPO.
        ASSIGN
            T-DREPO.Origen = 'AUT'
            T-DREPO.CodCia = s-codcia 
            T-DREPO.CodAlm = s-codalm 
            T-DREPO.Item = x-Item
            T-DREPO.AlmPed = Almrepos.almped
            T-DREPO.CodMat = Almmmate.codmat
            T-DREPO.CanReq = x-CanReq
            T-DREPO.CanGen = x-CanReq
            T-DREPO.StkAct = x-StockDisponible.
        ASSIGN
            x-Item = x-Item + 1
            pReposicion = pReposicion - T-DREPO.CanReq.
    END.
    /* RHC 15/10/2012 si queda un saldo lo pintamos en el almacén 998 */
    IF pReposicion > 0 THEN DO:
        x-CanReq = pReposicion.
        IF Almmmatg.CanEmp > 0 THEN DO:
            x-CanReq = ROUND(x-CanReq / Almmmatg.CanEmp, 0) * Almmmatg.CanEmp.
        END.
        IF x-CanReq > 0 THEN DO:
            /* Redondeamos la cantidad a enteros */
            IF TRUNCATE(x-CanReq,0) <> x-CanReq THEN DO:
                x-CanReq = TRUNCATE(x-CanReq,0) + 1.
            END.
            /* ********************************* */
            CREATE T-DREPO.
            ASSIGN
                T-DREPO.Origen = 'AUT'
                T-DREPO.CodCia = s-codcia 
                T-DREPO.CodAlm = s-codalm
                T-DREPO.Item = x-Item
                T-DREPO.AlmPed = "998"
                T-DREPO.CodMat = Almmmate.codmat
                T-DREPO.CanReq = 0
                T-DREPO.CanGen = x-CanReq
                /*T-DREPO.CanGen = pReposicion*/
                T-DREPO.StkAct = 0.
            x-Item = x-Item + 1.
        END.
    END.
END.

FOR EACH T-DREPO WHERE T-DREPO.canreq <= 0 AND LOOKUP(T-DREPO.AlmPed, '997,998') = 0:
    DELETE T-DREPO.
END.
/*f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '*** PROCESO TERMINADO ***'.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Por-Rotacion sW-Win 
PROCEDURE Por-Rotacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodPro AS CHAR.
DEF INPUT PARAMETER pMarca AS CHAR.
DEF INPUT PARAMETER pCodFam AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.

DEF VAR pRowid AS ROWID NO-UNDO.
DEF VAR pVentaDiaria AS DEC NO-UNDO.
DEF VAR pDiasMinimo AS INT.
DEF VAR pDiasUtiles AS INT.
DEF VAR x-StockMinimo AS DEC NO-UNDO.
DEF VAR x-StkAct AS DEC NO-UNDO.
DEF VAR k AS INT NO-UNDO.
DEF VAR pReposicion AS DEC NO-UNDO.
DEF VAR x-Item AS INT NO-UNDO.
DEF VAR x-TipMat AS CHAR NO-UNDO.
DEF VAR pComprometido AS DEC NO-UNDO.
DEF VAR x-StockDisponible AS DEC NO-UNDO.
DEF VAR x-CanReq AS DEC NO-UNDO.

/* Buscamos los valores generales */
FIND FIRST AlmCfgGn WHERE almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcfggn THEN DO:
    MESSAGE 'Debe configurar los parámetros generales' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

EMPTY TEMP-TABLE t-drepo.
/*f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Buscando información, un momento por favor'.*/

FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.tpoart <> "D"
    AND (pCodFam = "" OR LOOKUP(Almmmatg.codfam, pCodFam) > 0)
    AND (pCodPro = "" OR Almmmatg.codpr1 = pCodPro)
    AND (pMarca = "" OR Almmmatg.desmar BEGINS pMarca),
    EACH Almmmate OF Almmmatg NO-LOCK WHERE Almmmate.codalm = s-codalm:
    /*f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Procesando ' + Almmmate.codmat.*/
    /* Venta Diaria */
    ASSIGN
        pDiasMinimo = AlmCfgGn.DiasMinimo
        pDiasUtiles = AlmCfgGn.DiasUtiles.
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = Almmmatg.codpr1
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov AND gn-prov.StkMin > 0 THEN pDiasMinimo = gn-prov.StkMin.

    /* VA A HABER 2 FORMAS DE CALCULARLO:
        MANUAL: SIEMPRE Y CUANDO EL CAMPO ALMMMATE.STKMIN > 0 
        POR HISTORICOS: CUANDO EL CAMPO ALMMMATE.STKMIN = 0
        */
    IF Almmmate.StkMin = 0 THEN DO:     /* DEL HISTORICO */
        ASSIGN
            pRowid = ROWID(Almmmate)
            pVentaDiaria = DECIMAL(Almmmate.Libre_c04).
        /* Stock Minimo */
        ASSIGN
            x-StockMinimo = pDiasMinimo * pVentaDiaria
            x-StkAct = Almmmate.StkAct.
        IF pCodAlm <> '' THEN DO:
            DO k = 1 TO NUM-ENTRIES(pCodAlm):
                IF ENTRY(k, pCodAlm) = s-codalm THEN NEXT.   /* NO del almacen activo */
                FIND B-MATE WHERE B-MATE.codcia = s-codcia
                    AND B-MATE.codalm = ENTRY(k, pCodAlm)
                    AND B-MATE.codmat = Almmmate.codmat
                    NO-LOCK NO-ERROR.
                IF AVAILABLE B-MATE THEN x-StkAct = x-StkAct + B-MATE.StkAct.
            END.
        END.
        IF x-StkAct >= x-StockMinimo THEN NEXT.
        /* Cantidad de Reposicion */
        RUN gn/cantidad-de-reposicion (pRowid, pVentaDiaria, OUTPUT pReposicion).
        IF pReposicion <= 0 THEN NEXT.
        /* RHC 05/12/2012 NO tiene histórico */
        IF Almmmate.Libre_C01 = "SIN HISTORICO" THEN DO:
            CREATE T-DREPO.
            ASSIGN
                T-DREPO.Origen = 'AUT'
                T-DREPO.CodCia = s-codcia 
                T-DREPO.CodAlm = s-codalm
                T-DREPO.Item = x-Item
                T-DREPO.AlmPed = "997"
                T-DREPO.CodMat = Almmmate.codmat
                T-DREPO.CanReq = 0
                T-DREPO.CanGen = pReposicion
                T-DREPO.StkAct = 0.
            x-Item = x-Item + 1.
            NEXT.
        END.
    END.
    IF Almmmate.StkMin > 0 THEN DO:     /* MANUAL */
        /* Stock Minimo */
        ASSIGN
            x-StockMinimo = Almmmate.StkMin
            x-StkAct = Almmmate.StkAct.
        IF pCodAlm <> '' THEN DO:
            DO k = 1 TO NUM-ENTRIES(pCodAlm):
                IF ENTRY(k, pCodAlm) = s-codalm THEN NEXT.   /* NO del almacen activo */
                FIND B-MATE WHERE B-MATE.codcia = s-codcia
                    AND B-MATE.codalm = ENTRY(k, pCodAlm)
                    AND B-MATE.codmat = Almmmate.codmat
                    NO-LOCK NO-ERROR.
                IF AVAILABLE B-MATE THEN x-StkAct = x-StkAct + B-MATE.StkAct.
            END.
        END.
        IF x-StkAct >= x-StockMinimo THEN NEXT.
        /* Cantidad de Reposicion */
        pReposicion = x-StockMinimo - x-StkAct.
    END.
    /* distribuimos el pedido entre los almacenes de despacho */
    IF Almmmatg.Chr__02 = "P" THEN x-TipMat = "P". ELSE x-TipMat = "T".
    FOR EACH Almrepos NO-LOCK WHERE  almrepos.CodCia = s-codcia
        AND almrepos.CodAlm = Almmmate.codalm 
        AND almrepos.AlmPed <> Almmmate.codalm
        AND almrepos.TipMat = x-TipMat      /* Propios o Terceros */
        AND pReposicion > 0 /* <<< OJO <<< */
        BY almrepos.Orden:
        FIND B-MATE WHERE B-MATE.codcia = s-codcia
            AND B-MATE.codmat = Almmmate.codmat
            AND B-MATE.codalm = Almrepos.almped
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-MATE THEN NEXT.
/*         RUN vta2/Stock-Comprometido (Almmmate.CodMat, Almrepos.AlmPed, OUTPUT pComprometido). */
        RUN vta2/Stock-Comprometido-v2 (Almmmate.CodMat, Almrepos.AlmPed, OUTPUT pComprometido).
        x-StockDisponible = B-MATE.StkAct - x-StockMinimo - pComprometido.
        IF x-StockDisponible <= 0 THEN NEXT.
        /* Se solicitará la reposición de acuerdo al empaque del producto */
        x-CanReq = MINIMUM(x-StockDisponible, pReposicion).
        IF Almmmatg.CanEmp > 0 THEN DO:
            x-CanReq = ROUND(x-CanReq / Almmmatg.CanEmp, 0) * Almmmatg.CanEmp.
        END.
        IF x-CanReq <= 0 THEN NEXT.    /* Menos que la cantidad por empaque */
        /* Redondeamos la cantidad a enteros */
        IF TRUNCATE(x-CanReq,0) <> x-CanReq THEN DO:
            x-CanReq = TRUNCATE(x-CanReq,0) + 1.
        END.
        /* ********************************* */
        CREATE T-DREPO.
        ASSIGN
            T-DREPO.Origen = 'AUT'
            T-DREPO.CodCia = s-codcia 
            T-DREPO.CodAlm = s-codalm 
            T-DREPO.Item = x-Item
            T-DREPO.AlmPed = Almrepos.almped
            T-DREPO.CodMat = Almmmate.codmat
            T-DREPO.CanReq = x-CanReq
            T-DREPO.CanGen = x-CanReq
            T-DREPO.StkAct = x-StockDisponible.
        ASSIGN
            x-Item = x-Item + 1
            pReposicion = pReposicion - T-DREPO.CanReq.
    END.
    /* RHC 15/10/2012 si queda un saldo lo pintamos en el almacén 998 */
    IF pReposicion > 0 THEN DO:
        x-CanReq = pReposicion.
        IF Almmmatg.CanEmp > 0 THEN DO:
            /*x-CanReq = TRUNCATE(x-CanReq / Almmmatg.CanEmp, 0) * Almmmatg.CanEmp.*/
            x-CanReq = ROUND(x-CanReq / Almmmatg.CanEmp, 0) * Almmmatg.CanEmp.
        END.
        IF x-CanReq > 0 THEN DO:
            /* Redondeamos la cantidad a enteros */
            IF TRUNCATE(x-CanReq,0) <> x-CanReq THEN DO:
                x-CanReq = TRUNCATE(x-CanReq,0) + 1.
            END.
            /* ********************************* */
            CREATE T-DREPO.
            ASSIGN
                T-DREPO.Origen = 'AUT'
                T-DREPO.CodCia = s-codcia 
                T-DREPO.CodAlm = s-codalm
                T-DREPO.Item = x-Item
                T-DREPO.AlmPed = "998"
                T-DREPO.CodMat = Almmmate.codmat
                T-DREPO.CanReq = 0
                T-DREPO.CanGen = x-CanReq
                /*T-DREPO.CanGen = pReposicion*/
                T-DREPO.StkAct = 0.
            x-Item = x-Item + 1.
        END.
    END.
END.

FOR EACH T-DREPO WHERE T-DREPO.canreq <= 0 AND LOOKUP(T-DREPO.AlmPed, '997,998') = 0:
    DELETE T-DREPO.
END.
/*f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '*** PROCESO TERMINADO ***'.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Por-Utilex sW-Win 
PROCEDURE Por-Utilex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodPro AS CHAR.
DEF INPUT PARAMETER pMarca AS CHAR.
DEF INPUT PARAMETER pCodFam AS CHAR.
DEF INPUT PARAMETER pSubFam AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.

DEF VAR pRowid AS ROWID NO-UNDO.
DEF VAR pVentaDiaria AS DEC NO-UNDO.
DEF VAR pDiasMinimo AS INT.
DEF VAR pDiasUtiles AS INT.
DEF VAR x-StockMinimo AS DEC NO-UNDO.
DEF VAR x-StockMaximo AS DEC NO-UNDO.
DEF VAR x-StkAct AS DEC NO-UNDO.
DEF VAR k AS INT NO-UNDO.
DEF VAR pReposicion AS DEC NO-UNDO.
DEF VAR pAReponer   AS DEC NO-UNDO.
DEF VAR x-Item AS INT NO-UNDO.
DEF VAR x-TipMat AS CHAR NO-UNDO.
DEF VAR pComprometido AS DEC NO-UNDO.
DEF VAR x-StockDisponible AS DEC NO-UNDO.
DEF VAR x-CanReq AS DEC NO-UNDO.

/* Buscamos los valores generales */
FIND FIRST AlmCfgGn WHERE almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcfggn THEN DO:
    MESSAGE 'Debe configurar los parámetros generales' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

EMPTY TEMP-TABLE t-drepo.

x-Clasificaciones = REPLACE(x-Clasificaciones, 'N', 'XA,XB,XC,XD,XE,XF,NA,NB,NC,ND,NE,NF,,').

PRINCIPAL:
FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.tpoart <> "D"
    AND LOOKUP(Almmmatg.TipRot[1], x-Clasificaciones) > 0
    AND (pCodFam = "" OR LOOKUP(Almmmatg.codfam, pCodFam) > 0)
    AND (pSubFam = "" OR LOOKUP(Almmmatg.subfam, pSubFam) > 0)
    AND (pCodPro = "" OR Almmmatg.codpr1 = pCodPro)
    AND (pMarca = "" OR Almmmatg.desmar BEGINS pMarca),
    FIRST Almmmate OF Almmmatg NO-LOCK WHERE Almmmate.codalm = s-codalm
    AND Almmmate.VInMn1 > 0
    AND Almmmate.StkAct < Almmmate.VInMn1:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
        "PROCESANDO: " + Almmmatg.codmat + " " + Almmmatg.desmat.
    
    /* Stock Minimo */
    ASSIGN
        x-StockMinimo = Almmmate.VInMn1
        x-StockMaximo = Almmmate.StkMax
        x-StkAct      = Almmmate.StkAct.
    IF x-StockMaximo <= 0 OR x-StockMaximo = ? THEN x-StockMaximo = 1.   /* RHC 29/02/2016 */
    /* INCREMENTAMOS LOS PEDIDOS POR REPOSICION EN TRANSITO */
    RUN alm\p-articulo-en-transito (
        Almmmate.CodCia,
        Almmmate.CodAlm,
        Almmmate.CodMat,
        INPUT-OUTPUT TABLE tmp-tabla,
        OUTPUT pComprometido
        ).
    /*RUN alm/pedidoreposicionentransito (Almmmate.CodMat, Almmmate.CodAlm, OUTPUT pComprometido).*/
    x-StkAct = x-StkAct + pComprometido.

    /* DESCONTAMOS LO COMPROMETIDO */
    RUN vta2/Stock-Comprometido-v2 (Almmmate.CodMat, Almmmate.CodAlm, OUTPUT pComprometido).
    x-StkAct = x-StkAct - pComprometido.

    
    IF x-StkAct < 0 THEN x-StkAct = 0.
    /* ************************************************** */
    IF x-StkAct >= x-StockMinimo THEN NEXT PRINCIPAL.
    /* ********************* Cantidad de Reposicion ******************* */
    /* Definimos el stock maximo */
    /* RHC 05/06/2014 Cambio de filosofía, ahora es el % del stock mínimo */
    
    IF x-StkAct >= (x-StockMinimo * FILL-IN-PorRep / 100) THEN NEXT PRINCIPAL.

    /* Se va a reponer en cantidades múltiplo del valor Almmmate.StkMax */
    pAReponer = x-StockMinimo - x-StkAct.
    pReposicion = ROUND(pAReponer / x-StockMaximo, 0) * x-StockMaximo.
    /* *************************************************** */
    /* RHC 03/08/2016 Verificamos contra el Empaque Master */
    /* 0.9 * p * Almmmatg.CanEmp <= pReposicion <= 1.1 * p * Almmmatg.CanEmp
       => 0.9 * p <= pReposicion / AlmmmatgCanEmp <= 1.1 * p
       => 0.9 * p <= dFactor <= 1.1 * p
    */
    /* *************************************************** */

    IF Almmmatg.CanEmp > 0 THEN DO:
        DEF VAR dFactor AS DEC NO-UNDO.
        DEF VAR p      AS INT NO-UNDO.
        
        dFactor = pReposicion / Almmmatg.CanEmp.
        p = 1.
        REPEAT:
            IF (0.9 * p) <= dFactor AND dFactor <= (1.1 * p) THEN DO:
                /* Recalculamos la cantidad */
                pReposicion = p * Almmmatg.CanEmp.
                LEAVE.
            END.
            IF (0.9 * p) > dFactor THEN LEAVE.
            p = p + 1.
        END.
    END.
    /*IF almmmatg.codmat = '073203' THEN MESSAGE 'fin empaque ok'.*/
    /* *************************************************** */
    IF pReposicion <= 0 THEN NEXT PRINCIPAL.
    pAReponer = pReposicion.    /* OJO */
    /* ************************************************/
    /* distribuimos el pedido entre los almacenes de despacho */
    IF Almmmatg.Chr__02 = "P" THEN x-TipMat = "P". ELSE x-TipMat = "T".
    FOR EACH Almrepos NO-LOCK WHERE  almrepos.CodCia = s-codcia
        AND almrepos.CodAlm = Almmmate.codalm 
        AND almrepos.AlmPed <> Almmmate.codalm
        AND almrepos.TipMat = x-TipMat      /* Propios o Terceros */
        AND pReposicion > 0 /* <<< OJO <<< */
        BY almrepos.Orden:
        FIND B-MATE WHERE B-MATE.codcia = s-codcia
            AND B-MATE.codalm = Almrepos.almped
            AND B-MATE.codmat = Almmmate.codmat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-MATE THEN NEXT.
        RUN vta2/Stock-Comprometido-v2 (Almmmate.CodMat, Almrepos.AlmPed, OUTPUT pComprometido).
        x-StockDisponible = B-MATE.StkAct - B-MATE.VInMn1 - pComprometido.
        IF x-StockDisponible <= 0 THEN NEXT.
        /* Se solicitará la reposición de acuerdo al empaque del producto */
        x-CanReq = MINIMUM(x-StockDisponible, pReposicion).
        x-CanReq = ROUND(x-CanReq / x-StockMaximo, 0) * x-StockMaximo.
        /* No debe superar el stock disponible */
        REPEAT WHILE x-CanReq > x-StockDisponible:
            x-CanReq = x-CanReq - Almmmate.StkMax.
        END.
        IF x-CanReq <= 0 THEN NEXT.    /* Menos que la cantidad por empaque */
        /* ******************** RHC 18/02/2014 FILTRO POR IMPORTE DE REPOSICION ********************* */
        IF Almmmatg.MonVta = 2 THEN DO:
            IF x-CanReq * Almmmatg.CtoTot * Almmmatg.TpoCmb < FILL-IN-ImpMin THEN NEXT.
        END.
        ELSE IF x-CanReq * Almmmatg.CtoTot < FILL-IN-ImpMin THEN NEXT.
        IF x-CanReq = ? THEN NEXT.
        /* ****************************************************************************************** */
        CREATE T-DREPO.
        ASSIGN
            T-DREPO.Origen = 'AUT'
            T-DREPO.CodCia = s-codcia 
            T-DREPO.CodAlm = s-codalm 
            T-DREPO.Item = x-Item
            T-DREPO.AlmPed = Almrepos.almped
            T-DREPO.CodMat = Almmmate.codmat
            T-DREPO.CanReq = pAReponer
            T-DREPO.CanGen = x-CanReq
            T-DREPO.StkAct = x-StockDisponible.
        ASSIGN
            x-Item = x-Item + 1
            pReposicion = pReposicion - T-DREPO.CanGen.
    END.
    /* RHC 15/10/2012 si queda un saldo lo pintamos en el almacén 998 */
    IF pReposicion > 0 THEN DO:
        x-CanReq = pReposicion.
        IF Almmmate.StkMax > 0 THEN DO:
            x-CanReq = ROUND(x-CanReq / Almmmate.StkMax, 0) * Almmmate.StkMax.
        END.
        IF x-CanReq > 0 THEN DO:
            /* Redondeamos la cantidad a enteros */
            IF TRUNCATE(x-CanReq,0) <> x-CanReq THEN DO:
                x-CanReq = TRUNCATE(x-CanReq,0) + 1.
            END.
            /* ********************************* */
            CREATE T-DREPO.
            ASSIGN
                T-DREPO.Origen = 'AUT'
                T-DREPO.CodCia = s-codcia 
                T-DREPO.CodAlm = s-codalm
                T-DREPO.Item = x-Item
                T-DREPO.AlmPed = "998"
                T-DREPO.CodMat = Almmmate.codmat
                T-DREPO.CanReq = pAReponer
                T-DREPO.CanGen = x-CanReq
                T-DREPO.StkAct = 0.
            x-Item = x-Item + 1.
        END.
    END.
END.

FOR EACH T-DREPO WHERE T-DREPO.canreq <= 0 AND LOOKUP(T-DREPO.AlmPed, '997,998') = 0:
    DELETE T-DREPO.
END.

/* RHC 02/08/2016 Datos adicionales */
DEF VAR x-Total AS DEC NO-UNDO.
FOR EACH T-DREPO:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
        "DATOS ADICIONALES: " + T-DREPO.codmat.
    /* Comprometido */
    RUN vta2/stock-comprometido-v2 (T-DREPO.CodMat, T-DREPO.CodAlm, OUTPUT pComprometido).
    T-DREPO.CanApro = pComprometido.
    /* En Tránsito */
    RUN alm\p-articulo-en-transito (
        s-codcia,
        s-codalm,
        T-DREPO.codmat,
        INPUT-OUTPUT TABLE tmp-tabla,
        OUTPUT x-Total).
    T-DREPO.CanTran = x-Total.
END.
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros sW-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros sW-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records sW-Win  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed sW-Win 
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

