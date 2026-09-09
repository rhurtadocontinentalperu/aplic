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

DEF VAR x-desmat  AS CHAR NO-UNDO FORMAT 'X(30)'.
DEF VAR x-desmat2 AS CHAR NO-UNDO FORMAT 'X(20)'.
DEF VAR x-desmar  AS CHAR NO-UNDO FORMAT 'X(30)'.
DEF VAR x-preuni  AS CHAR NO-UNDO FORMAT 'X(12)'.
DEF VAR x-dtovol  AS CHAR NO-UNDO FORMAT 'X(40)'.
DEF VAR x-dtovo2  AS CHAR NO-UNDO FORMAT 'X(40)'.
DEF VAR cNotita   AS CHAR NO-UNDO FORMAT 'X(35)'.

DEFINE TEMP-TABLE tt-articulos 
    FIELDS t-codmat LIKE almmmatg.codmat.

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
rs-modimp x-desde x-hasta rs-tipo btn-print BUTTON-8 TOGGLE-Promocional 
&Scoped-Define DISPLAYED-OBJECTS fill-in-codmat FILL-IN-file rs-modimp ~
x-desde x-hasta rs-tipo TOGGLE-Promocional 

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

DEFINE VARIABLE x-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE x-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE rs-modimp AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Cod Internos", 1,
"Cod EAN 13", 2
     SIZE 27 BY .81 NO-UNDO.

DEFINE VARIABLE rs-tipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Por Lista", 1,
"Por Fechas", 2
     SIZE 23 BY 1 NO-UNDO.

DEFINE VARIABLE TOGGLE-Promocional AS LOGICAL INITIAL yes 
     LABEL "Considerar Descuento Promocional" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     fill-in-codmat AT ROW 2.88 COL 8 COLON-ALIGNED WIDGET-ID 20
     BUTTON-5 AT ROW 3.77 COL 52.86 WIDGET-ID 66
     FILL-IN-file AT ROW 3.85 COL 8 COLON-ALIGNED WIDGET-ID 68
     rs-modimp AT ROW 4.96 COL 10 NO-LABEL WIDGET-ID 80
     x-desde AT ROW 5.85 COL 8 COLON-ALIGNED WIDGET-ID 70
     x-hasta AT ROW 5.85 COL 28 COLON-ALIGNED WIDGET-ID 72
     rs-tipo AT ROW 6.92 COL 10 NO-LABEL WIDGET-ID 74
     btn-print AT ROW 8.27 COL 42 WIDGET-ID 4
     BUTTON-8 AT ROW 8.27 COL 51 WIDGET-ID 18
     TOGGLE-Promocional AT ROW 8.31 COL 10 WIDGET-ID 84
     "Impresión de Etiquetas Precios Chiclayo" VIEW-AS TEXT
          SIZE 45 BY .81 AT ROW 1.54 COL 3 WIDGET-ID 12
          FGCOLOR 7 FONT 13
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 61.14 BY 9.69
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
         TITLE              = "ETIQUETAS CONTINENTAL"
         HEIGHT             = 9.69
         WIDTH              = 61.14
         MAX-HEIGHT         = 9.69
         MAX-WIDTH          = 61.14
         VIRTUAL-HEIGHT     = 9.69
         VIRTUAL-WIDTH      = 61.14
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ETIQUETAS CONTINENTAL */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ETIQUETAS CONTINENTAL */
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
        fill-in-codmat FILL-IN-file x-desde x-hasta rs-tipo rs-modimp TOGGLE-Promocional.
    RUN Imprime-Etiqueta3.
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
            "Archivos Excel (*.csv)" "*.csv",
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

    CASE rs-tipo:
        WHEN 1 THEN DO:
            /* Carga de Excel */
            IF SEARCH(FILL-IN-file) <> ? THEN DO:
                OUTPUT TO VALUE(FILL-IN-file) APPEND.
                PUT UNFORMATTED "?" CHR(10) SKIP.
                OUTPUT CLOSE.
                INPUT FROM VALUE(FILL-IN-file).
                REPEAT:
                    CREATE tt-articulos.
                    IMPORT t-codmat.
                    IF t-codmat = '' THEN ASSIGN t-codmat = "?".        
                END.
                INPUT CLOSE.
            END.
        END.
        WHEN 2 THEN DO:            
            FOR EACH vtalistamin WHERE vtalistamin.codcia = s-codcia
                AND vtalistamin.coddiv = s-coddiv
                AND vtalistamin.fchact >= x-desde
                AND vtalistamin.fchact <= x-hasta NO-LOCK:
                CREATE tt-articulos.
                ASSIGN tt-articulos.t-codmat = vtalistamin.codmat.
            END.
        END.
    END CASE.

    FOR EACH tt-articulos:
        IF t-codmat = '' THEN DELETE tt-articulos.
    END.
    
    FIND FIRST tt-articulos NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-articulos THEN DO:
        CREATE tt-articulos.        
        ASSIGN t-codmat = fill-in-codmat.
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
  DISPLAY fill-in-codmat FILL-IN-file rs-modimp x-desde x-hasta rs-tipo 
          TOGGLE-Promocional 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE fill-in-codmat BUTTON-5 FILL-IN-file rs-modimp x-desde x-hasta rs-tipo 
         btn-print BUTTON-8 TOGGLE-Promocional 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Etiqueta2 W-Win 
PROCEDURE Imprime-Etiqueta2 :
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

DEFINE VARIABLE lEmpqPres  AS DECIMAL.
DEFINE VARIABLE lSec AS INT.
DEFINE VARIABLE lEscala AS INT.

DEFINE VAR f-factor AS DEC.
DEFINE VAR f-PreBas AS DEC.
DEFINE VAR f-PreVta AS DEC.
DEFINE VAR f-Dsctos AS DEC.
DEFINE VAR y-Dsctos AS DEC.
DEFINE VAR  x-TipDto AS CHAR.
DEFINE VAR f-FleteUnitario AS DEC.

DEFINE VAR lQtyPrecioA AS DEC.
DEFINE VAR lPrecioVenta_und AS DEC.
DEFINE VAR lPrecioVenta_undA AS DEC.
DEFINE VAR lPrecioVenta_undB AS DEC.
DEFINE VAR lPrecioVenta_undC AS DEC.
DEFINE VAR lPrecio_undA AS DEC.
DEFINE VAR lPrecio_undB AS DEC.
DEFINE VAR lPrecio_undC AS DEC.
DEFINE VAR lQty_undA AS DEC.
DEFINE VAR lQty_undB AS DEC.
DEFINE VAR lQty_undC AS DEC.

DEFINE VAR lUnidadVenta_und AS CHAR.
DEFINE VAR lUnidadVenta_undA AS CHAR.
DEFINE VAR lUnidadVenta_undB AS CHAR.
DEFINE VAR lUnidadVenta_undC AS CHAR.

    
lEmpqPres = 0.

RUN Carga-Articulos.

DEF VAR rpta AS LOG.
SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.

OUTPUT STREAM REPORTE TO PRINTER.
FOR EACH tt-articulos NO-LOCK:
    CASE rs-modimp:
        WHEN 1 THEN DO:
            FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
                AND trim(almmmatg.codmat) = trim(t-codmat) NO-LOCK NO-ERROR.
        END.
        WHEN 2 THEN DO:
            FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
                AND trim(almmmatg.codbrr) = trim(t-codmat) NO-LOCK NO-ERROR.
        END.
    END CASE.
    IF AVAIL almmmatg THEN DO:
        ASSIGN
            x-DtoVol = ''
            x-Dtovo2 = ''
            dPrecio  = 0
            cNotita  = ''.

        lPrecioVenta_undA = 0.00.
        lPrecioVenta_undB = 0.00.
        lPrecioVenta_undC = 0.00.
        lPrecioVenta_und = 0.00.
        lQtyPrecioA = 0.00.
        lPrecio_undA = 0.00.
        lPrecio_undB = 0.00.
        lPrecio_undC = 0.00.
        
        lUnidadVenta_undA = "".
        lUnidadVenta_undB = "".
        lUnidadVenta_undC = "".
        lUnidadVenta_und = "".


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
            lPrecioVenta_undA = f-PreVta + f-FleteUnitario.
            dPreuni = f-PreVta + f-FleteUnitario.
            lPrecioVenta_undA = dPreuni.

            /* Venta Unidad A  */
            FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                AND Almtconv.Codalter = almmmatg.undA
                NO-LOCK NO-ERROR.
            IF AVAILABLE almtconv THEN DO:
                /*lUnidadVenta_undA = " x " + STRING(almtconv.equival).*/
                IF almtconv.equival > almmmatg.pesobruto THEN DO:
                    lUnidadVenta_undA = 'S/.  ' + STRING(lPrecioVenta_undA,'>>>9.99') + "  x  " + STRING(almtconv.equival) + " " + almmmatg.undbas.
                END.                
                lQty_undA = almtconv.equival.
                lPrecio_undA = lPrecioVenta_undA / almtconv.equival. 
            END.
        
            IF almmmatg.undB <> ? AND almmmatg.undB <> "" THEN DO:
        
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
                lPrecioVenta_undB = f-PreVta + f-FleteUnitario.
        
                FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                    AND Almtconv.Codalter = almmmatg.undB
                    NO-LOCK NO-ERROR.
                IF AVAILABLE almtconv THEN DO:    
                    IF almtconv.equival > almmmatg.pesobruto THEN DO:
                        lUnidadVenta_undB = 'S/.  ' + STRING(lPrecioVenta_undB,'>>>9.99') + "  x  " + STRING(almtconv.equival) + " " + almmmatg.undBas.
                    END.                    
                    lPrecio_undB = lPrecioVenta_undB / almtconv.equival.
                    lQty_undB = almtconv.equival.
                END.
                /*MESSAGE lUnidadVenta_undB.*/
            END.
        
            IF almmmatg.undC <> ? AND almmmatg.undC <> "" THEN DO:
        
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
                lPrecioVenta_undC = f-PreVta + f-FleteUnitario.

                FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                    AND Almtconv.Codalter = almmmatg.undC
                    NO-LOCK NO-ERROR.
                IF AVAILABLE almtconv THEN DO:
                    IF almtconv.equival > almmmatg.pesobruto THEN DO:
                        lUnidadVenta_undC = 'S/.  ' + STRING(lPrecioVenta_undC,'>>>9.99') + "  x  " + STRING(almtconv.equival) + " " + almmmatg.undbas.
                    END.                    
                    lPrecio_undC = lPrecioVenta_undC / almtconv.equival.
                    lQty_undC = almtconv.equival.
                END.               
                /*MESSAGE lUnidadVenta_undC.*/

            END.
            /*****************************************************/
            /* Precio por presentacion de unidad minima */
            /*
            dPreuni = 0.00.
            lPrecioVenta_und = 0.00.
            IF lPrecio_undC > 0 THEN DO:
                IF (almmmatg.pesobruto / lQty_undC) >= 0.25 THEN DO:
                    lPrecioVenta_und = lPrecio_undC * almmmatg.pesobruto.
                END.
            END.
            IF lPrecioVenta_und <= 0 AND lPrecio_undB > 0 THEN DO:
                IF (almmmatg.pesobruto / lQty_undB) >= 0.25 THEN DO:
                    lPrecioVenta_und = lPrecio_undB * almmmatg.pesobruto.
                END.
            END.
            IF lPrecioVenta_und <= 0 AND lPrecio_undA > 0 THEN DO:
                IF (almmmatg.pesobruto / lQty_undA) >= 0.25 THEN DO:
                    lPrecioVenta_und = lPrecio_undA * almmmatg.pesobruto.
                END.
            END.
            dPreuni = lPrecioVenta_und.
            lUnidadVenta_und = " x " + STRING(almmmatg.pesobruto).            
            */
            /****************************************************/

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
                                           almmmatg.CHR__01,
                                           IF (almmmatg.pesobruto <= 0) THEN 1 ELSE almmmatg.pesobruto,
                                           4,
                                           s-codalm,   /* Necesario para REMATES */
                                           OUTPUT f-PreBas,
                                           OUTPUT f-PreVta,
                                           OUTPUT f-Dsctos,
                                           OUTPUT y-Dsctos,
                                           OUTPUT x-TipDto,
                                           OUTPUT f-FleteUnitario
                                           ).
            /*lPrecioVenta_undB = f-PreVta + f-FleteUnitario.*/
            lPrecioVenta_und = f-PreVta + f-FleteUnitario.
            dPreuni = lPrecioVenta_und * almmmatg.pesobruto.
            lUnidadVenta_und = " x " + STRING(almmmatg.pesobruto).            
            /*
            IF truncate(lPrecio_undA,0) = truncate(lPrecio_undB,0) AND TRUNCATE(lPrecio_undB,0) = truncate(lPrecio_undC,0) THEN DO:
                lUnidadVenta_undB = "".
                lUnidadVenta_undC = "".
            END.
            ELSE DO:
                IF truncate(lPrecio_undA,0) = truncate(lPrecio_undB,0) THEN DO:
                    lUnidadVenta_undB = "".
                END.
                ELSE DO:
                    IF truncate(lPrecio_undB,0) = truncate(lPrecio_undC,0) THEN DO:
                        lUnidadVenta_undC = "".
                    END.
                END.
            END.
            */
            ASSIGN 
                    /*x-DesMat  = TRIM(SUBSTRING(Almmmatg.Desmat,1,30))*/
                    x-DesMat  = TRIM(SUBSTRING(Almmmatg.Desmat,1,45))
                    x-DesMat2 = TRIM(SUBSTRING(Almmmatg.Desmat,31))
                    x-DesMar  = SUBSTRING(Almmmatg.Desmar,1,30)
                    x-PreUni  = 'S/.' + STRING(dPreUni,'>>>9.99').                        



                /*PUT STREAM REPORTE '^LH210,012'                  SKIP.   /* Inicia formato */*/
                PUT STREAM REPORTE '^XA^LH50,012'               SKIP.   /* Inicia formato */
                {alm/eti-gondolas02-01-chiclayo.i}

                PUT STREAM REPORTE '^PQ' + TRIM(STRING(1)) SKIP.  /* Cantidad a imprimir */
                PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
                PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */
        
        END.
    END.
END.

OUTPUT STREAM reporte CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Etiqueta3 W-Win 
PROCEDURE Imprime-Etiqueta3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       INCLUYE DESCUENTO PROMOCIONAL
------------------------------------------------------------------------------*/

DEFINE VARIABLE dPreUni  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dDsctos  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dDstoVo1 AS DECIMAL     .
DEFINE VARIABLE dDstoVo2 AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dPrecio  AS DECIMAL     NO-UNDO.

DEFINE VARIABLE lEmpqPres  AS DECIMAL.
DEFINE VARIABLE lSec AS INT.
DEFINE VARIABLE lEscala AS INT.

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

DEFINE VAR lQtyPrecioA AS DEC.
DEFINE VAR lPrecioVenta_und AS DEC.
DEFINE VAR lPrecioVenta_undA AS DEC.
DEFINE VAR lPrecioVenta_undB AS DEC.
DEFINE VAR lPrecioVenta_undC AS DEC.
DEFINE VAR lPrecio_undA AS DEC.
DEFINE VAR lPrecio_undB AS DEC.
DEFINE VAR lPrecio_undC AS DEC.
DEFINE VAR lQty_undA AS DEC.
DEFINE VAR lQty_undB AS DEC.
DEFINE VAR lQty_undC AS DEC.

DEFINE VAR lUnidadVenta_und AS CHAR.
DEFINE VAR lUnidadVenta_undA AS CHAR.
DEFINE VAR lUnidadVenta_undB AS CHAR.
DEFINE VAR lUnidadVenta_undC AS CHAR.

    
lEmpqPres = 0.

RUN Carga-Articulos.
DEF VAR rpta AS LOG.
SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.
OUTPUT STREAM REPORTE TO PRINTER.
FOR EACH tt-articulos NO-LOCK:
    CASE rs-modimp:
        WHEN 1 THEN DO:
            FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
                AND trim(almmmatg.codmat) = trim(t-codmat) NO-LOCK NO-ERROR.
        END.
        WHEN 2 THEN DO:
            FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
                AND trim(almmmatg.codbrr) = trim(t-codmat) NO-LOCK NO-ERROR.
        END.
    END CASE.
    IF NOT AVAILABLE almmmatg THEN NEXT.

    ASSIGN
        Y-DSCTOS = 0
        x-DtoVol = ''
        x-Dtovo2 = ''
        dPrecio  = 0
        cNotita  = ''.
    lPrecioVenta_undA = 0.00.
    lPrecioVenta_undB = 0.00.
    lPrecioVenta_undC = 0.00.
    lPrecioVenta_und = 0.00.
    lQtyPrecioA = 0.00.
    lPrecio_undA = 0.00.
    lPrecio_undB = 0.00.
    lPrecio_undC = 0.00.
    
    lUnidadVenta_undA = "".
    lUnidadVenta_undB = "".
    lUnidadVenta_undC = "".
    lUnidadVenta_und = "".

    f-DtoPromocional = 0.
    f-PrePromocional = 0.
    PROMOCIONAL:
    DO:
        /* Definimos el F-PREVTA y f-DtoPromocional */
        IF Almmmatg.CodFam = "011" THEN LEAVE PROMOCIONAL.
        IF Almmmatg.CodFam = "013" AND Almmmatg.SubFam <> "014" THEN LEAVE PROMOCIONAL.
        FIND FIRST VtaTabla WHERE VtaTabla.codcia = Almmmatg.codcia
            AND VtaTabla.tabla = "DTOPROLIMA"
            AND VtaTabla.llave_c1 = Almmmatg.codmat
            AND VtaTabla.llave_c2 = s-CodDiv
            AND TODAY >= VtaTabla.Rango_Fecha[1]
            AND TODAY <= VtaTabla.Rango_Fecha[2]
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaTabla THEN DO:
            ASSIGN
                F-PREVTA = Almmmatg.Prevta[1]
                f-DtoPromocional = VtaTabla.Valor[1].
            IF Almmmatg.Monvta = 1 THEN 
              ASSIGN X-PREVTA1 = F-PREVTA
                     X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.TpoCmb,6).
            ELSE
              ASSIGN X-PREVTA2 = F-PREVTA
                     X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.TpoCmb,6).
/*             FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas */
/*                 AND Almtconv.Codalter = s-UndVta                   */
/*                 NO-LOCK NO-ERROR.                                  */
/*             IF AVAILABLE Almtconv                                  */
/*             THEN x-Factor = Almtconv.Equival.                      */
/*             ELSE x-Factor = 1.                                     */
/*             X-PREVTA1 = X-PREVTA1 * X-FACTOR.                      */
/*             X-PREVTA2 = X-PREVTA2 * X-FACTOR.                      */
/*             IF S-CODMON = 1                    */
/*             THEN f-PrePromocional = X-PREVTA1. */
/*             ELSE f-PrePromocional = X-PREVTA2. */
            f-PrePromocional = X-PREVTA1.
        END.
    END.
    IF TOGGLE-Promocional = NO THEN f-DtoPromocional = 0.   /* <<< OJO <<< */
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
        dPreUni = (IF f-DtoPromocional > 0 THEN (f-PrePromocional * f-Factor) ELSE f-PreVta).
        dPreuni = (dPreUni + f-FleteUnitario) * (1 - f-DtoPromocional / 100).
        lPrecioVenta_undA = dPreuni.
        /* Venta Unidad A  */
        FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
            AND Almtconv.Codalter = almmmatg.undA
            NO-LOCK NO-ERROR.
        IF AVAILABLE almtconv THEN DO:
            IF almtconv.equival > almmmatg.pesobruto THEN DO:
                lUnidadVenta_undA = 'S/.  ' + STRING(lPrecioVenta_undA,'>>>9.99') + "  x  " + STRING(almtconv.equival) + " " + almmmatg.undbas.
            END.
            lQty_undA = almtconv.equival.
            lPrecio_undA = lPrecioVenta_undA / almtconv.equival. 
        END.
        IF almmmatg.undB <> ? AND almmmatg.undB <> "" THEN DO:
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
            dPreUni = (IF f-DtoPromocional > 0 THEN (f-PrePromocional * f-Factor) ELSE f-PreVta).
            dPreuni = (dPreUni + f-FleteUnitario) * (1 - f-DtoPromocional / 100).
            lPrecioVenta_undB = dPreuni.
            FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                AND Almtconv.Codalter = almmmatg.undB
                NO-LOCK NO-ERROR.
            IF AVAILABLE almtconv THEN DO:    
                IF almtconv.equival > almmmatg.pesobruto THEN DO:
                    lUnidadVenta_undB = 'S/.  ' + STRING(lPrecioVenta_undB,'>>>9.99') + "  x  " + STRING(almtconv.equival) + " " + almmmatg.undBas.
                END.
                lPrecio_undB = lPrecioVenta_undB / almtconv.equival.
                lQty_undB = almtconv.equival.
            END.
        END.
        IF almmmatg.undC <> ? AND almmmatg.undC <> "" THEN DO:
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
            dPreUni = (IF f-DtoPromocional > 0 THEN (f-PrePromocional * f-Factor) ELSE f-PreVta).
            dPreuni = (dPreUni + f-FleteUnitario) * (1 - f-DtoPromocional / 100).
            lPrecioVenta_undC = dPreuni.
            FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                AND Almtconv.Codalter = almmmatg.undC
                NO-LOCK NO-ERROR.
            IF AVAILABLE almtconv THEN DO:
                IF almtconv.equival > almmmatg.pesobruto THEN DO:
                    lUnidadVenta_undC = 'S/.  ' + STRING(lPrecioVenta_undC,'>>>9.99') + "  x  " + STRING(almtconv.equival) + " " + almmmatg.undbas.
                END.
                lPrecio_undC = lPrecioVenta_undC / almtconv.equival.
                lQty_undC = almtconv.equival.
            END.
        END.
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
                                          almmmatg.CHR__01,
                                          (IF almmmatg.pesobruto <= 0 THEN 1 ELSE almmmatg.pesobruto),
                                          4,
                                          s-codalm,   /* Necesario para REMATES */
                                          OUTPUT f-PreBas,
                                          OUTPUT f-PreVta,
                                          OUTPUT f-Dsctos,
                                          OUTPUT y-Dsctos,
                                          OUTPUT x-TipDto,
                                          OUTPUT f-FleteUnitario
                                          ).
        dPreUni = (IF f-DtoPromocional > 0 THEN (f-PrePromocional * f-Factor) ELSE f-PreVta).
        dPreuni = (dPreUni + f-FleteUnitario) * (1 - f-DtoPromocional / 100).
        lPrecioVenta_und = dPreuni.
        dPreuni = lPrecioVenta_und * almmmatg.pesobruto.
        lUnidadVenta_und = " x " + STRING(almmmatg.pesobruto).            
        ASSIGN 
            x-DesMat  = TRIM(SUBSTRING(Almmmatg.Desmat,1,45))
            x-DesMat2 = TRIM(SUBSTRING(Almmmatg.Desmat,31))
            x-DesMar  = SUBSTRING(Almmmatg.Desmar,1,30)
            x-PreUni  = 'S/.' + STRING(dPreUni,'>>>9.99').                        
        
        PUT STREAM REPORTE '^XA^LH50,012'               SKIP.   /* Inicia formato */
        {alm/eti-gondolas02-01-chiclayo.i}
        PUT STREAM REPORTE '^PQ' + TRIM(STRING(1)) SKIP.  /* Cantidad a imprimir */
        PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
        PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */
    END.
END.

OUTPUT STREAM reporte CLOSE.

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
          x-desde = TODAY
          x-hasta = TODAY.
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

