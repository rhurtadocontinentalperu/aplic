TRIGGER PROCEDURE FOR WRITE OF Gn-ConVt.

DEF SHARED VAR s-user-id AS CHAR.

/* CONTROL DE MIGRACION AL OPENORANGE */
IF NEW Gn-ConVt THEN
    ASSIGN
    Gn-ConVt.FlagFecha = STRING(DATETIME(TODAY, MTIME), "99/99/9999 HH:MM:SS")
    Gn-ConVt.FlagMigracion = "N"
    Gn-ConVt.FlagTipo      = "I"
    Gn-ConVt.FlagUsuario   = s-user-id.
ELSE ASSIGN
    Gn-ConVt.FlagFecha = STRING(DATETIME(TODAY, MTIME), "99/99/9999 HH:MM:SS")
    Gn-ConVt.FlagMigracion = "N"
    Gn-ConVt.FlagTipo      = "U"
    Gn-ConVt.FlagUsuario   = s-user-id.
