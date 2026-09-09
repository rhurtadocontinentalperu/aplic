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
  
x-codfchi = DATE(MONTH(TODAY - 30), 01, YEAR(TODAY - 30)).
x-codfchf = TODAY - 1.

x-NroFchI = INTEGER(STRING(YEAR(x-CodFchI),"9999") + STRING(MONTH(x-CodFchI),"99")).      
x-NroFchF = INTEGER(STRING(YEAR(x-CodFchF),"9999") + STRING(MONTH(x-CodFchF),"99")).                           

DISPLAY x-CodFchI x-CodFchF x-NroFchI x-NroFchF.
PAUSE 0.
    
    FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CodCia
        use-index Idx01 
        no-lock :
   
        FOR EACH CcbCdocu WHERE CcbCdocu.CodCia = S-CODCIA 
                            AND CcbCdocu.CodDiv = Gn-Divi.CodDiv
                            AND CcbCdocu.FchDoc >= x-CodFchI
                            AND CcbCdocu.FchDoc <= x-CodFchF
                            USE-INDEX llave10
                            BREAK BY CcbCdocu.CodCia
                                  BY CcbCdocu.CodDiv
                                  BY CcbCdocu.FchDoc:
            /* ***************** FILTROS ********************************** */
            IF Lookup(CcbCDocu.CodDoc,"TCK,FAC,BOL,N/C,N/D") = 0 THEN NEXT.
            IF CcbCDocu.FlgEst = "A"  THEN NEXT.
            IF CcbCDocu.ImpCto = ? THEN DO:
                CcbCDocu.ImpCto = 0.
            END.
            IF DAY(CcbCDocu.FchDoc) = 0 OR DAY(CcbCDocu.FchDoc) = ?
            THEN NEXT.
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
            
            IF Ccbcdocu.CodMon = 1 THEN 
                ASSIGN
                    EvtDivi.VtaxMesMn = EvtDivi.VtaxMesMn + x-signo1 * CcbCdocu.ImpTot
                    EvtDivi.VtaxMesMe = EvtDivi.VtaxMesMe + x-signo1 * CcbCdocu.ImpTot / x-TpoCmbCmp.
            IF Ccbcdocu.CodMon = 2 THEN 
                ASSIGN
                    EvtDivi.VtaxMesMn = EvtDivi.VtaxMesMn + x-signo1 * CcbCdocu.ImpTot * x-TpoCmbVta
                    EvtDivi.VtaxMesMe = EvtDivi.VtaxMesMe + x-signo1 * CcbCdocu.ImpTot.


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
               
               IF Ccbcdocu.CodMon = 1 THEN 
                    ASSIGN
                        EvtArti.VtaxMesMn = EvtArti.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin
                        EvtArti.VtaxMesMe = EvtArti.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin / x-TpoCmbCmp.
               IF Ccbcdocu.CodMon = 2 THEN 
                    ASSIGN
                        EvtArti.VtaxMesMn = EvtArti.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta
                        EvtArti.VtaxMesMe = EvtArti.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin.
               ASSIGN            
               EvtArti.CanxMes = EvtArti.CanxMes + ( x-signo1 * CcbDdocu.CanDes * F-FACTOR ).

           END.  
        END.
    END.
  
  
  

PROCEDURE PROCESA-NOTA:

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
               
               IF Ccbcdocu.CodMon = 1 THEN 
                    ASSIGN
                       EvtArti.VtaxMesMn = EvtArti.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin * x-coe
                       EvtArti.VtaxMesMe = EvtArti.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin * x-coe / x-TpoCmbCmp.
               IF Ccbcdocu.CodMon = 2 THEN 
                    ASSIGN
                        EvtArti.VtaxMesMn = EvtArti.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta * x-coe
                        EvtArti.VtaxMesMe = EvtArti.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin * x-coe.
               ASSIGN            
               EvtArti.CanxMes = EvtArti.CanxMes + ( x-signo1 * CcbDdocu.CanDes * F-FACTOR * x-can).

           END.  
  END.
END.



