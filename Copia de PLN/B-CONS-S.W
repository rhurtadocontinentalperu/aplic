&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*------------------------------------------------------------------------

  File:  

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

{bin/s-global.i}
{pln/s-global.i}

DEFINE NEW SHARED VARIABLE VAL-VAR AS DECIMAL EXTENT 20.
DEFINE VARIABLE CMB-lista AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-linea   AS CHARACTER FORMAT "x(80)" NO-UNDO.
DEFINE VARIABLE stat-reg  AS LOGICAL NO-UNDO.
DEFINE VARIABLE x-valcalI AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-valcalE AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-valcalA AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-conreg  AS INTEGER NO-UNDO.
DEFINE VARIABLE i         AS INTEGER NO-UNDO.
DEFINE VARIABLE x-dis-mon AS INTEGER EXTENT 5 NO-UNDO.
DEFINE VARIABLE x-acu-mon AS INTEGER EXTENT 5 NO-UNDO.

DEFINE BUTTON Btn_OK IMAGE-UP FILE "img/plobrbol"
    LABEL "OK" SIZE 6.43 BY 1.58 BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-Codigo AS CHARACTER FORMAT "X(256)":U 
    LABEL "Personal" VIEW-AS FILL-IN SIZE 6.72 BY .81 BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-Seccion AS CHARACTER FORMAT "X(256)":U 
    LABEL "Proyecto" VIEW-AS FILL-IN SIZE 28 BY .81 BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-20 EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL SIZE 37.14 BY 3.08.

DEFINE FRAME F-msg
    FILL-IN-Codigo AT ROW 2.08 COL 6.72 COLON-ALIGNED
    FILL-IN-Seccion AT ROW 2.96 COL 6.72 COLON-ALIGNED
    Btn_OK AT ROW 1.23 COL 30.29
    RECT-20 AT ROW 1 COL 1
    "Espere un momento por favor ..." VIEW-AS TEXT
    SIZE 22.57 BY .62 AT ROW 1.31 COL 4.43
    SPACE(11.13) SKIP(2.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
    FONT 4 TITLE "Procesando..." CENTERED.

DEFINE BUFFER b-PL-MOV-SEM FOR PL-MOV-SEM. /* BUFFER para busquedas de referencias */

DEFINE STREAM strm-boleta. /* STREAM para el reporte */

DEFINE TEMP-TABLE tmp-bole
    FIELD t-CodPer  AS CHARACTER
    FIELD t-NomPer  AS CHARACTER
    FIELD t-Linea   AS INTEGER
    FIELD t-Ingreso AS CHARACTER FORMAT "x(51)"
    FIELD t-Egreso  AS CHARACTER FORMAT "x(51)"
    FIELD t-Aporte  AS CHARACTER FORMAT "x(35)"
    INDEX i-nomper IS PRIMARY t-nomper t-Linea ASCENDING
    INDEX i-codper t-codper ASCENDING.

DEFINE TEMP-TABLE tmp-conc
    FIELD t-CodMov AS INTEGER
    FIELD t-TipMov AS CHARACTER
    FIELD t-Accum  AS DECIMAL
    INDEX i-CodMov IS PRIMARY t-CodMov ASCENDING.

DEFINE VARIABLE x-resumido AS LOGICAL INITIAL FALSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_pl-flg-s

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES integral.PL-PLAN integral.PL-CALC
&Scoped-define FIRST-EXTERNAL-TABLE integral.PL-PLAN


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR integral.PL-PLAN, integral.PL-CALC.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES integral.PL-FLG-SEM integral.PL-PERS

/* Definitions for BROWSE br_pl-flg-s                                   */
&Scoped-define FIELDS-IN-QUERY-br_pl-flg-s integral.PL-FLG-SEM.codper ~
integral.PL-PERS.patper integral.PL-PERS.matper integral.PL-PERS.nomper 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_pl-flg-s 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_pl-flg-s
&Scoped-define OPEN-QUERY-br_pl-flg-s OPEN QUERY br_pl-flg-s FOR EACH integral.PL-FLG-SEM ~
      WHERE PL-FLG-SEM.CodCia = s-CodCia ~
 AND PL-FLG-SEM.Periodo = s-Periodo ~
 AND PL-FLG-SEM.codpln = PL-PLAN.CodPln ~
 AND PL-FLG-SEM.NroSem = FILL-IN-NRO-SEM ~
 AND PL-FLG-SEM.SitAct <> "Inactivo" NO-LOCK, ~
      EACH integral.PL-PERS OF integral.PL-FLG-SEM NO-LOCK ~
    BY integral.PL-FLG-SEM.Proyecto ~
       BY integral.PL-FLG-SEM.seccion ~
        BY integral.PL-PERS.patper ~
         BY integral.PL-PERS.matper ~
          BY integral.PL-PERS.nomper.
&Scoped-define TABLES-IN-QUERY-br_pl-flg-s integral.PL-FLG-SEM ~
integral.PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-br_pl-flg-s integral.PL-FLG-SEM


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br_pl-flg-s}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-26 R-seleccion COMBO-S TGL-pantalla ~
FILL-IN-NRO-SEM B-aceptar Btn-UP Btn-DOWN br_pl-flg-s 
&Scoped-Define DISPLAYED-OBJECTS R-seleccion COMBO-S TGL-pantalla ~
FILL-IN-NRO-SEM 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-B-aceptar 
       MENU-ITEM m_Resumido     LABEL "Resumido"      
              TOGGLE-BOX.


/* Definitions of the field level widgets                               */
DEFINE BUTTON B-aceptar 
     IMAGE-UP FILE "img/b-ok":U
     LABEL "&Aceptar" 
     SIZE 10.72 BY 1.54.

DEFINE BUTTON Btn-DOWN 
     IMAGE-UP FILE "img/btn-down":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-UP 
     IMAGE-UP FILE "img/btn-up":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE VARIABLE COMBO-S AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 19.72 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-NRO-SEM AS INTEGER FORMAT "Z9":U INITIAL 0 
     LABEL "Semana" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE R-seleccion AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todo el personal", 1,
"Selectivo", 2,
"Por sección", 3,
"Por proyecto", 4
     SIZE 14.29 BY 1.92 NO-UNDO.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 69 BY 8.46.

DEFINE VARIABLE TGL-pantalla AS LOGICAL INITIAL no 
     LABEL "Salida a Pantalla" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.57 BY .5 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_pl-flg-s FOR 
      integral.PL-FLG-SEM, 
      integral.PL-PERS SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_pl-flg-s
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_pl-flg-s B-table-Win _STRUCTURED
  QUERY br_pl-flg-s NO-LOCK DISPLAY
      integral.PL-FLG-SEM.codper
      integral.PL-PERS.patper
      integral.PL-PERS.matper
      integral.PL-PERS.nomper
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 47.14 BY 7.96
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     R-seleccion AT ROW 2.5 COL 4 NO-LABEL
     COMBO-S AT ROW 4.54 COL 1.86 NO-LABEL
     TGL-pantalla AT ROW 5.54 COL 4.86
     FILL-IN-NRO-SEM AT ROW 1.42 COL 8.43 COLON-ALIGNED
     B-aceptar AT ROW 6.15 COL 6.29
     Btn-UP AT ROW 1.19 COL 14.43
     Btn-DOWN AT ROW 1.81 COL 14.43
     br_pl-flg-s AT ROW 1.23 COL 22
     RECT-26 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69 BY 8.46
         BGCOLOR 8 FGCOLOR 0 FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: integral.PL-PLAN,integral.PL-CALC
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 8.46
         WIDTH              = 69.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
                                                                        */
/* BROWSE-TAB br_pl-flg-s Btn-DOWN F-Main */
ASSIGN 
       B-aceptar:POPUP-MENU IN FRAME F-Main       = MENU POPUP-MENU-B-aceptar:HANDLE.

ASSIGN 
       br_pl-flg-s:NUM-LOCKED-COLUMNS IN FRAME F-Main = 1.

/* SETTINGS FOR COMBO-BOX COMBO-S IN FRAME F-Main
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_pl-flg-s
/* Query rebuild information for BROWSE br_pl-flg-s
     _TblList          = "integral.PL-FLG-SEM,integral.PL-PERS OF integral.PL-FLG-SEM"
     _Options          = "NO-LOCK"
     _OrdList          = "integral.PL-FLG-SEM.Proyecto|yes,integral.PL-FLG-SEM.seccion|yes,integral.PL-PERS.patper|yes,integral.PL-PERS.matper|yes,integral.PL-PERS.nomper|yes"
     _Where[1]         = "PL-FLG-SEM.CodCia = s-CodCia
 AND PL-FLG-SEM.Periodo = s-Periodo
 AND PL-FLG-SEM.codpln = PL-PLAN.CodPln
 AND PL-FLG-SEM.NroSem = FILL-IN-NRO-SEM
 AND PL-FLG-SEM.SitAct <> ""Inactivo"""
     _FldNameList[1]   = integral.PL-FLG-SEM.codper
     _FldNameList[2]   = integral.PL-PERS.patper
     _FldNameList[3]   = integral.PL-PERS.matper
     _FldNameList[4]   = integral.PL-PERS.nomper
     _Query            is OPENED
*/  /* BROWSE br_pl-flg-s */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-aceptar B-table-Win
ON CHOOSE OF B-aceptar IN FRAME F-Main /* Aceptar */
DO:
    ASSIGN FILL-IN-NRO-SEM COMBO-S R-seleccion.
    RUN imp_boleta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br_pl-flg-s
&Scoped-define SELF-NAME br_pl-flg-s
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-s B-table-Win
ON ROW-ENTRY OF br_pl-flg-s IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-s B-table-Win
ON ROW-LEAVE OF br_pl-flg-s IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-s B-table-Win
ON VALUE-CHANGED OF br_pl-flg-s IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-DOWN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN B-table-Win
ON CHOOSE OF Btn-DOWN IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main FILL-IN-NRO-SEM - 1 >= 1 THEN DO:
    DISPLAY INPUT FILL-IN-NRO-SEM - 1 @ FILL-IN-NRO-SEM WITH FRAME F-Main.
    ASSIGN FILL-IN-NRO-SEM.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-UP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP B-table-Win
ON CHOOSE OF Btn-UP IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main FILL-IN-NRO-SEM + 1 <= 53 THEN DO:
    DISPLAY INPUT FILL-IN-NRO-SEM + 1 @ FILL-IN-NRO-SEM WITH FRAME F-Main.
    ASSIGN FILL-IN-NRO-SEM.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-S
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-S B-table-Win
ON ENTRY OF COMBO-S IN FRAME F-Main
DO:
    ASSIGN CMB-Lista = "".
    CASE INPUT R-seleccion:
    WHEN 3 THEN DO:
        FOR EACH integral.PL-SECC NO-LOCK:
            ASSIGN CMB-Lista = CMB-Lista + "," + integral.PL-SECC.seccion.
        END.
    END.
    WHEN 4 THEN DO:
        FOR EACH integral.PL-PROY NO-LOCK:
            ASSIGN CMB-Lista = CMB-Lista + "," + integral.PL-PROY.proyecto.
        END.
    END.
    END CASE.
    COMBO-S:LIST-ITEMS IN FRAME F-Main = CMB-Lista.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NRO-SEM
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NRO-SEM B-table-Win
ON LEAVE OF FILL-IN-NRO-SEM IN FRAME F-Main /* Semana */
DO:
    IF INPUT FILL-IN-NRO-SEM > 54 OR INPUT FILL-IN-NRO-SEM = 0 THEN DO:
        BELL.
        MESSAGE "Rango de semanas es de 1 a 54"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FILL-IN-NRO-SEM.
        RETURN NO-APPLY.
    END.
    IF INPUT FILL-IN-NRO-SEM = FILL-IN-NRO-SEM THEN RETURN.
    ASSIGN FILL-IN-NRO-SEM.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Resumido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Resumido B-table-Win
ON VALUE-CHANGED OF MENU-ITEM m_Resumido /* Resumido */
DO:
    IF x-resumido THEN x-resumido = FALSE.
    ELSE x-resumido = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-seleccion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-seleccion B-table-Win
ON VALUE-CHANGED OF R-seleccion IN FRAME F-Main
DO:
    CASE INPUT R-seleccion:
    WHEN 1 THEN
        ASSIGN
            Br_pl-flg-s:SENSITIVE = FALSE
            COMBO-S:SENSITIVE     = FALSE.
    WHEN 2 THEN
        ASSIGN
            Br_pl-flg-s:SENSITIVE = TRUE
            COMBO-S:SENSITIVE     = FALSE.
    WHEN 3 OR WHEN 4 THEN DO:
        ASSIGN
            COMBO-S:LIST-ITEMS    = ""
            Br_pl-flg-s:SENSITIVE = FALSE
            COMBO-S:SENSITIVE     = TRUE.
        DISPLAY COMBO-S WITH FRAME F-Main.
    END.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ASSIGN FILL-IN-NRO-SEM = s-NroSem.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE acumula_conceptos B-table-Win 
PROCEDURE acumula_conceptos :
/*------------------------------------------------------------------------------
    Acumula conceptos
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER x-TipMov AS CHARACTER.

FIND FIRST tmp-conc WHERE t-CodMov = PL-MOV-SEM.CodMov NO-ERROR.
IF NOT AVAILABLE tmp-conc THEN DO:
    CREATE tmp-conc.
    ASSIGN
        t-CodMov = PL-MOV-SEM.CodMov
        t-TipMov = x-TipMov
        t-accum  = PL-MOV-SEM.valcal-Sem.
END.
ELSE ASSIGN t-accum = t-accum + PL-MOV-SEM.valcal-Sem.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "integral.PL-PLAN"}
  {src/adm/template/row-list.i "integral.PL-CALC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "integral.PL-PLAN"}
  {src/adm/template/row-find.i "integral.PL-CALC"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE busca_datos B-table-Win 
PROCEDURE busca_datos :
/*------------------------------------------------------------------------------
    Busca datos
------------------------------------------------------------------------------*/

DISPLAY PL-FLG-SEM.CodPer @ FILL-IN-Codigo WITH FRAME F-Msg.

IF NOT CAN-FIND(FIRST PL-MOV-SEM WHERE /* Si no tiene c lculo */
    PL-MOV-SEM.CodCia  = s-CodCia AND
    PL-MOV-SEM.Periodo = s-Periodo AND
    PL-MOV-SEM.NroSem  = FILL-IN-NRO-SEM AND
    PL-MOV-SEM.CodPln  = PL-PLAN.CodPln AND
    PL-MOV-SEM.CodCal  = PL-CALC.CodCal AND
    PL-MOV-SEM.CodPer  = PL-FLG-SEM.CodPer) THEN RETURN.

DEFINE VARIABLE x-nomper AS CHARACTER NO-UNDO.

FIND PL-PERS WHERE PL-PERS.CodPer = PL-FLG-SEM.CodPer NO-LOCK NO-ERROR.
IF AVAILABLE PL-PERS THEN
    x-nomper = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.

x-conreg = 0.

CREATE tmp-bole.
ASSIGN
    t-nomper  = x-nomper
    x-conreg  = x-conreg + 1
    t-linea   = x-conreg
    t-codper  = PL-FLG-SEM.CodPer
    t-ingreso = PL-FLG-SEM.CodPer + " " + x-nomper
    t-egreso  = FILL(" ",19) + "Inicio de vacaciones : "
    t-aporte  = "Fin de vacaciones : ".

IF PL-FLG-SEM.inivac <> ? THEN t-egreso = t-egreso + STRING(PL-FLG-SEM.inivac).
IF PL-FLG-SEM.finvac <> ? THEN t-aporte = t-aporte + STRING(PL-FLG-SEM.finvac).

CREATE tmp-bole.
ASSIGN
    t-nomper  = x-nomper
    x-conreg  = x-conreg + 1
    t-codper  = PL-FLG-SEM.CodPer
    t-linea   = x-conreg
    t-ingreso = "Cargo : " + PL-FLG-SEM.Cargo
    t-egreso  = "Secci¢n : " + PL-FLG-SEM.Seccion
    t-aporte  = "Proyecto : " + PL-FLG-SEM.Proyecto.

CREATE tmp-bole.
ASSIGN
    t-nomper  = x-nomper
    x-conreg  = x-conreg + 1
    t-codper  = PL-FLG-SEM.CodPer
    t-linea   = x-conreg
    t-ingreso = "Fecha de Ingreso : "
    t-egreso  = "Fecha de Cese : ".

IF PL-FLG-SEM.fecing <> ? THEN t-ingreso = t-ingreso + STRING(PL-FLG-SEM.fecing).

IF PL-FLG-SEM.vcontr <> ? THEN t-egreso = t-egreso + STRING(PL-FLG-SEM.vcontr).
ELSE t-egreso = t-egreso + "        ".

RUN PLN/P-CALC-S.R(
   integral.PL-FLG-SEM.Codcia,
   integral.PL-FLG-SEM.PERIODO,
   integral.PL-FLG-SEM.NroSem,
   integral.PL-FLG-SEM.codpln,
   1,
   integral.PL-FLG-SEM.codper,
   "^151(0);^154(0);^105(0);^106(0);^107(0);^109(0);^110(0)" ).

t-egreso = t-egreso + "      Salario : " + STRING(val-var[1] + val-var[2] +
    val-var[3] + val-var[4] + val-var[5] + val-var[6] + val-var[7], "ZZZ,ZZ9.99").

CREATE tmp-bole.
ASSIGN
    t-nomper  = x-nomper
    x-conreg  = x-conreg + 1
    t-codper  = PL-FLG-SEM.CodPer
    t-linea   = x-conreg
    t-ingreso = "Carnet de seguro : ".

IF AVAILABLE PL-PERS THEN
    ASSIGN t-ingreso = t-ingreso + STRING(PL-PERS.ctipss, "x(15)").
ELSE ASSIGN t-ingreso = t-ingreso + FILL(" ",15).

ASSIGN t-ingreso = t-ingreso + "  Fecha de pago :".

/* Para fecha de pago */
IF AVAILABLE PL-SEM THEN
    ASSIGN t-egreso = "del " + 
        STRING(DAY(PL-SEM.FecIni), "99") + " al " +
        STRING(DAY(PL-SEM.FecFin), "99") + " de " +
        STRING(MONTH(PL-SEM.FecFin), "99") + " de " +
        STRING(YEAR(PL-SEM.FecFin), "9,999").
ELSE ASSIGN t-egreso = "del    al    de    de".

FIND PL-AFPS WHERE PL-AFPS.CodAfp = PL-FLG-SEM.CodAfp NO-LOCK NO-ERROR.
IF AVAILABLE PL-AFPS THEN
    ASSIGN t-aporte = "AFP " + STRING(PL-AFPS.CodAfp, "99") + " " + PL-AFPS.DesAfp.

CREATE tmp-bole.
ASSIGN
    t-nomper = x-nomper
    x-conreg = x-conreg + 1
    t-codper = PL-FLG-SEM.CodPer
    t-linea  = x-conreg.

/* Para ingresos */
ASSIGN
    t-ingreso = " H A B E R E S "
    x-valcalE = 0
    x-valcalI = 0
    x-valcalA = 0.

FOR EACH PL-BOLE NO-LOCK WHERE
    PL-BOLE.CodPln = PL-PLAN.CodPln AND
    PL-BOLE.CodCal = PL-CALC.CodCal AND
    PL-BOLE.TpoBol = "Remuneraciones" BY PL-BOLE.nroitm:
    FIND PL-MOV-SEM WHERE
        PL-MOV-SEM.CodCia  = s-CodCia AND
        PL-MOV-SEM.Periodo = s-Periodo AND
        PL-MOV-SEM.NroSem  = FILL-IN-NRO-SEM AND
        PL-MOV-SEM.CodPln  = PL-PLAN.CodPln AND
        PL-MOV-SEM.CodCal  = PL-BOLE.CodCal AND
        PL-MOV-SEM.CodPer  = PL-FLG-SEM.CodPer AND
        PL-MOV-SEM.CodMov  = PL-BOLE.CodMov NO-LOCK NO-ERROR.
    IF AVAILABLE PL-MOV-SEM AND PL-MOV-SEM.ValCal-Sem <> 0 THEN DO:
        CREATE tmp-bole.
        ASSIGN
            x-conreg = x-conreg + 1
            t-CodPer  = PL-FLG-SEM.CodPer
            t-nomper  = x-nomper
            t-linea   = x-conreg
            t-ingreso = STRING(PL-MOV-SEM.CodMov, "999") + " ".
        FIND PL-CONC WHERE PL-CONC.CodMov = PL-MOV-SEM.CodMov NO-LOCK NO-ERROR.
        IF AVAILABLE PL-CONC THEN
            ASSIGN
                t-ingreso = t-ingreso + STRING(PL-CONC.DesMov, "x(20)") + " ".
        ELSE ASSIGN t-ingreso = t-ingreso + FILL(" ", 21).
        /* Para buscar referencia */
        IF PL-BOLE.CodRef <> 0 THEN DO:
            FIND b-PL-MOV-SEM WHERE
                b-PL-MOV-SEM.CodCia  = s-CodCia AND
                b-PL-MOV-SEM.Periodo = s-Periodo AND
                b-PL-MOV-SEM.NroSem  = FILL-IN-NRO-SEM AND
                b-PL-MOV-SEM.CodPln  = PL-PLAN.CodPln AND
                b-PL-MOV-SEM.CodCal  = PL-BOLE.CodCal-Ref AND
                b-PL-MOV-SEM.CodPer  = PL-FLG-SEM.CodPer AND
                b-PL-MOV-SEM.CodMov  = PL-BOLE.CodRef NO-LOCK NO-ERROR.
            IF AVAILABLE b-PL-MOV-SEM THEN
                ASSIGN
                    t-ingreso = t-ingreso +
                    STRING(b-PL-MOV-SEM.ValCal-Sem, "ZZZ,ZZ9.99") + " ".
            ELSE ASSIGN t-ingreso = t-ingreso + "           ".
        END.
        ELSE ASSIGN t-ingreso = t-ingreso + "           ".
        ASSIGN
            t-ingreso = t-ingreso + STRING(PL-MOV-SEM.ValCal-Sem, "ZZZ,ZZZ,ZZ9.99")
            x-valcalI = x-valcalI + PL-MOV-SEM.ValCal-Sem.
        RUN acumula_conceptos("ingreso"). /* Para acumulados de conceptos */
    END.
END.

/* Para egresos */
x-conreg = 5.
FIND FIRST tmp-bole WHERE
    tmp-bole.t-nomper = x-nomper AND
    tmp-bole.t-linea  = x-conreg NO-ERROR.
IF NOT AVAILABLE tmp-bole THEN DO:
    CREATE tmp-bole.
    ASSIGN
        t-nomper = x-nomper
        t-codper = PL-FLG-SEM.codper
        t-linea  = x-conreg.
END.
t-egreso = " D E S C U E N T O S ".

FOR EACH PL-BOLE NO-LOCK WHERE
    PL-BOLE.CodPln = PL-PLAN.CodPln AND
    PL-BOLE.CodCal = PL-CALC.CodCal AND
    PL-BOLE.TpoBol = "Descuentos" BY PL-BOLE.nroitm:
    FIND PL-MOV-SEM WHERE
        PL-MOV-SEM.CodCia  = s-CodCia AND
        PL-MOV-SEM.Periodo = s-Periodo AND
        PL-MOV-SEM.NroSem  = FILL-IN-NRO-SEM AND
        PL-MOV-SEM.CodPln  = PL-PLAN.CodPln AND
        PL-MOV-SEM.CodCal  = PL-BOLE.CodCal AND
        PL-MOV-SEM.CodPer  = PL-FLG-SEM.CodPer AND
        PL-MOV-SEM.CodMov  = PL-BOLE.CodMov NO-LOCK NO-ERROR.
    IF AVAILABLE PL-MOV-SEM AND PL-MOV-SEM.ValCal-Sem <> 0 THEN DO:
        x-conreg = x-conreg + 1.
        FIND FIRST tmp-bole WHERE
            tmp-bole.t-nomper = x-nomper AND
            tmp-bole.t-linea  = x-conreg NO-ERROR.
        IF NOT AVAILABLE tmp-bole THEN DO:
            CREATE tmp-bole.
            ASSIGN
                t-codper = PL-FLG-SEM.codper
                t-nomper = x-nomper
                t-linea  = x-conreg.
        END.
        ASSIGN t-egreso = STRING(PL-MOV-SEM.CodMov, "999") + " ".
        FIND PL-CONC WHERE PL-CONC.CodMov = PL-MOV-SEM.CodMov NO-LOCK NO-ERROR.
        IF AVAILABLE PL-CONC THEN
            ASSIGN t-egreso = t-egreso + STRING(PL-CONC.DesMov, "x(20)") + " ".
        ELSE ASSIGN t-egreso = t-egreso + FILL(" ", 21).
        /* Para buscar referencia */
        IF PL-BOLE.CodRef <> 0 THEN DO:
            FIND b-PL-MOV-SEM WHERE
                b-PL-MOV-SEM.CodCia  = s-CodCia AND
                b-PL-MOV-SEM.Periodo = s-Periodo AND
                b-PL-MOV-SEM.NroSem  = FILL-IN-NRO-SEM AND
                b-PL-MOV-SEM.CodPln  = PL-PLAN.CodPln AND
                b-PL-MOV-SEM.CodCal  = PL-BOLE.CodCal-Ref AND
                b-PL-MOV-SEM.CodPer  = PL-FLG-SEM.CodPer AND
                b-PL-MOV-SEM.CodMov  = PL-BOLE.CodRef NO-LOCK NO-ERROR.
            IF AVAILABLE b-PL-MOV-SEM THEN
                ASSIGN
                    t-egreso = t-egreso +
                    STRING(b-PL-MOV-SEM.ValCal-Sem, "ZZZ,ZZ9.99") + " ".
            ELSE ASSIGN t-egreso = t-egreso + "           ".
        END.
        ELSE ASSIGN t-egreso = t-egreso + "           ".
        ASSIGN
            t-egreso  = t-egreso + STRING(PL-MOV-SEM.ValCal-Sem, "ZZZ,ZZZ,ZZ9.99")
            x-valcalE = x-valcalE + PL-MOV-SEM.ValCal-Sem.
        RUN acumula_conceptos("egreso"). /* Para acumulados de conceptos */
    END.
END.

/* Para aportaciones */
ASSIGN x-conreg = 5.
FIND FIRST tmp-bole WHERE
    tmp-bole.t-nomper = x-nomper AND
    tmp-bole.t-linea  = x-conreg NO-ERROR.
IF NOT AVAILABLE tmp-bole THEN DO:
    CREATE tmp-bole.
    ASSIGN
        t-codper = PL-FLG-SEM.codper
        t-nomper = x-nomper
        t-linea  = x-conreg.
END.

t-aporte = " A P O R T A C I O N E S".

FOR EACH PL-BOLE NO-LOCK WHERE
    PL-BOLE.CodPln = PL-PLAN.CodPln AND
    PL-BOLE.CodCal = PL-CALC.CodCal AND
    PL-BOLE.TpoBol = "Aportes" BY PL-BOLE.nroitm:
    FIND PL-MOV-SEM WHERE
        PL-MOV-SEM.CodCia  = s-CodCia AND
        PL-MOV-SEM.Periodo = s-Periodo AND
        PL-MOV-SEM.NroSem  = FILL-IN-NRO-SEM AND
        PL-MOV-SEM.CodPln  = PL-PLAN.CodPln AND
        PL-MOV-SEM.CodCal  = PL-BOLE.CodCal AND
        PL-MOV-SEM.CodPer  = PL-FLG-SEM.CodPer AND
        PL-MOV-SEM.CodMov  = PL-BOLE.CodMov NO-LOCK NO-ERROR.
    IF AVAILABLE PL-MOV-SEM AND PL-MOV-SEM.ValCal-Sem <> 0 THEN DO:
        x-conreg = x-conreg + 1.
        FIND FIRST tmp-bole WHERE
            tmp-bole.t-nomper = x-nomper AND
            tmp-bole.t-linea  = x-conreg NO-ERROR.
        IF NOT AVAILABLE tmp-bole THEN DO:
            CREATE tmp-bole.
            ASSIGN
                t-codper = PL-FLG-SEM.codper
                t-nomper = x-nomper
                t-linea  = x-conreg.
        END.
        t-aporte = STRING(PL-MOV-SEM.CodMov, "999") + " ".
        ASSIGN t-aporte = STRING(PL-MOV-SEM.CodMov, "999") + " ".
        FIND PL-CONC WHERE PL-CONC.CodMov = PL-MOV-SEM.CodMov NO-LOCK NO-ERROR.
        IF AVAILABLE PL-CONC THEN
            ASSIGN t-aporte = t-aporte + STRING(PL-CONC.DesMov, "x(20)") + " ".
        ELSE ASSIGN t-aporte = t-aporte + FILL(" ", 21).
        ASSIGN
            t-aporte = t-aporte + STRING(PL-MOV-SEM.valcal-sem, "ZZZ,ZZ9.99")
            x-valcalA = x-valcalA + PL-MOV-SEM.ValCal-Sem.
        RUN acumula_conceptos("aporte"). /* Para acumulados de conceptos */
    END.
END.

FIND LAST tmp-bole WHERE tmp-bole.t-nomper = x-nomper NO-ERROR.
ASSIGN x-conreg = t-linea + 1.

CREATE tmp-bole.
ASSIGN
    t-nomper = x-nomper
    t-codper = PL-FLG-SEM.codper
    t-linea  = x-conreg
    t-ingreso = "NETO PAGAR ==> " + STRING(x-valcalI - x-valcalE, "ZZZ,ZZ9.99") +
        "    TOTAL HAB. " + STRING(x-valcalI, "ZZZ,ZZ9.99")
    t-egreso = FILL(" ",23) + "TOTAL DESCUENTOS " + STRING(x-valcalE, "ZZZ,ZZ9.99")
    t-aporte = "      " + "TOTAL APORTACIONES " + STRING(x-valcalA, "ZZZ,ZZ9.99").

RUN distribuye-mon(
    INTEGER(ABS(x-valcalI - x-valcalE)),
    OUTPUT x-dis-mon[1],
    OUTPUT x-dis-mon[2],
    OUTPUT x-dis-mon[3],
    OUTPUT x-dis-mon[4],
    OUTPUT x-dis-mon[5]
    ).
    
ASSIGN
    x-acu-mon[1] = x-acu-mon[1] + x-dis-mon[1]
    x-acu-mon[2] = x-acu-mon[2] + x-dis-mon[2]
    x-acu-mon[3] = x-acu-mon[3] + x-dis-mon[3]
    x-acu-mon[4] = x-acu-mon[4] + x-dis-mon[4]
    x-acu-mon[5] = x-acu-mon[5] + x-dis-mon[5].

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE distribuye-mon B-table-Win 
PROCEDURE distribuye-mon :
/*------------------------------------------------------------------------------
    Distribuci¢n de monedas.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER x-total   AS INTEGER.
DEFINE OUTPUT PARAMETER x-moneda1 AS INTEGER. /* Monedas de 1 Sol */
DEFINE OUTPUT PARAMETER x-moneda2 AS INTEGER. /* Monedas de 5 Soles */
DEFINE OUTPUT PARAMETER x-moneda3 AS INTEGER. /* Billetes de 10 Soles */
DEFINE OUTPUT PARAMETER x-moneda4 AS INTEGER. /* Billetes de 50 Soles */
DEFINE OUTPUT PARAMETER x-moneda5 AS INTEGER. /* Billetes de 100 Soles */

CASE LENGTH(STRING(x-total)):
WHEN 1 THEN
    ASSIGN x-moneda1 = x-total.
WHEN 2 THEN
    ASSIGN
        x-moneda3 = TRUNCATE(x-total / 10,0) 
        x-moneda1 = x-total MODULO 10.
WHEN 3 OR WHEN 4 OR WHEN 5 THEN
    ASSIGN
        x-moneda5 = TRUNCATE(x-total / 100,0)
        x-moneda1 = x-total MODULO 100
        x-moneda3 = TRUNCATE(x-moneda1 / 10,0)
        x-moneda1 = x-moneda1 MODULO 10.
END CASE.

IF x-moneda1 >= 5 THEN
    ASSIGN
        x-moneda2 = 1
        x-moneda1 = x-moneda1 - 5.
        
IF x-moneda3 >= 5 THEN
    ASSIGN
        x-moneda4 = 1
        x-moneda3 = x-moneda3 - 5.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imp_boleta B-table-Win 
PROCEDURE imp_boleta :
/*------------------------------------------------------------------------------
    Impresi¢n de consistencia de boleta de pago.
------------------------------------------------------------------------------*/

IF NOT CAN-FIND(FIRST PL-MOV-SEM WHERE /* Si no se efectu¢ ning£n c lculo */
    PL-MOV-SEM.CodCia  = s-CodCia AND
    PL-MOV-SEM.Periodo = s-Periodo AND
    PL-MOV-SEM.NroSem  = FILL-IN-NRO-SEM AND
    PL-MOV-SEM.CodPln  = PL-PLAN.CodPln AND
    PL-MOV-SEM.CodCal  = PL-CALC.CodCal) THEN DO:
    BELL.
    MESSAGE "No se efectu¢ ning£n c lculo" VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

DEFINE VARIABLE x-pagina  AS INTEGER FORMAT "ZZZ9" NO-UNDO.
DEFINE VARIABLE x-titulo  AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE p-archivo AS CHARACTER NO-UNDO.

FIND PF-CIAS WHERE PF-CIAS.CodCia = s-CodCia NO-LOCK.

CASE PL-CALC.CodCal:
WHEN 3 THEN ASSIGN x-titulo = "  VACACIONES".
WHEN 4 THEN ASSIGN x-titulo = "GRATIFICACIONES".
END CASE.

FIND PL-SEM WHERE
    PL-SEM.CodCia  = s-CodCia AND
    PL-SEM.Periodo = s-Periodo AND
    PL-SEM.NroSem  = FILL-IN-NRO-SEM NO-LOCK NO-ERROR.

DEFINE FRAME f-cab
    t-ingreso
    t-egreso
    t-aporte
    HEADER
    PF-CIAS.NomCia x-titulo AT 63 "FECHA :" TO 130 TODAY TO 140 SKIP
    "OFICINA DE RELACIONES LABORALES"
    "PLANILLA OBREROS - SEMANA #" TO 77 FILL-IN-NRO-SEM FORMAT "99"
    "-" YEAR(PL-SEM.FecFin) FORMAT "9,999"
    "P gina :" TO 130 x-pagina TO 140
    SKIP(1)
    WITH DOWN NO-BOX STREAM-IO WIDTH 150 NO-LABEL NO-UNDERLINE.

DEFINE FRAME f-cab2
    tmp-bole.t-ingreso FORMAT "x(45)" SPACE(2)
    tmp-bole.t-egreso FORMAT "x(45)" SPACE(2)
    tmp-bole.t-aporte FORMAT "x(45)"
    HEADER
    PF-CIAS.NomCia x-titulo AT 63 "FECHA :" TO 130 TODAY TO 140 SKIP
    "OFICINA DE RELACIONES LABORALES"
    "RESUMEN DE PLANILLA OBREROS - SEMANA #" TO 82 FILL-IN-NRO-SEM FORMAT "99"
    "-" YEAR(PL-SEM.FecFin) FORMAT "9,999"
    "P gina :" TO 130 x-pagina TO 140
    SKIP(1)
    WITH DOWN NO-BOX STREAM-IO WIDTH 140 NO-LABEL NO-UNDERLINE.

ASSIGN
    x-acu-mon[1] = 0
    x-acu-mon[2] = 0
    x-acu-mon[3] = 0
    x-acu-mon[4] = 0
    x-acu-mon[5] = 0.

CASE R-seleccion:
WHEN 1 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL IN FRAME F-Msg = "Secci¢n".
    FOR EACH PL-FLG-SEM WHERE
        PL-FLG-SEM.CodCia  = s-CodCia AND
        PL-FLG-SEM.Periodo = s-Periodo AND
        PL-FLG-SEM.NroSem  = FILL-IN-NRO-SEM AND
        PL-FLG-SEM.CodPln  = PL-PLAN.CodPln NO-LOCK:
        IF PL-FLG-SEM.SitAct = "Inactivo" THEN NEXT.
        DISPLAY PL-FLG-SEM.seccion @ FILL-IN-Seccion WITH FRAME F-Msg.
        RUN busca_datos.
    END.
END.
WHEN 2 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL = "Secci¢n".
    DO i = 1 TO br_pl-flg-s:NUM-SELECTED-ROWS IN FRAME F-Main:
        ASSIGN stat-reg  = br_pl-flg-s:FETCH-SELECTED-ROW(i).
        RUN busca_datos.
    END.
    ASSIGN stat-reg = br_pl-flg-s:DESELECT-ROWS().
END.
WHEN 3 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL = "Secci¢n".
    DISPLAY COMBO-S @ FILL-IN-Seccion WITH FRAME F-Msg.
    FOR EACH PL-FLG-SEM NO-LOCK WHERE
        PL-FLG-SEM.CodCia  = s-CodCia AND
        PL-FLG-SEM.Periodo = s-Periodo AND
        PL-FLG-SEM.NroSem  = FILL-IN-NRO-SEM AND
        PL-FLG-SEM.CodPln  = PL-PLAN.CodPln AND
        PL-FLG-SEM.Seccion = COMBO-S:
        IF PL-FLG-SEM.SitAct = "Inactivo" THEN NEXT.
        RUN busca_datos.
    END.
END.
WHEN 4 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL = "Proyecto".
    DISPLAY COMBO-S @ FILL-IN-Seccion WITH FRAME F-Msg.
    FOR EACH PL-FLG-SEM NO-LOCK WHERE
        PL-FLG-SEM.CodCia   = s-CodCia AND
        PL-FLG-SEM.Periodo  = s-Periodo AND
        PL-FLG-SEM.NroSem   = FILL-IN-NRO-SEM AND
        PL-FLG-SEM.CodPln   = PL-PLAN.CodPln AND
        PL-FLG-SEM.Proyecto = COMBO-S:
        IF PL-FLG-SEM.SitAct = "Inactivo" THEN NEXT.
        RUN busca_datos.
    END.
END.

END CASE.

HIDE FRAME F-Msg.

IF NOT CAN-FIND(FIRST tmp-bole) THEN RETURN.

IF INPUT TGL-pantalla = TRUE THEN DO:
    P-archivo = SESSION:TEMP-DIRECTORY +
          STRING(NEXT-VALUE(sec-arc,integral),"99999999") + ".scr".
    OUTPUT STREAM strm-boleta TO VALUE ( P-archivo ) PAGED PAGE-SIZE 66.
END.
ELSE DO:
    OUTPUT STREAM strm-boleta TO PRINTER PAGED PAGE-SIZE 66.
    /* Seteo de impresi¢n (Impresora EPSON) */
    PUT STREAM strm-boleta CONTROL "~033@~0335~033F~033P~033x~001~033C" CHR(66).
    PUT STREAM strm-boleta CONTROL "~033x" NULL "~017~033P".
END.

ASSIGN
    x-conreg = 1
    x-pagina = 1.

IF x-resumido = FALSE THEN DO:
    FOR EACH tmp-bole NO-LOCK BREAK
        BY tmp-bole.t-NomPer
        BY tmp-bole.t-CodPer
        BY tmp-bole.t-Linea :
        DISPLAY STREAM strm-boleta 
            tmp-bole.t-ingreso
            tmp-bole.t-egreso
            tmp-bole.t-aporte
            WITH FRAME f-cab.
        IF LINE-COUNTER( strm-boleta ) > 62 THEN DO:
            x-pagina = x-pagina + 1.
            PAGE STREAM strm-boleta.
        END.
        ELSE
            IF LAST-OF(tmp-bole.t-NomPer) THEN DO:
                PUT STREAM strm-boleta FILL("-", 140) FORMAT "x(140)" SKIP.
            END.
    END.

    PAGE STREAM strm-boleta.

    PUT STREAM strm-boleta "" SKIP(6).
END.

ASSIGN
    x-conreg  = 1
    x-valcalI = 0
    x-valcalE = 0
    x-valcalA = 0
    x-pagina  = x-pagina + 1.

CREATE tmp-bole.
ASSIGN
    tmp-bole.t-CodPer  = "9ZZZ"
    tmp-bole.t-NomPer  = FILL("Z", 60)
    tmp-bole.t-linea   = x-conreg
    tmp-bole.t-ingreso = " H A B E R E S "
    tmp-bole.t-egreso  = " D E S C U E N T O S "
    tmp-bole.t-aporte  = " A P O R T E S ".

FOR EACH tmp-conc WHERE t-TipMov = "ingreso":
    CREATE tmp-bole.
    ASSIGN
        x-conreg           = x-conreg + 1
        tmp-bole.t-CodPer  = "9ZZZ"
        tmp-bole.t-linea   = x-conreg
        tmp-bole.t-NomPer  = FILL("Z", 60)
        tmp-bole.t-ingreso = STRING(t-CodMov, "999") + " ".
    FIND PL-CONC WHERE PL-CONC.CodMov = tmp-conc.t-CodMov NO-LOCK NO-ERROR.
    IF AVAILABLE PL-CONC THEN
        ASSIGN t-ingreso = t-ingreso + STRING(PL-CONC.DesMov, "x(28)") + " ".
    ELSE ASSIGN t-ingreso = FILL(" ", 29).
    ASSIGN
        t-ingreso = t-ingreso + STRING(t-accum, "Z,ZZZ,ZZ9.99")
        x-valcalI = x-valcalI + t-accum.
END.

ASSIGN x-conreg = 2.

FOR EACH tmp-conc WHERE t-TipMov = "egreso":
    FIND FIRST tmp-bole WHERE
        tmp-bole.t-NomPer = FILL("Z", 60) AND
        tmp-bole.t-linea  = x-conreg NO-ERROR.
    IF NOT AVAILABLE tmp-bole THEN DO:
        CREATE tmp-bole.
        ASSIGN
            tmp-bole.t-NomPer = FILL("Z", 60)
            tmp-bole.t-CodPer = "9ZZZ"
            tmp-bole.t-linea  = x-conreg.
    END.
    ASSIGN tmp-bole.t-egreso = STRING(t-CodMov, "999") + " ".
    FIND PL-CONC WHERE PL-CONC.CodMov = tmp-conc.t-CodMov NO-LOCK NO-ERROR.
    IF AVAILABLE PL-CONC THEN
        ASSIGN t-egreso = t-egreso + STRING(PL-CONC.DesMov, "x(28)") + " ".
    ELSE ASSIGN t-egreso = FILL(" ", 29).
    ASSIGN
        t-egreso  = t-egreso + STRING(t-accum, "Z,ZZZ,ZZ9.99")
        x-valcalE = x-valcalE + t-accum
        x-conreg  = x-conreg + 1.
END.

ASSIGN x-conreg = 2.

FOR EACH tmp-conc WHERE t-TipMov = "aporte":
    FIND FIRST tmp-bole WHERE
        tmp-bole.t-NomPer = FILL("Z", 60) AND
        tmp-bole.t-CodPer = "9ZZZ" AND
        tmp-bole.t-linea  = x-conreg NO-ERROR.
    IF NOT AVAILABLE tmp-bole THEN DO:
        CREATE tmp-bole.
        ASSIGN
            tmp-bole.t-NomPer = FILL("Z", 60)
            tmp-bole.t-CodPer = "9ZZZ"
            tmp-bole.t-linea  = x-conreg.
    END.
    ASSIGN
        tmp-bole.t-aporte = STRING(t-CodMov, "999") + " ".
    FIND PL-CONC WHERE PL-CONC.CodMov = tmp-conc.t-CodMov NO-LOCK NO-ERROR.
    IF AVAILABLE PL-CONC THEN
        ASSIGN t-aporte = t-aporte + STRING(PL-CONC.DesMov, "x(28)") + " ".
    ELSE ASSIGN t-aporte = FILL(" ", 29).
    ASSIGN
        t-aporte  = t-aporte + STRING(t-accum, "Z,ZZZ,ZZ9.99")
        x-valcalA = x-valcalA + t-accum
        x-conreg  = x-conreg + 1.
END.

FIND LAST tmp-bole WHERE tmp-bole.t-NomPer = FILL("Z", 60) NO-ERROR.
ASSIGN x-conreg = t-linea + 1.

CREATE tmp-bole.
ASSIGN
    t-NomPer  = FILL("Z", 60)
    t-codPer  = "9ZZZ"
    t-linea   = x-conreg
    t-ingreso = FILL(" ", 33) + "------------"
    t-egreso  = FILL(" ", 33) + "------------"
    t-aporte  = FILL(" ", 33) + "------------"
    x-conreg  = x-conreg + 1.

CREATE tmp-bole.
ASSIGN
    t-codPer  = "9ZZZ"
    t-NomPer  = FILL("Z", 60)
    t-linea   = x-conreg
    t-ingreso = FILL(" ", 15) + "TOTAL HABERES ==> " + STRING(x-valcalI, "Z,ZZZ,ZZ9.99")
    t-egreso  = FILL(" ", 12) + "TOTAL DESCUENTOS ==> " + STRING(x-valcalE, "Z,ZZZ,ZZ9.99")
    t-aporte  = FILL(" ", 10) + "TOTAL APORTACIONES ==> " + STRING(x-valcalA, "Z,ZZZ,ZZ9.99")
    x-conreg  = x-conreg + 1.

CREATE tmp-bole.
ASSIGN
    t-codPer  = "9ZZZ"
    t-NomPer  = FILL("Z", 60)
    t-linea   = x-conreg
    x-conreg  = x-conreg + 1.

CREATE tmp-bole.
ASSIGN
    t-codPer  = "9ZZZ"
    t-NomPer  = FILL("Z", 60)
    t-linea   = x-conreg
    t-ingreso = "NETO A PAGAR ==> " + STRING(x-valcalI - x-valcalE, "Z,ZZZ,ZZ9.99")
    x-conreg  = x-conreg + 1.

CREATE tmp-bole.
ASSIGN
    t-codPer  = "9ZZZ"
    t-NomPer  = FILL("Z", 60)
    t-linea   = x-conreg
    t-ingreso = "=============================".

FOR EACH tmp-bole NO-LOCK WHERE t-NomPer = FILL("Z", 60) BY t-Linea :
    DISPLAY STREAM strm-boleta
        tmp-bole.t-ingreso
        tmp-bole.t-egreso
        tmp-bole.t-aporte
        WITH FRAME f-cab2.
END.

PUT STREAM strm-boleta "" SKIP.

PUT STREAM strm-boleta "DISTRIBUCION GENERAL DE MONEDAS" SKIP.
PUT STREAM strm-boleta "-------------------------------" SKIP.
PUT STREAM strm-boleta "Monedas de 1 Sol      : " x-acu-mon[1] FORMAT "ZZ,ZZ9" SKIP.
PUT STREAM strm-boleta "Monedas de 5 Soles    : " x-acu-mon[2] FORMAT "ZZ,ZZ9" SKIP.
PUT STREAM strm-boleta "Billetes de 10 Soles  : " x-acu-mon[3] FORMAT "ZZ,ZZ9" SKIP.
PUT STREAM strm-boleta "Billetes de 50 Soles  : " x-acu-mon[4] FORMAT "ZZ,ZZ9" SKIP.
PUT STREAM strm-boleta "Billetes de 100 Soles : " x-acu-mon[5] FORMAT "ZZ,ZZ9" SKIP.

OUTPUT STREAM strm-boleta CLOSE.

FOR EACH tmp-bole:
    DELETE tmp-bole.
END.

FOR EACH tmp-conc:
    DELETE tmp-conc.
END.

IF INPUT TGL-pantalla = TRUE THEN DO:
    RUN bin/_vcat.p ( P-archivo ). 
    OS-DELETE VALUE ( P-archivo ). 
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    DISPLAY FILL-IN-NRO-SEM WITH FRAME F-Main.

    APPLY "VALUE-CHANGED" TO R-seleccion IN FRAME F-Main.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "integral.PL-PLAN"}
  {src/adm/template/snd-list.i "integral.PL-CALC"}
  {src/adm/template/snd-list.i "integral.PL-FLG-SEM"}
  {src/adm/template/snd-list.i "integral.PL-PERS"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


