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
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE        VAR C-OP      AS CHAR.
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA  AS CHARACTER.
DEFINE        VAR F-PESALM  AS DECIMAL NO-UNDO.
DEFINE SHARED VAR S-CODDIV  AS CHARACTER.
DEFINE SHARED VAR S-USER-ID AS CHARACTER.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

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
    WITH CENTERED OVERLAY KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.

/* Local Variable Definitions ---                                       */
DEFINE VAR S-SUBTIT  AS CHAR.
DEFINE VAR X-TITU    AS CHAR INIT "E S T A D I S T I C A   D E    V E N T A S".
DEFINE VAR X-MONEDA  AS CHAR.
DEFINE VAR I         AS INTEGER   NO-UNDO.
DEFINE VAR II        AS INTEGER   NO-UNDO.
DEFINE VAR F-Salida  AS DECI INIT 0.
DEFINE VAR T-Vtamn   AS DECI INIT 0.
DEFINE VAR T-Vtame   AS DECI INIT 0.
DEFINE VAR T-Ctomn   AS DECI INIT 0.
DEFINE VAR T-Ctome   AS DECI INIT 0.
DEFINE VAR T-Vta     AS DECI INIT 0.
DEFINE VAR T-Cto     AS DECI INIT 0.

DEFINE VAR X-CODDIV  AS CHAR.
DEFINE VAR X-ARTI    AS CHAR.
DEFINE VAR X-FAMILIA AS CHAR.
DEFINE VAR X-SUBFAMILIA AS CHAR.
DEFINE VAR X-MARCA    AS CHAR.
DEFINE VAR X-PROVE    AS CHAR.
DEFINE VAR X-LLAVE    AS CHAR.
DEFINE VAR X-FECHA AS DATE.
DEFINE VAR X-CODDIA AS INTEGER INIT 1.
DEFINE VAR X-CODANO AS INTEGER .
DEFINE VAR X-CODMES AS INTEGER .
DEFINE VAR X-NOMMES AS CHAR INIT "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre".

DEFINE TEMP-TABLE tmp-tempo NO-UNDO
    FIELD t-codcia  LIKE Almdmov.Codcia 
    FIELD t-clase   LIKE Almmmatg.clase
    FIELD t-codfam  LIKE Almmmatg.codfam 
    FIELD t-subfam  LIKE Almmmatg.subfam
    FIELD t-prove   LIKE Almmmatg.CodPr1
    FIELD t-codmat  LIKE Almdmov.codmat
    FIELD t-desmat  LIKE Almmmatg.DesMat    FORMAT "X(40)"
    FIELD t-desmar  LIKE Almmmatg.DesMar    FORMAT "X(8)"
    FIELD t-undbas  LIKE Almmmatg.UndBas    FORMAT "X(8)"
    FIELD t-stkact  LIKE Almmmate.StkAct    FORMAT "->>>>>,>>9.99" EXTENT 6
    FIELD t-ventamn AS DEC           FORMAT "->>>>>>>9.99" 
    FIELD t-ventame AS DEC           FORMAT "->>>>>>>9.99"
    FIELD t-costome AS DEC           FORMAT "->>>>>>>9.99"
    FIELD t-costomn AS DEC           FORMAT "->>>>>>>9.99"
    FIELD t-venta   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99"  
    FIELD t-costo   AS DEC  DECIMALS 4 EXTENT 10 FORMAT "->>>>>>>9.9999"  
    FIELD t-canti   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99" 
    FIELD t-marge   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99"  
    FIELD t-utili   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99"
    FIELD t-nro_dia AS DEC  
    FIELDS t-CanEmp AS DECIMAL.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-1 BUTTON-2 BUTTON-3 BUTTON-4 ~
F-DIVISION F-CodFam F-SubFam F-Marca F-prov1 DesdeC HastaC DesdeF HastaF ~
F-Almacen T-dias DIASINI DIASFIN F-DIVISION-1 F-DIVISION-2 F-DIVISION-3 ~
F-DIVISION-4 F-DIVISION-5 F-DIVISION-6 nCodMon Btn_OK Btn_Cancel Btn_Help ~
Btn_Excel RECT-61 RECT-62 RECT-63 RECT-64 
&Scoped-Define DISPLAYED-OBJECTS F-DIVISION F-CodFam F-SubFam F-Marca ~
F-prov1 DesdeC HastaC DesdeF HastaF F-Almacen T-dias DIASINI DIASFIN ~
F-DIVISION-1 F-NOMDIV-1 F-DIVISION-2 F-NOMDIV-2 F-DIVISION-3 F-NOMDIV-3 ~
F-DIVISION-4 F-NOMDIV-4 F-DIVISION-5 F-NOMDIV-5 F-DIVISION-6 F-NOMDIV-6 ~
nCodMon 

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
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     IMAGE-UP FILE "img\b-ayuda":U
     LABEL "A&yuda" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\b-buscar":U NO-FOCUS
     LABEL "Button 1" 
     SIZE 4.43 BY .77.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\b-buscar":U NO-FOCUS
     LABEL "Button 2" 
     SIZE 4.43 BY .77.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img\b-buscar":U NO-FOCUS
     LABEL "Button 3" 
     SIZE 4.43 BY .77.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img\b-buscar":U NO-FOCUS
     LABEL "Button 4" 
     SIZE 4.43 BY .77.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img\b-buscar":U NO-FOCUS
     LABEL "Button 6" 
     SIZE 4.43 BY .77.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE DIASFIN AS INTEGER FORMAT ">>>9":U INITIAL 100 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69 NO-UNDO.

DEFINE VARIABLE DIASINI AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "De" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69 NO-UNDO.

DEFINE VARIABLE F-Almacen AS CHARACTER FORMAT "X(50)":U 
     LABEL "Stock Almacén" 
     VIEW-AS FILL-IN 
     SIZE 31.43 BY .69 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Línea" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-DIVISION AS CHARACTER FORMAT "X(5)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-DIVISION-1 AS CHARACTER FORMAT "X(5)":U INITIAL "00001" 
     LABEL "1" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .69 NO-UNDO.

DEFINE VARIABLE F-DIVISION-2 AS CHARACTER FORMAT "X(5)":U INITIAL "00002" 
     LABEL "2" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .69 NO-UNDO.

DEFINE VARIABLE F-DIVISION-3 AS CHARACTER FORMAT "X(5)":U INITIAL "00003" 
     LABEL "3" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .69 NO-UNDO.

DEFINE VARIABLE F-DIVISION-4 AS CHARACTER FORMAT "X(5)":U INITIAL "00000" 
     LABEL "4" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .69 NO-UNDO.

DEFINE VARIABLE F-DIVISION-5 AS CHARACTER FORMAT "X(5)":U INITIAL "00005" 
     LABEL "5" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .69 NO-UNDO.

DEFINE VARIABLE F-DIVISION-6 AS CHARACTER FORMAT "X(5)":U INITIAL "00006" 
     LABEL "6" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .69 NO-UNDO.

DEFINE VARIABLE F-Marca AS CHARACTER FORMAT "X(4)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-NOMDIV-1 AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69 NO-UNDO.

DEFINE VARIABLE F-NOMDIV-2 AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69 NO-UNDO.

DEFINE VARIABLE F-NOMDIV-3 AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69 NO-UNDO.

DEFINE VARIABLE F-NOMDIV-4 AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69 NO-UNDO.

DEFINE VARIABLE F-NOMDIV-5 AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69 NO-UNDO.

DEFINE VARIABLE F-NOMDIV-6 AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69 NO-UNDO.

DEFINE VARIABLE F-prov1 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-SubFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Sub-línea" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(6)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dólares", 2
     SIZE 16.72 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72 BY 1.88
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 10.23
     BGCOLOR 3 .

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.86 BY 5.38.

DEFINE RECTANGLE RECT-63
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.86 BY 1.38.

DEFINE RECTANGLE RECT-64
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL   
     SIZE 36.57 BY 1.54.

DEFINE VARIABLE T-dias AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.29 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-5 AT ROW 2.35 COL 26
     BUTTON-1 AT ROW 3.12 COL 26
     BUTTON-2 AT ROW 3.88 COL 26
     BUTTON-3 AT ROW 4.65 COL 26
     BUTTON-4 AT ROW 5.42 COL 26
     F-DIVISION AT ROW 2.35 COL 13 COLON-ALIGNED
     F-CodFam AT ROW 3.12 COL 13 COLON-ALIGNED
     F-SubFam AT ROW 3.88 COL 13 COLON-ALIGNED
     F-Marca AT ROW 4.65 COL 13 COLON-ALIGNED
     F-prov1 AT ROW 5.42 COL 13 COLON-ALIGNED
     DesdeC AT ROW 6.19 COL 13 COLON-ALIGNED
     HastaC AT ROW 6.19 COL 33 COLON-ALIGNED
     DesdeF AT ROW 6.96 COL 13 COLON-ALIGNED
     HastaF AT ROW 6.96 COL 33 COLON-ALIGNED
     F-Almacen AT ROW 8.81 COL 13 COLON-ALIGNED
     T-dias AT ROW 10.27 COL 16.86
     DIASINI AT ROW 10.27 COL 20.86 COLON-ALIGNED
     DIASFIN AT ROW 10.27 COL 28.86 COLON-ALIGNED
     F-DIVISION-1 AT ROW 5.08 COL 49.14 COLON-ALIGNED
     F-NOMDIV-1 AT ROW 5.12 COL 55.57 COLON-ALIGNED NO-LABEL
     F-DIVISION-2 AT ROW 5.81 COL 49.14 COLON-ALIGNED
     F-NOMDIV-2 AT ROW 5.85 COL 55.57 COLON-ALIGNED NO-LABEL
     F-DIVISION-3 AT ROW 6.62 COL 49.14 COLON-ALIGNED
     F-NOMDIV-3 AT ROW 6.58 COL 55.57 COLON-ALIGNED NO-LABEL
     F-DIVISION-4 AT ROW 7.31 COL 49.14 COLON-ALIGNED
     F-NOMDIV-4 AT ROW 7.31 COL 55.57 COLON-ALIGNED NO-LABEL
     F-DIVISION-5 AT ROW 8.12 COL 49.14 COLON-ALIGNED
     F-NOMDIV-5 AT ROW 8.12 COL 55.57 COLON-ALIGNED NO-LABEL
     F-DIVISION-6 AT ROW 8.92 COL 49.14 COLON-ALIGNED
     F-NOMDIV-6 AT ROW 8.92 COL 55.57 COLON-ALIGNED NO-LABEL
     nCodMon AT ROW 10.88 COL 52.43 NO-LABEL
     Btn_OK AT ROW 11.96 COL 39
     Btn_Cancel AT ROW 11.96 COL 50.29
     Btn_Help AT ROW 11.96 COL 61.72
     Btn_Excel AT ROW 11.96 COL 26.86 WIDGET-ID 4
     " Desplegar Divisiones" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 4.38 COL 49
          FONT 6
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1.35 COL 4.43
          FONT 6
     "Evaluar Días" VIEW-AS TEXT
          SIZE 9.29 BY .5 AT ROW 10.46 COL 6.86
     " Moneda" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 10.31 COL 49.57
          FONT 6
     "Puede ingresar hasta 5 almacenes como máximo" VIEW-AS TEXT
          SIZE 40 BY .5 AT ROW 8 COL 4 WIDGET-ID 6
          FONT 6
     RECT-46 AT ROW 11.77 COL 2
     RECT-61 AT ROW 1.54 COL 2
     RECT-62 AT ROW 4.5 COL 47.29
     RECT-63 AT ROW 10.38 COL 47.29
     RECT-64 AT ROW 9.88 COL 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 73.86 BY 12.92
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
         TITLE              = "Ventas por Proveedor (x Division de Usuario)"
         HEIGHT             = 12.92
         WIDTH              = 73.86
         MAX-HEIGHT         = 12.92
         MAX-WIDTH          = 73.86
         VIRTUAL-HEIGHT     = 12.92
         VIRTUAL-WIDTH      = 73.86
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
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
/* SETTINGS FOR BUTTON BUTTON-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NOMDIV-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NOMDIV-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NOMDIV-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NOMDIV-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NOMDIV-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NOMDIV-6 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Ventas por Proveedor (x Division de Usuario) */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Ventas por Proveedor (x Division de Usuario) */
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
ON CHOOSE OF Btn_Excel IN FRAME F-Main /* Aceptar */
DO:
  RUN Asigna-Variables.
  RUN Valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR". 
  RUN Inhabilita.
  RUN Excel.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help W-Win
ON CHOOSE OF Btn_Help IN FRAME F-Main /* Ayuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
MESSAGE "Help for File: {&FILE-NAME}":U VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  RUN Asigna-Variables.
  RUN Valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR". 
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "".
    output-var-2 = "".
    RUN lkup\C-Famili02.r("Familias").
    IF output-var-2 <> ? THEN DO:
        F-CODFAM = output-var-2.
        DISPLAY F-CODFAM.
        IF NUM-ENTRIES(F-CODFAM) > 1 THEN ASSIGN 
        F-SUBFAM:SENSITIVE = FALSE
        F-SUBFAM:SCREEN-VALUE = ""
        BUTTON-2:SENSITIVE = FALSE.
        ELSE ASSIGN 
        F-SUBFAM:SENSITIVE = TRUE
        BUTTON-2:SENSITIVE = TRUE.
        APPLY "ENTRY" TO F-CODFAM .
        RETURN NO-APPLY.
    END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = F-CODFAM.
    output-var-2 = "".
    RUN lkup\C-SubFam02.r("SubFamilias").
    IF output-var-2 <> ? THEN DO:
        F-SUBFAM = output-var-2.
        DISPLAY F-SUBFAM.
        APPLY "ENTRY" TO F-SUBFAM .
        RETURN NO-APPLY.

        
    END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "MK".
    output-var-2 = "".
    RUN lkup\C-ALMTAB02.r("SubFamilias").
    IF output-var-2 <> ? THEN DO:
        F-MARCA = output-var-2.
        DISPLAY F-MARCA.
        APPLY "ENTRY" TO F-MARCA .
        RETURN NO-APPLY.

        
    END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "".
    output-var-2 = "".
    RUN lkup\C-provee02.r("Proveedores").
    IF output-var-2 <> ? THEN DO:
        F-PROV1 = output-var-2.
        DISPLAY F-PROV1.
        APPLY "ENTRY" TO F-PROV1 .
        RETURN NO-APPLY.

    END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 6 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "".
    output-var-2 = "".
    RUN lkup\C-Divis02.r("Divisiones").
    IF output-var-2 <> ? THEN DO:
        F-DIVISION = output-var-2.
        DISPLAY F-DIVISION.
        APPLY "ENTRY" TO F-DIVISION .
        RETURN NO-APPLY.

    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC W-Win
ON LEAVE OF DesdeC IN FRAME F-Main /* Articulo */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
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


&Scoped-define SELF-NAME F-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodFam W-Win
ON LEAVE OF F-CodFam IN FRAME F-Main /* Línea */
DO:
   ASSIGN F-CodFam.
   IF NUM-ENTRIES(F-CODFAM) > 1 THEN ASSIGN 
       F-SUBFAM:SENSITIVE = FALSE
       F-SUBFAM:SCREEN-VALUE = ""
       BUTTON-2:SENSITIVE = FALSE.
   ELSE ASSIGN
    F-SUBFAM:SENSITIVE = TRUE
    BUTTON-2:SENSITIVE = TRUE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DIVISION
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DIVISION W-Win
ON LEAVE OF F-DIVISION IN FRAME F-Main /* División */
DO:
 DO WITH FRAME {&FRAME-NAME}:

 ASSIGN F-DIVISION.
 IF F-DIVISION = ""  THEN DO:
     ENABLE F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6.  
     F-DIVISION-1 = "00001" .
     F-DIVISION-2 = "00002" .
     F-DIVISION-3 = "00003" .
     F-DIVISION-4 = "00000" .
     F-DIVISION-5 = "00005" .
     F-DIVISION-6 = "00006" .
     DISPLAY F-DIVISION-1 F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6 .
     RUN local-initialize.
     RETURN.
 END.

 IF F-DIVISION <> "" THEN DO:
        
        FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                           Gn-Divi.Coddiv = F-DIVISION NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Gn-Divi THEN DO:
            MESSAGE "Division " + F-DIVISION + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-DIVISION IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
        END.    

        F-DIVISION-1 = F-DIVISION .
        F-NOMDIV-1 = Gn-Divi.DesDiv.           
        F-DIVISION-2 = "" .
        F-DIVISION-3 = "" .
        F-DIVISION-4 = "" .
        F-DIVISION-5 = "" .
        F-DIVISION-6 = "" .
        F-NOMDIV-2   = "".
        F-NOMDIV-3   = "".
        F-NOMDIV-4   = "".
        F-NOMDIV-5   = "".
        F-NOMDIV-6   = "".
        DISPLAY F-NOMDIV-1 F-NOMDIV-2 F-NOMDIV-3 F-NOMDIV-4 F-NOMDIV-5 F-NOMDIV-6 
                F-DIVISION-1 F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6 
                WITH FRAME {&FRAME-NAME}.
        DISABLE F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6.
      
  END.
 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DIVISION-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DIVISION-1 W-Win
ON LEAVE OF F-DIVISION-1 IN FRAME F-Main /* 1 */
DO:
  ASSIGN F-DIVISION-1.
  IF SELF:SCREEN-VALUE = "" THEN DO:
      SELF:SCREEN-VALUE = "".
      F-NOMDIV-1 = "".
      DISPLAY "" @ F-NOMDIV-1 WITH FRAME {&FRAME-NAME}.
      RETURN.
  END.
  FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                     Gn-Divi.Coddiv = F-DIVISION-1 NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Gn-Divi THEN DO:
     MESSAGE "Division " + F-DIVISION-1 + " No Existe " SKIP
             "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY" TO F-DIVISION-1 IN FRAME {&FRAME-NAME}.
     RETURN NO-APPLY.
  END.    
  X-LLAVE = F-DIVISION-2 + "," 
          + F-DIVISION-3 + ","
          + F-DIVISION-4 + ","
          + F-DIVISION-5 + "," 
          + F-DIVISION-6.
  DO I = 1 TO NUM-ENTRIES(X-LLAVE):
    IF F-DIVISION-1 = ENTRY(I,X-LLAVE)  THEN DO:
      MESSAGE "Division " + ENTRY(I,X-LLAVE) + " Ya Existe " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-DIVISION-1 IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.                             
  END.

  
  F-NOMDIV-1 = Gn-Divi.DesDiv.
  DISPLAY Gn-Divi.DesDiv @ F-NOMDIV-1 WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DIVISION-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DIVISION-2 W-Win
ON LEAVE OF F-DIVISION-2 IN FRAME F-Main /* 2 */
DO:
  ASSIGN F-DIVISION-2.
  IF SELF:SCREEN-VALUE = "" THEN DO:
      SELF:SCREEN-VALUE = "".
      F-NOMDIV-2 = "".
      DISPLAY "" @ F-NOMDIV-2 WITH FRAME {&FRAME-NAME}.
      RETURN.
  END.
  FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                     Gn-Divi.Coddiv = F-DIVISION-2 NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Gn-Divi THEN DO:
     MESSAGE "Division " + F-DIVISION-2 + " No Existe " SKIP
             "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY" TO F-DIVISION-2 IN FRAME {&FRAME-NAME}.
     RETURN NO-APPLY.
  END.    
  
  X-LLAVE = F-DIVISION-1 + "," 
          + F-DIVISION-3 + ","
          + F-DIVISION-4 + ","
          + F-DIVISION-5 + "," 
          + F-DIVISION-6.
  DO I = 1 TO NUM-ENTRIES(X-LLAVE):
    IF F-DIVISION-2 = ENTRY(I,X-LLAVE)  THEN DO:
      MESSAGE "Division " + ENTRY(I,X-LLAVE) + " Ya Existe " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-DIVISION-2 IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.                             
  END.

  F-NOMDIV-2 = Gn-Divi.DesDiv.
  DISPLAY Gn-Divi.DesDiv @ F-NOMDIV-2 WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DIVISION-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DIVISION-3 W-Win
ON LEAVE OF F-DIVISION-3 IN FRAME F-Main /* 3 */
DO:
  ASSIGN F-DIVISION-3.
  IF SELF:SCREEN-VALUE = "" THEN DO:
     SELF:SCREEN-VALUE = "".
     F-NOMDIV-3 = "".
     DISPLAY "" @ F-NOMDIV-3 WITH FRAME {&FRAME-NAME}.
     RETURN.
  END.
  FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                     Gn-Divi.Coddiv = F-DIVISION-3 NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Gn-Divi THEN DO:
     MESSAGE "Division " + F-DIVISION-3 + " No Existe " SKIP
             "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY" TO F-DIVISION-3 IN FRAME {&FRAME-NAME}.
     RETURN NO-APPLY.
  END.    
  X-LLAVE = F-DIVISION-1 + "," 
          + F-DIVISION-2 + ","
          + F-DIVISION-4 + ","
          + F-DIVISION-5 + "," 
          + F-DIVISION-6.
  DO I = 1 TO NUM-ENTRIES(X-LLAVE):
    IF F-DIVISION-3 = ENTRY(I,X-LLAVE)  THEN DO:
      MESSAGE "Division " + ENTRY(I,X-LLAVE) + " Ya Existe " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-DIVISION-3 IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.                             
  END.
  
  F-NOMDIV-3 = Gn-Divi.DesDiv.
  DISPLAY Gn-Divi.DesDiv @ F-NOMDIV-3 WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DIVISION-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DIVISION-4 W-Win
ON LEAVE OF F-DIVISION-4 IN FRAME F-Main /* 4 */
DO:
  ASSIGN F-DIVISION-4.
  IF SELF:SCREEN-VALUE = "" THEN DO:
     SELF:SCREEN-VALUE = "".
     F-NOMDIV-4 = "".
     DISPLAY "" @ F-NOMDIV-4 WITH FRAME {&FRAME-NAME}.
     RETURN.
  END.
  FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                     Gn-Divi.Coddiv = F-DIVISION-4 NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Gn-Divi THEN DO:
     MESSAGE "Division " + F-DIVISION-4 + " No Existe " SKIP
             "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY" TO F-DIVISION-4 IN FRAME {&FRAME-NAME}.
     RETURN NO-APPLY.
  END.    
  X-LLAVE = F-DIVISION-1 + "," 
          + F-DIVISION-2 + ","
          + F-DIVISION-3 + ","
          + F-DIVISION-5 + "," 
          + F-DIVISION-6.
  DO I = 1 TO NUM-ENTRIES(X-LLAVE):
    IF F-DIVISION-4 = ENTRY(I,X-LLAVE)  THEN DO:
      MESSAGE "Division " + ENTRY(I,X-LLAVE) + " Ya Existe " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-DIVISION-4 IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.                             
  END.

  F-NOMDIV-4 = Gn-Divi.DesDiv.
  DISPLAY Gn-Divi.DesDiv @ F-NOMDIV-4 WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DIVISION-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DIVISION-5 W-Win
ON LEAVE OF F-DIVISION-5 IN FRAME F-Main /* 5 */
DO:
  ASSIGN F-DIVISION-5.
  IF SELF:SCREEN-VALUE = "" THEN DO:
     SELF:SCREEN-VALUE = "".
     F-NOMDIV-5 = "".
     DISPLAY "" @ F-NOMDIV-5 WITH FRAME {&FRAME-NAME}.
     RETURN.
  END.
  FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                     Gn-Divi.Coddiv = F-DIVISION-5 NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Gn-Divi THEN DO:
     MESSAGE "Division " + F-DIVISION-5 + " No Existe " SKIP
             "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY" TO F-DIVISION-5 IN FRAME {&FRAME-NAME}.
     RETURN NO-APPLY.
  END.
  X-LLAVE = F-DIVISION-1 + "," 
          + F-DIVISION-3 + ","
          + F-DIVISION-4 + ","
          + F-DIVISION-2 + "," 
          + F-DIVISION-6.
  DO I = 1 TO NUM-ENTRIES(X-LLAVE):
    IF F-DIVISION-5 = ENTRY(I,X-LLAVE)  THEN DO:
      MESSAGE "Division " + ENTRY(I,X-LLAVE) + " Ya Existe " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-DIVISION-5 IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.                             
  END.
  
  F-NOMDIV-5 = Gn-Divi.DesDiv.    
  DISPLAY Gn-Divi.DesDiv @ F-NOMDIV-5 WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DIVISION-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DIVISION-6 W-Win
ON LEAVE OF F-DIVISION-6 IN FRAME F-Main /* 6 */
DO:
  ASSIGN F-DIVISION-6.
  IF SELF:SCREEN-VALUE = "" THEN DO:
     SELF:SCREEN-VALUE = "".
     F-NOMDIV-6 = "".
     DISPLAY "" @ F-NOMDIV-6 WITH FRAME {&FRAME-NAME}.
     RETURN.
  END.
  FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                     Gn-Divi.Coddiv = F-DIVISION-6 NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Gn-Divi THEN DO:
     MESSAGE "Division " + F-DIVISION-6 + " No Existe " SKIP
             "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY" TO F-DIVISION-6 IN FRAME {&FRAME-NAME}.
     RETURN NO-APPLY.
  END.    
  X-LLAVE = F-DIVISION-1 + "," 
          + F-DIVISION-3 + ","
          + F-DIVISION-4 + ","
          + F-DIVISION-5 + "," 
          + F-DIVISION-2.
  DO I = 1 TO NUM-ENTRIES(X-LLAVE):
    IF F-DIVISION-6 = ENTRY(I,X-LLAVE)  THEN DO:
      MESSAGE "Division " + ENTRY(I,X-LLAVE) + " Ya Existe " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-DIVISION-6 IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.                             
  END.
  
  F-NOMDIV-6 = Gn-Divi.DesDiv.
  DISPLAY Gn-Divi.DesDiv @ F-NOMDIV-6 WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Marca W-Win
ON LEAVE OF F-Marca IN FRAME F-Main /* Marca */
DO:
   ASSIGN F-Marca.
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   IF F-Marca = "" THEN DO:
      SELF:SCREEN-VALUE = "".
      RETURN.
   END.
   FIND AlmTabla WHERE AlmTabla.Tabla = 'MK' 
                 AND  AlmTabla.Codigo = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE AlmTabla THEN DO:
      MESSAGE "Codigo de Marca no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-SubFam W-Win
ON LEAVE OF F-SubFam IN FRAME F-Main /* Sub-línea */
DO:
   ASSIGN F-CodFam.
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   IF F-CodFam = "" THEN DO:
      SELF:SCREEN-VALUE = "".
      RETURN.
   END.
   FIND AlmSFami WHERE AlmSFami.CodCia = S-CODCIA 
                  AND  AlmSFami.codfam = F-CodFam 
                  AND  AlmSFami.subfam = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE AlmSFami THEN DO:
      MESSAGE "Codigo de Sub-Familia no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC W-Win
ON LEAVE OF HastaC IN FRAME F-Main /* A */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
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


&Scoped-define SELF-NAME T-dias
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-dias W-Win
ON VALUE-CHANGED OF T-dias IN FRAME F-Main
DO:
  ASSIGN T-dias.

  IF T-DIAS THEN DIASINI:SENSITIVE = TRUE.
  ELSE DIASINI:SENSITIVE = FALSE.
  
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
         F-Division 
         F-Division-1 
         F-Division-2 
         F-Division-3
         F-Division-4 
         F-Division-5 
         F-Division-6
         F-Nomdiv-1
         F-Nomdiv-2
         F-Nomdiv-3
         F-Nomdiv-4
         F-Nomdiv-5
         F-Nomdiv-6
         F-CodFam 
         F-SubFam 
         F-Marca 
         F-prov1 
         DesdeC 
         HastaC 
         DesdeF 
         HastaF 
         nCodMon
         F-Almacen 
         T-dias
         Diasini
         Diasfin.
         
  X-ARTI        = "ARTICULOS    : " .
  X-FAMILIA     = "FAMILIA      : "  + F-CODFAM.
  X-SUBFAMILIA  = "SUBFAMILIA   : "  + F-SUBFAM .
  X-MARCA       = "MARCA        : "  + F-MARCA .
  X-PROVE       = "PROVEEDOR    : "  + F-PROV1.
  IF HastaC <> "" THEN  X-ARTI  =  X-ARTI + DesdeC + " al " + HastaC .
    
  IF HastaC = "" THEN HastaC = "999999999".
    
  S-SUBTIT =   "PERIODO      : " + STRING(DesdeF,"99/99/9999") + " al " + STRING(HastaF,"99/99/9999").

  X-MONEDA =   "MONEDA       : " + IF NCODMON = 1 THEN "NUEVOS SOLES " ELSE "DOLARES AMERICANOS ".  

  IF HastaC = "" THEN HastaC = "999999".
  IF DesdeF = ?  THEN DesdeF = 01/01/1900.
  IF HastaF = ?  THEN HastaF = 01/01/3000.

  IF F-DIVISION = "" THEN DO:
    X-CODDIV = "".
    /* CAPTURAMOS LAS DIVISIONES */
    IF F-DIVISION-1 <> ''
    THEN IF x-CodDiv = '' THEN x-CodDiv = F-DIVISION-1.
        ELSE x-CodDiv = x-CodDiv + ',' + F-DIVISION-1.
    IF F-DIVISION-2 <> ''
    THEN IF x-CodDiv = '' THEN x-CodDiv = F-DIVISION-2.
        ELSE x-CodDiv = x-CodDiv + ',' + F-DIVISION-2.
    IF F-DIVISION-3 <> ''
    THEN IF x-CodDiv = '' THEN x-CodDiv = F-DIVISION-3.
        ELSE x-CodDiv = x-CodDiv + ',' + F-DIVISION-3.
    IF F-DIVISION-4 <> ''
    THEN IF x-CodDiv = '' THEN x-CodDiv = F-DIVISION-4.
        ELSE x-CodDiv = x-CodDiv + ',' + F-DIVISION-4.
    IF F-DIVISION-5 <> ''
    THEN IF x-CodDiv = '' THEN x-CodDiv = F-DIVISION-5.
        ELSE x-CodDiv = x-CodDiv + ',' + F-DIVISION-5.
    IF F-DIVISION-6 <> ''
    THEN IF x-CodDiv = '' THEN x-CodDiv = F-DIVISION-1.
        ELSE x-CodDiv = x-CodDiv + ',' + F-DIVISION-6.
    IF x-CodDiv = '' THEN DO:
        FOR EACH Gn-Divi NO-LOCK WHERE Gn-Divi.Codcia = S-CODCIA:
            X-CODDIV = X-CODDIV + Gn-Divi.Coddiv + "," .
        END.
    END.
  END.
  ELSE DO:
    FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                      Gn-Divi.Coddiv = F-DIVISION NO-LOCK NO-ERROR.
    X-CODDIV = Gn-Divi.CodDiv.
  END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Stock-Almacen W-Win 
PROCEDURE Carga-Stock-Almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR X-DIA AS INTEGER NO-UNDO.

X-DIA = HastaF - DesdeF.

FOR EACH tmp-Tempo:
    DO I = 1 TO NUM-ENTRIES(F-Almacen) :
        FIND almmmate WHERE
            Almmmate.CodCia = tmp-Tempo.t-CodCia AND
            Almmmate.CodAlm = ENTRY(I,F-Almacen) AND
            Almmmate.codmat = tmp-Tempo.t-CodMat
            NO-LOCK NO-ERROR.
        IF AVAIL almmmate THEN DO: 
            t-stkact[i] = t-stkact[i] + Almmmate.StkAct.
            t-stkact[6] = t-stkact[6] + Almmmate.StkAct.
        END.
    END.
    IF T-Canti[10] = 0 THEN NEXT.
    IF T-dias THEN DO:
        t-nro_dia = (t-stkact[6]) / (T-Canti[10] / x-dia).
        IF t-nro_dia > diasfin or t-nro_dia < diasini then DELETE tmp-tempo. 
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-1 W-Win 
PROCEDURE Carga-Temporal-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR X-ENTRA AS LOGICAL INIT FALSE.
DEFINE VAR x-Item AS INT NO-UNDO.

/******* Inicializa la Tabla Temporal ******/
EMPTY TEMP-TABLE tmp-tempo.

DO x-Item = 1 TO NUM-ENTRIES(x-CodDiv):
    FOR EACH dwh_ventas_mat NO-LOCK WHERE dwh_ventas_mat.CodCia = S-CODCIA
        AND dwh_ventas_mat.coddiv = ENTRY(x-item, x-coddiv)
        AND (dwh_ventas_mat.codmat >= DesdeC AND dwh_ventas_mat.CodMat <= HastaC)
        AND dwh_ventas_mat.Fecha >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99") + STRING(DAY(DesdeF), "99"))
        AND dwh_ventas_mat.Fecha <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99") + STRING(DAY(HastaF), "99")),
        FIRST Almmmatg OF dwh_ventas_mat NO-LOCK WHERE Almmmatg.codfam BEGINS F-CodFam
        AND Almmmatg.subfam BEGINS F-Subfam
        AND Almmmatg.CodPr1 BEGINS F-prov1
        AND Almmmatg.Codmar BEGINS F-Marca:
        DISPLAY dwh_ventas_mat.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
            FORMAT "X(11)" WITH FRAME F-Proceso.
        ASSIGN
            T-Vtamn   = 0
            T-Vtame   = 0
            T-Ctomn   = 0
            T-Ctome   = 0
            F-Salida  = 0.
        ASSIGN
            F-Salida = dwh_ventas_mat.Cantidad
            T-VtaMn  = dwh_ventas_mat.ImpNacCIGV
            T-VtaMe  = dwh_ventas_mat.ImpExtCIGV
            T-CtoMn  = dwh_ventas_mat.CostoNacCIGV
            T-CtoMe  = dwh_ventas_mat.CostoExtCIGV.
        FIND tmp-tempo WHERE t-codcia  = S-CODCIA 
            AND t-codmat  = dwh_ventas_mat.codmat
            NO-ERROR.
        IF NOT AVAIL tmp-tempo THEN DO:
            CREATE tmp-tempo.
            ASSIGN 
                t-codcia  = S-CODCIA
                t-Clase   = Almmmatg.Clase
                t-codfam  = Almmmatg.codfam 
                t-subfam  = Almmmatg.subfam
                t-prove   = Almmmatg.CodPr1
                t-codmat  = dwh_ventas_mat.codmat
                t-desmat  = Almmmatg.DesMat
                t-desmar  = Almmmatg.DesMar
                t-undbas  = Almmmatg.UndBas
                t-CanEmp  = Almmmatg.CanEmp.
        END.
        ASSIGN 
            T-Canti[10] = T-Canti[10] + F-Salida 
            T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
            T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )
            T-Marge[10] = T-Marge[10] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame )
            T-Utili[10] = T-Utili[10] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
        /******************************Secuencia Para Cargar Datos en las Columnas *****************/
        X-ENTRA = FALSE.
        IF F-DIVISION-1 <> "" AND dwh_ventas_mat.Coddiv = F-DIVISION-1 THEN DO:
            ASSIGN 
                T-Canti[1] = T-Canti[1] + F-Salida 
                T-Venta[1] = T-venta[1] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[1] = T-Costo[1] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )
                T-Marge[1] = T-Marge[1] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame )
                T-Utili[1] = T-Utili[1] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome )
                X-ENTRA = TRUE.
        END.       
        IF F-DIVISION-2 <> "" AND dwh_ventas_mat.Coddiv = F-DIVISION-2 THEN DO:
            ASSIGN 
                T-Canti[2] = T-Canti[2] + F-Salida 
                T-Venta[2] = T-venta[2] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[2] = T-Costo[2] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )
                T-Marge[2] = T-Marge[2] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame )
                T-Utili[2] = T-Utili[2] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome )
                X-ENTRA = TRUE.
        END.       
        IF F-DIVISION-3 <> "" AND dwh_ventas_mat.Coddiv = F-DIVISION-3 THEN DO:
            ASSIGN 
                T-Canti[3] = T-Canti[3] + F-Salida 
                T-Venta[3] = T-venta[3] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[3] = T-Costo[3] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )
                T-Marge[3] = T-Marge[3] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame )
                T-Utili[3] = T-Utili[3] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome )
                X-ENTRA = TRUE.
        END.
        IF F-DIVISION-4 <> "" AND dwh_ventas_mat.Coddiv = F-DIVISION-4 THEN DO:
            ASSIGN 
                T-Canti[4] = T-Canti[4] + F-Salida  
                T-Venta[4] = T-venta[4] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[4] = T-Costo[4] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )
                T-Marge[4] = T-Marge[4] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame )
                T-Utili[4] = T-Utili[4] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome )
                X-ENTRA = TRUE.
        END.
        IF F-DIVISION-5 <> "" AND dwh_ventas_mat.Coddiv = F-DIVISION-5 THEN DO:
            ASSIGN 
                T-Canti[5] = T-Canti[5] + F-Salida 
                T-Venta[5] = T-venta[5] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[5] = T-Costo[5] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )
                T-Marge[5] = T-Marge[5] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame )
                T-Utili[5] = T-Utili[5] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome )
                X-ENTRA = TRUE.
        END.
        IF F-DIVISION-6 <> "" AND dwh_ventas_mat.Coddiv = F-DIVISION-6 THEN DO:
            ASSIGN 
                T-Canti[6] = T-Canti[6] + F-Salida 
                T-Venta[6] = T-venta[6] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[6] = T-Costo[6] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )
                T-Marge[6] = T-Marge[6] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame )
                T-Utili[6] = T-Utili[6] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome )
                X-ENTRA = TRUE.     
        END.
        IF NOT X-ENTRA THEN DO:
            ASSIGN 
                T-Canti[7] = T-Canti[7] + F-Salida 
                T-Venta[7] = T-venta[7] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[7] = T-Costo[7] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )
                T-Marge[7] = T-Marge[7] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame )
                T-Utili[7] = T-Utili[7] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome )
                X-ENTRA = TRUE. 
        END.
        /**************************************************************************/
    END.
END.

/* COSTO PROMEDIO */
FIND LAST Gn-tcmb WHERE Gn-tcmb.fecha <= TODAY NO-LOCK NO-ERROR.
FOR EACH tmp-tempo NO-LOCK,
        FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia 
            AND Almmmatg.codmat = t-codmat:
    IF Almmmatg.monvta = nCodMon
    THEN t-Costo[10] = Almmmatg.CtoTot.
    ELSE IF nCodMon = 1
        THEN t-Costo[10] = Almmmatg.CtoTot * gn-tcmb.venta.
        ELSE t-Costo[10] = Almmmatg.CtoTot / gn-tcmb.compra.

    t-Costo[10] = 0.
END.


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
  DISPLAY F-DIVISION F-CodFam F-SubFam F-Marca F-prov1 DesdeC HastaC DesdeF 
          HastaF F-Almacen T-dias DIASINI DIASFIN F-DIVISION-1 F-NOMDIV-1 
          F-DIVISION-2 F-NOMDIV-2 F-DIVISION-3 F-NOMDIV-3 F-DIVISION-4 
          F-NOMDIV-4 F-DIVISION-5 F-NOMDIV-5 F-DIVISION-6 F-NOMDIV-6 nCodMon 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 BUTTON-2 BUTTON-3 BUTTON-4 F-DIVISION F-CodFam F-SubFam 
         F-Marca F-prov1 DesdeC HastaC DesdeF HastaF F-Almacen T-dias DIASINI 
         DIASFIN F-DIVISION-1 F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 
         F-DIVISION-5 F-DIVISION-6 nCodMon Btn_OK Btn_Cancel Btn_Help Btn_Excel 
         RECT-61 RECT-62 RECT-63 RECT-64 
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
DEFINE VARIABLE t-Column                AS INTEGER.
DEFINE VARIABLE t-Letra                 AS INTEGER.

DEFINE VARIABLE j        AS INTEGER     NO-UNDO.
DEFINE VARIABLE x-codalm AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cFila1   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cFila2   AS CHARACTER   NO-UNDO.

RUN Carga-temporal-1.
RUN Carga-Stock-Almacen.


/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".

chWorkSheet:Range("B2"):Value = s-nomcia.
chWorkSheet:Range("B3"):Value = x-titu.
chWorkSheet:Range("B4"):Value = s-subtit.
chWorkSheet:Range("A5"):Value = "FAMILIA: " + x-familia.
chWorkSheet:Range("A6"):Value = "SUBFAMILIA: " + x-subfamilia.
chWorkSheet:Range("A7"):Value = "ARTICULOS: " + x-arti.
chWorkSheet:Range("C7"):Value = "MARCA: " + x-marca.
chWorkSheet:Range("A8"):Value = "PROVEEDOR: " + x-prove.
chWorkSheet:Range("C8"):Value = "MONEDA: " + x-moneda.
chWorkSheet:Range("A9"):Value = "DIVISIONES EVALUADAS: " + X-CODDIV.
chWorkSheet:Range("A10"):Value = "ALMACENES EVALUADOS: " + F-ALMACEN.

chWorkSheet:Range("J11"):Value = "Otras".
chWorkSheet:Range("K11"):Value = "Total".

chWorkSheet:Range("A12"):Value = "Codigo".
chWorkSheet:Range("B12"):Value = "Descripcion".
chWorkSheet:Range("C12"):Value = "Marca".
chWorkSheet:Range("D12"):Value = "Unidad".
chWorkSheet:Range("E12"):Value = "Cantidad".
chWorkSheet:Range("F12"):Value = "Cantidad".
chWorkSheet:Range("G12"):Value = "Cantidad".
chWorkSheet:Range("H12"):Value = "Cantidad".
chWorkSheet:Range("I12"):Value = "Cantidad".
chWorkSheet:Range("J12"):Value = "Cantidad".
chWorkSheet:Range("K12"):Value = "Importe".
/*Descripcion almacenes*/
cFila1 = "L".
cFila2 = "".
DO j = 1 TO NUM-ENTRIES(f-almacen):
    x-CodAlm = ENTRY(j, f-almacen).
    cRange = cFila1 + cFila2 + "12".
    chWorkSheet:Range(cRange):Value = "ALM " + x-CodAlm.
    IF cFila2 = "" THEN DO:
        cFila1 = CHR(ASC(cFila1) + 1).
        IF ASC(cFila1) > 90 THEN DO:
            cFila1 = "A".
            cFila2 = "A".
        END.
    END.
    ELSE DO:
        cFila2 = CHR(ASC(cFila2) + 1).
        IF ASC(cFila2) > 90 THEN DO:
            cFila1 = CHR(ASC(cFila1) + 1).
            cFila2 = "A".
        END.
    END.
END.

cRange = cFila1 + cFila2 + "12".
chWorkSheet:Range(cRange):Value = "Stock Total".

IF cFila2 = "" THEN DO:
    cFila1 = CHR(ASC(cFila1) + 1).
    IF ASC(cFila1) > 90 THEN DO:
        cFila1 = "A".
        cFila2 = "A".
    END.
END.
ELSE DO:
    cFila2 = CHR(ASC(cFila2) + 1).
    IF ASC(cFila2) > 90 THEN DO:
        cFila1 = CHR(ASC(cFila1) + 1).
        cFila2 = "A".
    END.
END.
cRange = cFila1 + cFila2 + "12".
chWorkSheet:Range(cRange):Value = "Dia".

IF cFila2 = "" THEN DO:
    cFila1 = CHR(ASC(cFila1) + 1).
    IF ASC(cFila1) > 90 THEN DO:
        cFila1 = "A".
        cFila2 = "A".
    END.
END.
ELSE DO:
    cFila2 = CHR(ASC(cFila2) + 1).
    IF ASC(cFila2) > 90 THEN DO:
        cFila1 = CHR(ASC(cFila1) + 1).
        cFila2 = "A".
    END.
END.
cRange = cFila1 + cFila2 + "12".
chWorkSheet:Range(cRange):Value = "Costo".
IF cFila2 = "" THEN DO:
    cFila1 = CHR(ASC(cFila1) + 1).
    IF ASC(cFila1) > 90 THEN DO:
        cFila1 = "A".
        cFila2 = "A".
    END.
END.
ELSE DO:
    cFila2 = CHR(ASC(cFila2) + 1).
    IF ASC(cFila2) > 90 THEN DO:
        cFila1 = CHR(ASC(cFila1) + 1).
        cFila2 = "A".
    END.
END.

cRange = cFila1 + cFila2 + "12".
chWorkSheet:Range(cRange):Value = "EMPA".

t-column = 13.

FOR EACH tmp-tempo BREAK BY t-codcia
    BY t-prove BY t-codfam 
    BY t-subfam BY t-codmat:

    DISPLAY t-CodMat @ Fi-Mensaje LABEL "Código de Artículo"
        FORMAT "X(11)" WITH FRAME F-Proceso.

    IF FIRST-OF(t-prove) THEN DO:
        FIND GN-PROV WHERE GN-PROV.CODCIA = pv-codcia 
            AND GN-PROV.CODPRO = t-prove NO-LOCK NO-ERROR.
        IF AVAILABLE GN-PROV THEN DO:
            t-column = t-column + 1.
            cColumn = STRING(t-Column).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = "PROVEEDOR: " + t-prove.
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = gn-prov.NomPro.
        END.  
    END.
    ACCUM  t-venta[10] (SUB-TOTAL BY t-prove).
    ACCUM  t-venta[10] ( TOTAL BY t-codcia).

    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = t-codmat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = t-DesMat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = t-DesMar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = t-UndBas.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = t-canti[1].
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = t-canti[2].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = t-canti[3].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = t-canti[4].
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = t-canti[7].
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = t-canti[10].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = t-venta[10].

    cFila1 = "L".
    cFila2 = "".
    DO j = 1 TO NUM-ENTRIES(f-almacen):
        x-CodAlm = ENTRY(j, f-almacen).
        cRange = cFila1 + cFila2 + cColumn.

        /* Costo no imprimir */
        IF cFila1 = "N" THEN t-stkact[j] = 0.
        chWorkSheet:Range(cRange):Value = t-stkact[j].

        IF cFila2 = "" THEN DO:
            cFila1 = CHR(ASC(cFila1) + 1).
            IF ASC(cFila1) > 90 THEN DO:
                cFila1 = "A".
                cFila2 = "A".
            END.
        END.
        ELSE DO:
            cFila2 = CHR(ASC(cFila2) + 1).
            IF ASC(cFila2) > 90 THEN DO:
                cFila1 = CHR(ASC(cFila1) + 1).
                cFila2 = "A".
            END.
        END.
    END.

    cRange = cFila1 + cFila2 + cColumn.
    chWorkSheet:Range(cRange):Value = t-stkact[6].

    IF cFila2 = "" THEN DO:
        cFila1 = CHR(ASC(cFila1) + 1).
        IF ASC(cFila1) > 90 THEN DO:
            cFila1 = "A".
            cFila2 = "A".
        END.
    END.
    ELSE DO:
        cFila2 = CHR(ASC(cFila2) + 1).
        IF ASC(cFila2) > 90 THEN DO:
            cFila1 = CHR(ASC(cFila1) + 1).
            cFila2 = "A".
        END.
    END.
    cRange = cFila1 + cFila2 + cColumn.
    chWorkSheet:Range(cRange):Value = t-nro_dia.

    IF cFila2 = "" THEN DO:
        cFila1 = CHR(ASC(cFila1) + 1).
        IF ASC(cFila1) > 90 THEN DO:
            cFila1 = "A".
            cFila2 = "A".
        END.
    END.
    ELSE DO:
        cFila2 = CHR(ASC(cFila2) + 1).
        IF ASC(cFila2) > 90 THEN DO:
            cFila1 = CHR(ASC(cFila1) + 1).
            cFila2 = "A".
        END.
    END.
    cRange = cFila1 + cFila2 + cColumn.
    chWorkSheet:Range(cRange):Value = t-costo[10].
    IF cFila2 = "" THEN DO:
        cFila1 = CHR(ASC(cFila1) + 1).
        IF ASC(cFila1) > 90 THEN DO:
            cFila1 = "A".
            cFila2 = "A".
        END.
    END.
    ELSE DO:
        cFila2 = CHR(ASC(cFila2) + 1).
        IF ASC(cFila2) > 90 THEN DO:
            cFila1 = CHR(ASC(cFila1) + 1).
            cFila2 = "A".
        END.
    END.

    cRange = cFila1 + cFila2 + cColumn.
    chWorkSheet:Range(cRange):Value = t-CanEmp.

    IF LAST-OF(t-prove) THEN DO:
        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = "------------------".

        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = ("TOTAL PROVEEDOR : " + t-prove).
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY t-prove t-venta[10]).
    END.
    IF LAST-OF(t-codcia) THEN DO:
        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = "------------------".

        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = ("TOTAL COMPAÑIA : " ).
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL BY t-codcia t-venta[10]).
    END.
END.


/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

HIDE FRAME F-PROCESO.

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

    DEFINE FRAME F-REPORTE
        t-codmat     AT 1
        t-DesMat     FORMAT "X(35)"
        t-DesMar     FORMAT "X(6)" 
        t-UndBas     FORMAT "X(4)"      
        t-canti[1]   FORMAT "->>>>>>9"
        t-canti[2]   FORMAT "->>>>>>9"
        t-canti[3]   FORMAT "->>>>>>9"
        t-canti[4]   FORMAT "->>>>>>9"
        t-canti[7]   FORMAT "->>>>>>9"
        t-canti[10]  FORMAT "->>>>>>9.99"
        t-venta[10]  FORMAT "->>>>>>9.99"
        t-stkact[6]  FORMAT "->>>>>>9.99"        
        t-nro_dia    FORMAT ">>>9"
        t-costo[10]  FORMAT ">>>9.9999"
        t-CanEmp     FORMAT ">>>9"
        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

    DEFINE FRAME F-HEADER
        HEADER
        S-NOMCIA FORMAT "X(50)" AT 1 SKIP
         X-TITU  AT 40 FORMAT "X(50)" SKIP
        S-SUBTIT AT 1  FORMAT "X(60)" 
        "Pagina : " TO 135 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        X-FAMILIA  AT 1  FORMAT "X(60)" 
        "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
        X-SUBFAMILIA AT 1  FORMAT "X(60)" 
        "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
        X-ARTI   AT 1  FORMAT "X(60)" 
        X-MARCA  AT 80  FORMAT "X(60)" SKIP
        X-PROVE  AT 1  FORMAT "X(60)" 
        X-MONEDA AT 80  FORMAT "X(60)" SKIP
        "DIVISIONES EVALUADAS  : " + X-CODDIV   At 1 FORMAT "X(150)" SKIP
        "ALMACENES EVALUADOS  : " + F-ALMACEN   At 1 FORMAT "X(150)" SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  60
        F-DIVISION-2 AT  69
        F-DIVISION-3 AT  78
        F-DIVISION-4 AT  87
        "OTROS"  AT  96
        "T O T A L"  AT  105 SKIP
        " CODIGO  D E S C R I P C I O N           MARCA   U.M     CANT      CANT     CANT     CANT     CANT     CANT       IMPORTE      STOCK   DIAS  COSTO    EMPA" SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN.

    PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

    FOR EACH tmp-tempo BREAK
        BY t-codcia
        BY t-prove
        BY t-codfam 
        BY t-subfam 
        BY t-codmat:

    DISPLAY t-CodMat @ Fi-Mensaje LABEL "Código de Artículo"
        FORMAT "X(11)" WITH FRAME F-Proceso.

    VIEW STREAM REPORT FRAME F-HEADER.

    IF FIRST-OF(t-prove) THEN DO:
        FIND GN-PROV WHERE
            GN-PROV.CODCIA = pv-codcia AND
            GN-PROV.CODPRO = t-prove 
            NO-LOCK NO-ERROR.
        IF AVAILABLE GN-PROV THEN DO:
            PUT STREAM REPORT " " SKIP.
            PUT STREAM REPORT
                "PROVEEDOR : " FORMAT "X(20)" AT 1
                t-prove         FORMAT "X(15)" AT 25
                gn-prov.NomPro  FORMAT "X(40)" AT 45 SKIP.
            PUT STREAM REPORT '------------------------------------------' FORMAT "X(50)" SKIP.
        END.  
    END.

    DOWN STREAM REPORT WITH FRAME F-REPORTE.

    ACCUM  t-venta[10] (SUB-TOTAL BY t-prove).
    ACCUM  t-venta[10] ( TOTAL BY t-codcia).
        
    DISPLAY STREAM REPORT
        t-codmat
        t-DesMat
        t-DesMar
        t-UndBas
        t-canti[1] WHEN  t-canti[1] <> 0 FORMAT "->>>>>>9"
        t-canti[2] WHEN  t-canti[2] <> 0 FORMAT "->>>>>>9"
        t-canti[3] WHEN  t-canti[3] <> 0 FORMAT "->>>>>>9"
        t-canti[4] WHEN  t-canti[4] <> 0 FORMAT "->>>>>>9"
        t-canti[7] WHEN  t-canti[7] <> 0 FORMAT "->>>>>>9"
        t-canti[10]  FORMAT "->>>>>>9.99"      
        t-venta[10]  FORMAT "->>>>>>9.99" 
        t-stkact[6]  FORMAT "->>>>>>9.99"        
        t-nro_dia    FORMAT ">>>>9"
        /*t-costo[10]*/
        t-CanEmp        
        WITH FRAME F-REPORTE.
    DOWN STREAM REPORT WITH FRAME F-REPORTE.

    IF LAST-OF(t-prove) THEN DO:
        UNDERLINE STREAM REPORT
            t-venta[10]
            WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL PROVEEDOR : " + t-prove) @ t-desmat
            (ACCUM SUB-TOTAL BY t-prove t-venta[10]) @ t-venta[10] 
            WITH FRAME F-REPORTE.        
    END.
    IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[10]
            WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL COMPAÑIA : " ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-venta[10]) @ t-venta[10] 
            WITH FRAME F-REPORTE.        
    END.
END.
HIDE FRAME F-PROCESO.

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
    ENABLE ALL EXCEPT F-NOMDIV-1 F-NOMDIV-2 F-NOMDIV-3 F-NOMDIV-4 F-NOMDIV-5 F-NOMDIV-6
                      F-DIVISION F-DIVISION-1 F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6
                      BUTTON-5.

     IF T-DIAS THEN 
        ASSIGN
        DIASFIN:SENSITIVE = TRUE
        DIASINI:SENSITIVE = TRUE.
     ELSE 
       ASSIGN
       DIASFIN:SENSITIVE = FALSE
       DIASINI:SENSITIVE = FALSE.

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

    RUN Carga-temporal-1.
    RUN Carga-Stock-Almacen.

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
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inicializa-Variables W-Win 
PROCEDURE Inicializa-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN 
         F-Division
         F-Division-1 
         F-Division-2 
         F-Division-3
         F-Division-4 
         F-Division-5 
         F-Division-6
         F-Nomdiv-1
         F-Nomdiv-2
         F-Nomdiv-3
         F-Nomdiv-4
         F-Nomdiv-5
         F-Nomdiv-6
         F-CodFam 
         F-SubFam 
         F-Marca 
         F-prov1 
         DesdeC 
         HastaC 
         DesdeF 
         HastaF 
         nCodMon 
         F-Almacen
         T-dias
         Diasfin
         Diasini.
  
  IF HastaC <> "" THEN HastaC = "".
  IF DesdeF <> ?  THEN DesdeF = ?.
  IF HastaF <> ?  THEN HastaF = ?.
     IF T-DIAS THEN 
        ASSIGN
        DIASFIN:SENSITIVE = TRUE
        DIASINI:SENSITIVE = TRUE.
     ELSE 
       ASSIGN
       DIASFIN:SENSITIVE = FALSE
       DIASINI:SENSITIVE = FALSE.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
     IF T-DIAS THEN DIASINI:SENSITIVE = TRUE.
     ELSE DIASINI:SENSITIVE = FALSE.

     /* Ic 20-Jul-2012 */

     ASSIGN F-DIVISION = 'XXXX'.

     FIND FIRST FacUsers WHERE FacUsers.codcia = S-CODCIA AND FacUsers.usuario = S-USER-ID NO-LOCK NO-ERROR.
     IF AVAILABLE FacUsers THEN
            ASSIGN F-DIVISION = FacUsers.CodDiv.

     DISPLAY F-DIVISION.

     FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                        Gn-Divi.Coddiv = F-DIVISION NO-LOCK NO-ERROR.
     IF NOT AVAILABLE Gn-Divi THEN DO:
         MESSAGE "Division " + F-DIVISION + " No Existe " SKIP
                 "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO F-DIVISION IN FRAME {&FRAME-NAME}.
         RETURN NO-APPLY.
     END.    

     F-DIVISION-1 = F-DIVISION .
     F-NOMDIV-1 = Gn-Divi.DesDiv.           
     F-DIVISION-2 = "" .
     F-DIVISION-3 = "" .
     F-DIVISION-4 = "" .
     F-DIVISION-5 = "" .
     F-DIVISION-6 = "" .
     F-NOMDIV-2   = "".
     F-NOMDIV-3   = "".
     F-NOMDIV-4   = "".
     F-NOMDIV-5   = "".
     F-NOMDIV-6   = "".
     DISPLAY F-NOMDIV-1 F-NOMDIV-2 F-NOMDIV-3 F-NOMDIV-4 F-NOMDIV-5 F-NOMDIV-6 
             F-DIVISION-1 F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6.

     DISABLE F-DIVISION-1 F-DIVISION.
     DISABLE F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6.

     /* Ic 20-Jul-2012 */

     ASSIGN DesdeF = TODAY  + 1 - DAY(TODAY).
            HastaF = TODAY.
            F-DIVISION.
            F-DIVISION-1.
            F-DIVISION-2.
            F-DIVISION-3.
            F-DIVISION-1.
            F-DIVISION-4.
            F-DIVISION-5.
            F-DIVISION-6.
    /*
          FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                             Gn-Divi.Coddiv = F-DIVISION-1 NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Divi THEN DO:
            MESSAGE "Division " + F-DIVISION-1 + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-DIVISION-1 IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.    
          DISPLAY Gn-Divi.DesDiv @ F-NOMDIV-1.

          FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                             Gn-Divi.Coddiv = F-DIVISION-2 NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Divi THEN DO:
            MESSAGE "Division " + F-DIVISION-2 + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-DIVISION-1 IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.    
          DISPLAY Gn-Divi.DesDiv @ F-NOMDIV-2.

          FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                             Gn-Divi.Coddiv = F-DIVISION-3 NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Divi THEN DO:
            MESSAGE "Division " + F-DIVISION-3 + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-DIVISION-1 IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.    
          DISPLAY Gn-Divi.DesDiv @ F-NOMDIV-3.

          FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                             Gn-Divi.Coddiv = F-DIVISION-4 NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Divi THEN DO:
            MESSAGE "Division " + F-DIVISION-4 + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-DIVISION-4 IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.    
          DISPLAY Gn-Divi.DesDiv @ F-NOMDIV-4 .
          
          FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                             Gn-Divi.Coddiv = F-DIVISION-5 NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Divi THEN DO:
            MESSAGE "Division " + F-DIVISION-5 + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-DIVISION-5 IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.    
          DISPLAY Gn-Divi.DesDiv @ F-NOMDIV-5.
          
          FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                             Gn-Divi.Coddiv = F-DIVISION-6 NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Divi THEN DO:
            MESSAGE "Division " + F-DIVISION-6 + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-DIVISION-6 IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.    
          DISPLAY Gn-Divi.DesDiv @ F-NOMDIV-6.
    */



     DISPLAY DesdeF HastaF  .

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
        WHEN "F-Subfam" THEN ASSIGN input-var-1 = F-CodFam:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida W-Win 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF F-DIVISION <> "" THEN DO:
        DO I = 1 TO NUM-ENTRIES(F-DIVISION):
          FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                             Gn-Divi.Coddiv = ENTRY(I,F-DIVISION) NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Divi THEN DO:
            MESSAGE "Division " + ENTRY(I,F-DIVISION) + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-DIVISION IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.                             
        END.
END.

IF F-CODFAM <> "" THEN DO:
        DO I = 1 TO NUM-ENTRIES(F-CODFAM):
          FIND AlmtFami WHERE AlmtFami.Codcia = S-CODCIA AND
                              AlmtFami.CodFam = ENTRY(I,F-CODFAM) NO-LOCK NO-ERROR.
          IF NOT AVAILABLE AlmtFami THEN DO:
            MESSAGE "Familia " + ENTRY(I,F-CODFAM) + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-CODFAM IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.                             
        END.
END.


IF F-PROV1 <> "" THEN DO:
  DO I = 1 TO NUM-ENTRIES(F-PROV1):
          FIND GN-PROV WHERE GN-PROV.CODCIA = pv-codcia AND 
                             GN-PROV.CODPRO = ENTRY(I,F-PROV1) NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Prov THEN DO:
            MESSAGE "Proveedor " + ENTRY(I,F-PROV1) + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-PROV1 IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.                             
  END.

END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

