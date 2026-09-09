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

DEF INPUT PARAMETER pcDireccion AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pcMessage AS CHAR NO-UNDO.

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
         HEIGHT             = 5.85
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE cDireccionTrim AS CHARACTER NO-UNDO.
DEFINE VARIABLE lHasNumbers    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lHasLetters    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE iLoop          AS INTEGER   NO-UNDO.
DEFINE VARIABLE cChar          AS CHARACTER NO-UNDO.

ASSIGN cDireccionTrim = TRIM(pcDireccion). /* Elimina espacios al inicio y al final */

/* Regla 1: La dirección no debe estar vacía o ser solo espacios */
IF LENGTH(cDireccionTrim) = 0 THEN DO:
    pcMessage = "La dirección no puede estar vacía.".
    RETURN.
END.

/* Regla 2: Longitud mínima (ajusta según la longitud típica de tus direcciones) */
IF LENGTH(cDireccionTrim) < 5 THEN DO:
    pcMessage = "La dirección es demasiado corta.".
    RETURN.
END.

/* Regla 3: Debe contener letras y números (generalmente una dirección tiene nombre de calle y número) */
DO iLoop = 1 TO LENGTH(cDireccionTrim):
    cChar = SUBSTRING(cDireccionTrim, iLoop, 1).
    /*IF cChar MATCHES "[0-9]" THEN lHasNumbers = TRUE.*/
    IF INDEX("1234567890",cChar) > 0 THEN lHasNumbers = TRUE.
    /*IF cChar MATCHES "[A-Za-z]" THEN lHasLetters = TRUE.*/
    IF ( ( ASC(cChar) >= 65 AND ASC(cChar) <= 90 )
         OR ( ASC(cChar) >= 97 AND ASC(cChar) <= 122 )
         OR INDEX("áéíóúüñÁÉÍÓÚÜÑ",cChar) > 0 
         ) THEN lHasLetters = TRUE.
END.

IF NOT lHasNumbers OR NOT lHasLetters THEN DO:
    pcMessage = "La dirección debe contener letras y números (ej. 'Calle Falsa 123').".
    RETURN.
END.

/* Regla 4: Verificar la presencia de caracteres comúnmente usados y evitar símbolos extraños */
/* Permite letras, números, espacios, comas, puntos, guiones y el símbolo #. */
/* Ajusta según los caracteres permitidos en las direcciones de tu región. */
DO iLoop = 1 TO LENGTH(cDireccionTrim):
    cChar = SUBSTRING(cDireccionTrim, iLoop, 1).
    IF NOT ( 
        INDEX("1234567890áéíóúüñÁÉÍÓÚÜÑ ",cChar) > 0 OR /* Letras, números, espacios */
        ( ASC(cChar) >= 65 AND ASC(cChar) <= 90 )
        OR ( ASC(cChar) >= 97 AND ASC(cChar) <= 122 ) OR
        cChar = "," OR               /* Coma */
        cChar = "." OR               /* Punto */
        cChar = "-" OR               /* Guion */
        cChar = "#"                  /* Símbolo de número/apartamento */
        ) THEN DO:
        pcMessage = "La dirección contiene un carácter inválido: '" + cChar + "'.".
        RETURN.
    END.
/*     IF NOT (cChar MATCHES "[A-Za-z0-9 ]" OR /* Letras, números, espacios */                             */
/*             cChar = "," OR               /* Coma */                                                     */
/*             cChar = "." OR               /* Punto */                                                    */
/*             cChar = "-" OR               /* Guion */                                                    */
/*             cChar = "#"                  /* Símbolo de número/apartamento */                            */
/*            ) THEN DO:                                                                                   */
/*         pcMessage = "La dirección contiene un carácter inválido: '" + cChar + "'." VIEW-AS ALERT-BOX ERROR. */
/*         RETURN FALSE.                                                                                   */
/*     END.                                                                                                */
END.

/* Regla 5: Evitar secuencias obvias de caracteres inválidos (ej: "---" o "...") */
IF INDEX(cDireccionTrim, "..") > 0 OR
   INDEX(cDireccionTrim, "--") > 0 OR
   INDEX(cDireccionTrim, "  ") > 0 THEN DO: /* Doble espacio */
    pcMessage = "La dirección contiene secuencias de caracteres inválidos (ej. '..', '--', espacios dobles).".
    RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


