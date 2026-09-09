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
/* ***************************  Definitions  ************************** */
DEF INPUT PARAMETER pcProceso AS CHAR NO-UNDO.

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
         HEIGHT             = 7.54
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
DEF VAR iContador AS INTE NO-UNDO.

DEF BUFFER bGn-Clie FOR pro.gn-clie.
DEF BUFFER bGn-ClieD FOR pro.gn-clied.
DEF BUFFER bTabDepto FOR pro.TabDepto.
DEF BUFFER bTabProvi FOR pro.TabProvi.
DEF BUFFER bTabDistr FOR pro.TabDistr.

DEF BUFFER boBPAsdresses FOR oBPAsdresses.

DEF VAR cTexto AS CHAR NO-UNDO.

FOR EACH oBusineesPartners NO-LOCK,
    FIRST bGn-Clie NO-LOCK WHERE bGn-Clie.codcia = 0 AND 
        bGn-Clie.codcli = oBusineesPartners.U_codCli
    BY oBusineesPartners.U_codCli:

    DISPLAY oBusineesPartners.U_codCli WITH STREAM-IO NO-BOX NO-LABELS.
    PAUSE 0.

    /* 1.- Borramos data */
    FOR EACH oBPAsdresses WHERE oBPAsdresses.ParentKey = oBusineesPartners.CardCode EXCLUSIVE-LOCK:
        DELETE oBPAsdresses.
    END.

    /* 2.- Dirección Fiscal */
    FIND FIRST bGn-ClieD OF bgn-clie WHERE bGn-ClieD.sede = "@@@" NO-LOCK NO-ERROR.
    IF AVAILABLE bGn-ClieD THEN DO:
        /* Se crea 2 iguales */
        CREATE oBPAsdresses.
        ASSIGN
            oBPAsdresses.AddressName = "FISCAL"     /* bGn-ClieD.sede */
            oBPAsdresses.AddressType = "bo_BillTo"
            oBPAsdresses.Block = ""
            oBPAsdresses.BuildingFloorRoom = ""
            oBPAsdresses.Country = "PE"
            oBPAsdresses.FederalTaxID = oBusineesPartners.FederalTaxID 
            oBPAsdresses.LineNum = 0
            oBPAsdresses.ParentKey = oBusineesPartners.CardCode
            oBPAsdresses.TaxCode = "I18"
            .
        RUN lib/limpiar-texto-abc (INPUT bGn-ClieD.DirCli, INPUT " ", OUTPUT cTexto).
        cTexto = REPLACE(cTexto,";"," ").
        oBPAsdresses.Street = SUBSTRING(cTexto,1,100).

        FIND bTabDepto WHERE bTabDepto.CodDepto = bGn-ClieD.CodDept NO-LOCK NO-ERROR.
        IF AVAILABLE bTabDepto THEN DO:
            oBPAsdresses.State = bGn-ClieD.CodDept.
            FIND bTabProvi WHERE bTabProvi.CodDepto = bGn-ClieD.CodDept
                AND bTabProvi.CodProvi = bGn-ClieD.CodProv NO-LOCK NO-ERROR.
            IF AVAILABLE bTabProvi THEN DO:
                oBPAsdresses.City = bTabProvi.NomProvi.
                FIND bTabDistr WHERE bTabDistr.CodDepto = bGn-ClieD.CodDept
                    AND bTabDistr.CodProvi = bGn-ClieD.CodProv
                    AND bTabDistr.CodDistr = bGn-ClieD.CodDist NO-LOCK NO-ERROR.
                IF AVAILABLE bTabDistr THEN DO:
                    oBPAsdresses.County = bTabDistr.NomDistr.
                    oBPAsdresses.GlobalLocationNumber = TRIM(bGn-ClieD.CodDept) + TRIM(bGn-ClieD.CodProv) + TRIM(bGn-ClieD.CodDist).
                END.
            END.
        END.

        CREATE boBPAsdresses.
        BUFFER-COPY oBPAsdresses TO boBPAsdresses
            ASSIGN
            boBPAsdresses.AddressName = "ALMACEN"
            boBPAsdresses.AddressType = "bo_ShipTo"
            boBPAsdresses.LineNum = 1.
        RELEASE boBPAsdresses.
    END.
    /* 3.- Otras direcciones */
    iContador = 1.
    FOR EACH bGn-ClieD OF bgn-clie WHERE bGn-ClieD.sede <> "@@@" NO-LOCK BY bGn-ClieD.sede:
        iContador = iContador + 1.
        CREATE oBPAsdresses.
        ASSIGN
            oBPAsdresses.AddressName = bGn-ClieD.sede
            oBPAsdresses.AddressType = "bo_ShipTo"
            oBPAsdresses.Block = ""
            oBPAsdresses.BuildingFloorRoom = ""
            oBPAsdresses.Country = "PE"
            oBPAsdresses.FederalTaxID = bGn-ClieD.CodCli 
            oBPAsdresses.LineNum = iContador
            oBPAsdresses.ParentKey = "CL" + bgn-clie.codcli
            oBPAsdresses.TaxCode = "I18"
            .
        RUN lib/limpiar-texto-abc (INPUT bGn-ClieD.DirCli, INPUT " ", OUTPUT cTexto).
        cTexto = REPLACE(cTexto,";"," ").
        oBPAsdresses.Street = SUBSTRING(cTexto,1,100).

        FIND bTabDepto WHERE bTabDepto.CodDepto = bGn-ClieD.CodDept NO-LOCK NO-ERROR.
        IF AVAILABLE bTabDepto THEN DO:
            oBPAsdresses.State = bGn-ClieD.CodDept.
            FIND bTabProvi WHERE bTabProvi.CodDepto = bGn-ClieD.CodDept
                AND bTabProvi.CodProvi = bGn-ClieD.CodProv NO-LOCK NO-ERROR.
            IF AVAILABLE bTabProvi THEN DO:
                oBPAsdresses.City = bTabProvi.NomProvi.
                FIND bTabDistr WHERE bTabDistr.CodDepto = bGn-ClieD.CodDept
                    AND bTabDistr.CodProvi = bGn-ClieD.CodProv
                    AND bTabDistr.CodDistr = bGn-ClieD.CodDist NO-LOCK NO-ERROR.
                IF AVAILABLE bTabDistr THEN DO:
                    oBPAsdresses.County = bTabDistr.NomDistr.
                    oBPAsdresses.GlobalLocationNumber = TRIM(bGn-ClieD.CodDept) + TRIM(bGn-ClieD.CodProv) + TRIM(bGn-ClieD.CodDist).
                END.
            END.
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
DEF VAR c-xls-file AS CHAR INIT 'oBPAsdresses' NO-UNDO.
DEF VAR rpta AS LOG INIT NO NO-UNDO.

SYSTEM-DIALOG GET-FILE c-xls-file
    FILTERS 'Libro de Excel' '*.xlsx'
    INITIAL-FILTER 1
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION ".xlsx"
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
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER oBPAsdresses:HANDLE,
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

