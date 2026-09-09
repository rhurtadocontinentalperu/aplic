&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CMOV FOR Almcmov.



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
DEF NEW SHARED VAR pTipo AS CHAR.

ASSIGN
    pTipo = "BC".   /* Siempre va a ser chequeado por código de barras */

/* M: manual BC: código de barra */
IF LOOKUP(pTipo, 'M,BC') = 0 THEN RETURN ERROR.

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-coddoc AS CHAR INIT 'OTR' NO-UNDO.
DEFINE VAR x-fecha-inicio AS DATE.
DEFINE VAR x-hora-inicio AS CHAR.
DEF VAR x-HorIni LIKE faccpedi.horsac NO-UNDO.
DEF VAR x-FchIni LIKE faccpedi.fecsac NO-UNDO.

DEF NEW SHARED VAR lh_handle AS HANDLE.

/* *************************************************************************************** */
/* RHC 15/08/18 Verifico configuración de Incidencias */
/* *************************************************************************************** */
FIND TabGener WHERE TabGener.CodCia = s-CodCia AND
    TabGener.Codigo = s-CodDiv AND
    TabGener.Clave = 'CFGINC'
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE TabGener THEN DO:
    MESSAGE 'NO está configurado el control de incidencias' SKIP
        'Proceso Abortado' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
CASE TRUE:
    WHEN pTipo = "BC" AND TabGener.Libre_l01 = NO THEN DO:
        MESSAGE 'Esta Orden NO puede ingresarse por barras' SKIP
            'Ingresar la Orden por chequeo manual' SKIP(2)
            'Proceso Abortado' VIEW-AS ALERT-BOX WARNING.
        RETURN ERROR.
    END.
    WHEN pTipo = "M" AND TabGener.Libre_l01 = YES THEN DO:
        MESSAGE 'Esta Orden NO puede ingresarse manualmente' SKIP
            'Ingresar la Orden por chequeo de barras' SKIP(2)
            'Proceso Abortado' VIEW-AS ALERT-BOX WARNING.
        RETURN ERROR.
    END.
END CASE.

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
&Scoped-Define ENABLED-OBJECTS RECT-65 BUTTON-Nueva COMBO-BOX-CodDoc ~
x-NroDoc COMBO-BOX-1 FILL-IN-LPN FILL-IN_Observ 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodDoc x-NroDoc x-FchDoc ~
COMBO-BOX-1 FILL-IN-LPN FILL-IN-tiempo FILL-IN_Observ 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Centrar-Texto W-Win 
FUNCTION Centrar-Texto RETURNS LOGICAL
  ( INPUT h AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-chk-ingreso-dev-cli AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Cerrar 
     LABEL "Cerrar FAC" 
     SIZE 13 BY 1.12.

DEFINE BUTTON BUTTON-Nueva 
     LABEL "Nueva FAC" 
     SIZE 13 BY 1.12.

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione un motivo" 
     LABEL "Seleccion el motivo" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "Seleccione un motivo" 
     DROP-DOWN-LIST
     SIZE 46 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-CodDoc AS CHARACTER FORMAT "X(256)":U INITIAL "FAC" 
     LABEL "Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "FACTURA","FAC",
                     "BOLETA","BOL"
     DROP-DOWN-LIST
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-LPN AS CHARACTER FORMAT "X(20)":U 
     LABEL "RTV" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-tiempo AS CHARACTER FORMAT "X(25)":U 
     VIEW-AS FILL-IN 
     SIZE 21.29 BY 1.31
     FGCOLOR 12 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN_Observ AS CHARACTER FORMAT "X(50)" 
     LABEL "Observaciones" 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc AS DATE FORMAT "99/99/99":U 
     LABEL "Fecha de emisión" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-NroDoc AS CHARACTER FORMAT "x(14)":U 
     LABEL "Nro." 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-65
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 143 BY 4.04.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Cerrar AT ROW 1.27 COL 86 WIDGET-ID 24
     BUTTON-Nueva AT ROW 1.27 COL 99 WIDGET-ID 26
     COMBO-BOX-CodDoc AT ROW 1.54 COL 15 COLON-ALIGNED WIDGET-ID 44
     x-NroDoc AT ROW 1.54 COL 32 COLON-ALIGNED WIDGET-ID 36
     x-FchDoc AT ROW 1.54 COL 69 COLON-ALIGNED WIDGET-ID 34
     COMBO-BOX-1 AT ROW 2.62 COL 15 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-LPN AT ROW 2.62 COL 69 COLON-ALIGNED WIDGET-ID 46
     FILL-IN-tiempo AT ROW 3.42 COL 83.57 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     FILL-IN_Observ AT ROW 3.69 COL 15 COLON-ALIGNED HELP
          "Observaciones" WIDGET-ID 30
     RECT-65 AT ROW 1 COL 1 WIDGET-ID 32
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.29 BY 24.04
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CMOV B "?" ? INTEGRAL Almcmov
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CHEQUEO DE COMPROBANTES POR DEVOLUCION DE MERCADERIA"
         HEIGHT             = 24.04
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
/* SETTINGS FOR BUTTON BUTTON-Cerrar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-tiempo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME F-Main:HANDLE
       ROW             = 1
       COLUMN          = 119
       HEIGHT          = 3.85
       WIDTH           = 14.29
       WIDGET-ID       = 42
       HIDDEN          = yes
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CHEQUEO DE COMPROBANTES POR DEVOLUCION DE MERCADERIA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CHEQUEO DE COMPROBANTES POR DEVOLUCION DE MERCADERIA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Cerrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Cerrar W-Win
ON CHOOSE OF BUTTON-Cerrar IN FRAME F-Main /* Cerrar FAC */
DO:
  IF TRUE <> (x-NroDoc:SCREEN-VALUE > '') THEN DO:
      MESSAGE 'Comprobante NO válido' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO x-NroDoc.
      RETURN NO-APPLY.
  END.
  IF COMBO-BOX-1:SCREEN-VALUE BEGINS 'Seleccione' THEN DO:
      MESSAGE 'Debe seleccionar un motivo' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.

   /* Ic-27Ago2017, Si la devolucion de mercaderia es de Supermercados peruanos, obligar ingreso de RTV */
   IF CcbCDocu.CodCli = "20100070970" THEN DO:
       IF TRUE <> (FILL-IN-LPN:SCREEN-VALUE > "") THEN DO:
           MESSAGE "Para SUPERMERCADOS PERUANOS debe ingresar el RTV" VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO FILL-IN-LPN.
           RETURN NO-APPLY.
       END.       
   END.


  MESSAGE 'Cerramos la Orden?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  RUN Cerrar-Orden IN h_b-chk-ingreso-dev-cli (INPUT ENTRY(1,COMBO-BOX-1:SCREEN-VALUE,' - '),
                                               INPUT FILL-IN_Observ:SCREEN-VALUE,
                                               INPUT FILL-IN-LPN:SCREEN-VALUE).
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  ASSIGN
      x-FchDoc = ?
      x-NroDoc = ''
      FILL-IN_Observ = ''
      x-NroDoc:SENSITIVE = YES
      BUTTON-Cerrar:SENSITIVE = NO
      FILL-IN_Observ:SENSITIVE = YES.
  DISPLAY x-FchDoc x-NroDoc FILL-IN_Observ WITH FRAME {&FRAME-NAME}.
  APPLY 'LEAVE':U TO x-NroDoc IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Nueva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Nueva W-Win
ON CHOOSE OF BUTTON-Nueva IN FRAME F-Main /* Nueva FAC */
DO:
    MESSAGE 'Nuevo Pedido?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.
    ASSIGN
        x-NroDoc = '' 
        x-NroDoc:SENSITIVE = YES
        BUTTON-Cerrar:SENSITIVE = NO
        x-FchDoc = ?
        .
    DISPLAY 
        x-NroDoc
        x-FchDoc
        WITH FRAME {&FRAME-NAME}.
    APPLY 'LEAVE':U TO x-NroDoc IN FRAME {&FRAME-NAME}.
    APPLY 'ENTRY':U TO x-NroDoc IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame W-Win OCX.Tick
PROCEDURE CtrlFrame.PSTimer.Tick .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-tiempo AS CHAR.
DEFINE VAR x-centrar AS LOG.

x-Tiempo = ''.

RUN lib/_time-passed ( DATETIME(STRING(x-fecha-inicio,"99/99/9999") + ' ' + x-hora-inicio),
                         DATETIME(STRING(TODAY,"99/99/9999") + ' ' + STRING(TIME,"HH:MM:SS")), OUTPUT x-Tiempo).


fill-in-tiempo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-tiempo.

x-centrar = centrar-texto(fill-in-tiempo:HANDLE).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NroDoc W-Win
ON LEAVE OF x-NroDoc IN FRAME F-Main /* Nro. */
OR RETURN OF {&SELF-NAME} DO:
    IF SELF:SCREEN-VALUE = '' THEN DO:
        RUN Captura-Parametros IN h_b-chk-ingreso-dev-cli (INPUT pTipo,
                                                       INPUT "" /* CHARACTER */,
                                                       INPUT "" /* CHARACTER */).
        RETURN.
    END.
    FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia 
        AND Ccbcdocu.coddoc = COMBO-BOX-CodDoc:SCREEN-VALUE
        AND Ccbcdocu.nrodoc = x-nrodoc:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcdocu THEN DO:
        MESSAGE 'Comprobante NO válido' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    IF LOOKUP(CcbCDocu.FlgEst,"C,P") = 0 THEN DO:
       MESSAGE "DOCUMENTO NO VALIDO" VIEW-AS ALERT-BOX ERROR.
       SELF:SCREEN-VALUE = ''.
       RETURN NO-APPLY.
    END.
    IF CcbCDocu.FlgCon = "D" THEN DO:
       MESSAGE "El documento ya fue devuelto" VIEW-AS ALERT-BOX ERROR.
       SELF:SCREEN-VALUE = ''.
       RETURN NO-APPLY.
    END.
    /* ************************************************************************************ */
    /* 12/04/2024 Aprobación en trámite */
    /* ************************************************************************************ */
    IF CAN-FIND(FIRST ooMoviAlmacen WHERE OOMoviAlmacen.CodCia = s-codcia AND
                OOMoviAlmacen.CodAlm = s-codalm AND
                OOMoviAlmacen.TipMov = "I" AND
                OOMoviAlmacen.CodMov = 09 AND 
                OOMoviAlmacen.CodRef = Ccbcdocu.coddoc AND 
                OOMoviAlmacen.NroRef = Ccbcdocu.nrodoc AND 
                OOMoviAlmacen.FlagMigracion = "N" NO-LOCK)
        THEN DO:
        MESSAGE 'El comprobante está en trámite de APROBACION DEL SLOTING' SKIP
            'Comprobante NO válido' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    /* ************************************************************************************ */
    /* ************************************************************************************ */
    IF x-NroDoc <> SELF:SCREEN-VALUE THEN DO:
        /* Arranca el ciclo */            
        FILL-IN-tiempo = ''.
        ASSIGN
            x-FchIni = TODAY
            x-HorIni = STRING(TIME, 'HH:MM').
        ASSIGN {&SELF-NAME}.
        RUN Calcula-NroItems.
        FIND Almacen WHERE Almacen.codcia = s-codcia
            AND Almacen.codalm = Ccbcdocu.codalm
            NO-LOCK.
        ASSIGN
            x-fchdoc = Ccbcdocu.fchdoc.
        DISPLAY
            x-fchdoc
            WITH FRAME {&FRAME-NAME}.
        x-NroDoc:SENSITIVE = NO.
        BUTTON-Cerrar:SENSITIVE = YES.
        RUN Captura-Parametros IN h_b-chk-ingreso-dev-cli
            ( INPUT pTipo,
              INPUT Ccbcdocu.CodDoc /* CHARACTER */,
              INPUT Ccbcdocu.NroDoc /* CHARACTER */).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
lh_handle = THIS-PROCEDURE.

CASE pTipo:
    WHEN "BC" THEN {&WINDOW-NAME}:TITLE = {&WINDOW-NAME}:TITLE + " - BARRCODE".
    WHEN "M"  THEN {&WINDOW-NAME}:TITLE = {&WINDOW-NAME}:TITLE + " - MANUAL".
END CASE.

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
             INPUT  'ALM/b-chk-ingreso-dev-cli.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-chk-ingreso-dev-cli ).
       RUN set-position IN h_b-chk-ingreso-dev-cli ( 5.31 , 1.00 ) NO-ERROR.
       RUN set-size IN h_b-chk-ingreso-dev-cli ( 18.31 , 143.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 23.62 , 1.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 1.42 , 34.14 ) NO-ERROR.

       /* Links to SmartBrowser h_b-chk-ingreso-dev-cli. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_b-chk-ingreso-dev-cli ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-chk-ingreso-dev-cli ,
             FILL-IN_Observ:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             h_b-chk-ingreso-dev-cli , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-NroItems W-Win 
PROCEDURE Calcula-NroItems :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iNroItems AS INTEGER     NO-UNDO.
    
/*     x-NroItem = 0.                              */
/*     FOR EACH Facdpedi OF Faccpedi NO-LOCK:      */
/*         iNroItems = iNroItems + 1.              */
/*     END.                                        */
/*     ASSIGN x-NroItem = iNroItems.               */
/*     DISPLAY x-NroItem WITH FRAME {&FRAME-NAME}. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load W-Win  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "w-chk-ingreso-dev-cli.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
  .
  RUN DISPATCH IN THIS-PROCEDURE("initialize-controls":U) NO-ERROR.
END.
ELSE MESSAGE "w-chk-ingreso-dev-cli.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

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
  DISPLAY COMBO-BOX-CodDoc x-NroDoc x-FchDoc COMBO-BOX-1 FILL-IN-LPN 
          FILL-IN-tiempo FILL-IN_Observ 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-65 BUTTON-Nueva COMBO-BOX-CodDoc x-NroDoc COMBO-BOX-1 FILL-IN-LPN 
         FILL-IN_Observ 
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
      FOR EACH ccbtabla NO-LOCK WHERE ccbtabla.codcia = s-codcia
          AND ccbtabla.tabla = 'MD'
          AND CcbTabla.Libre_L01 = YES:
          COMBO-BOX-1:ADD-LAST(ccbtabla.codigo + ' - ' + ccbtabla.nombre).
      END.
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

DEF INPUT PARAMETER p-handle AS CHAR.

CASE p-handle:
    WHEN 'Add-Record' THEN RUN notify IN h_p-updv12   ('add-record':U).
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Centrar-Texto W-Win 
FUNCTION Centrar-Texto RETURNS LOGICAL
  ( INPUT h AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VARIABLE reps AS INTEGER     NO-UNDO.

reps = (h:WIDTH-PIXELS - FONT-TABLE:GET-TEXT-WIDTH-PIXELS(TRIM(h:SCREEN-VALUE),h:FONT) - 8 /* allow for 3-D borders */ ) / FONT-TABLE:GET-TEXT-WIDTH-PIXELS(' ',h:FONT).
reps = reps / 2.
h:SCREEN-VALUE = FILL(' ',reps) + TRIM(h:SCREEN-VALUE).

RETURN yes.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

