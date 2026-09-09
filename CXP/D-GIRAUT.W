&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
DEFINE VARIABLE I-NROROL AS INTEGER NO-UNDO.
DEFINE VARIABLE X-CTABCO AS CHAR NO-UNDO.
DEFINE VARIABLE X-CODOPE AS CHAR NO-UNDO.

{BIN/S-GLOBAL.I}
{CXP/CPGLOBAL.I}

DEFINE STREAM report.
DEFINE VARIABLE RECID-stack AS RECID  NO-UNDO.
DEFINE VARIABLE x-nomope   AS CHARACTER FORMAT "X(40)" NO-UNDO.

DEFINE VARIABLE x-NroAst    AS INTEGER   NO-UNDO.
DEFINE VARIABLE x-Llave     AS CHARACTER NO-UNDO INITIAL "".
DEFINE VARIABLE x-ImpMn1    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE x-ImpMn2    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE x-ImpMn3    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE S-NROMESCie AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE VARIABLE x-totalMN1  AS DECIMAL   NO-UNDO.
DEFINE VARIABLE x-totalMN2  AS DECIMAL   NO-UNDO.
DEFINE VARIABLE x-totalch1  AS DECIMAL   NO-UNDO.
DEFINE VARIABLE x-totalch2  AS DECIMAL   NO-UNDO.
DEFINE VARIABLE x-coddoc    AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-nrodoc    AS CHARACTER NO-UNDO.
DEFINE VARIABLE RECID-cab   AS RECID     NO-UNDO.
DEFINE VARIABLE RECID-tmp   AS RECID     NO-UNDO.
DEFINE VARIABLE RegAct      AS RECID     NO-UNDO.
DEFINE VARIABLE x-GloDoc    AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-GenAut    AS INTEGER   NO-UNDO.
DEFINE VARIABLE x-CodMon    AS INTEGER   NO-UNDO.
DEFINE VARIABLE LAST-CodMon AS INTEGER   NO-UNDO INITIAL 1.
DEFINE VARIABLE i           AS INTEGER   NO-UNDO.
DEFINE VARIABLE x           AS INTEGER   NO-UNDO.
DEFINE VARIABLE c           AS CHARACTER NO-UNDO.
DEFINE VARIABLE Lleva       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE pto         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE x-NroChq    AS INTEGER   NO-UNDO.
DEFINE VARIABLE x-NroItm    AS INTEGER   NO-UNDO.
DEFINE VARIABLE s-nrochq    AS CHARACTER NO-UNDO.

FIND Empresas WHERE Empresas.CodCia = s-codcia.

DEFINE BUFFER CABECERA FOR cb-cmov.
DEFINE BUFFER DETALLE  FOR cb-dmov.
DEFINE TEMP-TABLE VMOV LIKE cb-cmov.
DEFINE BUFFER B-DROL   FOR CP-DROL.

FIND FIRST cb-cfga WHERE cb-cfga.CodCia = cb-codcia AND cb-cfga.CodCfg = 1
      NO-LOCK  NO-ERROR.

X-CODOPE = cb-cfga.cjaEgr.
/*
message x-codope cb-codcia view-as alert-box.
*/
FIND cb-oper WHERE cb-oper.CodCia = cb-codcia 
              AND  cb-oper.Codope = X-CODOPE 
             NO-LOCK NO-ERROR.
     
IF NOT AVAILABLE cb-oper THEN DO:
   MESSAGE "Error en configuracion" SKIP
           "No Existe la Operaci¢n" SKIP
           "Caja Egresos"  x-codope VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

x-nomope = cb-oper.NomOpe.

FIND cb-peri WHERE cb-peri.CodCia = S-CODCIA AND
     cb-peri.Periodo = S-PERIODO NO-LOCK.
IF AVAILABLE cb-peri AND cb-peri.MesCie[S-NROMES + 1] THEN DO:
   MESSAGE "Mes cerrado, registro no puede ser alterado" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

FIND LAST cp-crol WHERE cp-crol.codcia = S-CODCIA AND
           cp-crol.periodo = S-PERIODO AND
           NOT cp-crol.flgest  NO-LOCK NO-ERROR.
IF NOT AVAILABLE cp-crol THEN DO:
    BELL.
    MESSAGE "No existe rol de pago pendiente" VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

FIND FIRST cp-drol WHERE cp-drol.codcia = S-CODCIA AND
           cp-drol.periodo = S-PERIODO  AND
           NOT cp-drol.flgpgo NO-LOCK NO-ERROR.
IF NOT AVAIL cp-drol THEN DO:
    BELL.
    MESSAGE "No existe cronograma pendiente" VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

DEF VAR Cta-PerDcb LIKE cb-ctas.CODCTA.
DEF VAR Cta-GanDcb LIKE cb-ctas.CODCTA.
DEF VAR Cta-PerTrl LIKE cb-ctas.CODCTA.
DEF VAR Cta-GanTrl LIKE cb-ctas.CODCTA.

/* Configuraci¢n de la diferencia de Cambio */
/* ---------------------------------------- */
FIND integral.cb-cfgg WHERE integral.cb-cfgg.CodCia = cb-codcia
    AND integral.cb-cfgg.Codcfg = "C01" NO-LOCK NO-ERROR.
    
IF NOT AVAILABLE integral.cb-cfgg
THEN DO:
    MESSAGE "Cuentas de diferencia    " SKIP
            "de cambio no configuradas" SKIP
            "        < C01 >          " 
            VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
IF cb-cfgg.codcta[1] = "" OR cb-cfgg.codcta[2] = ""
THEN DO:
    MESSAGE "Cuentas de diferencia" SKIP
            "de cambio mal configuradas < C02> " VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
Cta-PerDcb = cb-cfgg.codcta[1].
Cta-GanDcb = cb-cfgg.codcta[2].


/* Configuraci¢n Traslaci¢n */
/* ---------------------------------------- */
FIND integral.cb-cfgg WHERE integral.cb-cfgg.CodCia = cb-codcia
    AND integral.cb-cfgg.Codcfg = "C02" NO-LOCK NO-ERROR.
IF NOT AVAILABLE integral.cb-cfgg
THEN DO:
    MESSAGE "Cuentas de diferencia    " SKIP
            "de cambio no configuradas" SKIP
            "        < C02 >          " 
            VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
IF integral.cb-cfgg.codcta[1] = "" OR integral.cb-cfgg.codcta[2] = ""
THEN DO:
    MESSAGE "Cuentas de diferencia" SKIP
            "de cambio mal configuradas < C02> " VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
Cta-PerTrl = cb-cfgg.codcta[1].
Cta-GanTrl = cb-cfgg.codcta[2].

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME Brw-BRol

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES integral.cp-brol integral.cp-crol ~
integral.cp-drol

/* Definitions for BROWSE Brw-BRol                                      */
&Scoped-define FIELDS-IN-QUERY-Brw-BRol integral.cp-brol.ctabco ~
integral.cp-brol.NomBco 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Brw-BRol 
&Scoped-define FIELD-PAIRS-IN-QUERY-Brw-BRol
&Scoped-define OPEN-QUERY-Brw-BRol OPEN QUERY Brw-BRol FOR EACH integral.cp-brol ~
      WHERE integral.cp-brol.CodCia = S-CODCIA ~
 AND integral.cp-brol.Periodo = S-PERIODO ~
 AND cp-brol.Nromes = S-NROMES ~
 AND integral.cp-brol.Nrorol = I-NROROL NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-Brw-BRol integral.cp-brol
&Scoped-define FIRST-TABLE-IN-QUERY-Brw-BRol integral.cp-brol


/* Definitions for BROWSE Brw-CRol                                      */
&Scoped-define FIELDS-IN-QUERY-Brw-CRol integral.cp-crol.Nrorol ~
integral.cp-crol.CodDiv integral.cp-crol.Fch-pgo-1 ~
integral.cp-crol.Fch-pgo-2 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Brw-CRol 
&Scoped-define FIELD-PAIRS-IN-QUERY-Brw-CRol
&Scoped-define OPEN-QUERY-Brw-CRol OPEN QUERY Brw-CRol FOR EACH integral.cp-crol ~
      WHERE integral.cp-crol.CodCia = S-CODCIA ~
 AND integral.cp-crol.Periodo = S-PERIODO ~
 AND cp-crol.Nromes = S-NROMES ~
 AND NOT integral.cp-crol.Flgest NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-Brw-CRol integral.cp-crol
&Scoped-define FIRST-TABLE-IN-QUERY-Brw-CRol integral.cp-crol


/* Definitions for BROWSE Brw-DRol                                      */
&Scoped-define FIELDS-IN-QUERY-Brw-DRol integral.cp-drol.Coddoc ~
integral.cp-drol.Nrodoc integral.cp-drol.Codaux ~
(IF (integral.cp-drol.Codmon = 1) THEN ("S/.") ELSE ("US$")) ~
integral.cp-drol.Importe integral.cp-drol.imppgo integral.cp-drol.NomAux ~
integral.cp-drol.CodBco 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Brw-DRol 
&Scoped-define FIELD-PAIRS-IN-QUERY-Brw-DRol
&Scoped-define OPEN-QUERY-Brw-DRol OPEN QUERY Brw-DRol FOR EACH integral.cp-drol ~
      WHERE cp-drol.CodCia = S-CODCIA ~
 AND cp-drol.Periodo = S-PERIODO ~
 AND cp-drol.NroMes = S-NROMES ~
 AND cp-drol.Nrorol = I-NROROL ~
 AND cp-drol.ctabco = X-CTABCO ~
 AND NOT cp-drol.FlgPgo NO-LOCK ~
    BY integral.cp-drol.FchVto ~
       BY integral.cp-drol.Codaux ~
        BY integral.cp-drol.Coddoc INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-Brw-DRol integral.cp-drol
&Scoped-define FIRST-TABLE-IN-QUERY-Brw-DRol integral.cp-drol


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-Brw-BRol}~
    ~{&OPEN-QUERY-Brw-CRol}~
    ~{&OPEN-QUERY-Brw-DRol}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-15 Brw-CRol Brw-BRol Brw-DRol F-FchAst ~
F-TpoCmb F-NroChq Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-soles F-DOLAR F-FchAst F-TpoCmb F-NroChq 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE F-DOLAR AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "Dolares (US$)" 
     VIEW-AS FILL-IN 
     SIZE 13.43 BY .69 NO-UNDO.

DEFINE VARIABLE F-FchAst AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Asiento" 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .69 NO-UNDO.

DEFINE VARIABLE F-NroChq AS CHARACTER FORMAT "X(256)":U 
     LABEL "Numero de Cheque" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .69 NO-UNDO.

DEFINE VARIABLE F-soles AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "Soles (S/.)" 
     VIEW-AS FILL-IN 
     SIZE 13.43 BY .69 NO-UNDO.

DEFINE VARIABLE F-TpoCmb AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "Tipo de Cambio" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80.29 BY 1.23.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Brw-BRol FOR 
      integral.cp-brol SCROLLING.

DEFINE QUERY Brw-CRol FOR 
      integral.cp-crol SCROLLING.

DEFINE QUERY Brw-DRol FOR 
      integral.cp-drol SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE Brw-BRol
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS Brw-BRol D-Dialog _STRUCTURED
  QUERY Brw-BRol NO-LOCK DISPLAY
      integral.cp-brol.ctabco COLUMN-LABEL "Banco"
      integral.cp-brol.NomBco FORMAT "X(35)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 37 BY 3.5
         FONT 4
         TITLE "Bancos".

DEFINE BROWSE Brw-CRol
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS Brw-CRol D-Dialog _STRUCTURED
  QUERY Brw-CRol NO-LOCK DISPLAY
      integral.cp-crol.Nrorol COLUMN-LABEL "No. Rol"
      integral.cp-crol.CodDiv COLUMN-LABEL "Division"
      integral.cp-crol.Fch-pgo-1 COLUMN-LABEL "Vcmto. Desde"
      integral.cp-crol.Fch-pgo-2 COLUMN-LABEL "Vcmto. Hasta"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 42.86 BY 3.5
         BGCOLOR 15 FONT 4
         TITLE BGCOLOR 15 "Programaciones Pendientes".

DEFINE BROWSE Brw-DRol
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS Brw-DRol D-Dialog _STRUCTURED
  QUERY Brw-DRol NO-LOCK DISPLAY
      integral.cp-drol.Coddoc COLUMN-LABEL "C¢digo!docum"
      integral.cp-drol.Nrodoc COLUMN-LABEL "N£mero de!documento" FORMAT "x(12)"
      integral.cp-drol.Codaux COLUMN-LABEL "C¢digo!auxiliar" FORMAT "x(10)"
      (IF (integral.cp-drol.Codmon = 1) THEN ("S/.") ELSE ("US$")) COLUMN-LABEL "Mon!doc" FORMAT "x(3)"
      integral.cp-drol.Importe COLUMN-LABEL "Importe del!documento"
      integral.cp-drol.imppgo COLUMN-LABEL "Importe a!cancelar"
      integral.cp-drol.NomAux FORMAT "X(40)"
      integral.cp-drol.CodBco COLUMN-LABEL "Cod!Bco" FORMAT "x(3)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 80.29 BY 5.88
         BGCOLOR 15 FONT 4
         TITLE BGCOLOR 15 "Documentos Pendientes".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     Brw-CRol AT ROW 1 COL 1
     Brw-BRol AT ROW 1 COL 44.29
     Brw-DRol AT ROW 4.65 COL 1
     F-soles AT ROW 10.62 COL 39.86 COLON-ALIGNED
     F-DOLAR AT ROW 10.62 COL 65.43 COLON-ALIGNED
     F-FchAst AT ROW 11.73 COL 13.29 COLON-ALIGNED
     F-TpoCmb AT ROW 11.73 COL 38.57 COLON-ALIGNED
     F-NroChq AT ROW 11.73 COL 66.29 COLON-ALIGNED
     Btn_OK AT ROW 12.96 COL 23.43
     Btn_Cancel AT ROW 12.96 COL 48.86
     RECT-15 AT ROW 11.5 COL 1.29
     SPACE(0.55) SKIP(2.07)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Giro Automatico de Cheques".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   NOT-VISIBLE L-To-R                                                   */
/* BROWSE-TAB Brw-CRol RECT-15 D-Dialog */
/* BROWSE-TAB Brw-BRol Brw-CRol D-Dialog */
/* BROWSE-TAB Brw-DRol Brw-BRol D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

ASSIGN 
       Brw-DRol:NUM-LOCKED-COLUMNS IN FRAME D-Dialog = 2.

/* SETTINGS FOR FILL-IN F-DOLAR IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-soles IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE Brw-BRol
/* Query rebuild information for BROWSE Brw-BRol
     _TblList          = "integral.cp-brol"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "integral.cp-brol.CodCia = S-CODCIA
 AND integral.cp-brol.Periodo = S-PERIODO
 AND cp-brol.Nromes = S-NROMES
 AND integral.cp-brol.Nrorol = I-NROROL"
     _FldNameList[1]   > integral.cp-brol.ctabco
"cp-brol.ctabco" "Banco" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   > integral.cp-brol.NomBco
"cp-brol.NomBco" ? "X(35)" "character" ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE Brw-BRol */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE Brw-CRol
/* Query rebuild information for BROWSE Brw-CRol
     _TblList          = "integral.cp-crol"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "integral.cp-crol.CodCia = S-CODCIA
 AND integral.cp-crol.Periodo = S-PERIODO
 AND cp-crol.Nromes = S-NROMES
 AND NOT integral.cp-crol.Flgest"
     _FldNameList[1]   > integral.cp-crol.Nrorol
"cp-crol.Nrorol" "No. Rol" ? "integer" ? ? ? ? ? ? no ?
     _FldNameList[2]   > integral.cp-crol.CodDiv
"cp-crol.CodDiv" "Division" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > integral.cp-crol.Fch-pgo-1
"cp-crol.Fch-pgo-1" "Vcmto. Desde" ? "date" ? ? ? ? ? ? no ?
     _FldNameList[4]   > integral.cp-crol.Fch-pgo-2
"cp-crol.Fch-pgo-2" "Vcmto. Hasta" ? "date" ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE Brw-CRol */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE Brw-DRol
/* Query rebuild information for BROWSE Brw-DRol
     _TblList          = "integral.cp-drol"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "integral.cp-drol.FchVto|yes,integral.cp-drol.Codaux|yes,integral.cp-drol.Coddoc|yes"
     _Where[1]         = "cp-drol.CodCia = S-CODCIA
 AND cp-drol.Periodo = S-PERIODO
 AND cp-drol.NroMes = S-NROMES
 AND cp-drol.Nrorol = I-NROROL
 AND cp-drol.ctabco = X-CTABCO
 AND NOT cp-drol.FlgPgo"
     _FldNameList[1]   > integral.cp-drol.Coddoc
"cp-drol.Coddoc" "C¢digo!docum" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   > integral.cp-drol.Nrodoc
"cp-drol.Nrodoc" "N£mero de!documento" "x(12)" "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > integral.cp-drol.Codaux
"cp-drol.Codaux" "C¢digo!auxiliar" "x(10)" "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   > "_<CALC>"
"(IF (integral.cp-drol.Codmon = 1) THEN (""S/."") ELSE (""US$""))" "Mon!doc" "x(3)" ? ? ? ? ? ? ? no ?
     _FldNameList[5]   > integral.cp-drol.Importe
"cp-drol.Importe" "Importe del!documento" ? "decimal" ? ? ? ? ? ? no ?
     _FldNameList[6]   > integral.cp-drol.imppgo
"cp-drol.imppgo" "Importe a!cancelar" ? "decimal" ? ? ? ? ? ? no ?
     _FldNameList[7]   > integral.cp-drol.NomAux
"cp-drol.NomAux" ? "X(40)" "character" ? ? ? ? ? ? no ?
     _FldNameList[8]   > integral.cp-drol.CodBco
"cp-drol.CodBco" "Cod!Bco" "x(3)" "character" ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE Brw-DRol */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Giro Automatico de Cheques */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME Brw-BRol
&Scoped-define SELF-NAME Brw-BRol
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Brw-BRol D-Dialog
ON ITERATION-CHANGED OF Brw-BRol IN FRAME D-Dialog /* Bancos */
DO:
  X-CtaBco = {&FIRST-TABLE-IN-QUERY-Brw-BRol}.CtaBco.
  {&OPEN-QUERY-Brw-DRol}
  FIND cb-ctas WHERE cb-ctas.CodCia = CB-CodCia AND
                     cb-ctas.CodCta = X-CtaBco NO-LOCK NO-ERROR.
  IF AVAILABLE cb-ctas THEN F-NroChq = cb-ctas.nrochq.
  DISPLAY F-NroChq WITH FRAME {&FRAME-NAME}.
  RUN Calcula-Total.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Brw-BRol D-Dialog
ON ROW-DISPLAY OF Brw-BRol IN FRAME D-Dialog /* Bancos */
DO:
  X-CtaBco = {&FIRST-TABLE-IN-QUERY-Brw-BRol}.CtaBco.
  {&OPEN-QUERY-Brw-DRol}
  FIND cb-ctas WHERE cb-ctas.CodCia = CB-CodCia AND
                     cb-ctas.CodCta = X-CtaBco NO-LOCK NO-ERROR.
  IF AVAILABLE cb-ctas THEN F-NroChq = cb-ctas.nrochq.
  DISPLAY F-NroChq WITH FRAME {&FRAME-NAME}.
  RUN Calcula-Total.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Brw-BRol D-Dialog
ON VALUE-CHANGED OF Brw-BRol IN FRAME D-Dialog /* Bancos */
DO:
  X-CtaBco = {&FIRST-TABLE-IN-QUERY-Brw-BRol}.CtaBco.
  {&OPEN-QUERY-Brw-DRol}
  FIND cb-ctas WHERE cb-ctas.CodCia = CB-CodCia AND
                     cb-ctas.CodCta = X-CtaBco NO-LOCK NO-ERROR.
  IF AVAILABLE cb-ctas THEN F-NroChq = cb-ctas.nrochq.
  DISPLAY F-NroChq WITH FRAME {&FRAME-NAME}.
  RUN Calcula-Total.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME Brw-CRol
&Scoped-define SELF-NAME Brw-CRol
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Brw-CRol D-Dialog
ON ITERATION-CHANGED OF Brw-CRol IN FRAME D-Dialog /* Programaciones Pendientes */
DO:
  I-NroRol = {&FIRST-TABLE-IN-QUERY-Brw-CRol}.NroRol.
  F-NroChq:SCREEN-VALUE = {&FIRST-TABLE-IN-QUERY-Brw-CRol}.NroChq. 
  {&OPEN-QUERY-Brw-BRol}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Brw-CRol D-Dialog
ON VALUE-CHANGED OF Brw-CRol IN FRAME D-Dialog /* Programaciones Pendientes */
DO:
  I-NroRol = {&FIRST-TABLE-IN-QUERY-Brw-CRol}.NroRol.
  F-NroChq:SCREEN-VALUE = {&FIRST-TABLE-IN-QUERY-Brw-CRol}.NroChq. 
  {&OPEN-QUERY-Brw-BRol}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN F-FchAst F-NroChq F-TpoCmb.
  IF F-NroChq = "" THEN DO:
     MESSAGE "Ingrese el n£mero inicial de cheques" VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY" TO F-NroChq.
     RETURN NO-APPLY.
  END.
  s-nrochq = F-NroChq.
  RUN Procesa-Giro-1.
  RUN Procesa-Giro-2.
  RUN Cierra-Cronograma.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-FchAst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-FchAst D-Dialog
ON LEAVE OF F-FchAst IN FRAME D-Dialog /* Fecha de Asiento */
DO:
  IF INPUT F-FchAst = ? THEN RETURN.
  FIND gn-tcmb WHERE gn-tcmb.FECHA = INPUT F-FchAst NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb THEN DO:
     F-TpoCmb = gn-tcmb.Venta.
     DISPLAY F-TpoCmb WITH FRAME {&FRAME-NAME}.
  END.
  ELSE  MESSAGE "Tipo de cambio no registrado" VIEW-AS ALERT-BOX ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME Brw-BRol
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Acumula D-Dialog 
PROCEDURE Acumula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF cb-dmov.TpoMov THEN     /* Tipo D */
        ASSIGN cb-cmov.HbeMn1 = cb-cmov.HbeMn1 + cb-dmov.ImpMn1
               cb-cmov.HbeMn2 = cb-cmov.HbeMn2 + cb-dmov.ImpMn2
               cb-cmov.HbeMn3 = cb-cmov.HbeMn3 + cb-dmov.ImpMn3.
    ELSE
        ASSIGN cb-cmov.DbeMn1 = cb-cmov.DbeMn1 + cb-dmov.ImpMn1
               cb-cmov.DbeMn2 = cb-cmov.DbeMn2 + cb-dmov.ImpMn2
               cb-cmov.DbeMn3 = cb-cmov.DbeMn3 + cb-dmov.ImpMn3.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aplica-Dif D-Dialog 
PROCEDURE Aplica-Dif :
/*------------------------------------------------------------------------------
  Purpose: Aplicaci¢n de diferencia de cambio
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER XsCodCta LIKE cb-ctas.codcta.
DEFINE INPUT PARAMETER XlTpoMov AS LOGICAL.
DEFINE INPUT PARAMETER XfImpMn1 AS DECIMAL.
DEFINE INPUT PARAMETER XfImpMn2 AS DECIMAL.
DEFINE INPUT PARAMETER X-Recid  AS RECID.

DEFINE VAR iCodMon AS INTEGER.


IF XfImpMn1 = 0 AND XfImpMn2 = 0 THEN RETURN.

FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                   cb-ctas.CodCta = XsCodCta NO-LOCK NO-ERROR.
                   
IF NOT AVAILABLE cb-ctas THEN DO:
   MESSAGE "Error   : DIFERENCIA DE CAMBIO/TRASLACION " SKIP
            "Cuenta  : " + XsCodCta                     SKIP
            "No registrada"
            VIEW-AS ALERT-BOX ERROR.
    RETURN.        
END.

FIND FIRST Detalle WHERE RECID(Detalle) = x-Recid
           NO-LOCK NO-ERROR.

IF XfImpMn1 = 0 THEN iCodMon = 2.
   ELSE iCodMon = 1.

IF NOT AVAILABLE Detalle THEN RETURN.
   CREATE cb-dmov.
   ASSIGN cb-dmov.codcia  = detalle.CodCia
          cb-dmov.periodo = detalle.Periodo
          cb-dmov.nromes  = detalle.NroMes
          cb-dmov.codope  = detalle.CodOpe
          cb-dmov.nroast  = detalle.NroAst
          cb-dmov.codcta  = XsCodCta
          cb-dmov.codmon  = iCodMon
          cb-dmov.Tpocmb  = 0
          cb-dmov.TpoMov  = XlTpoMov
          cb-dmov.ImpMn1  = XfImpMn1
          cb-dmov.ImpMn2  = XfImpMn2
          cb-dmov.coddoc  = detalle.CodDoc
          cb-dmov.nrodoc  = detalle.nrodoc
          cb-dmov.TpoItm  = "D"
          cb-dmov.clfaux  = detalle.ClfAux
          cb-dmov.codaux  = detalle.CodAux
          cb-dmov.glodoc  = detalle.glodoc
          cb-dmov.nroitm  = x-nroitm
          cb-dmov.coddiv  = detalle.Coddiv
          cb-dmov.relacion = x-recid.
                       
    RegAct = RECID( cb-dmov ).
    RUN cbd/cb-acmd.p(RegAct, YES , YES).
    RUN Acumula.
       
    /*GENERACION DE CUENTAS AUTOMATICAS */
    /* Grabamos datos para la generaci¢n de Cuentas Autom ticas */
    x-GenAut = 0.
    /* Verificamos si la Cuenta genera automaticas de Clase 9 */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut9 ):
        IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut9 ) THEN DO:
           IF ENTRY( i, cb-cfga.GenAut9) <> "" THEN DO:
              x-GenAut = 1.
              LEAVE.
            END.
        END.
    END.
    /* Verificamos si la Cuenta genera automaticas de Clase 6 */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut6 ):
       IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut6 ) THEN DO:
          IF ENTRY( i, cb-cfga.GenAut6) <> "" THEN DO:
             x-GenAut = 2.
             LEAVE.
          END.
       END.
    END.
    /* Verificamos si la Cuenta genera automaticas de otro tipo */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut ):
        IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut ) THEN DO:
           IF ENTRY( i, cb-cfga.GenAut) <> "" THEN DO:
              x-GenAut = 3.
              LEAVE.
           END.
        END.
    END.

    ASSIGN cb-dmov.CtaAut = ""
           cb-dmov.CtrCta = "".

    CASE x-GenAut:
        /* Genera Cuentas Clase 9 */
        WHEN 1 THEN DO:
            ASSIGN cb-dmov.CtrCta = cb-ctas.Cc1Cta.
            IF cb-dmov.CLFAUX = "@CT" THEN cb-dmov.CtaAut = cb-dmov.CodAux.
            ELSE cb-dmov.CtaAut = cb-ctas.An1Cta.
            IF cb-dmov.CtrCta = "" THEN cb-dmov.CtrCta = cb-cfga.Cc1Cta9.
        END.
        /* Genera Cuentas Clase 6 */
        WHEN 2 THEN DO:
            ASSIGN cb-dmov.CtaAut = cb-ctas.An1Cta
                   cb-dmov.CtrCta = cb-ctas.Cc1Cta.
            IF cb-dmov.CtrCta = "" THEN cb-dmov.CtrCta = cb-cfga.Cc1Cta6.
        END.
        WHEN 3 THEN DO:
            ASSIGN cb-dmov.CtaAut = cb-ctas.An1Cta
                   cb-dmov.CtrCta = cb-ctas.Cc1Cta.
        END.
    END CASE.

    /* Chequendo las cuentas a generar en forma autom ticas */

    IF x-GenAut > 0 THEN DO:
       IF NOT CAN-FIND( cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
          cb-ctas.CodCta = cb-dmov.CtaAut ) AND LENGTH( cb-dmov.CtaAut)  <>
          INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles)) THEN DO:
          MESSAGE "Cuentas Autom ticas a generar" SKIP
                  "Tienen mal registro" VIEW-AS ALERT-BOX ERROR.
       END.
       IF NOT CAN-FIND( cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
          cb-ctas.CodCta = cb-dmov.CtrCta ) AND LENGTH( cb-dmov.CtrCta )  <>
          INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles)) THEN DO:
          MESSAGE "Cuentas Autom ticas a generar" SKIP
                  "Tienen mal registro" VIEW-AS ALERT-BOX ERROR.
       END.
    END.
    RUN Automaticas.
    FIND DETALLE WHERE RECID(DETALLE) = X-Recid.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Automaticas D-Dialog 
PROCEDURE Automaticas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Borrando las cuentas autom ticas generadas antes */
FOR EACH detalle WHERE detalle.Relacion = RegAct:    
    IF DETALLE.TpoMov THEN /* Tipo H */
       ASSIGN cb-cmov.HbeMn1 = cb-cmov.HbeMn1 - DETALLE.ImpMn1
              cb-cmov.HbeMn2 = cb-cmov.HbeMn2 - DETALLE.ImpMn2.           
    ELSE
       ASSIGN cb-cmov.DbeMn1 = cb-cmov.DbeMn1 - DETALLE.ImpMn1
              cb-cmov.DbeMn2 = cb-cmov.DbeMn2 - DETALLE.ImpMn2.
                
    DELETE DETALLE.
END.

/* Generando las cuentas autom ticas */
IF cb-dmov.CtrCta <> "" THEN DO:
   FIND integral.cb-ctas WHERE integral.cb-ctas.CodCia = cb-codcia
        AND integral.cb-ctas.CodCta = cb-dmov.CodCta NO-LOCK NO-ERROR.
        ASSIGN x-ImpMn1 = cb-dmov.ImpMn1
               x-ImpMn2 = cb-dmov.ImpMn2
        
        RECID-stack = 0.
        
        IF cb-dmov.CtaAut <> "" THEN DO:
           x-NroItm = x-NroItm + 1.
           CREATE DETALLE.
           ASSIGN DETALLE.CodCia   = cb-dmov.CodCia
                  DETALLE.Periodo  = cb-dmov.Periodo
                  DETALLE.NroMes   = cb-dmov.NroMes
                  DETALLE.CodOpe   = cb-dmov.CodOpe
                  DETALLE.NroAst   = cb-dmov.NroAst
                  DETALLE.TpoItm   = "A"
                  DETALLE.Relacion = RECID(cb-dmov)
                  DETALLE.CodMon   = cb-dmov.CodMon
                  DETALLE.TpoCmb   = cb-dmov.TpoCmb
                  DETALLE.NroItm   = x-NroItm
                  DETALLE.Codcta   = cb-dmov.CtaAut
                  DETALLE.CodDiv   = cb-dmov.CodDiv
                  DETALLE.ClfAux   = cb-dmov.CodAux
                  DETALLE.CodAux   = cb-dmov.CodCta
                  DETALLE.NroRuc   = cb-dmov.NroRuc
                  DETALLE.CodDoc   = cb-dmov.CodDoc
                  DETALLE.NroDoc   = cb-dmov.NroDoc
                  DETALLE.GloDoc   = cb-dmov.GloDoc
                  DETALLE.CodMon   = cb-dmov.CodMon
                  DETALLE.TpoCmb   = cb-dmov.TpoCmb
                  DETALLE.TpoMov   = cb-dmov.TpoMov
                  DETALLE.NroRef   = cb-dmov.NroRef
                  DETALLE.FchDoc   = cb-dmov.FchDoc
                  DETALLE.FchVto   = cb-dmov.FchVto
                  DETALLE.CodDiv   = cb-dmov.CodDiv
                  DETALLE.CCO      = cb-dmov.CCO
                  DETALLE.TM       = cb-dmov.TM
                  DETALLE.IMPMN1   = cb-dmov.IMPMN1
                  DETALLE.IMPMN2   = cb-dmov.IMPMN2.
                     

                RUN cbd/cb-acmd.p(RECID(DETALLE), YES , YES).
                
                IF DETALLE.TpoMov THEN     /* Tipo H */
                    ASSIGN cb-cmov.HbeMn1 = cb-cmov.HbeMn1 + DETALLE.ImpMn1
                           cb-cmov.HbeMn2 = cb-cmov.HbeMn2 + DETALLE.ImpMn2.
                    
                ELSE
                    ASSIGN cb-cmov.DbeMn1 = cb-cmov.DbeMn1 + DETALLE.ImpMn1
                           cb-cmov.DbeMn2 = cb-cmov.DbeMn2 + DETALLE.ImpMn2.
        
            END.
        
        
        x-NroItm = x-NroItm + 1.
        CREATE DETALLE.
        ASSIGN DETALLE.CodCia   = cb-dmov.CodCia
               DETALLE.Periodo  = cb-dmov.Periodo
               DETALLE.NroMes   = cb-dmov.NroMes
               DETALLE.CodOpe   = cb-dmov.CodOpe
               DETALLE.NroAst   = cb-dmov.NroAst
               DETALLE.TpoItm   = "A"
               DETALLE.Relacion = RECID(cb-dmov)
               DETALLE.CodMon   = cb-dmov.CodMon
               DETALLE.TpoCmb   = cb-dmov.TpoCmb
               DETALLE.NroItm   = x-NroItm
               DETALLE.Codcta   = cb-dmov.Ctrcta
               DETALLE.CodDiv   = cb-dmov.CodDiv
               DETALLE.ClfAux   = cb-dmov.ClfAux
               DETALLE.CodAux   = cb-dmov.CodCta
               DETALLE.NroRuc   = cb-dmov.NroRuc
               DETALLE.CodDoc   = cb-dmov.CodDoc
               DETALLE.NroDoc   = cb-dmov.NroDoc
               DETALLE.GloDoc   = cb-dmov.GloDoc
               DETALLE.CodMon   = cb-dmov.CodMon
               DETALLE.TpoCmb   = cb-dmov.TpoCmb
               DETALLE.TpoMov   = NOT cb-dmov.TpoMov
               DETALLE.ImpMn1   = cb-dmov.ImpMn1
               DETALLE.ImpMn2   = cb-dmov.ImpMn2
               DETALLE.NroRef   = cb-dmov.NroRef
               DETALLE.FchDoc   = cb-dmov.FchDoc
               DETALLE.FchVto   = cb-dmov.FchVto
               DETALLE.CCO      = cb-dmov.CCO
               DETALLE.TM       = cb-dmov.TM.
               
        RUN cbd/cb-acmd.p(RECID(DETALLE), YES , YES).
        
        IF DETALLE.TpoMov THEN     /* Tipo H */
            ASSIGN cb-cmov.HbeMn1 = cb-cmov.HbeMn1 + DETALLE.ImpMn1
                   cb-cmov.HbeMn2 = cb-cmov.HbeMn2 + DETALLE.ImpMn2.
        
        ELSE
            ASSIGN cb-cmov.DbeMn1 = cb-cmov.DbeMn1 + DETALLE.ImpMn1
                   cb-cmov.DbeMn2 = cb-cmov.DbeMn2 + DETALLE.ImpMn2.
        
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-Total D-Dialog 
PROCEDURE Calcula-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-Imp1 AS DECIMAL NO-UNDO.
DEFINE VAR x-Imp2 AS DECIMAL NO-UNDO.
ASSIGN x-Imp1 = 0 x-Imp2 = 0.
FOR EACH B-drol WHERE B-drol.CodCia  = S-CODCIA  AND
                      B-drol.Periodo = S-PERIODO AND
                      B-drol.NroMes  = S-NROMES  AND
                      B-drol.Nrorol  = I-NROROL  AND
                      B-drol.ctabco  = X-CTABCO  AND
                      NOT B-drol.FlgPgo NO-LOCK :
    IF B-drol.TpoMov THEN DO :                          
       x-Imp1 = x-Imp1 + B-drol.SdoMn1.
       x-Imp2 = x-Imp2 + B-drol.SdoMn2.
    END.   
    ELSE DO :   
       x-Imp1 = x-Imp1 - B-drol.SdoMn1.
       x-Imp2 = x-Imp2 - B-drol.SdoMn2.    
    END.                                   
END.
DISPLAY x-Imp1 @ F-SOLES WITH FRAME {&FRAME-NAME}.
DISPLAY x-Imp2 @ F-DOLAR WITH FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierra-Cronograma D-Dialog 
PROCEDURE Cierra-Cronograma :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    x-NroItm = 0.
    FOR EACH cp-drol NO-LOCK WHERE cp-drol.codcia = s-codcia AND
             cp-drol.periodo = s-periodo AND
             cp-drol.nromes  = s-nromes AND
             cp-drol.nrorol  = I-NROROL AND
             cp-drol.flgpgo  = FALSE :
        x-NroItm = x-NroItm + 1.
    END.
    IF x-NroItm = 0 THEN DO:
       FIND cp-crol WHERE cp-crol.CodCia = s-codcia AND
            cp-crol.Periodo = s-periodo AND
            cp-crol.nromes  = s-nromes AND
            cp-crol.Nrorol = I-NROROL NO-ERROR.
       IF AVAILABLE cp-crol THEN cp-crol.Flgest = YES.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Diferencia-cmb D-Dialog 
PROCEDURE Diferencia-cmb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  x-totalMn1 = 0.
  x-totalMn2 = 0.
  RECID-tmp  = ?.
  /*GENERA DIFERENCIA DE CAMBIO POR CADA ITEM */    
          
  FOR EACH detalle WHERE detalle.CodCia  = s-codcia  AND
                         detalle.Periodo = s-periodo AND
                         detalle.NroMes  = s-NroMes  AND
                         detalle.CodOpe  = x-CodOpe  AND
                         detalle.NroAst  = cb-cmov.NroAst AND
                         detalle.tpoitm  = "P"       AND
                         detalle.impmn3 <> 0 :                           
      CASE detalle.Codmon :
           WHEN 2 THEN DO:
              IF detalle.IMPMN3 > 0 THEN RUN APLICA-DIF(Cta-PerDcb,FALSE,ABS(detalle.IMPMN3),0,RECID(DETALLE)).
              IF detalle.IMPMN3 < 0 THEN RUN APLICA-DIF(Cta-GanDcb,TRUE ,ABS(detalle.IMPMN3),0,RECID(DETALLE)).
           END.
           WHEN 1 THEN DO:
              IF detalle.IMPMN3 > 0  THEN RUN APLICA-DIF(Cta-PerTrl,FALSE,0,ABS(detalle.IMPMN3),RECID(DETALLE)).
              IF detalle.IMPMN3 < 0  THEN RUN APLICA-DIF(Cta-GanTrl,TRUE ,0,ABS(detalle.IMPMN3),RECID(DETALLE)).
           END.             
      END.    
  END.    
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
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
  DISPLAY F-soles F-DOLAR F-FchAst F-TpoCmb F-NroChq 
      WITH FRAME D-Dialog.
  ENABLE RECT-15 Brw-CRol Brw-BRol Brw-DRol F-FchAst F-TpoCmb F-NroChq Btn_OK 
         Btn_Cancel 
      WITH FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime2 D-Dialog 
PROCEDURE Imprime2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR X-IMPRESO AS CHAR FORMAT "X(20)".
    X-IMPRESO = STRING(TIME,"HH:MM AM") + "-" + STRING(TODAY,"99/99/99").
    DEFINE var X-PAG AS CHAR FORMAT "999". 
    DEFINE VARIABLE x-glodoc   AS CHARACTER FORMAT "X(40)".
    DEFINE VARIABLE x-impletra AS CHARACTER FORMAT "X(100)".
    DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
    DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
    DEFINE VARIABLE x-fecha    AS DATE FORMAT "99/99/99" INITIAL TODAY.
    DEFINE VARIABLE x-codmon   AS INTEGER INITIAL 1.
    DEFINE VARIABLE x-con-reg  AS INTEGER.

    x-codmon = cb-cmov.codmon.

    IF cb-cmov.codmon = 1 THEN x-impletra = x-impletra + "----NUEVOS SOLES".
    ELSE x-impletra = x-impletra + "----DOLARES AMERICANOS".
    
    DEFINE FRAME f-cab
/*        "   "*/
        cb-dmov.coddiv LABEL "Divisi¢n"
        cb-dmov.codcta LABEL "Cuenta"
        cb-dmov.clfaux LABEL "Clf!Aux"
        cb-dmov.codaux       LABEL "Auxiliar"
        cb-dmov.nroref LABEL "Referencia"
        cb-dmov.coddoc LABEL "Cod"
        cb-dmov.nrodoc LABEL "Nro!Documento"
        cb-dmov.fchdoc LABEL "Fecha!Doc"
        x-glodoc       LABEL "Detalle"
        x-debe         LABEL "Cargos" FORMAT "(>,>>>,>>9.99)"
        x-haber        LABEL "Abonos" FORMAT "(>,>>>,>>9.99)"
        WITH WIDTH 150 NO-BOX STREAM-IO DOWN.
        
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia AND
         cb-ctas.codcta = cb-cmov.ctacja NO-LOCK NO-ERROR.
    FIND FIRST GN-DIVI  WHERE GN-DIVI.codcia  =  S-codcia AND
               GN-DIVI.codDIV  =  cb-cmov.coddiv
               NO-LOCK NO-ERROR.

    OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 33.
    PUT STREAM report CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(33).
    PUT STREAM report CONTROL CHR(27) CHR(80) CHR(15).
    PUT STREAM report empresas.nomcia.
    PUT STREAM report x-nomope AT ((130 - LENGTH(x-nomope)) / 2).
    PUT STREAM report "FECHA    :          " AT 100  cb-cmov.fchast SKIP.
    PUT STREAM report "VOUCHER No: " AT 54  cb-cmov.codope "-" cb-cmov.nroast SKIP(1).
    PUT STREAM report CONTROL CHR(27) CHR(70) CHR(27) CHR(120) 0.
    PUT STREAM report "DIVISION   : "   cb-cmov.coddiv " " gn-divi.desdiv.
    PUT STREAM report "T.CAMBIO :           " AT 100 cb-cmov.tpocmb FORMAT "ZZZ9.9999" SKIP.
    IF avail cb-ctas THEN 
       PUT STREAM report "CUENTA     : " cb-ctas.nomcta SKIP.
    PUT STREAM report "DOCUMENTO  : "   cb-cmov.coddoc  cb-cmov.nrochq.
    IF cb-cmov.codmon = 1 THEN PUT STREAM report "IMPORTE  :  S/. " AT 100.
    ELSE PUT STREAM report "IMPORTE  :  US$ " AT 100.
    PUT STREAM report cb-cmov.impchq FORMAT "**********9.99" SKIP.
    PUT STREAM report "PAGADO A   : " cb-cmov.girado SKIP.
    PUT STREAM report "CONCEPTO   : " cb-cmov.notast SKIP.
    PUT STREAM report CONTROL CHR(27) CHR(77) CHR(15).
    PUT STREAM report FILL("_",150) FORMAT "X(150)" SKIP.
    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = s-codcia
                    AND cb-dmov.periodo = s-periodo
                    AND cb-dmov.nromes  = s-NroMes
                    AND cb-dmov.codope  = cb-cmov.codope
                    AND cb-dmov.nroast  = cb-cmov.nroast
        BREAK BY (cb-dmov.nroast):
        x-glodoc = glodoc.
        IF x-glodoc = "" THEN DO:
            CASE cb-dmov.clfaux:
            WHEN "@CL" THEN DO:
                FIND gn-clie WHERE gn-clie.codcli = cb-dmov.codaux
                    AND gn-clie.CodCia = cl-codcia NO-LOCK NO-ERROR.
                IF AVAILABLE gn-clie THEN x-glodoc = gn-clie.nomcli.
            END.
            WHEN "@PV" THEN DO:
                FIND gn-prov WHERE gn-prov.codpro = cb-dmov.codaux
                    AND gn-prov.CodCia = pv-codcia NO-LOCK NO-ERROR.
                IF AVAILABLE gn-prov THEN x-glodoc = gn-prov.nompro.
            END.
            WHEN "@CT" THEN DO:
                find cb-ctas WHERE cb-ctas.codcta = cb-dmov.codaux
                    AND cb-ctas.CodCia = cb-codcia NO-LOCK NO-ERROR.
               IF AVAILABLE cb-ctas THEN x-glodoc = cb-ctas.nomcta.
            END.
            OTHERWISE DO:
                FIND cb-auxi WHERE cb-auxi.clfaux = cb-dmov.clfaux
                    AND cb-auxi.codaux = cb-dmov.codaux
                    AND cb-auxi.CodCia = cb-codcia NO-LOCK NO-ERROR.                      
                IF AVAILABLE cb-auxi THEN x-glodoc = cb-auxi.nomaux.
            END.
            END CASE.
        END.
        IF x-glodoc = "" THEN DO:
            IF AVAILABLE cb-cmov THEN x-glodoc = cb-cmov.notast.
        END.
        CASE x-codmon:
            WHEN 2 THEN DO:
                SUBSTR(x-glodoc,( 35 - LENGTH(STRING(ImpMn2)) ),31) = "(US$" + STRING(ImpMn2) + ")".
            END.
        END CASE.
        IF cb-dmov.tpomov THEN DO:
            x-debe  = 0.
            x-haber = ImpMn1.
        END.
        ELSE DO:
            x-debe  = ImpMn1.
            x-haber = 0.
        END.
        IF NOT (x-haber = 0 AND x-debe = 0) AND x-debe <> ? AND x-haber <> ?
        THEN DO:
            ACCUMULATE x-debe  (SUB-TOTAL BY cb-dmov.nroast).
            ACCUMULATE x-haber (SUB-TOTAL BY cb-dmov.nroast).
            IF LINE-COUNTER(report)  + 5 > PAGE-SIZE(report)
            THEN DO :
                      X-PAG =  STRING(PAGE-NUMBER(report),"999").
                      UNDERLINE STREAM report 
                              cb-dmov.coddiv
                              cb-dmov.codcta
                              x-glodoc
                              x-debe 
                              x-haber
                              WITH FRAME f-cab.    
                       DOWN STREAM report with frame f-cab.
                       DISPLAY STREAM report 
                              "PAG."              @ cb-dmov.coddiv
                              X-PAG               @ cb-dmov.codcta
                              "    .....Van.... " @ x-glodoc
                              ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
                              ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
                              WITH FRAME f-cab.    
                       X-PAG =  STRING(PAGE-NUMBER(report) + 1 ,"999").  
                       DOWN STREAM report with frame f-cab.
                       PAGE stream report.
                       DISPLAY STREAM report 
                              "PAG."              @ cb-dmov.coddiv
                              X-PAG               @ cb-dmov.codcta
                              "    .....Vienen.... " @ x-glodoc
                              ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
                              ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
                       WITH FRAME f-cab.    
                       DOWN STREAM report with frame f-cab.
                       UNDERLINE STREAM report 
                              cb-dmov.coddiv
                              cb-dmov.codcta
                              x-glodoc
                              x-debe 
                              x-haber
                       WITH FRAME f-cab.    
                       DOWN STREAM report with frame f-cab.
                 END.     
            DISPLAY STREAM report cb-dmov.coddiv
                                  cb-dmov.codcta
                                  cb-dmov.clfaux
                                  cb-dmov.codaux
                                  cb-dmov.nroref
                                  cb-dmov.coddoc
                                  cb-dmov.nrodoc
                                  cb-dmov.fchdoc
                                  x-glodoc
                                  x-debe   WHEN (x-debe  <> 0)
                                  x-haber  WHEN (x-haber <> 0) 
                            WITH FRAME f-cab.
            DOWN STREAM report with frame f-cab.
        END.
        IF LAST-OF (cb-dmov.nroast)
        THEN DO:
            x-glodoc = "                    TOTALES :".
            IF LINE-COUNTER(report)  + 3 > PAGE-SIZE(report)
            THEN PAGE stream report.
            DOWN STREAM report 1 WITH FRAME f-cab.
            UNDERLINE STREAM report 
                              x-glodoc
                              x-debe 
                              x-haber
                       WITH FRAME f-cab.    
            DOWN STREAM report with frame f-cab.
            DISPLAY STREAM report x-glodoc
                    ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
                    ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
                WITH FRAME f-cab.
        END.
    END.
    PUT STREAM report "SON : " x-impletra SKIP.
    DO WHILE LINE-COUNTER(report) < PAGE-SIZE(report) - 6 :
        PUT STREAM report "" skip.
    END.
    PUT STREAM report "-----------------       -----------------        ----------------- "  AT 30 SKIP.
    PUT STREAM report "      HECHO                 REVISADO              Vo.Bo.Gerencia          Impreso:" AT 30.
    PUT STREAM report x-impreso.
    OUTPUT STREAM report CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
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
     FIND LAST gn-tcmb NO-LOCK NO-ERROR.
     IF AVAILABLE gn-tcmb THEN  F-TpoCmb = gn-tcmb.Venta.
     F-FchAst = TODAY.
     DISPLAY F-FchAst F-TpoCmb.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NROCHQ D-Dialog 
PROCEDURE NROCHQ :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF s-NroChq = ""
    THEN RETURN.

    /* Incremetando */
    x        = 0.
    lleva    = YES.
    c        = "".
    DO i = LENGTH( s-NroChq ) TO 1 BY -1 :
        c = SUBSTR( s-NroChq, i, 1).
        IF Lleva
        THEN DO:
            IF INDEX( "0123456789", c ) <> 0
            THEN IF c = "9"
                 THEN ASSIGN SUBSTR( s-NroChq, i, 1) = "0"
                             Lleva = YES.
                 ELSE ASSIGN SUBSTR( s-NroChq, i, 1) = STRING(INTEGER( c ) + 1)
                             Lleva = NO.
            IF INDEX( "ABCDEFGHIJKLMNOPQRSTUVWXYZ", CAPS(c) ) <> 0
            THEN IF  c  =  "Z"
                 THEN ASSIGN SUBSTR( s-nrochq, i, 1) = "A"
                             Lleva = YES.
                 ELSE ASSIGN SUBSTR( s-nrochq, i, 1) = CHR(ASC( c ) + 1)
                             Lleva = NO.
        END.
        x = x + 1.
    END.
    RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Giro-1 D-Dialog 
PROCEDURE Procesa-Giro-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 /* MESSAGE "PROCESANDO 1" VIEW-AS ALERT-BOX. */
 
 DEFINE VAR x-Compara AS DECIMAL.
 DEFINE VAR x-Importe AS DECIMAL.
 
    FOR EACH cp-drol EXCLUSIVE-LOCK WHERE cp-drol.codcia = s-codcia AND
        cp-drol.periodo = s-periodo AND
        cp-drol.nromes  = s-nromes AND
        cp-drol.nrorol = I-NROROL AND
        cp-drol.flgpgo = FALSE AND
        cp-drol.ctabco = X-CTABCO AND
        cp-drol.codbco = ""
        BREAK BY cp-drol.coddoc
              BY cp-drol.codaux :

        IF FIRST-OF( cp-drol.codaux ) THEN DO:
           FIND CB-OPER WHERE cb-oper.codcia = cb-codcia AND
                              cb-oper.CodCta = X-CtaBco NO-LOCK NO-ERROR.
           
           IF AVAILABLE CB-OPER THEN DO :
              X-CODOPE = CB-OPER.CodOpe.
           END. 
                              
           RUN cbd/cbdnast.p(cb-codcia, s-codcia, s-periodo, s-nromes, X-CODOPE, OUTPUT x-nroast). 
           FIND cb-ctas WHERE cb-ctas.CodCia = CB-CodCia AND
                cb-ctas.CodCta = X-CtaBco NO-LOCK NO-ERROR.
           CREATE cb-cmov.
           ASSIGN
                cb-cmov.CodCia  = s-codcia
                cb-cmov.Periodo = s-periodo
                cb-cmov.NroMes  = s-nromes
                cb-cmov.CodOpe  = X-CODOPE
                cb-cmov.CodDiv  = cp-drol.coddiv
                cb-cmov.CodDoc  = cb-ctas.coddoc
                cb-cmov.NroAst  = STRING( x-NroAst,"999999" )
                cb-cmov.FchAst  = F-FchAst
                cb-cmov.Usuario = s-User-Id
                cb-cmov.ctacja  = X-CTABCO
                cb-cmov.Girado  = cp-drol.NomAux
                cb-cmov.GloAst  = cp-drol.glosa
                cb-cmov.Notast  = cp-drol.glosa
                cb-cmov.Nrovou  = STRING( cp-crol.nrorol,"999999" )
                cb-cmov.Codmon  = cb-ctas.codmon
                cb-cmov.nrochq  = S-NroChq
                cb-cmov.Tpocmb  = F-TpoCmb
                x-NroItm = 0.
            RUN NroChq.
        END.
        
        x-NroItm = x-NroItm + 1.
        CREATE cb-dmov.
        ASSIGN
            cb-dmov.CodCia  = s-codcia
            cb-dmov.Periodo = s-periodo
            cb-dmov.NroMes  = s-nromes
            cb-dmov.CodOpe  = cb-cmov.CodOpe
            cb-dmov.NroAst  = cb-cmov.NroAst
            cb-dmov.TpoCmb  = cb-cmov.TpoCmb
            cb-dmov.CodMon  = cb-cmov.Codmon         
            cb-dmov.TM      = cb-cmov.Codmon   /* PARA DIFERENCIA DE CAMBIO EN CAJA EGRESO */
            cb-dmov.CodDiv  = cp-drol.coddiv
            cb-dmov.Coddoc  = cp-drol.Coddoc
            cb-dmov.Nrodoc  = cp-drol.nrodoc
            cb-dmov.Clfaux  = cp-drol.Clfaux
            cb-dmov.Codaux  = cp-drol.Codaux
            cb-dmov.Codcta  = cp-drol.Codcta
            cb-dmov.Fchvto  = cp-drol.Fchvto
            cb-dmov.FchDoc  = cb-cmov.FchAst
            cb-dmov.TpoMov  = NOT cp-drol.TpoMov
            cb-dmov.Glodoc  = cp-drol.nomaux
            cb-dmov.Nroref  = cp-drol.Codope + "-" + cp-drol.Nroast
            cb-dmov.FlgAct  = TRUE
            cb-dmov.NroItm  = x-NroItm
            cb-dmov.TpoItm  = "P".
            
            x-Importe = cp-drol.Imppgo.
            
            cb-dmov.ImpMn1 = cp-drol.SdoMn1.
            cb-dmov.ImpMn2 = cp-drol.SdoMn2.
                  
        /* GENERANDO LA DIFERENCIA DE CAMBIO */
        
        x-Compara = IF cp-drol.CodMon = 1 THEN cb-dmov.ImpMn1 ELSE cb-dmov.ImpMn2.
        
        IF (cp-drol.CodMon = 1 AND ABS(x-importe) = x-Compara ) THEN 
            cb-dmov.ImpMn3 = ( ABS( cb-dmov.ImpMn1 ) / cb-dmov.tpocmb ) - cb-dmov.Impmn2.
                
        IF (cp-drol.CodMon = 2 AND ABS(x-importe) = x-Compara ) THEN
            cb-dmov.ImpMn3 = ( ABS( cb-dmov.ImpMn2 ) * cb-dmov.tpocmb ) - cb-dmov.Impmn1.
                     
        RegAct = RECID( cb-dmov ).
                
        RUN cbd/cb-acmd.p(RegAct, YES , YES).
        RUN Acumula.
        ASSIGN cp-drol.flgpgo  = TRUE
               cp-drol.Fchpago = F-FchAst.
               
        IF LAST-OF( cp-drol.codaux ) THEN DO:
           RUN Diferencia-Cmb.
           RUN Registro-de-Banco.
           ASSIGN cb-cmov.TotItm = x-NroItm.
           IF cb-cmov.codmon = 1 THEN ASSIGN cb-cmov.Impchq = ABS(x-totalch1).
           ELSE ASSIGN cb-cmov.Impchq = ABS(x-totalch2).           
           RUN Imprime2.
        END.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Giro-2 D-Dialog 
PROCEDURE Procesa-Giro-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR x-Compara AS DECIMAL.
 DEFINE VAR x-Importe AS DECIMAL.
 
    /*MESSAGE "PROCESANDO 2" VIEW-AS ALERT-BOX.*/
    FOR EACH cp-drol EXCLUSIVE-LOCK WHERE cp-drol.codcia = s-codcia AND
        cp-drol.periodo = s-periodo AND
        cp-drol.nromes  = s-nromes AND
        cp-drol.nrorol = I-NROROL AND
        cp-drol.flgpgo = FALSE AND
        cp-drol.ctabco = X-CTABCO AND
        cp-drol.codbco <> ""
        BREAK BY cp-drol.codbco
              BY cp-drol.codaux
              BY cp-drol.coddoc:
              
        IF FIRST-OF( cp-drol.codbco ) THEN DO:
           RUN cbd/cbdnast.p(cb-codcia, s-codcia, s-periodo, s-nromes, cb-oper.codope, OUTPUT x-nroast). 
           FIND cb-ctas WHERE cb-ctas.CodCia = CB-CodCia AND
                cb-ctas.CodCta = X-CtaBco NO-LOCK NO-ERROR.
           FIND cb-tabl WHERE cb-tabl.Tabla = "04" AND
                cb-tabl.Codigo = cb-ctas.codbco NO-LOCK NO-ERROR.
           CREATE cb-cmov.
           ASSIGN
                cb-cmov.CodCia  = s-codcia
                cb-cmov.Periodo = s-periodo
                cb-cmov.NroMes  = s-nromes
                cb-cmov.CodOpe  = X-CODOPE
                cb-cmov.CodDiv  = cp-drol.coddiv
                cb-cmov.CodDoc  = cb-ctas.coddoc
                cb-cmov.NroAst  = STRING( x-NroAst,"999999" )
                cb-cmov.FchAst  = F-FchAst
                cb-cmov.Usuario = s-User-Id
                cb-cmov.ctacja  = X-CTABCO
                cb-cmov.Girado  = cb-tabl.Nombre
                cb-cmov.GloAst  = cp-drol.glosa
                cb-cmov.Notast  = cp-drol.glosa
                cb-cmov.Nrovou  = STRING( cp-crol.nrorol,"999999" )
                cb-cmov.Codmon  = cb-ctas.codmon
                cb-cmov.nrochq  = S-NroChq
                cb-cmov.Tpocmb  = F-TpoCmb
                x-NroItm = 0.
            RUN NroChq.
        END.
        x-NroItm = x-NroItm + 1.
        CREATE cb-dmov.
        ASSIGN
            cb-dmov.CodCia  = s-codcia
            cb-dmov.Periodo = s-periodo
            cb-dmov.NroMes  = s-nromes
            cb-dmov.CodOpe  = cb-cmov.CodOpe
            cb-dmov.NroAst  = cb-cmov.NroAst
            cb-dmov.TpoCmb  = cb-cmov.TpoCmb
            cb-dmov.CodMon  = cb-cmov.Codmon
            cb-dmov.TM      = cb-cmov.Codmon   /* PARA DIFERENCIA DE CAMBIO EN CAJA EGRESO */
            cb-dmov.CodDiv  = cp-drol.coddiv
            cb-dmov.Coddoc  = cp-drol.Coddoc
            cb-dmov.Nrodoc  = cp-drol.nrodoc
            cb-dmov.Clfaux  = cp-drol.Clfaux
            cb-dmov.Codaux  = cp-drol.Codaux
            cb-dmov.Codcta  = cp-drol.Codcta
            cb-dmov.Fchvto  = cp-drol.Fchvto
            cb-dmov.FchDoc  = cb-cmov.FchAst
            cb-dmov.TpoMov  = NOT cp-drol.TpoMov
            cb-dmov.Glodoc  = cp-drol.nomaux
            cb-dmov.Nroref  = cp-drol.Codope + "-" + cp-drol.Nroast
            cb-dmov.FlgAct  = TRUE
            cb-dmov.NroItm  = x-NroItm
            cb-dmov.TpoItm  = "P".
            
             x-Importe = cp-drol.Imppgo.
            
            cb-dmov.ImpMn1 = cp-drol.SdoMn1.
            cb-dmov.ImpMn2 = cp-drol.SdoMn2.
                  
        /* GENERANDO LA DIFERENCIA DE CAMBIO */
        
        x-Compara = IF cp-drol.CodMon = 1 THEN cb-dmov.ImpMn1 ELSE cb-dmov.ImpMn2.
        
        IF (cp-drol.CodMon = 1 AND ABS(x-importe) = x-Compara ) THEN 
            cb-dmov.ImpMn3 = ( ABS( cb-dmov.ImpMn1 ) / cb-dmov.tpocmb ) - cb-dmov.Impmn2.
                
        IF (cp-drol.CodMon = 2 AND ABS(x-importe) = x-Compara ) THEN
            cb-dmov.ImpMn3 = ( ABS( cb-dmov.ImpMn2 ) * cb-dmov.tpocmb ) - cb-dmov.Impmn1.
                              
        RegAct = RECID( cb-dmov ).
        RUN cbd/cb-acmd.p(RegAct, YES , YES).
        RUN Acumula.
        ASSIGN cp-drol.flgpgo  = TRUE
               cp-drol.Fchpago = F-FchAst.
        IF LAST-OF( cp-drol.codbco ) THEN DO:
           RUN Diferencia-Cmb.
           RUN Registro-de-Banco.
           ASSIGN cb-cmov.TotItm = x-NroItm.
           IF cb-cmov.codmon = 1 THEN ASSIGN cb-cmov.Impchq = ABS(x-totalch1).
           ELSE ASSIGN cb-cmov.Impchq = ABS(x-totalch2).
           RUN Imprime2. 
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Registro-de-Banco D-Dialog 
PROCEDURE Registro-de-Banco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* calculo de cuenta 104?????  */

    x-totalch1 = 0.
    x-totalch2 = 0.
    FOR EACH detalle WHERE detalle.codcia = s-codcia AND
        detalle.periodo = s-periodo AND
        detalle.nromes  = s-nromes AND
        detalle.codope  = cb-cmov.codope AND
        detalle.nroast  = cb-cmov.nroast:
        IF detalle.tpomov THEN DO:
            x-totalch1 = x-totalch1 - detalle.impmn1.
            x-totalch2 = x-totalch2 - detalle.impmn2.
        END.
        ELSE DO:
            x-totalch1 = x-totalch1 + detalle.impmn1.
            x-totalch2 = x-totalch2 + detalle.impmn2.
        END.
    END.
    
    /*message  "LIBRO " cb-cmov.codope SKIP
             "VOUCHER " cb-cmov.NroAst skip
             "S/. " x-totalch1 skip
             "US$ " x-totalch2 VIEW-AS ALERT-BOX. */
    
    x-Nroitm = x-Nroitm + 1.
    CREATE cb-dmov.
    ASSIGN cb-dmov.CodCia  = s-codcia
           cb-dmov.Periodo = s-periodo
           cb-dmov.NroMes  = s-nromes
           cb-dmov.CodOpe  = cb-cmov.codope
           cb-dmov.NroAst  = cb-cmov.NroAst
           cb-dmov.Codcta  = cb-cmov.ctacja
           cb-dmov.CodMon  = cb-cmov.CodMon
           cb-dmov.TpoCmb  = cb-cmov.TpoCmb
           cb-dmov.FchDoc  = cb-cmov.FchAst
           cb-dmov.CODDIV  = cb-cmov.CODDIV
           cb-dmov.GLODOC  = "GIRO AUTOMATICO"
           cb-dmov.NroItm  = x-NroItm
           cb-dmov.TpoMov  = TRUE
           cb-dmov.ImpMn1  = ABS(x-totalch1)
           cb-dmov.ImpMn2  = ABS(x-totalch2)
           cb-dmov.CodDoc  = "CH"
           cb-dmov.nrodoc  = cb-cmov.nrochq
           cb-dmov.TpoItm  = "B"
           cb-dmov.FLGACT  = TRUE.
    RegAct = RECID( cb-dmov ).
    RUN cbd/cb-acmd.p(RegAct, YES ,YES).
    RUN Acumula.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "integral.cp-brol"}
  {src/adm/template/snd-list.i "integral.cp-drol"}
  {src/adm/template/snd-list.i "integral.cp-crol"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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


