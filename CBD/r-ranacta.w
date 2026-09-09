&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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

DEFINE SHARED VARIABLE s-codcia AS INTEGER.
DEFINE SHARED VARIABLE cb-codcia AS INTEGER.
DEFINE SHARED VARIABLE s-nomcia AS CHARACTER.
DEFINE SHARED VARIABLE s-periodo AS INTEGER.
DEFINE SHARED VARIABLE s-nromes AS INTEGER.

DEFINE VARIABLE cCodCta AS CHARACTER INITIAL "NULL" NO-UNDO.
DEFINE VARIABLE cListCta AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPeriodo AS CHARACTER NO-UNDO.
DEFINE VARIABLE iNroMes AS INTEGER NO-UNDO.
DEFINE VARIABLE ind AS INTEGER NO-UNDO.
DEFINE VARIABLE FI-MENSAJE AS CHAR FORMAT "X(40)" NO-UNDO.
DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.

DEFINE TEMP-TABLE wrk_pdt
    FIELDS wrk_tabla AS CHARACTER
    FIELDS wrk_TpoDocId LIKE PL-PERS.TpoDocId
    FIELDS wrk_NroDocId LIKE PL-PERS.NroDocId
    FIELDS wrk_char AS CHARACTER EXTENT 10 
    FIELDS wrk_int AS INTEGER EXTENT 10
    FIELDS wrk_dec AS DECIMAL EXTENT 10
    FIELDS wrk_date AS DATE EXTENT 10
    INDEX IDX01 IS PRIMARY wrk_tabla wrk_TpoDocId wrk_NroDocId.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6 SKIP
    Fi-Mensaje NO-LABEL FONT 6 SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
        BGCOLOR 15 FGCOLOR 0 
        TITLE "Procesando ..." FONT 7.

RUN cbd/cb-m000 (OUTPUT cPeriodo).
IF cPeriodo = '' THEN DO:
    MESSAGE
        'NO existen periodos configurados para esta compañia'
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-Cta

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-ctas

/* Definitions for BROWSE BROWSE-Cta                                    */
&Scoped-define FIELDS-IN-QUERY-BROWSE-Cta cb-ctas.Codcta cb-ctas.Nomcta 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-Cta 
&Scoped-define QUERY-STRING-BROWSE-Cta FOR EACH cb-ctas ~
      WHERE cb-ctas.CodCia = cb-codcia AND ~
cb-ctas.CodCta BEGINS cCodCta AND ~
LENGTH(cb-ctas.CodCta) >= 6 NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-Cta OPEN QUERY BROWSE-Cta FOR EACH cb-ctas ~
      WHERE cb-ctas.CodCia = cb-codcia AND ~
cb-ctas.CodCta BEGINS cCodCta AND ~
LENGTH(cb-ctas.CodCta) >= 6 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-Cta cb-ctas
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-Cta cb-ctas


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-Cta}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 COMBO-Periodo COMBO-mes ~
FILL-IN-CodCta RADIO-CodMon BROWSE-Cta Btn_Excel Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS COMBO-Periodo COMBO-mes FILL-IN-CodCta ~
RADIO-CodMon 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_Excel 
     IMAGE-UP FILE "img\excel":U
     LABEL "Excel" 
     SIZE 11 BY 1.5 TOOLTIP "Genera archivo texto"
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-mes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "Apertura","Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cuenta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-CodMon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 13.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 12.88.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15 BY 12.88.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-Cta FOR 
      cb-ctas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-Cta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-Cta W-Win _STRUCTURED
  QUERY BROWSE-Cta NO-LOCK DISPLAY
      cb-ctas.Codcta FORMAT "x(10)":U
      cb-ctas.Nomcta COLUMN-LABEL "Descripción" FORMAT "x(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 39.57 BY 9.88
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-Periodo AT ROW 1.38 COL 7 COLON-ALIGNED
     COMBO-mes AT ROW 1.38 COL 24.43 COLON-ALIGNED
     FILL-IN-CodCta AT ROW 2.35 COL 7 COLON-ALIGNED
     RADIO-CodMon AT ROW 2.35 COL 26.72 NO-LABEL
     BROWSE-Cta AT ROW 3.5 COL 4
     Btn_Excel AT ROW 8.69 COL 48
     Btn_OK AT ROW 10.23 COL 48
     Btn_Cancel AT ROW 11.77 COL 48
     "Moneda:" VIEW-AS TEXT
          SIZE 6.14 BY .5 AT ROW 2.54 COL 20
     RECT-1 AT ROW 1 COL 1
     RECT-2 AT ROW 1 COL 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 60.14 BY 12.92
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
         TITLE              = "Resumen - Analis de Cuentas"
         HEIGHT             = 12.92
         WIDTH              = 60.14
         MAX-HEIGHT         = 12.92
         MAX-WIDTH          = 60.14
         VIRTUAL-HEIGHT     = 12.92
         VIRTUAL-WIDTH      = 60.14
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
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-Cta RADIO-CodMon F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-Cta
/* Query rebuild information for BROWSE BROWSE-Cta
     _TblList          = "INTEGRAL.cb-ctas"
     _Options          = "NO-LOCK"
     _Where[1]         = "cb-ctas.CodCia = cb-codcia AND
cb-ctas.CodCta BEGINS cCodCta AND
LENGTH(cb-ctas.CodCta) >= 6"
     _FldNameList[1]   > INTEGRAL.cb-ctas.Codcta
"cb-ctas.Codcta" ? ? "character" ? ? ? ? ? ? no "Código de la Cuenta Contable" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.cb-ctas.Nomcta
"cb-ctas.Nomcta" "Descripción" ? "character" ? ? ? ? ? ? no "Descripción de la Cuenta" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-Cta */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Resumen - Analis de Cuentas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Resumen - Analis de Cuentas */
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

    DEFINE VARIABLE cFile-Name AS CHARACTER FORMAT "x(40)" LABEL "Archivo".
    DEFINE VARIABLE lOk AS LOGICAL NO-UNDO.

    ASSIGN
        COMBO-Periodo
        COMBO-Mes
        FILL-IN-CodCta
        RADIO-CodMon
        cListCta = "".

    DO WITH FRAME {&FRAME-NAME}:
        IF BROWSE-Cta:NUM-SELECTED-ROWS = 0 THEN DO:
            MESSAGE
                "Seleccione por lo menos una cuenta"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO BROWSE-Cta.
            UNDO, RETRY.
        END.
        DO ind = 1 TO BROWSE-Cta:NUM-SELECTED-ROWS:
            lOk = BROWSE-Cta:FETCH-SELECTED-ROW(ind).
            IF lOk THEN DO:
                IF cListCta = "" THEN cListCta = cb-ctas.CodCta.
                ELSE cListCta = cListCta + "," + cb-ctas.CodCta.
            END.
        END.
        iNroMes = LOOKUP(COMBO-mes,COMBO-mes:LIST-ITEMS) - 1.
    END.

    IF NOT AVAILABLE PF-CIAS THEN
        FIND GN-CIAS WHERE GN-CIAS.CodCia = s-codcia NO-LOCK.

    cFile-Name = "M:\0660" + TRIM(GN-CIAS.LIBRE-C[1]) + "???" + ".txt".

    lOk = FALSE.
    SYSTEM-DIALOG GET-FILE cFile-Name
        TITLE      "Seleccione Archivo..."
        FILTERS    "Texto (*.txt)"   "*.txt",
                   "Todos (*.*)"     "*.*"
        MUST-EXIST
        SAVE-AS
        USE-FILENAME
        UPDATE lOk.
    IF lOk = TRUE THEN DO:
        RUN Genera-Txt(cFile-Name).
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:

    DEFINE VARIABLE lOk AS LOGICAL NO-UNDO.

    ASSIGN
        COMBO-Periodo
        COMBO-Mes
        FILL-IN-CodCta
        RADIO-CodMon
        cListCta = "".

    DO WITH FRAME {&FRAME-NAME}:
        IF BROWSE-Cta:NUM-SELECTED-ROWS = 0 THEN DO:
            MESSAGE
                "Seleccione por lo menos una cuenta"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO BROWSE-Cta.
            UNDO, RETRY.
        END.
        DO ind = 1 TO BROWSE-Cta:NUM-SELECTED-ROWS:
            lOk = BROWSE-Cta:FETCH-SELECTED-ROW(ind).
            IF lOk THEN DO:
                IF cListCta = "" THEN cListCta = cb-ctas.CodCta.
                ELSE cListCta = cListCta + "," + cb-ctas.CodCta.
            END.
        END.
        iNroMes = LOOKUP(COMBO-mes,COMBO-mes:LIST-ITEMS) - 1.
        DISABLE ALL.
    END.

    RUN Imprime.

    DO WITH FRAME {&FRAME-NAME}:
        ENABLE ALL.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCta W-Win
ON LEAVE OF FILL-IN-CodCta IN FRAME F-Main /* Cuenta */
DO:

    cCodCta = FILL-IN-CodCta:SCREEN-VALUE.
    IF cCodCta = "" THEN cCodCta = "NULL".

    {&OPEN-QUERY-{&BROWSE-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-Cta
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Tempo W-Win 
PROCEDURE Carga-Tempo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR F-Saldo AS DEC.
/*
  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = S-CODCIA 
        AND  (x-Linea = 'Todas' OR Almmmatg.codfam = x-Linea)
        AND  Almmmatg.CodMat >= DesdeC  
        AND  Almmmatg.CodMat <= HastaC 
        AND  Almmmatg.CodMar BEGINS F-marca1 
        AND  Almmmatg.CodPr1 BEGINS F-provee1
        AND  Almmmatg.Catconta[1] BEGINS F-Catconta 
        AND  Almmmatg.TpoArt BEGINS R-Tipo: 
      DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(8)" WITH FRAME F-Proceso.
      
      FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= D-CORTE NO-LOCK NO-ERROR.

    /* Saldo Logistico */
    ASSIGN
        F-Saldo = 0.
/*    FOR EACH Almacen WHERE almacen.codcia = s-codcia
 *             AND almacen.flgrep = YES NO-LOCK:
 *         IF Almacen.AlmCsg = YES THEN NEXT.
 *         FIND LAST AlmStkAl WHERE almstkal.codcia = s-codcia
 *             AND almstkal.codalm = almacen.codalm
 *             AND almstkal.codmat = almmmatg.codmat
 *             AND almstkal.fecha <= D-Corte
 *             NO-LOCK NO-ERROR.
 *         IF AVAILABLE Almstkal THEN F-Saldo = F-Saldo + AlmStkal.StkAct.
 *     END.
 *     IF F-Saldo = 0 THEN NEXT.*/
    /* Costo Unitario */
    FIND LAST AlmStkGe WHERE almstkge.codcia = s-codcia
        AND almstkge.codmat = almmmatg.codmat
        AND almstkge.fecha <= D-Corte
        NO-LOCK NO-ERROR.

    IF AVAILABLE Almstkge THEN f-Saldo = AlmStkge.StkAct.
    IF f-Saldo = 0 THEN NEXT.

      
/*      FIND LAST AlmStkge WHERE AlmStkge.Codcia = S-CODCIA AND
 *                         AlmStkge.Codmat = Almmmatg.Codmat AND
 *                         AlmStkge.Fecha <= D-Corte
 *                         NO-LOCK NO-ERROR.
 *       IF NOT AVAILABLE AlmStkge THEN NEXT. 
 *       IF ALmStkge.StkAct = 0 THEN NEXT.*/
      
      FIND Tempo WHERE Tempo.Codcia = S-CODCIA AND
                       Tempo.Codmat = Almmmatg.Codmat
                       EXCLUSIVE-LOCK NO-ERROR.

      IF NOT AVAILABLE Tempo THEN DO:
         X-DESCAT = "".
         FIND Almtabla WHERE Almtabla.Tabla = CATEGORIA
                       AND  Almtabla.codigo = Almmmatg.Catconta[1] 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtabla THEN X-DESCAT = Almtabla.Nombre.
         
         CREATE Tempo.
         ASSIGN 
         Tempo.Codcia = Almmmatg.Codcia 
         Tempo.Codmat = Almmmatg.Codmat
         Tempo.Desmat = Almmmatg.Desmat
         Tempo.DesMar = Almmmatg.DesMar
         Tempo.UndStk = Almmmatg.UndStk
         Tempo.Catego = Almmmatg.Catconta[1]
         Tempo.Descat = X-DESCAT.   
      END.        

/*      Tempo.F-STKGEN = AlmStkge.Stkact.
 *       Tempo.F-PRECTO = AlmStkGe.CtoUni.
 *       
 *       IF I-CodMon = 1 THEN Tempo.F-VALCTO = Tempo.F-STKGEN * Tempo.F-PRECTO.
 *       IF I-CodMon = 2 THEN Tempo.F-VALCTO = Tempo.F-STKGEN * Tempo.F-PRECTO / Gn-Tcmb.Compra. */

    IF AVAILABLE Almstkge THEN Tempo.f-PreCto = Almstkge.CtoUni.
    Tempo.f-StkGen = F-Saldo.
    IF I-CodMon = 1 THEN Tempo.F-VALCTO = Tempo.F-STKGEN * Tempo.F-PRECTO.
    IF I-CodMon = 2 THEN Tempo.F-VALCTO = Tempo.F-STKGEN * Tempo.F-PRECTO / Gn-Tcmb.Compra. 
    
      /***************Costo Ultima Reposicion********MAGM***********/
      F-COSTO = 0.
      IF F-COSTO = 0 THEN DO:
         F-COSTO = Almmmatg.Ctolis.
         IF I-CodMon <> Almmmatg.MonVta THEN DO:
            IF I-CodMon = 1 THEN F-costo = F-costo * gn-tcmb.venta. 
            IF I-CodMon = 2 THEN F-costo = F-costo / gn-tcmb.venta. 
         END.            
      END.
      FT-COSTO = F-COSTO * F-STKGEN.
      
      /***************************************************************/

  END.
  */
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
  DISPLAY COMBO-Periodo COMBO-mes FILL-IN-CodCta RADIO-CodMon 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 COMBO-Periodo COMBO-mes FILL-IN-CodCta RADIO-CodMon 
         BROWSE-Cta Btn_Excel Btn_OK Btn_Cancel 
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

    DEFINE VARIABLE cb-codcia AS INTEGER NO-UNDO INITIAL 0.
    DEFINE VARIABLE pv-codcia AS INTEGER NO-UNDO INITIAL 0.
    DEFINE VARIABLE cl-codcia AS INTEGER NO-UNDO INITIAL 0.
    DEFINE VARIABLE cPinta-mes AS CHARACTER FORMAT "X(30)".
    DEFINE VARIABLE cExpres   AS CHARACTER FORMAT "X(40)".
    DEFINE VARIABLE cNomAux   AS CHARACTER FORMAT "X(50)".
    DEFINE VARIABLE cTipAux   AS CHARACTER.
    DEFINE VARIABLE dDebe     AS DECIMAL FORMAT "->>>,>>>,>>9.99".
    DEFINE VARIABLE dHaber    AS DECIMAL FORMAT "->>>,>>>,>>9.99".
    DEFINE VARIABLE dTotAux   AS DECIMAL FORMAT "->>>,>>>,>>9.99".
    DEFINE VARIABLE dTotGen   AS DECIMAL FORMAT "->>>,>>>,>>9.99".

    DEFINE VARIABLE cLblCta AS CHARACTER FORMAT "X(15)" EXTENT 100.
    DEFINE VARIABLE dSaldoCta AS DECIMAL FORMAT "->>>,>>>,>>9.99" EXTENT 100.
    DEFINE VARIABLE dTotalCta AS DECIMAL FORMAT "->>>,>>>,>>9.99" EXTENT 100.
    DEFINE VARIABLE cUndCta AS CHARACTER FORMAT "X(15)" EXTENT 100.

    FIND Empresas WHERE Empresas.CodCia = s-codcia NO-LOCK.
    IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.
    IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.
    IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

    RUN bin/_mes.p (INPUT iNroMes, 1, OUTPUT cPinta-mes).
    cPinta-mes = "AL MES DE " + cPinta-mes + " DE " + STRING(COMBO-periodo, "9999").

    DO ind = 1 TO NUM-ENTRIES(cListCta):
        cLblCta[ind] = FILL(" ", 15 - LENGTH(ENTRY(ind,cListCta))) +
            ENTRY(ind,cListCta).
        cUndCta[ind] = "---------------".
        IF ind = 100 THEN DO:
            cLblCta[ind] = "          + 100".
            LEAVE.
        END.
    END.

    IF RADIO-codmon = 1 THEN cExpres = "(EXPRESADO EN NUEVOS SOLES)".
    ELSE cExpres = "(EXPRESADO EN DOLARES)".

    DEFINE FRAME f-cab
        HEADER
        s-nomcia FORMAT "x(45)"
        "S A L D O   D E   C U E N T A S" AT 48
        "FECHA : " TO 117 TODAY TO 125
        SKIP
        cPinta-mes  AT 48
        "PAGINA :" TO 117 PAGE-NUMBER(report) FORMAT ">,>>9" TO 125
        cExpres   AT 43
        SKIP(1)
        WITH WIDTH 126 NO-BOX DOWN STREAM-IO NO-UNDERLINE NO-LABEL PAGE-TOP.

    RUN bin/_centrar.p(INPUT cPinta-mes, 30, OUTPUT cPinta-mes).
    RUN bin/_centrar.p(INPUT cExpres, 40, OUTPUT cExpres).

    VIEW STREAM report FRAME F-CAB.

    PUT STREAM report
        "AUXILIAR    "
        "NOMBRE/RAZON SOCIAL" FORMAT "X(50)".
    DO ind = 1 TO NUM-ENTRIES(cListCta):
        PUT STREAM report " " cLblCta[ind].
        IF ind = 100 THEN LEAVE.
    END.
    PUT STREAM report "           TOTAL" SKIP.
    PUT STREAM report
        "----------- "
        FILL("-",50) FORMAT "X(50)".
    DO ind = 1 TO NUM-ENTRIES(cListCta):
        PUT STREAM report " " cUndCta[ind].
        IF ind = 100 THEN LEAVE.
    END.
    PUT STREAM report " ---------------" SKIP.

    FOR EACH cb-dmov NO-LOCK WHERE
        cb-dmov.codcia = s-codcia AND
        cb-dmov.periodo = COMBO-periodo AND
        cb-dmov.nromes <= iNroMes AND
        LOOKUP(cb-dmov.codcta,cListCta) > 0
        BREAK BY cb-dmov.codaux ON ERROR UNDO, LEAVE:

        ind = LOOKUP(cb-dmov.codcta,cListCta).
        IF ind > 100 THEN ind = 100. 

        IF NOT tpomov THEN DO:
            CASE RADIO-codmon:
                WHEN 1 THEN DO:
                    dDebe  = ImpMn1.
                    dHaber = 0.
                END.
                WHEN 2 THEN DO:
                    dDebe  = ImpMn2.
                    dHaber = 0.
                END.
            END CASE.
        END.
        ELSE DO:
            CASE RADIO-codmon:
                WHEN 1 THEN DO:
                    dDebe  = 0.
                    dHaber = ImpMn1.
                END.
                WHEN 2 THEN DO:
                    dDebe  = 0.
                    dHaber = ImpMn2.
                END.
            END CASE.
        END.
        IF NOT (dHaber = 0 AND dDebe = 0) AND
            dHaber <> ? AND dDebe <> ? THEN DO:
            dSaldoCta[ind] = dSaldoCta[ind] + dDebe - dHaber.
            dTotalCta[ind] = dTotalCta[ind] + dDebe - dHaber.
        END.
        IF LAST-OF(cb-dmov.codaux) THEN DO:
            dTotAux = 0.
            DO ind = 1 TO NUM-ENTRIES(cListCta):
                dTotAux = dTotAux + dSaldoCta[ind].
                IF ind = 100 THEN LEAVE.
            END.
            IF dTotAux = 0 THEN NEXT.
            dTotGen = dTotGen + dTotAux.
            cNomAux = "".
            CASE cb-dmov.clfaux:
                WHEN "@CL" THEN DO:
                    cTipAux = "Cliente".
                    FIND gn-clie WHERE
                        gn-clie.codcli = cb-dmov.codaux AND
                        gn-clie.CodCia = cl-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE gn-clie THEN cNomAux = gn-clie.nomcli.
                END.
                WHEN "@PV" THEN DO:
                    cTipAux = "Proveedor".
                    FIND gn-prov WHERE
                        gn-prov.codpro = cb-dmov.codaux AND
                        gn-prov.CodCia = pv-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE gn-prov THEN cNomAux = gn-prov.nompro.
                END.
                WHEN "@CT" THEN DO:
                    cTipAux = "Cuenta".
                    find cb-ctas WHERE
                        cb-ctas.codcta = cb-dmov.codaux AND
                        cb-ctas.CodCia = cb-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-ctas THEN cNomAux = cb-ctas.nomcta.
                END.
                OTHERWISE DO:
                    cTipAux = "Otro".
                    FIND cb-auxi WHERE
                        cb-auxi.clfaux = cb-dmov.clfaux AND
                        cb-auxi.codaux = cb-dmov.codaux AND
                        cb-auxi.CodCia = cb-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-auxi THEN cNomAux = cb-auxi.nomaux.
                END.
            END CASE.

            /* Despliega Detalle de Información */
            PUT STREAM report
                cb-dmov.codaux " "
                cNomAux.
            DO ind = 1 TO NUM-ENTRIES(cListCta):
                PUT STREAM report " " dSaldoCta[ind].
                IF ind = 100 THEN LEAVE.
            END.
            PUT STREAM report " " dTotAux SKIP.

            dSaldoCta = 0.

            DISPLAY
                "   " + cTipAux + ": " + cb-dmov.codaux @ FI-MENSAJE
                WITH FRAME F-PROCESO.

            IF LINE-COUNTER(report) + 2 > PAGE-SIZE(report) THEN DO:
                PAGE STREAM report.
                PUT STREAM report
                    "AUXILIAR    "
                    "NOMBRE/RAZON SOCIAL" FORMAT "X(50)".
                DO ind = 1 TO NUM-ENTRIES(cListCta):
                    PUT STREAM report " " cLblCta[ind].
                    IF ind = 100 THEN LEAVE.
                END.
                PUT STREAM report "           TOTAL" SKIP.
                PUT STREAM report
                    "----------- "
                    FILL("-",50) FORMAT "X(50)".
                DO ind = 1 TO NUM-ENTRIES(cListCta):
                    PUT STREAM report " " cUndCta[ind].
                    IF ind = 100 THEN LEAVE.
                END.
                PUT STREAM report " ---------------" SKIP.
            END.
        END.    /* IF LAST-OF(cb-dmov.codaux)... */
    END.  /* FOR EACH cb-dmov... */

    IF LINE-COUNTER(report) + 2 > PAGE-SIZE(report) THEN DO:
        PAGE STREAM report.
        PUT STREAM report
            "AUXILIAR    "
            "NOMBRE/RAZON SOCIAL" FORMAT "X(50)".
        DO ind = 1 TO NUM-ENTRIES(cListCta):
            PUT STREAM report " " cLblCta[ind].
            IF ind = 100 THEN LEAVE.
        END.
        PUT STREAM report "           TOTAL" SKIP.
        PUT STREAM report
            "----------- "
            FILL("-",50) FORMAT "X(50)".
        DO ind = 1 TO NUM-ENTRIES(cListCta):
            PUT STREAM report " " cUndCta[ind].
            IF ind = 100 THEN LEAVE.
        END.
        PUT STREAM report " ---------------" SKIP.
    END.

    /* Despliega Totales */
    PUT STREAM report
        FILL(" ",12) FORMAT "x(12)"
        FILL(" ",50) FORMAT "x(50)".
    DO ind = 1 TO NUM-ENTRIES(cListCta):
        PUT STREAM report " " cUndCta[ind].
        IF ind = 100 THEN LEAVE.
    END.
    PUT STREAM report
        " ---------------"
        SKIP
        FILL(" ",11) FORMAT "X(11)" " "
        FILL(" ",37) + "TOTAL CUENTAS" FORMAT "X(50)".
    DO ind = 1 TO NUM-ENTRIES(cListCta):
        PUT STREAM report " " dTotalCta[ind].
        IF ind = 100 THEN LEAVE.
    END.
    PUT STREAM report " " dTotGen SKIP.

    HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-TXT W-Win 
PROCEDURE Genera-TXT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_file AS CHARACTER.

    DEFINE VARIABLE cb-codcia AS INTEGER NO-UNDO INITIAL 0.
    DEFINE VARIABLE pv-codcia AS INTEGER NO-UNDO INITIAL 0.
    DEFINE VARIABLE cl-codcia AS INTEGER NO-UNDO INITIAL 0.
    DEFINE VARIABLE cNomAux   AS CHARACTER FORMAT "X(50)".
    DEFINE VARIABLE cRUC      AS CHARACTER.
    DEFINE VARIABLE cTipAux   AS CHARACTER.
    DEFINE VARIABLE dDebe     AS DECIMAL FORMAT "->>>,>>>,>>9.99".
    DEFINE VARIABLE dHaber    AS DECIMAL FORMAT "->>>,>>>,>>9.99".
    DEFINE VARIABLE dSaldoCta AS DECIMAL.

    FIND Empresas WHERE Empresas.CodCia = s-codcia NO-LOCK.
    IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.
    IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.
    IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

    OUTPUT STREAM report TO VALUE(para_file).

    FOR EACH cb-dmov NO-LOCK WHERE
        cb-dmov.codcia = s-codcia AND
        cb-dmov.periodo = COMBO-periodo AND
        cb-dmov.nromes <= iNroMes AND
        LOOKUP(cb-dmov.codcta,cListCta) > 0
        BREAK BY cb-dmov.codaux ON ERROR UNDO, LEAVE:

        IF NOT tpomov THEN DO:
            CASE RADIO-codmon:
                WHEN 1 THEN DO:
                    dDebe  = ImpMn1.
                    dHaber = 0.
                END.
                WHEN 2 THEN DO:
                    dDebe  = ImpMn2.
                    dHaber = 0.
                END.
            END CASE.
        END.
        ELSE DO:
            CASE RADIO-codmon:
                WHEN 1 THEN DO:
                    dDebe  = 0.
                    dHaber = ImpMn1.
                END.
                WHEN 2 THEN DO:
                    dDebe  = 0.
                    dHaber = ImpMn2.
                END.
            END CASE.
        END.
        IF NOT (dHaber = 0 AND dDebe = 0) AND
            dHaber <> ? AND dDebe <> ? THEN DO:
            dSaldoCta = dSaldoCta + dDebe - dHaber.
        END.
        IF LAST-OF(cb-dmov.codaux) AND dSaldoCta <> 0 THEN DO:
            cNomAux = "".
            cRUC = "".
            CASE cb-dmov.clfaux:
                WHEN "@CL" THEN DO:
                    cTipAux = "Cliente".
                    FIND gn-clie WHERE
                        gn-clie.codcli = cb-dmov.codaux AND
                        gn-clie.CodCia = cl-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE gn-clie THEN DO:
                        cNomAux = gn-clie.nomcli.
                        cRUC = gn-clie.ruc.
                    END.
                END.
                WHEN "@PV" THEN DO:
                    cTipAux = "Proveedor".
                    FIND gn-prov WHERE
                        gn-prov.codpro = cb-dmov.codaux AND
                        gn-prov.CodCia = pv-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE gn-prov THEN DO:
                        cNomAux = gn-prov.nompro.
                        cRUC = gn-prov.ruc.
                    END.
                END.
                WHEN "@CT" THEN DO:
                    cTipAux = "Cuenta".
                    find cb-ctas WHERE
                        cb-ctas.codcta = cb-dmov.codaux AND
                        cb-ctas.CodCia = cb-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-ctas THEN cNomAux = cb-ctas.nomcta.
                END.
                OTHERWISE DO:
                    cTipAux = "Otro".
                    FIND cb-auxi WHERE
                        cb-auxi.clfaux = cb-dmov.clfaux AND
                        cb-auxi.codaux = cb-dmov.codaux AND
                        cb-auxi.CodCia = cb-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-auxi THEN cNomAux = cb-auxi.nomaux.
                END.
            END CASE.

            /* Despliega Detalle de Información */
            PUT STREAM report UNFORMATTED
                "06|"
                cRUC "|"
                "0|"
                "|"
                "|"
                "|"
                cNomAux "|"
                dSaldoCta "|" 
                SKIP.

            dSaldoCta = 0.

            DISPLAY
                "   " + cTipAux + ": " + cb-dmov.codaux @ FI-MENSAJE
                WITH FRAME F-PROCESO.

        END.    /* IF LAST-OF(cb-dmov.codaux)... */
    END.  /* FOR EACH cb-dmov... */

    OUTPUT STREAM report CLOSE.
    HIDE FRAME F-PROCESO.
    MESSAGE
        "Proceso Terminado con suceso"
        VIEW-AS ALERT-BOX INFORMA.

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

   DEFINE VARIABLE pto AS LOGICAL NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            COMBO-Periodo:LIST-ITEMS = cPeriodo
            COMBO-Periodo = s-periodo
            COMBO-Mes = ENTRY(s-nromes,COMBO-Mes:LIST-ITEMS).
        DO ind = 1 TO NUM-ENTRIES(cPeriodo):
            IF ENTRY(ind,cPeriodo) = "" THEN pto = COMBO-Periodo:DELETE("").
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "cb-ctas"}

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

