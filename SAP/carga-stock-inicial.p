DEF STREAM salida.
OUTPUT STREAM salida TO d:\almmmate.d.
PUT STREAM salida "CodAlm CodMat StkAct" SKIP.
FOR EACH almmmatg NO-LOCK WHERE almmmatg.codcia = 1 
    AND almmmatg.tpoart = "A"
    AND (almmmatg.catconta[1] = 'MC' OR almmmatg.catconta[1] = 'MI' OR 
         almmmatg.catconta[1] = 'PM' OR almmmatg.catconta[1] = 'CR'):
    DISPLAY almmmatg.codmat WITH STREAM-IO NO-BOX NO-LABELS. PAUSE 0.
    FOR EACH almacen NO-LOCK WHERE almacen.codcia = 1:
        FIND LAST almstkal USE-INDEX llave01 WHERE almstkal.codcia = 1
            AND almstkal.codalm = almacen.codalm
            AND almstkal.codmat = almmmatg.codmat
            AND almstkal.fecha < DATE(02,01,2026)
            NO-LOCK NO-ERROR.
        IF AVAILABLE almstkal THEN
            PUT STREAM salida UNFORMATTED 
                almacen.codalm   " "
                almmmatg.codmat  " "
                almstkal.stkact 
                SKIP.
    END.
END.
OUTPUT STREAM salida CLOSE.

