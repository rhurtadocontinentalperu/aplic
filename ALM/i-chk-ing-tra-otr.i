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

  /* *************************************************** */
  /* 17/06/2024 Felix Perez: Datos de tiempos de chequeo */
  /* *************************************************** */
  FIND Faccpedi WHERE Faccpedi.codcia = s-codcia AND
      Faccpedi.coddoc = "OTR" AND
      Faccpedi.nroped = x-NroDoc
      NO-LOCK NO-ERROR NO-WAIT.
  IF AVAILABLE Faccpedi THEN DO:
      CREATE LogisLogControl.
      ASSIGN
          LogisLogControl.CodCia = Faccpedi.codcia
          LogisLogControl.CodDiv = s-coddiv     /*Faccpedi.coddiv*/
          LogisLogControl.CodDoc = Faccpedi.coddoc
          LogisLogControl.NroDoc = Faccpedi.nroped
          LogisLogControl.Evento = "CHECKING_END"
          LogisLogControl.Fecha  = TODAY
          LogisLogControl.Hora   = STRING(TIME, "HH:MM:SS")
          LogisLogControl.Libre_c01 = STRING(x-FchIni, '99/99/9999') + ' ' + x-HorIni
          LogisLogControl.Libre_c02 = STRING(TODAY, '99/99/9999') + ' ' + STRING(TIME, "HH:MM:SS")
          LogisLogControl.Usuario= s-user-id.
      RELEASE LogisLogControl.
  END.
  /* *************************************************** */

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
         HEIGHT             = 4.85
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


