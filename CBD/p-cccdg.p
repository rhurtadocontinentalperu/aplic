&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER s-codcia AS INT.
DEF INPUT PARAMETER s-periodo AS INT.
DEF INPUT PARAMETER s-nromes AS INT.
DEF INPUT PARAMETER s-accion AS LOG.

DEF TEMP-TABLE T-CCO 
    FIELD cco AS CHAR
    FIELD TotGtoMn AS DEC
    FIELD TotGtoMe AS DEC
    INDEX Llave01 AS PRIMARY cco.

DEF VAR x-TotGtoMn AS DEC.
DEF VAR x-TotGtoMe AS DEC.
    
/* LIMPIAMOS LA INFORMACION ALMACENADA */
FOR EACH Cb-CcCDg WHERE cb-cccdg.codcia = s-codcia
        AND cb-cccdg.periodo = s-periodo
        AND cb-cccdg.nromes  = s-nromes:
    ASSIGN
        Cb-CcCDg.ImpGtoMe = 0
        Cb-CcCDg.ImpGtoMn = 0.
END.
FOR EACH Cb-CcDDg WHERE cb-ccddg.codcia = s-codcia
        AND cb-ccddg.periodo = s-periodo
        AND cb-ccddg.nromes  = s-nromes:
    ASSIGN
        Cb-CcDDg.ImpGtoMe = 0
        Cb-CcDDg.ImpGtoMn = 0
        Cb-CcDDg.TotGtoMe = 0
        Cb-CcDDg.TotGtoMn = 0.
END.
/* OJO */
IF s-accion = NO THEN RETURN.

/* CALCULAMOS LOS GASTOS TOTALES */        
FOR EACH CB-DMOV WHERE CB-DMOV.codcia = s-codcia
        AND CB-DMOV.periodo = s-periodo
        AND CB-DMOV.nromes = s-nromes
        AND CB-DMOV.codcta BEGINS '9'
        AND CB-DMOV.cco <> ''
        NO-LOCK:
    FIND T-CCO WHERE T-CCO.cco = CB-DMOV.cco EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE T-CCO THEN CREATE T-CCO.
    ASSIGN
        T-CCO.cco = CB-DMOV.cco.
    IF CB-DMOV.TpoMov = NO
    THEN ASSIGN
            T-CCO.TotGtoMn = T-CCO.TotGtoMn + cb-dmov.impmn1
            T-CCO.TotGtoMe = T-CCO.TotGtoMe + cb-dmov.impmn2.
    ELSE ASSIGN
            T-CCO.TotGtoMn = T-CCO.TotGtoMn - cb-dmov.impmn1
            T-CCO.TotGtoMe = T-CCO.TotGtoMe - cb-dmov.impmn2.
END.
/* CARGAMOS LOS TOTALES */
FOR EACH T-CCO:
    FIND CB-CcCDg WHERE cb-cccdg.codcia = s-codcia
        AND cb-cccdg.periodo = s-periodo
        AND cb-cccdg.nromes = s-nromes
        AND cb-cccdg.cco = T-CCO.cco
        EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE cb-cccdg 
    THEN ASSIGN 
            CB-CcCDg.ImpGtoMn = T-CCO.TotGtoMn
            CB-CcCDg.ImpGtoMe = T-CCO.TotGtoMe.
    FOR EACH CB-CcDDg WHERE cb-ccddg.codcia = s-codcia
            AND cb-ccddg.periodo = s-periodo
            AND cb-ccddg.nromes = s-nromes
            AND cb-ccddg.ccoD = T-CCO.cco:
        ASSIGN 
            CB-CcDDg.TotGtoMn = T-CCO.TotGtoMn
            CB-CcDDg.TotGtoMe = T-CCO.TotGtoMe.
    END.
END.
/* DISTRIBUIMOS LOS GASTOS */
FOR EACH CB-CcCDg WHERE cb-cccdg.codcia = s-codcia
        AND cb-cccdg.periodo = s-periodo
        AND cb-cccdg.nromes  = s-nromes:
    /* TOTAL GASTOS */
    ASSIGN
        x-TotGtoMn = 0
        x-TotGtoMe = 0.
    FOR EACH Cb-CcDDg OF CB-CcCDg:
        ASSIGN
            x-TotGtoMn = x-TotGtoMn + CB-CcDDg.TotGtoMn
            x-TotGtoMe = x-TotGtoMe + CB-CcDDg.TotGtoMe.
    END.
    FOR EACH Cb-CcDDg OF CB-CcCDg:
        ASSIGN
            Cb-CcDDg.ImpGtoMn = IF x-totgtomn <> 0 THEN cb-cccdg.impgtomn * cb-ccddg.totgtomn / x-totgtomn ELSE 0
            Cb-CcDDg.ImpGtoMe = IF x-totgtomn <> 0 THEN cb-cccdg.impgtome * cb-ccddg.totgtome / x-totgtome ELSE 0.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


