TRIGGER PROCEDURE FOR DELETE OF AlmCKits.

    DEFINE SHARED VAR s-codcia AS INT.

    /* borramos tablas relacionadas */
    FOR EACH AlmDKits OF AlmCKits:
        DELETE AlmDKits.
    END.
