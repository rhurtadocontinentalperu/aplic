TRIGGER PROCEDURE FOR DELETE OF VtaTrack01.

    DEFINE SHARED VAR s-codcia AS INT.

    /* borramos tablas relacionadas */
    FOR EACH VtaTrack02 OF VtaTrack01:
        DELETE VtaTrack02.
    END.
    FOR EACH VtaTrack03 OF VtaTrack01:
        DELETE VtaTrack03.
    END.
