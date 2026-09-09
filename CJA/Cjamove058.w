&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Maestro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Maestro 
&IF "{&NEW}" <> "" &THEN
    DEFINE INPUT  PARAMETER p-tipo-egreso  AS CHAR.
&ELSE
    DEFINE VARIABLE p-tipo-egreso  AS CHAR  INITIAL "".
&ENDIF

DEFINE NEW SHARED VARIABLE x-codope          LIKE cb-oper.CodOpe.
DEFINE VARIABLE CON-CUENTAS AS CHAR.

DEFINE VARIABLE x-NroAst AS INTEGER NO-UNDO.
DEFINE VARIABLE x-girado AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE x-notast AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE s-nomcia AS CHAR.
DEFINE VARIABLE S-ASIGNA AS CHAR.

DEFINE {&NEW} SHARED VARIABLE  s-codcia AS INTEGER   INITIAL 999.
DEFINE {&NEW} SHARED VARIABLE  s-aplic-id AS CHARACTER INITIAL "CBD".
DEFINE VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE VARIABLE cb-codcia AS INTEGER INITIAL 0.

FIND Empresas WHERE Empresas.CodCia = s-codcia.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.
IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.

IF p-tipo-egreso = "" THEN DO :
   FOR EACH cb-oper NO-LOCK WHERE cb-oper.CodCia = cb-CodCia AND
                            cb-oper.Resume = TRUE AND 
                            (cb-oper.TipMov = "E" OR cb-oper.TipMov = "") :
       P-TIPO-EGRESO = P-TIPO-EGRESO + cb-oper.CodOpe + ",".                             
   END. 
   P-TIPO-EGRESO = SUBSTRING(P-TIPO-EGRESO, 1, LENGTH(P-TIPO-EGRESO) - 1 ).
END.
CON-CUENTAS = "".
p-tipo-egreso = "058".
X-CODOPE    = ENTRY(1,P-TIPO-EGRESO).

DEFINE NEW SHARED VARIABLE x-Nomope          LIKE cb-oper.NomOpe.
DEFINE NEW SHARED VARIABLE x-selope          AS LOGICAL.
DEFINE {&NEW} SHARED VARIABLE s-periodo          AS INTEGER INITIAL 1996.
DEFINE {&NEW} SHARED VARIABLE s-NroMes          AS INTEGER INITIAL 12.
DEFINE {&NEW} SHARED VARIABLE s-user-id       AS CHARACTER INITIAL "MASTER".
DEFINE {&NEW} SHARED VARIABLE S-ADMIN         AS LOGICAL   INITIAL NO.
DEFINE {&NEW} SHARED VARIABLE cb-niveles AS CHARACTER INITIAL "2,3,4,5".

DEFINE VARIABLE  X-CLFAUX LIKE cb-ctas.CLFAUX.

DEFINE VARIABLE x-Llave     AS CHARACTER INITIAL "" NO-UNDO.
DEFINE VARIABLE s-NroMesCie    AS LOGICAL INITIAL YES  NO-UNDO.
DEFINE VARIABLE x-ImpMn1    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE x-ImpMn2    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE x-ImpMn3    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE x-totalMN1  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE x-totalMN2  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE x-totalch1  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE x-totalch2  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE x-total1    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE x-total2    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE x-coddoc    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE x-nrodoc    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE RECID-cab   AS RECID      NO-UNDO.
DEFINE VARIABLE RECID-stack AS RECID      NO-UNDO.
DEFINE VARIABLE RECID-tmp   AS RECID      NO-UNDO.
DEFINE VARIABLE RegAct      AS RECID      NO-UNDO.
DEFINE VARIABLE x-GloDoc    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE x-GenAut    AS INTEGER    NO-UNDO.
DEFINE VARIABLE x-CodMon    AS INTEGER    NO-UNDO.
DEFINE VARIABLE LAST-CodMon AS INTEGER    NO-UNDO INITIAL 1.
DEFINE VARIABLE i           AS INTEGER    NO-UNDO.
DEFINE VARIABLE x           AS INTEGER    NO-UNDO.
DEFINE VARIABLE c           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE Lleva       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE pto         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE x-NroChq    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE x-NroItm    LIKE integral.cb-dmov.NroItm  NO-UNDO.
DEFINE VAR DcbMn1   AS DECIMAL.
DEFINE VAR DcbMn2   AS DECIMAL.
DEFINE BUFFER CABECERA FOR cb-cmov.
DEFINE BUFFER DETALLE  FOR cb-dmov.
DEFINE BUFFER BUF-AUTO FOR cb-dmov.
DEFINE STREAM report.
/* Seleccionando la Operaci¢n a Trabajar */

FIND cb-cfga WHERE cb-cfga.CodCia = cb-codcia AND cb-cfga.codcfg = 1
                   NO-LOCK NO-ERROR.

FIND cb-oper WHERE cb-oper.CodCia = cb-codcia
                   AND cb-oper.CodOpe = x-codope
                   NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-oper
THEN DO:
    MESSAGE "No Configurado la Operaci¢n" + x-codope 
             VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
x-NomOpe = integral.cb-oper.Nomope.
CON-CUENTAS = integral.cb-oper.CodCta.

DEF VAR Cta-PerDcb LIKE cb-ctas.CODCTA.
DEF VAR Cta-GanDcb LIKE cb-ctas.CODCTA.
DEF VAR Aux-PerDcb LIKE cb-dmov.CodAux.
DEF VAR Aux-GanDcb LIKE cb-dmov.CodAux.
DEF VAR CCo-PerDcb LIKE cb-dmov.CCo.
DEF VAR CCo-GanDcb LIKE cb-dmov.Cco.

DEF VAR Cta-PerTrl LIKE cb-ctas.CODCTA.
DEF VAR Cta-GanTrl LIKE cb-ctas.CODCTA.
DEF VAR Aux-PerTrl LIKE cb-dmov.CodAux.
DEF VAR Aux-GanTrl LIKE cb-dmov.CodAux.
DEF VAR CCo-PerTrl LIKE cb-dmov.CCo.
DEF VAR CCo-GanTrl LIKE cb-dmov.CCo.

/*ML01* 23/Jun/2008 ***/
DEFINE NEW SHARED VARIABLE fFchAst AS DATE NO-UNDO.

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
Aux-PerDcb = cb-cfgg.CodAux[1].
Aux-GanDcb = cb-cfgg.CodAux[2].
CCo-PerDcb = cb-cfgg.Cco[1].
CCo-GanDcb = cb-cfgg.Cco[2].

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
Aux-PerTrl = cb-cfgg.CodAux[1].
Aux-GanTrl = cb-cfgg.CodAux[2].
CCo-PerTrl = cb-cfgg.CCo[1].
CCo-GanTrl = cb-cfgg.Cco[2].

FIND cb-peri WHERE cb-peri.CodCia = s-codcia AND
    cb-peri.Periodo = s-periodo NO-LOCK.
IF AVAILABLE cb-peri
THEN s-NroMesCie = cb-peri.MesCie[s-NroMes + 1].
pto      = SESSION:SET-WAIT-STATE("").
           
DEFINE NEW SHARED TEMP-TABLE RMOV LIKE cb-dmov.

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
&Scoped-define ASSIGN-ADD cb-cmov.CodMon = x-CodMon cb-cmov.usuario = s-user-id

/* Campos que no pueden ser modificados */
&Scoped-define NO-MODIFY cb-cmov.NroAst

/* Programa donde relaizara la Consulta */
&Scoped-define q-modelo cbd/q-asto.w ( OUTPUT RECID-stack )

/* Campos por los cuales se puede hacer Busquedas */
&Scoped-define Query-Field cb-cmov.NroAst

DEF VAR F-CREAR AS LOGICAL.

DEFINE BUFFER CABEZA FOR CB-CMOV.

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
&Scoped-define FIELDS-IN-QUERY-BRW-DETALLE cb-dmov.Codcta cb-dmov.Codaux ~
cb-dmov.Coddoc cb-dmov.Nrodoc cb-dmov.Glodoc cb-dmov.TpoMov cb-dmov.ImpMn1 ~
cb-dmov.ImpMn2 cb-dmov.Tpocmb cb-dmov.ImpMn3 cb-dmov.CodDiv cb-dmov.Nroref ~
cb-dmov.Clfaux cb-dmov.TpoItm cb-dmov.flgact cb-dmov.Relacion cb-dmov.tm ~
cb-cmov.Codmon cb-dmov.cco cb-dmov.C-Fcaja 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BRW-DETALLE 
&Scoped-define FIELD-PAIRS-IN-QUERY-BRW-DETALLE
&Scoped-define OPEN-QUERY-BRW-DETALLE OPEN QUERY BRW-DETALLE FOR EACH cb-dmov WHERE TRUE /* Join to cb-cmov incomplete */ ~
      AND cb-dmov.CodCia = s-codcia ~
 AND cb-dmov.Periodo = s-periodo ~
 AND cb-dmov.NroMes = s-NroMes ~
 AND cb-dmov.Codope = x-CodOpe ~
 AND cb-dmov.Nroast = cb-cmov.Nroast:SCREEN-VALUE IN FRAME F-maestro ~
 AND cb-dmov.TpoItm <> "B" NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BRW-DETALLE cb-dmov
&Scoped-define FIRST-TABLE-IN-QUERY-BRW-DETALLE cb-dmov


/* Definitions for FRAME F-maestro                                      */
&Scoped-define FIELDS-IN-QUERY-F-maestro cb-cmov.NroAst cb-cmov.CodDiv ~
cb-cmov.CtaCja cb-cmov.CodAux cb-cmov.NroVou cb-cmov.Girado cb-cmov.NotAst ~
cb-cmov.FchAst cb-cmov.Usuario cb-cmov.CodDoc cb-cmov.NroChq cb-cmov.ImpChq ~
cb-cmov.TpoCmb cb-cmov.C-FCaja 
&Scoped-define ENABLED-FIELDS-IN-QUERY-F-maestro cb-cmov.NroAst ~
cb-cmov.CodDiv cb-cmov.CtaCja cb-cmov.CodAux cb-cmov.NroVou cb-cmov.Girado ~
cb-cmov.NotAst cb-cmov.FchAst cb-cmov.CodDoc cb-cmov.NroChq cb-cmov.TpoCmb ~
cb-cmov.C-FCaja 
&Scoped-define ENABLED-TABLES-IN-QUERY-F-maestro cb-cmov
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-F-maestro cb-cmov

&Scoped-define FIELD-PAIRS-IN-QUERY-F-maestro~
 ~{&FP1}NroAst ~{&FP2}NroAst ~{&FP3}~
 ~{&FP1}CodDiv ~{&FP2}CodDiv ~{&FP3}~
 ~{&FP1}CtaCja ~{&FP2}CtaCja ~{&FP3}~
 ~{&FP1}CodAux ~{&FP2}CodAux ~{&FP3}~
 ~{&FP1}NroVou ~{&FP2}NroVou ~{&FP3}~
 ~{&FP1}Girado ~{&FP2}Girado ~{&FP3}~
 ~{&FP1}NotAst ~{&FP2}NotAst ~{&FP3}~
 ~{&FP1}FchAst ~{&FP2}FchAst ~{&FP3}~
 ~{&FP1}CodDoc ~{&FP2}CodDoc ~{&FP3}~
 ~{&FP1}NroChq ~{&FP2}NroChq ~{&FP3}~
 ~{&FP1}TpoCmb ~{&FP2}TpoCmb ~{&FP3}~
 ~{&FP1}C-FCaja ~{&FP2}C-FCaja ~{&FP3}
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
DEFINE VAR W-Maestro AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-B-imprimir 
       MENU-ITEM m_Todas_las_Cuentas LABEL "Todas las Cuentas"
       MENU-ITEM m_Todas_las_Cuentas_Ordenado_ LABEL "Todas las Cuentas Ordenado por Cuenta".


/* Definitions of the field level widgets                               */
DEFINE BUTTON B-Cancel AUTO-END-KEY 
     LABEL "&Cancelar":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE BUTTON B-ok 
     LABEL "&Aceptar":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE RECTANGLE R-navigaate-2
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 90.57 BY 1.88
     BGCOLOR 8 FGCOLOR 15 .

DEFINE BUTTON B-add 
     LABEL "&Crear":L 
     SIZE 8.43 BY 1
     FONT 4.

DEFINE BUTTON B-browse 
     IMAGE-UP FILE "IMG/pvbrow":U
     IMAGE-DOWN FILE "IMG/pvbrowd":U
     IMAGE-INSENSITIVE FILE "IMG/pvbrowx":U
     LABEL "&Consulta" 
     SIZE 6 BY 1.62.

DEFINE BUTTON B-delete 
     LABEL "&Eliminar":L 
     SIZE 8.43 BY 1
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

DEFINE BUTTON B-imprimir 
     LABEL "&Imprimir" 
     SIZE 8.43 BY 1.

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
     SIZE 8.43 BY 1
     FONT 4.

DEFINE BUTTON B-update 
     LABEL "&Modificar":L 
     SIZE 8.43 BY 1
     FONT 4.

DEFINE BUTTON BUTTON-2 
     LABEL "Copiar" 
     SIZE 8.43 BY 1.

DEFINE RECTANGLE R-consulta
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 8 BY 2
     BGCOLOR 8 .

DEFINE RECTANGLE R-exit
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 9.57 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE BUTTON b-d-add 
     LABEL "Agregar" 
     SIZE 9.57 BY .85.

DEFINE BUTTON b-d-Asigna 
     LABEL "Asignar" 
     SIZE 9.57 BY .85.

DEFINE BUTTON b-d-delete 
     LABEL "Eliminar" 
     SIZE 9.57 BY .85.

DEFINE BUTTON b-d-update 
     LABEL "Actualizar" 
     SIZE 9.57 BY .85.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE VARIABLE C-CodOpe AS CHARACTER FORMAT "X(3)":U 
     LABEL "Operación" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS " "
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE Moneda AS CHARACTER FORMAT "X(256)":U INITIAL "Soles" 
     LABEL "Moneda" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Soles","D¢lares" 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE F-SdoCta AS DECIMAL FORMAT "(>>>,>>>,>>9.99)":U INITIAL 0 
     LABEL "Saldo de Cta." 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodOpe AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 68.29 BY .69
     FONT 0 NO-UNDO.

DEFINE VARIABLE x-NomCta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .69
     BGCOLOR 7 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE X-NOMDIV AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .69
     BGCOLOR 7 FGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 90.86 BY 13.54.

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
     SIZE 90.57 BY 2
     BGCOLOR 8 FGCOLOR 15 .

DEFINE BUTTON B-Cancel-2 AUTO-END-KEY 
     LABEL "&Cancelar":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE BUTTON B-ok-2 
     LABEL "&Aceptar":L 
     SIZE 9 BY 1
     FONT 4.

DEFINE RECTANGLE R-navigaate-3
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 90.57 BY 2
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BRW-DETALLE W-Maestro _STRUCTURED
  QUERY BRW-DETALLE NO-LOCK DISPLAY
      cb-dmov.Codcta COLUMN-LABEL "Código!cuenta"
      cb-dmov.Codaux COLUMN-LABEL "Código!auxiliar" FORMAT "x(10)"
      cb-dmov.Coddoc COLUMN-LABEL "Código!docum."
      cb-dmov.Nrodoc COLUMN-LABEL "Número de!documento" FORMAT "x(20)"
      cb-dmov.Glodoc
      cb-dmov.TpoMov
      cb-dmov.ImpMn1 COLUMN-LABEL "Importe!(Soles)"
      cb-dmov.ImpMn2 COLUMN-LABEL "Importe!(Dólares)"
      cb-dmov.Tpocmb
      cb-dmov.ImpMn3 COLUMN-LABEL "Importe(Dfcm )"
      cb-dmov.CodDiv COLUMN-LABEL "Código!división."
      cb-dmov.Nroref COLUMN-LABEL "Número de!referencia"
      cb-dmov.Clfaux COLUMN-LABEL "Clasif.!auxiliar"
      cb-dmov.TpoItm
      cb-dmov.flgact
      cb-dmov.Relacion FORMAT ">>>>>>>>>9"
      cb-dmov.tm
      cb-cmov.Codmon
      cb-dmov.cco
      cb-dmov.C-Fcaja
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 76 BY 6
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-add
     B-ok AT ROW 1.54 COL 25
     B-Cancel AT ROW 1.54 COL 58
     R-navigaate-2 AT ROW 1 COL 1
    WITH 1 DOWN OVERLAY NO-HELP 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 14.62
         SIZE 90.86 BY 2.08
         BGCOLOR 8 FGCOLOR 0 FONT 4.

DEFINE FRAME F-update
     B-ok-2 AT ROW 1.5 COL 24.29
     B-Cancel-2 AT ROW 1.5 COL 57.57
     R-navigaate-3 AT ROW 1 COL 1
    WITH 1 DOWN OVERLAY NO-HELP 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 14.61
         SIZE 90.86 BY 2.08
         BGCOLOR 8 FGCOLOR 0 FONT 4.

DEFINE FRAME F-search
     B-ok-3 AT ROW 1.54 COL 24.29
     B-Cancel-3 AT ROW 1.54 COL 57.57
     R-navigaate-4 AT ROW 1 COL 1
    WITH 1 DOWN OVERLAY NO-HELP 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 14.61
         SIZE 90.86 BY 2.08
         BGCOLOR 8 FGCOLOR 0 FONT 4.

DEFINE FRAME F-maestro
     BRW-DETALLE AT ROW 5.73 COL 2
     C-CodOpe AT ROW 1.23 COL 10.86 COLON-ALIGNED
     cb-cmov.NroAst AT ROW 2.31 COL 10.57 COLON-ALIGNED
          LABEL "Voucher"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     cb-cmov.CodDiv AT ROW 3.12 COL 10.57 COLON-ALIGNED
          LABEL "División" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     cb-cmov.CtaCja AT ROW 4 COL 10.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     cb-cmov.CodAux AT ROW 4.85 COL 10.57 COLON-ALIGNED
          LABEL "Auxiliar"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     cb-cmov.NroVou AT ROW 11.81 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .69
     cb-cmov.Girado AT ROW 12.58 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 70 BY .69
     cb-cmov.NotAst AT ROW 13.38 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 70 BY .69
     FILL-IN-CodOpe AT ROW 1.23 COL 19.57 COLON-ALIGNED NO-LABEL
     X-NOMDIV AT ROW 3.12 COL 21.57 COLON-ALIGNED NO-LABEL
     x-NomCta AT ROW 4 COL 21.57 COLON-ALIGNED NO-LABEL
     cb-cmov.FchAst AT ROW 2.31 COL 32.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     cb-cmov.Usuario AT ROW 11.81 COL 33 COLON-ALIGNED
          LABEL "Autor"
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .69
          BGCOLOR 7 FGCOLOR 15 
     cb-cmov.CodDoc AT ROW 4.85 COL 37.57 COLON-ALIGNED
          LABEL "Doc"
          VIEW-AS FILL-IN 
          SIZE 6 BY .69
     cb-cmov.NroChq AT ROW 4.85 COL 48.57 COLON-ALIGNED
          LABEL "Nro"
          VIEW-AS FILL-IN 
          SIZE 15 BY .69
     cb-cmov.ImpChq AT ROW 11.81 COL 55 COLON-ALIGNED
          LABEL "Total"
          VIEW-AS FILL-IN 
          SIZE 17 BY .69
          BGCOLOR 7 FGCOLOR 15 
     Moneda AT ROW 3.12 COL 73.57 COLON-ALIGNED
     cb-cmov.TpoCmb AT ROW 2.31 COL 75.57 COLON-ALIGNED
          LABEL "T. Cambio"
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     F-SdoCta AT ROW 4 COL 74.86 COLON-ALIGNED
     cb-cmov.C-FCaja AT ROW 4.85 COL 77.57 COLON-ALIGNED
          LABEL "Con. Flj. Caja"
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .69
     b-d-add AT ROW 6.65 COL 80
     b-d-update AT ROW 7.73 COL 80
     b-d-delete AT ROW 8.81 COL 80
     b-d-Asigna AT ROW 9.96 COL 80
     B-impresoras AT ROW 13.27 COL 85.72
     RECT-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX OVERLAY NO-HELP 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 90.86 BY 13.54
         BGCOLOR 8 FGCOLOR 0 FONT 4.

DEFINE FRAME F-ctrl-frame
     B-query AT ROW 1.5 COL 1.43
     B-add AT ROW 1.5 COL 9.86
     B-update AT ROW 1.5 COL 18.29
     B-delete AT ROW 1.5 COL 26.86
     BUTTON-2 AT ROW 1.5 COL 35.57
     B-imprimir AT ROW 1.5 COL 44.14
     B-first AT ROW 1.46 COL 53.86
     B-prev AT ROW 1.46 COL 58.86
     B-next AT ROW 1.46 COL 63.86
     B-last AT ROW 1.46 COL 68.86
     B-browse AT ROW 1.19 COL 75
     B-exit AT ROW 1.5 COL 83.29
     R-exit AT ROW 1 COL 82
     R-consulta AT ROW 1 COL 74
    WITH 1 DOWN OVERLAY NO-HELP 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 14.59
         SIZE 90.86 BY 2.1
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
  CREATE WINDOW W-Maestro ASSIGN
         HIDDEN             = YES
         TITLE              = "Caja Egresos"
         COLUMN             = 17.72
         ROW                = 9.69
         HEIGHT             = 15.77
         WIDTH              = 91
         MAX-HEIGHT         = 16.85
         MAX-WIDTH          = 91.43
         VIRTUAL-HEIGHT     = 16.85
         VIRTUAL-WIDTH      = 91.43
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = 8
         FGCOLOR            = 0
         THREE-D            = yes
         FONT               = 4
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

IF NOT W-Maestro:LOAD-ICON("IMG/valmiesa":U) THEN
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
       B-imprimir:POPUP-MENU IN FRAME F-ctrl-frame       = MENU POPUP-MENU-B-imprimir:HANDLE.

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
/* BROWSE-TAB BRW-DETALLE RECT-2 F-maestro */
/* SETTINGS FOR BUTTON b-d-add IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b-d-Asigna IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b-d-delete IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b-d-update IN FRAME F-maestro
   NO-ENABLE                                                            */
ASSIGN 
       BRW-DETALLE:NUM-LOCKED-COLUMNS IN FRAME F-maestro = 2.

/* SETTINGS FOR FILL-IN cb-cmov.C-FCaja IN FRAME F-maestro
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.CodAux IN FRAME F-maestro
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.CodDiv IN FRAME F-maestro
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN cb-cmov.CodDoc IN FRAME F-maestro
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN F-SdoCta IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodOpe IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.ImpChq IN FRAME F-maestro
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR COMBO-BOX Moneda IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.NroAst IN FRAME F-maestro
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.NroChq IN FRAME F-maestro
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.TpoCmb IN FRAME F-maestro
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.Usuario IN FRAME F-maestro
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN x-NomCta IN FRAME F-maestro
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN X-NOMDIV IN FRAME F-maestro
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Maestro)
THEN W-Maestro:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BRW-DETALLE
/* Query rebuild information for BROWSE BRW-DETALLE
     _TblList          = "integral.cb-dmov WHERE integral.cb-cmov ..."
     _Options          = "NO-LOCK"
     _Where[1]         = "integral.cb-dmov.CodCia = s-codcia
 AND integral.cb-dmov.Periodo = s-periodo
 AND integral.cb-dmov.NroMes = s-NroMes
 AND integral.cb-dmov.Codope = x-CodOpe
 AND integral.cb-dmov.Nroast = integral.cb-cmov.Nroast:SCREEN-VALUE IN FRAME F-maestro
 AND integral.cb-dmov.TpoItm <> ""B"""
     _FldNameList[1]   > integral.cb-dmov.Codcta
"cb-dmov.Codcta" "Código!cuenta" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   > integral.cb-dmov.Codaux
"cb-dmov.Codaux" "Código!auxiliar" "x(10)" "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > integral.cb-dmov.Coddoc
"cb-dmov.Coddoc" "Código!docum." ? "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   > integral.cb-dmov.Nrodoc
"cb-dmov.Nrodoc" "Número de!documento" "x(20)" "character" ? ? ? ? ? ? no ?
     _FldNameList[5]   > integral.cb-dmov.Glodoc
"cb-dmov.Glodoc" ? ? "character" ? ? ? ? ? ? no ""
     _FldNameList[6]   = integral.cb-dmov.TpoMov
     _FldNameList[7]   > integral.cb-dmov.ImpMn1
"cb-dmov.ImpMn1" "Importe!(Soles)" ? "decimal" ? ? ? ? ? ? no ?
     _FldNameList[8]   > integral.cb-dmov.ImpMn2
"cb-dmov.ImpMn2" "Importe!(Dólares)" ? "decimal" ? ? ? ? ? ? no ?
     _FldNameList[9]   = integral.cb-dmov.Tpocmb
     _FldNameList[10]   > integral.cb-dmov.ImpMn3
"cb-dmov.ImpMn3" "Importe(Dfcm )" ? "decimal" ? ? ? ? ? ? no ?
     _FldNameList[11]   > integral.cb-dmov.CodDiv
"cb-dmov.CodDiv" "Código!división." ? "character" ? ? ? ? ? ? no ?
     _FldNameList[12]   > integral.cb-dmov.Nroref
"cb-dmov.Nroref" "Número de!referencia" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[13]   > integral.cb-dmov.Clfaux
"cb-dmov.Clfaux" "Clasif.!auxiliar" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[14]   = integral.cb-dmov.TpoItm
     _FldNameList[15]   = integral.cb-dmov.flgact
     _FldNameList[16]   > integral.cb-dmov.Relacion
"cb-dmov.Relacion" ? ">>>>>>>>>9" "recid" ? ? ? ? ? ? no ?
     _FldNameList[17]   = integral.cb-dmov.tm
     _FldNameList[18]   = integral.cb-cmov.Codmon
     _FldNameList[19]   = integral.cb-dmov.cco
     _FldNameList[20]   = integral.cb-dmov.C-Fcaja
     _Query            is OPENED
*/  /* BROWSE BRW-DETALLE */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-maestro
/* Query rebuild information for FRAME F-maestro
     _TblList          = "integral.cb-cmov"
     _Query            is NOT OPENED
*/  /* FRAME F-maestro */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define FRAME-NAME F-ctrl-frame
&Scoped-define SELF-NAME B-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-add W-Maestro
ON CHOOSE OF B-add IN FRAME F-ctrl-frame /* Crear */
DO:
    F-CREAR = TRUE.
    IF s-NroMesCie
    THEN DO:
        MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    FRAME F-ctrl-frame:VISIBLE = FALSE.
    FRAME F-add:VISIBLE = TRUE.
    c-CodOpe:SENSITIVE IN FRAME F-maestro = FALSE.
    CLEAR FRAME F-maestro.
    RUN cbd/cbdnast.p(cb-codcia, s-codcia, s-periodo, s-NroMes, x-codope, OUTPUT x-nroast). 
    RUN add-cmov.
    FRAME f-add:VISIBLE = FALSE.
    FRAME f-ctrl-frame:visible = TRUE.
    DISABLE  cb-cmov.Fchast 
             cb-cmov.coddiv 
             cb-cmov.ctacja
             cb-cmov.codaux
             cb-cmov.coddoc 
             cb-cmov.Nrochq 
             cb-cmov.Tpocmb
             b-d-add b-d-update b-d-delete b-d-Asigna
             cb-cmov.Nrovou
             cb-cmov.girado 
             cb-cmov.Notast 
             cb-cmov.c-fcaja
             WITH FRAME F-maestro.
    F-CREAR = FALSE.                      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-browse W-Maestro
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Cancel W-Maestro
ON CHOOSE OF B-Cancel IN FRAME F-add /* Cancelar */
DO:
   IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
      ELSE  CLEAR FRAME F-maestro.
   RECID-stack = 1.
   c-CodOpe:SENSITIVE IN FRAME F-maestro = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-update
&Scoped-define SELF-NAME B-Cancel-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Cancel-2 W-Maestro
ON CHOOSE OF B-Cancel-2 IN FRAME F-update /* Cancelar */
DO:
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
       ELSE  CLEAR FRAME F-maestro.
    RECID-stack = ?.
    c-CodOpe:SENSITIVE IN FRAME F-maestro = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-search
&Scoped-define SELF-NAME B-Cancel-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Cancel-3 W-Maestro
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
     IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
     ELSE  CLEAR FRAME F-maestro.
     c-CodOpe:SENSITIVE IN FRAME F-maestro = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-maestro
&Scoped-define SELF-NAME b-d-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-d-add W-Maestro
ON CHOOSE OF b-d-add IN FRAME F-maestro /* Agregar */
DO:
    fFchAst = INPUT cb-cmov.FchAst.
    S-ASIGNA = "N".
    APPLY "INSERT-MODE" TO BRW-DETALLE IN FRAME F-maestro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-d-Asigna
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-d-Asigna W-Maestro
ON CHOOSE OF b-d-Asigna IN FRAME F-maestro /* Asignar */
DO:
  S-ASIGNA = "S".  
  fFchAst = INPUT cb-cmov.FchAst.
  RUN cja\d-provpe.r.
  FOR EACH RMOV:
      APPLY "INSERT-MODE" TO BRW-DETALLE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-d-delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-d-delete W-Maestro
ON CHOOSE OF b-d-delete IN FRAME F-maestro /* Eliminar */
DO:
    APPLY "DELETE-CHARACTER" TO BRW-DETALLE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-d-update
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-d-update W-Maestro
ON CHOOSE OF b-d-update IN FRAME F-maestro /* Actualizar */
DO:
    fFchAst = INPUT cb-cmov.FchAst.
    S-ASIGNA = "N".
    APPLY "ENTER" TO BRW-DETALLE IN FRAME F-maestro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-ctrl-frame
&Scoped-define SELF-NAME B-delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-delete W-Maestro
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
  
    
    MESSAGE "Eliminar el Registro?"
         VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
         UPDATE selection AS LOGICAL.

    IF selection = NO THEN RETURN NO-APPLY.     /* Corregido por RHC el 5/11/97 */
    pto = SESSION:SET-WAIT-STATE("GENERAL").
    FRAME F-ctrl-frame:VISIBLE = FALSE.
    RECID-Tmp = RECID(  {&FIRST-TABLE-IN-QUERY-F-maestro} ).
    DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        FIND {&FIRST-TABLE-IN-QUERY-F-maestro}
               WHERE  RECID-Tmp = RECID(  {&FIRST-TABLE-IN-QUERY-F-maestro} )
                EXCLUSIVE-LOCK NO-ERROR.

        FOR EACH cb-dmov WHERE cb-dmov.CodCia  = cb-cmov.CodCia  AND
                               cb-dmov.Periodo = cb-cmov.Periodo AND
                               cb-dmov.NroMes  = cb-cmov.NroMes  AND
                               cb-dmov.CodOpe  = cb-cmov.CodOpe  AND
                               cb-dmov.NroAst  = cb-cmov.NroAst
                               EXCLUSIVE:
            /* Des-actulizando saldos acumulados
            RUN cbd/cb-acmd.p(RECID(cb-dmov), NO , YES).  
            RMT: LO ENCONTRE ASI */
            RUN cbd/cb-acmd.p(RECID(cb-dmov), NO , YES).  
            /* Borrando el detalle del Documento */
            IF cb-dmov.TpoItm = "B"
            THEN ASSIGN cb-dmov.ImpMn1 = 0
                        cb-dmov.ImpMn2 = 0
                        cb-dmov.ImpMn3 = 0.
            ELSE DELETE cb-dmov.
        END.
        /* Borrando Auditado */
        ASSIGN cb-cmov.NOTAST = "**** A N U L A D O ****"
               cb-cmov.FLGEST = "A".
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-exit W-Maestro
ON CHOOSE OF B-exit IN FRAME F-ctrl-frame /* Salir */
DO:
     APPLY  "CLOSE" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-first
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-first W-Maestro
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-impresoras W-Maestro
ON CHOOSE OF B-impresoras IN FRAME F-maestro
DO:
    SYSTEM-DIALOG PRINTER-SETUP.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-ctrl-frame
&Scoped-define SELF-NAME B-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-imprimir W-Maestro
ON CHOOSE OF B-imprimir IN FRAME F-ctrl-frame /* Imprimir */
DO:
   Message "Para imprimir presione" skip
           "el Click Derecho de su Mouse"
           VIEW-AS ALERT-BOX INFORMA.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-last
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-last W-Maestro
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-next W-Maestro
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-ok W-Maestro
ON CHOOSE OF B-ok IN FRAME F-add /* Aceptar */
DO:
    find cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                       cb-ctas.CodCta = INPUT FRAME F-maestro cb-cmov.CtaCja
                       NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas
    THEN DO:
        MESSAGE "Cuenta no registrada" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cb-cmov.CtaCja IN FRAME F-Maestro.
        RETURN NO-APPLY.
    END.
    IF LENGTH(cb-cmov.CtaCja:SCREEN-VALUE) <>
        INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles))
    THEN DO:
        MESSAGE "Cuenta no afecta a movimientos" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cb-cmov.CtaCja IN FRAME F-Maestro.
        RETURN NO-APPLY.
    END.
/*
    IF cb-cmov.NroChq:SCREEN-VALUE IN FRAME F-Maestro = ""
    THEN DO:
        MESSAGE "Debe Ingresar el No. de Cheque" VIEW-AS ALERT-BOX ERROR.
        cb-cmov.NroChq:SCREEN-VALUE IN FRAME F-Maestro = cb-ctas.NroChq.
        APPLY "ENTRY" TO cb-cmov.NroChq IN FRAME F-Maestro.
        RETURN NO-APPLY.

    END.
*/
    PTO = SESSION:SET-WAIT-STATE("GENERAL").
    RUN diferencia-cmb.
    IF INPUT FRAME F-maestro cb-cmov.impchq = 0 THEN
        DISPLAY "**** A N U L A D O ****" @ cb-cmov.Notast WITH FRAME F-maestro.
    CASE moneda:SCREEN-VALUE:
        WHEN "Soles"   THEN integral.cb-cmov.codmon = 1.
        WHEN "D¢lares" THEN integral.cb-cmov.codmon = 2.
        OTHERWISE integral.cb-cmov.codmon = 1.
    END CASE.
    RUN ultimo-item.
    FOR EACH cbd-stack WHERE cbd-stack.CodCia  = cb-cmov.CodCia  AND
                            cbd-stack.Periodo = cb-cmov.Periodo AND
                            cbd-stack.NroMes  = cb-cmov.NroMes  AND
                            cbd-stack.CodOpe  = cb-cmov.CodOpe  AND
                            cbd-stack.NroAst  = cb-cmov.NroAst 
                            EXCLUSIVE:
        RUN cbd-stack-act(BUFFER cbd-stack).
        DELETE cbd-stack.
    END.
    FOR EACH cb-dmov WHERE cb-dmov.CodCia  = cb-cmov.CodCia  AND
                           cb-dmov.Periodo = cb-cmov.Periodo AND
                           cb-dmov.NroMes  = cb-cmov.NroMes  AND
                           cb-dmov.CodOpe  = cb-cmov.CodOpe  AND
                           cb-dmov.NroAst  = cb-cmov.NroAst  AND
                           cb-dmov.flgact  = FALSE :
        RUN cbd/cb-acmd.p(RECID(cb-dmov), YES , YES).
        cb-dmov.flgact = TRUE.
    END.
    RUN CONTROL-CHEQUE.
    PTO = SESSION:SET-WAIT-STATE("").
    ASSIGN FRAME F-Maestro
        {&FIELDS-IN-QUERY-F-maestro}
        {&ASSIGN-ADD}.
        
    c-CodOpe:SENSITIVE IN FRAME F-maestro = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-update
&Scoped-define SELF-NAME B-ok-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-ok-2 W-Maestro
ON CHOOSE OF B-ok-2 IN FRAME F-update /* Aceptar */
DO:
   /* Verificamos si registro el Cuenta de Bancos */
    find cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                       cb-ctas.CodCta = INPUT FRAME F-maestro cb-cmov.CtaCja
                       NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas
    THEN DO:
        MESSAGE "Cuenta no registrada" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cb-cmov.CtaCja IN FRAME F-Maestro.
        RETURN NO-APPLY.
    END.
    IF LENGTH(cb-cmov.CtaCja:SCREEN-VALUE) <>
        INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles))
    THEN DO:
        MESSAGE "Cuenta no afecta a movimientos" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cb-cmov.CtaCja IN FRAME F-Maestro.
        RETURN NO-APPLY.
    END.
/*
    IF cb-cmov.NroChq:SCREEN-VALUE IN FRAME F-Maestro = ""
    THEN DO:
        MESSAGE "Debe Ingresar el No. de Cheque" VIEW-AS ALERT-BOX ERROR.
        cb-cmov.NroChq:SCREEN-VALUE IN FRAME F-Maestro = cb-ctas.NroChq.
        APPLY "ENTRY" TO cb-cmov.NroChq IN FRAME F-Maestro.
        RETURN NO-APPLY.
    END.
*/  
    /* RUN NroChq */
    RUN diferencia-cmb.
    RUN ultimo-item.
    FOR EACH cbd-stack WHERE cbd-stack.CodCia  = cb-cmov.CodCia  AND
                            cbd-stack.Periodo = cb-cmov.Periodo AND
                            cbd-stack.NroMes  = cb-cmov.NroMes  AND
                            cbd-stack.CodOpe  = cb-cmov.CodOpe  AND
                            cbd-stack.NroAst  = cb-cmov.NroAst  
                            EXCLUSIVE:
            RUN cbd-stack-act(BUFFER CBD-STACK). 
            DELETE cbd-stack.
    END.                
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
    CASE moneda:SCREEN-VALUE:
        WHEN "Soles"   THEN integral.cb-cmov.codmon = 1.
        WHEN "D¢lares" THEN integral.cb-cmov.codmon = 2.
        OTHERWISE integral.cb-cmov.codmon = 1.
    END CASE.

    ASSIGN FRAME F-maestro
        {&FIELDS-IN-QUERY-F-maestro}
        {&ASSIGN-ADD}.
        
    c-CodOpe:SENSITIVE IN FRAME F-maestro = TRUE.
       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-search
&Scoped-define SELF-NAME B-ok-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-ok-3 W-Maestro
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

     c-CodOpe:SENSITIVE IN FRAME F-maestro = TRUE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-ctrl-frame
&Scoped-define SELF-NAME B-prev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-prev W-Maestro
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-query W-Maestro
ON CHOOSE OF B-query IN FRAME F-ctrl-frame /* Buscar */
DO:

     CLEAR FRAME F-maestro.
     FRAME F-ctrl-frame:VISIBLE = FALSE.
     FRAME F-search:VISIBLE = TRUE.

     ENABLE {&QUERY-field}  WITH FRAME F-maestro.
     
     c-CodOpe:SENSITIVE IN FRAME F-maestro = FALSE.
     
     WAIT-FOR  "CHOOSE" OF b-ok-3 IN FRAME f-search
     OR CHOOSE OF b-cancel-3 IN FRAME f-search.

     DISABLE {&QUERY-field} WITH FRAME F-maestro.
     FRAME f-search:VISIBLE = FALSE.
     FRAME f-ctrl-frame:VISIBLE = TRUE.

END. /*choose of b-query*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-update
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-update W-Maestro
ON CHOOSE OF B-update IN FRAME F-ctrl-frame /* Modificar */
DO:
    F-CREAR = FALSE.
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
  
    c-CodOpe:SENSITIVE IN FRAME F-maestro = FALSE.
    
    FRAME f-ctrl-frame:VISIBLE = FALSE.
    FRAME f-update:VISIBLE = TRUE.
    RECID-stack = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} ).
    Data:
    DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        FIND FIRST {&FIRST-TABLE-IN-QUERY-F-maestro}
            WHERE RECID-stack = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} )
            EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
            x-CodMon = cb-cmov.CodMon.
            FOR EACH cb-dmov WHERE cb-dmov.codcia = s-codcia AND
                                  cb-dmov.Periodo = s-periodo    AND
                                  cb-dmov.NroMes  = s-NroMes    AND
                                  cb-dmov.CodOpe  = x-CodOpe AND
                                  cb-dmov.NroAst  = cb-cmov.NroAst AND
                                  ( cb-dmov.TpoItm  = "B" OR
                                    cb-dmov.TpoItm  = "D" ):
                RUN Delete-Dmov.
            END.
            {&OPEN-QUERY-BRW-DETALLE}
            GET FIRST BRW-DETALLE.
            find cb-ctas WHERE cb-ctas.CODCIA = cb-codcia AND
                               cb-ctas.CODCTA = cb-cmov.CTACJA 
                               NO-LOCK NO-ERROR.
            IF avail cb-ctas THEN X-CLFAUX = cb-ctas.CLFAUX.                   
            ENABLE cb-cmov.Fchast WITH FRAME F-maestro.
            IF cb-cfga.CODDIV THEN ENABLE cb-cmov.coddiv WITH FRAME F-maestro.
            ELSE DO:
                DISABLE cb-cmov.coddiv WITH FRAME F-maestro.
                integral.cb-cmov.coddiv:HIDDEN = TRUE.
            END.     
           ENABLE 
               cb-cmov.Tpocmb
               cb-cmov.ctacja
               cb-cmov.coddiv
               cb-cmov.c-fcaja
               cb-cmov.codaux
               cb-cmov.coddoc 
               cb-cmov.Nrochq 
               BRW-DETALLE b-d-add b-d-update b-d-delete b-d-Asigna
               cb-cmov.Nrovou
               cb-cmov.girado 
               cb-cmov.Notast 
               WITH FRAME F-maestro.
            x-CodMon = cb-cmov.CodMon.
            CASE x-CodMon :
                WHEN 1 THEN ASSIGN Moneda = "Soles"   x-CodMon = 1.
                WHEN 2 THEN ASSIGN Moneda = "D¢lares" x-CodMon = 2.
                OTHERWISE   ASSIGN Moneda = "Soles"   x-CodMon = 1.
            END CASE.
            DISPLAY  Moneda WITH FRAME F-maestro.
            WAIT-FOR CHOOSE OF b-ok-2 OR CHOOSE OF B-cancel-2 IN FRAME f-UPDATE.
            IF LAST-EVENT:FUNCTION = "END-ERROR" OR
               RECID-stack = ?
            THEN UNDO, LEAVE Data.
        END.
        ELSE MESSAGE  "No exiten Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.  /*transaction*/
    IF AVAILABLE {&FIRST-TABLE-IN-QUERY-F-maestro}
    THEN DO:
        RECID-stack = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} ).
        FIND FIRST {&FIRST-TABLE-IN-QUERY-F-maestro}
        WHERE RECID-stack = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} )
            NO-LOCK NO-ERROR.
    END.
    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
      DISABLE cb-cmov.Fchast 
              cb-cmov.coddiv
              cb-cmov.ctacja
              cb-cmov.codaux
              cb-cmov.coddoc 
              cb-cmov.Nrochq 
              cb-cmov.Tpocmb
              b-d-add b-d-update b-d-delete b-d-Asigna
              cb-cmov.Nrovou
              cb-cmov.girado 
              cb-cmov.Notast 
              cb-cmov.c-fcaja
              WITH FRAME F-maestro.
    FRAME f-update:VISIBLE = FALSE.
    FRAME F-ctrl-frame:VISIBLE = TRUE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BRW-DETALLE
&Scoped-define FRAME-NAME F-maestro
&Scoped-define SELF-NAME BRW-DETALLE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BRW-DETALLE W-Maestro
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
    IF cb-dmov.TpoItm = "D"
    THEN DO:
        BELL.
        MESSAGE "Diferencia de Cambio / Traslaci¢n " VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.     
    MESSAGE "Est  seguro de eliminar movimiento"
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOGICAL.
    IF rpta
    THEN DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        PTO = SESSION:SET-WAIT-STATE("GENERAL").
        RUN Delete-Dmov.
        {&OPEN-QUERY-{&BROWSE-NAME}}
        RUN importe-chq.
        PTO = SESSION:SET-WAIT-STATE("").
    END.
    ELSE RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BRW-DETALLE W-Maestro
ON INSERT-MODE OF BRW-DETALLE IN FRAME F-maestro
DO:
   DEF VAR X-ERROR AS LOGICAL INIT NO.
    IF b-d-add:SENSITIVE = NO
    THEN RETURN NO-APPLY.

    IF NOT CAN-FIND( cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
        cb-ctas.CodCta = cb-cmov.CtaCja:SCREEN-VALUE IN FRAME F-maestro )
    THEN DO:
        MESSAGE "Cuenta no registrada" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cb-cmov.CtaCja IN FRAME F-Maestro.
        RETURN NO-APPLY.
    END.
    IF LENGTH(cb-cmov.CtaCja:SCREEN-VALUE) <>
        INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles))
    THEN DO:
        MESSAGE "Cuenta no afecta a movimientos" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cb-cmov.CtaCja IN FRAME F-Maestro.
        RETURN NO-APPLY.
    END.
/*
    IF cb-cmov.NroChq:SCREEN-VALUE IN FRAME F-Maestro = ""
    THEN DO:
        MESSAGE "Debe Ingresar el No. de Documento" VIEW-AS ALERT-BOX ERROR.
        cb-cmov.NroChq:SCREEN-VALUE IN FRAME F-Maestro = cb-ctas.NroChq.
        APPLY "ENTRY" TO cb-cmov.NroChq IN FRAME F-Maestro.
        RETURN NO-APPLY.
    END.

    IF ((( INPUT FRAME F-maestro cb-cmov.tpocmb <= 0 ) and cb-ctas.codmon = 2 ) or
        (( INPUT FRAME F-maestro cb-cmov.tpocmb <> 0 ) and cb-ctas.codmon = 1 )) THEN DO:
        MESSAGE "Tipo de cambio errado" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cb-cmov.tpocmb.
        RETURN NO-APPLY.
    END.
*/
    IF LENGTH(cb-cmov.CodDiv:SCREEN-VALUE) < 5 THEN DO:
         MESSAGE "Divisi¢n no tiene movimiento" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO cb-cmov.CodDiv IN FRAME F-Maestro.
         RETURN NO-APPLY.
    END.    
    IF NOT CAN-FIND( GN-DIVI  WHERE GN-DIVI.codcia  =  S-codcia AND 
       GN-DIVI.codDIV  = cb-cmov.CodDiv:SCREEN-VALUE IN FRAME F-maestro ) AND
       cb-cfga.CodDiv
    THEN DO:
        MESSAGE "División no registrada" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cb-cmov.CodDiv IN FRAME F-Maestro.
        RETURN NO-APPLY.
    END.
   
    BLOQUE:
    DO TRANSACTION ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
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
               cb-dmov.CodMon  = x-CodMon
               cb-dmov.TpoCmb  = INPUT cb-cmov.TpoCmb
               cb-dmov.NroItm  = x-NroItm
               cb-cmov.TotItm  = x-NroItm
               cb-dmov.FchDoc  = INPUT cb-cmov.fchast
               cb-dmov.CodDiv  = INPUT cb-cmov.CodDiv
               cb-dmov.C-FCAJA = INPUT cb-cmov.C-FCAJA
               RegAct          = RECID(cb-dmov).
        IF S-ASIGNA = "S" THEN RUN Procesa-Asignacion.
        ELSE DO:
           {&WINDOW-NAME}:WINDOW-STATE = 2.
           SELF:SENSITIVE = NO.
           RUN cja/cjamove2.w(RegAct,OUTPUT x-girado,OUTPUT x-notast,OUTPUT X-ERROR).
           {&WINDOW-NAME}:WINDOW-STATE = 3.
        END.
        SELF:SENSITIVE = YES.
        IF X-ERROR THEN UNDO, RETURN NO-APPLY.
        IF cb-dmov.tpoitm = "P" THEN RUN detalle.
        PTO = SESSION:SET-WAIT-STATE("GENERAL").
        RUN Acumula.
        /* Generando Cuentas Autom ticas */
        RUN Automaticas.
        {&OPEN-QUERY-BRW-DETALLE}
        RUN importe-chq.
        PTO = SESSION:SET-WAIT-STATE("").
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BRW-DETALLE W-Maestro
ON MOUSE-SELECT-DBLCLICK OF BRW-DETALLE IN FRAME F-maestro
DO:
    APPLY "ENTER" TO BRW-DETALLE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BRW-DETALLE W-Maestro
ON RETURN OF BRW-DETALLE IN FRAME F-maestro
DO:
   DEF VAR X-ERROR AS LOGICAL INIT NO.
    IF b-d-add:SENSITIVE = NO
    THEN RETURN NO-APPLY.

    IF NOT CAN-FIND( cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
        cb-ctas.CodCta = cb-cmov.CtaCja:SCREEN-VALUE IN FRAME F-maestro )
    THEN DO:
        MESSAGE "Cuenta no registrada" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cb-cmov.CtaCja IN FRAME F-Maestro.
        RETURN NO-APPLY.
    END.
    IF LENGTH(cb-cmov.CtaCja:SCREEN-VALUE) <>
        INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles))
    THEN DO:
        MESSAGE "Cuenta no afecta a movimientos" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cb-cmov.CtaCja IN FRAME F-Maestro.
        RETURN NO-APPLY.
    END.
/*
    IF cb-cmov.NroChq:SCREEN-VALUE IN FRAME F-Maestro = ""
    THEN DO:
        MESSAGE "Debe Ingresar el No. de Cheque" VIEW-AS ALERT-BOX ERROR.
        cb-cmov.NroChq:SCREEN-VALUE IN FRAME F-Maestro = cb-ctas.NroChq.
        APPLY "ENTRY" TO cb-cmov.NroChq IN FRAME F-Maestro.
        RETURN NO-APPLY.
    END.

    IF INPUT FRAME F-maestro cb-cmov.tpocmb <= 0 THEN DO:
        MESSAGE "Debe ingresar el tipo de cambio" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cb-cmov.tpocmb.
        RETURN NO-APPLY.
    END.
*/
    RegAct = RECID(cb-dmov).

    DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        IF RegAct = ?
        THEN DO:
            BELL.
            MESSAGE "Item no Seleccionado o no existente"
                VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        IF cb-dmov.TpoItm = "A"
        THEN DO:
            BELL.
            MESSAGE "Cuenta Autom tica" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        IF cb-dmov.TpoItm = "P" AND cb-dmov.IMPMN3 <> 0
        THEN DO:
            BELL.
            MESSAGE "Esta tratando de modificar una "        SKIP
                    "provisi¢n ya cancelada.        "        SKIP
                    "Se le recomienda que tome los datos"    SKIP
                    "de esta provisi¢n y la elimine "        SKIP
                    "volviendo a crear un nuevo registro"    SKIP
                    "con los datos de la nueva cancelaci¢n"  SKIP
                    "o amortizaci¢n para esta provisi¢n.   " SKIP(3) 
                    "Desea continuar con la modificaci¢n " 
                    VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
                    TITLE "CONFIRME" UPDATE P98 AS LOGICAL.
            IF NOT P98 THEN RETURN NO-APPLY.
        END.
        FIND integral.cb-dmov WHERE RegAct = RECID(cb-dmov) EXCLUSIVE.

        ASSIGN cb-dmov.CodMon = x-CodMon
               cb-dmov.TpoCmb = INPUT cb-cmov.TpoCmb
               cb-dmov.FchDoc = INPUT cb-cmov.fchast.

        RUN Del-Acumula.
        RUN GrabaAnt.
        {&WINDOW-NAME}:WINDOW-STATE = 2.
        SELF:SENSITIVE = NO.
        RUN cja/cjamove2.w(RegAct,OUTPUT x-girado,OUTPUT x-notast,OUTPUT X-ERROR).
        {&WINDOW-NAME}:WINDOW-STATE = 3.
        SELF:SENSITIVE = YES.
        IF X-ERROR THEN UNDO, RETURN NO-APPLY .
        
        IF cb-dmov.tpoitm = "P" THEN RUN detalle.
        PTO = SESSION:SET-WAIT-STATE("GENERAL").
        RUN Acumula.
        /* Actualizando Cuentas Autom ticas */
        RUN Automaticas.
        PTO = BRW-DETALLE:REFRESH().
        RUN importe-chq.
        PTO = SESSION:SET-WAIT-STATE("").
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-ctrl-frame
&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Maestro
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
&Scoped-define SELF-NAME C-CodOpe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-CodOpe W-Maestro
ON VALUE-CHANGED OF C-CodOpe IN FRAME F-maestro /* Operación */
DO:
  x-CodOpe = SELF:SCREEN-VALUE.
  
  FIND cb-oper WHERE cb-oper.CodCia = cb-CodCia AND
                     cb-oper.CodOpe = SELF:SCREEN-VALUE 
                     NO-LOCK NO-ERROR.
                     
  x-NomOpe = integral.cb-oper.Nomope.
  x-codope = integral.cb-oper.codope.
  CON-CUENTAS = integral.cb-oper.codCta.
  
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
   {&OPEN-QUERY-BRW-DETALLE}
  FILL-IN-CodOpe:SCREEN-VALUE = x-NomOpe.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cmov.C-FCaja
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cmov.C-FCaja W-Maestro
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cmov.C-FCaja W-Maestro
ON LEAVE OF cb-cmov.C-FCaja IN FRAME F-maestro /* Con. Flj. Caja */
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


&Scoped-define SELF-NAME cb-cmov.CodAux
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cmov.CodAux W-Maestro
ON F8 OF cb-cmov.CodAux IN FRAME F-maestro /* Auxiliar */
DO:
   DEF VAR X-RECID AS RECID.
   RUN CBD/Q-AUXI1(cb-codcia,X-CLFAUX,s-codcia,OUTPUT X-RECID).
   IF X-RECID <> 0  THEN DO:
      FIND cb-auxi WHERE RECID(cb-auxi) = X-RECID NO-LOCK NO-ERROR.
      IF AVAIL cb-auxi THEN SELF:SCREEN-VALUE = cb-auxi.CODAUX.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cmov.CodAux W-Maestro
ON LEAVE OF cb-cmov.CodAux IN FRAME F-maestro /* Auxiliar */
DO:
    IF LOOKUP(LAST-EVENT:FUNCTION, "ENDKEY,ERROR,END-ERROR,CHOOSE") <> 0
    THEN RETURN.
    FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia AND
                        cb-auxi.CLFAUX = X-CLFAUX   AND
                        cb-auxi.CODAUX = cb-cmov.CODAUX:SCREEN-VALUE
                        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-auxi
    THEN DO:
        BELL.
        MESSAGE "Auxiliar no registrada" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cb-cmov.CodAux IN FRAME F-Maestro.
        RETURN NO-APPLY.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cmov.CodAux W-Maestro
ON MOUSE-SELECT-DBLCLICK OF cb-cmov.CodAux IN FRAME F-maestro /* Auxiliar */
DO:
   APPLY "F8" TO cb-cmov.CODAUX IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cmov.CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cmov.CodDiv W-Maestro
ON F8 OF cb-cmov.CodDiv IN FRAME F-maestro /* División */
OR "MOUSE-SELECT-DBLCLICK":U OF cb-cmov.CODDIV DO:
  {CBD/H-DIVI01.I NO SELF}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cmov.CodDiv W-Maestro
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
      ELSE X-NOMDIV:SCREEN-VALUE = GN-DIVI.DESDIV.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cmov.CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cmov.CodDoc W-Maestro
ON F8 OF cb-cmov.CodDoc IN FRAME F-maestro /* Doc */
DO:
      RUN cbd/q-clfaux.w("02", OUTPUT RECID-stack).
    IF RECID-stack <> 0
    THEN DO:
        FIND cb-tabl WHERE RECID( cb-tabl ) = RECID-stack
              NO-LOCK  NO-ERROR.
        IF AVAIL cb-tabl THEN DO:
             cb-cmov.CodDoc:SCREEN-VALUE = cb-tabl.codigo.
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cmov.CodDoc W-Maestro
ON LEAVE OF cb-cmov.CodDoc IN FRAME F-maestro /* Doc */
DO:
    IF LOOKUP(LAST-EVENT:FUNCTION, "ENDKEY,ERROR,END-ERROR,CHOOSE") <> 0
    THEN RETURN.
    IF SELF:SCREEN-VALUE = "CHQ" THEN RUN NROCHQ.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cmov.CtaCja
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cmov.CtaCja W-Maestro
ON F8 OF cb-cmov.CtaCja IN FRAME F-maestro /* Cuenta Caja */
DO:
    IF (SELF:SCREEN-VALUE = "") OR (NOT SELF:SCREEN-VALUE BEGINS CON-CUENTAS) THEN 
       RUN cbd/q-ctas4.w(cb-codcia,CON-CUENTAS,s-codcia, OUTPUT RECID-stack).
    ELSE
        RUN cbd/q-ctas4.w(cb-codcia,cb-cmov.CTACJA:SCREEN-VALUE,s-codcia, OUTPUT RECID-stack).  
    IF RECID-stack <> 0
    THEN DO:
        find cb-ctas WHERE RECID(cb-ctas) = RECID-stack NO-LOCK NO-ERROR.
        IF avail cb-ctas
        THEN DO:
            cb-cmov.CtaCja:SCREEN-VALUE = cb-ctas.CodCta.
            x-NomCta:SCREEN-VALUE = cb-ctas.NomCta.
            CASE integral.cb-ctas.codmon:
                WHEN 1 THEN moneda:SCREEN-VALUE = "Soles".
                WHEN 2 THEN moneda:SCREEN-VALUE = "D¢lares".
                OTHERWISE moneda:SCREEN-VALUE = "Soles".
            END CASE.
            APPLY "ENTRY" TO cb-cmov.ctacja.
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cmov.CtaCja W-Maestro
ON LEAVE OF cb-cmov.CtaCja IN FRAME F-maestro /* Cuenta Caja */
DO:
   DEF VAR T1 AS CHAR.
   
    IF LOOKUP(LAST-EVENT:FUNCTION, "ENDKEY,ERROR,END-ERROR,CHOOSE") <> 0
    THEN RETURN.
    T1 = cb-cmov.CTACJA:SCREEN-VALUE.
    IF NOT ( T1 BEGINS CON-CUENTAS ) THEN DO:
       MESSAGE "La cuenta debe ser :" CON-CUENTAS
                VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
    find cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                       cb-ctas.CodCta = INPUT cb-cmov.CtaCja
                       NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas
    THEN DO:
        BELL.
        MESSAGE "Cuenta no registrada" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cb-cmov.CtaCja IN FRAME F-Maestro.
        RETURN NO-APPLY.
    END.
  
    IF LENGTH(cb-cmov.CtaCja:SCREEN-VALUE) <>
        INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles))
    THEN DO:
        BELL.
        MESSAGE "Cuenta no afecta a movimientos" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    x-NomCta:SCREEN-VALUE = cb-ctas.NomCta.
    CASE integral.cb-ctas.codmon:
        WHEN 1 THEN moneda:SCREEN-VALUE = "Soles".
        WHEN 2 THEN moneda:SCREEN-VALUE = "D¢lares".
        OTHERWISE moneda:SCREEN-VALUE = "Soles".
    END CASE.
    x-codmon = integral.cb-ctas.codmon.
    RUN Saldo-Cuenta(cb-cmov.CTACJA:SCREEN-VALUE,cb-cmov.CodDiv:SCREEN-VALUE,x-codmon).
    IF cb-cmov.NroChq:SCREEN-VALUE IN FRAME F-Maestro = ""
    THEN cb-cmov.NroChq:SCREEN-VALUE IN FRAME F-Maestro = cb-ctas.NroChq.
    X-CLFAUX = cb-ctas.CLFAUX.
    IF  cb-ctas.PIDAUX  THEN DO:
        cb-cmov.CODAUX:VISIBLE = YES.
        APPLY "ENTRY" TO cb-cmov.CODAUX.
    END.    
    ELSE
    DO:
       cb-cmov.CODAUX:HIDDEN = YES.
    END.    

    cb-cmov.NroChq:HIDDEN = YES.   
    cb-cmov.CodDoc:HIDDEN = YES.   
    CASE integral.cb-ctas.codmon:
        WHEN 1 THEN cb-cmov.Tpocmb = 0.
        WHEN 2 THEN DO:
          FIND gn-tcmb WHERE gn-tcmb.FECHA = TODAY NO-LOCK NO-ERROR.
          IF AVAILABLE gn-tcmb
          THEN IF cb-oper.TpoCmb = 1 THEN cb-cmov.TpoCmb = gn-tcmb.Compra.
                                       ELSE cb-cmov.TpoCmb = gn-tcmb.Venta.
        END.        
    END CASE.
    DISPLAY  cb-cmov.Tpocmb WITH FRAME F-maestro.
    
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cmov.CtaCja W-Maestro
ON MOUSE-SELECT-DBLCLICK OF cb-cmov.CtaCja IN FRAME F-maestro /* Cuenta Caja */
DO:
    APPLY "F8" TO cb-cmov.CtaCja.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cmov.FchAst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cmov.FchAst W-Maestro
ON LEAVE OF cb-cmov.FchAst IN FRAME F-maestro /* Fecha */
DO:
        FIND gn-tcmb WHERE gn-tcmb.FECHA = INPUT FRAME F-Maestro cb-cmov.FchAst
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-tcmb
        THEN DO:
            IF cb-oper.TpoCmb = 1 THEN cb-cmov.TpoCmb = gn-tcmb.Compra.
                                       ELSE cb-cmov.TpoCmb = gn-tcmb.Venta.
            DISPLAY cb-cmov.TpoCmb WITH FRAME F-MAESTRO.                           
        END.    
        ELSE MESSAGE "No existe Tipo de Cambio" SKIP
                     "para la fecha registrada" VIEW-AS ALERT-BOX.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Moneda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Moneda W-Maestro
ON VALUE-CHANGED OF Moneda IN FRAME F-maestro /* Moneda */
DO:
    CASE Moneda:SCREEN-VALUE IN FRAME F-maestro :
        WHEN "Soles"   THEN  x-CodMon = 1.
        WHEN "D¢lares" THEN  x-CodMon = 2.
        OTHERWISE            x-CodMon = 1.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Todas_las_Cuentas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Todas_las_Cuentas W-Maestro
ON CHOOSE OF MENU-ITEM m_Todas_las_Cuentas /* Todas las Cuentas */
DO:
   RUN IMPRIME2(1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Todas_las_Cuentas_Ordenado_
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Todas_las_Cuentas_Ordenado_ W-Maestro
ON CHOOSE OF MENU-ITEM m_Todas_las_Cuentas_Ordenado_ /* Todas las Cuentas Ordenado por Cuenta */
DO:
   RUN IMPRIME-ORDENADO(1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cmov.NroChq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cmov.NroChq W-Maestro
ON LEAVE OF cb-cmov.NroChq IN FRAME F-maestro /* Nro */
DO:
    IF cb-cmov.nrochq:SCREEN-VALUE  = "" THEN DO:
        MESSAGE "Debe digitar el No. de Cheque" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    FIND FIRST cabecera WHERE 
               cabecera.codcia = s-codcia AND
               cabecera.ctacja = cb-cmov.ctacja:SCREEN-VALUE AND
               cabecera.nrochq = cb-cmov.nrochq:SCREEN-VALUE AND
               cabecera.codope = cb-cmov.codope              
               NO-LOCK NO-ERROR.
    IF AVAIL cabecera AND RECID( cabecera ) <> RECID( cb-cmov )THEN DO:
        MESSAGE "No. de Cheque ya registrado"  SKIP
                "Mes : " cabecera.NroMes       SKIP
                "Operacion : " cabecera.codope SKIP
                "Voucher : "  cabecera.NroAst
                 VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-add
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Maestro 


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
s-nomcia = x-NomOpe + "   " + s-nomcia + ", " + STRING( s-periodo , "9999" ).
{&WINDOW-NAME}:TITLE = s-nomcia + " - " + empresas.nomcia.

C-CodOpe:LIST-ITEMS IN FRAME F-maestro = p-tipo-egreso.
C-CodOpe:SCREEN-VALUE IN FRAME F-Maestro = ENTRY(1,P-TIPO-EGRESO).


/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.
MAIN-BLOCK:
DO ON ERROR UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.
    ASSIGN
    FRAME f-add:VISIBLE = FALSE
    FRAME f-update:VISIBLE = FALSE
    FRAME f-search:VISIBLE = FALSE
    FRAME F-ctrl-frame:VISIBLE = TRUE.

    FIND LAST {&FIRST-TABLE-IN-QUERY-F-maestro}
        &IF "{&RECORD-SCOPE}" <> "" &THEN
             WHERE {&RECORD-SCOPE}
        &ENDIF
        NO-LOCK  NO-ERROR.

    IF AVAIL {&FIRST-TABLE-IN-QUERY-F-maestro} THEN RUN Pintado.
    ELSE CLEAR FRAME F-maestro.

    FILL-IN-CodOpe:SCREEN-VALUE = x-NomOpe.
    
    DISABLE {&FIELDS-IN-QUERY-{&FRAME-NAME}}.
    DISABLE cb-cmov.Nroast
            cb-cmov.Fchast 
            cb-cmov.coddiv
            cb-cmov.ctacja
            cb-cmov.codaux
            cb-cmov.coddoc 
            cb-cmov.Nrochq 
            cb-cmov.Tpocmb
            b-d-add b-d-update b-d-delete b-d-Asigna
            cb-cmov.Nrovou
            cb-cmov.girado 
            cb-cmov.Notast 
            cb-cmov.c-fcaja
            WITH FRAME F-maestro. 
    IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE actualiza W-Maestro 
PROCEDURE actualiza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Acumula W-Maestro 
PROCEDURE Acumula :
IF cb-cmov.girado:SCREEN-VALUE IN FRAME F-maestro = "" THEN
        cb-cmov.girado:SCREEN-VALUE = x-girado.
    IF cb-cmov.notast:SCREEN-VALUE = "" THEN
        cb-cmov.notast:SCREEN-VALUE = x-notast.
    IF cb-dmov.TpoMov THEN     /* Tipo H */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE add-cmov W-Maestro 
PROCEDURE add-cmov :
DO ON ENDKEY UNDO,LEAVE ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        /* Creando la cabezera del documento */
        CREATE cb-cmov.
        ASSIGN cb-cmov.CodCia  = s-codcia
               cb-cmov.Periodo = s-periodo
               cb-cmov.NroMes  = s-NroMes
               cb-cmov.CodOpe  = x-CodOpe
               cb-cmov.CodDoc  = ""
               cb-cmov.NroAst  = STRING(x-NroAst,"999999")
               cb-cmov.FchAst  = TODAY
               cb-cmov.Usuario = s-user-id.
               recid-stack = RECID( integral.cb-cmov ). 
        FIND FIRST cb-auxi WHERE cb-auxi.codcia  =  cb-codcia AND 
                                 cb-auxi.clfaux  =  "@FC"       
                                NO-LOCK NO-ERROR.                                
        IF AVAIL CB-AUXI THEN ASSIGN CB-CMOV.C-FCAJA = CB-AUXI.CODAUX.                      
              
        /* Buscando el Tipo de Cambio que le corresponde */
         
        FIND gn-tcmb WHERE gn-tcmb.FECHA = TODAY NO-LOCK NO-ERROR.
        IF AVAILABLE gn-tcmb
        THEN IF cb-oper.TpoCmb = 1 THEN cb-cmov.TpoCmb = gn-tcmb.Compra.
                                       ELSE cb-cmov.TpoCmb = gn-tcmb.Venta.
                                       
        RUN Pintado.
        x-CodMon = 1.
        CASE x-CodMon :
            WHEN 1 THEN ASSIGN Moneda = "Soles"   x-CodMon = 1.
            WHEN 2 THEN ASSIGN Moneda = "D¢lares" x-CodMon = 2.
            OTHERWISE   ASSIGN Moneda = "Soles"   x-CodMon = 1.
        END CASE.
        DISPLAY  Moneda WITH FRAME F-maestro.
        ENABLE cb-cmov.Fchast WITH FRAME F-maestro.
        IF cb-cfga.CODDIV THEN ENABLE cb-cmov.coddiv WITH FRAME F-maestro.
        ELSE DO:
           DISABLE cb-cmov.coddiv WITH FRAME F-maestro.
           integral.cb-cmov.coddiv:HIDDEN = TRUE.
        END.     
        ENABLE 
               cb-cmov.Tpocmb
               cb-cmov.ctacja
               cb-cmov.coddiv
               cb-cmov.c-fcaja
               cb-cmov.codaux
               cb-cmov.coddoc 
               cb-cmov.Nrochq 
               b-d-add b-d-update b-d-delete b-d-Asigna
               cb-cmov.Nrovou
               cb-cmov.girado 
               cb-cmov.Notast 
               WITH FRAME F-maestro.
    
        APPLY "ENTRY" TO cb-cmov.FCHAST IN FRAME F-MAESTRO. 
        DO WITH FRAME F-ADD: 
           WAIT-FOR CHOOSE OF  b-Cancel ,b-ok  IN FRAME F-add.
        END.
        IF LAST-EVENT:FUNCTION = "END-ERROR" OR recid-stack = ?
            THEN UNDO, LEAVE.
    END.
IF LAST-EVENT:FUNCTION = "END-ERROR" OR recid-stack = ?
THEN DO:
    FIND {&FIRST-TABLE-IN-QUERY-F-maestro}
        WHERE recid-stack = RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} )EXCLUSIVE NO-ERROR.
    IF AVAILABLE {&FIRST-TABLE-IN-QUERY-F-maestro} THEN DO:
        DELETE {&FIRST-TABLE-IN-QUERY-F-maestro}.
        CLEAR FRAME f-maestro.
    END.
    /* Anulando el correlativo incrementado */
END.
/*
FIND {&FIRST-TABLE-IN-QUERY-F-maestro}
    WHERE RECID( {&FIRST-TABLE-IN-QUERY-F-maestro} ) = recid-stack   
          NO-LOCK NO-ERROR.

IF NOT AVAILABLE {&FIRST-TABLE-IN-QUERY-F-maestro}
  THEN CLEAR FRAME F-maestro.
*/ 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aplica-dif W-Maestro 
PROCEDURE aplica-dif :
/* -----------------------------------------------------------
Aplicaci¢n de diferencia de cambio
-------------------------------------------------------------*/
DEFINE INPUT PARAMETER XsCodCta LIKE cb-ctas.codcta.
DEFINE INPUT PARAMETER XsCodAux LIKE cb-dmov.CodAux.
DEFINE INPUT PARAMETER XsCodCco LIKE cb-dmov.CCo.

DEFINE INPUT PARAMETER XlTpoMov AS LOGICAL.
DEFINE INPUT PARAMETER XfImpMn1 AS DECIMAL FORMAT "ZZZZZZZ.99999".
DEFINE INPUT PARAMETER XfImpMn2 AS DECIMAL FORMAT "ZZZZZZZ.99999".
DEFINE INPUT PARAMETER X-Recid  AS RECID.
/*IF ROUND(XfImpMn1,2) = 0 AND ROUND(XfImpMn2,2) = 0 THEN RETURN.*/
FIND cb-ctas WHERE cb-ctas.CODCIA = cb-codcia AND
                   cb-ctas.CODCTA = XsCodCta
                   NO-LOCK NO-ERROR.
IF NOT avail cb-ctas THEN DO:
    MESSAGE "Error   : DIFERENCIA DE CAMBIO/TRASLACION " SKIP
            "Cuenta  : " + XsCodCta                        SKIP
            "No registrada"
            VIEW-AS ALERT-BOX ERROR.
    RETURN.        
END.
                      
    x-NroItm = 1.
    FIND LAST cb-dmov WHERE cb-dmov.CodCia  = s-codcia AND
                            cb-dmov.Periodo = s-periodo    AND
                            cb-dmov.NroMes  = s-NroMes    AND
                            cb-dmov.CodOpe  = x-CodOpe AND
                            cb-dmov.NroAst  = cb-cmov.NroAst:SCREEN-VALUE IN FRAME F-maestro
                            NO-LOCK NO-ERROR.
    IF AVAILABLE cb-dmov THEN x-NroItm = cb-dmov.NroItm + 1.
    CREATE cb-dmov.
    ASSIGN cb-dmov.codcia  = detalle.CodCia
           cb-dmov.periodo = detalle.Periodo
           cb-dmov.nromes  = detalle.NroMes
           cb-dmov.codope  = detalle.CodOpe
           cb-dmov.nroast  = detalle.NroAst
           cb-dmov.codcta  = XsCodCta
           cb-dmov.codmon  = detalle.CodMon
           cb-dmov.Tpocmb  = 0
           cb-dmov.TpoMov  = XlTpoMov
           cb-dmov.ImpMn1  = XfImpMn1
           cb-dmov.ImpMn2  = XfImpMn2
           cb-dmov.coddoc  = detalle.CodDoc
           cb-dmov.nrodoc  = detalle.nrodoc
           cb-dmov.TpoItm  = "D"
           cb-dmov.clfaux  = cb-Ctas.ClfAux
           cb-dmov.codaux  = XsCodAux
           cb-dmov.Cco     = XsCodCco
           cb-dmov.glodoc  = detalle.glodoc
           cb-dmov.nroitm  = x-nroitm
           cb-dmov.coddiv  = detalle.Coddiv
           cb-dmov.tm      = cb-ctas.tm
           cb-dmov.relacion = x-recid.
    RegAct = RECID( cb-dmov ).
    RUN Acumula.
   
    /*GENERACION DE CUENTAS AUTOMATICAS */
        /* Grabamos datos para la generaci¢n de Cuentas Autom ticas */
    x-GenAut = 0.
    /* Verificamos si la Cuenta genera automaticas de Clase 9 */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut9 ):
        IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut9 )
        THEN DO:
            IF ENTRY( i, cb-cfga.GenAut9) <> ""
            THEN DO:
                x-GenAut = 1.
                LEAVE.
            END.
        END.
    END.
    /* Verificamos si la Cuenta genera automaticas de Clase 6 */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut6 ):
        IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut6 )
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
        IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut )
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
            ASSIGN cb-dmov.CtrCta = cb-ctas.Cc1Cta.
            IF cb-dmov.CLFAUX = "@CT" THEN 
                cb-dmov.CtaAut    = cb-dmov.CodAux.
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
                    cb-ctas.CodCta = cb-dmov.CtaAut ) AND
                    LENGTH( cb-dmov.CtaAut)  <>
                    INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles))
       THEN DO:
               MESSAGE "Cuentas Autom ticas a generar" SKIP
                       "Tienen mal registro" VIEW-AS ALERT-BOX ERROR.
       END.
        IF NOT CAN-FIND( cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
            cb-ctas.CodCta = cb-dmov.CtrCta ) AND
            LENGTH( cb-dmov.CtrCta )  <>
            INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles))
        THEN DO:
            MESSAGE "Cuentas Autom ticas a generar" SKIP
                    "Tienen mal registro" VIEW-AS ALERT-BOX ERROR.
        END.
    END.
    RUN Automaticas.
    FIND DETALLE WHERE RECID(DETALLE) = X-Recid.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Automaticas W-Maestro 
PROCEDURE Automaticas :
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
    /* Borrando las cuentas autom ticas generadas antes */
    FOR EACH DETALLE WHERE DETALLE.Relacion = RegAct:
        RUN GrabaAnt-det.
        IF DETALLE.TpoMov THEN /* Tipo H */
            ASSIGN cb-cmov.HbeMn1 = cb-cmov.HbeMn1 - DETALLE.ImpMn1
                   cb-cmov.HbeMn2 = cb-cmov.HbeMn2 - DETALLE.ImpMn2.

        ELSE
            ASSIGN cb-cmov.DbeMn1 = cb-cmov.DbeMn1 - DETALLE.ImpMn1
                   cb-cmov.DbeMn2 = cb-cmov.DbeMn2 - DETALLE.ImpMn2.
        DELETE DETALLE.
    END.
    /* Generando las cuentas autom ticas */
    IF cb-dmov.CtrCta <> ""
    THEN DO:
        FIND integral.cb-ctas WHERE integral.cb-ctas.CodCia = cb-codcia
            AND integral.cb-ctas.CodCta = cb-dmov.CodCta NO-LOCK NO-ERROR.
        ASSIGN x-ImpMn1 = cb-dmov.ImpMn1
               x-ImpMn2 = cb-dmov.ImpMn2

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
                     
                RECID-stack = RECID( DETALLE ).
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cbd-stack-act W-Maestro 
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
RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE check-cmov W-Maestro 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Control-Cheque W-Maestro 
PROCEDURE Control-Cheque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF INPUT FRAME F-maestro cb-cmov.impchq = 0 OR 
   cb-cmov.Coddoc:SCREEN-VALUE <> "CH" THEN RETURN.
FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                   cb-ctas.CodCta = INPUT FRAME F-maestro cb-cmov.CtaCja NO-ERROR.
IF AVAILABLE cb-ctas AND cb-ctas.PidDoc AND cb-ctas.CodDoc = "CH" THEN DO:
   IF INPUT FRAME F-maestro cb-cmov.Nrochq > cb-ctas.NroChq THEN 
      ASSIGN cb-ctas.NroChq = INPUT FRAME F-maestro cb-cmov.Nrochq.
   ASSIGN cb-ctas.NroChq = STRING(DECIMAL(cb-ctas.NroChq) + 1).
END.
RELEASE cb-ctas.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Del-Acumula W-Maestro 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Delete-Dmov W-Maestro 
PROCEDURE Delete-Dmov :
RegAct = RECID(cb-dmov).
    FIND cb-dmov WHERE RECID(cb-dmov) = RegAct EXCLUSIVE.
    RUN Del-Acumula.
    RUN GrabaAnt.
    DELETE cb-dmov.
    FOR EACH cb-dmov WHERE cb-dmov.Relacion = RegAct:
        FOR EACH BUF-AUTO WHERE BUF-AUTO.relacion = RECID(cb-dmov) :
            RUN Grababuf.
            RUN Del-Acumula.
            DELETE BUF-AUTO.                          
        END. 
        RUN Del-Acumula.
        RUN GrabaAnt.
        DELETE cb-dmov.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE detalle W-Maestro 
PROCEDURE detalle :
IF cb-cmov.girado:SCREEN-VALUE IN FRAME F-maestro = "" THEN
        cb-cmov.girado:SCREEN-VALUE = x-girado.
    IF cb-cmov.notast:SCREEN-VALUE = "" THEN
        cb-cmov.notast:SCREEN-VALUE = x-notast.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE diferencia-cmb W-Maestro 
PROCEDURE diferencia-cmb :
/* -----------------------------------------------------------
Diferencia de cambio.
-------------------------------------------------------------*/
x-totalMN1 = 0.
x-totalMN2 = 0.
RECID-tmp  = ?.
FOR EACH detalle WHERE detalle.CodCia  = s-codcia  AND
                       detalle.Periodo = s-periodo AND
                       detalle.NroMes  = s-NroMes  AND
                       detalle.CodOpe  = x-CodOpe  AND
                       detalle.NroAst  = cb-cmov.NroAst:SCREEN-VALUE IN FRAME F-maestro AND
                       detalle.tpoitm  = "P"      AND
                       detalle.impmn3 <> 0  :
    /* Eliminar diferencias de cambio anteriores */                   
    RECID-TMP = RECID(detalle).
    FOR EACH cb-dmov WHERE cb-dmov.relacion = RECID-TMP :
        FOR EACH BUF-AUTO WHERE BUF-AUTO.relacion = RECID(cb-dmov) :
              RegAct = RECID( BUF-AUTO ).
              RUN GRABABUF.
              RUN Del-Acumula.
              DELETE BUF-AUTO.                          
        END. 
        RegAct = RECID( detalle ).
        RUN Del-Acumula.
        run GrabaAnt.
        DELETE cb-dmov.                        
    END.           
    
    CASE detalle.TM :
         WHEN 2  THEN DO:
            IF ( detalle.IMPMN3 > 0 AND detalle.IMPMN3 <> ? )
                THEN RUN APLICA-DIF(Cta-PerDcb,
                                    Aux-PerDcb,
                                    CCo-PerDcb,
                                    FALSE,
                                    ABS(detalle.IMPMN3),
                                    0,
                                    RECID(DETALLE)).
            IF ( detalle.IMPMN3 < 0  AND detalle.IMPMN3 <> ? )
                THEN RUN APLICA-DIF(Cta-GanDcb,
                                    Aux-GanDcb,
                                    Cco-GanDcb,
                                    TRUE,
                                    ABS(detalle.IMPMN3),
                                    0,
                                    RECID(DETALLE)).
         END.
         WHEN 1  THEN DO:
            IF ( detalle.IMPMN3 > 0 AND detalle.IMPMN3 <> ? )
               THEN RUN APLICA-DIF(Cta-PerTrl,
                                   Aux-PerTrl,
                                   CCo-PerTrl,
                                   FALSE,
                                   0,
                                   ABS(detalle.IMPMN3),
                                   RECID(DETALLE)).
            IF ( detalle.IMPMN3 < 0 AND detalle.IMPMN3 <> ? )
               THEN RUN APLICA-DIF(Cta-GanTrl,
                                   Aux-GanTrl,
                                   CCo-GanTrl,
                                   TRUE,
                                   0,
                                   ABS(detalle.IMPMN3),
                                   RECID(DETALLE)).
         END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Maestro _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Maestro)
  THEN DELETE WIDGET W-Maestro.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Maestro _DEFAULT-ENABLE
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
  DISPLAY C-CodOpe FILL-IN-CodOpe X-NOMDIV x-NomCta Moneda F-SdoCta 
      WITH FRAME F-maestro IN WINDOW W-Maestro.
  IF AVAILABLE cb-cmov THEN 
    DISPLAY cb-cmov.NroAst cb-cmov.CodDiv cb-cmov.CtaCja cb-cmov.CodAux 
          cb-cmov.NroVou cb-cmov.Girado cb-cmov.NotAst cb-cmov.FchAst 
          cb-cmov.Usuario cb-cmov.CodDoc cb-cmov.NroChq cb-cmov.ImpChq 
          cb-cmov.TpoCmb cb-cmov.C-FCaja 
      WITH FRAME F-maestro IN WINDOW W-Maestro.
  ENABLE RECT-2 BRW-DETALLE C-CodOpe cb-cmov.NroAst cb-cmov.CodDiv 
         cb-cmov.CtaCja cb-cmov.CodAux cb-cmov.NroVou cb-cmov.Girado 
         cb-cmov.NotAst cb-cmov.FchAst cb-cmov.CodDoc cb-cmov.NroChq 
         cb-cmov.TpoCmb cb-cmov.C-FCaja B-impresoras 
      WITH FRAME F-maestro IN WINDOW W-Maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-maestro}
  ENABLE R-exit R-consulta B-query B-add B-update B-delete BUTTON-2 B-imprimir 
         B-first B-prev B-next B-last B-browse B-exit 
      WITH FRAME F-ctrl-frame IN WINDOW W-Maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-ctrl-frame}
  ENABLE R-navigaate-4 B-ok-3 B-Cancel-3 
      WITH FRAME F-search IN WINDOW W-Maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-search}
  ENABLE R-navigaate-3 B-ok-2 B-Cancel-2 
      WITH FRAME F-update IN WINDOW W-Maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-update}
  ENABLE R-navigaate-2 B-ok B-Cancel 
      WITH FRAME F-add IN WINDOW W-Maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-add}
  VIEW W-Maestro.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GrabaAnt W-Maestro 
PROCEDURE GrabaAnt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT cb-dmov.flgact THEN RETURN.
CREATE cbd-stack.
ASSIGN 
       cbd-stack.Clfaux = cb-dmov.Clfaux 
       cbd-stack.Codaux = cb-dmov.Codaux
       cbd-stack.CodCia = cb-dmov.CodCia
       cbd-stack.Codcta = cb-dmov.Codcta
       cbd-stack.CodDiv = cb-dmov.CodDiv
       cbd-stack.Coddoc = cb-dmov.Coddoc 
       cbd-stack.Codmon = cb-dmov.Codmon
       cbd-stack.Codope = cb-dmov.Codope
       cbd-stack.Ctrcta = cb-dmov.Ctrcta
       cbd-stack.Fchdoc = cb-dmov.Fchdoc
       cbd-stack.FchVto = cb-dmov.FchVto
       cbd-stack.ImpMn1 = cb-dmov.ImpMn1
       cbd-stack.ImpMn2 = cb-dmov.ImpMn2
       cbd-stack.ImpMn3 = cb-dmov.ImpMn3
       cbd-stack.Nroast = cb-dmov.Nroast
       cbd-stack.Nrodoc = cb-dmov.Nrodoc
       cbd-stack.NroMes = cb-dmov.NroMes
       cbd-stack.Periodo = cb-dmov.Periodo
       cbd-stack.recid-mov = RECID(cb-dmov)
       cbd-stack.Tpocmb = cb-dmov.Tpocmb
       cbd-stack.TpoItm = cb-dmov.TpoItm
       cbd-stack.TpoMov = cb-dmov.TpoMov.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GrabaAnt-Det W-Maestro 
PROCEDURE GrabaAnt-Det :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT detalle.flgact THEN RETURN.
CREATE cbd-stack.
ASSIGN 
       cbd-stack.Clfaux = detalle.Clfaux 
       cbd-stack.Codaux = detalle.Codaux
       cbd-stack.CodCia = detalle.CodCia
       cbd-stack.Codcta = detalle.Codcta
       cbd-stack.CodDiv = detalle.CodDiv
       cbd-stack.Coddoc = detalle.Coddoc 
       cbd-stack.Codmon = detalle.Codmon
       cbd-stack.Codope = detalle.Codope
       cbd-stack.Ctrcta = detalle.Ctrcta
       cbd-stack.Fchdoc = detalle.Fchdoc
       cbd-stack.Fchvto = detalle.Fchvto
       cbd-stack.ImpMn1 = detalle.ImpMn1
       cbd-stack.ImpMn2 = detalle.ImpMn2
       cbd-stack.ImpMn3 = detalle.ImpMn3
       cbd-stack.Nroast = detalle.Nroast
       cbd-stack.Nrodoc = detalle.Nrodoc
       cbd-stack.NroMes = detalle.NroMes
       cbd-stack.Periodo = detalle.Periodo
       cbd-stack.recid-mov = RECID(detalle)
       cbd-stack.Tpocmb = detalle.Tpocmb
       cbd-stack.TpoItm = detalle.TpoItm
       cbd-stack.TpoMov = detalle.TpoMov.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grababuf W-Maestro 
PROCEDURE grababuf :
IF NOT buf-auto.flgact THEN RETURN.
CREATE cbd-stack.
ASSIGN 
       cbd-stack.Clfaux = buf-auto.Clfaux 
       cbd-stack.Codaux = buf-auto.Codaux
       cbd-stack.CodCia = buf-auto.CodCia
       cbd-stack.Codcta = buf-auto.Codcta
       cbd-stack.CodDiv = buf-auto.CodDiv
       cbd-stack.Coddoc = buf-auto.Coddoc 
       cbd-stack.Codmon = buf-auto.Codmon
       cbd-stack.Codope = buf-auto.Codope
       cbd-stack.Ctrcta = buf-auto.Ctrcta
       cbd-stack.Fchdoc = buf-auto.Fchdoc
       cbd-stack.FchVto = buf-auto.FchVto
       cbd-stack.ImpMn1 = buf-auto.ImpMn1
       cbd-stack.ImpMn2 = buf-auto.ImpMn2
       cbd-stack.ImpMn3 = buf-auto.ImpMn3
       cbd-stack.Nroast = buf-auto.Nroast
       cbd-stack.Nrodoc = buf-auto.Nrodoc
       cbd-stack.NroMes = buf-auto.NroMes
       cbd-stack.Periodo = buf-auto.Periodo
       cbd-stack.recid-mov = RECID(buf-auto)
       cbd-stack.Tpocmb = buf-auto.Tpocmb
       cbd-stack.TpoItm = buf-auto.TpoItm
       cbd-stack.TpoMov = buf-auto.TpoMov.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importe-chq W-Maestro 
PROCEDURE importe-chq :
x-totalch1 = 0.
    x-totalch2 = 0.
    FOR EACH detalle WHERE detalle.codcia = s-codcia AND
        detalle.periodo = s-periodo AND
        detalle.nromes  = s-NroMes AND
        detalle.codope  = integral.cb-cmov.codope AND
        detalle.nroast  = integral.cb-cmov.nroast AND
        detalle.TpoItm  <> "B" :
        IF detalle.tpomov THEN DO:
            x-totalch1 = x-totalch1 - detalle.impmn1.
            x-totalch2 = x-totalch2 - detalle.impmn2.
        END.
        ELSE DO:
            x-totalch1 = x-totalch1 + detalle.impmn1.
            x-totalch2 = x-totalch2 + detalle.impmn2.
        END.
    END.
    IF Moneda:SCREEN-VALUE IN FRAME F-maestro = "Soles" THEN
        DISPLAY x-totalch1 @ integral.cb-cmov.Impchq WITH FRAME F-maestro.
    ELSE
        DISPLAY x-totalch2 @ integral.cb-cmov.Impchq WITH FRAME F-maestro.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIME-ORDENADO W-Maestro 
PROCEDURE IMPRIME-ORDENADO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER F-CUENTAS AS INTEGER.
    /* 1 TODAS LAS CUENTAS
       2 OMITIR AUTOMATICAS 
    */   
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

    RUN bin/_numero.p ( cb-cmov.impchq,2,1, OUTPUT x-impletra ).
    IF cb-cmov.codmon = 1 THEN x-impletra = x-impletra + "----NUEVOS SOLES".
    ELSE x-impletra = x-impletra + "----DOLARES AMERICANOS".
    DEFINE FRAME f-cab
        cb-dmov.coddiv LABEL "Division"
        cb-dmov.codcta LABEL "Cuenta"
        cb-dmov.clfaux LABEL "Clf!Aux"
        cb-dmov.codaux       LABEL "Auxiliar"
        cb-dmov.nroref LABEL "Provision"
        cb-dmov.coddoc COLUMN-LABEL "Cod!Doc."
        cb-dmov.nrodoc LABEL "Nro!Documento"
        cb-dmov.fchdoc LABEL "Fecha!Doc"
        x-glodoc       LABEL "Detalle"
        x-debe         LABEL "Cargos"
        x-haber        LABEL "Abonos"
        WITH WIDTH 155 NO-BOX STREAM-IO DOWN.
        
    find cb-ctas WHERE cb-ctas.codcia = cb-codcia AND
        cb-ctas.codcta = cb-cmov.ctacja NO-LOCK NO-ERROR.
    FIND FIRST GN-DIVI  WHERE GN-DIVI.codcia  =  S-codcia AND 
               GN-DIVI.codDIV  =  cb-cmov.coddiv
               NO-LOCK NO-ERROR.                                

    OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 33.   
    PUT STREAM report CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(33) .
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
    PUT STREAM report FILL("-",150) FORMAT "X(150)" SKIP.
    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = s-codcia
                    AND cb-dmov.periodo = s-periodo
                    AND cb-dmov.nromes  = s-NroMes
                    AND cb-dmov.codope  = cb-cmov.codope
                    AND cb-dmov.nroast  = cb-cmov.nroast
        BREAK BY (cb-dmov.nroast) 
              BY cb-dmov.codcta
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
    PUT STREAM report "SON : " x-impletra SKIP.
    DO WHILE LINE-COUNTER(report) < PAGE-SIZE(report) - 5 :
        PUT STREAM report "" skip.
    END.
    PUT STREAM report "-----------------       -----------------        ----------------- "  AT 30 SKIP.
    PUT STREAM report "      HECHO                 REVISADO              Vo.Bo.Gerencia          Impreso:" AT 30.
    PUT STREAM report x-impreso.
    OUTPUT STREAM report CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime2 W-Maestro 
PROCEDURE imprime2 :
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
    DEFINE INPUT PARAMETER F-CUENTAS AS INTEGER.
    /* 1 TODAS LAS CUENTAS
       2 OMITIR AUTOMATICAS 
    */   
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


    RUN bin/_numero.p ( cb-cmov.impchq,2,1, OUTPUT x-impletra ).
    IF cb-cmov.codmon = 1 THEN x-impletra = x-impletra + "----NUEVOS SOLES".
    ELSE x-impletra = x-impletra + "----DOLARES AMERICANOS".
    
    DEFINE FRAME f-cab
        cb-dmov.coddiv LABEL "Division"
        cb-dmov.codcta LABEL "Cuenta"
        cb-dmov.clfaux LABEL "Clf!Aux"
        cb-dmov.codaux       LABEL "Auxiliar"
        cb-dmov.nroref LABEL "Referencia"
        cb-dmov.coddoc COLUMN-LABEL "Cod!Doc."
        cb-dmov.nrodoc LABEL "Nro!Documento"
        cb-dmov.fchdoc LABEL "Fecha!Doc"
        x-glodoc       LABEL "Detalle"
        x-debe         LABEL "Cargos"
        x-haber        LABEL "Abonos"
        WITH WIDTH 155 NO-BOX STREAM-IO DOWN.
        
    find cb-ctas WHERE cb-ctas.codcia = cb-codcia AND
        cb-ctas.codcta = cb-cmov.ctacja NO-LOCK NO-ERROR.
    FIND FIRST GN-DIVI  WHERE GN-DIVI.codcia  =  S-codcia AND 
               GN-DIVI.codDIV  =  cb-cmov.coddiv
               NO-LOCK NO-ERROR.                                

    OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 33.   
    PUT STREAM report CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(33) .
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
    PUT STREAM report FILL("-",150) FORMAT "X(150)" SKIP.
    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = s-codcia
                    AND cb-dmov.periodo = s-periodo
                    AND cb-dmov.nromes  = s-NroMes
                    AND cb-dmov.codope  = cb-cmov.codope
                    AND cb-dmov.nroast  = cb-cmov.nroast
        BREAK BY (cb-dmov.nroast) ON ERROR UNDO, LEAVE:
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
    PUT STREAM report "SON : " x-impletra SKIP.
    DO WHILE LINE-COUNTER(report) < PAGE-SIZE(report) - 5 :
        PUT STREAM report "" skip.
    END.
    PUT STREAM report "-----------------       -----------------        ----------------- "  AT 30 SKIP.
    PUT STREAM report "      HECHO                 REVISADO              Vo.Bo.Gerencia          Impreso:" AT 30.
    PUT STREAM report x-impreso.
    OUTPUT STREAM report CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NROCHQ W-Maestro 
PROCEDURE NROCHQ :
/* Solo se ejecuta esta rutina en creaci¢n */

    IF NOT FRAME F-add:VISIBLE
    THEN RETURN.
    FIND LAST cabecera WHERE  cabecera.codcia = s-codcia AND
                              cabecera.ctacja = cb-cmov.ctacja:SCREEN-VALUE IN FRAME F-Maestro AND
                              CABECERA.CODDOC = "CH" AND
                              CABECERA.NROMES <= CB-CMOV.NROMES
                              NO-LOCK NO-ERROR.

    IF NOT AVAILABLE cabecera
    THEN RETURN.

    IF cabecera.NroChq = ""
    THEN RETURN.

    /* Incremetando */
    x-NroChq = cabecera.NroChq.
    x        = 0.
    lleva    = YES.
    c        = "".
    DO i = LENGTH( x-NroChq ) TO 1 BY -1 :
        c = SUBSTR( x-NroChq, i, 1).
        IF Lleva
        THEN DO:
            IF INDEX( "0123456789", c ) <> 0
            THEN IF c = "9"
                 THEN ASSIGN SUBSTR( x-NroChq, i, 1) = "0"
                             Lleva = YES.
                 ELSE ASSIGN SUBSTR( x-NroChq, i, 1) = STRING(INTEGER( c ) + 1)
                             Lleva = NO.
            IF INDEX( "ABCDEFGHIJKLMNOPQRSTUVWXYZ", CAPS(c) ) <> 0
            THEN IF  c  =  "Z"
                 THEN ASSIGN SUBSTR( x-NroChq, i, 1) = "A"
                             Lleva = YES.
                 ELSE ASSIGN SUBSTR( x-NroChq, i, 1) = CHR(ASC( c ) + 1)
                             Lleva = NO.
        END.
        x = x + 1.
    END.
    IF x = 0 THEN RETURN.
    DISPLAY x-nrochq @ cb-cmov.Nrochq WITH FRAME F-Maestro.
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pintado W-Maestro 
PROCEDURE Pintado :
DISPLAY {&FIELDS-IN-QUERY-F-Maestro} WITH FRAME F-Maestro.
    {&OPEN-QUERY-BRW-DETALLE}
    ASSIGN Moneda = "Soles"
           x-CodMon = 1
           x-nomcta:SCREEN-VALUE = ""
           x-nomdiv:SCREEN-VALUE = "".
    IF AVAILABLE {&FIRST-TABLE-IN-QUERY-F-Maestro} THEN
        CASE cb-cmov.CodMon:
            WHEN 1 THEN ASSIGN Moneda = "Soles"   x-CodMon = 1.
            WHEN 2 THEN ASSIGN Moneda = "D¢lares" x-CodMon = 2.
            OTHERWISE   ASSIGN Moneda = "Soles"   x-CodMon = 1.
        END CASE.
    DISPLAY  Moneda WITH FRAME F-maestro.
    IF NOT QUERY-OFF-END("BRW-detalle") AND x-CodMon <> LAST-CodMon
    THEN ASSIGN pto = BRW-detalle:MOVE-COLUMN( 7, 8 )
                LAST-CodMon = x-CodMon.
    find cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                       cb-ctas.CodCta = cb-cmov.CtaCja:SCREEN-VALUE
                       NO-LOCK NO-ERROR.
    IF AVAILABLE cb-ctas THEN x-nomcta:SCREEN-VALUE = integral.cb-ctas.Nomcta.
    
    FIND FIRST GN-DIVI  WHERE GN-DIVI.codcia  =  S-codcia AND 
                              GN-DIVI.codDIV  BEGINS CB-CMOV.CODDIV:SCREEN-VALUE
                              NO-LOCK NO-ERROR.                                
    IF NOT AVAIL GN-DIVI THEN X-NOMDIV:SCREEN-VALUE = "".
    ELSE ASSIGN CB-CMOV.CODDIV:SCREEN-VALUE = GN-DIVI.codDIV
                X-NOMDIV:SCREEN-VALUE = GN-DIVI.DESDIV.
    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Asignacion W-Maestro 
PROCEDURE Procesa-Asignacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME F-maestro:
       ASSIGN cb-dmov.cco     = RMOV.cco   
              cb-dmov.Clfaux  = RMOV.Clfaux
              cb-dmov.CndCmp  = RMOV.CndCmp
              cb-dmov.Codaux  = RMOV.Codaux
              cb-dmov.Codcta  = RMOV.Codcta
              cb-dmov.CodDiv  = RMOV.CodDiv
              cb-dmov.Coddoc  = RMOV.Coddoc
              cb-dmov.Codref  = RMOV.Codref
              cb-dmov.CtaAut  = RMOV.CtaAut
              cb-dmov.CtrCta  = RMOV.CtrCta
              cb-dmov.DisCCo  = RMOV.DisCCo
              cb-dmov.Fchdoc  = RMOV.Fchdoc
              cb-dmov.Fchvto  = RMOV.Fchvto
              cb-dmov.flgact  = RMOV.flgact
              cb-dmov.Glodoc  = RMOV.Glodoc
              cb-dmov.ImpMn1  = ABSOLUTE (RMOV.ImpMn1)
              cb-dmov.ImpMn2  = ABSOLUTE (RMOV.ImpMn2)
              cb-dmov.Nrodoc  = RMOV.Nrodoc
              cb-dmov.Nroref  = RMOV.NroRef
              cb-dmov.Nroruc  = RMOV.Nroruc
              cb-dmov.OrdCmp  = RMOV.OrdCmp
              cb-dmov.Tpocmb  = RMOV.Tpocmb
              cb-dmov.TpoMov  = RMOV.TpoMov
              cb-dmov.TpoItm  = "P"
              cb-dmov.Tm      = RMOV.CodMon
              x-Girado        = RMOV.Glodoc.
              
       IF RMOV.CodMon = 2 THEN 
          ASSIGN cb-dmov.ImpMn3 = RMOV.ImpMn2 * INPUT cb-cmov.TpoCmb - RMOV.ImpMn1.
       ELSE
          ASSIGN cb-dmov.ImpMn3 = RMOV.ImpMn1 / INPUT cb-cmov.TpoCmb - RMOV.ImpMn2.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Saldo-Cuenta W-Maestro 
PROCEDURE Saldo-Cuenta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER C-CODCTA AS CHAR.
DEFINE INPUT PARAMETER X-CODDIV AS CHAR.
DEFINE INPUT PARAMETER I-CODMON AS INTEGER.
DEFINE VARIABLE II AS INTEGER.
DEFINE VARIABLE D-SdoCta AS DECIMAL EXTENT 2 INITIAL 0.
     FIND cb-acmd WHERE cb-acmd.CodCia = S-CODCIA AND
                       cb-acmd.Periodo = S-PERIODO AND
                       cb-acmd.CodCta  = C-CODCTA AND
                       cb-acmd.CodAux  = "" AND
                       cb-acmd.CodDiv  BEGINS X-CODDIV
                       NO-LOCK NO-ERROR.
     IF AVAILABLE cb-acmd THEN 
        DO II = 1 TO 14:
           D-SdoCta[1] = D-SdoCta[1] + (DbeMn1[II] - HbeMn1[II]).
           D-SdoCta[2] = D-SdoCta[2] + (DbeMn2[II] - HbeMn2[II]).
        END.
     DISPLAY D-SdoCta[I-CODMON] @ F-SdoCta WITH FRAME F-maestro.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ultimo-item W-Maestro 
PROCEDURE ultimo-item :
/* calculo de cuenta 104?????  */
    x-Nroitm = 1.
    def var t-totalch1  as decimal.
    def var t-totalch2  as decimal.
    t-totalch1 = 0.
    t-totalch2 = 0.
    FOR EACH detalle WHERE detalle.codcia = s-codcia AND
        detalle.periodo = s-periodo AND
        detalle.nromes  = s-NroMes AND
        detalle.codope  = integral.cb-cmov.codope AND
        detalle.nroast  = integral.cb-cmov.nroast AND
        LOOKUP(detalle.TpoItm,"B,A") = 0 
        BREAK by detalle.coddiv :
              
        IF FIRST-OF (DETALLE.CodDiv) THEN DO:
           x-totalch1 = 0.
           x-totalch2 = 0.
        END.
        IF detalle.tpomov THEN DO:
            x-totalch1 = x-totalch1 - detalle.impmn1.
            x-totalch2 = x-totalch2 - detalle.impmn2.
            t-totalch1 = t-totalch1 - detalle.impmn1.
            t-totalch2 = t-totalch2 - detalle.impmn2.
        END.
        ELSE DO:
            x-totalch1 = x-totalch1 + detalle.impmn1.
            x-totalch2 = x-totalch2 + detalle.impmn2.
            t-totalch1 = t-totalch1 + detalle.impmn1.
            t-totalch2 = t-totalch2 + detalle.impmn2.
        END.
        IF LAST-OF (DETALLE.CodDiv) THEN DO:
           FIND LAST cb-dmov WHERE cb-dmov.CodCia  = s-codcia AND
                                   cb-dmov.Periodo = s-periodo    AND
                                   cb-dmov.NroMes  = s-NroMes    AND
                                   cb-dmov.CodOpe  = x-CodOpe AND
                                   cb-dmov.NroAst  = cb-cmov.NroAst:SCREEN-VALUE IN FRAME F-maestro
                                   NO-LOCK NO-ERROR.
           IF AVAILABLE cb-dmov THEN x-NroItm = cb-dmov.NroItm + 1.
           CREATE cb-dmov.
           ASSIGN 
           cb-dmov.CodCia  = s-codcia
           cb-dmov.Periodo = s-periodo
           cb-dmov.NroMes  = s-NroMes
           cb-dmov.CodOpe  = x-CodOpe
           cb-dmov.NroAst  = cb-cmov.NroAst:SCREEN-VALUE
           cb-dmov.Codcta  = cb-cmov.ctacja:SCREEN-VALUE
           cb-dmov.CodMon  = x-CodMon
           cb-dmov.TpoCmb  = INPUT cb-cmov.TpoCmb
           cb-dmov.FchDoc  = INPUT cb-cmov.FchAst
           cb-dmov.CLFAUX  = X-CLFAUX
           cb-dmov.CODAUX  = INPUT cb-cmov.CODAUX
           cb-dmov.NroItm  = x-NroItm
           cb-cmov.TotItm  = x-NroItm
           cb-dmov.TpoMov  = (x-totalch1 > 0) 
           cb-dmov.ImpMn1  = ABS(x-totalch1)
           cb-dmov.ImpMn2  = ABS(x-totalch2)
           cb-dmov.CodDoc  = INPUT cb-cmov.CODDOC
           cb-dmov.CODDIV  = detalle.coddiv
           cb-dmov.nrodoc  = integral.cb-cmov.nrochq:SCREEN-VALUE
           cb-dmov.TpoItm  = "B".
           RegAct = RECID( cb-dmov ).
           RUN Acumula.
        END.
        
    END.
    IF Moneda:SCREEN-VALUE IN FRAME F-maestro = "Soles" THEN
        DISPLAY t-totalch1 @ integral.cb-cmov.Impchq WITH FRAME F-maestro.
    ELSE
        DISPLAY t-totalch2 @ integral.cb-cmov.Impchq WITH FRAME F-maestro.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


