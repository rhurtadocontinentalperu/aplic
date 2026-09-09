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
         HEIGHT             = 5.69
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

cFecha = REPLACE(ISO-DATE(pdFechaCorte),'-','').

/* 1.- Limpiamos datos */
DO TRANSACTION:
    FOR EACH oPMX_Saldos_1_1 EXCLUSIVE-LOCK:
        DELETE oPMX_Saldos_1_1.
    END.
    FOR EACH oPMX_Saldos_1_2 EXCLUSIVE-LOCK:
        DELETE oPMX_Saldos_1_2.
    END.
    FOR EACH oPMX_Saldos_1_3 EXCLUSIVE-LOCK:
        DELETE oPMX_Saldos_1_3.
    END.
END.
/* 2.- Cabecera */
DO TRANSACTION:
    CREATE oPMX_Saldos_1_1.
    ASSIGN
        oPMX_Saldos_1_1.DocNum = 1
        oPMX_Saldos_1_1.DocDate = cFecha
        oPMX_Saldos_1_1.Comments = "Entrada de mercancias para PMX Go-live"
        oPMX_Saldos_1_1.JournalMemo = "Entrada de mercancias para PMX Go-live"
        .
END.

DEF VAR iContador AS INTE NO-UNDO.

/* 3.- Detalle */
FOR EACH oInventoryGenEntry_4_2 NO-LOCK WHERE oInventoryGenEntry_4_2.warehousecode BEGINS '88',
    FIRST oInventoryGenEntry_4_3 NO-LOCK WHERE oInventoryGenEntry_4_3.parentkey = oInventoryGenEntry_4_2.RecordKey
    AND oInventoryGenEntry_4_3.BaseLineNumber = oInventoryGenEntry_4_2.LineNum,
    FIRST oBinLocation NO-LOCK WHERE oBinLocation.Warehouse = oInventoryGenEntry_4_2.warehousecode
    AND oBinLocation.AbsEntry = oInventoryGenEntry_4_3.BinAbsEntry:
    CREATE oPMX_Saldos_1_2.
    oPMX_Saldos_1_2.ParentKey = 1.
    oPMX_Saldos_1_2.LineNum = iContador.
    oPMX_Saldos_1_2.ItemCode = oInventoryGenEntry_4_2.ItemCode.
    oPMX_Saldos_1_2.LineTotal = oInventoryGenEntry_4_2.LineTotal.
    oPMX_Saldos_1_2.Currency = oInventoryGenEntry_4_2.Currency.
    oPMX_Saldos_1_2.WarehouseCode = oInventoryGenEntry_4_2.warehousecode.
    oPMX_Saldos_1_2.Quantity = oInventoryGenEntry_4_2.Quantity.
    oPMX_Saldos_1_2.U_PMX_LOCO = oBinLocation.BinCode2.
    oPMX_Saldos_1_2.U_PMAX_QUAN = oInventoryGenEntry_4_2.Quantity.
    

    FOR EACH oInventoryGenEntry_5_2 NO-LOCK WHERE oInventoryGenEntry_5_2.warehousecode = oInventoryGenEntry_4_2.warehousecode
        AND oInventoryGenEntry_5_2.itemcode = oInventoryGenEntry_4_2.itemcode,
        EACH oInventoryGenEntry_5_3 NO-LOCK WHERE oInventoryGenEntry_5_3.parentkey = oInventoryGenEntry_5_2.parentkey
        AND oInventoryGenEntry_5_3.baselinenumber = oInventoryGenEntry_5_2.linenum:
        CREATE oPMX_Saldos_1_3.
        oPMX_Saldos_1_3.AddmisionDate = oInventoryGenEntry_5_3.addmisiondate.
        oPMX_Saldos_1_3.ParentKey = oPMX_Saldos_1_2.ParentKey.
        oPMX_Saldos_1_3.BaseLineNumber = oPMX_Saldos_1_2.LineNum.
        oPMX_Saldos_1_3.BatchNumber = oInventoryGenEntry_5_3.batchnumber.
        oPMX_Saldos_1_3.ExpiryDate = oInventoryGenEntry_5_3.expirydate.
        oPMX_Saldos_1_3.Quantity = oInventoryGenEntry_5_3.quantity.

        oPMX_Saldos_1_2.U_PMX_BATC = oInventoryGenEntry_5_3.batchnumber.
        oPMX_Saldos_1_2.U_PMX_BBDT = oInventoryGenEntry_5_3.expirydate.
    END.
    iContador = iContador + 1.
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
DEF VAR c-xls-file AS CHAR INIT 'oPMX_Saldos_1_1' NO-UNDO.
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
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER oPMX_Saldos_1_1:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .

/* RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER oBusineesPartners:handle, */
/*                                   INPUT  c-csv-file,                     */
/*                                   OUTPUT c-xls-file) .                   */

/* Borramos librerias de la memoria */
SESSION:SET-WAIT-STATE('').

c-xls-file = 'oPMX_Saldos_1_2'.
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
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER oPMX_Saldos_1_2:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .

SESSION:SET-WAIT-STATE('').

c-xls-file = 'oPMX_Saldos_1_3'.
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
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER oPMX_Saldos_1_3:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .
SESSION:SET-WAIT-STATE('').

DELETE PROCEDURE hProc.

MESSAGE 'Proceso terminado con éxito' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

