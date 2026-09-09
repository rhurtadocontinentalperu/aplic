DEF VAR s-codcia AS INT INIT 001.
DEF VAR s-coddiv AS CHAR INIT '00015'.
DEF VAR s-codcli AS CHAR.
DEF VAR s-codmon AS INT.
DEF VAR s-tpocmb AS DEC.
DEF VAR f-factor AS DEC.
DEF VAR s-cndvta AS CHAR.
DEF VAR x-canped AS DEC.
DEF VAR f-PreBas AS DEC.
DEF VAR f-PreVta AS DEC.
DEF VAR f-Dsctos AS DEC.
DEF VAR y-Dsctos AS DEC.
DEF VAR z-Dsctos AS DEC.

FIND faccfggn WHERE faccfggn.codcia = s-codcia NO-LOCK.

FOR EACH faccpedi WHERE codcia = s-codcia
    AND coddiv = s-coddiv
    AND coddoc = 'cot'
    AND nroped >= '015090003'
    AND nroped <= '015090123':
    DISPLAY faccpedi.nroped.
    PAUSE 0.
    s-codcli = Faccpedi.codcli.
    s-codmon = Faccpedi.codmon.
    s-tpocmb = Faccpedi.tpocmb.
    s-cndvta = Faccpedi.fmapgo.
    
    RUN Recalcular-Precios.
    RUN Graba-Totales.
END.

PROCEDURE Recalcular-Precios:

    FOR EACH Facdpedi OF Faccpedi:
      F-FACTOR = Facdpedi.Factor.
      FIND Almmmatg WHERE 
           Almmmatg.CodCia = Facdpedi.CODCIA AND  
           Almmmatg.codmat = Facdpedi.codmat 
           NO-LOCK NO-ERROR.
      IF AVAILABLE Almmmatg THEN DO:
          x-CanPed = Facdpedi.CanPed.
          RUN vtaexp/PrecioVenta (s-CodCia,
                              s-CodDiv,
                              s-CodCli,
                              s-CodMon,
                              s-TpoCmb,
                              f-Factor,
                              Almmmatg.CodMat,
                              s-CndVta,
                              x-CanPed,
                              4,
                              OUTPUT f-PreBas,
                              OUTPUT f-PreVta,
                              OUTPUT f-Dsctos,
                              OUTPUT y-Dsctos).

          /* RHC 8.11.05  DESCUENTO ADICIONAL POR EXPOLIBRERIA */
          z-Dsctos = 0.
          FIND FacTabla WHERE factabla.codcia = s-codcia
              AND factabla.tabla = 'EL'
              AND factabla.codigo = STRING(YEAR(TODAY), '9999')
              NO-LOCK NO-ERROR.
          IF AVAILABLE FacTabla 
              AND y-Dsctos = 0 
              AND LOOKUP(TRIM(s-CndVta), '000,001') > 0 
              THEN DO:    /* NO Promociones */
              CASE Almmmatg.Chr__02:
                  WHEN 'P' THEN z-Dsctos = FacTabla.Valor[1].
                  WHEN 'T' THEN z-Dsctos = FacTabla.Valor[2].
              END CASE.
          END.
          IF AVAILABLE FacTabla 
              AND y-Dsctos = 0 
              AND LOOKUP(TRIM(s-CndVta), '400,401') > 0 
              THEN DO:    /* NO Promociones */
              CASE Almmmatg.Chr__02:
                  WHEN 'P' THEN z-Dsctos = FacTabla.Valor[1] /*- 1*/.
                  WHEN 'T' THEN z-Dsctos = FacTabla.Valor[2] /*- 2*/.
              END CASE.
          END.
          /* ************************************************* */

          ASSIGN 
              Facdpedi.PreBas = F-PreBas 
              Facdpedi.AftIgv = Almmmatg.AftIgv 
              Facdpedi.AftIsc = Almmmatg.AftIsc
              Facdpedi.PreUni = F-PREVTA
              Facdpedi.PorDto = F-DSCTOS
              Facdpedi.Por_Dsctos[1] = z-Dsctos
              Facdpedi.Por_Dsctos[2] = Almmmatg.PorMax
              Facdpedi.Por_Dsctos[3] = Y-DSCTOS 
              Facdpedi.ImpDto = ROUND( Facdpedi.PreUni * Facdpedi.CanPed * (Facdpedi.Por_Dsctos[1] / 100),4 )
              Facdpedi.ImpLin = ROUND( Facdpedi.PreUni * Facdpedi.CanPed , 2 ) - Facdpedi.ImpDto.
         IF Facdpedi.AftIsc THEN 
            Facdpedi.ImpIsc = ROUND(Facdpedi.PreBas * Facdpedi.CanPed * (Almmmatg.PorIsc / 100),4).
         IF Facdpedi.AftIgv THEN  
            Facdpedi.ImpIgv = Facdpedi.ImpLin - ROUND(Facdpedi.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
      END.
    END.


END PROCEDURE.

PROCEDURE Graba-Totales:

    DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
    DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
    DEFINE VARIABLE X-STANDFORD AS DECIMAL NO-UNDO.
    DEFINE VARIABLE X-LINEA1 AS DECIMAL NO-UNDO.
    DEFINE VARIABLE X-OTROS AS DECIMAL NO-UNDO.
    DEFINE VARIABLE Y-IMPTOT AS DECIMAL NO-UNDO.

    ASSIGN
      FacCPedi.ImpDto = 0
      FacCPedi.ImpIgv = 0
      FacCPedi.ImpIsc = 0
      FacCPedi.ImpTot = 0
      FacCPedi.ImpExo = 0
      FacCPedi.Importe[3] = 0.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK: 
      FacCPedi.ImpDto = FacCPedi.ImpDto + Facdpedi.ImpDto.
      F-Igv = F-Igv + Facdpedi.ImpIgv.
      F-Isc = F-Isc + Facdpedi.ImpIsc.
      FacCPedi.ImpTot = FacCPedi.ImpTot + Facdpedi.ImpLin.
      IF NOT Facdpedi.AftIgv THEN FacCPedi.ImpExo = FacCPedi.ImpExo + Facdpedi.ImpLin.
      /******************Identificacion de Importes para Descuento**********/
      FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND 
                           Almmmatg.Codmat = Facdpedi.CodMat NO-LOCK NO-ERROR.
      IF AVAILABLE Almmmatg THEN DO:
          IF Almmmatg.CodFam = "002" AND Almmmatg.SubFam = "012" AND TRIM(Almmmatg.Desmar) = "STANDFORD" 
          THEN X-STANDFORD = X-STANDFORD + Facdpedi.ImpLin.
          IF Facdpedi.Por_Dsctos[3] = 0 THEN DO:
             IF Almmmatg.CodFam = "001" 
             THEN X-LINEA1 = X-LINEA1 + Facdpedi.ImpLin.
             ELSE X-OTROS = X-OTROS + Facdpedi.ImpLin.
          END.                
      END.
      /*********************************************************************/
    END.
    Y-IMPTOT = ( X-LINEA1 + X-OTROS ) .   
    ASSIGN
      FacCPedi.ImpIgv = ROUND(F-IGV,2)
      FacCPedi.ImpIsc = ROUND(F-ISC,2)
      FacCPedi.ImpBrt = FacCPedi.ImpTot - FacCPedi.ImpIgv - FacCPedi.ImpIsc + 
                          FacCPedi.ImpDto - FacCPedi.ImpExo
      FacCPedi.ImpVta = FacCPedi.ImpBrt - FacCPedi.ImpDto
      FacCPedi.ImpDto = FacCPedi.ImpDto + ROUND(FacCPedi.ImpTot * FacCPedi.PorDto / 100,2)
      FacCPedi.ImpTot = ROUND(FacCPedi.ImpTot * (1 - FacCPedi.PorDto / 100),2)
      FacCPedi.ImpVta = ROUND(FacCPedi.ImpTot / (1 + FacCPedi.PorIgv / 100),2)
      FacCPedi.ImpIgv = FacCPedi.ImpTot - FacCPedi.ImpVta
      FacCPedi.ImpBrt = FacCPedi.ImpTot - FacCPedi.ImpIgv - FacCPedi.ImpIsc + 
                          FacCPedi.ImpDto - FacCPedi.ImpExo.
      FacCPedi.Importe[3] = IF Y-IMPTOT > FacCPedi.ImpTot THEN FacCPedi.ImpTot ELSE Y-IMPTOT.


END PROCEDURE.

