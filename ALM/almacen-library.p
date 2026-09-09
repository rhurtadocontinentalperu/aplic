&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-ALM FOR Almacen.
DEFINE BUFFER B-CREPO FOR almcrepo.
DEFINE BUFFER B-DREPO FOR almdrepo.
DEFINE BUFFER B-MATG FOR Almmmatg.
DEFINE TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE t-Almcmov NO-UNDO LIKE Almcmov.



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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

/* DEFINE TEMP-TABLE Detalle                                      */
/*     FIELD CodMat AS CHAR LABEL 'Articulo'                      */
/*     FIELD CodAlm AS CHAR LABEL 'Alm.Solicitante'               */
/*     FIELD Observ AS CHAR FORMAT 'x(60)' LABEL 'Observaciones'. */
/*                                                                */

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
      TABLE: B-ALM B "?" ? INTEGRAL Almacen
      TABLE: B-CREPO B "?" ? INTEGRAL almcrepo
      TABLE: B-DREPO B "?" ? INTEGRAL almdrepo
      TABLE: B-MATG B "?" ? INTEGRAL Almmmatg
      TABLE: PEDI T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: t-Almcmov T "?" NO-UNDO INTEGRAL Almcmov
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 9.5
         WIDTH              = 53.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ALM_Materiales-por-Almacen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ALM_Materiales-por-Almacen Procedure 
PROCEDURE ALM_Materiales-por-Almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodAlm AS CHAR.        /* Puede ser en blanco, en ese caso son TODOS los almacenes */
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pSolo   AS CHAR.        /* M: manual   A: automático   *: todos */
DEF OUTPUT PARAMETER pMensaje AS CHAR.

DEF BUFFER B-MATE FOR Almmmate.
DEF BUFFER B-MATG FOR Almmmatg.
DEF BUFFER B-ALMACEN FOR Almacen.
DEF BUFFER b-almautmv FOR almautmv.

DEF VAR x-Cuenta AS INTE NO-UNDO.
DEF VAR x-CodAlm AS CHAR NO-UNDO.

FIND B-MATG WHERE B-MATG.codcia = s-codcia AND B-MATG.codmat = pCodMat NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-MATG THEN RETURN 'OK'.
FIND CURRENT B-MATG EXCLUSIVE-LOCK NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
    UNDO, RETURN 'ADM-ERROR'.
END.
/* Filtro: Cuando es AUTOMATICA el campo Almtabla.CodCta1 está en blanco */
/* Cualquier código (pSolo) que no se 'M' ni 'A' (por ejemplo '*') pasa el filtro */
FIND AlmTabla WHERE almtabla.Tabla = "CC"
    AND almtabla.Codigo = B-MATG.catconta[1]
    NO-LOCK NO-ERROR.
IF pSolo = "M" AND AVAILABLE AlmTabla AND Almtabla.CodCta1 <> pSolo THEN RETURN 'OK'.
IF pSolo = "A" AND AVAILABLE ALmTabla AND Almtabla.CodCta1 = "M" THEN RETURN 'OK'.

/* Barremos almacén por almacén */
/* Si se le envía el almacén => NO se verifica ASIGNACION AUTOMATICA */
FOR EACH B-ALMACEN NO-LOCK WHERE B-ALMACEN.CodCia = s-CodCia 
    AND (TRUE <> (pCodAlm > '') OR B-ALMACEN.CodAlm = pCodAlm)
    AND B-ALMACEN.Campo-c[9] <> "I"                             /* Activo */
    AND (pCodAlm > '' OR B-ALMACEN.TdoArt = YES):               /* Asignación Automática Condicional */
    /* CONSISTENCIA POR PRODUCTO Y B-ALMACEN */
    IF B-MATG.TpoMrg > '' AND B-ALMACEN.Campo-c[2] > '' THEN DO:
        IF B-MATG.TpoMrg <> B-ALMACEN.Campo-c[2] THEN NEXT.
    END.
    /* *********************************** */
    FIND FIRST B-MATE WHERE B-MATE.CodCia = B-MATG.codcia 
        AND B-MATE.CodAlm = B-ALMACEN.CodAlm 
        AND B-MATE.CodMat = B-MATG.CodMat NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-MATE THEN DO:
        CREATE B-MATE.
        ASSIGN 
            B-MATE.CodCia = B-MATG.codcia
            B-MATE.CodAlm = B-ALMACEN.CodAlm
            B-MATE.CodMat = B-MATG.CodMat
            NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END.
    ELSE DO:
        FIND CURRENT B-MATE EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END.
    ASSIGN 
        B-MATE.DesMat = B-MATG.DesMat
        B-MATE.FacEqu = B-MATG.FacEqu
        B-MATE.UndVta = B-MATG.UndStk
        B-MATE.CodMar = B-MATG.CodMar.
    FIND FIRST b-almautmv WHERE 
        b-almautmv.CodCia = B-MATG.codcia AND
        b-almautmv.CodFam = B-MATG.codfam AND
        b-almautmv.CodMar = B-MATG.codMar AND
        b-almautmv.Almsol = B-MATE.CodAlm NO-LOCK NO-ERROR.
    IF AVAILABLE b-almautmv THEN 
        ASSIGN
            B-MATE.AlmDes = b-almautmv.Almdes
            B-MATE.CodUbi = b-almautmv.CodUbi.
    /* Actualizamos el catálogo */
    x-CodAlm = TRIM(B-ALMACEN.CodAlm).
    IF TRUE <> (B-MATG.Almacenes > '') THEN B-MATG.Almacenes = x-CodAlm.
    ELSE DO:
        IF LOOKUP(x-CodAlm, B-MATG.Almacenes) = 0 
            THEN B-MATG.Almacenes = B-MATG.Almacenes + "," + x-CodAlm.
    END.
END.
RELEASE B-MATG.
RELEASE B-MATE.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ALM_Materiales-por-Almacen-Old) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ALM_Materiales-por-Almacen-Old Procedure 
PROCEDURE ALM_Materiales-por-Almacen-Old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodMat AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR.

DEF BUFFER B-MATE FOR Almmmate.
DEF BUFFER B-MATG FOR Almmmatg.
DEF BUFFER B-ALMACEN FOR Almacen.
DEF BUFFER b-almautmv FOR almautmv.

DEF VAR x-Cuenta AS INTE NO-UNDO.
DEF VAR x-CodAlm AS CHAR NO-UNDO.

FIND B-MATG WHERE B-MATG.codcia = s-codcia AND B-MATG.codmat = pCodMat NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-MATG THEN RETURN 'OK'.
FIND CURRENT B-MATG EXCLUSIVE-LOCK NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
    UNDO, RETURN 'ADM-ERROR'.
END.

FIND AlmTabla WHERE almtabla.Tabla = "CC"
    AND almtabla.Codigo = B-MATG.catconta[1]
    NO-LOCK NO-ERROR.
IF AVAILABLE AlmTabla AND Almtabla.CodCta1 = "M" THEN RETURN "OK".

FOR EACH B-ALMACEN NO-LOCK WHERE B-ALMACEN.CodCia = s-CodCia 
    AND B-ALMACEN.Campo-c[9] <> "I"     /* Activo */
    /*AND B-ALMACEN.Campo-c[2] <> "Si"    /* NO Remates */  */
    AND B-ALMACEN.TdoArt = YES:         /* Asignación Automática */
    /* CONSISTENCIA POR PRODUCTO Y B-ALMACEN */
    IF B-MATG.TpoMrg > '' AND B-ALMACEN.Campo-c[2] > '' THEN DO:
        IF B-MATG.TpoMrg <> B-ALMACEN.Campo-c[2] THEN NEXT.
    END.
    /* *********************************** */
    FIND FIRST B-MATE WHERE B-MATE.CodCia = B-MATG.codcia 
        AND B-MATE.CodAlm = B-ALMACEN.CodAlm 
        AND B-MATE.CodMat = B-MATG.CodMat NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-MATE THEN DO:
        CREATE B-MATE.
        ASSIGN 
            B-MATE.CodCia = B-MATG.codcia
            B-MATE.CodAlm = B-ALMACEN.CodAlm
            B-MATE.CodMat = B-MATG.CodMat
            NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END.
    ELSE DO:
        FIND CURRENT B-MATE EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END.
    ASSIGN 
        B-MATE.DesMat = B-MATG.DesMat
        B-MATE.FacEqu = B-MATG.FacEqu
        B-MATE.UndVta = B-MATG.UndStk
        B-MATE.CodMar = B-MATG.CodMar.
    FIND FIRST b-almautmv WHERE 
        b-almautmv.CodCia = B-MATG.codcia AND
        b-almautmv.CodFam = B-MATG.codfam AND
        b-almautmv.CodMar = B-MATG.codMar AND
        b-almautmv.Almsol = B-MATE.CodAlm NO-LOCK NO-ERROR.
    IF AVAILABLE b-almautmv THEN 
        ASSIGN
            B-MATE.AlmDes = b-almautmv.Almdes
            B-MATE.CodUbi = b-almautmv.CodUbi.
    /* Actualizamos el catálogo */
    x-CodAlm = TRIM(B-ALMACEN.CodAlm).
    IF TRUE <> (B-MATG.Almacenes > '') THEN B-MATG.Almacenes = x-CodAlm.
    ELSE DO:
        IF LOOKUP(x-CodAlm, B-MATG.Almacenes) = 0 
            THEN B-MATG.Almacenes = B-MATG.Almacenes + "," + x-CodAlm.
    END.
END.
RELEASE B-MATG.
RELEASE B-MATE.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ALM_Tipo-MultiUbic) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ALM_Tipo-MultiUbic Procedure 
PROCEDURE ALM_Tipo-MultiUbic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodUbi AS CHAR.

IF CAN-FIND(FIRST Almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia AND
            Almmmate.codalm = pCodAlm AND
            Almmmate.codmat = pCodMat AND
            Almmmate.codubi = pCodUbi)
    THEN RETURN 'PRINCIPAL'.
ELSE RETURN 'SOBRESTOCK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-FIFO_Control-de-Series) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FIFO_Control-de-Series Procedure 
PROCEDURE FIFO_Control-de-Series :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pEvento AS CHAR.    /* WRITE DELETE */
DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pAlmOri AS CHAR.
DEF INPUT PARAMETER pTipMov AS CHAR.    /* I: ingreso S: salida */
DEF INPUT PARAMETER pCodMov AS INTE.
DEF INPUT PARAMETER pNroSer AS INTE.
DEF INPUT PARAMETER pNroDoc AS INTE.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodUnd AS CHAR.
DEF INPUT PARAMETER pSerialNumber AS CHAR.
DEF INPUT PARAMETER pCanDes AS DECI.
DEF INPUT PARAMETER pFactor AS DECI.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

IF LOOKUP(pEvento, 'WRITE,DELETE') = 0 THEN RETURN 'ADM-ERROR'.

FIND Almmmatg WHERE Almmmatg.CodCia = s-CodCia
    AND Almmmatg.codmat = pCodMat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg OR Almmmatg.RequiereSerialNr = "no" THEN RETURN "OK".

DEF VAR pCuenta AS INTE NO-UNDO.

CASE TRUE:
    WHEN pEvento = "DELETE" THEN DO:
        DEF BUFFER B-DMOV FOR fifodmov.
        RLOOP:
        DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
            FOR EACH fifodmov NO-LOCK WHERE fifodmov.CodCia = s-CodCia
                AND fifodmov.CodAlm = pCodAlm
                AND fifodmov.TipMov = pTipMov
                AND fifodmov.CodMov = pCodMov
                AND fifodmov.NroSer = pNroSer
                AND fifodmov.NroDoc = pNroDoc
                AND fifodmov.CodMat = pCodMat
                AND ( TRUE <> (pSerialNumber > '') OR fifodmov.SerialNumber = pSerialNumber ):
                FIND B-DMOV WHERE ROWID(B-DMOV) = ROWID(fifodmov) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                IF ERROR-STATUS:ERROR THEN DO:
                    {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje" }
                    UNDO RLOOP, RETURN 'ADM-ERROR'.
                END.
                FIND FIRST fifommate WHERE fifommate.CodCia = s-CodCia
                    AND fifommate.CodAlm = pCodAlm
                    AND fifommate.CodMat = pCodMat
                    AND fifommate.SerialNumber = fifodmov.SerialNumber          /* OJO */
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE fifommate THEN DO:
                    FIND FIRST fifommate WHERE fifommate.CodCia = s-CodCia
                        AND fifommate.CodMat = pCodMat
                        AND fifommate.SerialNumber = fifodmov.SerialNumber      /* OJO */
                        NO-LOCK NO-ERROR.
                END.
                IF NOT AVAILABLE fifommate THEN DO:
                    pMensaje = "Artículo no registrado: " + pCodMat + '/' + fifodmov.SerialNumber + CHR(10) +
                        "en el almacén " + pCodAlm.
                    RETURN 'ADM-ERROR'.
                END.
                FIND CURRENT fifommate EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                IF ERROR-STATUS:ERROR THEN DO:
                    {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje" }
                    RETURN 'ADM-ERROR'.
                END.
                CASE pTipMov:
                WHEN "I" THEN fifommate.StkAct = fifommate.StkAct - (fifodmov.CanDes * fifodmov.Factor).
                WHEN "S" THEN fifommate.StkAct = fifommate.StkAct + (fifodmov.CanDes * fifodmov.Factor).
                END CASE.

                DELETE B-DMOV.    /* OJO */
            END.
        END.
    END.
    WHEN pEvento = "WRITE" AND pTipMov = "I" AND pCodMov = 09 THEN DO:    
        /* Ingreso por Devolución de Mercadería */
        DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
            FIND FIRST fifommatg WHERE fifommatg.CodCia = s-CodCia
                AND fifommatg.CodMat = pCodMat
                AND fifommatg.SerialNumber = pSerialNumber
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE fifommatg THEN DO:
                pMensaje = "Artículo no registrado: " + pCodMat + '/' + pSerialNumber.
                RETURN 'ADM-ERROR'.
            END.
            FIND FIRST fifommate WHERE fifommate.CodCia = s-CodCia
                AND fifommate.CodAlm = pCodAlm
                AND fifommate.CodMat = pCodMat
                AND fifommate.SerialNumber = pSerialNumber
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE fifommate THEN DO:
                FIND FIRST fifommate WHERE fifommate.CodCia = s-CodCia
                    AND fifommate.CodMat = pCodMat
                    AND fifommate.SerialNumber = pSerialNumber
                    NO-LOCK NO-ERROR.
            END.
            IF NOT AVAILABLE fifommate THEN DO:
                pMensaje = "Artículo no registrado: " + pCodMat + '/' + pSerialNumber + CHR(10) +
                    "en el almacén " + pCodAlm.
                RETURN 'ADM-ERROR'.
            END.
            FIND CURRENT fifommate EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF ERROR-STATUS:ERROR THEN DO:
                {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje" }
                RETURN 'ADM-ERROR'.
            END.
            ASSIGN
                fifommate.StkAct = fifommate.StkAct + (pCanDes * pFactor).
            CREATE fifodmov.
            ASSIGN
                fifodmov.FchDoc = TODAY
                fifodmov.CodCia = s-CodCia
                fifodmov.CodAlm = pCodAlm
                fifodmov.AlmOri = pAlmOri
                fifodmov.TipMov = pTipMov
                fifodmov.CodMov = pCodMov
                fifodmov.NroSer = pNroSer
                fifodmov.NroDoc = pNroDoc
                fifodmov.CodMat = pCodMat
                fifodmov.SerialNumber = pSerialNumber
                fifodmov.CanDes = pCanDes
                fifodmov.Factor = pFactor
                fifodmov.CodUnd = pCodUnd.
        END.
    END.
END CASE.


RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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
DEF OUTPUT PARAMETER pMensaje2 AS CHAR NO-UNDO.

IF TRUE <> (pTipMov > '') THEN RETURN 'ADM-ERROR'.
IF TRUE <> (pNroDoc > '') THEN RETURN 'ADM-ERROR'.

DEF VAR iCuenta AS INT NO-UNDO.
DEF VAR pCodDiv AS CHAR NO-UNDO.
DEF VAR s-coddoc AS CHAR INIT 'R/A' NO-UNDO.
DEF VAR s-tipmov AS CHAR INIT 'A' NO-UNDO.

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
    pMensaje = 'Error correlativo ' + s-coddoc + ' división ' + pCodDiv.
    RETURN "ADM-ERROR".
END.

DEF VAR n-Items AS INT NO-UNDO.

pMensaje = "".
PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    {lib/lock-genericov3.i
        &Tabla="FacCorre"
        &Alcance="FIRST"
        &Condicion="Faccorre.codcia = s-codcia ~
            AND Faccorre.coddoc = s-coddoc ~
            AND Faccorre.flgest = YES ~
            AND Faccorre.coddiv = pCodDiv" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
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
    FOR EACH B-DREPO OF B-CREPO NO-LOCK,
        FIRST Almmmatg OF B-DREPO NO-LOCK
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
            /* GUARDAMOS LA REFERENCIA */
            ASSIGN
                pMensaje2 = pMensaje2 + (IF pMensaje2 > '' THEN ' ' ELSE '') +
                s-CodDoc + ' ' + STRING(Almcrepo.nroser, '999') + '-' + STRING(Almcrepo.nrodoc)
                Almcrepo.CodRef = pTipMov
                Almcrepo.NroRef = pNroDoc.
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
            almdrepo.CanAten = 0    /* OJO */
            NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="iCuenta"}
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

&IF DEFINED(EXCLUDE-GR_Formato_Items) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GR_Formato_Items Procedure 
PROCEDURE GR_Formato_Items :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pNroSer AS INTE NO-UNDO.

DEF OUTPUT PARAMETER pFormatoImpresion AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pItemsGuias AS INTE NO-UNDO.

/* Por defecto es el de la configuración general */
pItemsGuias = 13.
FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
IF AVAILABLE FacCfgGn THEN pItemsGuias = FacCfgGn.Items_Guias.

/* Tomamos el formato e items del correlativo */
FIND FIRST FacCorre WHERE FacCorre.codcia = s-codcia AND 
    FacCorre.CodDoc = "G/R" AND
    FacCorre.NroSer = pNroSer NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN DO:
    CASE FacCorre.NroImp:
        WHEN "C13" THEN ASSIGN pFormatoImpresion = FacCorre.NroImp pItemsGuias = 13.
        /*WHEN "C36" THEN ASSIGN pFormatoImpresion = FacCorre.NroImp pItemsGuias = 36.*/
        /* 03/06/2026: El nuevo formato solo acepta 30 items */
        WHEN "C36" THEN ASSIGN pFormatoImpresion = FacCorre.NroImp pItemsGuias = 30.
        WHEN "A4"  THEN ASSIGN pFormatoImpresion = FacCorre.NroImp pItemsGuias = 999.
    END CASE.
END.

/* Caso serie 000: Papel en Blanco Formato Contínuo Carta */
IF pNroSer = 000 THEN ASSIGN pFormatoImpresion = "CARTA" pItemsGuias = 999.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GR_Lista_de_Series) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GR_Lista_de_Series Procedure 
PROCEDURE GR_Lista_de_Series :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDiv AS CHAR NO-UNDO.
/* Puede estar en blanco, entonces vale el almacén */

DEF INPUT PARAMETER pCodAlm AS CHAR NO-UNDO.
/* Puede estar en blanco, entonces vale la división */

DEF INPUT PARAMETER pUsos AS CHAR NO-UNDO.
/* VARIOS, VENTAS, TRANSFERENCIAS e ITINERANTES */
/* SI envía TODOS => no filtra por uso */

DEF INPUT PARAMETER pEstado AS LOG NO-UNDO.
/* TRUE: solo activas 
   FALSE: solo inactivas 
   ?: todas, activas e inactivas */

DEF INPUT PARAMETER pTipo AS CHAR NO-UNDO.
/* MANUAL, ELECTRONICA, CLASICA */

DEF OUTPUT PARAMETER pSeries AS CHAR NO-UNDO.
/* 015,020,251 */

IF TRUE <> (pCodDiv > '') AND TRUE <> (pCodAlm > '') THEN DO:
    MESSAGE 'Debe enviar al menos un valor de la división o del almacén'
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

FOR EACH FacCorre NO-LOCK WHERE FacCorre.codcia = s-codcia AND 
    FacCorre.CodDoc = "G/R" AND
    FacCorre.NroSer <> 000 AND 
    (TRUE <> (pCodDiv > '') OR FacCorre.CodDiv = pCodDiv) AND
    (TRUE <> (pCodAlm > '') OR FacCorre.CodAlm = pCodAlm):

    IF pEstado = TRUE AND FacCorre.FlgEst = FALSE THEN NEXT.
    IF pEstado = FALSE AND FacCorre.FlgEst = TRUE THEN NEXT.

    /*MESSAGE faccorre.nroser FacCorre.ID_Pos FacCorre.ID_Pos2 pusos.*/

    IF FacCorre.ID_Pos <> pTipo THEN NEXT.
    IF pUsos <> "TODOS" THEN DO:
        CASE TRUE:
            WHEN pUsos = "VARIOS" AND FacCorre.ID_Pos2 > '' THEN NEXT.
            WHEN FacCorre.ID_Pos2 > '' AND FacCorre.ID_Pos2 <> pUsos THEN NEXT.
        END CASE.
    END.

    pSeries = pSeries + (IF TRUE <> (pSeries > '') THEN ''
        ELSE ',' ) + STRING(FacCorre.NroSer,'999') .
END.

END PROCEDURE.

/*
    IF pUsos <> "TODOS" THEN DO:
        /* Si la Serie NO tiene un uso específico (TODOS) => no se filtra */
        IF FacCorre.ID_Pos2 > '' AND FacCorre.ID_Pos2 <> pUsos THEN NEXT.
    END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-TRF_Ing_Transf_Pend) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE TRF_Ing_Transf_Pend Procedure 
PROCEDURE TRF_Ing_Transf_Pend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Tres tiempos: 24 horas, 48 horas y 72 horas 
------------------------------------------------------------------------------*/
/*
Si son varios entonces hay que ver cual es que tiene mas tiempo 
*/

/*DEFINE IMAGE IMAGE-1 FILENAME "img/auditor" SIZE 5 BY 1.5.*/
DEFINE IMAGE IMAGE-1 FILENAME "img/search" SIZE 5 BY 1.5.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 2 COL 5 SKIP
    "Buscando transferencias por recepcionar." SKIP 
    "Espere un momento por favor ..." 
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

VIEW FRAME f-Proceso.

DEF INPUT PARAMETER pCodDiv AS CHAR.            /* División Destino de Transferencia */
DEF INPUT PARAMETER pDateTime1 AS DATETIME.     /* normalmente NOW */

DEF VAR pDateTime2 AS DATETIME NO-UNDO.
DEF VAR x-Horas AS INT64 NO-UNDO.

DEF BUFFER b-Almacen FOR Almacen.   /* Almacén Destino */

EMPTY TEMP-TABLE t-Almcmov.

/* RHC 01/07/2020 Debe seguir el trabalenguas de Jose Nieto */
/*
Para el caso de las transferencias de tiendas a CD o entre tiendas (con paso o no por CD), 
    el plazo máximo para que la transferencia se encuentre abierta sin que se genere 
    una hoja de ruta o se ingrese la transferencia es de 5 días. 
En caso pasados los 5 días, se bloquean las transacciones de traslado del local emisor. 
Para el desbloqueo, se debe de comunicar con Control de Inventarios, 
    cuyo requisito principal es que se anule la salida y cargue nuevamente su stock. 
De generar hoja de ruta antes de los 5 días, ya pasa el control para el 
    lado del receptor (72 hrs).
*/

/* 1ro. Las salidas por transferencia */
FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia AND 
    Almacen.campo-c[9] <> "I" AND
    Almacen.coddiv = pCodDiv:
    /* Transferencias NO recepcionadas */
    FOR EACH Almcmov NO-LOCK WHERE Almcmov.codcia = s-codcia AND
        Almcmov.codalm = Almacen.codalm AND
        Almcmov.tipmov = "S" AND
        Almcmov.codmov = 03 AND
        Almcmov.flgsit = "T" AND
        Almcmov.flgest <> "A":
        /* Verificamos si tiene una H/R válida */
        FIND FIRST Di-RutaG WHERE Di-RutaG.CodCia = s-CodCia AND
            Di-RutaG.CodDoc = "H/R" AND
            Di-RutaG.CodAlm = Almcmov.CodAlm AND
            Di-RutaG.Tipmov = Almcmov.TipMov AND
            Di-RutaG.Codmov = Almcmov.CodMov AND
            Di-RutaG.serref = Almcmov.NroSer AND
            Di-RutaG.nroref = Almcmov.NroDoc AND
            CAN-FIND(FIRST Di-RutaC OF Di-RutaG WHERE Di-RutaC.FlgEst BEGINS "P" NO-LOCK)
            NO-LOCK NO-ERROR.
        IF AVAILABLE Di-RutaG THEN NEXT.

        ASSIGN
            pDateTime2 = DATETIME( MONTH(Almcmov.FchDoc), 
                                   DAY(Almcmov.FchDoc),
                                   YEAR(Almcmov.FchDoc),
                                   INTEGER(ENTRY(1,Almcmov.HorSal,':')),
                                   INTEGER(ENTRY(2,Almcmov.HorSal,':')) ).
        x-Horas = INTERVAL (pDateTime1, pDateTime2, 'hours') .
        CREATE t-Almcmov.
        BUFFER-COPY Almcmov TO t-Almcmov
            ASSIGN t-Almcmov.Libre_d01 = x-Horas.
    END.
END.
FOR EACH t-Almcmov NO-LOCK BY t-Almcmov.Libre_d01 DESC:
    x-Horas = t-Almcmov.Libre_d01.
    CASE TRUE:
        WHEN x-Horas >= 120 THEN DO:
            MESSAGE 'Han pasado más de 5 días y la Guía por Transferencia' 
                (STRING(t-Almcmov.NroSer, '999') + '-' + STRING(t-Almcmov.NroDoc, '99999999'))
                'aún no ha sido recepcionada' SKIP(1)
                'Viene del Almacén' t-Almcmov.CodAlm 'con destino al Almacén' t-Almcmov.AlmDes SKIP
                'Fue emitida el' t-Almcmov.FchDoc 'a las' t-Almcmov.HorSal 'horas' SKIP
                VIEW-AS ALERT-BOX WARNING.
            HIDE FRAME f-Proceso.
            RETURN 'ADM-ERROR'.
        END.
    END CASE.
END.

/* 2do. Verificamos Ingresos por Transferencias Pendientes */
EMPTY TEMP-TABLE t-Almcmov.
RLOOP:
FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia AND Almacen.campo-c[9] <> "I":
    FOR EACH Almcmov NO-LOCK WHERE Almcmov.codcia = s-codcia AND
        Almcmov.codalm = Almacen.codalm AND
        Almcmov.tipmov = "S" AND
        Almcmov.codmov = 03 AND
        Almcmov.flgsit = "T" AND
        Almcmov.flgest <> "A",
        FIRST b-Almacen NO-LOCK WHERE b-Almacen.codcia = s-codcia AND
        b-Almacen.codalm = Almcmov.almdes AND
        b-Almacen.coddiv = pCodDiv:
        ASSIGN
            pDateTime2 = DATETIME( MONTH(Almcmov.FchDoc), 
                                   DAY(Almcmov.FchDoc),
                                   YEAR(Almcmov.FchDoc),
                                   INTEGER(ENTRY(1,Almcmov.HorSal,':')),
                                   INTEGER(ENTRY(2,Almcmov.HorSal,':')) ).
        x-Horas = INTERVAL (pDateTime1, pDateTime2, 'hours') .
        CREATE t-Almcmov.
        BUFFER-COPY Almcmov TO t-Almcmov
            ASSIGN t-Almcmov.Libre_d01 = x-Horas.
        /* Buscamos si tiene una H/R cerrada y entregada */
        FOR EACH Di-RutaG NO-LOCK WHERE Di-RutaG.CodCia = s-CodCia AND
            Di-RutaG.CodDoc = "H/R" AND
            Di-RutaG.CodAlm = Almcmov.CodAlm AND
            Di-RutaG.Tipmov = Almcmov.TipMov AND
            Di-RutaG.Codmov = Almcmov.CodMov AND
            Di-RutaG.serref = Almcmov.NroSer AND
            Di-RutaG.nroref = Almcmov.NroDoc AND
            Di-RutaG.FlgEst = "C",
            FIRST Di-RutaC OF Di-RutaG NO-LOCK WHERE Di-RutaC.FlgEst = "C":
            ASSIGN
                pDateTime2 = DATETIME( MONTH(Di-RutaC.FchSal), 
                                       DAY(Di-RutaC.FchSal),
                                       YEAR(Di-RutaC.FchSal),
                                       INTEGER(ENTRY(1,Di-RutaG.HorLle,':')),
                                       INTEGER(ENTRY(2,Di-RutaG.HorLle,':')) ).
            x-Horas = INTERVAL (pDateTime1, pDateTime2, 'hours') .
            ASSIGN t-Almcmov.Libre_d01 = x-Horas.
            LEAVE.
        END.
        /* SI es mayor a 72 horas ya no vale la pena seguir buscando */
        IF x-Horas >= 72 THEN LEAVE RLOOP.
    END.
END.

/* FOR EACH b-Almacen NO-LOCK WHERE b-Almacen.codcia = s-CodCia AND                            */
/*     b-Almacen.coddiv = pCodDiv AND                                                          */
/*     b-Almacen.campo-c[9] <> "I":                                                            */
/*     /* Buscamos los almacenes de salida de mercaderia */                                    */
/*     FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-CodCia AND Almacen.campo-c[9] <> "I", */
/*         EACH Almcmov NO-LOCK WHERE Almcmov.codcia = s-CodCia AND                            */
/*         Almcmov.codalm = Almacen.CodAlm AND     /* Almacén de Salida */                     */
/*         Almcmov.tipmov = 'S' AND                                                            */
/*         Almcmov.codmov = 03 AND                                                             */
/*         Almcmov.almdes = b-Almacen.CodAlm AND   /* Almacén Destino */                       */
/*         Almcmov.flgsit = "T" AND                                                            */
/*         Almcmov.flgest <> "A":                                                              */
/*         ASSIGN                                                                              */
/*             pDateTime2 = DATETIME( MONTH(Almcmov.FchDoc),                                   */
/*                                    DAY(Almcmov.FchDoc),                                     */
/*                                    YEAR(Almcmov.FchDoc),                                    */
/*                                    INTEGER(ENTRY(1,Almcmov.HorSal,':')),                    */
/*                                    INTEGER(ENTRY(2,Almcmov.HorSal,':')) ).                  */
/*         x-Horas = INTERVAL (pDateTime1, pDateTime2, 'hours') .                              */
/*         CREATE t-Almcmov.                                                                   */
/*         BUFFER-COPY Almcmov TO t-Almcmov                                                    */
/*             ASSIGN t-Almcmov.Libre_d01 = x-Horas.                                           */
/*         /* Buscamos si tiene una H/R cerrada y entregada */                                 */
/*         FOR EACH Di-RutaG NO-LOCK WHERE Di-RutaG.CodCia = s-CodCia AND                      */
/*             Di-RutaG.CodDoc = "H/R" AND                                                     */
/*             Di-RutaG.CodAlm = Almcmov.CodAlm AND                                            */
/*             Di-RutaG.Tipmov = Almcmov.TipMov AND                                            */
/*             Di-RutaG.Codmov = Almcmov.CodMov AND                                            */
/*             Di-RutaG.serref = Almcmov.NroSer AND                                            */
/*             Di-RutaG.nroref = Almcmov.NroDoc AND                                            */
/*             Di-RutaG.FlgEst = "C",                                                          */
/*             FIRST Di-RutaC OF Di-RutaG NO-LOCK WHERE Di-RutaC.FlgEst = "C":                 */
/*             ASSIGN                                                                          */
/*                 pDateTime2 = DATETIME( MONTH(Di-RutaC.FchSal),                              */
/*                                        DAY(Di-RutaC.FchSal),                                */
/*                                        YEAR(Di-RutaC.FchSal),                               */
/*                                        INTEGER(ENTRY(1,Di-RutaG.HorLle,':')),               */
/*                                        INTEGER(ENTRY(2,Di-RutaG.HorLle,':')) ).             */
/*             x-Horas = INTERVAL (pDateTime1, pDateTime2, 'hours') .                          */
/*             ASSIGN t-Almcmov.Libre_d01 = x-Horas.                                           */
/*             LEAVE.                                                                          */
/*         END.                                                                                */
/*         /* SI es mayor a 72 horas ya no vale la pena seguir buscando */                     */
/*         IF x-Horas >= 72 THEN LEAVE RLOOP.                                                  */
/*     END.                                                                                    */
/* END.                                                                                        */

FOR EACH t-Almcmov NO-LOCK BY t-Almcmov.Libre_d01 DESC:
    x-Horas = t-Almcmov.Libre_d01.
    CASE TRUE:
        WHEN x-Horas >= 72 THEN DO:
            MESSAGE 'Han pasado más de 72 horas y la Guía por Transferencia' 
                (STRING(t-Almcmov.NroSer, '999') + '-' + STRING(t-Almcmov.NroDoc, '99999999'))
                'aún no ha sido recepcionada' SKIP(1)
                'Viene del Almacén' t-Almcmov.CodAlm 'con destino al Almacén' t-Almcmov.AlmDes SKIP
                'Fue emitida el' t-Almcmov.FchDoc 'a las' t-Almcmov.HorSal 'horas' SKIP
                VIEW-AS ALERT-BOX WARNING.
            HIDE FRAME f-Proceso.
            RETURN 'ADM-ERROR'.
        END.
        WHEN x-Horas >= 48 THEN DO:
            MESSAGE 'Han pasado más de 48 horas y la Guía por Transferencia' 
                (STRING(t-Almcmov.NroSer, '999') + '-' + STRING(t-Almcmov.NroDoc, '99999999'))
                'aún no ha sido recepcionada' SKIP(1)
                'Viene del Almacén' t-Almcmov.CodAlm 'con destino al Almacén' t-Almcmov.AlmDes SKIP
                'Fue emitida el' t-Almcmov.FchDoc 'a las' t-Almcmov.HorSal 'horas' SKIP
                VIEW-AS ALERT-BOX INFORMATION.
        END.
        WHEN x-Horas >= 24 THEN DO:
            MESSAGE 'Han pasado más de 24 horas y la Guía por Transferencia' 
                (STRING(t-Almcmov.NroSer, '999') + '-' + STRING(t-Almcmov.NroDoc, '99999999'))
                'aún no ha sido recepcionada' SKIP(1)
                'Viene del Almacén' t-Almcmov.CodAlm 'con destino al Almacén' t-Almcmov.AlmDes SKIP
                'Fue emitida el' t-Almcmov.FchDoc 'a las' t-Almcmov.HorSal 'horas' SKIP
                VIEW-AS ALERT-BOX INFORMATION.
        END.
    END CASE.
    LEAVE.
END.
HIDE FRAME f-Proceso.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

