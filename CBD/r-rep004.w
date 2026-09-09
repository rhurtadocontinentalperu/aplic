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
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR s-Periodo AS INT.

DEFINE TEMP-TABLE wrkp_prod
    FIELDS wrkp_ordpro LIKE Almcmov.nrorf1 COLUMN-LABEL "Nro OP"
    FIELDS wrkp_fching LIKE Almdmov.FchDoc FORMAT "99/99/99" COLUMN-LABEL "Fecha!Ingreso"
    FIELDS wrkp_nroing LIKE Almdmov.NroDoc COLUMN-LABEL "Nro Doc"
    FIELDS wrkp_iteing LIKE Almdmov.codmat COLUMN-LABEL "Código!Artículo"
    FIELDS wrkp_desing LIKE Almmmatg.desmat
    FIELDS wrkp_uming  LIKE Almdmov.CodUnd FORMAT "xxx"
    FIELDS wrkp_qtying LIKE Almdmov.CanDes
    INDEX idx01 wrkp_ordpro.

DEFINE TEMP-TABLE wrkpd_prod
    FIELDS wrkpd_ordpro LIKE Almcmov.nrorf1 COLUMN-LABEL "Nro OP"
    FIELDS wrkpd_fchsal LIKE Almdmov.FchDoc FORMAT "99/99/99" COLUMN-LABEL "Fecha!Salida"
    FIELDS wrkpd_nrosal LIKE Almdmov.NroDoc COLUMN-LABEL "Nro Doc"
    FIELDS wrkpd_itesal LIKE Almdmov.codmat COLUMN-LABEL "Código!Artículo"
    FIELDS wrkpd_dessal LIKE Almmmatg.desmat
    FIELDS wrkpd_umsal  LIKE Almdmov.CodUnd FORMAT "xxx"
    FIELDS wrkpd_qtysal LIKE Almdmov.CanDes
    INDEX idx01 wrkpd_ordpro.

DEFINE VARIABLE FI-MENSAJE AS CHAR FORMAT "X(40)" NO-UNDO.
DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6 SKIP
    Fi-Mensaje NO-LABEL FONT 6 SKIP     
    WITH OVERLAY CENTERED KEEP-TAB-ORDER
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE
        BGCOLOR 15 FGCOLOR 0
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
&Scoped-Define ENABLED-OBJECTS FILL-IN-fecha FILL-IN-fecha-2 Btn_Print ~
Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-fecha FILL-IN-fecha-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Salir" 
     SIZE 15 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_Excel 
     IMAGE-UP FILE "img\excel":U
     LABEL "Excel" 
     SIZE 15 BY 1.54 TOOLTIP "Genera archivo texto"
     BGCOLOR 8 .

DEFINE BUTTON Btn_Print 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Imprimir" 
     SIZE 15 BY 1.54.

DEFINE VARIABLE FILL-IN-fecha AS DATE FORMAT "99/99/99":U 
     LABEL "Desde Fecha" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-fecha-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta Fecha" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-fecha AT ROW 2.73 COL 20 COLON-ALIGNED
     FILL-IN-fecha-2 AT ROW 2.73 COL 41 COLON-ALIGNED
     Btn_Excel AT ROW 5.42 COL 19
     Btn_Print AT ROW 5.42 COL 34
     Btn_Done AT ROW 5.42 COL 49
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 65.43 BY 7.12
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
         TITLE              = "REPORTE DE INGRESOS Y SALIDAS DE PRODUCCIÓN"
         HEIGHT             = 7.12
         WIDTH              = 65.43
         MAX-HEIGHT         = 7.12
         MAX-WIDTH          = 65.43
         VIRTUAL-HEIGHT     = 7.12
         VIRTUAL-WIDTH      = 65.43
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

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR BUTTON Btn_Excel IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       Btn_Excel:HIDDEN IN FRAME F-Main           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE INGRESOS Y SALIDAS DE PRODUCCIÓN */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE INGRESOS Y SALIDAS DE PRODUCCIÓN */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Salir */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Excel W-Win
ON CHOOSE OF Btn_Excel IN FRAME F-Main /* Excel */
DO:

    ASSIGN FILL-IN-fecha FILL-IN-fecha-2.
    RUN Excel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Print W-Win
ON CHOOSE OF Btn_Print IN FRAME F-Main /* Imprimir */
DO:
    ASSIGN FILL-IN-fecha FILL-IN-fecha-2.
    RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
/*{src/adm/template/cntnrwin.i}*/

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
  DISPLAY FILL-IN-fecha FILL-IN-fecha-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-fecha FILL-IN-fecha-2 Btn_Print Btn_Done 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1.
    DEFINE VARIABLE cColumn            AS CHARACTER.
    DEFINE VARIABLE cRange             AS CHARACTER.
/* HABILITAR EN CASO LO SOLICITEN...
    RUN proc_carga-temp.

    IF NOT CAN-FIND (FIRST wrkp_prod) THEN DO:
        MESSAGE
            "No existen registros a imprimir"
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* set the column names for the Worksheet */
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "INGRESOS Y SALIDAS DE PRODUCCIÓN".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value =
        " DESDE: " + STRING(FILL-IN-fecha) +
        " HASTA: " + STRING(FILL-IN-fecha-2).
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "ORD PROD".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "FECHA".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "NÚMERO".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "PRODUCTO".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "DESCRIPCIÓN".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "UNIDAD".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "CANTIDAD".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "FECHA".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "NÚMERO".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "PRODUCTO".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "DESCRIPCIÓN".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "UNIDAD".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "CANTIDAD".

    chWorkSheet:Columns("A"):NumberFormat = "@".
    chWorkSheet:Columns("C"):NumberFormat = "@".
    chWorkSheet:Columns("I"):NumberFormat = "@".
    chWorkSheet:Columns("E"):ColumnWidth = 70.
    chWorkSheet:Columns("K"):ColumnWidth = 70.
    chWorkSheet:Range("A1:M3"):Font:Bold = TRUE.

    FOR EACH wrkp_prod NO-LOCK BREAK BY wrkp_ordpro:

        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = wrkp_ordpro.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = wrkp_fching.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = wrkp_nroing.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = wrkp_iteing.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = wrkp_desing.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = wrkp_uming.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = wrkp_qtying.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = wrkp_fchsal.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = wrkp_nrosal.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = wrkp_itesal.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = wrkp_dessal.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = wrkp_umsal.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = wrkp_qtysal.

        DISPLAY
            wrkp_ordpro @ FI-MENSAJE
            WITH FRAME F-PROCESO.

    END.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

    HIDE FRAME F-PROCESO.
    MESSAGE
        "Proceso Terminado con suceso"
        VIEW-AS ALERT-BOX INFORMA.
*/
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

    DEFINE VARIABLE iCount-Cab AS INTEGER NO-UNDO.
    DEFINE VARIABLE iCount-Aux AS INTEGER NO-UNDO.

    DEFINE BUFFER b-wrkp_prod FOR wrkp_prod.

    DEFINE FRAME f-cab
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + s-nomcia + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(80)" SKIP
        "INGRESOS Y SALIDAD DE PRODUCCIÓN" FORMAT "x(32)" AT 90
        "Página :" TO 190 PAGE-NUMBER(report) FORMAT "ZZ9" TO 200 SKIP
        "DEL" FILL-IN-fecha "AL" FILL-IN-fecha-2
        "Fecha  :" TO 190 STRING(TODAY,"99/99/99") TO 200
        "Hora   :" TO 190 STRING(TIME,"HH:MM:SS") TO 200
        WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

    DEFINE FRAME f-det
        wrkp_prod.wrkp_ordpro
        wrkp_prod.wrkp_fching
        wrkp_prod.wrkp_nroing
        wrkp_prod.wrkp_iteing
        wrkp_prod.wrkp_desing
        wrkp_prod.wrkp_uming
        wrkp_prod.wrkp_qtying
        wrkpd_fchsal
        wrkpd_nrosal
        wrkpd_itesal
        wrkpd_dessal
        wrkpd_umsal
        wrkpd_qtysal
        WITH DOWN STREAM-IO WIDTH 320.

    VIEW STREAM report FRAME f-cab.

    FOR EACH wrkp_prod NO-LOCK BREAK BY wrkp_prod.wrkp_ordpro
        WITH FRAME f-det:
        IF FIRST-OF(wrkp_prod.wrkp_ordpro) THEN DO:
            DISPLAY
                wrkp_ordpro @ FI-MENSAJE LABEL "    OP"
                WITH FRAME F-PROCESO.
            iCount-Cab = 0.
            iCount-Aux = 0.
            FOR EACH b-wrkp_prod NO-LOCK WHERE
                b-wrkp_prod.wrkp_ordpro = wrkp_prod.wrkp_ordpro:
                iCount-Cab = iCount-Cab + 1.
            END.
            FIND FIRST wrkpd_prod WHERE
                wrkpd_ordpro = wrkp_prod.wrkp_ordpro
                NO-LOCK NO-ERROR.
        END.
        DISPLAY STREAM report
            wrkp_prod.wrkp_ordpro /* WHEN FIRST-OF(wrkp_ordpro) */
            wrkp_prod.wrkp_fching
            wrkp_prod.wrkp_nroing
            wrkp_prod.wrkp_iteing
            wrkp_prod.wrkp_desing
            wrkp_prod.wrkp_uming
            wrkp_prod.wrkp_qtying.
        iCount-Aux = iCount-Aux + 1.
        IF AVAILABLE wrkpd_prod THEN DO:
            DISPLAY STREAM report
                wrkpd_fchsal
                wrkpd_nrosal
                wrkpd_itesal
                wrkpd_dessal
                wrkpd_umsal
                wrkpd_qtysal.
            FIND NEXT wrkpd_prod WHERE
                wrkpd_ordpro = wrkp_prod.wrkp_ordpro
                NO-LOCK NO-ERROR.
        END.
        IF iCount-Aux = iCount-Cab THEN
            REPEAT WHILE AVAILABLE wrkpd_prod:
            DOWN STREAM report 1 WITH FRAME f-det.
            DISPLAY STREAM report
                wrkpd_fchsal
                wrkpd_nrosal
                wrkpd_itesal
                wrkpd_dessal
                wrkpd_umsal
                wrkpd_qtysal
                WITH FRAME f-det.
            FIND NEXT wrkpd_prod WHERE
                wrkpd_ordpro = wrkp_prod.wrkp_ordpro
                NO-LOCK NO-ERROR.
        END.

        IF LAST-OF(wrkp_prod.wrkp_ordpro) AND
            NOT LAST(wrkp_prod.wrkp_ordpro) THEN
            DOWN STREAM report 1 WITH FRAME f-det.

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

    RUN proc_carga-temp.

    IF NOT CAN-FIND (FIRST wrkp_prod) THEN DO:
        MESSAGE
            "No existen registros a imprimir"
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
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
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

    ASSIGN
        FILL-IN-fecha = DATE(MONTH(TODAY),1,YEAR(TODAY))
        FILL-IN-fecha-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_carga-temp W-Win 
PROCEDURE proc_carga-temp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE dqtysal AS DECIMAL NO-UNDO.
DEFINE VARIABLE dqtying AS DECIMAL NO-UNDO.
DEFINE VARIABLE lfirst AS LOGICAL NO-UNDO.
DEFINE VARIABLE cNroOP AS CHARACTER NO-UNDO.

DISPLAY WITH FRAME F-PROCESO.

FOR EACH wrkp_prod:
    DELETE wrkp_prod.
END.
FOR EACH wrkpd_prod:
    DELETE wrkpd_prod.
END.

/* Ingresos */
FOR EACH Almmmatg NO-LOCK WHERE
    Almmmatg.codcia = s-codcia,
    EACH Almdmov NO-LOCK USE-INDEX ALMD02 WHERE
    Almdmov.CodCia = Almmmatg.codcia AND
    Almdmov.codmat = Almmmatg.CodMat AND
    Almdmov.FchDoc >= FILL-IN-fecha AND
    Almdmov.FchDoc <= FILL-IN-fecha-2 AND
    Almdmov.TipMov = "I" AND
    Almdmov.codmov = 50:

    FIND Almcmov WHERE
        Almcmov.CodCia = Almdmov.codcia AND
        Almcmov.CodAlm = Almdmov.codalm AND
        Almcmov.TipMov = Almdmov.tipmov AND
        Almcmov.CodMov = Almdmov.codmov AND
        Almcmov.NroDoc = Almdmov.nrodoc NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almcmov THEN NEXT.

    /* Busca OT */
    FIND pr-odpc WHERE
        pr-odpc.codcia = Almcmov.codcia AND
        PR-ODPC.NumOrd = SUBSTRING(Almcmov.nrorf1,3) NO-LOCK NO-ERROR.

    dqtying = Almdmov.CanDes * Almdmov.Factor.
    cNroOP = Almcmov.nrorf1.

    DISPLAY
        cNroOP @ FI-MENSAJE LABEL "    OP"
        WITH FRAME F-PROCESO.

    CREATE wrkp_prod.
    ASSIGN
        wrkp_ordpro = Almcmov.nrorf1
        wrkp_fching = Almdmov.FchDoc
        wrkp_nroing = Almdmov.NroDoc
        wrkp_iteing = Almdmov.codmat
        wrkp_desing = Almmmatg.desmat
        wrkp_uming  = Almdmov.CodUnd
        wrkp_qtying = dqtying.

END.

/* Salidas */
FOR EACH Almmmatg NO-LOCK WHERE
    Almmmatg.codcia = s-codcia,
    EACH Almdmov NO-LOCK USE-INDEX ALMD02 WHERE
    Almdmov.CodCia = Almmmatg.codcia AND
    Almdmov.codmat = Almmmatg.CodMat AND
    Almdmov.FchDoc >= FILL-IN-fecha AND
    Almdmov.TipMov = "S" AND
    Almdmov.codmov = 50:

    FIND Almcmov WHERE
        Almcmov.CodCia = Almdmov.codcia AND
        Almcmov.CodAlm = Almdmov.codalm AND
        Almcmov.TipMov = Almdmov.tipmov AND
        Almcmov.CodMov = Almdmov.codmov AND
        Almcmov.NroDoc = Almdmov.nrodoc NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almcmov THEN NEXT.

    /* Busca OT */
    FIND pr-odpc WHERE
        pr-odpc.codcia = Almcmov.codcia AND
        PR-ODPC.NumOrd = SUBSTRING(Almcmov.nrorf1,3) NO-LOCK NO-ERROR.

    dqtysal = Almdmov.CanDes * Almdmov.Factor.
    cNroOP = Almcmov.nrorf1.

    DISPLAY
        cNroOP @ FI-MENSAJE LABEL "    OP"
        WITH FRAME F-PROCESO.

    CREATE wrkpd_prod.
    ASSIGN
        wrkpd_ordpro = Almcmov.nrorf1
        wrkpd_fchsal = Almdmov.FchDoc
        wrkpd_nrosal = Almdmov.NroDoc
        wrkpd_itesal = Almdmov.codmat
        wrkpd_dessal = Almmmatg.desmat
        wrkpd_umsal  = Almdmov.CodUnd
        wrkpd_qtysal = dqtysal.
END.
    

HIDE FRAME F-PROCESO.

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

