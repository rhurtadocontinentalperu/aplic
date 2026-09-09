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
         HEIGHT             = 7.35
         WIDTH              = 72.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
  DEF INPUT-OUTPUT PARAMETER pCodMat AS CHAR.
  DEF INPUT-OUTPUT PARAMETER pCantidad AS DEC.
  DEF INPUT PARAMETER pCodCia AS INT.
  
  IF TRUE <> (pCodMat > '') THEN RETURN.

  DEF VAR x-Item AS INT NO-UNDO.
  DEF VAR s-coddoc AS CHAR INIT 'CHK'.
  DEF VAR Rpta AS CHAR NO-UNDO.
  DEF VAR ArtExecp AS CHAR NO-UNDO.
  DEF VAR cCodMat AS CHAR NO-UNDO.

  cCodMat = pCodMat.
  pCantidad = 1.

  RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " buscar en almmmatg x codmat").

  pCodMat = TRIM(pCodMat).  /* Sin caracteres extraños */
  CASE TRUE:
      WHEN LENGTH(pCodMat) >= 8 AND LENGTH(pCodMat) <= 13 THEN DO:
          /* De acuerdo a formato GS1 el número de caracteres puede ser 8, 12 o 13, pero no más de 13 */
          /* EAN 13 */
          FIND Almmmatg WHERE Almmmatg.codcia = pcodcia
              AND Almmmatg.codbrr = pCodMat
              AND Almmmatg.tpoart = 'A'      /* SOLO Activados */
              NO-LOCK NO-ERROR.
          IF ERROR-STATUS:ERROR = YES THEN DO:
              IF AMBIGUOUS Almmmatg THEN DO:
                  RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " buscar en vtatabla").
                  FIND FIRST vtatabla WHERE vtatabla.codcia = pCodCia AND 
                      vtatabla.tabla = 'EAN13DUPLICADOS' AND 
                      vtatabla.llave_c1 = pCodMat NO-LOCK NO-ERROR.
                  IF NOT AVAILABLE vtatabla THEN DO:
                      RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " buscar en vtatabla existen varios").
                      MESSAGE 'Existe más de un producto registrado con este código ' + pCodMat
                          VIEW-AS ALERT-BOX ERROR.
                      pCodMat = ''.
                      RETURN.
                  END.
                  RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " buscar en almmmatg x codbrr 2").
                  /* Buscamos la primera ocurrencia */
                  FIND FIRST Almmmatg WHERE Almmmatg.codcia = pcodcia
                      AND Almmmatg.codbrr = pCodMat
                      AND Almmmatg.tpoart = 'A'      /* SOLO Activados */
                      NO-LOCK NO-ERROR.
                  IF AVAILABLE Almmmatg THEN DO:
                      RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " OK " + Almmmatg.CodMat).
                      pCodMat = Almmmatg.CodMat.          
                      RETURN.
                  END.
              END.
              /* GS1 también dice que 13 dígitos para EAN14 (Inner) */
              RUN pEan14 (INPUT-OUTPUT pCodMat, OUTPUT pCantidad).
              IF RETURN-VALUE = 'OK' THEN RETURN.
          END.
          ELSE DO:
              RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " existe en Almmmatg").
              pCodMat = Almmmatg.CodMat.          
              RETURN.
          END.
      END.
      WHEN LENGTH(pCodMat) > 13 THEN DO:
          /* EAN 14: Para el Master */
          RUN pEan14 (INPUT-OUTPUT pCodMat, OUTPUT pCantidad).
          IF RETURN-VALUE = 'OK' THEN RETURN.
      END.
      OTHERWISE DO:
          FIND FIRST Almmmatg WHERE Almmmatg.codcia = pcodcia
              AND Almmmatg.codmat = pCodMat
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almmmatg THEN DO:
              RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " existe en Almmmatg - FIN").
              RETURN.
          END.      
          ASSIGN
              pCodMat = STRING(INTEGER(pCodMat), '999999')
              NO-ERROR.
          FIND Almmmatg WHERE Almmmatg.codcia = pcodcia
              AND Almmmatg.codmat = pCodMat
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almmmatg THEN DO:
              RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " buscar en almmmatg - otra vez - FIN").
              pCodMat = Almmmatg.CodMat.          
              RETURN.
          END.
      END.
  END CASE.
  /* Error si llega hasta aquí */
  RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " buscar en almmmatg - otra vez - FIN CON ERROR").
  MESSAGE 'Artículo ' + cCodMat + ' NO registrado en el Catálogo' VIEW-AS ALERT-BOX ERROR.
  pCodMat = ''.





/*
  RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " buscar en almmmatg x codmat").
  /* CODIGO NORMAL */
  FIND FIRST Almmmatg WHERE Almmmatg.codcia = pcodcia
      AND Almmmatg.codmat = pCodMat
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almmmatg THEN DO:
      RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " existe en Almmmatg").
      RETURN.
  END.      

  RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " buscar en almmmatg x codbrr").
  /* EAN 13 */
  FIND Almmmatg USE-INDEX MATG12 WHERE Almmmatg.codcia = pcodcia
      AND Almmmatg.codbrr = pCodMat
      AND Almmmatg.tpoart = 'A'      /* SOLO Activados */
      NO-LOCK NO-ERROR.
  IF ERROR-STATUS:ERROR = YES AND AMBIGUOUS Almmmatg THEN DO:
      RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " buscar en vtatabla").
      FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
          vtatabla.tabla = 'EAN13DUPLICADOS' AND 
          vtatabla.llave_c1 = pCodMat NO-LOCK NO-ERROR.
      IF NOT AVAILABLE vtatabla THEN DO:
          RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " buscar en vtatabla existen varios").
          MESSAGE 'Existe más de un producto registrado con este código ' + pCodMat
              VIEW-AS ALERT-BOX ERROR.
          pCodMat = ''.
          RETURN.
      END.
      RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " buscar en almmmatg x codbrr 2").
      FIND FIRST Almmmatg WHERE Almmmatg.codcia = pcodcia
          AND Almmmatg.codbrr = pCodMat
          AND Almmmatg.tpoart = 'A'      /* SOLO Activados */
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almmmatg THEN DO:
          RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " OK " + Almmmatg.CodMat).
          pCodMat = Almmmatg.CodMat.          
          RETURN.
      END.
  END.
  
  /* EAN 14 */
  IF NOT AVAILABLE Almmmatg THEN DO:
    RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " buscar en Almmmat1").
    DO x-Item = 1 TO 6:
        FIND FIRST Almmmat1 WHERE Almmmat1.codcia = pCodCia 
            AND Almmmat1.Barra[x-Item] = pCodMat 
            AND CAN-FIND(Almmmatg OF Almmmat1 WHERE Almmmatg.TpoArt = 'A' NO-LOCK)
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmat1 THEN DO:
            RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " OK " + Almmmat1.CodMat).
            pCodMat = Almmmat1.CodMat.
            pCantidad = Almmmat1.Equival[x-Item].
            RETURN.
        END.
    END.
    RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " buscar en Almmmat1 - FIN").
  END.
  
  IF NOT AVAILABLE Almmmatg THEN DO: 
      RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " buscar en almmmatg - otra vez").
      ASSIGN
          pCodMat = STRING(INTEGER(pCodMat), '999999')
          NO-ERROR.
      FIND Almmmatg WHERE Almmmatg.codcia = pcodcia
          AND Almmmatg.codmat = pCodMat
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almmmatg THEN DO:
          FIND Almmmatg USE-INDEX MATG12 WHERE Almmmatg.codcia = pcodcia
              AND Almmmatg.codbrr = pCodMat
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Almmmatg THEN DO:
              MESSAGE 'Artículo ' + pCodMat + ' NO registrado en el Catálogo' VIEW-AS ALERT-BOX ERROR.
              pCodMat = ''.
              RETURN.
          END.
      END.
      RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " buscar en almmmatg - otra vez - FIN").
  END.

  RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " FIN DE P-CODBRR " + Almmmatg.codmat).

  pCodMat = Almmmatg.codmat.
*/

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
DEF OUTPUT PARAMETER pCantidad AS DECI.

  /* EAN 14 */
  FOR EACH Almmmat1 NO-LOCK WHERE Almmmat1.Llave CONTAINS pCodMat:
      IF NOT CAN-FIND(Almmmatg OF Almmmat1 WHERE Almmmatg.TpoArt = 'A' NO-LOCK)
          THEN NEXT.
      DO x-Item = 1 TO 6:
          IF Almmmat1.Barra[x-Item] = pCodMat THEN DO:
              pCodMat = Almmmat1.CodMat.
              pCantidad = Almmmat1.Equival[x-Item].
              RETURN 'OK'.
          END.
      END.
  END.

/*   RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " buscar en Almmmat1").            */
/*   DO x-Item = 1 TO 6:                                                               */
/*       FIND FIRST Almmmat1 WHERE Almmmat1.codcia = pCodCia                           */
/*           AND Almmmat1.Barra[x-Item] = pCodMat                                      */
/*           AND CAN-FIND(Almmmatg OF Almmmat1 WHERE Almmmatg.TpoArt = 'A' NO-LOCK)    */
/*           NO-LOCK NO-ERROR.                                                         */
/*       IF AVAILABLE Almmmat1 THEN DO:                                                */
/*           RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " OK " + Almmmat1.CodMat). */
/*           pCodMat = Almmmat1.CodMat.                                                */
/*           pCantidad = Almmmat1.Equival[x-Item].                                     */
/*           RETURN 'OK'.                                                              */
/*       END.                                                                          */
/*   END.                                                                              */
/*   RUN lib/p-write-log-txt.p("P-CODBRR",pCodMat + " buscar en Almmmat1 - FIN").      */


  RETURN 'ADM-ERROR'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

