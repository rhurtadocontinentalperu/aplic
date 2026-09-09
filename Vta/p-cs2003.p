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

DEF INPUT PARAMETER s-codcia AS INT.
DEF INPUT PARAMETER f-fecini AS DATE.
DEF INPUT PARAMETER f-fecfin AS DATE.

DEF FRAME F-Mensaje
    "Procesando" ccbcdocu.coddoc ccbcdocu.nrodoc SKIP
    "Espere un momento por favor..."
    WITH WIDTH 40 CENTERED OVERLAY NO-LABELS VIEW-AS DIALOG-BOX.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
  DEF VAR s-task-no AS INT NO-UNDO.
  DEF VAR x-impnac AS DECI NO-UNDO.
  DEF VAR x-impusa AS DECI NO-UNDO.
  DEF VAR x-imptot AS DECI NO-UNDO.
  DEF VAR x-signo  AS DECI NO-UNDO.
  /*
  s-task-no = 2003 * 1000 + s-codcia.   /* aaaannn */
  */
  s-task-no = 999999.
  VIEW FRAME F-Mensaje.
  FOR EACH w-report WHERE task-no = s-task-no:
    DISPLAY w-report.campo-c[1] @ ccbcdocu.coddoc 
        w-report.campo-c[2] @ ccbcdocu.nrodoc 
        WITH FRAME f-Mensaje.
    PAUSE 0.
    DELETE w-report.
  END.
  FOR EACH CcbCdocu USE-INDEX Llave13 WHERE CcbCdocu.CodCia = s-codcia
          AND CCbCdocu.FchDoc >= f-fecini 
          AND CcbCdocu.FchDoc <= f-fecfin 
          AND LOOKUP(CcbCdocu.CodDoc,"FAC,BOL,N/C,N/D,TCK") > 0 
          AND CcbCdocu.FlgEst <> "A" 
          AND CcbCdocu.NroCard <> '' NO-LOCK,
          FIRST GN-DIVI WHERE gn-divi.codcia = s-codcia
            AND gn-divi.coddiv = ccbcdocu.coddiv NO-LOCK:
    DISPLAY ccbcdocu.coddoc ccbcdocu.nrodoc WITH FRAME f-Mensaje.
    PAUSE 0.
    ASSIGN
        x-impnac = 0
        x-impusa = 0
        x-imptot = 0.
    x-signo = IF ccbcdocu.coddoc = "N/C" THEN -1 ELSE 1.
    IF ccbcdocu.codmon = 1 THEN x-impnac = ccbcdocu.imptot * x-signo.
    IF ccbcdocu.codmon = 2 THEN x-impusa = ccbcdocu.imptot * x-signo.
    x-imptot = x-impnac + x-impusa * ccbcdocu.tpocmb.
    CREATE w-report.
    ASSIGN
        w-report.Task-No = s-task-no
        w-report.Llave-C = ccbcdocu.nrocard
        w-report.Campo-I[1] = s-codcia 
        w-report.Campo-F[1] = x-impnac
        w-report.Campo-F[2] = x-impusa
        w-report.Campo-F[3] = x-imptot
        w-report.Campo-D[1] = ccbcdocu.fchdoc
        w-report.Campo-C[1] = ccbcdocu.coddoc
        w-report.Campo-C[2] = ccbcdocu.nrodoc
        w-report.Campo-C[3] = gn-divi.desdiv        
        w-report.Campo-C[4] = ccbcdocu.codcli
        w-report.Campo-C[5] = ccbcdocu.flgest
        w-report.Campo-C[6] = ccbcdocu.coddiv.
  END.
  HIDE FRAME F-Mensaje.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


