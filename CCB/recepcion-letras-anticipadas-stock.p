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

DEFINE INPUT PARAMETER pCodCliente AS CHAR.
DEFINE INPUT PARAMETER pQletras AS INT.

DEFINE SHARED VAR s-codcia AS INT.

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
         HEIGHT             = 22.42
         WIDTH              = 94.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE BUFFER b-ccbstklet FOR ccbstklet.

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR" :

    FIND FIRST b-ccbstklet WHERE b-ccbstklet.codcia = s-codcia AND
                                    b-ccbstklet.codclie = pCodCliente NO-LOCK NO-ERROR.
    IF NOT AVAILABLE b-ccbstklet THEN DO:
        CREATE b-ccbstklet.
        ASSIGN b-ccbstklet.codcia = s-codcia
                b-ccbstklet.codclie = pCodCliente.
    END.
    ELSE DO:
        {lib/lock-genericov3.i
            &Tabla="b-ccbstklet"
            &Alcance="FIRST"
            &Condicion="b-ccbstklet.codcia = s-codcia AND b-ccbstklet.codclie = pCodCliente"
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
            &Accion="RETRY"
            &Mensaje="YES"
            &TipoError="UNDO, RETURN 'ADM-ERROR'"}   
    END.

    ASSIGN b-ccbstklet.qstklet = b-ccbstklet.qstklet + pQletras.

    RELEASE b-ccbstklet.

END.
RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


