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
DEFINE SHARED VAR CL-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE        VAR F-PESALM AS DECIMAL NO-UNDO.
DEFINE SHARED VAR S-CODDIV AS CHARACTER.
DEFINE SHARED VAR S-CodDoc AS CHARACTER.
DEFINE SHARED VAR S-NroDoc AS CHARACTER.
DEFINE SHARED VAR S-ImpTot AS DECIMAL.

/*Def var s-codcia    as inte init 1.*/
Def var x-signo1    as inte init 1.
Def var x-fin       as inte init 0.
Def var f-factor    as deci init 0.
Def var x-NroFchI   as inte init 0.
Def var x-NroFchF   as inte init 0.
Def var x-CodFchI   as date format '99/99/9999' init TODAY.
Def var x-CodFchF   as date format '99/99/9999' init TODAY.
/*Def var i           as inte init 0.*/
Def var x-TpoCmbCmp as deci init 1.
Def var x-TpoCmbVta as deci init 1.
Def var x-Day       as inte format '99'   init 1.
Def var x-Month     as inte format '99'   init 1.
Def var x-Year      as inte format '9999' init 1.
Def var x-coe       as deci init 0.
Def var x-can       as deci init 0.
def var x-fmapgo    as char.
def var x-canal     as char.

Def BUFFER B-CDOCU FOR CcbCdocu.
DEFINE SHARED VARIABLE S-Periodo AS INTEGER.
DEFINE TEMP-TABLE Detalle FIELD CodCia LIKE S-CodCia
                          FIELD CodDoc LIKE S-CodDoc
                          FIELD NroDoc LIKE S-NroDoc
                          FIELD ImpTot LIKE S-ImpTot
                          FIELD TpoBol LIKE Pl-Bol.TpoBol
                          FIELD CodMov LIKE Pl-Conc.CodMov
                          FIELD DesMov LIKE Pl-Conc.DesMov
                          FIELD CodCta LIKE Pl-Bol.CodCta
                          FIELD valcal AS DECIMAL EXTENT 12
                          FIELD Stotal AS DECIMAL
                          INDEX llave01 AS PRIMARY UNIQUE TpoBol CodMOv.

 

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
DEFINE VAR X-ARTI    AS CHAR.
DEFINE VAR X-FAMILIA AS CHAR.
/*DEFINE VAR X-CANAL AS CHAR.*/
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
    FIELD t-Desfam  LIKE AlmtFami.DesFam  
    FIELD t-subfam  LIKE Almmmatg.subfam
    FIELD t-prove   LIKE Almmmatg.CodPr1
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
    FIELD t-canal   LIKE almtabla.codigo
    FIELD t-periodo AS INT
    FIELD t-mes     AS INT.

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
&Scoped-Define ENABLED-OBJECTS RECT-58 RECT-62 RECT-61 RECT-63 C-tipo ~
FILL-IN-periodo C-tipo-2 F-DIVISION BUTTON-5 F-CodFam BUTTON-1 F-DIVISION-1 ~
F-Canal BUTTON-2 F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 DesdeF HastaF ~
F-DIVISION-5 F-DIVISION-6 nCodMon Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS C-tipo FILL-IN-periodo C-tipo-2 F-DIVISION ~
F-CodFam F-DIVISION-1 F-NOMDIV-1 F-Canal F-DIVISION-2 F-NOMDIV-2 F-NOMDIV-3 ~
F-DIVISION-3 F-DIVISION-4 F-NOMDIV-4 DesdeF HastaF F-DIVISION-5 F-NOMDIV-5 ~
F-DIVISION-6 F-NOMDIV-6 nCodMon 

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

DEFINE VARIABLE C-tipo AS CHARACTER FORMAT "X(20)":U INITIAL "Canal-Articulo" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "Canal-Articulo","Canal-Familia" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE C-tipo-2 AS CHARACTER FORMAT "X(20)":U INITIAL "Venta" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "Venta","Cantidad" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-Canal AS CHARACTER FORMAT "X(4)":U 
     LABEL "Canal" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Linea" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-DIVISION AS CHARACTER FORMAT "X(5)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

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

DEFINE VARIABLE FILL-IN-periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

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
     SIZE 73 BY 1.81
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27.57 BY 2.73.

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 9.65
     BGCOLOR 3 .

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27.29 BY 5.35.

DEFINE RECTANGLE RECT-63
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27.29 BY 1.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     C-tipo AT ROW 1.88 COL 51.72 COLON-ALIGNED HELP
          "coloque el codigo" NO-LABEL
     FILL-IN-periodo AT ROW 2.54 COL 9 COLON-ALIGNED
     C-tipo-2 AT ROW 2.85 COL 51.72 COLON-ALIGNED NO-LABEL
     F-DIVISION AT ROW 3.5 COL 9 COLON-ALIGNED
     BUTTON-5 AT ROW 3.5 COL 22
     F-CodFam AT ROW 4.46 COL 9 COLON-ALIGNED
     BUTTON-1 AT ROW 4.46 COL 22
     F-DIVISION-1 AT ROW 4.92 COL 49.57 COLON-ALIGNED
     F-NOMDIV-1 AT ROW 4.96 COL 56 COLON-ALIGNED NO-LABEL
     F-Canal AT ROW 5.42 COL 9 COLON-ALIGNED
     BUTTON-2 AT ROW 5.42 COL 22
     F-DIVISION-2 AT ROW 5.65 COL 49.57 COLON-ALIGNED
     F-NOMDIV-2 AT ROW 5.69 COL 56 COLON-ALIGNED NO-LABEL
     F-NOMDIV-3 AT ROW 6.42 COL 56 COLON-ALIGNED NO-LABEL
     F-DIVISION-3 AT ROW 6.46 COL 49.57 COLON-ALIGNED
     F-DIVISION-4 AT ROW 7.15 COL 49.57 COLON-ALIGNED
     F-NOMDIV-4 AT ROW 7.15 COL 56 COLON-ALIGNED NO-LABEL
     DesdeF AT ROW 7.58 COL 11.57 COLON-ALIGNED
     HastaF AT ROW 7.65 COL 33.29 COLON-ALIGNED
     F-DIVISION-5 AT ROW 7.96 COL 49.57 COLON-ALIGNED
     F-NOMDIV-5 AT ROW 7.96 COL 56 COLON-ALIGNED NO-LABEL
     F-DIVISION-6 AT ROW 8.77 COL 49.57 COLON-ALIGNED
     F-NOMDIV-6 AT ROW 8.77 COL 56 COLON-ALIGNED NO-LABEL
     nCodMon AT ROW 10.35 COL 52.86 NO-LABEL
     Btn_OK AT ROW 11.38 COL 36
     Btn_Cancel AT ROW 11.38 COL 47.29
     Btn_Help AT ROW 11.38 COL 58.72
     "Moneda" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 9.77 COL 50
          FONT 6
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1.35 COL 4.43
          FONT 6
     " Tipo de Reporte" VIEW-AS TEXT
          SIZE 14.57 BY .65 AT ROW 1.27 COL 48.43
          FONT 6
     " Desplegar Divisiones" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 4.27 COL 49.43
          FONT 6
     RECT-58 AT ROW 1.54 COL 47.43
     RECT-46 AT ROW 11.19 COL 2
     RECT-62 AT ROW 4.35 COL 47.72
     RECT-61 AT ROW 1.58 COL 2
     RECT-63 AT ROW 9.85 COL 47.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 75.29 BY 12.04
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
         HEIGHT             = 12.04
         WIDTH              = 75.29
         MAX-HEIGHT         = 26.5
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 26.5
         VIRTUAL-WIDTH      = 146.29
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
    input-var-1 = "CN".
    output-var-2 = "".
    RUN lkup\C-ALMTAB02.r("Canal de Ventas").
    IF output-var-2 <> ? THEN DO:
        F-Canal = output-var-2.
        DISPLAY F-Canal.
        APPLY "ENTRY" TO F-Canal.
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


&Scoped-define SELF-NAME F-Canal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Canal W-Win
ON LEAVE OF F-Canal IN FRAME F-Main /* Canal */
DO:
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
         C-tipo-2
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
         F-Canal 
         DesdeF 
         HastaF 
         nCodMon .
  X-ARTI        = "ARTICULOS    : " .
  X-FAMILIA     = "FAMILIA      : ".
  X-CANAL       = "CANAL        : ".
  
    
  S-SUBTIT =   "PERIODO      : " + STRING(DesdeF,"99/99/9999") + " al " + STRING(HastaF,"99/99/9999").

  IF C-tipo-2 = 'Venta'
  THEN X-MONEDA =   "MONEDA       : " + IF NCODMON = 1 THEN "NUEVOS SOLES " ELSE "DOLARES AMERICANOS ".  
  ELSE X-MONEDA = "CANTIDADES".

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

  IF F-CANAL = "" THEN DO:
    X-CANAL = "CANAL        : ".
    FOR EACH almtabla NO-LOCK WHERE almtabla.tabla = 'CN':                
        X-CANAL = X-CANAL + almtabla.Codigo + "," .
    END.
  END.
  ELSE DO:
   FIND Almtabla WHERE Almtabla.tabla = 'CN' AND
                      Almtabla.Codigo = F-CANAL NO-LOCK NO-ERROR.
   X-CANAL = X-CANAL + Almtabla.Codigo + "," .
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
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
 ------------------------------------------------------------------------------*/
DEFINE VAR X-ENTRA AS LOGICAL INIT FALSE.
DEFINE VAR X-DESCANAL AS CHAR.

 x-CodFchI = TODAY - 3.
 x-CodFchF = 11/01/9999.

  x-CodFchI = x-CodFchI - DAY(x-CodFchI) + 1.

  DO WHILE MONTH(x-CodFchF + 1) = MONTH(x-CodFchF):
           x-CodFchF = x-CodFchF + 1. 
  END. 
 
  x-CodFchF = x-CodFchF + 1.
  
x-codfchi = DATE(MONTH(TODAY - 30), 01, YEAR(TODAY - 30)).
x-codfchf = TODAY - 1.

x-NroFchI = INTEGER(STRING(YEAR(x-CodFchI),"9999") + STRING(MONTH(x-CodFchI),"99")).      
x-NroFchF = INTEGER(STRING(YEAR(x-CodFchF),"9999") + STRING(MONTH(x-CodFchF),"99")).                           

DISPLAY x-CodFchI x-CodFchF x-NroFchI x-NroFchF.
PAUSE 0.
    

 FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CodCia
        use-index Idx01 
        no-lock :
   
        FOR EACH CcbCdocu WHERE CcbCdocu.CodCia = S-CODCIA 
                            AND CcbCdocu.CodDiv = Gn-Divi.CodDiv
                            AND CcbCdocu.FchDoc >= x-CodFchI
                            AND CcbCdocu.FchDoc <= x-CodFchF
                            USE-INDEX llave10
                            BREAK BY CcbCdocu.CodCia
                                  BY CcbCdocu.CodDiv
                                  BY CcbCdocu.FchDoc:
            /* ***************** FILTROS ********************************** */
            IF Lookup(CcbCDocu.CodDoc,"TCK,FAC,BOL,N/C,N/D") = 0 THEN NEXT.
            IF CcbCDocu.FlgEst = "A"  THEN NEXT.
            IF CcbCDocu.ImpCto = ? THEN DO:
                CcbCDocu.ImpCto = 0.
            END.
            IF DAY(CcbCDocu.FchDoc) = 0 OR DAY(CcbCDocu.FchDoc) = ?
            THEN NEXT.
            /* *********************************************************** */
            x-signo1 = IF CcbCdocu.Coddoc = "N/C" THEN -1 ELSE 1.
            DISPLAY CcbCdocu.Codcia
                    CcbCdocu.Coddiv
                    CcbCdocu.FchDoc 
                    CcbCdocu.CodDoc
                    CcbCdocu.NroDoc
                    STRING(TIME,'HH:MM')
                    TODAY .
            PAUSE 0.
     
            ASSIGN
                x-Day   = DAY(CcbCdocu.FchDoc)
                x-Month = MONTH(CcbCdocu.FchDoc)
                x-Year  = YEAR(CcbCdocu.FchDoc).
                FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc
                                  USE-INDEX Cmb01
                                  NO-LOCK NO-ERROR.
                IF NOT AVAIL Gn-Tcmb THEN 
                    FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc
                                       USE-INDEX Cmb01
                                       NO-LOCK NO-ERROR.
                IF AVAIL Gn-Tcmb THEN 
                    ASSIGN
                    x-TpoCmbCmp = Gn-Tcmb.Compra
                    x-TpoCmbVta = Gn-Tcmb.Venta.
            
            IF Ccbcdocu.CodMon = 1 THEN 
                ASSIGN
                    EvtDivi.VtaxMesMn = EvtDivi.VtaxMesMn + x-signo1 * CcbCdocu.ImpTot
                    EvtDivi.VtaxMesMe = EvtDivi.VtaxMesMe + x-signo1 * CcbCdocu.ImpTot / x-TpoCmbCmp.
            IF Ccbcdocu.CodMon = 2 THEN 
                ASSIGN
                    EvtDivi.VtaxMesMn = EvtDivi.VtaxMesMn + x-signo1 * CcbCdocu.ImpTot * x-TpoCmbVta
                    EvtDivi.VtaxMesMe = EvtDivi.VtaxMesMe + x-signo1 * CcbCdocu.ImpTot.


           IF CcbCdocu.Coddoc = "N/C" AND CcbCdocu.CndCre = "N" THEN RUN PROCESA-NOTA.

           FOR EACH CcbDdocu OF CcbCdocu NO-LOCK:
               
               FIND Almmmatg WHERE Almmmatg.Codcia = CcbDdocu.Codcia AND
                                   Almmmatg.CodMat = CcbDdocu.CodMat NO-LOCK NO-ERROR.
               IF NOT AVAILABLE Almmmatg THEN NEXT.
               FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                                   Almtconv.Codalter = Ccbddocu.UndVta
                                   NO-LOCK NO-ERROR.
               F-FACTOR  = 1. 
               IF AVAILABLE Almtconv THEN DO:
                  F-FACTOR = Almtconv.Equival.
                  IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
               END.
               
               IF Ccbcdocu.CodMon = 1 THEN 
                    ASSIGN
                        EvtArti.VtaxMesMn = EvtArti.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin
                        EvtArti.VtaxMesMe = EvtArti.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin / x-TpoCmbCmp.
               IF Ccbcdocu.CodMon = 2 THEN 
                    ASSIGN
                        EvtArti.VtaxMesMn = EvtArti.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta
                        EvtArti.VtaxMesMe = EvtArti.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin.
               ASSIGN            
               EvtArti.CanxMes = EvtArti.CanxMes + ( x-signo1 * CcbDdocu.CanDes * F-FACTOR ).

           END.  
        END.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-2 W-Win 
PROCEDURE Carga-Temporal-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR X-ENTRA AS LOGICAL INIT FALSE.
DEFINE VAR X-DESCANAL AS CHAR.
DEFINE VAR X-DESFAM AS CHAR.
DEFINE VAR X-FAMILIAS AS CHAR INIT '000,001,002,010'.
DEFINE VAR X-MATRIS AS INT.

/*******Inicializa la Tabla Temporal ******/
FOR EACH tmp-tempo :
  DELETE tmp-tempo.
END.
/********************************/

  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = S-CODCIA
        AND  Almmmatg.codfam BEGINS F-CodFam
        USE-INDEX matg09:
      FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
                AND Gn-Divi.CodDiv BEGINS F-DIVISION:
        FOR EACH Evtclarti NO-LOCK WHERE Evtclarti.CodCia = S-CODCIA
                     AND   Evtclarti.CodDiv = Gn-Divi.Coddiv
                     AND   Evtclarti.Codmat = Almmmatg.codmat
                     AND   (Evtclarti.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
                     AND   Evtclarti.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99"))):
            DISPLAY Evtclarti.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo " FORMAT "X(11)" WITH FRAME F-Proceso.
            FIND gn-clie where gn-clie.codcia = cl-codcia and
                               gn-clie.codcli = evtclarti.codcli
                               no-lock no-error.
            IF F-CANAL <> "" AND F-Canal <> Gn-Clie.Canal THEN NEXT .
            X-DESCANAL =''.                                   
            FIND almtabla WHERE almtabla.Tabla = 'CN' AND almtabla.Codigo = gn-clie.Canal
                  NO-LOCK NO-ERROR.
            IF Available Almtabla THEN X-DESCANAL = almtabla.nombre.
            X-DESFAM=''.
            FIND AlmtFami WHERE AlmtFami.Codcia = S-CODCIA 
                AND  AlmtFami.CodFam  =  Almmmatg.codfam 
                NO-LOCK NO-ERROR.
            IF AVAILABLE AlmtFami THEN X-DESFAM = AlmtFami.DesFam.
            ASSIGN
                T-Vtamn   = 0
                T-Vtame   = 0
                T-Ctomn   = 0
                T-Ctome   = 0
                F-Salida  = 0.
            /*****************Capturando el Mes siguiente *******************/
            IF Evtclarti.Codmes < 12 THEN DO:
              ASSIGN
                  X-CODMES = Evtclarti.Codmes + 1
                  X-CODANO = Evtclarti.Codano.
            END.
            ELSE DO: 
              ASSIGN
                  X-CODMES = 01
                  X-CODANO = Evtclarti.Codano + 1.
            END.
            /**********************************************************************/
            
            /*********************** Calculo Para Obtener los datos diarios ************/
             DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
                  X-FECHA = DATE(STRING(I,"99") + "/" + STRING(Evtclarti.Codmes,"99") + "/" + STRING(Evtclarti.Codano,"9999")).
                  IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
                      FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(Evtclarti.Codmes,"99") + "/" + STRING(Evtclarti.Codano,"9999")) NO-LOCK NO-ERROR.
                      IF AVAILABLE Gn-tcmb THEN DO: 
                       F-Salida  = F-Salida  + Evtclarti.CanxDia[I].
                       T-Vtamn   = T-Vtamn   + Evtclarti.Vtaxdiamn[I] + Evtclarti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                       T-Vtame   = T-Vtame   + Evtclarti.Vtaxdiame[I] + Evtclarti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                      END.
                  END.
             END.         
            /******************************************************************************/      
            FIND tmp-tempo WHERE t-codcia  = S-CODCIA
                AND  t-canal  = gn-clie.canal    
                AND t-periodo = EvtClArti.Codano
                AND t-mes     = EvtClArti.Codmes  
                NO-ERROR.
      
            IF NOT AVAIL tmp-tempo THEN DO:
              CREATE tmp-tempo.
              ASSIGN t-codcia  = S-CODCIA
                     t-canal   = gn-clie.Canal
                     t-periodo = Evtclarti.codano
                     t-mes     = Evtclarti.codmes
                     t-Clase   = Almmmatg.Clase
                     t-codfam  = Almmmatg.codfam 
                     t-subfam  = Almmmatg.subfam
                     t-prove   = Almmmatg.CodPr1
                     t-codmat  = Evtclarti.codmat
                     t-desmat  = Almmmatg.DesMat
                     t-desmar  = Almmmatg.DesMar
                     t-undbas  = Almmmatg.UndBas
                     t-desfam  = X-DESFAM.
            END.
            X-MATRIS = LOOKUP(TRIM(AlmmmatG.codfam), X-FAMILIAS).
            IF X-MATRIS = 0 THEN X-MATRIS = 9.
            ASSIGN 
                T-Canti[X-MATRIS] = T-Canti[X-MATRIS] + F-Salida 
                T-Venta[X-MATRIS] = T-venta[X-MATRIS] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[X-MATRIS] = T-Costo[X-MATRIS] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
        END.
    END.
  END.
  FOR EACH tmp-tempo:
    ASSIGN
        T-Canti[10] = T-Canti[1] + T-Canti[2] + T-Canti[3] + T-Canti[4] + T-Canti[9]
        T-Venta[10] = T-Venta[1] + T-Venta[2] + T-Venta[3] + T-Venta[4] + T-Venta[9]
        T-Costo[10] = T-Costo[1] + T-Costo[2] + T-Costo[3] + T-Costo[4] + T-Costo[9].
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
  DISPLAY C-tipo FILL-IN-periodo C-tipo-2 F-DIVISION F-CodFam F-DIVISION-1 
          F-NOMDIV-1 F-Canal F-DIVISION-2 F-NOMDIV-2 F-NOMDIV-3 F-DIVISION-3 
          F-DIVISION-4 F-NOMDIV-4 DesdeF HastaF F-DIVISION-5 F-NOMDIV-5 
          F-DIVISION-6 F-NOMDIV-6 nCodMon 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-58 RECT-62 RECT-61 RECT-63 C-tipo FILL-IN-periodo C-tipo-2 
         F-DIVISION BUTTON-5 F-CodFam BUTTON-1 F-DIVISION-1 F-Canal BUTTON-2 
         F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 DesdeF HastaF F-DIVISION-5 
         F-DIVISION-6 nCodMon Btn_OK Btn_Cancel Btn_Help 
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
         t-venta[10]  FORMAT "->>>>>>>9.99"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + ")"  AT 100 FORMAT "X(25)" SKIP(1)
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Pagina : " TO 135 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         X-CANAL  AT 1  FORMAT "X(60)" 
         X-FAMILIA  AT 1  FORMAT "X(60)" 
         "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         X-ARTI   AT 1  FORMAT "X(60)" 
         X-MARCA  AT 80  FORMAT "X(60)" SKIP
         X-MONEDA AT 80  FORMAT "X(60)" SKIP
         "DIVISIONES EVALUADAS  : " + X-CODDIV At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        SUBSTRING(F-NOMDIV-1,1,10) AT  63 
        SUBSTRING(F-NOMDIV-2,1,10) AT  75 
        SUBSTRING(F-NOMDIV-3,1,10) AT  85 
        SUBSTRING(F-NOMDIV-4,1,10) AT  95 
        SUBSTRING(F-NOMDIV-5,1,10) AT  105
        SUBSTRING(F-NOMDIV-6,1,10) AT  115
        "O T R O S"  AT  125
        "T O T A L"  AT  140 SKIP
        " CODIGO  D E S C R I P C I O N                MARCA   U.M     CANTIDAD   CANTIDAD  CANTIDAD  CANTIDAD   CANTIDAD  CANTIDAD   CANTIDAD  CANTIDAD  IMPORTE    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo BREAK BY t-codcia
                           BY t-canal                      
                           BY t-codfam
                           BY t-codmat:

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-canal) THEN DO:
         FIND AlmTabla WHERE AlmTabla.Tabla = 'CN' 
                       AND  AlmTabla.Codigo = t-canal 
                      NO-LOCK NO-ERROR.
         IF AVAILABLE AlmTabla THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "CANAL : "  FORMAT "X(13)" AT 1 
                                 t-canal         FORMAT "X(15)" AT 15
                                 AlmTabla.Nombre  + {&PRN6B} FORMAT "X(40)" AT 35 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.
                          
         END.  
      END.


      IF FIRST-OF(t-codfam) THEN DO:
         FIND AlmtFami WHERE AlmtFami.Codcia = S-CODCIA 
                       AND  AlmtFami.CodFam  =  t-codFam 
                      NO-LOCK NO-ERROR.
         IF AVAILABLE AlmtFami THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "FAMILIA : "  FORMAT "X(13)" AT 8 
                                 t-codFam         FORMAT "X(15)" AT 25
                                 AlmtFami.DesFam  + {&PRN6B} FORMAT "X(40)" AT 45 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" AT 8 SKIP.
                          
         END.  
      END.
      
      ACCUM  t-venta[10]  (SUB-TOTAL BY t-codfam) .      
      ACCUM  t-venta[10]  (SUB-TOTAL BY t-canal) .
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
                t-venta[10]  FORMAT "->>>>>>>9.99"
                t-canti[10]  FORMAT "->>>>>>>9.99"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-codfam) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL FAMILIA : " + t-codfam) @ t-desmat
            (ACCUM SUB-TOTAL BY t-codfam  t-venta[10]) @ t-venta[10] 
            WITH FRAME F-REPORTE.
      END.


      IF LAST-OF(t-canal) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL CANAL : " + t-canal) @ t-desmat
            (ACCUM SUB-TOTAL BY t-canal t-venta[10]) @ t-venta[10] 
            WITH FRAME F-REPORTE.
      END.

  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            {&PRN6A} + ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-venta[10]) @ t-venta[10]
            WITH FRAME F-REPORTE.
      END.

  END.
   
  

  HIDE FRAME F-PROCESO.
  
 
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
         t-venta[10]  FORMAT "->>>>>>>9.99"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + ")"  AT 100 FORMAT "X(25)" SKIP(1)
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Pagina : " TO 135 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         X-CANAL  AT 1  FORMAT "X(60)" 
         X-FAMILIA  AT 1  FORMAT "X(60)" 
         "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         X-ARTI   AT 1  FORMAT "X(60)" 
         X-MARCA  AT 80  FORMAT "X(60)" SKIP
         X-MONEDA AT 80  FORMAT "X(60)" SKIP
         "DIVISIONES EVALUADAS  : " + X-CODDIV At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        SUBSTRING(F-NOMDIV-1,1,10) AT  63 
        SUBSTRING(F-NOMDIV-2,1,10) AT  75 
        SUBSTRING(F-NOMDIV-3,1,10) AT  85 
        SUBSTRING(F-NOMDIV-4,1,10) AT  95 
        SUBSTRING(F-NOMDIV-5,1,10) AT  105
        SUBSTRING(F-NOMDIV-6,1,10) AT  115
        "O T R O S"  AT  125
        "T O T A L"  AT  140 SKIP
        " CODIGO  D E S C R I P C I O N                MARCA   U.M     CANTIDAD   CANTIDAD  CANTIDAD  CANTIDAD   CANTIDAD  CANTIDAD   CANTIDAD  CANTIDAD  IMPORTE    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo BREAK BY t-codcia
                           BY t-canal                      
                           BY t-codfam
                           BY t-codmat:

      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-canal) THEN DO:
         FIND AlmTabla WHERE AlmTabla.Tabla = 'CN' 
                       AND  AlmTabla.Codigo = t-canal 
                      NO-LOCK NO-ERROR.
         IF AVAILABLE AlmTabla THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "CANAL : "  FORMAT "X(13)" AT 1 
                                 t-canal         FORMAT "X(15)" AT 15
                                 AlmTabla.Nombre  + {&PRN6B} FORMAT "X(40)" AT 35 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.
                          
         END.  
      END.


      IF FIRST-OF(t-codfam) THEN DO:
         FIND AlmtFami WHERE AlmtFami.Codcia = S-CODCIA 
                       AND  AlmtFami.CodFam  =  t-codFam 
                      NO-LOCK NO-ERROR.
         IF AVAILABLE AlmtFami THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "FAMILIA : "  FORMAT "X(13)" AT 8 
                                 t-codFam         FORMAT "X(15)" AT 25
                                 AlmtFami.DesFam  + {&PRN6B} FORMAT "X(40)" AT 45 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" AT 8 SKIP.
                          
         END.  
      END.
      
      ACCUM  t-venta[10]  (SUB-TOTAL BY t-codfam) .      
      ACCUM  t-venta[10]  (SUB-TOTAL BY t-canal) .
      ACCUM  t-venta[10]  ( TOTAL BY t-codcia) .
      
      DISPLAY STREAM REPORT 
                t-codmat
                t-DesMat
                t-DesMar
                t-UndBas
                t-venta[1] WHEN  t-venta[1] > 0 FORMAT "->>>>>>>9"
                t-venta[2] WHEN  t-venta[2] > 0 FORMAT "->>>>>>>9"
                t-venta[3] WHEN  t-venta[3] > 0 FORMAT "->>>>>>>9"
                t-venta[4] WHEN  t-venta[4] > 0 FORMAT "->>>>>>>9"
                t-venta[5] WHEN  t-venta[5] > 0 FORMAT "->>>>>>>9"
                t-venta[6] WHEN  t-venta[6] > 0 FORMAT "->>>>>>>9"
                t-venta[7] WHEN  t-venta[7] > 0 FORMAT "->>>>>>>9"
                t-venta[10]  FORMAT "->>>>>>>9.99"
                t-canti[10]  FORMAT "->>>>>>>9.99"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-codfam) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL FAMILIA : " + t-codfam) @ t-desmat
            (ACCUM SUB-TOTAL BY t-codfam  t-venta[10]) @ t-venta[10] 
            WITH FRAME F-REPORTE.
      END.


      IF LAST-OF(t-canal) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL CANAL : " + t-canal) @ t-desmat
            (ACCUM SUB-TOTAL BY t-canal t-venta[10]) @ t-venta[10] 
            WITH FRAME F-REPORTE.
      END.

  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            {&PRN6A} + ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-venta[10]) @ t-venta[10]
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
  DEFINE FRAME F-REPORTE
    t-periodo   FORMAT '9999'           COLUMN-LABEL 'Periodo'
    t-mes       FORMAT '99'             COLUMN-LABEL 'Mes'
    t-canti[1]  FORMAT '->>>,>>>,>>9'   COLUMN-LABEL 'Linea!000'
    t-canti[2]  FORMAT '->>>,>>>,>>9'  COLUMN-LABEL 'Linea!001'
    t-canti[3]  FORMAT '->>>,>>>,>>9'  COLUMN-LABEL 'Linea!002'
    t-canti[4]  FORMAT '->>>,>>>,>>9'  COLUMN-LABEL 'Linea!010'
    t-canti[9]  FORMAT '->>>,>>>,>>9'  COLUMN-LABEL 'Linea!Otros'
    t-canti[10] FORMAT '->>>,>>>,>>9'  COLUMN-LABEL 'Linea!Total'
    WITH PAGE-TOP WIDTH 200 NO-BOX NO-LABELS STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
    HEADER
        S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
        X-TITU AT 20 FORMAT "X(50)" 
        "(" + C-TIPO + ")"  FORMAT "X(25)" SKIP(1)
        "Pagina : " TO 80 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "Fecha  :"  TO 80 TODAY FORMAT "99/99/9999" SKIP
        "PERIODO:" DesdeF "al" HastaF
        "Hora   :"  TO 80 STRING(TIME,"HH:MM:SS") SKIP
        X-MONEDA FORMAT "X(60)" SKIP
        "DIVISIONES EVALUADAS:" X-CODDIV FORMAT "X(80)" SKIP
        "-----------------------------------------------------------------------------------------" SKIP
        "Periodo Mes        Linea        Linea        Linea        Linea        Linea        Linea" SKIP
        "                    000          001          002          010         Otros        Total" SKIP
        "-----------------------------------------------------------------------------------------" SKIP
/*
            9999  99 ->>>,>>>,>>9 ->>>,>>>,>>9 ->>>,>>>,>>9 ->>>,>>>,>>9 ->>>,>>>,>>9 ->>>,>>>,>>9
        12345678901234567890123456789012345678901234567890123456789012345678901234567890
                 1         2         3         4         5         6         7        
*/

    WITH PAGE-TOP WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME F-QUIEBRE
    t-canal Almtabla.nombre SKIP
    WITH STREAM-IO NO-BOX NO-LABELS NO-UNDERLINE DOWN.
    
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn3} .

  FOR EACH tmp-tempo BREAK BY t-codcia
                           BY t-canal                      
                           BY t-periodo
                           BY t-mes:
    VIEW STREAM REPORT FRAME F-HEADER.
    DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
    IF FIRST-OF(t-canal) THEN DO:
        FIND Almtabla WHERE Almtabla.tabla = 'CN'
            AND Almtabla.codigo = t-canal NO-LOCK NO-ERROR.
        DISPLAY STREAM REPORT
            t-canal
            Almtabla.nombre WHEN AVAILABLE Almtabla
            WITH FRAME F-QUIEBRE.
    END.
    ACCUMULATE t-canti[1] (TOTAL BY t-canal).
    ACCUMULATE t-canti[2] (TOTAL BY t-canal).
    ACCUMULATE t-canti[3] (TOTAL BY t-canal).
    ACCUMULATE t-canti[4] (TOTAL BY t-canal).
    ACCUMULATE t-canti[9] (TOTAL BY t-canal).
    ACCUMULATE t-canti[10] (TOTAL BY t-canal).
    ACCUMULATE t-canti[1] (TOTAL BY t-codcia).
    ACCUMULATE t-canti[2] (TOTAL BY t-codcia).
    ACCUMULATE t-canti[3] (TOTAL BY t-codcia).
    ACCUMULATE t-canti[4] (TOTAL BY t-codcia).
    ACCUMULATE t-canti[9] (TOTAL BY t-codcia).
    ACCUMULATE t-canti[10] (TOTAL BY t-codcia).
    DISPLAY STREAM REPORT 
        t-periodo   
        t-mes       
        t-canti[1]  
        t-canti[2]  
        t-canti[3]  
        t-canti[4]  
        t-canti[9]  
        t-canti[10] 
        WITH FRAME F-REPORTE.
    IF LAST-OF(t-canal) THEN DO:
        UNDERLINE STREAM REPORT
            t-canti[1]
            t-canti[2]
            t-canti[3]
            t-canti[4]
            t-canti[9]
            t-canti[10]
            WITH FRAME F-REPORTE.
        DOWN STREAM REPORT WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT
            ACCUM TOTAL BY t-canal t-canti[1] @ t-canti[1]
            ACCUM TOTAL BY t-canal t-canti[2] @ t-canti[2]
            ACCUM TOTAL BY t-canal t-canti[3] @ t-canti[3]
            ACCUM TOTAL BY t-canal t-canti[4] @ t-canti[4]
            ACCUM TOTAL BY t-canal t-canti[9] @ t-canti[9]
            ACCUM TOTAL BY t-canal t-canti[10] @ t-canti[10]
            WITH FRAME F-REPORTE.
        DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
    END.
    IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT
            t-canti[1]
            t-canti[2]
            t-canti[3]
            t-canti[4]
            t-canti[9]
            t-canti[10]
            WITH FRAME F-REPORTE.
        DOWN STREAM REPORT WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT
            ACCUM TOTAL BY t-codcia t-canti[1] @ t-canti[1]
            ACCUM TOTAL BY t-codcia t-canti[2] @ t-canti[2]
            ACCUM TOTAL BY t-codcia t-canti[3] @ t-canti[3]
            ACCUM TOTAL BY t-codcia t-canti[4] @ t-canti[4]
            ACCUM TOTAL BY t-codcia t-canti[9] @ t-canti[9]
            ACCUM TOTAL BY t-codcia t-canti[10] @ t-canti[10]
            WITH FRAME F-REPORTE.
    END.
  END.
  HIDE FRAME F-PROCESO.

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
    t-periodo   FORMAT '9999'           COLUMN-LABEL 'Periodo'
    t-mes       FORMAT '99'             COLUMN-LABEL 'Mes'
    t-venta[1]  FORMAT '->>>,>>>,>>9'   COLUMN-LABEL 'Linea!000'
    t-venta[2]  FORMAT '->>>,>>>,>>9'  COLUMN-LABEL 'Linea!001'
    t-venta[3]  FORMAT '->>>,>>>,>>9'  COLUMN-LABEL 'Linea!002'
    t-venta[4]  FORMAT '->>>,>>>,>>9'  COLUMN-LABEL 'Linea!010'
    t-venta[9]  FORMAT '->>>,>>>,>>9'  COLUMN-LABEL 'Linea!Otros'
    t-venta[10] FORMAT '->>>,>>>,>>9'  COLUMN-LABEL 'Linea!Total'
    WITH PAGE-TOP WIDTH 200 NO-BOX NO-LABELS STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
    HEADER
        S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
        X-TITU AT 20 FORMAT "X(50)" 
        "(" + C-TIPO + ")"  FORMAT "X(25)" SKIP(1)
        "Pagina : " TO 80 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "Fecha  :"  TO 80 TODAY FORMAT "99/99/9999" SKIP
        "PERIODO:" DesdeF "al" HastaF
        "Hora   :"  TO 80 STRING(TIME,"HH:MM:SS") SKIP
        X-MONEDA FORMAT "X(60)" SKIP
        "DIVISIONES EVALUADAS:" X-CODDIV FORMAT "X(80)" SKIP
        "-----------------------------------------------------------------------------------------" SKIP
        "Periodo Mes        Linea        Linea        Linea        Linea        Linea        Linea" SKIP
        "                    000          001          002          010         Otros        Total" SKIP
        "-----------------------------------------------------------------------------------------" SKIP
/*
            9999  99 ->>>,>>>,>>9 ->>>,>>>,>>9 ->>>,>>>,>>9 ->>>,>>>,>>9 ->>>,>>>,>>9 ->>>,>>>,>>9
        12345678901234567890123456789012345678901234567890123456789012345678901234567890
                 1         2         3         4         5         6         7        
*/

    WITH PAGE-TOP WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME F-QUIEBRE
    t-canal Almtabla.nombre SKIP
    WITH STREAM-IO NO-BOX NO-LABELS NO-UNDERLINE DOWN.
    
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn3} .

  FOR EACH tmp-tempo BREAK BY t-codcia
                           BY t-canal                      
                           BY t-periodo
                           BY t-mes:
    VIEW STREAM REPORT FRAME F-HEADER.
    DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
    IF FIRST-OF(t-canal) THEN DO:
        FIND Almtabla WHERE Almtabla.tabla = 'CN'
            AND Almtabla.codigo = t-canal NO-LOCK NO-ERROR.
        DISPLAY STREAM REPORT
            t-canal
            Almtabla.nombre WHEN AVAILABLE Almtabla
            WITH FRAME F-QUIEBRE.
    END.
    ACCUMULATE t-venta[1] (TOTAL BY t-canal).
    ACCUMULATE t-venta[2] (TOTAL BY t-canal).
    ACCUMULATE t-venta[3] (TOTAL BY t-canal).
    ACCUMULATE t-venta[4] (TOTAL BY t-canal).
    ACCUMULATE t-venta[9] (TOTAL BY t-canal).
    ACCUMULATE t-venta[10] (TOTAL BY t-canal).
    ACCUMULATE t-venta[1] (TOTAL BY t-codcia).
    ACCUMULATE t-venta[2] (TOTAL BY t-codcia).
    ACCUMULATE t-venta[3] (TOTAL BY t-codcia).
    ACCUMULATE t-venta[4] (TOTAL BY t-codcia).
    ACCUMULATE t-venta[9] (TOTAL BY t-codcia).
    ACCUMULATE t-venta[10] (TOTAL BY t-codcia).
    DISPLAY STREAM REPORT 
        t-periodo   
        t-mes       
        t-venta[1]  
        t-venta[2]  
        t-venta[3]  
        t-venta[4]  
        t-venta[9]  
        t-venta[10] 
        WITH FRAME F-REPORTE.
    IF LAST-OF(t-canal) THEN DO:
        UNDERLINE STREAM REPORT
            t-venta[1]
            t-venta[2]
            t-venta[3]
            t-venta[4]
            t-venta[9]
            t-venta[10]
            WITH FRAME F-REPORTE.
        DOWN STREAM REPORT WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT
            ACCUM TOTAL BY t-canal t-venta[1] @ t-venta[1]
            ACCUM TOTAL BY t-canal t-venta[2] @ t-venta[2]
            ACCUM TOTAL BY t-canal t-venta[3] @ t-venta[3]
            ACCUM TOTAL BY t-canal t-venta[4] @ t-venta[4]
            ACCUM TOTAL BY t-canal t-venta[9] @ t-venta[9]
            ACCUM TOTAL BY t-canal t-venta[10] @ t-venta[10]
            WITH FRAME F-REPORTE.
        DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
    END.
    IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT
            t-venta[1]
            t-venta[2]
            t-venta[3]
            t-venta[4]
            t-venta[9]
            t-venta[10]
            WITH FRAME F-REPORTE.
        DOWN STREAM REPORT WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT
            ACCUM TOTAL BY t-codcia t-venta[1] @ t-venta[1]
            ACCUM TOTAL BY t-codcia t-venta[2] @ t-venta[2]
            ACCUM TOTAL BY t-codcia t-venta[3] @ t-venta[3]
            ACCUM TOTAL BY t-codcia t-venta[4] @ t-venta[4]
            ACCUM TOTAL BY t-codcia t-venta[9] @ t-venta[9]
            ACCUM TOTAL BY t-codcia t-venta[10] @ t-venta[10]
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

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    CASE C-Tipo:
        WHEN "Canal-Articulo" THEN RUN Carga-Temporal.
        WHEN "Canal-Familia" THEN RUN Carga-Temporal-2.
    END CASE.

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        CASE C-Tipo:
            WHEN "Canal-Articulo" THEN DO:
                CASE C-tipo-2:
                    WHEN 'Venta'    THEN RUN Formato1A.
                    WHEN 'Cantidad' THEN RUN Formato1.
                END CASE.
            END.
            WHEN "Canal-Familia" THEN DO:
                CASE C-tipo-2:
                    WHEN 'Venta'    THEN RUN Formato2A.
                    WHEN 'Cantidad' THEN RUN Formato2.
                END CASE.
            END.
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
         F-Canal 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESA-NOTA W-Win 
PROCEDURE PROCESA-NOTA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH CcbDdocu OF CcbCdocu:
    x-can = IF CcbDdocu.CodMat = "00005" THEN 1 ELSE 0.
END.

FIND B-CDOCU WHERE B-CDOCU.Codcia = CcbCdocu.Codcia AND
                   B-CDOCU.CodDoc = CcbCdocu.Codref AND
                   B-CDOCU.NroDoc = CcbCdocu.Nroref 
                   NO-LOCK NO-ERROR.
IF AVAILABLE B-CDOCU THEN DO:
           x-coe = CcbCdocu.ImpTot / B-CDOCU.ImpTot.
           FOR EACH CcbDdocu OF B-CDOCU NO-LOCK:
               
               FIND Almmmatg WHERE Almmmatg.Codcia = CcbDdocu.Codcia AND
                                   Almmmatg.CodMat = CcbDdocu.CodMat NO-LOCK NO-ERROR.
               IF NOT AVAILABLE Almmmatg THEN NEXT.
               FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                                   Almtconv.Codalter = Ccbddocu.UndVta
                                   NO-LOCK NO-ERROR.
               F-FACTOR  = 1. 
               IF AVAILABLE Almtconv THEN DO:
                  F-FACTOR = Almtconv.Equival.
                  IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
               END.
               
               IF Ccbcdocu.CodMon = 1 THEN 
                    ASSIGN
                       EvtArti.VtaxMesMn = EvtArti.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin * x-coe
                       EvtArti.VtaxMesMe = EvtArti.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin * x-coe / x-TpoCmbCmp.
               IF Ccbcdocu.CodMon = 2 THEN 
                    ASSIGN
                        EvtArti.VtaxMesMn = EvtArti.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta * x-coe
                        EvtArti.VtaxMesMe = EvtArti.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin * x-coe.
               ASSIGN            
               EvtArti.CanxMes = EvtArti.CanxMes + ( x-signo1 * CcbDdocu.CanDes * F-FACTOR * x-can).

           END.  
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


IF F-CANAL <> "" THEN DO:
        DO I = 1 TO NUM-ENTRIES(F-Canal):
          FIND AlmTabla WHERE AlmTabla.Tabla = 'CN' AND
                              AlmTabla.Codigo = ENTRY(I,F-Canal) NO-LOCK NO-ERROR.
          IF NOT AVAILABLE AlmTabla THEN DO:
            MESSAGE "Canal " + ENTRY(I,F-Canal) + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-Canal IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.                             
        END.
END.


RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

