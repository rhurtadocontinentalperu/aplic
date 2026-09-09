DEFINE INPUT PARAMETER s-codcia  LIKE cb-dmov.codcia.
DEFINE INPUT PARAMETER x-CodCta  LIKE cb-dmov.codcta.
DEFINE INPUT PARAMETER x-CodDiv  LIKE cb-dmov.coddiv.
DEFINE INPUT PARAMETER x-Periodo LIKE cb-dmov.periodo.
DEFINE INPUT PARAMETER x-NroMes  LIKE cb-dmov.nromes.
DEFINE INPUT PARAMETER x-CodMon  LIKE cb-dmov.codmon.

DEFINE OUTPUT PARAMETER ImpCal1  AS DECIMAL.
DEFINE OUTPUT PARAMETER ImpCal2  AS DECIMAL.
DEFINE OUTPUT PARAMETER ImpCal3  AS DECIMAL.
DEFINE OUTPUT PARAMETER ImpCal4  AS DECIMAL.

DEFINE VARIABLE i AS INTEGER.
DEFINE VARIABLE x-ImpDbe AS DECIMAL.
DEFINE VARIABLE x-ImpHbe AS DECIMAL.
DEFINE VARIABLE x-ImpSdo AS DECIMAL.

DEFINE SHARED VAR cb-maxnivel AS INTEGER.

ImpCal1 = 0.  /*  Saldo Sub-Cuentas Debe del mes  */
ImpCal2 = 0.  /*  Saldo Sub-Cuentas Haber del mes */

ImpCal3 = 0.  /*  Saldo Sub-Cuentas Debe acumulado  */
ImpCal4 = 0.  /*  Saldo Sub-Cuentas Haber acumulado */

FOR EACH cb-acmd WHERE cb-acmd.CodCia  = s-codcia AND 
                       cb-acmd.Periodo = x-Periodo AND 
                       cb-acmd.CodCta  BEGINS ( x-CodCta ) AND 
                       cb-acmd.CodDiv  BEGINS ( x-CodDiv ) NO-LOCK:
    RUN ACUMULA.
END.           
  
RETURN.


PROCEDURE ACUMULA.

   DO i = 1 TO ( x-NroMes + 1) :
        CASE x-codmon:
        WHEN 1 THEN DO:
            x-ImpDbe = cb-acmd.DbeMn1[ i ].
            x-ImpHbe = cb-acmd.HbeMn1[ i ].
        END.
        WHEN 2 THEN DO:
           x-ImpDbe = cb-acmd.DbeMn2[ i ].
           x-ImpHbe = cb-acmd.HbeMn2[ i ].
        END.
        WHEN 3 THEN DO:
            x-ImpDbe = cb-acmd.DbeMn3[ i ].
            x-ImpHbe = cb-acmd.HbeMn3[ i ].
        END.
        END CASE.
        x-ImpSdo = x-ImpDbe - x-ImpHbe.
        IF x-ImpSdo > 0 THEN ImpCal3 = ImpCal3 + x-ImpSdo.
           ELSE ImpCal4 = ImpCal4 + x-ImpSdo.
                      
        IF i = ( x-NroMes + 1 ) THEN DO:
           IF x-ImpSdo > 0 THEN ImpCal1 = ImpCal1 + x-ImpSdo.
              ELSE ImpCal2 = ImpCal2 + x-ImpSdo.           
        END.
    END.
    
END PROCEDURE.
