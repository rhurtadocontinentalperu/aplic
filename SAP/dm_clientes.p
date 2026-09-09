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
PROCEDURE To-Table :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* 1.- Adicionamos o Actualizamos (y verificamos por si acaso duplicados) solo ACTIVOS */
DEF VAR iContador AS INTE NO-UNDO.
DEF VAR iCurrentNumber AS INTE NO-UNDO.
DEF VAR cTexto AS CHAR NO-UNDO.

FOR EACH oBusineesPartners NO-LOCK BY oBusineesPartners.RecordKey DESC:
    iContador = oBusineesPartners.RecordKey.
    LEAVE.
END.

DEF BUFFER bGn-Clie FOR pro.gn-clie.

FOR EACH bGn-Clie NO-LOCK WHERE bGn-Clie.codcia = 000 AND bGn-Clie.flgsit = "A" BY bGn-Clie.codcli:
    IF pdFechaCorte <> ? AND bGn-Clie.fching > pdFechaCorte THEN NEXT.

    IF iContador MODULO 1000 = 0 THEN DO:
        DISPLAY bGn-Clie.codcli WITH STREAM-IO NO-BOX NO-LABELS WIDTH 320.
        PAUSE 0.
    END.

    FIND FIRST oBusineesPartners WHERE oBusineesPartners.FederalTaxID = bGn-Clie.codcli NO-LOCK NO-ERROR.
    IF AVAILABLE oBusineesPartners THEN DO:
        FIND CURRENT oBusineesPartners EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE oBusineesPartners THEN RETURN.
        iCurrentNumber = oBusineesPartners.RecordKey.
    END.
    ELSE DO:
        iContador = iContador + 1.
        CREATE oBusineesPartners.
        iCurrentNumber = iContador.
    END.
    
    ASSIGN
        oBusineesPartners.RecordKey = iCurrentNumber
        oBusineesPartners.CardCode = "CL" + bGn-Clie.codcli
        oBusineesPartners.CardName = SUBSTRING(TRIM(bGn-Clie.nomcli),1,100)
        oBusineesPartners.CardType = "cCustomer"
        oBusineesPartners.Country = "PE"
        oBusineesPartners.City = "LIMA"
        oBusineesPartners.Currency = "##"
        .
    RUN lib/limpiar-texto-abc (INPUT bGn-Clie.nomcli, INPUT " ", OUTPUT cTexto).
    cTexto = REPLACE(cTexto,";"," ").
    ASSIGN
        oBusineesPartners.CardName = cTexto.

    ASSIGN
        oBusineesPartners.DebitorAccount = "12122100"
        oBusineesPartners.DownPaymentClearAct = "12211100"
        oBusineesPartners.FederalTaxID = bGn-Clie.codcli
        .
    ASSIGN
        oBusineesPartners.EmailAddress = ENTRY(1, bGn-Clie.Transporte[4], ';')
        oBusineesPartners.Cellular = ""
        oBusineesPartners.Phone1 = bGn-Clie.Telfnos[1] 
        oBusineesPartners.Phone2 = bGn-Clie.Telfnos[2] 
        oBusineesPartners.Fax = ""
        .
    ASSIGN
        oBusineesPartners.GroupCode = "100"
        oBusineesPartners.SalesPersonCode = -1      /* Valor por defecto */
        .
    IF bGn-Clie.codven > "" THEN DO:
        FIND FIRST oSalesPersons WHERE oSalesPersons.CodVen = bGn-Clie.codven NO-LOCK NO-ERROR.
        IF AVAILABLE oSalesPersons THEN oBusineesPartners.SalesPersonCode = oSalesPersons.SalesEmployeeCode.
    END.
    ASSIGN
        oBusineesPartners.ShipToDefault = "ALMACEN"     /* Valor por defecto */
        .
    ASSIGN
        oBusineesPartners.SubjectToWithholdingTax = "boNO"      /* Valor por defecto */
        oBusineesPartners.VatGroupLatinAmerica = "I18"
        .
    /* Queda pendiente el NO DOMICILIADO (SND) */
    CASE bGn-Clie.Libre_C01:
        WHEN "J" THEN ASSIGN oBusineesPartners.U_BPP_BPTP = "TPJ" oBusineesPartners.U_BPP_BPTD = "6".
        WHEN "N" THEN  oBusineesPartners.U_BPP_BPTP = "TPN".
        WHEN "E" THEN  oBusineesPartners.U_BPP_BPTP = "TPN".
    END CASE.
    ASSIGN
        oBusineesPartners.U_BPP_BPTD = "0"      /* Valor por defecto (Otros Tipos) */
        .
    CASE TRUE:
        WHEN bGn-Clie.Libre_C01 = "J" THEN oBusineesPartners.U_BPP_BPTD = "6".     /* RUC */
        OTHERWISE DO:
            oBusineesPartners.U_BPP_BPTD = "1".       /* DNI */
            IF LENGTH(TRIM(bGn-Clie.DNI)) <> 8 THEN oBusineesPartners.U_BPP_BPTD = "4".    /* Carnet de Extranjería */
            ASSIGN
                oBusineesPartners.U_BPP_BPAP = bGn-Clie.apepat
                oBusineesPartners.U_BPP_BPAM = bGn-Clie.apemat
                oBusineesPartners.U_BPP_BPNO = ENTRY(1, TRIM(bGn-Clie.nombre), " ")
                oBusineesPartners.U_BPP_BPN2 = (IF NUM-ENTRIES(TRIM(bGn-Clie.nombre)," ") > 1 THEN ENTRY(2, TRIM(bGn-Clie.nombre), " ") ELSE "")
                .    
            RUN lib/limpiar-texto-abc (INPUT bGn-Clie.apepat, INPUT " ", OUTPUT cTexto).
            cTexto = REPLACE(cTexto,";"," ").
            oBusineesPartners.U_BPP_BPAP = cTexto.
            RUN lib/limpiar-texto-abc (INPUT bGn-Clie.apemat, INPUT " ", OUTPUT cTexto).
            cTexto = REPLACE(cTexto,";"," ").
            oBusineesPartners.U_BPP_BPAM = cTexto.
            RUN lib/limpiar-texto-abc (INPUT oBusineesPartners.U_BPP_BPNO, INPUT " ", OUTPUT cTexto).
            cTexto = REPLACE(cTexto,";"," ").
            oBusineesPartners.U_BPP_BPNO = cTexto.
            RUN lib/limpiar-texto-abc (INPUT oBusineesPartners.U_BPP_BPN2, INPUT " ", OUTPUT cTexto).
            cTexto = REPLACE(cTexto,";"," ").
            oBusineesPartners.U_BPP_BPN2 = cTexto.
        END.
    END CASE.
    IF bGn-Clie.Rucold = "Si" THEN oBusineesPartners.U_VS_AFPRCP = "R".
    IF bGn-Clie.Libre_L01 = YES THEN oBusineesPartners.U_VS_AFPRCP = "P".

    /* Datos adicionales */
    ASSIGN
        oBusineesPartners.U_ClfPropios = bGn-Clie.clfcli
        oBusineesPartners.U_ClfTerceros = bGn-Clie.clfcli2
        oBusineesPartners.U_CodDiv = bGn-Clie.coddiv
        oBusineesPartners.U_Giro = bGn-Clie.gircli
        oBusineesPartners.U_Grupo = bGn-Clie.canal
        oBusineesPartners.U_Sector = bGn-Clie.clfcom
        .
    FIND FIRST pro.vtatabla WHERE pro.vtatabla.codcia = 001
        AND pro.vtatabla.tabla = "CUSTOMER_CLFCLI_CR"
        AND pro.vtatabla.llave_c1 = bGn-Clie.codcli
        AND pro.vtatabla.llave_c2 = "012"
        NO-LOCK NO-ERROR.
    IF AVAILABLE pro.vtatabla THEN oBusineesPartners.U_Clf012 = pro.vtatabla.llave_c3.

    /* Grabamos Sedes */
/*     RUN sap/clientes_direcciones (INPUT "To-Table", */
/*                                   BUFFER bGn-Clie).  */
END.
MESSAGE 'Proceso terminado con éxito' VIEW-AS ALERT-BOX INFORMATION.

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
DEF VAR c-xls-file AS CHAR INIT '03_BPVS - Clientes (oBusineesPartners)' NO-UNDO.
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
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER oBusineesPartners:HANDLE,
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

