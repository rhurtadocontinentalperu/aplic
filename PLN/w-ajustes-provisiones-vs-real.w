&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
/* Procedure Description
"Generaci¢n de calculos de planilla"
*/
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win
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

/* Local Variable Definitions ---                                       */

DEFINE SHARED VAR s-codcia AS INT.

DEFINE VAR lMesPagoReal AS INT INIT 7.  /* 7:Gratificacion Julio  12 : Grati Diciembre */
DEFINE VAR lTipoCalculo AS INT INIT 004.   /* Pago Gratificaicones (codcal) */
DEFINE VAR lTipoProvision AS INT INIT 011.   /* Provision Gratificaicones (codcal) */
DEFINE VAR lConcPago AS INT INIT 403.   /* Pago total (codmov)*/
DEFINE VAR lDscCalculo AS CHAR.

DEFINE VAR lMesDesde AS INT.
DEFINE VAR lMesHasta AS INT.
DEFINE VAR lYearDesde AS INT.
DEFINE VAR lYearHasta AS INT.
DEFINE VAR lQMeses AS INT.

DEFINE TEMP-TABLE tt-mov-pla
    FIELDS tt-codper LIKE pl-mov-mes.codper
    FIELDS tt-nombre AS CHAR FORMAT 'x(50)'
    FIELDS tt-provision AS DEC INIT 0 EXTENT 12
    FIELDS tt-real AS DEC INIT 0

    INDEX idx01 IS PRIMARY tt-codper.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES INTEGRAL.PL-PLAN
&Scoped-define FIRST-EXTERNAL-TABLE INTEGRAL.PL-PLAN


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR INTEGRAL.PL-PLAN.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rbGratiPeriodo rbCalculo rbCTSPeriodo ~
btnCalcular txtYear 
&Scoped-Define DISPLAYED-OBJECTS rbGratiPeriodo rbCalculo rbCTSPeriodo ~
txtYear 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-navico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-plan AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-plan AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnCalcular 
     LABEL "Calcular" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtYear AS INTEGER FORMAT ">,>>9":U INITIAL 0 
     LABEL "Año" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE rbCalculo AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Gratificaciones", 4,
"Vacaciones", 3,
"C.T.S.", 6
     SIZE 19 BY 2.5 NO-UNDO.

DEFINE VARIABLE rbCTSPeriodo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Noviembre - Abril", 4,
"Mayo - Octubre", 10
     SIZE 38 BY .96 NO-UNDO.

DEFINE VARIABLE rbGratiPeriodo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Julio", 7,
"Diciembre", 12
     SIZE 21 BY .96 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     rbGratiPeriodo AT ROW 3.04 COL 31.14 NO-LABEL WIDGET-ID 14
     rbCalculo AT ROW 3.12 COL 11 NO-LABEL WIDGET-ID 10
     rbCTSPeriodo AT ROW 4.65 COL 31.14 NO-LABEL WIDGET-ID 18
     btnCalcular AT ROW 6.19 COL 49 WIDGET-ID 4
     txtYear AT ROW 6.38 COL 27 COLON-ALIGNED WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 75.14 BY 7.31.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   External Tables: INTEGRAL.PL-PLAN
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Ajustes provisiones vs real"
         HEIGHT             = 7.31
         WIDTH              = 75.14
         MAX-HEIGHT         = 10.69
         MAX-WIDTH          = 79.14
         VIRTUAL-HEIGHT     = 10.69
         VIRTUAL-WIDTH      = 79.14
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Ajustes provisiones vs real */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Ajustes provisiones vs real */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnCalcular
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnCalcular W-Win
ON CHOOSE OF btnCalcular IN FRAME F-Main /* Calcular */
DO:
    ASSIGN txtYear RbCalculo rbGratiPeriodo rbCTSPeriodo.

    lTipoCalculo = RbCalculo.
    lConcPago = 403.
    CASE RbCalculo:
        WHEN 004 THEN DO:   /* Gratificaciones */
            lTipoProvision = 011.
            lMesPagoReal = rbGratiPeriodo.

            IF rbGratiPeriodo = 7 THEN DO:
                lMesDesde = 1.
                lMesHasta = 6.
            END.
            ELSE DO:
                lMesDesde = 7.
                lMesHasta = 12.
            END.
            lYearDesde = txtYear.
            lYearHasta = txtYear.
            lDscCalculo = "GRATIFICACIONES".
        END.
        WHEN 003 THEN DO:   /* Vacaciones */
            lTipoProvision = 010.
            lDscCalculo = "VACACIONES".
        END.
        WHEN 006 THEN DO:   /* C.T.S. */
            lTipoProvision = 009.       
            lMesPagoReal = rbCTSPeriodo.
            lDscCalculo = "C.T.S.".

            IF rbCTSPeriodo = 4 THEN DO:                
                lMesDesde = 11.
                lMesHasta = 04.
                lYearDesde = txtYear - 1.
                lYearHasta = txtYear.
            END.
            ELSE DO:
                lMesDesde = 05.
                lMesHasta = 10.
                lYearDesde = txtYear.
                lYearHasta = txtYear.
            END.
        END.                  
    END CASE.

    RUN ue-calcular.
END.
/*
    DEFINE VAR lMesPagoReal AS INT INIT 7.  /* 7:Gratificacion Julio  12 : Grati Diciembre */
    DEFINE VAR lTipoCalculo AS INT INIT 004.   /* Pago Gratificaicones (codcal) */
    DEFINE VAR lTipoProvision AS INT INIT 011.   /* Provision Gratificaicones (codcal) */
    DEFINE VAR lConcPago AS INT INIT 403.   /* Pago total (codmov)*/
*/
/*
DEFINE VAR lMesDesde AS INT.
DEFINE VAR lMesHasta AS INT.
DEFINE VAR lYearDesde AS INT.
DEFINE VAR lYearHasta AS INT.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

FIND FIRST pl-plan.

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
             INPUT  'pln/v-plan.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-plan ).
       RUN set-position IN h_v-plan ( 1.19 , 9.14 ) NO-ERROR.
       /* Size in UIB:  ( 1.35 , 52.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-navico.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 2.73 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 4.04 , 6.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pln/q-plan.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-plan ).
       RUN set-position IN h_q-plan ( 1.19 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.31 , 7.00 ) */

       /* Links to SmartViewer h_v-plan. */
       RUN add-link IN adm-broker-hdl ( h_q-plan , 'Record':U , h_v-plan ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-plan ,
             rbGratiPeriodo:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico ,
             h_v-plan , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-plan ,
             txtYear:HANDLE IN FRAME F-Main , 'AFTER':U ).
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "INTEGRAL.PL-PLAN"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "INTEGRAL.PL-PLAN"}

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
  DISPLAY rbGratiPeriodo rbCalculo rbCTSPeriodo txtYear 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE rbGratiPeriodo rbCalculo rbCTSPeriodo btnCalcular txtYear 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-show-errors W-Win 
PROCEDURE local-show-errors :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  message "ERROR CAPTURADO" VIEW-AS ALERT-BOX.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'show-errors':U ) .

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "INTEGRAL.PL-PLAN"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-calcular W-Win 
PROCEDURE ue-calcular :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-mov-pla.

SESSION:SET-WAIT-STATE('GENERAL').
RUN ue-pago-gratificacion.
RUN ue-provisiones.
RUN ue-excel.
SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-excel W-Win 
PROCEDURE ue-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

DEFINE VAR lSec AS INT.
DEFINE VAR lCelda AS CHAR.
DEFINE VAR lSuma AS DEC.

lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

iColumn = 1.
cColumn = STRING(iColumn).
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = lDscCalculo.

iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Codigo".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "ApPat ApMat Nombre".

DO lSec = 1 TO lQMeses:
    cRange = CHR(66 + lSec) + cColumn.
    chWorkSheet:Range(cRange):Value = "Provision Mes(" + STRING(lSec,"99") + ")".
END.
cRange = CHR(66 + lSec) + cColumn.
chWorkSheet:Range(cRange):Value = "Total Provision".
cRange = CHR(66 + lSec + 1) + cColumn.
chWorkSheet:Range(cRange):Value = "Ejecutado".
cRange = CHR(66 + lSec + 2) + cColumn.
chWorkSheet:Range(cRange):Value = "Provision - Ejecutado".

FOR EACH tt-mov-pla NO-LOCK :
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-codper.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-nombre.

    lSuma = 0.
    DO lSec = 1 TO lQMeses:
        cRange = CHR(66 + lSec) + cColumn.
        chWorkSheet:Range(cRange):Value = tt-provision[lSec].
        lSuma = lSuma + tt-provision[lSec].
    END.
    cRange = CHR(66 + lSec) + cColumn.
    chWorkSheet:Range(cRange):Value = lSuma.
    cRange = CHR(66 + lSec + 1) + cColumn.
    chWorkSheet:Range(cRange):Value = tt-real.
    cRange = CHR(66 + lSec + 2) + cColumn.
    chWorkSheet:Range(cRange):Value = lSuma - tt-real .
END.

{lib\excel-close-file.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-pago-gratificacion W-Win 
PROCEDURE ue-pago-gratificacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR XConcPago AS INT.

XConcPago = lConcPago.

/* Cuando es PAGO de gratificacion no considerar el adicional */
IF lTipoCalculo = 004 THEN XConcPago = 212.

FOR EACH pl-mov-mes WHERE pl-mov-mes.codcia = s-codcia AND
                    pl-mov-mes.periodo = txtYear AND 
                    pl-mov-mes.nromes = lMesPagoReal AND
                    pl-mov-mes.codpln = pl-plan.codpln AND 
                    pl-mov-mes.codcal = lTipoCalculo AND
                    pl-mov-mes.codmov = XConcPago NO-LOCK:

    IF pl-mov-mes.valcal-mes <= 0  THEN NEXT.
    FIND FIRST pl-pers WHERE pl-pers.codper = pl-mov-mes.codper NO-LOCK NO-ERROR.

    FIND FIRST tt-mov-pla WHERE tt-mov-pla.tt-codper = pl-mov-mes.codper EXCLUSIVE NO-ERROR.
    IF NOT AVAILABLE tt-mov-pla THEN DO:
        CREATE tt-mov-pla.
            ASSIGN tt-mov-pla.tt-codper = pl-mov-mes.codper
                    tt-mov-pla.tt-nombre = trim(pl-pers.patper)  + " " +
                                            TRIM(pl-pers.matper) + " " +
                                            TRIM(pl-pers.nomper).
    END.
    ASSIGN tt-mov-pla.tt-real = tt-mov-pla.tt-real + pl-mov-mes.valcal-mes.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-provisiones W-Win 
PROCEDURE ue-provisiones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lMes AS INT.
DEFINE VAR lYEar AS INT.
DEFINE VAR lHasta AS INT.
DEFINE VAR lDesde AS INT.

FOR EACH tt-mov-pla EXCLUSIVE :

    lQMeses = 0.

    DO lYear = lYearDesde TO lYearHasta :
        /**/
        IF lYear = lYearDesde THEN DO:
            lDesde = lMesDesde.
        END.
        ELSE lDesde = 1.
        /**/
        IF lYear = lYearHasta THEN DO:
            lHasta = lMesHasta.
        END.
        ELSE lHasta = 12.  

        DO lMes = lDesde TO lHasta:
            lQMeses = lQMeses + 1.
            FIND FIRST pl-mov-mes WHERE pl-mov-mes.codcia = s-codcia AND
                                pl-mov-mes.periodo = lYear AND 
                                pl-mov-mes.Nromes = lMes AND
                                pl-mov-mes.codpln = pl-plan.codpln AND
                                pl-mov-mes.codcal = lTipoProvision AND
                                pl-mov-mes.codper = tt-mov-pla.tt-codper AND
                                pl-mov-mes.codmov = lConcPago NO-LOCK NO-ERROR.
            IF AVAILABLE pl-mov-mes THEN DO:
               ASSIGN tt-mov-pla.tt-provision[lQMeses] = tt-mov-pla.tt-provision[lQMeses] + 
                                pl-mov-mes.valcal-mes.
            END.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

