output to c:\texto.txt.
for each almmmatg where codcia = 1 and CodBrr <> "" :
export delimiter "|" codmat codbrr undbas unda undb undc desmat desmar.
end.
output close.
/*
Nota:
Luego de generar el texto hay que crear el DBF cone l nombre barras.dbf y debe de tener la
siguiente estructura:
CODMAT  CHAR 6 
BARRA   CHAR 15
UNIBAS  CHAR 8
UNI1    CHAR 8 
UNI2    CHAR 8 
UNI3    CHAR 8
DES1    CHAR 45
DES2    CHAR 20
y posteriormente importar el texto generado
*/
