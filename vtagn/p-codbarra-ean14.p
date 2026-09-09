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
         HEIGHT             = 7.23
         WIDTH              = 72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* SOLO DEBE ACEPTAR CODIGOS DE BARRA QUE SEAN EAN14                    */

  DEF INPUT-OUTPUT PARAMETER pCodMat AS CHAR.
  DEF INPUT-OUTPUT PARAMETER pCantidad AS DEC.
  DEF INPUT PARAMETER pCodCia AS INT.
  DEF VAR x-Item AS INT NO-UNDO.
  DEF VAR Rpta AS CHAR NO-UNDO.
  DEF VAR ArtExecp AS CHAR NO-UNDO.

  pCantidad = 0.    /* POR DEFECTO NO EXISTE EL EAN14 */
  /*
  /* EAN 14 */
  DO x-Item = 1 TO 6:
      FIND FIRST Almmmat1 WHERE Almmmat1.codcia = pCodCia
          AND Almmmat1.Barra[x-Item] = pCodMat 
          AND CAN-FIND(FIRST Almmmatg OF Almmmat1 WHERE Almmmatg.TpoArt = 'A' NO-LOCK)
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almmmat1 THEN DO:
          pCodMat = Almmmat1.CodMat.
          pCantidad = Almmmat1.Equival[x-Item].
          RETURN.
      END.
  END.
*/
  /* EAN 14 */
  FOR EACH Almmmat1 NO-LOCK WHERE Almmmat1.Barras CONTAINS pCodMat:
      FIND FIRST Almmmatg OF almmmat1 WHERE Almmmatg.TpoArt = 'A' NO-LOCK NO-ERROR.
      IF AVAILABLE almmmatg THEN DO:
          DO x-Item = 1 TO 6:
              IF Almmmat1.Barras[x-Item] = pCodMat THEN DO:
                  pCodMat = Almmmat1.CodMat.
                  pCantidad = Almmmat1.Equival[x-Item].
                  RETURN 'OK'.
              END.
          END.
      END.
  END.

  /* Si llega hasta aquí es que NO hay código EAN 14 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


