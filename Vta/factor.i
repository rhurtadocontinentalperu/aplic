            F-FACTOR = 1.
            FIND Foxb0001 WHERE Foxb0001.Codpro = CODIGO
                          NO-LOCK NO-ERROR.
            IF AVAIL Foxb0001 THEN DO:
                CASE Foxb2001.Unipro:
                    WHERE Foxb0001.Un1pro THEN F-FACTOR = Foxb0001.Eq1uni.
                    WHERE Foxb0001.Un2pro THEN F-FACTOR = Foxb0001.Eq2uni.
                    WHERE Foxb0001.Un3pro THEN F-FACTOR = Foxb0001.Eq3uni.
                    WHERE Foxb0001.Un6pro THEN F-FACTOR = Foxb0001.Eq6uni.
                END CASE.
            END.
