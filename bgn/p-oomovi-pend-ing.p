&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-report-2 NO-UNDO LIKE w-report.



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
DEF INPUT PARAMETER pTipMov AS CHAR.
DEF INPUT PARAMETER pCodMov AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF OUTPUT PARAMETER TABLE FOR t-report-2.

DEF SHARED VAR s-codcia AS INTE.

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
   Temp-Tables and Buffers:
      TABLE: t-report-2 T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.08
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

  DEF VAR x-CodMov AS INTE NO-UNDO.
  DEF VAR k AS INTE NO-UNDO.

  EMPTY TEMP-TABLE t-report-2.

  DO k = 1 TO NUM-ENTRIES(pCodMov):
      x-CodMov = INTEGER(ENTRY(k, pCodMov)).
      FOR EACH OOMoviAlmacen NO-LOCK WHERE OOMoviAlmacen.CodCia = s-CodCia AND
          OOMoviAlmacen.FlagMigracion = "N" AND
          OOMoviAlmacen.TipMov = pTipMov AND
          OOMoviAlmacen.CodMov = x-CodMov AND
          LOOKUP(OOMoviAlmacen.CodAlm, pCodAlm) > 0 AND
          OOMoviAlmacen.FchDoc >= ADD-INTERVAL(TODAY,-90,'days'),
          FIRST Almmmatg OF OOMoviAlmacen NO-LOCK,
          FIRST Almmmate OF OOMoviAlmacen NO-LOCK:
          CREATE t-report-2.
          ASSIGN 
              t-report-2.Campo-C[1] = OOMoviAlmacen.CodAlm
              t-report-2.Campo-C[2] = OOMoviAlmacen.CodMat
              t-report-2.Campo-C[3] = Almmmatg.DesMat
              t-report-2.Campo-C[4] = Almmmatg.DesMar
              t-report-2.Campo-C[5] = Almmmatg.CodFam
              t-report-2.Campo-C[6] = Almmmatg.SubFam
              t-report-2.Campo-C[7] = Almmmatg.UndStk
              t-report-2.Campo-C[8] = STRING(OOMoviAlmacen.CanDes * OOMoviAlmacen.Factor)
              t-report-2.Campo-C[9] = Almmmate.CodUbi
              t-report-2.Campo-C[11] = STRING(OOMoviAlmacen.NroSer)
              t-report-2.Campo-C[12] = STRING(OOMoviAlmacen.NroDoc)
              t-report-2.Campo-C[13] = STRING(OOMoviAlmacen.FchDoc, '99/99/9999')
              t-report-2.Campo-C[14] = OOMoviAlmacen.TipMov
              t-report-2.Campo-C[15] = STRING(OOMoviAlmacen.CodMov)
              .
          FIND almtubic WHERE almtubic.CodCia = Almmmate.codcia AND
              almtubic.CodAlm = Almmmate.codalm AND 
              almtubic.CodUbi = Almmmate.codubi
              NO-LOCK NO-ERROR.
          IF AVAILABLE almtubic THEN t-report-2.Campo-C[10] = almtubic.CodZona.
      END.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


