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

DEFINE INPUT PARAMETER pParAlmUbi AS CHAR    NO-UNDO.

/*
DEFINE INPUT PARAMETER pParAlmacen AS CHAR    NO-UNDO.
DEFINE INPUT PARAMETER pParListaUbis AS CHAR    NO-UNDO.
*/

/* ***************************  Definitions  ************************** */
/*{src/bin/_prns.i} */  /* Para la impresion */
{src/adm2/widgetprto.i}
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR CL-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-USER-ID AS CHAR.

DEFINE VAR pGrupo AS CHAR.
DEFINE VAR pDesGrupo AS CHAR.
DEFINE VAR pAlmacen AS CHAR.
DEFINE VAR pListaUbis AS CHAR.
DEFINE VAR pParAlmacen AS CHAR.
DEFINE VAR pParListaUbis AS CHAR.

IF pParAlmUbi = 'NADA' THEN DO:
    pAlmacen = ''.
    pListaUbis = ''.
END.
ELSE DO:
    pAlmacen     = ENTRY(1,pParAlmUbi,"*").
    pListaUbis   = ENTRY(2,pParAlmUbi,"*").
END.

DEFINE VAR s-task-no AS INTEGER NO-UNDO.
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
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS txtArtDesde txtArtHasta rs_concuales rs_cant ~
r-queimprimir txt-valorizado txt-porcentaje r-imp Btn_Ok Btn_Done RECT-71 ~
RECT-75 RECT-72 RECT-73 
&Scoped-Define DISPLAYED-OBJECTS x-codalm txt-desalm txtArtDesde ~
txtArtHasta rs_concuales rs_cant r-queimprimir txt-valorizado ~
txt-porcentaje txtUbis r-pages x-nropages rbGrabarReg r-imp x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-Excel 
     IMAGE-UP FILE "IMG/excel.bmp":U
     LABEL "Button 1" 
     SIZE 12 BY 1.54.

DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_Ok 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.54.

DEFINE VARIABLE txt-desalm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE txt-porcentaje AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Cuya diferencia en unidades sea mayor/igual (>=) %" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txt-valorizado AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Cuya diferencia valorizada sea mayor igual (>=)" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txtArtDesde AS CHARACTER FORMAT "X(6)":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE txtArtHasta AS CHARACTER FORMAT "X(6)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE txtUbis AS CHARACTER FORMAT "X(256)":U 
     LABEL "Zonas" 
     VIEW-AS FILL-IN 
     SIZE 58 BY 1.73
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE x-codalm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 64 BY .81 NO-UNDO.

DEFINE VARIABLE x-nropages AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE r-imp AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impresión Laser", 1,
"Impresion Matricial", 2
     SIZE 55 BY 1.04 NO-UNDO.

DEFINE VARIABLE r-pages AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todas", 1,
"Páginas: ", 2
     SIZE 9 BY 1.88 NO-UNDO.

DEFINE VARIABLE r-queimprimir AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Solo diferencias", 1,
"Todos", 2
     SIZE 15 BY 1.35 NO-UNDO.

DEFINE VARIABLE rs_cant AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Cantidad del Proceso", 1,
"Diferencias", 2,
"Nada (en blanco)", 3
     SIZE 18 BY 2.12 NO-UNDO.

DEFINE VARIABLE rs_concuales AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Conteo", 1,
"Reconteo", 2,
"3er Conteo", 3,
"Sin Inventariar (Se considera la Zona del sistema)",4
     SIZE 38.86 BY 2.42 NO-UNDO.

DEFINE RECTANGLE RECT-71
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 70.14 BY 1.88
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-72
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72.29 BY 3.69.

DEFINE RECTANGLE RECT-73
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.29 BY 9.35.

DEFINE RECTANGLE RECT-75
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72 BY 4.42.

DEFINE VARIABLE rbGrabarReg AS LOGICAL INITIAL no 
     LABEL "Guardar como Hoja de Re-conteo ó 3er Conteo" 
     VIEW-AS TOGGLE-BOX
     SIZE 37 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-codalm AT ROW 1.73 COL 10 COLON-ALIGNED WIDGET-ID 42
     txt-desalm AT ROW 1.73 COL 18.43 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     txtArtDesde AT ROW 3.04 COL 16.57 COLON-ALIGNED WIDGET-ID 44
     txtArtHasta AT ROW 3.04 COL 31.86 COLON-ALIGNED WIDGET-ID 74
     rs_concuales AT ROW 4.85 COL 19.14 NO-LABEL WIDGET-ID 84
     rs_cant AT ROW 4.92 COL 61.14 NO-LABEL WIDGET-ID 100
     r-queimprimir AT ROW 8.5 COL 11.72 NO-LABEL WIDGET-ID 94
     txt-valorizado AT ROW 8.31 COL 62.86 COLON-ALIGNED WIDGET-ID 106
     txt-porcentaje AT ROW 9.46 COL 62.86 COLON-ALIGNED WIDGET-ID 108
     txtUbis AT ROW 10.81 COL 18 COLON-ALIGNED WIDGET-ID 112
     r-pages AT ROW 13.15 COL 8.86 NO-LABEL WIDGET-ID 52
     x-nropages AT ROW 14.31 COL 15.86 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     rbGrabarReg AT ROW 13.15 COL 33.86 WIDGET-ID 110
     r-imp AT ROW 16.69 COL 10.86 NO-LABEL WIDGET-ID 16
     x-mensaje AT ROW 17.85 COL 8.14 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     btn-Excel AT ROW 18.88 COL 40.29 WIDGET-ID 68
     Btn_Ok AT ROW 18.88 COL 52.29 WIDGET-ID 64
     Btn_Done AT ROW 18.88 COL 64.43
     "Ingrese número de páginas o rango de páginas separadas" VIEW-AS TEXT
          SIZE 41 BY .5 AT ROW 15.12 COL 17.86 WIDGET-ID 60
     "por coma. Por ejemplo:1,2,5-10." VIEW-AS TEXT
          SIZE 41 BY .5 AT ROW 15.73 COL 17.86 WIDGET-ID 48
     "Rango Páginas" VIEW-AS TEXT
          SIZE 11.72 BY .5 AT ROW 12.5 COL 8.43 WIDGET-ID 58
          FGCOLOR 1 
     "Criterios Impresión" VIEW-AS TEXT
          SIZE 12.72 BY .5 AT ROW 1.12 COL 3.29 WIDGET-ID 70
          FGCOLOR 1 
     "Articulos:" VIEW-AS TEXT
          SIZE 5.29 BY .5 AT ROW 3.23 COL 6.72 WIDGET-ID 72
     "Que Procesar :" VIEW-AS TEXT
          SIZE 12.57 BY .85 AT ROW 4.81 COL 6.29 WIDGET-ID 88
          BGCOLOR 9 FGCOLOR 15 FONT 6
     "Que Imprimir" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 7.73 COL 5.72 WIDGET-ID 98
     "Columa CANTIDAD a imprimir :" VIEW-AS TEXT
          SIZE 25.86 BY .81 AT ROW 3.88 COL 57 WIDGET-ID 104
          BGCOLOR 1 FGCOLOR 15 FONT 6
     RECT-71 AT ROW 18.77 COL 7.72 WIDGET-ID 24
     RECT-75 AT ROW 16.62 COL 6.86 WIDGET-ID 46
     RECT-72 AT ROW 12.69 COL 6.86 WIDGET-ID 50
     RECT-73 AT ROW 1.15 COL 1.72 WIDGET-ID 56
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85.72 BY 20.35
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
         TITLE              = "PDA - Impresion Hoja de Reconteo (Diferencias)"
         HEIGHT             = 20.35
         WIDTH              = 85.72
         MAX-HEIGHT         = 27.65
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.65
         VIRTUAL-WIDTH      = 146.29
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR BUTTON btn-Excel IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       btn-Excel:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR RADIO-SET r-pages IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX rbGrabarReg IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-desalm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtUbis IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-codalm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-nropages IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* PDA - Impresion Hoja de Reconteo (Diferencias) */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PDA - Impresion Hoja de Reconteo (Diferencias) */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-Excel W-Win
ON CHOOSE OF btn-Excel IN FRAME F-Main /* Button 1 */
DO:
    /*
    ASSIGN 
        x-CodAlm 
        r-imp 
        r-pages
        x-nropages
        x-zona
        rs_concuales
        rs_cant
        r-queimprimir
        txt-valorizado
        txt-porcentaje
        rbGrabarReg.
    IF txt-valorizado >=0 AND txt-porcentaje >= 0 THEN DO:  
        RUN Carga-Temporal.
        RUN Excel.
    END.
    ELSE DO:
        MESSAGE 'Los parametros deben ser mayor/igual a CERO' VIEW-AS ALERT-BOX WARNING.
    END.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Cancelar */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Ok W-Win
ON CHOOSE OF Btn_Ok IN FRAME F-Main /* Aceptar */
DO:
  ASSIGN 
      x-CodAlm 
      r-imp 
      r-pages
      x-nropages
      txtArtDesde
      txtArtHasta
      rs_concuales
      rs_cant
      r-queimprimir
      txt-valorizado
      txt-porcentaje
      rbGrabarReg
      txtUbis.

  IF txt-valorizado >=0 AND txt-porcentaje >= 0 THEN DO:  
    RUN Carga-Temporal.
    RUN Imprime.  
  END.
  ELSE DO:
      MESSAGE 'Lo parametros deben ser mayor/igual a CERO' VIEW-AS ALERT-BOX WARNING.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs_concuales
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs_concuales W-Win
ON LEAVE OF rs_concuales IN FRAME F-Main
DO:

  DEFINE VAR lProcesar AS CHAR.

  lProcesar = rs_concuales:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

  DO WITH FRAME {&FRAME-NAME}:
      IF lProcesar = '4' THEN DO:
          rs_cant:SCREEN-VALUE = '3'.
          r-queimprimir:SCREEN-VALUE = '2'.
          txt-valorizado:SCREEN-VALUE = '0.00'.
          txt-porcentaje:SCREEN-VALUE = '0'.
          /**/
          DISABLE rs_cant.
          DISABLE r-queimprimir.
          DISABLE txt-valorizado.
          DISABLE txt-porcentaje.
      END.
      ELSE DO:
          ENABLE rs_cant.
          ENABLE r-queimprimir.
          ENABLE txt-valorizado.
          ENABLE txt-porcentaje.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs_concuales W-Win
ON VALUE-CHANGED OF rs_concuales IN FRAME F-Main
DO:
    DEFINE VAR lProcesar AS CHAR.

    lProcesar = rs_concuales:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    DO WITH FRAME {&FRAME-NAME}:
        IF lProcesar = '4' THEN DO:
            rs_cant:SCREEN-VALUE = '3'.
            r-queimprimir:SCREEN-VALUE = '2'.
            txt-valorizado:SCREEN-VALUE = '0.00'.
            txt-porcentaje:SCREEN-VALUE = '0'.
            /**/
            DISABLE rs_cant.
            DISABLE r-queimprimir.
            DISABLE txt-valorizado.
            DISABLE txt-porcentaje.
        END.
        ELSE DO:
            ENABLE rs_cant.
            ENABLE r-queimprimir.
            ENABLE txt-valorizado.
            ENABLE txt-porcentaje.
        END.
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
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR L-Ubica       AS LOGICAL     NO-UNDO   INIT YES.    
    DEFINE VAR cAlmc         AS CHARACTER   NO-UNDO.

    DEFINE VAR cArtDesde        AS CHARACTER   NO-UNDO.
    DEFINE VAR cArtHasta        AS CHARACTER   NO-UNDO.
    DEFINE VAR cZona         AS CHARACTER   NO-UNDO.

    DEFINE VAR lRegValido    AS LOG.

    DEFINE VAR lQInventariado AS DECIMAL.
    DEFINE VAR x-ctopro AS DECIMAL.
    DEFINE VAR lQDif AS DECIMAL.
    DEFINE VAR lQDifValo AS DECIMAL.
    DEFINE VAR lQMostrar AS DECIMAL.
    DEFINE VAR lFaseInv AS CHAR.    
    DEFINE VAR lSec AS INT.
    
    REPEAT WHILE L-Ubica:
        s-task-no = RANDOM(900000,999999).
        FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
        IF NOT AVAILABLE w-report THEN L-Ubica = NO.
    END.

    pGrupo = "".
    pDesGrupo = "".
    IF rbGrabarReg = YES THEN DO:
        pGrupo = STRING(TIME,"hh:mm:ss").
        pGrupo = STRING(TODAY,"99-99-9999") + "_" + REPLACE(pGrupo, ':', '-') .

        CASE rs_concuales :
            WHEN 1 THEN DO:
                 /* Conteo */
                pGrupo = "REC_" + pGrupo.
                pDesGrupo = "RECONTEO".
            END.
            WHEN 2 THEN DO:
                /* Reconteo */
                pGrupo = "3ER_" + pGrupo.
                pDesGrupo = "3ER CONTEO".
            END.
            WHEN 3 THEN DO:
                /* 3er Conteo */
                pGrupo = "4TO_" + pGrupo.
                pDesGrupo = "4TO CONTEO CONTEO".
            END.
        END CASE.
    END.
   
    ASSIGN 
        cAlmc   = x-CodAlm:SCREEN-VALUE IN FRAME {&FRAME-NAME}
        cArtDesde  = ''
        cArtHasta  = ''.
    
    IF txtArtDesde   = '' THEN DO : 
        cArtDesde = '000000'.
    END.
    ELSE DO:  
        cArtDesde = FILL('0', ( 6 - LENGTH(TRIM(txtArtDesde))) ) + TRIM(txtArtDesde).
    END.

    IF txtArtHasta = '' THEN DO : 
        cArtHasta = '999999'.
    END.
    ELSE DO: 
        cArtHasta = FILL('0', (6 - LENGTH(TRIM(txtArtHasta))) ) + TRIM(txtArtHasta).
    END.
    
    lSec = 0.
    FOR EACH invCargaInicial WHERE invCargaInicial.codcia = s-codcia AND
                                    invCargaInicial.CodAlm = cAlmc AND 
                                    (invCargaInicial.CodMat >= cArtDesde AND 
                                     invCargaInicial.CodMat <= cArtHasta ) NO-LOCK:

        lRegValido = NO.
        /*Costo Promedio Kardex*/
        x-ctopro = 0.
        FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia
            AND AlmStkGe.codmat = invCargaInicial.codmat
            AND AlmStkGe.fecha <= invCargaInicial.FechInv
            NO-LOCK NO-ERROR.
        IF AVAILABLE AlmStkGe THEN x-ctopro = AlmStkge.CtoUni. 

        lFaseInv = ''.
        lQInventariado = 0.
        CASE rs_concuales :
            WHEN 1 THEN DO:
                 /* Conteo */
                 lQInventariado = invCargaInicial.QCont1.
                 lFaseInv = '(CONTEO)'.
            END.
            WHEN 2 THEN DO:
                /* Reconteo */
                lFaseInv = '(RECONTEO)'.
                lQInventariado = invCargaInicial.QCont2.
            END.
            WHEN 3 THEN DO:
                /* 3er Conteo */
                lFaseInv = '(3er CONTEO)'.
                lQInventariado = invCargaInicial.QCont3.
            END.
            WHEN 4 THEN DO:
                /* 3er Conteo */
                lFaseInv = '(Sin Inventariar)'.
                lQInventariado = 0.
            END.

        END CASE.

        /*lQInventariado = invCargaInicial.QinvFinal.*/
        lQDif = invCargaInicial.QinvFinal - invCargaInicial.QStkSis.
        lQDifValo = 0.

        IF txt-valorizado <= 0 AND  txt-porcentaje <= 0 THEN DO:
            lQDifValo = 1.
        END.
        ELSE DO:
            IF txt-valorizado > 0 THEN DO:
                lQDifValo = ABSOLUTE(lQDif * x-ctopro).
                IF lQDifValo < txt-valorizado THEN DO:
                    /* Si la diferencia valorizada es menor queel paramentro NO SE CONSIDERA */
                    lQDifValo = 0.
                END.
            END.
            IF lQDifValo = 0 THEN DO:
                IF txt-porcentaje > 0 THEN DO:
                    lQDifValo = (lQDif / invCargaInicial.QStkSis) * 100.
                    IF lQDifValo < txt-porcentaje THEN DO:
                        lQDifValo = 0.
                    END.
                END.  
            END.
        END.

        IF rs_concuales <> 4 THEN DO:
            FOR EACH invCPDA WHERE invCPDA.codcia = invCargaInicial.codcia AND 
                        invCPDA.CodAlm = invCargaInicial.CodAlm AND
                        invCPDA.CodMat = invCargaInicial.CodMat NO-LOCK:


                IF ((r-queimprimir = 2) OR (lQDif <> 0)) AND lQDifValo > 0 THEN DO:
                    IF rbGrabarReg = YES THEN DO:
                        CASE rs_concuales :
                            WHEN 1 THEN DO:
                                 /* Conteo */
                            END.
                            WHEN 2 THEN DO:
                                /* Reconteo */
                            END.
                            WHEN 3 THEN DO:
                                /* 3er Conteo */                        
                            END.
                        END CASE.
                    END.

                    lSec = lSec + 1.
                    CREATE w-report.
                    ASSIGN
                        w-report.Task-No    = s-task-no
                        w-report.llave-C = invCPDA.CZona
                        w-report.Llave-I    = invCargaInicial.CodCia
                        w-report.Campo-I[1] = 1
                        w-report.Campo-I[2] = lSec
                        w-report.Campo-C[1] = invCargaInicial.CodAlm
                        w-report.Campo-C[2] = invCPDA.CZona
                        w-report.Campo-C[3] = invCargaInicial.CodMat
                        w-report.Campo-C[4] = lFaseInv + " / Almacen: " + invCargaInicial.CodAlm + "- " + txt-desalm
                        w-report.Campo-C[5] = s-user-id
                        w-report.Campo-F[1] = invCargaInicial.QStkSis
                        w-report.Campo-F[2] = lQInventariado
                        w-report.Campo-F[3] = (lQInventariado - invCargaInicial.QStkSis).             

                        lQMostrar = ?.
                        CASE rs_Cant :
                            WHEN 1 THEN lQMostrar = lQInventariado.
                            WHEN 2 THEN lQMostrar = (lQInventariado - invCargaInicial.QStkSis).
                        END CASE.

                        w-report.Campo-F[2] = lQMostrar.
                        lRegValido = YES.
                END.
            END.
        END.
        ELSE DO:
            lRegValido = YES.
            /* Articulos sin Inventariar */
            IF invCargaInicial.QCont1 = ? AND invCargaInicial.QCont2 = ? AND 
                    invCargaInicial.QCont3 = ? THEN DO:
                lRegValido = NO.
            END.
        END.
        IF lRegValido = NO THEN DO:
            lSec = lSec + 1.
            CREATE w-report.
            ASSIGN
                w-report.Task-No    = s-task-no
                w-report.llave-C = IF (rs_concuales = 4) THEN invCargaInicial.Czona ELSE ""
                w-report.Llave-I    = invCargaInicial.CodCia
                w-report.Campo-I[1] = 1
                w-report.Campo-I[2] = lSec
                w-report.Campo-C[1] = invCargaInicial.CodAlm
                w-report.Campo-C[2] = IF (rs_concuales = 4) THEN invCargaInicial.Czona ELSE ""
                w-report.Campo-C[3] = invCargaInicial.CodMat
                w-report.Campo-C[4] = lFaseInv + " / Almacen: " + invCargaInicial.CodAlm + "- " + txt-desalm
                w-report.Campo-C[5] = s-user-id
                w-report.Campo-F[1] = invCargaInicial.QStkSis
                w-report.Campo-F[2] = lQInventariado
                w-report.Campo-F[3] = (lQInventariado - invCargaInicial.QStkSis).             

                lQMostrar = ?.
                CASE rs_Cant :
                    WHEN 1 THEN lQMostrar = lQInventariado.
                    WHEN 2 THEN lQMostrar = (lQInventariado - invCargaInicial.QStkSis).
                END CASE.

                w-report.Campo-F[2] = lQMostrar.
                lRegValido = YES.
        END.
        DISPLAY "Cargando informacion " + invCargaInicial.CodMat @ x-mensaje
            WITH FRAME {&FRAME-NAME}.

    END.

    /* -------------------------------------------------------------------- */
    /*
    DEF BUFFER B-DINV FOR AlmDInv.

    FOR EACH AlmDInv USE-INDEX Llave01
        WHERE AlmDInv.CodCia  =  s-codcia
        AND AlmDInv.CodAlm    =  cAlmc
        AND (r-pages = 1 OR
            LOOKUP(STRING(AlmDInv.NroPagina),x-nropages-2) > 0)
        AND AlmDInv.NomCia =  cNomCia
        AND (( txtUbis = "" 
        AND AlmDInv.CodUbi >= cZonaD
        AND AlmDInv.CodUbi <= cZonaH ) 
        OR (txtUbis <> "" AND LOOKUP(AlmDInv.CodUbi, txtUbis) > 0 ))  NO-LOCK:        

        /*Busca Supervisor*/
        FIND LAST TabSupAlm WHERE TabSupAlm.CodCia = AlmDinv.codcia
            AND TabSupAlm.CodAlm = AlmDinv.CodAlm
            AND TabSupAlm.CodUbi  = AlmDinv.CodUbi NO-LOCK NO-ERROR.
        IF AVAIL TabSupAlm THEN DO: 
            FIND FIRST almtabla WHERE almtabla.tabla = 'SU'
                AND almtabla.codigo = tabsupalm.cargo NO-LOCK NO-ERROR.
            IF AVAIL almtabla THEN cSuper = tabsupalm.cargo + "-" + almtabla.nombre. 
            ELSE cSuper = 'Ninguno'.
        END.

        /*Costo Promedio Kardex*/
        x-ctopro = 0.
        FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia
            AND AlmStkGe.codmat = almDinv.codmat
            AND AlmStkGe.fecha <= AlmDInv.Libre_f01
            NO-LOCK NO-ERROR.
        IF AVAILABLE AlmStkGe THEN x-ctopro = AlmStkge.CtoUni. 

        lFaseInv = ''.
        lQInventariado = 0.
        CASE rs_concuales :
            WHEN 1 THEN DO:
                 /* Conteo */
                 lQInventariado = AlmDInv.QtyConteo.
                 lFaseInv = '(CONTEO)'.
            END.
            WHEN 2 THEN DO:
                /* Reconteo */
                lFaseInv = '(RECONTEO)'.
                IF almdinv.coduserrec = ? OR almdinv.coduserrec='' THEN DO:
                    /* Si no hay reconteo, tomamos el conteo */
                    lQInventariado = AlmDInv.QtyConteo.
                END.
                ELSE lQInventariado = AlmDInv.QtyReConteo.
            END.
            WHEN 3 THEN DO:
                /* 3er Conteo */
                lFaseInv = '(3er CONTEO)'.
                IF almdinv.libre_c01=? OR almdinv.libre_c01='' THEN DO:
                    /* Si no hay 3er conteo se toma reconteo  */
                    IF almdinv.coduserrec = ? OR almdinv.coduserrec='' THEN DO:
                        /* si no reconteo se toma el conteo */
                        lQInventariado = AlmDInv.QtyConteo.
                    END.
                    ELSE lQInventariado = AlmDInv.QtyReConteo.
                END.
                ELSE  lQInventariado = AlmDInv.libre_d02.
            END.
        END CASE.

        /* AlmDInv.libre_D01 : Debe ejecutar el proceso de calculo de Conteo Final */
        lQInventariado = AlmDInv.libre_d01.
        lQDif = lQInventariado - AlmDInv.QtyFisico.
        lQDifValo = 0.

        IF txt-valorizado <= 0 AND  txt-porcentaje <= 0 THEN DO:
            lQDifValo = 1.
        END.
        ELSE DO:
            IF txt-valorizado > 0 THEN DO:
                lQDifValo = ABSOLUTE(lQDif * x-ctopro).
                IF lQDifValo < txt-valorizado THEN DO:
                    /* Si la diferencia valorizada es menor queel paramentro NO SE CONSIDERA */
                    lQDifValo = 0.
                END.
            END.
            IF lQDifValo = 0 THEN DO:
                IF txt-porcentaje > 0 THEN DO:
                    lQDifValo = (lQDif / AlmDInv.QtyFisico) * 100.
                    IF lQDifValo < txt-porcentaje THEN DO:
                        lQDifValo = 0.
                    END.
                END.  
            END.
        END.

        IF ((r-queimprimir = 2) OR (lQDif <> 0)) AND lQDifValo > 0 THEN DO:
            IF rbGrabarReg = YES THEN DO:
                CASE rs_concuales :
                    WHEN 1 THEN DO:
                         /* Conteo */
                        FIND B-DINV WHERE ROWID(B-DINV) = ROWID(Almdinv) EXCLUSIVE-LOCK
                            NO-ERROR.
                        ASSIGN B-DInv.libre_c04 = pGrupo.
                    END.
                    WHEN 2 THEN DO:
                        /* Reconteo */
                        FIND B-DINV WHERE ROWID(B-DINV) = ROWID(Almdinv) EXCLUSIVE-LOCK
                            NO-ERROR.
                        ASSIGN B-DInv.libre_c05 = pGrupo.
                    END.
                    WHEN 3 THEN DO:
                        /* 3er Conteo */
                        
                    END.
                END CASE.
            END.
            
            CREATE w-report.
            ASSIGN
                w-report.Task-No    = s-task-no
                w-report.Llave-I    = AlmDInv.CodCia
                w-report.Campo-I[1] = AlmDInv.NroPagina
                w-report.Campo-I[2] = AlmDInv.NroSecuencia                
                w-report.Campo-C[1] = AlmDInv.CodAlm
                w-report.Campo-C[2] = AlmDInv.CodUbi
                w-report.Campo-C[3] = AlmDInv.CodMat
                w-report.Campo-C[4] = lFaseInv + " / Almacen: " + AlmDInv.CodAlm + "- " + txt-desalm
                w-report.Campo-C[5] = cSuper
                w-report.Campo-F[1] = AlmDInv.QtyFisico
                w-report.Campo-F[2] = lQInventariado
                w-report.Campo-F[3] = (lQInventariado - AlmDInv.QtyFisico).             

                lQMostrar = ?.
                CASE rs_Cant :
                    WHEN 1 THEN lQMostrar = lQInventariado.
                    WHEN 2 THEN lQMostrar = (lQInventariado - AlmDInv.QtyFisico).
                END CASE.

                w-report.Campo-F[2] = lQMostrar.
        END.

        DISPLAY "Cargando informacion " + AlmDInv.CodMat @ x-mensaje
            WITH FRAME {&FRAME-NAME}.
    END.
    RELEASE B-DInv.
    */
    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.

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
  DISPLAY x-codalm txt-desalm txtArtDesde txtArtHasta rs_concuales rs_cant 
          r-queimprimir txt-valorizado txt-porcentaje txtUbis r-pages x-nropages 
          rbGrabarReg r-imp x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txtArtDesde txtArtHasta rs_concuales rs_cant r-queimprimir 
         txt-valorizado txt-porcentaje r-imp Btn_Ok Btn_Done RECT-71 RECT-75 
         RECT-72 RECT-73 
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
    DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
    DEFINE VARIABLE chChart                 AS COM-HANDLE.
    DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
    DEFINE VARIABLE iCount                  AS INTEGER init 1.
    DEFINE VARIABLE iIndex                  AS INTEGER.
    DEFINE VARIABLE cColumn                 AS CHARACTER.
    DEFINE VARIABLE cRange                  AS CHARACTER.
    DEFINE VARIABLE t-Column                AS INTEGER INIT 5.
    DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
    DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.
    
    DEFINE VARIABLE x-DesMat AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-DesMar AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-Und    AS CHARACTER   NO-UNDO.
    
    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.
    
    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().
    
    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).
    
    /*Header del Excel */
    cRange = "E" + '2'.
    chWorkSheet:Range(cRange):Value = "HOJA DE RECONTEO".
    cRange = "K" + '2'.
    chWorkSheet:Range(cRange):Value = TODAY.
    cRange = "C" + '3'.
    chWorkSheet:Range(cRange):Value = "Almacen: ".
    cRange = "D" + '3'.
    chWorkSheet:Range(cRange):Value = x-CodAlm.
/*
    cRange = "E" + '3'.
    chWorkSheet:Range(cRange):Value = "-" + txt-desalm.*/
    
    
    /*Formato*/
    chWorkSheet:Columns("A"):NumberFormat = "@".
    chWorkSheet:Columns("B"):NumberFormat = "@".
    chWorkSheet:Columns("C"):NumberFormat = "@".
    chWorkSheet:Columns("D"):NumberFormat = "@".
    chWorkSheet:Columns("E"):NumberFormat = "@".
    
    /* set the column names for the Worksheet */
    t-Column = t-Column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Almc.".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro.Pag".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro.Sec".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Ubicación".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Código".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Descripción".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Marca".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Unidad".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Conteo".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Reconteo".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Observaciones".
    

    FOR EACH w-report WHERE w-report.task-no = s-task-no
        BREAK BY w-report.Campo-C[1]
            BY w-report.Campo-I[1]
            BY w-report.Campo-I[2]:
        FIND FIRST Almmmatg WHERE Almmmatg.CodCia = s-CodCia
            AND Almmmatg.CodMat = w-report.Campo-C[3] NO-LOCK NO-ERROR.
        IF AVAIL Almmmatg THEN 
            ASSIGN 
                x-DesMat = Almmmatg.DesMat
                x-DesMar = Almmmatg.DesMar
                x-Und    = Almmmatg.UndBas.
        t-Column = t-Column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-C[1].
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-I[1].
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-I[2].
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-C[2].
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-C[3].
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = x-Desmat.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = x-DesMar.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = x-Und.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.Campo-F[2].
        DISPLAY "Cargando informacion..." @ x-mensaje
            WITH FRAME {&FRAME-NAME}.

    END.

    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
    
    /* launch Excel so it is visible to the user */
     chExcelApplication:Visible = TRUE.
    
    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.
    
    /*Borrando Temporal*/
    FOR EACH w-report WHERE task-no = s-task-no:
        DELETE w-report.
    END.
    s-task-no = 0.


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
  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
  RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'alm/rbalm.prl'.

  IF r-pages = 1 THEN DO:
      IF r-imp = 1 THEN RB-REPORT-NAME = 'Listado de Reconteos PDA'.
      ELSE RB-REPORT-NAME = 'Listado de Reconteo_2 Draft'.
  END.
  ELSE DO:
      IF r-imp = 1 THEN RB-REPORT-NAME = 'Listado de Reconteos PDA'.
      ELSE RB-REPORT-NAME = 'Listado de Reconteo_2a Draft'.
  END.

  RB-INCLUDE-RECORDS = 'O'.
  RB-FILTER = "w-report.task-no = " + STRING(S-TASK-NO).

  RB-OTHER-PARAMETERS = "s-nomcia=" + s-nomcia +
                        "~ncNropage = " + STRING('999999') + 
                        "~nGrupo = " + pGrupo +
                        "~nDesGrupo = " + pDesGrupo.

  RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                     RB-REPORT-NAME,
                     RB-INCLUDE-RECORDS,
                     RB-FILTER,
                     RB-OTHER-PARAMETERS).


  /*Borrando Temporal*/
  FOR EACH w-report WHERE task-no = s-task-no:
      DELETE w-report.
  END.
s-task-no = 0.

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
       /*x-CodAlm:LIST-ITEMS = s-codalm.*/
       FOR EACH Almacen WHERE Almacen.CodCia = s-codcia NO-LOCK:
           /*x-CodAlm:ADD-LAST(Almacen.CodAlm).*/
       END.   
       ASSIGN 
           x-CodAlm = IF (pAlmacen = "") THEN s-codalm ELSE pAlmacen.
       FIND FIRST Almacen WHERE Almacen.CodCia = s-codcia
           AND Almacen.CodAlm = x-CodAlm NO-LOCK NO-ERROR.
       IF AVAIL Almacen THEN DO:
           ASSIGN txt-desalm = Almacen.Descripcion.
           DISPLAY Almacen.Descripcion @ txt-desalm.
       END.

       ASSIGN txtUbis = pListaUbis.
       DISPLAY txtUbis @ pListaUbis.
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

