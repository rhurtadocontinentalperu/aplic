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
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR s-CodAlm AS CHARACTER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEFINE VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
        SKIP
    Fi-Mensaje NO-LABEL FONT 6
    SKIP     
    WITH OVERLAY CENTERED KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

DEFINE VAR cMoneda  AS CHARACTER FORMAT "X(20)" NO-UNDO.

DEFINE TEMP-TABLE wrk_temp NO-UNDO
    FIELDS CodAlm LIKE Almacen.CodAlm
    FIELDS CodFam LIKE Almmmatg.CodFam
    FIELDS DesFam AS CHARACTER FORMAT "x(40)" LABEL "Descripción"
    FIELDS CodMat LIKE Almmmatg.CodMat
    FIELDS DesMat LIKE Almmmatg.DesMat
    FIELDS CostoRep AS DECIMAL EXTENT 12 FORMAT ">>>>>>>9.99"
    INDEX CodAlm IS PRIMARY CodAlm CodFam.

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
&Scoped-Define ENABLED-OBJECTS Btn_Cancel Btn_Excel Btn_OK TOGGLE-form ~
FILL-IN-periodo COMBO-Linea RADIO-Tipo RADIO-CodMon COMBO-Almacen ~
COMBO-mesini COMBO-mesfin RECT-61 RECT-62 
&Scoped-Define DISPLAYED-OBJECTS TOGGLE-form FILL-IN-periodo COMBO-Linea ~
RADIO-Tipo RADIO-CodMon COMBO-Almacen COMBO-mesini COMBO-mesfin 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img\b-cancel":U NO-FOCUS FLAT-BUTTON
     LABEL "Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_Excel 
     IMAGE-UP FILE "img\excel":U NO-FOCUS FLAT-BUTTON
     LABEL "Excel" 
     SIZE 11 BY 1.5 TOOLTIP "Salida a Excel".

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U NO-FOCUS FLAT-BUTTON
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-Almacen AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Almacén" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-Linea AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Línea" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-mesfin AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Mes Fin" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEM-PAIRS "Enero",1,
                     "Febrero",2,
                     "Marzo",3,
                     "Abril",4,
                     "Mayo",5,
                     "Junio",6,
                     "Julio",7,
                     "Agosto",8,
                     "Setiembre",9,
                     "Octubre",10,
                     "Noviembre",11,
                     "Diciembre",12
     DROP-DOWN-LIST
     SIZE 13 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-mesini AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Mes Inicio" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEM-PAIRS "Enero",1,
                     "Febrero",2,
                     "Marzo",3,
                     "Abril",4,
                     "Mayo",5,
                     "Junio",6,
                     "Julio",7,
                     "Agosto",8,
                     "Setiembre",9,
                     "Octubre",10,
                     "Noviembre",11,
                     "Diciembre",12
     DROP-DOWN-LIST
     SIZE 13 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Año" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-CodMon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 13.72 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-Tipo AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Ambos", "",
"Activados", "A",
"Desactivados", "D"
     SIZE 32.57 BY .96 NO-UNDO.

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 13.72 BY 7.

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 55 BY 7.

DEFINE VARIABLE TOGGLE-form AS LOGICAL INITIAL yes 
     LABEL "¿Detallado?" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Btn_Cancel AT ROW 6.65 COL 58
     Btn_Excel AT ROW 3.69 COL 58 WIDGET-ID 2
     Btn_OK AT ROW 2.08 COL 58
     TOGGLE-form AT ROW 6.12 COL 37 WIDGET-ID 32
     FILL-IN-periodo AT ROW 2.08 COL 13 COLON-ALIGNED WIDGET-ID 20
     COMBO-Linea AT ROW 5.04 COL 13 COLON-ALIGNED
     RADIO-Tipo AT ROW 7.19 COL 15 NO-LABEL
     RADIO-CodMon AT ROW 6.12 COL 15 NO-LABEL WIDGET-ID 12
     COMBO-Almacen AT ROW 3.96 COL 13 COLON-ALIGNED WIDGET-ID 18
     COMBO-mesini AT ROW 2.88 COL 13 COLON-ALIGNED WIDGET-ID 30
     COMBO-mesfin AT ROW 2.88 COL 35 COLON-ALIGNED WIDGET-ID 28
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1.27 COL 3
          FONT 6
     "Estado:" VIEW-AS TEXT
          SIZE 5.57 BY .5 AT ROW 7.38 COL 9
     "Moneda:" VIEW-AS TEXT
          SIZE 6.14 BY .5 AT ROW 6.27 COL 8.14 WIDGET-ID 16
     RECT-61 AT ROW 1.54 COL 57
     RECT-62 AT ROW 1.54 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 70.86 BY 7.88
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
         TITLE              = "Existencias por Almacén con Costo de Reposición"
         HEIGHT             = 7.88
         WIDTH              = 70.86
         MAX-HEIGHT         = 9.31
         MAX-WIDTH          = 70.86
         VIRTUAL-HEIGHT     = 9.31
         VIRTUAL-WIDTH      = 70.86
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT W-Win:LOAD-ICON("img\climnu3":U) THEN
    MESSAGE "Unable to load icon: img\climnu3"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Existencias por Almacén con Costo de Reposición */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Existencias por Almacén con Costo de Reposición */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Excel W-Win
ON CHOOSE OF Btn_Excel IN FRAME F-Main /* Excel */
DO:

    RUN Asigna-Variables.
    RUN Inhabilita.
    RUN Excel.
    RUN Habilita.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
 
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables W-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            TOGGLE-form
            COMBO-mesfin
            COMBO-mesini
            FILL-IN-periodo
            RADIO-CodMon
            RADIO-Tipo
            COMBO-Linea
            COMBO-Almacen.
        IF RADIO-CodMon = 1 THEN cMoneda = "NUEVOS SOLES".
        ELSE cMoneda = "DOLARES AMERICANOS".
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Tempo W-Win 
PROCEDURE Carga-Tempo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE dSaldo AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dCosto AS DECIMAL NO-UNDO.
    DEFINE VARIABLE fCorte AS DATE NO-UNDO.
    DEFINE VARIABLE iCont AS INTEGER NO-UNDO.

    FOR EACH wrk_temp:
        DELETE wrk_temp.
    END.

    FOR EACH Almmmate NO-LOCK WHERE
        Almmmate.CodCia = s-CodCia AND
        (COMBO-Almacen = 'Todos' OR Almmmate.codalm = COMBO-Almacen) AND
        Almmmate.CodMat >= "",
        FIRST Almmmatg OF Almmmate NO-LOCK WHERE
        (COMBO-Linea = 'Todas' OR Almmmatg.codfam = COMBO-Linea) AND
        Almmmatg.TpoArt BEGINS RADIO-Tipo:

        IF Almmmatg.FchCes <> ? THEN NEXT.

        DISPLAY
            Almmmatg.CodMat @ Fi-Mensaje LABEL "    Código"
            FORMAT "X(8)" WITH FRAME F-Proceso.

        DO iCont = COMBO-mesini TO COMBO-mesfin:

            IF iCont = 12 THEN fCorte = DATE(12,31,FILL-IN-periodo).
            ELSE fCorte = DATE(iCont + 1,1,FILL-IN-periodo) - 1.

            FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= fCorte NO-LOCK NO-ERROR.

            dSaldo = 0.
            FIND LAST Almdmov WHERE
                Almdmov.CodCia = s-CodCia AND
                Almdmov.CodAlm = Almmmate.CodAlm AND
                Almdmov.CodMat = Almmmate.CodMat AND
                Almdmov.FchDoc <= fCorte
                USE-INDEX Almd03 NO-LOCK NO-ERROR.
            IF AVAILABLE Almdmov THEN dSaldo = Almdmov.StkSub.
            IF dSaldo <= 0 THEN NEXT.
            FIND FIRST wrk_temp WHERE
                wrk_temp.CodAlm = Almmmate.codalm AND
                wrk_temp.CodFam = Almmmatg.CodFam AND
                wrk_temp.CodMat = Almmmatg.CodMat NO-ERROR.
            IF NOT AVAILABLE wrk_temp THEN DO:
                CREATE wrk_temp.
                ASSIGN
                    wrk_temp.CodAlm = Almmmate.codalm
                    wrk_temp.CodFam = Almmmatg.CodFam
                    wrk_temp.CodMat = Almmmatg.CodMat
                    wrk_temp.DesMat = Almmmatg.DesMat.
                FIND AlmTFami WHERE
                    AlmTFami.CodCia = Almmmate.codcia AND
                    AlmTFami.CodFam = Almmmatg.CodFam
                    NO-LOCK NO-ERROR.
                IF AVAILABLE AlmTFami THEN
                    wrk_temp.DesFam = AlmTFami.DesFam.
            END.
            dCosto = Almmmatg.Ctolis.
            IF RADIO-CodMon <> Almmmatg.MonVta THEN DO:
                IF RADIO-CodMon = 1 THEN dCosto = dCosto * gn-tcmb.venta.
                IF RADIO-CodMon = 2 THEN dCosto = dCosto / gn-tcmb.venta.
            END.
            wrk_temp.CostoRep[iCont] = wrk_temp.CostoRep[iCont] + (dSaldo * dCosto).

        END. /* DO iCont... */

    END. /* FOR EACH Almmmatg... */
    HIDE FRAME F-PROCESO.

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
  DISPLAY TOGGLE-form FILL-IN-periodo COMBO-Linea RADIO-Tipo RADIO-CodMon 
          COMBO-Almacen COMBO-mesini COMBO-mesfin 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE Btn_Cancel Btn_Excel Btn_OK TOGGLE-form FILL-IN-periodo COMBO-Linea 
         RADIO-Tipo RADIO-CodMon COMBO-Almacen COMBO-mesini COMBO-mesfin 
         RECT-61 RECT-62 
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
    DEFINE VARIABLE chChart            AS COM-HANDLE.
    DEFINE VARIABLE chWorksheetRange   AS COM-HANDLE.
    DEFINE VARIABLE iCount             AS INTEGER INIT 1.
    DEFINE VARIABLE iIndex             AS INTEGER.
    DEFINE VARIABLE cColumn            AS CHARACTER.
    DEFINE VARIABLE cRange             AS CHARACTER.
    DEFINE VARIABLE t-Column           AS INTEGER INIT 2.

    DEFINE VARIABLE dTotCst AS DECIMAL EXTENT 12 NO-UNDO.
    DEFINE VARIABLE cTitulo AS CHARACTER FORMAT "x(60)" NO-UNDO.
    DEFINE VARIABLE cMes1 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cMes2 AS CHARACTER NO-UNDO.

    RUN bin/_mes.p (INPUT COMBO-mesini, 1, OUTPUT cMes1).
    IF COMBO-mesini <> COMBO-mesfin THEN
        RUN bin/_mes.p (INPUT COMBO-mesfin, 1, OUTPUT cMes2).

    IF cMes2 = "" THEN
        cTitulo = "MES DE " + cMes1 + " DE " + STRING(FILL-IN-Periodo,"9999").
    ELSE
        cTitulo = "DEL MES DE " + cMes1 + " AL MES " + cMes2 + " DE " + STRING(FILL-IN-Periodo,"9999").
    cTitulo = "COSTO DE REPOSICION X FAMILIA " + cTitulo.

    RUN Carga-Tempo.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:ADD().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    chWorkSheet:Range("A1:P2"):FONT:Bold = TRUE.
    chWorkSheet:Range("A1"):VALUE = cTitulo.
    chWorkSheet:Range("A2"):VALUE = "Almacén".
    chWorkSheet:Range("B2"):VALUE = "Familia".
    chWorkSheet:Range("C2"):VALUE = "Descripción".
    chWorkSheet:Range("D2"):VALUE = "Enero".
    chWorkSheet:Range("E2"):VALUE = "Febrero".
    chWorkSheet:Range("F2"):VALUE = "Marzo".
    chWorkSheet:Range("G2"):VALUE = "Abril".
    chWorkSheet:Range("H2"):VALUE = "Mayo".
    chWorkSheet:Range("I2"):VALUE = "Junio".
    chWorkSheet:Range("J2"):VALUE = "Julio".
    chWorkSheet:Range("K2"):VALUE = "Agosto".
    chWorkSheet:Range("L2"):VALUE = "Setiembre".
    chWorkSheet:Range("M2"):VALUE = "Octubre".
    chWorkSheet:Range("N2"):VALUE = "Noviembre".
    chWorkSheet:Range("O2"):VALUE = "Diciembre".
    chWorkSheet:Range("P2"):VALUE = "Total".

    chWorkSheet:COLUMNS("A"):NumberFormat = "@".
    chWorkSheet:COLUMNS("B"):NumberFormat = "@".
    chWorkSheet:COLUMNS("C"):ColumnWidth = 40.

    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    loop:
    FOR EACH wrk_temp NO-LOCK
        BREAK BY wrk_temp.CodAlm
        BY wrk_temp.CodFam:

        ACCUMULATE wrk_temp.costo[1] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[2] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[3] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[4] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[5] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[6] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[7] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[8] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[9] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[10] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[11] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[12] (SUB-TOTAL BY wrk_temp.CodFam).

        IF LAST-OF(wrk_temp.CodFam) THEN DO:
            dTotCst[1] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[1].
            dTotCst[2] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[2].
            dTotCst[3] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[3].
            dTotCst[4] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[4].
            dTotCst[5] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[5].
            dTotCst[6] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[6].
            dTotCst[7] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[7].
            dTotCst[8] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[8].
            dTotCst[9] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[9].
            dTotCst[10] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[10].
            dTotCst[11] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[11].
            dTotCst[12] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[12].

            t-column = t-column + 1.
            cColumn = STRING(t-Column).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):VALUE = wrk_temp.CodAlm.
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):VALUE = wrk_temp.CodFam.
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):VALUE = wrk_temp.DesFam.
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):VALUE = dTotCst[1].
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):VALUE = dTotCst[2].
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):VALUE = dTotCst[3].
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):VALUE = dTotCst[4].
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):VALUE = dTotCst[5].
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):VALUE = dTotCst[6].
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):VALUE = dTotCst[7].
            cRange = "K" + cColumn.
            chWorkSheet:Range(cRange):VALUE = dTotCst[8].
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):VALUE = dTotCst[9].
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):VALUE = dTotCst[10].
            cRange = "N" + cColumn.
            chWorkSheet:Range(cRange):VALUE = dTotCst[11].
            cRange = "O" + cColumn.
            chWorkSheet:Range(cRange):VALUE = dTotCst[12].
            cRange = "P" + cColumn.
            chWorkSheet:Range(cRange):VALUE =
                dTotCst[1] + dTotCst[2] + dTotCst[3] + dTotCst[4] + dTotCst[5] + dTotCst[6] +
                dTotCst[7] + dTotCst[8] + dTotCst[9] + dTotCst[10] + dTotCst[11] + dTotCst[12].
            DISPLAY
                wrk_temp.CodFam @ Fi-Mensaje LABEL "    Código"
                FORMAT "X(8)" WITH FRAME F-Proceso.
            READKEY PAUSE 0.
            IF LASTKEY = KEYCODE("F10") THEN LEAVE loop.
        END.
    END.

    HIDE FRAME F-Proceso NO-PAUSE.

    /* launch Excel so it is visible to the user */
    chExcelApplication:VISIBLE = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

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

    DEFINE VARIABLE cTitulo AS CHARACTER FORMAT "x(60)" NO-UNDO.
    DEFINE VARIABLE cMes1 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cMes2 AS CHARACTER NO-UNDO.

    RUN bin/_mes.p (INPUT COMBO-mesini, 1, OUTPUT cMes1).
    IF COMBO-mesini <> COMBO-mesfin THEN
        RUN bin/_mes.p (INPUT COMBO-mesfin, 1, OUTPUT cMes2).

    IF cMes2 = "" THEN
        cTitulo = "MES DE " + cMes1 + " DE " + STRING(FILL-IN-Periodo,"9999").
    ELSE
        cTitulo = "DEL MES DE " + cMes1 + " AL MES " + cMes2 + " DE " + STRING(FILL-IN-Periodo,"9999").

    DEFINE FRAME F-CAB
        HEADER
        s-NomCia  FORMAT "X(50)"
        "COSTO DE REPOSICION X FAMILIA" AT 80 cTitulo
        "Pagina :" TO 190 PAGE-NUMBER(REPORT) TO 200 FORMAT ">>>9"
        "Fecha :" TO 190 TODAY TO 200 FORMAT "99/99/99" SKIP
        "Moneda : " cMoneda
        "Hora :" TO 190 STRING(TIME,"HH:MM:SS") TO 200 SKIP
        WITH WIDTH 260 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

    RUN Carga-Tempo.
    VIEW STREAM REPORT FRAME F-CAB.

    FOR EACH wrk_temp NO-LOCK
        BREAK BY wrk_temp.CodAlm
        BY wrk_temp.CodFam
        WITH WIDTH 320 NO-BOX:
        DISPLAY STREAM REPORT
            wrk_temp.CodAlm COLUMN-LABEL "Almacén"
            wrk_temp.CodFam COLUMN-LABEL "Cod!Fam"
            wrk_temp.CodMat COLUMN-LABEL "Artículo"
            wrk_temp.DesMat
            wrk_temp.costo[1] COLUMN-LABEL "Costo!Enero"
            wrk_temp.costo[2] COLUMN-LABEL "Costo!Febrero"
            wrk_temp.costo[3] COLUMN-LABEL "Costo!Marzo"
            wrk_temp.costo[4] COLUMN-LABEL "Costo!Abril"
            wrk_temp.costo[5] COLUMN-LABEL "Costo!Mayo"
            wrk_temp.costo[6] COLUMN-LABEL "Costo!junio"
            wrk_temp.costo[7] COLUMN-LABEL "Costo!Julio"
            wrk_temp.costo[8] COLUMN-LABEL "Costo!Agosto"
            wrk_temp.costo[9] COLUMN-LABEL "Costo!Setiembre"
            wrk_temp.costo[10] COLUMN-LABEL "Costo!Octubre"
            wrk_temp.costo[11] COLUMN-LABEL "Costo!Noviembre"
            wrk_temp.costo[12] COLUMN-LABEL "Costo!Diciembre"
            WITH STREAM-IO.

        ACCUMULATE wrk_temp.costo[1] (SUB-TOTAL BY wrk_temp.CodAlm).
        ACCUMULATE wrk_temp.costo[2] (SUB-TOTAL BY wrk_temp.CodAlm).
        ACCUMULATE wrk_temp.costo[3] (SUB-TOTAL BY wrk_temp.CodAlm).
        ACCUMULATE wrk_temp.costo[4] (SUB-TOTAL BY wrk_temp.CodAlm).
        ACCUMULATE wrk_temp.costo[5] (SUB-TOTAL BY wrk_temp.CodAlm).
        ACCUMULATE wrk_temp.costo[6] (SUB-TOTAL BY wrk_temp.CodAlm).
        ACCUMULATE wrk_temp.costo[7] (SUB-TOTAL BY wrk_temp.CodAlm).
        ACCUMULATE wrk_temp.costo[8] (SUB-TOTAL BY wrk_temp.CodAlm).
        ACCUMULATE wrk_temp.costo[9] (SUB-TOTAL BY wrk_temp.CodAlm).
        ACCUMULATE wrk_temp.costo[10] (SUB-TOTAL BY wrk_temp.CodAlm).
        ACCUMULATE wrk_temp.costo[11] (SUB-TOTAL BY wrk_temp.CodAlm).
        ACCUMULATE wrk_temp.costo[12] (SUB-TOTAL BY wrk_temp.CodAlm).

        ACCUMULATE wrk_temp.costo[1] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[2] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[3] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[4] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[5] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[6] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[7] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[8] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[9] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[10] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[11] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[12] (SUB-TOTAL BY wrk_temp.CodFam).

        IF LAST-OF(wrk_temp.CodFam) THEN DO:
            UNDERLINE STREAM REPORT
                wrk_temp.costo[1]
                wrk_temp.costo[2]
                wrk_temp.costo[3]
                wrk_temp.costo[4]
                wrk_temp.costo[5]
                wrk_temp.costo[6]
                wrk_temp.costo[7]
                wrk_temp.costo[8]
                wrk_temp.costo[9]
                wrk_temp.costo[10]
                wrk_temp.costo[11]
                wrk_temp.costo[12]
                WITH STREAM-IO.
            DISPLAY STREAM REPORT
                "SUB-TOTAL FAMILIA " + wrk_temp.CodFam @ wrk_temp.DesMat
                ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[1] @ wrk_temp.costo[1]
                ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[2] @ wrk_temp.costo[2]
                ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[3] @ wrk_temp.costo[3]
                ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[4] @ wrk_temp.costo[4]
                ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[5] @ wrk_temp.costo[5]
                ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[6] @ wrk_temp.costo[6]
                ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[7] @ wrk_temp.costo[7]
                ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[8] @ wrk_temp.costo[8]
                ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[9] @ wrk_temp.costo[9]
                ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[10] @ wrk_temp.costo[10]
                ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[11] @ wrk_temp.costo[11]
                ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[12] @ wrk_temp.costo[12]
                WITH STREAM-IO.
        END.

        IF LAST-OF(wrk_temp.CodAlm) THEN DO:
            UNDERLINE STREAM REPORT
                wrk_temp.costo[1]
                wrk_temp.costo[2]
                wrk_temp.costo[3]
                wrk_temp.costo[4]
                wrk_temp.costo[5]
                wrk_temp.costo[6]
                wrk_temp.costo[7]
                wrk_temp.costo[8]
                wrk_temp.costo[9]
                wrk_temp.costo[10]
                wrk_temp.costo[11]
                wrk_temp.costo[12]
                WITH STREAM-IO.
            DISPLAY STREAM REPORT
                "TOTAL ALMACEN " + wrk_temp.CodAlm @ wrk_temp.DesMat
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[1] @ wrk_temp.costo[1]
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[2] @ wrk_temp.costo[2]
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[3] @ wrk_temp.costo[3]
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[4] @ wrk_temp.costo[4]
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[5] @ wrk_temp.costo[5]
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[6] @ wrk_temp.costo[6]
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[7] @ wrk_temp.costo[7]
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[8] @ wrk_temp.costo[8]
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[9] @ wrk_temp.costo[9]
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[10] @ wrk_temp.costo[10]
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[11] @ wrk_temp.costo[11]
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[12] @ wrk_temp.costo[12]
                WITH STREAM-IO.
        END.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato2 W-Win 
PROCEDURE Formato2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE dTotCst AS DECIMAL EXTENT 12 FORMAT ">>>>>>>9.99" NO-UNDO.
    DEFINE VARIABLE cTitulo AS CHARACTER FORMAT "x(60)" NO-UNDO.
    DEFINE VARIABLE cMes1 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cMes2 AS CHARACTER NO-UNDO.

    RUN bin/_mes.p (INPUT COMBO-mesini, 1, OUTPUT cMes1).
    IF COMBO-mesini <> COMBO-mesfin THEN
        RUN bin/_mes.p (INPUT COMBO-mesfin, 1, OUTPUT cMes2).

    IF cMes2 = "" THEN
        cTitulo = "MES DE " + cMes1 + " DE " + STRING(FILL-IN-Periodo,"9999").
    ELSE
        cTitulo = "DEL MES DE " + cMes1 + " AL MES " + cMes2 + " DE " + STRING(FILL-IN-Periodo,"9999").

    DEFINE FRAME F-CAB
        HEADER
        s-NomCia  FORMAT "X(50)"
        "COSTO DE REPOSICION X FAMILIA" AT 80 cTitulo
        "Pagina :" TO 190 PAGE-NUMBER(REPORT) TO 200 FORMAT ">>>9"
        "Fecha :" TO 190 TODAY TO 200 FORMAT "99/99/99" SKIP
        "Moneda : " cMoneda
        "Hora :" TO 190 STRING(TIME,"HH:MM:SS") TO 200 SKIP
        WITH WIDTH 260 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

    RUN Carga-Tempo.
    VIEW STREAM REPORT FRAME F-CAB.

    FOR EACH wrk_temp NO-LOCK
        BREAK BY wrk_temp.CodAlm
        BY wrk_temp.CodFam
        WITH WIDTH 320 NO-BOX:

        ACCUMULATE wrk_temp.costo[1] (SUB-TOTAL BY wrk_temp.CodAlm).
        ACCUMULATE wrk_temp.costo[2] (SUB-TOTAL BY wrk_temp.CodAlm).
        ACCUMULATE wrk_temp.costo[3] (SUB-TOTAL BY wrk_temp.CodAlm).
        ACCUMULATE wrk_temp.costo[4] (SUB-TOTAL BY wrk_temp.CodAlm).
        ACCUMULATE wrk_temp.costo[5] (SUB-TOTAL BY wrk_temp.CodAlm).
        ACCUMULATE wrk_temp.costo[6] (SUB-TOTAL BY wrk_temp.CodAlm).
        ACCUMULATE wrk_temp.costo[7] (SUB-TOTAL BY wrk_temp.CodAlm).
        ACCUMULATE wrk_temp.costo[8] (SUB-TOTAL BY wrk_temp.CodAlm).
        ACCUMULATE wrk_temp.costo[9] (SUB-TOTAL BY wrk_temp.CodAlm).
        ACCUMULATE wrk_temp.costo[10] (SUB-TOTAL BY wrk_temp.CodAlm).
        ACCUMULATE wrk_temp.costo[11] (SUB-TOTAL BY wrk_temp.CodAlm).
        ACCUMULATE wrk_temp.costo[12] (SUB-TOTAL BY wrk_temp.CodAlm).

        ACCUMULATE wrk_temp.costo[1] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[2] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[3] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[4] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[5] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[6] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[7] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[8] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[9] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[10] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[11] (SUB-TOTAL BY wrk_temp.CodFam).
        ACCUMULATE wrk_temp.costo[12] (SUB-TOTAL BY wrk_temp.CodFam).

        IF LAST-OF(wrk_temp.CodFam) THEN DO:
            dTotCst[1] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[1].
            dTotCst[2] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[2].
            dTotCst[3] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[3].
            dTotCst[4] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[4].
            dTotCst[5] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[5].
            dTotCst[6] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[6].
            dTotCst[7] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[7].
            dTotCst[8] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[8].
            dTotCst[9] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[9].
            dTotCst[10] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[10].
            dTotCst[11] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[11].
            dTotCst[12] = ACCUM SUB-TOTAL BY wrk_temp.CodFam wrk_temp.costo[12].
            DISPLAY STREAM REPORT
                wrk_temp.CodAlm COLUMN-LABEL "Almacén"
                wrk_temp.CodFam COLUMN-LABEL "Cod!Fam"
                wrk_temp.DesFam
                dTotCst[1] COLUMN-LABEL "Costo!Enero"
                dTotCst[2] COLUMN-LABEL "Costo!Febrero"
                dTotCst[3] COLUMN-LABEL "Costo!Marzo"
                dTotCst[4] COLUMN-LABEL "Costo!Abril"
                dTotCst[5] COLUMN-LABEL "Costo!Mayo"
                dTotCst[6] COLUMN-LABEL "Costo!junio"
                dTotCst[7] COLUMN-LABEL "Costo!Julio"
                dTotCst[8] COLUMN-LABEL "Costo!Agosto"
                dTotCst[9] COLUMN-LABEL "Costo!Setiembre"
                dTotCst[10] COLUMN-LABEL "Costo!Octubre"
                dTotCst[11] COLUMN-LABEL "Costo!Noviembre"
                dTotCst[12] COLUMN-LABEL "Costo!Diciembre"
                WITH STREAM-IO.
        END.

        IF LAST-OF(wrk_temp.CodAlm) THEN DO:
            UNDERLINE STREAM REPORT
                dTotCst[1]
                dTotCst[2]
                dTotCst[3]
                dTotCst[4]
                dTotCst[5]
                dTotCst[6]
                dTotCst[7]
                dTotCst[8]
                dTotCst[9]
                dTotCst[10]
                dTotCst[11]
                dTotCst[12]
                WITH STREAM-IO.
            DISPLAY STREAM REPORT
                "TOTAL ALMACEN " + wrk_temp.CodAlm @ wrk_temp.DesFam
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[1] @ dTotCst[1]
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[2] @ dTotCst[2]
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[3] @ dTotCst[3]
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[4] @ dTotCst[4]
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[5] @ dTotCst[5]
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[6] @ dTotCst[6]
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[7] @ dTotCst[7]
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[8] @ dTotCst[8]
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[9] @ dTotCst[9]
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[10] @ dTotCst[10]
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[11] @ dTotCst[11]
                ACCUM SUB-TOTAL BY wrk_temp.CodAlm wrk_temp.costo[12] @ dTotCst[12]
                WITH STREAM-IO.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Habilita W-Win 
PROCEDURE Habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    ENABLE ALL.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime W-Win 
PROCEDURE Imprime :
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
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        IF TOGGLE-form THEN RUN Formato.
        ELSE RUN Formato2.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inhabilita W-Win 
PROCEDURE Inhabilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    DISABLE ALL.
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

    DO WITH FRAME {&FRAME-NAME}:
        COMBO-mesini = MONTH(TODAY).
        COMBO-mesfin = MONTH(TODAY).
        FILL-IN-periodo = YEAR(TODAY).
        RADIO-Tipo = ''.
        DISPLAY /* D-Corte  */ RADIO-Tipo.
        FOR EACH Almtfami NO-LOCK WHERE Almtfami.CodCia = s-codcia:
            COMBO-Linea:ADD-LAST(Almtfami.codfam).
        END.
        FOR EACH Almacen NO-LOCK WHERE 
            Almacen.CodCia = s-codcia AND
            (Almacen.CodAlm = "03" OR 
            Almacen.CodAlm = "04" OR
            Almacen.CodAlm = "05" OR
            Almacen.CodAlm = "11" OR
            Almacen.CodAlm = "15" OR
            Almacen.CodAlm = "17" OR
            Almacen.CodAlm = "35A" OR
            Almacen.CodAlm = "40"):
            COMBO-Almacen:ADD-LAST(Almacen.codalm).
        END.
    END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

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
        WHEN "F-Catconta" THEN ASSIGN input-var-1 = "CC".
        WHEN "F-marca1" OR WHEN "F-marca2" THEN ASSIGN input-var-1 = "MK".
        WHEN "" THEN ASSIGN input-var-1 = "".
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

