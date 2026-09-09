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

DEF INPUT   PARAMETER pcEmail       AS CHAR NO-UNDO.
DEF OUTPUT  PARAMETER pcMessage     AS CHAR NO-UNDO.

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
         HEIGHT             = 4.31
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

    DEFINE VARIABLE cEmail       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iAtPos       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iDotPos      AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iLastDotPos  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cDomain      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cTLD         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lValid       AS LOGICAL   NO-UNDO.

    ASSIGN lValid = TRUE.
    ASSIGN cEmail = TRIM(pcEmail). /* Remove leading/trailing spaces */

    /* Rule 1: Email should not be empty */
    IF LENGTH(cEmail) = 0 THEN DO:
        pcMessage = "El correo electrónico no puede estar vacío".
        RETURN.
    END.

    /* Rule 2: Must contain exactly one '@' symbol */
    iAtPos = INDEX(cEmail, "@").
    IF iAtPos = 0 THEN DO:
        pcMessage = "El correo electrónico debe contener un símbolo '@'".
        RETURN.
    END.

    IF INDEX(cEmail, "@", iAtPos + 1) > 0 THEN DO:
        pcMessage = "El correo electrónico no puede contener más de un símbolo '@'".
        RETURN.
    END.

    /* Rule 3: '@' cannot be the first or last character */
    IF iAtPos = 1 OR iAtPos = LENGTH(cEmail) THEN DO:
        pcMessage = "El símbolo '@' no puede estar al inicio ni al final del correo electrónico".
        RETURN.
    END.

    /* Rule 4: Must contain at least one '.' after '@' */
    iDotPos = INDEX(cEmail, ".", iAtPos).
    IF iDotPos = 0 THEN DO:
        pcMessage = "El correo electrónico debe contener al menos un '.' después del '@'".
        RETURN.
    END.

    /* Rule 5: No consecutive dots ".." */
    IF INDEX(cEmail, "..") > 0 THEN DO:
        pcMessage = "El correo electrónico no puede contener puntos consecutivos (..)".
        RETURN.
    END.

    /* Rule 6: Get domain and check TLD length */
    cDomain = SUBSTRING(cEmail, iAtPos + 1).
    iLastDotPos = R-INDEX(cDomain, "."). /* Find the last dot in the domain */

    IF iLastDotPos = 0 OR iLastDotPos = LENGTH(cDomain) THEN DO:
        pcMessage = "Formato de dominio inválido".
        RETURN.
    END.

    cTLD = SUBSTRING(cDomain, iLastDotPos + 1).
    IF LENGTH(cTLD) < 2 THEN DO:
        pcMessage = "El dominio de nivel superior (TLD) es demasiado corto".
        RETURN.
    END.

    /*
     * Rule 7 (Optional/Advanced): Check for invalid characters.
     * This is very basic and doesn't cover all RFC complexities.
     * For full validation, a regex is highly recommended.
     * This simply checks for spaces or characters that are almost always invalid.
     */
    IF LOOKUP(" ", cEmail) > 0 OR
       LOOKUP(",", cEmail) > 0 OR
       LOOKUP(";", cEmail) > 0 OR
       LOOKUP(":", cEmail) > 0 OR
       LOOKUP("(", cEmail) > 0 OR
       LOOKUP(")", cEmail) > 0 OR
       LOOKUP("[", cEmail) > 0 OR
       LOOKUP("]", cEmail) > 0 OR
       LOOKUP("<", cEmail) > 0 OR
       LOOKUP(">", cEmail) > 0 THEN DO:
        pcMessage = "El correo electrónico contiene caracteres inválidos".
        RETURN.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


