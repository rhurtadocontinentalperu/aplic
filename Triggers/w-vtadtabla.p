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

TRIGGER PROCEDURE FOR WRITE OF VtaDTabla OLD BUFFER OldVtaDTabla.

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
         HEIGHT             = 5.23
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* ************************************************************************************** */
/* RHC 22/08/19 NUEVAS TABLAS */
/* ************************************************************************************** */
DEF VAR pError AS CHAR NO-UNDO.

CASE TRUE:
    WHEN VtaDTabla.Tabla = "UTILEX-ENCARTE" AND VtaDTabla.Tipo = "M"
        THEN DO:
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
            RUN CUPON_Importe-sin-igv.
        END.
        /* ************************************************************************************** */
    END.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-CUPON_Importe-sin-igv) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CUPON_Importe-sin-igv Procedure 
PROCEDURE CUPON_Importe-sin-igv :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF VtaDTabla.Libre_d02 <> OLDVtaDTabla.Libre_d02 THEN DO:
    ASSIGN
        VtaDTabla.TasaImpuesto = Sunat_Fact_Electr_Taxs.Tax
        VtaDTabla.ImporteUnitarioSinImpuesto = ROUND(VtaDTabla.Libre_d02 / ( 1 + Sunat_Fact_Electr_Taxs.Tax / 100), 4)
        VtaDTabla.ImporteUnitarioImpuesto = VtaDTabla.Libre_d02 - VtaDTabla.ImporteUnitarioSinImpuesto
        .
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

