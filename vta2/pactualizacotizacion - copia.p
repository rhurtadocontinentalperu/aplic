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

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pTipo  AS CHAR.     /* D: descarga(-)  C: carga(+) */
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

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
         HEIGHT             = 4.23
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* ACTUALIZA LA COTIZACION EN BASE AL PEDIDO AL CREDITO */
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE BUFFER B-CPEDI FOR FacCPedi.

/* El pedido */
FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN DO:
    /*pError = "Error de puntero " + STRING(pRowid).*/
    RETURN 'ADM-ERROR'.
END.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Bloqueamos la cotizacion */
    {lib/lock-genericov3.i ~
        &Tabla="B-CPEDI" ~
        &Alcance="FIRST" ~
        &Condicion="B-CPedi.CodCia=FacCPedi.CodCia ~
                AND B-CPedi.CodDiv=FacCPedi.CodDiv ~
                AND B-CPedi.CodDoc=FacCPedi.CodRef ~
                AND B-CPedi.NroPed=FacCPedi.NroRef" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pError" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        }
    /* NO ACTUALIZAMOS LAS PROMOCIONES */
    RLOOP:
    FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.Libre_c05 <> "OF":
        FIND FIRST B-DPedi OF B-CPedi WHERE B-DPedi.CodMat = Facdpedi.CodMat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-DPedi THEN NEXT.
        FIND CURRENT B-DPedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE B-DPedi THEN DO:
            pError = "NO se pudo actualizar: " + B-CPEDI.coddoc + " " + B-CPEDI.nroped.
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
        CASE pTipo:
            WHEN "D" THEN DO:
                IF (B-DPedi.CanAte - Facdpedi.CanPed) < 0 THEN DO:
                    /* Revisando saldos */
                    RUN Revisando-Saldos.
                    /* **************** */
                END.
                B-DPedi.CanAte = B-DPedi.CanAte - Facdpedi.CanPed.
                IF B-DPEDI.CanAte < 0 THEN DO:
                    pError = 'Se ha detectado un error al extornar el producto ' + B-DPEDI.codmat + CHR(10) +
                    'Los despachos superan a lo cotizado' + CHR(10) +
                    'Cant. cotizada: ' + STRING(B-DPEDI.CanPed, '->>>,>>9.99') + CHR(10) +
                    'Total atendido: ' + STRING(B-DPEDI.CanAte, '->>>,>>9.99') + CHR(10) +
                    'FIN DEL PROCESO'.
                    UNDO PRINCIPAL, RETURN "ADM-ERROR".
                END.
            END.
            WHEN "C" THEN DO:
                B-DPedi.CanAte = B-DPedi.CanAte + Facdpedi.CanPed.
                /* CONTROL DE ATENCIONES */
                IF B-DPEDI.CanAte > B-DPEDI.CanPed THEN DO:
                    pError = 'Se ha detectado un error al actualizar el producto ' + B-DPEDI.codmat + CHR(10) +
                    'Los despachos superan a lo cotizado' + CHR(10) +
                    'Cant. cotizada: ' + STRING(B-DPEDI.CanPed, '->>>,>>9.99') + CHR(10) +
                    'Total atendido: ' + STRING(B-DPEDI.CanAte, '->>>,>>9.99') + CHR(10) +
                    'FIN DEL PROCESO'.
                    UNDO PRINCIPAL, RETURN "ADM-ERROR".
                END.
            END.
        END CASE.
    END.
    /* RHC 11/08/2014 Solicitu de Transferencia STR */
    IF B-CPEDI.CodDoc = "STR" THEN DO:
        /* Actualizamos R/A */
        FIND Almcrepo WHERE Almcrepo.codcia = Faccpedi.codcia
            AND Almcrepo.codalm = Faccpedi.CodCli
            AND Almcrepo.nroser = INTEGER(SUBSTRING(B-CPEDI.NroRef,1,3))
            AND Almcrepo.nrodoc = INTEGER(SUBSTRING(B-CPEDI.NroRef,4))
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Almcrepo THEN DO:
            pError = 'No se pudo actualizar la ' + B-CPEDI.CodRef + ' ' + B-CPEDI.NroRef + CHR(10) +
                    
                'FIN DEL PROCESO'.
                    UNDO, RETURN "ADM-ERROR".
        END.
        FOR EACH Facdpedi OF Faccpedi NO-LOCK, 
            FIRST Almdrepo OF Almcrepo EXCLUSIVE-LOCK WHERE Almdrepo.codmat = Facdpedi.codmat
            ON ERROR UNDO, THROW:
            CASE pTipo:
                WHEN "D" THEN Almdrepo.CanAten = Almdrepo.CanAten - Facdpedi.CanPed.
                WHEN "C" THEN Almdrepo.CanAten = Almdrepo.CanAten + Facdpedi.CanPed.
            END CASE.
        END.
        ASSIGN
            Almcrepo.FlgEst = "C".
        FIND FIRST Almdrepo OF Almcrepo WHERE Almdrepo.CanAte < Almdrepo.CanApr NO-LOCK NO-ERROR.
        IF AVAILABLE Almdrepo THEN Almcrepo.FlgEst = "P".
    END.
    /* ACTUALIZAMOS FLAG DE LA COTIZACION */
    ASSIGN
        B-CPedi.FlgEst = "C".
    /* Si aun tiene cantidades x despachar lo mantenemos como pendiente */
    FIND FIRST B-DPedi OF B-CPedi WHERE B-DPedi.CanAte < B-DPedi.CanPed NO-LOCK NO-ERROR.
    IF AVAILABLE B-DPedi THEN ASSIGN B-CPedi.FlgEst = "P".
    /* RHC 06/02/2017 Cerramos la cotización de lista express             */
    /*IF B-CPEDI.TpoPed = "LF" AND pTipo = "C" THEN ASSIGN B-CPEDI.FlgEst = "C".*/
    /* ****************************************************************** */
END.
IF AVAILABLE B-CPEDI THEN RELEASE B-CPEDI.
IF AVAILABLE B-DPEDI THEN RELEASE B-DPEDI.
IF AVAILABLE Almcrepo THEN RELEASE Almcrepo.

RETURN 'OK'.


/* ******
/* ACTUALIZA LA COTIZACION EN BASE AL PEDIDO AL CREDITO */
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE BUFFER B-CPEDI FOR FacCPedi.

/* El pedido */
FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR.

IF NOT AVAILABLE Faccpedi THEN RETURN 'ADM-ERROR'.
PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Bloqueamos la cotizacion */
    {lib/lock-genericov3.i ~
        &Tabla="B-CPEDI" ~
        &Condicion="B-CPedi.CodCia=FacCPedi.CodCia ~
                AND B-CPedi.CodDiv=FacCPedi.CodDiv ~
                AND B-CPedi.CodDoc=FacCPedi.CodRef ~
                AND B-CPedi.NroPed=FacCPedi.NroRef" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pError" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        }
    /* NO ACTUALIZAMOS LAS PROMOCIONES */
    FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.Libre_c05 <> "OF",
        FIRST B-DPedi OF B-CPedi EXCLUSIVE-LOCK WHERE B-DPedi.CodMat = Facdpedi.CodMat
        AND B-DPEDI.Libre_c05 = Facdpedi.Libre_c05    /* Nuevo campo de control */
        ON ERROR UNDO, THROW:
        CASE pTipo:
            WHEN "D" THEN DO:
                B-DPedi.CanAte = B-DPedi.CanAte - Facdpedi.CanPed.
                IF B-DPEDI.CanAte < 0 THEN DO:
                    pError = 'Se ha detectado un error al extornar el producto ' + B-DPEDI.codmat + CHR(10) +
                    'Los despachos superan a lo cotizado' + CHR(10) +
                    'Cant. cotizada: ' + STRING(B-DPEDI.CanPed, '->>>,>>9.99') + CHR(10) +
                    'Total pedidos : ' + STRING(B-DPEDI.CanAte, '->>>,>>9.99') + CHR(10) +
                    'FIN DEL PROCESO'.
                    UNDO PRINCIPAL, RETURN "ADM-ERROR".
                END.
            END.
            WHEN "C" THEN DO:
                B-DPedi.CanAte = B-DPedi.CanAte + Facdpedi.CanPed.
                /* CONTROL DE ATENCIONES */
                IF B-DPEDI.CanAte > B-DPEDI.CanPed THEN DO:
                    pError = 'Se ha detectado un error al actualizar el producto ' + B-DPEDI.codmat + CHR(10) +
                    'Los despachos superan a lo cotizado' + CHR(10) +
                    'Cant. cotizada: ' + STRING(B-DPEDI.CanPed, '->>>,>>9.99') + CHR(10) +
                    'Total pedidos : ' + STRING(B-DPEDI.CanAte, '->>>,>>9.99') + CHR(10) +
                    'FIN DEL PROCESO'.
                    UNDO PRINCIPAL, RETURN "ADM-ERROR".
                END.
            END.
        END CASE.
    END.
    /* RHC 11/08/2014 Solicitu de Transferencia STR */
    IF B-CPEDI.CodDoc = "STR" THEN DO:
        /* Actualizamos R/A */
        FIND Almcrepo WHERE Almcrepo.codcia = Faccpedi.codcia
            AND Almcrepo.codalm = Faccpedi.CodCli
            AND Almcrepo.nroser = INTEGER(SUBSTRING(B-CPEDI.NroRef,1,3))
            AND Almcrepo.nrodoc = INTEGER(SUBSTRING(B-CPEDI.NroRef,4))
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Almcrepo THEN DO:
            pError = 'No se pudo actualizar la ' + B-CPEDI.CodRef + ' ' + B-CPEDI.NroRef + CHR(10) +
                    'FIN DEL PROCESO'.
                    UNDO, RETURN "ADM-ERROR".
        END.
        FOR EACH Facdpedi OF Faccpedi NO-LOCK, 
            FIRST Almdrepo OF Almcrepo EXCLUSIVE-LOCK WHERE Almdrepo.codmat = Facdpedi.codmat
            ON ERROR UNDO, THROW:
            CASE pTipo:
                WHEN "D" THEN Almdrepo.CanAten = Almdrepo.CanAten - Facdpedi.CanPed.
                WHEN "C" THEN Almdrepo.CanAten = Almdrepo.CanAten + Facdpedi.CanPed.
            END CASE.
        END.
        ASSIGN
            Almcrepo.FlgEst = "C".
        FIND FIRST Almdrepo OF Almcrepo WHERE Almdrepo.CanAte < Almdrepo.CanApr NO-LOCK NO-ERROR.
        IF AVAILABLE Almdrepo THEN Almcrepo.FlgEst = "P".
    END.
    /* ACTUALIZAMOS FLAG DE LA COTIZACION */
    ASSIGN
        B-CPedi.FlgEst = "C".
    /* Si aun tiene cantidades x despachar lo mantenemos como pendiente */
    FIND FIRST B-DPedi OF B-CPedi WHERE B-DPedi.CanAte < B-DPedi.CanPed NO-LOCK NO-ERROR.
    IF AVAILABLE B-DPedi THEN ASSIGN B-CPedi.FlgEst = "P".
    /* RHC 06/02/2017 Cerramos la cotización de lista express             */
    IF B-CPEDI.TpoPed = "LF" AND pTipo = "C" THEN ASSIGN B-CPEDI.FlgEst = "C".
    /* ****************************************************************** */
    IF AVAILABLE B-CPEDI THEN RELEASE B-CPEDI.
    IF AVAILABLE B-DPEDI THEN RELEASE B-DPEDI.
    IF AVAILABLE Almcrepo THEN RELEASE Almcrepo.
END.
RETURN 'OK'.

**** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Revisando-Saldos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Revisando-Saldos Procedure 
PROCEDURE Revisando-Saldos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-CanAte AS DECI NO-UNDO.

DEF BUFFER PEDIDO FOR Faccpedi.
DEF BUFFER DETALLE FOR Facdpedi.

x-canate = 0.
/* por pedidos en curso */
FOR EACH PEDIDO NO-LOCK WHERE PEDIDO.codcia = B-CPEDI.codcia
    AND PEDIDO.coddoc = 'PED'
    AND PEDIDO.coddiv = B-CPEDI.coddiv
    AND PEDIDO.codref = B-CPEDI.coddoc      /* COT */
    AND PEDIDO.nroref = B-CPEDI.nroped
    AND LOOKUP(PEDIDO.flgest, 'C,G,X,W,WX,WL') > 0,
    EACH DETALLE OF PEDIDO NO-LOCK WHERE DETALLE.codmat = facdpedi.codmat:
    x-canate = x-canate + DETALLE.canped.
END.
IF B-DPEDI.canate <> x-canate THEN DO:
    B-DPEDI.canate = x-canate.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

