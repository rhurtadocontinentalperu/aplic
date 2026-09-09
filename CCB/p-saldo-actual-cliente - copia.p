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
         HEIGHT             = 5.31
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* NOTA:
    Si pCodDiv = '00150' o '00070' 
    entonces SOLO se devuelve el saldo de esas divisiones
************************************************************************ */
DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pMonLCred AS INT.
DEF OUTPUT PARAMETER pDeuda AS DEC.

DEF SHARED VAR s-codcia AS INT.
DEF VAR pSaldoDoc AS DEC NO-UNDO.

FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= TODAY NO-LOCK.

DEF VAR pMaster AS CHAR.
DEF VAR pRelacionados AS CHAR.
DEF VAR pAgrupados AS LOG.

RUN ccb/p-cliente-master (pCodCli,
                          OUTPUT pMaster,
                          OUTPUT pRelacionados,
                          OUTPUT pAgrupados).
IF pAgrupados = YES AND pRelacionados > '' THEN .
ELSE pRelacionados = pCodCli.
/* *************************************************************************** */
/* ACUMULAMOS TODA LA DEUDA DEL CLIENTE Y DEL GRUPO TAMBIEN (SI FUERA EL CASO) */
/* *************************************************************************** */
pDeuda = 0.
DEF VAR iCuenta AS INT.
DEF VAR cFmaPgo AS CHAR INIT "G,X,P,W,WX,WL" NO-UNDO.
DEF VAR k AS INT NO-UNDO.
DO iCuenta = 1 TO NUM-ENTRIES(pRelacionados):
    pCodCli = ENTRY(iCuenta, pRelacionados).
    FOR EACH CcbCDocu NO-LOCK USE-INDEX Llave06 WHERE CcbCDocu.CodCia = S-CODCIA 
        AND CcbCDocu.CodCli = pCodCli
        AND CcbCDocu.FlgEst = "P",
        FIRST FacDocum OF CcbCDocu NO-LOCK WHERE FacDocum.TpoDoc <> ?:
        /* ******************************************************* */
        /* DOCUMENTOS QUE NO DEBEN AFECTAR LA LINEA DE CREDITO     */
        /* ******************************************************* */
        IF LOOKUP(CcbCDocu.CodDoc, 'FAC,BOL,N/C,N/D,BD,A/C,LPA,A/R,LET,CHQ,DCO,FAI,NCI,PAG') = 0 THEN NEXT.

        pSaldoDoc = CcbCDocu.SdoAct.
        IF pMonLCred = 1 THEN DO:
            IF CcbCDocu.CodMon = 2 THEN pSaldoDoc = pSaldoDoc * gn-tcmb.Compra.
        END.
        ELSE DO:
            IF CcbCDocu.CodMon = 1 THEN pSaldoDoc = pSaldoDoc / gn-tcmb.Venta.
        END.
        IF FacDocum.TpoDoc = YES    /* Cargos */
        THEN pDeuda = pDeuda + pSaldoDoc.
        ELSE pDeuda = pDeuda - pSaldoDoc.
    END.
    /* Suma Pedidos Credito Pendientes Generar Guias */
    DO k = 1 TO NUM-ENTRIES(cFmaPgo):
        FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia,
            EACH FacCPedi NO-LOCK USE-INDEX Llave10 WHERE FacCPedi.CodCia = S-CODCIA 
            AND FacCPedi.coddiv = gn-divi.coddiv
            AND FacCPedi.CodDoc = "PED"
            AND FacCPedi.FlgEst = ENTRY(k,cFmaPgo)
            AND FacCPedi.CodCli = pCodCli:
            FIND FIRST gn-convt WHERE gn-convt.codig = Faccpedi.FmaPgo NO-LOCK.
            IF gn-convt.tipvta = "1" THEN NEXT.     /* NO CONTADOS */
            FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE FacDPedi.CanPed > FacDPedi.CanAte:
                pSaldoDoc = (FacDPedi.CanPed - FacDPedi.CanAte) * FacDPedi.ImpLin / FacDPedi.CanPed.
                IF pMonLCred = 1 THEN DO:
                    IF FacCPedi.CodMon = 2 THEN pSaldoDoc = pSaldoDoc * gn-tcmb.Compra.
                END.
                ELSE DO:
                    IF FacCPedi.CodMon = 1 THEN pSaldoDoc = pSaldoDoc / gn-tcmb.Venta.
                END.
                pDeuda = pDeuda + pSaldoDoc.
            END.             
        END.
    END.
    /* Suma Ordenes Despacho Pendientes Generar Guias */
    FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia,
        EACH FacCPedi NO-LOCK USE-INDEX Llave10 WHERE FacCPedi.CodCia = S-CODCIA 
        AND FacCPedi.coddiv = gn-divi.coddiv
        AND FacCPedi.CodDoc = "O/D" 
        AND FacCPedi.FlgEst = "P"
        AND FacCPedi.CodCli = pCodCli:
        FIND FIRST gn-convt WHERE gn-convt.codig = Faccpedi.FmaPgo NO-LOCK.
        IF gn-convt.tipvta = "1" THEN NEXT.     /* NO CONTADOS */
        FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE FacDPedi.CanPed > FacDPedi.CanAte:
            pSaldoDoc = (FacDPedi.CanPed - FacDPedi.CanAte) * FacDPedi.ImpLin / FacDPedi.CanPed.
            IF pMonLCred = 1 THEN DO:
                IF FacCPedi.CodMon = 2 THEN pSaldoDoc = pSaldoDoc * gn-tcmb.Compra.
            END.
            ELSE DO:
                IF FacCPedi.CodMon = 1 THEN pSaldoDoc = pSaldoDoc / gn-tcmb.Venta.
            END.
            pDeuda = pDeuda + pSaldoDoc.
        END.             
    END.
END.

/* RHC Copiado el 11/06/2018

pDeuda = 0.
FOR EACH CcbCDocu NO-LOCK USE-INDEX Llave06 WHERE CcbCDocu.CodCia = S-CODCIA 
    AND CcbCDocu.CodCli = pCodCli
    AND CcbCDocu.FlgEst = "P",
    FIRST FacDocum OF CcbCDocu NO-LOCK WHERE FacDocum.TpoDoc <> ?:
    /* ******************************************************* */
    /* DOCUMENTOS QUE NO DEBEN AFECTAR LA LINEA DE CREDITO     */
    /* ******************************************************* */
    IF LOOKUP(CcbCDocu.CodDoc, 'FAC,BOL,N/C,N/D,BD,A/C,A/R,LET,CHQ,DCO,FAI,NCI,PAG') = 0 THEN NEXT.
    /* *************************************************************** */
    /* RHC 07/12/17 Casos especiales: 00150 Atlas y 00070 Perú Compras */
    /* *************************************************************** */
    CASE TRUE:
        WHEN LOOKUP(pCodDiv, '00150,00070') > 0 THEN DO:
            /* Solicitando saldo de ATLAS o PERU COMPRAS */
            IF Ccbcdocu.DivOri <> pCodDiv THEN NEXT.
        END.
        WHEN pCodDiv > '' THEN DO:
            /* Solicitando saldo menos de ATLAS o PERU COMPRAS */
            IF LOOKUP(Ccbcdocu.DivOri, '00150,00070') > 0 THEN NEXT.
        END.
        OTHERWISE DO:
            /* Saldo de TODOS los comprobantes */
        END.
    END CASE.
    /* *************************************************************** */
    /* *************************************************************** */
    pSaldoDoc = CcbCDocu.SdoAct.
    IF pMonLCred = 1 THEN DO:
        IF CcbCDocu.CodMon = 2 THEN pSaldoDoc = pSaldoDoc * gn-tcmb.Compra.
    END.
    ELSE DO:
        IF CcbCDocu.CodMon = 1 THEN pSaldoDoc = pSaldoDoc / gn-tcmb.Venta.
    END.
    IF FacDocum.TpoDoc = YES    /* Cargos */
    THEN pDeuda = pDeuda + pSaldoDoc.
    ELSE pDeuda = pDeuda - pSaldoDoc.
END.
/* Suma Pedidos Credito Pendientes Generar Guias */
DEF VAR cFmaPgo AS CHAR INIT "G,X,P,W,WX,WL" NO-UNDO.
DEF VAR k AS INT NO-UNDO.

DO k = 1 TO NUM-ENTRIES(cFmaPgo):
    FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia,
        EACH FacCPedi NO-LOCK USE-INDEX Llave10 WHERE FacCPedi.CodCia = S-CODCIA 
        AND FacCPedi.coddiv = gn-divi.coddiv
        AND FacCPedi.CodDoc = "PED"
        AND FacCPedi.FlgEst = ENTRY(k,cFmaPgo)
        AND FacCPedi.CodCli = pCodCli:
        FIND FIRST gn-convt WHERE gn-convt.codig = Faccpedi.FmaPgo NO-LOCK.
        IF gn-convt.tipvta = "1" THEN NEXT.     /* NO CONTADOS */
        /* *************************************************************** */
        /* RHC 07/12/17 Casos especiales: 00150 Atlas y 00070 Perú Compras */
        /* *************************************************************** */
        CASE TRUE:
            WHEN LOOKUP(pCodDiv, '00150,00070') > 0 THEN DO:
                /* Solicitando saldo de ATLAS o PERU COMPRAS */
                IF Faccpedi.CodDiv <> pCodDiv THEN NEXT.
            END.
            WHEN pCodDiv > '' THEN DO:
                /* Solicitando saldo menos de ATLAS o PERU COMPRAS */
                IF LOOKUP(Faccpedi.CodDiv, '00150,00070') > 0 THEN NEXT.
            END.
            OTHERWISE DO:
                /* Saldo de TODOS los comprobantes */
            END.
        END CASE.
        /* *************************************************************** */
        /* *************************************************************** */
        FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE FacDPedi.CanPed > FacDPedi.CanAte:
            pSaldoDoc = (FacDPedi.CanPed - FacDPedi.CanAte) * FacDPedi.ImpLin / FacDPedi.CanPed.
            IF pMonLCred = 1 THEN DO:
                IF FacCPedi.CodMon = 2 THEN pSaldoDoc = pSaldoDoc * gn-tcmb.Compra.
            END.
            ELSE DO:
                IF FacCPedi.CodMon = 1 THEN pSaldoDoc = pSaldoDoc / gn-tcmb.Venta.
            END.
            pDeuda = pDeuda + pSaldoDoc.
        END.             
    END.
END.
/* Suma Ordenes Despacho Pendientes Generar Guias */
FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia,
    EACH FacCPedi NO-LOCK USE-INDEX Llave10 WHERE FacCPedi.CodCia = S-CODCIA 
    AND FacCPedi.coddiv = gn-divi.coddiv
    AND FacCPedi.CodDoc = "O/D" 
    AND FacCPedi.FlgEst = "P"
    AND FacCPedi.CodCli = pCodCli:
    FIND FIRST gn-convt WHERE gn-convt.codig = Faccpedi.FmaPgo NO-LOCK.
    IF gn-convt.tipvta = "1" THEN NEXT.     /* NO CONTADOS */
    /* *************************************************************** */
    /* RHC 07/12/17 Casos especiales: 00150 Atlas y 00070 Perú Compras */
    /* *************************************************************** */
    CASE TRUE:
        WHEN LOOKUP(pCodDiv, '00150,00070') > 0 THEN DO:
            /* Solicitando saldo de ATLAS o PERU COMPRAS */
            IF Faccpedi.CodDiv <> pCodDiv THEN NEXT.
        END.
        WHEN pCodDiv > '' THEN DO:
            /* Solicitando saldo menos de ATLAS o PERU COMPRAS */
            IF LOOKUP(Faccpedi.CodDiv, '00150,00070') > 0 THEN NEXT.
        END.
        OTHERWISE DO:
            /* Saldo de TODOS los comprobantes */
        END.
    END CASE.
    /* *************************************************************** */
    /* *************************************************************** */
    FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE FacDPedi.CanPed > FacDPedi.CanAte:
        pSaldoDoc = (FacDPedi.CanPed - FacDPedi.CanAte) * FacDPedi.ImpLin / FacDPedi.CanPed.
        IF pMonLCred = 1 THEN DO:
            IF FacCPedi.CodMon = 2 THEN pSaldoDoc = pSaldoDoc * gn-tcmb.Compra.
        END.
        ELSE DO:
            IF FacCPedi.CodMon = 1 THEN pSaldoDoc = pSaldoDoc / gn-tcmb.Venta.
        END.
        pDeuda = pDeuda + pSaldoDoc.
    END.             
END.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


