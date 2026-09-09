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
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE        VAR C-OP     AS CHAR.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
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
DEFINE VAR X-DESDE  AS DATE.
DEFINE VAR X-HASTA  AS DATE.
DEFINE VAR X-FECHA  AS DATE.
DEFINE VAR X-CODDIA AS INTEGER INIT 1.
DEFINE VAR X-CODANO AS INTEGER .
DEFINE VAR X-CODMES AS INTEGER .
DEFINE VAR X-NROSEM AS INTEGER .
DEFINE VAR X-NOMMES AS CHAR INIT "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre".
DEFINE VAR X-ENTRA AS LOGICAL INIT FALSE.


DEFINE TEMP-TABLE T-Almmmatg LIKE Almmmatg.


DEFINE TEMP-TABLE tmp-tempo 
    FIELD t-codcia  LIKE Almdmov.Codcia 
    FIELD t-codmes  LIKE Evtarti.codmes
    FIELD t-nrosem  LIKE PL-Sem.Nrosem
    FIELD t-fchdoc  LIKE Almdmov.fchdoc
    FIELD t-fecini  LIKE Pl-sem.fecini
    FIELD t-fecfin  LIKE Pl-sem.fecfin
    FIELD t-clase   LIKE Almmmatg.clase
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
    FIELD t-canti   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99" .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-58 RECT-61 RECT-62 RECT-63 F-DIVISION ~
DesdeC DesdeF HastaF C-tipo F-PERIODO-1 F-PERIODO-2 F-PERIODO-3 F-PERIODO-4 ~
F-PERIODO-5 nCodMon Btn_OK Btn_Cancel Btn_Help BUTTON-5 
&Scoped-Define DISPLAYED-OBJECTS F-DIVISION DesdeC DesdeF HastaF C-tipo ~
F-PERIODO-1 F-PERIODO-2 F-PERIODO-3 F-PERIODO-4 F-PERIODO-5 nCodMon 

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

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 6" 
     SIZE 4.43 BY .77.

DEFINE VARIABLE C-tipo AS CHARACTER FORMAT "X(20)":U INITIAL "Mensual" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Mensual","Semanal","Diario" 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-DIVISION AS CHARACTER FORMAT "X(5)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-PERIODO-1 AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "1" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .69 NO-UNDO.

DEFINE VARIABLE F-PERIODO-2 AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "2" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .69 NO-UNDO.

DEFINE VARIABLE F-PERIODO-3 AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "3" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .69 NO-UNDO.

DEFINE VARIABLE F-PERIODO-4 AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "4" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .69 NO-UNDO.

DEFINE VARIABLE F-PERIODO-5 AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "5" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .69 NO-UNDO.

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
     SIZE 75.14 BY 1.81
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 26.86 BY 1.46.

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45.14 BY 8.42
     BGCOLOR 3 .

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 26.86 BY 5.35.

DEFINE RECTANGLE RECT-63
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 26.86 BY 1.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-DIVISION AT ROW 3.12 COL 11.57 COLON-ALIGNED
     DesdeC AT ROW 3.92 COL 11.72 COLON-ALIGNED
     DesdeF AT ROW 4.62 COL 11.72 COLON-ALIGNED HELP
          "Solo fechas del mismo Año"
     HastaF AT ROW 4.69 COL 33.43 COLON-ALIGNED HELP
          "Solo fechas del mismo Año"
     C-tipo AT ROW 1.88 COL 51.72 COLON-ALIGNED HELP
          "Tipo de Reporte" NO-LABEL
     F-PERIODO-1 AT ROW 3.73 COL 49.29 COLON-ALIGNED
     F-PERIODO-2 AT ROW 4.46 COL 49.29 COLON-ALIGNED
     F-PERIODO-3 AT ROW 5.27 COL 49.29 COLON-ALIGNED
     F-PERIODO-4 AT ROW 5.96 COL 49.29 COLON-ALIGNED
     F-PERIODO-5 AT ROW 6.77 COL 49.29 COLON-ALIGNED
     nCodMon AT ROW 9.15 COL 52.57 NO-LABEL
     Btn_OK AT ROW 10.15 COL 41.72
     Btn_Cancel AT ROW 10.15 COL 53
     Btn_Help AT ROW 10.15 COL 64.43
     BUTTON-5 AT ROW 3.12 COL 25.29
     RECT-46 AT ROW 9.88 COL 1.86
     RECT-58 AT ROW 1.54 COL 47.43
     RECT-61 AT ROW 1.54 COL 1.86
     RECT-62 AT ROW 3.15 COL 47.43
     RECT-63 AT ROW 8.65 COL 47.43
     "Moneda" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 8.58 COL 49.72
          FONT 6
     "Tipo de Reporte" VIEW-AS TEXT
          SIZE 16.29 BY .65 AT ROW 1.27 COL 48.43
          FONT 6
     "Criterio de Seleccion" VIEW-AS TEXT
          SIZE 22.86 BY .5 AT ROW 1.35 COL 4.43
          FONT 6
     "Displayar Periodos" VIEW-AS TEXT
          SIZE 20.86 BY .5 AT ROW 3.08 COL 49.14
          FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 76 BY 10.77
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
         HEIGHT             = 10.77
         WIDTH              = 74
         MAX-HEIGHT         = 21.38
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.38
         VIRTUAL-WIDTH      = 114.29
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
   Custom                                                               */
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


&Scoped-define SELF-NAME F-DIVISION
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DIVISION W-Win
ON LEAVE OF F-DIVISION IN FRAME F-Main /* Division */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    ASSIGN F-DIVISION .
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    IF F-DIVISION <> "" THEN DO:
           DO I = 1 TO NUM-ENTRIES(F-DIVISION):
             FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                                Gn-Divi.Coddiv = ENTRY(I,F-DIVISION) NO-LOCK NO-ERROR.
             IF NOT AVAILABLE Gn-Divi THEN DO:
               MESSAGE "Division " + ENTRY(I,F-DIVISION) + " No Existe " SKIP
                       "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
               APPLY "ENTRY" TO F-DIVISION IN FRAME {&FRAME-NAME}.
               RETURN NO-APPLY.
             END.                             
           END.
    END.
 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PERIODO-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PERIODO-1 W-Win
ON LEAVE OF F-PERIODO-1 IN FRAME F-Main /* 1 */
DO:
  ASSIGN F-PERIODO-1.
  IF F-PERIODO-1 = 0  THEN RETURN.
  X-LLAVE = STRING(F-PERIODO-4,"9999") + "," 
          + STRING(F-PERIODO-2,"9999") + ","
          + STRING(F-PERIODO-3,"9999") + ","
          + STRING(F-PERIODO-5,"9999") .
          
  DO I = 1 TO NUM-ENTRIES(X-LLAVE):
    IF STRING(F-PERIODO-1,"9999") = ENTRY(I,X-LLAVE)  THEN DO:
      MESSAGE "PERIODO " + ENTRY(I,X-LLAVE) + " Ya Existe " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-PERIODO-1 IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.                             
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PERIODO-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PERIODO-2 W-Win
ON LEAVE OF F-PERIODO-2 IN FRAME F-Main /* 2 */
DO:
  ASSIGN F-PERIODO-2.
  IF F-PERIODO-2 = 0  THEN RETURN.
  X-LLAVE = STRING(F-PERIODO-1,"9999") + "," 
          + STRING(F-PERIODO-4,"9999") + ","
          + STRING(F-PERIODO-3,"9999") + ","
          + STRING(F-PERIODO-5,"9999") .
          
  DO I = 1 TO NUM-ENTRIES(X-LLAVE):
    IF STRING(F-PERIODO-2,"9999") = ENTRY(I,X-LLAVE)  THEN DO:
      MESSAGE "PERIODO " + ENTRY(I,X-LLAVE) + " Ya Existe " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-PERIODO-2 IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.                             
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PERIODO-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PERIODO-3 W-Win
ON LEAVE OF F-PERIODO-3 IN FRAME F-Main /* 3 */
DO:
  ASSIGN F-PERIODO-3.
  IF F-PERIODO-3 = 0  THEN RETURN.
  X-LLAVE = STRING(F-PERIODO-1,"9999") + "," 
          + STRING(F-PERIODO-2,"9999") + ","
          + STRING(F-PERIODO-4,"9999") + ","
          + STRING(F-PERIODO-5,"9999") .
          
  DO I = 1 TO NUM-ENTRIES(X-LLAVE):
    IF STRING(F-PERIODO-3,"9999") = ENTRY(I,X-LLAVE) THEN DO:
      MESSAGE "PERIODO " + ENTRY(I,X-LLAVE) + " Ya Existe " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-PERIODO-3 IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.                             
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PERIODO-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PERIODO-4 W-Win
ON LEAVE OF F-PERIODO-4 IN FRAME F-Main /* 4 */
DO:
  ASSIGN F-PERIODO-4.
  IF F-PERIODO-4 = 0  THEN RETURN.
  X-LLAVE = STRING(F-PERIODO-1,"9999") + "," 
          + STRING(F-PERIODO-2,"9999") + ","
          + STRING(F-PERIODO-3,"9999") + ","
          + STRING(F-PERIODO-5,"9999") .
          
  DO I = 1 TO NUM-ENTRIES(X-LLAVE):
    IF STRING(F-PERIODO-4,"9999") = ENTRY(I,X-LLAVE)  THEN DO:
      MESSAGE "PERIODO " + ENTRY(I,X-LLAVE) + " Ya Existe " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-PERIODO-4 IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.                             
  END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-PERIODO-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-PERIODO-5 W-Win
ON LEAVE OF F-PERIODO-5 IN FRAME F-Main /* 5 */
DO:
  ASSIGN F-PERIODO-5.
  IF F-PERIODO-5 = 0  THEN RETURN.
  X-LLAVE = STRING(F-PERIODO-1,"9999") + "," 
          + STRING(F-PERIODO-2,"9999") + ","
          + STRING(F-PERIODO-3,"9999") + ","
          + STRING(F-PERIODO-4,"9999") .
          
  DO I = 1 TO NUM-ENTRIES(X-LLAVE):
    IF STRING(F-PERIODO-5,"9999") = ENTRY(I,X-LLAVE)  THEN DO:
      MESSAGE "PERIODO " + ENTRY(I,X-LLAVE) + " Ya Existe " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-PERIODO-5 IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
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
         F-Periodo-1 
         F-Periodo-2 
         F-Periodo-3
         F-Periodo-4 
         F-Periodo-5 
         DesdeC 
         DesdeF 
         HastaF 
         nCodMon .
  
    
    
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Diaria-Articulo W-Win 
PROCEDURE Carga-Diaria-Articulo :
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

DO II = 1 TO NUM-ENTRIES(X-LLAVE) :

  IF INTEGER(ENTRY(II,X-LLAVE)) = 0 THEN NEXT. 
  X-DESDE = DATE(STRING(DAY(DesdeF),"99") + "/" + STRING(MONTH(DesdeF),"99") + "/" + ENTRY(II,X-LLAVE)).
  X-HASTA = DATE(STRING(DAY(HastaF),"99") + "/" + STRING(MONTH(HastaF),"99") + "/" + ENTRY(II,X-LLAVE)).
  
  FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
                     AND Gn-Divi.CodDiv BEGINS F-DIVISION:
  
  FOR EACH Evtarti NO-LOCK WHERE Evtarti.CodCia = S-CODCIA
                         AND   Evtarti.CodDiv = Gn-Divi.Coddiv
                         AND   Evtarti.Codmat = DesdeC
                         AND   (Evtarti.Nrofch >= INTEGER(STRING(YEAR(X-DESDE),"9999") + STRING(MONTH(X-DESDE),"99"))
                         AND   Evtarti.Nrofch <= INTEGER(STRING(YEAR(X-HASTA),"9999") + STRING(MONTH(X-HASTA),"99")) ):
                         

      DISPLAY Evtarti.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                          Almmmatg.Codmat = DesdeC NO-LOCK NO-ERROR.
      
                                
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
            
            IF X-FECHA >= X-DESDE AND X-FECHA <= X-HASTA THEN DO:
                FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")) NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN DO: 
                 F-Salida  = Evtarti.CanxDia[I].
                 T-Vtamn   = Evtarti.Vtaxdiamn[I] + Evtarti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                 T-Vtame   = Evtarti.Vtaxdiame[I] + Evtarti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                END.
                                                      
                FIND tmp-tempo WHERE t-codcia  = S-CODCIA                           
                                AND  t-codmat  = Evtarti.codmat
                                AND  t-fchdoc  = X-FECHA  NO-ERROR.
                      
                IF NOT AVAIL tmp-tempo THEN DO:
                  CREATE tmp-tempo.
                  ASSIGN t-codcia  = S-CODCIA
                         t-Clase   = Almmmatg.Clase
                         t-codmat  = Evtarti.codmat
                         t-desmat  = Almmmatg.DesMat
                         t-desmar  = Almmmatg.DesMar
                         t-undbas  = Almmmatg.UndBas
                         t-fchdoc  = X-FECHA.
                END.
                ASSIGN T-Canti[10] = T-Canti[10] + F-Salida 
                       T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                       T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
      
                /******************************Secuencia Para Cargar Datos en las Columnas *****************/
                
                IF F-PERIODO-1 > 0 AND Evtarti.Codano = F-PERIODO-1 THEN DO:
                   ASSIGN T-Canti[1] = T-Canti[1] + F-Salida 
                          T-Venta[1] = T-venta[1] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[1] = T-Costo[1] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                END.       
                IF F-PERIODO-2 > 0 AND Evtarti.Codano = F-PERIODO-2 THEN DO:
                   ASSIGN T-Canti[2] = T-Canti[2] + F-Salida 
                          T-Venta[2] = T-venta[2] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[2] = T-Costo[2] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                END.       
                IF F-PERIODO-3 > 0 AND Evtarti.Codano = F-PERIODO-3 THEN DO:
                   ASSIGN T-Canti[3] = T-Canti[3] + F-Salida 
                          T-Venta[3] = T-venta[3] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[3] = T-Costo[3] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                END.       
                IF F-PERIODO-4 > 0 AND Evtarti.Codano = F-PERIODO-4 THEN DO:
                   ASSIGN T-Canti[4] = T-Canti[4] + F-Salida  
                          T-Venta[4] = T-venta[4] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[4] = T-Costo[4] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                END.       
                IF F-PERIODO-5 > 0 AND Evtarti.Codano = F-PERIODO-5 THEN DO:
                   ASSIGN T-Canti[5] = T-Canti[5] + F-Salida 
                          T-Venta[5] = T-venta[5] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[5] = T-Costo[5] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                END.                       
                /**************************************************************************/  
            END.          
       END.         
  END.
  END.
END.

HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Diaria-Division W-Win 
PROCEDURE Carga-Diaria-Division :
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

DO II = 1 TO NUM-ENTRIES(X-LLAVE) :

  IF INTEGER(ENTRY(II,X-LLAVE)) = 0 THEN NEXT. 
  X-DESDE = DATE(STRING(DAY(DesdeF),"99") + "/" + STRING(MONTH(DesdeF),"99") + "/" + ENTRY(II,X-LLAVE)).
  X-HASTA = DATE(STRING(DAY(HastaF),"99") + "/" + STRING(MONTH(HastaF),"99") + "/" + ENTRY(II,X-LLAVE)).
  FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
                     AND Gn-Divi.CodDiv BEGINS F-DIVISION:

  FOR EACH EvtDivi NO-LOCK WHERE EvtDivi.CodCia = S-CODCIA
                         AND   EvtDivi.CodDiv = Gn-Divi.Coddiv
                         AND   (EvtDivi.Nrofch >= INTEGER(STRING(YEAR(X-DESDE),"9999") + STRING(MONTH(X-DESDE),"99"))
                         AND   EvtDivi.Nrofch <= INTEGER(STRING(YEAR(X-HASTA),"9999") + STRING(MONTH(X-HASTA),"99")) ):
                         

      DISPLAY EvtDivi.CodDiv @ Fi-Mensaje LABEL "Codigo de Division "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                          Almmmatg.Codmat = DesdeC NO-LOCK NO-ERROR.
      
                                
      T-Vtamn   = 0.
      T-Vtame   = 0.
      T-Ctomn   = 0.
      T-Ctome   = 0.
      F-Salida  = 0.

      /*****************Capturando el Mes siguiente *******************/
      IF EvtDivi.Codmes < 12 THEN DO:
        ASSIGN
        X-CODMES = EvtDivi.Codmes + 1
        X-CODANO = EvtDivi.Codano .
      END.
      ELSE DO: 
        ASSIGN
        X-CODMES = 01
        X-CODANO = EvtDivi.Codano + 1 .
      END.
      /**********************************************************************/
      
      /*********************** Calculo Para Obtener los datos diarios ************/
       DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        

            X-FECHA = DATE(STRING(I,"99") + "/" + STRING(EvtDivi.Codmes,"99") + "/" + STRING(EvtDivi.Codano,"9999")).
            
            IF X-FECHA >= X-DESDE AND X-FECHA <= X-HASTA THEN DO:
                FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(EvtDivi.Codmes,"99") + "/" + STRING(EvtDivi.Codano,"9999")) NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN DO: 
                 T-Vtamn   = EvtDivi.Vtaxdiamn[I] + EvtDivi.Vtaxdiame[I] * Gn-Tcmb.Venta.
                 T-Vtame   = EvtDivi.Vtaxdiame[I] + EvtDivi.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                END.
                                                      
                FIND tmp-tempo WHERE t-codcia  = S-CODCIA                           
                                AND  t-fchdoc  = X-FECHA  NO-ERROR.
                      
                IF NOT AVAIL tmp-tempo THEN DO:
                  CREATE tmp-tempo.
                  ASSIGN t-codcia  = S-CODCIA
                         t-fchdoc  = X-FECHA.
                END.
                ASSIGN T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                       T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
      
                /******************************Secuencia Para Cargar Datos en las Columnas *****************/
                
                IF F-PERIODO-1 > 0 AND EvtDivi.Codano = F-PERIODO-1 THEN DO:
                   ASSIGN T-Venta[1] = T-venta[1] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[1] = T-Costo[1] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                END.       
                IF F-PERIODO-2 > 0 AND EvtDivi.Codano = F-PERIODO-2 THEN DO:
                   ASSIGN T-Venta[2] = T-venta[2] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[2] = T-Costo[2] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                END.       
                IF F-PERIODO-3 > 0 AND EvtDivi.Codano = F-PERIODO-3 THEN DO:
                   ASSIGN T-Venta[3] = T-venta[3] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[3] = T-Costo[3] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                END.       
                IF F-PERIODO-4 > 0 AND EvtDivi.Codano = F-PERIODO-4 THEN DO:
                   ASSIGN T-Venta[4] = T-venta[4] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[4] = T-Costo[4] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                END.       
                IF F-PERIODO-5 > 0 AND EvtDivi.Codano = F-PERIODO-5 THEN DO:
                   ASSIGN T-Venta[5] = T-venta[5] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[5] = T-Costo[5] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                END.                       
                /**************************************************************************/  
            END.          
       END.         
  END.
  END.
END.

HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Mensual-Articulo W-Win 
PROCEDURE Carga-Mensual-Articulo :
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

DO II = 1 TO NUM-ENTRIES(X-LLAVE) :

  IF INTEGER(ENTRY(II,X-LLAVE)) = 0 THEN NEXT. 
  X-DESDE = DATE(STRING(DAY(DesdeF),"99") + "/" + STRING(MONTH(DesdeF),"99") + "/" + ENTRY(II,X-LLAVE)).
  X-HASTA = DATE(STRING(DAY(HastaF),"99") + "/" + STRING(MONTH(HastaF),"99") + "/" + ENTRY(II,X-LLAVE)).
  FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
                     AND Gn-Divi.CodDiv BEGINS F-DIVISION:

  FOR EACH Evtarti NO-LOCK WHERE Evtarti.CodCia = S-CODCIA
                         AND   Evtarti.CodDiv = Gn-Divi.Coddiv
                         AND   Evtarti.Codmat = DesdeC
                         AND   (Evtarti.Nrofch >= INTEGER(STRING(YEAR(X-DESDE),"9999") + STRING(MONTH(X-DESDE),"99"))
                         AND   Evtarti.Nrofch <= INTEGER(STRING(YEAR(X-HASTA),"9999") + STRING(MONTH(X-HASTA),"99")) ):
                         

      DISPLAY Evtarti.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                          Almmmatg.Codmat = DesdeC NO-LOCK NO-ERROR.
      
                                
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
            IF X-FECHA >= X-DESDE AND X-FECHA <= X-HASTA THEN DO:
                FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")) NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN DO: 
                 F-Salida  = F-Salida  + Evtarti.CanxDia[I].
                 T-Vtamn   = T-Vtamn   + Evtarti.Vtaxdiamn[I] + Evtarti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                 T-Vtame   = T-Vtame   + Evtarti.Vtaxdiame[I] + Evtarti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                END.
            END.
            
            
       END.         
      
      /******************************************************************************/      

      FIND tmp-tempo WHERE t-codcia  = S-CODCIA
                      AND  t-codmat  = Evtarti.codmat
                      AND  t-codmes  = Evtarti.codmes
                     NO-ERROR.
      IF NOT AVAIL tmp-tempo THEN DO:
        CREATE tmp-tempo.
        ASSIGN t-codcia  = S-CODCIA
               t-Clase   = Almmmatg.Clase
               t-codmat  = Evtarti.codmat
               t-desmat  = Almmmatg.DesMat
               t-desmar  = Almmmatg.DesMar
               t-undbas  = Almmmatg.UndBas
               t-codmes  = Evtarti.codmes.
      END.
      ASSIGN T-Canti[10] = T-Canti[10] + F-Salida 
             T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
             T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
      
      /******************************Secuencia Para Cargar Datos en las Columnas *****************/
      
      IF F-PERIODO-1 > 0 AND Evtarti.Codano = F-PERIODO-1 THEN DO:
         ASSIGN T-Canti[1] = T-Canti[1] + F-Salida 
                T-Venta[1] = T-venta[1] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[1] = T-Costo[1] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
      END.       
      IF F-PERIODO-2 > 0 AND Evtarti.Codano = F-PERIODO-2 THEN DO:
         ASSIGN T-Canti[2] = T-Canti[2] + F-Salida 
                T-Venta[2] = T-venta[2] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[2] = T-Costo[2] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
      END.       
      IF F-PERIODO-3 > 0 AND Evtarti.Codano = F-PERIODO-3 THEN DO:
         ASSIGN T-Canti[3] = T-Canti[3] + F-Salida 
                T-Venta[3] = T-venta[3] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[3] = T-Costo[3] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
      END.       
      IF F-PERIODO-4 > 0 AND Evtarti.Codano = F-PERIODO-4 THEN DO:
         ASSIGN T-Canti[4] = T-Canti[4] + F-Salida  
                T-Venta[4] = T-venta[4] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[4] = T-Costo[4] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
      END.       
      IF F-PERIODO-5 > 0 AND Evtarti.Codano = F-PERIODO-5 THEN DO:
         ASSIGN T-Canti[5] = T-Canti[5] + F-Salida 
                T-Venta[5] = T-venta[5] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[5] = T-Costo[5] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
      END.       
      
      /**************************************************************************/
  END.
  END.
END.
HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Mensual-Division W-Win 
PROCEDURE Carga-Mensual-Division :
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

DO II = 1 TO NUM-ENTRIES(X-LLAVE) :

  IF INTEGER(ENTRY(II,X-LLAVE)) = 0 THEN NEXT. 
  X-DESDE = DATE(STRING(DAY(DesdeF),"99") + "/" + STRING(MONTH(DesdeF),"99") + "/" + ENTRY(II,X-LLAVE)).
  X-HASTA = DATE(STRING(DAY(HastaF),"99") + "/" + STRING(MONTH(HastaF),"99") + "/" + ENTRY(II,X-LLAVE)).
  FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
                     AND Gn-Divi.CodDiv BEGINS F-DIVISION:

  FOR EACH EvtDivi NO-LOCK WHERE EvtDivi.CodCia = S-CODCIA
                         AND   EvtDivi.CodDiv = Gn-Divi.Coddiv
                         AND   (EvtDivi.Nrofch >= INTEGER(STRING(YEAR(X-DESDE),"9999") + STRING(MONTH(X-DESDE),"99"))
                         AND   EvtDivi.Nrofch <= INTEGER(STRING(YEAR(X-HASTA),"9999") + STRING(MONTH(X-HASTA),"99")) ):
                         

      DISPLAY EvtDivi.Coddiv @ Fi-Mensaje LABEL "Codigo de Division "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                          Almmmatg.Codmat = DesdeC NO-LOCK NO-ERROR.
      
                                
      T-Vtamn   = 0.
      T-Vtame   = 0.
      T-Ctomn   = 0.
      T-Ctome   = 0.
      F-Salida  = 0.

      /*****************Capturando el Mes siguiente *******************/
      IF EvtDivi.Codmes < 12 THEN DO:
        ASSIGN
        X-CODMES = EvtDivi.Codmes + 1
        X-CODANO = EvtDivi.Codano .
      END.
      ELSE DO: 
        ASSIGN
        X-CODMES = 01
        X-CODANO = EvtDivi.Codano + 1 .
      END.
      /**********************************************************************/
      
      /*********************** Calculo Para Obtener los datos diarios ************/
       DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        

            X-FECHA = DATE(STRING(I,"99") + "/" + STRING(EvtDivi.Codmes,"99") + "/" + STRING(EvtDivi.Codano,"9999")).
            IF X-FECHA >= X-DESDE AND X-FECHA <= X-HASTA THEN DO:
                FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(EvtDivi.Codmes,"99") + "/" + STRING(EvtDivi.Codano,"9999")) NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN DO: 
                 T-Vtamn   = T-Vtamn   + EvtDivi.Vtaxdiamn[I] + EvtDivi.Vtaxdiame[I] * Gn-Tcmb.Venta.
                 T-Vtame   = T-Vtame   + EvtDivi.Vtaxdiame[I] + EvtDivi.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                END.
            END.
            
            
       END.         
      
      /******************************************************************************/      

      FIND tmp-tempo WHERE t-codcia  = S-CODCIA
                      AND  t-codmes  = EvtDivi.codmes
                     NO-ERROR.
      IF NOT AVAIL tmp-tempo THEN DO:
        CREATE tmp-tempo.
        ASSIGN t-codcia  = S-CODCIA
               t-codmes  = EvtDivi.codmes.
      END.
      ASSIGN T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
             T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
      
      /******************************Secuencia Para Cargar Datos en las Columnas *****************/
      
      IF F-PERIODO-1 > 0 AND EvtDivi.Codano = F-PERIODO-1 THEN DO:
         ASSIGN T-Venta[1] = T-venta[1] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[1] = T-Costo[1] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
      END.       
      IF F-PERIODO-2 > 0 AND EvtDivi.Codano = F-PERIODO-2 THEN DO:
         ASSIGN T-Venta[2] = T-venta[2] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[2] = T-Costo[2] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
      END.       
      IF F-PERIODO-3 > 0 AND EvtDivi.Codano = F-PERIODO-3 THEN DO:
         ASSIGN T-Venta[3] = T-venta[3] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[3] = T-Costo[3] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
      END.       
      IF F-PERIODO-4 > 0 AND EvtDivi.Codano = F-PERIODO-4 THEN DO:
         ASSIGN T-Venta[4] = T-venta[4] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[4] = T-Costo[4] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
      END.       
      IF F-PERIODO-5 > 0 AND EvtDivi.Codano = F-PERIODO-5 THEN DO:
         ASSIGN T-Venta[5] = T-venta[5] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                T-Costo[5] = T-Costo[5] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
      END.       
      
      /**************************************************************************/
  END.
  END.
END.
HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Semanal-Articulo W-Win 
PROCEDURE Carga-Semanal-Articulo :
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

DO II = 1 TO NUM-ENTRIES(X-LLAVE) :

  IF INTEGER(ENTRY(II,X-LLAVE)) = 0 THEN NEXT. 
  X-DESDE = DATE(STRING(DAY(DesdeF),"99") + "/" + STRING(MONTH(DesdeF),"99") + "/" + ENTRY(II,X-LLAVE)).
  X-HASTA = DATE(STRING(DAY(HastaF),"99") + "/" + STRING(MONTH(HastaF),"99") + "/" + ENTRY(II,X-LLAVE)).
  FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
                     AND Gn-Divi.CodDiv BEGINS F-DIVISION:

  FOR EACH Evtarti NO-LOCK WHERE Evtarti.CodCia = S-CODCIA
                         AND   Evtarti.CodDiv = Gn-Divi.Coddiv
                         AND   Evtarti.Codmat = DesdeC
                         AND   (Evtarti.Nrofch >= INTEGER(STRING(YEAR(X-DESDE),"9999") + STRING(MONTH(X-DESDE),"99"))
                         AND   Evtarti.Nrofch <= INTEGER(STRING(YEAR(X-HASTA),"9999") + STRING(MONTH(X-HASTA),"99")) ):
                         

      DISPLAY Evtarti.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                          Almmmatg.Codmat = DesdeC NO-LOCK NO-ERROR.
      
                                
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
            
            IF X-FECHA >= X-DESDE AND X-FECHA <= X-HASTA THEN DO:
                FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")) NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN DO: 
                 F-Salida  = Evtarti.CanxDia[I].
                 T-Vtamn   = Evtarti.Vtaxdiamn[I] + Evtarti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                 T-Vtame   = Evtarti.Vtaxdiame[I] + Evtarti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                END.
                FIND FIRST Pl-Sem WHERE Pl-Sem.Codcia  = S-CODCIA AND
                                  Pl-Sem.Periodo = Evtarti.Codano AND
                                  Pl-Sem.Fecini  >= X-FECHA NO-LOCK NO-ERROR.
                                      
                FIND tmp-tempo WHERE t-codcia  = S-CODCIA                           
                                AND  t-codmat  = Evtarti.codmat
                                AND  t-nrosem  = Pl-Sem.Nrosem  NO-ERROR.
                      
                IF NOT AVAIL tmp-tempo THEN DO:
                  CREATE tmp-tempo.
                  ASSIGN t-codcia  = S-CODCIA
                         t-Clase   = Almmmatg.Clase
                         t-codmat  = Evtarti.codmat
                         t-desmat  = Almmmatg.DesMat
                         t-desmar  = Almmmatg.DesMar
                         t-undbas  = Almmmatg.UndBas
                         t-nrosem  = Pl-sem.nrosem
                         t-fecini  = Pl-sem.fecini
                         t-fecfin  = Pl-sem.fecfin.
                END.
                ASSIGN T-Canti[10] = T-Canti[10] + F-Salida 
                       T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                       T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
      
                /******************************Secuencia Para Cargar Datos en las Columnas *****************/
                
                IF F-PERIODO-1 > 0 AND Evtarti.Codano = F-PERIODO-1 THEN DO:
                   ASSIGN T-Canti[1] = T-Canti[1] + F-Salida 
                          T-Venta[1] = T-venta[1] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[1] = T-Costo[1] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                END.       
                IF F-PERIODO-2 > 0 AND Evtarti.Codano = F-PERIODO-2 THEN DO:
                   ASSIGN T-Canti[2] = T-Canti[2] + F-Salida 
                          T-Venta[2] = T-venta[2] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[2] = T-Costo[2] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                END.       
                IF F-PERIODO-3 > 0 AND Evtarti.Codano = F-PERIODO-3 THEN DO:
                   ASSIGN T-Canti[3] = T-Canti[3] + F-Salida 
                          T-Venta[3] = T-venta[3] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[3] = T-Costo[3] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                END.       
                IF F-PERIODO-4 > 0 AND Evtarti.Codano = F-PERIODO-4 THEN DO:
                   ASSIGN T-Canti[4] = T-Canti[4] + F-Salida  
                          T-Venta[4] = T-venta[4] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[4] = T-Costo[4] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                END.       
                IF F-PERIODO-5 > 0 AND Evtarti.Codano = F-PERIODO-5 THEN DO:
                   ASSIGN T-Canti[5] = T-Canti[5] + F-Salida 
                          T-Venta[5] = T-venta[5] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[5] = T-Costo[5] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                END.                       
                /**************************************************************************/  
            END.          
       END.         
  END.
  END.
END.

HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Semanal-Division W-Win 
PROCEDURE Carga-Semanal-Division :
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

DO II = 1 TO NUM-ENTRIES(X-LLAVE) :

  IF INTEGER(ENTRY(II,X-LLAVE)) = 0 THEN NEXT. 
  X-DESDE = DATE(STRING(DAY(DesdeF),"99") + "/" + STRING(MONTH(DesdeF),"99") + "/" + ENTRY(II,X-LLAVE)).
  X-HASTA = DATE(STRING(DAY(HastaF),"99") + "/" + STRING(MONTH(HastaF),"99") + "/" + ENTRY(II,X-LLAVE)).
  FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
                     AND Gn-Divi.CodDiv BEGINS F-DIVISION:

  FOR EACH EvtDivi NO-LOCK WHERE EvtDivi.CodCia = S-CODCIA
                         AND   EvtDivi.CodDiv = Gn-Divi.Coddiv
                         AND   (EvtDivi.Nrofch >= INTEGER(STRING(YEAR(X-DESDE),"9999") + STRING(MONTH(X-DESDE),"99"))
                         AND   EvtDivi.Nrofch <= INTEGER(STRING(YEAR(X-HASTA),"9999") + STRING(MONTH(X-HASTA),"99")) ):
                         

      DISPLAY EvtDivi.Coddiv @ Fi-Mensaje LABEL "Codigo de Division "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                          Almmmatg.Codmat = DesdeC NO-LOCK NO-ERROR.
      
                                
      T-Vtamn   = 0.
      T-Vtame   = 0.
      T-Ctomn   = 0.
      T-Ctome   = 0.
      F-Salida  = 0.

      /*****************Capturando el Mes siguiente *******************/
      IF EvtDivi.Codmes < 12 THEN DO:
        ASSIGN
        X-CODMES = EvtDivi.Codmes + 1
        X-CODANO = EvtDivi.Codano .
      END.
      ELSE DO: 
        ASSIGN
        X-CODMES = 01
        X-CODANO = EvtDivi.Codano + 1 .
      END.
      /**********************************************************************/
      
      /*********************** Calculo Para Obtener los datos diarios ************/
       DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        

            X-FECHA = DATE(STRING(I,"99") + "/" + STRING(EvtDivi.Codmes,"99") + "/" + STRING(EvtDivi.Codano,"9999")).
            
            IF X-FECHA >= X-DESDE AND X-FECHA <= X-HASTA THEN DO:
                FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(EvtDivi.Codmes,"99") + "/" + STRING(EvtDivi.Codano,"9999")) NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN DO: 
                 T-Vtamn   = EvtDivi.Vtaxdiamn[I] + EvtDivi.Vtaxdiame[I] * Gn-Tcmb.Venta.
                 T-Vtame   = EvtDivi.Vtaxdiame[I] + EvtDivi.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                END.
                FIND FIRST Pl-Sem WHERE Pl-Sem.Codcia  = S-CODCIA AND
                                        Pl-Sem.Periodo = EvtDivi.Codano AND
                                        Pl-Sem.Fecini  >= X-FECHA NO-LOCK NO-ERROR.
                                      
                FIND tmp-tempo WHERE t-codcia  = S-CODCIA                           
                                AND  t-nrosem  = Pl-Sem.Nrosem  NO-ERROR.
                      
                IF NOT AVAIL tmp-tempo THEN DO:
                  CREATE tmp-tempo.
                  ASSIGN t-codcia  = S-CODCIA
                         t-nrosem  = Pl-sem.nrosem
                         t-fecini  = Pl-sem.fecini
                         t-fecfin  = Pl-sem.fecfin.
                END.
                ASSIGN T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                       T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
      
                /******************************Secuencia Para Cargar Datos en las Columnas *****************/
                
                IF F-PERIODO-1 > 0 AND EvtDivi.Codano = F-PERIODO-1 THEN DO:
                   ASSIGN T-Venta[1] = T-venta[1] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[1] = T-Costo[1] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                END.       
                IF F-PERIODO-2 > 0 AND EvtDivi.Codano = F-PERIODO-2 THEN DO:
                   ASSIGN T-Venta[2] = T-venta[2] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[2] = T-Costo[2] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                END.       
                IF F-PERIODO-3 > 0 AND EvtDivi.Codano = F-PERIODO-3 THEN DO:
                   ASSIGN T-Venta[3] = T-venta[3] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[3] = T-Costo[3] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                END.       
                IF F-PERIODO-4 > 0 AND EvtDivi.Codano = F-PERIODO-4 THEN DO:
                   ASSIGN T-Venta[4] = T-venta[4] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[4] = T-Costo[4] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                END.       
                IF F-PERIODO-5 > 0 AND EvtDivi.Codano = F-PERIODO-5 THEN DO:
                   ASSIGN T-Venta[5] = T-venta[5] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                          T-Costo[5] = T-Costo[5] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).      
                END.                       
                /**************************************************************************/  
            END.          
       END.         
  END.
  END.
END.

HIDE FRAME F-PROCESO.

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
  DISPLAY F-DIVISION DesdeC DesdeF HastaF C-tipo F-PERIODO-1 F-PERIODO-2 
          F-PERIODO-3 F-PERIODO-4 F-PERIODO-5 nCodMon 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-58 RECT-61 RECT-62 RECT-63 F-DIVISION DesdeC DesdeF HastaF C-tipo 
         F-PERIODO-1 F-PERIODO-2 F-PERIODO-3 F-PERIODO-4 F-PERIODO-5 nCodMon 
         Btn_OK Btn_Cancel Btn_Help BUTTON-5 
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
  
  RUN Carga-Mensual-Articulo.
  
  DEFINE FRAME F-REPORTE
         t-DesMat    FORMAT "X(25)"
         t-canti[1]  FORMAT "->>>>>>>>>9"
         t-venta[1]  FORMAT "->>>>>>>>>9"
         t-canti[2]  FORMAT "->>>>>>>>>9"
         t-venta[2]  FORMAT "->>>>>>>>>9"
         t-canti[3]  FORMAT "->>>>>>>>>9"
         t-venta[3]  FORMAT "->>>>>>>>>9"
         t-canti[4]  FORMAT "->>>>>>>>>9"
         t-venta[4]  FORMAT "->>>>>>>>>9"
         t-canti[5]  FORMAT "->>>>>>>>>9"
         t-venta[5]  FORMAT "->>>>>>>>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6B} + {&Prn3} FORMAT "X(50)" AT 1 SKIP(1)
         {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 40 FORMAT "X(50)" 
         {&PRN3} + {&PRN6A} + "(" + C-TIPO + ")" + {&PRN6B} + {&PRN3} AT 100 FORMAT "X(25)" SKIP(1)
         {&PRN3} + {&PRN6B} + "Pagina : " TO 130 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         {&PRN3} + {&PRN6B} + S-SUBTIT AT 1  FORMAT "X(60)" 
         {&PRN3} + {&PRN6B} + "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         {&PRN3} + {&PRN6B} + X-MONEDA AT 1  FORMAT "X(60)" 
         {&PRN3} + {&PRN6B} + "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         {&PRN3} + {&PRN6B} + "DIVISIONES EVALUADAS  : " + X-CODDIV  + {&PRN4} + {&PRN6B} At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        STRING(F-PERIODO-1,"9999") AT  35 
        STRING(F-PERIODO-2,"9999") AT  60 
        STRING(F-PERIODO-3,"9999") AT  85 
        STRING(F-PERIODO-4,"9999") AT  110 
        STRING(F-PERIODO-5,"9999") AT  135 SKIP
        "                            CANTIDAD   IMPORTE      CANTIDAD   IMPORTE      CANTIDAD   IMPORTE      CANTIDAD   IMPORTE       CANTIDAD   IMPORTE    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  WHERE t-canti[10] > 0 
                      BREAK BY t-codcia
                            BY t-codmat
                            BY t-codmes:


      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-codmat) THEN DO:
         PUT STREAM REPORT  " " SKIP.
         PUT STREAM REPORT   {&PRN6A} + "ARTICULO : "  FORMAT "X(10)" AT 1 
                             {&PRN6A} + t-codmat       FORMAT "X(8)"  AT 15
                             {&PRN6A} + t-desmat       FORMAT "X(40)" AT 25 
                             {&PRN6A} + t-desmar       FORMAT "X(15)" AT 70 
                             {&PRN6A} + t-undbas       FORMAT "X(8)" AT  90 SKIP.
         PUT STREAM REPORT   {&PRN6B} + '------------------------------------------' FORMAT "X(50)" SKIP.                      
   
      END.
      
      ACCUM  t-canti[1]  (TOTAL BY t-codcia) .
      ACCUM  t-canti[2]  (TOTAL BY t-codcia) .
      ACCUM  t-canti[3]  (TOTAL BY t-codcia) .
      ACCUM  t-canti[4]  (TOTAL BY t-codcia) .
      ACCUM  t-canti[5]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[1]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[2]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[3]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[4]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[5]  (TOTAL BY t-codcia) .

      
      DISPLAY STREAM REPORT 
                ENTRY(T-codmes,X-NOMMES) @ t-desmat
                t-canti[1] WHEN  t-canti[1] > 0 FORMAT "->>>>>>>>>9"
                t-venta[1] WHEN  t-venta[1] > 0 FORMAT "->>>>>>>>>9"
                t-canti[2] WHEN  t-canti[2] > 0 FORMAT "->>>>>>>>>9"
                t-venta[2] WHEN  t-venta[2] > 0 FORMAT "->>>>>>>>>9"
                t-canti[3] WHEN  t-canti[3] > 0 FORMAT "->>>>>>>>>9"
                t-venta[3] WHEN  t-venta[3] > 0 FORMAT "->>>>>>>>>9"
                t-canti[4] WHEN  t-canti[4] > 0 FORMAT "->>>>>>>>>9"
                t-venta[4] WHEN  t-venta[4] > 0 FORMAT "->>>>>>>>>9"
                t-canti[5] WHEN  t-canti[5] > 0 FORMAT "->>>>>>>>>9"
                t-venta[5] WHEN  t-venta[5] > 0 FORMAT "->>>>>>>>>9"
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

  
  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-canti[1]
            t-venta[1]
            t-canti[2]
            t-venta[2]
            t-canti[3]
            t-venta[3]
            t-canti[4]
            t-venta[4]
            t-canti[5]
            t-venta[5]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            {&PRN6A} + ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-canti[1]) @ t-canti[1]
            (ACCUM TOTAL BY t-codcia t-venta[1]) @ t-venta[1]
            (ACCUM TOTAL BY t-codcia t-canti[2]) @ t-canti[2]
            (ACCUM TOTAL BY t-codcia t-venta[2]) @ t-venta[2]
            (ACCUM TOTAL BY t-codcia t-canti[3]) @ t-canti[3]
            (ACCUM TOTAL BY t-codcia t-venta[3]) @ t-venta[3]
            (ACCUM TOTAL BY t-codcia t-canti[4]) @ t-canti[4]
            (ACCUM TOTAL BY t-codcia t-venta[4]) @ t-venta[4]
            (ACCUM TOTAL BY t-codcia t-canti[5]) @ t-canti[5]
            (ACCUM TOTAL BY t-codcia t-venta[5]) @ t-venta[5]
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
  
  RUN Carga-Semanal-Articulo.
  
  DEFINE FRAME F-REPORTE
         t-DesMat    FORMAT "X(25)"
         t-canti[1]  FORMAT "->>>>>>>>>9"
         t-venta[1]  FORMAT "->>>>>>>>>9"
         t-canti[2]  FORMAT "->>>>>>>>>9"
         t-venta[2]  FORMAT "->>>>>>>>>9"
         t-canti[3]  FORMAT "->>>>>>>>>9"
         t-venta[3]  FORMAT "->>>>>>>>>9"
         t-canti[4]  FORMAT "->>>>>>>>>9"
         t-venta[4]  FORMAT "->>>>>>>>>9"
         t-canti[5]  FORMAT "->>>>>>>>>9"
         t-venta[5]  FORMAT "->>>>>>>>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6B} + {&Prn3} FORMAT "X(50)" AT 1 SKIP(1)
         {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 40 FORMAT "X(50)" 
         {&PRN3} + {&PRN6A} + "(" + C-TIPO + ")" + {&PRN6B} + {&PRN3} AT 100 FORMAT "X(25)" SKIP(1)
         {&PRN3} + {&PRN6B} + "Pagina : " TO 130 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         {&PRN3} + {&PRN6B} + S-SUBTIT AT 1  FORMAT "X(60)" 
         {&PRN3} + {&PRN6B} + "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         {&PRN3} + {&PRN6B} + X-MONEDA AT 1  FORMAT "X(60)" 
         {&PRN3} + {&PRN6B} + "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         {&PRN3} + {&PRN6B} + "DIVISIONES EVALUADAS  : " + X-CODDIV  + {&PRN4} + {&PRN6B} At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        STRING(F-PERIODO-1,"9999") AT  35 
        STRING(F-PERIODO-2,"9999") AT  60 
        STRING(F-PERIODO-3,"9999") AT  85 
        STRING(F-PERIODO-4,"9999") AT  110 
        STRING(F-PERIODO-5,"9999") AT  135 SKIP
        "                            CANTIDAD   IMPORTE      CANTIDAD   IMPORTE      CANTIDAD   IMPORTE      CANTIDAD   IMPORTE       CANTIDAD   IMPORTE    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  WHERE t-canti[10] > 0 
                      BREAK BY t-codcia
                            BY t-codmat
                            BY t-nrosem:


      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-codmat) THEN DO:
         PUT STREAM REPORT  " " SKIP.
         PUT STREAM REPORT   {&PRN6A} + "ARTICULO : "  FORMAT "X(10)" AT 1 
                             {&PRN6A} + t-codmat       FORMAT "X(8)"  AT 15
                             {&PRN6A} + t-desmat       FORMAT "X(40)" AT 25 
                             {&PRN6A} + t-desmar       FORMAT "X(15)" AT 70 
                             {&PRN6A} + t-undbas       FORMAT "X(8)" AT  90 SKIP.
         PUT STREAM REPORT   {&PRN6B} + '------------------------------------------' FORMAT "X(50)" SKIP.                      
   
      END.
      
      ACCUM  t-canti[1]  (TOTAL BY t-codcia) .
      ACCUM  t-canti[2]  (TOTAL BY t-codcia) .
      ACCUM  t-canti[3]  (TOTAL BY t-codcia) .
      ACCUM  t-canti[4]  (TOTAL BY t-codcia) .
      ACCUM  t-canti[5]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[1]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[2]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[3]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[4]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[5]  (TOTAL BY t-codcia) .

      
      DISPLAY STREAM REPORT 
                ("Sem-" + STRING(t-nrosem,"99") + " " + SUBSTRING(STRING(t-fecini,"99/99/9999"),1,5) + "-" + SUBSTRING(STRING(t-fecfin,"99/99/9999"),1,5)) @ t-desmat
                t-canti[1] WHEN  t-canti[1] > 0 FORMAT "->>>>>>>>>9"
                t-venta[1] WHEN  t-venta[1] > 0 FORMAT "->>>>>>>>>9"
                t-canti[2] WHEN  t-canti[2] > 0 FORMAT "->>>>>>>>>9"
                t-venta[2] WHEN  t-venta[2] > 0 FORMAT "->>>>>>>>>9"
                t-canti[3] WHEN  t-canti[3] > 0 FORMAT "->>>>>>>>>9"
                t-venta[3] WHEN  t-venta[3] > 0 FORMAT "->>>>>>>>>9"
                t-canti[4] WHEN  t-canti[4] > 0 FORMAT "->>>>>>>>>9"
                t-venta[4] WHEN  t-venta[4] > 0 FORMAT "->>>>>>>>>9"
                t-canti[5] WHEN  t-canti[5] > 0 FORMAT "->>>>>>>>>9"
                t-venta[5] WHEN  t-venta[5] > 0 FORMAT "->>>>>>>>>9"
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

  
  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-canti[1]
            t-venta[1]
            t-canti[2]
            t-venta[2]
            t-canti[3]
            t-venta[3]
            t-canti[4]
            t-venta[4]
            t-canti[5]
            t-venta[5]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            {&PRN6A} + ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-canti[1]) @ t-canti[1]
            (ACCUM TOTAL BY t-codcia t-venta[1]) @ t-venta[1]
            (ACCUM TOTAL BY t-codcia t-canti[2]) @ t-canti[2]
            (ACCUM TOTAL BY t-codcia t-venta[2]) @ t-venta[2]
            (ACCUM TOTAL BY t-codcia t-canti[3]) @ t-canti[3]
            (ACCUM TOTAL BY t-codcia t-venta[3]) @ t-venta[3]
            (ACCUM TOTAL BY t-codcia t-canti[4]) @ t-canti[4]
            (ACCUM TOTAL BY t-codcia t-venta[4]) @ t-venta[4]
            (ACCUM TOTAL BY t-codcia t-canti[5]) @ t-canti[5]
            (ACCUM TOTAL BY t-codcia t-venta[5]) @ t-venta[5]
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
  
  RUN Carga-Diaria-Articulo.
  
  DEFINE FRAME F-REPORTE
         t-DesMat    FORMAT "X(25)"
         t-canti[1]  FORMAT "->>>>>>>>>9"
         t-venta[1]  FORMAT "->>>>>>>>>9"
         t-canti[2]  FORMAT "->>>>>>>>>9"
         t-venta[2]  FORMAT "->>>>>>>>>9"
         t-canti[3]  FORMAT "->>>>>>>>>9"
         t-venta[3]  FORMAT "->>>>>>>>>9"
         t-canti[4]  FORMAT "->>>>>>>>>9"
         t-venta[4]  FORMAT "->>>>>>>>>9"
         t-canti[5]  FORMAT "->>>>>>>>>9"
         t-venta[5]  FORMAT "->>>>>>>>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6B} + {&Prn3} FORMAT "X(50)" AT 1 SKIP(1)
         {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 40 FORMAT "X(50)" 
         {&PRN3} + {&PRN6A} + "(" + C-TIPO + ")" + {&PRN6B} + {&PRN3} AT 100 FORMAT "X(25)" SKIP(1)
         {&PRN3} + {&PRN6B} + "Pagina : " TO 130 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         {&PRN3} + {&PRN6B} + S-SUBTIT AT 1  FORMAT "X(60)" 
         {&PRN3} + {&PRN6B} + "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         {&PRN3} + {&PRN6B} + X-MONEDA AT 1  FORMAT "X(60)" 
         {&PRN3} + {&PRN6B} + "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         {&PRN3} + {&PRN6B} + "DIVISIONES EVALUADAS  : " + X-CODDIV  + {&PRN4} + {&PRN6B} At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        STRING(F-PERIODO-1,"9999") AT  35 
        STRING(F-PERIODO-2,"9999") AT  60 
        STRING(F-PERIODO-3,"9999") AT  85 
        STRING(F-PERIODO-4,"9999") AT  110 
        STRING(F-PERIODO-5,"9999") AT  135 SKIP
        "                            CANTIDAD   IMPORTE      CANTIDAD   IMPORTE      CANTIDAD   IMPORTE      CANTIDAD   IMPORTE       CANTIDAD   IMPORTE    " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  WHERE t-canti[10] > 0 
                      BREAK BY t-codcia
                            BY t-codmat
                            BY t-fchdoc:


      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(t-codmat) THEN DO:
         PUT STREAM REPORT  " " SKIP.
         PUT STREAM REPORT   {&PRN6A} + "ARTICULO : "  FORMAT "X(10)" AT 1 
                             {&PRN6A} + t-codmat       FORMAT "X(8)"  AT 15
                             {&PRN6A} + t-desmat       FORMAT "X(40)" AT 25 
                             {&PRN6A} + t-desmar       FORMAT "X(15)" AT 70 
                             {&PRN6A} + t-undbas       FORMAT "X(8)" AT  90 SKIP.
         PUT STREAM REPORT   {&PRN6B} + '------------------------------------------' FORMAT "X(50)" SKIP.                      
   
      END.
      
      ACCUM  t-canti[1]  (TOTAL BY t-codcia) .
      ACCUM  t-canti[2]  (TOTAL BY t-codcia) .
      ACCUM  t-canti[3]  (TOTAL BY t-codcia) .
      ACCUM  t-canti[4]  (TOTAL BY t-codcia) .
      ACCUM  t-canti[5]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[1]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[2]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[3]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[4]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[5]  (TOTAL BY t-codcia) .

      
      DISPLAY STREAM REPORT 
                STRING(t-fchdoc,"99/99/9999") @ t-desmat
                t-canti[1] WHEN  t-canti[1] > 0 FORMAT "->>>>>>>>>9"
                t-venta[1] WHEN  t-venta[1] > 0 FORMAT "->>>>>>>>>9"
                t-canti[2] WHEN  t-canti[2] > 0 FORMAT "->>>>>>>>>9"
                t-venta[2] WHEN  t-venta[2] > 0 FORMAT "->>>>>>>>>9"
                t-canti[3] WHEN  t-canti[3] > 0 FORMAT "->>>>>>>>>9"
                t-venta[3] WHEN  t-venta[3] > 0 FORMAT "->>>>>>>>>9"
                t-canti[4] WHEN  t-canti[4] > 0 FORMAT "->>>>>>>>>9"
                t-venta[4] WHEN  t-venta[4] > 0 FORMAT "->>>>>>>>>9"
                t-canti[5] WHEN  t-canti[5] > 0 FORMAT "->>>>>>>>>9"
                t-venta[5] WHEN  t-venta[5] > 0 FORMAT "->>>>>>>>>9"
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

  
  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-canti[1]
            t-venta[1]
            t-canti[2]
            t-venta[2]
            t-canti[3]
            t-venta[3]
            t-canti[4]
            t-venta[4]
            t-canti[5]
            t-venta[5]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            {&PRN6A} + ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-canti[1]) @ t-canti[1]
            (ACCUM TOTAL BY t-codcia t-venta[1]) @ t-venta[1]
            (ACCUM TOTAL BY t-codcia t-canti[2]) @ t-canti[2]
            (ACCUM TOTAL BY t-codcia t-venta[2]) @ t-venta[2]
            (ACCUM TOTAL BY t-codcia t-canti[3]) @ t-canti[3]
            (ACCUM TOTAL BY t-codcia t-venta[3]) @ t-venta[3]
            (ACCUM TOTAL BY t-codcia t-canti[4]) @ t-canti[4]
            (ACCUM TOTAL BY t-codcia t-venta[4]) @ t-venta[4]
            (ACCUM TOTAL BY t-codcia t-canti[5]) @ t-canti[5]
            (ACCUM TOTAL BY t-codcia t-venta[5]) @ t-venta[5]
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
  
  RUN Carga-Mensual-Division.
  
  DEFINE FRAME F-REPORTE
         t-DesMat    FORMAT "X(35)"
         t-venta[1]  FORMAT "->>>,>>>,>>>,>>9"
         t-venta[2]  FORMAT "->>>,>>>,>>>,>>9"
         t-venta[3]  FORMAT "->>>,>>>,>>>,>>9"
         t-venta[4]  FORMAT "->>>,>>>,>>>,>>9"
         t-venta[5]  FORMAT "->>>,>>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6B} + {&Prn3} FORMAT "X(50)" AT 1 SKIP(1)
         {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 40 FORMAT "X(50)" 
         {&PRN3} + {&PRN6A} + "(" + C-TIPO + ")" + {&PRN6B} + {&PRN3} AT 100 FORMAT "X(25)" SKIP(1)
         {&PRN3} + {&PRN6B} + "Pagina : " TO 130 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         {&PRN3} + {&PRN6B} + S-SUBTIT AT 1  FORMAT "X(60)" 
         {&PRN3} + {&PRN6B} + "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         {&PRN3} + {&PRN6B} + X-MONEDA AT 1  FORMAT "X(60)" 
         {&PRN3} + {&PRN6B} + "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         {&PRN3} + {&PRN6B} + "DIVISIONES EVALUADAS  : " + X-CODDIV  + {&PRN4} + {&PRN6B} At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        STRING(F-PERIODO-1,"9999") AT  49 
        STRING(F-PERIODO-2,"9999") AT  65 
        STRING(F-PERIODO-3,"9999") AT  82 
        STRING(F-PERIODO-4,"9999") AT  99 
        STRING(F-PERIODO-5,"9999") AT  117 SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  WHERE t-venta[10] > 0 
                      BREAK BY t-codcia
                            BY t-codmes:


      VIEW STREAM REPORT FRAME F-HEADER.

      
      ACCUM  t-venta[1]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[2]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[3]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[4]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[5]  (TOTAL BY t-codcia) .

      
      DISPLAY STREAM REPORT 
                ENTRY(T-codmes,X-NOMMES) @ t-desmat
                t-venta[1] WHEN  t-venta[1] > 0 FORMAT "->>>,>>>,>>>,>>9"
                t-venta[2] WHEN  t-venta[2] > 0 FORMAT "->>>,>>>,>>>,>>9"
                t-venta[3] WHEN  t-venta[3] > 0 FORMAT "->>>,>>>,>>>,>>9"
                t-venta[4] WHEN  t-venta[4] > 0 FORMAT "->>>,>>>,>>>,>>9"
                t-venta[5] WHEN  t-venta[5] > 0 FORMAT "->>>,>>>,>>>,>>9"
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

  
  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[1]
            t-venta[2]
            t-venta[3]
            t-venta[4]
            t-venta[5]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            {&PRN6A} + ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-venta[1]) @ t-venta[1]
            (ACCUM TOTAL BY t-codcia t-venta[2]) @ t-venta[2]
            (ACCUM TOTAL BY t-codcia t-venta[3]) @ t-venta[3]
            (ACCUM TOTAL BY t-codcia t-venta[4]) @ t-venta[4]
            (ACCUM TOTAL BY t-codcia t-venta[5]) @ t-venta[5]
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
  
  RUN Carga-Semanal-Division.
  
  DEFINE FRAME F-REPORTE
         t-DesMat    FORMAT "X(35)"
         t-venta[1]  FORMAT "->>>,>>>,>>>,>>9"
         t-venta[2]  FORMAT "->>>,>>>,>>>,>>9"
         t-venta[3]  FORMAT "->>>,>>>,>>>,>>9"
         t-venta[4]  FORMAT "->>>,>>>,>>>,>>9"
         t-venta[5]  FORMAT "->>>,>>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6B} + {&Prn3} FORMAT "X(50)" AT 1 SKIP(1)
         {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 40 FORMAT "X(50)" 
         {&PRN3} + {&PRN6A} + "(" + C-TIPO + ")" + {&PRN6B} + {&PRN3} AT 100 FORMAT "X(25)" SKIP(1)
         {&PRN3} + {&PRN6B} + "Pagina : " TO 130 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         {&PRN3} + {&PRN6B} + S-SUBTIT AT 1  FORMAT "X(60)" 
         {&PRN3} + {&PRN6B} + "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         {&PRN3} + {&PRN6B} + X-MONEDA AT 1  FORMAT "X(60)" 
         {&PRN3} + {&PRN6B} + "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         {&PRN3} + {&PRN6B} + "DIVISIONES EVALUADAS  : " + X-CODDIV  + {&PRN4} + {&PRN6B} At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        STRING(F-PERIODO-1,"9999") AT  49 
        STRING(F-PERIODO-2,"9999") AT  65 
        STRING(F-PERIODO-3,"9999") AT  82 
        STRING(F-PERIODO-4,"9999") AT  99 
        STRING(F-PERIODO-5,"9999") AT  117 SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  WHERE t-venta[10] > 0 
                      BREAK BY t-codcia
                            BY t-nrosem:


      VIEW STREAM REPORT FRAME F-HEADER.

      
      ACCUM  t-venta[1]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[2]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[3]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[4]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[5]  (TOTAL BY t-codcia) .

      
      DISPLAY STREAM REPORT 
                ("Sem-" + STRING(t-nrosem,"99") + " " + SUBSTRING(STRING(t-fecini,"99/99/9999"),1,5) + "-" + SUBSTRING(STRING(t-fecfin,"99/99/9999"),1,5)) @ t-desmat
                t-venta[1] WHEN  t-venta[1] > 0 FORMAT "->>>,>>>,>>>,>>9"
                t-venta[2] WHEN  t-venta[2] > 0 FORMAT "->>>,>>>,>>>,>>9"
                t-venta[3] WHEN  t-venta[3] > 0 FORMAT "->>>,>>>,>>>,>>9"
                t-venta[4] WHEN  t-venta[4] > 0 FORMAT "->>>,>>>,>>>,>>9"
                t-venta[5] WHEN  t-venta[5] > 0 FORMAT "->>>,>>>,>>>,>>9"
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

  
  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[1]
            t-venta[2]
            t-venta[3]
            t-venta[4]
            t-venta[5]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            {&PRN6A} + ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-venta[1]) @ t-venta[1]
            (ACCUM TOTAL BY t-codcia t-venta[2]) @ t-venta[2]
            (ACCUM TOTAL BY t-codcia t-venta[3]) @ t-venta[3]
            (ACCUM TOTAL BY t-codcia t-venta[4]) @ t-venta[4]
            (ACCUM TOTAL BY t-codcia t-venta[5]) @ t-venta[5]
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
  
  RUN Carga-Diaria-Division.
  
  DEFINE FRAME F-REPORTE
         t-DesMat    FORMAT "X(35)"
         t-venta[1]  FORMAT "->>>,>>>,>>>,>>9"
         t-venta[2]  FORMAT "->>>,>>>,>>>,>>9"
         t-venta[3]  FORMAT "->>>,>>>,>>>,>>9"
         t-venta[4]  FORMAT "->>>,>>>,>>>,>>9"
         t-venta[5]  FORMAT "->>>,>>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6B} + {&Prn3} FORMAT "X(50)" AT 1 SKIP(1)
         {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 40 FORMAT "X(50)" 
         {&PRN3} + {&PRN6A} + "(" + C-TIPO + ")" + {&PRN6B} + {&PRN3} AT 100 FORMAT "X(25)" SKIP(1)
         {&PRN3} + {&PRN6B} + "Pagina : " TO 130 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         {&PRN3} + {&PRN6B} + S-SUBTIT AT 1  FORMAT "X(60)" 
         {&PRN3} + {&PRN6B} + "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         {&PRN3} + {&PRN6B} + X-MONEDA AT 1  FORMAT "X(60)" 
         {&PRN3} + {&PRN6B} + "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         {&PRN3} + {&PRN6B} + "DIVISIONES EVALUADAS  : " + X-CODDIV  + {&PRN4} + {&PRN6B} At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        STRING(F-PERIODO-1,"9999") AT  49 
        STRING(F-PERIODO-2,"9999") AT  65 
        STRING(F-PERIODO-3,"9999") AT  82 
        STRING(F-PERIODO-4,"9999") AT  99 
        STRING(F-PERIODO-5,"9999") AT  117 SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  WHERE t-venta[10] > 0 
                      BREAK BY t-codcia
                            BY t-fchdoc:


      VIEW STREAM REPORT FRAME F-HEADER.

      
      ACCUM  t-venta[1]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[2]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[3]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[4]  (TOTAL BY t-codcia) .
      ACCUM  t-venta[5]  (TOTAL BY t-codcia) .

      
      DISPLAY STREAM REPORT 
                STRING(t-fchdoc,"99/99/9999") @ t-desmat
                t-venta[1] WHEN  t-venta[1] > 0 FORMAT "->>>,>>>,>>>,>>9"
                t-venta[2] WHEN  t-venta[2] > 0 FORMAT "->>>,>>>,>>>,>>9"
                t-venta[3] WHEN  t-venta[3] > 0 FORMAT "->>>,>>>,>>>,>>9"
                t-venta[4] WHEN  t-venta[4] > 0 FORMAT "->>>,>>>,>>>,>>9"
                t-venta[5] WHEN  t-venta[5] > 0 FORMAT "->>>,>>>,>>>,>>9"
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

  
  
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[1]
            t-venta[2]
            t-venta[3]
            t-venta[4]
            t-venta[5]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            {&PRN6A} + ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-venta[1]) @ t-venta[1]
            (ACCUM TOTAL BY t-codcia t-venta[2]) @ t-venta[2]
            (ACCUM TOTAL BY t-codcia t-venta[3]) @ t-venta[3]
            (ACCUM TOTAL BY t-codcia t-venta[4]) @ t-venta[4]
            (ACCUM TOTAL BY t-codcia t-venta[5]) @ t-venta[5]
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
         t-canti[10] FORMAT "->>>>>>>9.99"
         t-venta[10] FORMAT "->>>>>>>9.99"
         t-clase     FORMAT "X(2)" 
         

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6B} + {&Prn3} FORMAT "X(50)" AT 1 SKIP(1)
         {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 40 FORMAT "X(50)" 
         {&PRN3} + {&PRN6A} + "(" + C-TIPO + ")" + {&PRN6B} + {&PRN3} AT 100 FORMAT "X(25)" SKIP(1)
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
            {&PRN6A} + ("TOTAL   : " + S-NOMCIA ) @ t-desmat
            (ACCUM TOTAL BY t-codcia t-venta[10]) @ t-venta[10]
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
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.
   
  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
  
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
  s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").

  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY + "report.prn".
  
  CASE s-salida-impresion:
        WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
        WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
        WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
  END CASE.
  
  X-LLAVE  = STRING(F-PERIODO-1,"9999") + "," 
           + STRING(F-PERIODO-2,"9999") + ","
           + STRING(F-PERIODO-3,"9999") + ","
           + STRING(F-PERIODO-4,"9999") + ","
           + STRING(F-PERIODO-5,"9999") .

  IF DesdeC <> "" THEN DO:
    CASE C-Tipo:
      WHEN "Mensual"    THEN RUN Formato1.
      WHEN "Semanal"    THEN RUN Formato2.
      WHEN "Diario"     THEN RUN Formato3.
    END CASE. 
  END.
  ELSE DO:
    CASE C-Tipo:
      WHEN "Mensual"    THEN RUN Formato4.
      WHEN "Semanal"    THEN RUN Formato5.
      WHEN "Diario"     THEN RUN Formato6.
    END CASE. 
  END.
  
  
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
         F-Periodo-1 
         F-Periodo-2 
         F-Periodo-3
         F-Periodo-4 
         F-Periodo-5 
         DesdeC 
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
            F-PERIODO-1 = YEAR(TODAY) .
            F-PERIODO-2 = YEAR(TODAY) - 1.
            F-PERIODO-3 = YEAR(TODAY) - 2.
            F-PERIODO-4 = YEAR(TODAY) - 3.
            F-PERIODO-5 = YEAR(TODAY) - 4.
     DISPLAY DesdeF HastaF F-Periodo-1 F-Periodo-2 F-Periodo-3 F-Periodo-4 F-Periodo-5 .

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida W-Win 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DO WITH FRAME {&FRAME-NAME}:
    ASSIGN DesdeF HastaF .
    IF YEAR(DesdeF) <> YEAR(HastaF) THEN DO:
            MESSAGE "Rango de Fechas Errado "  SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO DesdeF IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR" .
    END.
 END.

 X-LLAVE  = STRING(F-PERIODO-1,"9999") + "," 
          + STRING(F-PERIODO-2,"9999") + ","
          + STRING(F-PERIODO-3,"9999") + ","
          + STRING(F-PERIODO-4,"9999") + ","
          + STRING(F-PERIODO-5,"9999") .

 X-ENTRA = FALSE.         
 
 DO I = 1 TO NUM-ENTRIES(X-LLAVE):
   IF STRING(YEAR(DesdeF),"9999") = ENTRY(I,X-LLAVE)  THEN X-ENTRA = TRUE.
 END.
 IF NOT X-ENTRA THEN DO:
      MESSAGE "Debe de Displayar el Periodo Elegido " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO F-PERIODO-1 IN FRAME {&FRAME-NAME}.
      RETURN "ADM-ERROR".
 END.                             

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


