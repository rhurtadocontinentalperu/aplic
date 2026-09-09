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

DEF INPUT PARAMETER pTipo AS CHAR.      /* EAN 13 o EAN 14 */
DEF INPUT PARAMETER pItem AS INT.       /* Solo para EAN14, va de 1 a 5 */
DEF INPUT PARAMETER pCodMat AS CHAR.    
DEF INPUT PARAMETER pCodBrr AS CHAR.
DEF OUTPUT PARAMETER pError AS CHAR.

DEF SHARED VAR s-codcia AS INT.

pError = ''.        /* Sin error por defecto */

IF LOOKUP(pTipo, 'EAN13,EAN14') = 0 THEN DO:
    MESSAGE 'Primer parámetro solo acepta los valores EAN13 o EAN14'.
    RETURN.
END.
IF NOT (pItem >= 0 AND pItem <= 5) THEN DO:
    MESSAGE 'Segundo parámetro solo acepta  valores enteros de 0 al 5'.
    RETURN.
END.
IF TRUE <> (pCodMat > '') THEN RETURN.
IF TRUE <> (pCodBrr > '') THEN RETURN.

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
         HEIGHT             = 4.15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF BUFFER B-MATG FOR Almmmatg.
DEF BUFFER B-MAT1 FOR Almmmat1.
DEF VAR k AS INT NO-UNDO.

FIND B-MATG WHERE B-MATG.codcia = s-codcia
    AND B-MATG.codmat = pCodMat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-MATG THEN DO:
    pError = "Código de producto NO registrado: " + pCodMat.
    RETURN.
END.
PRINCIPAL:
DO:
    CASE pTipo:
        WHEN 'EAN13' THEN DO:
            /* Que no se repita en el mismo producto como EAN14 */
            FIND B-MAT1 OF B-MATG NO-LOCK NO-ERROR.
            IF AVAILABLE B-MAT1 THEN DO k = 1 TO 5:
                IF B-MAT1.Barras[k] = pCodBrr THEN DO:
                    pError = "Código de Barra " + pCodBrr + " ya registrado como EAN14".
                    LEAVE PRINCIPAL.
                END.
            END.
            /* Que no se repita en otros productos como EAN13 */
            FIND FIRST B-MATG WHERE B-MATG.codcia = s-codcia
                AND B-MATG.codmat <> pCodMat 
                AND B-MATG.codbrr = pCodBrr
                NO-LOCK NO-ERROR.
            IF AVAILABLE B-MATG THEN DO:
                pError = "Código de Barra " + pCodBrr + " duplicado en el producto " + B-MATG.codmat.
                LEAVE PRINCIPAL.
            END.
            /* Que no se repita en otro producto como EAN14 */
            DO k = 1 TO 5:
                FIND FIRST B-MAT1 WHERE B-MAT1.codcia = s-codcia
                    AND B-MAT1.CodMat <> pCodMat
                    AND B-MAT1.Barras[k] = pCodBrr
                    NO-LOCK NO-ERROR.
                IF AVAILABLE B-MAT1 THEN DO:
                    pError = "Código de Barra " + pCodBrr + " ya registrado como EAN14 en el producto " + B-MAT1.codmat.
                    LEAVE PRINCIPAL.
                END.
            END.
        END.
        WHEN 'EAN14' THEN DO:
            /* Que no se repita en el mismo producto como EAN13 */
            IF B-MATG.CodBrr = pCodBrr THEN DO:
                pError = "Código de Barra " + pCodBrr + " ya registrado como EAN13".
                LEAVE PRINCIPAL.
            END.
            /* Que no se repita en otro EAN 14 */
            FIND B-MAT1 OF B-MATG NO-LOCK NO-ERROR.
            IF AVAILABLE B-MAT1 THEN DO k = 1 TO 5:
                IF k <> pItem AND B-MAT1.Barras[k] = pCodBrr THEN DO:
                    pError = "Código de Barra " + pCodBrr + " ya registrado como EAN14".
                    LEAVE PRINCIPAL.
                END.
            END.
            /* Que no se repita en otro producto como EAN 13 */
            FIND FIRST B-MATG WHERE B-MATG.codcia = s-codcia
                AND B-MATG.codmat <> pCodMat 
                AND B-MATG.codbrr = pCodBrr
                NO-LOCK NO-ERROR.
            IF AVAILABLE B-MATG THEN DO:
                pError = "Código de Barra " + pCodBrr + " ya registrado como EAN13 en el producto " + B-MATG.codmat.
                LEAVE PRINCIPAL.
            END.
            /* Que no se repita en otro producto como EAN14 */
            DO k = 1 TO 5:
                FIND FIRST B-MAT1 WHERE B-MAT1.codcia = s-codcia
                    AND B-MAT1.CodMat <> pCodMat
                    AND B-MAT1.Barras[k] = pCodBrr
                    NO-LOCK NO-ERROR.
                IF AVAILABLE B-MAT1 THEN DO:
                    pError = "Código de Barra " + pCodBrr + " ya registrado como EAN14 en el producto " + B-MAT1.codmat.
                    LEAVE PRINCIPAL.
                END.
            END.
        END.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


