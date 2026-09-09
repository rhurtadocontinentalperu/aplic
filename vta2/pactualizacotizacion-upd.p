&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE TEMP-TABLE PEDI-NEW NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE PEDI-OLD NO-UNDO LIKE FacDPedi.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       : Se comparan 2 tablas: como estaba antes y como queda después
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER TABLE FOR PEDI-OLD.
DEF INPUT PARAMETER TABLE FOR PEDI-NEW.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

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
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: PEDI-NEW T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: PEDI-OLD T "?" NO-UNDO INTEGRAL FacDPedi
   END-TABLES.
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

/* El pedido */
FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN DO:
    pMensaje = "NO se pudo ubicar el pedido logístico".
    RETURN 'ADM-ERROR'.
END.

pMensaje = "".
PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Bloqueamos la COTIZACION */
    {lib/lock-genericov3.i ~
        &Tabla="B-CPEDI" ~
        &Alcance="FIRST" ~
        &Condicion="B-CPEDI.CodCia=FacCPedi.CodCia ~
                AND B-CPEDI.CodDoc=FacCPedi.CodRef ~
                AND B-CPEDI.NroPed=FacCPedi.NroRef" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        }
    /* **************************************************************************************************** */
    /* 1ro. los registros eliminados */
    /* **************************************************************************************************** */
    FOR EACH PEDI-OLD NO-LOCK:
        FIND FIRST PEDI-NEW WHERE PEDI-NEW.CodMat = PEDI-OLD.CodMat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE PEDI-NEW THEN DO:
            FIND FIRST B-DPEDI OF B-CPEDI WHERE B-DPEDI.CodMat = PEDI-OLD.CodMat NO-LOCK NO-ERROR.
            IF NOT AVAILABLE B-DPEDI THEN NEXT.
            FIND CURRENT B-DPEDI EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF NOT AVAILABLE B-DPEDI THEN DO:
                pMensaje = "NO se pudo actualizar: " + B-CPEDI.coddoc + " " + B-CPEDI.nroped + " " + PEDI-OLD.CodMat.
                UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
            END.
            ASSIGN
                B-DPEDI.CanAte = B-DPEDI.CanAte - PEDI-OLD.CanPed.
            IF B-DPEDI.CanAte < 0 THEN DO:
                pMensaje = 'Se ha detectado un error al extornar el producto ' + B-DPEDI.codmat + CHR(10) +
                'Los despachos superan a lo cotizado' + CHR(10) +
                'Cant. cotizada: ' + STRING(B-DPEDI.CanPed, '->>>,>>9.99') + CHR(10) +
                'Total atendido: ' + STRING(B-DPEDI.CanAte, '->>>,>>9.99') + CHR(10) +
                'FIN DEL PROCESO'.
                UNDO PRINCIPAL, RETURN "ADM-ERROR".
            END.
        END.
    END.
    /* **************************************************************************************************** */
    /* 2do. los registros modificados */
    /* **************************************************************************************************** */
    DEF VAR x-Diferencia AS DECI NO-UNDO.
    FOR EACH PEDI-OLD NO-LOCK, FIRST PEDI-NEW NO-LOCK WHERE PEDI-NEW.CodMat = PEDI-OLD.CodMat
        AND PEDI-NEW.CanPed <> PEDI-OLD.CanPed:  /* OJO */
        x-Diferencia = (PEDI-NEW.CanPed - PEDI-OLD.CanPed).
        FIND FIRST B-DPEDI OF B-CPEDI WHERE B-DPEDI.CodMat = PEDI-OLD.CodMat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-DPEDI THEN NEXT.
        FIND CURRENT B-DPEDI EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE B-DPEDI THEN DO:
            pMensaje = "NO se pudo actualizar: " + B-CPEDI.coddoc + " " + B-CPEDI.nroped + " " + PEDI-OLD.CodMat.
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            B-DPEDI.CanAte = B-DPEDI.CanAte + x-Diferencia.
        IF B-DPEDI.CanAte < 0 THEN DO:
            pMensaje = 'Se ha detectado un error al extornar el producto ' + B-DPEDI.codmat + CHR(10) +
            'Los despachos superan a lo cotizado' + CHR(10) +
            'Cant. cotizada: ' + STRING(B-DPEDI.CanPed, '->>>,>>9.99') + CHR(10) +
            'Total atendido: ' + STRING(B-DPEDI.CanAte, '->>>,>>9.99') + CHR(10) +
            'FIN DEL PROCESO'.
            UNDO PRINCIPAL, RETURN "ADM-ERROR".
        END.
    END.
    /* **************************************************************************************************** */
    /* ACTUALIZAMOS FLAG DE LA COTIZACION */
    /* **************************************************************************************************** */
    ASSIGN
        B-CPEDI.FlgEst = "C".
    /* Si aun tiene cantidades x despachar lo mantenemos como pendiente */
    FIND FIRST B-DPEDI OF B-CPEDI WHERE B-DPEDI.CanAte < B-DPEDI.CanPed NO-LOCK NO-ERROR.
    IF AVAILABLE B-DPEDI THEN ASSIGN B-CPEDI.FlgEst = "P".
END.
IF AVAILABLE B-CPEDI THEN RELEASE B-CPEDI.
IF AVAILABLE B-DPEDI THEN RELEASE B-DPEDI.

RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


