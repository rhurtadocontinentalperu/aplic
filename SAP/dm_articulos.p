&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 03_BPVS - Clientes
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
         HEIGHT             = 6.08
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
PROCEDURE To-Table PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* 1.- Adicionamos o Actualizamos (y verificamos por si acaso duplicados) solo ACTIVOS */
DEF VAR iContador AS INTE NO-UNDO.
DEF VAR iCurrentNumber AS INTE NO-UNDO.
DEF VAR cTexto AS CHAR NO-UNDO.
DEF VAR cUndA AS CHAR NO-UNDO.
DEF VAR cUndB AS CHAR NO-UNDO.
DEF VAR cUndC AS CHAR NO-UNDO.
DEF VAR iBaseUoM LIKE oMaestroGrupoUnidadesMedidaCab.BaseUoM NO-UNDO.

DO TRANSACTION:
    FOR EACH oItems EXCLUSIVE-LOCK:
        DELETE oItems.
    END.
END.

FOR EACH pro.Almmmatg NO-LOCK WHERE pro.Almmmatg.codcia = 1 AND pro.Almmmatg.TpoArt = "A" AND pro.Almmmatg.fching <= pdFechaCorte:
    /* *********************************************************************************** */
    /* *********************************************************************************** */
    FIND oMaestroUnidadesDeMedida WHERE oMaestroUnidadesDeMedida.Code = pro.Almmmatg.undbas
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE oMaestroUnidadesDeMedida THEN NEXT.
    /* *********************************************************************************** */
    /* *********************************************************************************** */
    iContador = iContador + 1.
    CREATE oItems.
    ASSIGN
        oItems.RecordKey = iContador
        oItems.ItemCode = pro.Almmmatg.codmat.
    cTexto = TRIM(pro.Almmmatg.desmat).
    RUN lib/limpiar-texto-abc (INPUT cTexto, INPUT " ", OUTPUT cTexto).
    cTexto = REPLACE(cTexto,";"," ").
    ASSIGN
        oItems.ItemName = SUBSTRING(cTexto,1,100).
    /* *********************************************************************************** */
    /* Grupo de unidades de medida */
    /* Por defecto se le asigna la misma unidad */
    /* *********************************************************************************** */
    ASSIGN
        oItems.UoMGroupEntry = 0.
    FIND oMaestroGrupoUnidadesMedidaCab WHERE oMaestroGrupoUnidadesMedidaCab.CODE = pro.Almmmatg.undbas
        NO-LOCK NO-ERROR.
    IF AVAILABLE oMaestroGrupoUnidadesMedidaCab 
        THEN 
        ASSIGN
        oItems.UoMGroupEntry = oMaestroGrupoUnidadesMedidaCab.AbsEntry
        iBaseUoM = oMaestroGrupoUnidadesMedidaCab.BaseUoM.
    /* Unidades de ventas del artículo: hasta 3 unidades */
    ASSIGN
        cUndA = pro.Almmmatg.UndA   /* Unidad Base */
        cUndB = pro.Almmmatg.UndB
        cUndC = pro.Almmmatg.UndC.
    FOR EACH oMaestroGrupoUnidadesMedidaCab NO-LOCK WHERE INDEX(oMaestroGrupoUnidadesMedidaCab.Code, "_GRP") > 0
        AND oMaestroGrupoUnidadesMedidaCab.BaseUoM = iBaseUoM
        BY oMaestroGrupoUnidadesMedidaCab.AbsEntry:
        oItems.UoMGroupEntry = oMaestroGrupoUnidadesMedidaCab.AbsEntry.
        LEAVE.      /* Se toma el primero */
    END.
    /* *********************************************************************************** */
    ASSIGN
        oItems.InventoryUoMEntry = oMaestroUnidadesDeMedida.AbsEntry
        oItems.InventoryUOM = oMaestroUnidadesDeMedida.Code
        oItems.PricingUnit = oMaestroUnidadesDeMedida.AbsEntry
        .
    /* *********************************************************************************** */
    /* Grupo de artículos */
    /* *********************************************************************************** */
    FIND FIRST oItemGroups WHERE oItemGroups.codigo = pro.Almmmatg.catconta[1] NO-LOCK NO-ERROR.
    IF AVAILABLE oItemGroups THEN oItems.ItemsGroupCode = oItemGroups.NumberCod.
    ASSIGN
        oItems.DefaultPurchasingUoMEntry = oMaestroUnidadesDeMedida.AbsEntry
        oItems.PurchaseUnit = oMaestroUnidadesDeMedida.Code
        .
    /* *********************************************************************************** */
    FIND pro.Almtfami OF pro.Almmmatg NO-LOCK NO-ERROR.
    IF AVAILABLE pro.Almtfami AND pro.Almtfami.swcomercial = YES 
        THEN oItems.SalesItem = "tYES".
    ELSE oItems.SalesItem = "tNO".
    ASSIGN
        oItems.DefaultSalesUoMEntry = oMaestroUnidadesDeMedida.AbsEntry
        oItems.SalesUnit = oMaestroUnidadesDeMedida.Code
        .
    IF pro.Almmmatg.aftigv = NO THEN oItems.VatLiable = "tNO".

    FIND pro.Almtabla WHERE pro.Almtabla.tabla = "CC" AND pro.Almtabla.codigo = pro.Almmmatg.CatConta[1]
        NO-LOCK NO-ERROR.
    IF AVAILABLE pro.Almtabla THEN oItems.u_bpp_tipexist = TRIM(pro.Almtabla.nomant).

    /* SUNAT */
    FIND FIRST pro.Unidades WHERE Unidades.Codunid = pro.Almmmatg.undbas NO-LOCK NO-ERROR.
    IF AVAILABLE pro.Unidades THEN oItems.U_BPP_TIPUNMED = Unidades.CodSunat.

    IF pro.Almmmatg.CatConta[1] = "SV" THEN oItems.U_VS_TIPITM = "SV".
    IF pro.Almmmatg.CatConta[1] = "AF" THEN oItems.U_VS_TIPITM = "AC".
    ASSIGN
        oItems.SalesUnitWeight = pro.Almmmatg.Pesmat.
    IF pro.Almmmatg.CatConta[1] = "AF" THEN oItems.AssetItem = "tYES".

    ASSIGN
        oItems.codfam = pro.Almmmatg.codfam
        oItems.subfam = pro.Almmmatg.subfam
        oItems.CatContab = pro.Almmmatg.catconta[1]
        oItems.Licencia = (IF TRUE <> (pro.Almmmatg.Licencia[1] > '') THEN "" ELSE pro.Almmmatg.Licencia[1])
        oItems.CodMar = pro.Almmmatg.CodMar
        .
END.
/* 2.- Cargamos lotes */
FOR EACH SKULotes NO-LOCK:
    FIND oItems WHERE oItems.ItemCode = skulotes.codmat EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE oItems THEN DO:
        oItems.ManageBatchNumbers = "tYES".
        RELEASE oItems.
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
DEF VAR c-xls-file AS CHAR INIT '08 - BPVS - I1 - Catalogo de articulos de inventario (oItems)' NO-UNDO.
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
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER oItems:HANDLE,
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

