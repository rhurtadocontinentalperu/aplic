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

/* Librerias

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN <libreria> PERSISTENT SET hProc.

RUN DYNAMIC-FUNCTION('<funcion_interna>' IN hProc, <par1>,<par2>,...).

DELETE PROCEDURE hProc.

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

&IF DEFINED(EXCLUDE-CapitalizarPalabras) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CapitalizarPalabras Procedure 
FUNCTION CapitalizarPalabras RETURNS CHARACTER
  ( pcCadena AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-EsDireccionValida) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD EsDireccionValida Procedure 
FUNCTION EsDireccionValida RETURNS LOGICAL
  ( pcDireccion AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-EsDNIValido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD EsDNIValido Procedure 
FUNCTION EsDNIValido RETURNS LOGICAL
  ( pcDNI AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-EsNombreValido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD EsNombreValido Procedure 
FUNCTION EsNombreValido RETURNS LOGICAL
  ( pcNombre AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-_IsNumber) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD _IsNumber Procedure 
FUNCTION _IsNumber RETURNS LOGICAL PRIVATE
  ( INPUT pNumero AS CHAR )  FORWARD.

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
         HEIGHT             = 8.04
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-CapitalizarPalabras) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CapitalizarPalabras Procedure 
FUNCTION CapitalizarPalabras RETURNS CHARACTER
  ( pcCadena AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cResultado  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iLoop       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iLongitud   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE lNuevaPalabra AS LOGICAL NO-UNDO.

    ASSIGN cResultado = "".
    ASSIGN iLongitud = LENGTH(pcCadena).
    ASSIGN lNuevaPalabra = TRUE. /* La primera letra siempre inicia una "nueva palabra" */

    DO iLoop = 1 TO iLongitud:
        IF SUBSTRING(pcCadena, iLoop, 1) = " " THEN DO:
            ASSIGN cResultado = cResultado + " ".
            ASSIGN lNuevaPalabra = TRUE.
        END.
        ELSE DO:
            IF lNuevaPalabra THEN DO:
                ASSIGN cResultado = cResultado + CAPS(SUBSTRING(pcCadena, iLoop, 1)).
                ASSIGN lNuevaPalabra = FALSE.
            END.
            ELSE DO:
                ASSIGN cResultado = cResultado + LC(SUBSTRING(pcCadena, iLoop, 1)).
            END.
        END.
    END.

    RETURN cResultado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-EsDireccionValida) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION EsDireccionValida Procedure 
FUNCTION EsDireccionValida RETURNS LOGICAL
  ( pcDireccion AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cDireccionTrim AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lHasNumbers    AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE lHasLetters    AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE iLoop          AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cChar          AS CHARACTER NO-UNDO.

    ASSIGN cDireccionTrim = TRIM(pcDireccion). /* Elimina espacios al inicio y al final */

    /* Regla 1: La dirección no debe estar vacía o ser solo espacios */
    IF LENGTH(cDireccionTrim) = 0 THEN DO:
        MESSAGE "La dirección no puede estar vacía." VIEW-AS ALERT-BOX ERROR.
        RETURN FALSE.
    END.

    /* Regla 2: Longitud mínima (ajusta según la longitud típica de tus direcciones) */
    IF LENGTH(cDireccionTrim) < 5 THEN DO:
        MESSAGE "La dirección es demasiado corta." VIEW-AS ALERT-BOX ERROR.
        RETURN FALSE.
    END.

    /* Regla 3: Debe contener letras y números (generalmente una dirección tiene nombre de calle y número) */
    DO iLoop = 1 TO LENGTH(cDireccionTrim):
/*         cChar = SUBSTRING(cDireccionTrim, iLoop, 1).         */
/*         IF cChar MATCHES "[0-9]" THEN lHasNumbers = TRUE.    */
/*         IF cChar MATCHES "[A-Za-z]" THEN lHasLetters = TRUE. */
        cChar = SUBSTRING(cDireccionTrim, iLoop, 1).
        IF INDEX("1234567890",cChar) > 0 THEN lHasNumbers = TRUE.
        IF ( ( ASC(cChar) >= 65 AND ASC(cChar) <= 90 )
             OR ( ASC(cChar) >= 97 AND ASC(cChar) <= 122 )
             OR INDEX("áéíóúüñÁÉÍÓÚÜÑ",cChar) > 0 
             ) THEN lHasLetters = TRUE.
    END.

    IF NOT lHasNumbers OR NOT lHasLetters THEN DO:
        MESSAGE "La dirección debe contener letras y números (ej. 'Calle Falsa 123')." VIEW-AS ALERT-BOX ERROR.
        RETURN FALSE.
    END.

    /* Regla 4: Verificar la presencia de caracteres comúnmente usados y evitar símbolos extraños */
    /* Permite letras, números, espacios, comas, puntos, guiones y el símbolo #. */
    /* Ajusta según los caracteres permitidos en las direcciones de tu región. */
    DO iLoop = 1 TO LENGTH(cDireccionTrim):
        cChar = SUBSTRING(cDireccionTrim, iLoop, 1).
/*         IF NOT (cChar MATCHES "[A-Za-z0-9 ]" OR /* Letras, números, espacios */                             */
/*                 cChar = "," OR               /* Coma */                                                     */
/*                 cChar = "." OR               /* Punto */                                                    */
/*                 cChar = "-" OR               /* Guion */                                                    */
/*                 cChar = "#"                  /* Símbolo de número/apartamento */                            */
/*                ) THEN DO:                                                                                   */
/*             MESSAGE "La dirección contiene un carácter inválido: '" + cChar + "'." VIEW-AS ALERT-BOX ERROR. */
/*             RETURN FALSE.                                                                                   */
/*         END.                                                                                                */
        IF NOT ( 
            INDEX("1234567890áéíóúüñÁÉÍÓÚÜÑ ",cChar) > 0 OR /* Letras, números, espacios */
            ( ASC(cChar) >= 65 AND ASC(cChar) <= 90 )
            OR ( ASC(cChar) >= 97 AND ASC(cChar) <= 122 ) OR
            cChar = "," OR               /* Coma */
            cChar = "." OR               /* Punto */
            cChar = "-" OR               /* Guion */
            cChar = "#"                  /* Símbolo de número/apartamento */
            ) THEN DO:
            MESSAGE "La dirección contiene un carácter inválido: '" + cChar + "'." VIEW-AS ALERT-BOX ERROR.
            RETURN FALSE.
        END.

    END.

    /* Regla 5: Evitar secuencias obvias de caracteres inválidos (ej: "---" o "...") */
    IF INDEX(cDireccionTrim, "..") > 0 OR
       INDEX(cDireccionTrim, "--") > 0 OR
       INDEX(cDireccionTrim, "  ") > 0 THEN DO: /* Doble espacio */
        MESSAGE "La dirección contiene secuencias de caracteres inválidos (ej. '..', '--', espacios dobles)." VIEW-AS ALERT-BOX ERROR.
        RETURN FALSE.
    END.

    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-EsDNIValido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION EsDNIValido Procedure 
FUNCTION EsDNIValido RETURNS LOGICAL
  ( pcDNI AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR dni AS CHAR NO-UNDO.
DEF VAR pValidacion AS LOG NO-UNDO.

dni = TRIM(pcDNI).

/* 1. Verificar la longitud y el formato básico */
IF NOT (LENGTH(dni) = 8 OR LENGTH(dni) = 9) THEN DO:
    MESSAGE "Verificar la longitud y el formato" VIEW-AS ALERT-BOX.
    RETURN FALSE.
END.

DEF VAR numero_dni AS CHAR NO-UNDO.
DEF VAR digito_verificador_dado AS CHAR NO-UNDO.

numero_dni = SUBSTRING(dni,1,8).
digito_verificador_dado = CAPS(SUBSTRING(dni,9)).

/* Determinamos si los 8 primeros son numéricos */
IF _IsNumber(numero_dni) = NO THEN DO:
    MESSAGE "Los 8 primeros dígitos deben ser números" VIEW-AS ALERT-BOX.
    RETURN FALSE.
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
RETURN pValidacion.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-EsNombreValido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION EsNombreValido Procedure 
FUNCTION EsNombreValido RETURNS LOGICAL
  ( pcNombre AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VARIABLE cNombreTrim AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iLoop       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cChar       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lHasLetters AS LOGICAL   NO-UNDO.

    ASSIGN cNombreTrim = TRIM(pcNombre). /* Elimina espacios al inicio y al final */

    /* Regla 1: El nombre no debe estar vacío o ser solo espacios */
    IF LENGTH(cNombreTrim) = 0 THEN DO:
        MESSAGE "El nombre no puede estar vacío." VIEW-AS ALERT-BOX ERROR.
        RETURN FALSE.
    END.

    /* Regla 2: Longitud mínima (opcional, ajusta según tus necesidades) */
    IF LENGTH(cNombreTrim) < 2 THEN DO:
        MESSAGE "El nombre es demasiado corto." VIEW-AS ALERT-BOX ERROR.
        RETURN FALSE.
    END.

    /* Regla 3: Verificar caracteres válidos y presencia de letras */
    /* Permite letras (a-z, A-Z), espacios, apóstrofes y guiones. */
    /* Puedes extender esta lista para incluir caracteres acentuados (ej: "áéíóúüñÁÉÍÓÚÜÑ")
       dependiendo del codepage de tu base de datos y la naturaleza de tus nombres. */
    DO iLoop = 1 TO LENGTH(cNombreTrim):
        cChar = SUBSTRING(cNombreTrim, iLoop, 1).
/*         IF cChar MATCHES "[A-Za-z ]" OR /* Letras y espacios */         */
/*            cChar = "'" OR               /* Apóstrofes (ej: O'Malley) */ */
/*            cChar = "-" THEN             /* Guiones (ej: Smith-Jones) */ */
/*         DO:                                                             */
        IF ( ( ASC(cChar) >= 65 AND ASC(cChar) <= 90) OR 
             (ASC(cChar) >= 97 AND ASC(cChar) <= 122 ) OR 
             ASC(cChar) = 32 ) OR
            /* Letras minúsculas, mayúsculas y espacio en blanco */
            INDEX("áéíóúüñÁÉÍÓÚÜÑ",cChar) > 0 OR    /* Especiales */
            INDEX("1234567890",cChar) > 0 OR         /* Números */
            cChar = "'" OR               /* Apóstrofes (ej: O'Malley) */
            cChar = "-" OR               /* Guiones (ej: Smith-Jones) */
            cChar = "." THEN             /* Ej. Libreria S.A.C. */
            DO:
/*             IF cChar MATCHES "[A-Za-z]" THEN lHasLetters = TRUE. */
            IF ( (ASC(cChar) >= 65 AND ASC(cChar) <= 90) OR (ASC(cChar) >= 97 AND ASC(cChar) <= 122) )
                THEN lHasLetters = TRUE.
            /* Carácter válido, no hacer nada especial */
        END.

        ELSE DO:
            MESSAGE "El nombre contiene un carácter inválido: '" + cChar + "'." VIEW-AS ALERT-BOX ERROR.
            RETURN FALSE.
        END.
    END.

    /* Regla 4: Debe contener al menos una letra */
    IF NOT lHasLetters THEN DO:
        MESSAGE "El nombre debe contener al menos una letra." VIEW-AS ALERT-BOX ERROR.
        RETURN FALSE.
    END.

    /* Regla 5: No debe tener números o símbolos excesivos (ya cubierto por Regla 3 en este ejemplo, 
    pero importante de considerar si usas regex) */
    /* Si quisieras permitir algunos números (ej: "John Doe Jr. III"), 
    deberías modificar Regla 3 y añadir lógica adicional. */

    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-_IsNumber) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION _IsNumber Procedure 
FUNCTION _IsNumber RETURNS LOGICAL PRIVATE
  ( INPUT pNumero AS CHAR ) :
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

