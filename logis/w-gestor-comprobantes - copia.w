&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE PEDI LIKE FacDPedi.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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
DEF INPUT PARAMETER pParam AS CHAR.

/* Sintaxis: <Acceso Total>|<Tipo>
    <Acceso Total> = {YES,NO,TRUE,FALSE,SI,SÍ,sí}
    <Tipo> = {ELECTRONICA,MANUAL}
*/

/* ********************************************************************************** */
/* Chequeo de parámetros */
IF NUM-ENTRIES(pParam,'|') <> 2 THEN DO:
    MESSAGE 'Número de parámetros errados' SKIP
        'Se espera: ' SKIP
        '<Acceso Total>: SI o NO ' SKIP
        '<Tipo>: ELECTRONICA o MANUAL'
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

DEF VAR cParam1 AS CHAR NO-UNDO.
DEF VAR cParam2 AS CHAR NO-UNDO.

ASSIGN
    cParam1 = ENTRY(1,pParam,'|')
    cParam2 = ENTRY(2,pParam,'|').

IF LOOKUP(cParam1, 'YES,NO,TRUE,FALSE,SI,SÍ,sí') = 0 THEN RETURN ERROR.
IF LOOKUP(cParam2, 'ELECTRONICA,MANUAL') = 0 THEN RETURN ERROR.
/* ********************************************************************************** */

DEFINE NEW SHARED VAR s-acceso-total  AS LOG.
DEFINE NEW SHARED VARIABLE S-TIPMOV   AS CHAR.

IF LOOKUP(cParam1, 'YES,NO,TRUE,FALSE') > 0 THEN s-acceso-total = LOGICAL(cParam1).
IF LOOKUP(cParam1, 'SI,SÍ,sí') > 0 THEN s-acceso-total = YES.
s-TipMov = cParam2.

/* ********************************************************************************** */
/* RHC 20/07/2015 definimos s-codcia s-codalm s-desalm y s-coddiv SOLO para ALMACENES */
{alm/windowalmacen.i}
/* ********************************************************************************** */

/* Local Variable Definitions ---                                       */

DEFINE NEW SHARED VARIABLE s-CodDoc AS CHARACTER.
DEFINE NEW SHARED VARIABLE lh_handle AS HANDLE.

s-CodDoc = "O/D".

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
&Scoped-Define ENABLED-OBJECTS RECT-1 FILL-IN_NroPHR BUTTON_Fraccionar ~
BUTTON_Filtro BUTTON_Limpiar-Filtro BUTTON-1 BUTTON-create BUTTON-exit 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_NroPHR EDITOR_Titulo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-genera-comprobantes-cab AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-genera-factura-credb AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "REFRESCAR PANTALLA" 
     SIZE 22 BY 1.12.

DEFINE BUTTON BUTTON-create 
     LABEL "GENERAR COMPROBANTE" 
     SIZE 22 BY 1.12.

DEFINE BUTTON BUTTON-exit 
     LABEL "SALIR" 
     SIZE 22 BY 1.12.

DEFINE BUTTON BUTTON_Filtro 
     LABEL "APLICAR FILTRO" 
     SIZE 18 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON_Fraccionar  NO-FOCUS
     LABEL "FRACCIONAR ORDEN" 
     SIZE 33 BY 2.42
     BGCOLOR 12 FGCOLOR 0 FONT 9.

DEFINE BUTTON BUTTON_Limpiar-Filtro 
     LABEL "LIMPIAR FILTRO" 
     SIZE 21 BY 1.12
     FONT 6.

DEFINE VARIABLE EDITOR_Titulo AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 29 BY 2.69
     BGCOLOR 10 FGCOLOR 12 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroPHR AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 19 BY 1.35
     BGCOLOR 14 FGCOLOR 0 FONT 8 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 119 BY 2.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN_NroPHR AT ROW 1.54 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     BUTTON_Fraccionar AT ROW 1 COL 121 WIDGET-ID 22
     BUTTON_Filtro AT ROW 1.54 COL 53 WIDGET-ID 34
     BUTTON_Limpiar-Filtro AT ROW 1.54 COL 71 WIDGET-ID 38
     EDITOR_Titulo AT ROW 4.77 COL 122 NO-LABEL WIDGET-ID 42
     BUTTON-1 AT ROW 7.46 COL 122 WIDGET-ID 20
     BUTTON-create AT ROW 8.54 COL 122 WIDGET-ID 24
     BUTTON-exit AT ROW 9.62 COL 122 WIDGET-ID 28
     "# de PHR:" VIEW-AS TEXT
          SIZE 17 BY 1.35 AT ROW 1.54 COL 16 WIDGET-ID 32
          FONT 8
     RECT-1 AT ROW 1 COL 2 WIDGET-ID 36
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 153.86 BY 25.27
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: PEDI T "NEW SHARED" ? INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "GENERACION DE COMPROBANTES VENTAS AL CREDITO - SUNAT"
         HEIGHT             = 25.27
         WIDTH              = 153.86
         MAX-HEIGHT         = 26.19
         MAX-WIDTH          = 153.86
         VIRTUAL-HEIGHT     = 26.19
         VIRTUAL-WIDTH      = 153.86
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

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR EDITOR EDITOR_Titulo IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* GENERACION DE COMPROBANTES VENTAS AL CREDITO - SUNAT */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* GENERACION DE COMPROBANTES VENTAS AL CREDITO - SUNAT */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* REFRESCAR PANTALLA */
DO:
  RUN dispatch IN h_b-genera-comprobantes-cab('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-create
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-create W-Win
ON CHOOSE OF BUTTON-create IN FRAME F-Main /* GENERAR COMPROBANTE */
DO:
    RUN proc_GeneraGuia IN h_b-genera-comprobantes-cab.
    RUN dispatch IN h_b-genera-comprobantes-cab ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-exit W-Win
ON CHOOSE OF BUTTON-exit IN FRAME F-Main /* SALIR */
DO:
    RUN local-Exit.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Filtro W-Win
ON CHOOSE OF BUTTON_Filtro IN FRAME F-Main /* APLICAR FILTRO */
DO:
  RUN Captura-Filtro IN h_b-genera-comprobantes-cab
    ( INPUT FILL-IN_NroPHR:SCREEN-VALUE /* CHARACTER */).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Fraccionar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Fraccionar W-Win
ON CHOOSE OF BUTTON_Fraccionar IN FRAME F-Main /* FRACCIONAR ORDEN */
DO:
    RUN Fraccionar-Orden IN h_b-genera-comprobantes-cab.
    RUN dispatch IN h_b-genera-comprobantes-cab ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Limpiar-Filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Limpiar-Filtro W-Win
ON CHOOSE OF BUTTON_Limpiar-Filtro IN FRAME F-Main /* LIMPIAR FILTRO */
DO:
    FILL-IN_NroPHR:SCREEN-VALUE = "".
    RUN Captura-Filtro IN h_b-genera-comprobantes-cab
      ( INPUT FILL-IN_NroPHR:SCREEN-VALUE /* CHARACTER */).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

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

    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'logis/b-gestor-comprobantes-cabecera.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-genera-comprobantes-cab ).
       RUN set-position IN h_b-genera-comprobantes-cab ( 3.69 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-genera-comprobantes-cab ( 9.15 , 119.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta2/b-genera-factura-credb.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-genera-factura-credb ).
       RUN set-position IN h_b-genera-factura-credb ( 12.92 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-genera-factura-credb ( 13.12 , 120.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-genera-factura-credb. */
       RUN add-link IN adm-broker-hdl ( h_b-genera-comprobantes-cab , 'Record':U , h_b-genera-factura-credb ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-genera-comprobantes-cab ,
             BUTTON_Limpiar-Filtro:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-genera-factura-credb ,
             BUTTON-exit:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 1 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

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
  DISPLAY FILL-IN_NroPHR EDITOR_Titulo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 FILL-IN_NroPHR BUTTON_Fraccionar BUTTON_Filtro 
         BUTTON_Limpiar-Filtro BUTTON-1 BUTTON-create BUTTON-exit 
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
  CASE s-TipMov:
      WHEN "ELECTRONICA"    THEN EDITOR_Titulo = "FACTURACION ELECTRONICA".
      WHEN "MANUAL"         THEN EDITOR_Titulo = "FACTURACION MANUAL".
  END CASE.
  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FIND gn-divi WHERE gn-divi.codcia = s-codcia AND
          gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
      IF AVAILABLE gn-divi THEN DO:
          CASE gn-divi.campo-char[6]:
              WHEN "SE" THEN BUTTON_Fraccionar:HIDDEN = NO.
              OTHERWISE BUTTON_Fraccionar:HIDDEN = YES.
          END CASE.
      END.
      IF s-acceso-total = NO  THEN BUTTON_Fraccionar:HIDDEN = YES.
      IF s-acceso-total = YES THEN BUTTON_Fraccionar:HIDDEN = NO.
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

