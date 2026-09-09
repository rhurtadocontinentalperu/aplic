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
         HEIGHT             = 2.01
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
    DEFINE VARIABLE db-work AS CHARACTER NO-UNDO.
    DEFINE VARIABLE L-OK AS LOGICAL.
    DEFINE VARIABLE db-model AS CHARACTER NO-UNDO.

    FIND PL-CFG-RPT WHERE TpoRpt = 1 AND CodRep = 'Mensual'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PL-CFG-RPT THEN DO:
        MESSAGE "No está configurado el reporte 'Mensual'" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF CONNECTED( "db-work") THEN DISCONNECT db-work.
    FILE-INFO:FILE-NAME = ".".
   
    GET-KEY-VALUE SECTION "Planillas" KEY "Directorio de programas" VALUE db-model.

    db-model = db-model + "db-work".
    db-work = SESSION:TEMP-DIRECTORY + "db-work.db".
    CREATE DATABASE db-work FROM db-model REPLACE.
    CONNECT VALUE( db-work ) -1 -ld db-work.
    L-OK = NO.
    RUN pln/w-rpl-2m (PL-CFG-RPT.CodRep, PL-CFG-RPT.TpoRpt, TRUE , "" , OUTPUT L-OK).
    
    IF CONNECTED( "db-work") THEN DISCONNECT db-work.
    
    IF L-OK THEN 
       RUN pln/w-rpl-3.w( PL-CFG-RPT.CodRep, TRUE, PL-CFG-RPT.TpoRpt, "" ).
    
    IF CONNECTED( "db-work") THEN DISCONNECT db-work.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


