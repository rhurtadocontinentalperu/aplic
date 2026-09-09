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
DEFINE VAR X-LLAVE    AS CHAR.
DEFINE VAR X-FECHA AS DATE.
DEFINE VAR X-ENTRA AS LOGICAL INIT FALSE.
DEFINE VAR X-CODDIA AS INTEGER INIT 1.
DEFINE VAR X-CODANO AS INTEGER .
DEFINE VAR X-CODMES AS INTEGER .
DEFINE VAR X-NOMMES AS CHAR INIT "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre".

DEFINE TEMP-TABLE T-Almmmatg LIKE Almmmatg.

DEFINE TEMP-TABLE tmp-tempo 
    FIELD t-codcia  LIKE EvtProv.Codcia 
    FIELD t-CodProv  LIKE EvtProv.CodProv     
    FIELD t-Codano  LIKE EvtProv.Codano
    FIELD t-Codmes  LIKE EvtProv.Codmes
    FIELD t-Coddia  LIKE EvtProv.Codano
    FIELD t-fchdoc  LIKE Almdmov.fchdoc
    /*RD01*********/
    FIELD t-coddiv  LIKE evtall01.coddiv
    FIELD t-codfam  LIKE evtall01.codfam
    FIELD t-subfam  LIKE evtall01.subfam
    FIELD t-codmat  LIKE evtall01.codmat   
    /*RD01*********/
    FIELD t-ventamn AS DEC           FORMAT "->>>>>>>9.99" 
    FIELD t-ventame AS DEC           FORMAT "->>>>>>>9.99"
    FIELD t-costome AS DEC           FORMAT "->>>>>>>9.99"
    FIELD t-costomn AS DEC           FORMAT "->>>>>>>9.99"
    FIELD t-venta   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99"  
    FIELD t-costo   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99"  
    FIELD t-canti   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99" 
    FIELD t-marge   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99"  
    FIELD t-utili   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99"   .

DEFINE TEMP-TABLE tmp-temporal 
    FIELD tt-codcia  LIKE Almdmov.Codcia 
    FIELD tt-coddiv  LIKE evtall01.coddiv
    FIELD tt-codpro  LIKE evtprov.codpro
    FIELD tt-codfam  LIKE Almmmatg.codfam 
    FIELD tt-subfam  LIKE Almmmatg.subfam
    FIELD tt-codcli  LIKE evtall01.codunico
    FIELD tt-name    LIKE gn-clie.nomcli
    FIELD tt-numano  AS   INTEGER
    FIELD tt-nummes  AS   INTEGER
    FIELD tt-numdia  AS   INTEGER
    FIELD tt-codmat  LIKE Almdmov.codmat    
    FIELD tt-mate    AS   CHARACTER          FORMAT "X(40)"
    FIELD tt-desmar  LIKE Almmmatg.DesMar    FORMAT "X(8)"
    FIELD tt-undbas  LIKE Almmmatg.UndBas    FORMAT "X(8)"
    FIELD tt-stkact  LIKE Almmmate.StkAct    FORMAT "->>>>>,>>9.99"
    FIELD tt-venta   AS DEC EXTENT 10 FORMAT "->>>>>>>9.99" 
    FIELD tt-costo   AS DEC EXTENT 10 FORMAT "->>>>>>>9.99"
    FIELD tt-canti   AS DEC EXTENT 10 FORMAT "->>>>>>>9.99" 
    FIELD tt-marge   AS DEC EXTENT 10 FORMAT "->>>>>>>9.99"
    FIELD tt-utili   AS DEC EXTENT 10 FORMAT "->>>>>>>9.99".

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
&Scoped-Define ENABLED-OBJECTS RECT-61 RECT-58 RECT-63 RECT-62 C-tipo ~
C-tipo-2 F-DIVISION BUTTON-5 F-prov1 BUTTON-4 f-Fam F-DIVISION-1 f-SubFam ~
F-DIVISION-2 F-DIVISION-3 txt-codmat F-DIVISION-4 txt-marca F-DIVISION-5 ~
DesdeF HastaF F-DIVISION-6 nCodMon Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS C-tipo C-tipo-2 F-DIVISION F-prov1 f-Fam ~
F-DIVISION-1 F-NOMDIV-1 f-SubFam F-DIVISION-2 F-NOMDIV-2 F-NOMDIV-3 ~
F-DIVISION-3 txt-codmat F-DIVISION-4 F-NOMDIV-4 txt-marca F-DIVISION-5 ~
F-NOMDIV-5 DesdeF HastaF F-DIVISION-6 F-NOMDIV-6 nCodMon txt-msj 

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

DEFINE VARIABLE C-tipo AS CHARACTER FORMAT "X(20)":U INITIAL "Mensual" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Mensual","Diario" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE C-tipo-2 AS CHARACTER FORMAT "X(20)":U INITIAL "Cantidad" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Cantidad","Venta","Costo","Margen","Utilidad" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
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

DEFINE VARIABLE f-Fam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Familia" 
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

DEFINE VARIABLE f-SubFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Sub Familia" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE txt-codmat AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE txt-marca AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 15.43 BY .69 NO-UNDO.

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
     SIZE 73.14 BY 1.58
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27.57 BY 2.54.

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44.14 BY 9.62
     BGCOLOR 3 .

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27.43 BY 5.35.

DEFINE RECTANGLE RECT-63
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27.43 BY 1.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     C-tipo AT ROW 1.88 COL 51.72 COLON-ALIGNED HELP
          "Formato de Reporte" NO-LABEL
     C-tipo-2 AT ROW 2.85 COL 51.72 COLON-ALIGNED NO-LABEL
     F-DIVISION AT ROW 3.12 COL 11.57 COLON-ALIGNED
     BUTTON-5 AT ROW 3.12 COL 25.29
     F-prov1 AT ROW 3.96 COL 11.57 COLON-ALIGNED
     BUTTON-4 AT ROW 3.96 COL 25.29
     f-Fam AT ROW 4.81 COL 11.57 COLON-ALIGNED WIDGET-ID 2
     F-DIVISION-1 AT ROW 4.92 COL 49.43 COLON-ALIGNED
     F-NOMDIV-1 AT ROW 4.96 COL 55.86 COLON-ALIGNED NO-LABEL
     f-SubFam AT ROW 5.65 COL 11.57 COLON-ALIGNED WIDGET-ID 4
     F-DIVISION-2 AT ROW 5.65 COL 49.43 COLON-ALIGNED
     F-NOMDIV-2 AT ROW 5.69 COL 55.86 COLON-ALIGNED NO-LABEL
     F-NOMDIV-3 AT ROW 6.42 COL 55.86 COLON-ALIGNED NO-LABEL
     F-DIVISION-3 AT ROW 6.46 COL 49.43 COLON-ALIGNED
     txt-codmat AT ROW 6.5 COL 11.57 COLON-ALIGNED WIDGET-ID 6
     F-DIVISION-4 AT ROW 7.15 COL 49.43 COLON-ALIGNED
     F-NOMDIV-4 AT ROW 7.15 COL 55.86 COLON-ALIGNED NO-LABEL
     txt-marca AT ROW 7.38 COL 11.57 COLON-ALIGNED WIDGET-ID 8
     F-DIVISION-5 AT ROW 7.96 COL 49.43 COLON-ALIGNED
     F-NOMDIV-5 AT ROW 7.96 COL 55.86 COLON-ALIGNED NO-LABEL
     DesdeF AT ROW 8.27 COL 11.57 COLON-ALIGNED
     HastaF AT ROW 8.27 COL 29 COLON-ALIGNED
     F-DIVISION-6 AT ROW 8.77 COL 49.43 COLON-ALIGNED
     F-NOMDIV-6 AT ROW 8.77 COL 55.86 COLON-ALIGNED NO-LABEL
     nCodMon AT ROW 10.35 COL 52.72 NO-LABEL
     Btn_OK AT ROW 11.38 COL 38
     Btn_Cancel AT ROW 11.38 COL 49.29
     Btn_Help AT ROW 11.38 COL 60.72
     txt-msj AT ROW 11.65 COL 2.72 NO-LABEL WIDGET-ID 10
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1.35 COL 4.43
          FONT 6
     "Tipo de Reporte" VIEW-AS TEXT
          SIZE 16.29 BY .65 AT ROW 1.27 COL 48.43
          FONT 6
     " Moneda" VIEW-AS TEXT
          SIZE 8.14 BY .5 AT ROW 9.77 COL 49.86
          FONT 6
     " Desplegar Divisiones" VIEW-AS TEXT
          SIZE 18.72 BY .5 AT ROW 4.27 COL 49.29
          FONT 6
     RECT-61 AT ROW 1.54 COL 1.86
     RECT-58 AT ROW 1.54 COL 47.43
     RECT-46 AT ROW 11.23 COL 1.86
     RECT-63 AT ROW 9.85 COL 47.57
     RECT-62 AT ROW 4.35 COL 47.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 75.14 BY 11.92
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
         HEIGHT             = 11.92
         WIDTH              = 75.14
         MAX-HEIGHT         = 36.27
         MAX-WIDTH          = 160.72
         VIRTUAL-HEIGHT     = 36.27
         VIRTUAL-WIDTH      = 160.72
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


&Scoped-define SELF-NAME F-DIVISION
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DIVISION W-Win
ON LEAVE OF F-DIVISION IN FRAME F-Main /* Division */
DO:
 DO WITH FRAME {&FRAME-NAME}:

 ASSIGN F-DIVISION.
 IF F-DIVISION = ""  THEN DO:
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


&Scoped-define SELF-NAME f-Fam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-Fam W-Win
ON LEAVE OF f-Fam IN FRAME F-Main /* Familia */
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


&Scoped-define SELF-NAME f-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-SubFam W-Win
ON LEAVE OF f-SubFam IN FRAME F-Main /* Sub Familia */
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


&Scoped-define SELF-NAME txt-codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-codmat W-Win
ON LEAVE OF txt-codmat IN FRAME F-Main /* Articulo */
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
         DesdeF 
         HastaF 
         nCodMon
         C-tipo-2 
         F-Prov1
         F-Fam
         f-SubFam
         txt-codmat
         txt-marca.
  
    
  S-SUBTIT =   "PERIODO      : " + STRING(DesdeF,"99/99/9999") + " al " + STRING(HastaF,"99/99/9999").

  X-MONEDA =   "MONEDA       : " + IF NCODMON = 1 THEN "NUEVOS SOLES " ELSE "DOLARES AMERICANOS ".  

  IF DesdeF = ?  THEN DesdeF = 01/01/1900.
  IF HastaF = ?  THEN HastaF = 01/01/3000.

  IF F-DIVISION = "" THEN DO:
    X-CODDIV = "".
    FOR EACH Gn-Divi NO-LOCK WHERE Gn-Divi.Codcia = S-CODCIA:
       /* X-CODDIV = X-CODDIV + SUBSTRING(Gn-Divi.Desdiv,1,10) + "," .*/
        X-CODDIV = X-CODDIV + Gn-Divi.Coddiv + "," .
    END.
  END.
  ELSE DO:
   FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                      Gn-Divi.Coddiv = F-DIVISION NO-LOCK NO-ERROR.
  /* X-CODDIV = SUBSTRING(Gn-Divi.Desdiv,1,20) + "," .*/
   X-CODDIV = Gn-Divi.Coddiv + "," .
  END.
  
  
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Diario W-Win 
PROCEDURE Carga-Diario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*******Inicializa la Tabla Temporal ******/
FOR EACH tmp-tempo :
  DELETE tmp-tempo.
END.
/********************************/

FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
                   AND Gn-Divi.CodDiv BEGINS F-DIVISION:

FOR EACH EvtProv NO-LOCK WHERE EvtProv.CodCia = S-CODCIA
                         AND   EvtProv.CodDiv = Gn-Divi.Coddiv
                         AND   EvtProv.CodProv BEGINS F-Prov1
                         AND   (EvtProv.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
                         AND   EvtProv.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) ):
                         
      /*
      DISPLAY EvtProv.Coddiv @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */
      T-Vtamn   = 0.
      T-Vtame   = 0.
      T-Ctomn   = 0.
      T-Ctome   = 0.
      /*****************Capturando el Mes siguiente *******************/
      IF EvtProv.Codmes < 12 THEN DO:
        ASSIGN
        X-CODMES = EvtProv.Codmes + 1
        X-CODANO = EvtProv.Codano .
      END.
      ELSE DO: 
        ASSIGN
        X-CODMES = 01
        X-CODANO = EvtProv.Codano + 1 .
      END.
      /**********************************************************************/
      
      /*********************** Calculo Para Obtener los datos diarios ************/
       DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :
              
            X-FECHA = DATE(STRING(I,"99") + "/" + STRING(EvtProv.Codmes,"99") + "/" + STRING(EvtProv.Codano,"9999")).
            IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
                FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(EvtProv.Codmes,"99") + "/" + STRING(EvtProv.Codano,"9999")) NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN DO: 
                    T-Vtamn   = EvtProv.Vtaxdiamn[I] + EvtProv.Vtaxdiame[I] * Gn-Tcmb.Venta.
                    T-Vtame   = EvtProv.Vtaxdiame[I] + EvtProv.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                    T-Ctomn   = EvtProv.Ctoxdiamn[I] + EvtProv.Ctoxdiame[I] * Gn-Tcmb.Venta.
                    T-Ctome   = EvtProv.Ctoxdiame[I] + EvtProv.Ctoxdiamn[I] / Gn-Tcmb.Compra.
                    FIND tmp-tempo WHERE T-Codcia  = S-CODCIA AND
                                         T-CodProv  = EvtProv.CodProv AND
                                         T-Codano  = EvtProv.Codano AND
                                         T-Codmes  = EvtProv.Codmes AND
                                         T-Coddia  = I NO-ERROR.
                    IF NOT AVAIL tmp-tempo THEN DO:
                      CREATE tmp-tempo.
                      ASSIGN T-codcia  = S-CODCIA
                             T-CodProv  = EvtProv.CodProv
                             T-Codano  = EvtProv.Codano 
                             T-Codmes  = EvtProv.Codmes
                             T-Coddia  = I 
                             T-Fchdoc  = X-FECHA.                         
                    END.
                    ASSIGN T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                           T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )             
                           T-Marge[10] = T-Marge[10] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome )
                           T-Utili[10] = T-Utili[10] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).

                    /******************************Secuencia Para Cargar Datos en las Columnas *****************/
                    
                    X-ENTRA = FALSE.
                    IF F-DIVISION-1 <> "" AND EvtProv.Coddiv = F-DIVISION-1 THEN DO:
                       ASSIGN T-Venta[1] = T-venta[1] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                              T-Costo[1] = T-Costo[1] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )
                              T-Marge[1] = T-Marge[1] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome )
                              T-Utili[1] = T-Utili[1] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                              X-ENTRA = TRUE.
                    END.       
                    IF F-DIVISION-2 <> "" AND EvtProv.Coddiv = F-DIVISION-2 THEN DO:
                       ASSIGN T-Venta[2] = T-venta[2] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                              T-Costo[2] = T-Costo[2] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )
                              T-Marge[2] = T-Marge[2] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome )
                              T-Utili[2] = T-Utili[2] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                              X-ENTRA = TRUE.
                    END.       
                    IF F-DIVISION-3 <> "" AND EvtProv.Coddiv = F-DIVISION-3 THEN DO:
                       ASSIGN T-Venta[3] = T-venta[3] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                              T-Costo[3] = T-Costo[3] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )
                              T-Marge[3] = T-Marge[3] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome )
                              T-Utili[3] = T-Utili[3] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                              X-ENTRA = TRUE.
                    END.       
                    IF F-DIVISION-4 <> "" AND EvtProv.Coddiv = F-DIVISION-4 THEN DO:
                       ASSIGN T-Venta[4] = T-venta[4] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                              T-Costo[4] = T-Costo[4] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )
                              T-Marge[4] = T-Marge[4] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome )
                              T-Utili[4] = T-Utili[4] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                              X-ENTRA = TRUE.
                    END.       
                    IF F-DIVISION-5 <> "" AND EvtProv.Coddiv = F-DIVISION-5 THEN DO:
                       ASSIGN T-Venta[5] = T-venta[5] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                              T-Costo[5] = T-Costo[5] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )
                              T-Marge[5] = T-Marge[5] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome )
                              T-Utili[5] = T-Utili[5] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                              X-ENTRA = TRUE.
                    END.       
                    IF F-DIVISION-6 <> "" AND EvtProv.Coddiv = F-DIVISION-6 THEN DO:
                       ASSIGN T-Venta[6] = T-venta[6] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                              T-Costo[6] = T-Costo[6] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )
                              T-Marge[6] = T-Marge[6] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome )
                              T-Utili[6] = T-Utili[6] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                              X-ENTRA = TRUE.     
                    END.       
                    IF NOT X-ENTRA THEN DO:
                       ASSIGN T-Venta[7] = T-venta[7] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                              T-Costo[7] = T-Costo[7] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )
                              T-Marge[7] = T-Marge[7] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome )
                              T-Utili[7] = T-Utili[7] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                              X-ENTRA = TRUE. 
                     END.
                    
                    /**************************************************************************/

                END.
            END.
       END.
   
END.
END.
/*
HIDE FRAME F-PROCESO.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Diario1 W-Win 
PROCEDURE Carga-Diario1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iDiaUno AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iDiaDos AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE j       AS INTEGER     NO-UNDO.

    FOR EACH tmp-tempo :
        DELETE tmp-tempo.
    END.
    /*Busca Divisiones*/
    FOR EACH gn-divi WHERE gn-divi.CodCia = s-CodCia
        AND gn-divi.CodDiv BEGINS f-division NO-LOCK:
        FOR EACH evtall01 NO-LOCK USE-INDEX Indice02
            WHERE evtall01.CodCia = s-CodCia
            AND evtall01.CodDiv = gn-divi.CodDiv
            AND evtall01.CodPro BEGINS F-Prov1
            AND (evtall01.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
            AND evtall01.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")))
            AND evtall01.CodFam BEGINS f-Fam
            AND evtall01.SubFam BEGINS f-SubFam
            AND evtall01.CodMat BEGINS txt-codmat
            AND evtall01.DesMar BEGINS txt-marca:            
            /*
            DISPLAY evtall01.Coddiv @ Fi-Mensaje LABEL "Codigo de Articulo "
                FORMAT "X(11)" WITH FRAME F-Proceso.
            */
            IF (YEAR(DesdeF) = YEAR(HastaF)) AND (MONTH(DesdeF) = MONTH(HastaF)) THEN DO:
                iDiaUno = DAY(DesdeF).
                iDiaDos = DAY(HastaF).
            END.
            ELSE DO:
                IF evtall01.NroFch = (YEAR(DesdeF) * 100 + MONTH(DesdeF)) THEN DO: 
                    iDiaUno = DAY(DesdeF).
                    iDiaDos = 31.
                END.
                ELSE IF evtall01.NroFch = (YEAR(HastaF) * 100 + MONTH(HastaF)) THEN DO:
                    iDiaUno = 1.
                    iDiaDos = DAY(HastaF).
                END.
                ELSE DO:
                    iDiaUno = 1.
                    iDiaDos = 31.
                END.
            END.
            
            DO i = iDiaUno TO iDiaDos:
                X-FECHA = DATE(STRING(I,"99") + "/" + STRING(evtall01.Codmes,"99") + "/" + STRING(evtall01.Codano,"9999")).
                FIND FIRST tmp-tempo WHERE t-codcia = evtall01.codcia
                    AND t-codprov = evtall01.codpro
                    AND t-codano  = evtall01.codano
                    AND t-codmes  = evtall01.codmes
                    AND t-coddia  = i 
                    AND t-fchdoc  = x-fecha NO-LOCK NO-ERROR.
                IF NOT AVAILABLE tmp-tempo THEN DO:                       
                    CREATE tmp-tempo.
                    ASSIGN
                        t-codcia  =  evtall01.codcia
                        t-codpro  =  evtall01.codpro
                        t-codano  =  evtall01.codano
                        t-codmes  =  evtall01.codmes
                        t-coddia  =  i
                        t-fchdoc  =  X-FECHA.
                END.
            END.

            DO j = iDiaUno TO iDiaDos:
                FIND FIRST tmp-tempo WHERE t-codcia = s-codcia
                    AND t-codpro = evtall01.codpro
                    AND t-codano = evtall01.codano
                    AND t-codmes = evtall01.codmes 
                    AND t-coddia = j NO-ERROR.
                IF AVAILABLE tmp-tempo THEN DO:
                    /*********Secuencia para cargar datos totales**********/
                    ASSIGN 
                        T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] ELSE evtall01.vtaxdiame[j] )
                        T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN evtall01.ctoxdiamn[j] ELSE evtall01.ctoxdiame[j] )
                        T-Marge[10] = T-Marge[10] + ( IF ncodmon = 1 THEN (evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j]) / evtall01.ctoxdiamn[j]  ELSE (evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j]) / evtall01.ctoxdiame[j] )
                        T-Utili[10] = T-Utili[10] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j] ELSE evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j] ).
                    /******************************Secuencia Para Cargar Datos en las Columnas *****************/                    
                    X-ENTRA = FALSE.
                    IF F-DIVISION-1 <> "" AND evtall01.Coddiv = F-DIVISION-1 THEN DO:
                       ASSIGN t-Venta[1] = t-venta[1] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] ELSE evtall01.vtaxdiame[j] )
                              t-Costo[1] = t-Costo[1] + ( IF ncodmon = 1 THEN evtall01.ctoxdiamn[j] ELSE evtall01.ctoxdiame[j] )
                              t-Marge[1] = t-Marge[1] + ( IF ncodmon = 1 THEN (evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j]) / evtall01.ctoxdiamn[j]  ELSE (evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j]) / evtall01.ctoxdiame[j] )
                              t-Utili[1] = t-Utili[1] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j] ELSE evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j] ).
                              X-ENTRA = TRUE.
                    END.       
                    IF F-DIVISION-2 <> "" AND evtall01.Coddiv = F-DIVISION-2 THEN DO:
                       ASSIGN t-Venta[2] = t-venta[2] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] ELSE evtall01.vtaxdiame[j] )
                              t-Costo[2] = t-Costo[2] + ( IF ncodmon = 1 THEN evtall01.ctoxdiamn[j] ELSE evtall01.ctoxdiame[j] )
                              t-Marge[2] = t-Marge[2] + ( IF ncodmon = 1 THEN (evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j]) / evtall01.ctoxdiamn[j]  ELSE (evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j]) / evtall01.ctoxdiame[j] )
                              t-Utili[2] = t-Utili[2] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j] ELSE evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j] ).
                              X-ENTRA = TRUE.
                    END.       
                    IF F-DIVISION-3 <> "" AND evtall01.Coddiv = F-DIVISION-3 THEN DO:
                       ASSIGN t-Venta[3] = t-venta[3] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] ELSE evtall01.vtaxdiame[j] )
                              t-Costo[3] = t-Costo[3] + ( IF ncodmon = 1 THEN evtall01.ctoxdiamn[j] ELSE evtall01.ctoxdiame[j] )
                              t-Marge[3] = t-Marge[3] + ( IF ncodmon = 1 THEN (evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j]) / evtall01.ctoxdiamn[j]  ELSE (evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j]) / evtall01.ctoxdiame[j] )
                              t-Utili[3] = t-Utili[3] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j] ELSE evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j] ).
                              X-ENTRA = TRUE.
                    END.       
                    IF F-DIVISION-4 <> "" AND evtall01.Coddiv = F-DIVISION-4 THEN DO:
                       ASSIGN t-Venta[4] = t-venta[4] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] ELSE evtall01.vtaxdiame[j] )
                              t-Costo[4] = t-Costo[4] + ( IF ncodmon = 1 THEN evtall01.ctoxdiamn[j] ELSE evtall01.ctoxdiame[j] )
                              t-Marge[4] = t-Marge[4] + ( IF ncodmon = 1 THEN (evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j]) / evtall01.ctoxdiamn[j]  ELSE (evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j]) / evtall01.ctoxdiame[j] )
                              t-Utili[4] = t-Utili[4] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j] ELSE evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j] ).
                              X-ENTRA = TRUE.
                    END.       
                    IF F-DIVISION-5 <> "" AND evtall01.Coddiv = F-DIVISION-5 THEN DO:
                       ASSIGN t-Venta[5] = t-venta[5] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] ELSE evtall01.vtaxdiame[j] )
                              t-Costo[5] = t-Costo[5] + ( IF ncodmon = 1 THEN evtall01.ctoxdiamn[j] ELSE evtall01.ctoxdiame[j] )
                              t-Marge[5] = t-Marge[5] + ( IF ncodmon = 1 THEN (evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j]) / evtall01.ctoxdiamn[j]  ELSE (evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j]) / evtall01.ctoxdiame[j] )
                              t-Utili[5] = t-Utili[5] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j] ELSE evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j] ).
                              X-ENTRA = TRUE.
                    END.       
                    IF F-DIVISION-6 <> "" AND evtall01.Coddiv = F-DIVISION-6 THEN DO:
                       ASSIGN t-Venta[6] = t-venta[6] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] ELSE evtall01.vtaxdiame[j] )
                              t-Costo[6] = t-Costo[6] + ( IF ncodmon = 1 THEN evtall01.ctoxdiamn[j] ELSE evtall01.ctoxdiame[j] )
                              t-Marge[6] = t-Marge[6] + ( IF ncodmon = 1 THEN (evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j]) / evtall01.ctoxdiamn[j]  ELSE (evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j]) / evtall01.ctoxdiame[j] )
                              t-Utili[6] = t-Utili[6] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j] ELSE evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j] ).
                              X-ENTRA = TRUE.     
                    END.       
                    IF NOT X-ENTRA THEN DO:
                       ASSIGN t-Venta[7] = t-venta[7] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] ELSE evtall01.vtaxdiame[j] )
                              t-Costo[7] = t-Costo[7] + ( IF ncodmon = 1 THEN evtall01.ctoxdiamn[j] ELSE evtall01.ctoxdiame[j] )
                              t-Marge[7] = t-Marge[7] + ( IF ncodmon = 1 THEN (evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j]) / evtall01.ctoxdiamn[j]  ELSE (evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j]) / evtall01.ctoxdiame[j] )
                              t-Utili[7] = t-Utili[7] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j] ELSE evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j] ).
                              X-ENTRA = TRUE. 
                     END.
                    
                    /**************************************************************************/
                END.
            END.
        END. /*for each evtall01*/
    END. /*for each gn-divi...*/
    /*
    HIDE FRAME F-Proceso.
    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Mensual W-Win 
PROCEDURE Carga-Mensual :
/*
------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*******Inicializa la Tabla Temporal ******/
FOR EACH tmp-tempo :
  DELETE tmp-tempo.
END.
/********************************/ 

FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
                   AND Gn-Divi.CodDiv BEGINS F-DIVISION:

FOR EACH EvtProv NO-LOCK WHERE EvtProv.CodCia = S-CODCIA
                         AND   EvtProv.CodDiv = Gn-Divi.Coddiv
                         AND   EvtProv.CodProv BEGINS F-Prov1
                         AND   (EvtProv.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
                         AND   EvtProv.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) ):

      /*
      DISPLAY EvtProv.Coddiv @ Fi-Mensaje LABEL "Division"
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */
      T-Vtamn   = 0.
      T-Vtame   = 0.
      T-Ctomn   = 0.
      T-Ctome   = 0.
      /*****************Capturando el Mes siguiente *******************/
      IF EvtProv.Codmes < 12 THEN DO:
        ASSIGN
        X-CODMES = EvtProv.Codmes + 1
        X-CODANO = EvtProv.Codano .
      END.
      ELSE DO: 
        ASSIGN
        X-CODMES = 01
        X-CODANO = EvtProv.Codano + 1 .
      END.
      /**********************************************************************/
      
      /*********************** Calculo Para Obtener los datos diarios ************/
       DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        

            X-FECHA = DATE(STRING(I,"99") + "/" + STRING(EvtProv.Codmes,"99") + "/" + STRING(EvtProv.Codano,"9999")).
            IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
                FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(EvtProv.Codmes,"99") + "/" + STRING(EvtProv.Codano,"9999")) NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN DO: 
                 T-Vtamn   = T-Vtamn   + EvtProv.Vtaxdiamn[I] + EvtProv.Vtaxdiame[I] * Gn-Tcmb.Venta.
                 T-Vtame   = T-Vtame   + EvtProv.Vtaxdiame[I] + EvtProv.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                 T-Ctomn   = T-Ctomn   + EvtProv.Ctoxdiamn[I] + EvtProv.Ctoxdiame[I] * Gn-Tcmb.Venta.
                 T-Ctome   = T-Ctome   + EvtProv.Ctoxdiame[I] + EvtProv.Ctoxdiamn[I] / Gn-Tcmb.Compra.
                END.
            END.
       END.         
      
      /******************************************************************************/      

      FIND tmp-tempo WHERE t-codcia  = S-CODCIA AND
                           T-CodProv  = EvtProv.CodProv AND
                           T-Codano  = EvtProv.Codano AND
                           T-Codmes  = EvtProv.Codmes NO-ERROR.
      IF NOT AVAIL tmp-tempo THEN DO:
        CREATE tmp-tempo.
        ASSIGN t-codcia  = S-CODCIA
               T-CodProv  = EvtProv.CodProv
               T-Codano  = EvtProv.Codano 
               T-Codmes  = EvtProv.Codmes .
      END.
      ASSIGN T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
             T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )
             T-Marge[10] = T-Marge[10] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome )
             T-Utili[10] = T-Utili[10] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
      
      /******************************Secuencia Para Cargar Datos en las Columnas *****************/
      
      X-ENTRA = FALSE.
      IF F-DIVISION-1 <> "" AND EvtProv.Coddiv = F-DIVISION-1 THEN DO:
         ASSIGN T-Venta[1] = T-venta[1] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[1] = T-Costo[1] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )
                T-Marge[1] = T-Marge[1] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome )
                T-Utili[1] = T-Utili[1] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-2 <> "" AND EvtProv.Coddiv = F-DIVISION-2 THEN DO:
         ASSIGN T-Venta[2] = T-venta[2] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[2] = T-Costo[2] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )
                T-Marge[2] = T-Marge[2] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome )
                T-Utili[2] = T-Utili[2] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-3 <> "" AND EvtProv.Coddiv = F-DIVISION-3 THEN DO:
         ASSIGN T-Venta[3] = T-venta[3] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[3] = T-Costo[3] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )      
                T-Marge[3] = T-Marge[3] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome )
                T-Utili[3] = T-Utili[3] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-4 <> "" AND EvtProv.Coddiv = F-DIVISION-4 THEN DO:
         ASSIGN T-Venta[4] = T-venta[4] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[4] = T-Costo[4] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )      
                T-Marge[4] = T-Marge[4] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome )
                T-Utili[4] = T-Utili[4] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-5 <> "" AND EvtProv.Coddiv = F-DIVISION-5 THEN DO:
         ASSIGN T-Venta[5] = T-venta[5] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[5] = T-Costo[5] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )      
                T-Marge[5] = T-Marge[5] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome )
                T-Utili[5] = T-Utili[5] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-6 <> "" AND EvtProv.Coddiv = F-DIVISION-6 THEN DO:
         ASSIGN T-Venta[6] = T-venta[6] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[6] = T-Costo[6] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )
                T-Marge[6] = T-Marge[6] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome )
                T-Utili[6] = T-Utili[6] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.     
      END.       
      IF NOT X-ENTRA THEN DO:
         ASSIGN T-Venta[7] = T-venta[7] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[7] = T-Costo[7] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )
                T-Marge[7] = T-Marge[7] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome )
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Mensual1 W-Win 
PROCEDURE Carga-Mensual1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iDiaUno AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iDiaDos AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE j       AS INTEGER     NO-UNDO.

    FOR EACH tmp-tempo :
        DELETE tmp-tempo.
    END.
    /*Busca Divisiones*/
    FOR EACH gn-divi WHERE gn-divi.CodCia = s-CodCia
        AND gn-divi.CodDiv BEGINS f-division NO-LOCK:
        FOR EACH evtall01 NO-LOCK USE-INDEX Indice02
            WHERE evtall01.CodCia = s-CodCia
            AND evtall01.CodDiv = gn-divi.CodDiv
            AND evtall01.CodPro BEGINS F-Prov1
            AND (evtall01.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
            AND evtall01.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")))
            AND evtall01.CodFam BEGINS f-Fam
            AND evtall01.SubFam BEGINS f-SubFam
            AND evtall01.CodMat BEGINS txt-codmat
            AND evtall01.DesMar BEGINS txt-marca:            
            /*
            DISPLAY evtall01.Coddiv @ Fi-Mensaje LABEL "Codigo de Articulo "
                FORMAT "X(11)" WITH FRAME F-Proceso.
            */
            IF (YEAR(DesdeF) = YEAR(HastaF)) AND (MONTH(DesdeF) = MONTH(HastaF)) THEN DO:
                iDiaUno = DAY(DesdeF).
                iDiaDos = DAY(HastaF).
            END.
            ELSE DO:
                IF evtall01.NroFch = (YEAR(DesdeF) * 100 + MONTH(DesdeF)) THEN DO:
                    iDiaUno = DAY(DesdeF).
                    iDiaDos = 31.
                END.
                ELSE IF evtall01.NroFch = (YEAR(HastaF) * 100 + MONTH(HastaF)) THEN DO:
                    iDiaUno = 1.
                    iDiaDos = DAY(HastaF).
                END.
                ELSE DO:
                    iDiaUno = 1.
                    iDiaDos = 31.
                END.
            END.

            FIND FIRST tmp-tempo WHERE t-codcia = evtall01.codcia
                AND t-codprov = evtall01.codpro
                AND t-codano  = evtall01.codano
                AND t-codmes  = evtall01.codmes NO-LOCK NO-ERROR.
            IF NOT AVAILABLE tmp-tempo THEN DO:
                CREATE tmp-tempo.
                ASSIGN
                    t-codcia  =  evtall01.codcia
                    t-codpro  =  evtall01.codpro
                    t-codano  =  evtall01.codano
                    t-codmes  =  evtall01.codmes.
            END.

            DO j = iDiaUno TO iDiaDos:
                FIND FIRST tmp-tempo WHERE t-codcia = s-codcia
                    AND t-codpro = evtall01.codpro
                    AND t-codano = evtall01.codano
                    AND t-codmes = evtall01.codmes NO-ERROR.
                IF AVAILABLE tmp-tempo THEN DO:
                    /*********Secuencia para cargar datos totales**********/
                    ASSIGN 
                        T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] ELSE evtall01.vtaxdiame[j] )
                        T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN evtall01.ctoxdiamn[j] ELSE evtall01.ctoxdiame[j] )
                        T-Marge[10] = T-Marge[10] + ( IF ncodmon = 1 THEN (evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j]) / evtall01.ctoxdiamn[j]  ELSE (evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j]) / evtall01.ctoxdiame[j] )
                        T-Utili[10] = T-Utili[10] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j] ELSE evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j] ).
                    /******************************Secuencia Para Cargar Datos en las Columnas *****************/                    
                    X-ENTRA = FALSE.
                    IF F-DIVISION-1 <> "" AND evtall01.Coddiv = F-DIVISION-1 THEN DO:  
                       ASSIGN t-Venta[1] = t-venta[1] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] ELSE evtall01.vtaxdiame[j] )
                              t-Costo[1] = t-Costo[1] + ( IF ncodmon = 1 THEN evtall01.ctoxdiamn[j] ELSE evtall01.ctoxdiame[j] )
                              t-Marge[1] = t-Marge[1] + ( IF ncodmon = 1 THEN (evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j]) / evtall01.ctoxdiamn[j]  ELSE (evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j]) / evtall01.ctoxdiame[j] )
                              t-Utili[1] = t-Utili[1] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j] ELSE evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j] ).
                              X-ENTRA = TRUE.
                    END.       
                    IF F-DIVISION-2 <> "" AND evtall01.Coddiv = F-DIVISION-2 THEN DO:
                       ASSIGN t-Venta[2] = t-venta[2] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] ELSE evtall01.vtaxdiame[j] )
                              t-Costo[2] = t-Costo[2] + ( IF ncodmon = 1 THEN evtall01.ctoxdiamn[j] ELSE evtall01.ctoxdiame[j] )
                              t-Marge[2] = t-Marge[2] + ( IF ncodmon = 1 THEN (evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j]) / evtall01.ctoxdiamn[j]  ELSE (evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j]) / evtall01.ctoxdiame[j] )
                              t-Utili[2] = t-Utili[2] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j] ELSE evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j] ).
                              X-ENTRA = TRUE.
                    END.       
                    IF F-DIVISION-3 <> "" AND evtall01.Coddiv = F-DIVISION-3 THEN DO:
                       ASSIGN t-Venta[3] = t-venta[3] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] ELSE evtall01.vtaxdiame[j] )
                              t-Costo[3] = t-Costo[3] + ( IF ncodmon = 1 THEN evtall01.ctoxdiamn[j] ELSE evtall01.ctoxdiame[j] )
                              t-Marge[3] = t-Marge[3] + ( IF ncodmon = 1 THEN (evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j]) / evtall01.ctoxdiamn[j]  ELSE (evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j]) / evtall01.ctoxdiame[j] )
                              t-Utili[3] = t-Utili[3] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j] ELSE evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j] ).
                              X-ENTRA = TRUE.
                    END.       
                    IF F-DIVISION-4 <> "" AND evtall01.Coddiv = F-DIVISION-4 THEN DO:
                       ASSIGN t-Venta[4] = t-venta[4] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] ELSE evtall01.vtaxdiame[j] )
                              t-Costo[4] = t-Costo[4] + ( IF ncodmon = 1 THEN evtall01.ctoxdiamn[j] ELSE evtall01.ctoxdiame[j] )
                              t-Marge[4] = t-Marge[4] + ( IF ncodmon = 1 THEN (evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j]) / evtall01.ctoxdiamn[j]  ELSE (evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j]) / evtall01.ctoxdiame[j] )
                              t-Utili[4] = t-Utili[4] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j] ELSE evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j] ).
                              X-ENTRA = TRUE.
                    END.       
                    IF F-DIVISION-5 <> "" AND evtall01.Coddiv = F-DIVISION-5 THEN DO:
                       ASSIGN t-Venta[5] = t-venta[5] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] ELSE evtall01.vtaxdiame[j] )
                              t-Costo[5] = t-Costo[5] + ( IF ncodmon = 1 THEN evtall01.ctoxdiamn[j] ELSE evtall01.ctoxdiame[j] )
                              t-Marge[5] = t-Marge[5] + ( IF ncodmon = 1 THEN (evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j]) / evtall01.ctoxdiamn[j]  ELSE (evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j]) / evtall01.ctoxdiame[j] )
                              t-Utili[5] = t-Utili[5] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j] ELSE evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j] ).
                              X-ENTRA = TRUE.
                    END.       
                    IF F-DIVISION-6 <> "" AND evtall01.Coddiv = F-DIVISION-6 THEN DO:
                       ASSIGN t-Venta[6] = t-venta[6] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] ELSE evtall01.vtaxdiame[j] )
                              t-Costo[6] = t-Costo[6] + ( IF ncodmon = 1 THEN evtall01.ctoxdiamn[j] ELSE evtall01.ctoxdiame[j] )
                              t-Marge[6] = t-Marge[6] + ( IF ncodmon = 1 THEN (evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j]) / evtall01.ctoxdiamn[j]  ELSE (evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j]) / evtall01.ctoxdiame[j] )
                              t-Utili[6] = t-Utili[6] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j] ELSE evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j] ).
                              X-ENTRA = TRUE.     
                    END.       
                    IF NOT X-ENTRA THEN DO:
                       ASSIGN t-Venta[7] = t-venta[7] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] ELSE evtall01.vtaxdiame[j] )
                              t-Costo[7] = t-Costo[7] + ( IF ncodmon = 1 THEN evtall01.ctoxdiamn[j] ELSE evtall01.ctoxdiame[j] )
                              t-Marge[7] = t-Marge[7] + ( IF ncodmon = 1 THEN (evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j]) / evtall01.ctoxdiamn[j]  ELSE (evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j]) / evtall01.ctoxdiame[j] )
                              t-Utili[7] = t-Utili[7] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[j] - evtall01.ctoxdiamn[j] ELSE evtall01.vtaxdiame[j] - evtall01.ctoxdiame[j] ).
                              X-ENTRA = TRUE. 
                     END.                    
                    /**************************************************************************/
                END.
            END.
        END. /*for each evtall01*/
    END. /*for each gn-divi...*/
    /*
    HIDE FRAME F-Proceso.
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
  DISPLAY C-tipo C-tipo-2 F-DIVISION F-prov1 f-Fam F-DIVISION-1 F-NOMDIV-1 
          f-SubFam F-DIVISION-2 F-NOMDIV-2 F-NOMDIV-3 F-DIVISION-3 txt-codmat 
          F-DIVISION-4 F-NOMDIV-4 txt-marca F-DIVISION-5 F-NOMDIV-5 DesdeF 
          HastaF F-DIVISION-6 F-NOMDIV-6 nCodMon txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-61 RECT-58 RECT-63 RECT-62 C-tipo C-tipo-2 F-DIVISION BUTTON-5 
         F-prov1 BUTTON-4 f-Fam F-DIVISION-1 f-SubFam F-DIVISION-2 F-DIVISION-3 
         txt-codmat F-DIVISION-4 txt-marca F-DIVISION-5 DesdeF HastaF 
         F-DIVISION-6 nCodMon Btn_OK Btn_Cancel Btn_Help 
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
/* OUTPUT TO "D:\provvta0.txt". */
/*     FOR EACH tmp-temporal.   */
/*         DISPLAY              */
/*             tt-codcia        */
/*             tt-coddiv        */
/*             tt-codpro        */
/*             tt-codfam        */
/*             tt-subfam        */
/*             tt-codmat        */
/*             tt-numano        */
/*             tt-nummes        */
/*             tt-numdia        */
/*             tt-mate          */
/*             tt-venta[1]      */
/*             tt-venta[2]      */
/*             tt-venta[3]      */
/*             tt-venta[4]      */
/*             tt-venta[5]      */
/*             tt-venta[6]      */
/*             tt-venta[7]      */
/*              WITH WIDTH 300. */
/*     END.                     */
/* OUTPUT TO CLOSE.             */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FormatoDA W-Win 
PROCEDURE FormatoDA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FormatoDB W-Win 
PROCEDURE FormatoDB :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-fchdoc        AT 5
         t-venta[1]  FORMAT "->>,>>>,>>>,>>9" AT 25
         t-venta[2]  FORMAT "->>,>>>,>>>,>>9"
         t-venta[3]  FORMAT "->>,>>>,>>>,>>9"
         t-venta[4]  FORMAT "->>,>>>,>>>,>>9"
         t-venta[5]  FORMAT "->>,>>>,>>>,>>9"
         t-venta[6]  FORMAT "->>,>>>,>>>,>>9"
         t-venta[7]  FORMAT "->>,>>>,>>>,>>9"
         t-venta[10] FORMAT "->>,>>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU  AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")"  AT 100 FORMAT "X(25)" SKIP(1)
         "Pagina : " TO 130 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         X-MONEDA AT 1  FORMAT "X(60)" 
         "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         "DIVISIONES EVALUADAS  : " + X-CODDIV   At 1 FORMAT "X(150)" SKIP
         "LOS IMPORTE INCLUYEN I.G.V. "  At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 FORMAT "X(15)" AT  30 
        F-DIVISION-2 FORMAT "X(15)" AT  45 
        F-DIVISION-3 FORMAT "X(15)" AT  60 
        F-DIVISION-4 FORMAT "X(15)" AT  75 
        F-DIVISION-5 FORMAT "X(15)" AT  90
        F-DIVISION-6 FORMAT "X(15)" AT  105
        "O T R O S"  AT  120
        "T O T A L"  AT  140 SKIP
        "    FECHA                     Venta           Venta          Venta          Venta           Venta          Venta           Venta             Venta    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  /*WHERE t-venta[10] <> 0 */
                     BREAK BY T-Codcia
                           BY T-CodProv
                           BY T-Codano
                           BY T-Codmes
                           BY T-Coddia:


      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-CodProv) THEN DO:
         FIND Gn-Prov WHERE Gn-prov.Codcia = pv-codcia AND
                            Gn-prov.CodPro = T-CodProv
                            NO-LOCK NO-ERROR.
                      
         PUT STREAM REPORT T-CodProv AT 1 .
         IF AVAILABLE Gn-Prov THEN DO:
            PUT STREAM REPORT Gn-Prov.NomPro AT 12 FORMAT "X(45)" SKIP.
         END.
         
      END.

      IF FIRST-OF(t-codano) THEN DO:
        PUT STREAM REPORT  ("PERIODO  : " + STRING(T-Codano,"9999") ) FORMAT "X(30)" SKIP.
      END.

      IF FIRST-OF(t-codmes) THEN DO:
        PUT STREAM REPORT ENTRY(T-codmes,X-NOMMES) FORMAT "X(20)" AT 5 SKIP.    
      END.

      ACCUM  t-venta[1]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-venta[2]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-venta[3]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-venta[4]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-venta[5]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-venta[6]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-venta[7]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-venta[10] ( SUB-TOTAL BY T-CodProv) .

      ACCUM  t-venta[1]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-venta[2]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-venta[3]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-venta[4]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-venta[5]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-venta[6]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-venta[7]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-venta[10] ( SUB-TOTAL BY T-Codmes) .

      ACCUM  t-venta[1]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-venta[2]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-venta[3]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-venta[4]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-venta[5]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-venta[6]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-venta[7]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-venta[10] ( SUB-TOTAL BY T-CodAno) .

      ACCUM  t-venta[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[10] ( TOTAL BY t-codcia) .

      DISPLAY STREAM REPORT 
                t-fchdoc
                t-venta[1] WHEN  t-venta[1] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-venta[2] WHEN  t-venta[2] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-venta[3] WHEN  t-venta[3] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-venta[4] WHEN  t-venta[4] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-venta[5] WHEN  t-venta[5] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-venta[6] WHEN  t-venta[6] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-venta[7] WHEN  t-venta[7] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-venta[10]  FORMAT "->>,>>>,>>>,>>9"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-codmes) THEN DO:
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
            ("TOTAL : " + STRING(T-Codmes,"99") ) @ t-fchdoc
            (ACCUM SUB-TOTAL BY t-codmes t-venta[1]) @ t-venta[1]
            (ACCUM SUB-TOTAL BY t-codmes t-venta[2]) @ t-venta[2]
            (ACCUM SUB-TOTAL BY t-codmes t-venta[3]) @ t-venta[3]
            (ACCUM SUB-TOTAL BY t-codmes t-venta[4]) @ t-venta[4]
            (ACCUM SUB-TOTAL BY t-codmes t-venta[5]) @ t-venta[5]
            (ACCUM SUB-TOTAL BY t-codmes t-venta[6]) @ t-venta[6]
            (ACCUM SUB-TOTAL BY t-codmes t-venta[7]) @ t-venta[7]
            (ACCUM SUB-TOTAL BY t-codmes t-venta[10]) @ t-venta[10]
            WITH FRAME F-REPORTE.
        
      END.

      IF LAST-OF(t-codano) THEN DO:
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
            ("TOTAL : " + STRING(T-Codano,"9999") ) @ t-fchdoc
            (ACCUM SUB-TOTAL BY t-codano t-venta[1]) @ t-venta[1]
            (ACCUM SUB-TOTAL BY t-codano t-venta[2]) @ t-venta[2]
            (ACCUM SUB-TOTAL BY t-codano t-venta[3]) @ t-venta[3]
            (ACCUM SUB-TOTAL BY t-codano t-venta[4]) @ t-venta[4]
            (ACCUM SUB-TOTAL BY t-codano t-venta[5]) @ t-venta[5]
            (ACCUM SUB-TOTAL BY t-codano t-venta[6]) @ t-venta[6]
            (ACCUM SUB-TOTAL BY t-codano t-venta[7]) @ t-venta[7]
            (ACCUM SUB-TOTAL BY t-codano t-venta[10]) @ t-venta[10]
            WITH FRAME F-REPORTE.
      END.

      IF LAST-OF(t-CodProv) THEN DO:
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
            ("TOTAL : " + STRING(T-CodProv,"999") ) @ t-fchdoc
            (ACCUM SUB-TOTAL BY t-CodProv t-venta[1]) @ t-venta[1]
            (ACCUM SUB-TOTAL BY t-CodProv t-venta[2]) @ t-venta[2]
            (ACCUM SUB-TOTAL BY t-CodProv t-venta[3]) @ t-venta[3]
            (ACCUM SUB-TOTAL BY t-CodProv t-venta[4]) @ t-venta[4]
            (ACCUM SUB-TOTAL BY t-CodProv t-venta[5]) @ t-venta[5]
            (ACCUM SUB-TOTAL BY t-CodProv t-venta[6]) @ t-venta[6]
            (ACCUM SUB-TOTAL BY t-CodProv t-venta[7]) @ t-venta[7]
            (ACCUM SUB-TOTAL BY t-CodProv t-venta[10]) @ t-venta[10]
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
            ("TOTAL : " + S-NOMCIA ) @ t-fchdoc
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FormatoDC W-Win 
PROCEDURE FormatoDC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-fchdoc        AT 5
         t-Costo[1]  FORMAT "->>,>>>,>>>,>>9" AT 25
         t-Costo[2]  FORMAT "->>,>>>,>>>,>>9"
         t-Costo[3]  FORMAT "->>,>>>,>>>,>>9"
         t-Costo[4]  FORMAT "->>,>>>,>>>,>>9"
         t-Costo[5]  FORMAT "->>,>>>,>>>,>>9"
         t-Costo[6]  FORMAT "->>,>>>,>>>,>>9"
         t-Costo[7]  FORMAT "->>,>>>,>>>,>>9"
         t-Costo[10] FORMAT "->>,>>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU  AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
         "Pagina : " TO 130 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         X-MONEDA AT 1  FORMAT "X(60)" 
         "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP
         "LOS IMPORTE INCLUYEN I.G.V. "  At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 FORMAT "X(15)" AT  30 
        F-DIVISION-2 FORMAT "X(15)" AT  45 
        F-DIVISION-3 FORMAT "X(15)" AT  60 
        F-DIVISION-4 FORMAT "X(15)" AT  75 
        F-DIVISION-5 FORMAT "X(15)" AT  90
        F-DIVISION-6 FORMAT "X(15)" AT  105
        "O T R O S"  AT  120
        "T O T A L"  AT  140 SKIP
        "    FECHA                     Costo           Costo          Costo          Costo           Costo          Costo           Costo             Costo    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  /*WHERE t-Costo[10] <> 0 */
                     BREAK BY T-Codcia
                           BY T-CodProv
                           BY T-Codano
                           BY T-Codmes
                           BY T-Coddia:


      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-CodProv) THEN DO:
         FIND Gn-Prov WHERE Gn-prov.Codcia = pv-codcia AND
                            Gn-prov.CodPro = T-CodProv
                            NO-LOCK NO-ERROR.
                      
         PUT STREAM REPORT T-CodProv AT 1 .
         IF AVAILABLE Gn-Prov THEN DO:
            PUT STREAM REPORT Gn-Prov.NomPro AT 12 FORMAT "X(45)" SKIP.
         END.
         
      END.


      IF FIRST-OF(t-codano) THEN DO:
        PUT STREAM REPORT  ("PERIODO  : " + STRING(T-Codano,"9999") ) FORMAT "X(30)" SKIP.
      END.

      IF FIRST-OF(t-codmes) THEN DO:
        PUT STREAM REPORT  ENTRY(T-codmes,X-NOMMES) FORMAT "X(20)" AT 5 SKIP.    
      END.
      ACCUM  t-Costo[1]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-Costo[2]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-Costo[3]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-Costo[4]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-Costo[5]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-Costo[6]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-Costo[7]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-Costo[10] ( SUB-TOTAL BY T-CodProv) .

      ACCUM  t-Costo[1]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-Costo[2]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-Costo[3]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-Costo[4]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-Costo[5]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-Costo[6]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-Costo[7]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-Costo[10] ( SUB-TOTAL BY T-Codmes) .

      ACCUM  t-Costo[1]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-Costo[2]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-Costo[3]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-Costo[4]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-Costo[5]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-Costo[6]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-Costo[7]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-Costo[10] ( SUB-TOTAL BY T-CodAno) .

      ACCUM  t-Costo[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[10] ( TOTAL BY t-codcia) .

      DISPLAY STREAM REPORT 
                t-fchdoc
                t-Costo[1] WHEN  t-Costo[1] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Costo[2] WHEN  t-Costo[2] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Costo[3] WHEN  t-Costo[3] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Costo[4] WHEN  t-Costo[4] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Costo[5] WHEN  t-Costo[5] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Costo[6] WHEN  t-Costo[6] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Costo[7] WHEN  t-Costo[7] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Costo[10]  FORMAT "->>,>>>,>>>,>>9"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-codmes) THEN DO:
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
            ("TOTAL : " + STRING(T-Codmes,"99") ) @ t-fchdoc
            (ACCUM SUB-TOTAL BY t-codmes t-Costo[1]) @ t-Costo[1]
            (ACCUM SUB-TOTAL BY t-codmes t-Costo[2]) @ t-Costo[2]
            (ACCUM SUB-TOTAL BY t-codmes t-Costo[3]) @ t-Costo[3]
            (ACCUM SUB-TOTAL BY t-codmes t-Costo[4]) @ t-Costo[4]
            (ACCUM SUB-TOTAL BY t-codmes t-Costo[5]) @ t-Costo[5]
            (ACCUM SUB-TOTAL BY t-codmes t-Costo[6]) @ t-Costo[6]
            (ACCUM SUB-TOTAL BY t-codmes t-Costo[7]) @ t-Costo[7]
            (ACCUM SUB-TOTAL BY t-codmes t-Costo[10]) @ t-Costo[10]
            WITH FRAME F-REPORTE.
        
      END.

      IF LAST-OF(t-codano) THEN DO:
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
            ("TOTAL : " + STRING(T-Codano,"9999") ) @ t-fchdoc
            (ACCUM SUB-TOTAL BY t-codano t-Costo[1]) @ t-Costo[1]
            (ACCUM SUB-TOTAL BY t-codano t-Costo[2]) @ t-Costo[2]
            (ACCUM SUB-TOTAL BY t-codano t-Costo[3]) @ t-Costo[3]
            (ACCUM SUB-TOTAL BY t-codano t-Costo[4]) @ t-Costo[4]
            (ACCUM SUB-TOTAL BY t-codano t-Costo[5]) @ t-Costo[5]
            (ACCUM SUB-TOTAL BY t-codano t-Costo[6]) @ t-Costo[6]
            (ACCUM SUB-TOTAL BY t-codano t-Costo[7]) @ t-Costo[7]
            (ACCUM SUB-TOTAL BY t-codano t-Costo[10]) @ t-Costo[10]
            WITH FRAME F-REPORTE.
      END.

      IF LAST-OF(t-CodProv) THEN DO:
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
            ("TOTAL : " + STRING(T-CodProv,"999") ) @ t-fchdoc
            (ACCUM SUB-TOTAL BY t-CodProv t-Costo[1]) @ t-Costo[1]
            (ACCUM SUB-TOTAL BY t-CodProv t-Costo[2]) @ t-Costo[2]
            (ACCUM SUB-TOTAL BY t-CodProv t-Costo[3]) @ t-Costo[3]
            (ACCUM SUB-TOTAL BY t-CodProv t-Costo[4]) @ t-Costo[4]
            (ACCUM SUB-TOTAL BY t-CodProv t-Costo[5]) @ t-Costo[5]
            (ACCUM SUB-TOTAL BY t-CodProv t-Costo[6]) @ t-Costo[6]
            (ACCUM SUB-TOTAL BY t-CodProv t-Costo[7]) @ t-Costo[7]
            (ACCUM SUB-TOTAL BY t-CodProv t-Costo[10]) @ t-Costo[10]
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
            ("TOTAL : " + S-NOMCIA ) @ t-fchdoc
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
   
  /*
  HIDE FRAME F-PROCESO.
  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FormatoDD W-Win 
PROCEDURE FormatoDD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-fchdoc        AT 5
         t-Marge[1]  FORMAT "->>,>>>,>>>,>>9" AT 25
         t-Marge[2]  FORMAT "->>,>>>,>>>,>>9"
         t-Marge[3]  FORMAT "->>,>>>,>>>,>>9"
         t-Marge[4]  FORMAT "->>,>>>,>>>,>>9"
         t-Marge[5]  FORMAT "->>,>>>,>>>,>>9"
         t-Marge[6]  FORMAT "->>,>>>,>>>,>>9"
         t-Marge[7]  FORMAT "->>,>>>,>>>,>>9"
         t-Marge[10] FORMAT "->>,>>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU  AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")"  AT 100 FORMAT "X(25)" SKIP(1)
         "Pagina : " TO 130 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         X-MONEDA AT 1  FORMAT "X(60)" 
         "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 FORMAT "X(15)" AT  30 
        F-DIVISION-2 FORMAT "X(15)" AT  45 
        F-DIVISION-3 FORMAT "X(15)" AT  60 
        F-DIVISION-4 FORMAT "X(15)" AT  75 
        F-DIVISION-5 FORMAT "X(15)" AT  90
        F-DIVISION-6 FORMAT "X(15)" AT  105
        "O T R O S"  AT  120
        "T O T A L"  AT  140 SKIP
        "    FECHA                     Marge           Marge          Marge          Marge           Marge          Marge           Marge             Marge    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  /*WHERE t-Marge[10] <> 0 */
                     BREAK BY T-Codcia
                           BY T-CodProv
                           BY T-Codano
                           BY T-Codmes
                           BY T-Coddia:


      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-CodProv) THEN DO:
         FIND Gn-Prov WHERE Gn-prov.Codcia = pv-codcia AND
                            Gn-prov.CodPro = T-CodProv
                            NO-LOCK NO-ERROR.
                      
         PUT STREAM REPORT T-CodProv AT 1 .
         IF AVAILABLE Gn-Prov THEN DO:
            PUT STREAM REPORT Gn-Prov.NomPro AT 12 FORMAT "X(45)" SKIP.
         END.
         
      END.

      IF FIRST-OF(t-codano) THEN DO:
        PUT STREAM REPORT ("PERIODO  : " + STRING(T-Codano,"9999") )  FORMAT "X(30)" SKIP.
      END.

      IF FIRST-OF(t-codmes) THEN DO:
        PUT STREAM REPORT ENTRY(T-codmes,X-NOMMES) FORMAT "X(20)" AT 5 SKIP.    
      END.

      ACCUM  t-Marge[1]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-Marge[2]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-Marge[3]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-Marge[4]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-Marge[5]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-Marge[6]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-Marge[7]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-Marge[10] ( SUB-TOTAL BY T-CodProv) .

      ACCUM  t-Marge[1]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-Marge[2]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-Marge[3]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-Marge[4]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-Marge[5]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-Marge[6]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-Marge[7]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-Marge[10] ( SUB-TOTAL BY T-Codmes) .

      ACCUM  t-Marge[1]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-Marge[2]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-Marge[3]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-Marge[4]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-Marge[5]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-Marge[6]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-Marge[7]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-Marge[10] ( SUB-TOTAL BY T-CodAno) .

      ACCUM  t-Marge[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[10] ( TOTAL BY t-codcia) .

      DISPLAY STREAM REPORT 
                t-fchdoc
                t-Marge[1] WHEN  t-Marge[1] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Marge[2] WHEN  t-Marge[2] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Marge[3] WHEN  t-Marge[3] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Marge[4] WHEN  t-Marge[4] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Marge[5] WHEN  t-Marge[5] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Marge[6] WHEN  t-Marge[6] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Marge[7] WHEN  t-Marge[7] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Marge[10]  FORMAT "->>,>>>,>>>,>>9"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-codmes) THEN DO:
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
            ("TOTAL : " + STRING(T-Codmes,"99") ) @ t-fchdoc
            (ACCUM SUB-TOTAL BY t-codmes t-Marge[1]) @ t-Marge[1]
            (ACCUM SUB-TOTAL BY t-codmes t-Marge[2]) @ t-Marge[2]
            (ACCUM SUB-TOTAL BY t-codmes t-Marge[3]) @ t-Marge[3]
            (ACCUM SUB-TOTAL BY t-codmes t-Marge[4]) @ t-Marge[4]
            (ACCUM SUB-TOTAL BY t-codmes t-Marge[5]) @ t-Marge[5]
            (ACCUM SUB-TOTAL BY t-codmes t-Marge[6]) @ t-Marge[6]
            (ACCUM SUB-TOTAL BY t-codmes t-Marge[7]) @ t-Marge[7]
            (ACCUM SUB-TOTAL BY t-codmes t-Marge[10]) @ t-Marge[10]
            WITH FRAME F-REPORTE.
        
      END.

      IF LAST-OF(t-codano) THEN DO:
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
            ("TOTAL : " + STRING(T-Codano,"9999") ) @ t-fchdoc
            (ACCUM SUB-TOTAL BY t-codano t-Marge[1]) @ t-Marge[1]
            (ACCUM SUB-TOTAL BY t-codano t-Marge[2]) @ t-Marge[2]
            (ACCUM SUB-TOTAL BY t-codano t-Marge[3]) @ t-Marge[3]
            (ACCUM SUB-TOTAL BY t-codano t-Marge[4]) @ t-Marge[4]
            (ACCUM SUB-TOTAL BY t-codano t-Marge[5]) @ t-Marge[5]
            (ACCUM SUB-TOTAL BY t-codano t-Marge[6]) @ t-Marge[6]
            (ACCUM SUB-TOTAL BY t-codano t-Marge[7]) @ t-Marge[7]
            (ACCUM SUB-TOTAL BY t-codano t-Marge[10]) @ t-Marge[10]
            WITH FRAME F-REPORTE.
      END.

      IF LAST-OF(t-CodProv) THEN DO:
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
            ("TOTAL : " + STRING(T-CodProv,"999") ) @ t-fchdoc
            (ACCUM SUB-TOTAL BY t-CodProv t-Marge[1]) @ t-Marge[1]
            (ACCUM SUB-TOTAL BY t-CodProv t-Marge[2]) @ t-Marge[2]
            (ACCUM SUB-TOTAL BY t-CodProv t-Marge[3]) @ t-Marge[3]
            (ACCUM SUB-TOTAL BY t-CodProv t-Marge[4]) @ t-Marge[4]
            (ACCUM SUB-TOTAL BY t-CodProv t-Marge[5]) @ t-Marge[5]
            (ACCUM SUB-TOTAL BY t-CodProv t-Marge[6]) @ t-Marge[6]
            (ACCUM SUB-TOTAL BY t-CodProv t-Marge[7]) @ t-Marge[7]
            (ACCUM SUB-TOTAL BY t-CodProv t-Marge[10]) @ t-Marge[10]
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
            ("TOTAL : " + S-NOMCIA ) @ t-fchdoc
            (ACCUM TOTAL BY t-codcia t-Marge[1]) @ t-Marge[1]
            (ACCUM TOTAL BY t-codcia t-Marge[2]) @ t-Marge[2]
            (ACCUM TOTAL BY t-codcia t-Marge[3]) @ t-Marge[3]
            (ACCUM TOTAL BY t-codcia t-Marge[4]) @ t-Marge[4]
            (ACCUM TOTAL BY t-codcia t-Marge[5]) @ t-Marge[5]
            (ACCUM TOTAL BY t-codcia t-Marge[6]) @ t-Marge[6]
            (ACCUM TOTAL BY t-codcia t-Marge[7]) @ t-Marge[7]
            (ACCUM TOTAL BY t-codcia t-Marge[10]) @ t-Marge[10]
            WITH FRAME F-REPORTE.
      END.
     

  END.
   
  /*
  HIDE FRAME F-PROCESO.
  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FormatoDE W-Win 
PROCEDURE FormatoDE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-fchdoc        AT 5
         t-Utili[1]  FORMAT "->>,>>>,>>>,>>9" AT 25
         t-Utili[2]  FORMAT "->>,>>>,>>>,>>9"
         t-Utili[3]  FORMAT "->>,>>>,>>>,>>9"
         t-Utili[4]  FORMAT "->>,>>>,>>>,>>9"
         t-Utili[5]  FORMAT "->>,>>>,>>>,>>9"
         t-Utili[6]  FORMAT "->>,>>>,>>>,>>9"
         t-Utili[7]  FORMAT "->>,>>>,>>>,>>9"
         t-Utili[10] FORMAT "->>,>>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")"  AT 100 FORMAT "X(25)" SKIP(1)
         "Pagina : " TO 130 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         X-MONEDA AT 1  FORMAT "X(60)" 
         "Hora  :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 FORMAT "X(15)" AT  30 
        F-DIVISION-2 FORMAT "X(15)" AT  45 
        F-DIVISION-3 FORMAT "X(15)" AT  60 
        F-DIVISION-4 FORMAT "X(15)" AT  75 
        F-DIVISION-5 FORMAT "X(15)" AT  90
        F-DIVISION-6 FORMAT "X(15)" AT  105
        "O T R O S"  AT  120
        "T O T A L"  AT  140 SKIP
        "    FECHA                     Utili           Utili          Utili          Utili           Utili          Utili           Utili             Utili    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  /*WHERE t-Utili[10] <> 0 */
                     BREAK BY T-Codcia
                           BY T-CodProv
                           BY T-Codano
                           BY T-Codmes
                           BY T-Coddia:


      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-CodProv) THEN DO:
         FIND Gn-Prov WHERE Gn-prov.Codcia = pv-codcia AND
                            Gn-prov.CodPro = T-CodProv
                            NO-LOCK NO-ERROR.
                      
         PUT STREAM REPORT T-CodProv AT 1 .
         IF AVAILABLE Gn-Prov THEN DO:
            PUT STREAM REPORT Gn-Prov.NomPro AT 12 FORMAT "X(45)" SKIP.
         END.
         
      END.

      IF FIRST-OF(t-codano) THEN DO:
        PUT STREAM REPORT ("PERIODO  : " + STRING(T-Codano,"9999") ) FORMAT "X(30)" SKIP.
      END.

      IF FIRST-OF(t-codmes) THEN DO:
        PUT STREAM REPORT ENTRY(T-codmes,X-NOMMES) FORMAT "X(20)" AT 5 SKIP.    
      END.

      ACCUM  t-Utili[1]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-Utili[2]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-Utili[3]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-Utili[4]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-Utili[5]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-Utili[6]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-Utili[7]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-Utili[10] ( SUB-TOTAL BY T-CodProv) .

      ACCUM  t-Utili[1]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-Utili[2]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-Utili[3]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-Utili[4]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-Utili[5]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-Utili[6]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-Utili[7]  ( SUB-TOTAL BY T-Codmes) .
      ACCUM  t-Utili[10] ( SUB-TOTAL BY T-Codmes) .

      ACCUM  t-Utili[1]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-Utili[2]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-Utili[3]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-Utili[4]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-Utili[5]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-Utili[6]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-Utili[7]  ( SUB-TOTAL BY T-CodAno) .
      ACCUM  t-Utili[10] ( SUB-TOTAL BY T-CodAno) .

      ACCUM  t-Utili[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[10] ( TOTAL BY t-codcia) .

      DISPLAY STREAM REPORT 
                t-fchdoc
                t-Utili[1] WHEN  t-Utili[1] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Utili[2] WHEN  t-Utili[2] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Utili[3] WHEN  t-Utili[3] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Utili[4] WHEN  t-Utili[4] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Utili[5] WHEN  t-Utili[5] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Utili[6] WHEN  t-Utili[6] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Utili[7] WHEN  t-Utili[7] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Utili[10]  FORMAT "->>,>>>,>>>,>>9"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-codmes) THEN DO:
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
            ("TOTAL : " + STRING(T-Codmes,"99") ) @ t-fchdoc
            (ACCUM SUB-TOTAL BY t-codmes t-Utili[1]) @ t-Utili[1]
            (ACCUM SUB-TOTAL BY t-codmes t-Utili[2]) @ t-Utili[2]
            (ACCUM SUB-TOTAL BY t-codmes t-Utili[3]) @ t-Utili[3]
            (ACCUM SUB-TOTAL BY t-codmes t-Utili[4]) @ t-Utili[4]
            (ACCUM SUB-TOTAL BY t-codmes t-Utili[5]) @ t-Utili[5]
            (ACCUM SUB-TOTAL BY t-codmes t-Utili[6]) @ t-Utili[6]
            (ACCUM SUB-TOTAL BY t-codmes t-Utili[7]) @ t-Utili[7]
            (ACCUM SUB-TOTAL BY t-codmes t-Utili[10]) @ t-Utili[10]
            WITH FRAME F-REPORTE.
        
      END.

      IF LAST-OF(t-codano) THEN DO:
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
            ("TOTAL : " + STRING(T-Codano,"9999") ) @ t-fchdoc
            (ACCUM SUB-TOTAL BY t-codano t-Utili[1]) @ t-Utili[1]
            (ACCUM SUB-TOTAL BY t-codano t-Utili[2]) @ t-Utili[2]
            (ACCUM SUB-TOTAL BY t-codano t-Utili[3]) @ t-Utili[3]
            (ACCUM SUB-TOTAL BY t-codano t-Utili[4]) @ t-Utili[4]
            (ACCUM SUB-TOTAL BY t-codano t-Utili[5]) @ t-Utili[5]
            (ACCUM SUB-TOTAL BY t-codano t-Utili[6]) @ t-Utili[6]
            (ACCUM SUB-TOTAL BY t-codano t-Utili[7]) @ t-Utili[7]
            (ACCUM SUB-TOTAL BY t-codano t-Utili[10]) @ t-Utili[10]
            WITH FRAME F-REPORTE.
      END.

      IF LAST-OF(t-CodProv) THEN DO:
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
            ("TOTAL : " + STRING(T-CodProv,"999") ) @ t-fchdoc
            (ACCUM SUB-TOTAL BY t-CodProv t-Utili[1]) @ t-Utili[1]
            (ACCUM SUB-TOTAL BY t-CodProv t-Utili[2]) @ t-Utili[2]
            (ACCUM SUB-TOTAL BY t-CodProv t-Utili[3]) @ t-Utili[3]
            (ACCUM SUB-TOTAL BY t-CodProv t-Utili[4]) @ t-Utili[4]
            (ACCUM SUB-TOTAL BY t-CodProv t-Utili[5]) @ t-Utili[5]
            (ACCUM SUB-TOTAL BY t-CodProv t-Utili[6]) @ t-Utili[6]
            (ACCUM SUB-TOTAL BY t-CodProv t-Utili[7]) @ t-Utili[7]
            (ACCUM SUB-TOTAL BY t-CodProv t-Utili[10]) @ t-Utili[10]
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
            ("TOTAL : " + S-NOMCIA ) @ t-fchdoc
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
   
  /*
  HIDE FRAME F-PROCESO.
  */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FormatoMA W-Win 
PROCEDURE FormatoMA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FormatoMB W-Win 
PROCEDURE FormatoMB :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-REPORTE
         t-Codano    AT 1
         t-Codmes    FORMAT "99"
         t-venta[1]  FORMAT "->>,>>>,>>>,>>9" AT 25
         t-venta[2]  FORMAT "->>,>>>,>>>,>>9"
         t-venta[3]  FORMAT "->>,>>>,>>>,>>9"
         t-venta[4]  FORMAT "->>,>>>,>>>,>>9"
         t-venta[5]  FORMAT "->>,>>>,>>>,>>9"
         t-venta[6]  FORMAT "->>,>>>,>>>,>>9"
         t-venta[7]  FORMAT "->>,>>>,>>>,>>9"
         t-venta[10] FORMAT "->>,>>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU  AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
         "Pagina : " TO 130 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
          S-SUBTIT AT 1  FORMAT "X(60)" 
         "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         X-MONEDA AT 1  FORMAT "X(60)" 
         "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP
         "LOS IMPORTE INCLUYEN I.G.V. "  At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 FORMAT "X(15)" AT  30 
        F-DIVISION-2 FORMAT "X(15)" AT  45 
        F-DIVISION-3 FORMAT "X(15)" AT  60 
        F-DIVISION-4 FORMAT "X(15)" AT  75 
        F-DIVISION-5 FORMAT "X(15)" AT  90
        F-DIVISION-6 FORMAT "X(15)" AT  105
        "O T R O S"  AT  120
        "T O T A L"  AT  140 SKIP
        "    PERIODO     MES           Venta           Venta          Venta          Venta           Venta          Venta           Venta             Venta    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  /*WHERE t-venta[10] <> 0 */
                     BREAK BY T-Codcia
                           BY T-CodProv
                           BY T-Codano
                           BY T-Codmes:


      VIEW STREAM REPORT FRAME F-HEADER.
     
      ACCUM  t-venta[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[10] ( TOTAL BY t-codcia) .

      ACCUM  t-venta[1]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-venta[2]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-venta[3]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-venta[4]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-venta[5]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-venta[6]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-venta[7]  ( SUB-TOTAL BY T-CodProv) .
      ACCUM  t-venta[10] ( SUB-TOTAL BY T-CodProv) .

      IF FIRST-OF(t-CodProv) THEN DO:
         FIND Gn-Prov WHERE Gn-prov.Codcia = pv-codcia AND
                            Gn-prov.CodPro = T-CodProv
                            NO-LOCK NO-ERROR.
                      
         PUT STREAM REPORT T-CodProv AT 1 .
         IF AVAILABLE Gn-Prov THEN DO:
            PUT STREAM REPORT Gn-Prov.NomPro AT 12 FORMAT "X(45)" SKIP.
         END.
         
      END.
      
      DISPLAY STREAM REPORT 
                t-Codano
                t-Codmes
                t-venta[1] WHEN  t-venta[1] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-venta[2] WHEN  t-venta[2] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-venta[3] WHEN  t-venta[3] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-venta[4] WHEN  t-venta[4] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-venta[5] WHEN  t-venta[5] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-venta[6] WHEN  t-venta[6] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-venta[7] WHEN  t-venta[7] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-venta[10]  FORMAT "->>>,>>>,>>9.99"
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-CodProv) THEN DO:
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
            ("TOTAL : " ) @ t-Codano
            (ACCUM SUB-TOTAL BY t-CodProv t-venta[1]) @ t-venta[1]
            (ACCUM SUB-TOTAL BY t-CodProv t-venta[2]) @ t-venta[2]
            (ACCUM SUB-TOTAL BY t-CodProv t-venta[3]) @ t-venta[3]
            (ACCUM SUB-TOTAL BY t-CodProv t-venta[4]) @ t-venta[4]
            (ACCUM SUB-TOTAL BY t-CodProv t-venta[5]) @ t-venta[5]
            (ACCUM SUB-TOTAL BY t-CodProv t-venta[6]) @ t-venta[6]
            (ACCUM SUB-TOTAL BY t-CodProv t-venta[7]) @ t-venta[7]
            (ACCUM SUB-TOTAL BY t-CodProv t-venta[10]) @ t-venta[10]
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
            ("TOTAL : " + S-NOMCIA ) @ t-Codano
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FormatoMC W-Win 
PROCEDURE FormatoMC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-REPORTE
         t-Codano    AT 1
         t-Codmes    FORMAT "99"
         t-Costo[1]  FORMAT "->>,>>>,>>>,>>9" AT 25
         t-Costo[2]  FORMAT "->>,>>>,>>>,>>9"
         t-Costo[3]  FORMAT "->>,>>>,>>>,>>9"
         t-Costo[4]  FORMAT "->>,>>>,>>>,>>9"
         t-Costo[5]  FORMAT "->>,>>>,>>>,>>9"
         t-Costo[6]  FORMAT "->>,>>>,>>>,>>9"
         t-Costo[7]  FORMAT "->>,>>>,>>>,>>9"
         t-Costo[10] FORMAT "->>,>>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")"  AT 100 FORMAT "X(25)" SKIP(1)
         "Pagina : " TO 130 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         X-MONEDA AT 1  FORMAT "X(60)" 
         "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         "DIVISIONES EVALUADAS  : " + X-CODDIV   At 1 FORMAT "X(150)" SKIP
         "LOS IMPORTE INCLUYEN I.G.V. "  At 1 FORMAT "X(150)" SKIP
 

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 FORMAT "X(15)" AT  30 
        F-DIVISION-2 FORMAT "X(15)" AT  45 
        F-DIVISION-3 FORMAT "X(15)" AT  60 
        F-DIVISION-4 FORMAT "X(15)" AT  75 
        F-DIVISION-5 FORMAT "X(15)" AT  90
        F-DIVISION-6 FORMAT "X(15)" AT  105
        "O T R O S"  AT  120
        "T O T A L"  AT  140 SKIP
        "    PERIODO     MES           Costo           Costo          Costo          Costo           Costo          Costo           Costo             Costo    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  /*WHERE t-Costo[10] <> 0 */
                     BREAK BY T-Codcia
                           BY T-CodProv
                           BY T-Codano
                           BY T-Codmes:


      VIEW STREAM REPORT FRAME F-HEADER.
     
      ACCUM  t-Costo[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Costo[10] ( TOTAL BY t-codcia) .

      ACCUM  t-Costo[1]  ( SUB-TOTAL BY t-CodProv) .
      ACCUM  t-Costo[2]  ( SUB-TOTAL BY t-CodProv) .
      ACCUM  t-Costo[3]  ( SUB-TOTAL BY t-CodProv) .
      ACCUM  t-Costo[4]  ( SUB-TOTAL BY t-CodProv) .
      ACCUM  t-Costo[5]  ( SUB-TOTAL BY t-CodProv) .
      ACCUM  t-Costo[6]  ( SUB-TOTAL BY t-CodProv) .
      ACCUM  t-Costo[7]  ( SUB-TOTAL BY t-CodProv) .
      ACCUM  t-Costo[10] ( SUB-TOTAL BY t-CodProv) .

      IF FIRST-OF(t-CodProv) THEN DO:
         FIND Gn-Prov WHERE Gn-prov.Codcia = pv-codcia AND
                            Gn-prov.CodPro = T-CodProv
                            NO-LOCK NO-ERROR.
                      
         PUT STREAM REPORT T-CodProv AT 1 .
         IF AVAILABLE Gn-Prov THEN DO:
            PUT STREAM REPORT Gn-Prov.NomPro AT 12 FORMAT "X(45)" SKIP.
         END.
         
      END.

      DISPLAY STREAM REPORT 
                t-Codano
                t-Codmes
                t-Costo[1] WHEN  t-Costo[1] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Costo[2] WHEN  t-Costo[2] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Costo[3] WHEN  t-Costo[3] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Costo[4] WHEN  t-Costo[4] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Costo[5] WHEN  t-Costo[5] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Costo[6] WHEN  t-Costo[6] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Costo[7] WHEN  t-Costo[7] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Costo[10]  FORMAT "->>>,>>>,>>9.99"
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-CodProv) THEN DO:
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
            ("TOTAL : " ) @ t-Codano
            (ACCUM SUB-TOTAL BY t-CodProv t-Costo[1]) @ t-Costo[1]
            (ACCUM SUB-TOTAL BY t-CodProv t-Costo[2]) @ t-Costo[2]
            (ACCUM SUB-TOTAL BY t-CodProv t-Costo[3]) @ t-Costo[3]
            (ACCUM SUB-TOTAL BY t-CodProv t-Costo[4]) @ t-Costo[4]
            (ACCUM SUB-TOTAL BY t-CodProv t-Costo[5]) @ t-Costo[5]
            (ACCUM SUB-TOTAL BY t-CodProv t-Costo[6]) @ t-Costo[6]
            (ACCUM SUB-TOTAL BY t-CodProv t-Costo[7]) @ t-Costo[7]
            (ACCUM SUB-TOTAL BY t-CodProv t-Costo[10]) @ t-Costo[10]
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
            ("TOTAL : " + S-NOMCIA ) @ t-Codano
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
   
  /*
  HIDE FRAME F-PROCESO.
  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FormatoMD W-Win 
PROCEDURE FormatoMD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-REPORTE
         t-Codano    AT 1
         t-Codmes    FORMAT "99"
         t-Marge[1]  FORMAT "->>,>>>,>>>,>>9" AT 25
         t-Marge[2]  FORMAT "->>,>>>,>>>,>>9"
         t-Marge[3]  FORMAT "->>,>>>,>>>,>>9"
         t-Marge[4]  FORMAT "->>,>>>,>>>,>>9"
         t-Marge[5]  FORMAT "->>,>>>,>>>,>>9"
         t-Marge[6]  FORMAT "->>,>>>,>>>,>>9"
         t-Marge[7]  FORMAT "->>,>>>,>>>,>>9"
         t-Marge[10] FORMAT "->>,>>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")"  AT 100 FORMAT "X(25)" SKIP(1)
         "Pagina : " TO 130 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         X-MONEDA AT 1  FORMAT "X(60)" 
         "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         "DIVISIONES EVALUADAS  : " + X-CODDIV   At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 FORMAT "X(15)" AT  30 
        F-DIVISION-2 FORMAT "X(15)" AT  45 
        F-DIVISION-3 FORMAT "X(15)" AT  60 
        F-DIVISION-4 FORMAT "X(15)" AT  75 
        F-DIVISION-5 FORMAT "X(15)" AT  90
        F-DIVISION-6 FORMAT "X(15)" AT  105
        "O T R O S"  AT  120
        "T O T A L"  AT  140 SKIP
        "    PERIODO     MES           Marge           Marge          Marge          Marge           Marge          Marge           Marge             Marge    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  /*WHERE t-Marge[10] <> 0 */
                     BREAK BY T-Codcia
                           BY T-CodProv
                           BY T-Codano
                           BY T-Codmes:


      VIEW STREAM REPORT FRAME F-HEADER.
     
      ACCUM  t-Marge[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[10] ( TOTAL BY t-codcia) .

      ACCUM  t-Marge[1]  ( SUB-TOTAL BY t-CodProv) .
      ACCUM  t-Marge[2]  ( SUB-TOTAL BY t-CodProv) .
      ACCUM  t-Marge[3]  ( SUB-TOTAL BY t-CodProv) .
      ACCUM  t-Marge[4]  ( SUB-TOTAL BY t-CodProv) .
      ACCUM  t-Marge[5]  ( SUB-TOTAL BY t-CodProv) .
      ACCUM  t-Marge[6]  ( SUB-TOTAL BY t-CodProv) .
      ACCUM  t-Marge[7]  ( SUB-TOTAL BY t-CodProv) .
      ACCUM  t-Marge[10] ( SUB-TOTAL BY t-CodProv) .

      IF FIRST-OF(t-CodProv) THEN DO:
         FIND Gn-Prov WHERE Gn-prov.Codcia = pv-codcia AND
                            Gn-prov.CodPro = T-CodProv
                            NO-LOCK NO-ERROR.
                      
         PUT STREAM REPORT T-CodProv AT 1 .
         IF AVAILABLE Gn-Prov THEN DO:
            PUT STREAM REPORT Gn-Prov.NomPro AT 12 FORMAT "X(45)" SKIP.
         END.
         
      END.

      DISPLAY STREAM REPORT 
                t-Codano
                t-Codmes
                t-Marge[1] WHEN  t-Marge[1] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Marge[2] WHEN  t-Marge[2] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Marge[3] WHEN  t-Marge[3] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Marge[4] WHEN  t-Marge[4] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Marge[5] WHEN  t-Marge[5] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Marge[6] WHEN  t-Marge[6] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Marge[7] WHEN  t-Marge[7] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Marge[10]  FORMAT "->>>,>>>,>>9.99"
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-CodProv) THEN DO:
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
            ("TOTAL : " ) @ t-Codano
            (ACCUM SUB-TOTAL BY t-CodProv t-Marge[1]) @ t-Marge[1]
            (ACCUM SUB-TOTAL BY t-CodProv t-Marge[2]) @ t-Marge[2]
            (ACCUM SUB-TOTAL BY t-CodProv t-Marge[3]) @ t-Marge[3]
            (ACCUM SUB-TOTAL BY t-CodProv t-Marge[4]) @ t-Marge[4]
            (ACCUM SUB-TOTAL BY t-CodProv t-Marge[5]) @ t-Marge[5]
            (ACCUM SUB-TOTAL BY t-CodProv t-Marge[6]) @ t-Marge[6]
            (ACCUM SUB-TOTAL BY t-CodProv t-Marge[7]) @ t-Marge[7]
            (ACCUM SUB-TOTAL BY t-CodProv t-Marge[10]) @ t-Marge[10]
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
            ("TOTAL : " + S-NOMCIA ) @ t-Codano
            (ACCUM TOTAL BY t-codcia t-Marge[1]) @ t-Marge[1]
            (ACCUM TOTAL BY t-codcia t-Marge[2]) @ t-Marge[2]
            (ACCUM TOTAL BY t-codcia t-Marge[3]) @ t-Marge[3]
            (ACCUM TOTAL BY t-codcia t-Marge[4]) @ t-Marge[4]
            (ACCUM TOTAL BY t-codcia t-Marge[5]) @ t-Marge[5]
            (ACCUM TOTAL BY t-codcia t-Marge[6]) @ t-Marge[6]
            (ACCUM TOTAL BY t-codcia t-Marge[7]) @ t-Marge[7]
            (ACCUM TOTAL BY t-codcia t-Marge[10]) @ t-Marge[10]
            WITH FRAME F-REPORTE.
      END.
     

  END.
   
  /*
  HIDE FRAME F-PROCESO.
  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FormatoME W-Win 
PROCEDURE FormatoME :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-REPORTE
         t-Codano    AT 1
         t-Codmes    FORMAT "99"
         t-Utili[1]  FORMAT "->>,>>>,>>>,>>9" AT 25
         t-Utili[2]  FORMAT "->>,>>>,>>>,>>9"
         t-Utili[3]  FORMAT "->>,>>>,>>>,>>9"
         t-Utili[4]  FORMAT "->>,>>>,>>>,>>9"
         t-Utili[5]  FORMAT "->>,>>>,>>>,>>9"
         t-Utili[6]  FORMAT "->>,>>>,>>>,>>9"
         t-Utili[7]  FORMAT "->>,>>>,>>>,>>9"
         t-Utili[10] FORMAT "->>,>>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + "-" + C-TIPO-2 + ")" AT 100 FORMAT "X(25)" SKIP(1)
         "Pagina : " TO 130 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         X-MONEDA AT 1  FORMAT "X(60)" 
         "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         "DIVISIONES EVALUADAS  : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 FORMAT "X(15)" AT  30 
        F-DIVISION-2 FORMAT "X(15)" AT  45 
        F-DIVISION-3 FORMAT "X(15)" AT  60 
        F-DIVISION-4 FORMAT "X(15)" AT  75 
        F-DIVISION-5 FORMAT "X(15)" AT  90
        F-DIVISION-6 FORMAT "X(15)" AT  105
        "O T R O S"  AT  120
        "T O T A L"  AT  140 SKIP
        "    PERIODO     MES           Utili           Utili          Utili          Utili           Utili          Utili           Utili             Utili    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  /*WHERE t-Utili[10] <> 0 */
                     BREAK BY T-Codcia
                           BY T-CodProv
                           BY T-Codano
                           BY T-Codmes:


      VIEW STREAM REPORT FRAME F-HEADER.
     
      ACCUM  t-Utili[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[10] ( TOTAL BY t-codcia) .

      ACCUM  t-Utili[1]  ( SUB-TOTAL BY t-CodProv) .
      ACCUM  t-Utili[2]  ( SUB-TOTAL BY t-CodProv) .
      ACCUM  t-Utili[3]  ( SUB-TOTAL BY t-CodProv) .
      ACCUM  t-Utili[4]  ( SUB-TOTAL BY t-CodProv) .
      ACCUM  t-Utili[5]  ( SUB-TOTAL BY t-CodProv) .
      ACCUM  t-Utili[6]  ( SUB-TOTAL BY t-CodProv) .
      ACCUM  t-Utili[7]  ( SUB-TOTAL BY t-CodProv) .
      ACCUM  t-Utili[10] ( SUB-TOTAL BY t-CodProv) .

      IF FIRST-OF(t-CodProv) THEN DO:
         FIND Gn-Prov WHERE Gn-prov.Codcia = pv-codcia AND
                            Gn-prov.CodPro = T-CodProv
                            NO-LOCK NO-ERROR.
                      
         PUT STREAM REPORT T-CodProv AT 1 .
         IF AVAILABLE Gn-Prov THEN DO:
            PUT STREAM REPORT Gn-Prov.NomPro AT 12 FORMAT "X(45)" SKIP.
         END.
         
      END.

      DISPLAY STREAM REPORT 
                t-Codano
                t-Codmes
                t-Utili[1] WHEN  t-Utili[1] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Utili[2] WHEN  t-Utili[2] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Utili[3] WHEN  t-Utili[3] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Utili[4] WHEN  t-Utili[4] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Utili[5] WHEN  t-Utili[5] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Utili[6] WHEN  t-Utili[6] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Utili[7] WHEN  t-Utili[7] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Utili[10]  FORMAT "->>>,>>>,>>9.99"
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-CodProv) THEN DO:
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
            ("TOTAL : " ) @ t-Codano
            (ACCUM SUB-TOTAL BY t-CodProv t-Utili[1]) @ t-Utili[1]
            (ACCUM SUB-TOTAL BY t-CodProv t-Utili[2]) @ t-Utili[2]
            (ACCUM SUB-TOTAL BY t-CodProv t-Utili[3]) @ t-Utili[3]
            (ACCUM SUB-TOTAL BY t-CodProv t-Utili[4]) @ t-Utili[4]
            (ACCUM SUB-TOTAL BY t-CodProv t-Utili[5]) @ t-Utili[5]
            (ACCUM SUB-TOTAL BY t-CodProv t-Utili[6]) @ t-Utili[6]
            (ACCUM SUB-TOTAL BY t-CodProv t-Utili[7]) @ t-Utili[7]
            (ACCUM SUB-TOTAL BY t-CodProv t-Utili[10]) @ t-Utili[10]
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
            ("TOTAL : " + S-NOMCIA ) @ t-Codano
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
   

/*
 DEFINE FRAME F-REPORTE
         t-Codano    AT 1
         t-Codmes    FORMAT "99"
         t-Utili[1]  FORMAT "->>,>>>,>>>,>>9" AT 25
         t-Utili[2]  FORMAT "->>,>>>,>>>,>>9"
         t-Utili[3]  FORMAT "->>,>>>,>>>,>>9"
         t-Utili[4]  FORMAT "->>,>>>,>>>,>>9"
         t-Utili[5]  FORMAT "->>,>>>,>>>,>>9"
         t-Utili[6]  FORMAT "->>,>>>,>>>,>>9"
         t-Utili[7]  FORMAT "->>,>>>,>>>,>>9"
         t-Utili[10] FORMAT "->>,>>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6B} + {&Prn3} FORMAT "X(50)" AT 1 SKIP(1)
         {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 40 FORMAT "X(50)" 
         {&PRN3} + {&PRN6A} + "(" + C-TIPO + "-" + C-TIPO-2 + ")" + {&PRN6B} + {&PRN3} AT 100 FORMAT "X(25)" SKIP(1)
         {&PRN3} + {&PRN6B} + "Pagina : " TO 130 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         {&PRN3} + {&PRN6B} + S-SUBTIT AT 1  FORMAT "X(60)" 
         {&PRN3} + {&PRN6B} + "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         {&PRN3} + {&PRN6B} + X-MONEDA AT 1  FORMAT "X(60)" 
         {&PRN3} + {&PRN6B} + "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         {&PRN3} + {&PRN6B} + "DIVISIONES EVALUADAS  : " + X-CODDIV  + {&PRN4} + {&PRN6B} At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        F-DIVISION-1 FORMAT "X(15)" AT  30 
        F-DIVISION-2 FORMAT "X(15)" AT  45 
        F-DIVISION-3 FORMAT "X(15)" AT  60 
        F-DIVISION-4 FORMAT "X(15)" AT  75 
        F-DIVISION-5 FORMAT "X(15)" AT  90
        F-DIVISION-6 FORMAT "X(15)" AT  105
        "O T R O S"  AT  120
        "T O T A L"  AT  140 SKIP
        "    PERIODO     MES           Utili           Utili          Utili          Utili           Utili          Utili           Utili             Utili    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  /*WHERE t-Utili[10] <> 0 */
                     BREAK BY T-Codcia
                           BY T-Codano
                           BY T-Codmes:


      VIEW STREAM REPORT FRAME F-HEADER.
     
      ACCUM  t-Utili[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Utili[10] ( TOTAL BY t-codcia) .

      DISPLAY STREAM REPORT 
                t-Codano
                t-Codmes
                t-Utili[1] WHEN  t-Utili[1] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Utili[2] WHEN  t-Utili[2] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Utili[3] WHEN  t-Utili[3] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Utili[4] WHEN  t-Utili[4] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Utili[5] WHEN  t-Utili[5] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Utili[6] WHEN  t-Utili[6] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Utili[7] WHEN  t-Utili[7] <> 0 FORMAT "->>,>>>,>>>,>>9"
                t-Utili[10]  FORMAT "->>>,>>>,>>9.99"
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
            {&PRN6A} + ("TOTAL : " + S-NOMCIA ) @ t-Codano
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
    ENABLE ALL EXCEPT F-NOMDIV-1 F-NOMDIV-2 F-NOMDIV-3 F-NOMDIV-4 F-NOMDIV-5 F-NOMDIV-6.
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

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        txt-msj:VISIBLE IN FRAME {&FRAME-NAME} = YES.
        CASE C-Tipo:
            WHEN "Mensual" THEN RUN R-Mensual.
            WHEN "Diario"  THEN RUN R-Diario.
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
         DesdeF 
         HastaF 
         nCodMon 
         C-tipo-2
         F-Prov1.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE R-Diario W-Win 
PROCEDURE R-Diario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN Carga-Diario1.
CASE C-Tipo-2:
    WHEN "Cantidad"  THEN RUN FormatoDA.
    WHEN "Venta"     THEN RUN FormatoDB.
    WHEN "Costo"     THEN RUN FormatoDC.
    WHEN "Margen"    THEN RUN FormatoDD.
    WHEN "Utilidad"  THEN RUN FormatoDE.
END CASE. 
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE R-Mensual W-Win 
PROCEDURE R-Mensual :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN Carga-Mensual1.
CASE C-Tipo-2:
    WHEN "Cantidad"  THEN RUN FormatoMA.
    WHEN "Venta"     THEN RUN FormatoMB.
    WHEN "Costo"     THEN RUN FormatoMC.
    WHEN "Margen"    THEN RUN FormatoMD.
    WHEN "Utilidad"  THEN RUN FormatoME.
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


RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

