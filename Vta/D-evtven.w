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
DEFINE VAR X-TITU    AS CHAR INIT "ESTADISTICA DE VENTAS Vs. COSTOS X VENDEDOR Y FAMILIA".
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
DEFINE VAR x         AS int  INIT 0.
DEFINE VAR x-desfam  AS char.
DEFINE VAR X-MARGEN  AS deci INIT 0.

DEFINE VAR X-CODDIV  AS CHAR.
DEFINE VAR X-FAM     AS CHAR.
DEFINE VAR X-LLAVE    AS CHAR.
DEFINE VAR X-FECHA AS DATE.
DEFINE VAR X-ENTRA AS LOGICAL INIT FALSE.
DEFINE VAR X-CODDIA AS INTEGER INIT 1.
DEFINE VAR X-CODANO AS INTEGER .
DEFINE VAR X-CODMES AS INTEGER .
DEFINE VAR X-NOMMES AS CHAR INIT "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre".
DEFINE VAR C-TIPO   AS CHAR INIT "Clientes".


DEFINE TEMP-TABLE tmp-tempo 
    FIELD t-codcia  LIKE Evtdivi.Codcia 
    FIELD t-Codano  LIKE Evtdivi.Codano
    FIELD t-Codmes  LIKE Evtdivi.Codmes
    FIELD t-Coddia  LIKE Evtdivi.Codano
    FIELD t-fchdoc  LIKE Almdmov.fchdoc
    FIELD t-codven  LIKE Evtvend.Codven
    FIELD t-nomven  LIKE Gn-Ven.Nomven
    FIELD t-codfam  LIKE almmmatg.codfam
 
    
    FIELD t-ventamn AS DEC           FORMAT "->>>>>>>9.99" 
    FIELD t-ventame AS DEC           FORMAT "->>>>>>>9.99"
    FIELD t-costome AS DEC           FORMAT "->>>>>>>9.99"
    FIELD t-costomn AS DEC           FORMAT "->>>>>>>9.99"
    FIELD t-venta   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99"  
    FIELD t-costo   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99"  
    FIELD t-canti   AS DEC  EXTENT 10 FORMAT "->>>>>>>9.99" 
    INDEX llave01 t-codcia t-codven t-codfam 
    INDEX llave02 t-codcia t-codfam t-codven.

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
&Scoped-Define ENABLED-OBJECTS RECT-61 RECT-63 F-DIVISION BUTTON-5 F-linea ~
BUTTON-6 f-vendedor BUTTON-1 DesdeF HastaF R-Tipo nCodMon Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-DIVISION F-linea f-vendedor DesdeF ~
HastaF R-Tipo nCodMon txt-msj 

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

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 6" 
     SIZE 4.43 BY .81.

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 6" 
     SIZE 4.43 BY .81.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-DIVISION AS CHARACTER FORMAT "X(5)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-linea AS CHARACTER FORMAT "X(5)":U 
     LABEL "Linea" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE f-vendedor AS CHARACTER FORMAT "X(50)":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U INITIAL "Cargando Informacion....." 
     VIEW-AS FILL-IN 
     SIZE 39 BY .81
     BGCOLOR 7 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dolares", 2
     SIZE 16.72 BY .69 NO-UNDO.

DEFINE VARIABLE R-Tipo AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Vendedor-Linea", 1,
"Linea-Vendedor", 2
     SIZE 14.29 BY 1.62 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 65 BY 2.08
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65.14 BY 8.08
     BGCOLOR 3 .

DEFINE RECTANGLE RECT-63
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 23.43 BY 1.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-DIVISION AT ROW 2.15 COL 12 COLON-ALIGNED
     BUTTON-5 AT ROW 2.15 COL 25.14
     F-linea AT ROW 3.15 COL 12 COLON-ALIGNED
     BUTTON-6 AT ROW 3.23 COL 24.86
     f-vendedor AT ROW 4.23 COL 12 COLON-ALIGNED WIDGET-ID 98
     BUTTON-1 AT ROW 4.23 COL 55 WIDGET-ID 142
     DesdeF AT ROW 5.31 COL 12 COLON-ALIGNED
     HastaF AT ROW 5.31 COL 33 COLON-ALIGNED
     R-Tipo AT ROW 6.92 COL 6 NO-LABEL
     nCodMon AT ROW 7.35 COL 37 NO-LABEL
     Btn_OK AT ROW 9.88 COL 43
     Btn_Cancel AT ROW 9.88 COL 55
     txt-msj AT ROW 10.15 COL 3 NO-LABEL WIDGET-ID 2
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.43 BY .5 AT ROW 1.35 COL 4.43
          FONT 6
     " Moneda" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 6.92 COL 34.86
          FONT 6
     RECT-46 AT ROW 9.69 COL 2
     RECT-61 AT ROW 1.54 COL 1.86
     RECT-63 AT ROW 7.04 COL 33
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 67.72 BY 11.35
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
         TITLE              = "Ventas x Vendedor"
         HEIGHT             = 11.31
         WIDTH              = 67.72
         MAX-HEIGHT         = 12.35
         MAX-WIDTH          = 67.72
         VIRTUAL-HEIGHT     = 12.35
         VIRTUAL-WIDTH      = 67.72
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
ON END-ERROR OF W-Win /* Ventas x Vendedor */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Ventas x Vendedor */
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
  txt-msj:VISIBLE IN FRAME {&FRAME-NAME} = YES.
  RUN Imprime.  
  RUN Inicializa-Variables.
  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:

    DEF VAR x-Vendedores AS CHAR.
    x-Vendedores = f-vendedor:SCREEN-VALUE.
    RUN vta/d-lisven (INPUT-OUTPUT x-Vendedores).
    f-vendedor:SCREEN-VALUE = x-Vendedores.    
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
    input-var-1  = "".
    output-var-2 = "".
    RUN lkup\C-Famili02.r("Familias").
    IF output-var-2 <> ? THEN DO:
        F-LINEA = output-var-2.
        DISPLAY F-LINEA.
        RETURN NO-APPLY.
    END.
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
    IF F-DIVISION = ""  THEN RETURN.
   
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
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-linea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-linea W-Win
ON LEAVE OF F-linea IN FRAME F-Main /* Linea */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    ASSIGN F-DIVISION.
    IF F-DIVISION = ""  THEN RETURN.
   
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
         F-linea
         F-vendedor
         DesdeF 
         HastaF 
         nCodMon
         R-Tipo .
  
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDivi AS CHARACTER   NO-UNDO.


/******* Inicializa la Tabla Temporal ******/
FOR EACH tmp-tempo :
  DELETE tmp-tempo.
END.
/********************************/

cDivi = f-vendedor:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
FOR EACH Gn-Divi NO-LOCK WHERE Gn-Divi.Codcia = S-CODCIA 
    AND Gn-Divi.CodDiv BEGINS F-DIVISION:
    FOR EACH Gn-Ven WHERE Gn-Ven.Codcia = S-CODCIA NO-LOCK:
        IF cDivi <> "" THEN
            IF LOOKUP(gn-ven.codven,cDivi) = 0 THEN NEXT.
        FOR EACH Evtvend NO-LOCK WHERE evtvend.CodCia = S-CODCIA
                         AND   evtvend.CodDiv = Gn-Divi.Coddiv
                         AND   evtvend.Codven = Gn-Ven.Codven
                         AND   (evtvend.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
                         AND   evtvend.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) ):                         

      FIND FIRST Almmmatg WHERE Almmmatg.codcia = S-CODCIA and 
                                Almmmatg.codmat = evtvend.codmat and
                                Almmmatg.codfam BEGINS F-Linea
                                NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almmmatg THEN NEXT.
      
      /*
      DISPLAY evtvend.codven + " " + evtvend.codmat  @ Fi-Mensaje LABEL "Vendedor"
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */
    
      T-Vtamn   = 0.
      T-Vtame   = 0.
      T-Ctomn   = 0.
      T-Ctome   = 0.
      F-Salida  = 0.

      /*****************Capturando el Mes siguiente *******************/
      IF Evtvend.Codmes < 12 THEN DO:
        ASSIGN
        X-CODMES = EvtVend.Codmes + 1
        X-CODANO = EvtVend.Codano .
      END.
      ELSE DO: 
        ASSIGN
        X-CODMES = 01
        X-CODANO = EvtVend.Codano + 1 .
      END.
      /**********************************************************************/
      
      /*********************** Calculo Para Obtener los datos diarios ************/
       DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        

            X-FECHA = DATE(STRING(I,"99") + "/" + STRING(EvtVend.Codmes,"99") + "/" + STRING(EvtVend.Codano,"9999")).
         
            IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
                FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(EvtVend.Codmes,"99") + "/" + STRING(EvtVend.Codano,"9999")) NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN DO: 
                 F-Salida  = F-Salida  + Evtvend.CanxDia[I].
                 T-Vtamn   = T-Vtamn   + Evtvend.Vtaxdiamn[I] + Evtvend.Vtaxdiame[I] * Gn-Tcmb.Venta.
                 T-Vtame   = T-Vtame   + Evtvend.Vtaxdiame[I] + Evtvend.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                 T-Ctomn   = T-Ctomn   + Evtvend.Ctoxdiamn[I] + Evtvend.Ctoxdiame[I] * Gn-Tcmb.Venta.
                 T-Ctome   = T-Ctome   + Evtvend.Ctoxdiame[I] + Evtvend.Ctoxdiamn[I] / Gn-Tcmb.Compra.
                END.
            END.
       END.         
      
      /******************************************************************************/      
      
     
      FIND tmp-tempo WHERE t-codcia  = S-CODCIA AND
                           T-codven  = evtvend.Codven AND
                           T-codfam  = Almmmatg.Codfam
                           USE-INDEX llave01
                           NO-ERROR .
                           
      IF NOT AVAIL tmp-tempo THEN DO:
        CREATE tmp-tempo.
        ASSIGN t-codcia  = S-CODCIA
               T-Codven  = evtvend.Codven 
               t-codfam  = Almmmatg.Codfam.
        /*
        FIND gn-ven WHERE gn-ven.CodCia = 1 AND 
                           gn-ven.Codven = evtvend.CodVen  NO-LOCK NO-ERROR.
       
        IF AVAILABLE gn-ven THEN 
        */
        ASSIGN t-nomven = gn-ven.Nomven.
      END.
      ASSIGN T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
             T-Costo[10] = T-Costo[10] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).   
             
      
        END.
    END.
END.
/*
HIDE FRAME F-PROCESO.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cliente-Linea W-Win 
PROCEDURE Cliente-Linea :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN Carga-Temporal.
  
  DEFINE FRAME F-REPORTE
         t-Codven    AT  1 FORMAT "X(4)"
         t-nomven    AT  6 FORMAT "X(20)"
         t-codfam    AT 30 FORMAT "X(3)"
         x-desfam    AT 36 FORMAT "X(20)"
         t-COSTO[10] AT 60 FORMAT "->>,>>>,>>>,>>9"
         t-venta[10] AT 77 FORMAT "->>,>>>,>>>,>>9"
         x-margen    AT 94 FORMAT "->>,>>>,>>>,>>9"




        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 15 FORMAT "X(70)" SKIP
         "Pagina : " TO 75 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Fecha  :" TO  75 FORMAT "X(15)" TODAY TO 92 FORMAT "99/99/9999" SKIP
         X-MONEDA AT 1  FORMAT "X(60)" 
         "Hora   :" TO  75 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 92   SKIP
         "DIVISIONES EVALUADAS  : " + X-CODDIV   At 1 FORMAT "X(150)" SKIP
         "LOS IMPORTE INCLUYEN I.G.V. "  At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                    TOTAL          TOTAL               TOTAL" SKIP
        "Cod  Nombre Vendedor           Familia                              COSTO          VENTA              MARGEN" SKIP
        "------------------------------------------------------------------------------------------------------------" SKIP
        WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  WHERE t-venta[10] <> 0
                      BREAK BY T-Codcia
                            BY t-codven
                            BY T-CODFAM
                            :
      x-margen = t-venta[10] - t-costo[10].

                            
      ACCUM  t-venta[10]  ( SUB-TOTAL BY T-codven).
      ACCUM  t-costo[10]  ( SUB-TOTAL BY T-Codven).
      ACCUM  x-margen     ( SUB-TOTAL BY T-Codven).
      
      ACCUM  t-venta[10] ( TOTAL BY t-codcia) .
      ACCUM  t-costo[10] ( TOTAL BY t-codcia) .
      ACCUM  x-margen    ( TOTAL BY t-codcia) .
      
                           
      VIEW STREAM REPORT FRAME F-HEADER.
      x = 0.
      if first-of(t-Codven) then do:
       x = 1.
      end.
      FIND AlmtFami WHERE AlmtFami.Codcia = S-CODCIA 
                    AND  AlmtFami.CodFam  =  t-codFam 
                    NO-LOCK NO-ERROR.
      x-desfam = "".
      if available AlmtFami then x-desfam = AlmtFami.desfam.
    
      DISPLAY STREAM REPORT
        
         t-Codven when x = 1
         t-nomven when x = 1
         t-codfam
         x-desfam
         t-venta[10]  
         t-costo[10]
         x-margen
         
         WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.
      
      IF LAST-OF(t-codven) THEN DO:
        UNDERLINE STREAM REPORT 
            t-costo[10]
            t-venta[10]
            x-margen
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL : ") @ t-nomven 
            (ACCUM SUB-TOTAL BY t-codven t-costo[10]) @ t-costo[10]
            (ACCUM SUB-TOTAL BY t-codven t-venta[10]) @ t-venta[10]
            (ACCUM SUB-TOTAL BY t-codven x-margen)    @ x-margen

            WITH FRAME F-REPORTE.
      END.
     

      

      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[10]
            t-costo[10]
            x-margen
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL : " + S-NOMCIA ) @ t-nomven
            (ACCUM TOTAL BY t-codcia t-costo[10]) @ t-costo[10]
            (ACCUM TOTAL BY t-codcia t-venta[10]) @ t-venta[10]
            (ACCUM TOTAL BY t-codcia x-margen)    @ x-margen
            WITH FRAME F-REPORTE.
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
  DISPLAY F-DIVISION F-linea f-vendedor DesdeF HastaF R-Tipo nCodMon txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-61 RECT-63 F-DIVISION BUTTON-5 F-linea BUTTON-6 f-vendedor 
         BUTTON-1 DesdeF HastaF R-Tipo nCodMon Btn_OK Btn_Cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
        
        CASE R-Tipo:
            WHEN 1 THEN RUN Cliente-Linea.
            WHEN 2 THEN RUN Linea-Cliente.
        END.
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
/* DO WITH FRAME {&FRAME-NAME}: */
/*     DISABLE ALL.             */
/* END.                         */

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
         F-vendedor
         DesdeF 
         HastaF 
         nCodMon 
         R-Tipo.
  
  IF DesdeF <> ?  THEN DesdeF = ?.
  IF HastaF <> ?  THEN HastaF = ?.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Linea-Cliente W-Win 
PROCEDURE Linea-Cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN Carga-Temporal.
  
  DEFINE FRAME F-REPORTE
         t-codfam   FORMAT "X(3)" 
         x-desfam   FORMAT "X(25)" 
         t-Codven   FORMAt "X(6)" 
         t-nomven   FORMAT "X(20)"
         t-COSTO[10] AT 60 FORMAT "->>,>>>,>>>,>>9"
         t-venta[10] AT 77 FORMAT "->>,>>>,>>>,>>9"
         x-margen    AT 94 FORMAT "->>,>>>,>>>,>>9"




        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU AT 15 FORMAT "X(70)" SKIP
         "Pagina : " TO 75 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         S-SUBTIT AT 1  FORMAT "X(60)" 
         "Fecha  :" TO  75 FORMAT "X(15)" TODAY TO 92 FORMAT "99/99/9999" SKIP
         X-MONEDA AT 1  FORMAT "X(60)" 
         "Hora   :" TO  75 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 92   SKIP
         "DIVISIONES EVALUADAS  : " + X-CODDIV   At 1 FORMAT "X(150)" SKIP
         "LOS IMPORTE INCLUYEN I.G.V. "  At 1 FORMAT "X(150)" SKIP

        "------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                    TOTAL          TOTAL               TOTAL" SKIP
        "Familia                Cod  Nombre Vendedor                         COSTO          VENTA              MARGEN" SKIP
        "------------------------------------------------------------------------------------------------------------" SKIP
        WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  FOR EACH tmp-tempo  WHERE t-venta[10] <> 0 
                      BREAK BY T-Codcia
                            BY T-CODFAM
                            BY t-codven:
      x-margen = t-venta[10] - t-costo[10].

                            
      ACCUM  t-venta[10]  ( SUB-TOTAL BY T-codfam).
      ACCUM  t-costo[10]  ( SUB-TOTAL BY T-Codfam).
      ACCUM  x-margen     ( SUB-TOTAL BY T-Codfam).
      
      ACCUM  t-venta[10] ( TOTAL BY t-codcia) .
      ACCUM  t-costo[10] ( TOTAL BY t-codcia) .
      ACCUM  x-margen    ( TOTAL BY t-codcia) .
      
                           
      VIEW STREAM REPORT FRAME F-HEADER.
      x = 0.
      if first-of(t-Codfam) then do:
       x = 1.
      end.
      FIND AlmtFami WHERE AlmtFami.Codcia = S-CODCIA 
                    AND  AlmtFami.CodFam  =  t-codFam 
                    NO-LOCK NO-ERROR.
      x-desfam = "".
      if available AlmtFami then x-desfam = AlmtFami.desfam.
    
      DISPLAY STREAM REPORT
        
         t-Codfam when x = 1
         x-desfam when x = 1
         t-codven
         t-nomven
         t-venta[10]  
         t-costo[10]
         x-margen
         
         WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.
      
      IF LAST-OF(t-codfam) THEN DO:
        UNDERLINE STREAM REPORT 
            t-costo[10]
            t-venta[10]
            x-margen
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL : ") @ x-desfam 
            (ACCUM SUB-TOTAL BY t-codfam t-costo[10]) @ t-costo[10]
            (ACCUM SUB-TOTAL BY t-codfam t-venta[10]) @ t-venta[10]
            (ACCUM SUB-TOTAL BY t-codfam x-margen)    @ x-margen

            WITH FRAME F-REPORTE.
      END.
     

      

      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[10]
            t-costo[10]
            x-margen
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL : " + S-NOMCIA ) @ x-desfam
            (ACCUM TOTAL BY t-codcia t-costo[10]) @ t-costo[10]
            (ACCUM TOTAL BY t-codcia t-venta[10]) @ t-venta[10]
            (ACCUM TOTAL BY t-codcia x-margen)    @ x-margen
            WITH FRAME F-REPORTE.
      END.
     

  END.
  /*  
  HIDE FRAME F-PROCESO.
  */

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

