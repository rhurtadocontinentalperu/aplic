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
    FIELD t-codven  LIKE Ccbcdocu.Codven
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
    FIELD t-utili   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99" 
    INDEX LLAVE01 t-codcia t-codven t-codmat .

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
&Scoped-Define ENABLED-OBJECTS RECT-64 RECT-61 F-DIVISION BUTTON-5 F-CodFam ~
BUTTON-1 F-SubFam BUTTON-2 F-Marca BUTTON-3 F-prov1 BUTTON-4 DesdeC HastaC ~
DesdeF HastaF BUTTON-6 F-vend nCodMon Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS F-DIVISION F-CodFam F-SubFam F-Marca ~
F-prov1 DesdeC HastaC DesdeF HastaF F-vend nCodMon txt-msj 

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

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "img\b-buscar":U
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

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Linea" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-DIVISION AS CHARACTER FORMAT "X(5)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-Marca AS CHARACTER FORMAT "X(4)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-prov1 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-SubFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Sub-linea" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-vend AS CHARACTER FORMAT "X(3)":U 
     LABEL "Vendedor" 
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

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U INITIAL "Cargando Informacion....." 
     VIEW-AS FILL-IN 
     SIZE 34.29 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dolares", 2
     SIZE 20 BY .85 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47.14 BY 1.5
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47.14 BY 10.38
     BGCOLOR 3 .

DEFINE RECTANGLE RECT-64
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 22.43 BY 1.12.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-DIVISION AT ROW 2.19 COL 11.57 COLON-ALIGNED
     BUTTON-5 AT ROW 2.19 COL 25.29
     F-CodFam AT ROW 2.92 COL 11.57 COLON-ALIGNED
     BUTTON-1 AT ROW 2.92 COL 25.14
     F-SubFam AT ROW 3.69 COL 11.57 COLON-ALIGNED
     BUTTON-2 AT ROW 3.69 COL 25.14
     F-Marca AT ROW 4.42 COL 11.57 COLON-ALIGNED
     BUTTON-3 AT ROW 4.42 COL 25.14
     F-prov1 AT ROW 5.23 COL 11.57 COLON-ALIGNED
     BUTTON-4 AT ROW 5.23 COL 25.14
     DesdeC AT ROW 5.96 COL 11.57 COLON-ALIGNED
     HastaC AT ROW 6.04 COL 33.29 COLON-ALIGNED
     DesdeF AT ROW 6.65 COL 11.57 COLON-ALIGNED
     HastaF AT ROW 6.73 COL 33.29 COLON-ALIGNED
     BUTTON-6 AT ROW 7.35 COL 25.14
     F-vend AT ROW 7.42 COL 11.57 COLON-ALIGNED
     nCodMon AT ROW 9.65 COL 13.14 NO-LABEL
     txt-msj AT ROW 10.88 COL 2 NO-LABEL WIDGET-ID 2
     Btn_OK AT ROW 11.96 COL 13.72
     Btn_Cancel AT ROW 11.96 COL 25
     Btn_Help AT ROW 11.96 COL 36.43
     "Moneda" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 8.96 COL 13
          FONT 6
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1.35 COL 4.43
          FONT 6
     RECT-46 AT ROW 11.92 COL 1.14
     RECT-64 AT ROW 9.54 COL 12.29
     RECT-61 AT ROW 1.54 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 48.72 BY 12.65
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
         TITLE              = "AVANCE DE PROMOCIONES POR PRODUCTO Y CANAL DE VENTA"
         HEIGHT             = 12.54
         WIDTH              = 48.43
         MAX-HEIGHT         = 12.65
         MAX-WIDTH          = 48.72
         VIRTUAL-HEIGHT     = 12.65
         VIRTUAL-WIDTH      = 48.72
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
ON END-ERROR OF W-Win /* AVANCE DE PROMOCIONES POR PRODUCTO Y CANAL DE VENTA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* AVANCE DE PROMOCIONES POR PRODUCTO Y CANAL DE VENTA */
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


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Button 6 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "".
    output-var-2 = "".
    RUN lkup\C-vende.r("Vendedores").
    IF output-var-2 <> ? THEN DO:
        F-VEND = output-var-2.
        DISPLAY F-VEND.
        APPLY "ENTRY" TO F-VEND .
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
 ASSIGN F-DIVISION.
 IF F-DIVISION <> "" THEN DO:        
    FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                       Gn-Divi.Coddiv = F-DIVISION NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-Divi THEN DO:
        MESSAGE "Division " + F-DIVISION + " No Existe " SKIP
                "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO F-DIVISION IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.    
   
  END.
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
         F-CodFam 
         F-SubFam 
         F-Marca 
         F-prov1 
         DesdeC 
         HastaC 
         DesdeF 
         HastaF 
         nCodMon
         F-Vend.
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
                           AND  (Almmmatg.codmat >= DesdeC
                           AND   Almmmatg.CodMat <= HastaC)
                           AND  Almmmatg.CodPr1 BEGINS F-prov1
                           AND  Almmmatg.Codmar BEGINS F-Marca
                          USE-INDEX matg09:
   FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
                      AND Gn-Divi.Coddiv BEGINS F-DIVISION :      
   FOR EACH Gn-Ven WHERE Gn-Ven.Codcia = S-CODCIA 
                     AND Gn-Ven.Codven BEGINS F-VEND :      
                                      
    FOR EACH evtvend NO-LOCK WHERE evtvend.CodCia = S-CODCIA
                           AND   evtvend.CodDiv   = Gn-Divi.Coddiv 
                           AND   evtvend.CodVen   = Gn-Ven.Codven
/*                           AND   evtvend.Codmat   = Almmmatg.codmat*/
                           AND   (evtvend.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
                           AND   evtvend.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) ):
                         
      /*
      DISPLAY Almmmatg.Codfam + " " + Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */
      T-Vtamn   = 0.
      T-Vtame   = 0.
      T-Ctomn   = 0.
      T-Ctome   = 0.
      F-Salida  = 0.

      /*****************Capturando el Mes siguiente *******************/
      IF evtvend.Codmes < 12 THEN DO:
        ASSIGN
        X-CODMES = evtvend.Codmes + 1
        X-CODANO = evtvend.Codano .
      END.
      ELSE DO: 
        ASSIGN
        X-CODMES = 01
        X-CODANO = evtvend.Codano + 1 .
      END.
      /**********************************************************************/
      
      /*********************** Calculo Para Obtener los datos diarios ************/
       DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        

            X-FECHA = DATE(STRING(I,"99") + "/" + STRING(evtvend.Codmes,"99") + "/" + STRING(evtvend.Codano,"9999")).
            IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
                FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(evtvend.Codmes,"99") + "/" + STRING(evtvend.Codano,"9999")) NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN DO: 
/*                 F-Salida  = F-Salida  + evtvend.CanxDia[I].*/
                 T-Vtamn   = T-Vtamn   + evtvend.Vtaxdiamn[I] + evtvend.Vtaxdiame[I] * Gn-Tcmb.Venta.
                 T-Vtame   = T-Vtame   + evtvend.Vtaxdiame[I] + evtvend.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                 T-Ctomn   = T-Ctomn   + evtvend.Ctoxdiamn[I] + evtvend.Ctoxdiame[I] * Gn-Tcmb.Venta.
                 T-Ctome   = T-Ctome   + evtvend.Ctoxdiame[I] + evtvend.Ctoxdiamn[I] / Gn-Tcmb.Compra.
                END.
            END.
       END.         
      
      /******************************************************************************/      


      FIND tmp-tempo WHERE t-codcia  = S-CODCIA
                      AND  t-codven  = evtvend.Codven
/*                      AND  t-codmat  = evtvend.codmat*/
                     NO-ERROR.
      IF NOT AVAIL tmp-tempo THEN DO:
        CREATE tmp-tempo.
        ASSIGN t-codcia  = S-CODCIA
               t-codven  = evtvend.Codven
               t-Clase   = Almmmatg.Clase
               t-codfam  = Almmmatg.codfam 
               t-subfam  = Almmmatg.subfam
               t-prove   = Almmmatg.CodPr1
/*               t-codmat  = evtvend.codmat*/
               t-desmat  = Almmmatg.DesMat
               t-desmar  = Almmmatg.DesMar
               t-undbas  = Almmmatg.UndBas.
      END.
      ASSIGN T-Canti[10] = T-Canti[10] + F-Salida 
             T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
             T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
             T-Marge[10] = ( IF ncodmon = 1 THEN (T-Vtamn - T-Ctomn) / T-Ctomn  ELSE (T-Vtame - T-Ctome) / T-Ctome ) * 100.
             T-Utili[10] = T-Utili[10] + ( IF ncodmon = 1 THEN T-Vtamn - T-Ctomn ELSE T-Vtame - T-Ctome ).
      
   
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
          HastaF F-vend nCodMon txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-64 RECT-61 F-DIVISION BUTTON-5 F-CodFam BUTTON-1 F-SubFam 
         BUTTON-2 F-Marca BUTTON-3 F-prov1 BUTTON-4 DesdeC HastaC DesdeF HastaF 
         BUTTON-6 F-vend nCodMon Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
         t-DesMat    FORMAT "X(50)"
         t-DesMar    FORMAT "X(15)" 
         t-UndBas    FORMAT "X(6)"
         t-canti[10]  FORMAT "->>>>>>>>>>>>9.99"
         t-Venta[10]  FORMAT "->>>>>>>>>>>>9.99"
         t-Marge[10]  FORMAT "->>9.99"
        WITH WIDTH 220 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6B} + {&Prn3} FORMAT "X(50)" AT 1 SKIP(1)
         {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 40 FORMAT "X(50)" SKIP
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

        "----------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        " CODIGO  D E S C R I P C I O N                             MARCA        U.M                  CANTIDAD         IMPORTE     MARGEN% " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 220 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  /* WHERE t-canti[10] > 0  */
                     BREAK BY t-codcia
                           by t-codven
                           BY t-codfam 
                           BY t-prove 
                           BY t-codmat:
      /*
      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */
      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-Codven) THEN DO:
         FIND Gn-Ven WHERE Gn-Ven.Codcia = S-CODCIA AND
                           Gn-Ven.Codven = t-codven
                            NO-LOCK NO-ERROR.
         IF AVAILABLE Gn-Ven THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   {&PRN6A} + "VENDEDOR : "  FORMAT "X(15)" AT 1 
                                 {&PRN6A} + t-codven       FORMAT "X(7)" AT 17
                                 {&PRN6A} + Gn-Ven.NomVen + {&PRN6B} FORMAT "X(40)" AT 25 SKIP.
             PUT STREAM REPORT   {&PRN6B} + '------------------------------------------' FORMAT "X(50)" SKIP.
         END.
      END.

      IF FIRST-OF(t-CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = t-CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   {&PRN6A} + "FAMILIA : "  FORMAT "X(15)" AT 1 
                                 {&PRN6A} + t-codfam      FORMAT "X(05)" AT 17
                                 {&PRN6A} + Almtfami.Desfam + {&PRN6B} FORMAT "X(40)" AT 25 SKIP.
             PUT STREAM REPORT   {&PRN6B} + '------------------------------------------' FORMAT "X(50)" SKIP.
         END.
      END.

      IF FIRST-OF(t-prove) THEN DO:
         FIND GN-PROV WHERE GN-PROV.CODCIA = pv-codcia
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

      ACCUM  t-venta[10]  (SUB-TOTAL BY t-codven) .
      ACCUM  t-venta[10]  (SUB-TOTAL BY t-prove) .
      ACCUM  t-venta[10]  (SUB-TOTAL BY t-codfam) .
      ACCUM  t-venta[10]  ( TOTAL BY t-codcia) .

      DISPLAY STREAM REPORT 
                t-codmat
                t-DesMat
                t-DesMar
                t-UndBas
                t-canti[10]       
                t-venta[10]        
                t-Marge[10]        
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.


      IF LAST-OF(t-prove) THEN DO:  
            UNDERLINE STREAM REPORT
            t-venta[10]
            WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
            {&PRN6A} + ("TOTAL   : " + T-prove ) @ t-desmat
            (ACCUM SUB-TOTAL BY t-prove t-venta[10]) @ t-venta[10] 
             WITH FRAME F-REPORTE.
      END.
      IF LAST-OF(t-CodFam) THEN DO:  
            UNDERLINE STREAM REPORT
            t-venta[10]
            WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
            {&PRN6A} + ("TOTAL   : " + T-CODFAM ) @ t-desmat
            (ACCUM SUB-TOTAL BY t-codfam t-venta[10]) @ t-venta[10] 
             WITH FRAME F-REPORTE.
      END.
      IF LAST-OF(t-Codven) THEN DO:  
            UNDERLINE STREAM REPORT
            t-venta[10]
            WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
            {&PRN6A} + ("TOTAL   : " + T-codven ) @ t-desmat
            (ACCUM SUB-TOTAL BY t-codven t-venta[10]) @ t-venta[10] 
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
   ENABLE ALL .
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
        RUN Formato2A.
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
  ASSIGN 
         F-Division 
         F-CodFam 
         F-SubFam 
         F-Marca 
         F-prov1 
         DesdeC 
         HastaC 
         DesdeF 
         HastaF 
         nCodMon 
         F-Vend.
  
  IF HastaC <> "" THEN HastaC = "".
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

IF F-VEND <> "" THEN DO:
  DO I = 1 TO NUM-ENTRIES(F-VEND):
          FIND GN-VEN WHERE GN-VEN.CODCIA = S-CODCIA AND 
                            GN-VEN.CODVEN = ENTRY(I,F-VEND) NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-VEN THEN DO:
            MESSAGE "Vendedor " + ENTRY(I,F-VEND) + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-VEND IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.                             
  END.

END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

