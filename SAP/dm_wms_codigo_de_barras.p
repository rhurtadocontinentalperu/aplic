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
         HEIGHT             = 6.92
         WIDTH              = 60.
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

    DEF INPUT PARAMETER cBarCode AS CHAR.
    DEF INPUT PARAMETER cFreeText AS CHAR.
    DEF INPUT PARAMETER fEquivalencia AS DECIMAL DECIMALS 4.

    iCode = iCode + 1.
    CREATE oBarCode.
    ASSIGN
        INTEGRAL.oBarCode.AbsEntry = iCode
        INTEGRAL.oBarCode.ItemNro = pro.Almmmatg.codmat
        INTEGRAL.oBarCode.Barcode = cBarCode 
        INTEGRAL.oBarCode.FreeText = cFreeText
        INTEGRAL.oBarCode.Equivalencia = fEquivalencia
        .
    /* Buscamos el código de barra sugerido */
    FOR EACH INTEGRAL.oMaestroGrupoUnidadesMedidaDet NO-LOCK WHERE INTEGRAL.oMaestroGrupoUnidadesMedidaDet.CodUnid = pro.Almmmatg.undbas
        AND INTEGRAL.oMaestroGrupoUnidadesMedidaDet.BaseQuantity = INTEGRAL.oBarCode.Equivalencia:
        ASSIGN
            INTEGRAL.oBarCode.UoMEntry = INTEGRAL.oMaestroGrupoUnidadesMedidaDet.AlternateUoM
            INTEGRAL.oBarCode.Unidad = INTEGRAL.oMaestroGrupoUnidadesMedidaDet.CodAlter
            .
        LEAVE.
    END.

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


DO TRANSACTION:
    FOR EACH oBarCode EXCLUSIVE-LOCK:
        DELETE oBarCode.
    END.
END.

iCode = 0.
FOR EACH INTEGRAL.oItems NO-LOCK,
    FIRST pro.Almmmatg NO-LOCK WHERE pro.Almmmatg.codcia = 001 
    AND pro.Almmmatg.codmat = INTEGRAL.oItems.ItemCode
    /*AND pro.Almmmatg.fching <= DATE(07,31,2025)*/:
    FIND INTEGRAL.oMaestroUnidadesDeMedida WHERE INTEGRAL.oMaestroUnidadesDeMedida.CODE = pro.Almmmatg.undbas NO-LOCK NO-ERROR.
    IF AVAILABLE INTEGRAL.oMaestroUnidadesDeMedida THEN DO:
        iCode = iCode + 1.
        CREATE oBarCode.
        ASSIGN
            INTEGRAL.oBarCode.AbsEntry = iCode
            INTEGRAL.oBarCode.ItemNro = pro.Almmmatg.codmat
            INTEGRAL.oBarCode.Barcode = pro.Almmmatg.CodBrr 
            INTEGRAL.oBarCode.FreeText = "UNIDAD"
            INTEGRAL.oBarCode.UoMEntry = INTEGRAL.oMaestroUnidadesDeMedida.AbsEntry
            INTEGRAL.oBarCode.Unidad = pro.Almmmatg.undbas
            INTEGRAL.oBarCode.Equivalencia = 1
            .
        /*IF TRUE <> (INTEGRAL.oBarCode.Barcode > '') THEN INTEGRAL.oBarCode.Barcode = pro.Almmmatg.codmat.*/
        /* EAN 14 */
        FIND FIRST pro.Almmmat1 WHERE pro.Almmmat1.CodCia = pro.Almmmatg.codcia 
            AND pro.Almmmat1.codmat = pro.Almmmatg.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE pro.Almmmat1 THEN DO:
            IF pro.Almmmat1.Barras[1] > '' THEN RUN CargaEan14 (INPUT pro.Almmmat1.Barras[1], INPUT "EAN 14-1", INPUT pro.Almmmat1.Equival[1]).
            IF pro.Almmmat1.Barras[2] > '' THEN RUN CargaEan14 (INPUT pro.Almmmat1.Barras[2], INPUT "EAN 14-2", INPUT pro.Almmmat1.Equival[2]).
            IF pro.Almmmat1.Barras[3] > '' THEN RUN CargaEan14 (INPUT pro.Almmmat1.Barras[3], INPUT "EAN 14-3", INPUT pro.Almmmat1.Equival[3]).
            IF pro.Almmmat1.Barras[4] > '' THEN RUN CargaEan14 (INPUT pro.Almmmat1.Barras[4], INPUT "EAN 14-4", INPUT pro.Almmmat1.Equival[4]).
        END.
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
DEF VAR c-xls-file AS CHAR INIT '95 BVPS - Codigo de barras OBCD - BarCode' NO-UNDO.
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
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER oBarCode:HANDLE,
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

