/* REGENERACION DE ESTADISTICA DE COMPRAS - ATE */
DISABLE TRIGGERS FOR LOAD OF EcpPvArti.

Def var s-codcia    as inte init 1.
Def var x-signo1    as inte init 1.
Def var x-fin       as inte init 0.
Def var f-factor    as deci init 0.
Def var x-NroFchI   as inte init 0.
Def var x-NroFchF   as inte init 0.
Def var x-CodFchI   as date format '99/99/9999' init TODAY.
Def var x-CodFchF   as date format '99/99/9999' init TODAY.
Def var i           as inte init 0.
Def var x-TpoCmbCmp as deci init 1.
Def var x-TpoCmbVta as deci init 1.
Def var x-Day       as inte format '99'   init 1.
Def var x-Month     as inte format '99'   init 1.
Def var x-Year      as inte format '9999' init 1.
Def var x-coe       as deci init 0.
Def var x-can       as deci init 0.
def var x-fmapgo    as char.
def var x-canal     as char.

Def BUFFER B-CDOCU FOR CcbCdocu.
 
x-CodFchI = TODAY - 3.
x-CodFchF = 11/01/9999.

x-CodFchI = x-CodFchI - DAY(x-CodFchI) + 1.

DO WHILE MONTH(x-CodFchF + 1) = MONTH(x-CodFchF):
    x-CodFchF = x-CodFchF + 1. 
END. 
 
x-CodFchF = x-CodFchF + 1.
  
x-codfchi = DATE(MONTH(TODAY - 1), 01, YEAR(TODAY - 1)).
x-codfchf = TODAY - 1.

/*X-CODFCHI = DATE(04,01,2005).
 * X-CODFCHF = DATE(04,30,2005).*/

x-NroFchI = INTEGER(STRING(YEAR(x-CodFchI),"9999") + STRING(MONTH(x-CodFchI),"99")).      
x-NroFchF = INTEGER(STRING(YEAR(x-CodFchF),"9999") + STRING(MONTH(x-CodFchF),"99")).                           

DISPLAY x-CodFchI x-CodFchF x-NroFchI x-NroFchF.
PAUSE 0.

/* RHC 18.08.04 AHORA SE VA A GENERAR PARA TODAS LAS DIVISIONES */
FOR EACH Gn-Divi USE-INDEX IDX01 NO-LOCK WHERE Gn-Divi.Codcia = S-CodCia:
    FOR EACH EcpPvArti WHERE EcpPvArti.Codcia = S-CODCIA
                       AND EcpPvArti.CodDiv = Gn-Divi.CodDiv
                       AND EcpPvArti.NroFch >= x-NroFchI
                       AND EcpPvArti.NroFch <= x-NroFchF
                       USE-INDEX llave02 :
        DELETE EcpPvArti.
    END.
    FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
            AND Almacen.coddiv = GN-DIVI.coddiv:
        FOR EACH Almdmov USE-INDEX ALMD04 NO-LOCK WHERE Almdmov.codcia = s-codcia
                AND Almdmov.codalm = Almacen.codalm
                AND Almdmov.fchdoc >= x-CodFchI
                AND Almdmov.fchdoc <= x-CodFchF
                AND Almdmov.tipmov = 'I'
                AND Almdmov.codmov = 02,        /* COMPRAS */
                FIRST Almmmatg OF Almdmov NO-LOCK,
                FIRST Almcmov OF Almdmov NO-LOCK:
            DISPLAY Almdmov.Codcia
                    Almdmov.Codalm
                    Almdmov.FchDoc 
                    Almdmov.tipmov
                    Almdmov.codmov
                    Almdmov.NroDoc
                    STRING(TIME,'HH:MM')
                    TODAY .
            PAUSE 0.
            ASSIGN
                x-Day   = DAY(Almdmov.FchDoc)
                x-Month = MONTH(Almdmov.FchDoc)
                x-Year  = YEAR(Almdmov.FchDoc).
            FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= Almdmov.FchDoc
                              USE-INDEX Cmb01
                              NO-LOCK NO-ERROR.
            IF NOT AVAIL Gn-Tcmb THEN 
                FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= Almdmov.FchDoc
                                   USE-INDEX Cmb01
                                   NO-LOCK NO-ERROR.
            IF AVAIL Gn-Tcmb 
            THEN ASSIGN
                    x-TpoCmbCmp = Gn-Tcmb.Compra
                    x-TpoCmbVta = Gn-Tcmb.Venta.
            F-FACTOR  = 1. 
            IF Almdmov.factor > 0 THEN f-Factor = Almdmov.factor.
              
            FIND FIRST EcpPvArti WHERE EcpPvArti.codcia = almdmov.codcia
                AND EcpPvArti.coddiv = almacen.coddiv
                AND EcpPvArti.codprov = almcmov.codpro
                AND EcpPvArti.codmat = almdmov.codmat
                AND EcpPvArti.nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99"))
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE EcpPvArti THEN DO:
                 CREATE EcpPvArti.
                 ASSIGN
                 EcpPvArti.Codcia = Almdmov.Codcia 
                 EcpPvArti.CodDiv = Almacen.Coddiv 
                 EcpPvArti.codprov = almcmov.codpro
                 EcpPvArti.codmat = almdmov.codmat
                 EcpPvArti.CodAno = x-Year 
                 EcpPvArti.CodMes = x-Month
                 EcpPvArti.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99")) .
            END.                    
            IF Almcmov.CodMon = 1 THEN 
                        ASSIGN
                        EcpPvArti.CmpxDiaMn[x-Day] = EcpPvArti.CmpxDiaMn[x-Day] + ( x-signo1 * Almdmov.ImpCto)
                        EcpPvArti.CmpxDiaMe[x-Day] = EcpPvArti.CmpxDiaMe[x-Day] + ( x-signo1 * Almdmov.ImpCto /  x-TpoCmbCmp)
                        EcpPvArti.CmpxMesMn = EcpPvArti.CmpxMesMn + x-signo1 * Almdmov.ImpCto
                        EcpPvArti.CmpxMesMe = EcpPvArti.CmpxMesMe + x-signo1 * Almdmov.ImpCto / x-TpoCmbCmp.
            IF Almcmov.CodMon = 2 THEN 
                        ASSIGN
                        EcpPvArti.CmpxDiaMe[x-Day] = EcpPvArti.CmpxDiaMe[x-Day] + ( x-signo1 * Almdmov.ImpCto)
                        EcpPvArti.CmpxDiaMn[x-Day] = EcpPvArti.CmpxDiaMn[x-Day] + ( x-signo1 * Almdmov.ImpCto * x-TpoCmbVta)
                        EcpPvArti.CmpxMesMn = EcpPvArti.CmpxMesMn + x-signo1 * Almdmov.ImpCto * x-TpoCmbVta
                        EcpPvArti.CmpxMesMe = EcpPvArti.CmpxMesMe + x-signo1 * Almdmov.ImpCto.
            ASSIGN            
              EcpPvArti.CanxDia[x-Day] = EcpPvArti.CanxDia[x-Day] + ( x-signo1 * Almdmov.CanDes * F-FACTOR )
              EcpPvArti.CanxMes = EcpPvArti.CanxMes + ( x-signo1 * Almdmov.CanDes * F-FACTOR ).
        END.
    END.
END.


