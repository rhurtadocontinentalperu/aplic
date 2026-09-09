&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Validar el # de DNI Peruano

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER dni AS CHAR.
DEF OUTPUT PARAMETER pValidacion AS LOG.
DEF OUTPUT PARAMETER pMensaje AS CHAR.

/* pValidacion:
    TRUE: correcto
    FALSE: incorrecto
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-_IsNumber) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD _IsNumber Procedure 
FUNCTION _IsNumber RETURNS LOGICAL
  ( INPUT pNumero AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 7
         WIDTH              = 57.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/*
Valida un número de DNI peruano.

    Args:
        dni (str): El número de DNI a validar.

    Returns:
        bool: True si el DNI es válido, False en caso contrario.
*/
        
dni = TRIM(dni).

/* 1. Verificar la longitud y el formato básico */
IF NOT (LENGTH(dni) = 8 OR LENGTH(dni) = 9) THEN DO:
    pValidacion = FALSE.
    pMensaje = "Verificar la longitud y el formato".
    RETURN.
END.

DEF VAR numero_dni AS CHAR NO-UNDO.
DEF VAR digito_verificador_dado AS CHAR NO-UNDO.

numero_dni = SUBSTRING(dni,1,8).
digito_verificador_dado = CAPS(SUBSTRING(dni,9)).

/* Determinamos si los 8 primeros son numéricos */
IF _IsNumber(numero_dni) = NO THEN DO:
    pValidacion = FALSE.
    pMensaje = "Los 8 primeros dígitos deben ser números".
    RETURN.
END.
/* Convertir los 8 dígitos a una lista de enteros */
DEF VAR numeros AS CHAR NO-UNDO.
DEF VAR k AS INTE NO-UNDO.
DO k = 1 TO 8:
    numeros = numeros +
        (IF TRUE <> (numeros > "") THEN "" ELSE ",") +
        SUBSTRING(numero_dni,k,1).
END.
 
/* 2. Algoritmo de cálculo del dígito verificador
        Factores de multiplicación
*/        
DEF VAR factores AS CHAR INIT "3,2,7,6,5,4,3,2" NO-UNDO.
DEF VAR suma AS INTE NO-UNDO.
DO k = 1 TO 8:
    suma = suma + ( INTEGER(ENTRY(k,numeros)) * INTEGER(ENTRY(k,factores))).
END.

DEF VAR resto AS INTE NO-UNDO.
resto = suma MODULO 11.

DEF VAR digito_calculado_index AS INTE NO-UNDO.
digito_calculado_index = 11 - resto.

/* Mapeo de índices a dígitos/letras verificadores
   Para DNI modernos (dígito numérico)
*/
DEF VAR digitos_verificadores_numericos AS CHAR NO-UNDO.
digitos_verificadores_numericos = "6,7,8,9,0,1,1,2,3,4,5".

/* Para DNI antiguos (letra) - emitidos antes de 2007 para mayores de 60 años */
DEF VAR letras_verificadoras AS CHAR NO-UNDO.
letras_verificadoras = "K,A,B,C,D,E,F,G,H,I,J".

/* Si el índice es 11, el dígito verificador es 0 (según algunas implementaciones) */
DEF VAR digito_calculado AS INTE NO-UNDO.

IF digito_calculado_index = 11 THEN digito_calculado = 0.
ELSE digito_calculado = INTEGER(ENTRY(digito_calculado_index + 1, digitos_verificadores_numericos)).

/* Comparar el dígito verificador calculado con el dígito dado */
IF _isNumber(digito_verificador_dado) = YES THEN DO:
    /* Es un número */
    pValidacion = ( INTEGER(digito_verificador_dado) = digito_calculado ).
END.
ELSE DO:
    /* Es un caracter */
    IF LENGTH(digito_verificador_dado) = 1 THEN DO:
        /* Si el dígito dado es una letra (para DNI antiguos)
            Se verifica si el número de DNI original está dentro de un rango
            que pudiera haber sido emitido con letra verificadora.
            Por simplicidad, aquí solo comprobamos si la letra calculada coincide.
            En la práctica, los DNI con letra suelen tener un número específico
            de inicio (ej. 0xxxxxxx, 1xxxxxxx)
        */
        IF digito_calculado_index < LENGTH(letras_verificadoras)
            THEN pValidacion = ( ENTRY(digito_calculado_index + 1, letras_verificadoras) = digito_verificador_dado ).
            ELSE pValidacion = FALSE.
    END.
    ELSE pValidacion = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-_IsNumber) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION _IsNumber Procedure 
FUNCTION _IsNumber RETURNS LOGICAL
  ( INPUT pNumero AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR cChar AS CHAR NO-UNDO.
  DEF VAR iChar AS INTE NO-UNDO.
  DEF VAR iAsc AS INTE NO-UNDO.

  DO iChar = 1 TO LENGTH(pNumero):
      cChar = SUBSTRING(pNumero,iChar,1).
      iAsc = ASC(cChar).
      IF NOT (iAsc > 47 AND iAsc < 58) THEN RETURN FALSE.
  END.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

