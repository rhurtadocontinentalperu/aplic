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

DEFINE INPUT  PARAMETER ckamt    AS DECIMAL FORMAT ">>>,>>>,>>9.99" INIT
999999999.99.
DEFINE OUTPUT PARAMETER textamt1 AS CHARACTER FORMAT "x(60)".
DEFINE OUTPUT PARAMETER textamt2 AS CHARACTER FORMAT "x(60)".

DEFINE VARIABLE txtHUNDREDS as CHARACTER EXTENT 4 initial
     [ "billion",  "million",  "thousand", "hundred"].
DEFINE VARIABLE numHUNDREDS as INTEGER   EXTENT 4 initial
     [ 1000000000, 1000000,    1000,       1].
DEFINE VARIABLE txtTENS     as CHARACTER EXTENT 10 initial
     [ "",         "",         "twenty",   "thirty",   "forty",
    "fIFty",    "sixty",    "seventy",  "eighty",   "ninety"].
DEFINE VARIABLE txtUNITS    as CHARACTER EXTENT 20 initial
    [ "zero",     "one",      "two",      "three",    "four",
    "five",     "six",      "seven",    "eight",    "nine",
    "ten",      "eleven",   "twelve",   "thirteen", "fourteen",
    "fIFteen",  "sixteen",  "seventeen","eighteen", "nineteen"].
DEFINE VARIABLE RESULT as CHARACTER FORMAT "x(76)".

DEFINE VARIABLE NUMBER as decimal FORMAT "->,>>>,>>>,>>9.99".
DEFINE VARIABLE CENTS  as INTEGER.
DEFINE VARIABLE i      as INTEGER.
DEFINE VARIABLE x      as INTEGER.
DEFINE VARIABLE h      as INTEGER.
DEFINE VARIABLE t      as INTEGER.
DEFINE VARIABLE u      as INTEGER.

number = ckamt.
result = "*** ".
IF number < 0 THEN DO:
   result = result + "minus ".
   number = - number.
END.

cents = (number - TRUNCATE(number, 0)) * 100.
number = TRUNCATE(number, 0).

IF number = 0 THEN DO:
   result = result + txtUNITS[1] + " ".
END.
DO i = 1 TO 4:
    x = TRUNCATE(number / numHUNDREDS[i], 0).
    IF x = 0 THEN DO:
        number = number MOD numHUNDREDS[i].
        next.
    END.
    h = TRUNCATE(x / 100, 0).
    x = x MOD 100.
    t = TRUNCATE(x / 10, 0).
    u = x MOD 10.
    IF t = 1 THEN DO:
        u = u + 10.
        t = 0.
    END.
    IF h > 0 THEN DO:
        result = result + txtUNITS[h + 1] + " " + txtHUNDREDS[4] + " ".
    END.
    IF t > 0 THEN DO:
        result = result + txtTENS[t + 1].
        IF u > 0 THEN
            result = result + "-".
        ELSE
            result = result + " ".
        END.
    IF u > 0 THEN DO:
        result = result + txtUNITS[u + 1] + " ".
    END.
    IF i < 4 THEN DO:
        result = result + txtHUNDREDS[i] + " ".
    END.
    number = number MOD numHUNDREDS[i].
END.
result = result + "dollars and ".
IF cents = 0 THEN
    result = result + "no".
ELSE
    result = result + string(cents, "99").
result = result + " cents***".


/*  If the line is longer than 60 CHARACTERs, break it
    into two evenly-sized lines, on a word boundary.  */
IF LENGTH(result) > 60 THEN DO:
/*    do i = TRUNCATE(LENGTH(result) / 2, 0) to 1 by -1
 *      while SUBSTRING(result, i, 1) <> " ".
 *      END.
 *     textamt1 = SUBSTRING(result, 1, i - 1).
 *     textamt2 = SUBSTRING(result, i + 1).
 *     END.*/
  
    textamt1 = SUBSTRING(result,1,60).
    i = 60.
    REPEAT WHILE SUBSTRING(result,i,1) <> " ":
      i = i - 1.
    END.
    textamt1 = SUBSTRING(result,1,i).
    textamt2 = "********** " + SUBSTRING(result,i + 1,(LENGTH(result))).
END.
ELSE DO:
    textamt1 = result.
    textamt2 = "".
END.
SUBSTRING(textamt1,5,1) = CAPS(SUBSTRING(textamt1,5,1)).

/*display textamt1 label "Result1" textamt2 label "Result2". */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


