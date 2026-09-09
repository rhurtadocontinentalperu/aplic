&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-ADocu FOR CcbADocu.
DEFINE SHARED TEMP-TABLE PEDI LIKE FacDPedi.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
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
*/

DEFINE SHARED VARIABLE s-CodCia AS INTEGER.
DEFINE SHARED VARIABLE s-NomCia AS CHARACTER.

DEFINE SHARED VARIABLE s-CodDiv AS CHARACTER.
/*DEFINE SHARED VARIABLE s-CodAlm AS CHARACTER.*/
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
/* IF pTipoGuia = 'A' THEN DO:     /* AUTOMATICA */                                */
/*     FIND FIRST facdpedi OF faccpedi WHERE facdpedi.canate > 0 NO-LOCK NO-ERROR. */
/*     IF AVAILABLE facdpedi THEN DO:                                              */
/*         MESSAGE 'Esta Orden tiene atenciones parciales' SKIP                    */
/*             'Solo se pueden generar guias manuales'                             */
/*             VIEW-AS ALERT-BOX WARNING.                                          */
/*         RETURN ERROR.                                                           */
/*     END.                                                                        */
/* END.                                                                            */

FIND FacDocum WHERE FacDocum.CodCia = s-CodCia 
    AND FacDocum.CodDoc = cCodDoc 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum OR FacDocum.CodMov = 0 THEN DO:
    MESSAGE
        "Codigo de Documento" cCodDoc "no configurado"
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
cCodMov = FacDocum.CodMov.

FIND FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia 
    AND FacCorre.CodDiv = s-CodDiv 
    AND FacCorre.CodDoc = cCodDoc 
    AND FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME gDialog
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES PEDI Almmmatg

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 PEDI.codmat Almmmatg.DesMat ~
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


/* Definitions for DIALOG-BOX gDialog                                   */
&Scoped-define OPEN-BROWSERS-IN-QUERY-gDialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 COMBO-NroSer-Guia COMBO-NroSer ~
Btn_OK Btn_Cancel FILL-IN-Glosa FILL-IN-LugEnt RECT-1 
&Scoped-Define DISPLAYED-OBJECTS COMBO-NroSer-Guia FILL-IN-NroPed ~
FILL-IN-Cliente FILL-IN-DirClie COMBO-NroSer FILL-IN-NroDoc FILL-IN-items ~
FILL-IN-Glosa FILL-IN-LugEnt FILL-IN-NroDoc-GR 

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

DEFINE VARIABLE COMBO-NroSer AS CHARACTER FORMAT "X(3)":U 
     LABEL "Serie FAC" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 6.72 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-NroSer-Guia AS CHARACTER FORMAT "X(256)":U 
     LABEL "SERIE G/R" 
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

DEFINE VARIABLE FILL-IN-items AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Items por Guía" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81
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

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 5.92.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      PEDI, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 gDialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      PEDI.codmat COLUMN-LABEL "Producto" FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "x(60)":U
      PEDI.canate FORMAT ">,>>>,>>9.9999":U
      PEDI.UndVta COLUMN-LABEL "Unidad" FORMAT "x(6)":U
      PEDI.AlmDes COLUMN-LABEL "Almacén" FORMAT "x(3)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 80 BY 11.31
         FONT 4 ROW-HEIGHT-CHARS .46 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     BROWSE-2 AT ROW 7.46 COL 2 WIDGET-ID 200
     COMBO-NroSer-Guia AT ROW 4.5 COL 18 COLON-ALIGNED WIDGET-ID 32
     FILL-IN-NroPed AT ROW 1.81 COL 18 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-Cliente AT ROW 1.81 COL 35 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-DirClie AT ROW 2.62 COL 35 COLON-ALIGNED WIDGET-ID 24
     COMBO-NroSer AT ROW 3.69 COL 12.43 WIDGET-ID 2
     FILL-IN-NroDoc AT ROW 3.69 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     FILL-IN-items AT ROW 3.69 COL 71 COLON-ALIGNED WIDGET-ID 18
     Btn_OK AT ROW 1.81 COL 82
     Btn_Cancel AT ROW 3.42 COL 82
     FILL-IN-Glosa AT ROW 6.12 COL 18 COLON-ALIGNED WIDGET-ID 28
     FILL-IN-LugEnt AT ROW 5.31 COL 18 COLON-ALIGNED WIDGET-ID 30
     FILL-IN-NroDoc-GR AT ROW 4.5 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     RECT-1 AT ROW 1.27 COL 2 WIDGET-ID 4
     SPACE(13.71) SKIP(12.11)
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
      TABLE: PEDI T "SHARED" ? INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-2 1 gDialog */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX COMBO-NroSer IN FRAME gDialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-Cliente IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DirClie IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-items IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc-GR IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroPed IN FRAME gDialog
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
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "x(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.PEDI.canate
     _FldNameList[4]   > Temp-Tables.PEDI.UndVta
"PEDI.UndVta" "Unidad" "x(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.PEDI.AlmDes
"PEDI.AlmDes" "Almacén" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* COMPROBANTES POR ORDEN DE DESPACHO */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* Aceptar */
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

    MESSAGE
        "¿Todos los datos son correctos?"
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE rpta AS LOGICAL.
    IF rpta <> TRUE THEN RETURN NO-APPLY.

    ASSIGN
        COMBO-NroSer
        COMBO-NroSer-Guia
        FILL-IN-LugEnt
        FILL-IN-Glosa.

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


&Scoped-define SELF-NAME COMBO-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer gDialog
ON RETURN OF COMBO-NroSer IN FRAME gDialog /* Serie FAC */
DO:
    APPLY 'Tab':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer gDialog
ON VALUE-CHANGED OF COMBO-NroSer IN FRAME gDialog /* Serie FAC */
DO:
    /* Correlativo */
    FIND FacCorre WHERE
        FacCorre.CodCia = s-CodCia AND
        FacCorre.CodDoc = cCodDoc AND
        FacCorre.CodDiv = s-CodDiv AND
        FacCorre.NroSer = INTEGER(SELF:SCREEN-VALUE)
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacCorre THEN
        FILL-IN-NroDoc =
            STRING(FacCorre.NroSer,"999") +
            STRING(FacCorre.Correlativo,"999999").
    ELSE FILL-IN-NroDoc = "".
    DISPLAY FILL-IN-NroDoc WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-NroSer-Guia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer-Guia gDialog
ON VALUE-CHANGED OF COMBO-NroSer-Guia IN FRAME gDialog /* SERIE G/R */
DO:
    /* Correlativo */
    FIND FacCorre WHERE
        FacCorre.CodCia = s-CodCia AND
        FacCorre.CodDoc = "G/R" AND
        FacCorre.CodDiv = s-CodDiv AND
        FacCorre.NroSer = INTEGER(SELF:SCREEN-VALUE)
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacCorre THEN
        FILL-IN-NroDoc-GR =
            STRING(FacCorre.NroSer,"999") +
            STRING(FacCorre.Correlativo,"999999").
    ELSE FILL-IN-NroDoc-GR = "".
    DISPLAY FILL-IN-NroDoc-GR WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal gDialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierra-Pedido gDialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  DISPLAY COMBO-NroSer-Guia FILL-IN-NroPed FILL-IN-Cliente FILL-IN-DirClie 
          COMBO-NroSer FILL-IN-NroDoc FILL-IN-items FILL-IN-Glosa FILL-IN-LugEnt 
          FILL-IN-NroDoc-GR 
      WITH FRAME gDialog.
  ENABLE BROWSE-2 COMBO-NroSer-Guia COMBO-NroSer Btn_OK Btn_Cancel 
         FILL-IN-Glosa FILL-IN-LugEnt RECT-1 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Facturas-Adelantadas gDialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato gDialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generacion-de-Factura gDialog 
PROCEDURE Generacion-de-Factura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iCountItem AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE lCreaHeader AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lItemOk AS LOGICAL NO-UNDO.

    DEF BUFFER B-CDOCU FOR Ccbcdocu.
    DEF BUFFER B-DDOCU FOR Ccbddocu.
    
    trloop:
    DO TRANSACTION ON ERROR UNDO trloop, RETURN 'ADM-ERROR' ON STOP UNDO trloop, RETURN 'ADM-ERROR':
        /*Borrando Temporal*/
        EMPTY TEMP-TABLE Reporte.

        /* 1RA PARTE: GENERAMOS LAS FACTURAS */
        FIND FacCPedi WHERE ROWID(FacCPedi) = rwParaRowID EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE FacCPedi THEN DO:
            MESSAGE
                "Registro de O/D no disponible"
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
        IF NOT (FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = "C") THEN DO:
            MESSAGE
                "Registro de O/D ya no está 'PENDIENTE'"
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.

        /* Verifica Detalle */
        lItemOk = TRUE.
        FOR EACH PEDI WHERE PEDI.CanAte > 0:
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

        iCountGuide = 0.
        lCreaHeader = TRUE.
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

        FOR EACH PEDI WHERE PEDI.CanAte > 0,
            FIRST Almmmatg OF PEDI NO-LOCK,
            FIRST Almmmate NO-LOCK WHERE Almmmate.CodCia = FacCPedi.CodCia 
                AND Almmmate.CodAlm = PEDI.AlmDes
                AND Almmmate.CodMat = PEDI.CodMat,
            FIRST Facdpedi OF Faccpedi WHERE Facdpedi.codmat = PEDI.codmat
            BREAK BY PEDI.CodCia BY Almmmate.CodUbi BY PEDI.CodMat:
            /* Crea Cabecera */
            IF lCreaHeader THEN DO:
                /* Cabecera de Guía */
                RUN proc_CreaCabecera.
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.
                ASSIGN
                    iCountGuide = iCountGuide + 1
                    lCreaHeader = FALSE.
            END.
            /* Crea Detalle */
            CREATE CcbDDocu.
            BUFFER-COPY PEDI TO CcbDDocu
            ASSIGN
                CcbDDocu.NroItm = iCountItem
                CcbDDocu.CodCia = CcbCDocu.CodCia
                CcbDDocu.CodDiv = CcbcDocu.CodDiv
                CcbDDocu.Coddoc = CcbCDocu.Coddoc
                CcbDDocu.NroDoc = CcbCDocu.NroDoc 
                CcbDDocu.FchDoc = CcbCDocu.FchDoc
                CcbDDocu.CanDes = PEDI.CanAte.
            ASSIGN
                CcbDDocu.Pesmat = Almmmatg.Pesmat * (CcbDDocu.Candes * CcbDDocu.Factor).
            /* CORREGIMOS IMPORTES */
            ASSIGN
                Ccbddocu.ImpLin = ROUND ( Ccbddocu.CanDes * Ccbddocu.PreUni * 
                                          ( 1 - Ccbddocu.Por_Dsctos[1] / 100 ) *
                                          ( 1 - Ccbddocu.Por_Dsctos[2] / 100 ) *
                                          ( 1 - Ccbddocu.Por_Dsctos[3] / 100 ), 2 ).
            IF Ccbddocu.Por_Dsctos[1] = 0 AND Ccbddocu.Por_Dsctos[2] = 0 AND Ccbddocu.Por_Dsctos[3] = 0 
                THEN Ccbddocu.ImpDto = 0.
            ELSE Ccbddocu.ImpDto = Ccbddocu.CanDes * Ccbddocu.PreUni - Ccbddocu.ImpLin.
            ASSIGN
                Ccbddocu.ImpLin = ROUND(Ccbddocu.ImpLin, 2)
                Ccbddocu.ImpDto = ROUND(Ccbddocu.ImpDto, 2).
            IF Ccbddocu.AftIsc 
                THEN Ccbddocu.ImpIsc = ROUND(Ccbddocu.PreBas * Ccbddocu.CanDes * (Almmmatg.PorIsc / 100),4).
            ELSE Ccbddocu.ImpIsc = 0.
            IF Ccbddocu.AftIgv 
                THEN Ccbddocu.ImpIgv = Ccbddocu.ImpLin - ROUND( Ccbddocu.ImpLin  / ( 1 + (FacCPedi.PorIgv / 100) ), 4 ).
            ELSE Ccbddocu.ImpIgv = 0.
            /* Actualiza Detalle de la Orden de Despacho */
            ASSIGN 
                FacDPedi.CanAte = FacDPedi.CanAte + CcbDDocu.CanDes.
            lItemOk = TRUE.
            iCountItem = iCountItem + 1.
            IF iCountItem > FILL-IN-items OR LAST-OF(PEDI.CodCia) THEN DO:
                RUN proc_GrabaTotales.
                /* EN CASO DE CERRAR LAS FACTURAS APLICAMOS EL REDONDEO */
                IF LAST-OF(PEDI.CodCia) AND Faccpedi.Importe[2] <> 0 THEN DO:
                    /* NOS ASEGURAMOS QUE SEA EL ULTIMO REGISTRO */
                    IF NOT CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0
                                    NO-LOCK) THEN DO:
                        ASSIGN 
                            Ccbcdocu.ImpTot = Ccbcdocu.ImpTot + Faccpedi.Importe[2]
                            CcbCDocu.Libre_d02 = Faccpedi.Importe[2]
                            Ccbcdocu.ImpVta = ( Ccbcdocu.ImpTot / ( 1 + Ccbcdocu.PorIgv / 100 ) )
                            Ccbcdocu.ImpIgv = Ccbcdocu.ImpTot - Ccbcdocu.ImpVta
                            /*Ccbcdocu.ImpDto = Ccbcdocu.ImpBrt - Ccbcdocu.ImpVta*/
                            Ccbcdocu.ImpBrt = Ccbcdocu.ImpVta + Ccbcdocu.ImpDto + Ccbcdocu.ImpExo
                            Ccbcdocu.SdoAct = Ccbcdocu.ImpTot.
                    END.
                END.
                /* FIN DE REDONDEO */
                /* RHC 30-11-2006 Transferencia Gratuita */
                IF Ccbcdocu.FmaPgo = '900' THEN Ccbcdocu.sdoact = 0.
                IF Ccbcdocu.sdoact <= 0 
                THEN ASSIGN
                        Ccbcdocu.fchcan = TODAY
                        Ccbcdocu.flgest = 'C'.
                /* Descarga de Almacen */
                RUN vta2\act_alm (ROWID(CcbCDocu)).
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.
                /* RHC 25-06-2012 ASIENTO DE TRANSFERENCIA PARA SPEED */           
                RUN aplic/sypsa/registroventas (INPUT ROWID(ccbcdocu), INPUT "I"). 
            END.
            IF iCountItem > FILL-IN-items THEN DO:
                iCountItem = 1.
                lCreaHeader = TRUE.
                lItemOk = FALSE.
            END.
        END. /* FOR EACH FacDPedi... */
        /* 2DA PARTE: GENERACION DE GUIAS */
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
                CcbCDOcu.CodDiv = s-CodDiv
                CcbCDocu.CodDoc = "G/R"
                CcbCDocu.NroDoc =  STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999") 
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
            /* COPIAMOS DATOS DEL TRANSPORTISTA */
            FIND Ccbadocu WHERE Ccbadocu.codcia = B-CDOCU.codcia
                AND Ccbadocu.coddiv = B-CDOCU.coddiv
                AND Ccbadocu.coddoc = B-CDOCU.coddoc
                AND Ccbadocu.nrodoc = B-CDOCU.nrodoc
                NO-LOCK NO-ERROR.
            IF AVAILABLE Ccbadocu THEN DO:
                CREATE B-ADOCU.
                BUFFER-COPY Ccbadocu TO B-ADOCU
                    ASSIGN
                        B-ADOCU.CodDiv = Ccbcdocu.CodDiv
                        B-ADOCU.CodDoc = Ccbcdocu.CodDoc
                        B-ADOCU.NroDoc = Ccbcdocu.NroDoc.
            END.
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
        /* GRABACIONES FINALES */
        /* Cierra la O/D */
        FIND FIRST Facdpedi OF Faccpedi WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Facdpedi THEN FacCPedi.FlgEst = "C".

        /* CONTROL DE FACTURAS ADELANTADAS */
        RUN Facturas-Adelantadas.

        FIND CURRENT FacCPedi NO-LOCK.
        IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
        IF AVAILABLE(Ccbcdocu) THEN FIND CURRENT Ccbcdocu NO-LOCK.  /* Para no peder el puntero */
        IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.
        IF AVAILABLE(B-ADOCU)  THEN RELEASE B-ADOCU.
    END. /* DO TRANSACTION... */

    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir gDialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize gDialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO.

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
          IF cListItems = "" THEN cListItems = STRING(FacCorre.NroSer,"999").
          ELSE cListItems = cListItems + "," + STRING(FacCorre.NroSer,"999").
      END.
      ASSIGN
          COMBO-NroSer:LIST-ITEMS = cListItems
          COMBO-NroSer = ENTRY(1,COMBO-NroSer:LIST-ITEMS)
          COMBO-NroSer:LABEL = 'SERIE DE ' + (IF cCodDoc = 'FAC' THEN 'FACTURA' ELSE 'BOLETA')
          FILL-IN-items = FacCfgGn.Items_Guias
          FILL-IN-NroPed = FacCPedi.NroPed
          FILL-IN-Glosa = FacCPedi.Glosa
          FILL-IN-LugEnt = FacCPedi.LugEnt
          FILL-IN-Cliente = FacCPedi.CodCli + " - " + FacCPedi.NomCli
          FILL-IN-DirClie = FacCPedi.DirCli.
      FIND FacCorre WHERE
          FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDoc = cCodDoc AND
          FacCorre.CodDiv = s-CodDiv AND
          FacCorre.NroSer = INTEGER(COMBO-NroSer)
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacCorre THEN
          FILL-IN-NroDoc =
              STRING(FacCorre.NroSer,"999") +
              STRING(FacCorre.Correlativo,"999999").
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
          FILL-IN-NroDoc-GR =
              STRING(FacCorre.NroSer,"999") +
              STRING(FacCorre.Correlativo,"999999").
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Papel-Blanco gDialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros gDialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CreaCabecera gDialog 
PROCEDURE proc_CreaCabecera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    CREATE CcbCDocu.
    BUFFER-COPY FacCPedi 
        TO CcbCDocu
        ASSIGN
        CcbCDocu.CodDiv = s-CodDiv
        CcbCDocu.DivOri = FacCPedi.CodDiv    /* OJO: division de estadisticas */
        CcbCDocu.CodAlm = FacCPedi.CodAlm   /* OJO: Almacén despacho */
        CcbCDocu.CodDoc = cCodDoc
        CcbCDocu.NroDoc =  STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999") 
        CcbCDocu.FchDoc = TODAY
        CcbCDocu.CodMov = cCodMov
        CcbCDocu.CodRef = FacCPedi.CodDoc           /* CONTROL POR DEFECTO */
        CcbCDocu.NroRef = FacCPedi.NroPed
        CcbCDocu.Libre_c01 = FacCPedi.CodDoc        /* CONTROL ADICIONAL */
        CcbCDocu.Libre_c02 = FacCPedi.NroPed
        Ccbcdocu.CodPed = FacCPedi.CodRef
        Ccbcdocu.NroPed = FacCPedi.NroRef
        CcbCDocu.FchVto = TODAY
        CcbCDocu.CodAnt = FacCPedi.Atencion     /* DNI */
        CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
        CcbCDocu.NroOrd = FacCPedi.ordcmp
        CcbCDocu.FlgEst = "P"
        CcbCDocu.TpoFac = "CR"                  /* CREDITO */
        CcbCDocu.Tipo   = "CREDITO"
        CcbCDocu.usuario = S-USER-ID
        CcbCDocu.HorCie = STRING(TIME,'hh:mm')
        CcbCDocu.LugEnt = FILL-IN-LugEnt
        CcbCDocu.LugEnt2 = FacCPedi.LugEnt2
        CcbCDocu.Glosa = FILL-IN-Glosa
        CcbCDocu.FlgCbd = FacCPedi.FlgIgv.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /*RDP*/    
    CREATE Reporte.
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
    /* COPIAMOS DATOS DEL TRANSPORTISTA */
    FIND Ccbadocu WHERE Ccbadocu.codcia = Faccpedi.codcia
        AND Ccbadocu.coddiv = Faccpedi.coddiv
        AND Ccbadocu.coddoc = Faccpedi.coddoc
        AND Ccbadocu.nrodoc = Faccpedi.nroped
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbadocu THEN DO:
        CREATE B-ADOCU.
        BUFFER-COPY Ccbadocu TO B-ADOCU
            ASSIGN
                B-ADOCU.CodDiv = Ccbcdocu.CodDiv
                B-ADOCU.CodDoc = Ccbcdocu.CodDoc
                B-ADOCU.NroDoc = Ccbcdocu.NroDoc.
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_GrabaTotales gDialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros gDialog 
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

