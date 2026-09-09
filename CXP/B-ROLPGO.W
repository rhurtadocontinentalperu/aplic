&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*------------------------------------------------------------------------

  File:  

  Description: from BROWSER.W - Basic SmartBrowser Object Template

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
DEFINE VAR x-Mon AS CHAR FORMAT "X(3)" NO-UNDO.
DEF VAR P-DOC AS CHAR INIT "" NO-UNDO.

{BIN/S-GLOBAL.I}
{CXP/CPGLOBAL.I}


DEF VAR X-MENSAJE AS CHAR FORMAT "X(40)".

DEFINE FRAME F-MENSAJE 
       X-MENSAJE
       WITH TITLE "Espere un momento por favor.."
            CENTERED NO-LABELS VIEW-AS DIALOG-BOX.
            
DEF BUFFER B-DMOV FOR CB-DMOV.
DEF BUFFER B-DROL FOR cp-drol.
DEFINE SHARED TEMP-TABLE T-DROL LIKE CP-DROL.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES cp-brol
&Scoped-define FIRST-EXTERNAL-TABLE cp-brol


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cp-brol.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cp-drol

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table cp-drol.Glosa cp-drol.Coddoc ~
cp-drol.Nrodoc cp-drol.FchDoc cp-drol.FchVto X-MON @ X-MON cp-drol.Importe ~
cp-drol.imppgo cp-drol.Fchpago cp-drol.TpoMov cp-drol.CodBco cp-drol.Clfaux ~
cp-drol.CodDiv cp-drol.Codcta cp-drol.Codaux cp-drol.NomAux cp-drol.FlgPgo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table cp-drol.imppgo 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table cp-drol
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table cp-drol
&Scoped-define QUERY-STRING-br_table FOR EACH cp-drol WHERE cp-drol.CodCia = cp-brol.CodCia ~
  AND cp-drol.Periodo = cp-brol.Periodo ~
  AND cp-drol.NroMes = cp-brol.Nromes ~
  AND cp-drol.Nrorol = cp-brol.Nrorol ~
  AND cp-drol.ctabco = cp-brol.ctabco ~
 NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH cp-drol WHERE cp-drol.CodCia = cp-brol.CodCia ~
  AND cp-drol.Periodo = cp-brol.Periodo ~
  AND cp-drol.NroMes = cp-brol.Nromes ~
  AND cp-drol.Nrorol = cp-brol.Nrorol ~
  AND cp-drol.ctabco = cp-brol.ctabco ~
 NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table cp-drol
&Scoped-define FIRST-TABLE-IN-QUERY-br_table cp-drol


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-24 br_table Btn-Asigna Btn-Delete C-doc ~
x-codaux F-Banco 
&Scoped-Define DISPLAYED-OBJECTS F-SOLES F-DOLAR C-doc x-codaux F-Banco 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-Asigna 
     LABEL "&Asignar" 
     SIZE 8.29 BY .81.

DEFINE BUTTON Btn-Delete 
     LABEL "Borrar" 
     SIZE 8.29 BY .81.

DEFINE VARIABLE C-doc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cod. Doc." 
     VIEW-AS COMBO-BOX INNER-LINES 20
     DROP-DOWN-LIST
     SIZE 9.86 BY 1 NO-UNDO.

DEFINE VARIABLE F-Banco AS CHARACTER FORMAT "X(256)":U 
     LABEL "Banco" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .69 NO-UNDO.

DEFINE VARIABLE F-DOLAR AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "Dolares (US$)" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .69 NO-UNDO.

DEFINE VARIABLE F-SOLES AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "Soles (S/.)" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .69 NO-UNDO.

DEFINE VARIABLE x-codaux AS CHARACTER FORMAT "X(8)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 8.72 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90.43 BY 7.5.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      cp-drol SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      cp-drol.Glosa FORMAT "X(35)":U
      cp-drol.Coddoc COLUMN-LABEL "Cod.!Doc." FORMAT "x(4)":U
      cp-drol.Nrodoc FORMAT "x(10)":U
      cp-drol.FchDoc FORMAT "99/99/9999":U
      cp-drol.FchVto FORMAT "99/99/9999":U
      X-MON @ X-MON COLUMN-LABEL "Mon" FORMAT "x(3)":U
      cp-drol.Importe FORMAT "-ZZZ,ZZZ,ZZ9.99":U
      cp-drol.imppgo FORMAT "-ZZZ,ZZZ,ZZ9.99":U
      cp-drol.Fchpago COLUMN-LABEL "Fecha Pago" FORMAT "99/99/9999":U
      cp-drol.TpoMov FORMAT "H/D":U
      cp-drol.CodBco COLUMN-LABEL "Cod.!Bco." FORMAT "x(3)":U
      cp-drol.Clfaux FORMAT "X(3)":U
      cp-drol.CodDiv FORMAT "x(5)":U
      cp-drol.Codcta FORMAT "x(7)":U
      cp-drol.Codaux COLUMN-LABEL "Auxiliar" FORMAT "x(12)":U
      cp-drol.NomAux FORMAT "X(35)":U
      cp-drol.FlgPgo FORMAT "Si/No":U
  ENABLE
      cp-drol.imppgo
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 90 BY 5.19
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.12 COL 1.29
     F-SOLES AT ROW 6.65 COL 36.43 COLON-ALIGNED
     F-DOLAR AT ROW 6.65 COL 61.72 COLON-ALIGNED
     Btn-Asigna AT ROW 7.5 COL 2.43
     Btn-Delete AT ROW 7.5 COL 11
     C-doc AT ROW 7.58 COL 26.14 COLON-ALIGNED
     x-codaux AT ROW 7.58 COL 47.86 COLON-ALIGNED
     F-Banco AT ROW 7.58 COL 66.29 COLON-ALIGNED
     RECT-24 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: integral.cp-brol
   Allow: Basic,Browse
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
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 7.58
         WIDTH              = 90.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table RECT-24 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-DOLAR IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-SOLES IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.cp-drol WHERE integral.cp-brol <external> ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _JoinCode[1]      = "cp-drol.CodCia = cp-brol.CodCia
  AND cp-drol.Periodo = cp-brol.Periodo
  AND cp-drol.NroMes = cp-brol.Nromes
  AND cp-drol.Nrorol = cp-brol.Nrorol
  AND cp-drol.ctabco = cp-brol.ctabco
"
     _FldNameList[1]   > integral.cp-drol.Glosa
"cp-drol.Glosa" ? "X(35)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.cp-drol.Coddoc
"cp-drol.Coddoc" "Cod.!Doc." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = integral.cp-drol.Nrodoc
     _FldNameList[4]   = integral.cp-drol.FchDoc
     _FldNameList[5]   = integral.cp-drol.FchVto
     _FldNameList[6]   > "_<CALC>"
"X-MON @ X-MON" "Mon" "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = integral.cp-drol.Importe
     _FldNameList[8]   > integral.cp-drol.imppgo
"cp-drol.imppgo" ? ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > integral.cp-drol.Fchpago
"cp-drol.Fchpago" "Fecha Pago" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   = integral.cp-drol.TpoMov
     _FldNameList[11]   > integral.cp-drol.CodBco
"cp-drol.CodBco" "Cod.!Bco." "x(3)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   = integral.cp-drol.Clfaux
     _FldNameList[13]   = integral.cp-drol.CodDiv
     _FldNameList[14]   = integral.cp-drol.Codcta
     _FldNameList[15]   > integral.cp-drol.Codaux
"cp-drol.Codaux" "Auxiliar" "x(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > integral.cp-drol.NomAux
"cp-drol.NomAux" ? "X(35)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   = integral.cp-drol.FlgPgo
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Asigna
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Asigna B-table-Win
ON CHOOSE OF Btn-Asigna IN FRAME F-Main /* Asignar */
DO:
  ASSIGN C-doc x-codaux F-Banco.
  IF AVAILABLE cp-brol THEN DO:
     FIND cp-crol WHERE cp-crol.Codcia = cp-brol.CodCia AND
                        cp-crol.Periodo = cp-brol.Periodo AND
                        cp-crol.NroRol = cp-brol.NroRol NO-LOCK NO-ERROR.
     IF AVAILABLE CP-CROL AND CP-CROL.FLGEST THEN DO:
        MESSAGE "Cronograma cerrado ..." VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
     END.
  END.
  ELSE DO:
     MESSAGE "Cuenta bancaria no seleccionada" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  RUN Generar-Cronograma.
  RUN cxp\d-tmppgo.r.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Delete B-table-Win
ON CHOOSE OF Btn-Delete IN FRAME F-Main /* Borrar */
DO:
  IF AVAILABLE cp-brol THEN DO:
     FIND cp-crol WHERE cp-crol.Codcia = cp-brol.CodCia AND
                        cp-crol.Periodo = cp-brol.Periodo AND
                        cp-crol.NroRol = cp-brol.NroRol NO-LOCK NO-ERROR.
     IF AVAILABLE CP-CROL AND CP-CROL.FLGEST THEN DO:
        MESSAGE "Cronograma cerrado ..." VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
     END.
  END.
  MESSAGE "Esta Seguro " VIEW-AS ALERT-BOX QUESTION
          BUTTONS YES-NO UPDATE RPTA AS LOGICAL.
  IF NOT RPTA THEN RETURN NO-APPLY.
  RUN dispatch IN THIS-PROCEDURE ('delete-record':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-doc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-doc B-table-Win
ON VALUE-CHANGED OF C-doc IN FRAME F-Main /* Cod. Doc. */
DO:
  ASSIGN c-doc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-codaux
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-codaux B-table-Win
ON LEAVE OF x-codaux IN FRAME F-Main /* Proveedor */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA AND
         gn-prov.CodPro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-prov THEN DO:
     MESSAGE "Codigo de proveedor no registrado" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


ON FIND OF cp-drol DO:
   X-MON = IF cp-drol.CodMon = 1 THEN "S/." ELSE "US$".
END.
/* ***************************  Main Block  *************************** */
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Add-Prov B-table-Win 
PROCEDURE Add-Prov :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER M-BCO    AS INTEGER.
DEFINE INPUT PARAMETER M-CTAS   AS INTEGER.
DEFINE INPUT PARAMETER S-1      AS DECIMAL.
DEFINE INPUT PARAMETER S-2      AS DECIMAL.
DEFINE INPUT PARAMETER p-tpocmb AS DECIMAL.
DEFINE INPUT PARAMETER p-tpomov AS LOGICAL.


CREATE T-DROL.
ASSIGN
  T-DROL.CodCia   = cp-brol.codcia 
  T-DROL.Periodo  = cp-brol.periodo 
  T-DROL.NroMes   = cp-brol.NroMes
  T-DROL.Nrorol   = cp-brol.nrorol 
  T-DROL.ctabco   = cp-brol.ctabco 
  T-DROL.Monbco   = M-BCO
  T-DROL.Codmon   = IF M-CTAS = 3 THEN CB-DMOV.CODMON ELSE M-CTAS  
  T-DROL.Clfaux   = cb-dmov.clfaux 
  T-DROL.Codaux   = cb-dmov.codaux
  T-DROL.Codcta   = cb-dmov.codcta
  T-DROL.CodDiv   = cb-dmov.coddiv 
  T-DROL.Coddoc   = cb-dmov.coddoc
  T-DROL.FchDoc   = cb-dmov.fchdoc
  T-DROL.FchVto   = cb-dmov.fchvto
  T-DROL.Glosa    = cb-dmov.glodoc
  T-DROL.Nrodoc   = cb-dmov.nrodoc
  T-DROL.cco      = cb-dmov.cco
  T-DROL.c-fcaja  = cb-dmov.c-fcaja
  T-DROL.nroast   = cb-dmov.nroast
  T-DROL.codope   = cb-dmov.codope  
  T-DROL.sdomn1   = ABSOLUTE(S-1)
  T-DROL.sdomn2   = ABSOLUTE(S-2)
  T-DROL.tpocmb-pgo = p-tpocmb
  T-DROL.CodBco   = cb-dmov.CodBco
  T-DROL.TpoMov   = cb-dmov.TpoMov. 
  T-DROL.Importe  = IF T-DROL.Codmon = 1 THEN T-DROL.sdomn1 ELSE T-DROL.sdomn2. 
  T-DROL.imppgo   = IF T-DROL.Codmon = 1 THEN T-DROL.sdomn1 ELSE T-DROL.sdomn2. 


IF T-DROL.clfaux = "@PV" THEN DO:
   FIND gn-prov WHERE gn-prov.codcia  = cb-codcia and
                      gn-prov.codpro  = T-DROL.codaux
                      NO-LOCK NO-ERROR.
   IF AVAILABLE gn-prov THEN T-DROL.nomaux = gn-prov.nompro.                      
END.
ELSE DO:
   FIND FIRST cb-auxi WHERE cb-auxi.codcia  = cb-codcia and
                            cb-auxi.clfaux  = T-DROL.clfaux and
                            cb-auxi.codaux  = T-DROL.codaux
                            NO-LOCK NO-ERROR.
  IF AVAILABLE cb-auxi THEN T-DROL.nomaux = cb-auxi.nomaux.                            
END.

RETURN "ok".

/*
DEFINE INPUT PARAMETER M-BCO    AS INTEGER.
DEFINE INPUT PARAMETER M-CTAS   AS INTEGER.
DEFINE INPUT PARAMETER S-1      AS DECIMAL.
DEFINE INPUT PARAMETER S-2      AS DECIMAL.
DEFINE INPUT PARAMETER p-tpocmb AS DECIMAL.
DEFINE INPUT PARAMETER p-tpomov AS LOGICAL.


CREATE B-DROL.
ASSIGN
  B-DROL.CodCia   = cp-brol.codcia 
  B-DROL.Periodo  = cp-brol.periodo 
  B-DROL.NroMes   = cp-brol.NroMes
  B-DROL.Nrorol   = cp-brol.nrorol 
  B-DROL.ctabco   = cp-brol.ctabco 
  B-DROL.Monbco   = M-BCO
  B-DROL.Codmon   = IF M-CTAS = 3 THEN CB-DMOV.CODMON ELSE M-CTAS  
  B-DROL.Clfaux   = cb-dmov.clfaux 
  B-DROL.Codaux   = cb-dmov.codaux
  B-DROL.Codcta   = cb-dmov.codcta
  B-DROL.CodDiv   = cb-dmov.coddiv 
  B-DROL.Coddoc   = cb-dmov.coddoc
  B-DROL.FchDoc   = cb-dmov.fchdoc
  B-DROL.FchVto   = cb-dmov.fchvto
  B-DROL.Glosa    = cb-dmov.glodoc
  B-DROL.Nrodoc   = cb-dmov.nrodoc
  B-DROL.cco      = cb-dmov.cco
  B-DROL.c-fcaja  = cb-dmov.c-fcaja
  B-DROL.nroast   = cb-dmov.nroast
  B-DROL.codope   = cb-dmov.codope  
  B-DROL.sdomn1   = ABSOLUTE(S-1)
  B-DROL.sdomn2   = ABSOLUTE(S-2)
  B-DROL.tpocmb-pgo = p-tpocmb
  B-DROL.CodBco   = cb-dmov.CodBco
  B-DROL.TpoMov   = cb-dmov.TpoMov. 
  B-DROL.Importe  = IF B-DROL.Codmon = 1 THEN B-DROL.sdomn1 ELSE B-DROL.sdomn2. 
  B-DROL.imppgo   = IF B-DROL.Codmon = 1 THEN B-DROL.sdomn1 ELSE B-DROL.sdomn2. 


IF B-DROL.clfaux = "@PV" THEN DO:
   FIND gn-prov WHERE gn-prov.codcia  = cb-codcia and
                      gn-prov.codpro  = B-DROL.codaux
                      NO-LOCK NO-ERROR.
   IF AVAILABLE gn-prov THEN B-DROL.nomaux = gn-prov.nompro.                      
END.
ELSE DO:
   FIND FIRST cb-auxi WHERE cb-auxi.codcia  = cb-codcia and
                            cb-auxi.clfaux  = B-DROL.clfaux and
                            cb-auxi.codaux  = B-DROL.codaux
                            NO-LOCK NO-ERROR.
  IF AVAILABLE cb-auxi THEN B-DROL.nomaux = cb-auxi.nomaux.                            
END.

RETURN "ok".
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "cp-brol"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cp-brol"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-Total B-table-Win 
PROCEDURE Calcula-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-Imp1 AS DECIMAL NO-UNDO.
DEFINE VAR x-Imp2 AS DECIMAL NO-UNDO.
x-Imp1 = 0.
x-Imp2 = 0.
FOR EACH B-DROL NO-LOCK WHERE B-drol.CodCia  = cp-brol.CodCia  AND 
                              B-drol.Periodo = cp-brol.Periodo AND 
                              B-drol.NroMes  = cp-brol.Nromes  AND
                              B-drol.Nrorol  = cp-brol.Nrorol  AND
                              B-drol.ctabco  = cp-brol.ctabco :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GENERAR-CRONOGRAMA B-table-Win 
PROCEDURE GENERAR-CRONOGRAMA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR S-1    AS DECIMAL.
DEF VAR S-2    AS DECIMAL.
DEF VAR M-CTAS AS INTEGER.
DEF VAR M-BCO  AS INTEGER.
DEF VAR pok    AS LOGICAL.
DO WITH FRAME {&FRAME-NAME} :
   ASSIGN C-doc x-codaux.
   P-DOC = C-doc.      
   IF CAPS(P-DOC) = "TODOS" THEN P-DOC = "".
END.
IF AVAILABLE cp-brol THEN DO:
   FIND cp-crol WHERE cp-crol.Codcia = cp-brol.CodCia  AND
                     cp-crol.Periodo = cp-brol.Periodo AND
                     cp-crol.NroMes  = cp-brol.NroMes  AND
                      cp-crol.NroRol = cp-brol.NroRol  NO-LOCK NO-ERROR.
   IF NOT AVAILABLE cp-crol THEN RETURN.
END.
FIND CB-CTAS WHERE CB-CTAS.CODCIA = CB-CODCIA AND
                   CB-CTAS.CODCTA = CP-BROL.CTABCO NO-LOCK NO-ERROR.
IF NOT AVAIL cb-ctas THEN DO:
   MESSAGE "Cuenta bancaria no registrada"
   VIEW-AS ALERT-BOX ERROR.
   RETURN "ERROR".
END.

M-BCO = CB-CTAS.CODMON.

IF M-BCO = 3 THEN DO:
   MESSAGE "Moneda de Cuenta bancaria mal configurada"
   VIEW-AS ALERT-BOX ERROR.
   RETURN "ERROR".
END.

FOR EACH T-DROL:
    DELETE T-DROL.
END.

LAZO_1:
FOR EACH CP-TPRO NO-LOCK WHERE CP-TPRO.CODCIA = CB-CODCIA  AND
         CP-TPRO.CODDOC BEGINS (P-DOC) AND
         CP-TPRO.CORRELATIVO
         BREAK BY CP-TPRO.CODDOC
               BY CP-TPRO.CODCTA 
               BY CP-TPRO.CODOPE:
    LAZO_4:                         
    FOR EACH CB-DMOV NO-LOCK WHERE CB-DMOV.CODCIA = cp-crol.CodCia AND
             CB-DMOV.PERIODO = cp-crol.Periodo AND
             CB-DMOV.CODOPE  = CP-TPRO.CODOPE  AND
             CB-DMOV.CODCTA  = CP-TPRO.CODCTA  AND
             CB-DMOV.CODAUX BEGINS x-codaux    AND
             CB-DMOV.CODDOC  = CP-TPRO.CODDOC  AND
             CB-DMOV.FCHVTO >= cp-crol.Fch-pgo-1 AND
             CB-DMOV.FCHVTO <= cp-crol.Fch-pgo-2 AND
             CB-DMOV.CODBCO BEGINS F-Banco AND
             CB-DMOV.TPOITM NE "N":
         FIND CB-CTAS WHERE CB-CTAS.CODCIA = CB-CODCIA AND
              CB-CTAS.CODCTA = CB-DMOV.CODCTA NO-LOCK NO-ERROR.
         M-CTAS = 1.                   
         IF AVAIL CB-CTAS THEN M-CTAS = CB-CTAS.CODMON. 
         S-1 = 0.
         S-2 = 0.                   
         pok = no.
         IF CAN-FIND(FIRST cp-drol WHERE cp-drol.codcia  = cp-crol.codcia AND
                           cp-drol.periodo = cp-crol.periodo AND
                           cp-drol.nromes  = cp-crol.nromes  AND
                           cp-drol.nrorol  = cp-crol.nrorol  AND
                           cp-drol.codaux  = cb-dmov.codaux  AND
                           cp-drol.coddoc  = cb-dmov.coddoc  AND
                           cp-drol.nrodoc  = cb-dmov.nrodoc) THEN DO:
            FIND FIRST cp-drol WHERE cp-drol.codcia  = cp-crol.codcia AND
                           cp-drol.periodo = cp-crol.periodo AND
                           cp-drol.nromes  = cp-crol.nromes  AND
                           cp-drol.nrorol  = cp-crol.nrorol  AND
                           cp-drol.codaux  = cb-dmov.codaux  AND
                           cp-drol.coddoc  = cb-dmov.coddoc  AND
                           cp-drol.nrodoc  = cb-dmov.nrodoc NO-LOCK NO-ERROR.
            MESSAGE "REPETIDO EN " SKIP
                    cp-drol.periodo SKIP
                    cp-drol.nromes SKIP
                    cp-drol.nrorol SKIP
                    cp-drol.coddoc SKIP
                    cp-drol.nrodoc SKIP
                    cp-drol.ctabco
                    VIEW-AS ALERT-BOX.
                           NEXT LAZO_4.
         END.
         FOR EACH B-DMOV WHERE
                  B-DMOV.CODCIA  = CB-DMOV.CODCIA  AND
                  B-DMOV.PERIODO = CB-DMOV.PERIODO AND
                  B-DMOV.CODCTA  = CB-DMOV.CODCTA  AND
                  B-DMOV.CODAUX  = CB-DMOV.CODAUX  AND
                  B-DMOV.CODDOC  = CB-DMOV.CODDOC  AND
                  B-DMOV.NRODOC  = CB-DMOV.NRODOC :
             IF NOT pok THEN DO:
                x-mensaje = "Procesando: " +  b-dmov.codaux +  "-" + b-dmov.coddoc + "-" + b-dmov.nrodoc.
                DISPLAY  x-mensaje WITH FRAME F-mensaje.
                PAUSE 0.
                pok = YES.                   
             END.                
             IF B-DMOV.TPOMOV THEN DO:
                S-1 = S-1 + B-DMOV.IMPMN1.
                S-2 = S-2 + B-DMOV.IMPMN2.
             END.                
             ELSE DO:
                S-1 = S-1 - B-DMOV.IMPMN1.
                S-2 = S-2 - B-DMOV.IMPMN2. 
             END.
         END.
         CASE M-CTAS :
            WHEN 1 THEN IF S-1 <> 0 THEN 
                   RUN ADD-PROV(M-BCO, M-CTAS , S-1 , S-2 , cp-crol.tpocmb, TRUE ).                    
            WHEN 2 THEN IF S-2 <> 0 THEN 
                   RUN ADD-PROV(M-BCO, M-CTAS , S-1 , S-2 , cp-crol.tpocmb, TRUE ).                 
         END CASE.
    END.                       
END.
HIDE FRAME f-mensaje.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).      

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields B-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  RUN Calcula-Total.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  DEF VAR X-LIST AS CHAR.
  X-LIST = "TODOS,".
  DO WITH FRAME {&FRAME-NAME} :
     FOR EACH CP-TPRO WHERE CP-TPRO.CODCIA = CB-CODCIA AND
                            CP-TPRO.CORRELATIVO BREAK BY CP-TPRO.CODDOC :
         IF FIRST-OF(CP-TPRO.CODDOC) THEN          
           X-LIST = X-LIST + CP-TPRO.CODDOC + ",".
     END.
     X-LIST = SUBSTRING(X-LIST , 1 , LENGTH(X-LIST) - 1).
     ASSIGN C-DOC = "TODOS"
            C-DOC:LIST-ITEMS = X-LIST.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  DEFINE VARIABLE L-SEN AS LOGICAL INIT YES NO-UNDO.
  IF AVAILABLE cp-brol THEN DO:
     FIND cp-crol WHERE cp-crol.Codcia = cp-brol.CodCia AND
                       cp-crol.Periodo = cp-brol.Periodo AND
                        cp-crol.NroRol = cp-brol.NroRol NO-LOCK NO-ERROR.
     IF AVAILABLE CP-CROL AND CP-CROL.FLGEST THEN  L-SEN = NO.
  END.
  Btn-Asigna:SENSITIVE IN FRAME {&FRAME-NAME} = L-SEN.
  Btn-Delete:SENSITIVE IN FRAME {&FRAME-NAME} = L-SEN. 
  C-doc:SENSITIVE IN FRAME {&FRAME-NAME} = L-SEN. 
  x-codaux:SENSITIVE IN FRAME {&FRAME-NAME} = L-SEN.
  cp-drol.imppgo:READ-ONLY IN BROWSE {&BROWSE-NAME} = NOT L-SEN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
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

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
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
        WHEN "" THEN.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "cp-brol"}
  {src/adm/template/snd-list.i "cp-drol"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF AVAILABLE cp-brol AND p-state = "begin-update":U THEN DO:
     FIND cp-crol WHERE cp-crol.Codcia = cp-brol.CodCia AND
                        cp-crol.Periodo = cp-brol.Periodo AND
                        cp-crol.NroRol = cp-brol.NroRol NO-LOCK NO-ERROR.
     IF AVAILABLE CP-CROL AND CP-CROL.FLGEST THEN DO:
        MESSAGE "Cronograma cerrado ..." VIEW-AS ALERT-BOX WARNING.
        RETURN ERROR.
     END.
  END.
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
      WHEN "Abrir-Query":U THEN RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  EN CASO DE ERROR RETORNAR : RETURN "ADM-ERROR"
------------------------------------------------------------------------------*/
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

