&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER ORDENES FOR FacCPedi.
DEFINE BUFFER PEDIDOS FOR FacCPedi.
DEFINE NEW SHARED TEMP-TABLE T-FacCPedi NO-UNDO LIKE FacCPedi.
DEFINE NEW SHARED TEMP-TABLE T-RutaC LIKE DI-RutaC.
DEFINE NEW SHARED TEMP-TABLE T-RutaD LIKE DI-RutaD.



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
DEF SHARED VAR s-coddiv AS CHAR.

DEF SHARED VAR s-user-id AS CHAR.

DEF VAR pMensaje AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-FacCPedi

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 T-FacCPedi.Libre_c01 ~
T-FacCPedi.CodDoc T-FacCPedi.NroPed T-FacCPedi.NomCli T-FacCPedi.FchEnt ~
T-FacCPedi.Hora T-FacCPedi.Libre_d01 T-FacCPedi.ImpTot T-FacCPedi.Libre_d02 ~
T-FacCPedi.FchPed T-FacCPedi.Glosa T-FacCPedi.LugEnt T-FacCPedi.FlgEst ~
T-FacCPedi.FlgSit 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH T-FacCPedi ~
      WHERE T-FacCPedi.CodCia = s-codcia ~
 AND (T-FacCPedi.CodDoc = "O/D" ~
  OR T-FacCPedi.CodDoc = "OTR") ~
 AND T-FacCPedi.DivDes = s-coddiv ~
 AND (T-FacCPedi.FlgEst = "P" ~
  OR T-FacCPedi.FlgEst = "C") ~
 AND (T-FacCPedi.FlgSit = "T" ~
  OR T-FacCPedi.FlgSit = "TG" ~
  OR T-FacCPedi.FlgSit = "C") NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH T-FacCPedi ~
      WHERE T-FacCPedi.CodCia = s-codcia ~
 AND (T-FacCPedi.CodDoc = "O/D" ~
  OR T-FacCPedi.CodDoc = "OTR") ~
 AND T-FacCPedi.DivDes = s-coddiv ~
 AND (T-FacCPedi.FlgEst = "P" ~
  OR T-FacCPedi.FlgEst = "C") ~
 AND (T-FacCPedi.FlgSit = "T" ~
  OR T-FacCPedi.FlgSit = "TG" ~
  OR T-FacCPedi.FlgSit = "C") NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 T-FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 T-FacCPedi


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 BROWSE-2 BUTTON-2 BUTTON-3 ~
BUTTON-Refrescar BUTTON-Consolidar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-BROWSE-2 
       MENU-ITEM m_Detalle_de_la_Orden LABEL "Detalle de la Orden".


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-add-od-otr-cab AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-add-od-otr-det AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-od-otr-origen-det AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/forward.ico":U
     LABEL "Button 2" 
     SIZE 7 BY 1.62.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/back.ico":U
     LABEL "Button 3" 
     SIZE 7 BY 1.62.

DEFINE BUTTON BUTTON-4 
     LABEL "CREAR PHR EN BLANCO >>>" 
     SIZE 51 BY 1.35
     FONT 8.

DEFINE BUTTON BUTTON-Consolidar 
     LABEL "CONSOLIDAR HPK Y ENVIAR A PICKING" 
     SIZE 31 BY 1.12.

DEFINE BUTTON BUTTON-Refrescar 
     LABEL "REFRESCAR" 
     SIZE 15 BY 1.12.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 88 BY 13.19
     BGCOLOR 15 FGCOLOR 0 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      T-FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      T-FacCPedi.Libre_c01 COLUMN-LABEL "Distrito" FORMAT "x(10)":U
            WIDTH 10.43
      T-FacCPedi.CodDoc FORMAT "x(3)":U
      T-FacCPedi.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U
      T-FacCPedi.NomCli FORMAT "x(100)":U WIDTH 35
      T-FacCPedi.FchEnt COLUMN-LABEL "Fch.Entrega" FORMAT "99/99/9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      T-FacCPedi.Hora FORMAT "X(5)":U WIDTH 4.57
      T-FacCPedi.Libre_d01 COLUMN-LABEL "Peso kg" FORMAT "->>>,>>>,>>9.99":U
      T-FacCPedi.ImpTot FORMAT "->>,>>>,>>9.99":U
      T-FacCPedi.Libre_d02 COLUMN-LABEL "Volumen m3" FORMAT "->>>,>>>,>>9.99":U
      T-FacCPedi.FchPed FORMAT "99/99/9999":U
      T-FacCPedi.Glosa COLUMN-LABEL "Observaciones" FORMAT "X(50)":U
      T-FacCPedi.LugEnt FORMAT "x(60)":U
      T-FacCPedi.FlgEst FORMAT "X(2)":U
      T-FacCPedi.FlgSit COLUMN-LABEL "Situación" FORMAT "X(2)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 95 BY 20.46
         FONT 4
         TITLE "SELECCIONE EL REGISTRO A CONSOLIDAR" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-4 AT ROW 1.27 COL 52 WIDGET-ID 22
     BROWSE-2 AT ROW 3.15 COL 2 WIDGET-ID 200
     BUTTON-2 AT ROW 16.88 COL 99 WIDGET-ID 4
     BUTTON-3 AT ROW 18.77 COL 99 WIDGET-ID 10
     BUTTON-Refrescar AT ROW 25.23 COL 2 WIDGET-ID 2
     BUTTON-Consolidar AT ROW 25.23 COL 26 WIDGET-ID 12
     "(1)" VIEW-AS TEXT
          SIZE 5 BY 1.08 AT ROW 25.23 COL 17 WIDGET-ID 6
          FONT 8
     "(2)" VIEW-AS TEXT
          SIZE 5 BY 1.08 AT ROW 15.81 COL 100 WIDGET-ID 8
          FONT 8
     "Botón Derecho para menú contextual" VIEW-AS TEXT
          SIZE 27 BY .5 AT ROW 23.88 COL 2 WIDGET-ID 18
     "(3)" VIEW-AS TEXT
          SIZE 5 BY 1.08 AT ROW 25.23 COL 57 WIDGET-ID 14
          FONT 8
     RECT-1 AT ROW 1.27 COL 103 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 191.29 BY 26.12
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ORDENES B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDOS B "?" ? INTEGRAL FacCPedi
      TABLE: T-FacCPedi T "NEW SHARED" NO-UNDO INTEGRAL FacCPedi
      TABLE: T-RutaC T "NEW SHARED" ? INTEGRAL DI-RutaC
      TABLE: T-RutaD T "NEW SHARED" ? INTEGRAL DI-RutaD
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CONSOLIDACION DE ORDENES A PHR"
         HEIGHT             = 26.12
         WIDTH              = 191.29
         MAX-HEIGHT         = 26.15
         MAX-WIDTH          = 191.29
         VIRTUAL-HEIGHT     = 26.15
         VIRTUAL-WIDTH      = 191.29
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
/* BROWSE-TAB BROWSE-2 BUTTON-4 F-Main */
ASSIGN 
       BROWSE-2:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-BROWSE-2:HANDLE
       BROWSE-2:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2.

/* SETTINGS FOR BUTTON BUTTON-4 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.T-FacCPedi"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "T-FacCPedi.CodCia = s-codcia
 AND (T-FacCPedi.CodDoc = ""O/D""
  OR T-FacCPedi.CodDoc = ""OTR"")
 AND T-FacCPedi.DivDes = s-coddiv
 AND (T-FacCPedi.FlgEst = ""P""
  OR T-FacCPedi.FlgEst = ""C"")
 AND (T-FacCPedi.FlgSit = ""T""
  OR T-FacCPedi.FlgSit = ""TG""
  OR T-FacCPedi.FlgSit = ""C"")"
     _FldNameList[1]   > Temp-Tables.T-FacCPedi.Libre_c01
"T-FacCPedi.Libre_c01" "Distrito" "x(10)" "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.T-FacCPedi.CodDoc
     _FldNameList[3]   > Temp-Tables.T-FacCPedi.NroPed
"T-FacCPedi.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-FacCPedi.NomCli
"T-FacCPedi.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "35" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-FacCPedi.FchEnt
"T-FacCPedi.FchEnt" "Fch.Entrega" ? "date" 11 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-FacCPedi.Hora
"T-FacCPedi.Hora" ? ? "character" ? ? ? ? ? ? no ? no no "4.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-FacCPedi.Libre_d01
"T-FacCPedi.Libre_d01" "Peso kg" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = Temp-Tables.T-FacCPedi.ImpTot
     _FldNameList[9]   > Temp-Tables.T-FacCPedi.Libre_d02
"T-FacCPedi.Libre_d02" "Volumen m3" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   = Temp-Tables.T-FacCPedi.FchPed
     _FldNameList[11]   > Temp-Tables.T-FacCPedi.Glosa
"T-FacCPedi.Glosa" "Observaciones" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   = Temp-Tables.T-FacCPedi.LugEnt
     _FldNameList[13]   > Temp-Tables.T-FacCPedi.FlgEst
"T-FacCPedi.FlgEst" ? "X(2)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.T-FacCPedi.FlgSit
"T-FacCPedi.FlgSit" "Situación" "X(2)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONSOLIDACION DE ORDENES A PHR */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONSOLIDACION DE ORDENES A PHR */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  DEF VAR pNroDoc AS CHAR NO-UNDO.

  RUN Captura-PHR IN h_b-add-od-otr-cab
    ( OUTPUT pNroDoc /* CHARACTER */).
  IF pNroDoc = ? THEN RETURN NO-APPLY.

  DEF VAR k AS INT NO-UNDO.
  DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
      IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN DO:
          FIND T-RutaC WHERE T-RutaC.NroDoc = pNroDoc.
          CREATE T-RutaD.
          BUFFER-COPY T-RutaC TO T-RutaD
              ASSIGN
              T-RutaD.CodRef = T-FacCPedi.CodDoc 
              T-RutaD.NroRef = T-FacCPedi.NroPed.
          ASSIGN
              T-RutaD.Libre_d01 = T-FacCPedi.Libre_d01
              T-RutaD.ImpCob = T-FacCPedi.ImpTot
              T-RutaD.Libre_d02 = T-FacCPedi.Libre_d02.
          ASSIGN
              T-RutaD.Libre_c01 = T-FacCPedi.Libre_c01
              T-RutaD.Libre_c02 = T-FacCPedi.LugEnt.
          DELETE T-FacCPedi.
      END.
  END.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  RUN dispatch IN h_b-add-od-otr-det ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
    DEF VAR pCodRef AS CHAR NO-UNDO.
    DEF VAR pNroRef AS CHAR NO-UNDO.

    RUN Captura-Orden IN h_b-add-od-otr-det
      ( OUTPUT pCodRef, /* CHARACTER */
        OUTPUT pNroRef /* CHARACTER */).

    IF pNroRef = ? THEN RETURN NO-APPLY.

    FIND FIRST T-RutaD WHERE T-RutaD.CodRef = pCodRef AND
        T-RutaD.NroRef = pNroRef.
    FIND Faccpedi WHERE Faccpedi.codcia = s-codcia AND
        Faccpedi.coddoc = pCodRef AND
        Faccpedi.nroped = pNroRef NO-LOCK.
    CREATE T-Faccpedi.
    BUFFER-COPY Faccpedi TO T-Faccpedi.
    ASSIGN
        T-FacCPedi.Libre_d01 = T-RutaD.Libre_d01
        T-FacCPedi.ImpTot = T-RutaD.ImpCob 
        T-FacCPedi.Libre_d02 = T-RutaD.Libre_d02.
    ASSIGN
        T-FacCPedi.Libre_c01 = T-RutaD.Libre_c01 
        T-FacCPedi.LugEnt = T-RutaD.Libre_c02.

    DELETE T-RutaD.

    {&OPEN-QUERY-{&BROWSE-NAME}}
    RUN dispatch IN h_b-add-od-otr-det ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* CREAR PHR EN BLANCO >>> */
DO:
  DEF VAR pMensaje AS CHAR NO-UNDO.

  RUN Crear-PHR IN h_b-add-od-otr-cab
    ( OUTPUT pMensaje /* CHARACTER */).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Consolidar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Consolidar W-Win
ON CHOOSE OF BUTTON-Consolidar IN FRAME F-Main /* CONSOLIDAR HPK Y ENVIAR A PICKING */
DO:
  IF NOT CAN-FIND(FIRST T-RutaD NO-LOCK) THEN DO:
    MESSAGE 'NO hay ninguna Orden seleccionada' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  MESSAGE "Procedemos con la consolidación de PHR's?" VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  RUN MASTER-TRANSACTION.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  APPLY "CHOOSE":U TO BUTTON-Refrescar.
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Refrescar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Refrescar W-Win
ON CHOOSE OF BUTTON-Refrescar IN FRAME F-Main /* REFRESCAR */
DO:
  RUN Carga-Temporales.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  RUN dispatch IN h_b-add-od-otr-cab ('open-query':U).
  RUN dispatch IN h_b-add-od-otr-det ('open-query':U).
  ENABLE BUTTON-4 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Detalle_de_la_Orden
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Detalle_de_la_Orden W-Win
ON CHOOSE OF MENU-ITEM m_Detalle_de_la_Orden /* Detalle de la Orden */
DO:
    IF AVAILABLE T-Faccpedi THEN RUN logis/d-detalle-orden (T-Faccpedi.CodDoc, T-Faccpedi.NroPed).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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
             INPUT  'aplic/logis/b-add-od-otr-cab.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-add-od-otr-cab ).
       RUN set-position IN h_b-add-od-otr-cab ( 1.54 , 105.00 ) NO-ERROR.
       RUN set-size IN h_b-add-od-otr-cab ( 5.38 , 83.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-od-otr-origen-det.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-od-otr-origen-det ).
       RUN set-position IN h_b-od-otr-origen-det ( 7.19 , 105.00 ) NO-ERROR.
       RUN set-size IN h_b-od-otr-origen-det ( 7.00 , 83.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-add-od-otr-det.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-add-od-otr-det ).
       RUN set-position IN h_b-add-od-otr-det ( 14.46 , 108.00 ) NO-ERROR.
       RUN set-size IN h_b-add-od-otr-det ( 12.38 , 83.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-od-otr-origen-det. */
       RUN add-link IN adm-broker-hdl ( h_b-add-od-otr-cab , 'Record':U , h_b-od-otr-origen-det ).

       /* Links to SmartBrowser h_b-add-od-otr-det. */
       RUN add-link IN adm-broker-hdl ( h_b-add-od-otr-cab , 'Record':U , h_b-add-od-otr-det ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-add-od-otr-cab ,
             BUTTON-4:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-od-otr-origen-det ,
             BROWSE-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-add-od-otr-det ,
             h_b-od-otr-origen-det , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporales W-Win 
PROCEDURE Carga-Temporales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-FacCPedi.
EMPTY TEMP-TABLE T-RutaC.
EMPTY TEMP-TABLE T-RutaD.

SESSION:SET-WAIT-STATE('GENERAL').
RLOOP:
FOR EACH FacCPedi NO-LOCK WHERE FacCPedi.CodCia = s-codcia AND 
    FacCPedi.DivDes = s-coddiv AND 
    FacCPedi.FlgEst = "P" AND 
    (FacCPedi.FlgSit = "T" OR FacCPedi.FlgSit = "TG" /*OR FacCPedi.FlgSit = "C"*/) AND
    (FacCPedi.CodDoc = "O/D" OR FacCPedi.CodDoc = "OTR") :
    CASE TRUE:
        WHEN Faccpedi.CodDoc = "OTR" THEN DO:
            IF Faccpedi.TpoPed = "INC" THEN DO:
                IF NOT Faccpedi.Glosa BEGINS 'INCIDENCIA: MAL ESTADO' THEN NEXT RLOOP.
            END.
            IF Faccpedi.TpoPed = "XD" THEN NEXT RLOOP.
        END.
        WHEN Faccpedi.CodDoc = "O/D" THEN DO:
            IF Faccpedi.TipVta = "SI"  THEN NEXT RLOOP.       /* TRAMITE DOCUMENTARIO */
        END.
    END CASE.
    FIND FIRST DI-RutaD WHERE DI-RutaD.CodCia = s-CodCia AND
        DI-RutaD.CodDiv = s-CodDiv AND
        DI-RutaD.CodDoc = "PHR" AND
        DI-RutaD.CodRef = Faccpedi.CodDoc AND
        DI-RutaD.NroRef = Faccpedi.NroPed AND
        CAN-FIND(FIRST DI-RutaC OF DI-RutaD WHERE DI-RutaC.FlgEst <> "A" NO-LOCK)
        NO-LOCK NO-ERROR.
    IF AVAILABLE DI-RutaD THEN NEXT.
    CREATE T-FacCPedi.
    BUFFER-COPY FacCPedi TO T-FacCPedi.
    /* Peso y Volumen */
    ASSIGN
        T-Faccpedi.Libre_d01 = 0    /* Aqui acumulamos el peso */
        T-Faccpedi.Libre_d02 = 0.   /* Aqui acumulamos el volumen */
    ASSIGN
        T-Faccpedi.Libre_d01 = Faccpedi.Peso
        T-Faccpedi.Libre_d02 = Faccpedi.Volumen.
/*     FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:                                                 */
/*         ASSIGN                                                                                                                 */
/*             T-Faccpedi.Libre_d01 = T-Faccpedi.Libre_d01 +  (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.PesMat)               */
/*             T-Faccpedi.Libre_d02 = T-Faccpedi.Libre_d02 +  (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.Libre_d02 / 1000000). */
/*     END.                                                                                                                       */
    /* Importe */
    ASSIGN
        T-Faccpedi.ImpTot = Faccpedi.AcuBon[8].
/*     IF FacCPedi.CodDoc = "OTR" THEN DO:                                            */
/*         T-FacCPedi.ImpTot = 0.                                                     */
/*         FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK: */
/*             ASSIGN T-FacCPedi.ImpTot = T-FacCPedi.ImpTot +                         */
/*                 (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.CtoTot) *            */
/*                 (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1).              */
/*         END.                                                                       */
/*     END.                                                                           */
    /* Distrito y lugar de entrega */
    DEF VAR x-Ubigeo AS CHAR NO-UNDO.
    DEF VAR x-Longitud AS DEC NO-UNDO.
    DEF VAR x-Latitud AS DEC NO-UNDO.
    DEF VAR x-LugEnt AS CHAR NO-UNDO.

    RUN logis/p-datos-sede-auxiliar(INPUT FacCPedi.ubigeo[2], 
                                    INPUT FacCPedi.ubigeo[3],
                                    INPUT FacCPedi.ubigeo[1],
                                    OUTPUT x-ubigeo,
                                    OUTPUT x-longitud,
                                    OUTPUT x-latitud).

    FIND FIRST tabdistr WHERE tabdistr.coddepto = SUBSTRING(x-ubigeo,1,2) AND
        tabdistr.codprov = SUBSTRING(x-ubigeo,3,2) AND
        tabdistr.coddist = SUBSTRING(x-ubigeo,5,2)
        NO-LOCK NO-ERROR.
    IF AVAILABLE TabDistr THEN T-FacCPedi.Libre_c01 = TabDistr.NomDistr. ELSE T-FacCPedi.Libre_c01 = "<no existe>".

    RUN logis/p-lugar-de-entrega (FacCPedi.CodDoc,
                                  FacCPedi.NroPed,
                                  OUTPUT x-LugEnt).
    T-FacCPedi.LugEnt = x-LugEnt.
    IF NUM-ENTRIES(x-LugEnt,'|') > 1 THEN T-FacCPedi.LugEnt = ENTRY(2,x-LugEnt,'|').

END.

FOR EACH DI-RutaC NO-LOCK WHERE DI-RutaC.CodCia = s-codcia AND
    DI-RutaC.CodDiv = s-coddiv AND
    DI-RutaC.CodDoc = "PHR" AND
    (DI-RutaC.FlgEst = "PX" OR DI-RutaC.FlgEst = "PK" OR DI-RutaC.FlgEst = "PF"):
    CREATE T-RutaC.
    BUFFER-COPY DI-RutaC TO T-RutaC.
    ASSIGN
        T-RutaC.Libre_d01 = 0   /* Peso */
        T-RutaC.Libre_d02 = 0   /* Volumen */
        T-RutaC.Libre_d03 = 0.  /* Importe */
    FOR EACH DI-RutaD OF DI-RutaC NO-LOCK:
        ASSIGN
            T-RutaC.Libre_d01 = T-RutaC.Libre_d01 + Di-rutad.Libre_d01
            T-RutaC.Libre_d02 = T-RutaC.Libre_d02 + Di-rutad.ImpCob
            T-RutaC.Libre_d03 = T-RutaC.Libre_d03 + Di-rutad.Libre_d02.
        /* Caso OTR */
        /* Importe */
/*         IF DI-RutaD.CodRef = "OTR" THEN DO:                                 */
/*             T-RutaC.Libre_d03 = 0.  /* Importe */                           */
/*             FOR EACH Facdpedi WHERE Facdpedi.codcia = DI-RutaC.CodCia AND   */
/*                 Facdpedi.coddoc = DI-RutaD.CodRef AND                       */
/*                 Facdpedi.nroped = DI-RutaD.NroRef NO-LOCK,                  */
/*                 FIRST Almmmatg OF Facdpedi NO-LOCK:                         */
/*                 ASSIGN                                                      */
/*                     T-RutaC.Libre_d03 = T-RutaC.Libre_d03 +                 */
/*                     (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.CtoTot) * */
/*                     (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1).   */
/*             END.                                                            */
/*         END.                                                                */
    END.
END.
SESSION:SET-WAIT-STATE('').

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
  ENABLE RECT-1 BROWSE-2 BUTTON-2 BUTTON-3 BUTTON-Refrescar BUTTON-Consolidar 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MASTER-TRANSACTION W-Win 
PROCEDURE MASTER-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER BT-RutaD FOR T-RutaD.      
                   
/* ********************************************************************************** */
/* RHC 16/01/2020 COnsistencia de Pedidos y Bonificaciones */
/* ********************************************************************************** */
FOR EACH T-RutaC NO-LOCK WHERE CAN-FIND(FIRST BT-RutaD OF T-RutaC NO-LOCK):
    /* Por cada O/D con BONIFICACION deben estar las 2 en la misma PHR */
    FOR EACH T-RutaD OF T-RutaC NO-LOCK:
        /* Determinamos si es una bonificación o no */
        /* Solo en caso de O/D */
        IF T-RutaD.codref = "O/D" THEN DO:
            FIND ORDENES WHERE ORDENES.codcia = s-codcia AND
                ORDENES.coddoc = T-RutaD.codref AND
                ORDENES.nroped = T-RutaD.nroref NO-LOCK.
            FIND PEDIDOS WHERE PEDIDOS.codcia = s-codcia AND
                PEDIDOS.coddoc = ORDENES.codref AND
                PEDIDOS.nroped = ORDENES.nroref NO-LOCK.
            /* Es el original o el bonificado? */
            IF PEDIDOS.CodOrigen = "PED" AND PEDIDOS.FmaPgo = '899' THEN DO:    /* BONIFICACION */
                /* Buscamos su ORIGINAL */
                FIND FIRST ORDENES WHERE ORDENES.codcia = s-codcia AND
                    ORDENES.codref = PEDIDOS.CodOrigen AND
                    ORDENES.nroref = PEDIDOS.NroOrigen AND
                    ORDENES.coddoc = "O/D" AND
                    ORDENES.flgest <> "A" NO-LOCK.
                IF AVAILABLE ORDENES AND
                    NOT CAN-FIND(FIRST T-RutaD WHERE T-RutaD.coddoc = T-RutaC.coddoc AND 
                                T-RutaD.nrodoc = T-RutaC.nrodoc AND
                                T-RutaD.codref = ORDENES.coddoc AND
                                T-RutaD.nroref = ORDENES.nroped 
                                NO-LOCK) THEN DO:
                    pMensaje = "NO ha registrado la Orden Original " + ORDENES.NroPed + 
                        " para la Orden de Bonificación " + T-RutaD.nroref.
                    RETURN 'ADM-ERROR'.
                END.
            END.
            ELSE DO:    /* ORIGINAL */
                /* Buscamos si tiene PED de BONIFICACION */
                FIND FIRST Faccpedi WHERE Faccpedi.codcia = s-codcia AND
                    Faccpedi.coddoc = "PED" AND
                    Faccpedi.fmapgo = "899" AND
                    Faccpedi.CodOrigen = PEDIDOS.coddoc AND
                    Faccpedi.NroOrigen = PEDIDOS.nroped AND
                    Faccpedi.FlgEst <> "A"
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Faccpedi THEN DO:
                    /* Buscamos su BONIFICACION */
                    FIND FIRST ORDENES WHERE ORDENES.codcia = s-codcia AND
                        ORDENES.coddoc = "O/D" AND
                        ORDENES.codref = Faccpedi.coddoc AND
                        ORDENES.nroref = Faccpedi.nroped AND
                        ORDENES.flgest <> "A" NO-LOCK.
                    IF AVAILABLE ORDENES AND
                        NOT CAN-FIND(FIRST T-RutaD WHERE T-RutaD.coddoc = T-RutaC.coddoc AND 
                                    T-RutaD.nrodoc = T-RutaC.nrodoc AND
                                    T-RutaD.codref = ORDENES.coddoc AND
                                    T-RutaD.nroref = ORDENES.nroped 
                                    NO-LOCK) THEN DO:
                        pMensaje = "NO ha registrado la Orden Bonificación " + ORDENES.NroPed + 
                            " para la Orden Original " + T-RutaD.nroref.
                        RETURN 'ADM-ERROR'.
                    END.
                END.
            END.
        END.
    END.
END.
/* ********************************************************************************** */
/* ********************************************************************************** */
                   
DEF VAR x-Control-HPK AS LOG NO-UNDO.
pMensaje = ''.
x-Control-HPK = NO.
RLOOP:
DO WITH FRAME {&FRAME-NAME} TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH T-RutaC NO-LOCK WHERE CAN-FIND(FIRST BT-RutaD OF T-RutaC NO-LOCK):
        /* Bloqueamos el destino DESTINO */
        {lib/lock-genericov3.i ~
            &Tabla="DI-RutaC" ~
            &Condicion="DI-RutaC.CodCia = T-RutaC.CodCia AND ~
            DI-RutaC.CodDiv = T-RutaC.CodDiv AND ~
            DI-RutaC.CodDoc = T-RutaC.CodDoc AND ~
            DI-RutaC.NroDoc = T-RutaC.NroDoc" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje" ~
            &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'"}
        /* Verificamos su estado */
        IF NOT (DI-RutaC.FlgEst = "PX" OR DI-RutaC.FlgEst = "PK" OR DI-RutaC.FlgEst = "PF") THEN DO:
            pMensaje = "La PHR DESTINO (" + DI-RutaC.NroDoc + ") YA no es válida".
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        FOR EACH T-RutaD OF T-RutaC NO-LOCK:
            /* ********************************** */
            /* Verificamos nuevamente las Ordenes */
            /* ********************************** */
            FIND FacCPedi WHERE FacCPedi.CodCia = s-CodCia AND
                FacCPedi.CodDoc = T-RutaD.CodRef AND
                FacCPedi.NroPed = T-RutaD.NroRef NO-LOCK NO-ERROR.
            IF AVAILABLE FacCPedi AND NOT ( FacCPedi.FlgEst = "P" AND 
                                           (FacCPedi.FlgSit = "T" OR 
                                            FacCPedi.FlgSit = "TG" OR 
                                            FacCPedi.FlgSit = "C") )
                THEN NEXT.
            /* ********************************** */
            /* Bloqueamos Orden */
            FIND CURRENT FacCpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                {lib/mensaje-de-error.i &MensajeError="pMensaje"}
                UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
            IF (FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = "T")
                THEN FacCPedi.FlgSit = "TG".    /* Con PHR Generada */
            /* ********************************** */
            CREATE DI-RutaD.
            ASSIGN
                DI-RutaD.CodCia = T-RutaD.CodCia
                DI-RutaD.CodDiv = T-RutaD.CodDiv
                DI-RutaD.CodDoc = T-RutaD.CodDoc
                DI-RutaD.CodRef = T-RutaD.CodRef
                DI-RutaD.NroDoc = T-RutaD.NroDoc
                DI-RutaD.NroRef = T-RutaD.NroRef.
        END.
        /* Generamos las HPK si fuera necesario */
        /*IF DI-RutaC.FlgEst <> "PX" THEN DO:*/
            RUN logis/p-genera-hpk-v2 (INPUT ROWID(Di-RutaC), OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, RETURN 'ADM-ERROR'.
            x-Control-HPK = YES.
        /*END.*/
    END.
END.
IF AVAILABLE(DI-RutaC) THEN RELEASE DI-RutaC.
IF AVAILABLE(FacCPedi) THEN RELEASE FacCPedi.

IF x-Control-HPK = NO THEN MESSAGE "NO se han generado HPK's" VIEW-AS ALERT-BOX INFORMATION.
RETURN 'OK'.

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
  {src/adm/template/snd-list.i "T-FacCPedi"}

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

