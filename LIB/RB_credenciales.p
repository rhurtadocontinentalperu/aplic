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
DEFINE OUTPUT PARAMETER p-User AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p-Pass AS CHARACTER NO-UNDO.

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


p-User = "**NOUSER**".
p-Pass = "**NOPASS**".

DEFINE VAR x-codcia AS INT.
DEFINE VAR x-tabla AS CHAR.
DEFINE VAR x-llave_c1 AS CHAR.
DEFINE VAR x-llave_c2 AS CHAR.

x-codcia = 1.
x-tabla = "CONFIG-SESSION".
x-llave_c1 = "REPORTBUILDER".
x-llave_c2 = "CREDENCIALES".

FIND FIRST vtatabla WHERE vtatabla.codcia = x-codcia AND
                            vtatabla.tabla = x-tabla AND
                            vtatabla.llave_c1 = x-llave_c1 AND 
                            vtatabla.llave_c2 = x-llave_c2 NO-LOCK NO-ERROR.
IF AVAILABLE vtatabla THEN DO:
    p-User = TRIM(vtatabla.libre_c01).
    p-Pass = TRIM(vtatabla.libre_c02).
END.

/* -- */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


