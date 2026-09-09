&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-ADOCU FOR CcbADocu.
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-DDOCU FOR CcbDDocu.



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
DEFINE INPUT PARAMETER pCodDoc     AS CHAR.
/* pTipoGuia
    A: automática
    M: manual
*/
DEFINE SHARED VARIABLE s-CodCia AS INTEGER.
DEFINE SHARED VARIABLE s-NomCia AS CHARACTER.
DEFINE SHARED VARIABLE s-CodDiv AS CHARACTER.
DEFINE SHARED VARIABLE s-CodAlm AS CHARACTER.
DEFINE SHARED VARIABLE s-User-Id AS CHARACTER.
DEFINE SHARED VARIABLE cl-codcia AS INTEGER.

DEFINE VARIABLE cCodDoc AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodAlm AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodMov AS INTEGER NO-UNDO.
DEFINE VARIABLE iCountGuide AS INTEGER NO-UNDO.

DEF VAR s-FechaI AS DATETIME NO-UNDO.
DEF VAR s-FechaT AS DATETIME NO-UNDO.

s-FechaI = DATETIME(TODAY, MTIME).

FIND Di-rutac WHERE ROWID(Di-rutac) = rwParaRowID NO-LOCK NO-ERROR.
IF NOT AVAILABLE Di-rutac THEN DO:
    MESSAGE
        "Registro de H/R no disponible"
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
IF DI-RutaC.FlgEst <> "E" THEN DO:
    MESSAGE
        "Registro de H/R ya no está 'EMITIDA'"
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

/* Consistencia del tipo de guia */
cCodDoc = pCodDoc.
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
        "Codigo de Documento G/R no configurado para el almacén" cCodAlm
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
FIND FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia 
    AND FacCorre.CodDiv = s-CodDiv 
    AND FacCorre.CodDoc = 'BOL'
    AND FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE
        "Codigo de Documento BOL no configurado para la division" s-CodDiv
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
FIND FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia 
    AND FacCorre.CodDiv = s-CodDiv 
    AND FacCorre.CodDoc = 'FAC'
    AND FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE
        "Codigo de Documento FAC no configurado para la division" s-CodDiv
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

DEFINE TEMP-TABLE Reporte NO-UNDO
    FIELDS CodCia LIKE CcbCDocu.CodCia
    FIELDS CodDoc LIKE CcbCDocu.CodDoc
    FIELDS NroDoc LIKE CcbCDocu.Nrodoc.

DEFINE TEMP-TABLE Reporte-2 NO-UNDO
    FIELDS CodCia LIKE CcbCDocu.CodCia
    FIELDS CodDoc LIKE CcbCDocu.CodDoc
    FIELDS NroDoc LIKE CcbCDocu.Nrodoc.

DEFINE BUFFER F-CDOCU FOR CcbCDocu.
DEFINE BUFFER F-DDOCU FOR CcbDDocu.

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

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS TOGGLE-1 COMBO-NroSer Btn_OK Btn_Cancel ~
COMBO-NroSer-2 COMBO-NroSer-3 
&Scoped-Define DISPLAYED-OBJECTS TOGGLE-1 COMBO-NroSer FILL-IN-NroDoc ~
FILL-IN-items COMBO-NroSer-2 FILL-IN-NroDoc-2 FILL-IN-items-2 ~
COMBO-NroSer-3 FILL-IN-NroDoc-3 FILL-IN-items-3 

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
     LABEL "Serie G/R" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 6.72 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-NroSer-2 AS CHARACTER FORMAT "X(3)":U 
     LABEL "Serie FAC" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 6.72 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-NroSer-3 AS CHARACTER FORMAT "X(3)":U 
     LABEL "Serie BOL" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 6.72 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-items AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Items por Guía" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-items-2 AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Items por Factura" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-items-3 AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Items por Boleta" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "XXX-XXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc-2 AS CHARACTER FORMAT "XXX-XXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc-3 AS CHARACTER FORMAT "XXX-XXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE TOGGLE-1 AS LOGICAL INITIAL no 
     LABEL "Impresión EAN" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .77
     BGCOLOR 12 FGCOLOR 14  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     TOGGLE-1 AT ROW 2.08 COL 4 WIDGET-ID 44
     COMBO-NroSer AT ROW 2.08 COL 19.28 WIDGET-ID 2
     FILL-IN-NroDoc AT ROW 2.08 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     FILL-IN-items AT ROW 2.08 COL 59 COLON-ALIGNED WIDGET-ID 18
     Btn_OK AT ROW 6.12 COL 4
     Btn_Cancel AT ROW 6.12 COL 16
     COMBO-NroSer-2 AT ROW 3.15 COL 19.43 WIDGET-ID 32
     FILL-IN-NroDoc-2 AT ROW 3.15 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     FILL-IN-items-2 AT ROW 3.15 COL 59 COLON-ALIGNED WIDGET-ID 34
     COMBO-NroSer-3 AT ROW 4.23 COL 19.28 WIDGET-ID 38
     FILL-IN-NroDoc-3 AT ROW 4.23 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     FILL-IN-items-3 AT ROW 4.23 COL 59 COLON-ALIGNED WIDGET-ID 40
     SPACE(16.56) SKIP(3.45)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Generando GUIA(s) DE REMISION y FACTURA(s) o BOLETA(s)" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: B-ADOCU B "?" ? INTEGRAL CcbADocu
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: B-DDOCU B "?" ? INTEGRAL CcbDDocu
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
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX COMBO-NroSer IN FRAME gDialog
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX COMBO-NroSer-2 IN FRAME gDialog
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX COMBO-NroSer-3 IN FRAME gDialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-items IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-items-2 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-items-3 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc-2 IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc-3 IN FRAME gDialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* Generando GUIA(s) DE REMISION y FACTURA(s) o BOLETA(s) */
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

    MESSAGE
        "¿Todos los datos son correctos?"
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE rpta AS LOGICAL.
    IF rpta <> TRUE THEN RETURN NO-APPLY.

    ASSIGN
        TOGGLE-1
        COMBO-NroSer
        COMBO-NroSer-2
        COMBO-NroSer-3.

    CASE pTipoGuia:
        WHEN 'A' THEN DO:       /* AUTOMATICA */
            RUN proc_CreaGuia.
            IF RETURN-VALUE = 'ADM-ERROR' THEN
                MESSAGE
                    "Ninguna guía fué generada"
                    VIEW-AS ALERT-BOX WARNING.
            ELSE DO:
                MESSAGE
                    "Se ha(n) generado" iCountGuide "guía(s)"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
        END.
    END CASE.
    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer gDialog
ON RETURN OF COMBO-NroSer IN FRAME gDialog /* Serie G/R */
DO:
    APPLY 'Tab':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer gDialog
ON VALUE-CHANGED OF COMBO-NroSer IN FRAME gDialog /* Serie G/R */
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


&Scoped-define SELF-NAME COMBO-NroSer-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer-2 gDialog
ON RETURN OF COMBO-NroSer-2 IN FRAME gDialog /* Serie FAC */
DO:
    APPLY 'Tab':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer-2 gDialog
ON VALUE-CHANGED OF COMBO-NroSer-2 IN FRAME gDialog /* Serie FAC */
DO:

    /* Correlativo */
    FIND FacCorre WHERE
        FacCorre.CodCia = s-CodCia AND
        FacCorre.CodDoc = cCodDoc AND
        FacCorre.CodDiv = s-CodDiv AND
        FacCorre.NroSer = INTEGER(SELF:SCREEN-VALUE)
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacCorre THEN
        FILL-IN-NroDoc-2 =
            STRING(FacCorre.NroSer,"999") +
            STRING(FacCorre.Correlativo,"999999").
    ELSE FILL-IN-NroDoc-2 = "".
    DISPLAY FILL-IN-NroDoc-2 WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-NroSer-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer-3 gDialog
ON RETURN OF COMBO-NroSer-3 IN FRAME gDialog /* Serie BOL */
DO:
    APPLY 'Tab':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer-3 gDialog
ON VALUE-CHANGED OF COMBO-NroSer-3 IN FRAME gDialog /* Serie BOL */
DO:

    /* Correlativo */
    FIND FacCorre WHERE
        FacCorre.CodCia = s-CodCia AND
        FacCorre.CodDoc = cCodDoc AND
        FacCorre.CodDiv = s-CodDiv AND
        FacCorre.NroSer = INTEGER(SELF:SCREEN-VALUE)
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacCorre THEN
        FILL-IN-NroDoc-3 =
            STRING(FacCorre.NroSer,"999") +
            STRING(FacCorre.Correlativo,"999999").
    ELSE FILL-IN-NroDoc-3 = "".
    DISPLAY FILL-IN-NroDoc-3 WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Factura-Adelantada gDialog 
PROCEDURE Carga-Factura-Adelantada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Monto-Aplicar  AS DEC NO-UNDO.
  DEF VAR x-TpoCmb-Compra AS DEC INIT 1 NO-UNDO.
  DEF VAR x-TpoCmb-Venta  AS DEC INIT 1 NO-UNDO.
  DEF VAR x-NroItm        AS INT INIT 1 NO-UNDO.

  IF CcbCDocu.sdoact <= 0 THEN RETURN 'OK'.

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND FIRST F-CDOCU WHERE F-CDOCU.codcia = CcbCDocu.codcia
        AND F-CDOCU.coddoc = 'FAC'
        AND F-CDOCU.tpofac = 'A'
        AND F-CDOCU.codcli = CcbCDocu.codcli
        AND F-CDOCU.flgest = 'C'
        AND F-CDOCU.imptot2 > 0
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE F-CDOCU THEN RETURN 'OK'.
    FIND FIRST F-DDOCU OF F-CDOCU NO-LOCK NO-ERROR.
    IF NOT AVAILABLE F-DDOCU THEN RETURN 'OK'.
  
    FIND LAST Gn-tccja WHERE Gn-tccja.Fecha <= TODAY NO-LOCK NO-ERROR.

    IF AVAILABLE Gn-TcCja 
    THEN ASSIGN
            x-TpoCmb-Compra = Gn-Tccja.Compra.
            x-TpoCmb-Venta  = Gn-Tccja.Venta.
  
    IF CcbCDocu.codmon = F-CDOCU.codmon
    THEN ASSIGN
            x-Monto-Aplicar  = MINIMUM(CcbCDocu.imptot, F-CDOCU.imptot2).
    ELSE IF CcbCDocu.codmon = 1
        THEN ASSIGN
                x-Monto-Aplicar  = ROUND(MINIMUM(F-CDOCU.imptot2 * x-TpoCmb-Compra, CcbCDocu.imptot),2).
        ELSE ASSIGN
                x-Monto-Aplicar  = ROUND(MINIMUM(F-CDOCU.imptot2 / x-TpoCmb-Venta , CcbCDocu.imptot),2).

    /* CREAMOS DETALLE */
    FOR EACH Ccbddocu OF CcbCDocu NO-LOCK:
        x-NroItm = x-NroItm + 1.
    END.
    CREATE CcbDDocu.
    ASSIGN
        Ccbddocu.codcia = Ccbcdocu.codcia
        Ccbddocu.coddiv = Ccbcdocu.coddiv
        Ccbddocu.coddoc = Ccbcdocu.coddoc
        Ccbddocu.nrodoc = Ccbcdocu.nrodoc
        Ccbddocu.codmat = F-DDOCU.codmat
        Ccbddocu.candes = 1
        Ccbddocu.factor = 1
        Ccbddocu.undvta = 'UNI'
        Ccbddocu.preuni = -1 * x-Monto-Aplicar
        Ccbddocu.implin = -1 * x-Monto-Aplicar
        Ccbddocu.impigv = -1 * ROUND(x-Monto-Aplicar / (1 + CcbCDocu.PorIgv / 100) * CcbCDocu.PorIgv / 100, 2)
        CcbDDocu.AftIgv = YES
        CcbDDocu.NroItm = x-NroItm.
    
    /* Control de descarga de facturas adelantadas */
    CREATE Ccbdmov.
    ASSIGN
        CCBDMOV.CodCia = s-codcia
        CCBDMOV.CodCli = F-CDOCU.codcli
        CCBDMOV.CodDiv = CcbCDocu.coddiv
        CCBDMOV.CodDoc = F-CDOCU.coddoc
        CCBDMOV.CodMon = CcbCDocu.codmon
        CCBDMOV.CodRef = CcbCDocu.coddoc
        CCBDMOV.FchDoc = CcbCDocu.fchdoc
        CCBDMOV.FchMov = TODAY
        CCBDMOV.HraMov = STRING(TIME,'HH:MM')
        CCBDMOV.ImpTot = x-Monto-Aplicar
        CCBDMOV.NroDoc = F-CDOCU.nrodoc
        CCBDMOV.NroRef = CcbCDocu.nrodoc
        CCBDMOV.TpoCmb = (IF CcbCDocu.codmon = 1 THEN x-TpoCmb-Compra ELSE x-TpoCmb-Venta)
        CCBDMOV.usuario = s-user-id.
    
    /* Actualizamos saldo factura adelantada */
    IF F-CDOCU.CodMon = Ccbdmov.codmon
    THEN F-CDOCU.ImpTot2 = F-CDOCU.ImpTot2 - Ccbdmov.ImpTot.
    ELSE IF F-CDOCU.CodMon = 1
        THEN F-CDOCU.ImpTot2 = F-CDOCU.ImpTot2 - Ccbdmov.ImpTot * Ccbdmov.TpoCmb.
        ELSE F-CDOCU.ImpTot2 = F-CDOCU.ImpTot2 - Ccbdmov.ImpTot / Ccbdmov.TpoCmb.
    
    RELEASE CcbDDocu.    
    RELEASE F-CDOCU.
    RELEASE Ccbdmov.
  END.
  RUN proc_GrabaTotales.
  RETURN 'OK'.


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
  DISPLAY TOGGLE-1 COMBO-NroSer FILL-IN-NroDoc FILL-IN-items COMBO-NroSer-2 
          FILL-IN-NroDoc-2 FILL-IN-items-2 COMBO-NroSer-3 FILL-IN-NroDoc-3 
          FILL-IN-items-3 
      WITH FRAME gDialog.
  ENABLE TOGGLE-1 COMBO-NroSer Btn_OK Btn_Cancel COMBO-NroSer-2 COMBO-NroSer-3 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
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
            {&PRN4} + {&PRN6A} + "Forma Pago : " + CcbCDocu.FmaPgo  AT 1 FORMAT "X(40)"
            {&PRN4} + {&PRN7A} + {&PRN6B} + "N°Guía de Remisión: " + CcbCDocu.NroDoc + {&PRN6B} + {&PRN7B} + {&PRN3} AT 1 FORMAT "X(50)" SKIP   
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir gDialog 
PROCEDURE Imprimir :
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
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 30.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 30. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(33) + {&Prn4} .
        RUN Formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM REPORT CLOSE.
    END.
    OUTPUT CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.
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

    DO WITH FRAME {&FRAME-NAME}:
        FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
        FOR EACH FacCorre NO-LOCK WHERE 
            FacCorre.CodCia = s-CodCia AND
            FacCorre.CodDiv = s-CodDiv AND 
            FacCorre.CodDoc = cCodDoc AND
            /*FacCorre.CodAlm = cCodAlm AND*/
            FacCorre.FlgEst = YES:
            IF cListItems = "" THEN cListItems = STRING(FacCorre.NroSer,"999").
            ELSE cListItems = cListItems + "," + STRING(FacCorre.NroSer,"999").
        END.
        COMBO-NroSer:LIST-ITEMS = cListItems.
        COMBO-NroSer = ENTRY(1,COMBO-NroSer:LIST-ITEMS).

        cListItems = ''.
        FOR EACH FacCorre NO-LOCK WHERE 
            FacCorre.CodCia = s-CodCia AND
            FacCorre.CodDiv = s-CodDiv AND 
            FacCorre.CodDoc = 'FAC' AND
            /*FacCorre.CodAlm = cCodAlm AND*/
            FacCorre.FlgEst = YES:
            IF cListItems = "" THEN cListItems = STRING(FacCorre.NroSer,"999").
            ELSE cListItems = cListItems + "," + STRING(FacCorre.NroSer,"999").
        END.
        COMBO-NroSer-2:LIST-ITEMS = cListItems.
        COMBO-NroSer-2 = ENTRY(1,COMBO-NroSer-2:LIST-ITEMS).

        cListItems = ''.
        FOR EACH FacCorre NO-LOCK WHERE 
            FacCorre.CodCia = s-CodCia AND
            FacCorre.CodDiv = s-CodDiv AND 
            FacCorre.CodDoc = 'BOL' AND
            /*FacCorre.CodAlm = cCodAlm AND*/
            FacCorre.FlgEst = YES:
            IF cListItems = "" THEN cListItems = STRING(FacCorre.NroSer,"999").
            ELSE cListItems = cListItems + "," + STRING(FacCorre.NroSer,"999").
        END.
        COMBO-NroSer-3:LIST-ITEMS = cListItems.
        COMBO-NroSer-3 = ENTRY(1,COMBO-NroSer-3:LIST-ITEMS).
        
        FILL-IN-items = FacCfgGn.Items_Guias.
        FILL-IN-items-2 = FacCfgGn.Items_Factura.
        FILL-IN-items-3 = FacCfgGn.Items_Boleta.
        /* Correlativo */
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
        FIND FacCorre WHERE
            FacCorre.CodCia = s-CodCia AND
            FacCorre.CodDoc = 'FAC' AND
            FacCorre.CodDiv = s-CodDiv AND
            FacCorre.NroSer = INTEGER(COMBO-NroSer-2)
            NO-LOCK NO-ERROR.
        IF AVAILABLE FacCorre THEN
            FILL-IN-NroDoc-2 =
                STRING(FacCorre.NroSer,"999") +
                STRING(FacCorre.Correlativo,"999999").
        FIND FacCorre WHERE
            FacCorre.CodCia = s-CodCia AND
            FacCorre.CodDoc = 'BOL' AND
            FacCorre.CodDiv = s-CodDiv AND
            FacCorre.NroSer = INTEGER(COMBO-NroSer-3)
            NO-LOCK NO-ERROR.
        IF AVAILABLE FacCorre THEN
            FILL-IN-NroDoc-3 =
                STRING(FacCorre.NroSer,"999") +
                STRING(FacCorre.Correlativo,"999999").
    END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CreaGuia gDialog 
PROCEDURE proc_CreaGuia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK.
    
    /*Borrando Temporal*/
    FOR EACH Reporte:
        DELETE Reporte.
    END.
    FOR EACH Reporte-2:
        DELETE Reporte-2.
    END.

    iCountGuide = 0.

    trloop:
    DO TRANSACTION ON ERROR UNDO trloop, RETURN 'ADM-ERROR' ON STOP UNDO trloop, RETURN 'ADM-ERROR':
        FIND Di-rutac WHERE ROWID(Di-rutac) = rwParaRowID EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Di-rutac THEN DO:
            MESSAGE
                "Registro de H/R no disponible"
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
        IF Di-rutac.FlgEst <> "E" THEN DO:
            MESSAGE
                "Registro de H/R ya no está 'EMITIDO'"
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
        FIND Ccbadocu OF Di-RutaC NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Ccbadocu THEN DO:
            MESSAGE 'NO tiene registrado el TRANSPORTISTA' SKIP
                'Continuamos con la generación de Guías?'
                VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO 
                UPDATE rpta AS LOG.
            IF rpta = NO THEN RETURN 'ADM-ERROR'.
        END.

        /* GUIA DE REMISION */
        cCodDoc = 'G/R'.
        FOR EACH Di-rutaGri OF Di-rutac NO-LOCK,
                FIRST B-CDOCU WHERE B-CDOCU.codcia = Di-rutac.codcia        /* GRI */
                    AND B-CDOCU.coddoc = Di-rutagri.codref
                    AND B-CDOCU.nrodoc = Di-rutaGri.nroref,
                FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia     /* PED */
                    AND Faccpedi.coddoc = B-CDOCU.codped
                    AND Faccpedi.nroped = B-CDOCU.nroped
                BREAK BY Faccpedi.NroPed:
            /* Control de GRI */
            IF B-CDOCU.FlgEst <> 'P' THEN DO:
                MESSAGE 'La' B-CDOCU.coddoc B-CDOCU.nrodoc 'NO puede generar G/R' SKIP
                    'Revise el estado del documento' SKIP
                    'Proceso cancelado'
                    VIEW-AS ALERT-BOX ERROR.
                UNDO, RETURN 'ADM-ERROR'.
            END.
            /* Correlativo */
            FIND FacCorre WHERE
                FacCorre.CodCia = s-CodCia AND
                FacCorre.CodDiv = s-CodDiv AND
                FacCorre.CodDoc = cCodDoc AND
                FacCorre.NroSer = INTEGER(COMBO-NroSer) 
                EXCLUSIVE-LOCK NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                MESSAGE 'NO se encontro el correlativo para el documento ' cCodDoc
                    VIEW-AS ALERT-BOX ERROR.
                UNDO trloop, RETURN 'ADM-ERROR'.
            END.
            /* creamos guia */
            CREATE Ccbcdocu.
            BUFFER-COPY B-CDOCU TO Ccbcdocu
                ASSIGN
                    Ccbcdocu.coddiv = s-CodDiv
                    Ccbcdocu.coddoc = cCodDoc
                    CcbCDocu.NroDoc =  STRING(FacCorre.NroSer,"999") +
                                        STRING(FacCorre.Correlativo,"999999") 
                    CcbCDocu.FchDoc = TODAY
                    CcbCDocu.FchVto = TODAY
                    CcbCDocu.FlgEst = "F"       /* FACTURADA */
                    CcbCDocu.usuario = S-USER-ID
                    CcbCDocu.HorCie = STRING(TIME,'hh:mm')
                    FacCorre.Correlativo = FacCorre.Correlativo + 1
                    CcbCDocu.Libre_c01 = B-CDOCU.coddoc
                    CcbCDocu.Libre_c02 = B-CDOCU.nrodoc.
            FOR EACH B-DDOCU OF B-CDOCU NO-LOCK:
                CREATE Ccbddocu.
                BUFFER-COPY B-DDOCU TO Ccbddocu
                    ASSIGN
                        Ccbddocu.coddiv = Ccbcdocu.coddiv
                        Ccbddocu.coddoc = Ccbcdocu.coddoc
                        Ccbddocu.nrodoc = Ccbcdocu.nrodoc.
            END.
            /*RUN proc_GrabaTotales.*/
            ASSIGN
                B-CDOCU.Libre_c01 = Ccbcdocu.coddoc
                B-CDOCU.Libre_c02 = Ccbcdocu.nrodoc
                B-CDOCU.FlgEst = 'F'.

            IF AVAILABLE Ccbadocu THEN DO:
                CREATE B-ADOCU.
                BUFFER-COPY Ccbadocu TO B-ADOCU
                    ASSIGN
                        B-ADOCU.Coddiv = Ccbcdocu.coddiv
                        B-ADOCU.Coddoc = Ccbcdocu.coddoc
                        B-ADOCU.Nrodoc = Ccbcdocu.nrodoc.
                RELEASE B-ADOCU.
            END.
            /* TRACKING GUIAS */
            IF FIRST-OF(Faccpedi.NroPed) THEN DO:
                s-FechaT = DATETIME(TODAY, MTIME).
                RUN gn/pTracking (s-CodCia,
                                  FAccpedi.CodDiv,
                                  s-CodDiv,
                                  Faccpedi.CodDoc,
                                  Faccpedi.NroPed,
                                  s-User-Id,
                                  'EGUI',
                                  'P',
                                  'IO',
                                  s-FechaI,
                                  s-FechaT,
                                  Ccbcdocu.coddoc,
                                  Ccbcdocu.nrodoc).
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
            END.

            /* Carga H/Ruta */
            CREATE Di-RutaD.
            BUFFER-COPY Di-RutaC TO Di-RutaD
                ASSIGN
                    di-rutad.codref = ccbcdocu.coddoc
                    di-rutad.nroref = ccbcdocu.nrodoc
                    di-rutad.horest = DI-RutaC.HorSal.
            RELEASE Di-RutaD.
            /*RDP*/    
            CREATE Reporte.
                ASSIGN 
                    Reporte.CodCia = CcbCDocu.CodCia
                    Reporte.CodDoc = CcbCDocu.CodDoc
                    Reporte.NroDoc = CcbCDocu.NroDoc.

            RELEASE Ccbcdocu.
            iCountGuide = iCountGuide + 1.
        END.
        /* COMPROBANTES */
        FOR EACH Reporte,
                FIRST B-CDOCU WHERE B-CDOCU.codcia = s-codcia                   /* G/R */
                    AND B-CDOCU.coddoc = Reporte.coddoc
                    AND B-CDOCU.nrodoc = Reporte.nrodoc,
                FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = B-CDOCU.codcia  /* PED */
                    AND Faccpedi.coddoc = B-CDOCU.codped                   
                    AND Faccpedi.nroped = B-CDOCU.nroped
                BREAK BY Faccpedi.NroPed:
            cCodDoc = FacCPedi.Cmpbnte.      /* <<< OJO (FAC o BOL) <<< */
            /* VERIFCACION DEL TRACKING */
            FIND Vtatrack03 WHERE VtaTrack03.CodCia = s-codcia
                AND VtaTrack03.CodDiv = Faccpedi.coddiv
                AND VtaTrack03.CodDoc = Faccpedi.coddoc
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Vtatrack03 THEN NEXT.
            FIND Vtatrack01 OF Vtatrack03 NO-LOCK.      /* Definicion del tracking */
            IF VtaTrack01.Libre_c01 <> 'X' THEN NEXT.
            
            /* Correlativo */
            FIND FacCorre WHERE
                FacCorre.CodCia = s-CodCia AND
                FacCorre.CodDoc = cCodDoc AND
                FacCorre.CodDiv = s-CodDiv AND
                FacCorre.NroSer = (IF cCodDoc = 'BOL' THEN INTEGER(COMBO-NroSer-3) ELSE INTEGER(COMBO-NroSer-2))
                EXCLUSIVE-LOCK NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                MESSAGE 'NO se encontro el correlativo para el documento' cCodDoc
                    VIEW-AS ALERT-BOX ERROR.
                UNDO trloop, RETURN 'ADM-ERROR'.
            END.
            CREATE Ccbcdocu.
            BUFFER-COPY B-CDOCU TO Ccbcdocu
                ASSIGN
                    Ccbcdocu.coddoc = cCodDoc
                    /*Ccbcdocu.coddiv = s-CodDiv*/
                    Ccbcdocu.coddiv = Faccpedi.CodDiv        /* CARGA A LA DIVISION DEL PEDIDO */
                    CcbCDocu.NroDoc =  STRING(FacCorre.NroSer,"999") +
                                        STRING(FacCorre.Correlativo,"999999") 
                    CcbCDocu.FchDoc = TODAY
                    CcbCDocu.FchVto = TODAY
                    CcbCDocu.FlgEst = "P"       /* PENDIENTE */
                    CcbCDocu.FlgAte = "D"
                    CcbCDocu.TpoFac = "R"       /* <<< OJO <<< */
                    CcbCDocu.Tipo   = 'OFICINA'
                    CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
                    CcbCDocu.usuario = S-USER-ID
                    CcbCDocu.HorCie = STRING(TIME,'hh:mm')
                    FacCorre.Correlativo = FacCorre.Correlativo + 1.

            FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
                AND gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clie  THEN DO:
                ASSIGN 
                    CcbCDocu.CodDpto = gn-clie.CodDept 
                    CcbCDocu.CodProv = gn-clie.CodProv 
                    CcbCDocu.CodDist = gn-clie.CodDist.
            END.
            /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
            FIND GN-VEN WHERE gn-ven.codcia = s-codcia
                AND gn-ven.codven = ccbcdocu.codven
                NO-LOCK NO-ERROR.
            IF AVAILABLE GN-VEN THEN ccbcdocu.cco = gn-ven.cco.
            /* ACTUALIZA VENCIMIENTOS */
            FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
            IF AVAILABLE gn-convt 
                THEN ASSIGN Ccbcdocu.FchVto = TODAY + gn-ConVt.TotDias.
            /* OTROS DATOS */
            ASSIGN
                Ccbcdocu.TipVta = (IF Ccbcdocu.coddoc = 'FAC' THEN '1' ELSE '2')
                Ccbcdocu.CodRef = B-CDOCU.CodDoc
                Ccbcdocu.NroRef = B-CDOCU.nrodoc.
            /* DETALLE */
            FOR EACH B-DDOCU OF B-CDOCU NO-LOCK:
                CREATE Ccbddocu.
                BUFFER-COPY B-DDOCU TO Ccbddocu
                    ASSIGN
                        Ccbddocu.coddiv = Ccbcdocu.coddiv
                        Ccbddocu.coddoc = Ccbcdocu.coddoc
                        Ccbddocu.nrodoc = Ccbcdocu.nrodoc.
            END.
            /*RUN proc_GrabaTotales.*/

            /* RHC 22.10.08 APLICACION DE FACTURAS ADELANTADAS */
            /*IF s-aplic-fact-ade = YES THEN DO:*/
                RUN Carga-Factura-Adelantada.
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.
            /*END.*/

            ASSIGN
                B-CDOCU.CodRef = Ccbcdocu.coddoc
                B-CDOCU.NroRef = Ccbcdocu.nrodoc.
            /* TRACKING FACTURAS */
            IF FIRST-OF(Faccpedi.NroPed) THEN DO:
                s-FechaT = DATETIME(TODAY, MTIME).
                RUN gn/pTracking (s-CodCia,
                                  Faccpedi.CodDiv,
                                  s-CodDiv,
                                  Faccpedi.CodDoc,
                                  Faccpedi.NroPed,
                                  s-User-Id,
                                  'EFAC',
                                  'C',
                                  'IO',
                                  s-FechaI,
                                  s-FechaT,
                                  Ccbcdocu.coddoc,
                                  Ccbcdocu.nrodoc).
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
            END.
            /* Carga H/Ruta */
            CREATE Di-RutaD.
            BUFFER-COPY Di-RutaC TO Di-RutaD
                ASSIGN
                    di-rutad.codref = ccbcdocu.coddoc
                    di-rutad.nroref = ccbcdocu.nrodoc
                    di-rutad.horest = DI-RutaC.HorSal.
            RELEASE Di-RutaD.
            /*RDP*/    
            CREATE Reporte-2.
                ASSIGN 
                    Reporte-2.CodCia = CcbCDocu.CodCia
                    Reporte-2.CodDoc = CcbCDocu.CodDoc
                    Reporte-2.NroDoc = CcbCDocu.NroDoc.

            RELEASE Ccbcdocu.
        END.
        /* Cierra la H/R */
        ASSIGN 
            Di-RutaC.FlgEst = "P".
        RELEASE Di-RutaC.
        RELEASE FacCorre.
    END. /* DO TRANSACTION... */

    /* IMPRESION DE COMPROBANTES */
    GUIAS:
    FOR EACH Reporte NO-LOCK,
            FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
                AND Ccbcdocu.coddoc = Reporte.coddoc
                AND Ccbcdocu.nrodoc = Reporte.nrodoc,
            FIRST Facdocum OF Reporte NO-LOCK
            BREAK BY Reporte.CodDoc:
        FIND FacCorre WHERE FacCorre.CodCia = Ccbcdocu.codcia
            AND FacCorre.CodDiv = Ccbcdocu.coddiv
            AND FacCorre.CodDoc = CcbCDocu.CodDoc 
            AND  FacCorre.NroSer = INTEGER(SUBSTRING(CcbCDocu.NroDoc,1,3))  
            NO-LOCK.
        IF FIRST-OF(Reporte.CodDoc) THEN DO:
            MESSAGE 'Preparar el papel para' FacDocum.NomDoc SKIP
                'en la impresora' FacCorre.PRINTER SKIP
                'Imprimimos los documentos (S-N)?'
                VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO
                UPDATE rpta-2 AS LOG.
            IF rpta-2 = NO THEN LEAVE GUIAS.
        END.
        IF TOGGLE-1 = NO 
        THEN RUN vta/d-fmtgui-04a (ROWID(CcbCDocu)).
        ELSE RUN vta/d-fmtgui-04b (ROWID(CcbCDocu)).
    END.
    FACTURAS:
    FOR EACH Reporte-2 NO-LOCK WHERE Reporte-2.CodDoc = 'FAC',
            FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
                AND Ccbcdocu.coddoc = Reporte-2.coddoc
                AND Ccbcdocu.nrodoc = Reporte-2.nrodoc,
            FIRST Facdocum OF Reporte NO-LOCK
            BREAK BY Reporte-2.CodDoc:
        FIND FacCorre WHERE FacCorre.CodCia = Ccbcdocu.codcia
            AND FacCorre.CodDiv = Ccbcdocu.coddiv
            AND FacCorre.CodDoc = CcbCDocu.CodDoc 
            AND  FacCorre.NroSer = INTEGER(SUBSTRING(CcbCDocu.NroDoc,1,3))  
            NO-LOCK.
        IF FIRST-OF(Reporte-2.CodDoc) THEN DO:
            MESSAGE 'Preparar el papel para' FacDocum.NomDoc SKIP
                'en la impresora' FacCorre.PRINTER SKIP
                'Imprimimos los documentos (S-N)?'
                VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO
                UPDATE rpta-3 AS LOG.
            IF rpta-3 = NO THEN LEAVE FACTURAS.
        END.
        RUN VTA\R-IMPFAC2 (ROWID(CcbCDocu)).
    END.
    BOLETAS:
    FOR EACH Reporte-2 NO-LOCK WHERE Reporte-2.CodDoc = 'BOL',
            FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
                AND Ccbcdocu.coddoc = Reporte-2.coddoc
                AND Ccbcdocu.nrodoc = Reporte-2.nrodoc,
            FIRST Facdocum OF Reporte NO-LOCK
            BREAK BY Reporte-2.CodDoc:
        FIND FacCorre WHERE FacCorre.CodCia = Ccbcdocu.codcia
            AND FacCorre.CodDiv = Ccbcdocu.coddiv
            AND FacCorre.CodDoc = CcbCDocu.CodDoc 
            AND  FacCorre.NroSer = INTEGER(SUBSTRING(CcbCDocu.NroDoc,1,3))  
            NO-LOCK.
        IF FIRST-OF(Reporte-2.CodDoc) THEN DO:
            MESSAGE 'Preparar el papel para' FacDocum.NomDoc SKIP
                'en la impresora' FacCorre.PRINTER SKIP
                'Imprimimos los documentos (S-N)?'
                VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO
                UPDATE rpta-4 AS LOG.
            IF rpta-4 = NO THEN LEAVE BOLETAS.
        END.
        RUN VTA\R-IMPBOL2 (ROWID(CcbCDocu)).
    END.

    RETURN 'OK'.

END PROCEDURE.



/*

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_GrabaTotales gDialog 
PROCEDURE proc_GrabaTotales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta/graba-totales-fac.i}

IF Ccbcdocu.coddoc = 'FAC' OR Ccbcdocu.coddoc = 'BOL' THEN DO:
    /* RHC 30-11-2006 Transferencia Gratuita */
    IF Ccbcdocu.FmaPgo = '900' THEN Ccbcdocu.sdoact = 0.
    IF Ccbcdocu.sdoact <= 0 
    THEN ASSIGN
            Ccbcdocu.fchcan = TODAY
            Ccbcdocu.flgest = 'C'.
END.

END PROCEDURE.

/*
  DEFINE VARIABLE dIGV AS DECIMAL NO-UNDO.
  DEFINE VARIABLE dISC AS DECIMAL NO-UNDO.


    Ccbcdocu.ImpDto = 0.
    Ccbcdocu.ImpIgv = 0.
    Ccbcdocu.ImpIsc = 0.
    Ccbcdocu.ImpTot = 0.
    Ccbcdocu.ImpExo = 0.
    FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
      dIGV = dIGV + Ccbddocu.ImpIgv.
      dISC = dISC + Ccbddocu.ImpIsc.
      Ccbcdocu.ImpTot = Ccbcdocu.ImpTot + Ccbddocu.ImpLin.
      IF NOT Ccbddocu.AftIgv THEN Ccbcdocu.ImpExo = Ccbcdocu.ImpExo + Ccbddocu.ImpLin.
      IF Ccbddocu.AftIgv THEN
          Ccbcdocu.ImpDto = Ccbcdocu.ImpDto +
              ROUND(Ccbddocu.ImpDto / (1 + Ccbcdocu.PorIgv / 100),2).
      ELSE Ccbcdocu.ImpDto = Ccbcdocu.ImpDto + Ccbddocu.ImpDto.
    END.
    Ccbcdocu.ImpIgv = ROUND(dIGV,2).
    Ccbcdocu.ImpIsc = ROUND(dISC,2).
    Ccbcdocu.ImpVta = Ccbcdocu.ImpTot - Ccbcdocu.ImpExo - Ccbcdocu.ImpIgv.
    IF Ccbcdocu.PorDto > 0 THEN DO:
      Ccbcdocu.ImpDto = Ccbcdocu.ImpDto +
          ROUND((Ccbcdocu.ImpVta + Ccbcdocu.ImpExo) * Ccbcdocu.PorDto / 100,2).
      Ccbcdocu.ImpTot = ROUND(Ccbcdocu.ImpTot * (1 - Ccbcdocu.PorDto / 100),2).
      Ccbcdocu.ImpVta = ROUND(Ccbcdocu.ImpVta * (1 - Ccbcdocu.PorDto / 100),2).
      Ccbcdocu.ImpExo = ROUND(Ccbcdocu.ImpExo * (1 - Ccbcdocu.PorDto / 100),2).
      Ccbcdocu.ImpIgv = Ccbcdocu.ImpTot - Ccbcdocu.ImpExo - Ccbcdocu.ImpVta.
    END.
    Ccbcdocu.ImpBrt = Ccbcdocu.ImpVta + Ccbcdocu.ImpIsc + Ccbcdocu.ImpDto + Ccbcdocu.ImpExo.
    Ccbcdocu.SdoAct = Ccbcdocu.ImpTot.
*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE xxx gDialog 
PROCEDURE xxx :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
        /* COMPROBANTES */
        FOR EACH Reporte,
                FIRST B-CDOCU WHERE B-CDOCU.codcia = s-codcia                   /* G/R */
                    AND B-CDOCU.coddoc = Reporte.coddoc
                    AND B-CDOCU.nrodoc = Reporte.nrodoc,
                FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = B-CDOCU.codcia  /* O/D */
                    AND Faccpedi.coddoc = B-CDOCU.codped                   
                    AND Faccpedi.nroped = B-CDOCU.nroped,
                FIRST B-CPEDI NO-LOCK WHERE B-CPEDI.codcia = s-codcia       /* PED */
                    AND B-CPEDI.coddoc = 'PED'
                    AND B-CPEDI.nroped = Faccpedi.nroref
                BREAK BY B-CPEDI.NroPed:
            cCodDoc = FacCPedi.Cmpbnte.      /* <<< OJO (FAC o BOL) <<< */
            /* Correlativo */
            FIND FacCorre WHERE
                FacCorre.CodCia = s-CodCia AND
                FacCorre.CodDoc = cCodDoc AND
                FacCorre.CodDiv = s-CodDiv AND
                FacCorre.NroSer = (IF cCodDoc = 'BOL' THEN INTEGER(COMBO-NroSer-3) ELSE INTEGER(COMBO-NroSer-2))
                EXCLUSIVE-LOCK NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                MESSAGE 'NO se encontro el correlativo para el documento' cCodDoc
                    VIEW-AS ALERT-BOX ERROR.
                UNDO trloop, RETURN 'ADM-ERROR'.
            END.
            CREATE Ccbcdocu.
            BUFFER-COPY B-CDOCU TO Ccbcdocu
                ASSIGN
                    Ccbcdocu.coddoc = cCodDoc
                    /*Ccbcdocu.coddiv = s-CodDiv*/
                    Ccbcdocu.coddiv = B-CPEDI.CodDiv        /* CARGA A LA DIVISION DEL PEDIDO */
                    CcbCDocu.NroDoc =  STRING(FacCorre.NroSer,"999") +
                                        STRING(FacCorre.Correlativo,"999999") 
                    CcbCDocu.FchDoc = TODAY
                    CcbCDocu.FchVto = TODAY
                    CcbCDocu.FlgEst = "P"       /* PENDIENTE */
                    CcbCDocu.FlgAte = "D"
                    CcbCDocu.TpoFac = "R"       /* <<< OJO <<< */
                    CcbCDocu.Tipo   = 'OFICINA'
                    CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
                    CcbCDocu.usuario = S-USER-ID
                    CcbCDocu.HorCie = STRING(TIME,'hh:mm')
                    FacCorre.Correlativo = FacCorre.Correlativo + 1.
            FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
                AND gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clie  THEN DO:
                ASSIGN 
                    CcbCDocu.CodDpto = gn-clie.CodDept 
                    CcbCDocu.CodProv = gn-clie.CodProv 
                    CcbCDocu.CodDist = gn-clie.CodDist.
            END.
            /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
            FIND GN-VEN WHERE gn-ven.codcia = s-codcia
                AND gn-ven.codven = ccbcdocu.codven
                NO-LOCK NO-ERROR.
            IF AVAILABLE GN-VEN THEN ccbcdocu.cco = gn-ven.cco.
            /* ACTUALIZA VENCIMIENTOS */
            FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
            IF AVAILABLE gn-convt 
                THEN ASSIGN Ccbcdocu.FchVto = TODAY + gn-ConVt.TotDias.
            /* OTROS DATOS */
            ASSIGN
                Ccbcdocu.TipVta = (IF Ccbcdocu.coddoc = 'FAC' THEN '1' ELSE '2')
                Ccbcdocu.CodRef = B-CDOCU.CodDoc
                Ccbcdocu.NroRef = B-CDOCU.nrodoc.
            /* DETALLE */
            FOR EACH B-DDOCU OF B-CDOCU NO-LOCK:
                CREATE Ccbddocu.
                BUFFER-COPY B-DDOCU TO Ccbddocu
                    ASSIGN
                        Ccbddocu.coddiv = Ccbcdocu.coddiv
                        Ccbddocu.coddoc = Ccbcdocu.coddoc
                        Ccbddocu.nrodoc = Ccbcdocu.nrodoc.
            END.
            RUN proc_GrabaTotales.

            /* RHC 22.10.08 APLICACION DE FACTURAS ADELANTADAS */
            /*IF s-aplic-fact-ade = YES THEN DO:*/
                RUN Carga-Factura-Adelantada.
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.
                RUN proc_GrabaTotales.
            /*END.*/

            ASSIGN
                B-CDOCU.CodRef = Ccbcdocu.coddoc
                B-CDOCU.NroRef = Ccbcdocu.nrodoc.
            /* TRACKING FACTURAS */
            IF FIRST-OF(B-CPEDI.NroPed) THEN DO:
                s-FechaT = DATETIME(TODAY, MTIME).
                RUN gn/pTracking (s-CodCia,
                                  B-CPEDI.CodDiv,
                                  s-CodDiv,
                                  B-CPEDI.CodDoc,
                                  B-CPEDI.NroPed,
                                  s-User-Id,
                                  'EFAC',
                                  'C',
                                  'IO',
                                  s-FechaI,
                                  s-FechaT,
                                  Ccbcdocu.coddoc,
                                  Ccbcdocu.nrodoc).
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
            END.
            /* Carga H/Ruta */
            CREATE Di-RutaD.
            BUFFER-COPY Di-RutaC TO Di-RutaD
                ASSIGN
                    di-rutad.codref = ccbcdocu.coddoc
                    di-rutad.nroref = ccbcdocu.nrodoc
                    di-rutad.horest = DI-RutaC.HorSal.
            RELEASE Di-RutaD.
            /*RDP*/    
            CREATE Reporte-2.
                ASSIGN 
                    Reporte-2.CodCia = CcbCDocu.CodCia
                    Reporte-2.CodDoc = CcbCDocu.CodDoc
                    Reporte-2.NroDoc = CcbCDocu.NroDoc.

            RELEASE Ccbcdocu.
        END.
*/        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

