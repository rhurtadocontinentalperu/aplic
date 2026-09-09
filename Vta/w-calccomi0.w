&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE DETALLE NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE t-cdoc NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE t-dcaja NO-UNDO LIKE CcbDCaja.
DEFINE TEMP-TABLE t-dcomi NO-UNDO LIKE FacDComi.
DEFINE TEMP-TABLE t-ddoc NO-UNDO LIKE CcbDDocu
       INDEX LLave01 CodCia CodDoc NroDoc CodMat.



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
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR x-NroMes AS INT NO-UNDO.

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
&Scoped-define INTERNAL-TABLES t-dcomi

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 t-dcomi.CodDoc t-dcomi.NroDoc ~
t-dcomi.CodVen t-dcomi.CodRef t-dcomi.NroRef t-dcomi.ImpTot t-dcomi.ImpCom 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH t-dcomi NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH t-dcomi NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 t-dcomi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 t-dcomi


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-Periodo B-CALCULA-COMISION x-Mes ~
B-NUEVO-CALCULO BUTTON-EXCEL BROWSE-1 
&Scoped-Define DISPLAYED-OBJECTS x-Periodo x-Mes x-FchIni x-FchFin x-CodMon ~
x-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-CALCULA-COMISION 
     LABEL "CALCULA COMISIONES" 
     SIZE 19 BY 1.12.

DEFINE BUTTON B-GRABA-COMISION 
     LABEL "GRABAR COMISIONES" 
     SIZE 19 BY 1.12.

DEFINE BUTTON B-NUEVO-CALCULO 
     LABEL "NUEVO CALCULO" 
     SIZE 19 BY 1.12.

DEFINE BUTTON BUTTON-EXCEL 
     LABEL "GENERAR HOJA EXCEL" 
     SIZE 19 BY 1.12.

DEFINE VARIABLE x-Mes AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione Mes" 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre","Seleccione Mes" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE x-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE x-FchFin AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchIni AS DATE FORMAT "99/99/99":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2
     SIZE 12 BY 1.73 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      t-dcomi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 DISPLAY
      t-dcomi.CodDoc COLUMN-LABEL "Doc" FORMAT "x(3)":U
      t-dcomi.NroDoc FORMAT "X(9)":U
      t-dcomi.CodVen FORMAT "x(10)":U
      t-dcomi.CodRef COLUMN-LABEL "Ref" FORMAT "x(3)":U
      t-dcomi.NroRef FORMAT "X(12)":U
      t-dcomi.ImpTot FORMAT "->>,>>>,>>9.99":U
      t-dcomi.ImpCom FORMAT "->>>,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 76 BY 8.46
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-Periodo AT ROW 1.19 COL 23 COLON-ALIGNED
     B-CALCULA-COMISION AT ROW 1.19 COL 58
     x-Mes AT ROW 2.15 COL 23 COLON-ALIGNED
     B-GRABA-COMISION AT ROW 2.35 COL 58
     x-FchIni AT ROW 3.12 COL 23 COLON-ALIGNED
     x-FchFin AT ROW 3.12 COL 39 COLON-ALIGNED
     B-NUEVO-CALCULO AT ROW 3.5 COL 58
     x-CodMon AT ROW 4.08 COL 25 NO-LABEL
     BUTTON-EXCEL AT ROW 4.65 COL 58
     BROWSE-1 AT ROW 6 COL 3
     x-Mensaje AT ROW 14.65 COL 17 COLON-ALIGNED NO-LABEL
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 4.27 COL 17
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: DETALLE T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: t-cdoc T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: t-dcaja T "?" NO-UNDO INTEGRAL CcbDCaja
      TABLE: t-dcomi T "?" NO-UNDO INTEGRAL FacDComi
      TABLE: t-ddoc T "?" NO-UNDO INTEGRAL CcbDDocu
      ADDITIONAL-FIELDS:
          INDEX LLave01 CodCia CodDoc NroDoc CodMat
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CALCULO DE COMISIONES A VENDEDORES"
         HEIGHT             = 14.81
         WIDTH              = 80
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
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

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-1 BUTTON-EXCEL F-Main */
/* SETTINGS FOR BUTTON B-GRABA-COMISION IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET x-CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-FchFin IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-FchIni IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "Temp-Tables.t-dcomi"
     _FldNameList[1]   > Temp-Tables.t-dcomi.CodDoc
"t-dcomi.CodDoc" "Doc" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.t-dcomi.NroDoc
     _FldNameList[3]   = Temp-Tables.t-dcomi.CodVen
     _FldNameList[4]   > Temp-Tables.t-dcomi.CodRef
"t-dcomi.CodRef" "Ref" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-dcomi.NroRef
"t-dcomi.NroRef" ? "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = Temp-Tables.t-dcomi.ImpTot
     _FldNameList[7]   = Temp-Tables.t-dcomi.ImpCom
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CALCULO DE COMISIONES A VENDEDORES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CALCULO DE COMISIONES A VENDEDORES */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-CALCULA-COMISION
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-CALCULA-COMISION W-Win
ON CHOOSE OF B-CALCULA-COMISION IN FRAME F-Main /* CALCULA COMISIONES */
DO:
  IF x-Mes = 'Seleccione Mes' THEN RETURN NO-APPLY.
  RUN Carga-Temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-GRABA-COMISION
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-GRABA-COMISION W-Win
ON CHOOSE OF B-GRABA-COMISION IN FRAME F-Main /* GRABAR COMISIONES */
DO:
  RUN Grabar-Comisiones.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-NUEVO-CALCULO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-NUEVO-CALCULO W-Win
ON CHOOSE OF B-NUEVO-CALCULO IN FRAME F-Main /* NUEVO CALCULO */
DO:
  RUN Resetea-Variables.
  ASSIGN
    x-Mes:SENSITIVE IN FRAME {&FRAME-NAME} = YES
    x-Periodo:SENSITIVE IN FRAME {&FRAME-NAME} = YES
    B-CALCULA-COMISION:SENSITIVE IN FRAME {&FRAME-NAME} = YES
    B-GRABA-COMISION:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-EXCEL
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-EXCEL W-Win
ON CHOOSE OF BUTTON-EXCEL IN FRAME F-Main /* GENERAR HOJA EXCEL */
DO:
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Excel.
  SESSION:SET-WAIT-STATE('').
  MESSAGE 'Proceso Teminado' VIEW-AS ALERT-BOX.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Mes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Mes W-Win
ON VALUE-CHANGED OF x-Mes IN FRAME F-Main /* Mes */
DO:
    RUN Carga-Comision-Anterior.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        SELF:SCREEN-VALUE = x-Mes.
        RETURN NO-APPLY.
    END.

    ASSIGN
        x-Mes.
    x-NroMes = LOOKUP(x-Mes, x-Mes:LIST-ITEMS).
    IF x-NroMes = 12
    THEN x-FchIni = DATE(12,26,x-Periodo - 1).
    ELSE x-FchIni = DATE(x-NroMes - 1,26,x-Periodo).
    x-FchFin = DATE(x-NroMes,25,x-Periodo).
    DISPLAY x-FchIni x-FchFin WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Periodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Periodo W-Win
ON VALUE-CHANGED OF x-Periodo IN FRAME F-Main /* Periodo */
DO:
    RUN Carga-Comision-Anterior.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        SELF:SCREEN-VALUE = STRING(x-Periodo).
        RETURN NO-APPLY.
    END.

    ASSIGN
        x-Periodo.
    IF x-NroMes >= 1 AND x-NroMes <= 12
    THEN DO:
        IF x-NroMes = 12
        THEN x-FchIni = DATE(12,26,x-Periodo - 1).
        ELSE x-FchIni = DATE(x-NroMes - 1,26,x-Periodo).
        x-FchFin = DATE(x-NroMes,25,x-Periodo).
    END.
    DISPLAY x-FchIni x-FchFin WITH FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Comision-Anterior W-Win 
PROCEDURE Carga-Comision-Anterior :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR l-NroMes AS INT NO-UNDO.
  DEF VAR l-Periodo AS INT NO-UNDO.

  l-NroMes = LOOKUP(x-Mes:SCREEN-VALUE IN FRAME {&FRAME-NAME}, x-Mes:LIST-ITEMS).
  l-Periodo = INTEGER(x-Periodo:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

  FIND Facccomi WHERE FacCComi.CodCia = s-codcia
    AND FacCComi.NroMes = l-NroMes
    AND FacCComi.Periodo = l-Periodo
    NO-LOCK NO-ERROR.
  IF AVAILABLE FacCComi THEN DO:
    MESSAGE 'YA EXISTE un pago de comisión en esta fecha' SKIP
        '¿Desea continuar?' VIEW-AS ALERT-BOX WARNING 
        BUTTONS YES-NO UPDATE rpta AS LOGICAL.
    IF rpta = NO THEN RETURN 'ADM-ERROR'.
    FOR EACH t-dcomi:
        DELETE t-dcomi.
    END.
    FOR EACH Facdcomi OF Facccomi NO-LOCK:
        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'CARGANDO COMISION ANTERIOR: ' + 
            facdcomi.coddoc + ' ' + facdcomi.nrodoc.
        CREATE t-dcomi.
        BUFFER-COPY Facdcomi TO t-dcomi.
    END.
    {&OPEN-QUERY-{&BROWSE-NAME}}
    x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
  END.

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
  DEF VAR x-Signo AS INT NO-UNDO.

  FOR EACH DETALLE:
    DELETE DETALLE.
  END.
  FOR EACH t-dcaja:
    DELETE t-dcaja.
  END.
  FOR EACH t-cdoc:
    DELETE t-cdoc.
  END.
  FOR EACH t-ddoc:
    DELETE t-ddoc.
  END.
  FIND FIRST t-dcomi NO-LOCK NO-ERROR.
  IF AVAILABLE t-dcomi THEN DO:
    MESSAGE 'Volvemos a recalcular la comision?' 
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN 'ADM-ERROR'.
    FOR EACH t-dcomi:
        DELETE t-dcomi.
    END.
  END.
  
  ASSIGN
    x-Mes:SENSITIVE IN FRAME {&FRAME-NAME} = NO
    x-Periodo:SENSITIVE IN FRAME {&FRAME-NAME} = NO
    B-CALCULA-COMISION:SENSITIVE IN FRAME {&FRAME-NAME} = NO
    B-GRABA-COMISION:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

  x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'INICIANDO PROCESO. Un momento por favor...'.

  /* BUSCAMOS LOS DOCUMENTOS CANCELADOS */
  FOR EACH Ccbdcaja NO-LOCK WHERE Ccbdcaja.codcia = s-codcia
        AND Ccbdcaja.fchdoc >= x-fchini
        AND Ccbdcaja.fchdoc <= x-fchfin,
        FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Ccbdcaja.codcia
            AND Ccbcdocu.coddoc = Ccbdcaja.codref
            AND Ccbcdocu.nrodoc = Ccbdcaja.nroref:
    
    /* FILTROS */
    IF LOOKUP(TRIM(Ccbdcaja.codref), 'FAC,BOL,TCK,LET') = 0 THEN NEXT.
    IF Ccbdcaja.coddoc = 'CJE' THEN NEXT.       /* NO FAC canjeadas por letras */
    IF Ccbdcaja.coddoc = 'CLA' THEN NEXT.       /* NO FAC canjeadas por letras */
    /* ******* */
    x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'CARGANDO CANCELACIONES: ' + Ccbdcaja.coddoc + ' ' +
        Ccbdcaja.nrodoc + ' ' + STRING(Ccbdcaja.fchdoc).
    FIND DETALLE OF Ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE DETALLE THEN CREATE DETALLE.
    BUFFER-COPY Ccbcdocu TO DETALLE
        ASSIGN
            DETALLE.SdoAct = Ccbcdocu.ImpTot.       /* INICIALIZAMOS EL SALDO DEL DOCUMENTO */
  END.

  /* VEAMOS SI REALMENTE ESTAN CANCELADOS EN EL PERIODO */
  FOR EACH DETALLE:
    x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'VERIFICANDO DOCUMENTOS: ' + DETALLE.coddoc + ' ' +
        DETALLE.nrodoc + ' ' + STRING(DETALLE.fchdoc).
    FOR EACH Ccbdcaja NO-LOCK WHERE Ccbdcaja.codcia = s-codcia
            AND Ccbdcaja.codref = DETALLE.coddoc
            AND Ccbdcaja.nroref = DETALLE.nrodoc
            AND Ccbdcaja.fchdoc <= x-fchfin:
        CREATE t-dcaja.
        BUFFER-COPY Ccbdcaja TO t-dcaja.
        IF DETALLE.codmon = t-dcaja.codmon
        THEN DETALLE.SdoAct = DETALLE.SdoAct - t-dcaja.ImpTot.
        ELSE IF DETALLE.codmon = 1
                THEN DETALLE.SdoAct = DETALLE.SdoAct - t-dcaja.ImpTot * t-dcaja.TpoCmb.
                ELSE DETALLE.SdoAct = DETALLE.SdoAct - t-dcaja.ImpTot / t-dcaja.TpoCmb.
    END.            
  END.
  
/*  
  /* ELIMINAMOS LOS DOCUMENTOS DE COBRANZA DUDOSA */
  FOR EACH DETALLE:
    IF DETALLE.SdoAct > 0
    THEN DO:
        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'ELIMINANDO DOCUMENTOS: ' + DETALLE.coddoc + ' ' +
            DETALLE.nrodoc + ' ' + STRING(DETALLE.fchdoc).
        DELETE DETALLE.
    END. 
  END.
*/

  /* LA LETRA ES REEMPLAZADA POR EL DOCUMENTO ORIGINAL */
  DEF VAR x-FactorCje AS DEC DECIMALS 6 NO-UNDO.
  FOR EACH DETALLE WHERE DETALLE.coddoc = 'LET' /*AND DETALLE.codref = 'CJE'*/ :
    FIND Ccbcmvto WHERE Ccbcmvto.codcia = s-codcia
        AND Ccbcmvto.coddoc = DETALLE.codref
        AND Ccbcmvto.nrodoc = DETALLE.nroref
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbcmvto THEN DO:      /* CANJE POR LETRA UBICADO */
        x-FactorCje = DETALLE.ImpTot / Ccbcmvto.ImpTot.
        FOR EACH Ccbdmvto NO-LOCK WHERE Ccbdmvto.codcia = Ccbcmvto.codcia
                AND Ccbdmvto.coddoc = Ccbcmvto.coddoc
                AND Ccbdmvto.nrodoc = Ccbcmvto.nrodoc
                AND Ccbdmvto.TpoRef = 'O',
                FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
                    AND Ccbcdocu.coddoc = Ccbdmvto.codref
                    AND Ccbcdocu.nrodoc = CCbdmvto.nroref:
            FIND t-cdoc OF Ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE t-cdoc THEN CREATE t-cdoc.
            BUFFER-COPY Ccbcdocu TO t-cdoc
                ASSIGN
                    t-cdoc.CodRef = DETALLE.coddoc
                    t-cdoc.NroRef = DETALLE.nrodoc.
            FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
                CREATE t-ddoc.
                BUFFER-COPY Ccbddocu TO t-ddoc
                    ASSIGN
                        t-ddoc.ImpLin = Ccbddocu.ImpLin * x-FactorCje.
            END.
        END.
    END.
    DELETE DETALLE.     /* BORRAMOS LA LETRA */
  END.
  
  /* CARGAMOS LAS NOTAS DE ABONO APLICADAS */
  FOR EACH Ccbcdocu NO-LOCK USE-INDEX LLave13 WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.coddoc = 'N/C'
        AND Ccbcdocu.fchdoc >= x-FchIni
        AND Ccbcdocu.fchdoc <= x-FchFin
        AND Ccbcdocu.flgest <> 'A'
        AND Ccbcdocu.cndcre <> 'N':
    x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'CARGANDO N/C: ' + 
        Ccbcdocu.coddoc + ' ' + Ccbcdocu.nrodoc.
    CREATE t-cdoc.
    BUFFER-COPY Ccbcdocu TO t-cdoc.
    IF Ccbcdocu.SdoAct <= 1 THEN
        ASSIGN t-cdoc.FlgEst = 'C'.
    FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
        CREATE t-ddoc.
        BUFFER-COPY Ccbddocu TO t-ddoc.
    END.        
  END.

  /* CARGAMOS EL DETALLE DEL DOCUMENTO */
  FOR EACH DETALLE NO-LOCK :
    FIND t-cdoc OF DETALLE NO-LOCK NO-ERROR.
    IF AVAILABLE t-cdoc THEN NEXT.
    CREATE t-cdoc.
    BUFFER-COPY DETALLE TO t-cdoc.
    IF Detalle.SdoAct <= 1 THEN 
        ASSIGN t-cdoc.FlgEst = 'C'.
    x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'CARGANDO DOCUMENTOS: ' + DETALLE.coddoc + ' ' +
        DETALLE.nrodoc + ' ' + STRING(DETALLE.fchdoc).
    FOR EACH Ccbddocu OF DETALLE NO-LOCK:
        CREATE t-ddoc.
        BUFFER-COPY Ccbddocu TO t-ddoc.
    END.
  END.

  Datos:
  FOR EACH t-cdoc NO-LOCK:
    x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'CARGANDO COMISIONES: ' + t-cdoc.coddoc + ' ' +
        t-cdoc.nrodoc.
    CREATE t-dcomi.
    ASSIGN
        t-dcomi.CodCia = s-codcia
        t-dcomi.CodDoc = t-cdoc.coddoc
        t-dcomi.CodMon = t-cdoc.codmon
        t-dcomi.CodVen = t-cdoc.codven
        t-dcomi.ImpIgv = t-cdoc.impigv
        t-dcomi.ImpTot = t-cdoc.imptot
        t-dcomi.ImpVta = t-cdoc.impvta
        t-dcomi.NroDoc = t-cdoc.nrodoc
        t-dcomi.PorIgv = t-cdoc.porigv
        t-dcomi.CodRef = t-cdoc.codref
        t-dcomi.NroRef = t-cdoc.nroref.
    /*No considera facturas ya pagadas con comisiones anteriores*/
    IF t-cdoc.FchDoc < 08/26/2009 OR t-cdoc.FlgEst <> "C" THEN DO:
        ASSIGN t-dcomi.impcom = 0.
        NEXT Datos.
    END.
    x-Signo = IF t-cdoc.coddoc = 'N/C' THEN -1 ELSE 1.
    DETALLE:
    FOR EACH t-ddoc OF t-cdoc, FIRST Almmmatg OF t-ddoc NO-LOCK:
        /* Todo en Nuevos Soles */
        IF t-cdoc.codmon = 2 THEN t-ddoc.ImpLin = t-ddoc.ImpLin * t-cdoc.TpoCmb.
        ASSIGN
            t-ddoc.Flg_Factor = Almmmatg.TipArt
            t-ddoc.ImpCto = 0.
        /* Comisiones por Rotacion */
        IF LOOKUP(TRIM(Almmmatg.Clase), 'A,B,C,D,E') > 0 THEN DO:
            FIND PorComi WHERE PorComi.CodCia = s-codcia 
                AND PorComi.Catego = Almmmatg.Clase NO-LOCK NO-ERROR.
            IF AVAILABLE PorComi THEN DO:
                ASSIGN
                    t-ddoc.impcto = x-Signo * t-ddoc.implin * PorComi.Porcom / 100
                    t-dcomi.impcom = t-dcomi.impcom + t-ddoc.impcto.      /* ACUMULAMOS COMISIONES */
                NEXT DETALLE.
            END.
        END.
        /* Comisiones por Linea */
        FIND FacTabla WHERE FacTabla.codcia = s-codcia
            AND FacTabla.Tabla = 'CV'
            AND FacTabla.Codigo = TRIM(Almmmatg.codfam) + t-cdoc.coddiv
            NO-LOCK NO-ERROR.
        IF AVAILABLE FacTabla THEN DO:
            ASSIGN
                t-ddoc.impcto = x-Signo * t-ddoc.implin * FacTabla.Valor[1] / 100
                t-dcomi.impcom = t-dcomi.impcom + t-ddoc.impcto.      /* ACUMULAMOS COMISIONES */
        END.            
        ASSIGN
            t-ddoc.implin = x-Signo * t-ddoc.implin.
    END.
  END.
          
  {&OPEN-QUERY-{&BROWSE-NAME}}

  x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'PROCESO TERMINADO'.
  PAUSE 2.
  x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.


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
  DISPLAY x-Periodo x-Mes x-FchIni x-FchFin x-CodMon x-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-Periodo B-CALCULA-COMISION x-Mes B-NUEVO-CALCULO BUTTON-EXCEL 
         BROWSE-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Vendedor".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Nombre".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Doc".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Numero".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Ref".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Numero".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Fecha Doc".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "Cliente".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "Nombre".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "Mon".
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "Importe".
cRange = "L" + cColumn.
chWorkSheet:Range(cRange):Value = "Comision".
cRange = "M" + cColumn.
chWorkSheet:Range(cRange):Value = "FlgEst".
cRange = "N" + cColumn.
chWorkSheet:Range(cRange):Value = "Saldo Actual".

FOR EACH t-dcomi NO-LOCK,
        FIRST Gn-ven OF t-dcomi,
        FIRST Ccbcdocu WHERE Ccbcdocu.codcia = t-dcomi.codcia
            AND Ccbcdocu.coddoc = t-dcomi.coddoc
            AND Ccbcdocu.nrodoc = t-dcomi.nrodoc:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + t-dcomi.codven.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = gn-ven.NomVen.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = t-dcomi.coddoc.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + t-dcomi.nrodoc.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = t-dcomi.codref.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + t-dcomi.nroref.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = ccbcdocu.FchDoc.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + ccbcdocu.codcli.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = ccbcdocu.nomcli.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(ccbcdocu.codmon).
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(ccbcdocu.imptot).
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(t-dcomi.impcom).
    IF CcbcDocu.SdoAct <= 1 THEN DO:
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = 'C'.
    END.
    ELSE DO: 
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.FlgEst).

    END.
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(CcbCDocu.SdoAct).
END.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar-Comisiones W-Win 
PROCEDURE Grabar-Comisiones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  MESSAGE 'Se va a proceder a grabar las comisiones' SKIP
    '¿Continuamos?' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN.
  
  FIND FacCComi WHERE Facccomi.codcia = s-codcia
    AND Facccomi.periodo = x-periodo
    AND Facccomi.nromes = x-nromes
    EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Facccomi THEN CREATE FacCComi.
  ASSIGN
    FacCComi.CodCia = s-codcia
    FacCComi.CodMon = x-codmon
    FacCComi.FchFin = x-fchfin
    FacCComi.FchIni = x-fchfin
    FacCComi.Fecha = TODAY
    FacCComi.Hora = STRING(TIME, 'HH:MM')
    FacCComi.NroMes = x-nromes
    FacCComi.Periodo = x-periodo
    /*FacCComi.TpoCmb */
    FacCComi.Usuario = s-user-id.
  
  FOR EACH Facdcomi OF Facccomi:
    DELETE Facdcomi.
  END.
  
  FOR EACH t-dcomi:
    x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'GRABANDO COMISIONES: ' + t-dcomi.coddoc + ' ' +
        t-dcomi.nrodoc.
    CREATE Facdcomi.
    BUFFER-COPY t-dcomi TO Facdcomi
        ASSIGN
            Facdcomi.periodo = Facccomi.periodo
            Facdcomi.nromes  = Facccomi.nromes.
  END.
  RELEASE FacCComi.
  
  APPLY 'CHOOSE':U TO B-NUEVO-CALCULO IN FRAME {&FRAME-NAME}.
  x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Fin del proceso'.
  PAUSE 2.
  x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    x-Periodo:DELETE(1).
    x-Periodo:ADD-LAST(STRING(YEAR(TODAY), '9999')).
    x-Periodo:ADD-LAST(STRING(YEAR(TODAY) - 1, '9999')).
    x-Periodo:SCREEN-VALUE = STRING(YEAR(TODAY), '9999').
    x-Periodo = YEAR(TODAY).
/*    x-NroMes = MONTH(TODAY).
 *     x-Mes:SCREEN-VALUE = x-Mes:ENTRY(x-NroMes).
 *     IF x-NroMes = 12
 *     THEN x-FchIni = DATE(12,26,x-Periodo - 1).
 *     ELSE x-FchIni = DATE(x-NroMes - 1,26,x-Periodo).
 *     x-FchFin = DATE(x-NroMes,25,x-Periodo).
 *     DISPLAY x-FchIni x-FchFin.*/
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resetea-Variables W-Win 
PROCEDURE Resetea-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        x-Mes = 'Seleccione Mes'
        x-FchIni = ?
        x-FchFin = ?.
    DISPLAY x-Mes x-FchIni x-FchFin.
    FOR EACH t-dcomi:
        DELETE t-dcomi.
    END.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  END.
  
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
  {src/adm/template/snd-list.i "t-dcomi"}

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

