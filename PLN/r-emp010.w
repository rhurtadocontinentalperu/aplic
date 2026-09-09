&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-periodo AS INT.
DEF SHARED VAR s-nromes AS INT.
DEF SHARED VAR s-nomcia AS CHAR.

DEFINE VARIABLE cPeriodo AS CHARACTER NO-UNDO.

RUN cbd/cb-m000 (OUTPUT cPeriodo).
IF cPeriodo = '' THEN DO:
    MESSAGE
        'NO existen periodos configurados para esta compañia'
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

DEFINE TEMP-TABLE wrk_report NO-UNDO
    FIELDS wrk_codper LIKE pl-pers.codper
    FIELDS wrk_nomper AS CHARACTER
        FORMAT "X(60)" LABEL "Apellidos y Nombres"
    FIELDS wrk_cargo LIKE pl-flg-mes.cargos
    FIELDS wrk_senati AS INTEGER LABEL "Cod" FORMAT "9"
    FIELDS wrk_valcal AS DECIMAL LABEL "Mes" EXTENT 12
    INDEX IDX01 AS PRIMARY wrk_codper.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Periodo BUTTON-1 BUTTON-2 BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Periodo 

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
     SIZE 15 BY 1.54 TOOLTIP "Aceptar".

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Button 2" 
     SIZE 15 BY 1.54 TOOLTIP "Cancelar".

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img\tbldat":U
     LABEL "Button 3" 
     SIZE 15 BY 1.5 TOOLTIP "Salida a archivo".

DEFINE VARIABLE COMBO-BOX-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     SIZE 7 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Periodo AT ROW 2.73 COL 20 COLON-ALIGNED
     BUTTON-1 AT ROW 1.38 COL 50
     BUTTON-2 AT ROW 3.12 COL 50
     BUTTON-3 AT ROW 4.85 COL 50
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17
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
         TITLE              = "Resumen Anual de Haberes Mensuales"
         HEIGHT             = 5.62
         WIDTH              = 71.86
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Resumen Anual de Haberes Mensuales */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Resumen Anual de Haberes Mensuales */
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
    ASSIGN COMBO-BOX-Periodo.
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


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
    ASSIGN COMBO-BOX-Periodo.
    RUN Texto.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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

    DEFINE BUFFER b-MOV-MES FOR PL-MOV-MES.

    FOR EACH wrk_report:
        DELETE wrk_report.
    END.

    FOR EACH PL-MOV-MES NO-LOCK WHERE
        PL-MOV-MES.codcia  = s-codcia AND
        PL-MOV-MES.periodo = COMBO-BOX-Periodo AND
        PL-MOV-MES.nromes  >= 1 AND
        PL-MOV-MES.codpln  = 01 AND
        (PL-MOV-MES.codcal = 001 OR PL-MOV-MES.codcal = 004) AND
        LOOKUP(STRING(PL-MOV-MES.codmov),
        "101,136,103,125,126,127,209,131,134,138,116,139,106,107,108,212") > 0
        BREAK BY PL-MOV-MES.codper:
        IF FIRST-OF(PL-MOV-MES.codper) THEN DO:
            FIND FIRST wrk_report WHERE
                wrk_codper = PL-MOV-MES.CodPer
                NO-ERROR.
            IF NOT AVAILABLE wrk_report THEN DO:
                CREATE wrk_report.
                ASSIGN
                    wrk_codper = PL-MOV-MES.CodPer.
                FIND pl-pers WHERE
                    pl-pers.codper = PL-MOV-MES.codper
                    NO-LOCK NO-ERROR.
                IF AVAILABLE pl-pers THEN
                    wrk_nomper = pl-pers.patper + " " + pl-pers.matper + " " + pl-pers.nomper.
                FIND pl-flg-mes WHERE
                    pl-flg-mes.codcia = PL-MOV-MES.codcia AND
                    pl-flg-mes.periodo = PL-MOV-MES.periodo AND
                    pl-flg-mes.codpln = PL-MOV-MES.codpln AND
                    pl-flg-mes.nromes = PL-MOV-MES.nromes AND
                    pl-flg-mes.codper = PL-MOV-MES.codper
                    NO-LOCK NO-ERROR.
                IF AVAILABLE pl-flg-mes THEN
                    wrk_cargo = pl-flg-mes.cargos.
            END.
            DISPLAY
                pl-mov-mes.codper @ Fi-Mensaje
                LABEL "    Personal" FORMAT "X(13)"
                WITH FRAME F-Proceso.
            /* Captura Senati */
            FIND b-MOV-MES WHERE
                b-MOV-MES.CodCia  = PL-MOV-MES.CodCia AND
                b-MOV-MES.Periodo = PL-MOV-MES.periodo AND
                b-MOV-MES.NroMes  = PL-MOV-MES.nromes AND
                b-MOV-MES.CodPln  = PL-MOV-MES.CodPln AND
                b-MOV-MES.CodCal  = PL-MOV-MES.CodCal AND
                b-MOV-MES.codper  = PL-MOV-MES.CodPer AND
                b-MOV-MES.codmov  = 018 NO-ERROR.
            IF AVAILABLE b-MOV-MES THEN
                wrk_Senati = INTEGER(b-MOV-MES.valcal-mes).
        END.
        wrk_valcal[PL-MOV-MES.nromes] =
            wrk_valcal[PL-MOV-MES.nromes] +
            PL-MOV-MES.valcal-mes.
    END.
    HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
  DISPLAY COMBO-BOX-Periodo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-Periodo BUTTON-1 BUTTON-2 BUTTON-3 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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

    DEFINE VARIABLE dTotal AS DECIMAL NO-UNDO.
    DEFINE VARIABLE iInd AS INTEGER NO-UNDO.

    DEFINE FRAME F-REPORTE
        wrk_codper
        wrk_nomper
        wrk_cargo
        wrk_senati
        wrk_valcal[1] FORMAT '>>>>>>9.99' COLUMN-LABEL "Enero"
        wrk_valcal[2] FORMAT '>>>>>>9.99' COLUMN-LABEL "Febrero"
        wrk_valcal[3] FORMAT '>>>>>>9.99' COLUMN-LABEL "Marzo"
        wrk_valcal[4] FORMAT '>>>>>>9.99' COLUMN-LABEL "Abril"
        wrk_valcal[5] FORMAT '>>>>>>9.99' COLUMN-LABEL "Mayo"
        wrk_valcal[6] FORMAT '>>>>>>9.99' COLUMN-LABEL "Junio"
        wrk_valcal[7] FORMAT '>>>>>>9.99' COLUMN-LABEL "Julio"
        wrk_valcal[8] FORMAT '>>>>>>9.99' COLUMN-LABEL "Agosto"
        wrk_valcal[9] FORMAT '>>>>>>9.99' COLUMN-LABEL "Setiembre"
        wrk_valcal[10] FORMAT '>>>>>>9.99' COLUMN-LABEL "Octubre"
        wrk_valcal[11] FORMAT '>>>>>>9.99' COLUMN-LABEL "Noviembre"
        wrk_valcal[12] FORMAT '>>>>>>9.99' COLUMN-LABEL "Diciembre"
        dTotal FORMAT '>>>>>>9.99' COLUMN-LABEL "Total"
        WITH WIDTH 250 NO-BOX STREAM-IO DOWN.

    DEFINE FRAME F-HEADER       
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(45)" SKIP
        {&PRN6A} + "REPORTE ANUAL DE HABERES MENSUALES" AT 100 FORMAT 'x(35)'
        {&PRN3} + {&PRN6B} + "Pagina : " AT 200 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN4} + "Fecha : " AT 200 STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)"
        "Hora  : " AT 200 STRING(TIME,"HH:MM:SS") SKIP
        WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

    FOR EACH wrk_report NO-LOCK:
        VIEW STREAM REPORT FRAME F-HEADER.
        dTotal = 0.
        DO iInd = 1 TO 12:
            dTotal = dTotal + wrk_valcal[iInd].
        END.
        DISPLAY STREAM REPORT
            wrk_codper
            wrk_nomper
            wrk_cargo
            wrk_senati
            wrk_valcal[1]
            wrk_valcal[2]
            wrk_valcal[3]
            wrk_valcal[4]
            wrk_valcal[5]
            wrk_valcal[6]
            wrk_valcal[7]
            wrk_valcal[8]
            wrk_valcal[9]
            wrk_valcal[10]
            wrk_valcal[11]
            wrk_valcal[12]
            dTotal
            WITH FRAME F-REPORTE.
    END.

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

    RUN Carga-Temporal.

    FIND FIRST wrk_report NO-LOCK NO-ERROR.
    IF NOT AVAILABLE wrk_report THEN DO:
        MESSAGE
            "No hay registros a imprimir"
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
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
        COMBO-BOX-Periodo:LIST-ITEMS = cPeriodo
        COMBO-BOX-Periodo = s-periodo.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto W-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lRpta AS LOGICAL NO-UNDO.
    DEFINE VARIABLE cArchivo AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dTotal AS DECIMAL NO-UNDO.
    DEFINE VARIABLE iInd AS INTEGER NO-UNDO.

    DEFINE FRAME F-REPORTE
        wrk_codper
        wrk_nomper
        wrk_cargo
        wrk_senati
        wrk_valcal[1] FORMAT '>>>>>>9.99' COLUMN-LABEL "Enero"
        wrk_valcal[2] FORMAT '>>>>>>9.99' COLUMN-LABEL "Febrero"
        wrk_valcal[3] FORMAT '>>>>>>9.99' COLUMN-LABEL "Marzo"
        wrk_valcal[4] FORMAT '>>>>>>9.99' COLUMN-LABEL "Abril"
        wrk_valcal[5] FORMAT '>>>>>>9.99' COLUMN-LABEL "Mayo"
        wrk_valcal[6] FORMAT '>>>>>>9.99' COLUMN-LABEL "Junio"
        wrk_valcal[7] FORMAT '>>>>>>9.99' COLUMN-LABEL "Julio"
        wrk_valcal[8] FORMAT '>>>>>>9.99' COLUMN-LABEL "Agosto"
        wrk_valcal[9] FORMAT '>>>>>>9.99' COLUMN-LABEL "Setiembre"
        wrk_valcal[10] FORMAT '>>>>>>9.99' COLUMN-LABEL "Octubre"
        wrk_valcal[11] FORMAT '>>>>>>9.99' COLUMN-LABEL "Noviembre"
        wrk_valcal[12] FORMAT '>>>>>>9.99' COLUMN-LABEL "Diciembre"
        dTotal FORMAT '>>>>>>9.99' COLUMN-LABEL "Total"
        WITH WIDTH 250 NO-BOX STREAM-IO DOWN.

    cArchivo = 'Empleados' + STRING(COMBO-BOX-Periodo, '9999') + '.txt'.
    SYSTEM-DIALOG GET-FILE cArchivo
        FILTERS 'Texto' '*.txt'
        ASK-OVERWRITE
        CREATE-TEST-FILE
        DEFAULT-EXTENSION '.txt'
        INITIAL-DIR 'M:\'
        RETURN-TO-START-DIR 
        USE-FILENAME
        SAVE-AS
        UPDATE lRpta.
    IF lRpta = NO THEN RETURN.
    RUN Carga-Temporal.
    FIND FIRST wrk_report NO-LOCK NO-ERROR.
    IF NOT AVAILABLE wrk_report THEN DO:
        MESSAGE
            "No hay registros a imprimir"
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    OUTPUT STREAM REPORT TO VALUE(cArchivo).
    FOR EACH wrk_report NO-LOCK:
        dTotal = 0.
        DO iInd = 1 TO 12:
            dTotal = dTotal + wrk_valcal[iInd].
        END.
        DISPLAY STREAM REPORT
            wrk_codper
            wrk_nomper
            wrk_cargo
            wrk_senati
            wrk_valcal[1]
            wrk_valcal[2]
            wrk_valcal[3]
            wrk_valcal[4]
            wrk_valcal[5]
            wrk_valcal[6]
            wrk_valcal[7]
            wrk_valcal[8]
            wrk_valcal[9]
            wrk_valcal[10]
            wrk_valcal[11]
            wrk_valcal[12]
            dTotal
            WITH FRAME F-REPORTE.
    END.
    PAGE STREAM REPORT.
    OUTPUT STREAM REPORT CLOSE.
    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


