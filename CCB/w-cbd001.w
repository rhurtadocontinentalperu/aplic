&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-DMOV LIKE INTEGRAL.cb-dmov.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR cb-codcia AS INT.

DEF VAR p-Periodo AS INT.
DEF VAR p-NroMes  AS INT.
DEF VAR s-NroMesCie AS LOGICAL INITIAL YES.

/* CONTROL DE BOTONES */
DEF VAR L-BUTTON-1 AS LOG INIT YES.

/* CONTABILIDAD */
DEF VAR x-codope LIKE cb-dmov.codope.

/* VERIFICAMOS CONFIGURACIONES */
FIND FacDocum WHERE FacDocum.codcia = s-codcia
  AND FacDocum.coddoc = 'BD' 
  NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum
THEN DO:
  MESSAGE 'La Boleta de Depósito no está configurada en el maestro de documentos'
      VIEW-AS ALERT-BOX WARNING.
  RETURN.
END.
IF FacDocum.Codope = ''
THEN DO:
  MESSAGE 'La Boleta de Depósito no tiene registrada la Operación Contable'
      VIEW-AS ALERT-BOX WARNING.
  RETURN.
END.
IF FacDocum.CodCta[1] = ''
THEN DO:
  MESSAGE 'La Boleta de Depósito no tiene registrada la Cuenta en MN'
      VIEW-AS ALERT-BOX WARNING.
  RETURN.
END.
IF FacDocum.CodCta[2] = ''
THEN DO:
  MESSAGE 'La Boleta de Depósito no tiene registrada la Cuenta en ME'
      VIEW-AS ALERT-BOX WARNING.
  RETURN.
END.
x-CodOpe = FacDocum.CodOpe.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-DMOV

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 T-DMOV.CodOpe T-DMOV.CodDiv ~
T-DMOV.CCo T-DMOV.CodCta T-DMOV.GloDoc T-DMOV.ClfAux T-DMOV.CodAux ~
T-DMOV.TpoMov T-DMOV.ImpMn1 T-DMOV.ImpMn2 T-DMOV.TpoCmb T-DMOV.FchDoc ~
T-DMOV.CodDoc T-DMOV.NroDoc T-DMOV.Periodo T-DMOV.NroMes T-DMOV.C-FCaja 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH T-DMOV NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH T-DMOV NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 T-DMOV
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 T-DMOV


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-25 FILL-IN-FchDoc COMBO-BOX-CodDiv ~
BUTTON-1 BUTTON-3 BROWSE-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-FchDoc COMBO-BOX-CodDiv ~
FILL-IN-Venta FILL-IN-Compra FILL-IN-Debe-1 FILL-IN-Debe-2 FILL-IN-Haber-1 ~
FILL-IN-Haber-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\proces":U
     LABEL "Button 1" 
     SIZE 11 BY 1.73.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\climnu1":U
     IMAGE-INSENSITIVE FILE "img\ayuda":U
     LABEL "Button 2" 
     SIZE 12 BY 1.73.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img\print1":U
     LABEL "Button 3" 
     SIZE 12 BY 1.73 TOOLTIP "Imprimir".

DEFINE VARIABLE COMBO-BOX-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Compra AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "T.C. Compra" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-Debe-1 AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "S/." 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Debe-2 AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "US$" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc AS DATE FORMAT "99/99/9999":U 
     LABEL "Dia" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Haber-1 AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "S/." 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Haber-2 AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "US$" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Venta AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "T.C. Venta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73 BY 1.15.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      T-DMOV SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 DISPLAY
      T-DMOV.CodOpe COLUMN-LABEL "Op." FORMAT "X(3)":U
      T-DMOV.CodDiv COLUMN-LABEL "Divi." FORMAT "X(5)":U
      T-DMOV.CCo COLUMN-LABEL "CCO" FORMAT "X(5)":U
      T-DMOV.CodCta COLUMN-LABEL "Cuenta" FORMAT "X(10)":U
      T-DMOV.GloDoc FORMAT "X(30)":U
      T-DMOV.ClfAux COLUMN-LABEL "Clf.!Aux." FORMAT "X(3)":U
      T-DMOV.CodAux COLUMN-LABEL "Cod.!Auxiliar" FORMAT "X(11)":U
      T-DMOV.TpoMov COLUMN-LABEL "T" FORMAT "H/D":U
      T-DMOV.ImpMn1 FORMAT "-Z,ZZZ,ZZ9.99":U
      T-DMOV.ImpMn2 FORMAT "-Z,ZZZ,ZZ9.99":U
      T-DMOV.TpoCmb FORMAT "Z9.9999":U
      T-DMOV.FchDoc FORMAT "99/99/9999":U
      T-DMOV.CodDoc FORMAT "X(4)":U
      T-DMOV.NroDoc FORMAT "X(10)":U
      T-DMOV.Periodo FORMAT "9999":U
      T-DMOV.NroMes FORMAT "99":U
      T-DMOV.C-FCaja COLUMN-LABEL "F.Caja" FORMAT "X(7)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 105 BY 9.04
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-FchDoc AT ROW 1.38 COL 9 COLON-ALIGNED
     COMBO-BOX-CodDiv AT ROW 1.38 COL 26 COLON-ALIGNED
     FILL-IN-Venta AT ROW 1.38 COL 46 COLON-ALIGNED
     FILL-IN-Compra AT ROW 1.38 COL 65 COLON-ALIGNED
     BUTTON-1 AT ROW 2.54 COL 5
     BUTTON-2 AT ROW 2.54 COL 18
     BUTTON-3 AT ROW 2.54 COL 33
     BROWSE-1 AT ROW 4.46 COL 3
     FILL-IN-Debe-1 AT ROW 13.88 COL 77 COLON-ALIGNED
     FILL-IN-Debe-2 AT ROW 13.88 COL 92 COLON-ALIGNED
     FILL-IN-Haber-1 AT ROW 14.85 COL 77 COLON-ALIGNED
     FILL-IN-Haber-2 AT ROW 14.85 COL 92 COLON-ALIGNED
     "DEBE:" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 14.08 COL 69
     "HABER:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 15.04 COL 69
     RECT-25 AT ROW 1.19 COL 5
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 108.43 BY 17
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-DMOV T "?" ? INTEGRAL cb-dmov
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ASIENTO CONTABLE BOLETAS DE DEPOSITO"
         HEIGHT             = 15.23
         WIDTH              = 108.43
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 108.43
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 108.43
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB BROWSE-1 BUTTON-3 F-Main */
/* SETTINGS FOR BUTTON BUTTON-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Compra IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Debe-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Debe-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Haber-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Haber-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Venta IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "Temp-Tables.T-DMOV"
     _FldNameList[1]   > Temp-Tables.T-DMOV.CodOpe
"T-DMOV.CodOpe" "Op." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-DMOV.CodDiv
"T-DMOV.CodDiv" "Divi." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-DMOV.CCo
"T-DMOV.CCo" "CCO" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-DMOV.CodCta
"T-DMOV.CodCta" "Cuenta" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.T-DMOV.GloDoc
     _FldNameList[6]   > Temp-Tables.T-DMOV.ClfAux
"T-DMOV.ClfAux" "Clf.!Aux." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-DMOV.CodAux
"T-DMOV.CodAux" "Cod.!Auxiliar" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-DMOV.TpoMov
"T-DMOV.TpoMov" "T" ? "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-DMOV.ImpMn1
"T-DMOV.ImpMn1" ? "-Z,ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-DMOV.ImpMn2
"T-DMOV.ImpMn2" ? "-Z,ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   = Temp-Tables.T-DMOV.TpoCmb
     _FldNameList[12]   = Temp-Tables.T-DMOV.FchDoc
     _FldNameList[13]   = Temp-Tables.T-DMOV.CodDoc
     _FldNameList[14]   = Temp-Tables.T-DMOV.NroDoc
     _FldNameList[15]   = Temp-Tables.T-DMOV.Periodo
     _FldNameList[16]   = Temp-Tables.T-DMOV.NroMes
     _FldNameList[17]   > Temp-Tables.T-DMOV.C-FCaja
"T-DMOV.C-FCaja" "F.Caja" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ASIENTO CONTABLE BOLETAS DE DEPOSITO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ASIENTO CONTABLE BOLETAS DE DEPOSITO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  IF L-BUTTON-1 = YES
  THEN DO:
    ASSIGN COMBO-BOX-CodDiv FILL-IN-Compra FILL-IN-FchDoc FILL-IN-Venta.
    /* CONSISTENCIA CIERRE CONTABLE */
    FIND cb-peri WHERE cb-peri.CodCia  = s-codcia  
      AND cb-peri.Periodo = YEAR(FILL-IN-fchdoc) NO-LOCK NO-ERROR.
    IF AVAILABLE cb-peri 
    THEN s-NroMesCie = cb-peri.MesCie[MONTH(FILL-IN-fchdoc) + 1].
    ELSE s-NroMesCie = YES.
    IF s-NroMesCie THEN DO:
       MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
  
    RUN Carga-Temporal.
    {&OPEN-QUERY-{&BROWSE-NAME}}
    RUN Totales.
    ASSIGN
        COMBO-BOX-CodDiv:SENSITIVE = NO
        FILL-IN-FchDoc:SENSITIVE = NO
        BUTTON-2:SENSITIVE = YES
        L-BUTTON-1 = NO.
    BUTTON-1:LOAD-IMAGE('img/b-cancel.bmp').
    BUTTON-2:TOOLTIP = "Trasladar a la Contabilidad".
  END.
  ELSE DO:
    ASSIGN
        COMBO-BOX-CodDiv:SENSITIVE = YES
        FILL-IN-FchDoc:SENSITIVE = YES
        BUTTON-2:SENSITIVE = NO
        L-BUTTON-1 = YES.
    BUTTON-1:LOAD-IMAGE('img/proces.bmp').
    BUTTON-2:TOOLTIP = "".
    /* BORRAMOS TEMPORAL */
    FOR EACH T-DMOV:
        DELETE T-DMOV.
    END.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  /* CONSISTENCIA CIERRE CONTABLE */
  FIND cb-peri WHERE cb-peri.CodCia  = s-codcia  
    AND cb-peri.Periodo = YEAR(FILL-IN-fchdoc) NO-LOCK NO-ERROR.
  IF AVAILABLE cb-peri 
  THEN s-NroMesCie = cb-peri.MesCie[MONTH(FILL-IN-fchdoc) + 1].
  ELSE s-NroMesCie = YES.
  IF s-NroMesCie THEN DO:
     MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  MESSAGE "Transferimos el asiento a contabilidad?" VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE RPTA-1 AS LOG.
  IF RPTA-1 = NO THEN RETURN NO-APPLY.
  RUN Asiento-Detallado.
  APPLY "CHOOSE":U TO BUTTON-1.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  RUN Pre-Impresion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchDoc W-Win
ON LEAVE OF FILL-IN-FchDoc IN FRAME F-Main /* Dia */
DO:
  ASSIGN
    {&SELF-NAME}
    p-Periodo = YEAR({&SELF-NAME})
    p-NroMes  = MONTH({&SELF-NAME}).
  IF {&SELF-NAME} = ? THEN RETURN.
  /*
  FIND gn-tcmb WHERE gn-tcmb.fecha = {&SELF-NAME} NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb 
  THEN DISPLAY
            gn-tcmb.venta @ FILL-IN-Venta
            gn-tcmb.compra @ FILL-IN-Compra
            WITH FRAME {&FRAME-NAME}.
  ELSE DO: 
    MESSAGE "No se ha registrado el tipo de cambio para la fecha ingresada"
        VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  */
  FIND LAST GN-TCCJA WHERE gn-tccja.fecha <= {&SELF-NAME} NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tccja
  THEN DISPLAY
            gn-tccja.venta  @ FILL-IN-Venta
            gn-tccja.compra @ FILL-IN-Compra
            WITH FRAME {&FRAME-NAME}.
  ELSE DO: 
    MESSAGE "No se ha registrado el tipo de cambio para la fecha ingresada"
        VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Flag W-Win 
PROCEDURE Actualiza-Flag :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH CcbBolDep WHERE ccbboldep.codcia = s-codcia
        AND ccbboldep.coddoc = 'BD' 
        AND ccbboldep.coddiv = COMBO-BOX-CodDiv
        AND ccbboldep.flgest <> 'A'
        AND ccbboldep.fchdoc = FILL-IN-FchDoc:
    ASSIGN 
        CcbBolDep.NroMes = Cb-Cmov.Nromes
        CcbBolDep.Codope = Cb-Cmov.Codope
        CcbBolDep.Nroast = Cb-Cmov.Nroast
        CcbBolDep.FchCbd = TODAY
        CcbBolDep.FlgCbd = TRUE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anula-Asto W-Win 
PROCEDURE Anula-Asto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-codcia  AS INTEGER.
DEFINE INPUT PARAMETER p-periodo AS INTEGER.
DEFINE INPUT PARAMETER p-mes     AS INTEGER.
DEFINE INPUT PARAMETER p-codope  AS CHARACTER.
DEFINE INPUT PARAMETER p-nroast  AS CHARACTER.

DEFINE BUFFER C-DMOV FOR CB-DMOV.

FOR EACH CB-DMOV WHERE
    CB-DMOV.codcia  = p-codcia AND
    CB-DMOV.periodo = p-periodo AND
    CB-DMOV.nromes  = p-mes AND
    CB-DMOV.codope  = p-codope AND
    CB-DMOV.nroast  = p-nroast:
    FOR EACH C-DMOV WHERE C-DMOV.RELACION = RECID(CB-DMOV) :
        RUN cbd/cb-acmd.p(RECID(C-DMOV),NO,YES).
        DELETE C-DMOV.
    END.
    RUN cbd/cb-acmd.p(RECID(CB-DMOV),NO,YES).
    DELETE CB-DMOV.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asiento-Detallado W-Win 
PROCEDURE Asiento-Detallado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR p-codcia  AS INTE NO-UNDO.
DEFINE VAR p-codope  AS CHAR NO-UNDO.
DEFINE VAR p-nroast  AS CHAR NO-UNDO.
DEFINE VAR x-nroast  AS INTE NO-UNDO.
DEFINE VAR p-fchast  AS DATE NO-UNDO.
DEFINE VAR d-uno     AS DECI NO-UNDO.
DEFINE VAR d-dos     AS DECI NO-UNDO.
DEFINE VAR h-uno     AS DECI NO-UNDO.
DEFINE VAR h-dos     AS DECI NO-UNDO.
DEFINE VAR x-clfaux  AS CHAR NO-UNDO.
DEFINE VAR x-genaut  AS INTE NO-UNDO.
DEFINE VAR I         AS INTE NO-UNDO.
DEFINE VAR J         AS INTE NO-UNDO.
DEFINE VAR x-coddoc  AS LOGI NO-UNDO.

DEFINE BUFFER DETALLE FOR CB-DMOV.

p-codcia  = s-codcia.

FIND FIRST T-DMOV NO-ERROR.
IF NOT AVAILABLE T-DMOV THEN DO:
   MESSAGE "No se ha generado ningun preasiento" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

/* CONFIGURACION DE CUENTAS AUTOMATICAS */
FIND cb-cfga WHERE cb-cfga.codcia = cb-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfga THEN DO:
   MESSAGE "Plan de cuentas no configurado" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

/* BORRO INFORMACION TRANSFERIDA ANTERIORMENTE */
FIND FIRST cb-control WHERE cb-control.CodCia  = s-codcia 
    AND cb-control.Coddiv  = COMBO-BOX-CodDiv
    AND (cb-control.tipo    = '@BD' OR  cb-control.tipo    = '@BDM')
    AND cb-control.fchpro  = FILL-IN-fchdoc 
    NO-LOCK NO-ERROR.
IF AVAILABLE cb-control 
THEN DO:
    MESSAGE
        "Asientos contables del mes ya existen "  SKIP
        "        ¨Desea reemplazarlos? "
        VIEW-AS ALERT-BOX WARNING
        BUTTONS YES-NO UPDATE sigue AS LOGICAL.
    IF NOT sigue THEN RETURN.
END.
FOR EACH cb-control WHERE cb-control.CodCia  = s-codcia 
        AND cb-control.Coddiv  = COMBO-BOX-CodDiv 
        AND (cb-control.tipo    = '@BD' OR cb-control.tipo    = '@BDM')
        AND cb-control.fchpro  = FILL-IN-fchdoc:
    FOR EACH cb-cmov WHERE cb-cmov.CodCia  = cb-control.codcia 
            AND cb-cmov.Periodo = cb-control.periodo 
            AND cb-cmov.NroMes  = cb-control.nromes 
            AND cb-cmov.CodOpe  = cb-control.codope 
            AND cb-cmov.NroAst  = cb-control.nroast:
        RUN anula-asto(
                cb-cmov.codcia,
                cb-cmov.periodo,
                cb-cmov.nromes,
                cb-cmov.codope,
                cb-cmov.nroast ).
        DELETE cb-cmov.    
    END.   
    DELETE cb-control.
END.
FOR EACH T-DMOV BREAK BY T-DMOV.coddiv:
    IF FIRST-OF(T-DMOV.coddiv) THEN DO:
       /* Verifico si el movimiento se realiz¢ anteriormente */
       p-codope = T-DMOV.codope.
       CREATE cb-control.
       ASSIGN
          cb-control.CodCia  = p-codcia
          cb-control.Periodo = p-periodo
          cb-control.Nromes  = p-nromes 
          cb-control.Coddiv  = T-DMOV.coddiv
          cb-control.Codope  = p-Codope
          cb-control.tipo    = '@BD'
          cb-control.fchpro  = FILL-IN-fchdoc
          cb-control.Usuario = s-user-id
          cb-control.Hora    = STRING(TIME,'HH:MM:SS')
          cb-control.fecha   = TODAY.
       /* Verifico si el movimiento se realiz¢ anteriormente */
       p-codope = T-DMOV.codope.
       RUN cbd/cbdnast (cb-codcia,
                        p-codcia, 
                        p-periodo, 
                        p-nromes, 
                        p-codope, 
                        OUTPUT x-nroast). 
        ASSIGN
            p-nroast = STRING(x-nroast, '999999')
            d-uno  = 0
            d-dos  = 0
            h-uno  = 0
            h-dos  = 0
            j      = 0.
    END.
    /* DETALLE */
    FIND cb-ctas WHERE
        cb-ctas.codcia = cb-codcia AND
        cb-ctas.codcta = T-DMOV.codcta NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN NEXT.
    ASSIGN
        x-clfaux = IF T-DMOV.clfaux = '' THEN cb-ctas.clfaux ELSE T-DMOV.clfaux
        x-coddoc = cb-ctas.piddoc.
    J = J + 1.
    CREATE CB-DMOV.
    ASSIGN
        CB-CONTROL.nroast = p-nroast    /* <<< OJO <<< */
        CB-DMOV.codcia  = p-codcia
        CB-DMOV.PERIODO = p-periodo
        CB-DMOV.NROMES  = p-nromes
        CB-DMOV.CODOPE  = p-codope
        CB-DMOV.NROAST  = p-nroast
        CB-DMOV.NROITM  = J
        CB-DMOV.codcta  = T-DMOV.codcta
        CB-DMOV.coddiv  = T-DMOV.coddiv
        CB-DMOV.cco     = T-DMOV.cco
        CB-DMOV.Coddoc  = IF x-coddoc THEN T-DMOV.coddoc ELSE ''
        CB-DMOV.Nrodoc  = IF x-coddoc THEN T-DMOV.nrodoc ELSE ''
        CB-DMOV.clfaux  = IF x-clfaux <> '' THEN x-clfaux ELSE ''
        CB-DMOV.codaux  = IF x-clfaux <> '' THEN T-DMOV.codaux ELSE ''
        CB-DMOV.Nroruc  = IF x-clfaux <> '' THEN T-DMOV.nroruc ELSE ''
        CB-DMOV.GLODOC  = T-DMOV.glodoc
        CB-DMOV.tpomov  = T-DMOV.tpomov
        CB-DMOV.impmn1  = T-DMOV.impmn1
        CB-DMOV.impmn2  = T-DMOV.impmn2
        CB-DMOV.FCHDOC  = T-DMOV.Fchdoc
        CB-DMOV.FCHVTO  = T-DMOV.Fchvto
        CB-DMOV.FLGACT  = TRUE
        CB-DMOV.RELACION = 0
        CB-DMOV.TM      = T-DMOV.tm
        CB-DMOV.codmon  = T-DMOV.codmon
        CB-DMOV.tpocmb  = T-DMOV.tpocmb
/*ML01* Guarda Referencia de Boleta de Depósito */
/*ML01*/ CB-DMOV.NroRef = T-DMOV.NroRef
        CB-DMOV.c-fcaja  = T-DMOV.c-fcaja.
    RUN cbd/cb-acmd (RECID(CB-DMOV),YES,YES).
    IF CB-DMOV.tpomov THEN DO:
        h-uno = h-uno + CB-DMOV.impmn1.
        h-dos = h-dos + CB-DMOV.impmn2.
    END.
    ELSE DO:
        d-uno = d-uno + CB-DMOV.impmn1.
        d-dos = d-dos + CB-DMOV.impmn2.
    END.
    /* GENERACION DE CUENTA AUTOMATICAS */        
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
    ASSIGN
        cb-dmov.CtaAut = ""
        cb-dmov.CtrCta = "".
    CASE x-GenAut:
        /* Genera Cuentas Clase 9 */
        WHEN 1 THEN DO:
            cb-dmov.CtrCta = cb-ctas.Cc1Cta.
            cb-dmov.CtaAut = cb-ctas.An1Cta.
            IF cb-dmov.CtrCta = "" THEN cb-dmov.CtrCta = cb-cfga.Cc1Cta9.
        END.
        /* Genera Cuentas Clase 6 */
        WHEN 2 THEN DO:
            cb-dmov.CtrCta = cb-ctas.Cc1Cta.
            cb-dmov.CtaAut = cb-ctas.An1Cta.
            IF cb-dmov.CtrCta = "" THEN
                cb-dmov.CtrCta = cb-cfga.Cc1Cta6.
        END.
        WHEN 3 THEN DO:
            cb-dmov.CtaAut = cb-ctas.An1Cta.
            cb-dmov.CtrCta = cb-ctas.Cc1Cta.
        END.
    END CASE.
    /* Chequendo las cuentas a generar en forma autom tica */
    IF x-GenAut > 0 THEN DO:
        IF NOT CAN-FIND(FIRST cb-ctas WHERE
            cb-ctas.CodCia = cb-codcia AND
            cb-ctas.CodCta = cb-dmov.CtaAut) THEN DO:
            MESSAGE
                "Cuentas Autom ticas a generar" SKIP
                "Tienen mal registro, Cuenta" cb-dmov.CtaAut "no existe"
                VIEW-AS ALERT-BOX ERROR.
            cb-dmov.CtaAut = "".
        END.
        IF NOT CAN-FIND( cb-ctas WHERE
            cb-ctas.CodCia = cb-codcia AND
            cb-ctas.CodCta = cb-dmov.CtrCta ) THEN DO:
            MESSAGE
                "Cuentas Autom ticas a generar" SKIP
                "Tienen mal registro, Contra Cuenta" cb-dmov.CtrCta "no existe"
                VIEW-AS ALERT-BOX ERROR.
            cb-dmov.CtrCta = "".
        END.
    END. /*Fin del x-genaut > 0 */
    
    IF cb-dmov.CtaAut <> "" AND cb-dmov.CtrCta <> "" THEN DO:
        J = J + 1.
        CREATE DETALLE.
        BUFFER-COPY CB-DMOV TO DETALLE
            ASSIGN DETALLE.TpoItm = 'A'
                    DETALLE.Relacion = RECID(CB-DMOV)
                    DETALLE.CodCta = CB-DMOV.CtaAut
                    DETALLE.CodAux = CB-DMOV.CodCta.
        RUN cbd/cb-acmd (RECID(DETALLE), YES ,YES).
        IF detalle.tpomov THEN DO:
            h-uno = h-uno + detalle.impmn1.
            h-dos = h-dos + detalle.impmn2.
        END.
        ELSE DO:
            d-uno = d-uno + CB-DMOV.impmn1.
            d-dos = d-dos + CB-DMOV.impmn2.
        END.
        J = J + 1.
        CREATE detalle.
        BUFFER-COPY CB-DMOV TO DETALLE
            ASSIGN DETALLE.TpoItm = 'A'
                    DETALLE.Relacion = RECID(CB-DMOV)
                    DETALLE.CodCta = CB-DMOV.CtrCta
                    DETALLE.CodAux = CB-DMOV.CodCta
                    DETALLE.TpoMov = NOT CB-DMOV.TpoMov.
        RUN cbd/cb-acmd (RECID(DETALLE), YES ,YES).
        IF detalle.tpomov THEN DO:
            h-uno = h-uno + detalle.impmn1.
            h-dos = h-dos + detalle.impmn2.
        END.
        ELSE DO:
            d-uno = d-uno + CB-DMOV.impmn1.
            d-dos = d-dos + CB-DMOV.impmn2.
        END.
    END.
    IF LAST-OF(T-DMOV.coddiv) THEN DO:
        FIND cb-cmov WHERE
           cb-cmov.codcia  = p-codcia AND
           cb-cmov.PERIODO = p-periodo AND
           cb-cmov.NROMES  = p-nromes AND
           cb-cmov.CODOPE  = p-codope AND
           cb-cmov.NROAST  = p-nroast NO-ERROR.
        IF NOT AVAILABLE cb-cmov THEN DO:
            CREATE cb-cmov.
            ASSIGN
                cb-cmov.codcia  = p-codcia
                cb-cmov.PERIODO = p-periodo
                cb-cmov.NROMES  = p-nromes
                cb-cmov.CODOPE  = p-codope
                cb-cmov.NROAST  = p-nroast. 
        END.
        ASSIGN
            cb-cmov.Coddiv = T-DMOV.coddiv
            cb-cmov.Fchast = FILL-IN-fchdoc
            cb-cmov.TOTITM = J
            cb-cmov.CODMON = T-DMOV.codmon
            cb-cmov.TPOCMB = T-DMOV.tpocmb
            cb-cmov.DBEMN1 = d-uno
            cb-cmov.DBEMN2 = d-dos
            cb-cmov.HBEMN1 = h-uno
            cb-cmov.HBEMN2 = h-dos
            cb-cmov.NOTAST = 'Boletas de Deposito del ' + STRING(FILL-IN-fchdoc)
            cb-cmov.GLOAST = 'Boletas de Deposito del ' + STRING(FILL-IN-fchdoc).
    END.
END.
RUN Actualiza-Flag.
MESSAGE ' Proceso Concluido ' VIEW-AS ALERT-BOX INFORMATION.
/* BORRAMOS TEMPORAL */
FOR EACH T-DMOV:
    DELETE T-DMOV.
END.
{&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH T-DMOV:
    DELETE T-DMOV.
  END.
  
  DEF VAR x-codcta LIKE cb-dmov.codcta.

  /* GENERAMOS ASIENTO */
  FOR EACH CcbBolDep NO-LOCK WHERE ccbboldep.codcia = s-codcia
        AND ccbboldep.coddoc = 'BD' 
        AND ccbboldep.coddiv = COMBO-BOX-CodDiv
        AND ccbboldep.flgest <> 'A'
        AND ccbboldep.fchdoc = FILL-IN-FchDoc:
    /* CUENTA AL DEBE */
    RUN Graba-Detalle (x-codope,
                        COMBO-BOX-CodDiv,
                        FacDocum.CodCbd,
                        CcbBolDep.CodCta,
                        00,
                        CcbBolDep.CodMon,
                        FILL-IN-Compra,
                        '',
                        '@CL',
                        CcbBolDep.CodCli,
                        NO,     /* Debe */
                        CcbBolDep.ImpTot,
                        CcbBolDep.FchReg,
                        CcbBolDep.NroDoc,
                        '10',
/*ML01*/                CcbBolDep.NroRef,
                        CcbBolDep.NomCli).
    /* CUENTA AL HABER */
    x-codcta = IF ccbboldep.codmon = 1 THEN FacDocum.CodCta[1] ELSE FacDocum.CodCta[2].
    RUN Graba-Detalle (x-codope,
                        COMBO-BOX-CodDiv,
                        '',
                        x-CodCta,
                        00,
                        CcbBolDep.CodMon,
                        FILL-IN-Compra,
                        '',
                        '@CL',
                        CcbBolDep.CodCli,
                        YES,     /* Debe */
                        CcbBolDep.ImpTot,
                        CcbBolDep.FchReg,
                        CcbBolDep.NroDoc,
                        '12',
/*ML01*/                CcbBolDep.NroRef,
                        CcbBolDep.NomCli).
  END.
          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-FchDoc COMBO-BOX-CodDiv FILL-IN-Venta FILL-IN-Compra 
          FILL-IN-Debe-1 FILL-IN-Debe-2 FILL-IN-Haber-1 FILL-IN-Haber-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-25 FILL-IN-FchDoc COMBO-BOX-CodDiv BUTTON-1 BUTTON-3 BROWSE-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Detalle W-Win 
PROCEDURE Graba-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER x-codope  AS CHAR.
DEFINE INPUT PARAMETER x-coddiv  AS CHAR.
DEFINE INPUT PARAMETER x-codcbd  AS CHAR.
DEFINE INPUT PARAMETER x-codcta  AS CHAR.
DEFINE INPUT PARAMETER x-tm      AS INTEGER.
DEFINE INPUT PARAMETER x-codmon  AS INTEGER.
DEFINE INPUT PARAMETER x-tpocmb  AS DECIMAL.
DEFINE INPUT PARAMETER x-cco     AS CHAR.
DEFINE INPUT PARAMETER x-clfaux  AS CHAR.
DEFINE INPUT PARAMETER x-codaux  AS CHAR.
DEFINE INPUT PARAMETER x-tpomov  AS LOGICAL.
DEFINE INPUT PARAMETER x-importe AS DECIMAL.
DEFINE INPUT PARAMETER x-fchdoc  AS DATE.
DEFINE INPUT PARAMETER x-nrodoc  AS CHAR.
DEFINE INPUT PARAMETER x-nroref  AS CHAR.
DEFINE INPUT PARAMETER x-c-fcaja AS CHAR.
DEFINE INPUT PARAMETER x-glodoc  AS CHAR.

DEFINE VAR x-nroruc AS CHAR.

IF x-tm = 0 THEN x-tm = 01.
 
FIND GN-CLIE WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = x-codaux
    NO-LOCK NO-ERROR.
IF AVAILABLE GN-CLIE
THEN x-NroRuc = gn-clie.Ruc.

FIND CB-CTAS WHERE CB-CTAS.codcia = cb-codcia
    AND CB-CTAS.codcta = x-codcta
    NO-LOCK NO-ERROR.
IF AVAILABLE CB-CTAS 
THEN ASSIGN
        x-Cco    = IF CB-CTAS.PidCco THEN x-Cco    ELSE ''
        x-CodAux = IF CB-CTAS.PidAux THEN x-CodAux ELSE ''
        x-ClfAux = IF CB-CTAS.PidAux THEN x-ClfAux ELSE ''
        x-NroRuc = IF CB-CTAS.PidAux THEN x-NroRuc ELSE ''
        x-CodCbd = IF x-CodCbd = '' THEN cb-ctas.Coddoc ELSE x-CodCbd.
CREATE t-dmov.
ASSIGN
    t-dmov.codcia  = s-codcia
    t-dmov.periodo = p-periodo
    t-dmov.nromes  = p-nromes
    t-dmov.codope  = x-codope
    t-dmov.coddiv  = x-coddiv
    t-dmov.codcta  = x-codcta
    t-dmov.fchdoc  = x-fchdoc 
    t-dmov.fchvto  = x-fchdoc
    t-dmov.clfaux  = x-clfaux
    t-dmov.codaux  = x-codaux
    t-dmov.tpomov  = x-tpomov
    t-dmov.nroruc  = x-nroruc
    t-dmov.codmon  = x-codmon
    t-dmov.tpocmb  = x-tpocmb
    t-dmov.coddoc  = x-codcbd
    t-dmov.nrodoc  = x-nrodoc
/*ML01*/ t-dmov.nroref = x-nroref
    t-dmov.tm      = x-tm
    t-dmov.cco     = x-cco
    t-dmov.c-fcaja = x-c-fcaja
    t-dmov.glodoc   = x-glodoc.
IF t-dmov.CodMon = 1 
THEN ASSIGN
        t-dmov.impmn1  = x-importe
        t-dmov.tpocmb  = 0.
ELSE ASSIGN
        t-dmov.impmn2  = x-importe
        t-dmov.impmn1  = ROUND(( x-importe * x-Tpocmb ) ,2).  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR I-nroitm AS INTEGER NO-UNDO.
DEFINE VAR x-debe   AS DECIMAL NO-UNDO.
DEFINE VAR x-haber  AS DECIMAL NO-UNDO.

DEFINE FRAME F-Header
    HEADER
    S-NOMCIA FORMAT "X(45)" 
    "Fecha  : " AT 110 TODAY SKIP(1)
    "BOLETAS DE DEPOSITO" AT 20 SKIP(1)
    "Operacion      : " x-codope SKIP
    "Fecha          : " FILL-IN-fchdoc SPACE(10) "Tipo de cambio : " AT 65 FILL-IN-Venta SKIP(1)
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200. 
  
DEFINE FRAME F-Detalle
    I-NroItm        COLUMN-LABEL "Item" FORMAT ">>9"        
    T-DMOV.coddiv   COLUMN-LABEL "Division"
    T-DMOV.codcta   COLUMN-LABEL "Cuenta"
    T-DMOV.cco      COLUMN-LABEL "Cco"
    T-DMOV.clfaux   COLUMN-LABEL "Clf"
    T-DMOV.codaux   COLUMN-LABEL "Auxiliar"
    T-DMOV.coddoc   COLUMN-LABEL "Doc"
    T-DMOV.nrodoc   COLUMN-LABEL "Numero"
    T-DMOV.glodoc   COLUMN-LABEL " Concepto"
    T-DMOV.tpomov   COLUMN-LABEL "T"
    x-debe          COLUMN-LABEL "Debe" FORMAT ">>>>,>>>,>>9.99" 
    x-haber         COLUMN-LABEL "Haber" FORMAT ">>>>,>>>,>>9.99" 
    WITH NO-BOX WIDTH 200 STREAM-IO DOWN. 

I-NroItm = 0.
FOR EACH T-DMOV BREAK BY T-DMOV.coddiv:
    VIEW FRAME F-Header.
    IF FIRST-OF(T-DMOV.coddiv) THEN  I-Nroitm = 0.
    I-Nroitm = I-Nroitm + 1.
    x-debe   = 0.
    x-haber  = 0.
    IF T-DMOV.tpomov THEN x-haber = T-DMOV.impmn1.
    ELSE x-debe = T-DMOV.impmn1.
    ACCUMULATE x-debe (TOTAL BY T-DMOV.coddiv).
    ACCUMULATE x-haber (TOTAL BY T-DMOV.coddiv).
    DISPLAY 
        I-NroItm       AT 1   FORMAT ">>9" 
        T-DMOV.coddiv  
        T-DMOV.codcta  
        T-DMOV.cco
        T-DMOV.clfaux  
        T-DMOV.codaux
        T-DMOV.coddoc
        T-DMOV.nrodoc
        T-DMOV.glodoc
        T-DMOV.tpomov
        x-debe  WHEN x-debe <> 0
        x-haber WHEN x-haber <> 0
        WITH FRAME F-Detalle.
    IF LAST-OF(T-DMOV.coddiv) THEN DO:
        UNDERLINE 
            x-debe
            x-haber
            WITH FRAME F-Detalle.
        DISPLAY 
            "        TOTAL "    @ T-DMOV.glodoc
            ACCUM TOTAL BY T-DMOV.coddiv x-debe  @ x-debe
            ACCUM TOTAL BY T-DMOV.coddiv x-haber @ x-haber
            WITH FRAME F-Detalle.
        PAGE.
    END.
END.    

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
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN
    FILL-IN-FchDoc = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH GN-DIVI WHERE GN-DIVI.codcia = s-codcia NO-LOCK:
        COMBO-BOX-CodDiv:ADD-LAST(GN-DIVI.coddiv).
    END.
    COMBO-BOX-CodDiv:SCREEN-VALUE = s-CodDiv.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pre-Impresion W-Win 
PROCEDURE Pre-Impresion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.   

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT CONTROL {&PRN0} {&PRN5A} CHR(66) {&PRN3}.
        RUN Imprimir.
        PAGE .
        OUTPUT CLOSE.
    END.
    OUTPUT CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "T-DMOV"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Totales W-Win 
PROCEDURE Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ASSIGN
    FILL-IN-Debe-1 = 0
    FILL-IN-Debe-2 = 0
    FILL-IN-Haber-1 = 0
    FILL-IN-Haber-2 = 0.
  
  FOR EACH T-DMOV:
    IF T-DMOV.tpomov = NO
    THEN ASSIGN
            FILL-IN-Debe-1 = FILL-IN-Debe-1 + T-DMOV.ImpMn1
            FILL-IN-Debe-2 = FILL-IN-Debe-2 + T-DMOV.ImpMn2.
    ELSE ASSIGN
            FILL-IN-Haber-1 = FILL-IN-Haber-1 + T-DMOV.ImpMn1
            FILL-IN-Haber-2 = FILL-IN-Haber-2 + T-DMOV.ImpMn2.
  END.
  DISPLAY
    FILL-IN-Debe-1 FILL-IN-Debe-2 FILL-IN-Haber-1 FILL-IN-Haber-2
    WITH FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

