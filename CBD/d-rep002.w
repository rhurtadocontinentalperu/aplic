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
{src/bin/_prns.i}   /* Para la impresion */
{cbd/cbglobal.i}

DEF SHARED VAR s-CodCia AS INT.
DEF SHARED VAR s-NomCia AS CHAR.

/* VARIABLES PARTICULARES DE LA RUTINA */
DEFINE VARIABLE x-nomcta   AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE x-nombala  AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)".
DEFINE VARIABLE x-expres   AS CHARACTER FORMAT "X(40)".
DEFINE VARIABLE x-nomaux   AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE imp-aux    AS LOGICAL.
DEFINE VARIABLE imprime    AS LOGICAL INITIAL YES.
DEFINE VARIABLE imprimemes AS LOGICAL INITIAL NO.
DEFINE VARIABLE x-conreg   AS INTEGER.
DEFINE VARIABLE x-condoc   AS INTEGER.
DEFINE VARIABLE x-glodoc   LIKE cb-dmov.glodoc.
DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           LABEL "Cargos     ". 
DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           LABEL "Abonos     ".
DEFINE VARIABLE x-importe  AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-"
                           LABEL "Importe    ".
DEFINE VARIABLE x-saldo    AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-"
                           COLUMN-LABEL "Saldo     !Actual    ".

DEF VAR X-CLFAUX AS CHAR INIT "".

DEFINE TEMP-TABLE T-REPORT
FIELD codcia AS INT
FIELD fchdoc AS DATE    COLUMN-LABEL " Fecha!  Doc."
FIELD coddiv AS CHAR    FORMAT "X(5)"  COLUMN-LABEL "Div"
FIELD cco    AS CHAR    FORMAT "X(5)"  COLUMN-LABEL "C.Cos"
FIELD nroast AS CHAR    FORMAT "X(6)"  COLUMN-LABEL "Compro!bante"
FIELD codope AS CHAR    FORMAT "X(3)"  COLUMN-LABEL "Li-!bro"
FIELD nromes AS INTEGER FORMAT "99"    COLUMN-LABEL "Mes"
FIELD coddoc AS CHAR    FORMAT "X(3)"  COLUMN-LABEL "Cod!Doc"  
FIELD nrodoc AS CHAR    FORMAT "X(17)" COLUMN-LABEL "  Nro.!Documento"
FIELD nroref AS CHAR    FORMAT "X(10)" COLUMN-LABEL "  Nro.!Referencia"
FIELD fchvto AS DATE    COLUMN-LABEL " Fecha!  Vto."
FIELD glodoc AS CHAR    FORMAT "X(50)" COLUMN-LABEL "D e t a l l e"           
FIELD t-importe AS DECIMAL    FORMAT "ZZ,ZZZ,ZZ9.99-" COLUMN-LABEL "Importe" 
FIELD t-debe    AS DECIMAL    FORMAT "ZZ,ZZZ,ZZ9.99-" COLUMN-LABEL "Cargos"
FIELD t-haber   AS DECIMAL    FORMAT "ZZ,ZZZ,ZZ9.99-" COLUMN-LABEL "Abonos"
FIELD t-saldo   AS DECIMAL    FORMAT "ZZ,ZZZ,ZZ9.99-" COLUMN-LABEL "Saldo     !Actual    "
FIELD clfaux    AS CHAR
FIELD codaux    AS CHAR       FORMAT "X(8)"  COLUMN-LABEL "Código !Auxiliar"
FIELD codcta    AS CHAR       FORMAT "X(8)"  COLUMN-LABEL "Código!Cuenta"
FIELD FECHA-ID  AS DATE  
FIELD Voucher   AS CHAR FORMAT "X(9)" 
INDEX IDX01 codcta codaux Voucher fecha-id coddoc nrodoc codope nroast fchdoc
INDEX IDX02 codcta codaux coddoc nrodoc
INDEX IDX03 codaux codcta Voucher fecha-id coddoc nrodoc codope nroast fchdoc.

DEFINE TEMP-TABLE REPORTE LIKE T-REPORT.

DEFINE VAR X-MENSAJE AS CHAR FORMAT "X(40)".
DEFINE FRAME F-AUXILIAR X-MENSAJE
    WITH TITLE "Espere un momento por favor" VIEW-AS DIALOG-BOX CENTERED NO-LABELS.


/* VARIABLES GENERALES :  IMPRESION,SISTEMA,MODULO,USUARIO */
DEFINE VARIABLE P-Largo    AS INTEGER NO-UNDO.
DEFINE VARIABLE P-Ancho    AS INTEGER NO-UNDO.
DEFINE VARIABLE P-pagini   AS INTEGER FORMAT ">>>9" NO-UNDO.
DEFINE VARIABLE P-pagfin   AS INTEGER FORMAT ">>>9" NO-UNDO.
DEFINE VARIABLE P-copias   AS INTEGER FORMAT ">9" NO-UNDO.
DEFINE VARIABLE P-select   AS INTEGER FORMAT "9" NO-UNDO.
DEFINE VARIABLE P-archivo  AS CHARACTER FORMAT "x(30)" NO-UNDO.

DEFINE VARIABLE P-detalle  LIKE TermImp.Detalle NO-UNDO.
DEFINE VARIABLE P-comando  LIKE TermImp.Comando NO-UNDO.
DEFINE VARIABLE P-device   LIKE TermImp.Device NO-UNDO.
DEFINE VARIABLE P-name     LIKE TermImp.p-name NO-UNDO.

DEFINE VARIABLE P-Reset    AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-Flen     AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-6lpi     AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-8lpi     AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-10cpi    AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-12cpi    AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-15cpi    AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-20cpi    AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-Landscap AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-Portrait AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-DobleOn  AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-DobleOff AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-BoldOn   AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-BoldOff  AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-UlineOn  AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-UlineOff AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-ItalOn   AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-ItalOff  AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-SuperOn  AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-SuperOff AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-SubOn    AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-SubOff   AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-Proptnal AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-Lpi      AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-immediate-display AS LOGICAL NO-UNDO.
DEFINE VARIABLE x-Raya     AS CHARACTER FORMAT "X(150)" NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".

DEFINE        VARIABLE P-config  AS CHARACTER NO-UNDO.
DEFINE        VARIABLE c-Pagina  AS INTEGER LABEL "                 Imprimiendo Pagina " NO-UNDO.
DEFINE        VARIABLE c-Copias  AS INTEGER NO-UNDO.
DEFINE        VARIABLE x-Detalle LIKE Modulos.Detalle NO-UNDO.
DEFINE        VARIABLE i           AS INTEGER NO-UNDO.
DEFINE        VARIABLE OKpressed   AS LOGICAL NO-UNDO.

/* MACRO NUEVA-PAGINA */
&GLOBAL-DEFINE NEW-PAGE READKEY PAUSE 0. ~
IF LASTKEY = KEYCODE("F10") THEN RETURN ERROR. ~
IF LINE-COUNTER( report ) > (P-Largo - 8 ) OR c-Pagina = 0 ~
THEN RUN NEW-PAGE

DEFINE FRAME T-cab
       REPORTE.fchdoc COLUMN-LABEL " Fecha!  Doc."
       REPORTE.coddiv COLUMN-LABEL "Div"
       REPORTE.cco    COLUMN-LABEL "C.Cos"
       REPORTE.nroast COLUMN-LABEL "Compro!bante"
       REPORTE.codope COLUMN-LABEL "Ope!rac"
       REPORTE.nromes LABEL        "Mes"
       REPORTE.coddoc COLUMN-LABEL "Cod!Doc" FORMAT "X(3)"          
       REPORTE.nrodoc COLUMN-LABEL "  Nro.!Documento" 
       REPORTE.fchvto COLUMN-LABEL " Fecha!  Vto."
       REPORTE.NroRef COLUMN-LABEL "Referencia" FORMAT "X(10)" 
       REPORTE.glodoc COLUMN-LABEL "D e t a l l e" FORMAT "X(25)"          
       REPORTE.T-importe  
       REPORTE.T-debe
       REPORTE.T-haber  
       REPORTE.T-saldo
       HEADER
       S-Nomcia
       "A N A L I S I S  D E   C U E N T A S" AT 70
       /*"FECHA : " TO 150 TODAY TO 160*/
       SKIP
       pinta-mes AT 68
       "PAGINA :" TO 150 c-pagina FORMAT "ZZ9" TO 160
       x-nombala AT 63
       x-expres  AT 68
       SKIP(3)
       WITH WIDTH 255 NO-BOX DOWN STREAM-IO.

DEFINE IMAGE IMAGE-1
     FILENAME "IMG/print"
     SIZE 5 BY 1.5.

DEFINE FRAME F-Mensaje
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16
          font 4
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19
          font 4
     "F10 = Cancela Reporte" VIEW-AS TEXT
          SIZE 21 BY 1 AT ROW 3.5 COL 12
          font 4          
     SPACE(10.28) SKIP(0.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Imprimiendo ...".

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
&Scoped-Define ENABLED-OBJECTS RECT-26 RECT-5 RECT-27 C-Mes x-CodOpe x-Div ~
x-cuenta x-cuenta-2 x-codmon RADIO-SET-1 RB-NUMBER-COPIES B-impresoras ~
RB-BEGIN-PAGE RB-END-PAGE BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS C-Mes x-CodOpe x-Div x-cuenta x-cuenta-2 ~
x-codmon RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-archivo 
     IMAGE-UP FILE "IMG/pvstop":U
     LABEL "&Archivos.." 
     SIZE 5 BY 1.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Button 1" 
     SIZE 15 BY 1.54.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Button 2" 
     SIZE 15 BY 1.54.

DEFINE VARIABLE C-Mes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Al Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 13
     LIST-ITEMS "0","1","2","3","4","5","6","7","8","9","10","11","12" 
     DROP-DOWN-LIST
     SIZE 6 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-Div AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE RB-BEGIN-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "Página Desde" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-END-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 9999 
     LABEL "Página Hasta" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-NUMBER-COPIES AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "No. Copias" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-OUTPUT-FILE AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33.86 BY .69
     BGCOLOR 15 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE VARIABLE x-CodOpe AS CHARACTER FORMAT "X(3)":U 
     LABEL "Operacion" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-cuenta AS CHARACTER FORMAT "X(10)":U 
     LABEL "Desde la Cuenta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-cuenta-2 AS CHARACTER FORMAT "X(10)":U 
     LABEL "Hasta la Cuenta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 12 BY 3 NO-UNDO.

DEFINE VARIABLE x-codmon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dólares", 2
     SIZE 16 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 6.35.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 1.92.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78.29 BY 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     C-Mes AT ROW 1.38 COL 23 COLON-ALIGNED
     x-CodOpe AT ROW 2.35 COL 23 COLON-ALIGNED
     x-Div AT ROW 3.31 COL 23 COLON-ALIGNED
     x-cuenta AT ROW 4.27 COL 23 COLON-ALIGNED
     x-cuenta-2 AT ROW 5.23 COL 23 COLON-ALIGNED
     x-codmon AT ROW 6.19 COL 25 NO-LABEL
     RADIO-SET-1 AT ROW 8.62 COL 2 NO-LABEL
     RB-NUMBER-COPIES AT ROW 8.62 COL 64 COLON-ALIGNED
     B-impresoras AT ROW 9.62 COL 15
     RB-BEGIN-PAGE AT ROW 9.62 COL 64 COLON-ALIGNED
     b-archivo AT ROW 10.62 COL 15
     RB-END-PAGE AT ROW 10.62 COL 64 COLON-ALIGNED
     RB-OUTPUT-FILE AT ROW 10.88 COL 19 COLON-ALIGNED NO-LABEL
     BUTTON-1 AT ROW 12.35 COL 5
     BUTTON-2 AT ROW 12.35 COL 21
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 6.19 COL 19
     " Configuración de Impresión" VIEW-AS TEXT
          SIZE 78.29 BY .62 AT ROW 7.35 COL 1
          BGCOLOR 1 FGCOLOR 15 
     RECT-26 AT ROW 1 COL 1
     RECT-5 AT ROW 8.12 COL 1
     RECT-27 AT ROW 12.15 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17
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
         TITLE              = "REPORTE DE INCONSISTENCIAS DE CUENTAS POR COBRAR"
         HEIGHT             = 13.19
         WIDTH              = 79
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 93.29
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 93.29
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
/* SETTINGS FOR BUTTON b-archivo IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       b-archivo:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN RB-OUTPUT-FILE IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       RB-OUTPUT-FILE:HIDDEN IN FRAME F-Main           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE INCONSISTENCIAS DE CUENTAS POR COBRAR */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE INCONSISTENCIAS DE CUENTAS POR COBRAR */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-archivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-archivo W-Win
ON CHOOSE OF b-archivo IN FRAME F-Main /* Archivos.. */
DO:
     SYSTEM-DIALOG GET-FILE RB-OUTPUT-FILE
        TITLE      "Archivo de Impresión ..."
        FILTERS    "Archivos Impresión (*.txt)"   "*.txt",
                   "Todos (*.*)"   "*.*"
        INITIAL-DIR "./txt"
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.
      
    IF OKpressed = TRUE THEN
        RB-OUTPUT-FILE:SCREEN-VALUE = RB-OUTPUT-FILE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-impresoras
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-impresoras W-Win
ON CHOOSE OF B-impresoras IN FRAME F-Main
DO:
    SYSTEM-DIALOG PRINTER-SETUP.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  ASSIGN C-Mes x-codmon x-CodOpe x-cuenta x-cuenta-2 x-Div.
  /*RUN Imprimir.*/
  RUN Imprimir-1.
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


&Scoped-define SELF-NAME RADIO-SET-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 W-Win
ON VALUE-CHANGED OF RADIO-SET-1 IN FRAME F-Main
DO:
    IF SELF:SCREEN-VALUE = "3"
    THEN ASSIGN b-archivo:VISIBLE = YES
                RB-OUTPUT-FILE:VISIBLE = YES
                b-archivo:SENSITIVE = YES
                RB-OUTPUT-FILE:SENSITIVE = YES.
    ELSE ASSIGN b-archivo:VISIBLE = NO
                RB-OUTPUT-FILE:VISIBLE = NO
                b-archivo:SENSITIVE = NO
                RB-OUTPUT-FILE:SENSITIVE = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodOpe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodOpe W-Win
ON LEFT-MOUSE-DBLCLICK OF x-CodOpe IN FRAME F-Main /* Operacion */
OR F8 OF x-CodOpe
DO:
   DEF VAR X AS RECID.
   RUN cbd/q-oper(cb-codcia,output X).
   FIND cb-oper WHERE RECID(cb-oper) = X
        NO-LOCK NO-ERROR.
   IF AVAILABLE cb-oper THEN DO:
        ASSIGN {&SELF-NAME} = cb-oper.CodOpe.
        DISPLAY {&SELF-NAME} WITH FRAME {&FRAME-NAME}.
   END.     
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-cuenta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-cuenta W-Win
ON F8 OF x-cuenta IN FRAME F-Main /* Desde la Cuenta */
OR "MOUSE-SELECT-DBLCLICK":U OF X-CUENTA DO:
  
  {ADM/H-CTAS02.I NO SELF}
   
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-cuenta W-Win
ON LEAVE OF x-cuenta IN FRAME F-Main /* Desde la Cuenta */
DO:  
   X-CLFAUX = "".
   FIND CB-CTAS WHERE CB-CTAS.CODCIA = CB-CODCIA AND
                      CB-CTAS.CODCTA = X-CUENTA:SCREEN-VALUE
                      NO-LOCK NO-ERROR.
   IF AVAIL CB-CTAS THEN X-CLFAUX = CB-CTAS.CLFAUX.                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-cuenta-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-cuenta-2 W-Win
ON F8 OF x-cuenta-2 IN FRAME F-Main /* Hasta la Cuenta */
OR "MOUSE-SELECT-DBLCLICK":U OF X-CUENTA-2 DO:
  
  {ADM/H-CTAS02.I NO SELF}
   
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-cuenta-2 W-Win
ON LEAVE OF x-cuenta-2 IN FRAME F-Main /* Hasta la Cuenta */
DO:
  
   X-CLFAUX = "".
   FIND CB-CTAS WHERE CB-CTAS.CODCIA = CB-CODCIA AND
                      CB-CTAS.CODCTA = X-CUENTA:SCREEN-VALUE
                      NO-LOCK NO-ERROR.
   IF AVAIL CB-CTAS THEN X-CLFAUX = CB-CTAS.CLFAUX.                   
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra W-Win 
PROCEDURE Borra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH t-report WHERE
         t-report.codcta = cb-dmov.codcta and
         t-report.codaux = cb-dmov.codaux and
         t-report.coddoc = cb-dmov.coddoc and
         t-report.nrodoc = cb-dmov.nrodoc :
    DELETE t-report.                   
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
  DEF VAR X-MONCTA AS INTEGER.
  DEF VAR CON-CTA  AS INTEGER.
  DEF VAR Y-SALDO  AS DECIMAL.
  DEF VAR K AS INTEGER.
  DEF VAR T-FECHA AS DATE.
  DEF VAR X-VOUCHER AS CHAR.   
  DEF VAR X-S1 AS DECIMAL.
  DEF VAR X-S2 AS DECIMAL.
  DEF VAR X-GLODOC AS CHAR.
  DEF VAR X-DEBE AS DEC.
  DEF VAR X-HABER AS DEC.
  DEF VAR X-IMPORTE AS DEC.
  DEF VAR X-SDOACT AS DEC.
  DEF VAR X-FECHA-D AS DATE.
  DEF VAR X-FECHA-H AS DATE.

  ASSIGN
    K = 0
    Y-SALDO = 0.

  DISPLAY "Ordenando Información Requerida" @ x-mensaje with frame f-auxiliar.
  PAUSE 0.

  FOR EACH T-REPORT:
    DELETE T-REPORT.
  END.
  FOR EACH REPORTE:
    DELETE REPORTE.
  END.
  
  FOR EACH cb-dmov NO-LOCK WHERE
        cb-dmov.codcia    =      s-codcia           AND
        cb-dmov.periodo   =      s-periodo          AND
        cb-dmov.codcta   >=      (x-cuenta)         AND
        cb-dmov.codcta   <=      (x-cuenta-2)       AND
        /*cb-dmov.codaux   BEGINS  (x-auxiliar)       AND*/
        cb-dmov.nromes   <=      c-mes              AND
        (x-Div = 'Todas' OR cb-dmov.coddiv BEGINS x-div) AND
        /*cb-dmov.clfaux   BEGINS  (x-Clasificacion)  AND*/
        (x-CodOpe = '' OR cb-dmov.codope = x-codope),
        FIRST CB-CTAS WHERE cb-ctas.codcia = cb-codcia
            AND cb-ctas.codcta = cb-dmov.codcta 
            AND cb-ctas.codmon = x-codmon NO-LOCK     
            BREAK BY cb-dmov.codcia
                  BY cb-dmov.periodo 
                  BY cb-dmov.Codcta
                  BY cb-dmov.codaux
                  BY cb-dmov.coddoc
                  BY cb-dmov.nrodoc 
                  BY cb-dmov.nromes 
                  BY cb-dmov.fchdoc :
    IF FIRST-OF(cb-dmov.codcta) 
    THEN x-MonCta = cb-ctas.codmon.
    IF FIRST-OF(cb-dmov.nrodoc) AND FIRST-OF(cb-dmov.fchdoc) 
    THEN ASSIGN 
            T-FECHA = CB-DMOV.FCHDOC
            X-VOUCHER = cb-dmov.codope + cb-dmov.nroast.
    IF FIRST-OF(cb-dmov.nrodoc) 
    THEN ASSIGN
            x-s1 = 0
            x-s2 = 0.
    IF cb-dmov.tpomov 
    THEN ASSIGN 
            x-s1 = x-s1 - cb-dmov.impmn1
            x-s2 = x-s2 - cb-dmov.impmn2.
    ELSE ASSIGN 
            x-s1 = x-s1 + cb-dmov.impmn1
            x-s2 = x-s2 + cb-dmov.impmn2.
    x-glodoc = cb-dmov.glodoc.
    IF NOT cb-dmov.tpomov 
    THEN CASE x-codmon:
            WHEN 1 THEN DO:
                x-debe  = cb-dmov.ImpMn1.
                x-haber = 0.
        END.
            WHEN 2 THEN DO:
                x-debe  = cb-dmov.ImpMn2.
                x-haber = 0.
            END.
        END CASE.
    ELSE CASE x-codmon:
            WHEN 1 THEN DO:
                x-debe  = 0.
                x-haber = cb-dmov.ImpMn1.
            END.
            WHEN 2 THEN DO:
                x-debe  = 0.
                x-haber = cb-dmov.ImpMn2.
            END.
         END CASE.            
    IF cb-dmov.codmon = x-codmon 
    THEN x-importe = 0.
    ELSE CASE cb-dmov.codmon:
            WHEN 1 THEN 
                x-importe = cb-dmov.ImpMn1.
            WHEN 2 THEN 
                x-importe = cb-dmov.ImpMn2.
         END CASE.
    CREATE T-REPORT.
    ASSIGN 
        T-REPORT.CODCTA    = CB-DMOV.CODCTA
        T-REPORT.CLFAUX    = CB-DMOV.CLFAUX
        T-REPORT.CODAUX    = CB-DMOV.CODAUX
        T-REPORT.FCHDOC    = CB-DMOV.FCHDOC
        T-REPORT.CODDIV    = cb-dmov.coddiv
        T-REPORT.CCO       = cb-dmov.cco
        T-REPORT.NROAST    = cb-dmov.nroast
        T-REPORT.CODOPE    = cb-dmov.codope
        T-REPORT.NROMES    = cb-dmov.nromes
        T-REPORT.CODDOC    = cb-dmov.coddoc
        T-REPORT.NRODOC    = cb-dmov.nrodoc
        T-REPORT.NROREF    = cb-dmov.nroref
        T-REPORT.FCHVTO    = cb-dmov.fchvto
        T-REPORT.GLODOC    = x-glodoc
        T-REPORT.T-IMPORTE = x-importe
        T-REPORT.T-DEBE    = x-debe
        T-REPORT.T-HABER   = x-haber
        T-REPORT.FECHA-ID  = T-FECHA
        T-REPORT.VOUCHER   = X-VOUCHER.
    IF LAST-OF(CB-DMOV.NRODOC) THEN DO:
        CASE x-moncta :
            WHEN 1 then IF  x-s1 = 0 THEN RUN borra.
            WHEN 2 then IF  x-s2 = 0 THEN RUN borra.
            OTHERWISE DO:
                CASE x-codmon :
                    WHEN 1 then IF  x-s1 = 0 THEN RUN borra.
                    WHEN 2 then IF  x-s2 = 0 THEN RUN borra.
                END CASE.
            END.
        END CASE.
    END.
  END. /* FIN DEL FOR EACH */    
  
  /* RESUMEN POR DOCUMENTO */
  FOR EACH T-REPORT NO-LOCK USE-INDEX IDX03
        BREAK  BY T-REPORT.CODAUX
                BY T-REPORT.CODCTA
                BY T-REPORT.CODDOC
                BY T-REPORT.NRODOC 
                BY T-REPORT.NROMES
                BY T-REPORT.FCHDOC:
    IF FIRST-OF(T-REPORT.NroDoc)
    THEN DO:
        CREATE REPORTE.
        BUFFER-COPY T-REPORT TO REPORTE
            ASSIGN REPORTE.T-Importe = T-REPORT.T-Debe - T-REPORT.T-Haber
                    REPORTE.T-Debe = 0
                    REPORTE.T-Haber = 0.
    END.
    ASSIGN
        REPORTE.T-Debe  = REPORTE.T-Debe  + T-REPORT.T-Debe
        REPORTE.T-Haber = REPORTE.T-Haber + T-REPORT.T-Haber.
    IF LAST-OF(T-REPORT.NroDoc)
    THEN REPORTE.T-Saldo = REPORTE.T-Debe - REPORTE.T-Haber.    
  END.

  /* INCONSISTENCIA */
  FOR EACH REPORTE:
    FIND FacDocum WHERE facdocum.codcia = s-codcia
        AND facdocum.codcbd = REPORTE.coddoc NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacDocum THEN NEXT.
    FIND CcbCDocu WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.coddoc = facdocum.coddoc
        AND ccbcdocu.nrodoc = reporte.nrodoc
        NO-LOCK NO-ERROR.
/*    IF AVAILABLE ccbcdocu AND ccbcdocu.sdoact = reporte.t-saldo
 *     THEN DELETE REPORTE.*/
    IF AVAILABLE CcbCDocu
    THEN DO:
        /* Calculamos el saldo del documento */
        RUN bin/_dateif (c-Mes, s-Periodo, OUTPUT x-Fecha-d, OUTPUT x-Fecha-h).
        x-SdoAct = CcbCDocu.ImpTot.     /* OJO */
        FOR EACH CcbDCaja WHERE CcbDCaja.codcia = ccbcdocu.codcia
                AND ccbdcaja.codref = ccbcdocu.coddoc
                AND ccbdcaja.nroref = ccbcdocu.nrodoc 
                AND ccbdcaja.fchdoc <= x-Fecha-H NO-LOCK:
            IF ccbcdocu.codmon = ccbdcaja.codmon
            THEN x-sdoact = x-sdoact - ccbdcaja.imptot.
            ELSE IF ccbcdocu.codmon = 1
                THEN x-sdoact = x-sdoact - ROUND(ccbdcaja.imptot * ccbdcaja.tpocmb,2).
                ELSE x-sdoact = x-sdoact - ROUND(ccbdcaja.imptot / ccbdcaja.tpocmb,2).
        END.                    
        IF reporte.t-saldo = x-sdoact THEN DELETE REPORTE.
    END.
  END.  
  
  HIDE FRAME F-Auxiliar.
  
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
  DISPLAY C-Mes x-CodOpe x-Div x-cuenta x-cuenta-2 x-codmon RADIO-SET-1 
          RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-26 RECT-5 RECT-27 C-Mes x-CodOpe x-Div x-cuenta x-cuenta-2 
         x-codmon RADIO-SET-1 RB-NUMBER-COPIES B-impresoras RB-BEGIN-PAGE 
         RB-END-PAGE BUTTON-1 BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
  DEF VAR x-NomAux AS CHAR.
  DEF VAR Titulo-1 AS CHAR FORMAT 'x(80)'.
  DEF VAR Titulo-2 AS CHAR FORMAT 'x(80)'.
  DEF VAR Titulo-3 AS CHAR FORMAT 'x(80)'.
  DEF VAR Titulo-4 AS CHAR FORMAT 'x(80)'.

  RUN bin/_mes (c-Mes, 1, OUTPUT Titulo-1).
  Titulo-1 = 'AL MES DE ' + TRIM(Titulo-1) + ' PERIODO ' + STRING(s-Periodo, '9999').
  Titulo-2 = 'DIVISION: ' + x-Div.
  Titulo-3 = 'DESDE LA CUENTA ' + x-Cuenta + ' HASTA LA CUENTA ' + x-Cuenta-2.
  Titulo-4 = 'DOCUMENTOS EN ' + IF x-CodMon = 1 THEN 'SOLES' ELSE 'DOLARES'.
  
  DEFINE FRAME FD-REP
    REPORTE.codaux      FORMAT 'x(11)'              COLUMN-LABEL 'Auxiliar'
    x-NomAux            FORMAT 'x(35)'              COLUMN-LABEL 'Nombre del Auxiliar'
    REPORTE.coddoc      FORMAT 'x(2)'               COLUMN-LABEL 'Doc'
    REPORTE.nrodoc      FORMAT 'x(10)'              COLUMN-LABEL 'Numero'
    REPORTE.t-importe   FORMAT '->>>,>>>,>>9.99'    COLUMN-LABEL 'Importe'
    REPORTE.t-saldo     FORMAT '->>>,>>>,>>9.99'    COLUMN-LABEL 'Saldo'
    WITH WIDTH 200 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME H-REP
    HEADER
    S-NOMCIA FORMAT "X(45)" SKIP
    "INCONSISTENCIAS DE CUENTAS POR COBRAR" AT 30
    "Pag.  : " AT 110 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
    "Fecha : " AT 110 STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
    Titulo-1 SKIP
    Titulo-2 SKIP
    Titulo-3 SKIP
    Titulo-4 SKIP(1)
    WITH PAGE-TOP WIDTH 200 NO-BOX NO-LABELS STREAM-IO CENTERED DOWN. 

  FOR EACH REPORTE:
    VIEW STREAM REPORT FRAME H-REP.
    x-NomAux = ''.
    FIND GN-CLIE WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = reporte.codaux
        NO-LOCK NO-ERROR.
    IF AVAILABLE GN-CLIE
    THEN x-nomaux = gn-clie.nomcli.
    ELSE DO:
        FIND CB-AUXI WHERE cb-auxi.codcia = cb-codcia
            AND cb-auxi.codaux = reporte.codaux
            NO-LOCK NO-ERROR.
        IF AVAILABLE cb-auxi THEN x-nomaux = cb-auxi.nomaux.
    END.
    DISPLAY STREAM REPORT
        REPORTE.codaux      
        x-NomAux            
        REPORTE.coddoc      
        REPORTE.nrodoc      
        REPORTE.t-importe   
        REPORTE.t-saldo     
        WITH FRAME FD-REP.
  END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-1 W-Win 
PROCEDURE Formato-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR X-MONCTA AS INTEGER.
DEF VAR K AS INTEGER.
DEF VAR CON-CTA  AS INTEGER.
DEF VAR Y-SALDO  AS DECIMAL.

IF C-COPIAS = 1 THEN  DO:
    RUN Carga-Temporal.
END.

p-config =  p-20cpi.

DO WITH FRAME T-REP :
        FOR EACH REPORTE NO-LOCK USE-INDEX IDX03
               BREAK  BY REPORTE.CODAUX
                      BY REPORTE.CODCTA
                      BY REPORTE.VOUCHER
                      BY REPORTE.FECHA-ID
                      BY REPORTE.CODDOC
                      BY REPORTE.NRODOC 
                      BY REPORTE.CODOPE
                      BY REPORTE.NROAST
                      BY REPORTE.FCHDOC :
             K = K + 1.
             IF K = 1 THEN DO:
                hide frame f-auxiliar .
                VIEW FRAME F-Mensaje.   
                PAUSE 0.           
             END.          
             IF FIRST-OF (REPORTE.nrodoc) THEN x-conreg = 0.
             IF FIRST-OF (REPORTE.codaux) THEN DO:
                run T-nom-aux.
                x-nomaux = REPORTE.codaux + " " + x-nomaux.
                {&NEW-PAGE}.            
                DISPLAY STREAM report WITH FRAME T-cab.
                PUT STREAM report CONTROL P-dobleon.
                PUT STREAM report x-nomaux.
                PUT STREAM report CONTROL P-dobleoff.
                DOWN STREAM REPORT WITH FRAME T-CAB.
                CON-CTA = CON-CTA + 1.
             END.
             IF FIRST-OF (REPORTE.codcta) THEN DO:
                i = 0.
                x-condoc = 0.
                find cb-ctas WHERE cb-ctas.codcia = cb-codcia
                                AND cb-ctas.codcta = REPORTE.codcta
                                  NO-LOCK NO-ERROR.
                IF AVAILABLE cb-ctas THEN DO:
                   x-MoNcta = cb-ctas.codmon.
                   x-nomcta = REPORTE.codcta + " " + cb-ctas.nomcta.
                   {&NEW-PAGE}.            
                   DISPLAY STREAM report WITH FRAME T-cab.
                   PUT STREAM report CONTROL P-dobleon.
                   PUT STREAM report x-nomcta.
                   PUT STREAM report CONTROL P-dobleoff.
                   DOWN STREAM REPORT WITH FRAME T-CAB.    
                END.
             END.
             ACCUMULATE T-debe  (SUB-TOTAL BY REPORTE.nrodoc).
             ACCUMULATE T-haber (SUB-TOTAL BY REPORTE.nrodoc).
             ACCUMULATE T-debe  (SUB-TOTAL BY REPORTE.codcta).
             ACCUMULATE T-haber (SUB-TOTAL BY REPORTE.codcta).
             ACCUMULATE T-debe  (SUB-TOTAL BY REPORTE.codaux).
             ACCUMULATE T-haber (SUB-TOTAL BY REPORTE.codaux).
             ACCUMULATE T-debe  (TOTAL) .
             ACCUMULATE T-haber (TOTAL) .
             X-CONREG = X-CONREG + 1. 
             IF LAST-OF(REPORTE.NRODOC) AND X-CONREG > 0 THEN DO:
                Y-SALDO = (ACCUMULATE    SUB-TOTAL BY REPORTE.NroDoc T-debe ) -
                          (ACCUMULATE    SUB-TOTAL BY REPORTE.NroDoc T-haber) .
                {&NEW-PAGE}.
                DISPLAY STREAM REPORT 
                        REPORTE.fchdoc 
                        REPORTE.coddiv 
                        REPORTE.cco    
                        REPORTE.nroast 
                        REPORTE.codope 
                        REPORTE.nromes 
                        REPORTE.coddoc 
                        REPORTE.nrodoc 
                        REPORTE.fchvto 
                        REPORTE.NroRef
                        REPORTE.glodoc 
                        REPORTE.T-importe  WHEN T-IMPORTE <> 0
                        REPORTE.T-debe     WHEN T-DEBE    <> 0 
                        REPORTE.T-haber    WHEN T-HABER   <> 0
                        y-saldo @ t-saldo
                        WITH FRAME T-CAB.
                DOWN STREAM REPORT WITH FRAME T-CAB.
                UNDERLINE STREAM REPORT 
                          REPORTE.fchdoc 
                          REPORTE.coddiv 
                          REPORTE.cco    
                          REPORTE.nroast 
                          REPORTE.codope 
                          REPORTE.nromes 
                          REPORTE.coddoc 
                          REPORTE.nrodoc 
                          REPORTE.fchvto 
                          REPORTE.NroRef
                          REPORTE.glodoc 
                          REPORTE.T-importe  
                          REPORTE.T-debe
                          REPORTE.T-haber  
                          REPORTE.T-saldo
                          WITH FRAME T-CAB.
                DOWN STREAM REPORT WITH FRAME T-CAB.    
                X-CONDOC = X-CONDOC + 1.
             END.
             ELSE DO:
                    {&NEW-PAGE}.
                    DISPLAY STREAM REPORT 
                            REPORTE.fchdoc 
                            REPORTE.coddiv 
                            REPORTE.cco    
                            REPORTE.nroast 
                            REPORTE.codope 
                            REPORTE.nromes 
                            REPORTE.coddoc 
                            REPORTE.nrodoc 
                            REPORTE.fchvto 
                            REPORTE.NroRef
                            REPORTE.glodoc 
                            REPORTE.T-importe  WHEN T-IMPORTE <> 0
                            REPORTE.T-debe     WHEN T-DEBE    <> 0 
                            REPORTE.T-haber    WHEN T-HABER   <> 0
                            WITH FRAME T-CAB.
                    DOWN STREAM REPORT WITH FRAME T-CAB.
             END.
             IF LAST-OF(REPORTE.CODCTA)  THEN DO:
                Y-SALDO = (ACCUMULATE    SUB-TOTAL BY REPORTE.CODCTA T-debe ) -
                          (ACCUMULATE    SUB-TOTAL BY REPORTE.CODCTA T-haber) .
                DISPLAY STREAM REPORT
                        "T o t a l  C u e n t a"                          @ REPORTE.GloDoc
                        ACCUMULATE   SUB-TOTAL BY REPORTE.CODCTA T-debe  @ t-debe 
                        ACCUMULATE   SUB-TOTAL BY REPORTE.CODCTA T-haber @ t-haber
                        Y-SALDO                                           @ t-saldo
                        WITH FRAME T-CAB.
                DOWN STREAM REPORT WITH FRAME T-CAB.    
                UNDERLINE STREAM REPORT 
                          REPORTE.fchdoc 
                          REPORTE.coddiv 
                          REPORTE.cco    
                          REPORTE.nroast 
                          REPORTE.codope 
                          REPORTE.nromes 
                          REPORTE.coddoc 
                          REPORTE.nrodoc 
                          REPORTE.fchvto 
                          REPORTE.NroRef
                          REPORTE.glodoc 
                          REPORTE.T-importe  
                          REPORTE.T-debe
                          REPORTE.T-haber  
                          REPORTE.T-saldo
                          WITH FRAME T-CAB.
                DOWN STREAM REPORT WITH WITH FRAME T-CAB.
             END.
             IF LAST-OF(REPORTE.CODAUX) AND X-CONDOC > 0 THEN DO:
                Y-SALDO = (ACCUMULATE    SUB-TOTAL BY REPORTE.CODAUX T-debe ) -
                          (ACCUMULATE    SUB-TOTAL BY REPORTE.CODAUX T-haber) .
                DISPLAY STREAM REPORT
                        "Total   Auxiliar " @ REPORTE.GLODOC
                        ACCUMULATE   SUB-TOTAL BY REPORTE.CODAUX T-debe  @ t-debe 
                        ACCUMULATE   SUB-TOTAL BY REPORTE.CODAUX T-haber @ t-haber
                        Y-SALDO                                           @ t-saldo
                        WITH FRAME T-CAB.
                DOWN STREAM REPORT WITH FRAME T-CAB.    
                UNDERLINE STREAM REPORT 
                          REPORTE.fchdoc 
                          REPORTE.coddiv 
                          REPORTE.cco    
                          REPORTE.nroast 
                          REPORTE.codope 
                          REPORTE.nromes 
                          REPORTE.coddoc 
                          REPORTE.nrodoc 
                          REPORTE.fchvto 
                          REPORTE.NroRef
                          REPORTE.glodoc 
                          REPORTE.T-importe  
                          REPORTE.T-debe
                          REPORTE.T-haber  
                          REPORTE.T-saldo
                          WITH FRAME T-CAB.
                DOWN STREAM REPORT WITH WITH FRAME T-CAB.
             END.
         END.
         IF CON-CTA > 1 THEN DO:
            UNDERLINE STREAM REPORT 
                      REPORTE.fchdoc 
                      REPORTE.coddiv 
                      REPORTE.cco    
                      REPORTE.nroast 
                      REPORTE.codope 
                      REPORTE.nromes 
                      REPORTE.coddoc 
                      REPORTE.nrodoc 
                      REPORTE.fchvto 
                      REPORTE.NroRef
                      REPORTE.glodoc 
                      REPORTE.T-importe  
                      REPORTE.T-debe
                      REPORTE.T-haber  
                      REPORTE.T-saldo
                      WITH FRAME T-CAB.
            DOWN STREAM REPORT WITH WITH FRAME T-CAB.
            Y-SALDO = (ACCUMULATE    TOTAL T-debe ) -
                      (ACCUMULATE    TOTAL T-haber) .
            DISPLAY STREAM REPORT
                    "T o t a l   G e n e r a l" @ REPORTE.glodoc
                    ACCUMULATE   TOTAL  T-debe  @ t-debe 
                    ACCUMULATE   TOTAL  T-haber @ t-haber
                    Y-SALDO                     @ t-saldo
                    WITH FRAME T-CAB.
            DOWN STREAM REPORT WITH FRAME T-CAB.    
         END. /* FIN DEL CON-CTA */

END. /* FIN DEL DO WITH */

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
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.
   
  RUN Carga-Temporal.
  
  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
  
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
  s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").

  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY + "report.prn".
  
  CASE s-salida-impresion:
        WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
        WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
        WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
  END CASE.

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.

  RUN Formato.
  
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN LIB/W-README.R(s-print-file).
  END CASE. 


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir-1 W-Win 
PROCEDURE Imprimir-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN bin/_mes.p ( INPUT c-mes , 1,  OUTPUT pinta-mes ).
    pinta-mes = "MES DE " + pinta-mes + " DE " + STRING( s-periodo , "9999" ).
    IF x-codmon = 1 THEN x-expres = "(EXPRESADO EN NUEVOS SOLES)".
    ELSE x-expres = "(EXPRESADO EN DOLARES)".
    x-nombala = "INCONSISTENCIAS DE CUENTAS POR COBRAR".
    
    RUN bin/_centrar.p ( INPUT pinta-mes, 40 , OUTPUT pinta-mes).
    RUN bin/_centrar.p ( INPUT x-expres,  40 , OUTPUT x-expres ).
    RUN bin/_centrar.p ( INPUT x-nombala, 50 , OUTPUT x-nombala).
           
    P-largo  = 66.
    P-Ancho  = FRAME T-cab:WIDTH.
    P-Copias = INPUT FRAME {&FRAME-NAME} RB-NUMBER-COPIES.
    P-pagIni = INPUT FRAME {&FRAME-NAME} RB-BEGIN-PAGE.
    P-pagfin = INPUT FRAME {&FRAME-NAME} RB-END-PAGE.
    P-select = INPUT FRAME {&FRAME-NAME} RADIO-SET-1.
    P-archivo= INPUT FRAME {&FRAME-NAME} RB-OUTPUT-FILE.
    P-detalle = "Impresora Local (EPSON)".
    P-name  = "Epson E/F/J/RX/LQ".
    P-device  = "PRN".

    IF P-select = 2 
    THEN P-archivo = SESSION:TEMP-DIRECTORY + 
          STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
    ELSE RUN setup-print.      
    IF P-select <> 1 
    THEN P-copias = 1.

  DO c-Copias = 1 to P-copias ON ERROR UNDO, LEAVE
                                ON STOP UNDO, LEAVE:
        OUTPUT STREAM report TO NUL PAGED PAGE-SIZE 1000.
        c-Pagina = 0.
        RUN FORMATO-1.
        OUTPUT STREAM report CLOSE.        
  END.
  OUTPUT STREAM report CLOSE.        
  HIDE FRAME F-Mensaje.  
  IF NOT LASTKEY = KEYCODE("ESC") AND P-select = 2 THEN DO: 
     RUN bin/_vcat.p ( P-archivo ). 
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
  C-Mes = s-Nromes.
  FOR EACH GN-DIVI WHERE gn-divi.codcia = s-codcia NO-LOCK:
    x-Div:ADD-LAST(gn-divi.coddiv) IN FRAME {&FRAME-NAME} .
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NEW-PAGE W-Win 
PROCEDURE NEW-PAGE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    c-Pagina = c-Pagina + 1.
    IF c-Pagina > P-pagfin
    THEN RETURN ERROR.
    DISPLAY c-Pagina WITH FRAME f-mensaje.
    IF c-Pagina > 1 THEN PAGE STREAM report.
    IF P-pagini = c-Pagina 
    THEN DO:
        OUTPUT STREAM report CLOSE.
        IF P-select = 1 
        THEN DO:
               OUTPUT STREAM report TO PRINTER NO-MAP NO-CONVERT UNBUFFERED
                    PAGED PAGE-SIZE 1000.
               PUT STREAM report CONTROL P-reset NULL P-flen NULL P-config NULL.
        END.
        ELSE DO:
            OUTPUT STREAM report TO VALUE ( P-archivo ) NO-MAP NO-CONVERT UNBUFFERED
                 PAGED PAGE-SIZE 1000.
            IF P-select = 3 THEN
                PUT STREAM report CONTROL P-reset P-flen P-config.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE T-NOM-AUX W-Win 
PROCEDURE T-NOM-AUX :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        CASE REPORTE.clfaux:
            WHEN "@CL" THEN DO:
                FIND gn-clie WHERE 
                     gn-clie.codcli  = REPORTE.codaux AND
                     gn-clie.CodCia = cl-codcia
                     NO-LOCK NO-ERROR. 
                IF AVAILABLE gn-clie THEN
                    x-nomaux = gn-clie.nomcli.
            END.
            WHEN "@PV" THEN DO:
                FIND gn-prov WHERE 
                     gn-prov.CodCia = pv-codcia AND
                     gn-prov.codpro = REPORTE.codaux
                     NO-LOCK NO-ERROR.                      
                IF AVAILABLE gn-prov THEN 
                    x-nomaux = gn-prov.nompro.
            END.
            WHEN "@CT" THEN DO:
                find cb-ctas WHERE 
                     cb-ctas.CodCia = cb-codcia AND
                     cb-ctas.codcta = REPORTE.codaux 
                     NO-LOCK NO-ERROR.                      
                IF AVAILABLE cb-ctas THEN 
                    x-nomaux = cb-ctas.nomcta.
            END.
            WHEN "" THEN DO:
                x-nomaux = "".
            END.
            OTHERWISE DO:
                FIND cb-auxi WHERE 
                     cb-auxi.CodCia = cb-codcia AND
                     cb-auxi.clfaux = REPORTE.clfaux AND
                     cb-auxi.codaux = REPORTE.codaux
                     NO-LOCK NO-ERROR.                      
                IF AVAILABLE cb-auxi THEN 
                    x-nomaux = cb-auxi.nomaux.
                ELSE
                    x-nomaux = "".
            END.
        END CASE.
            

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

