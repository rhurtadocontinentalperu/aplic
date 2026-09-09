&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/*-----------------
FUNCTION _FUZZYCMP
*-----------------
* Rutina  : _FUZZYCMP
* Funcion : Compara dos strings retornando la certeza de que sean iguales */

DEF INPUT PARAMETER string1 AS CHAR.
DEF INPUT PARAMETER string2 AS CHAR.
DEF INPUT PARAMETER distancia AS INT.
DEF OUTPUT PARAMETER resultado AS DEC.

/*
DEF VAR string1 AS CHAR INIT 'hola1'.
DEF VAR string2 AS CHAR INIT 'hola2'.
DEF VAR distancia AS INT INIT 2.
DEF SHARED VAR resultado AS DEC.
*/

DEF VAR i AS INT.
DEF VAR l AS INT.
DEF VAR lista AS CHAR.
DEF VAR s AS INT.
DEF VAR cv AS INT.
DEF VAR sub AS CHAR.
DEF VAR sub1 AS INT.
DEF VAR A_ AS INT EXTENT 200.
DEF VAR B_ AS INT EXTENT 200.
DEF VAR SumAA AS INT.
DEF VAR SumBB AS INT.
DEF VAR SumAB AS INT.

resultado = 0.
IF String1 = '' OR String2 = '' THEN RETURN.
IF String1 = String2 THEN DO:
    resultado = 1.
    RETURN.
END.
String1 = ' ' + TRIM(String1).
String2 = ' ' + TRIM(String2).
lista = ''.
cv    = 0.
/*
* Calculo los n-grams del primer string
*/
i = distancia.
l = LENGTH(String1).
IF l < Distancia THEN RETURN.
DO WHILE i <= l:
   sub = SUBSTRING(String1, i - (distancia - 1), distancia).
   IF INDEX(sub, ' ') = 0 OR SUBSTRING(sub,1,1) = ' ' AND INDEX(SUBSTRING(sub,2), ' ') = 0 THEN DO:
   /*IF (.NOT. ' ' $ sub) .OR. (left(sub,1)=' ' .AND. !' ' $ SUBSTR(sub,2)) THEN DO:*/
       s = INDEX(lista, 'A_' + sub).
       IF s = 0 THEN DO:
           cv      = cv + 1.
           sub1    = cv.
           A_[Sub1] = 1.
           B_[Sub1] = 0.
           lista  = lista + 'A_' + sub + 'B_' + sub.
       END.
       ELSE DO:
           sub1    = TRUNCATE( ( (s - 1) / ((distancia + 2) * 2) ) + 1, 0).
           A_[Sub1] = A_[sub1] + 1.
       END.
   END.
   i = i + 1.
END.

/*
* Calculo los n-grams del segundo string
*/
i = distancia.
l = LENGTH(String2).
IF l < Distancia THEN RETURN.
DO WHILE i <= l:
    sub = SUBSTR(String2, i - (distancia - 1), distancia).
    IF INDEX(sub, ' ') = 0 OR SUBSTRING(sub,1,1) = ' ' AND INDEX(SUBSTRING(sub,2), ' ') = 0 THEN DO:
    /*IF (.NOT. ' ' $ M->sub) .OR. (left(sub,1)=' ' .AND. !' ' $ SUBSTR(sub,2))*/
        s = INDEX(lista, 'A_' + sub).
        IF s = 0 THEN DO:
            cv      = cv + 1.
            sub1    = cv.
            A_[Sub1] = 0.
            B_[Sub1] = 1.
            lista  = lista + 'A_' + sub + 'B_' + sub.
        END.
        ELSE DO:
            sub1    = TRUNCATE( ( (s - 1) / ((distancia + 2) * 2) ) + 1, 0).
            B_[Sub1] = B_[sub1] + 1.
        END.
    END.
    i = i + 1.
END.

/*
* Calculo la sumatoria de a*a b*b y a*b
*/
ASSIGN
    SumAA = 0
    SumBB = 0
    SumAB = 0.
i = 1.
DO WHILE i <= cv:
    sub1 = i.
    SumAA = SumAA + EXP (A_[sub1], 2).
    SumBB = SumBB + EXP (B_[sub1], 2).
    SumAB = SumAB + A_[sub1] * B_[sub1].
    i = i + 1.
END.
IF SumAA * SumBB = 0 
THEN resultado = 0.
ELSE resultado = SumAB / SQRT (SumAA * SumBB) .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


