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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */


    /* CALCULO GENERAL DE LOS IMPORTES POR LINEA */
    FIND Almmmatg WHERE Almmmatg.codcia = T-DDOCU.codcia
        AND Almmmatg.codmat = T-DDOCU.codmat
        NO-LOCK.
    /* PRECIO UNITARIO Y % DE DESCUENTO */
    FIND gn-divi WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = s-coddiv NO-LOCK.
    CASE GN-DIVI.TipDto:
        WHEN 1 THEN DO:             /* PRECIO UNITARIO INCLUIDO DESCUENTO */
            ASSIGN
                T-DDOCU.ImpLin = T-DDOCU.PreUni * T-DDOCU.CanPed.
        END.
        WHEN 2 THEN DO:             /* PRECIO UNITARIO NO INCLUIDO DESCUENTO */
            ASSIGN
                T-DDOCU.ImpLin = T-DDOCU.PreUni * T-DDOCU.CanPed * 
                                  (1 - T-DDOCU.PorDto1 / 100) *
                                  (1 - T-DDOCU.PorDto2 / 100) *
                                  (1 - T-DDOCU.PorDto3 / 100).
        END.
    END CASE.
    ASSIGN 
      T-DDOCU.AftIgv = Almmmatg.AftIgv 
      T-DDOCU.AftIsc = Almmmatg.AftIsc.
    IF s-FlgIgv = YES THEN DO:
        T-DDOCU.PorIgv = s-PorIgv.
        IF T-DDOCU.AftIgv = NO THEN DO:
            T-DDOCU.PorIgv = 0.
        END.
    END.
    ELSE DO:
        T-DDOCU.AftIgv = NO.
        T-DDOCU.PorIgv = 0.
    END.
    /* IMPORTE VENTA */
    T-DDOCU.ImpIgv = T-DDOCU.ImpLin / (1 + T-DDOCU.PorIgv / 100 ) * T-DDOCU.PorIgv / 100.
    IF T-DDOCU.AftIgv = YES THEN T-DDOCU.ImpVta = T-DDOCU.ImpLin - T-DDOCU.ImpIgv.
    IF T-DDOCU.AftIgv = NO  THEN T-DDOCU.ImpVta = 0.
    /* IMPORTE EXONERADO */
    IF T-DDOCU.AftIgv = NO  THEN T-DDOCU.ImpExo = T-DDOCU.ImpLin.
    IF T-DDOCU.AftIgv = YES THEN T-DDOCU.ImpExo = 0.
    /* IMPORTE DESCUENTO */
    T-DDOCU.ImpDto = ( ( T-DDOCU.PreUni * T-DDOCU.CanPed ) - T-DDOCU.ImpLin ) / ( 1 + T-DDOCU.PorIgv / 100 ).
    /* IMPORTE BRUTO */
    T-DDOCU.ImpBrt = T-DDOCU.ImpDto + T-DDOCU.ImpExo + T-DDOCU.ImpVta.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


