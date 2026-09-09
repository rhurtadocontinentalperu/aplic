DEF VAR pCodFam AS CHAR .
DEF VAR s-codcia AS INT INIT 001.
DEF VAR pCodMat AS CHAR.
DEF VAR pMarca AS CHAR.
DEF VAR CMB-filtro AS CHAR.
DEF VAR pFiltro AS CHAR.

DEF TEMP-TABLE t-Almmmatg LIKE Almmmatg.

DEF TEMP-TABLE t-Matg
    FIELD codmat AS CHAR.

pCodFam = '010'.
pCodMat = ''.
pMarca = ''.
CMB-filtro = 'Nombres que contengan'.
pFiltro = 'cuad rayado'.

DEF VAR LocalCadena AS CHAR NO-UNDO.
DEF VAR LocalOrden AS INTE NO-UNDO.

DEF VAR c-CodMat AS CHAR.
CASE TRUE:
    WHEN pCodMat > '' THEN DO:
        DECLARE cur-CodMat-01 CURSOR FOR 
        SELECT Almmmatg.codmat 
            FROM Almmmatg, Almtfami 
            WHERE Almmmatg.codcia = s-codcia AND 
            Almmmatg.codmat = pCodMat AND
            Almmmatg.tpoart <> "D" AND
            Almtfami.codcia = Almmmatg.codcia AND
            Almtfami.codfam = Almmmatg.codfam AND
            Almtfami.swcomercial = YES
            .
        OPEN cur-CodMat-01.
        FETCH cur-CodMat-01 INTO c-CodMat.
        REPEAT:
            CREATE t-Matg.
            ASSIGN t-Matg.CodMat = c-CodMat.
            FETCH cur-CodMat-01 INTO c-CodMat.
        END.
    END.
    WHEN CMB-filtro = 'Nombres que inicien con' AND pFiltro > '' THEN DO:
        DECLARE cur-CodMat-02 CURSOR FOR 
        SELECT Almmmatg.codmat
            FROM Almmmatg, Almtfami
            WHERE Almmmatg.codcia = s-codcia AND 
            Almmmatg.desmat BEGINS pFiltro AND
            Almmmatg.tpoart <> "D" AND
            (pMarca = '' OR Almmmatg.desmar BEGINS pMarca) AND
            (pCodFam = 'Todos' OR Almmmatg.codfam = pCodFam) AND
            Almtfami.codcia = Almmmatg.codcia AND
            Almtfami.codfam = Almmmatg.codfam AND
            Almtfami.swcomercial = YES
            .
        OPEN cur-CodMat-02.
        FETCH cur-CodMat-02 INTO c-CodMat.
        REPEAT:
            CREATE t-Matg.
            ASSIGN t-Matg.CodMat = c-CodMat.
            FETCH cur-CodMat-02 INTO c-CodMat.
        END.
    END.
    WHEN CMB-filtro = 'Nombres que contengan' AND pFiltro > '' THEN DO:
        DO LocalOrden = 1 TO NUM-ENTRIES(pFiltro, " "):
            LocalCadena = LocalCadena + (IF TRUE <> (LocalCadena > '') THEN "" ELSE " ") + 
                TRIM(ENTRY(LocalOrden,pFiltro, " ")) + "*".
        END.
        DECLARE cur-CodMat-03 CURSOR FOR
        SELECT Almmmatg.codmat
            FROM Almmmatg, Almtfami, Almmmate
            WHERE Almmmatg.codcia = s-codcia AND
            Almmmatg.DesMat CONTAINS LocalCadena  AND
            Almmmatg.tpoart <> "D" AND
            (pMarca = '' OR Almmmatg.desmar BEGINS pMarca) AND
            (pCodFam = 'Todos' OR Almmmatg.codfam = pCodFam) AND
            Almtfami.codcia = Almmmatg.codcia AND
            Almtfami.codfam = Almmmatg.codfam AND
            Almtfami.swcomercial = YES AND
            Almmmate.codcia = Almmmatg.codcia AND
            Almmmate.codalm = "03" AND
            Almmmate.codmat = Almmmatg.codmat AND
            Almmmate.stkact > 0
            .
        OPEN cur-CodMat-03.
        FETCH cur-CodMat-03 INTO c-CodMat.
        REPEAT:
            CREATE t-Matg.
            ASSIGN t-Matg.CodMat = c-CodMat.
            FETCH cur-CodMat-03 INTO c-CodMat.
        END.
    END.
    OTHERWISE DO:
        DECLARE cur-CodMat-04 CURSOR FOR 
        SELECT Almmmatg.codmat 
            FROM Almmmatg, Almtfami
            WHERE Almmmatg.codcia = s-codcia AND 
            Almmmatg.tpoart <> "D" AND
            (pMarca = '' OR Almmmatg.desmar BEGINS pMarca) AND
            (pCodFam = 'Todos' OR Almmmatg.codfam = pCodFam) AND
            Almtfami.codcia = Almmmatg.codcia AND
            Almtfami.codfam = Almmmatg.codfam AND
            Almtfami.swcomercial = YES
            .
        OPEN cur-CodMat-04.
        FETCH cur-CodMat-04 INTO c-CodMat.
        REPEAT:
            CREATE t-Matg.
            ASSIGN t-Matg.CodMat = c-CodMat.
            FETCH cur-CodMat-04 INTO c-CodMat.
        END.
    END.
END CASE.


FOR EACH t-Matg, FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = 1 AND Almmmatg.codmat = t-Matg.codmat:
    CREATE t-Almmmatg.
    BUFFER-COPY Almmmatg TO t-Almmmatg.
END.

FOR EACH t-almmmatg NO-LOCK:
    DISPLAY t-almmmatg.codmat t-almmmatg.desmat t-almmmatg.codfam WITH STREAM-IO NO-BOX WIDTH 320.
END.
