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

IF NOT connected('cissac') THEN DO:
        MESSAGE 'No hay Conexion a Cissac, Desea Conectarse?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.
END.

IF NOT connected('cissac') THEN DO:
    /*CONNECT -db integral -ld cissac -N TCP -S 65030 -H 192.168.100.202 NO-ERROR.*/

    /* Ic - Migracion a Cloud WIN  */
    DEFINE VAR cDBfisica AS CHAR NO-UNDO.
    DEFINE VAR cDBlogica AS CHAR NO-UNDO.
    DEFINE VAR cPuerto AS CHAR NO-UNDO.
    DEFINE VAR cIPOrigen AS CHAR NO-UNDO.
    DEFINE VAR cOtrosDatos AS CHAR NO-UNDO.
    DEFINE VAR cCadenaDeConexion AS CHAR NO-UNDO.

    cDBfisica = "integral".
    cDBlogica = "cissac".
    cPuerto = "65030".
    cIPorigen = "192.168.100.202".
    cOtrosDatos = "".
    cCadenaDeConexion = "".

    /*pCadenaDeConexion = "-db " + pDBfisica + " -ld " + pDBlogica + " -N TCP -H " + cIPDestino + " -S " + pPuerto.*/
    RUN lib/migracion-win-cloud(cDBfisica, cDBlogica, cIpOrigen, cOtrosDatos, OUTPUT cCadenaDeConexion).
   
    CONNECT VALUE(cCadenaDeConexion) NO-ERROR.
END.
                                                                                          
 IF ERROR-STATUS:ERROR THEN DO:                                                           
     MESSAGE 'NO se ha podido conectar la base de datos de STANDFORD' SKIP                
         'NO podemos capturar el stock'                                                   
         VIEW-AS ALERT-BOX WARNING.         
     RETURN NO-APPLY.
 END.    

 RUN alm\w-stock-marbetes.r.

 IF CONNECTED('cissac') THEN DISCONNECT 'cissac' NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


