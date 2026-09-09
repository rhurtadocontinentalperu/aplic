&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Genereción de comprobantes de Percepción

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
IF LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL,TCK') = 0 THEN RETURN 'OK'.

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

s-Porpercepcion = 0.
PERCEPCION:
DO:
    /* Por si acaso limpiamos información donde debe estar los cálculos de percepción */
    ASSIGN
        Ccbcdocu.AcuBon[4] = 0
        Ccbcdocu.AcuBon[5] = 0.
    /* ****************************************************************************** */
    /* Veamos si es sujeto a Percepcion */
    f-ImpPercepcion = 0.
    FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK,
        FIRST Almsfami OF Almmmatg WHERE Almsfami.Libre_C05 = "SI":
        f-ImpPercepcion = f-ImpPercepcion + Ccbddocu.ImpLin.
    END.
    IF Ccbcdocu.coddoc = "BOL" THEN DO:
        IF Ccbcdocu.codmon = 1 AND f-ImpPercepcion <= 700 THEN LEAVE PERCEPCION.
        IF Ccbcdocu.codmon = 2 AND f-ImpPercepcion * Ccbcdocu.tpocmb <= 700 THEN LEAVE PERCEPCION.
    END.
    FIND FIRST Vtatabla WHERE Vtatabla.codcia = s-codcia
        AND Vtatabla.tabla = 'CLNOPER'
        AND VtaTabla.Llave_c1 = CcbCDocu.RucCli
        NO-LOCK NO-ERROR.
    IF AVAILABLE Vtatabla THEN LEAVE PERCEPCION.
    /* ******************************** */
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = Ccbcdocu.codcli
        NO-LOCK.
    IF gn-clie.Libre_L01 = YES AND gn-clie.RucOld <> "SI" THEN s-Porpercepcion = 0.5.
    IF gn-clie.Libre_L01 = NO AND gn-clie.RucOld <> "SI" THEN s-Porpercepcion = 2.
    IF Ccbcdocu.coddoc = "BOL" THEN s-PorPercepcion = 2.
    FOR EACH ccbddocu OF ccbcdocu, 
        FIRST Almmmatg OF ccbddocu NO-LOCK,
        FIRST Almsfami OF Almmmatg NO-LOCK:
        ASSIGN
            ccbddocu.PorDcto_Adelanto[5] = 0
            ccbddocu.ImpDcto_Adelanto[5] = 0.
        IF Almsfami.Libre_c05 = "SI" THEN
            ASSIGN
            ccbddocu.PorDcto_Adelanto[5] = s-PorPercepcion
            ccbddocu.ImpDcto_Adelanto[5] = ROUND(ccbddocu.implin * s-PorPercepcion / 100, 2).
    END.
    /* Actualizamos el total de la factura */
    FOR EACH ccbddocu OF ccbcdocu NO-LOCK.
        ccbcdocu.AcuBon[5] = ccbcdocu.AcuBon[5] + ccbddocu.ImpDcto_Adelanto[5].
    END.
    IF ccbcdocu.AcuBon[5] = 0 THEN LEAVE PERCEPCION.
    /* 
    SE INCREMENTA EL IMPORTE Y EL SALDO DEL COMPROBANTE SIN AFECTAR EL IGV.
    AL IMPRIMIR SEPARAR LA PERCEPCION.
    */
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


