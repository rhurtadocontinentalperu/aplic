&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
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

FIND Ccbcdocu WHERE ROWID(Ccbcdocu) = rwParaRowID NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbcdocu THEN DO:
    MESSAGE
        "Registro de" Ccbcdocu.coddoc "no disponible"
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
IF NOT (Ccbcdocu.FlgEst = "P" AND Ccbcdocu.FlgCon = 'P') THEN DO:
    MESSAGE
        "Registro de" Ccbcdocu.coddoc "ya no está 'PENDIENTE'"
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
cCodAlm = Ccbcdocu.Codalm.      /* <<< OJO <<< */

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
    AND FacCorre.CodAlm = cCodAlm       /* <<< OJO <<< */
    AND FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE
        "Codigo de Documento" cCodDoc "no configurado para el almacén" cCodAlm
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

/* CONSISTENCIA DE TRACKING */
FIND Faccpedi WHERE Faccpedi.codcia = Ccbcdocu.codcia
    AND Faccpedi.coddoc = Ccbcdocu.codped
    AND Faccpedi.nroped = Ccbcdocu.nroped
    NO-LOCK.
FIND Vtatrack03 WHERE VtaTrack03.CodCia = s-codcia
    AND VtaTrack03.CodDiv = Faccpedi.coddiv
    AND VtaTrack03.CodDoc = Faccpedi.coddoc
    NO-LOCK NO-ERROR.
IF AVAILABLE Vtatrack03 THEN DO:
    FIND Vtatrack01 OF Vtatrack03 NO-LOCK NO-ERROR.     /* Definicion del tracking */
END.

DEFINE TEMP-TABLE Reporte NO-UNDO
    FIELDS CodCia LIKE CcbCDocu.CodCia
    FIELDS CodDoc LIKE CcbCDocu.CodDoc
    FIELDS NroDoc LIKE CcbCDocu.Nrodoc.

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

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-NroSer Btn_OK Btn_Cancel FILL-IN-Glosa ~
FILL-IN-LugEnt RECT-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodDoc FILL-IN-NroPed ~
FILL-IN-Cliente FILL-IN-DirClie COMBO-NroSer FILL-IN-NroDoc FILL-IN-items ~
FILL-IN-Glosa FILL-IN-LugEnt 

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

DEFINE VARIABLE FILL-IN-Cliente AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 4 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodDoc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

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

DEFINE VARIABLE FILL-IN-NroPed AS CHARACTER FORMAT "X(9)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70 BY 5.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     FILL-IN-CodDoc AT ROW 1.81 COL 7 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     FILL-IN-NroPed AT ROW 1.81 COL 11 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     FILL-IN-Cliente AT ROW 1.81 COL 28 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-DirClie AT ROW 2.62 COL 28 COLON-ALIGNED WIDGET-ID 24
     COMBO-NroSer AT ROW 3.69 COL 5.28 WIDGET-ID 2
     FILL-IN-NroDoc AT ROW 3.69 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     FILL-IN-items AT ROW 6.12 COL 63 COLON-ALIGNED WIDGET-ID 18
     Btn_OK AT ROW 7.46 COL 2
     Btn_Cancel AT ROW 7.46 COL 14
     FILL-IN-Glosa AT ROW 5.31 COL 11 COLON-ALIGNED WIDGET-ID 28
     FILL-IN-LugEnt AT ROW 4.5 COL 11 COLON-ALIGNED WIDGET-ID 30
     RECT-1 AT ROW 1.27 COL 2 WIDGET-ID 4
     SPACE(1.28) SKIP(2.34)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Generando Guia(s) de Remisión por FAC o BOL" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
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
/* SETTINGS FOR FILL-IN FILL-IN-Cliente IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodDoc IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DirClie IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-items IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroPed IN FRAME gDialog
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
ON WINDOW-CLOSE OF FRAME gDialog /* Generando Guia(s) de Remisión por FAC o BOL */
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

    FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
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
        FILL-IN-LugEnt
        FILL-IN-Glosa.

    CASE pTipoGuia:
        WHEN 'A' THEN DO:       /* AUTOMATICA */
            RUN proc_CreaGuia.
            IF RETURN-VALUE = 'ADM-ERROR' THEN
                MESSAGE
                    "Ninguna guía fué generada"
                    VIEW-AS ALERT-BOX WARNING.
            ELSE DO:
                MESSAGE
                    "Se ha generado la guía"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
/*                 RUN Papel-Blanco. */
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
  DISPLAY FILL-IN-CodDoc FILL-IN-NroPed FILL-IN-Cliente FILL-IN-DirClie 
          COMBO-NroSer FILL-IN-NroDoc FILL-IN-items FILL-IN-Glosa FILL-IN-LugEnt 
      WITH FRAME gDialog.
  ENABLE COMBO-NroSer Btn_OK Btn_Cancel FILL-IN-Glosa FILL-IN-LugEnt RECT-1 
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
    DO WITH FRAME {&FRAME-NAME}:
        COMBO-NroSer:LIST-ITEMS = cListItems.
        COMBO-NroSer = ENTRY(1,COMBO-NroSer:LIST-ITEMS).
        FILL-IN-items = FacCfgGn.Items_Guias.
        FILL-IN-CodDoc = Ccbcdocu.CodDoc.
        FILL-IN-NroPed = Ccbcdocu.NroDoc.
        FILL-IN-Glosa = Ccbcdocu.Glosa.
        FILL-IN-LugEnt = Ccbcdocu.LugEnt.
        FILL-IN-Cliente = Ccbcdocu.CodCli + " - " + Ccbcdocu.NomCli.
        FILL-IN-DirClie = Ccbcdocu.DirCli.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CreaGuia gDialog 
PROCEDURE proc_CreaGuia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*Borrando Temporal*/
    FOR EACH Reporte.
        DELETE Reporte.
    END.

    trloop:
    DO TRANSACTION ON ERROR UNDO trloop, RETURN 'ADM-ERROR' ON STOP UNDO trloop, RETURN 'ADM-ERROR':
        FIND Ccbcdocu WHERE ROWID(Ccbcdocu) = rwParaRowID EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Ccbcdocu THEN DO:
            MESSAGE
                "Registro de" Ccbcdocu.coddoc "no disponible"
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
        IF Ccbcdocu.FlgEst <> "P" OR Ccbcdocu.FlgCon <> "P" THEN DO:
            MESSAGE
                "Registro de" Ccbcdocu.coddoc "ya no está 'PENDIENTE'"
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.

        /* Correlativo */
        FIND FacCorre WHERE
            FacCorre.CodCia = s-CodCia AND
            FacCorre.CodDoc = cCodDoc AND
            FacCorre.CodDiv = s-CodDiv AND
            FacCorre.NroSer = INTEGER(COMBO-NroSer)
            EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR THEN UNDO trloop, RETURN 'ADM-ERROR'.

         /* Cabecera de Guía */
        CREATE B-CDocu.
        BUFFER-COPY Ccbcdocu TO B-CDOCU
            ASSIGN
                B-CDocu.CodCia = s-CodCia
                B-CDocu.CodDiv = Ccbcdocu.CodDiv
                B-CDocu.CodDoc = cCodDoc
                B-CDocu.NroDoc =  STRING(FacCorre.NroSer,"999") +
                                    STRING(FacCorre.Correlativo,"999999") 
                B-CDocu.FchDoc = TODAY
                B-CDocu.CodMov = cCodMov
                B-CDocu.CodAlm = cCodAlm
                B-CDocu.CodPed = Ccbcdocu.CodPed 
                B-CDocu.NroPed = Ccbcdocu.NroPed
                B-CDocu.CodRef = Ccbcdocu.CodDoc 
                B-CDocu.NroRef = Ccbcdocu.NroDoc
                B-CDocu.Tipo   = "OFICINA"
                B-CDocu.FchVto = TODAY
                B-CDocu.TpoFac = "R"       /* GUIA VENTA AUTOMATICA */
                B-CDocu.TpoCmb = FacCfgGn.TpoCmb[1]
                B-CDocu.FlgEst = "P"       /* CHEQUEADA */
                B-CDocu.FlgSit = "P"
                B-CDocu.usuario = S-USER-ID
                B-CDocu.HorCie = STRING(TIME,'hh:mm')
                B-CDocu.LugEnt = FILL-IN-LugEnt
                B-CDocu.Glosa = FILL-IN-Glosa
                FacCorre.Correlativo = FacCorre.Correlativo + 1.
        /* TRACKING */
        s-FechaT = DATETIME(TODAY, MTIME).
        RUN gn/pTracking-01 (s-CodCia,
                          s-CodDiv,
                          Ccbcdocu.CodPed,
                          Ccbcdocu.NroPed,
                          s-User-Id,
                          'EGUI',
                          'P',
                          s-FechaI,
                          s-FechaT,
                          Ccbcdocu.coddoc,
                          Ccbcdocu.nrodoc,
                          Ccbcdocu.coddoc,
                          Ccbcdocu.nrodoc).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        /*RDP*/    
        CREATE Reporte.
            ASSIGN 
                Reporte.CodCia = B-CDocu.CodCia
                Reporte.CodDoc = B-CDocu.CodDoc
                Reporte.NroDoc = B-CDocu.NroDoc.
        FIND gn-convt WHERE gn-convt.Codig = B-CDocu.FmaPgo NO-LOCK NO-ERROR.
        IF AVAILABLE gn-convt THEN DO:
            B-CDocu.TipVta = IF gn-ConVt.TotDias = 0 THEN "1" ELSE "2".
            B-CDocu.FchVto = B-CDocu.FchDoc + INTEGER(ENTRY(NUM-ENTRIES(gn-ConVt.Vencmtos),gn-ConVt.Vencmtos)).
        END.
        FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
            AND gn-clie.CodCli = B-CDocu.CodCli 
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie  THEN DO:
            ASSIGN
                B-CDocu.CodDpto = gn-clie.CodDept 
                B-CDocu.CodProv = gn-clie.CodProv 
                B-CDocu.CodDist = gn-clie.CodDist.
        END.

        FOR EACH Ccbddocu OF Ccbcdocu BY Ccbddocu.NroItm:
            /* Crea Detalle */
            CREATE B-DDocu.
            BUFFER-COPY Ccbddocu TO B-DDocu
                ASSIGN
                    B-DDocu.CodCia = B-CDocu.CodCia
                    B-DDocu.Coddoc = B-CDocu.Coddoc
                    B-DDocu.NroDoc = B-CDocu.NroDoc 
                    B-DDocu.FchDoc = B-CDocu.FchDoc
                    B-DDocu.CodDiv = B-CDocu.CodDiv.
        END. /* FOR EACH Ccbddocu... */
        /* Descarga de Almacen */
        IF AVAILABLE Vtatrack01 THEN DO:
            IF Vtatrack01.Libre_c01 = 'X' THEN DO:
                RUN vta\act_alm (ROWID(CcbCDocu)).
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.
            END.
        END.
        ELSE DO:    /* Si no existe tracking definido de todas maneras descarga almacen */
            RUN vta\act_alm (ROWID(CcbCDocu)).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.
        END.
        /* Actualiza Estado de la Factura */
        ASSIGN
            Ccbcdocu.codref = B-CDOCU.coddoc
            Ccbcdocu.nroref = B-CDOCU.nrodoc
            Ccbcdocu.FlgCon = "".

        RELEASE Ccbcdocu.
        RELEASE FacCorre.
        RELEASE B-CDOCU.
        RELEASE B-DDOCU.
    END. /* DO TRANSACTION... */
    RETURN 'OK'.

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

