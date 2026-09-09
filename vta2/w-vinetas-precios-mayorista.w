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
{src/bin/_prns.i}   /* Para la impresion */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF STREAM REPORTE.
DEF SHARED VAR s-codalm LIKE almacen.codalm.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-nomcia   AS CHAR.

DEF VAR x-desmat  AS CHAR NO-UNDO FORMAT 'X(30)'.
DEF VAR x-desmat2 AS CHAR NO-UNDO FORMAT 'X(20)'.
DEF VAR x-desmar  AS CHAR NO-UNDO FORMAT 'X(30)'.
DEF VAR x-preuni  AS CHAR NO-UNDO FORMAT 'X(12)'.
DEF VAR x-dtovol  AS CHAR NO-UNDO FORMAT 'X(40)'.
DEF VAR x-dtovo2  AS CHAR NO-UNDO FORMAT 'X(40)'.
DEF VAR cNotita   AS CHAR NO-UNDO FORMAT 'X(35)'.

DEFINE VAR lPrecioConDscto AS DEC.
DEFINE VAR lPrecioNormal AS DEC.
DEFINE VAR lDsctoPromocional AS DEC.

DEFINE TEMP-TABLE tt-articulos 
    FIELDS t-codmat LIKE almmmatg.codmat FORMA 'x(6)'
    FIELDS t-cuantos AS INT INIT 0 FORMAT '9' .

DEFINE VAR s-task-no AS INT.


/* Precios retail */
DEFINE VAR toggle-nuevoformato AS LOG.

toggle-nuevoformato = YES.

IF USERID("DICTDB") = "MASTER" THEN s-coddiv = '00072'.


/*
DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "aplic/alm/rbalm.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Hoja Ruta2".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

/* capturamos ruta inicial */
DEF VAR S-REPORT-LIBRARY AS CHAR.
GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE s-report-library.
RB-REPORT-LIBRARY = s-report-library + "alm\rbalm.prl".

*/

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
&Scoped-Define ENABLED-OBJECTS fill-in-codmat BUTTON-5 FILL-IN-file ~
RADIO-SET-formato btn-print BUTTON-8 
&Scoped-Define DISPLAYED-OBJECTS fill-in-codmat FILL-IN-file ~
RADIO-SET-formato 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-print 
     IMAGE-UP FILE "IMG/print-2.ico":U
     LABEL "Button 7" 
     SIZE 9 BY 2.15.

DEFINE BUTTON btnPreciosxVolumen 
     LABEL "Imprimir precios x Volumen" 
     SIZE 24 BY 1.12.

DEFINE BUTTON BUTTON-5 
     LABEL "..." 
     SIZE 5 BY 1.

DEFINE BUTTON BUTTON-8 
     IMAGE-UP FILE "IMG/exit.ico":U
     LABEL "Button 8" 
     SIZE 9 BY 2.15.

DEFINE VARIABLE fill-in-codmat AS CHARACTER FORMAT "X(13)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-file AS CHARACTER FORMAT "X(256)":U 
     LABEL "Listado" 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE txtCuantos AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Cuantos (0 = Todos)" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-formato AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Formato Estandar", 1,
"Precio A + Promociones(si lo hay)", 2
     SIZE 27 BY 1.54 NO-UNDO.

DEFINE VARIABLE rs-modimp AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Cod Internos", 1,
"Cod EAN 13", 2
     SIZE 27 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53 BY 1.19.

DEFINE VARIABLE TOGGLE-Promocional AS LOGICAL INITIAL no 
     LABEL "Formato RETAIL (Utilex)" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     fill-in-codmat AT ROW 2.88 COL 8 COLON-ALIGNED WIDGET-ID 20
     BUTTON-5 AT ROW 3.77 COL 52.86 WIDGET-ID 66
     FILL-IN-file AT ROW 3.85 COL 8 COLON-ALIGNED WIDGET-ID 68
     RADIO-SET-formato AT ROW 5.04 COL 8 NO-LABEL WIDGET-ID 96
     btn-print AT ROW 5.27 COL 43 WIDGET-ID 4
     BUTTON-8 AT ROW 5.27 COL 52 WIDGET-ID 18
     rs-modimp AT ROW 7.46 COL 2 NO-LABEL WIDGET-ID 80
     TOGGLE-Promocional AT ROW 7.54 COL 31 WIDGET-ID 84
     btnPreciosxVolumen AT ROW 8.5 COL 30 WIDGET-ID 90
     txtCuantos AT ROW 8.62 COL 19.29 COLON-ALIGNED WIDGET-ID 88
     "6 digitos / Ean13" VIEW-AS TEXT
          SIZE 13.72 BY .5 AT ROW 3.04 COL 37.57 WIDGET-ID 94
          FGCOLOR 12 
     "Impresión de Viñetas de Precios Mayorista / MOSTRADOR" VIEW-AS TEXT
          SIZE 54.86 BY .81 AT ROW 1.04 COL 4.14 WIDGET-ID 12
          FGCOLOR 7 FONT 13
     "  Ingrese el codigo de articulo" VIEW-AS TEXT
          SIZE 20.72 BY .73 AT ROW 2.08 COL 10 WIDGET-ID 92
          BGCOLOR 9 FGCOLOR 15 
     RECT-1 AT ROW 8.46 COL 5 WIDGET-ID 86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 61.43 BY 8.81
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
         TITLE              = "VIÑETAS DE PRECIOS"
         HEIGHT             = 8.69
         WIDTH              = 61.43
         MAX-HEIGHT         = 9.69
         MAX-WIDTH          = 61.43
         VIRTUAL-HEIGHT     = 9.69
         VIRTUAL-WIDTH      = 61.43
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
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR BUTTON btnPreciosxVolumen IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       btnPreciosxVolumen:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       RECT-1:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR RADIO-SET rs-modimp IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       rs-modimp:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX TOGGLE-Promocional IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       TOGGLE-Promocional:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN txtCuantos IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       txtCuantos:HIDDEN IN FRAME F-Main           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* VIÑETAS DE PRECIOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* VIÑETAS DE PRECIOS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-print W-Win
ON CHOOSE OF btn-print IN FRAME F-Main /* Button 7 */
DO:
    
    ASSIGN
        fill-in-codmat FILL-IN-file TOGGLE-Promocional radio-set-formato. /*rs-modimp  txtCuantos.*/
    RUN imprimir-vinetas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnPreciosxVolumen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnPreciosxVolumen W-Win
ON CHOOSE OF btnPreciosxVolumen IN FRAME F-Main /* Imprimir precios x Volumen */
DO:
    ASSIGN
        fill-in-codmat FILL-IN-file rs-modimp TOGGLE-Promocional txtCuantos.
    RUN proceso-x-Vol.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* ... */
DO:

    DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.

    SYSTEM-DIALOG GET-FILE FILL-IN-file
        FILTERS
            "Archivos Texto (*.txt)" "*.txt",
            "Todos (*.*)" "*.*"
        TITLE
            "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.

    IF OKpressed = TRUE THEN
        FILL-IN-file:SCREEN-VALUE = FILL-IN-file.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* Button 8 */
DO:
  RUN local-exit.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Articulos W-Win 
PROCEDURE Carga-Articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FOR EACH tt-articulos:
        DELETE tt-articulos.
    END.

    DEFINE VAR xlineatextto AS CHAR.

    IF SEARCH(FILL-IN-file) <> ? THEN DO:
        OUTPUT TO VALUE(FILL-IN-file) APPEND.
        PUT UNFORMATTED "?" CHR(10) SKIP.
        OUTPUT CLOSE.
        INPUT FROM VALUE(FILL-IN-file).
        REPEAT:
            CREATE tt-articulos.
            IMPORT UNFORMATTED xlineatextto.
            ASSIGN t-codmat = SUBSTRING(xlineatextto,1,6)
                    t-cuantos = int(SUBSTRING(xlineatextto,7,1)).
            IF t-codmat = '' THEN ASSIGN t-codmat = "?".        
        END.
        INPUT CLOSE.
    END.

    FOR EACH tt-articulos:
        IF t-codmat = '' THEN DELETE tt-articulos.
    END.
    
    FIND FIRST tt-articulos WHERE t-codmat = fill-in-codmat NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-articulos THEN DO:
        CREATE tt-articulos.        
        ASSIGN t-codmat = fill-in-codmat
                t-cuantos = txtCuantos.
    END.

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
  DISPLAY fill-in-codmat FILL-IN-file RADIO-SET-formato 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE fill-in-codmat BUTTON-5 FILL-IN-file RADIO-SET-formato btn-print 
         BUTTON-8 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-data-precio W-Win 
PROCEDURE generar-data-precio :
/*
DEFINE VAR f-factor AS DEC.
DEFINE VAR f-PreBas AS DEC.
DEFINE VAR f-PreVta AS DEC.
DEFINE VAR f-Dsctos AS DEC.
DEFINE VAR y-Dsctos AS DEC.
DEFINE VAR  x-TipDto AS CHAR.
DEFINE VAR f-FleteUnitario AS DEC.
DEFINE VAR f-DtoPromocional AS DEC NO-UNDO.
DEFINE VAR X-PREVTA1 AS DEC NO-UNDO.
DEFINE VAR X-PREVTA2 AS DEC NO-UNDO.
DEFINE VAR f-PrePromocional AS DEC NO-UNDO.

DEFINE VAR lPrecio AS DEC.
DEFINE VAR lFactorNuevoMinimoVta AS DEC.
DEFINE VAR lMinimoVta AS DEC.
DEFINE VAR lNuevoMinimoVta AS DEC.

DEFINE VAR lMask AS CHAR.
  
RUN Carga-Articulos.


DEF VAR rpta AS LOG.
SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.
OUTPUT STREAM REPORTE TO PRINTER.

/*
DEFINE VAR x-file-zpl AS CHAR.

x-file-zpl = "d:\tmp\huancayo" + "-" + fill-in-codmat + ".txt".

OUTPUT STREAM REPORTE TO VALUE(x-file-zpl).
*/

DEFINE VAR x-precio-1 AS CHAR.
DEFINE VAR x-precio-2 AS CHAR.

FOR EACH tt-articulos NO-LOCK:

    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
        AND trim(almmmatg.codmat) = trim(t-codmat) NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almmmatg THEN DO:
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
            AND trim(almmmatg.codbrr) = trim(t-codmat) NO-LOCK NO-ERROR.
    END.

    IF NOT AVAILABLE almmmatg THEN NEXT.
    ASSIGN 
        x-DesMat  = TRIM(SUBSTRING(Almmmatg.Desmat,1,45))
        x-DesMat2 = TRIM(SUBSTRING(Almmmatg.Desmat,46))
        x-DesMar  = SUBSTRING(Almmmatg.Desmar,1,30)

    /* Minimo de Venta - Chiclayo , el campo es almmmatg.pesobruto */
    lMinimoVta = IF (almmmatg.pesobruto <= 0) THEN 1 ELSE almmmatg.pesobruto.
    lFactorNuevoMinimoVta = 0.25.

    ASSIGN
        Y-DSCTOS = 0
        x-DtoVol = ''
        x-Dtovo2 = ''
        cNotita  = ''.
    
    x-precio-1 = "".
    x-precio-2 = "".

    f-DtoPromocional = 0.
    f-PrePromocional = 0.

    f-factor = 0.
    f-PreBas = 0.
    f-PreVta = 0.
    f-Dsctos = 0.
    y-Dsctos = 0.
    x-TipDto = "".
    f-FleteUnitario = 0.

    /* Precio B */
    IF NOT (TRUE <> (almmmatg.undB > "")) THEN DO:
        /*MESSAGE "BBBBBBB".*/
        f-factor = 0.
        f-PreBas = 0.
        f-PreVta = 0.
        f-Dsctos = 0.
        y-Dsctos = 0.
        x-TipDto = "".
        f-FleteUnitario = 0.
        RUN vta2/PrecioMayorista-Cont-v2 (s-CodCia,
                                          s-CodDiv,
                                          '11111111111',
                                          1,
                                          almmmatg.tpocmb,
                                          OUTPUT f-Factor,
                                          almmmatg.codmat,
                                          'SINDESCUENTOS',
                                          almmmatg.undB,
                                          1,
                                          4,
                                          s-codalm,   /* Necesario para REMATES */
                                          OUTPUT f-PreBas,
                                          OUTPUT f-PreVta,
                                          OUTPUT f-Dsctos,
                                          OUTPUT y-Dsctos,
                                          OUTPUT x-TipDto,
                                          OUTPUT f-FleteUnitario
                                          ).
        lPrecio = f-PreVta + f-FleteUnitario.

        FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
            AND Almtconv.Codalter = almmmatg.undB
            NO-LOCK NO-ERROR.
        IF AVAILABLE almtconv THEN DO:    
            lNuevoMinimoVta = round(almtconv.equival * lFactorNuevoMinimoVta,0).
            lNuevoMinimoVta = IF (lNuevoMinimoVta <= 0) THEN 1 ELSE lNuevoMinimoVta.

            x-PreUni  = 'S/.' + STRING(lPrecio,'>>>9.99').
            RUN ue-mask(INPUT almtconv.equival, OUTPUT lMask).
            x-precio-1 = x-PreUni + "  x  " + STRING(almtconv.equival,lMask) + " " + almmmatg.undbas.
            
            /*
            IF lNuevoMinimoVta > lMinimoVta THEN DO:
                lPrecio = round(lPrecio / almtconv.equival ,4).
                lPrecioRefx = round(lPrecio,2).
                IF lPrecioRefX <> lPrecioRef THEN DO:
                    lPrecioRef = lPrecioRefX.
                    lPrecio = lPrecio * lNuevoMinimoVta.
                    RUN ue-mask(INPUT lNuevoMinimoVta, OUTPUT lMask).
                    laPrecios[lSec1] = 'S/.  ' + STRING(lPrecio,'>>>9.99') + "  x  " + 
                        STRING(lNuevoMinimoVta,lMask) + " " + trim(almmmatg.undbas) + " (" + string(lPrecioRef) + ")".
                    lSec1 = lSec1 + 1.
                END.

            END.
            */
        END.
    END.

    IF almmmatg.codfam = '013' THEN DO:        
        IF almmmatg.dtovolr[1] > 0 THEN DO:
            /* Dscto Volumen */
            lprecio = almmmatg.prevta[1].
            IF almmmatg.monvta = 2 THEN DO:
                lprecio = lprecio * almmmatg.tpocmb.
            END.
            lprecio = ROUND(( 1 - (almmmatg.dtovold[1] / 100)) * lPrecio , 4).

            RUN ue-mask(INPUT almmmatg.dtovolr[1], OUTPUT lMask).
            x-precio-2  = 'S/.' + STRING(lPrecio,'>>>9.99').
            x-precio-2  = x-precio-2 + "  a partir de " + STRING(almmmatg.dtovolr[1],lMask) + " " + almmmatg.undbas.
        END.
    END.
    ELSE DO:
        IF NOT (TRUE <> (almmmatg.undC > "")) THEN DO:
            /*MESSAGE "CCCCCCCCCCCCCC".*/
            f-factor = 0.
            f-PreBas = 0.
            f-PreVta = 0.
            f-Dsctos = 0.
            y-Dsctos = 0.
            x-TipDto = "".
            f-FleteUnitario = 0.
            RUN vta2/PrecioMayorista-Cont-v2 (s-CodCia,
                                              s-CodDiv,
                                              '11111111111',
                                              1,
                                              almmmatg.tpocmb,
                                              OUTPUT f-Factor,
                                              almmmatg.codmat,
                                              'SINDESCUENTOS',
                                              almmmatg.undC,
                                              1,
                                              4,
                                              s-codalm,   /* Necesario para REMATES */
                                              OUTPUT f-PreBas,
                                              OUTPUT f-PreVta,
                                              OUTPUT f-Dsctos,
                                              OUTPUT y-Dsctos,
                                              OUTPUT x-TipDto,
                                              OUTPUT f-FleteUnitario
                                              ).
            lPrecio = f-PreVta + f-FleteUnitario.

            FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                AND Almtconv.Codalter = almmmatg.undC
                NO-LOCK NO-ERROR.
            IF AVAILABLE almtconv THEN DO:
                lNuevoMinimoVta = round(almtconv.equival * lFactorNuevoMinimoVta,0).
                lNuevoMinimoVta = IF (lNuevoMinimoVta <= 0) THEN 1 ELSE lNuevoMinimoVta.

                RUN ue-mask(INPUT almtconv.equival, OUTPUT lMask).
                x-PreUni  = 'S/.' + STRING(lPrecio,'>>>9.99').
                x-precio-2 = x-PreUni + "  x  " + STRING(almtconv.equival,lMask) + " " + almmmatg.undbas.
                /*
                IF almtconv.equival > lMinimoVta THEN DO:
                    lPrecio = round(lPrecio / almtconv.equival ,4).
                    lPrecioRefX = round(lPrecio,2).
                    IF lPrecioRefX <> lPrecioRef THEN DO:
                        lPrecio = lPrecio * lNuevoMinimoVta.                        
                        lPrecioRef = lPrecioRefX.
                        RUN ue-mask(INPUT lNuevoMinimoVta, OUTPUT lMask).
                        laPrecios[lSec1] = 'S/.  ' + STRING(lPrecio,'>>>9.99') + "  x  " + 
                            STRING(lNuevoMinimoVta,lMask) + " " + trim(almmmatg.undbas) + " (" + string(lPrecioRef) + ")".
                        lSec1 = lSec1 + 1.
                    END.
                END.
                */
            END.
        END.
    END.

    /*
    /****************************************************************/
    IF almmmatg.undA <> ? AND almmmatg.undA <> "" THEN DO:
        RUN vta2/PrecioMayorista-Cont-v2 (s-CodCia,
                                          s-CodDiv,
                                          '11111111111',
                                          1,
                                          almmmatg.tpocmb,
                                          OUTPUT f-Factor,
                                          almmmatg.codmat,
                                          'SINDESCUENTOS',
                                          almmmatg.undA,
                                          1,
                                          4,
                                          s-codalm,   /* Necesario para REMATES */
                                          OUTPUT f-PreBas,
                                          OUTPUT f-PreVta,
                                          OUTPUT f-Dsctos,
                                          OUTPUT y-Dsctos,
                                          OUTPUT x-TipDto,
                                          OUTPUT f-FleteUnitario
                                          ).

        lPrecio = f-PreVta + f-FleteUnitario.

        /* Venta Unidad A  */
        FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
            AND Almtconv.Codalter = almmmatg.undA
            NO-LOCK NO-ERROR.
        IF AVAILABLE almtconv THEN DO:
            /*SI(REDONDEAR(H2768*0.25,0)=0,1,+REDONDEAR(H2768*0.25,0))*/
            lNuevoMinimoVta = round(almtconv.equival * lFactorNuevoMinimoVta,0).
            lNuevoMinimoVta = IF (lNuevoMinimoVta <= 0) THEN 1 ELSE lNuevoMinimoVta.
            /*MESSAGE "A :" + string(lPrecio) + " Mvta :" + string(lNuevoMinimoVta).*/
            /*IF almtconv.equival > lMinimoVta THEN DO:*/
            x-PreUni  = 'S/.' + STRING(lPrecio,'>>>9.99').
            lUnidadVenta_und = "  x  " + STRING(almtconv.equival,lMask).

            IF lNuevoMinimoVta > lMinimoVta THEN DO:
                lPrecio = round(lPrecio / almtconv.equival ,4).
                lPrecioRefx = round(lPrecio,2).
                IF lPrecioRefX <> lPrecioRef THEN DO:
                    lPrecioRef = lPrecioRefX.
                    lPrecio = lPrecio * lNuevoMinimoVta.
                    RUN ue-mask(INPUT lNuevoMinimoVta, OUTPUT lMask).
                    laPrecios[lSec1] = 'S/.  ' + STRING(lPrecio,'>>>9.99') + "  x  " + 
                        STRING(lNuevoMinimoVta,lMask) + " " + trim(almmmatg.undbas) + " (" + string(lPrecioRef) + ")".                   
                    lSec1 = lSec1 + 1.
                END.
                /* Ic - 09Ene2020 - Huancayo */
                x-PreUni  = 'S/.' + STRING(lPrecio,'>>>9.99').
                lUnidadVenta_und = "  x  " + STRING(lNuevoMinimoVta,lMask).
            END.
        END.

    END.    
    */
    
    PUT STREAM REPORTE '^XA^LH50,012'               SKIP.   /* Inicia formato */
    {vta2/vineta-precios-mayorista.i}
    PUT STREAM REPORTE '^PQ' + TRIM(STRING(1)) SKIP.  /* Cantidad a imprimir */
    PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
    PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */           

END.

OUTPUT STREAM reporte CLOSE.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-data-precio-retail W-Win 
PROCEDURE generar-data-precio-retail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE impresion-x-vol W-Win 
PROCEDURE impresion-x-vol :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 /* Pantalla general de parametros de impresion */
 /*
RUN bin/_prnctr.p.
IF s-salida-impresion = 0 THEN RETURN.
   */
   
/*   
DEFINE VARIABLE cDatabaseName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cHostName        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNetworkProto    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPortNumber      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cOtherParams     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNewConnString   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDelimeter       AS CHARACTER NO-UNDO.

GET-KEY-VALUE SECTION "RBParametros" KEY "cDatabaseName" VALUE cDatabaseName.
GET-KEY-VALUE SECTION "RBParametros" KEY "cHostName" VALUE cHostName.
GET-KEY-VALUE SECTION "RBParametros" KEY "cNetworkProto" VALUE cNetworkProto.
GET-KEY-VALUE SECTION "RBParametros" KEY "cPortNumber" VALUE cPortNumber.
GET-KEY-VALUE SECTION "RBParametros" KEY "cOtherParams" VALUE cOtherParams.

ASSIGN cDelimeter = CHR(32).
IF NOT (cDatabaseName = ? OR
   cHostName = ? OR
   cNetworkProto = ? OR
   cPortNumber = ?) THEN DO:
   ASSIGN
       cNewConnString =
       "-db" + cDelimeter + cDatabaseName + cDelimeter +
       "-H" + cDelimeter + cHostName + cDelimeter +
       "-N" + cDelimeter + cNetworkProto + cDelimeter +
       "-S" + cDelimeter + cPortNumber + cDelimeter.
   RB-DB-CONNECTION = cNewConnString.
END.

RB-INCLUDE-RECORDS = "O".
RB-FILTER = " w-report.task-no = " + STRING(s-task-no).
              
ASSIGN
      RB-REPORT-NAME = "Precios por Volumen"
      RB-BEGIN-PAGE = s-pagina-inicial
      RB-END-PAGE = s-pagina-final
      RB-PRINTER-NAME = s-printer-name
      RB-OUTPUT-FILE = s-print-file
      RB-NUMBER-COPIES = s-nro-copias.
  CASE s-salida-impresion:
      WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
      WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
      WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
  END CASE.
  /*
  FIND FIRST DI-RutaD OF DI-RutaC NO-LOCK NO-ERROR.

  IF AVAILABLE DI-RutaD THEN
  */
  /*FIND FIRST tt-articulos NO-LOCK NO-ERROR.*/

  RUN aderb/_prntrb2 (RB-REPORT-LIBRARY,
                      RB-REPORT-NAME,
                      RB-DB-CONNECTION,
                      RB-INCLUDE-RECORDS,
                      RB-FILTER,
                      RB-MEMO-FILE,
                      RB-PRINT-DESTINATION,
                      RB-PRINTER-NAME,
                      RB-PRINTER-PORT,
                      RB-OUTPUT-FILE,
                      RB-NUMBER-COPIES,
                      RB-BEGIN-PAGE,
                      RB-END-PAGE,
                      RB-TEST-PATTERN,
                      RB-WINDOW-TITLE,
                      RB-DISPLAY-ERRORS,
                      RB-DISPLAY-STATUS,
                      RB-NO-WAIT,
                      RB-OTHER-PARAMETERS,
                      "").

*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime-con-dsctopromo W-Win 
PROCEDURE imprime-con-dsctopromo :
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir-vinetas W-Win 
PROCEDURE imprimir-vinetas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE dPreUni  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dDsctos  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dDstoVo1 AS DECIMAL     .
    DEFINE VARIABLE dDstoVo2 AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dPrecio  AS DECIMAL     NO-UNDO.

    DEF VAR x-dtovol  AS CHAR NO-UNDO FORMAT 'X(40)'.
    DEF VAR x-dtovo2  AS CHAR NO-UNDO FORMAT 'X(40)'.
    DEF VAR x-cod-barra AS CHAR NO-UNDO FORMAT 'X(15)'.
    DEF VAR x-desmat  AS CHAR NO-UNDO FORMAT 'X(30)'.
    DEF VAR x-desmat2 AS CHAR NO-UNDO FORMAT 'X(20)'.
    DEF VAR x-desmar  AS CHAR NO-UNDO FORMAT 'X(30)'.
    DEF VAR x-preuni  AS CHAR NO-UNDO FORMAT 'X(12)'.
    DEF VAR x-prec-ean14  AS CHAR NO-UNDO FORMAT 'X(40)'.

    /* */
    DEFINE VAR s-CodMon AS INT INIT 1.
    DEFINE VAR f-Factor AS DEC INIT 1.
    DEFINE VAR s-FlgSit AS CHAR.
    DEFINE VAR s-NroDec AS DEC INIT 4.
    DEFINE VAR x-canped AS DEC INIT 1.
    DEFINE VAR x-implin AS DEC.

    DEFINE VAR f-PreBas AS DEC.
    DEFINE VAR f-PreVta AS DEC.
    DEFINE VAR f-Dsctos AS DEC.
    DEFINE VAR y-Dsctos AS DEC.
    DEFINE VAR x-TipDto AS CHAR.
    DEFINE VAR f-FleteUnitario AS DEC.

    DEFINE VAR lMask AS CHAR.
    DEFINE VAR x-precio-1 AS CHAR.
    DEFINE VAR x-precio-2 AS CHAR.
    DEFINE VAR lprecio AS DEC.

    /* --- */
    RUN Carga-Articulos.

    FIND FIRST tt-articulos NO-LOCK NO-ERROR.

    IF NOT AVAILABLE tt-articulos THEN RETURN.

    DEFINE VAR s-CodCli AS CHAR.
    DEFINE VAR x-papel AS LOG.
    
    x-papel = YES.

    IF x-papel = YES THEN DO:
        DEF VAR rpta AS LOG.
        SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
        IF rpta = NO THEN RETURN.
        OUTPUT STREAM REPORTE TO PRINTER.
    END.
    ELSE DO:
        DEFINE VAR x-file-zpl AS CHAR.
    
        x-file-zpl = session:temp-directory + "pruebas.txt".
    
        OUTPUT STREAM REPORTE TO VALUE(x-file-zpl).
    END.
    
    FOR EACH tt-articulos NO-LOCK:

        s-CodMon = 1.
        f-Factor = 1.
        s-FlgSit = "".
        s-NroDec = 4.
        x-canped = 1.
        x-implin = 0.
        s-FlgSit = ''.
        x-precio-1 = "".
        x-precio-2 = "".

        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
            AND trim(almmmatg.codmat) = trim(t-codmat) NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almmmatg THEN DO:
            FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
                AND trim(almmmatg.codbrr) = trim(t-codmat) NO-LOCK NO-ERROR.
        END.

        IF NOT AVAILABLE almmmatg THEN NEXT.

        ASSIGN 
            x-DesMat  = TRIM(SUBSTRING(Almmmatg.Desmat,1,30))
            x-DesMat2 = TRIM(SUBSTRING(Almmmatg.Desmat,31))
            x-DesMar  = SUBSTRING(Almmmatg.Desmar,1,18).

        s-CodCli = "11111111111".
        
        IF radio-set-formato = 2 THEN DO:
            /* Precio A */
            IF NOT (TRUE <> (almmmatg.undA > "")) THEN DO:
                    RUN pri/PrecioVentaMayorContado (s-CodCia,
                                                   s-CodDiv,
                                                   s-CodCli,
                                                   s-CodMon,
                                                   almmmatg.tpocmb,
                                                   OUTPUT f-Factor,
                                                   almmmatg.codmat,
                                                   s-FlgSit,
                                                   almmmatg.undA,
                                                   x-canped,
                                                   s-NroDec,
                                                   s-codalm,   /* Necesario para REMATES */
                                                   OUTPUT f-PreBas,
                                                   OUTPUT f-PreVta,
                                                   OUTPUT f-Dsctos,     /* DSCTO Clasfi Cliente, CondVta */
                                                   OUTPUT y-Dsctos,     /* DSCTO PROMOCIONAL o VOLUMEN  */
                                                   OUTPUT x-TipDto,     /* PROM o VOL */
                                                   OUTPUT f-FleteUnitario
                                                   ).


                    x-implin = ROUND((x-canped * f-PreVta ) * (1 - f-Dsctos / 100),2).
                    x-PreUni  = 'S/.' + STRING(x-implin,'>>>9.99').
                    x-precio-2 = x-preUni.

                    IF x-TipDto = "PROM" THEN DO:
                        x-precio-1 = x-preUni.
                        x-implin = ROUND((x-canped * f-PreVta ) * (1 - f-Dsctos / 100) * ( 1 - y-dsctos / 100) ,2). 
                        x-PreUni  = 'S/.' + STRING(x-implin,'>>>9.99').
                        x-precio-2 = x-preUni.
                    END.

                    /*x-implin = ROUND((x-canped * f-PreVta ) * (1 - f-Dsctos / 100) * ( 1 - y-dsctos / 100) ,2). */

                    /*  */
                    FIND FIRST Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                                AND Almtconv.Codalter = almmmatg.undA NO-LOCK NO-ERROR.
                    IF AVAILABLE almtconv THEN DO:    
                        /*
                        x-PreUni  = 'S/.' + STRING(x-implin,'>>>9.99').
                        RUN ue-mask(INPUT almtconv.equival, OUTPUT lMask).
                        x-precio-1 = x-PreUni + "  x  " + STRING(almtconv.equival,lMask) + " " + almmmatg.undbas.
                        */
                    END.

                    RUN imprimir-vinetas-formato-01(INPUT almmmatg.codmat,
                                                    INPUT almmmatg.codbrr,
                                                    INPUT x-DesMat,
                                                    INPUT x-DesMat2,
                                                    INPUT x-desmar,
                                                    INPUT x-precio-1,
                                                    INPUT x-precio-2).
            END.
            /*
            DEFINE INPUT PARAMETER pCodigoArticulo AS CHAR NO-UNDO.
            DEFINE INPUT PARAMETER pCodigoBarraEAN13 AS CHAR NO-UNDO.
            DEFINE INPUT PARAMETER pDescripcion AS CHAR NO-UNDO.
            DEFINE INPUT PARAMETER pDescripcion2 AS CHAR NO-UNDO.
            DEFINE INPUT PARAMETER pMarca AS CHAR NO-UNDO.
            DEFINE INPUT PARAMETER pPrecioAntiguo AS CHAR NO-UNDO.
            DEFINE INPUT PARAMETER pPrecio AS CHAR NO-UNDO.
            */

            /* El siguiente Registro */
            NEXT.
        END.

        IF NOT (TRUE <> (almmmatg.undB > "")) THEN DO:
                RUN pri/PrecioVentaMayorContado (s-CodCia,
                                               s-CodDiv,
                                               s-CodCli,
                                               s-CodMon,
                                               almmmatg.tpocmb,
                                               OUTPUT f-Factor,
                                               almmmatg.codmat,
                                               s-FlgSit,
                                               almmmatg.undB,
                                               x-canped,
                                               s-NroDec,
                                               s-codalm,   /* Necesario para REMATES */
                                               OUTPUT f-PreBas,
                                               OUTPUT f-PreVta,
                                               OUTPUT f-Dsctos,
                                               OUTPUT y-Dsctos,
                                               OUTPUT x-TipDto,
                                               OUTPUT f-FleteUnitario
                                               ).
                x-implin = ROUND((x-canped * f-PreVta ) * (1 - f-Dsctos / 100) * ( 1 - y-dsctos / 100) ,2). 

                x-implin = x-implin + (x-canped * f-FleteUnitario).
            /*  */
            FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                AND Almtconv.Codalter = almmmatg.undB
                NO-LOCK NO-ERROR.
            IF AVAILABLE almtconv THEN DO:    

                x-PreUni  = 'S/.' + STRING(x-implin,'>>>9.99').
                RUN ue-mask(INPUT almtconv.equival, OUTPUT lMask).
                x-precio-1 = x-PreUni + "  x  " + STRING(almtconv.equival,lMask) + " " + almmmatg.undbas.

            END.
        END.
        /**/
        IF almmmatg.codfam = '013' THEN DO:
            /* x Volumen */
            x-canped = almmmatg.dtovolr[1].

            RUN pri/PrecioVentaMayorContado (s-CodCia,
                                           s-CodDiv,
                                           s-CodCli,
                                           s-CodMon,
                                           almmmatg.tpocmb,
                                           OUTPUT f-Factor,
                                           almmmatg.codmat,
                                           s-FlgSit,
                                           almmmatg.undbas,
                                           x-canped,
                                           s-NroDec,
                                           s-codalm,   /* Necesario para REMATES */
                                           OUTPUT f-PreBas,
                                           OUTPUT f-PreVta,
                                           OUTPUT f-Dsctos,
                                           OUTPUT y-Dsctos,
                                           OUTPUT x-TipDto,
                                           OUTPUT f-FleteUnitario
                                           ).
            x-implin = ROUND((x-canped * f-PreVta ) * (1 - f-Dsctos / 100) * ( 1 - y-dsctos / 100) ,2). 

            x-implin = x-implin + (x-canped * f-FleteUnitario).

            x-PreUni  = 'S/.' + STRING(x-implin,'>>>9.99').
            RUN ue-mask(INPUT x-canped, OUTPUT lMask).
            x-precio-2 = x-PreUni + "  x  " + STRING(x-canped,lMask) + " " + almmmatg.undbas + " (*)".

        END.
        ELSE DO:
            IF NOT (TRUE <> (almmmatg.undC > "")) THEN DO:
                    s-FlgSit = "".
                    x-canped = 1.

                    RUN pri/PrecioVentaMayorContado (s-CodCia,
                                                   s-CodDiv,
                                                   s-CodCli,
                                                   s-CodMon,
                                                   almmmatg.tpocmb,
                                                   OUTPUT f-Factor,
                                                   almmmatg.codmat,
                                                   s-FlgSit,
                                                   almmmatg.undC,
                                                   x-canped,
                                                   s-NroDec,
                                                   s-codalm,   /* Necesario para REMATES */
                                                   OUTPUT f-PreBas,
                                                   OUTPUT f-PreVta,
                                                   OUTPUT f-Dsctos,
                                                   OUTPUT y-Dsctos,
                                                   OUTPUT x-TipDto,
                                                   OUTPUT f-FleteUnitario
                                                   ).

                    x-implin = ROUND((x-canped * f-PreVta ) * (1 - f-Dsctos / 100) * ( 1 - y-dsctos / 100) ,2). 

                    x-implin = x-implin + (x-canped * f-FleteUnitario).
                /*  */
                FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                    AND Almtconv.Codalter = almmmatg.undC
                    NO-LOCK NO-ERROR.
                IF AVAILABLE almtconv THEN DO:    

                    x-PreUni  = 'S/.' + STRING(x-implin,'>>>9.99').
                    RUN ue-mask(INPUT almtconv.equival, OUTPUT lMask).
                    x-precio-1 = x-PreUni + "  x  " + STRING(almtconv.equival,lMask) + " " + almmmatg.undbas.

                END.

            END.
        END.
        
        /**/
        PUT STREAM REPORTE '^XA^LH50,012'               SKIP.   /* Inicia formato */
        {vta2/vineta-precios-mayorista.i}
        PUT STREAM REPORTE '^PQ' + TRIM(STRING(1)) SKIP.  /* Cantidad a imprimir */
        PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
        PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */           

    END.

    OUTPUT STREAM reporte CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir-vinetas-formato-01 W-Win 
PROCEDURE imprimir-vinetas-formato-01 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodigoArticulo AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pCodigoBarraEAN13 AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pDescripcion AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pDescripcion2 AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pMarca AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pPrecioAntiguo AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pPrecio AS CHAR NO-UNDO.

DEFINE VAR x-fecha AS CHAR.

x-fecha = STRING(TODAY,"99/99/9999").

PUT STREAM REPORTE '^XA^LH50,012'               SKIP.   /* Inicia formato */

PUT STREAM REPORTE '^FO0,0'                             SKIP.   /* Coordenadas de origen campo1 */
PUT STREAM REPORTE '^A0N,35,30'                         SKIP.
PUT STREAM REPORTE '^FD'.
PUT STREAM REPORTE pDescripcion  FORMAT 'x(30)'                          SKIP.
PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

PUT STREAM REPORTE '^FO0,30'                             SKIP.   /* Coordenadas de origen campo1 */
PUT STREAM REPORTE '^A0N,35,30'                         SKIP.
PUT STREAM REPORTE '^FD'.
PUT STREAM REPORTE pDescripcion2 FORMAT 'x(30)'                           SKIP.
PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

PUT STREAM REPORTE '^FO0,60'                            SKIP.   /* Coordenadas de origen campo1 */
PUT STREAM REPORTE '^A0N,30,25'                         SKIP.
PUT STREAM REPORTE '^FD'.
PUT STREAM REPORTE pMarca                             SKIP.
PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

PUT STREAM REPORTE '^FO20,140'                          SKIP.   /* Coordenadas de origen barras */
IF pCodigoBarraEAN13 <> '' THEN DO:
    PUT STREAM REPORTE '^BEN,35'                        SKIP.
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE pCodigoBarraEAN13 FORMAT 'x(13)'   SKIP.
END.
ELSE DO:
    PUT STREAM REPORTE '^BCN,35,Y,N,N'                  SKIP.   /* Codigo 128 */
    PUT STREAM REPORTE '^FD'.
    PUT STREAM REPORTE pCodigoArticulo FORMAT 'x(6)'    SKIP.
END.
PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

PUT STREAM REPORTE '^FO250,65'                         SKIP.   /* Coordenadas de origen */
PUT STREAM REPORTE '^A0N,25,25'                         SKIP.   /* Coordenada de impresion */
PUT STREAM REPORTE '^FD'.
PUT STREAM REPORTE pPrecioAntiguo  FORMAT 'X(20)'             SKIP.   /* Descripcion */
PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

PUT STREAM REPORTE '^FO140,90'                         SKIP.   /* Coordenadas de origen */
PUT STREAM REPORTE '^A0n,70,80'                         SKIP.   /* Coordenada de impresion */
PUT STREAM REPORTE '^FD'.
PUT STREAM REPORTE pPrecio  FORMAT 'X(12)'             SKIP.   /* Descripcion */
PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

/*Fecha*/
PUT STREAM REPORTE '^FO450,30'                          SKIP.   /* Coordenadas de origen barras */
PUT STREAM REPORTE '^A0R,20,20'                         SKIP.   /* Coordenada de impresion */
PUT STREAM REPORTE '^FD'.
PUT STREAM REPORTE x-fecha FORMAT 'x(10)'           SKIP.   /* Descripcion */
PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

/*Impresion Codigo Interno*/
PUT STREAM REPORTE '^FO450,130'                          SKIP.   /* Coordenadas de origen barras */
PUT STREAM REPORTE '^A0R,20,20'                         SKIP.   /* Coordenada de impresion */
PUT STREAM REPORTE '^FD'.
PUT STREAM REPORTE pCodigoArticulo  FORMAT '999999'     SKIP.   /* Descripcion */
PUT STREAM REPORTE '^FS'                                SKIP.   /* Fin de Campo1 */

PUT STREAM REPORTE '^PQ' + TRIM(STRING(1)) SKIP.  /* Cantidad a imprimir */
PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */           


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
  /*
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN 
          x-desde = TODAY
          x-hasta = TODAY.
  END.
  */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proceso-x-Vol W-Win 
PROCEDURE proceso-x-Vol :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*DEFINE VAR s-task-no AS INT.*/
DEFINE VAR lSec AS INT.
DEFINE VAR lTope AS INT.
DEFINE VAR lRegistros AS INT.
DEFINE VAR lprecio AS DEC.

RUN Carga-Articulos.

DEF VAR rpta AS LOG.
SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.

OUTPUT STREAM REPORTE TO PRINTER.

REPEAT:
    s-task-no = RANDOM(1, 999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no
                    AND w-report.llave-c = s-user-id NO-LOCK)
        THEN DO:
        /*
        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no.
        */
        LEAVE.
    END.
END.

FOR EACH tt-articulos NO-LOCK:

    FIND w-report WHERE task-no = s-task-no AND llave-c = t-codmat NO-ERROR.
    FIND FIRST almmmatg WHERE codcia = s-codcia AND codmat = t-codmat NO-LOCK NO-ERROR.

    IF NOT AVAILABLE w-report AND AVAILABLE almmmatg THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no
            w-report.llave-c = t-codmat
            w-report.campo-c[1] = almmmatg.desmat.
            w-report.campo-c[2] = almmmatg.desmar.
            w-report.campo-c[3] = almmmatg.undA.

        lTope = IF (tt-articulos.t-cuantos = 0) THEN 10 ELSE tt-articulos.t-cuantos.
        
        REPEAT lsec = 1 TO 10:
            IF almmmatg.dtovolr[lsec] > 0 THEN DO:
                IF lSec <= lTope THEN DO:
                    lprecio = almmmatg.prevta[1].
                    IF almmmatg.monvta = 2 THEN DO:
                        lprecio = lprecio * almmmatg.tpocmb.
                    END.
                    lprecio = ROUND(( 1 - (almmmatg.dtovold[lsec] / 100)) * lPrecio , 4).


                    /*
                    w-report.campo-i[lsec] = almmmatg.dtovolr[lsec].
                    w-report.campo-f[lsec] = lPrecio.
                    */

                    w-report.campo-c[10 + lSec] = string(almmmatg.dtovolr[lsec],">>,>>9").
                    w-report.campo-c[20 + lSec] = string(lPrecio,">>,>>9.9999").
                END.
                ELSE DO: 
                    w-report.campo-c[5] = "A mayor cantidad consultar con el Administrador".
                    LEAVE.
                END.                    
            END.
        END.            
    END.
END.
/*
FOR EACH w-report WHERE w-report.task-no = s-task-no :
    REPEAT lsec = 1 TO lTope :
        DISPLAY w-report.campo-c[1] w-report.campo-i[lsec] w-report.campo-f[lsec].
    END.
END.
*/

FIND FIRST tt-articulos NO-LOCK NO-ERROR.
IF AVAILABLE tt-articulos THEN DO:
    RUN impresion-x-vol.
END.

DEF BUFFER B-w-report FOR w-report.
DEFINE VAR lRowId AS ROWID.

FOR EACH w-report WHERE w-report.task-no = s-task-no NO-LOCK:
    lRowId = ROWID(w-report).
    FIND FIRST b-w-report WHERE ROWID(b-w-report) = lRowid EXCLUSIVE NO-ERROR.
    IF AVAILABLE b-w-report THEN DO:
        DELETE b-w-report.            
    END.    
END.
RELEASE B-w-report.

OUTPUT STREAM REPORTE CLOSE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-mask W-Win 
PROCEDURE ue-mask :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-Valor AS DEC    NO-UNDO.
DEFINE OUTPUT PARAMETER p-mask AS CHAR    NO-UNDO.

IF (TRUNCATE(p-Valor,0) - p-Valor) <> 0  THEN DO:
    p-mask = ">>9.99".
END.
ELSE DO:
    p-mask = ">>>9".
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

