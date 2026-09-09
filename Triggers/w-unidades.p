TRIGGER PROCEDURE FOR WRITE OF Unidades.

DEF SHARED VAR s-user-id AS CHAR.

ASSIGN
    Unidades.Usuario = s-user-id
    Unidades.Fecha   = DATETIME(TODAY,MTIME).
