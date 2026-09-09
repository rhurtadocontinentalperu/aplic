&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE T-ALMVTA NO-UNDO LIKE almacen_ventas.
DEFINE NEW SHARED TEMP-TABLE t-report NO-UNDO LIKE w-report.



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

DEF BUFFER bt-report FOR t-report.

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
&Scoped-Define ENABLED-OBJECTS RECT-61 RECT-1 RADIO-SET_TpoArt ~
BUTTON-Filtro BUTTON-Limpiar FILL-IN_CodMat FILL-IN_DesMat COMBO-BOX_CodFam ~
FILL-IN_DesMar COMBO-BOX_SubFam FILL-IN_NomPro BUTTON-Texto BUTTON-Grupos ~
BUTTON-Almacenes 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET_TpoArt FILL-IN_CodMat x-DesMat ~
FILL-IN_DesMat COMBO-BOX_CodFam FILL-IN_DesMar COMBO-BOX_SubFam ~
FILL-IN_NomPro EDITOR-Texto FILL-IN_Grupos FILL-IN_CodAlm FILL-IN_Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-almacen-ventas-mat AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-almacen-ventas-res AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Almacenes 
     LABEL "..." 
     SIZE 5 BY .81.

DEFINE BUTTON BUTTON-Filtro 
     LABEL "Aplicar Filtro" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Grupos 
     LABEL "..." 
     SIZE 5 BY .81.

DEFINE BUTTON BUTTON-Limpiar 
     LABEL "Limpiar Filtro" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Stop-It 
     IMAGE-UP FILE "img/pvparar.ico":U
     LABEL "Button 1" 
     SIZE 4 BY .81.

DEFINE BUTTON BUTTON-Texto 
     IMAGE-UP FILE "img/b-buscar.ico":U
     LABEL "Button 11" 
     SIZE 4 BY .96.

DEFINE VARIABLE COMBO-BOX_CodFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Linea" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Todas","Todas"
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_SubFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "SubLineas" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Todas","Todas"
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE EDITOR-Texto AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 34 BY 1.54 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodAlm AS CHARACTER FORMAT "x(256)" 
     LABEL "Almacén" 
     VIEW-AS FILL-IN 
     SIZE 64 BY .81
     BGCOLOR 14 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_CodMat AS CHARACTER FORMAT "X(6)" 
     LABEL "Codigo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_DesMar AS CHARACTER FORMAT "X(30)" 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 22.86 BY .81.

DEFINE VARIABLE FILL-IN_DesMat AS CHARACTER FORMAT "X(100)" 
     LABEL "Descripción" 
     VIEW-AS FILL-IN 
     SIZE 72.86 BY .81.

DEFINE VARIABLE FILL-IN_Grupos AS CHARACTER FORMAT "X(256)":U 
     LABEL "Grupo" 
     VIEW-AS FILL-IN 
     SIZE 64 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 132 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_NomPro AS CHARACTER FORMAT "x(100)" 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 72.86 BY .81.

DEFINE VARIABLE x-DesMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 64 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET_TpoArt AS CHARACTER INITIAL "A" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Activado", "A",
"Desactivado", "D",
"Todos", ""
     SIZE 32 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 141 BY 2.42
     BGCOLOR 15 FGCOLOR 0 .

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 6 GRAPHIC-EDGE  NO-FILL   
     SIZE 141 BY 1.35.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET_TpoArt AT ROW 1.27 COL 11 NO-LABEL WIDGET-ID 18
     BUTTON-Filtro AT ROW 1.27 COL 101 WIDGET-ID 22
     BUTTON-Limpiar AT ROW 1.27 COL 116 WIDGET-ID 48
     FILL-IN_CodMat AT ROW 2.08 COL 9 COLON-ALIGNED WIDGET-ID 6
     x-DesMat AT ROW 2.08 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     FILL-IN_DesMat AT ROW 2.88 COL 9 COLON-ALIGNED HELP
          "Descripción del material" WIDGET-ID 10
     COMBO-BOX_CodFam AT ROW 2.88 COL 99 COLON-ALIGNED WIDGET-ID 30
     FILL-IN_DesMar AT ROW 3.69 COL 9 COLON-ALIGNED WIDGET-ID 8
     COMBO-BOX_SubFam AT ROW 3.69 COL 99 COLON-ALIGNED WIDGET-ID 32
     FILL-IN_NomPro AT ROW 4.5 COL 9 COLON-ALIGNED HELP
          "Nombre del Proveedor" WIDGET-ID 14
     EDITOR-Texto AT ROW 4.77 COL 101 NO-LABEL WIDGET-ID 42
     BUTTON-Texto AT ROW 4.77 COL 137 WIDGET-ID 40
     FILL-IN_Grupos AT ROW 5.31 COL 9 COLON-ALIGNED WIDGET-ID 24
     BUTTON-Grupos AT ROW 5.31 COL 75 WIDGET-ID 26
     FILL-IN_CodAlm AT ROW 6.12 COL 9 COLON-ALIGNED WIDGET-ID 2
     BUTTON-Almacenes AT ROW 6.12 COL 75 WIDGET-ID 28
     BUTTON-Stop-It AT ROW 25.77 COL 4 WIDGET-ID 68
     FILL-IN_Mensaje AT ROW 25.77 COL 7 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     "Leyenda:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 23.35 COL 3 WIDGET-ID 60
          BGCOLOR 15 FGCOLOR 0 
     "Desde Texto:" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 4.77 COL 91 WIDGET-ID 46
     "Proy. C = Promedio desde Enero a Marzo (año pasado)" VIEW-AS TEXT
          SIZE 39 BY .5 AT ROW 23.62 COL 11 WIDGET-ID 52
          BGCOLOR 15 FGCOLOR 0 
     "Proy. NC = Promedio desde Abril hasta el mes pasado (año actual)" VIEW-AS TEXT
          SIZE 48 BY .5 AT ROW 24.15 COL 11 WIDGET-ID 54
          BGCOLOR 15 FGCOLOR 0 
     "Prom. NC = Promedio meses No Campaña Abril a Setiembre (año pasado)" VIEW-AS TEXT
          SIZE 51 BY .5 AT ROW 24.69 COL 11 WIDGET-ID 56
          BGCOLOR 15 FGCOLOR 0 
     "y mes actual hasta Setiembre (año pasado)" VIEW-AS TEXT
          SIZE 48 BY .5 AT ROW 24.15 COL 59 WIDGET-ID 58
          BGCOLOR 15 FGCOLOR 0 
     RECT-61 AT ROW 25.5 COL 2 WIDGET-ID 64
     RECT-1 AT ROW 23.08 COL 2 WIDGET-ID 62
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.29 BY 25.88
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-ALMVTA T "NEW SHARED" NO-UNDO INTEGRAL almacen_ventas
      TABLE: t-report T "NEW SHARED" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ALMACENES VS VENTAS"
         HEIGHT             = 25.88
         WIDTH              = 144.29
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

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON BUTTON-Stop-It IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-Stop-It:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR EDITOR EDITOR-Texto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Grupos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ALMACENES VS VENTAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ALMACENES VS VENTAS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Almacenes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Almacenes W-Win
ON CHOOSE OF BUTTON-Almacenes IN FRAME F-Main /* ... */
DO:
  DEF VAR pAlmacenes AS CHAR NO-UNDO.

  RUN gn/d-alm-por-zona-geogr (INPUT FILL-IN_Grupos:SCREEN-VALUE, OUTPUT pAlmacenes).
  IF pAlmacenes > '' THEN FILL-IN_CodAlm:SCREEN-VALUE = pAlmacenes.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Filtro W-Win
ON CHOOSE OF BUTTON-Filtro IN FRAME F-Main /* Aplicar Filtro */
DO:
  ASSIGN
      COMBO-BOX_CodFam 
      COMBO-BOX_SubFam 
      EDITOR-Texto 
      FILL-IN_CodAlm 
      FILL-IN_CodMat 
      FILL-IN_DesMar 
      FILL-IN_DesMat 
      FILL-IN_Grupos 
      FILL-IN_NomPro 
      RADIO-SET_TpoArt
      .
  /*SESSION:SET-WAIT-STATE('GENERAL').*/
  RUN Carga-Temporal.
  /*SESSION:SET-WAIT-STATE('').*/
  RUN dispatch IN h_b-almacen-ventas-mat ('open-query':U).
  RUN dispatch IN h_b-almacen-ventas-res ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Grupos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Grupos W-Win
ON CHOOSE OF BUTTON-Grupos IN FRAME F-Main /* ... */
DO:
  DEF VAR pGrupos AS CHAR NO-UNDO.

  RUN gn/d-zona-geogr-abast (OUTPUT pGrupos).
  IF pGrupos > '' THEN ASSIGN FILL-IN_Grupos:SCREEN-VALUE = pGrupos FILL-IN_CodAlm:SCREEN-VALUE = ''.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Limpiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Limpiar W-Win
ON CHOOSE OF BUTTON-Limpiar IN FRAME F-Main /* Limpiar Filtro */
DO:
  ASSIGN
      COMBO-BOX_CodFam = 'Todas'
      COMBO-BOX_SubFam = 'Todas'
      EDITOR-Texto = ''
      FILL-IN_CodAlm = ''
      FILL-IN_CodMat = ''
      FILL-IN_DesMar = ''
      FILL-IN_DesMat = ''
      FILL-IN_Grupos = ''
      FILL-IN_NomPro = ''
      RADIO-SET_TpoArt = 'A'
      x-DesMat = ''
      .
  DISPLAY
      COMBO-BOX_CodFam COMBO-BOX_SubFam 
      EDITOR-Texto 
      FILL-IN_CodAlm FILL-IN_CodMat FILL-IN_DesMar FILL-IN_DesMat 
      FILL-IN_Grupos FILL-IN_NomPro RADIO-SET_TpoArt
      x-DesMat
      WITH FRAME {&FRAME-NAME}.
  EMPTY TEMP-TABLE T-ALMVTA.
  EMPTY TEMP-TABLE t-report.
  RUN dispatch IN h_b-almacen-ventas-mat ('open-query':U).
  RUN dispatch IN h_b-almacen-ventas-res ('open-query':U).
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


&Scoped-define SELF-NAME BUTTON-Texto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Texto W-Win
ON CHOOSE OF BUTTON-Texto IN FRAME F-Main /* Button 11 */
DO:
  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR rpta AS LOG NO-UNDO.

  SYSTEM-DIALOG GET-FILE x-Archivo
      MUST-EXIST
      TITLE "Seleccione el archivo con los artículos"
      UPDATE rpta.
  IF rpta = NO THEN RETURN NO-APPLY.
  EDITOR-Texto:SCREEN-VALUE = x-Archivo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_CodFam W-Win
ON VALUE-CHANGED OF COMBO-BOX_CodFam IN FRAME F-Main /* Linea */
DO:
    DEF VAR lOk AS LOG NO-UNDO.
    ASSIGN {&self-name}.
    /* Carga Sublineas */
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN lOk = COMBO-BOX_SubFam:DELETE(COMBO-BOX_SubFam:LIST-ITEM-PAIRS) NO-ERROR.
        COMBO-BOX_SubFam:ADD-LAST('Todas','Todas').
        FOR EACH Almsfami NO-LOCK WHERE Almsfami.codcia = s-codcia AND Almsfami.codfam = COMBO-BOX_CodFam:
            COMBO-BOX_SubFam:ADD-LAST( AlmSFami.subfam + ' ' + AlmSFam.dessub, AlmSFami.subfam).
        END.
        COMBO-BOX_SubFam:SCREEN-VALUE = 'Todas'.
        APPLY 'VALUE-CHANGED':U TO COMBO-BOX_SubFam.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_SubFam W-Win
ON VALUE-CHANGED OF COMBO-BOX_SubFam IN FRAME F-Main /* SubLineas */
DO:
    ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodMat W-Win
ON LEAVE OF FILL-IN_CodMat IN FRAME F-Main /* Codigo */
DO:
    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).
    SELF:SCREEN-VALUE = pCodMat.
    x-DesMat:SCREEN-VALUE = ''.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = pCodMat
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN x-DesMat:SCREEN-VALUE = Almmmatg.desmat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/b-almacen-ventas-mat.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-almacen-ventas-mat ).
       RUN set-position IN h_b-almacen-ventas-mat ( 7.19 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-almacen-ventas-mat ( 9.96 , 141.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/b-almacen-ventas-res.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-almacen-ventas-res ).
       RUN set-position IN h_b-almacen-ventas-res ( 17.42 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-almacen-ventas-res ( 5.38 , 141.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-almacen-ventas-res. */
       RUN add-link IN adm-broker-hdl ( h_b-almacen-ventas-mat , 'Record':U , h_b-almacen-ventas-res ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-almacen-ventas-mat ,
             BUTTON-Almacenes:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-almacen-ventas-res ,
             h_b-almacen-ventas-mat , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-ALMVTA.
EMPTY TEMP-TABLE t-report.

/* Determinamos los almacenes a trabajar */
DEF VAR x-Almacenes AS CHAR NO-UNDO.

IF FILL-IN_Grupos > '' THEN DO:
    IF FILL-IN_CodAlm > '' THEN x-Almacenes = FILL-IN_CodAlm.
    ELSE DO:
        FOR EACH TabGener NO-LOCK WHERE TabGener.CodCia = s-codcia 
            AND TabGener.Clave = "ZG" 
            AND LOOKUP(TabGener.Codigo, FILL-IN_Grupos) > 0,
            FIRST almtabla WHERE almtabla.Tabla = TabGener.Clave
            AND almtabla.Codigo = TabGener.Codigo NO-LOCK:
            x-Almacenes = x-Almacenes + (IF TRUE <> (x-Almacenes > '') THEN '' ELSE ',')
                + TabGener.Libre_c01.
        END.
    END.
END.
ELSE DO:
    IF FILL-IN_CodAlm > '' THEN x-Almacenes = FILL-IN_CodAlm.
    ELSE DO:
        FOR EACH TabGener NO-LOCK WHERE TabGener.CodCia = s-codcia 
            AND TabGener.Clave = "ZG",
            FIRST almtabla WHERE almtabla.Tabla = TabGener.Clave
            AND almtabla.Codigo = TabGener.Codigo NO-LOCK:
            x-Almacenes = x-Almacenes + (IF TRUE <> (x-Almacenes > '') THEN '' ELSE ',')
                + TabGener.Libre_c01.
        END.
    END.
END.
/* 2 Casos: De un archivo Texto o Por Filtros */
Stop-It = FALSE.
BUTTON-Stop-It:VISIBLE IN FRAME {&FRAME-NAME} = YES.
BUTTON-Stop-It:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

IF EDITOR-Texto > '' THEN DO:
    FILE-INFO:FILE-NAME = EDITOR-Texto.
    IF FILE-INFO:FILE-NAME = ? THEN DO:
        MESSAGE 'Error en el archivo texto' VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
    DEF VAR x-Linea AS CHAR NO-UNDO.
    INPUT FROM VALUE(EDITOR-Texto).
    RLOOP:
    REPEAT:
        IMPORT UNFORMATTED x-Linea.
        IF x-Linea = '' THEN LEAVE.
        FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
            AND Almmmatg.codmat = x-Linea
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg THEN NEXT.
        /* Acumulamos ventas */
        FILL-IN_Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Código: ' + Almmmatg.codmat + ' ' + Almmmatg.desmat.
        FOR EACH almacen_ventas WHERE almacen_ventas.CodCia = s-codcia 
            AND almacen_ventas.CodMat = x-Linea
            AND (FILL-IN_Grupos = '' OR LOOKUP(almacen_ventas.Grupo, FILL-IN_Grupos) > 0)
            AND (FILL-IN_CodAlm = '' OR LOOKUP(almacen_ventas.CodAlm, FILL-IN_CodAlm) > 0)
            NO-LOCK:
            FIND T-ALMVTA WHERE T-ALMVTA.CodCia = almacen_ventas.CodCia 
                AND T-ALMVTA.CodMat = almacen_ventas.CodMat
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE T-ALMVTA THEN CREATE T-ALMVTA.
            BUFFER-COPY almacen_ventas TO T-ALMVTA.
            FIND t-report WHERE t-report.Llave-C = almacen_ventas.CodMat
                AND t-report.Llave-I = almacen_ventas.Periodo
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE t-report THEN CREATE t-report.
            ASSIGN
                t-report.Llave-C = almacen_ventas.CodMat
                t-report.Llave-I = almacen_ventas.Periodo.
            /* acumulados */
            ASSIGN
                t-report.Campo-F[1] = t-report.Campo-F[1] + almacen_ventas.Cantidad[1] 
                t-report.Campo-F[2] = t-report.Campo-F[2] + almacen_ventas.Cantidad[2] 
                t-report.Campo-F[3] = t-report.Campo-F[3] + almacen_ventas.Cantidad[3] 
                t-report.Campo-F[4] = t-report.Campo-F[4] + almacen_ventas.Cantidad[4] 
                t-report.Campo-F[5] = t-report.Campo-F[5] + almacen_ventas.Cantidad[5] 
                t-report.Campo-F[6] = t-report.Campo-F[6] + almacen_ventas.Cantidad[6] 
                t-report.Campo-F[7] = t-report.Campo-F[7] + almacen_ventas.Cantidad[7] 
                t-report.Campo-F[8] = t-report.Campo-F[8] + almacen_ventas.Cantidad[8] 
                t-report.Campo-F[9] = t-report.Campo-F[9] + almacen_ventas.Cantidad[9] 
                t-report.Campo-F[10] = t-report.Campo-F[10] + almacen_ventas.Cantidad[10] 
                t-report.Campo-F[11] = t-report.Campo-F[11] + almacen_ventas.Cantidad[11] 
                t-report.Campo-F[12] = t-report.Campo-F[12] + almacen_ventas.Cantidad[12] 
                .
            PROCESS EVENTS.
            IF Stop-It = YES THEN LEAVE RLOOP.
        END.
    END.
    INPUT CLOSE.
END.
ELSE DO:
    /* Acumulamos ventas */
    RLOOP:
    FOR EACH almacen_ventas WHERE almacen_ventas.CodCia = s-codcia 
        AND (FILL-IN_CodMat = '' OR almacen_ventas.CodMat = FILL-IN_CodMat)
        AND (RADIO-SET_TpoArt = '' OR almacen_ventas.TpoArt = RADIO-SET_TpoArt)
        AND (FILL-IN_DesMat = '' OR almacen_ventas.DesMat CONTAINS FILL-IN_DesMat)
        AND (FILL-IN_DesMar = '' OR almacen_ventas.DesMar CONTAINS FILL-IN_DesMar)
        AND (FILL-IN_NomPro = '' OR almacen_ventas.NomPro CONTAINS FILL-IN_NomPro)
        AND (COMBO-BOX_CodFam = 'Todas' OR almacen_ventas.CodFam = COMBO-BOX_CodFam)
        AND (COMBO-BOX_SubFam = 'Todas' OR almacen_ventas.SubFam = COMBO-BOX_SubFam)
        AND (FILL-IN_Grupos = '' OR LOOKUP(almacen_ventas.Grupo, FILL-IN_Grupos) > 0)
        AND (FILL-IN_CodAlm = '' OR LOOKUP(almacen_ventas.CodAlm, FILL-IN_CodAlm) > 0)
        NO-LOCK:
        FILL-IN_Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Código: ' + almacen_ventas.codmat + ' ' + almacen_ventas.desmat.
        FIND T-ALMVTA WHERE T-ALMVTA.CodCia = almacen_ventas.CodCia 
            AND T-ALMVTA.CodMat = almacen_ventas.CodMat
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE T-ALMVTA THEN CREATE T-ALMVTA.
        BUFFER-COPY almacen_ventas TO T-ALMVTA.
        FIND t-report WHERE t-report.Llave-C = almacen_ventas.CodMat
            AND t-report.Llave-I = almacen_ventas.Periodo
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE t-report THEN CREATE t-report.
        ASSIGN
            t-report.Llave-C = almacen_ventas.CodMat
            t-report.Llave-I = almacen_ventas.Periodo.
        /* acumulados */
        ASSIGN
            t-report.Campo-F[1] = t-report.Campo-F[1] + almacen_ventas.Cantidad[1] 
            t-report.Campo-F[2] = t-report.Campo-F[2] + almacen_ventas.Cantidad[2] 
            t-report.Campo-F[3] = t-report.Campo-F[3] + almacen_ventas.Cantidad[3] 
            t-report.Campo-F[4] = t-report.Campo-F[4] + almacen_ventas.Cantidad[4] 
            t-report.Campo-F[5] = t-report.Campo-F[5] + almacen_ventas.Cantidad[5] 
            t-report.Campo-F[6] = t-report.Campo-F[6] + almacen_ventas.Cantidad[6] 
            t-report.Campo-F[7] = t-report.Campo-F[7] + almacen_ventas.Cantidad[7] 
            t-report.Campo-F[8] = t-report.Campo-F[8] + almacen_ventas.Cantidad[8] 
            t-report.Campo-F[9] = t-report.Campo-F[9] + almacen_ventas.Cantidad[9] 
            t-report.Campo-F[10] = t-report.Campo-F[10] + almacen_ventas.Cantidad[10] 
            t-report.Campo-F[11] = t-report.Campo-F[11] + almacen_ventas.Cantidad[11] 
            t-report.Campo-F[12] = t-report.Campo-F[12] + almacen_ventas.Cantidad[12] 
            .
        PROCESS EVENTS.
        IF Stop-It = YES THEN LEAVE RLOOP.
    END.
END.
/* Stocks Máximos */
FOR EACH T-ALMVTA:
    FILL-IN_Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Stock Máximo Código: ' + T-ALMVTA.codmat + ' ' + T-ALMVTA.desmat.
    FOR EACH Almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia
        AND (x-Almacenes = '' OR LOOKUP(Almmmate.codalm, x-Almacenes) > 0)
        AND Almmmate.codmat = T-ALMVTA.codmat:
        ASSIGN
            T-ALMVTA.StkMaxCamp = T-ALMVTA.StkMaxCamp + Almmmate.VCtMn1
            T-ALMVTA.StkMaxNoCamp = T-ALMVTA.StkMaxNoCamp + Almmmate.VCtMn2.
    END.
END.
/* Redondeo */
FOR EACH t-report:
    ASSIGN
        t-report.Campo-F[1] = ROUND(t-report.Campo-F[1],0)
        t-report.Campo-F[2] = ROUND(t-report.Campo-F[2],0)
        t-report.Campo-F[3] = ROUND(t-report.Campo-F[3],0)
        t-report.Campo-F[4] = ROUND(t-report.Campo-F[4],0)
        t-report.Campo-F[5] = ROUND(t-report.Campo-F[5],0)
        t-report.Campo-F[6] = ROUND(t-report.Campo-F[6],0)
        t-report.Campo-F[7] = ROUND(t-report.Campo-F[7],0)
        t-report.Campo-F[8] = ROUND(t-report.Campo-F[8],0)
        t-report.Campo-F[9] = ROUND(t-report.Campo-F[9],0)
        t-report.Campo-F[10] = ROUND(t-report.Campo-F[10],0)
        t-report.Campo-F[11] = ROUND(t-report.Campo-F[11],0)
        t-report.Campo-F[12] = ROUND(t-report.Campo-F[12],0)
        .
END.
/* Datos calculados */
DEF VAR k AS INT NO-UNDO.
DEF VAR x-Mes AS INT NO-UNDO.
DEF VAR x-ProyC  AS INT NO-UNDO.
DEF VAR x-ProyNC AS INT NO-UNDO.
DEF VAR x-PromNC AS INT NO-UNDO.

x-Mes = MONTH(TODAY).
FOR EACH t-report BREAK BY t-report.Llave-C BY t-report.Llave-I DESC:
    FILL-IN_Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Cáculos Finales Código: ' + t-report.Llave-C.
    IF FIRST-OF(t-report.Llave-C) OR FIRST-OF(t-report.Llave-I) THEN DO:
        x-ProyC  = 0.
        x-ProyNC = 0.
        x-PromNC = 0.
    END.
    DO k = 4 TO (x-Mes - 1):
        t-report.Campo-F[14] = t-report.Campo-F[14] + t-report.Campo-F[k].
        x-ProyNC = x-ProyNC + 1.
    END.
    FOR EACH bt-report WHERE bt-report.Llave-C = t-report.Llave-C
        AND bt-report.Llave-I = (t-report.Llave-I - 1) NO-LOCK:
        DO k = 1 TO 3:
            t-report.Campo-F[13] = t-report.Campo-F[13] + bt-report.Campo-F[k].
            x-ProyC = x-ProyC + 1.
        END.
        DO k = x-Mes TO 9:
            t-report.Campo-F[14] = t-report.Campo-F[14] + bt-report.Campo-F[k].
            x-ProyNC = x-ProyNC + 1.
        END.
        DO k = 4 TO 9:
            t-report.Campo-F[15] = t-report.Campo-F[15] + bt-report.Campo-F[k].
            x-PromNC = x-PromNC + 1.
        END.
    END.
    IF LAST-OF(t-report.Llave-C) OR LAST-OF(t-report.Llave-I) THEN DO:
        IF x-ProyC > 0  THEN t-report.Campo-F[13] = t-report.Campo-F[13] / x-ProyC.
        IF x-ProyNC > 0 THEN t-report.Campo-F[14] = t-report.Campo-F[14] / x-ProyNC.
        IF x-PromNC > 0 THEN t-report.Campo-F[15] = t-report.Campo-F[15] / x-PromNC.
    END.
END.
FILL-IN_Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
BUTTON-Stop-It:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
BUTTON-Stop-It:VISIBLE IN FRAME {&FRAME-NAME} = NO.

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
  DISPLAY RADIO-SET_TpoArt FILL-IN_CodMat x-DesMat FILL-IN_DesMat 
          COMBO-BOX_CodFam FILL-IN_DesMar COMBO-BOX_SubFam FILL-IN_NomPro 
          EDITOR-Texto FILL-IN_Grupos FILL-IN_CodAlm FILL-IN_Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-61 RECT-1 RADIO-SET_TpoArt BUTTON-Filtro BUTTON-Limpiar 
         FILL-IN_CodMat FILL-IN_DesMat COMBO-BOX_CodFam FILL-IN_DesMar 
         COMBO-BOX_SubFam FILL-IN_NomPro BUTTON-Texto BUTTON-Grupos 
         BUTTON-Almacenes 
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
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          COMBO-BOX_CodFam:DELIMITER = '|'
          COMBO-BOX_SubFam:DELIMITER = '|'.
      FOR EACH Almtfami WHERE Almtfami.codcia = s-codcia:
          COMBO-BOX_CodFam:ADD-LAST(Almtfami.codfam + ' ' + Almtfami.desfam,Almtfami.codfam).

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

