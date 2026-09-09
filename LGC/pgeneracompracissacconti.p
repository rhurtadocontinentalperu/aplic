&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Conecta la base de datos de estadisticas y luego la cierra

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

DEF VAR pProfile AS CHAR NO-UNDO.

pProfile = 'cissac.pf'.
IF NOT CONNECTED("cissac") THEN DO:
    pProfile = SEARCH(pProfile).
    IF pProfile = ? THEN DO:
        MESSAGE 'NO se ha encontrado el archivo cissac.pf'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    CONNECT -pf cissac.pf NO-ERROR.
    /*CONNECT -db integral -ld cissac -N TCP -S 65030 -H 192.168.100.213 NO-ERROR.*/
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'NO se pudo conectar la base de CISSAC' SKIP
            'Comunicar al administrador de base de datos'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
END.

RUN lgc/ggeneracompracissacconti (pRowid).

IF CONNECTED("cissac") THEN DISCONNECT cissac NO-ERROR.

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
         HEIGHT             = 4.27
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


