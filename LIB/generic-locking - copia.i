&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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

/*
{lib/generic-locking.i ~
&TableName=""
&VarScope="[FIRST][LAST]NEXT][PREV][CURRENT]"       /* OPCIONAL */
&Condicion="[TRUE]"                                 /* OPCIONAL */
&VarMessage=""                                      /* OPCIONAL LocalMensaje */
&TypeLocking="[EXCLUSIVE-LOCK][NO-ERROR][NO-WAIT]"  /* OPCIONAL NO-LOCK */
&VarCounter=""                                      /* OPCIONAL LocalCounter */
*/

&IF DEFINED(Condition) &THEN
&ELSE
    &SCOPED-DEFINE Condition (TRUE)
&ENDIF

&IF DEFINED(VarMessage) &THEN
&ELSE
    DEF VAR LocalMensaje AS CHAR INITIAL '' NO-UNDO.
    &SCOPED-DEFINE VarMessage LocalMensaje
&ENDIF

&IF DEFINED(VarCounter) &THEN
&ELSE
    DEF VAR LocalCounter AS INTE INIT 0 NO-UNDO.
    &SCOPED-DEFINE VarCounter LocalCounter
&ENDIF

&IF DEFINED(TypeLocking) &THEN
&ELSE
    &SCOPED-DEFINE TypeLocking NO-LOCK
&ENDIF

DEF VAR LocalError AS INTE INIT 0 NO-UNDO.

/* Control de Bloqueo */
{&VarCounter} = -1.
REPEAT ON ERROR undo, RETRY ON STOP UNDO, RETRY:
    {&VarCounter} = {&VarCounter} + 1.
    IF {&VarCounter} >= 5 THEN LEAVE.

    {&VarMessage} = "".

    &IF DEFINED(VarScope) &THEN
    FIND {&VarScope} {&TableName} WHERE {&Condition} {&TypeLocking}.
    &ELSE
    FIND {&TableName} WHERE {&Condition} {&TypeLocking}.
    &ENDIF

    IF AVAILABLE({&TableName}) THEN LEAVE.
    
    /*CATCH oneError AS PROGRESS.Lang.SysError:*/
    CATCH oneError AS PROGRESS.Lang.Error:
        /* ************************************** */
        /* NO PASA POR AQUI SI USAS EL "NO-ERROR" */
        /* ************************************** */
        {&VarMessage} = "Error inesperado con la tabla: " + "{&TableName}".
        {&VarMessage} = {&VarMessage} + "~n~n" + "Mensaje de error: " + "~n" + oneError:getmessage(1).
        DELETE OBJECT oneError.
    END CATCH.
    FINALLY:
        /* ************************************************************************************** */
        /* SI USAS EL "NO-ERROR" NO CARGA EL MENSAJE DE ERROR, ASÍ QUE DEBE HABER UN CONTROL AQUÍ */
        /* ************************************************************************************** */
        IF TRUE <> ({&VarMessage} > "") AND NOT AVAILABLE {&TableName} THEN DO:
            {&VarMessage} = "Error inesperado con la tabla: " + "{&TableName}".
            DO LocalError = 1 TO ERROR-STATUS:NUM-MESSAGES:
                IF LocalError = 1 THEN {&VarMessage} = {&VarMessage} + "~n~n" + "Mensaje de error: ".
                {&VarMessage} = {&VarMessage} + "~n" + ERROR-STATUS:GET-MESSAGE(LocalError).
            END.
        END.
        LEAVE.
    END FINALLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 5.46
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


