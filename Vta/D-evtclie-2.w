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
DEFINE SHARED VAR cl-CODCIA  AS INTEGER.
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
DEFINE VAR T-Sdomn   AS DECI INIT 0.
DEFINE VAR T-Sdome   AS DECI INIT 0.
DEFINE VAR T-Vta     AS DECI INIT 0.
DEFINE VAR T-Cto     AS DECI INIT 0.
DEFINE VAR T-Sdo     AS DECI INIT 0.

DEFINE VAR X-CODDIV  AS CHAR.
DEFINE VAR X-LLAVE    AS CHAR.
DEFINE VAR X-FECHA AS DATE.
DEFINE VAR X-ENTRA AS LOGICAL INIT FALSE.
DEFINE VAR X-CODDIA AS INTEGER INIT 1.
DEFINE VAR X-CODANO AS INTEGER .
DEFINE VAR X-CODMES AS INTEGER .
DEFINE VAR X-NOMMES AS CHAR INIT "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre".
DEFINE VAR C-TIPO   AS CHAR INIT "Clientes".
DEFINE VAR X-DEP AS CHAR FORMAT "X(15)".
DEFINE VAR X-PRO AS CHAR FORMAT "X(15)".
DEFINE VAR X-DIS AS CHAR FORMAT "X(15)".


DEFINE TEMP-TABLE tmp-tempo 
    FIELD t-codcia  LIKE Evtdivi.Codcia 
    FIELD t-Codano  LIKE Evtdivi.Codano
    FIELD t-Codmes  LIKE Evtdivi.Codmes
    FIELD t-Coddia  LIKE Evtdivi.Codano
    FIELD t-fchdoc  LIKE Almdmov.fchdoc
    FIELD t-codcli  LIKE Evtclie.Codcli
    FIELD t-ruc     LIKE Gn-clie.Ruc
    FIELD t-dpto    AS CHAR FORMAT "X(15)"
    FIELD t-provi   AS CHAR FORMAT "X(15)"
    FIELD t-distr   AS CHAR FORMAT "X(15)"
    FIELD t-nomcli  LIKE Gn-clie.Nomcli FORMAT 'x(45)'
    FIELD t-clfcli  LIKE Gn-clie.clfcli
    FIELD t-ventamn AS DEC           FORMAT "->>>>>>>9.99" 
    FIELD t-ventame AS DEC           FORMAT "->>>>>>>9.99"
    FIELD t-costome AS DEC           FORMAT "->>>>>>>9.99"
    FIELD t-costomn AS DEC           FORMAT "->>>>>>>9.99"
    FIELD t-venta   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99"  
    FIELD t-costo   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99"  
    FIELD t-canti   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99" 
    FIELD t-saldo   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99"  
    FIELD t-saldomn AS DEC           FORMAT "->>>>>>>9.99"
    FIELD t-saldome AS DEC           FORMAT "->>>>>>>9.99".

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
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 BUTTON-1 f-clien DesdeF HastaF ~
nCodMon x-Dpto x-Provi x-Distr Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-Division f-clien f-nomcli DesdeF HastaF ~
nCodMon x-Dpto x-NomDpto x-Provi x-NomProvi x-Distr x-NomDistr txt-msj 

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

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE f-clien AS CHARACTER FORMAT "XXXXXXXXXXX":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-Division AS CHARACTER FORMAT "X(60)":U INITIAL "00000" 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE f-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.57 BY .81 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 70.29 BY .81
     BGCOLOR 1 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE x-Distr AS CHARACTER FORMAT "X(2)":U 
     LABEL "Distrito" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE x-Dpto AS CHARACTER FORMAT "X(2)":U 
     LABEL "Departamento" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomDistr AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomDpto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomProvi AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.

DEFINE VARIABLE x-Provi AS CHARACTER FORMAT "X(2)":U 
     LABEL "Provincia" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dolares", 2
     SIZE 16.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71.43 BY 10.77.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71.43 BY 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-Division AT ROW 2.38 COL 12 COLON-ALIGNED WIDGET-ID 14
     BUTTON-1 AT ROW 2.38 COL 57.57 WIDGET-ID 12
     f-clien AT ROW 3.46 COL 12 COLON-ALIGNED
     f-nomcli AT ROW 3.46 COL 23.43 COLON-ALIGNED NO-LABEL
     DesdeF AT ROW 4.46 COL 12 COLON-ALIGNED
     HastaF AT ROW 4.5 COL 28 COLON-ALIGNED
     nCodMon AT ROW 5.58 COL 14 NO-LABEL
     x-Dpto AT ROW 6.77 COL 13 COLON-ALIGNED
     x-NomDpto AT ROW 6.77 COL 18 COLON-ALIGNED NO-LABEL
     x-Provi AT ROW 7.77 COL 13 COLON-ALIGNED
     x-NomProvi AT ROW 7.77 COL 18 COLON-ALIGNED NO-LABEL
     x-Distr AT ROW 8.77 COL 13 COLON-ALIGNED
     x-NomDistr AT ROW 8.77 COL 18 COLON-ALIGNED NO-LABEL
     txt-msj AT ROW 10.35 COL 1.86 NO-LABEL WIDGET-ID 2
     Btn_OK AT ROW 12.12 COL 50
     Btn_Cancel AT ROW 12.12 COL 61
     "Criterio de Seleccion" VIEW-AS TEXT
          SIZE 22.86 BY .5 AT ROW 1.54 COL 4.43
          FONT 6
     "Moneda" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 5.69 COL 6
          FONT 6
     RECT-1 AT ROW 1.12 COL 1.57 WIDGET-ID 8
     RECT-2 AT ROW 11.92 COL 1.57 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 72.72 BY 13.12
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
         HEIGHT             = 13.12
         WIDTH              = 72.72
         MAX-HEIGHT         = 13.12
         MAX-WIDTH          = 72.72
         VIRTUAL-HEIGHT     = 13.12
         VIRTUAL-WIDTH      = 72.72
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
/* SETTINGS FOR FILL-IN F-Division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-nomcli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       txt-msj:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN x-NomDistr IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomDpto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomProvi IN FRAME F-Main
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
  DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:

    DEF VAR x-Divisiones AS CHAR.
    x-Divisiones = F-Division:SCREEN-VALUE.
    RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
    F-Division:SCREEN-VALUE = x-Divisiones.
    /*cDivi = x-Divisiones.*/
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


&Scoped-define SELF-NAME F-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Division W-Win
ON LEAVE OF F-Division IN FRAME F-Main /* División */
DO:
    ASSIGN F-Division.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Distr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Distr W-Win
ON LEAVE OF x-Distr IN FRAME F-Main /* Distrito */
DO:
  x-NomDistr:SCREEN-VALUE = ''.
  FIND Tabdistr WHERE Tabdistr.CodDepto = x-Dpto:SCREEN-VALUE 
    AND Tabdistr.Codprovi = x-Provi:SCREEN-VALUE 
    AND Tabdistr.Coddistr = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Tabdistr THEN x-NomDistr:SCREEN-VALUE = TabDistr.NomDistr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Dpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Dpto W-Win
ON LEAVE OF x-Dpto IN FRAME F-Main /* Departamento */
DO:
  x-NomDpto:SCREEN-VALUE = ''.
  FIND TabDepto WHERE TabDepto.CodDepto = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE TabDepto THEN x-NomDpto:SCREEN-VALUE = TabDepto.NomDepto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Provi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Provi W-Win
ON LEAVE OF x-Provi IN FRAME F-Main /* Provincia */
DO:
  x-NomProvi:SCREEN-VALUE = ''.
  FIND  Tabprovi WHERE Tabprovi.CodDepto = x-Dpto:SCREEN-VALUE 
    AND Tabprovi.Codprovi = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Tabprovi THEN x-NomProvi:SCREEN-VALUE = TabProvi.NomProvi. 
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
  ASSIGN F-Division 
         F-clien
         DesdeF 
         HastaF 
         nCodMon
         x-Distr x-Dpto x-Provi.
  
    
  S-SUBTIT =   "PERIODO      : " + STRING(DesdeF,"99/99/9999") + " al " + STRING(HastaF,"99/99/9999").

  X-MONEDA =   "MONEDA       : " + IF NCODMON = 1 THEN "NUEVOS SOLES " ELSE "DOLARES AMERICANOS ".  

  IF DesdeF = ?  THEN DesdeF = 01/01/1900.
  IF HastaF = ?  THEN HastaF = 01/01/3000.

  /*
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
  */
  
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

DEF VAR x-TpoCmb AS DEC   NO-UNDO.
DEF VAR x-Signo  AS INT   NO-UNDO.
DEF VAR cDivi    AS CHAR  NO-UNDO FORMAT "X(50)".

/*******Inicializa la Tabla Temporal ******/
FOR EACH tmp-tempo :
  DELETE tmp-tempo.
END.


cDivi = f-division:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

DISPLAY "Cargando Información...." @ txt-msj WITH FRAME {&FRAME-NAME}.

/********************************/
FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA 
    AND LOOKUP(Gn-Divi.CodDiv,cDivi) > 0:
    FOR EACH EvtClie NO-LOCK WHERE EvtClie.CodCia = S-CODCIA
        AND EvtClie.CodDiv = Gn-Divi.Coddiv
        AND EvtClie.Codcli BEGINS F-clien
        AND (EvtClie.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
        AND EvtClie.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) ),
        FIRST GN-CLIE NO-LOCK WHERE GN-CLIE.codcia = cl-codcia
            AND GN-CLIE.codcli = EvtClie.codcli
            AND gn-clie.CodDept BEGINS x-Dpto
            AND gn-clie.CodProv BEGINS x-Provi
            AND gn-clie.CodDist BEGINS x-Distr: 
            
      /****
      DISPLAY EvtClie.Codcli @ Fi-Mensaje LABEL "Cliente"
              FORMAT "X(11)" WITH FRAME F-Proceso.
      **********/
      T-Vtamn   = 0.
      T-Vtame   = 0.
      T-Ctomn   = 0.
      T-Ctome   = 0.
      T-Sdome   = 0.
      T-Sdomn   = 0.
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
                FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(EvtClie.Codmes,"99") + "/" + STRING(EvtClie.Codano,"9999")) NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN DO: 
                 T-Vtamn   = T-Vtamn   + EvtClie.Vtaxdiamn[I] + EvtClie.Vtaxdiame[I] * Gn-Tcmb.Venta.
                 T-Vtame   = T-Vtame   + EvtClie.Vtaxdiame[I] + EvtClie.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                 T-Ctomn   = T-Ctomn   + EvtClie.Ctoxdiamn[I] + EvtClie.Ctoxdiame[I] * Gn-Tcmb.Venta.
                 T-Ctome   = T-Ctome   + EvtClie.Ctoxdiame[I] + EvtClie.Ctoxdiamn[I] / Gn-Tcmb.Compra.
                END.
            END.
       END.         
       

      /******************************************************************************/      
      /*********************** Calculo Para Obtener los saldo diarios ************/
      FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia
                AND ccbcdocu.coddiv = gn-divi.coddiv
                AND ccbcdocu.fchdoc >= DesdeF
                AND ccbcdocu.fchdoc <= HastaF
                AND ccbcdocu.codcli = EvtClie.CodCli
                NO-LOCK:
            IF LOOKUP(TRIM(CcbCDocu.CodDoc),"TCK,FAC,BOL,N/C,N/D,LET,CHQ") = 0 THEN NEXT.
            IF CcbCDocu.FlgEst = "A"  THEN NEXT.
            x-Signo  = IF CcbCdocu.Coddoc = "N/C" THEN -1 ELSE 1.
            x-TpoCmb = 1.
/*             FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= ccbcdocu.fchdoc       */
/*                 NO-LOCK NO-ERROR.                                          */
/*             IF NOT AVAILABLE gn-tcmb                                       */
/*             THEN FIND FIRST gn-tcmb WHERE gn-tcmb.fecha <= ccbcdocu.fchdoc */
/*                 NO-LOCK NO-ERROR.                                          */
/*             IF AVAILABLE gn-tcmb THEN x-TpoCmb = gn-tcmb.venta.            */
            x-TpoCmb = Ccbcdocu.tpocmb.
            IF ccbcdocu.codmon = 1
            THEN ASSIGN
                    T-SdoMn = T-SdoMn + x-signo * ccbcdocu.sdoact
                    T-SdoMe = T-SdoMe + x-signo * ccbcdocu.sdoact / x-tpocmb.
            ELSE ASSIGN
                    T-SdoMe = T-SdoMe + x-signo * ccbcdocu.sdoact
                    T-SdoMn = T-SdoMn + x-signo * ccbcdocu.sdoact * x-tpocmb.
            PAUSE 0.
      END.            
      /******************************************************************************/      
     
      
      FIND tmp-tempo WHERE t-codcia  = S-CODCIA AND
                           T-codcli  = EvtClie.Codcli 
                           NO-ERROR.
      IF NOT AVAIL tmp-tempo THEN DO:
        CREATE tmp-tempo.
        ASSIGN t-codcia  = S-CODCIA
               T-Codcli  = EvtClie.Codcli .
        x-dep = "".
        x-pro = "".
        x-dis = "".
        FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
        IF AVAILABLE TabDepto THEN x-dep = TabDepto.NomDepto.

        FIND TabProvi WHERE TabProvi.CodDepto = gn-clie.CodDept 
            AND TabProvi.CodProvi = gn-clie.CodProv NO-LOCK NO-ERROR.
        IF AVAILABLE TabProvi THEN x-pro = TabProvi.NomProvi.

        FIND TabDistr WHERE TabDistr.CodDepto = gn-clie.CodDept 
            AND TabDistr.CodProvi = gn-clie.CodProv 
            AND TabDistr.CodDistr = gn-clie.CodDist NO-LOCK NO-ERROR.
        IF AVAILABLE TabDistr THEN x-dis = TabDistr.NomDistr.


        IF AVAILABLE gn-clie THEN 
        ASSIGN t-nomcli = gn-clie.Nomcli
               t-ruc    = gn-clie.ruc
               t-clfcli = gn-clie.clfcli
               t-dpto   = x-dep
               t-provi  = x-pro
               t-distr  = x-dis.
      END.
      ASSIGN T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
             T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome )
             T-Saldo[10] = T-Saldo[10] + ( IF ncodmon = 1 THEN T-Sdomn ELSE T-Sdome ).

     PAUSE 0.
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
  DISPLAY F-Division f-clien f-nomcli DesdeF HastaF nCodMon x-Dpto x-NomDpto 
          x-Provi x-NomProvi x-Distr x-NomDistr txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 BUTTON-1 f-clien DesdeF HastaF nCodMon x-Dpto x-Provi 
         x-Distr Btn_OK Btn_Cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     Impresion de ventas con el saldo
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN Carga-Temporal.
  
  DEFINE FRAME F-REPORTE
    t-Codcli    COLUMN-LABEL "Codigo"       FORMAT 'x(11)'
    t-Ruc       COLUMN-LABEL "RUC"
    t-nomcli    COLUMN-LABEL "Nombre o Razon Social"
    t-clfcli    COLUMN-LABEL "Calif."
    t-dpto      COLUMN-LABEL "Departamento"
    t-provi     COLUMN-LABEL "Provincia"
    t-distr     COLUMN-LABEL "Distrito"
    t-venta[10] COLUMN-LABEL "Importe"      FORMAT "->>,>>>,>>>,>>9"
    t-saldo[10] COLUMN-LABEL "Saldo"        FORMAT "->>,>>>,>>>,>>9"
    WITH WIDTH 200 NO-BOX STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + ")"  AT 100 FORMAT "X(25)" SKIP(1)
         "Pagina : " TO 130 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         X-MONEDA AT 1  FORMAT "X(60)" 
         "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         "DIVISIONES EVALUADAS  : " + X-CODDIV   At 1 FORMAT "X(150)" SKIP
         "LOS IMPORTE INCLUYEN I.G.V. "  At 1 FORMAT "X(150)" SKIP
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  WHERE t-venta[10] <> 0 
        BREAK BY T-Codcia
        BY T-venta[10] DESCENDING :
    VIEW STREAM REPORT FRAME F-HEADER.
    ACCUM  t-venta[10] ( TOTAL BY t-codcia).
    ACCUM  t-saldo[10] ( TOTAL BY t-codcia).
    DISPLAY STREAM REPORT 
                t-Codcli
                t-Ruc
                t-nomcli
                t-clfcli
                t-dpto   
                t-provi  
                t-distr                           
                t-venta[10]  
                t-saldo[10]
               WITH FRAME F-REPORTE.
    DOWN STREAM REPORT WITH FRAME F-REPORTE.

    IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[10]
            t-saldo[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            (ACCUM TOTAL BY t-codcia t-venta[10]) @ t-venta[10]
            (ACCUM TOTAL BY t-codcia t-saldo[10]) @ t-saldo[10]
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
    ENABLE ALL EXCEPT F-NOMCLI x-NomDistr x-NomDpto x-NomProvi txt-msj.
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

    RUN Carga-Temporal.

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        RUN Formato.
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
  ASSIGN F-Division 
         F-clien
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
            F-DIVISION = s-coddiv.
     DISPLAY DesdeF HastaF f-division .

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
        WHEN "x-Provi" THEN ASSIGN input-var-1 = x-Dpto:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        WHEN "x-Distr" 
        THEN DO:
            input-var-1 = x-Dpto:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
            input-var-2 = x-Provi:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        END.
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
         t-clfcli    AT 80
         t-dpto   
         t-provi             
         t-venta[10] FORMAT "->>,>>>,>>>,>>9"

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 40 FORMAT "X(50)" 
         "(" + C-TIPO + ")"  AT 100 FORMAT "X(25)" SKIP(1)
         "Pagina : " TO 130 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Fecha  :" TO 135 FORMAT "X(15)" TODAY TO 147 FORMAT "99/99/9999" SKIP
         X-MONEDA AT 1  FORMAT "X(60)" 
         "Hora   :" TO 135 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 147   SKIP
         "DIVISIONES EVALUADAS  : " + X-CODDIV   At 1 FORMAT "X(150)" SKIP
         "LOS IMPORTE INCLUYEN I.G.V. "  At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "  Codigo     RUC           Nombre o Razon Social                      Calificacion Departamento   Provincia                         Importe  " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  WHERE t-venta[10] <> 0 
                     BREAK BY T-Codcia
                           BY T-venta[10] DESCENDING :


      VIEW STREAM REPORT FRAME F-HEADER.
     
      ACCUM  t-venta[10] ( TOTAL BY t-codcia) .

      DISPLAY STREAM REPORT 
                t-Codcli
                t-Ruc
                t-nomcli
                t-clfcli
                t-dpto   
                t-provi                             
                t-venta[10]  FORMAT "->>>,>>>,>>9.99"
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL : " + S-NOMCIA ) @ t-Codano
            (ACCUM TOTAL BY t-codcia t-venta[10]) @ t-venta[10]
            WITH FRAME F-REPORTE.
      END.
     

  END.
   
/*
  RUN Carga-Temporal.
  
  DEFINE FRAME F-REPORTE
         t-Codcli   
         t-Ruc     
         t-nomcli
         t-clfcli    AT 80
         t-venta[10] AT 90 FORMAT "->>,>>>,>>>,>>9"

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
         "LOS IMPORTE INCLUYEN I.G.V. "  At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "  Codigo     RUC           Nombre o Razon Social                      Calificacion                       Importe  " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  WHERE t-venta[10] <> 0 
                     BREAK BY T-Codcia
                           BY T-venta[10] DESCENDING :


      VIEW STREAM REPORT FRAME F-HEADER.
     
      ACCUM  t-venta[10] ( TOTAL BY t-codcia) .

      DISPLAY STREAM REPORT 
                t-Codcli
                t-Ruc
                t-nomcli
                t-clfcli
                t-venta[10]  FORMAT "->>>,>>>,>>9.99"
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.

      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            {&PRN6A} + ("TOTAL : " + S-NOMCIA ) @ t-Codano
            (ACCUM TOTAL BY t-codcia t-venta[10]) @ t-venta[10]
            WITH FRAME F-REPORTE.
      END.
     

  END.
*/
  

  HIDE FRAME F-PROCESO.
  
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

