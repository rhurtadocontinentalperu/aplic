&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME bgDialog
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER ANTICIPOS FOR CcbCDocu.
DEFINE BUFFER B-ADocu FOR CcbADocu.
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE BUFFER EXPRESS FOR FacCPedi.
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE SHARED TEMP-TABLE PEDI LIKE FacDPedi.
DEFINE TEMP-TABLE PEDI-2 NO-UNDO LIKE FacDPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE TEMP-TABLE T-CcbADocu NO-UNDO LIKE CcbADocu.
DEFINE TEMP-TABLE T-CDOCU LIKE CcbCDocu.
DEFINE TEMP-TABLE T-DDOCU LIKE CcbDDocu.
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS bgDialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
  
  Cambios en la versión para Lista Express:
  * Canal de Pago es un código de cliente
  * Generación de DCO en base a ese código de cliente
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
DEFINE INPUT PARAMETER pOrigen AS CHAR.
/* pOrigen
    MOSTRADOR: Solo emisión de Factura
      CREDITO: Factura y Guias de Remisión
    */
DEFINE INPUT PARAMETER pCodTer AS CHAR.

DEFINE SHARED VARIABLE s-CodCia AS INTEGER.
DEFINE SHARED VARIABLE s-NomCia AS CHARACTER.
DEFINE SHARED VARIABLE s-CodDiv AS CHARACTER.
DEFINE SHARED VARIABLE s-User-Id AS CHARACTER.
DEFINE SHARED VARIABLE cl-codcia AS INTEGER.
DEFINE SHARED VARIABLE pv-codcia AS INTEGER.

DEFINE VARIABLE cCodDoc AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodAlm AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodMov AS INTEGER NO-UNDO.
DEFINE VARIABLE iCountGuide AS INTEGER NO-UNDO.
DEFINE VARIABLE cObser  AS CHARACTER   NO-UNDO.

/*DEF VAR x-Articulo-ICBPer AS CHAR INIT '099268'.*/

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
ASSIGN
    cCodAlm = FacCPedi.Codalm       /* <<< OJO <<< */
    cObser  = FacCPedi.Glosa
    cCodDoc = FacCPedi.Cmpbnte.     /* <<< OJO <<< */
/* Consistencia del tipo de guia */
CASE TRUE:
    WHEN pTipoGuia = "FM" THEN ASSIGN cCodDoc = "FAI" pTipoGuia = "M".
    WHEN pTipoGuia = "FA" THEN ASSIGN cCodDoc = "FAI" pTipoGuia = "A".
END CASE.
IF LOOKUP(cCodDoc, 'FAC,BOL,FAI') = 0 THEN RETURN.  /* 14Set2016 incluir FAI */

FIND FacDocum WHERE FacDocum.CodCia = s-CodCia 
    AND FacDocum.CodDoc = cCodDoc 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum OR FacDocum.CodMov = 0 THEN DO:
    MESSAGE
        "Codigo de Documento " cCodDoc " no existe en la maestra FACDOCUM" SKIP
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
    FacCorre.ID_Pos = pOrigen AND
    FacCorre.FlgEst = YES:
    IF pOrigen = "CREDITO" THEN DO:
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
    ELSE cOk = YES.
END.
IF cOk = NO THEN DO:
    MESSAGE
        "Código de Documento " cCodDoc " no configurado " SKIP
        "division " s-CodDiv SKIP 
        "Origen(MOSTRADOR/CREDITO) " pOrigen
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
IF pOrigen = "CREDITO" THEN DO:
    FIND FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia 
        AND FacCorre.CodDiv = s-CodDiv 
        AND FacCorre.CodDoc = "G/R"
        AND FacCorre.FlgEst = YES
        /*AND NOT (FacCorre.Tipmov = "S" AND FacCorre.Codmov <> 00)*/
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCorre THEN DO:
        MESSAGE "Correlativo del Documento G/R NO configurado" VIEW-AS ALERT-BOX WARNING.
        pOrigen = "MOSTRADOR".  /* Artificio para NO generar Guias de Remisión */
        /*RETURN ERROR.*/
    END.
END.

DEFINE TEMP-TABLE Reporte NO-UNDO
    FIELD CodCia LIKE CcbCDocu.CodCia
    FIELD CodDiv LIKE CcbCDOcu.CodDiv 
    FIELD CodDoc LIKE CcbCDocu.CodDoc
    FIELD NroDoc LIKE CcbCDocu.Nrodoc
    INDEX Llave01 codcia coddiv coddoc nrodoc.

DEF BUFFER B-CDOCU FOR Ccbcdocu.
DEF BUFFER B-DDOCU FOR Ccbddocu.
DEF BUFFER b-faccpedi FOR faccpedi.
DEF BUFFER c-faccpedi FOR faccpedi.

DEF VAR s-FechaI AS DATETIME NO-UNDO.
DEF VAR s-FechaT AS DATETIME NO-UNDO.

s-FechaI = DATETIME(TODAY, MTIME).

/* Ic - 28Ene2016, Para factura ValesUtilex */
DEFINE VAR pEsValesUtilex AS LOG INIT NO.

/* Ic - 01Mar2016, para ListaExpress */
DEF NEW SHARED VAR s-codcja AS CHAR INITIAL "I/C".
DEF NEW SHARED VAR s-sercja AS INT.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-FormatoFAC  AS CHAR INIT '999-99999999' NO-UNDO.
DEF VAR x-FormatoGUIA AS CHAR INIT '999-999999' NO-UNDO.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
RUN sunat\p-formato-doc (INPUT cCodDoc, OUTPUT x-FormatoFAC).
RUN sunat\p-formato-doc (INPUT "G/R", OUTPUT x-FormatoGUIA).

DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR pMensaje-2 AS CHAR NO-UNDO.

/* Ic - 01Feb2017, es serie comprobante DIFERIDO */
DEFINE VAR pEsSerieDiferido AS LOG INIT NO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME bgDialog
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


/* Definitions for DIALOG-BOX bgDialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-bgDialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 FILL-IN-tipo COMBO-NroSer Btn_OK ~
Btn_Cancel RECT-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-tipo COMBO-BOX-Guias ~
COMBO-NroSer-Guia FILL-IN-NroPed FILL-IN-Cliente FILL-IN-DirClie ~
COMBO-NroSer FILL-IN-NroDoc FILL-IN-items FILL-IN-Glosa FILL-IN-LugEnt ~
FILL-IN-NroDoc-GR 

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
     SIZE 7 BY 1 NO-UNDO.

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
     SIZE 13 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc-GR AS CHARACTER FORMAT "XXX-XXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroPed AS CHARACTER FORMAT "X(9)":U 
     LABEL "O/D" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-tipo AS CHARACTER FORMAT "X(25)":U 
      VIEW-AS TEXT 
     SIZE 28.43 BY .88
     FGCOLOR 12 FONT 9 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 5.92
     BGCOLOR 15 FGCOLOR 0 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      PEDI, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 bgDialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      PEDI.codmat COLUMN-LABEL "Producto" FORMAT "X(6)":U
      (IF PEDI.Libre_c05 <> '' AND PEDI.Libre_c05 <> "OF" THEN PEDI.Libre_c05 + ' - ' ELSE '') + Almmmatg.desmat @ Almmmatg.desmat COLUMN-LABEL "Descripción" FORMAT "x(60)":U
            WIDTH 45.72
      PEDI.canate FORMAT ">,>>>,>>9.9999":U
      PEDI.UndVta COLUMN-LABEL "Unidad" FORMAT "x(6)":U
      PEDI.AlmDes COLUMN-LABEL "Almacén" FORMAT "x(3)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 80 BY 13.19
         FONT 4 ROW-HEIGHT-CHARS .46 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME bgDialog
     BROWSE-2 AT ROW 7.46 COL 2 WIDGET-ID 200
     FILL-IN-tipo AT ROW 3.27 COL 50.86 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     BUTTON-4 AT ROW 5.04 COL 83 WIDGET-ID 40
     COMBO-BOX-Guias AT ROW 4.23 COL 64.29 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     COMBO-NroSer-Guia AT ROW 4.27 COL 10 COLON-ALIGNED WIDGET-ID 32
     FILL-IN-NroPed AT ROW 1.58 COL 10 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-Cliente AT ROW 1.58 COL 27 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-DirClie AT ROW 2.35 COL 27 COLON-ALIGNED WIDGET-ID 24
     COMBO-NroSer AT ROW 3.46 COL 4.43 WIDGET-ID 2
     FILL-IN-NroDoc AT ROW 3.46 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     FILL-IN-items AT ROW 3.46 COL 42.29 COLON-ALIGNED WIDGET-ID 18
     Btn_OK AT ROW 1.81 COL 83
     Btn_Cancel AT ROW 3.42 COL 83
     FILL-IN-Glosa AT ROW 6.12 COL 11 COLON-ALIGNED WIDGET-ID 28
     FILL-IN-LugEnt AT ROW 5.31 COL 11 COLON-ALIGNED WIDGET-ID 30
     FILL-IN-NroDoc-GR AT ROW 4.27 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     "<<=== Generamos Guía de Remisión?:" VIEW-AS TEXT
          SIZE 32 BY .77 AT ROW 4.27 COL 33.72 WIDGET-ID 38
          BGCOLOR 12 FGCOLOR 15 FONT 6
     RECT-1 AT ROW 1.27 COL 2 WIDGET-ID 4
     SPACE(13.85) SKIP(13.99)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "COMPROBANTES POR ORDEN DE DESPACHO - GUIA DE REMISION ~"CLASICA~"" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: ANTICIPOS B "?" ? INTEGRAL CcbCDocu
      TABLE: B-ADocu B "?" ? INTEGRAL CcbADocu
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: EXPRESS B "?" ? INTEGRAL FacCPedi
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
      TABLE: PEDI T "SHARED" ? INTEGRAL FacDPedi
      TABLE: PEDI-2 T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: T-CcbADocu T "?" NO-UNDO INTEGRAL CcbADocu
      TABLE: T-CDOCU T "?" ? INTEGRAL CcbCDocu
      TABLE: T-DDOCU T "?" ? INTEGRAL CcbDDocu
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB bgDialog 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX bgDialog
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-2 1 bgDialog */
ASSIGN 
       FRAME bgDialog:SCROLLABLE       = FALSE
       FRAME bgDialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-4 IN FRAME bgDialog
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-4:HIDDEN IN FRAME bgDialog           = TRUE.

/* SETTINGS FOR COMBO-BOX COMBO-BOX-Guias IN FRAME bgDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-NroSer IN FRAME bgDialog
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX COMBO-NroSer-Guia IN FRAME bgDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Cliente IN FRAME bgDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DirClie IN FRAME bgDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Glosa IN FRAME bgDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-items IN FRAME bgDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-LugEnt IN FRAME bgDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc IN FRAME bgDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc-GR IN FRAME bgDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroPed IN FRAME bgDialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX bgDialog
/* Query rebuild information for DIALOG-BOX bgDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX bgDialog */
&ANALYZE-RESUME

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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME bgDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bgDialog bgDialog
ON WINDOW-CLOSE OF FRAME bgDialog /* COMPROBANTES POR ORDEN DE DESPACHO - GUIA DE REMISION "CLASICA" */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK bgDialog
ON CHOOSE OF Btn_OK IN FRAME bgDialog /* Aceptar */
DO:

    DEFINE VARIABLE iCount AS INTEGER NO-UNDO.

    FOR EACH FacDPedi OF FacCPedi NO-LOCK:
        iCount = iCount + 1.
    END.
    IF iCount = 0 THEN DO:
        MESSAGE "No hay items por despachar"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    ASSIGN combo-box-guias.

    /* Empresas NO requiere G/R */
    IF pOrigen = "CREDITO" THEN DO:
       IF FacCPedi.CodCli = "20100047218" THEN 

           IF cCodDoc <> "FAI" THEN DO:
               MESSAGE "Para el BCP solo se emiten FAI, consulte con COMERCIAL"
                   VIEW-AS ALERT-BOX ERROR.
               RETURN NO-APPLY.
           END.

          DEFINE VAR hProc AS HANDLE NO-UNDO.           /* Handle Libreria */
          DEFINE VAR x-DeliveryGroup AS CHAR.
          DEFINE VAR x-InvoiCustomerGroup AS CHAR.

          RUN logis\logis-librerias.r PERSISTENT SET hProc.

          /* Procedimientos */
          RUN Grupo-reparto IN hProc (INPUT Faccpedi.codref, INPUT Faccpedi.nroref, /* PED */
                                      OUTPUT x-DeliveryGroup, OUTPUT x-InvoiCustomerGroup).     

          DELETE PROCEDURE hProc.

          IF x-DeliveryGroup = "" THEN DO:
              /* Sin Grupo de Reparto */
              IF cCodDoc = "FAI" AND combo-box-guias = 'NO' THEN DO:
                  MESSAGE "La O/D pertence a pedido EXTRAORDINARIO, obligatorio generar G/R"
                      VIEW-AS ALERT-BOX ERROR.
                  RETURN NO-APPLY.
              END.
          END.
          ELSE DO:
              /* Con Grupo de Reparto */
              IF cCodDoc = "FAI" AND combo-box-guias = 'SI' THEN DO:
                  MESSAGE "La O/D pertence a pedido PLANIFICADO, la FAI debe generarse sin G/R"
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
        FILL-IN-items
        COMBO-NroSer-Guia
        FILL-IN-LugEnt
        FILL-IN-Glosa
        COMBO-BOX-Guias.

    /* UN SOLO PROCESO */
    RUN MASTER-TRANSACTION.
    IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 bgDialog
ON CHOOSE OF BUTTON-4 IN FRAME bgDialog /* Button 4 */
DO:
  IF Faccpedi.DT = YES THEN DO:
      MESSAGE 'La Orden es para DEJAR EN TIENDA' SKIP
          'Acceso Denegado' VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.
  RUN logis/d-transportista (INPUT-OUTPUT TABLE T-CcbADocu,
                             Faccpedi.codcia,
                             Faccpedi.coddiv,
                             Faccpedi.coddoc,
                             Faccpedi.nroped
                             ).
  FIND FIRST T-CcbADocu NO-LOCK NO-ERROR.
  IF AVAILABLE T-CcbADocu THEN DO:
      FILL-IN-LugEnt = T-CcbADocu.Libre_C[12].
      FILL-IN-Glosa = T-CcbADocu.Libre_C[16].
  END.
  ELSE DO:
      FILL-IN-Glosa = FacCPedi.Glosa.
      FILL-IN-LugEnt = FacCPedi.LugEnt.
  END.
  DISPLAY FILL-IN-LugEnt FILL-IN-Glosa WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Guias
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Guias bgDialog
ON VALUE-CHANGED OF COMBO-BOX-Guias IN FRAME bgDialog
DO:
  ASSIGN {&self-name}.
  IF {&SELF-name} = "SI" THEN COMBO-NroSer-Guia:SENSITIVE = YES.
  ELSE COMBO-NroSer-Guia:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer bgDialog
ON RETURN OF COMBO-NroSer IN FRAME bgDialog /* Serie FAC */
DO:
    APPLY 'Tab':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer bgDialog
ON VALUE-CHANGED OF COMBO-NroSer IN FRAME bgDialog /* Serie FAC */
DO:
    /* Correlativo */
    FIND FacCorre WHERE
        FacCorre.CodCia = s-CodCia AND
        FacCorre.CodDoc = cCodDoc AND
        FacCorre.CodDiv = s-CodDiv AND
        FacCorre.NroSer = INTEGER(SELF:SCREEN-VALUE)
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacCorre THEN
        FILL-IN-NroDoc = STRING(FacCorre.NroSer,ENTRY(1,x-FormatoFAC,'-')) + 
        STRING(FacCorre.Correlativo,ENTRY(2,x-FormatoFAC,'-')).
    ELSE FILL-IN-NroDoc = "".
    RUN sunat\p-nro-items (cCodDoc, INTEGER(SELF:SCREEN-VALUE), OUTPUT FILL-IN-items).
    
    DISPLAY FILL-IN-NroDoc FILL-IN-items WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-NroSer-Guia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer-Guia bgDialog
ON VALUE-CHANGED OF COMBO-NroSer-Guia IN FRAME bgDialog /* Serie G/R */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK bgDialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

{logis/d-genera-comprobantes-sunat-gre.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects bgDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Inicial bgDialog 
PROCEDURE Carga-Inicial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE ITEM.

  IF pTipoGuia = "A" THEN DO:
      FOR EACH facdpedi OF faccpedi NO-LOCK WHERE (facdpedi.canped - facdpedi.canate) > 0 BY Facdpedi.NroItm:
          CREATE ITEM.
          BUFFER-COPY facdpedi TO ITEM
              ASSIGN
                ITEM.canped = facdpedi.canped - facdpedi.canate
                ITEM.canate = facdpedi.canped - facdpedi.canate.
      END.
  END.
  ELSE DO:
      FOR EACH PEDI WHERE PEDI.CanAte > 0:
          CREATE ITEM.
          BUFFER-COPY PEDI TO ITEM.
      END.
  END.
  /* Solo para el pintado inicial de la pantalla */
  EMPTY TEMP-TABLE PEDI.
  FOR EACH ITEM:
      CREATE PEDI.
      BUFFER-COPY ITEM TO PEDI.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierra-Pedido bgDialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Devolucion-Mercaderia bgDialog 
PROCEDURE Devolucion-Mercaderia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT (COTIZACION.TpoPed = "LF") THEN RETURN 'OK'.
DEF VAR lDiferente AS LOG INIT NO NO-UNDO.
DEF VAR i AS INT NO-UNDO.

pMensaje = "".

DEF VAR s-coddoc AS CHAR INIT 'N/C' NO-UNDO.
DEF VAR s-nroser AS INT NO-UNDO.
DEF VAR cListItems AS CHAR NO-UNDO.
/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

DEF BUFFER NCREDITO FOR Ccbcdocu.

{sunat\i-lista-series.i &CodCia=s-CodCia ~
    &CodDiv=s-CodDiv ~
    &CodDoc=s-CodDoc ~
    &FlgEst='' ~          /* En blanco si quieres solo ACTIVOS */
    &Tipo='CREDITO' ~
    &ListaSeries=cListItems ~
    }
ASSIGN s-NroSer = INTEGER(ENTRY(1,cListItems)) NO-ERROR.
IF ERROR-STATUS:ERROR OR s-NroSer <= 0 THEN DO:
    pMensaje = "NO definido el número de serie para la N/C por devolución de mercaderia Lista Express".
    RETURN "ADM-ERROR".
END.

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.

/* La diferencia la sacamos de la cotizacion original */
IF NOT CAN-FIND(FIRST B-DPEDI OF COTIZACION WHERE B-DPEDI.CanPed > B-DPEDI.CanAte NO-LOCK) THEN RETURN 'OK'.
FIND FIRST T-CDOCU NO-LOCK.
FIND Ccbcdocu OF T-CDOCU NO-LOCK.
RLOOP:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    /* Correlativo */
    {lib\lock-genericov3.i &Tabla="FacCorre" ~
        &Condicion="FacCorre.CodCia = s-CodCia ~
        AND FacCorre.CodDiv = s-CodDiv ~
        AND FacCorre.CodDoc = s-CodDoc ~
        AND FacCorre.NroSer = s-NroSer" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &tMensaje="pMensaje" ~
        &TipoError="UNDO RLOOP, RETURn 'ADM-ERROR'" ~
        }
    CREATE NCREDITO.
    BUFFER-COPY Ccbcdocu
        EXCEPT Ccbcdocu.CodRef Ccbcdocu.NroRef Ccbcdocu.Glosa Ccbcdocu.NroOrd Ccbcdocu.CodAnt
        TO NCREDITO
        ASSIGN 
        NCREDITO.CodCia = S-CODCIA
        NCREDITO.CodDiv = S-CODDIV
        NCREDITO.CodDoc = S-CODDOC
        NCREDITO.NroDoc = STRING(FacCorre.NroSer, ENTRY(1, x-Formato, '-')) +
                          STRING(FacCorre.Correlativo, ENTRY(2, x-Formato, '-'))
        NCREDITO.CodRef = Ccbcdocu.CodDoc
        NCREDITO.NroRef = Ccbcdocu.NroDoc
        NCREDITO.FchDoc = TODAY
        NCREDITO.FchVto = ADD-INTERVAL (TODAY, 1, 'years')
        NCREDITO.FlgEst = "P"
        NCREDITO.TpoCmb = FacCfgGn.TpoCmb[1]
        NCREDITO.CndCre = 'D'
        NCREDITO.TpoFac = ""
        NCREDITO.Tipo   = "CREDITO"
        NCREDITO.CodCaja= ""
        NCREDITO.usuario = S-USER-ID
        NCREDITO.SdoAct = B-CDOCU.ImpTot
        NCREDITO.ImpTot2 = 0
        NCREDITO.ImpDto2 = 0
        NCREDITO.CodMov = 09      /* INGRESO POR DEVOLUCION DEL CLIENTE */
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, LEAVE.
    IF NCREDITO.RucCli = '' THEN NCREDITO.RucCli = '12345678901'.
    IF NCREDITO.CodAnt = '' THEN NCREDITO.CodAnt = '12345678'.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
    FIND GN-VEN WHERE gn-ven.codcia = s-codcia
        AND gn-ven.codven = Ccbcdocu.codven
        NO-LOCK NO-ERROR.
    IF AVAILABLE GN-VEN THEN NCREDITO.cco = gn-ven.cco.
    /* Detalle */
    i = 1.
    FOR EACH B-DPEDI OF COTIZACION NO-LOCK WHERE B-DPEDI.CanPed > B-DPEDI.CanAte BY B-DPEDI.NroItm:
        CREATE CcbDDocu.
        ASSIGN 
            CcbDDocu.NroItm = i
            CcbDDocu.CodCia = NCREDITO.CodCia 
            CcbDDocu.Coddiv = NCREDITO.Coddiv 
            CcbDDocu.CodDoc = NCREDITO.CodDoc 
            CcbDDocu.NroDoc = NCREDITO.NroDoc
            CcbDDocu.CodMat = B-DPEDI.codmat 
            CcbDDocu.PreUni = B-DPEDI.PreUni 
            CcbDDocu.CanDes = B-DPEDI.CanPed - B-DPEDI.CanAte 
            CcbDDocu.Factor = B-DPEDI.Factor 
            CcbDDocu.ImpIsc = B-DPEDI.ImpIsc
            CcbDDocu.ImpIgv = B-DPEDI.ImpIgv 
            CcbDDocu.ImpLin = B-DPEDI.ImpLin
            CcbDDocu.AftIgv = B-DPEDI.AftIgv
            CcbDDocu.AftIsc = B-DPEDI.AftIsc
            CcbDDocu.UndVta = B-DPEDI.UndVta.
        ASSIGN
            CcbDDocu.ImpDto2 = B-DPEDI.ImpDto2 * (CcbDDocu.CanDes / B-DPEDI.CanPed).
        ASSIGN 
            CcbDDocu.ImpLin = ROUND( CcbDDocu.PreUni * CcbDDocu.CanDes , 2 ).
        IF CcbDDocu.AftIgv THEN CcbDDocu.ImpIgv = CcbDDocu.ImpLin - ROUND(CcbDDocu.ImpLin  / (1 + (Ccbcdocu.PorIgv / 100)),4).
        i = i + 1.
    END.
    /* TOTALES */
    DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
    DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
    ASSIGN
        NCREDITO.ImpDto = 0
        NCREDITO.ImpIgv = 0
        NCREDITO.ImpIsc = 0
        NCREDITO.ImpTot = 0
        NCREDITO.ImpExo = 0.
    FOR EACH Ccbddocu OF NCREDITO NO-LOCK:        
        F-Igv = F-Igv + Ccbddocu.ImpIgv.
        F-Isc = F-Isc + Ccbddocu.ImpIsc.
        NCREDITO.ImpTot = NCREDITO.ImpTot + Ccbddocu.ImpLin.
        IF NOT Ccbddocu.AftIgv THEN NCREDITO.ImpExo = NCREDITO.ImpExo + Ccbddocu.ImpLin.
        IF Ccbddocu.AftIgv = YES
            THEN NCREDITO.ImpDto = NCREDITO.ImpDto + ROUND(Ccbddocu.ImpDto / (1 + NCREDITO.PorIgv / 100), 2).
        ELSE NCREDITO.ImpDto = NCREDITO.ImpDto + Ccbddocu.ImpDto.
    END.
    ASSIGN
        NCREDITO.ImpIgv = ROUND(F-IGV,2)
        NCREDITO.ImpIsc = ROUND(F-ISC,2)
        NCREDITO.ImpVta = NCREDITO.ImpTot - NCREDITO.ImpExo - NCREDITO.ImpIgv.
    /* RHC 22.12.06 */
    IF NCREDITO.PorDto > 0 THEN DO:
        NCREDITO.ImpDto = NCREDITO.ImpDto + ROUND((NCREDITO.ImpVta + NCREDITO.ImpExo) * NCREDITO.PorDto / 100, 2).
        NCREDITO.ImpTot = ROUND(NCREDITO.ImpTot * (1 - NCREDITO.PorDto / 100),2).
        NCREDITO.ImpVta = ROUND(NCREDITO.ImpVta * (1 - NCREDITO.PorDto / 100),2).
        NCREDITO.ImpExo = ROUND(NCREDITO.ImpExo * (1 - NCREDITO.PorDto / 100),2).
        NCREDITO.ImpIgv = NCREDITO.ImpTot - NCREDITO.ImpExo - NCREDITO.ImpVta.
    END.
    ASSIGN
        NCREDITO.ImpBrt = NCREDITO.ImpVta /*+ Ccbcdocu.ImpIsc*/ + NCREDITO.ImpDto /*+ Ccbcdocu.ImpExo*/
        NCREDITO.SdoAct  = NCREDITO.ImpTot.
    /* ************************************************************************** */
    RUN vta2/ing-devo-utilex (ROWID(NCREDITO)).
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO RLOOP, LEAVE.
    /* ************************************************************************** */
    /* Control de Comprobantes                                                    */
    /* ************************************************************************** */
    CREATE Reporte.
    BUFFER-COPY NCREDITO TO Reporte.    /* OJO: Control de Comprobantes Generados */
    /* ************************************************************************** */
END.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(NCREDITO) THEN RELEASE NCREDITO.
IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI bgDialog  _DEFAULT-DISABLE
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
  HIDE FRAME bgDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI bgDialog  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-tipo COMBO-BOX-Guias COMBO-NroSer-Guia FILL-IN-NroPed 
          FILL-IN-Cliente FILL-IN-DirClie COMBO-NroSer FILL-IN-NroDoc 
          FILL-IN-items FILL-IN-Glosa FILL-IN-LugEnt FILL-IN-NroDoc-GR 
      WITH FRAME bgDialog.
  ENABLE BROWSE-2 FILL-IN-tipo COMBO-NroSer Btn_OK Btn_Cancel RECT-1 
      WITH FRAME bgDialog.
  VIEW FRAME bgDialog.
  {&OPEN-BROWSERS-IN-QUERY-bgDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Facturas-Adelantadas bgDialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FIRST-TRANSACTION bgDialog 
PROCEDURE FIRST-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* 1ro. Generamos las TEMPORALES PARA FAC/BOL */
    RUN Crea-Comprobantes.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = "NO se pudo crear el Comprobante Temporal".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    
    /* 2do. GRABACION DE LOS COMPROBANTES: ACTUALIZA ALMACENES */
    RUN Graba-Comprobantes.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = "NO se pudo crear el Comprobante".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    
    /* 3ro. PARTE: CANCELACION AUTOMATICA LISTA EXPRESS */
/*     RUN Generacion-Canc-Auto.                                                                          */
/*     IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                                             */
/*         IF pMensaje = "" THEN pMensaje = "NO se pudo generar la Cancelación Automática Lista Express". */
/*         UNDO RLOOP, RETURN 'ADM-ERROR'.                                                                */
/*     END.                                                                                               */
    /* 3ro. Generacion de G/R */
    RUN Generacion-de-GR.
    
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = "NO se pudo generar la G/R".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.

END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato bgDialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-NC bgDialog 
PROCEDURE Genera-NC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pConcepto AS CHAR.
DEF INPUT PARAMETER x-Monto-Aplicar AS DEC.
DEF INPUT PARAMETER pTpoFac AS CHAR.            /* ADELANTO, DESCUENTO */
DEF INPUT PARAMETER x-TpoCmb-Compra AS DEC.
DEF INPUT PARAMETER x-TpoCmb-Venta  AS DEC.
DEF OUTPUT PARAMETER pMensaje AS CHAR.

pMensaje = "".

DEF VAR s-coddoc AS CHAR INIT 'N/C' NO-UNDO.
DEF VAR s-nroser AS INT NO-UNDO.
DEF VAR cListItems AS CHAR NO-UNDO.
DEF VAR x-ImpMn AS DEC NO-UNDO.
DEF VAR x-ImpMe AS DEC NO-UNDO.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

DEF BUFFER NCREDITO FOR Ccbcdocu.

{sunat\i-lista-series.i &CodCia=s-CodCia ~
    &CodDiv=s-CodDiv ~
    &CodDoc=s-CodDoc ~
    &FlgEst='' ~          /* En blanco si quieres solo ACTIVOS */
    &Tipo='CREDITO' ~
    &ListaSeries=cListItems ~
    }

ASSIGN s-NroSer = INTEGER(ENTRY(1,cListItems)) NO-ERROR.
IF ERROR-STATUS:ERROR OR s-NroSer <= 0 THEN DO:
    pMensaje = "NO definido el número de serie para la N/C por aplicación de anticipos".
    RETURN "ADM-ERROR".
END.

RLOOP:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    /* Correlativo */
    {lib\lock-genericov3.i &Tabla="FacCorre" ~
        &Condicion="FacCorre.CodCia = s-CodCia ~
        AND FacCorre.CodDiv = s-CodDiv ~
        AND FacCorre.CodDoc = s-CodDoc ~
        AND FacCorre.NroSer = s-NroSer" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &tMensaje="pMensaje" ~
        &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'" ~
        }
    /* Bloqueamos correlativo */
/*     {lib/lock-genericov2.i ~                     */
/*         &Tabla="FacCorre" ~                      */
/*         &Condicion="FacCorre.CodCia = s-codcia ~ */
/*         AND FacCorre.CodDiv = s-coddiv ~         */
/*         AND FacCorre.CodDoc = s-coddoc ~         */
/*         AND FacCorre.NroSer = s-nroser" ~        */
/*         &Bloqueo="EXCLUSIVE-LOCK" ~              */
/*         &Accion="RETRY" ~                        */
/*         &Mensaje="YES" ~                         */
/*         &TipoError="LEAVE" ~                     */
/*         }                                        */
    /* Copiamos los datos de la FAC a la N/C */
    CREATE NCREDITO.
    BUFFER-COPY Ccbcdocu 
        TO NCREDITO
        ASSIGN
        NCREDITO.codcia = s-codcia
        NCREDITO.coddiv = s-coddiv
        NCREDITO.coddoc = s-CodDoc
        NCREDITO.NroDoc = STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) 
                            + STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')) 
        NCREDITO.FchDoc = TODAY
        NCREDITO.FchVto = ADD-INTERVAL (TODAY, 1, 'years')
        NCREDITO.CndCre = "N"
        NCREDITO.usuario = S-USER-ID
        NCREDITO.FlgEst = "P"                   /* Pendiente */
        NCREDITO.codref = ANTICIPOS.CodRef
        NCREDITO.nroref = ANTICIPOS.NroRef
        NCREDITO.CodPed = ANTICIPOS.CodDoc      /* OJO */
        NCREDITO.NroPed = ANTICIPOS.NroDoc
        NCREDITO.TpoFac = pTpoFac               /* Ej. ADELANTO */
        NCREDITO.Tipo   = "CREDITO"
        NCREDITO.CodCaja= ""
        NCREDITO.CodCta = pConcepto
        NCREDITO.TpoCmb = (IF Ccbcdocu.codmon = 1 THEN x-TpoCmb-Compra ELSE x-TpoCmb-Venta)
        NCREDITO.imptot = x-Monto-Aplicar
        NCREDITO.sdoact = x-Monto-Aplicar
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "NO se pudo generar la N/C por Anticipos" + CHR(10) +
            "Revise el correlativo de la serie " + STRING(s-NroSer, '999').
        UNDO, LEAVE.
    END.
    /* Buscamos la FAC o BOL que generó el A/C */
/*     FOR EACH Ccbdcaja NO-LOCK WHERE CcbDCaja.CodCia = s-codcia */
/*         AND CcbDCaja.CodDoc = ANTICIPOS.CodRef                 */
/*         AND CcbDCaja.NroDoc = ANTICIPOS.NroRef:                */
/*         ASSIGN                                                 */
/*             NCREDITO.codref = CcbDCaja.CodRef                  */
/*             NCREDITO.nroref = CcbDCaja.NroRef.                 */
/*     END.                                                       */
    FIND GN-VEN WHERE GN-VEN.codcia = s-codcia AND GN-VEN.codven = NCREDITO.codven NO-LOCK NO-ERROR.
    IF AVAILABLE GN-VEN THEN NCREDITO.cco = GN-VEN.cco.
    ASSIGN
        Faccorre.correlativo = Faccorre.correlativo + 1.
    /* Detalle: creamos una linea con el concepto */
    CREATE Ccbddocu.
    BUFFER-COPY NCREDITO
        TO Ccbddocu
        ASSIGN
        Ccbddocu.nroitm = 1
        Ccbddocu.codmat = pConcepto
        Ccbddocu.candes = 1
        Ccbddocu.preuni = NCREDITO.imptot
        Ccbddocu.implin = NCREDITO.imptot
        Ccbddocu.factor = 1.
    FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia
        AND CcbTabla.Tabla = s-CodDoc
        AND CcbTabla.Codigo = Ccbddocu.codmat NO-LOCK.
    IF CcbTabla.Afecto THEN
        ASSIGN
            Ccbddocu.AftIgv = Yes
            Ccbddocu.ImpIgv = Ccbddocu.implin * ((NCREDITO.PorIgv / 100) / (1 + (NCREDITO.PorIgv / 100))).
    ELSE
        ASSIGN
            Ccbddocu.AftIgv = No
            Ccbddocu.ImpIgv = 0.
    /* Totales */
    ASSIGN
        NCREDITO.ImpExo = (IF Ccbddocu.AftIgv = No  THEN Ccbddocu.implin ELSE 0)
        NCREDITO.ImpIgv = Ccbddocu.ImpIgv
        NCREDITO.ImpVta = NCREDITO.ImpTot - NCREDITO.ImpIgv
        NCREDITO.ImpBrt = NCREDITO.ImpVta.

    /* ************************************************************************** */
    /* Control de Comprobantes                                                    */
    /* ************************************************************************** */
    CREATE Reporte.
    BUFFER-COPY NCREDITO TO Reporte.    /* OJO: Control de Comprobantes Generados */
    /* ************************************************************************** */
    /* *************************************************** */
    /* SOLO PARA N/C x ANTICIPO ACTUALIZAMOS SALDO DEL A/C */
    /* *************************************************** */
    IF pTpoFac <> "ADELANTO" THEN LEAVE RLOOP.      /* OJO */
    /* *************************************************** */
    /* *************************************************** */
    IF NCREDITO.CodMon = 1
        THEN ASSIGN
                x-ImpMn = NCREDITO.ImpTot
                x-ImpMe = NCREDITO.ImpTot / NCREDITO.TpoCmb.
    ELSE ASSIGN
                x-ImpMn = NCREDITO.ImpTot * NCREDITO.TpoCmb
                x-ImpMe = NCREDITO.ImpTot.
    /* ************************************************************************** */
    /* 1ro Amortizamos el Anticipo                                                */
    /* ************************************************************************** */
    CREATE Ccbdmov.
    ASSIGN
        Ccbdmov.CodCia = s-CodCia
        Ccbdmov.CodDiv = s-CodDiv
        Ccbdmov.CodDoc = ANTICIPOS.CodDoc
        Ccbdmov.NroDoc = ANTICIPOS.NroDoc
        Ccbdmov.CodRef = NCREDITO.CodDoc     /* N/C */
        Ccbdmov.NroRef = NCREDITO.NroDoc
        Ccbdmov.CodMon = ANTICIPOS.CodMon   /* OJO */
        Ccbdmov.CodCli = NCREDITO.CodCli
        Ccbdmov.FchDoc = NCREDITO.FchDoc
        Ccbdmov.HraMov = STRING(TIME,"HH:MM:SS")
        Ccbdmov.TpoCmb = NCREDITO.TpoCmb
        Ccbdmov.usuario = s-User-ID
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = 'NO se pudo amortizar el saldo del A/C'.
        UNDO, LEAVE.
    END.
    IF ANTICIPOS.CodMon = 1 THEN ASSIGN Ccbdmov.ImpTot = x-ImpMn.
    ELSE ASSIGN Ccbdmov.ImpTot = x-ImpMe.
    /* Actualizamo saldo del A/C */
    ASSIGN
        ANTICIPOS.SdoAct = ANTICIPOS.SdoAct - Ccbdmov.imptot.
    IF ANTICIPOS.SdoAct <= 0 THEN
        ASSIGN
            ANTICIPOS.flgest = 'C'
            ANTICIPOS.fchcan = TODAY.
    /* ************************************************************************** */
    /* 2do Amortizamos el Comprobante                                             */
    /* ************************************************************************** */
    CREATE Ccbdcaja.
    ASSIGN
        CcbDCaja.CodCia = s-codcia
        CcbDCaja.CodDiv = s-coddiv
        CcbDCaja.CodDoc = NCREDITO.coddoc 
        CcbDCaja.NroDoc = NCREDITO.nrodoc
        CcbDCaja.CodCli = NCREDITO.codcli
        CcbDCaja.CodMon = NCREDITO.codmon
        CcbDCaja.CodRef = Ccbcdocu.coddoc
        CcbDCaja.NroRef = Ccbcdocu.nrodoc
        CcbDCaja.FchDoc = TODAY
        CcbDCaja.ImpTot = NCREDITO.imptot
        CcbDCaja.TpoCmb = NCREDITO.tpocmb.
    ASSIGN
        Ccbcdocu.SdoAct = Ccbcdocu.SdoAct - NCREDITO.imptot.
    IF Ccbcdocu.SdoAct <= 0 THEN
        ASSIGN
            Ccbcdocu.FlgEst = "C"
            Ccbcdocu.FchCan = TODAY.
    /* ************************************************************************** */
    /* 3ro Amortizamos la N/C                                                     */
    /* ************************************************************************** */
    CREATE Ccbdmov.
    ASSIGN
        Ccbdmov.CodCia = s-CodCia
        Ccbdmov.CodDiv = s-CodDiv
        Ccbdmov.CodDoc = NCREDITO.CodDoc     /* N/C */
        Ccbdmov.NroDoc = NCREDITO.NroDoc
        Ccbdmov.CodRef = Ccbcdocu.CodDoc
        Ccbdmov.NroRef = Ccbcdocu.NroDoc
        Ccbdmov.CodMon = NCREDITO.CodMon
        Ccbdmov.CodCli = NCREDITO.CodCli
        Ccbdmov.FchDoc = NCREDITO.FchDoc
        Ccbdmov.HraMov = STRING(TIME,"HH:MM:SS")
        Ccbdmov.ImpTot = NCREDITO.ImpTot
        Ccbdmov.TpoCmb = NCREDITO.TpoCmb
        Ccbdmov.usuario = s-User-ID
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = 'NO se pudo amortizar el saldo de la N/C'.
        UNDO, LEAVE.
    END.
    ASSIGN
        NCREDITO.SdoAct = 0
        NCREDITO.FlgEst = "C"
        NCREDITO.FchCan = TODAY.
END.
IF AVAILABLE(NCREDITO) THEN RELEASE NCREDITO.
IF AVAILABLE(Ccbdmov)  THEN RELEASE Ccbdmov.
IF AVAILABLE(Faccorre) THEN RELEASE Faccorre.
IF AVAILABLE(Ccbdcaja) THEN RELEASE Ccbdcaja.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Temp-FeLogErrores bgDialog 
PROCEDURE Graba-Temp-FeLogErrores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH T-FeLogErrores:
    CREATE FeLogErrores.
    BUFFER-COPY T-FeLogErrores TO FeLogErrores NO-ERROR.
    DELETE T-FeLogErrores.
END.
IF AVAILABLE(FeLogErrores) THEN RELEASE FeLogErrores.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir bgDialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable bgDialog 
PROCEDURE local-enable :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      CASE pOrigen:
          WHEN "CREDITO" THEN DO:
              ASSIGN
                  COMBO-NroSer-Guia:SENSITIVE = YES
                  BUTTON-4:SENSITIVE = YES
                  COMBO-BOX-Guias:SENSITIVE = YES.
          END.
      END CASE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize bgDialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO.
  DEFINE VAR lxCotizacion AS CHAR.

  /* Si es una venta MANUAL la tabla PEDI ya viene pre-cargada */
  RUN Carga-Inicial.   /* Carga la tabla ITEM */

  FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
  DO WITH FRAME {&FRAME-NAME}:
      /* CORRELATIVO DE FAC y BOL */
      /* Por defecto supone que es un Centro de Distribución */
      {sunat\i-lista-series.i &CodCia=s-CodCia ~
          &CodDiv=s-CodDiv ~
          &CodDoc=cCodDoc ~
          &FlgEst='' ~
          &Tipo='CREDITO' ~
          &ListaSeries=cListItems }
          
      ASSIGN
          COMBO-NroSer:LIST-ITEMS = cListItems
          COMBO-NroSer = ENTRY(1,COMBO-NroSer:LIST-ITEMS)
          FILL-IN-items = FacCfgGn.Items_Guias
          FILL-IN-NroPed = FacCPedi.NroPed
          FILL-IN-Glosa = FacCPedi.Glosa
          FILL-IN-LugEnt = FacCPedi.LugEnt
          FILL-IN-Cliente = FacCPedi.CodCli + " - " + FacCPedi.NomCli
          FILL-IN-DirClie = FacCPedi.DirCli.
      /* Rutina Lugar de Entrega */
      RUN logis/p-lugar-de-entrega (INPUT Faccpedi.CodDoc,
                                    INPUT Faccpedi.NroPed,
                                    OUTPUT FILL-IN-LugEnt).
      IF NUM-ENTRIES(FILL-IN-LugEnt, '|') > 1 THEN FILL-IN-LugEnt = ENTRY(2, FILL-IN-LugEnt, '|').
      /* *********************** */
      CASE cCodDoc:
          WHEN "FAC" THEN ASSIGN FILL-IN-items = FacCfgGn.Items_Factura COMBO-NroSer:LABEL = 'SERIE DE FACTURA'.
          WHEN "BOL" THEN ASSIGN FILL-IN-items = FacCfgGn.Items_Boleta  COMBO-NroSer:LABEL = 'SERIE DE BOLETAS'.
          WHEN "FAI" THEN ASSIGN FILL-IN-items = FacCfgGn.Items_Boleta  COMBO-NroSer:LABEL = 'SERIE DE FAIs'.
      END CASE.
      RUN sunat\p-nro-items (cCodDoc, INTEGER(COMBO-NroSer), OUTPUT FILL-IN-items).
      RUN sunat\p-formato-doc (INPUT cCodDoc, OUTPUT x-FormatoFAC).
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
          FILL-IN-NroDoc =
              STRING(FacCorre.NroSer,ENTRY(1,x-FormatoFAC,'-')) +
              STRING(FacCorre.Correlativo,ENTRY(2,x-FormatoFAC,'-')).

      /* CORRELATIVO DE GUIAS DE REMISION */
      ASSIGN
          COMBO-NroSer-Guia:FORMAT = TRIM(ENTRY(1,x-FormatoGUIA,'-'))
          FILL-IN-NroDoc-GR:FORMAT = x-FormatoGUIA.

      DEF VAR pSeries AS CHAR NO-UNDO.
      /* 4/12/23 */
      DEFINE VAR hProc AS HANDLE NO-UNDO.
      RUN alm/almacen-library.p PERSISTENT SET hProc.
      RUN GR_Lista_de_Series IN hProc (INPUT s-CodDiv,
                                       INPUT "",
                                       INPUT "VENTAS",
                                       INPUT TRUE,
                                       INPUT "CLASICA",
                                       OUTPUT pSeries).
      DELETE PROCEDURE hProc.
      /* 21/03/2022 Carga Series */
/*       RUN gn/p-series-solo-gr (INPUT s-CodDiv,                     */
/*                                INPUT "VENTAS",                     */
/*                                INPUT YES,       /* Solo activos */ */
/*                                OUTPUT pSeries).                    */
      cListItems = pSeries.
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
          FILL-IN-NroDoc-GR =
              STRING(FacCorre.NroSer,ENTRY(1,x-FormatoGUIA,'-')) +
              STRING(FacCorre.Correlativo,ENTRY(2,x-FormatoGUIA,'-')).
      IF TRUE <> (cListItems > "") THEN 
          ASSIGN 
          COMBO-NroSer-Guia:SENSITIVE = NO 
          COMBO-BOX-Guias = "NO"
          COMBO-BOX-Guias:SENSITIVE = NO.

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
          RELEASE T-CcbADocu.
      END.      
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
      IF pOrigen = "MOSTRADOR" THEN COMBO-BOX-Guias:SCREEN-VALUE = "NO".

      /**/
      ASSIGN COMBO-BOX-Guias:SENSITIVE = YES.


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
                  APPLY 'VALUE-CHANGED':U TO COMBO-BOX-Guias.
              END.

              IF c-faccpedi.codcli = '20100047218' THEN DO:
                  /* Verificamos si la Cotizacion tiene grupo de reparto */
                  fill-in-tipo:SCREEN-VALUE = "  EXTRAORDINARIO".
                  IF NOT (TRUE <> (c-faccpedi.DeliveryGroup > "")) THEN DO:
                      fill-in-tipo:SCREEN-VALUE = "  PLANIFICADO (" + c-faccpedi.DeliveryGroup + ")".
                  END.
              END.            
          END.

      END.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MASTER-TRANSACTION bgDialog 
PROCEDURE MASTER-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Ic - 01Feb2017, Macchiu, verifica si la serie es comprobantes DIFERIDOS */
    pEsSerieDiferido = NO.
    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia 
        AND vtatabla.tabla = 'NSERIE_DIFERIDO' 
        AND vtatabla.llave_c1 = COMBO-NroSer NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN DO:
        /* Maximo 7 dias */
        IF MONTH(TODAY - 7) = MONTH(TODAY)  THEN DO:
            MESSAGE "Imposible generar Comprobante con la serie seleccionada " SKIP
                    "esta fuera de fecha" VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
        /* Buscamos la O/D diferida a generar */
        FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                vtatabla.tabla = 'ORDEN_DIFERIDO' AND
                                vtatabla.llave_c1 = faccpedi.coddoc AND
                                vtatabla.llave_c2 = faccpedi.nroped NO-LOCK NO-ERROR.
        IF NOT AVAILABLE vtatabla THEN DO:
            MESSAGE "La serie del comprobante es DIFERIDA" SKIP
                    "Pero la " + faccpedi.coddoc + "  no esta como DIFERIDA...ERROR" VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
        pEsSerieDiferido = YES.
    END.  
    ELSE DO:
        /* Buscamos la O/D diferida a generar */
        FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                vtatabla.tabla = 'ORDEN_DIFERIDO' AND
                                vtatabla.llave_c1 = faccpedi.coddoc AND
                                vtatabla.llave_c2 = faccpedi.nroped NO-LOCK NO-ERROR.
        IF AVAILABLE vtatabla THEN DO:
            MESSAGE "La " + faccpedi.coddoc + " esta inscrita como DIFERIDA no le corresponde esta serie de Comprobante"
                     VIEW-AS ALERT-BOX ERROR.

                MESSAGE 'Desea Continuar con el proceso?' VIEW-AS ALERT-BOX QUESTION
                        BUTTONS YES-NO UPDATE rpta AS LOG.
                IF rpta = NO THEN DO:
                RETURN 'ADM-ERROR'.
            END.            
        END.
    END.
    /* Ic - 01Feb2017, FIN */
    SESSION:SET-WAIT-STATE('GENERAL').
    EMPTY TEMP-TABLE T-FELogErrores.    /* CONTROL DE ERRORES DE FACTURACION ELECTRONICA */
    pMensaje-2 = "DOCUMENTOS GENERADOS:" + CHR(10).

    DEFINE VAR x-veces AS INT.

    x-veces = 0.

    RLOOP:
    REPEAT ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        EMPTY TEMP-TABLE Reporte.           /* Documentos Creados en la transacción */
        pMensaje = "".
        /* FIJAMOS EL PUNTERO DEL BUFFER EN LA O/D */
        {lib\lock-genericov3.i ~
            &Tabla="FacCPedi" ~
            &Condicion="ROWID(FacCPedi) = rwParaRowID" ~
            &Bloqueo="EXCLUSIVE-LOCK" ~
            &Accion="LEAVE" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje"
            &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'" ~
            }
        /* ******************************************************************************************** */
        /* TABLAS RELACIONADAS */
        /* ******************************************************************************************** */
        FIND FIRST PEDIDO WHERE PEDIDO.codcia = Faccpedi.codcia
            AND PEDIDO.coddoc = Faccpedi.codref
            AND PEDIDO.nroped = Faccpedi.nroref
            NO-LOCK.
        FIND FIRST COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
            AND COTIZACION.coddoc = PEDIDO.codref
            AND COTIZACION.nroped = PEDIDO.nroref
            NO-LOCK.
        /* ******************************************************************************************** */
        /* CARGAMOS SALDOS DE LA  O/D */
        /* ******************************************************************************************** */
        RUN Carga-Temporal.
        FIND FIRST PEDI NO-LOCK NO-ERROR.

        IF NOT AVAILABLE PEDI THEN LEAVE.   /* Ya no hay nada que facturar */
        
        /* ZONAS Y UBICACIONES, DESCUENTOS LISTA EXPRESS */
        RUN Resumen-Temporal.
        
        /* ******************************************************************************************** */
        /* FILTRO DE CONTROL */
        /* ******************************************************************************************** */
        IF NOT (FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = "C") THEN DO:
            pMensaje = "Registro de O/D ya no está 'PENDIENTE'".
            UNDO RLOOP, LEAVE.
        END.

        /* ******************************************************************************************** */
        /* 1ra. TRANSACCION: COMPROBANTES */
        /* ******************************************************************************************** */
        RUN FIRST-TRANSACTION.
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR: No se pudo generar el comprobante" .
            UNDO RLOOP, LEAVE.
        END.
        /* ******************************************************************************************** */
        /* 2da. TRANSACCION: E-POS */
        /* ******************************************************************************************** */
        RUN SECOND-TRANSACTION.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, LEAVE.
        /* ******************************************************************************************** */
        /* 3ro. GRABACIONES FINALES:  Cierra la O/D */
        /* ******************************************************************************************** */
        FIND FIRST Facdpedi OF Faccpedi WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0 NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Facdpedi THEN FacCPedi.FlgEst = "C".
        /* RHC 07/02/2017 Lista Express */
        IF COTIZACION.TpoPed = "LF" THEN FacCPedi.FlgEst = "C".
        FOR EACH Reporte NO-LOCK, FIRST Ccbcdocu OF Reporte NO-LOCK:
            pMensaje-2 = pMensaje-2 + Ccbcdocu.coddoc + ' ' + Ccbcdocu.nrodoc + CHR(10).
        END.

        x-veces = x-veces + 1.

    END.
    SESSION:SET-WAIT-STATE('').

    /* liberamos tablas */
    RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */
    FIND CURRENT FacCPedi NO-LOCK.
    IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
    IF AVAILABLE(Ccbcdocu) THEN FIND CURRENT Ccbcdocu NO-LOCK.  /* Para no peder el puntero */
    IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.
    IF AVAILABLE(Ccbadocu) THEN RELEASE Ccbadocu.
    IF AVAILABLE(B-ADOCU)  THEN RELEASE B-ADOCU.
    IF AVAILABLE(w-repor)  THEN RELEASE w-report.
    IF AVAILABLE(Gn-clie)  THEN RELEASE Gn-clie.
    IF AVAILABLE(Ccbccaja) THEN RELEASE Ccbccaja.
    IF pMensaje <> "" THEN DO:
        MESSAGE "Hubo Problemas para generar comprobante" SKIP
            pMensaje VIEW-AS ALERT-BOX ERROR.
        pMensaje = "".
        RETURN 'ADM-ERROR'.
    END.
    pMensaje = pMensaje-2.
    /* 3ro. CONTROL DE FACTURAS ADELANTADAS */
    IF pOrigen = "MOSTRADOR" THEN DO:
        RUN Facturas-Adelantadas.
    END.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Papel-Blanco bgDialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros bgDialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros bgDialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SECOND-TRANSACTION bgDialog 
PROCEDURE SECOND-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       NORMALMENTE, NO HAY MAS DE UN COMPROBANTE EN LA TABLA "Reporte"
------------------------------------------------------------------------------*/

DEF VAR iNumOrden AS INT INIT 0 NO-UNDO.   /* COntrola la cantidad de comprobantes procesados */
pMensaje = "".
FOR EACH Reporte NO-LOCK, FIRST Ccbcdocu OF Reporte NO-LOCK:
    iNumOrden = iNumOrden + 1.
    /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
    RUN sunat\progress-to-ppll-v3  ( INPUT Ccbcdocu.coddiv,
                                     INPUT Ccbcdocu.coddoc,
                                     INPUT Ccbcdocu.nrodoc,
                                     INPUT-OUTPUT TABLE T-FELogErrores,
                                     OUTPUT pMensaje ).
    IF RETURN-VALUE <> "OK" THEN DO:
        IF RETURN-VALUE = 'ADM-ERROR' THEN IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR conexión de ePos".
        IF RETURN-VALUE = 'ERROR-EPOS' THEN IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR grabación de ePos".
        IF RETURN-VALUE = 'PLAN-B' THEN DO:
            pMensaje = ''.
            RETURN "PLAN-B".
        END.
        RETURN 'ADM-ERROR'.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

