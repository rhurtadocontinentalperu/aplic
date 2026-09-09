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
         HEIGHT             = 15.04
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

    DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
    DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.

    ASSIGN
        INTEGRAL.Ccbcdocu.ImpDto = 0
        INTEGRAL.Ccbcdocu.ImpIgv = 0
        INTEGRAL.Ccbcdocu.ImpIsc = 0
        INTEGRAL.Ccbcdocu.ImpTot = 0
        INTEGRAL.Ccbcdocu.ImpExo = 0.
        INTEGRAL.Ccbcdocu.acubon[10] = 0.

    FOR EACH INTEGRAL.Ccbddocu OF INTEGRAL.Ccbcdocu NO-LOCK:        
       F-Igv = F-Igv + INTEGRAL.Ccbddocu.ImpIgv.
       F-Isc = F-Isc + INTEGRAL.Ccbddocu.ImpIsc.
       INTEGRAL.Ccbcdocu.ImpTot = INTEGRAL.Ccbcdocu.ImpTot + INTEGRAL.Ccbddocu.ImpLin.

       /*IF NOT INTEGRAL.Ccbddocu.AftIgv THEN INTEGRAL.Ccbcdocu.ImpExo = INTEGRAL.Ccbcdocu.ImpExo + INTEGRAL.Ccbddocu.ImpLin.*/

       IF INTEGRAL.Ccbddocu.AftIgv = YES
       THEN INTEGRAL.Ccbcdocu.ImpDto = INTEGRAL.Ccbcdocu.ImpDto + ROUND(INTEGRAL.Ccbddocu.ImpDto / (1 + INTEGRAL.Ccbcdocu.PorIgv / 100), 2).
       ELSE INTEGRAL.Ccbcdocu.ImpDto = INTEGRAL.Ccbcdocu.ImpDto + INTEGRAL.Ccbddocu.ImpDto.

        IF ccbddocu.codmat = x-articulo-ICBPER THEN DO:
            /* Inafecto */
            ASSIGN ccbcdocu.AcuBon[10] = ccbcdocu.AcuBon[10] + ccbddocu.implin.
        END.
        ELSE DO:
            IF NOT ccbddocu.AftIgv THEN ccbcdocu.ImpExo = ccbcdocu.ImpExo + ccbddocu.ImpLin.
        END.

    END.

    ASSIGN
        INTEGRAL.Ccbcdocu.ImpIgv = ROUND(F-IGV,2)
        INTEGRAL.Ccbcdocu.ImpIsc = ROUND(F-ISC,2)
        INTEGRAL.Ccbcdocu.ImpVta = INTEGRAL.Ccbcdocu.ImpTot - INTEGRAL.Ccbcdocu.ImpExo - INTEGRAL.Ccbcdocu.ImpIgv - ccbcdocu.AcuBon[10].
    /* RHC 22.12.06 */
    IF INTEGRAL.Ccbcdocu.PorDto > 0 THEN DO:
        INTEGRAL.Ccbcdocu.ImpDto = INTEGRAL.Ccbcdocu.ImpDto + ROUND((INTEGRAL.Ccbcdocu.ImpVta + INTEGRAL.Ccbcdocu.ImpExo) * INTEGRAL.Ccbcdocu.PorDto / 100, 2).
        INTEGRAL.Ccbcdocu.ImpTot = ROUND(INTEGRAL.Ccbcdocu.ImpTot * (1 - INTEGRAL.Ccbcdocu.PorDto / 100),2).
        INTEGRAL.Ccbcdocu.ImpVta = ROUND(INTEGRAL.Ccbcdocu.ImpVta * (1 - INTEGRAL.Ccbcdocu.PorDto / 100),2).
        INTEGRAL.Ccbcdocu.ImpExo = ROUND(INTEGRAL.Ccbcdocu.ImpExo * (1 - INTEGRAL.Ccbcdocu.PorDto / 100),2).
        INTEGRAL.Ccbcdocu.ImpIgv = INTEGRAL.Ccbcdocu.ImpTot - INTEGRAL.Ccbcdocu.ImpExo - INTEGRAL.Ccbcdocu.ImpVta.
    END.
    ASSIGN
        INTEGRAL.Ccbcdocu.ImpBrt = INTEGRAL.Ccbcdocu.ImpVta /*+ INTEGRAL.Ccbcdocu.ImpIsc*/ + INTEGRAL.Ccbcdocu.ImpDto /*+ INTEGRAL.Ccbcdocu.ImpExo*/
        INTEGRAL.Ccbcdocu.SdoAct  = INTEGRAL.Ccbcdocu.ImpTot.
  /* CALCULO DE PERCEPCIONES */
  RUN vta2/calcula-percepcion-abonos ( ROWID(INTEGRAL.Ccbcdocu) ).
  FIND CURRENT INTEGRAL.Ccbcdocu.
  /* *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


