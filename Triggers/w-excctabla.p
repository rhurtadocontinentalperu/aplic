TRIGGER PROCEDURE FOR WRITE OF Excctabla OLD BUFFER OldExcctabla.

    IF Excctabla.codigo <> OldExcctabla.codigo THEN DO:
        FOR EACH Excdtabla OF OldExcctabla:
            Excdtabla.Codigo = Excctabla.Codigo.
        END.
    END.
