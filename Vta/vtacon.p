&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{BIN/S-GLOBAL.I}

DEFINE NEW SHARED VARIABLE S-CodDiv AS CHAR.
DEFINE NEW SHARED VARIABLE S-CodVen AS CHAR.
DEFINE NEW SHARED VARIABLE S-CodAlm AS CHAR.
DEFINE NEW SHARED VARIABLE S-DesAlm AS CHAR.
DEFINE NEW SHARED VARIABLE S-LisNiv AS CHAR.

FIND FIRST FacUsers WHERE FacUsers.CodCia = S-CODCIA 
                     AND  FacUsers.Usuario = S-USER-ID 
                    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacUsers THEN DO:
   MESSAGE "Usuario no esta registrado en la tabla Usuarios" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.
IF FacUsers.CodDiv = "" OR FacUsers.CodAlm = "" THEN DO:
   MESSAGE "Falta definir parametros de Usuarios" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.
ASSIGN S-CodDiv = FacUsers.CodDiv
       S-CodAlm = FacUsers.CodAlm 
       S-DesAlm = FacUsers.CodAlm 
       S-CodVen = FacUsers.CodVen
       S-LisNiv = FacUsers.Niveles.

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

RUN VTA/VCN/W-VTAMOS

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


