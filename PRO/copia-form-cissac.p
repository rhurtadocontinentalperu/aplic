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

IF NOT connected('cissac')
    THEN CONNECT -db integral -ld cissac -N TCP -S IN_ON_ST -H inf210 NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
  MESSAGE 'NO se ha podido conectar la base de datos de STANDFORD' SKIP
      'NO podemos copiar las fórmulas'
      VIEW-AS ALERT-BOX WARNING.
  RETURN.
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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
FIND integral.pr-formc WHERE ROWID(integral.pr-formc) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE integral.pr-formc THEN RETURN.

FIND cissac.pr-formc OF integral.pr-formc NO-LOCK NO-ERROR.
IF AVAILABLE cissac.pr-formc THEN DO:
    MESSAGE 'La fórmula YA existe en CISSAC' SKIP
        'La reemplazamos?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN.
END.
DO TRANSACTION ON ERROR UNDO, RETURN ON STOP UNDO, RETURN:
    IF AVAILABLE cissac.pr-formc THEN DO:
        FIND CURRENT cissac.pr-formc EXCLUSIVE-LOCK NO-ERROR.
        IF  NOT AVAILABLE cissac.pr-formc THEN UNDO, RETURN.
        FOR EACH cissac.pr-formd OF cissac.pr-formc:
            DELETE cissac.pr-formd.
        END.
        FOR EACH cissac.pr-formdm OF cissac.pr-formc:
            DELETE cissac.pr-formdm.
        END.
        DELETE cissac.pr-formc.
    END.
    CREATE cissac.pr-formc.
    BUFFER-COPY integral.pr-formc TO cissac.pr-formc.
    FOR EACH integral.pr-formd OF integral.pr-formc NO-LOCK:
        CREATE cissac.pr-formd.
        BUFFER-COPY integral.pr-formd TO cissac.pr-formd.
    END.
    FOR EACH integral.pr-formdm OF integral.pr-formc NO-LOCK:
        CREATE cissac.pr-formdm.
        BUFFER-COPY integral.pr-formdm TO cissac.pr-formdm.
    END.
END.
IF CONNECTED('cissac') THEN DISCONNECT cissac NO-ERROR.

MESSAGE 'Migracion exitosa' VIEW-AS ALERT-BOX.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


