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
    FOR EACH oInventoryGenEntry_4_1 EXCLUSIVE-LOCK:
        DELETE oInventoryGenEntry_4_1.
    END.
    FOR EACH oInventoryGenEntry_4_2 EXCLUSIVE-LOCK:
        DELETE oInventoryGenEntry_4_2.
    END.
    FOR EACH oInventoryGenEntry_4_3 EXCLUSIVE-LOCK:
        DELETE oInventoryGenEntry_4_3.
    END.
END.
/* 2.- Cabecera */
DO TRANSACTION:
    CREATE oInventoryGenEntry_4_1.
    ASSIGN
        oInventoryGenEntry_4_1.RecordKey = 1
        oInventoryGenEntry_4_1.Comments = "Saldos Iniciales - " + STRING(pdFechaCorte,'99/99/9999')
        oInventoryGenEntry_4_1.DocCurrency = "SOL"
        oInventoryGenEntry_4_1.DocDueDate = cFecha
        oInventoryGenEntry_4_1.DocDate = cFecha
        oInventoryGenEntry_4_1.JournalMemo = "Inventarios al " + STRING(pdFechaCorte,'99/99/9999')
        .
END.

DEF VAR iContador AS INTE NO-UNDO.
DEF VAR iRegistros AS INTE NO-UNDO.

/* 3.- Detalle: Stock por almacén */
/* Los archivos son similares */
FOR EACH oInventoryGenEntry_1_2 NO-LOCK:
    CREATE oInventoryGenEntry_4_2.
    ASSIGN
        oInventoryGenEntry_4_2.RecordKey        =  oInventoryGenEntry_1_2.RecordKey    
        oInventoryGenEntry_4_2.LineNum          =  oInventoryGenEntry_1_2.LineNum      
        oInventoryGenEntry_4_2.ItemCode         =  oInventoryGenEntry_1_2.ItemCode     
        oInventoryGenEntry_4_2.UnitPrice        =  oInventoryGenEntry_1_2.UnitPrice    
        oInventoryGenEntry_4_2.Quantity         =  oInventoryGenEntry_1_2.Quantity     
        oInventoryGenEntry_4_2.WarehouseCode    =  oInventoryGenEntry_1_2.WarehouseCode
        oInventoryGenEntry_4_2.AccountCode      =  oInventoryGenEntry_1_2.AccountCode  
        oInventoryGenEntry_4_2.ShipDate         =  oInventoryGenEntry_1_2.ShipDate     
        oInventoryGenEntry_4_2.Currency         =  oInventoryGenEntry_1_2.Currency     
        oInventoryGenEntry_4_2.LineTotal        =  oInventoryGenEntry_1_2.LineTotal    
        oInventoryGenEntry_4_2.U_tipoOpT12      =  oInventoryGenEntry_1_2.U_tipoOpT12  
        .
END.

/* 4.- Detalle: Stock por almacén y ubicación */
iContador = 0.
FOR EACH oInventoryGenEntry_4_2 NO-LOCK:
    CREATE oInventoryGenEntry_4_3.
    ASSIGN
        oInventoryGenEntry_4_3.ParentKey = oInventoryGenEntry_4_2.RecordKey
        oInventoryGenEntry_4_3.BaseLineNumber = oInventoryGenEntry_4_2.LineNum
        oInventoryGenEntry_4_3.LineNum = iContador
        oInventoryGenEntry_4_3.Quantity = oInventoryGenEntry_4_2.Quantity
        /*oInventoryGenEntry_4_3.AllowNegativeQuantity */
        .
    FIND pro.Almmmate WHERE pro.Almmmate.codcia = 1
        AND pro.Almmmate.codalm = oInventoryGenEntry_4_2.WarehouseCode
        AND pro.Almmmate.codmat = oInventoryGenEntry_4_2.ItemCode
        NO-LOCK NO-ERROR.
    IF AVAILABLE pro.Almmmate THEN DO:
        FIND oBinLocation WHERE oBinLocation.Warehouse = oInventoryGenEntry_4_2.WarehouseCode
            AND oBinLocation.codubiprogress = pro.Almmmate.codubi
            NO-LOCK NO-ERROR.
        IF AVAILABLE oBinLocation THEN oInventoryGenEntry_4_3.BinAbsEntry = oBinLocation.AbsEntry.
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
DEF VAR c-xls-file AS CHAR INIT 'oInventoryGenEntry_4_1' NO-UNDO.
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
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER oInventoryGenEntry_4_1:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .

/* RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER oBusineesPartners:handle, */
/*                                   INPUT  c-csv-file,                     */
/*                                   OUTPUT c-xls-file) .                   */

/* Borramos librerias de la memoria */
SESSION:SET-WAIT-STATE('').

c-xls-file = 'oInventoryGenEntry_4_2'.
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
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER oInventoryGenEntry_4_2:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .

SESSION:SET-WAIT-STATE('').

c-xls-file = 'oInventoryGenEntry_4_3'.
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
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER oInventoryGenEntry_4_3:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .
SESSION:SET-WAIT-STATE('').

DELETE PROCEDURE hProc.

MESSAGE 'Proceso terminado con éxito' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

