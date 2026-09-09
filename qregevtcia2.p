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

/* DESCOMENTAR SI QUIERES CALCULAR POR UN RANGO DE FECHAS FIJO */ 
x-CodFchI = 01/01/2008.
x-codfchf = TODAY - 1.

x-NroFchI = INTEGER(STRING(YEAR(x-CodFchI),"9999") + STRING(MONTH(x-CodFchI),"99")).      
x-NroFchF = INTEGER(STRING(YEAR(x-CodFchF),"9999") + STRING(MONTH(x-CodFchF),"99")).                           

DISPLAY x-CodFchI x-CodFchF x-NroFchI x-NroFchF.
PAUSE 0.

/* RHC 18.08.04 AHORA SE VAN A GENERAR PARA TODAS LAS DIVISIONES */
FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CodCia use-index Idx01 no-lock :
   
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
                       

