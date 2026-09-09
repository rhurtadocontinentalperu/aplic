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
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(60)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje FORMAT 'x(20)' NO-LABEL FONT 6
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

DEFINE VARIABLE Division  AS CHAR FORMAT "X(40)" NO-UNDO.

DEFINE TEMP-TABLE tmp-temporal 
    FIELD tt-codcia  LIKE Almdmov.Codcia 
    FIELD tt-coddiv  LIKE evtall01.coddiv 
    FIELD tt-codfam  LIKE Almmmatg.codfam 
    FIELD tt-subfam  LIKE Almmmatg.subfam 
    FIELD tt-codcli  LIKE evtall01.codunico
    FIELD tt-name    LIKE gn-clie.nomcli
    FIELD tt-numano  AS   INTEGER
    FIELD tt-nummes  AS   INTEGER
    FIELD tt-mes     AS   CHARACTER
    FIELD tt-codmat  LIKE Almdmov.codmat    
    FIELD tt-mate    AS   CHARACTER          FORMAT "X(40)"
    FIELD tt-desmar  LIKE Almmmatg.DesMar    FORMAT "X(8)"
    FIELD tt-undbas  LIKE Almmmatg.UndBas    FORMAT "X(8)"
    FIELD tt-stkact  LIKE Almmmate.StkAct    FORMAT "->>>>>,>>9.99"
    FIELD tt-venta   AS DEC EXTENT 10 FORMAT "->>>>>>>9.99" 
    FIELD tt-costo   AS DEC EXTENT 10 FORMAT "->>>>>>>9.99"
    FIELD tt-canti   AS DEC EXTENT 10 FORMAT "->>>>>>>9.99" 
    FIELD tt-marge   AS DEC EXTENT 10 FORMAT "->>>>>>>9.99"
    FIELD tt-utili   AS DEC EXTENT 10 FORMAT "->>>>>>>9.99"
    INDEX Indice1 tt-codcia tt-coddiv tt-codfam tt-subfam.

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
&Scoped-Define ENABLED-OBJECTS f-Fam f-SubFam F-clien DesdeC BUTTON-4 ~
DesdeF HastaF nCodMon BUTTON-6 Btn_Cancel Btn_Help F-vend BUTTON-7 BUTTON-8 ~
BUTTON-2 BUTTON-1 RECT-63 RECT-61 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_Mensaje f-Fam f-SubFam F-clien ~
DesdeC DesdeF HastaF nCodMon F-vend f-Division txt-msj 

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

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 11 BY 1.5.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 4" 
     SIZE 4.43 BY .77.

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "IMG/tbldat.ico":U
     LABEL "Archivo" 
     SIZE 11 BY 1.5.

DEFINE BUTTON BUTTON-7 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 7" 
     SIZE 4.43 BY .77.

DEFINE BUTTON BUTTON-8 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 8" 
     SIZE 4.43 BY .77.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .69 NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .69 NO-UNDO.

DEFINE VARIABLE F-clien AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .69 NO-UNDO.

DEFINE VARIABLE f-Division AS CHARACTER FORMAT "X(60)":U INITIAL "00000" 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 32 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE f-Fam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .69 NO-UNDO.

DEFINE VARIABLE f-SubFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Sub Familia" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .69 NO-UNDO.

DEFINE VARIABLE F-vend AS CHARACTER FORMAT "X(9)":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .69 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U INITIAL "Cargando Informacion....." 
     VIEW-AS FILL-IN 
     SIZE 22.29 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dolares", 2
     SIZE 12 BY 1.88 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69 BY 1.5
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51 BY 7.27
     BGCOLOR 3 .

DEFINE RECTANGLE RECT-63
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15.72 BY 4.04.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN_Mensaje AT ROW 10.42 COL 2 NO-LABEL WIDGET-ID 20
     f-Fam AT ROW 3.31 COL 13.29 COLON-ALIGNED WIDGET-ID 2
     f-SubFam AT ROW 4.15 COL 13.29 COLON-ALIGNED WIDGET-ID 4
     F-clien AT ROW 5 COL 13.29 COLON-ALIGNED
     DesdeC AT ROW 6.73 COL 13.29 COLON-ALIGNED
     BUTTON-4 AT ROW 4.96 COL 26.43
     DesdeF AT ROW 7.62 COL 13.29 COLON-ALIGNED
     HastaF AT ROW 7.62 COL 29.29 COLON-ALIGNED
     nCodMon AT ROW 2.08 COL 55 NO-LABEL
     BUTTON-6 AT ROW 8.81 COL 37 WIDGET-ID 6
     Btn_Cancel AT ROW 8.81 COL 48.29
     Btn_Help AT ROW 8.81 COL 59.72
     F-vend AT ROW 5.85 COL 13.29 COLON-ALIGNED WIDGET-ID 8
     BUTTON-7 AT ROW 5.85 COL 26.43 WIDGET-ID 10
     BUTTON-8 AT ROW 3.27 COL 26.57 WIDGET-ID 12
     BUTTON-2 AT ROW 8.81 COL 25.86 WIDGET-ID 14
     f-Division AT ROW 2.35 COL 13.29 COLON-ALIGNED WIDGET-ID 18
     BUTTON-1 AT ROW 2.35 COL 48 WIDGET-ID 16
     txt-msj AT ROW 9.15 COL 2.72 NO-LABEL WIDGET-ID 22
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1.35 COL 4.43
          FONT 6
     " Moneda" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.27 COL 54
          FONT 6
     RECT-46 AT ROW 8.85 COL 2
     RECT-63 AT ROW 1.54 COL 53.72
     RECT-61 AT ROW 1.54 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 70.43 BY 10.27
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
         HEIGHT             = 10.27
         WIDTH              = 70.43
         MAX-HEIGHT         = 10.85
         MAX-WIDTH          = 70.43
         VIRTUAL-HEIGHT     = 10.85
         VIRTUAL-WIDTH      = 70.43
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN f-Division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       txt-msj:HIDDEN IN FRAME F-Main           = TRUE
       txt-msj:READ-ONLY IN FRAME F-Main        = TRUE.

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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 codW-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:

    DEF VAR x-Divisiones AS CHAR.
    x-Divisiones = F-Division:SCREEN-VALUE.
    RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
    F-Division:SCREEN-VALUE = x-Divisiones.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 codW-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
    RUN Asigna-Variables.
    RUN Valida.
    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR". 
    MESSAGE
      "El Reporte podría tomar algun tiempo" SKIP
      "Ser mas especifico acelera el Proceso" SKIP
      "Desea Continuar ?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE choice AS LOGICAL.
    CASE choice:
        WHEN TRUE  THEN DO: 
            txt-msj:VISIBLE IN FRAME {&FRAME-NAME} = YES.
            RUN Carga_Temporal.
        END.
        WHEN FALSE THEN RETURN.
    END.
    RUN Excel.
    RUN Inicializa-Variables.
    txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.
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


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 codW-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Archivo */
DO:
  RUN Asigna-Variables.
  RUN Valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR". 
  MESSAGE
      "El Reporte podría tomar algun tiempo" SKIP
      "Ser mas especifico acelera el Proceso" SKIP
      "Desea Continuar ?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE choice AS LOGICAL.
  CASE choice:
      WHEN TRUE THEN DO: 
          txt-msj:VISIBLE IN FRAME {&FRAME-NAME} = YES.
          RUN Carga_temporal.
      END.
      WHEN FALSE THEN RETURN.
  END.
  RUN Formato.
  RUN Inicializa-Variables.
  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 codW-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* Button 7 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "".
    output-var-2 = "".
    RUN lkup\C-vende.r("Vendedor").
    IF output-var-2 <> ? THEN DO:
        f-vend = output-var-2.
        DISPLAY f-vend.
        APPLY "ENTRY" TO f-vend .
        RETURN NO-APPLY.

    END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 codW-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* Button 8 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1  = "".
    output-var-2 = "".
    RUN lkup\C-Famili02.r("Familias").
    IF output-var-2 <> ? THEN DO:
        f-fam = output-var-2.
        DISPLAY f-fam.
        RETURN NO-APPLY.
    END.
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


&Scoped-define SELF-NAME f-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-Division codW-Win
ON LEAVE OF f-Division IN FRAME F-Main /* División */
DO:
    ASSIGN F-Division.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-Fam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-Fam codW-Win
ON LEAVE OF f-Fam IN FRAME F-Main /* Familia */
DO:
    ASSIGN f-Fam.
    IF f-Fam <> "" THEN DO: 
        FIND AlmtFam WHERE AlmtFam.CodCia = s-codcia 
            AND AlmtFam.CodFam = f-Fam NO-LOCK NO-ERROR.
        IF NOT AVAILABLE AlmtFam THEN DO:
            MESSAGE "Codigo de Familia NO Existe " SKIP
                "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO f-Fam IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.     
        END.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-SubFam codW-Win
ON LEAVE OF f-SubFam IN FRAME F-Main /* Sub Familia */
DO:
    ASSIGN 
        f-Fam
        f-subfam .
    IF f-subfam <> "" THEN DO: 
        FIND AlmsFam WHERE AlmsFam.CodCia = s-codcia 
            AND AlmsFam.CodFam = f-Fam
            AND AlmsFam.SubFam = f-subfam NO-LOCK NO-ERROR.
        IF NOT AVAILABLE AlmsFam THEN DO:
            MESSAGE "Codigo de SubFamilia NO Existe " SKIP
                "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO f-subfam IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.     
        END.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-vend
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-vend codW-Win
ON LEAVE OF F-vend IN FRAME F-Main /* Vendedor */
DO:
  ASSIGN f-vend .
  IF f-vend <> "" THEN DO: 
     FIND gn-ven WHERE gn-ven.CodCia = s-codcia AND 
          gn-ven.CodVen = f-vend NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-ven THEN DO:
        MESSAGE "Codigo de Vendedor NO Existe " SKIP
                "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO f-vend IN FRAME {&FRAME-NAME}.
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
  ASSIGN 
      F-Division 
      F-Clien 
      DesdeC 
      DesdeF 
      HastaF 
      nCodMon
      f-fam
      f-subfam
      f-vend.
  X-ARTI        = "ARTICULOS    : " + DesdeC.
  X-PROVE       = "PROVEEDOR    : "  + F-CLIEN.
    
    
  S-SUBTIT =   "PERIODO      : " + STRING(DesdeF,"99/99/9999") + " al " + STRING(HastaF,"99/99/9999").

  X-MONEDA =   "MONEDA       : " + IF NCODMON = 1 THEN "NUEVOS SOLES " ELSE "DOLARES AMERICANOS ".  

  IF DesdeF = ?  THEN DesdeF = 01/01/1900.
  IF HastaF = ?  THEN HastaF = 01/01/3000.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga_Temporal codW-Win 
PROCEDURE Carga_Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*DEFINE INPUT PARAMETER cCodDiv LIKE gn-divi.CodDiv.*/
    DEFINE VARIABLE iDiaUno AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iDiaDos AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iMes    AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iAnio   AS INTEGER    NO-UNDO.
    DEFINE VARIABLE i       AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cDesMat AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lValue  AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cName   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDivi   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dUtili  AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE cMeses  AS CHARACTER  EXTENT 12 NO-UNDO.
    
    cMeses[1] = "Enero".
    cMeses[2] = "Febrero".
    cMeses[3] = "Marzo".
    cMeses[4] = "Abril".
    cMeses[5] = "Mayo".
    cMeses[6] = "Junio".
    cMeses[7] = "Julio".
    cMeses[8] = "Agosto".
    cMeses[9] = "Setiembre".
    cMeses[10] = "Octubre".
    cMeses[11] = "Noviembre".
    cMeses[12] = "Diciembre".

    FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia AND LOOKUP(gn-divi.coddiv,f-division) > 0 NO-LOCK:        
        FOR EACH evtall01 USE-INDEX Indice01 WHERE evtall01.CodCia = s-CodCia
            AND evtall01.NroFch >= (YEAR(DesdeF) * 100 + MONTH(DesdeF))
            AND evtall01.NroFch <= (YEAR(HastaF) * 100 + MONTH(HastaF)) 
            AND evtall01.CodDiv = gn-divi.coddiv
            AND evtall01.CodFam BEGINS f-Fam
            AND evtall01.SubFam BEGINS f-SubFam
            AND evtall01.CodUnico BEGINS F-clien
            AND evtall01.CodVen BEGINS f-vend            
            AND EvtALL01.codmat BEGINS DesdeC NO-LOCK:

            IF MONTH(DesdeF) = MONTH(HastaF) THEN DO:
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

            iMes  = (evtall01.NroFch MODULO 100).
            iAnio = (evtall01.NroFch / 100).
            FIND FIRST gn-clie WHERE gn-clie.CodCia = cl-codcia
                AND gn-clie.CodCli = evtall01.CodUnico NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clie THEN cName = gn-clie.codcli + "-" + gn-clie.nomCli.

            FIND FIRST Almmmatg WHERE Almmmatg.CodCia = s-codcia
                AND Almmmatg.CodMat = evtall01.CodMat NO-LOCK NO-ERROR.
            IF AVAILABLE Almmmatg THEN cDesMat = Almmmatg.DesMat.
            FIND FIRST tmp-temporal WHERE tt-codcia = s-codcia
                AND tt-coddiv = evtall01.CodDiv
                AND tt-codfam = evtall01.codfam
                AND tt-subfam = evtall01.subfam
                AND tt-codcli = evtall01.codunico
                AND tt-codmat = evtall01.codmat 
                AND tt-numano = iAnio
                AND tt-nummes = iMes  NO-LOCK NO-ERROR.
            IF NOT AVAILABLE tmp-temporal THEN DO:
                CREATE tmp-temporal.
                ASSIGN
                    tt-codcia  =  evtall01.codcia
                    tt-coddiv  =  evtall01.CodDiv
                    tt-codfam  =  evtall01.codfam
                    tt-subfam  =  evtall01.subfam
                    tt-codcli  =  evtall01.codunico
                    tt-name    =  cName
                    tt-numano  =  iAnio
                    tt-nummes  =  iMes
                    tt-mes     =  cMeses[iMes]
                    tt-codmat  =  evtall01.codmat
                    tt-mate    =  evtall01.codmat + "-" + cDesMat
                    tt-desmar  =  almmmatg.desmar
                    tt-undbas  =  almmmatg.undbas.

                FILL-IN_Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Evtall01.CodMat + ' ' + EvtAll01.CodDiv + ' ' + STRING(EvtAll01.NroFch, '999999').
                /*
                DISPLAY Evtall01.codmat @ Fi-Mensaje 
                    LABEL "Codigo de Articulo "
                    WITH FRAME F-Proceso.
                */    
            END.
            DO i = iDiaUno TO iDiaDos:
                /**********Calcula Totales********/
                ASSIGN 
                    tt-Canti[1] = tt-Canti[1] + evtall01.Canxdia[i] 
                    tt-Venta[1] = tt-venta[1] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[i] ELSE evtall01.vtaxdiame[i] )
                    tt-Costo[1] = tt-Costo[1] + ( IF ncodmon = 1 THEN evtall01.ctoxdiamn[i] ELSE evtall01.ctoxdiame[i] )
                    tt-Utili[1] = tt-Utili[1] + ( IF ncodmon = 1 THEN evtall01.vtaxdiamn[i] - evtall01.ctoxdiamn[i] ELSE evtall01.vtaxdiame[i] - evtall01.ctoxdiame[i] ).        
            END.
            IF ncodmon = 1 THEN DO:
                dUtili = ((tt-Venta[1] - tt-Costo[1]) / tt-Venta[1]) .
                IF dUtili <> ? THEN tt-Marge[1] = dUtili.
            END.
            PAUSE 0.
        END.
    END.    
    /*
    HIDE FRAME F-Proceso.
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
  DISPLAY FILL-IN_Mensaje f-Fam f-SubFam F-clien DesdeC DesdeF HastaF nCodMon 
          F-vend f-Division txt-msj 
      WITH FRAME F-Main IN WINDOW codW-Win.
  ENABLE f-Fam f-SubFam F-clien DesdeC BUTTON-4 DesdeF HastaF nCodMon BUTTON-6 
         Btn_Cancel Btn_Help F-vend BUTTON-7 BUTTON-8 BUTTON-2 BUTTON-1 RECT-63 
         RECT-61 
      WITH FRAME F-Main IN WINDOW codW-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW codW-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel codW-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.
    
    DEF VAR Familia   AS CHAR FORMAT "X(40)" NO-UNDO.
    DEF VAR SubFami   AS CHAR FORMAT "X(40)" NO-UNDO.

    /* contamos los registros */
    DEF VAR iItems AS INT NO-UNDO.
    FOR EACH tmp-temporal:
        iItems = iItems + 1.
    END.
    IF iItems > 65530 THEN DO:
        MESSAGE 'El reporte supera los 65536 registros que soporta una hoja Excel'
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* Encabezado */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "REPORTE DE ESTADISTICA".

    iCount = iCount + 2.
    /* set the column names for the Worksheet */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Division".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cliente".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Periodo".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Mes".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fam".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "SubFam".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Articulo-Descripcion".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Marca".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Und.Base".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cantidad".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Venta".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "Costo".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "Margen".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "Utilidad".
    iCount = iCount + 1.

/*     DISPLAY "" @ Fi-Mensaje LABEL "Cargando Excel..." */
/*         FORMAT "X(20)" WITH FRAME F-Proceso.          */

    FOR EACH tmp-temporal NO-LOCK : 
        /*
        DISPLAY STRING(iCount) + ' ' + STRING(iItems) @ Fi-Mensaje LABEL "Cargando Excel..."
            FORMAT "X(20)" WITH FRAME F-Proceso.
        */    

        FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
            AND gn-divi.coddiv = tt-coddiv NO-LOCK NO-ERROR. 
        Division = tt-coddiv + "-" + gn-divi.desdiv.

        FIND FIRST AlmtFami WHERE AlmtFami.CodCia = s-codcia
            AND AlmtFami.CodFam = tt-codfam NO-LOCK NO-ERROR.
        Familia = tt-codfam.
        IF AVAILABLE Almtfami THEN Familia = tt-codfam + "-" + AlmtFami.DesFam.
    
        FIND FIRST AlmsFami WHERE AlmsFami.CodCia = s-codcia
            AND AlmsFami.CodFam = tt-codfam
            AND AlmsFami.subfam = tt-subfam NO-LOCK NO-ERROR.
        SubFami = tt-subfam.
        IF AVAILABLE ALmsfami THEN SubFami = tt-subfam + "-" + AlmsFami.DesSub.

        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = Division.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-name.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-numano.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-mes.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = Familia.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = SubFami.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-mate.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-desmar.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-undbas.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-canti[1].
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-venta[1].
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-costo[1].
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-marge[1].
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-utili[1].
        iCount = iCount + 1.

        PAUSE 0.
    END.
    /*
    HIDE FRAME F-Proceso.
    */

    MESSAGE "Proceso Terminado"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato codW-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR x-Archivo AS CHAR NO-UNDO.
    DEF VAR x-Rpta    AS LOG  NO-UNDO.

    DEF VAR Division  AS CHAR FORMAT "X(40)" NO-UNDO.
    DEF VAR Familia   AS CHAR FORMAT "X(40)" NO-UNDO.
    DEF VAR SubFami   AS CHAR FORMAT "X(40)" NO-UNDO.

    x-Archivo = 'EstVtas'+ STRING(YEAR(TODAY)) + STRING(MONTH(TODAY)) + string(DAY(TODAY)) + 
        '_' + SUBSTRING(STRING(TIME,"HH:MM"),1,2) + 
        SUBSTRING(STRING(TIME,"HH:MM"),4).
    SYSTEM-DIALOG GET-FILE x-Archivo
        FILTERS 'Texto' '*.txt'
        ASK-OVERWRITE
        CREATE-TEST-FILE
        DEFAULT-EXTENSION '.txt'
        INITIAL-DIR 'c:\tmp'
        RETURN-TO-START-DIR 
        USE-FILENAME
        SAVE-AS
        UPDATE x-rpta.
    IF x-rpta = NO THEN RETURN.

    SESSION:SET-WAIT-STATE('general').
    OUTPUT STREAM REPORT TO VALUE(x-Archivo).

    PUT STREAM REPORT
        "Div.|Cliente|Periodo|Mes|Fam|SubFam|Articulo - Descripcion|"
        "Marca|Und Base|Cantidad|Venta|Costo|Margen|Utilidad".
     
    PUT STREAM REPORT 
        "Total" SKIP.
    FOR EACH tmp-temporal NO-LOCK USE-INDEX Indice1:
        FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
            AND gn-divi.coddiv = tt-coddiv NO-LOCK NO-ERROR. 
        Division = tt-coddiv + "-" + gn-divi.desdiv.

        FIND AlmtFami WHERE AlmtFami.CodCia = s-codcia
            AND AlmtFami.CodFam = tt-codfam NO-LOCK NO-ERROR.
        Familia = tt-codfam + "-" + AlmtFami.DesFam.

        FIND AlmsFami WHERE AlmsFami.CodCia = s-codcia
            AND AlmsFami.CodFam = tt-codfam
            AND AlmsFami.subfam = tt-subfam NO-LOCK NO-ERROR.
        SubFami = tt-subfam + "-" + AlmsFami.DesSub.
        PUT STREAM REPORT
            Division "|"
            tt-name       "|"
            tt-numano     "|"
            tt-mes        "|"
            Familia       "|"
            SubFami       "|"
            tt-mate       "|"
            tt-desmar     "|"
            tt-undbas     "|"
            tt-canti[1]   "|" 
            tt-venta[1]   "|"
            tt-costo[1]   "|" 
            tt-marge[1]   "|"
            tt-utili[1]   SKIP.
        /*
        DISPLAY "" @ Fi-Mensaje LABEL ""
            FORMAT "X(11)" WITH FRAME F-Proceso.
        */    
    END.
    /*
    HIDE FRAME f-Proceso.
    */
    OUTPUT STREAM REPORT CLOSE.
    SESSION:SET-WAIT-STATE('').
    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.

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
    ASSIGN 
        F-Division = ""
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

