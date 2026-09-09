&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CcbCBult FOR CcbCBult.
DEFINE BUFFER B-ControlOD FOR ControlOD.
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE BUFFER B-Vtaddocu FOR VtaDDocu.



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

DEF INPUT PARAMETER pCodAlm     AS CHAR.    /* Almacén Origen */
DEF INPUT PARAMETER pAlmDes     AS CHAR.    /* Almacén Destino */
DEF INPUT PARAMETER pCodDoc     AS CHAR.    /* OTR */
DEF INPUT PARAMETER pNroPed     AS CHAR.
DEF OUTPUT PARAMETER pMensaje   AS CHAR.

pMensaje = "".

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

/* NOTA: La división debe ser la del Almacén de Origen */
DEF VAR s-CodDiv AS CHAR NO-UNDO.
FIND FIRST Almacen WHERE Almacen.codcia = s-CodCia
    AND Almacen.codalm = pCodAlm
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almacen THEN DO:
    pMensaje = "NO se ubicó el almacén " + pCodAlm.
    RETURN 'ADM-ERROR'.
END.
s-CodDiv = Almacen.CodDiv.
FIND B-CPEDI WHERE B-CPEDI.codcia = s-CodCia
    AND B-CPEDI.coddoc = pCodDoc    /* OTR */
    AND B-CPEDI.nroped = pNroPed
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CPEDI THEN DO:
    pMensaje = "NO se ubicó la Orden de Transferencia " + pCodDoc + ' ' + pNroPed.
    RETURN 'ADM-ERROR'.
END.
IF B-CPEDI.CodRef <> "R/A" THEN DO:
    pMensaje = "NO es una OTR por Cross Docking por Reposición de Mercadería" + pCodDoc + ' ' + pNroPed.
    RETURN 'ADM-ERROR'.
END.

DEFINE VARIABLE s-CodDoc AS CHAR INIT "OTR" NO-UNDO.
DEFINE VARIABLE s-NroSer AS INT NO-UNDO.

/* SOLO SE PUEDE MIGRAR UNA VEZ */
IF CAN-FIND(FIRST Faccpedi WHERE Faccpedi.codcia = s-CodCia
            AND Faccpedi.coddiv = s-CodDiv
            AND Faccpedi.coddoc = s-CodDoc
            AND Faccpedi.codref = B-CPEDI.CodRef
            AND Faccpedi.nroref = B-CPEDI.NroRef
            AND Faccpedi.flgest <> "A"
            NO-LOCK) THEN RETURN 'OK'.
FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
    FacCorre.CodDiv = S-CODDIV AND
    FacCorre.CodDoc = S-CODDOC AND
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
   pMensaje = "Correlativo del Documento no configurado: " + s-coddoc + CHR(10) +
       "en la división: " + s-CodDiv.
   RETURN 'ADM-ERROR'.
END.
ASSIGN
    s-NroSer = FacCorre.NroSer.

FIND FIRST FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK.

DEFINE VARIABLE s-DiasVtoO_D LIKE GN-DIVI.DiasVtoO_D.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    pMensaje =  'División ' + s-coddiv + ' NO configurada'.
    RETURN 'ADM-ERROR'.
END.
s-DiasVtoO_D = GN-DIVI.DiasVtoO_D.

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
      TABLE: B-CcbCBult B "?" ? INTEGRAL CcbCBult
      TABLE: B-ControlOD B "?" ? INTEGRAL ControlOD
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: B-Vtaddocu B "?" ? INTEGRAL VtaDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 5.12
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE VAR x-Comprobante AS CHAR NO-UNDO.
DEFINE VAR iNroSKU AS INT NO-UNDO.
DEFINE VAR iPeso AS DEC NO-UNDO.
DEFINE VAR lFechaPedido AS DATE NO-UNDO.
DEFINE VAR cUbigeo AS CHAR NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Paso 02 : Adiciono el Registro en la Cabecera */
    {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}

    /* ***************************************************************** */
    /* Determino la fecha de entrega del pedido */
    /* ***************************************************************** */
    ASSIGN
        iNroSKU = 0
        iPeso = 0.
    FOR EACH B-DPEDI OF B-CPEDI NO-LOCK, FIRST Almmmatg OF B-DPEDI NO-LOCK:
        iNroSKU = iNroSKU + 1.
        iPeso = iPeso + (B-DPEDI.CanPed * B-DPEDI.Factor) * Almmmatg.PesMat.
    END.
    lFechaPedido = TODAY.
    FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = pAlmDes NO-LOCK NO-ERROR.
    FIND gn-divi WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = Almacen.coddiv
        NO-LOCK NO-ERROR.
    cUbigeo = TRIM(gn-divi.Campo-Char[3]) + TRIM(gn-divi.Campo-Char[4]) + TRIM(gn-divi.Campo-Char[5]).

    CREATE Faccpedi.
    BUFFER-COPY B-CPEDI TO Faccpedi
    ASSIGN 
        Faccpedi.CodCia = S-CODCIA
        Faccpedi.CodDiv = s-CodDiv
        Faccpedi.CodDoc = s-coddoc 
        Faccpedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        Faccpedi.FchPed = TODAY
        FacCPedi.Libre_c01 = s-User-id + '|' + STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM')
        FacCPedi.Fchent = lFechaPedido
        Faccpedi.FchVen = lFechaPedido + 7
        FacCPedi.CodAlm = pCodAlm
        FacCPedi.AlmacenXD = ''         /* OJO: Ya no es cross docking */
        FacCPedi.CrossDocking = NO
        FacCPedi.FlgEst = 'X'           /* Temporalmente */
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "NO se pudo crear la OTR".
        UNDO, LEAVE.
    END.
    /* Datos adicionales */
    ASSIGN
        Faccpedi.codcli  = pAlmDes
        Faccpedi.nomcli  = Almacen.Descripcion 
        Faccpedi.dircli  = Almacen.DirAlm
        Faccpedi.Usuario = S-USER-ID
        Faccpedi.Hora   = STRING(TIME,"HH:MM").
    /* Division destino */
    FIND Almacen OF Faccpedi NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN FacCPedi.DivDes = Almacen.CodDiv.
    /* *********************************************************** */
    /* FECHA DE ENTREGA */
    /* *********************************************************** */
    RUN logis/p-fecha-de-entrega (Faccpedi.CodDoc,
                                  Faccpedi.NroPed,
                                  INPUT-OUTPUT lFechaPedido,
                                  OUTPUT pMensaje).
/*     RUN gn/p-fchent-v3 (FacCPedi.CodAlm,           */
/*                         TODAY,                     */
/*                         STRING(TIME,'HH:MM:SS'),   */
/*                         FacCPedi.CodCli,           */
/*                         FacCPedi.CodDiv,           */
/*                         cUbigeo,                   */
/*                         FacCPedi.CodDoc,           */
/*                         FacCPedi.NroPed,           */
/*                         iNroSKU,                   */
/*                         iPeso,                     */
/*                         INPUT-OUTPUT lFechaPedido, */
/*                         OUTPUT pMensaje).          */
    IF pMensaje > '' THEN UNDO, LEAVE.
    ASSIGN
        FacCPedi.FchEnt = lFechaPedido
        Faccpedi.FchVen = lFechaPedido + 7.
    /* *********************************************************** */
    /* TRACKING */
    /* *********************************************************** */
    RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                            Faccpedi.CodDiv,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef,
                            s-User-Id,
                            'GOT',    /* Generación OTR */
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef)
        NO-ERROR.
    /* *********************************************************** */
    /* *************************************************************** */
    /* RHC 21/11/2016 DATOS DEL CIERRE DE LA OTR EN LA DIVISION ORIGEN */
    /* *************************************************************** */
    FOR EACH Vtaddocu NO-LOCK WHERE VtaDDocu.CodCia = B-CPEDI.CodCia
        AND VtaDDocu.CodDiv = B-CPEDI.CodDiv
        AND VtaDDocu.CodPed = B-CPEDI.CodDoc
        AND VtaDDocu.NroPed = B-CPEDI.NroPed:
        CREATE B-Vtaddocu.
        BUFFER-COPY Vtaddocu TO B-Vtaddocu
            ASSIGN 
            B-Vtaddocu.CodDiv = s-CodDiv
            B-Vtaddocu.CodPed = Faccpedi.CodDoc
            B-Vtaddocu.NroPed = Faccpedi.NroPed
            B-Vtaddocu.CodCli = Faccpedi.CodCli
            NO-ERROR.
    END.
    FOR EACH ControlOD NO-LOCK WHERE ControlOD.CodCia = B-CPEDI.CodCia
        AND ControlOD.CodDiv = B-CPEDI.CodDiv
        AND ControlOD.CodDoc = B-CPEDI.CodDoc
        AND ControlOD.NroDoc = B-CPEDI.NroPed:
        CREATE B-ControlOD.
        BUFFER-COPY ControlOD TO B-ControlOD
            ASSIGN
            B-ControlOD.CodDiv = s-CodDiv
            B-ControlOD.CodDoc = Faccpedi.CodDoc
            B-ControlOD.NroDoc = Faccpedi.NroPed
            B-ControlOD.CodAlm = Faccpedi.CodAlm
            B-ControlOD.CodCli = Faccpedi.CodCli
            NO-ERROR.
    END.
    FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = B-CPEDI.CodCia
        AND CcbCBult.CodDiv = B-CPEDI.CodDiv
        AND CcbCBult.CodDoc = B-CPEDI.CodDoc
        AND CcbCBult.NroDoc = B-CPEDI.NroPed:
        CREATE B-CcbCBult.
        BUFFER-COPY CcbCBult TO B-CcbCBult
            ASSIGN
            B-CcbCBult.CodDiv = s-CodDiv
            B-CcbCBult.CodDoc = Faccpedi.CodDoc
            B-CcbCBult.NroDoc = Faccpedi.NroPed
            B-CcbCBult.CodCli = Faccpedi.CodCli
            NO-ERROR.
    END.
    /* *************************************************************** */
    /* *************************************************************** */
    ASSIGN 
        FacCPedi.UsrAprobacion = S-USER-ID
        FacCPedi.FchAprobacion = TODAY.
    /* CONTROL DE OTROS PROCESOS POR DIVISION */
    ASSIGN 
        FacCPedi.FlgEst = 'P'
        FacCPedi.FlgSit = 'C'.      /* DIRECTO A DISTRIBUCION */

    RUN Genera-Pedido.    /* Detalle del pedido */ 
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = "No se pudo generar el detalle de la Orden de Despacho".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN 
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    x-Comprobante = Faccpedi.coddoc + ' ' + Faccpedi.nroped.
END.
IF AVAILABLE(Faccorre) THEN RELEASE FacCorre.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
IF AVAILABLE(Ccbadocu) THEN RELEASE Ccbadocu.
IF AVAILABLE(B-CPEDI)  THEN RELEASE B-CPEDI.
IF AVAILABLE(B-DPEDI)  THEN RELEASE B-DPEDI.

pMensaje = x-Comprobante.   /* devuelvo la OTR */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Genera-Pedido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pedido Procedure 
PROCEDURE Genera-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

   FOR EACH B-DPEDI OF B-CPEDI NO-LOCK BY B-DPEDI.NroItm:
       /* GRABAMOS LA DIVISION Y EL ALMACEN DESTINO EN LA CABECERA */
       I-NITEM = I-NITEM + 1.
       CREATE FacDPedi. 
       BUFFER-COPY B-DPEDI 
           TO FacDPedi
           ASSIGN  
           FacDPedi.CodCia  = FacCPedi.CodCia 
           FacDPedi.coddiv  = FacCPedi.coddiv 
           FacDPedi.AlmDes  = FacCPedi.CodAlm
           FacDPedi.coddoc  = FacCPedi.coddoc 
           FacDPedi.NroPed  = FacCPedi.NroPed 
           FacDPedi.FchPed  = FacCPedi.FchPed
           FacDPedi.Hora    = FacCPedi.Hora 
           FacDPedi.FlgEst  = 'P'       /*FacCPedi.FlgEst*/
           FacDPedi.NroItm  = I-NITEM
           FacDPedi.CanAte  = 0                     /* <<< OJO <<< */
           FacDPedi.CanSol  = FacDPedi.CanPed       /* <<< OJO <<< */
           FacDPedi.CanPick = FacDPedi.CanPed      /* <<< OJO <<< */
           NO-ERROR.
       IF ERROR-STATUS:ERROR THEN DO:
           pMensaje = "Error al grabar el producto " + B-DPEDI.codmat.
           UNDO, RETURN 'ADM-ERROR'.
       END.
   END.
   RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

