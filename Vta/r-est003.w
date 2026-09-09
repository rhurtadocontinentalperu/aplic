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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-task-no AS INT NO-UNDO.

/* Local Variable Definitions ---                                       */
DEF TEMP-TABLE DETALLE LIKE Almmmatg
    FIELD DesFam LIKE Almtfami.desfam
    FIELD CodCli LIKE Gn-clie.codcli
    FIELD NomCli LIKE Gn-clie.nomcli
    FIELD Cantidad AS DEC
    FIELD Venta    AS DEC
    INDEX Llave01 AS PRIMARY CodCia CodCli CodMat.
    
DEFINE TEMP-TABLE tt-cliente
    FIELDS tt-codcli LIKE gn-clie.codcli
    FIELDS tt-nomcli LIKE gn-clie.nomcli
    INDEX idx01 IS PRIMARY tt-codcli.

DEF VAR cl-codcia AS INT NO-UNDO.
FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.

DEF VAR RB-REPORT-LIBRARY AS CHAR.  /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.     /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR. /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.  /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     /* Otros parametros */

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEFINE VARIABLE FI-MENSAJE AS CHARACTER FORMAT "X(40)" NO-UNDO.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
        SKIP
    Fi-Mensaje NO-LABEL FONT 6
    SKIP     
    WITH CENTERED OVERLAY KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

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
&Scoped-Define ENABLED-OBJECTS x-CodCli BUTTON-4 x-FchDoc-1 x-FchDoc-2 ~
x-CodMon FILL-IN-file BUTTON-5 BUTTON-1 BUTTON-2 BUTTON-excel 
&Scoped-Define DISPLAYED-OBJECTS x-CodCli x-NomCli F-Division x-FchDoc-1 ~
x-FchDoc-2 x-CodMon FILL-IN-file txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\print1":U
     LABEL "Button 1" 
     SIZE 7 BY 1.73 TOOLTIP "Imprimir".

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\exit":U
     LABEL "Button 2" 
     SIZE 7 BY 1.73 TOOLTIP "Salir".

DEFINE BUTTON BUTTON-4 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE BUTTON BUTTON-5 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE BUTTON BUTTON-excel 
     IMAGE-UP FILE "img\excel":U
     LABEL "Excel" 
     SIZE 7 BY 1.73 TOOLTIP "Salida a Excel".

DEFINE VARIABLE F-Division AS CHARACTER FORMAT "X(60)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-file AS CHARACTER FORMAT "X(256)":U 
     LABEL "Archivo de Carga" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U INITIAL "Cargando Informacion....." 
     VIEW-AS FILL-IN 
     SIZE 34.29 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-CodCli AS CHARACTER FORMAT "x(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodMon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2
     SIZE 18 BY .62 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodCli AT ROW 1.58 COL 14 COLON-ALIGNED
     x-NomCli AT ROW 1.58 COL 27 COLON-ALIGNED NO-LABEL
     F-Division AT ROW 2.54 COL 14 COLON-ALIGNED
     BUTTON-4 AT ROW 2.54 COL 60
     x-FchDoc-1 AT ROW 3.5 COL 14 COLON-ALIGNED
     x-FchDoc-2 AT ROW 4.46 COL 14 COLON-ALIGNED
     x-CodMon AT ROW 5.58 COL 16 NO-LABEL
     FILL-IN-file AT ROW 7.19 COL 14 COLON-ALIGNED WIDGET-ID 4
     BUTTON-5 AT ROW 7.19 COL 60 WIDGET-ID 6
     BUTTON-1 AT ROW 8.54 COL 46
     BUTTON-2 AT ROW 8.54 COL 53
     BUTTON-excel AT ROW 8.54 COL 60 WIDGET-ID 2
     txt-msj AT ROW 8.81 COL 11 NO-LABEL WIDGET-ID 12
     "Obs:" VIEW-AS TEXT
          SIZE 4 BY .5 AT ROW 6.38 COL 12 WIDGET-ID 10
     " Para salida a excel, ingrese un txt o csv con los códigos de los clientes." VIEW-AS TEXT
          SIZE 49 BY .5 AT ROW 6.38 COL 16 WIDGET-ID 8
          BGCOLOR 1 FGCOLOR 15 
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 5.58 COL 9
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.86 BY 9.88
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
         TITLE              = "VENTAS POR MARCA Y CLIENTE"
         HEIGHT             = 9.88
         WIDTH              = 71.86
         MAX-HEIGHT         = 9.88
         MAX-WIDTH          = 71.86
         VIRTUAL-HEIGHT     = 9.88
         VIRTUAL-WIDTH      = 71.86
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
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
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN F-Division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       txt-msj:HIDDEN IN FRAME F-Main           = TRUE
       txt-msj:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN x-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* VENTAS POR MARCA Y CLIENTE */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* VENTAS POR MARCA Y CLIENTE */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:

    ASSIGN F-Division x-CodCli x-CodMon x-FchDoc-1 x-FchDoc-2 x-NomCli.
    RUN Imprimir.
    txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* ... */
DO:
  DEF VAR x-Divisiones AS CHAR.
  x-Divisiones = f-Division:SCREEN-VALUE.
  RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
  f-Division:SCREEN-VALUE = x-Divisiones.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* ... */
DO:

    DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.

    SYSTEM-DIALOG GET-FILE FILL-IN-file
        FILTERS
            "Archivos Excel (*.csv)" "*.csv",
            "Archivos Texto (*.txt)" "*.txt",
            "Todos (*.*)" "*.*"
        TITLE
            "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.

    IF OKpressed = TRUE THEN
        FILL-IN-file:SCREEN-VALUE = FILL-IN-file.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-excel W-Win
ON CHOOSE OF BUTTON-excel IN FRAME F-Main /* Excel */
DO:
    ASSIGN F-Division x-CodCli x-CodMon x-FchDoc-1 x-FchDoc-2 x-NomCli FILL-IN-file.
    MESSAGE  FILL-IN-file.
    IF SEARCH(FILL-IN-file) = ? THEN DO:
        MESSAGE "Archivo " FILL-IN-file "NO existe"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Division W-Win
ON LEAVE OF F-Division IN FRAME F-Main /* Division */
DO:
    ASSIGN F-Division.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodCli W-Win
ON LEAVE OF x-CodCli IN FRAME F-Main /* Cliente */
DO:
  FIND Gn-clie WHERE Gn-clie.codcia = cl-codcia
    AND Gn-clie.codcli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-clie THEN x-NomCli:SCREEN-VALUE = Gn-clie.nomcli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
/*{src/adm/template/cntnrwin.i}*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal W-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH w-report WHERE w-report.task-no = s-task-no  AND w-report.llave-c = s-user-id:
    DELETE w-report.
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
  DEF VAR i AS INT NO-UNDO.
  DEF VAR j AS INT NO-UNDO.
  DEF VAR X-CODDIA AS INTEGER INIT 1.
  DEF VAR X-CODANO AS INTEGER .
  DEF VAR X-CODMES AS INTEGER .
  DEF VAR X-FECHA  AS DATE.
  DEF VAR x-NroFch-1 AS INT NO-UNDO.
  DEF VAR x-NroFch-2 AS INT NO-UNDO.
    
  /*  VIEW FRAME F-Proceso.*/

  FOR EACH Detalle:
    DELETE Detalle.
  END.

  IF f-Division = '' THEN DO:
    FOR EACH GN-DIVI WHERE gn-divi.codcia = s-codcia NO-LOCK:
        IF f-Division = '' THEN f-Division = TRIM(gn-divi.coddiv).
        ELSE f-Division = f-Division + ',' + TRIM(gn-divi.coddiv).
    END.
  END.

  x-NroFch-1 = YEAR(x-FchDoc-1) * 100 + MONTH(x-FchDoc-1).
  x-NroFch-2 = YEAR(x-FchDoc-2) * 100 + MONTH(x-FchDoc-2).

  DO i = 1 TO NUM-ENTRIES(f-Division):
    FOR EACH EvtClArti USE-INDEX Llave04 NO-LOCK WHERE Evtclarti.codcia = s-codcia
                AND Evtclarti.coddiv = ENTRY(i, f-Division)
                AND Evtclarti.codcli BEGINS x-CodCli
               AND Evtclarti.nrofch >= x-NroFch-1
               AND Evtclarti.nrofch <= x-NroFch-2,
               FIRST Almmmatg OF Evtclarti NO-LOCK,
               FIRST Almtfami WHERE Almtfami.codcia = s-codcia
                AND Almtfami.codfam = Almmmatg.codfam,
               Gn-clie NO-LOCK WHERE Gn-clie.codcia = cl-codcia
                   AND Gn-clie.codcli = Evtclarti.codcli:
        /*
        DISPLAY
            Evtclarti.coddiv + " " + Evtclarti.codmat @ Fi-Mensaje
            LABEL "  Cargando" FORMAT "X(13)"
            WITH FRAME F-Proceso.
        */    
        FIND DETALLE WHERE DETALLE.codcia = Evtclarti.codcia
            AND DETALLE.codcli = Evtclarti.codcli
            AND DETALLE.codmat = Evtclarti.codmat
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE DETALLE THEN DO:
            CREATE DETALLE.
            BUFFER-COPY Almmmatg TO DETALLE
                ASSIGN
                    DETALLE.codcli = Gn-clie.codcli
                    DETALLE.nomcli = Gn-clie.nomcli
                    DETALLE.desfam = Almtfami.desfam.
        END.
        /*****************Capturando el Mes siguiente *******************/
        IF EvtClArti.Codmes < 12 THEN DO:
            ASSIGN
                X-CODMES = EvtClArti.Codmes + 1
                X-CODANO = EvtClArti.Codano.
        END.
        ELSE DO: 
            ASSIGN
                X-CODMES = 01
                X-CODANO = EvtClArti.Codano + 1.
        END.
        /*********************** Calculo Para Obtener los datos diarios ************/
        DO j = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
            X-FECHA = DATE(STRING(j,"99") + "/" + STRING(EvtClArti.Codmes,"99") + "/" + STRING(EvtClArti.Codano,"9999")).
            IF X-FECHA >= x-FchDoc-1 AND X-FECHA <= x-FchDoc-2 THEN DO:
                FIND LAST Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(j,"99") + "/" + 
                    STRING(EvtClArti.Codmes,"99") + "/" + STRING(EvtClArti.Codano,"9999")) 
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tcmb THEN DO: 
                    IF x-CodMon = 1
                    THEN DETALLE.Venta = DETALLE.Venta + EvtClArti.Vtaxdiamn[j] + EvtClArti.Vtaxdiame[j] * Gn-Tcmb.Venta.
                    ELSE DETALLE.Venta = DETALLE.Venta + EvtClArti.Vtaxdiame[j] + EvtClArti.Vtaxdiamn[j] / Gn-Tcmb.Compra.
                    DETALLE.Cantidad = DETALLE.Cantidad + Evtclarti.canxdia[j].
                END.
            END.
       END.         
      /******************************************************************************/      
       PAUSE 0.
    END.
  END.

    REPEAT:
        s-task-no = RANDOM(1, 999999).
        FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
        IF NOT AVAILABLE w-report THEN LEAVE.
    END.

    FOR EACH DETALLE:
        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no
            w-report.llave-c = s-user-id
            w-report.campo-c[1] = detalle.codcli
            w-report.campo-c[2] = detalle.nomcli
            w-report.campo-c[3] = detalle.codfam
            w-report.campo-c[4] = detalle.codmar
            w-report.campo-c[5] = detalle.desmar
            w-report.campo-c[6] = detalle.codmat
            w-report.campo-c[7] = detalle.desmat
            w-report.campo-c[8] = detalle.desfam
            w-report.campo-f[1] = detalle.cantidad
            w-report.campo-f[2] = detalle.venta.
    END.
    /*
    HIDE FRAME F-Proceso.
    */

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

    DEF VAR i AS INT NO-UNDO.
    DEF VAR j AS INT NO-UNDO.
    DEF VAR X-CODDIA AS INTEGER INIT 1.
    DEF VAR X-CODANO AS INTEGER .
    DEF VAR X-CODMES AS INTEGER .
    DEF VAR X-FECHA  AS DATE.
    DEF VAR x-NroFch-1 AS INT NO-UNDO.
    DEF VAR x-NroFch-2 AS INT NO-UNDO.
    DEFINE VARIABLE cCodcli AS CHARACTER   NO-UNDO.

    /*VIEW FRAME F-Proceso.*/

    FOR EACH Detalle:
        DELETE Detalle.
    END.

    FOR EACH tt-cliente:
        DELETE tt-cliente.
    END.

    /* Carga de Excel */
    OUTPUT TO VALUE(FILL-IN-file) APPEND.
    PUT UNFORMATTED "" CHR(10) SKIP.
    OUTPUT CLOSE.
    INPUT FROM VALUE(FILL-IN-file).
    REPEAT:
        CREATE tt-cliente.
        IMPORT tt-codcli.
    END.
    INPUT CLOSE.

    FOR EACH tt-cliente:
        IF tt-codcli = "" THEN DO:
            DELETE tt-cliente.
            NEXT.
        END.
        FOR Gn-clie
            FIELDS (Gn-clie.codcia Gn-clie.codcli Gn-clie.nomcli)
            WHERE Gn-clie.codcia = cl-codcia
            AND Gn-clie.codcli = tt-codcli
            NO-LOCK:
        END.
        IF NOT AVAILABLE Gn-clie THEN DO:
            DELETE tt-cliente.
            NEXT.
        END.
        ASSIGN tt-nomcli = Gn-clie.nomcli.
    END.

    IF NOT CAN-FIND(FIRST tt-cliente) THEN DO:
        HIDE FRAME f-proceso NO-PAUSE.
        RETURN.
    END.

    IF f-Division = '' THEN DO:
        FOR EACH GN-DIVI WHERE gn-divi.codcia = s-codcia NO-LOCK:
            IF f-Division = '' 
            THEN f-Division = TRIM(gn-divi.coddiv).
            ELSE f-Division = f-Division + ',' + TRIM(gn-divi.coddiv).
        END.
    END.

    x-NroFch-1 = YEAR(x-FchDoc-1) * 100 + MONTH(x-FchDoc-1).
    x-NroFch-2 = YEAR(x-FchDoc-2) * 100 + MONTH(x-FchDoc-2).

    FOR EACH tt-cliente NO-LOCK:
        /*
        DISPLAY
            tt-CodCli @ Fi-Mensaje
            LABEL "  Cargando Código" FORMAT "X(13)"
            WITH FRAME F-Proceso.
        */    
        DO i = 1 TO NUM-ENTRIES(f-Division):
            FOR EACH EvtClArti USE-INDEX Llave04 NO-LOCK
                WHERE Evtclarti.codcia = s-codcia
                AND Evtclarti.coddiv = ENTRY(i, f-Division)
                AND Evtclarti.codcli = tt-CodCli
                AND Evtclarti.nrofch >= x-NroFch-1
                AND Evtclarti.nrofch <= x-NroFch-2,
                FIRST Almmmatg OF Evtclarti NO-LOCK,
                FIRST Almtfami WHERE Almtfami.codcia = s-codcia
                AND Almtfami.codfam = Almmmatg.codfam NO-LOCK:
    
                FIND DETALLE WHERE DETALLE.codcia = Evtclarti.codcia
                    AND DETALLE.codcli = Evtclarti.codcli
                    AND DETALLE.codmat = Evtclarti.codmat
                    EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE DETALLE THEN DO:
                    CREATE DETALLE.
                    BUFFER-COPY Almmmatg TO DETALLE
                    ASSIGN
                        DETALLE.codcli = tt-codcli
                        DETALLE.nomcli = tt-nomcli
                        DETALLE.desfam = Almtfami.desfam.
                END.
                /*****************Capturando el Mes siguiente *******************/
                IF EvtClArti.Codmes < 12 THEN DO:
                    ASSIGN
                        X-CODMES = EvtClArti.Codmes + 1
                        X-CODANO = EvtClArti.Codano.
                END.
                ELSE DO: 
                    ASSIGN
                        X-CODMES = 01
                        X-CODANO = EvtClArti.Codano + 1.
                END.
                /*********************** Calculo Para Obtener los datos diarios ************/
                DO j = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" +
                    STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ):
                    X-FECHA = DATE(STRING(j,"99") + "/" +
                        STRING(EvtClArti.Codmes,"99") + "/" +
                        STRING(EvtClArti.Codano,"9999")).
                    IF X-FECHA >= x-FchDoc-1 AND X-FECHA <= x-FchDoc-2 THEN DO:
                        FIND LAST Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(j,"99") + "/" + 
                            STRING(EvtClArti.Codmes,"99") + "/" + STRING(EvtClArti.Codano,"9999")) 
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE Gn-tcmb THEN DO: 
                            IF x-CodMon = 1
                            THEN DETALLE.Venta = DETALLE.Venta + EvtClArti.Vtaxdiamn[j] + EvtClArti.Vtaxdiame[j] * Gn-Tcmb.Venta.
                            ELSE DETALLE.Venta = DETALLE.Venta + EvtClArti.Vtaxdiame[j] + EvtClArti.Vtaxdiamn[j] / Gn-Tcmb.Compra.
                            DETALLE.Cantidad = DETALLE.Cantidad + Evtclarti.canxdia[j].
                        END.
                    END.
                END.         
                /******************************************************************************/      
            END.
            PAUSE 0.
        END.
    END.

    REPEAT:
        s-task-no = RANDOM(1, 999999).
        FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
        IF NOT AVAILABLE w-report THEN LEAVE.
    END.

    FOR EACH DETALLE:
        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no
            w-report.llave-c = s-user-id
            w-report.campo-c[1] = detalle.codcli
            w-report.campo-c[2] = detalle.nomcli
            w-report.campo-c[3] = detalle.codfam
            w-report.campo-c[4] = detalle.codmar
            w-report.campo-c[5] = detalle.desmar
            w-report.campo-c[6] = detalle.codmat
            w-report.campo-c[7] = detalle.desmat
            w-report.campo-c[8] = detalle.desfam
            w-report.campo-f[1] = detalle.cantidad
            w-report.campo-f[2] = detalle.venta.
    END.
    /*
    HIDE FRAME f-proceso NO-PAUSE.
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
  DISPLAY x-CodCli x-NomCli F-Division x-FchDoc-1 x-FchDoc-2 x-CodMon 
          FILL-IN-file txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-CodCli BUTTON-4 x-FchDoc-1 x-FchDoc-2 x-CodMon FILL-IN-file BUTTON-5 
         BUTTON-1 BUTTON-2 BUTTON-excel 
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

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cTitle             AS CHARACTER NO-UNDO.

    RUN Carga-Temporal-2.

    FIND FIRST w-report WHERE
        w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE
            "No existen registros a imprimir"
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:ADD().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    /* set the column names for the Worksheet */
    cTitle = "VENTAS POR CLIENTE Y MARCA - DEL " +
        STRING(x-fchdoc-1) + " AL " + STRING(x-fchdoc-2) + " - MONEDA " +
        (IF x-codmon = 1 THEN 'SOLES' ELSE 'DOLARES').
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE = cTitle.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "CLIENTE".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "NOMBRE O RAZON SOCIAL".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "LINEA".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "DESCRIPCION".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "MARCA".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "DESCRIPCION".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "ARTICULO".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "DESCRIPCION".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "CANTIDAD".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "VENTA".

    chWorkSheet:COLUMNS("A"):NumberFormat = "@".
    chWorkSheet:COLUMNS("B"):ColumnWidth = 40.
    chWorkSheet:COLUMNS("C"):NumberFormat = "@".
    chWorkSheet:COLUMNS("D"):ColumnWidth = 30.
    chWorkSheet:COLUMNS("E"):NumberFormat = "@".
    chWorkSheet:COLUMNS("F"):ColumnWidth = 30.
    chWorkSheet:COLUMNS("G"):NumberFormat = "@".
    chWorkSheet:COLUMNS("H"):ColumnWidth = 40.
    chWorkSheet:Range("A1:J2"):FONT:Bold = TRUE.

    FOR EACH w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.llave-c = s-user-id NO-LOCK
        BREAK BY w-report.campo-c[1]
        BY w-report.campo-c[3]
        BY w-report.campo-c[4]
        BY w-report.campo-c[6]:
        IF FIRST-OF(w-report.campo-c[1]) THEN
            /*
            DISPLAY
                w-report.campo-c[1] @ FI-MENSAJE
                    LABEL "  Procesando Cliente"
                    FORMAT "X(12)"
                WITH FRAME F-PROCESO.
            */    
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):VALUE = w-report.campo-c[1].
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):VALUE = w-report.campo-c[2].
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):VALUE = w-report.campo-c[3].
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):VALUE = w-report.campo-c[8].
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):VALUE = w-report.campo-c[4].
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):VALUE = w-report.campo-c[5].
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):VALUE = w-report.campo-c[6].
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):VALUE = w-report.campo-c[7].
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):VALUE = w-report.campo-f[1].
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):VALUE = w-report.campo-f[2].
    END.

    /* launch Excel so it is visible to the user */
    chExcelApplication:VISIBLE = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.
    /*
    HIDE FRAME F-PROCESO.
    */
    RUN Borra-Temporal.

    MESSAGE
        "Proceso Terminado con suceso"
        VIEW-AS ALERT-BOX INFORMA.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN carga-temporal.
    HIDE FRAME f-mensaje NO-PAUSE.

    FIND FIRST w-report WHERE
        w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE
            "No existen registros a imprimir"
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "vta\rbvta.prl"
        RB-REPORT-NAME = 'Ventas por Marca y Cliente'
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER =
            "w-report.task-no = " + STRING(s-task-no) +
            " AND w-report.llave-c = '" + TRIM(s-user-id) + "'"
        RB-OTHER-PARAMETERS =
            's-nomcia = ' + s-nomcia +
            '~ns-fchdoc-1 = ' + STRING(x-fchdoc-1) +
            '~ns-fchdoc-2 = ' + STRING(x-fchdoc-2) +
            '~ns-coddiv = ' + f-Division +
            '~ns-moneda = ' + (IF x-codmon = 1 THEN 'SOLES' ELSE 'DOLARES').

    RUN lib/_Imprime2(
        RB-REPORT-LIBRARY,
        RB-REPORT-NAME,
        RB-INCLUDE-RECORDS,
        RB-FILTER,
        RB-OTHER-PARAMETERS).

    RUN Borra-Temporal.

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
  ASSIGN
    x-FchDoc-1 = TODAY - DAY(TODAY) + 1
    x-FchDoc-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-Parametros W-Win 
PROCEDURE procesa-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
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
        WHEN "" THEN .
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

