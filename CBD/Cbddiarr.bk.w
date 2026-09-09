&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-maestro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-maestro 
/* Local Variable Definitions ---                                       */
DEFINE VARIABLE x-NroAst    AS INTEGER NO-UNDO.
DEFINE VARIABLE RECID-cab   AS RECID NO-UNDO.
DEFINE VARIABLE RECID-stack AS RECID NO-UNDO.
DEFINE VARIABLE RECID-tmp   AS RECID NO-UNDO.
DEFINE VARIABLE RegAct      AS RECID NO-UNDO.
DEFINE VARIABLE x-GloDoc    AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-CodMon    AS INTEGER NO-UNDO.
DEFINE VARIABLE LAST-CodMon AS INTEGER NO-UNDO INITIAL 1.
DEFINE VARIABLE pto AS LOGICAL.
DEFINE VARIABLE Continuar AS LOGICAL.
DEFINE VARIABLE MaxError    AS DECIMAL INIT 0.005.
DEFINE VARIABLE s-nomcia    AS CHAR.
pto = SESSION:SET-WAIT-STATE("").

DEFINE VARIABLE  x-NroItm  LIKE integral.cb-dmov.NroItm.

DEFINE {&NEW} SHARED VARIABLE  s-codcia AS INTEGER   INITIAL 999.
DEFINE {&NEW} SHARED VARIABLE  s-aplic-id AS CHARACTER INITIAL "CBD".
DEFINE VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE VARIABLE cb-codcia AS INTEGER INITIAL 0.

FIND Empresas WHERE Empresas.CodCia = s-codcia.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.
IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.

FIND FIRST cb-cfga WHERE cb-cfga.CodCia = cb-codcia AND cb-cfga.CodCfg = 1
      NO-LOCK  NO-ERROR.


DEFINE NEW SHARED VARIABLE x-codope            LIKE cb-oper.CodOpe.
DEFINE NEW SHARED VARIABLE x-Nomope            LIKE cb-oper.NomOpe.
DEFINE NEW SHARED VARIABLE x-selope            AS LOGICAL.
DEFINE {&NEW} SHARED VARIABLE s-periodo            AS INTEGER INITIAL 1996.
DEFINE {&NEW} SHARED VARIABLE s-NroMes            AS INTEGER INITIAL 7.
DEFINE {&NEW} SHARED VARIABLE s-user-id         AS CHARACTER INITIAL "MASTER".
DEFINE {&NEW} SHARED VARIABLE S-ADMIN           AS LOGICAL   INITIAL NO.
DEFINE {&NEW} SHARED VARIABLE cb-niveles   AS CHARACTER INITIAL "2,3,5".
DEFINE {&NEW} SHARED VARIABLE x-MaxNivel       AS INTEGER INITIAL 5.
DEFINE BUFFER DETALLE FOR cb-dmov.
DEFINE BUFFER CABEZA  FOR cb-cmov.
DEFINE VARIABLE x-Llave AS CHARACTER INITIAL "".
DEFINE VARIABLE i       AS INTEGER.
DEFINE VARIABLE s-NroMesCie AS LOGICAL INITIAL YES.
FIND cb-peri WHERE  cb-peri.CodCia     = s-codcia  AND
                     cb-peri.Periodo    = s-periodo NO-LOCK.
IF AVAILABLE cb-peri
THEN s-NroMesCie = cb-peri.MesCie[s-NroMes + 1].
DEFINE VARIABLE x-ImpMn1 AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-ImpMn2 AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-ImpMn3 AS DECIMAL NO-UNDO.
DEFINE STREAM report.

/* Seleccionando la Operaci¢n a Trabajar */
RUN cbd/s-opera.w  ( cb-codcia, OUTPUT RECID-stack ).
IF LOOKUP(LAST-EVENT:FUNCTION, "ENDKEY,ERROR,END-ERROR") <> 0
THEN RETURN.
FIND cb-oper WHERE RECID( cb-oper ) = RECID-stack NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-oper
THEN RETURN.
x-NomOpe = integral.cb-oper.Nomope.
x-codope = integral.cb-oper.codope.


DEF VAR X-D1 AS DECIMAL.
DEF VAR X-D2 AS DECIMAL.
DEF VAR X-H1 AS DECIMAL.
DEF VAR X-H2 AS DECIMAL.

DEFINE  TEMP-TABLE  cbd-stack
 FIELD clfaux  LIKE  cb-dmov.clfaux
 FIELD Codaux  LIKE  cb-dmov.Codaux
 FIELD CodCia  LIKE  cb-dmov.CodCia
 FIELD Codcta  LIKE  cb-dmov.Codcta
 FIELD CodDiv  LIKE  cb-dmov.CodDiv
 FIELD Coddoc  LIKE  cb-dmov.Coddoc 
 FIELD Codmon  LIKE  cb-dmov.Codmon
 FIELD Codope  LIKE  cb-dmov.Codope
 FIELD Ctrcta  LIKE  cb-dmov.Ctrcta
 FIELD Fchdoc  LIKE  cb-dmov.Fchdoc
 FIELD FchVto  LIKE  cb-dmov.FchVto
 FIELD ImpMn1  LIKE  cb-dmov.ImpMn1
 FIELD ImpMn2  LIKE  cb-dmov.ImpMn2
 FIELD ImpMn3  LIKE  cb-dmov.ImpMn3
 FIELD Nroast  LIKE  cb-dmov.Nroast
 FIELD Nrodoc  LIKE  cb-dmov.Nrodoc
 FIELD NroMes  LIKE  cb-dmov.NroMes
 FIELD Periodo LIKE  cb-dmov.Periodo
 FIELD recid-mov        AS    recid
 FIELD Tpocmb  LIKE  cb-dmov.Tpocmb
 FIELD TpoItm  LIKE  cb-dmov.TpoItm
 FIELD TpoMov  LIKE  cb-dmov.TpoMov.


/* C A M B I O S   E N    L O S   P R E - P R O C E S A D O R E S */

/* Solo muestra los registros que cumplan con la condici¢n : */


&Scoped-define RECORD-SCOPE ( cb-cmov.CodCia = s-codcia ~
AND cb-cmov.Periodo = s-periodo ~
AND cb-cmov.NroMes  = s-NroMes ~
AND cb-cmov.CodOpe  = x-CodOpe )

/* Como Buscar un Registro en la Tabla ( Para Crear, modificar, anular etc.) */
&Scoped-define SEARCH-KEY cb-cmov.NroAst  = cb-cmov.NroAst:SCREEN-VALUE IN FRAME F-maestro 

/* Campos Ocultos que deben ser asignados en cada modificaci¢n */
&Scoped-define ASSIGN-ADD cb-cmov.CodMon  = x-CodMon
                      
/* Campos que no pueden ser modificados */
&Scoped-define NO-MODIFY cb-cmov.NroAst

/* Programa donde relaizara la Consulta */
&Scoped-define q-modelo  cbd/q-asto.w ( OUTPUT RECID-stack )

/* Campos por los cuales se puede hacer Busquedas */
&Scoped-define Query-Field cb-cmov.NroAst

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-add
&Scoped-define BROWSE-NAME BRW-DETALLE

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-dmov cb-cmov

/* Definitions for BROWSE BRW-DETALLE                                   */
&Scoped-define FIELDS-IN-QUERY-BRW-DETALLE cb-dmov.Nroitm cb-dmov.CodDiv ~
cb-dmov.Codcta cb-dmov.Clfaux cb-dmov.Codaux cb-dmov.Glodoc cb-dmov.TpoMov ~
cb-dmov.ImpMn1 cb-dmov.ImpMn2 cb-dmov.Tpocmb cb-dmov.Codmon cb-dmov.cco ~
cb-dmov.Coddoc cb-dmov.Nrodoc cb-dmov.Nroref cb-dmov.Fchdoc cb-dmov.Fchvto ~
cb-dmov.tm cb-dmov.Nroruc cb-dmov.TpoItm cb-dmov.flgact cb-dmov.Relacion ~
cb-dmov.C-Fcaja 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BRW-DETALLE 
&Scoped-define FIELD-PAIRS-IN-QUERY-BRW-DETALLE
&Scoped-define OPEN-QUERY-BRW-DETALLE OPEN QUERY BRW-DETALLE FOR EACH cb-dmov WHERE TRUE /* Join to cb-cmov incomplete */ ~
      AND cb-dmov.CodCia = s-codcia ~
 AND cb-dmov.Periodo = s-periodo ~
 AND cb-dmov.NroMes = s-NroMes ~
 AND cb-dmov.Codope = x-CodOpe ~
 AND cb-dmov.Nroast = cb-cmov.Nroast:SCREEN-VALUE NO-LOCK ~
    BY cb-dmov.Nroitm.
&Scoped-define TABLES-IN-QUERY-BRW-DETALLE cb-dmov
&Scoped-define FIRST-TABLE-IN-QUERY-BRW-DETALLE cb-dmov


/* Definitions for FRAME F-maestro                                      */
&Scoped-define FIELDS-IN-QUERY-F-maestro cb-cmov.NroAst cb-cmov.NroVou ~
cb-cmov.FchAst cb-cmov.TpoCmb cb-cmov.CodDiv cb-cmov.C-FCaja cb-cmov.NotAst ~
cb-cmov.GloAst cb-cmov.TotItm cb-cmov.DbeMn1 cb-cmov.DbeMn2 cb-cmov.NroTra ~
cb-cmov.HbeMn1 cb-cmov.HbeMn2 
&Scoped-define ENABLED-FIELDS-IN-QUERY-F-maestro cb-cmov.NroTra 
&Scoped-define ENABLED-TABLES-IN-QUERY-F-maestro cb-cmov
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-F-maestro cb-cmov
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-maestro ~
    ~{&OPEN-QUERY-BRW-DETALLE}
&Scoped-define OPEN-QUERY-F-maestro OPEN QUERY F-maestro FOR EACH cb-cmov SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-F-maestro cb-cmov
&Scoped-define FIRST-TABLE-IN-QUERY-F-maestro cb-cmov


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS R-navigaate-2 B-ok B-Cancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-maestro AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-B-Imprimir 
       MENU-ITEM m_Todas_las_Cuentas LABEL "Todas las Cuentas"
       MENU-ITEM m_Omitir_Automticas LABEL "Omitir Autom ticas"
       MENU-ITEM m_Todas_las_cuentas_Ordenado_ LABEL "Todas las cuentas Ordenado por Cuenta"
       MENU-ITEM m_Omitir_Automticas_Ordenado_ LABEL "Omitir Autom ticas Ordenado por Cuenta"
       MENU-ITEM m_Todas_Las_Cuentas_Ordenado_2 LABEL "Todas Las Cuentas Ordenado por D/H"
       MENU-ITEM m_Omitir_Automticas_Ordernado LABEL "Omitir Autom ticas Ordernado por D/H".


/* Definitions of the field level widgets                               */
DEFINE BUTTON B-Cancel AUTO-END-KEY 
     LABEL "&Cancelar":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE BUTTON B-ok AUTO-GO 
     LABEL "&Aceptar":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE RECTANGLE R-navigaate-2
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 88 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE BUTTON B-add 
     LABEL "&Crear":L 
     SIZE 8 BY 1
     FONT 4.

DEFINE BUTTON B-browse 
     IMAGE-UP FILE "IMG/pvbrow":U
     IMAGE-DOWN FILE "IMG/pvbrowd":U
     IMAGE-INSENSITIVE FILE "IMG/pvbrowx":U
     LABEL "&Consulta" 
     SIZE 6 BY 1.58.

DEFINE BUTTON B-delete 
     LABEL "&Eliminar":L 
     SIZE 8 BY 1
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
     SIZE 4.57 BY 1
     FONT 4.

DEFINE BUTTON B-Imprimir 
     LABEL "&Imprimir" 
     SIZE 8 BY 1.

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
     SIZE 4.57 BY 1
     FONT 4.

DEFINE BUTTON B-prev 
     IMAGE-UP FILE "IMG/pvback":U
     IMAGE-DOWN FILE "IMG/pvbackd":U
     IMAGE-INSENSITIVE FILE "IMG/pvbackx":U
     LABEL "<":L 
     SIZE 4.57 BY 1
     FONT 4.

DEFINE BUTTON B-query 
     LABEL "&Buscar":L 
     SIZE 8 BY 1
     FONT 4.

DEFINE BUTTON B-update 
     LABEL "&Modificar":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE BUTTON BUTTON-2 
     LABEL "Copiar" 
     SIZE 8 BY 1.

DEFINE RECTANGLE R-modify
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 88 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE BUTTON b-d-add 
     LABEL "Agregar" 
     SIZE 9 BY .85.

DEFINE BUTTON b-d-delete 
     LABEL "Eliminar" 
     SIZE 9 BY .85.

DEFINE BUTTON B-D-SUMA 
     LABEL "&Sumar" 
     SIZE 9 BY .85.

DEFINE BUTTON b-d-update 
     LABEL "Actualizar" 
     SIZE 9 BY .85.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON BUTTON-3 
     LABEL "Copiar" 
     SIZE 9 BY .85.

DEFINE BUTTON BUTTON-4 
     LABEL "Operación" 
     SIZE 9 BY .85.

DEFINE VARIABLE Moneda AS CHARACTER FORMAT "X(256)":U INITIAL "Soles" 
     LABEL "Moneda" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Soles","Dólares" 
     SIZE 14 BY 1 NO-UNDO.

DEFINE BUTTON B-Cancel-3 AUTO-END-KEY 
     LABEL "&Cancelar":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE BUTTON B-ok-3 AUTO-GO 
     LABEL "&Aceptar":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE RECTANGLE R-navigaate-4
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 87 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE BUTTON B-Cancel-2 AUTO-END-KEY 
     LABEL "&Cancelar":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE BUTTON B-ok-2 AUTO-GO 
     LABEL "&Aceptar":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE RECTANGLE R-navigaate-3
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 88 BY 2
     BGCOLOR 8 FGCOLOR 15 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BRW-DETALLE FOR 
      cb-dmov SCROLLING.

DEFINE QUERY F-maestro FOR 
      cb-cmov SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BRW-DETALLE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BRW-DETALLE W-maestro _STRUCTURED
  QUERY BRW-DETALLE NO-LOCK DISPLAY
      cb-dmov.Nroitm FORMAT "ZZZ9"
      cb-dmov.CodDiv FORMAT "x(6)"
      cb-dmov.Codcta
      cb-dmov.Clfaux FORMAT "X(5)"
      cb-dmov.Codaux COLUMN-LABEL "Auxiliar" FORMAT "x(10)"
      cb-dmov.Glodoc
      cb-dmov.TpoMov
      cb-dmov.ImpMn1
      cb-dmov.ImpMn2
      cb-dmov.Tpocmb
      cb-dmov.Codmon
      cb-dmov.cco
      cb-dmov.Coddoc COLUMN-LABEL "Doc"
      cb-dmov.Nrodoc
      cb-dmov.Nroref
      cb-dmov.Fchdoc
      cb-dmov.Fchvto
      cb-dmov.tm FORMAT "99"
      cb-dmov.Nroruc
      cb-dmov.TpoItm
      cb-dmov.flgact
      cb-dmov.Relacion
      cb-dmov.C-Fcaja
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 76.57 BY 7.77
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-search
     B-ok-3 AT ROW 1.54 COL 24.29
     B-Cancel-3 AT ROW 1.54 COL 57.57
     R-navigaate-4 AT ROW 1 COL 1
    WITH 1 DOWN OVERLAY NO-HELP 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 14.62
         SIZE 88.29 BY 2.08
         BGCOLOR 8 FGCOLOR 0 FONT 4.

DEFINE FRAME F-update
     B-ok-2 AT ROW 1.5 COL 24.29
     B-Cancel-2 AT ROW 1.5 COL 57.57
     R-navigaate-3 AT ROW 1 COL 1
    WITH 1 DOWN OVERLAY NO-HELP 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 14.62
         SIZE 88.29 BY 2.08
         BGCOLOR 8 FGCOLOR 0 FONT 4.

DEFINE FRAME F-add
     B-ok AT ROW 1.5 COL 24.29
     B-Cancel AT ROW 1.5 COL 57.57
     R-navigaate-2 AT ROW 1 COL 1
    WITH 1 DOWN OVERLAY NO-HELP 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 14.62
         SIZE 88.29 BY 2.08
         BGCOLOR 8 FGCOLOR 0 FONT 4.

DEFINE FRAME F-maestro
     cb-cmov.NroAst AT ROW 1.27 COL 6 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     Moneda AT ROW 1.27 COL 31 COLON-ALIGNED
     cb-cmov.NroVou AT ROW 1.27 COL 76 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     cb-cmov.FchAst AT ROW 2.08 COL 6 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     cb-cmov.TpoCmb AT ROW 2.08 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     cb-cmov.CodDiv AT ROW 2.08 COL 56 COLON-ALIGNED
          LABEL "División" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 8 BY .69
     cb-cmov.C-FCaja AT ROW 2.08 COL 76 COLON-ALIGNED
          LABEL "Con. Flj. Caja"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     cb-cmov.NotAst AT ROW 2.96 COL 6 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 58 BY .69
     cb-cmov.GloAst AT ROW 3.69 COL 8 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 312 SCROLLBAR-VERTICAL
          SIZE 58 BY 1.12
     cb-cmov.TotItm AT ROW 3.69 COL 79 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .69
     BRW-DETALLE AT ROW 4.92 COL 1.43
     b-d-add AT ROW 5.77 COL 79.72
     b-d-update AT ROW 6.77 COL 79.72
     b-d-delete AT ROW 7.77 COL 79.72
     BUTTON-3 AT ROW 8.77 COL 79.72
     B-D-SUMA AT ROW 9.85 COL 79.72 HELP
          "Re-Calcular los acumulados del asiento"
     BUTTON-4 AT ROW 10.88 COL 79.72
     B-impresoras AT ROW 11.88 COL 80.86
     cb-cmov.DbeMn1 AT ROW 12.85 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .69
          FONT 0
     cb-cmov.DbeMn2 AT ROW 12.85 COL 49.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .69
          FONT 0
     cb-cmov.NroTra AT ROW 13.12 COL 75 COLON-ALIGNED
          LABEL "Traslado"
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     cb-cmov.HbeMn1 AT ROW 13.62 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .69
          FONT 0
     cb-cmov.HbeMn2 AT ROW 13.62 COL 49.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .69
          FONT 0
    WITH 1 DOWN NO-BOX OVERLAY NO-HELP 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 13.54
         FONT 4.

DEFINE FRAME F-ctrl-frame
     B-query AT ROW 1.54 COL 2
     B-add AT ROW 1.54 COL 10
     B-update AT ROW 1.54 COL 18
     B-delete AT ROW 1.54 COL 27
     BUTTON-2 AT ROW 1.54 COL 35
     B-Imprimir AT ROW 1.54 COL 43
     B-first AT ROW 1.54 COL 52
     B-prev AT ROW 1.54 COL 57
     B-next AT ROW 1.54 COL 62
     B-last AT ROW 1.54 COL 67
     B-browse AT ROW 1.27 COL 72
     B-exit AT ROW 1.54 COL 80
     R-modify AT ROW 1 COL 1
    WITH 1 DOWN OVERLAY NO-HELP 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 14.58
         SIZE 88.29 BY 2.12
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
         TITLE              = "Diario General"
         COLUMN             = 13.57
         ROW                = 2.85
         HEIGHT             = 15.62
         WIDTH              = 88.72
         MAX-HEIGHT         = 17.08
         MAX-WIDTH          = 91.43
         VIRTUAL-HEIGHT     = 17.08
         VIRTUAL-WIDTH      = 91.43
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
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
/* SETTINGS FOR FRAME F-add
   NOT-VISIBLE UNDERLINE                                                */
ASSIGN 
       FRAME F-add:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON B-Cancel IN FRAME F-add
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-ok IN FRAME F-add
   NO-DISPLAY                                                           */
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
ASSIGN 
       B-Imprimir:POPUP-MENU IN FRAME F-ctrl-frame       = MENU POPUP-MENU-B-Imprimir:HANDLE.

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
   UNDERLINE L-To-R                                                     */
/* BROWSE-TAB BRW-DETALLE TotItm F-maestro */
/* SETTINGS FOR BUTTON b-d-add IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b-d-delete IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON B-D-SUMA IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b-d-update IN FRAME F-maestro
   NO-ENABLE                                                            */
ASSIGN 
       BRW-DETALLE:NUM-LOCKED-COLUMNS IN FRAME F-maestro = 2.

/* SETTINGS FOR BUTTON BUTTON-3 IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.C-FCaja IN FRAME F-maestro
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN cb-cmov.CodDiv IN FRAME F-maestro
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN cb-cmov.DbeMn1 IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.DbeMn2 IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.FchAst IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR cb-cmov.GloAst IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.HbeMn1 IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.HbeMn2 IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX Moneda IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.NotAst IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.NroAst IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.NroTra IN FRAME F-maestro
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.NroVou IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.TotItm IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.TpoCmb IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME F-search
   NOT-VISIBLE UNDERLINE                                                */
ASSIGN 
       FRAME F-search:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON B-Cancel-3 IN FRAME F-search
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-ok-3 IN FRAME F-search
   NO-DISPLAY                                                           */
/* SETTINGS FOR FRAME F-update
   NOT-VISIBLE UNDERLINE                                                */
ASSIGN 
       FRAME F-update:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON B-Cancel-2 IN FRAME F-update
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON B-ok-2 IN FRAME F-update
   NO-DISPLAY                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-maestro)
THEN W-maestro:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BRW-DETALLE
/* Query rebuild information for BROWSE BRW-DETALLE
     _TblList          = "integral.cb-dmov WHERE integral.cb-cmov ..."
     _Options          = "NO-LOCK"
     _OrdList          = "integral.cb-dmov.Nroitm|yes"
     _Where[1]         = "integral.cb-dmov.CodCia = s-codcia
 AND integral.cb-dmov.Periodo = s-periodo
 AND integral.cb-dmov.NroMes = s-NroMes
 AND integral.cb-dmov.Codope = x-CodOpe
 AND integral.cb-dmov.Nroast = integral.cb-cmov.Nroast:SCREEN-VALUE"
     _FldNameList[1]   > integral.cb-dmov.Nroitm
"cb-dmov.Nroitm" ? "ZZZ9" "integer" ? ? ? ? ? ? no ?
     _FldNameList[2]   > integral.cb-dmov.CodDiv
"cb-dmov.CodDiv" ? "x(6)" "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   = integral.cb-dmov.Codcta
     _FldNameList[4]   > integral.cb-dmov.Clfaux
"cb-dmov.Clfaux" ? "X(5)" "character" ? ? ? ? ? ? no ?
     _FldNameList[5]   > integral.cb-dmov.Codaux
"cb-dmov.Codaux" "Auxiliar" "x(10)" "character" ? ? ? ? ? ? no ?
     _FldNameList[6]   > integral.cb-dmov.Glodoc
"cb-dmov.Glodoc" ? ? "character" ? ? ? ? ? ? no ""
     _FldNameList[7]   = integral.cb-dmov.TpoMov
     _FldNameList[8]   = integral.cb-dmov.ImpMn1
     _FldNameList[9]   = integral.cb-dmov.ImpMn2
     _FldNameList[10]   = integral.cb-dmov.Tpocmb
     _FldNameList[11]   = integral.cb-dmov.Codmon
     _FldNameList[12]   = integral.cb-dmov.cco
     _FldNameList[13]   > integral.cb-dmov.Coddoc
"cb-dmov.Coddoc" "Doc" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[14]   = integral.cb-dmov.Nrodoc
     _FldNameList[15]   = integral.cb-dmov.Nroref
     _FldNameList[16]   = integral.cb-dmov.Fchdoc
     _FldNameList[17]   = integral.cb-dmov.Fchvto
     _FldNameList[18]   > integral.cb-dmov.tm
"cb-dmov.tm" ? "99" "integer" ? ? ? ? ? ? no ?
     _FldNameList[19]   = integral.cb-dmov.Nroruc
     _FldNameList[20]   = integral.cb-dmov.TpoItm
     _FldNameList[21]   = integral.cb-dmov.flgact
     _FldNameList[22]   = integral.cb-dmov.Relacion
     _FldNameList[23]   = integral.cb-dmov.C-Fcaja
     _Query            is OPENED
*/  /* BROWSE BRW-DETALLE */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-maestro
/* Query rebuild information for FRAME F-maestro
     _TblList          = "integral.cb-cmov"
     _Query            is OPENED
*/  /* FRAME F-maestro */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME F-maestro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-maestro W-maestro
ON F3 OF FRAME F-maestro
DO:
    message "Presione F3" view-as alert-box error.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-ctrl-frame
&Scoped-define SELF-NAME B-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-add W-maestro
ON CHOOSE OF B-add IN FRAME F-ctrl-frame /* Crear */
DO:
    IF s-NroMesCie
    THEN DO:
        MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    ASSIGN 
        FRAME F-ctrl-frame:VISIBLE = FALSE
        FRAME F-add:VISIBLE        = TRUE.
    DO WITH FRAME F-MAESTRO :
       BUTTON-4:SENSITIVE = FALSE.
    END.
      
    CLEAR FRAME f-maestro.
    RUN cbd/cbdnast.p(cb-codcia, s-codcia, s-periodo, s-NroMes, x-codope, OUTPUT x-nroast). 
    RUN add-cmov.
    ASSIGN
        FRAME f-add:VISIBLE        = FALSE
        FRAME f-ctrl-frame:visible = TRUE.

    DO WITH FRAME F-MAESTRO :
       BUTTON-4:SENSITIVE = TRUE.
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


&Scoped-define FRAME-NAME F-add
&Scoped-define SELF-NAME B-Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Cancel W-maestro
ON CHOOSE OF B-Cancel IN FRAME F-add /* Cancelar */
DO:
     /* RECID-cab = ?. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-update
&Scoped-define SELF-NAME B-Cancel-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Cancel-2 W-maestro
ON CHOOSE OF B-Cancel-2 IN FRAME F-update /* Cancelar */
DO:
    RECID-cab = ?.
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


&Scoped-define FRAME-NAME F-maestro
&Scoped-define SELF-NAME b-d-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-d-add W-maestro
ON CHOOSE OF b-d-add IN FRAME F-maestro /* Agregar */
DO:
    APPLY "INSERT-MODE" TO BRW-DETALLE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-d-delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-d-delete W-maestro
ON CHOOSE OF b-d-delete IN FRAME F-maestro /* Eliminar */
DO:
    APPLY "DELETE-CHARACTER" TO BRW-DETALLE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-D-SUMA
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-D-SUMA W-maestro
ON CHOOSE OF B-D-SUMA IN FRAME F-maestro /* Sumar */
DO:
    IF b-d-suma:SENSITIVE = NO
    THEN RETURN NO-APPLY.
    ASSIGN  cb-cmov.HbeMn1 = 0
            cb-cmov.HbeMn2 = 0
            cb-cmov.HbeMn3 = 0
            cb-cmov.DbeMn1 = 0
            cb-cmov.DbeMn2 = 0
            cb-cmov.DbeMn3 = 0.
    FOR EACH cb-dmov WHERE cb-dmov.CodCia  = s-codcia  AND
                           cb-dmov.Periodo = s-periodo AND
                           cb-dmov.NroMes  = s-NroMes  AND
                           cb-dmov.CodOpe  = x-CodOpe  AND
                           cb-dmov.NroAst  = cb-cmov.NroAst:SCREEN-VALUE
                           NO-LOCK:
        RUN Acumula.                        
    END.         
    DISPLAY cb-cmov.HbeMn1
            cb-cmov.HbeMn2
            cb-cmov.DbeMn1 
            cb-cmov.DbeMn2
            WITH FRAME F-maestro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-d-update
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-d-update W-maestro
ON CHOOSE OF b-d-update IN FRAME F-maestro /* Actualizar */
DO:
    APPLY "ENTER" TO BRW-DETALLE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-ctrl-frame
&Scoped-define SELF-NAME B-delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-delete W-maestro
ON CHOOSE OF B-delete IN FRAME F-ctrl-frame /* Eliminar */
DO:
    IF NOT AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro}
    THEN DO:
        MESSAGE  "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
        RETURN NO-APPLY.
    END.  
    IF s-NroMesCie
    THEN DO:
        MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF CB-CMOV.FLGEST = "A" THEN DO:
       MESSAGE "Registro anulado no puede ser modificado"
       VIEW-AS ALERT-BOX INFORMA.
       RETURN NO-APPLY.
    END.
    
    
    MESSAGE "Eliminar el Registro"
         VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
         UPDATE selection AS LOGICAL.
   
    IF NOT selection THEN RETURN NO-APPLY.
    pto = SESSION:SET-WAIT-STATE("GENERAL").
    FRAME F-ctrl-frame:VISIBLE = FALSE.
    RECID-Tmp = RECID(  {&FIRST-TABLE-IN-QUERY-F-maestro} ).
    DO  ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        FIND {&FIRST-TABLE-IN-QUERY-F-maestro}
               WHERE  RECID-Tmp = RECID(  {&FIRST-TABLE-IN-QUERY-F-maestro} )
                 NO-ERROR.
         
        FOR EACH cb-dmov WHERE cb-dmov.CodCia  = cb-cmov.CodCia  AND
                               cb-dmov.Periodo = cb-cmov.Periodo AND
                               cb-dmov.NroMes  = cb-cmov.NroMes  AND
                               cb-dmov.CodOpe  = cb-cmov.CodOpe  AND
                               cb-dmov.NroAst  = cb-cmov.NroAst :
         
            /* Des-actulizando saldos acumulados */ 
            RUN cbd/cb-acmd.p(RECID(cb-dmov), NO , YES).
            /* Borrando el detalle del Documento */ 
            DELETE cb-dmov.
        END.                
        /* Borrando la Cabezera del Documento */  
        DELETE  cb-cmov.
    END.
    IF NOT AVAIL  {&FIRST-TABLE-IN-QUERY-F-maestro} 
    THEN FIND LAST {&FIRST-TABLE-IN-QUERY-F-maestro}
             &IF "{&RECORD-SCOPE}" <> "" &THEN
                WHERE {&RECORD-SCOPE}
             &ENDIF  
             NO-LOCK NO-ERROR.
    ELSE FIND {&FIRST-TABLE-IN-QUERY-F-maestro}
                WHERE  RECID-Tmp = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} )
                NO-LOCK NO-ERROR.

    IF AVAIL  {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
    ELSE CLEAR FRAME F-maestro.
    pto = SESSION:SET-WAIT-STATE("").
    FRAME  F-ctrl-frame:VISIBLE = TRUE.

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
       NO-LOCK  NO-ERROR.

     IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
     ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
                    BUTTONS OK.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-maestro
&Scoped-define SELF-NAME B-impresoras
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-impresoras W-maestro
ON CHOOSE OF B-impresoras IN FRAME F-maestro
DO:
    SYSTEM-DIALOG PRINTER-SETUP.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-ctrl-frame
&Scoped-define SELF-NAME B-Imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Imprimir W-maestro
ON CHOOSE OF B-Imprimir IN FRAME F-ctrl-frame /* Imprimir */
DO:
    Message "Seleccione Impresión con el " SKIP
            "Click Derecho de su Mouse"    
            VIEW-AS ALERT-BOX INFORMA.
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


&Scoped-define FRAME-NAME F-add
&Scoped-define SELF-NAME B-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-ok W-maestro
ON CHOOSE OF B-ok IN FRAME F-add /* Aceptar */
DO:
  MaxError = 0.05.
  ASSIGN FRAME F-maestro
  {&FIELDS-IN-QUERY-F-maestro}
  {&ASSIGN-ADD}.
  APPLY "CHOOSE" TO B-D-SUMA.   
  IF NOT ( cb-cmov.HbeMn1 = cb-cmov.DbeMn1 AND 
           cb-cmov.HbeMn2 = cb-cmov.DbeMn2 ) THEN DO:
     APPLY "CHOOSE" TO B-D-SUMA.    
     IF ( ABSOLUTE(cb-cmov.HbeMn1 - cb-cmov.DbeMn1) > MaxError) OR 
        ( ABSOLUTE(cb-cmov.HbeMn2 - cb-cmov.DbeMn2) > MaxError) THEN DO:
          BELL.
          MESSAGE "Asiento DES-BALANCEADO" SKIP
                  "Desea Salir sin completar el Asiento ?"   
                  VIEW-AS ALERT-BOX ERROR
                  BUTTONS YES-NO
                        UPDATE choice AS LOGICAL.
                IF NOT choice THEN RETURN NO-APPLY.
     END.
     ELSE DO :
        RUN Dif-Redondeo(1).
        RUN Dif-Redondeo(2).
     END.
  END.    
     
  BUCLE:
  FOR EACH DETALLE WHERE  DETALLE.CodCia  = cb-cmov.CodCia  AND
                          DETALLE.Periodo = cb-cmov.Periodo AND
                          DETALLE.NroMes  = cb-cmov.NroMes  AND
                          DETALLE.CodOpe  = cb-cmov.CodOpe  AND
                          DETALLE.NroAst  = cb-cmov.NroAst 
                          BREAK BY DETALLE.CODDIV :
       IF FIRST-OF(DETALLE.CODDIV) THEN 
         ASSIGN X-D1 = 0
                X-D2 = 0
                X-H1 = 0
                X-H2 = 0.     
                                
       IF NOT DETALLE.TPOMOV THEN DO:
           X-D1 = X-D1 + DETALLE.IMPMN1.
           X-D2 = X-D2 + DETALLE.IMPMN2.
       END.                     
       ELSE DO:
           X-H1 = X-H1 + DETALLE.IMPMN1.
           X-H2 = X-H2 + DETALLE.IMPMN2.
       END.                     
       
       IF LAST-OF(DETALLE.CODDIV) AND ( (X-D1 <> X-H1 ) OR (X-D2 <> X-H2 )) THEN DO:
          IF ABS(X-D1 - X-H1) > MaxError OR ABS(X-D2 - X-H2) > MaxError THEN DO:
             BELL.
             MESSAGE "DIVISION DESBALANCEADA: " + DETALLE.CODDIV SKIP
             "Desea Salir sin completar el Asiento ?"   
             VIEW-AS ALERT-BOX ERROR
             BUTTONS YES-NO
             UPDATE choice1 AS LOGICAL.
             IF NOT choice1 THEN RETURN NO-APPLY.
             ELSE LEAVE BUCLE.
          END.
       END.
    END.
    
  FOR EACH CBD-STACK WHERE CBD-STACK.CodCia  = cb-cmov.CodCia  AND
                           CBD-STACK.Periodo = cb-cmov.Periodo AND
                           CBD-STACK.NroMes  = cb-cmov.NroMes  AND
                           CBD-STACK.CodOpe  = cb-cmov.CodOpe  AND
                           CBD-STACK.NroAst  = cb-cmov.NroAst  
                           EXCLUSIVE:
       RUN cbd-stack-act(BUFFER CBD-STACK). 
       DELETE CBD-STACK.
  END.     
  
  ASSIGN X-D1 = 0
         X-D2 = 0
         X-H1 = 0
         X-H2 = 0.     
             
  FOR EACH cb-dmov WHERE cb-dmov.CodCia  = cb-cmov.CodCia  AND
                            cb-dmov.Periodo = cb-cmov.Periodo AND
                            cb-dmov.NroMes  = cb-cmov.NroMes  AND
                            cb-dmov.CodOpe  = cb-cmov.CodOpe  AND
                            cb-dmov.NroAst  = cb-cmov.NroAst  AND
                            cb-dmov.flgact  = FALSE
                            EXCLUSIVE:
      RUN cbd/cb-acmd.p(RECID(cb-dmov), YES, YES). 
      cb-dmov.flgact = TRUE.
  END.                            
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-update
&Scoped-define SELF-NAME B-ok-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-ok-2 W-maestro
ON CHOOSE OF B-ok-2 IN FRAME F-update /* Aceptar */
DO:
  MaxError = 0.05.
  ASSIGN FRAME F-maestro
  {&FIELDS-IN-QUERY-F-maestro}
  {&ASSIGN-ADD}.
  APPLY "CHOOSE" TO B-D-SUMA.   
  IF NOT ( cb-cmov.HbeMn1 = cb-cmov.DbeMn1 AND 
           cb-cmov.HbeMn2 = cb-cmov.DbeMn2 ) THEN DO:
     APPLY "CHOOSE" TO B-D-SUMA.    
     IF ( ABSOLUTE(cb-cmov.HbeMn1 - cb-cmov.DbeMn1) > MaxError) OR 
        ( ABSOLUTE(cb-cmov.HbeMn2 - cb-cmov.DbeMn2) > MaxError) THEN DO:
          BELL.
          MESSAGE "Asiento DES-BALANCEADO" SKIP
                  "Desea Salir sin completar el Asiento ?"   
                  VIEW-AS ALERT-BOX ERROR
                  BUTTONS YES-NO
                        UPDATE choice AS LOGICAL.
                IF NOT choice THEN RETURN NO-APPLY.
     END.
     ELSE DO :
        RUN Dif-Redondeo(1).
        RUN Dif-Redondeo(2).
     END.
  END.    
     
  BUCLE:
  FOR EACH DETALLE WHERE  DETALLE.CodCia  = cb-cmov.CodCia  AND
                          DETALLE.Periodo = cb-cmov.Periodo AND
                          DETALLE.NroMes  = cb-cmov.NroMes  AND
                          DETALLE.CodOpe  = cb-cmov.CodOpe  AND
                          DETALLE.NroAst  = cb-cmov.NroAst 
                          BREAK BY DETALLE.CODDIV :
       IF FIRST-OF(DETALLE.CODDIV) THEN 
         ASSIGN X-D1 = 0
                X-D2 = 0
                X-H1 = 0
                X-H2 = 0.     
                                
       IF NOT DETALLE.TPOMOV THEN DO:
           X-D1 = X-D1 + DETALLE.IMPMN1.
           X-D2 = X-D2 + DETALLE.IMPMN2.
       END.                     
       ELSE DO:
           X-H1 = X-H1 + DETALLE.IMPMN1.
           X-H2 = X-H2 + DETALLE.IMPMN2.
       END.                     
       
       IF LAST-OF(DETALLE.CODDIV) AND ( (X-D1 <> X-H1 ) OR (X-D2 <> X-H2 )) THEN DO:
          IF ABS(X-D1 - X-H1) > MaxError OR ABS(X-D2 - X-H2) > MaxError THEN DO:
             BELL.
             MESSAGE "DIVISION DESBALANCEADA: " + DETALLE.CODDIV SKIP
             "Desea Salir sin completar el Asiento ?"   
             VIEW-AS ALERT-BOX ERROR
             BUTTONS YES-NO
             UPDATE choice1 AS LOGICAL.
             IF NOT choice1 THEN RETURN NO-APPLY.
             ELSE LEAVE BUCLE.
          END.
       END.
    END.
    
  FOR EACH CBD-STACK WHERE CBD-STACK.CodCia  = cb-cmov.CodCia  AND
                           CBD-STACK.Periodo = cb-cmov.Periodo AND
                           CBD-STACK.NroMes  = cb-cmov.NroMes  AND
                           CBD-STACK.CodOpe  = cb-cmov.CodOpe  AND
                           CBD-STACK.NroAst  = cb-cmov.NroAst  
                           EXCLUSIVE:
       RUN cbd-stack-act(BUFFER CBD-STACK). 
       DELETE CBD-STACK.
  END.     
  
  ASSIGN X-D1 = 0
         X-D2 = 0
         X-H1 = 0
         X-H2 = 0.     
             
  FOR EACH cb-dmov WHERE cb-dmov.CodCia  = cb-cmov.CodCia  AND
                            cb-dmov.Periodo = cb-cmov.Periodo AND
                            cb-dmov.NroMes  = cb-cmov.NroMes  AND
                            cb-dmov.CodOpe  = cb-cmov.CodOpe  AND
                            cb-dmov.NroAst  = cb-cmov.NroAst  AND
                            cb-dmov.flgact  = FALSE
                            EXCLUSIVE:
      RUN cbd/cb-acmd.p(RECID(cb-dmov), YES, YES). 
      cb-dmov.flgact = TRUE.
  END.                            
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-search
&Scoped-define SELF-NAME B-ok-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-ok-3 W-maestro
ON CHOOSE OF B-ok-3 IN FRAME F-search /* Aceptar */
DO:
    IF cb-cmov.NroAst:SCREEN-VALUE IN FRAME F-maestro <> "" THEN DO:
         FIND FIRST  {&FIRST-TABLE-IN-QUERY-F-maestro}
             WHERE 
                  &IF "{&RECORD-SCOPE}" <> "" &THEN
                      {&RECORD-SCOPE} AND
                  &ENDIF
                  cb-cmov.NroAst = cb-cmov.NroAst:SCREEN-VALUE IN FRAME F-maestro
                   NO-LOCK NO-ERROR.
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
      ELSE  DO:
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
     CLEAR FRAME F-maestro.
     FRAME F-ctrl-frame:VISIBLE = FALSE.
     FRAME F-search:VISIBLE = TRUE.
     
     DO WITH FRAME F-MAESTRO :
       BUTTON-4:SENSITIVE = FALSE.
     END.      
     
     ENABLE {&QUERY-field}  WITH FRAME F-maestro.
     
     APPLY "ENTRY" TO cb-cmov.NroAst.
          
     WAIT-FOR  "CHOOSE" OF b-ok-3 IN FRAME f-search
     OR CHOOSE OF b-cancel-3 IN FRAME f-search.
     
     DISABLE {&QUERY-field} WITH FRAME F-maestro.
     FRAME f-search:VISIBLE = FALSE.
     FRAME f-ctrl-frame:VISIBLE = TRUE.
    DO WITH FRAME F-MAESTRO :
       BUTTON-4:SENSITIVE = TRUE.
    END.
  
END. /*choose of b-query*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-update
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-update W-maestro
ON CHOOSE OF B-update IN FRAME F-ctrl-frame /* Modificar */
DO:
    IF s-NroMesCie
    THEN DO:
        MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF CB-CMOV.FLGEST = "A" THEN DO:
       MESSAGE "Registro anulado no puede ser modificado"
       VIEW-AS ALERT-BOX INFORMA.
       RETURN NO-APPLY.
    END.                   
       
    FRAME f-ctrl-frame:VISIBLE = FALSE.
    FRAME f-update:VISIBLE = TRUE.
    DO WITH FRAME F-MAESTRO :
       BUTTON-4:SENSITIVE = FALSE.
    END.
    RECID-cab = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} ).
    Data:            
    DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        FIND FIRST {&FIRST-TABLE-IN-QUERY-F-maestro}
            WHERE RECID-cab = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} )
            EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
            x-CodMon = cb-cmov.CodMon.
            GET FIRST BRW-DETALLE.
            ASSIGN  cb-cmov.Usuario = s-user-id.
            ENABLE cb-cmov.Fchast Moneda Nrovou cb-cmov.Tpocmb
                cb-cmov.Notast cb-cmov.GloAst BRW-DETALLE
                b-d-add b-d-update b-d-delete BUTTON-3 b-d-suma WITH FRAME F-maestro.
            IF cb-cfga.CodDiv THEN 
                ENABLE cb-cmov.CODDIV WITH FRAME F-maestro.
            ELSE DO:
                DISABLE cb-cmov.CODDIV WITH FRAME F-maestro.
            END.        
            IF cb-oper.resume THEN ENABLE cb-cmov.C-Fcaja WITH FRAME F-maestro.
            ELSE DO:
               DISABLE cb-cmov.C-Fcaja WITH FRAME F-maestro.
            END.   
            CASE cb-oper.CodMon:
                WHEN 1 THEN DO:
                    x-CodMon = 1.
                    DISABLE Moneda.
                END.
                WHEN 2 THEN DO:
                    x-CodMon = 2.
                    DISABLE Moneda.
                END.
            END CASE.

            CASE x-CodMon :
                WHEN 1 THEN ASSIGN Moneda = "Soles"   x-CodMon = 1.
                WHEN 2 THEN ASSIGN Moneda = "Dólares" x-CodMon = 2.
                OTHERWISE   ASSIGN Moneda = "Soles"   x-CodMon = 1.
            END CASE.
            DISPLAY  Moneda WITH FRAME F-maestro.
            /* BORANDO LAS CUENTAS DE REDONDEO PARA VOLVER A GENERARLAS */
            FOR EACH cb-dmov WHERE cb-dmov.CodCia  = cb-cmov.CodCia  AND
                           cb-dmov.Periodo = cb-cmov.Periodo AND
                           cb-dmov.NroMes  = cb-cmov.NroMes  AND
                           cb-dmov.CodOpe  = cb-cmov.CodOpe  AND
                           cb-dmov.NroAst  = cb-cmov.NroAst  AND
                           cb-dmov.TpoItm  = "R" :
                RUN Delete-Dmov.  
            END.                               
            RUN PINTADO.                           
            WAIT-FOR CHOOSE OF b-ok-2 OR CHOOSE OF B-cancel-2 IN FRAME f-UPDATE.
            IF LAST-EVENT:FUNCTION = "END-ERROR" OR
               RECID-cab = ?
            THEN UNDO, LEAVE Data.
        END.
        ELSE MESSAGE  "No exiten Registros." VIEW-AS ALERT-BOX ERROR
        BUTTONS OK.                                        
            
    END.  /*transaction*/
    IF AVAILABLE {&FIRST-TABLE-IN-QUERY-F-maestro}
    THEN DO:
        RECID-cab = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} ).
        FIND FIRST {&FIRST-TABLE-IN-QUERY-F-maestro}
        WHERE RECID-cab = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} )
            NO-LOCK NO-ERROR.
    END.
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
    DISABLE cb-cmov.Fchast Moneda Nrovou cb-cmov.Tpocmb cb-cmov.Notast
        cb-cmov.GloAst b-d-add b-d-update b-d-delete BUTTON-3 b-d-suma
        cb-cmov.c-fcaja
        WITH FRAME F-maestro.
    IF cb-cfga.CodDiv THEN DISABLE cb-cmov.CODDIV WITH FRAME F-maestro.
    
    FRAME F-update:VISIBLE = FALSE.
    FRAME F-ctrl-frame:VISIBLE = TRUE.
     DO WITH FRAME F-MAESTRO :
       BUTTON-4:SENSITIVE = TRUE.
    END.       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BRW-DETALLE
&Scoped-define FRAME-NAME F-maestro
&Scoped-define SELF-NAME BRW-DETALLE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BRW-DETALLE W-maestro
ON COPY OF BRW-DETALLE IN FRAME F-maestro
DO:
    IF RECID(cb-dmov) = ? THEN DO:
        MESSAGE "No ha seleccionado ning£n elemento"
        VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    
    IF cb-dmov.TpoItm = "A" THEN DO:
     MESSAGE "Esta cuenta es automática no se puede copiar"
        VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.  
    END.    
    
    IF cb-dmov.TpoItm = "D" THEN DO:
     MESSAGE "Esta cuenta es por Diferencia de Cambio / Traslación "
        VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.  
    END.    
    
    MESSAGE "Generar I.G.V " VIEW-AS ALERT-BOX QUESTION
    BUTTON YES-NO-CANCEL  UPDATE OPCION AS LOGICAL.
    CASE OPCION :
       WHEN TRUE  THEN RUN GENERA-IGV.
       WHEN FALSE THEN RUN DUPLICA.
       OTHERWISE RETURN.
    END.        
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BRW-DETALLE W-maestro
ON DELETE-CHARACTER OF BRW-DETALLE IN FRAME F-maestro
DO:
    IF b-d-add:SENSITIVE = NO
    THEN RETURN NO-APPLY.
    IF RECID(cb-dmov) = ?
    THEN DO:
        BELL.
        MESSAGE "Item no seleccionado o no existente" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF cb-dmov.TpoItm = "A"
    THEN DO:
        BELL.
        MESSAGE "Cuenta Autom tica" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    
    MESSAGE "Est  seguro de eliminar movimiento"
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOGICAL.
    IF rpta
    THEN DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        RUN Delete-Dmov.
        {&OPEN-QUERY-{&BROWSE-NAME}}
        DISPLAY cb-cmov.HbeMn1
                cb-cmov.HbeMn2
                cb-cmov.DbeMn1 
                cb-cmov.DbeMn2
            WITH FRAME F-maestro.
    END.
    ELSE RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BRW-DETALLE W-maestro
ON INSERT-MODE OF BRW-DETALLE IN FRAME F-maestro
DO:
    IF b-d-add:SENSITIVE = NO THEN RETURN NO-APPLY.
    DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE: 
        x-NroItm = 1.
        FIND LAST cb-dmov WHERE cb-dmov.CodCia  = s-codcia AND
                                cb-dmov.Periodo = s-periodo    AND
                                cb-dmov.NroMes  = s-NroMes    AND
                                cb-dmov.CodOpe  = x-CodOpe AND
                                cb-dmov.NroAst  = cb-cmov.NroAst:SCREEN-VALUE
                                NO-LOCK NO-ERROR.
        IF AVAILABLE cb-dmov THEN x-NroItm = cb-dmov.NroItm + 1.
        CREATE cb-dmov.
        ASSIGN cb-dmov.CodCia  = s-codcia
               cb-dmov.Periodo = s-periodo
               cb-dmov.NroMes  = s-NroMes
               cb-dmov.CodOpe  = x-CodOpe
               cb-dmov.NroAst  = cb-cmov.NroAst:SCREEN-VALUE
               cb-dmov.GloDoc  = INPUT cb-cmov.NotAst
               cb-dmov.CodDiv  = INPUT cb-cmov.CodDiv
               cb-dmov.FCHDOC  = INPUT cb-cmov.FCHAST
               cb-dmov.FCHVTO  = INPUT cb-cmov.FCHAST
               cb-dmov.CodMon  = x-CodMon
               cb-dmov.TpoCmb  = INPUT cb-cmov.TpoCmb
               cb-dmov.NroItm  = x-NroItm
               cb-dmov.C-FCAJA = INPUT cb-cmov.C-FCAJA
               cb-cmov.TotItm  = x-NroItm
               RegAct          = RECID(cb-dmov).
               cb-dmov.NroRef  = IF INPUT cb-cmov.NROVOU = "" THEN "" ELSE INPUT cb-cmov.NROVOU.
        RUN cbd/cbddiar2.w(TRUE,RegAct, x-CodMon).
        PTO = SESSION:SET-WAIT-STATE("GENERAL").
        RUN Acumula.
        /* Generando Cuentas Autom ticas */
        RUN Automaticas-1.
        {&OPEN-QUERY-BRW-DETALLE}
        PTO = SESSION:SET-WAIT-STATE("").
        DISPLAY  cb-cmov.HbeMn1
                 cb-cmov.HbeMn2 
                 cb-cmov.DbeMn1 
                 cb-cmov.DbeMn2
                 cb-cmov.TotItm
                WITH FRAME F-maestro.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BRW-DETALLE W-maestro
ON MOUSE-SELECT-DBLCLICK OF BRW-DETALLE IN FRAME F-maestro
DO:
    APPLY "ENTER" TO BRW-DETALLE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BRW-DETALLE W-maestro
ON RETURN OF BRW-DETALLE IN FRAME F-maestro
DO:
   
    IF b-d-add:SENSITIVE = NO
    THEN RETURN NO-APPLY.
    RegAct = RECID(cb-dmov).
    DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        IF RECID(cb-dmov) = ?
        THEN DO:
            BELL.
            MESSAGE "Item no seleccionado o no existente"
                VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        IF cb-dmov.TpoItm = "A"
        THEN DO:
            BELL.
            MESSAGE "Cuenta Autom tica" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.    
        RUN Del-Acumula.
        RUN GrabaAnt.
        RUN cbd/cbddiar2.w(FALSE,RegAct, x-CodMon).
        PTO = SESSION:SET-WAIT-STATE("GENERAL").
        RUN Acumula.
        /* Actualizando Cuentas Autom ticas */
        RUN Automaticas-1.
        PTO = BRW-DETALLE:REFRESH().
        PTO = SESSION:SET-WAIT-STATE("").
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-ctrl-frame
&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-maestro
ON CHOOSE OF BUTTON-2 IN FRAME F-ctrl-frame /* Copiar */
DO  :
    DEF VAR X-RECID AS RECID.
    MESSAGE "Esta seguro de Copiar este " SKIP
            "Comprobante" 
            VIEW-AS ALERT-BOX INFORMA
            BUTTON YES-NO UPDATE RPTA AS LOGICAL.
    IF NOT RPTA THEN RETURN.        

DO ON ENDKEY UNDO, LEAVE ON STOP UNDO, LEAVE ON ERROR UNDO,LEAVE
    WITH  FRAME F-MAESTRO:
    RUN cbd/cbdnast.p(cb-codcia, s-codcia, s-periodo, s-NroMes, x-codope, OUTPUT x-nroast). 
    CREATE CABEZA.
    ASSIGN cabeza.CodCia  = cb-cmov.CodCia
           cabeza.Periodo = cb-cmov.Periodo
           cabeza.NroMes  = cb-cmov.NroMes 
           cabeza.CodOpe  = cb-cmov.CodOpe
           cabeza.NroAst  = STRING(x-NroAst,"999999")
           cabeza.FchAst  = cb-cmov.FchAst
           cabeza.Usuario = cb-cmov.Usuario
           cabeza.Codaux  = cb-cmov.Codaux  
           cabeza.CodDiv  = cb-cmov.CodDiv
           cabeza.Coddoc  = cb-cmov.Coddoc
           cabeza.Codaux  = cb-cmov.Codaux 
           cabeza.Codmon  = cb-cmov.Codmon
           cabeza.Ctacja  = cb-cmov.Ctacja
           cabeza.DbeMn1  = cb-cmov.DbeMn1
           cabeza.DbeMn2  = cb-cmov.DbeMn2
           cabeza.DbeMn3  = cb-cmov.DbeMn3
           cabeza.FchMod  = cb-cmov.FchMod 
           cabeza.Flgest  = cb-cmov.Flgest
           cabeza.Girado  = cb-cmov.Girado 
           cabeza.GloAst  = cb-cmov.GloAst   
           cabeza.HbeMn1  = cb-cmov.HbeMn1
           cabeza.HbeMn2  = cb-cmov.HbeMn2
           cabeza.HbeMn3  = cb-cmov.HbeMn3
           cabeza.Impchq  = cb-cmov.Impchq
           cabeza.Notast  = cb-cmov.Notast 
           cabeza.Nrochq  = cb-cmov.Nrochq 
           cabeza.NroTra  = cb-cmov.NroTra
           cabeza.Nrovou  = cb-cmov.Nrovou
           cabeza.Totitm  = cb-cmov.Totitm
           cabeza.Tpocmb  = cb-cmov.Tpocmb.
     FOR EACH cb-dmov WHERE cb-dmov.CodCia  = s-codcia  AND
                           cb-dmov.Periodo = s-periodo AND
                           cb-dmov.NroMes  = s-NroMes  AND
                           cb-dmov.CodOpe  = x-CodOpe  AND
                           cb-dmov.NroAst  = cb-cmov.NroAst:SCREEN-VALUE AND
                           cb-dmov.TpoItm <> "A"
                           NO-LOCK:
         CREATE DETALLE.
         ASSIGN
         detalle.CodCia   = cabeza.CodCia 
         detalle.Periodo  = cabeza.Periodo 
         detalle.NroMes   = cabeza.NroMes 
         detalle.Codope   = cabeza.Codope 
         detalle.Nroast   = cabeza.Nroast
         detalle.cco      = cb-dmov.cco 
         detalle.Clfaux   = cb-dmov.Clfaux
         detalle.Codaux   = cb-dmov.Codaux  
         detalle.Codcta   = cb-dmov.Codcta 
         detalle.CodDiv   = cb-dmov.CodDiv 
         detalle.Coddoc   = cb-dmov.Coddoc 
         detalle.Codmon   = cb-dmov.Codmon 
         detalle.CtaAut   = cb-dmov.CtaAut 
         detalle.CtrCta   = cb-dmov.CtrCta 
         detalle.Fchdoc   = cb-dmov.Fchdoc 
         detalle.Fchvto   = cb-dmov.Fchvto 
         detalle.flgact   = cb-dmov.flgact 
         detalle.Glodoc   = cb-dmov.Glodoc 
         detalle.ImpMn1   = cb-dmov.ImpMn1 
         detalle.ImpMn2   = cb-dmov.ImpMn2 
         detalle.ImpMn3   = cb-dmov.ImpMn3 
         detalle.Nrodoc   = cb-dmov.Nrodoc 
         detalle.Nroitm   = cb-dmov.Nroitm 
         detalle.Nroref   = cb-dmov.Nroref 
         detalle.Nroruc   = cb-dmov.Nroruc 
         detalle.Relacion = cb-dmov.Relacion 
         detalle.tm       = cb-dmov.tm 
         detalle.Tpocmb   = cb-dmov.Tpocmb 
         detalle.TpoItm   = cb-dmov.TpoItm 
         detalle.TpoMov   = cb-dmov.TpoMov.                                 
         RUN cbd/cb-acmd.p(RECID(detalle), YES, YES).   
         IF Detalle.CtaAut <> ""  AND  Detalle.CtrCta <> "" 
            THEN DO:
                X-RECID = RECID(DETALLE).
                CREATE DETALLE.
                ASSIGN 
                   detalle.CodCia   = cabeza.CodCia 
                   detalle.Periodo  = cabeza.Periodo 
                   detalle.NroMes   = cabeza.NroMes 
                   detalle.Codope   = cabeza.Codope 
                   detalle.Nroast   = cabeza.Nroast
                   DETALLE.TpoItm   = "A"
                   DETALLE.Relacion = X-RECID
                   DETALLE.CodMon   = cb-dmov.CodMon
                   DETALLE.TpoCmb   = cb-dmov.TpoCmb
                   DETALLE.NroItm   = cb-dmov.NroItm
                   DETALLE.Codcta   = cb-dmov.CtaAut
                   DETALLE.CodDiv   = cb-dmov.CodDiv
                   DETALLE.ClfAux   = cb-dmov.ClfAux
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
                   DETALLE.ImpMn1   = cb-dmov.ImpMn1
                   DETALLE.ImpMn2   = cb-dmov.ImpMn2
                   DETALLE.ImpMn3   = cb-dmov.ImpMn3
                   DETALLE.Tm       = cb-dmov.Tm
                   DETALLE.CCO      = cb-dmov.CCO.
               RUN cbd/cb-acmd.p(RECID(DETALLE), YES ,YES).     
               CREATE DETALLE.
               ASSIGN 
                  detalle.CodCia   = cabeza.CodCia 
                  detalle.Periodo  = cabeza.Periodo 
                  detalle.NroMes   = cabeza.NroMes 
                  detalle.Codope   = cabeza.Codope 
                  detalle.Nroast   = cabeza.Nroast
                  DETALLE.TpoItm   = "A"
                  DETALLE.Relacion = X-RECID
                  DETALLE.CodMon   = cb-dmov.CodMon
                  DETALLE.TpoCmb   = cb-dmov.TpoCmb
                  DETALLE.NroItm   = cb-dmov.NroItm
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
                  DETALLE.ImpMn3   = cb-dmov.ImpMn3
                  DETALLE.NroRef   = cb-dmov.NroRef
                  DETALLE.FchDoc   = cb-dmov.FchDoc
                  DETALLE.FchVto   = cb-dmov.FchVto
                  DETALLE.Tm       = cb-dmov.Tm.
                  DETALLE.CCO      = cb-dmov.CCO.
                  RUN cbd/cb-acmd.p(RECID(DETALLE), YES ,YES). 
    
       END. /*FIN DE GENERACION DE AUTOMATICAS */                  
                  
    END. /*FIN DEL FOR EACH */    
END.   
    MESSAGE "Se ha generado el comprobante " cabeza.nroast skip
            "con exito"  VIEW-AS ALERT-BOX INFORMA.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-maestro
&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-maestro
ON CHOOSE OF BUTTON-3 IN FRAME F-maestro /* Copiar */
DO:
    APPLY "COPY" TO BRW-DETALLE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-maestro
ON CHOOSE OF BUTTON-4 IN FRAME F-maestro /* Operación */
DO:
  RUN cbd/s-opera.w  ( cb-codcia, OUTPUT RECID-stack ).
  IF LOOKUP(LAST-EVENT:FUNCTION, "ENDKEY,ERROR,END-ERROR") <> 0
  THEN RETURN.
  FIND cb-oper WHERE RECID( cb-oper ) = RECID-stack NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-oper
  THEN RETURN.
  x-NomOpe = integral.cb-oper.Nomope.
  x-codope = integral.cb-oper.codope.
  RUN bin/_mes.p ( INPUT s-NroMes , 1,  OUTPUT s-nomcia ).  
  s-nomcia = x-NomOpe + "   " + s-nomcia + ", " + STRING( s-periodo , "9999" ) + 
             " - " + EMPRESAS.NOMCIA + " - " + s-user-id. 
  {&WINDOW-NAME}:TITLE = s-nomcia.


  ASSIGN
  FRAME f-add:VISIBLE = FALSE
  FRAME f-update:VISIBLE = FALSE
  FRAME f-search:VISIBLE = FALSE
  FRAME F-ctrl-frame:VISIBLE = TRUE .
  FIND LAST {&FIRST-TABLE-IN-QUERY-F-maestro}
        &IF "{&RECORD-SCOPE}" <> "" &THEN
             WHERE {&RECORD-SCOPE}
        &ENDIF
        NO-ERROR.
   IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
   ELSE CLEAR FRAME F-maestro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cmov.C-FCaja
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cmov.C-FCaja W-maestro
ON F8 OF cb-cmov.C-FCaja IN FRAME F-maestro /* Con. Flj. Caja */
OR "MOUSE-SELECT-DBLCLICK":U OF cb-cmov.c-fcaja DO:
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cmov.C-FCaja W-maestro
ON LEAVE OF cb-cmov.C-FCaja IN FRAME F-maestro /* Con. Flj. Caja */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   FIND FIRST cb-auxi WHERE cb-auxi.codcia  = cb-codcia   AND 
                            cb-auxi.clfaux  = "@FC"       AND
                            cb-auxi.codaux  = SELF:SCREEN-VALUE
                            NO-LOCK NO-ERROR.                                
      IF NOT AVAIL cb-auxi THEN DO:
         MESSAGE "Código de Flujo de Caja no registrado" VIEW-AS ALERT-BOX ERROR.
         RETURN NO-APPLY.
      END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cmov.CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cmov.CodDiv W-maestro
ON F8 OF cb-cmov.CodDiv IN FRAME F-maestro /* División */
OR "MOUSE-SELECT-DBLCLICK":U OF cb-cmov.CODDIV DO:
  {CBD/H-DIVI01.I NO SELF}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cmov.CodDiv W-maestro
ON LEAVE OF cb-cmov.CodDiv IN FRAME F-maestro /* División */
DO:
   IF SELF:SCREEN-VALUE <> "" THEN DO:
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
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cmov.FchAst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cmov.FchAst W-maestro
ON LEAVE OF cb-cmov.FchAst IN FRAME F-maestro /* Fecha */
DO: 
   /* IF SELF:SCREEN-VALUE <> STRING(cb-cmov.FchAst)
    THEN DO:
  */  
        FIND gn-tcmb WHERE gn-tcmb.FECHA = INPUT FRAME F-Maestro cb-cmov.FchAst
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-tcmb 
        THEN DO :
                    IF cb-oper.TpoCmb = 1 THEN cb-cmov.TpoCmb = gn-tcmb.Compra.
                    ELSE cb-cmov.TpoCmb = gn-tcmb.Venta.
                    DISPLAY cb-cmov.TpoCmb WITH FRAME F-MAESTRO.
             END.       
        ELSE MESSAGE "No existe Tipo de Cambio" SKIP
                     "para la fecha registrada" VIEW-AS ALERT-BOX.
   /* END.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Moneda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Moneda W-maestro
ON RETURN OF Moneda IN FRAME F-maestro /* Moneda */
DO:
  APPLY "TAB":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Moneda W-maestro
ON VALUE-CHANGED OF Moneda IN FRAME F-maestro /* Moneda */
DO:
    CASE Moneda:SCREEN-VALUE IN FRAME F-maestro :
        WHEN "Soles"   THEN  x-CodMon = 1.
        WHEN "Dólares" THEN  x-CodMon = 2.
        OTHERWISE            x-CodMon = 1.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Omitir_Automticas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Omitir_Automticas W-maestro
ON CHOOSE OF MENU-ITEM m_Omitir_Automticas /* Omitir Autom ticas */
DO:  
   RUN IMPRIME(2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Omitir_Automticas_Ordenado_
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Omitir_Automticas_Ordenado_ W-maestro
ON CHOOSE OF MENU-ITEM m_Omitir_Automticas_Ordenado_ /* Omitir Autom ticas Ordenado por Cuenta */
DO:
  /* MESSAGE "OPCION NO AUTORIZADA"
   VIEW-AS ALERT-BOX INFORMA.
   RETURN.*/
   RUN IMPRIME-ORDENADO(2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Omitir_Automticas_Ordernado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Omitir_Automticas_Ordernado W-maestro
ON CHOOSE OF MENU-ITEM m_Omitir_Automticas_Ordernado /* Omitir Autom ticas Ordernado por D/H */
DO:
  /* MESSAGE "OPCION NO AUTORIZADA"
   VIEW-AS ALERT-BOX INFORMA.
   RETURN.*/
   RUN IMPRIME-DH(2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Todas_las_Cuentas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Todas_las_Cuentas W-maestro
ON CHOOSE OF MENU-ITEM m_Todas_las_Cuentas /* Todas las Cuentas */
DO:
   RUN IMPRIME(1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Todas_las_cuentas_Ordenado_
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Todas_las_cuentas_Ordenado_ W-maestro
ON CHOOSE OF MENU-ITEM m_Todas_las_cuentas_Ordenado_ /* Todas las cuentas Ordenado por Cuenta */
DO:
   RUN IMPRIME-ORDENADO(1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Todas_Las_Cuentas_Ordenado_2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Todas_Las_Cuentas_Ordenado_2 W-maestro
ON CHOOSE OF MENU-ITEM m_Todas_Las_Cuentas_Ordenado_2 /* Todas Las Cuentas Ordenado por D/H */
DO:
   RUN IMPRIME-DH(1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-add
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

ON "ENDKEY", END-ERROR OF B-add, B-browse, B-Cancel, B-Cancel-2, B-Cancel-3, 
        B-delete, B-exit, B-first, B-last, B-next, B-ok, B-ok-2, B-ok-3, B-prev, 
        B-query, B-update, FRAME F-maestro
DO: 
    IF FRAME F-add:VISIBLE    = TRUE THEN APPLY "CHOOSE" TO B-cancel.
    IF FRAME F-update:VISIBLE = TRUE THEN APPLY "CHOOSE" TO B-cancel-2.
    IF FRAME F-search:VISIBLE = TRUE THEN APPLY "CHOOSE" TO B-cancel-3.
    IF FRAME F-ctrl-frame:VISIBLE = TRUE 
    THEN APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

ON "GO" OF FRAME F-maestro, FRAME F-add, FRAME F-update, FRAME F-search
DO: 
    IF FRAME F-add:VISIBLE    = TRUE THEN APPLY "CHOOSE" TO B-ok.
    IF FRAME F-update:VISIBLE = TRUE THEN APPLY "CHOOSE" TO B-ok-2.
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

RUN bin/_mes.p ( INPUT s-NroMes , 1,  OUTPUT s-nomcia ).  
s-nomcia = x-NomOpe + "   " + s-nomcia + ", " + STRING( s-periodo , "9999" ) +
           " - " + Empresas.NomCia + " - " + s-user-id.
{&WINDOW-NAME}:TITLE = s-nomcia.

&Undefine OPEN-QUERY-BRW-DETALLE

&Scoped-define OPEN-QUERY-BRW-DETALLE OPEN QUERY BRW-DETALLE FOR EACH integral.cb-dmov ~
      WHERE integral.cb-dmov.CodCia = s-codcia ~
 AND integral.cb-dmov.Periodo = s-periodo ~
 AND integral.cb-dmov.NroMes = s-NroMes ~
 AND integral.cb-dmov.Codope = x-CodOpe ~
 AND integral.cb-dmov.Nroast = integral.cb-cmov.Nroast:SCREEN-VALUE NO-LOCK.
/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

MAIN-BLOCK:
DO ON ERROR UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    BRW-DETALLE:NUM-LOCKED-COLUMNS = 3. 
    ASSIGN
    FRAME f-add:VISIBLE = FALSE
    FRAME f-update:VISIBLE = FALSE
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
    DISABLE {&ENABLED-FIELDS-IN-QUERY-{&FRAME-NAME}}.
    IF NOT THIS-PROCEDURE:PERSISTENT THEN    
    WAIT-FOR CLOSE OF THIS-PROCEDURE.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ACTUALIZA W-maestro 
PROCEDURE ACTUALIZA :
DEFINE PARAMETER BUFFER CBD-STACK FOR CBD-STACK.
DEFINE INPUT PARAMETER X-CODDIV  AS CHAR.
DEFINE INPUT PARAMETER  X-CODCTA AS CHAR.

    FIND cb-acmd WHERE cb-acmd.CodCia  = cbd-stack.CodCia
                   AND cb-acmd.Periodo = cbd-stack.Periodo
                   AND cb-acmd.CodDiv  = x-CodDiv
                   AND cb-acmd.CodCta  = x-CodCta
                   EXCLUSIVE NO-ERROR.
    IF NOT AVAILABLE cb-acmd
    THEN DO:
        CREATE cb-acmd.
        ASSIGN cb-acmd.CodCia  = cbd-stack.CodCia 
               cb-acmd.Periodo = cbd-stack.Periodo
               cb-acmd.CodDiv  = x-CodDiv
               cb-acmd.CodCta  = x-CodCta.
    END.
    IF NOT cbd-stack.TpoMov     /*  Tipo H = TRUE */
    THEN ASSIGN cb-acmd.DbeMn1[ cbd-stack.NroMes + 1 ] = 
                cb-acmd.DbeMn1[ cbd-stack.NroMes + 1 ] - cbd-stack.ImpMn1
                cb-acmd.DbeMn2[ cbd-stack.NroMes + 1 ] = 
                cb-acmd.DbeMn2[ cbd-stack.NroMes + 1 ] - cbd-stack.ImpMn2
                cb-acmd.DbeMn3[ cbd-stack.NroMes + 1 ] = 
                cb-acmd.DbeMn3[ cbd-stack.NroMes + 1 ] - cbd-stack.ImpMn3.
    ELSE ASSIGN cb-acmd.HbeMn1[ cbd-stack.NroMes + 1 ] = 
                cb-acmd.HbeMn1[ cbd-stack.NroMes + 1 ] - cbd-stack.ImpMn1
                cb-acmd.HbeMn2[ cbd-stack.NroMes + 1 ] = 
                cb-acmd.HbeMn2[ cbd-stack.NroMes + 1 ] - cbd-stack.ImpMn2
                cb-acmd.HbeMn3[ cbd-stack.NroMes + 1 ] = 
                cb-acmd.HbeMn3[ cbd-stack.NroMes + 1 ] - cbd-stack.ImpMn3.
    RELEASE cb-acmd.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Acumula W-maestro 
PROCEDURE Acumula :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    IF cb-dmov.TpoMov THEN     /* Tipo H */
        ASSIGN  cb-cmov.HbeMn1 = cb-cmov.HbeMn1 + cb-dmov.ImpMn1
                cb-cmov.HbeMn2 = cb-cmov.HbeMn2 + cb-dmov.ImpMn2
                cb-cmov.HbeMn3 = cb-cmov.HbeMn3 + cb-dmov.ImpMn3.
    ELSE 
        ASSIGN cb-cmov.DbeMn1 = cb-cmov.DbeMn1 + cb-dmov.ImpMn1
               cb-cmov.DbeMn2 = cb-cmov.DbeMn2 + cb-dmov.ImpMn2
               cb-cmov.DbeMn3 = cb-cmov.DbeMn3 + cb-dmov.ImpMn3.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE add-cmov W-maestro 
PROCEDURE add-cmov :
/* -----------------------------------------------------------
    Creacion de la cabecera de movimientos
-------------------------------------------------------------*/
DO ON ENDKEY UNDO, LEAVE ON STOP UNDO, LEAVE ON ERROR UNDO,LEAVE:
    CREATE cb-cmov.
    RECID-cab = RECID( cb-cmov ). 
    ASSIGN cb-cmov.CodCia  = s-codcia
        cb-cmov.Periodo = s-periodo
        cb-cmov.NroMes  = s-NroMes
        cb-cmov.CodOpe  = x-CodOpe
        cb-cmov.NroAst  = STRING(x-NroAst,"999999")
        cb-cmov.FchAst  = TODAY
        cb-cmov.Usuario = s-user-id.
    /* Voucher atrazados colocamos el ultimo dia del mes como fecha de registro */
    IF YEAR( TODAY ) <> s-periodo OR MONTH( TODAY ) <> s-NroMes
    THEN IF s-NroMes = 12
         THEN cb-cmov.FchAst  = DATE( 1, 1, s-periodo + 1) - 1.
         ELSE cb-cmov.FchAst  = DATE( s-NroMes + 1, 1, s-periodo) - 1.
    /* Buscando el Tipo de Cambio que le corresponde */
    FIND gn-tcmb WHERE gn-tcmb.FECHA = TODAY NO-LOCK NO-ERROR.
    IF AVAILABLE gn-tcmb THEN
        IF cb-oper.TpoCmb = 1 THEN
            cb-cmov.TpoCmb = gn-tcmb.Compra.
        ELSE cb-cmov.TpoCmb = gn-tcmb.Venta.
    RUN Pintado.
        
    CASE cb-oper.CodMon:
         WHEN 1 THEN DO:
             x-CodMon = 1.
             DISABLE moneda.
         END.
        WHEN 2 THEN DO:
            x-CodMon = 2.
            DISABLE moneda.
        END.    
    END CASE. 

    CASE x-CodMon :
        WHEN 1 THEN ASSIGN Moneda = "Soles"   x-CodMon = 1.
        WHEN 2 THEN ASSIGN Moneda = "Dólares" x-CodMon = 2.
        OTHERWISE   ASSIGN Moneda = "Soles"   x-CodMon = 1.
    END CASE.
    DISPLAY Moneda WITH FRAME F-maestro.
        
    ENABLE cb-cmov.Fchast
        cb-cmov.Nrovou
        cb-cmov.Tpocmb 
        cb-cmov.Notast
        cb-cmov.GloAst
        BRW-DETALLE
        b-d-add
        b-d-update
        b-d-delete
        BUTTON-3
        b-d-suma
        WITH FRAME F-maestro.
     IF cb-cfga.CodDiv THEN ENABLE cb-cmov.coddiv WITH FRAME F-maestro.
     ELSE  DO:
        DISABLE cb-cmov.coddiv WITH FRAME F-maestro.
     END.   
     IF cb-oper.resume THEN ENABLE cb-cmov.C-Fcaja WITH FRAME F-maestro.
     ELSE DO:
        DISABLE cb-cmov.C-Fcaja WITH FRAME F-maestro.
     END.   
     
    APPLY "ENTRY" TO cb-cmov.Fchast IN FRAME F-maestro.  
    WAIT-FOR CHOOSE OF b-ok IN FRAME F-add, b-Cancel IN FRAME F-add.
    IF LAST-EVENT:FUNCTION = "END-ERROR" OR RECID-cab = ?
    THEN UNDO, LEAVE.
END.

IF LAST-EVENT:FUNCTION = "END-ERROR" OR RECID-cab = ?
THEN DO:
    FIND {&FIRST-TABLE-IN-QUERY-F-maestro}
        WHERE RECID-cab = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} )EXCLUSIVE NO-ERROR.
    
    IF AVAILABLE {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
        DELETE {&FIRST-TABLE-IN-QUERY-F-maestro}.
        CLEAR FRAME f-maestro.
    END.
   
    /* Anulando el correlativo incrementado */
END.

FIND {&FIRST-TABLE-IN-QUERY-F-maestro}
    WHERE RECID-cab = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} )NO-LOCK NO-ERROR.
IF NOT AVAILABLE {&FIRST-TABLE-IN-QUERY-F-maestro}
   THEN CLEAR FRAME f-maestro.
DISABLE cb-cmov.Fchast Moneda Nrovou cb-cmov.Tpocmb cb-cmov.Notast cb-cmov.GloAst
        cb-cmov.C-FCAJA
        b-d-add b-d-update b-d-delete BUTTON-3 b-d-suma WITH FRAME F-maestro.

IF cb-cfga.CodDiv THEN DISABLE cb-cmov.coddiv WITH FRAME F-maestro.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE automaticas-1 W-maestro 
PROCEDURE automaticas-1 :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
/* Borrando las cuentas autom ticas generadas antes */ 
FOR EACH DETALLE WHERE DETALLE.Relacion = RegAct:
    RUN GrabaAnt-det.
    IF DETALLE.TpoMov THEN     /* Tipo H */
        ASSIGN cb-cmov.HbeMn1 = cb-cmov.HbeMn1 - DETALLE.ImpMn1
               cb-cmov.HbeMn2 = cb-cmov.HbeMn2 - DETALLE.ImpMn2
               cb-cmov.HbeMn3 = cb-cmov.HbeMn3 - DETALLE.ImpMn3.
    ELSE 
        ASSIGN cb-cmov.DbeMn1 = cb-cmov.DbeMn1 - DETALLE.ImpMn1
               cb-cmov.DbeMn2 = cb-cmov.DbeMn2 - DETALLE.ImpMn2
               cb-cmov.DbeMn2 = cb-cmov.DbeMn3 - DETALLE.ImpMn3.
    DELETE DETALLE.
END.

/* Generando las cuentas autom ticas */
IF cb-dmov.CtrCta <> "" THEN DO:
    FIND integral.cb-ctas WHERE integral.cb-ctas.CodCia = cb-codcia
                        AND integral.cb-ctas.CodCta = cb-dmov.CodCta
                        NO-LOCK NO-ERROR.
    ASSIGN x-ImpMn1 = cb-dmov.ImpMn1
           x-ImpMn2 = cb-dmov.ImpMn2
           x-ImpMn3 = cb-dmov.ImpMn3
           RECID-stack = 0.

        IF cb-dmov.CtaAut <> ""
        THEN DO:
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
                   DETALLE.NroItm   = cb-dmov.NroItm
                   DETALLE.Codcta   = cb-dmov.CtaAut
                   DETALLE.CodDiv   = cb-dmov.CodDiv
                   DETALLE.ClfAux   = cb-dmov.ClfAux
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
                   DETALLE.ImpMn1   = cb-dmov.ImpMn1
                   DETALLE.ImpMn2   = cb-dmov.ImpMn2
                   DETALLE.ImpMn3   = cb-dmov.ImpMn3
                   DETALLE.Tm       = cb-dmov.Tm
                   DETALLE.CCO      = cb-dmov.CCO.
           RECID-stack = RECID( DETALLE ).
   
           IF DETALLE.TpoMov THEN     /* Tipo H */
                ASSIGN  cb-cmov.HbeMn1 = cb-cmov.HbeMn1 + DETALLE.ImpMn1
                        cb-cmov.HbeMn2 = cb-cmov.HbeMn2 + DETALLE.ImpMn2
                        cb-cmov.HbeMn3 = cb-cmov.HbeMn3 + DETALLE.ImpMn3.
           ELSE 
                ASSIGN cb-cmov.DbeMn1 = cb-cmov.DbeMn1 + DETALLE.ImpMn1
                       cb-cmov.DbeMn2 = cb-cmov.DbeMn2 + DETALLE.ImpMn2
                       cb-cmov.DbeMn3 = cb-cmov.DbeMn3 + DETALLE.ImpMn3.
        END
        .
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
           DETALLE.NroItm   = cb-dmov.NroItm
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
           DETALLE.ImpMn3   = cb-dmov.ImpMn3
           DETALLE.NroRef   = cb-dmov.NroRef
           DETALLE.FchDoc   = cb-dmov.FchDoc
           DETALLE.FchVto   = cb-dmov.FchVto
           DETALLE.Tm       = cb-dmov.Tm
           DETALLE.CCO      = cb-dmov.CCO.
   /* RUN cbd/cb-acmd.p(RECID(DETALLE), YES ,YES). 
      ERROR
   */
    IF DETALLE.TpoMov THEN     /* Tipo H */
        ASSIGN  cb-cmov.HbeMn1 = cb-cmov.HbeMn1 + DETALLE.ImpMn1
                cb-cmov.HbeMn2 = cb-cmov.HbeMn2 + DETALLE.ImpMn2
                cb-cmov.HbeMn3 = cb-cmov.HbeMn3 + DETALLE.ImpMn3.
    ELSE 
        ASSIGN cb-cmov.DbeMn1 = cb-cmov.DbeMn1 + DETALLE.ImpMn1
               cb-cmov.DbeMn2 = cb-cmov.DbeMn2 + DETALLE.ImpMn2
               cb-cmov.DbeMn3 = cb-cmov.DbeMn3 + DETALLE.ImpMn3.
END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cabecera W-maestro 
PROCEDURE cabecera :
DEFINE VARIABLE x-nom-ope AS CHARACTER FORMAT "x(40)".
    x-nomope = cb-oper.nomope.
    PUT STREAM report CONTROL "~017" NULL "~040".
    PUT integral.Empresas.NomCia.
    PUT STREAM report CONTROL "~040" NULL "~017".
    PUT cb-cmov.nroast AT 60 SKIP.
    PUT "( " cb-cmov.codope " ) " x-nom-ope.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cbd-stack-act W-maestro 
PROCEDURE cbd-stack-act :
DEFINE PARAMETER BUFFER CBD-STACK FOR CBD-STACK.
DEFINE VARIABLE x-codcta LIKE cbd-stack.CodCta.
DEFINE VARIABLE x-coddiv LIKE cbd-stack.CodDiv.
DEFINE VARIABLE i             AS INTEGER.

/*
FIND FIRST cp-tpro WHERE cp-tpro.CodCia = cb-codcia AND
    cp-tpro.Codcta = cbd-stack.CodCta NO-LOCK NO-ERROR.
IF AVAILABLE cp-tpro THEN DO:
   FIND CtaCte-Pgo WHERE 
        CtaCte-Pgo.CodCia  = cbd-stack.CodCia  AND
        CtaCte-Pgo.Periodo = cbd-stack.Periodo AND
        CtaCte-Pgo.CodCta  = cbd-stack.CodCta  AND
        CtaCte-Pgo.CodCta  = cbd-stack.CodCta  AND
        CtaCte-Pgo.CodDiv  = cbd-stack.CodDiv  AND
        CtaCte-Pgo.NroDoc  = cbd-stack.NroDoc  AND
        CtaCte-Pgo.CodAux  = cbd-stack.CodAux NO-ERROR.
    IF NOT AVAILABLE CtaCte-Pgo
    THEN DO:
      /*  RMT : 25/02/96 
                No puedo crear cuenta corriente de algo que
                no encuentro
      */          
      /*  CREATE CtaCte-Pgo.
        ASSIGN CtaCte-Pgo.CodCia  = cbd-stack.CodCia
               CtaCte-Pgo.Periodo = cbd-stack.Periodo
               CtaCte-Pgo.CodCta  = cbd-stack.CodCta
               CtaCte-Pgo.CodAux  = cbd-stack.CodAux
               CtaCte-Pgo.CodDoc  = cbd-stack.CodDoc
               CtaCte-Pgo.NroDoc  = cbd-stack.NroDoc
               CtaCte-Pgo.ClfAux  = cbd-stack.ClfAux
               CtaCte-Pgo.CodMon  = cbd-stack.CodMon
               CtaCte-Pgo.FchDoc  = cbd-stack.FchDoc
               CtaCte-Pgo.FchVto  = cbd-stack.FchVto
               CtaCte-Pgo.ImpMn1  = cbd-stack.ImpMn1
               CtaCte-Pgo.ImpMn2  = cbd-stack.ImpMn2
               CtaCte-Pgo.ImpMn3  = cbd-stack.ImpMn3
               CtaCte-Pgo.FlgCan  = "P".  
       */        
    END.
    ELSE DO:
        FIND FIRST cp-tpro WHERE cp-tpro.CodCia = cb-codcia AND
            cp-tpro.CodCTA = cbd-stack.CodCta AND
            cp-tpro.CodOpe = cbd-stack.CodOpe NO-LOCK NO-ERROR.
        IF AVAILABLE cp-tpro
        THEN ASSIGN
            CtaCte-Pgo.ClfAux = cbd-stack.ClfAux
            CtaCte-Pgo.CodMon = cbd-stack.CodMon
            CtaCte-Pgo.FchDoc = cbd-stack.FchDoc
            CtaCte-Pgo.FchVto = cbd-stack.FchVto
            CtaCte-Pgo.ImpMn1 = cbd-stack.ImpMn1
            CtaCte-Pgo.ImpMn2 = cbd-stack.ImpMn2
            CtaCte-Pgo.ImpMn3 = cbd-stack.ImpMn3.
    END.
    IF NOT cbd-stack.TpoMov      /*  Tipo H = TRUE   */
    THEN ASSIGN
        CtaCte-Pgo.SdoMn1 = CtaCte-Pgo.SdoMn1
                                     - cbd-stack.ImpMn1
        CtaCte-Pgo.SdoMn2 = CtaCte-Pgo.SdoMn2
                                     - cbd-stack.ImpMn2
        CtaCte-Pgo.SdoMn3 = CtaCte-Pgo.SdoMn3
                                     - cbd-stack.ImpMn3.
    ELSE ASSIGN
        CtaCte-Pgo.SdoMn1 = CtaCte-Pgo.SdoMn1
                                     + cbd-stack.ImpMn1
        CtaCte-Pgo.SdoMn2 = CtaCte-Pgo.SdoMn2
                                     + cbd-stack.ImpMn2
        CtaCte-Pgo.SdoMn3 = CtaCte-Pgo.SdoMn3
                                     + cbd-stack.ImpMn3.
    /* Cancelando la Cuenta Corriente */
    CASE CtaCte-Pgo.CodMon:
        WHEN 1 THEN
            IF CtaCte-Pgo.SdoMn1 = 0 THEN DO:
                IF CtaCte-Pgo.ImpMn1 = 0 THEN
                    ASSIGN CtaCte-Pgo.FlgCan = "A".
                ELSE ASSIGN CtaCte-Pgo.FlgCan = "C".
            END.
            ELSE ASSIGN CtaCte-Pgo.FlgCan = "P".
        WHEN 2 THEN
            IF CtaCte-Pgo.SdoMn2 = 0 THEN DO:
                IF CtaCte-Pgo.ImpMn2 = 0 THEN
                    ASSIGN CtaCte-Pgo.FlgCan = "A".
                ELSE ASSIGN CtaCte-Pgo.FlgCan = "C".
            END.
            ELSE ASSIGN CtaCte-Pgo.FlgCan = "P".
        WHEN 3 THEN
            IF CtaCte-Pgo.SdoMn3 = 0 THEN DO:
                IF CtaCte-Pgo.ImpMn3 = 0 THEN
                    ASSIGN CtaCte-Pgo.FlgCan = "A".
                ELSE ASSIGN CtaCte-Pgo.FlgCan = "C".
            END.
            ELSE ASSIGN CtaCte-Pgo.FlgCan = "P". 
    END CASE.
END.
*/

/* Des-Actualizando el nivel de movimiento */
x-codcta = cbd-stack.CodCta.
x-coddiv = cbd-stack.CodDiv.
/*Por Divisi¢n */

RUN ACTUALIZA(BUFFER CBD-STACK,X-CODDIV,X-CODCTA).
 
IF x-coddiv <> "" THEN DO:
   x-coddiv = "".
   RUN ACTUALIZA(BUFFER CBD-STACK,X-CODDIV,X-CODCTA).
END.
/* Des-Actualizando niveles anteriores */
    x-coddiv = "".
    REPEAT i = NUM-ENTRIES( cb-niveles ) TO 1 BY -1 :
        IF LENGTH( x-codcta ) > INTEGER( ENTRY( i, cb-niveles) )
        THEN DO:
            x-codcta = SUBSTR( x-CodCta, 1, INTEGER( ENTRY( i, cb-niveles) ) ).
            RUN ACTUALIZA(BUFFER CBD-STACK,X-CODDIV,X-CODCTA).
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE check-cmov W-maestro 
PROCEDURE check-cmov :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    RETURN "OK.".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Del-Acumula W-maestro 
PROCEDURE Del-Acumula :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    IF cb-dmov.TpoMov THEN     /* Tipo H */
        ASSIGN  cb-cmov.HbeMn1 = cb-cmov.HbeMn1 - cb-dmov.ImpMn1
                cb-cmov.HbeMn2 = cb-cmov.HbeMn2 - cb-dmov.ImpMn2
                cb-cmov.HbeMn3 = cb-cmov.HbeMn3 - cb-dmov.ImpMn3.
    ELSE 
        ASSIGN cb-cmov.DbeMn1 = cb-cmov.DbeMn1 - cb-dmov.ImpMn1
               cb-cmov.DbeMn2 = cb-cmov.DbeMn2 - cb-dmov.ImpMn2
               cb-cmov.HbeMn3 = cb-cmov.HbeMn3 - cb-dmov.ImpMn3.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Delete-Dmov W-maestro 
PROCEDURE Delete-Dmov :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    RegAct = RECID(cb-dmov).
    FIND cb-dmov WHERE RECID(cb-dmov) = RegAct EXCLUSIVE.
    RUN Del-Acumula.
    RUN GrabaAnt.
    DELETE cb-dmov.
    FOR EACH cb-dmov WHERE cb-dmov.Relacion = RegAct:
        RUN Del-Acumula.
        RUN GrabaAnt.
        DELETE cb-dmov.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Dif-Redondeo W-maestro 
PROCEDURE Dif-Redondeo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER I-Mon AS INTEGER.
   
   DEFINE VARIABLE CtaRnd AS CHAR NO-UNDO.
   DEFINE VARIABLE AuxRnd AS CHAR NO-UNDO.
   DEFINE VARIABLE CcoRnd AS CHAR NO-UNDO.
   
   FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia AND
        cb-cfgg.Codcfg = "RND" NO-LOCK NO-ERROR.
   IF NOT AVAILABLE cb-cfgg THEN
      FIND cb-cfgg WHERE cb-cfgg.CodCia = S-CodCia AND
           cb-cfgg.Codcfg = "RND" NO-LOCK NO-ERROR.
   IF NOT AVAILABLE cb-cfgg THEN RETURN.
   
   IF I-Mon = 1 THEN DO :
      IF (cb-cmov.DbeMn1 - cb-cmov.HbeMn1) < 0 THEN DO :
         CtaRnd = cb-cfgg.codcta[1].  /* PERDIDA  */
         AuxRnd = cb-cfgg.codAux[1].  /* PERDIDA  */
         CcoRnd = cb-cfgg.Cco[1].  /* PERDIDA  */
      END.   
      ELSE DO :
         CtaRnd = cb-cfgg.codcta[2]. /* GANANCIA */
         AuxRnd = cb-cfgg.codAux[2]. /* GANANCIA */
         CcoRnd = cb-cfgg.Cco[2].    /* GANANCIA */
      END.
      IF cb-cmov.DbeMn1 - cb-cmov.HbeMn1 = 0 THEN RETURN.
   END.
   ELSE DO :
     IF (cb-cmov.DbeMn2 - cb-cmov.HbeMn2) < 0 THEN DO :
         CtaRnd = cb-cfgg.codcta[1].  /* PERDIDA  */
         AuxRnd = cb-cfgg.codAux[1].  /* PERDIDA  */
         CcoRnd = cb-cfgg.Cco[1].  /* PERDIDA  */
     END.   
     ELSE DO :
         CtaRnd = cb-cfgg.codcta[2]. /* GANANCIA */
         AuxRnd = cb-cfgg.codAux[2]. /* GANANCIA */
         CcoRnd = cb-cfgg.Cco[2].    /* GANANCIA */
     END.
     IF cb-cmov.DbeMn2 - cb-cmov.HbeMn2 = 0 THEN RETURN.
   END.
   
   FIND cb-ctas WHERE cb-ctas.CodCia = cb-CodCia AND
                      cb-ctas.CodCta = CtaRnd NO-LOCK NO-ERROR.
   
   X-NroItm = cb-cmov.Totitm.
   X-NroItm = X-NroItm + 1.
   CREATE detalle.
   detalle.CodCia  = S-CodCia. 
   detalle.NroMes  = S-NroMes. 
   detalle.Periodo = S-PERIODO.
   detalle.Codope  = cb-cmov.Codope.
   detalle.NroAst  = cb-cmov.NroAst.
   detalle.Codcta  = CtaRnd.
   detalle.ClfAux  = cb-ctas.ClfAux.
   detalle.CodAux  = AuxRnd.
   detalle.Cco     = CcoRnd.
   detalle.CodDiv  = cb-cmov.CodDiv.
   detalle.Codmon  = I-Mon.
   detalle.TpoItm  = "R".
   detalle.flgact  = YES.
   IF CtaRnd = cb-cfgg.codcta[2] THEN 
        detalle.Glodoc  = "Ganancia por Redondeo". 
   ELSE detalle.Glodoc  = "Perdida por Redondeo". 
   detalle.Tpocmb  = 0.
   IF I-Mon = 1 THEN 
        ASSIGN detalle.ImpMn1  = ABSOLUTE(cb-cmov.DbeMn1 - cb-cmov.HbeMn1)
               detalle.ImpMn2  = 0
               detalle.TpoMov  = (cb-cmov.DbeMn1 > cb-cmov.HbeMn1).
   ELSE ASSIGN detalle.ImpMn2  = ABSOLUTE(cb-cmov.DbeMn2 - cb-cmov.HbeMn2)
               detalle.ImpMn1  = 0
               detalle.TpoMov  = (cb-cmov.DbeMn2 > cb-cmov.HbeMn2).
   detalle.ImpMn3  = 0.
   detalle.TM      = cb-ctas.TM.
   detalle.NroItm  = X-NroItm.

   IF detalle.TpoMov THEN cb-cmov.HbeMn1 = cb-cmov.HbeMn1 + detalle.ImpMn1.
   ELSE cb-cmov.DbeMn1 = cb-cmov.DbeMn1 + detalle.ImpMn1.
   IF detalle.TpoMov THEN cb-cmov.HbeMn2 = cb-cmov.HbeMn2 + detalle.ImpMn2.
   ELSE cb-cmov.DbeMn2 = cb-cmov.DbeMn2 + detalle.ImpMn2.
      
   FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                      cb-ctas.CodCta = detalle.CodCta NO-LOCK NO-ERROR.      

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DUPLICA W-maestro 
PROCEDURE DUPLICA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
         CREATE DETALLE.
         ASSIGN
         detalle.CodCia   = cb-dmov.CodCia 
         detalle.Periodo  = cb-dmov.Periodo 
         detalle.NroMes   = cb-dmov.NroMes 
         detalle.Codope   = cb-dmov.Codope 
         detalle.Nroast   = cb-dmov.Nroast
         detalle.cco      = cb-dmov.cco 
         detalle.Clfaux   = cb-dmov.Clfaux
         detalle.Codaux   = cb-dmov.Codaux  
         detalle.Codcta   = cb-dmov.Codcta 
         detalle.CodDiv   = cb-dmov.CodDiv 
         detalle.Coddoc   = cb-dmov.Coddoc 
         detalle.Codmon   = cb-dmov.Codmon 
         detalle.CtaAut   = cb-dmov.CtaAut 
         detalle.CtrCta   = cb-dmov.CtrCta 
         detalle.Fchdoc   = cb-dmov.Fchdoc 
         detalle.Fchvto   = cb-dmov.Fchvto 
         detalle.Glodoc   = cb-dmov.Glodoc 
         detalle.ImpMn1   = cb-dmov.ImpMn1 
         detalle.ImpMn2   = cb-dmov.ImpMn2 
         detalle.ImpMn3   = cb-dmov.ImpMn3 
         detalle.Nrodoc   = cb-dmov.Nrodoc 
         detalle.Nroitm   = cb-dmov.Nroitm 
         detalle.Nroref   = cb-dmov.Nroref 
         detalle.Nroruc   = cb-dmov.Nroruc 
         detalle.c-fcaja  = cb-dmov.c-fcaja
         detalle.tm       = cb-dmov.tm 
         detalle.Tpocmb   = cb-dmov.Tpocmb 
         detalle.TpoItm   = cb-dmov.TpoItm 
         detalle.TpoMov   = cb-dmov.TpoMov.                                 


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
  DISPLAY Moneda 
      WITH FRAME F-maestro IN WINDOW W-maestro.
  IF AVAILABLE cb-cmov THEN 
    DISPLAY cb-cmov.NroAst cb-cmov.NroVou cb-cmov.FchAst cb-cmov.TpoCmb 
          cb-cmov.CodDiv cb-cmov.C-FCaja cb-cmov.NotAst cb-cmov.GloAst 
          cb-cmov.TotItm cb-cmov.DbeMn1 cb-cmov.DbeMn2 cb-cmov.NroTra 
          cb-cmov.HbeMn1 cb-cmov.HbeMn2 
      WITH FRAME F-maestro IN WINDOW W-maestro.
  ENABLE BRW-DETALLE BUTTON-4 B-impresoras cb-cmov.NroTra 
      WITH FRAME F-maestro IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-maestro}
  ENABLE R-modify B-query B-add B-update B-delete BUTTON-2 B-Imprimir B-first 
         B-prev B-next B-last B-browse B-exit 
      WITH FRAME F-ctrl-frame IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-ctrl-frame}
  ENABLE R-navigaate-2 B-ok B-Cancel 
      WITH FRAME F-add IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-add}
  ENABLE R-navigaate-4 B-ok-3 B-Cancel-3 
      WITH FRAME F-search IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-search}
  ENABLE R-navigaate-3 B-ok-2 B-Cancel-2 
      WITH FRAME F-update IN WINDOW W-maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-update}
  VIEW W-maestro.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GENERA-IGV W-maestro 
PROCEDURE GENERA-IGV :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR P-CODCTA AS CHAR.
P-CODCTA = "".
BLOQUE:
FOR EACH cb-cfgg NO-LOCK WHERE cb-cfgg.CODCIA = cb-codcia AND
                              LOOKUP(cb-cfgg.CODCFG ,"R01,R02") > 0 :
  IF  LOOKUP(cb-dmov.CODOPE, cb-cfgg.CODOPE) > 0                  
     THEN DO:
          P-CODCTA = ENTRY(1,cb-cfgg.CODAUX[1]).
          LEAVE BLOQUE.
          END.
    
END.
IF P-CODCTA = "" THEN DO:
   MESSAGE "No configura la cuenta de I.G.V para " skip
           "esta operaci¢n"
           VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.        
END.

find cb-ctas WHERE cb-ctas.CODCTA = p-codcta NO-LOCK NO-ERROR.
IF NOT avail cb-ctas THEN DO:
   MESSAGE "Cuenta de IGV" 
           "no registrada en plan de cuentas"
           VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.        
END.

         CREATE DETALLE.
         ASSIGN
         detalle.CodCia   = cb-dmov.CodCia 
         detalle.Periodo  = cb-dmov.Periodo 
         detalle.NroMes   = cb-dmov.NroMes 
         detalle.Codope   = cb-dmov.Codope 
         detalle.Nroast   = cb-dmov.Nroast
         detalle.CodDiv   = cb-dmov.CodDiv 
         detalle.Codmon   = cb-dmov.Codmon 
         detalle.CtaAut   = cb-dmov.CtaAut 
         detalle.CtrCta   = cb-dmov.CtrCta
         detalle.Glodoc   = cb-dmov.Glodoc  
         detalle.Nroruc   = cb-dmov.Nroruc 
         detalle.tm       = cb-dmov.tm 
         detalle.Tpocmb   = cb-dmov.Tpocmb 
         detalle.TpoItm   = cb-dmov.TpoItm 
         detalle.TpoMov   = FALSE
         detalle.Nroitm   = cb-dmov.Nroitm. 
         IF cb-oper.RESUME THEN 
                                ASSIGN detalle.c-fcaja  = cb-dmov.c-fcaja.
         IF cb-ctas.PIDCCO THEN ASSIGN detalle.cco      = cb-dmov.cco .
         IF cb-ctas.PIDAUX THEN ASSIGN detalle.Clfaux   = cb-dmov.Clfaux
                                       detalle.Codaux   = cb-dmov.Codaux.  
         IF cb-ctas.PIDDOC THEN ASSIGN detalle.Coddoc   = cb-dmov.Coddoc 
                                       detalle.Fchdoc   = cb-dmov.Fchdoc 
                                       detalle.Fchvto   = cb-dmov.Fchvto
                                       detalle.Nrodoc   = cb-dmov.Nrodoc . 
         IF cb-ctas.PIDREF THEN ASSIGN detalle.Nroref   = cb-dmov.Nroref. 
         detalle.Codcta   = p-codcta.
         IF cb-dmov.CODCTA BEGINS "421" THEN 
         ASSIGN  detalle.ImpMn1   = cb-dmov.ImpMn1 * 18 / 118 
                 detalle.ImpMn2   = cb-dmov.ImpMn2 * 18 / 118.
                 
         ELSE    ASSIGN  detalle.ImpMn1   = cb-dmov.ImpMn1 * 18 / 100 
                         detalle.ImpMn2   = cb-dmov.ImpMn2 * 18 / 100.
                 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GrabaAnt W-maestro 
PROCEDURE GrabaAnt :
IF NOT cb-dmov.flgact THEN RETURN.
CREATE CBD-STACK.
ASSIGN CBD-STACK.Codaux = cb-dmov.Codaux
       CBD-STACK.CodCia = cb-dmov.CodCia
       CBD-STACK.Codcta = cb-dmov.Codcta
       CBD-STACK.CodDiv = cb-dmov.CodDiv
       CBD-STACK.Coddoc = cb-dmov.Coddoc 
       CBD-STACK.Codmon = cb-dmov.Codmon
       CBD-STACK.Codope = cb-dmov.Codope
       CBD-STACK.Ctrcta = cb-dmov.Ctrcta
       CBD-STACK.Fchdoc = cb-dmov.Fchdoc
       CBD-STACK.ImpMn1 = cb-dmov.ImpMn1
       CBD-STACK.ImpMn2 = cb-dmov.ImpMn2
       CBD-STACK.ImpMn3 = cb-dmov.ImpMn3
       CBD-STACK.Nroast = cb-dmov.Nroast
       CBD-STACK.Nrodoc = cb-dmov.Nrodoc
       CBD-STACK.NroMes = cb-dmov.NroMes
       CBD-STACK.Periodo = cb-dmov.Periodo
       CBD-STACK.recid-mov = RECID(cb-dmov)
       CBD-STACK.Tpocmb = cb-dmov.Tpocmb
       CBD-STACK.TpoItm = cb-dmov.TpoItm
       CBD-STACK.TpoMov = cb-dmov.TpoMov.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GrabaAnt-Det W-maestro 
PROCEDURE GrabaAnt-Det :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
IF NOT detalle.flgact THEN RETURN.
CREATE CBD-STACK.
ASSIGN CBD-STACK.Codaux = detalle.Codaux
       CBD-STACK.CodCia = detalle.CodCia
       CBD-STACK.Codcta = detalle.Codcta
       CBD-STACK.CodDiv = detalle.CodDiv
       CBD-STACK.Coddoc = detalle.Coddoc 
       CBD-STACK.Codmon = detalle.Codmon
       CBD-STACK.Codope = detalle.Codope
       CBD-STACK.Ctrcta = detalle.Ctrcta
       CBD-STACK.Fchdoc = detalle.Fchdoc
       CBD-STACK.ImpMn1 = detalle.ImpMn1
       CBD-STACK.ImpMn2 = detalle.ImpMn2
       CBD-STACK.ImpMn3 = detalle.ImpMn3
       CBD-STACK.Nroast = detalle.Nroast
       CBD-STACK.Nrodoc = detalle.Nrodoc
       CBD-STACK.NroMes = detalle.NroMes
       CBD-STACK.Periodo = detalle.Periodo
       CBD-STACK.recid-mov = RECID(detalle)
       CBD-STACK.Tpocmb = detalle.Tpocmb
       CBD-STACK.TpoItm = detalle.TpoItm
       CBD-STACK.TpoMov = detalle.TpoMov.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime W-maestro 
PROCEDURE imprime :
DEFINE INPUT PARAMETER F-CUENTAS AS Integer.
    /* 1 todas las cuentas
       2 eliminar las automaticas
     */
    DEF VAR X-IMPRESO AS CHAR FORMAT "X(20)".
    X-IMPRESO = STRING(TIME,"HH:MM AM") + "-" + STRING(TODAY,"99/99/9999").
    DEFINE var X-PAG AS CHAR FORMAT "999". 
    DEFINE VARIABLE x-filtro   AS CHAR.   
    DEFINE VARIABLE x-glodoc   AS CHARACTER FORMAT "X(35)".
    DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
    DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
    DEFINE VARIABLE x-fecha    AS DATE FORMAT "99/99/9999" INITIAL TODAY.
    DEFINE VARIABLE x-codmon   AS INTEGER INITIAL 1.
    DEFINE VARIABLE x-con-reg  AS INTEGER.
    DEFINE VARIABLE x-nom-ope  AS CHARACTER FORMAT "x(40)".
    DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)".
    RUN bin/_mes.p ( INPUT s-NroMes , 1,  OUTPUT pinta-mes ).
    pinta-mes = pinta-mes + " DE " + STRING( s-periodo , "9999" ).
    x-codmon = integral.cb-cmov.codmon.
    x-fecha  = integral.cb-cmov.Fchast.
  
    DEFINE FRAME f-cab
        cb-dmov.coddiv LABEL "Divis"
        cb-dmov.codcta LABEL "Cuenta"
        cb-dmov.clfaux LABEL "Clf!Aux"
        cb-dmov.codaux       LABEL "Auxiliar"
        cb-dmov.cco          LABEL "C.Cos"
        cb-dmov.nroref LABEL "Referencia"
        cb-dmov.coddoc COLUMN-LABEL "Cod!Doc."
        cb-dmov.nrodoc LABEL "Nro!Documento"
        cb-dmov.fchdoc LABEL "Fecha!Doc"
        x-glodoc       LABEL "Detalle"
        x-debe         LABEL "Cargos"
        x-haber        LABEL "Abonos"
        WITH WIDTH 160 NO-BOX STREAM-IO DOWN.
    OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 66.    
    PUT STREAM report CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(66) .
    PUT STREAM report CONTROL CHR(27) CHR(80) CHR(15).
    PUT STREAM report empresas.nomcia SKIP.
    PUT STREAM report x-nomope. 
    PUT STREAM report "ASIENTO No: " AT 50 
                      integral.cb-cmov.codope
                      "-"
                      integral.cb-cmov.nroast 
                      SKIP(1).
    PUT STREAM report pinta-mes SKIP(1).
    PUT STREAM report CONTROL CHR(27) CHR(70) CHR(27) CHR(120) 0.
    PUT STREAM report CONTROL CHR(27) CHR(80) CHR(15).
    PUT STREAM report "FECHA     : " cb-cmov.fchast.
    PUT STREAM REPORT "REFERENCIA : " AT 70 cb-cmov.NroVou SKIP.
    IF integral.cb-cmov.codmon = 1 THEN
        PUT STREAM report "MONEDA    :         S/. " SKIP.
    ELSE
        PUT STREAM report "MONEDA    :         US$ " SKIP.
    PUT STREAM report "T.CAMBIO  : " integral.cb-cmov.tpocmb SKIP.    
    PUT STREAM report "CONCEPTO  : " integral.cb-cmov.notast SKIP.
    
    PUT STREAM report CONTROL CHR(27) CHR(77) CHR(15).

    PUT STREAM report FILL("_",160) FORMAT "X(160)" SKIP.

    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = s-codcia
                    AND cb-dmov.periodo = s-periodo
                    AND cb-dmov.nromes  = s-NroMes
                    AND cb-dmov.codope  = cb-cmov.codope
                    AND cb-dmov.nroast  = cb-cmov.nroast
        BREAK BY (cb-dmov.nroast)
              BY (cb-dmov.Nroitm) ON ERROR UNDO, LEAVE:
        IF F-CUENTAS = 2 AND cb-dmov.tpoitm = "A" THEN NEXT.
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
                                  cb-dmov.cco
                                  cb-dmov.nroref
                                  cb-dmov.coddoc
                                  cb-dmov.nrodoc
                                  cb-dmov.fchdoc
                                  x-glodoc
                                  x-debe   WHEN (x-debe  <> 0)
                                  x-haber  WHEN (x-haber <> 0) 
                            WITH FRAME f-cab.

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
    DO WHILE LINE-COUNTER(report) < PAGE-SIZE(report) - 10 :
        PUT STREAM report "" skip.
    END.
    PUT STREAM report "               -----------------       -----------------       -----------------       ----------------- " SKIP.
    PUT STREAM report "                  PREPARADO                  Vo. Bo.            ADMINISTRACION             CONTADOR           Impreso:".
    PUT STREAM report x-impreso SKIP.
    
    OUTPUT STREAM report CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIME-DH W-maestro 
PROCEDURE IMPRIME-DH :
DEFINE INPUT PARAMETER F-CUENTAS AS Integer.
    /* 1 todas las cuentas
       2 eliminar las automaticas
     */
    DEF VAR X-IMPRESO AS CHAR FORMAT "X(20)".
    X-IMPRESO = STRING(TIME,"HH:MM AM") + "-" + STRING(TODAY,"99/99/9999").
    DEFINE var X-PAG AS CHAR FORMAT "999". 
    DEFINE VARIABLE x-filtro   AS CHAR.   
    DEFINE VARIABLE x-glodoc   AS CHARACTER FORMAT "X(35)".
    DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
    DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
    DEFINE VARIABLE x-fecha    AS DATE FORMAT "99/99/9999" INITIAL TODAY.
    DEFINE VARIABLE x-codmon   AS INTEGER INITIAL 1.
    DEFINE VARIABLE x-con-reg  AS INTEGER.
    DEFINE VARIABLE x-nom-ope  AS CHARACTER FORMAT "x(40)".
    DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)".
    RUN bin/_mes.p ( INPUT s-NroMes , 1,  OUTPUT pinta-mes ).
    pinta-mes = pinta-mes + " DE " + STRING( s-periodo , "9999" ).
    x-codmon = integral.cb-cmov.codmon.
    x-fecha  = integral.cb-cmov.Fchast.
  
    DEFINE FRAME f-cab
        cb-dmov.coddiv LABEL "Divis"
        cb-dmov.codcta LABEL "Cuenta"
        cb-dmov.clfaux LABEL "Clf!Aux"
        cb-dmov.codaux       LABEL "Auxiliar"
        cb-dmov.cco          LABEL "C.Cos"
        cb-dmov.nroref LABEL "Referencia"
        cb-dmov.coddoc COLUMN-LABEL "Cod!Doc."
        cb-dmov.nrodoc LABEL "Nro!Documento"
        cb-dmov.fchdoc LABEL "Fecha!Doc"
        x-glodoc       LABEL "Detalle"
        x-debe         LABEL "Cargos"
        x-haber        LABEL "Abonos"
        WITH WIDTH 160 NO-BOX STREAM-IO DOWN.
    OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 66.    
    PUT STREAM report CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(66) .
    PUT STREAM report CONTROL CHR(27) CHR(80) CHR(15).
    PUT STREAM report empresas.nomcia SKIP.
    PUT STREAM report x-nomope. 
    PUT STREAM report "ASIENTO No: " AT 50 
                      integral.cb-cmov.codope
                      "-"
                      integral.cb-cmov.nroast 
                      SKIP(1).
    PUT STREAM report pinta-mes SKIP(1).
    PUT STREAM report CONTROL CHR(27) CHR(70) CHR(27) CHR(120) 0.
    PUT STREAM report CONTROL CHR(27) CHR(80) CHR(15).
    PUT STREAM report "FECHA     : " cb-cmov.fchast SKIP.
    PUT STREAM REPORT "REFERENCIA : " AT 70 cb-cmov.NroVou SKIP.
    IF integral.cb-cmov.codmon = 1 THEN
        PUT STREAM report "MONEDA    :         S/. " SKIP.
    ELSE
        PUT STREAM report "MONEDA    :         US$ " SKIP.
    PUT STREAM report "T.CAMBIO  : " integral.cb-cmov.tpocmb SKIP.    
    PUT STREAM report "CONCEPTO  : " integral.cb-cmov.notast SKIP.
    
    PUT STREAM report CONTROL CHR(27) CHR(77) CHR(15).

    PUT STREAM report FILL("_",160) FORMAT "X(160)" SKIP.

    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = s-codcia
                    AND cb-dmov.periodo = s-periodo
                    AND cb-dmov.nromes  = s-NroMes
                    AND cb-dmov.codope  = cb-cmov.codope
                    AND cb-dmov.nroast  = cb-cmov.nroast
        BREAK BY (cb-dmov.nroast) 
              BY (cb-dmov.tpomov)
              BY (cb-dmov.Nroitm) 
        ON ERROR UNDO, LEAVE:
        IF F-CUENTAS = 2 AND cb-dmov.tpoitm = "A" THEN NEXT.
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
                                  cb-dmov.cco
                                  cb-dmov.nroref
                                  cb-dmov.coddoc
                                  cb-dmov.nrodoc
                                  cb-dmov.fchdoc
                                  x-glodoc
                                  x-debe   WHEN (x-debe  <> 0)
                                  x-haber  WHEN (x-haber <> 0) 
                            WITH FRAME f-cab.

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
    DO WHILE LINE-COUNTER(report) < PAGE-SIZE(report) - 10 :
        PUT STREAM report "" skip.
    END.
    PUT STREAM report "               -----------------       -----------------       -----------------       ----------------- " SKIP.
    PUT STREAM report "                  PREPARADO                  Vo. Bo.            ADMINISTRACION             CONTADOR           Impreso:".
    PUT STREAM report x-impreso SKIP.
    
    OUTPUT STREAM report CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIME-ORDENADO W-maestro 
PROCEDURE IMPRIME-ORDENADO :
DEFINE INPUT PARAMETER F-CUENTAS AS Integer.
    /* 1 todas las cuentas
       2 eliminar las automaticas
     */
    DEF VAR X-IMPRESO AS CHAR FORMAT "X(20)".
    X-IMPRESO = STRING(TIME,"HH:MM AM") + "-" + STRING(TODAY,"99/99/9999").
    DEFINE var X-PAG AS CHAR FORMAT "999". 
    DEFINE VARIABLE x-filtro   AS CHAR.   
    DEFINE VARIABLE x-glodoc   AS CHARACTER FORMAT "X(35)".
    DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
    DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
    DEFINE VARIABLE x-fecha    AS DATE FORMAT "99/99/9999" INITIAL TODAY.
    DEFINE VARIABLE x-codmon   AS INTEGER INITIAL 1.
    DEFINE VARIABLE x-con-reg  AS INTEGER.
    DEFINE VARIABLE x-nom-ope  AS CHARACTER FORMAT "x(40)".
    DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)".
    RUN bin/_mes.p ( INPUT s-NroMes , 1,  OUTPUT pinta-mes ).
    pinta-mes = pinta-mes + " DE " + STRING( s-periodo , "9999" ).
    x-codmon = integral.cb-cmov.codmon.
    x-fecha  = integral.cb-cmov.Fchast.
    
    DEFINE FRAME f-cab
        cb-dmov.coddiv LABEL "Divis"
        cb-dmov.codcta LABEL "Cuenta"
        cb-dmov.clfaux LABEL "Clf!Aux"
        cb-dmov.codaux       LABEL "Auxiliar"
        cb-dmov.cco          LABEL "C.Cos"
        cb-dmov.nroref LABEL "Referencia"
        cb-dmov.coddoc COLUMN-LABEL "Cod!Doc."
        cb-dmov.nrodoc LABEL "Nro!Documento"
        cb-dmov.fchdoc LABEL "Fecha!Doc"
        x-glodoc       LABEL "Detalle"
        x-debe         LABEL "Cargos"
        x-haber        LABEL "Abonos"
        WITH WIDTH 160 NO-BOX STREAM-IO DOWN.
    OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 66.    
    PUT STREAM report CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(66) .
    PUT STREAM report CONTROL CHR(27) CHR(80) CHR(15).
    PUT STREAM report empresas.nomcia SKIP.
    PUT STREAM report x-nomope. 
    PUT STREAM report "ASIENTO No: " AT 50 
                      integral.cb-cmov.codope
                      "-"
                      integral.cb-cmov.nroast 
                      SKIP(1).
    PUT STREAM report pinta-mes SKIP(1).
    PUT STREAM report CONTROL CHR(27) CHR(70) CHR(27) CHR(120) 0.
    PUT STREAM report CONTROL CHR(27) CHR(80) CHR(15).
    PUT STREAM report "FECHA     : " cb-cmov.fchast SKIP.
    PUT STREAM REPORT "REFERENCIA : " AT 70 cb-cmov.NroVou SKIP.
    IF integral.cb-cmov.codmon = 1 THEN
        PUT STREAM report "MONEDA    :         S/. " SKIP.
    ELSE
        PUT STREAM report "MONEDA    :         US$ " SKIP.
    PUT STREAM report "T.CAMBIO  : " integral.cb-cmov.tpocmb SKIP.    
    PUT STREAM report "CONCEPTO  : " integral.cb-cmov.notast SKIP.
    
    PUT STREAM report CONTROL CHR(27) CHR(77) CHR(15).
    
    PUT STREAM report FILL("_",160) FORMAT "X(160)" SKIP.

    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = s-codcia
                    AND cb-dmov.periodo = s-periodo
                    AND cb-dmov.nromes  = s-NroMes
                    AND cb-dmov.codope  = cb-cmov.codope
                    AND cb-dmov.nroast  = cb-cmov.nroast
        BREAK BY (cb-dmov.nroast) 
              BY (cb-dmov.codcta) 
              BY (cb-dmov.Nroitm)
              ON ERROR UNDO, LEAVE:
        IF F-CUENTAS = 2 AND cb-dmov.tpoitm = "A" THEN NEXT.
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
                                  cb-dmov.cco
                                  cb-dmov.nroref
                                  cb-dmov.coddoc
                                  cb-dmov.nrodoc
                                  cb-dmov.fchdoc
                                  x-glodoc
                                  x-debe   WHEN (x-debe  <> 0)
                                  x-haber  WHEN (x-haber <> 0) 
                            WITH FRAME f-cab.

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
    DO WHILE LINE-COUNTER(report) < PAGE-SIZE(report) - 10 :
        PUT STREAM report "" skip.
    END.
    PUT STREAM report "               -----------------       -----------------       -----------------       ----------------- " SKIP.
    PUT STREAM report "                  PREPARADO                  Vo. Bo.            ADMINISTRACION             CONTADOR           Impreso:".
    PUT STREAM report x-impreso SKIP.
    
    OUTPUT STREAM report CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pintado W-maestro 
PROCEDURE Pintado :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DISPLAY {&FIELDS-IN-QUERY-F-Maestro} WITH FRAME F-Maestro.
    {&OPEN-QUERY-BRW-DETALLE}
    ASSIGN Moneda = "Soles" x-CodMon = 1.
    IF AVAILABLE {&FIRST-TABLE-IN-QUERY-F-Maestro} THEN
        CASE {&FIRST-TABLE-IN-QUERY-F-Maestro}.CodMon :
            WHEN 1 THEN ASSIGN Moneda = "Soles"   x-CodMon = 1.
            WHEN 2 THEN ASSIGN Moneda = "Dólares" x-CodMon = 2.
            OTHERWISE   ASSIGN Moneda = "Soles"   x-CodMon = 1.
        END CASE.
    DISPLAY Moneda WITH FRAME F-maestro.
    IF NOT QUERY-OFF-END("BRW-detalle") AND x-CodMon <> LAST-CodMon
    THEN ASSIGN pto = BRW-detalle:MOVE-COLUMN( 7, 8 ) 
                LAST-CodMon = x-CodMon.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


