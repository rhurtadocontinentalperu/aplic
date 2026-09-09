&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME nrotraW-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS nrotraW-Win 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: /*ML01*/ 05/Ene/2010 Captura Poercentaje de Detracción
                    de campo cb-CMov.PorDet. 
          
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
DEFINE SHARED VARIABLE s-nomcia AS CHARACTER.
DEFINE SHARED VARIABLE s-periodo AS INTEGER.
DEFINE SHARED VARIABLE s-nromes AS INTEGER.

DEFINE VARIABLE cListCta AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPeriodo AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodOpe AS CHARACTER NO-UNDO.
DEFINE VARIABLE iNroMes AS INTEGER NO-UNDO.
DEFINE VARIABLE iNroMes-1 AS INTEGER NO-UNDO.
DEFINE VARIABLE ind AS INTEGER NO-UNDO.

DEFINE VARIABLE cb-codcia AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE pv-codcia AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE cl-codcia AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE cPinta-mes AS CHARACTER FORMAT "X(30)".
DEFINE VARIABLE cNomAux  AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE cTipAux  AS CHARACTER.
DEFINE VARIABLE dPordet  AS DECIMAL FORMAT ">>9.99" NO-UNDO.
DEFINE VARIABLE dTotImp1 AS DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE dDetImp1 AS DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE dSalImp1 AS DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE dTotImp2 AS DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE dDetImp2 AS DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE dSalImp2 AS DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.

DEFINE TEMP-TABLE wrk_detrac NO-UNDO
    FIELDS wrk_fchast LIKE cb-cmov.fchast
    FIELDS wrk_nroast LIKE cb-cmov.nroast
    FIELDS wrk_codope LIKE cb-cmov.codope
    FIELDS wrk_codcta LIKE cb-dmov.codcta
    FIELDS wrk_codaux LIKE cb-dmov.codaux
    FIELDS wrk_nomaux LIKE cNomAux
    FIELDS wrk_coddoc LIKE cb-dmov.coddoc
    FIELDS wrk_nrodoc LIKE cb-dmov.nrodoc
    FIELDS wrk_pordet LIKE dPordet
    FIELDS wrk_moneda AS CHARACTER
    FIELDS wrk_totimp1 LIKE dTotImp1
    FIELDS wrk_detimp1 LIKE dDetImp1
    FIELDS wrk_salimo1 LIKE dSalImp1
    FIELDS wrk_nroref LIKE cb-cmov.nrotra
    FIELDS wrk_fchref LIKE cb-cmov.fchmod
    INDEX idx01 IS PRIMARY
        wrk_codaux wrk_coddoc wrk_nrodoc
        wrk_fchast wrk_codope DESCENDING.

DEFINE VARIABLE FI-MENSAJE AS CHAR FORMAT "X(40)" NO-UNDO.
DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6 SKIP
    Fi-Mensaje NO-LABEL FONT 6 SKIP     
    WITH CENTERED OVERLAY KEEP-TAB-ORDER 
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

cListCta = "421101,421102".

DEFINE BUFFER b-cb-dmov FOR cb-dmov.
DEFINE BUFFER b-cb-cmov FOR cb-cmov.

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
&Scoped-Define ENABLED-OBJECTS COMBO-Periodo RADIO-SET-codmon COMBO-mes ~
COMBO-mes-1 FILL-IN-CodAux FILL-IN-CodAux-1 FILL-IN-plazo Btn_Excel Btn_OK ~
Btn_Cancel RECT-2 RECT-1 
&Scoped-Define DISPLAYED-OBJECTS COMBO-Periodo RADIO-SET-codmon COMBO-mes ~
COMBO-mes-1 FILL-IN-CodAux FILL-IN-CodAux-1 FILL-IN-plazo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR nrotraW-Win AS WIDGET-HANDLE NO-UNDO.

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
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-mes-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Hasta" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodAux AS CHARACTER FORMAT "X(256)":U 
     LABEL "Auxiliar" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodAux-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-plazo AS INTEGER FORMAT ">>9":U INITIAL 5 
     LABEL "Días de Plazo de Pago" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-codmon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 12 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 5.38.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15 BY 5.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-Periodo AT ROW 1.38 COL 10 COLON-ALIGNED
     RADIO-SET-codmon AT ROW 1.38 COL 30 NO-LABEL
     COMBO-mes AT ROW 2.35 COL 10 COLON-ALIGNED
     COMBO-mes-1 AT ROW 2.35 COL 28 COLON-ALIGNED
     FILL-IN-CodAux AT ROW 3.31 COL 10 COLON-ALIGNED
     FILL-IN-CodAux-1 AT ROW 3.31 COL 28 COLON-ALIGNED
     FILL-IN-plazo AT ROW 4.27 COL 28 COLON-ALIGNED
     Btn_Excel AT ROW 1.38 COL 48
     Btn_OK AT ROW 2.92 COL 48
     Btn_Cancel AT ROW 4.46 COL 48
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 1.58 COL 23.57
     RECT-2 AT ROW 1 COL 46
     RECT-1 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 60.14 BY 5.38
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
  CREATE WINDOW nrotraW-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Reporte Conciliación de Detracciones"
         HEIGHT             = 5.38
         WIDTH              = 60.14
         MAX-HEIGHT         = 5.38
         MAX-WIDTH          = 60.14
         VIRTUAL-HEIGHT     = 5.38
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
IF NOT nrotraW-Win:LOAD-ICON("img\climnu3":U) THEN
    MESSAGE "Unable to load icon: img\climnu3"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB nrotraW-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW nrotraW-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(nrotraW-Win)
THEN nrotraW-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME nrotraW-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nrotraW-Win nrotraW-Win
ON END-ERROR OF nrotraW-Win /* Reporte Conciliación de Detracciones */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nrotraW-Win nrotraW-Win
ON WINDOW-CLOSE OF nrotraW-Win /* Reporte Conciliación de Detracciones */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel nrotraW-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Excel nrotraW-Win
ON CHOOSE OF Btn_Excel IN FRAME F-Main /* Excel */
DO:

    DEFINE VARIABLE lOk AS LOGICAL NO-UNDO.
    DEFINE VARIABLE cFile-Name AS CHARACTER NO-UNDO.

    ASSIGN
        COMBO-Periodo
        COMBO-Mes
        COMBO-Mes-1
        RADIO-SET-codmon
        FILL-IN-CodAux
        FILL-IN-CodAux-1
        FILL-IN-plazo.

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

        DO WITH FRAME {&FRAME-NAME}:
            iNroMes = LOOKUP(COMBO-mes,COMBO-mes:LIST-ITEMS).
            iNroMes-1 = LOOKUP(COMBO-mes,COMBO-mes-1:LIST-ITEMS).
            DISABLE ALL.
        END.

        IF FILL-IN-CodAux-1 = "" THEN FILL-IN-CodAux-1 = "ZZZZZZZZ".
        RUN Genera-Txt(cFile-Name).
        IF FILL-IN-CodAux-1 = "ZZZZZZZZ" THEN FILL-IN-CodAux-1 = "".

        DO WITH FRAME {&FRAME-NAME}:
            ENABLE ALL.
        END.

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK nrotraW-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:

    ASSIGN
        COMBO-Periodo
        COMBO-Mes
        COMBO-Mes-1
        RADIO-SET-codmon
        FILL-IN-CodAux
        FILL-IN-CodAux-1
        FILL-IN-plazo.

    DO WITH FRAME {&FRAME-NAME}:
        iNroMes = LOOKUP(COMBO-mes,COMBO-mes:LIST-ITEMS).
        iNroMes-1 = LOOKUP(COMBO-mes-1,COMBO-mes-1:LIST-ITEMS).
        DISABLE ALL.
    END.

    IF FILL-IN-CodAux-1 = "" THEN FILL-IN-CodAux-1 = "ZZZZZZZZ".
    RUN Imprime.
    IF FILL-IN-CodAux-1 = "ZZZZZZZZ" THEN FILL-IN-CodAux-1 = "".

    DO WITH FRAME {&FRAME-NAME}:
        ENABLE ALL.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK nrotraW-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

/* Include custom  Main Block code for SmartWindows. */

{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects nrotraW-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available nrotraW-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal nrotraW-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND Empresas WHERE Empresas.CodCia = s-codcia NO-LOCK.
    IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.
    IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.
    IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

    DISPLAY WITH FRAME F-PROCESO.

    EMPTY TEMP-TABLE wrk_detrac.

    /* Todas las provisiones */
    FOR EACH cb-dmov NO-LOCK WHERE
        cb-dmov.codcia = s-codcia AND
        cb-dmov.periodo = COMBO-periodo AND
        cb-dmov.nromes >= iNroMes AND
        cb-dmov.nromes <= iNroMes-1 AND
        cb-dmov.codope = "060" AND
        (cb-dmov.codcta = "42121110" OR cb-dmov.codcta = "42121120") AND
        cb-dmov.codaux >= FILL-IN-CodAux AND
        cb-dmov.codaux <= FILL-IN-CodAux-1,
        FIRST cb-cmov NO-LOCK WHERE
            cb-cmov.codcia = cb-dmov.codcia AND
            cb-cmov.periodo = cb-dmov.periodo AND
            cb-cmov.nromes = cb-dmov.nromes AND
            cb-cmov.codope = cb-dmov.codope AND
            cb-cmov.nroast = cb-dmov.nroast AND
            (cb-cmov.codmon = 2 OR RADIO-SET-codmon = 1)
        BREAK BY cb-dmov.nromes BY cb-dmov.nroast:
        IF FIRST-OF(cb-dmov.nroast) THEN DO:
            dTotImp1 = 0.
        END.
/*ML01*/ dPordet = cb-cmov.PorDet.
        IF cb-dmov.TM = 8 THEN dTotImp1 = dTotImp1 + cb-dmov.ImpMn1.
        IF LAST-OF(cb-dmov.nroast) AND
            dPordet <> 0 AND dTotImp1 <> 0 THEN DO:
            dDetImp1 = ROUND((dTotImp1 * (dPordet / 100)),0).
            dSalImp1 = dTotImp1 - dDetImp1.
            IF cb-cmov.codmon = 2 THEN DO:
                dTotImp2 = ROUND((dTotImp1 / cb-cmov.tpocmb),2).
                dDetImp2 = ROUND((dDetImp1 / cb-cmov.tpocmb),2).
                dSalImp2 = dTotImp2 - dDetImp2.
            END.
            ELSE DO:
                dTotImp2 = 0.
                dDetImp2 = 0.
                dSalImp2 = 0.
            END.
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

            IF RADIO-SET-codmon = 2 AND cb-cmov.codmon = 2 THEN DO:
                dTotImp1 = dTotImp2.
                dDetImp1 = dDetImp2.
                dSalImp1 = dSalImp2.
            END.

            CREATE wrk_detrac.
            ASSIGN
                wrk_fchast = cb-cmov.fchast
                wrk_nroast = cb-cmov.nroast
                wrk_codope = cb-cmov.codope
                wrk_codcta = cb-dmov.codcta
                wrk_codaux = cb-dmov.codaux
                wrk_nomaux = cNomAux
                wrk_coddoc = cb-dmov.coddoc
                wrk_nrodoc = cb-dmov.nrodoc
                wrk_pordet = dPordet
                wrk_moneda = IF RADIO-SET-codmon = 1 THEN "S/." ELSE "US$"
                wrk_totimp1 = dTotImp1
                wrk_detimp1 = dDetImp1
                wrk_salimo1 = dSalImp1
                wrk_nroref = cb-cmov.nrotra
                wrk_fchref = cb-cmov.fchmod.
            DISPLAY
                "   " + cTipAux + ": " + cb-dmov.codaux @ FI-MENSAJE
                WITH FRAME F-PROCESO.

            /* Cancelaciones */
            FOR EACH b-cb-dmov NO-LOCK WHERE
                b-cb-dmov.codcia = cb-dmov.codcia AND
                b-cb-dmov.periodo >= cb-dmov.periodo AND
                b-cb-dmov.codcta = cb-dmov.codcta AND
                b-cb-dmov.CodDoc = cb-dmov.coddoc AND
                b-cb-dmov.NroDoc = cb-dmov.nrodoc AND
                b-cb-dmov.CodAux = cb-dmov.codaux USE-INDEX DMOV05,
                FIRST b-cb-cmov NO-LOCK WHERE
                    b-cb-cmov.codcia = b-cb-dmov.codcia AND
                    b-cb-cmov.periodo = b-cb-dmov.periodo AND
                    b-cb-cmov.nromes = b-cb-dmov.nromes AND
                    b-cb-cmov.codope = b-cb-dmov.codope AND
                    b-cb-cmov.nroast = b-cb-dmov.nroast:

                IF b-cb-dmov.codope <> "002" THEN NEXT.

                IF RADIO-SET-codmon = 2 THEN
                    dTotImp1 = ROUND((b-cb-dmov.ImpMn1 / b-cb-dmov.tpocmb),2).
                ELSE dTotImp1 = b-cb-dmov.ImpMn1.

                CREATE wrk_detrac.
                ASSIGN
                    wrk_nroast = b-cb-dmov.nroast
                    wrk_fchast = b-cb-cmov.fchast
                    wrk_codope = b-cb-dmov.codope
                    wrk_codcta = b-cb-dmov.codcta
                    wrk_codaux = b-cb-dmov.codaux
                    wrk_nomaux = cNomAux
                    wrk_coddoc = b-cb-dmov.coddoc
                    wrk_nrodoc = b-cb-dmov.nrodoc
                    wrk_pordet = dPordet
                    wrk_moneda = IF RADIO-SET-codmon = 1 THEN "S/." ELSE "US$"
                    wrk_totimp1 = dTotImp1
                    wrk_nroref = b-cb-cmov.nrotra.

            END.
        END.
    END.

    HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI nrotraW-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(nrotraW-Win)
  THEN DELETE WIDGET nrotraW-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI nrotraW-Win  _DEFAULT-ENABLE
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
  DISPLAY COMBO-Periodo RADIO-SET-codmon COMBO-mes COMBO-mes-1 FILL-IN-CodAux 
          FILL-IN-CodAux-1 FILL-IN-plazo 
      WITH FRAME F-Main IN WINDOW nrotraW-Win.
  ENABLE COMBO-Periodo RADIO-SET-codmon COMBO-mes COMBO-mes-1 FILL-IN-CodAux 
         FILL-IN-CodAux-1 FILL-IN-plazo Btn_Excel Btn_OK Btn_Cancel RECT-2 
         RECT-1 
      WITH FRAME F-Main IN WINDOW nrotraW-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW nrotraW-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel nrotraW-Win 
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

    FIND Empresas WHERE Empresas.CodCia = s-codcia NO-LOCK.
    IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.
    IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.
    IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

    IF iNroMes <> iNroMes-1 THEN
        cPinta-mes = "DE ENERO A DICIEMBRE DE " + STRING(COMBO-Periodo).
    ELSE cPinta-mes = CAPS(COMBO-Mes) + " DE " + STRING(COMBO-Periodo).

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* set the column names for the Worksheet */
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "REPORTE DE DETRACCIONES".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = cPinta-mes.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "FECHA".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "ASIENTO".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "CUENTA".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "AUXILIAR".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "NOMBRE".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "GLOSA".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "CD".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOCUMENTO".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "% DETRACCION".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "IMPORTE S/.".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "DETRACCION S/.".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "SALDO S/.".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "TIPO CAMBIO".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "IMPORTE US$".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "DETRACCION US$".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "SALDO US$".

    chWorkSheet:Columns("B"):NumberFormat = "@".
    chWorkSheet:Columns("C"):NumberFormat = "@".
    chWorkSheet:Columns("D"):NumberFormat = "@".
    chWorkSheet:Columns("G"):NumberFormat = "@".
    chWorkSheet:Columns("H"):NumberFormat = "@".
    chWorkSheet:Columns("E"):ColumnWidth = 45.
    chWorkSheet:Columns("F"):ColumnWidth = 45.
    chWorkSheet:Range("A1:P3"):Font:Bold = TRUE.

    FOR EACH cb-dmov NO-LOCK WHERE
        cb-dmov.codcia = s-codcia AND
        cb-dmov.periodo = COMBO-periodo AND
        cb-dmov.nromes >= iNroMes AND
        cb-dmov.nromes <= iNroMes-1 AND
        cb-dmov.codope = cCodOpe AND
        LOOKUP(cb-dmov.codcta,cListCta) > 0 AND
        cb-dmov.codaux >= FILL-IN-CodAux AND
        cb-dmov.codaux <= FILL-IN-CodAux-1,
        FIRST cb-cmov NO-LOCK WHERE
            cb-cmov.codcia = cb-dmov.codcia AND
            cb-cmov.periodo = cb-dmov.periodo AND
            cb-cmov.nromes = cb-dmov.nromes AND
            cb-cmov.codope = cb-dmov.codope AND
            cb-cmov.nroast = cb-dmov.nroast
        BREAK BY cb-dmov.nromes BY cb-dmov.nroast:
        IF FIRST-OF(cb-dmov.nroast) THEN DO:
/*ML01* ***
            IF NUM-ENTRIES(cb-cmov.GloAst,"-") > 1 THEN
                dPordet = DECIMAL(ENTRY(1,cb-cmov.GloAst,"-")) NO-ERROR.
            ELSE dPordet = DECIMAL(cb-cmov.GloAst) NO-ERROR.
*ML01* ***/
/*ML01*/    dPordet = cb-CMov.PorDet.
            dTotImp1 = 0.
        END.
        IF cb-dmov.TM = 8 THEN dTotImp1 = dTotImp1 + ImpMn1.
        IF LAST-OF(cb-dmov.nroast) AND
            dPordet <> 0 AND dTotImp1 <> 0 THEN DO:
            dDetImp1 = ROUND((dTotImp1 * (dPordet / 100)),0).
            dSalImp1 = dTotImp1 - dDetImp1.
            IF cb-cmov.codmon = 2 THEN DO:
                dTotImp2 = ROUND((dTotImp1 / cb-cmov.tpocmb),2).
                dDetImp2 = ROUND((dDetImp1 / cb-cmov.tpocmb),2).
                dSalImp2 = dTotImp2 - dDetImp2.
            END.
            ELSE DO:
                dTotImp2 = 0.
                dDetImp2 = 0.
                dSalImp2 = 0.
            END.
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

            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-cmov.fchast.
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-cmov.nroast.
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-dmov.codcta.
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-dmov.codaux.
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = cNomAux.
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-dmov.glodoc.
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-dmov.coddoc.
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-dmov.nrodoc.
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):Value = dPordet.
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotImp1.
            cRange = "K" + cColumn.
            chWorkSheet:Range(cRange):Value = dDetImp1.
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = dSalImp1.
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-cmov.tpocmb.
            cRange = "N" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotImp2.
            cRange = "O" + cColumn.
            chWorkSheet:Range(cRange):Value = dDetImp2.
            cRange = "P" + cColumn.
            chWorkSheet:Range(cRange):Value = dSalImp2.

            DISPLAY
                "   " + cTipAux + ": " + cb-dmov.codaux @ FI-MENSAJE
                WITH FRAME F-PROCESO.
        END.
    END.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

    HIDE FRAME F-PROCESO.
    MESSAGE
        "Proceso Terminado con suceso"
        VIEW-AS ALERT-BOX INFORMA.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato nrotraW-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE fPimerDia AS DATE NO-UNDO.
    DEFINE VARIABLE fFecPago AS DATE NO-UNDO.
    DEFINE VARIABLE iDiaSemana AS INTEGER NO-UNDO.
    DEFINE VARIABLE iContador AS INTEGER NO-UNDO.
    DEFINE VARIABLE iSabDom AS INTEGER NO-UNDO.

    IF iNroMes <> iNroMes-1 THEN
        cPinta-mes = "DE ENERO A DICIEMBRE DE " + STRING(COMBO-Periodo).
    ELSE cPinta-mes = CAPS(COMBO-Mes) + " DE " + STRING(COMBO-Periodo).

    DEFINE FRAME f-cab
        HEADER
        s-nomcia FORMAT "x(50)"
        "REPORTE CONCILIACIÓN DE DETRACCIONES" AT 107
        "FECHA : " TO 247 TODAY TO 257
        SKIP
        cPinta-mes  AT 114
        "PAGINA :" TO 247 PAGE-NUMBER(report) FORMAT ">,>>9" TO 257
        WITH WIDTH 400 NO-BOX DOWN STREAM-IO NO-UNDERLINE NO-LABEL PAGE-TOP.

    RUN bin/_centrar.p(INPUT cPinta-mes, 30, OUTPUT cPinta-mes).

    VIEW STREAM report FRAME F-CAB.

    /* Todas las provisiones */
    FOR EACH wrk_detrac NO-LOCK
        BREAK BY wrk_codaux
        BY wrk_coddoc BY wrk_nrodoc
        BY wrk_fchast BY wrk_codope DESCENDING
        WITH FRAME f-det WIDTH 400:
        IF wrk_codope = "060" THEN DO:
            /* Primer día del siguiente mes */
            IF MONTH(wrk_fchast) = 12 THEN
                fPimerDia = DATE(1,1,YEAR(wrk_fchast) + 1).
            ELSE
                fPimerDia = DATE(MONTH(wrk_fchast) + 1,1,YEAR(wrk_fchast)).
            /* No debe ser Sábado o Domingo */
            IF WEEKDAY(fPimerDia) = 7 THEN fPimerDia = fPimerDia + 2.      /* Sábado */
            ELSE IF WEEKDAY(fPimerDia) = 1 THEN fPimerDia = fPimerDia + 1. /* Domingo */

            CASE WEEKDAY(fPimerDia):
                WHEN 2 THEN iDiaSemana = 5.
                WHEN 3 THEN iDiaSemana = 4.
                WHEN 4 THEN iDiaSemana = 3.
                WHEN 5 THEN iDiaSemana = 2.
                WHEN 6 THEN iDiaSemana = 1.
            END CASE.
            iSabDom = 0.
            iContador = FILL-IN-plazo.
            DO WHILE iContador > 0:
                iContador = iContador - iDiaSemana.
                IF iContador > 0 THEN iSabDom = iSabDom + 2.
                IF iDiaSemana < 5 THEN iDiaSemana = 5.
            END.
            IF FILL-IN-plazo > 0 THEN
                fFecPago = fPimerDia + FILL-IN-plazo - 1 + iSabDom.
            ELSE fFecPago = fPimerDia.

        END.
        ELSE fFecPago = wrk_fchast.
        DISPLAY STREAM REPORT
            wrk_fchast 
            wrk_nroast
            wrk_codope
            wrk_codcta
            wrk_codaux
            wrk_nomaux COLUMN-LABEL "Nombre/Razón Social"
            wrk_coddoc COLUMN-LABEL "CD"
            wrk_nrodoc
            wrk_pordet COLUMN-LABEL "% Det"
            wrk_moneda COLUMN-LABEL "Mon" FORMAT "xxx"
            wrk_totimp1 COLUMN-LABEL "Importe" WHEN wrk_totimp1 <> 0
            wrk_detimp1 COLUMN-LABEL "Detracción" WHEN wrk_detimp1 <> 0
            wrk_salimo1 COLUMN-LABEL "Saldo" WHEN wrk_salimo1 <> 0
            fFecPago COLUMN-LABEL "Plazo!Pago"
            wrk_nroref COLUMN-LABEL "Nro Detrac" FORMAT "X(10)"
            wrk_fchref COLUMN-LABEL "Fecha!Detrac"
            WITH STREAM-IO.
        DISPLAY
            "    " + wrk_codaux @ FI-MENSAJE
            WITH FRAME F-PROCESO.
        IF LAST-OF(wrk_codaux) THEN DOWN STREAM report 1 WITH STREAM-IO.
    END.

    HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-TXT nrotraW-Win 
PROCEDURE Genera-TXT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_file AS CHARACTER.

    DEFINE VARIABLE fPimerDia AS DATE NO-UNDO.
    DEFINE VARIABLE fFecPago AS DATE NO-UNDO.
    DEFINE VARIABLE iDiaSemana AS INTEGER NO-UNDO.
    DEFINE VARIABLE iContador AS INTEGER NO-UNDO.
    DEFINE VARIABLE iSabDom AS INTEGER NO-UNDO.

    RUN Carga-Temporal.

    OUTPUT STREAM report TO VALUE(para_file).
    /* Todas las provisiones */
    FOR EACH wrk_detrac NO-LOCK
        BREAK BY wrk_codaux
        BY wrk_coddoc BY wrk_nrodoc
        BY wrk_fchast BY wrk_codope DESCENDING
        WITH FRAME f-det WIDTH 400:
        IF wrk_codope = "060" THEN DO:
            /* Primer día del siguiente mes */
            IF MONTH(wrk_fchast) = 12 THEN
                fPimerDia = DATE(1,1,YEAR(wrk_fchast) + 1).
            ELSE
                fPimerDia = DATE(MONTH(wrk_fchast) + 1,1,YEAR(wrk_fchast)).
            /* No debe ser Sábado o Domingo */
            IF WEEKDAY(fPimerDia) = 7 THEN fPimerDia = fPimerDia + 2.      /* Sábado */
            ELSE IF WEEKDAY(fPimerDia) = 1 THEN fPimerDia = fPimerDia + 1. /* Domingo */

            CASE WEEKDAY(fPimerDia):
                WHEN 2 THEN iDiaSemana = 5.
                WHEN 3 THEN iDiaSemana = 4.
                WHEN 4 THEN iDiaSemana = 3.
                WHEN 5 THEN iDiaSemana = 2.
                WHEN 6 THEN iDiaSemana = 1.
            END CASE.
            iSabDom = 0.
            iContador = FILL-IN-plazo.
            DO WHILE iContador > 0:
                iContador = iContador - iDiaSemana.
                IF iContador > 0 THEN iSabDom = iSabDom + 2.
                IF iDiaSemana < 5 THEN iDiaSemana = 5.
            END.
            IF FILL-IN-plazo > 0 THEN
                fFecPago = fPimerDia + FILL-IN-plazo - 1 + iSabDom.
            ELSE fFecPago = fPimerDia.

        END.
        ELSE fFecPago = wrk_fchast.
        DISPLAY STREAM REPORT
            wrk_fchast 
            wrk_nroast
            wrk_codope
            wrk_codcta
            wrk_codaux
            wrk_nomaux COLUMN-LABEL "Nombre/Razón Social"
            wrk_coddoc COLUMN-LABEL "CD"
            wrk_nrodoc
            wrk_pordet COLUMN-LABEL "% Det"
            wrk_moneda COLUMN-LABEL "Mon" FORMAT "xxx"
            wrk_totimp1 COLUMN-LABEL "Importe" WHEN wrk_totimp1 <> 0
            wrk_detimp1 COLUMN-LABEL "Detracción" WHEN wrk_detimp1 <> 0
            wrk_salimo1 COLUMN-LABEL "Saldo" WHEN wrk_salimo1 <> 0
            fFecPago COLUMN-LABEL "Plazo!Pago"
            wrk_nroref COLUMN-LABEL "Nro Detrac" FORMAT "X(10)"
            wrk_fchref COLUMN-LABEL "Fecha!Detrac"
            WITH STREAM-IO.
        DISPLAY
            "    " + wrk_codaux @ FI-MENSAJE
            WITH FRAME F-PROCESO.
        IF LAST-OF(wrk_codaux) THEN DOWN STREAM report 1 WITH STREAM-IO.
    END.
    OUTPUT STREAM report CLOSE.
    HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime nrotraW-Win 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    RUN Carga-Temporal.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit nrotraW-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize nrotraW-Win 
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
            COMBO-Mes = ENTRY(s-nromes,COMBO-Mes:LIST-ITEMS)
            COMBO-Mes-1 = ENTRY(s-nromes,COMBO-Mes:LIST-ITEMS).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros nrotraW-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros nrotraW-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records nrotraW-Win  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed nrotraW-Win 
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

