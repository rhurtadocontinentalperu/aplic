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

{BIN/S-GLOBAL.I}

DEFINE NEW SHARED VARIABLE S-CODALM AS CHAR INIT "".
DEFINE NEW SHARED VARIABLE S-DESALM AS CHAR INIT "".
DEFINE NEW SHARED VARIABLE S-CODDIV AS CHAR INIT "".
DEFINE NEW SHARED VARIABLE S-MOVUSR AS CHAR INIT "".
DEFINE NEW SHARED VARIABLE S-STATUS-ALMACEN AS LOG INIT YES.

DEFINE VARIABLE s-ok AS LOGICAL INITIAL NO NO-UNDO.

/* VERIFICAMOS MOVIMIENTOS VALIDOS POR USUARIO */
/* Ej I,03|I,13|S,03 */
FOR EACH AlmUsrMov NO-LOCK WHERE AlmUsrMov.CodCia = s-codcia
  AND AlmUsrMov.User-Id = s-user-id:
  IF s-MovUsr = ''
      THEN s-MovUsr = TRIM(AlmUsrMov.TipMov) + ',' + TRIM(STRING(AlmUsrMov.CodMov)).
  ELSE s-MovUsr = s-MovUsr + '|' + TRIM(AlmUsrMov.TipMov) + ',' + TRIM(STRING(AlmUsrMov.CodMov)).
END.

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
         HEIGHT             = 4.12
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

RUN alm/d-ingalm (OUTPUT s-ok).
IF s-ok = NO THEN RETURN.
ELSE RUN alm/mainmenu2.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


