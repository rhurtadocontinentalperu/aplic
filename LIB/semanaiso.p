&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description : La primera semana del año es la que contiene el primer jueves del año

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pFecha AS DATE.
DEF OUTPUT PARAMETER pSemana AS INT.
DEF OUTPUT PARAMETER pAno AS INT.

DEF VAR xDia AS INT.
DEF VAR xMes AS INT.
DEF VAR xAno AS INT.
DEF VAR xA AS INT.
DEF VAR xB AS INT.
DEF VAR xC AS INT.
DEF VAR xD AS INT.
DEF VAR xS AS INT.
DEF VAR xE AS INT.
DEF VAR xF AS INT.
DEF VAR xG AS INT.
DEF VAR xN AS INT.
DEF VAR xSemana AS INT.

ASSIGN
    xDia = DAY(pFecha)
    xMes = MONTH(pFecha)
    xAno = YEAR(pFecha).

IF xMes = 01 OR xMes = 02 THEN DO:  /* Enero o Febrero */
    ASSIGN
        xA = xAno - 1
        xB = TRUNCATE(xA / 4, 0) - TRUNCATE(xA / 100, 0) + TRUNCATE(xA / 400, 0)
        xC = TRUNCATE( (xA - 1) / 4, 0) - TRUNCATE( (xA - 1) / 100, 0) + TRUNCATE( (xA - 1) / 400, 0)
        xS = xB - xC
        xE = 0
        xF = xDia - 1 + (31 * (xMes - 1) ).
END.
ELSE DO:    /* de Marzo a Diciembre */
    ASSIGN
        xA = xAno
        xB = TRUNCATE(xA / 4, 0 ) - TRUNCATE(xA / 100, 0) + TRUNCATE(xA / 400, 0)
        xC = TRUNCATE( (xA - 1) / 4, 0 ) - TRUNCATE( (xA - 1) / 100, 0) + TRUNCATE( (xA - 1) / 400, 0)
        xS = xB - xC
        xE = xS + 1
        xF = xDia + TRUNCATE( ( ( 153 * (xMes - 3) ) + 2 ) / 5, 0) + 58 + xS.
END.
/* Adicionalmente sumándole 1 a la variable xF 
    se obtiene numero ordinal del dia de la fecha ingresada con referencia al año actual
    */
/* Estos cálculos se aplican a cualquier mes */
ASSIGN
    xG = (xA + xB) MODULO 7
    xD = (xF + xG - xE) MODULO 7 /* Adicionalmente esta variable nos indica el dia de la semana 0=Lunes, ... , 6=Domingo */
    xN = xF + 3 - xD.
IF xN < 0 THEN DO:
    /* Si la variable n es menor a 0 se trata de una semana perteneciente al año anterior */
    ASSIGN
        xSemana = 53 - TRUNCATE( (xG - xS) / 5, 0)
        xAno = xAno - 1.
END.
ELSE IF xN > (364 + xS) THEN DO:
    /* Si n es mayor a 364 + $s entonces la fecha corresponde a la primera semana del año siguiente.*/
    ASSIGN
        xSemana = 1
        xAno = xAno + 1.
END.
ELSE DO:
    /* En cualquier otro caso es una semana del año actual */
    xSemana = TRUNCATE(xN / 7, 0) + 1.
END.

ASSIGN
    pAno = xAno
    pSemana = xSemana.

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
         HEIGHT             = 4.19
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


