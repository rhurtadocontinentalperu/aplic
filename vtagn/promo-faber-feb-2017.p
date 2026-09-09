/* RHC 22/02/2017 Promoción Faber */
DEF VAR x-Grupo1 AS CHAR INIT '037210,037209,037211' NO-UNDO.
DEF VAR x-Grupo2 AS CHAR INIT '024098,024100,024099' NO-UNDO.
DEF VAR x-Grupo3 AS CHAR INIT '073392,073394,073393' NO-UNDO.

DEF VAR k AS INT NO-UNDO.

DEF TEMP-TABLE T-COMPONENTE LIKE Facdpedi
    FIELD Componente AS CHAR
    FIELD Kits       AS INT.
/* Deben ser multiplos exactos del empaque inner */
DO  k = 1 TO NUM-ENTRIES(x-Grupo1):
    FIND Facdpedi OF Faccpedi WHERE Facdpedi.codmat = ENTRY(k,x-Grupo1)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Facdpedi THEN NEXT.
    FIND Almmmatg OF Facdpedi NO-LOCK.
    IF Almmmatg.StkRep <= 0 THEN NEXT.
    IF (Facdpedi.CanPed * Facdpedi.Factor) MODULO Almmmatg.StkRep <> 0 THEN NEXT.
    CREATE T-COMPONENTE.
    BUFFER-COPY Facdpedi 
        TO T-COMPONENTE 
        ASSIGN 
        T-COMPONENTE.Componente = '1'
        T-COMPONENTE.Kits       = (Facdpedi.CanPed * Facdpedi.Factor) / Almmmatg.StkRep.
END.
FIND FIRST T-COMPONENTE WHERE T-COMPONENTE.Componente = '1' NO-LOCK NO-ERROR.
IF NOT AVAILABLE T-COMPONENTE THEN RETURN.

DO  k = 1 TO NUM-ENTRIES(x-Grupo2):
    FIND Facdpedi OF Faccpedi WHERE Facdpedi.codmat = ENTRY(k,x-Grupo2)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Facdpedi THEN NEXT.
    FIND Almmmatg OF Facdpedi NO-LOCK.
    IF Almmmatg.StkRep <= 0 THEN NEXT.
    IF (Facdpedi.CanPed * Facdpedi.Factor) MODULO Almmmatg.StkRep <> 0 THEN NEXT.
    CREATE T-COMPONENTE.
    BUFFER-COPY Facdpedi 
        TO T-COMPONENTE 
        ASSIGN 
        T-COMPONENTE.Componente = '2'
        T-COMPONENTE.Kits       = (Facdpedi.CanPed * Facdpedi.Factor) / Almmmatg.StkRep.
END.
FIND FIRST T-COMPONENTE WHERE T-COMPONENTE.Componente = '2' NO-LOCK NO-ERROR.
IF NOT AVAILABLE T-COMPONENTE THEN RETURN.

DO  k = 1 TO NUM-ENTRIES(x-Grupo3):
    FIND Facdpedi OF Faccpedi WHERE Facdpedi.codmat = ENTRY(k,x-Grupo3)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Facdpedi THEN NEXT.
    FIND Almmmatg OF Facdpedi NO-LOCK.
    IF Almmmatg.StkRep <= 0 THEN NEXT.
    IF (Facdpedi.CanPed * Facdpedi.Factor) MODULO Almmmatg.StkRep <> 0 THEN NEXT.
    CREATE T-COMPONENTE.
    BUFFER-COPY Facdpedi 
        TO T-COMPONENTE 
        ASSIGN 
        T-COMPONENTE.Componente = '3'
        T-COMPONENTE.Kits       = (Facdpedi.CanPed * Facdpedi.Factor) / Almmmatg.StkRep.
END.
FIND FIRST T-COMPONENTE WHERE T-COMPONENTE.Componente = '3' NO-LOCK NO-ERROR.
IF NOT AVAILABLE T-COMPONENTE THEN RETURN.
/* Determinamos cuantos kits podemos armar */
DEF VAR x-Kits-1 AS INT NO-UNDO.
DEF VAR x-Kits-2 AS INT NO-UNDO.
DEF VAR x-Kits-3 AS INT NO-UNDO.

FOR EACH T-COMPONENTE NO-LOCK WHERE T-COMPONENTE.Componente = '1':
    x-Kits-1 = x-Kits-1 + T-COMPONENTE.Kits.
END.
FOR EACH T-COMPONENTE NO-LOCK WHERE T-COMPONENTE.Componente = '2':
    x-Kits-2 = x-Kits-2 + T-COMPONENTE.Kits.
END.
FOR EACH T-COMPONENTE NO-LOCK WHERE T-COMPONENTE.Componente = '3':
    x-Kits-3 = x-Kits-3 + T-COMPONENTE.Kits.
END.
IF x-Kits-1 <> x-Kits-2 OR x-Kits-1 <> x-Kits-3 THEN RETURN.
/* Actualizamos el Porcentaje de Descuentos */
FOR EACH T-COMPONENTE NO-LOCK,
    FIRST Facdpedi OF Faccpedi WHERE Facdpedi.CodMat = T-COMPONENTE.CodMat:
    ASSIGN
        FacDPedi.Por_Dsctos[1] = 0
        FacDPedi.Por_Dsctos[2] = 0
        FacDPedi.Por_Dsctos[3] = 10
        Facdpedi.Libre_c04 = "DCAMPANA".
END.

