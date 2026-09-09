&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-ADOCU FOR CcbADocu.
DEFINE TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE TEMP-TABLE t-Almcmov NO-UNDO LIKE Almcmov.
DEFINE TEMP-TABLE T-MoviAlmacen NO-UNDO LIKE OOMoviAlmacen
       /*FIELD t-Rowid AS ROWID*/.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Creación de O/D y OTR

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Librerias

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

/* LIBRERIAS EXTERNAS:
    alm/pactualizareposicion.p
    ccb/libreria-ccb.p
    ccb/p-cliente-master.p
    dist/p-transfxppv-v2
    gn/master-library.p
    logis/p-genera-hpk-library.p
    logis/p-datos-sede-auxiliar.p
    logis/p-fecha-de-entrega.p
    logis/d-dejado-en-tienda.p
    vta2/linea-de-credito-v2.p
    vtagn/ventas-library.p
    vtagn/pTracking-04.p
*/

/* ***************************  Definitions  ************************** */


DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codalm AS CHAR.

FIND FIRST FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCfgGn THEN DO:
    MESSAGE "No se encontró configuración general para la compañía:" s-codcia VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

DEF VAR LocalCuentaError AS INTE NO-UNDO.

DEF TEMP-TABLE pt-Resumen-HPK
    FIELD CodCia LIKE Facdpedi.CodCia
    FIELD Tipo   LIKE VtaDTabla.Tipo
    FIELD CodDoc LIKE Facdpedi.CodDoc
    FIELD NroPed LIKE Facdpedi.NroPed
    FIELD AlmDes LIKE Facdpedi.AlmDes
    FIELD CodMat LIKE Facdpedi.CodMat
    FIELD CanPed LIKE Facdpedi.CanPed
    FIELD Factor LIKE Facdpedi.Factor
    FIELD UndVta LIKE Facdpedi.UndVta
    FIELD ImpLin LIKE Facdpedi.ImpLin
    FIELD Sector AS CHAR
    FIELD Ubicacion AS CHAR
    FIELD Caso LIKE LogisConsolidaHpk.Caso
    .

DEF BUFFER pt-Resumen-HPK-2 FOR pt-Resumen-HPK.

DEF VAR hVentasLibrary AS HANDLE NO-UNDO.
DEF VAR hLibreriaCcb AS HANDLE NO-UNDO.
DEF VAR hMasterLibrary AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE Tmp_Log_No_Reposicion NO-UNDO
    FIELD CodMat AS CHAR LABEL 'Articulo'
    FIELD CodAlm AS CHAR LABEL 'Alm.Solicitante'
    FIELD Observ AS CHAR FORMAT 'x(60)' LABEL 'Observaciones'.

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
      TABLE: B-ADOCU B "?" ? INTEGRAL CcbADocu
      TABLE: PEDI T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: t-Almcmov T "?" NO-UNDO INTEGRAL Almcmov
      TABLE: T-MoviAlmacen T "?" NO-UNDO INTEGRAL OOMoviAlmacen
      ADDITIONAL-FIELDS:
          /*FIELD t-Rowid AS ROWID*/
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 18.85
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ABAS_Aprobar_RA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ABAS_Aprobar_RA Procedure 
PROCEDURE ABAS_Aprobar_RA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pCrossDocking AS LOG.
DEF INPUT PARAMETER pAlmacenXD AS CHAR.
DEF INPUT-OUTPUT PARAMETER TABLE FOR Tmp_Log_No_Reposicion.
DEF OUTPUT PARAMETER pMensaje2 AS CHAR.     /* Sin NO-UNDO para revertir el mensaje */
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

FIND Almcrepo WHERE ROWID(Almcrepo) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcrepo THEN RETURN "OK".

DEF VAR pComprometido AS DEC NO-UNDO.
DEF VAR fDisponible AS DEC NO-UNDO.
DEF VAR pFechaEntrega AS DATE NO-UNDO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND CURRENT Almcrepo EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Almcrepo THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ********************************************************************************************* */
    /* RHC 21/02/2018 Consistencia del Stock Origen Disponible */
    /* ********************************************************************************************* */
    FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = Almcrepo.codalm NO-LOCK.
    FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = Almacen.coddiv NO-LOCK.

    FOR EACH Almdrepo OF Almcrepo NO-LOCK, FIRST Almmmatg OF Almdrepo NO-LOCK:
        /* *********************************************************************** */
        /* CONSISTENCIA TIPO DE ALMACEN */
        /* *********************************************************************** */
        /* UTILEX */
        IF GN-DIVI.CanalVenta = "MIN" AND NOT (Almmmatg.TpoMrg > "" OR Almmmatg.TpoMrg = "2") THEN DO:
            CREATE Tmp_Log_No_Reposicion.
            ASSIGN
                Tmp_Log_No_Reposicion.codmat = Almdrepo.codmat
                Tmp_Log_No_Reposicion.codalm = Almcrepo.codalm
                Tmp_Log_No_Reposicion.observ = 'Este producto es solo para almacenes mayoristas'.
        END.
        /* *********************************************************************** */
    END.
    /* ********************************************************************************************* */
    /* ********************************************************************************************* */
    ASSIGN
        Almcrepo.FlgEst = "C"        /* RHC 28/11/17 CERRADO */
        Almcrepo.FchApr = TODAY
        Almcrepo.FlgSit = 'A'       /* Aprobado */
        Almcrepo.HorApr = STRING(TIME, 'HH:MM')
        Almcrepo.UsrApr = s-user-id.
    /* Aprobacion y Generacion de OTR automaticamente */
    RUN OTR_Generacion_por_RA (BUFFER Almcrepo,
                               INPUT pCrossDocking,
                               INPUT pAlmacenXD,
                               OUTPUT pFechaEntrega,
                               OUTPUT pMensaje2,
                               OUTPUT pMensaje).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo generar la OTR para el doc: " +
            STRING(almcrepo.NroSer, '999') + "-" + STRING(almcrepo.NroDoc, '999999').
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* *************************************************************************** */
    ASSIGN
        Almcrepo.Fecha          = pFechaEntrega
        Almcrepo.CrossDocking   = pCrossDocking
        Almcrepo.AlmacenXD      = pAlmacenXD.
    IF AVAILABLE(Almcrepo) THEN RELEASE Almcrepo.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ALM_Generacion_RA_por_Incidencia) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ALM_Generacion_RA_por_Incidencia Procedure 
PROCEDURE ALM_Generacion_RA_por_Incidencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pMensaje2 AS CHAR.     /* Sin NO-UNDO para revertir el mensaje */
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR x-rowid-crepo AS ROWID NO-UNDO.
DEF VAR x-rowid-cpedi AS ROWID NO-UNDO.
DEF VAR pFechaEntrega AS DATE NO-UNDO.
DEF VAR pNroSalida AS CHAR NO-UNDO.
DEF VAR pNroIngreso AS CHAR NO-UNDO.

DEFINE BUFFER b-almcrepo FOR almcrepo.
DEFINE BUFFER b-faccpedi FOR faccpedi.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="AlmCIncidencia" ~
        &Condicion="ROWID(AlmCIncidencia) = pRowid" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    /* ***************************************************** */
    /* Barremos todas las R/A relacionadas a esta incidencia */
    /* ***************************************************** */
    FOR EACH Almcrepo NO-LOCK WHERE almcrepo.CodCia = AlmCIncidencia.CodCia AND
        almcrepo.TipMov = "INC" AND
        almcrepo.CodRef = "INC" AND
        almcrepo.NroRef = AlmCIncidencia.NroControl AND
        almcrepo.FlgEst = "P" AND 
        almcrepo.FlgSit = "G":
        x-rowid-crepo = ROWID(almcrepo).
        /* ********************************************************* */
        /* 1ro. Generamos la OTR */
        /* F: Faltamtes
           S: Sobrantes
           M: Mal estado
        */
        /* Si Almcrepo.Incidencia = "F" o "S" => NO genera OTR */
        /* ********************************************************* */
        RUN OTR_Generacion_por_RA (BUFFER Almcrepo,
                                   INPUT NO,
                                   INPUT "",
                                   OUTPUT pFechaEntrega,
                                   OUTPUT pMensaje2,
                                   OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar la Orden de Transferencias'.
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        /* ********************************************************* */
        /* 2do. Generamos las Salidas por Transferencia por cada OTR */
        /* ********************************************************* */
        FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-CodCia
            AND Faccpedi.coddoc = 'OTR'
            AND Faccpedi.codref = 'R/A'
            AND INTEGER(SUBSTRING(Faccpedi.nroref,1,3)) = Almcrepo.nroser
            AND INTEGER(SUBSTRING(Faccpedi.nroref,4)) = Almcrepo.nrodoc
            AND Faccpedi.flgest = "P":
            x-rowid-cpedi = ROWID(faccpedi).
            CASE Almcrepo.Incidencia:
                WHEN "F" OR WHEN "S" THEN DO:
                    /* SALIDA E INGRESO AUTOMATICO */
                    RUN dist/p-transfxppv-v2 ("APPEND",
                                              ROWID(Faccpedi),
                                              Faccpedi.CodAlm,
                                              Faccpedi.CodCli,
                                              OUTPUT pNroSalida,
                                              OUTPUT pNroIngreso,
                                              OUTPUT pMensaje).
                    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                        IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar las Transferencias'.
                        UNDO RLOOP, RETURN 'ADM-ERROR'.
                    END.
                    /* *********************************************************************************** */
                    /* Ic - 20Set2018 */
                    /* *********************************************************************************** */
                    FIND FIRST b-faccpedi WHERE ROWID(b-faccpedi) = ROWID(Faccpedi) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                    IF NOT AVAILABLE b-faccpedi THEN DO:
                        pMensaje = "NO se pudo actualizar el faccpedi.flgest y flgest = 'C' y 'C' ".
                        UNDO RLOOP, RETURN 'ADM-ERROR'.
                    END.
                    ASSIGN
                        b-Faccpedi.FlgSit = "C"   /* Chequeado */
                        b-Faccpedi.FlgEst = "C".  /* Atendido */

                    /* RHC 23/02/2019 Solicitado por Lucy Mesia */
                    /* Viene de una INCidencia */
                    ASSIGN
                        b-Faccpedi.fchchq = TODAY
                        b-Faccpedi.horchq = STRING(TIME,'HH:MM:SS').
                    /* *********************************************************************************** */
                    FOR EACH Facdpedi OF Faccpedi EXCLUSIVE-LOCK:
                        Facdpedi.CanAte = Facdpedi.CanPed.
                    END.
                    /* *********************************************************************************** */
                    
                END.
            END CASE.
        END.
        /* ****************************************************************************** */
        /* Ic - 20Set2018 */
        /* ****************************************************************************** */
        FIND FIRST b-almcrepo WHERE ROWID(b-almcrepo) = x-rowid-crepo EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE b-almcrepo THEN DO:
            pMensaje = "NO se pudo actualizar la reposicion(almcrepo.flgest y flgsit = 'P' y 'G') ".
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            b-almcrepo.FlgEst = "P"
            b-almcrepo.FlgSit = "G".
        /* RHC 09/04/2019 Cambiar de estado para que no afecte el stock comprometido */
        ASSIGN
            b-almcrepo.FlgEst = "C".
        /* ****************************************************************************** */
    END.
    ASSIGN
        AlmCIncidencia.FlgEst = "C"
        AlmCIncidencia.FechaAprobacion = TODAY
        AlmCIncidencia.HoraAprobacion = STRING(TIME, 'HH:MM:SS')
        AlmCIncidencia.UsrAprobacion = s-user-id.
    
    RELEASE AlmCIncidencia.

    IF AVAILABLE(b-Almcrepo) THEN RELEASE Almcrepo.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ALM_Migrar_OTR_CrossDocking) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ALM_Migrar_OTR_CrossDocking Procedure 
PROCEDURE ALM_Migrar_OTR_CrossDocking :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Viene de un I-03 x Cross Docking
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDoc     AS CHAR.    /* OTR u O/D */
DEF INPUT PARAMETER pNroPed     AS CHAR.
DEF INPUT PARAMETER pCodAlm     AS CHAR.    /* Almacén Origen */
DEF INPUT PARAMETER pAlmDes     AS CHAR.    /* Almacén Destino */
DEF INPUT PARAMETER pZona       AS INTE.
DEF INPUT PARAMETER pBultos     AS INTE.
DEF OUTPUT PARAMETER pComprobante AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pMensaje   AS CHAR NO-UNDO.

DEF BUFFER B-DPEDI FOR Facdpedi.

DEF VAR s-coddoc     AS CHAR INITIAL "OTR" NO-UNDO.    /* Orden de Transferencia */
DEF VAR s-NroSer     AS INT  NO-UNDO.
DEF VAR s-TpoPed     AS CHAR INITIAL "" NO-UNDO.
DEF VAR lFechaPedido AS DATE NO-UNDO.

DEF VAR s-CodDiv AS CHAR NO-UNDO.
FIND FIRST Almacen WHERE Almacen.codcia = s-CodCia AND Almacen.codalm = pCodAlm NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almacen THEN DO:
    pMensaje = "NO se ubicó el almacén " + pCodAlm.
    RETURN 'ADM-ERROR'.
END.
s-CodDiv = Almacen.CodDiv.

/* Buscamos el PED del origen */
FIND PEDIDO WHERE PEDIDO.codcia = s-CodCia
    AND PEDIDO.coddoc = pCodDoc    /* OTR u O/D */
    AND PEDIDO.nroped = pNroPed
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE PEDIDO THEN DO:
    pMensaje = "NO se ubicó la Orden " + pCodDoc + ' ' + pNroPed.
    RETURN 'ADM-ERROR'.
END.
IF LOOKUP(PEDIDO.CodRef, "R/A,PED") = 0 THEN DO:
    pMensaje = "NO es una Orden por Cross Docking: " + pCodDoc + ' ' + pNroPed.
    RETURN 'ADM-ERROR'.
END.

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

/* ***************************************************************************** */
/* RUTINA MASTER */
/* ***************************************************************************** */
PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* ******************************************************************************** */
    /* Adiciono el Registro en la Cabecera */
    /* ******************************************************************************** */
    {lib/lock-genericov3.i
        &Tabla="FacCorre"
        &Condicion="Faccorre.codcia = s-codcia
        AND Faccorre.coddoc = s-coddoc
        AND Faccorre.nroser = s-nroser"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"
        }

    lFechaPedido = TODAY.
    FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = pAlmDes NO-LOCK NO-ERROR.

    CREATE Faccpedi.
    BUFFER-COPY PEDIDO TO Faccpedi
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
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    RELEASE FacCorre.
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
    /* ***************************************************************** */
    /* FECHA DE ENTREGA */
    /* ***************************************************************** */
    lFechaPedido = TODAY.
    RUN logis/p-fecha-de-entrega (FacCPedi.CodDoc,              /* Documento actual */
                                  FacCPedi.NroPed,
                                  INPUT-OUTPUT lFechaPedido,
                                  OUTPUT pMensaje).
    IF pMensaje > '' THEN UNDO, RETURN 'ADM-ERROR'.

    ASSIGN
        FacCPedi.FchEnt = lFechaPedido
        Faccpedi.FchVen = lFechaPedido + 7.
    pComprobante = Faccpedi.coddoc + ' ' + Faccpedi.nroped.
    /* ***************************************************************** */
    /* CONTROL DE OTROS PROCESOS POR DIVISION */
    /* OJO: Pasa directo a Distribución */
    /* ***************************************************************** */
/*     RUN GEN_Otros_Procesos (BUFFER Faccpedi). */
    ASSIGN 
        FacCPedi.UsrAprobacion = S-USER-ID
        FacCPedi.FchAprobacion = TODAY.
    /* CONTROL DE OTROS PROCESOS POR DIVISION */
    ASSIGN 
        FacCPedi.FlgEst = 'P'
        FacCPedi.FlgSit = 'C'.      /* DIRECTO A DISTRIBUCION */
    /* ***************************************************************** */
    /* DETALLE DE LA OTR */
    /* ***************************************************************** */
    DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

    FOR EACH B-DPEDI OF PEDIDO NO-LOCK BY B-DPEDI.NroItm:
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
           FacDPedi.CanSol  = B-DPEDI.CanPed       /* <<< OJO <<< */
           FacDPedi.CanPick = B-DPEDI.CanPed      /* <<< OJO <<< */
           NO-ERROR.
       IF ERROR-STATUS:ERROR = YES THEN DO:
           pMensaje = "Error al grabar el producto " + B-DPEDI.codmat.
           UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
       END.
    END.
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
    /* *************************************************************************** */
    /* Creamos control de bultos */
    /* *************************************************************************** */
    IF NOT CAN-FIND(FIRST Ccbcbult WHERE CcbCBult.CodCia = Faccpedi.codcia 
                    AND CcbCBult.CodDiv = Faccpedi.coddiv
                    AND CcbCBult.CodDoc = Faccpedi.coddoc
                    AND CcbCBult.NroDoc = Faccpedi.nroped
                    NO-LOCK) THEN DO:
        CREATE CcbCBult.
        ASSIGN
            CcbCBult.CodCia = Faccpedi.codcia 
            CcbCBult.CodDiv = Faccpedi.coddiv
            CcbCBult.CodDoc = Faccpedi.coddoc
            CcbCBult.NroDoc = Faccpedi.nroped
            CcbCBult.Bultos = pBultos
            CcbCBult.Chequeador = s-user-id
            CcbCBult.CodCli = Faccpedi.codcli
            CcbCBult.DirCli = Faccpedi.dircli
            CcbCBult.NomCli = Faccpedi.nomcli
            .
        RELEASE CcbCBult.
    END.
    /* **************************** */
    /* LOG de control para REPORTES */
    /* Como no hay HPK se pasa la OTR */
    /* **************************** */
    RUN lib/logtabla ("FACCPEDI",
                      s-coddiv + ":" + Faccpedi.coddoc + ":" + Faccpedi.nroped + ":" + STRING(pZona),
                      "DIST_RECEP_BULTOS").
    /* *************************************************************************** */
    /* RHC 22/09/2020 Control por M.R. */
    /* *************************************************************************** */
    /* SE VA A BLOQUEAR, NO SE LE VE UTILIDAD PRACTICA: Genera una ODP o una OTP
    RUN ML_Genera-OD-Control IN hMasterLibrary (INPUT ROWID(Faccpedi),    /* O/D */
                                                OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "ERROR: No se pudo generar el registro de control".
        UNDO LoopGrabarData, RETURN 'ADM-ERROR'.   
    END.
    */
    /* *************************************************************************** */
    /* 24/7/2025: Debe pasar directamente a la PHR */
    /* *************************************************************************** */
    FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = Faccpedi.DivDes NO-LOCK NO-ERROR.
    CASE TRUE:
        WHEN gn-divi.Campo-Char[6] = "PR" THEN DO:
            /* 2do. La PHR */
            /* La división que despacha vs la de origen debe ser PHR AUTOMATICA */
            RUN LOG_Genera_PHR_por_OTR (BUFFER Faccpedi, OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        END.
    END CASE.
    /* *********************************************************************** */
    /* 30/07/2025: En este caso FORZAMOS los estado de la OTR por CrossDocking */
    /* CONTROL DE OTROS PROCESOS POR DIVISION */
    /* *********************************************************************** */
    ASSIGN 
        FacCPedi.FlgEst = 'P'
        FacCPedi.FlgSit = 'C'.      /* DIRECTO A DISTRIBUCION */
    /* *********************************************************************** */
    /* *************************************************************************** */

    /* *************************************************************************** */
    /* GENERACION DE SUB-ORDENES, HPK Y PHR */
    /* OJO => NO genera ni HPK ni PHR */
    /* *************************************************************************** */
/*     FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = Faccpedi.DivDes NO-LOCK NO-ERROR.     */
/*     CASE TRUE:                                                                                              */
/*         WHEN Faccpedi.FlgSit = "T" AND (gn-divi.Campo-Char[6] = "SE" OR Faccpedi.coddiv = "00017") THEN DO: */
/*             RUN LOG_Genera_SubOrden (BUFFER Faccpedi, OUTPUT pMensaje).                                                      */
/*             IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.                                    */
/*         END.                                                                                                */
/*         WHEN Faccpedi.FlgSit = "T" AND gn-divi.Campo-Char[6] = "PR" THEN DO:                                */
/*             /* 1ro. La HPK */                                                                               */
/*             RUN LOG_Genera_HPK (BUFFER Faccpedi, OUTPUT pMensaje).                                                           */
/*             IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.                                    */
/*             /* 2do. La PHR */                                                                               */
/*             /* La división que despacha vs la de origen debe ser PHR AUTOMATICA */                          */
/*             RUN LOG_Genera_PHR (BUFFER Faccpedi, OUTPUT pMensaje).                                                           */
/*             IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.                                    */
/*         END.                                                                                                */
/*     END CASE.                                                                                               */
    IF AVAILABLE(FacCPedi) THEN RELEASE FacCPedi.
END.


RETURN 'OK'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CCB_Aprobar_Pedido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CCB_Aprobar_Pedido Procedure 
PROCEDURE CCB_Aprobar_Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pFlgEst AS CHAR.            /* Valores: X, W, etc */
DEF OUTPUT PARAMETER pNroOD AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pAviso AS CHAR NO-UNDO.

DEF VAR iItem AS INTE NO-UNDO.

FIND PEDIDO WHERE ROWID(PEDIDO) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE PEDIDO THEN RETURN "OK".

IF PEDIDO.FlgEst <> pFlgEst THEN DO:
    pMensaje = 'El documento ' + PEDIDO.coddoc + " " + PEDIDO.nroped +
        ' ya NO se encuentra pendiente de aprobación'.
    RETURN 'ADM-ERROR'.
END.

/* ********************************************************************************* */
/* 12/06/18 De cualquier cliente del grupo */
/* ********************************************************************************* */
DEF VAR LocalMaster AS CHAR NO-UNDO.
DEF VAR LocalRelacionados AS CHAR NO-UNDO.
DEF VAR LocalAgrupados AS LOG NO-UNDO.
DEF VAR LocalCliente AS CHAR NO-UNDO.

RUN ccb/p-cliente-master (PEDIDO.CodCli,
                          OUTPUT LocalMaster,
                          OUTPUT LocalRelacionados,
                          OUTPUT LocalAgrupados).
IF LocalAgrupados = YES AND LocalRelacionados > '' THEN .
ELSE LocalRelacionados = PEDIDO.CodCli.
/* ********************************************************************************* */
/* Deudas pendientes hasta con 5 días de atraso */
/* ********************************************************************************* */
RLOOP:
DO iItem = 1 TO NUM-ENTRIES(LocalRelacionados):
    FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia 
        AND Ccbcdocu.codcli = ENTRY(iItem, LocalRelacionados)
        AND Ccbcdocu.flgest = "P":
        IF LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL,LET,N/D,CHQ') > 0 AND (Ccbcdocu.fchvto + 5) < TODAY THEN DO:
            MESSAGE 'El cliente/grupo tiene una deuda atrazada:' SKIP
                '    Cliente:' Ccbcdocu.nomcli SKIP
                '  Documento:' Ccbcdocu.coddoc Ccbcdocu.nrodoc SKIP
                'Vencimiento:' Ccbcdocu.fchvto SKIP
                'Continúa con la aprobación?'
                VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
                UPDATE Rpta AS LOG.
            IF Rpta = NO THEN RETURN "OK".
            LEAVE RLOOP.
        END.
    END.
END.
/* ********************************************************************************* */
/* MASTER TRANSACTION */
/* ********************************************************************************* */
DEF VAR x-CodUbic AS CHAR INIT 'ANP' NO-UNDO.

CICLO:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Inicio de Transacción */
    FIND CURRENT PEDIDO EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="LocalCuentaError"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        PEDIDO.Flgest = 'P'                 /* Aprobado por defecto */
        PEDIDO.UsrAprobacion = s-user-id
        PEDIDO.FchAprobacion = TODAY.

    /* RHC 30/12/2015 Para no depender del vendedor o el tipo de venta
        vamos a fijarnos en el tipo de canal de venta de la division */
    FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = PEDIDO.coddiv NO-LOCK.
    CASE pFlgEst:
        WHEN "X" OR WHEN "T" THEN DO:   /* Aprobado por CREDITOS y COBRANZAS Y TESORERIA */
            /* Trámite Documentario pasa a ser aprobado por Logística */
            IF PEDIDO.TipVta = "Si" THEN DO:
                ASSIGN 
                    PEDIDO.FlgEst = "WL"
                    pAviso = "Debe ser aprobado por Logística"
                    .
            END.
            /* Supermercados pasa a APROBACION POR SECR. GG */
            IF GN-DIVI.CanalVenta = "MOD" THEN DO:  /* SUPERMERCADOS */
                ASSIGN 
                    PEDIDO.FlgEst = "W"
                    pAviso = "Debe ser aprobado por Secretaria de GG"
                    .
            END.
            x-CodUbic = "ANPX".
        END.
        WHEN "WC" THEN DO:
            /* Pasa a ser aprobado por LOGISTICA */
            ASSIGN
                PEDIDO.Flgest = 'WL'     /* Aprobaciòn por Logística */
                pAviso = "Debe ser aprobado por Logística"
                .

            x-CodUbic = "ANPWX".
        END.
        WHEN "W" THEN DO:   /* Aprobado por Asistente de Gerencia General */
            ASSIGN
                PEDIDO.Flgest = 'WX'      /* Aprobaciòn por Gerencia General */
                pAviso = "Debe ser aprobado por GG"
                .
            /* Provincias pasa a APROBACION POR LOGISTICA */
            IF GN-DIVI.CanalVenta = "PRO" THEN DO:  /* PROVINCIAS */
                ASSIGN 
                    PEDIDO.FlgEst = "WL"
                    pAviso = "Debe ser aprobado por Logística"
                    .
            END.
            /* Supermercados pasa a APROBACION POR LOGISTICA */
            IF GN-DIVI.CanalVenta = "MOD" THEN DO:  /* SUPERMERCADOS */
                ASSIGN 
                    PEDIDO.FlgEst = "WL"
                    pAviso = "Debe ser aprobado por Logística"
                    .
            END.
            /* RHC 18.04.2012 APROBACION AUTOMATICA (TEMPORAL) */
            IF PEDIDO.FlgEst = "WL" THEN ASSIGN PEDIDO.FlgEst = "P" pAviso = "".
            /* ************************************ */
            x-CodUbic = "ANPWX".
        END.
    END CASE.
    /* TRACKING */
    RUN vtagn/pTracking-04 (PEDIDO.CodCia,
                            PEDIDO.CodDiv,
                            PEDIDO.CodDoc,
                            PEDIDO.NroPed,
                            s-User-Id,
                            x-CodUbic,
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            PEDIDO.CodDoc,
                            PEDIDO.NroPed,
                            PEDIDO.CodDoc,
                            PEDIDO.NroPed).

    /* SI NO HA SIDO APROBADO ENTONCES NO GENERA ORDEN DE DESPACHO */
    IF PEDIDO.FlgEst <> "P" THEN LEAVE.

    /* DEPENDIENDO DE SI ES CROSSDOCKING O NO GENERA UNA O/D O UNA OTR */
    CASE PEDIDO.CrossDocking:
        WHEN NO THEN DO:
            RUN OD_Generacion_Rutina_Master (NO,
                                             OUTPUT pNroOD,
                                             OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
            pAviso = "Orden de Despacho = " + pNroOD.
        END.
        WHEN YES THEN DO:
            RUN OTR_Generacion_por_CrossDocking (NO,
                                             OUTPUT pNroOD,
                                             OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
            pAviso = "Orden de Transferencia = " + pNroOD.
        END.
    END CASE.
END.
IF AVAILABLE(PEDIDO) THEN RELEASE PEDIDO.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CCB_Verifica_Cliente) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CCB_Verifica_Cliente Procedure 
PROCEDURE CCB_Verifica_Cliente PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Rutina PRIVATE
------------------------------------------------------------------------------*/

/* Control por condición de venta */
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pAviso AS CHAR NO-UNDO.


/* *********************************************************************** */
/* RUTINA ESTANDAR */
/* *********************************************************************** */
RUN CCB_Verifica_Cliente_FmaPgo (OUTPUT pAviso).

/* *********************************************************************** 
    PARA CONTADO ANTICIPADO
    01Oct2019, Susana Leon converso con Daniel Llican y en coordinacion
                con Julisa calderon, cuando la boleta de deposito (BD) es inferior 
                al monto del pedido se debe derivar a la bandeja de CyC
*********************************************************************** */
DEFINE VAR x-doc-deposito AS CHAR.

x-doc-deposito = TRIM(PEDIDO.usrchq).
IF TRUE <> (PEDIDO.usrchq > "") THEN x-doc-deposito = "BD".

IF PEDIDO.fmapgo = '002' AND PEDIDO.FlgEst = "P" THEN DO:
    FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.coddoc = x-doc-deposito        /* BD o A/R */
        AND Ccbcdocu.nrodoc = PEDIDO.Libre_c03
        AND Ccbcdocu.codcli = PEDIDO.CodCli
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcdocu OR Ccbcdocu.flgest <> 'P' OR Ccbcdocu.SdoAct <= 0
        THEN DO:
        pMensaje = x-doc-deposito + " " + PEDIDO.Libre_c03 + " NO existe o no pertenece al cliente".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    IF Ccbcdocu.FmaPgo <> PEDIDO.fmapgo THEN DO:
        pMensaje =  'La condición de venta del " + PEDIDO.usrchq + " " + PEDIDO.Libre_c03 + " NO es CONTADO ANTICIPADO'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /*
        01Oct2019, Susana Leon converso con Daniel Llican y en coordinacion
                    con Julisa calderon, cuando la boleta de deposito (BD) es inferior 
                    al monto del pedido se debe derivar a la bandeja de CyC
    */            
    IF PEDIDO.CodMon = Ccbcdocu.CodMon THEN DO:
        IF Ccbcdocu.sdoact < PEDIDO.imptot THEN DO:
            ASSIGN 
                PEDIDO.flgest = 'X'
                PEDIDO.Libre_c05 = 'EL MONTO DEL " + PEDIDO.usrchq + " " + PEDIDO.Libre_c03 +" ES INFERIOR AL MONTO DEL PEDIDO'
                PEDIDO.Libre_c04 = '- PASA POR EVALUACION DE CREDITO'.
        END.
    END.
    ELSE DO:
        IF Ccbcdocu.codmon = 1 THEN DO:
            IF Ccbcdocu.sdoact < (PEDIDO.imptot * PEDIDO.Tpocmb) THEN DO:
                ASSIGN 
                    PEDIDO.flgest = 'X'
                    PEDIDO.Libre_c05 = 'EL MONTO DEL " + PEDIDO.usrchq + " " + PEDIDO.Libre_c03 + " ES INFERIOR AL MONTO DEL PEDIDO'
                    PEDIDO.Libre_c04 = '- PASA POR EVALUACION DE CREDITO'.
            END.
        END.
        ELSE DO:
            IF Ccbcdocu.sdoact < (PEDIDO.imptot / PEDIDO.Tpocmb) THEN DO:
                ASSIGN 
                    PEDIDO.flgest = 'X'
                    PEDIDO.Libre_c05 = 'EL MONTO DEL " + PEDIDO.usrchq + " " + PEDIDO.Libre_c03 + " ES INFERIOR AL MONTO DEL PEDIDO'
                    PEDIDO.Libre_c04 = '- PASA POR EVALUACION DE CREDITO'.
            END.
        END.
    END.
END.   
/* *********************************************************************** */
/* VERIFICAMOS MARGEN DE UTILIDAD */
/* *********************************************************************** */
IF LOOKUP(PEDIDO.Lista_de_Precios, '00000,00017,00018') > 0 THEN DO:
    RUN VTA_Margen_de_Utilidad.
    IF PEDIDO.FlgEst = "W" THEN DO:
        pAviso = "Margen Utilidad!" + PEDIDO.Libre_c05.
    END.
END.

/* 01Oct2019 - Fin */
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CCB_Verifica_Cliente_FmaPgo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CCB_Verifica_Cliente_FmaPgo Procedure 
PROCEDURE CCB_Verifica_Cliente_FmaPgo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       El BUFFER PEDIDO debe estar bloqueado y dbe ser PED u OTR
                Se determina si el pedido pasa a ser aprobado en otra instancia
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER pAviso AS CHAR NO-UNDO.

DEFINE VAR x-cliente-ubicacion AS CHAR.
DEFINE VAR x-tolerancia-dias AS INT.
DEFINE VAR x-stk-letras AS INT.
DEFINE VAR x-stk-letras-del-cliente AS INT.

DEFINE BUFFER bClied FOR gn-clied.

/* ************************************************************ */
/* 29/03/17 CLIENTES ESPECIALES SE APRUEBAN AUTOMATICAMENTE */
/* ************************************************************ */
FIND FIRST gn-cliex WHERE gn-cliex.CodCia = cl-codcia
    AND gn-cliex.CodUnico = PEDIDO.codcli
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-cliex THEN DO:
    ASSIGN
        PEDIDO.FlgEst = "P".
    RETURN.
END.

/* ************************************************************ */
/* Ic - 05Feb2021 19:41pm,  conversamos con Susana y luego verificar */
/* Condiciones de ventas especiales 001 y 002 */
/* ************************************************************ */
IF LOOKUP(PEDIDO.fmapgo,"001,002") = 0 THEN DO:
    FIND FIRST gn-convt WHERE gn-ConVt.Codig = PEDIDO.FmaPgo NO-LOCK NO-ERROR.
    /* Los CONTADO se aprueban automáticamente */
    IF AVAILABLE gn-convt AND gn-convt.tipvta = "1" THEN DO:
        ASSIGN
            PEDIDO.FlgEst = "P".
        RETURN.
    END.
END.
/* TAMPOCO EXPOLIBRERIA CONTADO CONTRA-ENTREGA */
IF PEDIDO.TpoPed = "E" AND PEDIDO.FmaPgo = '001' THEN DO:
    ASSIGN
        PEDIDO.FlgEst = "P".
    RETURN.
END.

/* 16/02/2026: División 00522 es como un contado Susana León y Carla Tenazoa */
FIND FIRST Vtatabla WHERE Vtatabla.codcia = s-codcia
    AND Vtatabla.tabla = "CONFIG-VTAS"
    AND Vtatabla.llave_c1 = "MARKETPLACE"
    AND Vtatabla.llave_c2 = "DIVISION"
    AND Vtatabla.llave_c3 = PEDIDO.CodDiv
    NO-LOCK NO-ERROR NO-WAIT.
IF AVAILABLE Vtatabla THEN DO:
    PEDIDO.FlgEst = "P".
    RETURN.
END.

/* ********************************************************************************* */
/* CONTADO CONTRAENTREGA Y TRANSFERENCIAS GRATUITAS NECESITAN APROBACION OBLIGATORIA */
/* ********************************************************************************* */
/* 25/08/17 Acuerdo de reunión, correo del 24/08/17 */
IF LOOKUP(PEDIDO.fmaPgo,"001,900,899") > 0 THEN DO:
    ASSIGN 
        PEDIDO.Flgest = 'X'   /* x CC */
        PEDIDO.Glosa  = TRIM (PEDIDO.Glosa) + '//Cond.Cred.'
        PEDIDO.Libre_c05 = 'CONDICION DE VENTA'.
    pAviso = 'Por la condición de venta debe ser aprobado por Créditos ó administrador'.
    RETURN.
END.
/* ********************************************************************************* */
/* Ic 27Set2019 - Direccion de clientes es de CLIENTE moroso no pasa */
/* ********************************************************************************* */
FIND FIRST bClied WHERE bClied.codcia = cl-codcia
   AND bClied.codcli = PEDIDO.codcli
   AND bClied.sede = PEDIDO.sede NO-LOCK NO-ERROR.
IF AVAILABLE bClied THEN DO:
    DEFINE VAR x-moroso AS CHAR.
    RUN ccb\libreria-ccb PERSISTENT SET hLibreriaCcb.   
    x-moroso = "".
    RUN direccion-de-moroso IN hLibreriaCcb (INPUT PEDIDO.codcli, 
                                             INPUT bClied.dircli,
                                             INPUT PEDIDO.fmapgo,
                                             OUTPUT x-moroso).        
    DELETE PROCEDURE hLibreriaCcb.
    IF x-moroso > "" THEN DO:
        ASSIGN
            PEDIDO.Flgest = 'X'
            PEDIDO.Glosa  = TRIM (PEDIDO.Glosa) 
            PEDIDO.Libre_c05 = 'DIRECCION DE ENTREGA, PERTENECE A CLIENTE MOROSO(' + x-moroso + ')'
            PEDIDO.Libre_c04 = '- PASA POR EVALUACION DE CREDITO'.
        pAviso = 'Direccion de entrega de cliente moroso!!'.
        RETURN.
    END.
END.
/* ********************************************************************************* */
/* POR LA LINEA DE CREDITO: Contado NO verifica la línea de crédito */
/* RHC 12/06/18 La línea de crédito de todo el grupo si fuera el caso */
/* 28/11/2024 Gina Condor */
/* Reemplazar vta2/linea-de-credito-v2 por vta2/linea-de-credito-disponible */
/* ********************************************************************************* */
/*RUN vta2/linea-de-credito-disponible (PEDIDO.CodDiv,*/
RUN vta2/linea-de-credito-v2 (PEDIDO.CodDiv,
                              PEDIDO.CodCli,
                              PEDIDO.FmaPgo,
                              PEDIDO.CodMon,
                              0,
                              NO).
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    ASSIGN 
        PEDIDO.Flgest = 'X'
        PEDIDO.Glosa  = TRIM (PEDIDO.Glosa) + '//Linea Credito'
        PEDIDO.Libre_c05 = 'SUPERA LA LINEA DE CREDITO'
        PEDIDO.Libre_c04 = ' - SUPERA LA LINEA DE CREDITO'.
    pAviso = PEDIDO.Libre_c05.
    RETURN.
END.

ASSIGN 
    PEDIDO.Libre_c04 = ' - IMPORTE DENTRO DE LA LINEA DE CREDITO'.

/* ********************************************************************************* */
/* DEUDA VENCIDA */
/* 12/06/18 De cualquier cliente del grupo */
/* ********************************************************************************* */
DEF VAR LocalMaster AS CHAR.
DEF VAR LocalRelacionados AS CHAR.
DEF VAR LocalAgrupados AS LOG.
DEF VAR LocalCliente AS CHAR NO-UNDO.

RUN ccb/p-cliente-master (PEDIDO.CodCli,
                          OUTPUT LocalMaster,
                          OUTPUT LocalRelacionados,
                          OUTPUT LocalAgrupados).
IF LocalAgrupados = YES AND LocalRelacionados > '' THEN DO:
END.
ELSE DO:
    LocalRelacionados = PEDIDO.CodCli.
END.
/* DOCUMENTOS CON DEUDA VENCIDA */
/* Ic - 11Ago2020 - FIN, correo Sr. Rodolfo Salas del 11Ago2020 : Notificación: Notas de Crédito */
DEFINE VAR x-dias-tolerables AS INT.
DEFINE VAR x-tabla-cyc AS CHAR.        
DEFINE VAR iCliente AS INTE NO-UNDO.

x-tabla-cyc = "APR.PED|DOCMNTOS".
/* Cliente de LIMA o PROVINCIA */
RUN vtagn/ventas-library PERSISTENT SET hVentasLibrary.
RUN VTA_ubicacion-cliente IN hVentasLibrary (INPUT PEDIDO.codcli, OUTPUT x-cliente-ubicacion).
IF TRUE <> (x-cliente-ubicacion > "") THEN x-cliente-ubicacion = "CUALQUIERCOSA".
/* Barremos tolerancia por defecto (8 horas en promedio) */
FOR EACH factabla WHERE factabla.codcia = s-codcia AND factabla.tabla = x-tabla-cyc NO-LOCK:
    x-dias-tolerables = 0.
    IF PEDIDO.fmapgo = '002' THEN DO:
        /* CONTADO ANTICIPADO */
        RUN VTA_tolerancia-dias-vctos IN hVentasLibrary (INPUT factabla.codigo, 
                                                         INPUT PEDIDO.coddiv,
                                                         INPUT PEDIDO.codcli, 
                                                         INPUT x-cliente-ubicacion, /* x-ubicli = "" : que la rutina calcule la ubicacion del cliente*/
                                                         OUTPUT x-dias-tolerables).
    END.
    ELSE DO:
        x-dias-tolerables = factabla.valor[1].
    END.                
    IF x-dias-tolerables < 0 THEN x-dias-tolerables = 0.

    DO iCliente = 1 TO NUM-ENTRIES(LocalRelacionados):
        FIND FIRST CcbCDocu WHERE CcbCDocu.CodCia = PEDIDO.CodCia
            AND CcbCDocu.CodCli = ENTRY(iCLiente, LocalRelacionados)
            AND CcbCDocu.FlgEst = "P" 
            AND CcbCDocu.CodDoc = factabla.codigo                  /* FAC,BOL,CHQ,LET,N/D */
            AND (CcbCDocu.FchVto + x-dias-tolerables ) < TODAY    /* 8 dias + de plazo */
            NO-LOCK NO-ERROR. 
        IF AVAIL CcbCDocu THEN DO:
            ASSIGN
                PEDIDO.Flgest = 'X'
                PEDIDO.Glosa  = TRIM (PEDIDO.Glosa) + '//Doc. Venc.'
                PEDIDO.Libre_c05 = 'DEUDA VENCIDA: ' + Ccbcdocu.coddoc + ' ' + Ccbcdocu.nrodoc.
            pAviso = "El cliente/grupo tiene una deuda atrazada:" + CHR(13) + CHR(10) +
                "Cliente : " + TRIM(Ccbcdocu.nomcli) + CHR(13) + CHR(10) +
                "Documento : " + TRIM(Ccbcdocu.coddoc) + " " + TRIM(Ccbcdocu.nrodoc) + CHR(13) + CHR(10) +
                "Vencimiento : " + STRING(Ccbcdocu.fchvto,"99/99/9999").
            RETURN.
        END.
    END.
END.        
DELETE PROCEDURE hVentasLibrary.
/* Ic - 11Ago2020 - FIN */

/* ********************************************************************************* */
/* RHC 15/11/18 Solicitado por Luis Figueroa               
    Si tiene línea de crédito
    Si no tiene deudas mayores a 8 días
    Si tiene al menos una letra frimada en blanco
   Ic - 29Oct2019, correo de Julissa se valida contra la cantidad de letras
        que se ingreso en la condicion de venta
        Si el Stock de Letras es < que las letras requeridas segun Cond.Venta pasa por aprobacion
        de CyC, de lo contrario se aprueba en automatico
*/
/* ********************************************************************************* */
x-stk-letras = 0.
x-stk-letras-del-cliente = 0.
FIND FIRST gn-convt WHERE gn-ConVt.Codig = PEDIDO.FmaPgo NO-LOCK NO-ERROR.
IF AVAILABLE gn-convt  THEN x-stk-letras = gn-convt.libre_d01.  /* Cantidad de letras que requiere la condicion de venta */
IF x-stk-letras < 0 THEN x-stk-letras = 0.
IF x-stk-letras > 0 THEN DO:
    /* Si la condicion de venta tiene cargada cantida de letras */
    FIND FIRST ccbstklet WHERE ccbstklet.codcia = s-CodCia AND
        ccbstklet.codclie = PEDIDO.CodCli NO-LOCK NO-ERROR.
    IF AVAILABLE ccbstklet THEN x-stk-letras-del-cliente = ccbstklet.qstklet.
    /* 21Oct2022 - Ana Huaman si la condicion de venta indica stock de letras, se debe validar a todas las ventas */
    IF x-stk-letras-del-cliente < x-stk-letras THEN DO:
        ASSIGN
            PEDIDO.Flgest = 'X'
            PEDIDO.Glosa  = TRIM (PEDIDO.Glosa) 
            PEDIDO.Libre_c05 = 'NO TIENE STOCK DE LETRAS (' + STRING(x-stk-letras-del-cliente) + ')'
            PEDIDO.Libre_c04 = '- PASA POR EVALUACION DE CREDITO'.
        pAviso = 'El cliente NO tiene Stock de Letras!!'.
        RETURN.
    END.            
END.

/* **************************************************** */
/* CANJE CON LETRAS POR ACEPTAR/APROBAR */
/* **************************************************** */
/* Dias de Tolerancia */
x-tolerancia-dias = 15.
IF x-cliente-ubicacion = "CUALQUIERCOSA" THEN x-cliente-ubicacion = "LIMA". /* x compatibilidad, si no tiene ubicacion asume LIMA segun Julissa */
FIND FIRST FacTabla WHERE FacTabla.codcia = s-codcia AND
    FacTabla.tabla = "APR.PED|LT.X.ACEPTAR" AND   /* APROBACION PEDIDOS, LETRAS X ACEPTAR */
    FacTabla.codigo = x-cliente-ubicacion NO-LOCK NO-ERROR.
IF AVAILABLE FacTabla THEN x-tolerancia-dias = FacTabla.valor[1].
FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = PEDIDO.codcia
    AND CcbCDocu.CodCli = PEDIDO.Codcli
    AND Ccbcdocu.flgest = "X" 
    AND Ccbcdocu.coddoc = 'LET'
    AND (TODAY - Ccbcdocu.FchDoc) >= x-tolerancia-dias  /* 15 */
    NO-LOCK NO-ERROR.
IF AVAILABLE Ccbcdocu THEN DO:
    ASSIGN
        PEDIDO.Flgest = 'X'
        PEDIDO.Glosa  = TRIM (PEDIDO.Glosa) + '//CANJE POR LETRA POR APROBAR'
        PEDIDO.Libre_c05 = 'Cliente tiene letra pendiente por ACEPTAR ' + Ccbcdocu.CodRef + ' ' + Ccbcdocu.NroRef + ' ' + STRING(Ccbcdocu.FchDoc,"99/99/9999").
    pAviso = PEDIDO.Libre_c05.
    RETURN.
END.

/* ********************************************************************************* */
/* RHC 08.05.2012 PEDIDOS DE SUPERMERCADOS PASAN OBLIGADO POR SEC GG GG*/
/* ********************************************************************************* */
IF PEDIDO.coddiv = '00017' THEN DO:
    ASSIGN
        PEDIDO.Flgest = 'W'
        PEDIDO.Glosa  = TRIM (PEDIDO.Glosa) + '//Supermercados'
        PEDIDO.Libre_c05 = 'SUPERMERCADOS' + PEDIDO.Libre_c04.
    RETURN.
END.
/* *********************************************************************** */
/* APROBAMOS EL PEDIDO */
/* *********************************************************************** */
IF PEDIDO.FlgEst = "G" THEN PEDIDO.FlgEst = "P".

/* *********************************************************************** */
/* 27/09/2019 TRAMITE DOCUMENTARIO: Forzamos la aprobar por COMERCIAL  */
/* 23/10/2019 TRAMITE DOCUMENTARIO: Forzamos la aprobar por CC y CC  */
/* PEDIDO.TipVta = "Si" = Tramite documentario */
/* *********************************************************************** */
IF PEDIDO.TipVta = "Si" AND PEDIDO.FlgEst = "P" THEN DO:
    ASSIGN
        PEDIDO.Flgest = "X"
        PEDIDO.Glosa  = TRIM(PEDIDO.Glosa) 
        PEDIDO.Libre_c05 = 'TRAMITE DOCUMENTARIO'.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GEN_Carga_Detalle_OTR_por_RA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GEN_Carga_Detalle_OTR_por_RA Procedure 
PROCEDURE GEN_Carga_Detalle_OTR_por_RA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAMETER s-CodDoc AS CHAR.         /* OTR */
  DEF INPUT PARAMETER lAlmDespacho AS CHAR.
  DEF INPUT PARAMETER lDivDespacho AS CHAR.

  DEFINE VARIABLE I-NPEDI AS INTEGER NO-UNDO.
  DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
  DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE s-StkComprometido AS DEC.
  DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.
  DEFINE VARIABLE F-CANPED AS DECIMAL NO-UNDO.
  DEFINE VARIABLE x-StkAct AS DEC NO-UNDO.
  DEFINE VARIABLE x-CodAlm AS CHAR NO-UNDO.
  DEFINE VARIABLE i AS INT NO-UNDO.

  i-NPedi = 0.
  /* ************************************************* */
  /* RHC 23/08/17 Simplificación del proceso Max Ramos */
  /* ************************************************* */
  DEF VAR t-AlmDes AS CHAR NO-UNDO.
  DEF VAR t-CanPed AS DEC NO-UNDO.

  FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = Almcrepo.codalm NO-LOCK.
  FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = Almacen.coddiv NO-LOCK.

  EMPTY TEMP-TABLE PEDI.
  FOR EACH Almdrepo OF Almcrepo NO-LOCK WHERE (Almdrepo.CanApro - Almdrepo.CanAten) > 0,
      FIRST Almmmatg OF Almdrepo NO-LOCK:
      f-Factor = 1.
      t-AlmDes = ''.
      t-CanPed = 0.
      F-CANPED = (Almdrepo.CanApro - Almdrepo.CanAten).     /* OJO */
      x-CodAlm = lAlmDespacho.
      /* DEFINIMOS LA CANTIDAD */
      x-CanPed = f-CanPed * f-Factor.
      IF f-CanPed <= 0 THEN NEXT.
      IF f-CanPed > t-CanPed THEN DO:
          t-CanPed = f-CanPed.
          t-AlmDes = x-CodAlm.
      END.
      /* ******************************************************** */
      /* FILTRAMOS EL PRODUCTO DE ACUERDO AL ALMACEN SOLICITANTES */
      /* ******************************************************** */
      CASE TRUE:
          WHEN GN-DIVI.CanalVenta = "MIN" THEN DO:    /* UTILEX */
              IF NOT ( (TRUE <> (Almmmatg.TpoMrg > '')) OR Almmmatg.TpoMrg = "2" ) THEN NEXT.
          END.
          OTHERWISE DO:   /* MAYORISTAS */
          END.
      END CASE.
      /* ******************************************************** */
      /* GRABACION */
      I-NPEDI = I-NPEDI + 1.
      CREATE PEDI.
      BUFFER-COPY Almdrepo 
          EXCEPT Almdrepo.CanReq Almdrepo.CanApro
          TO PEDI
          ASSIGN 
              PEDI.CodCia = s-codcia
              PEDI.CodDiv = lDivDespacho
              PEDI.CodDoc = s-coddoc
              PEDI.NroPed = ''
              PEDI.ALMDES = t-AlmDes  /* *** OJO *** */
              PEDI.NroItm = I-NPEDI
              PEDI.CanPed = t-CanPed            /* << OJO << */
              PEDI.CanAte = 0
              PEDI.Factor = 1.                  /* Importante */
      ASSIGN
          PEDI.Libre_d01 = (Almdrepo.CanApro - Almdrepo.CanAten)
          PEDI.Libre_d02 = t-CanPed
          PEDI.Libre_c01 = '*'.
      ASSIGN
          PEDI.UndVta = Almmmatg.UndBas.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GEN_Consistencia_Cruzada) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GEN_Consistencia_Cruzada Procedure 
PROCEDURE GEN_Consistencia_Cruzada PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Se verifica que los items de la Orden sean los mismos que el del Pedido
                Rutina PRIVATE
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF BUFFER B-DPEDI FOR Facdpedi.

DEF VAR x-ItmPed AS INT NO-UNDO.
DEF VAR x-ItmOD  AS INT NO-UNDO.
DEF VAR x-ImpPed AS DEC NO-UNDO.
DEF VAR x-ImpOD  AS DEC NO-UNDO.
ASSIGN
    x-ItmPed = 0
    x-ItmOD  = 0
    x-ImpPed = 0
    x-ImpOD  = 0.
FOR EACH Facdpedi OF Faccpedi NO-LOCK:
    x-ItmPed = x-ItmPed + 1.
    x-ImpPed = x-ImpPed + Facdpedi.ImpLin.
END.
FOR EACH B-DPEDI OF PEDIDO NO-LOCK:
    x-ItmOD = x-ItmOD + 1.
    x-ImpOD = x-ImpOD + B-DPEDI.ImpLin.
END.
IF x-ItmPed <> x-ItmOD OR x-ImpPed <> x-ImpOD THEN DO:
    pMensaje = "Se encontró una inconsistencia entre el Pedido y la Orden de Despacho" +  CHR(10) +
        "Proceso Abortado".        
    RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GEN_Datos_del_Transportista) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GEN_Datos_del_Transportista Procedure 
PROCEDURE GEN_Datos_del_Transportista PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Rutina PRIVATE
------------------------------------------------------------------------------*/


    /* ******************************************************************** */
    /* COPIAMOS DATOS DEL TRANSPORTISTA */
    /* ******************************************************************** */
    FIND FIRST Ccbadocu WHERE Ccbadocu.codcia = PEDIDO.codcia
        AND Ccbadocu.coddiv = PEDIDO.coddiv
        AND Ccbadocu.coddoc = PEDIDO.coddoc
        AND Ccbadocu.nrodoc = PEDIDO.nroped
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbadocu THEN DO:
        FIND FIRST B-ADOCU WHERE B-ADOCU.codcia = Faccpedi.codcia
            AND B-ADOCU.coddiv = Faccpedi.coddiv
            AND B-ADOCU.coddoc = Faccpedi.coddoc
            AND B-ADOCU.nrodoc = Faccpedi.nroped
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE B-ADOCU THEN CREATE B-ADOCU.
        BUFFER-COPY Ccbadocu TO B-ADOCU
            ASSIGN
                B-ADOCU.CodDiv = FacCPedi.CodDiv
                B-ADOCU.CodDoc = FacCPedi.CodDoc
                B-ADOCU.NroDoc = FacCPedi.NroPed
            NO-ERROR.
    END.
    /* ******************************************************************** */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GEN_Detalle_de_la_orden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GEN_Detalle_de_la_orden Procedure 
PROCEDURE GEN_Detalle_de_la_orden PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Rutina PRIVATE
------------------------------------------------------------------------------*/

DEF PARAMETER BUFFER bFaccpedi FOR Faccpedi.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

DEF BUFFER B-DPEDI FOR Facdpedi.

FOR EACH B-DPEDI OF PEDIDO NO-LOCK BY B-DPEDI.NroItm:
    /* GRABAMOS LA DIVISION Y EL ALMACEN DESTINO EN LA CABECERA */
    I-NITEM = I-NITEM + 1.
    CREATE FacDPedi. 
    BUFFER-COPY B-DPEDI 
        TO FacDPedi
        ASSIGN  
        FacDPedi.CodCia  = bFaccpedi.CodCia 
        FacDPedi.coddiv  = bFaccpedi.coddiv 
        FacDPedi.coddoc  = bFaccpedi.coddoc 
        FacDPedi.NroPed  = bFaccpedi.NroPed 
        FacDPedi.FchPed  = bFaccpedi.FchPed
        FacDPedi.Hora    = bFaccpedi.Hora 
        FacDPedi.FlgEst  = 'P'       /*bFaccpedi.FlgEst*/
        FacDPedi.NroItm  = I-NITEM
        FacDPedi.CanAte  = 0                     /* <<< OJO <<< */
        FacDPedi.CanSol  = FacDPedi.CanPed       /* <<< OJO <<< */
        FacDPedi.CanPick = FacDPedi.CanPed      /* <<< OJO <<< */
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = "Error al grabar el producto " + B-DPEDI.codmat.
        UNDO, RETURN 'ADM-ERROR'.
    END.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GEN_Detalle_de_la_OTR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GEN_Detalle_de_la_OTR Procedure 
PROCEDURE GEN_Detalle_de_la_OTR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE PARAMETER BUFFER bFaccpedi FOR Faccpedi.
    DEFINE INPUT PARAMETER pDivDespacho AS CHAR.
    DEFINE INPUT PARAMETER pAlmDespacho AS CHAR.
    DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.
    
    DEFINE VARIABLE I-NPEDI AS INTEGER NO-UNDO.
    DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
    DEFINE VARIABLE F-CANPED AS DECIMAL NO-UNDO.
    DEFINE VARIABLE x-CodAlm AS CHAR NO-UNDO.
    DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
    DEFINE VARIABLE t-AlmDes AS CHAR NO-UNDO.
    DEFINE VARIABLE t-CanPed AS DEC NO-UNDO.

    EMPTY TEMP-TABLE PEDI.
    i-NPedi = 0.
    FOR EACH FacDPedi OF PEDIDO NO-LOCK, FIRST Almmmatg OF FacDPedi NO-LOCK:
        f-Factor = 1.
        t-AlmDes = ''.
        t-CanPed = 0.
        F-CANPED = (FacDPedi.CanPed - FacDPedi.CanAte).     /* OJO */
        x-CodAlm = pAlmDespacho.
        /* DEFINIMOS LA CANTIDAD */
        x-CanPed = f-CanPed * f-Factor.
        IF f-CanPed <= 0 THEN NEXT.
        IF f-CanPed > t-CanPed THEN DO:
            t-CanPed = f-CanPed.
            t-AlmDes = x-CodAlm.
        END.
        I-NPEDI = I-NPEDI + 1.
        CREATE PEDI.
        BUFFER-COPY FacDPedi 
            TO PEDI
            ASSIGN 
            PEDI.CodCia = bFaccpedi.codcia
            PEDI.CodDiv = pDivDespacho
            PEDI.CodDoc = bFaccpedi.coddoc
            PEDI.NroPed = ''
            PEDI.ALMDES = t-AlmDes  /* *** OJO *** */
            PEDI.NroItm = I-NPEDI
            PEDI.CanPed = t-CanPed            /* << OJO << */
            PEDI.CanAte = 0.
        ASSIGN
            PEDI.Libre_d01 = (FacDPedi.CanPed - FacDPedi.CanAte)
            PEDI.Libre_d02 = t-CanPed
            PEDI.Libre_c01 = '*'.
        ASSIGN
            PEDI.UndVta = Almmmatg.UndBas.
    END.
    /* Borramos data sobrante */
    FOR EACH PEDI WHERE PEDI.CanPed <= 0:
        DELETE PEDI.
    END.
    /* AHORA SÍ GRABAMOS EL PEDIDO */
    I-NPEDI = 0.
    FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK BY PEDI.NroItm: 
        I-NPEDI = I-NPEDI + 1.
        CREATE Facdpedi.
        BUFFER-COPY PEDI 
            TO Facdpedi
            ASSIGN
            Facdpedi.CodCia = bFaccpedi.CodCia
            Facdpedi.CodDiv = bFaccpedi.CodDiv
            Facdpedi.coddoc = bFaccpedi.coddoc
            Facdpedi.NroPed = bFaccpedi.NroPed
            Facdpedi.AlmDes = bFaccpedi.CodAlm
            Facdpedi.FchPed = bFaccpedi.FchPed
            Facdpedi.Hora   = bFaccpedi.Hora 
            Facdpedi.FlgEst = bFaccpedi.FlgEst
            FacDPedi.CanSol  = FacDPedi.CanPed 
            FacDPedi.CanPick = FacDPedi.CanPed
            Facdpedi.NroItm = I-NPEDI.
        DELETE PEDI.
    END.
    /* verificamos que al menos exista 1 item grabado */
    FIND FIRST Facdpedi OF bFaccpedi NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Facdpedi THEN DO:
        pMensaje = "NO existen items en la OTR".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GEN_Detalle_OTR_por_RA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GEN_Detalle_OTR_por_RA Procedure 
PROCEDURE GEN_Detalle_OTR_por_RA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF PARAMETER BUFFER bFaccpedi FOR Faccpedi.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  DEFINE VARIABLE I-NPEDI AS INTEGER NO-UNDO INIT 0.

  /* Borramos data sobrante */
  FOR EACH PEDI WHERE PEDI.CanPed <= 0:
      DELETE PEDI.
  END.

  /* AHORA SÍ GRABAMOS EL PEDIDO */
  FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK BY PEDI.NroItm: 
      I-NPEDI = I-NPEDI + 1.
      /* RHC No hay límite de items 
      IF I-NPEDI > 52 THEN LEAVE.
      */
      CREATE Facdpedi.
      BUFFER-COPY PEDI 
          TO Facdpedi
          ASSIGN
              Facdpedi.CodCia = bFaccpedi.CodCia
              Facdpedi.CodDiv = bFaccpedi.CodDiv
              Facdpedi.AlmDes = bFaccpedi.CodAlm
              Facdpedi.coddoc = bFaccpedi.coddoc
              Facdpedi.NroPed = bFaccpedi.NroPed
              Facdpedi.FchPed = bFaccpedi.FchPed
              Facdpedi.Hora   = bFaccpedi.Hora 
              Facdpedi.FlgEst = "P"     
              FacDPedi.CanPick = FacDPedi.CanPed
              Facdpedi.NroItm = I-NPEDI.
      DELETE PEDI.
  END.
  IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
  /* verificamos que al menos exista 1 item grabado */
  FIND FIRST Facdpedi OF bFaccpedi NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Facdpedi 
  THEN DO:
      pMensaje = "NO hay items en la OTR".
      RETURN 'ADM-ERROR'.
  END.
  ELSE RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GEN_Otros_Procesos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GEN_Otros_Procesos Procedure 
PROCEDURE GEN_Otros_Procesos PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Rutina PRIVATE
------------------------------------------------------------------------------*/

DEF PARAMETER BUFFER bFaccpedi FOR Faccpedi.

DEFINE VARIABLE s-FlgPicking LIKE GN-DIVI.FlgPicking.
DEFINE VARIABLE s-FlgBarras LIKE GN-DIVI.FlgBarras.

/* Control de Picking y Barras */
FIND FIRST gn-divi WHERE gn-divi.codcia = bFaccpedi.codcia
    AND gn-divi.coddiv = bFaccpedi.divdes
    NO-LOCK.
ASSIGN
    s-FlgPicking = GN-DIVI.FlgPicking
    s-FlgBarras  = GN-DIVI.FlgBarras.

IF s-FlgPicking = YES THEN bFacCPedi.FlgSit = "T".    /* Por Pickear en Almacén */
IF s-FlgPicking = NO AND s-FlgBarras = NO THEN bFacCPedi.FlgSit = "C".    /* Picking OK */
IF s-FlgPicking = NO AND s-FlgBarras = YES THEN bFacCPedi.FlgSit = "P".   /* Pre-Picking OK */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-LOG_Genera_HPK) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LOG_Genera_HPK Procedure 
PROCEDURE LOG_Genera_HPK PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Rutina PRIVATE
------------------------------------------------------------------------------*/

DEF PARAMETER BUFFER bFaccpedi FOR Faccpedi.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* ****************************************** */
/* Se genera la HPK: Con la nueva versión */
/* ****************************************** */
DEFINE VAR hLibLogis AS HANDLE NO-UNDO.
RUN logis/p-genera-hpk-library.p PERSISTENT SET hLibLogis.
RUN HPK_Genera-HPK-Master-v2 IN hLibLogis (INPUT ROWID(bFaccpedi), OUTPUT pMensaje) NO-ERROR.    
IF ERROR-STATUS:ERROR THEN pMensaje = pMensaje + CHR(10) + ERROR-STATUS:GET-MESSAGE(1).
IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.    
DELETE PROCEDURE hLibLogis.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-LOG_Genera_PHR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LOG_Genera_PHR Procedure 
PROCEDURE LOG_Genera_PHR PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       SOLO ESTA GENERANDO PHR POR O/D, NO POR OTR
                Rutina PRIVATE
------------------------------------------------------------------------------*/

DEF PARAMETER BUFFER bFaccpedi FOR Faccpedi.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR s-CodDoc AS CHAR NO-UNDO INIT 'PHR'.
DEF VAR s-adm-new-record AS LOG NO-UNDO.
DEF VAR s-coddiv AS CHAR NO-UNDO.
DEF VAR s-nroser AS INTE NO-UNDO.
DEF VAR pCuenta AS INTE NO-UNDO.
DEF VAR pObserv AS CHAR NO-UNDO.
DEF VAR pCodPos AS CHAR INIT "" NO-UNDO.

/* De acuerdo al documento */
CASE bFaccpedi.CodDoc:
    WHEN "O/D" THEN DO:
        /* La división que despacha vs la de origen debe ser PHR AUTOMATICA */
        FIND VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
            VtaTabla.Tabla = "CFGDIV_PHR" AND
            VtaTabla.Llave_c1 = bFaccpedi.DivDes AND
            VtaTabla.Llave_c2 = bFaccpedi.CodDiv
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE VtaTabla THEN RETURN 'OK'.
        /* ****************************************** */
        /* Determinamos el agrupador */
        /* ****************************************** */
        CASE VtaTabla.Libre_c03:
            WHEN "CR" THEN DO:
                IF bFaccpedi.Cliente_Recoge = NO THEN RETURN 'OK'.
                pObserv = "CL RECOGE".
            END.
            WHEN "CNR" THEN DO:
                IF bFaccpedi.Cliente_Recoge = YES THEN RETURN 'OK'.
                pObserv = "CL NO RECOGE".
            END.
            WHEN "CRNR" THEN DO:
                CASE bFaccpedi.Cliente_Recoge:
                    WHEN YES THEN pObserv = "CL RECOGE".
                    WHEN NO THEN pObserv  = "CL NO RECOGE".
                END CASE.
            END.
            WHEN "DL" THEN DO:
                IF pCodPos = "P0" THEN RETURN 'OK'.
                pObserv = "LIMA".
            END.
            WHEN "DP" THEN DO:
                IF pCodPos <> "P0" THEN RETURN 'OK'.
                pObserv = "PROVINCIA".
            END.
            WHEN "DLP" THEN DO:
                CASE pCodPos:
                    WHEN "P0" THEN pObserv = "PROVINCIA".
                    OTHERWISE pObserv = "LIMA".
                END CASE.
            END.
        END CASE.
        IF TRUE <> (pObserv > '') THEN DO:
            pMensaje = "NO está definido el AGRUPADOR POR O/D".
            RETURN 'ADM-ERROR'.
        END.
        pObserv = TRIM(pObserv) + " - " + bFaccpedi.CodDiv.       /* OJO */
    END.
    OTHERWISE DO:
        /* Por ahora NO genera PHR */
        RETURN "OK".
    END.
END CASE.
/* ******************************************************************************** */
/* Generamos la PHR siempre y cuando se despache en un CD por Picking por rutas */
/* ******************************************************************************** */
/* Artificio */
ASSIGN
    s-coddiv = bFaccpedi.DivDes.
FIND FIRST FacCorre WHERE FacCorre.CodCia = s-codcia AND
    FacCorre.CodDiv = s-coddiv AND
    FacCorre.CodDoc = s-coddoc AND
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    pMensaje = "Correlativo no configurado para la división " + s-coddiv +
        " y el documento " + s-coddoc.
    RETURN 'ADM-ERROR'.
END.
ASSIGN
    s-nroser = FacCorre.NroSer.

/* 23/03/2022 Datos del ubigeo */
DEF VAR pUbigeo AS CHAR NO-UNDO.
DEF VAR pLongitud AS DECI NO-UNDO.
DEF VAR platitud AS DECI NO-UNDO.

DEFINE VAR xnewCod AS CHAR NO-UNDO.
DEFINE VAR xnewNro AS CHAR NO-UNDO.

RUN logis/p-datos-sede-auxiliar.r (
    bFaccpedi.Ubigeo[2],   /* ClfAux @CL @PV */
    bFaccpedi.Ubigeo[3],   /* Auxiliar */
    bFaccpedi.Ubigeo[1],   /* Sede */
    OUTPUT pUbigeo,
    OUTPUT pLongitud,
    OUTPUT pLatitud
    ).
FIND TabDepto WHERE TabDepto.CodDepto = SUBSTRING(pUbigeo,1,2) NO-LOCK NO-ERROR.
IF AVAILABLE TabDepto THEN DO:
    FIND TabProv WHERE TabProv.CodDepto = SUBSTRING(pUbigeo,1,2) AND
        TabProv.CodProv = SUBSTRING(pUbigeo,3,2) NO-LOCK NO-ERROR.
    IF AVAILABLE TabProv THEN DO:
        FIND TabDistr WHERE TabDistr.CodDepto = SUBSTRING(pUbigeo,1,2) AND
            TabDistr.CodProv = SUBSTRING(pUbigeo,3,2) AND
            TabDistr.Coddistr = SUBSTRING(pUbigeo,5,2) NO-LOCK NO-ERROR.
        IF AVAILABLE TabDistr THEN DO:
            pCodPos = TabDistr.CodPos.
        END.
    END.
END.

FIND gn-divi WHERE gn-divi.codcia = s-codcia AND
    gn-divi.coddiv = bFaccpedi.CodDiv NO-LOCK NO-ERROR.
IF AVAILABLE gn-divi THEN pObserv = pObserv + " " + GN-DIVI.DesDiv.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* 1ro. Generamos la PHR */
    FIND FIRST Di-RutaC WHERE DI-RutaC.CodCia = s-codcia AND
        DI-RutaC.CodDiv = s-coddiv AND
        DI-RutaC.CodDoc = s-coddoc AND
        DI-RutaC.FchDoc = TODAY AND
        DI-RutaC.FlgEst = "PK" AND
        DI-RutaC.Libre_c05 = "AUTOMATICO" AND
        DI-RutaC.Observ = pObserv
        NO-LOCK NO-ERROR.
    s-adm-new-record = YES.
    IF AVAILABLE Di-RutaC THEN s-adm-new-record = NO.
    IF s-adm-new-record = YES THEN DO:
        {lib/lock-genericov3.i ~
            &Tabla="FacCorre" ~
            &Condicion="FacCorre.CodCia = s-codcia AND ~
            FacCorre.CodDiv = s-coddiv AND ~
            FacCorre.CodDoc = s-coddoc AND ~
            FacCorre.NroSer = s-nroser" ~
            Bloqueo="EXCLUSIVE-LOCK NO-ERROR NO-WAIT" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje" ~
            &TipoError="UNDO, RETURN 'ADM-ERROR'" }
        CREATE DI-RutaC.
        ASSIGN
            DI-RutaC.CodCia = s-codcia
            DI-RutaC.CodDiv = s-coddiv
            DI-RutaC.CodDoc = s-coddoc
            DI-RutaC.FchDoc = TODAY
            DI-RutaC.NroDoc = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999')
            DI-RutaC.flgest  = "PK"     /* Con Hoja de Ruta */
            DI-RutaC.Libre_c05 = "AUTOMATICO"   
            DI-RutaC.Observ = pObserv
            DI-RutaC.usuario = s-user-id
            NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
            UNDO, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
        RELEASE FacCorre.

    END.
    ELSE DO:
        FIND CURRENT DI-RutaC EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END.
    CREATE DI-RutaD.
    ASSIGN
        DI-RutaD.CodCia = DI-RutaC.CodCia 
        DI-RutaD.CodDiv = DI-RutaC.CodDiv 
        DI-RutaD.CodDoc = DI-RutaC.CodDoc 
        DI-RutaD.NroDoc = DI-RutaC.NroDoc
        DI-RutaD.CodRef = bFaccpedi.CodDoc
        DI-RutaD.NroRef = bFaccpedi.NroPed.
    /* ****************************************** */
    /* 29/05/2025: Actualizar ORIGEN del HPK */
    /* ****************************************** */
    FOR EACH Vtacdocu EXCLUSIVE-LOCK WHERE Vtacdocu.codcia = s-codcia 
        AND Vtacdocu.codref = bFaccpedi.coddoc
        AND Vtacdocu.nroref = bFaccpedi.nroped 
        AND Vtacdocu.coddiv = s-coddiv
        AND Vtacdocu.codped = "HPK"
        AND Vtacdocu.flgest <> "A":
        ASSIGN
            Vtacdocu.codori = s-CodDoc          /* PHR */
            Vtacdocu.nroori = DI-RutaC.NroDoc.
    END.
    IF AVAILABLE(Vtacdocu) THEN RELEASE Vtacdocu.

    /* ****************************************** */
    /* 05/06/2024: Actualizar el estado de la O/D */
    /* ****************************************** */
    ASSIGN
        bFaccpedi.FlgSit = "TG".

    IF AVAILABLE DI-RutaC THEN RELEASE DI-RutaC.
    IF AVAILABLE DI-RutaD THEN RELEASE DI-RutaD.

END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-LOG_Genera_PHR_por_OTR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LOG_Genera_PHR_por_OTR Procedure 
PROCEDURE LOG_Genera_PHR_por_OTR PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       SOLO ESTA GENERANDO PHR SOLO POR OTR
                Rutina PRIVATE
------------------------------------------------------------------------------*/

DEF PARAMETER BUFFER bFaccpedi FOR Faccpedi.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR s-CodDoc AS CHAR NO-UNDO INIT 'PHR'.
DEF VAR s-adm-new-record AS LOG NO-UNDO.
DEF VAR s-coddiv AS CHAR NO-UNDO.
DEF VAR s-nroser AS INTE NO-UNDO.
DEF VAR pCuenta AS INTE NO-UNDO.
DEF VAR pObserv AS CHAR NO-UNDO.
DEF VAR pCodPos AS CHAR INIT "" NO-UNDO.

/* La división que despacha debe ser PHR AUTOMATICA */
FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
    VtaTabla.Tabla = "CFGDIV_PHR" AND
    VtaTabla.Llave_c1 = bFaccpedi.DivDes
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla THEN RETURN 'OK'.
pObserv = "CL NO RECOGE".   /* Valor por defecto */
pObserv = bFaccpedi.NomCli. /* 31/07/2025: Nuevo valor por defecto */

/* ******************************************************************************** */
/* Generamos la PHR siempre y cuando se despache en un CD por Picking por rutas */
/* ******************************************************************************** */
/* Artificio */
ASSIGN
    s-coddiv = bFaccpedi.DivDes.
FIND FIRST FacCorre WHERE FacCorre.CodCia = s-codcia AND
    FacCorre.CodDiv = s-coddiv AND
    FacCorre.CodDoc = s-coddoc AND
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    pMensaje = "Correlativo no configurado para la división " + s-coddiv +
        " y el documento " + s-coddoc.
    RETURN 'ADM-ERROR'.
END.
ASSIGN
    s-nroser = FacCorre.NroSer.

/* 23/03/2022 Datos del ubigeo */
DEF VAR pUbigeo AS CHAR NO-UNDO.
DEF VAR pLongitud AS DECI NO-UNDO.
DEF VAR platitud AS DECI NO-UNDO.

DEFINE VAR xnewCod AS CHAR NO-UNDO.
DEFINE VAR xnewNro AS CHAR NO-UNDO.

RUN logis/p-datos-sede-auxiliar.r (
    bFaccpedi.Ubigeo[2],   /* ClfAux @CL @PV */
    bFaccpedi.Ubigeo[3],   /* Auxiliar */
    bFaccpedi.Ubigeo[1],   /* Sede */
    OUTPUT pUbigeo,
    OUTPUT pLongitud,
    OUTPUT pLatitud
    ).
FIND TabDepto WHERE TabDepto.CodDepto = SUBSTRING(pUbigeo,1,2) NO-LOCK NO-ERROR.
IF AVAILABLE TabDepto THEN DO:
    FIND TabProv WHERE TabProv.CodDepto = SUBSTRING(pUbigeo,1,2) AND
        TabProv.CodProv = SUBSTRING(pUbigeo,3,2) NO-LOCK NO-ERROR.
    IF AVAILABLE TabProv THEN DO:
        FIND TabDistr WHERE TabDistr.CodDepto = SUBSTRING(pUbigeo,1,2) AND
            TabDistr.CodProv = SUBSTRING(pUbigeo,3,2) AND
            TabDistr.Coddistr = SUBSTRING(pUbigeo,5,2) NO-LOCK NO-ERROR.
        IF AVAILABLE TabDistr THEN DO:
            pCodPos = TabDistr.CodPos.
        END.
    END.
END.

/* 31/07/2025 */
/* FIND gn-divi WHERE gn-divi.codcia = s-codcia AND                    */
/*     gn-divi.coddiv = bFaccpedi.CodDiv NO-LOCK NO-ERROR.             */
/* IF AVAILABLE gn-divi THEN pObserv = pObserv + " " + GN-DIVI.DesDiv. */

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* 1ro. Generamos la PHR */
    FIND FIRST Di-RutaC WHERE DI-RutaC.CodCia = s-codcia AND
        DI-RutaC.CodDiv = s-coddiv AND
        DI-RutaC.CodDoc = s-coddoc AND
        DI-RutaC.FchDoc = TODAY AND
        DI-RutaC.FlgEst = "PK" AND
        DI-RutaC.Libre_c05 = "AUTOMATICO" AND
        DI-RutaC.Observ = pObserv
        NO-LOCK NO-ERROR.
    s-adm-new-record = YES.
    IF AVAILABLE Di-RutaC THEN s-adm-new-record = NO.
    IF s-adm-new-record = YES THEN DO:
        {lib/lock-genericov3.i ~
            &Tabla="FacCorre" ~
            &Condicion="FacCorre.CodCia = s-codcia AND ~
            FacCorre.CodDiv = s-coddiv AND ~
            FacCorre.CodDoc = s-coddoc AND ~
            FacCorre.NroSer = s-nroser" ~
            Bloqueo="EXCLUSIVE-LOCK NO-ERROR NO-WAIT" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje" ~
            &TipoError="UNDO, RETURN 'ADM-ERROR'" }
        CREATE DI-RutaC.
        ASSIGN
            DI-RutaC.CodCia = s-codcia
            DI-RutaC.CodDiv = s-coddiv
            DI-RutaC.CodDoc = s-coddoc
            DI-RutaC.FchDoc = TODAY
            DI-RutaC.NroDoc = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999')
            DI-RutaC.flgest  = "PK"     /* Con Hoja de Ruta */
            DI-RutaC.Libre_c05 = "AUTOMATICO"   
            DI-RutaC.Observ = pObserv
            DI-RutaC.usuario = s-user-id
            NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
            UNDO, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
        RELEASE FacCorre.

    END.
    ELSE DO:
        FIND CURRENT DI-RutaC EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END.
    CREATE DI-RutaD.
    ASSIGN
        DI-RutaD.CodCia = DI-RutaC.CodCia 
        DI-RutaD.CodDiv = DI-RutaC.CodDiv 
        DI-RutaD.CodDoc = DI-RutaC.CodDoc 
        DI-RutaD.NroDoc = DI-RutaC.NroDoc
        DI-RutaD.CodRef = bFaccpedi.CodDoc
        DI-RutaD.NroRef = bFaccpedi.NroPed.
    /* ****************************************** */
    /* 29/05/2025: Actualizar ORIGEN del HPK */
    /* ****************************************** */
    FOR EACH Vtacdocu EXCLUSIVE-LOCK WHERE Vtacdocu.codcia = s-codcia 
        AND Vtacdocu.codref = bFaccpedi.coddoc
        AND Vtacdocu.nroref = bFaccpedi.nroped 
        AND Vtacdocu.coddiv = s-coddiv
        AND Vtacdocu.codped = "HPK"
        AND Vtacdocu.flgest <> "A":
        ASSIGN
            Vtacdocu.codori = s-CodDoc          /* PHR */
            Vtacdocu.nroori = DI-RutaC.NroDoc.
    END.
    IF AVAILABLE(Vtacdocu) THEN RELEASE Vtacdocu.

    /* ****************************************** */
    /* 05/06/2024: Actualizar el estado de la OTR */
    /* ****************************************** */
    ASSIGN
        bFaccpedi.FlgSit = "TG".

    IF AVAILABLE DI-RutaC THEN RELEASE DI-RutaC.
    IF AVAILABLE DI-RutaD THEN RELEASE DI-RutaD.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-LOG_Genera_SubOrden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LOG_Genera_SubOrden Procedure 
PROCEDURE LOG_Genera_SubOrden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Rutina PRIVATE
------------------------------------------------------------------------------*/

DEF PARAMETER BUFFER bFaccpedi FOR Faccpedi.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEFINE VAR lSector AS CHAR.

DEFINE VAR lSectorG0 AS LOG.
DEFINE VAR lSectorOK AS LOG.
DEFINE VAR lUbic AS CHAR.

/* 
    Para aquellos articulos cuya ubicacion no sea correcta SSPPMMN
    SS : Sector
    PP : Pasaje
    MM : Modulo
    N  : Nivel (A,B,C,D,E,F)
*/
lSectorG0 = NO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* El SECTOR forma parte del código de ubicación */
    FOR EACH Facdpedi OF bFaccpedi NO-LOCK,
        FIRST almmmate NO-LOCK WHERE Almmmate.CodCia = facdpedi.codcia
            AND Almmmate.CodAlm = facdpedi.almdes
            AND Almmmate.codmat = facdpedi.codmat
        BREAK BY SUBSTRING(Almmmate.CodUbi,1,2):
        IF FIRST-OF(SUBSTRING(Almmmate.CodUbi,1,2)) THEN DO:
            /* Ic - 29Nov2016, G- = G0 */
            lSector = CAPS(SUBSTRING(Almmmate.CodUbi,1,2)).
            lUbic = TRIM(Almmmate.CodUbi).
            lSectorOK = NO.
            /* Si el sector es Correcto y el codigo de la ubicacion esta OK */
            /* 18May2017 Felix Perez creo una nueva ZONA (07) */
            IF (lSector >= '01' AND lSector <= '07') AND LENGTH(lUbic) = 7 THEN DO:
                /* Ubic Ok */
                lSectorOK = YES.
            END.
            ELSE DO:
                lSector = "G0".
            END.        
            /* Ic - 29Nov2016, FIN  */
            IF lSectorOK = YES OR lSectorG0 = NO THEN DO:
                CREATE vtacdocu.
                BUFFER-COPY bFaccpedi TO vtacdocu
                    ASSIGN 
                    VtaCDocu.CodCia = bFaccpedi.codcia
                    VtaCDocu.CodDiv = bFaccpedi.coddiv
                    VtaCDocu.CodPed = bFaccpedi.coddoc
                    VtaCDocu.NroPed = bFaccpedi.nroped + '-' + lSector
                    VtaCDocu.FlgEst = 'P'   /* APROBADO */
                    NO-ERROR.
                IF ERROR-STATUS:ERROR = YES THEN DO:
                    pMensaje = "Error al grabar la suborden " + bFaccpedi.nroped + '-' + SUBSTRING(Almmmate.CodUbi,1,2).
                    UNDO RLOOP, RETURN 'ADM-ERROR'.
                END.
                ASSIGN
                    Vtacdocu.Glosa = bFaccpedi.Glosa.    /* OJO */
                IF lSector = 'G0' THEN lSectorG0 = YES.
            END.
        END.
        CREATE vtaddocu.
        BUFFER-COPY facdpedi TO vtaddocu
            ASSIGN
            VtaDDocu.CodCia = VtaCDocu.codcia
            VtaDDocu.CodDiv = VtaCDocu.coddiv
            VtaDDocu.CodPed = VtaCDocu.codped
            VtaDDocu.NroPed = bFaccpedi.nroped + '-' + lSector /*VtaCDocu.nroped*/
            VtaDDocu.CodUbi = Almmmate.CodUbi.
    END.
    IF AVAILABLE vtacdocu THEN RELEASE vtacdocu.
    IF AVAILABLE vtaddocu THEN RELEASE vtaddocu.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-OD_Generacion_Rutina_Master) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OD_Generacion_Rutina_Master Procedure 
PROCEDURE OD_Generacion_Rutina_Master PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Rutina PRIVATE
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pProcesoBatch AS LOG.
DEF OUTPUT PARAMETER pComprobante AS CHAR.     /* O/D generada */
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEFINE VARIABLE s-FlgPicking LIKE GN-DIVI.FlgPicking NO-UNDO.
DEFINE VARIABLE s-FlgBarras LIKE GN-DIVI.FlgBarras NO-UNDO.
DEFINE VARIABLE s-DiasVtoO_D LIKE GN-DIVI.DiasVtoO_D NO-UNDO.
DEFINE VARIABLE s-NroSer AS INTEGER NO-UNDO.

/* ***************************************************************************** */
/* PARAMETROS DE COTIZACION PARA LA DIVISION */
/* ***************************************************************************** */
FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = PEDIDO.coddiv
    NO-LOCK NO-ERROR.
ASSIGN
    s-FlgPicking = GN-DIVI.FlgPicking
    s-FlgBarras  = GN-DIVI.FlgBarras
    s-DiasVtoO_D = GN-DIVI.DiasVtoO_D.
/* ***************************************************************************** */
/* DOCUMENTO A GENERAR */
/* ***************************************************************************** */
DEF VAR s-CodDoc AS CHAR INIT "O/D" NO-UNDO.
CASE PEDIDO.CodDoc:
    WHEN "PED" THEN s-CodDoc = "O/D".
    WHEN "P/M" THEN s-CodDoc =  "O/M".
END CASE.
/* ***************************************************************************** */
/* PARAMETROS PARA GENERAR EL PEDIDO */
/* ***************************************************************************** */
DEF VAR  s-CodDiv AS CHAR NO-UNDO.
s-CodDiv = PEDIDO.coddiv.       /* La división del PEDIDO */

FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
    FacCorre.CodDoc = S-CODDOC AND
    FacCorre.CodDiv = S-CODDIV AND
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
   pMensaje = "Correlativo del Documento no configurado: " + s-coddoc + CHR(10) +
       "para la división: " + s-CodDiv.
   RETURN 'ADM-ERROR'.
END.
ASSIGN
    s-nroser = FacCorre.NroSer.

LoopGrabarData:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Bloqueamos control de correlativos */
    {lib/lock-genericov3.i
        &Tabla="FacCorre"
        &Condicion=" FacCorre.CodCia = s-codcia
        AND FacCorre.CodDoc = s-coddoc
        AND FacCorre.NroSer = s-nroser"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Intentos=10
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO LoopGrabarData, RETURN 'ADM-ERROR'"
        }
    /* Creamos la Orden */
    CREATE FacCPedi.
    BUFFER-COPY PEDIDO 
        EXCEPT 
        PEDIDO.TpoPed
        PEDIDO.FlgEst
        PEDIDO.FlgSit
        /*PEDIDO.TipVta*/
        TO FacCPedi
        ASSIGN 
            FacCPedi.CodCia = S-CODCIA
            FacCPedi.CodDiv = S-CODDIV
            FacCPedi.CodDoc = s-coddoc 
            FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
            FacCPedi.CodRef = PEDIDO.CodDoc
            FacCPedi.NroRef = PEDIDO.NroPed
            FacCPedi.TpoCmb = FacCfgGn.TpoCmb[1] 
            FacCPedi.FchPed = TODAY
            FacCPedi.FchVen = TODAY + s-DiasVtoO_D
            FacCPedi.Hora = STRING(TIME,"HH:MM:SS")
            FacCPedi.FlgEst = 'X'   /* PROCESANDO: revisar rutina Genera-Pedido */
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Correlativo de la Orden mal registrado o duplicado".
        UNDO LoopGrabarData, LEAVE.
    END.
    ASSIGN 
        FacCPedi.UsrAprobacion = S-USER-ID
        FacCPedi.FchAprobacion = TODAY.
    ASSIGN 
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    RELEASE FacCorre.
    /* ************************************************************************** */
    /* RHC 22/11/17 se va a volver a calcular la fecha de entrega                 */
    /* La O/D hereda la FchEnt y Libre_f02 del PED                                */
    /* ************************************************************************** */
    DEF VAR pFchEnt AS DATE NO-UNDO.
    RUN logis/p-fecha-de-entrega (INPUT Faccpedi.CodDoc,
                                  INPUT Faccpedi.NroPed,
                                  INPUT-OUTPUT pFchEnt,
                                  OUTPUT pMensaje).
    IF pMensaje > '' THEN UNDO LoopGrabarData, RETURN 'ADM-ERROR'.
    ASSIGN
        FacCPedi.FchEnt = pFchEnt.  /* OJO */
    /* ************************************************************************** */
    /* TRACKING */
    /* ******************************************************************** */
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
    /* ******************************************************************** */
    /* COPIAMOS DATOS DEL TRANSPORTISTA */
    /* ******************************************************************** */
    RUN GEN_Datos_del_Transportista.
    /* ******************************************************************** */
    /* Detalle de la OD */
    /* ******************************************************************** */
    RUN GEN_Detalle_de_la_orden (BUFFER Faccpedi, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO LoopGrabarData, RETURN 'ADM-ERROR'.
    /* ******************************************************************** */
    /* RHC 26/12/2016 Consistencia final: La O/D y el PED deben ser iguales */
    /* ******************************************************************** */
    RUN GEN_Consistencia_Cruzada (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO LoopGrabarData, RETURN 'ADM-ERROR'.
    /* ******************************************************************** */
    /* CONTROL DE OTROS PROCESOS POR DIVISION */
    /* Contol de Barras y Picking */
    /* ******************************************************************** */
    RUN GEN_Otros_Procesos (BUFFER Faccpedi).

    /* Trámite Documentario */
    IF Faccpedi.TipVta = "Si" THEN DO:
        /* Listo para Facturar */
        ASSIGN 
            FacCPedi.FlgEst = 'P'
            FacCPedi.FlgSit = 'C'.      /* NO HPK ni PHR */
    END.
    /* Para caso de Riqra */
    IF pProcesoBatch = YES THEN DO:
        ASSIGN FacCPedi.FlgSit = "K".   /* Por generar PHR-HPK */
    END.
    /* *************************************************************************** */
    /* Actualiza Cantidad Atendida del Pedido */
    /* *************************************************************************** */
    RUN gn/master-library PERSISTENT SET hMasterLibrary.
    RUN Actualiza-Saldo-Referencia IN hMasterLibrary (ROWID(Faccpedi), "C", OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "ERROR: No se pudo actualizar el saldo del Pedido".
        UNDO LoopGrabarData, RETURN 'ADM-ERROR'.     
    END.
    /* *************************************************************************** */
    /* RHC 08/04/2016 Ahora sí actualizamos el estado */
    /* *************************************************************************** */
    ASSIGN
        FacCPedi.FlgEst = 'P'.  /* APROBADO */
    pComprobante = Faccpedi.coddoc + ' ' + Faccpedi.nroped.
    /* *************************************************************************** */
    /* RHC 22/09/2020 Control por M.R. */
    /* *************************************************************************** */
    /* SE VA A BLOQUEAR, NO SE LE VE UTILIDAD PRACTICA: Genera una ODP o una OTP
    RUN ML_Genera-OD-Control IN hMasterLibrary (INPUT ROWID(Faccpedi),    /* O/D */
                                                OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "ERROR: No se pudo generar el registro de control".
        UNDO LoopGrabarData, RETURN 'ADM-ERROR'.   
    END.
    */
    DELETE PROCEDURE hMasterLibrary.
    /* *************************************************************************** */
    /* GENERACION DE SUB-ORDENES, HPK Y PHR */
    /* *************************************************************************** */
    FIND gn-divi WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = Faccpedi.DivDes NO-LOCK NO-ERROR.
    CASE TRUE:
        WHEN Faccpedi.FlgSit = "T" 
            AND (gn-divi.Campo-Char[6] = "SE" /*OR Faccpedi.coddiv = "00017"*/) THEN DO:
            RUN LOG_Genera_SubOrden (BUFFER Faccpedi, OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO LoopGrabarData, RETURN 'ADM-ERROR'.
        END.
        WHEN Faccpedi.FlgSit = "T" AND gn-divi.Campo-Char[6] = "PR" THEN DO:
            /* 1ro. La HPK */
            RUN LOG_Genera_HPK (BUFFER Faccpedi, OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO LoopGrabarData, RETURN 'ADM-ERROR'.
            /* 2do. La PHR */
            /* La división que despacha vs la de origen debe ser PHR AUTOMATICA */
            RUN LOG_Genera_PHR (BUFFER Faccpedi, OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO LoopGrabarData, RETURN 'ADM-ERROR'.
        END.
    END CASE.
    IF AVAILABLE(FacCPedi) THEN RELEASE FacCPedi.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-OTR_Generacion_por_Compras) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OTR_Generacion_por_Compras Procedure 
PROCEDURE OTR_Generacion_por_Compras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Genera la OTR en base al movimiento de ooMoviAlmacen (I-90)
  que viene del OpenOrange 
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER TABLE FOR T-MoviAlmacen.
DEF INPUT PARAMETER pZona AS INTE.
DEF INPUT PARAMETER pBultos AS INTE.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEFINE VAR lDivDespacho AS CHAR NO-UNDO.
DEFINE VAR lAlmDespacho AS CHAR NO-UNDO.
DEFINE VAR s-CodDoc AS CHAR INIT 'OTR' NO-UNDO.
DEFINE VAR s-NroSer AS INTE NO-UNDO.
DEFINE VAR s-TpoPed AS CHAR NO-UNDO.
DEFINE VAR lFechaPedido AS DATE NO-UNDO.
DEFINE VAR I-NPEDI AS INTE NO-UNDO.

lFechaPedido = TODAY.

IF NOT CAN-FIND(FIRST T-MoviAlmacen NO-LOCK) THEN RETURN "OK".
IF CAN-FIND(FIRST T-MoviAlmacen WHERE TRUE <> (T-MoviAlmacen.almfinal > "") NO-LOCK) THEN DO:
    pMensaje = "El registro Almacen:" + T-MoviAlmacen.codalm + " Tipo:" + T-MoviAlmacen.tipmov + 
                " Cod.Mov:" + STRING(T-MoviAlmacen.codmov) + " Serie:" + STRING(T-MoviAlmacen.nroser) + 
                " Nro.Doc:" + STRING(T-MoviAlmacen.nrodoc) + " No tiene configurado el Almacen final".
    RETURN "ADM-ERROR".
END.

FOR EACH T-MoviAlmacen NO-LOCK:
    FIND FIRST Almacen WHERE Almacen.codcia = s-codcia
        AND Almacen.codalm = T-MoviAlmacen.codalm NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almacen THEN DO:
        pMensaje = 'Almacén de despacho ' + T-MoviAlmacen.codalm + ' NO existe'.
        RETURN "ADM-ERROR".
    END.
    lDivDespacho = Almacen.CodDiv.
    lAlmDespacho = Almacen.codalm.
END.
/* ************************************************************************************** */
/* Control del correlativo  de la OTR */
/* ************************************************************************************** */
FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
    FacCorre.CodDiv = lDivDespacho AND
    FacCorre.CodDoc = s-coddoc AND
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    pMensaje = "Codigo de Documento " + s-coddoc + " No configurado para la division " + lDivDespacho.
    RETURN "ADM-ERROR".
END.
s-NroSer = FacCorre.NroSer.

/* ************************************************************************************** */
/* Capturamos parámetros del primer registro (todos son iguales) */
/* ************************************************************************************** */
FIND FIRST T-MoviAlmacen NO-LOCK.

DEFINE VAR x-codalm AS CHAR NO-UNDO.
DEFINE VAR x-almfinal AS CHAR NO-UNDO.
DEFINE VAR x-tipmov AS CHAR NO-UNDO.
DEFINE VAR x-codmov AS INT NO-UNDO.
DEFINE VAR x-nroser AS INT NO-UNDO.
DEFINE VAR x-nrodoc AS INT NO-UNDO.
DEFINE VAR s-userid AS CHAR INIT "BATCH".

x-codalm    = T-MoviAlmacen.codalm.
x-almfinal  = T-MoviAlmacen.almfinal.
x-tipmov    = T-MoviAlmacen.tipmov.
x-codmov    = T-MoviAlmacen.codmov.
x-nroser    = T-MoviAlmacen.nroser.
x-nrodoc    = T-MoviAlmacen.nrodoc.

/* ************************************************************************************** */
/* RUTINA PRINCIPAL */
/* ************************************************************************************** */
PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i
        &Tabla="FacCorre"
        &Condicion="Faccorre.codcia = s-codcia
        AND Faccorre.coddoc = s-coddoc
        AND Faccorre.nroser = s-nroser"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"
        }
    /* **************************************************************************** */
    /* Destino final */
    /* **************************************************************************** */
    FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = x-almfinal NO-LOCK NO-ERROR.
    /* **************************************************************************** */
    CREATE Faccpedi.
    ASSIGN 
        Faccpedi.CodCia = S-CODCIA
        Faccpedi.CodDoc = s-coddoc 
        Faccpedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        Faccpedi.CodRef = "OPEN"      /* OPEN */
        Faccpedi.FchPed = TODAY
        Faccpedi.CodDiv = lDivDespacho
        FacCPedi.CodAlm = lAlmDespacho
        FacCPedi.DivDes = lDivDespacho
        Faccpedi.FlgEst = "X"       /* EN PROCESO */
        FacCPedi.TpoPed = s-TpoPed
        FacCPedi.FlgEnv = YES
        FacCPedi.Libre_c01 = s-User-id + '|' + STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM')
        FacCPedi.FchEnt = lFechaPedido
        Faccpedi.FchVen = lFechaPedido + 7
        Faccpedi.CodCli = x-almfinal
        Faccpedi.NomCli = Almacen.Descripcion
        Faccpedi.Dircli = Almacen.DirAlm
        FacCPedi.NroRef = STRING(x-nroser,"999") + STRING(x-nrodoc,"9999999999")
        FacCPedi.Glosa  = T-MoviAlmacen.observ
        FacCPedi.codmon = T-MoviAlmacen.codmon
        FacCPedi.tpocmb = T-MoviAlmacen.tpocmb
        FacCPedi.OrdCmp = T-MoviAlmacen.NroRf1
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = 'Error en el correlativo' + CHR(10) + 'No se pudo grabar la ' + s-coddoc.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    RELEASE FacCorre.
    /* *************************************************************************** */
    /* Ubicación del Almacén Destino */
    /* *************************************************************************** */
    ASSIGN
        FacCPedi.Ubigeo[1] = ""
        FacCPedi.Ubigeo[2] = "@ALM"
        FacCPedi.Ubigeo[3] = Faccpedi.CodCli.
    /* *************************************************************************** */
    /* Motivo */
    /* *************************************************************************** */
    ASSIGN FacCPedi.MotReposicion = "16".
    ASSIGN FacCPedi.VtaPuntual = NO.
    /* Actualizamos la hora cuando lo vuelve a modificar */
    ASSIGN
        Faccpedi.Usuario = S-USER-ID
        Faccpedi.Hora   = STRING(TIME,"HH:MM:SS").
    /* ***************************************************************** */
    /* FECHA DE ENTREGA */
    /* ***************************************************************** */
    RUN logis/p-fecha-de-entrega (FacCPedi.CodDoc,              /* Documento actual */
                                  FacCPedi.NroPed,
                                  INPUT-OUTPUT lFechaPedido,
                                  OUTPUT pMensaje).
    IF pMensaje > '' THEN UNDO, RETURN 'ADM-ERROR'.

    ASSIGN
        FacCPedi.FchEnt = lFechaPedido
        Faccpedi.FchVen = lFechaPedido + 7
        Faccpedi.FlgEst = "P".                  /* OJO >>> APROBADO */
    /*pFechaEntrega = lFechaPedido.               /* OJO: FECHA REPROGRAMADA */*/
    /* ***************************************************************** */
    /* CONTROL DE OTROS PROCESOS POR DIVISION */
    /* ***************************************************************** */
    /*RUN GEN_Otros_Procesos (BUFFER Faccpedi).*/
    ASSIGN 
        FacCPedi.UsrAprobacion = S-USER-ID
        FacCPedi.FchAprobacion = TODAY.
    /* CONTROL DE OTROS PROCESOS POR DIVISION */
    ASSIGN 
        FacCPedi.FlgEst = 'P'
        FacCPedi.FlgSit = 'C'.      /* DIRECTO A DISTRIBUCION */
    /* OTROS DATOS DE CONTROL */
    ASSIGN
        FacCPedi.CodOrigen = T-MoviAlmacen.CodAlm + ":" + T-MoviAlmacen.TipMov + ":" + STRING(T-MoviAlmacen.CodMov)
        FacCPedi.NroOrigen = STRING(T-MoviAlmacen.NroSer,"999") + ":" + STRING(T-MoviAlmacen.NroDoc,"9999999999").
    /* *************************************************************************** */
    /* DETALLE DE LA OTR */
    /* Por si acaso verificamos SKUs repetidos */
    /* *************************************************************************** */
    I-NPEDI = 0.
    FOR EACH T-MoviAlmacen NO-LOCK WHERE T-MoviAlmacen.codalm = x-codalm 
        AND T-MoviAlmacen.tipmov = x-tipmov 
        AND T-MoviAlmacen.codmov = x-codmov 
        AND T-MoviAlmacen.nroser = x-nroser 
        AND T-MoviAlmacen.nrodoc = x-nrodoc,
        FIRST Almmmatg OF T-MoviAlmacen NO-LOCK
        BY T-MoviAlmacen.nroitm:
        FIND FIRST Facdpedi WHERE Facdpedi.CodCia = Faccpedi.CodCia
            AND Facdpedi.CodDiv = Faccpedi.CodDiv
            AND Facdpedi.coddoc = Faccpedi.coddoc
            AND Facdpedi.NroPed = Faccpedi.NroPed
            AND Facdpedi.codmat = T-MoviAlmacen.codmat
            NO-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE Facdpedi THEN DO:
            CREATE Facdpedi.
            ASSIGN
                Facdpedi.CodCia = Faccpedi.CodCia
                Facdpedi.CodDiv = Faccpedi.CodDiv
                Facdpedi.coddoc = Faccpedi.coddoc
                Facdpedi.NroPed = Faccpedi.NroPed
                Facdpedi.codmat = T-MoviAlmacen.codmat.
            I-NPEDI = I-NPEDI + 1.
        END.
        ELSE DO:
            FIND CURRENT Facdpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                {lib/mensaje-de-error.i &MensajeError="pMensaje"}
                UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
            END.
        END.
        ASSIGN 
            Facdpedi.AlmDes = Faccpedi.CodAlm
            Facdpedi.FchPed = Faccpedi.FchPed
            Facdpedi.Hora   = Faccpedi.Hora 
            Facdpedi.FlgEst = "P"     /*Faccpedi.FlgEst*/
            Facdpedi.NroItm = I-NPEDI.
        ASSIGN 
            facdpedi.factor = T-MoviAlmacen.factor
            facdpedi.undvta = Almmmatg.UndBas
            facdpedi.tipvta = ""
            facdpedi.canped = Facdpedi.canped + T-MoviAlmacen.candes
            facdpedi.preuni = 0
            facdpedi.implin = 0
            facdpedi.aftigv = YES
            facdpedi.aftisc = NO
            facdpedi.prebas = 0
            facdpedi.pesmat = Almmmatg.pesmat
            facdpedi.almdes = lAlmDespacho
            facdpedi.canpick = 0
            facdpedi.preuni  = T-MoviAlmacen.linpreuni.
        RELEASE Facdpedi.
    END.
    /* *********************************************************** */
    /* RHC Calculamos totales */
    /* *********************************************************** */
/*     ASSIGN                                                                                                            */
/*         Faccpedi.Items = 0          /* Items */                                                                       */
/*         Faccpedi.Peso = 0           /* Peso kg */                                                                     */
/*         Faccpedi.Volumen = 0.       /* Volumen m3 */                                                                  */
/*     FOR EACH Facdpedi OF Faccpedi NO-LOCK,FIRST Almmmatg OF Facdpedi NO-LOCK:                                         */
/*         ASSIGN                                                                                                        */
/*             Faccpedi.Items = Faccpedi.Items + 1                                                                       */
/*             Faccpedi.Peso = Faccpedi.Peso + (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.PesMat)                     */
/*             Faccpedi.Volumen = Faccpedi.Volumen + (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.Libre_d02 / 1000000). */
/*     END.                                                                                                              */
    /* *********************************************************** */
    /* IMPORTES en S/  ----------- Costos de reposicion revisar */
    /* *********************************************************** */
    ASSIGN
        Faccpedi.AcuBon[8] = Faccpedi.ImpTot * (IF Faccpedi.CodMon = 2 THEN Faccpedi.TpoCmb ELSE 1).   /* Importes */
    IF Faccpedi.CodDoc = "OTR" THEN DO:
        ASSIGN
            Faccpedi.AcuBon[8] = 0.
        FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
            ASSIGN 
                Faccpedi.AcuBon[8] = Faccpedi.AcuBon[8] + 
                                    (Facdpedi.CanPed * Facdpedi.Factor * Facdpedi.preuni) * 
                                    (IF faccpedi.codmon = 2 THEN faccpedi.TpoCmb ELSE 1).
        END.
    END.
    /* ************************************************************** */
    /* TRACKING */
    /* ************************************************************** */
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
    /* *************************************************************************** */
    /* Creamos control de bultos */
    /* *************************************************************************** */
    IF NOT CAN-FIND(FIRST Ccbcbult WHERE CcbCBult.CodCia = Faccpedi.codcia 
                    AND CcbCBult.CodDiv = Faccpedi.coddiv
                    AND CcbCBult.CodDoc = Faccpedi.coddoc
                    AND CcbCBult.NroDoc = Faccpedi.nroped
                    NO-LOCK) THEN DO:
        CREATE CcbCBult.
        ASSIGN
            CcbCBult.CodCia = Faccpedi.codcia 
            CcbCBult.CodDiv = Faccpedi.coddiv
            CcbCBult.CodDoc = Faccpedi.coddoc
            CcbCBult.NroDoc = Faccpedi.nroped
            CcbCBult.Bultos = pBultos
            CcbCBult.Chequeador = s-user-id
            CcbCBult.CodCli = Faccpedi.codcli
            CcbCBult.DirCli = Faccpedi.dircli
            CcbCBult.NomCli = Faccpedi.nomcli
            .
        RELEASE CcbCBult.
    END.
    /* **************************** */
    /* LOG de control para REPORTES */
    /* Como no hay HPK se pasa la OTR */
    /* **************************** */
    RUN lib/logtabla ("FACCPEDI",
                      s-coddiv + ":" + Faccpedi.coddoc + ":" + Faccpedi.nroped + ":" + STRING(pZona),
                      "DIST_RECEP_BULTOS").
    /* *************************************************************************** */
    /* *************************************************************************** */
    /* RHC 22/09/2020 Control por M.R. */
    /* *************************************************************************** */
    /* SE VA A BLOQUEAR, NO SE LE VE UTILIDAD PRACTICA: Genera una ODP o una OTP
    RUN ML_Genera-OD-Control IN hMasterLibrary (INPUT ROWID(Faccpedi),    /* O/D */
                                                OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "ERROR: No se pudo generar el registro de control".
        UNDO LoopGrabarData, RETURN 'ADM-ERROR'.   
    END.
    */
    /* *************************************************************************** */
    /* GENERACION DE SUB-ORDENES, HPK Y PHR */
    /* OJO: Nunca va a pasar por aquí */
    /* *************************************************************************** */
/*     FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = Faccpedi.DivDes NO-LOCK NO-ERROR.     */
/*     CASE TRUE:                                                                                              */
/*         WHEN Faccpedi.FlgSit = "T" AND (gn-divi.Campo-Char[6] = "SE" OR Faccpedi.coddiv = "00017") THEN DO: */
/*             RUN LOG_Genera_SubOrden (BUFFER Faccpedi, OUTPUT pMensaje).                                     */
/*             IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.                                    */
/*         END.                                                                                                */
/*         WHEN Faccpedi.FlgSit = "T" AND gn-divi.Campo-Char[6] = "PR" THEN DO:                                */
/*             /* 1ro. La HPK */                                                                               */
/*             RUN LOG_Genera_HPK (BUFFER Faccpedi, OUTPUT pMensaje).                                          */
/*             IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.                                    */
/*             /* 2do. La PHR */                                                                               */
/*             /* La división que despacha vs la de origen debe ser PHR AUTOMATICA */                          */
/*             RUN LOG_Genera_PHR (BUFFER Faccpedi, OUTPUT pMensaje).                                          */
/*             IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.                                    */
/*         END.                                                                                                */
/*     END CASE.                                                                                               */
    IF AVAILABLE(FacCPedi) THEN RELEASE FacCPedi.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-OTR_Generacion_por_CrossDocking) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OTR_Generacion_por_CrossDocking Procedure 
PROCEDURE OTR_Generacion_por_CrossDocking PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Rutina PRIVATE
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pProcesoBatch AS LOG.
DEF OUTPUT PARAMETER pComprobante AS CHAR.     /* OTR generada */
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR s-coddoc     AS CHAR INITIAL "OTR" NO-UNDO.    /* Orden de Transferencia */
DEF VAR s-NroSer     AS INT  NO-UNDO.
DEF VAR s-TpoPed     AS CHAR INITIAL "" NO-UNDO.

/* ***************************************************************************** */
/* PARAMETROS DE PEDIDOS PARA LA DIVISION */
/* ***************************************************************************** */
DEF VAR s-FlgEmpaque LIKE GN-DIVI.FlgEmpaque.
DEF VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEF VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.

DEF VAR cUbigeo     AS CHAR NO-UNDO.
DEF VAR lHora       AS CHAR NO-UNDO.
DEF VAR lDias       AS INT NO-UNDO.
DEF VAR lHoraTope   AS CHAR NO-UNDO.
DEF VAR lFechaPedido AS DATE NO-UNDO.

/* ***************************************************************************** */
/* El Almacén Destino (El que va a hacer el despacho final al cliente) */
/* ***************************************************************************** */
FIND FIRST Almacen WHERE Almacen.codcia = s-codcia
      AND Almacen.codalm = PEDIDO.AlmacenXD NO-LOCK NO-ERROR.
IF NOT AVAILABLE almacen THEN DO:
    pMensaje = 'Almacén CrossDocking: ' + PEDIDO.AlmacenXD + ' NO existe'.
    RETURN "ADM-ERROR".
END.
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = Almacen.CodDiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    pMensaje = 'División del almacén CrossDocking: ' + Almacen.CodDiv + ' errada'.
    RETURN "ADM-ERROR".
END.
cUbigeo = TRIM(gn-divi.Campo-Char[3]) + TRIM(gn-divi.Campo-Char[4]) + TRIM(gn-divi.Campo-Char[5]).

/* ***************************************************************************** */
/* El almacén de Despacho (El que debería despachar al cliente) */
/* ***************************************************************************** */
DEF VAR lDivDespacho AS CHAR NO-UNDO.
DEF VAR lAlmDespacho AS CHAR NO-UNDO.

FIND FIRST Almacen WHERE Almacen.codcia = s-codcia
      AND Almacen.codalm = PEDIDO.CodAlm NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almacen THEN DO:
    pMensaje = 'Almacen de despacho ' + PEDIDO.CodAlm + ' No existe'.
    RETURN "ADM-ERROR".
END.
lDivDespacho = Almacen.CodDiv.
lAlmDespacho = Almacen.CodAlm.
/* ***************************************************************************** */
/* Control del correlativo */
/* ***************************************************************************** */
FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
    FacCorre.CodDiv = lDivDespacho AND
    FacCorre.CodDoc = S-CODDOC AND
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
   pMensaje = "Codigo de Documento: " + s-coddoc + " No configurado para la división " + lDivDespacho.
   RETURN "ADM-ERROR".
END.
/* La serie segun el almacén de donde se desea despachar */
s-NroSer = FacCorre.NroSer.
/* ***************************************************************************** */
/* Datos de la División de Despacho */
/* ***************************************************************************** */
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = lDivDespacho
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    pMensaje = 'División: ' + lDivDespacho + ' NO configurada'.
    RETURN "ADM-ERROR".
END.
ASSIGN
    s-DiasVtoPed = GN-DIVI.DiasVtoPed
    s-FlgEmpaque = GN-DIVI.FlgEmpaque
    s-VentaMayorista = GN-DIVI.VentaMayorista.

/* ***************************************************************************** */
/* RUTINA MASTER */
/* ***************************************************************************** */
PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* ******************************************************************************** */
    /* Adiciono el Registro en la Cabecera */
    /* ******************************************************************************** */
    {lib/lock-genericov3.i
        &Tabla="FacCorre"
        &Condicion="Faccorre.codcia = s-codcia
        AND Faccorre.coddoc = s-coddoc
        AND Faccorre.nroser = s-nroser"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"
        }
    /* ***************************************************************** */
    /* Determino la fecha de entrega del pedido */
    /* ***************************************************************** */
    lFechaPedido = MAXIMUM(TODAY, PEDIDO.FchEnt).
    CREATE Faccpedi.
    BUFFER-COPY PEDIDO TO Faccpedi
        ASSIGN 
        Faccpedi.CodCia = S-CODCIA
        Faccpedi.CodDiv = lDivDespacho
        Faccpedi.CodDoc = s-coddoc      /* OTR */
        Faccpedi.TpoPed = s-tpoped      /* "" */
        Faccpedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        FacCPedi.CodAlm = lAlmDespacho
        Faccpedi.FchPed = TODAY
        Faccpedi.FlgEst = "X"       /* EN PROCESO */
        FacCPedi.FlgEnv = YES
        FacCPedi.Libre_c01 = s-User-id + '|' + STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM')
        FacCPedi.FchEnt = lFechaPedido
        Faccpedi.FchVen = lFechaPedido + 7
        Faccpedi.CodRef = PEDIDO.CodDoc    /* PED */
        FacCPedi.NroRef = PEDIDO.NroPed
        FacCPedi.Glosa = PEDIDO.Glosa
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = 'NO se pudo grabar la ' + s-coddoc.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN 
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    RELEASE FacCorre.
    /* 20/12/17 Cross Docking */
    ASSIGN
        Faccpedi.CrossDocking = YES
        Faccpedi.AlmacenXD    = Faccpedi.CodCli.            /* Destino Final (Cliente) */
    ASSIGN
        Faccpedi.CodCli       = PEDIDO.AlmacenXD.          /* Almacén de Tránsito */
    FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = PEDIDO.AlmacenXD NO-LOCK NO-ERROR.
    ASSIGN
        Faccpedi.NomCli = Almacen.Descripcion
        Faccpedi.Dircli = Almacen.DirAlm.
    /* Actualizamos la hora cuando lo vuelve a modificar */
    ASSIGN
        Faccpedi.Usuario = S-USER-ID
        Faccpedi.Hora   = STRING(TIME,"HH:MM:SS").
    /* Division destino */
    FIND Almacen OF Faccpedi NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN FacCPedi.DivDes = Almacen.CodDiv.
    /* ***************************************************************** */
    /* FECHA DE ENTREGA */
    /* ***************************************************************** */
    RUN logis/p-fecha-de-entrega (FacCPedi.CodDoc,              /* Documento actual */
                                  FacCPedi.NroPed,
                                  INPUT-OUTPUT lFechaPedido,
                                  OUTPUT pMensaje).
    IF pMensaje > '' THEN UNDO, RETURN 'ADM-ERROR'.

    ASSIGN
        FacCPedi.FchEnt = lFechaPedido
        Faccpedi.FchVen = lFechaPedido + 7
        Faccpedi.FlgEst = "P".                  /* OJO >>> APROBADO */
    pComprobante = Faccpedi.coddoc + ' ' + Faccpedi.nroped.
    /* ***************************************************************** */
    /* CONTROL DE OTROS PROCESOS POR DIVISION */
    /* ***************************************************************** */
    RUN GEN_Otros_Procesos (BUFFER Faccpedi).

    /* ***************************************************************** */
    /* DETALLE DE LA OTR */
    /* ***************************************************************** */
    RUN GEN_Detalle_de_la_OTR (BUFFER Faccpedi,
                               INPUT lDivDespacho,
                               INPUT lAlmDespacho,
                               OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

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
    /* *************************************************************************** */
    /* RHC 22/09/2020 Control por M.R. */
    /* *************************************************************************** */
    /* SE VA A BLOQUEAR, NO SE LE VE UTILIDAD PRACTICA: Genera una ODP o una OTP
    RUN ML_Genera-OD-Control IN hMasterLibrary (INPUT ROWID(Faccpedi),    /* O/D */
                                                OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "ERROR: No se pudo generar el registro de control".
        UNDO LoopGrabarData, RETURN 'ADM-ERROR'.   
    END.
    */
    /* *************************************************************************** */
    /* GENERACION DE SUB-ORDENES, HPK Y PHR */
    /* *************************************************************************** */
    FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = Faccpedi.DivDes NO-LOCK NO-ERROR.
    CASE TRUE:
        WHEN Faccpedi.FlgSit = "T" AND (gn-divi.Campo-Char[6] = "SE" /*OR Faccpedi.coddiv = "00017"*/) THEN DO:
            RUN LOG_Genera_SubOrden (BUFFER Faccpedi, OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        END.
        WHEN Faccpedi.FlgSit = "T" AND gn-divi.Campo-Char[6] = "PR" THEN DO:
            /* 1ro. La HPK */
            RUN LOG_Genera_HPK (BUFFER Faccpedi, OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
            /* 2do. La PHR */
            /* La división que despacha vs la de origen debe ser PHR AUTOMATICA */
            RUN LOG_Genera_PHR (BUFFER Faccpedi, OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        END.
    END CASE.
    IF AVAILABLE(FacCPedi) THEN RELEASE FacCPedi.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-OTR_Generacion_por_RA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OTR_Generacion_por_RA Procedure 
PROCEDURE OTR_Generacion_por_RA PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       bAlmcrepo ya debe estar en el registro correcto y bloqueado
------------------------------------------------------------------------------*/

/* Se puede originar a partir de estos tipo documentos:
    R/A
    O/D
    O/M
    CDC       Cross Docking Compras
*/

DEF PARAMETER BUFFER bAlmcrepo FOR Almcrepo.
DEF INPUT PARAMETER pCrossDocking AS LOG.
DEF INPUT PARAMETER pAlmacenXD AS CHAR.
DEF OUTPUT PARAMETER pFechaEntrega AS DATE.
DEF OUTPUT PARAMETER pMensaje2 AS CHAR.     /* OJO: sin NO-UNDO para revertir mensaje */
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF BUFFER bAlmacen FOR Almacen.

/* ***************************************************************** */
/* Faltantes y Sobrantes NO generan movimientos de OTR */
/* ***************************************************************** */
/* 05/08/2025: Se genera para todos */
/* IF bAlmcrepo.TipMov = "INC" AND (bAlmcrepo.Incidencia = "F" OR bAlmcrepo.Incidencia = "S") THEN DO: */
/*     RETURN "OK".                                                                                    */
/* END.                                                                                                */

DEF VAR s-CodRef AS CHAR INIT 'R/A' NO-UNDO.
DEF VAR s-CodDoc AS CHAR INIT 'OTR' NO-UNDO.
DEF VAR lDivDespacho LIKE Almacen.CodDiv NO-UNDO.
DEF VAR lAlmDespacho LIKE bAlmcrepo.almped NO-UNDO.
DEF VAR s-NroSer AS INTE NO-UNDO.
DEF VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEF VAR s-FlgEmpaque LIKE GN-DIVI.FlgEmpaque.
DEF VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEF VAR lFechaPedido AS DATE NO-UNDO.

/* ************************************************************************************** */
/* Almacén Destino */
/* ************************************************************************************** */
FIND FIRST bAlmacen WHERE bAlmacen.codcia = s-codcia AND bAlmacen.codalm = bAlmcrepo.CodAlm NO-LOCK NO-ERROR.
IF NOT AVAILABLE bAlmacen THEN DO:
    pMensaje = 'Almacén ' + bAlmcrepo.CodAlm + ' NO existe'.
    RETURN "ADM-ERROR".
END.
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = bAlmacen.CodDiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    pMensaje = 'División ' + bAlmacen.CodDiv + ' del almacén destino NO configurada'.
    RETURN "ADM-ERROR".
END.
/* ************************************************************************************** */
/* El almacén de Despacho */
/* ************************************************************************************** */
FIND FIRST bAlmacen WHERE bAlmacen.codcia = s-codcia AND bAlmacen.codalm = bAlmcrepo.almped NO-LOCK NO-ERROR.
IF NOT AVAILABLE bAlmacen THEN DO:
    pMensaje = 'Almacen de despacho ' + bAlmcrepo.almped + ' No existe'.
    RETURN "ADM-ERROR".
END.
lDivDespacho = bAlmacen.CodDiv.
lAlmDespacho = bAlmcrepo.almped.
/* ************************************************************************************** */
/* Control del correlativo  de la OTR */
/* ************************************************************************************** */
FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
    FacCorre.CodDiv = lDivDespacho AND
    FacCorre.CodDoc = S-CODDOC AND
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    pMensaje = "Codigo de Documento " + s-coddoc + " no configurado para la division " + lDivDespacho.
    RETURN "ADM-ERROR".
END.
/* La serie segun el almacén de donde se desea despachar(bAlmcrepo.almped) segun la R/A */
ASSIGN s-NroSer = FacCorre.NroSer.
/* Datos de la División de Despacho */
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = lDivDespacho NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    pMensaje = 'División ' + lDivDespacho + ' NO configurada'.
    RETURN "ADM-ERROR".
END.
ASSIGN
    s-DiasVtoPed = GN-DIVI.DiasVtoPed
    s-FlgEmpaque = GN-DIVI.FlgEmpaque
    s-VentaMayorista = GN-DIVI.VentaMayorista.
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    RUN GEN_Carga_Detalle_OTR_por_RA (INPUT s-CodDoc,
                                      INPUT lAlmDespacho,
                                      INPUT lDivDespacho).
    IF NOT CAN-FIND(FIRST PEDI NO-LOCK) THEN DO:
        pMensaje = "NO hay items para generar la OTR".
        UNDO, RETURN 'ADM-ERROR'.
    END.

    {lib/lock-genericov3.i
        &Tabla="FacCorre"
        &Condicion="Faccorre.codcia = s-codcia
        AND Faccorre.coddoc = s-coddoc
        AND Faccorre.nroser = s-nroser"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"
        }

    /* **************************************************************************** */
    /* Destino */
    /* **************************************************************************** */
    FIND bAlmacen WHERE bAlmacen.codcia = s-codcia AND 
        bAlmacen.codalm = bAlmcrepo.codalm NO-LOCK NO-ERROR.
    /* **************************************************************************** */
    CREATE Faccpedi.
    ASSIGN 
        Faccpedi.CodCia = S-CODCIA
        Faccpedi.CodDoc = s-coddoc 
        Faccpedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        Faccpedi.CodRef = s-codref      /* R/A */
        Faccpedi.FchPed = TODAY
        Faccpedi.CodDiv = lDivDespacho
        FacCPedi.CodAlm = lAlmDespacho
        Faccpedi.FlgEst = "X"       /* EN PROCESO */
        FacCPedi.FlgEnv = YES
        FacCPedi.Libre_c01 = s-User-id + '|' + STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM')
        Faccpedi.CodCli = bAlmcrepo.CodAlm
        Faccpedi.NomCli = bAlmacen.Descripcion
        Faccpedi.Dircli = bAlmacen.DirAlm
        FacCPedi.NroRef = STRING(bAlmcrepo.nroser,"999") + STRING(bAlmcrepo.nrodoc,"999999")
        FacCPedi.Glosa  = bAlmcrepo.Glosa
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = 'Error en el correlativo' + CHR(10) + 'No se pudo grabar la ' + s-coddoc + CHR(10) +
             STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999").
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN 
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    RELEASE FacCorre.

    /* ***************************************************************** */
    /* FECHA DE ENTREGA */
    /* ***************************************************************** */
    lFechaPedido = MAXIMUM(TODAY, bAlmcrepo.Fecha).
    IF lFechaPedido = ? THEN lFechaPedido = TODAY.
    RUN logis/p-fecha-de-entrega (FacCPedi.CodDoc,              /* Documento actual */
                                  FacCPedi.NroPed,
                                  INPUT-OUTPUT lFechaPedido,
                                  OUTPUT pMensaje).
    IF pMensaje > '' THEN UNDO, RETURN 'ADM-ERROR'.

    ASSIGN
        FacCPedi.FchEnt = lFechaPedido
        Faccpedi.FchVen = lFechaPedido + 7
        Faccpedi.FlgEst = "P".                                  /* OJO >>> APROBADO */
    pFechaEntrega = lFechaPedido. 
    ASSIGN
        pMensaje2 = "ORDEN DE TRANSFERENCIA N° " + Faccpedi.NroPed + CHR(10) +
                    "Fecha de entrega: " + STRING(lFechaPedido).

    /* *************************************************************************** */
    /* RHC 26/10/2020 PEDIDO COMERCIAL (Cotizacion) que viene de la R/A */
    /* *************************************************************************** */
    ASSIGN
        Faccpedi.Libre_c03 = bAlmcrepo.Libre_c03.
    /* *************************************************************************** */
    /* RHC 21/03/2019 Motivo de la INCIDENCIA */
    /* *************************************************************************** */
    IF bAlmcrepo.TipMov = "INC" THEN DO:
        Faccpedi.Glosa  = "INCIDENCIA: ".
        CASE bAlmcrepo.Incidencia:
            WHEN "F" THEN ASSIGN Faccpedi.Glosa  = Faccpedi.Glosa + "FALTANTE".
            WHEN "S" THEN ASSIGN Faccpedi.Glosa  = Faccpedi.Glosa + "SOBRANTE".
            WHEN "M" THEN ASSIGN Faccpedi.Glosa  = Faccpedi.Glosa + "MAL ESTADO".
        END CASE.
        Faccpedi.Glosa  = Faccpedi.Glosa + " / " + s-user-id + ' ' + STRING(NOW, '99/99/9999 HH:MM:SS').
        Faccpedi.Observa = Faccpedi.Glosa.
        Faccpedi.CodOrigen = bAlmcrepo.CodRef.    /* INC */
        Faccpedi.NroOrigen = bAlmcrepo.NroRef.    /* AlmCIncidencia.NroControl */
        Faccpedi.TpoPed = "INC".
    END.
    /* *************************************************************************** */
    /* 20/12/17 Cross Docking */
    IF pCrossDocking = YES THEN DO:
        Faccpedi.CrossDocking = YES.
        Faccpedi.AlmacenXD    = Faccpedi.CodCli.    /* Destino Final */
        Faccpedi.CodCli       = pAlmacenXD.         /* Almacén de Tránsito */
        FIND bAlmacen WHERE bAlmacen.codcia = s-codcia AND bAlmacen.codalm = pAlmacenXD NO-LOCK NO-ERROR.
        Faccpedi.NomCli = bAlmacen.Descripcion.
        Faccpedi.Dircli = bAlmacen.DirAlm.
    END.
    /* *************************************************************************** */
    /* Ubicación del Almacén Destino */
    /* *************************************************************************** */
    ASSIGN
        FacCPedi.Ubigeo[1] = ""
        FacCPedi.Ubigeo[2] = "@ALM"
        FacCPedi.Ubigeo[3] = Faccpedi.CodCli.
    /* *************************************************************************** */
    /* Motivo */
    /* *************************************************************************** */
    ASSIGN FacCPedi.MotReposicion = bAlmcrepo.MotReposicion.
    ASSIGN FacCPedi.VtaPuntual = bAlmcrepo.VtaPuntual.
    /* Actualizamos la hora cuando lo vuelve a modificar */
    ASSIGN
        Faccpedi.Usuario = S-USER-ID
        Faccpedi.Hora   = STRING(TIME,"HH:MM:SS").
    /* Division destino */
    FIND bAlmacen OF Faccpedi NO-LOCK NO-ERROR.
    IF AVAILABLE bAlmacen THEN FacCPedi.DivDes = bAlmacen.CodDiv.
    /* ***************************************************************** */
    /* CONTROL DE OTROS PROCESOS POR DIVISION */
    /* ***************************************************************** */
    RUN GEN_Otros_Procesos (BUFFER Faccpedi).
    /* ******************************************************************** */
    /* Detalle de la OTR */
    /* ******************************************************************** */
    RUN GEN_Detalle_OTR_por_RA (BUFFER Faccpedi, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    /* IMPORTES en S/ */
    ASSIGN
        Faccpedi.AcuBon[8] = 0.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
        ASSIGN 
            Faccpedi.AcuBon[8] = Faccpedi.AcuBon[8] + 
                (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.CtoTot) * 
                (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1).
    END.
    /* *********************************************************** */
    /* ACTUALIZAMOS SALDO DE LA R/A */
    /* *********************************************************** */
    RUN alm/pactualizareposicion ( ROWID(Faccpedi), "C", OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo extornar la R/A'.
        UNDO, RETURN 'ADM-ERROR'.
    END.

    /* *********************************************************** */
    /* TRACKING */
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
    /* *************************************************************************** */
    /* RHC 22/09/2020 Control por M.R. */
    /* *************************************************************************** */
    /* SE VA A BLOQUEAR, NO SE LE VE UTILIDAD PRACTICA: Genera una ODP o una OTP
    RUN ML_Genera-OD-Control IN hMasterLibrary (INPUT ROWID(Faccpedi),    /* O/D */
                                                OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "ERROR: No se pudo generar el registro de control".
        UNDO LoopGrabarData, RETURN 'ADM-ERROR'.   
    END.
    */
    /* ***************************************************************** */
    /* CAMBIOS SI EL ORIGEN ES UNA INCIDENCIA */
    /* Faltantes y Mal Estado */
    /* ***************************************************************** */
/*     IF bAlmcrepo.TipMov = "INC" AND (bAlmcrepo.Incidencia = "F" OR bAlmcrepo.Incidencia = "S") THEN DO: */
/*         ASSIGN                                                                                          */
/*             Faccpedi.FlgSit = "C"   /* Chequeado */                                                     */
/*             Faccpedi.FlgEst = "C".  /* Atendido */                                                      */
/*         /* *********************************************************************************** */       */
/*         /* RHC 23/02/2019 Solicitado por Lucy Mesia */                                                  */
/*         /* Viene de una INCidencia */                                                                   */
/*         /* *********************************************************************************** */       */
/*         ASSIGN                                                                                          */
/*             Faccpedi.fchchq = TODAY                                                                     */
/*             Faccpedi.horchq = STRING(TIME,'HH:MM:SS').                                                  */
/*         /* *********************************************************************************** */       */
/*         FOR EACH Facdpedi OF Faccpedi EXCLUSIVE-LOCK:                                                   */
/*             Facdpedi.CanAte = Facdpedi.CanPed.                                                          */
/*         END.                                                                                            */
/*         RELEASE Facdpedi.                                                                               */
/*     END.                                                                                                */
    /* *************************************************************************** */
    /* GENERACION DE SUB-ORDENES, HPK Y PHR */
    /* *************************************************************************** */
    FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = Faccpedi.DivDes NO-LOCK NO-ERROR.
    CASE TRUE:
        WHEN bAlmcrepo.TipMov = "INC" AND (bAlmcrepo.Incidencia = "F" OR bAlmcrepo.Incidencia = "S") THEN DO:
            /* En estos casos NO genera HPK ni PHR ni nada */

        END.
        WHEN Faccpedi.FlgSit = "T" AND (gn-divi.Campo-Char[6] = "SE") THEN DO:
            RUN LOG_Genera_SubOrden (BUFFER Faccpedi, OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        END.
        WHEN Faccpedi.FlgSit = "T" AND gn-divi.Campo-Char[6] = "PR" THEN DO:
            /* 1ro. La HPK */
            RUN LOG_Genera_HPK (BUFFER Faccpedi, OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
            /* 2do. La PHR */
            /* La división que despacha vs la de origen debe ser PHR AUTOMATICA */
            RUN LOG_Genera_PHR (BUFFER Faccpedi, OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        END.
    END CASE.

    IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PED_Despachar_Rutina_Master) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PED_Despachar_Rutina_Master Procedure 
PROCEDURE PED_Despachar_Rutina_Master :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       El Pedido Logístico (PED) debe cumplir ciertas condiciones para
  ser aprobado y generar automáticamente una Orden de Despacho (O/D), en caso 
  contrario debe pasar a ser aprobado por C&C
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.                /* PED */
DEF INPUT PARAMETER pProcesoBatch AS LOG.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pAviso AS CHAR NO-UNDO.

/* ****************************************************************************** */
/* Nos posicionamos en el PEDIDO LOGISTICO */
/* ****************************************************************************** */
FIND PEDIDO WHERE ROWID(PEDIDO) = pRowid NO-LOCK NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    {lib/mensaje-de-error.i &CuentaError="LocalCuentaError" &MensajeError="pMensaje"}
    RETURN 'ADM-ERROR'.
END.
/* OJO: Solo PEDidos GENERADOS */  
IF PEDIDO.flgest <> "G" THEN DO:
    pMensaje = "El pedido ya NO está por aprobar". 
    RETURN "ADM-ERROR".
END.

/* 29/04/2026: Harold Segura, control de dirección de entrega */
/* 1ro. NO debe ser "Cliente Recoge" */
IF PEDIDO.Cliente_Recoge = NO THEN DO:
    RUN Verifica_Agencia_Transporte (OUTPUT pMensaje).
    IF pMensaje > '' THEN RETURN 'ADM-ERROR'.

/*     /* 29/05/2026: Solo debe funcionar si se vende desde LIMA o CALLAO */                           */
/*     DEF BUFFER bGn-Divi FOR Gn-Divi.                                                                */
/*     FIND bGn-Divi WHERE bGn-Divi.codcia = PEDIDO.codcia AND                                         */
/*         bGn-Divi.coddiv = PEDIDO.coddiv NO-LOCK NO-ERROR.                                           */
/*     IF AVAILABLE bGn-Divi AND LOOKUP(TRIM(bGn-Divi.Campo-Char[3]), '15,07') > 0 THEN DO:            */
/*         /* 2do. El ubigeo NO debe ser Lima o Callao */                                              */
/*         FIND gn-clied WHERE gn-clied.codcia = cl-codcia AND                                         */
/*             gn-clied.codcli = PEDIDO.codcli AND                                                     */
/*             gn-clied.sede = PEDIDO.sede NO-LOCK NO-ERROR.                                           */
/*         IF AVAILABLE gn-clied AND NOT (Gn-ClieD.CodDept = "15" OR Gn-ClieD.CodDept = "07") THEN DO: */
/*             /* 3ro. Debe tener registrado el transportista */                                       */
/*             FIND Ccbadocu WHERE Ccbadocu.codcia = s-codcia AND                                      */
/*                 Ccbadocu.coddiv = PEDIDO.coddiv AND                                                 */
/*                 Ccbadocu.coddoc = PEDIDO.coddoc AND                                                 */
/*                 Ccbadocu.nrodoc = PEDIDO.nroped NO-LOCK NO-ERROR.                                   */
/*             IF NOT AVAILABLE Ccbadocu OR TRUE <> (CcbADocu.Libre_C[9] > '') THEN DO:                */
/*                 pMensaje = "Aún no ha sido registrada la AGENCIA DE TRANSPORTE".                    */
/*                 RETURN "ADM-ERROR".                                                                 */
/*             END.                                                                                    */
/*             IF TRUE <> (CcbADocu.Libre_C[20] > '') THEN DO:                                         */
/*                 pMensaje = "Aún no ha sido registrada la SEDE de la AGENCIA DE TRANSPORTE".         */
/*                 RETURN "ADM-ERROR".                                                                 */
/*             END.                                                                                    */
/*         END.                                                                                        */
/*     END.                                                                                            */
END.

/* ****************************************************************************** */
/* 
    Ic - 23Jun2020, para casos de pedido de 002 - CONTADO ANTICIPADO
    que aun no haya actualizado la BD
*/
/* ****************************************************************************** */
DEFINE VAR x-fmapago AS CHAR NO-UNDO.
DEFINE VAR x-boleta-deposito AS CHAR NO-UNDO.
DEFINE VAR x-retval AS CHAR NO-UNDO.  
DEFINE VAR pNroOD AS CHAR NO-UNDO.

x-fmapago = PEDIDO.fmapgo.
x-boleta-deposito = PEDIDO.libre_c03.
IF x-fmapago = '002' THEN DO:
    IF TRUE <> (x-boleta-deposito > "") THEN DO:
        pMensaje = "Imposible realizar despacho" + CHR(10) +
            "para CONTADO ANTICIPADO, debe asignar la BD APROBADO".
        RETURN 'ADM-ERROR'.
    END.
    /* Verificamos que la condicion de venta este asignado a esa division  */
    DEFINE VAR hVentasLibrary AS HANDLE NO-UNDO.
    RUN vtagn/ventas-library.p  PERSISTENT SET hVentasLibrary.
    RUN VTA_cond-vta_division IN hVentasLibrary (INPUT x-fmapago, 
                                                 INPUT PEDIDO.coddiv, 
                                                 OUTPUT x-retval).
    DELETE PROCEDURE hVentasLibrary.
    IF x-retval = 'NO' THEN DO:
        pMensaje =  "La condicion de venta (" + x-fmapago + ")" + CHR(10) +
                "No esta asignado a la división de venta (" + PEDIDO.coddiv + ")".
        RETURN "ADM-ERROR".
    END.
END.
/* ****************************************************************************** */
DEF VAR iCuenta AS INTE NO-UNDO.
DEF VAR pDT AS LOG NO-UNDO.
DEF VAR pAlmacenDT AS CHAR NO-UNDO.
DEF VAR pCrossDocking AS LOG NO-UNDO.
DEF VAR pAlmacenXD AS CHAR NO-UNDO.
DEF VAR k AS INT NO-UNDO.

DEF BUFFER B-DESTINO FOR Almacen.
DEF BUFFER B-ORIGEN  FOR Almacen.

/* ****************************************************************************** */
/* RHC 23/07/20196 Ciclo de Dejado en Tienda */
/* ****************************************************************************** */
IF pProcesoBatch = NO THEN DO:
    RUN logis/d-dejado-en-tienda (OUTPUT pDT, OUTPUT pAlmacenDT).
    IF pAlmacenDT = "ERROR" THEN RETURN 'OK'.
END.
IF pDT = YES THEN DO k = 1 TO NUM-ENTRIES(PEDIDO.CodAlm):
    FIND FIRST B-DESTINO WHERE B-DESTINO.codcia = s-codcia
        AND B-DESTINO.codalm = ENTRY(k, PEDIDO.CodAlm)
        NO-LOCK.
    FIND FIRST B-ORIGEN WHERE B-ORIGEN.codcia = s-codcia
        AND B-ORIGEN.codalm = pAlmacenDT
        NO-LOCK.
    IF B-DESTINO.CodDiv = B-ORIGEN.CodDiv THEN DO:
        pMensaje = 'NO se puede generar para el mismo CD'.
        RETURN 'ADM-ERROR'.
    END.
END.
/* ****************************************************************************** */
/* ****************************************************************************** */
IF pProcesoBatch = NO THEN DO:
    MESSAGE 'El Pedido está listo para ser despachado' SKIP 'Continuamos?'
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN 'ADM-ERROR'.
    /* Ic - 30Set2024, reunion Carla Tenazoa, pedido desde Riqra no considerar transportista */
    /* Revisar datos del Transportista */
/*     FIND FIRST Ccbadocu WHERE Ccbadocu.codcia = PEDIDO.codcia                         */
/*         AND Ccbadocu.coddiv = PEDIDO.coddiv                                           */
/*         AND Ccbadocu.coddoc = PEDIDO.coddoc                                           */
/*         AND Ccbadocu.nrodoc = PEDIDO.nroped                                           */
/*         NO-LOCK NO-ERROR.                                                             */
/*     IF NOT AVAILABLE Ccbadocu THEN DO:                                                */
/*         MESSAGE 'Aún NO ha ingresado los datos del transportista' SKIP 'Continuamos?' */
/*             VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE rpta-1 AS LOG.            */
/*         IF rpta-1 = NO THEN RETURN 'ADM-ERROR'.                                       */
/*     END.                                                                              */
END.

DEF VAR pFchEnt AS DATE NO-UNDO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Bloqueamos PEDIDO */
    {lib/lock-genericov3.i ~
        &Tabla="PEDIDO" ~
        &Condicion="ROWID(PEDIDO) = pRowid" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
    IF PEDIDO.flgest <> "G" THEN DO:
        pMensaje = 'El Pedido ya fue aprobado por:' + CHR(10) +
            'Usuario: ' + PEDIDO.UsrAprobacion + CHR(10) +
            'Fecha: ' + STRING(PEDIDO.FchAprobacion) + CHR(10) + CHR(10) +
            'Proceso abortado'.
        UNDO RLOOP, RETURN 'ADM-ERROR'.  
    END.
    /* ****************************************************************************** */
    /* Reactualizamos la Fecha de Entrega                                             */
    /* ****************************************************************************** */
    pFchEnt = PEDIDO.FchEnt.      /* OJO */
    IF PEDIDO.Ubigeo[2] <> "@PV" THEN DO:
        pFchEnt = PEDIDO.Libre_f02.   /* Pactada con el cliente */
        /* LA RUTINA VA A DECIDIR SI EL CALCULO ES POR UBIGEO O POR GPS */
        RUN logis/p-fecha-de-entrega (PEDIDO.CodDoc,              /* Documento actual */
                                      PEDIDO.NroPed,
                                      INPUT-OUTPUT pFchEnt,
                                      OUTPUT pMensaje).
        IF pMensaje > '' THEN UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        PEDIDO.FchEnt = pFchEnt.

    /* ****************************************************************************** */
    RUN CCB_Verifica_Cliente (OUTPUT pMensaje, OUTPUT pAviso).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    /* RHC 19/02/2018 Cross Docking */
    ASSIGN                  
        PEDIDO.AlmacenDT      = pAlmacenDT
        PEDIDO.DT             = pDT
        PEDIDO.CrossDocking   = pCrossDocking
        PEDIDO.AlmacenXD      = pAlmacenXD.    /* Almacén que despacha al cliente */
    /* ********************************************************************************************** */
    /* CONTROL DE SEDE Y UBIGEO: POR CLIENTE */
    /* ********************************************************************************************** */
    IF PEDIDO.DT = YES THEN DO:
        ASSIGN
            PEDIDO.Ubigeo[1] = PEDIDO.AlmacenDT
            PEDIDO.Ubigeo[2] = "@ALM"
            PEDIDO.Ubigeo[3] = PEDIDO.AlmacenDT.
    END.
    
    /* ********************************************************************************************** */
    /* *********************************************************************** */
    /* APROBACION DEL PEDIDO */
    /* *********************************************************************** */
    IF PEDIDO.FlgEst = "P" THEN DO:
       /* TRACKING */
        FIND Almacen OF PEDIDO NO-LOCK.
        RUN vtagn/pTracking-04 (s-CodCia,
                          Almacen.CodDiv,
                          PEDIDO.CodDoc,
                          PEDIDO.NroPed,
                          s-User-Id,
                          'ANP',
                          'P',
                          DATETIME(TODAY, MTIME),
                          DATETIME(TODAY, MTIME),
                          PEDIDO.coddoc,
                          PEDIDO.nroped,
                          PEDIDO.coddoc,
                          PEDIDO.nroped).
    END.
    IF PEDIDO.FlgEst = "X" THEN DO:
        /* ******************************* */
        /* RHC 17/08/2018 TRACKING DE CONTROL */
        /* ******************************* */
        RUN vtagn/pTracking-04 (s-CodCia,
                          s-CodDiv,
                          PEDIDO.CodDoc,
                          PEDIDO.NroPed,
                          s-User-Id,
                          'PANPX',
                          'P',
                          DATETIME(TODAY, MTIME),
                          DATETIME(TODAY, MTIME),
                          PEDIDO.CodDoc,
                          PEDIDO.NroPed,
                          PEDIDO.CodRef,
                          PEDIDO.NroRef).
    END.

    /* ********************************************************************************************** */
    /* SI NO HA SIDO APROBADO ENTONCES NO GENERA ORDEN DE DESPACHO */
    /* ********************************************************************************************** */
    IF PEDIDO.FlgEst <> "P" THEN LEAVE.

    /* ********************************************************************************************** */
    /* DEPENDIENDO DE SI ES CROSSDOCKING O NO GENERA UNA O/D O UNA OTR */
    /* OJO: En esta rutina SIEMPRE PEDIDO.CrossDocking = NO */
    /* ********************************************************************************************** */
    CASE PEDIDO.CrossDocking:
        WHEN NO THEN DO:
            RUN OD_Generacion_Rutina_Master (NO,
                                             OUTPUT pNroOD,
                                             OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
            pAviso = "Orden de Despacho = " + pNroOD.
        END.
        WHEN YES THEN DO:
            /* Por aquí NUNCA pasa (¿?) */
            RUN OTR_Generacion_por_CrossDocking (NO,
                                             OUTPUT pNroOD,
                                             OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
            pAviso = "Orden de Transferencia = " + pNroOD.
        END.
    END CASE.
END.
RETURN 'OK'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Verifica_Agencia_Transporte) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica_Agencia_Transporte Procedure 
PROCEDURE Verifica_Agencia_Transporte PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF BUFFER bAlmacen FOR Almacen.
DEF BUFFER bOrigen FOR gn-divi.
DEF BUFFER bDespacho FOR gn-divi.
DEF BUFFER bGn-clied FOR Gn-clied.
DEF BUFFER bCcbadocu FOR Ccbadocu.

pMensaje = "".

/* División donde se origina la venta */
FIND bOrigen WHERE bOrigen.codcia = s-codcia
    AND bOrigen.coddiv = PEDIDO.CodDiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE bOrigen THEN DO:
    pMensaje = "NO está registrada la división del origen de la venta".
    RETURN.
END.

/* División del almacén de despacho */
FIND bAlmacen WHERE bAlmacen.codcia = s-codcia AND 
    bAlmacen.codalm = PEDIDO.CodAlm NO-LOCK NO-ERROR.
IF NOT AVAILABLE bAlmacen THEN DO:
    pMensaje = "NO está registrada el almacén de despacho".
    RETURN.
END.
FIND bDespacho WHERE bDespacho.codcia = s-codcia
    AND bDespacho.coddiv = bAlmacen.coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE bDespacho THEN DO:
    pMensaje = "NO está registrada la división de despacho en el maestro de divisiones".
    RETURN.
END.

/* Sede destino */
FIND bGn-clied WHERE bGn-clied.codcia = cl-codcia
    AND bGn-clied.codcli = PEDIDO.codcli
    AND bGn-clied.sede = PEDIDO.sede
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE bGn-clied THEN DO:
    pMensaje = "NO está registrada la sede del cliente".
    RETURN.
END.

DEF VAR lPreguntar AS LOG INIT NO NO-UNDO.

/* Caso "especial" FERIAS */
IF bOrigen.CanalVenta = "FER" THEN DO:
    /* Lima Metropolitana y Callao */
    IF (bOrigen.Campo-char[3] = "15" AND bOrigen.Campo-char[4] = "01")
        OR bOrigen.Campo-char[3] = "07" THEN RETURN.    /* NO hay control */
    /* Preguntamos */
    lPreguntar = YES.
END.
ELSE DO:
    /* Caso "normal" */
    /* Lima Metropolitana */
    IF (bDespacho.Campo-char[3] = "15" AND bDespacho.Campo-char[4] = "01")
        OR bDespacho.Campo-char[3] = "07" THEN DO:
        IF (bGn-ClieD.CodDept = "15" AND Gn-ClieD.CodProv = "01") 
            OR bGn-ClieD.CodDept = "07" THEN RETURN.     /* NO hay control */
    END.

    /* Arequipa */
    IF bDespacho.Campo-char[3] = "04" THEN DO:
        IF bGn-ClieD.CodDept = "04" THEN RETURN.     /* NO hay control */
    END.

    /* Chiclayo */
    IF bDespacho.Campo-char[3] = "14" THEN DO:
        IF (bGn-ClieD.CodDept = "14" OR bGn-ClieD.CodDept = "13") THEN RETURN.     /* NO hay control */
    END.

    /* Trujillo */
    IF bDespacho.Campo-char[3] = "13" THEN DO:
        IF bGn-ClieD.CodDept = "13" THEN RETURN.     /* NO hay control */
    END.
END.

/* Buscamos registro de la agencia de transporte */
FIND bCcbadocu WHERE bCcbadocu.codcia = s-codcia AND
    bCcbadocu.coddiv = PEDIDO.coddiv AND
    bCcbadocu.coddoc = PEDIDO.coddoc AND
    bCcbadocu.nrodoc = PEDIDO.nroped NO-LOCK NO-ERROR.
IF AVAILABLE bCcbadocu AND bCcbADocu.Libre_C[9] > '' THEN DO:
    IF TRUE <> (bCcbADocu.Libre_C[20] > '') THEN DO:
        pMensaje = "Aún no ha sido registrada la SEDE de la AGENCIA DE TRANSPORTE".
        RETURN.
    END.
END.

IF NOT AVAILABLE bCcbadocu OR TRUE <> (bCcbADocu.Libre_C[9] > '') THEN DO:
    IF lPreguntar = YES THEN DO:
        MESSAGE 'NO se ha registrado la AGENCIA DE TRANSPORTE' SKIP
            'Continuamos con la generación de la ORDEN DE DESPACHO?'
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta1 AS LOG.
        IF rpta1 = NO THEN DO:
            pMensaje = "Aún no ha sido registrada la AGENCIA DE TRANSPORTE".
            RETURN.
        END.
    END.
    ELSE DO:
        pMensaje = "Aún no ha sido registrada la AGENCIA DE TRANSPORTE".
        RETURN.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-VTA_Margen_de_Utilidad) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VTA_Margen_de_Utilidad Procedure 
PROCEDURE VTA_Margen_de_Utilidad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR dDscto AS DEC.
DEF VAR f-DtoMax AS DEC.
DEF VAR s-Tipo AS CHAR.
DEF VAR s-Nivel AS CHAR.

DEF BUFFER COTIZACION FOR Faccpedi.
DEF BUFFER B-DPEDI FOR Facdpedi.

/* Buscamos la cotizacion de origen */
FIND FIRST COTIZACION WHERE COTIZACION.CodCia = PEDIDO.CodCia 
    AND COTIZACION.CodDiv = PEDIDO.CodDiv
    AND COTIZACION.CodDoc = PEDIDO.CodRef
    AND COTIZACION.NroPed = PEDIDO.NroRef   
    NO-LOCK NO-ERROR.
IF AVAILABLE COTIZACION THEN DO:
    FIND FIRST FacUsers WHERE FacUsers.CodCia = S-CODCIA 
        AND  FacUsers.Usuario = COTIZACION.UsrDscto
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacUsers THEN DO:
        s-Nivel = SUBSTRING(FacUsers.Niveles,1,2).
        FOR EACH B-DPEDI OF COTIZACION NO-LOCK, 
            FIRST Facdpedi OF PEDIDO NO-LOCK WHERE Facdpedi.codmat = B-DPEDI.codmat:
            /*Descuentos Permitidos*/
            /* 22/02/2023 Esta tabla solo le da mantenimento S00*/
            FIND gn-clieds WHERE gn-clieds.CodCia = cl-CodCia 
                AND gn-clieds.CodCli = COTIZACION.CodCli 
                AND ((gn-clieds.fecini = ? AND gn-clieds.fecfin = ?) OR
                     (gn-clieds.fecini = ? AND gn-clieds.fecfin >= TODAY) OR
                     (gn-clieds.fecini <= TODAY AND gn-clieds.fecfin = ?) OR
                     (gn-clieds.fecini <= TODAY AND gn-clieds.fecfin >= TODAY)) 
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clieds THEN DO:
                f-DtoMax = gn-clieds.dscto.
                IF DECIMAL(B-DPEDI.Por_DSCTOS[1]) > f-DtoMax THEN s-tipo = 'Si'.        
            END.
            ELSE DO:
                FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
                FIND Almtabla WHERE almtabla.Tabla =  "NA" 
                    AND almtabla.Codigo = s-nivel NO-LOCK NO-ERROR.
                CASE almtabla.Codigo:
                    WHEN "D1" THEN f-DtoMax = FacCfgGn.DtoMax.
                    WHEN "D2" THEN f-DtoMax = FacCfgGn.DtoDis.
                    WHEN "D3" THEN f-DtoMax = FacCfgGn.DtoMay.
                    WHEN "D4" THEN f-DtoMax = FacCfgGn.DtoPro.
                END CASE.
                IF DEC(B-DPEDI.Por_DSCTOS[1]) > f-DtoMax THEN s-tipo = 'Si'.
            END.
            /*Validando Margen*/        
            IF B-DPEDI.Libre_d01 <= 0 THEN s-tipo = 'Si'.
        END.
        IF s-Tipo = "Si" THEN DO:
            ASSIGN
                PEDIDO.Flgest = 'W'
                PEDIDO.Libre_c05 = "MARGENES DE UTILIDAD BAJOS".
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

