&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
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

  Created: 07/14/95 -  7:08 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

&IF "{&NEW}" = "" &THEN
    DEFINE INPUT PARAMETER x-CodCta AS CHARACTER.
    DEFINE INPUT PARAMETER s-NroMes    AS INTEGER.
    DEFINE INPUT PARAMETER y-codcia AS INTEGER.
    DEFINE INPUT PARAMETER x-NivMax AS INTEGER.
    DEFINE INPUT PARAMETER x-CodDiv AS CHAR INITIAL "00000".
&ELSE
    DEFINE VARIABLE x-CodCta AS CHARACTER INITIAL "10422".
    DEFINE VARIABLE s-NroMes    AS INTEGER INITIAL 2.
    DEFINE VARIABLE y-codcia AS INTEGER INITIAL 0.
    DEFINE VARIABLE x-NivMax AS INTEGER INITIAL 5.
    DEFINE VARIABLE x-CodDiv AS CHAR INITIAL "00000".
&ENDIF

/* Local Variable Definitions ---                                       */
DEFINE {&NEW} SHARED VARIABLE s-codcia  AS INTEGER INITIAL 1.
DEFINE {&NEW} SHARED VARIABLE s-periodo     AS INTEGER INITIAL 1995.
DEFINE {&NEW} SHARED VARIABLE s-user-id  AS CHARACTER INITIAL "JORGE".

DEFINE VARIABLE x-CodMon    AS CHARACTER INITIAL "S/.".
DEFINE VARIABLE x-NomMes    AS CHARACTER.
DEFINE VARIABLE lista-ope   AS CHARACTER.
DEFINE VARIABLE lista-aux   AS CHARACTER.
DEFINE VARIABLE x-glodoc    AS CHARACTER.
DEFINE VARIABLE x-CodAux    AS CHARACTER.
DEFINE VARIABLE x-CodOpe    AS CHARACTER.
DEFINE VARIABLE RECID-stack AS RECID.
DEFINE VARIABLE RegAct      AS RECID.
DEFINE VARIABLE x-Suma1     AS DECIMAL INITIAL 0.
DEFINE VARIABLE x-Suma2     AS DECIMAL INITIAL 0.
DEFINE VARIABLE x-saldoIS   AS DECIMAL.
DEFINE VARIABLE x-saldoCS   AS DECIMAL.
DEFINE VARIABLE x-saldoAS   AS DECIMAL.
DEFINE VARIABLE x-saldoSS   AS DECIMAL.
DEFINE VARIABLE x-saldoID   AS DECIMAL.
DEFINE VARIABLE x-saldoCD   AS DECIMAL.
DEFINE VARIABLE x-saldoAD   AS DECIMAL.
DEFINE VARIABLE x-saldoSD   AS DECIMAL.
DEFINE VARIABLE i           AS INTEGER.
DEFINE VARIABLE cl-codcia  AS INTEGER INITIAL 0.
DEFINE VARIABLE pv-codcia  AS INTEGER INITIAL 0.
DEFINE VARIABLE pto         AS LOGICAL.
DEFINE VARIABLE pto1        AS LOGICAL.

FIND Empresas WHERE Empresas.CodCia = s-codcia.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

pto = SESSION:SET-WAIT-STATE("").

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-dmov cb-ctas cb-oper

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 cb-dmov.Codope cb-dmov.Nroast ~
cb-dmov.Nrodoc cb-dmov.Codaux (x-glodoc) cb-dmov.Codmon cb-dmov.TpoMov ~
cb-dmov.ImpMn1 cb-dmov.ImpMn2 cb-dmov.Tpocmb cb-dmov.Nroref cb-dmov.Coddoc ~
cb-dmov.Fchdoc cb-dmov.Fchvto cb-dmov.Nroruc cb-dmov.Clfaux cb-dmov.CodDiv 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-2
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH cb-dmov ~
      WHERE cb-dmov.CodCia = s-codcia ~
 AND cb-dmov.Codcta = x-CodCta ~
 AND cb-dmov.Codope BEGINS x-CodOpe ~
 AND cb-dmov.Codaux BEGINS x-CodAux ~
 AND cb-dmov.Periodo = s-periodo ~
 AND cb-dmov.NroMes = s-NroMes NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 cb-dmov
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 cb-dmov


/* Definitions for DIALOG-BOX DIALOG-1                                  */
&Scoped-define FIELDS-IN-QUERY-DIALOG-1 cb-ctas.Codcta cb-ctas.Nomcta 
&Scoped-define OPEN-BROWSERS-IN-QUERY-DIALOG-1 ~
    ~{&OPEN-QUERY-BROWSE-2}
&Scoped-define OPEN-QUERY-DIALOG-1 OPEN QUERY DIALOG-1 FOR EACH cb-ctas ~
      WHERE cb-ctas.CodCia = Y-Codcia ~
 AND cb-ctas.Codcta = x-Codcta SHARE-LOCK, ~
      EACH cb-oper WHERE TRUE /* Join to cb-ctas incomplete */ SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-DIALOG-1 cb-ctas cb-oper
&Scoped-define FIRST-TABLE-IN-QUERY-DIALOG-1 cb-ctas


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 BROWSE-2 RECT-5 B-continuar F-Cdoper ~
F-Cdaux B-operacion B-salir B-aux Combo-mon 
&Scoped-Define DISPLAYED-FIELDS cb-ctas.Codcta cb-ctas.Nomcta 
&Scoped-Define DISPLAYED-OBJECTS F-Cdoper F-Desoper F-Cdaux F-Desaux x-suma ~
x-saldoi x-cargo x-abono x-saldoa Combo-mon 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-aux 
     IMAGE-UP FILE "adeicon/y-combo":U
     LABEL "" 
     SIZE 3.57 BY .69.

DEFINE BUTTON B-continuar 
     LABEL "&Continuar" 
     SIZE 13 BY 1.

DEFINE BUTTON B-operacion 
     IMAGE-UP FILE "adeicon/y-combo":U
     LABEL "" 
     SIZE 3.57 BY .69.

DEFINE BUTTON B-salir AUTO-END-KEY 
     LABEL "&Atrás" 
     SIZE 13 BY 1.

DEFINE VARIABLE Combo-mon AS CHARACTER FORMAT "X(256)":U INITIAL "S/." 
     LABEL "Moneda" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "S/.","US$" 
     SIZE 7 BY .92 NO-UNDO.

DEFINE VARIABLE F-Cdaux AS CHARACTER FORMAT "X(8)":U 
     LABEL "Auxiliar" 
     VIEW-AS FILL-IN 
     SIZE 12.72 BY .69 NO-UNDO.

DEFINE VARIABLE F-Cdoper AS CHARACTER FORMAT "X(3)":U 
     LABEL "Operacion" 
     VIEW-AS FILL-IN 
     SIZE 8.72 BY .69 NO-UNDO.

DEFINE VARIABLE F-Desaux AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .69
     FONT 0 NO-UNDO.

DEFINE VARIABLE F-Desoper AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .69
     FONT 0 NO-UNDO.

DEFINE VARIABLE x-abono AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "Abono" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-cargo AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "Cargo" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-saldoa AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "S. actual" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-saldoi AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "S. inicial" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-suma AS DECIMAL FORMAT "(ZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "Suma" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88
     FONT 0 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 86.29 BY 13.23
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 86.14 BY 2.27
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      cb-dmov SCROLLING.

DEFINE QUERY DIALOG-1 FOR 
      cb-ctas, 
      cb-oper SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 DIALOG-1 _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      cb-dmov.Codope COLUMN-LABEL "Opera-!ci¢n"
      cb-dmov.Nroast COLUMN-LABEL "Compro-!bante"
      cb-dmov.Nrodoc COLUMN-LABEL "N£mero de!Documento"
      cb-dmov.Codaux
      (x-glodoc) COLUMN-LABEL "D e t a l l e" FORMAT "x(30)"
      cb-dmov.Codmon
      cb-dmov.TpoMov
      cb-dmov.ImpMn1 COLUMN-LABEL "Importe!(Soles)"
      cb-dmov.ImpMn2 COLUMN-LABEL "Importe!(D¢lares)"
      cb-dmov.Tpocmb
      cb-dmov.Nroref
      cb-dmov.Coddoc COLUMN-LABEL "C¢digo!Docum."
      cb-dmov.Fchdoc COLUMN-LABEL "Fecha!Docum."
      cb-dmov.Fchvto COLUMN-LABEL "Fecha!Vcto."
      cb-dmov.Nroruc COLUMN-LABEL "N£mero de!RUC"
      cb-dmov.Clfaux COLUMN-LABEL "Clasif!Auxil."
      cb-dmov.CodDiv COLUMN-LABEL "Divisio-!naria"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS MULTIPLE SIZE 84 BY 8.35
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     cb-ctas.Codcta AT ROW 1.5 COL 1 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.72 BY .69
          BGCOLOR 8 FONT 0
     BROWSE-2 AT ROW 2.5 COL 2.14
     B-continuar AT ROW 14.77 COL 5
     F-Cdoper AT ROW 11 COL 11 COLON-ALIGNED
     F-Desoper AT ROW 11.73 COL 11 COLON-ALIGNED NO-LABEL
     F-Cdaux AT ROW 12.5 COL 11 COLON-ALIGNED
     F-Desaux AT ROW 13.27 COL 11 COLON-ALIGNED NO-LABEL
     cb-ctas.Nomcta AT ROW 1.5 COL 14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 51 BY .69
          BGCOLOR 8 FONT 0
     B-operacion AT ROW 10.96 COL 22
     B-salir AT ROW 14.77 COL 22
     B-aux AT ROW 12.54 COL 26.43
     x-suma AT ROW 14.81 COL 54.57 COLON-ALIGNED
     x-saldoi AT ROW 11 COL 64 COLON-ALIGNED
     x-cargo AT ROW 11.73 COL 64 COLON-ALIGNED
     x-abono AT ROW 12.5 COL 64 COLON-ALIGNED
     x-saldoa AT ROW 13.27 COL 64 COLON-ALIGNED
     Combo-mon AT ROW 1.5 COL 76 COLON-ALIGNED
     RECT-3 AT ROW 1 COL 1
     RECT-5 AT ROW 14.27 COL 1
     SPACE(0.14) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Consulta".


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
                                                                        */
/* BROWSE-TAB BROWSE-2 Codcta DIALOG-1 */
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

ASSIGN 
       B-operacion:AUTO-RESIZE IN FRAME DIALOG-1      = TRUE.

ASSIGN 
       BROWSE-2:NUM-LOCKED-COLUMNS IN FRAME DIALOG-1 = 2.

/* SETTINGS FOR FILL-IN cb-ctas.Codcta IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Desaux IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Desoper IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-ctas.Nomcta IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-abono IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-cargo IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-saldoa IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-saldoi IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-suma IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "integral.cb-dmov"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "cb-dmov.CodCia = s-codcia
 AND cb-dmov.Codcta = x-CodCta
 AND cb-dmov.Codope BEGINS x-CodOpe
 AND cb-dmov.Codaux BEGINS x-CodAux
 AND cb-dmov.Periodo = s-periodo
 AND cb-dmov.NroMes = s-NroMes"
     _FldNameList[1]   > integral.cb-dmov.Codope
"cb-dmov.Codope" "Opera-!ci¢n" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   > integral.cb-dmov.Nroast
"cb-dmov.Nroast" "Compro-!bante" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > integral.cb-dmov.Nrodoc
"cb-dmov.Nrodoc" "N£mero de!Documento" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   = integral.cb-dmov.Codaux
     _FldNameList[5]   > "_<CALC>"
"(x-glodoc)" "D e t a l l e" "x(30)" ? ? ? ? ? ? ? no ?
     _FldNameList[6]   = integral.cb-dmov.Codmon
     _FldNameList[7]   = integral.cb-dmov.TpoMov
     _FldNameList[8]   > integral.cb-dmov.ImpMn1
"cb-dmov.ImpMn1" "Importe!(Soles)" ? "decimal" ? ? ? ? ? ? no ?
     _FldNameList[9]   > integral.cb-dmov.ImpMn2
"cb-dmov.ImpMn2" "Importe!(D¢lares)" ? "decimal" ? ? ? ? ? ? no ?
     _FldNameList[10]   = integral.cb-dmov.Tpocmb
     _FldNameList[11]   = integral.cb-dmov.Nroref
     _FldNameList[12]   > integral.cb-dmov.Coddoc
"cb-dmov.Coddoc" "C¢digo!Docum." ? "character" ? ? ? ? ? ? no ?
     _FldNameList[13]   > integral.cb-dmov.Fchdoc
"cb-dmov.Fchdoc" "Fecha!Docum." ? "date" ? ? ? ? ? ? no ?
     _FldNameList[14]   > integral.cb-dmov.Fchvto
"cb-dmov.Fchvto" "Fecha!Vcto." ? "date" ? ? ? ? ? ? no ?
     _FldNameList[15]   > integral.cb-dmov.Nroruc
"cb-dmov.Nroruc" "N£mero de!RUC" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[16]   > integral.cb-dmov.Clfaux
"cb-dmov.Clfaux" "Clasif!Auxil." ? "character" ? ? ? ? ? ? no ?
     _FldNameList[17]   > integral.cb-dmov.CodDiv
"cb-dmov.CodDiv" "Divisio-!naria" ? "character" ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX DIALOG-1
/* Query rebuild information for DIALOG-BOX DIALOG-1
     _TblList          = "integral.cb-ctas,integral.cb-oper WHERE integral.cb-ctas ..."
     _Options          = "SHARE-LOCK"
     _Where[1]         = "integral.cb-ctas.CodCia = Y-Codcia
 AND integral.cb-ctas.Codcta = x-Codcta"
     _Query            is OPENED
*/  /* DIALOG-BOX DIALOG-1 */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-aux
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-aux DIALOG-1
ON CHOOSE OF B-aux IN FRAME DIALOG-1
DO:
    CASE cb-ctas.ClfAux:
    WHEN "@CL" THEN DO:
        RUN adm/q-clie.w(y-CodCia, OUTPUT RECID-stack).
        IF RECID-stack <> 0 THEN DO:
            FIND gn-clie WHERE RECID(gn-clie) = RECID-stack NO-LOCK  NO-ERROR.
            IF AVAIL gn-clie THEN DO:
                DISPLAY gn-clie.NomCli @ F-Desaux
                        gn-clie.CodCli @ F-Cdaux WITH FRAME DIALOG-1.
                x-CodAux = gn-clie.CodCli.
                pto = SESSION:SET-WAIT-STATE("GENERAL").
                {&OPEN-QUERY-{&BROWSE-NAME}}
                APPLY "ENTRY" TO BROWSE-2.
                pto = SESSION:SET-WAIT-STATE("").
                RETURN NO-APPLY.
            END.
            ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
        END.
    END.
    WHEN "@PV" THEN DO:
        RUN adm/q-prov.w(y-CodCia, OUTPUT RECID-stack).
        IF RECID-stack <> 0 THEN DO:
            FIND gn-prov WHERE RECID(gn-prov) = RECID-stack NO-LOCK NO-ERROR.
            IF AVAILABLE gn-prov THEN DO:
                DISPLAY gn-prov.NomPro @ F-Desaux
                        gn-prov.Codpro @ F-Cdaux WITH FRAME DIALOG-1.
                x-CodAux = gn-prov.CodPro.
                pto = SESSION:SET-WAIT-STATE("GENERAL").
                {&OPEN-QUERY-{&BROWSE-NAME}}
                APPLY "ENTRY" TO BROWSE-2.
                pto = SESSION:SET-WAIT-STATE("").
                RETURN NO-APPLY.
            END.
            ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
        END.
    END. 
    WHEN "@CT" THEN DO:
        RUN cbd/q-ctas2.w(y-CodCia,"9", OUTPUT RECID-stack).
        IF RECID-stack <> 0 THEN DO:
            find cb-ctas WHERE RECID(cb-ctas) = RECID-stack NO-LOCK NO-ERROR.
            IF avail cb-ctas THEN DO:
                DISPLAY cb-ctas.NomCta @ F-Desaux
                        cb-ctas.Codcta @ F-Cdaux WITH FRAME DIALOG-1.
                x-CodAux = cb-ctas.CodCta.
                pto = SESSION:SET-WAIT-STATE("GENERAL").
                {&OPEN-QUERY-{&BROWSE-NAME}}
                APPLY "ENTRY" TO BROWSE-2.
                pto = SESSION:SET-WAIT-STATE("").
                RETURN NO-APPLY.
            END.
            ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
                BUTTONS OK.
        END.
    END.
    OTHERWISE DO:
        RUN cbd/q-auxi.w(y-CodCia, cb-ctas.ClfAux, OUTPUT RECID-stack).
        IF RECID-stack <> 0 THEN DO:
            FIND cb-auxi WHERE RECID(cb-auxi) = RECID-stack NO-LOCK NO-ERROR.
            IF AVAIL cb-auxi THEN DO:
                DISPLAY cb-auxi.NomAux @ F-Desaux
                        cb-auxi.Codaux @ F-Cdaux WITH FRAME DIALOG-1.
                x-CodAux = cb-auxi.CodAux.
                pto = SESSION:SET-WAIT-STATE("GENERAL").
                {&OPEN-QUERY-{&BROWSE-NAME}}
                APPLY "ENTRY" TO BROWSE-2.
                pto = SESSION:SET-WAIT-STATE("").
                RETURN NO-APPLY.
            END.
            ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
                BUTTONS OK.
        END.
    END.
    END CASE.
    APPLY "ENTRY" TO BROWSE-2.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-continuar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-continuar DIALOG-1
ON CHOOSE OF B-continuar IN FRAME DIALOG-1 /* Continuar */
DO:
    IF NOT AVAIL cb-dmov 
    THEN DO:
        MESSAGE "Registro no seleccionado" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    FIND cb-cmov WHERE cb-cmov.CodCia  = cb-dmov.CodCia AND
                       cb-cmov.Periodo = cb-dmov.Periodo AND
                       cb-cmov.NroMes  = cb-dmov.NroMes AND
                       cb-cmov.CodOpe  = cb-dmov.CodOpe AND
                       cb-cmov.NroAst  = cb-dmov.NroAst NO-LOCK NO-ERROR.
    IF NOT AVAIL cb-cmov THEN DO:
        MESSAGE "Cabecera de detalle no existe" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    RegAct = RECID(cb-cmov).
    RUN cbd/cbdcons3.w(RegAct, y-codcia).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-operacion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-operacion DIALOG-1
ON CHOOSE OF B-operacion IN FRAME DIALOG-1
DO:
    RUN cbd/q-oper.w(y-CodCia, OUTPUT RECID-stack).
    IF RECID-stack <> 0
    THEN DO:
        FIND cb-oper
             WHERE RECID(cb-oper) = RECID-stack NO-LOCK  NO-ERROR.
        IF AVAILABLE cb-oper
        THEN DO:
            DISPLAY cb-oper.CodOpe @ F-Cdoper
                    cb-oper.NomOpe @ F-Desoper WITH FRAME DIALOG-1.
            x-CodOpe = cb-oper.CodOpe.
            pto = SESSION:SET-WAIT-STATE("GENERAL").
            {&OPEN-QUERY-{&BROWSE-NAME}}
            APPLY "ENTRY" TO BROWSE-2.
            pto = SESSION:SET-WAIT-STATE("").
            RETURN NO-APPLY.
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
                 BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 DIALOG-1
ON MOUSE-SELECT-CLICK OF BROWSE-2 IN FRAME DIALOG-1
DO:
    ASSIGN x-Suma1 = 0
           x-Suma2 = 0.
    DO i = 1 TO BROWSE-2:NUM-SELECTED-ROWS:
        pto1 = BROWSE-2:FETCH-SELECTED-ROW(i).
        IF NOT cb-dmov.TpoMov AND cb-dmov.ImpMn1 <> ? AND cb-dmov.ImpMn2 <> ?
        THEN DO:
            x-Suma1 = x-Suma1 + cb-dmov.ImpMn1.
            x-Suma2 = x-Suma2 + cb-dmov.ImpMn2.
        END.
        ELSE DO:
            x-Suma1 = x-Suma1 - cb-dmov.ImpMn1.
            x-Suma2 = x-Suma2 - cb-dmov.ImpMn2.
        END.
    END.
    IF Combo-mon:SCREEN-VALUE IN FRAME DIALOG-1 = "S/."
    THEN DISPLAY x-Suma1 @ x-Suma WITH FRAME DIALOG-1.
    ELSE DISPLAY x-Suma2 @ x-Suma WITH FRAME DIALOG-1.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Combo-mon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Combo-mon DIALOG-1
ON VALUE-CHANGED OF Combo-mon IN FRAME DIALOG-1 /* Moneda */
DO:
    IF QUERY-OFF-END("BROWSE-2") THEN RETURN.
    IF Combo-mon:SCREEN-VALUE IN FRAME DIALOG-1 <> x-CodMon
    THEN DO:
        pto1 = BROWSE-2:MOVE-COLUMN(7, 8).
        x-CodMon = Combo-mon:SCREEN-VALUE IN FRAME DIALOG-1.
    END.
    IF Combo-mon:SCREEN-VALUE IN FRAME DIALOG-1 = "S/."
    THEN DO:
        DISPLAY x-Suma1 @ x-Suma
                x-saldoIS @ x-saldoi
                x-saldoCS @ x-cargo
                x-saldoAS @ x-abono
                x-saldoSS @ x-saldoa WITH FRAME DIALOG-1.
    END.
    ELSE DO:
        DISPLAY x-Suma2 @ x-Suma
                x-saldoID @ x-saldoi
                x-saldoCD @ x-cargo
                x-saldoAD @ x-abono
                x-saldoSD @ x-saldoa WITH FRAME DIALOG-1.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Cdaux
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Cdaux DIALOG-1
ON F8 OF F-Cdaux IN FRAME DIALOG-1 /* Auxiliar */
DO:
    APPLY "CHOOSE" TO B-aux.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Cdaux DIALOG-1
ON LEAVE OF F-Cdaux IN FRAME DIALOG-1 /* Auxiliar */
DO:

    IF F-cdaux:SCREEN-VALUE = ""
    THEN DO:
        x-Codaux = "".
        F-Desaux:SCREEN-VALUE = "".
        pto = SESSION:SET-WAIT-STATE("GENERAL").
        {&OPEN-QUERY-{&BROWSE-NAME}}
        APPLY "ENTRY" TO BROWSE-2.
        pto = SESSION:SET-WAIT-STATE("").
        RETURN NO-APPLY.
    END.

    CASE cb-ctas.ClfAux:
    WHEN "@CL" THEN DO:
        FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
            gn-clie.CodCli = F-cdaux:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAIL gn-clie THEN DO:
            MESSAGE "C¢digo de auxiliar no registrado" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-cdaux IN FRAME DIALOG-1.
            RETURN NO-APPLY.
        END.
        DISPLAY gn-clie.NomCli @ F-Desaux
                gn-clie.CodCli @ F-Cdaux WITH FRAME DIALOG-1.
        x-CodAux = gn-clie.CodCli.
        pto = SESSION:SET-WAIT-STATE("GENERAL").
        {&OPEN-QUERY-{&BROWSE-NAME}}
        APPLY "ENTRY" TO BROWSE-2.
        pto = SESSION:SET-WAIT-STATE("").
        RETURN NO-APPLY.
    END.
    WHEN "@PV" THEN DO:
        FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND
            gn-prov.CodPro = F-cdaux:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-prov THEN DO:
            MESSAGE "C¢digo de auxiliar no registrado" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-cdaux IN FRAME DIALOG-1.
            RETURN NO-APPLY.
        END.
        DISPLAY gn-prov.NomPro @ F-Desaux
                gn-prov.Codpro @ F-Cdaux WITH FRAME DIALOG-1.
        x-CodAux = gn-prov.CodPro.
        pto = SESSION:SET-WAIT-STATE("GENERAL").
        {&OPEN-QUERY-{&BROWSE-NAME}}
        APPLY "ENTRY" TO BROWSE-2.
        pto = SESSION:SET-WAIT-STATE("").
        RETURN NO-APPLY.
    END.
    WHEN "@CT" THEN DO:
        find cb-ctas WHERE cb-ctas.CodCia = Y-CodCia AND
            cb-ctas.CodCta = F-cdaux:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF NOT avail cb-ctas THEN DO:
            MESSAGE "C¢digo de auxiliar no registrado" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-cdaux IN FRAME DIALOG-1.
            RETURN NO-APPLY.
        END.
        DISPLAY cb-ctas.NomCta @ F-Desaux
                cb-ctas.Codcta @ F-Cdaux WITH FRAME DIALOG-1.
        x-CodAux = cb-ctas.CodCta.
        pto = SESSION:SET-WAIT-STATE("GENERAL").
        {&OPEN-QUERY-{&BROWSE-NAME}}
        APPLY "ENTRY" TO BROWSE-2.
        pto = SESSION:SET-WAIT-STATE("").
        RETURN NO-APPLY.
    END.
    OTHERWISE DO:
        FIND cb-auxi WHERE cb-auxi.CodCia = Y-CodCia AND
            cb-auxi.ClfAux = cb-ctas.ClfAux AND
            cb-auxi.CodAux = F-cdaux:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAIL cb-auxi THEN DO:
            MESSAGE "C¢digo de auxiliar no registrado" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-cdaux IN FRAME DIALOG-1.
            RETURN NO-APPLY.
        END.
        DISPLAY cb-auxi.NomAux @ F-Desaux
                cb-auxi.Codaux @ F-Cdaux WITH FRAME DIALOG-1.
        x-CodAux = cb-auxi.CodAux.
        pto = SESSION:SET-WAIT-STATE("GENERAL").
        {&OPEN-QUERY-{&BROWSE-NAME}}
        APPLY "ENTRY" TO BROWSE-2.
        pto = SESSION:SET-WAIT-STATE("").
        RETURN NO-APPLY.
    END.
    END CASE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Cdoper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Cdoper DIALOG-1
ON F8 OF F-Cdoper IN FRAME DIALOG-1 /* Operacion */
DO:
    APPLY "CHOOSE" TO B-operacion. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Cdoper DIALOG-1
ON LEAVE OF F-Cdoper IN FRAME DIALOG-1 /* Operacion */
DO:

    IF F-cdoper:SCREEN-VALUE = ""
    THEN DO:
        x-CodOpe = "".
        F-Desoper:SCREEN-VALUE = "".
        pto = SESSION:SET-WAIT-STATE("GENERAL").
        {&OPEN-QUERY-{&BROWSE-NAME}}
        APPLY "ENTRY" TO BROWSE-2.
        pto = SESSION:SET-WAIT-STATE("").
        RETURN NO-APPLY.
    END.

    FIND cb-oper WHERE integral.cb-oper.Codcia = y-codcia AND
        integral.cb-oper.Codope = F-Cdoper:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-oper THEN DO:
        MESSAGE "Operaci¢n no existente" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO F-cdoper IN FRAME DIALOG-1.
        RETURN NO-APPLY.
    END.
    DISPLAY cb-oper.Codope @ F-cdoper
            cb-oper.NomOpe @ F-Desoper WITH FRAME DIALOG-1.
    x-CodOpe = cb-oper.CodOpe.
    pto = SESSION:SET-WAIT-STATE("GENERAL").
    {&OPEN-QUERY-{&BROWSE-NAME}}
    APPLY "ENTRY" TO BROWSE-2.
    pto = SESSION:SET-WAIT-STATE("").
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Cdoper DIALOG-1
ON MOUSE-SELECT-DBLCLICK OF F-Cdoper IN FRAME DIALOG-1 /* Operacion */
DO:
APPLY "CHOOSE" TO B-operacion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Desaux
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Desaux DIALOG-1
ON F8 OF F-Desaux IN FRAME DIALOG-1
DO:
    APPLY "CHOOSE" TO B-aux.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Desaux DIALOG-1
ON LEAVE OF F-Desaux IN FRAME DIALOG-1
DO:
    IF F-Cdaux = "" THEN x-CodAux = "".
    {&OPEN-QUERY-{&BROWSE-NAME}}
    RUN suma.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Desaux DIALOG-1
ON MOUSE-SELECT-DBLCLICK OF F-Desaux IN FRAME DIALOG-1
DO:
    APPLY "CHOOSE" TO b-Aux.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DIALOG-1 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

RUN bin/_mes.p ( INPUT s-NroMes , 1,  OUTPUT x-NomMes ).  
x-NomMes = "Consulta " + x-NomMes + ", " + STRING( s-periodo , "9999" ).
FRAME {&FRAME-NAME}:TITLE = x-NomMes.

ON FIND OF integral.cb-dmov
DO:
    x-glodoc = integral.cb-dmov.glodoc.
    IF x-glodoc = "" THEN DO:
        FIND cb-cmov WHERE cb-cmov.CodCia  = cb-dmov.CodCia AND
                           cb-cmov.Periodo = cb-dmov.Periodo AND
                           cb-cmov.NroMes  = cb-dmov.NroMes AND
                           cb-cmov.CodOpe  = cb-dmov.CodOpe AND
                           cb-cmov.NroAst  = cb-dmov.NroAst NO-LOCK NO-ERROR.
        IF AVAIL cb-cmov THEN x-glodoc = cb-cmov.notast.
    END.
END.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN enable_UI.
    RUN calcula.
    WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcula DIALOG-1 
PROCEDURE calcula :
ASSIGN x-saldoIS = 0
       x-saldoCS = 0
       x-saldoAS = 0
       x-saldoSS = 0
       x-saldoID = 0
       x-saldoCD = 0
       x-saldoAD = 0
       x-saldoSD = 0.

/* IF NOT AVAILABLE cb-acmd THEN RETURN. */

FOR EACH cb-acmd WHERE cb-acmd.CodCia  = s-codcia AND
                       cb-acmd.Periodo = s-periodo AND
                       cb-acmd.CodCta  BEGINS cb-ctas.Codcta AND
                       cb-acmd.CodDiv  BEGINS x-CodDiv NO-LOCK :
                       
    DO i = 1 TO s-NroMes:
        x-saldoIS = x-saldoIS + ( DbeMn1[i] - HbeMn1[i] ).
        x-saldoID = x-saldoID + ( DbeMn2[i] - HbeMn2[i] ).
    END.
    x-saldoCS = x-saldoCS + DbeMn1[ s-NroMes + 1 ].
    x-saldoAS = x-saldoAS + HbeMn1[ s-NroMes + 1 ].
    x-saldoSS = x-saldoSS + ( x-saldoIS + ( x-saldoCS - x-saldoAS ) ).
    x-saldoCD = x-saldoCD + DbeMn2[ s-NroMes + 1 ].
    x-saldoAD = x-saldoAD + HbeMn2[ s-NroMes + 1 ].
    x-saldoSD = x-saldoID + ( x-saldoCD - x-saldoAD ).
END.    
APPLY "VALUE-CHANGED" TO combo-mon IN FRAME DIALOG-1.
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

  {&OPEN-QUERY-DIALOG-1}
  GET FIRST DIALOG-1.
  DISPLAY F-Cdoper F-Desoper F-Cdaux F-Desaux x-suma x-saldoi x-cargo x-abono 
          x-saldoa Combo-mon 
      WITH FRAME DIALOG-1.
  IF AVAILABLE cb-ctas THEN 
    DISPLAY cb-ctas.Codcta cb-ctas.Nomcta 
      WITH FRAME DIALOG-1.
  ENABLE RECT-3 BROWSE-2 RECT-5 B-continuar F-Cdoper F-Cdaux B-operacion 
         B-salir B-aux Combo-mon 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


