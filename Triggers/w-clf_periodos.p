TRIGGER PROCEDURE FOR WRITE OF Clf_Periodos.

ASSIGN
Clf_Periodos.Descripcion = Clf_Periodos.Tipo + " " + 
STRING(Clf_Periodos.Periodo, '9999').
