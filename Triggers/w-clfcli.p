TRIGGER PROCEDURE FOR WRITE OF ClfCli.

DEF SHARED VAR s-user-id AS CHAR.

/* CONTROL DE MIGRACION AL OPENORANGE */
IF NEW ClfCli THEN
    ASSIGN
    ClfCli.FlagFecha = STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS')
    ClfCli.FlagMigracion = "N"
    ClfCli.FlagTipo      = "I"
    ClfCli.FlagUsuario   = s-user-id.
ELSE ASSIGN
    ClfCli.FlagFecha = STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS')
    ClfCli.FlagMigracion = "N"
    ClfCli.FlagTipo      = "U"
    ClfCli.FlagUsuario   = s-user-id.
