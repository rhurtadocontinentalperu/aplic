TRIGGER PROCEDURE FOR DELETE OF gn-clie.

    DEFINE SHARED VAR s-codcia AS INT.

    FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
      AND Ccbcdocu.codcli = gn-clie.codcli NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbcdocu THEN DO:
      MESSAGE 'Este cliente tiene historial de créditos, no se puede anular'
          VIEW-AS ALERT-BOX ERROR.
      RETURN ERROR.
    END.

    RUN lib/logtabla ('GN-CLIE',
                      STRING(gn-clie.codcia, '999') + '|' + gn-clie.codcli,
                      'DELETE').

    FOR EACH Gn-CLieB OF Gn-Clie:
      DELETE Gn-ClieB.
    END.
    FOR EACH Gn-CLieD OF Gn-Clie:
      DELETE Gn-ClieD.
    END.
    FOR EACH Gn-CLieL OF Gn-Clie:
      DELETE Gn-ClieL.
    END.
    FOR EACH Gn-CLieCyg OF Gn-Clie:
      DELETE Gn-ClieCyg.
    END.
