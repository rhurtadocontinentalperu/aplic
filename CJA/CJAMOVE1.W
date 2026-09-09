&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 07/19/95 -  9:03 am

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

&IF "{&NEW}" = "" &THEN
    DEFINE INPUT  PARAMETER RegAct   AS RECID.
    DEFINE OUTPUT PARAMETER x-girado AS CHARACTER.
    DEFINE OUTPUT PARAMETER x-notast AS CHARACTER.
&ELSE
    DEFINE VARIABLE RegAct   AS RECID.
    DEFINE VARIABLE x-girado AS CHARACTER.
    DEFINE VARIABLE x-notast AS CHARACTER.
    FIND FIRST cb-dmov.
    regact = RECID( integral.cb-dmov ).
&ENDIF

/* Local Variable Definitions ---                                       */

DEFINE {&NEW} SHARED VARIABLE s-codcia       AS INTEGER INITIAL 2.
DEFINE {&NEW} SHARED VARIABLE s-periodo          AS INTEGER INITIAL 1996.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-dmov

/* Definitions for DIALOG-BOX DIALOG-1                                  */
&Scoped-define FIELDS-IN-QUERY-DIALOG-1 cb-dmov.Codcta cb-dmov.CodDiv ~
cb-dmov.Codaux cb-dmov.C-Fcaja cb-dmov.cco cb-dmov.Coddoc cb-dmov.Nroref ~
cb-dmov.Glodoc cb-dmov.Nrodoc 
&Scoped-define ENABLED-FIELDS-IN-QUERY-DIALOG-1 cb-dmov.Codcta ~
cb-dmov.CodDiv cb-dmov.Codaux cb-dmov.C-Fcaja cb-dmov.cco cb-dmov.Coddoc ~
&Scoped-define ENABLED-TABLES-IN-QUERY-DIALOG-1 cb-dmov
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-DIALOG-1 cb-dmov

&Scoped-define FIELD-PAIRS-IN-QUERY-DIALOG-1~
 ~{&FP1}Codcta ~{&FP2}Codcta ~{&FP3}~
 ~{&FP1}CodDiv ~{&FP2}CodDiv ~{&FP3}~
 ~{&FP1}Codaux ~{&FP2}Codaux ~{&FP3}~
 ~{&FP1}C-Fcaja ~{&FP2}C-Fcaja ~{&FP3}~
 ~{&FP1}cco ~{&FP2}cco ~{&FP3}~
 ~{&FP1}Coddoc ~{&FP2}Coddoc ~{&FP3}~
 ~{&FP1}Nroref ~{&FP2}Nroref ~{&FP3}~
 ~{&FP1}Glodoc ~{&FP2}Glodoc ~{&FP3}~
 ~{&FP1}Nrodoc ~{&FP2}Nrodoc ~{&FP3}
&Scoped-define OPEN-QUERY-DIALOG-1 OPEN QUERY DIALOG-1 FOR EACH cb-dmov SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-DIALOG-1 cb-dmov
&Scoped-define FIRST-TABLE-IN-QUERY-DIALOG-1 cb-dmov


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cb-dmov.Codcta cb-dmov.CodDiv cb-dmov.Codaux ~
cb-dmov.C-Fcaja cb-dmov.cco cb-dmov.Coddoc cb-dmov.Nroref cb-dmov.Glodoc ~
cb-dmov.Nrodoc 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}Codcta ~{&FP2}Codcta ~{&FP3}~
 ~{&FP1}CodDiv ~{&FP2}CodDiv ~{&FP3}~
 ~{&FP1}Codaux ~{&FP2}Codaux ~{&FP3}~
 ~{&FP1}C-Fcaja ~{&FP2}C-Fcaja ~{&FP3}~
 ~{&FP1}cco ~{&FP2}cco ~{&FP3}~
 ~{&FP1}Coddoc ~{&FP2}Coddoc ~{&FP3}~
 ~{&FP1}Nroref ~{&FP2}Nroref ~{&FP3}~
 ~{&FP1}Glodoc ~{&FP2}Glodoc ~{&FP3}~
 ~{&FP1}Nrodoc ~{&FP2}Nrodoc ~{&FP3}
&Scoped-define ENABLED-TABLES cb-dmov
&Scoped-define FIRST-ENABLED-TABLE cb-dmov
&Scoped-Define ENABLED-OBJECTS RECT-6 RECT-4 RECT-5 x-div X-coddoc x-codaux ~
x-importe b-aceptar x-NroDoc b-cancelar 
&Scoped-Define DISPLAYED-FIELDS cb-dmov.Codcta cb-dmov.CodDiv ~
cb-dmov.Codaux cb-dmov.C-Fcaja cb-dmov.cco cb-dmov.Coddoc cb-dmov.Nroref ~
cb-dmov.Glodoc cb-dmov.Nrodoc 
&Scoped-Define DISPLAYED-OBJECTS x-div X-coddoc x-codaux x-importe x-NroDoc ~
x-NomCta campo-aux 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-aceptar AUTO-GO 
     LABEL "&Aceptar" 
     SIZE 9.72 BY 1.08.

DEFINE BUTTON b-cancelar AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 9.72 BY 1.08.

DEFINE VARIABLE campo-aux AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

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
     VIEW-AS FILL-IN 
     SIZE 20 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-NomCta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-NomDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-NroDoc AS CHARACTER FORMAT "X(10)":U 
     VIEW-AS FILL-IN 
     SIZE 16 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 77 BY 8.62
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 76.86 BY 1.62
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 77 BY 4.04
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY DIALOG-1 FOR 
      cb-dmov SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     x-div AT ROW 2.35 COL 16 COLON-ALIGNED
     X-coddoc AT ROW 3.15 COL 16 COLON-ALIGNED
     x-codaux AT ROW 4 COL 16 COLON-ALIGNED
     cb-dmov.Codcta AT ROW 5.31 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 15 
     cb-dmov.CodDiv AT ROW 6.31 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 15 
     cb-dmov.Codaux AT ROW 7.31 COL 16 COLON-ALIGNED FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 15 
     cb-dmov.C-Fcaja AT ROW 8.27 COL 16 COLON-ALIGNED
          LABEL "C¢ncepto  F.Caja" FORMAT "x(7)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     cb-dmov.cco AT ROW 9.08 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     cb-dmov.Coddoc AT ROW 9.92 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
          BGCOLOR 15 FGCOLOR 0 
     cb-dmov.Nroref AT ROW 10.65 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
          BGCOLOR 15 
     cb-dmov.Glodoc AT ROW 11.46 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 58 BY .81
          BGCOLOR 15 
     x-importe AT ROW 12.54 COL 16 COLON-ALIGNED
     b-aceptar AT ROW 13.92 COL 19
     x-NroDoc AT ROW 3.15 COL 25 COLON-ALIGNED NO-LABEL
     cb-dmov.Nrodoc AT ROW 9.92 COL 26 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
          BGCOLOR 15 
     x-NomCta AT ROW 5.31 COL 29 COLON-ALIGNED NO-LABEL
     x-NomDiv AT ROW 6.31 COL 29 COLON-ALIGNED NO-LABEL
     campo-aux AT ROW 7.31 COL 29 COLON-ALIGNED NO-LABEL
     b-cancelar AT ROW 13.92 COL 52
     RECT-6 AT ROW 1 COL 1
     "PROVISION" VIEW-AS TEXT
          SIZE 12.72 BY 1.04 AT ROW 1.23 COL 3.57
          FONT 11
     RECT-4 AT ROW 5.04 COL 1
     RECT-5 AT ROW 13.65 COL 1
     SPACE(0.14) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "MOVIMIENTOS".

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DIALOG-1
   Default                                                              */
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN cb-dmov.C-Fcaja IN FRAME DIALOG-1
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN campo-aux IN FRAME DIALOG-1
   NO-ENABLE                                                            */
ASSIGN 
       campo-aux:HIDDEN IN FRAME DIALOG-1           = TRUE.

/* SETTINGS FOR FILL-IN cb-dmov.Codaux IN FRAME DIALOG-1
   EXP-FORMAT                                                           */
ASSIGN 
       cb-dmov.Codaux:HIDDEN IN FRAME DIALOG-1           = TRUE.

ASSIGN 
       cb-dmov.CodDiv:HIDDEN IN FRAME DIALOG-1           = TRUE.

ASSIGN 
       cb-dmov.Coddoc:HIDDEN IN FRAME DIALOG-1           = TRUE.

ASSIGN 
       cb-dmov.Glodoc:HIDDEN IN FRAME DIALOG-1           = TRUE.

ASSIGN 
       cb-dmov.Nrodoc:HIDDEN IN FRAME DIALOG-1           = TRUE.

ASSIGN 
       cb-dmov.Nroref:HIDDEN IN FRAME DIALOG-1           = TRUE.

/* SETTINGS FOR FILL-IN x-NomCta IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomDiv IN FRAME DIALOG-1
   NO-DISPLAY NO-ENABLE                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX DIALOG-1
/* Query rebuild information for DIALOG-BOX DIALOG-1
     _TblList          = "integral.cb-dmov"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX DIALOG-1 */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b-aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-aceptar DIALOG-1
ON CHOOSE OF b-aceptar IN FRAME DIALOG-1 /* Aceptar */
DO:
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
        NOT CAN-FIND(cb-auxi WHERE cb-auxi.CodCia = cb-codcia AND
        cb-auxi.ClfAux = "00" AND cb-auxi.CodAux = cb-dmov.CodDiv )
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
            MESSAGE "Inv lido C¢digo Auxiliar" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY":U TO cb-dmov.CodAux.
            RETURN NO-APPLY.
        END.
    /* CodDoc */
    IF cb-ctas.PidDoc AND
        NOT CAN-FIND(cb-tabl WHERE cb-tabl.Tabla  = "02" AND
        cb-tabl.Codigo = cb-dmov.CodDoc:SCREEN-VALUE)
    THEN DO:
        MESSAGE "Inv lido C¢digo de Documento" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO cb-dmov.CodDoc.
        RETURN NO-APPLY.
    END.
    /* NroDoc */
    IF cb-ctas.PidDoc AND cb-dmov.Nrodoc:SCREEN-VALUE = ""
    THEN DO:
        MESSAGE "Inv lido No. de Documento" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO cb-dmov.NroDoc.
        RETURN NO-APPLY.
    END.
    FIND FIRST cb-auxi WHERE cb-auxi.codcia  =  cb-codcia AND 
                                cb-auxi.clfaux  =  "@FC"       AND
                                cb-auxi.codaux  =  INPUT cb-dmov.C-FCAJA
                                NO-LOCK NO-ERROR.                                
    IF NOT AVAIL cb-auxi THEN DO:
         MESSAGE "C¢digo de Flujo de Caja no registrado" VIEW-AS ALERT-BOX ERROR.
         RETURN NO-APPLY.
    END.                          
    
    /* Centro de Costo */
    IF cb-ctas.Pidcco AND 
       NOT CAN-FIND(cb-auxi WHERE cb-auxi.CodCia  = cb-codcia AND
        cb-auxi.Clfaux = "CCO" AND cb-auxi.CodAux = cb-dmov.Cco:SCREEN-VALUE)
    THEN DO:
        MESSAGE "Inv lido Centro de Costo" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO cb-dmov.Cco.
        RETURN NO-APPLY.
    END.

    /* Importes */
    IF INPUT x-Importe = 0 THEN DO:
        MESSAGE "Inv lido Importe Registrado" VIEW-AS ALERT-BOX ERROR.
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
               cb-dmov.CtaAut = INPUT FRAME DIALOG-1 cb-dmov.CodAux.
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
    ASSIGN FRAME DIALOG-1
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
           cb-dmov.flgact = false.
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
            IF (cb-dmov.CODMON = 1 AND ABS(x-importe) < cb-dmov.ImpMn1 ) THEN
            DO:
                cb-dmov.ImpMn1 = ABS( x-importe ).
                IF cb-dmov.tpocmb = 0 THEN
                   cb-dmov.ImpMn2 = 0.
                ELSE
                cb-dmov.ImpMn2 = ( ABS( x-importe ) / cb-dmov.tpocmb ).
            END.
            IF (cb-dmov.CODMON = 2 AND ABS(x-importe) < cb-dmov.ImpMn2 ) THEN
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


&Scoped-define SELF-NAME cb-dmov.C-Fcaja
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.C-Fcaja DIALOG-1
ON F8 OF cb-dmov.C-Fcaja IN FRAME DIALOG-1 /* C¢ncepto  F.Caja */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.C-Fcaja DIALOG-1
ON LEAVE OF cb-dmov.C-Fcaja IN FRAME DIALOG-1 /* C¢ncepto  F.Caja */
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


&Scoped-define SELF-NAME cb-dmov.cco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.cco DIALOG-1
ON F8 OF cb-dmov.cco IN FRAME DIALOG-1 /* Centro de Costo */
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


&Scoped-define SELF-NAME cb-dmov.Codaux
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.Codaux DIALOG-1
ON F8 OF cb-dmov.Codaux IN FRAME DIALOG-1 /* Cod.Auxiliar */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.Codaux DIALOG-1
ON LEAVE OF cb-dmov.Codaux IN FRAME DIALOG-1 /* Cod.Auxiliar */
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


&Scoped-define SELF-NAME cb-dmov.Codcta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.Codcta DIALOG-1
ON F8 OF cb-dmov.Codcta IN FRAME DIALOG-1 /* Cuenta Contable */
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
            THEN DISPLAY cb-ctas.CodDoc @ cb-dmov.CodDoc WITH FRAME DIALOG-1.
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.
    APPLY "ENTRY":U TO cb-dmov.CodCta.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.Codcta DIALOG-1
ON LEAVE OF cb-dmov.Codcta IN FRAME DIALOG-1 /* Cuenta Contable */
DO:
    IF LOOKUP(LAST-EVENT:FUNCTION, "ENDKEY,ERROR,END-ERROR,CHOOSE") <> 0
    THEN RETURN.
    find cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                       cb-ctas.CodCta = INPUT cb-dmov.CodCta
                       NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
        BELL.
        MESSAGE "Cuenta no registrada" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cb-dmov.CodCta IN FRAME DIALOG-1.
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.CodDiv DIALOG-1
ON F8 OF cb-dmov.CodDiv IN FRAME DIALOG-1 /* Divisionaria */
OR "MOUSE-SELECT-DBLCLICK":U OF cb-dmov.CODDIV DO:
  /*  RUN cbd/q-auxi.w(cb-codcia, "00", OUTPUT RECID-stack). */
    DEF VAR T-ROWID AS ROWID.
    RUN CBD/H-AUXI01.W(s-codcia, "00" , OUTPUT T-ROWID).
    IF T-ROWID <> ?
    THEN DO:
        FIND cb-auxi WHERE ROWID(cb-auxi) = T-ROWID NO-LOCK  NO-ERROR.
        IF AVAIL cb-auxi
        THEN DO:
            cb-dmov.CodDiv:SCREEN-VALUE = cb-auxi.CodAux.
            x-NomDiv:SCREEN-VALUE       = cb-auxi.NomAux.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.CodDiv DIALOG-1
ON LEAVE OF cb-dmov.CodDiv IN FRAME DIALOG-1 /* Divisionaria */
DO:
    IF LOOKUP(LAST-EVENT:FUNCTION, "ENDKEY,ERROR,END-ERROR,CHOOSE") <> 0
    THEN RETURN.
    FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia
                    AND cb-auxi.CLFAUX = "00"
                    AND cb-auxi.CodAUX = SELF:SCREEN-VALUE
                    NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-auxi
    THEN DO:
        MESSAGE "C¢digo de Divisionaria no Registrado" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    DISPLAY cb-auxi.NomAux @ x-NomDiv WITH FRAME DIALOG-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmov.Coddoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.Coddoc DIALOG-1
ON F8 OF cb-dmov.Coddoc IN FRAME DIALOG-1 /* Cod.Doc */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.Coddoc DIALOG-1
ON LEAVE OF cb-dmov.Coddoc IN FRAME DIALOG-1 /* Cod.Doc */
DO:
    IF LOOKUP(LAST-EVENT:FUNCTION, "ENDKEY,ERROR,END-ERROR,CHOOSE") <> 0
    THEN RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmov.Coddoc DIALOG-1
ON MOUSE-SELECT-DBLCLICK OF cb-dmov.Coddoc IN FRAME DIALOG-1 /* Cod.Doc */
DO:
    APPLY "F8" TO cb-dmov.coddoc.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-codaux
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-codaux DIALOG-1
ON ENTRY OF x-codaux IN FRAME DIALOG-1 /* Auxiliar */
DO:
    IF x-clfaux = "" THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-codaux DIALOG-1
ON LEAVE OF x-codaux IN FRAME DIALOG-1 /* Auxiliar */
DO:
    DO ON ERROR UNDO, LEAVE:
        RUN provision.
        RUN Cfg-CodCta.
        RETURN.
    END.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME X-coddoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL X-coddoc DIALOG-1
ON F8 OF X-coddoc IN FRAME DIALOG-1 /* Documento */
DO:
    RUN cja/q-docpro.w(cb-codcia, OUTPUT x-CodDoc).
    IF x-CodDoc  <> ?
    THEN x-Coddoc:SCREEN-VALUE = x-CodDoc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL X-coddoc DIALOG-1
ON LEAVE OF X-coddoc IN FRAME DIALOG-1 /* Documento */
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
        MESSAGE "C¢digo de documento no existe" VIEW-AS ALERT-BOX ERROR.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL X-coddoc DIALOG-1
ON MOUSE-SELECT-DBLCLICK OF X-coddoc IN FRAME DIALOG-1 /* Documento */
DO:
    APPLY "F8" TO x-coddoc.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-div
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-div DIALOG-1
ON ENTRY OF x-div IN FRAME DIALOG-1 /* División */
DO:
   IF SELF:SCREEN-VALUE = "" THEN SELF:SCREEN-VALUE = cb-dmov.CODDIV.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-div DIALOG-1
ON F8 OF x-div IN FRAME DIALOG-1 /* División */
OR "MOUSE-SELECT-DBLCLICK":U OF x-div DO:
   def var X-ROWID AS ROWID.
   RUN cbd/H-auxi01.w(s-codcia, "00",OUTPUT X-ROWID).
   IF X-ROWID <> ? THEN DO:
      FIND cb-auxi WHERE ROWID(cb-auxi) = X-ROWID
        NO-LOCK NO-ERROR.
      IF AVAIL cb-auxi THEN ASSIGN self:screen-value = cb-auxi.codaux.
      ELSE DO:
           MESSAGE "Divisi¢n no registrada" VIEW-AS ALERT-BOX ERROR.
           RETURN NO-APPLY.    
      END.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-div DIALOG-1
ON LEAVE OF x-div IN FRAME DIALOG-1 /* División */
DO:
      IF LENGTH(SELF:SCREEN-VALUE) < 5 THEN DO:
         MESSAGE "Divisi¢n no tiene movimiento" VIEW-AS ALERT-BOX ERROR.
         RETURN NO-APPLY.
      END.
      FIND FIRST cb-auxi WHERE cb-auxi.codcia  =  cb-codcia AND 
                                cb-auxi.clfaux  =  "00"       AND
                                cb-auxi.codaux  =  SELF:SCREEN-VALUE
                                NO-LOCK NO-ERROR.                                
      IF NOT AVAIL cb-auxi THEN DO:
         MESSAGE "Divisi¢n no registrada" VIEW-AS ALERT-BOX ERROR.
         RETURN NO-APPLY.
      END.                          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-importe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-importe DIALOG-1
ON MOUSE-SELECT-DBLCLICK OF x-importe IN FRAME DIALOG-1 /* Importe */
OR "F8":U OF X-IMPORTE DO:
   DEF VAR P-RESULT AS DECIMAL.
   RUN CJA/D-CONVER.W( CB-DMOV.TPOCMB , CB-DMOV.CODMON , OUTPUT P-RESULT).
   IF P-RESULT <> ? THEN 
      DISPLAY P-RESULT @ X-IMPORTE WITH FRAME {&FRAME-NAME}.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NroDoc DIALOG-1
ON LEAVE OF x-NroDoc IN FRAME DIALOG-1
DO:
    IF x-div:SCREEN-VALUE = "" THEN DO:
       MESSAGE "C¢digo de Divisi¢n no valido"
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DIALOG-1 


/* ***************************  Main Block  *************************** */

IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

ON GO OF FRAME {&FRAME-NAME} APPLY "CHOOSE":U TO B-aceptar.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON STOP    UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    FIND integral.cb-dmov WHERE RECID( integral.cb-dmov ) = RegAct NO-ERROR.

    IF NOT AVAIL integral.cb-dmov THEN DO:
        MESSAGE "Registro de detalle inv lido" VIEW-AS ALERT-BOX ERROR.
        UNDO, LEAVE MAIN-BLOCK.
    END.
    x-div = cb-dmov.coddiv.
    IF cb-dmov.tpoitm = "P" THEN
        ASSIGN x-coddoc = cb-dmov.coddoc
               x-nrodoc = cb-dmov.nrodoc
               x-codaux = cb-dmov.codaux.

    RUN enable_UI.

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
    WAIT-FOR CHOOSE OF B-aceptar.
    RUN disable_UI.
    RETURN.
END.
RUN disable_UI.
RETURN ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cfg-CodAux DIALOG-1 
PROCEDURE Cfg-CodAux :
CASE cb-dmov.clfaux :
        WHEN "@PV" THEN DO:
            FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND
                                   gn-prov.CodPro = cb-dmov.CodAux:SCREEN-VALUE IN FRAME DIALOG-1
                                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-prov
            THEN RETURN ERROR.
            DISPLAY gn-prov.NomPro @ campo-aux WITH FRAME DIALOG-1.
            integral.cb-dmov.nroruc = gn-prov.ruc.
        END.
        WHEN "@CL" THEN DO:
            FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
                gn-clie.CodCli = cb-dmov.CodAux:SCREEN-VALUE  IN FRAME DIALOG-1
                                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-clie
            THEN RETURN ERROR.
            DISPLAY  gn-clie.NomCli @ campo-aux WITH FRAME DIALOG-1.
            integral.cb-dmov.nroruc = gn-clie.ruc.
        END.
        WHEN "@CT"  THEN DO:
                IF LENGTH(cb-dmov.Codaux:SCREEN-VALUE IN FRAME DIALOG-1) <>
                    INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles))
                THEN RETURN ERROR.
                find B-CTAS WHERE B-CTAS.CodCia = cb-codcia AND
                     B-CTAS.CodCta =
                         cb-dmov.CodAux:SCREEN-VALUE IN FRAME DIALOG-1
                               NO-LOCK NO-ERROR.
                IF NOT AVAILABLE B-CTAS
                THEN RETURN ERROR.
                DISPLAY B-CTAS.NomCta @ campo-aux  WITH FRAME DIALOG-1.
        
        END.
        OTHERWISE DO:
            FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia AND
                                cb-auxi.ClfAux = cb-dmov.ClfAux AND
                                cb-auxi.CodAux = cb-dmov.CodAux:SCREEN-VALUE IN FRAME DIALOG-1
                               NO-LOCK NO-ERROR.
            IF NOT AVAILABLE cb-auxi
            THEN RETURN ERROR.
            DISPLAY cb-auxi.NomAux @ campo-aux  WITH FRAME DIALOG-1.
        END.
    END CASE.
    x-girado = campo-aux:SCREEN-VALUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cfg-CodCta DIALOG-1 
PROCEDURE Cfg-CodCta :
DISPLAY cb-ctas.NomCta @ x-NomCta WITH FRAME DIALOG-1.
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
    IF cb-dmov.codmon = 1
    THEN
        x-Importe = integral.cb-dmov.ImpMn1.
    ELSE
        x-Importe = integral.cb-dmov.ImpMn2.
    DISPLAY x-Importe WITH FRAME DIALOG-1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chk_provision DIALOG-1 
PROCEDURE chk_provision :
/* -----------------------------------------------------------
  Purpose:  Verificar si el documento es correcto y 
            definir la configuracion de auxiliar a usar.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    FOR EACH integral.cp-tpro WHERE integral.cp-tpro.codcia = cb-codcia AND
        integral.cp-tpro.coddoc = x-coddoc:SCREEN-VALUE IN FRAME DIALOG-1:
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DIALOG-1 _DEFAULT-DISABLE
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
  HIDE FRAME DIALOG-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DIALOG-1 _DEFAULT-ENABLE
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
  DISPLAY x-div X-coddoc x-codaux x-importe x-NroDoc x-NomCta campo-aux 
      WITH FRAME DIALOG-1.
  IF AVAILABLE cb-dmov THEN 
    DISPLAY cb-dmov.Codcta cb-dmov.CodDiv cb-dmov.Codaux cb-dmov.C-Fcaja 
          cb-dmov.cco cb-dmov.Coddoc cb-dmov.Nroref cb-dmov.Glodoc 
          cb-dmov.Nrodoc 
      WITH FRAME DIALOG-1.
  ENABLE RECT-6 RECT-4 RECT-5 x-div X-coddoc x-codaux cb-dmov.Codcta 
         cb-dmov.CodDiv cb-dmov.Codaux cb-dmov.C-Fcaja cb-dmov.cco 
         cb-dmov.Coddoc cb-dmov.Nroref cb-dmov.Glodoc x-importe b-aceptar 
         x-NroDoc cb-dmov.Nrodoc b-cancelar 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE provision DIALOG-1 
PROCEDURE provision :
/* -----------------------------------------------------------
  Purpose:  Buscar y Jalar los datos de la provision
            para el registro automatico    
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    /* Calculando los saldos */
    DEF VAR X-MonCta AS INTEGER.
    X-MonCta = 0 .
    ASSIGN FRAME DIALOG-1
           x-coddoc
           x-nrodoc
           x-codaux
           x-SdoMn1 = 0
           x-SdoMn2 = 0
           RECID-ok = ?
           x-nroast = ?
           x-nromes = ?
           x-codope = ?.
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
        FOR EACH DETALLE WHERE detalle.codcia  = s-codcia AND
                               detalle.periodo = s-periodo    AND
                               detalle.codcta  = x-codcta AND
                               detalle.codaux  = x-codaux AND
                               detalle.coddoc  = x-coddoc AND
                               detalle.nrodoc  = x-nrodoc AND
                               detalle.coddiv  = input x-div    
                               NO-LOCK: 
            /*
            IF RECID-ok = ? 
            
            THEN ASSIGN RECID-ok = RECID( detalle )
                        x-nroast = detalle.nroast
                        x-nromes = detalle.nromes
                        x-codope = detalle.codope.
             */           

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
        END.

        IF RECID-ok <> ? THEN  LEAVE.        

        FIND NEXT integral.cp-tpro WHERE integral.cp-tpro.codcia = cb-codcia 
                                      AND integral.cp-tpro.coddoc = x-coddoc   
                                       NO-LOCK.
    END.
    IF RECID-ok = ?
    THEN DO:
        MESSAGE "Provisi¢n no registrada" VIEW-AS ALERT-BOX ERROR.        
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
        MESSAGE "Voucher de provisi¢n mal registrado" VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    
    FIND detalle WHERE RECID-ok = RECID( detalle ) NO-LOCK NO-ERROR.

    ASSIGN
        cb-dmov.tpoitm = "P"
        cb-dmov.relacion = RECID ( cb-cmov )
        x-notast = cb-cmov.notast
        cb-dmov.codcta:SCREEN-VALUE IN FRAME DIALOG-1 = detalle.codcta
        cb-dmov.coddiv:SCREEN-VALUE IN FRAME DIALOG-1 = detalle.coddiv
        cb-dmov.clfaux              = detalle.clfaux
        cb-dmov.codaux:SCREEN-VALUE IN FRAME DIALOG-1 = detalle.codaux
        cb-dmov.nroruc              = detalle.nroruc
        cb-dmov.coddoc:SCREEN-VALUE IN FRAME DIALOG-1 = detalle.coddoc
        cb-dmov.cco:SCREEN-VALUE IN FRAME DIALOG-1    = detalle.cco
        cb-dmov.nrodoc:SCREEN-VALUE IN FRAME DIALOG-1 = detalle.nrodoc
        cb-dmov.nroref:SCREEN-VALUE IN FRAME DIALOG-1 = detalle.nroref
        cb-dmov.tpomov              = NOT detalle.tpomov
        cb-dmov.glodoc:SCREEN-VALUE IN FRAME DIALOG-1 = cb-cmov.notast
        cb-dmov.impmn1              = ABS( x-SdoMn1)
        cb-dmov.impmn2              = ABS( x-SdoMn2)
        cb-dmov.tm                  = 0.
       
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




        
    DISPLAY x-Importe WITH FRAME DIALOG-1.
    FIND integral.cb-ctas WHERE integral.cb-ctas.codcia = cb-codcia AND
        integral.cb-ctas.codcta = integral.cb-dmov.codcta:SCREEN-VALUE
        NO-LOCK.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


