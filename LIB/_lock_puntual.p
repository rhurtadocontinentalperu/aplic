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
         HEIGHT             = 6.31
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-MASTER-TRANSACTION) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MASTER-TRANSACTION Procedure 
PROCEDURE MASTER-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroSer AS INTE.
DEF OUTPUT PARAMETER pNroDoc AS INTE.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

MESSAGE pcoddoc pnroser.

CASE TRUE:
    WHEN pCodDoc = "COT" THEN DO:
        RUN _Lock_Cotizacion (INPUT pCodDoc,
                              INPUT pNroSer,
                              OUTPUT pNroDoc,
                              OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    END.
END CASE.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-_Lock_Cotizacion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _Lock_Cotizacion Procedure 
PROCEDURE _Lock_Cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Se buscará un correlativo que aún no ha sido generado por otro usuario
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroSer AS INTE.
DEF OUTPUT PARAMETER pNroDoc AS INTE.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

MESSAGE pcoddoc pnroser.

/* 1ro Bloqueamos */
  {lib/lock-genericov3.i ~
      &Tabla="FacCorre" ~
      &Condicion="FacCorre.codcia = s-codcia" + " AND " + ~
      "Faccorre.coddoc = pCodDoc" + " AND " + ~
      "Faccorre.nroser = pNroSer" ~
      &Alcance="FIRST" ~
      &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
      &Accion="RETRY" ~
      &Mensaje="NO" ~
      &txtMensaje="pMensaje" ~
      &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
      }

/* 2do Capturamos correlativo */
  ASSIGN
      pNroDoc = FacCorre.Correlativo.

/* 3ro Actualizamos el correlativo */
  ASSIGN
      FacCorre.Correlativo = FacCorre.Correlativo + 1.

/* 4to Desbloqueamos correlativo */
  RELEASE FacCorre.

  RETURN 'OK'.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

