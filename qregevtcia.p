DISABLE TRIGGERS FOR LOAD OF EvtDivi.
DISABLE TRIGGERS FOR LOAD OF EvtArti.
DISABLE TRIGGERS FOR LOAD OF EvtClie.
DISABLE TRIGGERS FOR LOAD OF EvtFpgo.
DISABLE TRIGGERS FOR LOAD OF EvtClFpgo.
DISABLE TRIGGERS FOR LOAD OF EvtVend.
DISABLE TRIGGERS FOR LOAD OF EvtClArti.

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
 

/* DESCOMENTAR SI QUIERES CALCULAR POR UN RANGO DE FECHAS FIJO */ 
x-CodFchI = 01/01/2008.
x-codfchf = TODAY - 1.

x-NroFchI = INTEGER(STRING(YEAR(x-CodFchI),"9999") + STRING(MONTH(x-CodFchI),"99")).      
x-NroFchF = INTEGER(STRING(YEAR(x-CodFchF),"9999") + STRING(MONTH(x-CodFchF),"99")).                           

DISPLAY x-CodFchI x-CodFchF x-NroFchI x-NroFchF.
PAUSE 0.
/* RHC 18.08.04 AHORA SE VA A GENERAR PARA TODAS LAS DIVISIONES */
    
    FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CodCia use-index Idx01 no-lock :
   
        FOR EACH EvtDivi WHERE EvtDivi.Codcia = S-CODCIA
                           AND EvtDivi.CodDiv = Gn-Divi.CodDiv
                           AND EvtDivi.NroFch >= x-NroFchI
                           AND EvtDivi.NroFch <= x-NroFchF
                           USE-INDEX llave01 :
            DELETE EvtDivi.
        END.
  
        FOR EACH EvtArti WHERE EvtArti.Codcia = S-CODCIA
                           AND EvtArti.CodDiv = Gn-Divi.CodDiv
                           AND EvtArti.NroFch >= x-NroFchI
                           AND EvtArti.NroFch <= x-NroFchF
                           USE-INDEX llave02 :
            DELETE EvtArti.
        END.
     
        FOR EACH EvtClie WHERE EvtClie.Codcia = S-CODCIA
                           AND EvtClie.CodDiv = Gn-Divi.CodDiv
                           AND EvtClie.NroFch >= x-NroFchI
                           AND EvtClie.NroFch <= x-NroFchF
                           USE-INDEX llave02 :
            DELETE EvtClie.
        END.
     
        FOR EACH EvtFpgo WHERE EvtFpgo.Codcia = S-CODCIA
                           AND EvtFpgo.CodDiv = Gn-Divi.CodDiv
                           AND EvtFpgo.NroFch >= x-NroFchI
                           AND EvtFpgo.NroFch <= x-NroFchF
                           USE-INDEX llave02:
            DELETE EvtFpgo.
        END.
   
        FOR EACH EvtClFpgo WHERE EvtClFpgo.Codcia = S-CODCIA
                             AND EvtClFpgo.CodDiv = Gn-Divi.CodDiv
                             AND EvtClFpgo.NroFch >= x-NroFchI
                             AND EvtClFpgo.NroFch <= x-NroFchF
                             USE-INDEX llave02:
            DELETE EvtClFpgo.
        END.

        FOR EACH EvtVend WHERE EvtVend.Codcia = S-CODCIA
                           AND EvtVend.CodDiv = Gn-Divi.CodDiv
                           AND EvtVend.NroFch >= x-NroFchI
                           AND EvtVend.NroFch <= x-NroFchF
                           USE-INDEX llave02:
            DELETE EvtVend.
        END.
   

        FOR EACH EvtVen WHERE EvtVen.Codcia = S-CODCIA
                           AND EvtVen.CodDiv = Gn-Divi.CodDiv
                           AND EvtVen.NroFch >= x-NroFchI
                           AND EvtVen.NroFch <= x-NroFchF
                           USE-INDEX llave02:
            DELETE EvtVen.
        END.


        FOR EACH Evtcan WHERE Evtcan.Codcia = S-CODCIA
                           AND Evtcan.CodDiv = Gn-Divi.CodDiv
                           AND Evtcan.NroFch >= x-NroFchI
                           AND Evtcan.NroFch <= x-NroFchF
                           USE-INDEX llave02:
            DELETE Evtcan.
        END.

        FOR EACH EvtClArti WHERE EvtClArti.Codcia = S-CODCIA
                             AND EvtClArti.CodDiv = Gn-Divi.CodDiv
                             AND EvtClArti.NroFch >= x-NroFchI
                             AND EvtClArti.NroFch <= x-NroFchF
                             USE-INDEX llave04:
            DELETE EvtClArti.
        END.


        FOR EACH EvtProvF WHERE EvtProvF.Codcia = S-CODCIA
                            AND EvtProvF.CodDiv = Gn-Divi.CodDiv
                            AND EvtProvF.NroFch >= x-NroFchI
                            AND EvtProvF.NroFch <= x-NroFchF
                            USE-INDEX llave02 :
             DELETE EvtProvF.
        END.

        FOR EACH CcbCdocu WHERE CcbCdocu.CodCia = S-CODCIA 
                            AND CcbCdocu.CodDiv = Gn-Divi.CodDiv
                            AND CcbCdocu.FchDoc >= x-CodFchI
                            AND CcbCdocu.FchDoc <= x-CodFchF
                            USE-INDEX llave10
                            /*NO-LOCK*/
                            BREAK BY CcbCdocu.CodCia
                                  BY CcbCdocu.CodDiv
                                  BY CcbCdocu.FchDoc:
            /* ***************** FILTROS ********************************** */
            IF Lookup(CcbCDocu.CodDoc,"TCK,FAC,BOL,N/C,N/D") = 0 THEN NEXT.
            IF CcbCDocu.FlgEst = "A"  THEN NEXT.
            IF CcbCDocu.ImpCto = ? THEN DO:
                CcbCDocu.ImpCto = 0.
            END.
            /* *********************************************************** */
            x-signo1 = IF CcbCdocu.Coddoc = "N/C" THEN -1 ELSE 1.
            DISPLAY CcbCdocu.Codcia
                    CcbCdocu.Coddiv
                    CcbCdocu.FchDoc 
                    CcbCdocu.CodDoc
                    CcbCdocu.NroDoc
                    STRING(TIME,'HH:MM')
                    TODAY .
            PAUSE 0.
     
            ASSIGN
                x-Day   = DAY(CcbCdocu.FchDoc)
                x-Month = MONTH(CcbCdocu.FchDoc)
                x-Year  = YEAR(CcbCdocu.FchDoc).
                FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc
                                  USE-INDEX Cmb01
                                  NO-LOCK NO-ERROR.
                IF NOT AVAIL Gn-Tcmb THEN 
                    FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc
                                       USE-INDEX Cmb01
                                       NO-LOCK NO-ERROR.
                IF AVAIL Gn-Tcmb THEN 
                    ASSIGN
                    x-TpoCmbCmp = Gn-Tcmb.Compra
                    x-TpoCmbVta = Gn-Tcmb.Venta.
            
            FIND EvtDivi WHERE EvtDivi.Codcia = CcbCdocu.Codcia AND
                               EvtDivi.CodDiv = CcbCdocu.Coddiv AND
                               EvtDivi.NroFch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99")) NO-ERROR.
            IF NOT AVAILABLE EvtDivi THEN DO:
                CREATE EvtDivi.
                ASSIGN
                EvtDivi.Codcia = CcbCdocu.Codcia 
                EvtDivi.CodDiv = CcbCdocu.Coddiv 
                EvtDivi.CodAno = x-Year 
                EvtDivi.CodMes = x-Month
                EvtDivi.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99")).
            END.                    
            IF Ccbcdocu.CodMon = 1 THEN 
                        ASSIGN
                        EvtDivi.CtoxDiaMn[x-Day] = EvtDivi.CtoxDiaMn[x-Day] + ( x-signo1 * CcbCdocu.ImpCto)
                        EvtDivi.VtaxDiaMn[x-Day] = EvtDivi.VtaxDiaMn[x-Day] + ( x-signo1 * CcbCdocu.ImpTot)
                        EvtDivi.CtoxMesMn = EvtDivi.CtoxMesMn + x-signo1 * CcbCdocu.ImpCto
                        EvtDivi.VtaxMesMn = EvtDivi.VtaxMesMn + x-signo1 * CcbCdocu.ImpTot
                        EvtDivi.CtoxMesMe = EvtDivi.CtoxMesMe + x-signo1 * CcbCdocu.ImpCto / x-TpoCmbCmp
                        EvtDivi.VtaxMesMe = EvtDivi.VtaxMesMe + x-signo1 * CcbCdocu.ImpTot / x-TpoCmbCmp.
            IF Ccbcdocu.CodMon = 2 THEN 
                        ASSIGN
                        EvtDivi.CtoxDiaMe[x-Day] = EvtDivi.CtoxDiaMe[x-Day] + ( x-signo1 * CcbCdocu.ImpCto)
                        EvtDivi.VtaxDiaMe[x-Day] = EvtDivi.VtaxDiaMe[x-Day] + ( x-signo1 * CcbCdocu.ImpTot)
                        EvtDivi.CtoxMesMn = EvtDivi.CtoxMesMn + x-signo1 * CcbCdocu.ImpCto * x-TpoCmbVta
                        EvtDivi.VtaxMesMn = EvtDivi.VtaxMesMn + x-signo1 * CcbCdocu.ImpTot * x-TpoCmbVta
                        EvtDivi.CtoxMesMe = EvtDivi.CtoxMesMe + x-signo1 * CcbCdocu.ImpCto
                        EvtDivi.VtaxMesMe = EvtDivi.VtaxMesMe + x-signo1 * CcbCdocu.ImpTot.

            FIND EvtClie WHERE EvtClie.Codcia = CcbCdocu.Codcia AND
                               EvtClie.CodDiv = CcbCdocu.Coddiv AND
                               EvtClie.Codcli = CcbCdocu.Codcli AND
                               EvtClie.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99")) 
                               NO-ERROR.
            IF NOT AVAILABLE EvtClie THEN DO:
                CREATE EvtClie.
                ASSIGN
                EvtClie.Codcia = CcbCdocu.Codcia 
                EvtClie.CodDiv = CcbCdocu.Coddiv 
                EvtClie.CodAno = x-Year 
                EvtClie.CodMes = x-Month
                EvtClie.Codcli = CcbCdocu.Codcli
                EvtClie.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99"))  .
            END.                   
            IF Ccbcdocu.CodMon = 1 THEN 
                        ASSIGN
                        EvtClie.CtoxDiaMn[x-Day] = EvtClie.CtoxDiaMn[x-Day] + ( x-signo1 * CcbCdocu.ImpCto)
                        EvtClie.VtaxDiaMn[x-Day] = EvtClie.VtaxDiaMn[x-Day] + ( x-signo1 * CcbCdocu.ImpTot)
                        EvtClie.CtoxMesMn = EvtClie.CtoxMesMn + x-signo1 * CcbCdocu.ImpCto
                        EvtClie.VtaxMesMn = EvtClie.VtaxMesMn + x-signo1 * CcbCdocu.ImpTot
                        EvtClie.CtoxMesMe = EvtClie.CtoxMesMe + x-signo1 * CcbCdocu.ImpCto / x-TpoCmbCmp
                        EvtClie.VtaxMesMe = EvtClie.VtaxMesMe + x-signo1 * CcbCdocu.ImpTot / x-TpoCmbCmp.
            IF Ccbcdocu.CodMon = 2 THEN 
                        ASSIGN
                        EvtClie.CtoxDiaMe[x-Day] = EvtClie.CtoxDiaMe[x-Day] + ( x-signo1 * CcbCdocu.ImpCto)
                        EvtClie.VtaxDiaMe[x-Day] = EvtClie.VtaxDiaMe[x-Day] + ( x-signo1 * CcbCdocu.ImpTot)
                        EvtClie.CtoxMesMn = EvtClie.CtoxMesMn + x-signo1 * CcbCdocu.ImpCto * x-TpoCmbVta
                        EvtClie.VtaxMesMn = EvtClie.VtaxMesMn + x-signo1 * CcbCdocu.ImpTot * x-TpoCmbVta
                        EvtClie.CtoxMesMe = EvtClie.CtoxMesMe + x-signo1 * CcbCdocu.ImpCto
                        EvtClie.VtaxMesMe = EvtClie.VtaxMesMe + x-signo1 * CcbCdocu.ImpTot.

            

            X-FMAPGO = CcbCdocu.FmaPgo.
            IF CcbCdocu.Coddoc = "N/C" THEN DO:
               FIND B-CDOCU WHERE B-CDOCU.Codcia = CcbCdocu.Codcia AND
                                  B-CDOCU.Coddoc = CcbCdocu.Codref AND
                                  B-CDOCU.NroDoc = CcbCdocu.Nroref
                                  NO-LOCK NO-ERROR.
               IF AVAILABLE B-CDOCU THEN X-FMAPGO = B-CDOCU.FmaPgo.
            END.

            FIND EvtFpgo WHERE EvtFpgo.Codcia = CcbCdocu.Codcia AND
                               EvtFpgo.CodDiv = CcbCdocu.Coddiv AND
                               EvtFpgo.FmaPgo = X-FMAPGO        AND
                               EvtFpgo.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99"))                           
                               NO-ERROR.
            IF NOT AVAILABLE EvtFpgo THEN DO:
                CREATE EvtFpgo.
                ASSIGN
                EvtFpgo.Codcia = CcbCdocu.Codcia 
                EvtFpgo.CodDiv = CcbCdocu.Coddiv 
                EvtFpgo.CodAno = x-Year 
                EvtFpgo.CodMes = x-Month
                EvtFpgo.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99"))
                EvtFpgo.FmaPgo = X-FMAPGO.
            END.                    
            IF Ccbcdocu.CodMon = 1 THEN 
                        ASSIGN
                        EvtFpgo.CtoxDiaMn[x-Day] = EvtFpgo.CtoxDiaMn[x-Day] + ( x-signo1 * CcbCdocu.ImpCto)
                        EvtFpgo.VtaxDiaMn[x-Day] = EvtFpgo.VtaxDiaMn[x-Day] + ( x-signo1 * CcbCdocu.ImpTot)
                        EvtFpgo.CtoxMesMn = EvtFpgo.CtoxMesMn + x-signo1 * CcbCdocu.ImpCto
                        EvtFpgo.VtaxMesMn = EvtFpgo.VtaxMesMn + x-signo1 * CcbCdocu.ImpTot
                        EvtFpgo.CtoxMesMe = EvtFpgo.CtoxMesMe + x-signo1 * CcbCdocu.ImpCto / x-TpoCmbCmp
                        EvtFpgo.VtaxMesMe = EvtFpgo.VtaxMesMe + x-signo1 * CcbCdocu.ImpTot / x-TpoCmbCmp.
            IF Ccbcdocu.CodMon = 2 THEN 
                        ASSIGN
                        EvtFpgo.CtoxDiaMe[x-Day] = EvtFpgo.CtoxDiaMe[x-Day] + ( x-signo1 * CcbCdocu.ImpCto)
                        EvtFpgo.VtaxDiaMe[x-Day] = EvtFpgo.VtaxDiaMe[x-Day] + ( x-signo1 * CcbCdocu.ImpTot)
                        EvtFpgo.CtoxMesMn = EvtFpgo.CtoxMesMn + x-signo1 * CcbCdocu.ImpCto * x-TpoCmbVta
                        EvtFpgo.VtaxMesMn = EvtFpgo.VtaxMesMn + x-signo1 * CcbCdocu.ImpTot * x-TpoCmbVta
                        EvtFpgo.CtoxMesMe = EvtFpgo.CtoxMesMe + x-signo1 * CcbCdocu.ImpCto
                        EvtFpgo.VtaxMesMe = EvtFpgo.VtaxMesMe + x-signo1 * CcbCdocu.ImpTot.


            FIND EvtClFpgo WHERE EvtClFpgo.Codcia = CcbCdocu.Codcia AND
                               EvtClFpgo.CodDiv = CcbCdocu.Coddiv AND
                               EvtClFpgo.FmaPgo = X-FMAPGO AND
                               EvtClFpgo.Codcli = CcbCdocu.Codcli AND
                               EvtClFpgo.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99"))                           
                               NO-ERROR.
            IF NOT AVAILABLE EvtClFpgo THEN DO:
                CREATE EvtClFpgo.
                ASSIGN
                EvtClFpgo.Codcia = CcbCdocu.Codcia 
                EvtClFpgo.CodDiv = CcbCdocu.Coddiv 
                EvtClFpgo.CodAno = x-Year 
                EvtClFpgo.CodMes = x-Month
                EvtClFpgo.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99"))
                EvtClFpgo.Codcli = CcbCdocu.Codcli
                EvtClFpgo.FmaPgo = X-FMAPGO.
            END.                    
            IF Ccbcdocu.CodMon = 1 THEN 
                        ASSIGN
                        EvtClFpgo.CtoxDiaMn[x-Day] = EvtClFpgo.CtoxDiaMn[x-Day] + ( x-signo1 * CcbCdocu.ImpCto)
                        EvtClFpgo.VtaxDiaMn[x-Day] = EvtClFpgo.VtaxDiaMn[x-Day] + ( x-signo1 * CcbCdocu.ImpTot)
                        EvtClFpgo.CtoxMesMn = EvtClFpgo.CtoxMesMn + x-signo1 * CcbCdocu.ImpCto
                        EvtClFpgo.VtaxMesMn = EvtClFpgo.VtaxMesMn + x-signo1 * CcbCdocu.ImpTot
                        EvtClFpgo.CtoxMesMe = EvtClFpgo.CtoxMesMe + x-signo1 * CcbCdocu.ImpCto / x-TpoCmbCmp
                        EvtClFpgo.VtaxMesMe = EvtClFpgo.VtaxMesMe + x-signo1 * CcbCdocu.ImpTot / x-TpoCmbCmp.
            IF Ccbcdocu.CodMon = 2 THEN 
                        ASSIGN
                        EvtClFpgo.CtoxDiaMe[x-Day] = EvtClFpgo.CtoxDiaMe[x-Day] + ( x-signo1 * CcbCdocu.ImpCto)
                        EvtClFpgo.VtaxDiaMe[x-Day] = EvtClFpgo.VtaxDiaMe[x-Day] + ( x-signo1 * CcbCdocu.ImpTot)
                        EvtClFpgo.CtoxMesMn = EvtClFpgo.CtoxMesMn + x-signo1 * CcbCdocu.ImpCto * x-TpoCmbVta
                        EvtClFpgo.VtaxMesMn = EvtClFpgo.VtaxMesMn + x-signo1 * CcbCdocu.ImpTot * x-TpoCmbVta
                        EvtClFpgo.CtoxMesMe = EvtClFpgo.CtoxMesMe + x-signo1 * CcbCdocu.ImpCto
                        EvtClFpgo.VtaxMesMe = EvtClFpgo.VtaxMesMe + x-signo1 * CcbCdocu.ImpTot.


            FIND EvtVen WHERE EvtVen.Codcia = CcbCdocu.Codcia AND
                              EvtVen.CodDiv = CcbCdocu.Coddiv AND
                              EvtVen.CodVen = CcbCdocu.CodVen AND
                              EvtVen.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99")) 
                              NO-ERROR.
            IF NOT AVAILABLE EvtVen THEN DO:
               CREATE EvtVen.
               ASSIGN
               EvtVen.Codcia = CcbCdocu.Codcia 
               EvtVen.CodDiv = CcbCdocu.Coddiv 
               EvtVen.CodAno = x-Year 
               EvtVen.CodMes = x-Month
               EvtVen.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99")) 
               EvtVen.CodVen = CcbCdocu.CodVen.            
            END.                    
            IF Ccbcdocu.CodMon = 1 THEN 
                        ASSIGN
                        EvtVen.CtoxDiaMn[x-Day] = EvtVen.CtoxDiaMn[x-Day] + ( x-signo1 * CcbCdocu.ImpCto)
                        EvtVen.VtaxDiaMn[x-Day] = EvtVen.VtaxDiaMn[x-Day] + ( x-signo1 * CcbCdocu.ImpTot)
                        EvtVen.CtoxMesMn = EvtVen.CtoxMesMn + x-signo1 * CcbCdocu.ImpCto
                        EvtVen.VtaxMesMn = EvtVen.VtaxMesMn + x-signo1 * CcbCdocu.ImpTot
                        EvtVen.CtoxMesMe = EvtVen.CtoxMesMe + x-signo1 * CcbCdocu.ImpCto / x-TpoCmbCmp
                        EvtVen.VtaxMesMe = EvtVen.VtaxMesMe + x-signo1 * CcbCdocu.ImpTot / x-TpoCmbCmp.
            IF Ccbcdocu.CodMon = 2 THEN 
                        ASSIGN
                        EvtVen.CtoxDiaMe[x-Day] = EvtVen.CtoxDiaMe[x-Day] + ( x-signo1 * CcbCdocu.ImpCto)
                        EvtVen.VtaxDiaMe[x-Day] = EvtVen.VtaxDiaMe[x-Day] + ( x-signo1 * CcbCdocu.ImpTot)
                        EvtVen.CtoxMesMn = EvtVen.CtoxMesMn + x-signo1 * CcbCdocu.ImpCto * x-TpoCmbVta
                        EvtVen.VtaxMesMn = EvtVen.VtaxMesMn + x-signo1 * CcbCdocu.ImpTot * x-TpoCmbVta
                        EvtVen.CtoxMesMe = EvtVen.CtoxMesMe + x-signo1 * CcbCdocu.ImpCto
                        EvtVen.VtaxMesMe = EvtVen.VtaxMesMe + x-signo1 * CcbCdocu.ImpTot.



            FIND Gn-Ven WHERE Gn-Ven.Codcia = S-CODCIA AND
                              Gn-Ven.COdven = Ccbcdocu.CodVen
                              NO-LOCK NO-ERROR.
            x-canal = "". 
            IF AVAILABLE Gn-Ven THEN x-canal = Gn-Ven.Ptovta.

            FIND Evtcan WHERE Evtcan.Codcia = CcbCdocu.Codcia AND
                              Evtcan.CodDiv = CcbCdocu.Coddiv AND
                              Evtcan.Canal  = x-canal         AND
                              Evtcan.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99")) 
                              NO-ERROR.
            IF NOT AVAILABLE Evtcan THEN DO:
               CREATE Evtcan.
               ASSIGN
               Evtcan.Codcia = CcbCdocu.Codcia 
               Evtcan.CodDiv = CcbCdocu.Coddiv 
               Evtcan.CodAno = x-Year 
               Evtcan.CodMes = x-Month
               Evtcan.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99")) 
               Evtcan.Canal  = x-canal.            
            END.                    
            IF Ccbcdocu.CodMon = 1 THEN 
                        ASSIGN
                        Evtcan.CtoxDiaMn[x-Day] = Evtcan.CtoxDiaMn[x-Day] + ( x-signo1 * CcbCdocu.ImpCto)
                        Evtcan.VtaxDiaMn[x-Day] = Evtcan.VtaxDiaMn[x-Day] + ( x-signo1 * CcbCdocu.ImpTot)
                        Evtcan.CtoxMesMn = Evtcan.CtoxMesMn + x-signo1 * CcbCdocu.ImpCto
                        Evtcan.VtaxMesMn = Evtcan.VtaxMesMn + x-signo1 * CcbCdocu.ImpTot
                        Evtcan.CtoxMesMe = Evtcan.CtoxMesMe + x-signo1 * CcbCdocu.ImpCto / x-TpoCmbCmp
                        Evtcan.VtaxMesMe = Evtcan.VtaxMesMe + x-signo1 * CcbCdocu.ImpTot / x-TpoCmbCmp.
            IF Ccbcdocu.CodMon = 2 THEN 
                        ASSIGN
                        Evtcan.CtoxDiaMe[x-Day] = Evtcan.CtoxDiaMe[x-Day] + ( x-signo1 * CcbCdocu.ImpCto)
                        Evtcan.VtaxDiaMe[x-Day] = Evtcan.VtaxDiaMe[x-Day] + ( x-signo1 * CcbCdocu.ImpTot)
                        Evtcan.CtoxMesMn = Evtcan.CtoxMesMn + x-signo1 * CcbCdocu.ImpCto * x-TpoCmbVta
                        Evtcan.VtaxMesMn = Evtcan.VtaxMesMn + x-signo1 * CcbCdocu.ImpTot * x-TpoCmbVta
                        Evtcan.CtoxMesMe = Evtcan.CtoxMesMe + x-signo1 * CcbCdocu.ImpCto
                        Evtcan.VtaxMesMe = Evtcan.VtaxMesMe + x-signo1 * CcbCdocu.ImpTot.


           IF CcbCdocu.Coddoc = "N/C" AND CcbCdocu.CndCre = "N" THEN RUN PROCESA-NOTA.

           FOR EACH CcbDdocu OF CcbCdocu NO-LOCK:
               
               FIND Almmmatg WHERE Almmmatg.Codcia = CcbDdocu.Codcia AND
                                   Almmmatg.CodMat = CcbDdocu.CodMat NO-LOCK NO-ERROR.
               IF NOT AVAILABLE Almmmatg THEN NEXT.
               FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                                   Almtconv.Codalter = Ccbddocu.UndVta
                                   NO-LOCK NO-ERROR.
               F-FACTOR  = 1. 
               IF AVAILABLE Almtconv THEN DO:
                  F-FACTOR = Almtconv.Equival.
                  IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
               END.
               
               FIND EvtArti WHERE EvtArti.Codcia = CcbCdocu.Codcia AND
                                  EvtArti.CodDiv = CcbCdocu.Coddiv AND
                                  EvtArti.CodMat = CcbDdocu.CodMat AND
                                  EvtArti.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99"))
                                  NO-ERROR.     
               IF NOT AVAILABLE EvtArti THEN DO:
                    CREATE EvtArti.
                    ASSIGN
                    EvtArti.Codcia = CcbCdocu.Codcia 
                    EvtArti.CodDiv = CcbCdocu.Coddiv 
                    EvtArti.CodAno = x-Year 
                    EvtArti.CodMes = x-Month
                    EvtArti.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99")) 
                    EvtArti.CodMat = CcbDdocu.CodMat.            
               END.                    
               IF Ccbcdocu.CodMon = 1 THEN 
                           ASSIGN
                           EvtArti.CtoxDiaMn[x-Day] = EvtArti.CtoxDiaMn[x-Day] + ( x-signo1 * CcbDdocu.ImpCto)
                           EvtArti.VtaxDiaMn[x-Day] = EvtArti.VtaxDiaMn[x-Day] + ( x-signo1 * CcbDdocu.ImpLin)
                           EvtArti.CtoxMesMn = EvtArti.CtoxMesMn + x-signo1 * CcbDdocu.ImpCto
                           EvtArti.VtaxMesMn = EvtArti.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin
                           EvtArti.CtoxMesMe = EvtArti.CtoxMesMe + x-signo1 * CcbDdocu.ImpCto / x-TpoCmbCmp
                           EvtArti.VtaxMesMe = EvtArti.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin / x-TpoCmbCmp.
               IF Ccbcdocu.CodMon = 2 THEN 
                           ASSIGN
                           EvtArti.CtoxDiaMe[x-Day] = EvtArti.CtoxDiaMe[x-Day] + ( x-signo1 * CcbDdocu.ImpCto)
                           EvtArti.VtaxDiaMe[x-Day] = EvtArti.VtaxDiaMe[x-Day] + ( x-signo1 * CcbDdocu.ImpLin)
                           EvtArti.CtoxMesMn = EvtArti.CtoxMesMn + x-signo1 * CcbDdocu.ImpCto * x-TpoCmbVta
                           EvtArti.VtaxMesMn = EvtArti.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta
                           EvtArti.CtoxMesMe = EvtArti.CtoxMesMe + x-signo1 * CcbDdocu.ImpCto
                           EvtArti.VtaxMesMe = EvtArti.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin.
               ASSIGN            
               EvtArti.CanxDia[x-Day] = EvtArti.CanxDia[x-Day] + ( x-signo1 * CcbDdocu.CanDes * F-FACTOR )
               EvtArti.CanxMes = EvtArti.CanxMes + ( x-signo1 * CcbDdocu.CanDes * F-FACTOR ).

               FIND EvtVend WHERE EvtVend.Codcia = CcbCdocu.Codcia AND
                                  EvtVend.CodDiv = CcbCdocu.Coddiv AND
                                  EvtVend.CodVen = CcbCdocu.CodVen AND
                                  EvtVend.CodMat = CcbDdocu.CodMat AND 
                                  EvtVend.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99")) 
                                  NO-ERROR.
               IF NOT AVAILABLE EvtVend THEN DO:
                  CREATE EvtVend.
                  ASSIGN
                  EvtVend.Codcia = CcbCdocu.Codcia 
                  EvtVend.CodDiv = CcbCdocu.Coddiv 
                  EvtVend.CodAno = x-Year 
                  EvtVend.CodMes = x-Month
                  EvtVend.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99")) 
                  EvtVend.CodVen = CcbCdocu.CodVen             
                  EvtVend.CodMat = CcbDdocu.CodMat.            
               END.                    
               IF Ccbcdocu.CodMon = 1 THEN 
                           ASSIGN
                           EvtVend.CtoxDiaMn[x-Day] = EvtVend.CtoxDiaMn[x-Day] + ( x-signo1 * CcbDdocu.ImpCto)
                           EvtVend.VtaxDiaMn[x-Day] = EvtVend.VtaxDiaMn[x-Day] + ( x-signo1 * CcbDdocu.ImpLin)
                           EvtVend.CtoxMesMn = EvtVend.CtoxMesMn + x-signo1 * CcbDdocu.ImpCto
                           EvtVend.VtaxMesMn = EvtVend.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin
                           EvtVend.CtoxMesMe = EvtVend.CtoxMesMe + x-signo1 * CcbDdocu.ImpCto / x-TpoCmbCmp
                           EvtVend.VtaxMesMe = EvtVend.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin / x-TpoCmbCmp.
               IF Ccbcdocu.CodMon = 2 THEN 
                           ASSIGN
                           EvtVend.CtoxDiaMe[x-Day] = EvtVend.CtoxDiaMe[x-Day] + ( x-signo1 * CcbDdocu.ImpCto)
                           EvtVend.VtaxDiaMe[x-Day] = EvtVend.VtaxDiaMe[x-Day] + ( x-signo1 * CcbDdocu.ImpLin)
                           EvtVend.CtoxMesMn = EvtVend.CtoxMesMn + x-signo1 * CcbDdocu.ImpCto * x-TpoCmbVta
                           EvtVend.VtaxMesMn = EvtVend.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta
                           EvtVend.CtoxMesMe = EvtVend.CtoxMesMe + x-signo1 * CcbDdocu.ImpCto
                           EvtVend.VtaxMesMe = EvtVend.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin.
               ASSIGN            
               EvtVend.CanxDia[x-Day] = EvtVend.CanxDia[x-Day] + ( x-signo1 * CcbDdocu.CanDes * F-FACTOR)
               EvtVend.CanxMes = EvtVend.CanxMes + ( x-signo1 * CcbDdocu.CanDes * F-FACTOR).

               FIND EvtClArti WHERE EvtClArti.Codcia = CcbCDocu.Codcia AND
                                    EvtClArti.CodDiv = CcbCDocu.Coddiv AND
                                    EvtClArti.CodCli = CcbCDocu.CodCli AND
                                    EvtClArti.CodMat = CcbDDocu.CodMat AND 
                                    EvtClArti.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99"))

                                    USE-INDEX Llave01
                                    NO-ERROR.
               IF NOT AVAILABLE EvtClArti THEN DO:
                  CREATE EvtClArti.
                  ASSIGN
                  EvtClArti.Codcia = CcbCdocu.Codcia 
                  EvtClArti.CodDiv = CcbCdocu.Coddiv 
                  EvtClArti.CodAno = x-Year 
                  EvtClArti.CodMes = x-Month
                  EvtClArti.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99"))
                  EvtClArti.CodCli = CcbCdocu.CodCli             
                  EvtClArti.CodMat = CcbDdocu.CodMat.            
               END.
               IF Ccbcdocu.CodMon = 1 THEN 
                           ASSIGN
                           EvtClArti.CtoxDiaMn[x-Day] = EvtClArti.CtoxDiaMn[x-Day] + ( x-signo1 * CcbDdocu.ImpCto)
                           EvtClArti.VtaxDiaMn[x-Day] = EvtClArti.VtaxDiaMn[x-Day] + ( x-signo1 * CcbDdocu.ImpLin)
                           EvtClArti.CtoxMesMn = EvtClArti.CtoxMesMn + x-signo1 * CcbDdocu.ImpCto
                           EvtClArti.VtaxMesMn = EvtClArti.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin
                           EvtClArti.CtoxMesMe = EvtClArti.CtoxMesMe + x-signo1 * CcbDdocu.ImpCto / x-TpoCmbCmp
                           EvtClArti.VtaxMesMe = EvtClArti.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin / x-TpoCmbCmp.
               IF Ccbcdocu.CodMon = 2 THEN 
                           ASSIGN
                           EvtClArti.CtoxDiaMe[x-Day] = EvtClArti.CtoxDiaMe[x-Day] + ( x-signo1 * CcbDdocu.ImpCto)
                           EvtClArti.VtaxDiaMe[x-Day] = EvtClArti.VtaxDiaMe[x-Day] + ( x-signo1 * CcbDdocu.ImpLin)
                           EvtClArti.CtoxMesMn = EvtClArti.CtoxMesMn + x-signo1 * CcbDdocu.ImpCto * x-TpoCmbVta
                           EvtClArti.VtaxMesMn = EvtClArti.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta
                           EvtClArti.CtoxMesMe = EvtClArti.CtoxMesMe + x-signo1 * CcbDdocu.ImpCto
                           EvtClArti.VtaxMesMe = EvtClArti.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin.
               ASSIGN            
               EvtClArti.CanxDia[x-Day] = EvtClArti.CanxDia[x-Day] + ( x-signo1 * CcbdDocu.CanDes * F-FACTOR)
               EvtClArti.CanxMes = EvtClArti.CanxMes + ( x-signo1 * CcbdDocu.CanDes * F-FACTOR).
             
               FIND EvtProvF WHERE EvtProvF.Codcia = CcbCdocu.Codcia AND
                                   EvtProvF.CodDiv = CcbCdocu.Coddiv AND
                                   EvtProvF.CodProv = Almmmatg.CodPr1 AND
                                   EvtProvF.FmaPgo = X-FMAPGO AND
                                   EvtProvF.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99"))
                                   NO-ERROR.     
               IF NOT AVAILABLE EvtProvF THEN DO:
                    CREATE EvtProvF.
                    ASSIGN
                    EvtProvF.Codcia = CcbCdocu.Codcia 
                    EvtProvF.CodDiv = CcbCdocu.Coddiv 
                    EvtProvF.CodAno = x-Year 
                    EvtProvF.CodMes = x-Month
                    EvtProvF.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99")) 
                    EvtProvF.FmaPgo = X-FMAPGO 
                    EvtProvF.CodProv = Almmmatg.CodPr1.
               END.                    
               IF Ccbcdocu.CodMon = 1 THEN 
                           ASSIGN
                           EvtProvF.CtoxDiaMn[x-Day] = EvtProvF.CtoxDiaMn[x-Day] + ( x-signo1 * CcbDdocu.ImpCto)
                           EvtProvF.VtaxDiaMn[x-Day] = EvtProvF.VtaxDiaMn[x-Day] + ( x-signo1 * CcbDdocu.ImpLin)
                           EvtProvF.CtoxMesMn = EvtProvF.CtoxMesMn + x-signo1 * CcbDdocu.ImpCto
                           EvtProvF.VtaxMesMn = EvtProvF.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin
                           EvtProvF.CtoxMesMe = EvtProvF.CtoxMesMe + x-signo1 * CcbDdocu.ImpCto / x-TpoCmbCmp
                           EvtProvF.VtaxMesMe = EvtProvF.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin / x-TpoCmbCmp.
               IF Ccbcdocu.CodMon = 2 THEN 
                           ASSIGN
                           EvtProvF.CtoxDiaMe[x-Day] = EvtProvF.CtoxDiaMe[x-Day] + ( x-signo1 * CcbDdocu.ImpCto)
                           EvtProvF.VtaxDiaMe[x-Day] = EvtProvF.VtaxDiaMe[x-Day] + ( x-signo1 * CcbDdocu.ImpLin)
                           EvtProvF.CtoxMesMn = EvtProvF.CtoxMesMn + x-signo1 * CcbDdocu.ImpCto * x-TpoCmbVta
                           EvtProvF.VtaxMesMn = EvtProvF.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta
                           EvtProvF.CtoxMesMe = EvtProvF.CtoxMesMe + x-signo1 * CcbDdocu.ImpCto
                           EvtProvF.VtaxMesMe = EvtProvF.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin.

           END.  
        END.
    END.
  
  
  


PROCEDURE PROCESA-NOTA.

FOR EACH CcbDdocu OF CcbCdocu:
    x-can = IF CcbDdocu.CodMat = "00005" THEN 1 ELSE 0.
END.
FIND B-CDOCU WHERE B-CDOCU.Codcia = CcbCdocu.Codcia AND
                   B-CDOCU.CodDoc = CcbCdocu.Codref AND
                   B-CDOCU.NroDoc = CcbCdocu.Nroref 
                   NO-LOCK NO-ERROR.
IF AVAILABLE B-CDOCU THEN DO:
           x-coe = CcbCdocu.ImpTot / B-CDOCU.ImpTot.
           FOR EACH CcbDdocu OF B-CDOCU NO-LOCK:
               
               FIND Almmmatg WHERE Almmmatg.Codcia = CcbDdocu.Codcia AND
                                   Almmmatg.CodMat = CcbDdocu.CodMat NO-LOCK NO-ERROR.
               IF NOT AVAILABLE Almmmatg THEN NEXT.
               FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                                   Almtconv.Codalter = Ccbddocu.UndVta
                                   NO-LOCK NO-ERROR.
               F-FACTOR  = 1. 
               IF AVAILABLE Almtconv THEN DO:
                  F-FACTOR = Almtconv.Equival.
                  IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
               END.
               
               FIND EvtArti WHERE EvtArti.Codcia = CcbCdocu.Codcia AND
                                  EvtArti.CodDiv = CcbCdocu.Coddiv AND
                                  EvtArti.CodMat = CcbDdocu.CodMat AND
                                  EvtArti.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99"))
                                  NO-ERROR.     
               IF NOT AVAILABLE EvtArti THEN DO:
                    CREATE EvtArti.
                    ASSIGN
                    EvtArti.Codcia = CcbCdocu.Codcia 
                    EvtArti.CodDiv = CcbCdocu.Coddiv 
                    EvtArti.CodAno = x-Year 
                    EvtArti.CodMes = x-Month
                    EvtArti.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99")) 
                    EvtArti.CodMat = CcbDdocu.CodMat.            
               END.                    
               IF Ccbcdocu.CodMon = 1 THEN 
                           ASSIGN
                           EvtArti.CtoxDiaMn[x-Day] = EvtArti.CtoxDiaMn[x-Day] + ( x-signo1 * CcbDdocu.ImpCto * x-coe)
                           EvtArti.VtaxDiaMn[x-Day] = EvtArti.VtaxDiaMn[x-Day] + ( x-signo1 * CcbDdocu.ImpLin * x-coe)
                           EvtArti.CtoxMesMn = EvtArti.CtoxMesMn + x-signo1 * CcbDdocu.ImpCto * x-coe
                           EvtArti.VtaxMesMn = EvtArti.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin * x-coe
                           EvtArti.CtoxMesMe = EvtArti.CtoxMesMe + x-signo1 * CcbDdocu.ImpCto * x-coe / x-TpoCmbCmp
                           EvtArti.VtaxMesMe = EvtArti.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin * x-coe / x-TpoCmbCmp.
               IF Ccbcdocu.CodMon = 2 THEN 
                           ASSIGN
                           EvtArti.CtoxDiaMe[x-Day] = EvtArti.CtoxDiaMe[x-Day] + ( x-signo1 * CcbDdocu.ImpCto * x-coe)
                           EvtArti.VtaxDiaMe[x-Day] = EvtArti.VtaxDiaMe[x-Day] + ( x-signo1 * CcbDdocu.ImpLin * x-coe)
                           EvtArti.CtoxMesMn = EvtArti.CtoxMesMn + x-signo1 * CcbDdocu.ImpCto * x-TpoCmbVta * x-coe
                           EvtArti.VtaxMesMn = EvtArti.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta * x-coe
                           EvtArti.CtoxMesMe = EvtArti.CtoxMesMe + x-signo1 * CcbDdocu.ImpCto * x-coe
                           EvtArti.VtaxMesMe = EvtArti.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin * x-coe.
               ASSIGN            
               EvtArti.CanxDia[x-Day] = EvtArti.CanxDia[x-Day] + ( x-signo1 * CcbDdocu.CanDes * F-FACTOR * x-can )
               EvtArti.CanxMes = EvtArti.CanxMes + ( x-signo1 * CcbDdocu.CanDes * F-FACTOR * x-can).

               FIND EvtVend WHERE EvtVend.Codcia = CcbCdocu.Codcia AND
                                  EvtVend.CodDiv = CcbCdocu.Coddiv AND
                                  EvtVend.CodVen = CcbCdocu.CodVen AND
                                  EvtVend.CodMat = CcbDdocu.CodMat AND 
                                  EvtVend.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99")) 
                                  NO-ERROR.
               IF NOT AVAILABLE EvtVend THEN DO:
                  CREATE EvtVend.
                  ASSIGN
                  EvtVend.Codcia = CcbCdocu.Codcia 
                  EvtVend.CodDiv = CcbCdocu.Coddiv 
                  EvtVend.CodAno = x-Year 
                  EvtVend.CodMes = x-Month
                  EvtVend.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99")) 
                  EvtVend.CodVen = CcbCdocu.CodVen             
                  EvtVend.CodMat = CcbDdocu.CodMat.            
               END.                    
               IF Ccbcdocu.CodMon = 1 THEN 
                           ASSIGN
                           EvtVend.CtoxDiaMn[x-Day] = EvtVend.CtoxDiaMn[x-Day] + ( x-signo1 * CcbDdocu.ImpCto * x-coe)
                           EvtVend.VtaxDiaMn[x-Day] = EvtVend.VtaxDiaMn[x-Day] + ( x-signo1 * CcbDdocu.ImpLin * x-coe)
                           EvtVend.CtoxMesMn = EvtVend.CtoxMesMn + x-signo1 * CcbDdocu.ImpCto * x-coe 
                           EvtVend.VtaxMesMn = EvtVend.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin * x-coe
                           EvtVend.CtoxMesMe = EvtVend.CtoxMesMe + x-signo1 * CcbDdocu.ImpCto * x-coe / x-TpoCmbCmp
                           EvtVend.VtaxMesMe = EvtVend.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin * x-coe / x-TpoCmbCmp.
               IF Ccbcdocu.CodMon = 2 THEN 
                           ASSIGN
                           EvtVend.CtoxDiaMe[x-Day] = EvtVend.CtoxDiaMe[x-Day] + ( x-signo1 * CcbDdocu.ImpCto * x-coe)
                           EvtVend.VtaxDiaMe[x-Day] = EvtVend.VtaxDiaMe[x-Day] + ( x-signo1 * CcbDdocu.ImpLin * x-coe)
                           EvtVend.CtoxMesMn = EvtVend.CtoxMesMn + x-signo1 * CcbDdocu.ImpCto * x-TpoCmbVta * x-coe
                           EvtVend.VtaxMesMn = EvtVend.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta * x-coe
                           EvtVend.CtoxMesMe = EvtVend.CtoxMesMe + x-signo1 * CcbDdocu.ImpCto * x-coe
                           EvtVend.VtaxMesMe = EvtVend.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin * x-coe .
               ASSIGN            
               EvtVend.CanxDia[x-Day] = EvtVend.CanxDia[x-Day] + ( x-signo1 * CcbDdocu.CanDes * F-FACTOR * x-can)
               EvtVend.CanxMes = EvtVend.CanxMes + ( x-signo1 * CcbDdocu.CanDes * F-FACTOR * x-can).

               FIND EvtClArti WHERE EvtClArti.Codcia = CcbCDocu.Codcia AND
                                    EvtClArti.CodDiv = CcbCDocu.Coddiv AND
                                    EvtClArti.CodCli = CcbCDocu.CodCli AND
                                    EvtClArti.CodMat = CcbDDocu.CodMat AND 
                                    EvtClArti.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99"))

                                    USE-INDEX Llave01
                                    NO-ERROR.
               IF NOT AVAILABLE EvtClArti THEN DO:
                  CREATE EvtClArti.
                  ASSIGN
                  EvtClArti.Codcia = CcbCdocu.Codcia 
                  EvtClArti.CodDiv = CcbCdocu.Coddiv 
                  EvtClArti.CodAno = x-Year 
                  EvtClArti.CodMes = x-Month
                  EvtClArti.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99"))
                  EvtClArti.CodCli = CcbCdocu.CodCli             
                  EvtClArti.CodMat = CcbDdocu.CodMat.            
               END. 
               IF Ccbcdocu.CodMon = 1 THEN 
                  ASSIGN
                  EvtClArti.CtoxDiaMn[x-Day] = EvtClArti.CtoxDiaMn[x-Day] + ( x-signo1 * CcbDdocu.ImpCto * x-coe)
                  EvtClArti.VtaxDiaMn[x-Day] = EvtClArti.VtaxDiaMn[x-Day] + ( x-signo1 * CcbDdocu.ImpLin * x-coe)
                  EvtClArti.CtoxMesMn = EvtClArti.CtoxMesMn + x-signo1 * CcbDdocu.ImpCto * x-coe
                  EvtClArti.VtaxMesMn = EvtClArti.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin * x-coe
                  EvtClArti.CtoxMesMe = EvtClArti.CtoxMesMe + x-signo1 * CcbDdocu.ImpCto * x-coe / x-TpoCmbCmp
                  EvtClArti.VtaxMesMe = EvtClArti.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin * x-coe / x-TpoCmbCmp.
               IF Ccbcdocu.CodMon = 2 THEN 
                  ASSIGN
                  EvtClArti.CtoxDiaMe[x-Day] = EvtClArti.CtoxDiaMe[x-Day] + ( x-signo1 * CcbDdocu.ImpCto * x-coe)
                  EvtClArti.VtaxDiaMe[x-Day] = EvtClArti.VtaxDiaMe[x-Day] + ( x-signo1 * CcbDdocu.ImpLin * x-coe )
                  EvtClArti.CtoxMesMn = EvtClArti.CtoxMesMn + x-signo1 * CcbDdocu.ImpCto * x-TpoCmbVta * x-coe
                  EvtClArti.VtaxMesMn = EvtClArti.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta * x-coe
                  EvtClArti.CtoxMesMe = EvtClArti.CtoxMesMe + x-signo1 * CcbDdocu.ImpCto * x-coe
                  EvtClArti.VtaxMesMe = EvtClArti.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin * x-coe.
               ASSIGN            
               EvtClArti.CanxDia[x-Day] = EvtClArti.CanxDia[x-Day] + ( x-signo1 * CcbdDocu.CanDes * F-FACTOR * x-can)
               EvtClArti.CanxMes = EvtClArti.CanxMes + ( x-signo1 * CcbdDocu.CanDes * F-FACTOR * x-can).


               FIND EvtProvF WHERE EvtProvF.Codcia = CcbCdocu.Codcia AND
                                   EvtProvF.CodDiv = CcbCdocu.Coddiv AND
                                   EvtProvF.CodProv = Almmmatg.CodPr1 AND
                                   EvtProvF.FmaPgo = X-FMAPGO AND
                                   EvtProvF.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99"))
                                   NO-ERROR.     
               IF NOT AVAILABLE EvtProvF THEN DO:
                    CREATE EvtProvF.
                    ASSIGN
                    EvtProvF.Codcia = CcbCdocu.Codcia 
                    EvtProvF.CodDiv = CcbCdocu.Coddiv 
                    EvtProvF.CodAno = x-Year 
                    EvtProvF.CodMes = x-Month
                    EvtProvF.Nrofch = INTEGER(STRING(x-Year,"9999") + STRING(x-Month,"99")) 
                    EvtProvF.FmaPgo = X-FMAPGO 
                    EvtProvF.CodProv = Almmmatg.CodPr1.
               END.                    
               IF Ccbcdocu.CodMon = 1 THEN 
                           ASSIGN
                           EvtProvF.CtoxDiaMn[x-Day] = EvtProvF.CtoxDiaMn[x-Day] + ( x-signo1 * CcbDdocu.ImpCto * x-coe)
                           EvtProvF.VtaxDiaMn[x-Day] = EvtProvF.VtaxDiaMn[x-Day] + ( x-signo1 * CcbDdocu.ImpLin * x-coe)
                           EvtProvF.CtoxMesMn = EvtProvF.CtoxMesMn + x-signo1 * CcbDdocu.ImpCto * x-coe
                           EvtProvF.VtaxMesMn = EvtProvF.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin * x-coe
                           EvtProvF.CtoxMesMe = EvtProvF.CtoxMesMe + x-signo1 * CcbDdocu.ImpCto / x-TpoCmbCmp * x-coe
                           EvtProvF.VtaxMesMe = EvtProvF.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin / x-TpoCmbCmp * x-coe.
               IF Ccbcdocu.CodMon = 2 THEN 
                           ASSIGN
                           EvtProvF.CtoxDiaMe[x-Day] = EvtProvF.CtoxDiaMe[x-Day] + ( x-signo1 * CcbDdocu.ImpCto * x-coe)
                           EvtProvF.VtaxDiaMe[x-Day] = EvtProvF.VtaxDiaMe[x-Day] + ( x-signo1 * CcbDdocu.ImpLin * x-coe)
                           EvtProvF.CtoxMesMn = EvtProvF.CtoxMesMn + x-signo1 * CcbDdocu.ImpCto * x-TpoCmbVta * x-coe
                           EvtProvF.VtaxMesMn = EvtProvF.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta * x-coe
                           EvtProvF.CtoxMesMe = EvtProvF.CtoxMesMe + x-signo1 * CcbDdocu.ImpCto * x-coe
                           EvtProvF.VtaxMesMe = EvtProvF.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin * x-coe.

           END.  
  END.
END.



/* RHC 18.08.04 AHORA SE VAN A GENERAR PARA TODAS LAS DIVISIONES */
FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CodCia
    use-index Idx01 
    no-lock :
   
    FOR EACH EvtLine WHERE Evtline.Codcia = S-CODCIA
                       AND Evtline.CodDiv = Gn-Divi.CodDiv
                       AND Evtline.NroFch >= x-NroFchI
                       AND Evtline.NroFch <= x-NroFchF
                       USE-INDEX llave02 :
        DELETE EvtLine.
    END.
  
    FOR EACH EvtProv WHERE EvtProv.Codcia = S-CODCIA
                       AND EvtProv.CodDiv = Gn-Divi.CodDiv
                       AND EvtProv.NroFch >= x-NroFchI
                       AND EvtProv.NroFch <= x-NroFchF
                       USE-INDEX llave02 :
        DELETE EvtProv.
    END.

    FOR EACH EvtProvL WHERE EvtProvL.Codcia = S-CODCIA
                       AND EvtProvL.CodDiv = Gn-Divi.CodDiv
                       AND EvtProvL.NroFch >= x-NroFchI
                       AND EvtProvL.NroFch <= x-NroFchF
                       USE-INDEX llave02 :
        DELETE EvtProvL.
    END.

    FOR EACH EvtArti WHERE EvtArti.Codcia = S-CODCIA
                       AND EvtArti.CodDiv = Gn-Divi.CodDiv
                       AND EvtArti.CodMat begins ''
                       AND EvtArti.NroFch >= x-NroFchI
                       AND EvtArti.NroFch <= x-NroFchF
                       USE-INDEX llave01,
         EACH Almmmatg where Almmmatg.Codcia = Evtarti.Codcia AND
                             Almmmatg.CodMat = EvtArti.Codmat:
                                      
         display Evtarti.Codcia 
                 EvtArti.Coddiv
                 EvtArti.CodMat
                 EvtArti.CodAno
                 EvtArti.CodMes.
         FIND EvtLine WHERE EvtLine.Codcia = EvtArti.Codcia AND
                            EvtLine.CodDiv = EvtArti.CodDiv AND
                            EvtLine.CodFam = Almmmatg.CodFam AND
                            EvtLine.NroFch = EvtArti.NroFch
                            NO-ERROR.
         IF NOT AVAILABLE EvtLine THEN DO:
            CREATE EvtLine.
            ASSIGN  
             EvtLine.Codano = EvtArti.Codano 
             EvtLine.CodCia = EvtArti.Codcia
             EvtLine.CodDiv = EvtArti.CodDiv
             EvtLine.Codmes = EvtArti.CodMes
             EvtLine.CodFam = Almmmatg.CodFam 
             EvtLine.Nrofch = EvtArti.NroFch.
         END.
         ASSIGN
         EvtLine.VtaxMesMe = EvtLine.VtaxMesMe + EvtArti.VtaxMesMe 
         EvtLine.VtaxMesMn = EvtLine.VtaxMesMn + EvtArti.VtaxMesMn
         EvtLine.CtoxMesMe = EvtLine.CtoxMesMe + EvtArti.CtoxMesMe
         EvtLine.CtoxMesMn = EvtLine.CtoxMesMn + EvtArti.CtoxMesMn.                  
         DO I = 1 TO 31 :
            EvtLine.VtaxDiaMn[I] = EvtLine.VtaxDiaMn[I] + EvtArti.VtaxDiaMn[I].
            EvtLine.VtaxDiaMe[I] = EvtLine.VtaxDiaMe[I] + EvtArti.VtaxDiaMe[I].
            EvtLine.CtoxDiaMn[I] = EvtLine.CtoxDiaMn[I] + EvtArti.CtoxDiaMn[I].
            EvtLine.CtoxDiaMe[I] = EvtLine.CtoxDiaMe[I] + EvtArti.CtoxDiaMe[I].
         END.


         FIND EvtProv WHERE EvtProv.Codcia = EvtArti.Codcia AND
                            EvtProv.CodDiv = EvtArti.CodDiv AND
                            EvtProv.CodProv = Almmmatg.CodPr1 AND
                            EvtProv.NroFch = EvtArti.NroFch
                            NO-ERROR.
         IF NOT AVAILABLE EvtProv THEN DO:
            CREATE EvtProv.
            ASSIGN  
             EvtProv.Codano = EvtArti.Codano 
             EvtProv.CodCia = EvtArti.Codcia
             EvtProv.CodDiv = EvtArti.CodDiv
             EvtProv.Codmes = EvtArti.CodMes
             EvtProv.CodProv = Almmmatg.CodPr1
             EvtProv.Nrofch = EvtArti.NroFch.
         END.
         ASSIGN
         EvtProv.VtaxMesMe = EvtProv.VtaxMesMe + EvtArti.VtaxMesMe 
         EvtProv.VtaxMesMn = EvtProv.VtaxMesMn + EvtArti.VtaxMesMn
         EvtProv.CtoxMesMe = EvtProv.CtoxMesMe + EvtArti.CtoxMesMe
         EvtProv.CtoxMesMn = EvtProv.CtoxMesMn + EvtArti.CtoxMesMn.                  
         DO I = 1 TO 31 :
            EvtProv.VtaxDiaMn[I] = EvtProv.VtaxDiaMn[I] + EvtArti.VtaxDiaMn[I].
            EvtProv.VtaxDiaMe[I] = EvtProv.VtaxDiaMe[I] + EvtArti.VtaxDiaMe[I].
            EvtProv.CtoxDiaMn[I] = EvtProv.CtoxDiaMn[I] + EvtArti.CtoxDiaMn[I].
            EvtProv.CtoxDiaMe[I] = EvtProv.CtoxDiaMe[I] + EvtArti.CtoxDiaMe[I].
         END.

         FIND EvtProvL WHERE EvtProvL.Codcia = EvtArti.Codcia AND
                            EvtProvL.CodDiv = EvtArti.CodDiv AND
                            EvtProvL.CodProv = Almmmatg.CodPr1 AND
                            EvtProvL.CodFam = Almmmatg.CodFam AND
                            EvtProvL.NroFch = EvtArti.NroFch
                            NO-ERROR.
         IF NOT AVAILABLE EvtProvL THEN DO:
            CREATE EvtProvL.
            ASSIGN  
             EvtProvL.Codano = EvtArti.Codano 
             EvtProvL.CodCia = EvtArti.Codcia
             EvtProvL.CodDiv = EvtArti.CodDiv
             EvtProvL.Codmes = EvtArti.CodMes
             EvtProvL.CodProv = Almmmatg.CodPr1
             EvtProvL.CodFam  = Almmmatg.CodFam
             EvtProvL.Nrofch = EvtArti.NroFch.
         END.
         ASSIGN
         EvtProvL.VtaxMesMe = EvtProvL.VtaxMesMe + EvtArti.VtaxMesMe 
         EvtProvL.VtaxMesMn = EvtProvL.VtaxMesMn + EvtArti.VtaxMesMn
         EvtProvL.CtoxMesMe = EvtProvL.CtoxMesMe + EvtArti.CtoxMesMe
         EvtProvL.CtoxMesMn = EvtProvL.CtoxMesMn + EvtArti.CtoxMesMn.                  
         DO I = 1 TO 31 :
            EvtProvL.VtaxDiaMn[I] = EvtProvL.VtaxDiaMn[I] + EvtArti.VtaxDiaMn[I].
            EvtProvL.VtaxDiaMe[I] = EvtProvL.VtaxDiaMe[I] + EvtArti.VtaxDiaMe[I].
            EvtProvL.CtoxDiaMn[I] = EvtProvL.CtoxDiaMn[I] + EvtArti.CtoxDiaMn[I].
            EvtProvL.CtoxDiaMe[I] = EvtProvL.CtoxDiaMe[I] + EvtArti.CtoxDiaMe[I].
         END.
         PAUSE 0.
    END.

END.    
                       


