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

DEF INPUT PARAMETER pCodMat AS CHAR.                                   
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pMargen AS DEC.

DEF OUTPUT PARAMETER pForeground AS INT.
DEF OUTPUT PARAMETER pBackground AS INT.

/* Valores por defecto */
ASSIGN
    pForeground = ?
    pBackground = ?.

DEF SHARED VAR s-codcia AS INT.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND
    Almmmatg.codmat = pCodMat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.

FIND gn-divi WHERE gn-divi.codcia = s-codcia AND
    gn-divi.coddiv = pCodDiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN RETURN.

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
         HEIGHT             = 4.62
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
FIND VtaTabla WHERE VtaTabla.CodCia = s-Codcia AND
    /*VtaTabla.Llave_c1 = GN-DIVI.Grupo_Divi_GG AND*/
    VtaTabla.Llave_c1 = gn-divi.CanalVenta AND
    VtaTabla.Tabla = "SEMMML" AND
    VtaTabla.Llave_c2 = Almmmatg.codfam
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla THEN RETURN.
CASE TRUE:
    WHEN pMargen <= VtaTabla.Valor[1] THEN DO:
        ASSIGN
            pForeground = 12    /* Rojo */
            pBackground = 12.
    END.
    WHEN pMargen <= VtaTabla.Valor[2] THEN DO:
        ASSIGN
            pForeground = 14    /* Amarillo */
            pBackground = 14.
    END.
    WHEN pMargen <= VtaTabla.Valor[3] THEN DO:
        ASSIGN
            pForeground = 10    /* Verde */
            pBackground = 10.
    END.
    OTHERWISE DO:
        ASSIGN
            pForeground = 0    /* Negro */
            pBackground = 0.
    END.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


