&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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

&IF "{&NEW}" = "" &THEN
    DEFINE INPUT  PARAMETER RegAct   AS RECID.
    DEFINE OUTPUT PARAMETER x-girado AS CHARACTER.
    DEFINE OUTPUT PARAMETER x-notast AS CHARACTER.
    DEFINE OUTPUT PARAMETER X-ERROR  AS LOGICAL.
&ELSE
    DEFINE VARIABLE RegAct   AS RECID.
    DEFINE VARIABLE x-girado AS CHARACTER.
    DEFINE VARIABLE x-notast AS CHARACTER.
    DEFINE VAR X-ERROR AS LOGICAL .
    
    FIND FIRST cb-dmov.
    regact = RECID( integral.cb-dmov ).

&ENDIF

/* Local Variable Definitions ---                                       */

DEFINE {&NEW} SHARED VARIABLE s-codcia       AS INTEGER INITIAL 1.
DEFINE {&NEW} SHARED VARIABLE s-periodo          AS INTEGER INITIAL 1997.
DEFINE {&NEW} SHARED VARIABLE cb-niveles AS CHARACTER INITIAL "2,3,4,5".
DEFINE VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE VARIABLE cb-codcia AS INTEGER INITIAL 0.

FIND Empresas WHERE Empresas.CodCia = s-codcia.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.
IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.
DEF    VAR      Der-CodDiv  AS CHAR.


DEFINE VARIABLE x-nromes    AS INTEGER   NO-UNDO.
DEFINE VARIABLE x-codope    AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-nroast    AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-clfaux    AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-codcta    AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-SdoMn1    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE x-SdoMn2    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE x-GenAut    AS INTEGER   NO-UNDO.
DEFINE VARIABLE i           AS INTEGER   NO-UNDO.
DEFINE VARIABLE y-codmon    AS INTEGER   NO-UNDO.
DEFINE VARIABLE pto         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE RECID-stack AS RECID     NO-UNDO.
DEFINE VARIABLE RECID-ok    AS RECID     NO-UNDO.
DEFINE BUFFER detalle FOR integral.cb-dmov.

pto = SESSION:SET-WAIT-STATE("").

DEF BUFFER B-CTAS FOR CB-CTAS.

DEFINE SHARED TEMP-TABLE RMOV LIKE cb-dmov.

/*ML01* 24/Jun/2008 ***/
DEFINE SHARED VARIABLE fFchAst AS DATE NO-UNDO.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-dmov

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define FIELDS-IN-QUERY-D-Dialog cb-dmov.CodCta cb-dmov.CodDiv ~
cb-dmov.CodAux cb-dmov.C-FCaja cb-dmov.CCo cb-dmov.CodDoc cb-dmov.NroDoc ~
cb-dmov.NroRef cb-dmov.GloDoc cb-dmov.TpoCmb cb-dmov.FchVto cb-dmov.Chr_01 ~
cb-dmov.Log_01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-D-Dialog cb-dmov.CodCta ~
cb-dmov.CodDiv cb-dmov.CodAux cb-dmov.C-FCaja cb-dmov.CCo cb-dmov.CodDoc ~
cb-dmov.NroDoc cb-dmov.NroRef cb-dmov.GloDoc cb-dmov.TpoCmb cb-dmov.FchVto ~
cb-dmov.Chr_01 cb-dmov.Log_01 
&Scoped-define ENABLED-TABLES-IN-QUERY-D-Dialog cb-dmov
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-D-Dialog cb-dmov
&Scoped-define QUERY-STRING-D-Dialog FOR EACH cb-dmov SHARE-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH cb-dmov SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog cb-dmov
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog cb-dmov


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cb-dmov.CodCta cb-dmov.CodDiv cb-dmov.CodAux ~
cb-dmov.C-FCaja cb-dmov.CCo cb-dmov.CodDoc cb-dmov.NroDoc cb-dmov.NroRef ~
cb-dmov.GloDoc cb-dmov.TpoCmb cb-dmov.FchVto cb-dmov.Chr_01 cb-dmov.Log_01 
&Scoped-define ENABLED-TABLES cb-dmov
&Scoped-define FIRST-ENABLED-TABLE cb-dmov
&Scoped-Define ENABLED-OBJECTS RECT-5 RECT-4 RECT-6 x-div X-coddoc x-NroDoc ~
x-codaux x-importe Btn_OK Btn_Cancel BUTTON-14 
&Scoped-Define DISPLAYED-FIELDS cb-dmov.CodCta cb-dmov.CodDiv ~
cb-dmov.CodAux cb-dmov.C-FCaja cb-dmov.CCo cb-dmov.CodDoc cb-dmov.NroDoc ~
cb-dmov.NroRef cb-dmov.GloDoc cb-dmov.TpoCmb cb-dmov.FchVto cb-dmov.Chr_01 ~
cb-dmov.Log_01 
&Scoped-define DISPLAYED-TABLES cb-dmov
&Scoped-define FIRST-DISPLAYED-TABLE cb-dmov
&Scoped-Define DISPLAYED-OBJECTS x-div X-coddoc x-NroDoc x-codaux x-NomCta ~
campo-aux x-importe 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Aceptar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-14 
     IMAGE-UP FILE "img/b-buscar":U
     LABEL "Button 14" 
     SIZE 8 BY 1.08.

DEFINE VARIABLE campo-aux AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE x-codaux AS CHARACTER FORMAT "X(8)":U 
     LABEL "Auxiliar" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE X-coddoc AS CHARACTER FORMAT "X(3)":U 
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-div AS CHARACTER FORMAT "X(5)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE x-importe AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "Importe" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 20 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-NomCta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE x-NomDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE x-NroDoc AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 16 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 77 BY 10.77
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 76.86 BY 1.62
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 77 BY 3.77
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      cb-dmov SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     x-div AT ROW 1.81 COL 14 COLON-ALIGNED
     X-coddoc AT ROW 2.62 COL 14 COLON-ALIGNED
     x-NroDoc AT ROW 2.62 COL 22 COLON-ALIGNED NO-LABEL
     x-codaux AT ROW 3.42 COL 14 COLON-ALIGNED
     cb-dmov.CodCta AT ROW 5.31 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 15 
     x-NomCta AT ROW 5.31 COL 27 COLON-ALIGNED NO-LABEL
     cb-dmov.CodDiv AT ROW 6.12 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .85
     x-NomDiv AT ROW 6.12 COL 27 COLON-ALIGNED NO-LABEL
     cb-dmov.CodAux AT ROW 6.92 COL 14 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 15 
     campo-aux AT ROW 6.92 COL 27 COLON-ALIGNED NO-LABEL
     cb-dmov.C-FCaja AT ROW 8.27 COL 15 COLON-ALIGNED
          LABEL "Concepto  F.Caja" FORMAT "x(7)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     cb-dmov.CCo AT ROW 9.08 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     cb-dmov.CodDoc AT ROW 9.88 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
          BGCOLOR 15 FGCOLOR 0 
     cb-dmov.NroDoc AT ROW 9.88 COL 25 COLON-ALIGNED NO-LABEL FORMAT "x(20)"
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
          BGCOLOR 15 
     cb-dmov.NroRef AT ROW 10.69 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
          BGCOLOR 15 
     cb-dmov.GloDoc AT ROW 11.5 COL 15 COLON-ALIGNED FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 58 BY .81
          BGCOLOR 15 
     x-importe AT ROW 12.31 COL 15 COLON-ALIGNED
     cb-dmov.TpoCmb AT ROW 12.31 COL 52 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.43 BY .81
     cb-dmov.FchVto AT ROW 13.12 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     cb-dmov.Chr_01 AT ROW 13.12 COL 52 COLON-ALIGNED WIDGET-ID 2
          LABEL "Comprobante Retención" FORMAT "x(9)"
          VIEW-AS FILL-IN 
          SIZE 11.14 BY .81
     cb-dmov.Log_01 AT ROW 14.19 COL 17 HELP
          "" NO-LABEL WIDGET-ID 6
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Si", yes,
"No", no
          SIZE 12 BY .88
     Btn_OK AT ROW 15.81 COL 20
     Btn_Cancel AT ROW 15.81 COL 43
     BUTTON-14 AT ROW 15.81 COL 66.43
     "Gasto Sustentado?:" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 14.46 COL 3 WIDGET-ID 10
     "PROVISION" VIEW-AS TEXT
          SIZE 9 BY 1.04 AT ROW 1.27 COL 30
          FONT 1
     RECT-5 AT ROW 15.54 COL 1
     RECT-4 AT ROW 4.77 COL 1
     RECT-6 AT ROW 1 COL 1
     SPACE(0.28) SKIP(12.64)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Detalle".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN cb-dmov.C-FCaja IN FRAME D-Dialog
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN campo-aux IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       campo-aux:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN cb-dmov.Chr_01 IN FRAME D-Dialog
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN cb-dmov.CodAux IN FRAME D-Dialog
   EXP-FORMAT                                                           */
ASSIGN 
       cb-dmov.CodAux:HIDDEN IN FRAME D-Dialog           = TRUE.

ASSIGN 
       cb-dmov.CodDiv:HIDDEN IN FRAME D-Dialog           = TRUE.

ASSIGN 
       cb-dmov.CodDoc:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN cb-dmov.GloDoc IN FRAME D-Dialog
   EXP-FORMAT                                                           */
/* SETTINGS FOR RADIO-SET cb-dmov.Log_01 IN FRAME D-Dialog
   EXP-HELP                                                             */
/* SETTINGS FOR FILL-IN cb-dmov.NroDoc IN FRAME D-Dialog
   EXP-FORMAT                                                           */
ASSIGN 
       cb-dmov.NroDoc:HIDDEN IN FRAME D-Dialog           = TRUE.

ASSIGN 
       cb-dmov.NroRef:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN x-NomCta IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomDiv IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "integral.cb-dmov"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Detalle */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancelar */
DO:
  ASSIGN X-ERROR = TRUE.
  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
   X-ERROR = FALSE.
    /* Verificamos si todo los campos estan bien ingresados */
    /* CodCta */
    DEF VAR X-COMPARA AS DECIMAL INIT 0.
    find cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
        cb-ctas.CodCta = cb-dmov.CodCta:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas OR LENGTH(cb-dmov.CodCta:SCREEN-VALUE) <>
         INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles))
    THEN DO:
        MESSAGE "Inv lido C¢digo de Cuenta" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO cb-dmov.CodCta.
        RETURN NO-APPLY.
    END.
    /* CodDiv */
    IF cb-cfga.CodDiv AND
        NOT CAN-FIND(gn-divi  WHERE gn-divi.CodCia = S-codcia AND
            gn-divi.coddiv = cb-dmov.CodDiv:SCREEN-VALUE )
    THEN DO:
        MESSAGE "Inv lido C¢digo de Divisionaria" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO cb-dmov.CodDiv.
        RETURN NO-APPLY.
    END.

    /* CodAux */
    IF cb-ctas.PidAux THEN 
        aux:
        DO:
            DO ON ERROR UNDO, LEAVE:
                RUN Cfg-CodAux.
                LEAVE aux.
            END.
            MESSAGE "Inválido Código Auxiliar" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY":U TO cb-dmov.CodAux.
            RETURN NO-APPLY.
        END.
    /* CodDoc */
    IF cb-ctas.PidDoc AND
        NOT CAN-FIND(cb-tabl WHERE cb-tabl.Tabla  = "02" AND
        cb-tabl.Codigo = cb-dmov.CodDoc:SCREEN-VALUE)
    THEN DO:
        MESSAGE "Inv lido Código de Documento" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO cb-dmov.CodDoc.
        RETURN NO-APPLY.
    END.
    /* NroDoc */
    IF cb-ctas.PidDoc AND cb-dmov.Nrodoc:SCREEN-VALUE = ""
    THEN DO:
        MESSAGE "Inválido No. de Documento" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO cb-dmov.NroDoc.
        RETURN NO-APPLY.
    END.
    FIND FIRST cb-auxi WHERE cb-auxi.codcia  =  cb-codcia AND 
                                cb-auxi.clfaux  =  "@FC"       AND
                                cb-auxi.codaux  =  INPUT cb-dmov.C-FCAJA
                                NO-LOCK NO-ERROR.                                
    IF NOT AVAIL cb-auxi THEN DO:
         MESSAGE "Código de Flujo de Caja no registrado" VIEW-AS ALERT-BOX ERROR.
         RETURN NO-APPLY.
    END.

    /* Centro de Costo */
    IF cb-ctas.Pidcco AND cb-dmov.Cco:SCREEN-VALUE = '' THEN DO:
        MESSAGE "Ingrese Centro de Costo" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO cb-dmov.Cco.
        RETURN NO-APPLY.
    END.
    IF cb-ctas.Pidcco AND 
       NOT CAN-FIND(cb-auxi WHERE cb-auxi.CodCia  = cb-codcia AND
        cb-auxi.Clfaux = "CCO" AND cb-auxi.CodAux = cb-dmov.Cco:SCREEN-VALUE)
    THEN DO:
        MESSAGE "Inválido Centro de Costo" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO cb-dmov.Cco.
        RETURN NO-APPLY.
    END.

    /* Importes */
    IF INPUT x-Importe = 0 THEN DO:
        MESSAGE "Inválido Importe Registrado" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO x-Importe.
        RETURN NO-APPLY.
    END.

    /* Grabamos datos para la generaci¢n de Cuentas Autom ticas */
    x-GenAut = 0.
    /* Verificamos si la Cuenta genera autom ticas de Clase 9 */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut9 ):
        IF cb-dmov.CodCta:SCREEN-VALUE BEGINS ENTRY( i, cb-cfga.GenAut9 )
        THEN DO:
            IF ENTRY( i, cb-cfga.GenAut9) <> ""
            THEN DO:
                x-GenAut = 1.
                LEAVE.
            END.
        END.
    END.
    /* Verificamos si la Cuenta genera autom ticas de Clase 6 */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut6 ):
        IF cb-dmov.CodCta:SCREEN-VALUE BEGINS ENTRY( i, cb-cfga.GenAut6 )
        THEN DO:
            IF ENTRY( i, cb-cfga.GenAut6) <> ""
            THEN DO:
                x-GenAut = 2.
                LEAVE.
            END.
        END.
    END.
    /* Verificamos si la Cuenta genera automaticas de otro tipo */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut ):
        IF cb-dmov.CodCta:SCREEN-VALUE BEGINS ENTRY( i, cb-cfga.GenAut )
        THEN DO:
            IF ENTRY( i, cb-cfga.GenAut) <> ""
            THEN DO:
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
            cb-dmov.CtrCta = cb-ctas.Cc1Cta.
            IF cb-ctas.CLFAUX = "@CT" THEN
               cb-dmov.CtaAut = INPUT FRAME {&FRAME-NAME} cb-dmov.CodAux.
            ELSE
               cb-dmov.CtaAut = cb-ctas.An1Cta.   
            IF cb-dmov.CtrCta = ""
                        THEN cb-dmov.CtrCta = cb-cfga.Cc1Cta9.
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
                    cb-ctas.CodCta = cb-dmov.CtaAut ) AND
                    LENGTH(cb-dmov.CtaAut )  <>
                    INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles))
                THEN DO:
                    MESSAGE "Cuentas Autom ticas a generar" SKIP
                            "Tienen mal registro" VIEW-AS ALERT-BOX ERROR.
                    APPLY "ENTRY":U TO cb-dmov.CODCTA.
                    RETURN NO-APPLY.
                END.
     
        IF NOT CAN-FIND( cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
            cb-ctas.CodCta = cb-dmov.CtrCta ) AND
            LENGTH( cb-dmov.CtrCta )  <>
            INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles))
        THEN DO:
            MESSAGE "Cuentas Autom ticas a generar" SKIP
                    "Tienen mal registro" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY":U TO cb-dmov.CODCTA.
            RETURN NO-APPLY.
        END.
    END.    
    /* Asignando los datos registrados */
    ASSIGN FRAME {&FRAME-NAME}
           x-importe
           cb-dmov.Codcta
           cb-dmov.CodDiv
           cb-dmov.CCO
           cb-dmov.ClfAux = cb-ctas.clfaux
           cb-dmov.CodAux
           cb-dmov.CodDoc
           cb-dmov.NroDoc
           cb-dmov.GloDoc
           cb-dmov.TpoMov = ( x-importe < 0 )
           cb-dmov.NroRef
           cb-dmov.ImpMn3 = 0
           cb-dmov.C-FCAJA
           cb-dmov.flgact = false
           cb-dmov.fchvto
/*ML01*/   cb-dmov.chr_01
           cb-dmov.tpocmb
           cb-dmov.LOG_01.

        IF cb-dmov.TpoItm <> "P" THEN    
            IF cb-dmov.codmon = 1 THEN DO:
                cb-dmov.ImpMn1 = ABS( x-importe ).
                IF cb-dmov.tpocmb = 0 THEN
                    cb-dmov.ImpMn2 = 0.
                ELSE
                cb-dmov.ImpMn2 = ( ABS( x-importe ) / cb-dmov.tpocmb ).
            END.
            ELSE DO:
                cb-dmov.ImpMn2 = ABS( x-importe ).
                cb-dmov.ImpMn1 = ( ABS( x-importe ) * cb-dmov.tpocmb ).
            END.
        ELSE   
        DO:
            /*Amortizaciones */
/*             IF (cb-dmov.CODMON = 1 AND ABS(x-importe) < cb-dmov.ImpMn1 ) THEN */
            IF (cb-dmov.CODMON = 1 AND ABS(x-importe) <> cb-dmov.ImpMn1 ) THEN
            DO:
                cb-dmov.ImpMn1 = ABS( x-importe ).
                IF cb-dmov.tpocmb = 0 THEN
                   cb-dmov.ImpMn2 = 0.
                ELSE
                cb-dmov.ImpMn2 = ( ABS( x-importe ) / cb-dmov.tpocmb ).
            END.
/*             IF (cb-dmov.CODMON = 2 AND ABS(x-importe) < cb-dmov.ImpMn2 ) THEN */
            IF (cb-dmov.CODMON = 2 AND ABS(x-importe) <> cb-dmov.ImpMn2 ) THEN
            DO:
                cb-dmov.ImpMn2 = ABS( x-importe ).
                cb-dmov.ImpMn1 = ( ABS( x-importe ) * cb-dmov.tpocmb ).
            END.
            /*Cancelaci¢n*/
              X-COMPARA = IF cb-dmov.codmon = 1 THEN cb-dmov.ImpMn1 
                                                ELSE cb-dmov.ImpMn2.
              IF (cb-dmov.TM = 1 AND ABS(x-importe) = X-Compara ) THEN
                  cb-dmov.ImpMn3 =  cb-dmov.ImpMn1  / cb-dmov.tpocmb - cb-dmov.Impmn2.
              IF (cb-dmov.TM   = 2 AND ABS(x-importe) = X-Compara ) THEN
                  cb-dmov.ImpMn3 =  cb-dmov.ImpMn2  * cb-dmov.tpocmb - cb-dmov.Impmn1.
      END.                

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-14 D-Dialog
ON CHOOSE OF BUTTON-14 IN FRAME D-Dialog /* Button 14 */
DO:
    RUN cja\d-provpe.r.
    /*  RUN CJA/H-DMOV01.W ( YES    ,
                        INPUT-OUTPUT    X-CODDOC,
                        INPUT-OUTPUT  X-DIV     ,
                        INPUT-OUTPUT  X-CODAUX  ,
                        INPUT-OUTPUT  X-NRODOC  ,
                        INPUT-OUTPUT  X-CLFAUX ) .*/
    DO WITH FRAME {&FRAME-NAME} :
       FIND FIRST RMOV NO-LOCK NO-ERROR.
       IF AVAILABLE RMOV THEN
          ASSIGN X-CODDOC = RMOV.CODDOC
                 X-DIV    = RMOV.CODDIV
                 X-CODAUX = RMOV.CODAUX
                 X-NRODOC = RMOV.NRODOC.
       DISPLAY X-CODDOC 
               X-DIV
               X-CODAUX
               X-NRODOC.
       APPLY "ENTRY":U TO X-CODAUX.        
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmov.C-FCaja
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.C-FCaja D-Dialog
ON F8 OF cb-dmov.C-FCaja IN FRAME D-Dialog /* Concepto  F.Caja */
OR "MOUSE-SELECT-DBLCLICK":U OF cb-dmov.C-FCAJA DO:
   def var X-ROWID AS ROWID.
   RUN cbd/H-auxi01.w(s-codcia, "@FC",OUTPUT X-ROWID).
   IF X-ROWID <> ? THEN DO:
      FIND cb-auxi WHERE ROWID(cb-auxi) = X-ROWID
        NO-LOCK NO-ERROR.
      IF AVAIL cb-auxi THEN ASSIGN self:screen-value = cb-auxi.codaux.
      ELSE DO:
           MESSAGE "Concepto de Flujo de Caja no registrada" VIEW-AS ALERT-BOX ERROR.
           RETURN NO-APPLY.    
      END.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.C-FCaja D-Dialog
ON LEAVE OF cb-dmov.C-FCaja IN FRAME D-Dialog /* Concepto  F.Caja */
DO:
    FIND FIRST cb-auxi WHERE cb-auxi.codcia  =  cb-codcia AND 
                                cb-auxi.clfaux  =  "@FC"       AND
                                cb-auxi.codaux  =  SELF:SCREEN-VALUE
                                NO-LOCK NO-ERROR.                                
      IF NOT AVAIL cb-auxi THEN DO:
         MESSAGE "C¢digo de Flujo de Caja no registrado" VIEW-AS ALERT-BOX ERROR.
         RETURN NO-APPLY.
      END.                          
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmov.CCo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.CCo D-Dialog
ON F8 OF cb-dmov.CCo IN FRAME D-Dialog /* Centro de Costo */
OR "MOUSE-SELECT-DBLCLICK":U OF cb-dmov.CCO DO:
  /*  
   RUN cbd/q-auxi.w(cb-codcia,"CCO", OUTPUT RECID-stack).
  */
   DEF VAR T-ROWID AS ROWID.
   RUN CBD/H-AUXI01.W(s-codcia, "CCO", OUTPUT T-ROWID).
  
   IF T-ROWID <> ?
        THEN DO:
            FIND cb-auxi WHERE ROWID(cb-auxi) = T-ROWID NO-LOCK  NO-ERROR.
            IF AVAIL cb-auxi
            THEN DO:
                cb-dmov.Cco:SCREEN-VALUE = cb-auxi.CodAux.
            END.
        END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmov.CodAux
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.CodAux D-Dialog
ON F8 OF cb-dmov.CodAux IN FRAME D-Dialog /* Auxiliar */
OR "MOUSE-SELECT-DBLCLICK":U OF cb-dmov.CODAUX DO:
    DEF VAR T-ROWID AS ROWID.
    DEF VAR T-RECID AS RECID.
    CASE cb-dmov.ClfAux:
    WHEN "@PV"  THEN DO:
       /* RUN adm/q-prov.w(pv-codcia, OUTPUT T-ROWID).        */
        RUN ADM/H-PROV01.W(s-codcia, OUTPUT T-ROWID).       
        IF T-ROWID <> ?
        THEN DO:
            FIND gn-prov WHERE ROWID(gn-prov) = T-ROWID NO-LOCK NO-ERROR.
            IF AVAILABLE gn-prov
            THEN DO:
                cb-dmov.CodAux:SCREEN-VALUE = gn-prov.CodPro.
                campo-aux:SCREEN-VALUE      = gn-prov.NomPro.
            END.
        END.
    END.
    WHEN "@CL" THEN DO:
      /*  RUN adm/q-clie.w(cl-codcia, OUTPUT T-ROWID).         */
        RUN ADM/H-CLIE01.W(s-codcia, OUTPUT T-ROWID).       
        IF T-ROWID <> ?
        THEN DO:
            FIND gn-clie WHERE ROWID(gn-clie) = T-ROWID NO-LOCK NO-ERROR.
            IF AVAIL gn-clie
            THEN DO:
                cb-dmov.CodAux:SCREEN-VALUE = gn-clie.CodCli.
                campo-aux:SCREEN-VALUE      = gn-clie.NomCli.
            END.
        END.
    END.
    WHEN "@CT" THEN DO:
  
            RUN cbd/q-ctas2.w(cb-codcia, "9", OUTPUT T-RECID).
            IF T-RECID <> ?
            THEN DO:
                find cb-ctas WHERE RECID(cb-ctas) = T-RECID NO-LOCK  NO-ERROR.
                IF avail cb-ctas
                THEN DO:
                    cb-dmov.CodAux:SCREEN-VALUE = cb-ctas.CodCta.
                    campo-aux:SCREEN-VALUE      = cb-ctas.NomCta.
                END.
  
        END.
    END.
    OTHERWISE DO:
      /*  RUN cbd/q-auxi.w(cb-codcia,cb-dmov.ClfAux, OUTPUT T-ROWID). */
        RUN cbd/H-auxi01.w(s-codcia,cb-dmov.ClfAux, OUTPUT T-ROWID).
        IF T-ROWID <> ?
        THEN DO:
            FIND cb-auxi WHERE ROWID(cb-auxi) = T-ROWID NO-LOCK  NO-ERROR.
            IF AVAIL cb-auxi
            THEN DO:
                cb-dmov.Codaux:SCREEN-VALUE = cb-auxi.CodAux.
                campo-aux:SCREEN-VALUE      = cb-auxi.NomAux.
            END.
        END.
    END.
    END CASE.
    RETURN NO-APPLY.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.CodAux D-Dialog
ON LEAVE OF cb-dmov.CodAux IN FRAME D-Dialog /* Auxiliar */
DO:
    IF LOOKUP(LAST-EVENT:FUNCTION, "ENDKEY,ERROR,END-ERROR,CHOOSE") <> 0
    THEN RETURN.

    DO ON ERROR UNDO, LEAVE:
        RUN Cfg-CodAux.
        RETURN.
    END.
    MESSAGE "Auxiliar no Registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmov.CodCta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.CodCta D-Dialog
ON F8 OF cb-dmov.CodCta IN FRAME D-Dialog /* Cuenta Contable */
OR "MOUSE-SELECT-DBLCLICK":U OF cb-dmov.CODCTA DO:
   /* RUN cbd/q-ctas2.w(cb-codcia,cb-dmov.CodCta:SCREEN-VALUE, OUTPUT ROWID-stack). */
    DEF VAR T-ROWID AS ROWID.
    RUN CBD/H-CTAS01(s-codcia, 0 , OUTPUT T-ROWID).
    IF T-ROWID <> ?
    THEN DO:
        find cb-ctas WHERE ROWID(cb-ctas) = T-ROWID NO-LOCK NO-ERROR.
        IF avail cb-ctas
        THEN DO:
            cb-dmov.CodCta:SCREEN-VALUE = cb-ctas.CodCta.
            x-NomCta:SCREEN-VALUE       = cb-ctas.NomCta.
            IF cb-ctas.PidDoc
            THEN DISPLAY cb-ctas.CodDoc @ cb-dmov.CodDoc WITH FRAME {&FRAME-NAME}.
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.
    APPLY "ENTRY":U TO cb-dmov.CodCta.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.CodCta D-Dialog
ON LEAVE OF cb-dmov.CodCta IN FRAME D-Dialog /* Cuenta Contable */
DO:
    IF LOOKUP(LAST-EVENT:FUNCTION, "ENDKEY,ERROR,END-ERROR,CHOOSE") <> 0
    THEN RETURN.
    find cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                       cb-ctas.CodCta = INPUT cb-dmov.CodCta
                       NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        BELL.
        MESSAGE "Cuenta no registrada" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cb-dmov.CodCta IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
    IF LENGTH(cb-dmov.CodCta:SCREEN-VALUE) <> 
        INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles))
    THEN DO:
        BELL.
        MESSAGE "Cuenta no afecta a movimientos" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    RUN Cfg-CodCta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmov.CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.CodDiv D-Dialog
ON F8 OF cb-dmov.CodDiv IN FRAME D-Dialog /* División */
OR "MOUSE-SELECT-DBLCLICK":U OF cb-dmov.CODDIV DO:
  {CBD/H-DIVI01.i YES x-NomDiv}
          
  
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.CodDiv D-Dialog
ON LEAVE OF cb-dmov.CodDiv IN FRAME D-Dialog /* División */
DO:
    IF LOOKUP(LAST-EVENT:FUNCTION, "ENDKEY,ERROR,END-ERROR,CHOOSE") <> 0
    THEN RETURN.
    
    FIND gn-divi  WHERE gn-divi.CodCia = S-codcia
                    AND gn-divi.coddiv = SELF:SCREEN-VALUE
                    NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-divi
    THEN DO:
        MESSAGE "C¢digo de Divisionaria no Registrado" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    x-NomDiv:SCREEN-VALUE = GN-DIVI.DESDIV.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmov.CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.CodDoc D-Dialog
ON F8 OF cb-dmov.CodDoc IN FRAME D-Dialog /* Cod.Docmto. */
DO:
    RUN cbd/q-clfaux.w("02", OUTPUT RECID-stack).
    IF RECID-stack <> 0
    THEN DO:
        FIND cb-tabl WHERE RECID( cb-tabl ) = RECID-stack
              NO-LOCK  NO-ERROR.
        IF AVAIL cb-tabl THEN DO:
             cb-dmov.CodDoc:SCREEN-VALUE = cb-tabl.codigo.
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.CodDoc D-Dialog
ON LEAVE OF cb-dmov.CodDoc IN FRAME D-Dialog /* Cod.Docmto. */
DO:
    IF LOOKUP(LAST-EVENT:FUNCTION, "ENDKEY,ERROR,END-ERROR,CHOOSE") <> 0
    THEN RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.CodDoc D-Dialog
ON MOUSE-SELECT-DBLCLICK OF cb-dmov.CodDoc IN FRAME D-Dialog /* Cod.Docmto. */
DO:
    APPLY "F8" TO cb-dmov.coddoc.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-codaux
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-codaux D-Dialog
ON ENTRY OF x-codaux IN FRAME D-Dialog /* Auxiliar */
DO:
    IF x-clfaux = "" THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-codaux D-Dialog
ON LEAVE OF x-codaux IN FRAME D-Dialog /* Auxiliar */
DO:
 DEF VAR OK AS LOGICAL.
 OK = FALSE.
    DO ON ERROR UNDO, LEAVE:
        RUN provision.
        IF RETURN-VALUE = "OK"  THEN OK=YES.
        RUN Cfg-CodCta.
        RETURN.
    END.
    
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME X-coddoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL X-coddoc D-Dialog
ON F8 OF X-coddoc IN FRAME D-Dialog /* Documento */
DO:
    RUN cja/q-docpro.w(cb-codcia, OUTPUT x-CodDoc).
    IF x-CodDoc  <> ?
    THEN x-Coddoc:SCREEN-VALUE = x-CodDoc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL X-coddoc D-Dialog
ON LEAVE OF X-coddoc IN FRAME D-Dialog /* Documento */
DO:
    IF x-coddoc:SCREEN-VALUE = "" THEN DO:
        ASSIGN
            x-nrodoc:SCREEN-VALUE = ""
            x-codaux:SCREEN-VALUE = ""
            x-nrodoc:SENSITIVE = FALSE
            x-codaux:SENSITIVE = FALSE
            integral.cb-dmov.Codaux:SENSITIVE = TRUE
            integral.cb-dmov.Codcta:SENSITIVE = TRUE
            integral.cb-dmov.CodDiv:SENSITIVE = TRUE
            integral.cb-dmov.Coddoc:SENSITIVE = TRUE
            integral.cb-dmov.Nrodoc:SENSITIVE = TRUE
            integral.cb-dmov.Nroref:SENSITIVE = TRUE.
        RETURN.
    END.
    FIND FIRST integral.cp-tpro WHERE integral.cp-tpro.codcia = cb-codcia AND
        integral.cp-tpro.coddoc = x-coddoc:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAIL integral.cp-tpro THEN DO:
        MESSAGE "Código de documento no existe" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO x-coddoc.
        RETURN NO-APPLY.
    END.
    ASSIGN
        x-nrodoc:SCREEN-VALUE = ""
        x-codaux:SCREEN-VALUE = ""
        x-nrodoc:SENSITIVE    = TRUE
        x-codaux:SENSITIVE    = TRUE
        x-codcta              = ""
        x-clfaux              = ""
        integral.cb-dmov.Codaux:SENSITIVE = FALSE
        integral.cb-dmov.Codcta:SENSITIVE = FALSE
        integral.cb-dmov.CodDiv:SENSITIVE = FALSE
        integral.cb-dmov.Coddoc:SENSITIVE = FALSE
        integral.cb-dmov.Nrodoc:SENSITIVE = FALSE
        integral.cb-dmov.Nroref:SENSITIVE = FALSE.
    APPLY "ENTRY" TO x-nrodoc.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL X-coddoc D-Dialog
ON MOUSE-SELECT-DBLCLICK OF X-coddoc IN FRAME D-Dialog /* Documento */
DO:
    APPLY "F8" TO x-coddoc.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-div
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-div D-Dialog
ON ENTRY OF x-div IN FRAME D-Dialog /* División */
DO:
   IF SELF:SCREEN-VALUE = "" THEN SELF:SCREEN-VALUE = cb-dmov.CODDIV.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-div D-Dialog
ON F8 OF x-div IN FRAME D-Dialog /* División */
OR "MOUSE-SELECT-DBLCLICK":U OF x-div DO:
 {CBD/H-DIVI01.I NO SELF}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-div D-Dialog
ON LEAVE OF x-div IN FRAME D-Dialog /* División */
DO:
      IF LENGTH(SELF:SCREEN-VALUE) < 5 THEN DO:
         MESSAGE "Divisi¢n no tiene movimiento" VIEW-AS ALERT-BOX ERROR.
         RETURN NO-APPLY.
      END.
      FIND FIRST GN-DIVI  WHERE GN-DIVI.codcia  =  S-codcia AND 
                                GN-DIVI.codDIV  =  SELF:SCREEN-VALUE
                                NO-LOCK NO-ERROR.                                
      IF NOT AVAIL GN-DIVI THEN DO:
         MESSAGE "Divisi¢n no registrada" VIEW-AS ALERT-BOX ERROR.
         RETURN NO-APPLY.
      END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-importe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-importe D-Dialog
ON MOUSE-SELECT-DBLCLICK OF x-importe IN FRAME D-Dialog /* Importe */
OR "F8":U OF X-IMPORTE DO:
   DEF VAR P-RESULT AS DECIMAL.
   RUN CJA/D-CONVER.W( CB-DMOV.TPOCMB , CB-DMOV.CODMON , OUTPUT P-RESULT).
   IF P-RESULT <> ? THEN 
      DISPLAY P-RESULT @ X-IMPORTE WITH FRAME {&FRAME-NAME}.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NroDoc D-Dialog
ON LEAVE OF x-NroDoc IN FRAME D-Dialog
DO:
    IF x-div:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Código de División no válido"
       VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO x-div IN FRAME {&FRAME-NAME}.
       RETURN NO-APPLY.
    END.
    DO ON ERROR UNDO, LEAVE:
        RUN chk_provision.
        RETURN.
    END.
    MESSAGE "Documento no existe" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

 FIND integral.cb-dmov WHERE RECID( integral.cb-dmov ) = RegAct NO-ERROR.

    IF NOT AVAIL integral.cb-dmov THEN DO:
        MESSAGE "Registro de detalle inválido" VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    
    x-div = cb-dmov.coddiv.
    IF cb-dmov.tpoitm = "P" THEN
        ASSIGN x-coddoc = cb-dmov.coddoc
               x-nrodoc = cb-dmov.nrodoc
               x-codaux = cb-dmov.codaux.

    FIND cb-cfga WHERE cb-cfga.CodCia = cb-codcia AND cb-cfga.CodCfg = 1
        NO-LOCK NO-ERROR.
    IF AVAILABLE cb-cfga THEN
        IF cb-cfga.CodDiv THEN
            ASSIGN cb-dmov.CodDiv:VISIBLE = YES
                   x-NomDiv:VISIBLE       = YES.
        ELSE ASSIGN cb-dmov.CodDiv:VISIBLE = NO
                    x-NomDiv:VISIBLE       = NO.

    find cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                       cb-ctas.CodCta = cb-dmov.CodCta NO-LOCK NO-ERROR.
    IF AVAILABLE cb-ctas THEN RUN Cfg-CodCta.
    
    APPLY "ENTRY" TO x-div IN FRAME {&FRAME-NAME}.
    
{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CFG-CODAUX D-Dialog 
PROCEDURE CFG-CODAUX :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF cb-dmov.CodAux:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '' THEN RETURN ERROR.
CASE cb-dmov.clfaux :
        WHEN "@PV" THEN DO:
            FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND
                gn-prov.CodPro = cb-dmov.CodAux:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-prov
            THEN RETURN ERROR.
            /* Proveedor Cesado */
            IF gn-prov.flgsit = 'C' THEN DO:
                MESSAGE 'Proveedor Cesado' VIEW-AS ALERT-BOX ERROR.
                RETURN ERROR.
            END.
            DISPLAY gn-prov.NomPro @ campo-aux WITH FRAME {&FRAME-NAME}.
            integral.cb-dmov.nroruc = gn-prov.ruc.
        END.
        WHEN "@CL" THEN DO:
            FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
                gn-clie.CodCli = cb-dmov.CodAux:SCREEN-VALUE  IN FRAME {&FRAME-NAME}
                                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-clie
            THEN RETURN ERROR.
            DISPLAY  gn-clie.NomCli @ campo-aux WITH FRAME {&FRAME-NAME}.
            integral.cb-dmov.nroruc = gn-clie.ruc.
        END.
        WHEN "@CT"  THEN DO:
                IF LENGTH(cb-dmov.Codaux:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <>
                    INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles))
                THEN RETURN ERROR.
                find B-CTAS WHERE B-CTAS.CodCia = cb-codcia AND
                     B-CTAS.CodCta =
                         cb-dmov.CodAux:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                               NO-LOCK NO-ERROR.
                IF NOT AVAILABLE B-CTAS
                THEN RETURN ERROR.
                DISPLAY B-CTAS.NomCta @ campo-aux  WITH FRAME {&FRAME-NAME}.
        
        END.
        OTHERWISE DO:
            FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia AND
                                cb-auxi.ClfAux = cb-dmov.ClfAux AND
                                cb-auxi.CodAux = cb-dmov.CodAux:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                               NO-LOCK NO-ERROR.
            IF NOT AVAILABLE cb-auxi
            THEN RETURN ERROR.
            DISPLAY cb-auxi.NomAux @ campo-aux  WITH FRAME {&FRAME-NAME}.
        END.
END CASE.
x-girado = campo-aux:SCREEN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CFG-CODCTA D-Dialog 
PROCEDURE CFG-CODCTA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DISPLAY cb-ctas.NomCta @ x-NomCta WITH FRAME {&FRAME-NAME}.
    IF cb-cfga.CodDiv AND cb-dmov.CodDiv = ""
    THEN cb-dmov.CodDiv:SCREEN-VALUE = cb-ctas.CodDiv.

    IF cb-ctas.PidAux
    THEN DO:
            ASSIGN cb-dmov.CodAux:VISIBLE = YES
                   cb-dmov.ClfAux         = cb-ctas.clfaux.
        
        DO ON ERROR UNDO,LEAVE:
            RUN Cfg-CodAux.
        END.
    END.
    ELSE
        ASSIGN
            cb-dmov.CodAux:HIDDEN = YES
            campo-aux:HIDDEN      = YES.

    IF cb-ctas.PidCco THEN ASSIGN cb-dmov.Cco:VISIBLE = YES.
                      ELSE ASSIGN cb-dmov.Cco:HIDDEN = YES.
    IF cb-ctas.PidDoc THEN DO:
        ASSIGN cb-dmov.CodDoc:VISIBLE = YES
               cb-dmov.NroDoc:VISIBLE = YES.
        IF   cb-dmov.CodDoc:SCREEN-VALUE = ""
        THEN cb-dmov.CodDoc:SCREEN-VALUE = cb-ctas.CodDoc.
    END.
    ELSE
        ASSIGN cb-dmov.CodDoc:HIDDEN = YES
               cb-dmov.NroDoc:HIDDEN = YES.


    FIND integral.cp-tpro WHERE integral.cp-tpro.codcia = cb-codcia AND
        integral.cp-tpro.codcta = INPUT integral.cb-dmov.codcta AND
        integral.cp-tpro.codope = integral.cb-dmov.codope NO-LOCK NO-ERROR.
    IF AVAILABLE integral.cp-tpro THEN DO:
        ASSIGN cb-dmov.CodDoc:VISIBLE = YES
               cb-dmov.NroDoc:VISIBLE = YES
               cb-dmov.CodDoc:VISIBLE = YES.
    END.

    IF cb-ctas.PidRef
    THEN ASSIGN cb-dmov.NroRef:VISIBLE      = YES.
    ELSE ASSIGN cb-dmov.NroRef:HIDDEN       = YES
                cb-dmov.NroRef:SCREEN-VALUE = "".

    /* RHC 31.01.2012 Gasto sustentado */
    IF cb-ctas.Sustento = YES THEN DO:
        ASSIGN
            cb-dmov.Log_01:VISIBLE = YES
            cb-dmov.Log_01:SENSITIVE = YES.
    END.
    ELSE DO:
        ASSIGN
            cb-dmov.Log_01:VISIBLE = NO
            cb-dmov.Log_01:SENSITIVE = NO.
    END.


    IF cb-dmov.codmon = 1
    THEN
        x-Importe = integral.cb-dmov.ImpMn1.
    ELSE
        x-Importe = integral.cb-dmov.ImpMn2.
    IF CB-DMOV.TPOMOV THEN x-Importe = - x-Importe.    
    DISPLAY x-Importe format "(ZZZ,ZZZ,ZZ9.99)" WITH FRAME {&FRAME-NAME}.
    IF NEW cb-dmov THEN DO:
        IF cb-dmov.LOG_01:VISIBLE THEN cb-dmov.LOG_01:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Yes' .
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CHK_PROVISION D-Dialog 
PROCEDURE CHK_PROVISION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH integral.cp-tpro WHERE integral.cp-tpro.codcia = cb-codcia AND
        integral.cp-tpro.coddoc = x-coddoc:SCREEN-VALUE IN FRAME {&FRAME-NAME}:
        FIND FIRST detalle WHERE detalle.codcia = s-codcia AND
            detalle.periodo = s-periodo AND
            detalle.codcta  = integral.cp-tpro.codcta AND
            detalle.coddoc  = x-coddoc:SCREEN-VALUE AND
            detalle.nrodoc  = x-nrodoc:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAIL detalle THEN DO:
            x-codaux:SCREEN-VALUE = detalle.codaux.
            x-codcta = integral.cp-tpro.codcta.
            x-clfaux = "".
            FIND integral.cb-ctas WHERE integral.cb-ctas.codcia = cb-codcia AND
                integral.cb-ctas.codcta = x-codcta NO-LOCK NO-ERROR.
            IF AVAIL integral.cb-ctas THEN DO:
                x-clfaux = integral.cb-ctas.clfaux.
            END.
            RETURN.
        END.
    END.
    RETURN ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY x-div X-coddoc x-NroDoc x-codaux x-NomCta campo-aux x-importe 
      WITH FRAME D-Dialog.
  IF AVAILABLE cb-dmov THEN 
    DISPLAY cb-dmov.CodCta cb-dmov.CodDiv cb-dmov.CodAux cb-dmov.C-FCaja 
          cb-dmov.CCo cb-dmov.CodDoc cb-dmov.NroDoc cb-dmov.NroRef 
          cb-dmov.GloDoc cb-dmov.TpoCmb cb-dmov.FchVto cb-dmov.Chr_01 
          cb-dmov.Log_01 
      WITH FRAME D-Dialog.
  ENABLE RECT-5 RECT-4 RECT-6 x-div X-coddoc x-NroDoc x-codaux cb-dmov.CodCta 
         cb-dmov.CodDiv cb-dmov.CodAux cb-dmov.C-FCaja cb-dmov.CCo 
         cb-dmov.CodDoc cb-dmov.NroDoc cb-dmov.NroRef cb-dmov.GloDoc x-importe 
         cb-dmov.TpoCmb cb-dmov.FchVto cb-dmov.Chr_01 cb-dmov.Log_01 Btn_OK 
         Btn_Cancel BUTTON-14 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROVISION D-Dialog 
PROCEDURE PROVISION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Calculando los saldos */
        ASSIGN FRAME {&FRAME-NAME}
           x-coddoc
           x-nrodoc
           x-codaux
           x-SdoMn1 = 0
           x-SdoMn2 = 0
           RECID-ok = ?
           x-nroast = ?
           x-nromes = ?
           x-codope = ?.

    DEF VAR X-MonCta AS INTEGER.
    X-MonCta = 0 .
           
    FIND FIRST integral.cp-tpro WHERE integral.cp-tpro.codcia = cb-codcia AND
                                       integral.cp-tpro.coddoc = x-coddoc   
                                       NO-LOCK NO-ERROR.
    REPEAT:
        X-MonCta =                0.
        x-CodCta =  cp-tpro.CodCta.
        find cb-ctas WHERE cb-ctas.CODCIA = cb-codcia AND
                           cb-ctas.CODCTA = X-CODCTA 
                           NO-LOCK NO-ERROR.
        IF avail cb-ctas THEN X-MonCta = cb-ctas.CodMon.
        ASSIGN 
           x-SdoMn1 = 0
           x-SdoMn2 = 0
           RECID-ok = ?
           x-nroast = ?
           x-nromes = ?
           x-codope = ?.
        FOR EACH DETALLE WHERE detalle.codcia  = s-codcia AND
                               detalle.periodo = s-periodo    AND
                               detalle.codcta  = x-codcta AND
                               detalle.codaux  = x-codaux AND
                               detalle.coddoc  = x-coddoc AND
                               detalle.nrodoc  = x-nrodoc AND
                               detalle.coddiv  = input x-div    
                               NO-LOCK: 
            if detalle.nromes > cb-dmov.nromes then do:
               message "Se ha encontrado movimiento " skip
                       "del documento en un mes posterior:"  skip
                       detalle.nromes "-" detalle.codope "-" detalle.nroast skip
                       "El saldo calculado incluye todos los movimientos" skip
                       "incluyendo los posteriores"
                       view-as alert-box informa.          
            
            end.                   
            IF detalle.TpoMov
            THEN ASSIGN x-SdoMn1 = x-SdoMn1 + detalle.ImpMn1           
                        x-SdoMn2 = x-SdoMn2 + detalle.ImpMn2.
            ELSE ASSIGN x-SdoMn1 = x-SdoMn1 - detalle.ImpMn1           
                        x-SdoMn2 = x-SdoMn2 - detalle.ImpMn2.

            IF AVAIL integral.cp-tpro AND 
                     (integral.cp-tpro.codope = detalle.codope OR detalle.codope = "000")    /* Y la apertura? */
            THEN ASSIGN RECID-ok = RECID( detalle )
                        x-nroast = detalle.nroast
                        x-nromes = detalle.nromes
                        x-codope = detalle.codope.
            ELSE DO:
                 IF AVAIL integral.cp-tpro AND 
                    detalle.nromes = 0 then  
                    ASSIGN 
                        RECID-ok = RECID( detalle )
                        x-nroast = detalle.nroast
                        x-nromes = detalle.nromes
                        x-codope = detalle.codope.
                        
            END.            
                         
        END.

        IF RECID-ok <> ? THEN  LEAVE.        

        FIND NEXT integral.cp-tpro WHERE integral.cp-tpro.codcia = cb-codcia 
                                      AND integral.cp-tpro.coddoc = x-coddoc   
                                       NO-LOCK.
                                       
    END.
    IF RECID-ok = ?
    THEN DO:
        MESSAGE "Provisión no registrada" VIEW-AS ALERT-BOX ERROR.        
        RETURN ERROR.
    END.
    FIND FIRST cb-cmov WHERE cb-cmov.codcia = s-codcia  AND
                             cb-cmov.periodo = s-periodo    AND
                             cb-cmov.nromes = x-nromes  AND
                             cb-cmov.codope = x-codope  AND
                             cb-cmov.nroast = x-nroast
                          NO-LOCK NO-ERROR.
    IF NOT AVAIL cb-cmov
    THEN DO:
        MESSAGE "Provisión mal registrado" VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.

    /*ML01* 24/Jun/2008 ***/
    IF cb-cmov.FchAst > fFchAst THEN DO:
        MESSAGE
            "Fecha de PROVISIÓN no puede ser mayor"
            "a la fecha de de CANCELACIÓN"
            VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.

    FIND detalle WHERE RECID-ok = RECID( detalle ) NO-LOCK NO-ERROR.
    
    ASSIGN
        cb-dmov.tpoitm = "P"
        cb-dmov.relacion = RECID ( cb-cmov )
        x-notast = cb-cmov.notast
        cb-dmov.codcta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = detalle.codcta
        cb-dmov.coddiv:SCREEN-VALUE IN FRAME {&FRAME-NAME} = detalle.coddiv
        cb-dmov.clfaux              = detalle.clfaux
        cb-dmov.codaux:SCREEN-VALUE IN FRAME {&FRAME-NAME} = detalle.codaux
        cb-dmov.nroruc              = detalle.nroruc
        cb-dmov.coddoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = detalle.coddoc
        cb-dmov.cco:SCREEN-VALUE IN FRAME {&FRAME-NAME}    = detalle.cco
        cb-dmov.nrodoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = detalle.nrodoc
        cb-dmov.nroref:SCREEN-VALUE IN FRAME {&FRAME-NAME} = detalle.nroref
        cb-dmov.tpomov              = ( X-importe < 0 )
        cb-dmov.glodoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = DETALLE.GLODOC
        cb-dmov.impmn1              = ABS( x-SdoMn1)
        cb-dmov.impmn2              = ABS( x-SdoMn2)
        cb-dmov.tm                  = 0.
        IF 
        cb-dmov.glodoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN 
        ASSIGN cb-dmov.glodoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cb-Cmov.NOTAST.
    CASE x-moncta   :
    WHEN  1 
        THEN DO:
            x-Importe   = x-SdoMn1.
            cb-dmov.tm  = 1. 
    END.
    WHEN 2 THEN 
    DO:
        x-Importe  = x-SdoMn2.
        cb-dmov.tm = 2.
        
             
    END.
    OTHERWISE DO:
        IF cb-dmov.codmon = 1 THEN  x-Importe = x-SdoMn1.
                              ELSE  x-Importe = x-SdoMn2.
        IF detalle.codmon = 1 THEN  cb-dmov.tm = 1.
                              ELSE  cb-dmov.tm = 2.                      
        END.                      
    END. /*FIN DEL CASE */
    
    x-Importe = ABSOLUTE (x-Importe).
    
    DISPLAY x-Importe FORMAT "(ZZZ,ZZZ,ZZ9.99)" WITH FRAME {&FRAME-NAME}.
    FIND integral.cb-ctas WHERE integral.cb-ctas.codcia = cb-codcia AND
        integral.cb-ctas.codcta = integral.cb-dmov.codcta:SCREEN-VALUE
        NO-LOCK.
    RETURN "OK".    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "cb-dmov"}

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

