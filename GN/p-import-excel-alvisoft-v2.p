&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description : Crea un nuevo registro en PL-PERS siguiendo las reglas de Progress

    Author(s)   :
    Created     :
    Notes       : 
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pcArchivoExcel AS CHAR NO-UNDO.

DEF OUTPUT PARAMETER pcReturn AS CHAR NO-UNDO.


DEF VAR s-codcia AS INTE INIT 001 NO-UNDO.      /* Solo Continental */

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
         HEIGHT             = 5.5
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Leemos registro por registro */
RUN Import_Excel.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Import_Excel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Import_Excel Procedure 
PROCEDURE Import_Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Determinamos si exite el archivo */
DEFINE VARIABLE cFoundPath AS CHARACTER NO-UNDO.

/* Usa SEARCH para verificar la existencia del archivo */
ASSIGN cFoundPath = SEARCH(pcArchivoExcel).

IF TRUE <> (cFoundPath > '') THEN DO:
    pcReturn = "Error: " + "El archivo NO existe en la ruta: " + pcArchivoExcel.
    RETURN.
END.

DEFINE VARIABLE chExcelApplication          AS COM-HANDLE.
DEFINE VARIABLE chWorkbook                  AS COM-HANDLE.
DEFINE VARIABLE chWorksheet                 AS COM-HANDLE.
DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.

/* CREAMOS LA HOJA EXCEL */
CREATE "Excel.Application" chExcelApplication.
chWorkbook = chExcelApplication:Workbooks:OPEN(pcArchivoExcel).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

SESSION:SET-WAIT-STATE('GENERAL').

ASSIGN
    t-Column = 0
    t-Row = 1.    
/* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
cValue = chWorkSheet:Cells(1,1):VALUE.
IF cValue = "" OR cValue = ? THEN DO:
    pcReturn = "Error: " + 'Formato del archivo Excel errado'.
    RETURN.
END.

DEF VAR cCodPer AS CHAR NO-UNDO.
DEF VAR cTpoDocId AS CHAR NO-UNDO.
DEF VAR cNroDocId AS CHAR NO-UNDO.
DEF VAR cNombre AS CHAR NO-UNDO.
DEF VAR dFchIng AS DATE NO-UNDO.
DEF VAR dFchCese AS DATE NO-UNDO.
DEF VAR cPatPer AS CHAR NO-UNDO.
DEF VAR cMatPer AS CHAR NO-UNDO.
DEF VAR cNomPer AS CHAR NO-UNDO.
DEF VAR iInicio AS INTE NO-UNDO.
DEF VAR x-CodAux AS CHAR NO-UNDO.

DEF BUFFER B-Pers FOR pl-pers.
DISABLE TRIGGERS FOR LOAD OF PL-PERS.

ASSIGN
    t-Row = 1.     /* Saltamos el encabezado de los campos */
REPEAT:
    ASSIGN
        t-Row    = t-Row + 1.
    /* CODIGO */
    t-column = 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
    cCodPer = cValue.
    /* Tipo de documento */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    CASE cValue:
        WHEN "DOC. NACIONAL DE IDENTIDAD" THEN cTpoDocId = "01".
        WHEN "CARNÉ DE EXTRANJERÍA" THEN cTpoDocId = "04".
        WHEN "REG. UNICO DE CONTRIBUYENTES" THEN cTpoDocId = "06".
        WHEN "PASAPORTE" THEN cTpoDocId = "07".
        WHEN "PARTIDA DE NACIMIENTO" THEN cTpoDocId = "11".
        OTHERWISE cTpoDocId = cValue.
    END CASE.
    /* Nro. de documento */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    cNroDocId = cValue.
    /* Trabajador */
    t-Column = t-Column + 1.
    cValue = TRIM(chWorkSheet:Cells(t-Row, t-Column):VALUE).
    cNombre = cValue.
    cNomPer = TRIM(ENTRY(2,cNombre,", ")).
    cPatPer = TRIM(ENTRY(1,cNombre," ")).
    cMatPer = "".
    iInicio = LENGTH(cPatPer) + 2. 
    REPEAT:
        cMatPer = cMatPer + SUBSTRING(cNombre,iInicio,1).
        iInicio = iInicio + 1.
        IF SUBSTRING(cNombre,iInicio,1) = ","  THEN LEAVE.
        IF iInicio > 100 THEN LEAVE.
    END.
    /* Fecha de Ingreso */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    dFchIng = DATE(cValue) NO-ERROR.
    /* Fecha de Cese */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    dFchCese = DATE(cValue) NO-ERROR.

    /* ACTUALIZAMOS LA PLANILLA CONTINENTAL */
    FIND FIRST pl-pers WHERE pl-pers.tpodocid = cTpoDocId AND pl-pers.nrodocid = cNroDocId NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN DO:
        /* Actualizamos Alvisoft */
        FIND CURRENT pl-pers EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN NEXT.
        IF AVAILABLE pl-pers THEN pl-pers.lmilit = cCodPer.
    END.
    ELSE DO:
        FIND LAST B-Pers WHERE B-Pers.CodPer > "" AND INTEGER(B-Pers.CodPer) < 999998
            NO-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE B-Pers THEN DO:
            x-CodAux = '000001'.
        END.
        x-CodAux = STRING(INTEGER(B-Pers.CodPer) + 1, '999999').
        CREATE pl-pers.
        ASSIGN
            pl-pers.codcia = s-codcia
            pl-pers.codper = x-CodAux
            pl-pers.tpodocid = cTpoDocId
            pl-pers.nrodocid = cNroDocId
            pl-pers.nomper = cNomPer
            pl-pers.patper = cPatPer
            pl-pers.matper = cMatPer
            pl-pers.lmilit = cCodPer
            NO-ERROR
            .
        IF ERROR-STATUS:ERROR = YES THEN UNDO, NEXT.
    END.
    IF AVAILABLE(pl-pers) THEN RELEASE pl-pers.
END.
SESSION:SET-WAIT-STATE('').

/* CERRAMOS EL EXCEL */
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

