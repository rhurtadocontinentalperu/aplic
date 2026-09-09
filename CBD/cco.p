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
         HEIGHT             = 2.01
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER s-CodCia AS INT.
DEF INPUT PARAMETER s-Periodo AS INT.
DEF INPUT PARAMETER s-NroMes AS INT.

DEFINE SHARED VARIABLE   CB-CODCIA   AS INTEGER.   
DEFINE SHARED VARIABLE   PV-CODCIA   AS INTEGER.   
DEFINE SHARED VARIABLE   CL-CODCIA   AS INTEGER.   

DEFINE SHARED TEMP-TABLE RMOV LIKE cb-dmov.

FOR EACH CB-DMOV WHERE cb-dmov.codcia = s-codcia
        AND cb-dmov.periodo = s-periodo
        AND cb-dmov.nromes = s-nromes
        AND cb-dmov.codcta BEGINS '9'
        AND cb-dmov.cco <> '' NO-LOCK,
        FIRST CB-AUXI WHERE cb-auxi.codcia = cb-codcia
            AND cb-auxi.clfaux = 'CCO'
            and cb-auxi.codaux = cb-dmov.cco NO-LOCK:

    FIND RMOV WHERE RMOV.codcia = cb-dmov.codcia 
        AND RMOV.cco = cb-dmov.cco
        NO-ERROR.
    IF NOT AVAILABLE RMOV
    THEN CREATE RMOV.
    ASSIGN
        RMOV.codcia = cb-dmov.codcia
        RMOV.cco    = cb-dmov.cco.
    IF cb-dmov.TpoMov = NO
    THEN ASSIGN
            RMOV.impmn1 = RMOV.impmn1 + cb-dmov.impmn1
            RMOV.impmn2 = RMOV.impmn2 + cb-dmov.impmn2.
    ELSE ASSIGN
            RMOV.impmn1 = RMOV.impmn1 - cb-dmov.impmn1
            RMOV.impmn2 = RMOV.impmn2 - cb-dmov.impmn2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


