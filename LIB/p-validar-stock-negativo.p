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

DEFINE INPUT PARAMETER pAlmacen AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pUsuario AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pRetorno AS INT NO-UNDO.

DEFINE VAR cTabla AS CHAR NO-UNDO.
DEFINE VAR cLlave_c1 AS CHAR NO-UNDO.
DEFINE VAR cLlave_c2 AS CHAR NO-UNDO.
DEFINE VAR cLlave_c3 AS CHAR NO-UNDO.
DEFINE VAR cLlave_c4 AS CHAR NO-UNDO.
DEFINE VAR cLlave_c5 AS CHAR NO-UNDO.

cTabla = 'CONFIG-VLD'.
cLlave_c1 = "NOVALIDAR".
cLlave_c2 = "STOCK".
cLlave_c3 = "NEGATIVO".

cLlave_c4 = pAlmacen.
cLlave_c5 = pUsuario.


pRetorno = 1.       /* Si validar stock negativo */

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


FIND FIRST vtatabla WHERE vtatabla.codcia = 1 AND 
                            vtatabla.tabla = cTabla AND
                            vtatabla.llave_c1 = cLlave_c1 AND 
                            vtatabla.llave_c2 = cLlave_c2 AND
                            vtatabla.llave_c3 = cLlave_c3 AND
                            vtatabla.llave_c4 = cLlave_c4 AND
                            vtatabla.llave_c5 = cLlave_c5 NO-LOCK NO-ERROR.

IF NOT AVAILABLE vtatabla THEN RETURN "OK".

DEFINE VAR dDate AS DATE.

dDate = TODAY.

IF (dDate >= vtatabla.rango_fecha[1] AND dDate <= vtatabla.rango_fecha[2]) THEN DO:
    pRetorno = 0.
END.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


