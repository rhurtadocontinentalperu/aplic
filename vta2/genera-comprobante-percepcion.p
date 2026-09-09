&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-CMvto NO-UNDO LIKE CcbCMvto.
DEFINE TEMP-TABLE T-DMvto NO-UNDO LIKE CcbDMvto.



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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

/* Control de correlativos */
DEF VAR s-coddoc AS CHAR INIT "PER" NO-UNDO.
DEF VAR s-nroser AS INT NO-UNDO.

FIND Ccbccaja WHERE ROWID(Ccbccaja) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbccaja THEN RETURN "ADM-ERROR".
IF LOOKUP(Ccbccaja.Tipo, 'MOSTRADOR,CANCELACION') = 0 THEN RETURN.

/* que no se repita */
FIND FIRST Ccbcmvto WHERE CcbCMvto.CodCia = Ccbccaja.codcia
    AND CcbCMvto.CodDiv = s-coddiv
    AND CcbCMvto.CodDoc = s-coddoc
    AND CcbCMvto.Libre_chr[1] = Ccbccaja.coddoc
    AND CcbCMvto.Libre_chr[2] = Ccbccaja.nrodoc
    NO-LOCK NO-ERROR.
IF AVAILABLE Ccbcmvto THEN RETURN.


DEF BUFFER CDOCU FOR Ccbcdocu.

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
   Temp-Tables and Buffers:
      TABLE: T-CMvto T "?" NO-UNDO INTEGRAL CcbCMvto
      TABLE: T-DMvto T "?" NO-UNDO INTEGRAL CcbDMvto
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 6.62
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF VAR x-Factor AS DEC DECIMALS 6 NO-UNDO.
DEF VAR x-ImpPer AS DEC NO-UNDO.

/* 1ro Calculamos percepción por Amortizaciones */
RUN Paso-1.

/* 2do. Calculamos percepción por N/C aplicadas */
RUN Paso-2.

/* 3ro. Calculamos percepción por PRA por aplicar con N/C cerradas */
/*RUN Paso-3.*/

/* 4to. Generamos el comprobante de retención */
RUN Paso-4.
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Paso-1) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Paso-1 Procedure 
PROCEDURE Paso-1 :
/*------------------------------------------------------------------------------
  Purpose:     Percepción por Amortización
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Rastreamos los PRC */                                          
FOR EACH Ccbdcaja OF Ccbccaja, FIRST Ccbcdocu WHERE Ccbcdocu.codcia = Ccbdcaja.codcia
    AND Ccbcdocu.coddoc = Ccbdcaja.codref AND Ccbcdocu.nrodoc = Ccbdcaja.nroref,
    FIRST CDOCU WHERE CDOCU.codcia = Ccbcdocu.codcia AND CDOCU.coddoc = "PRC"
    AND CDOCU.codref = Ccbcdocu.coddoc AND CDOCU.nroref = Ccbcdocu.nrodoc
    AND CDOCU.flgest = "X":
    /* Factor de aplicación */
    x-Factor = ROUND(Ccbcdocu.AcuBon[5] / Ccbcdocu.ImpTot * Ccbdcaja.ImpTot, 2).
    /* Monto de la Percepción */
    x-ImpPer = MINIMUM(x-Factor, CDOCU.SdoAct).
    IF x-ImpPer <= 0 THEN NEXT.
    /* Registro de la percepción */
    CREATE T-DMVTO.
    ASSIGN
        T-DMvto.CodOpe = CDOCU.coddoc
        T-DMvto.NroAst = CDOCU.nrodoc
        T-DMvto.CodRef = Ccbcdocu.coddoc 
        T-DMvto.NroRef = Ccbcdocu.nrodoc
        T-DMvto.ImpTot = x-ImpPer
        T-DMvto.ImpInt = Ccbcdocu.AcuBon[4]
        T-DMvto.ImpDoc = x-ImpPer / Ccbcdocu.AcuBon[4] * 100.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Paso-2) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Paso-2 Procedure 
PROCEDURE Paso-2 :
/*------------------------------------------------------------------------------
  Purpose:     Percepción por Notas de Crédito
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Calculamos cuanto de percepción debemos cubrir */
DEF VAR x-SaldoPer AS DEC NO-UNDO.
FOR EACH T-DMVTO WHERE LOOKUP(T-DMVTO.codref, 'FAC,BOL,TCK') > 0:
    x-SaldoPer = x-SaldoPer + T-DMVTO.ImpTot.
END.
IF x-SaldoPer <= 0 THEN RETURN.

/* Aplicamos la percepción */
FOR EACH Ccbdmov NO-LOCK WHERE Ccbdmov.codcia = s-codcia
    AND Ccbdmov.coddoc = "N/C"
    AND Ccbdmov.codref = Ccbccaja.coddoc
    AND Ccbdmov.nroref = Ccbccaja.nrodoc,
    FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.coddoc = Ccbdmov.coddoc
    AND Ccbcdocu.nrodoc = ccbdmov.nrodoc,
    FIRST CDOCU NO-LOCK WHERE CDOCU.codcia = s-codcia
    AND CDOCU.coddoc = "PRA"
    AND CDOCU.codref = Ccbcdocu.coddoc
    AND CDOCU.nroref = Ccbcdocu.nrodoc
    AND CDOCU.flgest = "X":
    IF x-SaldoPer <= 0 THEN LEAVE.
    /* Factor de aplicación */
    x-Factor = ROUND(Ccbcdocu.AcuBon[5] / Ccbcdocu.ImpTot * Ccbdmov.ImpTot, 2).
    /* Monto de la Percepción */
    x-ImpPer = MINIMUM(x-Factor, CDOCU.SdoAct, x-SaldoPer).
    /* Registro de la percepción */
    CREATE T-DMVTO.
    ASSIGN
        T-DMvto.CodOpe = CDOCU.coddoc
        T-DMvto.NroAst = CDOCU.nrodoc
        T-DMvto.CodRef = Ccbcdocu.coddoc 
        T-DMvto.NroRef = Ccbcdocu.nrodoc
        T-DMvto.ImpTot = x-ImpPer
        T-DMvto.ImpInt = Ccbcdocu.AcuBon[4]
        T-DMvto.ImpDoc = x-ImpPer / Ccbcdocu.AcuBon[4] * 100.
    /* Saldo */
    x-SaldoPer = x-SaldoPer - x-ImpPer.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Paso-3) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Paso-3 Procedure 
PROCEDURE Paso-3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Calculamos cuanto de percepción falta por cubrir */
DEF VAR x-SaldoPer AS DEC NO-UNDO.
FOR EACH T-DMVTO:
    x-SaldoPer = x-SaldoPer + (IF T-DMVTO.codref = "N/C" THEN -1 ELSE 1) * T-DMVTO.ImpTot.
END.
IF x-SaldoPer <= 0 THEN RETURN.

FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.coddoc = "N/C"
    AND Ccbcdocu.codcli = Ccbccaja.codcli
    AND Ccbcdocu.flgest = "C",
    FIRST CDOCU NO-LOCK WHERE CDOCU.codcia = s-codcia
    AND CDOCU.coddoc = "PRA"
    AND CDOCU.codref = Ccbcdocu.coddoc
    AND CDOCU.nroref = Ccbcdocu.nrodoc
    AND CDOCU.flgest = "X"
    BY Ccbcdocu.fchdoc:
    IF x-SaldoPer <= 0 THEN LEAVE.
    /* Monto de la Percepción */
    x-ImpPer = MINIMUM(CDOCU.SdoAct, x-SaldoPer).
    /* Registro de la percepción */
    CREATE T-DMVTO.
    ASSIGN
        T-DMvto.CodOpe = CDOCU.coddoc
        T-DMvto.NroAst = CDOCU.nrodoc
        T-DMvto.CodRef = Ccbcdocu.coddoc 
        T-DMvto.NroRef = Ccbcdocu.nrodoc
        T-DMvto.ImpTot = x-ImpPer
        T-DMvto.ImpInt = Ccbcdocu.AcuBon[4]
        T-DMvto.ImpDoc = x-ImpPer / Ccbcdocu.AcuBon[4] * 100.
    /* Saldo */
    x-SaldoPer = x-SaldoPer - x-ImpPer.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Paso-4) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Paso-4 Procedure 
PROCEDURE Paso-4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST T-DMVTO NO-LOCK NO-ERROR.
IF NOT AVAILABLE T-DMVTO THEN RETURN "OK".

FIND FIRST Faccorre WHERE Faccorre.codcia = s-codcia
    AND Faccorre.coddoc = s-coddoc
    AND Faccorre.coddiv = s-coddiv
    AND Faccorre.flgest = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccorre THEN DO:
    MESSAGE 'NO está configurado el correlativo para el documento' s-coddoc SKIP
        'de la división' s-coddiv
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
s-nroser = Faccorre.nroser.

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    {vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}

    REPEAT:
        IF NOT CAN-FIND(FIRST CcbCMvto WHERE CcbCMvto.codcia = s-codcia
                    AND CcbCMvto.coddiv = FacCorre.coddiv
                    AND CcbCMvto.coddoc = FacCorre.coddoc
                    AND CcbCMvto.nrodoc = STRING(FacCorre.nroser, '999') + 
                    STRING(FacCorre.correlativo, '999999')
                    NO-LOCK)
            THEN LEAVE.
        ASSIGN
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
    END.

    CREATE Ccbcmvto.
    ASSIGN
        CcbCMvto.CodCia = s-codcia
        CcbCMvto.CodDiv = s-coddiv
        CcbCMvto.CodDoc = s-coddoc
        CcbCMvto.NroDoc = STRING(s-nroser, '999') + STRING(Faccorre.correlativo, '999999')
        CcbCMvto.CodCli = Ccbccaja.codcli
        CcbCMvto.CodMon = 1
        CcbCMvto.FchDoc = Ccbccaja.fchdoc
        CcbCMvto.FlgEst = "P"
        CcbCMvto.Glosa = ""
        CcbCMvto.ImpTot = 0
        CcbCMvto.Libre_chr[1] = Ccbccaja.coddoc
        CcbCMvto.Libre_chr[2] = Ccbccaja.nrodoc
        CcbCMvto.Libre_chr[3] = Ccbccaja.tipo
        CcbCMvto.TpoCmb = Ccbccaja.tpocmb
        CcbCMvto.Usuario = Ccbccaja.usuario.
    ASSIGN
        Faccorre.correlativo = Faccorre.correlativo + 1.

    FOR EACH T-DMVTO:
        /* actualizamos saldos de percepciones */
        CREATE Ccbdmvto.
        BUFFER-COPY Ccbcmvto
            TO Ccbdmvto
            ASSIGN
            Ccbdmvto.codope = T-DMvto.CodOpe
            Ccbdmvto.nroast = T-DMvto.NroAst
            Ccbdmvto.codref = T-DMvto.CodRef
            Ccbdmvto.nroref = T-DMvto.NroRef
            Ccbdmvto.imptot = T-DMvto.ImpTot
            Ccbdmvto.impdoc = T-DMvto.ImpDoc
            Ccbdmvto.ImpInt = T-Dmvto.ImpInt.
        FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
            AND Ccbcdocu.coddoc = Ccbdmvto.codope
            AND Ccbcdocu.nrodoc = Ccbdmvto.nroast
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Ccbcdocu THEN UNDO, RETURN 'ADM-ERROR'.
        ASSIGN
            Ccbcdocu.sdoact = Ccbcdocu.sdoact - Ccbdmvto.imptot.
        IF Ccbcdocu.sdoact <= 0 THEN Ccbcdocu.flgest = "C".
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

