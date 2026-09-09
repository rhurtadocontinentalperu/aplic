&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b-vtacdocu FOR VtaCDocu.
DEFINE TEMP-TABLE t-Detalle NO-UNDO LIKE logisdchequeo
       INDEX Idx00 AS PRIMARY CodMat.



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
DEF INPUT PARAMETER x-CodDoc AS CHAR.
DEF INPUT PARAMETER x-NroDoc AS CHAR.
DEF INPUT PARAMETER x-Embalado AS CHAR.
DEF INPUT PARAMETER x-CodPer AS CHAR.
DEF INPUT PARAMETER x-hora-inicio AS CHAR.
DEF INPUT PARAMETER x-fecha-inicio AS DATE.
DEF INPUT PARAMETER x-mesa AS CHAR.
DEF INPUT PARAMETER x-ConInconsistencias AS LOG.
DEFINE OUTPUT PARAMETER pMsg AS CHAR NO-UNDO.   

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

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
   Temp-Tables and Buffers:
      TABLE: b-vtacdocu B "?" ? INTEGRAL VtaCDocu
      TABLE: t-Detalle T "?" NO-UNDO INTEGRAL logisdchequeo
      ADDITIONAL-FIELDS:
          INDEX Idx00 AS PRIMARY CodMat
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.46
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE VAR x-numbultos AS INT.
DEFINE VAR x-codref AS CHAR.    /* O/D */
DEFINE VAR x-nroref AS CHAR.
DEFINE VAR x-Cuenta-Error AS INT NO-UNDO.

pMsg = "".
SESSION:SET-WAIT-STATE("GENERAL").
x-numbultos = 0.
GRABAR_INFO:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Bloqueamos la HPK */
    {lib/lock-genericov3.i ~
        &Tabla="Vtacdocu" ~
        &Alcance="FIRST" ~
        &Condicion="Vtacdocu.codcia = s-codcia AND ~
            Vtacdocu.coddiv = s-coddiv AND ~
            Vtacdocu.codped = x-Coddoc AND ~
            Vtacdocu.nroped = x-NroDoc" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMsg" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    IF Vtacdocu.FlgEst <> "P" THEN DO:
        pMsg = "La HPK ya no está pendiente".
        UNDO GRABAR_INFO, RETURN 'ADM-ERROR'.
    END.
    /* O/D */
    x-codref = vtacdocu.codref.
    x-nroref = vtacdocu.nroref.
    /* La O/D, OTR */
    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND 
        faccpedi.coddoc = x-codref AND
        faccpedi.nroped = x-nroref AND
        faccpedi.flgest <> 'A' NO-LOCK NO-ERROR.
    IF NOT AVAILABLE faccpedi THEN DO:
        pMsg = "La Orden ya no existe o está anulada".
        UNDO GRABAR_INFO, RETURN 'ADM-ERROR'.
    END.
    FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE Faccpedi THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMsg" &CuentaError="x-Cuenta-Error"}
        UNDO GRABAR_INFO, RETURN 'ADM-ERROR'.
    END.
    /* ******************************************************************************* */
    /* Actualizamos la cantidad CHEQUEADA en VtaDDocu,
        Si hay inconsistencias entonces VtaDDocu.CanPed <> VtaDDocu.CanPick
        Si NO hay inconsistencias entonces VtaDDocu.CanPed = VtaDDocu.CanPick
        */
    /* ******************************************************************************* */
    /* OJO: El Vtaddocu aún tiene en item FLETE */
    /* RHC 11/07/2020 A estas alturas no tiene ni SERVICIOS ni DROP SHIPPING */
    FOR EACH Vtaddocu OF Vtacdocu EXCLUSIVE-LOCK,
        FIRST Almmmatg OF Vtaddocu NO-LOCK,
        FIRST Almtfami OF Almmmatg NO-LOCK ON ERROR UNDO, THROW:
        ASSIGN 
            Vtaddocu.CanPick = 0.
        IF Almtfami.Libre_c01 = "SV" THEN Vtaddocu.CanPick = (Vtaddocu.CanPed * Vtaddocu.Factor).   /* FLETE en Unidades de Stock */
    END.
    EMPTY TEMP-TABLE t-Detalle.
    /* OJO: Logisdchequeo NO tiene FLETE */
    FOR EACH LogisDChequeo NO-LOCK WHERE LogisDChequeo.CodCia = s-CodCia
        AND LogisDChequeo.CodDiv = s-CodDiv
        AND LogisDChequeo.CodPed = x-CodDoc
        AND LogisDChequeo.NroPed = x-NroDoc:
        FIND t-Detalle WHERE t-Detalle.codmat = LogisDChequeo.codmat NO-ERROR.
        IF NOT AVAILABLE t-Detalle THEN CREATE t-Detalle.
        ASSIGN
            t-Detalle.codmat = LogisDChequeo.codmat
            t-Detalle.canped = t-Detalle.canped + LogisDChequeo.canped.     /* En unidades de Stock */
    END.
    FOR EACH Vtaddocu OF Vtacdocu EXCLUSIVE-LOCK, 
        FIRST t-Detalle NO-LOCK WHERE t-Detalle.CodMat = Vtaddocu.CodMat
        ON ERROR UNDO, THROW:
        ASSIGN Vtaddocu.canpick = t-Detalle.canped.                         /* En unidades de Stock*/
    END.
/*     FOR EACH t-Detalle NO-LOCK,                                                                       */
/*         EACH Vtaddocu OF Vtacdocu EXCLUSIVE-LOCK WHERE Vtaddocu.codmat = t-Detalle.codmat             */
/*         ON ERROR UNDO, THROW:                                                                         */
/*         ASSIGN Vtaddocu.canpick = t-Detalle.canped.                         /* En unidades de Stock*/ */
/*     END.                                                                                              */
    /* ******************************************************************************* */
    /* ******************************************************************************* */
    CASE x-ConInconsistencias:
        WHEN NO THEN DO:
            /* ******************************************************************************* */
            /* Control por O/D */
            /* ******************************************************************************* */
            x-numbultos = 0.
            FOR EACH LogisdChequeo NO-LOCK WHERE logisdchequeo.CodCia = s-CodCia
                AND logisdchequeo.CodDiv = s-CodDiv
                AND logisdchequeo.CodPed = x-CodDoc
                AND logisdchequeo.NroPed = x-NroDoc,
                FIRST Almmmatg OF LogisdChequeo NO-LOCK
                BREAK BY logisdchequeo.Etiqueta:
                IF FIRST-OF(logisdchequeo.Etiqueta) THEN DO:
                    x-numbultos = x-numbultos + 1.
                    /* RHC 24/04/2020 Mejora en ControlOD */
                    /* Solo debe haber un registro por Etiqueta */
                    FIND FIRST ControlOD WHERE ControlOD.codcia = s-codcia AND 
                        ControlOD.coddoc = faccpedi.coddoc AND 
                        ControlOD.nrodoc = faccpedi.nroped AND 
                        ControlOD.nroetq = logisdchequeo.Etiqueta AND
                        ControlOD.coddiv = s-coddiv 
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE ControlOD THEN DO:
                        FIND CURRENT ControlOD EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                        IF NOT AVAILABLE ControlOD THEN DO:
                            pMsg = "Imposible actualizar la tabla ControlOD".
                            UNDO GRABAR_INFO, RETURN 'ADM-ERROR'.
                        END.
                        DELETE ControlOD.
                    END.
                    CREATE ControlOD.
                    ASSIGN 
                        ControlOD.codcia = s-codcia
                        ControlOD.coddiv = s-coddiv
                        ControlOD.coddoc = faccpedi.coddoc
                        ControlOD.nrodoc = faccpedi.nroped
                        ControlOD.nroetq = logisdchequeo.Etiqueta.
                END.
                /* Control de Los bultos */
                ASSIGN  
                    ControlOD.codcli = faccpedi.codcli
                    ControlOD.codalm = faccpedi.codalm
                    ControlOD.fchdoc = faccpedi.fchped
                    ControlOD.fchchq = TODAY
                    ControlOD.horchq = STRING(TIME,"HH:MM:SS")
                    ControlOD.nomcli = Faccpedi.nomcli
                    ControlOD.usuario = Faccpedi.usuario
                    ControlOD.cantart = ControlOD.cantart + logisdchequeo.CanPed.
                ASSIGN
                    ControlOD.pesart = ControlOD.pesart + (logisdchequeo.canped * almmmatg.pesmat).
            END.
            /* ******************************************************************************* */
            /* Control de Bultos */
            /* RHC 31/01/2020 Control de HPK por Bultos */
            /* Se supone que TODOS los bultos de aquí SON NUEVOS */
            /* ******************************************************************************* */
            FIND FIRST Ccbcbult WHERE ccbcbult.codcia = s-codcia
                AND ccbcbult.coddiv = s-coddiv
                AND ccbcbult.coddoc = faccpedi.coddoc
                AND ccbcbult.nrodoc = faccpedi.nroped
                AND ccbcbult.CHR_05 = Vtacdocu.codped + ',' + Vtacdocu.nroped   /* HPK */
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Ccbcbult THEN DO:
                CREATE Ccbcbult.
            END.
            ELSE DO:
                FIND CURRENT Ccbcbult EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                IF ERROR-STATUS:ERROR = YES THEN DO:
                    {lib/mensaje-de-error.i &MensajeError="pMsg"}
                    UNDO GRABAR_INFO, RETURN 'ADM-ERROR'.
                END.
            END.
            ASSIGN  
                ccbcbult.codcia = s-codcia 
                ccbcbult.coddiv = s-coddiv
                ccbcbult.coddoc = faccpedi.coddoc
                ccbcbult.nrodoc = faccpedi.nroped
                ccbcbult.bultos = x-numbultos
                ccbcbult.codcli = faccpedi.codcli
                ccbcbult.fchdoc = TODAY
                ccbcbult.nomcli = faccpedi.nomcli
                ccbcbult.CHR_01 = 'P'
                ccbcbult.usuario = s-user-id
                ccbcbult.CHR_05 = (Vtacdocu.codped + ',' + Vtacdocu.nroped) /* OJO >>> HPK */
                .
            /* ******************************************************************************* */
            /* Estado de la HPK */
            /* ******************************************************************************* */
            ASSIGN 
                Vtacdocu.flgsit = IF(x-Embalado = 'SI') THEN 'PE' ELSE 'PC'
                Vtacdocu.libre_c04 = x-CodPer + "|" + STRING(TODAY,"99/99/9999") + "|" + STRING(TIME,"HH:MM:SS").
            IF Vtacdocu.FecSac = ? THEN
                ASSIGN
                    Vtacdocu.horsac = x-hora-inicio
                    Vtacdocu.fecsac = x-fecha-inicio.
            /* ******************************************************************************* */
            /* Control LPN Supermercados */
            /* ******************************************************************************* */
            RUN Control-LPN (INPUT faccpedi.coddoc, INPUT faccpedi.nroped) NO-ERROR.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                pMsg = "No se pudo generar los LPNs".
                UNDO GRABAR_INFO, RETURN 'ADM-ERROR'.
            END.
            /* ******************************************************************************* */
            /* Tarea Cerrada */    
            /* ******************************************************************************* */
            FIND FIRST chktareas WHERE chktareas.codcia = s-codcia AND
                chktareas.coddiv = s-coddiv AND 
                chktareas.coddoc = x-CodDoc AND
                chktareas.nroped = x-NroDoc AND
                chktareas.mesa = x-Mesa EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF NOT AVAILABLE chktareas THEN DO:
                pMsg = "No se pudo actualizar la tarea (ChkTareas)".
                UNDO GRABAR_INFO, RETURN 'ADM-ERROR'.
            END.
            ASSIGN 
                chktareas.flgest = IF(x-Embalado = 'SI') THEN 'E' ELSE 'T'
                chktareas.fechafin = TODAY
                chktareas.horafin = STRING(TIME,"HH:MM:SS")
                chktareas.usuariofin = s-user-id.
            /* ******************************************************************************* */
            /* Actualizamos FACCPEDI para disparar los triggers */  
            /* ******************************************************************************* */
            /* Si todas las HPK tienen FlgSIt = "PC" entonces la O/D tiene que ser FlgSit = "PC" */
            DEF VAR lOrdenLista AS LOG NO-UNDO.
            lOrdenLista = YES.
            FOR EACH b-vtacdocu NO-LOCK WHERE b-vtacdocu.codcia = VtaCDocu.codcia
                AND b-vtacdocu.coddiv = VtaCDocu.coddiv
                AND b-vtacdocu.codped = VtaCDocu.codped      /* HPK */
                AND b-vtacdocu.codref = VtaCDocu.codref      /* O/D OTR */
                AND b-vtacdocu.nroref = VtaCDocu.nroref:
                IF b-vtacdocu.flgsit <> "PC" THEN DO:
                    lOrdenLista = NO.
                    LEAVE.
                END.
            END.
            /*
            IF lOrdenLista = YES THEN ASSIGN Faccpedi.FlgSit = "PC".    /* Cierre de Chequeo */
            ASSIGN
                Faccpedi.Libre_f01 = TODAY.
            */
            /* En corrdinacion con RUBEN el 20Ago2021 */
            IF lOrdenLista = YES THEN DO:
                ASSIGN Faccpedi.FlgSit = "PC"    /* Cierre de Chequeo */
                        Faccpedi.usrchq = s-user-id
                        Faccpedi.fchchq = TODAY
                        Faccpedi.horchq = STRING(TIME,'HH:MM:SS')
                        /*
                        Para el inicio de chequeo no sirve x que es picking x ruta
                        Faccpedi.horsac = x-HorIni
                        Faccpedi.fecsac = x-FchIni
                        */
                        .
            END.
            ASSIGN
                Faccpedi.Libre_f01 = TODAY.            

        END.
        WHEN YES THEN DO:
            /* ******************************************************************************* */
            /* Estado de la HPK */
            /* ******************************************************************************* */
            ASSIGN 
                Vtacdocu.flgsit = "PO"      /* Chequeo Observado */
                Vtacdocu.libre_c04 = x-CodPer + "|" + STRING(TODAY,"99/99/9999") + "|" + STRING(TIME,"HH:MM:SS").
            IF Vtacdocu.FecSac = ? THEN
                ASSIGN
                    Vtacdocu.horsac = x-hora-inicio
                    Vtacdocu.fecsac = x-fecha-inicio.
            /* ******************************************************************************* */
            /* Observar */    
            /* ******************************************************************************* */
            FIND FIRST chktareas WHERE chktareas.codcia = s-codcia AND
                chktareas.coddiv = s-coddiv AND 
                chktareas.coddoc = x-CodDoc AND
                chktareas.nroped = x-NroDoc AND
                chktareas.mesa = x-Mesa EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF NOT AVAILABLE chktareas THEN DO:
                pMsg = "No se pudo actualizar la tarea (ChkTareas)".
                UNDO GRABAR_INFO, LEAVE GRABAR_INFO.
            END.
            ASSIGN 
                chktareas.flgest = "O"      /* Observada */
                chktareas.fechafin = TODAY
                chktareas.horafin = STRING(TIME,"HH:MM:SS")
                chktareas.usuariofin = s-user-id.
        END.
    END CASE.
END. /* TRANSACTION block */
IF AVAILABLE Faccpedi THEN RELEASE faccpedi.
IF AVAILABLE Vtacdocu THEN RELEASE vtacdocu.
IF AVAILABLE ChkTareas THEN RELEASE chktareas.
IF AVAILABLE Ccbcbult THEN RELEASE ccbcbult.
IF AVAILABLE CONTROLOD THEN RELEASE ControlOD.
SESSION:SET-WAIT-STATE("").
RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Control-LPN) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Control-LPN Procedure 
PROCEDURE Control-LPN :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ************************************************ */
/* RHC 18/11/2015 CONTROL DE LPN PARA SUPERMERCADOS */
/* ************************************************ */

DEFINE INPUT PARAMETER xCodDoc AS CHAR.
DEFINE INPUT PARAMETER xNroDoc AS CHAR.

DEFINE BUFFER pedido FOR faccpedi.
DEFINE BUFFER cotizacion FOR faccpedi.
DEFINE BUFFER x-faccpedi FOR faccpedi.

/* La Orden */
FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                            x-faccpedi.coddoc = xCodDoc AND
                            x-faccpedi.nroped = xNroDoc NO-LOCK NO-ERROR.

/* Ubicamos el registro de control de la Orden de Compra */
FIND PEDIDO WHERE PEDIDO.codcia = x-Faccpedi.codcia
                    AND PEDIDO.coddoc = x-Faccpedi.codref
                    AND PEDIDO.nroped = x-Faccpedi.nroref NO-LOCK NO-ERROR.
IF NOT AVAILABLE PEDIDO THEN RETURN.

/* La cotizacion */
FIND FIRST COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
                    AND COTIZACION.coddoc = PEDIDO.codref
                    AND COTIZACION.nroped = PEDIDO.nroref NO-LOCK NO-ERROR.
IF NOT AVAILABLE COTIZACION THEN RETURN.

/* Control para SuperMercados */
FIND FIRST SupControlOC  WHERE SupControlOC.CodCia = COTIZACION.codcia
    AND SupControlOC.CodCli = COTIZACION.codcli
    AND SupControlOC.OrdCmp = COTIZACION.OrdCmp 
    AND SupControlOC.CodDiv = COTIZACION.coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE SupControlOC THEN RETURN.

/* Comienza la Transacción */
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
  {lib/lock-genericov3.i ~
      &Tabla="SupControlOC" ~
      &Alcance="FIRST" ~
      &Condicion="SupControlOC.CodCia = COTIZACION.codcia ~
      AND SupControlOC.CodCli = COTIZACION.codcli ~
      AND SupControlOC.OrdCmp = COTIZACION.OrdCmp" ~
      AND SupControlOC.CodDiv = COTIZACION.coddiv ~
      &Bloqueo="EXCLUSIVE-LOCK" 
      &Accion="RETRY" ~
      &Mensaje="YES" ~
      &TipoError="RETURN ERROR" ~
      }
  FOR EACH ControlOD EXCLUSIVE-LOCK WHERE ControlOD.CodCia = x-Faccpedi.codcia
      AND ControlOD.CodDoc = x-Faccpedi.coddoc
      AND ControlOD.NroDoc = x-Faccpedi.nroped
      AND ControlOD.CodDiv = s-CodDiv
      ON ERROR UNDO, THROW:
      ASSIGN
          ControlOD.LPN1 = "5000"  
          ControlOD.LPN2 = FILL("0",10) + TRIM(COTIZACION.OrdCmp)
          ControlOD.LPN2 = SUBSTRING(ControlOD.LPN2, LENGTH(ControlOD.LPN2) - 10 + 1, 10)
          ControlOD.LPN    = "POR DEFINIR"
          ControlOD.OrdCmp = COTIZACION.OrdCmp
          ControlOD.Sede   = COTIZACION.Ubigeo[1].
  END.
END.
IF AVAILABLE(SupControlOC) THEN RELEASE SupControlOC.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

