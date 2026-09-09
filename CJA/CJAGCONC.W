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
DEFINE {&NEW} SHARED VARIABLE s-NroMes AS INTEGER INITIAL 11.
DEFINE VARIABLE RECID-stack AS RECID NO-UNDO.
DEFINE VARIABLE RECID-tmp   AS RECID NO-UNDO.
DEFINE VARIABLE x-nivel     AS CHARACTER.
DEFINE VARIABLE x-ctacre    AS CHARACTER INITIAL "".
DEFINE VARIABLE x-maxnivel  AS INTEGER.
DEFINE VARIABLE x-debe      AS DECIMAL.
DEFINE VARIABLE x-haber     AS DECIMAL.
DEFINE VARIABLE pto         AS LOGICAL.
DEFINE VARIABLE k           AS INTEGER INITIAL 0.
DEFINE VARIABLE cnromes     AS INTEGER INITIAL 0.
DEFINE VARIABLE cnroano     AS INTEGER INITIAL 0.
DEFINE BUFFER bcoaux FOR integral.bcoconci.
DEFINE VARIABLE x-nroref    AS CHARACTER INITIAL "".
DEFINE VARIABLE x-importe   AS DECIMAL INITIAL 0.
DEFINE VARIABLE x-totabono  AS DECIMAL INITIAL 0.
DEFINE VARIABLE x-totcargo  AS DECIMAL INITIAL 0.
DEFINE VARIABLE impca1      AS DECIMAL INITIAL 0.
DEFINE VARIABLE impca2      AS DECIMAL INITIAL 0.
DEFINE VARIABLE impca3      AS DECIMAL INITIAL 0.
DEFINE VARIABLE impca4      AS DECIMAL INITIAL 0.
DEFINE VARIABLE impca5      AS DECIMAL INITIAL 0.
DEFINE VARIABLE impca6      AS DECIMAL INITIAL 0.
DEFINE VARIABLE x-codmon    AS INTEGER INITIAL 1.
DEFINE VARIABLE x-logico    AS LOGICAL INITIAL FALSE.
DEFINE VARIABLE xsdomesant AS DECIMAL FORMAT "(ZZZZ,ZZ9.99)" INITIAL 0.
DEFINE VARIABLE xcarmesact AS DECIMAL FORMAT "(ZZZZ,ZZ9.99)" INITIAL 0.
DEFINE VARIABLE xabomesact AS DECIMAL FORMAT "(ZZZZ,ZZ9.99)" INITIAL 0.
DEFINE VARIABLE xconbcocar AS DECIMAL FORMAT "(ZZZZ,ZZ9.99)" INITIAL 0.
DEFINE VARIABLE xconbcoabo AS DECIMAL FORMAT "(ZZZZ,ZZ9.99)" INITIAL 0.
DEFINE VARIABLE xconlibabo AS DECIMAL FORMAT "(ZZZZ,ZZ9.99)" INITIAL 0.
DEFINE VARIABLE xconlibcar AS DECIMAL FORMAT "(ZZZZ,ZZ9.99)" INITIAL 0.
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
&Scoped-define INTERNAL-TABLES bcoconci cb-ctas

/* Definitions for BROWSE BRW-credito                                   */
&Scoped-define FIELDS-IN-QUERY-BRW-credito bcoconci.Fchref bcoconci.Nroref ~
bcoconci.TpoMov ~
(IF (NOT integral.bcoconci.TpoMov) THEN (integral.bcoconci.Importe) ELSE (0)) ~
(IF (integral.bcoconci.TpoMov) THEN (integral.bcoconci.Importe) ELSE (0)) ~
bcoconci.Codope bcoconci.Nroast bcoconci.Glodoc ~
(IF integral.bcoconci.Flgori = "B"  THEN "Banco"  ELSE "Libro") ~
bcoconci.MesOri bcoconci.Flgest bcoconci.MesCon 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BRW-credito 
&Scoped-define FIELD-PAIRS-IN-QUERY-BRW-credito
&Scoped-define OPEN-QUERY-BRW-credito OPEN QUERY BRW-credito FOR EACH bcoconci WHERE TRUE /* Join to cb-ctas incomplete */ ~
      AND bcoconci.Codcia = s-codcia ~
 AND bcoconci.Periodo = s-periodo ~
 AND bcoconci.Nromes = s-NroMes ~
 AND bcoconci.flgest = "" ~
 AND bcoconci.codcta = cb-ctas.codcta:SCREEN-VALUE NO-LOCK ~
    BY bcoconci.Fchref ~
       BY bcoconci.Nroref.
&Scoped-define TABLES-IN-QUERY-BRW-credito bcoconci
&Scoped-define FIRST-TABLE-IN-QUERY-BRW-credito bcoconci


/* Definitions for FRAME F-maestro                                      */
&Scoped-define FIELDS-IN-QUERY-F-maestro cb-ctas.Codcta cb-ctas.Nomcta 
&Scoped-define ENABLED-FIELDS-IN-QUERY-F-maestro cb-ctas.Codcta ~
cb-ctas.Nomcta 
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
&Scoped-Define ENABLED-OBJECTS R-modify R-exit R-consulta R-navigaate ~
R-query B-query B-add B-Imprime B-first B-prev B-next B-last B-browse ~
B-exit 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-maestro AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-add 
     LABEL "&Conciliaci¢n":L 
     SIZE 11 BY 1
     FONT 4.

DEFINE BUTTON B-browse 
     IMAGE-UP FILE "IMG/pvbrow":U
     IMAGE-DOWN FILE "IMG/pvbrowd":U
     IMAGE-INSENSITIVE FILE "IMG/pvbrowx":U
     LABEL "&Consulta" 
     SIZE 5.72 BY 1.5.

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

DEFINE BUTTON B-Imprime 
     LABEL "&Impresi¢n" 
     SIZE 11 BY 1.

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

DEFINE VARIABLE x-bancos AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "(-) No conciliado bancos" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-concil AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "(=) Saldo Conciliado" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-contable AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "Saldo  Contable" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-libros AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "(+) No  conciliado  libros" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-saldoi AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "Saldo Inicial de Bancos" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-total AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "(+) Saldo Final de Bancos" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE R-maestro1
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 90.86 BY 3
     BGCOLOR 8 FGCOLOR 15 .

DEFINE RECTANGLE R-maestro2
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 90.86 BY 10.62
     BGCOLOR 8 FGCOLOR 15 .

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
      bcoconci SCROLLING.

DEFINE QUERY F-maestro FOR 
      cb-ctas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BRW-credito
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BRW-credito W-maestro _STRUCTURED
  QUERY BRW-credito NO-LOCK DISPLAY
      bcoconci.Fchref COLUMN-LABEL "Fecha    !Refer.    "
      bcoconci.Nroref FORMAT "X(12)"
      bcoconci.TpoMov
      (IF (NOT integral.bcoconci.TpoMov) THEN (integral.bcoconci.Importe) ELSE (0)) COLUMN-LABEL "Cargo" FORMAT "ZZ,ZZZ,ZZZ,ZZ9.99"
      (IF (integral.bcoconci.TpoMov) THEN (integral.bcoconci.Importe) ELSE (0)) COLUMN-LABEL "Abono" FORMAT "ZZ,ZZZ,ZZZ,ZZ9.99"
      bcoconci.Codope
      bcoconci.Nroast
      bcoconci.Glodoc FORMAT "x(20)"
      (IF integral.bcoconci.Flgori = "B"  THEN "Banco"  ELSE "Libro") COLUMN-LABEL "Orig"
      bcoconci.MesOri COLUMN-LABEL "Mes!Ori"
      bcoconci.Flgest COLUMN-LABEL "S!T"
      bcoconci.MesCon COLUMN-LABEL "Mes!Con"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 85 BY 7.5
         BGCOLOR 15 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-maestro
     BRW-credito AT ROW 4.5 COL 88 RIGHT-ALIGNED
     cb-ctas.Codcta AT ROW 1.5 COL 7 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 15 
     cb-ctas.Nomcta AT ROW 1.5 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 68 BY .81
          BGCOLOR 15 
     x-bancos AT ROW 12.38 COL 26 COLON-ALIGNED
     x-libros AT ROW 13.38 COL 26 COLON-ALIGNED
     x-saldoi AT ROW 2.5 COL 36 COLON-ALIGNED
     x-total AT ROW 2.5 COL 73 COLON-ALIGNED
     x-concil AT ROW 12.38 COL 73 COLON-ALIGNED
     x-contable AT ROW 13.38 COL 73 COLON-ALIGNED
     R-maestro1 AT ROW 1 COL 1
     R-maestro2 AT ROW 4 COL 1
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
     B-add AT ROW 1.5 COL 16
     B-Imprime AT ROW 1.5 COL 30
     B-first AT ROW 1.5 COL 46
     B-prev AT ROW 1.5 COL 52
     B-next AT ROW 1.5 COL 58
     B-last AT ROW 1.5 COL 64
     B-browse AT ROW 1.27 COL 72
     B-exit AT ROW 1.5 COL 82
     R-modify AT ROW 1 COL 11
     R-exit AT ROW 1 COL 80
     R-consulta AT ROW 1 COL 70
     R-navigaate AT ROW 1 COL 44
     R-query AT ROW 1 COL 1
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
         TITLE              = "Conciliaci¢n Bancaria"
         COLUMN             = 17.43
         ROW                = 8.88
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
/* SETTINGS FOR FRAME F-maestro
   UNDERLINE                                                            */
/* BROWSE-TAB BRW-credito R-maestro2 F-maestro */
/* SETTINGS FOR BROWSE BRW-credito IN FRAME F-maestro
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN x-saldoi IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-total IN FRAME F-maestro
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
     _TblList          = "integral.bcoconci WHERE integral.cb-ctas <external> ..."
     _Options          = "NO-LOCK"
     _OrdList          = "integral.bcoconci.Fchref|yes,integral.bcoconci.Nroref|yes"
     _Where[1]         = "integral.bcoconci.Codcia = s-codcia
 AND integral.bcoconci.Periodo = s-periodo
 AND integral.bcoconci.Nromes = s-NroMes
 AND integral.bcoconci.flgest = """"
 AND integral.bcoconci.codcta = integral.cb-ctas.codcta:SCREEN-VALUE"
     _FldNameList[1]   > integral.bcoconci.Fchref
"bcoconci.Fchref" "Fecha    !Refer.    " ? "date" ? ? ? ? ? ? no ?
     _FldNameList[2]   > integral.bcoconci.Nroref
"bcoconci.Nroref" ? "X(12)" "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   = integral.bcoconci.TpoMov
     _FldNameList[4]   > "_<CALC>"
"(IF (NOT integral.bcoconci.TpoMov) THEN (integral.bcoconci.Importe) ELSE (0))" "Cargo" "ZZ,ZZZ,ZZZ,ZZ9.99" ? ? ? ? ? ? ? no ?
     _FldNameList[5]   > "_<CALC>"
"(IF (integral.bcoconci.TpoMov) THEN (integral.bcoconci.Importe) ELSE (0))" "Abono" "ZZ,ZZZ,ZZZ,ZZ9.99" ? ? ? ? ? ? ? no ?
     _FldNameList[6]   = integral.bcoconci.Codope
     _FldNameList[7]   = integral.bcoconci.Nroast
     _FldNameList[8]   > integral.bcoconci.Glodoc
"bcoconci.Glodoc" ? "x(20)" "character" ? ? ? ? ? ? no ?
     _FldNameList[9]   > "_<CALC>"
"(IF integral.bcoconci.Flgori = ""B""  THEN ""Banco""  ELSE ""Libro"")" "Orig" ? ? ? ? ? ? ? ? no ?
     _FldNameList[10]   > integral.bcoconci.MesOri
"bcoconci.MesOri" "Mes!Ori" ? "integer" ? ? ? ? ? ? no ?
     _FldNameList[11]   > integral.bcoconci.Flgest
"bcoconci.Flgest" "S!T" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[12]   > integral.bcoconci.MesCon
"bcoconci.MesCon" "Mes!Con" ? "integer" ? ? ? ? ? ? no ?
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
ON CHOOSE OF B-add IN FRAME F-ctrl-frame /* Conciliaci¢n */
DO:
    DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE:
        FIND FIRST integral.cbdbanco WHERE integral.cbdbanco.codcia = s-codcia
            AND integral.cbdbanco.periodo = s-periodo
            AND integral.cbdbanco.nromes  = s-NroMes
            AND integral.cbdbanco.codcta  = INPUT FRAME F-maestro integral.cb-ctas.codcta
            NO-LOCK  NO-ERROR.
        IF NOT AVAIL integral.cbdbanco THEN DO:
            MESSAGE "Cuenta no registrada en extracto bancario." VIEW-AS
               ALERT-BOX ERROR.
            APPLY "ENTRY" TO integral.cb-ctas.codcta.
            RETURN NO-APPLY.
        END.
        /*
        FIND FIRST integral.cbdbanco WHERE integral.cbdbanco.codcia = s-codcia
            AND integral.cbdbanco.periodo = s-periodo
            AND integral.cbdbanco.nromes  = s-NroMes
            AND integral.cbdbanco.codcta  = integral.cb-ctas.codcta:SCREEN-VALUE
            AND integral.cbdbanco.flgest  = "B"
            NO-LOCK  NO-ERROR.
        IF NOT AVAIL integral.cbdbanco THEN DO:
            MESSAGE "No hay registros de extracto bancario." VIEW-AS
                ALERT-BOX ERROR.
            APPLY "ENTRY" TO integral.cb-ctas.codcta.
            RETURN NO-APPLY.
        END.
        */
        x-saldoi = integral.cbdbanco.sdoini.
        x-total  = x-total + x-saldoi.
        DISPLAY x-saldoi WITH FRAME F-maestro.
        RUN concilia.
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


&Scoped-define SELF-NAME B-Imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Imprime W-maestro
ON CHOOSE OF B-Imprime IN FRAME F-ctrl-frame /* Impresi¢n */
DO:

    DEFINE VARIABLE answer AS LOGICAL NO-UNDO.

    SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
    IF NOT answer THEN RETURN NO-APPLY.
    RUN noconcil.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
    WAIT-FOR "CHOOSE" OF b-ok-3 IN FRAME f-search
        OR CHOOSE OF b-cancel-3 IN FRAME f-search.
    DISABLE {&QUERY-field} WITH FRAME F-maestro.
    FRAME f-search:VISIBLE = FALSE.
    BRW-credito:SENSITIVE = TRUE.
    FRAME f-ctrl-frame:VISIBLE = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BRW-credito
&Scoped-define FRAME-NAME F-maestro
&Scoped-define SELF-NAME BRW-credito
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BRW-credito W-maestro
ON MOUSE-SELECT-DBLCLICK OF BRW-credito IN FRAME F-maestro
DO:
    RECID-tmp = RECID(integral.bcoconci).
    DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        FIND integral.bcoconci WHERE RECID(integral.bcoconci) = RECID-tmp EXCLUSIVE-LOCK.
        IF AVAIL integral.bcoconci THEN DO:
            UPDATE integral.bcoconci.nroref WITH VIEW-AS DIALOG-BOX FRAME F-Browse.
            IF integral.bcoconci.flgori = "B" THEN DO:
                FIND integral.cbdbanco WHERE RECID(integral.cbdbanco) =
                    integral.bcoconci.n-recid EXCLUSIVE-LOCK.
                IF AVAIL integral.cbdbanco THEN
                    integral.cbdbanco.nroref = integral.bcoconci.nroref.
            END.
            IF integral.bcoconci.flgori = "L" THEN DO:
                FIND integral.cb-dmov WHERE RECID(integral.cb-dmov) =
                    integral.bcoconci.n-recid EXCLUSIVE-LOCK.
                IF AVAIL integral.cb-dmov THEN
                    integral.cb-dmov.nrodoc = integral.bcoconci.nroref.
            END.
            PTO = BRW-credito:REFRESH().
            /* trato de conciliar el cambio, ya no porque demora 5-10-95 */
            /*
            x-importe = 0.
            x-nroref  = integral.bcoconci.nroref.
            FOR EACH integral.bcoconci WHERE integral.bcoconci.codcia = s-codcia AND
                integral.bcoconci.periodo = s-periodo AND
                integral.bcoconci.nromes  = s-NroMes AND
                integral.bcoconci.codcta  = integral.cb-ctas.codcta AND
                integral.bcoconci.flgest  = "" AND
                integral.bcoconci.nroref  = x-nroref:
                IF integral.bcoconci.tpomov THEN
                    x-importe = x-importe - integral.bcoconci.importe.
                ELSE
                    x-importe = x-importe + integral.bcoconci.importe.
            END.
            IF ABS(x-importe) < 0.01 THEN DO:
                FOR EACH bcoaux WHERE bcoaux.codcia = s-codcia AND
                                bcoaux.periodo = s-periodo AND
                                bcoaux.nromes  = s-NroMes AND
                                bcoaux.codcta  = integral.cb-ctas.codcta AND
                                bcoaux.nroref  = x-nroref EXCLUSIVE-LOCK:
                    ASSIGN bcoaux.FlgEst = "C"
                           bcoaux.MesCon = s-NroMes.
                END.
            END.
            RUN Pintado.
            */
        END.
        ELSE MESSAGE "Registro No existente"  VIEW-AS ALERT-BOX.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ctas.Codcta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.Codcta W-maestro
ON LEAVE OF cb-ctas.Codcta IN FRAME F-maestro /* Cuenta */
DO:

/*    IF LOOKUP (LAST-EVENT:FUNCTION,"ENDKEY,ERROR,END-ERROR") <> 0 THEN RETURN.
    IF NOT ( integral.cb-ctas.codcta:SCREEN-VALUE IN FRAME F-maestro BEGINS x-ctacre OR
             integral.cb-ctas.codcta:SCREEN-VALUE IN FRAME F-maestro BEGINS x-ctaaho )
    THEN DO:
        MESSAGE "C¢digos de cuentas no v lidos, deben ser:" SKIP
                x-ctacre + " / " + x-ctaaho
                VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO integral.cb-ctas.codcta.
        RETURN NO-APPLY.
    END.
 */
    FIND integral.cb-ctas WHERE integral.cb-ctas.codcia = y-codcia AND
        integral.cb-ctas.codcta = integral.cb-ctas.codcta:SCREEN-VALUE
             NO-LOCK  NO-ERROR.
    IF NOT AVAIL integral.cb-ctas THEN DO:
        MESSAGE "Nro.de cuenta no existente." VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO integral.cb-ctas.codcta.
        RETURN NO-APPLY.
    END.
    x-codmon = cb-ctas.codmon.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-ctrl-frame
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
         B-exit, B-first, B-last, B-next, B-ok-3, B-prev,
        B-query,  FRAME F-maestro
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

ON END OF  B-query, B-add,
           B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-last.
    RETURN NO-APPLY.
END.

ON F8 OF  B-query, B-add,
          B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-browse.
    RETURN NO-APPLY.
END.

ON HOME OF  B-query, B-add,
            B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-first.
    RETURN NO-APPLY.
END.

ON INSERT-MODE OF  B-query, B-add,
            B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-add.
    RETURN NO-APPLY.
END.

ON PAGE-DOWN OF  B-query, B-add,
            B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-next.
    RETURN NO-APPLY.
END.

ON PAGE-UP OF  B-query, B-add,
            B-First, B-prev, B-next, B-last, B-Browse, B-exit
DO:
    APPLY "CHOOSE" TO B-prev.
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
x-saldoi   = 0.
x-totabono = 0.
x-total    = 0.
x-totcargo = 0.
x-logico   = TRUE.
x-concil   = 0.
x-bancos   = 0.
x-libros   = 0.
x-contable = 0.
x-codmon   = integral.cb-ctas.codmon.
xsdomesant = 0.
xcarmesact = 0.
xabomesact = 0.
xconbcocar = 0.
xconbcoabo = 0.
xconlibabo = 0.
xconlibcar = 0.
/*

RUN cbd/cbd_imp.p ( INPUT   s-codcia,
                        integral.cb-ctas.codcta:SCREEN-VALUE IN FRAME F-maestro,
                        "",
                        s-periodo,
                        s-NroMes,
                        x-codmon,
                OUTPUT impca1,
                OUTPUT impca2,
                OUTPUT impca3,
                OUTPUT impca4,
                OUTPUT impca5,
                OUTPUT impca6 ).
*/


xcarmesact = 0 .
xabomesact = 0 .
x-contable = 0 .
DEF VAR X-TEMPORAL AS DECIMAL.

FOR EACH CB-DMOV NO-LOCK WHERE CB-DMOV.CODCIA  = S-CODCIA  AND
                               CB-DMOV.PERIODO = S-PERIODO AND 
                               CB-DMOV.CODCTA  = cb-ctas.codcta:SCREEN-VALUE IN FRAME F-maestro AND
                               CB-DMOV.NROMES  <= S-NROMES :
                               
    CASE X-CODMON :
         WHEN 1 THEN X-TEMPORAL = CB-DMOV.IMPMN1.
         WHEN 2 THEN X-TEMPORAL = CB-DMOV.IMPMN2.
    END CASE.
                               
    IF CB-DMOV.NROMES = S-NROMES THEN 
       IF CB-DMOV.TPOMOV THEN xabomesact = xabomesact + X-TEMPORAL.
                         ELSE xcarmesact = xcarmesact + X-TEMPORAL.
  
    IF CB-DMOV.TPOMOV THEN X-CONTABLE = X-CONTABLE - X-TEMPORAL.
                      ELSE X-CONTABLE = X-CONTABLE + X-TEMPORAL.    
                
END.



FOR EACH integral.cbdbanco WHERE integral.cbdbanco.codcia = s-codcia AND
            integral.cbdbanco.periodo = s-periodo AND
                integral.cbdbanco.nromes  = s-NroMes AND
                    integral.cbdbanco.codcta  = integral.cb-ctas.codcta:
    IF x-logico THEN DO:
       x-saldoi = integral.cbdbanco.sdoini.
       x-total  = x-saldoi.
       x-logico = FALSE.
    END.
    IF integral.cbdbanco.tpomov THEN
        x-total = x-total + integral.cbdbanco.importe.
    ELSE
        x-total = x-total - integral.cbdbanco.importe.
END.
DISPLAY x-saldoi x-total WITH FRAME F-maestro.

GET FIRST BRW-credito NO-LOCK.

DO WHILE AVAIL ( integral.bcoconci ):
    IF integral.bcoconci.flgori = "B" THEN DO:
        IF integral.bcoconci.tpomov THEN DO:
            x-bancos = x-bancos - integral.bcoconci.importe.
            xconbcoabo = xconbcoabo + integral.bcoconci.importe.
        END.
        ELSE DO:
            x-bancos = x-bancos + integral.bcoconci.importe.
            xconbcocar = xconbcocar + integral.bcoconci.importe.
        END.
    END.
    IF integral.bcoconci.flgori = "L" THEN DO:
        IF integral.bcoconci.tpomov THEN DO:
            x-libros = x-libros + integral.bcoconci.importe.
            xconlibabo = xconlibabo + integral.bcoconci.importe.
        END.
        ELSE DO:
            x-libros = x-libros - integral.bcoconci.importe.
            xconlibcar = xconlibcar + integral.bcoconci.importe.
        END.
    END.
    GET NEXT BRW-credito NO-LOCK.
END.
x-concil = x-total - x-bancos + x-libros.

DISPLAY x-bancos x-concil x-libros x-contable WITH FRAME F-maestro.
GET FIRST BRW-credito NO-LOCK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE concilia W-maestro 
PROCEDURE concilia :
/* ANULANDO MOVIMIENTOS DEL MES DE PROCESO HACIA ADELANTE */

DEFINE VAR x-Imp1 AS DECIMAL.
DEFINE VAR x-Imp2 AS DECIMAL.

DISPLAY "ANULANDO MOVIMIENTOS DEL MES Y POSTERIORES" WITH FRAME F-mensaje VIEW-AS
DIALOG-BOX.
pto = SESSION:SET-WAIT("GENERAL").
FOR EACH bcoconci WHERE bcoconci.codcia = s-codcia AND
            bcoconci.periodo = s-periodo AND
            bcoconci.nromes  >= s-NroMes AND
            bcoconci.codcta  = cb-ctas.codcta EXCLUSIVE-LOCK:
            DELETE bcoconci.
END.
pto = SESSION:SET-WAIT("").

/* MOVIMIENTOS NO CONCILIADOS DEL MES ANTERIOR LOS AGREGO(ademas.nromes=s-NroMes)*/

DISPLAY "AGREGANDO MOVIMIENTOS NO CONCILIADOS DEL MES ANTERIOR" 
        WITH FRAME F-mensaje VIEW-AS DIALOG-BOX.
        
pto = SESSION:SET-WAIT("GENERAL").


cNroMes = s-NroMes - 1.
cNroAno = s-periodo.

IF cNroMes = 0 THEN DO :
   cNroMes = 12.
   cNroAno = s-periodo - 1.
END.   

FIND bcoaux WHERE bcoaux.codcia = s-codcia AND
     bcoaux.periodo = cNroAno AND
     bcoaux.nromes  = cnromes AND
     bcoaux.Flgest  = "" AND
     bcoaux.codcta  = cb-ctas.codcta NO-ERROR.
     
FOR EACH bcoaux WHERE bcoaux.codcia = s-codcia AND
    bcoaux.periodo = cNroAno AND
    bcoaux.nromes  = cnromes AND
    bcoaux.Flgest  = "" AND
    bcoaux.codcta  = cb-ctas.codcta:
    CREATE bcoconci.
    ASSIGN bcoconci.codcia  = bcoaux.codcia
           bcoconci.periodo = s-Periodo
           bcoconci.nromes  = s-NroMes
           bcoconci.codcta  = cb-ctas.codcta
           bcoconci.Fchref  = bcoaux.Fchref
           bcoconci.Glodoc  = bcoaux.Glodoc
           bcoconci.Importe = bcoaux.Importe
           bcoconci.Nroref  = bcoaux.Nroref
           bcoconci.TpoMov  = bcoaux.TpoMov
           bcoconci.flgori  = bcoaux.flgori
           bcoconci.n-recid = bcoaux.n-recid
           bcoconci.codope  = bcoaux.codope
           bcoconci.nroast  = bcoaux.nroast
           bcoconci.glodoc  = bcoaux.glodoc
           bcoconci.sdoini  = x-saldoi
           bcoconci.mesori  = bcoaux.mesori.
END.

pto = SESSION:SET-WAIT("").

/* AGREGAR EL EXTRACTO BANCARIO */

DISPLAY "AGREGANDO MOVIMIENTOS DEL EXTRACTO BANCARIO" WITH FRAME F-mensaje VIEW-AS
DIALOG-BOX.
pto = SESSION:SET-WAIT("GENERAL").
FOR EACH cbdbanco WHERE cbdbanco.codcia = s-codcia AND
         cbdbanco.periodo = s-periodo AND
         cbdbanco.nromes  = s-NroMes AND
         cbdbanco.codcta  = cb-ctas.codcta:
    CREATE bcoconci.
    ASSIGN bcoconci.codcia  = s-codcia
           bcoconci.periodo = s-periodo
           bcoconci.nromes  = s-NroMes
           bcoconci.codcta  = cb-ctas.codcta
           bcoconci.Fchref  = cbdbanco.Fchref
           bcoconci.Glodoc  = cbdbanco.Glodoc
           bcoconci.Importe = cbdbanco.Importe
           bcoconci.Nroref  = cbdbanco.Nroref
           bcoconci.Sdoini  = cbdbanco.Sdoini
           bcoconci.TpoMov  = cbdbanco.TpoMov
           bcoconci.n-recid = RECID(cbdbanco)
           bcoconci.mesori  = s-NroMes
           bcoconci.flgori  = "B".
END.

pto = SESSION:SET-WAIT("").

/* AGREGAR EL MOVIMIENTO CONTABLE */


DISPLAY "AGREGANDO MOVIMIENTOS CONTABLE" WITH FRAME F-mensaje VIEW-AS
DIALOG-BOX.

pto = SESSION:SET-WAIT("GENERAL").
FOR EACH cb-dmov WHERE cb-dmov.codcia = s-codcia    AND
                       cb-dmov.periodo = s-periodo  AND
                       cb-dmov.nromes  = s-NroMes   AND
                       cb-dmov.codcta  = cb-ctas.codcta 
                       BREAK BY cb-dmov.NroDoc :
                       
    /* EXCLUIR DIFERENCIA DE CAMBIO Y TRASLACION */
    
    IF FIRST-OF (cb-dmov.NroDoc ) THEN DO :
       X-Imp1 = 0.
       X-Imp2 = 0.
       FIND cb-cmov WHERE cb-cmov.codcia   = cb-dmov.codcia   AND
                          cb-cmov.periodo  = cb-dmov.periodo  AND
                          cb-cmov.nromes   = cb-dmov.nromes   AND
                          cb-cmov.codope   = cb-dmov.codope   AND
                          cb-cmov.nroast   = cb-dmov.nroast
                          NO-LOCK NO-ERROR.
    END.
                          
    IF CB-DMOV.IMPMN2 = 0 AND CB-DMOV.IMPMN1 <> 0 THEN NEXT.
    IF CB-DMOV.IMPMN1 = 0 AND CB-DMOV.IMPMN2 <> 0 THEN NEXT.
    
    IF cb-dmov.TpoMov THEN DO :
       x-Imp1 = x-Imp1 + cb-dmov.Impmn1. 
       x-Imp2 = x-Imp2 + cb-dmov.Impmn2. 
    END.   
    ELSE DO :
       x-Imp1 = x-Imp1 - cb-dmov.Impmn1. 
       x-Imp2 = x-Imp2 - cb-dmov.Impmn2.
    END.   
                      
    IF LAST-OF(cb-dmov.NroDoc ) THEN DO :
       CREATE bcoconci.
       ASSIGN bcoconci.codcia  = s-codcia
              bcoconci.periodo = s-periodo
              bcoconci.nromes  = s-NroMes
              bcoconci.codcta  = cb-ctas.codcta
              bcoconci.Fchref  = cb-dmov.Fchdoc
              bcoconci.Glodoc  = cb-dmov.Glodoc
              bcoconci.Nroref  = cb-dmov.Nrodoc              
              bcoconci.codope  = cb-dmov.codope
              bcoconci.nroast  = cb-dmov.nroast
              bcoconci.glodoc  = cb-dmov.glodoc
              bcoconci.n-recid = RECID(cb-dmov)
              bcoconci.mesori  = s-NroMes
              bcoconci.sdoini  = x-saldoi
              bcoconci.flgori  = "L".
              
            
       IF cb-dmov.fchdoc =  ? THEN bcoconci.fchref = cb-cmov.fchast.
           
       CASE CB-CTAS.CODMON :
            WHEN 1 THEN DO : 
                 bcoconci.Importe = ABS(x-Imp1). 
                 bcoconci.TpoMov  = (x-Imp1 > 0).
            END.     
                 
            WHEN 2 THEN DO :
                 bcoconci.Importe = ABS(x-Imp2). 
                 bcoconci.TpoMov  = (x-Imp2 > 0).
            END.     
            OTHERWISE 
            IF cb-dmov.codmon = 2 THEN bcoconci.Importe = ABS(x-Imp2).
                                  ELSE bcoconci.Importe = ABS(x-Imp1).
     
       END CASE.     


   MESSAGE bcoconci.codcia 
           bcoconci.periodo 
           bcoconci.nromes 
           bcoconci.importe
           x-imp1
           x-imp2.        


    END.
END.
pto = SESSION:SET-WAIT("").


/* PROCESO DE CONCILIACION BANCARIA POR NRO.DOCUMENTO*/
DISPLAY "CONCILIANDO POR NRO DE DOCUMENTO" WITH FRAME F-mensaje VIEW-AS
DIALOG-BOX.
pto = SESSION:SET-WAIT("GENERAL").
FOR EACH bcoconci WHERE bcoconci.codcia = s-codcia AND
    bcoconci.periodo = s-periodo AND
    bcoconci.nromes  = s-NroMes AND
    bcoconci.codcta  = cb-ctas.codcta AND
    bcoconci.flgest  = ""
    BREAK BY bcoconci.nroref:
    IF FIRST-OF (bcoconci.nroref) THEN x-importe = 0.
    IF bcoconci.tpomov THEN
        x-importe = x-importe - bcoconci.importe.
    ELSE
        x-importe = x-importe + bcoconci.importe.
    IF LAST-OF (bcoconci.nroref) THEN DO:
        /* CONCILIACION OK  */
        IF ABS(x-importe) < 0.01 THEN
            FOR EACH bcoaux WHERE bcoaux.codcia = s-codcia AND
                                bcoaux.periodo = s-periodo AND
                                bcoaux.nromes  = s-NroMes AND
                                bcoaux.codcta  = cb-ctas.codcta AND
                                bcoaux.nroref  = bcoconci.nroref EXCLUSIVE-LOCK:
                ASSIGN bcoaux.FlgEst = "C"
                       bcoaux.MesCon = s-NroMes.
            END.
    END.
END.
pto = SESSION:SET-WAIT("").

RUN calcula.

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
  DISPLAY x-bancos x-libros x-saldoi x-total x-concil x-contable 
      WITH FRAME F-maestro IN WINDOW W-maestro.
  IF AVAILABLE cb-ctas THEN 
    DISPLAY cb-ctas.Codcta cb-ctas.Nomcta 
      WITH FRAME F-maestro IN WINDOW W-maestro.
  ENABLE R-maestro1 R-maestro2 BRW-credito cb-ctas.Codcta cb-ctas.Nomcta 
         x-bancos x-libros x-concil x-contable 
      WITH FRAME F-maestro IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-maestro}
  ENABLE R-modify R-exit R-consulta R-navigaate R-query B-query B-add B-Imprime 
         B-first B-prev B-next B-last B-browse B-exit 
      WITH FRAME F-ctrl-frame IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-ctrl-frame}
  ENABLE R-navigaate-4 B-ok-3 B-Cancel-3 
      WITH FRAME F-search IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-search}
  VIEW W-maestro.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE noconcil W-maestro 
PROCEDURE noconcil :
/* -----------------------------------------------------------
  Purpose: Impresion de no conciliados
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/

    DEFINE VARIABLE x-glodoc   AS CHARACTER FORMAT "X(25)".
    DEFINE VARIABLE x-inicial  AS DECIMAL FORMAT "(ZZZZZ,ZZ9.99)" INITIAL 0.
    DEFINE VARIABLE x-final    AS DECIMAL FORMAT "(ZZZZZ,ZZ9.99)" INITIAL 0.
    DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "(ZZZZZ,ZZ9.99)".
    DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "(ZZZZZ,ZZ9.99)".
    DEFINE VARIABLE x-chqpen   AS DECIMAL FORMAT "(ZZZZZ,ZZ9.99)".
    DEFINE VARIABLE x-chqcob   AS DECIMAL FORMAT "(ZZZZZ,ZZ9.99)".
    DEFINE VARIABLE x-fecha    AS DATE FORMAT "99/99/99" INITIAL TODAY.
    DEFINE VARIABLE x-con-reg  AS INTEGER.
    DEFINE VARIABLE x-cuenta   LIKE integral.cb-ctas.codcta.
    DEFINE VARIABLE x-nomcta   AS CHARACTER FORMAT "X(50)".
    DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)".
    DEFINE VARIABLE x-Encontro AS LOGICAL.
    x-Encontro = FALSE.
    RUN cbd/cbd_imp.p ( INPUT s-codcia,
                        integral.cb-ctas.codcta:SCREEN-VALUE IN FRAME F-maestro,
                        "",s-periodo,(s-NroMes - 1),x-codmon,
                OUTPUT impca1,
                OUTPUT impca2,
                OUTPUT impca3,
                OUTPUT impca4,
                OUTPUT impca5,
                OUTPUT impca6 ).
                
    xsdomesant = impca6.

    RUN bin/_mes.p ( INPUT s-NroMes , 1,  OUTPUT pinta-mes ).
    pinta-mes = pinta-mes + " DE " + STRING( s-periodo , "9999" ).
    x-inicial = x-contable.

    OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 59.

    DEFINE FRAME f-cab
        integral.bcoconci.Fchref COLUMN-LABEL "Fecha"
        integral.bcoconci.Nroref COLUMN-LABEL "Nro!Documento"
        integral.bcoconci.Flgori COLUMN-LABEL "O"       FORMAT "X(1)"
        integral.bcoconci.CodOpe COLUMN-LABEL "Ope"     FORMAT "X(3)"
        integral.bcoconci.MesOri COLUMN-LABEL "Mes"     FORMAT "99"
        integral.bcoconci.NroAst COLUMN-LABEL "Cmpbte." FORMAT "X(6)"
        integral.bcoconci.Glodoc COLUMN-LABEL "Detalle" FORMAT "X(30)"
        x-debe                   COLUMN-LABEL "Cargos"  FORMAT "(Z,ZZZ,ZZ9.99)"
        x-haber                  COLUMN-LABEL "Abonos"  FORMAT "(Z,ZZZ,ZZ9.99)"
      HEADER
        empresas.nomcia "FECHA  : " AT 75 x-fecha AT 85 SKIP
        "HORA   : " AT 75 STRING(TIME,"hh:mm:ss") AT 85 SKIP
        "BANCO : " AT 20 x-cuenta FORMAT "X(8)" x-nomcta FORMAT "X(25)" SKIP
        "NO CONCILIADOS " AT 30 pinta-mes AT 45 SKIP(1)
        /*"(+) SALDO LIBRO BANCOS : " TO 75 x-inicial AT 81 SKIP*/
        FILL("-",96) FORMAT "X(96)"
    WITH WIDTH 132 NO-BOX STREAM-IO DOWN.

    FIND integral.cb-ctas WHERE integral.cb-ctas.codcia = y-codcia AND
        integral.cb-ctas.codcta = integral.cb-ctas.codcta:SCREEN-VALUE IN
        FRAME F-maestro NO-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.cb-ctas THEN DO:
        BELL.
        MESSAGE "Cuenta no registrada" VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    x-codmon = integral.cb-ctas.codmon.
    x-cuenta = integral.cb-ctas.codcta.
    x-nomcta = integral.cb-ctas.nomcta.
    IF integral.cb-ctas.codmon = 1 THEN
        x-nomcta = x-nomcta + " (S/.) ".
    ELSE
        x-nomcta = x-nomcta + " (US$) ".

    PUT STREAM report CONTROL "~033x" NULL "~017~033P".
    
    FOR EACH bcoconci NO-LOCK WHERE bcoconci.codcia = s-codcia AND
       
        bcoconci.periodo = s-periodo AND
        bcoconci.nromes  = s-NroMes AND
        bcoconci.Flgest  = ""    AND
        bcoconci.codcta  = x-cuenta
        BREAK BY bcoconci.codcta
              BY bcoconci.fchref ON ERROR UNDO, LEAVE:
        IF integral.bcoconci.TpoMov THEN DO:
            x-debe   = 0.
            x-haber  = bcoconci.Importe.
        END.
        ELSE DO:
            x-debe  = bcoconci.Importe.
            x-haber = 0.
        END.
        IF NOT (x-haber = 0 AND x-debe = 0) AND x-debe <> ? AND x-haber <> ?
        THEN DO:
            ACCUMULATE x-debe  (SUB-TOTAL BY bcoconci.codcta).
            ACCUMULATE x-haber (SUB-TOTAL BY bcoconci.codcta).            
            DISPLAY STREAM report bcoconci.fchref
                                  bcoconci.nroref
                                  bcoconci.flgori
                                  bcoconci.Codope
                                  bcoconci.MesOri
                                  bcoconci.Nroast
                                  bcoconci.glodoc
                                  x-debe   WHEN (x-debe  <> 0)
                                  x-haber  WHEN (x-haber <> 0)
                            WITH FRAME f-cab.
        END.
        IF LAST-OF (bcoconci.codcta)
        THEN DO:
            x-Encontro = TRUE.
            PUT STREAM report FILL("-",96) FORMAT "X(96)" SKIP.
            DOWN STREAM report WITH FRAME f-cab.
            DISPLAY STREAM report
                    ACCUM SUB-TOTAL BY (bcoconci.codcta) x-debe  @ x-debe
                    ACCUM SUB-TOTAL BY (bcoconci.codcta) x-haber @ x-haber
                WITH FRAME f-cab.
            X-chqpen = ACCUM SUB-TOTAL BY (bcoconci.codcta) x-haber. /* cheques no cobrados */
            X-chqcob = ACCUM SUB-TOTAL BY (bcoconci.codcta) x-debe. /* cheques cobrados */
        END.
    END.
    x-final = x-inicial +  x-chqpen - x-chqcob.

    IF x-encontro = FALSE THEN DO :
       PUT STREAM report empresas.nomcia "FECHA  : " AT 75 x-fecha AT 85. 
       PUT STREAM report "HORA   : " AT 75 STRING(TIME,"hh:mm:ss") AT 85. 
       PUT STREAM report "BANCO : " AT 20 x-cuenta FORMAT "X(5)" x-nomcta FORMAT "X(25)".
       PUT STREAM report "CONCILIADOS " AT 30 pinta-mes AT 45.
       PUT STREAM report FILL("-",96) FORMAT "X(96)" AT 2.
    END.
      
    PUT STREAM report "SALDO ANT LIBROS : " TO 20 xsdomesant AT 21
                      "SALDO LIBROS     : " TO 75 x-inicial  AT 83.
                      
    PUT STREAM report "CARGOS MES       : " TO 20 xcarmesact AT 21
                      "(+) CHQ/PEND BCO : " TO 75 x-chqpen /*xconbcocar*/ AT 83.
    PUT STREAM report "ABONOS MES       : " TO 20 xabomesact AT 21
                      "(-) ABONOS BCO   : " TO 75 /* xconbcoabo AT 83 */ .
    PUT STREAM report FILL("-",13) FORMAT "X(13)" AT 21
                      "(+) DEP/PEND LIB : " TO 75 /* xconlibabo AT 83 */ .
                      
    PUT STREAM report "SALDO LIBROS     : " TO 20 x-inicial  AT 21
                      "(-) CARG/PEND LIB: " TO 75 x-chqcob /*xconlibcar*/  AT 83.
    PUT STREAM report FILL("=",13) FORMAT "X(13)" AT 83.
    PUT STREAM report "(=) SALDO BANCOS : " TO 65 x-final    AT 83.

    /* -----------------------------------------------------------
    PUT STREAM report "SALDO LIBROS     : " TO 65 x-inicial  AT 83.
    PUT STREAM report "(+) CHQ/PEND BCO : " TO 65 xconbcocar AT 83.
    PUT STREAM report "(-) ABONOS BCO   : " TO 65 xconbcoabo AT 83.
    PUT STREAM report "(+) DEP/PEND LIB : " TO 65 xconlibabo AT 83.
    PUT STREAM report "(-) CARG/PEND LIB: " TO 65 xconlibcar AT 83.
    PUT STREAM report FILL("=",13) FORMAT "X(13)" AT 83.
    PUT STREAM report "(=) SALDO BANCOS : " TO 65 x-final    AT 83.
    ------------------------------------------------------------ */

    OUTPUT STREAM report CLOSE.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pintado W-maestro 
PROCEDURE pintado :
DISPLAY {&FIELDS-IN-QUERY-F-maestro} WITH FRAME F-maestro.
    {&OPEN-BROWSERS-IN-QUERY-F-maestro}
RUN calcula.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


