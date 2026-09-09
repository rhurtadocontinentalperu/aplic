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

DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroSer AS INT.
DEF OUTPUT PARAMETER pNroItems AS INT.

DEF SHARED VAR s-codcia AS INT.

/* Valores por Defecto */
pNroItems = 999.
FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
IF AVAILABLE FacCfgGn THEN DO:
    CASE pCodDoc:
        WHEN "BOL" THEN pNroItems = FacCfgGn.Items_Boleta.
        WHEN "FAC" THEN pNroItems = FacCfgGn.Items_Factura.
        WHEN "FAI" THEN pNroItems = FacCfgGn.Items_Factura.
        WHEN "N/C" THEN pNroItems = FacCfgGn.Items_N_Credito.
        WHEN "N/D" THEN pNroItems = FacCfgGn.Items_N_Debito.
        WHEN "N/D" THEN pNroItems = FacCfgGn.Items_N_Debito.
        WHEN "G/R" THEN pNroItems = FacCfgGn.Items_guias.
        WHEN "TCK" THEN pNroItems = 999.
    END CASE.
END.
/* Valores SUNAT */
FIND FacCorre WHERE FacCorre.CodCia = s-codcia
    AND FacCorre.CodDoc = pCodDoc
    AND FacCorre.NroSer = pNroSer
    NO-LOCK NO-ERROR.

IF AVAILABLE FacCorre AND FacCorre.ListaPrecio > pNroItems THEN DO:
    FIND GN-DIVI WHERE GN-DIVI.CodCia = s-codcia AND GN-DIVI.CodDiv = FacCorre.CodDiv 
        NO-LOCK NO-ERROR.
    IF AVAILABLE GN-DIVI AND gn-divi.campo-log[10] = YES THEN pNroItems = FacCorre.ListaPrecio.
END.

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
         HEIGHT             = 3.96
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


