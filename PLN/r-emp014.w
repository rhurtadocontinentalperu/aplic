&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE SHARED VARIABLE s-codcia AS INTEGER.
DEFINE SHARED VARIABLE s-nomcia AS CHARACTER.
DEFINE SHARED VARIABLE s-periodo AS INTEGER.
DEFINE SHARED VARIABLE s-nromes AS INTEGER.

/* Local Variable Definitions ---                                       */
DEF VAR x-Periodo AS CHAR NO-UNDO.

RUN cbd/cb-m000 (OUTPUT x-Periodo).
IF x-Periodo = '' THEN DO:
    MESSAGE 'NO existen periodos configurados para esta compañia'
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEFINE VARIABLE FI-MENSAJE AS CHARACTER FORMAT "X(40)" NO-UNDO.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor..." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
    SKIP
    Fi-Mensaje NO-LABEL FONT 6
    SKIP     
    WITH OVERLAY CENTERED KEEP-TAB-ORDER
        SIDE-LABELS NO-UNDERLINE BGCOLOR 15 FGCOLOR 0 
        TITLE "Procesando..." FONT 7.

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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Periodo F-Codpln COMBO-BOX-Mes-1 ~
COMBO-BOX-Mes-2 FILL-IN-codper FILL-IN-codmov BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Periodo F-Codpln F-NomPla ~
COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 FILL-IN-codper FILL-IN-codmov ~
FILL-IN-desmov 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Button 1" 
     SIZE 15 BY 1.62.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Button 2" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE COMBO-BOX-Mes-1 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Desde el mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12" 
     DROP-DOWN-LIST
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Mes-2 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Hasta el mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12" 
     DROP-DOWN-LIST
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE F-Codpln AS INTEGER FORMAT "99":U INITIAL 1 
     LABEL "Planilla" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE F-NomPla AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-codmov AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Concepto" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-codper AS CHARACTER FORMAT "X(256)":U 
     LABEL "Personal" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-desmov AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Periodo AT ROW 1.27 COL 10 COLON-ALIGNED WIDGET-ID 22
     F-Codpln AT ROW 2.35 COL 10 COLON-ALIGNED WIDGET-ID 24
     F-NomPla AT ROW 2.35 COL 16 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     COMBO-BOX-Mes-1 AT ROW 3.42 COL 10 COLON-ALIGNED WIDGET-ID 18
     COMBO-BOX-Mes-2 AT ROW 3.42 COL 29 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-codper AT ROW 4.5 COL 10 COLON-ALIGNED WIDGET-ID 28
     FILL-IN-codmov AT ROW 5.58 COL 10 COLON-ALIGNED WIDGET-ID 30
     FILL-IN-desmov AT ROW 5.58 COL 16 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     BUTTON-1 AT ROW 6.65 COL 30
     BUTTON-2 AT ROW 6.65 COL 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 62 BY 7.77
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Reporte de Conceptos"
         HEIGHT             = 7.77
         WIDTH              = 62
         MAX-HEIGHT         = 7.81
         MAX-WIDTH          = 62
         VIRTUAL-HEIGHT     = 7.81
         VIRTUAL-WIDTH      = 62
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
{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN F-NomPla IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-desmov IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte de Conceptos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de Conceptos */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            F-Codpln
            COMBO-BOX-Periodo
            COMBO-BOX-Mes-1
            COMBO-BOX-Mes-2
            FILL-IN-codper
            FILL-IN-codmov.
        FIND Pl-plan WHERE Pl-plan.Codpln = F-Codpln NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Pl-plan THEN DO:
            MESSAGE
                "Código de planilla no existe"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-Codpln.
            RETURN NO-APPLY.
        END.
        F-NomPla = Pl-plan.despln.
        DISPLAY F-Codpln F-Nompla.
        FIND pl-conc WHERE pl-conc.codmov = FILL-IN-codmov NO-LOCK NO-ERROR.
        IF NOT AVAILABLE pl-conc THEN DO:
            MESSAGE
                "Código de concepto no existe"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FILL-IN-codmov.
            RETURN NO-APPLY.
        END.
        ASSIGN FILL-IN-desmov = PL-CONC.DesMov.
        DISPLAY FILL-IN-desmov.
    END.

    RUN Imprimir.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Codpln
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Codpln W-Win
ON MOUSE-SELECT-DBLCLICK OF F-Codpln IN FRAME F-Main /* Planilla */
OR F8 OF F-Codpln DO:
 DO WITH FRAME {&FRAME-NAME}:
    DEFINE VARIABLE reg-act AS ROWID.
    RUN PLN/H-PLAN.w (OUTPUT reg-act).
    IF reg-act <> ? THEN DO:
       FIND pl-plan WHERE ROWID(pl-plan) = reg-act NO-LOCK NO-ERROR.
       ASSIGN
       F-Codpln = pl-plan.codpln 
       F-Nompla = pl-plan.Despln.
       DISPLAY F-Codpln F-Nompla.       
    END.  
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codmov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codmov W-Win
ON LEAVE OF FILL-IN-codmov IN FRAME F-Main /* Concepto */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            FILL-IN-codmov.
        FIND pl-conc WHERE pl-conc.codmov = FILL-IN-codmov NO-LOCK NO-ERROR.
        IF AVAILABLE pl-conc THEN DO:
            ASSIGN FILL-IN-desmov = PL-CONC.DesMov.
            DISPLAY FILL-IN-desmov.
        END.
        ELSE DISPLAY "" @ FILL-IN-desmov.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
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
  DISPLAY COMBO-BOX-Periodo F-Codpln F-NomPla COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 
          FILL-IN-codper FILL-IN-codmov FILL-IN-desmov 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-Periodo F-Codpln COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 
         FILL-IN-codper FILL-IN-codmov BUTTON-1 BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cNomPro AS CHAR LABEL "Nombre" FORMAT "x(30)" NO-UNDO.

    DEFINE FRAME F-REPORTE
        pl-mov-mes.codper
        cNomPro
        pl-mov-mes.periodo
        pl-mov-mes.nromes
        pl-mov-mes.codcal
        pl-mov-mes.valcal-mes(TOTAL)
        WITH WIDTH 200 NO-BOX STREAM-IO DOWN.

    DEFINE FRAME F-HEADER
        HEADER
        s-nomcia
        "PAGINA:" TO 100 PAGE-NUMBER(REPORT) SKIP
        "REPORTE DE CONCEPTO POR RANGO DE MESES" SKIP
        "CONCEPTO: " FILL-IN-codmov FILL-IN-desmov
        WITH PAGE-TOP WIDTH 200 NO-LABELS NO-UNDERLINE STREAM-IO.

    VIEW STREAM report FRAME F-HEADER.

    FOR EACH pl-mov-mes WHERE
        pl-mov-mes.codcia = s-CodCia AND
        pl-mov-mes.periodo = COMBO-BOX-Periodo AND
        pl-mov-mes.nromes >= COMBO-BOX-Mes-1 AND
        pl-mov-mes.nromes <= COMBO-BOX-Mes-2 AND
        pl-mov-mes.codpln = f-codpln AND
        pl-mov-mes.codcal > 0 AND
        pl-mov-mes.codper BEGINS FILL-IN-codper AND
        pl-mov-mes.codmov = FILL-IN-codmov NO-LOCK,
        FIRST pl-pers WHERE
            pl-pers.codcia = pl-mov-mes.codcia AND
            pl-pers.codper = pl-mov-mes.codper NO-LOCK
        BREAK BY pl-mov-mes.codper BY pl-mov-mes.nromes:
        cNomPro = PL-PERS.patper + " " + PL-PERS.matper + " " + PL-PERS.nomper.
        DISPLAY
            pl-mov-mes.codper @ Fi-Mensaje LABEL " Personal" FORMAT "X(11)"
            WITH FRAME F-Proceso.
        DISPLAY STREAM REPORT
            pl-mov-mes.codper   WHEN FIRST-OF(pl-mov-mes.codper)
            cNomPro             WHEN FIRST-OF(pl-mov-mes.codper)
            pl-mov-mes.periodo
            pl-mov-mes.nromes
            pl-mov-mes.codcal
            pl-mov-mes.valcal-mes(TOTAL BY pl-mov-mes.codper)
            WITH FRAME F-REPORTE.
    END.

    HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 66.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 66. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

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

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        COMBO-BOX-Periodo:LIST-ITEMS = x-Periodo
        COMBO-BOX-Periodo = s-periodo 
        COMBO-BOX-Mes-1 = s-nromes
        COMBO-BOX-Mes-2 = s-nromes
        F-Codpln = 01 .
    FIND Pl-plan WHERE Pl-plan.Codpln = F-Codpln NO-LOCK NO-ERROR.
    IF AVAILABLE Pl-plan THEN F-NomPla = Pl-plan.despln.    

  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    DO WITH FRAME {&FRAME-NAME}:
        DISPLAY F-Codpln F-Nompla COMBO-BOX-Mes-1 COMBO-BOX-Mes-2.
    END.

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
        WHEN "FILL-IN-CCosto" THEN 
            ASSIGN
                input-var-1 = "CCO"
                input-var-2 = ""
                input-var-3 = "".
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

