&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME adminW-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS adminW-Win 
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
DEFINE VAR X-TITU    AS CHAR INIT "ESTADISTICA DE VENTAS".
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
    FIELD t-prove   LIKE Almmmatg.CodPr1
    FIELD t-codmat  LIKE Almdmov.codmat
    FIELD t-desmat  LIKE Almmmatg.DesMat    FORMAT "X(40)"
    FIELD t-desmar  LIKE Almmmatg.DesMar    FORMAT "X(8)"
    FIELD t-undbas  LIKE Almmmatg.UndBas    FORMAT "X(8)"
    FIELD t-codven  LIKE EvtVend.CodVen     FORMAT "X(3)"
    FIELD t-nomven  LIKE Gn-Ven.Nomven 
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
&Scoped-Define ENABLED-OBJECTS RECT-61 RECT-63 RECT-58 BUTTON-5 F-DIVISION ~
C-tipo-2 F-Vendedor BUTTON-6 DesdeF HastaF nCodMon Btn_OK-2 Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-DIVISION C-tipo-2 F-Vendedor DesdeF ~
HastaF nCodMon 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR adminW-Win AS WIDGET-HANDLE NO-UNDO.

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

DEFINE BUTTON Btn_OK-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 6" 
     SIZE 4.43 BY .81.

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 2" 
     SIZE 4.43 BY .81.

DEFINE VARIABLE C-tipo-2 AS CHARACTER FORMAT "X(20)":U INITIAL "Cantidad" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "Cantidad","Venta" 
     DROP-DOWN-LIST
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-DIVISION AS CHARACTER FORMAT "X(5)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-Vendedor AS CHARACTER FORMAT "X(60)":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 36 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dolares", 2
     SIZE 16.72 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 1.88
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.86 BY 2.77.

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56 BY 4.31
     BGCOLOR 3 .

DEFINE RECTANGLE RECT-63
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.86 BY 1.19.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-5 AT ROW 2.35 COL 25.29
     F-DIVISION AT ROW 2.38 COL 12 COLON-ALIGNED
     C-tipo-2 AT ROW 2.62 COL 60 COLON-ALIGNED NO-LABEL
     F-Vendedor AT ROW 3.46 COL 12 COLON-ALIGNED WIDGET-ID 2
     BUTTON-6 AT ROW 3.46 COL 51
     DesdeF AT ROW 4.54 COL 12 COLON-ALIGNED
     HastaF AT ROW 4.54 COL 30 COLON-ALIGNED
     nCodMon AT ROW 4.88 COL 64.72 NO-LABEL
     Btn_OK-2 AT ROW 6.31 COL 46 WIDGET-ID 4
     Btn_OK AT ROW 6.31 COL 60
     Btn_Cancel AT ROW 6.31 COL 74
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1.35 COL 4.43
          FONT 6
     " Tipo de Reporte" VIEW-AS TEXT
          SIZE 14.57 BY .65 AT ROW 1.27 COL 61.14
          FONT 6
     " Moneda" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 4.5 COL 62.72
          FONT 6
     RECT-61 AT ROW 1.54 COL 3
     RECT-46 AT ROW 6.12 COL 3
     RECT-63 AT ROW 4.65 COL 60
     RECT-58 AT ROW 1.54 COL 60.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 89 BY 7.73
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
  CREATE WINDOW adminW-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Ventas Totales"
         HEIGHT             = 7.73
         WIDTH              = 89
         MAX-HEIGHT         = 7.73
         MAX-WIDTH          = 89
         VIRTUAL-HEIGHT     = 7.73
         VIRTUAL-WIDTH      = 89
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
IF NOT adminW-Win:LOAD-ICON("img\climnu3":U) THEN
    MESSAGE "Unable to load icon: img\climnu3"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB adminW-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW adminW-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(adminW-Win)
THEN adminW-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME adminW-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL adminW-Win adminW-Win
ON END-ERROR OF adminW-Win /* Ventas Totales */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL adminW-Win adminW-Win
ON WINDOW-CLOSE OF adminW-Win /* Ventas Totales */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel adminW-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK adminW-Win
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


&Scoped-define SELF-NAME Btn_OK-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK-2 adminW-Win
ON CHOOSE OF Btn_OK-2 IN FRAME F-Main /* Aceptar */
DO:
  RUN Asigna-Variables.
  RUN Valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR". 
  RUN Inhabilita.
  RUN Carga-temporal.
  CASE C-Tipo-2:
      WHEN "Cantidad"  THEN RUN ExcelA.
      WHEN "Venta"     THEN RUN ExcelB.
  END CASE. 
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 adminW-Win
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 adminW-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Button 2 */
DO:
  DEF VAR x-Vendedores AS CHAR.
  x-Vendedores = F-Vendedor:SCREEN-VALUE.
  RUN vta/d-repo08 (INPUT-OUTPUT x-Vendedores).
  F-Vendedor:SCREEN-VALUE = x-Vendedores.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-tipo-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-tipo-2 adminW-Win
ON VALUE-CHANGED OF C-tipo-2 IN FRAME F-Main
DO:
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN C-TIPO-2 .  
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DIVISION
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DIVISION adminW-Win
ON LEAVE OF F-DIVISION IN FRAME F-Main /* Division */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN F-DIVISION.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Vendedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Vendedor adminW-Win
ON LEAVE OF F-Vendedor IN FRAME F-Main /* Vendedor */
DO:
    ASSIGN F-Vendedor.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK adminW-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

/* Include custom  Main Block code for SmartWindows. */

{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects adminW-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available adminW-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables adminW-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  
    ASSIGN F-Vendedor
           F-Division 
           DesdeF 
           HastaF 
           nCodMon
           C-tipo-2 .    
  S-SUBTIT =   "PERIODO : " + STRING(DesdeF,"99/99/9999") + " al " + STRING(HastaF,"99/99/9999").
  X-MONEDA =   "MONEDA  : " + IF NCODMON = 1 THEN "NUEVOS SOLES " ELSE "DOLARES AMERICANOS ".  
  IF DesdeF = ?  THEN DesdeF = 01/01/1900.
  IF HastaF = ?  THEN HastaF = 01/01/3000.
  IF F-DIVISION = "" THEN DO:
    X-CODDIV = "".
    FOR EACH Gn-Divi NO-LOCK WHERE Gn-Divi.Codcia = S-CODCIA:
        X-CODDIV = X-CODDIV + Gn-Divi.Coddiv + "," .
    END.
  END.
  ELSE DO:
   FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                      Gn-Divi.Coddiv = F-DIVISION NO-LOCK NO-ERROR.
   X-CODDIV = Gn-Divi.CodDiv + "," .
  END.  
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-temporal adminW-Win 
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
  IF F-Vendedor = '' THEN DO:
        FOR EACH GN-VEN WHERE Gn-Ven.codcia = s-codcia NO-LOCK:
            IF F-Vendedor = '' 
            THEN F-Vendedor = TRIM(Gn-Ven.CodVen).
            ELSE F-Vendedor = F-Vendedor + ',' + TRIM(Gn-Ven.CodVen).
        END.
  END.
  DO i = 1 TO NUM-ENTRIES(F-Vendedor):
      FOR EACH Gn-Divi NO-LOCK WHERE Gn-Divi.Codcia = S-CODCIA 
                         AND Gn-Divi.CodDiv BEGINS F-DIVISION:
            FOR EACH EvtVend NO-LOCK WHERE EvtVend.CodCia = S-CODCIA
                AND   EvtVend.CodDiv = Gn-Divi.Coddiv
                AND   (EvtVend.Nrofch >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99"))
                AND   EvtVend.Nrofch <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99")) )
                AND (LOOKUP(EvtVend.CodVen,F-Vendedor) > 0 OR F-Vendedor = ""),
                FIRST Gn-Ven NO-LOCK WHERE Gn-Ven.Codcia = EvtVend.CodCia 
                             AND Gn-Ven.CodVen = EvtVend.CodVen:
                FIND FIRST Almmmatg WHERE Almmmatg.codcia = S-CODCIA and 
                                        Almmmatg.codmat = evtvend.codmat 
                                        NO-LOCK NO-ERROR.
               IF NOT AVAILABLE Almmmatg THEN NEXT.
               DISPLAY EvtVend.CodVen + " " + EvtVend.CodMat @ Fi-Mensaje LABEL "Código de Vendedor X Artículo "
                      FORMAT "X(11)" WITH FRAME F-Proceso.
               T-Vtamn   = 0.
               T-Vtame   = 0.
               T-Ctomn   = 0.
               T-Ctome   = 0.
               F-Salida  = 0.
              /*****************Capturando el Mes siguiente *******************/
               IF EvtVend.Codmes < 12 THEN DO:
                    ASSIGN
                    X-CODMES = EvtVend.Codmes + 1
                    X-CODANO = EvtVend.Codano .
               END.
               ELSE DO: 
                    ASSIGN
                    X-CODMES = 01
                    X-CODANO = EvtVend.Codano + 1 .
               END.
              /*********************** Calculo Para Obtener los datos diarios ************/
               DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
                    X-FECHA = DATE(STRING(I,"99") + "/" + STRING(EvtVend.Codmes,"99") + "/" + STRING(EvtVend.Codano,"9999")).         
                    IF X-FECHA >= DesdeF AND X-FECHA <= HastaF THEN DO:
                        FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(EvtVend.Codmes,"99") + "/" + STRING(EvtVend.Codano,"9999")) NO-LOCK NO-ERROR.
                        IF AVAILABLE Gn-tcmb THEN DO: 
                         F-Salida  = F-Salida  + EvtVend.CanxDia[I].
                         T-Vtamn   = T-Vtamn   + EvtVend.Vtaxdiamn[I] + EvtVend.Vtaxdiame[I] * Gn-Tcmb.Venta.
                         T-Vtame   = T-Vtame   + EvtVend.Vtaxdiame[I] + EvtVend.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                         T-Ctomn   = T-Ctomn   + EvtVend.Ctoxdiamn[I] + EvtVend.Ctoxdiame[I] * Gn-Tcmb.Venta.
                         T-Ctome   = T-Ctome   + EvtVend.Ctoxdiame[I] + EvtVend.Ctoxdiamn[I] / Gn-Tcmb.Compra.
                        END.
                    END.
               END.         
              /******************************************************************************/      
                FIND tmp-tempo WHERE t-codcia  = S-CODCIA
                              AND  t-codmat  = EvtVend.codmat
                              AND  T-codven  = evtvend.Codven 
                              NO-ERROR.
                IF NOT AVAILABLE tmp-tempo THEN DO:
                    CREATE tmp-tempo.
                    ASSIGN t-codcia  = S-CODCIA
                           t-Clase   = Almmmatg.Clase
                           t-codfam  = Almmmatg.codfam 
                           t-subfam  = Almmmatg.subfam
                           t-prove   = Almmmatg.CodPr1
                           t-codmat  = EvtVend.codmat
                           t-desmat  = Almmmatg.DesMat
                           t-desmar  = Almmmatg.DesMar
                           t-undbas  = Almmmatg.UndBas
                           T-Codven  = evtvend.Codven 
                           t-nomven = gn-ven.Nomven.
               END.
               ASSIGN T-Canti[10] = T-Canti[10] + F-Salida 
                     T-Venta[10] = T-venta[10] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame ).
              /******************************Secuencia Para Cargar Datos en las Columnas *****************/
               X-ENTRA = FALSE.
               IF NOT X-ENTRA THEN DO:
                 ASSIGN T-Canti[7] = T-Canti[7] + F-Salida 
                        T-Venta[7] = T-venta[7] + ( IF ncodmon = 1 THEN T-Vtamn ELSE T-Vtame ).
                        X-ENTRA = TRUE. 
               END.
            END.
       END.
  END.
HIDE FRAME F-PROCESO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI adminW-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(adminW-Win)
  THEN DELETE WIDGET adminW-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI adminW-Win  _DEFAULT-ENABLE
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
  DISPLAY F-DIVISION C-tipo-2 F-Vendedor DesdeF HastaF nCodMon 
      WITH FRAME F-Main IN WINDOW adminW-Win.
  ENABLE RECT-61 RECT-63 RECT-58 BUTTON-5 F-DIVISION C-tipo-2 F-Vendedor 
         BUTTON-6 DesdeF HastaF nCodMon Btn_OK-2 Btn_OK Btn_Cancel 
      WITH FRAME F-Main IN WINDOW adminW-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW adminW-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExcelA adminW-Win 
PROCEDURE ExcelA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chWorkbook         AS COM-HANDLE.
DEFINE VARIABLE chWorksheet        AS COM-HANDLE.
DEFINE VARIABLE iCount             AS INTEGER INITIAL 4.
DEFINE VARIABLE cColumn            AS CHARACTER.
DEFINE VARIABLE cRange             AS CHARACTER.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Range("A1"):Value = s-nomcia.
chWorkSheet:Range("B1"):Value = x-titu.
chWorkSheet:Range("A2"):Value = "DIVISIONES EVALUADAS : " + X-CODDIV .
chWorkSheet:Range("A3"):Value = "LOS IMPORTES INCLUYEN I.G.V ".

/* set the column names for the Worksheet */
chWorkSheet:Range("A4"):Value = "CODIGO".
chWorkSheet:Range("B4"):Value = "DESCRIPCION".
chWorkSheet:Range("C4"):Value = "MARCA".
chWorkSheet:Range("D4"):Value = "UNIDAD".
chWorkSheet:Range("E4"):Value = "CANTIDAD".

chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Range("A1:E4"):Font:Bold = TRUE.

FOR EACH tmp-tempo  WHERE t-codcia = s-codcia
    BREAK BY t-codcia
        BY t-codven BY t-codfam 
        BY t-subfam BY t-codmat:
        
    DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
          FORMAT "X(11)" WITH FRAME F-Proceso.
    
    IF FIRST-OF(t-codven) THEN DO:
        FIND GN-VEN WHERE GN-VEN.CODCIA = s-codcia 
            AND  GN-VEN.CODVEN = t-codven  NO-LOCK NO-ERROR.
        IF AVAILABLE GN-VEN THEN DO:
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = "VENDEDOR: " + t-codven.
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = gn-ven.NomVen.
        END.  
    END.

    ACCUM  t-canti[10]  (SUB-TOTAL BY t-codven) .
    ACCUM  t-canti[10]  ( TOTAL BY t-codcia) .

    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = t-codmat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = t-DesMat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = t-DesMar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = t-UndBas.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = t-canti[10].
    
    IF LAST-OF(t-codven) THEN DO:
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY t-codven t-canti[10]).
    END.

    IF LAST-OF(t-codcia) THEN DO:
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = "(TOTAL   : )".
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL BY t-codcia t-canti[10]).
    END.
END.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

MESSAGE 'Reporte Terminado' VIEW-AS ALERT-BOX INFORMATION.

HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExcelB adminW-Win 
PROCEDURE ExcelB :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chWorkbook         AS COM-HANDLE.
DEFINE VARIABLE chWorksheet        AS COM-HANDLE.
DEFINE VARIABLE iCount             AS INTEGER INITIAL 4.
DEFINE VARIABLE cColumn            AS CHARACTER.
DEFINE VARIABLE cRange             AS CHARACTER.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A1"):Value = s-nomcia.
chWorkSheet:Range("B1"):Value = x-titu.
chWorkSheet:Range("A2"):Value = "DIVISIONES EVALUADAS : " + X-CODDIV .
chWorkSheet:Range("A3"):Value = "LOS IMPORTES INCLUYEN I.G.V ".

/* set the column names for the Worksheet */
chWorkSheet:Range("A4"):Value = "CODIGO".
chWorkSheet:Range("B4"):Value = "DESCRIPCION".
chWorkSheet:Range("C4"):Value = "MARCA".
chWorkSheet:Range("D4"):Value = "UNIDAD".
chWorkSheet:Range("E4"):Value = "VENTA".

chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Range("A1:E4"):Font:Bold = TRUE.

FOR EACH tmp-tempo 
    BREAK BY t-codcia
        BY t-codven BY t-codfam 
        BY t-subfam BY t-codmat:    

    DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
        FORMAT "X(11)" WITH FRAME F-Proceso.

    IF FIRST-OF(t-codven) THEN DO:
        FIND GN-VEN WHERE GN-VEN.CODCIA = s-codcia 
            AND GN-VEN.CODVEN = t-codven NO-LOCK NO-ERROR.
        IF AVAILABLE GN-VEN THEN DO:
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = "VENDEDOR: " + t-codven.
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = gn-ven.NomVen.
        END.  
    END.

    ACCUM  t-venta[10]  (SUB-TOTAL BY t-codven) .
    ACCUM  t-venta[10]  ( TOTAL BY t-codcia) .

    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = t-codmat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = t-DesMat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = t-DesMar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = t-UndBas.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = t-venta[10] .

    IF LAST-OF(t-codven) THEN DO:
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY t-codven t-venta[10]).
    END.

    IF LAST-OF(t-codcia) THEN DO:
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = "(TOTAL   : )".
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL BY t-codcia t-venta[10]).
    END.
END.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

MESSAGE 'Reporte Terminado' VIEW-AS ALERT-BOX INFORMATION.

HIDE FRAME F-PROCESO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1A adminW-Win 
PROCEDURE Formato1A :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-codmat    AT 1
         t-DesMat    FORMAT "X(40)"
         t-DesMar    FORMAT "X(10)" 
         t-UndBas    FORMAT "X(4)"
         t-canti[10]  FORMAT "->>>>>>>9.99"
        WITH WIDTH 110 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU  AT 20 FORMAT "X(25)" 
         "(" + "Vendedor-Articulo" + "-" + C-TIPO-2 + ")" AT 50 FORMAT "X(29)" SKIP(1)
         S-SUBTIT AT 1  FORMAT "X(50)" 
         "Pagina : " TO 65 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         X-MONEDA    AT 1  FORMAT "X(50)"
         "Fecha  :"  TO 65 FORMAT "X(15)" TODAY TO 77 FORMAT "99/99/9999" SKIP
         "Hora   :"  TO 65 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 75   SKIP
         "DIVISIONES EVALUADAS : " + X-CODDIV  At 1 FORMAT "X(150)" SKIP
        "-------------------------------------------------------------------------------" SKIP
        "T O T A L"  AT  70 SKIP
        " CODIGO  D E S C R I P C I O N                   MARCA     U.M      CANTIDAD   " SKIP
        "-------------------------------------------------------------------------------" SKIP
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .
  FOR EACH tmp-tempo  WHERE t-codcia = s-codcia
                     BREAK BY t-codcia
                           BY t-codven
                           BY t-codfam 
                           BY t-subfam 
                           BY t-codmat:
      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      VIEW STREAM REPORT FRAME F-HEADER.
      IF FIRST-OF(t-codven) THEN DO:
         FIND GN-VEN WHERE GN-VEN.CODCIA = s-codcia 
                      AND  GN-VEN.CODVEN = t-codven 
                      NO-LOCK NO-ERROR.
         IF AVAILABLE GN-VEN THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "VENDEDOR : "  FORMAT "X(12)" AT 1 
                                 t-codven       FORMAT "X(3)"  AT 15
                                 gn-ven.NomVen  FORMAT "X(40)" AT 20 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.
         END.  
      END.
      ACCUM  t-canti[10]  (SUB-TOTAL BY t-codven) .
      ACCUM  t-canti[10]  ( TOTAL BY t-codcia) .
      
      DISPLAY STREAM REPORT 
                t-codmat
                t-DesMat
                t-DesMar
                t-UndBas
                t-canti[10]  FORMAT "->>>>>>>9.99"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.   
      IF LAST-OF(t-codven) THEN DO:
            UNDERLINE STREAM REPORT 
                t-canti[10] 
                WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
                (ACCUM SUB-TOTAL BY t-codven t-canti[10]) @ t-canti[10] 
                WITH FRAME F-REPORTE.
      END.
      IF LAST-OF(t-codcia) THEN DO:
            UNDERLINE STREAM REPORT 
                t-canti[10] 
                WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT 
                ("TOTAL   : ") @ t-desmat
                (ACCUM TOTAL BY t-codcia t-canti[10]) @ t-canti[10]
                WITH FRAME F-REPORTE.
      END.
  END.
  HIDE FRAME F-PROCESO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1B adminW-Win 
PROCEDURE Formato1B :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE
         t-codmat    AT 1
         t-DesMat    FORMAT "X(40)"
         t-DesMar    FORMAT "X(10)" 
         t-UndBas    FORMAT "X(4)"
         t-venta[10]  FORMAT "->>>>>>>9.99"
        WITH WIDTH 110 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP(1)
         X-TITU  AT 20 FORMAT "X(25)" 
         "(" + "Vendedor-Articulo" + "-" + C-TIPO-2 + ")" AT 50 FORMAT "X(25)" SKIP(1)
         S-SUBTIT    AT 1  FORMAT "X(50)" 
         "Pagina : " TO 65 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         X-MONEDA    AT 1  FORMAT "X(50)"
         "Fecha  :"  TO 65 FORMAT "X(15)" TODAY TO 77 FORMAT "99/99/9999" SKIP
         "Hora   :"  TO 65 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") TO 75   SKIP
         "DIVISIONES EVALUADAS : " + X-CODDIV   At 1 FORMAT "X(150)" SKIP
         "LOS IMPORTES INCLUYEN I.G.V "   At 1 FORMAT "X(150)" SKIP
        "-------------------------------------------------------------------------------" SKIP
        "T O T A L"  AT  70 SKIP
        " CODIGO  D E S C R I P C I O N                   MARCA     U.M         VENTA   " SKIP
        "-------------------------------------------------------------------------------" SKIP
         WITH PAGE-TOP WIDTH 205 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .
  FOR EACH tmp-tempo  /*WHERE t-venta[10] > 0 */
                     BREAK BY t-codcia
                           BY t-codven
                           BY t-codfam 
                           BY t-subfam 
                           BY t-codmat:    
      DISPLAY t-CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      VIEW STREAM REPORT FRAME F-HEADER.
      IF FIRST-OF(t-codven) THEN DO:
         FIND GN-VEN WHERE GN-VEN.CODCIA = s-codcia 
                      AND GN-VEN.CODVEN = t-codven 
                      NO-LOCK NO-ERROR.
         IF AVAILABLE GN-VEN THEN DO:
             PUT STREAM REPORT  " " SKIP.
             PUT STREAM REPORT   "VENDEDOR : "  FORMAT "X(12)" AT 1 
                                 t-codven       FORMAT "X(3)"  AT 15
                                 gn-ven.NomVen  FORMAT "X(40)" AT 20 SKIP.
             PUT STREAM REPORT   '------------------------------------------' FORMAT "X(50)" SKIP.
         END.  
      END.
      ACCUM  t-venta[10]  (SUB-TOTAL BY t-codven) .
      ACCUM  t-venta[10]  ( TOTAL BY t-codcia) .
      DISPLAY STREAM REPORT 
                t-codmat
                t-DesMat
                t-DesMar
                t-UndBas
                t-venta[10]  FORMAT "->>>>>>>9.99"      
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.
      IF LAST-OF(t-codven) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            (ACCUM SUB-TOTAL BY t-codven t-venta[10]) @ t-venta[10] 
            WITH FRAME F-REPORTE.
      END.
      IF LAST-OF(t-codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            t-venta[10]
        WITH FRAME F-REPORTE.
        DISPLAY STREAM REPORT 
            ("TOTAL   : ") @ t-desmat
            (ACCUM TOTAL BY t-codcia t-venta[10]) @ t-venta[10]
            WITH FRAME F-REPORTE.
      END.
  END.
  HIDE FRAME F-PROCESO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Habilita adminW-Win 
PROCEDURE Habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    ENABLE ALL.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime adminW-Win 
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
        CASE C-Tipo-2:
            WHEN "Cantidad"  THEN RUN Formato1A.
            WHEN "Venta"     THEN RUN Formato1B.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inhabilita adminW-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inicializa-Variables adminW-Win 
PROCEDURE Inicializa-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    ASSIGN F-Vendedor
         F-Division 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit adminW-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize adminW-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros adminW-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros adminW-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records adminW-Win  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed adminW-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida adminW-Win 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
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
IF F-VENDEDOR = "" THEN DO:
   MESSAGE "Ingrese un codigo de vendedor" VIEW-AS ALERT-BOX.
   RETURN "ADM-ERROR".
   APPLY "ENTRY" TO F-VENDEDOR.
   RETURN NO-APPLY. 
END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

