&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE COTIZACION LIKE FacCPedi.
DEFINE TEMP-TABLE DETA NO-UNDO LIKE FacDPedi.
DEFINE NEW SHARED TEMP-TABLE DOCU LIKE CcbCDocu.



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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF NEW SHARED VAR lh_handle AS HANDLE.

DEFINE TEMP-TABLE RESUMEN
    FIELD CodFam LIKE Almmmatg.codfam
    FIELD SubFam LIKE Almmmatg.subfam
    FIELD ImpLin LIKE Facdpedi.implin.

DEF VAR x-Control-COT AS CHAR NO-UNDO.  /* Control de COT procesadas */

DEF VAR s-Tabla AS CHAR INIT 'PLTJULIO' NO-UNDO.
&SCOPED-DEFINE Condicion (VtaCTabla.CodCia = s-codcia AND VtaCTabla.Tabla = s-Tabla)

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-CDOCU

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES COTIZACION

/* Definitions for BROWSE BROWSE-CDOCU                                  */
&Scoped-define FIELDS-IN-QUERY-BROWSE-CDOCU COTIZACION.CodDoc ~
COTIZACION.NroPed COTIZACION.FchPed COTIZACION.FmaPgo COTIZACION.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-CDOCU 
&Scoped-define QUERY-STRING-BROWSE-CDOCU FOR EACH COTIZACION NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-CDOCU OPEN QUERY BROWSE-CDOCU FOR EACH COTIZACION NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-CDOCU COTIZACION
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-CDOCU COTIZACION


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-CDOCU}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN_CodCli FILL-IN-Desde BUTTON-1 ~
FILL-IN-Hasta BUTTON-2 BROWSE-CDOCU BUTTON-Refrescar BUTTON-Limpiar BtnDone ~
BUTTON-Sube BUTTON-Sube-2 BUTTON-Generar 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_CodCli FILL-IN_NomCli ~
FILL-IN-Desde FILL-IN-Hasta FILL-IN_ImpTot FILL-IN_Cumplimiento ~
COMBO-BOX_Zona EDITOR-Cotizaciones FILL-IN_ImpProyectado 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-updv14 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-gen-preletra-julio AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 7 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/calendar.bmp":U
     LABEL "Button 1" 
     SIZE 4 BY 1.08.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/calendar.bmp":U
     LABEL "Button 2" 
     SIZE 4 BY 1.08.

DEFINE BUTTON BUTTON-Generar 
     LABEL "GENERAR PRE-LETRAS" 
     SIZE 31 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON-Limpiar 
     LABEL "LIMPIAR TODO" 
     SIZE 21 BY 1.08.

DEFINE BUTTON BUTTON-Refrescar 
     LABEL "CARGA TEMPORALES" 
     SIZE 21 BY 1.08 TOOLTIP "REFRESCAR".

DEFINE BUTTON BUTTON-Sube 
     IMAGE-UP FILE "img/down.ico":U
     LABEL ">" 
     SIZE 6 BY 1.54 TOOLTIP "Incluir seleccionados"
     FONT 8.

DEFINE BUTTON BUTTON-Sube-2 
     IMAGE-UP FILE "img/downblue.bmp":U
     LABEL ">>" 
     SIZE 6 BY 1.54 TOOLTIP "Incluir todos"
     FONT 8.

DEFINE VARIABLE COMBO-BOX_Zona AS CHARACTER FORMAT "X(256)":U 
     LABEL "Zona" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "LIMA","LMC",
                     "ORIENTE","COR",
                     "NORTE","NOR",
                     "SUR","SUR"
     DROP-DOWN-LIST
     SIZE 30 BY 1 NO-UNDO.

DEFINE VARIABLE EDITOR-Cotizaciones AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 30 BY 4
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidas desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Cumplimiento AS DECIMAL FORMAT ">>9.99":U INITIAL 100 
     LABEL "% de Cumplimiento" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpProyectado AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Importe de Cumplimiento" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpTot AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Total" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-CDOCU FOR 
      COTIZACION SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-CDOCU
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-CDOCU W-Win _STRUCTURED
  QUERY BROWSE-CDOCU NO-LOCK DISPLAY
      COTIZACION.CodDoc COLUMN-LABEL "Doc" FORMAT "x(3)":U WIDTH 4.43
      COTIZACION.NroPed COLUMN-LABEL "Número" FORMAT "X(12)":U
            WIDTH 9.43
      COTIZACION.FchPed COLUMN-LABEL "Fecha Emisión" FORMAT "99/99/9999":U
      COTIZACION.FmaPgo COLUMN-LABEL "Condición de venta" FORMAT "X(8)":U
            WIDTH 13.43
      COTIZACION.ImpTot FORMAT "->>,>>>,>>9.99":U WIDTH 11.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 54 BY 4.5
         FONT 4 ROW-HEIGHT-CHARS .46 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN_CodCli AT ROW 1.27 COL 13 COLON-ALIGNED WIDGET-ID 2
     FILL-IN_NomCli AT ROW 1.27 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     FILL-IN-Desde AT ROW 2.35 COL 13 COLON-ALIGNED WIDGET-ID 8
     BUTTON-1 AT ROW 2.35 COL 27 WIDGET-ID 50
     FILL-IN-Hasta AT ROW 2.35 COL 37 COLON-ALIGNED WIDGET-ID 10
     BUTTON-2 AT ROW 2.35 COL 51 WIDGET-ID 54
     BROWSE-CDOCU AT ROW 3.69 COL 3 WIDGET-ID 200
     BUTTON-Refrescar AT ROW 4.23 COL 58 WIDGET-ID 56
     BUTTON-Limpiar AT ROW 5.31 COL 58 WIDGET-ID 66
     BtnDone AT ROW 6.38 COL 58 WIDGET-ID 28
     FILL-IN_ImpTot AT ROW 8.27 COL 41 COLON-ALIGNED WIDGET-ID 62
     BUTTON-Sube AT ROW 9.08 COL 3 WIDGET-ID 58
     BUTTON-Sube-2 AT ROW 9.08 COL 9 WIDGET-ID 18
     FILL-IN_Cumplimiento AT ROW 9.08 COL 28 COLON-ALIGNED WIDGET-ID 6
     COMBO-BOX_Zona AT ROW 9.88 COL 28 COLON-ALIGNED WIDGET-ID 4
     BUTTON-Generar AT ROW 17.15 COL 46 WIDGET-ID 60
     EDITOR-Cotizaciones AT ROW 19.04 COL 46 NO-LABEL WIDGET-ID 68
     FILL-IN_ImpProyectado AT ROW 23.08 COL 62 COLON-ALIGNED WIDGET-ID 72
     "Cotizaciones:" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 18.5 COL 46 WIDGET-ID 70
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 84 BY 24.73
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: COTIZACION T "NEW SHARED" ? INTEGRAL FacCPedi
      TABLE: DETA T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: DOCU T "NEW SHARED" ? INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "GENERACION DE PRE-LETRAS CAMPAÑA - JULIO"
         HEIGHT             = 24.73
         WIDTH              = 84
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
/* BROWSE-TAB BROWSE-CDOCU BUTTON-2 F-Main */
/* SETTINGS FOR COMBO-BOX COMBO-BOX_Zona IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR EDITOR-Cotizaciones IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Cumplimiento IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpProyectado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-CDOCU
/* Query rebuild information for BROWSE BROWSE-CDOCU
     _TblList          = "Temp-Tables.COTIZACION"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.COTIZACION.CodDoc
"COTIZACION.CodDoc" "Doc" ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.COTIZACION.NroPed
"COTIZACION.NroPed" "Número" ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.COTIZACION.FchPed
"COTIZACION.FchPed" "Fecha Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.COTIZACION.FmaPgo
"COTIZACION.FmaPgo" "Condición de venta" ? "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.COTIZACION.ImpTot
"COTIZACION.ImpTot" ? ? "decimal" ? ? ? ? ? ? no ? no no "11.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-CDOCU */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* GENERACION DE PRE-LETRAS CAMPAÑA - JULIO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* GENERACION DE PRE-LETRAS CAMPAÑA - JULIO */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  RUN src/bin/_calenda.
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
  DISPLAY RETURN-VALUE @ FILL-IN-Desde WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
    RUN src/bin/_calenda.
    IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
    DISPLAY RETURN-VALUE @ FILL-IN-Hasta WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Generar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Generar W-Win
ON CHOOSE OF BUTTON-Generar IN FRAME F-Main /* GENERAR PRE-LETRAS */
DO:
   RUN Genera-PreLetra.
   IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
   APPLY 'CHOOSE':U TO BUTTON-Limpiar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Limpiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Limpiar W-Win
ON CHOOSE OF BUTTON-Limpiar IN FRAME F-Main /* LIMPIAR TODO */
DO:
  CLEAR FRAME {&FRAME-NAME} ALL.
  
  RUN dispatch IN THIS-PROCEDURE ('initialize':U).
  EMPTY TEMP-TABLE COTIZACION.
  EMPTY TEMP-TABLE DOCU.
  {&OPEN-QUERY-BROWSE-CDOCU}
  RUN dispatch IN h_t-gen-preletra-julio ('open-query':U).
  RUN Totales.
  DISPLAY 80 @  FILL-IN_Cumplimiento WITH FRAME {&FRAME-NAME}.
  ASSIGN
      BUTTON-1:SENSITIVE = YES
      BUTTON-2:SENSITIVE = YES
      FILL-IN_CodCli:SENSITIVE = YES
      FILL-IN-Desde:SENSITIVE = YES
      FILL-IN-Hasta:SENSITIVE = YES
      EDITOR-Cotizaciones:SCREEN-VALUE IN FRAME {&FRAME-NAME}= ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Refrescar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Refrescar W-Win
ON CHOOSE OF BUTTON-Refrescar IN FRAME F-Main /* CARGA TEMPORALES */
DO:
  ASSIGN
      COMBO-BOX_Zona FILL-IN_CodCli FILL-IN_Cumplimiento
      FILL-IN-Desde FILL-IN-Hasta.
  IF FILL-IN-Desde = ? THEN FILL-IN-Desde = TODAY.
  IF FILL-IN-Hasta = ? THEN FILL-IN-Hasta = TODAY + 1.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporales.
  SESSION:SET-WAIT-STATE('').
  /*MESSAGE 'Carga Exitosa' VIEW-AS ALERT-BOX INFORMATION.*/
  {&OPEN-QUERY-BROWSE-CDOCU}
  RUN dispatch IN h_t-gen-preletra-julio ('open-query':U).
  RUN Totales.
  ASSIGN
      BUTTON-1:SENSITIVE = NO
      BUTTON-2:SENSITIVE = NO
      FILL-IN_CodCli:SENSITIVE = NO
      FILL-IN-Desde:SENSITIVE = NO
      FILL-IN-Hasta:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Sube
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Sube W-Win
ON CHOOSE OF BUTTON-Sube IN FRAME F-Main /* > */
DO:
    ASSIGN COMBO-BOX_Zona FILL-IN_Cumplimiento.
    RUN Pr-Sube.
    RUN dispatch IN h_t-gen-preletra-julio ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Sube-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Sube-2 W-Win
ON CHOOSE OF BUTTON-Sube-2 IN FRAME F-Main /* >> */
DO:
    ASSIGN COMBO-BOX_Zona FILL-IN_Cumplimiento.
    RUN Pr-Sube-2.
    RUN dispatch IN h_t-gen-preletra-julio ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodCli W-Win
ON LEAVE OF FILL-IN_CodCli IN FRAME F-Main /* Cliente */
DO:
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie THEN DO:
      FILL-IN_NomCli:SCREEN-VALUE = gn-clie.nomcli.
      /* Buscamos ZONA del cliente */
      FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
      IF AVAILABLE TabDepto THEN DO:
          COMBO-BOX_Zona:SCREEN-VALUE = TabDepto.Zona.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-CDOCU
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
             INPUT  'ccb/t-gen-preletra-julio.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-gen-preletra-julio ).
       RUN set-position IN h_t-gen-preletra-julio ( 10.96 , 3.00 ) NO-ERROR.
       RUN set-size IN h_t-gen-preletra-julio ( 14.00 , 42.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv14.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv14 ).
       RUN set-position IN h_p-updv14 ( 11.77 , 46.00 ) NO-ERROR.
       RUN set-size IN h_p-updv14 ( 5.38 , 10.00 ) NO-ERROR.

       /* Links to SmartBrowser h_t-gen-preletra-julio. */
       RUN add-link IN adm-broker-hdl ( h_p-updv14 , 'TableIO':U , h_t-gen-preletra-julio ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-gen-preletra-julio ,
             COMBO-BOX_Zona:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv14 ,
             h_t-gen-preletra-julio , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Letras W-Win 
PROCEDURE Carga-Letras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pZona  AS CHAR.
DEF INPUT PARAMETER pLinea AS CHAR.
DEF INPUT PARAMETER pSubLinea AS CHAR.
DEF INPUT PARAMETER pImpTot AS DEC.
DEF INPUT PARAMETER pNroSer AS INT.
DEF INPUT-OUTPUT PARAMETER pNroDoc AS INT.

DEF VAR fSaldo AS DEC NO-UNDO.
fSaldo = pImpTot.
/*pNroDoc = 0.*/
/* Existen 2 formas de calcular :
Por condicion de venta
Por Fechas de vencimiento
*/
FIND FIRST VtaCTabla WHERE {&Condicion} AND
    VtaCTabla.Libre_c01 = pLinea AND
    VtaCTabla.Libre_c02 = pSubLinea
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaCTabla THEN RETURN.
DEF VAR x-Vencto AS CHAR NO-UNDO.
DEF VAR F-NroLet AS INT NO-UNDO.
DEF VAR s-conta AS INT NO-UNDO.
DEF VAR F-LetIni AS INT NO-UNDO.
DEF VAR s-nrolet AS INT NO-UNDO.
DEF VAR s-implet AS DEC DECIMALS 2 NO-UNDO.
DEF VAR x-fchvto AS DATE NO-UNDO.

CASE VtaCTabla.Libre_c03:
    WHEN "CV" THEN DO:      /* Condicion de Venta */
        /* La condición de venta define cuantas letras se van a generar
            y las fechas de vencimiento se calculan a partir de la fecha de hoy
            */
        FIND gn-ConVt WHERE gn-ConVt.Codig = VtaCTabla.Libre_c04 NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-ConVt THEN RETURN.
        X-VENCTO = Gn-convt.Vencmtos.
        F-NroLet = NUM-ENTRIES(x-Vencto).
        ASSIGN
            s-conta = 1
            s-nrolet = pNroDoc
            s-implet = ROUND(pImpTot / F-NroLet , 2)
            x-fchvto = TODAY.
        DO s-conta = 1 TO F-NroLet:
            x-fchvto = TODAY + INTEGER(ENTRY(s-conta, X-Vencto)).
            CREATE DOCU.
            ASSIGN 
                DOCU.CodCia = s-codcia
                DOCU.CodDiv = s-coddiv
                DOCU.CodDoc = 'LET'
                DOCU.NroDoc = STRING(pNroSer, '999') + STRING(s-nrolet ,"999999")
                DOCU.Libre_c01 = pLinea
                DOCU.Libre_c02 = pSubLinea
                DOCU.FchDoc = TODAY
                DOCU.FchVto = x-fchvto
                DOCU.ImpTot = IF (s-conta = F-NroLet) THEN
                    (pImpTot - ((s-conta - 1) * s-implet))
                    ELSE s-implet. 
            s-nrolet = s-nrolet + 1.
        END.
        pNroDoc = s-NroLet.
    END.
    WHEN "FV" THEN DO:      /* Fechas de Vencimiento */
        FOR EACH VtaDTabla OF VtaCTabla NO-LOCK WHERE VtaDTabla.Libre_d01 > 0
            BREAK BY VtaDTabla.Llave BY VtaDTabla.Tipo:
            CREATE DOCU.
            ASSIGN 
                DOCU.CodCia = s-codcia
                DOCU.CodDiv = s-coddiv
                DOCU.CodDoc = 'LET'
                DOCU.NroDoc = STRING(pNroSer, '999') + STRING(pNroDoc ,"999999")
                DOCU.FchDoc = TODAY
                DOCU.FchVto = VtaDTabla.Libre_f01 
                DOCU.ImpTot = ROUND(pImpTot * VtaDTabla.Libre_d01 / 100, 2)
                DOCU.Libre_c01 = pLinea
                DOCU.Libre_c02 = pSubLinea.
            fSaldo = fSaldo - DOCU.ImpTot.
            pNroDoc = pNroDoc + 1.
            IF LAST-OF(VtaDTabla.Llave) THEN DO:
                DOCU.ImpTot = DOCU.ImpTot + fSaldo.
            END.
        END.
    END.
END CASE.

/*
FOR EACH VtaCTabla NO-LOCK WHERE VtaCTabla.CodCia = s-codcia AND 
    VtaCTabla.Tabla = "PLT" AND
    VtaCTabla.Libre_c01 = pLinea AND
    VtaCTabla.Libre_c02 = pZona,
    EACH VtaDTabla OF VtaCTabla NO-LOCK WHERE VtaDTabla.Libre_d01 > 0
    BREAK BY VtaDTabla.Llave BY VtaDTabla.Tipo:
    CREATE DOCU.
    ASSIGN 
        DOCU.CodCia = s-codcia
        DOCU.CodDiv = s-coddiv
        DOCU.CodDoc = 'LET'
        DOCU.NroDoc = STRING(pNroSer, '999') + STRING(pNroDoc ,"999999")
        DOCU.FchDoc = TODAY
        DOCU.FchVto = VtaDTabla.Libre_f01 
        DOCU.ImpTot = ROUND(pImpTot * VtaDTabla.Libre_d01 / 100, 2)
        DOCU.Libre_c01 = pZona
        DOCU.Libre_c02 = pLinea.
    fSaldo = fSaldo - DOCU.ImpTot.
    pNroDoc = pNroDoc + 1.
    IF LAST-OF(VtaDTabla.Llave) THEN DO:
        DOCU.ImpTot = DOCU.ImpTot + fSaldo.
    END.
END.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporales W-Win 
PROCEDURE Carga-Temporales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE COTIZACION.
EMPTY TEMP-TABLE DOCU.

FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
    AND Faccpedi.coddoc = 'COT'
    AND Faccpedi.codcli = FILL-IN_CodCli
    AND Faccpedi.fchped >= FILL-IN-Desde
    AND Faccpedi.fchped <= FILL-IN-Hasta
    AND Faccpedi.flgest <> 'A',
    FIRST gn-ConVt NO-LOCK WHERE gn-ConVt.Codig = Faccpedi.fmapgo
    AND gn-ConVt.Codig = "411"
    AND gn-ConVt.Libre_l02 = YES:       /* Por ejemplo la 411 */
    /* *********************************** */
    /* Verificamos que no esté en otra PLT */
    /* *********************************** */
    FIND FIRST CcbCMvto WHERE CcbCMvto.CodCia = s-codcia AND
        CcbCMvto.CodCli = FILL-IN_CodCli AND
        CcbCMvto.CodDoc = 'PLT' AND
        CcbCMvto.FlgEst <> 'A' AND
        LOOKUP(Faccpedi.NroPed, CcbCMvto.NroRef) > 0
        NO-LOCK NO-ERROR.
    IF AVAILABLE CcbCMvto THEN NEXT.
    /* *********************************** */
    CREATE COTIZACION.
    BUFFER-COPY Faccpedi TO COTIZACION.
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
  DISPLAY FILL-IN_CodCli FILL-IN_NomCli FILL-IN-Desde FILL-IN-Hasta 
          FILL-IN_ImpTot FILL-IN_Cumplimiento COMBO-BOX_Zona EDITOR-Cotizaciones 
          FILL-IN_ImpProyectado 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN_CodCli FILL-IN-Desde BUTTON-1 FILL-IN-Hasta BUTTON-2 
         BROWSE-CDOCU BUTTON-Refrescar BUTTON-Limpiar BtnDone BUTTON-Sube 
         BUTTON-Sube-2 BUTTON-Generar 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-PreLetra W-Win 
PROCEDURE Genera-PreLetra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Consistencia de Importes */
IF FILL-IN_ImpProyectado = 0 OR NOT CAN-FIND(FIRST DOCU NO-LOCK) THEN RETURN 'ADM-ERROR'.

DEF VAR x-ImpTot AS DEC NO-UNDO.

FOR EACH DOCU NO-LOCK:
    x-ImpTot = x-ImpTot + DOCU.ImpTot.
END.
IF x-ImpTot <> FILL-IN_ImpProyectado THEN DO:
    MESSAGE 'Hay un diferencia entre los importes de las letras y del cumplimiento' SKIP
        'Proceso Abortado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

DEF VAR s-CodDoc AS CHAR INIT 'PLT' NO-UNDO.    /* PRE-LETRA */
DEF VAR s-NroSer AS INT NO-UNDO.
DEF VAR x-NroDoc AS CHAR NO-UNDO.

FIND FIRST FacCorre WHERE FacCorre.CodCia = s-codcia AND
    FacCorre.CodDiv = s-coddiv AND
    FacCorre.CodDoc = s-coddoc AND
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE 'NO definido el correlativo para el documento:' s-coddoc
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
ASSIGN
    s-NroSer = FacCorre.NroSer.
FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
FIND gn-clie WHERE gn-clie.codcia = cl-codcia 
    AND gn-clie.codcli = FILL-IN_CodCli NO-LOCK NO-ERROR.
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}
    CREATE CcbCMvto.
    ASSIGN 
        CcbCMvto.CodCia = S-CODCIA
        CcbCMvto.CodDiv = S-CODDIV
        CcbCMvto.CodDoc = S-CODDOC
        CcbCMvto.FchDoc = TODAY
        CcbCMvto.FlgEst = "P"
        CcbCMvto.NroDoc = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        CcbCMvto.usuario = S-USER-ID
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
         RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
         UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        CcbCMvto.NroRef = x-Control-COT     /* OJO */
        CcbCMvto.CodCli = FILL-IN_CodCli
        CcbCMvto.Libre_chr[2] = gn-clie.Ruc
        /*CcbCMvto.Libre_chr[3] */
        CcbCMvto.CodMon = 1
        CcbCMvto.TpoCmb = FacCfgGn.Tpocmb[1].
    ASSIGN
      FacCorre.Correlativo = FacCorre.Correlativo + 1.
    ASSIGN 
        CcbCMvto.CodDpto = gn-clie.CodDept 
        CcbCMvto.CodProv = gn-clie.CodProv 
        CcbCMvto.CodDist = gn-clie.CodDist.
    FOR EACH DOCU:
        CREATE CcbDMvto.
        ASSIGN
            CcbDMvto.CodCia = Ccbcmvto.codcia
            CcbDMvto.CodCli = Ccbcmvto.codcli
            CcbDMvto.CodDiv = Ccbcmvto.coddiv
            CcbDMvto.CodDoc = Ccbcmvto.coddoc
            CcbDMvto.FchEmi = Ccbcmvto.fchdoc
            CcbDMvto.NroDoc = Ccbcmvto.nrodoc.
        ASSIGN
            CcbDMvto.CodRef = DOCU.CodDoc
            CcbDMvto.NroRef = DOCU.NroDoc
            CcbDMvto.FchVto = DOCU.FchVto
            CcbDMvto.TpoRef = "O"
            CcbDMvto.ImpTot = DOCU.ImpTot
            CcbDMvto.CodCta = DOCU.Libre_c01 + '|' + DOCU.Libre_c02
            .
    END.
    ASSIGN
       CcbCMvto.ImpTot = 0.
    FOR EACH DOCU:
        Ccbcmvto.ImpTot = Ccbcmvto.ImpTot + DOCU.ImpTot.
    END.
    x-NroDoc = Ccbcmvto.NroDoc.
END.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(Ccbcmvto) THEN RELEASE Ccbcmvto.
IF AVAILABLE(Ccbdmvto) THEN RELEASE Ccbdmvto.
MESSAGE 'GENERACION EXITOSA' SKIP
    'Documento generado:' s-coddoc x-nrodoc VIEW-AS ALERT-BOX INFORMATION.

RETURN 'OK'.

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
  DISPLAY
      TODAY - DAY(TODAY) + 1 @ FILL-IN-Desde
      TODAY @ FILL-IN-Hasta 
      WITH FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pr-Sube W-Win 
PROCEDURE Pr-Sube :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN DO:
    MESSAGE 'Debe seleccionar al menos un registro' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

DEF VAR k AS INT NO-UNDO.
DEF VAR cLinea AS CHAR NO-UNDO.
DEF VAR pNroSer AS INT INIT 000 NO-UNDO.
DEF VAR pNroDoc AS INT INIT 1 NO-UNDO.

EMPTY TEMP-TABLE RESUMEN.
EMPTY TEMP-TABLE DOCU.
x-Control-COT = ''.
FILL-IN_ImpProyectado = 0.
DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS WITH FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN DO:
        x-Control-COT = x-Control-COT +
                        (IF TRUE <> (x-Control-COT > '') THEN '' ELSE ',') +
                        COTIZACION.NroPed.
        FILL-IN_ImpProyectado = FILL-IN_ImpProyectado + COTIZACION.ImpTot.
        /* Agrupamos de acuerdo a la linea y sublinea */
        EMPTY TEMP-TABLE DETA.
        FOR EACH Facdpedi OF COTIZACION NO-LOCK:
            CREATE DETA.
            BUFFER-COPY Facdpedi TO DETA.
        END.
        FOR EACH VtaCTabla NO-LOCK WHERE {&Condicion}:
            FOR EACH DETA, FIRST Almmmatg OF DETA NO-LOCK:
                IF Almmmatg.CodFam = VtaCTabla.Libre_c01 THEN DO:
                    IF VtaCTabla.Libre_c02 > '' AND Almmmatg.SubFam <> VtaCTabla.Libre_c02 
                        THEN NEXT.
                    FIND RESUMEN WHERE RESUMEN.codfam = VtaCTabla.Libre_c01 AND
                        RESUMEN.subfam = VtaCTabla.Libre_c02 NO-ERROR.
                    IF NOT AVAILABLE RESUMEN THEN CREATE RESUMEN.
                    ASSIGN
                        RESUMEN.codfam = VtaCTabla.Libre_c01
                        RESUMEN.subfam = VtaCTabla.Libre_c02
                        RESUMEN.implin = RESUMEN.implin + DETA.implin.
                    DELETE DETA.
                END.
            END.
        END.
        /* Procesamos el saldo como OTROS */
        FOR EACH VtaCTabla NO-LOCK WHERE {&Condicion} AND VtaCTabla.Libre_c01 = 'OTROS':
            FOR EACH DETA, FIRST Almmmatg OF DETA NO-LOCK:
                FIND RESUMEN WHERE RESUMEN.codfam = VtaCTabla.Libre_c01 AND
                    RESUMEN.subfam = VtaCTabla.Libre_c02 NO-ERROR.
                IF NOT AVAILABLE RESUMEN THEN CREATE RESUMEN.
                ASSIGN
                    RESUMEN.codfam = VtaCTabla.Libre_c01
                    RESUMEN.subfam = VtaCTabla.Libre_c02
                    RESUMEN.implin = RESUMEN.implin + DETA.implin.
            END.
        END.
    END.
END.
FOR EACH RESUMEN:
    RUN Carga-Letras (COMBO-BOX_Zona,
                      RESUMEN.codfam,
                      RESUMEN.subfam,
                      ROUND(RESUMEN.implin * FILL-IN_Cumplimiento / 100, 2),
                      pNroSer,
                      INPUT-OUTPUT pNroDoc).
END.
EDITOR-Cotizaciones:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-Control-COT.
FILL-IN_ImpProyectado = ROUND(FILL-IN_ImpProyectado * FILL-IN_Cumplimiento / 100, 2).
DISPLAY FILL-IN_ImpProyectado WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pr-Sube-2 W-Win 
PROCEDURE Pr-Sube-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k AS INT NO-UNDO.
DEF VAR cLinea AS CHAR NO-UNDO.
DEF VAR pNroSer AS INT INIT 000 NO-UNDO.
DEF VAR pNroDoc AS INT INIT 1 NO-UNDO.

EMPTY TEMP-TABLE RESUMEN.
EMPTY TEMP-TABLE DOCU.
x-Control-COT = ''.
FILL-IN_ImpProyectado = 0.
FOR EACH COTIZACION NO-LOCK:
    x-Control-COT = x-Control-COT +
                    (IF TRUE <> (x-Control-COT > '') THEN '' ELSE ',') +
                    COTIZACION.NroPed.
    FILL-IN_ImpProyectado = FILL-IN_ImpProyectado + COTIZACION.ImpTot.
    /* Agrupamos de acuerdo a la linea y sublinea */
    EMPTY TEMP-TABLE DETA.
    FOR EACH Facdpedi OF COTIZACION NO-LOCK:
        CREATE DETA.
        BUFFER-COPY Facdpedi TO DETA.
    END.
    FOR EACH VtaCTabla NO-LOCK WHERE {&Condicion}:
        FOR EACH DETA, FIRST Almmmatg OF DETA NO-LOCK:
            IF Almmmatg.CodFam = VtaCTabla.Libre_c01 THEN DO:
                IF VtaCTabla.Libre_c02 > '' AND Almmmatg.SubFam <> VtaCTabla.Libre_c02 
                    THEN NEXT.
                FIND RESUMEN WHERE RESUMEN.codfam = VtaCTabla.Libre_c01 AND
                    RESUMEN.subfam = VtaCTabla.Libre_c02 NO-ERROR.
                IF NOT AVAILABLE RESUMEN THEN CREATE RESUMEN.
                ASSIGN
                    RESUMEN.codfam = VtaCTabla.Libre_c01
                    RESUMEN.subfam = VtaCTabla.Libre_c02
                    RESUMEN.implin = RESUMEN.implin + DETA.implin.
                DELETE DETA.
            END.
        END.
    END.
    /* Procesamos el saldo como OTROS */
    FOR EACH VtaCTabla NO-LOCK WHERE {&Condicion} AND VtaCTabla.Libre_c01 = 'OTROS':
        FOR EACH DETA, FIRST Almmmatg OF DETA NO-LOCK:
            FIND RESUMEN WHERE RESUMEN.codfam = VtaCTabla.Libre_c01 AND
                RESUMEN.subfam = VtaCTabla.Libre_c02 NO-ERROR.
            IF NOT AVAILABLE RESUMEN THEN CREATE RESUMEN.
            ASSIGN
                RESUMEN.codfam = VtaCTabla.Libre_c01
                RESUMEN.subfam = VtaCTabla.Libre_c02
                RESUMEN.implin = RESUMEN.implin + DETA.implin.
        END.
    END.
END.
FOR EACH RESUMEN:
    RUN Carga-Letras (COMBO-BOX_Zona,
                      RESUMEN.codfam,
                      RESUMEN.subfam,
                      ROUND(RESUMEN.implin * FILL-IN_Cumplimiento / 100, 2),
                      pNroSer,
                      INPUT-OUTPUT pNroDoc).
END.
EDITOR-Cotizaciones:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-Control-COT.
FILL-IN_ImpProyectado = ROUND(FILL-IN_ImpProyectado * FILL-IN_Cumplimiento / 100, 2).
DISPLAY FILL-IN_ImpProyectado WITH FRAME {&FRAME-NAME}.

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

DEF INPUT PARAMETER pParam AS CHAR.

CASE pParam:
    WHEN 'disable-button' THEN BUTTON-Generar:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    WHEN 'enable-button'  THEN BUTTON-Generar:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END CASE.

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
  {src/adm/template/snd-list.i "COTIZACION"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Totales W-Win 
PROCEDURE Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER B-COTIZACION FOR COTIZACION.

FILL-IN_ImpTot = 0.
FOR EACH B-COTIZACION NO-LOCK:
    FILL-IN_ImpTot = FILL-IN_ImpTot + B-COTIZACION.ImpTot.
END.
DISPLAY FILL-IN_ImpTot WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

