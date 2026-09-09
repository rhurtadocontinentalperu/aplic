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

TRIGGER PROCEDURE FOR WRITE OF VtaDctoProm OLD BUFFER OldVtaDctoProm.

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
         HEIGHT             = 4.27
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* RHC 04/03/2019 Log General */
/*{TRIGGERS/i-logtransactions.i &TableName="VtaDctoProm" &Event="WRITE"}*/

/* RHC 21/10/2021 Grabar importe sin igv */
FIND FIRST Sunat_Fact_Electr_Taxs  WHERE Sunat_Fact_Electr_Taxs.TaxTypeCode = "IGV"
    AND TODAY >= Sunat_Fact_Electr_Taxs.Start_Date 
    AND TODAY <= Sunat_Fact_Electr_Taxs.End_Date 
    AND Sunat_Fact_Electr_Taxs.Disabled = NO
    AND Sunat_Fact_Electr_Taxs.Tax > 0
    NO-LOCK NO-ERROR.
IF AVAILABLE Sunat_Fact_Electr_Taxs THEN DO:
    IF VtaDctoProm.Precio <> OLDVtaDctoProm.Precio THEN
        ASSIGN
            VtaDctoProm.TasaImpuesto = Sunat_Fact_Electr_Taxs.Tax
            VtaDctoProm.ImporteUnitarioSinImpuesto = ROUND(VtaDctoProm.Precio / ( 1 + Sunat_Fact_Electr_Taxs.Tax / 100), 4)
            VtaDctoProm.ImporteUnitarioImpuesto = VtaDctoProm.Precio - VtaDctoProm.ImporteUnitarioSinImpuesto
            .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


