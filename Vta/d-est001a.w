&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-Meses NO-UNDO LIKE PL-SEM
       FIELD Nombre AS CHAR
       INDEX Llave01 NroMes.



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
DEF SHARED VAR s-CodCia  AS INT.
DEF SHARED VAR cl-CodCia AS INT.
DEF SHARED VAR s-NomCia  AS CHAR.

DEF VAR s-Task-No AS INT NO-UNDO.
DEF VAR s-CodMon  AS INT NO-UNDO.
DEF VAR s-Titulo  AS CHAR NO-UNDO.
DEF VAR s-SubTitulo  AS CHAR NO-UNDO.

DEF VAR x-NroFch-1 AS INT NO-UNDO.
DEF VAR x-NroFch-2 AS INT NO-UNDO.
DEF VAR x-Mensaje  AS CHAR FORMAT 'x(30)'.

DEF FRAME F-MENSAJE
    x-Mensaje
    WITH TITLE 'Procesando, un momento por favor...'
        NO-LABELS CENTERED OVERLAY VIEW-AS DIALOG-BOX.

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "vta/rbvta.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-Meses

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-Meses

/* Definitions for BROWSE BROWSE-Meses                                  */
&Scoped-define FIELDS-IN-QUERY-BROWSE-Meses T-Meses.Nombre   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-Meses   
&Scoped-define SELF-NAME BROWSE-Meses
&Scoped-define QUERY-STRING-BROWSE-Meses FOR EACH T-Meses NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-Meses OPEN QUERY {&SELF-NAME} FOR EACH T-Meses NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-Meses T-Meses
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-Meses T-Meses


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-Meses}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Periodo RADIO-SET-Moneda ~
BROWSE-Meses COMBO-BOX-CodDiv COMBO-BOX-Canal BUTTON-1 BUTTON-5 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Periodo RADIO-SET-Moneda ~
COMBO-BOX-CodDiv COMBO-BOX-Canal txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Button 1" 
     SIZE 15 BY 1.54.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Button 5" 
     SIZE 15 BY 1.54.

DEFINE VARIABLE COMBO-BOX-Canal AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Canal" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 46 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-CodDiv AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 46 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Periodo AS INTEGER FORMAT "9999":U INITIAL 2003 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "2003","2004","2005","2006","2007","2008","2009","2010" 
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U INITIAL "Cargando Informacion....." 
     VIEW-AS FILL-IN 
     SIZE 34.29 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE RADIO-SET-Moneda AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2
     SIZE 16 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-Meses FOR 
      T-Meses SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-Meses
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-Meses W-Win _FREEFORM
  QUERY BROWSE-Meses DISPLAY
      T-Meses.Nombre COLUMN-LABEL 'Mes' FORMAT 'x(20)'
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-LABELS NO-ROW-MARKERS MULTIPLE SIZE 25 BY 9.04
         FONT 4
         TITLE "Seleccione Meses".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Periodo AT ROW 1.77 COL 23 COLON-ALIGNED
     RADIO-SET-Moneda AT ROW 2.73 COL 25 NO-LABEL
     BROWSE-Meses AT ROW 3.88 COL 19
     COMBO-BOX-CodDiv AT ROW 13.31 COL 17 COLON-ALIGNED
     COMBO-BOX-Canal AT ROW 14.27 COL 17 COLON-ALIGNED
     BUTTON-1 AT ROW 15.81 COL 39
     BUTTON-5 AT ROW 15.81 COL 55
     txt-msj AT ROW 16.08 COL 3.29 NO-LABEL WIDGET-ID 2
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 2.73 COL 19
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 72.29 BY 17.27
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-Meses T "?" NO-UNDO INTEGRAL PL-SEM
      ADDITIONAL-FIELDS:
          FIELD Nombre AS CHAR
          INDEX Llave01 NroMes
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "PROYECCION DE VENTA"
         HEIGHT             = 17.27
         WIDTH              = 72.29
         MAX-HEIGHT         = 17.27
         MAX-WIDTH          = 72.29
         VIRTUAL-HEIGHT     = 17.27
         VIRTUAL-WIDTH      = 72.29
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

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-Meses RADIO-SET-Moneda F-Main */
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       txt-msj:HIDDEN IN FRAME F-Main           = TRUE
       txt-msj:READ-ONLY IN FRAME F-Main        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-Meses
/* Query rebuild information for BROWSE BROWSE-Meses
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH T-Meses NO-LOCK.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-Meses */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* PROYECCION DE VENTA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PROYECCION DE VENTA */
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
  ASSIGN COMBO-BOX-Periodo RADIO-SET-Moneda COMBO-BOX-Canal COMBO-BOX-CodDiv.
  s-CodMon = RADIO-SET-Moneda.
  RUN Imprimir.
  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 5 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-Meses
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Meses W-Win 
PROCEDURE Carga-Meses :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR i AS INT NO-UNDO.
  
  DO I = 1 TO 12:
    CREATE T-Meses.
    ASSIGN
        T-Meses.NroMes = I.
    CASE I:
        WHEN 1 THEN T-Meses.Nombre = 'Enero'.
        WHEN 2 THEN T-Meses.Nombre = 'Febrero'.
        WHEN 3 THEN T-Meses.Nombre = 'Marzo'.
        WHEN 4 THEN T-Meses.Nombre = 'Abril'.
        WHEN 5 THEN T-Meses.Nombre = 'Mayo'.
        WHEN 6 THEN T-Meses.Nombre = 'Junio'.
        WHEN 7 THEN T-Meses.Nombre = 'Julio'.
        WHEN 8 THEN T-Meses.Nombre = 'Agosto'.
        WHEN 9 THEN T-Meses.Nombre = 'Setiembre'.
        WHEN 10 THEN T-Meses.Nombre = 'Octubre'.
        WHEN 11 THEN T-Meses.Nombre = 'Noviembre'.
        WHEN 12 THEN T-Meses.Nombre = 'Diciembre'.
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
  DEF VAR x-Llave-c AS CHAR NO-UNDO.
  DEF VAR x-Campo-c AS CHAR EXTENT 4 NO-UNDO.
  DEF VAR x-Campo-f AS DEC  EXTENT 6 NO-UNDO.
  DEF VAR x-Item    AS INT NO-UNDO.
  DEF VAR x-CodDiv  AS CHAR NO-UNDO.
  DEF VAR x-Canal   AS CHAR NO-UNDO.
 
  DEF VAR T-Vtamn   AS DEC NO-UNDO.
  DEF VAR T-Vtame   AS DEC NO-UNDO.
  DEF VAR X-CODDIA  AS INT NO-UNDO.
  DEF VAR X-CODMES  AS INT NO-UNDO.
  DEF VAR X-CODANO  AS INT NO-UNDO.
  DEF VAR I         AS INT NO-UNDO.
  DEF VAR X-FECHA   AS DATE NO-UNDO.

  x-CodDiv = COMBO-BOX-CodDiv.
  IF x-CodDiv <> 'Todas' THEN x-CodDiv = SUBSTRING(x-CodDiv, 1, INDEX(x-CodDiv, ' ') - 1).

  x-Canal = COMBO-BOX-Canal.
  IF x-Canal <> 'Todos' THEN x-Canal = SUBSTRING(x-Canal, 1, INDEX(x-Canal, ' ') - 1).

  REPEAT:
    s-task-no = RANDOM(1,999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK)
    THEN LEAVE.
  END.

  DO x-Item = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(x-Item) 
    THEN ASSIGN
            x-NroFch-1 = DECIMAL(COMBO-BOX-Periodo) * 100 + T-Meses.NroMes
            x-NroFch-2 = DECIMAL(COMBO-BOX-Periodo) * 100 + T-Meses.NroMes.
    FOR EACH GN-DIVI NO-LOCK WHERE gn-divi.codcia = s-codcia
            AND (COMBO-BOX-CodDiv = 'Todas' OR gn-divi.coddiv = x-CodDiv):
        ESTADISTICA:
        FOR EACH EvtClArti NO-LOCK WHERE evtclarti.codcia = s-codcia
            AND evtclarti.coddiv  = GN-DIVI.coddiv
            AND nrofch >= x-nrofch-1
            AND nrofch <= x-nrofch-2:
          x-Mensaje = evtclarti.coddiv + ' ' + evtclarti.codmat.
          /*
          DISPLAY x-Mensaje WITH FRAME F-MENSAJE.
          */
          /* Inicializamos valores */
          ASSIGN
            x-Llave-c    = SUBSTRING(STRING(evtclarti.nrofch, '999999'), 5,2)
            x-Campo-f[1] = 0
            x-Campo-f[2] = 0
            x-Campo-f[3] = 0
            x-Campo-f[4] = 0
            x-Campo-f[5] = 0    /* Fotocopia */
            x-Campo-f[6] = 0.   /* Otros */



            T-Vtamn   = 0.
            T-Vtame   = 0.
            /*****************Capturando el Mes siguiente *******************/
            X-CODDIA = 01.
            IF Evtclarti.Codmes < 12 THEN DO:
              ASSIGN
              X-CODMES = Evtclarti.Codmes + 1
              X-CODANO = Evtclarti.Codano .
            END.
            ELSE DO: 
              ASSIGN
              X-CODMES = 01
              X-CODANO = Evtclarti.Codano + 1 .
            END.
            /*********************** Calculo Para Obtener los datos diarios ************/
             DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
                X-FECHA = DATE(STRING(I,"99") + "/" + STRING(Evtclarti.Codmes,"99") + "/" + STRING(Evtclarti.Codano,"9999")).
                    FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + 
                                                        STRING(Evtclarti.Codmes,"99") + "/" + 
                                                        STRING(Evtclarti.Codano,"9999")) NO-LOCK NO-ERROR.
                    IF AVAILABLE Gn-tcmb THEN DO: 
                     T-Vtamn   = T-Vtamn   + Evtclarti.Vtaxdiamn[I] + Evtclarti.Vtaxdiame[I] * Gn-Tcmb.Venta.
                     T-Vtame   = T-Vtame   + Evtclarti.Vtaxdiame[I] + Evtclarti.Vtaxdiamn[I] / Gn-Tcmb.Compra.
                    END.
             END.         
            /******************************************************************************/      

          /* Clasificamos por la Familia */
          FIND AlmMMatg OF EvtClArti NO-LOCK NO-ERROR.
          IF AVAILABLE Almmmatg
          THEN DO:
            CASE Almmmatg.codfam:
                WHEN '000' THEN x-Campo-f[1] = IF s-codmon = 2 THEN T-VtaMe /*EvtClArti.VtaxMesMe */
                                                ELSE T-VtaMn /*EvtClArti.VtaxMesMn*/.
                WHEN '001' THEN x-Campo-f[2] = IF s-codmon = 2 THEN T-VtaMe /*EvtClArti.VtaxMesMe */
                                                ELSE T-VtaMn /*EvtClArti.VtaxMesMn*/.
                WHEN '002' THEN x-Campo-f[3] = IF s-codmon = 2 THEN T-VtaMe /*EvtClArti.VtaxMesMe */
                                                ELSE T-VtaMn /*EvtClArti.VtaxMesMn*/.
                WHEN '010' THEN x-Campo-f[4] = IF s-codmon = 2 THEN T-VtaMe /*EvtClArti.VtaxMesMe */
                                                ELSE T-VtaMn /*EvtClArti.VtaxMesMn*/.
                WHEN '011' THEN x-Campo-f[5] = IF s-codmon = 2 THEN T-VtaMe /*EvtClArti.VtaxMesMe */
                                                ELSE T-VtaMn /*EvtClArti.VtaxMesMn*/.
                OTHERWISE x-Campo-f[6] = IF s-codmon = 2 THEN T-VtaMe /*EvtClArti.VtaxMesMe */
                                                ELSE T-VtaMn /*EvtClArti.VtaxMesMn*/.
            END CASE.
          END.
          ELSE x-Campo-f[6] = IF s-codmon = 2 THEN T-VtaMe /*EvtClArti.VtaxMesMe*/ ELSE T-VtaMn /*EvtClArti.VtaxMesMn*/.


            /* Agrupamos por Oficina y Ferias */
            CASE evtclarti.coddiv:
                WHEN '00001' OR WHEN '00002' OR WHEN '00003' OR WHEN '00012' THEN DO:
                    ASSIGN
                        x-Campo-c[1] = '01'
                        x-Campo-c[2] = 'Total Tiendas'
                        x-Campo-c[3] = evtclarti.coddiv
                        x-Campo-c[4] = GN-DIVI.DesDiv.
                    FIND w-report WHERE task-no = s-task-no 
                        AND llave-c = x-Llave-c
                        AND campo-c[1] = x-Campo-c[1]
                        AND campo-c[3] = x-Campo-c[3] EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT AVAILABLE w-report
                    THEN CREATE w-report.
                    ASSIGN
                        w-report.task-no = s-task-no
                        w-report.llave-c = x-llave-c
                        w-report.campo-c[1] = x-campo-c[1]
                        w-report.campo-c[2] = x-campo-c[2]
                        w-report.campo-c[3] = x-campo-c[3]
                        w-report.campo-c[4] = x-campo-c[4]
                        w-report.campo-f[1] = w-report.campo-f[1] + x-campo-f[1]
                        w-report.campo-f[2] = w-report.campo-f[2] + x-campo-f[2]
                        w-report.campo-f[3] = w-report.campo-f[3] + x-campo-f[3]
                        w-report.campo-f[4] = w-report.campo-f[4] + x-campo-f[4]
                        w-report.campo-f[5] = w-report.campo-f[5] + x-campo-f[5]
                        w-report.campo-f[6] = w-report.campo-f[6] + x-campo-f[6].
                END.
                WHEN '00000' THEN DO:
                  ASSIGN
                      x-Campo-c[1] = '02'
                      x-Campo-c[2] = 'Total Oficina'.
                    /* buscamos el canal del cliente */
                    FIND GN-CLIE WHERE GN-CLIE.codcia = cl-codcia
                      AND GN-CLIE.codcli = EVTCLARTI.codcli NO-LOCK NO-ERROR.
                    IF AVAILABLE GN-CLIE
                    THEN DO:
                        IF x-Canal <> 'Todos' AND Gn-clie.canal <> x-Canal THEN NEXT ESTADISTICA.
                        FIND Almtabla WHERE Almtabla.Tabla = 'CN'
                            AND Almtabla.codigo = Gn-clie.canal
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE Almtabla
                        THEN ASSIGN
                                x-Campo-c[3] = Gn-clie.canal
                                x-Campo-c[4] = almtabla.Nombre.
                        ELSE ASSIGN
                                x-Campo-c[3] = '99998'
                                x-Campo-c[4] = 'SIN CANAL ESPECIFICO'.
/*                        CASE GN-CLIE.Canal:
 *                             WHEN '0006' THEN DO:
 *                                 ASSIGN
 *                                     x-Campo-c[3] = '01'
 *                                     x-Campo-c[4] = 'Horizontal'.
 *                             END.
 *                             WHEN '0001' THEN DO:
 *                                 ASSIGN
 *                                     x-Campo-c[3] = '02'
 *                                     x-Campo-c[4] = 'Estatal'.
 *                             END.
 *                             WHEN '0002' OR WHEN '0003' OR WHEN '0004' THEN DO:
 *                                 ASSIGN
 *                                     x-Campo-c[3] = '03'
 *                                     x-Campo-c[4] = 'Privado'.
 *                             END.
 *                             WHEN '0005' OR WHEN '0007' THEN DO:
 *                                 ASSIGN
 *                                     x-Campo-c[3] = '04'
 *                                     x-Campo-c[4] = 'Provincia'.
 *                             END.
 *                             WHEN '0008' THEN DO:
 *                                 ASSIGN
 *                                     x-Campo-c[3] = '05'
 *                                     x-Campo-c[4] = 'Supermercado/Cadena Tiendas'.
 *                             END.
 *                             OTHERWISE DO:
 *                                 ASSIGN
 *                                     x-Campo-c[3] = '06'
 *                                     x-Campo-c[4] = 'Otros'.
 *                             END.
 *                         END CASE.*/
                    END.
                    ELSE DO:
                          ASSIGN
                              x-Campo-c[3] = '99999'
                              x-Campo-c[4] = 'CLIENTE NO REGISTRADO'.
                    END.
                    FIND w-report WHERE task-no = s-task-no 
                      AND llave-c = x-Llave-c
                      AND campo-c[1] = x-Campo-c[1]
                      AND campo-c[3] = x-Campo-c[3] EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT AVAILABLE w-report
                    THEN CREATE w-report.
                    ASSIGN
                      w-report.task-no = s-task-no
                      w-report.llave-c = x-llave-c
                      w-report.campo-c[1] = x-campo-c[1]
                      w-report.campo-c[2] = x-campo-c[2]
                      w-report.campo-c[3] = x-campo-c[3]
                      w-report.campo-c[4] = x-campo-c[4]
                      w-report.campo-f[1] = w-report.campo-f[1] + x-campo-f[1]
                      w-report.campo-f[2] = w-report.campo-f[2] + x-campo-f[2]
                      w-report.campo-f[3] = w-report.campo-f[3] + x-campo-f[3]
                      w-report.campo-f[4] = w-report.campo-f[4] + x-campo-f[4]
                      w-report.campo-f[5] = w-report.campo-f[5] + x-campo-f[5]
                      w-report.campo-f[6] = w-report.campo-f[6] + x-campo-f[6].
                END.
                WHEN '00005' OR WHEN '00009' OR WHEN '00011' OR WHEN '00013' THEN DO:
                    ASSIGN
                        x-Campo-c[1] = '03'
                        x-Campo-c[2] = 'Total Ferias'
                        x-Campo-c[3] = evtclarti.coddiv
                        x-Campo-c[4] = GN-DIVI.DesDiv.
                    FIND w-report WHERE task-no = s-task-no 
                        AND llave-c = x-Llave-c
                        AND campo-c[1] = x-Campo-c[1]
                        AND campo-c[3] = x-Campo-c[3] EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT AVAILABLE w-report
                    THEN CREATE w-report.
                    ASSIGN
                        w-report.task-no = s-task-no
                        w-report.llave-c = x-llave-c
                        w-report.campo-c[1] = x-campo-c[1]
                        w-report.campo-c[2] = x-campo-c[2]
                        w-report.campo-c[3] = x-campo-c[3]
                        w-report.campo-c[4] = x-campo-c[4]
                        w-report.campo-f[1] = w-report.campo-f[1] + x-campo-f[1]
                        w-report.campo-f[2] = w-report.campo-f[2] + x-campo-f[2]
                        w-report.campo-f[3] = w-report.campo-f[3] + x-campo-f[3]
                        w-report.campo-f[4] = w-report.campo-f[4] + x-campo-f[4]
                        w-report.campo-f[5] = w-report.campo-f[5] + x-campo-f[5]
                        w-report.campo-f[6] = w-report.campo-f[6] + x-campo-f[6].
                END.
/*                WHEN '00014' THEN DO:
 *                   ASSIGN
 *                       x-Campo-c[1] = '02'
 *                       x-Campo-c[2] = 'Total Oficina'
 *                       x-Campo-c[3] = '01'
 *                       x-Campo-c[4] = 'Horizontal'.
 *                     FIND w-report WHERE task-no = s-task-no 
 *                       AND llave-c = x-Llave-c
 *                       AND campo-c[1] = x-Campo-c[1]
 *                       AND campo-c[3] = x-Campo-c[3] EXCLUSIVE-LOCK NO-ERROR.
 *                     IF NOT AVAILABLE w-report
 *                     THEN CREATE w-report.
 *                     ASSIGN
 *                       w-report.task-no = s-task-no
 *                       w-report.llave-c = x-llave-c
 *                       w-report.campo-c[1] = x-campo-c[1]
 *                       w-report.campo-c[2] = x-campo-c[2]
 *                       w-report.campo-c[3] = x-campo-c[3]
 *                       w-report.campo-c[4] = x-campo-c[4]
 *                       w-report.campo-f[1] = w-report.campo-f[1] + x-campo-f[1]
 *                       w-report.campo-f[2] = w-report.campo-f[2] + x-campo-f[2]
 *                       w-report.campo-f[3] = w-report.campo-f[3] + x-campo-f[3]
 *                       w-report.campo-f[4] = w-report.campo-f[4] + x-campo-f[4]
 *                       w-report.campo-f[5] = w-report.campo-f[5] + x-campo-f[5]
 *                       w-report.campo-f[6] = w-report.campo-f[6] + x-campo-f[6].
 *                 END.*/
                OTHERWISE DO:
                    ASSIGN
                        x-Campo-c[1] = '04'
                        x-Campo-c[2] = 'Otros'
                        x-Campo-c[3] = evtclarti.coddiv
                        x-Campo-c[4] = GN-DIVI.DesDiv.
                    FIND w-report WHERE task-no = s-task-no 
                        AND llave-c = x-Llave-c
                        AND campo-c[1] = x-Campo-c[1]
                        AND campo-c[3] = x-Campo-c[3] EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT AVAILABLE w-report
                    THEN CREATE w-report.
                    ASSIGN
                        w-report.task-no = s-task-no
                        w-report.llave-c = x-llave-c
                        w-report.campo-c[1] = x-campo-c[1]
                        w-report.campo-c[2] = x-campo-c[2]
                        w-report.campo-c[3] = x-campo-c[3]
                        w-report.campo-c[4] = x-campo-c[4]
                        w-report.campo-f[1] = w-report.campo-f[1] + x-campo-f[1]
                        w-report.campo-f[2] = w-report.campo-f[2] + x-campo-f[2]
                        w-report.campo-f[3] = w-report.campo-f[3] + x-campo-f[3]
                        w-report.campo-f[4] = w-report.campo-f[4] + x-campo-f[4]
                        w-report.campo-f[5] = w-report.campo-f[5] + x-campo-f[5]
                        w-report.campo-f[6] = w-report.campo-f[6] + x-campo-f[6].
                END.
            END CASE.

        END.
    END.
  END.
  /*
  HIDE FRAME F-MENSAJE.
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
  DISPLAY COMBO-BOX-Periodo RADIO-SET-Moneda COMBO-BOX-CodDiv COMBO-BOX-Canal 
          txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-Periodo RADIO-SET-Moneda BROWSE-Meses COMBO-BOX-CodDiv 
         COMBO-BOX-Canal BUTTON-1 BUTTON-5 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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

  DEF VAR x-Item AS INT NO-UNDO.

    txt-msj:VISIBLE IN FRAME {&FRAME-NAME} = YES.
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

/*
    CASE RADIO-SET-MES:
        WHEN 1 THEN s-Titulo = 'ENE-ABR ' + STRING(COMBO-BOX-Periodo, '9999').
        WHEN 2 THEN s-Titulo = 'MAY-AGO ' + STRING(COMBO-BOX-Periodo, '9999').
        WHEN 3 THEN s-Titulo = 'SET-DIC ' + STRING(COMBO-BOX-Periodo, '9999').
    END CASE.
*/    

  s-Titulo = ''.
  DO x-Item = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(x-Item) THEN DO:
        CASE T-Meses.NroMes:
            WHEN 1 THEN s-Titulo = IF s-Titulo = '' THEN 'ENERO' ELSE s-Titulo + ',' + 'ENERO'.
            WHEN 2 THEN s-Titulo = IF s-Titulo = '' THEN 'FEBRERO' ELSE s-Titulo + ',' + 'FEBRERO'.
            WHEN 3 THEN s-Titulo = IF s-Titulo = '' THEN 'MARZO' ELSE s-Titulo + ',' + 'MARZO'.
            WHEN 4 THEN s-Titulo = IF s-Titulo = '' THEN 'ABRIL' ELSE s-Titulo + ',' + 'ABRIL'.
            WHEN 5 THEN s-Titulo = IF s-Titulo = '' THEN 'MAYO' ELSE s-Titulo + ',' + 'MAYO'.
            WHEN 6 THEN s-Titulo = IF s-Titulo = '' THEN 'JUNIO' ELSE s-Titulo + ',' + 'JUNIO'.
            WHEN 7 THEN s-Titulo = IF s-Titulo = '' THEN 'JULIO' ELSE s-Titulo + ',' + 'JULIO'.
            WHEN 8 THEN s-Titulo = IF s-Titulo = '' THEN 'AGOSTO' ELSE s-Titulo + ',' + 'AGOSTO'.
            WHEN 9 THEN s-Titulo = IF s-Titulo = '' THEN 'SETIEMBRE' ELSE s-Titulo + ',' + 'SETIEMBRE'.
            WHEN 10 THEN s-Titulo = IF s-Titulo = '' THEN 'OCTUBRE' ELSE s-Titulo + ',' + 'OCTUBRE'.
            WHEN 11 THEN s-Titulo = IF s-Titulo = '' THEN 'NOVIEMBRE' ELSE s-Titulo + ',' + 'NOVIEMBRE'.
            WHEN 12 THEN s-Titulo = IF s-Titulo = '' THEN 'DICIEMBRE' ELSE s-Titulo + ',' + 'DICIEMBRE'.
        END CASE.
    END.
  END.
  s-Titulo = s-Titulo + ' PERIODO ' + STRING(COMBO-BOX-Periodo).
  
    s-SubTitulo = 'EXPRESADO EN ' +
        IF s-CodMon = 1 THEN 'NUEVOS SOLES'
        ELSE 'DOLARES AMERICANOS'.

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "vta\rbvta.prl"
        RB-REPORT-NAME = "Proyeccion de Venta Texto"
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER = "w-report.task-no = " + STRING(s-task-no)
        RB-OTHER-PARAMETERS =
            "s-nomcia = " + s-nomcia +
            "~ns-titulo = " + s-titulo +
            "~ns-subtitulo = " + s-subtitulo.

    RUN lib/_Imprime2(
        RB-REPORT-LIBRARY,
        RB-REPORT-NAME,
        RB-INCLUDE-RECORDS,
        RB-FILTER,
        RB-OTHER-PARAMETERS).

    FOR EACH w-report WHERE w-report.task-no = s-task-no:
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
  RUN Carga-Meses.
  COMBO-BOX-Periodo = YEAR(TODAY).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH Gn-divi WHERE Gn-divi.codcia = s-codcia NO-LOCK:
        COMBO-BOX-CodDiv:ADD-LAST(TRIM(Gn-divi.coddiv) + ' ' + GN-DIVI.DesDiv).
    END.
    FOR EACH Almtabla NO-LOCK WHERE Almtabla.tabla = 'CN':
        COMBO-BOX-Canal:ADD-LAST(TRIM(almtabla.Codigo) + ' ' + almtabla.Nombre).
    END.
  END.

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
  {src/adm/template/snd-list.i "T-Meses"}

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

