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
DEFINE VAR S-SUBTIT1  AS CHAR.
DEFINE VAR S-SUBTIT2  AS CHAR.
DEFINE VAR S-SUBTIT3  AS CHAR.
DEFINE VAR S-SUBTIT4  AS CHAR.
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
DEFINE VAR C-TIPO   AS CHAR INIT "Clientes".
DEFINE VAR N AS INTEGER.
DEFINE VAR Y-DESDEF AS DATE.
DEFINE VAR Y-HASTAF AS DATE.


DEFINE TEMP-TABLE tmp-tempo 
    FIELD t-codcia  LIKE Evtdivi.Codcia 
    FIELD t-Codano  LIKE Evtdivi.Codano
    FIELD t-Codmes  LIKE Evtdivi.Codmes
    FIELD t-Coddia  LIKE Evtdivi.Codano
    FIELD t-fchdoc  LIKE Almdmov.fchdoc
    FIELD t-codcli  LIKE Evtclie.Codcli
    FIELD t-ruc     LIKE Gn-clie.Ruc
    FIELD t-nomcli  LIKE Gn-clie.Nomcli
    FIELD t-clfcli  LIKE Gn-clie.clfcli
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
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-74 RECT-76 RECT-64 RECT-73 RECT-69 ~
BUTTON-1 f-clien DesdeF HastaF R-PER nCodMon Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS txt-Division f-clien f-nomcli DesdeF ~
HastaF R-PER nCodMon F-PER1 F-PER2 F-PER3 F-PER4 txt-msj 

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
     IMAGE-UP FILE "IMG/b-buscar.ico":U
     LABEL "..." 
     SIZE 4 BY .81.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-clien AS CHARACTER FORMAT "XXXXXXXXXXX":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .69 NO-UNDO.

DEFINE VARIABLE F-PER1 AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo 1" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-PER2 AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo 2" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-PER3 AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo 3" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-PER4 AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo 4" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE txt-Division AS CHARACTER FORMAT "X(60)":U INITIAL "00000" 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 37.43 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U INITIAL "Cargando Informacion....." 
     VIEW-AS FILL-IN 
     SIZE 19.29 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dolares", 2
     SIZE 11.29 BY 1.27 NO-UNDO.

DEFINE VARIABLE R-PER AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Periodo 1", 1,
"Periodo 2", 2,
"Periodo 3", 3,
"Periodo 4", 4
     SIZE 10.86 BY 3.08 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56 BY 1.92
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-64
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56 BY 3.5.

DEFINE RECTANGLE RECT-69
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 11.72 BY 3.27.

DEFINE RECTANGLE RECT-73
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 19 BY 3.77.

DEFINE RECTANGLE RECT-74
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 12.86 BY 1.65.

DEFINE RECTANGLE RECT-76
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56 BY 4.88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-Division AT ROW 2.12 COL 8.57 COLON-ALIGNED WIDGET-ID 4
     BUTTON-1 AT ROW 2.12 COL 48.43 WIDGET-ID 2
     f-clien AT ROW 3.12 COL 8.43 COLON-ALIGNED
     f-nomcli AT ROW 3.12 COL 20.43 COLON-ALIGNED NO-LABEL
     DesdeF AT ROW 3.92 COL 8.43 COLON-ALIGNED
     HastaF AT ROW 3.92 COL 23.29 COLON-ALIGNED
     R-PER AT ROW 6 COL 27.14 NO-LABEL
     nCodMon AT ROW 6.12 COL 44.86 NO-LABEL
     F-PER1 AT ROW 6.31 COL 10.14 COLON-ALIGNED
     F-PER2 AT ROW 7.08 COL 10.14 COLON-ALIGNED
     F-PER3 AT ROW 7.85 COL 10.14 COLON-ALIGNED
     F-PER4 AT ROW 8.62 COL 10.14 COLON-ALIGNED
     Btn_OK AT ROW 10.04 COL 23.72
     Btn_Cancel AT ROW 10.04 COL 35
     Btn_Help AT ROW 10.04 COL 46.43
     txt-msj AT ROW 10.31 COL 2.86 NO-LABEL WIDGET-ID 6
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18 BY .5 AT ROW 1.19 COL 4
          FONT 6
     "Moneda" VIEW-AS TEXT
          SIZE 6.72 BY .5 AT ROW 5.27 COL 44.29
          FONT 6
     "Periodos" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 5.27 COL 11.29
          FONT 6
     "Ordenado Por" VIEW-AS TEXT
          SIZE 12.14 BY .5 AT ROW 5.27 COL 25.86
          FONT 6
     RECT-74 AT ROW 5.88 COL 44.14
     RECT-76 AT ROW 4.96 COL 2
     RECT-64 AT ROW 1.46 COL 2
     RECT-73 AT ROW 5.88 COL 4.29
     RECT-46 AT ROW 9.85 COL 2
     RECT-69 AT ROW 5.88 COL 26.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1.08
         SIZE 58.86 BY 11.19
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
         HEIGHT             = 11.27
         WIDTH              = 58.86
         MAX-HEIGHT         = 11.27
         MAX-WIDTH          = 58.86
         VIRTUAL-HEIGHT     = 11.27
         VIRTUAL-WIDTH      = 58.86
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
/* SETTINGS FOR FILL-IN f-nomcli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PER1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PER2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PER3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-PER4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-Division IN FRAME F-Main
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:

    DEF VAR x-Divisiones AS CHAR.
    x-Divisiones = txt-Division:SCREEN-VALUE.
    RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
    txt-Division:SCREEN-VALUE = x-Divisiones.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeF W-Win
ON LEAVE OF DesdeF IN FRAME F-Main /* Desde */
DO:
    DO WITH FRAME {&FRAME-NAME}:
     ASSIGN DesdeF .
     F-PER1 = YEAR(DESDEF).
     F-PER2 = YEAR(DESDEF) - 1.
     F-PER3 = YEAR(DESDEF) - 2.
     F-PER4 = YEAR(DESDEF) - 3.

     DISPLAY F-PER1 F-PER2 F-PER3 F-PER4 .

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-clien
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-clien W-Win
ON LEAVE OF f-clien IN FRAME F-Main /* Cliente */
DO:
  ASSIGN F-clien .
  IF F-Clien = "" THEN DO:
     F-Nomcli:SCREEN-VALUE = "".
     RETURN.
  END.
  IF F-clien <> "" THEN DO: 
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
          gn-clie.Codcli = F-clien NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-clie THEN DO:
        MESSAGE "Codigo de Cliente NO Existe " SKIP
                "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO F-Clien IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.     
     END.
     F-Nomcli = gn-clie.Nomcli.
  END.
  DISPLAY F-NomCli WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-Division W-Win
ON LEAVE OF txt-Division IN FRAME F-Main /* División */
DO:
    ASSIGN txt-Division.
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
         F-clien
         DesdeF 
         HastaF 
         nCodMon 
         R-per
         txt-Division.

  S-SUBTIT1 =   "PERIODO-1    : " + STRING(DesdeF,"99/99/9999") + " al " + STRING(HastaF,"99/99/9999").
  S-SUBTIT2 =   "PERIODO-2    : " + STRING(DAY(DesdeF),"99") + "/" + STRING(MONTH(DesdeF),"99") + "/" + STRING(YEAR(DesdeF) - 1,"9999") +  
                           " al " + STRING(DAY(HastaF),"99") + "/" + STRING(MONTH(HastaF),"99") + "/" + STRING(YEAR(HastaF) - 1 ,"9999").
  S-SUBTIT3 =   "PERIODO-3    : " + STRING(DAY(DesdeF),"99") + "/" + STRING(MONTH(DesdeF),"99") + "/" + STRING(YEAR(DesdeF) - 2,"9999") +  
                           " al " + STRING(DAY(HastaF),"99") + "/" + STRING(MONTH(HastaF),"99") + "/" + STRING(YEAR(HastaF) - 2 ,"9999").
  S-SUBTIT4 =   "PERIODO-4    : " + STRING(DAY(DesdeF),"99") + "/" + STRING(MONTH(DesdeF),"99") + "/" + STRING(YEAR(DesdeF) - 3,"9999") +  
                           " al " + STRING(DAY(HastaF),"99") + "/" + STRING(MONTH(HastaF),"99") + "/" + STRING(YEAR(HastaF) - 3 ,"9999").

  X-MONEDA =   "MONEDA       : " + IF NCODMON = 1 THEN "NUEVOS SOLES " ELSE "DOLARES AMERICANOS ".  

  IF DesdeF = ?  THEN DesdeF = 01/01/1900.
  IF HastaF = ?  THEN HastaF = 01/01/3000.

  IF txt-Division = "" THEN DO:
    X-CODDIV = "".
    FOR EACH Gn-Divi NO-LOCK WHERE Gn-Divi.Codcia = S-CODCIA:
        X-CODDIV = X-CODDIV + SUBSTRING(Gn-Divi.Desdiv,1,10) + "," .
    END.
  END.
  ELSE DO:
    FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
        LOOKUP(Gn-Divi.Coddiv,txt-Division) > 0 NO-LOCK:
        X-CODDIV = X-CODDIV + SUBSTRING(Gn-Divi.Desdiv,1,20) + "," .
    END.
  END.  
  
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*
------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
Y-DESDEF = DESDEF.
Y-HASTAF = HASTAF.


/*******Inicializa la Tabla Temporal ******/
FOR EACH tmp-tempo :
  DELETE tmp-tempo.
END.
/********************************/




DO N = 1 TO 4 :

FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                       LOOKUP(Gn-Divi.Coddiv,txt-Division) > 0 :
    FOR EACH EvtClie NO-LOCK WHERE EvtClie.CodCia = S-CODCIA
                             AND   EvtClie.CodDiv = Gn-Divi.Coddiv
                             AND   EvtClie.Codcli BEGINS F-clien
                             AND   (EvtClie.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
                             AND   EvtClie.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) ):                         
      /*
      DISPLAY EvtClie.Codcli @ Fi-Mensaje LABEL "Cliente"
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */
      T-Vtamn   = 0.
      T-Vtame   = 0.
      T-Ctomn   = 0.
      T-Ctome   = 0.
      /*****************Capturando el Mes siguiente *******************/
      IF EvtClie.Codmes < 12 THEN DO:
        ASSIGN
        X-CODMES = EvtClie.Codmes + 1
        X-CODANO = EvtClie.Codano .
      END.
      ELSE DO: 
        ASSIGN
        X-CODMES = 01
        X-CODANO = EvtClie.Codano + 1 .
      END.
      /**********************************************************************/
      
      /*********************** Calculo Para Obtener los datos diarios ************/
       DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        

            X-FECHA = DATE(STRING(I,"99") + "/" + STRING(EvtClie.Codmes,"99") + "/" + STRING(EvtClie.Codano,"9999")).
            IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
                FIND LAST Gn-tcmb WHERE Gn-tcmb.Fecha <= DATE(STRING(I,"99") + "/" + STRING(EvtClie.Codmes,"99") + "/" + STRING(EvtClie.Codano,"9999")) NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN DO: 
                 T-Vtamn   = T-Vtamn   + EvtClie.Vtaxdiamn[I] + EvtClie.Vtaxdiame[I] * Gn-Tcmb.Venta.
                 T-Vtame   = T-Vtame   + EvtClie.Vtaxdiame[I] + EvtClie.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                 T-Ctomn   = T-Ctomn   + EvtClie.Ctoxdiamn[I] + EvtClie.Ctoxdiame[I] * Gn-Tcmb.Venta.
                 T-Ctome   = T-Ctome   + EvtClie.Ctoxdiame[I] + EvtClie.Ctoxdiamn[I] / Gn-Tcmb.Compra.
                END.
            END.
       END.         
      
      /******************************************************************************/      
     
      FIND tmp-tempo WHERE t-codcia  = S-CODCIA AND
                           T-codcli  = EvtClie.Codcli 
                           NO-ERROR.
                           
      IF NOT AVAIL tmp-tempo THEN DO:

        CREATE tmp-tempo.
        ASSIGN t-codcia  = S-CODCIA
               T-Codcli  = EvtClie.Codcli .

        FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
                           gn-clie.Codcli = EvtClie.Codcli  NO-LOCK NO-ERROR.
       
        IF AVAILABLE gn-clie THEN 
        ASSIGN t-nomcli = gn-clie.Nomcli
               t-ruc    = gn-clie.ruc
               t-clfcli = gn-clie.clfcli.         
      
      END.
      ASSIGN T-Venta[N] = T-venta[N] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
             T-Costo[N] = T-Costo[N] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).   
      
   END.    

END.

DesdeF = DATE(STRING(DAY(DesdeF),"99") + "/" + STRING(MONTH(DesdeF),"99") + "/" + STRING((YEAR(DesdeF) - 1 ),"9999")).
HastaF = DATE(STRING(DAY(HastaF),"99") + "/" + STRING(MONTH(HastaF),"99") + "/" + STRING((YEAR(HastaF) - 1 ),"9999")).

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
  DISPLAY txt-Division f-clien f-nomcli DesdeF HastaF R-PER nCodMon F-PER1 
          F-PER2 F-PER3 F-PER4 txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-74 RECT-76 RECT-64 RECT-73 RECT-69 BUTTON-1 f-clien DesdeF HastaF 
         R-PER nCodMon Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
    ENABLE ALL EXCEPT F-NOMCLI F-PER1 F-PER2 F-PER3 F-PER4.
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
        RUN Reporte.
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
  ASSIGN txt-Division
         F-clien
         DesdeF 
         HastaF 
         nCodMon
         R-per .
  
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
     F-PER1 = YEAR(DESDEF).
     F-PER2 = YEAR(DESDEF) - 1.
     F-PER3 = YEAR(DESDEF) - 2.
     F-PER4 = YEAR(DESDEF) - 3.

     DISPLAY DesdeF HastaF F-PER1 F-PER2 F-PER3 F-PER4 .

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Reporte W-Win 
PROCEDURE Reporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN Carga-Temporal.
  
  DEFINE FRAME F-REPORTE
         t-Codcli   
         t-Ruc     
         t-nomcli
         t-clfcli   AT 80
         t-venta[1] AT 90  FORMAT "->>>>>>>>>>9"
         t-venta[2] AT 105 FORMAT "->>>>>>>>>>9"
         t-venta[3] AT 120 FORMAT "->>>>>>>>>>9"
         t-venta[4] AT 135 FORMAT "->>>>>>>>>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + ")"  AT 100 FORMAT "X(25)" SKIP(1)
         "Pagina : " TO 130 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         S-SUBTIT1 AT 1  FORMAT "X(60)" 
         "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         S-SUBTIT2 AT 1  FORMAT "X(60)" 
         "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         S-SUBTIT3 AT 1  FORMAT "X(60)" SKIP
         S-SUBTIT4 AT 1  FORMAT "X(60)" SKIP
         X-MONEDA AT 1  FORMAT "X(60)" SKIP
         "DIVISIONES EVALUADAS  : " + X-CODDIV   At 1 FORMAT "X(150)" SKIP
         "LOS IMPORTES INCLUYEN I.G.V. "  At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "  Codigo     RUC           Nombre o Razon Social                      Calificacion           Periodo-1      Periodo-2     Periodo-3      Periodo-4   " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo BREAK BY T-Codcia
                           BY T-venta[r-per] DESCENDING :


      VIEW STREAM REPORT FRAME F-HEADER.
     
      ACCUM  t-venta[1] ( TOTAL BY t-codcia) .
      ACCUM  t-venta[2] ( TOTAL BY t-codcia) .
      ACCUM  t-venta[3] ( TOTAL BY t-codcia) .
      ACCUM  t-venta[4] ( TOTAL BY t-codcia) .

      DISPLAY STREAM REPORT 
                t-Codcli
                t-Ruc
                t-nomcli
                t-clfcli
                t-venta[1]  FORMAT "->>>>>>>>>>9"
                t-venta[2]  FORMAT "->>>>>>>>>>9"
                t-venta[3]  FORMAT "->>>>>>>>>>9"
                t-venta[4]  FORMAT "->>>>>>>>>>9"
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[1]
            t-venta[2]
            t-venta[3]
            t-venta[4]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL : " + S-NOMCIA ) @ t-Codano
            (ACCUM TOTAL BY t-codcia t-venta[1]) @ t-venta[1]
            (ACCUM TOTAL BY t-codcia t-venta[2]) @ t-venta[2]
            (ACCUM TOTAL BY t-codcia t-venta[3]) @ t-venta[3]
            (ACCUM TOTAL BY t-codcia t-venta[4]) @ t-venta[4]
            WITH FRAME F-REPORTE.
      END.
     

  END.
   
  
  /*
  HIDE FRAME F-PROCESO.
  */
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
/*
IF txt-DIVISION <> "" THEN DO:
        DO I = 1 TO NUM-ENTRIES(txt-DIVISION):
          FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                             Gn-Divi.Coddiv = ENTRY(I,txt-DIVISION) NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Divi THEN DO:
            MESSAGE "Division " + ENTRY(I,F-DIVISION) + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-DIVISION IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.                             
        END.
END.*/

IF DESDEF > HASTAF  THEN DO:
    MESSAGE "Fecha Final No puede ser menor " SKIP
            "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO HASTAF IN FRAME {&FRAME-NAME}.
    RETURN "ADM-ERROR".
    
END.

IF  ( YEAR(DESDEF) <> YEAR(HASTAF)) THEN DO:
    MESSAGE "Rango de Fechas deben de pertenecer al mismo año" SKIP
            "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO DESDEF IN FRAME {&FRAME-NAME}.
    RETURN "ADM-ERROR".
    
END.




RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

