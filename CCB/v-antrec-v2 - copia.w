&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*------------------------------------------------------------------------
  File:
  Description: from VIEWER.W - Template for SmartViewer Objects
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
DEF SHARED VAR S-NOMCIA  AS CHAR.
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-coddiv  AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddoc  AS CHAR.
DEF SHARED VAR s-ptovta  AS INTE.
DEF SHARED VAR s-tipo    AS CHAR.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR lh_Handle AS HANDLE.
DEF SHARED VAR cl-codcia AS INT.

DEF VAR F-CODDOC AS CHAR INIT "A/R".
DEF VAR Y-CODMON AS INTEGER.
DEF VAR X-CTASOL AS CHAR INIT "122101".
DEF VAR X-CTADOL AS CHAR INIT "122102".

DEF BUFFER b-ccbccaja FOR ccbccaja.

DEF VAR RB-REPORT-LIBRARY AS CHAR NO-UNDO.
DEF VAR RB-REPORT-NAME AS CHAR NO-UNDO.
DEF VAR RB-INCLUDE-RECORDS AS CHAR NO-UNDO.
DEF VAR RB-FILTER AS CHAR NO-UNDO.
DEF VAR RB-OTHER-PARAMETERS AS CHAR NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES CcbCCaja
&Scoped-define FIRST-EXTERNAL-TABLE CcbCCaja


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCCaja.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCCaja.CodCli CcbCCaja.Codcta[10] ~
CcbCCaja.Glosa CcbCCaja.ImpNac[1] CcbCCaja.ImpUsa[1] CcbCCaja.ImpNac[4] ~
CcbCCaja.ImpUsa[4] CcbCCaja.CodBco[4] CcbCCaja.ImpNac[5] CcbCCaja.ImpUsa[5] ~
CcbCCaja.Voucher[5] CcbCCaja.CodBco[5] 
&Scoped-define ENABLED-TABLES CcbCCaja
&Scoped-define FIRST-ENABLED-TABLE CcbCCaja
&Scoped-Define ENABLED-OBJECTS RECT-6 RECT-33 RECT-34 RECT-35 RECT-36 ~
RECT-37 RECT-39 RECT-40 
&Scoped-Define DISPLAYED-FIELDS CcbCCaja.NroDoc CcbCCaja.CodDiv ~
CcbCCaja.FchDoc CcbCCaja.CodCli CcbCCaja.usuario CcbCCaja.TpoCmb ~
CcbCCaja.Codcta[10] CcbCCaja.Glosa CcbCCaja.ImpNac[1] CcbCCaja.ImpUsa[1] ~
CcbCCaja.ImpNac[4] CcbCCaja.ImpUsa[4] CcbCCaja.CodBco[4] CcbCCaja.ImpNac[5] ~
CcbCCaja.ImpUsa[5] CcbCCaja.Voucher[5] CcbCCaja.CodBco[5] 
&Scoped-define DISPLAYED-TABLES CcbCCaja
&Scoped-define FIRST-DISPLAYED-TABLE CcbCCaja
&Scoped-Define DISPLAYED-OBJECTS X-Status F-NomDiv F-Descli F-NroDoc ~
x-Nombr FILL-IN_Voucher4a FILL-IN_Voucher4b FILL-IN_Voucher4c ~
COMBO_TarjCred FILL-IN-4 FILL-IN-5 FILL-IN_SaldoBD fSumSol fSumDol ~
FILL-IN_Voucher4 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO_TarjCred AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE moneda AS CHARACTER FORMAT "X(256)":U 
     LABEL "Moneda" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "S/.","US$" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE F-Descli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.

DEFINE VARIABLE F-NomDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52 BY .81 NO-UNDO.

DEFINE VARIABLE F-NroDoc AS CHARACTER FORMAT "xxx-xxxxxx" 
     LABEL "Numero Doc" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .81
     BGCOLOR 15 FGCOLOR 9 .

DEFINE VARIABLE FILL-IN-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_SaldoBD AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Voucher4 AS CHARACTER FORMAT "x(16)" 
     LABEL "# de Tarjeta de Crédito" 
     VIEW-AS FILL-IN 
     SIZE 15.72 BY .81.

DEFINE VARIABLE FILL-IN_Voucher4a AS CHARACTER FORMAT "99" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_Voucher4b AS CHARACTER FORMAT "x(6)" INITIAL "xxxxxx" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81.

DEFINE VARIABLE FILL-IN_Voucher4c AS CHARACTER FORMAT "9999" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE fSumDol AS DECIMAL FORMAT "->>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE fSumSol AS DECIMAL FORMAT "->>>>,>>9.99":U INITIAL 0 
     LABEL "Total" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE x-Nombr AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .81 NO-UNDO.

DEFINE VARIABLE X-Status AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25 BY 3.77.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 13 BY 3.77.

DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18 BY 3.77.

DEFINE RECTANGLE RECT-36
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 7 BY 3.77.

DEFINE RECTANGLE RECT-37
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 30 BY 3.77.

DEFINE RECTANGLE RECT-39
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25 BY 1.35.

DEFINE RECTANGLE RECT-40
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 13 BY 1.35.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 93 BY .96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCCaja.NroDoc AT ROW 1.27 COL 10 COLON-ALIGNED FORMAT "XXX-XXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          FONT 6
     X-Status AT ROW 1.27 COL 79 COLON-ALIGNED
     CcbCCaja.CodDiv AT ROW 2.08 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.57 BY .81
     F-NomDiv AT ROW 2.08 COL 17 COLON-ALIGNED NO-LABEL
     CcbCCaja.FchDoc AT ROW 2.08 COL 79 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCCaja.CodCli AT ROW 2.88 COL 10 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     F-Descli AT ROW 2.88 COL 21 COLON-ALIGNED NO-LABEL
     CcbCCaja.usuario AT ROW 2.88 COL 79 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     F-NroDoc AT ROW 3.69 COL 10 COLON-ALIGNED
     CcbCCaja.TpoCmb AT ROW 3.69 COL 79 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCCaja.Codcta[10] AT ROW 4.5 COL 10 COLON-ALIGNED
          LABEL "Cond. Venta" FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     x-Nombr AT ROW 4.5 COL 19 COLON-ALIGNED NO-LABEL
     CcbCCaja.Glosa AT ROW 5.31 COL 12 NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-VERTICAL
          SIZE 73.29 BY 2.15
     moneda AT ROW 7.73 COL 10 COLON-ALIGNED HELP
          "Ingrese Moneda  --> Use flechas del cursor" WIDGET-ID 66
     CcbCCaja.ImpNac[1] AT ROW 9.88 COL 13 COLON-ALIGNED
          LABEL "Efectivo" FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 11 FGCOLOR 0 
     CcbCCaja.ImpUsa[1] AT ROW 9.88 COL 26 COLON-ALIGNED NO-LABEL FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 11 FGCOLOR 0 
     CcbCCaja.ImpNac[4] AT ROW 10.69 COL 13 COLON-ALIGNED WIDGET-ID 2
          LABEL "Tarjeta de crédito" FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 11 FGCOLOR 0 
     CcbCCaja.ImpUsa[4] AT ROW 10.69 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 4 FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FILL-IN_Voucher4a AT ROW 10.69 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     FILL-IN_Voucher4b AT ROW 10.69 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     FILL-IN_Voucher4c AT ROW 10.69 COL 49 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     CcbCCaja.CodBco[4] AT ROW 10.69 COL 57 COLON-ALIGNED NO-LABEL WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     COMBO_TarjCred AT ROW 10.69 COL 64 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-4 AT ROW 10.69 COL 82 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     CcbCCaja.ImpNac[5] AT ROW 11.5 COL 13 COLON-ALIGNED WIDGET-ID 54
          LABEL "Boleta de Depós." FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 11 FGCOLOR 0 
     CcbCCaja.ImpUsa[5] AT ROW 11.5 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 56 FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 11 FGCOLOR 0 
     CcbCCaja.Voucher[5] AT ROW 11.5 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 58
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     CcbCCaja.CodBco[5] AT ROW 11.5 COL 57 COLON-ALIGNED NO-LABEL WIDGET-ID 60
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     FILL-IN-5 AT ROW 11.5 COL 64 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     FILL-IN_SaldoBD AT ROW 11.5 COL 82 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     fSumSol AT ROW 12.85 COL 13 COLON-ALIGNED WIDGET-ID 46
     fSumDol AT ROW 12.85 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     FILL-IN_Voucher4 AT ROW 12.85 COL 64 COLON-ALIGNED WIDGET-ID 44
     "En US$" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 9.08 COL 29 WIDGET-ID 26
     "En S/." VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 9.08 COL 18 WIDGET-ID 24
     "Nro. Cta. Cte./Referencia" VIEW-AS TEXT
          SIZE 17.29 BY .5 AT ROW 9.08 COL 66 WIDGET-ID 30
     "F.Presen" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 9.08 COL 83.86 WIDGET-ID 22
     "Numero Documento" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 9.12 COL 40.86 WIDGET-ID 28
     "Banco" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 9.12 COL 58.43 WIDGET-ID 20
     "Detalle:" VIEW-AS TEXT
          SIZE 5.72 BY .5 AT ROW 5.58 COL 5
     RECT-6 AT ROW 8.81 COL 2 WIDGET-ID 18
     RECT-33 AT ROW 8.81 COL 2 WIDGET-ID 34
     RECT-34 AT ROW 8.81 COL 27 WIDGET-ID 36
     RECT-35 AT ROW 8.81 COL 40 WIDGET-ID 38
     RECT-36 AT ROW 8.81 COL 58 WIDGET-ID 40
     RECT-37 AT ROW 8.81 COL 65 WIDGET-ID 42
     RECT-39 AT ROW 12.58 COL 2 WIDGET-ID 50
     RECT-40 AT ROW 12.58 COL 27 WIDGET-ID 52
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.CcbCCaja
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 14.85
         WIDTH              = 103.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CcbCCaja.CodBco[5] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.CodCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCCaja.Codcta[10] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCCaja.CodDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO_TarjCred IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Descli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_SaldoBD IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Voucher4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Voucher4a IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Voucher4b IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Voucher4c IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN_Voucher4c:AUTO-RESIZE IN FRAME F-Main      = TRUE.

/* SETTINGS FOR FILL-IN fSumDol IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fSumSol IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR CcbCCaja.Glosa IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.ImpNac[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCCaja.ImpNac[4] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCCaja.ImpNac[5] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCCaja.ImpUsa[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCCaja.ImpUsa[4] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCCaja.ImpUsa[5] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR COMBO-BOX moneda IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN CcbCCaja.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCCaja.TpoCmb IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN x-Nombr IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN X-Status IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME CcbCCaja.CodBco[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.CodBco[4] V-table-Win
ON LEAVE OF CcbCCaja.CodBco[4] IN FRAME F-Main /* Banco[4] */
DO:
    FIND cb-tabl WHERE cb-tabl.Tabla = "04" AND
        cb-tabl.codigo = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE cb-tabl THEN FILL-IN-4:SCREEN-VALUE = cb-tabl.Nombre.
    ELSE FILL-IN-4:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCCaja.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.CodCli V-table-Win
ON LEAVE OF CcbCCaja.CodCli IN FRAME F-Main /* Cliente */
DO:

    DO WITH FRAME {&FRAME-NAME}:
        IF SELF:SCREEN-VALUE = "" THEN RETURN.
        FIND gn-clie WHERE
            gn-clie.CodCia = cl-codcia AND
            gn-clie.CodCli = CcbCCaja.CodCli:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-clie  THEN DO:
            MESSAGE
                "Código de cliente no existe"
                VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        DISPLAY gn-clie.NomCli @ F-Descli.
        IF gn-clie.CodCli BEGINS "11111111" THEN DO:
            F-Descli:SENSITIVE = TRUE.
            APPLY 'ENTRY':U TO F-Descli.
        END.
        ELSE F-Descli:SENSITIVE = FALSE.
    END. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCCaja.Codcta[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.Codcta[10] V-table-Win
ON LEAVE OF CcbCCaja.Codcta[10] IN FRAME F-Main /* Cond. Venta */
DO:
  x-Nombr:SCREEN-VALUE = ''.
  FIND Gn-convt WHERE Gn-convt.codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-convt THEN x-Nombr:SCREEN-VALUE = Gn-convt.nombr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Voucher4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher4 V-table-Win
ON LEAVE OF FILL-IN_Voucher4 IN FRAME F-Main /* # de Tarjeta de Crédito */
DO:

    IF FILL-IN_Voucher4:SCREEN-VALUE = FILL-IN_Voucher4 THEN RETURN.

    IF INPUT FILL-IN_Voucher4 = "" THEN DO:
        MESSAGE
            "Ingrese el numero de la Tarjeta de Crédito"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Voucher4a
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher4a V-table-Win
ON LEAVE OF FILL-IN_Voucher4a IN FRAME F-Main
DO:
    IF LENGTH(SELF:SCREEN-VALUE) <> 2 THEN DO:
        MESSAGE 'Solamente debe ingresar los 2 primeros dígitos' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    IF FILL-IN_Voucher4a:SCREEN-VALUE = FILL-IN_Voucher4a THEN RETURN.

    /* Armamos # de tarjeta */
    DEF VAR x-Ok AS LOG NO-UNDO.
    x-Ok = NO.

    FILL-IN_Voucher4:SCREEN-VALUE = FILL-IN_Voucher4a:SCREEN-VALUE + "xxxxxx" + FILL-IN_Voucher4c:SCREEN-VALUE.
    COMBO_TarjCred:DELETE(COMBO_TarjCred:LIST-ITEMS).
    FOR EACH FacTabla NO-LOCK WHERE FacTabla.codcia = s-codcia
        AND FacTabla.tabla = "TC"
        AND LENGTH(FacTabla.codigo) <= 2
        AND SELF:SCREEN-VALUE BEGINS FacTabla.Campo-C[1]
        BREAK BY FacTabla.Campo-C[1] DESC:
        COMBO_TarjCred:ADD-LAST(FacTabla.Codigo + " " + FacTabla.Nombre).
        IF FIRST-OF(FacTabla.Campo-C[1]) THEN DO:
            /* Se supone que el campo FacTabla.Valor[3] es igual en todos los casos */
            CASE TRUE:
                WHEN FacTabla.Valor[3] = 16 THEN FILL-IN_Voucher4c:FORMAT = "9999".
                WHEN FacTabla.Valor[3] = 14 THEN FILL-IN_Voucher4c:FORMAT = "99".
            END CASE.
            COMBO_TarjCred:SCREEN-VALUE = FacTabla.Codigo + " " + FacTabla.Nombre.
        END.
        x-Ok = YES.
    END.
    IF x-Ok = NO THEN DO:
        MESSAGE 'Debe ingresar número válidos' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    IF INPUT FILL-IN_Voucher4a = "" THEN DO:
        MESSAGE
            "Ingrese el numero de la Tarjeta de Crédito"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Voucher4b
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher4b V-table-Win
ON LEAVE OF FILL-IN_Voucher4b IN FRAME F-Main
DO:

    IF FILL-IN_Voucher4:SCREEN-VALUE = FILL-IN_Voucher4 THEN RETURN.

    IF INPUT FILL-IN_Voucher4 = "" THEN DO:
        MESSAGE
            "Ingrese el numero de la Tarjeta de Crédito"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Voucher4c
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher4c V-table-Win
ON LEAVE OF FILL-IN_Voucher4c IN FRAME F-Main
DO:
    IF FILL-IN_Voucher4c:SCREEN-VALUE = FILL-IN_Voucher4c THEN RETURN.
    IF FILL-IN_Voucher4c:FORMAT = "9999"
        AND LENGTH(SELF:SCREEN-VALUE) <> 4
        THEN DO:
        MESSAGE 'Debe ingresar los 4 últimos dígitos' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    IF FILL-IN_Voucher4c:FORMAT = "99"
        AND LENGTH(SELF:SCREEN-VALUE) <> 2
        THEN DO:
        MESSAGE 'Debe ingresar los 2 últimos dígitos' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    /* Armamos # de tarjeta */
    FILL-IN_Voucher4:SCREEN-VALUE = FILL-IN_Voucher4a:SCREEN-VALUE + "xxxxxx" + FILL-IN_Voucher4c:SCREEN-VALUE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCCaja.ImpNac[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.ImpNac[1] V-table-Win
ON LEAVE OF CcbCCaja.ImpNac[1] IN FRAME F-Main /* Efectivo */
DO:
    RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCCaja.ImpNac[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.ImpNac[4] V-table-Win
ON LEAVE OF CcbCCaja.ImpNac[4] IN FRAME F-Main /* Tarjeta de crédito */
DO:
    IF DECIMAL(CcbCCaja.ImpNac[4]:SCREEN-VALUE) > 0 THEN
        CcbCCaja.ImpUsa[4]:SENSITIVE = FALSE.
    ELSE CcbCCaja.ImpUsa[4]:SENSITIVE = TRUE.
    RUN _habilita.
    RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCCaja.ImpNac[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.ImpNac[5] V-table-Win
ON LEAVE OF CcbCCaja.ImpNac[5] IN FRAME F-Main /* Boleta de Depós. */
DO:
    IF DECIMAL(SELF:SCREEN-VALUE) > FILL-IN_SaldoBD THEN DO:
        MESSAGE "Este monto es mayor al saldo" SKIP
            "de la boleta de deposito"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCCaja.ImpUsa[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.ImpUsa[1] V-table-Win
ON LEAVE OF CcbCCaja.ImpUsa[1] IN FRAME F-Main /* Importe US$[1] */
DO:
    RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCCaja.ImpUsa[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.ImpUsa[4] V-table-Win
ON LEAVE OF CcbCCaja.ImpUsa[4] IN FRAME F-Main /* Importe US$[4] */
DO:
    IF DECIMAL(CcbCCaja.ImpUsa[4]:SCREEN-VALUE) > 0 THEN
        CcbCCaja.ImpNac[4] :SENSITIVE = FALSE.
    ELSE CcbCCaja.ImpNac[4] :SENSITIVE = TRUE.
    RUN _habilita.
    RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCCaja.ImpUsa[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.ImpUsa[5] V-table-Win
ON LEAVE OF CcbCCaja.ImpUsa[5] IN FRAME F-Main /* Importe US$[5] */
DO:
    IF DECIMAL(SELF:SCREEN-VALUE) > FILL-IN_SaldoBD THEN DO:
        MESSAGE "Este monto es mayor al saldo" SKIP
            "de la boleta de deposito"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    RUN Calculo.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME moneda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL moneda V-table-Win
ON RETURN OF moneda IN FRAME F-Main /* Moneda */
DO:
    APPLY "TAB":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL moneda V-table-Win
ON VALUE-CHANGED OF moneda IN FRAME F-Main /* Moneda */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        IF moneda:SCREEN-VALUE = "S/." THEN y-CodMon = 1.
        ELSE y-CodMon = 2.
        CcbCCaja.CodBco[5]:SCREEN-VALUE = ''.
        CcbCCaja.Voucher[5]:SCREEN-VALUE = ''.
        DISPLAY 0 @ CcbCCaja.ImpNac[5].
        DISPLAY 0 @ CcbCCaja.ImpUsa[5].
        IF Y-CodMon = 1 THEN DO:       
            CcbCcaja.ImpNac[1]:SENSITIVE = YES.
            CcbCcaja.ImpNac[4]:SENSITIVE = YES.
            CcbCcaja.ImpUsa[1]:SENSITIVE = NO.
            CcbCcaja.ImpUsa[4]:SENSITIVE = NO.
            DISPLAY 0 @ CcbCcaja.ImpUsa[1].
            DISPLAY 0 @ CcbCcaja.ImpUsa[4].
        END.
        IF Y-CodMon = 2 THEN DO:
            DISPLAY 0 @ CcbCcaja.ImpNac[1].
            DISPLAY 0 @ CcbCcaja.ImpNac[4].
            CcbCcaja.ImpNac[1]:SENSITIVE = NO.
            CcbCcaja.ImpNac[4]:SENSITIVE = NO.
            CcbCcaja.ImpUsa[1]:SENSITIVE = YES.
            CcbCcaja.ImpUsa[4]:SENSITIVE = YES.
        END.
        RUN Calculo.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCCaja.Voucher[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCCaja.Voucher[5] V-table-Win
ON LEAVE OF CcbCCaja.Voucher[5] IN FRAME F-Main /* Voucher[5] */
DO:
    IF TRUE <> (CcbCCaja.Voucher[5]:SCREEN-VALUE > "") THEN DO:
        ASSIGN
            CcbCCaja.ImpNac[5]:SCREEN-VALUE = "0"
            CcbCCaja.ImpUsa[5]:SCREEN-VALUE = "0"
            FILL-IN_SaldoBD = 0
            CcbCCaja.CodBco[5]:SCREEN-VALUE = ""
            FILL-IN-5       = ""
            FILL-IN-5:SENSITIVE = FALSE.
        DO WITH FRAME {&FRAME-NAME}:
            DISPLAY
                FILL-IN_SaldoBD
                .

        END.
        RUN Calculo.
        RETURN.
    END.
    FIND CcbCDocu WHERE CcbCDocu.CodCia = S-CodCia AND  
        CcbCDocu.CodDoc = "BD" AND  
        CcbCDocu.CodCli = CcbCCaja.CodCli:SCREEN-VALUE AND  
        CcbCDocu.nrodoc = CcbCCaja.Voucher[5]:SCREEN-VALUE AND
        CcbCDocu.flgest = "P" NO-LOCK NO-ERROR.
    IF AVAILABLE CcbCDocu THEN DO:
        IF Ccbcdocu.CodMon <> y-CodMon THEN DO:
            MESSAGE "La moneda de la Boleta de Depósito no coincide con la moneda seleccionada"
                VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        /* ********************************************* */
        /* RHC 06/11/2015 Restricciones aprobadas por SL */
        /* ********************************************* */
        IF CcbCCaja.CodCli:SCREEN-VALUE = FacCfgGn.CliVar THEN DO:
            MESSAGE 'NO procede para clientes' FacCfgGn.CliVar VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        /* Dentro del año comercial */
        IF Ccbcdoc.FchDoc < ADD-INTERVAL(TODAY,-1,'years') THEN DO:
            MESSAGE 'Solo se permiten boletas de depósito dentro del año comercial'
                VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        /* ********************************************* */
        IF CcbCDocu.CodMon = 1 THEN DO:
            ASSIGN
                CcbCCaja.ImpNac[5]:SCREEN-VALUE = STRING(CcbCDocu.SdoAct)
                CcbCCaja.ImpUsa[5]:SCREEN-VALUE = "0".
        END.
        ELSE DO:
            ASSIGN
                CcbCCaja.ImpUsa[5]:SCREEN-VALUE = STRING(CcbCDocu.SdoAct)
                CcbCCaja.ImpNac[5]:SCREEN-VALUE = "0".
        END.
        ASSIGN 
            FILL-IN_SaldoBD = CcbCDocu.SdoAct.
        FIND cb-tabl WHERE cb-tabl.Tabla = "04" AND
            cb-tabl.codigo = CcbCDocu.FlgAte
            NO-LOCK NO-ERROR.
        IF AVAILABLE cb-tabl THEN
            ASSIGN
                CcbCCaja.CodBco[5]:SCREEN-VALUE = cb-tabl.codigo
                FILL-IN-5 = cb-tabl.Nombre.
        ELSE 
            ASSIGN
                CcbCCaja.CodBco[5]:SCREEN-VALUE = ""
                FILL-IN-5 = "".
        DO WITH FRAME {&FRAME-NAME}:     
            DISPLAY
                FILL-IN-5                
                FILL-IN_SaldoBD.
        END.
    END.
    ELSE DO:
        MESSAGE
            "Nro. de Documento no Registrado" SKIP
            "o no pertenece al Cliente Seleccionado"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "CcbCCaja"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCCaja"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculo V-table-Win 
PROCEDURE Calculo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    fSumSol = DECIMAL(CcbCCaja.ImpNac[1]:SCREEN-VALUE) + DECIMAL(CcbCCaja.ImpNac[4]:SCREEN-VALUE).
    fSumDol = DECIMAL(CcbCCaja.ImpUsa[1]:SCREEN-VALUE) + DECIMAL(CcbCCaja.ImpUsa[4]:SCREEN-VALUE).
    fSumSol = fSumSol + DECIMAL(CcbCCaja.ImpNac[5]:SCREEN-VALUE).
    fSumDol = fSumDol + DECIMAL(CcbCCaja.ImpUsa[5]:SCREEN-VALUE).
    DISPLAY fSumSol fSumDol.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cancelar-Documento V-table-Win 
PROCEDURE Cancelar-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND FIRST FacCorre WHERE
        FacCorre.CodCia = s-codcia AND
        FacCorre.Coddiv = s-coddiv AND
        FacCorre.CodDoc = f-coddoc
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCorre THEN RETURN 'ADM-ERROR'.
    CREATE CcbCDocu.
    ASSIGN
        CcbCDocu.Codcia = S-CODCIA
        CcbCDocu.CodDiv = S-CODDIV
        CcbCDocu.Coddoc = F-CODDOC
        CcbCDocu.NroDoc = STRING(faccorre.nroser, "999") + STRING(faccorre.correlativo, "999999")
        CcbCDocu.CodCli = CcbCcaja.Codcli
        CcbCDocu.NomCli = CcbCcaja.Nomcli
        CcbCDocu.CodRef = CcbCcaja.CodDoc
        CcbCDocu.NroRef = CcbCcaja.NroDoc
        CcbCDocu.FchDoc = TODAY
        CcbCDocu.FchVto = TODAY
        CcbCDocu.CodMon = Y-CODMON
        CcbCDocu.Usuario = S-USER-ID            
        CcbCCaja.Voucher[1] = STRING(F-Coddoc,"X(3)") + CcbCDocu.NroDoc
        CcbCDocu.FlgEst = "P"
        FacCorre.Correlativo = FacCorre.Correlativo + 1
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
        UNDO, RETURN 'ADM-ERROR'.
    END.
    IF Y-CodMon = 2 THEN DO:
        ASSIGN
            CcbCDocu.ImpTot = CcbCcaja.ImpUsa[1] + CcbCcaja.ImpUsa[4] + CcbCcaja.ImpUsa[5].
            /*CcbCDocu.SdoAct = CcbCcaja.ImpUsa[1].*/
    END.
    IF Y-CodMon = 1 THEN DO:
        ASSIGN
            CcbCDocu.ImpTot = CcbCcaja.ImpNac[1] + CcbCcaja.ImpNac[4] + CcbCcaja.ImpNac[5].
            /*CcbCDocu.SdoAct = CcbCcaja.ImpNac[1].*/
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  /* RHC 28/03/2016 Rutrina que verifica que no haya un cierre de caja pendiente */
  RUN ccb/control-cierre-caja (s-codcia,s-coddiv,s-user-id,s-codter).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  DEFINE VARIABLE lAnswer AS LOGICAL NO-UNDO.

  /* Verifica Monto Tope por CAJA */
  RUN ccb\p-vermtoic (OUTPUT lAnswer).
  IF lAnswer THEN RETURN ERROR.

  /* Busca I/C tipo "Sencillo" Activo */
  IF NOT s-codter BEGINS "ATE" THEN DO:
      lAnswer = FALSE.
      FOR EACH b-ccbccaja WHERE b-ccbccaja.codcia = s-codcia AND
          b-ccbccaja.coddiv = s-coddiv AND
          b-ccbccaja.coddoc = "I/C" AND
          b-ccbccaja.tipo = "SENCILLO" AND
          b-ccbccaja.usuario = s-user-id AND
          b-ccbccaja.codcaja = s-codter AND
          b-ccbccaja.flgcie = "P" NO-LOCK:
          IF b-ccbccaja.flgest <> "A" THEN lAnswer = TRUE.
      END.
      IF NOT lAnswer THEN DO:
          MESSAGE "Se debe ingresar el I/C SENCILLO como primer movimiento"
              VIEW-AS ALERT-BOX ERROR.
          RETURN ERROR.
      END.
  END.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ).

  /* Code placed here will execute AFTER standard behavior.    */
  RUN proc_enable IN lh_Handle ( INPUT FALSE ).
  DO WITH FRAME {&FRAME-NAME}:
      MONEDA = "S/.". 
      Y-CODMON = 1.
      FIND LAST gn-tccja WHERE gn-tccja.Fecha <= TODAY 
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-tccja THEN DISPLAY gn-tccja.Compra @ CcbCCaja.TpoCmb.
      DISPLAY
          TODAY @ CcbCCaja.FchDoc
          S-USER-ID @ CcbCcaja.Usuario
          S-CODDIV @ CcbCCaja.CodDiv
          MONEDA.
      CcbCCaja.Codcli:SCREEN-VALUE = "".
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    DO WITH FRAME {&FRAME-NAME}:
        FIND FacCorre WHERE 
            FacCorre.CodCia = s-codcia AND
            FacCorre.CodDoc = s-coddoc AND 
            FacCorre.NroSer = s-ptovta
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE FacCorre THEN UNDO, RETURN 'ADM-ERROR'.
        ASSIGN
            CcbCCaja.CodCia  = s-codcia
            CcbCCaja.CodDoc  = s-coddoc
            CcbCCaja.NroDoc  = STRING(faccorre.nroser, "999") + STRING(faccorre.correlativo, "999999")
            CcbCCaja.CodDiv  = S-CODDIV
            CcbCCaja.Tipo    = s-tipo
            CcbCCaja.usuario = s-user-id
            CcbCCaja.CodCaja = S-CODTER
            CcbCCaja.FchDoc  = TODAY
            CcbCCaja.TpoCmb  = DECI(CcbCCaja.TpoCmb:SCREEN-VALUE)
            CcbCCaja.ImpNac[1] = DECI(CcbCCaja.ImpNac[1]:SCREEN-VALUE)
            CcbCCaja.ImpUsa[1] = DECI(CcbCCaja.ImpUsa[1]:SCREEN-VALUE)
            CcbcCaja.Flgest    = "C"
            CcbCCaja.Voucher[1] = STRING(F-Coddoc,"X(3)") +
                STRING(F-Nrodoc:SCREEN-VALUE,"X(9)")
            CcbCCaja.NomCli = F-DesCli:SCREEN-VALUE
            CcbCCaja.Voucher[10] = STRING(TIME,"HH:MM:SS").
        FacCorre.Correlativo = FacCorre.Correlativo + 1.     
        IF Y-CodMon = 2 THEN DO:
            CcbCCaja.CodCta[1] = X-CTADOL.
        END.
        IF Y-CodMon = 1 THEN DO:
            CcbCCaja.CodCta[1] = X-CTASOL.
        END.
        /* *************** */
        ASSIGN
            CcbCCaja.Voucher[4] = FILL-IN_Voucher4:SCREEN-VALUE
            CcbCCaja.Voucher[9] = COMBO_TarjCred:SCREEN-VALUE.
        /* *************** */
        CREATE CcbDCaja.
        ASSIGN
            CcbDCaja.CodCia = CcbCCaja.CodCia   
            CcbDCaja.CodDoc = CcbCCaja.CodDoc
            CcbDCaja.NroDoc = CcbCCaja.NroDoc
            CcbDCaja.CodMon = Y-CodMon
            CcbDCaja.CodRef = CcbCCaja.CodDoc
            CcbDCaja.NroRef = CcbCCaja.NroDoc
            CcbDCaja.FchDoc = CcbCCaja.FchDoc
            CcbDCaja.CodDiv = CcbCCaja.CodDiv
            CcbDCaja.TpoCmb = CcbCCaja.TpoCmb.
        IF Y-CodMon = 1 THEN DO:
            CcbDCaja.ImpTot = CcbCCaja.ImpNac[1] + CcbCCaja.ImpNac[4] + CcbCCaja.ImpNac[5].
        END.
        IF Y-CodMon = 2 THEN DO:
            CcbDCaja.ImpTot = CcbCCaja.ImpUsa[1] + CcbCCaja.ImpUsa[4] + CcbCCaja.ImpUsa[5].
        END.
        RUN Cancelar-Documento.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        /* Actualiza la Boleta de Deposito */
        IF CcbCCaja.Voucher[5] > "" AND
            (CcbCCaja.ImpNac[5] + CcbCCaja.ImpUsa[5]) > 0 THEN DO:
            RUN proc_AplicaDoc("BD",
                               CcbCCaja.Voucher[5],
                               ccbccaja.nrodoc,
                               CcbCCaja.tpocmb,
                               CcbCCaja.ImpNac[5],
                               CcbCCaja.ImpUsa[5]
                               ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.

    END.
    IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
    IF AVAILABLE(FacCorre) THEN RELEASE faccorre.

    F-Descli:SENSITIVE = FALSE.
    RUN proc_enable IN lh_Handle ( INPUT TRUE ).
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    DO WITH FRAME {&FRAME-NAME}:
        F-Descli:SENSITIVE = FALSE.
    END.
    RUN proc_enable IN lh_Handle ( INPUT TRUE ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

/* Correo Susana Leon 23Jun2017 */
MESSAGE "NO se permite ANULACION"
    VIEW-AS ALERT-BOX ERROR.

RETURN "ADM-ERROR".

    IF ccbccaja.flgcie = "C" THEN DO:
        MESSAGE "Ya se hizo el cierre de caja" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    IF ccbccaja.flgest = "A" THEN DO:
        MESSAGE
            "Registro ya fue Anulado"
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""}

    DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
        FIND CcbCdocu WHERE
            CcbCdocu.CodCia = s-codcia AND
            CcbCdocu.CodDiv = S-CODDIV AND
            CcbCdocu.CodDoc = F-Coddoc AND
            CcbCdocu.NroDoc = INPUT FRAME {&FRAME-NAME} F-Nrodoc
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE CcbCdocu THEN DO:
            MESSAGE
                'Anticipo no se encuentra registrado'
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.
        IF CcbCdocu.SdoAct <> CcbCdocu.ImpTot THEN DO:
            MESSAGE
                'Anticipo presenta cancelaciones'
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.
        ASSIGN
            CcbCdocu.SdoAct = 0
            CcbCdocu.FlgEst = "A".
        FOR EACH ccbdcaja OF ccbccaja:
            DELETE ccbdcaja.
        END.
        FIND b-ccbccaja WHERE ROWID(b-ccbccaja) = ROWID(ccbccaja) EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE B-CCBCCAJA THEN UNDO, RETURN 'ADM-ERROR'.
        ASSIGN 
            b-ccbccaja.flgest = "A"
            b-ccbccaja.usranu = s-user-id
            b-ccbccaja.fchanu = TODAY
            b-ccbccaja.horanu = STRING(TIME, 'HH:MM:SS').
        RELEASE b-ccbccaja.
    END.

    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FILL-IN_Voucher4a:SENSITIVE = NO.
      FILL-IN_Voucher4c:SENSITIVE = NO.
      COMBO_TarjCred:SENSITIVE = NO.
      moneda:SENSITIVE = NO.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE CcbCCaja THEN DO WITH FRAME {&FRAME-NAME}:
      IF CcbCCaja.FlgEst = "A" THEN X-Status:SCREEN-VALUE = " ANULADO ".
      IF CcbCCaja.FlgEst = "C" THEN X-Status:SCREEN-VALUE = " PENDIENTE".
      IF CcbCCaja.FlgEst = "P" THEN X-Status:SCREEN-VALUE = " PENDIENTE".
      IF CcbCCaja.FlgEst = " " THEN X-Status:SCREEN-VALUE = " PENDIENTE".
      IF CcbCCaja.FlgCie = "C" THEN X-Status:SCREEN-VALUE = " CERRADO ".
      DISPLAY CcbCCaja.NomCli @ F-Descli SUBSTRING(CcbCCaja.Voucher[1],4,15) @ F-NroDoc.
      IF CcbCCaja.ImpNac[1] + CcbCCaja.ImpNac[4] + CcbCCaja.ImpNac[5] <> 0 THEN DO:
          moneda = "S/.".
      END.
      IF CcbCCaja.ImpUsa[1] + CcbCCaja.ImpUsa[4] + CcbCCaja.ImpUsa[5] <> 0 THEN DO:
          moneda = "US$" .
      END.
      DISPLAY moneda.

      x-Nombr:SCREEN-VALUE = ''.
      FIND Gn-convt WHERE Gn-convt.codig = CcbCCaja.Codcta[10] NO-LOCK NO-ERROR.
      IF AVAILABLE GN-convt THEN x-Nombr:SCREEN-VALUE = gn-ConVt.Nombr.
      /* ********************** */
      DISPLAY
          CcbCCaja.Voucher[4] @ FILL-IN_Voucher4
          SUBSTRING(CcbCCaja.Voucher[4],1,2) @ FILL-IN_Voucher4a
          SUBSTRING(CcbCCaja.Voucher[4],8)   @ FILL-IN_Voucher4c

          .
      ASSIGN
          COMBO_TarjCred:SCREEN-VALUE = CcbCCaja.Voucher[9].
      RUN Calculo.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      CcbCCaja.ImpUsa[1]:SENSITIVE = NO.
      CcbCCaja.ImpUsa[4]:SENSITIVE = NO.
      CcbCCaja.ImpNac[5]:SENSITIVE = NO.
      CcbCCaja.ImpUsa[5]:SENSITIVE = NO.
      CcbCCaja.CodBco[5]:SENSITIVE = NO.
      moneda:SENSITIVE = YES.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR s-titulo AS CHAR NO-UNDO.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    IF CcbcCaja.Flgest = "A" THEN DO:
        MESSAGE
            "Recibo Anulado. Verifique"
            VIEW-AS ALERT-BOX.
        RETURN.
    END.

    s-titulo = STRING(Ccbccaja.Nrodoc,"999-999999").

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb/rbccb.prl"
        RB-REPORT-NAME = "Anticipos v2"
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER =
            "Ccbccaja.Codcia = " + string(S-CODCIA,"999") +
            " AND Ccbccaja.Coddoc = '" + S-CODDOC + "'" +
            " AND Ccbccaja.Nrodoc = '" + STRING(Ccbccaja.Nrodoc, 'x(12)') + "'"
        RB-OTHER-PARAMETERS =
            "s-nomcia = " + s-nomcia +
            "~ns-titulo = " + s-titulo.

    RUN lib/_Imprime2(
        RB-REPORT-LIBRARY,
        RB-REPORT-NAME,
        RB-INCLUDE-RECORDS,
        RB-FILTER,
        RB-OTHER-PARAMETERS).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
      COMBO_TarjCred:DELETE(COMBO_TarjCred:LIST-ITEMS).
      FOR EACH FacTabla NO-LOCK WHERE FacTabla.codcia = s-codcia
          AND FacTabla.tabla = "TC"
          AND LENGTH(FacTabla.codigo) <= 2
        BREAK BY FacTabla.Campo-C[1] DESC:
        COMBO_TarjCred:ADD-LAST(FacTabla.Codigo + " " + FacTabla.Nombre).
    END.
  END.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros V-table-Win 
PROCEDURE procesa-parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_AplicaDoc V-table-Win 
PROCEDURE proc_AplicaDoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_CodDoc LIKE CcbCDocu.CodDoc.
    DEFINE INPUT PARAMETER para_NroDoc LIKE CcbDMov.NroDoc.
    DEFINE INPUT PARAMETER para_NroDocCja LIKE CcbDMov.NroDoc.    
    DEFINE INPUT PARAMETER para_TpoCmb LIKE CCBDMOV.TpoCmb.
    DEFINE INPUT PARAMETER para_ImpNac LIKE CcbDMov.ImpTot.
    DEFINE INPUT PARAMETER para_ImpUSA LIKE CcbDMov.ImpTot.

    DEFINE BUFFER B-CDocu FOR CcbCDocu.

    /* Tipo de Documento */
    FIND FacDoc WHERE
        FacDoc.CodCia = s-CodCia AND
        FacDoc.CodDoc = para_CodDoc
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacDoc THEN DO:
        MESSAGE
            para_CodDoc 'NO CONFIGURADO'
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        /* Busca Documento */
        FIND FIRST B-CDocu WHERE
            B-CDocu.CodCia = s-codcia AND
            B-CDocu.CodDoc = para_CodDoc AND
            B-CDocu.NroDoc = para_NroDoc
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE B-CDocu THEN DO:
            MESSAGE
                "DOCUMENTO" para_CodDoc para_NroDoc "NO REGISTRADO"
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.
        /* Crea Detalle de la Aplicación */
        CREATE CCBDMOV.
        ASSIGN
            CCBDMOV.CodCia = s-CodCia
            CCBDMOV.CodDiv = s-CodDiv
            CCBDMOV.NroDoc = B-CDocu.NroDoc
            CCBDMOV.CodDoc = B-CDocu.CodDoc
            CCBDMOV.CodMon = B-CDocu.CodMon
            CCBDMOV.CodRef = s-CodDoc
            CCBDMOV.NroRef = para_NroDocCja
            CCBDMOV.CodCli = B-CDocu.CodCli
            CCBDMOV.FchDoc = B-CDocu.FchDoc
            CCBDMOV.HraMov = STRING(TIME,"HH:MM:SS")
            CCBDMOV.TpoCmb = para_tpocmb
            CCBDMOV.usuario = s-User-ID.
        IF B-CDocu.CodMon = 1 THEN
            ASSIGN CCBDMOV.ImpTot = para_ImpNac.
        ELSE ASSIGN CCBDMOV.ImpTot = para_ImpUSA.
        IF FacDoc.TpoDoc THEN
            ASSIGN B-CDocu.SdoAct = B-CDocu.SdoAct + CCBDMOV.ImpTot.
        ELSE
            ASSIGN B-CDocu.SdoAct = B-CDocu.SdoAct - CCBDMOV.ImpTot.
        /* Cancela Documento */
        IF B-CDocu.SdoAct = 0 THEN
            ASSIGN 
                B-CDocu.FlgEst = "C"
                B-CDocu.FchCan = TODAY.
        ELSE
            ASSIGN
                B-CDocu.FlgEst = "P"
                B-CDocu.FchCan = ?.
        /* RHC 26/08/2015 Chequeo adicional */
        IF B-CDOCU.SdoAct < 0 THEN DO:
            MESSAGE 'ERROR en el saldo del documento:' B-CDocu.coddoc B-CDocu.nrodoc SKIP
                'Proceso Abortado'
                VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END. /* DO TRANSACTION... */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros V-table-Win 
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
        WHEN "Voucher" THEN 
            ASSIGN
                input-var-1 = CcbCCaja.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                input-var-2 = "P"
                input-var-3 = "Autorizada".
        WHEN "CodCta" THEN ASSIGN input-var-1 = "1".
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "CcbCCaja"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
    DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

    IF p-state = 'update-begin':U THEN DO:
        RUN valida-update.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
    END.

    CASE p-state:
        /* Object instance CASEs can go here to replace standard behavior
           or add new cases. */
        {src/adm/template/vstates.i}
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     Validacion de datos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Realizar la PREGUNTA */
  MESSAGE 'Una vez GRABADO no hay ANULACION ni MODIFICACION' SKIP
      'Esta seguro de GRABAR?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN "ADM-ERROR".

  DO WITH FRAME {&FRAME-NAME} :
      IF CcbCCaja.CodCli:SCREEN-VALUE = FacCfgGn.CliVar THEN DO:
          MESSAGE 'NO se puede registrar a un cliente genérico'
              VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
      FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
          AND gn-clie.CodCli = CcbCCaja.CodCli:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-clie  THEN DO:
          MESSAGE "Codigo de cliente no existe"
              VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO CcbCCaja.CodCli.
          RETURN "ADM-ERROR".
      END.
      /* ************************************************************************* */
      /* RHC Control del RUC y DNI */
      /* ************************************************************************* */
      DEF VAR pResultado AS CHAR.
      CASE TRUE:
          WHEN gn-clie.Libre_C01 = "J" 
              THEN DO:
              IF LENGTH(gn-clie.Ruc) < 11 OR LOOKUP(SUBSTRING(gn-clie.Ruc,1,2), '20') = 0 THEN DO:
                  MESSAGE 'ERROR en el RUC del cliente' SKIP
                      'RUC:' gn-clie.Ruc SKIP
                      'Debe tener 11 dígitos y comenzar con 20' SKIP
                      'Hacer las correcciones en el maestro de clientes'
                      VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO CcbCCaja.CodCli.
                  RETURN 'ADM-ERROR'.
              END.
              /* dígito verificador */
              RUN lib/_ValRuc (gn-clie.Ruc, OUTPUT pResultado).
              IF pResultado = 'ERROR' THEN DO:
                  MESSAGE 'ERROR en el RUC del cliente' SKIP
                      'RUC:' gn-clie.Ruc SKIP
                      'Código mal registrado' SKIP
                      'Hacer las correcciones en el maestro de clientes'
                      VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO CcbCCaja.CodCli.
                  RETURN 'ADM-ERROR'.
              END.
          END.
          WHEN gn-clie.Libre_C01 = "E" AND LOOKUP(SUBSTRING(gn-clie.Ruc,1,2), '15,17') > 0 THEN DO:
              IF LENGTH(gn-clie.Ruc) < 11 THEN DO:
                  MESSAGE 'ERROR en el RUC del cliente' SKIP
                      'RUC:' gn-clie.Ruc SKIP
                      'Debe tener 11 dígitos y comenzar con 15 ó 17' SKIP
                      'Hacer las correcciones en el maestro de clientes'
                      VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO CcbCCaja.CodCli.
                  RETURN 'ADM-ERROR'.
              END.
              /* dígito verificador */
              RUN lib/_ValRuc (gn-clie.Ruc, OUTPUT pResultado).
              IF pResultado = 'ERROR' THEN DO:
                  MESSAGE 'ERROR en el RUC del cliente' SKIP
                      'RUC:' gn-clie.Ruc SKIP
                      'Código mal registrado' SKIP
                      'Hacer las correcciones en el maestro de clientes'
                      VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO CcbCCaja.CodCli.
                  RETURN 'ADM-ERROR'.
              END.
          END.
      END CASE.
      /* ************************************************************************* */
      /* SOLO OPENORANGE */
      DEF VAR pClienteOpenOrange AS LOG NO-UNDO.
      RUN gn/clienteopenorange (cl-codcia, CcbCCaja.CodCli:SCREEN-VALUE, s-CodDoc, OUTPUT pClienteOpenOrange).
      IF pClienteOpenOrange = YES THEN DO:
          MESSAGE "Cliente NO se puede antender por Continental" SKIP
              "Solo se le puede antender por OpenOrange"
              VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO CcbCCaja.CodCli.
          RETURN "ADM-ERROR".   
      END.
      IF DECI(CcbCCaja.ImpNac[1]:SCREEN-VALUE) + 
          DECI(CcbCCaja.ImpNac[4]:SCREEN-VALUE) + 
          DECI(CcbCCaja.ImpNac[5]:SCREEN-VALUE) + 
          DECI(CcbCCaja.ImpUsa[1]:SCREEN-VALUE) +
          DECI(CcbCCaja.ImpUsa[4]:SCREEN-VALUE) +
          DECI(CcbCCaja.ImpUsa[5]:SCREEN-VALUE) = 0 THEN DO:
          MESSAGE "Importe no debe ser cero" VIEW-AS ALERT-BOX ERROR.
          IF y-codmon = 1 THEN APPLY "ENTRY" TO CcbCCaja.ImpNac[1].
          IF y-codmon = 2 THEN APPLY "ENTRY" TO CcbCCaja.ImpUsa[1].
          RETURN "ADM-ERROR".      
      END.
      IF CcbCCaja.Codcta[10]:SCREEN-VALUE <> '' THEN DO:
          FIND Gn-convt WHERE Gn-convt.codig = CcbCCaja.Codcta[10]:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF NOT AVAILABLE GN-convt THEN DO:
              MESSAGE "Condicion de venta no existe"
                  VIEW-AS ALERT-BOX ERROR.
              APPLY "ENTRY" TO CcbCCaja.CodCta[10].
              RETURN "ADM-ERROR".
          END.
      END.

      /* Pago con Tarjeta de Credito */
      IF DECIMAL(Ccbccaja.ImpNac[4]:SCREEN-VALUE) <> 0 OR 
          DECIMAL(Ccbccaja.ImpUsa[4]:SCREEN-VALUE) <> 0 THEN DO:
          IF TRUE <> (FILL-IN_Voucher4:SCREEN-VALUE > "") THEN DO:
              MESSAGE "Ingrese el nro de la tarjeta de crédito"
                  VIEW-AS ALERT-BOX ERROR.
              RETURN "ADM-ERROR".
          END.
          IF COMBO_TarjCred:SCREEN-VALUE EQ ? OR
              COMBO_TarjCred:SCREEN-VALUE EQ "" THEN DO:
              MESSAGE
                  "Seleccione una tarjeta de crédito"
                  VIEW-AS ALERT-BOX ERROR.
              APPLY 'ENTRY':U TO COMBO_TarjCred.
              RETURN "ADM-ERROR".
          END.
      END.

      /* RHC Pago con BD */
      IF CcbCCaja.Voucher[5]:SCREEN-VALUE > '' THEN DO:
          FIND CcbCDocu WHERE CcbCDocu.CodCia = S-CodCia AND  
              CcbCDocu.CodDoc = "BD" AND  
              CcbCDocu.CodCli = CcbCCaja.CodCli:SCREEN-VALUE AND  
              CcbCDocu.nrodoc = CcbCCaja.Voucher[5]:SCREEN-VALUE AND
              CcbCDocu.flgest = "P" NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Ccbcdocu OR
              Ccbcdocu.sdoact <> DECIMAL(CcbCCaja.ImpNac[5]:SCREEN-VALUE) + 
              DECIMAL(CcbCCaja.ImpUsa[5]:SCREEN-VALUE)
              THEN DO:
              MESSAGE 'El saldo de la Boleta de Depósito ha cambiado' VIEW-AS ALERT-BOX ERROR.
              APPLY 'ENTRY':U TO CcbCCaja.Voucher[5].
              RETURN 'ADM-ERROR'.
          END.
      END.
  END.

  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/

RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _habilita V-table-Win 
PROCEDURE _habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    IF DECIMAL(CcbCCaja.ImpNac[4]:SCREEN-VALUE) <> 0 OR 
        DECIMAL(CcbCCaja.ImpUsa[4]:SCREEN-VALUE) <> 0 THEN DO:
        ASSIGN
            FILL-IN_Voucher4a:SENSITIVE = TRUE 
            FILL-IN_Voucher4c:SENSITIVE = TRUE 
            CcbCCaja.CodBco[4]:SENSITIVE = TRUE
            COMBO_TarjCred:SENSITIVE = TRUE.
    END.
    ELSE DO:
        ASSIGN
            FILL-IN_Voucher4:SCREEN-VALUE = "" 
            CcbCCaja.CodBco[4]:SCREEN-VALUE = ""
            COMBO_TarjCred:SCREEN-VALUE = ""
            FILL-IN-4:SCREEN-VALUE = ""
            FILL-IN_Voucher4:SENSITIVE = FALSE 
            CcbCCaja.CodBco[4]:SENSITIVE = FALSE
            COMBO_TarjCred:SENSITIVE = FALSE.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

