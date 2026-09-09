define input parameter x-inven as integer.
 FIND Almtdocm WHERE 
      Almtdocm.CodCia = s-codcia AND
      Almtdocm.CodAlm = S-CODALM AND Almtdocm.TipMov = 'I' AND
      Almtdocm.CodMov = 11 NO-ERROR.
 if not avail  Almtdocm then do:
     message "El Movimiento 11 no esta definido en Autorización de Movimientos" skip 
     "el programa será abortado" view-as alert-box.
 end.     
 
 CREATE Almcmov.
 ASSIGN Almcmov.CodCia  = Almtdocm.CodCia 
        Almcmov.CodAlm  = Almtdocm.CodAlm 
        Almcmov.TipMov  = Almtdocm.TipMov
        Almcmov.CodMov  = Almtdocm.CodMov
        Almcmov.Observ  = 'AJUSTE POR DIFERENCIA DE INVENTARIO ' + string(today,"99/99/99") + string(time,"HH:MM") + S-USER-ID
        Almcmov.usuario = S-USER-ID
        Almcmov.Fchdoc  = InvConfig.FchInv
        Almcmov.Tpocmb  = X-TPOCMB.
 IF AVAILABLE Almtdocm THEN ASSIGN Almcmov.NroDoc = Almtdocm.NroDoc
                                   Almtdocm.NroDoc = Almtdocm.NroDoc + 1.
 RELEASE Almtdocm.
  
 FOR EACH T-REPORT WHERE T-report.Campo-f[6] > 0 AND T-report.Campo-f[7] = x-inven:
     CREATE almdmov.
     ASSIGN Almdmov.CodCia = Almcmov.CodCia 
            Almdmov.CodAlm = Almcmov.CodAlm 
            Almdmov.TipMov = Almcmov.TipMov 
            Almdmov.CodMov = Almcmov.CodMov 
            Almdmov.NroDoc = Almcmov.NroDoc 
            Almdmov.CodMon = Almcmov.CodMon 
            Almdmov.FchDoc = Almcmov.FchDoc 
            Almdmov.TpoCmb = Almcmov.TpoCmb
            Almdmov.codmat = T-report.Llave-C
            Almdmov.CanDes = T-report.Campo-f[6]
            Almdmov.CodUnd = T-report.Campo-c[2]
            Almdmov.Factor = 1.
            
     IF I-TpoCto = 1 THEN 
        ASSIGN Almdmov.PreUni = ROUND(T-report.Campo-f[2] / T-report.Campo-f[1], 4).
     ELSE 
        ASSIGN Almdmov.PreUni = ROUND(T-report.Campo-f[4], 4).
        
     ASSIGN Almdmov.ImpCto = Almdmov.Preuni * Almdmov.Candes
            Almdmov.CodAjt = ''
                   R-ROWID = ROWID(Almdmov).
     FIND FIRST Almtmovm WHERE 
                Almtmovm.CodCia = Almcmov.CodCia AND
                Almtmovm.Tipmov = Almcmov.TipMov AND 
                Almtmovm.Codmov = Almcmov.CodMov NO-LOCK NO-ERROR.
     IF AVAILABLE Almtmovm AND Almtmovm.PidPCo THEN ASSIGN Almdmov.CodAjt = "A".
     ELSE ASSIGN Almdmov.CodAjt = ''.
     RUN ALM\ALMACSTK (R-ROWID).
     /*
     RUN ALM\ALMACPR1 (R-ROWID,"U").
     RUN ALM\ALMACPR2 (R-ROWID,"U").
     */
 END. 
END PROCEDURE.
