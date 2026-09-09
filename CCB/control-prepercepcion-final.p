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
DEF BUFFER CDOCU FOR Ccbcdocu.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-coddoc AS CHAR INIT "PRP" NO-UNDO.
DEF VAR s-nroser AS INTE INIT 000   NO-UNDO.
DEF VAR x-Factor AS DEC DECIMALS 6 NO-UNDO.
DEF VAR x-ImpPer AS DEC NO-UNDO.


/* GENERAMOS CONTROL DE PERCEPCIONES POR COMPROBANTES (PRP) */
DEF INPUT PARAMETER s-coddiv AS CHAR.
DEF INPUT PARAMETER CodDocCja AS CHAR.
DEF INPUT PARAMETER NroDocCja AS CHAR.

FIND Ccbccaja WHERE Ccbccaja.codcia = s-codcia
    AND Ccbccaja.coddoc = CodDocCja
    AND Ccbccaja.nrodoc = NroDocCja
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbccaja THEN RETURN "ADM-ERROR".
IF LOOKUP(Ccbccaja.Tipo, 'MOSTRADOR,CANCELACION') = 0 THEN RETURN "OK".

/* que no se repita */
FIND FIRST Ccbcmvto WHERE CcbCMvto.CodCia = s-codcia
    AND CcbCMvto.CodDiv = s-coddiv
    AND CcbCMvto.CodDoc = s-coddoc
    AND CcbCMvto.Libre_chr[1] = CodDocCja
    AND CcbCMvto.Libre_chr[2] = NroDocCja
    AND CcbCMvto.FlgEst <> "A"
    NO-LOCK NO-ERROR.
IF AVAILABLE Ccbcmvto THEN RETURN "OK".

/* FIND FIRST Faccorre WHERE Faccorre.codcia = s-codcia                             */
/*     AND Faccorre.coddiv = s-coddiv                                               */
/*     AND Faccorre.coddoc = s-coddoc                                               */
/*     AND Faccorre.flgest = YES                                                    */
/*     NO-LOCK NO-ERROR.                                                            */
/* IF NOT AVAILABLE Faccorre THEN DO:                                               */
/*     MESSAGE 'NO está configurado el correlativo para el documento' s-coddoc SKIP */
/*         'de la división' s-coddiv                                                */
/*         VIEW-AS ALERT-BOX ERROR.                                                 */
/*     RETURN 'ADM-ERROR'.                                                          */
/* END.                                                                             */
/* s-nroser = Faccorre.nroser.      
/* CORRELATIVO UNICO PARA TODA LA EMPRESA */                                                */
FIND FIRST Facdocum WHERE Facdocum.codcia = s-codcia
    AND Facdocum.coddoc = s-coddoc
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Facdocum THEN DO:
    MESSAGE 'NO está configurado el documento' s-coddoc '(PRE-PERCEPCION)'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

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
FOR EACH Ccbdcaja OF Ccbccaja NO-LOCK, 
    FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Ccbdcaja.codcia
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
DEF VAR x-NroDoc AS INT INIT 0 NO-UNDO.

FIND FIRST T-DMVTO NO-LOCK NO-ERROR.
IF NOT AVAILABLE T-DMVTO THEN RETURN "OK".

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    /* Correlativo Unico para toda la empresa */
    FOR FIRST VtaCDocu NO-LOCK WHERE VtaCDocu.codcia = s-codcia
        AND VtaCDocu.codped = s-coddoc
        BY VtaCDocu.nroped DESC:
        ASSIGN x-NroDoc = INTEGER(VtaCDocu.nroped) NO-ERROR.
    END.
    x-NroDoc = x-NroDoc + 1.
    REPEAT:     /* Que no se repita */
        IF NOT CAN-FIND(FIRST VtaCDocu WHERE VtaCDocu.codcia = s-codcia
                        AND VtaCDocu.codped = s-coddoc
                        AND VtaCDocu.nroped = STRING(x-NroDoc, '999999999')
                        NO-LOCK)
            THEN LEAVE.
        ASSIGN
            x-NroDoc = x-NroDoc + 1.
    END.
    CREATE VtaCDocu.
    ASSIGN
        VtaCDocu.CodCia = s-codcia
        VtaCDocu.CodDiv = s-coddiv
        VtaCDocu.CodPed = s-coddoc
        VtaCDocu.NroPed = STRING(x-NroDoc, '999999999')
        VtaCDocu.CodCli = Ccbccaja.codcli
        VtaCDocu.NomCli = Ccbccaja.nomcli
        VtaCDocu.FchPed = TODAY
        VtaCDocu.CodMon = 1
        VtaCDocu.TpoCmb = Ccbccaja.tpocmb
        VtaCDocu.FlgEst = "P"
        VtaCDocu.Glosa = ""
        VtaCDocu.ImpTot = 0
        VtaCDocu.CodOri = Ccbccaja.coddoc
        VtaCDocu.NroOri = Ccbccaja.nrodoc
        VtaCDocu.Cmpbnte = Ccbccaja.tipo
        VtaCDocu.Usuario = s-user-id.
    FOR EACH T-DMVTO:
        /* actualizamos saldos de percepciones */
        CREATE VtaDDocu.
        BUFFER-COPY VtaCDocu
            TO VtaDDocu
            ASSIGN
            VtaDDocu.Libre_c01 = T-DMvto.CodOpe     /* PRC o PRA */
            VtaDDocu.Libre_c02 = T-DMvto.NroAst
            VtaDDocu.Libre_c03 = T-DMvto.CodRef     /* FAC BOL TCK N/C */
            VtaDDocu.Libre_c04 = T-DMvto.NroRef
            VtaDDocu.ImpBrt = T-DMvto.ImpDoc
            VtaDDocu.PorIsc = T-DMvto.ImpInt
            VtaDDocu.ImpLin = T-Dmvto.ImpTot.
        /* Actualizamos saldo del PRC o PRA */
        FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
            AND Ccbcdocu.coddoc = VtaDDocu.Libre_c01
            AND Ccbcdocu.nrodoc = VtaDDocu.Libre_c02
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Ccbcdocu THEN UNDO, RETURN 'ADM-ERROR'.
        ASSIGN
            Ccbcdocu.sdoact = Ccbcdocu.sdoact - VtaDDocu.ImpLin.
        IF Ccbcdocu.sdoact <= 0 THEN Ccbcdocu.flgest = "C".
    END.
END.

RETURN "OK".

END PROCEDURE.

/* Rutina anterior */
/*
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    /* Correlativo Unico para toda la empresa */
    FOR FIRST Ccbcmvto NO-LOCK WHERE Ccbcmvto.codcia = s-codcia
        AND Ccbcmvto.coddoc = s-coddoc
        BY Ccbcmvto.nrodoc DESC:
        ASSIGN x-NroDoc = INTEGER(Ccbcmvto.nrodoc) NO-ERROR.
    END.
    x-NroDoc = x-NroDoc + 1.
    REPEAT:     /* Que no se repita */
        IF NOT CAN-FIND(FIRST CcbCMvto WHERE CcbCMvto.codcia = s-codcia
                        AND CcbCMvto.coddoc = s-coddoc
                        AND CcbCMvto.nrodoc = STRING(x-NroDoc, '999999999')
                        NO-LOCK)
            THEN LEAVE.
        ASSIGN
            x-NroDoc = x-NroDoc + 1.
    END.
    CREATE Ccbcmvto.
    ASSIGN
        CcbCMvto.CodCia = s-codcia
        CcbCMvto.CodDiv = s-coddiv
        CcbCMvto.CodDoc = s-coddoc
        CcbCMvto.NroDoc = STRING(x-NroDoc, '999999999')
        CcbCMvto.CodCli = Ccbccaja.codcli
        CcbCMvto.FchDoc = TODAY
        CcbCMvto.CodMon = 1
        CcbCMvto.TpoCmb = Ccbccaja.tpocmb
        CcbCMvto.FlgEst = "P"
        CcbCMvto.Glosa = ""
        CcbCMvto.ImpTot = 0
        CcbCMvto.Libre_chr[1] = Ccbccaja.coddoc
        CcbCMvto.Libre_chr[2] = Ccbccaja.nrodoc
        CcbCMvto.Libre_chr[3] = Ccbccaja.tipo
        CcbCMvto.Usuario = s-user-id.
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
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

