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
         HEIGHT             = 3.81
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
  DEF INPUT-OUTPUT PARAMETER pCodMat AS CHAR.
  DEF INPUT-OUTPUT PARAMETER pCantidad AS DEC.
  DEF INPUT PARAMETER pCodCia AS INT.
  
  DEF SHARED VAR s-codcia AS INT.
  DEF VAR x-Item AS INT NO-UNDO.
  DEF VAR s-coddoc AS CHAR INIT 'CHK'.
  DEF VAR Rpta AS CHAR NO-UNDO.
  DEF VAR ArtExecp AS CHAR NO-UNDO.

  pCantidad = 1.


  /* CODIGO NORMAL */
  FIND Almmmatg WHERE Almmmatg.codcia = pcodcia
    AND Almmmatg.codmat = pCodMat
    NO-LOCK NO-ERROR.
  IF AVAILABLE Almmmatg THEN DO:
      RETURN.
  END.

  /* EAN 13 */
  FIND Almmmatg USE-INDEX MATG12 WHERE Almmmatg.codcia = pcodcia
    AND Almmmatg.codbrr = pCodMat
    NO-LOCK NO-ERROR.
  IF AMBIGUOUS Almmmatg THEN DO:
      FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'EAN13DUPLICADOS' AND 
          vtatabla.llave_c1 = pCodMat NO-LOCK NO-ERROR.
      IF NOT AVAILABLE vtatabla THEN DO:
          MESSAGE 'Existe más de un producto registrado con este código'
              VIEW-AS ALERT-BOX ERROR.
          pCodMat = ''.
          RETURN.
      END.
     FIND FIRST Almmmatg WHERE Almmmatg.codcia = pcodcia
            AND Almmmatg.codbrr = pCodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmatg THEN DO:
            pCodMat = Almmmatg.CodMat.
            RETURN.
        END.
  END.

  /* EAN 14 */
  IF NOT AVAILABLE Almmmatg THEN DO:
    DO x-Item = 1 TO 3:
        FIND FIRST Almmmat1 WHERE Almmmat1.codcia = pCodCia 
            AND Almmmat1.Barra[x-Item] = pCodMat 
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmat1 THEN DO:
            FIND Almmmatg OF Almmmat1 NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almmmatg THEN NEXT.
            pCodMat = Almmmat1.CodMat.
            pCantidad = Almmmat1.Equival[x-Item].
            RETURN.
        END.
    END.
  END.

  IF NOT AVAILABLE Almmmatg THEN DO:
    ASSIGN
        pCodMat = STRING(INTEGER(SELF:SCREEN-VALUE), '999999')
        NO-ERROR.
    FIND Almmmatg WHERE Almmmatg.codcia = pcodcia
        AND Almmmatg.codmat = pCodMat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        MESSAGE 'Artículo NO registrado en el Catálogo' VIEW-AS ALERT-BOX ERROR.
        pCodMat = ''.
        RETURN.
    END.
  END.
  pCodMat = Almmmatg.codmat.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


