&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
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

DEFINE SHARED VARIABLE s-codcia AS INTEGER.
DEFINE SHARED VARIABLE cb-codcia AS INTEGER.
DEFINE SHARED VARIABLE s-nomcia AS CHARACTER.
DEFINE SHARED VARIABLE s-periodo AS INTEGER.
DEFINE SHARED VARIABLE s-nromes AS INTEGER.
DEFINE SHARED VARIABLE s-user-id AS CHARACTER.

DEFINE VARIABLE RB-REPORT-LIBRARY AS CHAR NO-UNDO.
DEFINE VARIABLE RB-REPORT-NAME AS CHAR NO-UNDO.
DEFINE VARIABLE RB-INCLUDE-RECORDS AS CHAR NO-UNDO.
DEFINE VARIABLE RB-FILTER AS CHAR NO-UNDO.
DEFINE VARIABLE RB-OTHER-PARAMETERS AS CHAR NO-UNDO.

DEFINE VARIABLE s-task-no AS INT NO-UNDO.

DEFINE VARIABLE cPeriodo AS CHARACTER NO-UNDO.
DEFINE VARIABLE iNroMes AS INTEGER NO-UNDO.
DEFINE VARIABLE ind AS INTEGER NO-UNDO.
DEFINE VARIABLE FI-MENSAJE AS CHAR FORMAT "X(40)" NO-UNDO.
DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.

DEFINE VARIABLE cMonth AS CHARACTER NO-UNDO EXTENT 12
    INITIAL ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",        "Julio", "Agosto", "Setiembre", "Octubre", "Noviembre", "Diciembre"] .
DEFINE VARIABLE cDate AS CHARACTER NO-UNDO.

DEFINE TEMP-TABLE wrk_auxiliar NO-UNDO
    FIELDS wrk_codaux AS CHARACTER FORMAT "x(13)" LABEL "Auxiliar"
    FIELDS wrk_nomaux AS CHARACTER FORMAT "x(40)" LABEL "Nombre o Razón Social"
    FIELDS wrk_diraux AS CHARACTER FORMAT "x(40)" LABEL "Dirección"
    FIELDS wrk_ciudad AS CHARACTER FORMAT "x(20)" LABEL "Ciudad"
    FIELDS wrk_imptot AS DECIMAL FORMAT "->>>,>>>,>>9.99" LABEL "Importe"
        INDEX IDX01 IS PRIMARY wrk_codaux
        INDEX IDX02 wrk_nomaux
        INDEX IDX03 wrk_imptot.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6 SKIP
    Fi-Mensaje NO-LABEL FONT 6 SKIP     
    WITH CENTERED OVERLAY KEEP-TAB-ORDER 
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
        BGCOLOR 15 FGCOLOR 0 
        TITLE "Procesando ..." FONT 7.

RUN cbd/cb-m000 (OUTPUT cPeriodo).
IF cPeriodo = '' THEN DO:
    MESSAGE
        'NO existen periodos configurados para esta compañia'
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-Auxiliar

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES wrk_auxiliar

/* Definitions for BROWSE BROWSE-Auxiliar                               */
&Scoped-define FIELDS-IN-QUERY-BROWSE-Auxiliar wrk_codaux wrk_nomaux wrk_imptot   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-Auxiliar   
&Scoped-define SELF-NAME BROWSE-Auxiliar
&Scoped-define OPEN-QUERY-BROWSE-Auxiliar  CASE RADIO-sort:     WHEN 1 THEN OPEN QUERY {&BROWSE-NAME} FOR EACH wrk_auxiliar NO-LOCK.     WHEN 2 THEN OPEN QUERY {&BROWSE-NAME} FOR EACH wrk_auxiliar NO-LOCK BY wrk_nomaux.     WHEN 3 THEN OPEN QUERY {&BROWSE-NAME} FOR EACH wrk_auxiliar NO-LOCK BY wrk_imptot DESCENDING. END CASE.
&Scoped-define TABLES-IN-QUERY-BROWSE-Auxiliar wrk_auxiliar
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-Auxiliar wrk_auxiliar


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-Auxiliar}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 RECT-4 COMBO-Periodo ~
COMBO-mes RADIO-Cuenta RADIO-CodMon FILL-IN-monto FILL-IN-auditor ~
FILL-IN-fecha_doc FILL-IN-direccion FILL-IN-fecha_corte FILL-IN-fax ~
FILL-IN-fecha_res RADIO-sort BROWSE-Auxiliar Btn_Filtro Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS COMBO-Periodo COMBO-mes RADIO-Cuenta ~
RADIO-CodMon FILL-IN-monto FILL-IN-auditor FILL-IN-fecha_doc ~
FILL-IN-direccion FILL-IN-fecha_corte FILL-IN-fax FILL-IN-fecha_res ~
RADIO-sort 

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
     SIZE 11 BY 1.5 TOOLTIP "Cancelar"
     BGCOLOR 8 .

DEFINE BUTTON Btn_Filtro 
     IMAGE-UP FILE "adeicon\filter-d":U
     LABEL "Filtrar" 
     SIZE 11 BY 1.5 TOOLTIP "Filtrar Auxiliar"
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5 TOOLTIP "Imprimir Formato"
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-mes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Hasta Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "Apertura","Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-auditor AS CHARACTER FORMAT "X(256)":U 
     LABEL "Auditora" 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-direccion AS CHARACTER FORMAT "X(256)":U 
     LABEL "Dirección" 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-fax AS CHARACTER FORMAT "X(256)":U 
     LABEL "Fax" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-fecha_corte AS DATE FORMAT "99/99/99":U 
     LABEL "Fecha de corte" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-fecha_doc AS DATE FORMAT "99/99/99":U 
     LABEL "Fecha del documento" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-fecha_res AS DATE FORMAT "99/99/99":U 
     LABEL "Responder antes del" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-monto AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Monto Mínimo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-CodMon AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 7 BY 1.35 NO-UNDO.

DEFINE VARIABLE RADIO-Cuenta AS CHARACTER INITIAL "12" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Cliente", "12",
"Proveedor", "42"
     SIZE 10 BY 1.35 NO-UNDO.

DEFINE VARIABLE RADIO-sort AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Código", 1,
"Nombre", 2,
"Importe", 3
     SIZE 26 BY .58 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71 BY 2.88.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71 BY 3.27.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56 BY 10.19.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15 BY 10.19.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-Auxiliar FOR 
      wrk_auxiliar SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-Auxiliar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-Auxiliar W-Win _FREEFORM
  QUERY BROWSE-Auxiliar NO-LOCK DISPLAY
      wrk_codaux
      wrk_nomaux
      wrk_imptot
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 53.43 BY 8.54
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-Periodo AT ROW 1.38 COL 9 COLON-ALIGNED
     COMBO-mes AT ROW 1.38 COL 29 COLON-ALIGNED
     RADIO-Cuenta AT ROW 2.35 COL 11 NO-LABEL
     RADIO-CodMon AT ROW 2.35 COL 31 NO-LABEL
     FILL-IN-monto AT ROW 2.73 COL 55 COLON-ALIGNED
     FILL-IN-auditor AT ROW 4.08 COL 7 COLON-ALIGNED
     FILL-IN-fecha_doc AT ROW 4.08 COL 58 COLON-ALIGNED
     FILL-IN-direccion AT ROW 5.04 COL 7 COLON-ALIGNED
     FILL-IN-fecha_corte AT ROW 5.04 COL 58 COLON-ALIGNED
     FILL-IN-fax AT ROW 6 COL 7 COLON-ALIGNED
     FILL-IN-fecha_res AT ROW 6 COL 58 COLON-ALIGNED
     RADIO-sort AT ROW 7.54 COL 12 NO-LABEL
     BROWSE-Auxiliar AT ROW 8.31 COL 2
     Btn_Filtro AT ROW 8.31 COL 59
     Btn_OK AT ROW 13.88 COL 59
     Btn_Cancel AT ROW 15.42 COL 59
     "Auxiliar:" VIEW-AS TEXT
          SIZE 5.14 BY .5 AT ROW 2.73 COL 5.43
     "Ordenar por:" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 7.54 COL 3
     "Moneda:" VIEW-AS TEXT
          SIZE 6.14 BY .5 AT ROW 2.73 COL 24.57
     RECT-1 AT ROW 1 COL 1
     RECT-2 AT ROW 3.88 COL 1
     RECT-3 AT ROW 7.15 COL 1
     RECT-4 AT ROW 7.15 COL 57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.14 BY 16.38
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
         TITLE              = "Circularizaciones Clientes / Proveedor"
         HEIGHT             = 16.38
         WIDTH              = 71.14
         MAX-HEIGHT         = 16.38
         MAX-WIDTH          = 71.14
         VIRTUAL-HEIGHT     = 16.38
         VIRTUAL-WIDTH      = 71.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
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
/* BROWSE-TAB BROWSE-Auxiliar RADIO-sort F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-Auxiliar
/* Query rebuild information for BROWSE BROWSE-Auxiliar
     _START_FREEFORM

CASE RADIO-sort:
    WHEN 1 THEN OPEN QUERY {&BROWSE-NAME} FOR EACH wrk_auxiliar NO-LOCK.
    WHEN 2 THEN OPEN QUERY {&BROWSE-NAME} FOR EACH wrk_auxiliar NO-LOCK BY wrk_nomaux.
    WHEN 3 THEN OPEN QUERY {&BROWSE-NAME} FOR EACH wrk_auxiliar NO-LOCK BY wrk_imptot DESCENDING.
END CASE.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Where[1]         = "cb-ctas.CodCia = 0 AND
cb-ctas.CodCta BEGINS cCodCta AND
LENGTH(cb-ctas.CodCta) >= 6"
     _Query            is OPENED
*/  /* BROWSE BROWSE-Auxiliar */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Circularizaciones Clientes / Proveedor */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Circularizaciones Clientes / Proveedor */
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


&Scoped-define SELF-NAME Btn_Filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Filtro W-Win
ON CHOOSE OF Btn_Filtro IN FRAME F-Main /* Filtrar */
DO:

    ASSIGN
        COMBO-Periodo
        COMBO-Mes
        RADIO-CodMon
        RADIO-Cuenta
        FILL-IN-monto.

    DO WITH FRAME {&FRAME-NAME}:
        iNroMes = LOOKUP(COMBO-mes,COMBO-mes:LIST-ITEMS) - 1.
    END.

    RUN Carga_Temporal.
    {&OPEN-QUERY-{&BROWSE-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            FILL-IN-auditor
            FILL-IN-direccion
            FILL-IN-fax
            FILL-IN-fecha_doc
            FILL-IN-fecha_corte
            FILL-IN-fecha_res.
        IF BROWSE-Auxiliar:NUM-SELECTED-ROWS = 0 THEN DO:
            MESSAGE
                "Desea Imprimir Todos los Registros?"
                VIEW-AS ALERT-BOX
                QUESTION BUTTONS YES-NO
                UPDATE answer AS LOGICAL.
            IF NOT answer THEN RETURN NO-APPLY.
        END.
    END.

    RUN Imprime.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-sort
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-sort W-Win
ON VALUE-CHANGED OF RADIO-sort IN FRAME F-Main
DO:
    ASSIGN {&SELF-NAME}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-Auxiliar
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga_Formato W-Win 
PROCEDURE Carga_Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER para_form AS CHARACTER.

    cDate =
        STRING(DAY(FILL-IN-fecha_res),">9") + " de " +
        cMonth[MONTH(FILL-IN-fecha_res)] + " de " +
        STRING(YEAR(FILL-IN-fecha_res),"9999").

    CASE RADIO-Cuenta:
        WHEN "12" THEN  /* Clientes */
            ASSIGN para_form =
                "Nuestros auditores " + FILL-IN-auditor + ", están " +
                "efectuando la revisión de nuestros estados financieros al " +
                STRING(FILL-IN-fecha_corte) + ". " +
                "En relación con su examen están solicitando un estado de " +
                "cuenta detallado del saldo de nuestra cuenta con ustedes." +
                CHR(10) + CHR(10) +
                "Les agradeceremos enviar su respuesta directamente a " + FILL-IN-auditor +
                " a " + FILL-IN-direccion + " ó a los FAX N° " + FILL-IN-fax +
                " a mas tardar el " + cDate + ".".

        WHEN "42" THEN  /* Proveedores */
            ASSIGN para_form =
                "Nuestros auditores " + FILL-IN-auditor + ", están " +
                "efectuando la revisión de nuestros estados financieros. " +
                "En relación con su examen desean saber si nosotros les " +
                "adeudamos importe alguno al " + STRING(FILL-IN-fecha_corte) +
                ", así como el importe de anticipos otorgados. Si hubiese " +
                "algún saldo, favor adjuntar un estado de cuenta indicando " +
                "las partidas que lo conforman." +
                CHR(10) + CHR(10) +
                "Les agradeceremos enviar su respuesta directamente a " + FILL-IN-auditor +
                " a " + FILL-IN-direccion + " ó a los FAX N° " + FILL-IN-fax +
                " lo más breve posible.".
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga_Temporal W-Win 
PROCEDURE Carga_Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cb-codcia AS INTEGER NO-UNDO INITIAL 0.
    DEFINE VARIABLE pv-codcia AS INTEGER NO-UNDO INITIAL 0.
    DEFINE VARIABLE cl-codcia AS INTEGER NO-UNDO INITIAL 0.
    DEFINE VARIABLE cNomAux   AS CHARACTER FORMAT "X(50)" NO-UNDO.
    DEFINE VARIABLE cDirAux   AS CHARACTER FORMAT "X(50)" NO-UNDO.
    DEFINE VARIABLE cCiudad   AS CHARACTER FORMAT "X(50)" NO-UNDO.
    DEFINE VARIABLE cTipAux   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dDebe     AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dHaber    AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dSaldoCta AS DECIMAL NO-UNDO.

    FIND Empresas WHERE Empresas.CodCia = s-codcia NO-LOCK.
    IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.
    IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.
    IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

    DISPLAY WITH FRAME F-PROCESO.

    FOR EACH wrk_auxiliar:
        DELETE wrk_auxiliar.
    END.

    FOR EACH cb-dmov NO-LOCK WHERE
        cb-dmov.codcia = s-codcia AND
        cb-dmov.periodo = COMBO-periodo AND
        cb-dmov.nromes <= iNroMes AND
        cb-dmov.codcta BEGINS RADIO-Cuenta
        BREAK BY cb-dmov.codaux ON ERROR UNDO, LEAVE:

        IF NOT tpomov THEN DO:
            CASE RADIO-codmon:
                WHEN 1 THEN DO:
                    dDebe  = ImpMn1.
                    dHaber = 0.
                END.
                WHEN 2 THEN DO:
                    dDebe  = ImpMn2.
                    dHaber = 0.
                END.
            END CASE.
        END.
        ELSE DO:
            CASE RADIO-codmon:
                WHEN 1 THEN DO:
                    dDebe  = 0.
                    dHaber = ImpMn1.
                END.
                WHEN 2 THEN DO:
                    dDebe  = 0.
                    dHaber = ImpMn2.
                END.
            END CASE.
        END.
        IF NOT (dHaber = 0 AND dDebe = 0) AND
            dHaber <> ? AND dDebe <> ? THEN
            dSaldoCta = dSaldoCta + dDebe - dHaber.
        IF LAST-OF(cb-dmov.codaux) AND
            ABS(dSaldoCta) >= FILL-IN-monto AND
            dSaldoCta <> 0 THEN DO:
            cNomAux = "".
            cDirAux = "".
            cCiudad = "".
            CASE cb-dmov.clfaux:
                WHEN "@CL" THEN DO:
                    cTipAux = "Cliente".
                    FIND gn-clie WHERE
                        gn-clie.codcli = cb-dmov.codaux AND
                        gn-clie.CodCia = cl-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE gn-clie THEN DO:
                        cNomAux = gn-clie.nomcli.
                        cDirAux = gn-clie.dircli.
                        FIND Tabdistr WHERE
                            Tabdistr.CodDepto = gn-clie.CodDept AND
                            Tabdistr.Codprovi = gn-clie.codprov AND
                            Tabdistr.Coddistr = gn-clie.coddist 
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE Tabdistr THEN
                            cCiudad = Tabdistr.Nomdistr.
                    END.
                END.
                WHEN "@PV" THEN DO:
                    cTipAux = "Proveedor".
                    FIND gn-prov WHERE
                        gn-prov.codpro = cb-dmov.codaux AND
                        gn-prov.CodCia = pv-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE gn-prov THEN DO:
                        cNomAux = gn-prov.nompro.
                        cDirAux = gn-prov.dirpro.
                        FIND Tabdistr WHERE
                            Tabdistr.CodDepto = gn-prov.CodDept AND
                            Tabdistr.Codprovi = gn-prov.codprov AND
                            Tabdistr.Coddistr = gn-prov.coddist 
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE Tabdistr THEN
                            cCiudad = Tabdistr.Nomdistr.
                    END.
                END.
                WHEN "@CT" THEN DO:
                    cTipAux = "Cuenta".
                    find cb-ctas WHERE
                        cb-ctas.codcta = cb-dmov.codaux AND
                        cb-ctas.CodCia = cb-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-ctas THEN cNomAux = cb-ctas.nomcta.
                END.
                OTHERWISE DO:
                    cTipAux = "Otro".
                    FIND cb-auxi WHERE
                        cb-auxi.clfaux = cb-dmov.clfaux AND
                        cb-auxi.codaux = cb-dmov.codaux AND
                        cb-auxi.CodCia = cb-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-auxi THEN cNomAux = cb-auxi.nomaux.
                END.
            END CASE.
            CREATE wrk_auxiliar.
            ASSIGN
                wrk_codaux = cb-dmov.codaux
                wrk_nomaux = cNomAux
                wrk_diraux = cDirAux
                wrk_ciudad = cCiudad
                wrk_imptot = dSaldoCta
                dSaldoCta = 0.

            DISPLAY
                "   " + cTipAux + ": " + cb-dmov.codaux @ FI-MENSAJE
                WITH FRAME F-PROCESO.

        END.    /* IF LAST-OF(cb-dmov.codaux)... */
    END.  /* FOR EACH cb-dmov... */
    HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga_w-report W-Win 
PROCEDURE Carga_w-report :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lOk AS LOGICAL NO-UNDO.

    s-task-no = 0.
    cDate =
        "Lima, " + STRING(DAY(FILL-IN-fecha_doc),">9") + " de " +
        cMonth[MONTH(FILL-IN-fecha_doc)] + " de " +
        STRING(YEAR(FILL-IN-fecha_doc),"9999").

    IF BROWSE-Auxiliar:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} > 0 THEN
        DO ind = 1 TO BROWSE-Auxiliar:NUM-SELECTED-ROWS:
        lOk = BROWSE-Auxiliar:FETCH-SELECTED-ROW(ind).
        IF lOk THEN DO:
            IF s-task-no = 0 THEN REPEAT:
                s-task-no = RANDOM(1, 999999).
                IF NOT CAN-FIND(FIRST w-report WHERE
                    w-report.task-no = s-task-no AND
                    w-report.Llave-C = s-user-id NO-LOCK) THEN LEAVE.
            END.
            CREATE w-report.
            ASSIGN
                w-report.Task-No = s-task-no                    /* ID Tarea */
                w-report.Llave-C = s-user-id                    /* ID Usuario */
                w-report.Campo-C[1] = wrk_auxiliar.wrk_codaux   /* Auxiliar */
                w-report.Campo-C[2] = wrk_nomaux                /* Nombre  */
                w-report.Campo-C[3] = wrk_diraux                /* Direccion  */
                w-report.Campo-C[4] = wrk_ciudad                /* Ciudad  */
                w-report.Campo-C[5] = cDate                     /* Fecha */
                w-report.Campo-F[1] = wrk_imptot.               /* Importe */
            RUN Carga_Formato(OUTPUT w-report.Campo-C[6]).
        END.
    END.
    ELSE FOR EACH wrk_auxiliar NO-LOCK:
        IF s-task-no = 0 THEN REPEAT:
            s-task-no = RANDOM(1, 999999).
            IF NOT CAN-FIND(FIRST w-report WHERE
                w-report.task-no = s-task-no AND
                w-report.Llave-C = s-user-id NO-LOCK) THEN LEAVE.
        END.
        CREATE w-report.
        ASSIGN
            w-report.Task-No = s-task-no                        /* ID Tarea */
            w-report.Llave-C = s-user-id                        /* ID Usuario */
            w-report.Campo-C[1] = wrk_codaux                    /* Auxiliar */
            w-report.Campo-C[2] = wrk_nomaux                    /* Nombre  */
            w-report.Campo-C[3] = wrk_diraux                    /* Direccion  */
            w-report.Campo-C[4] = wrk_ciudad                    /* Ciudad  */
            w-report.Campo-C[5] = cDate                         /* Fecha */
            w-report.Campo-F[1] = wrk_imptot.                   /* Importe */
        RUN Carga_Formato(OUTPUT w-report.Campo-C[6]).
    END.

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
  DISPLAY COMBO-Periodo COMBO-mes RADIO-Cuenta RADIO-CodMon FILL-IN-monto 
          FILL-IN-auditor FILL-IN-fecha_doc FILL-IN-direccion 
          FILL-IN-fecha_corte FILL-IN-fax FILL-IN-fecha_res RADIO-sort 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 RECT-3 RECT-4 COMBO-Periodo COMBO-mes RADIO-Cuenta 
         RADIO-CodMon FILL-IN-monto FILL-IN-auditor FILL-IN-fecha_doc 
         FILL-IN-direccion FILL-IN-fecha_corte FILL-IN-fax FILL-IN-fecha_res 
         RADIO-sort BROWSE-Auxiliar Btn_Filtro Btn_OK Btn_Cancel 
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
    
    RUN Carga_w-report.

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "cbd/rbcbd.prl"
        RB-REPORT-NAME = "Circularizaciones"
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER =
            " w-report.task-no = " + STRING(s-task-no) +
            " AND w-report.Llave-C = '" + s-user-id + "'".

    RUN lib/_Imprime2(
        RB-REPORT-LIBRARY,
        RB-REPORT-NAME,
        RB-INCLUDE-RECORDS,
        RB-FILTER,
        RB-OTHER-PARAMETERS).

    FOR EACH w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id:
        DELETE w-report.
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

   DEFINE VARIABLE pto AS LOGICAL NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            COMBO-Periodo:LIST-ITEMS = cPeriodo
            COMBO-Periodo = s-periodo
            COMBO-Mes = ENTRY(s-nromes + 1,COMBO-Mes:LIST-ITEMS).
        IF s-nromes = 12 THEN
            FILL-IN-fecha_doc = DATE(12,31,s-periodo).
        ELSE
            FILL-IN-fecha_doc = DATE(s-nromes + 1,1,s-periodo) - 1.
        FILL-IN-fecha_corte = FILL-IN-fecha_doc.
        FILL-IN-fecha_res = FILL-IN-fecha_corte + 15.
        DO ind = 1 TO NUM-ENTRIES(cPeriodo):
            IF ENTRY(ind,cPeriodo) = "" THEN pto = COMBO-Periodo:DELETE("").
        END.
    END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
        WHEN "F-Catconta" THEN ASSIGN input-var-1 = "CC".
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "wrk_auxiliar"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

