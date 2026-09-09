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
DEF INPUT PARAMETER pcProceso AS CHAR NO-UNDO.

CASE pcProceso:
    WHEN "To-Table" THEN RUN To-Table.
    WHEN "To-Text"  THEN RUN To-Text.
END CASE.

DEF VAR iCode AS INTE NO-UNDO.

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
         HEIGHT             = 5.85
         WIDTH              = 69.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-CargaEan14) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CargaEan14 Procedure 
PROCEDURE CargaEan14 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER cUoMType AS CHAR NO-UNDO.
    DEF INPUT PARAMETER iUoMEntry AS INTE NO-UNDO.
    DEF INPUT PARAMETER cUnidadBase AS CHAR NO-UNDO.
    DEF INPUT PARAMETER cUnidadAlternativa AS CHAR NO-UNDO.
    DEF INPUT PARAMETER iDefaultBarcode AS INTE NO-UNDO.


    CREATE INTEGRAL.oItemUnitOfMeasurement.
    ASSIGN
        INTEGRAL.oItemUnitOfMeasurement.ParentKey = INTEGRAL.oItems.ItemCode
        INTEGRAL.oItemUnitOfMeasurement.LineNum   = iCode
        INTEGRAL.oItemUnitOfMeasurement.UoMType   = cUoMType
        INTEGRAL.oItemUnitOfMeasurement.UoMEntry  = iUoMEntry
        INTEGRAL.oItemUnitOfMeasurement.UnidadBase = cUnidadBase
        INTEGRAL.oItemUnitOfMeasurement.UnidadAlternativa = cUnidadAlternativa
         INTEGRAL.oItemUnitOfMeasurement.DefaultBarcode = iDefaultBarcode
        .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-To-Table) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE To-Table Procedure 
PROCEDURE To-Table :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER bUnidadesMedida FOR INTEGRAL.oMaestroUnidadesDeMedida.

DO TRANSACTION:
    DELETE FROM INTEGRAL.oItemUnitOfMeasurement.
END.

iCode = 0.
FOR EACH INTEGRAL.oItems NO-LOCK,
    FIRST pro.Almmmatg NO-LOCK WHERE pro.Almmmatg.codcia = 001
    AND pro.Almmmatg.codmat = INTEGRAL.oItems.ItemCode:
    FIND INTEGRAL.oMaestroUnidadesDeMedida WHERE INTEGRAL.oMaestroUnidadesDeMedida.CODE = pro.Almmmatg.undbas NO-LOCK NO-ERROR.
    iCode = 0.
    IF AVAILABLE INTEGRAL.oMaestroUnidadesDeMedida THEN DO:
        /* Unidad de inventario */
        RUN CargaEan14 (INPUT "iutInventory", 
                        INPUT INTEGRAL.oMaestroUnidadesDeMedida.AbsEntry,
                        INPUT pro.Almmmatg.undbas,
                        INPUT pro.Almmmatg.undbas,
                        INPUT 0
                        ).
        iCode = iCode + 1.
        /* Unidad de venta igual a la unidad de stock */
        RUN CargaEan14 (INPUT "iutSales", 
                        INPUT INTEGRAL.oMaestroUnidadesDeMedida.AbsEntry,
                        INPUT pro.Almmmatg.undbas,
                        INPUT pro.Almmmatg.undbas,
                        INPUT 0
                        ).
        iCode = iCode + 1.
        /* Unidade de venta A, B y C */
        IF pro.Almmmatg.UndA > '' AND pro.Almmmatg.UndA <> pro.Almmmatg.undbas THEN DO:
            FIND bUnidadesMedida WHERE bUnidadesMedida.CODE = pro.Almmmatg.UndA NO-LOCK NO-ERROR.
            IF AVAILABLE bUnidadesMedida THEN DO:
                RUN CargaEan14 (INPUT "iutSales", 
                                INPUT bUnidadesMedida.AbsEntry,
                                INPUT pro.Almmmatg.undbas,
                                INPUT pro.Almmmatg.UndA,
                                INPUT 0
                                ).
                iCode = iCode + 1.
            END.
        END.
        IF pro.Almmmatg.UndB > '' AND pro.Almmmatg.UndB <> pro.Almmmatg.undbas THEN DO:
            FIND bUnidadesMedida WHERE bUnidadesMedida.CODE = pro.Almmmatg.UndB NO-LOCK NO-ERROR.
            IF AVAILABLE bUnidadesMedida THEN DO:
                RUN CargaEan14 (INPUT "iutSales", 
                                INPUT bUnidadesMedida.AbsEntry,
                                INPUT pro.Almmmatg.undbas,
                                INPUT pro.Almmmatg.UndB,
                                INPUT 0
                                ).
                iCode = iCode + 1.
            END.
        END.
        IF pro.Almmmatg.UndC > '' AND pro.Almmmatg.UndC <> pro.Almmmatg.undbas THEN DO:
            FIND bUnidadesMedida WHERE bUnidadesMedida.CODE = pro.Almmmatg.UndC NO-LOCK NO-ERROR.
            IF AVAILABLE bUnidadesMedida THEN DO:
                RUN CargaEan14 (INPUT "iutSales", 
                                INPUT bUnidadesMedida.AbsEntry,
                                INPUT pro.Almmmatg.undbas,
                                INPUT pro.Almmmatg.UndC,
                                INPUT 0
                                ).
                iCode = iCode + 1.
            END.
        END.
        /* Unidades de ventas por EAN 14 */
        FOR EACH INTEGRAL.oBarCode NO-LOCK USE-INDEX Idx01 WHERE INTEGRAL.oBarCode.ItemNro = pro.Almmmatg.codmat
            AND INTEGRAL.oBarCode.FreeText BEGINS "EAN 14":
            RUN CargaEan14 (INPUT "iutSales", 
                            INPUT INTEGRAL.oBarCode.UoMEntry,
                            INPUT pro.Almmmatg.undbas,
                            INPUT INTEGRAL.oBarCode.Unidad,
                            INPUT 0
                            ).
            iCode = iCode + 1.
        END.
        /* Unidades de compra por EAN 14 */
        FOR EACH INTEGRAL.oBarCode NO-LOCK USE-INDEX Idx01 WHERE INTEGRAL.oBarCode.ItemNro = pro.Almmmatg.codmat:
            RUN CargaEan14 (INPUT "iutPurchasing", 
                            INPUT INTEGRAL.oBarCode.UoMEntry,
                            INPUT pro.Almmmatg.undbas,
                            INPUT INTEGRAL.oBarCode.Unidad,
                            INPUT INTEGRAL.oBarCode.AbsEntry
                            ).
            iCode = iCode + 1.
        END.
    END.
END.

/* Carga final */
FOR EACH oItemUnitOfMeasurement EXCLUSIVE-LOCK,
    FIRST oBarCode WHERE oBarCode.ItemNro = oItemUnitOfMeasurement.ParentKey
        AND oBarCode.UoMEntry = oItemUnitOfMeasurement.UoMEntry NO-LOCK,
    FIRST ooItemAlternativeCode WHERE ooItemAlternativeCode.ItemNro = oItemUnitOfMeasurement.ParentKey
        AND ooItemAlternativeCode.ItemCode = oBarCode.BarCode NO-LOCK:
    ASSIGN
        oItemUnitOfMeasurement.Height1 = ooItemAlternativeCode.HEIGHT / 100
        oItemUnitOfMeasurement.Length1 = ooItemAlternativeCode.LONG / 100
        oItemUnitOfMeasurement.Width1 = ooItemAlternativeCode.WIDTH / 100
        oItemUnitOfMeasurement.Volume = ROUND((oItemUnitOfMeasurement.Height1 *
                                              oItemUnitOfMeasurement.Length1 * 
                                              oItemUnitOfMeasurement.Width1),
                                              6)
        oItemUnitOfMeasurement.VolumeUnit = "4"
        oItemUnitOfMeasurement.Height1Unit = "4"
        oItemUnitOfMeasurement.Length1Unit = "4"
        oItemUnitOfMeasurement.Width1Unit = "4"
        oItemUnitOfMeasurement.Weight1 = ooItemAlternativeCode.Weight 
        oItemUnitOfMeasurement.Weight1Unit = "3"
        .
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
DEF VAR c-xls-file AS CHAR INIT '96 BVPS - Unidades de medida por articulo (ITM12 - ItemUnitOfMeasurement)' NO-UNDO.
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
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER oItemUnitOfMeasurement:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .

/* RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER oBusineesPartners:handle, */
/*                                   INPUT  c-csv-file,                     */
/*                                   OUTPUT c-xls-file) .                   */

/* Borramos librerias de la memoria */
DELETE PROCEDURE hProc.
SESSION:SET-WAIT-STATE('').

MESSAGE 'Proceso terminado con éxito' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

