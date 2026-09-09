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

DEF INPUT PARAMETER pcNombre AS CHAR NO-UNDO.
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
         HEIGHT             = 3.96
         WIDTH              = 54.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE cNombreTrim AS CHARACTER NO-UNDO.
DEFINE VARIABLE iLoop       AS INTEGER   NO-UNDO.
DEFINE VARIABLE cChar       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lHasLetters AS LOGICAL   NO-UNDO.

ASSIGN cNombreTrim = TRIM(pcNombre). /* Elimina espacios al inicio y al final */

/* Regla 1: El nombre no debe estar vacío o ser solo espacios */
IF LENGTH(cNombreTrim) = 0 THEN DO:
    pcMessage = "El nombre no puede estar vacío.".
    RETURN.
END.

/* Regla 2: Longitud mínima (opcional, ajusta según tus necesidades) */
IF LENGTH(cNombreTrim) < 2 THEN DO:
    pcMessage = "El nombre es demasiado corto.".
    RETURN.
END.

/* Regla 3: Verificar caracteres válidos y presencia de letras */
/* Permite letras (a-z, A-Z), espacios, apóstrofes y guiones. */
/* Puedes extender esta lista para incluir caracteres acentuados (ej: "áéíóúüñÁÉÍÓÚÜÑ")
   dependiendo del codepage de tu base de datos y la naturaleza de tus nombres. */
DO iLoop = 1 TO LENGTH(cNombreTrim):
    cChar = SUBSTRING(cNombreTrim, iLoop, 1).
    IF ( (ASC(cChar) >= 65 AND ASC(cChar) <= 90) OR (ASC(cChar) >= 97 AND ASC(cChar) <= 122) OR ASC(cChar) = 32 ) OR
       /* Letras minúsculas, mayúsculas y espacio en blanco */
       INDEX("áéíóúüñÁÉÍÓÚÜÑ",cChar) > 0 OR    /* Especiales */
       INDEX("1234567890",cChar) > 0 OR         /* Números */
       cChar = "'" OR               /* Apóstrofes (ej: O'Malley) */
       cChar = "-" OR               /* Guiones (ej: Smith-Jones) */
       cChar = "." THEN             /* Ej. Libreria S.A.C. */
     DO:
        IF ( (ASC(cChar) >= 65 AND ASC(cChar) <= 90) OR (ASC(cChar) >= 97 AND ASC(cChar) <= 122) )
            THEN lHasLetters = TRUE.
        /* Carácter válido, no hacer nada especial */
    END.
    ELSE DO:
        pcMessage = "El nombre contiene un carácter inválido: '" + cChar + "'.".
        RETURN.
    END.
END.

/* Regla 4: Debe contener al menos una letra */
IF NOT lHasLetters THEN DO:
    pcMessage = "El nombre debe contener al menos una letra.".
    RETURN.
END.

/* Regla 5: No debe tener números o símbolos excesivos (ya cubierto por Regla 3 en este ejemplo, pero importante de considerar si usas regex) */
/* Si quisieras permitir algunos números (ej: "John Doe Jr. III"), deberías modificar Regla 3 y añadir lógica adicional. */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


