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
         HEIGHT             = 4.85
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  **************************** */
/* SIMILAR AL LOCK-GENERICOV21.I PERO CON BUSCA SI HAY UN REGISTRO LIBRE */
/* EL REGISTRO DE BUSQUEDA DEBE EXISTIR, SI NO FALLA LA RUTINA           */

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

DEF VAR LocalCounter AS INTEGER INITIAL 0 NO-UNDO.
DEF VAR ix AS INTEGER NO-UNDO.
/*DEF VAR LocalMensaje AS CHAR INITIAL "" NO-UNDO.*/
&IF DEFINED(txtMensaje) &THEN
&ELSE
DEF VAR LocalMensaje AS CHAR INITIAL "" NO-UNDO.
&SCOPED-DEFINE txtMensaje LocalMensaje
&ENDIF

LocalCounter = -1.
GetLock:
REPEAT ON STOP UNDO, {&Accion} ON ERROR UNDO, {&Accion}:
    {&txtMensaje} = "".
    &IF DEFINED(Intentos) &THEN
        LocalCounter = LocalCounter + 1.
        IF LocalCounter >= {&Intentos} THEN LEAVE GetLock.    /* 5 intentos máximo */
    &ELSE 
        LocalCounter = LocalCounter + 1.
        IF LocalCounter >= 5 THEN LEAVE GetLock.    /* 5 intentos máximo */
    &ENDIF
    &IF DEFINED(Alcance) &THEN
        FIND {&Alcance} {&Tabla} WHERE {&Condicion} {&Bloqueo}.
    &ELSE
        FIND {&Tabla} WHERE {&Condicion} {&Bloqueo}.
    &ENDIF
    IF AVAILABLE {&Tabla} THEN LEAVE.
    IF NOT AVAILABLE {&Tabla} 
        OR AMBIGUOUS {&Tabla}       /* Llave Duplicada */
        OR LOCKED({&Tabla})     /* Bloqueado por otro usuario */
        THEN DO:      
        IF ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
            {&txtMensaje} = ERROR-STATUS:GET-MESSAGE(1).
            DO ix = 2 TO ERROR-STATUS:NUM-MESSAGES:
                {&txtMensaje} = {&txtMensaje} + CHR(10) + ERROR-STATUS:GET-MESSAGE(ix).
            END.
        END.
        IF {&Mensaje} = YES THEN DO:
            MESSAGE {&txtMensaje} VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        END.
        LEAVE GetLock.
    END.
    PAUSE 2 NO-MESSAGE.
    CATCH oneError AS PROGRESS.Lang.SysError:
        {&txtMensaje} = oneError:GetMessage(1).
        IF {&Mensaje} = YES THEN DO:
            MESSAGE {&txtMensaje} VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        END.
        DELETE OBJECT oneError.
    END CATCH.
    /* *********************************************************************************** */
    /* CONTROL DE ERRORES */
    /* *********************************************************************************** */
    FINALLY:
        IF NOT AVAILABLE {&Tabla} AND TRUE <> ({&txtMensaje} > '') THEN DO:
            {&txtMensaje} = "NO se pudo bloquear la tabla " + "{&Tabla}". 
        END.
    END FINALLY.
END.
&IF DEFINED(Intentos) &THEN
    IF LocalCounter >= {&Intentos} OR NOT AVAILABLE {&Tabla} THEN {&TipoError}.
&ELSE
    IF LocalCounter >= 5 OR NOT AVAILABLE {&Tabla} THEN {&TipoError}.
&ENDIF
/* RHC 17/04/2017 Solo en caso de la tabla FACCORRE */
&IF TRIM(CAPS("{&Tabla}")) = "FACCORRE" &THEN 
    IF ({&Tabla}.NroIni > 0 AND {&Tabla}.Correlativo < {&Tabla}.NroIni) THEN DO:
        {&txtMensaje} = 'Correlativo NO válido para este comprobante' + CHR(10) +
                      'Comprobante: ' + {&Tabla}.CodDoc + CHR(10) +
                      'N° de serie: ' + STRING({&Tabla}.NroSer,'999') + CHR(10) +
                      'N° correlativo: ' + STRING({&Tabla}.Correlativo) + CHR(10) + 
                      'Válidos desde el ' + STRING({&Tabla}.NroIni) + ' hasta el ' + STRING({&Tabla}.NroFin).
        IF {&Mensaje} = YES THEN DO:
            MESSAGE {&txtMensaje} VIEW-AS ALERT-BOX ERROR.
        END.
        {&TipoError}.
    END.
    IF ({&Tabla}.NroFin > 0 AND {&Tabla}.Correlativo > {&Tabla}.NroFin) THEN DO:
        IF {&Tabla}.FlgCic = NO THEN DO:
            {&txtMensaje} = 'Correlativo NO válido para este comprobante' + CHR(10) +
                          'Comprobante: ' + {&Tabla}.CodDoc + CHR(10) +
                          'N° de serie: ' + STRING({&Tabla}.NroSer,'999') + CHR(10) +
                          'N° correlativo: ' + STRING({&Tabla}.Correlativo) + CHR(10) + 
                          'Válidos desde el ' + STRING({&Tabla}.NroIni) + ' hasta el ' + STRING({&Tabla}.NroFin).
            IF {&Mensaje} = YES THEN DO:
                MESSAGE {&txtMensaje} VIEW-AS ALERT-BOX ERROR.
            END.
            {&TipoError}.
        END.
        IF {&Tabla}.FlgCic = YES THEN DO:
            IF {&Tabla}.NroIni > 0 THEN {&Tabla}.Correlativo = {&Tabla}.NroIni.
            ELSE {&Tabla}.Correlativo = 1.
        END.
    END.
&ENDIF

/* IF TRIM(CAPS("{&Tabla}")) = "FACCORRE" THEN DO:                                                                   */
/*     IF ({&Tabla}.NroIni > 0 AND {&Tabla}.Correlativo < {&Tabla}.NroIni) THEN DO:                                  */
/*         {&txtMensaje} = 'Correlativo NO válido para este comprobante' + CHR(10) +                                 */
/*                       'Comprobante: ' + {&Tabla}.CodDoc + CHR(10) +                                               */
/*                       'N° de serie: ' + STRING({&Tabla}.NroSer,'999') + CHR(10) +                                 */
/*                       'N° correlativo: ' + STRING({&Tabla}.Correlativo) + CHR(10) +                               */
/*                       'Válidos desde el ' + STRING({&Tabla}.NroIni) + ' hasta el ' + STRING({&Tabla}.NroFin).     */
/*         IF {&Mensaje} = YES THEN DO:                                                                              */
/*             MESSAGE {&tMensaje} VIEW-AS ALERT-BOX ERROR.                                                          */
/*         END.                                                                                                      */
/*         {&TipoError}.                                                                                             */
/*     END.                                                                                                          */
/*     IF ({&Tabla}.NroFin > 0 AND {&Tabla}.Correlativo > {&Tabla}.NroFin) THEN DO:                                  */
/*         IF {&Tabla}.FlgCic = NO THEN DO:                                                                          */
/*             {&txtMensaje} = 'Correlativo NO válido para este comprobante' + CHR(10) +                             */
/*                           'Comprobante: ' + {&Tabla}.CodDoc + CHR(10) +                                           */
/*                           'N° de serie: ' + STRING({&Tabla}.NroSer,'999') + CHR(10) +                             */
/*                           'N° correlativo: ' + STRING({&Tabla}.Correlativo) + CHR(10) +                           */
/*                           'Válidos desde el ' + STRING({&Tabla}.NroIni) + ' hasta el ' + STRING({&Tabla}.NroFin). */
/*             IF {&Mensaje} = YES THEN DO:                                                                          */
/*                 MESSAGE {&tMensaje} VIEW-AS ALERT-BOX ERROR.                                                      */
/*             END.                                                                                                  */
/*             {&TipoError}.                                                                                         */
/*         END.                                                                                                      */
/*         IF {&Tabla}.FlgCic = YES THEN DO:                                                                         */
/*             IF {&Tabla}.NroIni > 0 THEN {&Tabla}.Correlativo = {&Tabla}.NroIni.                                   */
/*             ELSE {&Tabla}.Correlativo = 1.                                                                        */
/*         END.                                                                                                      */
/*     END.                                                                                                          */
/* END.                                                                                                              */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


