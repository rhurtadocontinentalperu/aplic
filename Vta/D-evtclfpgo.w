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
DEFINE SHARED VAR CL-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA  AS CHARACTER.
DEFINE        VAR F-PESALM  AS DECIMAL NO-UNDO.
DEFINE SHARED VAR S-CODDIV  AS CHARACTER.

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
    WITH OVERLAY CENTERED KEEP-TAB-ORDER 
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
DEFINE VAR X-CANAL   AS  CHAR.
DEFINE VAR X-PAGO    AS CHAR.
DEFINE VAR X-LLAVE    AS CHAR.
DEFINE VAR X-FECHA AS DATE.
DEFINE VAR X-CODDIA AS INTEGER INIT 1.
DEFINE VAR X-CODANO AS INTEGER .
DEFINE VAR X-CODMES AS INTEGER .
DEFINE VAR X-NOMMES AS CHAR INIT "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre".
DEFINE VAR X-DESCAN AS CHAR.
DEFINE VAR X-FMAPGO AS CHAR.


DEFINE TEMP-TABLE tmp-tempo 
    FIELD t-codcia  LIKE Almdmov.Codcia 
    FIELD t-fmapgo  LIKE evtclfpgo.fmapgo
    FIELD t-despgo  LIKE gn-convt.nombr FORMAT "X(40)" 
    FIELD t-canal   LIKE gn-clie.Canal
    FIELD t-descan  LIKE gn-convt.nombr  FORMAT "X(40)"
    FIELD t-codcli  LIKE evtclfpgo.Codcli
    FIELD t-nomcli  LIKE gn-clie.nomcli  FORMAT "X(40)"
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
&Scoped-Define ENABLED-OBJECTS RECT-63 RECT-61 RECT-58 RECT-62 C-tipo ~
F-DIVISION BUTTON-5 C-tipo-2 F-canal BUTTON-4 f-cpago BUTTON-6 F-DIVISION-1 ~
DesdeF HastaF F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 ~
F-DIVISION-6 nCodMon Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS C-tipo F-DIVISION C-tipo-2 F-canal f-cpago ~
F-DIVISION-1 F-NOMDIV-1 DesdeF HastaF F-DIVISION-2 F-NOMDIV-2 F-NOMDIV-3 ~
F-DIVISION-3 F-DIVISION-4 F-NOMDIV-4 F-DIVISION-5 F-NOMDIV-5 F-DIVISION-6 ~
F-NOMDIV-6 nCodMon txt-msj 

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

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 4" 
     SIZE 4.43 BY .77.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 6" 
     SIZE 4.43 BY .77.

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 6" 
     SIZE 4.43 BY .77.

DEFINE VARIABLE C-tipo AS CHARACTER FORMAT "X(20)":U INITIAL "Prove-Cliente" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Prove-Cliente","Linea-Sublinea","Resumen-Proveedor","Resumen-Sublinea","Resumen-Linea","Cliente" 
     DROP-DOWN-LIST
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE C-tipo-2 AS CHARACTER FORMAT "X(20)":U INITIAL "Cantidad" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Cantidad","Venta","Costo","Margen","Utilidad" 
     DROP-DOWN-LIST
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-canal AS CHARACTER FORMAT "X(11)":U 
     LABEL "Canal" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-cpago AS CHARACTER FORMAT "X(6)":U 
     LABEL "Cond.Pago" 
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

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U INITIAL "Cargando Informacion....." 
     VIEW-AS FILL-IN 
     SIZE 35.29 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dolares", 2
     SIZE 16.72 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72 BY 1.5
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.86 BY 2.77.

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45.14 BY 9.65
     BGCOLOR 3 .

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.86 BY 5.35.

DEFINE RECTANGLE RECT-63
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.86 BY 1.19.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     C-tipo AT ROW 2.19 COL 49.43 COLON-ALIGNED HELP
          "coloque el codigo" NO-LABEL
     F-DIVISION AT ROW 3.12 COL 11.57 COLON-ALIGNED
     BUTTON-5 AT ROW 3.12 COL 25.29
     C-tipo-2 AT ROW 3.15 COL 49.43 COLON-ALIGNED NO-LABEL
     F-canal AT ROW 3.92 COL 11.57 COLON-ALIGNED
     BUTTON-4 AT ROW 4 COL 25.14
     f-cpago AT ROW 4.65 COL 11.57 COLON-ALIGNED
     BUTTON-6 AT ROW 4.81 COL 25.14
     F-DIVISION-1 AT ROW 5.08 COL 49.14 COLON-ALIGNED
     F-NOMDIV-1 AT ROW 5.12 COL 55.57 COLON-ALIGNED NO-LABEL
     DesdeF AT ROW 5.42 COL 11.57 COLON-ALIGNED
     HastaF AT ROW 5.42 COL 33.29 COLON-ALIGNED
     F-DIVISION-2 AT ROW 5.81 COL 49.14 COLON-ALIGNED
     F-NOMDIV-2 AT ROW 5.85 COL 55.57 COLON-ALIGNED NO-LABEL
     F-NOMDIV-3 AT ROW 6.58 COL 55.57 COLON-ALIGNED NO-LABEL
     F-DIVISION-3 AT ROW 6.62 COL 49.14 COLON-ALIGNED
     F-DIVISION-4 AT ROW 7.31 COL 49.14 COLON-ALIGNED
     F-NOMDIV-4 AT ROW 7.31 COL 55.57 COLON-ALIGNED NO-LABEL
     F-DIVISION-5 AT ROW 8.12 COL 49.14 COLON-ALIGNED
     F-NOMDIV-5 AT ROW 8.12 COL 55.57 COLON-ALIGNED NO-LABEL
     F-DIVISION-6 AT ROW 8.92 COL 49.14 COLON-ALIGNED
     F-NOMDIV-6 AT ROW 8.92 COL 55.57 COLON-ALIGNED NO-LABEL
     nCodMon AT ROW 10.5 COL 52.43 NO-LABEL
     Btn_OK AT ROW 11.38 COL 39
     Btn_Cancel AT ROW 11.38 COL 50.29
     Btn_Help AT ROW 11.38 COL 61.72
     txt-msj AT ROW 11.69 COL 2.72 NO-LABEL WIDGET-ID 2
     " Tipo de Reporte" VIEW-AS TEXT
          SIZE 16.29 BY .65 AT ROW 1.27 COL 48.43
          FONT 6
     "Moneda" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 9.92 COL 49.57
          FONT 6
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1.35 COL 4.43
          FONT 6
     " Desplegar Divisiones" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 4.38 COL 49
          FONT 6
     RECT-63 AT ROW 10 COL 47.29
     RECT-61 AT ROW 1.54 COL 2
     RECT-58 AT ROW 1.54 COL 47.43
     RECT-46 AT ROW 11.42 COL 2
     RECT-62 AT ROW 4.5 COL 47.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 74.43 BY 11.96
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
         HEIGHT             = 11.96
         WIDTH              = 74.43
         MAX-HEIGHT         = 11.96
         MAX-WIDTH          = 74.43
         VIRTUAL-HEIGHT     = 11.96
         VIRTUAL-WIDTH      = 74.43
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
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       txt-msj:HIDDEN IN FRAME F-Main           = TRUE
       txt-msj:READ-ONLY IN FRAME F-Main        = TRUE.

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
  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "CN".
    output-var-2 = "".
    RUN lkup\C-ALMTAB.r("Canal").
    IF output-var-2 <> ? THEN DO:
        F-canal = output-var-2.
        DISPLAY F-Canal.
        APPLY "ENTRY" TO F-Canal .
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


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Button 6 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "".
    output-var-2 = "".
    RUN lkup\C-condvt.r("Cond.de Pago").
    IF output-var-2 <> ? THEN DO:
        F-CPAGO = output-var-2.
        DISPLAY F-CPAGO.
        APPLY "ENTRY" TO F-CPAGO .
        RETURN NO-APPLY.

    END.
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


&Scoped-define SELF-NAME F-canal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-canal W-Win
ON LEAVE OF F-canal IN FRAME F-Main /* Canal */
DO:
  ASSIGN F-Canal .
  IF F-Canal <> "" THEN DO: 
     FIND almtabla WHERE tabla="CN" AND 
          almtabla.codigo = F-Canal NO-LOCK NO-ERROR.
     IF NOT AVAILABLE almtabla THEN DO:
        MESSAGE "Codigo de Canal NO Existe " SKIP
                "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO F-Canal IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.     
     END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-cpago
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-cpago W-Win
ON LEAVE OF f-cpago IN FRAME F-Main /* Cond.Pago */
DO:
 ASSIGN F-CPAGO .
 IF F-CPAGO = "" THEN RETURN.
  FIND gn-convt WHERE gn-convt.Codig = f-cpago
                NO-LOCK NO-ERROR.
  IF NOT AVAILABLE GN-CONVT THEN DO:
     MESSAGE "Codigo No Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
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
         F-Canal
         F-cpago 
         DesdeF 
         HastaF 
         nCodMon
         C-tipo-2 .
    
    
  S-SUBTIT =   "PERIODO      : " + STRING(DesdeF,"99/99/9999") + " al " + STRING(HastaF,"99/99/9999").

  X-MONEDA =   "MONEDA       : " + IF NCODMON = 1 THEN "NUEVOS SOLES " ELSE "DOLARES AMERICANOS ".  

  X-PAGO   =   "FORMA DE PAGO : " + IF F-CPAGO = "" THEN "TODOS" ELSE F-CPAGO.

  X-CANAL  =   "CANAL DE VENTA : " + IF F-CANAL = "" THEN "TODOS" ELSE F-CANAL.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
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

                       
  FOR EACH Gn-Divi NO-LOCK WHERE Gn-Divi.Codcia = S-CODCIA 
                             AND Gn-Divi.CodDiv BEGINS F-DIVISION:
                                                  
    FOR EACH evtclfpgo NO-LOCK WHERE evtclfpgo.CodCia = S-CODCIA
                         AND   evtclfpgo.CodDiv = Gn-Divi.Coddiv
                         AND   evtclfpgo.Fmapgo begins F-cpago
                         AND   (evtclfpgo.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
                         AND   evtclfpgo.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) )
                         USE-INDEX LLAVE01,
         EACH gn-clie  WHERE gn-clie.Codcia = cl-codcia AND
                             gn-clie.Codcli = evtclfpgo.Codcli AND
                             gn-clie.canal begins f-canal:
                         
             
      /*
      DISPLAY evtclfpgo.Codcli @ Fi-Mensaje LABEL "Codigo de Cliente "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */
      T-Vtamn   = 0.
      T-Vtame   = 0.
      T-Ctomn   = 0.
      T-Ctome   = 0.
      F-Salida  = 0.

      /*****************Capturando el Mes siguiente *******************/
      IF evtclfpgo.Codmes < 12 THEN DO:
        ASSIGN
        X-CODMES = evtclfpgo.Codmes + 1
        X-CODANO = evtclfpgo.Codano .
      END.
      ELSE DO: 
        ASSIGN
        X-CODMES = 01
        X-CODANO = evtclfpgo.Codano + 1 .
      END.
      /**********************************************************************/
      
      /*********************** Calculo Para Obtener los datos diarios ************/
       DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        

            X-FECHA = DATE(STRING(I,"99") + "/" + STRING(evtclfpgo.Codmes,"99") + "/" + STRING(evtclfpgo.Codano,"9999")).
         
            IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
                FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(evtclfpgo.Codmes,"99") + "/" + STRING(evtclfpgo.Codano,"9999")) NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN DO: 
                 T-Vtamn   = T-Vtamn   + evtclfpgo.Vtaxdiamn[I] + evtclfpgo.Vtaxdiame[I] * Gn-Tcmb.Venta.
                 T-Vtame   = T-Vtame   + evtclfpgo.Vtaxdiame[I] + evtclfpgo.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                 T-Ctomn   = T-Ctomn   + evtclfpgo.Ctoxdiamn[I] + evtclfpgo.Ctoxdiame[I] * Gn-Tcmb.Venta.
                 T-Ctome   = T-Ctome   + evtclfpgo.Ctoxdiame[I] + evtclfpgo.Ctoxdiamn[I] / Gn-Tcmb.Compra.
                END.
            END.
       END.         
      
      /******************************************************************************/      

      FIND tmp-tempo WHERE t-codcia  = S-CODCIA
                      AND  t-codcli  = evtclfpgo.Codcli
                      AND  t-fmapgo  = evtclfpgo.fmapgo
                      NO-ERROR.
      IF NOT AVAIL tmp-tempo THEN DO:

        X-DESCAN = "".
        X-FMAPGO = "".
        
        /********* buscando el nombre del canal ********************/
        FIND almtabla WHERE tabla="CN" AND 
             almtabla.codigo = gn-clie.canal
             NO-LOCK NO-ERROR.
        IF AVAILABLE almtabla THEN X-DESCAN = almtabla.Nombre.

        FIND gn-convt WHERE gn-convt.Codig = evtclfpgo.fmapgo
                      NO-LOCK NO-ERROR.
        IF AVAILABLE GN-CONVT THEN X-FMAPGO = gn-ConVt.Nombr.
        /**********************************************************/

        CREATE tmp-tempo.
        ASSIGN t-codcia  = S-CODCIA
               t-codcli  = evtclfpgo.codcli
               t-nomcli  = gn-clie.nomcli
               t-canal   = gn-clie.canal
               t-descan  = X-DESCAN
               t-fmapgo  = evtclfpgo.fmapgo
               t-despgo  = X-FMAPGO.
      END.
      ASSIGN T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
             T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
             T-Marge[10] = T-Marge[10] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
             T-Utili[10] = T-Utili[10] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
      
      /******************************Secuencia Para Cargar Datos en las Columnas *****************/
      
      X-ENTRA = FALSE.
      IF F-DIVISION-1 <> "" AND evtclfpgo.Coddiv = F-DIVISION-1 THEN DO:
         ASSIGN T-Canti[1] = T-Canti[1] + F-Salida 
                T-Venta[1] = T-venta[1] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[1] = T-Costo[1] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                T-Marge[1] = T-Marge[1] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
                T-Utili[1] = T-Utili[1] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-2 <> "" AND evtclfpgo.Coddiv = F-DIVISION-2 THEN DO:
         ASSIGN T-Canti[2] = T-Canti[2] + F-Salida 
                T-Venta[2] = T-venta[2] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[2] = T-Costo[2] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                T-Marge[2] = T-Marge[2] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
                T-Utili[2] = T-Utili[2] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-3 <> "" AND evtclfpgo.Coddiv = F-DIVISION-3 THEN DO:
         ASSIGN T-Canti[3] = T-Canti[3] + F-Salida 
                T-Venta[3] = T-venta[3] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[3] = T-Costo[3] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                T-Marge[3] = T-Marge[3] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
                T-Utili[3] = T-Utili[3] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-4 <> "" AND evtclfpgo.Coddiv = F-DIVISION-4 THEN DO:
         ASSIGN T-Canti[4] = T-Canti[4] + F-Salida  
                T-Venta[4] = T-venta[4] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[4] = T-Costo[4] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                T-Marge[4] = T-Marge[4] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
                T-Utili[4] = T-Utili[4] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-5 <> "" AND evtclfpgo.Coddiv = F-DIVISION-5 THEN DO:
         ASSIGN T-Canti[5] = T-Canti[5] + F-Salida 
                T-Venta[5] = T-venta[5] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[5] = T-Costo[5] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                T-Marge[5] = T-Marge[5] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
                T-Utili[5] = T-Utili[5] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-6 <> "" AND evtclfpgo.Coddiv = F-DIVISION-6 THEN DO:
         ASSIGN T-Canti[6] = T-Canti[6] + F-Salida 
                T-Venta[6] = T-venta[6] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[6] = T-Costo[6] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
                T-Marge[6] = T-Marge[6] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
                T-Utili[6] = T-Utili[6] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.     
      END.       
      IF NOT X-ENTRA THEN DO:
         ASSIGN T-Canti[7] = T-Canti[7] + F-Salida 
                T-Venta[7] = T-venta[7] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[7] = T-Costo[7] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
                T-Marge[7] = T-Marge[7] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
                T-Utili[7] = T-Utili[7] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE. 
       END.
      
      /**************************************************************************/

   
    END.
  END.
/*
HIDE FRAME F-PROCESO.
*/
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
  DISPLAY C-tipo F-DIVISION C-tipo-2 F-canal f-cpago F-DIVISION-1 F-NOMDIV-1 
          DesdeF HastaF F-DIVISION-2 F-NOMDIV-2 F-NOMDIV-3 F-DIVISION-3 
          F-DIVISION-4 F-NOMDIV-4 F-DIVISION-5 F-NOMDIV-5 F-DIVISION-6 
          F-NOMDIV-6 nCodMon txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-63 RECT-61 RECT-58 RECT-62 C-tipo F-DIVISION BUTTON-5 C-tipo-2 
         F-canal BUTTON-4 f-cpago BUTTON-6 F-DIVISION-1 DesdeF HastaF 
         F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6 
         nCodMon Btn_OK Btn_Cancel Btn_Help 
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
         t-codcli
         t-nomcli    FORMAT "X(45)"
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
         X-PAGO  AT 1  FORMAT "X(60)" 
         "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         X-CANAL AT 1  FORMAT "X(60)" 
         "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         X-MONEDA AT 80  FORMAT "X(60)" SKIP
         "DIVISIONES EVALUADAS  : " + X-CODDIV   At 1 FORMAT "X(150)" SKIP
         "LOS IMPORTES INCLUYEN I.G.V "   At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  59 
        F-DIVISION-2 AT  70
        F-DIVISION-3 AT  80 
        F-DIVISION-4 AT  90 
        F-DIVISION-5 AT  102
        F-DIVISION-6 AT  110
        "OTROS"  AT  122
        "TOTAL"  AT  134 SKIP
        "   CLIENTE         NOMBRE O RAZON SOCIAL                  VENTA      VENTA     VENTA     VENTA      VENTA     VENTA      VENTA       VENTA      " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo BREAK BY t-codcia
                           BY t-fmapgo
                           BY t-canal :
      /*
      DISPLAY t-fmapgo @ Fi-Mensaje LABEL "Codigo de Cliente "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */
      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-fmapgo) THEN DO:
          PUT STREAM REPORT  " " SKIP.
          PUT STREAM REPORT   "FORMA DE PAGO: "   FORMAT "X(16)" AT 1 
                              t-fmapgo             FORMAT "X(15)" AT 19
                              t-despgo             FORMAT "X(40)" AT 37 SKIP.
          PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.                          
      END.
      
      IF FIRST-OF(t-canal) THEN DO:
          PUT STREAM REPORT  " " SKIP.
          PUT STREAM REPORT   "CANAL DE VENTA : "   FORMAT "X(20)" AT 10 
                              t-canal             FORMAT "X(15)" AT 35
                              t-descan            FORMAT "X(40)" AT 55 SKIP.
          PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" at 10 SKIP.                          
      END.

      ACCUM  t-venta[1]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-venta[2]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-venta[3]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-venta[4]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-venta[5]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-venta[6]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-venta[7]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-venta[10]  (SUB-TOTAL BY t-canal) .

      ACCUM  t-venta[1]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-venta[2]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-venta[3]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-venta[4]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-venta[5]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-venta[6]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-venta[7]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-venta[10]  (SUB-TOTAL BY t-fmapgo) .

      ACCUM  t-venta[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[10]  ( TOTAL BY t-codcia) .
      
      DISPLAY STREAM REPORT 
                t-codcli
                t-nomcli
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

      IF LAST-OF(t-canal) THEN DO:
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
            ("TOTAL CANAL : " + t-canal) @ t-nomcli
            (ACCUM SUB-TOTAL BY t-canal t-venta[1]) @ t-venta[1] 
            (ACCUM SUB-TOTAL BY t-canal t-venta[2]) @ t-venta[2] 
            (ACCUM SUB-TOTAL BY t-canal t-venta[3]) @ t-venta[3] 
            (ACCUM SUB-TOTAL BY t-canal t-venta[4]) @ t-venta[4] 
            (ACCUM SUB-TOTAL BY t-canal t-venta[5]) @ t-venta[5] 
            (ACCUM SUB-TOTAL BY t-canal t-venta[6]) @ t-venta[6] 
            (ACCUM SUB-TOTAL BY t-canal t-venta[7]) @ t-venta[7] 
            (ACCUM SUB-TOTAL BY t-canal t-venta[10]) @ t-venta[10] 
            WITH FRAME F-REPORTE.
      END.
  
      IF LAST-OF(t-fmapgo) THEN DO:
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
            ("TOTAL FORMA DE PAGO : " + t-fmapgo) @ t-nomcli
            (ACCUM SUB-TOTAL BY t-fmapgo t-venta[1]) @ t-venta[1] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-venta[2]) @ t-venta[2] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-venta[3]) @ t-venta[3] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-venta[4]) @ t-venta[4] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-venta[5]) @ t-venta[5] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-venta[6]) @ t-venta[6] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-venta[7]) @ t-venta[7] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-venta[10]) @ t-venta[10] 
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
            ("TOTAL   : " + S-NOMCIA ) @ t-nomcli
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
   
  /*
  HIDE FRAME F-PROCESO.
  */
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
  DEFINE FRAME F-REPORTE
         t-codcli
         t-nomcli     FORMAT "X(45)"
         t-costo[1]   FORMAT "->>>>>>>9"
         t-costo[2]   FORMAT "->>>>>>>9"
         t-costo[3]   FORMAT "->>>>>>>9"
         t-costo[4]   FORMAT "->>>>>>>9"
         t-costo[5]   FORMAT "->>>>>>>9"
         t-costo[6]   FORMAT "->>>>>>>9"
         t-costo[7]   FORMAT "->>>>>>>9"
         t-costo[10]  FORMAT "->>>>>>>9.99"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU  AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Pagina : " TO 135 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         X-PAGO  AT 1  FORMAT "X(60)" 
         "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         X-CANAL AT 1  FORMAT "X(60)" 
         "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         X-MONEDA AT 80  FORMAT "X(60)" SKIP
         "DIVISIONES EVALUADAS  : " + X-CODDIV   At 1 FORMAT "X(150)" SKIP
         "LOS IMPORTES INCLUYEN I.G.V "   At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  59 
        F-DIVISION-2 AT  70
        F-DIVISION-3 AT  80 
        F-DIVISION-4 AT  90 
        F-DIVISION-5 AT  102
        F-DIVISION-6 AT  110
        "OTROS"  AT  122
        "TOTAL"  AT  134 SKIP
        "   CLIENTE         NOMBRE O RAZON SOCIAL                  COSTO      COSTO     COSTO     COSTO      COSTO     COSTO      COSTO       COSTO      " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo BREAK BY t-codcia
                           BY t-fmapgo
                           BY t-canal :
      /* 
      DISPLAY t-fmapgo @ Fi-Mensaje LABEL "Codigo de Cliente "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */
      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-fmapgo) THEN DO:
          PUT STREAM REPORT  " " SKIP.
          PUT STREAM REPORT   "FORMA DE PAGO: "   FORMAT "X(16)" AT 1 
                              t-fmapgo             FORMAT "X(15)" AT 19
                              t-despgo             FORMAT "X(40)" AT 37 SKIP.
          PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.                          
      END.
      
      IF FIRST-OF(t-canal) THEN DO:
          PUT STREAM REPORT  " " SKIP.
          PUT STREAM REPORT   "CANAL DE VENTA : "   FORMAT "X(20)" AT 10 
                              t-canal             FORMAT "X(15)" AT 35
                              t-descan            FORMAT "X(40)" AT 55 SKIP.
          PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" at 10 SKIP.                          
      END.

      ACCUM  t-costo[1]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-costo[2]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-costo[3]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-costo[4]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-costo[5]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-costo[6]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-costo[7]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-costo[10]  (SUB-TOTAL BY t-canal) .

      ACCUM  t-costo[1]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-costo[2]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-costo[3]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-costo[4]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-costo[5]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-costo[6]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-costo[7]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-costo[10]  (SUB-TOTAL BY t-fmapgo) .

      ACCUM  t-costo[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-costo[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-costo[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-costo[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-costo[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-costo[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-costo[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-costo[10]  ( TOTAL BY t-codcia) .
      
      DISPLAY STREAM REPORT 
                t-codcli
                t-nomcli
                t-costo[1] WHEN  t-costo[1] <> 0 FORMAT "->>>>>>>9"
                t-costo[2] WHEN  t-costo[2] <> 0 FORMAT "->>>>>>>9"
                t-costo[3] WHEN  t-costo[3] <> 0 FORMAT "->>>>>>>9"
                t-costo[4] WHEN  t-costo[4] <> 0 FORMAT "->>>>>>>9"
                t-costo[5] WHEN  t-costo[5] <> 0 FORMAT "->>>>>>>9"
                t-costo[6] WHEN  t-costo[6] <> 0 FORMAT "->>>>>>>9"
                t-costo[7] WHEN  t-costo[7] <> 0 FORMAT "->>>>>>>9"
                t-costo[10]  FORMAT "->>>>>>>9.99"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-canal) THEN DO:
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
            ("TOTAL CANAL : " + t-canal) @ t-nomcli
            (ACCUM SUB-TOTAL BY t-canal t-costo[1])  @ t-costo[1] 
            (ACCUM SUB-TOTAL BY t-canal t-costo[2])  @ t-costo[2] 
            (ACCUM SUB-TOTAL BY t-canal t-costo[3])  @ t-costo[3] 
            (ACCUM SUB-TOTAL BY t-canal t-costo[4])  @ t-costo[4] 
            (ACCUM SUB-TOTAL BY t-canal t-costo[5])  @ t-costo[5] 
            (ACCUM SUB-TOTAL BY t-canal t-costo[6])  @ t-costo[6] 
            (ACCUM SUB-TOTAL BY t-canal t-costo[7])  @ t-costo[7] 
            (ACCUM SUB-TOTAL BY t-canal t-costo[10]) @ t-costo[10] 
            WITH FRAME F-REPORTE.
      END.
  
      IF LAST-OF(t-fmapgo) THEN DO:
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
            ("TOTAL FORMA DE PAGO : " + t-fmapgo) @ t-nomcli
            (ACCUM SUB-TOTAL BY t-fmapgo t-costo[1]) @ t-costo[1] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-costo[2]) @ t-costo[2] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-costo[3]) @ t-costo[3] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-costo[4]) @ t-costo[4] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-costo[5]) @ t-costo[5] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-costo[6]) @ t-costo[6] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-costo[7]) @ t-costo[7] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-costo[10]) @ t-costo[10] 
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
            ("TOTAL   : " + S-NOMCIA ) @ t-nomcli
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
   
  /*
  HIDE FRAME F-PROCESO.
  */
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
         t-codcli
         t-nomcli     FORMAT "X(45)"
         t-marge[1]   FORMAT "->>>>>>>9"
         t-marge[2]   FORMAT "->>>>>>>9"
         t-marge[3]   FORMAT "->>>>>>>9"
         t-marge[4]   FORMAT "->>>>>>>9"
         t-marge[5]   FORMAT "->>>>>>>9"
         t-marge[6]   FORMAT "->>>>>>>9"
         t-marge[7]   FORMAT "->>>>>>>9"
         t-marge[10]  FORMAT "->>>>>>>9.99"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU  AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Pagina : " TO 135 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         X-PAGO  AT 1  FORMAT "X(60)" 
         "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         X-CANAL AT 1  FORMAT "X(60)" 
         "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         X-MONEDA AT 80  FORMAT "X(60)" SKIP
         "DIVISIONES EVALUADAS  : " + X-CODDIV   At 1 FORMAT "X(150)" SKIP
         "LOS IMPORTES INCLUYEN I.G.V "   At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  59 
        F-DIVISION-2 AT  70
        F-DIVISION-3 AT  80 
        F-DIVISION-4 AT  90 
        F-DIVISION-5 AT  101
        F-DIVISION-6 AT  111
        "OTROS"  AT  121
        "TOTAL"  AT  134 SKIP                                      
        "   CLIENTE         NOMBRE O RAZON SOCIAL                 MARGEN     MARGEN    MARGEN    MARGEN     MARGEN    MARGEN     MARGEN      MARGEN     " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo BREAK BY t-codcia
                           BY t-fmapgo
                           BY t-canal :
      /*
      DISPLAY t-fmapgo @ Fi-Mensaje LABEL "Codigo de Cliente "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */
      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-fmapgo) THEN DO:
          PUT STREAM REPORT  " " SKIP.
          PUT STREAM REPORT   "FORMA DE PAGO: "   FORMAT "X(16)" AT 1 
                              t-fmapgo             FORMAT "X(15)" AT 19
                              t-despgo             FORMAT "X(40)" AT 37 SKIP.
          PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.                          
      END.
      
      IF FIRST-OF(t-canal) THEN DO:
          PUT STREAM REPORT  " " SKIP.
          PUT STREAM REPORT   "CANAL DE VENTA : "   FORMAT "X(20)" AT 10 
                              t-canal             FORMAT "X(15)" AT 35
                              t-descan            FORMAT "X(40)" AT 55 SKIP.
          PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" at 10 SKIP.                          
      END.

      ACCUM  t-marge[1]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-marge[2]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-marge[3]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-marge[4]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-marge[5]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-marge[6]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-marge[7]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-marge[10]  (SUB-TOTAL BY t-canal) .

      ACCUM  t-marge[1]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-marge[2]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-marge[3]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-marge[4]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-marge[5]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-marge[6]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-marge[7]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-marge[10]  (SUB-TOTAL BY t-fmapgo) .

      ACCUM  t-marge[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-marge[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-marge[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-marge[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-marge[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-marge[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-marge[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-marge[10]  ( TOTAL BY t-codcia) .
      
      DISPLAY STREAM REPORT 
                t-codcli
                t-nomcli
                t-marge[1] WHEN  t-marge[1] <> 0 FORMAT "->>>>>>>9"
                t-marge[2] WHEN  t-marge[2] <> 0 FORMAT "->>>>>>>9"
                t-marge[3] WHEN  t-marge[3] <> 0 FORMAT "->>>>>>>9"
                t-marge[4] WHEN  t-marge[4] <> 0 FORMAT "->>>>>>>9"
                t-marge[5] WHEN  t-marge[5] <> 0 FORMAT "->>>>>>>9"
                t-marge[6] WHEN  t-marge[6] <> 0 FORMAT "->>>>>>>9"
                t-marge[7] WHEN  t-marge[7] <> 0 FORMAT "->>>>>>>9"
                t-marge[10]  FORMAT "->>>>>>>9.99"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-canal) THEN DO:
        UNDERLINE STREAM REPORT 
            t-marge[1]
            t-marge[2]
            t-marge[3]
            t-marge[4]
            t-marge[5]
            t-marge[6]
            t-marge[7]
            t-marge[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL CANAL : " + t-canal) @ t-nomcli
            (ACCUM SUB-TOTAL BY t-canal t-marge[1])  @ t-marge[1] 
            (ACCUM SUB-TOTAL BY t-canal t-marge[2])  @ t-marge[2] 
            (ACCUM SUB-TOTAL BY t-canal t-marge[3])  @ t-marge[3] 
            (ACCUM SUB-TOTAL BY t-canal t-marge[4])  @ t-marge[4] 
            (ACCUM SUB-TOTAL BY t-canal t-marge[5])  @ t-marge[5] 
            (ACCUM SUB-TOTAL BY t-canal t-marge[6])  @ t-marge[6] 
            (ACCUM SUB-TOTAL BY t-canal t-marge[7])  @ t-marge[7] 
            (ACCUM SUB-TOTAL BY t-canal t-marge[10]) @ t-marge[10] 
            WITH FRAME F-REPORTE.
      END.
  
      IF LAST-OF(t-fmapgo) THEN DO:
        UNDERLINE STREAM REPORT 
            t-marge[1]
            t-marge[2]
            t-marge[3]
            t-marge[4]
            t-marge[5]
            t-marge[6]
            t-marge[7]
            t-marge[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL FORMA DE PAGO : " + t-fmapgo) @ t-nomcli
            (ACCUM SUB-TOTAL BY t-fmapgo t-marge[1]) @ t-marge[1] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-marge[2]) @ t-marge[2] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-marge[3]) @ t-marge[3] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-marge[4]) @ t-marge[4] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-marge[5]) @ t-marge[5] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-marge[6]) @ t-marge[6] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-marge[7]) @ t-marge[7] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-marge[10]) @ t-marge[10] 
            WITH FRAME F-REPORTE.
      END.
  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-marge[1]
            t-marge[2]
            t-marge[3]
            t-marge[4]
            t-marge[5]
            t-marge[6]
            t-marge[7]
            t-marge[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-nomcli
            (ACCUM TOTAL BY t-codcia t-marge[1]) @ t-marge[1]
            (ACCUM TOTAL BY t-codcia t-marge[2]) @ t-marge[2]
            (ACCUM TOTAL BY t-codcia t-marge[3]) @ t-marge[3]
            (ACCUM TOTAL BY t-codcia t-marge[4]) @ t-marge[4]
            (ACCUM TOTAL BY t-codcia t-marge[5]) @ t-marge[5]
            (ACCUM TOTAL BY t-codcia t-marge[6]) @ t-marge[6]
            (ACCUM TOTAL BY t-codcia t-marge[7]) @ t-marge[7]
            (ACCUM TOTAL BY t-codcia t-marge[10]) @ t-marge[10]
            WITH FRAME F-REPORTE.
      END.     
  END.   
  
  /*
  HIDE FRAME F-PROCESO.
  */
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
         t-codcli
         t-nomcli     FORMAT "X(45)"
         t-utili[1]   FORMAT "->>>>>>>9"
         t-utili[2]   FORMAT "->>>>>>>9"
         t-utili[3]   FORMAT "->>>>>>>9"
         t-utili[4]   FORMAT "->>>>>>>9"
         t-utili[5]   FORMAT "->>>>>>>9"
         t-utili[6]   FORMAT "->>>>>>>9"
         t-utili[7]   FORMAT "->>>>>>>9"
         t-utili[10]  FORMAT "->>>>>>>9.99"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU  AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Pagina : " TO 135 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         X-PAGO  AT 1  FORMAT "X(60)" 
         "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         X-CANAL AT 1  FORMAT "X(60)" 
         "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         X-MONEDA AT 80  FORMAT "X(60)" SKIP
         "DIVISIONES EVALUADAS  : " + X-CODDIV   At 1 FORMAT "X(150)" SKIP
         "LOS IMPORTES INCLUYEN I.G.V "   At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 AT  59 
        F-DIVISION-2 AT  70
        F-DIVISION-3 AT  80 
        F-DIVISION-4 AT  90 
        F-DIVISION-5 AT  102
        F-DIVISION-6 AT  110
        "OTROS"  AT  122
        "TOTAL"  AT  134 SKIP                                      
        "   CLIENTE         NOMBRE O RAZON SOCIAL               UTILIDAD   UTILIDAD  UTILIDAD  UTILIDAD   UTILIDAD  UTILIDAD   UTILIDAD    UTILIDAD     " SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo BREAK BY t-codcia
                           BY t-fmapgo
                           BY t-canal :
      /*
      DISPLAY t-fmapgo @ Fi-Mensaje LABEL "Codigo de Cliente "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */
      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-fmapgo) THEN DO:
          PUT STREAM REPORT  " " SKIP.
          PUT STREAM REPORT   "FORMA DE PAGO: "   FORMAT "X(16)" AT 1 
                              t-fmapgo             FORMAT "X(15)" AT 19
                              t-despgo             FORMAT "X(40)" AT 37 SKIP.
          PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.                          
      END.
      
      IF FIRST-OF(t-canal) THEN DO:
          PUT STREAM REPORT  " " SKIP.
          PUT STREAM REPORT   "CANAL DE VENTA : "   FORMAT "X(20)" AT 10 
                              t-canal             FORMAT "X(15)" AT 35
                              t-descan            FORMAT "X(40)" AT 55 SKIP.
          PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" at 10 SKIP.                          
      END.

      ACCUM  t-utili[1]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-utili[2]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-utili[3]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-utili[4]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-utili[5]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-utili[6]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-utili[7]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-utili[10]  (SUB-TOTAL BY t-canal) .

      ACCUM  t-utili[1]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-utili[2]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-utili[3]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-utili[4]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-utili[5]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-utili[6]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-utili[7]  (SUB-TOTAL BY t-fmapgo) .
      ACCUM  t-utili[10]  (SUB-TOTAL BY t-fmapgo) .

      ACCUM  t-utili[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-utili[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-utili[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-utili[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-utili[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-utili[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-utili[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-utili[10]  ( TOTAL BY t-codcia) .
      
      DISPLAY STREAM REPORT 
                t-codcli
                t-nomcli
                t-utili[1] WHEN  t-utili[1] <> 0 FORMAT "->>>>>>>9"
                t-utili[2] WHEN  t-utili[2] <> 0 FORMAT "->>>>>>>9"
                t-utili[3] WHEN  t-utili[3] <> 0 FORMAT "->>>>>>>9"
                t-utili[4] WHEN  t-utili[4] <> 0 FORMAT "->>>>>>>9"
                t-utili[5] WHEN  t-utili[5] <> 0 FORMAT "->>>>>>>9"
                t-utili[6] WHEN  t-utili[6] <> 0 FORMAT "->>>>>>>9"
                t-utili[7] WHEN  t-utili[7] <> 0 FORMAT "->>>>>>>9"
                t-utili[10]  FORMAT "->>>>>>>9.99"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-canal) THEN DO:
        UNDERLINE STREAM REPORT 
            t-utili[1]
            t-utili[2]
            t-utili[3]
            t-utili[4]
            t-utili[5]
            t-utili[6]
            t-utili[7]
            t-utili[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL CANAL : " + t-canal) @ t-nomcli
            (ACCUM SUB-TOTAL BY t-canal t-utili[1])  @ t-utili[1] 
            (ACCUM SUB-TOTAL BY t-canal t-utili[2])  @ t-utili[2] 
            (ACCUM SUB-TOTAL BY t-canal t-utili[3])  @ t-utili[3] 
            (ACCUM SUB-TOTAL BY t-canal t-utili[4])  @ t-utili[4] 
            (ACCUM SUB-TOTAL BY t-canal t-utili[5])  @ t-utili[5] 
            (ACCUM SUB-TOTAL BY t-canal t-utili[6])  @ t-utili[6] 
            (ACCUM SUB-TOTAL BY t-canal t-utili[7])  @ t-utili[7] 
            (ACCUM SUB-TOTAL BY t-canal t-utili[10]) @ t-utili[10] 
            WITH FRAME F-REPORTE.
      END.
  
      IF LAST-OF(t-fmapgo) THEN DO:
        UNDERLINE STREAM REPORT 
            t-utili[1]
            t-utili[2]
            t-utili[3]
            t-utili[4]
            t-utili[5]
            t-utili[6]
            t-utili[7]
            t-utili[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL FORMA DE PAGO : " + t-fmapgo) @ t-nomcli
            (ACCUM SUB-TOTAL BY t-fmapgo t-utili[1]) @ t-utili[1] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-utili[2]) @ t-utili[2] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-utili[3]) @ t-utili[3] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-utili[4]) @ t-utili[4] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-utili[5]) @ t-utili[5] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-utili[6]) @ t-utili[6] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-utili[7]) @ t-utili[7] 
            (ACCUM SUB-TOTAL BY t-fmapgo t-utili[10]) @ t-utili[10] 
            WITH FRAME F-REPORTE.
      END.
  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-utili[1]
            t-utili[2]
            t-utili[3]
            t-utili[4]
            t-utili[5]
            t-utili[6]
            t-utili[7]
            t-utili[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL   : " + S-NOMCIA ) @ t-nomcli
            (ACCUM TOTAL BY t-codcia t-utili[1]) @ t-utili[1]
            (ACCUM TOTAL BY t-codcia t-utili[2]) @ t-utili[2]
            (ACCUM TOTAL BY t-codcia t-utili[3]) @ t-utili[3]
            (ACCUM TOTAL BY t-codcia t-utili[4]) @ t-utili[4]
            (ACCUM TOTAL BY t-codcia t-utili[5]) @ t-utili[5]
            (ACCUM TOTAL BY t-codcia t-utili[6]) @ t-utili[6]
            (ACCUM TOTAL BY t-codcia t-utili[7]) @ t-utili[7]
            (ACCUM TOTAL BY t-codcia t-utili[10]) @ t-utili[10]
            WITH FRAME F-REPORTE.
      END.
     

  END.
   
  /*
  HIDE FRAME F-PROCESO.
  */
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

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".
    
    txt-msj:VISIBLE IN FRAME {&FRAME-NAME} = YES.
    RUN Carga-Temporal.

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        RUN Formato1.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
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
         F-canal 
         F-Cpago 
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
  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.
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
        WHEN "f-canal" THEN ASSIGN input-var-1 = "CN".
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

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

