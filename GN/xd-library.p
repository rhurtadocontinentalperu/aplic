&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CcbADocu FOR CcbADocu.
DEFINE BUFFER B-CcbCBult FOR CcbCBult.
DEFINE BUFFER B-ControlOD FOR ControlOD.
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE TEMP-TABLE b-VtaDDocu NO-UNDO LIKE VtaDDocu.
DEFINE BUFFER ORDEN FOR FacCPedi.



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

RUN <libreria>.rutina_internaIN hProc (input  buffer tt-excel:handle,
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
      TABLE: B-CcbADocu B "?" ? INTEGRAL CcbADocu
      TABLE: B-CcbCBult B "?" ? INTEGRAL CcbCBult
      TABLE: B-ControlOD B "?" ? INTEGRAL ControlOD
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: b-VtaDDocu T "?" NO-UNDO INTEGRAL VtaDDocu
      TABLE: ORDEN B "?" ? INTEGRAL FacCPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 7.12
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-XD_Cierre-IngTra-OTR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE XD_Cierre-IngTra-OTR Procedure 
PROCEDURE XD_Cierre-IngTra-OTR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Cierre de chequeo de OTR por Ingreso por Transferencia
               SOLO si la G/R de Origen es por CrossDocking
------------------------------------------------------------------------------*/

    DEF INPUT  PARAMETER pRowid AS ROWID.
    DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    DEF BUFFER B-CMOV FOR Almcmov.

    FIND FIRST B-CMOV WHERE ROWID(B-CMOV) = pRowid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CMOV THEN DO:
        pMensaje = "NO se ubicó la G/R de salida por transferencia".
        RETURN 'ADM-ERROR'.
    END.
    IF B-CMOV.CrossDocking = NO THEN RETURN 'OK'.   /* SOLO SI ES POR CROSSDOCKING */
    /* ********************************************************************* */
    /* RHC 21/12/2017 MIGRACION DE ORDENES DE DESPACHO DEL ORIGEN AL DESTINO */
    /* La OTR Tiene como CodRef = "R/A" */
    /* La O/D Tiene como CodRef = "PED" */
    /* ********************************************************************* */
    FIND ORDEN WHERE ORDEN.codcia = s-codcia 
        AND ORDEN.coddoc = B-CMOV.codref 
        AND ORDEN.nroped = B-CMOV.nroref NO-LOCK NO-ERROR.
    CASE TRUE:
        WHEN ORDEN.CodRef = "R/A" THEN DO:
            RUN XD_Migra-RA (Almcmov.CodAlm,      /* Almacén de Origen */
                             Almcmov.AlmacenXD,   /* Almacén de Destino */
                             B-CMOV.CodRef,         /* OTR */
                             B-CMOV.NroRef,         /* Número de la OTR */
                             OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo migrar la OTR'.
                UNDO, RETURN 'ADM-ERROR'.
            END.
        END.
        WHEN ORDEN.CodRef = "PED" THEN DO:
            RUN XD_Migra-OTR (Almcmov.CodAlm,         /* Almacén de Origen */
                              B-CMOV.CodRef,         /* OTR */
                              B-CMOV.NroRef,         /* Número de la OTR */
                              OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo migrar la OTR'.
                UNDO, RETURN 'ADM-ERROR'.
            END.
        END.
    END CASE.
    IF AVAILABLE(Almcmov) THEN RELEASE Almcmov.
    /* ********************************************************************* */
    /* ********************************************************************* */
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-XD_Genera-Pedido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE XD_Genera-Pedido Procedure 
PROCEDURE XD_Genera-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

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

&IF DEFINED(EXCLUDE-XD_Migra-OTR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE XD_Migra-OTR Procedure 
PROCEDURE XD_Migra-OTR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodAlm     AS CHAR.    /* Almacén Origen */
DEF INPUT PARAMETER pCodDoc     AS CHAR.    /* OTR */
DEF INPUT PARAMETER pNroPed     AS CHAR.
DEF OUTPUT PARAMETER pComprobante AS CHAR.
DEF OUTPUT PARAMETER pMensaje   AS CHAR NO-UNDO.

pMensaje = "".
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
/* Buscamos la OTR del Origen */
FIND ORDEN WHERE ORDEN.codcia = s-codcia
    AND ORDEN.coddoc = pCodDoc
    AND ORDEN.nroped = pNroPed
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE ORDEN THEN DO:
    pMensaje = "NO se ubicó la orden: " + pCodDoc + ' ' + pNroPed.
    RETURN 'ADM-ERROR'.
END.
IF ORDEN.CrossDocking = NO OR LOOKUP(ORDEN.CodRef,"R/A,PED") = 0 THEN DO:
    pMensaje = "NO es una Orden por Cross Docking: " + pCodDoc + ' ' + pNroPed.
    RETURN 'ADM-ERROR'.
END.
/* Buscamos el PED del origen */
FIND B-CPEDI WHERE B-CPEDI.codcia = s-CodCia
    AND B-CPEDI.coddoc = ORDEN.CodRef
    AND B-CPEDI.nroped = ORDEN.NroRef
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CPEDI THEN DO:
    pMensaje = "NO se ubicó el pedido " + pCodDoc + ' ' + pNroPed.
    RETURN 'ADM-ERROR'.
END.
/* RHC 12/02/2018 SE VA A GENERAR UNA NUEVA O/D PARA EL CLIENTE */
DEFINE VARIABLE s-CodDoc AS CHAR INIT "O/D" NO-UNDO.
DEFINE VARIABLE s-NroSer AS INT NO-UNDO.
/* SOLO SE PUEDE MIGRAR UNA VEZ */
IF CAN-FIND(FIRST Faccpedi WHERE Faccpedi.codcia = s-CodCia
            AND Faccpedi.coddiv = s-CodDiv
            AND Faccpedi.coddoc = s-CodDoc              /* O/D */
            AND Faccpedi.codref = B-CPEDI.CodDoc        /* PED */
            AND Faccpedi.nroref = B-CPEDI.NroPed
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

/* PARAMETROS DE COTIZACION PARA LA DIVISION */
DEFINE VARIABLE s-FlgPicking LIKE GN-DIVI.FlgPicking.
DEFINE VARIABLE s-FlgBarras LIKE GN-DIVI.FlgBarras.
DEFINE VARIABLE s-DiasVtoO_D LIKE GN-DIVI.DiasVtoO_D.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    pMensaje = 'División ' + s-coddiv + ' NO configurada'.
    RETURN 'ADM-ERROR'.
END.
ASSIGN
    s-FlgPicking = GN-DIVI.FlgPicking
    s-FlgBarras  = GN-DIVI.FlgBarras
    s-DiasVtoO_D = GN-DIVI.DiasVtoO_D.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="FacCorre" ~
        &Condicion="FacCorre.CodCia = s-codcia ~
        AND FacCorre.CodDoc = s-coddoc ~
        AND FacCorre.NroSer = s-nroser" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        }
    CREATE FacCPedi.
    BUFFER-COPY B-CPEDI 
        EXCEPT 
        B-CPEDI.TpoPed
        B-CPEDI.FlgEst
        B-CPEDI.FlgSit
        B-CPEDI.TipVta
        TO FacCPedi
        ASSIGN 
            FacCPedi.CodCia = S-CODCIA
            FacCPedi.CodDiv = S-CODDIV
            FacCPedi.CodAlm = pCodAlm       /* Almacén de Despacho */
            FacCPedi.CodDoc = s-coddoc 
            FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
            FacCPedi.CodRef = B-CPEDI.CodDoc    /* PED */
            FacCPedi.NroRef = B-CPEDI.NroPed
            FacCPedi.TpoCmb = FacCfgGn.TpoCmb[1] 
            FacCPedi.FchPed = TODAY
            FacCPedi.FchEnt = TODAY
            FacCPedi.FchVen = TODAY + s-DiasVtoO_D
            FacCPedi.Hora = STRING(TIME,"HH:MM")
            FacCPedi.FlgEst = 'X'   /* PROCESANDO: revisar rutina Genera-Pedido */
            FacCPedi.TpoPed = "XD"  /* <<< OJO <<< */
            FacCPedi.CrossDocking = NO
            FacCPedi.AlmacenXD = ''
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Correlativo de la Orden mal registrado o duplicado".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN 
        Faccpedi.Usuario = S-USER-ID
        Faccpedi.Hora   = STRING(TIME,"HH:MM").
    /* ************************************************************ */
    /* ************************************************************ */
    /* Division destino */
    FIND Almacen OF Faccpedi NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN FacCPedi.DivDes = Almacen.CodDiv.
    /* ************************************************************************** */
    /* TRACKING */
    /* ************************************************************************** */
    RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                            Faccpedi.CodDiv,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef,
                            s-User-Id,
                            'GOD',
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef)
        NO-ERROR.
    /* ************************************************************************** */
    /* RHC 22/11/17 se va a volver a calcular la fecha de entrega                 */
    /* ************************************************************************** */
    DEF VAR pFchEnt AS DATE NO-UNDO.
    DEF VAR pNroSKU AS INT NO-UNDO.
    DEF VAR pPeso   AS DEC NO-UNDO.

    RUN logis/p-fecha-de-entrega (FacCPedi.CodDoc,              /* Documento actual */
                                  FacCPedi.NroPed,
                                  INPUT-OUTPUT pFchEnt,
                                  OUTPUT pMensaje).
    IF pMensaje > '' THEN DO:
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        FacCPedi.FchEnt = pFchEnt.  /* OJO */
    /* ************************************************************************** */
    /* *********************************************************** */
    /* *************************************************************** */
    /* RHC 21/11/2016 DATOS DEL CIERRE DE LA OTR EN LA DIVISION ORIGEN */
    /* *************************************************************** */
    FOR EACH Vtaddocu NO-LOCK WHERE VtaDDocu.CodCia = ORDEN.CodCia
        AND VtaDDocu.CodDiv = ORDEN.CodDiv
        AND VtaDDocu.CodPed = ORDEN.CodDoc
        AND VtaDDocu.NroPed = ORDEN.NroPed:
        CREATE B-Vtaddocu.
        BUFFER-COPY Vtaddocu TO B-Vtaddocu
            ASSIGN
            B-Vtaddocu.CodDiv = s-CodDiv
            B-Vtaddocu.CodPed = Faccpedi.CodDoc
            B-Vtaddocu.NroPed = Faccpedi.NroPed
            B-Vtaddocu.CodCli = Faccpedi.CodCli
            NO-ERROR.
    END.
    FOR EACH ControlOD NO-LOCK WHERE ControlOD.CodCia = ORDEN.CodCia
        AND ControlOD.CodDiv = ORDEN.CodDiv
        AND ControlOD.CodDoc = ORDEN.CodDoc
        AND ControlOD.NroDoc = ORDEN.NroPed:
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
    FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = ORDEN.CodCia
        AND CcbCBult.CodDiv = ORDEN.CodDiv
        AND CcbCBult.CodDoc = ORDEN.CodDoc
        AND CcbCBult.NroDoc = ORDEN.NroPed:
        CREATE B-CcbCBult.
        BUFFER-COPY CcbCBult TO B-CcbCBult
            ASSIGN
            B-CcbCBult.CodDiv = s-CodDiv
            B-CcbCBult.CodDoc = Faccpedi.CodDoc
            B-CcbCBult.NroDoc = Faccpedi.NroPed
            B-CcbCBult.CodCli = Faccpedi.CodCli
            NO-ERROR.
    END.
    /* RHC 21/05/2018 TRANSPORTISTA */
    FOR EACH CcbADocu NO-LOCK WHERE CcbADocu.CodCia = B-CPEDI.CodCia
        AND CcbADocu.CodDiv = B-CPEDI.CodDiv
        AND CcbADocu.CodDoc = B-CPEDI.CodDoc
        AND CcbADocu.NroDoc = B-CPEDI.NroPed:
        CREATE B-CcbADocu.
        BUFFER-COPY 
            CcbADocu TO B-CcbADocu
            ASSIGN
            B-CcbADocu.CodDiv = s-CodDiv
            B-CcbADocu.CodDoc = Faccpedi.CodDoc
            B-CcbADocu.NroDoc = Faccpedi.NroPed.
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

   DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
   FOR EACH B-DPEDI OF B-CPEDI NO-LOCK BY B-DPEDI.NroItm ON ERROR UNDO, THROW:
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
           FacDPedi.CanPick = FacDPedi.CanPed.     /* <<< OJO <<< */
   END.
   ASSIGN 
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    pComprobante = Faccpedi.coddoc + ' ' + Faccpedi.nroped.
END.
IF AVAILABLE(Faccorre) THEN RELEASE FacCorre.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
IF AVAILABLE(Ccbcbult) THEN RELEASE Ccbcbult.
IF AVAILABLE(Ccbadocu) THEN RELEASE Ccbadocu.
IF AVAILABLE(B-CPEDI)  THEN RELEASE B-CPEDI.
IF AVAILABLE(B-DPEDI)  THEN RELEASE B-DPEDI.
/*pMensaje = x-Comprobante.   /* devuelvo la OTR */*/

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-XD_Migra-RA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE XD_Migra-RA Procedure 
PROCEDURE XD_Migra-RA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodAlm     AS CHAR.    /* Almacén Origen */
DEF INPUT PARAMETER pAlmDes     AS CHAR.    /* Almacén Destino */
DEF INPUT PARAMETER pCodDoc     AS CHAR.    /* OTR u O/D */
DEF INPUT PARAMETER pNroPed     AS CHAR.
DEF OUTPUT PARAMETER pComprobante AS CHAR.
DEF OUTPUT PARAMETER pMensaje   AS CHAR NO-UNDO.

pMensaje = "".

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
    AND B-CPEDI.coddoc = pCodDoc    /* OTR u O/D */
    AND B-CPEDI.nroped = pNroPed
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CPEDI THEN DO:
    pMensaje = "NO se ubicó la Orden " + pCodDoc + ' ' + pNroPed.
    RETURN 'ADM-ERROR'.
END.
IF LOOKUP(B-CPEDI.CodRef, "R/A,PED") = 0 THEN DO:
    pMensaje = "NO es una Orden por Cross Docking: " + pCodDoc + ' ' + pNroPed.
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
            NO-LOCK) 
    THEN RETURN 'OK'.
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

DEFINE VAR iNroSKU AS INT NO-UNDO.
DEFINE VAR iPeso AS DEC NO-UNDO.
DEFINE VAR lFechaPedido AS DATE NO-UNDO.
DEFINE VAR cUbigeo AS CHAR NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Paso 02 : Adiciono el Registro en la Cabecera */
    {lib/lock-genericov3.i
        &Tabla="FacCorre"
        &Condicion="FacCorre.codcia = s-codcia ~
        AND FacCorre.coddoc = s-coddoc ~
        AND FacCorre.nroser = s-nroser"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
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
        FacCPedi.TpoPed = "XD"          /* OJO >>> Es una forma de marcar las nuevas OTR */
        FacCPedi.FlgEst = 'X'           /* Temporalmente */
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "NO se pudo crear la OTR".
        UNDO, RETURN 'ADM-ERROR'.
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
    RUN logis/p-fecha-de-entrega (INPUT Faccpedi.CodDoc,
                                  INPUT Faccpedi.NroPed,
                                  INPUT-OUTPUT lFechaPedido,
                                  OUTPUT pMensaje).
    IF pMensaje > '' THEN UNDO, RETURN 'ADM-ERROR'.
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
        FIND FIRST B-ControlOD WHERE B-ControlOD.CodCia = ControlOD.CodCia AND
            B-ControlOD.CodDiv = s-CodDiv AND
            B-ControlOD.CodDoc = Faccpedi.CodDoc AND
            B-ControlOD.NroDoc = Faccpedi.NroPed AND
            B-ControlOD.NroEtq = ControlOD.NroEtq AND
            B-ControlOD.CodAlm = Faccpedi.CodAlm AND
            B-ControlOD.CodCli = Faccpedi.CodCli
            NO-LOCK NO-ERROR.
        IF AVAILABLE B-ControlOD THEN NEXT.
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
/*         FIND FIRST B-CcbCBult WHERE B-CcbCBult.CodCia = Faccpedi.CodCia AND */
/*             B-CcbCBult.CodDiv = s-CodDiv AND                                */
/*             B-CcbCBult.CodDoc = Faccpedi.CodDoc AND                         */
/*             B-CcbCBult.NroDoc = Faccpedi.NroPed AND                         */
/*             B-CcbCBult.CodCli = Faccpedi.CodCli                             */
/*             NO-LOCK NO-ERROR.                                               */
/*         IF AVAILABLE B-CcbCBult THEN NEXT.                                  */
        CREATE B-CcbCBult.
        BUFFER-COPY CcbCBult TO B-CcbCBult
            ASSIGN
            B-CcbCBult.CodDiv = s-CodDiv
            B-CcbCBult.CodDoc = Faccpedi.CodDoc
            B-CcbCBult.NroDoc = Faccpedi.NroPed
            B-CcbCBult.CodCli = Faccpedi.CodCli
            B-CcbCBult.Chr_01 = "P"   /* Corrección */
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

    RUN XD_Genera-Pedido (OUTPUT pMensaje).    /* Detalle del pedido */ 
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = "No se pudo generar el detalle de la Orden de Despacho".
        UNDO, RETURN 'ADM-ERROR'.
    END.

    /* *************************************************************** */
    /* 11/01/2025: Martin Chirinos -> Genera PHR automática */
    /* *************************************************************** */
    DEFINE VAR hMasterLibrary AS HANDLE NO-UNDO.

    RUN gn/master-library PERSISTENT SET hMasterLibrary.
    RUN ALM_Genera-PHR-ING-XD IN hMasterLibrary (INPUT ROWID(Faccpedi),
                                                 OUTPUT pMensaje).
    DELETE PROCEDURE hMasterLibrary.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* *************************************************************** */
    /* *************************************************************** */
    ASSIGN 
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    pComprobante = Faccpedi.coddoc + ' ' + Faccpedi.nroped.
END.
IF AVAILABLE(Faccorre) THEN RELEASE FacCorre.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
IF AVAILABLE(Ccbadocu) THEN RELEASE Ccbadocu.
IF AVAILABLE(B-CPEDI)  THEN RELEASE B-CPEDI.
IF AVAILABLE(B-DPEDI)  THEN RELEASE B-DPEDI.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

