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
DEFINE SHARED VAR pv-CODCIA  AS INTEGER.
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
DEFINE VAR X-TOTAL  AS CHAR.
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
DEFINE VAR X-ENTRA AS LOGICAL INIT FALSE.


DEFINE TEMP-TABLE tmp-tempo 
    FIELD t-codcia  LIKE Almdmov.Codcia 
    FIELD t-coddiv  LIKE EvtArti.Coddiv 
    FIELD t-clase   LIKE Almmmatg.clase
    FIELD t-codfam  LIKE Almmmatg.codfam 
    FIELD t-subfam  LIKE Almmmatg.subfam
    FIELD t-prove   LIKE Almmmatg.CodPr1
    FIELD t-codmat  LIKE Almdmov.codmat
    FIELD t-desmat  LIKE Almmmatg.DesMat    FORMAT "X(40)"
    FIELD t-desmar  LIKE Almmmatg.DesMar    FORMAT "X(8)"
    FIELD t-undbas  LIKE Almmmatg.UndBas    FORMAT "X(8)"
    FIELD t-stkact  LIKE Almmmate.StkAct    FORMAT "->>>>>,>>9.99"
    FIELD t-ventamn AS DEC            FORMAT "->>>>>>>9.99" 
    FIELD t-ventame AS DEC            FORMAT "->>>>>>>9.99"
    FIELD t-costome AS DEC            FORMAT "->>>>>>>9.99"
    FIELD t-costomn AS DEC            FORMAT "->>>>>>>9.99"
    FIELD t-venta   AS DEC  EXTENT 10 FORMAT "->>>>>>>>9.99"  
    FIELD t-costo   AS DEC  EXTENT 10 FORMAT "->>>>>>>>9.99"  
    FIELD t-canti   AS DEC  EXTENT 10 FORMAT "->>>>>>>>9.99" 
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
&Scoped-Define ENABLED-OBJECTS RECT-61 F-DIVISION BUTTON-5 F-CodFam ~
BUTTON-1 F-SubFam BUTTON-2 DesdeF HastaF nCodMon Btn_OK Btn_Excel ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-DIVISION F-CodFam F-SubFam DesdeF HastaF ~
nCodMon txt-msj 

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

DEFINE BUTTON Btn_Excel 
     IMAGE-UP FILE "img\excel":U
     LABEL "Excel" 
     SIZE 11 BY 1.5 TOOLTIP "Salida a Excel".

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 1" 
     SIZE 4.43 BY .81.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 2" 
     SIZE 4.43 BY .81.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 6" 
     SIZE 4.43 BY .81.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-DIVISION AS CHARACTER FORMAT "X(60)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE F-SubFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Sub-Familia" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 62.14 BY .81
     FONT 1 NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dolares", 2
     SIZE 16.72 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY 1.85
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY 8.35
     BGCOLOR 3 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-DIVISION AT ROW 2.62 COL 13 COLON-ALIGNED
     BUTTON-5 AT ROW 2.62 COL 59
     F-CodFam AT ROW 3.69 COL 13 COLON-ALIGNED
     BUTTON-1 AT ROW 3.69 COL 27
     F-SubFam AT ROW 4.77 COL 13 COLON-ALIGNED
     BUTTON-2 AT ROW 4.77 COL 27
     DesdeF AT ROW 5.85 COL 13 COLON-ALIGNED
     HastaF AT ROW 5.85 COL 32 COLON-ALIGNED
     nCodMon AT ROW 7.19 COL 15 NO-LABEL
     txt-msj AT ROW 8.54 COL 2.86 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     Btn_OK AT ROW 10.04 COL 32
     Btn_Excel AT ROW 10.04 COL 44 WIDGET-ID 2
     Btn_Cancel AT ROW 10.04 COL 56
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1.15 COL 4.43
          FONT 6
     " Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 7.19 COL 8
     RECT-61 AT ROW 1.46 COL 3
     RECT-46 AT ROW 9.88 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69 BY 11.12
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
         HEIGHT             = 11.12
         WIDTH              = 69
         MAX-HEIGHT         = 11.12
         MAX-WIDTH          = 69
         VIRTUAL-HEIGHT     = 11.12
         VIRTUAL-WIDTH      = 69
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


&Scoped-define SELF-NAME Btn_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Excel W-Win
ON CHOOSE OF Btn_Excel IN FRAME F-Main /* Excel */
DO:                            
    RUN Asigna-Variables.
    RUN Inhabilita.
    RUN Excel. 
    RUN Habilita.
    RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  RUN Asigna-Variables.
  RUN Valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN NO-APPLY. 
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


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 6 */
DO:
    DEF VAR x-Divisiones AS CHAR.
    x-Divisiones = F-Division:SCREEN-VALUE.
    RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
    F-Division:SCREEN-VALUE = x-Divisiones.

  /*DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "".
    output-var-2 = "".
    RUN lkup\C-Divis02.r("Divisiones").
    IF output-var-2 <> ? THEN DO:
        F-DIVISION = output-var-2.
        DISPLAY F-DIVISION.
        APPLY "ENTRY" TO F-DIVISION .
        RETURN NO-APPLY.

    END.
  END.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodFam W-Win
ON LEAVE OF F-CodFam IN FRAME F-Main /* Familia */
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
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-SubFam W-Win
ON LEAVE OF F-SubFam IN FRAME F-Main /* Sub-Familia */
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
         F-CodFam 
         F-SubFam 
         DesdeF 
         HastaF 
         nCodMon.
  X-FAMILIA     = "FAMILIA               : "  + F-CODFAM.
  X-SUBFAMILIA  = "SUBFAMILIA            : "  + F-SUBFAM .
  S-SUBTIT      = "PERIODO               : "  + STRING(DesdeF,"99/99/9999") + " al " + STRING(HastaF,"99/99/9999").
  X-MONEDA      = "MONEDA                : "  + IF NCODMON = 1 THEN "NUEVOS SOLES " ELSE "DOLARES AMERICANOS ".  
  IF DesdeF = ?  THEN DesdeF = 01/01/1900.
  IF HastaF = ?  THEN HastaF = 01/01/3000.
  X-TOTAL       = "TOTAL:".

  IF F-Division = '' THEN DO:
   FOR EACH GN-DIVI WHERE Gn-Divi.codcia = s-codcia NO-LOCK:
       IF F-Division = '' THEN F-Division = TRIM(Gn-Divi.CodDiv).
       ELSE F-Division = F-Division + ',' + TRIM(Gn-Divi.CodDiv).
   END.
  END.

END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Data W-Win 
PROCEDURE Carga-Data :
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


IF F-Division = '' THEN DO:
   FOR EACH GN-DIVI WHERE Gn-Divi.codcia = s-codcia NO-LOCK:
       IF F-Division = '' THEN F-Division = TRIM(Gn-Divi.CodDiv).
       ELSE F-Division = F-Division + ',' + TRIM(Gn-Divi.CodDiv).
   END.
END.

FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia
    AND LOOKUP(gn-divi.coddiv,f-division) > 0 NO-LOCK:

    FOR EACH Evtarti NO-LOCK USE-INDEX Llave02
        WHERE Evtarti.CodCia = gn-divi.codcia
        AND Evtarti.CodDiv = gn-divi.coddiv
        AND (Evtarti.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99")) 
        AND Evtarti.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) ),
        FIRST Almmmatg WHERE Almmmatg.codcia = evtarti.codcia
        AND Almmmatg.codmat = EvtArti.codmat NO-LOCK:
        
        IF NOT (Almmmatg.codfam BEGINS F-CodFam AND Almmmatg.subfam BEGINS F-Subfam ) THEN NEXT.
        /*
        DISPLAY Evtarti.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
                FORMAT "X(11)" WITH FRAME F-Proceso.
        */
        DISPLAY "Cargando División: " + Evtarti.CodDiv + " - Articulo: " + EvtArti.CodMat @ txt-msj
            WITH FRAME {&FRAME-NAME}.


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
            IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
                FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")) 
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN DO: 
                    F-Salida  = F-Salida  + Evtarti.CanxDia[I].
                    T-Vtamn   = T-Vtamn   + Evtarti.Vtaxdiamn[I] + Evtarti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                    T-Vtame   = T-Vtame   + Evtarti.Vtaxdiame[I] + Evtarti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                    T-Ctomn   = T-Ctomn   + Evtarti.Ctoxdiamn[I] + Evtarti.Ctoxdiame[I] * Gn-Tcmb.Venta.
                    T-Ctome   = T-Ctome   + Evtarti.Ctoxdiame[I] + Evtarti.Ctoxdiamn[I] / Gn-Tcmb.Compra.
                END.
            END.
        END.         
        /******************************************************************************/      

        FIND tmp-tempo WHERE t-codcia  = S-CODCIA 
            AND  t-codmat  = Evtarti.codmat NO-ERROR.
        IF NOT AVAILABLE tmp-tempo THEN DO:
          CREATE tmp-tempo.
          ASSIGN t-codcia  = S-CODCIA
                 t-coddiv  = Evtarti.coddiv
                 t-Clase   = Almmmatg.Clase
                 t-codfam  = Almmmatg.codfam 
                 t-subfam  = Almmmatg.subfam
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
        IF NOT X-ENTRA THEN DO:
            ASSIGN T-Canti[7] = T-Canti[7] + F-Salida 
                  T-Venta[7] = T-venta[7] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                  T-Costo[7] = T-Costo[7] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
                  X-ENTRA = TRUE. 
        END.
    END. /*for each evtarti...*/
END. /*for each gn-divi...*/

/*

DO i = 1 TO NUM-ENTRIES(F-Division):  
    FOR EACH Evtarti NO-LOCK WHERE Evtarti.CodCia = S-CODCIA 
        AND (Evtarti.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99")) 
          AND Evtarti.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) ) 
        AND LOOKUP(Evtarti.CodDiv,F-Division OR F-Division = ""), 
        FIRST Gn-Divi NO-LOCK WHERE Gn-Divi.Codcia = Evtarti.CodCia 
                 AND Gn-Divi.CodDiv = Evtarti.CodDiv :

                 
        FIND FIRST Almmmatg WHERE Almmmatg.codcia = S-CODCIA and 
                   Almmmatg.codmat = EvtArti.codmat
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg THEN NEXT.
        IF NOT (Almmmatg.codfam BEGINS F-CodFam AND Almmmatg.subfam BEGINS F-Subfam ) THEN NEXT.
        DISPLAY Evtarti.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
                FORMAT "X(11)" WITH FRAME F-Proceso.
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
             IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
                 FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")) 
                      NO-LOCK NO-ERROR.
                 IF AVAILABLE Gn-tcmb THEN DO: 
                    F-Salida  = F-Salida  + Evtarti.CanxDia[I].
                    T-Vtamn   = T-Vtamn   + Evtarti.Vtaxdiamn[I] + Evtarti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                    T-Vtame   = T-Vtame   + Evtarti.Vtaxdiame[I] + Evtarti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                    T-Ctomn   = T-Ctomn   + Evtarti.Ctoxdiamn[I] + Evtarti.Ctoxdiame[I] * Gn-Tcmb.Venta.
                    T-Ctome   = T-Ctome   + Evtarti.Ctoxdiame[I] + Evtarti.Ctoxdiamn[I] / Gn-Tcmb.Compra.
                 END.
             END.
        END.         
  /******************************************************************************/      
        FIND tmp-tempo WHERE t-codcia  = S-CODCIA AND  
                 t-codmat  = Evtarti.codmat NO-ERROR.
        IF NOT AVAILABLE tmp-tempo THEN DO:
          CREATE tmp-tempo.
          ASSIGN t-codcia  = S-CODCIA
                 t-coddiv  = Evtarti.coddiv
                 t-Clase   = Almmmatg.Clase
                 t-codfam  = Almmmatg.codfam 
                 t-subfam  = Almmmatg.subfam
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
        IF NOT X-ENTRA THEN DO:
            ASSIGN T-Canti[7] = T-Canti[7] + F-Salida 
                  T-Venta[7] = T-venta[7] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                  T-Costo[7] = T-Costo[7] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
                  X-ENTRA = TRUE. 
        END.
    END.
    */
/*
END.
*/
/*
END.
*/


HIDE FRAME F-PROCESO.

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

/*******Inicializa la Tabla Temporal ******/
FOR EACH tmp-tempo :
  DELETE tmp-tempo.
END.
/********************************/


IF F-Division = '' THEN DO:
   FOR EACH GN-DIVI WHERE Gn-Divi.codcia = s-codcia NO-LOCK:
       IF F-Division = '' THEN F-Division = TRIM(Gn-Divi.CodDiv).
       ELSE F-Division = F-Division + ',' + TRIM(Gn-Divi.CodDiv).
   END.
END.


DO i = 1 TO NUM-ENTRIES(F-Division):  
    FOR EACH Evtarti NO-LOCK WHERE Evtarti.CodCia = S-CODCIA 
        AND (Evtarti.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99")) 
          AND Evtarti.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) ) 
        AND (LOOKUP(Evtarti.CodDiv,F-Division) > 0) OR (F-Division = "") , 
        FIRST Gn-Divi NO-LOCK WHERE Gn-Divi.Codcia = Evtarti.CodCia 
                 AND Gn-Divi.CodDiv = Evtarti.CodDiv :
                 
        FIND FIRST Almmmatg WHERE Almmmatg.codcia = S-CODCIA and 
                   Almmmatg.codmat = EvtArti.codmat
                   NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg THEN NEXT.
        IF NOT (Almmmatg.codfam BEGINS F-CodFam AND Almmmatg.subfam BEGINS F-Subfam ) THEN NEXT.
        DISPLAY Evtarti.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
                FORMAT "X(11)" WITH FRAME F-Proceso.
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
             IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
                 FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(Evtarti.Codmes,"99") + "/" + STRING(Evtarti.Codano,"9999")) 
                      NO-LOCK NO-ERROR.
                 IF AVAILABLE Gn-tcmb THEN DO: 
                    F-Salida  = F-Salida  + Evtarti.CanxDia[I].
                    T-Vtamn   = T-Vtamn   + Evtarti.Vtaxdiamn[I] + Evtarti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                    T-Vtame   = T-Vtame   + Evtarti.Vtaxdiame[I] + Evtarti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                    T-Ctomn   = T-Ctomn   + Evtarti.Ctoxdiamn[I] + Evtarti.Ctoxdiame[I] * Gn-Tcmb.Venta.
                    T-Ctome   = T-Ctome   + Evtarti.Ctoxdiame[I] + Evtarti.Ctoxdiamn[I] / Gn-Tcmb.Compra.
                 END.
             END.
        END.         
  /******************************************************************************/      
        FIND tmp-tempo WHERE t-codcia  = S-CODCIA AND  
                 t-codmat  = Evtarti.codmat NO-ERROR.
        IF NOT AVAILABLE tmp-tempo THEN DO:
          CREATE tmp-tempo.
          ASSIGN t-codcia  = S-CODCIA
                 t-coddiv  = Evtarti.coddiv
                 t-Clase   = Almmmatg.Clase
                 t-codfam  = Almmmatg.codfam 
                 t-subfam  = Almmmatg.subfam
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
        IF NOT X-ENTRA THEN DO:
            ASSIGN T-Canti[7] = T-Canti[7] + F-Salida 
                  T-Venta[7] = T-venta[7] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame )
                  T-Costo[7] = T-Costo[7] + ( IF ncodmon = 1 THEN T-Ctomn ELSE T-Ctome ).
                  X-ENTRA = TRUE. 
        END.
    END.
END.
/*
END.
*/
HIDE FRAME F-PROCESO.

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
  DISPLAY F-DIVISION F-CodFam F-SubFam DesdeF HastaF nCodMon txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-61 F-DIVISION BUTTON-5 F-CodFam BUTTON-1 F-SubFam BUTTON-2 DesdeF 
         HastaF nCodMon Btn_OK Btn_Excel Btn_Cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 5.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:COLUMNS("A"):ColumnWidth = 8.
chWorkSheet:COLUMNS("B"):ColumnWidth = 45.
chWorkSheet:COLUMNS("C"):ColumnWidth = 15.
chWorkSheet:COLUMNS("D"):ColumnWidth = 7.
chWorkSheet:COLUMNS("E"):ColumnWidth = 7.
chWorkSheet:COLUMNS("F"):ColumnWidth = 6.
chWorkSheet:COLUMNS("G"):ColumnWidth = 13.
chWorkSheet:COLUMNS("H"):ColumnWidth = 13.
chWorkSheet:COLUMNS("I"):ColumnWidth = 13.

chWorkSheet:Range("A1: L5"):FONT:Bold = TRUE.
chWorkSheet:Range("A1"):VALUE = "ESTADISTICAS DE VENTAS X DIVISION CON DETALLE DE PRODUCTO ". 
chWorkSheet:Range("A2"):VALUE = "PERIODO                        : " + STRING(DesdeF,"99/99/9999") + 
" AL " + STRING(HastaF,"99/99/9999"). 
chWorkSheet:Range("A3"):VALUE = "DIVISIONES EVALUADAS: " + F-DIVISION.
chWorkSheet:Range("A4"):VALUE = "MONEDA                         : " + IF NCODMON = 1 THEN "NUEVOS SOLES " ELSE "DOLARES AMERICANOS ".
chWorkSheet:Range("A5"):VALUE = "Código".
chWorkSheet:Range("B5"):VALUE = "Descripción".
chWorkSheet:Range("C5"):VALUE = "Marca".
chWorkSheet:Range("D4"):VALUE = "Código".
chWorkSheet:Range("D5"):VALUE = "Familia".
chWorkSheet:Range("E4"):VALUE = "Sub".
chWorkSheet:Range("E5"):VALUE = "Familia".
chWorkSheet:Range("F5"):VALUE = "Unidad".
chWorkSheet:Range("G5"):VALUE = "Cantidad".
chWorkSheet:Range("H5"):VALUE = "Ventas".
chWorkSheet:Range("I5"):VALUE = "Costo".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:COLUMNS("D"):NumberFormat = "@".
chWorkSheet:COLUMNS("E"):NumberFormat = "@".
/*
chWorkSheet:COLUMNS("G"):NumberFormat = "@".
chWorkSheet:COLUMNS("H"):NumberFormat = "@".
chWorkSheet:COLUMNS("I"):NumberFormat = "@".
*/

chWorkSheet = chExcelApplication:Sheets:Item(1).

FOR EACH   tmp-tempo:
    DELETE tmp-tempo.
END.

RUN Carga-Data.

loopREP:
FOR EACH tmp-tempo  
    BREAK BY t-codcia
    BY t-codfam 
    BY t-subfam 
    BY t-codmat:

    t-column = t-column + 1.                                                                                                                               
    cColumn = STRING(t-Column).                                                                                        
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-tempo.t-codmat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-tempo.t-desmat.
    cRange = "C" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = tmp-tempo.t-desmar.
    cRange = "D" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = tmp-tempo.t-codfam.
    cRange = "E" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = tmp-tempo.t-subfam.
    cRange = "F" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = tmp-tempo.t-undbas.
    cRange = "G" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = STRING (tmp-tempo.T-Canti[10], "->>>>>>>>9.99") . 
    cRange = "H" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = STRING (tmp-tempo.T-Venta[10], "->>>>>>>>9.99") . 
    cRange = "I" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = STRING (tmp-tempo.T-Costo[10], "->>>>>>>>9.99") . 

    DISPLAY "Código de Articulo: " + tmp-tempo.t-codmat @ txt-msj
        WITH FRAME {&FRAME-NAME}.    
    
END.

DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.    


/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.
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
  DEFINE FRAME F-REPORTE
         t-codmat  AT 1  FORMAT "X(06)"
         t-DesMat    FORMAT "X(40)"
         t-DesMar    FORMAT "X(12)"
         t-CodFam    FORMAT "X(5)"
         t-SubFam    FORMAT "X(5)"
         t-UndBas    FORMAT "X(6)"
         t-canti[10]  FORMAT "->>>>>>>>9.99"
         t-venta[10]  FORMAT "->>>>>>>>9.99"
         t-costo[10]  FORMAT "->>>>>>>>9.99"
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU  AT 40 FORMAT "X(55)" 
         "(" + "Artículo" + "-" + "Familia-SubFamilia" + ")" AT 100 FORMAT "X(35)" SKIP(1)
         S-SUBTIT  AT 1  FORMAT "X(60)" 
         "Pagina  : " TO 109 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         X-FAMILIA  AT 1  FORMAT "X(60)" 
         "Fecha  :" TO 108 FORMAT "X(15)" TODAY TO 119 FORMAT "99/99/9999" SKIP
         X-SUBFAMILIA AT 1  FORMAT "X(60)" 
         "Hora   :" TO 108 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 117   SKIP
         X-MONEDA AT 1  FORMAT "X(60)" SKIP
         "DIVISIONES EVALUADAS  : " + F-DIVISION  At 1 FORMAT "X(150)" SKIP
        "--------------------------------------------------------------------------------------------------------------------------------"      SKIP
        "SUB"  AT  68 SKIP
        "CODIGO D E S C R I P C I O N                     MARCA      FAM   FAM   U.M         CANTIDAD        VENTAS         COSTO       " AT 1 SKIP
        "--------------------------------------------------------------------------------------------------------------------------------"      SKIP
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .
  FOR EACH tmp-tempo WHERE t-codcia = s-codcia  
           BREAK BY t-codcia
                 BY t-codfam 
                 BY t-subfam 
                 BY t-codmat:
      /*
      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      */
      DISPLAY "Código de Articulo: " + t-codmat @ txt-msj WITH FRAME {&FRAME-NAME}.

      VIEW STREAM REPORT FRAME F-HEADER.
      ACCUM  t-canti[10]  ( TOTAL BY t-codcia) .
      ACCUM  t-venta[10]  ( TOTAL BY t-codcia) .
      ACCUM  t-costo[10]  ( TOTAL BY t-codcia) .
      DOWN STREAM REPORT WITH FRAME F-REPORTE.
      
           DISPLAY STREAM REPORT 
                t-codmat
                t-DesMat
                t-DesMar
                t-CodFam    
                t-SubFam    
                t-UndBas
                t-canti[10] FORMAT "->>>>>>>>9.99"
                t-venta[10] FORMAT "->>>>>>>>9.99"
                t-costo[10] FORMAT "->>>>>>>>9.99"
               WITH FRAME F-REPORTE.
      
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-canti[10] 
            t-venta[10] 
            t-costo[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            X-TOTAL @ t-UndBas
            (ACCUM TOTAL BY t-codcia t-canti[10]) @ t-canti[10]
            (ACCUM TOTAL BY t-codcia t-venta[10]) @ t-venta[10]
            (ACCUM TOTAL BY t-codcia t-costo[10]) @ t-costo[10]
            WITH FRAME F-REPORTE.
      END.
  END.

  /*HIDE FRAME F-PROCESO.*/
  DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.

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
        ENABLE ALL EXCEPT txt-msj.
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

    RUN Carga-Data.
    
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
        DISABLE ALL .
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
             F-CodFam 
             F-SubFam 
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

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

