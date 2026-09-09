&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Informacion de SUNAT

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER v-email AS CHARACTER.
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

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
         HEIGHT             = 4.23
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
define variable nChar as integer.
define variable v-length as integer.
define variable v-left as character format "x(250)" no-undo .
define variable v-right as character format "x(250)" no-undo .
define variable v-at as integer.
define variable v-dot as integer.

v-email = trim(v-email).
v-length = length(v-email).
if v-length < 5 then /* Minimal acceptable email: X@X.X */
DO:
    pError = "El correo no debe tener menos de 5 caracteres".
    RETURN.
END.

v-at = index(v-email, "@").
v-left = substring (v-email, 1, (v-at - 1)).
v-right = substring(v-email, (v-at + 1), (v-length - (v-at ))).
v-dot = index(v-right,".").
    
/* Ic - Validacion */
IF LENGTH(v-left) >= 1 THEN DO:
    if index("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_" , caps(substring(v-left,LENGTH(v-left),1))) = 0 THEN do:
        pError = "Caracter no válido en el correo".
        RETURN.
    end.
END.
IF LENGTH(v-right) >= 1 THEN DO:
    if index("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_" , caps(substring(v-right,LENGTH(v-right),1))) = 0 THEN do:
        pError = "Caracter no válido en el correo".
        RETURN.
    end.
END.
/* Ic - Fin */
if v-at = 0 or v-dot = 0 or length(v-left) = 0 or length(v-right) = 0 THEN do:
    pError = "Correo mal registrado".
    RETURN.
end.

do nChar = 1 to length(v-left) :
    if index("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.-_" , caps(substring(v-left,nChar,1))) = 0 THEN do:
        pError = "Caracter no válido en el correo".
        RETURN.
    end.
end.

nChar = 0.
do nChar = 1 to length(v-right) :
    if index("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.-" , caps(substring(v-right,nChar,1))) = 0 THEN DO: 
        pError = "Caracter no válido en el correo".
        RETURN.
    end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


