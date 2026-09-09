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

DEFINE        VAR C-OP     AS CHAR.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE        VAR F-PESALM AS DECIMAL NO-UNDO.
DEFINE SHARED VAR S-CODDIV AS CHARACTER.

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
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
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



DEFINE TEMP-TABLE tmp-tempo 
    FIELD t-codcia  LIKE Almdmov.Codcia 
    FIELD t-clase   LIKE Almmmatg.clase
    FIELD t-codfam  LIKE Almmmatg.codfam 
    FIELD t-subfam  LIKE Almmmatg.subfam
    FIELD t-prove   LIKE Almmmatg.CodPr1
    FIELD t-codmat  LIKE Almdmov.codmat
    FIELD t-desmat  LIKE Almmmatg.DesMat    FORMAT "X(40)"
    FIELD t-desmar  LIKE Almmmatg.DesMar    FORMAT "X(8)"
    FIELD t-undbas  LIKE Almmmatg.UndBas    FORMAT "X(8)"
    FIELD t-stkact  LIKE Almmmate.StkAct    FORMAT "->>>>>,>>9.99"
    FIELD t-ventamn AS DEC           FORMAT "->>>>>>>9.99" 
    FIELD t-ventame AS DEC           FORMAT "->>>>>>>9.99"
    FIELD t-costome AS DEC           FORMAT "->>>>>>>9.99"
    FIELD t-costomn AS DEC           FORMAT "->>>>>>>9.99"
    FIELD t-venta   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99"  
    FIELD t-costo   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99"  
    FIELD t-canti   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99" 
    FIELD t-marge   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99"  
    FIELD t-utili   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99"  .

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
&Scoped-Define ENABLED-OBJECTS RECT-61 RECT-58 RECT-63 RECT-62 F-DIVISION ~
BUTTON-5 C-tipo F-CodFam BUTTON-1 C-tipo-2 F-SubFam BUTTON-2 F-Marca ~
BUTTON-3 F-prov1 BUTTON-4 F-DIVISION-1 F-DIVISION-2 FILL-IN-file ~
BUTTON-file F-DIVISION-3 x-CodMat F-DIVISION-4 F-DIVISION-5 F-DIVISION-6 ~
DesdeF HastaF nCodMon Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS F-DIVISION C-tipo F-CodFam C-tipo-2 ~
F-SubFam F-Marca F-prov1 F-DIVISION-1 F-NOMDIV-1 F-DIVISION-2 F-NOMDIV-2 ~
FILL-IN-file F-NOMDIV-3 F-DIVISION-3 x-CodMat F-DIVISION-4 F-NOMDIV-4 ~
F-DIVISION-5 F-NOMDIV-5 F-DIVISION-6 F-NOMDIV-6 DesdeF HastaF nCodMon 

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
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 1" 
     SIZE 4.43 BY .77.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 2" 
     SIZE 4.43 BY .77.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 3" 
     SIZE 4.43 BY .77.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 4" 
     SIZE 4.43 BY .77.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 6" 
     SIZE 4.43 BY .77.

DEFINE BUTTON BUTTON-file 
     LABEL "..." 
     SIZE 3 BY .81 TOOLTIP "Archivo".

DEFINE VARIABLE C-tipo AS CHARACTER FORMAT "X(20)":U INITIAL "Prove-Articulo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Prove-Articulo","Linea-Sublinea","Resumen-Proveedor","Resumen-Sublinea","Resumen-Linea","Articulo" 
     DROP-DOWN-LIST
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE C-tipo-2 AS CHARACTER FORMAT "X(20)":U INITIAL "Cantidad" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Cantidad","Venta","Costo","Margen","Utilidad" 
     DROP-DOWN-LIST
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE x-CodMat AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 32.43 BY 3.27 TOOLTIP "Ej: 004444,000150,004445" NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Linea" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-DIVISION AS CHARACTER FORMAT "X(5)":U 
     LABEL "Division" 
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
     LABEL "Sub-linea" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-file AS CHARACTER FORMAT "X(256)":U 
     LABEL "Archivo" 
     VIEW-AS FILL-IN 
     SIZE 26 BY .81 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dolares", 2
     SIZE 16.72 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72 BY 1.88
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.86 BY 2.77.

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 10.23
     BGCOLOR 3 .

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.86 BY 5.73.

DEFINE RECTANGLE RECT-63
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27 BY 1.35.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-DIVISION AT ROW 1.96 COL 12 COLON-ALIGNED
     BUTTON-5 AT ROW 1.96 COL 25.72
     C-tipo AT ROW 2.19 COL 49.43 COLON-ALIGNED HELP
          "coloque el codigo" NO-LABEL
     F-CodFam AT ROW 2.69 COL 12 COLON-ALIGNED
     BUTTON-1 AT ROW 2.69 COL 25.57
     C-tipo-2 AT ROW 3.15 COL 49.43 COLON-ALIGNED NO-LABEL
     F-SubFam AT ROW 3.46 COL 12 COLON-ALIGNED
     BUTTON-2 AT ROW 3.46 COL 25.57
     F-Marca AT ROW 4.19 COL 12 COLON-ALIGNED
     BUTTON-3 AT ROW 4.19 COL 25.57
     F-prov1 AT ROW 5 COL 12 COLON-ALIGNED
     BUTTON-4 AT ROW 5 COL 25.57
     F-DIVISION-1 AT ROW 5.08 COL 49.14 COLON-ALIGNED
     F-NOMDIV-1 AT ROW 5.12 COL 55.57 COLON-ALIGNED NO-LABEL
     F-DIVISION-2 AT ROW 5.81 COL 49.14 COLON-ALIGNED
     F-NOMDIV-2 AT ROW 5.85 COL 55.57 COLON-ALIGNED NO-LABEL
     FILL-IN-file AT ROW 6 COL 12 COLON-ALIGNED
     BUTTON-file AT ROW 6 COL 40
     F-NOMDIV-3 AT ROW 6.58 COL 55.57 COLON-ALIGNED NO-LABEL
     F-DIVISION-3 AT ROW 6.62 COL 49.14 COLON-ALIGNED
     x-CodMat AT ROW 6.96 COL 14 NO-LABEL
     F-DIVISION-4 AT ROW 7.31 COL 49.14 COLON-ALIGNED
     F-NOMDIV-4 AT ROW 7.31 COL 55.57 COLON-ALIGNED NO-LABEL
     F-DIVISION-5 AT ROW 8.12 COL 49.14 COLON-ALIGNED
     F-NOMDIV-5 AT ROW 8.12 COL 55.57 COLON-ALIGNED NO-LABEL
     F-DIVISION-6 AT ROW 8.92 COL 49.14 COLON-ALIGNED
     F-NOMDIV-6 AT ROW 8.92 COL 55.57 COLON-ALIGNED NO-LABEL
     DesdeF AT ROW 10.42 COL 11 COLON-ALIGNED
     HastaF AT ROW 10.5 COL 32.72 COLON-ALIGNED
     nCodMon AT ROW 11 COL 52.14 NO-LABEL
     Btn_OK AT ROW 12.12 COL 39
     Btn_Cancel AT ROW 12.12 COL 50.29
     Btn_Help AT ROW 12.12 COL 61.72
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1.35 COL 4.43
          FONT 6
     " Desplegar Divisiones" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 4.38 COL 49
          FONT 6
     "Materiales:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 7.15 COL 6
     " Tipo de Reporte" VIEW-AS TEXT
          SIZE 14.57 BY .65 AT ROW 1.27 COL 48.43
          FONT 6
     "Moneda" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 10.42 COL 49.29
          FONT 6
     RECT-61 AT ROW 1.54 COL 2
     RECT-58 AT ROW 1.54 COL 47.43
     RECT-46 AT ROW 11.96 COL 2
     RECT-63 AT ROW 10.42 COL 47
     RECT-62 AT ROW 4.5 COL 47.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 73.86 BY 13.04
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
         TITLE              = "Ventas Totales"
         HEIGHT             = 13.04
         WIDTH              = 73.86
         MAX-HEIGHT         = 13.04
         MAX-WIDTH          = 73.86
         VIRTUAL-HEIGHT     = 13.04
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
   FRAME-NAME                                                           */
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
ON END-ERROR OF W-Win /* Ventas Totales */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Ventas Totales */
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


&Scoped-define SELF-NAME BUTTON-file
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-file W-Win
ON CHOOSE OF BUTTON-file IN FRAME F-Main /* ... */
DO:

    DEFINE VARIABLE filename AS CHARACTER NO-UNDO.
    DEFINE VARIABLE OKpressed AS LOGICAL INITIAL TRUE.

    SYSTEM-DIALOG GET-FILE filename
        TITLE      "Seleccione Archivo..."
        FILTERS    "Texto (*.txt)"   "*.txt",
                    "Todos (*.*)"     "*.*"
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = TRUE THEN DO:
        FILL-IN-file:SCREEN-VALUE = filename.
        RUN proc_charge-list(filename).
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-tipo W-Win
ON VALUE-CHANGED OF C-tipo IN FRAME F-Main
DO:
  DO WITH FRAME {&FRAME-NAME}:

  ASSIGN C-TIPO.
  IF C-TIPO = "Resumen-Proveedor" OR C-TIPO = "Resumen-Sublinea" THEN DO:
      F-DIVISION-1 = "".
      F-DIVISION-2 = "" .
      F-DIVISION-3 = "" .
      F-DIVISION-4 = "" .
      F-DIVISION-5 = "" .
      F-DIVISION-6 = "" .
      F-NOMDIV-1 = "".
      F-NOMDIV-2   = "".
      F-NOMDIV-3   = "".
      F-NOMDIV-4   = "".
      F-NOMDIV-5   = "".
      F-NOMDIV-6   = "".
      DISPLAY F-NOMDIV-1 F-NOMDIV-2 F-NOMDIV-3 F-NOMDIV-4 F-NOMDIV-5 F-NOMDIV-6 
              F-DIVISION-1 F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6 .       
      DISABLE F-DIVISION-1 F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6.
  END.
  ELSE DO:
     ENABLE F-DIVISION-1 F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6.  
     F-DIVISION   = "".
     F-DIVISION-1 = "00001" .
     F-DIVISION-2 = "00002" .
     F-DIVISION-3 = "00003" .
     F-DIVISION-4 = "00000" .
     F-DIVISION-5 = "00005" .
     F-DIVISION-6 = "00006" .
     DISPLAY F-DIVISION F-DIVISION-1 F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6 .
     RUN local-initialize.

  
  END.


  END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-tipo-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-tipo-2 W-Win
ON VALUE-CHANGED OF C-tipo-2 IN FRAME F-Main
DO:
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN C-TIPO-2 .  
  END.
    
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodFam W-Win
ON LEAVE OF F-CodFam IN FRAME F-Main /* Linea */
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
ON LEAVE OF F-DIVISION IN FRAME F-Main /* Division */
DO:
 DO WITH FRAME {&FRAME-NAME}:

 ASSIGN F-DIVISION.
 IF F-DIVISION = "" AND ( LOOKUP(C-TIPO,"Resumen-Proveedor,Resumen-Sublinea") = 0 ) THEN DO:
     SELF:SCREEN-VALUE = "".
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
        IF  LOOKUP(C-TIPO,"Resumen-Proveedor,Resumen-Sublinea") = 0  THEN DO:                         
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
ON LEAVE OF F-SubFam IN FRAME F-Main /* Sub-linea */
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


&Scoped-define SELF-NAME FILL-IN-file
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-file W-Win
ON LEAVE OF FILL-IN-file IN FRAME F-Main /* Archivo */
DO:
    RUN proc_charge-list(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodMat W-Win
ON LEFT-MOUSE-DBLCLICK OF x-CodMat IN FRAME F-Main
DO:
  DEF VAR x-Codigos AS CHAR NO-UNDO.

  RUN vta/d-selmat (OUTPUT x-Codigos).
  IF x-Codigos <> '' THEN DO:
    IF SELF:SCREEN-VALUE = ''
    THEN SELF:SCREEN-VALUE = x-Codigos.
    ELSE SELF:SCREEN-VALUE = TRIM(SELF:SCREEN-VALUE) + ',' + x-Codigos.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables W-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN C-tipo
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
         x-CodMat
         DesdeF 
         HastaF 
         nCodMon
         C-tipo-2 .
  X-ARTI        = "ARTICULOS    : " .
  X-FAMILIA     = "FAMILIA      : "  + F-CODFAM.
  X-SUBFAMILIA  = "SUBFAMILIA   : "  + F-SUBFAM .
  X-MARCA       = "MARCA        : "  + F-MARCA .
  X-PROVE       = "PROVEEDOR    : "  + F-PROV1.
  IF x-CodMat <> "" THEN  X-ARTI  =  X-ARTI + x-CodMat .
    
  S-SUBTIT =   "PERIODO      : " + STRING(DesdeF,"99/99/9999") + " al " + STRING(HastaF,"99/99/9999").

  X-MONEDA =   "MONEDA       : " + IF NCODMON = 1 THEN "NUEVOS SOLES " ELSE "DOLARES AMERICANOS ".  

  IF DesdeF = ?  THEN DesdeF = 01/01/1900.
  IF HastaF = ?  THEN HastaF = 01/01/3000.

  IF F-DIVISION = "" THEN DO:
    X-CODDIV = "".
    FOR EACH Gn-Divi NO-LOCK WHERE Gn-Divi.Codcia = S-CODCIA:
/*        X-CODDIV = X-CODDIV + SUBSTRING(Gn-Divi.Desdiv,1,10) + "," .*/
        X-CODDIV = X-CODDIV + Gn-Divi.Coddiv + "," .
    END.
  END.
  ELSE DO:
   FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                      Gn-Divi.Coddiv = F-DIVISION NO-LOCK NO-ERROR.
/*   X-CODDIV = SUBSTRING(Gn-Divi.Desdiv,1,20) + "," . */
   X-CODDIV = Gn-Divi.CodDiv + "," .
  END.
  
  
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BAckup W-Win 
PROCEDURE BAckup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
DEFINE VAR X-ENTRA AS LOGICAL INIT FALSE.

/*******Inicializa la Tabla Temporal ******/
FOR EACH tmp-tempo :
  DELETE tmp-tempo.
END.
/********************************/


FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = S-CODCIA
                           AND  Almmmatg.codfam BEGINS F-CodFam
                           AND  Almmmatg.subfam BEGINS F-Subfam
                           AND  (Almmmatg.codmat >= DesdeC
                           AND   Almmmatg.CodMat <= HastaC)
                           AND  Almmmatg.CodPr1 BEGINS F-prov1
                           AND  Almmmatg.Codmar BEGINS F-Marca
                          USE-INDEX matg09,
    EACH Evtarti NO-LOCK WHERE Evtarti.CodCia = S-CODCIA
                         AND   Evtarti.CodDiv BEGINS F-DIVISION
                         AND   Evtarti.Codmat = Almmmatg.codmat
                         /* AND   (Evtarti.CodAno >= YEAR(DesdeF) 
                         AND   Evtarti.Codano <= YEAR(HastaF))
                         AND   Evtarti.CodMes >= MONTH(DesdeF) */
                         BREAK BY Almmmatg.codcia
                               BY Almmmatg.codmat :
                         

      DISPLAY Evtarti.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      
      T-Vtamn   = 0.
      T-Vtame   = 0.
      T-Ctomn   = 0.
      T-Ctome   = 0.
      F-Salida  = 0.


      /*********************** Calculo Para Obtener los datos diarios ************/
      IF YEAR(DesdeF) = YEAR(HastaF) AND MONTH(DesdeF) = MONTH(HastaF) THEN DO:
        DO I = DAY(DesdeF)  TO DAY(HastaF) :
          FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")) NO-LOCK NO-ERROR.
          IF AVAILABLE Gn-tcmb THEN DO: 
            F-Salida  = F-Salida  + Evtarti.CanxDia[I].
            T-Vtamn   = T-Vtamn   + Evtarti.Vtaxdiamn[I] + Evtarti.Vtaxdiame[I] * Gn-Tcmb.Venta.
            T-Vtame   = T-Vtame   + Evtarti.Vtaxdiame[I] + Evtarti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
          END.
        END.
      END.
      ELSE DO:
        X-ENTRA = FALSE.
        IF Evtarti.Codano = YEAR(DesdeF) AND Evtarti.Codmes = MONTH(DesdeF) THEN DO:
            DO I = DAY(DesdeF)  TO 31 :
              FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")) NO-LOCK NO-ERROR.
              IF AVAILABLE Gn-tcmb THEN DO: 
                  F-Salida  = F-Salida  + Evtarti.CanxDia[I].
                  T-Vtamn   = T-Vtamn   + Evtarti.Vtaxdiamn[I] + Evtarti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                  T-Vtame   = T-Vtame   + Evtarti.Vtaxdiame[I] + Evtarti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
              END.
            END.
            X-ENTRA = TRUE.
        END.
        IF Evtarti.Codano = YEAR(HastaF) AND Evtarti.Codmes = MONTH(HastaF) THEN DO:
            DO I = 1 TO DAY(HastaF) :
              FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")) NO-LOCK NO-ERROR.
              IF AVAILABLE Gn-tcmb THEN DO: 
                F-Salida  = F-Salida  + Evtarti.CanxDia[I].
                T-Vtamn   = T-Vtamn   + Evtarti.Vtaxdiamn[I] + Evtarti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                T-Vtame   = T-Vtame   + Evtarti.Vtaxdiame[I] + Evtarti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
              END.
            END.        
            X-ENTRA = TRUE.
        END.
        IF NOT X-ENTRA THEN DO:    
            DO I = 1 TO 31 :
              FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")) NO-LOCK NO-ERROR.
              IF AVAILABLE Gn-tcmb THEN DO: 
                  F-Salida  = F-Salida  + Evtarti.CanxDia[I].
                  T-Vtamn   = T-Vtamn   + Evtarti.Vtaxdiamn[I] + Evtarti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                  T-Vtame   = T-Vtame   + Evtarti.Vtaxdiame[I] + Evtarti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
              END.
            END.
        END.
      END.
      /******************************************************************************/      

      FIND tmp-tempo WHERE t-codcia  = S-CODCIA
                      AND  t-codfam  = Almmmatg.codfam 
                      AND  t-subfam  = Almmmatg.subfam
                      AND  t-prove   = Almmmatg.CodPr1
                      AND  t-codmat  = Evtarti.codmat
                     NO-ERROR.
      IF NOT AVAIL tmp-tempo THEN DO:
        CREATE tmp-tempo.
        ASSIGN t-codcia  = S-CODCIA
               t-codfam  = Almmmatg.codfam 
               t-subfam  = Almmmatg.subfam
               t-prove   = Almmmatg.CodPr1
               t-codmat  = Evtarti.codmat
               t-desmat  = Almmmatg.DesMat
               t-desmar  = Almmmatg.DesMar
               t-undbas  = Almmmatg.UndBas.
      END.
      ASSIGN T-Canti[10] = T-Canti[10] + F-Salida 
             T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
             T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
      
      /******************************Secuencia Para Cargar Datos en las Columnas *****************/
      
      X-ENTRA = FALSE.
      IF F-DIVISION-1 <> "" AND Evtarti.Coddiv = F-DIVISION-1 THEN DO:
         ASSIGN T-Canti[1] = T-Canti[1] + F-Salida 
                T-Venta[1] = T-venta[1] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[1] = T-Costo[1] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-2 <> "" AND Evtarti.Coddiv = F-DIVISION-2 THEN DO:
         ASSIGN T-Canti[2] = T-Canti[2] + F-Salida 
                T-Venta[2] = T-venta[2] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[2] = T-Costo[2] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-3 <> "" AND Evtarti.Coddiv = F-DIVISION-3 THEN DO:
         ASSIGN T-Canti[3] = T-Canti[3] + F-Salida 
                T-Venta[3] = T-venta[3] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[3] = T-Costo[3] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-4 <> "" AND Evtarti.Coddiv = F-DIVISION-4 THEN DO:
         ASSIGN T-Canti[4] = T-Canti[4] + F-Salida  
                T-Venta[4] = T-venta[4] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[4] = T-Costo[4] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-5 <> "" AND Evtarti.Coddiv = F-DIVISION-5 THEN DO:
         ASSIGN T-Canti[5] = T-Canti[5] + F-Salida 
                T-Venta[5] = T-venta[5] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[5] = T-Costo[5] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-6 <> "" AND Evtarti.Coddiv = F-DIVISION-6 THEN DO:
         ASSIGN T-Canti[6] = T-Canti[6] + F-Salida 
                T-Venta[6] = T-venta[6] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[6] = T-Costo[6] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
                X-ENTRA = TRUE.     
      END.       
      IF NOT X-ENTRA THEN DO:
         ASSIGN T-Canti[7] = T-Canti[7] + F-Salida 
                T-Venta[7] = T-venta[7] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[7] = T-Costo[7] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
                X-ENTRA = TRUE. 
       END.
      
      /**************************************************************************/
      
      /*********** Calculo del Stock ***********************/
      /*
      IF LAST-OF(Almmmatg.codmat) THEN DO:
        FOR EACH Almacen WHERE Almacen.CodCia = Almmmatg.CodCia :
          FIND FIRST Almmmate WHERE Almmmate.CodCia = Almmmatg.CodCia AND
                                    Almmmate.CodAlm = Almacen.CodAlm  AND
                                    Almmmate.CodMat = Almmmatg.CodMat
                                    NO-LOCK NO-ERROR.
          IF AVAILABLE Almmmate THEN T-Stkact  = T-Stkact + Almmmate.StkAct.
 
        END.               
      END.
      */
      /**************************************************/ 
   
   

END.

HIDE FRAME F-PROCESO.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-temporal W-Win 
PROCEDURE Carga-temporal :
/*
------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR X-ENTRA AS LOGICAL INIT FALSE.

/*******Inicializa la Tabla Temporal ******/
FOR EACH tmp-tempo :
  DELETE tmp-tempo.
END.
/********************************/


FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = S-CODCIA
                           AND  Almmmatg.codfam BEGINS F-CodFam
                           AND  Almmmatg.subfam BEGINS F-Subfam
                           AND  LOOKUP(TRIM(Almmmatg.codmat), x-CodMat) > 0
                           AND  Almmmatg.CodPr1 BEGINS F-prov1
                           AND  Almmmatg.Codmar BEGINS F-Marca
                          USE-INDEX matg09:
  FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
                     AND Gn-Divi.CodDiv BEGINS F-DIVISION:
                                               
    FOR EACH Evtarti NO-LOCK WHERE Evtarti.CodCia = S-CODCIA
                         AND   Evtarti.CodDiv = Gn-Divi.Coddiv
                         AND   Evtarti.Codmat = Almmmatg.codmat
                         AND   (Evtarti.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
                         AND   Evtarti.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) ):
                         

      DISPLAY Evtarti.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      
      T-Vtamn   = 0.
      T-Vtame   = 0.
      T-Ctomn   = 0.
      T-Ctome   = 0.
      F-Salida  = 0.

      /*****************Capturando el Mes siguiente *******************/
      IF Evtarti.Codmes < 12 THEN DO:
        ASSIGN
        X-CODMES = Evtarti.Codmes + 1
        X-CODANO = Evtarti.Codano .
      END.
      ELSE DO: 
        ASSIGN
        X-CODMES = 01
        X-CODANO = Evtarti.Codano + 1 .
      END.
      /**********************************************************************/
      
      /*********************** Calculo Para Obtener los datos diarios ************/
       DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        

            X-FECHA = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")).
         
            IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
                FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")) NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN DO: 
                 F-Salida  = F-Salida  + Evtarti.CanxDia[I].
                 T-Vtamn   = T-Vtamn   + Evtarti.Vtaxdiamn[I] + Evtarti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                 T-Vtame   = T-Vtame   + Evtarti.Vtaxdiame[I] + Evtarti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                 T-Ctomn   = T-Ctomn   + Evtarti.Ctoxdiamn[I] + Evtarti.Ctoxdiame[I] * Gn-Tcmb.Venta.
                 T-Ctome   = T-Ctome   + Evtarti.Ctoxdiame[I] + Evtarti.Ctoxdiamn[I] / Gn-Tcmb.Compra.
                END.
            END.
       END.         
      
      /******************************************************************************/      

      FIND tmp-tempo WHERE t-codcia  = S-CODCIA
                      AND  t-codmat  = Evtarti.codmat
                     NO-ERROR.
      IF NOT AVAIL tmp-tempo THEN DO:
        CREATE tmp-tempo.
        ASSIGN t-codcia  = S-CODCIA
               t-Clase   = Almmmatg.Clase
               t-codfam  = Almmmatg.codfam 
               t-subfam  = Almmmatg.subfam
               t-prove   = Almmmatg.CodPr1
               t-codmat  = Evtarti.codmat
               t-desmat  = Almmmatg.DesMat
               t-desmar  = Almmmatg.DesMar
               t-undbas  = Almmmatg.UndBas.
      END.
      ASSIGN T-Canti[10] = T-Canti[10] + F-Salida 
             T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
             T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
             T-Marge[10] = T-Marge[10] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome ).
             T-Utili[10] = T-Utili[10] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
      
      /******************************Secuencia Para Cargar Datos en las Columnas *****************/
      
      X-ENTRA = FALSE.
      IF F-DIVISION-1 <> "" AND Evtarti.Coddiv = F-DIVISION-1 THEN DO:
         ASSIGN T-Canti[1] = T-Canti[1] + F-Salida 
                T-Venta[1] = T-venta[1] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[1] = T-Costo[1] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                T-Marge[1] = T-Marge[1] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome ).
                T-Utili[1] = T-Utili[1] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-2 <> "" AND Evtarti.Coddiv = F-DIVISION-2 THEN DO:
         ASSIGN T-Canti[2] = T-Canti[2] + F-Salida 
                T-Venta[2] = T-venta[2] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[2] = T-Costo[2] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                T-Marge[2] = T-Marge[2] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome ).
                T-Utili[2] = T-Utili[2] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-3 <> "" AND Evtarti.Coddiv = F-DIVISION-3 THEN DO:
         ASSIGN T-Canti[3] = T-Canti[3] + F-Salida 
                T-Venta[3] = T-venta[3] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[3] = T-Costo[3] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                T-Marge[3] = T-Marge[3] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome ).
                T-Utili[3] = T-Utili[3] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-4 <> "" AND Evtarti.Coddiv = F-DIVISION-4 THEN DO:
         ASSIGN T-Canti[4] = T-Canti[4] + F-Salida  
                T-Venta[4] = T-venta[4] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[4] = T-Costo[4] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                T-Marge[4] = T-Marge[4] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome ).
                T-Utili[4] = T-Utili[4] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-5 <> "" AND Evtarti.Coddiv = F-DIVISION-5 THEN DO:
         ASSIGN T-Canti[5] = T-Canti[5] + F-Salida 
                T-Venta[5] = T-venta[5] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[5] = T-Costo[5] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                T-Marge[5] = T-Marge[5] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome ).
                T-Utili[5] = T-Utili[5] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-6 <> "" AND Evtarti.Coddiv = F-DIVISION-6 THEN DO:
         ASSIGN T-Canti[6] = T-Canti[6] + F-Salida 
                T-Venta[6] = T-venta[6] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[6] = T-Costo[6] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
                T-Marge[6] = T-Marge[6] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome ).
                T-Utili[6] = T-Utili[6] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.     
      END.       
      IF NOT X-ENTRA THEN DO:
         ASSIGN T-Canti[7] = T-Canti[7] + F-Salida 
                T-Venta[7] = T-venta[7] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[7] = T-Costo[7] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
                T-Marge[7] = T-Marge[7] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome ).
                T-Utili[7] = T-Utili[7] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE. 
       END.
      
      /**************************************************************************/
      
      /*********** Calculo del Stock ***********************/
      /*
      IF LAST-OF(Almmmatg.codmat) THEN DO:
        FOR EACH Almacen WHERE Almacen.CodCia = Almmmatg.CodCia :
          FIND FIRST Almmmate WHERE Almmmate.CodCia = Almmmatg.CodCia AND
                                    Almmmate.CodAlm = Almacen.CodAlm  AND
                                    Almmmate.CodMat = Almmmatg.CodMat
                                    NO-LOCK NO-ERROR.
          IF AVAILABLE Almmmate THEN T-Stkact  = T-Stkact + Almmmate.StkAct.
 
        END.               
      END.
      */
      /**************************************************/ 
   
    END.
  END.
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
  DISPLAY F-DIVISION C-tipo F-CodFam C-tipo-2 F-SubFam F-Marca F-prov1 
          F-DIVISION-1 F-NOMDIV-1 F-DIVISION-2 F-NOMDIV-2 FILL-IN-file 
          F-NOMDIV-3 F-DIVISION-3 x-CodMat F-DIVISION-4 F-NOMDIV-4 F-DIVISION-5 
          F-NOMDIV-5 F-DIVISION-6 F-NOMDIV-6 DesdeF HastaF nCodMon 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-61 RECT-58 RECT-63 RECT-62 F-DIVISION BUTTON-5 C-tipo F-CodFam 
         BUTTON-1 C-tipo-2 F-SubFam BUTTON-2 F-Marca BUTTON-3 F-prov1 BUTTON-4 
         F-DIVISION-1 F-DIVISION-2 FILL-IN-file BUTTON-file F-DIVISION-3 
         x-CodMat F-DIVISION-4 F-DIVISION-5 F-DIVISION-6 DesdeF HastaF nCodMon 
         Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1 W-Win 
PROCEDURE Formato1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
CASE C-Tipo-2:
    WHEN "Cantidad"  THEN RUN Formato1A.
    WHEN "Venta"     THEN RUN Formato1B.
    WHEN "Costo"     THEN RUN Formato1C.
    WHEN "Margen"    THEN RUN Formato1D.
    WHEN "Utilidad"  THEN RUN Formato1E.
END CASE. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1A W-Win 
PROCEDURE Formato1A :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
  DEFINE FRAME F-REPORTE
         t-codmat    AT 1
         t-DesMat    FORMAT "X(40)"
         t-DesMar    FORMAT "X(6)" 
         t-UndBas    FORMAT "X(4)"
         t-canti[1]  FORMAT "->>>>>>>9"
         t-canti[2]  FORMAT "->>>>>>>9"
         t-canti[3]  FORMAT "->>>>>>>9"
         t-canti[4]  FORMAT "->>>>>>>9"
         t-canti[5]  FORMAT "->>>>>>>9"
         t-canti[6]  FORMAT "->>>>>>>9"
         t-canti[7]  FORMAT "->>>>>>>9"
         t-canti[10]  FORMAT "->>>>>>>9.99"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6B} + {&Prn3} FORMAT "X(50)" AT 1 SKIP(1)
         {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 40 FORMAT "X(50)" 
         {&PRN3} + {&PRN6A} + "(" + C-TIPO + "-" + C-TIPO-2 + ")" + {&PRN6B} + {&PRN3} AT 100 FORMAT "X(25)" SKIP(1)
         {&PRN3} + {&PRN6B} + S-SUBTIT AT 1  FORMAT "X(60)" 
         {&PRN3} + {&PRN6B} + "Pagina : " TO 135 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         {&PRN3} + {&PRN6B} + X-FAMILIA  AT 1  FORMAT "X(60)" 
         {&PRN3} + {&PRN6B} + "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         {&PRN3} + {&PRN6B} + X-SUBFAMILIA AT 1  FORMAT "X(60)" 
         {&PRN3} + {&PRN6B} + "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         {&PRN3} + {&PRN6B} + X-ARTI   AT 1  FORMAT "X(60)" 
         {&PRN3} + {&PRN6B} + X-MARCA  AT 80  FORMAT "X(60)" SKIP
         {&PRN3} + {&PRN6B} + X-PROVE  AT 1  FORMAT "X(60)" 
         {&PRN3} + {&PRN6B} + X-MONEDA AT 80  FORMAT "X(60)" SKIP
         {&PRN3} + {&PRN6B} + "DIVISIONES EVALUADAS  : " + X-CODDIV  + {&PRN4} + {&PRN6B} At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  63 
        F-DIVISION-2 AT  75 
        F-DIVISION-3 AT  85 
        F-DIVISION-4 AT  95 
        F-DIVISION-5 AT  105
        F-DIVISION-6 AT  115
        "O T R O S"  AT  125
        "T O T A L"  AT  140 SKIP
        " CODIGO  D E S C R I P C I O N                MARCA   U.M     CANTIDAD   CANTIDAD  CANTIDAD  CANTIDAD   CANTIDAD  CANTIDAD   CANTIDAD  CANTIDAD  IMPORTE    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  /*WHERE t-canti[10] > 0 */
                     BREAK BY t-codcia
                           BY t-prove
                           BY t-codfam 
                           BY t-subfam 
                           BY t-codmat:

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-prove) THEN DO:
         FIND GN-PROV WHERE GN-PROV.CODCIA = 0 
                       AND  GN-PROV.CODPRO = t-prove 
                      NO-LOCK NO-ERROR.
         IF AVAILABLE GN-PROV THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   {&PRN6A} + "PROVEEDOR : "  FORMAT "X(20)" AT 1 
                                 {&PRN6A} + t-prove         FORMAT "X(15)" AT 25
                                 {&PRN6A} + gn-prov.NomPro  + {&PRN6B} FORMAT "X(40)" AT 45 SKIP.
             PUT STREAM REPORT   {&PRN6B} + '------------------------------------------' FORMAT "X(50)" SKIP.
                          
         END.  
      END.
      
      
      DISPLAY STREAM REPORT 
                t-codmat
                t-DesMat
                t-DesMar
                t-UndBas
                t-canti[1] WHEN  t-canti[1] <> 0 FORMAT "->>>>>>>9"
                t-canti[2] WHEN  t-canti[2] <> 0 FORMAT "->>>>>>>9"
                t-canti[3] WHEN  t-canti[3] <> 0 FORMAT "->>>>>>>9"
                t-canti[4] WHEN  t-canti[4] <> 0 FORMAT "->>>>>>>9"
                t-canti[5] WHEN  t-canti[5] <> 0 FORMAT "->>>>>>>9"
                t-canti[6] WHEN  t-canti[6] <> 0 FORMAT "->>>>>>>9"
                t-canti[7] WHEN  t-canti[7] <> 0 FORMAT "->>>>>>>9"
                t-canti[10]  FORMAT "->>>>>>>9.99"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

     

  END.
   
  

  HIDE FRAME F-PROCESO.
*/
  DEFINE FRAME F-REPORTE
         t-codmat    AT 1
         t-DesMat    FORMAT "X(40)"
         t-DesMar    FORMAT "X(6)" 
         t-UndBas    FORMAT "X(4)"
         t-canti[1]  FORMAT "->>>>>>>9"
         t-canti[2]  FORMAT "->>>>>>>9"
         t-canti[3]  FORMAT "->>>>>>>9"
         t-canti[4]  FORMAT "->>>>>>>9"
         t-canti[5]  FORMAT "->>>>>>>9"
         t-canti[6]  FORMAT "->>>>>>>9"
         t-canti[7]  FORMAT "->>>>>>>9"
         t-canti[10]  FORMAT "->>>>>>>9.99"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU  AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
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
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  63 
        F-DIVISION-2 AT  75 
        F-DIVISION-3 AT  85 
        F-DIVISION-4 AT  95 
        F-DIVISION-5 AT  105
        F-DIVISION-6 AT  115
        "O T R O S"  AT  125
        "T O T A L"  AT  140 SKIP
        " CODIGO  D E S C R I P C I O N                MARCA   U.M     CANTIDAD   CANTIDAD  CANTIDAD  CANTIDAD   CANTIDAD  CANTIDAD   CANTIDAD  CANTIDAD  IMPORTE    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  /*WHERE t-canti[10] > 0 */
                     BREAK BY t-codcia
                           BY t-prove
                           BY t-codfam 
                           BY t-subfam 
                           BY t-codmat:

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-prove) THEN DO:
         FIND GN-PROV WHERE GN-PROV.CODCIA = pv-codcia 
                       AND  GN-PROV.CODPRO = t-prove 
                      NO-LOCK NO-ERROR.
         IF AVAILABLE GN-PROV THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "PROVEEDOR : "  FORMAT "X(20)" AT 1 
                                 t-prove         FORMAT "X(15)" AT 25
                                 gn-prov.NomPro  FORMAT "X(40)" AT 45 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.
                          
         END.  
      END.
      
      
      DISPLAY STREAM REPORT 
                t-codmat
                t-DesMat
                t-DesMar
                t-UndBas
                t-canti[1] WHEN  t-canti[1] <> 0 FORMAT "->>>>>>>9"
                t-canti[2] WHEN  t-canti[2] <> 0 FORMAT "->>>>>>>9"
                t-canti[3] WHEN  t-canti[3] <> 0 FORMAT "->>>>>>>9"
                t-canti[4] WHEN  t-canti[4] <> 0 FORMAT "->>>>>>>9"
                t-canti[5] WHEN  t-canti[5] <> 0 FORMAT "->>>>>>>9"
                t-canti[6] WHEN  t-canti[6] <> 0 FORMAT "->>>>>>>9"
                t-canti[7] WHEN  t-canti[7] <> 0 FORMAT "->>>>>>>9"
                t-canti[10]  FORMAT "->>>>>>>9.99"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

     

  END.
   
  

  HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1B W-Win 
PROCEDURE Formato1B :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-codmat    AT 1
         t-DesMat    FORMAT "X(40)"
         t-DesMar    FORMAT "X(6)" 
         t-UndBas    FORMAT "X(4)"
         t-venta[1]  FORMAT "->>>>>>>9"
         t-venta[2]  FORMAT "->>>>>>>9"
         t-venta[3]  FORMAT "->>>>>>>9"
         t-venta[4]  FORMAT "->>>>>>>9"
         t-venta[5]  FORMAT "->>>>>>>9"
         t-venta[6]  FORMAT "->>>>>>>9"
         t-venta[7]  FORMAT "->>>>>>>9"
         t-venta[10]  FORMAT "->>>>>>>9.99"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU  AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
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
         "LOS IMPORTES INCLUYEN I.G.V "   At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  63 
        F-DIVISION-2 AT  75 
        F-DIVISION-3 AT  85 
        F-DIVISION-4 AT  95 
        F-DIVISION-5 AT  105
        F-DIVISION-6 AT  115
        "O T R O S"  AT  125
        "T O T A L"  AT  140 SKIP
        " CODIGO  D E S C R I P C I O N                MARCA   U.M     VENTA      VENTA     VENTA     VENTA      VENTA     VENTA      VENTA       VENTA      " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  /*WHERE t-venta[10] > 0 */
                     BREAK BY t-codcia
                           BY t-prove
                           BY t-codfam 
                           BY t-subfam 
                           BY t-codmat:

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-prove) THEN DO:
         FIND GN-PROV WHERE GN-PROV.CODCIA = pv-codcia 
                       AND  GN-PROV.CODPRO = t-prove 
                      NO-LOCK NO-ERROR.
         IF AVAILABLE GN-PROV THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "PROVEEDOR : "  FORMAT "X(20)" AT 1 
                                 t-prove         FORMAT "X(15)" AT 25
                                 gn-prov.NomPro  FORMAT "X(40)" AT 45 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.
                          
         END.  
      END.
      
      ACCUM  t-venta[1]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-venta[2]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-venta[3]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-venta[4]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-venta[5]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-venta[6]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-venta[7]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-venta[10]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-venta[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[10]  ( TOTAL BY t-codcia) .
      
      DISPLAY STREAM REPORT 
                t-codmat
                t-DesMat
                t-DesMar
                t-UndBas
                t-venta[1] WHEN  t-venta[1] <> 0 FORMAT "->>>>>>>9"
                t-venta[2] WHEN  t-venta[2] <> 0 FORMAT "->>>>>>>9"
                t-venta[3] WHEN  t-venta[3] <> 0 FORMAT "->>>>>>>9"
                t-venta[4] WHEN  t-venta[4] <> 0 FORMAT "->>>>>>>9"
                t-venta[5] WHEN  t-venta[5] <> 0 FORMAT "->>>>>>>9"
                t-venta[6] WHEN  t-venta[6] <> 0 FORMAT "->>>>>>>9"
                t-venta[7] WHEN  t-venta[7] <> 0 FORMAT "->>>>>>>9"
                t-venta[10]  FORMAT "->>>>>>>9.99"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-prove) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[1]
            t-venta[2]
            t-venta[3]
            t-venta[4]
            t-venta[5]
            t-venta[6]
            t-venta[7]
            t-venta[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL PROVEEDOR : " + t-prove) @ t-desmat
            (ACCUM SUB-TOTAL BY t-prove t-venta[1]) @ t-venta[1] 
            (ACCUM SUB-TOTAL BY t-prove t-venta[2]) @ t-venta[2] 
            (ACCUM SUB-TOTAL BY t-prove t-venta[3]) @ t-venta[3] 
            (ACCUM SUB-TOTAL BY t-prove t-venta[4]) @ t-venta[4] 
            (ACCUM SUB-TOTAL BY t-prove t-venta[5]) @ t-venta[5] 
            (ACCUM SUB-TOTAL BY t-prove t-venta[6]) @ t-venta[6] 
            (ACCUM SUB-TOTAL BY t-prove t-venta[7]) @ t-venta[7] 
            (ACCUM SUB-TOTAL BY t-prove t-venta[10]) @ t-venta[10] 
            WITH FRAME F-REPORTE.
      END.
  
  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[1]
            t-venta[2]
            t-venta[3]
            t-venta[4]
            t-venta[5]
            t-venta[6]
            t-venta[7]
            t-venta[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-venta[1]) @ t-venta[1]
            (ACCUM TOTAL BY t-codcia t-venta[2]) @ t-venta[2]
            (ACCUM TOTAL BY t-codcia t-venta[3]) @ t-venta[3]
            (ACCUM TOTAL BY t-codcia t-venta[4]) @ t-venta[4]
            (ACCUM TOTAL BY t-codcia t-venta[5]) @ t-venta[5]
            (ACCUM TOTAL BY t-codcia t-venta[6]) @ t-venta[6]
            (ACCUM TOTAL BY t-codcia t-venta[7]) @ t-venta[7]
            (ACCUM TOTAL BY t-codcia t-venta[10]) @ t-venta[10]
            WITH FRAME F-REPORTE.
      END.
     

  END.
   
  

  HIDE FRAME F-PROCESO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1C W-Win 
PROCEDURE Formato1C :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*

  DEFINE FRAME F-REPORTE
         t-codmat    AT 1
         t-DesMat    FORMAT "X(40)"
         t-DesMar    FORMAT "X(6)" 
         t-UndBas    FORMAT "X(4)"
         t-COSTO[1]  FORMAT "->>>>>>>9"
         t-COSTO[2]  FORMAT "->>>>>>>9"
         t-COSTO[3]  FORMAT "->>>>>>>9"
         t-COSTO[4]  FORMAT "->>>>>>>9"
         t-COSTO[5]  FORMAT "->>>>>>>9"
         t-COSTO[6]  FORMAT "->>>>>>>9"
         t-COSTO[7]  FORMAT "->>>>>>>9"
         t-COSTO[10]  FORMAT "->>>>>>>9.99"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")"  AT 100 FORMAT "X(25)" SKIP(1)
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
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP
         "LOS IMPORTES INCLUYEN I.G.V "   At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  63 
        F-DIVISION-2 AT  75 
        F-DIVISION-3 AT  85 
        F-DIVISION-4 AT  95 
        F-DIVISION-5 AT  105
        F-DIVISION-6 AT  115
        "O T R O S"  AT  125
        "T O T A L"  AT  140 SKIP
        " CODIGO  D E S C R I P C I O N                MARCA   U.M     COSTO      COSTO     COSTO     COSTO      COSTO     COSTO      COSTO     COSTO                " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  /*WHERE t-COSTO[10] > 0 */
                     BREAK BY t-codcia
                           BY t-prove
                           BY t-codfam 
                           BY t-subfam 
                           BY t-codmat:

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-prove) THEN DO:
         FIND GN-PROV WHERE GN-PROV.CODCIA = 0 
                       AND  GN-PROV.CODPRO = t-prove 
                      NO-LOCK NO-ERROR.
         IF AVAILABLE GN-PROV THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "PROVEEDOR : "  FORMAT "X(20)" AT 1 
                                 t-prove         FORMAT "X(15)" AT 25
                                 gn-prov.NomPro  FORMAT "X(40)" AT 45 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.
                          
         END.  
      END.
      
      ACCUM  t-costo[1]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-costo[2]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-costo[3]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-costo[4]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-costo[5]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-costo[6]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-costo[7]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-costo[10]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-costo[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-costo[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-costo[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-costo[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-costo[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-costo[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-costo[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-costo[10]  ( TOTAL BY t-codcia) .
      
      DISPLAY STREAM REPORT 
                t-codmat
                t-DesMat
                t-DesMar
                t-UndBas
                t-COSTO[1] WHEN  t-COSTO[1] <> 0 FORMAT "->>>>>>>9"
                t-COSTO[2] WHEN  t-COSTO[2] <> 0 FORMAT "->>>>>>>9"
                t-COSTO[3] WHEN  t-COSTO[3] <> 0 FORMAT "->>>>>>>9"
                t-COSTO[4] WHEN  t-COSTO[4] <> 0 FORMAT "->>>>>>>9"
                t-COSTO[5] WHEN  t-COSTO[5] <> 0 FORMAT "->>>>>>>9"
                t-COSTO[6] WHEN  t-COSTO[6] <> 0 FORMAT "->>>>>>>9"
                t-COSTO[7] WHEN  t-COSTO[7] <> 0 FORMAT "->>>>>>>9"
                t-COSTO[10]  FORMAT "->>>>>>>9.99"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-prove) THEN DO:
        UNDERLINE STREAM REPORT 
            t-costo[1]
            t-costo[2]
            t-costo[3]
            t-costo[4]
            t-costo[5]
            t-costo[6]
            t-costo[7]
            t-costo[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL PROVEEDOR : " + t-prove) @ t-desmat
            (ACCUM SUB-TOTAL BY t-prove t-costo[1]) @ t-costo[1] 
            (ACCUM SUB-TOTAL BY t-prove t-costo[2]) @ t-costo[2] 
            (ACCUM SUB-TOTAL BY t-prove t-costo[3]) @ t-costo[3] 
            (ACCUM SUB-TOTAL BY t-prove t-costo[4]) @ t-costo[4] 
            (ACCUM SUB-TOTAL BY t-prove t-costo[5]) @ t-costo[5] 
            (ACCUM SUB-TOTAL BY t-prove t-costo[6]) @ t-costo[6] 
            (ACCUM SUB-TOTAL BY t-prove t-costo[7]) @ t-costo[7] 
            (ACCUM SUB-TOTAL BY t-prove t-costo[10]) @ t-costo[10] 
            WITH FRAME F-REPORTE.
      END.
  
  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-costo[1]
            t-costo[2]
            t-costo[3]
            t-costo[4]
            t-costo[5]
            t-costo[6]
            t-costo[7]
            t-costo[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-costo[1]) @ t-costo[1]
            (ACCUM TOTAL BY t-codcia t-costo[2]) @ t-costo[2]
            (ACCUM TOTAL BY t-codcia t-costo[3]) @ t-costo[3]
            (ACCUM TOTAL BY t-codcia t-costo[4]) @ t-costo[4]
            (ACCUM TOTAL BY t-codcia t-costo[5]) @ t-costo[5]
            (ACCUM TOTAL BY t-codcia t-costo[6]) @ t-costo[6]
            (ACCUM TOTAL BY t-codcia t-costo[7]) @ t-costo[7]
            (ACCUM TOTAL BY t-codcia t-costo[10]) @ t-costo[10]
            WITH FRAME F-REPORTE.
      END.
     

  END.

  HIDE FRAME F-PROCESO.
*/

  DEFINE FRAME F-REPORTE
         t-codmat    AT 1
         t-DesMat    FORMAT "X(40)"
         t-DesMar    FORMAT "X(6)" 
         t-UndBas    FORMAT "X(4)"
         t-COSTO[1]  FORMAT "->>>>>>>9"
         t-COSTO[2]  FORMAT "->>>>>>>9"
         t-COSTO[3]  FORMAT "->>>>>>>9"
         t-COSTO[4]  FORMAT "->>>>>>>9"
         t-COSTO[5]  FORMAT "->>>>>>>9"
         t-COSTO[6]  FORMAT "->>>>>>>9"
         t-COSTO[7]  FORMAT "->>>>>>>9"
         t-COSTO[10]  FORMAT "->>>>>>>9.99"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU  AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")"  AT 100 FORMAT "X(25)" SKIP(1)
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
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP
         "LOS IMPORTES INCLUYEN I.G.V "   At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  63 
        F-DIVISION-2 AT  75 
        F-DIVISION-3 AT  85 
        F-DIVISION-4 AT  95 
        F-DIVISION-5 AT  105
        F-DIVISION-6 AT  115
        "O T R O S"  AT  125
        "T O T A L"  AT  140 SKIP
        " CODIGO  D E S C R I P C I O N                MARCA   U.M     COSTO      COSTO     COSTO     COSTO      COSTO     COSTO      COSTO     COSTO                " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  /*WHERE t-COSTO[10] > 0 */
                     BREAK BY t-codcia
                           BY t-prove
                           BY t-codfam 
                           BY t-subfam 
                           BY t-codmat:

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-prove) THEN DO:
         FIND GN-PROV WHERE GN-PROV.CODCIA = pv-codcia 
                       AND  GN-PROV.CODPRO = t-prove 
                      NO-LOCK NO-ERROR.
         IF AVAILABLE GN-PROV THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "PROVEEDOR : "  FORMAT "X(20)" AT 1 
                                 t-prove         FORMAT "X(15)" AT 25
                                 gn-prov.NomPro  FORMAT "X(40)" AT 45 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.
                          
         END.  
      END.
      
      ACCUM  t-costo[1]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-costo[2]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-costo[3]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-costo[4]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-costo[5]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-costo[6]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-costo[7]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-costo[10]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-costo[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-costo[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-costo[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-costo[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-costo[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-costo[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-costo[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-costo[10]  ( TOTAL BY t-codcia) .
      
      DISPLAY STREAM REPORT 
                t-codmat
                t-DesMat
                t-DesMar
                t-UndBas
                t-COSTO[1] WHEN  t-COSTO[1] <> 0 FORMAT "->>>>>>>9"
                t-COSTO[2] WHEN  t-COSTO[2] <> 0 FORMAT "->>>>>>>9"
                t-COSTO[3] WHEN  t-COSTO[3] <> 0 FORMAT "->>>>>>>9"
                t-COSTO[4] WHEN  t-COSTO[4] <> 0 FORMAT "->>>>>>>9"
                t-COSTO[5] WHEN  t-COSTO[5] <> 0 FORMAT "->>>>>>>9"
                t-COSTO[6] WHEN  t-COSTO[6] <> 0 FORMAT "->>>>>>>9"
                t-COSTO[7] WHEN  t-COSTO[7] <> 0 FORMAT "->>>>>>>9"
                t-COSTO[10]  FORMAT "->>>>>>>9.99"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-prove) THEN DO:
        UNDERLINE STREAM REPORT 
            t-costo[1]
            t-costo[2]
            t-costo[3]
            t-costo[4]
            t-costo[5]
            t-costo[6]
            t-costo[7]
            t-costo[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL PROVEEDOR : " + t-prove) @ t-desmat
            (ACCUM SUB-TOTAL BY t-prove t-costo[1]) @ t-costo[1] 
            (ACCUM SUB-TOTAL BY t-prove t-costo[2]) @ t-costo[2] 
            (ACCUM SUB-TOTAL BY t-prove t-costo[3]) @ t-costo[3] 
            (ACCUM SUB-TOTAL BY t-prove t-costo[4]) @ t-costo[4] 
            (ACCUM SUB-TOTAL BY t-prove t-costo[5]) @ t-costo[5] 
            (ACCUM SUB-TOTAL BY t-prove t-costo[6]) @ t-costo[6] 
            (ACCUM SUB-TOTAL BY t-prove t-costo[7]) @ t-costo[7] 
            (ACCUM SUB-TOTAL BY t-prove t-costo[10]) @ t-costo[10] 
            WITH FRAME F-REPORTE.
      END.
  
  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-costo[1]
            t-costo[2]
            t-costo[3]
            t-costo[4]
            t-costo[5]
            t-costo[6]
            t-costo[7]
            t-costo[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-costo[1]) @ t-costo[1]
            (ACCUM TOTAL BY t-codcia t-costo[2]) @ t-costo[2]
            (ACCUM TOTAL BY t-codcia t-costo[3]) @ t-costo[3]
            (ACCUM TOTAL BY t-codcia t-costo[4]) @ t-costo[4]
            (ACCUM TOTAL BY t-codcia t-costo[5]) @ t-costo[5]
            (ACCUM TOTAL BY t-codcia t-costo[6]) @ t-costo[6]
            (ACCUM TOTAL BY t-codcia t-costo[7]) @ t-costo[7]
            (ACCUM TOTAL BY t-codcia t-costo[10]) @ t-costo[10]
            WITH FRAME F-REPORTE.
      END.
     

  END.

  HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1D W-Win 
PROCEDURE Formato1D :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-codmat    AT 1
         t-DesMat    FORMAT "X(40)"
         t-DesMar    FORMAT "X(6)" 
         t-UndBas    FORMAT "X(4)"
         t-Marge[1]  FORMAT "->>>>>>>9"
         t-Marge[2]  FORMAT "->>>>>>>9"
         t-Marge[3]  FORMAT "->>>>>>>9"
         t-Marge[4]  FORMAT "->>>>>>>9"
         t-Marge[5]  FORMAT "->>>>>>>9"
         t-Marge[6]  FORMAT "->>>>>>>9"
         t-Marge[7]  FORMAT "->>>>>>>9"
         t-Marge[10]  FORMAT "->>>>>>>9.99"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
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
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  63 
        F-DIVISION-2 AT  75 
        F-DIVISION-3 AT  85 
        F-DIVISION-4 AT  95 
        F-DIVISION-5 AT  105
        F-DIVISION-6 AT  115
        "O T R O S"  AT  125
        "T O T A L"  AT  140 SKIP
        " CODIGO  D E S C R I P C I O N                MARCA   U.M     Marge      Marge     Marge     Marge      Marge     Marge      Marge     Marge                " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo /* WHERE t-Marge[10] > 0 */
                     BREAK BY t-codcia
                           BY t-prove
                           BY t-codfam 
                           BY t-subfam 
                           BY t-codmat:

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-prove) THEN DO:
         FIND GN-PROV WHERE GN-PROV.CODCIA = pv-codcia 
                       AND  GN-PROV.CODPRO = t-prove 
                      NO-LOCK NO-ERROR.
         IF AVAILABLE GN-PROV THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "PROVEEDOR : "  FORMAT "X(20)" AT 1 
                                 t-prove         FORMAT "X(15)" AT 25
                                 gn-prov.NomPro  FORMAT "X(40)" AT 45 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.
                          
         END.  
      END.
      T-Marge[1] = (T-Venta[1] - T-Costo[1]) / T-Venta[1] .
      T-Marge[2] = (T-Venta[2] - T-Costo[2]) / T-Venta[2] .
      T-Marge[3] = (T-Venta[3] - T-Costo[3]) / T-Venta[3] .
      T-Marge[4] = (T-Venta[4] - T-Costo[4]) / T-Venta[4] .
      T-Marge[5] = (T-Venta[5] - T-Costo[5]) / T-Venta[5] .
      T-Marge[6] = (T-Venta[6] - T-Costo[6]) / T-Venta[6] .
      T-Marge[7] = (T-Venta[7] - T-Costo[7]) / T-Venta[7] .
      T-Marge[10] = (T-Venta[10] - T-Costo[10]) / T-Venta[10] .
      
      ACCUM  t-Marge[1]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Marge[2]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Marge[3]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Marge[4]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Marge[5]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Marge[6]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Marge[7]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Marge[10]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Marge[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[10]  ( TOTAL BY t-codcia) .

      ACCUM  t-Venta[1]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Venta[2]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Venta[3]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Venta[4]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Venta[5]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Venta[6]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Venta[7]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Venta[10]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Venta[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[10]  ( TOTAL BY t-codcia) .

      ACCUM  t-Costo[1]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Costo[2]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Costo[3]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Costo[4]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Costo[5]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Costo[6]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Costo[7]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Costo[10]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Costo[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[10]  ( TOTAL BY t-codcia) .
      
      DISPLAY STREAM REPORT 
                t-codmat
                t-DesMat
                t-DesMar
                t-UndBas
                t-Marge[1] WHEN  t-Marge[1] <> 0 FORMAT "->>>>>>>9"
                t-Marge[2] WHEN  t-Marge[2] <> 0 FORMAT "->>>>>>>9"
                t-Marge[3] WHEN  t-Marge[3] <> 0 FORMAT "->>>>>>>9"
                t-Marge[4] WHEN  t-Marge[4] <> 0 FORMAT "->>>>>>>9"
                t-Marge[5] WHEN  t-Marge[5] <> 0 FORMAT "->>>>>>>9"
                t-Marge[6] WHEN  t-Marge[6] <> 0 FORMAT "->>>>>>>9"
                t-Marge[7] WHEN  t-Marge[7] <> 0 FORMAT "->>>>>>>9"
                t-Marge[10]  FORMAT "->>>>>>>9.99"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-prove) THEN DO:
        UNDERLINE STREAM REPORT 
            t-Marge[1]
            t-Marge[2]
            t-Marge[3]
            t-Marge[4]
            t-Marge[5]
            t-Marge[6]
            t-Marge[7]
            t-Marge[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL PROVEEDOR : " + t-prove) @ t-desmat
            ((ACCUM SUB-TOTAL BY t-prove t-Venta[1]) - (ACCUM SUB-TOTAL BY t-prove t-Costo[1])) / (ACCUM SUB-TOTAL BY t-prove t-Venta[1]) @ t-Marge[1] 
            ((ACCUM SUB-TOTAL BY t-prove t-Venta[2]) - (ACCUM SUB-TOTAL BY t-prove t-Costo[2])) / (ACCUM SUB-TOTAL BY t-prove t-Venta[2]) @ t-Marge[2] 
            ((ACCUM SUB-TOTAL BY t-prove t-Venta[3]) - (ACCUM SUB-TOTAL BY t-prove t-Costo[3])) / (ACCUM SUB-TOTAL BY t-prove t-Venta[3]) @ t-Marge[3] 
            ((ACCUM SUB-TOTAL BY t-prove t-Venta[4]) - (ACCUM SUB-TOTAL BY t-prove t-Costo[4])) / (ACCUM SUB-TOTAL BY t-prove t-Venta[4]) @ t-Marge[4] 
            ((ACCUM SUB-TOTAL BY t-prove t-Venta[5]) - (ACCUM SUB-TOTAL BY t-prove t-Costo[5])) / (ACCUM SUB-TOTAL BY t-prove t-Venta[5]) @ t-Marge[5] 
            ((ACCUM SUB-TOTAL BY t-prove t-Venta[6]) - (ACCUM SUB-TOTAL BY t-prove t-Costo[6])) / (ACCUM SUB-TOTAL BY t-prove t-Venta[6]) @ t-Marge[6] 
            ((ACCUM SUB-TOTAL BY t-prove t-Venta[7]) - (ACCUM SUB-TOTAL BY t-prove t-Costo[7])) / (ACCUM SUB-TOTAL BY t-prove t-Venta[7]) @ t-Marge[7] 
            ((ACCUM SUB-TOTAL BY t-prove t-Venta[10]) - (ACCUM SUB-TOTAL BY t-prove t-Costo[10])) / (ACCUM SUB-TOTAL BY t-prove t-Venta[10]) @ t-Marge[10] 
            WITH FRAME F-REPORTE.
      END.
  
  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-Marge[1]
            t-Marge[2]
            t-Marge[3]
            t-Marge[4]
            t-Marge[5]
            t-Marge[6]
            t-Marge[7]
            t-Marge[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            ((ACCUM TOTAL BY t-codcia t-Venta[1]) - (ACCUM TOTAL BY t-codcia t-Costo[1])) / (ACCUM TOTAL BY t-codcia t-Venta[1]) @ t-Marge[1]
            ((ACCUM TOTAL BY t-codcia t-Venta[2]) - (ACCUM TOTAL BY t-codcia t-Costo[2])) / (ACCUM TOTAL BY t-codcia t-Venta[2]) @ t-Marge[2]
            ((ACCUM TOTAL BY t-codcia t-Venta[3]) - (ACCUM TOTAL BY t-codcia t-Costo[3])) / (ACCUM TOTAL BY t-codcia t-Venta[3]) @ t-Marge[3]
            ((ACCUM TOTAL BY t-codcia t-Venta[4]) - (ACCUM TOTAL BY t-codcia t-Costo[4])) / (ACCUM TOTAL BY t-codcia t-Venta[4]) @ t-Marge[4]
            ((ACCUM TOTAL BY t-codcia t-Venta[5]) - (ACCUM TOTAL BY t-codcia t-Costo[5])) / (ACCUM TOTAL BY t-codcia t-Venta[5]) @ t-Marge[5]
            ((ACCUM TOTAL BY t-codcia t-Venta[6]) - (ACCUM TOTAL BY t-codcia t-Costo[6])) / (ACCUM TOTAL BY t-codcia t-Venta[6]) @ t-Marge[6]
            ((ACCUM TOTAL BY t-codcia t-Venta[7]) - (ACCUM TOTAL BY t-codcia t-Costo[7])) / (ACCUM TOTAL BY t-codcia t-Venta[7]) @ t-Marge[7]
            ((ACCUM TOTAL BY t-codcia t-Venta[10]) - (ACCUM TOTAL BY t-codcia t-Costo[10])) / (ACCUM TOTAL BY t-codcia t-Venta[10]) @ t-Marge[10]
            WITH FRAME F-REPORTE.
      END.
     

  END.

  HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1E W-Win 
PROCEDURE Formato1E :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-codmat    AT 1
         t-DesMat    FORMAT "X(40)"
         t-DesMar    FORMAT "X(6)" 
         t-UndBas    FORMAT "X(4)"
         t-Utili[1]  FORMAT "->>>>>>>9"
         t-Utili[2]  FORMAT "->>>>>>>9"
         t-Utili[3]  FORMAT "->>>>>>>9"
         t-Utili[4]  FORMAT "->>>>>>>9"
         t-Utili[5]  FORMAT "->>>>>>>9"
         t-Utili[6]  FORMAT "->>>>>>>9"
         t-Utili[7]  FORMAT "->>>>>>>9"
         t-Utili[10]  FORMAT "->>>>>>>9.99"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU  AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
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
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  63 
        F-DIVISION-2 AT  75 
        F-DIVISION-3 AT  85 
        F-DIVISION-4 AT  95 
        F-DIVISION-5 AT  105
        F-DIVISION-6 AT  115
        "O T R O S"  AT  125
        "T O T A L"  AT  140 SKIP
        " CODIGO  D E S C R I P C I O N                MARCA   U.M     Utili      Utili     Utili     Utili      Utili     Utili      Utili     Utili                " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  /*WHERE t-Utili[10] > 0 */
                     BREAK BY t-codcia
                           BY t-prove
                           BY t-codfam 
                           BY t-subfam 
                           BY t-codmat:

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-prove) THEN DO:
         FIND GN-PROV WHERE GN-PROV.CODCIA = pv-codcia 
                       AND  GN-PROV.CODPRO = t-prove 
                      NO-LOCK NO-ERROR.
         IF AVAILABLE GN-PROV THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "PROVEEDOR : "  FORMAT "X(20)" AT 1 
                                 t-prove         FORMAT "X(15)" AT 25
                                 gn-prov.NomPro  FORMAT "X(40)" AT 45 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.
                          
         END.  
      END.
      
      ACCUM  t-Utili[1]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Utili[2]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Utili[3]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Utili[4]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Utili[5]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Utili[6]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Utili[7]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Utili[10]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Utili[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[10]  ( TOTAL BY t-codcia) .
      
      DISPLAY STREAM REPORT 
                t-codmat
                t-DesMat
                t-DesMar
                t-UndBas
                t-Utili[1] WHEN  t-Utili[1] <> 0 FORMAT "->>>>>>>9"
                t-Utili[2] WHEN  t-Utili[2] <> 0 FORMAT "->>>>>>>9"
                t-Utili[3] WHEN  t-Utili[3] <> 0 FORMAT "->>>>>>>9"
                t-Utili[4] WHEN  t-Utili[4] <> 0 FORMAT "->>>>>>>9"
                t-Utili[5] WHEN  t-Utili[5] <> 0 FORMAT "->>>>>>>9"
                t-Utili[6] WHEN  t-Utili[6] <> 0 FORMAT "->>>>>>>9"
                t-Utili[7] WHEN  t-Utili[7] <> 0 FORMAT "->>>>>>>9"
                t-Utili[10]  FORMAT "->>>>>>>9.99"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-prove) THEN DO:
        UNDERLINE STREAM REPORT 
            t-Utili[1]
            t-Utili[2]
            t-Utili[3]
            t-Utili[4]
            t-Utili[5]
            t-Utili[6]
            t-Utili[7]
            t-Utili[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL PROVEEDOR : " + t-prove) @ t-desmat
            (ACCUM SUB-TOTAL BY t-prove t-Utili[1]) @ t-Utili[1] 
            (ACCUM SUB-TOTAL BY t-prove t-Utili[2]) @ t-Utili[2] 
            (ACCUM SUB-TOTAL BY t-prove t-Utili[3]) @ t-Utili[3] 
            (ACCUM SUB-TOTAL BY t-prove t-Utili[4]) @ t-Utili[4] 
            (ACCUM SUB-TOTAL BY t-prove t-Utili[5]) @ t-Utili[5] 
            (ACCUM SUB-TOTAL BY t-prove t-Utili[6]) @ t-Utili[6] 
            (ACCUM SUB-TOTAL BY t-prove t-Utili[7]) @ t-Utili[7] 
            (ACCUM SUB-TOTAL BY t-prove t-Utili[10]) @ t-Utili[10] 
            WITH FRAME F-REPORTE.
      END.
  
  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-Utili[1]
            t-Utili[2]
            t-Utili[3]
            t-Utili[4]
            t-Utili[5]
            t-Utili[6]
            t-Utili[7]
            t-Utili[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-Utili[1]) @ t-Utili[1]
            (ACCUM TOTAL BY t-codcia t-Utili[2]) @ t-Utili[2]
            (ACCUM TOTAL BY t-codcia t-Utili[3]) @ t-Utili[3]
            (ACCUM TOTAL BY t-codcia t-Utili[4]) @ t-Utili[4]
            (ACCUM TOTAL BY t-codcia t-Utili[5]) @ t-Utili[5]
            (ACCUM TOTAL BY t-codcia t-Utili[6]) @ t-Utili[6]
            (ACCUM TOTAL BY t-codcia t-Utili[7]) @ t-Utili[7]
            (ACCUM TOTAL BY t-codcia t-Utili[10]) @ t-Utili[10]
            WITH FRAME F-REPORTE.
      END.
     

  END.

  HIDE FRAME F-PROCESO.

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
CASE C-Tipo-2:
    WHEN "Cantidad"  THEN RUN Formato2A.
    WHEN "Venta"     THEN RUN Formato2B.
    WHEN "Costo"     THEN RUN Formato2C.
    WHEN "Margen"    THEN RUN Formato2D.
    WHEN "Utilidad"  THEN RUN Formato2E.
END CASE. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato2A W-Win 
PROCEDURE Formato2A :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-codmat    AT 1
         t-DesMat    FORMAT "X(40)"
         t-DesMar    FORMAT "X(6)" 
         t-UndBas    FORMAT "X(4)"
         t-canti[1]  FORMAT "->>>>>>>9"
         t-canti[2]  FORMAT "->>>>>>>9"
         t-canti[3]  FORMAT "->>>>>>>9"
         t-canti[4]  FORMAT "->>>>>>>9"
         t-canti[5]  FORMAT "->>>>>>>9"
         t-canti[6]  FORMAT "->>>>>>>9"
         t-canti[7]  FORMAT "->>>>>>>9"
         t-canti[10]  FORMAT "->>>>>>>9.99"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
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
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  63 
        F-DIVISION-2 AT  75 
        F-DIVISION-3 AT  85 
        F-DIVISION-4 AT  95 
        F-DIVISION-5 AT  105
        F-DIVISION-6 AT  115
        "O T R O S"  AT  125
        "T O T A L"  AT  140 SKIP
        " CODIGO  D E S C R I P C I O N                MARCA   U.M     CANTIDAD   CANTIDAD  CANTIDAD  CANTIDAD   CANTIDAD  CANTIDAD   CANTIDAD  CANTIDAD             " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  /* WHERE t-canti[10] > 0  */
                     BREAK BY t-codcia
                           BY t-codfam 
                           BY t-subfam 
                           BY t-codmat:

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = t-CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "FAMILIA : "  FORMAT "X(15)" AT 1 
                                 t-codfam      FORMAT "X(05)" AT 17
                                 Almtfami.Desfam  FORMAT "X(40)" AT 25 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.
         END.
      END.

      IF FIRST-OF(t-SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = S-CODCIA 
                        AND  Almsfami.codfam = t-CodFam 
                        AND  Almsfami.subfam = t-Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "SUB-FAMILIA : "  FORMAT "X(15)" AT 11 
                                 t-subfam        FORMAT "X(05)" AT 27
                                 AlmSfami.DesSub FORMAT "X(40)" AT 35 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" AT 11 SKIP.
         END.
      END.
      DISPLAY STREAM REPORT 
                t-codmat
                t-DesMat
                t-DesMar
                t-UndBas
                t-canti[1] WHEN  t-canti[1] <> 0 FORMAT "->>>>>>>9"
                t-canti[2] WHEN  t-canti[2] <> 0 FORMAT "->>>>>>>9"
                t-canti[3] WHEN  t-canti[3] <> 0 FORMAT "->>>>>>>9"
                t-canti[4] WHEN  t-canti[4] <> 0 FORMAT "->>>>>>>9"
                t-canti[5] WHEN  t-canti[5] <> 0 FORMAT "->>>>>>>9"
                t-canti[6] WHEN  t-canti[6] <> 0 FORMAT "->>>>>>>9"
                t-canti[7] WHEN  t-canti[7] <> 0 FORMAT "->>>>>>>9"
                t-canti[10]  FORMAT "->>>>>>>9.99"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.
  END.
  HIDE FRAME F-PROCESO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato2B W-Win 
PROCEDURE Formato2B :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-codmat    AT 1
         t-DesMat    FORMAT "X(40)"
         t-DesMar    FORMAT "X(6)" 
         t-UndBas    FORMAT "X(4)"
         t-Venta[1]  FORMAT "->>>>>>>9"
         t-Venta[2]  FORMAT "->>>>>>>9"
         t-Venta[3]  FORMAT "->>>>>>>9"
         t-Venta[4]  FORMAT "->>>>>>>9"
         t-Venta[5]  FORMAT "->>>>>>>9"
         t-Venta[6]  FORMAT "->>>>>>>9"
         t-Venta[7]  FORMAT "->>>>>>>9"
         t-Venta[10]  FORMAT "->>>>>>>9.99"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
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
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP
         "LOS IMPORTES INCLUYEN I.G.V "   At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  63 
        F-DIVISION-2 AT  75 
        F-DIVISION-3 AT  85 
        F-DIVISION-4 AT  95 
        F-DIVISION-5 AT  105
        F-DIVISION-6 AT  115
        "O T R O S"  AT  125
        "T O T A L"  AT  140 SKIP
        " CODIGO  D E S C R I P C I O N                MARCA   U.M     VENTA      VENTA     VENTA     VENTA      VENTA     VENTA      VENTA                          " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  /* WHERE t-Venta[10] > 0 */
                     BREAK BY t-codcia
                           BY t-codfam 
                           BY t-subfam 
                           BY t-codmat:

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = t-CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "FAMILIA : "  FORMAT "X(15)" AT 1 
                                 t-codfam      FORMAT "X(05)" AT 17
                                 Almtfami.Desfam FORMAT "X(40)" AT 25 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.
         END.
      END.

      IF FIRST-OF(t-SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = S-CODCIA 
                        AND  Almsfami.codfam = t-CodFam 
                        AND  Almsfami.subfam = t-Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "SUB-FAMILIA : "  FORMAT "X(15)" AT 11 
                                 t-subfam      FORMAT "X(05)" AT 27
                                 AlmSfami.DesSub FORMAT "X(40)" AT 35 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" AT 11 SKIP.
         END.
      END.

      ACCUM  t-venta[1]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-venta[2]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-venta[3]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-venta[4]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-venta[5]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-venta[6]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-venta[7]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-venta[10]  (SUB-TOTAL BY t-codfam) .

      ACCUM  t-venta[1]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-venta[2]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-venta[3]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-venta[4]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-venta[5]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-venta[6]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-venta[7]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-venta[10]  (SUB-TOTAL BY t-subfam) .

      ACCUM  t-venta[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[10]  ( TOTAL BY t-codcia) .
      
      DISPLAY STREAM REPORT 
                t-codmat
                t-DesMat
                t-DesMar
                t-UndBas
                t-Venta[1] WHEN  t-Venta[1] <> 0 FORMAT "->>>>>>>9"
                t-Venta[2] WHEN  t-Venta[2] <> 0 FORMAT "->>>>>>>9"
                t-Venta[3] WHEN  t-Venta[3] <> 0 FORMAT "->>>>>>>9"
                t-Venta[4] WHEN  t-Venta[4] <> 0 FORMAT "->>>>>>>9"
                t-Venta[5] WHEN  t-Venta[5] <> 0 FORMAT "->>>>>>>9"
                t-Venta[6] WHEN  t-Venta[6] <> 0 FORMAT "->>>>>>>9"
                t-Venta[7] WHEN  t-Venta[7] <> 0 FORMAT "->>>>>>>9"
                t-Venta[10]  FORMAT "->>>>>>>9.99"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-SubFam) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[1]
            t-venta[2]
            t-venta[3]
            t-venta[4]
            t-venta[5]
            t-venta[6]
            t-venta[7]
            t-venta[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL SUB-FAMILIA: " + t-subfam) @ t-desmat
            (ACCUM SUB-TOTAL BY t-subfam t-venta[1]) @ t-venta[1] 
            (ACCUM SUB-TOTAL BY t-subfam t-venta[2]) @ t-venta[2] 
            (ACCUM SUB-TOTAL BY t-subfam t-venta[3]) @ t-venta[3] 
            (ACCUM SUB-TOTAL BY t-subfam t-venta[4]) @ t-venta[4] 
            (ACCUM SUB-TOTAL BY t-subfam t-venta[5]) @ t-venta[5] 
            (ACCUM SUB-TOTAL BY t-subfam t-venta[6]) @ t-venta[6] 
            (ACCUM SUB-TOTAL BY t-subfam t-venta[7]) @ t-venta[7] 
            (ACCUM SUB-TOTAL BY t-subfam t-venta[10]) @ t-venta[10] 
            WITH FRAME F-REPORTE.

      END.

      IF LAST-OF(t-CodFam) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[1]
            t-venta[2]
            t-venta[3]
            t-venta[4]
            t-venta[5]
            t-venta[6]
            t-venta[7]
            t-venta[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL FAMILIA : " + t-codfam) @ t-desmat
            (ACCUM SUB-TOTAL BY t-codfam t-venta[1]) @ t-venta[1] 
            (ACCUM SUB-TOTAL BY t-codfam t-venta[2]) @ t-venta[2] 
            (ACCUM SUB-TOTAL BY t-codfam t-venta[3]) @ t-venta[3] 
            (ACCUM SUB-TOTAL BY t-codfam t-venta[4]) @ t-venta[4] 
            (ACCUM SUB-TOTAL BY t-codfam t-venta[5]) @ t-venta[5] 
            (ACCUM SUB-TOTAL BY t-codfam t-venta[6]) @ t-venta[6] 
            (ACCUM SUB-TOTAL BY t-codfam t-venta[7]) @ t-venta[7] 
            (ACCUM SUB-TOTAL BY t-codfam t-venta[10]) @ t-venta[10] 
            WITH FRAME F-REPORTE.
         
      END.
  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[1]
            t-venta[2]
            t-venta[3]
            t-venta[4]
            t-venta[5]
            t-venta[6]
            t-venta[7]
            t-venta[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-venta[1]) @ t-venta[1]
            (ACCUM TOTAL BY t-codcia t-venta[2]) @ t-venta[2]
            (ACCUM TOTAL BY t-codcia t-venta[3]) @ t-venta[3]
            (ACCUM TOTAL BY t-codcia t-venta[4]) @ t-venta[4]
            (ACCUM TOTAL BY t-codcia t-venta[5]) @ t-venta[5]
            (ACCUM TOTAL BY t-codcia t-venta[6]) @ t-venta[6]
            (ACCUM TOTAL BY t-codcia t-venta[7]) @ t-venta[7]
            (ACCUM TOTAL BY t-codcia t-venta[10]) @ t-venta[10]
            WITH FRAME F-REPORTE.
      END.     
  END. 
  HIDE FRAME F-PROCESO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato2C W-Win 
PROCEDURE Formato2C :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-codmat    AT 1
         t-DesMat    FORMAT "X(40)"
         t-DesMar    FORMAT "X(6)" 
         t-UndBas    FORMAT "X(4)"
         t-Costo[1]  FORMAT "->>>>>>>9"
         t-Costo[2]  FORMAT "->>>>>>>9"
         t-Costo[3]  FORMAT "->>>>>>>9"
         t-Costo[4]  FORMAT "->>>>>>>9"
         t-Costo[5]  FORMAT "->>>>>>>9"
         t-Costo[6]  FORMAT "->>>>>>>9"
         t-Costo[7]  FORMAT "->>>>>>>9"
         t-Costo[10]  FORMAT "->>>>>>>9.99"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")"  AT 100 FORMAT "X(25)" SKIP(1)
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
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP
         "LOS IMPORTES INCLUYEN I.G.V "   At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  63 
        F-DIVISION-2 AT  75 
        F-DIVISION-3 AT  85 
        F-DIVISION-4 AT  95 
        F-DIVISION-5 AT  105
        F-DIVISION-6 AT  115
        "O T R O S"  AT  125
        "T O T A L"  AT  140 SKIP
        " CODIGO  D E S C R I P C I O N                MARCA   U.M     Costo      Costo     Costo     Costo      Costo     Costo      Costo                          " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo   /* WHERE t-Costo[10] <> 0 */
                     BREAK BY t-codcia
                           BY t-codfam 
                           BY t-subfam 
                           BY t-codmat:

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = t-CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "FAMILIA : "  FORMAT "X(15)" AT 1 
                                 t-codfam      FORMAT "X(05)" AT 17
                                 Almtfami.Desfam FORMAT "X(40)" AT 25 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.
         END.
      END.

      IF FIRST-OF(t-SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = S-CODCIA 
                        AND  Almsfami.codfam = t-CodFam 
                        AND  Almsfami.subfam = t-Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "SUB-FAMILIA : "  FORMAT "X(15)" AT 11 
                                 t-subfam      FORMAT "X(05)" AT 27
                                 AlmSfami.DesSub FORMAT "X(40)" AT 35 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" AT 11 SKIP.
         END.
      END.

      ACCUM  t-Costo[1]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[2]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[3]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[4]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[5]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[6]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[7]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[10]  (SUB-TOTAL BY t-codfam) .

      ACCUM  t-Costo[1]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[2]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[3]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[4]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[5]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[6]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[7]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[10]  (SUB-TOTAL BY t-subfam) .

      ACCUM  t-Costo[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[10]  ( TOTAL BY t-codcia) .
      
      DISPLAY STREAM REPORT 
                t-codmat
                t-DesMat
                t-DesMar
                t-UndBas
                t-Costo[1] WHEN  t-Costo[1] <> 0 FORMAT "->>>>>>>9"
                t-Costo[2] WHEN  t-Costo[2] <> 0 FORMAT "->>>>>>>9"
                t-Costo[3] WHEN  t-Costo[3] <> 0 FORMAT "->>>>>>>9"
                t-Costo[4] WHEN  t-Costo[4] <> 0 FORMAT "->>>>>>>9"
                t-Costo[5] WHEN  t-Costo[5] <> 0 FORMAT "->>>>>>>9"
                t-Costo[6] WHEN  t-Costo[6] <> 0 FORMAT "->>>>>>>9"
                t-Costo[7] WHEN  t-Costo[7] <> 0 FORMAT "->>>>>>>9"
                t-Costo[10]  FORMAT "->>>>>>>9.99"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.


      IF LAST-OF(t-SubFam) THEN DO:
        UNDERLINE STREAM REPORT 
            t-Costo[1]
            t-Costo[2]
            t-Costo[3]
            t-Costo[4]
            t-Costo[5]
            t-Costo[6]
            t-Costo[7]
            t-Costo[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL SUB-FAMILIA: " + t-subfam) @ t-desmat
            (ACCUM SUB-TOTAL BY t-subfam t-Costo[1]) @ t-Costo[1] 
            (ACCUM SUB-TOTAL BY t-subfam t-Costo[2]) @ t-Costo[2] 
            (ACCUM SUB-TOTAL BY t-subfam t-Costo[3]) @ t-Costo[3] 
            (ACCUM SUB-TOTAL BY t-subfam t-Costo[4]) @ t-Costo[4] 
            (ACCUM SUB-TOTAL BY t-subfam t-Costo[5]) @ t-Costo[5] 
            (ACCUM SUB-TOTAL BY t-subfam t-Costo[6]) @ t-Costo[6] 
            (ACCUM SUB-TOTAL BY t-subfam t-Costo[7]) @ t-Costo[7] 
            (ACCUM SUB-TOTAL BY t-subfam t-Costo[10]) @ t-Costo[10] 
            WITH FRAME F-REPORTE.

      END.

      IF LAST-OF(t-CodFam) THEN DO:
        UNDERLINE STREAM REPORT 
            t-Costo[1]
            t-Costo[2]
            t-Costo[3]
            t-Costo[4]
            t-Costo[5]
            t-Costo[6]
            t-Costo[7]
            t-Costo[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL FAMILIA : " + t-codfam) @ t-desmat
            (ACCUM SUB-TOTAL BY t-codfam t-Costo[1]) @ t-Costo[1] 
            (ACCUM SUB-TOTAL BY t-codfam t-Costo[2]) @ t-Costo[2] 
            (ACCUM SUB-TOTAL BY t-codfam t-Costo[3]) @ t-Costo[3] 
            (ACCUM SUB-TOTAL BY t-codfam t-Costo[4]) @ t-Costo[4] 
            (ACCUM SUB-TOTAL BY t-codfam t-Costo[5]) @ t-Costo[5] 
            (ACCUM SUB-TOTAL BY t-codfam t-Costo[6]) @ t-Costo[6] 
            (ACCUM SUB-TOTAL BY t-codfam t-Costo[7]) @ t-Costo[7] 
            (ACCUM SUB-TOTAL BY t-codfam t-Costo[10]) @ t-Costo[10] 
            WITH FRAME F-REPORTE.
         
      END.
  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-Costo[1]
            t-Costo[2]
            t-Costo[3]
            t-Costo[4]
            t-Costo[5]
            t-Costo[6]
            t-Costo[7]
            t-Costo[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-Costo[1]) @ t-Costo[1]
            (ACCUM TOTAL BY t-codcia t-Costo[2]) @ t-Costo[2]
            (ACCUM TOTAL BY t-codcia t-Costo[3]) @ t-Costo[3]
            (ACCUM TOTAL BY t-codcia t-Costo[4]) @ t-Costo[4]
            (ACCUM TOTAL BY t-codcia t-Costo[5]) @ t-Costo[5]
            (ACCUM TOTAL BY t-codcia t-Costo[6]) @ t-Costo[6]
            (ACCUM TOTAL BY t-codcia t-Costo[7]) @ t-Costo[7]
            (ACCUM TOTAL BY t-codcia t-Costo[10]) @ t-Costo[10]
            WITH FRAME F-REPORTE.
      END.
  END.
  HIDE FRAME F-PROCESO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato2D W-Win 
PROCEDURE Formato2D :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-codmat    AT 1
         t-DesMat    FORMAT "X(40)"
         t-DesMar    FORMAT "X(6)" 
         t-UndBas    FORMAT "X(4)"
         t-Marge[1]  FORMAT "->>>>>>>9"
         t-Marge[2]  FORMAT "->>>>>>>9"
         t-Marge[3]  FORMAT "->>>>>>>9"
         t-Marge[4]  FORMAT "->>>>>>>9"
         t-Marge[5]  FORMAT "->>>>>>>9"
         t-Marge[6]  FORMAT "->>>>>>>9"
         t-Marge[7]  FORMAT "->>>>>>>9"
         t-Marge[10]  FORMAT "->>>>>>>9.99"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
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
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  63 
        F-DIVISION-2 AT  75 
        F-DIVISION-3 AT  85 
        F-DIVISION-4 AT  95 
        F-DIVISION-5 AT  105
        F-DIVISION-6 AT  115
        "O T R O S"  AT  125
        "T O T A L"  AT  140 SKIP
        " CODIGO  D E S C R I P C I O N                MARCA   U.M     Marge      Marge     Marge     Marge      Marge     Marge      Marge                          " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo   /* WHERE t-Marge[10] <> 0 */
                     BREAK BY t-codcia
                           BY t-codfam 
                           BY t-subfam 
                           BY t-codmat:

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = t-CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "FAMILIA : "  FORMAT "X(15)" AT 1 
                                 t-codfam      FORMAT "X(05)" AT 17
                                 Almtfami.Desfam FORMAT "X(40)" AT 25 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.
         END.
      END.

      IF FIRST-OF(t-SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = S-CODCIA 
                        AND  Almsfami.codfam = t-CodFam 
                        AND  Almsfami.subfam = t-Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "SUB-FAMILIA : "  FORMAT "X(15)" AT 11 
                                 t-subfam      FORMAT "X(05)" AT 27
                                 AlmSfami.DesSub FORMAT "X(40)" AT 35 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" AT 11 SKIP.
         END.
      END.

      T-Marge[1] = (T-Venta[1] - T-Costo[1]) / T-Venta[1] .
      T-Marge[2] = (T-Venta[2] - T-Costo[2]) / T-Venta[2] .
      T-Marge[3] = (T-Venta[3] - T-Costo[3]) / T-Venta[3] .
      T-Marge[4] = (T-Venta[4] - T-Costo[4]) / T-Venta[4] .
      T-Marge[5] = (T-Venta[5] - T-Costo[5]) / T-Venta[5] .
      T-Marge[6] = (T-Venta[6] - T-Costo[6]) / T-Venta[6] .
      T-Marge[7] = (T-Venta[7] - T-Costo[7]) / T-Venta[7] .
      T-Marge[10] = (T-Venta[10] - T-Costo[10]) / T-Venta[10] .

      ACCUM  t-Marge[1]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Marge[2]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Marge[3]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Marge[4]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Marge[5]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Marge[6]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Marge[7]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Marge[10]  (SUB-TOTAL BY t-codfam) .

      ACCUM  t-Marge[1]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Marge[2]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Marge[3]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Marge[4]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Marge[5]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Marge[6]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Marge[7]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Marge[10]  (SUB-TOTAL BY t-subfam) .

      ACCUM  t-Marge[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[10]  ( TOTAL BY t-codcia) .
      
      ACCUM  t-Venta[1]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Venta[2]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Venta[3]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Venta[4]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Venta[5]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Venta[6]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Venta[7]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Venta[10]  (SUB-TOTAL BY t-codfam) .

      ACCUM  t-Venta[1]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Venta[2]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Venta[3]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Venta[4]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Venta[5]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Venta[6]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Venta[7]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Venta[10]  (SUB-TOTAL BY t-subfam) .

      ACCUM  t-Venta[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[10]  ( TOTAL BY t-codcia) .

      ACCUM  t-Costo[1]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[2]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[3]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[4]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[5]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[6]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[7]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[10]  (SUB-TOTAL BY t-codfam) .

      ACCUM  t-Costo[1]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[2]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[3]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[4]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[5]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[6]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[7]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[10]  (SUB-TOTAL BY t-subfam) .

      ACCUM  t-Costo[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[10]  ( TOTAL BY t-codcia) .


      DISPLAY STREAM REPORT 
                t-codmat
                t-DesMat
                t-DesMar
                t-UndBas
                t-Marge[1] WHEN  t-Marge[1] <> 0 FORMAT "->>>>>>>9"
                t-Marge[2] WHEN  t-Marge[2] <> 0 FORMAT "->>>>>>>9"
                t-Marge[3] WHEN  t-Marge[3] <> 0 FORMAT "->>>>>>>9"
                t-Marge[4] WHEN  t-Marge[4] <> 0 FORMAT "->>>>>>>9"
                t-Marge[5] WHEN  t-Marge[5] <> 0 FORMAT "->>>>>>>9"
                t-Marge[6] WHEN  t-Marge[6] <> 0 FORMAT "->>>>>>>9"
                t-Marge[7] WHEN  t-Marge[7] <> 0 FORMAT "->>>>>>>9"
                t-Marge[10]  FORMAT "->>>>>>>9.99"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.


      IF LAST-OF(t-SubFam) THEN DO:
        UNDERLINE STREAM REPORT 
            t-Marge[1]
            t-Marge[2]
            t-Marge[3]
            t-Marge[4]
            t-Marge[5]
            t-Marge[6]
            t-Marge[7]
            t-Marge[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL SUB-FAMILIA: " + t-subfam) @ t-desmat
            ((ACCUM SUB-TOTAL BY t-subfam t-Venta[1]) - (ACCUM SUB-TOTAL BY t-subfam t-Costo[1])) / (ACCUM SUB-TOTAL BY t-subfam t-Venta[1]) @ t-Marge[1] 
            ((ACCUM SUB-TOTAL BY t-subfam t-Venta[2]) - (ACCUM SUB-TOTAL BY t-subfam t-Costo[2])) / (ACCUM SUB-TOTAL BY t-subfam t-Venta[2]) @ t-Marge[2] 
            ((ACCUM SUB-TOTAL BY t-subfam t-Venta[3]) - (ACCUM SUB-TOTAL BY t-subfam t-Costo[3])) / (ACCUM SUB-TOTAL BY t-subfam t-Venta[3]) @ t-Marge[3] 
            ((ACCUM SUB-TOTAL BY t-subfam t-Venta[4]) - (ACCUM SUB-TOTAL BY t-subfam t-Costo[4])) / (ACCUM SUB-TOTAL BY t-subfam t-Venta[4]) @ t-Marge[4] 
            ((ACCUM SUB-TOTAL BY t-subfam t-Venta[5]) - (ACCUM SUB-TOTAL BY t-subfam t-Costo[5])) / (ACCUM SUB-TOTAL BY t-subfam t-Venta[5]) @ t-Marge[5] 
            ((ACCUM SUB-TOTAL BY t-subfam t-Venta[6]) - (ACCUM SUB-TOTAL BY t-subfam t-Costo[6])) / (ACCUM SUB-TOTAL BY t-subfam t-Venta[6]) @ t-Marge[6] 
            ((ACCUM SUB-TOTAL BY t-subfam t-Venta[7]) - (ACCUM SUB-TOTAL BY t-subfam t-Costo[7])) / (ACCUM SUB-TOTAL BY t-subfam t-Venta[7]) @ t-Marge[7] 
            ((ACCUM SUB-TOTAL BY t-subfam t-Venta[10]) - (ACCUM SUB-TOTAL BY t-subfam t-Costo[10])) / (ACCUM SUB-TOTAL BY t-subfam t-Venta[10]) @ t-Marge[10] 
            WITH FRAME F-REPORTE.

      END.

      IF LAST-OF(t-CodFam) THEN DO:
        UNDERLINE STREAM REPORT 
            t-Marge[1]
            t-Marge[2]
            t-Marge[3]
            t-Marge[4]
            t-Marge[5]
            t-Marge[6]
            t-Marge[7]
            t-Marge[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL FAMILIA : " + t-codfam) @ t-desmat
            ((ACCUM SUB-TOTAL BY t-codfam t-Venta[1]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[1])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[1]) @ t-Marge[1] 
            ((ACCUM SUB-TOTAL BY t-codfam t-Venta[2]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[2])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[2]) @ t-Marge[2] 
            ((ACCUM SUB-TOTAL BY t-codfam t-Venta[3]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[3])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[3]) @ t-Marge[3] 
            ((ACCUM SUB-TOTAL BY t-codfam t-Venta[4]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[4])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[4]) @ t-Marge[4] 
            ((ACCUM SUB-TOTAL BY t-codfam t-Venta[5]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[5])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[5]) @ t-Marge[5] 
            ((ACCUM SUB-TOTAL BY t-codfam t-Venta[6]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[6])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[6]) @ t-Marge[6] 
            ((ACCUM SUB-TOTAL BY t-codfam t-Venta[7]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[7])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[7]) @ t-Marge[7] 
            ((ACCUM SUB-TOTAL BY t-codfam t-Venta[10]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[10])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[10]) @ t-Marge[10] 
            WITH FRAME F-REPORTE.
         
      END.
  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-Marge[1]
            t-Marge[2]
            t-Marge[3]
            t-Marge[4]
            t-Marge[5]
            t-Marge[6]
            t-Marge[7]
            t-Marge[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            ((ACCUM TOTAL BY t-codcia t-Venta[1]) - (ACCUM TOTAL BY t-codcia t-Costo[1])) / (ACCUM TOTAL BY t-codcia t-Venta[1]) @ t-Marge[1]
            ((ACCUM TOTAL BY t-codcia t-Venta[2]) - (ACCUM TOTAL BY t-codcia t-Costo[2])) / (ACCUM TOTAL BY t-codcia t-Venta[2]) @ t-Marge[2]
            ((ACCUM TOTAL BY t-codcia t-Venta[3]) - (ACCUM TOTAL BY t-codcia t-Costo[3])) / (ACCUM TOTAL BY t-codcia t-Venta[3]) @ t-Marge[3]
            ((ACCUM TOTAL BY t-codcia t-Venta[4]) - (ACCUM TOTAL BY t-codcia t-Costo[4])) / (ACCUM TOTAL BY t-codcia t-Venta[4]) @ t-Marge[4]
            ((ACCUM TOTAL BY t-codcia t-Venta[5]) - (ACCUM TOTAL BY t-codcia t-Costo[5])) / (ACCUM TOTAL BY t-codcia t-Venta[5]) @ t-Marge[5]
            ((ACCUM TOTAL BY t-codcia t-Venta[6]) - (ACCUM TOTAL BY t-codcia t-Costo[6])) / (ACCUM TOTAL BY t-codcia t-Venta[6]) @ t-Marge[6]
            ((ACCUM TOTAL BY t-codcia t-Venta[7]) - (ACCUM TOTAL BY t-codcia t-Costo[7])) / (ACCUM TOTAL BY t-codcia t-Venta[7]) @ t-Marge[7]
            ((ACCUM TOTAL BY t-codcia t-Venta[10]) - (ACCUM TOTAL BY t-codcia t-Costo[10])) / (ACCUM TOTAL BY t-codcia t-Venta[10]) @ t-Marge[1]
            WITH FRAME F-REPORTE.
      END.
     

  END.
   
  

  HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato2E W-Win 
PROCEDURE Formato2E :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-codmat    AT 1
         t-DesMat    FORMAT "X(40)"
         t-DesMar    FORMAT "X(6)" 
         t-UndBas    FORMAT "X(4)"
         t-Utili[1]  FORMAT "->>>>>>>9"
         t-Utili[2]  FORMAT "->>>>>>>9"
         t-Utili[3]  FORMAT "->>>>>>>9"
         t-Utili[4]  FORMAT "->>>>>>>9"
         t-Utili[5]  FORMAT "->>>>>>>9"
         t-Utili[6]  FORMAT "->>>>>>>9"
         t-Utili[7]  FORMAT "->>>>>>>9"
         t-Utili[10]  FORMAT "->>>>>>>9.99"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
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
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  63 
        F-DIVISION-2 AT  75 
        F-DIVISION-3 AT  85 
        F-DIVISION-4 AT  95 
        F-DIVISION-5 AT  105
        F-DIVISION-6 AT  115
        "O T R O S"  AT  125
        "T O T A L"  AT  140 SKIP
        " CODIGO  D E S C R I P C I O N                MARCA   U.M     Utili      Utili     Utili     Utili      Utili     Utili      Utili                          " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo   /* WHERE t-Utili[10] <> 0 */
                     BREAK BY t-codcia
                           BY t-codfam 
                           BY t-subfam 
                           BY t-codmat:

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = t-CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "FAMILIA : "  FORMAT "X(15)" AT 1 
                                 t-codfam      FORMAT "X(05)" AT 17
                                 Almtfami.Desfam  FORMAT "X(40)" AT 25 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.
         END.
      END.

      IF FIRST-OF(t-SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = S-CODCIA 
                        AND  Almsfami.codfam = t-CodFam 
                        AND  Almsfami.subfam = t-Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "SUB-FAMILIA : "  FORMAT "X(15)" AT 11 
                                 t-subfam      FORMAT "X(05)" AT 27
                                 AlmSfami.DesSub FORMAT "X(40)" AT 35 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" AT 11 SKIP.
         END.
      END.

      ACCUM  t-Utili[1]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Utili[2]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Utili[3]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Utili[4]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Utili[5]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Utili[6]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Utili[7]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Utili[10]  (SUB-TOTAL BY t-codfam) .

      ACCUM  t-Utili[1]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Utili[2]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Utili[3]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Utili[4]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Utili[5]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Utili[6]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Utili[7]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Utili[10]  (SUB-TOTAL BY t-subfam) .

      ACCUM  t-Utili[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[10]  ( TOTAL BY t-codcia) .
      
      DISPLAY STREAM REPORT 
                t-codmat
                t-DesMat
                t-DesMar
                t-UndBas
                t-Utili[1] WHEN  t-Utili[1] <> 0 FORMAT "->>>>>>>9"
                t-Utili[2] WHEN  t-Utili[2] <> 0 FORMAT "->>>>>>>9"
                t-Utili[3] WHEN  t-Utili[3] <> 0 FORMAT "->>>>>>>9"
                t-Utili[4] WHEN  t-Utili[4] <> 0 FORMAT "->>>>>>>9"
                t-Utili[5] WHEN  t-Utili[5] <> 0 FORMAT "->>>>>>>9"
                t-Utili[6] WHEN  t-Utili[6] <> 0 FORMAT "->>>>>>>9"
                t-Utili[7] WHEN  t-Utili[7] <> 0 FORMAT "->>>>>>>9"
                t-Utili[10]  FORMAT "->>>>>>>9.99"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.


      IF LAST-OF(t-SubFam) THEN DO:
        UNDERLINE STREAM REPORT 
            t-Utili[1]
            t-Utili[2]
            t-Utili[3]
            t-Utili[4]
            t-Utili[5]
            t-Utili[6]
            t-Utili[7]
            t-Utili[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL SUB-FAMILIA: " + t-subfam) @ t-desmat
            (ACCUM SUB-TOTAL BY t-subfam t-Utili[1]) @ t-Utili[1] 
            (ACCUM SUB-TOTAL BY t-subfam t-Utili[2]) @ t-Utili[2] 
            (ACCUM SUB-TOTAL BY t-subfam t-Utili[3]) @ t-Utili[3] 
            (ACCUM SUB-TOTAL BY t-subfam t-Utili[4]) @ t-Utili[4] 
            (ACCUM SUB-TOTAL BY t-subfam t-Utili[5]) @ t-Utili[5] 
            (ACCUM SUB-TOTAL BY t-subfam t-Utili[6]) @ t-Utili[6] 
            (ACCUM SUB-TOTAL BY t-subfam t-Utili[7]) @ t-Utili[7] 
            (ACCUM SUB-TOTAL BY t-subfam t-Utili[10]) @ t-Utili[10] 
            WITH FRAME F-REPORTE.

      END.

      IF LAST-OF(t-CodFam) THEN DO:
        UNDERLINE STREAM REPORT 
            t-Utili[1]
            t-Utili[2]
            t-Utili[3]
            t-Utili[4]
            t-Utili[5]
            t-Utili[6]
            t-Utili[7]
            t-Utili[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL FAMILIA : " + t-codfam) @ t-desmat
            (ACCUM SUB-TOTAL BY t-codfam t-Utili[1]) @ t-Utili[1] 
            (ACCUM SUB-TOTAL BY t-codfam t-Utili[2]) @ t-Utili[2] 
            (ACCUM SUB-TOTAL BY t-codfam t-Utili[3]) @ t-Utili[3] 
            (ACCUM SUB-TOTAL BY t-codfam t-Utili[4]) @ t-Utili[4] 
            (ACCUM SUB-TOTAL BY t-codfam t-Utili[5]) @ t-Utili[5] 
            (ACCUM SUB-TOTAL BY t-codfam t-Utili[6]) @ t-Utili[6] 
            (ACCUM SUB-TOTAL BY t-codfam t-Utili[7]) @ t-Utili[7] 
            (ACCUM SUB-TOTAL BY t-codfam t-Utili[10]) @ t-Utili[10] 
            WITH FRAME F-REPORTE.
         
      END.
  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-Utili[1]
            t-Utili[2]
            t-Utili[3]
            t-Utili[4]
            t-Utili[5]
            t-Utili[6]
            t-Utili[7]
            t-Utili[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-Utili[1]) @ t-Utili[1]
            (ACCUM TOTAL BY t-codcia t-Utili[2]) @ t-Utili[2]
            (ACCUM TOTAL BY t-codcia t-Utili[3]) @ t-Utili[3]
            (ACCUM TOTAL BY t-codcia t-Utili[4]) @ t-Utili[4]
            (ACCUM TOTAL BY t-codcia t-Utili[5]) @ t-Utili[5]
            (ACCUM TOTAL BY t-codcia t-Utili[6]) @ t-Utili[6]
            (ACCUM TOTAL BY t-codcia t-Utili[7]) @ t-Utili[7]
            (ACCUM TOTAL BY t-codcia t-Utili[10]) @ t-Utili[10]
            WITH FRAME F-REPORTE.
      END.
     

  END.
   
  

  HIDE FRAME F-PROCESO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato3 W-Win 
PROCEDURE Formato3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
CASE C-Tipo-2:
    WHEN "Cantidad"  THEN RUN Formato3A.
    WHEN "Venta"     THEN RUN Formato3B.
    WHEN "Costo"     THEN RUN Formato3C.
    WHEN "Margen"    THEN RUN Formato3D.
    WHEN "Utilidad"  THEN RUN Formato3E.
END CASE.  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato3A W-Win 
PROCEDURE Formato3A :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato3B W-Win 
PROCEDURE Formato3B :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-prove     AT 1
         t-DesMat    FORMAT "X(40)"
         t-Venta[1]  FORMAT "->>>,>>>,>>9"
         t-Venta[2]  FORMAT "->>>,>>>,>>9"
         t-Venta[3]  FORMAT "->>>,>>>,>>9"
         t-Venta[4]  FORMAT "->>>,>>>,>>9"
         t-Venta[5]  FORMAT "->>>,>>>,>>9"
         t-Venta[6]  FORMAT "->>>,>>>,>>9"
         t-Venta[7]  FORMAT "->>>,>>>,>>9"
         t-Venta[10]  FORMAT "->>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")"  AT 100 FORMAT "X(25)" SKIP(1)
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
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP
         "LOS IMPORTES INCLUYEN I.G.V "   At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  50 
        F-DIVISION-2 AT  63 
        F-DIVISION-3 AT  76 
        F-DIVISION-4 AT  89 
        F-DIVISION-5 AT  102
        F-DIVISION-6 AT  115
        "O T R O S"  AT  128
        "T O T A L"  AT  142 SKIP
        " CODIGO      NOMBRE O RAZON SOCIAL                Venta        Venta        Venta        Venta       Venta        Venta       Venta        Venta    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo /* WHERE t-canti[10] > 0 */
                     BREAK BY t-codcia
                           BY t-prove:

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      ACCUM  t-venta[1]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-venta[2]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-venta[3]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-venta[4]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-venta[5]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-venta[6]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-venta[7]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-venta[10]  (SUB-TOTAL BY t-prove) .

      ACCUM  t-venta[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[10]  ( TOTAL BY t-codcia) .

      IF LAST-OF(t-prove) THEN DO:
         FIND GN-PROV WHERE GN-PROV.CODCIA = pv-codcia
                       AND  GN-PROV.CODPRO = t-prove 
                      NO-LOCK NO-ERROR.
         IF AVAILABLE GN-PROV THEN DO:
             DISPLAY STREAM REPORT 
             t-prove  
             Gn-prov.Nompro @ t-desmat
             (ACCUM SUB-TOTAL BY t-prove t-venta[1]) @ t-venta[1] 
             (ACCUM SUB-TOTAL BY t-prove t-venta[2]) @ t-venta[2] 
             (ACCUM SUB-TOTAL BY t-prove t-venta[3]) @ t-venta[3] 
             (ACCUM SUB-TOTAL BY t-prove t-venta[4]) @ t-venta[4] 
             (ACCUM SUB-TOTAL BY t-prove t-venta[5]) @ t-venta[5] 
             (ACCUM SUB-TOTAL BY t-prove t-venta[6]) @ t-venta[6] 
             (ACCUM SUB-TOTAL BY t-prove t-venta[7]) @ t-venta[7] 
             (ACCUM SUB-TOTAL BY t-prove t-venta[10]) @ t-venta[10] 
             WITH FRAME F-REPORTE.
                                
         END.  

      END.
  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[1]
            t-venta[2]
            t-venta[3]
            t-venta[4]
            t-venta[5]
            t-venta[6]
            t-venta[7]
            t-venta[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-venta[1]) @ t-venta[1]
            (ACCUM TOTAL BY t-codcia t-venta[2]) @ t-venta[2]
            (ACCUM TOTAL BY t-codcia t-venta[3]) @ t-venta[3]
            (ACCUM TOTAL BY t-codcia t-venta[4]) @ t-venta[4]
            (ACCUM TOTAL BY t-codcia t-venta[5]) @ t-venta[5]
            (ACCUM TOTAL BY t-codcia t-venta[6]) @ t-venta[6]
            (ACCUM TOTAL BY t-codcia t-venta[7]) @ t-venta[7]
            (ACCUM TOTAL BY t-codcia t-venta[10]) @ t-venta[10]
            WITH FRAME F-REPORTE.
            
      END.
     

  END.
   
  

  HIDE FRAME F-PROCESO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato3C W-Win 
PROCEDURE Formato3C :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-prove     AT 1
         t-DesMat    FORMAT "X(40)"
         t-Costo[1]  FORMAT "->>>,>>>,>>9"
         t-Costo[2]  FORMAT "->>>,>>>,>>9"
         t-Costo[3]  FORMAT "->>>,>>>,>>9"
         t-Costo[4]  FORMAT "->>>,>>>,>>9"
         t-Costo[5]  FORMAT "->>>,>>>,>>9"
         t-Costo[6]  FORMAT "->>>,>>>,>>9"
         t-Costo[7]  FORMAT "->>>,>>>,>>9"
         t-Costo[10]  FORMAT "->>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
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
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP
         "LOS IMPORTES INCLUYEN I.G.V "   At 1 FORMAT "X(150)" SKIP


        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  50 
        F-DIVISION-2 AT  63 
        F-DIVISION-3 AT  76 
        F-DIVISION-4 AT  89 
        F-DIVISION-5 AT  102
        F-DIVISION-6 AT  115
        "O T R O S"  AT  128
        "T O T A L"  AT  142 SKIP
        " CODIGO      NOMBRE O RAZON SOCIAL                Costo        Costo        Costo        Costo       Costo        Costo       Costo        Costo    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo /* WHERE t-canti[10] > 0 */
                     BREAK BY t-codcia
                           BY t-prove:

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      ACCUM  t-Costo[1]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Costo[2]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Costo[3]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Costo[4]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Costo[5]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Costo[6]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Costo[7]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Costo[10]  (SUB-TOTAL BY t-prove) .

      ACCUM  t-Costo[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[10]  ( TOTAL BY t-codcia) .

      IF LAST-OF(t-prove) THEN DO:
         FIND GN-PROV WHERE GN-PROV.CODCIA = pv-codcia
                       AND  GN-PROV.CODPRO = t-prove 
                      NO-LOCK NO-ERROR.
         IF AVAILABLE GN-PROV THEN DO:
             DISPLAY STREAM REPORT 
             t-prove  
             Gn-prov.Nompro @ t-desmat
             (ACCUM SUB-TOTAL BY t-prove t-Costo[1]) @ t-Costo[1] 
             (ACCUM SUB-TOTAL BY t-prove t-Costo[2]) @ t-Costo[2] 
             (ACCUM SUB-TOTAL BY t-prove t-Costo[3]) @ t-Costo[3] 
             (ACCUM SUB-TOTAL BY t-prove t-Costo[4]) @ t-Costo[4] 
             (ACCUM SUB-TOTAL BY t-prove t-Costo[5]) @ t-Costo[5] 
             (ACCUM SUB-TOTAL BY t-prove t-Costo[6]) @ t-Costo[6] 
             (ACCUM SUB-TOTAL BY t-prove t-Costo[7]) @ t-Costo[7] 
             (ACCUM SUB-TOTAL BY t-prove t-Costo[10]) @ t-Costo[10] 
             WITH FRAME F-REPORTE.
                                
         END.  

      END.
  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-Costo[1]
            t-Costo[2]
            t-Costo[3]
            t-Costo[4]
            t-Costo[5]
            t-Costo[6]
            t-Costo[7]
            t-Costo[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-Costo[1]) @ t-Costo[1]
            (ACCUM TOTAL BY t-codcia t-Costo[2]) @ t-Costo[2]
            (ACCUM TOTAL BY t-codcia t-Costo[3]) @ t-Costo[3]
            (ACCUM TOTAL BY t-codcia t-Costo[4]) @ t-Costo[4]
            (ACCUM TOTAL BY t-codcia t-Costo[5]) @ t-Costo[5]
            (ACCUM TOTAL BY t-codcia t-Costo[6]) @ t-Costo[6]
            (ACCUM TOTAL BY t-codcia t-Costo[7]) @ t-Costo[7]
            (ACCUM TOTAL BY t-codcia t-Costo[10]) @ t-Costo[10]
            WITH FRAME F-REPORTE.
            
      END.
     

  END.
   
  

  HIDE FRAME F-PROCESO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato3D W-Win 
PROCEDURE Formato3D :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-prove     AT 1
         t-DesMat    FORMAT "X(40)"
         t-Marge[1]  FORMAT "->>>,>>>,>>9"
         t-Marge[2]  FORMAT "->>>,>>>,>>9"
         t-Marge[3]  FORMAT "->>>,>>>,>>9"
         t-Marge[4]  FORMAT "->>>,>>>,>>9"
         t-Marge[5]  FORMAT "->>>,>>>,>>9"
         t-Marge[6]  FORMAT "->>>,>>>,>>9"
         t-Marge[7]  FORMAT "->>>,>>>,>>9"
         t-Marge[10]  FORMAT "->>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
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
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  50 
        F-DIVISION-2 AT  63 
        F-DIVISION-3 AT  76 
        F-DIVISION-4 AT  89 
        F-DIVISION-5 AT  102
        F-DIVISION-6 AT  115
        "O T R O S"  AT  128
        "T O T A L"  AT  142 SKIP
        " CODIGO      NOMBRE O RAZON SOCIAL                Marge        Marge        Marge        Marge       Marge        Marge       Marge        Marge    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo /* WHERE t-canti[10] > 0 */
                     BREAK BY t-codcia
                           BY t-prove:

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      T-Marge[1] = (T-Venta[1] - T-Costo[1]) / T-Venta[1] .
      T-Marge[2] = (T-Venta[2] - T-Costo[2]) / T-Venta[2] .
      T-Marge[3] = (T-Venta[3] - T-Costo[3]) / T-Venta[3] .
      T-Marge[4] = (T-Venta[4] - T-Costo[4]) / T-Venta[4] .
      T-Marge[5] = (T-Venta[5] - T-Costo[5]) / T-Venta[5] .
      T-Marge[6] = (T-Venta[6] - T-Costo[6]) / T-Venta[6] .
      T-Marge[7] = (T-Venta[7] - T-Costo[7]) / T-Venta[7] .
      T-Marge[10] = (T-Venta[10] - T-Costo[10]) / T-Venta[10] .

      ACCUM  t-Marge[1]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Marge[2]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Marge[3]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Marge[4]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Marge[5]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Marge[6]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Marge[7]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Marge[10]  (SUB-TOTAL BY t-prove) .

      ACCUM  t-Marge[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[10]  ( TOTAL BY t-codcia) .

      ACCUM  t-Venta[1]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Venta[2]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Venta[3]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Venta[4]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Venta[5]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Venta[6]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Venta[7]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Venta[10]  (SUB-TOTAL BY t-prove) .

      ACCUM  t-Venta[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[10]  ( TOTAL BY t-codcia) .

      ACCUM  t-Costo[1]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Costo[2]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Costo[3]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Costo[4]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Costo[5]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Costo[6]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Costo[7]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Costo[10]  (SUB-TOTAL BY t-prove) .

      ACCUM  t-Costo[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[10]  ( TOTAL BY t-codcia) .

      IF LAST-OF(t-prove) THEN DO:
         FIND GN-PROV WHERE GN-PROV.CODCIA = pv-codcia
                       AND  GN-PROV.CODPRO = t-prove 
                      NO-LOCK NO-ERROR.
         IF AVAILABLE GN-PROV THEN DO:
             DISPLAY STREAM REPORT 
             t-prove  
             Gn-prov.Nompro @ t-desmat
             ((ACCUM SUB-TOTAL BY t-prove t-Venta[1]) - (ACCUM SUB-TOTAL BY t-prove t-Costo[1])) / (ACCUM SUB-TOTAL BY t-prove t-Venta[1]) @ t-Marge[1] 
             ((ACCUM SUB-TOTAL BY t-prove t-Venta[2]) - (ACCUM SUB-TOTAL BY t-prove t-Costo[2])) / (ACCUM SUB-TOTAL BY t-prove t-Venta[2]) @ t-Marge[2] 
             ((ACCUM SUB-TOTAL BY t-prove t-Venta[3]) - (ACCUM SUB-TOTAL BY t-prove t-Costo[3])) / (ACCUM SUB-TOTAL BY t-prove t-Venta[3]) @ t-Marge[3] 
             ((ACCUM SUB-TOTAL BY t-prove t-Venta[4]) - (ACCUM SUB-TOTAL BY t-prove t-Costo[4])) / (ACCUM SUB-TOTAL BY t-prove t-Venta[4]) @ t-Marge[4] 
             ((ACCUM SUB-TOTAL BY t-prove t-Venta[5]) - (ACCUM SUB-TOTAL BY t-prove t-Costo[5])) / (ACCUM SUB-TOTAL BY t-prove t-Venta[5]) @ t-Marge[5] 
             ((ACCUM SUB-TOTAL BY t-prove t-Venta[6]) - (ACCUM SUB-TOTAL BY t-prove t-Costo[6])) / (ACCUM SUB-TOTAL BY t-prove t-Venta[6]) @ t-Marge[6] 
             ((ACCUM SUB-TOTAL BY t-prove t-Venta[7]) - (ACCUM SUB-TOTAL BY t-prove t-Costo[7])) / (ACCUM SUB-TOTAL BY t-prove t-Venta[7]) @ t-Marge[7] 
             ((ACCUM SUB-TOTAL BY t-prove t-Venta[10]) - (ACCUM SUB-TOTAL BY t-prove t-Costo[10])) / (ACCUM SUB-TOTAL BY t-prove t-Venta[10]) @ t-Marge[10] 
             WITH FRAME F-REPORTE.
                                
         END.  

      END.
  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-Marge[1]
            t-Marge[2]
            t-Marge[3]
            t-Marge[4]
            t-Marge[5]
            t-Marge[6]
            t-Marge[7]
            t-Marge[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            ((ACCUM TOTAL BY t-codcia t-Venta[1]) - (ACCUM TOTAL BY t-codcia t-Costo[1])) / (ACCUM TOTAL BY t-codcia t-Venta[1]) @ t-Marge[1]
            ((ACCUM TOTAL BY t-codcia t-Venta[2]) - (ACCUM TOTAL BY t-codcia t-Costo[2])) / (ACCUM TOTAL BY t-codcia t-Venta[2]) @ t-Marge[2]
            ((ACCUM TOTAL BY t-codcia t-Venta[3]) - (ACCUM TOTAL BY t-codcia t-Costo[3])) / (ACCUM TOTAL BY t-codcia t-Venta[3]) @ t-Marge[3]
            ((ACCUM TOTAL BY t-codcia t-Venta[4]) - (ACCUM TOTAL BY t-codcia t-Costo[4])) / (ACCUM TOTAL BY t-codcia t-Venta[4]) @ t-Marge[4]
            ((ACCUM TOTAL BY t-codcia t-Venta[5]) - (ACCUM TOTAL BY t-codcia t-Costo[5])) / (ACCUM TOTAL BY t-codcia t-Venta[5]) @ t-Marge[5]
            ((ACCUM TOTAL BY t-codcia t-Venta[6]) - (ACCUM TOTAL BY t-codcia t-Costo[6])) / (ACCUM TOTAL BY t-codcia t-Venta[6]) @ t-Marge[6]
            ((ACCUM TOTAL BY t-codcia t-Venta[7]) - (ACCUM TOTAL BY t-codcia t-Costo[7])) / (ACCUM TOTAL BY t-codcia t-Venta[7]) @ t-Marge[7]
            ((ACCUM TOTAL BY t-codcia t-Venta[10]) - (ACCUM TOTAL BY t-codcia t-Costo[10])) / (ACCUM TOTAL BY t-codcia t-Venta[10]) @ t-Marge[10]
            WITH FRAME F-REPORTE.
            
      END.
     

  END.
   
  

  HIDE FRAME F-PROCESO.

 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato3E W-Win 
PROCEDURE Formato3E :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-prove     AT 1
         t-DesMat    FORMAT "X(40)"
         t-Utili[1]  FORMAT "->>>,>>>,>>9"
         t-Utili[2]  FORMAT "->>>,>>>,>>9"
         t-Utili[3]  FORMAT "->>>,>>>,>>9"
         t-Utili[4]  FORMAT "->>>,>>>,>>9"
         t-Utili[5]  FORMAT "->>>,>>>,>>9"
         t-Utili[6]  FORMAT "->>>,>>>,>>9"
         t-Utili[7]  FORMAT "->>>,>>>,>>9"
         t-Utili[10]  FORMAT "->>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
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
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  50 
        F-DIVISION-2 AT  63 
        F-DIVISION-3 AT  76 
        F-DIVISION-4 AT  89 
        F-DIVISION-5 AT  102
        F-DIVISION-6 AT  115
        "O T R O S"  AT  128
        "T O T A L"  AT  142 SKIP
        " CODIGO      NOMBRE O RAZON SOCIAL                Utili        Utili        Utili        Utili       Utili        Utili       Utili        Utili    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo /* WHERE t-canti[10] > 0 */
                     BREAK BY t-codcia
                           BY t-prove:

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      ACCUM  t-Utili[1]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Utili[2]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Utili[3]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Utili[4]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Utili[5]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Utili[6]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Utili[7]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-Utili[10]  (SUB-TOTAL BY t-prove) .

      ACCUM  t-Utili[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[10]  ( TOTAL BY t-codcia) .

      IF LAST-OF(t-prove) THEN DO:
         FIND GN-PROV WHERE GN-PROV.CODCIA = pv-codcia
                       AND  GN-PROV.CODPRO = t-prove 
                      NO-LOCK NO-ERROR.
         IF AVAILABLE GN-PROV THEN DO:
             DISPLAY STREAM REPORT 
             t-prove  
             Gn-prov.Nompro @ t-desmat
             (ACCUM SUB-TOTAL BY t-prove t-Utili[1]) @ t-Utili[1] 
             (ACCUM SUB-TOTAL BY t-prove t-Utili[2]) @ t-Utili[2] 
             (ACCUM SUB-TOTAL BY t-prove t-Utili[3]) @ t-Utili[3] 
             (ACCUM SUB-TOTAL BY t-prove t-Utili[4]) @ t-Utili[4] 
             (ACCUM SUB-TOTAL BY t-prove t-Utili[5]) @ t-Utili[5] 
             (ACCUM SUB-TOTAL BY t-prove t-Utili[6]) @ t-Utili[6] 
             (ACCUM SUB-TOTAL BY t-prove t-Utili[7]) @ t-Utili[7] 
             (ACCUM SUB-TOTAL BY t-prove t-Utili[10]) @ t-Utili[10] 
             WITH FRAME F-REPORTE.
                                
         END.  

      END.
  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-Utili[1]
            t-Utili[2]
            t-Utili[3]
            t-Utili[4]
            t-Utili[5]
            t-Utili[6]
            t-Utili[7]
            t-Utili[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-Utili[1]) @ t-Utili[1]
            (ACCUM TOTAL BY t-codcia t-Utili[2]) @ t-Utili[2]
            (ACCUM TOTAL BY t-codcia t-Utili[3]) @ t-Utili[3]
            (ACCUM TOTAL BY t-codcia t-Utili[4]) @ t-Utili[4]
            (ACCUM TOTAL BY t-codcia t-Utili[5]) @ t-Utili[5]
            (ACCUM TOTAL BY t-codcia t-Utili[6]) @ t-Utili[6]
            (ACCUM TOTAL BY t-codcia t-Utili[7]) @ t-Utili[7]
            (ACCUM TOTAL BY t-codcia t-Utili[10]) @ t-Utili[10]
            WITH FRAME F-REPORTE.
            
      END.
     

  END.
   
  

  HIDE FRAME F-PROCESO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato4 W-Win 
PROCEDURE Formato4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
CASE C-Tipo-2:
    WHEN "Cantidad"  THEN RUN Formato4A.
    WHEN "Venta"     THEN RUN Formato4B.
    WHEN "Costo"     THEN RUN Formato4C.
    WHEN "Margen"    THEN RUN Formato4D.
    WHEN "Utilidad"  THEN RUN Formato4E.
END CASE.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato4A W-Win 
PROCEDURE Formato4A :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato4B W-Win 
PROCEDURE Formato4B :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-subfam    AT 1
         t-DesMat    FORMAT "X(40)"
         t-venta[1]  FORMAT "->>>,>>>,>>9"
         t-venta[2]  FORMAT "->>>,>>>,>>9"
         t-venta[3]  FORMAT "->>>,>>>,>>9"
         t-venta[4]  FORMAT "->>>,>>>,>>9"
         t-venta[5]  FORMAT "->>>,>>>,>>9"
         t-venta[6]  FORMAT "->>>,>>>,>>9"
         t-venta[7]  FORMAT "->>>,>>>,>>9"
         t-venta[10]  FORMAT "->>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA  FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
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
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP
         "LOS IMPORTES INCLUYEN I.G.V "   At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  50 
        F-DIVISION-2 AT  63 
        F-DIVISION-3 AT  76 
        F-DIVISION-4 AT  89 
        F-DIVISION-5 AT  102
        F-DIVISION-6 AT  115
        "O T R O S"  AT  128
        "T O T A L"  AT  142 SKIP
        " SUB-FAMILIA   D E S C R I P C I O N              VENTA        VENTA        VENTA        VENTA       VENTA        VENTA       VENTA        VENTA    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo /* WHERE t-canti[10] > 0 */
                     BREAK BY t-codcia
                           BY t-codfam 
                           BY t-subfam :

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = t-CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "FAMILIA : "  FORMAT "X(15)" AT 1 
                                 t-codfam      FORMAT "X(05)" AT 17
                                 Almtfami.Desfam FORMAT "X(40)" AT 25 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.
         END.
      END.

      ACCUM  t-venta[1]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-venta[2]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-venta[3]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-venta[4]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-venta[5]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-venta[6]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-venta[7]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-venta[10]  (SUB-TOTAL BY t-codfam) .

      ACCUM  t-venta[1]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-venta[2]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-venta[3]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-venta[4]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-venta[5]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-venta[6]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-venta[7]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-venta[10]  (SUB-TOTAL BY t-subfam) .

      ACCUM  t-venta[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[10]  ( TOTAL BY t-codcia) .



      
      IF LAST-OF(t-SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = S-CODCIA 
                        AND  Almsfami.codfam = t-CodFam 
                        AND  Almsfami.subfam = t-Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             DISPLAY STREAM REPORT 
             t-subfam 
             Almsfami.subfam  @ t-desmat
             (ACCUM SUB-TOTAL BY t-subfam t-venta[1]) @ t-venta[1] 
             (ACCUM SUB-TOTAL BY t-subfam t-venta[2]) @ t-venta[2] 
             (ACCUM SUB-TOTAL BY t-subfam t-venta[3]) @ t-venta[3] 
             (ACCUM SUB-TOTAL BY t-subfam t-venta[4]) @ t-venta[4] 
             (ACCUM SUB-TOTAL BY t-subfam t-venta[5]) @ t-venta[5] 
             (ACCUM SUB-TOTAL BY t-subfam t-venta[6]) @ t-venta[6] 
             (ACCUM SUB-TOTAL BY t-subfam t-venta[7]) @ t-venta[7] 
             (ACCUM SUB-TOTAL BY t-subfam t-venta[10]) @ t-venta[10] 
             WITH FRAME F-REPORTE.

         END.  
      END.


      IF LAST-OF(t-CodFam) THEN DO:  
            UNDERLINE STREAM REPORT
            t-venta[1]
            t-venta[2]
            t-venta[3]
            t-venta[4]
            t-venta[5]
            t-venta[6]
            t-venta[7]
            t-venta[10]
            WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
            ("TOTAL   : " + T-CODFAM ) @ t-desmat
            (ACCUM SUB-TOTAL BY t-codfam t-venta[1]) @ t-venta[1] 
            (ACCUM SUB-TOTAL BY t-codfam t-venta[2]) @ t-venta[2] 
            (ACCUM SUB-TOTAL BY t-codfam t-venta[3]) @ t-venta[3] 
            (ACCUM SUB-TOTAL BY t-codfam t-venta[4]) @ t-venta[4] 
            (ACCUM SUB-TOTAL BY t-codfam t-venta[5]) @ t-venta[5] 
            (ACCUM SUB-TOTAL BY t-codfam t-venta[6]) @ t-venta[6] 
            (ACCUM SUB-TOTAL BY t-codfam t-venta[7]) @ t-venta[7] 
            (ACCUM SUB-TOTAL BY t-codfam t-venta[10]) @ t-venta[10] 
             WITH FRAME F-REPORTE.
      END.
  
      IF LAST-OF(t-codcia) THEN DO:
            UNDERLINE STREAM REPORT
            t-venta[1]
            t-venta[2]
            t-venta[3]
            t-venta[4]
            t-venta[5]
            t-venta[6]
            t-venta[7]
            t-venta[10]
            WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-venta[1]) @ t-venta[1] 
            (ACCUM TOTAL BY t-codcia t-venta[2]) @ t-venta[2] 
            (ACCUM TOTAL BY t-codcia t-venta[3]) @ t-venta[3] 
            (ACCUM TOTAL BY t-codcia t-venta[4]) @ t-venta[4] 
            (ACCUM TOTAL BY t-codcia t-venta[5]) @ t-venta[5] 
            (ACCUM TOTAL BY t-codcia t-venta[6]) @ t-venta[6] 
            (ACCUM TOTAL BY t-codcia t-venta[7]) @ t-venta[7] 
            (ACCUM TOTAL BY t-codcia t-venta[10]) @ t-venta[10] 
             WITH FRAME F-REPORTE.
      END.
  

  END.
  HIDE FRAME F-PROCESO.
 
  END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato4C W-Win 
PROCEDURE Formato4C :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-subfam    AT 1
         t-DesMat    FORMAT "X(40)"
         t-Costo[1]  FORMAT "->>>,>>>,>>9"
         t-Costo[2]  FORMAT "->>>,>>>,>>9"
         t-Costo[3]  FORMAT "->>>,>>>,>>9"
         t-Costo[4]  FORMAT "->>>,>>>,>>9"
         t-Costo[5]  FORMAT "->>>,>>>,>>9"
         t-Costo[6]  FORMAT "->>>,>>>,>>9"
         t-Costo[7]  FORMAT "->>>,>>>,>>9"
         t-Costo[10]  FORMAT "->>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
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
         "LOS IMPORTES INCLUYEN I.G.V "   At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  50 
        F-DIVISION-2 AT  63 
        F-DIVISION-3 AT  76 
        F-DIVISION-4 AT  89 
        F-DIVISION-5 AT  102
        F-DIVISION-6 AT  115
        "O T R O S"  AT  128
        "T O T A L"  AT  142 SKIP
        " SUB-FAMILIA   D E S C R I P C I O N              Costo        Costo        Costo        Costo       Costo        Costo       Costo        Costo    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo /* WHERE t-canti[10] > 0 */
                     BREAK BY t-codcia
                           BY t-codfam 
                           BY t-subfam :

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = t-CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT  "FAMILIA : "  FORMAT "X(15)" AT 1 
                                t-codfam      FORMAT "X(05)" AT 17
                                Almtfami.Desfam  FORMAT "X(40)" AT 25 SKIP.
             PUT STREAM REPORT  '------------------------------------------' FORMAT "X(50)" SKIP.
         END.
      END.

      ACCUM  t-Costo[1]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[2]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[3]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[4]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[5]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[6]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[7]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[10]  (SUB-TOTAL BY t-codfam) .

      ACCUM  t-Costo[1]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[2]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[3]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[4]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[5]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[6]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[7]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[10]  (SUB-TOTAL BY t-subfam) .

      ACCUM  t-Costo[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[10]  ( TOTAL BY t-codcia) .



      
      IF LAST-OF(t-SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = S-CODCIA 
                        AND  Almsfami.codfam = t-CodFam 
                        AND  Almsfami.subfam = t-Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             DISPLAY STREAM REPORT 
             t-subfam 
             Almsfami.subfam  @ t-desmat
             (ACCUM SUB-TOTAL BY t-subfam t-Costo[1]) @ t-Costo[1] 
             (ACCUM SUB-TOTAL BY t-subfam t-Costo[2]) @ t-Costo[2] 
             (ACCUM SUB-TOTAL BY t-subfam t-Costo[3]) @ t-Costo[3] 
             (ACCUM SUB-TOTAL BY t-subfam t-Costo[4]) @ t-Costo[4] 
             (ACCUM SUB-TOTAL BY t-subfam t-Costo[5]) @ t-Costo[5] 
             (ACCUM SUB-TOTAL BY t-subfam t-Costo[6]) @ t-Costo[6] 
             (ACCUM SUB-TOTAL BY t-subfam t-Costo[7]) @ t-Costo[7] 
             (ACCUM SUB-TOTAL BY t-subfam t-Costo[10]) @ t-Costo[10] 
             WITH FRAME F-REPORTE.

         END.  
      END.


      IF LAST-OF(t-CodFam) THEN DO:  
            UNDERLINE STREAM REPORT
            t-Costo[1]
            t-Costo[2]
            t-Costo[3]
            t-Costo[4]
            t-Costo[5]
            t-Costo[6]
            t-Costo[7]
            t-Costo[10]
            WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
            ("TOTAL   : " + T-CODFAM ) @ t-desmat
            (ACCUM SUB-TOTAL BY t-codfam t-Costo[1]) @ t-Costo[1] 
            (ACCUM SUB-TOTAL BY t-codfam t-Costo[2]) @ t-Costo[2] 
            (ACCUM SUB-TOTAL BY t-codfam t-Costo[3]) @ t-Costo[3] 
            (ACCUM SUB-TOTAL BY t-codfam t-Costo[4]) @ t-Costo[4] 
            (ACCUM SUB-TOTAL BY t-codfam t-Costo[5]) @ t-Costo[5] 
            (ACCUM SUB-TOTAL BY t-codfam t-Costo[6]) @ t-Costo[6] 
            (ACCUM SUB-TOTAL BY t-codfam t-Costo[7]) @ t-Costo[7] 
            (ACCUM SUB-TOTAL BY t-codfam t-Costo[10]) @ t-Costo[10] 
             WITH FRAME F-REPORTE.
      END.
  
      IF LAST-OF(t-codcia) THEN DO:
            UNDERLINE STREAM REPORT
            t-Costo[1]
            t-Costo[2]
            t-Costo[3]
            t-Costo[4]
            t-Costo[5]
            t-Costo[6]
            t-Costo[7]
            t-Costo[10]
            WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-Costo[1]) @ t-Costo[1] 
            (ACCUM TOTAL BY t-codcia t-Costo[2]) @ t-Costo[2] 
            (ACCUM TOTAL BY t-codcia t-Costo[3]) @ t-Costo[3] 
            (ACCUM TOTAL BY t-codcia t-Costo[4]) @ t-Costo[4] 
            (ACCUM TOTAL BY t-codcia t-Costo[5]) @ t-Costo[5] 
            (ACCUM TOTAL BY t-codcia t-Costo[6]) @ t-Costo[6] 
            (ACCUM TOTAL BY t-codcia t-Costo[7]) @ t-Costo[7] 
            (ACCUM TOTAL BY t-codcia t-Costo[10]) @ t-Costo[10] 
             WITH FRAME F-REPORTE.
      END.
  

  END.
  HIDE FRAME F-PROCESO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato4D W-Win 
PROCEDURE Formato4D :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-subfam    AT 1
         t-DesMat    FORMAT "X(40)"
         t-Marge[1]  FORMAT "->>>,>>>,>>9"
         t-Marge[2]  FORMAT "->>>,>>>,>>9"
         t-Marge[3]  FORMAT "->>>,>>>,>>9"
         t-Marge[4]  FORMAT "->>>,>>>,>>9"
         t-Marge[5]  FORMAT "->>>,>>>,>>9"
         t-Marge[6]  FORMAT "->>>,>>>,>>9"
         t-Marge[7]  FORMAT "->>>,>>>,>>9"
         t-Marge[10]  FORMAT "->>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU  AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
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

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  50 
        F-DIVISION-2 AT  63 
        F-DIVISION-3 AT  76 
        F-DIVISION-4 AT  89 
        F-DIVISION-5 AT  102
        F-DIVISION-6 AT  115
        "O T R O S"  AT  128
        "T O T A L"  AT  142 SKIP
        " SUB-FAMILIA   D E S C R I P C I O N              Marge        Marge        Marge        Marge       Marge        Marge       Marge        Marge    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo /* WHERE t-canti[10] > 0 */
                     BREAK BY t-codcia
                           BY t-codfam 
                           BY t-subfam :

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = t-CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "FAMILIA : "  FORMAT "X(15)" AT 1 
                                 t-codfam      FORMAT "X(05)" AT 17
                                 Almtfami.Desfam FORMAT "X(40)" AT 25 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.
         END.
      END.

      T-Marge[1] = (T-Venta[1] - T-Costo[1]) / T-Venta[1] .
      T-Marge[2] = (T-Venta[2] - T-Costo[2]) / T-Venta[2] .
      T-Marge[3] = (T-Venta[3] - T-Costo[3]) / T-Venta[3] .
      T-Marge[4] = (T-Venta[4] - T-Costo[4]) / T-Venta[4] .
      T-Marge[5] = (T-Venta[5] - T-Costo[5]) / T-Venta[5] .
      T-Marge[6] = (T-Venta[6] - T-Costo[6]) / T-Venta[6] .
      T-Marge[7] = (T-Venta[7] - T-Costo[7]) / T-Venta[7] .
      T-Marge[10] = (T-Venta[10] - T-Costo[10]) / T-Venta[10] .

      ACCUM  t-Marge[1]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Marge[2]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Marge[3]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Marge[4]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Marge[5]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Marge[6]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Marge[7]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Marge[10]  (SUB-TOTAL BY t-codfam) .

      ACCUM  t-Marge[1]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Marge[2]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Marge[3]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Marge[4]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Marge[5]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Marge[6]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Marge[7]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Marge[10]  (SUB-TOTAL BY t-subfam) .

      ACCUM  t-Marge[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[10]  ( TOTAL BY t-codcia) .


      ACCUM  t-Venta[1]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Venta[2]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Venta[3]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Venta[4]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Venta[5]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Venta[6]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Venta[7]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Venta[10]  (SUB-TOTAL BY t-codfam) .

      ACCUM  t-Venta[1]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Venta[2]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Venta[3]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Venta[4]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Venta[5]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Venta[6]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Venta[7]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Venta[10]  (SUB-TOTAL BY t-subfam) .

      ACCUM  t-Venta[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[10]  ( TOTAL BY t-codcia) .


      ACCUM  t-Costo[1]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[2]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[3]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[4]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[5]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[6]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[7]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[10]  (SUB-TOTAL BY t-codfam) .

      ACCUM  t-Costo[1]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[2]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[3]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[4]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[5]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[6]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[7]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Costo[10]  (SUB-TOTAL BY t-subfam) .

      ACCUM  t-Costo[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[10]  ( TOTAL BY t-codcia) .



      
      IF LAST-OF(t-SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = S-CODCIA 
                        AND  Almsfami.codfam = t-CodFam 
                        AND  Almsfami.subfam = t-Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             DISPLAY STREAM REPORT 
             t-subfam 
             Almsfami.subfam  @ t-desmat
             ((ACCUM SUB-TOTAL BY t-subfam t-Venta[1]) - (ACCUM SUB-TOTAL BY t-subfam t-Costo[1])) / (ACCUM SUB-TOTAL BY t-subfam t-Venta[1]) @ t-Marge[1] 
             ((ACCUM SUB-TOTAL BY t-subfam t-Venta[2]) - (ACCUM SUB-TOTAL BY t-subfam t-Costo[2])) / (ACCUM SUB-TOTAL BY t-subfam t-Venta[2]) @ t-Marge[2] 
             ((ACCUM SUB-TOTAL BY t-subfam t-Venta[3]) - (ACCUM SUB-TOTAL BY t-subfam t-Costo[3])) / (ACCUM SUB-TOTAL BY t-subfam t-Venta[3]) @ t-Marge[3] 
             ((ACCUM SUB-TOTAL BY t-subfam t-Venta[4]) - (ACCUM SUB-TOTAL BY t-subfam t-Costo[4])) / (ACCUM SUB-TOTAL BY t-subfam t-Venta[4]) @ t-Marge[4] 
             ((ACCUM SUB-TOTAL BY t-subfam t-Venta[5]) - (ACCUM SUB-TOTAL BY t-subfam t-Costo[5])) / (ACCUM SUB-TOTAL BY t-subfam t-Venta[5]) @ t-Marge[5] 
             ((ACCUM SUB-TOTAL BY t-subfam t-Venta[6]) - (ACCUM SUB-TOTAL BY t-subfam t-Costo[6])) / (ACCUM SUB-TOTAL BY t-subfam t-Venta[6]) @ t-Marge[6] 
             ((ACCUM SUB-TOTAL BY t-subfam t-Venta[7]) - (ACCUM SUB-TOTAL BY t-subfam t-Costo[7])) / (ACCUM SUB-TOTAL BY t-subfam t-Venta[7]) @ t-Marge[7] 
             ((ACCUM SUB-TOTAL BY t-subfam t-Venta[10]) - (ACCUM SUB-TOTAL BY t-subfam t-Costo[10])) / (ACCUM SUB-TOTAL BY t-subfam t-Venta[10]) @ t-Marge[10] 
             WITH FRAME F-REPORTE.

         END.  
      END.


      IF LAST-OF(t-CodFam) THEN DO:  
            UNDERLINE STREAM REPORT
            t-Marge[1]
            t-Marge[2]
            t-Marge[3]
            t-Marge[4]
            t-Marge[5]
            t-Marge[6]
            t-Marge[7]
            t-Marge[10]
            WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
            ("TOTAL   : " + T-CODFAM ) @ t-desmat
            ((ACCUM SUB-TOTAL BY t-codfam t-Venta[1]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[1])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[1]) @ t-Marge[1] 
            ((ACCUM SUB-TOTAL BY t-codfam t-Venta[2]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[2])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[2]) @ t-Marge[2] 
            ((ACCUM SUB-TOTAL BY t-codfam t-Venta[3]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[3])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[3]) @ t-Marge[3] 
            ((ACCUM SUB-TOTAL BY t-codfam t-Venta[4]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[4])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[4]) @ t-Marge[4] 
            ((ACCUM SUB-TOTAL BY t-codfam t-Venta[5]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[5])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[5]) @ t-Marge[5] 
            ((ACCUM SUB-TOTAL BY t-codfam t-Venta[6]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[6])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[6]) @ t-Marge[6] 
            ((ACCUM SUB-TOTAL BY t-codfam t-Venta[7]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[7])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[7]) @ t-Marge[7] 
            ((ACCUM SUB-TOTAL BY t-codfam t-Venta[10]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[10])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[10]) @ t-Marge[10] 
             WITH FRAME F-REPORTE.
      END.
  
      IF LAST-OF(t-codcia) THEN DO:
            UNDERLINE STREAM REPORT
            t-Marge[1]
            t-Marge[2]
            t-Marge[3]
            t-Marge[4]
            t-Marge[5]
            t-Marge[6]
            t-Marge[7]
            t-Marge[10]
            WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            ((ACCUM TOTAL BY t-codcia t-Venta[1]) - (ACCUM TOTAL BY t-codcia t-Costo[1])) / (ACCUM TOTAL BY t-codcia t-Venta[1]) @ t-Marge[1] 
            ((ACCUM TOTAL BY t-codcia t-Venta[2]) - (ACCUM TOTAL BY t-codcia t-Costo[2])) / (ACCUM TOTAL BY t-codcia t-Venta[2]) @ t-Marge[2] 
            ((ACCUM TOTAL BY t-codcia t-Venta[3]) - (ACCUM TOTAL BY t-codcia t-Costo[3])) / (ACCUM TOTAL BY t-codcia t-Venta[3]) @ t-Marge[3] 
            ((ACCUM TOTAL BY t-codcia t-Venta[4]) - (ACCUM TOTAL BY t-codcia t-Costo[4])) / (ACCUM TOTAL BY t-codcia t-Venta[4]) @ t-Marge[4] 
            ((ACCUM TOTAL BY t-codcia t-Venta[5]) - (ACCUM TOTAL BY t-codcia t-Costo[5])) / (ACCUM TOTAL BY t-codcia t-Venta[5]) @ t-Marge[5] 
            ((ACCUM TOTAL BY t-codcia t-Venta[6]) - (ACCUM TOTAL BY t-codcia t-Costo[6])) / (ACCUM TOTAL BY t-codcia t-Venta[6]) @ t-Marge[6] 
            ((ACCUM TOTAL BY t-codcia t-Venta[7]) - (ACCUM TOTAL BY t-codcia t-Costo[7])) / (ACCUM TOTAL BY t-codcia t-Venta[7]) @ t-Marge[7] 
            ((ACCUM TOTAL BY t-codcia t-Venta[10]) - (ACCUM TOTAL BY t-codcia t-Costo[10])) / (ACCUM TOTAL BY t-codcia t-Venta[10]) @ t-Marge[10] 
             WITH FRAME F-REPORTE.
      END.
  

  END.
  HIDE FRAME F-PROCESO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato4E W-Win 
PROCEDURE Formato4E :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-subfam    AT 1
         t-DesMat    FORMAT "X(40)"
         t-Utili[1]  FORMAT "->>>,>>>,>>9"
         t-Utili[2]  FORMAT "->>>,>>>,>>9"
         t-Utili[3]  FORMAT "->>>,>>>,>>9"
         t-Utili[4]  FORMAT "->>>,>>>,>>9"
         t-Utili[5]  FORMAT "->>>,>>>,>>9"
         t-Utili[6]  FORMAT "->>>,>>>,>>9"
         t-Utili[7]  FORMAT "->>>,>>>,>>9"
         t-Utili[10]  FORMAT "->>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA  FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU  AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
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
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  50 
        F-DIVISION-2 AT  63 
        F-DIVISION-3 AT  76 
        F-DIVISION-4 AT  89 
        F-DIVISION-5 AT  102
        F-DIVISION-6 AT  115
        "O T R O S"  AT  128
        "T O T A L"  AT  142 SKIP
        " SUB-FAMILIA   D E S C R I P C I O N              Utili        Utili        Utili        Utili       Utili        Utili       Utili        Utili    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo /* WHERE t-canti[10] > 0 */
                     BREAK BY t-codcia
                           BY t-codfam 
                           BY t-subfam :

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = t-CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "FAMILIA : "  FORMAT "X(15)" AT 1 
                                 t-codfam      FORMAT "X(05)" AT 17
                                 Almtfami.Desfam  FORMAT "X(40)" AT 25 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.
         END.
      END.

      ACCUM  t-Utili[1]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Utili[2]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Utili[3]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Utili[4]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Utili[5]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Utili[6]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Utili[7]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Utili[10]  (SUB-TOTAL BY t-codfam) .

      ACCUM  t-Utili[1]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Utili[2]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Utili[3]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Utili[4]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Utili[5]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Utili[6]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Utili[7]  (SUB-TOTAL BY t-subfam) .
      ACCUM  t-Utili[10]  (SUB-TOTAL BY t-subfam) .

      ACCUM  t-Utili[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[10]  ( TOTAL BY t-codcia) .



      
      IF LAST-OF(t-SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = S-CODCIA 
                        AND  Almsfami.codfam = t-CodFam 
                        AND  Almsfami.subfam = t-Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             DISPLAY STREAM REPORT 
             t-subfam 
             Almsfami.subfam  @ t-desmat
             (ACCUM SUB-TOTAL BY t-subfam t-Utili[1]) @ t-Utili[1] 
             (ACCUM SUB-TOTAL BY t-subfam t-Utili[2]) @ t-Utili[2] 
             (ACCUM SUB-TOTAL BY t-subfam t-Utili[3]) @ t-Utili[3] 
             (ACCUM SUB-TOTAL BY t-subfam t-Utili[4]) @ t-Utili[4] 
             (ACCUM SUB-TOTAL BY t-subfam t-Utili[5]) @ t-Utili[5] 
             (ACCUM SUB-TOTAL BY t-subfam t-Utili[6]) @ t-Utili[6] 
             (ACCUM SUB-TOTAL BY t-subfam t-Utili[7]) @ t-Utili[7] 
             (ACCUM SUB-TOTAL BY t-subfam t-Utili[10]) @ t-Utili[10] 
             WITH FRAME F-REPORTE.

         END.  
      END.


      IF LAST-OF(t-CodFam) THEN DO:  
            UNDERLINE STREAM REPORT
            t-Utili[1]
            t-Utili[2]
            t-Utili[3]
            t-Utili[4]
            t-Utili[5]
            t-Utili[6]
            t-Utili[7]
            t-Utili[10]
            WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
            ("TOTAL   : " + T-CODFAM ) @ t-desmat
            (ACCUM SUB-TOTAL BY t-codfam t-Utili[1]) @ t-Utili[1] 
            (ACCUM SUB-TOTAL BY t-codfam t-Utili[2]) @ t-Utili[2] 
            (ACCUM SUB-TOTAL BY t-codfam t-Utili[3]) @ t-Utili[3] 
            (ACCUM SUB-TOTAL BY t-codfam t-Utili[4]) @ t-Utili[4] 
            (ACCUM SUB-TOTAL BY t-codfam t-Utili[5]) @ t-Utili[5] 
            (ACCUM SUB-TOTAL BY t-codfam t-Utili[6]) @ t-Utili[6] 
            (ACCUM SUB-TOTAL BY t-codfam t-Utili[7]) @ t-Utili[7] 
            (ACCUM SUB-TOTAL BY t-codfam t-Utili[10]) @ t-Utili[10] 
             WITH FRAME F-REPORTE.
      END.
  
      IF LAST-OF(t-codcia) THEN DO:
            UNDERLINE STREAM REPORT
            t-Utili[1]
            t-Utili[2]
            t-Utili[3]
            t-Utili[4]
            t-Utili[5]
            t-Utili[6]
            t-Utili[7]
            t-Utili[10]
            WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-Utili[1]) @ t-Utili[1] 
            (ACCUM TOTAL BY t-codcia t-Utili[2]) @ t-Utili[2] 
            (ACCUM TOTAL BY t-codcia t-Utili[3]) @ t-Utili[3] 
            (ACCUM TOTAL BY t-codcia t-Utili[4]) @ t-Utili[4] 
            (ACCUM TOTAL BY t-codcia t-Utili[5]) @ t-Utili[5] 
            (ACCUM TOTAL BY t-codcia t-Utili[6]) @ t-Utili[6] 
            (ACCUM TOTAL BY t-codcia t-Utili[7]) @ t-Utili[7] 
            (ACCUM TOTAL BY t-codcia t-Utili[10]) @ t-Utili[10] 
             WITH FRAME F-REPORTE.
      END.
  

  END.
  HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato5 W-Win 
PROCEDURE Formato5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
CASE C-Tipo-2:
    WHEN "Cantidad"  THEN RUN Formato5A.
    WHEN "Venta"     THEN RUN Formato5B.
    WHEN "Costo"     THEN RUN Formato5C.
    WHEN "Margen"    THEN RUN Formato5D.
    WHEN "Utilidad"  THEN RUN Formato5E.
END CASE.  


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato5A W-Win 
PROCEDURE Formato5A :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato5B W-Win 
PROCEDURE Formato5B :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-codfam    AT 1
         t-DesMat    FORMAT "X(40)"
         t-venta[1]  FORMAT "->>>,>>>,>>9"
         t-venta[2]  FORMAT "->>>,>>>,>>9"
         t-venta[3]  FORMAT "->>>,>>>,>>9"
         t-venta[4]  FORMAT "->>>,>>>,>>9"
         t-venta[5]  FORMAT "->>>,>>>,>>9"
         t-venta[6]  FORMAT "->>>,>>>,>>9"
         t-venta[7]  FORMAT "->>>,>>>,>>9"
         t-venta[10]  FORMAT "->>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU  AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
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
         "LOS IMPORTES INCLUYEN I.G.V "   At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  50 
        F-DIVISION-2 AT  63 
        F-DIVISION-3 AT  76 
        F-DIVISION-4 AT  89 
        F-DIVISION-5 AT  102
        F-DIVISION-6 AT  115
        "O T R O S"  AT  128
        "T O T A L"  AT  142 SKIP
        " FAMILIA     D E S C R I P C I O N                VENTA        VENTA        VENTA        VENTA       VENTA        VENTA       VENTA        VENTA    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo /* WHERE t-venta[10] <> 0 */
                     BREAK BY t-codcia
                           BY t-codfam  :

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.



      ACCUM  t-venta[1]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-venta[2]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-venta[3]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-venta[4]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-venta[5]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-venta[6]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-venta[7]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-venta[10]  (SUB-TOTAL BY t-codfam) .


      ACCUM  t-venta[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[10]  ( TOTAL BY t-codcia) .





      IF LAST-OF(t-CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = t-CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             DISPLAY STREAM REPORT 
             t-codfam 
             Almtfami.Desfam  @ t-desmat
             (ACCUM SUB-TOTAL BY t-codfam t-venta[1]) @ t-venta[1] 
             (ACCUM SUB-TOTAL BY t-codfam t-venta[2]) @ t-venta[2] 
             (ACCUM SUB-TOTAL BY t-codfam t-venta[3]) @ t-venta[3] 
             (ACCUM SUB-TOTAL BY t-codfam t-venta[4]) @ t-venta[4] 
             (ACCUM SUB-TOTAL BY t-codfam t-venta[5]) @ t-venta[5] 
             (ACCUM SUB-TOTAL BY t-codfam t-venta[6]) @ t-venta[6] 
             (ACCUM SUB-TOTAL BY t-codfam t-venta[7]) @ t-venta[7] 
             (ACCUM SUB-TOTAL BY t-codfam t-venta[10]) @ t-venta[10] 
             WITH FRAME F-REPORTE.


         END.
      END.
      
  
      IF LAST-OF(t-codcia) THEN DO:
            UNDERLINE STREAM REPORT
            t-venta[1]
            t-venta[2]
            t-venta[3]
            t-venta[4]
            t-venta[5]
            t-venta[6]
            t-venta[7]
            t-venta[10]
            WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-venta[1]) @ t-venta[1] 
            (ACCUM TOTAL BY t-codcia t-venta[2]) @ t-venta[2] 
            (ACCUM TOTAL BY t-codcia t-venta[3]) @ t-venta[3] 
            (ACCUM TOTAL BY t-codcia t-venta[4]) @ t-venta[4] 
            (ACCUM TOTAL BY t-codcia t-venta[5]) @ t-venta[5] 
            (ACCUM TOTAL BY t-codcia t-venta[6]) @ t-venta[6] 
            (ACCUM TOTAL BY t-codcia t-venta[7]) @ t-venta[7] 
            (ACCUM TOTAL BY t-codcia t-venta[10]) @ t-venta[10] 
             WITH FRAME F-REPORTE.

      END.
  

  END.
  HIDE FRAME F-PROCESO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato5C W-Win 
PROCEDURE Formato5C :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-codfam    AT 1
         t-DesMat    FORMAT "X(40)"
         t-Costo[1]  FORMAT "->>>,>>>,>>9"
         t-Costo[2]  FORMAT "->>>,>>>,>>9"
         t-Costo[3]  FORMAT "->>>,>>>,>>9"
         t-Costo[4]  FORMAT "->>>,>>>,>>9"
         t-Costo[5]  FORMAT "->>>,>>>,>>9"
         t-Costo[6]  FORMAT "->>>,>>>,>>9"
         t-Costo[7]  FORMAT "->>>,>>>,>>9"
         t-Costo[10]  FORMAT "->>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU  AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
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
         "LOS IMPORTES INCLUYEN I.G.V "   At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  50 
        F-DIVISION-2 AT  63 
        F-DIVISION-3 AT  76 
        F-DIVISION-4 AT  89 
        F-DIVISION-5 AT  102
        F-DIVISION-6 AT  115
        "O T R O S"  AT  128
        "T O T A L"  AT  142 SKIP
        " FAMILIA     D E S C R I P C I O N                Costo        Costo        Costo        Costo       Costo        Costo       Costo        Costo    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo /* WHERE t-Costo[10] <> 0 */
                     BREAK BY t-codcia
                           BY t-codfam  :

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.



      ACCUM  t-Costo[1]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[2]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[3]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[4]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[5]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[6]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[7]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[10]  (SUB-TOTAL BY t-codfam) .


      ACCUM  t-Costo[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[10]  ( TOTAL BY t-codcia) .





      IF LAST-OF(t-CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = t-CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             DISPLAY STREAM REPORT 
             t-codfam 
             Almtfami.Desfam  @ t-desmat
             (ACCUM SUB-TOTAL BY t-codfam t-Costo[1]) @ t-Costo[1] 
             (ACCUM SUB-TOTAL BY t-codfam t-Costo[2]) @ t-Costo[2] 
             (ACCUM SUB-TOTAL BY t-codfam t-Costo[3]) @ t-Costo[3] 
             (ACCUM SUB-TOTAL BY t-codfam t-Costo[4]) @ t-Costo[4] 
             (ACCUM SUB-TOTAL BY t-codfam t-Costo[5]) @ t-Costo[5] 
             (ACCUM SUB-TOTAL BY t-codfam t-Costo[6]) @ t-Costo[6] 
             (ACCUM SUB-TOTAL BY t-codfam t-Costo[7]) @ t-Costo[7] 
             (ACCUM SUB-TOTAL BY t-codfam t-Costo[10]) @ t-Costo[10] 
             WITH FRAME F-REPORTE.


         END.
      END.
      
  
      IF LAST-OF(t-codcia) THEN DO:
            UNDERLINE STREAM REPORT
            t-Costo[1]
            t-Costo[2]
            t-Costo[3]
            t-Costo[4]
            t-Costo[5]
            t-Costo[6]
            t-Costo[7]
            t-Costo[10]
            WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-Costo[1]) @ t-Costo[1] 
            (ACCUM TOTAL BY t-codcia t-Costo[2]) @ t-Costo[2] 
            (ACCUM TOTAL BY t-codcia t-Costo[3]) @ t-Costo[3] 
            (ACCUM TOTAL BY t-codcia t-Costo[4]) @ t-Costo[4] 
            (ACCUM TOTAL BY t-codcia t-Costo[5]) @ t-Costo[5] 
            (ACCUM TOTAL BY t-codcia t-Costo[6]) @ t-Costo[6] 
            (ACCUM TOTAL BY t-codcia t-Costo[7]) @ t-Costo[7] 
            (ACCUM TOTAL BY t-codcia t-Costo[10]) @ t-Costo[10] 
             WITH FRAME F-REPORTE.

      END.
  

  END.
  HIDE FRAME F-PROCESO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato5D W-Win 
PROCEDURE Formato5D :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-codfam    AT 1
         t-DesMat    FORMAT "X(40)"
         t-Marge[1]  FORMAT "->>>,>>>,>>9"
         t-Marge[2]  FORMAT "->>>,>>>,>>9"
         t-Marge[3]  FORMAT "->>>,>>>,>>9"
         t-Marge[4]  FORMAT "->>>,>>>,>>9"
         t-Marge[5]  FORMAT "->>>,>>>,>>9"
         t-Marge[6]  FORMAT "->>>,>>>,>>9"
         t-Marge[7]  FORMAT "->>>,>>>,>>9"
         t-Marge[10]  FORMAT "->>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU  AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")"  AT 100 FORMAT "X(25)" SKIP(1)
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
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  50 
        F-DIVISION-2 AT  63 
        F-DIVISION-3 AT  76 
        F-DIVISION-4 AT  89 
        F-DIVISION-5 AT  102
        F-DIVISION-6 AT  115
        "O T R O S"  AT  128
        "T O T A L"  AT  142 SKIP
        " FAMILIA     D E S C R I P C I O N                Marge        Marge        Marge        Marge       Marge        Marge       Marge        Marge    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo /* WHERE t-Marge[10] <> 0 */
                     BREAK BY t-codcia
                           BY t-codfam  :

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      T-Marge[1] = (T-Venta[1] - T-Costo[1]) / T-Venta[1] .
      T-Marge[2] = (T-Venta[2] - T-Costo[2]) / T-Venta[2] .
      T-Marge[3] = (T-Venta[3] - T-Costo[3]) / T-Venta[3] .
      T-Marge[4] = (T-Venta[4] - T-Costo[4]) / T-Venta[4] .
      T-Marge[5] = (T-Venta[5] - T-Costo[5]) / T-Venta[5] .
      T-Marge[6] = (T-Venta[6] - T-Costo[6]) / T-Venta[6] .
      T-Marge[7] = (T-Venta[7] - T-Costo[7]) / T-Venta[7] .
      T-Marge[10] = (T-Venta[10] - T-Costo[10]) / T-Venta[10] .



      ACCUM  t-Marge[1]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Marge[2]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Marge[3]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Marge[4]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Marge[5]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Marge[6]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Marge[7]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Marge[10]  (SUB-TOTAL BY t-codfam) .


      ACCUM  t-Marge[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[10]  ( TOTAL BY t-codcia) .

      ACCUM  t-Venta[1]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Venta[2]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Venta[3]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Venta[4]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Venta[5]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Venta[6]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Venta[7]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Venta[10]  (SUB-TOTAL BY t-codfam) .


      ACCUM  t-Venta[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[10]  ( TOTAL BY t-codcia) .

      ACCUM  t-Costo[1]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[2]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[3]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[4]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[5]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[6]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[7]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Costo[10]  (SUB-TOTAL BY t-codfam) .


      ACCUM  t-Costo[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[10]  ( TOTAL BY t-codcia) .




      IF LAST-OF(t-CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = t-CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             DISPLAY STREAM REPORT 
             t-codfam 
             Almtfami.Desfam  @ t-desmat
             ((ACCUM SUB-TOTAL BY t-codfam t-Venta[1]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[1])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[1]) @ t-Marge[1] 
             ((ACCUM SUB-TOTAL BY t-codfam t-Venta[2]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[2])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[2]) @ t-Marge[2] 
             ((ACCUM SUB-TOTAL BY t-codfam t-Venta[3]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[3])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[3]) @ t-Marge[3] 
             ((ACCUM SUB-TOTAL BY t-codfam t-Venta[4]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[4])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[4]) @ t-Marge[4] 
             ((ACCUM SUB-TOTAL BY t-codfam t-Venta[5]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[5])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[5]) @ t-Marge[5] 
             ((ACCUM SUB-TOTAL BY t-codfam t-Venta[6]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[6])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[6]) @ t-Marge[6] 
             ((ACCUM SUB-TOTAL BY t-codfam t-Venta[7]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[7])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[7]) @ t-Marge[7] 
             ((ACCUM SUB-TOTAL BY t-codfam t-Venta[10]) - (ACCUM SUB-TOTAL BY t-codfam t-Costo[10])) / (ACCUM SUB-TOTAL BY t-codfam t-Venta[10]) @ t-Marge[10] 
             WITH FRAME F-REPORTE.


         END.
      END.
      
  
      IF LAST-OF(t-codcia) THEN DO:
            UNDERLINE STREAM REPORT
            t-Marge[1]
            t-Marge[2]
            t-Marge[3]
            t-Marge[4]
            t-Marge[5]
            t-Marge[6]
            t-Marge[7]
            t-Marge[10]
            WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            ((ACCUM TOTAL BY t-codcia t-Venta[1]) - (ACCUM TOTAL BY t-codcia t-Costo[1])) / (ACCUM TOTAL BY t-codcia t-Venta[1]) @ t-Marge[1] 
            ((ACCUM TOTAL BY t-codcia t-Venta[2]) - (ACCUM TOTAL BY t-codcia t-Costo[2])) / (ACCUM TOTAL BY t-codcia t-Venta[2]) @ t-Marge[2] 
            ((ACCUM TOTAL BY t-codcia t-Venta[3]) - (ACCUM TOTAL BY t-codcia t-Costo[3])) / (ACCUM TOTAL BY t-codcia t-Venta[3]) @ t-Marge[3] 
            ((ACCUM TOTAL BY t-codcia t-Venta[4]) - (ACCUM TOTAL BY t-codcia t-Costo[4])) / (ACCUM TOTAL BY t-codcia t-Venta[4]) @ t-Marge[4] 
            ((ACCUM TOTAL BY t-codcia t-Venta[5]) - (ACCUM TOTAL BY t-codcia t-Costo[5])) / (ACCUM TOTAL BY t-codcia t-Venta[5]) @ t-Marge[5] 
            ((ACCUM TOTAL BY t-codcia t-Venta[6]) - (ACCUM TOTAL BY t-codcia t-Costo[6])) / (ACCUM TOTAL BY t-codcia t-Venta[6]) @ t-Marge[6] 
            ((ACCUM TOTAL BY t-codcia t-Venta[7]) - (ACCUM TOTAL BY t-codcia t-Costo[7])) / (ACCUM TOTAL BY t-codcia t-Venta[7]) @ t-Marge[7] 
            ((ACCUM TOTAL BY t-codcia t-Venta[10]) - (ACCUM TOTAL BY t-codcia t-Costo[10])) / (ACCUM TOTAL BY t-codcia t-Venta[10]) @ t-Marge[10] 
             WITH FRAME F-REPORTE.

      END.
  

  END.
  HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato5E W-Win 
PROCEDURE Formato5E :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-codfam    AT 1
         t-DesMat    FORMAT "X(40)"
         t-Utili[1]  FORMAT "->>>,>>>,>>9"
         t-Utili[2]  FORMAT "->>>,>>>,>>9"
         t-Utili[3]  FORMAT "->>>,>>>,>>9"
         t-Utili[4]  FORMAT "->>>,>>>,>>9"
         t-Utili[5]  FORMAT "->>>,>>>,>>9"
         t-Utili[6]  FORMAT "->>>,>>>,>>9"
         t-Utili[7]  FORMAT "->>>,>>>,>>9"
         t-Utili[10]  FORMAT "->>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
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

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  50 
        F-DIVISION-2 AT  63 
        F-DIVISION-3 AT  76 
        F-DIVISION-4 AT  89 
        F-DIVISION-5 AT  102
        F-DIVISION-6 AT  115
        "O T R O S"  AT  128
        "T O T A L"  AT  142 SKIP
        " FAMILIA     D E S C R I P C I O N                Utili        Utili        Utili        Utili       Utili        Utili       Utili        Utili    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo /* WHERE t-Utili[10] <> 0 */
                     BREAK BY t-codcia
                           BY t-codfam  :

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.



      ACCUM  t-Utili[1]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Utili[2]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Utili[3]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Utili[4]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Utili[5]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Utili[6]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Utili[7]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-Utili[10]  (SUB-TOTAL BY t-codfam) .


      ACCUM  t-Utili[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[10]  ( TOTAL BY t-codcia) .





      IF LAST-OF(t-CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = t-CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             DISPLAY STREAM REPORT 
             t-codfam 
             Almtfami.Desfam  @ t-desmat
             (ACCUM SUB-TOTAL BY t-codfam t-Utili[1]) @ t-Utili[1] 
             (ACCUM SUB-TOTAL BY t-codfam t-Utili[2]) @ t-Utili[2] 
             (ACCUM SUB-TOTAL BY t-codfam t-Utili[3]) @ t-Utili[3] 
             (ACCUM SUB-TOTAL BY t-codfam t-Utili[4]) @ t-Utili[4] 
             (ACCUM SUB-TOTAL BY t-codfam t-Utili[5]) @ t-Utili[5] 
             (ACCUM SUB-TOTAL BY t-codfam t-Utili[6]) @ t-Utili[6] 
             (ACCUM SUB-TOTAL BY t-codfam t-Utili[7]) @ t-Utili[7] 
             (ACCUM SUB-TOTAL BY t-codfam t-Utili[10]) @ t-Utili[10] 
             WITH FRAME F-REPORTE.


         END.
      END.
      
  
      IF LAST-OF(t-codcia) THEN DO:
            UNDERLINE STREAM REPORT
            t-Utili[1]
            t-Utili[2]
            t-Utili[3]
            t-Utili[4]
            t-Utili[5]
            t-Utili[6]
            t-Utili[7]
            t-Utili[10]
            WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-Utili[1]) @ t-Utili[1] 
            (ACCUM TOTAL BY t-codcia t-Utili[2]) @ t-Utili[2] 
            (ACCUM TOTAL BY t-codcia t-Utili[3]) @ t-Utili[3] 
            (ACCUM TOTAL BY t-codcia t-Utili[4]) @ t-Utili[4] 
            (ACCUM TOTAL BY t-codcia t-Utili[5]) @ t-Utili[5] 
            (ACCUM TOTAL BY t-codcia t-Utili[6]) @ t-Utili[6] 
            (ACCUM TOTAL BY t-codcia t-Utili[7]) @ t-Utili[7] 
            (ACCUM TOTAL BY t-codcia t-Utili[10]) @ t-Utili[10] 
             WITH FRAME F-REPORTE.

      END.
  

  END.
  HIDE FRAME F-PROCESO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato6 W-Win 
PROCEDURE Formato6 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
CASE C-Tipo-2:
    WHEN "Cantidad"  THEN RUN Formato6A.
    WHEN "Venta"     THEN RUN Formato6B.
    WHEN "Costo"     THEN RUN Formato6C.
    WHEN "Margen"    THEN RUN Formato6D.
    WHEN "Utilidad"  THEN RUN Formato6E.
END CASE.  

  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato6A W-Win 
PROCEDURE Formato6A :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-codmat    AT 1
         t-DesMat    FORMAT "X(40)"
         t-DesMar    FORMAT "X(6)" 
         t-UndBas    FORMAT "X(4)"
         t-canti[1]  FORMAT "->>>>>>>9"
         t-canti[2]  FORMAT "->>>>>>>9"
         t-canti[3]  FORMAT "->>>>>>>9"
         t-canti[4]  FORMAT "->>>>>>>9"
         t-canti[5]  FORMAT "->>>>>>>9"
         t-canti[6]  FORMAT "->>>>>>>9"
         t-canti[7]  FORMAT "->>>>>>>9"
         t-canti[10] FORMAT "->>>>>>>9.99"
         t-clase     FORMAT "X(2)" 
         

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
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
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP

        "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  63 
        F-DIVISION-2 AT  75 
        F-DIVISION-3 AT  85 
        F-DIVISION-4 AT  95 
        F-DIVISION-5 AT  105
        F-DIVISION-6 AT  115
        "O T R O S"  AT  125
        "T O T A L"  AT  140 SKIP
        " CODIGO  D E S C R I P C I O N                MARCA   U.M     CANTIDAD   CANTIDAD  CANTIDAD  CANTIDAD   CANTIDAD  CANTIDAD   CANTIDAD  CANTIDAD           CLASE " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo /*HERE t-canti[10] > 0 */
                     BREAK BY t-codcia
                           BY t-canti[10] DESCENDING :

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.
           
      
      DISPLAY STREAM REPORT 
                t-codmat
                t-DesMat
                t-DesMar
                t-UndBas
                t-canti[1] WHEN  t-canti[1] <> 0 FORMAT "->>>>>>>9"
                t-canti[2] WHEN  t-canti[2] <> 0 FORMAT "->>>>>>>9"
                t-canti[3] WHEN  t-canti[3] <> 0 FORMAT "->>>>>>>9"
                t-canti[4] WHEN  t-canti[4] <> 0 FORMAT "->>>>>>>9"
                t-canti[5] WHEN  t-canti[5] <> 0 FORMAT "->>>>>>>9"
                t-canti[6] WHEN  t-canti[6] <> 0 FORMAT "->>>>>>>9"
                t-canti[7] WHEN  t-canti[7] <> 0 FORMAT "->>>>>>>9"
                t-canti[10]  FORMAT "->>>>>>>9.99"
                t-clase     
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

 
     

  END.
   
  

  HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato6B W-Win 
PROCEDURE Formato6B :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-codmat    AT 1
         t-DesMat    FORMAT "X(40)"
         t-DesMar    FORMAT "X(6)" 
         t-UndBas    FORMAT "X(4)"
         t-venta[1]  FORMAT "->>>>>>>9"
         t-venta[2]  FORMAT "->>>>>>>9"
         t-venta[3]  FORMAT "->>>>>>>9"
         t-venta[4]  FORMAT "->>>>>>>9"
         t-venta[5]  FORMAT "->>>>>>>9"
         t-venta[6]  FORMAT "->>>>>>>9"
         t-venta[7]  FORMAT "->>>>>>>9"
         t-venta[10] FORMAT "->>>>>>>9.99"
         t-clase     FORMAT "X(2)" 
         

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
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
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP
         "LOS IMPORTES INCLUYEN I.G.V "   At 1 FORMAT "X(150)" SKIP

        "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  63 
        F-DIVISION-2 AT  75 
        F-DIVISION-3 AT  85 
        F-DIVISION-4 AT  95 
        F-DIVISION-5 AT  105
        F-DIVISION-6 AT  115
        "O T R O S"  AT  125
        "T O T A L"  AT  140 SKIP    
        " CODIGO  D E S C R I P C I O N                MARCA   U.M     VENTA     VENTA     VENTA      VENTA     VENTA      VENTA               VENTA    CLASE " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  /*WHERE t-venta[10] > 0 */
                     BREAK BY t-codcia
                           BY t-venta[10] DESCENDING:

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.
           
      ACCUM  t-venta[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[10]  ( TOTAL BY t-codcia) .
      
      DISPLAY STREAM REPORT 
                t-codmat
                t-DesMat
                t-DesMar
                t-UndBas
                t-venta[1] WHEN  t-venta[1] <> 0 FORMAT "->>>>>>>9"
                t-venta[2] WHEN  t-venta[2] <> 0 FORMAT "->>>>>>>9"
                t-venta[3] WHEN  t-venta[3] <> 0 FORMAT "->>>>>>>9"
                t-venta[4] WHEN  t-venta[4] <> 0 FORMAT "->>>>>>>9"
                t-venta[5] WHEN  t-venta[5] <> 0 FORMAT "->>>>>>>9"
                t-venta[6] WHEN  t-venta[6] <> 0 FORMAT "->>>>>>>9"
                t-venta[7] WHEN  t-venta[7] <> 0 FORMAT "->>>>>>>9"
                t-venta[10]  FORMAT "->>>>>>>9.99" 
                t-clase     
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

 
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[1]
            t-venta[2]
            t-venta[3]
            t-venta[4]
            t-venta[5]
            t-venta[6]
            t-venta[7]
            t-venta[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-venta[1]) @ t-venta[1]
            (ACCUM TOTAL BY t-codcia t-venta[2]) @ t-venta[2]
            (ACCUM TOTAL BY t-codcia t-venta[3]) @ t-venta[3]
            (ACCUM TOTAL BY t-codcia t-venta[4]) @ t-venta[4]
            (ACCUM TOTAL BY t-codcia t-venta[5]) @ t-venta[5]
            (ACCUM TOTAL BY t-codcia t-venta[6]) @ t-venta[6]
            (ACCUM TOTAL BY t-codcia t-venta[7]) @ t-venta[7]
            (ACCUM TOTAL BY t-codcia t-venta[10]) @ t-venta[10]
            WITH FRAME F-REPORTE.
      END.
     

  END.
   
  

  HIDE FRAME F-PROCESO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato6C W-Win 
PROCEDURE Formato6C :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-codmat    AT 1
         t-DesMat    FORMAT "X(40)"
         t-DesMar    FORMAT "X(6)" 
         t-UndBas    FORMAT "X(4)"
         t-Costo[1]  FORMAT "->>>>>>>9"
         t-Costo[2]  FORMAT "->>>>>>>9"
         t-Costo[3]  FORMAT "->>>>>>>9"
         t-Costo[4]  FORMAT "->>>>>>>9"
         t-Costo[5]  FORMAT "->>>>>>>9"
         t-Costo[6]  FORMAT "->>>>>>>9"
         t-Costo[7]  FORMAT "->>>>>>>9"
         t-Costo[10] FORMAT "->>>>>>>9.99"
         t-clase     FORMAT "X(2)" 
         

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA  FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU  AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
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
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP
         "LOS IMPORTES INCLUYEN I.G.V "   At 1 FORMAT "X(150)" SKIP

        "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  63 
        F-DIVISION-2 AT  75 
        F-DIVISION-3 AT  85 
        F-DIVISION-4 AT  95 
        F-DIVISION-5 AT  105
        F-DIVISION-6 AT  115
        "O T R O S"  AT  125
        "T O T A L"  AT  140 SKIP    
        " CODIGO  D E S C R I P C I O N                MARCA   U.M     Costo     Costo     Costo      Costo     Costo      Costo               Costo    CLASE " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  /*WHERE t-Costo[10] > 0 */
                     BREAK BY t-codcia
                           BY t-Costo[10] DESCENDING:

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.
           
      ACCUM  t-Costo[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[10]  ( TOTAL BY t-codcia) .
      
      DISPLAY STREAM REPORT 
                t-codmat
                t-DesMat
                t-DesMar
                t-UndBas
                t-Costo[1] WHEN  t-Costo[1] <> 0 FORMAT "->>>>>>>9"
                t-Costo[2] WHEN  t-Costo[2] <> 0 FORMAT "->>>>>>>9"
                t-Costo[3] WHEN  t-Costo[3] <> 0 FORMAT "->>>>>>>9"
                t-Costo[4] WHEN  t-Costo[4] <> 0 FORMAT "->>>>>>>9"
                t-Costo[5] WHEN  t-Costo[5] <> 0 FORMAT "->>>>>>>9"
                t-Costo[6] WHEN  t-Costo[6] <> 0 FORMAT "->>>>>>>9"
                t-Costo[7] WHEN  t-Costo[7] <> 0 FORMAT "->>>>>>>9"
                t-Costo[10]  FORMAT "->>>>>>>9.99" 
                t-clase     
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

 
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-Costo[1]
            t-Costo[2]
            t-Costo[3]
            t-Costo[4]
            t-Costo[5]
            t-Costo[6]
            t-Costo[7]
            t-Costo[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-Costo[1]) @ t-Costo[1]
            (ACCUM TOTAL BY t-codcia t-Costo[2]) @ t-Costo[2]
            (ACCUM TOTAL BY t-codcia t-Costo[3]) @ t-Costo[3]
            (ACCUM TOTAL BY t-codcia t-Costo[4]) @ t-Costo[4]
            (ACCUM TOTAL BY t-codcia t-Costo[5]) @ t-Costo[5]
            (ACCUM TOTAL BY t-codcia t-Costo[6]) @ t-Costo[6]
            (ACCUM TOTAL BY t-codcia t-Costo[7]) @ t-Costo[7]
            (ACCUM TOTAL BY t-codcia t-Costo[10]) @ t-Costo[10]
            WITH FRAME F-REPORTE.
      END.
     

  END.
   
  

  HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato6D W-Win 
PROCEDURE Formato6D :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-codmat    AT 1
         t-DesMat    FORMAT "X(40)"
         t-DesMar    FORMAT "X(6)" 
         t-UndBas    FORMAT "X(4)"
         t-Marge[1]  FORMAT "->>>>>>>9"
         t-Marge[2]  FORMAT "->>>>>>>9"
         t-Marge[3]  FORMAT "->>>>>>>9"
         t-Marge[4]  FORMAT "->>>>>>>9"
         t-Marge[5]  FORMAT "->>>>>>>9"
         t-Marge[6]  FORMAT "->>>>>>>9"
         t-Marge[7]  FORMAT "->>>>>>>9"
         t-Marge[10] FORMAT "->>>>>>>9.99"
         t-clase     FORMAT "X(2)" 
         

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU  AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
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
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP

        "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  63 
        F-DIVISION-2 AT  75 
        F-DIVISION-3 AT  85 
        F-DIVISION-4 AT  95 
        F-DIVISION-5 AT  105
        F-DIVISION-6 AT  115
        "O T R O S"  AT  125
        "T O T A L"  AT  140 SKIP    
        " CODIGO  D E S C R I P C I O N                MARCA   U.M     Marge     Marge     Marge      Marge     Marge      Marge               Marge    CLASE " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  /*WHERE t-Marge[10] > 0 */
                     BREAK BY t-codcia
                           BY t-Marge[10] DESCENDING:

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.
           
      T-Marge[1] = (T-Venta[1] - T-Costo[1]) / T-Venta[1] .
      T-Marge[2] = (T-Venta[2] - T-Costo[2]) / T-Venta[2] .
      T-Marge[3] = (T-Venta[3] - T-Costo[3]) / T-Venta[3] .
      T-Marge[4] = (T-Venta[4] - T-Costo[4]) / T-Venta[4] .
      T-Marge[5] = (T-Venta[5] - T-Costo[5]) / T-Venta[5] .
      T-Marge[6] = (T-Venta[6] - T-Costo[6]) / T-Venta[6] .
      T-Marge[7] = (T-Venta[7] - T-Costo[7]) / T-Venta[7] .
      T-Marge[10] = (T-Venta[10] - T-Costo[10]) / T-Venta[10] .

      ACCUM  t-Marge[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[10]  ( TOTAL BY t-codcia) .
      
      ACCUM  t-Venta[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[10]  ( TOTAL BY t-codcia) .

      ACCUM  t-Costo[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[10]  ( TOTAL BY t-codcia) .

      DISPLAY STREAM REPORT 
                t-codmat
                t-DesMat
                t-DesMar
                t-UndBas
                t-Marge[1] WHEN  t-Marge[1] <> 0 FORMAT "->>>>>>>9"
                t-Marge[2] WHEN  t-Marge[2] <> 0 FORMAT "->>>>>>>9"
                t-Marge[3] WHEN  t-Marge[3] <> 0 FORMAT "->>>>>>>9"
                t-Marge[4] WHEN  t-Marge[4] <> 0 FORMAT "->>>>>>>9"
                t-Marge[5] WHEN  t-Marge[5] <> 0 FORMAT "->>>>>>>9"
                t-Marge[6] WHEN  t-Marge[6] <> 0 FORMAT "->>>>>>>9"
                t-Marge[7] WHEN  t-Marge[7] <> 0 FORMAT "->>>>>>>9"
                t-Marge[10]  FORMAT "->>>>>>>9.99" 
                t-clase     
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

 
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-Marge[1]
            t-Marge[2]
            t-Marge[3]
            t-Marge[4]
            t-Marge[5]
            t-Marge[6]
            t-Marge[7]
            t-Marge[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            ((ACCUM TOTAL BY t-codcia t-Venta[1]) - (ACCUM TOTAL BY t-codcia t-Costo[1])) / (ACCUM TOTAL BY t-codcia t-Venta[1]) @ t-Marge[1] 
            ((ACCUM TOTAL BY t-codcia t-Venta[2]) - (ACCUM TOTAL BY t-codcia t-Costo[2])) / (ACCUM TOTAL BY t-codcia t-Venta[2]) @ t-Marge[2] 
            ((ACCUM TOTAL BY t-codcia t-Venta[3]) - (ACCUM TOTAL BY t-codcia t-Costo[3])) / (ACCUM TOTAL BY t-codcia t-Venta[3]) @ t-Marge[3] 
            ((ACCUM TOTAL BY t-codcia t-Venta[4]) - (ACCUM TOTAL BY t-codcia t-Costo[4])) / (ACCUM TOTAL BY t-codcia t-Venta[4]) @ t-Marge[4] 
            ((ACCUM TOTAL BY t-codcia t-Venta[5]) - (ACCUM TOTAL BY t-codcia t-Costo[5])) / (ACCUM TOTAL BY t-codcia t-Venta[5]) @ t-Marge[5] 
            ((ACCUM TOTAL BY t-codcia t-Venta[6]) - (ACCUM TOTAL BY t-codcia t-Costo[6])) / (ACCUM TOTAL BY t-codcia t-Venta[6]) @ t-Marge[6] 
            ((ACCUM TOTAL BY t-codcia t-Venta[7]) - (ACCUM TOTAL BY t-codcia t-Costo[7])) / (ACCUM TOTAL BY t-codcia t-Venta[7]) @ t-Marge[7] 
            ((ACCUM TOTAL BY t-codcia t-Venta[10]) - (ACCUM TOTAL BY t-codcia t-Costo[10])) / (ACCUM TOTAL BY t-codcia t-Venta[10]) @ t-Marge[10] 
            WITH FRAME F-REPORTE.
      END.
     

  END.
   
  

  HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato6E W-Win 
PROCEDURE Formato6E :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-codmat    AT 1
         t-DesMat    FORMAT "X(40)"
         t-DesMar    FORMAT "X(6)" 
         t-UndBas    FORMAT "X(4)"
         t-Utili[1]  FORMAT "->>>>>>>9"
         t-Utili[2]  FORMAT "->>>>>>>9"
         t-Utili[3]  FORMAT "->>>>>>>9"
         t-Utili[4]  FORMAT "->>>>>>>9"
         t-Utili[5]  FORMAT "->>>>>>>9"
         t-Utili[6]  FORMAT "->>>>>>>9"
         t-Utili[7]  FORMAT "->>>>>>>9"
         t-Utili[10] FORMAT "->>>>>>>9.99"
         t-clase     FORMAT "X(2)" 
         

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA  FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU  AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")"  AT 100 FORMAT "X(25)" SKIP(1)
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
         "DIVISIONES EVALUADAS  : " + X-CODDIV AT 1 FORMAT "X(150)" SKIP

        "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  63 
        F-DIVISION-2 AT  75 
        F-DIVISION-3 AT  85 
        F-DIVISION-4 AT  95 
        F-DIVISION-5 AT  105
        F-DIVISION-6 AT  115
        "O T R O S"  AT  125
        "T O T A L"  AT  140 SKIP    
        " CODIGO  D E S C R I P C I O N                MARCA   U.M     Utili     Utili     Utili      Utili     Utili      Utili               Utili    CLASE " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  /*WHERE t-Utili[10] > 0 */
                     BREAK BY t-codcia
                           BY t-Utili[10] DESCENDING:

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.
           
      ACCUM  t-Utili[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[10]  ( TOTAL BY t-codcia) .
      
      DISPLAY STREAM REPORT 
                t-codmat
                t-DesMat
                t-DesMar
                t-UndBas
                t-Utili[1] WHEN  t-Utili[1] <> 0 FORMAT "->>>>>>>9"
                t-Utili[2] WHEN  t-Utili[2] <> 0 FORMAT "->>>>>>>9"
                t-Utili[3] WHEN  t-Utili[3] <> 0 FORMAT "->>>>>>>9"
                t-Utili[4] WHEN  t-Utili[4] <> 0 FORMAT "->>>>>>>9"
                t-Utili[5] WHEN  t-Utili[5] <> 0 FORMAT "->>>>>>>9"
                t-Utili[6] WHEN  t-Utili[6] <> 0 FORMAT "->>>>>>>9"
                t-Utili[7] WHEN  t-Utili[7] <> 0 FORMAT "->>>>>>>9"
                t-Utili[10]  FORMAT "->>>>>>>9.99" 
                t-clase     
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

 
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-Utili[1]
            t-Utili[2]
            t-Utili[3]
            t-Utili[4]
            t-Utili[5]
            t-Utili[6]
            t-Utili[7]
            t-Utili[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-Utili[1]) @ t-Utili[1]
            (ACCUM TOTAL BY t-codcia t-Utili[2]) @ t-Utili[2]
            (ACCUM TOTAL BY t-codcia t-Utili[3]) @ t-Utili[3]
            (ACCUM TOTAL BY t-codcia t-Utili[4]) @ t-Utili[4]
            (ACCUM TOTAL BY t-codcia t-Utili[5]) @ t-Utili[5]
            (ACCUM TOTAL BY t-codcia t-Utili[6]) @ t-Utili[6]
            (ACCUM TOTAL BY t-codcia t-Utili[7]) @ t-Utili[7]
            (ACCUM TOTAL BY t-codcia t-Utili[10]) @ t-Utili[10]
            WITH FRAME F-REPORTE.
      END.
     

  END.
   
  

  HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato7 W-Win 
PROCEDURE Formato7 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-codmat    AT 1
         t-DesMat    FORMAT "X(40)"
         t-DesMar    FORMAT "X(6)" 
         t-UndBas    FORMAT "X(4)"
         t-canti[1]  FORMAT "->>>>>>>9"
         t-canti[2]  FORMAT "->>>>>>>9"
         t-canti[3]  FORMAT "->>>>>>>9"
         t-canti[4]  FORMAT "->>>>>>>9"
         t-canti[5]  FORMAT "->>>>>>>9"
         t-canti[6]  FORMAT "->>>>>>>9"
         t-canti[7]  FORMAT "->>>>>>>9"
         t-canti[10] FORMAT "->>>>>>>9.99"
         t-venta[10] FORMAT "->>>>>>>9.99"
         t-clase     FORMAT "X(2)" 
         

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU  AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + ")" AT 100 FORMAT "X(25)" SKIP(1)
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
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP

        "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        SUBSTRING(F-NOMDIV-1,1,10) AT  63 
        SUBSTRING(F-NOMDIV-2,1,10) AT  75 
        SUBSTRING(F-NOMDIV-3,1,10) AT  85 
        SUBSTRING(F-NOMDIV-4,1,10) AT  95 
        SUBSTRING(F-NOMDIV-5,1,10) AT  105
        SUBSTRING(F-NOMDIV-6,1,10) AT  115
        "O T R O S"  AT  125
        "T O T A L"  AT  140 SKIP
        " CODIGO  D E S C R I P C I O N                MARCA   U.M     CANTIDAD   CANTIDAD  CANTIDAD  CANTIDAD   CANTIDAD  CANTIDAD   CANTIDAD  CANTIDAD  IMPORTE  CLASE " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  WHERE t-canti[10] > 0 
                     BREAK BY t-codcia
                           BY t-canti[10] DESCENDING :

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.
           
      ACCUM  t-venta[10]  ( TOTAL BY t-codcia) .
      
      DISPLAY STREAM REPORT 
                t-codmat
                t-DesMat
                t-DesMar
                t-UndBas
                t-canti[1] WHEN  t-canti[1] > 0 FORMAT "->>>>>>>9"
                t-canti[2] WHEN  t-canti[2] > 0 FORMAT "->>>>>>>9"
                t-canti[3] WHEN  t-canti[3] > 0 FORMAT "->>>>>>>9"
                t-canti[4] WHEN  t-canti[4] > 0 FORMAT "->>>>>>>9"
                t-canti[5] WHEN  t-canti[5] > 0 FORMAT "->>>>>>>9"
                t-canti[6] WHEN  t-canti[6] > 0 FORMAT "->>>>>>>9"
                t-canti[7] WHEN  t-canti[7] > 0 FORMAT "->>>>>>>9"
                t-canti[10]  FORMAT "->>>>>>>9.99"
                t-venta[10]  FORMAT "->>>>>>>9.99" 
                t-clase     
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

 
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-desmat
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
    IF LOOKUP(C-TIPO,"Resumen-Proveedor,Resumen-Sublinea") = 0  THEN 
        ENABLE ALL EXCEPT F-NOMDIV-1 F-NOMDIV-2 F-NOMDIV-3 F-NOMDIV-4 F-NOMDIV-5 F-NOMDIV-6.
    ELSE 
    ENABLE ALL EXCEPT F-NOMDIV-1 F-NOMDIV-2 F-NOMDIV-3 F-NOMDIV-4 F-NOMDIV-5 F-NOMDIV-6
                      F-DIVISION-1 F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6 .

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
  /*RUN bin/_prnctr.p.*/
  RUN lib/Imprimir2.
  IF s-salida-impresion = 0 THEN RETURN.
   
  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
  
/*  RUN aderb/_prlist.p(
 *       OUTPUT s-printer-list,
 *       OUTPUT s-port-list,
 *       OUTPUT s-printer-count).
 *   s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
 *   s-port-name = REPLACE(S-PORT-NAME, ":", "").*/

/*  IF s-salida-impresion = 1 THEN 
 *      s-print-file = SESSION:TEMP-DIRECTORY + "report.prn".*/

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.

  
/*  CASE s-salida-impresion:
 *         WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
 *         WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
 *         WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 *   END CASE.*/
  
  RUN Carga-Temporal.
  
  CASE C-Tipo:
    WHEN "Prove-Articulo"    THEN RUN Formato1.
    WHEN "Linea-Sublinea"    THEN RUN Formato2.
    WHEN "Resumen-Proveedor" THEN RUN Formato3.
    WHEN "Resumen-Sublinea"  THEN RUN Formato4.
    WHEN "Resumen-Linea"     THEN RUN Formato5.
    WHEN "Articulo"          THEN RUN Formato6.
  END CASE. 
  
  
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN LIB/W-README.R(s-print-file).
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
  ASSIGN C-tipo
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
         x-CodMat
         DesdeF 
         HastaF 
         nCodMon 
         C-tipo-2.
  
  IF DesdeF <> ?  THEN DesdeF = ?.
  IF HastaF <> ?  THEN HastaF = ?.
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
     ASSIGN DesdeF = TODAY  + 1 - DAY(TODAY).
            HastaF = TODAY.
            F-DIVISION-2.
            F-DIVISION-3.
            F-DIVISION-1.
            F-DIVISION-4.
            F-DIVISION-5.
            F-DIVISION-6.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_charge-list W-Win 
PROCEDURE proc_charge-list :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_file AS CHARACTER NO-UNDO.

    DEFINE VARIABLE cLine AS CHARACTER NO-UNDO.

    IF SEARCH(para_file) = ? THEN RETURN.

    x-CodMat = "".

    INPUT FROM VALUE(para_file).
    REPEAT:
        cLine = "".
        IMPORT DELIMITER "," cLine.
        IF cLine <> "" THEN DO:
            IF x-CodMat = "" THEN x-codmat = cLine.
            ELSE x-codmat = x-codmat + "," + cLine.
        END.
    END.
    INPUT CLOSE.

    DISPLAY x-codmat WITH FRAME {&FRAME-NAME}.

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
IF x-CodMat = '' THEN DO:
    MESSAGE 'Debe ingresar la lista de materiales separados por comas'
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO x-CodMat IN FRAME {&FRAME-NAME}.
    RETURN 'ADM-ERROR'.
END.
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

