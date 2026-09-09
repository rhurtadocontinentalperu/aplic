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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR cl-codcia AS INT.

/* Local Variable Definitions ---                                       */

DEF VAR s-task-no AS INT NO-UNDO.
DEF VAR RB-REPORT-LIBRARY AS CHAR.  /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.     /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR. /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.  /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     /* Otros parametros */

DEF VAR cDivi  AS CHARACTER NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-1 FILL-IN-CodCli FILL-IN-CodVen ~
FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 tg-orden RADIO-SET-Ubicacion ~
RADIO-SET-Situacion RADIO-SET-Estado x-Bancos BUTTON-2 BUTTON-3 Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Division FILL-IN-CodCli ~
FILL-IN-NomCli FILL-IN-CodVen FILL-IN-NomVen FILL-IN-FchDoc-1 ~
FILL-IN-FchDoc-2 tg-orden RADIO-SET-Ubicacion RADIO-SET-Situacion ~
RADIO-SET-Estado x-Bancos x-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado W-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT cFlgEst AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSituacion W-Win 
FUNCTION fSituacion RETURNS CHARACTER
  ( INPUT cFlgSit AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fUbicacion W-Win 
FUNCTION fUbicacion RETURNS CHARACTER
  ( INPUT cFlgUbi AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\exit":U
     LABEL "&Done" 
     SIZE 8 BY 1.92
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\print1":U
     LABEL "Button 2" 
     SIZE 8 BY 1.92.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 3" 
     SIZE 8 BY 1.88.

DEFINE VARIABLE x-Bancos AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Banco" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "x(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodVen AS CHARACTER FORMAT "X(3)":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Division AS CHARACTER FORMAT "X(100)":U INITIAL "00000" 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Emitidas desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-2 AS DATE FORMAT "99/99/99":U 
     LABEL "hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81 NO-UNDO.

DEFINE VARIABLE x-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Estado AS CHARACTER INITIAL "P" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pendientes", "P",
"Cobranza Dudosa", "J",
"Canceladas", "C",
"Anuladas", "A",
"Por Aprobar", "X",
"Todo", "Todo"
     SIZE 15 BY 4.19 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Situacion AS CHARACTER INITIAL "C" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Transito", "T",
"Cobranza Libre", "C",
"Cobranza Garantia", "G",
"Descuento", "D",
"Protestada", "P",
"Otros", "",
"Todo", "Todo"
     SIZE 18 BY 4.62 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Ubicacion AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "En Cartera", "C",
"En Banco", "B",
"Todo", "Todo"
     SIZE 12 BY 3 NO-UNDO.

DEFINE VARIABLE tg-orden AS LOGICAL INITIAL yes 
     LABEL "Ordena por Fch Vcto" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1.15 COL 59 WIDGET-ID 4
     FILL-IN-Division AT ROW 1.23 COL 13 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-CodCli AT ROW 2.19 COL 13 COLON-ALIGNED
     FILL-IN-NomCli AT ROW 2.19 COL 25 COLON-ALIGNED NO-LABEL
     FILL-IN-CodVen AT ROW 3.12 COL 13 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-NomVen AT ROW 3.12 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     FILL-IN-FchDoc-1 AT ROW 4.08 COL 13 COLON-ALIGNED
     FILL-IN-FchDoc-2 AT ROW 4.08 COL 28 COLON-ALIGNED
     tg-orden AT ROW 4.12 COL 51 WIDGET-ID 8
     RADIO-SET-Ubicacion AT ROW 5.31 COL 34 NO-LABEL
     RADIO-SET-Situacion AT ROW 5.31 COL 57 NO-LABEL
     RADIO-SET-Estado AT ROW 5.42 COL 9 NO-LABEL
     x-Bancos AT ROW 10.31 COL 9 COLON-ALIGNED WIDGET-ID 12
     BUTTON-2 AT ROW 11.65 COL 5
     BUTTON-3 AT ROW 11.65 COL 14 WIDGET-ID 10
     Btn_Done AT ROW 11.65 COL 23
     x-Mensaje AT ROW 12.46 COL 39 COLON-ALIGNED NO-LABEL
     "Ubicacion:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 5.31 COL 26
     "Situacion:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 5.31 COL 48
     "Estado:" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 5.42 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.72 BY 13.92
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
         TITLE              = "LETRAS POR UBICACION"
         HEIGHT             = 13.92
         WIDTH              = 80.72
         MAX-HEIGHT         = 13.92
         MAX-WIDTH          = 105.72
         VIRTUAL-HEIGHT     = 13.92
         VIRTUAL-WIDTH      = 105.72
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
{src/adm/method/viewer.i}
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
/* SETTINGS FOR FILL-IN FILL-IN-Division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* LETRAS POR UBICACION */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* LETRAS POR UBICACION */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Done */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:

    DEF VAR x-Divisiones AS CHAR.
    x-Divisiones = FILL-IN-Division:SCREEN-VALUE.
    RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
    FILL-IN-Division:SCREEN-VALUE = x-Divisiones.
    cDivi = x-Divisiones.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  ASSIGN
    FILL-IN-CodCli 
    FILL-IN-CodVen
    FILL-IN-FchDoc-1 
    FILL-IN-FchDoc-2 
    RADIO-SET-Ubicacion 
    RADIO-SET-Situacion
    RADIO-SET-Estado
    FILL-IN-Division
    tg-orden
      x-Bancos.
  IF FILL-IN-FchDoc-1 = ? OR FILL-IN-FchDoc-2 = ? THEN RETURN NO-APPLY.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
    ASSIGN
        FILL-IN-CodCli 
        FILL-IN-CodVen
        FILL-IN-FchDoc-1 
        FILL-IN-FchDoc-2 
        RADIO-SET-Ubicacion 
        RADIO-SET-Situacion
        RADIO-SET-Estado
        FILL-IN-Division
        tg-orden
        x-Bancos.
  IF FILL-IN-FchDoc-1 = ? OR FILL-IN-FchDoc-2 = ? THEN RETURN NO-APPLY.
  RUN Excel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli W-Win
ON LEAVE OF FILL-IN-CodCli IN FRAME F-Main /* Cliente */
DO:
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie THEN FILL-IN-NomCli:SCREEN-VALUE = gn-clie.nomcli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodVen W-Win
ON LEAVE OF FILL-IN-CodVen IN FRAME F-Main /* Vendedor */
DO:
    FIND gn-ven WHERE gn-ven.codcia = s-codcia
        AND gn-ven.codven = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN FILL-IN-NomVen:SCREEN-VALUE = gn-ven.nomven.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Division W-Win
ON LEAVE OF FILL-IN-Division IN FRAME F-Main /* División */
DO:
    ASSIGN FILL-IN-Division.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-2 W-Win 
PROCEDURE Carga-Temporal-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-FlgUbi AS CHAR NO-UNDO.
  DEF VAR x-NomUbi AS CHAR NO-UNDO.
  DEF VAR x-CodBco AS CHAR NO-UNDO.
  DEF VAR x-Texto AS CHAR NO-UNDO.
  DEF VAR x-FlgEst AS CHAR NO-UNDO.

  x-FlgEst = RADIO-SET-Estado.
  CASE TRUE:
      WHEN RADIO-SET-Estado = "Todo" THEN x-FlgEst = "J,P,C,A,X".
      WHEN RADIO-SET-Estado = "P" THEN x-FlgEst = "J,P".
  END CASE.
  REPEAT:
    s-task-no = RANDOM(1,999998).
    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN LEAVE.
  END.
  x-CodBco = x-Bancos.
  IF x-Bancos <> "Todos" THEN x-CodBco = SUBSTRING(x-Bancos,1,INDEX(x-Bancos, " - ")).
  FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
      AND LOOKUP(Ccbcdocu.coddiv,cDivi) > 0
      AND Ccbcdocu.coddoc = 'LET'
      AND (FILL-IN-CodCli = "" OR Ccbcdocu.codcli = FILL-IN-CodCli)
      AND Ccbcdocu.fchdoc >= FILL-IN-FchDoc-1
      AND Ccbcdocu.fchdoc <= FILL-IN-FchDoc-2
      /*AND (RADIO-SET-Estado = "Todo" OR Ccbcdocu.flgest = RADIO-SET-Estado)*/
      AND LOOKUP(Ccbcdocu.FlgEst, x-FlgEst) > 0
      AND (RADIO-SET-Ubicacion = "Todo" OR Ccbcdocu.flgubi = RADIO-SET-Ubicacion)
      AND (RADIO-SET-Situacion = "Todo" OR Ccbcdocu.flgsit = RADIO-SET-Situacion),
      FIRST Gn-clie NO-LOCK WHERE Gn-clie.codcia = cl-codcia 
      AND Gn-clie.codcli = Ccbcdocu.codcli
      AND (FILL-IN-CodVen = "" OR gn-clie.codven = FILL-IN-CodVen):
      IF x-CodBco <> "Todos" THEN DO:
          FIND Cb-ctas WHERE Cb-ctas.codcia = CL-CODCIA
              AND Cb-ctas.codcta = Ccbcdocu.codcta
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Cb-ctas THEN NEXT.
          IF Cb-ctas.codbco <> x-codbco THEN NEXT.
      END.
      x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'PROCESANDO: ' +
        ccbcdocu.coddoc + ' ' + ccbcdocu.nrodoc + ' ' + STRING(ccbcdocu.fchdoc).
    CREATE w-report.
    ASSIGN
        w-report.task-no     = s-task-no
        w-report.campo-c[1]  = Ccbcdocu.coddoc
        w-report.campo-c[2]  = Ccbcdocu.nrodoc
        w-report.campo-c[3]  = Ccbcdocu.codcli
        w-report.campo-c[4]  = Gn-clie.nomcli
        w-report.campo-c[5]  = ( IF Ccbcdocu.codmon = 1 THEN 'S/.' ELSE 'US$' )
        w-report.campo-c[7]  = Ccbcdocu.nrosal
        w-report.campo-c[21] = Ccbcdocu.coddiv
        w-report.campo-f[1]  = Ccbcdocu.imptot
        w-report.campo-f[2]  = Ccbcdocu.sdoact
        w-report.campo-c[8] = fEstado(Ccbcdocu.flgest)
        w-report.campo-c[9] = fUbicacion(Ccbcdocu.flgubi)
        w-report.campo-c[10] = fSituacion(Ccbcdocu.flgsit)
        w-report.campo-c[11]  = gn-clie.codven
        w-report.campo-c[25] = gn-clie.dircli
        w-report.campo-c[26] = ccbcdocu.codref + "-" + ccbcdocu.nroref.

    ASSIGN
        w-report.campo-d[1]  = Ccbcdocu.fchdoc
        NO-ERROR.
    ASSIGN
        w-report.campo-d[2]  = Ccbcdocu.fchvto
        NO-ERROR.

    
    RUN lib/limpiar-texto (w-report.campo-c[4], '', OUTPUT x-Texto).
    ASSIGN w-report.campo-c[4] = x-texto.

    FIND gn-ven WHERE gn-ven.codcia = s-codcia
        AND gn-ven.codven = gn-clie.codven
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN DO:
        w-report.campo-c[12] = gn-ven.nomven.
        RUN lib/limpiar-texto (w-report.campo-c[12], '', OUTPUT x-Texto).
        ASSIGN w-report.campo-c[12] = x-texto.
    END.
    FIND Cb-ctas WHERE Cb-ctas.codcia = CL-CODCIA
        AND Cb-ctas.codcta = Ccbcdocu.codcta
        NO-LOCK NO-ERROR.
    IF AVAILABLE Cb-ctas
    THEN DO:
        FIND Cb-tabl WHERE Cb-tabl.tabla = '04'
            AND Cb-tabl.codigo = Cb-ctas.codbco
            NO-LOCK NO-ERROR.
        IF AVAILABLE Cb-tabl THEN DO:
            w-report.campo-c[20] = cb-tabl.Nombre.
            RUN lib/limpiar-texto (w-report.campo-c[20], '', OUTPUT x-Texto).
            ASSIGN w-report.campo-c[20] = x-texto.
        END.
    END.
    /* RHC 06/06/2017 Datos adicionales Julissa Calderon */
    DEF VAR pCodDepto AS CHAR.
    DEF VAR pNomDepto AS CHAR.
    DEF VAR pCodProvi AS CHAR.
    DEF VAR pNomProvi AS CHAR.
    DEF VAR pCodDistr AS CHAR.
    DEF VAR pNomDistr AS CHAR.
    RUN gn/ubigeo-cliente (
        INPUT gn-clie.CodCia ,
        INPUT gn-clie.CodCli ,
        OUTPUT pCodDepto, 
        OUTPUT pNomDepto, 
        OUTPUT pCodProvi, 
        OUTPUT pNomProvi, 
        OUTPUT pCodDistr, 
        OUTPUT pNomDistr 
        ).
    ASSIGN
        w-report.campo-c[22] = pNomDepto
        w-report.campo-c[23] = pNomProvi
        w-report.campo-c[24] = pNomDistr.
    /* ************************************************* */

  END.
  x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
  
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
  DISPLAY FILL-IN-Division FILL-IN-CodCli FILL-IN-NomCli FILL-IN-CodVen 
          FILL-IN-NomVen FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 tg-orden 
          RADIO-SET-Ubicacion RADIO-SET-Situacion RADIO-SET-Estado x-Bancos 
          x-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 FILL-IN-CodCli FILL-IN-CodVen FILL-IN-FchDoc-1 
         FILL-IN-FchDoc-2 tg-orden RADIO-SET-Ubicacion RADIO-SET-Situacion 
         RADIO-SET-Estado x-Bancos BUTTON-2 BUTTON-3 Btn_Done 
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
    /* Cargamos temporal */
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Carga-Temporal-2.
    SESSION:SET-WAIT-STATE('').

    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE
            'No hay registro a imprimir'
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
    DEFINE VARIABLE chChart                 AS COM-HANDLE.
    DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
    DEFINE VARIABLE iCount                  AS INTEGER init 1.
    DEFINE VARIABLE iIndex                  AS INTEGER.
    DEFINE VARIABLE cColumn                 AS CHARACTER.
    DEFINE VARIABLE cRange                  AS CHARACTER.
    DEFINE VARIABLE t-Column                AS INTEGER INIT 1.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "DIV".
    chWorkSheet:Columns("A"):NumberFormat = "@".
    cRange = "B" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "DOC".
    chWorkSheet:Columns("B"):NumberFormat = "@".
    cRange = "C" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "NUMERO".
    chWorkSheet:Columns("C"):NumberFormat = "@".
    cRange = "D" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "EMISION".
    chWorkSheet:Columns("D"):NumberFormat = "dd/mm/yyyy".
    cRange = "E" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "VENCIMIENTO".
    chWorkSheet:Columns("E"):NumberFormat = "dd/mm/yyyy".
    cRange = "F" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "CLIENTE".
    chWorkSheet:Columns("F"):NumberFormat = "@".
    cRange = "G" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "NOMBRE".
    cRange = "H" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "MON".
    cRange = "I" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "IMPORTE".
    cRange = "J" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "SALDO".
    cRange = "K" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "UBICACION".
    cRange = "L" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "SITUACION".
    cRange = "M" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "BANCO".
    cRange = "N" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "# UNICO".
    cRange = "O" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "ESTADO".
    cRange = "P" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "VENDEDOR".
    chWorkSheet:Columns("P"):NumberFormat = "@".
    cRange = "Q" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "NOMBRE".
    cRange = "R" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "DIRECC.CLIENTE".
    cRange = "S" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "DEPARTAMENTO".
    cRange = "T" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "PROVINCIA".
    cRange = "U" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "DISTRITO".
    cRange = "V" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "Nro. Canje".

    FOR EACH w-report WHERE w-report.task-no = s-task-no:
        t-column = t-column + 1.                                                                                                                               
        cColumn = STRING(t-Column).                                                                                        
        cRange = "A" + cColumn.                                                                                                                                
        ASSIGN chWorkSheet:Range(cRange):Value = w-report.campo-c[21] NO-ERROR.
        cRange = "B" + cColumn.                                                                                                                                
        ASSIGN chWorkSheet:Range(cRange):Value = w-report.campo-c[1] NO-ERROR.
        cRange = "C" + cColumn.                                                                                                                                
        ASSIGN chWorkSheet:Range(cRange):Value = w-report.campo-c[2] NO-ERROR.
        cRange = "D" + cColumn.                                                                                                                                
        ASSIGN chWorkSheet:Range(cRange):Value = w-report.campo-d[1] NO-ERROR.
        cRange = "E" + cColumn.                                                                                                                                
        ASSIGN chWorkSheet:Range(cRange):Value = w-report.campo-d[2] NO-ERROR.
        cRange = "F" + cColumn.                                                                                                                                
        ASSIGN chWorkSheet:Range(cRange):Value = w-report.campo-c[3] NO-ERROR.
        cRange = "G" + cColumn.                                                                                                                                
        ASSIGN chWorkSheet:Range(cRange):Value = w-report.campo-c[4] NO-ERROR.
        cRange = "H" + cColumn.                                                                                                                                
        ASSIGN chWorkSheet:Range(cRange):Value = w-report.campo-c[5] NO-ERROR.
        cRange = "I" + cColumn.                                                                                                                                
        ASSIGN chWorkSheet:Range(cRange):Value = w-report.campo-f[1] NO-ERROR.
        cRange = "J" + cColumn.                                                                                    
        ASSIGN chWorkSheet:Range(cRange):Value = w-report.campo-f[2] NO-ERROR.
        cRange = "K" + cColumn.                                                                                    
        ASSIGN chWorkSheet:Range(cRange):Value = w-report.campo-c[9] NO-ERROR.
        cRange = "L" + cColumn.                                                                                    
        ASSIGN chWorkSheet:Range(cRange):Value = w-report.campo-c[10] NO-ERROR.
        cRange = "M" + cColumn.                                                                                    
        ASSIGN chWorkSheet:Range(cRange):Value = w-report.campo-c[20] NO-ERROR.
        cRange = "N" + cColumn.                                                                                    
        ASSIGN chWorkSheet:Range(cRange):Value = w-report.campo-c[7] NO-ERROR.
        cRange = "O" + cColumn.                                                                                    
        ASSIGN chWorkSheet:Range(cRange):Value = w-report.campo-c[8] NO-ERROR.
        cRange = "P" + cColumn.                                                                                    
        ASSIGN chWorkSheet:Range(cRange):Value = w-report.campo-c[11] NO-ERROR.
        cRange = "Q" + cColumn.                                                                                    
        ASSIGN chWorkSheet:Range(cRange):Value = w-report.campo-c[12] NO-ERROR.
        cRange = "R" + cColumn.                                                                                    
        ASSIGN chWorkSheet:Range(cRange):Value = w-report.campo-c[25] NO-ERROR.
        cRange = "S" + cColumn.                                                                                    
        ASSIGN chWorkSheet:Range(cRange):Value = w-report.campo-c[22] NO-ERROR.
        cRange = "T" + cColumn.                                                                                    
        ASSIGN chWorkSheet:Range(cRange):Value = w-report.campo-c[23] NO-ERROR.
        cRange = "U" + cColumn.                                                                                    
        ASSIGN chWorkSheet:Range(cRange):Value = w-report.campo-c[24] NO-ERROR.
        cRange = "V" + cColumn.                                                                                    
        ASSIGN chWorkSheet:Range(cRange):Value = w-report.campo-c[26] NO-ERROR.

    END.

    /* launch Excel so it is visible to the user */
    chExcelApplication:VISIBLE = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

    FOR EACH w-report WHERE w-report.task-no = s-task-no:
        DELETE w-report.
    END.

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

    /* Cargamos temporal */
    RUN Carga-Temporal-2.

    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE
            'No hay registro a imprimir'
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb/rbccb.prl".
    IF tg-orden THEN ASSIGN RB-REPORT-NAME = 'Letras por Ubicacion2'.
    ELSE ASSIGN RB-REPORT-NAME = 'Letras por Ubicacion'.

    ASSIGN
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER = 'w-report.task-no = ' + STRING(s-task-no)
        RB-OTHER-PARAMETERS = 's-nomcia = ' + s-nomcia.

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
  ASSIGN
    FILL-IN-FchDoc-1 = TODAY - DAY(TODAY) + 1
    FILL-IN-FchDoc-2 = TODAY
    cDivi            = FILL-IN-Division.
  FOR EACH cb-tabl WHERE cb-tabl.tabla = '04' NO-LOCK:
      x-Bancos:ADD-LAST(cb-tabl.codigo + " - " + cb-tabl.Nombre) IN FRAME {&FRAME-NAME}.
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado W-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT cFlgEst AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pEstado AS CHAR.
  RUN gn/fFlgEstCCBv2.p (Ccbcdocu.CodDoc, Ccbcdocu.FlgEst, OUTPUT pEstado).
  RETURN pEstado.

/*   CASE cFlgEst:                                  */
/*     WHEN 'P' THEN RETURN 'PEN'.                  */
/*     WHEN 'A' THEN RETURN 'ANU'.                  */
/*     WHEN 'C' THEN RETURN 'CAN'.                  */
/*   END CASE.                                      */
/*   RETURN cFlgEst.   /* Function return value. */ */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSituacion W-Win 
FUNCTION fSituacion RETURNS CHARACTER
  ( INPUT cFlgSit AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE cflgsit:
    WHEN 'T' THEN RETURN 'Transito'.
    WHEN 'C' THEN RETURN 'Cobranza Libre'.
    WHEN 'G' THEN RETURN 'Cobranza Garantia'.
    WHEN 'D' THEN RETURN 'Descuento'.
    WHEN 'P' THEN RETURN 'Protestada'.
  END CASE.
  RETURN cflgsit.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fUbicacion W-Win 
FUNCTION fUbicacion RETURNS CHARACTER
  ( INPUT cFlgUbi AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE cflgubi:
    WHEN 'C' THEN RETURN 'Cartera'.
    WHEN 'B' THEN RETURN 'Banco'.
  END CASE.
  RETURN cflgubi.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

