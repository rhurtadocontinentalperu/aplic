TRIGGER PROCEDURE FOR WRITE OF Gn-Ven.

DEF SHARED VAR s-user-id AS CHAR.

/* CONTROL DE MIGRACION AL OPENORANGE */
IF NEW Gn-Ven THEN
    ASSIGN
    Gn-Ven.FlagFecha = STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS')
    Gn-Ven.FlagMigracion = "N"
    Gn-Ven.FlagTipo      = "I"
    Gn-Ven.FlagUsuario   = s-user-id.
ELSE ASSIGN
    Gn-Ven.FlagFecha = STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS')
    Gn-Ven.FlagMigracion = "N"
    Gn-Ven.FlagTipo      = "U"
    Gn-Ven.FlagUsuario   = s-user-id.
