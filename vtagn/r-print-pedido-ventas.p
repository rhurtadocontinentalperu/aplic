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

/* Librerias

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN <libreria> PERSISTENT SET hProc.

RUN <libreria>.rutina_interna IN hProc (input  buffer tt-excel:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-excel:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.

*/


/* ***************************  Definitions  ************************** */
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR RB-REPORT-LIBRARY               AS CHAR                     NO-UNDO.
DEF VAR RB-REPORT-NAME                  AS CHAR                     NO-UNDO.
DEF VAR RB-INCLUDE-RECORDS              AS CHAR INITIAL ""          NO-UNDO.
DEF VAR RB-FILTER                       AS CHAR INITIAL ""          NO-UNDO.
DEF VAR RB-OTHER-PARAMETERS             AS CHAR INITIAL ""          NO-UNDO.
DEF VAR RB-DB-CONNECTION                AS CHAR INITIAL ""          NO-UNDO.
DEF VAR RB-MEMO-FILE                    AS CHAR INITIAL ""          NO-UNDO.
DEF VAR RB-PRINT-DESTINATION            AS CHAR INITIAL ""          NO-UNDO.
DEF VAR RB-PRINTER-NAME                 AS CHAR INITIAL ""          NO-UNDO.
DEF VAR RB-PRINTER-PORT                 AS CHAR INITIAL ""          NO-UNDO.
DEF VAR RB-OUTPUT-FILE                  AS CHAR INITIAL ""          NO-UNDO.
DEF VAR RB-NUMBER-COPIES                AS INTEGER INITIAL 1        NO-UNDO.
DEF VAR RB-BEGIN-PAGE                   AS INTEGER INITIAL 0        NO-UNDO.
DEF VAR RB-END-PAGE                     AS INTEGER INITIAL 0        NO-UNDO.
DEF VAR RB-TEST-PATTERN                 AS LOGICAL INITIAL NO       NO-UNDO.
DEF VAR RB-WINDOW-TITLE                 AS CHARACTER INITIAL ""     NO-UNDO.
DEF VAR RB-DISPLAY-ERRORS               AS LOGICAL INITIAL YES      NO-UNDO.
DEF VAR RB-DISPLAY-STATUS               AS LOGICAL INITIAL YES      NO-UNDO.
DEF VAR RB-NO-WAIT                      AS LOGICAL INITIAL NO       NO-UNDO.

/* capturamos ruta inicial */
DEF VAR S-REPORT-LIBRARY AS CHAR.
GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE s-report-library.

DEFINE TEMP-TABLE Detalle
    FIELD codcia AS INT
    FIELD CodAlm LIKE Almmmate.CodAlm
    FIELD codmat AS CHAR FORMAT 'x(6)'
    FIELD desmat AS CHAR FORMAT 'x(43)'
    FIELD desmar AS CHAR FORMAT 'x(10)'
    FIELD candes AS DEC  FORMAT '>>,>>9.99'
    FIELD UndBas LIKE Almmmatg.UndBas
    FIELD undvta AS CHAR FORMAT 'x(8)'
    FIELD codzona AS CHAR FORMAT 'x(8)'
    FIELD codubi AS CHAR FORMAT 'x(5)'
    FIELD ruta   AS INT  FORMAT '>9'
    FIELD CodKit AS LOGICAL
    FIELD Glosa  AS CHARACTER
    FIELD codmat1 AS CHAR FORMAT 'x(6)'
    FIELD desmat1 AS CHAR FORMAT 'x(45)'
    FIELD desmar1 AS CHAR FORMAT 'x(10)'
    FIELD candes1 AS DEC  FORMAT '>>,>>9.99'
    FIELD UndBas1 LIKE Almmmatg.UndBas
    FIELD undvta1 AS CHAR FORMAT 'x(8)'
    FIELD codubi1 AS CHAR FORMAT 'x(5)'
    FIELD Glosa1  AS CHARACTER
    FIELD Empaque AS CHAR FORMAT 'x(25)'
    .


DEF BUFFER b-Detalle FOR Detalle.

DEF VAR s-Task-No AS INTE NO-UNDO.

DEF VAR DES-DIV  AS CHARACTER FORMAT "X(25)".
DEF VAR x-NroSal AS CHAR NO-UNDO.
DEF VAR X-ALMDES LIKE CcbDDocu.AlmDes NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fGetEmpaque) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fGetEmpaque Procedure 
FUNCTION fGetEmpaque RETURNS CHARACTER
  ( INPUT pCantidad AS dec )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 9.81
         WIDTH              = 55.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-PED_Charge_Report) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PED_Charge_Report Procedure 
PROCEDURE PED_Charge_Report :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pTitulo AS CHAR.

DEFINE VAR lKit     AS LOGICAL     NO-UNDO.

FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK,
    FIRST Almmmatg OF Ccbddocu NO-LOCK,
    FIRST Almmmate NO-LOCK WHERE Almmmate.codcia = Ccbddocu.codcia
    AND Almmmate.codmat = Ccbddocu.codmat
    AND Almmmate.codalm = Ccbddocu.almdes:
    CREATE Detalle.
    ASSIGN
        Detalle.codcia = s-codcia
        Detalle.codalm = Ccbddocu.almdes
        Detalle.codmat = Almmmatg.codmat
        Detalle.desmat = Almmmatg.desmat
        Detalle.desmar = Almmmatg.desmar
        Detalle.candes = Ccbddocu.candes * Ccbddocu.factor      /* En Unidades Base */
        Detalle.undvta = Ccbddocu.undvta
        Detalle.undbas = Almmmatg.undbas
        Detalle.codubi = Almmmate.codubi.
    FIND Almtubic OF Almmmate NO-LOCK NO-ERROR.
    IF AVAILABLE Almtubic THEN Detalle.codzona = Almtubic.codzona.
    /* RHC 12/01/2012 Luis Nerio solicita se haga la impresión corrida */
    /* 08/02/2012 También Elizabeth Urbano */
    CASE Almmmate.codalm:
        WHEN "04" OR WHEN "05" OR WHEN "31" THEN DO:
            Detalle.codzona = 'G-0'.
        END.
    END CASE.
    /* 20/00/2025 Felix Perez: mostrar también los empaques */
    ASSIGN
        Detalle.Empaque = fGetEmpaque(Detalle.candes).
END.
/*Buscando Kits*/
FOR EACH Detalle:
    lKit = NO.
    IF lKit THEN DELETE Detalle.
END.

DEF VAR x-Ruta AS INT.
FOR EACH Detalle BY Detalle.codubi:
    x-Ruta = x-Ruta + 1.
    Detalle.Ruta = x-Ruta.
END.

/* CARGAMOS LO MISMO PERO POR DESCRIPCION */
x-Ruta = 1.
FOR EACH Detalle BREAK BY Detalle.codcia BY Detalle.DesMat:
    FIND b-Detalle WHERE b-Detalle.Ruta = x-Ruta.
    ASSIGN
        b-Detalle.codmat1 = Detalle.codmat
        b-Detalle.desmat1 = Detalle.desmat
        b-Detalle.desmar1 = Detalle.desmar
        b-Detalle.undbas1 = Detalle.undbas
        b-Detalle.codubi1 = Detalle.codubi
        b-Detalle.candes1 = Detalle.candes.
    x-Ruta = x-Ruta + 1.
END.

/* Cargamos el archivo de impresión */
DEF VAR n-Item AS INTE NO-UNDO.

s-Task-No = 0.
n-Item = 0.
REPEAT:
    s-task-no = RANDOM(1,999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no AND
                    w-report.llave-c = s-user-id NO-LOCK)
        THEN LEAVE.
END.
FOR EACH Detalle NO-LOCK BY Detalle.codcia BY Detalle.CodZona BY Detalle.CodUbi:
    n-Item = n-Item + 1.
    /* LLAVE */
    CREATE w-report.
    ASSIGN
        w-report.task-no = s-task-no
        w-report.llave-c = s-user-id
        w-report.Campo-C[1] = Ccbcdocu.coddoc
        w-report.Campo-C[2] = Ccbcdocu.nrodoc.
    /* QUIEBRE */
    ASSIGN
        w-report.Campo-C[30] = Detalle.CodZona.
    /* DETALLE */
    ASSIGN
        w-report.Llave-I = n-Item
        w-report.Campo-C[3] = Detalle.codmat
        w-report.Campo-C[4] = Detalle.desmat
        w-report.Campo-C[5] = Detalle.desmar
        w-report.Campo-F[1] = Detalle.candes
        w-report.Campo-C[6] = Detalle.undbas
        w-report.Campo-C[7] = Detalle.codubi
        .
    /* DATOS DE CABECERA */
    ASSIGN
        w-report.Campo-C[10] = pTitulo
        w-report.Campo-C[11] = Des-Div
        w-report.Campo-C[12] = Ccbcdocu.codped
        w-report.Campo-C[13] = Ccbcdocu.nroped
        w-report.Campo-C[14] = Ccbcdocu.Libre_c01
        w-report.Campo-C[15] = Ccbcdocu.Libre_c02
        w-report.Campo-C[16] = x-NroSal
        w-report.Campo-C[17] = CcbCDocu.NomCli
        w-report.Campo-C[18] = CcbCDocu.CodVen
        w-report.Campo-C[19] = CcbCDocu.DirCli
        w-report.Campo-C[20] = X-ALMDES
        w-report.Campo-C[21] = CcbCDocu.Glosa
        w-report.Campo-C[22] = Detalle.Empaque
        .
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PED_Print_Document) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PED_Print_Document Procedure 
PROCEDURE PED_Print_Document :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* La búsqueda se basa en el comprobante */
DEFINE INPUT PARAMETER pRowid AS ROWID NO-UNDO.     /* FAC o BOL */
DEFINE INPUT PARAMETER pVersion   AS CHAR.
DEFINE OUTPUT PARAMETER pError AS CHAR NO-UNDO.
/* pVersion:
    "O": ORIGINAL 
    "R": RE-IMPRESION 
*/    
FIND ccbcdocu WHERE ROWID(ccbcdocu) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu OR Ccbcdocu.flgest = "A" THEN RETURN.

DEF VAR pCodDiv AS CHAR NO-UNDO.
DEF VAR pCodDoc AS CHAR NO-UNDO.
DEF VAR pNroDoc AS CHAR NO-UNDO.

FIND Faccpedi WHERE Faccpedi.codcia = s-codcia AND
    Faccpedi.coddoc = Ccbcdocu.libre_c01 AND
    Faccpedi.nroped = Ccbcdocu.libre_c02
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi OR Faccpedi.flgest = "A" THEN RETURN.
ASSIGN
    pCodDiv = Faccpedi.coddiv
    pCodDoc = Faccpedi.coddoc
    pNroDoc = Faccpedi.nroped.

/* LO GUARDO POR SI ACASO 
/* Datos del pedido */
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE INPUT PARAMETER pCodDoc AS CHAR.     /* O/M */
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE INPUT PARAMETER pVersion   AS CHAR.
DEFINE OUTPUT PARAMETER pError AS CHAR NO-UNDO.
/* pVersion:
    "O": ORIGINAL 
    "R": RE-IMPRESION 
*/    
/* Buscamos el pedido */
FIND Faccpedi WHERE Faccpedi.codcia = s-codcia AND
    Faccpedi.coddiv = pCodDiv AND
    Faccpedi.coddoc = pCodDoc AND
    Faccpedi.nroped = pNroDoc
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN.
IF Faccpedi.flgest = 'A' THEN RETURN.
/* Buscamos la FAC o BOL */
FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia AND
    Ccbcdocu.codped = Faccpedi.codref AND
    Ccbcdocu.nroped = Faccpedi.nroref AND
    Ccbcdocu.libre_c01 = Faccpedi.coddoc AND 
    Ccbcdocu.libre_c02 = Faccpedi.nroped AND 
    (Ccbcdocu.coddoc = 'BOL' OR Ccbcdocu.coddoc = 'FAC')
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbcdocu THEN RETURN.
IF Ccbcdocu.flgest = "A" THEN RETURN.
***************************** */

FIND gn-divi WHERE gn-divi.codcia = s-codcia AND
    gn-divi.coddiv = pCodDiv NO-LOCK NO-ERROR.
IF AVAILABLE GN-DIVI THEN DES-DIV = GN-DIVI.DesDiv.
ELSE DES-DIV = "".

FIND Almcmov WHERE Almcmov.codcia = Ccbcdocu.codcia
    AND Almcmov.codref = Ccbcdocu.coddoc
    AND Almcmov.nroref = Ccbcdocu.nrodoc
    NO-LOCK NO-ERROR.
IF AVAILABLE Almcmov THEN x-NroSal = STRING(Almcmov.nrodoc).
ELSE x-NroSal = "".

x-AlmDes = Ccbcdocu.CodAlm.

/* Definimos los parámetros de la impresión */
/* Programa base para la impresión de O/M */
DEF VAR s-Tabla AS CHAR NO-UNDO.
DEF VAR pFormato AS CHAR INIT 'TCK' NO-UNDO.
DEF VAR pImpresionDirecta AS LOG INIT YES NO-UNDO.
DEF VAR pImpresora AS CHAR NO-UNDO.

s-Tabla = "CFG_FMT_IMP_OM".
RB-REPORT-LIBRARY = s-report-library + "ccb/rbccb.prl".
RB-REPORT-NAME    = "Imprime Orden Despacho".

FIND Factabla WHERE FacTabla.CodCia = s-codcia AND
    FacTabla.Tabla = s-tabla AND
    FacTabla.Codigo = pCodDiv
    NO-LOCK NO-ERROR.
IF AVAILABLE Factabla THEN DO:
    pFormato = Factabla.Campo-C[01].
    pImpresionDirecta = Factabla.Campo-L[01].
    IF Factabla.Campo-C[02] > "" THEN RB-REPORT-LIBRARY = s-report-library + Factabla.Campo-C[02].
    IF Factabla.Campo-C[03] > "" THEN RB-REPORT-NAME = Factabla.Campo-C[03].
END.
IF pFormato = "NO" THEN RETURN "OK".

FIND Faccorre WHERE FacCorre.CodCia = s-codcia AND
    FacCorre.CodDiv = pCodDiv AND
    FacCorre.CodDoc = pCodDoc AND
    FacCorre.NroSer = INTEGER(SUBSTRING(pNroDoc,1,3))
    NO-LOCK NO-ERROR.
IF AVAILABLE Faccorre THEN pImpresora = FacCorre.Printer.

/* Cargamos los datos a imprimir */
RUN PED_Charge_Report (INPUT pVersion).
IF NOT CAN-FIND(FIRST Detalle NO-LOCK) THEN DO:
    pError = "NO hay nada que imprimir".
    RETURN.
END.

RUN PED_Send_to_Printer (pImpresionDirecta,
                         pImpresora,
                         pVersion,
                         pFormato,
                         OUTPUT pError).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PED_Print_Laser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PED_Print_Laser Procedure 
PROCEDURE PED_Print_Laser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pTitulo AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* Conectamos a la base de datos de impresión */
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
        pMensaje = "No se pudieron ubicar las credenciales para" + CHR(10) +
                "la conexión del REPORTBUILDER" + CHR(10) +
                "--------------------------------------------" + CHR(10) +
                "Comunicarse con el área de sistemas - desarrollo".
        RETURN.
    END.

   ASSIGN
       cNewConnString =
       "-db" + cDelimeter + cDatabaseName + cDelimeter +
       "-H" + cDelimeter + cHostName + cDelimeter +
       "-N" + cDelimeter + cNetworkProto + cDelimeter +
       "-S" + cDelimeter + cPortNumber + cDelimeter +
       "-U " + x-rb-user  + cDelimeter + cDelimeter +
       "-P " + x-rb-pass + cDelimeter + cDelimeter.

   IF cOtherParams > '' THEN cNewConnString = cNewConnString + cOtherParams + cDelimeter.
   RB-DB-CONNECTION = cNewConnString.
END.

/* ¿cuantas hojas se van a imprimir? */
DEF VAR x-Pagina AS INT NO-UNDO.
DEF VAR x-TotalPaginas AS INT NO-UNDO.

ASSIGN
    x-Pagina = 0
    x-TotalPaginas = 0.
FOR EACH Detalle BREAK BY Detalle.codzona:
    IF FIRST-OF(Detalle.codzona) THEN x-TotalPaginas = x-TotalPaginas + 1.
END.
/* ****************************************************************************** */
RB-INCLUDE-RECORDS = "O".
RB-FILTER = " w-report.task-no = " + STRING(s-task-no) +  
              " AND w-report.llave-c = '" + s-user-id + "'".
RB-OTHER-PARAMETERS = "s-Titulo = " + pTitulo +
    "~ns-Paginas = " + STRING(x-TotalPaginas).

ASSIGN
    RB-BEGIN-PAGE = s-pagina-inicial
    RB-END-PAGE = s-pagina-final
    RB-PRINTER-NAME = s-port-name       /*s-printer-name*/
    RB-OUTPUT-FILE = s-print-file
    RB-NUMBER-COPIES = s-nro-copias.

CASE s-salida-impresion:
  WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
  WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
  WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
END CASE.
/*
MESSAGE RB-REPORT-LIBRARY SKIP
    RB-REPORT-NAME SKIP
    RB-INCLUDE-RECORDS SKIP
    RB-FILTER SKIP
    RB-PRINTER-NAME SKIP 
    RB-PRINTER-PORT SKIP
    RB-OTHER-PARAMETERS.
*/
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PED_Print_Matricial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PED_Print_Matricial Procedure 
PROCEDURE PED_Print_Matricial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pImprimeDirecto AS LOG NO-UNDO.
DEF INPUT PARAMETER pTitulo AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR n-item  AS INTE NO-UNDO.

DEFINE FRAME F-DetaFac
    N-Item         FORMAT "ZZ9"          COLUMN-LABEL '   '
    Detalle.codmat                      COLUMN-LABEL 'CODIGO'
    Detalle.desmat FORMAT 'x(45)'       COLUMN-LABEL 'D E S C R I P C I O N '
    Detalle.desmar FORMAT 'x(8)'       COLUMN-LABEL 'MARCA'
    Detalle.candes FORMAT '>>>>>>9.99'  COLUMN-LABEL 'CANTIDAD'
    Detalle.undbas FORMAT 'x(4)'        COLUMN-LABEL 'U.M.'
    Detalle.CodUbi FORMAT 'x(8)'        COLUMN-LABEL 'ZONA'
    WITH NO-BOX STREAM-IO WIDTH 320 DOWN.

DEFINE FRAME F-HdrFac
    HEADER 
    {&PRN7A} + {&PRN6A} + pTitulo + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT 'x(20)' 
    SKIP
    DES-DIV FORMAT "X(40)"  
    TODAY FORMAT "99/99/9999" STRING(TIME,"HH:MM:SS") 
    SKIP 
    "Numero de"
    {&PRN7A} + {&PRN6A} + ccbcdocu.coddoc + " :" + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(8)"
    {&PRN7A} + {&PRN6A} + ccbcdocu.nrodoc + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "XXXXXX-XXXXXXXXXXXX" 
    SKIP
    "Nro. de Pedido : " 
    {&PRN7A} + {&PRN6A} + CcbCDocu.CodPed CcbCDocu.NroPed + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT 'x(20)' 
    SKIP
    {&PRN7A} + {&PRN6A} + STRING(Ccbcdocu.Libre_c01, 'x(3)') STRING(Ccbcdocu.Libre_c02, 'x(12)') + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT 'x(20)' 
    SKIP
    "Orden Despacho : " x-NroSal FORMAT 'x(20)' 
    SKIP
    "Cliente   : " CcbCDocu.NomCli FORMAT "x(40)"
    SKIP     
    "Vendedor  : " CcbCDocu.CodVen FORMAT "X(40)"
    SKIP
    "Direccion : " CcbCDocu.DirCli FORMAT "x(50)" 
    SKIP
    "Almacen   : " {&Prn6a} + X-ALMDES + {&Prn6b} FORMAT "X(20)" 
    SKIP
    "OBS : " CAPS(CcbCDocu.Glosa) FORMAT "X(50)" 
    SKIP
    "Sacador: ____________________" FORMAT "x(30)" 
    "Chequeador: ____________________" AT 45 FORMAT "x(30)"  
    SKIP
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 320.

/* ¿cuantas hojas se van a imprimir? */
DEF VAR x-Pagina AS INT NO-UNDO.
DEF VAR x-TotalPaginas AS INT NO-UNDO.

ASSIGN
    x-Pagina = 0
    x-TotalPaginas = 0.
FOR EACH Detalle BREAK BY Detalle.codzona:
    IF FIRST-OF(Detalle.codzona) THEN x-TotalPaginas = x-TotalPaginas + 1.
END.

/*MESSAGE pImprimeDirecto SKIP s-port-name.*/

IF pImprimeDirecto = YES THEN DO:
    OUTPUT TO PRINTER VALUE(s-port-name) PAGE-SIZE 31.
END.
ELSE DO:
    OUTPUT TO PRINTER PAGE-SIZE 31.
END.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN4}.     
FOR EACH Detalle BREAK BY Detalle.codcia BY Detalle.CodZona BY Detalle.CodUbi:
    VIEW FRAME F-HdrFac.
    n-item = n-item + 1.    
    DISPLAY 
        n-item 
        Detalle.codmat 
        Detalle.desmat 
        Detalle.desmar 
        Detalle.candes 
        Detalle.undbas 
        Detalle.CodUbi 
        WITH FRAME F-DetaFac.
    IF LAST-OF(Detalle.CodZona) THEN DO:
        x-Pagina = x-Pagina + 1.
        DOWN 1 WITH FRAME f-DetaFac.
        DISPLAY
            'Pagina: ' + STRING(x-Pagina, '99') + ' de ' + STRING(x-TotalPaginas, '99') @ Detalle.desmat
            WITH FRAME f-DetaFac.
        PAGE.
    END.
    IF LAST-OF(Detalle.codcia) THEN PAGE.
END.
OUTPUT CLOSE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PED_Send_to_Printer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PED_Send_to_Printer Procedure 
PROCEDURE PED_Send_to_Printer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pImprimeDirecto AS LOG.
DEFINE INPUT PARAMETER pNombreImpresora AS CHAR.
DEFINE INPUT PARAMETER pVersion AS CHAR.
DEFINE INPUT PARAMETER pFormatoTck AS CHAR.
DEFINE OUTPUT PARAMETER pError AS CHAR NO-UNDO. 

/* ********************************************************************************************** */
/* 27/7/2023: Definir la impresora */
/* ********************************************************************************************** */
s-Printer-Name = pNombreImpresora.

DEF VAR Success AS LOGICAL NO-UNDO.
CASE TRUE:
    WHEN pImprimeDirecto = NO THEN DO:
        /* Solicitamos Impresora: OJO s-Printer-Name debe ser una variable GLOBAL */
/*         RUN bin/_prnctr.                                                                */
/*         IF s-salida-impresion = 0 THEN RETURN 'OK'.     /* Usuario NO desea imprimir */ */
/*         RUN lib/_port-name-v2.p (s-printer-name, OUTPUT s-port-name).                   */
        DEF VAR rpta AS LOG NO-UNDO.
        SYSTEM-DIALOG PRINTER-SETUP  UPDATE rpta.
        IF rpta = NO THEN RETURN.
    END.
    OTHERWISE DO:
        /* Buscamos impresora para impresión directa */
        IF TRUE <> (s-Printer-Name > '') THEN DO:     
            /* Impresora no definida */
            /* Capturo la impresora por defecto */
            RUN lib/_default_printer.p (OUTPUT s-printer-name, OUTPUT s-port-name, OUTPUT success).
            IF Success = NO THEN DO:
                pError = "NO hay una impresora por defecto definida".
                RETURN 'ADM-ERROR'.
            END.
            /* De acuerdo al sistema operativo transformamos el puerto de impresión */
            RUN lib/_port-name-v2.p (s-Printer-Name, OUTPUT s-Port-Name).
        END.
        ELSE DO:
            /* Impresora definida */            
            RUN lib/_port-name-v2.p (s-printer-name, OUTPUT s-port-name).
            IF TRUE <> (s-port-name > '') THEN DO:
                pError = 'NO está definida la impresora ' + CHR(10) +
                    'División: ' + Ccbcdocu.coddiv + CHR(10) +
                    'Documento: ' + Ccbcdocu.coddoc + CHR(10) +
                    'N° Serie: ' + SUBSTRING(CcbCDocu.NroDoc, 1, 3) + CHR(10) +
                    'Impresora: ' + s-printer-name + ' <<<'.
                RETURN 'ADM-ERROR'.
            END.
        END.
    END.
END CASE.
/* ********************************************************************************************** */
/* ********************************************************************************************** */
CASE pFormatoTck:
    WHEN "A4" THEN DO:
        RUN PED_Print_Laser (INPUT pVersion, OUTPUT pError).
    END.
    WHEN "TCK" THEN DO:
        RUN PED_Print_Matricial (INPUT pImprimeDirecto, INPUT pVersion, OUTPUT pError).
    END.
END CASE.

/* Borrar el temporal */
DEF BUFFER B-w-report FOR w-report.
DEFINE VAR lRowId AS ROWID.

FOR EACH w-report WHERE w-report.task-no = s-task-no AND w-report.llave-c =  s-user-id NO-LOCK:
    lRowId = ROWID(w-report).  
    FIND FIRST b-w-report WHERE ROWID(b-w-report) = lRowid EXCLUSIVE NO-ERROR.   
    IF AVAILABLE b-w-report THEN DO:
        DELETE b-w-report.            
    END.    
END.
RELEASE B-w-report.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fGetEmpaque) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fGetEmpaque Procedure 
FUNCTION fGetEmpaque RETURNS CHARACTER
  ( INPUT pCantidad AS dec ) :

    DEFINE VAR lRetVal AS CHAR INIT "".
    DEFINE VAR lSaldo AS DEC.
    DEFINE VAR lValor AS INT.

    lSaldo = pCantidad.
    IF lSaldo > 0 AND almmmatg.canemp > 0 THEN DO:
        lValor = TRUNCATE(lSaldo / almmmatg.canemp,0).
        IF lValor > 0 THEN DO:
            lRetVal = "M(" + STRING(lValor) + "/" + STRING(almmmatg.canemp) + " )".
        END.
        lSaldo = lSaldo - (lValor * almmmatg.canemp).
    END.
    IF lSaldo > 0 AND almmmatg.StkRep > 0 THEN DO:
        lValor = TRUNCATE(lSaldo / almmmatg.StkRep,0).
        IF lValor > 0 THEN DO:
            lRetVal = lRetVal + IF(lRetVal = "") THEN "" ELSE " ".
            lRetVal = lRetVal + "I(" + STRING(lValor) + "/" + STRING(almmmatg.StkRep) + ")".
        END.
        lSaldo = lSaldo - (lValor * almmmatg.StkRep).
    END.
    IF lSaldo > 0 THEN DO:
        lRetVal = lRetVal + IF(lRetVal = "") THEN "" ELSE " ".
        lRetVal = lRetVal + "U(" + STRING(lSaldo) + ")".
    END.


  RETURN lRetVal.   /* Function return value. */

  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

