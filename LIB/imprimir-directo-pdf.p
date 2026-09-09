&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT PARAMETER pLibraryPRL AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pReportName AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pFilter AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pRutaFilePDF AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pNameFilePDF AS CHAR NO-UNDO.

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "aplic/alm/rbalm.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Hoja Ruta2".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

DEFINE VAR x-ruta-pdf AS CHAR.

x-ruta-pdf = pRutaFilePDF.

IF SUBSTRING(pRutaFilePDF,LENGTH(pRutaFilePDF),1) <> "\" THEN DO:
    x-ruta-pdf = x-ruta-pdf + "\".
END.

pNameFilePDF = "".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

  /* Code placed here will execute AFTER standard behavior.    */
  GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
  ASSIGN
    /*
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'alm/RBALM.PRL'
    RB-REPORT-NAME = 'ingreso devolucion cliente alm'
    RB-INCLUDE-RECORDS = 'O'
    RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
    */
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + pLibraryPRL
    RB-REPORT-NAME = pReportName
    RB-INCLUDE-RECORDS = 'O'
    RB-FILTER = pFilter.

    DEFINE VARIABLE cDatabaseName    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cHostName        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cNetworkProto    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cPortNumber      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cOtherParams     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cNewConnString   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDelimeter       AS CHARACTER NO-UNDO.
    
    GET-KEY-VALUE SECTION "RBParametros" KEY "cDatabaseName" VALUE cDatabaseName.
    GET-KEY-VALUE SECTION "RBParametros" KEY "cHostName" VALUE cHostName.
    GET-KEY-VALUE SECTION "RBParametros" KEY "cNetworkProto" VALUE cNetworkProto.
    GET-KEY-VALUE SECTION "RBParametros" KEY "cPortNumber" VALUE cPortNumber.
    GET-KEY-VALUE SECTION "RBParametros" KEY "cOtherParams" VALUE cOtherParams.
    
    ASSIGN cDelimeter = CHR(32).
    IF NOT (cDatabaseName = ? OR cHostName = ? OR cNetworkProto = ? OR cPortNumber = ?) THEN DO:

        DEFINE VAR x-rb-user AS CHAR.
        DEFINE VAR x-rb-pass AS CHAR.
    
        RUN lib/RB_credenciales(OUTPUT x-rb-user, OUTPUT x-rb-pass).
    
        IF x-rb-user = "**NOUSER**" THEN DO:
            MESSAGE "No se pudieron ubicar las credenciales para" SKIP
                    "la conexion del REPORTBUILDER" SKIP
                    "--------------------------------------------" SKIP
                    "Comunicarse con el area de sistemas - desarrollo"
                VIEW-AS ALERT-BOX INFORMATION.
    
            RETURN "ADM-ERROR".
        END.
    
       ASSIGN
           cNewConnString =
           "-db" + cDelimeter + cDatabaseName + cDelimeter +
           "-H" + cDelimeter + cHostName + cDelimeter +
           "-N" + cDelimeter + cNetworkProto + cDelimeter +
           "-S" + cDelimeter + cPortNumber + cDelimeter +
           "-U " + x-rb-user  + cDelimeter + cDelimeter +
           "-P " + x-rb-pass + cDelimeter + cDelimeter.

       /*
       ASSIGN
           cNewConnString =
           "-db" + cDelimeter + cDatabaseName + cDelimeter +
           "-H" + cDelimeter + cHostName + cDelimeter +
           "-N" + cDelimeter + cNetworkProto + cDelimeter +
           "-S" + cDelimeter + cPortNumber + cDelimeter +
           "-U usrddigger"  + cDelimeter + cDelimeter +
           "-P udd1456" + cDelimeter + cDelimeter.
       */

       IF cOtherParams > '' THEN cNewConnString = cNewConnString + cOtherParams + cDelimeter.
       RB-DB-CONNECTION = cNewConnString.
    END.


    /*  */
    DEFINE VARIABLE x-current-printername AS CHARACTER NO-UNDO.

    x-current-printername          = SESSION:PRINTER-NAME.


    DEFINE VARIABLE x-new-printer-name AS CHARACTER.
    DEFINE VARIABLE x-new-ireturn AS INTEGER.

    IF CAPS(x-current-printername) <> "PDFCREATOR" THEN DO:
        x-new-printer-name = "PDFCreator".
        RUN SetDefaultPrinterA(INPUT x-new-printer-name, OUTPUT x-new-ireturn).

        IF x-new-ireturn <> 1 THEN DO:
            MESSAGE "No esta instalado la impresora " + x-new-printer-name.
            RETURN.
        END.
    END.

    DOS Silent VALUE("taskkill /F /IM PDFCreator.exe /T").

    /*Variáveis de instancia PDFCreator*/
    DEFINE VARIABLE PDFObjQueue AS COM-HANDLE      NO-UNDO.
    DEFINE VARIABLE PDF AS COM-HANDLE      NO-UNDO.
    DEFINE VARIABLE PDFObj AS COM-HANDLE      NO-UNDO.
    DEFINE VARIABLE PDFPrintJob AS HANDLE      NO-UNDO.

    CREATE "PDFCreator.PDFCreatorObj" pdfObj NO-ERROR.
    IF NOT VALID-HANDLE (pdfobj) THEN DO:
        MESSAGE "ERROR AL INICIAR EL PDFCreator" SKIP
                ERROR-STATUS:GET-MESSAGE(1).
        RETURN.
    END.
    CREATE "PDFCreator.JobQueue" PDFObjQueue NO-ERROR.
    IF NOT VALID-HANDLE (PDFObjQueue) THEN DO:
        MESSAGE "ERROR COLA DE IMPRESION DEL PDFCreator - PDFObj" SKIP
                ERROR-STATUS:GET-MESSAGE(1).
        RETURN.
    END.

    PDFObjQueue:Initialize() NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        MESSAGE "ERROR AL INICIALIZAR LA COLA DE IMPRESION DEL PDFCreator" SKIP
                ERROR-STATUS:GET-MESSAGE(1).
    END.

    /* La impresora a imprimir */
    DEFINE VAR x-filer AS CHAR.
    x-filer = PDFObj:GetPDFCreatorPrinters.

    s-Printer-Name = x-new-printer-name.

    /* 4 De acuerdo al sistema operativo transformamos el puerto de impresión */
    RUN lib/_port-name-v2.p (s-Printer-Name, OUTPUT s-Port-Name).    

    RB-BEGIN-PAGE = 1.
    RB-END-PAGE = 99999999.
    RB-PRINTER-NAME = s-port-name.       /*s-printer-name*/
    /*RB-PRINTER-PORT = s-port-name*/
    RB-OUTPUT-FILE = s-print-file.
    RB-NUMBER-COPIES = s-nro-copias.

    /* -------------------------- */

    RUN aderb/_prntrb2 (RB-REPORT-LIBRARY,
                      RB-REPORT-NAME,
                      RB-DB-CONNECTION,
                      RB-INCLUDE-RECORDS,
                      RB-FILTER,
                      RB-MEMO-FILE,
                      RB-PRINT-DESTINATION,
                      RB-PRINTER-NAME,
                      RB-PRINTER-PORT,
                      RB-OUTPUT-FILE,
                      RB-NUMBER-COPIES,
                      RB-BEGIN-PAGE,
                      RB-END-PAGE,
                      RB-TEST-PATTERN,
                      RB-WINDOW-TITLE,
                      RB-DISPLAY-ERRORS,
                      RB-DISPLAY-STATUS,
                      RB-NO-WAIT,
                      RB-OTHER-PARAMETERS,  
                      "").
    /* ------------------------------------------------------- */
    DEFINE VAR x-sec AS INT.
    DEFINE VAR x-sec1 AS INT.

    DEFINE VAR x-file-pdf AS CHAR.
    DEFINE VAR x-file AS CHAR.

    /* Nombre del File */
    x-file-pdf = pReportName + "_".
    x-file-pdf = x-file-pdf + replace(replace(replace(STRING(NOW,"99/99/9999 HH:MM:SS"),"/","-"),":","-")," ","_").

    x-sec1 = 0.

    ATRAPAR_PRINT:
    REPEAT x-sec = 1 TO 30:
        PDFObjQueue:WaitForJob(1).
        IF PDFObjQueue:COUNT = 0 THEN DO:
            /**/
        END.
        ELSE DO:
            pdfObj = PDFObjQueue:NextJob.
            x-sec1 = 1.
            LEAVE ATRAPAR_PRINT.
        END.
    END.

    IF x-sec1 = 0 THEN DO:
        /**/
    END.
    ELSE DO:
        pdfObj:SetProfileByGuid("DefaultGuid").
        pdfObj:SetProfileSetting("ShowProgress", "False").
        x-file = x-ruta-pdf + "\" + x-file-pdf.
        pdfObj:ConvertTo(x-file).
    END.

    /*encerrar processo*/
    pdfobjQueue:ReleaseCom.

    RELEASE OBJECT pdfobj.
    RELEASE OBJECT PDFObjQueue.
    DOS Silent VALUE("taskkill /F /IM PDFCreator.exe /T").

    RUN SetDefaultPrinterA(INPUT x-current-printername, OUTPUT x-new-ireturn).

    pNameFilePDF = x-file.

    RETURN "OK".
    


PROCEDURE SetDefaultPrinterA EXTERNAL "WINSPOOL.drv":U :
    DEFINE INPUT PARAMETER pszPrinter AS CHARACTER.
    DEFINE RETURN PARAMETER ireturn AS LONG.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


