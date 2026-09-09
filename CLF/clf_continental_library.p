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

/* Librerias

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN <libreria> PERSISTENT SET hProc.

RUN <libreria>.rutina_interna IN hProc (input  buffer tt-excel:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-excel:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.

*/

DEF SHARED VAR s-codcia AS INTE.

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
         HEIGHT             = 6.62
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Connect_Continental) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Connect_Continental Procedure 
PROCEDURE Connect_Continental :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

FIND FIRST Clf_Connect NO-LOCK NO-ERROR.
IF NOT AVAILABLE Clf_Connect THEN DO:
    pMensaje = "No se ha configurado los parámetros de conexión a la base de datos".
    RETURN 'ADM-ERROR'.
END.

DEF VAR x-DataBase AS CHAR.
DEF VAR x-LogDataBase AS CHAR.
DEF VAR x-Ip AS CHAR.
DEF VAR x-Service AS CHAR.
DEF VAR x-Protocol AS CHAR.
DEF VAR x-User AS CHAR.
DEF VAR x-Password AS CHAR.

DEF VAR x-Connection AS CHAR.
ASSIGN
    x-Database = Clf_Connect.Clf_DataBase
    x-LogDatabase = Clf_Connect.Clf_LogDataBase
    x-ip = Clf_Connect.Clf_IP
    x-service = Clf_Connect.Clf_Service
    x-protocol = Clf_Connect.Clf_Protocol
    x-user = Clf_Connect.Clf_User
    x-password = Clf_Connect.Clf_Password.

/* Fijamos el nombre de la base de datos */
x-LogDatabase = "continental".

ASSIGN
    x-Connection = "-db " + x-database + " " +
    "-ld " + x-logdatabase + " " +
    "-H " + x-ip + " " +
    "-S " + x-service + " " +
    "-U " + x-user + " " +
    "-P " + x-password.

CONNECT VALUE(x-connection) NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMensaje = "No se pudo conectar a la base de datos" + CHR(10) +
        "Revisar los parámetros de conexión" + CHR(10) +
        x-Connection.
    RETURN 'ADM-ERROR'.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Disconnect_Continental) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Disconnect_Continental Procedure 
PROCEDURE Disconnect_Continental :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST Clf_Connect NO-LOCK NO-ERROR.
IF NOT AVAILABLE Clf_Connect THEN RETURN.

DEF VAR x-DataBase AS CHAR.
DEF VAR x-LogDataBase AS CHAR.
DEF VAR x-Ip AS CHAR.
DEF VAR x-Service AS CHAR.
DEF VAR x-Protocol AS CHAR.
DEF VAR x-User AS CHAR.
DEF VAR x-Password AS CHAR.


DEF VAR x-Connection AS CHAR.
ASSIGN
    x-Database = Clf_Connect.Clf_DataBase
    x-LogDatabase = Clf_Connect.Clf_LogDataBase
    x-ip = Clf_Connect.Clf_IP
    x-service = Clf_Connect.Clf_Service
    x-protocol = Clf_Connect.Clf_Protocol
    x-user = Clf_Connect.Clf_User
    x-password = Clf_Connect.Clf_Password.
/* Forzamos el ALIAS a continental */
x-LogDatabase = "continental".

ASSIGN
    x-Connection = "-db " + x-database + " " +
    "-ld " + x-logdatabase + " " +
    "-H " + x-ip + " " +
    "-S " + x-service + " " +
    "-U " + x-user + " " +
    "-P " + x-password.

DISCONNECT VALUE(x-LogDatabase).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Update_Continental) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Update_Continental Procedure 
PROCEDURE Update_Continental :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pCodigo AS CHAR.
DEF INPUT PARAMETER pTipo AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pClasificacion AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

IF LOOKUP(pCodigo, 'GENERAL,MAYORISTA,UTILEX') = 0 THEN RETURN 'OK'.

DISABLE TRIGGERS FOR LOAD OF continental.FacTabla.

FIND FIRST continental.FacTabla WHERE continental.FacTabla.codcia = s-codcia AND
    continental.FacTabla.tabla = "RANKVTA" AND
    continental.FacTabla.codigo = pCodMat
    EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
IF ERROR-STATUS:ERROR = YES AND LOCKED(continental.FacTabla) THEN DO:
    pMensaje = "Registro en uso por otro usuario" + CHR(10) +  ERROR-STATUS:GET-MESSAGE(1).
    RETURN 'ADM-ERROR'.
END.
IF NOT AVAILABLE(continental.FacTabla) THEN DO:
    CREATE continental.FacTabla.
    ASSIGN
        continental.FacTabla.codcia = s-codcia
        continental.FacTabla.tabla = "RANKVTA"
        continental.FacTabla.codigo = pCodMat
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje"}
        RETURN 'ADM-ERROR'. 
    END.
END.

CASE TRUE:
    WHEN pCodigo = "GENERAL" AND pTipo = "CAMPAÑA" THEN DO:
        ASSIGN continental.FacTabla.Campo-C[1] = pClasificacion.
    END.
    WHEN pCodigo = "GENERAL" AND pTipo = "NO CAMPAÑA" THEN DO:
        ASSIGN continental.FacTabla.Campo-C[4] = pClasificacion.
    END.
    WHEN pCodigo = "UTILEX" AND pTipo = "CAMPAÑA" THEN DO:
        ASSIGN continental.FacTabla.Campo-C[2] = pClasificacion.
    END.
    WHEN pCodigo = "UTILEX" AND pTipo = "NO CAMPAÑA" THEN DO:
        ASSIGN continental.FacTabla.Campo-C[5] = pClasificacion.
    END.
    WHEN pCodigo = "MAYORISTA" AND pTipo = "CAMPAÑA" THEN DO:
        ASSIGN continental.FacTabla.Campo-C[3] = pClasificacion.
    END.
    WHEN pCodigo = "MAYORISTA" AND pTipo = "NO CAMPAÑA" THEN DO:
        ASSIGN continental.FacTabla.Campo-C[6] = pClasificacion.
    END.
END CASE.
IF AVAILABLE(continental.FacTabla) THEN RELEASE continental.FacTabla.
RETURN 'OK'.
/*

FIND FIRST Factabla WHERE factabla.codcia = Almmmatg.codcia AND 
    factabla.tabla = 'RANKVTA' AND 
    factabla.codigo = almmmatg.codmat
    NO-LOCK NO-ERROR.

			Todos				Utilex/Institucional		Mayorista
Campaña			factabla.campo-c[1]		factabla.campo-c[2]		factabla.campo-c[3]
NO Campaña		factabla.campo-c[4]		factabla.campo-c[5]		factabla.campo-c[6]


*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

