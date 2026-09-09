TRIGGER PROCEDURE FOR WRITE OF Dsctos.

DEF SHARED VAR s-user-id AS CHAR.

/* CONTROL DE MIGRACION AL OPENORANGE */
IF NEW Dsctos THEN
    ASSIGN
    Dsctos.FlagFecha = STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS')
    Dsctos.FlagMigracion = "N"
    Dsctos.FlagTipo      = "I"
    Dsctos.FlagUsuario   = s-user-id.
ELSE ASSIGN
    Dsctos.FlagFecha = STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS')
    Dsctos.FlagMigracion = "N"
    Dsctos.FlagTipo      = "U"
    Dsctos.FlagUsuario   = s-user-id.
