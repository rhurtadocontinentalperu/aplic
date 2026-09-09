&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE NEW SHARED TEMP-TABLE T-CALMD NO-UNDO LIKE AlmCDocu
       FIELD CodDiv AS CHAR.



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

DEF VAR x-CodPed AS CHAR NO-UNDO.
DEF VAR x-CodDiv AS CHAR NO-UNDO.

&SCOPED-DEFINE Condicion ( T-CALMD.CodCia = s-codcia ~
AND T-CALMD.CodDoc = x-CodPed ~
AND ( TRUE <> (x-CodDiv > '') OR T-CALMD.CodDiv = x-CodDiv ) )

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
&Scoped-Define ENABLED-OBJECTS SELECT-CodDoc RADIO-SET-Origen BUTTON-1 ~
FILL-IN-Fecha-1 BUTTON-Actualizar FILL-IN-Fecha-2 
&Scoped-Define DISPLAYED-OBJECTS SELECT-CodDoc RADIO-SET-Origen ~
FILL-IN-Fecha-1 FILL-IN-Fecha-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstadoDet W-Win 
FUNCTION fEstadoDet RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNombre W-Win 
FUNCTION fNombre RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fusuariofecha W-Win 
FUNCTION fusuariofecha RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-reprogr-od-nep AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-reprograma-od-det-2 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Enviar a Excel" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Actualizar 
     LABEL "APLICAR FILTRO" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Origen AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Mis Ordenes", 1,
"Todas las Ordenes", 2
     SIZE 30 BY .81 NO-UNDO.

DEFINE VARIABLE SELECT-CodDoc AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     LIST-ITEM-PAIRS "Todos","Todos" 
     SIZE 46 BY 10.23
     BGCOLOR 8 FGCOLOR 1 FONT 10 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     SELECT-CodDoc AT ROW 1.27 COL 2 NO-LABEL WIDGET-ID 8
     RADIO-SET-Origen AT ROW 1.27 COL 61 NO-LABEL WIDGET-ID 20
     BUTTON-1 AT ROW 2.15 COL 106 WIDGET-ID 18
     FILL-IN-Fecha-1 AT ROW 2.35 COL 59 COLON-ALIGNED WIDGET-ID 14
     BUTTON-Actualizar AT ROW 2.35 COL 81 WIDGET-ID 6
     FILL-IN-Fecha-2 AT ROW 3.42 COL 59 COLON-ALIGNED WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.29 BY 25.5
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: T-CALMD T "NEW SHARED" NO-UNDO INTEGRAL AlmCDocu
      ADDITIONAL-FIELDS:
          FIELD CodDiv AS CHAR
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "PEDIDOS NO ENTREGADOS PENDIENTES"
         HEIGHT             = 25.5
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
       COLUMN          = 131
       HEIGHT          = 3.85
       WIDTH           = 14.29
       WIDGET-ID       = 12
       HIDDEN          = yes
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */
      CtrlFrame:MOVE-BEFORE(SELECT-CodDoc:HANDLE IN FRAME F-Main).

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* PEDIDOS NO ENTREGADOS PENDIENTES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PEDIDOS NO ENTREGADOS PENDIENTES */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Enviar a Excel */
DO:
  ASSIGN SELECT-coddoc.    
  
  RUN enviar-a-excel.
  /*
  IF s-user-id = 'ADMIN' THEN DO:
      RUN enviar-a-excel.
  END.
  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Actualizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Actualizar W-Win
ON CHOOSE OF BUTTON-Actualizar IN FRAME F-Main /* APLICAR FILTRO */
DO:
   ASSIGN FILL-IN-Fecha-1 FILL-IN-Fecha-2 RADIO-SET-Origen.
   SESSION:SET-WAIT-STATE('GENERAL').
   RUN Carga-Temporal.
   SESSION:SET-WAIT-STATE('').
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

APPLY 'CHOOSE':U TO BUTTON-Actualizar IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME SELECT-CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SELECT-CodDoc W-Win
ON VALUE-CHANGED OF SELECT-CodDoc IN FRAME F-Main
DO:
  ASSIGN {&SELF-NAME}.
  ASSIGN
      x-CodPed = ''
      x-CodDiv = ''.
  x-CodPed = ENTRY(1, SELECT-CodDoc, '|').
  IF NUM-ENTRIES(SELECT-CodDoc, '|') > 1 THEN x-CodDiv = ENTRY(2, SELECT-CodDoc, '|').
  /*MESSAGE SELF:SCREEN-VALUE SKIP x-codped x-coddiv.*/
  {&OPEN-QUERY-{&BROWSE-NAME}}
  RUN Captura-Parametros IN h_b-reprogr-od-nep
    ( INPUT x-CodPed /* CHARACTER */,
      INPUT x-CodDiv /* CHARACTER */).
  RUN dispatch IN h_b-reprogr-od-nep ('open-query':U).
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
             INPUT  'aplic/dist/b-reprograma-od-det-2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-reprograma-od-det-2 ).
       RUN set-position IN h_b-reprograma-od-det-2 ( 4.77 , 49.00 ) NO-ERROR.
       RUN set-size IN h_b-reprograma-od-det-2 ( 6.69 , 95.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/dist/b-reprogr-od-nep.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-reprogr-od-nep ).
       RUN set-position IN h_b-reprogr-od-nep ( 11.69 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-reprogr-od-nep ( 14.54 , 142.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-reprograma-od-det-2. */
       RUN add-link IN adm-broker-hdl ( h_b-reprogr-od-nep , 'Record':U , h_b-reprograma-od-det-2 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-reprograma-od-det-2 ,
             FILL-IN-Fecha-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-reprogr-od-nep ,
             h_b-reprograma-od-det-2 , 'AFTER':U ).
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

EMPTY TEMP-TABLE T-CALMD.

CASE RADIO-SET-Origen:
    WHEN 1 THEN DO:
        FOR EACH AlmCDocu NO-LOCK WHERE AlmCDocu.CodCia = s-codcia
            AND AlmCDocu.CodLlave = s-coddiv
            AND AlmCDocu.FlgEst <> "A"
            AND LOOKUP(AlmCDocu.CodDoc, "O/D,OTR,O/M") > 0
            AND AlmCDocu.FchDoc >= FILL-IN-Fecha-1
            AND AlmCDocu.FchDoc <= FILL-IN-Fecha-2
            ,
            FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = Almcdocu.codcia
            AND Faccpedi.coddoc = Almcdocu.coddoc
            AND Faccpedi.nroped = Almcdocu.nrodoc:
            CREATE T-CALMD.
            BUFFER-COPY AlmCDocu 
                TO T-CALMD 
                ASSIGN 
                T-CALMD.CodDiv = Faccpedi.CodDiv
                T-CALMD.Libre_d05 = 0.
            FOR EACH Facdpedi NO-LOCK WHERE FacDPedi.CodCia = Almcdocu.CodCia
                AND FacDPedi.CodDoc = Almcdocu.CodDoc
                AND FacDPedi.NroPed = Almcdocu.NroDoc:
                T-CALMD.Libre_d05 = T-CALMD.Libre_d05 + 1.
            END.
        END.
    END.
    WHEN 2 THEN DO:
        FOR EACH GN-DIVI NO-LOCK WHERE GN-DIVI.CodCia = s-CodCia,
            EACH AlmCDocu NO-LOCK WHERE AlmCDocu.CodCia = s-codcia
            AND AlmCDocu.CodLlave = GN-DIVI.CodDiv
            AND AlmCDocu.FlgEst <> "A"
            AND LOOKUP(AlmCDocu.CodDoc, "O/D,OTR,O/M") > 0
            AND AlmCDocu.FchDoc >= FILL-IN-Fecha-1
            AND AlmCDocu.FchDoc <= FILL-IN-Fecha-2
            ,
            FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = Almcdocu.codcia
            AND Faccpedi.coddoc = Almcdocu.coddoc
            AND Faccpedi.nroped = Almcdocu.nrodoc:
            CREATE T-CALMD.
            BUFFER-COPY AlmCDocu 
                TO T-CALMD 
                ASSIGN 
                T-CALMD.CodDiv = Faccpedi.CodDiv
                T-CALMD.Libre_d05 = 0.
            FOR EACH Facdpedi NO-LOCK WHERE FacDPedi.CodCia = Almcdocu.CodCia
                AND FacDPedi.CodDoc = Almcdocu.CodDoc
                AND FacDPedi.NroPed = Almcdocu.NroDoc:
                T-CALMD.Libre_d05 = T-CALMD.Libre_d05 + 1.
            END.
        END.
    END.
END CASE.

DEF VAR k AS INT NO-UNDO.
DEF VAR n AS INT NO-UNDO.
DEF VAR m AS INT NO-UNDO.

DEF BUFFER BT-CALMD FOR T-CALMD.
DO WITH FRAME {&FRAME-NAME}:
    SELECT-CodDoc:DELETE(SELECT-CodDoc:LIST-ITEM-PAIRS).
    FOR EACH T-CALMD NO-LOCK,
        FIRST Faccpedi NO-LOCK WHERE FaccPedi.CodCia = T-CALMD.CodCia
        AND FaccPedi.CodDoc = T-CALMD.CodDoc
        AND FaccPedi.NroPed = T-CALMD.NroDoc
        BREAK BY T-CALMD.CodDoc BY Faccpedi.CodDiv:
        IF FIRST-OF(T-CALMD.CodDoc) THEN DO:
            n = 0.
            FOR EACH BT-CALMD NO-LOCK WHERE BT-CALMD.CodDoc = T-CALMD.CodDoc:
                n = n + 1.
            END.
            SELECT-CodDoc:ADD-LAST( T-CALMD.CodDoc + ' (' + STRING(n) + ')' , T-CALMD.CodDoc).
        END.
        IF FIRST-OF(T-CALMD.CodDoc) OR FIRST-OF(Faccpedi.CodDiv) THEN DO:
            k = 0.
            m = 0.
        END.
        k = k + 1.
        m = m + 1.
        T-CALMD.Libre_d05 = k.
        IF LAST-OF(Faccpedi.CodDiv) THEN DO:
            FIND FIRST GN-DIVI OF Faccpedi NO-LOCK.
            SELECT-CodDoc:ADD-LAST( Gn-DIVI.CodDiv + ' - ' + GN-DIVI.DesDiv + '(' + STRING(m) + ')', T-CALMD.CodDoc + '|' + Faccpedi.CodDiv ).
        END.
    END.
    DISPLAY SELECT-CodDoc.
END.

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

OCXFile = SEARCH( "w-reprogr-od-nep.wrx":U ).
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
ELSE MESSAGE "w-reprogr-od-nep.wrx":U SKIP(1)
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
  DISPLAY SELECT-CodDoc RADIO-SET-Origen FILL-IN-Fecha-1 FILL-IN-Fecha-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE SELECT-CodDoc RADIO-SET-Origen BUTTON-1 FILL-IN-Fecha-1 
         BUTTON-Actualizar FILL-IN-Fecha-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enviar-a-excel W-Win 
PROCEDURE enviar-a-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
REPEAT WHILE SELECT-coddoc:NUM-ITEMS > 0:
    
END.
*/

DEFINE VAR x-lista AS CHAR.
DEFINE VAR x-count AS INT.
DEFINE VAR x-sec AS INT.
DEFINE VAR x-filtro1 AS CHAR.
DEFINE VAR x-titulo AS CHAR.
DEFINE VAR x-coddiv AS CHAR.
DEFINE VAR x-codped AS CHAR.
DEF VAR fNombre AS CHAR.
DEF VAR festadodet AS CHAR.
DEF VAR fusuario-fecha AS CHAR.
DEF VAR fNroRep AS INT NO-UNDO.
DEFINE VAR x-incrementa-row AS LOG.

x-lista = SELECT-coddoc:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME}.
x-count = NUM-ENTRIES(x-lista,",").

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.
define VAR cValue as char.


lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

SESSION:SET-WAIT-STATE('GENERAL').

chExcelApplication:Visible = FALSE.

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = NO. /* Si permanece abierto el Excel luego de concluir el proceso */
/*cColList - Array Columnas (A,B,C...AA,AB,AC...) */

chWorkSheet = chExcelApplication:Sheets:Item(1).

iRow = 1.
cRange = "A" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Division".
cRange = "B" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Nro".
cRange = "C" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Reprog".
cRange = "D" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Doc".
cRange = "E" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Nro Cotiz".
cRange = "F" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Doc".
cRange = "G" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "NroPedido".
cRange = "H" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Doc".
cRange = "I" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "NroOrden".
cRange = "J" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Fecha entrega".
cRange = "K" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Nombre Cliente".
cRange = "L" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Doc".
cRange = "M" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Nro H/R".
cRange = "N" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Importe".
cRange = "O" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Peso".
cRange = "P" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "M3".
cRange = "Q" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Motivo no entregado".
cRange = "R" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "1er responsable ruta".

cRange = "S" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Codigo".
cRange = "T" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Numero".
cRange = "U" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Fecha".
cRange = "V" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Cliente".
cRange = "W" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Nombre".
cRange = "X" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Importe Total".
cRange = "Y" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Usu. Reprog.".
cRange = "Z" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Nombre".
cRange = "AA" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Fecha Hora".

iRow = 2.

/* ----------------------------------------------- */
REPEAT x-sec = 1 TO x-count :
    x-filtro1 = ENTRY(x-sec + 1,x-lista,",").
    x-titulo = ENTRY(x-sec,x-lista,",").

    x-CodPed = ENTRY(1, x-filtro1, '|').
    IF NUM-ENTRIES(x-filtro1, '|') > 1 THEN DO:
        x-CodDiv = ENTRY(2, x-filtro1, '|').
    END.
    ELSE NEXT.
        
        
    /* --- */
    FOR EACH T-CALMD WHERE T-CALMD.codcia = s-codcia AND
                            T-CALMD.CodDoc = x-CodPed AND 
                            (x-CodDiv = '' OR T-CALMD.CodDiv = x-CodDiv ) 
                            NO-LOCK:

            FOR EACH INTEGRAL.FacCPedi WHERE INTEGRAL.FacCPedi.CodCia = T-CALMD.CodCia
                                        AND INTEGRAL.FacCPedi.CodDoc = T-CALMD.CodDoc
                                        AND INTEGRAL.FacCPedi.NroPed = T-CALMD.NroDoc NO-LOCK,
                EACH PEDIDO WHERE PEDIDO.CodCia = INTEGRAL.FacCPedi.CodCia
                                    AND PEDIDO.CodDoc = INTEGRAL.FacCPedi.CodRef
                                    AND PEDIDO.NroPed = INTEGRAL.FacCPedi.NroRef NO-LOCK
                                    BY T-CALMD.Libre_d05 :

                    /*  */
                    FIND AlmTabla WHERE AlmTabla.Tabla = 'HR'
                        AND AlmTabla.Codigo = T-CALMD.Libre_c03
                        AND almtabla.NomAnt = 'N'
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE AlmTabla THEN festadoDet = almtabla.Nombre.
    
                    /*  */
                    RUN gn/nombre-usuario (T-CALMD.UsrCreacion, OUTPUT fNombre).
    
                    /*  */
                    fNroRep = 0.                
                    FOR EACH logtabla NO-LOCK WHERE logtabla.codcia = s-codcia
                                                    AND logtabla.Evento = "REPROGRAMACION"
                                                    AND logtabla.Tabla = 'ALMCDOCU'
                                                    AND logtabla.ValorLlave BEGINS T-CALMD.CodLlave + '|' + T-CALMD.CodDoc + '|' + T-CALMD.NroDoc:
                         fNroRep = fNroRep + 1.
                    END.

                    cRange = "A" + TRIM(STRING(iRow)).
                    chWorkSheet:Range(cRange):VALUE = "'" + x-titulo.
    
                    cRange = "B" + TRIM(STRING(iRow)).
                    chWorkSheet:Range(cRange):VALUE = t-calmd.libre_d05.
    
                    cRange = "C" + TRIM(STRING(iRow)).
                    chWorkSheet:Range(cRange):VALUE = fnrorep.
    
                    cRange = "D" + TRIM(STRING(iRow)).
                    chWorkSheet:Range(cRange):VALUE = pedido.codref.                
    
                    cRange = "E" + TRIM(STRING(iRow)).
                    chWorkSheet:Range(cRange):VALUE = "'" + pedido.nroref.
                    
                    cRange = "F" + TRIM(STRING(iRow)).
                    chWorkSheet:Range(cRange):VALUE = pedido.coddoc.
                    
                    cRange = "G" + TRIM(STRING(iRow)).
                    chWorkSheet:Range(cRange):VALUE = "'" + pedido.nroped.
                    
                    cRange = "H" + TRIM(STRING(iRow)).
                    chWorkSheet:Range(cRange):VALUE = t-calmd.coddoc.
                    
                    cRange = "I" + TRIM(STRING(iRow)).
                    chWorkSheet:Range(cRange):VALUE = "'" + t-calmd.nrodoc.
                    
                    cRange = "J" + TRIM(STRING(iRow)).
                    chWorkSheet:Range(cRange):VALUE = faccpedi.fchent.
                    
                    cRange = "K" + TRIM(STRING(iRow)).
                    chWorkSheet:Range(cRange):VALUE = faccpedi.nomcli.
                    
                    cRange = "L" + TRIM(STRING(iRow)).
                    chWorkSheet:Range(cRange):VALUE = t-calmd.libre_c01.
                    
                    cRange = "M" + TRIM(STRING(iRow)).
                    chWorkSheet:Range(cRange):VALUE = "'" + t-calmd.libre_c02.
                    
                    cRange = "N" + TRIM(STRING(iRow)).
                    chWorkSheet:Range(cRange):VALUE = t-calmd.libre_d01.
                    
                    cRange = "O" + TRIM(STRING(iRow)).
                    chWorkSheet:Range(cRange):VALUE = t-calmd.libre_d02.
                    
                    cRange = "P" + TRIM(STRING(iRow)).
                    chWorkSheet:Range(cRange):VALUE = t-calmd.libre_d03.
                    
                    cRange = "Q" + TRIM(STRING(iRow)).
                    chWorkSheet:Range(cRange):VALUE = festadoDet.
                    
                    cRange = "R" + TRIM(STRING(iRow)).
                    chWorkSheet:Range(cRange):VALUE = fnombre.
    
                    /*iRow = iRow + 1.*/
                    x-incrementa-row = NO.
                    /* ----------------------------------------------------- */

                    FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = FacCPedi.CodCia
                                          AND CcbCDocu.CodPed = FacCPedi.CodRef
                                          AND CcbCDocu.NroPed = FacCPedi.NroRef
                                          AND CcbCDocu.Libre_c01 = FacCPedi.CodDoc
                                          AND CcbCDocu.Libre_c02 = FacCPedi.NroPed                    
                                          AND (CcbCDocu.CodDoc = "FAC" OR CcbCDocu.CodDoc = "BOL" OR CcbCDocu.CodDoc = "G/R")
                                          AND LOOKUP(CcbCDocu.FlgEst, "C,P,F") > 0 NO-LOCK :

                        fusuario-fecha = fusuariofecha().

                        IF x-incrementa-row = YES THEN DO:
                            cRange = "A" + TRIM(STRING(iRow)).
                            chWorkSheet:Range(cRange):VALUE = "'" + x-titulo.

                            cRange = "B" + TRIM(STRING(iRow)).
                            chWorkSheet:Range(cRange):VALUE = t-calmd.libre_d05.

                            cRange = "C" + TRIM(STRING(iRow)).
                            chWorkSheet:Range(cRange):VALUE = fnrorep.

                            cRange = "D" + TRIM(STRING(iRow)).
                            chWorkSheet:Range(cRange):VALUE = pedido.codref.                

                            cRange = "E" + TRIM(STRING(iRow)).
                            chWorkSheet:Range(cRange):VALUE = "'" + pedido.nroref.

                            cRange = "F" + TRIM(STRING(iRow)).
                            chWorkSheet:Range(cRange):VALUE = pedido.coddoc.

                            cRange = "G" + TRIM(STRING(iRow)).
                            chWorkSheet:Range(cRange):VALUE = "'" + pedido.nroped.

                            cRange = "H" + TRIM(STRING(iRow)).
                            chWorkSheet:Range(cRange):VALUE = t-calmd.coddoc.

                            cRange = "I" + TRIM(STRING(iRow)).
                            chWorkSheet:Range(cRange):VALUE = "'" + t-calmd.nrodoc.

                            cRange = "J" + TRIM(STRING(iRow)).
                            chWorkSheet:Range(cRange):VALUE = faccpedi.fchent.

                            cRange = "K" + TRIM(STRING(iRow)).
                            chWorkSheet:Range(cRange):VALUE = faccpedi.nomcli.

                            cRange = "L" + TRIM(STRING(iRow)).
                            chWorkSheet:Range(cRange):VALUE = t-calmd.libre_c01.

                            cRange = "M" + TRIM(STRING(iRow)).
                            chWorkSheet:Range(cRange):VALUE = "'" + t-calmd.libre_c02.

                            cRange = "N" + TRIM(STRING(iRow)).
                            chWorkSheet:Range(cRange):VALUE = t-calmd.libre_d01.

                            cRange = "O" + TRIM(STRING(iRow)).
                            chWorkSheet:Range(cRange):VALUE = t-calmd.libre_d02.

                            cRange = "P" + TRIM(STRING(iRow)).
                            chWorkSheet:Range(cRange):VALUE = t-calmd.libre_d03.

                            cRange = "Q" + TRIM(STRING(iRow)).
                            chWorkSheet:Range(cRange):VALUE = festadoDet.

                            cRange = "R" + TRIM(STRING(iRow)).
                            chWorkSheet:Range(cRange):VALUE = fnombre.
                        END.

                        cRange = "S" + TRIM(STRING(iRow)).
                        chWorkSheet:Range(cRange):VALUE = ccbcdocu.coddoc.
                        cRange = "T" + TRIM(STRING(iRow)).
                        chWorkSheet:Range(cRange):VALUE = "'" + ccbcdocu.nrodoc.
                        cRange = "U" + TRIM(STRING(iRow)).
                        chWorkSheet:Range(cRange):VALUE = ccbcdocu.fchdoc.
                        cRange = "V" + TRIM(STRING(iRow)).
                        chWorkSheet:Range(cRange):VALUE = "'" + ccbcdocu.codcli.
                        cRange = "W" + TRIM(STRING(iRow)).
                        chWorkSheet:Range(cRange):VALUE = "'" + ccbcdocu.nomcli.
                        cRange = "X" + TRIM(STRING(iRow)).
                        chWorkSheet:Range(cRange):VALUE = ccbcdocu.imptot.
                        cRange = "Y" + TRIM(STRING(iRow)).
                        chWorkSheet:Range(cRange):VALUE = entry(1,fusuario-fecha,"|").
                        cRange = "Z" + TRIM(STRING(iRow)).
                        chWorkSheet:Range(cRange):VALUE = entry(2,fusuario-fecha,"|").
                        cRange = "AA" + TRIM(STRING(iRow)).
                        chWorkSheet:Range(cRange):VALUE = ENTRY(3,fUsuario-Fecha,'|') + ' ' + ENTRY(4,fUsuario-Fecha,'|').

                        x-incrementa-row = YES.
                        IF x-incrementa-row = YES THEN iRow = iRow + 1.
                        
                    END.
                    /**/                    
                    IF x-incrementa-row = NO THEN iRow = iRow + 1.

            END.
    END.
    /* --- */
    x-sec = x-sec + 1.
END.

/* ----------------------------------------------- */

chExcelApplication:Visible = TRUE.

{lib\excel-close-file.i} 

SESSION:SET-WAIT-STATE('').

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
      FILL-IN-Fecha-1 = ADD-INTERVAL(TODAY,-15,'days')
      FILL-IN-Fecha-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstadoDet W-Win 
FUNCTION fEstadoDet RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
FIND AlmTabla WHERE AlmTabla.Tabla = 'HR'
    AND AlmTabla.Codigo = T-CALMD.Libre_c03
    AND almtabla.NomAnt = 'N'
    NO-LOCK NO-ERROR.
IF AVAILABLE AlmTabla THEN RETURN almtabla.Nombre.
RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNombre W-Win 
FUNCTION fNombre RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR pNombre AS CHAR.

  RUN gn/nombre-usuario (T-CALMD.UsrCreacion, OUTPUT pNombre).


  RETURN pNombre.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fusuariofecha W-Win 
FUNCTION fusuariofecha RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
  DEF BUFFER B-Almcdocu FOR Almcdocu.

  DEF VAR pNombre AS CHAR NO-UNDO.

  FOR EACH Di-RutaD NO-LOCK WHERE DI-RutaD.CodCia = s-codcia 
      AND DI-RutaD.CodDiv = s-coddiv
      AND DI-RutaD.CodDoc = "H/R"
      AND DI-RutaD.CodRef = Ccbcdocu.coddoc
      AND DI-RutaD.NroRef = Ccbcdocu.nrodoc,
      FIRST Di-RutaC OF Di-RutaD NO-LOCK WHERE Di-RutaC.FlgEst = "C":
      /* Buscamos por la O/D reprogramada */
      FIND LogTabla WHERE logtabla.codcia = s-codcia
          AND logtabla.Evento = "REPROGRAMACION"
          AND logtabla.Tabla = 'ALMCDOCU'
          AND logtabla.ValorLlave = (s-CodDiv + '|' + Faccpedi.CodDoc + '|' + Faccpedi.NroPed + '|' +
          DI-RutaC.CodDoc + '|' + DI-RutaC.NroDoc)
          NO-LOCK NO-ERROR.
      IF AVAILABLE LogTabla THEN DO:
          RUN gn/nombre-usuario (logtabla.Usuario, OUTPUT pNombre).
          RETURN logtabla.Usuario + '|' + pNombre + '|' + 
              STRING(logtabla.Dia, '99/99/9999') + '|' +
              logtabla.Hora.
      END.
  END.
  RETURN "|||".   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

