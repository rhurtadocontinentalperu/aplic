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
DEF INPUT  PARAMETER pTipo  AS CHAR.
DEF INPUT  PARAMETER pFlag  AS CHAR.
DEF OUTPUT PARAMETER pValor AS CHAR.

/* SOLO PARA LETRAS */
DEF SHARED VAR cl-codcia AS INT.
CASE pTipo:
    WHEN "Situacion" THEN DO:
        CASE pFlag:
            WHEN 'T' THEN pValor = 'Transito'.
            WHEN 'C' THEN pValor = 'Cobranza Libre'.
            WHEN 'G' THEN pValor = 'Cobranza Garantia'.
            WHEN 'D' THEN pValor = 'Descuento'.
            WHEN 'P' THEN pValor = 'Protestada'.
        END CASE.
    END.
    WHEN "Ubicacion" THEN DO:
        CASE pFlag:
            WHEN 'C' THEN pValor = 'Cartera'.
            WHEN 'B' THEN pValor = 'Banco'.
        END CASE.
    END.
    WHEN "Banco" THEN DO:
        FIND Cb-ctas WHERE Cb-ctas.codcia = CL-CODCIA
            AND Cb-ctas.codcta = pFlag
            NO-LOCK NO-ERROR.
        IF AVAILABLE Cb-ctas THEN DO:
            FIND Cb-tabl WHERE Cb-tabl.tabla = '04'
                AND Cb-tabl.codigo = Cb-ctas.codbco
                NO-LOCK NO-ERROR.
            IF AVAILABLE Cb-tabl THEN pValor = cb-tabl.Nombre.
        END.
    END.
    OTHERWISE pValor = "".
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


