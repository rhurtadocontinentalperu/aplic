&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

        /* definimos el precio base */
        FIND FIRST Lg-dmatpr WHERE Lg-dmatpr.codcia = s-codcia
            AND Lg-dmatpr.codmat = Almmmatg.codmat
            AND Lg-dmatpr.codpro = Almmmatg.CodPr1
            AND Lg-dmatpr.flgest = 'A'
            NO-LOCK NO-ERROR.
        IF AVAILABLE Lg-dmatpr THEN DO:
            IF S-CODMON = 1 THEN DO:
                IF Almmmatg.MonVta = 1 THEN
                    ASSIGN F-PREBAS = Lg-dmatpr.PreAct * (1 + Lg-dmatpr.IgvMat / 100) * F-FACTOR.
                ELSE
                    ASSIGN F-PREBAS = Lg-dmatpr.PreAct * (1 + Lg-dmatpr.IgvMat / 100) * S-TpoCmb * F-FACTOR.
            END.
            IF S-CODMON = 2 THEN DO:
               IF Almmmatg.MonVta = 2 THEN
                  ASSIGN F-PREBAS = Lg-dmatpr.PreAct * (1 + Lg-dmatpr.IgvMat / 100) * F-FACTOR.
               ELSE
                  ASSIGN F-PREBAS = (Lg-dmatpr.PreAct * (1 + Lg-dmatpr.IgvMat / 100) / S-TpoCmb) * F-FACTOR.
            END.
        END.
        /* Definimos los descuentos */
        FIND Facctpro WHERE Facctpro.codcia = s-codcia
            AND Facctpro.codpro = Almmmatg.codpr1
            AND FAcctpro.categoria = Facctmat.categoria
            NO-LOCK NO-ERROR.
        IF AVAILABLE Facctpro 
        THEN DO:
            IF x-FlgEst <> '' THEN x-ClfCli = x-FlgEst.
            CASE x-ClfCli:
            WHEN 'A' THEN F-DSCTOS = (1 - (1 - Facctpro.dsctos[1] / 100) * (1 - Facctpro.Dsctos[2] / 100) * (1 - Facctpro.Dsctos[3] / 100) * (1 - Facctpro.Dsctos[4] / 100) ) * 100.
            WHEN 'B' THEN F-DSCTOS = (1 - (1 - Facctpro.dsctos[5] / 100) * (1 - Facctpro.Dsctos[6] / 100) * (1 - Facctpro.Dsctos[7] / 100) * (1 - Facctpro.Dsctos[8] / 100) ) * 100.
            WHEN 'C' THEN F-DSCTOS = (1 - (1 - Facctpro.dsctos[9] / 100) * (1 - Facctpro.Dsctos[10] / 100) * (1 - Facctpro.Dsctos[11] / 100) * (1 - Facctpro.Dsctos[12] / 100) ) * 100.
            OTHERWISE F-DSCTOS = (1 - (1 - Facctpro.dsctos[9] / 100) * (1 - Facctpro.Dsctos[10] / 100) * (1 - Facctpro.Dsctos[11] / 100) * (1 - Facctpro.Dsctos[12] / 100) ) * 100.
            END CASE.
        END.
        F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).
        RUN BIN/_ROUND1(F-PREVTA,4,OUTPUT F-PREVTA).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


