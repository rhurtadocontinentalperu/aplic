&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME codW-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS codW-Win 
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
    FIELD t-codcli  LIKE Evtclarti.Codcli
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
&Scoped-Define ENABLED-OBJECTS RECT-62 RECT-58 RECT-63 RECT-61 C-tipo ~
C-tipo-2 F-clien BUTTON-4 DesdeC DesdeF HastaF nCodMon Btn_OK Btn_Cancel ~
Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS C-tipo F-DIVISION C-tipo-2 F-clien DesdeC ~
F-DIVISION-1 F-NOMDIV-1 DesdeF HastaF F-DIVISION-2 F-NOMDIV-2 F-NOMDIV-3 ~
F-DIVISION-3 F-DIVISION-4 F-NOMDIV-4 F-DIVISION-5 F-NOMDIV-5 F-DIVISION-6 ~
F-NOMDIV-6 nCodMon txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR codW-Win AS WIDGET-HANDLE NO-UNDO.

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

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-clien AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-DIVISION AS CHARACTER FORMAT "X(5)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-DIVISION-1 AS CHARACTER FORMAT "X(5)":U 
     LABEL "1" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .69 NO-UNDO.

DEFINE VARIABLE F-DIVISION-2 AS CHARACTER FORMAT "X(5)":U 
     LABEL "2" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .69 NO-UNDO.

DEFINE VARIABLE F-DIVISION-3 AS CHARACTER FORMAT "X(5)":U 
     LABEL "3" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .69 NO-UNDO.

DEFINE VARIABLE F-DIVISION-4 AS CHARACTER FORMAT "X(5)":U 
     LABEL "4" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .69 NO-UNDO.

DEFINE VARIABLE F-DIVISION-5 AS CHARACTER FORMAT "X(5)":U 
     LABEL "5" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .69 NO-UNDO.

DEFINE VARIABLE F-DIVISION-6 AS CHARACTER FORMAT "X(5)":U 
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

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .81 NO-UNDO.

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
     SIZE 45.14 BY 9.85
     BGCOLOR 3 .

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.86 BY 5.35.

DEFINE RECTANGLE RECT-63
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.86 BY 1.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     C-tipo AT ROW 2.19 COL 49.43 COLON-ALIGNED HELP
          "coloque el codigo" NO-LABEL
     F-DIVISION AT ROW 3.12 COL 11.57 COLON-ALIGNED
     BUTTON-5 AT ROW 3.12 COL 25.29
     C-tipo-2 AT ROW 3.15 COL 49.43 COLON-ALIGNED NO-LABEL
     F-clien AT ROW 3.92 COL 11.57 COLON-ALIGNED
     BUTTON-4 AT ROW 3.92 COL 25.14
     DesdeC AT ROW 4.65 COL 11.57 COLON-ALIGNED
     F-DIVISION-1 AT ROW 5.08 COL 49.14 COLON-ALIGNED
     F-NOMDIV-1 AT ROW 5.12 COL 55.57 COLON-ALIGNED NO-LABEL
     DesdeF AT ROW 5.35 COL 11.57 COLON-ALIGNED
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
     Btn_OK AT ROW 11.38 COL 37
     Btn_Cancel AT ROW 11.38 COL 48.29
     Btn_Help AT ROW 11.38 COL 59.72
     txt-msj AT ROW 11.77 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1.35 COL 4.43
          FONT 6
     " Moneda" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 9.92 COL 49.57
          FONT 6
     " Tipo de Reporte" VIEW-AS TEXT
          SIZE 14.57 BY .65 AT ROW 1.27 COL 48.43
          FONT 6
     " Desplegar Divisiones" VIEW-AS TEXT
          SIZE 18 BY .5 AT ROW 4.38 COL 49
          FONT 6
     RECT-62 AT ROW 4.5 COL 47.29
     RECT-58 AT ROW 1.54 COL 47.43
     RECT-46 AT ROW 11.42 COL 2
     RECT-63 AT ROW 10 COL 47.29
     RECT-61 AT ROW 1.54 COL 2
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
  CREATE WINDOW codW-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Venta de Articulos x Cliente"
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
IF NOT codW-Win:LOAD-ICON("img\climnu3":U) THEN
    MESSAGE "Unable to load icon: img\climnu3"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB codW-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW codW-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON BUTTON-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DIVISION IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DIVISION-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DIVISION-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DIVISION-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DIVISION-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DIVISION-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DIVISION-6 IN FRAME F-Main
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
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(codW-Win)
THEN codW-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME codW-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL codW-Win codW-Win
ON END-ERROR OF codW-Win /* Venta de Articulos x Cliente */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL codW-Win codW-Win
ON WINDOW-CLOSE OF codW-Win /* Venta de Articulos x Cliente */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel codW-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help codW-Win
ON CHOOSE OF Btn_Help IN FRAME F-Main /* Ayuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
MESSAGE "Help for File: {&FILE-NAME}":U VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK codW-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  RUN Asigna-Variables.
  RUN Valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR". 
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
  DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 codW-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "".
    output-var-2 = "".
    RUN lkup\C-client.r("Clientes").
    IF output-var-2 <> ? THEN DO:
        F-CLIEN = output-var-2.
        DISPLAY F-CLIEN.
        APPLY "ENTRY" TO F-CLIEN .
        RETURN NO-APPLY.

    END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 codW-Win
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-tipo codW-Win
ON VALUE-CHANGED OF C-tipo IN FRAME F-Main
DO:
  DO WITH FRAME {&FRAME-NAME}:

  ASSIGN C-TIPO.
  END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-tipo-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-tipo-2 codW-Win
ON VALUE-CHANGED OF C-tipo-2 IN FRAME F-Main
DO:
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN C-TIPO-2 .  
  END.
    
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC codW-Win
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


&Scoped-define SELF-NAME F-clien
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-clien codW-Win
ON LEAVE OF F-clien IN FRAME F-Main /* Cliente */
DO:
  ASSIGN F-clien .
  IF F-clien <> "" THEN DO: 
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
          gn-clie.Codcli = F-clien NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-clie THEN DO:
        MESSAGE "Codigo de Cliente NO Existe " SKIP
                "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO F-Clien IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.     
     END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK codW-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

/* Include custom  Main Block code for SmartWindows. */

{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects codW-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available codW-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables codW-Win 
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
         F-Clien 
         DesdeC 
         DesdeF 
         HastaF 
         nCodMon
         C-tipo-2 .
  X-ARTI        = "ARTICULOS    : " + DesdeC.
  X-PROVE       = "PROVEEDOR    : "  + F-CLIEN.
    
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal codW-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR X-ENTRA AS LOGICAL INIT FALSE.

/*******Inicializa la Tabla Temporal ******/
EMPTY TEMP-TABLE tmp-tempo.

FOR EACH Ventas_Cabecera NO-LOCK WHERE Ventas_Cabecera.CodDiv = F-DIVISION-1
    AND (F-clien = '' OR Ventas_Cabecera.CodCli = F-clien)
    AND Ventas_Cabecera.DateKey >= DesdeF
    AND Ventas_Cabecera.DateKey <= HastaF,
    EACH Ventas_Detalle OF Ventas_Cabecera WHERE (DesdeC= '' OR Ventas_Detalle.CodMat = DesdeC),
    FIRST DimProducto OF Ventas_Detalle NO-LOCK:
    DISPLAY "Codigo de Articulo: " + Ventas_Detalle.CodMat @ txt-msj 
        WITH FRAME {&FRAME-NAME}.
    ASSIGN
        T-Vtamn   = 0
        T-Vtame   = 0
        T-Ctomn   = 0
        T-Ctome   = 0
        F-Salida  = 0.
    ASSIGN
        F-Salida  = F-Salida  + Ventas_Detalle.Cantidad
        T-Vtamn   = T-Vtamn   + Ventas_Detalle.ImpNacCIGV
        T-Vtame   = T-Vtame   + Ventas_Detalle.ImpExtCIGV
        T-Ctomn   = T-Ctomn   + Ventas_Detalle.CostoNacCIGV
        T-Ctome   = T-Ctome   + Ventas_Detalle.CostoExtCIGV.
    FIND tmp-tempo WHERE t-codcia  = S-CODCIA
        AND  t-codcli  = Ventas_Cabecera.Codcli
        AND  t-codmat  = Ventas_Detalle.codmat
        NO-ERROR.
    IF NOT AVAIL tmp-tempo THEN DO:
        CREATE tmp-tempo.
        ASSIGN 
            t-codcia  = S-CODCIA
            /*t-Clase   = DimProducto.Clase*/
            t-codfam  = DimProducto.codfam 
            t-subfam  = DimProducto.subfam
            t-codcli  = Ventas_Cabecera.codcli
            t-codmat  = Ventas_Detalle.codmat
            t-desmat  = DimProducto.DesMat
            t-desmar  = DimProducto.DesMar
            t-undbas  = DimProducto.UndStk.
    END.
    ASSIGN T-Canti[10] = T-Canti[10] + F-Salida 
           T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
           T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
           T-Marge[10] = T-Marge[10] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
           T-Utili[10] = T-Utili[10] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).

    /******************************Secuencia Para Cargar Datos en las Columnas *****************/

    X-ENTRA = FALSE.
    IF F-DIVISION-1 <> "" AND Ventas_Detalle.Coddiv = F-DIVISION-1 THEN DO:
       ASSIGN T-Canti[1] = T-Canti[1] + F-Salida 
              T-Venta[1] = T-venta[1] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
              T-Costo[1] = T-Costo[1] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
              T-Marge[1] = T-Marge[1] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
              T-Utili[1] = T-Utili[1] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
              X-ENTRA = TRUE.
    END.       
    IF F-DIVISION-2 <> "" AND Ventas_Detalle.Coddiv = F-DIVISION-2 THEN DO:
       ASSIGN T-Canti[2] = T-Canti[2] + F-Salida 
              T-Venta[2] = T-venta[2] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
              T-Costo[2] = T-Costo[2] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
              T-Marge[2] = T-Marge[2] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
              T-Utili[2] = T-Utili[2] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
              X-ENTRA = TRUE.
    END.       
    IF F-DIVISION-3 <> "" AND Ventas_Detalle.Coddiv = F-DIVISION-3 THEN DO:
       ASSIGN T-Canti[3] = T-Canti[3] + F-Salida 
              T-Venta[3] = T-venta[3] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
              T-Costo[3] = T-Costo[3] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
              T-Marge[3] = T-Marge[3] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
              T-Utili[3] = T-Utili[3] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
              X-ENTRA = TRUE.
    END.       
    IF F-DIVISION-4 <> "" AND Ventas_Detalle.Coddiv = F-DIVISION-4 THEN DO:
       ASSIGN T-Canti[4] = T-Canti[4] + F-Salida  
              T-Venta[4] = T-venta[4] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
              T-Costo[4] = T-Costo[4] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
              T-Marge[4] = T-Marge[4] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
              T-Utili[4] = T-Utili[4] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
              X-ENTRA = TRUE.
    END.       
    IF F-DIVISION-5 <> "" AND Ventas_Detalle.Coddiv = F-DIVISION-5 THEN DO:
       ASSIGN T-Canti[5] = T-Canti[5] + F-Salida 
              T-Venta[5] = T-venta[5] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
              T-Costo[5] = T-Costo[5] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
              T-Marge[5] = T-Marge[5] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
              T-Utili[5] = T-Utili[5] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
              X-ENTRA = TRUE.
    END.       
    IF F-DIVISION-6 <> "" AND Ventas_Detalle.Coddiv = F-DIVISION-6 THEN DO:
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-1 codW-Win 
PROCEDURE Carga-Temporal-1 :
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
                                                  
    FOR EACH Evtclarti NO-LOCK WHERE Evtclarti.CodCia = S-CODCIA
                         AND   Evtclarti.CodDiv = Gn-Divi.Coddiv
                         AND   Evtclarti.CodCli = F-CLIEN
                         AND   Evtclarti.Codmat = DESDEC
                         AND   (Evtclarti.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
                         AND   Evtclarti.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) )
                         USE-INDEX LLAVE01,
         EACH Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                             Almmmatg.CodMat = Evtclarti.Codmat:
                         

      /*
      DISPLAY Evtclarti.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */

      DISPLAY "Codigo de Articulo: " + Evtclarti.CodMat @ txt-msj 
          WITH FRAME {&FRAME-NAME}.

      T-Vtamn   = 0.
      T-Vtame   = 0.
      T-Ctomn   = 0.
      T-Ctome   = 0.
      F-Salida  = 0.

      /*****************Capturando el Mes siguiente *******************/
      IF Evtclarti.Codmes < 12 THEN DO:
        ASSIGN
        X-CODMES = Evtclarti.Codmes + 1
        X-CODANO = Evtclarti.Codano .
      END.
      ELSE DO: 
        ASSIGN
        X-CODMES = 01
        X-CODANO = Evtclarti.Codano + 1 .
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
                 T-Ctomn   = T-Ctomn   + Evtclarti.Ctoxdiamn[I] + Evtclarti.Ctoxdiame[I] * Gn-Tcmb.Venta.
                 T-Ctome   = T-Ctome   + Evtclarti.Ctoxdiame[I] + Evtclarti.Ctoxdiamn[I] / Gn-Tcmb.Compra.
                END.
            END.
       END.         
      
      /******************************************************************************/      

      FIND tmp-tempo WHERE t-codcia  = S-CODCIA
                      AND  t-codcli  = Evtclarti.Codcli
                      AND  t-codmat  = Evtclarti.codmat
                     NO-ERROR.
      IF NOT AVAIL tmp-tempo THEN DO:
        CREATE tmp-tempo.
        ASSIGN t-codcia  = S-CODCIA
               t-Clase   = Almmmatg.Clase
               t-codfam  = Almmmatg.codfam 
               t-subfam  = Almmmatg.subfam
               t-codcli  = Evtclarti.codcli
               t-codmat  = Evtclarti.codmat
               t-desmat  = Almmmatg.DesMat
               t-desmar  = Almmmatg.DesMar
               t-undbas  = Almmmatg.UndBas.
      END.
      ASSIGN T-Canti[10] = T-Canti[10] + F-Salida 
             T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
             T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
             T-Marge[10] = T-Marge[10] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
             T-Utili[10] = T-Utili[10] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
      
      /******************************Secuencia Para Cargar Datos en las Columnas *****************/
      
      X-ENTRA = FALSE.
      IF F-DIVISION-1 <> "" AND Evtclarti.Coddiv = F-DIVISION-1 THEN DO:
         ASSIGN T-Canti[1] = T-Canti[1] + F-Salida 
                T-Venta[1] = T-venta[1] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[1] = T-Costo[1] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                T-Marge[1] = T-Marge[1] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
                T-Utili[1] = T-Utili[1] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-2 <> "" AND Evtclarti.Coddiv = F-DIVISION-2 THEN DO:
         ASSIGN T-Canti[2] = T-Canti[2] + F-Salida 
                T-Venta[2] = T-venta[2] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[2] = T-Costo[2] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                T-Marge[2] = T-Marge[2] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
                T-Utili[2] = T-Utili[2] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-3 <> "" AND Evtclarti.Coddiv = F-DIVISION-3 THEN DO:
         ASSIGN T-Canti[3] = T-Canti[3] + F-Salida 
                T-Venta[3] = T-venta[3] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[3] = T-Costo[3] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                T-Marge[3] = T-Marge[3] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
                T-Utili[3] = T-Utili[3] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-4 <> "" AND Evtclarti.Coddiv = F-DIVISION-4 THEN DO:
         ASSIGN T-Canti[4] = T-Canti[4] + F-Salida  
                T-Venta[4] = T-venta[4] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[4] = T-Costo[4] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                T-Marge[4] = T-Marge[4] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
                T-Utili[4] = T-Utili[4] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-5 <> "" AND Evtclarti.Coddiv = F-DIVISION-5 THEN DO:
         ASSIGN T-Canti[5] = T-Canti[5] + F-Salida 
                T-Venta[5] = T-venta[5] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[5] = T-Costo[5] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                T-Marge[5] = T-Marge[5] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
                T-Utili[5] = T-Utili[5] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-6 <> "" AND Evtclarti.Coddiv = F-DIVISION-6 THEN DO:
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-2 codW-Win 
PROCEDURE Carga-Temporal-2 :
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
                                                  
    FOR EACH Evtclarti NO-LOCK WHERE Evtclarti.CodCia = S-CODCIA
                         AND   Evtclarti.CodDiv = Gn-Divi.Coddiv
                         AND   Evtclarti.CodCli = F-CLIEN
                         AND   (Evtclarti.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
                         AND   Evtclarti.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) )
                         USE-INDEX LLAVE02,
         EACH Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                             Almmmatg.CodMat = Evtclarti.Codmat:
                         

      /*
      DISPLAY Evtclarti.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */
      
      DISPLAY "Codigo de Articulo: " + Evtclarti.CodMat @ txt-msj 
          WITH FRAME {&FRAME-NAME}.

      T-Vtamn   = 0.
      T-Vtame   = 0.
      T-Ctomn   = 0.
      T-Ctome   = 0.
      F-Salida  = 0.

      /*****************Capturando el Mes siguiente *******************/
      IF Evtclarti.Codmes < 12 THEN DO:
        ASSIGN
        X-CODMES = Evtclarti.Codmes + 1
        X-CODANO = Evtclarti.Codano .
      END.
      ELSE DO: 
        ASSIGN
        X-CODMES = 01
        X-CODANO = Evtclarti.Codano + 1 .
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
                 T-Ctomn   = T-Ctomn   + Evtclarti.Ctoxdiamn[I] + Evtclarti.Ctoxdiame[I] * Gn-Tcmb.Venta.
                 T-Ctome   = T-Ctome   + Evtclarti.Ctoxdiame[I] + Evtclarti.Ctoxdiamn[I] / Gn-Tcmb.Compra.
                END.
            END.
       END.         
      
      /******************************************************************************/      

      FIND tmp-tempo WHERE t-codcia  = S-CODCIA
                      AND  t-codcli  = Evtclarti.Codcli
                      AND  t-codmat  = Evtclarti.codmat
                     NO-ERROR.
      IF NOT AVAIL tmp-tempo THEN DO:
        CREATE tmp-tempo.
        ASSIGN t-codcia  = S-CODCIA
               t-Clase   = Almmmatg.Clase
               t-codfam  = Almmmatg.codfam 
               t-subfam  = Almmmatg.subfam
               t-codcli  = Evtclarti.codcli
               t-codmat  = Evtclarti.codmat
               t-desmat  = Almmmatg.DesMat
               t-desmar  = Almmmatg.DesMar
               t-undbas  = Almmmatg.UndBas.
      END.
      ASSIGN T-Canti[10] = T-Canti[10] + F-Salida 
             T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
             T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
             T-Marge[10] = T-Marge[10] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
             T-Utili[10] = T-Utili[10] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
      
      /******************************Secuencia Para Cargar Datos en las Columnas *****************/
      
      X-ENTRA = FALSE.
      IF F-DIVISION-1 <> "" AND Evtclarti.Coddiv = F-DIVISION-1 THEN DO:
         ASSIGN T-Canti[1] = T-Canti[1] + F-Salida 
                T-Venta[1] = T-venta[1] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[1] = T-Costo[1] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                T-Marge[1] = T-Marge[1] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
                T-Utili[1] = T-Utili[1] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-2 <> "" AND Evtclarti.Coddiv = F-DIVISION-2 THEN DO:
         ASSIGN T-Canti[2] = T-Canti[2] + F-Salida 
                T-Venta[2] = T-venta[2] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[2] = T-Costo[2] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                T-Marge[2] = T-Marge[2] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
                T-Utili[2] = T-Utili[2] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-3 <> "" AND Evtclarti.Coddiv = F-DIVISION-3 THEN DO:
         ASSIGN T-Canti[3] = T-Canti[3] + F-Salida 
                T-Venta[3] = T-venta[3] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[3] = T-Costo[3] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                T-Marge[3] = T-Marge[3] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
                T-Utili[3] = T-Utili[3] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-4 <> "" AND Evtclarti.Coddiv = F-DIVISION-4 THEN DO:
         ASSIGN T-Canti[4] = T-Canti[4] + F-Salida  
                T-Venta[4] = T-venta[4] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[4] = T-Costo[4] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                T-Marge[4] = T-Marge[4] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
                T-Utili[4] = T-Utili[4] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-5 <> "" AND Evtclarti.Coddiv = F-DIVISION-5 THEN DO:
         ASSIGN T-Canti[5] = T-Canti[5] + F-Salida 
                T-Venta[5] = T-venta[5] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[5] = T-Costo[5] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                T-Marge[5] = T-Marge[5] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
                T-Utili[5] = T-Utili[5] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-6 <> "" AND Evtclarti.Coddiv = F-DIVISION-6 THEN DO:
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-3 codW-Win 
PROCEDURE Carga-Temporal-3 :
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

                       
  FOR EACH Gn-Divi NO-LOCK WHERE Gn-Divi.Codcia = S-CODCIA AND Gn-Divi.CodDiv BEGINS F-DIVISION:
      FOR EACH Evtclarti NO-LOCK WHERE Evtclarti.CodCia = S-CODCIA
          AND Evtclarti.CodDiv = Gn-Divi.Coddiv
          AND Evtclarti.Codmat = DESDEC
          AND (Evtclarti.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
              AND Evtclarti.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) )
          USE-INDEX LLAVE03,
          FIRST Almmmatg  WHERE Almmmatg.Codcia = S-CODCIA AND
          Almmmatg.CodMat = Evtclarti.Codmat NO-LOCK:

          /*
          DISPLAY Evtclarti.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
            FORMAT "X(11)" WITH FRAME F-Proceso.
          */

          DISPLAY "Codigo de Articulo: " + Evtclarti.CodMat @ txt-msj 
              WITH FRAME {&FRAME-NAME}.

          T-Vtamn   = 0.
          T-Vtame   = 0.
          T-Ctomn   = 0.
          T-Ctome   = 0.
          F-Salida  = 0.

          /*****************Capturando el Mes siguiente *******************/
          IF Evtclarti.Codmes < 12 THEN DO:
              ASSIGN
                  X-CODMES = Evtclarti.Codmes + 1
                  X-CODANO = Evtclarti.Codano .
          END.
          ELSE DO: 
              ASSIGN
                  X-CODMES = 01
                  X-CODANO = Evtclarti.Codano + 1 .
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
                      T-Ctomn   = T-Ctomn   + Evtclarti.Ctoxdiamn[I] + Evtclarti.Ctoxdiame[I] * Gn-Tcmb.Venta.
                      T-Ctome   = T-Ctome   + Evtclarti.Ctoxdiame[I] + Evtclarti.Ctoxdiamn[I] / Gn-Tcmb.Compra.
                  END.
              END.
          END.         

          /******************************************************************************/      
          FIND tmp-tempo WHERE t-codcia  = S-CODCIA
              AND  t-codcli  = Evtclarti.Codcli
              AND  t-codmat  = Evtclarti.codmat NO-ERROR.

          IF NOT AVAIL tmp-tempo THEN DO:
              CREATE tmp-tempo.
              ASSIGN 
                  t-codcia  = S-CODCIA
                  t-Clase   = Almmmatg.Clase
                  t-codfam  = Almmmatg.codfam 
                  t-subfam  = Almmmatg.subfam
                  t-codcli  = Evtclarti.codcli
                  t-codmat  = Evtclarti.codmat
                  t-desmat  = Almmmatg.DesMat
                  t-desmar  = Almmmatg.DesMar
                  t-undbas  = Almmmatg.UndBas.
          END.
          ASSIGN 
              T-Canti[10] = T-Canti[10] + F-Salida 
              T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
              T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
              T-Marge[10] = T-Marge[10] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
              T-Utili[10] = T-Utili[10] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).

      
          /******************************Secuencia Para Cargar Datos en las Columnas *****************/
          X-ENTRA = FALSE.
          IF F-DIVISION-1 <> "" AND Evtclarti.Coddiv = F-DIVISION-1 THEN DO:
              ASSIGN 
                  T-Canti[1] = T-Canti[1] + F-Salida 
                  T-Venta[1] = T-venta[1] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                  T-Costo[1] = T-Costo[1] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
              T-Marge[1] = T-Marge[1] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
              T-Utili[1] = T-Utili[1] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
              X-ENTRA = TRUE.
          END.       

          IF F-DIVISION-2 <> "" AND Evtclarti.Coddiv = F-DIVISION-2 THEN DO:
              ASSIGN 
                  T-Canti[2] = T-Canti[2] + F-Salida 
                  T-Venta[2] = T-venta[2] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                  T-Costo[2] = T-Costo[2] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                  T-Marge[2] = T-Marge[2] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
                  T-Utili[2] = T-Utili[2] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                  X-ENTRA = TRUE.
          END.       
          
          IF F-DIVISION-3 <> "" AND Evtclarti.Coddiv = F-DIVISION-3 THEN DO:
              ASSIGN 
                  T-Canti[3] = T-Canti[3] + F-Salida 
                  T-Venta[3] = T-venta[3] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                  T-Costo[3] = T-Costo[3] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                  T-Marge[3] = T-Marge[3] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
                  T-Utili[3] = T-Utili[3] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                  X-ENTRA = TRUE.
          END.       

          IF F-DIVISION-4 <> "" AND Evtclarti.Coddiv = F-DIVISION-4 THEN DO:
              ASSIGN 
                  T-Canti[4] = T-Canti[4] + F-Salida  
                  T-Venta[4] = T-venta[4] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                  T-Costo[4] = T-Costo[4] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                  T-Marge[4] = T-Marge[4] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
                  T-Utili[4] = T-Utili[4] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                  X-ENTRA = TRUE.
          END.       

          IF F-DIVISION-5 <> "" AND Evtclarti.Coddiv = F-DIVISION-5 THEN DO:
              ASSIGN 
                  T-Canti[5] = T-Canti[5] + F-Salida 
                  T-Venta[5] = T-venta[5] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                  T-Costo[5] = T-Costo[5] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                  T-Marge[5] = T-Marge[5] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
                  T-Utili[5] = T-Utili[5] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                  X-ENTRA = TRUE.
          END.       

          IF F-DIVISION-6 <> "" AND Evtclarti.Coddiv = F-DIVISION-6 THEN DO:
              ASSIGN 
                  T-Canti[6] = T-Canti[6] + F-Salida 
                  T-Venta[6] = T-venta[6] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                  T-Costo[6] = T-Costo[6] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
                  T-Marge[6] = T-Marge[6] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
                  T-Utili[6] = T-Utili[6] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
                  X-ENTRA = TRUE.     
          END.       

          IF NOT X-ENTRA THEN DO:
              ASSIGN 
                  T-Canti[7] = T-Canti[7] + F-Salida 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-4 codW-Win 
PROCEDURE Carga-Temporal-4 :
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

  FOR EACH Gn-Divi NO-LOCK WHERE Gn-Divi.Codcia = S-CODCIA AND Gn-Divi.CodDiv BEGINS F-DIVISION:
      FOR EACH Evtclarti NO-LOCK USE-INDEX LLAVE04
          WHERE Evtclarti.CodCia = S-CODCIA
          AND Evtclarti.CodDiv = Gn-Divi.Coddiv
          AND (Evtclarti.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
              AND Evtclarti.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) ),
          FIRST Almmmatg WHERE Almmmatg.Codcia = S-CODCIA 
            AND Almmmatg.CodMat = Evtclarti.Codmat NO-LOCK:
                         

      /*
      DISPLAY Evtclarti.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */
      DISPLAY "Codigo de Articulo: " + Evtclarti.CodMat @ txt-msj 
          WITH FRAME {&FRAME-NAME}.

      T-Vtamn   = 0.
      T-Vtame   = 0.
      T-Ctomn   = 0.
      T-Ctome   = 0.
      F-Salida  = 0.

      /*****************Capturando el Mes siguiente *******************/
      IF Evtclarti.Codmes < 12 THEN DO:
        ASSIGN
        X-CODMES = Evtclarti.Codmes + 1
        X-CODANO = Evtclarti.Codano .
      END.
      ELSE DO: 
        ASSIGN
        X-CODMES = 01
        X-CODANO = Evtclarti.Codano + 1 .
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
                   T-Ctomn   = T-Ctomn   + Evtclarti.Ctoxdiamn[I] + Evtclarti.Ctoxdiame[I] * Gn-Tcmb.Venta.
                   T-Ctome   = T-Ctome   + Evtclarti.Ctoxdiame[I] + Evtclarti.Ctoxdiamn[I] / Gn-Tcmb.Compra.
               END.
           END.
       END.         
      
      /******************************************************************************/      

      FIND tmp-tempo WHERE t-codcia  = S-CODCIA
          AND  t-codcli  = Evtclarti.Codcli
          AND  t-codmat  = Evtclarti.codmat NO-ERROR.
      IF NOT AVAIL tmp-tempo THEN DO:
          CREATE tmp-tempo.
          ASSIGN 
              t-codcia  = S-CODCIA
              t-Clase   = Almmmatg.Clase
              t-codfam  = Almmmatg.codfam 
              t-subfam  = Almmmatg.subfam
              t-codcli  = Evtclarti.codcli
              t-codmat  = Evtclarti.codmat
              t-desmat  = Almmmatg.DesMat
              t-desmar  = Almmmatg.DesMar
              t-undbas  = Almmmatg.UndBas.
      END.
      ASSIGN T-Canti[10] = T-Canti[10] + F-Salida 
             T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
             T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
             T-Marge[10] = T-Marge[10] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
             T-Utili[10] = T-Utili[10] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
      
      /******************************Secuencia Para Cargar Datos en las Columnas *****************/
      
      X-ENTRA = FALSE.
      IF F-DIVISION-1 <> "" AND Evtclarti.Coddiv = F-DIVISION-1 THEN DO:
          ASSIGN 
              T-Canti[1] = T-Canti[1] + F-Salida 
              T-Venta[1] = T-venta[1] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
              T-Costo[1] = T-Costo[1] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
          T-Marge[1] = T-Marge[1] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
          T-Utili[1] = T-Utili[1] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
          X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-2 <> "" AND Evtclarti.Coddiv = F-DIVISION-2 THEN DO:
          ASSIGN 
              T-Canti[2] = T-Canti[2] + F-Salida 
              T-Venta[2] = T-venta[2] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
              T-Costo[2] = T-Costo[2] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
          T-Marge[2] = T-Marge[2] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
          T-Utili[2] = T-Utili[2] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
          X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-3 <> "" AND Evtclarti.Coddiv = F-DIVISION-3 THEN DO:
          ASSIGN 
              T-Canti[3] = T-Canti[3] + F-Salida 
              T-Venta[3] = T-venta[3] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
              T-Costo[3] = T-Costo[3] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
          T-Marge[3] = T-Marge[3] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
          T-Utili[3] = T-Utili[3] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
          X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-4 <> "" AND Evtclarti.Coddiv = F-DIVISION-4 THEN DO:
          ASSIGN 
              T-Canti[4] = T-Canti[4] + F-Salida  
              T-Venta[4] = T-venta[4] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
              T-Costo[4] = T-Costo[4] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
          T-Marge[4] = T-Marge[4] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
          T-Utili[4] = T-Utili[4] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
          X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-5 <> "" AND Evtclarti.Coddiv = F-DIVISION-5 THEN DO:
          ASSIGN 
              T-Canti[5] = T-Canti[5] + F-Salida 
              T-Venta[5] = T-venta[5] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
              T-Costo[5] = T-Costo[5] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
          T-Marge[5] = T-Marge[5] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
          T-Utili[5] = T-Utili[5] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
          X-ENTRA = TRUE.
      END.       
      IF F-DIVISION-6 <> "" AND Evtclarti.Coddiv = F-DIVISION-6 THEN DO:
          ASSIGN 
              T-Canti[6] = T-Canti[6] + F-Salida 
              T-Venta[6] = T-venta[6] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
              T-Costo[6] = T-Costo[6] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
          T-Marge[6] = T-Marge[6] + ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Vtamn  ELSE (T-Vtame - T-Ctome) / T-Vtame ).
          T-Utili[6] = T-Utili[6] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
          X-ENTRA = TRUE.     
      END.       
      IF NOT X-ENTRA THEN DO:
          ASSIGN 
              T-Canti[7] = T-Canti[7] + F-Salida 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI codW-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(codW-Win)
  THEN DELETE WIDGET codW-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI codW-Win  _DEFAULT-ENABLE
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
  DISPLAY C-tipo F-DIVISION C-tipo-2 F-clien DesdeC F-DIVISION-1 F-NOMDIV-1 
          DesdeF HastaF F-DIVISION-2 F-NOMDIV-2 F-NOMDIV-3 F-DIVISION-3 
          F-DIVISION-4 F-NOMDIV-4 F-DIVISION-5 F-NOMDIV-5 F-DIVISION-6 
          F-NOMDIV-6 nCodMon txt-msj 
      WITH FRAME F-Main IN WINDOW codW-Win.
  ENABLE RECT-62 RECT-58 RECT-63 RECT-61 C-tipo C-tipo-2 F-clien BUTTON-4 
         DesdeC DesdeF HastaF nCodMon Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME F-Main IN WINDOW codW-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW codW-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1 codW-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1A codW-Win 
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
                           BY t-codcli
                           BY t-codmat:
      /*
      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */

      DISPLAY "Codigo de Articulo: " + t-CodMat @ txt-msj 
          WITH FRAME {&FRAME-NAME}.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-codcli) THEN DO:
         FIND Gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
                            gn-clie.Codcli = t-codcli
                            NO-LOCK NO-ERROR.

         IF AVAILABLE Gn-clie THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "CLIENTE : "   FORMAT "X(20)" AT 1 
                                 t-codcli       FORMAT "X(15)" AT 25
                                 Gn-clie.NomCli FORMAT "X(40)" AT 45 SKIP.
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
   
  
  /*
  HIDE FRAME F-PROCESO.
  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1B codW-Win 
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
                           BY t-codcli
                           BY t-desmar
                           BY t-codfam 
                           BY t-subfam 
                           BY t-codmat:
      /*
      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */

      DISPLAY "Codigo de Articulo: " + t-CodMat @ txt-msj 
          WITH FRAME {&FRAME-NAME}.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-codcli) THEN DO:
         FIND Gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
                            gn-clie.Codcli = t-codcli
                            NO-LOCK NO-ERROR.

         IF AVAILABLE Gn-clie THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "CLIENTE : "   FORMAT "X(20)" AT 1 
                                 t-codcli       FORMAT "X(15)" AT 25
                                 Gn-clie.NomCli FORMAT "X(40)" AT 45 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.
                          
         END.  
      END.
      
      ACCUM  t-venta[1]  (SUB-TOTAL BY t-desmar) .
      ACCUM  t-venta[2]  (SUB-TOTAL BY t-desmar) .
      ACCUM  t-venta[3]  (SUB-TOTAL BY t-desmar) .
      ACCUM  t-venta[4]  (SUB-TOTAL BY t-desmar) .
      ACCUM  t-venta[5]  (SUB-TOTAL BY t-desmar) .
      ACCUM  t-venta[6]  (SUB-TOTAL BY t-desmar) .
      ACCUM  t-venta[7]  (SUB-TOTAL BY t-desmar) .
      ACCUM  t-venta[10]  (SUB-TOTAL BY t-desmar) .
      ACCUM  t-venta[1]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-venta[2]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-venta[3]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-venta[4]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-venta[5]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-venta[6]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-venta[7]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-venta[10]  (SUB-TOTAL BY t-codcli) .
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

      IF LAST-OF(t-desmar) THEN DO:
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
            ("TOTAL MARCA : " + t-desmar) @ t-desmat
            (ACCUM SUB-TOTAL BY t-desmar t-venta[1]) @ t-venta[1] 
            (ACCUM SUB-TOTAL BY t-desmar t-venta[2]) @ t-venta[2] 
            (ACCUM SUB-TOTAL BY t-desmar t-venta[3]) @ t-venta[3] 
            (ACCUM SUB-TOTAL BY t-desmar t-venta[4]) @ t-venta[4] 
            (ACCUM SUB-TOTAL BY t-desmar t-venta[5]) @ t-venta[5] 
            (ACCUM SUB-TOTAL BY t-desmar t-venta[6]) @ t-venta[6] 
            (ACCUM SUB-TOTAL BY t-desmar t-venta[7]) @ t-venta[7] 
            (ACCUM SUB-TOTAL BY t-desmar t-venta[10]) @ t-venta[10] 
            WITH FRAME F-REPORTE.
      END.
      IF LAST-OF(t-codcli) THEN DO:
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
            ("TOTAL CLIENTE : " + t-codcli) @ t-desmat
            (ACCUM SUB-TOTAL BY t-codcli t-venta[1]) @ t-venta[1] 
            (ACCUM SUB-TOTAL BY t-codcli t-venta[2]) @ t-venta[2] 
            (ACCUM SUB-TOTAL BY t-codcli t-venta[3]) @ t-venta[3] 
            (ACCUM SUB-TOTAL BY t-codcli t-venta[4]) @ t-venta[4] 
            (ACCUM SUB-TOTAL BY t-codcli t-venta[5]) @ t-venta[5] 
            (ACCUM SUB-TOTAL BY t-codcli t-venta[6]) @ t-venta[6] 
            (ACCUM SUB-TOTAL BY t-codcli t-venta[7]) @ t-venta[7] 
            (ACCUM SUB-TOTAL BY t-codcli t-venta[10]) @ t-venta[10] 
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
   
  /*
  HIDE FRAME F-PROCESO.
  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1C codW-Win 
PROCEDURE Formato1C :
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
                           BY t-codcli
                           BY t-codfam 
                           BY t-subfam 
                           BY t-codmat:
      /*
      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */

      DISPLAY "Codigo de Articulo: " + t-CodMat @ txt-msj 
          WITH FRAME {&FRAME-NAME}.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-codcli) THEN DO:
         FIND Gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
                            gn-clie.Codcli = t-codcli
                            NO-LOCK NO-ERROR.

         IF AVAILABLE Gn-clie THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "CLIENTE : "   FORMAT "X(20)" AT 1 
                                 t-codcli       FORMAT "X(15)" AT 25
                                 Gn-clie.NomCli FORMAT "X(40)" AT 45 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.
                          
         END.  
      END.
      
      ACCUM  t-costo[1]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-costo[2]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-costo[3]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-costo[4]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-costo[5]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-costo[6]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-costo[7]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-costo[10]  (SUB-TOTAL BY t-codcli) .
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

      IF LAST-OF(t-codcli) THEN DO:
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
            ("TOTAL CLIENTE : " + t-codcli) @ t-desmat
            (ACCUM SUB-TOTAL BY t-codcli t-costo[1]) @ t-costo[1] 
            (ACCUM SUB-TOTAL BY t-codcli t-costo[2]) @ t-costo[2] 
            (ACCUM SUB-TOTAL BY t-codcli t-costo[3]) @ t-costo[3] 
            (ACCUM SUB-TOTAL BY t-codcli t-costo[4]) @ t-costo[4] 
            (ACCUM SUB-TOTAL BY t-codcli t-costo[5]) @ t-costo[5] 
            (ACCUM SUB-TOTAL BY t-codcli t-costo[6]) @ t-costo[6] 
            (ACCUM SUB-TOTAL BY t-codcli t-costo[7]) @ t-costo[7] 
            (ACCUM SUB-TOTAL BY t-codcli t-costo[10]) @ t-costo[10] 
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
  /*
  HIDE FRAME F-PROCESO.
  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1D codW-Win 
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
                           BY t-codcli
                           BY t-codfam 
                           BY t-subfam 
                           BY t-codmat:
      /*
      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */

      DISPLAY "Codigo de Articulo: " + t-CodMat @ txt-msj 
          WITH FRAME {&FRAME-NAME}.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-codcli) THEN DO:
         FIND Gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
                            gn-clie.Codcli = t-codcli
                            NO-LOCK NO-ERROR.

         IF AVAILABLE Gn-clie THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "CLIENTE : "   FORMAT "X(20)" AT 1 
                                 t-codcli       FORMAT "X(15)" AT 25
                                 Gn-clie.NomCli FORMAT "X(40)" AT 45 SKIP.
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
      
      ACCUM  t-Marge[1]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Marge[2]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Marge[3]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Marge[4]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Marge[5]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Marge[6]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Marge[7]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Marge[10]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Marge[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Marge[10]  ( TOTAL BY t-codcia) .

      ACCUM  t-Venta[1]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Venta[2]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Venta[3]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Venta[4]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Venta[5]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Venta[6]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Venta[7]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Venta[10]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Venta[1]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[2]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[3]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[4]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[5]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[6]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[7]  ( TOTAL BY t-codcia) .
      ACCUM  t-Venta[10]  ( TOTAL BY t-codcia) .

      ACCUM  t-Costo[1]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Costo[2]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Costo[3]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Costo[4]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Costo[5]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Costo[6]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Costo[7]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Costo[10]  (SUB-TOTAL BY t-codcli) .
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

      IF LAST-OF(t-codcli) THEN DO:
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
            ("TOTAL CLIENTE : " + t-codcli) @ t-desmat
            ((ACCUM SUB-TOTAL BY t-codcli t-Venta[1]) - (ACCUM SUB-TOTAL BY t-codcli t-Costo[1])) / (ACCUM SUB-TOTAL BY t-codcli t-Venta[1]) @ t-Marge[1] 
            ((ACCUM SUB-TOTAL BY t-codcli t-Venta[2]) - (ACCUM SUB-TOTAL BY t-codcli t-Costo[2])) / (ACCUM SUB-TOTAL BY t-codcli t-Venta[2]) @ t-Marge[2] 
            ((ACCUM SUB-TOTAL BY t-codcli t-Venta[3]) - (ACCUM SUB-TOTAL BY t-codcli t-Costo[3])) / (ACCUM SUB-TOTAL BY t-codcli t-Venta[3]) @ t-Marge[3] 
            ((ACCUM SUB-TOTAL BY t-codcli t-Venta[4]) - (ACCUM SUB-TOTAL BY t-codcli t-Costo[4])) / (ACCUM SUB-TOTAL BY t-codcli t-Venta[4]) @ t-Marge[4] 
            ((ACCUM SUB-TOTAL BY t-codcli t-Venta[5]) - (ACCUM SUB-TOTAL BY t-codcli t-Costo[5])) / (ACCUM SUB-TOTAL BY t-codcli t-Venta[5]) @ t-Marge[5] 
            ((ACCUM SUB-TOTAL BY t-codcli t-Venta[6]) - (ACCUM SUB-TOTAL BY t-codcli t-Costo[6])) / (ACCUM SUB-TOTAL BY t-codcli t-Venta[6]) @ t-Marge[6] 
            ((ACCUM SUB-TOTAL BY t-codcli t-Venta[7]) - (ACCUM SUB-TOTAL BY t-codcli t-Costo[7])) / (ACCUM SUB-TOTAL BY t-codcli t-Venta[7]) @ t-Marge[7] 
            ((ACCUM SUB-TOTAL BY t-codcli t-Venta[10]) - (ACCUM SUB-TOTAL BY t-codcli t-Costo[10])) / (ACCUM SUB-TOTAL BY t-codcli t-Venta[10]) @ t-Marge[10] 
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
  /*
  HIDE FRAME F-PROCESO.
  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1E codW-Win 
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
                           BY t-codcli
                           BY t-codfam 
                           BY t-subfam 
                           BY t-codmat:
      /*
      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */

      DISPLAY "Codigo de Articulo: " + t-CodMat @ txt-msj 
          WITH FRAME {&FRAME-NAME}.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-codcli) THEN DO:
         FIND Gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
                            gn-clie.Codcli = t-codcli
                            NO-LOCK NO-ERROR.

         IF AVAILABLE Gn-clie THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "CLIENTE : "   FORMAT "X(20)" AT 1 
                                 t-codcli       FORMAT "X(15)" AT 25
                                 Gn-clie.NomCli FORMAT "X(40)" AT 45 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.
                          
         END.  
      END.
      
      ACCUM  t-Utili[1]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Utili[2]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Utili[3]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Utili[4]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Utili[5]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Utili[6]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Utili[7]  (SUB-TOTAL BY t-codcli) .
      ACCUM  t-Utili[10]  (SUB-TOTAL BY t-codcli) .
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

      IF LAST-OF(t-codcli) THEN DO:
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
            ("TOTAL CLIENTE : " + t-codcli) @ t-desmat
            (ACCUM SUB-TOTAL BY t-codcli t-Utili[1]) @ t-Utili[1] 
            (ACCUM SUB-TOTAL BY t-codcli t-Utili[2]) @ t-Utili[2] 
            (ACCUM SUB-TOTAL BY t-codcli t-Utili[3]) @ t-Utili[3] 
            (ACCUM SUB-TOTAL BY t-codcli t-Utili[4]) @ t-Utili[4] 
            (ACCUM SUB-TOTAL BY t-codcli t-Utili[5]) @ t-Utili[5] 
            (ACCUM SUB-TOTAL BY t-codcli t-Utili[6]) @ t-Utili[6] 
            (ACCUM SUB-TOTAL BY t-codcli t-Utili[7]) @ t-Utili[7] 
            (ACCUM SUB-TOTAL BY t-codcli t-Utili[10]) @ t-Utili[10] 
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
  /*
  HIDE FRAME F-PROCESO.
  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Habilita codW-Win 
PROCEDURE Habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
/*     IF LOOKUP(C-TIPO,"Resumen-Proveedor,Resumen-Sublinea") = 0  THEN                                 */
/*         ENABLE ALL EXCEPT F-NOMDIV-1 F-NOMDIV-2 F-NOMDIV-3 F-NOMDIV-4 F-NOMDIV-5 F-NOMDIV-6 txt-msj. */
/*     ELSE                                                                                             */
/*     ENABLE ALL EXCEPT F-NOMDIV-1 F-NOMDIV-2 F-NOMDIV-3 F-NOMDIV-4 F-NOMDIV-5 F-NOMDIV-6              */
/*                       F-DIVISION-1 F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6  */
/*                       txt-msj.                                                                       */

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime codW-Win 
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
    IF F-CLIEN = "" AND DesdeC = "" THEN DO:
        MESSAGE
            "El Reporte podría tomar algun tiempo" SKIP
            "Ser mas especifico acelera el Proceso" SKIP
            "Desea Continuar ?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE choice AS LOGICAL.
        CASE choice:
            WHEN FALSE THEN RETURN.
        END.
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inhabilita codW-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inicializa-Variables codW-Win 
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
         F-clien 
         DesdeC 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit codW-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize codW-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN 
      DesdeF = TODAY  + 1 - DAY(TODAY)
      HastaF = TODAY
      F-DIVISION-1 = s-CodDiv.
  FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
      Gn-Divi.Coddiv = F-DIVISION-1 NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-Divi THEN F-NOMDIV-1 = Gn-Divi.DesDiv.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros codW-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros codW-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records codW-Win  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed codW-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida codW-Win 
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

