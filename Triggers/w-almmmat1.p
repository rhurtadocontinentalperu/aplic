TRIGGER PROCEDURE FOR WRITE OF almmmat1.

DEFINE SHARED VAR s-user-id AS CHAR.

FIND FIRST Almmmatg OF Almmmat1 EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
IF AVAILABLE Almmmatg THEN Almmmatg.Libre_d05 = 1.
IF AVAILABLE(Almmmatg) THEN RELEASE Almmmatg.


/* 07/02/2024: Optimiza la búsqueda */
/* DEF VAR cLlave AS CHAR NO-UNDO.             */
/* DEF VAR iItem AS INTE NO-UNDO.              */
/*                                             */
/* cLlave = ''.                                */
/* DO iItem = 1 TO 10:                         */
/*     cLLave = cLlave +                       */
/*         (IF cLlave > '' THEN '|' ELSE '') + */
/*         TRIM(Almmmat1.Barras[iItem]).       */
/* END.                                        */
/* almmmat1.Llave = cLlave.                    */
