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
         HEIGHT             = 5
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* Parámetros de entrada */
DEF INPUT PARAMETER pcEvento AS CHAR.           /* WRITE DELETE */
DEF INPUT PARAMETER pcCodDiv AS CHAR.           /* División del Evento */
DEF INPUT PARAMETER pcBlock AS CHAR.            /* Terminal del vendedor */
DEF INPUT PARAMETER pcCodCli AS CHAR.           /* Cliente */
DEF INPUT PARAMETER piEstado AS INTE.           /* Estado actual */
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.  /* Mensaje de error */

DEF SHARED VAR s-codcia AS INTE.                /* 001: Continental SAC */
DEF SHARED VAR s-user-id AS CHAR.

/* Actualizamos la atención */
/*
  Tabla: "Almacen"
  Alcance: [{"FIRST" | "LAST" | "CURRENT" }]   Valor opcional
  Condicion: "Almacen.codcia = s-codcia AND Almacen.codalm = s-codalm"
  Bloqueo: { "NO-LOCK" | "SHARED-LOCK" | "EXCLUSIVE-LOCK" ("NO-ERROR") ("NO-WAIT")}
  Accion: { "RETRY" | "LEAVE" }
  Mensaje: { "YES" | "NO" }
  txtMensaje: "pMensaje"    Valor Opcional
  TipoError: { "[UNDO,] RETURN {'ADM-ERROR' | ERROR | }" | "NEXT" | "LEAVE" }
  &Intentos="5"
*/
DEF BUFFER bControl FOR even_control_turno.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    CASE pcEvento:
        WHEN "WRITE" THEN DO:
            /* Puede que exista o no el registro */
            FIND FIRST bControl WHERE bControl.CodCia = s-codcia AND 
                bControl.CodDiv = pcCodDiv AND 
                bControl.Block = pcBlock AND 
                bControl.CodCli = pcCodCli AND 
                bControl.Fecha = TODAY
                NO-LOCK NO-ERROR NO-WAIT.
            IF NOT AVAILABLE bControl THEN DO:
                /* Nuevo Registro */
                CREATE even_control_turno.
                ASSIGN
                    even_control_turno.CodCia = s-codcia 
                    even_control_turno.CodDiv = pcCodDiv 
                    even_control_turno.Block = pcBlock 
                    even_control_turno.CodCli = pcCodCli.
            END.
            ELSE DO:
                /* Registro existente */
                {lib/lock-genericov3.i ~
                    &Tabla="even_control_turno" ~
                    &Alcance="FIRST" ~
                    &Condicion="even_control_turno.CodCia = s-codcia AND ~
                    even_control_turno.CodDiv = pcCodDiv AND ~
                    even_control_turno.Block = pcBlock AND ~ 
                    even_control_turno.CodCli = pcCodCli AND ~
                    even_control_turno.Fecha = TODAY " ~
                    &Bloqueo="EXCLUSIVE-LOCK NO-ERROR NO-WAIT" ~
                    &Accion="RETRY" ~
                    &Mensaje="NO" ~
                    &txtMensaje="pMensaje" ~
                    &TipoError="RETURN 'ADM-ERROR'" ~
                    }
            END.
            ASSIGN
                even_control_turno.Estado = piEstado
                even_control_turno.Usuario = s-user-id
                even_control_turno.Fecha = TODAY
                even_control_turno.Hora = STRING(TIME,"HH:MM:SS")
                .
        END.
        WHEN "DELETE" THEN DO:
            /* Puede que exista o no el registro */
            FIND FIRST bControl WHERE bControl.CodCia = s-codcia AND 
                bControl.CodDiv = pcCodDiv AND 
                bControl.Block = pcBlock AND 
                bControl.CodCli = pcCodCli AND 
                bControl.Fecha = TODAY AND
                bCOntrol.Estado = piEstado
                NO-LOCK NO-ERROR NO-WAIT.
            IF AVAILABLE bControl THEN DO:
                FIND CURRENT bControl EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                IF ERROR-STATUS:ERROR = YES THEN DO:
                    {lib/mensaje-de-error.i ~
                        &MensajeError="pMensaje" }
                    RETURN 'ADM-ERROR'.                        
                END.
                DELETE bControl.
            END.
        END.
    END CASE.
    RELEASE bControl.
END.
RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


