&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

      IF X-Items = F-Items THEN DO:
        FIND FIRST FacCorre WHERE 
             FacCorre.CodCia = S-CODCIA AND
             FacCorre.CodDoc = "REP"    AND
             FacCorre.CodDiv = S-CODDIV AND
             FacCorre.NroSer = S-NROSER  EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE FacCorre THEN DO:
           CREATE Almcrequ.
           ASSIGN 
           Almcrequ.CodCia = S-CODCIA
           Almcrequ.CodAlm = F-CODALM
           Almcrequ.Almdes = F-Almdes
           Almcrequ.NroSer = S-NROSER
           Almcrequ.FchDoc = TODAY
           Almcrequ.Usuario = S-USER-ID
           Almcrequ.HorGen = STRING(TIME,"HH:MM")
           Almcrequ.NroSer = FacCorre.NroSer
           Almcrequ.NroDoc = FacCorre.Correlativo
           Almcrequ.Observ = Almcrequ.Observ + "/ " + STRING(f-dias) + " Dias /" + s-subtit5
           FacCorre.Correlativo = FacCorre.Correlativo + 1.
        END.
        RELEASE FacCorre.
        X-Items = 0.
        IF x-nrodoc = "" THEN x-nrodoc = STRING(Almcrequ.NroDoc,"999999").
        ELSE x-Nrodoc = x-nrodoc + "," + STRING(Almcrequ.NroDoc,"999999").
      END.
      X-Items = X-Items + 1. 
      CREATE Almdrequ.
      ASSIGN Almdrequ.CodCia = Almcrequ.CodCia
            Almdrequ.CodAlm = Almcrequ.CodAlm
            Almdrequ.NroSer = Almcrequ.NroSer
            Almdrequ.NroDoc = Almcrequ.NroDoc
            Almdrequ.codmat = Repo.codmat
            Almdrequ.CanReq = Repo.canate
            Almdrequ.AlmDes = Almcrequ.AlmDes.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


