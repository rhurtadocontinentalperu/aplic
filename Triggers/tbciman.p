
TRIGGER PROCEDURE FOR WRITE OF tbciman.

ASSIGN tbciman.observacion = "Escrito a las " + STRING(NOW,"99/99/9999 HH:MM:SS").

