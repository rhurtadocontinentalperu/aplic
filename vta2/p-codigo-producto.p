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
         HEIGHT             = 5.12
         WIDTH              = 62.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
  DEF INPUT-OUTPUT PARAMETER pCodMat AS CHAR.
  DEF INPUT PARAMETER pError AS LOG.
  
  DEF SHARED VAR s-codcia AS INT.

  DEF VAR x-Item AS INT NO-UNDO.
  DEF VAR s-coddoc AS CHAR INIT 'CHK'.
  DEF VAR Rpta AS CHAR NO-UNDO.
  DEF VAR ArtExecp AS CHAR NO-UNDO.
  DEF VAR cCodMat AS CHAR NO-UNDO.

  cCodMat = pCodMat.

  pCodMat = TRIM(pCodMat).  /* Sin caracteres extraños */
  CASE TRUE:
      WHEN LENGTH(pCodMat) >= 8 AND LENGTH(pCodMat) <= 13 THEN DO:
          /* De acuerdo a formato GS1 el número de caracteres puede ser 8, 12 o 13, pero no más de 13 */
          /* EAN 13 */
          FIND Almmmatg WHERE Almmmatg.codcia = s-CodCia
              AND Almmmatg.codbrr = pCodMat
              AND Almmmatg.tpoart = 'A'      /* SOLO Activados */
              NO-LOCK NO-ERROR.
          IF ERROR-STATUS:ERROR = YES THEN DO:
              IF AMBIGUOUS Almmmatg THEN DO:
                  FIND FIRST vtatabla WHERE vtatabla.codcia = s-CodCia AND 
                      vtatabla.tabla = 'EAN13DUPLICADOS' AND 
                      vtatabla.llave_c1 = pCodMat NO-LOCK NO-ERROR.
                  IF NOT AVAILABLE vtatabla THEN DO:
                      IF pError THEN MESSAGE 'Existe más de un producto registrado con este código ' + pCodMat
                          VIEW-AS ALERT-BOX ERROR.
                      pCodMat = ''.
                      RETURN.
                  END.
                  /* Buscamos la primera ocurrencia */
                  FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-CodCia
                      AND Almmmatg.codbrr = pCodMat
                      AND Almmmatg.tpoart = 'A'      /* SOLO Activados */
                      NO-LOCK NO-ERROR.
                  IF AVAILABLE Almmmatg THEN DO:
                      pCodMat = Almmmatg.CodMat.          
                      RETURN.
                  END.
              END.
              /* GS1 también dice que 13 dígitos para EAN14 (Inner) */
              RUN pEan14 (INPUT-OUTPUT pCodMat).
              IF RETURN-VALUE = 'OK' THEN RETURN.
          END.
          ELSE DO:
              pCodMat = Almmmatg.CodMat.          
              RETURN.
          END.
      END.
      WHEN LENGTH(pCodMat) > 13 THEN DO:
          /* EAN 14: Para el Master */
          RUN pEan14 (INPUT-OUTPUT pCodMat).
          IF RETURN-VALUE = 'OK' THEN RETURN.
      END.
      OTHERWISE DO:
          FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-CodCia
              AND Almmmatg.codmat = pCodMat
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almmmatg THEN DO:
              RETURN.
          END.      
          ASSIGN
              pCodMat = STRING(INTEGER(pCodMat), '999999')
              NO-ERROR.
          FIND Almmmatg WHERE Almmmatg.codcia = s-CodCia
              AND Almmmatg.codmat = pCodMat
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almmmatg THEN DO:
              pCodMat = Almmmatg.CodMat.          
              RETURN.
          END.
      END.
  END CASE.
  /* Error si llega hasta aquí */
  IF pError THEN MESSAGE 'Artículo ' + cCodMat + ' NO registrado en el Catálogo' VIEW-AS ALERT-BOX ERROR.
  pCodMat = ''.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pEan14) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pEan14 Procedure 
PROCEDURE pEan14 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT-OUTPUT PARAMETER pCodMat AS CHAR.

  /* EAN 14 */
  DO x-Item = 1 TO 6:
      /*
      FIND FIRST Almmmat1 WHERE Almmmat1.codcia = s-CodCia 
          AND Almmmat1.Barra[x-Item] = pCodMat 
          AND CAN-FIND(Almmmatg OF Almmmat1 WHERE Almmmatg.TpoArt = 'A' NO-LOCK)
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almmmat1 THEN DO:
          RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " OK " + Almmmat1.CodMat).
          pCodMat = Almmmat1.CodMat.
          RETURN 'OK'.
      END.
      */
    FIND FIRST Almmmat1 WHERE Almmmat1.Barras[x-Item] = pCodMat AND Almmmat1.codcia = s-codcia NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmat1 THEN DO:
        FIND FIRST Almmmatg OF almmmat1 WHERE Almmmatg.TpoArt = 'A' NO-LOCK NO-ERROR.
        IF AVAILABLE almmmatg THEN DO:
            pCodMat = Almmmat1.CodMat.
            RETURN 'OK'.
        END.
    END.
  END.

  RETURN 'ADM-ERROR'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

