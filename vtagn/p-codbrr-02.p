&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
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
         HEIGHT             = 4.19
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
  DEF INPUT-OUTPUT PARAMETER pCodMat AS CHAR.
  DEF OUTPUT PARAMETER pFactor AS DEC.
  
  DEF SHARED VAR s-codcia AS INT.

  DEF VAR k AS INT.

  pFactor = 1.

  /* CODIGO NORMAL */
  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = pCodMat
    NO-LOCK NO-ERROR.
  IF AVAILABLE Almmmatg THEN DO:
      RETURN.
  END.

  /* EAN 13 */
  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codbrr = pCodMat
    AND Almmmatg.tpoart <> 'D'      /* NO Desactivados */
    NO-LOCK NO-ERROR.
  IF AMBIGUOUS Almmmatg THEN DO:
    MESSAGE 'Existe más de un producto registrado con el código EAN 13' pCodMat
        VIEW-AS ALERT-BOX ERROR.
    pCodMat = ''.
    RETURN.
  END.

  IF NOT AVAILABLE Almmmatg THEN DO:
      /* EAN 14 */
      DO k = 1 TO 6:
          FOR LAST Almmmat1 NO-LOCK WHERE Almmmat1.codcia = s-codcia
              AND Almmmat1.Barras[k] = pCodMat,
              FIRST Almmmatg OF Almmmat1 NO-LOCK WHERE Almmmatg.TpoArt <> 'D':
              ASSIGN
                  pCodMat = Almmmatg.CodMat
                  pFactor = Almmmat1.Equival[k].
              RETURN.
          END.
      END.
      ASSIGN
          pCodMat = STRING(INTEGER(SELF:SCREEN-VALUE), '999999')
          NO-ERROR.
      FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
          AND Almmmatg.codmat = pCodMat
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almmmatg THEN DO:
          MESSAGE 'Artículo NO registrado en el Catálogo' VIEW-AS ALERT-BOX ERROR.
          pCodMat = ''.
          RETURN.
      END.
      pCodMat = Almmmatg.codmat.
  END.
  ELSE pCodMat = Almmmatg.codmat.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


