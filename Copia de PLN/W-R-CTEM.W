&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
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

DEFINE VARIABLE ok-state AS LOGICAL.
DEFINE VARIABLE x-nombre AS CHARACTER.
DEFINE VARIABLE x-mes    AS CHARACTER.
DEFINE VARIABLE x-pagina AS CHARACTER.

{bin/s-global.i}
{pln/s-global.i}

DEFINE STREAM str-report.

DEFINE FRAME f-cab
    PL-CFG-CTE-MES.CodPer
    x-nombre                   COLUMN-LABEL "Apellidos y Nombres" FORMAT "x(40)"
    PL-CFG-CTE-MES.Nro-Cte-Mes COLUMN-LABEL "# Pr‚stamo"
    PL-CFG-CTE-MES.Fch-Cte-Mes COLUMN-LABEL "Fecha Efec."
    PL-CFG-CTE-MES.Imp-Cte-Mes COLUMN-LABEL "Importe" FORMAT "Z,ZZZ,ZZ9.99"
    PL-CFG-CTE-MES.Fch-Prx-Pgo-Mes COLUMN-LABEL "Pr¢ximo Pago"
    PL-CFG-CTE-MES.Cuo-Cte-Mes COLUMN-LABEL "Cuota" FORMAT "Z,ZZZ,ZZ9.99"
    PL-CFG-CTE-MES.Sdo-Cte-Mes COLUMN-LABEL "Saldo" FORMAT "Z,ZZZ,ZZ9.99"
    HEADER
    s-NomCia "FECHA :" TO 130 TODAY TO 140 SKIP
    x-mes FORMAT "x(25)" "ESTADO DE CUENTA CORRIENTE" AT 57
    "P gina : " TO 130 PAGE-NUMBER(str-report) TO 140
    SKIP(1)
    WITH DOWN NO-BOX STREAM-IO WIDTH 250.

ok-state = SESSION:SET-WAIT-STATE("").

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME Brw-soles

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES integral.PL-CFG-CTE-MES integral.PL-PERS

/* Definitions for BROWSE Brw-soles                                     */
&Scoped-define FIELDS-IN-QUERY-Brw-soles integral.PL-CFG-CTE-MES.CodPer ~
integral.PL-PERS.patper + " " + integral.PL-PERS.matper + ", " + integral.PL-PERS.nomper ~
integral.PL-CFG-CTE-MES.Nro-Cte-Mes integral.PL-CFG-CTE-MES.Fch-Cte-Mes ~
integral.PL-CFG-CTE-MES.Imp-Cte-Mes integral.PL-CFG-CTE-MES.Fch-Prx-Pgo-Mes ~
integral.PL-CFG-CTE-MES.Cuo-Cte-Mes integral.PL-CFG-CTE-MES.Sdo-Cte-Mes 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Brw-soles 
&Scoped-define FIELD-PAIRS-IN-QUERY-Brw-soles
&Scoped-define OPEN-QUERY-Brw-soles OPEN QUERY Brw-soles FOR EACH integral.PL-CFG-CTE-MES ~
      WHERE PL-CFG-CTE-MES.CodCia = s-codcia ~
 AND PL-CFG-CTE-MES.Periodo = s-periodo ~
 AND PL-CFG-CTE-MES.NroMes = FILL-IN-nromes ~
 AND PL-CFG-CTE-MES.Clf-Cte-Mes = 1 ~
 AND PL-CFG-CTE-MES.Tpo-Cte-Mes = FILL-IN-tpo NO-LOCK, ~
      EACH integral.PL-PERS OF integral.PL-CFG-CTE-MES NO-LOCK ~
    BY integral.PL-PERS.patper ~
       BY integral.PL-PERS.matper ~
        BY integral.PL-PERS.nomper.
&Scoped-define TABLES-IN-QUERY-Brw-soles integral.PL-CFG-CTE-MES ~
integral.PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-Brw-soles integral.PL-CFG-CTE-MES


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-Brw-soles}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-25 RECT-24 Brw-soles FILL-IN-NROMES ~
R-sele Btn-UP Btn-DOWN FILL-IN-tpo Btn-UP-2 Btn-DOWN-2 TGL-movs ~
TGL-pantalla B-imprimir R-moneda B-salir 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NROMES R-sele FILL-IN-tpo ~
FILL-IN-destpo TGL-movs TGL-pantalla R-moneda 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-imprimir 
     LABEL "&Imprimir" 
     SIZE 10 BY .85.

DEFINE BUTTON B-salir 
     LABEL "&Salir" 
     SIZE 10 BY .85.

DEFINE BUTTON Btn-DOWN 
     IMAGE-UP FILE "img/btn-down":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-DOWN-2 
     IMAGE-UP FILE "img/btn-down":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-UP 
     IMAGE-UP FILE "img/btn-up":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-UP-2 
     IMAGE-UP FILE "img/btn-up":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE VARIABLE FILL-IN-destpo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26.14 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-NROMES AS INTEGER FORMAT "Z9":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-tpo AS INTEGER FORMAT "Z9":U INITIAL 0 
     LABEL "Tipo" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE R-moneda AS LOGICAL 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles", yes,
"D¢lares", no
     SIZE 9.72 BY 1.31 NO-UNDO.

DEFINE VARIABLE R-sele AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todos", 1,
"Seleccionados", 2
     SIZE 13.86 BY 1.69 NO-UNDO.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77.14 BY 9.46.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77.14 BY 2.5.

DEFINE VARIABLE TGL-movs AS LOGICAL INITIAL no 
     LABEL "Listar Movimientos" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.72 BY .77 NO-UNDO.

DEFINE VARIABLE TGL-pantalla AS LOGICAL INITIAL no 
     LABEL "Salida a Pantalla" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.72 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Brw-soles FOR 
      integral.PL-CFG-CTE-MES, 
      integral.PL-PERS SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE Brw-soles
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS Brw-soles W-Win _STRUCTURED
  QUERY Brw-soles NO-LOCK DISPLAY
      integral.PL-CFG-CTE-MES.CodPer
      integral.PL-PERS.patper + " " + integral.PL-PERS.matper + ", " + integral.PL-PERS.nomper COLUMN-LABEL "Apellidos y Nombres" FORMAT "x(45)"
      integral.PL-CFG-CTE-MES.Nro-Cte-Mes COLUMN-LABEL "# Pr‚stamo"
      integral.PL-CFG-CTE-MES.Fch-Cte-Mes COLUMN-LABEL "Fecha Efect."
      integral.PL-CFG-CTE-MES.Imp-Cte-Mes
      integral.PL-CFG-CTE-MES.Fch-Prx-Pgo-Mes COLUMN-LABEL "Pr¢ximo Pago"
      integral.PL-CFG-CTE-MES.Cuo-Cte-Mes
      integral.PL-CFG-CTE-MES.Sdo-Cte-Mes
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 74.72 BY 7.38
         BGCOLOR 15 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Brw-soles AT ROW 2.96 COL 2.86
     FILL-IN-NROMES AT ROW 1.73 COL 7.86 COLON-ALIGNED
     R-sele AT ROW 11.31 COL 9.14 NO-LABEL
     Btn-UP AT ROW 1.5 COL 13.86
     Btn-DOWN AT ROW 2.12 COL 13.86
     FILL-IN-tpo AT ROW 1.73 COL 21.14 COLON-ALIGNED
     Btn-UP-2 AT ROW 1.5 COL 27.14
     FILL-IN-destpo AT ROW 1.73 COL 28.43 COLON-ALIGNED NO-LABEL
     Btn-DOWN-2 AT ROW 2.12 COL 27.14
     TGL-movs AT ROW 11.31 COL 27.43
     TGL-pantalla AT ROW 11.31 COL 51
     B-imprimir AT ROW 12.27 COL 57
     R-moneda AT ROW 1.42 COL 67.14 NO-LABEL
     B-salir AT ROW 12.23 COL 67.72
     " Impresi¢n" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 10.69 COL 3.72
     "Moneda:" VIEW-AS TEXT
          SIZE 6.29 BY .5 AT ROW 1.42 COL 60.29
     RECT-25 AT ROW 10.85 COL 1.57
     RECT-24 AT ROW 1.15 COL 1.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 77.86 BY 12.42
         BGCOLOR 8 FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 2
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta/Impresi¢n de Estados de Cuenta Corriente"
         HEIGHT             = 12.54
         WIDTH              = 78.29
         MAX-HEIGHT         = 12.54
         MAX-WIDTH          = 78.29
         VIRTUAL-HEIGHT     = 12.54
         VIRTUAL-WIDTH      = 78.29
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
/* BROWSE-TAB Brw-soles RECT-24 F-Main */
ASSIGN 
       Brw-soles:NUM-LOCKED-COLUMNS IN FRAME F-Main = 2.

/* SETTINGS FOR FILL-IN FILL-IN-destpo IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE Brw-soles
/* Query rebuild information for BROWSE Brw-soles
     _TblList          = "integral.PL-CFG-CTE-MES,integral.PL-PERS OF integral.PL-CFG-CTE-MES"
     _Options          = "NO-LOCK"
     _OrdList          = "integral.PL-PERS.patper|yes,integral.PL-PERS.matper|yes,integral.PL-PERS.nomper|yes"
     _Where[1]         = "PL-CFG-CTE-MES.CodCia = s-codcia
 AND PL-CFG-CTE-MES.Periodo = s-periodo
 AND PL-CFG-CTE-MES.NroMes = FILL-IN-nromes
 AND PL-CFG-CTE-MES.Clf-Cte-Mes = 1
 AND PL-CFG-CTE-MES.Tpo-Cte-Mes = FILL-IN-tpo"
     _FldNameList[1]   = integral.PL-CFG-CTE-MES.CodPer
     _FldNameList[2]   > "_<CALC>"
"integral.PL-PERS.patper + "" "" + integral.PL-PERS.matper + "", "" + integral.PL-PERS.nomper" "Apellidos y Nombres" "x(45)" ? ? ? ? ? ? ? no ?
     _FldNameList[3]   > integral.PL-CFG-CTE-MES.Nro-Cte-Mes
"PL-CFG-CTE-MES.Nro-Cte-Mes" "# Pr‚stamo" ? "integer" ? ? ? ? ? ? no ?
     _FldNameList[4]   > integral.PL-CFG-CTE-MES.Fch-Cte-Mes
"PL-CFG-CTE-MES.Fch-Cte-Mes" "Fecha Efect." ? "date" ? ? ? ? ? ? no ?
     _FldNameList[5]   = integral.PL-CFG-CTE-MES.Imp-Cte-Mes
     _FldNameList[6]   > integral.PL-CFG-CTE-MES.Fch-Prx-Pgo-Mes
"PL-CFG-CTE-MES.Fch-Prx-Pgo-Mes" "Pr¢ximo Pago" ? "date" ? ? ? ? ? ? no ?
     _FldNameList[7]   = integral.PL-CFG-CTE-MES.Cuo-Cte-Mes
     _FldNameList[8]   = integral.PL-CFG-CTE-MES.Sdo-Cte-Mes
     _Query            is OPENED
*/  /* BROWSE Brw-soles */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Consulta/Impresi¢n de Estados de Cuenta Corriente */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Consulta/Impresi¢n de Estados de Cuenta Corriente */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-imprimir W-Win
ON CHOOSE OF B-imprimir IN FRAME F-Main /* Imprimir */
DO:
    ASSIGN
        FRAME {&FRAME-NAME}
        FILL-IN-NROMES
        FILL-IN-tpo
        R-sele
        TGL-movs
        TGL-pantalla.
    RUN imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-salir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-salir W-Win
ON CHOOSE OF B-salir IN FRAME F-Main /* Salir */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-DOWN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN W-Win
ON CHOOSE OF Btn-DOWN IN FRAME F-Main
DO:
    IF INPUT FRAME {&FRAME-NAME} FILL-IN-nromes - 1 >= 1 THEN DO:
        DISPLAY INPUT FILL-IN-nromes - 1 @ FILL-IN-nromes WITH FRAME F-Main.
        ASSIGN FILL-IN-nromes.
        {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-DOWN-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN-2 W-Win
ON CHOOSE OF Btn-DOWN-2 IN FRAME F-Main
DO:
    IF AVAILABLE PL-CORR-CTE-MES THEN DO:
        FIND PREV PL-CORR-CTE-MES WHERE
            PL-CORR-CTE-MES.CodCia = s-codcia AND
            PL-CORR-CTE-MES.Periodo = s-periodo AND
            PL-CORR-CTE-MES.Clf-Cte-Mes = 1 NO-LOCK NO-ERROR.
        IF AVAILABLE PL-CORR-CTE-MES THEN DO:
            FILL-IN-destpo = PL-CORR-CTE-MES.Des-Cte-Mes.
            FILL-IN-tpo    = PL-CORR-CTE-MES.Tpo-Cte-Mes.
        END.
    END.
    IF NOT AVAILABLE PL-CORR-CTE-MES THEN DO:
        FIND FIRST PL-CORR-CTE-MES WHERE
            PL-CORR-CTE-MES.CodCia = s-codcia AND
            PL-CORR-CTE-MES.Periodo = s-periodo AND
            PL-CORR-CTE-MES.Clf-Cte-Mes = 1 NO-LOCK NO-ERROR.
        IF AVAILABLE PL-CORR-CTE-MES THEN DO:
            FILL-IN-destpo = PL-CORR-CTE-MES.Des-Cte-Mes.
            FILL-IN-tpo    = PL-CORR-CTE-MES.Tpo-Cte-Mes.
        END.
    END.
    DISPLAY FILL-IN-destpo FILL-IN-tpo WITH FRAME {&FRAME-NAME}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-UP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP W-Win
ON CHOOSE OF Btn-UP IN FRAME F-Main
DO:
    IF INPUT FRAME {&FRAME-NAME} FILL-IN-nromes + 1 <= 12 THEN DO:
        DISPLAY INPUT FILL-IN-nromes + 1 @ FILL-IN-nromes WITH FRAME F-Main.
        ASSIGN FILL-IN-nromes.
        {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-UP-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP-2 W-Win
ON CHOOSE OF Btn-UP-2 IN FRAME F-Main
DO:
    IF AVAILABLE PL-CORR-CTE-MES THEN DO:
        FIND NEXT PL-CORR-CTE-MES WHERE
            PL-CORR-CTE-MES.CodCia = s-codcia AND
            PL-CORR-CTE-MES.Periodo = s-periodo AND
            PL-CORR-CTE-MES.Clf-Cte-Mes = 1 NO-LOCK NO-ERROR.
        IF AVAILABLE PL-CORR-CTE-MES THEN DO:
            FILL-IN-destpo = PL-CORR-CTE-MES.Des-Cte-Mes.
            FILL-IN-tpo    = PL-CORR-CTE-MES.Tpo-Cte-Mes.
        END.
    END.
    IF NOT AVAILABLE PL-CORR-CTE-MES THEN DO:
        FIND FIRST PL-CORR-CTE-MES WHERE
            PL-CORR-CTE-MES.CodCia = s-codcia AND
            PL-CORR-CTE-MES.Periodo = s-periodo AND
            PL-CORR-CTE-MES.Clf-Cte-Mes = 1 NO-LOCK NO-ERROR.
        IF AVAILABLE PL-CORR-CTE-MES THEN DO:
            FILL-IN-destpo = PL-CORR-CTE-MES.Des-Cte-Mes.
            FILL-IN-tpo    = PL-CORR-CTE-MES.Tpo-Cte-Mes.
        END.
    END.
    DISPLAY FILL-IN-destpo FILL-IN-tpo WITH FRAME {&FRAME-NAME}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NROMES
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NROMES W-Win
ON LEAVE OF FILL-IN-NROMES IN FRAME F-Main /* Mes */
DO:
    IF INPUT FILL-IN-nromes > 12 OR INPUT FILL-IN-nromes = 0 THEN DO:
        BELL.
        MESSAGE "Rango de mes es de 1 a 12"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FILL-IN-nromes.
        RETURN NO-APPLY.
    END.
    IF INPUT FILL-IN-nromes = FILL-IN-nromes THEN RETURN.
    ASSIGN FILL-IN-nromes.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-tpo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-tpo W-Win
ON LEAVE OF FILL-IN-tpo IN FRAME F-Main /* Tipo */
DO:
    FIND PL-CORR-CTE-MES WHERE
        PL-CORR-CTE-MES.CodCia = s-codcia AND
        PL-CORR-CTE-MES.Periodo = s-periodo AND
        PL-CORR-CTE-MES.Clf-Cte-Mes = 1 AND
        PL-CORR-CTE-MES.Tpo-Cte-Mes = INPUT FRAME {&FRAME-NAME} FILL-IN-tpo
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PL-CORR-CTE-MES THEN DO:
        BELL.
        MESSAGE
            "Tipo de pr‚stamo no registrado"
            VIEW-AS ALERT-BOX ERROR.
        FILL-IN-destpo = "".
    END.
    ELSE FILL-IN-destpo = PL-CORR-CTE-MES.Des-Cte-Mes.
    DISPLAY FILL-IN-destpo WITH FRAME {&FRAME-NAME}.
    IF INPUT FILL-IN-tpo = FILL-IN-tpo THEN RETURN.
    ASSIGN FILL-IN-tpo.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME Brw-soles
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-NROMES R-sele FILL-IN-tpo FILL-IN-destpo TGL-movs TGL-pantalla 
          R-moneda 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-25 RECT-24 Brw-soles FILL-IN-NROMES R-sele Btn-UP Btn-DOWN 
         FILL-IN-tpo Btn-UP-2 Btn-DOWN-2 TGL-movs TGL-pantalla B-imprimir 
         R-moneda B-salir 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir W-Win 
PROCEDURE imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE p-archivo AS CHARACTER.
DEFINE VARIABLE i         AS INTEGER.

IF TGL-pantalla = TRUE THEN DO:
    P-archivo = SESSION:TEMP-DIRECTORY +
          STRING(NEXT-VALUE(sec-arc,integral),"99999999") + ".scr".
    OUTPUT STREAM str-report TO VALUE ( P-archivo ) PAGED PAGE-SIZE 66.
END.
ELSE DO:
    OUTPUT STREAM str-report TO PRINTER PAGED PAGE-SIZE 66.
    /* Seteo de impresi¢n (Impresora EPSON) */
    PUT STREAM str-report CONTROL "~033@~0335~033F~033P~033x~001~033C" CHR(66).
    PUT STREAM str-report CONTROL "~033x" NULL "~017~033P".
END.

RUN bin/_mes.r( FILL-IN-NROMES , 1 , OUTPUT x-mes ).
x-mes = "MES DE " + x-mes + " DE " + STRING(s-periodo,"9999").

CASE R-sele:
WHEN 1 THEN DO:
    GET FIRST Brw-soles.
    DO WHILE AVAILABLE(PL-CFG-CTE-MES):
        IF AVAILABLE PL-PERS THEN
            x-nombre = PL-PERS.patper + " " + PL-PERS.matper + ", " + PL-PERS.nomper.
        ELSE x-nombre = "".
        DISPLAY STREAM str-report
            PL-CFG-CTE-MES.CodPer
            x-nombre
            PL-CFG-CTE-MES.Nro-Cte-Mes
            PL-CFG-CTE-MES.Fch-Cte-Mes
            PL-CFG-CTE-MES.Imp-Cte-Mes
            PL-CFG-CTE-MES.Fch-Prx-Pgo-Mes
            PL-CFG-CTE-MES.Cuo-Cte-Mes
            PL-CFG-CTE-MES.Sdo-Cte-Mes
            WITH FRAME f-cab.
        DOWN STREAM str-report 1 WITH FRAME f-cab.
        IF LINE-COUNTER( str-report ) > 62 THEN PAGE STREAM str-report.
        IF TGL-movs THEN DO:
            DISPLAY STREAM str-report
                "MOVIMIENTOS" @ x-nombre
                WITH FRAME f-cab.
            DOWN STREAM str-report 1 WITH FRAME f-cab.
            IF LINE-COUNTER( str-report ) > 62 THEN PAGE STREAM str-report.
            FOR EACH PL-MOV-CTE-MES NO-LOCK WHERE
                PL-MOV-CTE-MES.CodCia = PL-CFG-CTE-MES.CodCia AND
                PL-MOV-CTE-MES.Clf-Cte-Mes = PL-CFG-CTE-MES.Clf-Cte-Mes AND
                PL-MOV-CTE-MES.Tpo-Cte-Mes = PL-CFG-CTE-MES.Tpo-Cte-Mes AND
                PL-MOV-CTE-MES.Nro-Cte-Mes = PL-CFG-CTE-MES.Nro-Cte-Mes AND
                PL-MOV-CTE-MES.CodPer = PL-CFG-CTE-MES.CodPer :
                DISPLAY STREAM str-report
                    "PERIODO " + STRING(PL-MOV-CTE-MES.Periodo,"9999") +
                    " MES " + STRING(PL-MOV-CTE-MES.NroMes,"99") @ x-nombre
                    "CALCULO " + STRING(PL-MOV-CTE-MES.CodCal,"99") @ PL-CFG-CTE-MES.Nro-Cte-Mes
                    PL-MOV-CTE-MES.CodPln @ PL-CFG-CTE-MES.Fch-Cte-Mes
                    PL-MOV-CTE-MES.Fch-Ult-Mov-Cte-Mes @ PL-CFG-CTE-MES.Imp-Cte-Mes
                    PL-MOV-CTE-MES.Hra-Ult-Mov-Cte-Mes @ PL-CFG-CTE-MES.Fch-Prx-Pgo-Mes
                    PL-MOV-CTE-MES.Val-Cte-Mes @ PL-CFG-CTE-MES.Cuo-Cte-Mes
                    WITH FRAME f-cab.
                DOWN STREAM str-report 1 WITH FRAME f-cab.
                IF LINE-COUNTER( str-report ) > 62 THEN PAGE STREAM str-report.
            END.
            IF LINE-COUNTER( str-report ) > 6 THEN
                PUT STREAM str-report FILL("-", 140) FORMAT "x(140)" SKIP.
        END.
        GET NEXT Brw-soles.
    END.
END.
WHEN 2 THEN DO:
    DO i = 1 TO Brw-soles:NUM-SELECTED-ROWS IN FRAME F-Main:
        ASSIGN ok-state = Brw-soles:FETCH-SELECTED-ROW(i).
        IF ok-state THEN DO:
            FIND PL-PERS WHERE PL-PERS.codper = PL-CFG-CTE-MES.codper
                NO-LOCK NO-ERROR.
            IF AVAILABLE PL-PERS THEN
                x-nombre = PL-PERS.patper + " " + PL-PERS.matper + ", " +
                PL-PERS.nomper.
            ELSE x-nombre = "".
            DISPLAY STREAM str-report
                PL-CFG-CTE-MES.CodPer
                x-nombre
                PL-CFG-CTE-MES.Nro-Cte-Mes
                PL-CFG-CTE-MES.Fch-Cte-Mes
                PL-CFG-CTE-MES.Imp-Cte-Mes
                PL-CFG-CTE-MES.Fch-Prx-Pgo-Mes
                PL-CFG-CTE-MES.Cuo-Cte-Mes
                PL-CFG-CTE-MES.Sdo-Cte-Mes
                WITH FRAME f-cab.
            DOWN STREAM str-report 1 WITH FRAME f-cab.
            IF LINE-COUNTER( str-report ) > 62 THEN PAGE STREAM str-report.
            IF TGL-movs THEN DO:
                DISPLAY STREAM str-report
                    "MOVIMIENTOS" @ x-nombre
                    WITH FRAME f-cab.
                DOWN STREAM str-report 1 WITH FRAME f-cab.
                IF LINE-COUNTER( str-report ) > 62 THEN PAGE STREAM str-report.
                FOR EACH PL-MOV-CTE-MES NO-LOCK WHERE
                    PL-MOV-CTE-MES.CodCia = PL-CFG-CTE-MES.CodCia AND
                    PL-MOV-CTE-MES.Clf-Cte-Mes = PL-CFG-CTE-MES.Clf-Cte-Mes AND
                    PL-MOV-CTE-MES.Tpo-Cte-Mes = PL-CFG-CTE-MES.Tpo-Cte-Mes AND
                    PL-MOV-CTE-MES.Nro-Cte-Mes = PL-CFG-CTE-MES.Nro-Cte-Mes AND
                    PL-MOV-CTE-MES.CodPer = PL-CFG-CTE-MES.CodPer :
                    DISPLAY STREAM str-report
                        "PERIODO " + STRING(PL-MOV-CTE-MES.Periodo,"9999") +
                        " MES " + STRING(PL-MOV-CTE-MES.NroMes,"99") @ x-nombre
                        "CALCULO " + STRING(PL-MOV-CTE-MES.CodCal,"99") @ PL-CFG-CTE-MES.Nro-Cte-Mes
                        PL-MOV-CTE-MES.CodPln @ PL-CFG-CTE-MES.Fch-Cte-Mes
                        PL-MOV-CTE-MES.Fch-Ult-Mov-Cte-Mes @ PL-CFG-CTE-MES.Imp-Cte-Mes
                        PL-MOV-CTE-MES.Hra-Ult-Mov-Cte-Mes @ PL-CFG-CTE-MES.Fch-Prx-Pgo-Mes
                        PL-MOV-CTE-MES.Val-Cte-Mes @ PL-CFG-CTE-MES.Cuo-Cte-Mes
                        WITH FRAME f-cab.
                    DOWN STREAM str-report 1 WITH FRAME f-cab.
                    IF LINE-COUNTER( str-report ) > 62 THEN PAGE STREAM str-report.
                END.
                IF LINE-COUNTER( str-report ) > 6 THEN
                    PUT STREAM str-report FILL("-", 140) FORMAT "x(140)" SKIP.
            END.
        END.
    END.
    ASSIGN ok-state = Brw-soles:DESELECT-ROWS().
END.
END CASE.

OUTPUT STREAM str-report CLOSE.

IF INPUT TGL-pantalla = TRUE THEN DO:
    RUN bin/_vcat.p ( P-archivo ). 
    OS-DELETE VALUE ( P-archivo ). 
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
    FIND FIRST PL-CORR-CTE-MES WHERE
        PL-CORR-CTE-MES.CodCia = s-codcia AND
        PL-CORR-CTE-MES.Periodo = s-periodo AND
        PL-CORR-CTE-MES.Clf-Cte-Mes = 1 NO-LOCK NO-ERROR.
    IF AVAILABLE PL-CORR-CTE-MES THEN DO:
        FILL-IN-destpo = PL-CORR-CTE-MES.Des-Cte-Mes.
        FILL-IN-tpo    = PL-CORR-CTE-MES.Tpo-Cte-Mes.
        R-moneda       = TRUE.
    END.
    FILL-IN-nromes = s-nromes.
    DISPLAY
        FILL-IN-destpo
        FILL-IN-nromes
        FILL-IN-tpo
        R-moneda
        WITH FRAME {&FRAME-NAME}.
    {&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "integral.PL-CFG-CTE-MES"}
  {src/adm/template/snd-list.i "integral.PL-PERS"}

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


