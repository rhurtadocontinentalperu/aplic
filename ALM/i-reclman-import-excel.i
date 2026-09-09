&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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

DEFINE INPUT PARAMETER pcArchivo AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pMensaje AS LONGCHAR NO-UNDO.

DEFINE VARIABLE chExcelApplication          AS COM-HANDLE.
DEFINE VARIABLE chWorkbook                  AS COM-HANDLE.
DEFINE VARIABLE chWorksheet                 AS COM-HANDLE.
DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.
DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.

/* CREAMOS LA HOJA EXCEL */
CREATE "Excel.Application" chExcelApplication.
chWorkbook = chExcelApplication:Workbooks:OPEN(pcArchivo).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

SESSION:SET-WAIT-STATE('GENERAL').

ASSIGN
    t-Column = 0
    t-Row = 1.    
/* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
cValue = chWorkSheet:Cells(1,1):VALUE.
IF cValue = "" OR cValue = ? THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

DEF VAR cCodMat AS CHAR NO-UNDO.
DEF VAR fCanDes AS DECI NO-UNDO.


DEF VAR x-Item AS INT INIT 1 NO-UNDO.

FOR EACH B-ITEM BY B-ITEM.NroItm:
    x-Item = B-ITEM.NroItm + 1.
END.

ASSIGN
    pMensaje = ""
    t-Row = 1.     /* Saltamos el encabezado de los campos */
REPEAT:
    t-Row = t-Row + 1.
    t-column = 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
    /* CODIGO */
    cCodMat = cValue.
    /* CANTIDAD */
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    fCanDes = DECIMAL(cValue) NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = pMensaje + (IF TRUE <> (pMensaje > '') THEN '' ELSE CHR(10)) + 
            "Artículo: " + cCodMat + " No se pudo importar la cantidad".
        NEXT.
    END.
    /* CONSISTENCIA */
    FIND Almmmatg WHERE Almmmatg.CodCia = s-CodCia AND
         Almmmatg.CodMat = cCodMat
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        pMensaje = pMensaje + (IF TRUE <> (pMensaje > '') THEN '' ELSE CHR(10)) + 
            "Artículo: " + cCodMat + " No registrado en el maestro de artículos".
        NEXT.
    END. 
    FIND Almmmate WHERE Almmmate.CodCia = s-CodCia AND
         Almmmate.CodAlm = s-CodAlm AND
         Almmmate.CodMat = cCodMat
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN DO:
        pMensaje = pMensaje + (IF TRUE <> (pMensaje > '') THEN '' ELSE CHR(10)) + 
            "Artículo: " + cCodMat + " No asginado al almacén " + s-codalm.
        NEXT.
    END.
    /* SOLO ARTÍCULOS NUEVOS */
    IF CAN-FIND(FIRST {&Tabla} WHERE {&Tabla}.codmat = cCodMat NO-LOCK) THEN NEXT.
    CREATE {&Tabla}.
    ASSIGN
        {&Tabla}.NroItm = x-Item
        {&Tabla}.Factor = 1
        {&Tabla}.CodCia = s-codcia
        {&Tabla}.CodMat = cCodMat
        {&Tabla}.CanDes = fCanDes
        {&Tabla}.CodUnd = Almmmatg.UndStk.
    /* buscamos el precio promedio */
    FIND LAST Almstkge WHERE AlmStkge.CodCia = s-codcia
        AND AlmStkge.codmat = {&Tabla}.CodMat
        AND AlmStkge.Fecha <= TODAY
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almstkge THEN DO:
        ASSIGN
            {&Tabla}.PreUni = AlmStkge.CtoUni
            {&Tabla}.ImpCto = AlmStkge.CtoUni * {&Tabla}.CanDes.
    END.
    x-Item = x-Item + 1.
END.
SESSION:SET-WAIT-STATE('').
/* CERRAMOS EL EXCEL */
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

RUN dispatch IN THIS-PROCEDURE ('open-query':U).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


