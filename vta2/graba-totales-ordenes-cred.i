&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Importe total para FacCPedi (COT PED O/D P/M)

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

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

  DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
  DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.

  ASSIGN
    FacCPedi.ImpDto = 0
    FacCPedi.ImpIgv = 0
    FacCPedi.ImpIsc = 0
    FacCPedi.ImpTot = 0
    FacCPedi.ImpExo = 0
    FacCPedi.Importe[3] = 0
    F-IGV = 0
    F-ISC = 0.
  /* VENTAS INAFECTAS A IGV */
  IF FacCPedi.FlgIgv = NO THEN DO:
      FacCPedi.PorIgv = 0.00.
      FOR EACH FacDPedi OF FacCPedi:
          ASSIGN
              FacDPedi.AftIgv = NO
              FacDPedi.ImpIgv = 0.00.
      END.
  END.
  FOR EACH FacDPedi OF FacCPedi:
      ASSIGN
          F-Igv = F-Igv + FacDPedi.ImpIgv
          F-Isc = F-Isc + FacDPedi.ImpIsc
          FacCPedi.ImpTot = FacCPedi.ImpTot + FacDPedi.ImpLin.
      /* Importe Inafecto o Exonerado */
      IF FacDPedi.ImpIgv = 0 THEN FacCPedi.ImpExo = FacCPedi.ImpExo + FacDPedi.ImpLin.
  END.
  ASSIGN
      FacCPedi.ImpIgv = ROUND(F-IGV,2)
      FacCPedi.ImpIsc = ROUND(F-ISC,2)
      FacCPedi.ImpVta = FacCPedi.ImpTot - FacCPedi.ImpExo - FacCPedi.ImpIgv
      FacCPedi.ImpBrt = FacCPedi.ImpVta + FacCPedi.ImpIsc + FacCPedi.ImpDto + FacCPedi.ImpExo
      FacCPedi.Importe[1] = FacCPedi.ImpTot.    /* Guardamos el importe original */
  IF FacCPedi.FlgIgv = NO 
      THEN ASSIGN
          FacCPedi.ImpVta = FacCPedi.ImpExo
          FacCPedi.ImpBrt = FacCPedi.ImpExo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


