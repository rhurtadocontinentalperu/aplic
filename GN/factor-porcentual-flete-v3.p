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
    Notes       : Factor Gerencia General
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

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
         HEIGHT             = 5.04
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE INPUT PARAMETER pListaPrecio AS CHAR.
DEFINE INPUT PARAMETER x-codmat AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER pFlete AS DEC.
DEFINE INPUT PARAMETER x-tpoped AS CHAR.    /* Tipo de Pedido */
DEFINE INPUT PARAMETER pf-factor AS DEC.
DEFINE INPUT PARAMETER ps-codmon AS INT.
/* Nuevo parámetro */
DEFINE INPUT PARAMETER pPreUni AS DECI.

DEFINE SHARED VAR s-codcia AS INT.

DEFINE VAR x-factor-porcentual-flete AS DEC INIT 0.

/* Validación */
IF pFlete <= 0 THEN RETURN.

DEFINE BUFFER x-almmmatg FOR almmmatg.
DEFINE BUFFER x-vtatabla FOR vtatabla.

DEFINE VAR SW-LOG1 AS LOG.
DEFINE VAR x-precio AS DEC.
DEFINE VAR x-factor AS DEC INIT 0.
DEFINE VAR x-calc-fac AS DEC INIT 0.
DEFINE VAR x-prevta1 AS DEC INIT 0.
DEFINE VAR x-prevta2 AS DEC INIT 0.
DEFINE VAR x-prevta AS DEC INIT 0.

FIND FIRST x-almmmatg WHERE x-almmmatg.codcia = s-codcia AND 
    x-almmmatg.codmat = x-codmat NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-almmmatg THEN RETURN.

/* Chequear si la familia entra a la formula de factor (1.5%) */
FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
    x-vtatabla.tabla = 'FACTORPORFLETE' AND
    x-vtatabla.llave_c1 = pListaPrecio AND
    x-vtatabla.llave_c2 = x-almmmatg.codfam NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-vtatabla THEN DO:
    /* Si no esta se le cobra Flete */    
    RETURN.
END.
x-factor-porcentual-flete = x-vtatabla.valor[1]. /* 1.5% */
/* 10/01/2023 El precio y el factor viene como parámetro */
IF pPreUni > 0 THEN DO:
    x-calc-fac = (pFlete / pPreUni) * 100.
    /* Si es menor , flete = 0 */
    IF x-calc-fac < x-factor-porcentual-flete  THEN pFlete = 0.
END.         

RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


