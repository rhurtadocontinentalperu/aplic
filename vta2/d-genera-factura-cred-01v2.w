&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME mgDialog
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-ADocu FOR CcbADocu.
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE BUFFER EXPRESS FOR FacCPedi.
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE SHARED TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE PEDI-2 NO-UNDO LIKE FacDPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE TEMP-TABLE T-CcbADocu NO-UNDO LIKE CcbADocu.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS mgDialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
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

DEFINE INPUT PARAMETER rwParaRowID AS ROWID.
DEFINE INPUT PARAMETER pTipoGuia   AS CHAR.
/* pTipoGuia
    A: automática
    M: manual
    FA: FAI automático
    FM: FAI manual
*/

DEFINE SHARED VARIABLE s-CodCia AS INTEGER.
DEFINE SHARED VARIABLE s-NomCia AS CHARACTER.

DEFINE SHARED VARIABLE s-CodDiv AS CHARACTER.
DEFINE SHARED VARIABLE s-User-Id AS CHARACTER.
DEFINE SHARED VARIABLE cl-codcia AS INTEGER.

DEFINE VARIABLE cCodDoc AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodAlm AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodMov AS INTEGER NO-UNDO.
DEFINE VARIABLE iCountGuide AS INTEGER NO-UNDO.
DEFINE VARIABLE cObser  AS CHARACTER   NO-UNDO.

FIND FacCPedi WHERE ROWID(FacCPedi) = rwParaRowID NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCPedi THEN DO:
    MESSAGE
        "Registro de O/D no disponible"
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
IF NOT (FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = 'C') THEN DO:
    MESSAGE
        "Registro de O/D ya no está 'PENDIENTE'"
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
cCodAlm = FacCPedi.Codalm.      /* <<< OJO <<< */
cObser  = FacCPedi.Glosa.
cCodDoc = FacCPedi.Cmpbnte.     /* <<< OJO <<< */

/* Consistencia del tipo de guia */
CASE TRUE:
    WHEN pTipoGuia = "FM" THEN ASSIGN cCodDoc = "FAI" pTipoGuia = "M".
    WHEN pTipoGuia = "FA" THEN ASSIGN cCodDoc = "FAI" pTipoGuia = "A".
END CASE.
FIND FacDocum WHERE FacDocum.CodCia = s-CodCia 
    AND FacDocum.CodDoc = cCodDoc 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum OR FacDocum.CodMov = 0 THEN DO:
    MESSAGE
        "Codigo de Documento" cCodDoc "no configurado" SKIP
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
cCodMov = FacDocum.CodMov.

DEF VAR cOk AS LOG NO-UNDO.
cOk = NO.
FOR EACH FacCorre NO-LOCK WHERE 
    FacCorre.CodCia = s-CodCia AND
    FacCorre.CodDiv = s-CodDiv AND 
    FacCorre.CodDoc = cCodDoc AND
    FacCorre.FlgEst = YES:
    /* SOLO ACEPTA LOS QUE NO ESTEN ASIGNADOS A UNA CAJA COBRANZA */
    FIND CcbDTerm WHERE CcbDTerm.CodCia = s-codcia
        AND CcbDTerm.CodDiv = s-coddiv
        AND CcbDTerm.CodDoc = cCodDoc
        AND CcbDTerm.NroSer = FacCorre.NroSer
        NO-LOCK NO-ERROR.
    IF AVAILABLE CcbDTerm THEN DO:
        /* Verificamos la cabecera */
        FIND FIRST CcbCTerm OF CcbDTerm NO-LOCK NO-ERROR.
        IF AVAILABLE CcbCTerm THEN NEXT.
    END.
    cOk = YES.
END.
IF cOk = NO THEN DO:
    MESSAGE
        "Codigo de Documento" cCodDoc "no configurado"
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

FIND FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia 
    AND FacCorre.CodDiv = s-CodDiv 
    AND FacCorre.CodDoc = "G/R"
    AND FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE
        "Código de Documento G/R no configurado"
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

DEFINE TEMP-TABLE Reporte NO-UNDO
    FIELD CodCia LIKE CcbCDocu.CodCia
    FIELD CodDiv LIKE CcbCDOcu.CodDiv 
    FIELD CodDoc LIKE CcbCDocu.CodDoc
    FIELD NroDoc LIKE CcbCDocu.Nrodoc
    INDEX Llave01 codcia coddiv coddoc nrodoc.

DEF VAR s-FechaI AS DATETIME NO-UNDO.
DEF VAR s-FechaT AS DATETIME NO-UNDO.

s-FechaI = DATETIME(TODAY, MTIME).

/* Ic - 28Ene2016, Para factura ValesUtilex */
DEFINE VAR pEsValesUtilex AS LOG INIT NO.

/* Ic - 01Mar2016, para ListaExpress */
DEF NEW SHARED VAR s-codcja AS CHAR INITIAL "I/C".
DEF NEW SHARED VAR s-sercja AS INT.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-FormatoFAC  AS CHAR INIT '999-999999' NO-UNDO.
DEF VAR x-FormatoGUIA AS CHAR INIT '999-999999' NO-UNDO.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
/* RUN sunat\p-formato-doc (INPUT cCodDoc, OUTPUT x-FormatoFAC). */
/* RUN sunat\p-formato-doc (INPUT "G/R", OUTPUT x-FormatoGUIA).  */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME mgDialog
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES PEDI Almmmatg

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 PEDI.codmat ~
(IF PEDI.Libre_c05 <> '' AND PEDI.Libre_c05 <> "OF" THEN PEDI.Libre_c05 + ' - ' ELSE '') + Almmmatg.desmat @ Almmmatg.desmat ~
PEDI.canate PEDI.UndVta PEDI.AlmDes 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH PEDI ~
      WHERE PEDI.canate > 0 NO-LOCK, ~
      EACH Almmmatg OF PEDI NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH PEDI ~
      WHERE PEDI.canate > 0 NO-LOCK, ~
      EACH Almmmatg OF PEDI NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 PEDI Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 PEDI
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 Almmmatg


/* Definitions for DIALOG-BOX mgDialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-mgDialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 cboTarjetas BUTTON-4 ~
COMBO-BOX-Guias COMBO-NroSer-Guia COMBO-NroSer Btn_OK Btn_Cancel ~
FILL-IN-Glosa FILL-IN-LugEnt RECT-1 RECT-25 
&Scoped-Define DISPLAYED-OBJECTS cboCobranza cboFormaPago cboTarjetas ~
txtEmpCourier txtMecanismo txtMetodoPago COMBO-BOX-Guias COMBO-NroSer-Guia ~
FILL-IN-NroPed FILL-IN-Cliente FILL-IN-DirClie COMBO-NroSer FILL-IN-NroDoc ~
FILL-IN-items FILL-IN-Glosa FILL-IN-LugEnt FILL-IN-NroDoc-GR 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "&Cancelar" 
     SIZE 12 BY 1.54.

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "&Aceptar" 
     SIZE 12 BY 1.54.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/api-vy.ico":U
     LABEL "Button 4" 
     SIZE 12 BY 1.54 TOOLTIP "Ingresar datos del transportista".

DEFINE VARIABLE cboCobranza AS CHARACTER FORMAT "X(25)":U INITIAL "Pagina Web" 
     LABEL "Canal pago" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Continental","Pagina Web","Courier" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cboFormaPago AS CHARACTER FORMAT "X(20)":U INITIAL "Efectivo" 
     LABEL "Forma de Pago" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Efectivo","Tarjeta","Deposito Bancario" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cboTarjetas AS CHARACTER FORMAT "X(15)":U 
     LABEL "Tarjetas" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 28.29 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Guias AS CHARACTER FORMAT "X(256)":U INITIAL "SI" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "SI","NO" 
     DROP-DOWN-LIST
     SIZE 6 BY 1
     FONT 6 NO-UNDO.

DEFINE VARIABLE COMBO-NroSer AS CHARACTER FORMAT "X(3)":U 
     LABEL "Serie FAC" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 6.72 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-NroSer-Guia AS CHARACTER FORMAT "X(256)":U 
     LABEL "Serie G/R" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Cliente AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 4 NO-UNDO.

DEFINE VARIABLE FILL-IN-DirClie AS CHARACTER FORMAT "X(256)":U 
     LABEL "Dirección" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 4 NO-UNDO.

DEFINE VARIABLE FILL-IN-Glosa AS CHARACTER FORMAT "X(60)":U 
     LABEL "Glosa" 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-items AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "Items por Guía" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-LugEnt AS CHARACTER FORMAT "X(60)":U 
     LABEL "Entregar en" 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "XXX-XXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc-GR AS CHARACTER FORMAT "XXX-XXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroPed AS CHARACTER FORMAT "X(9)":U 
     LABEL "O/D" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE txtEmpCourier AS CHARACTER FORMAT "X(50)":U 
     LABEL "Courier" 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81 NO-UNDO.

DEFINE VARIABLE txtMecanismo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mecanismo" 
     VIEW-AS FILL-IN 
     SIZE 15.57 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE txtMetodoPago AS CHARACTER FORMAT "X(256)":U 
     LABEL "Metodo de Pago" 
     VIEW-AS FILL-IN 
     SIZE 41 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 5.92.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80.14 BY 3.5.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      PEDI, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 mgDialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      PEDI.codmat COLUMN-LABEL "Producto" FORMAT "X(6)":U
      (IF PEDI.Libre_c05 <> '' AND PEDI.Libre_c05 <> "OF" THEN PEDI.Libre_c05 + ' - ' ELSE '') + Almmmatg.desmat @ Almmmatg.desmat COLUMN-LABEL "Descripción" FORMAT "x(60)":U
            WIDTH 45.72
      PEDI.canate FORMAT ">,>>>,>>9.9999":U
      PEDI.UndVta COLUMN-LABEL "Unidad" FORMAT "x(6)":U
      PEDI.AlmDes COLUMN-LABEL "Almacén" FORMAT "x(3)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 80 BY 11.31
         FONT 4 ROW-HEIGHT-CHARS .46 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME mgDialog
     BROWSE-2 AT ROW 11.19 COL 3 WIDGET-ID 200
     cboCobranza AT ROW 8.92 COL 6.57 WIDGET-ID 42
     cboFormaPago AT ROW 9.92 COL 13.14 COLON-ALIGNED WIDGET-ID 52
     cboTarjetas AT ROW 9.88 COL 36.72 COLON-ALIGNED WIDGET-ID 58
     txtEmpCourier AT ROW 8.92 COL 36.57 COLON-ALIGNED WIDGET-ID 44
     txtMecanismo AT ROW 7.92 COL 63.43 COLON-ALIGNED WIDGET-ID 48
     txtMetodoPago AT ROW 7.92 COL 13.14 COLON-ALIGNED WIDGET-ID 46
     BUTTON-4 AT ROW 5.04 COL 82 WIDGET-ID 40
     COMBO-BOX-Guias AT ROW 4.5 COL 69 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     COMBO-NroSer-Guia AT ROW 4.5 COL 18 COLON-ALIGNED WIDGET-ID 32
     FILL-IN-NroPed AT ROW 1.81 COL 18 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-Cliente AT ROW 1.81 COL 35 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-DirClie AT ROW 2.62 COL 35 COLON-ALIGNED WIDGET-ID 24
     COMBO-NroSer AT ROW 3.69 COL 12.43 WIDGET-ID 2
     FILL-IN-NroDoc AT ROW 3.69 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     FILL-IN-items AT ROW 3.69 COL 49 COLON-ALIGNED WIDGET-ID 18
     Btn_OK AT ROW 1.81 COL 82
     Btn_Cancel AT ROW 3.42 COL 82
     FILL-IN-Glosa AT ROW 6.12 COL 18 COLON-ALIGNED WIDGET-ID 28
     FILL-IN-LugEnt AT ROW 5.31 COL 18 COLON-ALIGNED WIDGET-ID 30
     FILL-IN-NroDoc-GR AT ROW 4.5 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     "<<=== Generamos Guía de Remisión?:" VIEW-AS TEXT
          SIZE 32 BY .5 AT ROW 4.77 COL 39 WIDGET-ID 38
          BGCOLOR 12 FGCOLOR 15 FONT 6
     "   Para ListaExpress" VIEW-AS TEXT
          SIZE 15.14 BY .5 AT ROW 7.35 COL 4.72 WIDGET-ID 56
          BGCOLOR 15 FGCOLOR 2 
     RECT-1 AT ROW 1.27 COL 2 WIDGET-ID 4
     RECT-25 AT ROW 7.5 COL 2 WIDGET-ID 54
     SPACE(13.14) SKIP(11.95)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "COMPROBANTES POR ORDEN DE DESPACHO" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: B-ADocu B "?" ? INTEGRAL CcbADocu
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: EXPRESS B "?" ? INTEGRAL FacCPedi
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
      TABLE: PEDI T "SHARED" NO-UNDO INTEGRAL FacDPedi
      TABLE: PEDI-2 T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: T-CcbADocu T "?" NO-UNDO INTEGRAL CcbADocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB mgDialog 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX mgDialog
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-2 1 mgDialog */
ASSIGN 
       FRAME mgDialog:SCROLLABLE       = FALSE
       FRAME mgDialog:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX cboCobranza IN FRAME mgDialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR COMBO-BOX cboFormaPago IN FRAME mgDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-NroSer IN FRAME mgDialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-Cliente IN FRAME mgDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DirClie IN FRAME mgDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-items IN FRAME mgDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc IN FRAME mgDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc-GR IN FRAME mgDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroPed IN FRAME mgDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtEmpCourier IN FRAME mgDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtMecanismo IN FRAME mgDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtMetodoPago IN FRAME mgDialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.PEDI,INTEGRAL.Almmmatg OF Temp-Tables.PEDI"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "Temp-Tables.PEDI.canate > 0"
     _FldNameList[1]   > Temp-Tables.PEDI.codmat
"PEDI.codmat" "Producto" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"(IF PEDI.Libre_c05 <> '' AND PEDI.Libre_c05 <> ""OF"" THEN PEDI.Libre_c05 + ' - ' ELSE '') + Almmmatg.desmat @ Almmmatg.desmat" "Descripción" "x(60)" ? ? ? ? ? ? ? no ? no no "45.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.PEDI.canate
     _FldNameList[4]   > Temp-Tables.PEDI.UndVta
"PEDI.UndVta" "Unidad" "x(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.PEDI.AlmDes
"PEDI.AlmDes" "Almacén" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX mgDialog
/* Query rebuild information for DIALOG-BOX mgDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX mgDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME mgDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mgDialog mgDialog
ON WINDOW-CLOSE OF FRAME mgDialog /* COMPROBANTES POR ORDEN DE DESPACHO */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK mgDialog
ON CHOOSE OF Btn_OK IN FRAME mgDialog /* Aceptar */
DO:
    DEFINE VARIABLE iCount AS INTEGER NO-UNDO.

    ASSIGN cboCobranza txtEmpCourier cboFormaPago cboTarjetas.

    FOR EACH FacDPedi OF FacCPedi NO-LOCK:
        iCount = iCount + 1.
    END.
    IF iCount = 0 THEN DO:
        MESSAGE "No hay items por despachar"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    /* Lista Express */
    IF faccpedi.coddiv = '00506' THEN DO:
        IF cboCobranza = 'Courier' THEN DO:
            IF txtEmpCourier = '' OR txtEmpCourier = ? THEN DO :
                MESSAGE "Por favor ingrese el nombre de la Empresa Courier"
                    VIEW-AS ALERT-BOX ERROR.                
                RETURN NO-APPLY.
            END.
        END.
        IF cboFormaPago = 'Tarjeta' THEN DO:
            IF cboTarjetas = '' OR cboTarjetas = ? THEN DO:
                MESSAGE "Por favor ingrese la Tarjeta de Pago"
                    VIEW-AS ALERT-BOX ERROR.                
                RETURN NO-APPLY.
            END.
        END.
    END.

    MESSAGE
        "¿Todos los datos son correctos?"
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE rpta AS LOGICAL.
    IF rpta <> TRUE THEN RETURN NO-APPLY.

    ASSIGN
        COMBO-NroSer
        COMBO-NroSer-Guia
        FILL-IN-LugEnt
        FILL-IN-Glosa
        COMBO-BOX-Guias.

    /* UN SOLO PROCESO */
    RUN Generacion-de-Factura.
    IF RETURN-VALUE = 'ADM-ERROR' THEN
        MESSAGE
            "Ninguna Factura fue generada"
            VIEW-AS ALERT-BOX WARNING.
    ELSE DO:
        MESSAGE
            "Se ha(n) generado" iCountGuide "Factura(s)"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 mgDialog
ON CHOOSE OF BUTTON-4 IN FRAME mgDialog /* Button 4 */
DO:
  RUN dist/d-transportista (INPUT-OUTPUT TABLE T-CcbADocu).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cboCobranza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cboCobranza mgDialog
ON VALUE-CHANGED OF cboCobranza IN FRAME mgDialog /* Canal pago */
DO:
  DEFINE VAR lxCanal AS CHAR.

  lxCanal = cboCobranza:SCREEN-VALUE.
  DISABLE txtEmpCourier WITH FRAME {&FRAME-NAME}.
  IF lxCanal = 'Courier' THEN DO:
      ENABLE txtEmpCourier WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cboFormaPago
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cboFormaPago mgDialog
ON VALUE-CHANGED OF cboFormaPago IN FRAME mgDialog /* Forma de Pago */
DO:
  DEFINE VAR lxFPago AS CHAR.
  DEFINE VAR lxTarjeta AS CHAR.

  lxFPago = cboFormaPago:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  lxTarjeta = cboTarjetas:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  DISABLE cboTarjetas WITH FRAME {&FRAME-NAME}.
  IF lxFPago = 'Tarjeta' THEN DO:
      ENABLE cboTarjetas WITH FRAME {&FRAME-NAME}.
      IF lxtarjeta = '' OR lxtarjeta = ?  THEN DO:
        cboTarjetas:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '01'.
      END.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Guias
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Guias mgDialog
ON VALUE-CHANGED OF COMBO-BOX-Guias IN FRAME mgDialog
DO:
  ASSIGN {&self-name}.
  IF {&SELF-name} = "SI" THEN COMBO-NroSer-Guia:SENSITIVE = YES.
  ELSE COMBO-NroSer-Guia:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer mgDialog
ON RETURN OF COMBO-NroSer IN FRAME mgDialog /* Serie FAC */
DO:
    APPLY 'Tab':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer mgDialog
ON VALUE-CHANGED OF COMBO-NroSer IN FRAME mgDialog /* Serie FAC */
DO:
    /* Correlativo */
    FIND FacCorre WHERE
        FacCorre.CodCia = s-CodCia AND
        FacCorre.CodDoc = cCodDoc AND
        FacCorre.CodDiv = s-CodDiv AND
        FacCorre.NroSer = INTEGER(SELF:SCREEN-VALUE)
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacCorre THEN
/*         FILL-IN-NroDoc =                          */
/*             STRING(FacCorre.NroSer,"999") +       */
/*             STRING(FacCorre.Correlativo,"999999") */
        FILL-IN-NroDoc = STRING(FacCorre.NroSer,ENTRY(1,x-FormatoFAC,'-')) + 
        STRING(FacCorre.Correlativo,ENTRY(2,x-FormatoFAC,'-')).

    ELSE FILL-IN-NroDoc = "".
    DISPLAY FILL-IN-NroDoc WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-NroSer-Guia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer-Guia mgDialog
ON VALUE-CHANGED OF COMBO-NroSer-Guia IN FRAME mgDialog /* Serie G/R */
DO:
    /* Correlativo */
    FIND FacCorre WHERE
        FacCorre.CodCia = s-CodCia AND
        FacCorre.CodDoc = "G/R" AND
        FacCorre.CodDiv = s-CodDiv AND
        FacCorre.NroSer = INTEGER(SELF:SCREEN-VALUE)
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacCorre THEN
/*         FILL-IN-NroDoc-GR =                       */
/*             STRING(FacCorre.NroSer,"999") +       */
/*             STRING(FacCorre.Correlativo,"999999") */
        FILL-IN-NroDoc-GR = STRING(FacCorre.NroSer,ENTRY(1,x-FormatoGUIA,'-')) + 
        STRING(FacCorre.Correlativo,ENTRY(2,x-FormatoGUIA,'-')).

    ELSE FILL-IN-NroDoc-GR = "".
    DISPLAY FILL-IN-NroDoc-GR WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK mgDialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects mgDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aplicacion-de-Adelantos mgDialog 
PROCEDURE Aplicacion-de-Adelantos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF FacCPedi.TpoLic = NO THEN RETURN.
IF LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL') = 0 THEN RETURN.
RUN vtagn/p-aplica-factura-adelantada (ROWID(Ccbcdocu)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal mgDialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE PEDI.
  FOR EACH facdpedi OF faccpedi NO-LOCK WHERE facdpedi.canped - facdpedi.canate > 0:
      CREATE PEDI.
      BUFFER-COPY facdpedi TO PEDI
          ASSIGN
            PEDI.canped = facdpedi.canped - facdpedi.canate
            PEDI.canate = facdpedi.canped - facdpedi.canate.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierra-Pedido mgDialog 
PROCEDURE Cierra-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE I-NRO AS INTEGER INIT 0 NO-UNDO.
  
  FOR EACH FacDPedi NO-LOCK WHERE 
         FacDPedi.CodCia = S-CODCIA AND
         FacDPedi.CodDoc = CcbCDocu.CodRef AND
         FacDPedi.NroPed = CcbCDocu.NroRef:
    IF (FacDPedi.CanPed - FacDPedi.CanAte) > 0 THEN DO:
       I-NRO = 1.
       LEAVE.
    END.
  END.
  IF I-NRO = 0 THEN ASSIGN FacCPedi.FlgEst = "C".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI mgDialog  _DEFAULT-DISABLE
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
  HIDE FRAME mgDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI mgDialog  _DEFAULT-ENABLE
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
  DISPLAY cboCobranza cboFormaPago cboTarjetas txtEmpCourier txtMecanismo 
          txtMetodoPago COMBO-BOX-Guias COMBO-NroSer-Guia FILL-IN-NroPed 
          FILL-IN-Cliente FILL-IN-DirClie COMBO-NroSer FILL-IN-NroDoc 
          FILL-IN-items FILL-IN-Glosa FILL-IN-LugEnt FILL-IN-NroDoc-GR 
      WITH FRAME mgDialog.
  ENABLE BROWSE-2 cboTarjetas BUTTON-4 COMBO-BOX-Guias COMBO-NroSer-Guia 
         COMBO-NroSer Btn_OK Btn_Cancel FILL-IN-Glosa FILL-IN-LugEnt RECT-1 
         RECT-25 
      WITH FRAME mgDialog.
  VIEW FRAME mgDialog.
  {&OPEN-BROWSERS-IN-QUERY-mgDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Facturas-Adelantadas mgDialog 
PROCEDURE Facturas-Adelantadas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Control de Facturas Adelantadas */
  DEFINE VARIABLE x-saldo-mn AS DEC NO-UNDO.
  DEFINE VARIABLE x-saldo-me AS DEC NO-UNDO.

  ASSIGN
      x-saldo-mn = 0
      x-saldo-me = 0.
  FOR EACH Ccbcdocu USE-INDEX Llave06 NO-LOCK WHERE Ccbcdocu.codcia = Faccpedi.codcia
      AND Ccbcdocu.codcli = Faccpedi.CodCli
      AND Ccbcdocu.flgest = "P"
      AND Ccbcdocu.coddoc = "A/C":
      IF Ccbcdocu.CodMon = 1 THEN x-saldo-mn = x-saldo-mn + Ccbcdocu.SdoAct.
      ELSE x-saldo-me = x-saldo-me + Ccbcdocu.SdoAct.
  END.
  IF x-saldo-mn > 0 OR x-saldo-me > 0 THEN DO:
      MESSAGE 'Hay un SALDO de Factura(s) Adelantada(s) por aplicar' SKIP
          'Por aplicar NUEVOS SOLES:' x-saldo-mn SKIP
          'Por aplicar DOLARES:' x-saldo-me SKIP
          'AVISAR AL AREA DE VENTAS' VIEW-AS ALERT-BOX WARNING.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato mgDialog 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE x-vend  AS CHARACTER NO-UNDO.

    DEFINE FRAME f-det
        CcbDDocu.CodMat  FORMAT 'X(7)'
        Almmmatg.DesMat  FORMAT 'x(60)'
        Almmmatg.DesMar  FORMAT 'x(24)'
        Almmmatg.UndBas
        CcbDDocu.CanDes  FORMAT ">>,>>>,>>9.9999"
        WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

    FOR EACH Reporte,
        FIRST CCbCDocu NO-LOCK WHERE 
            CcbCDocu.CodCia = Reporte.CodCia AND
            CcbCDocu.CodDoc = Reporte.CodDoc AND
            CcbCDocu.NroDoc = Reporte.NroDoc:
        FOR FIRST gn-ven WHERE
            gn-ven.codcia = CcbCDocu.CodCia AND
            gn-ven.CodVen = CcbCDocu.CodVen NO-LOCK:
            x-vend = gn-ven.NomVen.
        END.
        DEFINE FRAME f-cab
            HEADER
            {&PRN2} + {&PRN7A} + {&PRN6A} + s-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
            {&PRN4} + {&PRN6A} + "Cliente : " + CcbCDocu.NomCli  AT 1 FORMAT "X(60)" 
            {&PRN4} + {&PRN6B} + "Pagina: " AT 100 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
            {&PRN4} + {&PRN6A} + "Dirección: " + CcbCDocu.DirCli  AT 1 FORMAT "X(60)" SKIP
            {&PRN4} + {&PRN6A} + "RUC: " + CcbCDocu.RucCli  AT 1 FORMAT "X(40)"
            {&PRN4} + {&PRN6B} + "Hora  : " AT 100 FORMAT "X(15)" STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP
            {&PRN4} + {&PRN6A} + "Vendedor : " + x-vend  AT 1 FORMAT "X(15)" SKIP
            {&PRN4} + {&PRN6B} + "Forma Pago : " + CcbCDocu.FmaPgo  AT 1 FORMAT "X(40)" SKIP
/*RD01*/    {&PRN4} + {&PRN6B} + "Glosa : " + cObser  AT 1 FORMAT "X(60)" SKIP
            {&PRN4} + {&PRN7A} + {&PRN6B} + "N° Guía de Remisión : " + CcbCDocu.NroDoc + {&PRN6B} + {&PRN7B} + {&PRN3} AT 1 FORMAT "X(50)" SKIP   
            {&PRN4} + {&PRN7A} + {&PRN6B} + "N° Orden de Despacho: " + CcbCDocu.Libre_c02 + {&PRN6B} + {&PRN7B} + {&PRN3} AT 1 FORMAT "X(50)" SKIP   
            "Pto. Llegada:" FacCPedi.LugEnt FORMAT 'X(80)' SKIP
            FacCPedi.lugent2 FORMAT 'x(80)' AT 14 SKIP
            "------------------------------------------------------------------------------------------------------------------------------------" SKIP
            " Código  Descripción                                                    Marca                  Unidad      Cantidad           " SKIP
            "------------------------------------------------------------------------------------------------------------------------------------" SKIP 
    /***      999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 */
            WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
        VIEW STREAM Report FRAME f-cab.
        FOR EACH CcbDDocu OF CcbCDocu NO-LOCK,
            EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = CcbDDocu.CodCia
                AND Almmmatg.CodMat = CcbDDocu.CodMat,
                FIRST Almmmate WHERE
                    Almmmate.CodCia = CcbDDocu.CodCia AND
                    Almmmate.CodAlm = CcbCDocu.CodAlm AND
                    Almmmate.CodMat = CcbDDocu.CodMat 
                    BREAK BY Almmmate.CodUbi
                          BY CcbDDocu.CodMat:
                          DISPLAY STREAM Report
                                CcbDDocu.CodMat  
                                Almmmatg.DesMat
                                Almmmatg.DesMar
                                Almmmatg.UndBas
                                CcbDDocu.CanDes
                                WITH FRAME f-det.
        END.
        PAGE STREAM Report.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generacion-de-Factura mgDialog 
PROCEDURE Generacion-de-Factura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    DEFINE VARIABLE iCountItem AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE lCreaHeader AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lItemOk AS LOGICAL NO-UNDO.
    DEFINE VARIABLE pMensaje AS CHAR NO-UNDO.

    DEF BUFFER B-CDOCU FOR Ccbcdocu.
    DEF BUFFER B-DDOCU FOR Ccbddocu.
    DEF BUFFER b-faccpedi FOR faccpedi.
    DEF BUFFER c-faccpedi FOR faccpedi.
        
    EMPTY TEMP-TABLE Reporte.

    RUN Resumen-Temporal.

    /* Verificamos Detalle */
    lItemOk = TRUE.
    FOR EACH PEDI NO-LOCK WHERE PEDI.CanAte > 0:
        FIND Almmmate WHERE
            Almmmate.CodCia = PEDI.CodCia AND
            Almmmate.CodAlm = PEDI.AlmDes AND
            Almmmate.codmat = PEDI.CodMat 
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmate THEN DO:
            MESSAGE
                "Artículo" PEDI.CodMat "NO está asignado al almacén" PEDI.almdes
                VIEW-AS ALERT-BOX ERROR.
            lItemOk = FALSE.
        END.
    END.
    IF NOT lItemOk THEN RETURN 'ADM-ERROR'.

    trloop:
    DO TRANSACTION ON ERROR UNDO trloop, RETURN 'ADM-ERROR' ON STOP UNDO trloop, RETURN 'ADM-ERROR':
        /* 1RA PARTE: GENERAMOS LAS FACTURAS */
        FIND FacCPedi WHERE ROWID(FacCPedi) = rwParaRowID EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE FacCPedi THEN DO:
            MESSAGE
                "Registro de O/D no disponible"
                VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        IF NOT (FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = "C") THEN DO:
            MESSAGE
                "Registro de O/D ya no está 'PENDIENTE'"
                VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            iCountGuide = 0
            lCreaHeader = TRUE
            lItemOk = FALSE.
        /* Correlativo */
        FIND FacCorre WHERE
            FacCorre.CodCia = s-CodCia AND
            FacCorre.CodDoc = cCodDoc AND
            FacCorre.CodDiv = s-CodDiv AND
            FacCorre.NroSer = INTEGER(COMBO-NroSer)
            EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE 'Error en el control de correlativo' cCodDoc s-CodDiv COMBO-NroSer
                VIEW-AS ALERT-BOX ERROR.
            UNDO trloop, RETURN 'ADM-ERROR'.
        END.

        /* Ic - 28Ene2016 - Para O/D - Vales Utilex no generar Guia */
        pEsValesUtilex = NO.
        /* Buscamos el Pedido */
        FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = faccpedi.codcia AND 
                                    b-faccpedi.coddiv = faccpedi.coddiv AND
                                    b-faccpedi.coddoc = 'PED' AND 
                                    b-faccpedi.nroped = faccpedi.nroref NO-LOCK NO-ERROR.
        IF AVAILABLE b-faccpedi THEN DO:
            /* Buscamos la Cotizacion */
            FIND FIRST c-faccpedi WHERE c-faccpedi.codcia = b-faccpedi.codcia AND 
                                        c-faccpedi.coddiv = b-faccpedi.coddiv AND
                                        c-faccpedi.coddoc = 'COT' AND 
                                        c-faccpedi.nroped = b-faccpedi.nroref NO-LOCK NO-ERROR.
            IF AVAILABLE c-faccpedi THEN DO:
                IF c-faccpedi.tpoped = 'VU' THEN pEsValesUtilex = YES.
            END.
        END.

        IF COTIZACION.TpoPed = "LF" THEN DO:   /* LISTA EXPRESS */
            FOR EACH PEDI WHERE PEDI.CanAte > 0,
                FIRST Almmmatg OF PEDI NO-LOCK,
                FIRST Almmmate NO-LOCK WHERE Almmmate.CodCia = FacCPedi.CodCia 
                    AND Almmmate.CodAlm = PEDI.AlmDes
                    AND Almmmate.CodMat = PEDI.CodMat
                BREAK BY PEDI.CodCia BY PEDI.NroItm:

                {vta2/d-genera-factura-cred.i}

            END. /* FOR EACH FacDPedi... */
        END.
        ELSE DO:
            FOR EACH PEDI WHERE PEDI.CanAte > 0,
                FIRST Almmmatg OF PEDI NO-LOCK,
                FIRST Almmmate NO-LOCK WHERE Almmmate.CodCia = FacCPedi.CodCia 
                    AND Almmmate.CodAlm = PEDI.AlmDes
                    AND Almmmate.CodMat = PEDI.CodMat
                BREAK BY PEDI.CodCia BY PEDI.Libre_c05 BY PEDI.Libre_c04 BY PEDI.CodMat:

                {vta2/d-genera-factura-cred.i}

            END. /* FOR EACH FacDPedi... */
        END.

        /* 2DA PARTE: GENERACION DE GUIAS */
        IF pEsValesUtilex = NO AND COMBO-BOX-Guias = "SI" THEN DO:
            /* Correlativo */
            FIND FacCorre WHERE
                FacCorre.CodCia = s-CodCia AND
                FacCorre.CodDoc = "G/R" AND
                FacCorre.CodDiv = s-CodDiv AND
                FacCorre.NroSer = INTEGER(COMBO-NroSer-Guia)
                EXCLUSIVE-LOCK NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                MESSAGE 'Error en el control de correlativo G/R' s-CodDiv COMBO-NroSer-Guia
                    VIEW-AS ALERT-BOX ERROR.
                UNDO trloop, RETURN 'ADM-ERROR'.
            END.
            FOR EACH Reporte, FIRST B-CDOCU OF Reporte:
                CREATE CcbCDocu.
                BUFFER-COPY B-CDOCU
                    TO CcbCDocu
                    ASSIGN
                    CcbCDocu.CodDiv = s-CodDiv
                    CcbCDocu.CodDoc = "G/R"
                    /*CcbCDocu.NroDoc =  STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999") */
                    CcbCDocu.NroDoc =  STRING(FacCorre.NroSer,ENTRY(1,x-FormatoGUIA,'-')) + 
                                        STRING(FacCorre.Correlativo,ENTRY(2,x-FormatoGUIA,'-')) 
                    CcbCDocu.FchDoc = TODAY
                    CcbCDocu.CodRef = B-CDOCU.CodDoc
                    CcbCDocu.NroRef = B-CDOCU.NroDoc
                    CcbCDocu.FlgEst = "F"   /* FACTURADO */
                    CcbCDocu.usuario = S-USER-ID
                    CcbCDocu.TpoFac = "A".    /* AUTOMATICA (No descarga stock) */
                ASSIGN
                    FacCorre.Correlativo = FacCorre.Correlativo + 1.
                ASSIGN
                    B-CDOCU.CodRef = Ccbcdocu.coddoc
                    B-CDOCU.NroRef = Ccbcdocu.nrodoc.
                /* RHC 22/07/2015 COPIAMOS DATOS DEL TRANSPORTISTA */
                FIND FIRST T-CcbADocu NO-LOCK NO-ERROR.
                IF AVAILABLE T-CcbADocu THEN DO:
                    FIND FIRST B-ADOCU WHERE B-ADOCU.codcia = Ccbcdocu.codcia
                        AND B-ADOCU.coddiv = Ccbcdocu.coddiv
                        AND B-ADOCU.coddoc = Ccbcdocu.coddoc
                        AND B-ADOCU.nrodoc = Ccbcdocu.nrodoc
                        NO-ERROR.
                    IF NOT AVAILABLE B-ADOCU THEN CREATE B-ADOCU.
                    BUFFER-COPY T-CcbADocu 
                        TO B-ADOCU
                        ASSIGN
                            B-ADOCU.CodCia = Ccbcdocu.CodCia
                            B-ADOCU.CodDiv = Ccbcdocu.CodDiv
                            B-ADOCU.CodDoc = Ccbcdocu.CodDoc
                            B-ADOCU.NroDoc = Ccbcdocu.NroDoc.
                END.
                /* *********************************************** */
                /* COPIAMOS DATOS DEL TRANSPORTISTA */
/*                 FIND Ccbadocu WHERE Ccbadocu.codcia = B-CDOCU.codcia          */
/*                     AND Ccbadocu.coddiv = B-CDOCU.coddiv                      */
/*                     AND Ccbadocu.coddoc = B-CDOCU.coddoc                      */
/*                     AND Ccbadocu.nrodoc = B-CDOCU.nrodoc                      */
/*                     NO-LOCK NO-ERROR.                                         */
/*                 IF AVAILABLE Ccbadocu THEN DO:                                */
/*                     FIND FIRST B-ADOCU WHERE B-ADOCU.codcia = Ccbcdocu.codcia */
/*                         AND B-ADOCU.coddiv = Ccbcdocu.coddiv                  */
/*                         AND B-ADOCU.coddoc = Ccbcdocu.coddoc                  */
/*                         AND B-ADOCU.nrodoc = Ccbcdocu.nrodoc                  */
/*                         NO-ERROR.                                             */
/*                     IF NOT AVAILABLE B-ADOCU THEN CREATE B-ADOCU.             */
/*                     BUFFER-COPY Ccbadocu TO B-ADOCU                           */
/*                         ASSIGN                                                */
/*                             B-ADOCU.CodDiv = Ccbcdocu.CodDiv                  */
/*                             B-ADOCU.CodDoc = Ccbcdocu.CodDoc                  */
/*                             B-ADOCU.NroDoc = Ccbcdocu.NroDoc.                 */
/*                 END.                                                          */
                FOR EACH B-DDOCU OF B-CDOCU NO-LOCK:
                    CREATE Ccbddocu.
                    BUFFER-COPY B-DDOCU 
                        TO Ccbddocu
                        ASSIGN
                            Ccbddocu.coddiv = Ccbcdocu.coddiv
                            Ccbddocu.coddoc = Ccbcdocu.coddoc
                            Ccbddocu.nrodoc = Ccbcdocu.nrodoc.                        
                END.
            END.
        END.
        /* 3RA PARTE: CANCELACION AUTOMATICA */
        IF cCodDoc = "TCK" AND COTIZACION.TpoPed = "LF" THEN DO:

            DEFINE VAR xCorrelativo AS INT.

            /* Ic - 01Mar2016, Generamos el Ingreso a Caja (I/C) */
            FIND FIRST ccbdterm WHERE
                CcbDTerm.CodCia = s-codcia AND
                CcbDTerm.CodDiv = s-coddiv AND
                CcbDTerm.CodDoc = s-codcja AND
                CcbDTerm.CodTer = 'ListaExpress' NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ccbdterm THEN DO:
                MESSAGE
                   "EL DOCUMENTO INGRESO DE CAJA NO ESTA CONFIGURADO PARA LISTAEXPRESS"
                   VIEW-AS ALERT-BOX ERROR.
                UNDO trLoop, RETURN "ADM-ERROR".
            END.
            s-sercja = ccbdterm.nroser.

            FIND Faccorre WHERE
                FacCorre.CodCia = s-codcia AND
                FacCorre.CodDiv = s-coddiv AND
                FacCorre.CodDoc = s-codcja AND
                FacCorre.NroSer = s-sercja
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE FacCorre THEN DO:
                MESSAGE 'Error correlativo división:' s-coddiv 'documento:' s-codcja 'serie:' s-sercja
                    VIEW-AS ALERT-BOX ERROR.
                UNDO trLoop, RETURN 'ADM-ERROR'.
            END.
                
            xCorrelativo = FacCorre.Correlativo.

            REPEAT:
                IF NOT CAN-FIND(Ccbccaja WHERE Ccbccaja.codcia = s-codcia
                               AND Ccbccaja.coddiv = s-coddiv
                               AND Ccbccaja.coddoc = s-codcja
                               AND Ccbccaja.nrodoc = STRING(FacCorre.NroSer,"999") +
                               STRING(xCorrelativo,"999999")
                               NO-LOCK)
                    THEN LEAVE.
                xCorrelativo = xCorrelativo + 1.
            END.
        
        /* Crea Cabecera de Caja */
        DEFINE VAR lxItmCbo AS INT.
        DEFINE VAR lxMetodoPago AS CHAR.
        DEFINE VAR lxQueTarjeta AS CHAR.

        lxMetodoPago = cboCobranza.
        lxQueTarjeta = ''.
        IF cboCobranza = 'Courier' THEN DO: 
            lxMetodoPago = lxMetodoPago + "|" + txtEmpCourier.
        END.
        ELSE lxMetodoPago = lxMetodoPago + "|  " .

        lxMetodoPago = lxMetodoPago + "|" + cboFormaPago.
        /* Tarjetas */
        IF cboFormaPago = 'Tarjeta' THEN DO:
            lxItmCbo = cboTarjetas:LOOKUP(cboTarjetas) IN FRAME {&FRAME-NAME}.
            lxQueTarjeta = cboTarjetas + ' ' + ENTRY( lxItmCbo * 2 - 1 , cboTarjetas:LIST-ITEM-PAIRS ).            
            lxMetodoPago = lxMetodoPago + "|" + lxQueTarjeta.
        END.
        lxMetodoPago = lxMetodoPago + "|  " .

        /* Para caso ListaExpress...las modalidades de cobro y pago */
        ASSIGN ccbcdocu.codage = lxMetodoPago.

        CREATE CcbCCaja.
        ASSIGN
            CcbCCaja.CodCia     = s-CodCia
            CcbCCaja.CodDiv     = s-CodDiv 
            CcbCCaja.CodDoc     = s-CodCja
            CcbCCaja.NroDoc     = STRING(FacCorre.NroSer,"999") + STRING(xCorrelativo,"999999")
            FacCorre.Correlativo = xCorrelativo + 1
            CcbCCaja.CodCaja    = 'ListaExpress'
            CcbCCaja.usuario    = s-user-id
            CcbCCaja.CodCli     = faccpedi.codcli
            CcbCCaja.NomCli     = faccpedi.NomCli
            CcbCCaja.CodMon     = CcbCDocu.codmon
            CcbCCaja.FchDoc     = TODAY
            CcbCCaja.Tipo       = 'CANCELACION'
            CcbCCaja.TpoCmb     = CcbCDocu.tpocmb
            CcbCCaja.FLGEST     = "C"
            ccbccaja.ImpNac[4] = CcbCDocu.imptot.            
        CASE cboFormaPago :
            WHEN "Efectivo" THEN DO :
                ASSIGN ccbccaja.Voucher[9] = ''.
            END.
            WHEN "Tarjeta" THEN DO:
                ASSIGN ccbccaja.Voucher[9] = lxQueTarjeta.
            END.
            WHEN "Deposito Bancario" THEN DO:
                ASSIGN ccbccaja.Voucher[9] = ''.
            END.
        END CASE.
    
        /* */
            FOR EACH Reporte, FIRST B-CDOCU OF Reporte:
                CREATE Ccbdcaja.
                ASSIGN
                    CcbDCaja.CodCia = B-CDOCU.codcia
                    CcbDCaja.CodCli = B-CDOCU.codcli
                    CcbDCaja.CodDiv = B-CDOCU.coddiv
                    CcbDCaja.CodDoc = CcbCCaja.CodDoc /*B-CDOCU.coddoc*/
                    CcbDCaja.CodMon = B-CDOCU.codmon
                    CcbDCaja.CodRef = B-CDOCU.coddoc
                    CcbDCaja.FchDoc = B-CDOCU.fchdoc
                    CcbDCaja.ImpTot = B-CDOCU.imptot
                    CcbDCaja.NroDoc = CcbCCaja.NroDoc /*B-CDOCU.nrodoc*/
                    CcbDCaja.NroRef = CcbCDocu.nrodoc   /*B-CDOCU.nroref*/
                    CcbDCaja.TpoCmb = B-CDOCU.tpocmb.
                ASSIGN
                    B-CDOCU.FchCan = B-CDOCU.fchdoc
                    B-CDOCU.FlgEst = "C"
                    B-CDOCU.SdoAct = 0.
            END.
        END.

        /* GRABACIONES FINALES */
        /* Cierra la O/D */
        FIND FIRST Facdpedi OF Faccpedi WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Facdpedi THEN FacCPedi.FlgEst = "C".

        /* CONTROL DE FACTURAS ADELANTADAS */
        /*RUN Facturas-Adelantadas.*/
    END. /* DO TRANSACTION... */
    FIND CURRENT FacCPedi NO-LOCK.
    IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
    IF AVAILABLE(Ccbcdocu) THEN FIND CURRENT Ccbcdocu NO-LOCK.  /* Para no peder el puntero */
    IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.
    IF AVAILABLE(Ccbadocu) THEN RELEASE Ccbadocu.
    IF AVAILABLE(B-ADOCU)  THEN RELEASE B-ADOCU.
    IF AVAILABLE(w-repor)  THEN RELEASE w-report.
    IF AVAILABLE(Gn-clie)  THEN RELEASE Gn-clie.
    IF AVAILABLE(Ccbccaja) THEN RELEASE Ccbccaja.

    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir mgDialog 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN vta/r-impgr-01 (INPUT-OUTPUT TABLE Reporte).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize mgDialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO.
  DEFINE VAR lxCotizacion AS CHAR.

  IF pTipoGuia = "A" THEN RUN Carga-Temporal.

  FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
  DO WITH FRAME {&FRAME-NAME}:
      /* CORRELATIVO DE FAC y BOL */
      cListItems = "".
      FOR EACH FacCorre NO-LOCK WHERE 
          FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDiv = s-CodDiv AND 
          FacCorre.CodDoc = cCodDoc AND
          FacCorre.FlgEst = YES:
          /* SOLO ACEPTA LOS QUE NO ESTEN ASIGNADOS A UNA CAJA COBRANZA */
          FIND CcbDTerm WHERE CcbDTerm.CodCia = s-codcia
              AND CcbDTerm.CodDiv = s-coddiv
              AND CcbDTerm.CodDoc = cCodDoc
              AND CcbDTerm.NroSer = FacCorre.NroSer
              NO-LOCK NO-ERROR.
          IF AVAILABLE CcbDTerm THEN DO:
              /* Verificamos la cabecera */
              FIND FIRST CcbCTerm OF CcbDTerm NO-LOCK NO-ERROR.
              IF AVAILABLE CcbCTerm THEN NEXT.
          END.
          IF cListItems = "" THEN cListItems = STRING(FacCorre.NroSer,"999").
          ELSE cListItems = cListItems + "," + STRING(FacCorre.NroSer,"999").
      END.
      ASSIGN
          COMBO-NroSer:LIST-ITEMS = cListItems
          COMBO-NroSer = ENTRY(1,COMBO-NroSer:LIST-ITEMS)
          FILL-IN-items = (IF cCodDoc = "TCK" THEN 999999 ELSE FacCfgGn.Items_Guias)
          FILL-IN-NroPed = FacCPedi.NroPed
          FILL-IN-Glosa = FacCPedi.Glosa
          FILL-IN-LugEnt = FacCPedi.LugEnt
          FILL-IN-Cliente = FacCPedi.CodCli + " - " + FacCPedi.NomCli
          FILL-IN-DirClie = FacCPedi.DirCli.
      CASE cCodDoc:
          WHEN "FAC" THEN COMBO-NroSer:LABEL = 'SERIE DE FACTURA'.
          WHEN "BOL" THEN COMBO-NroSer:LABEL = 'SERIE DE BOLETA'.
          WHEN "TCK" THEN COMBO-NroSer:LABEL = 'SERIE DE TICKET'.
      END CASE.
      ASSIGN
          COMBO-NroSer:FORMAT = TRIM(ENTRY(1,x-FormatoFAC,'-'))
          FILL-IN-NroDoc:FORMAT = x-FormatoFAC.
      FIND FacCorre WHERE
          FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDoc = cCodDoc AND
          FacCorre.CodDiv = s-CodDiv AND
          FacCorre.NroSer = INTEGER(COMBO-NroSer)
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacCorre THEN
/*           FILL-IN-NroDoc =                          */
/*               STRING(FacCorre.NroSer,"999") +       */
/*               STRING(FacCorre.Correlativo,"999999") */
          FILL-IN-NroDoc =
              STRING(FacCorre.NroSer,ENTRY(1,x-FormatoFAC,'-')) +
              STRING(FacCorre.Correlativo,ENTRY(2,x-FormatoFAC,'-')).

      /* CORRELATIVO DE GUIAS DE REMISION */
      cListItems = "".
      FOR EACH FacCorre NO-LOCK WHERE 
          FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDiv = s-CodDiv AND 
          FacCorre.CodDoc = "G/R" AND
          FacCorre.FlgEst = YES:
          IF cListItems = "" THEN cListItems = STRING(FacCorre.NroSer,"999").
          ELSE cListItems = cListItems + "," + STRING(FacCorre.NroSer,"999").
      END.
      ASSIGN
          COMBO-NroSer-Guia:LIST-ITEMS = cListItems
          COMBO-NroSer-Guia = ENTRY(1,COMBO-NroSer-Guia:LIST-ITEMS).
      /* Correlativo */
      FIND FIRST FacCorre WHERE
          FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDiv = s-CodDiv AND
          FacCorre.CodDoc = "G/R" AND
          FacCorre.NroSer = INTEGER(COMBO-NroSer-Guia)
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacCorre THEN
/*           FILL-IN-NroDoc-GR =                       */
/*               STRING(FacCorre.NroSer,"999") +       */
/*               STRING(FacCorre.Correlativo,"999999") */
          FILL-IN-NroDoc-GR =
              STRING(FacCorre.NroSer,ENTRY(1,x-FormatoGUIA,'-')) +
              STRING(FacCorre.Correlativo,ENTRY(2,x-FormatoGUIA,'-')).

      /* RHC Cargamos TRANSPORTISTA por defecto */
      EMPTY TEMP-TABLE T-CcbADocu.
      FIND Ccbadocu WHERE Ccbadocu.codcia = Faccpedi.codcia
              AND Ccbadocu.coddiv = Faccpedi.coddiv
              AND Ccbadocu.coddoc = Faccpedi.coddoc
              AND Ccbadocu.nrodoc = Faccpedi.nroped
              NO-LOCK NO-ERROR.
      IF AVAILABLE CcbADocu THEN DO:
          CREATE T-CcbADocu.
          BUFFER-COPY CcbADocu TO T-CcbADocu
              ASSIGN
              T-CcbADocu.CodDiv = CcbADocu.CodDiv
              T-CcbADocu.CodDoc = CcbADocu.CodDoc
              T-CcbADocu.NroDoc = CcbADocu.NroDoc.
      END.      
  END.

  /* Ic - 01mar2016, ListaExpress */
  cboTarjetas:DELETE(cboTarjetas:LIST-ITEM-PAIRS).
  FOR EACH factabla WHERE factabla.codcia = s-codcia and 
                        factabla.tabla = 'TC' and 
                        factabla.codigo <> "00" and 
                        length(factabla.codigo) <= 2 NO-LOCK:
        cboTarjetas:ADD-LAST(factabla.nombre, factabla.codigo). 
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      /* RHC 14.08.2014 Caso de FAI */
      IF cCodDoc = "FAI" THEN DO:
          COMBO-NroSer:LABEL = "Serie FAI".
          COMBO-BOX-Guias:SCREEN-VALUE = "SI".
          COMBO-BOX-Guias:SENSITIVE = NO.
          APPLY 'VALUE-CHANGED' TO COMBO-BOX-Guias.
      END.
      /* RHC 03/02/2016 */
      IF cCodDoc = "TCK" THEN DO:
          ASSIGN
              COMBO-BOX-Guias:SCREEN-VALUE = "NO"
              COMBO-BOX-Guias:SENSITIVE = NO.
          APPLY 'VALUE-CHANGED' TO COMBO-BOX-Guias.
      END.

      /* Ic - 28Ene2016 - Para O/D - Vales Utilex no generar Guia */
      DEFINE BUFFER b-faccpedi FOR faccpedi.
      DEFINE BUFFER c-faccpedi FOR faccpedi.

      lxCotizacion = ''.
      DEFINE VAR cEsValesUtilex AS LOG INIT NO.

      /* Buscamos el Pedido */
      FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = faccpedi.codcia AND 
                                  b-faccpedi.coddiv = faccpedi.coddiv AND
                                  b-faccpedi.coddoc = 'PED' AND 
                                  b-faccpedi.nroped = faccpedi.nroref NO-LOCK NO-ERROR.
      IF AVAILABLE b-faccpedi THEN DO:
          /* Buscamos la Cotizacion */
          lxCotizacion = b-faccpedi.nroref.
          FIND FIRST c-faccpedi WHERE c-faccpedi.codcia = b-faccpedi.codcia AND 
                                      c-faccpedi.coddiv = b-faccpedi.coddiv AND
                                      c-faccpedi.coddoc = 'COT' AND 
                                      c-faccpedi.nroped = b-faccpedi.nroref NO-LOCK NO-ERROR.
          IF AVAILABLE c-faccpedi THEN DO:
              IF c-faccpedi.tpoped = 'VU' THEN DO:
                  COMBO-BOX-Guias:SCREEN-VALUE = "NO".
                  APPLY 'VALUE->CHANGED' TO COMBO-BOX-Guias.
              END.
          END.
      END.

      RELEASE b-faccpedi.
      RELEASE c-faccpedi.

      /* Ic - 01Mar2016, ListaExpress */
      DISABLE cboCobranza.
      DISABLE txtEmpCourier.
      DISABLE cboFormaPago.
      DISABLE cboTarjetas.

      DEFINE BUFFER i-vtatabla FOR vtatabla.
      /**/
      IF s-CodDiv = '00506' THEN DO:
          FIND FIRST i-vtatabla WHERE i-vtatabla.codcia = s-codcia AND
                                    i-vtatabla.tabla = "MTPGLSTEXPRS" AND 
                                    i-vtatabla.llave_c1 = lxCotizacion NO-LOCK NO-ERROR.
          IF AVAILABLE i-vtatabla THEN DO:
                ASSIGN txtMetodoPago:SCREEN-VALUE = i-vtatabla.llave_c3
                        txtMecanismo:SCREEN-VALUE = i-vtatabla.llave_c5.
          END.
          
          ENABLE cboCobranza.
          ENABLE cboFormaPago.
      END.
      RELEASE i-vtatabla.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Papel-Blanco mgDialog 
PROCEDURE Papel-Blanco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF CcbCDocu.FlgEst <> "A" THEN DO:
        IF CcbCDocu.FlgEnv  = YES    /* Es G/R manual */
            OR Ccbcdocu.FlgEst = 'X' THEN DO:
            MESSAGE 'Esta GUIA SOLO debe imprimirse en PAPEL BLANCO' SKIP
                'NO usar formatos preimpresos' SKIP
                'Continuamos la impresion?'
                VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
                UPDATE rpta-1 AS LOG.
            IF rpta-1 = NO THEN RETURN.
            RUN Imprimir.
        END.
        ELSE DO:
            IF Ccbcdocu.flgest <> 'F' THEN DO:
                MESSAGE 'NO se puede imprimir la guía' SKIP
                    'Aún no se ha Facturado' VIEW-AS ALERT-BOX ERROR.
                RETURN.
            END.
            RUN vta/d-fmtgui (ROWID(CcbCDocu)).
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros mgDialog 
PROCEDURE Procesa-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CASE HANDLE-CAMPO:NAME:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CreaCabecera mgDialog 
PROCEDURE proc_CreaCabecera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* ******************************************* */
    /* RHC 24/11/2015 Control de LISTA DE TERCEROS */
    /* ******************************************* */
    IF AVAILABLE COTIZACION AND COTIZACION.TipBon[10] > 0 THEN DO:
        FIND Gn-clie WHERE Gn-clie.codcia = cl-codcia
            AND Gn-clie.codcli = Faccpedi.codcli
            EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR AND LOCKED(Gn-clie) THEN DO:
            MESSAGE 'NO se pudo actualizar el control de LISTA DE TERCEROS en el cliente'
                VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            Gn-clie.Libre_d01 = MAXIMUM(Gn-clie.Libre_d01, COTIZACION.TipBon[10]).
    END.
/*     FIND PEDIDO WHERE PEDIDO.codcia = Faccpedi.codcia                                         */
/*         AND PEDIDO.coddiv = Faccpedi.coddiv                                                   */
/*         AND PEDIDO.coddoc = Faccpedi.codref                                                   */
/*         AND PEDIDO.nroped = Faccpedi.nroref                                                   */
/*         NO-LOCK NO-ERROR.                                                                     */
/*     IF AVAILABLE PEDIDO THEN DO:                                                              */
/*         FIND COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia                               */
/*             AND COTIZACION.coddiv = PEDIDO.coddiv                                             */
/*             AND COTIZACION.coddoc = PEDIDO.codref                                             */
/*             AND COTIZACION.nroped = PEDIDO.nroref                                             */
/*             NO-LOCK NO-ERROR.                                                                 */
/*         IF AVAILABLE COTIZACION AND COTIZACION.TipBon[10] > 0 THEN DO:                        */
/*             FIND Gn-clie WHERE Gn-clie.codcia = cl-codcia                                     */
/*                 AND Gn-clie.codcli = Faccpedi.codcli                                          */
/*                 EXCLUSIVE-LOCK NO-ERROR.                                                      */
/*             IF ERROR-STATUS:ERROR AND LOCKED(Gn-clie) THEN DO:                                */
/*                 MESSAGE 'NO se pudo actualizar el control de LISTA DE TERCEROS en el cliente' */
/*                     VIEW-AS ALERT-BOX ERROR.                                                  */
/*                 UNDO, RETURN 'ADM-ERROR'.                                                     */
/*             END.                                                                              */
/*             ASSIGN                                                                            */
/*                 Gn-clie.Libre_d01 = MAXIMUM(Gn-clie.Libre_d01, COTIZACION.TipBon[10]).        */
/*         END.                                                                                  */
/*     END.                                                                                      */
    FIND Gn-clie WHERE Gn-clie.codcia = cl-codcia
        AND Gn-clie.codcli = Faccpedi.codcli
        NO-LOCK NO-ERROR.
    /* ******************************************* */
    CREATE CcbCDocu.
    BUFFER-COPY FacCPedi 
        EXCEPT Faccpedi.ImpDto2 Faccpedi.PorDto Faccpedi.Importe
        TO CcbCDocu
        ASSIGN
        CcbCDocu.CodDiv = s-CodDiv
        CcbCDocu.DivOri = FacCPedi.CodDiv    /* OJO: division de estadisticas */
        CcbCDocu.CodAlm = FacCPedi.CodAlm   /* OJO: Almacén despacho */
        CcbCDocu.CodDoc = cCodDoc
        /*CcbCDocu.NroDoc =  STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999") */
        CcbCDocu.NroDoc =  STRING(FacCorre.NroSer,ENTRY(1,x-FormatoFAC,'-')) + 
                            STRING(FacCorre.Correlativo,ENTRY(2,x-FormatoFAC,'-')) 
        CcbCDocu.FchDoc = TODAY
        CcbCDocu.CodMov = cCodMov
        CcbCDocu.CodRef = FacCPedi.CodDoc           /* CONTROL POR DEFECTO */
        CcbCDocu.NroRef = FacCPedi.NroPed
        CcbCDocu.Libre_c01 = FacCPedi.CodDoc        /* CONTROL ADICIONAL */
        CcbCDocu.Libre_c02 = FacCPedi.NroPed
        CcbCDocu.Libre_c04 = (IF cCodDoc = "TCK" AND AVAILABLE gn-clie AND gn-clie.libre_c01 = "J" THEN "FAC" ELSE "")     /* Para TCK */
        Ccbcdocu.CodPed = FacCPedi.CodRef
        Ccbcdocu.NroPed = FacCPedi.NroRef
        CcbCDocu.FchVto = TODAY
        CcbCDocu.CodAnt = FacCPedi.Atencion     /* DNI */
        CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
        CcbCDocu.NroOrd = FacCPedi.ordcmp
        CcbCDocu.FlgEst = IF (pEsValesUtilex = YES ) THEN "E" ELSE "P"
        CcbCDocu.TpoFac = "CR"                  /* CREDITO */
        CcbCDocu.Tipo   = "CREDITO"
        CcbCDocu.usuario = S-USER-ID
        CcbCDocu.HorCie = STRING(TIME,'hh:mm')
        CcbCDocu.LugEnt = FILL-IN-LugEnt
        CcbCDocu.LugEnt2 = FacCPedi.LugEnt2
        CcbCDocu.Glosa = FILL-IN-Glosa
        CcbCDocu.FlgCbd = FacCPedi.FlgIgv.
    /* RHC 18/02/2016 LISTA EXPRESS WEB */          
    IF COTIZACION.TpoPed = "LF" 
        THEN ASSIGN
                CcbCDocu.ImpDto2   = COTIZACION.ImpDto2       /* Descuento TOTAL CON IGV */
                CcbCDocu.Libre_d01 = COTIZACION.Importe[3].   /* Descuento TOTAL SIN IGV */
    /* **************************** */
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /*RDP*/    
    FIND FIRST Reporte WHERE Reporte.codcia = Ccbcdocu.codcia
        AND Reporte.coddiv = Ccbcdocu.coddiv
        AND Reporte.coddoc = Ccbcdocu.coddoc
        AND Reporte.nrodoc = Ccbcdocu.nrodoc
        NO-ERROR.
    IF NOT AVAILABLE Reporte THEN CREATE Reporte.
    ASSIGN 
        Reporte.CodCia = CcbCDocu.CodCia
        Reporte.CodDiv = CcbCDocu.CodDiv
        Reporte.CodDoc = CcbCDocu.CodDoc
        Reporte.NroDoc = CcbCDocu.NroDoc.
    FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN DO:
        CcbCDocu.TipVta = IF gn-ConVt.TotDias = 0 THEN "1" ELSE "2".
        CcbCDocu.FchVto = CcbCDocu.FchDoc + INTEGER(ENTRY(NUM-ENTRIES(gn-ConVt.Vencmtos),gn-ConVt.Vencmtos)).
    END.
    FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
        AND gn-clie.CodCli = CcbCDocu.CodCli 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie  THEN DO:
        ASSIGN
            CcbCDocu.CodDpto = gn-clie.CodDept 
            CcbCDocu.CodProv = gn-clie.CodProv 
            CcbCDocu.CodDist = gn-clie.CodDist.
    END.
    /* Guarda Centro de Costo */
    FIND gn-ven WHERE
        gn-ven.codcia = s-codcia AND
        gn-ven.codven = ccbcdocu.codven
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN ccbcdocu.cco = gn-ven.cco.
    /* RHC 22/07/2015 COPIAMOS DATOS DEL TRANSPORTISTA */
    FIND FIRST T-CcbADocu NO-LOCK NO-ERROR.
    IF AVAILABLE T-CcbADocu THEN DO:
        FIND FIRST B-ADOCU WHERE B-ADOCU.codcia = Ccbcdocu.codcia
            AND B-ADOCU.coddiv = Ccbcdocu.coddiv
            AND B-ADOCU.coddoc = Ccbcdocu.coddoc
            AND B-ADOCU.nrodoc = Ccbcdocu.nrodoc
            NO-ERROR.
        IF NOT AVAILABLE B-ADOCU THEN CREATE B-ADOCU.
        BUFFER-COPY T-CcbADocu 
            TO B-ADOCU
            ASSIGN
                B-ADOCU.CodCia = Ccbcdocu.CodCia
                B-ADOCU.CodDiv = Ccbcdocu.CodDiv
                B-ADOCU.CodDoc = Ccbcdocu.CodDoc
                B-ADOCU.NroDoc = Ccbcdocu.NroDoc.
    END.
    /* COPIAMOS DATOS DEL TRANSPORTISTA */
/*     FIND Ccbadocu WHERE Ccbadocu.codcia = Faccpedi.codcia         */
/*         AND Ccbadocu.coddiv = Faccpedi.coddiv                     */
/*         AND Ccbadocu.coddoc = Faccpedi.coddoc                     */
/*         AND Ccbadocu.nrodoc = Faccpedi.nroped                     */
/*         NO-LOCK NO-ERROR.                                         */
/*     IF AVAILABLE Ccbadocu THEN DO:                                */
/*         FIND FIRST B-ADOCU WHERE B-ADOCU.codcia = Ccbcdocu.codcia */
/*             AND B-ADOCU.coddiv = Ccbcdocu.coddiv                  */
/*             AND B-ADOCU.coddoc = Ccbcdocu.coddoc                  */
/*             AND B-ADOCU.nrodoc = Ccbcdocu.nrodoc                  */
/*             NO-ERROR.                                             */
/*         IF NOT AVAILABLE B-ADOCU THEN CREATE B-ADOCU.             */
/*         BUFFER-COPY Ccbadocu TO B-ADOCU                           */
/*             ASSIGN                                                */
/*                 B-ADOCU.CodDiv = Ccbcdocu.CodDiv                  */
/*                 B-ADOCU.CodDoc = Ccbcdocu.CodDoc                  */
/*                 B-ADOCU.NroDoc = Ccbcdocu.NroDoc.                 */
/*     END.                                                          */
    /* ******************************** */
    /* TRACKING GUIAS */
    RUN vtagn/pTracking-04 (s-CodCia,
                            s-CodDiv,
                            Ccbcdocu.CodPed,
                            Ccbcdocu.NroPed,
                            s-User-Id,
                            'EFAC',
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Ccbcdocu.coddoc,
                            Ccbcdocu.nrodoc,
                            CcbCDocu.Libre_c01,
                            CcbCDocu.Libre_c02).
    s-FechaT = DATETIME(TODAY, MTIME).
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_GrabaTotales mgDialog 
PROCEDURE proc_GrabaTotales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {vta2/graba-totales-factura-cred.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros mgDialog 
PROCEDURE Recoge-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CASE HANDLE-CAMPO:NAME:
        WHEN "" THEN ASSIGN input-var-1 = "".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumen-Temporal mgDialog 
PROCEDURE Resumen-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* RHC 04/02/2016 LISTA EXPRESS-> Viene los códigos repetidos */
    /* NOTA: Se a facturar con EL ORIGINAL (CLE)
             Si el importe del ticket es menor a la COT => NOTA DE CREDITO
       NOTA: Siempre cargar el temporal ITEM para actualizar lo atendido en la O/D
    */
    /*RUN vtagn/p-tpoped ( ROWID(Faccpedi) ).*/
    FIND PEDIDO WHERE PEDIDO.codcia = Faccpedi.codcia
        AND PEDIDO.coddiv = Faccpedi.coddiv
        AND PEDIDO.coddoc = Faccpedi.codref
        AND PEDIDO.nroped = Faccpedi.nroref
        NO-LOCK.
    FIND COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
        AND COTIZACION.coddiv = PEDIDO.coddiv
        AND COTIZACION.coddoc = PEDIDO.codref
        AND COTIZACION.nroped = PEDIDO.nroref
        NO-LOCK.
    IF COTIZACION.TpoPed = "LF" THEN DO:      /* LISTA EXPRESS */
        /* SE VA A CARGAR EL EXCEL ORIGINAL COMPLETO */
        FIND EXPRESS WHERE EXPRESS.codcia = COTIZACION.codcia
            AND EXPRESS.coddiv = COTIZACION.coddiv
            AND EXPRESS.coddoc = "CLE"
            AND EXPRESS.nroped = COTIZACION.nroped
            NO-LOCK.
        /* EL TCK SE GENERA POR EL EXCEL ORIGINAL */
        EMPTY TEMP-TABLE PEDI.
        FOR EACH Facdpedi OF EXPRESS NO-LOCK:
            CREATE PEDI.
            BUFFER-COPY Facdpedi
                TO PEDI
                ASSIGN
                    PEDI.AlmDes = Faccpedi.codalm
                    PEDI.coddoc = Faccpedi.coddoc
                    PEDI.nroped = Faccpedi.nroped
                    PEDI.canate = Facdpedi.canped.  /* OJO */
        END.
        /* Actualizamos los códigos que han sido cambiados en la cotizacion */
        FOR EACH Facdpedi OF COTIZACION NO-LOCK WHERE Facdpedi.codmat <> Facdpedi.codmatweb:
            FIND PEDI WHERE PEDI.codmatweb = Facdpedi.codmatweb
                AND PEDI.libre_c05 = Facdpedi.libre_c05.
            BUFFER-COPY Facdpedi 
                TO PEDI
                ASSIGN
                    PEDI.AlmDes = Faccpedi.codalm
                    PEDI.coddoc = Faccpedi.coddoc
                    PEDI.nroped = Faccpedi.nroped
                    PEDI.canate = Facdpedi.canped.  /* OJO */
        END.
    END.
    /* Consolidamos código repetidos */
    EMPTY TEMP-TABLE PEDI-2.
    EMPTY TEMP-TABLE ITEM.      /* Aqui vamos a guardar el ORIGINAL */
    FOR EACH PEDI BY PEDI.codmat:
        CREATE ITEM.
        BUFFER-COPY PEDI TO ITEM.
        FIND PEDI-2 WHERE PEDI-2.codmat = PEDI.codmat NO-ERROR.
        IF NOT AVAILABLE PEDI-2 THEN DO:
            CREATE PEDI-2.
            BUFFER-COPY PEDI TO PEDI-2.
        END.
        ELSE DO:
            /* Acumulamos */
            ASSIGN
                PEDI-2.CanPed = PEDI-2.CanPed + PEDI.CanPed
                PEDI-2.CanAte = PEDI-2.CanAte + PEDI.CanAte.
        END.
    END.
    EMPTY TEMP-TABLE PEDI.
    FOR EACH PEDI-2:
        CREATE PEDI.
        BUFFER-COPY PEDI-2 TO PEDI.
    END.
    /* ********************************************************** */
    /* Cargamos informacion de Zonas y Ubicaciones */
    FOR EACH PEDI:
        ASSIGN
            PEDI.Libre_c04 = "G-0"
            PEDI.Libre_c05 = "G-0".
        FIND FIRST Almmmate WHERE Almmmate.CodCia = s-CodCia
            AND Almmmate.CodAlm = PEDI.AlmDes
            AND Almmmate.CodMat = PEDI.CodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN DO:
            ASSIGN 
                PEDI.Libre_c04 = Almmmate.CodUbi.
            FIND Almtubic WHERE Almtubic.codcia = s-codcia
                AND Almtubic.codubi = Almmmate.codubi
                AND Almtubic.codalm = Almmmate.codalm
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtubic THEN PEDI.Libre_c05 = Almtubic.CodZona.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

