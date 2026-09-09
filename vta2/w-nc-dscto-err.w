&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ITEM NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE T-CDOCU NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE T-DDOCU NO-UNDO LIKE CcbDDocu.
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.



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
DEF VAR s-coddoc AS CHAR INIT 'N/C'.
DEF SHARED VAR s-user-id AS CHAR.

FIND FIRST FacCorre WHERE FacCorre.CodCia = s-codcia
    AND FacCorre.CodDiv = s-coddiv
    AND FacCorre.CodDoc = s-coddoc
    AND FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE 'NO está definido el correlativo para la' s-coddoc 'de la división' s-coddiv
        VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.

DEFINE BUFFER B-TABLA FOR VtaDTabla.
DEFINE TEMP-TABLE Promocion LIKE VtaDTabla.
DEF VAR x-ImpDto2  AS DEC INIT 0 NO-UNDO.

DEF VAR lFlgDB1 AS LOG NO-UNDO.
DEF VAR lFlgDB2 AS LOG NO-UNDO.
DEF VAR lFlgDB3 AS LOG NO-UNDO.
DEF VAR lFlgDB4 AS LOG NO-UNDO.
DEF VAR lFlgDB5 AS LOG NO-UNDO.
DEF VAR lFlgDB6 AS LOG NO-UNDO.
DEF VAR lFlgDB8 AS LOG NO-UNDO.
DEF VAR lFlgDB9 AS LOG NO-UNDO.
DEF VAR lFlgDB11 AS LOG NO-UNDO.
DEF VAR lFlgDB12 AS LOG NO-UNDO.
DEF VAR lFlgDB20 AS LOG NO-UNDO.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

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

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 COMBO-BOX-CodRef ~
FILL-IN-NroRef COMBO-BOX-Cupon BUTTON-1 COMBO-BOX-NroSer COMBO-BOX-Concepto ~
BtnDone BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodRef FILL-IN-NroRef ~
FILL-IN-FchDoc FILL-IN-CodCli FILL-IN-NomCli FILL-IN-ImpTot COMBO-BOX-Cupon ~
FILL-IN-NewImport FILL-IN-CodDoc COMBO-BOX-NroSer FILL-IN-NroDoc ~
COMBO-BOX-Concepto FILL-IN-ImpFinal 

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
     LABEL "Calcular Nuevo Importe" 
     SIZE 21 BY .77.

DEFINE BUTTON BUTTON-2 
     LABEL "Generar Nota de Crédito" 
     SIZE 20 BY 1.12.

DEFINE BUTTON BUTTON-3 
     LABEL "Limpiar Filtros" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX-CodRef AS CHARACTER FORMAT "X(256)":U INITIAL "TCK" 
     LABEL "Referencia" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "TCK" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Concepto AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione concepto" 
     LABEL "Concepto" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Seleccione concepto","Seleccione concepto"
     DROP-DOWN-LIST
     SIZE 56 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Cupon AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione un Cupón" 
     LABEL "Descuento x Cupón" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEM-PAIRS "Seleccione un Cupón","Seleccione un Cupón"
     DROP-DOWN-LIST
     SIZE 57 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-NroSer AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Serie" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodDoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Comprobante" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitido el" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpFinal AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Importe Final" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpTot AS DECIMAL FORMAT "->>>>,>>9.99":U INITIAL 0 
     LABEL "Importe Total" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NewImport AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Nuevo Importe" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS INTEGER FORMAT ">>>>>>>9":U INITIAL 0 
     LABEL "Correlativo" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroRef AS CHARACTER FORMAT "XXX-XXXXXXXX":U 
     LABEL "N° Referencia" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 3.65.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 2.88.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 4.81.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-CodRef AT ROW 1.96 COL 15 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-NroRef AT ROW 1.96 COL 36 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-FchDoc AT ROW 1.96 COL 58 COLON-ALIGNED WIDGET-ID 18
     FILL-IN-CodCli AT ROW 2.92 COL 15 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-NomCli AT ROW 2.92 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     FILL-IN-ImpTot AT ROW 3.88 COL 15 COLON-ALIGNED WIDGET-ID 20
     COMBO-BOX-Cupon AT ROW 5.81 COL 15 COLON-ALIGNED WIDGET-ID 52
     FILL-IN-NewImport AT ROW 6.77 COL 15 COLON-ALIGNED WIDGET-ID 26
     BUTTON-1 AT ROW 6.77 COL 31 WIDGET-ID 28
     FILL-IN-CodDoc AT ROW 9.08 COL 15 COLON-ALIGNED WIDGET-ID 4
     COMBO-BOX-NroSer AT ROW 9.08 COL 29 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-NroDoc AT ROW 9.08 COL 45 COLON-ALIGNED WIDGET-ID 8
     COMBO-BOX-Concepto AT ROW 10.04 COL 15 COLON-ALIGNED WIDGET-ID 38
     FILL-IN-ImpFinal AT ROW 11 COL 15 COLON-ALIGNED WIDGET-ID 42
     BtnDone AT ROW 11.58 COL 78 WIDGET-ID 48
     BUTTON-2 AT ROW 11.96 COL 17 WIDGET-ID 46
     BUTTON-3 AT ROW 11.96 COL 39 WIDGET-ID 50
     "Datos de la Nota de Crédito" VIEW-AS TEXT
          SIZE 20 BY .5 AT ROW 8.31 COL 4 WIDGET-ID 40
          BGCOLOR 9 FGCOLOR 15 
     "Comprobante a Verificar" VIEW-AS TEXT
          SIZE 18 BY .5 AT ROW 1.19 COL 4 WIDGET-ID 30
          BGCOLOR 9 FGCOLOR 15 
     "Cupón de Descuento a Aplicar" VIEW-AS TEXT
          SIZE 22 BY .5 AT ROW 5.04 COL 4 WIDGET-ID 34
          BGCOLOR 9 FGCOLOR 15 
     RECT-1 AT ROW 1.38 COL 2 WIDGET-ID 32
     RECT-2 AT ROW 5.04 COL 2 WIDGET-ID 36
     RECT-3 AT ROW 8.5 COL 2 WIDGET-ID 44
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 86 BY 12.54
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: T-CDOCU T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: T-DDOCU T "?" NO-UNDO INTEGRAL CcbDDocu
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "NOTA DE CREDITOS POR DESCUENTOS X APLICAR"
         HEIGHT             = 12.54
         WIDTH              = 86
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
/* SETTINGS FOR BUTTON BUTTON-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpFinal IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NewImport IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* NOTA DE CREDITOS POR DESCUENTOS X APLICAR */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* NOTA DE CREDITOS POR DESCUENTOS X APLICAR */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Calcular Nuevo Importe */
DO:
  IF FILL-IN-NroRef = '' THEN DO:
      MESSAGE 'Debe ingresar primero un Comprobante válido'
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN-NroRef.
      RETURN NO-APPLY.
  END.
  IF COMBO-BOX-Cupon BEGINS 'Seleccione' THEN DO:
      MESSAGE 'Debe seleccionar un Cupón válido'
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO COMBO-BOX-Cupon.
      RETURN NO-APPLY.
  END.
  /* Calculamos */
  ASSIGN
      FILL-IN-ImpTot.
  RUN Calculamos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Generar Nota de Crédito */
DO:
  ASSIGN
       COMBO-BOX-Cupon COMBO-BOX-Concepto COMBO-BOX-NroSer FILL-IN-ImpFinal.
  IF COMBO-BOX-Concepto BEGINS 'Seleccione' THEN DO:
      MESSAGE 'Debe seleccionar un concepto' VIEW-AS ALERT-BOX.
      APPLY 'ENTRY':U TO COMBO-BOX-Concepto.
      RETURN NO-APPLY.
  END.
  
  MESSAGE 'Se van a generar las Notas de Crédito' SKIP(1)
      'N° de Serie:' COMBO-BOX-NroSer SKIP
      'Moneda:' (IF Ccbcdocu.CodMon = 1 THEN 'Soles' ELSE 'Dólares') SKIP
      'Concepto:' COMBO-BOX-Concepto:SCREEN-VALUE SKIP
      'Fecha de las N/C' TODAY SKIP(1)
      'Continuamos con la generación?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
      UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.

  EMPTY TEMP-TABLE T-FELogErrores.    /* CONTROL DE ERRORES DE FACTURACION ELECTRONICA */
  pMensaje = "".
  RUN Genera-Comprobante.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF pMensaje <> '' THEN MESSAGE pMensaje + CHR(10) +
          'Salga del sistema y vuelva a intentarlo'
          VIEW-AS ALERT-BOX ERROR.
  END.
  RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */
  IF AVAILABLE(Faccorre) THEN RELEASE Faccorre.
  IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Limpiar Filtros */
DO:
   RUN Limpia-Filtros.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodRef W-Win
ON VALUE-CHANGED OF COMBO-BOX-CodRef IN FRAME F-Main /* Referencia */
DO:
    ASSIGN {&self-name}.
    FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.coddoc = COMBO-BOX-CodRef
        AND Ccbcdocu.nrodoc = FILL-IN-NroRef
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbcdoc AND Ccbcdocu.flgest <> 'A' THEN DO:
        DISPLAY
            CcbCDocu.FchDoc @ FILL-IN-FchDoc
            CcbCDocu.CodCli @ FILL-IN-CodCli
            CcbCDocu.NomCli @ FILL-IN-NomCli
            CcbCDocu.ImpTot @ FILL-IN-ImpTot
            WITH FRAME {&FRAME-NAME}.
        ASSIGN
            FILL-IN-ImpTot:LABEL = 'Importe Total ' + (IF Ccbcdocu.codmon = 1 THEN 'S/' ELSE 'US$')
            FILL-IN-ImpFinal:LABEL = 'Importe Final ' + (IF Ccbcdocu.codmon = 1 THEN 'S/' ELSE 'US$').
    END.
    ELSE DO:
        MESSAGE 'Comprobante NO válido' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Cupon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Cupon W-Win
ON VALUE-CHANGED OF COMBO-BOX-Cupon IN FRAME F-Main /* Descuento x Cupón */
DO:
  ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-NroSer W-Win
ON VALUE-CHANGED OF COMBO-BOX-NroSer IN FRAME F-Main /* Serie */
DO:
  ASSIGN {&self-name}.
  FIND FacCorre WHERE FacCorre.CodCia = s-codcia
      AND FacCorre.CodDiv = s-coddiv
      AND FacCorre.CodDoc = s-coddoc
      AND FacCorre.NroSer = COMBO-BOX-NroSer
      NO-LOCK.
  FILL-IN-NroDoc = FacCorre.Correlativo.
  DISPLAY FacCorre.Correlativo @ FILL-IN-NroDoc WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroRef W-Win
ON LEAVE OF FILL-IN-NroRef IN FRAME F-Main /* N° Referencia */
DO:
  ASSIGN {&self-name}.
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
      AND Ccbcdocu.coddoc = COMBO-BOX-CodRef
      AND Ccbcdocu.nrodoc = FILL-IN-NroRef
      NO-LOCK NO-ERROR.
  IF AVAILABLE Ccbcdoc AND Ccbcdocu.flgest <> 'A' THEN DO:
      DISPLAY
          CcbCDocu.FchDoc @ FILL-IN-FchDoc
          CcbCDocu.CodCli @ FILL-IN-CodCli
          CcbCDocu.NomCli @ FILL-IN-NomCli
          CcbCDocu.ImpTot @ FILL-IN-ImpTot
          WITH FRAME {&FRAME-NAME}.
      ASSIGN
          FILL-IN-ImpTot:LABEL = 'Importe Total ' + (IF Ccbcdocu.codmon = 1 THEN 'S/' ELSE 'US$')
          FILL-IN-ImpFinal:LABEL = 'Importe Final ' + (IF Ccbcdocu.codmon = 1 THEN 'S/' ELSE 'US$').
  END.
  ELSE DO:
      MESSAGE 'Comprobante NO válido' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculamos W-Win 
PROCEDURE Calculamos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND VtaCTabla  WHERE VtaCTabla.CodCia = s-codcia
    AND VtaCTabla.Tabla = "UTILEX-ENCARTE"
    AND VtaCTabla.Llave = COMBO-BOX-Cupon
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaCTabla THEN DO:
    MESSAGE 'Código del Cupón de Descuento NO válido' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

DEF VAR pExcepcion AS LOG.
DEF VAR pPorDto2 AS DEC NO-UNDO.
DEF VAR pPreUni  AS DEC NO-UNDO.
DEF VAR pLibre_c04 AS CHAR NO-UNDO.

EMPTY TEMP-TABLE ITEM.

FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
    CREATE ITEM.
    BUFFER-COPY Ccbddocu TO ITEM
        ASSIGN
        ITEM.CanPed = Ccbddocu.candes.
END.

&SCOPED-DEFINE Rutina-Comun ~
    pPreUni = ITEM.PreUni.  /* Valor por defecto */ ~
    pLibre_c04 = "CD".          /* Valor por defecto */ ~
    /* % de Descuento */ ~
    pPorDto2 = (IF VtaDTabla.Libre_d01 > 0 THEN VtaDTabla.Libre_d01 ELSE VtaCTabla.Libre_d01). ~
    IF Vtadtabla.Tipo = "M" AND Vtadtabla.Libre_d02 > 0 THEN DO:~
        /* Caso especial: Tiene definido el Precio Unitario */~
        ASSIGN~
            pLibre_c04 = "UTILEX-ROJO"~
            pPorDto2 = 0~
            pPreUni = Vtadtabla.Libre_d02.~
    END.~
    ELSE IF pPorDto2 = 0 THEN NEXT. ~
    /* Solo productos sin promociones */ ~
    IF VtaCTabla.Libre_L02 = YES AND ~
        ( MAXIMUM( ITEM.Por_Dsctos[1], ITEM.Por_Dsctos[2], ITEM.Por_Dsctos[3] ) > 0 ~
          OR LOOKUP(ITEM.Libre_c04, 'PROM,VOL') > 0 ) ~
        THEN NEXT.~
    /* El mejor descuento */ ~
    IF VtaCTabla.Libre_L01 = YES AND ~
        MAXIMUM( ITEM.Por_Dsctos[1], ITEM.Por_Dsctos[2], ITEM.Por_Dsctos[3] ) > pPorDto2 ~
        THEN NEXT. ~
    /* Buscamos si es una excepción */ ~
    RUN Excepcion-Linea (OUTPUT pExcepcion). ~
    IF pExcepcion = YES THEN NEXT. ~
    ASSIGN ~
        ITEM.Por_Dsctos[1] = 0 ~
        ITEM.Por_Dsctos[2] = 0 ~
        ITEM.Por_Dsctos[3] = 0 ~
        ITEM.PreUni  = pPreUni ~
        ITEM.PorDto2 = pPorDto2 ~
        ITEM.Libre_c04 = pLibre_c04.  /* MARCA DESCUENTO POR ENCARTE */

/* MARCAMOS LOS PRODUCTOS VALIDOS PARA EL ENCARTE */

RLOOP:
DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    FOR EACH ITEM:
        /* Limpiamos controles */
        IF ITEM.PorDto2 > 0 OR LOOKUP(ITEM.Libre_c04, "CD,UTILEX-ROJO") > 0 THEN
            ASSIGN
            ITEM.PorDto2 = 0
            ITEM.Libre_c04 = "".
    END.
    
    /* ******************* POR ARTICULO ****************** */
    rloop1:
    FOR EACH Vtadtabla OF Vtactabla NO-LOCK WHERE Vtadtabla.Tipo = "M":
        FIND FIRST ITEM WHERE ITEM.codmat = Vtadtabla.LlaveDetalle 
            AND LOOKUP(ITEM.Libre_c04, "CD,UTILEX-ROJO") = 0 
            AND ITEM.Libre_c05 <> "OF"
            EXCLUSIVE-LOCK NO-ERROR.
        /* Verificamos el "Operador" */
        CASE TRUE:
            WHEN Vtactabla.Libre_c02 = "OR" THEN DO:    /* Por la compra de cualquiera de los productos */
                IF NOT AVAILABLE ITEM THEN NEXT rloop1.
            END.
            WHEN Vtactabla.Libre_c02 = "AND" THEN DO:    /* Debe comprar todos los productos */
                /* Debe comprarlo */
                IF NOT AVAILABLE ITEM THEN UNDO rloop, LEAVE rloop.
            END.
        END CASE.
        {&Rutina-Comun}
    END.
        
    /* ******************* POR PROVEEDOR ****************** */
    rloop2:
    FOR EACH Vtadtabla OF Vtactabla NO-LOCK WHERE Vtadtabla.Tipo = "P":
        FIND FIRST ITEM WHERE LOOKUP(ITEM.Libre_c04, "CD,UTILEX-ROJO") = 0 
            AND ITEM.Libre_c05 <> "OF" 
            AND CAN-FIND(FIRST Almmmatg OF ITEM WHERE Almmmatg.codpr1 = Vtadtabla.LlaveDetalle NO-LOCK)
            NO-LOCK NO-ERROR.
        /* Verificamos el "Operador" */
        CASE TRUE:
            WHEN Vtactabla.Libre_c03 = "OR" THEN DO:    /* Por la compra de cualquiera de los productos */
                IF NOT AVAILABLE ITEM THEN NEXT rloop2.
            END.
            WHEN Vtactabla.Libre_c03 = "AND" THEN DO:    /* Debe comprar todos los productos */
                /* Debe comprarlo */
                IF NOT AVAILABLE ITEM THEN UNDO rloop, LEAVE rloop.
            END.
        END CASE.
        FOR EACH ITEM WHERE LOOKUP(ITEM.Libre_c04, "CD,UTILEX-ROJO") = 0 AND
            ITEM.Libre_c05 <> "OF",
            FIRST Almmmatg OF ITEM WHERE Almmmatg.codpr1 = Vtadtabla.LlaveDetalle NO-LOCK:
            {&Rutina-Comun}
        END.
    END.
    
    /* ******************* POR LINEAS ****************** */
    rloop3:
    FOR EACH Vtadtabla OF Vtactabla NO-LOCK WHERE Vtadtabla.Tipo = "L":
        FIND FIRST ITEM WHERE LOOKUP(ITEM.Libre_c04, "CD,UTILEX-ROJO") = 0 
            AND ITEM.Libre_c05 <> "OF" 
            AND CAN-FIND(FIRST Almmmatg OF ITEM WHERE Almmmatg.codfam = Vtadtabla.LlaveDetalle AND 
                     (Vtadtabla.Libre_c01 = "" OR Almmmatg.subfam = Vtadtabla.Libre_c01) NO-LOCK)
            NO-LOCK NO-ERROR.
        /* Verificamos el "Operador" */
        CASE TRUE:
            WHEN Vtactabla.Libre_c05 = "OR" THEN DO:    /* Por la compra de cualquiera de los productos */
                IF NOT AVAILABLE ITEM THEN NEXT rloop3.
            END.
            WHEN Vtactabla.Libre_c05 = "AND" THEN DO:    /* Debe comprar todos los productos */
                /* Debe comprarlo */
                IF NOT AVAILABLE ITEM THEN UNDO rloop, LEAVE rloop.
            END.
        END CASE.
        FOR EACH ITEM WHERE LOOKUP(ITEM.Libre_c04, "CD,UTILEX-ROJO") = 0 
            AND ITEM.Libre_c05 <> "OF",
            FIRST Almmmatg OF ITEM NO-LOCK WHERE Almmmatg.codfam = Vtadtabla.LlaveDetalle AND 
            (Vtadtabla.Libre_c01 = "" OR Almmmatg.subfam = Vtadtabla.Libre_c01):
            {&Rutina-Comun}
        END.
    END.
    
END.

/* CALCULO FINAL */
x-ImpDto2 = 0.
FOR EACH ITEM WHERE LOOKUP(ITEM.Libre_c04, "CD,UTILEX-ROJO") > 0, 
    FIRST Almmmatg OF ITEM NO-LOCK:
    ASSIGN
        ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni * 
        ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
        ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
        ( 1 - ITEM.Por_Dsctos[3] / 100 )
        ITEM.ImpDto2 = ROUND ( ITEM.ImpLin * ITEM.PorDto2 / 100, 2).
    IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
        THEN ITEM.ImpDto = 0.
    ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
    ASSIGN
        ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
        ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
    IF ITEM.AftIsc 
        THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
    IF ITEM.AftIgv 
        THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (Ccbcdocu.PorIgv / 100) ), 4 ).
    ASSIGN
        x-ImpDto2 = x-ImpDto2 + ITEM.ImpDto2.
END.

/* CALCULO FINAL */
ASSIGN
    x-ImpDto2 = 0.
FOR EACH ITEM WHERE LOOKUP(ITEM.Libre_c04, "CD") > 0:
    x-ImpDto2 = x-ImpDto2 + ITEM.ImpDto2.
END.
IF VtaCTabla.Libre_d02 > 0 THEN DO:
    DEF VAR y-ImpDto2 LIKE Faccpedi.ImpDto2 NO-UNDO.
    y-ImpDto2 = x-ImpDto2.
    x-ImpDto2 = MINIMUM(x-ImpDto2, VtaCTabla.Libre_d02).
    IF y-ImpDto2 <> x-ImpDto2 THEN DO:
        FOR EACH ITEM WHERE ITEM.PorDto2 > 0:
            ITEM.ImpDto2 = ROUND (ITEM.ImpDto2 * ( x-ImpDto2 / y-ImpDto2 ), 2).
        END.
    END.
END.


/* FINALES */
  ASSIGN
      x-ImpDto2 = 0
      FILL-IN-NewImport = 0.
    
  FOR EACH ITEM NO-LOCK: 
      x-ImpDto2 = x-ImpDto2 + ITEM.ImpDto2.
      FILL-IN-NewImport = FILL-IN-NewImport + ITEM.ImpLin.
  END.
  /* RHC 06/05/2014 En caso tenga descuento por Encarte */
  IF x-ImpDto2 > 0 THEN DO:
      ASSIGN
          FILL-IN-NewImport = FILL-IN-NewImport - x-ImpDto2.
  END.

  /* Importe final */
  
  FILL-IN-ImpFinal = FILL-IN-ImpTot - FILL-IN-NewImport.
  IF FILL-IN-ImpFinal < 0  THEN FILL-IN-ImpFinal = 0.
  DISPLAY FILL-IN-NewImport FILL-IN-ImpFinal WITH FRAME {&FRAME-NAME}.

  /* En caso de ser positivo ya podemos generar la N/C */
  IF FILL-IN-ImpFinal > 0 THEN DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          COMBO-BOX-CodRef:SENSITIVE = NO
          COMBO-BOX-Cupon:SENSITIVE = NO
          BUTTON-1:SENSITIVE = NO
          BUTTON-2:SENSITIVE = YES
          FILL-IN-NroRef:SENSITIVE = NO.
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
  DISPLAY COMBO-BOX-CodRef FILL-IN-NroRef FILL-IN-FchDoc FILL-IN-CodCli 
          FILL-IN-NomCli FILL-IN-ImpTot COMBO-BOX-Cupon FILL-IN-NewImport 
          FILL-IN-CodDoc COMBO-BOX-NroSer FILL-IN-NroDoc COMBO-BOX-Concepto 
          FILL-IN-ImpFinal 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 RECT-3 COMBO-BOX-CodRef FILL-IN-NroRef COMBO-BOX-Cupon 
         BUTTON-1 COMBO-BOX-NroSer COMBO-BOX-Concepto BtnDone BUTTON-3 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excepcion-Linea W-Win 
PROCEDURE Excepcion-Linea :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pExcepcion AS LOG.

pExcepcion = NO.

/* Por Linea y/o Sublinea */
FIND B-TABLA OF Vtactabla WHERE B-TABLA.LlaveDetalle = Almmmatg.codfam
    AND B-TABLA.Libre_c01 = Almmmatg.subfam
    AND B-TABLA.Tipo = "XL"
    NO-LOCK NO-ERROR.
IF AVAILABLE B-TABLA THEN pExcepcion = YES.
FIND B-TABLA OF Vtactabla WHERE B-TABLA.LlaveDetalle = Almmmatg.codfam
    AND B-TABLA.Libre_c01 = ""
    AND B-TABLA.Tipo = "XL"
    NO-LOCK NO-ERROR.
IF AVAILABLE B-TABLA THEN pExcepcion = YES.
/* Por Producto */
FIND B-TABLA OF Vtactabla WHERE B-TABLA.LlaveDetalle = Almmmatg.codmat
    AND B-TABLA.Tipo = "XM"
    NO-LOCK NO-ERROR.
IF AVAILABLE B-TABLA THEN pExcepcion = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Comprobante W-Win 
PROCEDURE Genera-Comprobante :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DISABLE TRIGGERS FOR LOAD OF Ccbcdocu.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND FIRST Faccfggn WHERE codcia = s-codcia NO-LOCK.
    FIND Faccorre WHERE FacCorre.CodCia = s-codcia
        AND FacCorre.CodDiv = s-coddiv
        AND FacCorre.CodDoc = s-coddoc
        AND FacCorre.NroSer = COMBO-BOX-NroSer
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCorre THEN RETURN.

    EMPTY TEMP-TABLE t-cdocu.
    EMPTY TEMP-TABLE t-ddocu.

    FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia
      AND Ccbcdocu.coddoc = COMBO-BOX-CodRef
      AND Ccbcdocu.nrodoc = FILL-IN-NroRef
      NO-LOCK.
    CREATE t-cdocu.
    ASSIGN
        t-cdocu.codcia = s-codcia
        t-cdocu.coddoc = s-coddoc
        t-cdocu.coddiv = s-coddiv
        t-cdocu.nrodoc = STRING(Faccorre.nroser, ENTRY(1, x-Formato, '-')) +
                            STRING(Faccorre.correlativo, ENTRY(2, x-Formato, '-'))
        t-cdocu.fchdoc = TODAY
        t-cdocu.fchvto = ADD-INTERVAL (TODAY, 1, 'years')
        t-cdocu.codcli = ccbcdocu.codcli
        t-cdocu.ruccli = ccbcdocu.ruccli
        t-cdocu.nomcli = ccbcdocu.nomcli
        t-cdocu.dircli = ccbcdocu.dircli
        t-cdocu.porigv = ( IF ccbcdocu.porigv > 0 THEN ccbcdocu.porigv ELSE FacCfgGn.PorIgv )
        t-cdocu.codmon = ccbcdocu.codmon
        t-cdocu.usuario = s-user-id
        t-cdocu.tpocmb = Faccfggn.tpocmb[1]
        t-cdocu.codref = ccbcdocu.coddoc
        t-cdocu.nroref = ccbcdocu.nrodoc
        t-cdocu.codven = ccbcdocu.codven
        t-cdocu.cndcre = 'N'
        t-cdocu.fmapgo = ccbcdocu.fmapgo
        t-cdocu.tpofac = ""
        t-cdocu.divori = ccbcdocu.coddiv   /* OJO */
        t-cdocu.tipo   = "CREDITO"          /* SUNAT */
        t-cdocu.codcaja= "".
    /* ACTUALIZAMOS EL CENTRO DE COSTO */
    FIND GN-VEN WHERE GN-VEN.codcia = s-codcia
        AND GN-VEN.codven = t-cdocu.codven NO-LOCK NO-ERROR.
    IF AVAILABLE GN-VEN THEN t-cdocu.cco = GN-VEN.cco.
    ASSIGN
        Faccorre.correlativo = Faccorre.correlativo + 1.
    FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia
        AND CcbTabla.Tabla  = 'N/C' 
        AND CcbTabla.Codigo = COMBO-BOX-Concepto NO-LOCK.
    CREATE t-ddocu.
    BUFFER-COPY t-cdocu TO t-ddocu.
    ASSIGN
        t-ddocu.codmat = CcbTabla.Codigo
        t-ddocu.factor = 1
        t-ddocu.candes = 1
        t-ddocu.preuni = FILL-IN-ImpFinal
        t-ddocu.implin = t-ddocu.CanDes * t-ddocu.PreUni.
    IF CcbTabla.Afecto THEN
        ASSIGN
        t-ddocu.AftIgv = Yes
        t-ddocu.ImpIgv = (t-ddocu.CanDes * t-ddocu.PreUni) * ((t-cdocu.PorIgv / 100) / (1 + (t-cdocu.PorIgv / 100))).
    ELSE
        ASSIGN
        t-ddocu.AftIgv = No
        t-ddocu.ImpIgv = 0.
    t-ddocu.NroItm = 1.
    ASSIGN
      t-cdocu.ImpBrt = 0
      t-cdocu.ImpExo = 0
      t-cdocu.ImpDto = 0
      t-cdocu.ImpIgv = 0
      t-cdocu.ImpTot = 0.
    FOR EACH t-ddocu OF t-cdocu NO-LOCK:
      ASSIGN
            t-cdocu.ImpBrt = t-cdocu.ImpBrt + (IF t-ddocu.AftIgv = Yes THEN t-ddocu.PreUni * t-ddocu.CanDes ELSE 0)
            t-cdocu.ImpExo = t-cdocu.ImpExo + (IF t-ddocu.AftIgv = No  THEN t-ddocu.PreUni * t-ddocu.CanDes ELSE 0)
            t-cdocu.ImpDto = t-cdocu.ImpDto + t-ddocu.ImpDto
            t-cdocu.ImpIgv = t-cdocu.ImpIgv + t-ddocu.ImpIgv
            t-cdocu.ImpTot = t-cdocu.ImpTot + t-ddocu.ImpLin.
    END.
    ASSIGN 
        t-cdocu.ImpVta = t-cdocu.ImpBrt - t-cdocu.ImpIgv
        t-cdocu.ImpBrt = t-cdocu.ImpBrt - t-cdocu.ImpIgv + t-cdocu.ImpDto
        t-cdocu.SdoAct = t-cdocu.ImpTot
        t-cdocu.FlgEst = 'P'.

    CREATE ccbcdocu.
    BUFFER-COPY t-cdocu TO ccbcdocu NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "ERROR: No se pudo generar la Nota de Crédito".
        UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    END.
    FOR EACH t-ddocu OF t-cdocu:
        CREATE ccbddocu.
        BUFFER-COPY t-ddocu TO ccbddocu.
    END.
    /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
/*     RUN sunat\progress-to-ppll-v21 ( INPUT ROWID(Ccbcdocu),             */
/*                                      INPUT-OUTPUT TABLE T-FELogErrores, */
/*                                      OUTPUT pMensaje ).                 */
    RUN sunat\progress-to-ppll-v3 ( INPUT Ccbcdocu.coddiv,
                                    INPUT Ccbcdocu.coddoc,
                                    INPUT Ccbcdocu.nrodoc,
                                    INPUT-OUTPUT TABLE T-FELogErrores,
                                    OUTPUT pMensaje ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = "ERROR: No se pudo generar la Factura Electrónica".
        UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    END.
    IF RETURN-VALUE = 'ERROR-POS' THEN DO:
        IF pMensaje = "" THEN pMensaje = "ERROR: No se pudo Confirmar la Factura Electrónica".
        RETURN 'ADM-ERROR'.
    END.
    /* *********************************************************** */
    /* Replica */
    RUN Replicar.
    FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
        RUN Replicar-Detalle.
    END.
    RUN Limpia-Filtros.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Temp-FeLogErrores W-Win 
PROCEDURE Graba-Temp-FeLogErrores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH T-FeLogErrores:
    CREATE FeLogErrores.
    BUFFER-COPY T-FeLogErrores TO FeLogErrores NO-ERROR.
    DELETE T-FeLogErrores.
END.
IF AVAILABLE(FeLogErrores) THEN RELEASE FeLogErrores.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Limpia-Filtros W-Win 
PROCEDURE Limpia-Filtros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        COMBO-BOX-Concepto = 'Seleccione concepto'
        FILL-IN-CodCli = ''
        COMBO-BOX-Cupon  = 'Seleccione un Cupón'
        FILL-IN-FchDoc = ?
        FILL-IN-ImpFinal = 0
        FILL-IN-ImpTot   = 0
        FILL-IN-NewImport = 0
        FILL-IN-NomCli = ''
        FILL-IN-NroDoc = 0
        FILL-IN-NroRef = ''.
    APPLY 'VALUE-CHANGED':U TO COMBO-BOX-NroSer.
    ASSIGN
        FILL-IN-NroRef:SENSITIVE = YES
        COMBO-BOX-Cupon:SENSITIVE = YES
        BUTTON-1:SENSITIVE = YES
        BUTTON-2:SENSITIVE = NO.
    DISPLAY 
        COMBO-BOX-Concepto
        FILL-IN-CodCli 
        COMBO-BOX-Cupon  
        FILL-IN-FchDoc 
        FILL-IN-ImpFinal 
        FILL-IN-ImpTot   
        FILL-IN-NewImport
        FILL-IN-NomCli 
        FILL-IN-NroDoc 
        FILL-IN-NroRef.
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
  ASSIGN
      FILL-IN-CodDoc = s-CodDoc.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DEF VAR cListItems AS CHAR NO-UNDO.
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-NroSer:DELETE(1).
/*       FOR EACH FacCorre NO-LOCK WHERE FacCorre.CodCia = s-codcia        */
/*           AND FacCorre.CodDiv = s-coddiv                                */
/*           AND FacCorre.CodDoc = s-coddoc                                */
/*           AND FacCorre.FlgEst = YES:                                    */
/*           COMBO-BOX-NroSer:ADD-LAST(STRING(FacCorre.NroSer)).           */
/*       END.                                                              */
      {sunat\i-lista-series.i &CodCia=s-CodCia ~
          &CodDiv=s-CodDiv ~
          &CodDoc=s-CodDoc ~
          &FlgEst='' ~          /* En blanco si quieres solo ACTIVOS */
          &Tipo='CREDITO' ~
          &ListaSeries=cListItems ~
          }
      COMBO-BOX-NroSer:ADD-LAST(cListItems).
      COMBO-BOX-NroSer:SCREEN-VALUE = COMBO-BOX-NroSer:ENTRY(1).

      FIND FacCorre WHERE FacCorre.CodCia = s-codcia
          AND FacCorre.CodDiv = s-coddiv
          AND FacCorre.CodDoc = s-coddoc
          AND FacCorre.NroSer = INTEGER(COMBO-BOX-NroSer:ENTRY(1))
          NO-LOCK.
      DISPLAY FacCorre.Correlativo @ FILL-IN-NroDoc.
      FOR EACH CcbTabla NO-LOCK WHERE CcbTabla.CodCia = s-codcia
          AND CcbTabla.Tabla = s-CodDoc
          AND CcbTabla.Codigo = '00003'
          AND CcbTabla.Libre_L02 = YES:
           COMBO-BOX-Concepto:ADD-LAST(CcbTabla.Nombre,CcbTabla.Codigo).
      END.
      FOR EACH VtaCTabla NO-LOCK WHERE VtaCTabla.CodCia = s-codcia 
          AND LOOKUP(VtaCTabla.Llave , '896314,321496') > 0
          AND VtaCTabla.Tabla = "UTILEX-ENCARTE":
          COMBO-BOX-Cupon:ADD-LAST(VtaCTabla.Descripcion,VtaCTabla.Llave).
      END.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Replicar W-Win 
PROCEDURE Replicar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN
    lFlgDB1 = YES
    lFlgDB2 = YES
    lFlgDB3 = YES
    lFlgDB4 = YES
    lFlgDB5 = YES
    lFlgDB6 = YES
    lFlgDB8 = YES
    lFlgDB9 = YES
    lFlgDB11 = YES
    lFlgDB12 = YES
    lFlgDB20 = YES.
CASE Ccbcdocu.DivOri:
    WHEN '00501' THEN DO:
        {rpl/reptrig.i
        &Table  = ccbcdocu
        &Key    = "string(ccbcdocu.codcia,'999') + string(ccbcdocu.coddiv, 'x(5)') ~
            + string(ccbcdocu.coddoc, 'x(3)') + string(ccbcdocu.nrodoc, 'x(15)') "
        &Prg    = r-ccbcdocu
        &Event  = WRITE
        &FlgDB0 = TRUE
        &FlgDB1 = NO
        &FlgDB2 = TRUE
        &FlgDB3 = TRUE
        &FlgDB4 = TRUE
        &FlgDB5 = TRUE
        &FlgDB6 = TRUE
        &FlgDB7 = TRUE
        &FlgDB8 = TRUE
        &FlgDB9 = TRUE
        &FlgDB10 = TRUE
        &FlgDB11 = TRUE
        &FlgDB12 = TRUE
        &FlgDB13 = TRUE
        &FlgDB14 = TRUE
        &FlgDB15 = TRUE
        &FlgDB16 = TRUE
        &FlgDB17 = TRUE
        &FlgDB18 = TRUE
        &FlgDB19 = TRUE
        &FlgDB20 = TRUE
        }
    END.
    WHEN '00023' THEN DO:
        {rpl/reptrig.i
        &Table  = ccbcdocu
        &Key    = "string(ccbcdocu.codcia,'999') + string(ccbcdocu.coddiv, 'x(5)') ~
            + string(ccbcdocu.coddoc, 'x(3)') + string(ccbcdocu.nrodoc, 'x(15)') "
        &Prg    = r-ccbcdocu
        &Event  = WRITE
        &FlgDB0 = TRUE
        &FlgDB1 = TRUE
        &FlgDB2 = NO
        &FlgDB3 = TRUE
        &FlgDB4 = TRUE
        &FlgDB5 = TRUE
        &FlgDB6 = TRUE
        &FlgDB7 = TRUE
        &FlgDB8 = TRUE
        &FlgDB9 = TRUE
        &FlgDB10 = TRUE
        &FlgDB11 = TRUE
        &FlgDB12 = TRUE
        &FlgDB13 = TRUE
        &FlgDB14 = TRUE
        &FlgDB15 = TRUE
        &FlgDB16 = TRUE
        &FlgDB17 = TRUE
        &FlgDB18 = TRUE
        &FlgDB19 = TRUE
        &FlgDB20 = TRUE
        }

    END.
    WHEN '00027' THEN DO:
        {rpl/reptrig.i
        &Table  = ccbcdocu
        &Key    = "string(ccbcdocu.codcia,'999') + string(ccbcdocu.coddiv, 'x(5)') ~
            + string(ccbcdocu.coddoc, 'x(3)') + string(ccbcdocu.nrodoc, 'x(15)') "
        &Prg    = r-ccbcdocu
        &Event  = WRITE
        &FlgDB0 = TRUE
        &FlgDB1 = TRUE
        &FlgDB2 = TRUE
        &FlgDB3 = NO
        &FlgDB4 = TRUE
        &FlgDB5 = TRUE
        &FlgDB6 = TRUE
        &FlgDB7 = TRUE
        &FlgDB8 = TRUE
        &FlgDB9 = TRUE
        &FlgDB10 = TRUE
        &FlgDB11 = TRUE
        &FlgDB12 = TRUE
        &FlgDB13 = TRUE
        &FlgDB14 = TRUE
        &FlgDB15 = TRUE
        &FlgDB16 = TRUE
        &FlgDB17 = TRUE
        &FlgDB18 = TRUE
        &FlgDB19 = TRUE
        &FlgDB20 = TRUE
        }

    END.
    WHEN '00502' THEN DO:
        {rpl/reptrig.i
        &Table  = ccbcdocu
        &Key    = "string(ccbcdocu.codcia,'999') + string(ccbcdocu.coddiv, 'x(5)') ~
            + string(ccbcdocu.coddoc, 'x(3)') + string(ccbcdocu.nrodoc, 'x(15)') "
        &Prg    = r-ccbcdocu
        &Event  = WRITE
        &FlgDB0 = TRUE
        &FlgDB1 = TRUE
        &FlgDB2 = TRUE
        &FlgDB3 = TRUE
        &FlgDB4 = TRUE
        &FlgDB5 = TRUE
        &FlgDB6 = TRUE
        &FlgDB7 = TRUE
        &FlgDB8 = TRUE
        &FlgDB9 = TRUE
        &FlgDB10 = TRUE
        &FlgDB11 = TRUE
        &FlgDB12 = TRUE
        &FlgDB13 = TRUE
        &FlgDB14 = TRUE
        &FlgDB15 = TRUE
        &FlgDB16 = TRUE
        &FlgDB17 = TRUE
        &FlgDB18 = TRUE
        &FlgDB19 = TRUE
        &FlgDB20 = NO
        }

    END.
    WHEN '00503' THEN DO:
        {rpl/reptrig.i
        &Table  = ccbcdocu
        &Key    = "string(ccbcdocu.codcia,'999') + string(ccbcdocu.coddiv, 'x(5)') ~
            + string(ccbcdocu.coddoc, 'x(3)') + string(ccbcdocu.nrodoc, 'x(15)') "
        &Prg    = r-ccbcdocu
        &Event  = WRITE
        &FlgDB0 = TRUE
        &FlgDB1 = TRUE
        &FlgDB2 = TRUE
        &FlgDB3 = TRUE
        &FlgDB4 = TRUE
        &FlgDB5 = NO
        &FlgDB6 = TRUE
        &FlgDB7 = TRUE
        &FlgDB8 = TRUE
        &FlgDB9 = TRUE
        &FlgDB10 = TRUE
        &FlgDB11 = TRUE
        &FlgDB12 = TRUE
        &FlgDB13 = TRUE
        &FlgDB14 = TRUE
        &FlgDB15 = TRUE
        &FlgDB16 = TRUE
        &FlgDB17 = TRUE
        &FlgDB18 = TRUE
        &FlgDB19 = TRUE
        &FlgDB20 = TRUE
        }

    END.
    WHEN '00504' THEN DO:
        {rpl/reptrig.i
        &Table  = ccbcdocu
        &Key    = "string(ccbcdocu.codcia,'999') + string(ccbcdocu.coddiv, 'x(5)') ~
            + string(ccbcdocu.coddoc, 'x(3)') + string(ccbcdocu.nrodoc, 'x(15)') "
        &Prg    = r-ccbcdocu
        &Event  = WRITE
        &FlgDB0 = TRUE
        &FlgDB1 = TRUE
        &FlgDB2 = TRUE
        &FlgDB3 = TRUE
        &FlgDB4 = TRUE
        &FlgDB5 = TRUE
        &FlgDB6 = TRUE
        &FlgDB7 = TRUE
        &FlgDB8 = TRUE
        &FlgDB9 = TRUE
        &FlgDB10 = TRUE
        &FlgDB11 = TRUE
        &FlgDB12 = TRUE
        &FlgDB13 = TRUE
        &FlgDB14 = TRUE
        &FlgDB15 = TRUE
        &FlgDB16 = TRUE
        &FlgDB17 = TRUE
        &FlgDB18 = TRUE
        &FlgDB19 = TRUE
        &FlgDB20 = NO
        }

    END.
    WHEN '00508' THEN DO:
        {rpl/reptrig.i
        &Table  = ccbcdocu
        &Key    = "string(ccbcdocu.codcia,'999') + string(ccbcdocu.coddiv, 'x(5)') ~
            + string(ccbcdocu.coddoc, 'x(3)') + string(ccbcdocu.nrodoc, 'x(15)') "
        &Prg    = r-ccbcdocu
        &Event  = WRITE
        &FlgDB0 = TRUE
        &FlgDB1 = TRUE
        &FlgDB2 = TRUE
        &FlgDB3 = TRUE
        &FlgDB4 = TRUE
        &FlgDB5 = TRUE
        &FlgDB6 = TRUE
        &FlgDB7 = TRUE
        &FlgDB8 = TRUE
        &FlgDB9 = NO
        &FlgDB10 = TRUE
        &FlgDB11 = TRUE
        &FlgDB12 = TRUE
        &FlgDB13 = TRUE
        &FlgDB14 = TRUE
        &FlgDB15 = TRUE
        &FlgDB16 = TRUE
        &FlgDB17 = TRUE
        &FlgDB18 = TRUE
        &FlgDB19 = TRUE
        &FlgDB20 = TRUE
        }

    END.
    WHEN '00510' THEN DO:
        {rpl/reptrig.i
        &Table  = ccbcdocu
        &Key    = "string(ccbcdocu.codcia,'999') + string(ccbcdocu.coddiv, 'x(5)') ~
            + string(ccbcdocu.coddoc, 'x(3)') + string(ccbcdocu.nrodoc, 'x(15)') "
        &Prg    = r-ccbcdocu
        &Event  = WRITE
        &FlgDB0 = TRUE
        &FlgDB1 = TRUE
        &FlgDB2 = TRUE
        &FlgDB3 = TRUE
        &FlgDB4 = TRUE
        &FlgDB5 = TRUE
        &FlgDB6 = TRUE
        &FlgDB7 = TRUE
        &FlgDB8 = TRUE
        &FlgDB9 = TRUE
        &FlgDB10 = TRUE
        &FlgDB11 = NO
        &FlgDB12 = TRUE
        &FlgDB13 = TRUE
        &FlgDB14 = TRUE
        &FlgDB15 = TRUE
        &FlgDB16 = TRUE
        &FlgDB17 = TRUE
        &FlgDB18 = TRUE
        &FlgDB19 = TRUE
        &FlgDB20 = TRUE
        }

    END.
    WHEN '00511' THEN DO:
        {rpl/reptrig.i
        &Table  = ccbcdocu
        &Key    = "string(ccbcdocu.codcia,'999') + string(ccbcdocu.coddiv, 'x(5)') ~
            + string(ccbcdocu.coddoc, 'x(3)') + string(ccbcdocu.nrodoc, 'x(15)') "
        &Prg    = r-ccbcdocu
        &Event  = WRITE
        &FlgDB0 = TRUE
        &FlgDB1 = TRUE
        &FlgDB2 = TRUE
        &FlgDB3 = TRUE
        &FlgDB4 = TRUE
        &FlgDB5 = TRUE
        &FlgDB6 = TRUE
        &FlgDB7 = TRUE
        &FlgDB8 = TRUE
        &FlgDB9 = TRUE
        &FlgDB10 = TRUE
        &FlgDB11 = TRUE
        &FlgDB12 = NO
        &FlgDB13 = TRUE
        &FlgDB14 = TRUE
        &FlgDB15 = TRUE
        &FlgDB16 = TRUE
        &FlgDB17 = TRUE
        &FlgDB18 = TRUE
        &FlgDB19 = TRUE
        &FlgDB20 = TRUE
        }

    END.
END CASE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Replicar-Detalle W-Win 
PROCEDURE Replicar-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

CASE ccbcdocu.DivOri:
    WHEN '00501' THEN DO:
        {rpl/reptrig.i
        &Table  = ccbddocu
    &Key    =  "string(ccbddocu.codcia,'999') + string(ccbddocu.coddiv,'x(5)') ~
        + string(ccbddocu.coddoc,'x(3)') + string(ccbddocu.nrodoc,'x(15)') ~
        + string(ccbddocu.codmat,'x(6)')"
        &Prg    = r-ccbddocu
        &Event  = WRITE
        &FlgDB0 = TRUE
        &FlgDB1 = NO
        &FlgDB2 = TRUE
        &FlgDB3 = TRUE
        &FlgDB4 = TRUE
        &FlgDB5 = TRUE
        &FlgDB6 = TRUE
        &FlgDB7 = TRUE
        &FlgDB8 = TRUE
        &FlgDB9 = TRUE
        &FlgDB10 = TRUE
        &FlgDB11 = TRUE
        &FlgDB12 = TRUE
        &FlgDB13 = TRUE
        &FlgDB14 = TRUE
        &FlgDB15 = TRUE
        &FlgDB16 = TRUE
        &FlgDB17 = TRUE
        &FlgDB18 = TRUE
        &FlgDB19 = TRUE
        &FlgDB20 = TRUE
        }
    END.
    WHEN '00023' THEN DO:
        {rpl/reptrig.i
        &Table  = ccbddocu
    &Key    =  "string(ccbddocu.codcia,'999') + string(ccbddocu.coddiv,'x(5)') ~
        + string(ccbddocu.coddoc,'x(3)') + string(ccbddocu.nrodoc,'x(15)') ~
        + string(ccbddocu.codmat,'x(6)')"
        &Prg    = r-ccbddocu
        &Event  = WRITE
        &FlgDB0 = TRUE
        &FlgDB1 = TRUE
        &FlgDB2 = NO
        &FlgDB3 = TRUE
        &FlgDB4 = TRUE
        &FlgDB5 = TRUE
        &FlgDB6 = TRUE
        &FlgDB7 = TRUE
        &FlgDB8 = TRUE
        &FlgDB9 = TRUE
        &FlgDB10 = TRUE
        &FlgDB11 = TRUE
        &FlgDB12 = TRUE
        &FlgDB13 = TRUE
        &FlgDB14 = TRUE
        &FlgDB15 = TRUE
        &FlgDB16 = TRUE
        &FlgDB17 = TRUE
        &FlgDB18 = TRUE
        &FlgDB19 = TRUE
        &FlgDB20 = TRUE
        }

    END.
    WHEN '00027' THEN DO:
        {rpl/reptrig.i
        &Table  = ccbddocu
    &Key    =  "string(ccbddocu.codcia,'999') + string(ccbddocu.coddiv,'x(5)') ~
        + string(ccbddocu.coddoc,'x(3)') + string(ccbddocu.nrodoc,'x(15)') ~
        + string(ccbddocu.codmat,'x(6)')"
        &Prg    = r-ccbddocu
        &Event  = WRITE
        &FlgDB0 = TRUE
        &FlgDB1 = TRUE
        &FlgDB2 = TRUE
        &FlgDB3 = NO
        &FlgDB4 = TRUE
        &FlgDB5 = TRUE
        &FlgDB6 = TRUE
        &FlgDB7 = TRUE
        &FlgDB8 = TRUE
        &FlgDB9 = TRUE
        &FlgDB10 = TRUE
        &FlgDB11 = TRUE
        &FlgDB12 = TRUE
        &FlgDB13 = TRUE
        &FlgDB14 = TRUE
        &FlgDB15 = TRUE
        &FlgDB16 = TRUE
        &FlgDB17 = TRUE
        &FlgDB18 = TRUE
        &FlgDB19 = TRUE
        &FlgDB20 = TRUE
        }

    END.
    WHEN '00502' THEN DO:
        {rpl/reptrig.i
        &Table  = ccbddocu
    &Key    =  "string(ccbddocu.codcia,'999') + string(ccbddocu.coddiv,'x(5)') ~
        + string(ccbddocu.coddoc,'x(3)') + string(ccbddocu.nrodoc,'x(15)') ~
        + string(ccbddocu.codmat,'x(6)')"
        &Prg    = r-ccbddocu
        &Event  = WRITE
        &FlgDB0 = TRUE
        &FlgDB1 = TRUE
        &FlgDB2 = TRUE
        &FlgDB3 = TRUE
        &FlgDB4 = TRUE
        &FlgDB5 = TRUE
        &FlgDB6 = TRUE
        &FlgDB7 = TRUE
        &FlgDB8 = TRUE
        &FlgDB9 = TRUE
        &FlgDB10 = TRUE
        &FlgDB11 = TRUE
        &FlgDB12 = TRUE
        &FlgDB13 = TRUE
        &FlgDB14 = TRUE
        &FlgDB15 = TRUE
        &FlgDB16 = TRUE
        &FlgDB17 = TRUE
        &FlgDB18 = TRUE
        &FlgDB19 = TRUE
        &FlgDB20 = NO
        }

    END.
    WHEN '00503' THEN DO:
        {rpl/reptrig.i
        &Table  = ccbddocu
    &Key    =  "string(ccbddocu.codcia,'999') + string(ccbddocu.coddiv,'x(5)') ~
        + string(ccbddocu.coddoc,'x(3)') + string(ccbddocu.nrodoc,'x(15)') ~
        + string(ccbddocu.codmat,'x(6)')"
        &Prg    = r-ccbddocu
        &Event  = WRITE
        &FlgDB0 = TRUE
        &FlgDB1 = TRUE
        &FlgDB2 = TRUE
        &FlgDB3 = TRUE
        &FlgDB4 = TRUE
        &FlgDB5 = NO
        &FlgDB6 = TRUE
        &FlgDB7 = TRUE
        &FlgDB8 = TRUE
        &FlgDB9 = TRUE
        &FlgDB10 = TRUE
        &FlgDB11 = TRUE
        &FlgDB12 = TRUE
        &FlgDB13 = TRUE
        &FlgDB14 = TRUE
        &FlgDB15 = TRUE
        &FlgDB16 = TRUE
        &FlgDB17 = TRUE
        &FlgDB18 = TRUE
        &FlgDB19 = TRUE
        &FlgDB20 = TRUE
        }

    END.
    WHEN '00504' THEN DO:
        {rpl/reptrig.i
        &Table  = ccbddocu
    &Key    =  "string(ccbddocu.codcia,'999') + string(ccbddocu.coddiv,'x(5)') ~
        + string(ccbddocu.coddoc,'x(3)') + string(ccbddocu.nrodoc,'x(15)') ~
        + string(ccbddocu.codmat,'x(6)')"
        &Prg    = r-ccbddocu
        &Event  = WRITE
        &FlgDB0 = TRUE
        &FlgDB1 = TRUE
        &FlgDB2 = TRUE
        &FlgDB3 = TRUE
        &FlgDB4 = TRUE
        &FlgDB5 = TRUE
        &FlgDB6 = TRUE
        &FlgDB7 = TRUE
        &FlgDB8 = TRUE
        &FlgDB9 = TRUE
        &FlgDB10 = TRUE
        &FlgDB11 = TRUE
        &FlgDB12 = TRUE
        &FlgDB13 = TRUE
        &FlgDB14 = TRUE
        &FlgDB15 = TRUE
        &FlgDB16 = TRUE
        &FlgDB17 = TRUE
        &FlgDB18 = TRUE
        &FlgDB19 = TRUE
        &FlgDB20 = NO
        }

    END.
    WHEN '00508' THEN DO:
        {rpl/reptrig.i
        &Table  = ccbddocu
    &Key    =  "string(ccbddocu.codcia,'999') + string(ccbddocu.coddiv,'x(5)') ~
        + string(ccbddocu.coddoc,'x(3)') + string(ccbddocu.nrodoc,'x(15)') ~
        + string(ccbddocu.codmat,'x(6)')"
        &Prg    = r-ccbddocu
        &Event  = WRITE
        &FlgDB0 = TRUE
        &FlgDB1 = TRUE
        &FlgDB2 = TRUE
        &FlgDB3 = TRUE
        &FlgDB4 = TRUE
        &FlgDB5 = TRUE
        &FlgDB6 = TRUE
        &FlgDB7 = TRUE
        &FlgDB8 = TRUE
        &FlgDB9 = NO
        &FlgDB10 = TRUE
        &FlgDB11 = TRUE
        &FlgDB12 = TRUE
        &FlgDB13 = TRUE
        &FlgDB14 = TRUE
        &FlgDB15 = TRUE
        &FlgDB16 = TRUE
        &FlgDB17 = TRUE
        &FlgDB18 = TRUE
        &FlgDB19 = TRUE
        &FlgDB20 = TRUE
        }

    END.
    WHEN '00510' THEN DO:
        {rpl/reptrig.i
        &Table  = ccbddocu
    &Key    =  "string(ccbddocu.codcia,'999') + string(ccbddocu.coddiv,'x(5)') ~
        + string(ccbddocu.coddoc,'x(3)') + string(ccbddocu.nrodoc,'x(15)') ~
        + string(ccbddocu.codmat,'x(6)')"
        &Prg    = r-ccbddocu
        &Event  = WRITE
        &FlgDB0 = TRUE
        &FlgDB1 = TRUE
        &FlgDB2 = TRUE
        &FlgDB3 = TRUE
        &FlgDB4 = TRUE
        &FlgDB5 = TRUE
        &FlgDB6 = TRUE
        &FlgDB7 = TRUE
        &FlgDB8 = TRUE
        &FlgDB9 = TRUE
        &FlgDB10 = TRUE
        &FlgDB11 = NO
        &FlgDB12 = TRUE
        &FlgDB13 = TRUE
        &FlgDB14 = TRUE
        &FlgDB15 = TRUE
        &FlgDB16 = TRUE
        &FlgDB17 = TRUE
        &FlgDB18 = TRUE
        &FlgDB19 = TRUE
        &FlgDB20 = TRUE
        }

    END.
    WHEN '00511' THEN DO:
        {rpl/reptrig.i
        &Table  = ccbddocu
    &Key    =  "string(ccbddocu.codcia,'999') + string(ccbddocu.coddiv,'x(5)') ~
        + string(ccbddocu.coddoc,'x(3)') + string(ccbddocu.nrodoc,'x(15)') ~
        + string(ccbddocu.codmat,'x(6)')"
        &Prg    = r-ccbddocu
        &Event  = WRITE
        &FlgDB0 = TRUE
        &FlgDB1 = TRUE
        &FlgDB2 = TRUE
        &FlgDB3 = TRUE
        &FlgDB4 = TRUE
        &FlgDB5 = TRUE
        &FlgDB6 = TRUE
        &FlgDB7 = TRUE
        &FlgDB8 = TRUE
        &FlgDB9 = TRUE
        &FlgDB10 = TRUE
        &FlgDB11 = TRUE
        &FlgDB12 = NO
        &FlgDB13 = TRUE
        &FlgDB14 = TRUE
        &FlgDB15 = TRUE
        &FlgDB16 = TRUE
        &FlgDB17 = TRUE
        &FlgDB18 = TRUE
        &FlgDB19 = TRUE
        &FlgDB20 = TRUE
        }

    END.
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

