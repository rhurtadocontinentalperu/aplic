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

DEF INPUT PARAMETER pcArchivoExcel AS CHAR NO-UNDO.
DEF INPUT PARAMETER pcForma AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pcReturn AS CHAR NO-UNDO.


/* pcForma:
CREATE: borra todo y graba
APPEND: graba solo los que no hay
*/


DEF SHARED VAR s-codcia AS INTE.

DEF VAR s-Tabla AS CHAR INIT "PL-PERS" NO-UNDO.

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
         HEIGHT             = 4.69
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Borramos toda la tabla */
RUN Clean_Records.
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN.

/* Leemos registro por registro */
RUN Import_Excel.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Clean_Records) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Clean_Records Procedure 
PROCEDURE Clean_Records :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Borramos toda la tabla */
IF pcForma = "CREATE" THEN DO TRANSACTION:
    FOR EACH FacTabla EXCLUSIVE-LOCK WHERE FacTabla.codcia = s-codcia AND FacTabla.tabla = s-Tabla:
        DELETE FacTabla.
    END.
    CATCH oneError AS PROGRESS.Lang.SysError:
        pcReturn = "Error: " + oneError:GetMessage(1).
        DELETE OBJECT oneError.
        RETURN 'ADM-ERROR'.
    END CATCH.
END.
IF AVAILABLE(FacTabla) THEN RELEASE FacTabla.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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
/* ******************* */
ASSIGN
    t-Row = 1.     /* Saltamos el encabezado de los campos */
REPEAT:
    ASSIGN
        t-Row    = t-Row + 1.
    /* CODIGO */
    t-column = 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
    FIND FacTabla WHERE FacTabla.codcia = s-codcia 
        AND FacTabla.tabla = s-Tabla
        AND FacTabla.codigo = cValue
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacTabla THEN NEXT.
    CREATE FacTabla.
    ASSIGN
        FacTabla.codcia = s-codcia 
        FacTabla.tabla = s-Tabla
        FacTabla.codigo = cValue.
    /* Tipo de documento */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        FacTabla.Campo-C[1] = cValue.
    /* Nro. de documento */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        FacTabla.Campo-C[2] = cValue.
    /* Trabajador */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        FacTabla.Nombre = cValue.
    /* Fecha de Ingreso */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        FacTabla.Campo-D[1] = DATE(cValue)
        NO-ERROR.
    /* Fecha de Cese */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        FacTabla.Campo-D[2] = DATE(cValue)
        NO-ERROR.
END.
/* Cruzamos con la planilla actual */
FOR EACH FacTabla EXCLUSIVE-LOCK WHERE FacTabla.codcia = s-codcia AND FacTabla.tabla = s-Tabla:
    FIND FIRST pl-pers WHERE pl-pers.codcia = s-codcia
        AND pl-pers.nrodocid = FacTabla.Campo-C[2]
        NO-LOCK NO-ERROR.
    IF AVAILABLE PL-PERS THEN FacTabla.Campo-C[20] = PL-PERS.codper.
END.
IF AVAILABLE(FacTabla) THEN RELEASE FacTabla.
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

