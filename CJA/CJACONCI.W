&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-maestro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-maestro 
/*------------------------------------------------------------------------

  File: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:  VALMIESA - DEPARTAMENTO DE TECNOLOGIA

  Created: 10/25/93 - 11:42 am

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/*~ MAESTRO V1.00 FOR MS-WINDOWS ~*/
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE {&NEW} SHARED VARIABLE  s-codcia AS INTEGER INITIAL 1.
DEFINE VARIABLE Y-codcia                AS INTEGER INITIAL 0.

FIND integral.empresas WHERE integral.empresas.codcia = s-codcia.
IF NOT integral.empresas.campo-codcbd THEN y-codcia = s-codcia.

FIND integral.cb-cfga WHERE cb-cfga.CodCia = Y-CodCia AND CodCfg = 1
    NO-LOCK NO-ERROR.        

IF NOT AVAIL integral.cb-cfga THEN DO:
    BELL.
    MESSAGE "NO SE HA CONFIGURADO EL SISTEMA CONTABLE"
        VIEW-AS ALERT-BOX.
    RETURN.
END.

IF integral.cb-cfga.ctacredito = "" THEN DO: 
    BELL.
    MESSAGE "NO SE HA CONFIGURADO LAS CUENTAS DE CREDITO" 
        VIEW-AS ALERT-BOX.
    RETURN.
END.

DEFINE {&NEW} SHARED VARIABLE cb-niveles AS CHARACTER INITIAL "2,3,5".
DEFINE {&NEW} SHARED VARIABLE s-periodo AS INTEGER INITIAL 1995.
DEFINE {&NEW} SHARED VARIABLE s-NroMes AS INTEGER INITIAL 2.
DEFINE VARIABLE RECID-stack AS RECID NO-UNDO.
DEFINE VARIABLE RECID-tmp   AS RECID NO-UNDO.
DEFINE VARIABLE x-nivel     AS CHARACTER.
DEFINE VARIABLE x-ctacre    AS CHARACTER INITIAL "".
DEFINE VARIABLE x-maxnivel  AS INTEGER.
DEFINE VARIABLE x-debe      AS DECIMAL.
DEFINE VARIABLE x-haber     AS DECIMAL.
DEFINE VARIABLE pto         AS LOGICAL.
DEFINE STREAM report.

x-maxnivel = INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles)).
pto        = SESSION:SET-WAIT-STATE("").
   
/*   C A M B I O S   E N    L O S   P R E - P R O C E S A D O R E S */

/* Solo muestra los registros que cumplan con la condici¢n : */
&Scoped-define RECORD-SCOPE integral.cb-ctas.CodCia = Y-CodCia AND ~
    integral.cb-ctas.Codcta BEGINS integral.cb-cfga.ctacredito AND ~
    LENGTH ( integral.cb-ctas.Codcta ) = x-maxnivel

/* Como Buscar un Registro en la Tabla ( Para Crear, modificar, anular etc.) */
&Scoped-define SEARCH-KEY integral.cb-ctas.Codcta = integral.cb-ctas.Codcta:SCREEN-VALUE IN FRAME F-maestro

/*
/* Campos Ocultos que deben ser asignados en cada modificaci¢n */
&Scoped-define ASSIGN-ADD integral.cb-ctas.CodCia = Y-CodCia

/* Campos que no pueden ser modificados */
&Scoped-define NO-MODIFY integral.cb-ctas.Codcta integral.cb-ctas.activo integral.cb-ctas.nomcta
*/

/* Programa donde relaizara la Consulta */
&Scoped-define q-modelo cbd/q-ctas3.w ( Y-CodCia, "10", OUTPUT RECID-stack )

/* Campos por los cuales se puede hacer Busquedas */
&Scoped-define Query-Field integral.cb-ctas.Codcta integral.cb-ctas.nomcta

DEFINE BUTTON B-aceptar AUTO-GO 
     LABEL "&Aceptar" 
     SIZE 10 BY 1.

DEFINE BUTTON B-cancelar AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE R-ctacredito
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 44 BY 6.5
     BGCOLOR 8 .

DEFINE RECTANGLE R-ctacredito2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 44 BY 2
     BGCOLOR 8 .

DEFINE FRAME F-ctacredito
     integral.Cbdbanco.Fchref AT ROW 1.5 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY 1
     integral.Cbdbanco.Nroref AT ROW 3 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY 1
     integral.Cbdbanco.TpoMov AT ROW 4.5 COL 22 COLON-ALIGNED HELP
          "Tipo de Movimiento Haber / Debe"
          LABEL "Tipo de Movimiento"
          VIEW-AS FILL-IN 
          SIZE 3.43 BY 1
     integral.Cbdbanco.Importe AT ROW 6 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY 1
     B-aceptar AT ROW 8 COL 8
     B-cancelar AT ROW 8 COL 28
     R-ctacredito AT ROW 1 COL 1
     R-ctacredito2 AT ROW 7.5 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         TITLE "Movimiento de cuenta" ROW 5 CENTERED.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-ctrl-frame
&Scoped-define BROWSE-NAME BRW-credito

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Cbdbanco cb-ctas

/* Definitions for BROWSE BRW-credito                                   */
&Scoped-define FIELDS-IN-QUERY-BRW-credito Cbdbanco.Fchref Cbdbanco.Nroref ~
Cbdbanco.TpoMov ~
(IF (NOT integral.Cbdbanco.TpoMov) THEN (integral.Cbdbanco.Importe) ELSE (0)) ~
(IF (integral.Cbdbanco.TpoMov) THEN (integral.Cbdbanco.Importe) ELSE (0)) 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BRW-credito 
&Scoped-define FIELD-PAIRS-IN-QUERY-BRW-credito
&Scoped-define OPEN-QUERY-BRW-credito OPEN QUERY BRW-credito FOR EACH Cbdbanco WHERE TRUE /* Join to cb-ctas incomplete */ ~
      AND Cbdbanco.Codcia = s-codcia ~
 AND Cbdbanco.Periodo = s-periodo ~
 AND Cbdbanco.Nromes = s-NroMes ~
 AND Cbdbanco.Codcta = cb-ctas.codcta:SCREEN-VALUE IN FRAME F-maestro ~
 AND Cbdbanco.flgest = "B" NO-LOCK ~
    BY Cbdbanco.Fchref ~
       BY Cbdbanco.Nroref.
&Scoped-define TABLES-IN-QUERY-BRW-credito Cbdbanco
&Scoped-define FIRST-TABLE-IN-QUERY-BRW-credito Cbdbanco


/* Definitions for FRAME F-maestro                                      */
&Scoped-define FIELDS-IN-QUERY-F-maestro cb-ctas.Codcta cb-ctas.Nomcta ~
cb-ctas.Codmon 
&Scoped-define ENABLED-FIELDS-IN-QUERY-F-maestro cb-ctas.Codcta ~
cb-ctas.Nomcta cb-ctas.Codmon 
&Scoped-define ENABLED-TABLES-IN-QUERY-F-maestro cb-ctas
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-F-maestro cb-ctas

&Scoped-define FIELD-PAIRS-IN-QUERY-F-maestro~
 ~{&FP1}Codcta ~{&FP2}Codcta ~{&FP3}~
 ~{&FP1}Nomcta ~{&FP2}Nomcta ~{&FP3}
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-maestro ~
    ~{&OPEN-QUERY-BRW-credito}
&Scoped-define OPEN-QUERY-F-maestro OPEN QUERY F-maestro FOR EACH cb-ctas SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-F-maestro cb-ctas
&Scoped-define FIRST-TABLE-IN-QUERY-F-maestro cb-ctas


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS R-consulta R-exit R-query R-navigaate ~
R-modify B-query B-add B-update B-delete B-first B-prev B-next B-last ~
B-browse B-exit 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-maestro AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-add 
     LABEL "&Crear":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE BUTTON B-browse 
     IMAGE-UP FILE "IMG/pvbrow":U
     IMAGE-DOWN FILE "IMG/pvbrowd":U
     IMAGE-INSENSITIVE FILE "IMG/pvbrowx":U
     LABEL "&Consulta" 
     SIZE 5.72 BY 1.5.

DEFINE BUTTON B-delete 
     LABEL "&Eliminar":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE BUTTON B-exit 
     LABEL "&Salir":L 
     SIZE 7 BY 1
     FONT 4.

DEFINE BUTTON B-first 
     IMAGE-UP FILE "IMG/pvfirst":U
     IMAGE-DOWN FILE "IMG/pvfirstd":U
     IMAGE-INSENSITIVE FILE "IMG/pvfirstx":U
     LABEL "<<":L 
     SIZE 5 BY 1
     FONT 4.

DEFINE BUTTON B-last 
     IMAGE-UP FILE "IMG/pvlast":U
     IMAGE-DOWN FILE "IMG/pvlastd":U
     IMAGE-INSENSITIVE FILE "IMG/pvlastx":U
     LABEL ">>":L 
     SIZE 4.57 BY 1
     FONT 4.

DEFINE BUTTON B-next 
     IMAGE-UP FILE "IMG/pvforw":U
     IMAGE-DOWN FILE "IMG/pvforwd":U
     IMAGE-INSENSITIVE FILE "IMG/pvforwx":U
     LABEL ">":L 
     SIZE 5 BY 1
     FONT 4.

DEFINE BUTTON B-prev 
     IMAGE-UP FILE "IMG/pvback":U
     IMAGE-DOWN FILE "IMG/pvbackd":U
     IMAGE-INSENSITIVE FILE "IMG/pvbackx":U
     LABEL "<":L 
     SIZE 5 BY 1
     FONT 4.

DEFINE BUTTON B-query 
     LABEL "&Buscar":L 
     SIZE 7.57 BY 1
     FONT 4.

DEFINE BUTTON B-update 
     LABEL "&Modificar":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE RECTANGLE R-consulta
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 10 BY 2
     BGCOLOR 8 .

DEFINE RECTANGLE R-exit
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 11.57 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-modify
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 33 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-navigaate
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 26 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-query
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 10 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE BUTTON B-Imprimir 
     LABEL "Imprimir" 
     SIZE 8 BY 1.

DEFINE BUTTON B-saldoi 
     LABEL "Modif. Saldo &Inicial" 
     SIZE 17 BY .85.

DEFINE VARIABLE x-saldoi AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "Sld.Inicial" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-totabono AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-total AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "Saldo Final" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-totcargo AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE R-maestro1
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 90.86 BY 3.5
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-maestro2
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 90.86 BY 10.12
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-saldoi
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 24 BY 4.

DEFINE BUTTON B-Cancel-3 
     LABEL "&Cancelar":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE BUTTON B-ok-3 AUTO-GO 
     LABEL "&Aceptar":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE RECTANGLE R-navigaate-4
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 90.57 BY 2
     BGCOLOR 8 FGCOLOR 15 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BRW-credito FOR 
      Cbdbanco SCROLLING.

DEFINE QUERY F-maestro FOR 
      cb-ctas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BRW-credito
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BRW-credito W-maestro _STRUCTURED
  QUERY BRW-credito NO-LOCK DISPLAY
      Cbdbanco.Fchref COLUMN-LABEL "Fecha!Referencia"
      Cbdbanco.Nroref FORMAT "X(12)"
      Cbdbanco.TpoMov
      (IF (NOT integral.Cbdbanco.TpoMov) THEN (integral.Cbdbanco.Importe) ELSE (0)) COLUMN-LABEL "Cargo" FORMAT "ZZ,ZZZ,ZZZ,ZZ9.99"
      (IF (integral.Cbdbanco.TpoMov) THEN (integral.Cbdbanco.Importe) ELSE (0)) COLUMN-LABEL "Abono" FORMAT "ZZ,ZZZ,ZZZ,ZZ9.99"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 56 BY 7.5
         BGCOLOR 15 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-maestro
     BRW-credito AT ROW 5 COL 7
     cb-ctas.Codcta AT ROW 1.5 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 15 
     cb-ctas.Nomcta AT ROW 3 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 52 BY .81
          BGCOLOR 15 
     x-totcargo AT ROW 13 COL 28 COLON-ALIGNED NO-LABEL
     x-totabono AT ROW 13 COL 44 COLON-ALIGNED NO-LABEL
     cb-ctas.Codmon AT ROW 1.38 COL 66 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Soles", 1,
"D¢lares", 2
          SIZE 10 BY 1.5
     B-saldoi AT ROW 9.5 COL 70
     x-total AT ROW 13.5 COL 73 COLON-ALIGNED
     x-saldoi AT ROW 8 COL 74 COLON-ALIGNED
     B-Imprimir AT ROW 1.5 COL 81
     R-maestro2 AT ROW 4.5 COL 1
     "Totales -->" VIEW-AS TEXT
          SIZE 12 BY 1 AT ROW 13 COL 13
          FONT 1
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 1.5 COL 58
     R-saldoi AT ROW 7 COL 66
     R-maestro1 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 90.86 BY 13.62
         BGCOLOR 8 FGCOLOR 0 FONT 4.

DEFINE FRAME F-search
     B-ok-3 AT ROW 1.54 COL 24.29
     B-Cancel-3 AT ROW 1.54 COL 57.57
     R-navigaate-4 AT ROW 1 COL 1
    WITH 1 DOWN OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 14.61
         SIZE 90.86 BY 2.08
         BGCOLOR 8 FGCOLOR 0 .

DEFINE FRAME F-ctrl-frame
     B-query AT ROW 1.5 COL 2
     B-add AT ROW 1.5 COL 13
     B-update AT ROW 1.5 COL 23
     B-delete AT ROW 1.5 COL 33
     B-first AT ROW 1.5 COL 46
     B-prev AT ROW 1.5 COL 52
     B-next AT ROW 1.5 COL 58
     B-last AT ROW 1.5 COL 64
     B-browse AT ROW 1.27 COL 72
     B-exit AT ROW 1.5 COL 82
     R-consulta AT ROW 1 COL 70
     R-exit AT ROW 1 COL 80
     R-query AT ROW 1 COL 1
     R-navigaate AT ROW 1 COL 44
     R-modify AT ROW 1 COL 11
    WITH 1 DOWN OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 14.61
         SIZE 90.86 BY 2.08
         BGCOLOR 8 FGCOLOR 0 FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-maestro ASSIGN
         HIDDEN             = YES
         TITLE              = "Ingreso de Extracto Bancario"
         COLUMN             = 6.57
         ROW                = 10.15
         HEIGHT             = 15.69
         WIDTH              = 90.86
         MAX-HEIGHT         = 15.69
         MAX-WIDTH          = 90.86
         VIRTUAL-HEIGHT     = 15.69
         VIRTUAL-WIDTH      = 90.86
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = 8
         FGCOLOR            = 0
         THREE-D            = yes
         FONT               = 8
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

IF NOT W-maestro:LOAD-ICON("IMG/valmiesa":U) THEN
    MESSAGE "Unable to load icon: IMG/valmiesa"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR FRAME F-ctrl-frame
   UNDERLINE                                                            */
/* SETTINGS FOR BUTTON B-add IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-delete IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-exit IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-first IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-last IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-next IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-prev IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-query IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-update IN FRAME F-ctrl-frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR FRAME F-maestro
   UNDERLINE                                                            */
/* BROWSE-TAB BRW-credito R-maestro1 F-maestro */
/* SETTINGS FOR FILL-IN x-saldoi IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-totabono IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-total IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-totcargo IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME F-search
   NOT-VISIBLE UNDERLINE                                                */
ASSIGN 
       FRAME F-search:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON B-Cancel-3 IN FRAME F-search
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-ok-3 IN FRAME F-search
   NO-DISPLAY                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-maestro)
THEN W-maestro:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BRW-credito
/* Query rebuild information for BROWSE BRW-credito
     _TblList          = "integral.Cbdbanco WHERE integral.cb-ctas <external> ..."
     _Options          = "NO-LOCK"
     _OrdList          = "integral.Cbdbanco.Fchref|yes,integral.Cbdbanco.Nroref|yes"
     _Where[1]         = "integral.Cbdbanco.Codcia = s-codcia
 AND integral.Cbdbanco.Periodo = s-periodo
 AND integral.Cbdbanco.Nromes = s-NroMes
 AND integral.Cbdbanco.Codcta = integral.cb-ctas.codcta:SCREEN-VALUE IN FRAME F-maestro
 AND integral.Cbdbanco.flgest = ""B"""
     _FldNameList[1]   > integral.Cbdbanco.Fchref
"Cbdbanco.Fchref" "Fecha!Referencia" ? "date" ? ? ? ? ? ? no ?
     _FldNameList[2]   > integral.Cbdbanco.Nroref
"Cbdbanco.Nroref" ? "X(12)" "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   = integral.Cbdbanco.TpoMov
     _FldNameList[4]   > "_<CALC>"
"(IF (NOT integral.Cbdbanco.TpoMov) THEN (integral.Cbdbanco.Importe) ELSE (0))" "Cargo" "ZZ,ZZZ,ZZZ,ZZ9.99" ? ? ? ? ? ? ? no ?
     _FldNameList[5]   > "_<CALC>"
"(IF (integral.Cbdbanco.TpoMov) THEN (integral.Cbdbanco.Importe) ELSE (0))" "Abono" "ZZ,ZZZ,ZZZ,ZZ9.99" ? ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE BRW-credito */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-maestro
/* Query rebuild information for FRAME F-maestro
     _TblList          = "integral.cb-ctas"
     _Query            is OPENED
*/  /* FRAME F-maestro */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-add W-maestro
ON CHOOSE OF B-add IN FRAME F-ctrl-frame /* Crear */
DO:
    DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE:
        CREATE integral.cbdbanco.
        ASSIGN integral.cbdbanco.codcia  = s-codcia
               integral.cbdbanco.periodo = s-periodo
               integral.cbdbanco.nromes  = s-NroMes
               integral.cbdbanco.codcta  = integral.cb-ctas.codcta
               integral.Cbdbanco.Flgest  = "B"
               integral.Cbdbanco.Sdoini  = INPUT FRAME F-maestro x-saldoi.
        UPDATE integral.Cbdbanco.Fchref
               integral.Cbdbanco.Nroref
               integral.Cbdbanco.TpoMov
               integral.Cbdbanco.Importe
               b-aceptar b-cancelar WITH FRAME F-ctacredito.
        RUN pintado.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-browse W-maestro
ON CHOOSE OF B-browse IN FRAME F-ctrl-frame /* Consulta */
DO:
    RUN {&q-modelo} .
    IF RECID-stack <> 0
    THEN DO:
        FIND {&TABLES-IN-QUERY-F-maestro}
             WHERE RECID( {&TABLES-IN-QUERY-F-maestro} ) = RECID-stack
              NO-LOCK  NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
         ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
         BUTTONS OK.
     END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-search
&Scoped-define SELF-NAME B-Cancel-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Cancel-3 W-maestro
ON CHOOSE OF B-Cancel-3 IN FRAME F-search /* Cancelar */
DO:
     FIND PREV {&FIRST-TABLE-IN-QUERY-F-maestro} 
     &IF "{&RECORD-SCOPE}" <> "" &THEN
          WHERE {&RECORD-SCOPE}
      &ENDIF  
     NO-LOCK NO-ERROR.
     IF NOT AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN 
     FIND FIRST {&FIRST-TABLE-IN-QUERY-F-maestro}
     &IF "{&RECORD-SCOPE}" <> "" &THEN
          WHERE {&RECORD-SCOPE}
      &ENDIF  
      NO-LOCK NO-ERROR.
     IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN  RUN Pintado.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-ctrl-frame
&Scoped-define SELF-NAME B-delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-delete W-maestro
ON CHOOSE OF B-delete IN FRAME F-ctrl-frame /* Eliminar */
DO:
    RECID-tmp = 0.
    IF AVAIL integral.cbdbanco THEN RECID-tmp = RECID ( integral.cbdbanco ).
    DO TRANSACTION ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        FIND integral.cbdbanco WHERE RECID-Tmp = RECID( integral.cbdbanco )
            EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL integral.cbdbanco THEN DO:
            MESSAGE "Eliminar movimiento"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE selection AS LOGICAL.
            IF selection THEN DO:
                DELETE integral.cbdbanco.
                RUN pintado.
            END.
            ELSE
                FIND integral.cbdbanco
                    WHERE RECID-Tmp = RECID( integral.cbdbanco )
                        NO-LOCK NO-ERROR.
        END.
        ELSE MESSAGE "No existen movimientos." VIEW-AS ALERT-BOX ERROR
        BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-exit W-maestro
ON CHOOSE OF B-exit IN FRAME F-ctrl-frame /* Salir */
DO:
     APPLY  "CLOSE" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-first
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-first W-maestro
ON CHOOSE OF B-first IN FRAME F-ctrl-frame /* << */
DO:
    FIND FIRST {&TABLES-IN-QUERY-F-maestro}
        &IF "{&RECORD-SCOPE}" <> "" &THEN
            WHERE {&RECORD-SCOPE}
        &ENDIF
        NO-LOCK NO-ERROR.
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
    ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
        BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-maestro
&Scoped-define SELF-NAME B-Imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Imprimir W-maestro
ON CHOOSE OF B-Imprimir IN FRAME F-maestro /* Imprimir */
DO:

    DEFINE VARIABLE answer AS LOGICAL NO-UNDO.

    SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
    IF NOT answer THEN RETURN NO-APPLY.
    RUN imprimir.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-ctrl-frame
&Scoped-define SELF-NAME B-last
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-last W-maestro
ON CHOOSE OF B-last IN FRAME F-ctrl-frame /* >> */
DO:

     FIND LAST {&FIRST-TABLE-IN-QUERY-F-maestro}
     &IF "{&RECORD-SCOPE}" <> "" &THEN
          WHERE {&RECORD-SCOPE}
      &ENDIF  
      NO-LOCK  NO-ERROR.
     
     IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
     ELSE MESSAGE "No exiten Registros." VIEW-AS ALERT-BOX ERROR
             BUTTONS OK.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-next
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-next W-maestro
ON CHOOSE OF B-next IN FRAME F-ctrl-frame /* > */
DO: 
     FIND NEXT {&FIRST-TABLE-IN-QUERY-F-maestro}  
     &IF "{&RECORD-SCOPE}" <> "" &THEN
          WHERE {&RECORD-SCOPE}
     &ENDIF
     NO-LOCK  NO-ERROR.
     IF NOT AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN 
     FIND FIRST {&FIRST-TABLE-IN-QUERY-F-maestro} 
     &IF "{&RECORD-SCOPE}" <> "" &THEN
          WHERE {&RECORD-SCOPE}
     &ENDIF  
     NO-LOCK NO-ERROR.
     IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
     ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
             BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-search
&Scoped-define SELF-NAME B-ok-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-ok-3 W-maestro
ON CHOOSE OF B-ok-3 IN FRAME F-search /* Aceptar */
DO:
    IF cb-ctas.codcta:SCREEN-VALUE IN FRAME F-maestro <> "" THEN DO:
         FIND FIRST  {&FIRST-TABLE-IN-QUERY-F-maestro}
              WHERE 
                  &IF "{&RECORD-SCOPE}" <> "" &THEN
                      {&RECORD-SCOPE} AND
                  &ENDIF
                  cb-ctas.codcta = cb-ctas.codcta:SCREEN-VALUE IN FRAME F-maestro
                   NO-LOCK NO-ERROR.
         ASSIGN integral.cb-ctas.Nomcta:SCREEN-VALUE = "".
    END.

    IF integral.cb-ctas.Nomcta:SCREEN-VALUE IN FRAME F-maestro <> "" THEN DO:
         FIND FIRST  {&FIRST-TABLE-IN-QUERY-F-maestro}
              WHERE 
                  &IF "{&RECORD-SCOPE}" <> "" &THEN
                      {&RECORD-SCOPE} AND
                  &ENDIF
                  integral.cb-ctas.Nomcta BEGINS integral.cb-ctas.Nomcta:SCREEN-VALUE IN FRAME F-maestro
                   NO-LOCK NO-ERROR.
         ASSIGN integral.cb-ctas.codcta:SCREEN-VALUE = "".
    END.
   
     IF NOT AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
         APPLY "CHOOSE" TO B-Browse IN FRAME F-ctrl-frame.
        IF RECID-stack <> 0
        THEN RETURN.
     END.
         
     IF NOT AVAIL  {&FIRST-TABLE-IN-QUERY-F-maestro}  THEN DO:
         FIND FIRST  {&FIRST-TABLE-IN-QUERY-F-maestro}
         &IF "{&RECORD-SCOPE}" <> "" &THEN
              WHERE {&RECORD-SCOPE}
          &ENDIF  
          NO-LOCK NO-ERROR.
     END.
     
      IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN  RUN Pintado.
      ELSE DO:
           CLEAR FRAME F-maestro.
           MESSAGE  "Registro no Existente." VIEW-AS ALERT-BOX ERROR BUTTONS OK. 
     END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-ctrl-frame
&Scoped-define SELF-NAME B-prev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-prev W-maestro
ON CHOOSE OF B-prev IN FRAME F-ctrl-frame /* < */
DO:
     FIND PREV {&FIRST-TABLE-IN-QUERY-F-maestro}
     &IF "{&RECORD-SCOPE}" <> "" &THEN
          WHERE {&RECORD-SCOPE}
     &ENDIF  
     NO-LOCK  NO-ERROR.
     IF NOT AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN 
     FIND LAST {&FIRST-TABLE-IN-QUERY-F-maestro} 
     &IF "{&RECORD-SCOPE}" <> "" &THEN
          WHERE {&RECORD-SCOPE}
     &ENDIF  
     NO-LOCK NO-ERROR.
     IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
     ELSE MESSAGE "No Existen Registros" VIEW-AS ALERT-BOX ERROR
             BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-query
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-query W-maestro
ON CHOOSE OF B-query IN FRAME F-ctrl-frame /* Buscar */
DO:
    FIND FIRST {&FIRST-TABLE-IN-QUERY-F-maestro}
        &IF "{&RECORD-SCOPE}" <> "" &THEN
            WHERE {&RECORD-SCOPE}
        &ENDIF
        NO-LOCK NO-ERROR.
    IF NOT AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
        MESSAGE  "No exiten Registros." VIEW-AS ALERT-BOX ERROR
        BUTTONS OK.
        RETURN.
    END.
    CLEAR FRAME F-maestro.
    FRAME F-ctrl-frame:VISIBLE = FALSE.
    FRAME F-search:VISIBLE = TRUE.
    ENABLE {&QUERY-field} WITH FRAME F-maestro.
    BRW-credito:SENSITIVE = FALSE.
    B-saldoi:SENSITIVE = FALSE.
    WAIT-FOR "CHOOSE" OF b-ok-3 IN FRAME f-search
        OR CHOOSE OF b-cancel-3 IN FRAME f-search.
    DISABLE {&QUERY-field} WITH FRAME F-maestro.
    FRAME f-search:VISIBLE = FALSE.
    BRW-credito:SENSITIVE = TRUE.
    FRAME f-ctrl-frame:VISIBLE = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-maestro
&Scoped-define SELF-NAME B-saldoi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-saldoi W-maestro
ON CHOOSE OF B-saldoi IN FRAME F-maestro /* Modif. Saldo Inicial */
DO:
    x-saldoi:SENSITIVE IN FRAME F-maestro = TRUE.
    APPLY "ENTRY" TO x-saldoi.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-ctrl-frame
&Scoped-define SELF-NAME B-update
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-update W-maestro
ON CHOOSE OF B-update IN FRAME F-ctrl-frame /* Modificar */
DO:
    RECID-stack = 0.
    IF AVAIL integral.cbdbanco THEN RECID-stack = RECID( integral.cbdbanco ).
    DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        FIND integral.cbdbanco WHERE RECID ( integral.cbdbanco ) = RECID-stack
            EXCLUSIVE NO-ERROR.
        IF AVAIL integral.cbdbanco THEN DO:
            UPDATE integral.Cbdbanco.Fchref
                   integral.Cbdbanco.Nroref
                   integral.Cbdbanco.TpoMov
                   integral.Cbdbanco.Importe
                   b-aceptar b-cancelar WITH FRAME F-ctacredito.
            {&OPEN-QUERY-BRW-credito}
            RUN calcula.
        END.
        ELSE MESSAGE "Registro de movimiento no existe"
            VIEW-AS ALERT-BOX ERROR.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-maestro
&Scoped-define SELF-NAME cb-ctas.Codcta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.Codcta W-maestro
ON LEAVE OF cb-ctas.Codcta IN FRAME F-maestro /* Cuenta */
DO:
/*
    IF LOOKUP (LAST-EVENT:FUNCTION,"ENDKEY,ERROR,END-ERROR") <> 0 THEN RETURN.
    IF NOT ( integral.cb-ctas.codcta:SCREEN-VALUE IN FRAME F-maestro BEGINS x-ctacre OR
             integral.cb-ctas.codcta:SCREEN-VALUE IN FRAME F-maestro BEGINS x-ctaaho ) 
    THEN DO:
        MESSAGE "C¢digos de cuentas no v lidos, deben ser:" SKIP
                x-ctacre + " / " + x-ctaaho
                VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO integral.cb-ctas.codcta.
        RETURN NO-APPLY.
    END.  
    FIND integral.cb-ctas WHERE integral.cb-ctas.codcia = s-codcia AND
        integral.cb-ctas.codcta = integral.cb-ctas.codcta:SCREEN-VALUE
             NO-LOCK  NO-ERROR.
    IF NOT AVAIL integral.cb-ctas THEN DO:
        MESSAGE "Nro.de cuenta no existente." VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO integral.cb-ctas.codcta.
        RETURN NO-APPLY.
    END.
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-saldoi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-saldoi W-maestro
ON LEAVE OF x-saldoi IN FRAME F-maestro /* Sld.Inicial */
DO:
    ASSIGN x-saldoi.
    FOR EACH integral.cbdbanco WHERE integral.cbdbanco.codcia = s-codcia AND
        integral.cbdbanco.periodo = s-periodo AND
        integral.cbdbanco.nromes  = s-NroMes AND
        integral.cbdbanco.codcta  = integral.cb-ctas.codcta AND
        integral.cbdbanco.flgest  = "B":
        ASSIGN integral.cbdbanco.sdoini = x-saldoi.
    END.
    GET FIRST BRW-credito NO-LOCK.    
    x-total = x-saldoi + ( x-totcargo - x-totabono ).
    DISPLAY x-total WITH FRAME F-maestro.
    x-saldoi:SENSITIVE = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-ctrl-frame
&Scoped-define BROWSE-NAME BRW-credito
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-maestro 


/* ***************************  Main Block  *************************** */

/* Send messages to alert boxes because there is no message area.       */
ASSIGN CURRENT-WINDOW             = {&WINDOW-NAME}
       SESSION:SYSTEM-ALERT-BOXES = (CURRENT-WINDOW:MESSAGE-AREA = NO).
 
ON CLOSE OF THIS-PROCEDURE
      RUN disable_UI.
        
ON "WINDOW-CLOSE" OF {&WINDOW-NAME}  DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

ON "ENDKEY", END-ERROR OF B-add, B-browse, B-Cancel-3, 
        B-delete, B-exit, B-first, B-last, B-next, B-ok-3, B-prev, 
        B-query, B-update, FRAME F-maestro
DO: 
    IF FRAME F-search:VISIBLE = TRUE THEN APPLY "CHOOSE" TO B-cancel-3.
    IF FRAME F-ctrl-frame:VISIBLE = TRUE 
    THEN APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

ON "GO" OF FRAME F-maestro, FRAME F-search
DO: 
    IF FRAME F-search:VISIBLE = TRUE THEN APPLY "CHOOSE" TO B-ok-3.
    RETURN NO-APPLY.
END.

ON DELETE-CHARACTER OF  B-query, B-add, B-update, B-delete, 
            B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-delete.
    RETURN NO-APPLY.    
END.

ON END OF  B-query, B-add, B-update, B-delete, 
           B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-last.
    RETURN NO-APPLY.    
END.

ON F8 OF  B-query, B-add, B-update, B-delete, 
          B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-browse.
    RETURN NO-APPLY.    
END.

ON HOME OF  B-query, B-add, B-update, B-delete, 
            B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-first.
    RETURN NO-APPLY.    
END.

ON INSERT-MODE OF  B-query, B-add, B-update, B-delete, 
            B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-add.
    RETURN NO-APPLY.    
END.

ON PAGE-DOWN OF  B-query, B-add, B-update, B-delete, 
            B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-next.
    RETURN NO-APPLY.  
END.

ON PAGE-UP OF  B-query, B-add, B-update, B-delete, 
            B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-prev.
    RETURN NO-APPLY.  
END.

ON RETURN OF  B-query, B-add, B-update, B-delete, 
            B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-update.
    RETURN NO-APPLY.    
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

MAIN-BLOCK:
DO ON ERROR UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    ASSIGN
    FRAME f-search:VISIBLE = FALSE
    FRAME F-ctrl-frame:VISIBLE = TRUE.

    RUN enable_UI.

    FIND LAST {&FIRST-TABLE-IN-QUERY-F-maestro}
    &IF "{&RECORD-SCOPE}" <> "" &THEN
         WHERE {&RECORD-SCOPE}
    &ENDIF
    NO-LOCK  NO-ERROR.
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
    ELSE CLEAR FRAME F-maestro.

    DISABLE {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
    IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcula W-maestro 
PROCEDURE calcula :
ASSIGN
    x-saldoi   = 0
    x-totabono = 0
    x-total    = 0
    x-totcargo = 0.

GET FIRST BRW-credito NO-LOCK.

IF AVAIL integral.cbdbanco THEN
    x-saldoi = integral.cbdbanco.sdoini.

DO WHILE AVAIL ( integral.cbdbanco ):
    IF integral.cbdbanco.tpomov THEN
        x-totabono = x-totabono + integral.cbdbanco.importe.
    ELSE
        x-totcargo = x-totcargo + integral.cbdbanco.importe.
    GET NEXT BRW-credito NO-LOCK.
END.

x-total = x-saldoi + ( x-totabono - x-totcargo ).

DISPLAY x-saldoi x-totabono x-total x-totcargo WITH FRAME F-maestro.
GET FIRST BRW-credito NO-LOCK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-maestro _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-maestro)
  THEN DELETE WIDGET W-maestro.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-maestro _DEFAULT-ENABLE
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

  {&OPEN-QUERY-F-maestro}
  GET FIRST F-maestro.
  DISPLAY x-totcargo x-totabono x-total x-saldoi 
      WITH FRAME F-maestro IN WINDOW W-maestro.
  IF AVAILABLE cb-ctas THEN 
    DISPLAY cb-ctas.Codcta cb-ctas.Nomcta cb-ctas.Codmon 
      WITH FRAME F-maestro IN WINDOW W-maestro.
  ENABLE R-maestro2 R-saldoi R-maestro1 BRW-credito cb-ctas.Codcta 
         cb-ctas.Nomcta cb-ctas.Codmon B-saldoi B-Imprimir 
      WITH FRAME F-maestro IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-maestro}
  ENABLE R-consulta R-exit R-query R-navigaate R-modify B-query B-add B-update 
         B-delete B-first B-prev B-next B-last B-browse B-exit 
      WITH FRAME F-ctrl-frame IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-ctrl-frame}
  ENABLE R-navigaate-4 B-ok-3 B-Cancel-3 
      WITH FRAME F-search IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-search}
  VIEW W-maestro.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir W-maestro 
PROCEDURE imprimir :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    
    DEFINE VARIABLE x-glodoc   AS CHARACTER FORMAT "X(25)".
    DEFINE VARIABLE x-inicial  AS INTEGER FORMAT "(ZZZZ,ZZ9.99)" INITIAL 0.
    DEFINE VARIABLE x-final    AS INTEGER FORMAT "(ZZZZ,ZZ9.99)" INITIAL 0.
    DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "(ZZZZ,ZZ9.99)".
    DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "(ZZZZ,ZZ9.99)".
    DEFINE VARIABLE x-tdebe    AS DECIMAL FORMAT "(ZZZZ,ZZ9.99)".
    DEFINE VARIABLE x-thaber   AS DECIMAL FORMAT "(ZZZZ,ZZ9.99)".
    DEFINE VARIABLE x-fecha    AS DATE FORMAT "99/99/99" INITIAL TODAY.
    DEFINE VARIABLE x-codmon   AS INTEGER INITIAL 1.
    DEFINE VARIABLE x-con-reg  AS INTEGER.
    DEFINE VARIABLE x-cuenta   LIKE integral.cb-ctas.codcta.
    DEFINE VARIABLE x-nomcta   LIKE integral.cb-ctas.nomcta.
    DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)".
    
    RUN bin/_mes.p ( INPUT s-NroMes , 1,  OUTPUT pinta-mes ).
    pinta-mes = pinta-mes + " DE " + STRING( s-periodo , "9999" ).
    x-inicial = x-saldoi.
     
    OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 62.

    DEFINE FRAME f-cab
        integral.Cbdbanco.Fchref LABEL "Fecha"
        SPACE(1)
        integral.Cbdbanco.Nroref LABEL "No Documento"
        SPACE(1)
        integral.Cbdbanco.Glodoc COLUMN-LABEL "Detalle" FORMAT "X(30)"
        SPACE(1)
        x-debe         COLUMN-LABEL "Cargos" FORMAT "(ZZZZ,ZZ9.99)"
        SPACE(1)
        x-haber        COLUMN-LABEL "Abonos" FORMAT "(ZZZZ,ZZ9.99)"
        HEADER empresas.nomcia "FECHA  : " AT 60 x-fecha AT 70 SKIP
             "HORA   : " AT 60 STRING(TIME,"hh:mm:ss") AT 70 SKIP
             "BANCO : " AT 20 x-cuenta FORMAT "X(8)" x-nomcta FORMAT "X(25)" SKIP
             "EXTRACTO BANCARIO " AT 20 pinta-mes AT 40 SKIP(1)
             "SALDO INICIAL : " AT 48 x-saldoi AT 63 SKIP
             FILL("-",78) FORMAT "X(78)"                  
        WITH WIDTH 80 NO-BOX STREAM-IO DOWN.

    FIND integral.cb-ctas WHERE integral.cb-ctas.codcia = y-codcia AND
            integral.cb-ctas.codcta = integral.cb-ctas.codcta:SCREEN-VALUE IN 
            FRAME F-maestro
            NO-LOCK NO-ERROR.
    x-codmon = integral.cb-ctas.codmon.
    x-cuenta = integral.cb-ctas.codcta.
    x-nomcta = integral.cb-ctas.nomcta.  
    IF integral.cb-ctas.codmon = 1 THEN
        x-nomcta = x-nomcta + " (S/.) ".
    ELSE
        x-nomcta = x-nomcta + " (US$) ".
        
    PUT STREAM report CONTROL "~033x" NULL "~017~033P".
    FOR EACH cbdbanco NO-LOCK WHERE cbdbanco.codcia = s-codcia AND
        Cbdbanco.Periodo = s-periodo AND  
        cbdbanco.nromes  = s-NroMes AND 
        cbdbanco.codcta  = x-cuenta
        BREAK BY cbdbanco.codcta
              BY cbdbanco.fchref ON ERROR UNDO, LEAVE:
        IF integral.cbdbanco.TpoMov THEN DO:
            x-debe  = 0.
            x-haber = cbdbanco.Importe.
            x-thaber = x-thaber + x-haber.
        END.
        ELSE DO:
            x-debe  = cbdbanco.Importe.
            x-haber = 0.
            x-tdebe = x-tdebe + x-debe.
        END.
        IF NOT (x-haber = 0 AND x-debe = 0) AND x-debe <> ? AND x-haber <> ?
        THEN DO:
            ACCUMULATE x-debe  (SUB-TOTAL BY cbdbanco.codcta).
            ACCUMULATE x-haber (SUB-TOTAL BY cbdbanco.codcta).
            DISPLAY STREAM report cbdbanco.fchref
                                  cbdbanco.nroref
                                  cbdbanco.glodoc
                                  x-debe   WHEN (x-debe  <> 0)
                                  x-haber  WHEN (x-haber <> 0) 
                            WITH FRAME f-cab.
        END.

        IF LAST-OF (cbdbanco.codcta)
        THEN DO:
            PUT STREAM report FILL("-",78) FORMAT "X(78)" SKIP.
            DOWN STREAM report WITH FRAME f-cab.
            DISPLAY STREAM report 
                    ACCUM SUB-TOTAL BY (cbdbanco.codcta) x-debe  @ x-debe
                    ACCUM SUB-TOTAL BY (cbdbanco.codcta) x-haber @ x-haber
                WITH FRAME f-cab.
        END.
    END.
    x-final = x-inicial - x-tdebe + x-thaber.
    PUT STREAM report "(=) SALDO BANCOS : " AT 48 x-final AT 63.                   
    OUTPUT STREAM report CLOSE.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pintado W-maestro 
PROCEDURE pintado :
DISPLAY {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
    {&OPEN-BROWSERS-IN-QUERY-F-maestro}
IF QUERY-OFF-END("BRW-credito") THEN B-saldoi:SENSITIVE = FALSE.
ELSE B-saldoi:SENSITIVE = TRUE.
RUN calcula.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


