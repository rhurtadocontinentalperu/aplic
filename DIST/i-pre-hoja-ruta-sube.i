&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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

ASSIGN
    T-RUTAD.CodCia = s-codcia
    T-RUTAD.CodDiv = s-coddiv
    T-RUTAD.Libre_c01 = T-CDOCU.CodPed
    T-RUTAD.Libre_c02 = T-CDOCU.NroPed
    T-RUTAD.CodDoc = T-CDOCU.CodRef     /* OJO: G/R o GTR */
    T-RUTAD.CodRef = T-CDOCU.CodDoc 
    T-RUTAD.NroRef = T-CDOCU.NroDoc
    T-RUTAD.Libre_c03 = T-CDOCU.Libre_C04
    T-RUTAD.Libre_c05 = T-CDOCU.NomCli
    T-RUTAD.Libre_d01 = T-CDOCU.Libre_d01   /* Peso kg */
    T-RUTAD.Libre_d02 = T-CDOCU.Libre_d02   /* Volumen m3 */
    T-RUTAD.ImpCob    = T-CDOCU.ImpTot      /* Importe S/ */
    T-RUTAD.Libre_c04 = T-CDOCU.CodAlm
    T-RUTAD.Libre_f01 = T-CDOCU.FchAte
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


