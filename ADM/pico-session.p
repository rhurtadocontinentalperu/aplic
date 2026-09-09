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

DEFINE VAR x-codcia AS INT INIT 1.

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
         HEIGHT             = 5.42
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Pico-Programa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pico-Programa Procedure 
PROCEDURE Pico-Programa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pAplicacionID AS CHAR.
DEFINE INPUT PARAMETER pCodMnu AS CHAR.
DEFINE INPUT PARAMETER pPrograma AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

DEFINE VAR x-retval AS CHAR NO-UNDO.
DEFINE VAR x-hora AS CHAR NO-UNDO.
DEFINE VAR x-horaX AS DEC NO-UNDO.

x-retval = "OK".

IF /*USERID("DICTDB") <> "ADMIN" AND*/ USERID("DICTDB") <> "MASTER" THEN DO:
    SESSION:TIME-SOURCE = "integral".   /* Toma la fecha y hora del servidor de 'integral' */

    x-hora = STRING(TIME,'HH:MM:SS'). 
    x-hora = SUBSTRING(x-hora,1,5).
    x-hora = TRIM(REPLACE(x-hora,":",".")).
    x-horaX = DEC(x-hora).
    /*
    FIND FIRST PF-G002 WHERE PF-G002.Aplic-Id = pAplicacionID AND 
        pf-g002.codmnu = pCodMnu AND
        PF-G002.Programa = pPrograma NO-LOCK NO-ERROR.
    IF AVAILABLE PF-G002 AND (PF-G002.hInicio + PF-G002.hTermino) > 0 THEN DO:
        x-retval = "Esta fuera de horario de PICO y PROGRAMA - Hora del Servidor(" + STRING(TIME,'HH:MM:SS') + ")".
        IF x-horaX >= PF-G002.hInicio AND x-horaX <= PF-G002.hTermino THEN DO:
            x-retval = "OK".
        END.
    END.
    */
    x-retval = "OK".
END.

pRetVal = x-retval.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pico-session) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pico-session Procedure 
PROCEDURE pico-session :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pAplicacionID AS CHAR.
DEFINE INPUT PARAMETER pPrograma AS CHAR.
DEFINE INPUT PARAMETER pUserId AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

DEFINE VAR x-retval AS CHAR NO-UNDO.
DEFINE VAR x-hora AS CHAR NO-UNDO.
DEFINE VAR x-horaX AS DEC NO-UNDO.
                   
x-retval = "OK".
pRetVal = x-retval.

/*
    Ic - 27Abr2020, por indicacion de Daniel Llican se deshabilito por whatsapp
        indico que solo se habilita por campaña
*/

RETURN x-retval.        /* Ic - 27Abr2020 */

IF USERID("DICTDB") <> "ADMIN" AND USERID("DICTDB") <> "MASTER" THEN DO:
    FIND FIRST _user WHERE _user._userid = pUserId NO-LOCK NO-ERROR.
    IF AVAILABLE _user THEN DO:

        IF TRUE <> (_user._U-misc2[2] > "") THEN DO:
            /* x-retval = "Usuario aun no tiene definido si es parte de PICO SESSION". */
            /*MESSAGE "Sin Falg de Pico y Session".*/
        END.
        ELSE DO:
            IF TRIM(_user._U-misc2[2]) = "SI" THEN DO:

                SESSION:TIME-SOURCE = "integral".   /* Toma la fecha y hora del servidor de 'integral' */

                x-hora = STRING(TIME,'HH:MM:SS'). 
                x-hora = SUBSTRING(x-hora,1,5).
                x-hora = TRIM(REPLACE(x-hora,":",".")).
                x-horaX = DEC(x-hora).

                FIND FIRST usuario_horario WHERE usuario_horario.codcia = x-codcia AND
                                                    usuario_horario.usuario = pUserId
                                                    NO-LOCK NO-ERROR.
                IF AVAILABLE usuario_horario THEN DO:
                    x-retval = "Esta fuera de horario de PICO y SESSION - Hora del Servidor(" + STRING(TIME,'HH:MM:SS') + ")".

                    PICOSESSION:
                    FOR EACH usuario_horario WHERE usuario_horario.codcia = x-codcia AND
                                                    usuario_horario.usuario = pUserId AND 
                                                    usuario_horario.diadelasemana = 0 NO-LOCK:

                        FIND FIRST horario WHERE horario.codcia = x-codcia AND
                                                    horario.diadelasemana = usuario_horario.diadelasemana AND
                                                    horario.correlativo = usuario_horario.correlativo NO-LOCK NO-ERROR.
                        IF AVAILABLE horario THEN DO:
                            IF x-horaX >= horario.hinicio AND x-horaX <= horario.htermino THEN DO:
                                x-retval = "OK".
                                LEAVE PICOSESSION.
                            END.
                        END.
                    END.
                END.
                ELSE DO:
                    x-retval = "Usuario no tiene defino el horario de PICO y SESSION".
                END.
            END.
        END.
    END.
    ELSE DO:
        x-retval = "Usuario no esta registrado como usuario".
    END.
END.

pRetVal = x-retval.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

