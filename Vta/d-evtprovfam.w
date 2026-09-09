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
DEFINE VAR X-CANAL AS CHAR.
DEFINE VAR X-SUBFAMILIA AS CHAR.
DEFINE VAR X-MARCA    AS CHAR.
DEFINE VAR X-PROVE    AS CHAR.
DEFINE VAR X-LLAVE    AS CHAR.
DEFINE VAR X-FECHA AS DATE.
DEFINE VAR X-CODDIA AS INTEGER INIT 1.
DEFINE VAR X-CODANO AS INTEGER .
DEFINE VAR X-CODMES AS INTEGER .
DEFINE VAR X-NOMMES AS CHAR INIT "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre".
DEFINE VAR X-NOMPRO AS CHAR.

DEFINE TEMP-TABLE tmp-tempo 
    FIELD t-codcia  LIKE Almdmov.Codcia 
    FIELD t-codfam  LIKE Almmmatg.codfam
    FIELD t-Desfam  LIKE AlmtFami.DesFam  
    FIELD t-prove   LIKE Gn-prov.CodPro
    FIELD t-nompro  LIKE Gn-prov.NomPro
    FIELD t-codmat  LIKE Almdmov.codmat
    FIELD t-desmat  LIKE Almmmatg.DesMat    FORMAT "X(40)"
    FIELD t-desmar  LIKE Almmmatg.DesMar    FORMAT "X(8)"
    FIELD t-undbas  LIKE Almmmatg.UndBas    FORMAT "X(8)"
    FIELD t-ventamn AS DEC           FORMAT "->>>>>>>9.99" 
    FIELD t-ventame AS DEC           FORMAT "->>>>>>>9.99"
    FIELD t-costome AS DEC           FORMAT "->>>>>>>9.99"
    FIELD t-costomn AS DEC           FORMAT "->>>>>>>9.99"
    FIELD t-venta   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99"  
    FIELD t-costo   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99"  
    FIELD t-canti   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99" 
    FIELD x-des1  LIKE Almmmatg.DesMat    FORMAT "X(40)"
    FIELD t-canal   LIKE almtabla.codigo.

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
&Scoped-Define ENABLED-OBJECTS F-DIVISION F-CodFam F-CodProv DesdeF HastaF ~
C-tipo F-DIVISION-1 F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 ~
F-DIVISION-6 nCodMon Btn_OK Btn_Cancel Btn_Help BUTTON-5 BUTTON-1 BUTTON-2 ~
RECT-58 RECT-61 RECT-62 RECT-63 
&Scoped-Define DISPLAYED-OBJECTS F-DIVISION F-CodFam F-CodProv DesdeF ~
HastaF C-tipo F-DIVISION-1 F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 ~
F-DIVISION-5 F-DIVISION-6 nCodMon F-NOMDIV-1 F-NOMDIV-2 F-NOMDIV-3 ~
F-NOMDIV-4 F-NOMDIV-5 F-NOMDIV-6 txt-msj 

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

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 6" 
     SIZE 4.43 BY .77.

DEFINE VARIABLE C-tipo AS CHARACTER FORMAT "X(20)":U INITIAL "Venta" 
     VIEW-AS COMBO-BOX INNER-LINES 1
     LIST-ITEMS "Venta" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Linea" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-CodProv AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
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
     SIZE 34.29 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dolares", 2
     SIZE 16.72 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72 BY 1.81
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.57 BY 1.46.

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 8.5
     BGCOLOR 3 .

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.57 BY 5.35.

DEFINE RECTANGLE RECT-63
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.57 BY 1.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-DIVISION AT ROW 3.12 COL 11.57 COLON-ALIGNED
     F-CodFam AT ROW 3.85 COL 11.57 COLON-ALIGNED
     F-CodProv AT ROW 4.62 COL 11.57 COLON-ALIGNED
     DesdeF AT ROW 7.58 COL 11.57 COLON-ALIGNED
     HastaF AT ROW 7.65 COL 33.29 COLON-ALIGNED
     C-tipo AT ROW 1.88 COL 51.72 COLON-ALIGNED HELP
          "coloque el codigo" NO-LABEL
     F-DIVISION-1 AT ROW 3.73 COL 49.29 COLON-ALIGNED
     F-DIVISION-2 AT ROW 4.46 COL 49.29 COLON-ALIGNED
     F-DIVISION-3 AT ROW 5.27 COL 49.29 COLON-ALIGNED
     F-DIVISION-4 AT ROW 5.96 COL 49.29 COLON-ALIGNED
     F-DIVISION-5 AT ROW 6.77 COL 49.29 COLON-ALIGNED
     F-DIVISION-6 AT ROW 7.58 COL 49.29 COLON-ALIGNED
     nCodMon AT ROW 9.15 COL 52.57 NO-LABEL
     Btn_OK AT ROW 10.42 COL 38
     Btn_Cancel AT ROW 10.42 COL 49.29
     Btn_Help AT ROW 10.42 COL 60.72
     F-NOMDIV-1 AT ROW 3.77 COL 55.72 COLON-ALIGNED NO-LABEL
     F-NOMDIV-2 AT ROW 4.5 COL 55.72 COLON-ALIGNED NO-LABEL
     F-NOMDIV-3 AT ROW 5.23 COL 55.72 COLON-ALIGNED NO-LABEL
     F-NOMDIV-4 AT ROW 5.96 COL 55.72 COLON-ALIGNED NO-LABEL
     F-NOMDIV-5 AT ROW 6.77 COL 55.72 COLON-ALIGNED NO-LABEL
     F-NOMDIV-6 AT ROW 7.58 COL 55.72 COLON-ALIGNED NO-LABEL
     BUTTON-5 AT ROW 3.12 COL 25.29
     BUTTON-1 AT ROW 3.85 COL 25.14
     BUTTON-2 AT ROW 4.62 COL 25.14
     txt-msj AT ROW 10.77 COL 3 NO-LABEL WIDGET-ID 2
     " Moneda" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 8.58 COL 49.72
          FONT 6
     " Tipo de Reporte" VIEW-AS TEXT
          SIZE 14.57 BY .65 AT ROW 1.27 COL 48.43
          FONT 6
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1.35 COL 4.43
          FONT 6
     " Desplegar Divisiones" VIEW-AS TEXT
          SIZE 18.86 BY .5 AT ROW 3.08 COL 49.14
          FONT 6
     RECT-46 AT ROW 10.23 COL 2
     RECT-58 AT ROW 1.54 COL 47.43
     RECT-61 AT ROW 1.54 COL 2
     RECT-62 AT ROW 3.15 COL 47.43
     RECT-63 AT ROW 8.65 COL 47.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 73.86 BY 11.15
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
         HEIGHT             = 11.15
         WIDTH              = 73.86
         MAX-HEIGHT         = 11.15
         MAX-WIDTH          = 73.86
         VIRTUAL-HEIGHT     = 11.15
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
        IF NUM-ENTRIES(F-CODFAM) = 1 THEN 
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
    input-var-1 = "".
    output-var-2 = "".
    RUN lkup\C-provee02.r("Proveedores").
    IF output-var-2 <> ? THEN DO:
        F-CODPROV = output-var-2.
        DISPLAY F-CODPROV.
        APPLY "ENTRY" TO F-CODPROV.
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


&Scoped-define SELF-NAME F-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodFam W-Win
ON LEAVE OF F-CodFam IN FRAME F-Main /* Linea */
DO:
   ASSIGN F-CodFam.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodProv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodProv W-Win
ON LEAVE OF F-CodProv IN FRAME F-Main /* Proveedor */
DO:
/*
   ASSIGN F-Canal.
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   IF F-Canal = "" THEN DO:
      SELF:SCREEN-VALUE = "".
      RETURN.
   END.
   FIND AlmTabla WHERE AlmTabla.Tabla = 'CN' 
                 AND  AlmTabla.Codigo = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE AlmTabla THEN DO:
      MESSAGE "Codigo de Canal no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
*/
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
         F-CodFam 
         F-CodProv 
         DesdeF 
         HastaF 
         nCodMon .
  X-ARTI        = "ARTICULOS    : " .
  X-FAMILIA     = "FAMILIA      : ".
  X-CANAL       = "CANAL        : ".
  
    
  S-SUBTIT =   "PERIODO      : " + STRING(DesdeF,"99/99/9999") + " al " + STRING(HastaF,"99/99/9999").

  X-MONEDA =   "MONEDA       : " + IF NCODMON = 1 THEN "NUEVOS SOLES " ELSE "DOLARES AMERICANOS ".  

  IF DesdeF = ?  THEN DesdeF = 01/01/1900.
  IF HastaF = ?  THEN HastaF = 01/01/3000.

  IF F-DIVISION = "" THEN DO:
    X-CODDIV = "".
    FOR EACH Gn-Divi NO-LOCK WHERE Gn-Divi.Codcia = S-CODCIA:
        X-CODDIV = X-CODDIV + SUBSTRING(Gn-Divi.Desdiv,1,10) + "," .
    END.
  END.
  ELSE DO:
  FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                      Gn-Divi.Coddiv = F-DIVISION NO-LOCK NO-ERROR.
  X-CODDIV = SUBSTRING(Gn-Divi.Desdiv,1,20) + "," .
  END.

  IF F-CODFAM = "" THEN DO:
    X-FAMILIA = "FAMILIA      : ".
    FOR EACH AlmtFami NO-LOCK WHERE AlmtFami.Codcia = S-CODCIA:
        X-FAMILIA = X-FAMILIA + AlmtFami.CodFam + "," .
    END.
  END.
  ELSE DO:
   FIND AlmtFami WHERE AlmtFami.Codcia = S-CODCIA AND
                      AlmtFami.CodFam = F-CODFAM NO-LOCK NO-ERROR.
   X-FAMILIA = X-FAMILIA + Almtfami.CodFam + "," .
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
DEFINE VAR X-DESCANAL AS CHAR.
DEFINE VAR X-DESFAM AS CHAR.

/*******Inicializa la Tabla Temporal ******/
FOR EACH tmp-tempo :
  DELETE tmp-tempo.
END.
/********************************/

                                  
    FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
                         AND Gn-Divi.CodDiv BEGINS F-DIVISION:

        FOR EACH EvtProvL NO-LOCK WHERE EvtProvL.CodCia = S-CODCIA
                         AND   EvtProvL.CodDiv = Gn-Divi.Coddiv
                         AND   EvtProvL.CodProv BEGINS F-CodProv
                         AND   EvtProvL.CodFam  BEGINS F-CodFam
                         AND   (EvtProvL.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
                         AND   EvtProvL.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99"))):

                /*
                DISPLAY EvtProvL.CodProv @ Fi-Mensaje LABEL "Codigo de Proveedor "
                FORMAT "X(11)" WITH FRAME F-Proceso.
                */

                FIND gn-prov where gn-prov.codcia = pv-codcia and
                                   gn-prov.codpro = EvtProvL.codprov
                                   no-lock no-error.
                IF AVAILABLE gn-prov 
                THEN x-NomPro = gn-prov.nompro.
                ELSE x-NomPro = ''.
     
                X-DESFAM=''.
                FIND AlmtFami WHERE AlmtFami.Codcia = S-CODCIA 
                         AND  AlmtFami.CodFam  =  EvtProvL.codfam 
                        NO-LOCK NO-ERROR.
                IF AVAILABLE AlmtFami THEN DO:
                   X-DESFAM=AlmtFami.DesFam.
                END.    
                T-Vtamn   = 0.
                T-Vtame   = 0.
                T-Ctomn   = 0.
                T-Ctome   = 0.
                F-Salida  = 0.
          
                /*****************Capturando el Mes siguiente *******************/
                IF EvtProvL.Codmes < 12 THEN DO:
                  ASSIGN
                  X-CODMES = EvtProvL.Codmes + 1
                  X-CODANO = EvtProvL.Codano .
                END.
                ELSE DO: 
                  ASSIGN
                  X-CODMES = 01
                  X-CODANO = EvtProvL.Codano + 1 .
                END.
                /**********************************************************************/
                
                /*********************** Calculo Para Obtener los datos diarios ************/
                 DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
          
                      X-FECHA = DATE(STRING(I,"99") + "/" + STRING(EvtProvL.Codmes,"99") + "/" + STRING(EvtProvL.Codano,"9999")).
                      IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
                          FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(EvtProvL.Codmes,"99") + "/" + STRING(EvtProvL.Codano,"9999")) NO-LOCK NO-ERROR.
                          IF AVAILABLE Gn-tcmb THEN DO: 
                           F-Salida  = F-Salida  + EvtProvL.CanxDia[I].
                           T-Vtamn   = T-Vtamn   + EvtProvL.Vtaxdiamn[I] + EvtProvL.Vtaxdiame[I] * Gn-Tcmb.Venta.
                           T-Vtame   = T-Vtame   + EvtProvL.Vtaxdiame[I] + EvtProvL.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                          END.
                      END.
                 END.         
      
                /******************************************************************************/      
                FIND tmp-tempo WHERE t-codcia  = S-CODCIA
                                AND  t-prove   = EvtProvL.CodProv      
                                AND  t-codfam  = EvtProvL.CodFam
                                NO-ERROR.
          
                IF NOT AVAIL tmp-tempo THEN DO:
                  CREATE tmp-tempo.
                  ASSIGN t-codcia  = S-CODCIA
                         t-prove   = EvtProvL.codpro
                         t-nompro  = x-nompro
                         t-codfam  = EvtProvL.codfam 
                         t-desfam  = X-DESFAM.
                END.
                ASSIGN T-Canti[10] = T-Canti[10] + F-Salida 
                       T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                       T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
      
                /******************************Secuencia Para Cargar Datos en las Columnas *****************/
                
                X-ENTRA = FALSE.
                IF F-DIVISION-1 <> "" AND EvtProvL.Coddiv = F-DIVISION-1 THEN DO:
                   ASSIGN T-Canti[1] = T-Canti[1] + F-Salida 
                          T-Venta[1] = T-venta[1] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[1] = T-Costo[1] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                          X-ENTRA = TRUE.
                END.       
                IF F-DIVISION-2 <> "" AND EvtProvL.Coddiv = F-DIVISION-2 THEN DO:
                   ASSIGN T-Canti[2] = T-Canti[2] + F-Salida 
                          T-Venta[2] = T-venta[2] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[2] = T-Costo[2] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                          X-ENTRA = TRUE.
                END.       
                IF F-DIVISION-3 <> "" AND EvtProvL.Coddiv = F-DIVISION-3 THEN DO:
                   ASSIGN T-Canti[3] = T-Canti[3] + F-Salida 
                          T-Venta[3] = T-venta[3] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[3] = T-Costo[3] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                          X-ENTRA = TRUE.
                END.       
                IF F-DIVISION-4 <> "" AND EvtProvL.Coddiv = F-DIVISION-4 THEN DO:
                   ASSIGN T-Canti[4] = T-Canti[4] + F-Salida  
                          T-Venta[4] = T-venta[4] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[4] = T-Costo[4] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                          X-ENTRA = TRUE.
                END.       
                IF F-DIVISION-5 <> "" AND EvtProvL.Coddiv = F-DIVISION-5 THEN DO:
                   ASSIGN T-Canti[5] = T-Canti[5] + F-Salida 
                          T-Venta[5] = T-venta[5] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[5] = T-Costo[5] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                          X-ENTRA = TRUE.
                END.       
                IF F-DIVISION-6 <> "" AND EvtProvL.Coddiv = F-DIVISION-6 THEN DO:
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
  DISPLAY F-DIVISION F-CodFam F-CodProv DesdeF HastaF C-tipo F-DIVISION-1 
          F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6 
          nCodMon F-NOMDIV-1 F-NOMDIV-2 F-NOMDIV-3 F-NOMDIV-4 F-NOMDIV-5 
          F-NOMDIV-6 txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE F-DIVISION F-CodFam F-CodProv DesdeF HastaF C-tipo F-DIVISION-1 
         F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6 
         nCodMon Btn_OK Btn_Cancel Btn_Help BUTTON-5 BUTTON-1 BUTTON-2 RECT-58 
         RECT-61 RECT-62 RECT-63 
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
  DEFINE FRAME F-REPORTE
         t-codfam    AT 1
         t-Desfam    FORMAT "X(40)"
         t-venta[1]  FORMAT "->>>>>>>9"
         t-venta[2]  FORMAT "->>>>>>>9"
         t-venta[3]  FORMAT "->>>>>>>9"
         t-venta[4]  FORMAT "->>>>>>>9"
         t-venta[5]  FORMAT "->>>>>>>9"
         t-venta[6]  FORMAT "->>>>>>>9"
         t-venta[7]  FORMAT "->>>>>>>9"
         t-venta[10]  FORMAT "->>>>>>>9.99"
         t-venta[10]  FORMAT "->>>>>>>9.99"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA AT 1 FORMAT 'x(50)' SKIP(1)
         X-TITU AT 40 FORMAT 'x(50)'
         "(" + C-TIPO + ")"  AT 100 FORMAT "X(25)" SKIP(1)
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Pagina : " TO 135 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         X-CANAL  AT 1  FORMAT "X(60)" 
         X-FAMILIA  AT 1  FORMAT "X(60)" 
         "Fecha  :" TO 135 TODAY TO 147 FORMAT "99/99/9999" SKIP
         "Hora   :" TO 135 STRING(TIME,"HH:MM:SS") TO 147   SKIP
         X-MONEDA AT 80  FORMAT "X(60)" SKIP
         "DIVISIONES EVALUADAS  : " + X-CODDIV At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        SUBSTRING(F-NOMDIV-1,1,10) FORMAT 'x(9)' AT  46
        SUBSTRING(F-NOMDIV-2,1,10) FORMAT 'x(9)' 
        SUBSTRING(F-NOMDIV-3,1,10) FORMAT 'x(9)' 
        SUBSTRING(F-NOMDIV-4,1,10) FORMAT 'x(9)' 
        SUBSTRING(F-NOMDIV-5,1,10) FORMAT 'x(9)' 
        SUBSTRING(F-NOMDIV-6,1,10) FORMAT 'x(9)' 
        "O T R O S"  SPACE(3)
        "T O T A L"  SKIP
        " CODIGO  D E S C R I P C I O N                 IMPORTE   IMPORTE   IMPORTE   IMPORTE   IMPORTE   IMPORTE   IMPORTE      IMPORTE              " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*
         12345678901234567890123456789012345678901234567890
         123 1234567890123456789012345678901234567890 ->>>>>>>9 ->>>>>>>9 ->>>>>>>9 ->>>>>>>9 ->>>>>>>9 ->>>>>>>9 ->>>>>>>9 ->>>>>>>9.99 ->>>>>>>9.99

*/
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo BREAK BY t-codcia
                           BY t-prove
                           BY t-codfam:
      /*
      DISPLAY t-prove @ Fi-Mensaje LABEL "Codigo de Proveedor "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */
      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-prove) THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "PROVEEDOR : "   
                                 t-prove FORMAT "X(15)" 
                                 t-nompro FORMAT "X(40)" SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.
                          
      END.

      ACCUM  t-venta[10]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-venta[10]  ( TOTAL BY t-codcia) .
      
      DISPLAY STREAM REPORT 
                t-codfam
                t-Desfam
                t-DesMar
                t-venta[1] WHEN  t-venta[1] > 0 FORMAT "->>>>>>>9"
                t-venta[2] WHEN  t-venta[2] > 0 FORMAT "->>>>>>>9"
                t-venta[3] WHEN  t-venta[3] > 0 FORMAT "->>>>>>>9"
                t-venta[4] WHEN  t-venta[4] > 0 FORMAT "->>>>>>>9"
                t-venta[5] WHEN  t-venta[5] > 0 FORMAT "->>>>>>>9"
                t-venta[6] WHEN  t-venta[6] > 0 FORMAT "->>>>>>>9"
                t-venta[7] WHEN  t-venta[7] > 0 FORMAT "->>>>>>>9"
                t-venta[10]  FORMAT "->>>>>>>9.99"
                t-venta[10]  FORMAT "->>>>>>>9.99"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-prove) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL PROVEEDOR : " + t-prove) @ t-desfam
            (ACCUM SUB-TOTAL BY t-prove t-venta[10]) @ t-venta[10] 
            WITH FRAME F-REPORTE.
      END.
  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT
            ("TOTAL   : " + S-NOMCIA ) @ t-desfam
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
        CASE C-Tipo:
            WHEN "Venta" THEN RUN Formato1.
        END CASE.
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
         F-CodFam 
         F-CodProv
         DesdeF 
         HastaF 
         nCodMon .
  
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
IF F-CODPROV <> "" THEN DO:
    FIND GN-PROV WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = F-CODPROV
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE GN-PROV THEN DO:
        MESSAGE "Proveedor" f-codprov " NO existe" SKIP
            "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO F-CODPROV IN FRAME {&FRAME-NAME}.
        RETURN "ADM-ERROR".
    END.
END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

