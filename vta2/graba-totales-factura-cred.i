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


/* NOTA : La aplicación de A/C afecta el importe línea en un monto de descuento
que se verá afectado en el total de la factura 
Los campos grabados son:
CcbDDocu.ImpDcto_Adelanto[1]    Importe del descuento
CcbDDocu.ImpDcto_Adelanto[2] 
CcbDDocu.ImpDcto_Adelanto[3] 
CcbDDocu.ImpDcto_Adelanto[4] 
CcbDDocu.ImpDcto_Adelanto[5] 
CcbDDocu.PorDcto_Adelanto[1]    % Del descuento (ej. 3.5%)
CcbDDocu.PorDcto_Adelanto[2] 
CcbDDocu.PorDcto_Adelanto[3] 
CcbDDocu.PorDcto_Adelanto[4] 
CcbDDocu.PorDcto_Adelanto[5]
*/

  DEFINE VARIABLE F-IGV LIKE Ccbcdocu.ImpIgv NO-UNDO.
  DEFINE VARIABLE F-ISC LIKE Ccbcdocu.ImpIsc NO-UNDO.
  DEFINE VARIABLE F-ImpDtoAdelanto AS DECIMAL NO-UNDO.
  DEFINE VARIABLE F-IgvDtoAdelanto AS DECIMAL NO-UNDO.
  DEFINE VARIABLE F-ImpLin LIKE Ccbddocu.ImpLin NO-UNDO.

  ASSIGN
      CcbCDocu.ImpDto = 0
      CcbCDocu.ImpIgv = 0
      CcbCDocu.ImpIsc = 0
      CcbCDocu.ImpTot = 0
      CcbCDocu.ImpExo = 0
      CcbCDocu.ImpTot2= 0
      F-IGV = 0
      F-ISC = 0
      F-ImpDtoAdelanto = 0
      F-IgvDtoAdelanto = 0
      F-ImpLin = 0
      /*CcbCDocu.Libre_d01 = 0*/    /* DESCUENTO LISTA EXPRESS WEB */
      CcbCDocu.Libre_d02 = 0.
  /* RHC 14/03/2013 Nuevo cálculo */
  FOR EACH CcbDDocu OF CcbCDocu:
      ASSIGN
          F-Igv = F-Igv + CcbDDocu.ImpIgv
          F-Isc = F-Isc + CcbDDocu.ImpIsc
          CcbCDocu.ImpTot = CcbCDocu.ImpTot + Ccbddocu.ImpLin.
      /* Importe Inafecto o Exonerado */
      IF CcbDDocu.ImpIgv = 0 THEN CcbCDocu.ImpExo = CcbCDocu.ImpExo + (CcbDDocu.ImpLin - CcbDDocu.ImpDto2).
  END.
  ASSIGN
      CcbCDocu.ImpTot = CcbCDocu.ImpTot - CcbCDocu.ImpDto2  /* <<< OJO: Descuento total Lista Express */
      CcbCDocu.ImpIsc = ROUND(F-ISC,2)
      CcbCDocu.ImpVta = ROUND( (CcbCDocu.ImpTot - CcbCDocu.ImpExo) / (1 + CcbCDocu.PorIgv / 100), 2).
  IF CcbCDocu.ImpExo = 0 THEN CcbCDocu.ImpIgv = CcbCDocu.ImpTot - CcbCDocu.ImpVta.
  ELSE CcbCDocu.ImpIgv = ROUND(CcbCDocu.ImpVta * CcbCDocu.PorIgv / 100, 2).
  ASSIGN
      CcbCDocu.ImpBrt = CcbCDocu.ImpVta + CcbCDocu.ImpDto + Ccbcdocu.Libre_d01  /* Dcto Lista Express SIN IGV */
      CcbCDocu.SdoAct = CcbCDocu.ImpTot.

  IF CcbCDocu.PorIgv = 0.00     /* VENTA INAFECTA */
      THEN ASSIGN
          Ccbcdocu.ImpIgv = 0
          CcbCDocu.ImpVta = CcbCDocu.ImpExo
          CcbCDocu.ImpBrt = CcbCDocu.ImpExo.

  /* CALCULO DE PERCEPCIONES */
  RUN vta2/calcula-percepcion ( ROWID(Ccbcdocu) ).

  /* ************************************* */
  /* RHC 22/07/2016 TRANSFERENCIA GRATUITA */
  /* ************************************* */
/*   IF CcbCDocu.FmaPgo = "900" THEN       */
/*       ASSIGN                            */
/*       CcbCDocu.ImpBrt = 0               */
/*       CcbCDocu.ImpDto = 0               */
/*       CcbCDocu.ImpExo = CcbCDocu.ImpTot */
/*       CcbCDocu.ImpVta = 0               */
/*       CcbCDocu.ImpIgv = 0.              */
  /* ************************************* */

  /* *********************** */
  FIND CURRENT CcbCDocu.
  /* *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


