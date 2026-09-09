DEF NEW SHARED VAR s-user-id AS CHAR INIT 'ADMIN'.
DEF NEW SHARED VAR hSocket AS HANDLE NO-UNDO.
DEF VAR perror AS CHAR NO-UNDO.

FOR EACH ccbcdocu NO-LOCK WHERE codcia = 1
    AND coddiv = '00001'
    AND flgest <> 'a'
    AND coddoc = 'FAC'
    AND fchdoc >= 04/01/2016
    AND fchdoc <= 04/30/2016:
    RUN sunat\progress-to-ppll ( ROWID(ccbcdocu), OUTPUT perror).
    DISPLAY coddoc nrodoc perror WITH STREAM-IO WIDTH 320.
    PAUSE 0.
END.
