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

IF NOT connected('cissac')
    THEN CONNECT -db integral -ld cissac -N TCP -S IN_ON_ST -H inf210 NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
  MESSAGE 'NO se ha podido conectar la base de datos de STANDFORD' SKIP
      'NO podemos capturar el stock'
      VIEW-AS ALERT-BOX WARNING.
END.

DEFINE SHARED TEMP-TABLE tabla NO-UNDO
    FIELDS t-codcli LIKE integral.gn-clie.codcli
    FIELDS t-coddoc LIKE integral.faccpedi.coddoc
    FIELDS t-nrocot LIKE integral.faccpedi.nroped
    FIELDS t-totcot AS DECIMAL FORMAT "->>>>>>>>>9.99"
    FIELDS t-codfac LIKE integral.ccbcdocu.coddoc
    FIELDS t-nrofac LIKE integral.ccbcdocu.nrodoc
    FIELDS t-totfac AS DECIMAL FORMAT "->>>>>>>>>9.99"
    FIELDS t-totlet AS DECIMAL FORMAT "->>>>>>>>>9.99"
    FIELDS t-letcis AS DECIMAL FORMAT "->>>>>>>>>9.99"
    FIELDS t-libred AS DECIMAL FORMAT "->>>>>>>>>9.99"
    FIELDS t-librec AS CHAR
    FIELDS t-libref AS DATE    .


/*DEFINE INPUT PARAMETER cCodCli AS CHAR.*/
DEFINE INPUT PARAMETER fDesde  AS DATE.
DEFINE INPUT PARAMETER fHasta  AS DATE.
DEFINE INPUT PARAMETER cDivi   AS CHAR.
/*DEFINE OUTPUT PARAMETER x-totlet AS DECIMAL.*/

/*Data-Cissac*/
/*RUN ccb\letras-cissac.p (fDesde,fHasta,cDivi, OUTPUT x-totlet).*/
RUN ccb\letras-cissac.p (fDesde,fHasta,cDivi).


IF CONNECTED('cissac') THEN DISCONNECT 'cissac' NO-ERROR.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


