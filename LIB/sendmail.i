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
/* Variables a definir */
/*
  xUser = "ciman@continentalperu.com"
  xPass = "@Sistemas09"
  SmtpMail = "mail.continentalperu.com"
  EmailFrom = "ciman@continentalperu.com"
  EmailTO = "rhurtado@continentalperu.com"
  EmailCC = "ciman@continentalperu.com^B"   ^B para copia oculta
  Attachments = "estadodecuenta.pdf:filetype='BINARY'"      [B64ENCODED|BINARY] Default: BINARY
  LocalFiles = "d:\tmp\estadodecuenta.pdf".
  Subject = "Desde Wins 32"
  Body = "Enviando desde PURO PROGRESS"
*/

DEFINE VAR Importance AS INT    INIT 1 NO-UNDO.    /* De 0 a 3 donde 1 = HIGH  3 = LOW */
DEFINE VAR xDoAuth    AS LOG    INIT YES NO-UNDO.
DEFINE VAR xAuthType  AS CHAR   INIT "base64" NO-UNDO.
DEFINE VAR MIMEHeader AS CHAR   NO-UNDO.
DEFINE VAR BodyType   AS CHAR   INIT "TEXT" NO-UNDO.

DEFINE VAR oExito AS LOGICAL.
DEFINE VAR vMessage AS CHAR.

oExito = NO.
vMessage = "".

RUN lib/smtpmail-socket-v2 (INPUT {&SmtpMail}, 
                     INPUT {&EmailTO},
                     INPUT {&EmailFrom},
                     INPUT {&EmailCC},
                     INPUT {&Attachments},
                     INPUT {&LocalFiles},
                     INPUT {&Subject},
                     INPUT {&Body},
                     INPUT MIMEHeader,
                     INPUT Bodytype,
                     INPUT Importance,
                     INPUT xDoAuth,
                     INPUT xAuthType,
                     INPUT {&xUser},
                     INPUT {&xPass},
                     OUTPUT oExito,
                     OUTPUT vMessage).

MESSAGE vMessage VIEW-AS ALERT-BOX INFORMATION.

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
         HEIGHT             = 5.19
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


