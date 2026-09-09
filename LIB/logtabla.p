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
         HEIGHT             = 4.81
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
  DEF INPUT PARAMETER cTabla  AS CHAR.
  DEF INPUT PARAMETER cLlave  AS CHAR.
  DEF INPUT PARAMETER cEvento AS CHAR.
  
  DEF SHARED VAR S-CODCIA  AS INT.
  DEF SHARED VAR S-USER-ID AS CHAR.
 
  CREATE LogTabla.
  ASSIGN 
    LogTabla.CodCia = S-CODCIA
    LogTabla.Usuario= S-USER-ID 
    LogTabla.Tabla  = CAPS(cTabla)
    LogTabla.ValorLlave = cLlave
    LogTabla.Evento = CAPS(cEvento)
    LogTabla.Dia    = TODAY
    LogTabla.Hora   = STRING(TIME, 'HH:MM:SS').

  RELEASE LogTabla.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


