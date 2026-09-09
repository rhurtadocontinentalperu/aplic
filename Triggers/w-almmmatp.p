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

TRIGGER PROCEDURE FOR WRITE OF almmmatp OLD BUFFER Oldalmmmatp.

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
         HEIGHT             = 5.54
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF VAR x-Item AS INTE NO-UNDO.
DEF VAR f-PrecioLista AS DECI NO-UNDO.

f-PrecioLista = Almmmatp.PreOfi.
/* Actualizamos Precio por Volumen */
IF Almmmatp.PreOfi <> OldAlmmmatp.PreOfi THEN DO:
    DO x-Item = 1 TO 10:
        IF Almmmatp.DtoVolD[x-Item] <> 0 THEN
            ASSIGN Almmmatp.DtoVolP[x-Item] = ROUND(f-PrecioLista * (1 - (Almmmatp.DtoVolD[x-Item]  / 100)), 4).
    END.
END.
/* Actualizamos Precio Promocional */
DO x-Item = 1 TO 10:
    IF Almmmatp.PromDto[x-Item] <> 0 THEN
        ASSIGN Almmmatp.PromPrecio[x-Item] = ROUND(f-PrecioLista * (1 - (Almmmatp.PromDto[x-Item]  / 100)), 4).
END.
/* ************************************************************************************** */
/* RHC 21/10/2021 Grabar importe sin igv */
/* ************************************************************************************** */
FIND FIRST Sunat_Fact_Electr_Taxs  WHERE Sunat_Fact_Electr_Taxs.TaxTypeCode = "IGV"
    AND Sunat_Fact_Electr_Taxs.Disabled = NO
    AND TODAY >= Sunat_Fact_Electr_Taxs.Start_Date 
    AND TODAY <= Sunat_Fact_Electr_Taxs.End_Date 
    AND Sunat_Fact_Electr_Taxs.Tax > 0
    NO-LOCK NO-ERROR.
IF AVAILABLE Sunat_Fact_Electr_Taxs THEN DO:
    RUN MAR_Importe-sin-igv.
END.
/* ************************************************************************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-MAR_Importe-sin-igv) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MAR_Importe-sin-igv Procedure 
PROCEDURE MAR_Importe-sin-igv :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k AS INTE NO-UNDO.

IF Almmmatp.PreOfi <> OLDAlmmmatp.PreOfi THEN DO:
    ASSIGN
        Almmmatp.TasaImpuesto = Sunat_Fact_Electr_Taxs.Tax
        Almmmatp.ImporteUnitarioSinImpuesto = ROUND(Almmmatp.PreOfi / ( 1 + Sunat_Fact_Electr_Taxs.Tax / 100), 4)
        almmmatp.ImporteUnitarioImpuesto = Almmmatp.PreOfi - Almmmatp.ImporteUnitarioSinImpuesto
        .
END.
DO k = 1 TO 10:
    IF Almmmatp.DtoVolP[k] <> OLDAlmmmatp.DtoVolP[k] THEN 
        ASSIGN
        Almmmatp.TasaImpuesto = Sunat_Fact_Electr_Taxs.Tax
        Almmmatp.DtoVolPSinImpuesto[k] = ROUND(Almmmatp.DtoVolP[k] / ( 1 + Sunat_Fact_Electr_Taxs.Tax / 100), 4)
        Almmmatp.DtoVolPImpuesto[k] = Almmmatp.DtoVolP[k] -  Almmmatp.DtoVolPSinImpuesto[k]
        .
END.
DO k = 1 TO 10:
    IF Almmmatp.PromPrecio[k] <> OLDAlmmmatp.PromPrecio[k] THEN 
        ASSIGN
        Almmmatp.TasaImpuesto = Sunat_Fact_Electr_Taxs.Tax
        Almmmatp.PromPrecioSinImpuesto[k] = ROUND(Almmmatp.PromPrecio[k] / ( 1 + Sunat_Fact_Electr_Taxs.Tax / 100), 4)
        Almmmatp.PromPrecioImpuesto[k] = Almmmatp.PromPrecio[k] -  Almmmatp.PromPrecioSinImpuesto[k]
        .
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

