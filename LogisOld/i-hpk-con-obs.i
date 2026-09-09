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

CICLO:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    CASE ORDEN.CodDoc:
        /* CONTROL DE ORDENES DE DESPACHO */
        WHEN "O/D" OR WHEN "O/M" THEN DO:
            
            /* POSICIONAMOS PUNTEROS DEL PEDIDO Y COTIZACION */
            /* RHC 19/02/2018 En caso de Cross Docking x Cliente el origen está en otra división */
            FIND FIRST PEDIDO WHERE PEDIDO.codcia = ORDEN.codcia
                AND PEDIDO.coddoc = ORDEN.codref
                AND PEDIDO.nroped = ORDEN.nroref
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE PEDIDO THEN DO:
                pError = "NO se pudo bloquear el " + ORDEN.codref + " " + ORDEN.nroref +
                    CHR(10) + ERROR-STATUS:GET-MESSAGE(1).
                UNDO CICLO, RETURN 'ADM-ERROR'.
            END.
            IF ORDEN.CodDoc = 'O/D' THEN DO:
                FIND FIRST COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
                    AND COTIZACION.coddiv = PEDIDO.coddiv
                    AND COTIZACION.coddoc = PEDIDO.codref
                    AND COTIZACION.nroped = PEDIDO.nroref
                    EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE COTIZACION THEN DO:
                    pError = "NO se pudo bloquear la cotización " + PEDIDO.codref + " " + PEDIDO.nroref +
                        CHR(10) + ERROR-STATUS:GET-MESSAGE(1).
                    UNDO CICLO, RETURN 'ADM-ERROR'.
                END.
            END.
        END.
        /* CONTROL ORDENES DE TRANSFERENCIA */
        WHEN "OTR" THEN DO:
            /* DOS TIPOS: POR REPOSICION AUTOMATICA (R/A) O POR CROSS DOCKING CLIENTES (PED) */
            CASE ORDEN.CodRef:
                /* POR REPOSICION AUTOMATICA */
                WHEN "R/A" THEN DO:
                    /* Buscamos la R/A base */
                    /* **************************************************************** */
                    /* RHC 12/01/2018 Si no la encuentra puede que sea un Cross Docking */
                    /* **************************************************************** */
                    IF ORDEN.CrossDocking = YES THEN DO:
                        FIND FIRST Almcrepo WHERE almcrepo.CodCia = ORDEN.codcia
                            AND almcrepo.CodAlm = ORDEN.AlmacenXD
                            AND almcrepo.NroSer = INT(SUBSTRING(ORDEN.nroref,1,3))
                            AND almcrepo.NroDoc = INT(SUBSTRING(ORDEN.nroref,4))
                            NO-LOCK NO-ERROR.
                    END.
                    ELSE DO:
                        FIND FIRST Almcrepo WHERE almcrepo.CodCia = ORDEN.codcia
                            AND almcrepo.CodAlm = ORDEN.CodCli
                            AND almcrepo.NroSer = INT(SUBSTRING(ORDEN.nroref,1,3))
                            AND almcrepo.NroDoc = INT(SUBSTRING(ORDEN.nroref,4))
                            NO-LOCK NO-ERROR.
                    END.
                    /* **************************************************************** */
                    IF NOT AVAILABLE Almcrepo THEN DO:
                        pError = "NO se pudo bloquear la R/A " + ORDEN.nroref +
                            CHR(10) + ERROR-STATUS:GET-MESSAGE(1).
                        UNDO CICLO, RETURN 'ADM-ERROR'.
                    END.
                    /* Extornamos la cantidad atendida en la R/A */
                    {&Control-RA}
                    IF AVAILABLE Almdrepo THEN RELEASE Almdrepo.
                END.
                /* POR CROSS DOCKING CLIENTES */
                WHEN "PED" THEN DO:
                    /* ACTUALIZAMOS PEDIDOS Y COTIZACIONES */
                    FIND FIRST PEDIDO WHERE PEDIDO.codcia = ORDEN.codcia
                        AND PEDIDO.coddoc = ORDEN.codref
                        AND PEDIDO.nroped = ORDEN.nroref
                        EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT AVAILABLE PEDIDO THEN DO:
                        pError = "NO se pudo bloquear el " + ORDEN.codref + " " + ORDEN.nroref +
                            CHR(10) + ERROR-STATUS:GET-MESSAGE(1).
                        UNDO CICLO, RETURN 'ADM-ERROR'.
                    END.
                    FIND FIRST COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
                        AND COTIZACION.coddiv = PEDIDO.coddiv
                        AND COTIZACION.coddoc = PEDIDO.codref
                        AND COTIZACION.nroped = PEDIDO.nroref
                        EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT AVAILABLE COTIZACION THEN DO:
                        pError = "NO se pudo bloquear la cotización " + PEDIDO.codref + " " + PEDIDO.nroref +
                            CHR(10) + ERROR-STATUS:GET-MESSAGE(1).
                        UNDO CICLO, RETURN 'ADM-ERROR'.
                    END.
                    {&Control-COT}
                    ASSIGN
                        COTIZACION.FlgEst = "C".
                    IF CAN-FIND(FIRST Facdpedi OF COTIZACION WHERE Facdpedi.CanPed > Facdpedi.CanAte NO-LOCK)
                        THEN COTIZACION.FlgEst = "P".
                    {&Control-PED}
                END.
            END CASE.
        END.
    END CASE.
END.
RETURN 'OK'.

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
         HEIGHT             = 4.58
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


