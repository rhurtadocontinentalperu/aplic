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
                    Los programas deben ejecutarse en orden
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pcProceso AS CHAR NO-UNDO.
DEF INPUT PARAMETER pdFechaCorte AS DATE NO-UNDO.

CASE pcProceso:
    WHEN "To-Table" THEN RUN To-Table.
    WHEN "To-Text"  THEN RUN To-Text.
END CASE.

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
         HEIGHT             = 5.65
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-To-Table) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE To-Table Procedure 
PROCEDURE To-Table :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR cFecha AS CHAR NO-UNDO.
DEF VAR cFechaExp AS CHAR NO-UNDO.

cFecha = REPLACE(ISO-DATE(pdFechaCorte),'-','').
cFechaExp = REPLACE(ISO-DATE(ADD-INTERVAL(pdFechaCorte,18,'months')),'-','').

/* 1.- Cabecera */
DO TRANSACTION:
    FOR EACH oInventoryGenEntry_5_1 EXCLUSIVE-LOCK:
        DELETE oInventoryGenEntry_5_1.
    END.
    CREATE oInventoryGenEntry_5_1.
    ASSIGN
        oInventoryGenEntry_5_1.DocNum = 1
        oInventoryGenEntry_5_1.Comments = "Saldos Iniciales - "
        oInventoryGenEntry_5_1.DocCurrency = "SOL"
        oInventoryGenEntry_5_1.DocDueDate = cFecha
        oInventoryGenEntry_5_1.DocDate = cFecha
        oInventoryGenEntry_5_1.JournalMemo = "Saldos iniciales " + STRING(pdFechaCorte,'99/99/9999')
        .
    RELEASE oInventoryGenEntry_5_1.
END.

DEF VAR iContador AS INTE NO-UNDO.
DEF VAR iRegistros AS INTE NO-UNDO.

DO TRANSACTION:
    FOR EACH oInventoryGenEntry_5_2 EXCLUSIVE-LOCK:
        DELETE oInventoryGenEntry_5_2.
    END.
    RELEASE oInventoryGenEntry_5_2.
    FOR EACH oInventoryGenEntry_5_3 EXCLUSIVE-LOCK:
        DELETE oInventoryGenEntry_5_3.
    END.
    RELEASE oInventoryGenEntry_5_3.
    FOR EACH oInventoryGenEntry_5_4 EXCLUSIVE-LOCK:
        DELETE oInventoryGenEntry_5_4.
    END.
    RELEASE oInventoryGenEntry_5_4.
END.


iContador = 0.
iRegistros = 0.
FOR EACH oItems NO-LOCK WHERE oItems.ManageBatchNumbers = "tYES" BY oItems.ItemCode:
    /* Ingreso Detalle Alm:  */
    FOR EACH oInventoryGenEntry_4_2 NO-LOCK WHERE oInventoryGenEntry_4_2.ItemCode = oItems.ItemCode,
        EACH oInventoryGenEntry_4_3 NO-LOCK WHERE oInventoryGenEntry_4_3.ParentKey = 1
        AND oInventoryGenEntry_4_3.BaseLineNumber = oInventoryGenEntry_4_2.LineNum:
        /* Solo hay un registro por cada artículo */
        CREATE oInventoryGenEntry_5_2. 
        ASSIGN
            oInventoryGenEntry_5_2.ParentKey = 1        /* OJO */
            oInventoryGenEntry_5_2.LineNum = iContador
            oInventoryGenEntry_5_2.ItemCode = oItems.ItemCode
            oInventoryGenEntry_5_2.UnitPrice = oInventoryGenEntry_4_2.UnitPrice
            oInventoryGenEntry_5_2.Quantity = oInventoryGenEntry_4_2.Quantity
            oInventoryGenEntry_5_2.WarehouseCode = oInventoryGenEntry_4_2.WarehouseCode
            oInventoryGenEntry_5_2.AccountCode = "9902"
            oInventoryGenEntry_5_2.ShipDate = cFecha
            oInventoryGenEntry_5_2.Currency = "SOL"
            oInventoryGenEntry_5_2.LineTotal = oInventoryGenEntry_4_2.LineTotal
            oInventoryGenEntry_5_2.U_tipoOpT12 = "99"
            .
        /* SOlo hay un registro por cada artículo */
        CREATE oInventoryGenEntry_5_3.
        ASSIGN
            oInventoryGenEntry_5_3.ParentKey = oInventoryGenEntry_5_2.ParentKey
            oInventoryGenEntry_5_3.BaseLineNumber = oInventoryGenEntry_5_2.LineNum
            oInventoryGenEntry_5_3.LineNum = iRegistros
            oInventoryGenEntry_5_3.BatchNumber = cFecha
            oInventoryGenEntry_5_3.InternalSerialNumber = cFecha
            oInventoryGenEntry_5_3.ManufacturerSerialNumber = cFecha
            oInventoryGenEntry_5_3.AddmisionDate = cFecha
            oInventoryGenEntry_5_3.ExpiryDate = cFechaExp
            oInventoryGenEntry_5_3.Quantity = oInventoryGenEntry_5_2.Quantity
            oInventoryGenEntry_5_3.ManufacturingDate = cFecha
            .
        /* Solo hay un registro por cada artículo */
        CREATE oInventoryGenEntry_5_4.
        ASSIGN
            oInventoryGenEntry_5_4.ParentKey = oInventoryGenEntry_5_3.ParentKey
            oInventoryGenEntry_5_4.BaseLineNumber = oInventoryGenEntry_5_3.BaseLineNumber
            oInventoryGenEntry_5_4.SerialAndBatchNumbersBaseLine = oInventoryGenEntry_5_3.LineNum
            oInventoryGenEntry_5_4.LineNum = iRegistros
            oInventoryGenEntry_5_4.BinAbsEntry = oInventoryGenEntry_4_3.BinAbsEntry
            oInventoryGenEntry_5_4.Quantity = oInventoryGenEntry_5_3.Quantity
            oInventoryGenEntry_5_4.AllowNegativeQuantity = "tNO"
            /*oInventoryGenEntry_5_4.codubiprogress = */
            .
        iContador = iContador + 1.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-To-Text) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE To-Text Procedure 
PROCEDURE To-Text :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


/* Archivo de Salida */
DEF VAR c-csv-file AS CHAR NO-UNDO.
DEF VAR c-xls-file AS CHAR INIT 'oInventoryGenEntry_5_1' NO-UNDO.
DEF VAR rpta AS LOG INIT NO NO-UNDO.

SYSTEM-DIALOG GET-FILE c-xls-file
    FILTERS 'Libro de Excel' '*.csv'
    INITIAL-FILTER 1
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION ".csv"
    SAVE-AS
    TITLE "Guardar como"
    USE-FILENAME
    UPDATE rpta.
IF rpta = NO THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').
/* Variable de memoria */
DEFINE VAR hProc AS HANDLE NO-UNDO.
/* Levantamos la libreria a memoria */
RUN lib\Tools-to-excel PERSISTENT SET hProc.


/* Programas que generan el Excel */
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER oInventoryGenEntry_5_1:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .

/* RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER oBusineesPartners:handle, */
/*                                   INPUT  c-csv-file,                     */
/*                                   OUTPUT c-xls-file) .                   */

/* Borramos librerias de la memoria */
SESSION:SET-WAIT-STATE('').

c-xls-file = 'oInventoryGenEntry_5_2'.
SYSTEM-DIALOG GET-FILE c-xls-file
    FILTERS 'Libro de Excel' '*.csv'
    INITIAL-FILTER 1
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION ".csv"
    SAVE-AS
    TITLE "Guardar como"
    USE-FILENAME
    UPDATE rpta.
IF rpta = NO THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').
/* Programas que generan el Excel */
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER oInventoryGenEntry_5_2:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .
SESSION:SET-WAIT-STATE('').


c-xls-file = 'oInventoryGenEntry_5_3'.
SYSTEM-DIALOG GET-FILE c-xls-file
    FILTERS 'Libro de Excel' '*.csv'
    INITIAL-FILTER 1
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION ".csv"
    SAVE-AS
    TITLE "Guardar como"
    USE-FILENAME
    UPDATE rpta.
IF rpta = NO THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').
/* Programas que generan el Excel */
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER oInventoryGenEntry_5_3:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .
SESSION:SET-WAIT-STATE('').

c-xls-file = 'oInventoryGenEntry_5_4'.
SYSTEM-DIALOG GET-FILE c-xls-file
    FILTERS 'Libro de Excel' '*.csv'
    INITIAL-FILTER 1
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION ".csv"
    SAVE-AS
    TITLE "Guardar como"
    USE-FILENAME
    UPDATE rpta.
IF rpta = NO THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').
/* Programas que generan el Excel */
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER oInventoryGenEntry_5_4:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .
SESSION:SET-WAIT-STATE('').



DELETE PROCEDURE hProc.

MESSAGE 'Proceso terminado con éxito' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

