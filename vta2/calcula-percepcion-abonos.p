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

DEF INPUT PARAMETER pRowid AS ROWID.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

FIND Ccbcdocu WHERE ROWID(Ccbcdocu) = pRowid EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbcdocu THEN RETURN "ADM-ERROR".
IF LOOKUP(Ccbcdocu.coddoc, 'N/C,N/D') = 0 THEN RETURN 'OK'.

DEF BUFFER CDOCU FOR Ccbcdocu.
DEF BUFFER DDOCU FOR Ccbddocu.

FIND CDOCU WHERE CDOCU.codcia = Ccbcdocu.codcia
    AND CDOCU.coddoc = Ccbcdocu.codref
    AND CDOCU.nrodoc = Ccbcdocu.nroref
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE CDOCU THEN RETURN 'OK'.

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
         HEIGHT             = 4.27
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* ESTE PROCESO SE DEBE CORRER DESPUES DE CALCULAR TODO EL COMPROBANTE */
DEF VAR s-PorPercepcion AS DEC NO-UNDO.
DEF VAR f-ImpPercepcion AS DEC NO-UNDO.

PERCEPCION:
DO:
    /* Por si acaso limpiamos información donde debe estar los cálculos de percepción */
    ASSIGN
        s-Porpercepcion = 0
        Ccbcdocu.AcuBon[4] = 0
        Ccbcdocu.AcuBon[5] = 0.
    /* ****************************************************************************** */
    FOR EACH Ccbddocu OF Ccbcdocu:
        ASSIGN
            Ccbddocu.PorDcto_Adelanto[5] = 0
            Ccbddocu.ImpDcto_Adelanto[5] = 0.
/*         FIND FIRST DDOCU OF CDOCU WHERE DDOCU.codmat = Ccbddocu.codmat NO-LOCK NO-ERROR.                             */
/*         IF AVAILABLE DDOCU THEN                                                                                      */
/*             ASSIGN                                                                                                   */
/*             s-PorPercepcion = (IF DDOCU.PorDcto_Adelanto[5] > 0 THEN DDOCU.PorDcto_Adelanto[5] ELSE s-PorPercepcion) */
/*             Ccbddocu.PorDcto_Adelanto[5] = DDOCU.PorDcto_Adelanto[5]                                                 */
/*             Ccbddocu.ImpDcto_Adelanto[5] = ROUND(Ccbddocu.implin * Ccbddocu.PorDcto_Adelanto[5] / 100, 2).           */
    END.
    /* Actualizamos el total de la N/A */
    FOR EACH ccbddocu OF ccbcdocu NO-LOCK.
        ccbcdocu.AcuBon[5] = ccbcdocu.AcuBon[5] + ccbddocu.ImpDcto_Adelanto[5].
    END.
    IF ccbcdocu.AcuBon[5] = 0 THEN s-PorPercepcion = 0.
    /* RHC 24/10/2013 MODIFICACION SOLICITADA POR JUAN HERMOZA */
    ASSIGN
        ccbcdocu.AcuBon[4] = s-PorPercepcion
        ccbcdocu.ImpTot = ccbcdocu.ImpTot + ccbcdocu.AcuBon[5]
        ccbcdocu.SdoAct = ccbcdocu.SdoAct + ccbcdocu.AcuBon[5].
END.
IF AVAILABLE(ccbcdocu) THEN RELEASE ccbcdocu.
IF AVAILABLE(ccbddocu) THEN RELEASE ccbddocu.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


