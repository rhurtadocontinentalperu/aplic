&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CREPO FOR almcrepo.
DEFINE BUFFER B-DREPO FOR almdrepo.



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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

/* Sintaxis:

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
      TABLE: B-CREPO B "?" ? INTEGRAL almcrepo
      TABLE: B-DREPO B "?" ? INTEGRAL almdrepo
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Genera-RA-por-RAN) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-RA-por-RAN Procedure 
PROCEDURE Genera-RA-por-RAN :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       A partir de una RAN (Reposición Automática Nocturna)
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodAlm AS CHAR.        /* Almcrepo.CodAlm */
DEF INPUT PARAMETER pTipMov AS CHAR.        /* RAN */
DEF INPUT PARAMETER pNroDoc AS CHAR.        /* # del RAN */

DEF INPUT PARAMETER pFchEnt AS DATE.        /* TODAY + 2 */
DEF INPUT PARAMETER pGlosa AS CHAR.
DEF INPUT PARAMETER pVtaPuntual AS LOG.     /* NO */
DEF INPUT PARAMETER pMotivo AS CHAR.        /* RepAutomParam.Motivo */

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

IF TRUE <> (pTipMov > '') THEN RETURN 'ADM-ERROR'.
IF TRUE <> (pNroDoc > '') THEN RETURN 'ADM-ERROR'.

DEF VAR iCuenta AS INT NO-UNDO.
DEF VAR pCodDiv AS CHAR.
DEF VAR s-coddoc AS CHAR INIT 'R/A'.
DEF VAR s-tipmov AS CHAR INIT 'A'.

FIND B-CREPO WHERE B-CREPO.CodCia = s-codcia
    AND B-CREPO.CodAlm = pCodAlm
    AND B-CREPO.TipMov = pTipMov
    AND B-CREPO.NroSer = INTEGER(SUBSTRING(pNroDoc,1,3))
    AND B-CREPO.NroDoc = INTEGER(SUBSTRING(pNroDoc,4))
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CREPO THEN RETURN 'ADM-ERROR'.

FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = pCodAlm
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almacen THEN DO:
    pMensaje = 'Almacén: ' + pCodAlm + ' NO definido'.
    RETURN 'ADM-ERROR'.
END.
pCodDiv = Almacen.coddiv.

FIND FIRST Faccorre WHERE Faccorre.codcia = s-codcia
    AND Faccorre.coddoc = s-coddoc
    AND Faccorre.flgest = YES
    AND Faccorre.coddiv = pCodDiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccorre THEN DO:
    pMensaje = 'No se encuentra el correlativo para la división ' + s-coddoc + ' ' + pCodDiv.
    RETURN "ADM-ERROR".
END.

DEF VAR n-Items AS INT NO-UNDO.
DEF BUFFER B-MATG FOR Almmmatg.

pMensaje = "".
PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    {lib/lock-genericov3.i
        &Tabla="FacCorre"
        &Alcance="FIRST"
        &Condicion="Faccorre.codcia = s-codcia ~
            AND Faccorre.coddoc = s-coddoc ~
            AND Faccorre.flgest = YES ~
            AND Faccorre.coddiv = pCodDiv"
        &Bloqueo="EXCLUSIVE-LOCK"
        &Accion="RETRY"
        &Mensaje="YES"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"
        }
    /* CERRAMOS LA REFERENCIA (RAN) */
    FIND B-CREPO WHERE B-CREPO.CodCia = s-codcia
        AND B-CREPO.CodAlm = pCodAlm
        AND B-CREPO.TipMov = pTipMov
        AND B-CREPO.NroSer = INTEGER(SUBSTRING(pNroDoc,1,3))
        AND B-CREPO.NroDoc = INTEGER(SUBSTRING(pNroDoc,4))
        EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="iCuenta"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* OJO: SOLO SI HAY DISPONIBLE DESPACHO (DesStkDis > 0) */
    FOR EACH B-DREPO OF B-CREPO EXCLUSIVE-LOCK:
        ASSIGN
            B-DREPO.CanAten = B-DREPO.CanAten + B-DREPO.cangen.
    END.
    IF NOT CAN-FIND(FIRST B-DREPO OF B-CREPO WHERE B-DREPO.CanApro > B-DREPO.CanAten NO-LOCK)
        THEN ASSIGN B-CREPO.FlgEst = "C".

    /* Depuramos el temporal */
    FOR EACH B-DREPO OF B-CREPO EXCLUSIVE-LOCK WHERE B-DREPO.AlmPed = '998':
        DELETE B-DREPO.
    END.

    n-Items = 0.
    /* RHC 25/03/19 Definimos tope de registros */
    DEF VAR x-TopeRA AS DEC INIT 52 NO-UNDO.

    FIND FIRST AlmCfgGn WHERE AlmCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
    IF AVAILABLE AlmCfgGn AND AlmCfgGn.Libre_d01 > 0 THEN x-TopeRA = AlmCfgGn.Libre_d01.
    /* OJO: SOLO SI HAY DISPONIBLE DESPACHO (DesStkDis > 0) */
    FOR EACH B-DREPO OF B-CREPO NO-LOCK 
        BREAK BY B-DREPO.AlmPed BY Almmmatg.DesMar BY Almmmatg.DesMat:
        IF FIRST-OF(B-DREPO.AlmPed) OR n-Items >= x-TopeRA THEN DO:
            s-TipMov = "A".
            CREATE Almcrepo.
            ASSIGN
                almcrepo.CodCia = s-codcia
                almcrepo.TipMov = s-TipMov          /* OJO: Automático */
                almcrepo.AlmPed = B-DREPO.Almped
                almcrepo.CodAlm = pCodAlm
                almcrepo.FchDoc = TODAY
                almcrepo.FchVto = TODAY + 7
                almcrepo.Fecha = pFchEnt    /* Ic 13May2015*/
                almcrepo.Hora = STRING(TIME, 'HH:MM:SS')
                almcrepo.NroDoc = Faccorre.correlativo
                almcrepo.NroSer = Faccorre.nroser
                almcrepo.Usuario = s-user-id
                almcrepo.Glosa = pGlosa
                NO-ERROR.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="iCuenta"}
                UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
            END.
            ASSIGN
                almcrepo.VtaPuntual     = pVtaPuntual
                almcrepo.MotReposicion  = pMotivo.
            ASSIGN
                Faccorre.correlativo = Faccorre.correlativo + 1
                n-Items = 0.
            /* RHC 21/04/2016 Almacén de despacho CD? */
            IF CAN-FIND(FIRST TabGener WHERE TabGener.CodCia = s-codcia
                        AND TabGener.Clave = "ZG"
                        AND TabGener.Libre_c01 = Almcrepo.AlmPed    /* Almacén de Despacho */
                        AND TabGener.Libre_l01 = YES                /* CD */
                        NO-LOCK)
                THEN Almcrepo.FlgSit = "G".   /* Por Autorizar por Abastecimientos */
            /* ************************************** */
        END.
        CREATE Almdrepo.
        BUFFER-COPY B-DREPO TO Almdrepo
            ASSIGN
            almdrepo.ITEM   = n-Items + 1
            almdrepo.CodCia = almcrepo.codcia
            almdrepo.CodAlm = almcrepo.codalm
            almdrepo.TipMov = almcrepo.tipmov
            almdrepo.NroSer = almcrepo.nroser
            almdrepo.NroDoc = almcrepo.nrodoc
            almdrepo.CanReq = almdrepo.cangen
            almdrepo.CanApro = almdrepo.cangen
            NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
        n-Items = n-Items + 1.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

