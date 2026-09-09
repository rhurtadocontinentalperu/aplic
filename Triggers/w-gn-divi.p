TRIGGER PROCEDURE FOR WRITE OF Gn-Divi.

DEF SHARED VAR s-user-id AS CHAR.

/* CONTROL DE MIGRACION AL OPENORANGE */
IF NEW Gn-Divi THEN
    ASSIGN
    Gn-Divi.FlagFecha = STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS')
    Gn-Divi.FlagMigracion = "N"
    Gn-Divi.FlagTipo      = "I"
    Gn-Divi.FlagUsuario   = s-user-id.
ELSE ASSIGN
    Gn-Divi.FlagFecha = STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS')
    Gn-Divi.FlagMigracion = "N"
    Gn-Divi.FlagTipo      = "U"
    Gn-Divi.FlagUsuario   = s-user-id.
