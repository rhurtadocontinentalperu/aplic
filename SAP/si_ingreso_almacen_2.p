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

DEF TEMP-TABLE toWareHouse LIKE oWareHouse.

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

/* 1.- Borramos todo */
DO TRANSACTION:
    FOR EACH oInventoryGenEntry_2_1 EXCLUSIVE-LOCK:
        DELETE oInventoryGenEntry_2_1.
    END.
    FOR EACH oInventoryGenEntry_2_2 EXCLUSIVE-LOCK:
        DELETE oInventoryGenEntry_2_2.
    END.
    FOR EACH oInventoryGenEntry_2_3 EXCLUSIVE-LOCK:
        DELETE oInventoryGenEntry_2_3.
    END.
END.

DEF VAR iContador AS INTE NO-UNDO.
DEF VAR iRegistros AS INTE NO-UNDO.

/* 2.- Por cada Almacén se va a gestionar Lotes */
EMPTY TEMP-TABLE toWareHouse.
FOR EACH oItems NO-LOCK WHERE oItems.ManageBatchNumbers = "tYES",
    EACH oInventoryGenEntry_1_2 NO-LOCK WHERE oInventoryGenEntry_1_2.ItemCode = oItems.ItemCode
    BREAK BY oInventoryGenEntry_1_2.WarehouseCode:
    IF FIRST-OF(oInventoryGenEntry_1_2.WarehouseCode) THEN DO:
        CREATE toWareHouse.
        toWareHouse.WarehouseCode = oInventoryGenEntry_1_2.WarehouseCode.
    END.
END.
FOR EACH toWareHouse NO-LOCK:
    iRegistros = iRegistros + 1.
    CREATE oInventoryGenEntry_2_1.
    ASSIGN
        oInventoryGenEntry_2_1.RecordKey = iRegistros
        oInventoryGenEntry_2_1.Comments = "Saldo Inicial - " + toWareHouse.WarehouseCode + " - Lotes"
        oInventoryGenEntry_2_1.DocCurrency = "SOL"
        oInventoryGenEntry_2_1.DocDate = cFecha 
        oInventoryGenEntry_2_1.DocDueDate = cFecha
        oInventoryGenEntry_2_1.JournalMemo = "Inventario al " + STRING(pdFechaCorte,'99/99/9999')
        .
    iContador = 0.
    FOR EACH oInventoryGenEntry_1_2 NO-LOCK WHERE oInventoryGenEntry_1_2.WarehouseCode = toWareHouse.WarehouseCode,
        FIRST oItems NO-LOCK WHERE oItems.ItemCode = oInventoryGenEntry_1_2.ItemCode 
            AND oItems.ManageBatchNumbers = "tYES"
        BY oInventoryGenEntry_1_2.RecordKey BY oInventoryGenEntry_1_2.LineNum:
        CREATE oInventoryGenEntry_2_2.
        ASSIGN
            oInventoryGenEntry_2_2.RecordKey = oInventoryGenEntry_2_1.RecordKey
            oInventoryGenEntry_2_2.LineNum = iContador
            oInventoryGenEntry_2_2.ItemCode = oItems.ItemCode
            oInventoryGenEntry_2_2.UnitPrice = oInventoryGenEntry_1_2.UnitPrice
            oInventoryGenEntry_2_2.WarehouseCode = oInventoryGenEntry_1_2.WarehouseCode
            oInventoryGenEntry_2_2.Quantity = oInventoryGenEntry_1_2.Quantity
            oInventoryGenEntry_2_2.AccountCode = "9902"
            oInventoryGenEntry_2_2.ShipDate = cFecha
            oInventoryGenEntry_2_2.Currency = "SOL"
            oInventoryGenEntry_2_2.LineTotal = oInventoryGenEntry_1_2.LineTotal
            oInventoryGenEntry_2_2.U_tipoOpT12 = "99"
            .
        CREATE oInventoryGenEntry_2_3.
        ASSIGN
            oInventoryGenEntry_2_3.RecordKey = oInventoryGenEntry_2_2.RecordKey
            oInventoryGenEntry_2_3.BaseLineNumber = oInventoryGenEntry_2_2.LineNum
            oInventoryGenEntry_2_3.LineNum = 0
            oInventoryGenEntry_2_3.Quantity = oInventoryGenEntry_2_2.Quantity
            oInventoryGenEntry_2_3.BatchNumber = cFecha
            oInventoryGenEntry_2_3.InternalSerialNumber = cFecha
            oInventoryGenEntry_2_3.ManufacturerSerialNumber = cFecha
            oInventoryGenEntry_2_3.AddmisionDate = cFecha
            oInventoryGenEntry_2_3.ExpiryDate = cFechaExp
            oInventoryGenEntry_2_3.ManufacturingDate = cFecha
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
DEF VAR c-xls-file AS CHAR INIT 'oInventoryGenEntry_2_1' NO-UNDO.
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
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER oInventoryGenEntry_2_1:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .

/* RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER oBusineesPartners:handle, */
/*                                   INPUT  c-csv-file,                     */
/*                                   OUTPUT c-xls-file) .                   */

/* Borramos librerias de la memoria */
SESSION:SET-WAIT-STATE('').

c-xls-file = 'oInventoryGenEntry_2_2'.
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
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER oInventoryGenEntry_2_2:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .
SESSION:SET-WAIT-STATE('').


c-xls-file = 'oInventoryGenEntry_2_3'.
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
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER oInventoryGenEntry_2_3:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .
SESSION:SET-WAIT-STATE('').

DELETE PROCEDURE hProc.

MESSAGE 'Proceso terminado con éxito' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

