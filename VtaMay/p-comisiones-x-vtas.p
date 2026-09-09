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

DEFINE INPUT PARAMETER p-coddiv AS CHAR.

IF NOT connected('estavtas') THEN DO:

    CONNECT -db estavtas -ld estavtas -N TCP -S 65000 -H 192.168.100.201 NO-ERROR.

    /* Ic - Migracion a Cloud WIN  */
    DEFINE VAR cDBfisica AS CHAR NO-UNDO.
    DEFINE VAR cDBlogica AS CHAR NO-UNDO.
    DEFINE VAR cPuerto AS CHAR NO-UNDO.
    DEFINE VAR cIPOrigen AS CHAR NO-UNDO.
    DEFINE VAR cOtrosDatos AS CHAR NO-UNDO.
    DEFINE VAR cCadenaDeConexion AS CHAR NO-UNDO.

    cDBfisica = "estavtas".
    cDBlogica = "estavtas".
    cPuerto = "65000".
    cIPorigen = "192.168.100.201".
    cOtrosDatos = "".
    cCadenaDeConexion = "".

    /*pCadenaDeConexion = "-db " + pDBfisica + " -ld " + pDBlogica + " -N TCP -H " + cIPDestino + " -S " + pPuerto.*/
    RUN lib/migracion-win-cloud(cDBfisica, cDBlogica, cIpOrigen, cOtrosDatos, OUTPUT cCadenaDeConexion).
   
    CONNECT VALUE(cCadenaDeConexion) NO-ERROR.

END.
       
IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'NO se ha podido conectar la base de datos de ESTADISTICAS' SKIP
              'NO podemos capturar las ventas'
              VIEW-AS ALERT-BOX WARNING.
        RETURN.
END.

RUN VtaMay/w-comisiones-x-vtas.r (INPUT p-coddiv).

IF CONNECTED('estavtas') THEN DISCONNECT 'estavtas' NO-ERROR.

        


/* IF NOT connected('cissac')                                                                */
/*         THEN CONNECT -db integral -ld cissac -N TCP -S 65030 -H 192.168.100.202 NO-ERROR. */
/*                                                                                           */
/* IF ERROR-STATUS:ERROR THEN DO:                                                            */
/*     MESSAGE 'NO se ha podido conectar la base de datos de STANDFORD' SKIP                 */
/*         'NO podemos capturar el stock'                                                    */
/*         VIEW-AS ALERT-BOX WARNING.                                                        */
/* END.    */

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
         HEIGHT             = 3.85
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


