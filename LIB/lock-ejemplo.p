DEF VAR s-codcia AS INT INIT 000.
DEF VAR x-codcli AS CHAR INIT '11111111111'.

/* &SCOPED-DEFINE Prueba gn-clie.codcia = s-codcia AND ~ */
/* gn-clie.codcli = x-codcli                             */

{lib/lock.i &Tabla="gn-clie" &Condicion="gn-clie.codcia = s-codcia AND ~
gn-clie.codcli = x-codcli"}

/*{lib/lock.i &Tabla="gn-clie" &Condicion="{&Prueba}"}*/

UPDATE gn-clie.codcli.
