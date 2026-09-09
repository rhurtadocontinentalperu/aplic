&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE DETALLE NO-UNDO LIKE CcbCDocu.



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
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR x-CodMon    AS CHAR FORMAT 'X(3)' NO-UNDO.
DEF VAR cl-codcia   AS INT       NO-UNDO.
DEF VAR cl-codcbd   AS INT       NO-UNDO.
DEF VAR cCodPos     AS CHAR      NO-UNDO.
DEF VAR cRepLeg     LIKE gn-prov.RepLegal.
DEF VAR cRepLegCar  LIKE gn-prov.RepLegalCargo .
DEF VAR cMes        AS CHARACTER EXTENT 12 NO-UNDO.
DEF VAR dImpTot     AS DECIMAL   NO-UNDO.
DEF VAR X-EnLetras  AS CHARACTER NO-UNDO.
DEF VAR cImpTotLet  AS CHARACTER .
DEF VAR cTipCond    AS CHARACTER.

FIND Empresas WHERE empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.
IF NOT Empresas.Campo-CodCbd THEN cl-codcbd = s-codcia.

DEF BUFFER b-clie FOR gn-clie.

cMes[1]  = 'Enero'.
cMes[2]  = 'Febrero'.
cMes[3]  = 'Marzo'.
cMes[4]  = 'Abril'.
cMes[5]  = 'Mayo'.
cMes[6]  = 'Junio'.
cMes[7]  = 'Julio'.
cMes[8]  = 'Agosto'.
cMes[9]  = 'Setiembre'.
cMes[10] = 'Octubre'.
cMes[11] = 'Noviembre'.
cMes[12] = 'Diciembre'.

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
&Scoped-define INTERNAL-TABLES DETALLE

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 DETALLE.CodDoc DETALLE.NroDoc ~
DETALLE.FchDoc DETALLE.FchVto ~
(IF Detalle.codmon = 1 THEN 'S/.' ELSE 'US$') @ x-CodMon DETALLE.ImpTot ~
DETALLE.SdoAct ~
IF (DETALLE.FchVto <=  txt-fchcorte ) THEN ('Vencimiento') ELSE ('') @ cTipCond 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH DETALLE NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH DETALLE NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 DETALLE
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 DETALLE


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 r-filtro txt-fchcorte FILL-IN-CodCli ~
TOGGLE-1 ChkGrabar txtEmail txtTelef FILL-IN-atencion txtCelular BROWSE-1 ~
BUTTON-1 BUTTON-3 Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS r-filtro txt-fchcorte FILL-IN-CodCli ~
FILL-IN-NomCli FILL-IN-NroCarta TOGGLE-1 txtNombre ChkGrabar txtEmail ~
txtTelef FILL-IN-atencion txtCelular 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "IMG/exit.ico":U
     LABEL "Salir" 
     SIZE 10 BY 2 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "IMG/b-eliminar.bmp":U
     LABEL "Eliminar" 
     SIZE 10 BY 2 TOOLTIP "Eliminar".

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "IMG/b-print.bmp":U
     LABEL "Imprimir" 
     SIZE 10 BY 2 TOOLTIP "Imprimir".

DEFINE VARIABLE FILL-IN-atencion AS CHARACTER FORMAT "X(80)":U INITIAL "PAGO A PROVEEDORES" 
     LABEL "Atencion" 
     VIEW-AS FILL-IN 
     SIZE 62.14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "x(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroCarta AS CHARACTER FORMAT "X(256)":U 
     LABEL "CARTA N°" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .81 NO-UNDO.

DEFINE VARIABLE txt-fchcorte AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Corte" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE txtCelular AS CHARACTER FORMAT "X(50)":U 
     LABEL "No. Celular" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .81 NO-UNDO.

DEFINE VARIABLE txtEmail AS CHARACTER FORMAT "X(150)":U 
     LABEL "Email" 
     VIEW-AS FILL-IN 
     SIZE 57.29 BY .81 NO-UNDO.

DEFINE VARIABLE txtNombre AS CHARACTER FORMAT "X(150)":U 
     LABEL "Analista" 
     VIEW-AS FILL-IN 
     SIZE 57 BY .81 NO-UNDO.

DEFINE VARIABLE txtTelef AS CHARACTER FORMAT "X(60)":U 
     LABEL "Telf Oficina" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .81 NO-UNDO.

DEFINE VARIABLE r-filtro AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"Vencidos", 2
     SIZE 18 BY .85 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 112 BY 4.42.

DEFINE VARIABLE ChkGrabar AS LOGICAL INITIAL yes 
     LABEL "Grabar datos del Analista" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.43 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-1 AS LOGICAL INITIAL no 
     LABEL "Aviso Central de Riesgo" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      DETALLE SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 DISPLAY
      DETALLE.CodDoc COLUMN-LABEL "Doc" FORMAT "x(3)":U WIDTH 4.43
      DETALLE.NroDoc FORMAT "X(12)":U WIDTH 11.43
      DETALLE.FchDoc COLUMN-LABEL "Fecha de!Emision" FORMAT "99/99/9999":U
      DETALLE.FchVto FORMAT "99/99/9999":U WIDTH 11.57
      (IF Detalle.codmon = 1 THEN 'S/.' ELSE 'US$') @ x-CodMon COLUMN-LABEL "Moneda"
            WIDTH 6.72
      DETALLE.ImpTot FORMAT "->>,>>>,>>9.99":U WIDTH 14.43
      DETALLE.SdoAct COLUMN-LABEL "Saldo Actual" FORMAT "->>,>>>,>>9.99":U
            WIDTH 13.14
      IF (DETALLE.FchVto <=  txt-fchcorte ) THEN ('Vencimiento') ELSE ('') @ cTipCond COLUMN-LABEL "Observación" FORMAT "X(15)":U
            WIDTH 22.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 102 BY 10.23
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     r-filtro AT ROW 1.19 COL 26.57 NO-LABEL WIDGET-ID 4
     txt-fchcorte AT ROW 1.27 COL 8.57 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-CodCli AT ROW 2.23 COL 8.57 COLON-ALIGNED
     FILL-IN-NomCli AT ROW 2.23 COL 20.57 COLON-ALIGNED NO-LABEL
     FILL-IN-NroCarta AT ROW 3.12 COL 8.57 COLON-ALIGNED WIDGET-ID 10
     TOGGLE-1 AT ROW 3.31 COL 36.57 WIDGET-ID 12
     txtNombre AT ROW 4.92 COL 10.86 COLON-ALIGNED WIDGET-ID 26
     ChkGrabar AT ROW 5.04 COL 83 WIDGET-ID 24
     txtEmail AT ROW 5.88 COL 10.72 COLON-ALIGNED WIDGET-ID 14
     txtTelef AT ROW 6.81 COL 10.72 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-atencion AT ROW 7.73 COL 46.86 COLON-ALIGNED WIDGET-ID 28
     txtCelular AT ROW 7.77 COL 10.72 COLON-ALIGNED WIDGET-ID 18
     BROWSE-1 AT ROW 9.08 COL 2
     BUTTON-1 AT ROW 9.27 COL 106
     BUTTON-3 AT ROW 12.35 COL 106
     Btn_Done AT ROW 17.15 COL 106
     "   Datos del Analista" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 4.23 COL 4.86 WIDGET-ID 22
          FGCOLOR 4 FONT 6
     RECT-1 AT ROW 4.46 COL 3 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 116.14 BY 18.65
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: DETALLE T "?" NO-UNDO INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "AVISO DE COBRANZA"
         HEIGHT             = 18.65
         WIDTH              = 116.14
         MAX-HEIGHT         = 18.65
         MAX-WIDTH          = 116.14
         VIRTUAL-HEIGHT     = 18.65
         VIRTUAL-WIDTH      = 116.14
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB BROWSE-1 txtCelular F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroCarta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtNombre IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "Temp-Tables.DETALLE"
     _FldNameList[1]   > Temp-Tables.DETALLE.CodDoc
"DETALLE.CodDoc" "Doc" ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.DETALLE.NroDoc
"DETALLE.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.DETALLE.FchDoc
"DETALLE.FchDoc" "Fecha de!Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.DETALLE.FchVto
"DETALLE.FchVto" ? ? "date" ? ? ? ? ? ? no ? no no "11.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"(IF Detalle.codmon = 1 THEN 'S/.' ELSE 'US$') @ x-CodMon" "Moneda" ? ? ? ? ? ? ? ? no ? no no "6.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.DETALLE.ImpTot
"DETALLE.ImpTot" ? ? "decimal" ? ? ? ? ? ? no ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.DETALLE.SdoAct
"DETALLE.SdoAct" "Saldo Actual" ? "decimal" ? ? ? ? ? ? no ? no no "13.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"IF (DETALLE.FchVto <=  txt-fchcorte ) THEN ('Vencimiento') ELSE ('') @ cTipCond" "Observación" "X(15)" ? ? ? ? ? ? ? no ? no no "22.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* AVISO DE COBRANZA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* AVISO DE COBRANZA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Salir */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Eliminar */
DO:
  MESSAGE 'Eliminamos el registro?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN.
  {&BROWSE-NAME}:DELETE-CURRENT-ROW().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Imprimir */
DO:
    ASSIGN FILL-IN-NroCarta TOGGLE-1 txtEmail txtCelular txtTelef chkgrabar txtNombre fill-in-atencion.
    IF txtEmail = "" THEN DO:
        MESSAGE "Ingrese Email del Analista".
        RETURN NO-APPLY.
    END.
    IF txtTelef = "" THEN DO:
        MESSAGE "Ingrese el telefono de oficina del Analista".
        RETURN NO-APPLY.
    END.
    IF txtCelular = "" THEN DO:
        MESSAGE "Ingrese el nro de celular del Analista".
        RETURN NO-APPLY.
    END.
    IF fill-in-atencion = "" THEN DO:
        MESSAGE "Ingrese a quien va dirigido la carta (Atencion)".
        RETURN NO-APPLY.
    END.

/*     IF txtNombre = "" THEN DO:                                         */
/*         MESSAGE "Nombre del usuario esta vacio, comunique a Sistemas". */
/*         RETURN NO-APPLY.                                               */
/*     END.                                                               */

  RUN Imprimir.

  IF ChkGrabar = YES THEN DO:

      DISABLE TRIGGERS FOR LOAD OF ccbTabla.

      DEFINE VAR lDatos AS CHAR.
              
      lDatos = trim(txtNombre) + "|" + TRIM(txtEmail) + "|" + TRIM(txtTelef) + "|" + 
          TRIM(txtCelular) + "|" + STRING(NOW) + "|" + TRIM(fill-in-atencion).

      FIND FIRST ccbtabla WHERE ccbtabla.codcia = s-codcia AND  
                                    ccbtabla.tabla = 'CARTACOB' AND
                                    ccbtabla.codigo = s-user-id EXCLUSIVE NO-ERROR.
      IF NOT AVAILABLE ccbtabla THEN DO:
          CREATE ccbTabla.
          ASSIGN ccbtabla.codcia = s-codcia
                ccbtabla.tabla = 'CARTACOB'
                ccbtabla.codigo = s-user-id
                ccbtabla.libre_c02 = STRING(NOW).
      END.
      ASSIGN ccbtabla.libre_c01 = lDatos.

      RELEASE ccbtabla.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli W-Win
ON LEAVE OF FILL-IN-CodCli IN FRAME F-Main /* Cliente */
DO:
  IF SELF:SCREEN-VALUE <> {&SELF-NAME} THEN DO:
    ASSIGN {&SELF-NAME}.
    FILL-IN-NomCli:SCREEN-VALUE = ''.
    ASSIGN txt-fchcorte r-filtro.

    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN DO:
        FILL-IN-NomCli:SCREEN-VALUE = gn-clie.nomcli.
        cRepLeg    = gn-clie.RepLeg[1].
        cRepLegCar = gn-clie.Aval2[5] .
        FIND almtabla WHERE almtabla.Tabla = 'CP' 
            AND almtabla.Codigo = gn-clie.codpos NO-LOCK NO-ERROR.
        IF AVAILABLE almtabla THEN cCodPos = almtabla.nombre.
        IF (cRepLeg = '' OR cRepLegCar = '') = TRUE THEN DO:
            /*RUN ccb/w-repleg (cl-codcia, fill-in-CodCli,cRepLeg, gn-clie.Aval2[5]).*/
            FIND FIRST b-clie WHERE ROWID(b-clie) = ROWID(gn-clie) NO-LOCK NO-ERROR.
            cRepLeg    = b-clie.RepLeg[1].
            cRepLegCar = b-clie.Aval2[5] .
        END.
        RUN Carga-Temporal.
    END.    
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME r-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL r-filtro W-Win
ON VALUE-CHANGED OF r-filtro IN FRAME F-Main
DO:
    RUN Asigna-Variables.
    RUN Carga-Temporal.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-fchcorte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-fchcorte W-Win
ON LEAVE OF txt-fchcorte IN FRAME F-Main /* Fecha Corte */
DO:
  RUN Asigna-Variables.
  RUN Carga-Temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
/*{src/adm/template/cntnrwin.i}*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables W-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            txt-fchcorte
            r-filtro
            FILL-IN-CodCli.
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
  
  FOR EACH DETALLE:
    DELETE DETALLE.
  END.
  
  FOR EACH Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
      AND Ccbcdocu.flgest = 'P'
      AND Ccbcdocu.codcli = FILL-IN-CodCli 
      AND LOOKUP(TRIM(Ccbcdocu.coddoc), 'FAC,LET,N/D,BOL,DCO') > 0 
      NO-LOCK:         
      /*Solo Vencidos*/
      IF r-filtro = 2 THEN IF Ccbcdocu.FchVto > txt-fchcorte THEN NEXT.
      CREATE DETALLE.
      BUFFER-COPY Ccbcdocu TO DETALLE.
  END.        
  {&OPEN-QUERY-{&BROWSE-NAME}}

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
  DISPLAY r-filtro txt-fchcorte FILL-IN-CodCli FILL-IN-NomCli FILL-IN-NroCarta 
          TOGGLE-1 txtNombre ChkGrabar txtEmail txtTelef FILL-IN-atencion 
          txtCelular 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 r-filtro txt-fchcorte FILL-IN-CodCli TOGGLE-1 ChkGrabar 
         txtEmail txtTelef FILL-IN-atencion txtCelular BROWSE-1 BUTTON-1 
         BUTTON-3 Btn_Done 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
  /* Pasamos la informacion al w-report */
  DEF VAR RB-REPORT-LIBRARY AS CHAR.  /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.     /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR. /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.  /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     /* Otros parametros */
  DEF VAR s-task-no AS INT NO-UNDO.

  DEFINE VAR lNroCarta AS CHAR.
  DEFINE VAR lUbicacion AS CHAR.
  DEFINE VAR lSituacion AS CHAR.

  GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
  RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'ccb/rbccb.prl'.
  RB-REPORT-NAME = 'Aviso de Cobranza 3v2'.   /* Con amenaza */
  RB-INCLUDE-RECORDS = 'O'.

  dImpTot = 0.
  REPEAT:
    s-task-no = RANDOM(1,999999).
    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN LEAVE.
  END.

  GET FIRST {&BROWSE-NAME}.
  REPEAT WHILE AVAILABLE DETALLE:

    CREATE w-report.
    ASSIGN
        w-report.task-no = s-task-no
        w-report.campo-i[1]  = cl-codcia
        w-report.campo-c[1]  = detalle.codcli
        w-report.campo-c[2]  = gn-clie.nomcli
        w-report.campo-c[3]  = gn-clie.dircli
        w-report.campo-c[4]  = gn-clie.ruc
        w-report.campo-c[5]  = detalle.coddoc
        w-report.campo-c[6]  = detalle.nrodoc
        w-report.campo-c[7]  = IF detalle.codmon = 1 THEN 'S/' ELSE 'US$'
        w-report.campo-c[8]  = 'PEN'
        w-report.campo-d[1]  = detalle.fchdoc
        w-report.campo-d[2]  = detalle.fchvto
        /*w-report.campo-f[1]  = IF detalle.codmon = 1 THEN detalle.imptot ELSE (detalle.imptot * detalle.TpoCmb)*/
        w-report.campo-f[1]  = detalle.imptot
        w-report.campo-f[2]  = detalle.sdoact
        w-report.campo-c[15] = CAPS(cRepLeg)
        w-report.campo-c[16] = cRepLegCar
        /*w-report.campo-c[17] = 'Ate, ' + STRING(DAY(TODAY)) + ' de ' + cMes[MONTH(TODAY)] + ' del ' + STRING(YEAR(TODAY))*/
        w-report.campo-c[17] = 'Lima, ' + STRING(DAY(TODAY)) + ' de ' + cMes[MONTH(TODAY)] + ' del ' + STRING(YEAR(TODAY))
        w-report.campo-c[18] = cCodPos.

    /* datos letras */
    lSituacion = "".
    lUbicacion = "".
    IF detalle.coddoc = 'LET' THEN DO:
        w-report.campo-c[10] = 'CARTERA'.
        FIND cb-ctas WHERE cb-ctas.codcia = cl-codcbd
            AND cb-ctas.codcta = detalle.codcta 
            NO-LOCK NO-ERROR.
        IF AVAILABLE cb-ctas THEN DO:
            FIND cb-tabl WHERE cb-tabl.tabla = '04'
                AND cb-tabl.codigo = cb-ctas.codbco
                NO-LOCK NO-ERROR.
            w-report.campo-c[10] = cb-tabl.Nombre.
        END.
        /* documentos canjeados */
        FOR EACH ccbdmvto NO-LOCK WHERE ccbdmvto.codcia = s-codcia
                AND ccbdmvto.coddoc = detalle.codref
                AND ccbdmvto.nrodoc = detalle.nroref
                AND ccbdmvto.codcli = detalle.codcli
                AND ccbdmvto.tporef = 'O':
            IF w-report.campo-c[11] = ''
            THEN w-report.campo-c[11] = ccbdmvto.codref + '-' + ccbdmvto.nroref.
            ELSE w-report.campo-c[11] = w-report.campo-c[11] + ',' + ccbdmvto.codref + '-' + ccbdmvto.nroref.
        END.                

        /* Ic - 21Jul2017 */
        lSituacion = 'EMITIDA'.
        lUbicacion = 'CARTERA'.
        CASE Detalle.flgsit:
            WHEN "C" THEN lSituacion = "COBRANZA LIBRE".
            WHEN "D" THEN lSituacion = "DESCUENTO".
            WHEN "G" THEN lSituacion = "GARANTIA".
            WHEN "P" THEN lSituacion = "PROTESTADA".
        END CASE.
        /* Documentos en Banco */
        IF Detalle.flgubi = "B" THEN DO:
            lUbicacion = 'BANCO'.
        END.
        IF Detalle.flgubi = "C" THEN DO:
            lUbicacion = 'CARTERA'.
        END.

    END.

    
    ASSIGN w-report.campo-c[20] = CAPS(SUBSTRING(lUbicacion, 1, 1) ) + LC(SUBSTRING(lUbicacion, 2) )
            w-report.campo-c[21] = CAPS(SUBSTRING(lSituacion, 1, 1) ) + LC(SUBSTRING(lSituacion, 2) ).

    /*dImpTot = dImpTot + w-report.campo-f[1].*/
    dImpTot = dImpTot + w-report.campo-f[2].
    GET NEXT {&BROWSE-NAME}.
  END.

  /* Nro de la Carta */
  lNroCarta = STRING(NOW,"99/99/9999 HH:MM:SS").
  lNroCarta = SUBSTRING(lNroCarta,4,2) + SUBSTRING(lNroCarta,1,2) + 
          REPLACE(SUBSTRING(lNroCarta,12),":","") + " CC-GFA / " + SUBSTRING(lNroCarta,7,4).

  /************************  PUNTEROS EN POSICION  *******************************/
  RUN bin/_numero(dImpTot, 2, 1, OUTPUT X-EnLetras).
  X-EnLetras = '(' + X-EnLetras + " NUEVOS SOLES)".
  
  RB-FILTER = 'w-report.task-no = ' + STRING(s-task-no).
  RB-OTHER-PARAMETERS = "~ncImpTotLet = " + x-EnLetras + 
                        "~ndImpTot = " + STRING(dImpTot) +
                        "~ncNroCarta = " + lNroCarta +
                        "~ncNombre = " + TRIM(txtNombre) +                         
                        "~ncEmail = " + TRIM(txtEmail) + 
                        "~ncNroTelef = " + TRIM(txtTelef) +
                        "~ncNroCelular = " + TRIM(txtCelular) +
                        "~ncAtencion = " + TRIM(fill-in-atencion) +
                        "~ncavisocentral = " + IF(toggle-1 = YES) THEN "1" ELSE " "  .

  RUN lib/_Imprime2 (RB-REPORT-LIBRARY,
                  RB-REPORT-NAME,
                  RB-INCLUDE-RECORDS,
                  RB-FILTER,
                  RB-OTHER-PARAMETERS).

  FOR EACH w-report WHERE w-report.task-no = s-task-no:
    DELETE w-report.
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
      txt-fchcorte = TODAY
      FILL-IN-NroCarta = "NNNNN  CC-GFA / " + STRING(YEAR(TODAY), '9999').

/* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* Datos del Analista */
  FIND FIRST ccbtabla WHERE ccbtabla.codcia = s-codcia AND  
                                ccbtabla.tabla = 'CARTACOB' AND
                                ccbtabla.codigo = s-user-id NO-LOCK NO-ERROR.
  IF AVAILABLE ccbtabla THEN DO:
      /*IF NUM-ENTRIES(ccbtabla.libre_c01,"|") <= 5 THEN DO:*/
      IF NUM-ENTRIES(ccbtabla.libre_c01,"|") >= 1 THEN txtNombre:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(1,ccbtabla.libre_c01,"|") NO-ERROR.
      IF NUM-ENTRIES(ccbtabla.libre_c01,"|") >= 2 THEN txtEmail:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(2,ccbtabla.libre_c01,"|") NO-ERROR.
      IF NUM-ENTRIES(ccbtabla.libre_c01,"|") >= 3 THEN txtTelef:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(3,ccbtabla.libre_c01,"|") NO-ERROR.
      IF NUM-ENTRIES(ccbtabla.libre_c01,"|") >= 4 THEN txtCelular:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(4,ccbtabla.libre_c01,"|") NO-ERROR.
      IF NUM-ENTRIES(ccbtabla.libre_c01,"|") >= 6 THEN fill-in-atencion:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(6,ccbtabla.libre_c01,"|") NO-ERROR.
      ASSIGN txtNombre.
      /*END.*/
  END.

  FIND FIRST _user WHERE _user._userid = s-user-id NO-LOCK NO-ERROR.
  IF AVAILABLE _user THEN DO:      
      IF _user._user-name <> txtNombre THEN DO:
            txtNombre:SCREEN-VALUE IN FRAME {&FRAME-NAME} = _user._user-name.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
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
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
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
  {src/adm/template/snd-list.i "DETALLE"}

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

