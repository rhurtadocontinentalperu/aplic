&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
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
DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pEvent AS CHAR.
DEF INPUT PARAMETER pUser AS CHAR.


/* FIND integral.almmmatg WHERE ROWID(integral.almmmatg) = pRowid NO-LOCK NO-ERROR. */
/* IF NOT AVAILABLE integral.almmmatg THEN RETURN.                                  */
/* CREATE cissac.Logmmatg.                                                          */
/* BUFFER-COPY integral.almmmatg TO cissac.Logmmatg                                 */
/*     ASSIGN                                                                       */
/*     cissac.Logmmatg.LogDate = TODAY                                              */
/*     cissac.Logmmatg.LogTime = STRING(TIME, 'HH:MM:SS')                           */
/*     cissac.Logmmatg.LogUser = pUser                                              */
/*     cissac.Logmmatg.FlagFechaHora = DATETIME(TODAY, MTIME)                       */
/*     cissac.Logmmatg.FlagUsuario = pUser                                          */
/*     cissac.Logmmatg.flagestado = pEvent.                                         */

/* RHC 12/06/2015 */
FIND Almmmatg WHERE ROWID(Almmmatg) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.
CREATE LogmmatgCi.
BUFFER-COPY Almmmatg TO LogmmatgCi
    ASSIGN
    LogmmatgCi.LogDate = TODAY
    LogmmatgCi.LogTime = STRING(TIME, 'HH:MM:SS')
    LogmmatgCi.LogUser = pUser
    LogmmatgCi.FlagFechaHora = DATETIME(TODAY, MTIME)
    LogmmatgCi.FlagUsuario = pUser
    LogmmatgCi.flagestado = pEvent.

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
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


