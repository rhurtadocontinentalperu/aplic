{lib/tt-file.i}

DEF TEMP-TABLE t-matg
    FIELD codmat LIKE almmmatg.codmat
    FIELD desmat LIKE almmmatg.desmat
    FIELD desmar LIKE almmmatg.desmar
    FIELD codfam LIKE almmmatg.codfam
    FIELD subfam LIKE almmmatg.subfam
    FIELD undstk LIKE almmmatg.undstk.


FOR EACH almmmatg NO-LOCK WHERE codcia = 1 AND codmat <= '000150':
    CREATE t-matg.
    BUFFER-COPY almmmatg TO t-matg.
END.


DEF VAR x-file AS CHAR.
DEF VAR coptions AS CHAR.

coptions = 'FileType:xml' + CHR(1) + 'Grid:yes'.
RUN lib/tt-file (TEMP-TABLE t-matg:HANDLE, x-file, cOptions).
