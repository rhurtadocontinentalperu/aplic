&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-VtaDTabla NO-UNDO LIKE VtaDTabla.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
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

{src/adm2/widgetprto.i}

DEFINE SHARED VARIABLE pRCID AS INT.

DEFINE SHARED VAR s-codcia AS INT.
DEFINE VAR lTabla AS CHAR INIT "RACKS".
DEFINE VAR lODConteo AS INT.
DEFINE VAR lPesoTotal AS DEC.
DEFINE VAR lAlmacen AS CHAR.

DEFINE VAR lCD AS CHAR.
DEFINE VAR lMsgErr AS CHAR.
DEFINE VAR lNroOD AS CHAR.

&SCOPED-DEFINE CONDICION ( ~
            INTEGRAL.vtatabla.CodCia = s-codcia AND INTEGRAL.vtatabla.tabla = lTabla AND ~
            INTEGRAL.vtatabla.llave_c1 = lCD AND vtatabla.libre_c02 = 'SI' AND  ~
            ( INTEGRAL.vtatabla.valor[1] - INTEGRAL.vtatabla.valor[2] ) > 0 )

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES VtaTabla tt-VtaDTabla

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 VtaTabla.Llave_c2 VtaTabla.Valor[1] ~
VtaTabla.Valor[2] VtaTabla.Libre_c02 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH VtaTabla ~
      WHERE {&CONDICION} NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH VtaTabla ~
      WHERE {&CONDICION} NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 VtaTabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 VtaTabla


/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 tt-VtaDTabla.Libre_c04 ~
tt-VtaDTabla.Libre_c01 tt-VtaDTabla.Libre_d01 tt-VtaDTabla.Libre_d03 ~
tt-VtaDTabla.Libre_c02 tt-VtaDTabla.Libre_c03 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH tt-VtaDTabla NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH tt-VtaDTabla NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 tt-VtaDTabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 tt-VtaDTabla


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS txtCD optgrpTipo txtOD txtBultos BtnAddOD ~
BROWSE-4 btnGrabar txtCodRack BtnRefrescarRacks btnAceptar BROWSE-2 ~
btnEmpty txtPesoTotal 
&Scoped-Define DISPLAYED-OBJECTS txtCD optgrpTipo txtOD txtBultos ~
txtDetallePaleta txtCodRack txtNomCli txtNomCD txtRacksDisponibles ~
txtPesoTotal 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnAceptar 
     LABEL "Aceptar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BtnAddOD 
     LABEL "Adicionar O/D a la paleta" 
     SIZE 27.43 BY 1.12.

DEFINE BUTTON btnEmpty 
     LABEL "Borrar TODO" 
     SIZE 18 BY 1.12.

DEFINE BUTTON btnGrabar 
     LABEL "Enviar la PALETA al RACK" 
     SIZE 33 BY 1.12.

DEFINE BUTTON BtnRefrescarRacks 
     LABEL "Refrescar RACKS disponibles" 
     SIZE 29 BY 1.12.

DEFINE VARIABLE txtBultos AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Bultos" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE txtCD AS CHARACTER FORMAT "X(5)":U 
     LABEL "Centro de Distribucion" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE txtCodRack AS CHARACTER FORMAT "X(10)":U 
     LABEL "RACK destino de la Paleta" 
     VIEW-AS FILL-IN 
     SIZE 21.43 BY 1.58
     BGCOLOR 9 FGCOLOR 15 FONT 8 NO-UNDO.

DEFINE VARIABLE txtDetallePaleta AS CHARACTER FORMAT "X(100)":U INITIAL "       ORDENES contenidos en la Paleta para enviar al RACK ( Double Click - Elimina )" 
     VIEW-AS FILL-IN 
     SIZE 90.29 BY 1
     BGCOLOR 6 FGCOLOR 15 FONT 13 NO-UNDO.

DEFINE VARIABLE txtNomCD AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE txtNomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52 BY 1 NO-UNDO.

DEFINE VARIABLE txtOD AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "O/ D" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY 1 NO-UNDO.

DEFINE VARIABLE txtPesoTotal AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Peso Total" 
     VIEW-AS FILL-IN 
     SIZE 21.43 BY 1.58
     BGCOLOR 15 FGCOLOR 1 FONT 8 NO-UNDO.

DEFINE VARIABLE txtRacksDisponibles AS CHARACTER FORMAT "X(100)":U INITIAL "             RACKS Disponibles" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1
     BGCOLOR 9 FGCOLOR 15 FONT 14 NO-UNDO.

DEFINE VARIABLE optgrpTipo AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Ventas (O/D)", "O/D",
"Trasferencias Manual (TRA)", "TRA",
"Orden de Transferencia (OTR)", "OTR"
     SIZE 72.43 BY 1.15 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      VtaTabla SCROLLING.

DEFINE QUERY BROWSE-4 FOR 
      tt-VtaDTabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 wWin _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      VtaTabla.Llave_c2 COLUMN-LABEL "Cod.Rack" FORMAT "x(8)":U
      VtaTabla.Valor[1] COLUMN-LABEL "Capacidad!Nro Paletas" FORMAT "->>>,>>>,>>9":U
      VtaTabla.Valor[2] COLUMN-LABEL "Capacidad!Usada" FORMAT "->>>,>>>,>>9":U
            WIDTH 11.29
      VtaTabla.Libre_c02 COLUMN-LABEL "Activo" FORMAT "x(5)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 42 BY 15.08 ROW-HEIGHT-CHARS .58 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 wWin _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      tt-VtaDTabla.Libre_c04 COLUMN-LABEL "Tipo" FORMAT "x(4)":U
            WIDTH 4.86
      tt-VtaDTabla.Libre_c01 COLUMN-LABEL "Orden" FORMAT "x(10)":U
            WIDTH 12.86
      tt-VtaDTabla.Libre_d01 COLUMN-LABEL "Bultos" FORMAT "->>,>>9":U
            WIDTH 7
      tt-VtaDTabla.Libre_d03 COLUMN-LABEL "Peso" FORMAT "->>,>>9.9999":U
      tt-VtaDTabla.Libre_c02 COLUMN-LABEL "CodCiente" FORMAT "x(11)":U
            WIDTH 13.72
      tt-VtaDTabla.Libre_c03 COLUMN-LABEL "Nombre Cliente" FORMAT "x(80)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 90.43 BY 11.85 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     txtCD AT ROW 1.38 COL 20.14 COLON-ALIGNED WIDGET-ID 2
     optgrpTipo AT ROW 17.15 COL 47 NO-LABEL WIDGET-ID 48
     txtOD AT ROW 18.5 COL 51 COLON-ALIGNED WIDGET-ID 32
     txtBultos AT ROW 19.85 COL 52 COLON-ALIGNED WIDGET-ID 36
     BtnAddOD AT ROW 19.96 COL 71.57 WIDGET-ID 38
     BROWSE-4 AT ROW 4.92 COL 46 WIDGET-ID 300
     btnGrabar AT ROW 21.69 COL 69.43 WIDGET-ID 42
     txtDetallePaleta AT ROW 3.81 COL 44.14 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     txtCodRack AT ROW 1.38 COL 113 COLON-ALIGNED WIDGET-ID 28
     BtnRefrescarRacks AT ROW 19.27 COL 10 WIDGET-ID 30
     txtNomCli AT ROW 18.46 COL 64.43 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     txtNomCD AT ROW 1.38 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     btnAceptar AT ROW 1.35 COL 65.43 WIDGET-ID 24
     BROWSE-2 AT ROW 4 COL 2 WIDGET-ID 200
     btnEmpty AT ROW 2.73 COL 46.43 WIDGET-ID 46
     txtRacksDisponibles AT ROW 2.96 COL 1.72 NO-LABEL WIDGET-ID 44
     txtPesoTotal AT ROW 20.35 COL 113.43 COLON-ALIGNED WIDGET-ID 52
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 136.57 BY 22.27 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: tt-VtaDTabla T "?" NO-UNDO INTEGRAL VtaDTabla
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Definicion de Racks"
         HEIGHT             = 22.27
         WIDTH              = 136.57
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.14
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-4 BtnAddOD fMain */
/* BROWSE-TAB BROWSE-2 btnAceptar fMain */
/* SETTINGS FOR FILL-IN txtDetallePaleta IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtNomCD IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtNomCli IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtRacksDisponibles IN FRAME fMain
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.VtaTabla"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "{&CONDICION}"
     _FldNameList[1]   > INTEGRAL.VtaTabla.Llave_c2
"VtaTabla.Llave_c2" "Cod.Rack" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.VtaTabla.Valor[1]
"VtaTabla.Valor[1]" "Capacidad!Nro Paletas" "->>>,>>>,>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.VtaTabla.Valor[2]
"VtaTabla.Valor[2]" "Capacidad!Usada" "->>>,>>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "11.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtaTabla.Libre_c02
"VtaTabla.Libre_c02" "Activo" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.tt-VtaDTabla"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-VtaDTabla.Libre_c04
"tt-VtaDTabla.Libre_c04" "Tipo" "x(4)" "character" ? ? ? ? ? ? no ? no no "4.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-VtaDTabla.Libre_c01
"tt-VtaDTabla.Libre_c01" "Orden" "x(10)" "character" ? ? ? ? ? ? no ? no no "12.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-VtaDTabla.Libre_d01
"tt-VtaDTabla.Libre_d01" "Bultos" "->>,>>9" "decimal" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-VtaDTabla.Libre_d03
"tt-VtaDTabla.Libre_d03" "Peso" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-VtaDTabla.Libre_c02
"tt-VtaDTabla.Libre_c02" "CodCiente" "x(11)" "character" ? ? ? ? ? ? no ? no no "13.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-VtaDTabla.Libre_c03
"tt-VtaDTabla.Libre_c03" "Nombre Cliente" "x(80)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Definicion de Racks */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Definicion de Racks */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 wWin
ON VALUE-CHANGED OF BROWSE-2 IN FRAME fMain
DO:
    txtCodRack:SCREEN-VALUE = "".
    IF AVAILABLE vtatabla THEN DO:
        txtCodRack:SCREEN-VALUE = vtatabla.llave_c2.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
&Scoped-define SELF-NAME BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 wWin
ON MOUSE-MOVE-DBLCLICK OF BROWSE-4 IN FRAME fMain
DO:
  IF AVAILABLE tt-vtadtabla THEN DO:
      MESSAGE 'Seguro de eliminar la OD(' + tt-vtadtabla.libre_c01 + ')' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.

    /*reset Paleta*/
    lODConteo = lODConteo - 1.   

        /*  */
    lPesoTotal = lPesoTotal - tt-vtadtabla.libre_d03.
    DELETE tt-vtadtabla.
    txtPesoTotal:SCREEN-VALUE = STRING(lPesoTotal,">>,>>>,>>9.99").

    {&OPEN-QUERY-BROWSE-4}

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnAceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnAceptar wWin
ON CHOOSE OF btnAceptar IN FRAME fMain /* Aceptar */
DO:
    DEFINE VAR lxCD AS CHAR.

    ASSIGN txtCD.

    lxCD = txtCD:SCREEN-VALUE.
    txtNomCD:SCREEN-VALUE = "".

    IF lxCD = "" THEN DO:
        RETURN NO-APPLY.
    END.

    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
          gn-divi.coddiv = lxCD NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-divi THEN DO:
        MESSAGE "Centro de Distribucion ERRADA" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
    END.

    txtNomCD:SCREEN-VALUE = gn-divi.desdiv.
    /*
    */
  BROWSE-2:VISIBLE = TRUE.
  BROWSE-4:VISIBLE = TRUE.
  txtCodRack:VISIBLE = TRUE.
  txtDetallePaleta:VISIBLE = TRUE.
  btnRefrescarRacks:VISIBLE = TRUE.
  btnGrabar:VISIBLE = TRUE. 
  btnAddOD:VISIBLE = TRUE.
  txtOD:VISIBLE = TRUE.
  txtNomCli:VISIBLE = TRUE.
  txtBultos:VISIBLE = TRUE.
  txtRacksDisponibles:VISIBLE = TRUE.
  btnEmpty:VISIBLE = TRUE.
  optgrptipo:VISIBLE = TRUE.
  txtPesoTotal:VISIBLE = TRUE.

    lCD = lxCD.
    {&OPEN-QUERY-BROWSE-2}

    /*reset Paleta*/
    lODConteo = 0.   
    lPesoTotal = 0.
    EMPTY TEMP-TABLE tt-vtadtabla.

    txtPesoTotal:SCREEN-VALUE = STRING(lPesoTotal,">>,>>>,>>9.99").

    {&OPEN-QUERY-BROWSE-4}

    /*APPLY 'ENTRY':U TO txtOD.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnAddOD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnAddOD wWin
ON CHOOSE OF BtnAddOD IN FRAME fMain /* Adicionar O/D a la paleta */
DO:
   ASSIGN txtOD txtBultos optgrpTipo.  

  IF txtOD <= 0 THEN DO:
      RETURN NO-APPLY.
  END.

  DEFINE VAR lxOD AS CHAR.
  DEFINE VAR lxBultosDisponibles AS INT.
  DEFINE VAR lTipo AS CHAR.
  DEFINE VAR lPeso AS DEC.

  txtNomCli:SCREEN-VALUE = "".  
  lTipo = optgrpTipo.

  IF txtOD > 0 THEN DO:

      lxOD = STRING(txtOD,"999999999").

      FIND tt-vtadtabla WHERE tt-vtadtabla.libre_c04 = lTipo AND 
          tt-vtadtabla.libre_c01 = lxOD NO-LOCK NO-ERROR.
      IF AVAILABLE tt-vtadtabla THEN DO:
          MESSAGE "ORDEN ya esta ingresado" VIEW-AS ALERT-BOX.
          RETURN NO-APPLY.
      END.
    /*
      FIND FIRST vtadtabla WHERE vtadtabla.codcia = s-codcia AND 
                                vtadtabla.tabla = 'MOV-RACK-DTL' AND
                                vtadtabla.libre_c03 = lTipo AND 
                                vtadtabla.llavedetalle = lxOD NO-LOCK NO-ERROR.
      IF AVAILABLE vtadtabla THEN DO:
          MESSAGE "O/D ya tiene RACK Asignado y esta es la Paleta (" + vtadtabla.tipo + ")" VIEW-AS ALERT-BOX.
          RETURN NO-APPLY.
      END.
      */
      FIND FIRST ccbcbult WHERE ccbcbult.codcia = s-codcia AND 
              ccbcbult.coddoc = lTipo AND ccbcbult.nrodoc = lxOD NO-LOCK NO-ERROR.
      IF NOT AVAILABLE ccbcbult THEN DO:
          MESSAGE "O/D ó Transferencia no existe..." VIEW-AS ALERT-BOX.
          RETURN NO-APPLY.
      END.

        lxBultosDisponibles = ccbcbult.bultos - ccbcbult.DEC_01.
        txtNomCli:SCREEN-VALUE = ccbcbult.nomcli.

    IF txtBultos > lxBultosDisponibles THEN DO:
        MESSAGE "Exceso de Bultos para la ORDEN " VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
    END.
    
    lAlmacen = trim(ccbcbult.codcli).   /* Para casos de Transferencias */
    RUN ue-peso (INPUT lTipo, INPUT lxOD, OUTPUT lPeso).
    /* No todos los bultos de la ORDEN van en la PALETA - Proporcion */
    IF txtBultos < ccbcbult.bultos AND ccbcbult.bultos > 0 THEN DO:
        lPeso = (lPeso * txtBultos) / ccbcbult.bultos.
    END.


    CREATE tt-vtadtabla.
        ASSIGN  tt-vtadtabla.libre_c01 = lxOD    
                tt-vtadtabla.libre_d01 = txtBultos
                tt-vtadtabla.libre_d03 = lPeso
                tt-vtadtabla.libre_c02 = ccbcbult.codcli
                tt-vtadtabla.libre_c03 = ccbcbult.nomcli.
                tt-vtadtabla.libre_c04 = lTipo.

        lODConteo = lODConteo + 1.

        {&OPEN-QUERY-BROWSE-4}

    /*  */
    lPesoTotal = lPesoTotal + lPeso.
    txtPesoTotal:SCREEN-VALUE = STRING(lPesoTotal,">>,>>>,>>9.99").
      
      APPLY 'ENTRY':U TO txtOD.

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnEmpty
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnEmpty wWin
ON CHOOSE OF btnEmpty IN FRAME fMain /* Borrar TODO */
DO:
        MESSAGE 'Seguro de borrar el contenido de la PALETA' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.  

    /*reset Paleta*/
    lODConteo = 0.   
        EMPTY TEMP-TABLE tt-vtadtabla.

    lPesoTotal = 0.
    txtPesoTotal:SCREEN-VALUE = STRING(lPesoTotal,">>,>>>,>>9.99").


    {&OPEN-QUERY-BROWSE-4}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnGrabar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnGrabar wWin
ON CHOOSE OF btnGrabar IN FRAME fMain /* Enviar la PALETA al RACK */
DO:
  IF lODConteo > 0   THEN DO:
      MESSAGE 'Seguro de Grabar?' VIEW-AS ALERT-BOX QUESTION
              BUTTONS YES-NO UPDATE rpta AS LOG.
      IF rpta = NO THEN RETURN NO-APPLY.

      ASSIGN txtCD txtCodRack.

      lMsgErr = "".
      RUN ue-grabar.

      IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        IF lMsgErr <> "" THEN DO:
            MESSAGE lMsgErr VIEW-AS ALERT-BOX.
            RETURN NO-APPLY.
        END.      
      END.
      ELSE DO:
        IF lMsgErr <> "" THEN DO:
            MESSAGE lMsgErr VIEW-AS ALERT-BOX.
        END.
        ELSE DO:
            /* reset datos */    
            {&OPEN-QUERY-BROWSE-2}

            lODConteo = 0.   
            EMPTY TEMP-TABLE tt-vtadtabla.
            lPesoTotal = 0.
            txtPesoTotal:SCREEN-VALUE = STRING(lPesoTotal,">>,>>>,>>9.99").

            {&OPEN-QUERY-BROWSE-4}
        END.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnRefrescarRacks
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnRefrescarRacks wWin
ON CHOOSE OF BtnRefrescarRacks IN FRAME fMain /* Refrescar RACKS disponibles */
DO:
   {&OPEN-QUERY-BROWSE-2}
   txtCodRack:SCREEN-VALUE = "".
   txtCodRack:SCREEN-VALUE = vtatabla.llave_c2.

/*
    FIND FIRST {&FIRST-TABLE-IN-QUERY-BROWSE-2} NO-LOCK NO-ERROR.

   IF AVAILABLE vtatabla THEN DO:
       /*txtCodRack:SCREEN-VALUE = vtatabla.llave_c2.*/
   END.
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCD wWin
ON ENTRY OF txtCD IN FRAME fMain /* Centro de Distribucion */
DO:

  BROWSE-2:VISIBLE = FALSE.
  BROWSE-4:VISIBLE = FALSE.
  txtCodRack:VISIBLE = FALSE.
  txtDetallePaleta:VISIBLE = FALSE.
  btnRefrescarRacks:VISIBLE = FALSE.
  btnGrabar:VISIBLE = FALSE. 
  btnAddOD:VISIBLE = FALSE.
  btnEmpty:VISIBLE = FALSE.
  txtOD:VISIBLE = FALSE.
  txtNomCli:VISIBLE = FALSE.
  txtBultos:VISIBLE = FALSE.
  txtPesoTotal:VISIBLE = FALSE.
  txtRacksDisponibles:VISIBLE = FALSE.
  optgrptipo:VISIBLE = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCD wWin
ON LEAVE OF txtCD IN FRAME fMain /* Centro de Distribucion */
DO:
  DEFINE VAR lxCD AS CHAR.

  lxCD = txtCD:SCREEN-VALUE.
  txtNomCD:SCREEN-VALUE = "".

  IF lxCD <> "" THEN DO:
    
      FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
            gn-divi.coddiv = lxCD NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-divi THEN DO:
          RETURN NO-APPLY.
      END.
    
      txtNomCD:SCREEN-VALUE = gn-divi.desdiv.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtOD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtOD wWin
ON LEAVE OF txtOD IN FRAME fMain /* O/ D */
DO:
  ASSIGN optgrptipo.

    ASSIGN txtOD.

    DEFINE VAR lxOD AS CHAR.

    txtNomCli:SCREEN-VALUE = "".
    txtBultos:SCREEN-VALUE = "0".

    IF txtOD > 0 THEN DO:
    
        lxOD = STRING(txtOD,"999999999").
        
        FIND tt-vtadtabla WHERE tt-vtadtabla.libre_c04 = optgrptipo AND 
            tt-vtadtabla.libre_c01 = lxOD NO-LOCK NO-ERROR.
        IF AVAILABLE tt-vtadtabla THEN DO:
            MESSAGE "O/D ya esta ingresado" VIEW-AS ALERT-BOX.
            RETURN NO-APPLY.
        END.
        
        FIND FIRST ccbcbult WHERE ccbcbult.codcia = s-codcia AND 
                ccbcbult.coddoc = optgrptipo AND ccbcbult.nrodoc = lxOD NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ccbcbult THEN DO:
            MESSAGE "ORDEN no existe..." VIEW-AS ALERT-BOX.
            RETURN NO-APPLY.
        END.
        txtNomCli:SCREEN-VALUE = ccbcbult.nomcli.
        txtBultos:SCREEN-VALUE = STRING((ccbcbult.bultos - ccbcbult.DEC_01),">>,>>9").

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

    txtCodRack:SCREEN-VALUE = "".
/*    IF AVAILABLE vtatabla THEN DO:*/
        /*txtCodRack:SCREEN-VALUE = vtatabla.llave_c2.*/
    /*END.*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY txtCD optgrpTipo txtOD txtBultos txtDetallePaleta txtCodRack txtNomCli 
          txtNomCD txtRacksDisponibles txtPesoTotal 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE txtCD optgrpTipo txtOD txtBultos BtnAddOD BROWSE-4 btnGrabar 
         txtCodRack BtnRefrescarRacks btnAceptar BROWSE-2 btnEmpty txtPesoTotal 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros wWin 
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
        WHEN "" THEN .
    END CASE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros wWin 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-grabar wWin 
PROCEDURE ue-grabar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lxOD AS CHAR.
DEFINE VAR lxFecha AS CHAR.
DEFINE VAR lxFecha2 AS CHAR.
DEFINE VAR lxBultos AS INT.
DEFINE VAR lPesoTot AS DEC.

DEFINE VAR lRackOk AS INT.
DEFINE VAR lRackErr AS INT.

lmsgErr = "".

/* No ingreso O/D a la paleta */
IF lODConteo = 0 THEN DO:
    RETURN NO-APPLY.
END.
/* No selecciono RACK */
IF txtCodRack = "" THEN DO:
    lmsgErr = "Seleccione el RACK de destino".
    RETURN NO-APPLY.
END.
/* Si RACK existe */
FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'RACKS' AND 
        vtatabla.llave_c1 = txtCD AND vtatabla.llave_c2 = txtCodRack NO-LOCK NO-ERROR.
IF NOT AVAILABLE vtatabla THEN DO:
    lmsgErr ="Codigo de RACK no existe".
    RETURN NO-APPLY.
END.
/* Si RACK esta disponible */
IF vtatabla.libre_c02 <> 'si' THEN DO:
    lmsgErr = "RACK no esta activo".
    RETURN NO-APPLY.
END.
/* Si RACK tiene capacidad disponible */
IF (vtatabla.valor[1] - vtatabla.valor[2]) <= 0 THEN DO:
    lmsgErr =  "El RACK seleccionado no tiene capacidad disponible" .
    RETURN NO-APPLY.
END.

/* A grabar datossssss */

DISABLE TRIGGERS FOR LOAD OF vtactabla.
DISABLE TRIGGERS FOR LOAD OF vtadtabla.

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR" :

    /* Genero el NroDePaleta */
    lxFecha = string(NOW,"99/99/9999 HH:MM:SS").
    lxFecha2 = SUBSTRING(lxFecha,7,4) + SUBSTRING(lxFecha,4,2) + 
                SUBSTRING(lxFecha,1,2) + SUBSTRING(lxFecha,12,2) +
            SUBSTRING(lxFecha,15,2) + SUBSTRING(lxFecha,18,2).
    lxBultos = 0.
    lPesoTot = 0.

    lRackOk = 0.
    lRackErr = 0.

    FOR EACH tt-vtadtabla :

        FIND FIRST vtadtabla WHERE vtadtabla.codcia = s-codcia AND 
                                  vtadtabla.tabla = 'MOV-RACK-DTL' AND
                                  vtadtabla.libre_c03 = tt-vtadtabla.libre_c04 AND 
                                  vtadtabla.llavedetalle = tt-vtadtabla.libre_c01 NO-LOCK NO-ERROR.
        IF AVAILABLE vtadtabla THEN DO:
            lRackErr = lRackErr + 1.
        END.
        ELSE DO:
            /* O/D */
            lRackOk = lRackOk + 1.
            CREATE vtadtabla.
                ASSIGN vtadtabla.codcia     = s-codcia
                        vtadtabla.tabla     = "MOV-RACK-DTL"
                        vtadtabla.llave     = txtCD     /* CD */
                        vtadtabla.tipo      = lxFecha2  /* Nro Paleta */
                        vtadtabla.llavedetalle = tt-vtadtabla.libre_c01     /* Nro Orden */
                        vtadtabla.libre_d01     = tt-vtadtabla.libre_d01    /* Bultos */
                        vtadtabla.fchcreacion   = TODAY
                        vtadtabla.libre_c02     = string(TIME,"HH:MM:SS")
                        vtadtabla.libre_d02     = pRCID                     /*  */
                        vtadtabla.libre_c03     = tt-vtadtabla.libre_c04    /* O/D, OTR, TRA */
                        vtadtabla.libre_d03     = tt-vtadtabla.libre_d03    /* Peso */
                        vtadtabla.libre_c04     = tt-vtadtabla.libre_c02    /* CodClie */

                                            /* CD + Rack + NroPaleta */
                        vtadtabla.libre_c01 = txtCD + txtCodRack + lxFecha2.


                FIND FIRST ccbcbult WHERE ccbcbult.codcia = s-codcia AND 
                        ccbcbult.coddoc = tt-vtadtabla.libre_c04 
                    AND ccbcbult.nrodoc = tt-vtadtabla.libre_c01 EXCLUSIVE NO-ERROR.
            /* Actualizo los bultos */
            ASSIGN ccbcbult.DEC_01 = ccbcbult.DEC_01 + tt-vtadtabla.libre_d01.

            lxBultos    = lxBultos + tt-vtadtabla.libre_d01.
            lPesoTot    = lPesoTot + tt-vtadtabla.libre_d03.
        END.

    END.
    /* La cabecera  */
    CREATE vtactabla.
        ASSIGN vtactabla.codcia     = s-codcia
                vtactabla.tabla     = "MOV-RACK-HDR"
                vtactabla.llave     = txtCD + txtCodRack + lxFecha2
                vtactabla.libre_c01     = txtCodRack
                vtactabla.libre_c02     = lxFecha2
                vtactabla.libre_d01     = lxBultos
                vtactabla.libre_d02     = pRCID
                vtactabla.libre_f01     = TODAY
                vtactabla.libre_c03     = string(TIME,"HH:MM:SS")
                vtactabla.libre_d04     = lPesoTot.

    /* Actualizo RACK */
        FIND FIRST vtatabla WHERE vtatabla.codcia = 1 AND vtatabla.tabla = 'RACKS' AND 
                vtatabla.llave_c1 = txtCD AND vtatabla.llave_c2 = txtCodRack EXCLUSIVE NO-ERROR.
        IF NOT AVAILABLE vtatabla THEN DO:
            lMsgERR = "Codigo de RACK no existe".
            UNDO, RETURN 'ADM-ERROR'.
        END.
        IF vtatabla.libre_c02 <> 'SI' THEN DO:
            lMsgERR = "RACK no esta ACTIVO".
            UNDO, RETURN 'ADM-ERROR'.
        END.
        IF (vtatabla.valor[1] - vtatabla.valor[2]) <= 0 THEN DO:
            lMsgERR = "RACK sin CAPACIDAD".
            UNDO, RETURN 'ADM-ERROR'.
        END.
        ASSIGN vtatabla.valor[2] = vtatabla.valor[2] + 1.
END.

RELEASE ccbcbult.
RELEASE vtadtabla.
RELEASE vtactabla.
RELEASE vtatabla.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-peso wWin 
PROCEDURE ue-peso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pTipoOrden AS CHAR    NO-UNDO.
DEFINE INPUT PARAMETER pNroOrden AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER pPeso AS DEC    NO-UNDO.

DEFINE VAR lSer AS INT.
DEFINE VAR lnroDoc AS INT.

pPeso = 0.
IF pTipoOrden = 'TRA' THEN DO:
    /* Transferencias */
    lSer = INT(SUBSTRING(pNroOrden,1,3)).
    lNroDoc = INT(SUBSTRING(pNroOrden,4,6)).    
    FOR EACH almdmov WHERE almdmov.codcia  = s-codcia and almdmov.codalm = lAlmacen 
        and almdmov.tipmov = 'S' and almdmov.codmov = 3 and 
        almdmov.nroser = lSer and almdmov.nrodoc = lnroDoc NO-LOCK,
        FIRST almmmatg OF almdmov NO-LOCK:
        pPeso = pPeso + (almdmov.candes * almmmatg.pesmat).
    END.
END.
ELSE DO:
    FOR EACH facdpedi WHERE facdpedi.codcia = s-codcia AND 
        facdpedi.coddoc = pTipoOrden AND 
        facdpedi.nroped = pNroOrden NO-LOCK,
        FIRST almmmatg OF facdpedi NO-LOCK:
      pPeso = pPeso + (facdpedi.canped * almmmatg.pesmat).
    END.
END.




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

