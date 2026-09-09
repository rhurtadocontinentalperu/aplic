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

DEFINE INPUT PARAMETER pCadena AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pDigVeri AS INT NO-UNDO.

DEFINE VAR tnBaseMas AS INT.
DEFINE VAR lcNumeroAl AS CHAR.
DEFINE VAR liSec AS INT.
DEFINE VAR lcCaracter AS CHAR.
DEFINE VAR liK AS INT.
DEFINE VAR lnTotal AS INT.
DEFINE VAR lnNumeroAux AS INT.
DEFINE VAR lnResto AS INT.
DEFINE VAR lnDigito AS INT.
DEFINE VAR tnBasemax AS INT.

DEFINE VAR lFiler AS INT.

pDigVeri = 0.
pCadena = TRIM(pCadena).
tnBasemax = LENGTH(pCadena).

lcNumeroAl = "".
DO liSec = 1 TO LENGTH(pCadena):
    lcCaracter = CAPS(SUBSTRING(pCadena,liSec,1)).
    lFiler = ASC(lcCaracter).
    IF lFiler >= 48 AND lFiler <= 57 THEN DO:
        lcNumeroAl = lcNumeroAl + lcCaracter.
    END.
    ELSE DO:
        lcNumeroAl = lcNumeroAl + STRING(lFiler).
    END.
END.

liK = 2.
lnTotal = 0.

DO liSec = LENGTH(lcNumeroAl) TO 1 BY -1:
    IF liK > tnBasemax THEN DO:
        liK = 2.
    END.
    lnNumeroAux = INTEGER(SUBSTRING(lcNumeroAl,liSec,1)).
    lnTotal = lnTotal + (lnNumeroAux * liK).
    liK = liK + 1.
END.

lnResto = lnTotal MODULO 11.

IF lnResto > 0 THEN DO:
    lnDigito = 11 - lnResto.
END.
ELSE DO:
    lnDigito = 0.
END.

pDigVeri = lnDigito.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


