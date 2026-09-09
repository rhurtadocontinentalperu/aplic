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

/* Programa a ejecutar
    Formato pPrograma: aplic/gn/p-ecommerce-precios 
    */
                                            
DEF INPUT PARAMETER pPrograma AS CHAR.     

/* ******************************************** */
/* RHC 27/11/2020 Bloqueo de la tabla ecommerce */
/* ******************************************** */
RETURN.
/* ******************************************** */
/* ******************************************** */

DEF SHARED VAR s-NomCia AS CHAR.

/* Ic - Migracion a Cloud WIN  */
DEFINE VAR cDBfisica AS CHAR NO-UNDO.
DEFINE VAR cDBlogica AS CHAR NO-UNDO.
DEFINE VAR cPuerto AS CHAR NO-UNDO.
DEFINE VAR cIPOrigen AS CHAR NO-UNDO.
DEFINE VAR cOtrosDatos AS CHAR NO-UNDO.
DEFINE VAR cCadenaDeConexion AS CHAR NO-UNDO.

IF INDEX(s-nomcia, 'PRUEBA') > 0 THEN DO:
    IF NOT CONNECTED('ecommerce') THEN DO:
        /* CONNECT -db ecommerce -N TCP -S 65020 -H 192.168.100.216 NO-ERROR.*/
    
        cDBfisica = "ecommerce".
        cDBlogica = "ecommerce".
        cPuerto = "65020".
        cIPorigen = "192.168.100.216".
        cOtrosDatos = "".
        cCadenaDeConexion = "".
    
        /*pCadenaDeConexion = "-db " + pDBfisica + " -ld " + pDBlogica + " -N TCP -H " + cIPDestino + " -S " + pPuerto.*/
        RUN lib/migracion-win-cloud(cDBfisica, cDBlogica, cIpOrigen, cOtrosDatos, OUTPUT cCadenaDeConexion).
       
        CONNECT VALUE(cCadenaDeConexion) NO-ERROR.
    END.
        
    IF ERROR-STATUS:ERROR THEN DO:                                                            
         MESSAGE 'NO se ha podido conectar la base de datos de ECOMMERCE' VIEW-AS ALERT-BOX WARNING.     
    END.    
END.
ELSE DO:    
    IF NOT CONNECTED('ecommerce') THEN DO:

        /*CONNECT -db ecommerce -N TCP -S 65020 -H 192.168.100.242 NO-ERROR.*/

        cDBfisica = "ecommerce".
        cDBlogica = "ecommerce".
        cPuerto = "65020".
        cIPorigen = "192.168.100.242".
        cOtrosDatos = "".
        cCadenaDeConexion = "".
    
        /*pCadenaDeConexion = "-db " + pDBfisica + " -ld " + pDBlogica + " -N TCP -H " + cIPDestino + " -S " + pPuerto.*/
        RUN lib/migracion-win-cloud(cDBfisica, cDBlogica, cIpOrigen, cOtrosDatos, OUTPUT cCadenaDeConexion).
       
        CONNECT VALUE(cCadenaDeConexion) NO-ERROR.
    END.
        
    IF ERROR-STATUS:ERROR THEN DO:                                                            
         MESSAGE 'NO se ha podido conectar la base de datos de ECOMMERCE' VIEW-AS ALERT-BOX WARNING.     
    END.    
END.

CASE TRUE:
    WHEN INDEX(pPrograma, "VU") > 0 THEN DO:
        RUN vta2/wcotgralcredmayoristav23.w ("VU").
        IF CONNECTED("ecommerce") THEN DISCONNECT ecommerce NO-ERROR.
    END.
END CASE.
IF CONNECTED("ecommerce") THEN DISCONNECT ecommerce NO-ERROR.

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


