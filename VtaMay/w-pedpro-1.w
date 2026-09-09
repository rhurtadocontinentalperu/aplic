&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE CDOCU NO-UNDO LIKE INTEGRAL.CcbCDocu.
DEFINE TEMP-TABLE DDOCU NO-UNDO LIKE INTEGRAL.CcbDDocu.
DEFINE TEMP-TABLE DETA NO-UNDO LIKE INTEGRAL.FacDPedi.


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

DEF VAR x-CodMon AS CHAR NO-UNDO.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-coddoc AS CHAR INIT 'PED'.
DEF VAR cl-codcia AS INT NO-UNDO.

FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.

DEF NEW SHARED VAR input-var-1 AS CHAR.
DEF NEW SHARED VAR input-var-2 AS CHAR.
DEF NEW SHARED VAR input-var-3 AS CHAR.
DEF NEW SHARED VAR output-var-1 AS ROWID.
DEF NEW SHARED VAR output-var-2 AS CHAR.
DEF NEW SHARED VAR output-var-3 AS CHAR.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEF VAR s-TpoCmb AS DEC NO-UNDO.
  
ASSIGN
    s-TpoCmb = 1.
FIND TcmbCot WHERE  TcmbCot.Codcia = 0
    AND  (TcmbCot.Rango1 <= TODAY - TODAY + 1
    AND   TcmbCot.Rango2 >= TODAY - TODAY + 1)
        NO-LOCK NO-ERROR.
IF AVAIL TcmbCot THEN s-TPOCMB = TcmbCot.TpoCmb.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CDOCU DETA Almmmatg

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 CDOCU.FchDoc CDOCU.CodDoc ~
CDOCU.NroDoc _Moneda(CDOCU.CodMon) @ x-CodMon CDOCU.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-1
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH CDOCU NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 CDOCU
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 CDOCU


/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 DETA.codmat Almmmatg.DesMat ~
DETA.CanPed _Moneda(1) @ x-CodMon DETA.PorDto DETA.PreUni DETA.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-2
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH DETA NO-LOCK, ~
      EACH Almmmatg OF DETA NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 DETA Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 DETA


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-1 BROWSE-2 x-CodCli x-FchDoc-1 ~
x-FchDoc-2 BUTTON-1 BUTTON-7 BUTTON-3 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS x-CodCli x-FchDoc-1 x-FchDoc-2 x-NomCli 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD _Moneda W-Win 
FUNCTION _Moneda RETURNS CHARACTER
  ( INPUT pCodMon AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "adeicon\filter-u":U
     IMAGE-DOWN FILE "adeicon\filter-d":U
     IMAGE-INSENSITIVE FILE "adeicon\filter-i":U
     LABEL "Button 1" 
     SIZE 6 BY 1.35 TOOLTIP "Buscar informacion".

DEFINE BUTTON BUTTON-2 
     LABEL "GENERA PEDIDO" 
     SIZE 18 BY 1.12
     FONT 1.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "adeicon\del-au":U
     IMAGE-DOWN FILE "adeicon\del-ad":U
     IMAGE-INSENSITIVE FILE "adeicon\del-ai":U
     LABEL "Button 3" 
     SIZE 5 BY 1.12.

DEFINE BUTTON BUTTON-7 
     IMAGE-UP FILE "adeicon\exit-au":U
     LABEL "Button 7" 
     SIZE 5 BY 1.35.

DEFINE VARIABLE x-CodCli AS CHARACTER FORMAT "x(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Facturas desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-2 AS DATE FORMAT "99/99/99":U 
     LABEL "hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      CDOCU SCROLLING.

DEFINE QUERY BROWSE-2 FOR 
      DETA, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 DISPLAY
      CDOCU.FchDoc
      CDOCU.CodDoc
      CDOCU.NroDoc
      _Moneda(CDOCU.CodMon) @ x-CodMon COLUMN-LABEL "Mon" FORMAT "x(3)"
      CDOCU.ImpTot COLUMN-LABEL "Importe" FORMAT "->,>>>,>>9.99"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 48 BY 4.5
         FONT 2
         TITLE "C O M P R O B A N T E S".

DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      DETA.codmat COLUMN-LABEL "Codigo"
      Almmmatg.DesMat
      DETA.CanPed FORMAT ">,>>9.9999"
      _Moneda(1) @ x-CodMon COLUMN-LABEL "Mon" FORMAT "x(3)"
      DETA.PorDto
      DETA.PreUni COLUMN-LABEL "Unitario" FORMAT ">,>>9.99999"
      DETA.ImpLin FORMAT ">>,>>9.99"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 90 BY 5.58
         FONT 2
         TITLE "P R O M O C I O N E S".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-1 AT ROW 4.65 COL 2
     BROWSE-2 AT ROW 9.65 COL 2
     x-CodCli AT ROW 1.38 COL 14 COLON-ALIGNED
     x-FchDoc-1 AT ROW 2.35 COL 14 COLON-ALIGNED
     x-FchDoc-2 AT ROW 3.31 COL 14 COLON-ALIGNED
     x-NomCli AT ROW 1.38 COL 28 COLON-ALIGNED NO-LABEL
     BUTTON-1 AT ROW 2.35 COL 40
     BUTTON-7 AT ROW 2.35 COL 46
     BUTTON-3 AT ROW 5.62 COL 53
     BUTTON-2 AT ROW 7.92 COL 70
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 92.29 BY 17
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: CDOCU T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: DDOCU T "?" NO-UNDO INTEGRAL CcbDDocu
      TABLE: DETA T "?" NO-UNDO INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "PEDIDOS DE PROMOCIONES - TRANSFERENCIA GRATUITA"
         HEIGHT             = 14.81
         WIDTH              = 92.29
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 92.29
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 92.29
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
/* BROWSE-TAB BROWSE-1 1 F-Main */
/* BROWSE-TAB BROWSE-2 BROWSE-1 F-Main */
ASSIGN 
       BROWSE-2:NUM-LOCKED-COLUMNS IN FRAME F-Main = 2.

/* SETTINGS FOR FILL-IN x-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "Temp-Tables.CDOCU"
     _FldNameList[1]   = Temp-Tables.CDOCU.FchDoc
     _FldNameList[2]   = Temp-Tables.CDOCU.CodDoc
     _FldNameList[3]   = Temp-Tables.CDOCU.NroDoc
     _FldNameList[4]   > "_<CALC>"
"_Moneda(CDOCU.CodMon) @ x-CodMon" "Mon" "x(3)" ? ? ? ? ? ? ? no ?
     _FldNameList[5]   > Temp-Tables.CDOCU.ImpTot
"CDOCU.ImpTot" "Importe" "->,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.DETA,INTEGRAL.Almmmatg OF Temp-Tables.DETA"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.DETA.codmat
"DETA.codmat" "Codigo" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[3]   > Temp-Tables.DETA.CanPed
"DETA.CanPed" ? ">,>>9.9999" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[4]   > "_<CALC>"
"_Moneda(1) @ x-CodMon" "Mon" "x(3)" ? ? ? ? ? ? ? no ?
     _FldNameList[5]   = Temp-Tables.DETA.PorDto
     _FldNameList[6]   > Temp-Tables.DETA.PreUni
"DETA.PreUni" "Unitario" ">,>>9.99999" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[7]   > Temp-Tables.DETA.ImpLin
"DETA.ImpLin" ? ">>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _Query            is OPENED
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
ON END-ERROR OF W-Win /* PEDIDOS DE PROMOCIONES - TRANSFERENCIA GRATUITA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PEDIDOS DE PROMOCIONES - TRANSFERENCIA GRATUITA */
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
  ASSIGN
    x-CodCli x-FchDoc-1 x-FchDoc-2.
  FIND Gn-clie WHERE Gn-clie.codcia = cl-codcia
    AND Gn-clie.codcli = x-CodCli
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Gn-clie THEN DO:
    MESSAGE 'Cliente no registrado' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO x-CodCli.
    RETURN NO-APPLY.
  END.
  IF x-FchDoc-1 = ? OR x-FchDoc-2 = ? THEN DO:
    MESSAGE 'Ingrese las fechas' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO x-FchDoc-1.
    RETURN NO-APPLY.
  END.

  RUN Carga-Cotizaciones.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  RUN Carga-Promociones.
  {&OPEN-QUERY-BROWSE-2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* GENERA PEDIDO */
DO:
  FIND FIRST DETA NO-LOCK NO-ERROR.
  IF NOT AVAILABLE DETA THEN RETURN.
  RUN Genera-Pedido.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  IF NOT AVAILABLE CDOCU THEN RETURN.
  MESSAGE 'Borramos Comprobante?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta-1 AS LOG.
  IF rpta-1 = NO THEN RETURN NO-APPLY.
  DELETE CDOCU.
  {&OPEN-QUERY-BROWSE-1}
  RUN Carga-Promociones.
  {&OPEN-QUERY-BROWSE-2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 W-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* Button 7 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodCli W-Win
ON LEAVE OF x-CodCli IN FRAME F-Main /* Cliente */
DO:
  FIND Gn-clie WHERE Gn-clie.codcia = cl-codcia
    AND Gn-clie.codcli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-clie THEN x-NomCli:SCREEN-VALUE = Gn-clie.nomcli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodCli W-Win
ON LEFT-MOUSE-DBLCLICK OF x-CodCli IN FRAME F-Main /* Cliente */
OR F8 OF x-CodCli
DO:
  ASSIGN
    input-var-1 = ''
    input-var-2 = ''
    input-var-3 = ''
    output-var-1 = ?
    output-var-2 = ''
    output-var-3 = ''.
  RUN lkup/C-CLIENT-2 ('Clientes').
  IF output-var-2 <> ? THEN DO:
    SELF:SCREEN-VALUE = output-var-2.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Cotizaciones W-Win 
PROCEDURE Carga-Cotizaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH CDOCU:
    DELETE CDOCU.
  END.
  /* 26.3.07 Buscamos las facturas en todas las divisiones */
  FOR EACH Gn-divi NO-LOCK WHERE Gn-divi.codcia = s-codcia:
    FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
            AND Ccbcdocu.coddiv = Gn-divi.coddiv
            AND (Ccbcdocu.coddoc = 'FAC' OR Ccbcdocu.coddoc = 'BOL')
            AND Ccbcdocu.codcli = x-codcli
            AND Ccbcdocu.fchdoc >= x-fchdoc-1
            AND Ccbcdocu.fchdoc <= x-fchdoc-2
            AND Ccbcdocu.flgest <> 'A':
        CREATE CDOCU.
        BUFFER-COPY Ccbcdocu TO CDOCU.
    END.
  END.
  FIND FIRST CDOCU NO-LOCK NO-ERROR.
  IF AVAILABLE CDOCU
  THEN ASSIGN 
            x-CodCli:SENSITIVE IN FRAME {&FRAME-NAME} = NO
            x-FchDoc-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO
            x-FchDoc-2:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
          
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Promociones W-Win 
PROCEDURE Carga-Promociones :
/*------------------------------------------------------------------------------
  Purpose:     Acumulamos los comprobantes y calculamos las promociones
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-ImpTot AS DEC NO-UNDO.
  DEF VAR x-Factor AS INT NO-UNDO.
  DEF VAR f-PreBas AS DEC NO-UNDO.
  DEF VAR f-PreVta AS DEC NO-UNDO.
  DEF VAR f-Dsctos AS DEC NO-UNDO.
  DEF VAR y-Dsctos AS DEC NO-UNDO.
  
  FOR EACH DETA:
    DELETE DETA.
  END.
  FOR EACH DDOCU:
    DELETE DDOCU.
  END.
  /* Acumulamos los comprobantes en S/. */
  FOR EACH CDOCU NO-LOCK,
        EACH Ccbddocu OF CDOCU NO-LOCK:
    FIND DDOCU WHERE DDOCU.CodCia = Ccbddocu.codcia
        AND DDOCU.CodMat = Ccbddocu.codmat
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE DDOCU THEN CREATE DDOCU.
    ASSIGN
        DDOCU.CodCia = Ccbddocu.codcia
        DDOCU.CodMat = Ccbddocu.codmat.
    IF CDOCU.CodMon = 1
    THEN ASSIGN
            DDOCU.ImpLin = DDOCU.ImpLin + Ccbddocu.ImpLin.
    ELSE ASSIGN
            DDOCU.ImpLin = DDOCU.ImpLin + Ccbddocu.ImpLin * CDOCU.TpoCmb.
  END.
  /* barremos las promociones */
  PROMOCION:
  FOR EACH Expcprom NO-LOCK WHERE ExpCProm.CodCia = s-codcia AND ExpCProm.FlgEst = 'A':
    x-ImpTot = 0.
    FOR EACH Expdprom OF Expcprom NO-LOCK WHERE Expdprom.Tipo = 'P':
        FIND DDOCU WHERE DDOCU.codmat = Expdprom.codmat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE DDOCU THEN NEXT.
        x-ImpTot = x-ImpTot + DDOCU.ImpLin.
    END.
    IF Expcprom.codmon = 2
    THEN x-ImpTot = x-ImpTot / s-tpocmb.
    IF x-ImpTot < ExpCProm.Importe THEN NEXT PROMOCION.
    x-Factor = TRUNCATE(x-ImpTot / Expcprom.importe, 0).
    FOR EACH Expdprom OF Expcprom NO-LOCK WHERE Expdprom.Tipo = 'G', 
            FIRST Almmmatg OF Expdprom NO-LOCK:
        FIND DETA WHERE DETA.CodMat = Expdprom.codmat EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE DETA THEN CREATE DETA.
        ASSIGN
            DETA.codcia = s-codcia
            DETA.codmat = Expdprom.codmat
            DETA.canped = DETA.canped + (ExpDProm.Cantidad * x-Factor)
            DETA.undvta = Almmmatg.undbas
            DETA.factor = 1
            DETA.almdes = s-codalm.
        RUN vtamay/PrecioVenta (s-CodCia,
                        s-CodDiv,
                        x-CodCli,
                        1,
                        s-tpocmb,
                        1,
                        DETA.CodMat,
                        '900',
                        DETA.CanPed,
                        4,
                        OUTPUT f-PreBas,
                        OUTPUT f-PreVta,
                        OUTPUT f-Dsctos,
                        OUTPUT y-Dsctos).
        ASSIGN
            DETA.PorDto = f-Dsctos
            DETA.PreUni = f-PreVta
            DETA.ImpDto = ROUND( DETA.PreUni * DETA.CanPed * (DETA.Por_Dsctos[1] / 100),4 )
            DETA.ImpLin = ROUND( DETA.PreUni * DETA.CanPed , 2 ) - DETA.ImpDto.
        IF DETA.AftIsc 
        THEN DETA.ImpIsc = ROUND(DETA.PreBas * DETA.CanPed * (Almmmatg.PorIsc / 100),4).
        IF DETA.AftIgv 
        THEN DETA.ImpIgv = DETA.ImpLin - ROUND(DETA.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
    END.
  END.
    
END PROCEDURE.

/* Calculo factura por factura
  DEF VAR x-ImpTot AS DEC NO-UNDO.
  DEF VAR x-Factor AS INT NO-UNDO.
  DEF VAR f-PreBas AS DEC NO-UNDO.
  DEF VAR f-PreVta AS DEC NO-UNDO.
  DEF VAR f-Dsctos AS DEC NO-UNDO.
  DEF VAR y-Dsctos AS DEC NO-UNDO.
  
  FOR EACH DETA:
    DELETE DETA.
  END.
  /* barremos las promociones */
  FOR EACH CDOCU:
    PROMOCION:
    FOR EACH Expcprom NO-LOCK WHERE ExpCProm.CodCia = s-codcia
            AND ExpCProm.FlgEst = 'A':
        /* acumulamos por promoción */
        x-ImpTot = 0.
        FOR EACH Expdprom OF Expcprom NO-LOCK WHERE Expdprom.Tipo = 'P':
            FIND Ccbddocu OF CDOCU WHERE Ccbddocu.codmat = Expdprom.codmat
                NO-LOCK NO-ERROR.
            /*IF NOT AVAILABLE Facdpedi THEN NEXT PROMOCION.*/
            IF NOT AVAILABLE Ccbddocu THEN NEXT.
            x-ImpTot = x-ImpTot + Ccbddocu.ImpLin.
        END.
        IF CDOCU.codmon <> Expcprom.codmon
        THEN IF CDOCU.codmon = 1
            THEN x-ImpTot = x-ImpTot / CDOCU.tpocmb.
            ELSE x-ImpTot = x-Imptot * CDOCU.tpocmb.
        IF x-ImpTot < ExpCProm.Importe THEN NEXT PROMOCION.
        x-Factor = TRUNCATE(x-ImpTot / Expcprom.importe, 0).
        FOR EACH Expdprom OF Expcprom NO-LOCK WHERE Expdprom.Tipo = 'G', FIRST Almmmatg OF Expdprom NO-LOCK:
            FIND DETA WHERE DETA.CodMat = Expdprom.codmat EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE DETA THEN CREATE DETA.
            ASSIGN
                DETA.codcia = s-codcia
                DETA.codmat = Expdprom.codmat
                DETA.canped = DETA.canped + ExpDProm.Cantidad * x-Factor
                DETA.undvta = Almmmatg.undbas
                DETA.factor = 1
                DETA.almdes = s-codalm.
            RUN vtamay/PrecioVenta (s-CodCia,
                            s-CodDiv,
                            x-CodCli,
                            1,
                            CDOCU.tpocmb,
                            1,
                            DETA.CodMat,
                            '900',
                            DETA.CanPed,
                            4,
                            OUTPUT f-PreBas,
                            OUTPUT f-PreVta,
                            OUTPUT f-Dsctos,
                            OUTPUT y-Dsctos).
            ASSIGN
                DETA.PorDto = f-Dsctos
                DETA.PreUni = f-PreVta
                DETA.ImpDto = ROUND( DETA.PreUni * DETA.CanPed * (DETA.Por_Dsctos[1] / 100),4 )
                DETA.ImpLin = ROUND( DETA.PreUni * DETA.CanPed , 2 ) - DETA.ImpDto.
            IF DETA.AftIsc 
            THEN DETA.ImpIsc = ROUND(DETA.PreBas * DETA.CanPed * (Almmmatg.PorIsc / 100),4).
            IF DETA.AftIgv 
            THEN DETA.ImpIgv = DETA.ImpLin - ROUND(DETA.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
        END.
    END.
  END.

*/

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
  DISPLAY x-CodCli x-FchDoc-1 x-FchDoc-2 x-NomCli 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-1 BROWSE-2 x-CodCli x-FchDoc-1 x-FchDoc-2 BUTTON-1 BUTTON-7 
         BUTTON-3 BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pedido W-Win 
PROCEDURE Genera-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
    AND FacCorre.CodDoc = S-CODDOC 
    AND FacCorre.CodDiv = S-CODDIV 
    AND Faccorre.Codalm = S-CodAlm
    EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre THEN RETURN 'ADM-ERROR'.

  CREATE FacCPedi.
  ASSIGN 
    FacCPedi.CodCia = S-CODCIA
    FacCPedi.CodDoc = s-coddoc 
    FacCPedi.FchPed = TODAY 
    FacCPedi.FchVen = TODAY + 7
    FacCPedi.FchEnt = TODAY
    FacCPedi.CodAlm = S-CODALM
    FacCPedi.PorIgv = FacCfgGn.PorIgv 
    FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
    FacCPedi.CodDiv = S-CODDIV
    FacCPedi.TpoPed = ""
    FacCPedi.TpoCmb = s-TpoCmb
    FacCPedi.CodMon = 1.
  ASSIGN
    FacCorre.Correlativo = FacCorre.Correlativo + 1.
  RELEASE FacCorre.
  FIND Gn-clie WHERE Gn-clie.codcia = cl-codcia
    AND Gn-clie.codcli = x-CodCli NO-LOCK NO-ERROR.
  ASSIGN
    FacCPedi.CodCli = Gn-clie.CodCli
    FacCPedi.NomCli = Gn-clie.nomcli
    FacCPedi.RucCli = Gn-clie.Ruc
    FacCPedi.DirCli = Gn-clie.dircli
    FacCPedi.FmaPgo = '900'
    FacCPedi.NroCard = Gn-clie.nrocard
    FacCPedi.CodVen = '340'
    FacCPedi.Usuario = s-user-id
    FacCPedi.TipVta = (IF FacCPedi.RucCli = '' THEN '2' ELSE '1')
    FacCPedi.FlgEst = 'P'.

  FOR EACH DETA BY DETA.NroItm: 
    I-NITEM = I-NITEM + 1.
    CREATE FacDPedi.
    BUFFER-COPY DETA TO FacDPedi
        ASSIGN
            FacDPedi.CodCia = FacCPedi.CodCia
            FacDPedi.CodDiv = FacCPedi.CodDiv
            FacDPedi.coddoc = FacCPedi.coddoc
            FacDPedi.NroPed = FacCPedi.NroPed
            FacDPedi.FchPed = FacCPedi.FchPed
            FacDPedi.Hora   = FacCPedi.Hora 
            FacDPedi.FlgEst = FacCPedi.FlgEst
            FacDPedi.NroItm = I-NITEM.
    DELETE DETA.
  END.
  RUN Graba-Totales.
  RELEASE FacCPedi.    
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH CDOCU:
        DELETE CDOCU.
    END.
    {&OPEN-QUERY-BROWSE-1}
    {&OPEN-QUERY-BROWSE-2}
    ASSIGN
        x-CodCli:SENSITIVE = YES
        x-FchDoc-1:SENSITIVE = YES
        x-FchDoc-2:SENSITIVE = YES.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales W-Win 
PROCEDURE Graba-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
  DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.

  ASSIGN
    FacCPedi.ImpDto = 0
    FacCPedi.ImpIgv = 0
    FacCPedi.ImpIsc = 0
    FacCPedi.ImpTot = 0
    FacCPedi.ImpExo = 0
    FacCPedi.Importe[3] = 0.
  FOR EACH FacDPedi OF FacCPedi NO-LOCK: 
    FacCPedi.ImpDto = FacCPedi.ImpDto + FacDPedi.ImpDto.
    F-Igv = F-Igv + FacDpedi.ImpIgv.
    F-Isc = F-Isc + FacDPedi.ImpIsc.
    FacCPedi.ImpTot = FacCPedi.ImpTot + FacDPedi.ImpLin.
    IF NOT FacDPedi.AftIgv THEN FacCPedi.ImpExo = FacCPedi.ImpExo + FacDPedi.ImpLin.
  END.
  ASSIGN
    FacCPedi.ImpIgv = ROUND(F-IGV,2)
    FacCPedi.ImpIsc = ROUND(F-ISC,2)
    FacCPedi.ImpBrt = FacCPedi.ImpTot - FacCPedi.ImpIgv - FacCPedi.ImpIsc + FacCPedi.ImpDto - FacCPedi.ImpExo
    FacCPedi.ImpVta = FacCPedi.ImpBrt - FacCPedi.ImpDto.
  IF FacCPedi.PorDto > 0 THEN DO:
    ASSIGN
        FacCPedi.ImpDto = FacCPedi.ImpDto + ROUND(FacCPedi.ImpTot * FacCPedi.PorDto / 100,2)
        FacCPedi.ImpTot = ROUND(FacCPedi.ImpTot * (1 - FacCPedi.PorDto / 100),2)
        FacCPedi.ImpVta = ROUND(FacCPedi.ImpVta * (1 - FacCPedi.PorDto / 100),2)
        FacCPedi.ImpIgv = IF FacCPedi.ImpExo = 0 THEN (FacCPedi.ImpTot - FacCPedi.ImpVta) ELSE ROUND(FacCPedi.ImpVta * FacCPedi.PorIgv / 100, 2)
        FacCPedi.ImpBrt = FacCPedi.ImpTot - FacCPedi.ImpIgv - FacCPedi.ImpIsc + FacCPedi.ImpDto - FacCPedi.ImpExo.
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
    x-FchDoc-1 = DATE(01,01,YEAR(TODAY))
    x-FchDoc-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "DETA"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "CDOCU"}

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


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION _Moneda W-Win 
FUNCTION _Moneda RETURNS CHARACTER
  ( INPUT pCodMon AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE pCodMon:
    WHEN 1 THEN RETURN 'S/.'.
    WHEN 2 THEN RETURN 'US$'.
  END CASE.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


