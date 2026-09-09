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

/* ICBPER */
DEFINE VAR x-articulo-ICBPER AS CHAR.

x-articulo-ICBPER = '099268'.

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
         HEIGHT             = 4.81
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* EL PROGRAMA DEVUELVE LA CANTIDAD SUGERIDA DE ACUERDO AL EMPAQUE      
Si existe el INNER lo redondea y devuelve ese valor (FIN)
Si existe el MASTER lo redondea y devuelve ese valor (FIN)
Si no hay ni master ni inner lo deja como está
******************************************************************** */

DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCanPed AS DEC.
DEF OUTPUT PARAMETER pSugerido AS DEC.
DEF OUTPUT PARAMETER pEmpaque AS DEC.

pSugerido = pCanPed.            /* Valor por Defecto */

DEF SHARED VAR s-codcia AS INT.

DEF VAR f-CanFinal AS DEC NO-UNDO.
DEF VAR f-MinimoVentas AS DEC NO-UNDO.

DEF BUFFER B-DIVI FOR gn-divi.
DEF BUFFER B-MATG FOR Almmmatg.

FIND FIRST B-MATG WHERE B-MATG.codcia = s-codcia AND B-MATG.codmat = pCodMat NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-MATG THEN RETURN.

IF x-articulo-ICBPER = pCodMat THEN RETURN.

EMPAQUE:
DO:
    /* ******************************************************************************* */
    /* 1ro. Redondeamos al INNER */
    /* ******************************************************************************* */
    IF B-MATG.StkRep > 0 THEN DO:
        pEmpaque = B-MATG.StkRep.
        pSugerido = 0.
        IF pCanPed >= pEmpaque THEN DO:
            f-CanFinal = TRUNCATE(pCanPed / pEmpaque, 0) * pEmpaque.
            pSugerido = f-CanFinal.
        END.
        RETURN.     /* Regresamos el valor */
    END.
    /* ******************************************************************************* */
    /* 2do. Redondeamos al MASTER */
    /* ******************************************************************************* */
    IF B-MATG.CanEmp > 0 THEN DO:
        pEmpaque = B-MATG.CanEmp.
        pSugerido = 0.
        IF pCanPed >= pEmpaque THEN DO:
            f-CanFinal = TRUNCATE(pCanPed / pEmpaque, 0) * pEmpaque.
            pSugerido = f-CanFinal.
        END.
        RETURN.
    END.
    /* ******************************************************************************* */
    /* En caso que no esté definido el INNER y el MASTER devuelve la cantidad tal cual */
    /* ******************************************************************************* */
    pSugerido = pCanPed.
END.    /* END EMPAQUE */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


