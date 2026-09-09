&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
CREATE WIDGET-POOL.

&IF "{&NEW}" = "" &THEN
    DEFINE INPUT PARAMETER        P-PAGAR   AS LOGICAL.
    DEFINE INPUT-OUTPUT PARAMETER P-CODDOC  AS CHAR.
    DEFINE INPUT-OUTPUT PARAMETER P-CODDIV  AS CHAR.
    DEFINE INPUT-OUTPUT PARAMETER P-CODAUX  AS CHAR.
    DEFINE INPUT-OUTPUT PARAMETER P-NRODOC  AS CHAR.
    DEFINE INPUT-OUTPUT PARAMETER X-CLFAUX  AS CHAR.
&ELSE
    DEFINE VAR P-PAGAR   AS LOGICAL INIT YES.
    DEFINE VAR P-CODDIV  AS CHAR    INIT "".
    DEFINE VAR P-CODDOC  AS CHAR    INIT "F/.".
    DEFINE VAR P-CODAUX  AS CHAR    INIT "".
    DEFINE VAR P-NRODOC  AS CHAR    INIT "".
    DEFINE VAR  X-CLFAUX  AS CHAR.
&ENDIF


{BIN/S-GLOBAL.I}
{CBD/CBGLOBAL.I}

DEF VAR X-CUENTAS AS CHAR INIT "".
DEF VAR X-CODOPE  AS CHAR INIT "".
DEF VAR T-CODOPE  AS CHAR INIT "".

DEFINE TEMP-TABLE T-DOC 
 FIELD CODDOC    AS CHAR
 FIELD L-CODOPE  AS CHAR
 FIELD L-CUENTAS AS CHAR
 INDEX IDX01 CODDOC.

DEF VAR X-T AS CHAR FORMAT "X".


&Scoped-define gotzila OPEN QUERY BROWSE-2 FOR EACH integral.Cb-dmov ~
      WHERE CB-DMOV.CODCIA   = S-CODCIA   AND ~
CB-DMOV.PERIODO  = S-PERIODO  AND ~
CB-DMOV.NROMES   >= C-MES-1   AND ~
CB-DMOV.NROMES   <= C-MES-2   AND ~
CB-DMOV.CODDIV   BEGINS x-CODDIV AND ~
CB-DMOV.CODAUX   BEGINS x-CODAUX AND ~
CB-DMOV.NRODOC   BEGINS x-NRODOC AND ~
CB-DMOV.CODDOC    = C-DOC  AND ~
LOOKUP(CB-DMOV.CODCTA,X-CUENTAS) > 0 AND ~
LOOKUP(CB-DMOV.CODOPE,X-CODOPE) > 0  ~
NO-LOCK ~
    BY integral.Cb-dmov.Codaux ~
    BY integral.Cb-dmov.Coddoc ~
    BY integral.Cb-dmov.Nrodoc INDEXED-REPOSITION.


&Scoped-define gotsuqui OPEN QUERY BROWSE-2 FOR EACH integral.Cb-dmov ~
      WHERE CB-DMOV.CODCIA   = S-CODCIA   AND ~
CB-DMOV.PERIODO  = S-PERIODO  AND ~
CB-DMOV.NROMES   >= C-MES-1   AND ~
CB-DMOV.NROMES   <= C-MES-2   AND ~
CB-DMOV.CODDIV   BEGINS x-CODDIV AND ~
CB-DMOV.CODAUX   BEGINS x-CODAUX AND ~
CB-DMOV.NRODOC   BEGINS x-NRODOC AND ~
CB-DMOV.CODDOC    = C-DOC  AND ~
lOOKUP(CB-DMOV.CODCTA,X-CUENTAS) > 0 ~
NO-LOCK ~
    BY integral.Cb-dmov.Codaux ~
    BY integral.Cb-dmov.Coddoc ~
    BY integral.Cb-dmov.Nrodoc INDEXED-REPOSITION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Cb-dmov

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 Cb-dmov.CodDiv Cb-dmov.Codaux ~
Cb-dmov.Nrodoc Cb-dmov.Glodoc ~
IF (cb-dmov.tpomov) THEN ('-') ELSE ('+') @ X-T Cb-dmov.ImpMn1 ~
Cb-dmov.ImpMn2 Cb-dmov.NroMes Cb-dmov.Codope Cb-dmov.Fchdoc Cb-dmov.Nroast ~
Cb-dmov.Codcta Cb-dmov.Clfaux Cb-dmov.Coddoc Cb-dmov.Nroref Cb-dmov.cco ~
Cb-dmov.TpoMov Cb-dmov.Tpocmb Cb-dmov.Codmon 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-2
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH Cb-dmov NO-LOCK ~
    BY Cb-dmov.Codaux ~
       BY Cb-dmov.Coddoc ~
        BY Cb-dmov.Nrodoc INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 Cb-dmov
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 Cb-dmov


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 C-doc X-CodDiv Aceptar c-mes-1 ~
x-codaux c-mes-2 x-NroDoc B-Salir COMBO-BOX-2 B-aceptar 
&Scoped-Define DISPLAYED-OBJECTS C-doc X-CodDiv c-mes-1 x-codaux c-mes-2 ~
x-NroDoc COMBO-BOX-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Aceptar 
     LABEL "Aceptar" 
     SIZE 10 BY .85.

DEFINE BUTTON B-aceptar 
     LABEL "Filtrar" 
     SIZE 9.57 BY .85.

DEFINE BUTTON B-Salir 
     LABEL "Salir" 
     SIZE 10 BY .85.

DEFINE VARIABLE C-doc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEMS "Item 1" 
     SIZE 8.29 BY 1 NO-UNDO.

DEFINE VARIABLE c-mes-1 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Del Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 13
     LIST-ITEMS "0","1","2","3","4","5","6","7","8","9","10","11","12","13" 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE c-mes-2 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Hasta el Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 13
     LIST-ITEMS "0","1","2","3","4","5","6","7","8","9","10","11","12","13" 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Ver solo Provisiones" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Ver solo Provisiones","Todo el movimiento" 
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE x-codaux AS CHARACTER FORMAT "X(8)":U 
     LABEL "Auxiliar" 
     VIEW-AS FILL-IN 
     SIZE 10.86 BY .85
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE X-CodDiv AS CHARACTER FORMAT "X(5)":U 
     LABEL "Divisi¢n" 
     VIEW-AS FILL-IN 
     SIZE 8.72 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-NroDoc AS CHARACTER FORMAT "X(10)":U 
     LABEL "Nro Documento" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .85
     BGCOLOR 15  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      Cb-dmov SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      Cb-dmov.CodDiv COLUMN-LABEL "Divis" FORMAT "x(8)"
      Cb-dmov.Codaux COLUMN-LABEL "Auxiliar" FORMAT "x(10)"
      Cb-dmov.Nrodoc COLUMN-LABEL "Nro!Documento" FORMAT "x(14)"
      Cb-dmov.Glodoc
      IF (cb-dmov.tpomov) THEN ('-') ELSE ('+') @ X-T COLUMN-LABEL "T" FORMAT "X"
      Cb-dmov.ImpMn1
      Cb-dmov.ImpMn2
      Cb-dmov.NroMes
      Cb-dmov.Codope
      Cb-dmov.Fchdoc COLUMN-LABEL "Fecha......"
      Cb-dmov.Nroast
      Cb-dmov.Codcta
      Cb-dmov.Clfaux FORMAT "xxxx"
      Cb-dmov.Coddoc
      Cb-dmov.Nroref
      Cb-dmov.cco
      Cb-dmov.TpoMov
      Cb-dmov.Tpocmb
      Cb-dmov.Codmon
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 81 BY 11.69
         BGCOLOR 15 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-2 AT ROW 3.38 COL 1.14
     C-doc AT ROW 1.12 COL 8.14 COLON-ALIGNED
     X-CodDiv AT ROW 2.27 COL 8.14 COLON-ALIGNED
     Aceptar AT ROW 15.19 COL 19.86
     c-mes-1 AT ROW 1.12 COL 27.14 COLON-ALIGNED
     x-codaux AT ROW 2.27 COL 24.29 COLON-ALIGNED
     c-mes-2 AT ROW 1.12 COL 50.86 COLON-ALIGNED
     x-NroDoc AT ROW 2.23 COL 50.86 COLON-ALIGNED
     B-Salir AT ROW 15.19 COL 52.14
     COMBO-BOX-2 AT ROW 1.12 COL 61 COLON-ALIGNED NO-LABEL
     B-aceptar AT ROW 2.23 COL 71
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81.29 BY 16.73
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
         TITLE              = "Consulta de Provisiones"
         HEIGHT             = 15.08
         WIDTH              = 81.29
         MAX-HEIGHT         = 17.73
         MAX-WIDTH          = 91.43
         VIRTUAL-HEIGHT     = 17.73
         VIRTUAL-WIDTH      = 91.43
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
/* BROWSE-TAB BROWSE-2 1 F-Main */
ASSIGN 
       BROWSE-2:NUM-LOCKED-COLUMNS IN FRAME F-Main = 3.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "integral.Cb-dmov"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "integral.Cb-dmov.Codaux|yes,integral.Cb-dmov.Coddoc|yes,integral.Cb-dmov.Nrodoc|yes"
     _FldNameList[1]   > integral.Cb-dmov.CodDiv
"Cb-dmov.CodDiv" "Divis" "x(8)" "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   > integral.Cb-dmov.Codaux
"Cb-dmov.Codaux" "Auxiliar" "x(10)" "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > integral.Cb-dmov.Nrodoc
"Cb-dmov.Nrodoc" "Nro!Documento" "x(14)" "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   = integral.Cb-dmov.Glodoc
     _FldNameList[5]   > "_<CALC>"
"IF (cb-dmov.tpomov) THEN ('-') ELSE ('+') @ X-T" "T" "X" ? ? ? ? ? ? ? no ?
     _FldNameList[6]   = integral.Cb-dmov.ImpMn1
     _FldNameList[7]   = integral.Cb-dmov.ImpMn2
     _FldNameList[8]   = integral.Cb-dmov.NroMes
     _FldNameList[9]   = integral.Cb-dmov.Codope
     _FldNameList[10]   > integral.Cb-dmov.Fchdoc
"Cb-dmov.Fchdoc" "Fecha......" ? "date" ? ? ? ? ? ? no ?
     _FldNameList[11]   = integral.Cb-dmov.Nroast
     _FldNameList[12]   = integral.Cb-dmov.Codcta
     _FldNameList[13]   > integral.Cb-dmov.Clfaux
"Cb-dmov.Clfaux" ? "xxxx" "character" ? ? ? ? ? ? no ?
     _FldNameList[14]   = integral.Cb-dmov.Coddoc
     _FldNameList[15]   = integral.Cb-dmov.Nroref
     _FldNameList[16]   = integral.Cb-dmov.cco
     _FldNameList[17]   = integral.Cb-dmov.TpoMov
     _FldNameList[18]   = integral.Cb-dmov.Tpocmb
     _FldNameList[19]   = integral.Cb-dmov.Codmon
     _Query            is NOT OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Consulta de Provisiones */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Consulta de Provisiones */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Aceptar W-Win
ON CHOOSE OF Aceptar IN FRAME F-Main /* Aceptar */
DO:
   ASSIGN P-CODDIV = CB-DMOV.CODDIV
          P-CODDOC = CB-DMOV.CODDOC
          P-CODAUX = CB-DMOV.CODAUX
          P-NRODOC = CB-DMOV.NRODOC
          X-CLFAUX = CB-DMOV.CLFAUX.
   APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-aceptar W-Win
ON CHOOSE OF B-aceptar IN FRAME F-Main /* Filtrar */
DO:
    DEF VAR T AS   LOGICAL.
    assign c-mes-1 c-mes-2
           X-CODDIV
           X-CODAUX
           X-NRODOC.
  /*         
    MESSAGE C-DOC X-CUENTAS X-CODOPE VIEW-AS  ALERT-BOX .
   */ 
    
    if c-mes-2 < c-mes-1 then do:
       message "Rango de meses no valido"
       VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY":U TO C-MES-2.
    end.
    T = SESSION:SET-WAIT-STATE("GENERAL").
    if X-CODOPE = T-CODOPE then {&gotsuqui}
                           else {&gotzila}
    T = SESSION:SET-WAIT-STATE("").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Salir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Salir W-Win
ON CHOOSE OF B-Salir IN FRAME F-Main /* Salir */
DO:
   APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-doc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-doc W-Win
ON VALUE-CHANGED OF C-doc IN FRAME F-Main /* Documento */
DO:
  assign c-doc.
  FIND T-DOC WHERE T-DOC.CODDOC = C-DOC NO-ERROR.
  IF AVAIL T-DOC THEN ASSIGN X-CODOPE = T-DOC.L-CODOPE
                             X-CUENTAS = T-DOC.L-CUENTAS.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-2 W-Win
ON VALUE-CHANGED OF COMBO-BOX-2 IN FRAME F-Main
DO:
  
  CASE LOOKUP(SELF:SCREEN-VALUE , COMBO-BOX-2:LIST-ITEMS ) :
      WHEN 1 THEN DO:
             FIND T-DOC WHERE T-DOC.CODDOC = C-DOC NO-ERROR.
             IF AVAIL T-DOC THEN ASSIGN X-CODOPE = T-DOC.L-CODOPE.                           
             END.
      WHEN 2 THEN X-CODOPE = T-CODOPE.
  END CASE.
  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-codaux
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-codaux W-Win
ON MOUSE-SELECT-DBLCLICK OF x-codaux IN FRAME F-Main /* Auxiliar */
OR "F8" OF x-codaux DO:

DEF VAR X-CLFAUX AS CHAR.
DEF VAR X-CODCTA AS CHAR.
FIND T-DOC WHERE T-DOC.CODDOC = C-DOC NO-ERROR.
IF NOT AVAIL T-DOC THEN RETURN NO-APPLY.
IF T-DOC.L-CUENTAS = "" THEN RETURN NO-APPLY.
X-CODCTA = ENTRY(1 , T-DOC.L-CUENTAS).
FIND CB-CTAS WHERE CB-CTAS.CODCIA = CB-CODCIA AND
                   CB-CTAS.CODCTA = X-CODCTA
                   NO-LOCK NO-ERROR.
IF NOT AVAIL CB-CTAS THEN RETURN NO-APPLY.
X-CLFAUX = CB-CTAS.CLFAUX.
IF X-CLFAUX = "" THEN RETURN NO-APPLY.                   

                         
  
    DEF VAR T-ROWID AS ROWID.
    DEF VAR T-RECID AS RECID.  

    
    CASE X-CLFAUX :
    WHEN "@PV"  THEN DO:
        RUN ADM/H-PROV01.W(s-codcia , OUTPUT T-ROWID).
        IF T-ROWID <> ?
        THEN DO:
            FIND gn-prov WHERE ROWID(gn-prov) = T-ROWID NO-LOCK NO-ERROR.
            IF AVAILABLE gn-prov
            THEN  SELF:SCREEN-VALUE  = gn-prov.CodPro.
        END.
    END.
    WHEN "@CL" THEN DO:
        RUN ADM/H-CLIE01.W(s-codcia, OUTPUT T-ROWID).    
        IF T-ROWID <> ?
        THEN DO:
            FIND gn-clie WHERE ROWID(gn-clie) = T-ROWID NO-LOCK NO-ERROR.
            IF AVAIL gn-clie
            THEN SELF:SCREEN-VALUE  = gn-clie.codcli.
        END.
    END.
    WHEN "@CT" THEN DO:
            RUN cbd/q-ctas2.w(cb-codcia, "9", OUTPUT T-RECID).
            IF T-RECID <> ?
            THEN DO:
                find cb-ctas WHERE RECID(cb-ctas) = T-RECID NO-LOCK  NO-ERROR.
                IF avail cb-ctas
                THEN  self:screen-value = cb-ctas.CodCta.
            END.
  
    END.
    OTHERWISE DO:
        RUN CBD/H-AUXI01(s-codcia, X-ClfAux , OUTPUT T-ROWID ).     
        IF T-ROWID <> ?
        THEN DO:
            FIND cb-auxi WHERE ROWID(cb-auxi) = T-ROWID NO-LOCK  NO-ERROR.
            IF AVAIL cb-auxi
            THEN self:screen-value = cb-auxi.CodAux.
        END.
    END.
    END CASE.
  

  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME X-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL X-CodDiv W-Win
ON F8 OF X-CodDiv IN FRAME F-Main /* Divisi¢n */
OR "MOUSE-SELECT-DBLCLICK":U OF X-CodDiv DO: 
   {CBD/H-DIVI01.I NO SELF}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NroDoc W-Win
ON MOUSE-SELECT-DBLCLICK OF x-NroDoc IN FRAME F-Main /* Nro Documento */
/*
OR "F8" OF X-AUXILIAR DO:
DEF VAR X-CLFAUX AS CHAR.
DEF VAR X-CLFAUX-1 AS CHAR.
DEF VAR X-CLFAUX-2 AS CHAR.

assign
  x-clfaux = ""
  x-clfaux-1 = ""
  x-clfaux-2 = "".
  
find cb-ctas where cb-ctas.codcia = cb-codcia and
                   cb-ctas.codcta = x-cta-ini:screen-value
                   no-lock no-error.
                   
if avail cb-ctas then  x-clfaux-1 = cb-ctas.clfaux.
                      
find cb-ctas where cb-ctas.codcia = cb-codcia and
                   cb-ctas.codcta = x-cta-fin:screen-value
                   no-lock no-error.
if avail cb-ctas then  x-clfaux-2 = cb-ctas.clfaux.

if x-clfaux-1 = x-clfaux-2 then x-clfaux = x-clfaux-1.

if x-clfaux-1 <> "" and  x-clfaux-2  = "" then return no-apply.
if x-clfaux-1 =  "" and  x-clfaux-2 <> "" then return no-apply.


if x-clfaux = "" then return.
  

  
    DEF VAR T-ROWID AS ROWID.
    DEF VAR T-RECID AS RECID.  

    
    CASE X-CLFAUX :
    WHEN "@PV"  THEN DO:
        RUN ADM/H-PROV01.W(s-codcia , OUTPUT T-ROWID).
        IF T-ROWID <> ?
        THEN DO:
            FIND gn-prov WHERE ROWID(gn-prov) = T-ROWID NO-LOCK NO-ERROR.
            IF AVAILABLE gn-prov
            THEN  SELF:SCREEN-VALUE  = gn-prov.CodPro.
        END.
    END.
    WHEN "@CL" THEN DO:
        RUN ADM/H-CLIE01.W(s-codcia, OUTPUT T-ROWID).    
        IF T-ROWID <> ?
        THEN DO:
            FIND gn-clie WHERE ROWID(gn-clie) = T-ROWID NO-LOCK NO-ERROR.
            IF AVAIL gn-clie
            THEN SELF:SCREEN-VALUE  = gn-clie.codcli.
        END.
    END.
    WHEN "@CT" THEN DO:
            RUN cbd/q-ctas2.w(cb-codcia, "9", OUTPUT T-RECID).
            IF T-RECID <> ?
            THEN DO:
                find cb-ctas WHERE RECID(cb-ctas) = T-RECID NO-LOCK  NO-ERROR.
                IF avail cb-ctas
                THEN  self:screen-value = cb-ctas.CodCta.
            END.
  
    END.
    OTHERWISE DO:
        RUN CBD/H-AUXI01(s-codcia, X-ClfAux , OUTPUT T-ROWID ).     
        IF T-ROWID <> ?
        THEN DO:
            FIND cb-auxi WHERE ROWID(cb-auxi) = T-ROWID NO-LOCK  NO-ERROR.
            IF AVAIL cb-auxi
            THEN self:screen-value = cb-auxi.CodAux.
        END.
    END.
    END CASE.
  
*/  
  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
       
/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
  DISPLAY C-doc X-CodDiv c-mes-1 x-codaux c-mes-2 x-NroDoc COMBO-BOX-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-2 C-doc X-CodDiv Aceptar c-mes-1 x-codaux c-mes-2 x-NroDoc 
         B-Salir COMBO-BOX-2 B-aceptar 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
DO WITH FRAME {&FRAME-NAME} :
  
  {&WINDOW-NAME}:TITLE = "Provisiones: " + substring(s-nomcia,1,30) + "-" + string(s-periodo,"9,999").
   
  DEF VAR L-DOCS AS CHAR INIT "".
  ASSIGN C-MES-1    = 0
         C-MES-2    = S-NROMES.
  T-CODOPE = "".       
  FOR EACH CB-OPER NO-LOCK WHERE CB-OPER.CODCIA = CB-CODCIA :
      T-CODOPE = T-CODOPE + CB-OPER.CODOPE + ",". 
      
  END.        
  IF T-CODOPE <> "" THEN 
      T-CODOPE  =  SUBSTRING(T-CODOPE , 1 , LENGTH(T-CODOPE ) - 1).                       
  
  FOR EACH CP-TPRO NO-LOCK  WHERE CP-TPRO.CODCIA      = CB-CODCIA  AND
                                  CP-TPRO.CORRELATIVO = P-PAGAR
                            BREAK BY CP-TPRO.CODDOC :
                            
      IF FIRST-OF(CP-TPRO.CODDOC) THEN DO:
         ASSIGN L-DOCS = L-DOCS + CP-TPRO.CODDOC + ",".                      
         CREATE T-DOC.
         ASSIGN T-DOC.CODDOC = CP-TPRO.CODDOC.
         ASSIGN T-DOC.L-CODOPE = "000,".
      END.   
      ASSIGN T-DOC.L-CODOPE   = T-DOC.L-CODOPE  + CP-TPRO.CODOPE + ","
             T-DOC.L-CUENTAS  = T-DOC.L-CUENTAS + CP-TPRO.CODCTA + ",".
             
      IF LAST-OF(CP-TPRO.CODDOC) THEN DO:
       IF T-DOC.L-CODOPE  <> "" THEN 
          T-DOC.L-CODOPE  =  SUBSTRING(T-DOC.L-CODOPE , 1 , LENGTH(T-DOC.L-CODOPE ) - 1).                       
       IF T-DOC.L-CUENTAS <> "" THEN    
          T-DOC.L-CUENTAS =  SUBSTRING(T-DOC.L-CUENTAS, 1 , LENGTH(T-DOC.L-CUENTAS) - 1).                       
      END.       
  
  END.
  C-DOC = P-CODDOC.
  x-codaux = P-CODAUX.
  X-CODDIV = P-CODDIV.
  X-NRODOC = P-NRODOC.
  IF L-DOCS <> "" THEN DO:
      L-DOCS = SUBSTRING(L-DOCS , 1 , LENGTH(L-DOCS) - 1).                       
      C-DOC:LIST-ITEMS = L-DOCS.
      IF P-CODDOC <> "" THEN C-DOC:SCREEN-VALUE = P-CODDOC.
  END.    
 
END.

FIND T-DOC WHERE T-DOC.CODDOC = P-CODDOC NO-ERROR.
IF AVAIL T-DOC THEN ASSIGN X-CUENTAS = T-DOC.L-CUENTAS
                           X-CODOPE  = T-DOC.L-CODOPE.


  
RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "Cb-dmov"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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


