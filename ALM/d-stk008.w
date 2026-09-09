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

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje FORMAT 'x(30)' NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

DEF TEMP-TABLE DETALLE LIKE Almmmatg
    FIELD StkAct AS DEC
    FIELD StkObs AS DEC
    FIELD ImpTot AS DEC.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-61 RECT-59 RECT-58 RECT-60 DesdeC ~
HastaC COMBO-BOX-Dias RADIO-SET-Costo Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS DesdeC HastaC RADIO-SET-Movimiento ~
COMBO-BOX-Dias RADIO-SET-Stock RADIO-SET-Costo 

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

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX-Dias AS INTEGER FORMAT "99":U INITIAL 8 
     LABEL "Hace mas de" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "8","12" 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(9)":U 
     LABEL "Desde el articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(9)":U 
     LABEL "hasta el articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Costo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Promedio", 1,
"Reposicion", 2
     SIZE 31 BY .96 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Movimiento AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Con Movimiento", 1,
"Sin Movimiento", 2
     SIZE 29 BY .96 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Stock AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Con Stock", 1,
"Sin Stock", 2
     SIZE 29 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 80 BY 1.69
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 1.92.

DEFINE RECTANGLE RECT-59
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 1.54.

DEFINE RECTANGLE RECT-60
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 1.35.

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 1.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     DesdeC AT ROW 1.96 COL 15 COLON-ALIGNED
     HastaC AT ROW 1.96 COL 36.86 COLON-ALIGNED
     RADIO-SET-Movimiento AT ROW 3.88 COL 5 NO-LABEL
     COMBO-BOX-Dias AT ROW 3.88 COL 45 COLON-ALIGNED
     RADIO-SET-Stock AT ROW 5.62 COL 5 NO-LABEL
     RADIO-SET-Costo AT ROW 7.15 COL 5 NO-LABEL
     Btn_OK AT ROW 10.35 COL 53.72
     Btn_Cancel AT ROW 10.35 COL 66.14
     RECT-61 AT ROW 6.77 COL 1
     "Meses" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 4.08 COL 54
     RECT-59 AT ROW 3.5 COL 1
     "Rango de Materiales" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 1.19 COL 2
     "Con o sin movimiento" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 3.31 COL 2
     "Con o sin stock" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 5.04 COL 2
     "Valorizacion" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 6.77 COL 2
     RECT-58 AT ROW 1.38 COL 1
     RECT-46 AT ROW 10.23 COL 1
     RECT-60 AT ROW 5.23 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 11.5
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
         TITLE              = "ARTICULOS ACTIVOS CON STOCK Y SIN MOVIMIENTO"
         HEIGHT             = 10.92
         WIDTH              = 80
         MAX-HEIGHT         = 11.5
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 11.5
         VIRTUAL-WIDTH      = 80
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

IF NOT W-Win:LOAD-ICON("img\climnu3":U) THEN
    MESSAGE "Unable to load icon: img\climnu3"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   L-To-R                                                               */
/* SETTINGS FOR RADIO-SET RADIO-SET-Movimiento IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET RADIO-SET-Stock IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ARTICULOS ACTIVOS CON STOCK Y SIN MOVIMIENTO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ARTICULOS ACTIVOS CON STOCK Y SIN MOVIMIENTO */
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


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  ASSIGN 
    DesdeC HastaC COMBO-BOX-Dias RADIO-SET-Movimiento 
        RADIO-SET-Stock RADIO-SET-Costo.
  IF HastaC = "" THEN HastaC = "999999".
  IF DesdeC = ""
  THEN DO:
    FIND FIRST Almmmatg WHERE almmmatg.codcia = s-codcia NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN DesdeC = ALmmmatg.codmat.
  END.
  RUN Imprime.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC W-Win
ON LEAVE OF DesdeC IN FRAME F-Main /* Desde el articulo */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC W-Win
ON LEAVE OF HastaC IN FRAME F-Main /* hasta el articulo */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.  
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
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
  DEF VAR x-StkAct AS DEC NO-UNDO.
  DEF VAR x-StkObs AS DEC NO-UNDO.
  DEF VAR x-FchDoc AS DATE NO-UNDO.
  DEF VAR x-CtoUni AS DEC NO-UNDO.
  DEF VAR x-AlmOks AS CHAR INIT '03,04,05,83,11,22' NO-UNDO.    /* Alm. Validos */
  DEF VAR x-AlmObs AS CHAR INIT '79,03B,04B,05B,83B' NO-UNDO.   /* Alm. Obsoletos */

  FOR EACH DETALLE:
    DELETE DETALLE.
  END.

  CATALOGO:
  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat >= DesdeC
        AND Almmmatg.codmat <= HastaC
        AND Almmmatg.tpoart <> 'D':
    DISPLAY Almmmatg.codmat @ Fi-Mensaje LABEL "Materiales "
        FORMAT "X(10)" WITH FRAME F-Proceso.
    /* CALCULAMOS EL STOCK */
    x-StkAct = 0.
    FOR EACH Almmmate NO-LOCK WHERE Almmmate.codcia = Almmmatg.codcia
            AND Almmmate.codmat = Almmmatg.codmat
            AND LOOKUP(TRIM(Almmmate.codalm), x-AlmOks) > 0:
        x-StkAct = x-StkAct + Almmmate.StkAct.
    END.
    /* RHC 20.09.04 NO obsoletos Susana Leon
    x-StkObs = 0.
    FOR EACH Almmmate NO-LOCK WHERE Almmmate.codcia = Almmmatg.codcia
            AND Almmmate.codmat = Almmmatg.codmat
            AND LOOKUP(TRIM(Almmmate.codalm), x-AlmObs) > 0:
        x-StkObs = x-StkObs + Almmmate.StkAct.
    END.
    *************************************** */
    CASE RADIO-SET-Stock:
        WHEN 1 THEN DO:         /* Con Stock */
            IF (x-StkAct + x-StkObs) = 0 THEN NEXT CATALOGO.
        END.
        WHEN 2 THEN DO:         /* Sin Stock */
            IF (x-StkAct + x-StkObs) <> 0 THEN NEXT CATALOGO.
        END.
    END CASE.
    /* BUSCAMOS SI TIENE MOVIMIENTOS A PARTIR DE ESA FECHA */
    x-FchDoc = TODAY - ( COMBO-BOX-Dias * 30).
    CASE RADIO-SET-Movimiento:
        WHEN 1 THEN DO:     /* Con Movimiento */
            FIND FIRST Almdmov USE-INDEX ALMD02 WHERE almdmov.codcia = s-codcia
                AND almdmov.codmat = almmmatg.codmat
                AND almdmov.fchdoc < x-FchDoc
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almdmov THEN NEXT CATALOGO.
        END.
        WHEN 2 THEN DO:     /* Sin Movimiento */
            FIND LAST Almdmov USE-INDEX ALMD02 WHERE almdmov.codcia = s-codcia
                AND almdmov.codmat = almmmatg.codmat
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almdmov 
                AND Almdmov.fchdoc >= x-FchDoc THEN NEXT CATALOGO.
        END.
    END CASE.
    
    /* RHC 31.08.04 cambio solicitado por Susana Leon
    x-FchDoc = TODAY - ( COMBO-BOX-Dias * 30).
    IF TOGGLE-1 = NO
    THEN DO:
        FIND FIRST Almdmov USE-INDEX ALMD02 WHERE almdmov.codcia = s-codcia
                AND almdmov.codmat = almmmatg.codmat
                AND almdmov.fchdoc >= x-FchDoc
                NO-LOCK NO-ERROR.
        CASE RADIO-SET-Movimiento:
            WHEN 1 THEN DO:     /* Con Movimiento */
                IF NOT AVAILABLE Almdmov THEN NEXT CATALOGO.
            END.
            WHEN 2 THEN DO:     /* Sin Movimiento */
                IF AVAILABLE Almdmov THEN NEXT CATALOGO.
            END.
        END CASE.
    END.
    ELSE DO:
        FIND FIRST Almdmov USE-INDEX ALMD02 WHERE almdmov.codcia = s-codcia
                AND almdmov.codmat = almmmatg.codmat
                AND almdmov.fchdoc >= x-FchDoc
                NO-LOCK NO-ERROR.
        REPEAT WHILE AVAILABLE Almdmov:
            FIND Almtmov OF Almdmov NO-LOCK NO-ERROR.
            IF Almtmovm.MovTrf = YES
            THEN DO:
                FIND NEXT Almdmov USE-INDEX ALMD02 WHERE almdmov.codcia = s-codcia
                    AND almdmov.codmat = almmmatg.codmat
                    AND almdmov.fchdoc >= x-FchDoc
                    NO-LOCK NO-ERROR.
            END.
            ELSE LEAVE.
        END.
        CASE RADIO-SET-Movimiento:
            WHEN 1 THEN DO:     /* Con Movimiento */
                IF NOT AVAILABLE Almdmov THEN NEXT CATALOGO.
            END.
            WHEN 2 THEN DO:     /* Sin Movimiento */
                IF AVAILABLE Almdmov THEN NEXT CATALOGO.
            END.
        END CASE.
    END.
    */
    /* Costo Unitario */
    ASSIGN
        x-CtoUni = 0.
    CASE RADIO-SET-Costo:
        WHEN 1 THEN DO:
            FIND LAST AlmStkGe WHERE almstkge.codcia = s-codcia
                AND almstkge.codmat = almmmatg.codmat
                AND almstkge.fecha <= TODAY
                NO-LOCK NO-ERROR.
            IF AVAILABLE AlmStkGe THEN x-CtoUni = almstkge.ctouni.
        END.
        WHEN 2 THEN DO:
            x-CtoUni = Almmmatg.CtoLis.
            IF Almmmatg.MonVta = 2
            THEN x-CtoUni = x-CtoUni * Almmmatg.TpoCmb. 
        END.
    END CASE.
    /* GRABAMOS INFORMACION */
    CREATE DETALLE.
    BUFFER-COPY Almmmatg TO DETALLE
        ASSIGN 
            DETALLE.StkAct = x-StkAct
            DETALLE.StkObs = x-StkObs
            DETALLE.CtoLis = x-CtoUni
            DETALLE.ImpTot = (x-StkAct + x-StkObs) * x-CtoUni
            DETALLE.FchAct = ?.
    /* Buscamos el ultimo movimiento */
    FIND LAST almdmov USE-INDEX ALMD02 WHERE almdmov.codcia = s-codcia
        AND almdmov.codmat = Almmmatg.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE Almdmov THEN DETALLE.FchAct = Almdmov.fchdoc.
  END.
  HIDE FRAME F-Proceso.     

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
  DISPLAY DesdeC HastaC RADIO-SET-Movimiento COMBO-BOX-Dias RADIO-SET-Stock 
          RADIO-SET-Costo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-61 RECT-59 RECT-58 RECT-60 DesdeC HastaC COMBO-BOX-Dias 
         RADIO-SET-Costo Btn_OK Btn_Cancel 
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
  DEF VAR Titulo-1 AS CHAR FORMAT 'x(60)'.
  DEF VAR Titulo-2 AS CHAR FORMAT 'x(60)'.
  DEF VAR Titulo-3 AS CHAR FORMAT 'x(60)'.
  
  Titulo-1 = "MATERIALES".
  IF DesdeC <> '' THEN Titulo-1 = Titulo-1 + " DESDE EL CODIGO " + DesdeC.
  IF HastaC <> '' THEN Titulo-1 = Titulo-1 + " HASTA EL CODIGO " + HastaC.
  CASE RADIO-SET-Stock:
    WHEN 1 THEN Titulo-2 = "CON STOCK".
    WHEN 2 THEN Titulo-2 = "SIN STOCK".
  END CASE.
  CASE RADIO-SET-Movimiento:
    WHEN 1 THEN Titulo-2 = Titulo-2 + " Y CON MOVIMIENTO".
    WHEN 2 THEN Titulo-2 = Titulo-2 + " Y SIN MOVIMIENTO".
  END CASE.
  Titulo-2 = Titulo-2 + " HACE MAS DE " + STRING(COMBO-BOX-Dias, '>9') + " MESES".
  CASE RADIO-SET-Costo:
    WHEN 1 THEN Titulo-3 = 'VALORIZADO AL COSTO PROMEDIO EN NUEVOS SOLES'.
    WHEN 2 THEN Titulo-3 = 'VALORIZADO AL COSTO DE REPOSICION EN NUEVOS SOLES'.
  END CASE.
  DEFINE FRAME F-DETALLE
    DETALLE.codmat FORMAT 'x(6)' 
    DETALLE.desmat FORMAT 'x(48)'
    DETALLE.undbas FORMAT 'x(6)'
    DETALLE.desmar FORMAT 'x(20)' 
    DETALLE.stkact FORMAT '->,>>>,>>9.99' 
    DETALLE.stkobs FORMAT '->,>>>,>>9.99' 
    DETALLE.ctolis FORMAT '->>>,>>9.9999' 
    DETALLE.imptot FORMAT '->>,>>>,>>9.99' 
    DETALLE.tipart FORMAT 'x(3)'
    DETALLE.tpoart FORMAT 'x(3)'
    DETALLE.fchact FORMAT '99/99/9999'
    SKIP
  WITH WIDTH 170 NO-BOX NO-LABELS STREAM-IO. 

  DEFINE FRAME F-HEADER
    HEADER
    S-NOMCIA FORMAT 'x(50)' SKIP
    "ARTICULOS ACTIVOS" AT 50 
    "Pagina :" TO 130 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
    "Fecha :"  TO 130 TODAY FORMAT "99/99/9999" SKIP
    "Hora :"   TO 130 STRING(TIME,"HH:MM") SKIP
    Titulo-1 SKIP
    Titulo-2 SKIP
    Titulo-3 SKIP(1)
    '                                                                                           Stock  Obsoletos y/o      Precio                                    ' SKIP
    'Codigo Descripcion                                      Unidad Marca                       Actual  Deteriorados      Unitario          Total Rot Est Ult. Mov. ' SKIP
    '---------------------------------------------------------------------------------------------------------------------------------------------------------------' SKIP
/*            1         2         3         4         5         6         7         8         9         10       11        12        13        14
     123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
     123456 123456789012345678901234567890123456789012345678 123456 12345678901234567890 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 ->>,>>>,>>9.99 123 123 99/99/9999
*/
    WITH PAGE-TOP WIDTH 170 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO. 

  FOR EACH DETALLE BREAK BY DETALLE.CodCia BY DETALLE.desmat:
    VIEW STREAM REPORT FRAME F-HEADER.
    ACCUMULATE DETALLE.imptot (TOTAL BY DETALLE.CodCia).
    DISPLAY STREAM REPORT 
        DETALLE.codmat
        DETALLE.desmat
        DETALLE.undbas
        DETALLE.desmar 
        DETALLE.stkact
        DETALLE.stkobs
        DETALLE.ctolis
        DETALLE.imptot
        DETALLE.tipart
        DETALLE.tpoart
        DETALLE.fchact
        WITH FRAME F-DETALLE.
    IF LAST-OF(DETALLE.CodCia)
    THEN DO:
        UNDERLINE STREAM REPORT
            DETALLE.desmar
            DETALLE.imptot
            WITH FRAME F-DETALLE DOWN.
        DISPLAY STREAM REPORT
            'TOTAL GENERAL >>>' @ DETALLE.desmar
            ACCUM TOTAL BY DETALLE.CodCia DETALLE.imptot @ DETALLE.imptot
            WITH FRAME F-DETALLE.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-1 W-Win 
PROCEDURE Formato-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR Titulo-1 AS CHAR FORMAT 'x(60)'.
  DEF VAR Titulo-2 AS CHAR FORMAT 'x(60)'.
  DEF VAR Titulo-3 AS CHAR FORMAT 'x(60)'.
  
  Titulo-1 = "MATERIALES".
  IF DesdeC <> '' THEN Titulo-1 = Titulo-1 + " DESDE EL CODIGO " + DesdeC.
  IF HastaC <> '' THEN Titulo-1 = Titulo-1 + " HASTA EL CODIGO " + HastaC.
  CASE RADIO-SET-Stock:
    WHEN 1 THEN Titulo-2 = "CON STOCK".
    WHEN 2 THEN Titulo-2 = "SIN STOCK".
  END CASE.
  CASE RADIO-SET-Movimiento:
    WHEN 1 THEN Titulo-2 = Titulo-2 + " Y CON MOVIMIENTO".
    WHEN 2 THEN Titulo-2 = Titulo-2 + " Y SIN MOVIMIENTO".
  END CASE.
  Titulo-2 = Titulo-2 + " HACE MAS DE " + STRING(COMBO-BOX-Dias, '>9') + " MESES".
  CASE RADIO-SET-Costo:
    WHEN 1 THEN Titulo-3 = 'VALORIZADO AL COSTO PROMEDIO EN NUEVOS SOLES'.
    WHEN 2 THEN Titulo-3 = 'VALORIZADO AL COSTO DE REPOSICION EN NUEVOS SOLES'.
  END CASE.
  DEFINE FRAME F-DETALLE
    DETALLE.codmat FORMAT 'x(6)' 
    DETALLE.desmat FORMAT 'x(48)'
    DETALLE.undbas FORMAT 'x(6)'
    DETALLE.desmar FORMAT 'x(20)' 
    DETALLE.stkact FORMAT '->,>>>,>>9.99' 
    DETALLE.ctolis FORMAT '->>>,>>9.9999' 
    DETALLE.imptot FORMAT '->>,>>>,>>9.99' 
    DETALLE.tipart FORMAT 'x(3)'
    DETALLE.tpoart FORMAT 'x(3)'
    DETALLE.fchact FORMAT '99/99/9999'
    SKIP
  WITH WIDTH 170 NO-BOX NO-LABELS STREAM-IO. 

  DEFINE FRAME F-HEADER
    HEADER
    S-NOMCIA FORMAT 'x(50)' SKIP
    "ARTICULOS ACTIVOS" AT 50 
    "Pagina :" TO 130 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
    "Fecha :"  TO 130 TODAY FORMAT "99/99/9999" SKIP
    "Hora :"   TO 130 STRING(TIME,"HH:MM") SKIP
    Titulo-1 SKIP
    Titulo-2 SKIP
    Titulo-3 SKIP(1)
    '                                                                                           Stock                                                 ' SKIP
    'Codigo Descripcion                                      Unidad Marca                       Actual        Costo           Total Rot Est Ult. Mov. ' SKIP
    '-------------------------------------------------------------------------------------------------------------------------------------------------' SKIP
/*            1         2         3         4         5         6         7         8         9         10       11        12        13        14
     123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
     123456 123456789012345678901234567890123456789012345678 123456 12345678901234567890 ->,>>>,>>9.99 ->,>>>,>>9.99 ->>,>>>,>>9.99 123 123 99/99/9999
*/
    WITH PAGE-TOP WIDTH 170 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO. 

  FOR EACH DETALLE BREAK BY DETALLE.CodCia BY DETALLE.desmat:
    VIEW STREAM REPORT FRAME F-HEADER.
    ACCUMULATE DETALLE.imptot (TOTAL BY DETALLE.CodCia).
    DISPLAY STREAM REPORT 
        DETALLE.codmat
        DETALLE.desmat
        DETALLE.undbas
        DETALLE.desmar 
        DETALLE.stkact
        DETALLE.ctolis
        DETALLE.imptot
        DETALLE.tipart
        DETALLE.tpoart
        DETALLE.fchact
        WITH FRAME F-DETALLE.
    IF LAST-OF(DETALLE.CodCia)
    THEN DO:
        UNDERLINE STREAM REPORT
            DETALLE.desmar
            DETALLE.imptot
            WITH FRAME F-DETALLE DOWN.
        DISPLAY STREAM REPORT
            'TOTAL GENERAL >>>' @ DETALLE.desmar
            ACCUM TOTAL BY DETALLE.CodCia DETALLE.imptot @ DETALLE.imptot
            WITH FRAME F-DETALLE.
    END.
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
   
    RUN Carga-Temporal.

    FIND FIRST DETALLE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE DETALLE THEN DO:
        MESSAGE 'NO hay registros a imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

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
        RUN Formato-1.        /* Sin la columna de Obsoletos */
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
        WHEN "" THEN .
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _Header W-Win 
PROCEDURE _Header :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
titulo = "REPORTE DE MOVIMIENTOS POR DIA".

mens1 = "TIPO Y CODIGO DE MOVIMIENTO : " + C-TipMov + "-" + STRING(I-CodMov, "99") + " " + D-Movi:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
mens2 = "MATERIAL : " + DesdeC + " A: " + HastaC .
mens3 = "FECHA : " + STRING(F-FchDes, "99/99/9999") + " A: " + STRING(F-FchHas, "99/99/9999").

titulo = S-NomCia + fill(" ", (INT((90 - length(titulo)) / 2)) - length(S-NomCia)) + titulo.
mens1 = fill(" ", INT((90 - length(mens1)) / 2)) + mens1.
mens2 = fill(" ", INT((90 - length(mens2)) / 2)) + mens2.
mens3 = C-condicion:SCREEN-VALUE + fill(" ", INT((90 - length(mens3)) / 2) - LENGTH(C-condicion:SCREEN-VALUE)) + mens3.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


