&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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

  IF x-CodUbiIni <> x-CodUbiFin THEN DO:
      FIND FIRST almubimat WHERE almubimat.CodCia = {&iAlmmmate}.codcia
          AND almubimat.CodAlm = {&iAlmmmate}.codalm
          AND almubimat.CodMat = {&iAlmmmate}.codmat
          AND almubimat.CodUbi = x-CodUbiIni
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE almubimat THEN DO:
          /* CREATE */
          CREATE almubimat.
          BUFFER-COPY {&iAlmmmate} TO Almubimat.
          FIND Almtubic WHERE almtubic.CodCia = {&iAlmmmate}.codcia
              AND almtubic.CodAlm = {&iAlmmmate}.codalm
              AND almtubic.CodUbi = {&iAlmmmate}.codubi
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almtubic THEN almubimat.CodZona = Almtubic.codzona.
          CREATE Logubimat.
          BUFFER-COPY {&iAlmmmate} TO Logubimat
              ASSIGN
              logubimat.Usuario = s-user-id
              logubimat.Hora = STRING(TIME, 'HH:MM:SS')
              logubimat.Fecha = TODAY
              logubimat.Evento = 'CREATE'
              logubimat.CodUbiIni = x-CodUbiFin
              logubimat.CodUbiFin = x-CodUbiFin.
          FIND Almtubic WHERE almtubic.CodCia = {&iAlmmmate}.codcia
              AND almtubic.CodAlm = {&iAlmmmate}.codalm
              AND almtubic.CodUbi = x-CodUbiFin
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almtubic THEN
              ASSIGN
              logubimat.CodZonaIni = almtubic.CodZona
              logubimat.CodZonaFin = almtubic.CodZona.
      END.
      ELSE DO:
          /* MOVE */
          FIND CURRENT Almubimat EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
          IF ERROR-STATUS:ERROR = YES THEN DO:
              {lib/mensaje-de-error.i &MensajeError="pMensaje" }
              MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
              UNDO, RETURN 'ADM-ERROR'.
          END.
          ASSIGN
              almubimat.CodUbi = x-CodUbiFin.
          CREATE Logubimat.
          BUFFER-COPY {&iAlmmmate} TO Logubimat
              ASSIGN
              logubimat.Usuario = s-user-id
              logubimat.Hora = STRING(TIME, 'HH:MM:SS')
              logubimat.Fecha = TODAY
              logubimat.Evento = 'MOVE'
              logubimat.CodUbiIni = x-CodUbiIni
              logubimat.CodZonaIni = Almubimat.CodZona
              logubimat.CodUbiFin = x-CodUbiFin.
          FIND Almtubic WHERE almtubic.CodCia = {&iAlmmmate}.codcia
              AND almtubic.CodAlm = {&iAlmmmate}.codalm
              AND almtubic.CodUbi = x-CodUbiFin
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almtubic THEN 
              ASSIGN
              almubimat.codzona    = Almtubic.CodZona
              logubimat.CodZonaFin = Almtubic.CodZona.
      END.
      IF AVAILABLE(logubimat) THEN RELEASE logubimat.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 5.81
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


