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
         HEIGHT             = 3.92
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

  DEFINE VARIABLE F-IGV LIKE Ccbcdocu.ImpIgv NO-UNDO.
  DEFINE VARIABLE F-ISC LIKE Ccbcdocu.ImpIsc NO-UNDO.

  ASSIGN
      CcbCDocu.ImpDto = 0
      CcbCDocu.ImpIgv = 0
      CcbCDocu.ImpIsc = 0
      CcbCDocu.ImpTot = 0
      CcbCDocu.ImpExo = 0
      F-IGV = 0
      F-ISC = 0.
  FOR EACH CcbDDocu OF CcbCDocu:
      ASSIGN
          F-Igv = F-Igv + CcbDDocu.ImpIgv
          F-Isc = F-Isc + CcbDDocu.ImpIsc
          CcbCDocu.ImpTot = CcbCDocu.ImpTot + Ccbddocu.ImpLin.
      /* Importe Inafecto o Exonerado */
      IF CcbDDocu.ImpIgv = 0 THEN CcbCDocu.ImpExo = CcbCDocu.ImpExo + Ccbddocu.ImpLin.
  END.
  ASSIGN
      CcbCDocu.ImpIgv = ROUND(F-IGV,2)
      CcbCDocu.ImpIsc = ROUND(F-ISC,2)
      CcbCDocu.ImpVta = CcbCDocu.ImpTot - CcbCDocu.ImpExo - CcbCDocu.ImpIgv
      CcbCDocu.ImpBrt = CcbCDocu.ImpVta + CcbCDocu.ImpIsc + CcbCDocu.ImpDto + CcbCDocu.ImpExo
      CcbCDocu.SdoAct = CcbCDocu.ImpTot.
  IF CcbCDocu.PorIgv = 0.00     /* VENTA INAFECTA */
      THEN ASSIGN
          CcbCDocu.ImpVta = CcbCDocu.ImpExo
          CcbCDocu.ImpBrt = CcbCDocu.ImpExo.

  /* CALCULO DE PERCEPCIONES */
  RUN vta2/calcula-percepcion-contado ( ROWID(Ccbcdocu), ROWID(B-CPEDM) ).
  FIND CURRENT CcbCDocu.
  /* *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


