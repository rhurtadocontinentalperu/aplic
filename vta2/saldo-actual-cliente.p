/* NOTA: Programas afectados:
    vta2/linea-de-credito-01.p
    ccb/v-consul-cctv3.w
    
*/

/* Sintaxis:
    {vta2/saldo-actual-cliente 
    &pCodCli="<Var CodCli>"  
    &pSaldoDoc="<Var SaldoDoc>" 
    &pDeuda="<Var Deuda>"
    &fSdoAct="<Func fSdoAct()"
*/

/* Suma Todos los Documentos Pendientes */
FOR EACH CcbCDocu NO-LOCK WHERE CcbCDocu.CodCia = S-CODCIA 
    AND CcbCDocu.CodCli = {&pCodCli} 
    AND CcbCDocu.FlgEst = "P",
    FIRST FacDocum OF CcbCDocu NO-LOCK WHERE FacDocum.TpoDoc <> ?:
    /* ******************************************************* */
    /* DOCUMENTOS QUE NO DEBEN AFECTAR LA LINEA DE CREDITO     */
    /* ******************************************************* */
/*     IF LOOKUP(Ccbcdocu.coddoc, 'A/R,BD,A/C') > 0 THEN NEXT. */
    /* 1ro LETRAS ADELANTAS */
    IF Ccbcdocu.coddoc = 'LET' AND Ccbcdocu.codref = 'CLA' THEN NEXT.
    /* 2do. A/R por LETRAS ADELANTAS */
    IF Ccbcdocu.coddoc = 'A/R' AND Ccbcdocu.codref = 'CLA' THEN NEXT.
    /* 3ro. A/C POR FACTURAS ADELANTADAS */
    IF Ccbcdocu.coddoc = 'A/C' THEN NEXT.
    /* ******************************************************* */
    /* ******************************************************* */
    {&pSaldoDoc} = CcbCDocu.SdoAct.
    IF cMonLCred = 1 THEN DO:
        IF CcbCDocu.CodMon = 2 THEN {&pSaldoDoc} = {&pSaldoDoc} * FacCfgGn.Tpocmb[1].
    END.
    ELSE DO:
        IF CcbCDocu.CodMon = 1 THEN {&pSaldoDoc} = {&pSaldoDoc} / FacCfgGn.Tpocmb[1].
    END.
    IF FacDocum.TpoDoc
    THEN {&pDeuda} = {&pDeuda} + {&pSaldoDoc}.
    ELSE {&pDeuda} = {&pDeuda} - {&pSaldoDoc}.
END.
/* RHC INICIO DEL SPEED */
/* IF TODAY >= 08/01/2012 THEN DO:                                                              */
/*         DEFINE VARIABLE chAppCom AS COM-HANDLE.                                              */
/*     DEFINE VAR lValor        AS DECIMAL.    /* SALDO DEL CLIENTE = LINEA CRED - POR PAGAR */ */
/*     DEFINE VAR lCodCli       AS CHAR.                                                        */
/*                                                                                              */
/*     CREATE "sp_db2.Speed400db2" chAppCom.                                                    */
/*                                                                                              */
/*     lCodCli = SUBSTRING(gn-clie.codcli,1,10).                                                */
/*     IF gn-clie.codant <> '' AND LENGTH(gn-clie.codant) = 10                                  */
/*         THEN lCodCli = gn-clie.codant.                                                       */
/*                                                                                              */
/*     lValor = chAppCom:GetLineaCredito(1,lCodCli).                                            */
/*     /*MESSAGE lValor.*/                                                                      */
/*     ASSIGN                                                                                   */
/*         {&pDeuda} = 0      /* YA lo incluye en la línea de crédito */                           */
/*         dImpLCred = lValor * FacCfgGn.TpoCmb[1].    /* Como está en US$ lo pasamos a S/. */  */
/*                                                                                              */
/*     /* release com-handles */                                                                */
/*     RELEASE OBJECT chAppCom NO-ERROR.                                                        */
/* END.                                                                                         */
/* Suma Pedidos Credito Pendientes Generar Guias */
FOR EACH FacCPedi NO-LOCK WHERE FacCPedi.CodCia = S-CODCIA 
    AND FacCPedi.CodDoc = "PED" 
    AND FacCPedi.CodCli = {&pCodCli} 
    AND LOOKUP(FacCPedi.FlgEst, "G,X,P,W,WX,WL") > 0:
    FIND FIRST gn-convt WHERE gn-convt.codig = Faccpedi.FmaPgo NO-LOCK.
    IF gn-convt.tipvta = "1" THEN NEXT.     /* NO CONTADOS */
    {&pSaldoDoc} = {&fSdoAct}().
    IF cMonLCred = 1 THEN DO:
       IF FacCpedi.CodMon = 2 THEN {&pSaldoDoc} = {&pSaldoDoc} * FacCfgGn.Tpocmb[1].
    END.
    ELSE DO:
       IF FacCpedi.CodMon = 1 THEN {&pSaldoDoc} = {&pSaldoDoc} / FacCfgGn.Tpocmb[1].
    END.
    {&pDeuda} = {&pDeuda} + {&pSaldoDoc}.
END.
/* Suma Ordenes Despacho Pendientes Generar Guias */
FOR EACH FacCPedi NO-LOCK WHERE
    FacCPedi.CodCia = S-CODCIA AND
    FacCPedi.CodDoc = "O/D" AND
    FacCPedi.CodCli = {&pCodCli} AND
    FacCPedi.FlgEst = "P":
    FIND FIRST gn-convt WHERE gn-convt.codig = Faccpedi.FmaPgo NO-LOCK.
    IF gn-convt.tipvta = "1" THEN NEXT.     /* NO CONTADOS */
    {&pSaldoDoc} = {&fSdoAct}.
    IF cMonLCred = 1 THEN DO:
       IF FacCpedi.CodMon = 2 THEN {&pSaldoDoc} = {&pSaldoDoc} * FacCfgGn.Tpocmb[1].
    END.
    ELSE DO:
       IF FacCpedi.CodMon = 1 THEN {&pSaldoDoc} = {&pSaldoDoc} / FacCfgGn.Tpocmb[1].
    END.
    {&pDeuda} = {&pDeuda} + {&pSaldoDoc}.
END.
