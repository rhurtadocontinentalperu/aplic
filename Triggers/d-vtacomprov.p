TRIGGER PROCEDURE FOR DELETE OF Vtacomprov.

    /* borramos tablas relacionadas */
    FOR EACH Vtacomarti OF Vtacomprov:
        DELETE Vtacomarti.
    END.

    FOR EACH Vtacomvige OF Vtacomprov:
        DELETE Vtacomvige.
    END.
