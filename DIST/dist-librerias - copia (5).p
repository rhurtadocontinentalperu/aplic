&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-CMOV FOR Almcmov.
DEFINE BUFFER B-PHRC FOR DI-RutaC.
DEFINE BUFFER B-PHRD FOR DI-RutaD.
DEFINE BUFFER B-RutaC FOR DI-RutaC.
DEFINE BUFFER B-RutaD FOR DI-RutaD.
DEFINE BUFFER B-RutaG FOR Di-RutaG.
DEFINE BUFFER OD_Original FOR FacCPedi.
DEFINE TEMP-TABLE T-CREPO NO-UNDO LIKE almcrepo.
DEFINE TEMP-TABLE T-GUIAS NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE T-RutaD NO-UNDO LIKE DI-RutaD.



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

DEF SHARED VAR s-CodCia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR cl-codcia AS INT. 
DEF SHARED VAR pv-codcia AS INT. 

DEFINE SHARED VARIABLE pRCID AS INT.  

DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER x-Faccpedi FOR faccpedi.

DEFINE TEMP-TABLE T-OD-FAI-GR
    FIELD   T-COD_OD    AS  CHAR
    FIELD   T-NRO_OD    AS  CHAR
    FIELD   T-FAI   AS  CHAR
    FIELD   T-GR    AS  CHAR
    FIELD   T-SWT    AS  CHAR
    INDEX idx01 T-COD_OD T-NRO_OD T-GR. 

/* Sintaxis 
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN <libreria> PERSISTENT SET hProc.
RUN <libreria>.rutina_internaIN hProc (input  buffer tt-excel:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .
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
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: B-CMOV B "?" ? INTEGRAL Almcmov
      TABLE: B-PHRC B "?" ? INTEGRAL DI-RutaC
      TABLE: B-PHRD B "?" ? INTEGRAL DI-RutaD
      TABLE: B-RutaC B "?" ? INTEGRAL DI-RutaC
      TABLE: B-RutaD B "?" ? INTEGRAL DI-RutaD
      TABLE: B-RutaG B "?" ? INTEGRAL Di-RutaG
      TABLE: OD_Original B "?" ? INTEGRAL FacCPedi
      TABLE: T-CREPO T "?" NO-UNDO INTEGRAL almcrepo
      TABLE: T-GUIAS T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: T-RutaD T "?" NO-UNDO INTEGRAL DI-RutaD
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 19.58
         WIDTH              = 65.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Close-HR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Close-HR Procedure 
PROCEDURE Close-HR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.

FIND Di-RutaC WHERE ROWID(Di-RutaC) = pRowid NO-LOCK.
/* Verificamos que venga de una PHR */
IF ENTRY(1, DI-RutaC.Libre_c03) <> "PHR" THEN RETURN 'OK'.

DEF BUFFER B-PHRC FOR Di-RutaC.
DEF BUFFER B-PHRD FOR Di-RutaD.
PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="B-PHRC" ~
        &Condicion="B-PHRC.codcia = DI-RutaC.codcia
        AND B-PHRC.coddiv = DI-RutaC.coddiv
        AND B-PHRC.coddoc = ENTRY(1, DI-RutaC.libre_c03)
        AND B-PHRC.nrodoc = ENTRY(2, DI-RutaC.libre_c03)" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        }
    FOR EACH B-PHRD OF B-PHRC EXCLUSIVE-LOCK WHERE B-PHRD.FlgEst <> "A"
        ON ERROR UNDO, THROW:
        ASSIGN B-PHRD.FlgEst = "C".     /* Cerrado */
    END.
END.
IF AVAILABLE(B-PHRC) THEN RELEASE B-PHRC.
IF AVAILABLE(B-PHRD) THEN RELEASE B-PHRD.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Extorna-PHR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorna-PHR Procedure 
PROCEDURE Extorna-PHR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT  PARAMETER pRowid   AS ROWID.
DEF INPUT  PARAMETER pGlosa   AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

pMensaje = ''.

FIND Di-RutaC WHERE ROWID(Di-RutaC) = pRowid NO-LOCK.
IF NOT Di-RutaC.Libre_c03 BEGINS 'PHR' THEN RETURN 'OK'.

DEF BUFFER B-RUTAC FOR Di-RutaC.
DEF BUFFER B-RUTAB FOR DI-RutaD.

IF NOT CAN-FIND(FIRST B-RUTAC WHERE  B-RUTAC.codcia = Di-RutaC.CodCia AND
                B-RUTAC.coddiv = Di-RutaC.coddiv AND     
                B-RUTAC.coddoc = "PHR" AND 
                B-RUTAC.CodCob = DI-RutaC.NroDoc
                NO-LOCK)
    THEN RETURN 'OK'.
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH B-RUTAC WHERE B-RUTAC.codcia = Di-RutaC.CodCia AND
        B-RUTAC.coddiv = Di-RutaC.coddiv AND     
        B-RUTAC.coddoc = "PHR" AND 
        B-RUTAC.CodCob = DI-RutaC.NroDoc    /* OJO */
        EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
        ASSIGN
            B-RUTAC.FlgEst = "PF".
        /* Información Adicional */
        ASSIGN
            B-RutaC.HorSal      = Di-RutaC.HorSal 
            B-RutaC.FchSal      = Di-RutaC.FchSal 
            B-RutaC.KmtIni      = Di-RutaC.KmtIni 
            B-RutaC.CodVeh      = Di-RutaC.CodVeh
            B-RutaC.Libre_c01   = Di-RutaC.Libre_c01 
            B-RutaC.TpoTra      = Di-RutaC.TpoTra 
            B-RutaC.Nomtra      = Di-RutaC.Nomtra 
            B-RutaC.CodPro      = Di-RutaC.CodPro 
            B-RutaC.Tpotra      = Di-RutaC.Tpotra
            B-RutaC.ayudante-1  = Di-RutaC.ayudante-1 
            B-RutaC.ayudante-2  = Di-RutaC.ayudante-2 
            B-RutaC.responsable = Di-RutaC.responsable 
            B-RutaC.DesRut      = Di-RutaC.DesRut 
            B-RutaC.Libre_c04   = pGlosa    /* Glosa de anulación */
            .
        FOR EACH B-RUTAD OF B-RUTAC EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
            B-RUTAD.FlgEst = "P".   /* Status Original */
        END.
    END.
END.
RELEASE B-RUTAC.
RELEASE B-RUTAD.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Extorna-PHR-Multiple) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorna-PHR-Multiple Procedure 
PROCEDURE Extorna-PHR-Multiple :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT  PARAMETER pRowid   AS ROWID.
DEF INPUT  PARAMETER pGlosa   AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

pMensaje = ''.

FIND Di-RutaC WHERE ROWID(Di-RutaC) = pRowid NO-LOCK.

DEF BUFFER B-RUTAC FOR Di-RutaC.
DEF BUFFER B-RUTAB FOR DI-RutaD.
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH B-RUTAC WHERE B-RUTAC.codcia = Di-RutaC.CodCia AND
        B-RUTAC.coddiv = Di-RutaC.coddiv AND     
        B-RUTAC.coddoc = "PHR" AND 
        B-RUTAC.codref = Di-RutaC.coddoc AND
        B-RUTAC.nroref = Di-RutaC.nrodoc
        EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
        ASSIGN
            B-RUTAC.FlgEst = "PF".
        /* Información Adicional */
        ASSIGN
            B-RutaC.HorSal      = Di-RutaC.HorSal 
            B-RutaC.FchSal      = Di-RutaC.FchSal 
            B-RutaC.KmtIni      = Di-RutaC.KmtIni 
            B-RutaC.CodVeh      = Di-RutaC.CodVeh
            B-RutaC.Libre_c01   = Di-RutaC.Libre_c01 
            B-RutaC.TpoTra      = Di-RutaC.TpoTra 
            B-RutaC.Nomtra      = Di-RutaC.Nomtra 
            B-RutaC.CodPro      = Di-RutaC.CodPro 
            B-RutaC.Tpotra      = Di-RutaC.Tpotra
            B-RutaC.ayudante-1  = Di-RutaC.ayudante-1 
            B-RutaC.ayudante-2  = Di-RutaC.ayudante-2 
            B-RutaC.responsable = Di-RutaC.responsable 
            B-RutaC.DesRut      = Di-RutaC.DesRut 
            B-RutaC.Libre_c04   = pGlosa    /* Glosa de anulación */
            .
        FOR EACH B-RUTAD OF B-RUTAC EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
            B-RUTAD.FlgEst = "P".   /* Status Original */
        END.
    END.
END.
RELEASE B-RUTAC.
RELEASE B-RUTAD.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HR-Pendiente) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HR-Pendiente Procedure 
PROCEDURE HR-Pendiente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pDias AS INT.
DEF INPUT PARAMETER pMensaje AS LOG.

DEF BUFFER B-RutaC FOR Di-RutaC.

FIND FIRST B-RutaC WHERE B-RutaC.codcia = s-codcia AND
    B-RutaC.coddiv = pCodDiv AND 
    B-RutaC.coddoc = 'H/R' AND 
    B-RutaC.flgest BEGINS 'P' AND 
    B-RutaC.fchdoc < ADD-INTERVAL(TODAY, (-1 * pDias), 'days') NO-LOCK NO-ERROR.
IF AVAILABLE B-RutaC THEN DO:
    IF pMensaje = YES THEN DO:
        MESSAGE 'H/R' B-RutaC.NroDoc 'PENDIENTE de cerrar hace más de' pDias 'días'
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HR_Cierre-Dejado-en-Tienda) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HR_Cierre-Dejado-en-Tienda Procedure 
PROCEDURE HR_Cierre-Dejado-en-Tienda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Actualiza todas la G/R relacionadas on la O/D para esa H/R
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pFlgEst AS CHAR.    /* "T" */
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pMotivo AS CHAR.
DEF INPUT PARAMETER pRowid AS ROWID.

FIND B-RutaD WHERE ROWID(B-RutaD) = pRowid NO-LOCK NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN RETURN 'ADM-ERROR'.
FIND FIRST B-RutaC OF B-RutaD NO-LOCK.

FIND FIRST B-CDOCU WHERE B-CDOCU.codcia = B-RutaD.codcia AND
    B-CDOCU.coddoc = B-RutaD.codref AND
    B-CDOCU.nrodoc = B-RutaD.nroref
    NO-LOCK NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN RETURN 'ADM-ERROR'.
/* Orden de Despacho */
DEF VAR x-CodDoc AS CHAR NO-UNDO.
DEF VAR x-NroDoc AS CHAR NO-UNDO.
ASSIGN
    x-CodDoc = B-CDOCU.Libre_c01       /* O/D */
    x-NroDoc = B-CDOCU.Libre_c02.

/* TODAS A DEJADO EN TIENDA */
DEF VAR x-Rowid AS ROWID NO-UNDO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    REPEAT:
        FIND FIRST B-RutaD OF B-RutaC WHERE B-RutaD.flgest <> pFlgEst 
            AND CAN-FIND(FIRST B-CDOCU WHERE B-CDOCU.codcia = B-RutaD.codcia AND
                         B-CDOCU.coddoc = B-RutaD.codref AND
                         B-CDOCU.nrodoc = B-RutaD.nroref AND
                         B-CDOCU.libre_c01 = x-CodDoc AND
                         B-CDOCU.libre_c02 = x-NroDoc NO-LOCK)
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-RutaD THEN LEAVE.
        x-Rowid = ROWID(B-RutaD).
        {lib/lock-genericov3.i ~
            &Tabla="B-RUTAD" ~
            &Condicion="ROWID(B-RUTAD) = x-Rowid" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
            &Accion="RETRY" ~
            &Mensaje="YES" ~
            &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'"}
        ASSIGN
            B-RutaD.flgest    = pFlgEst     /* Dejado en Tienda */
            B-RutaD.FlgEstDet = pMotivo
            B-RutaD.Libre_c02 = pCodDiv.
    END.
END.
IF AVAILABLE(B-RUTAD) THEN RELEASE B-RUTAD.
RETURN 'OK'.

END PROCEDURE.

/*
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH B-RutaD OF B-RutaC EXCLUSIVE-LOCK,
        FIRST B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = B-RutaD.codcia AND
        B-CDOCU.coddoc = B-RutaD.codref AND
        B-CDOCU.nrodoc = B-RutaD.nroref AND
        B-CDOCU.libre_c01 = x-CodDoc AND
        B-CDOCU.libre_c02 = x-NroDoc
        ON ERROR UNDO, THROW:
        ASSIGN
            B-RutaD.flgest    = pFlgEst     /* Dejado en Tienda */
            B-RutaD.FlgEstDet = pMotivo
            B-RutaD.Libre_c02 = pCodDiv.
    END.
END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HR_Cierre-DT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HR_Cierre-DT Procedure 
PROCEDURE HR_Cierre-DT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Solo para G/R DT (Dejado en Tienda manualmente)
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pCodDiv AS CHAR.    /* División destino */
DEF INPUT PARAMETER pCodOD AS CHAR.     /* La Orden de Despacho */
DEF INPUT PARAMETER pNroOD AS CHAR.

DEF BUFFER B-CBULT FOR Ccbcbult.

FIND Di-RutaC WHERE ROWID(Di-RutaC) = pRowid NO-LOCK.

DEF VAR x-Guias AS INT NO-UNDO.        
DEF VAR x-Guias-2 AS INT NO-UNDO.
DEF VAR x-ImpTot AS DEC NO-UNDO.
DEF VAR x-Peso AS DEC NO-UNDO.
DEF VAR x-Volumen AS DEC NO-UNDO.

DEF VAR x-CodDiv AS CHAR NO-UNDO.   /* Divisón Final */
DEF VAR x-Motivo AS CHAR NO-UNDO.
DEF VAR x-CodHR  AS CHAR NO-UNDO.
DEF VAR x-NroHR  AS CHAR NO-UNDO.

EMPTY TEMP-TABLE T-GUIAS.   /* GUIAS DE REMISION A ANULAR */

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Un Proceso: En ambos casos las G/R relacionadas se ANULAN
        DEJADO EN TIENDA:
            Cambiar la O/D como si se hubiera despachado de esa tienda 
    */
    /* ********************************************************************************************** */
    /* POR ORDENES DE DESPACHO */
    /* ********************************************************************************************** */
    FOR EACH Di-RutaD OF Di-RutaC NO-LOCK WHERE Di-RutaD.codref = "G/R" AND
            Di-RutaD.flgest = "T" AND       /* Dejado en Tienda */
            Di-RutaD.flgestdet = "@DT" AND
            Di-RutaD.libre_c02 = pCodDiv,
        FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Di-RutaD.codcia
            AND Ccbcdocu.coddoc = Di-RutaD.codref   /* G/R */
            AND Ccbcdocu.nrodoc = Di-RutaD.nroref
            AND Ccbcdocu.Libre_c01 = pCodOD
            AND Ccbcdocu.Libre_c02 = pNroOD 
        BREAK BY Ccbcdocu.Libre_c02:      /* Quiebre por número de O/D */
        IF FIRST-OF(Ccbcdocu.Libre_c02) THEN DO:
            /* Limpiamos contador de guias por O/D */
            x-Guias = 0.
            x-ImpTot = 0.
            x-Peso = 0.
            x-Volumen = 0.
        END.
        x-Guias = x-Guias + 1.
        x-ImpTot = x-ImpTot + Ccbcdocu.ImpTot.
        FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
            x-Peso = x-Peso + (Almmmatg.PesMat * Ccbddocu.CanDes * Ccbddocu.Factor).
            x-Volumen = x-Volumen + (Almmmatg.Libre_d02 * Ccbddocu.CanDes * Ccbddocu.Factor / 1000000).
        END.
        /* ******************************************************************************************** */
        IF LAST-OF(Ccbcdocu.Libre_c02) THEN DO:
            /* Verificamos si TODAS la G/R han sido NO ENTREGADAS */
            x-Guias-2 = 0.
            FOR EACH B-RUTAD NO-LOCK WHERE B-RutaD.CodCia = Di-RutaC.CodCia AND
                B-RutaD.CodDiv = Di-RutaC.CodDiv AND
                B-RutaD.CodDoc = Di-RutaC.CodDoc AND 
                B-RutaD.NroDoc = Di-RutaC.NroDoc AND
                B-RUTAD.CodRef = "G/R",
                FIRST B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = B-RUTAD.codcia
                    AND B-CDOCU.coddoc = B-RUTAD.codref         /* G/R */
                    AND B-CDOCU.nrodoc = B-RUTAD.nroref
                    AND B-CDOCU.Libre_c01 = Ccbcdocu.libre_c01  /* O/D */
                    AND B-CDOCU.Libre_c02 = Ccbcdocu.libre_c02:
                x-Guias-2 = x-Guias-2 + 1.
            END.
            /* ******************************************************************************************** */
            /* TODAS HAN SIDO "NO ENTREGADAS" */
            /* RHC 29/05/18 Si se repite el ciclo chancamos la anterior */
            /* ******************************************************************************************** */
            IF x-Guias = x-Guias-2 THEN DO:
                /* ******************************************************************************************** */
                /* TIENDA: LA O/D Original migra a la tienda */
                /* ******************************************************************************************** */
                ASSIGN
                    x-CodDiv = Di-RutaD.Libre_c02   /* Tienda */
                    x-Motivo = DI-RutaD.FlgEstDet
                    x-CodHR  = DI-RutaC.CodDoc    /* H/R */
                    x-NroHR  = DI-RutaC.NroDoc.
                /* ******************************************************************************************** */
                /* Migramos la O/D a la nueva división */
                /* ******************************************************************************************** */
                FIND FIRST Almacen WHERE Almacen.codcia = s-codcia AND
                    Almacen.coddiv = x-CodDiv AND
                    Almacen.AlmPrincipal = YES AND
                    Almacen.Campo-c[9] <> "I" NO-LOCK NO-ERROR.
                IF NOT AVAILABLE Almacen THEN DO:
                    MESSAGE 'La división' x-CodDiv 'NO tiene un almacén principal definido'
                        VIEW-AS ALERT-BOX ERROR.
                    UNDO RLOOP, RETURN 'ADM-ERROR'.
                END.
                FIND FIRST OD_Original WHERE OD_Original.CodCia = s-codcia AND
                    OD_Original.CodDoc = Ccbcdocu.Libre_c01 AND 
                    OD_Original.NroPed = Ccbcdocu.Libre_c02
                    EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                IF NOT AVAILABLE OD_Original THEN DO:
                    MESSAGE Ccbcdocu.Libre_c01 Ccbcdocu.Libre_c02 'Bloqueado por otro usuario'
                        VIEW-AS ALERT-BOX ERROR.
                    UNDO RLOOP, RETURN 'ADM-ERROR'.
                END.
                ASSIGN
                    OD_Original.CodAlm = Almacen.codalm
                    OD_Original.DivDes = Almacen.coddiv.
                /* ******************************************************************************************** */
                /* RHC 16/09/2019 Cambio de destino y Valores por Defecto */
                /* ******************************************************************************************** */
                ASSIGN
                    OD_Original.AlmacenDT = ""
                    OD_Original.DT = NO.
                /* CONTROL DE SEDE Y UBIGEO: POR CLIENTE */
                ASSIGN
                      OD_Original.Ubigeo[1] = OD_Original.Sede
                      OD_Original.Ubigeo[2] = "@CL"
                      OD_Original.Ubigeo[3] = OD_Original.CodCli.
                FIND FIRST CcbADocu WHERE CcbADocu.CodCia = OD_Original.CodCia AND
                    CcbADocu.CodDiv = OD_Original.CodDiv AND
                    CcbADocu.CodDoc = OD_Original.CodDoc AND
                    CcbADocu.NroDoc = OD_Original.NroPed
                    NO-LOCK NO-ERROR.
                IF AVAILABLE CcbADocu AND CcbADocu.Libre_C[9] > '' THEN DO:  /* AGENCIA DE TRANSPORTE */
                    /* CONTROL DE SEDE Y UBIGEO: POR PROVEEDOR */
                    FIND gn-provd WHERE gn-provd.CodCia = pv-codcia AND 
                        gn-provd.CodPro = CcbADocu.Libre_C[9] AND 
                        gn-provd.Sede   = CcbADocu.Libre_C[20]
                        NO-LOCK.
                    FIND TabDistr WHERE TabDistr.CodDepto = gn-provd.CodDept 
                        AND TabDistr.CodProvi = gn-provd.CodProv 
                        AND TabDistr.CodDistr = gn-provd.CodDist
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE TabDistr THEN DO:
                        ASSIGN
                            OD_Original.Ubigeo[1] = gn-provd.Sede
                            OD_Original.Ubigeo[2] = "@PV"
                            OD_Original.Ubigeo[3] = gn-provd.CodPro.
                    END.
                END.
                ASSIGN
                    OD_Original.FlgEst = "P".    /* Regresa a EN PROCESO hasta definir su REPROGRAMACION */
                /* ******************************************************************************************** */
                /* MIGRAR BULTOS A LA TIENDA: Desdee al Almacén de donde se originó a la DEJADO EN TIENDA */
                /* ******************************************************************************************** */
                FOR EACH Ccbcbult NO-LOCK WHERE CcbCBult.CodCia = s-CodCia AND
                    CcbCBult.CodDiv = Ccbcdocu.CodDiv AND   /* Donde se originó la G/R */
                    CcbCBult.CodDoc = OD_Original.CodDoc AND
                    CcbCBult.NroDoc = OD_Original.NroPed:
                    CREATE B-CBULT.
                    BUFFER-COPY Ccbcbult TO B-CBULT ASSIGN B-CBULT.CodDiv = Almacen.coddiv NO-ERROR.
                    IF ERROR-STATUS:ERROR = NO THEN UNDO, NEXT.
                END.
                /* ******************************************************************************************** */
                /* CONTROL DE REPROGRAMACIONES */
                /* ******************************************************************************************** */
                FIND Almcdocu WHERE AlmCDocu.CodCia = Ccbcdocu.CodCia
                    AND AlmCDocu.CodLlave = x-CodDiv            /* OJO */
                    AND AlmCDocu.CodDoc = Ccbcdocu.Libre_c01    /* O/D */
                    AND AlmCDocu.NroDoc = Ccbcdocu.Libre_c02
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Almcdocu THEN DO:
                    FIND CURRENT Almcdocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                    IF ERROR-STATUS:ERROR = YES THEN DO:
                        MESSAGE 'Tabla Almcdocu en uso por otro usuario' VIEW-AS ALERT-BOX ERROR.
                        UNDO RLOOP, RETURN 'ADM-ERROR'.
                    END.
                END.
                ELSE CREATE Almcdocu.
                ASSIGN
                    AlmCDocu.CodCia = Ccbcdocu.CodCia
                    AlmCDocu.CodDoc = Ccbcdocu.Libre_c01    /* O/D */
                    AlmCDocu.NroDoc = Ccbcdocu.Libre_c02
                    AlmCDocu.CodLlave = x-CodDiv            /* OJO */
                    AlmCDocu.FchDoc = TODAY
                    AlmCDocu.FchCreacion = TODAY
                    AlmCDocu.FlgEst = "P"       /* "P": por reprogramar, "C": reprogramado, "A": no se reprograma */
                    AlmCDocu.UsrCreacion = s-user-id
                    AlmCDocu.Libre_c01 = x-CodHR            /* H/R */
                    AlmCDocu.Libre_c02 = x-NroHR
                    AlmCDocu.Libre_c03 = x-Motivo           /* Motivo */
                    AlmCDocu.Libre_d01 = x-ImpTot
                    AlmCDocu.Libre_d02 = x-Peso
                    AlmCDocu.Libre_d03 = x-Volumen
                    NO-ERROR.
                IF ERROR-STATUS:ERROR = YES THEN DO:
                    MESSAGE 'Tabla Almcdocu error en la llave' VIEW-AS ALERT-BOX ERROR.
                    UNDO RLOOP, RETURN 'ADM-ERROR'.
                END.
                /* ********************************************************************************************** */
                /* RHC 08/03/2019 Actualizamos CONTROL de PHR */
                /* ********************************************************************************************** */
/*                 IF ENTRY(1, DI-RutaC.Libre_c03) = "PHR" THEN DO:                                           */
/*                     FIND B-PHRD WHERE B-PHRD.codcia = DI-RutaC.codcia                                      */
/*                         AND B-PHRD.coddiv = DI-RutaC.coddiv                                                */
/*                         AND B-PHRD.coddoc = ENTRY(1, DI-RutaC.libre_c03)                                   */
/*                         AND B-PHRD.nrodoc = ENTRY(2, DI-RutaC.libre_c03)                                   */
/*                         AND B-PHRD.CodRef = Ccbcdocu.Libre_c01  /* O/D */                                  */
/*                         AND B-PHRD.NroRef = Ccbcdocu.Libre_c02 EXCLUSIVE-LOCK NO-ERROR NO-WAIT.            */
/*                     IF ERROR-STATUS:ERROR = YES THEN DO:                                                   */
/*                         MESSAGE 'Registro de O/D en uso por otro usuario' VIEW-AS ALERT-BOX ERROR.         */
/*                         UNDO RLOOP, RETURN 'ADM-ERROR'.                                                    */
/*                     END.                                                                                   */
/*                     ASSIGN                                                                                 */
/*                         B-PHRD.FlgEst = "P".    /* Regresa a EN PROCESO hasta definir su REPROGRAMACION */ */
/*                 END.                                                                                       */
                /* ********************************************************************************************** */
                /* GUIAS DE REMISION A ANULAR */
                /* ********************************************************************************************** */
                FOR EACH B-RUTAD OF Di-RutaC NO-LOCK WHERE B-RUTAD.codref = "G/R" AND
                        (B-RUTAD.flgest = "T" AND B-RUTAD.FlgEstDet = "@DT") ,   /* Dejado en Tienda */
                    FIRST B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = B-RUTAD.codcia
                        AND B-CDOCU.coddoc = B-RUTAD.codref   /* G/R */
                        AND B-CDOCU.nrodoc = B-RUTAD.nroref
                        AND B-CDOCU.Libre_c01 = Ccbcdocu.libre_c01  /* O/D */
                        AND B-CDOCU.Libre_c02 = Ccbcdocu.libre_c02:
                    CREATE T-GUIAS.
                    BUFFER-COPY B-CDOCU TO T-GUIAS.

                    /* Ic 17Feb2020, ESTADOS para No entregado/reprogramado y Dejado en tienda */
                    IF (B-RUTAD.flgest = "T" AND B-RUTAD.FlgEstDet <> "@DT") THEN ASSIGN T-GUIAS.Libre_c01 = "DT".

                END.
            END.
        END.
    END.
    
    /* ********************************************************************************************** */
    /* ANULA G/R POR VENTAS  */
    /* ********************************************************************************************** */
    FOR EACH T-GUIAS NO-LOCK, FIRST Ccbcdocu OF T-GUIAS EXCLUSIVE-LOCK ON ERROR UNDO, THROW:

        ASSIGN
            CcbCDocu.FlgEst = T-GUIAS.Libre_c01.
        /*
        ASSIGN
            CcbCDocu.FlgEst = "A"
            CcbCDocu.UsuAnu = s-user-id
            CcbCDocu.FchAnu = TODAY.
        */
    END.
    
END.
IF AVAILABLE(Almcdocu) THEN RELEASE Almcdocu.
IF AVAILABLE(B-PHRD)   THEN RELEASE B-PHRD.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HR_Cierre-OTR-deja-en-tienda) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HR_Cierre-OTR-deja-en-tienda Procedure 
PROCEDURE HR_Cierre-OTR-deja-en-tienda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HR_Cierre-PHR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HR_Cierre-PHR Procedure 
PROCEDURE HR_Cierre-PHR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.

FIND B-RutaC WHERE ROWID(B-RutaC) = pRowid NO-LOCK.
/* Verificamos que venga de una PHR */
IF ENTRY(1, B-RutaC.Libre_c03) <> "PHR" THEN RETURN 'OK'.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i 
        &Tabla="B-PHRC" ~
        &Condicion="B-PHRC.codcia = B-RutaC.codcia
        AND B-PHRC.coddiv = B-RutaC.coddiv
        AND B-PHRC.coddoc = ENTRY(1, B-RutaC.libre_c03)
        AND B-PHRC.nrodoc = ENTRY(2, B-RutaC.libre_c03)" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~                             
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        }
    /**/
    IF AVAILABLE B-PHRC THEN DO:
        FOR EACH B-PHRD OF B-PHRC EXCLUSIVE-LOCK WHERE B-PHRD.FlgEst <> "A"
            ON ERROR UNDO, THROW:
            ASSIGN B-PHRD.FlgEst = "C".     /* Cerrado */
        END.
    END.
END.
IF AVAILABLE(B-PHRC) THEN RELEASE B-PHRC.
IF AVAILABLE(B-PHRD) THEN RELEASE B-PHRD.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HR_Cierre-PHR-Multiple) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HR_Cierre-PHR-Multiple Procedure 
PROCEDURE HR_Cierre-PHR-Multiple :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.

FIND B-RutaC WHERE ROWID(B-RutaC) = pRowid NO-LOCK.

/* Verificamos que venga de una PHR */
/*IF ENTRY(1, B-RutaC.Libre_c03) <> "PHR" THEN RETURN 'OK'.*/

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH B-PHRC NO-LOCK WHERE B-PHRC.codcia = B-RutaC.codcia
        AND B-PHRC.coddiv = B-RutaC.coddiv
        AND B-PHRC.coddoc = "PHR"
        AND B-PHRC.codref = B-RutaC.CodDoc
        AND B-PHRC.nroref = B-RutaC.NroDoc:
        RLOOP:
        REPEAT:
            IF NOT CAN-FIND(FIRST B-PHRD WHERE B-PHRD.CodCia = B-PHRC.CodCia AND
                            B-PHRD.CodDiv = B-PHRC.CodDiv AND
                            B-PHRD.CodDoc = B-PHRC.CodDoc AND
                            B-PHRD.NroDoc = B-PHRC.NroDoc AND
                            LOOKUP(B-PHRD.FlgEst, 'A,C') = 0 )
                THEN LEAVE RLOOP.
            {lib/lock-genericov3.i ~
                &Tabla="B-PHRD" ~
                &Alcance="FIRST" ~
                &Condicion="B-PHRD.CodCia = B-PHRC.CodCia AND ~
                B-PHRD.CodDiv = B-PHRC.CodDiv AND ~
                B-PHRD.CodDoc = B-PHRC.CodDoc AND ~
                B-PHRD.NroDoc = B-PHRC.NroDoc AND ~
                LOOKUP(B-PHRD.FlgEst, 'A,C') = 0" ~
                &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
                &Accion="RETRY" ~
                &Mensaje="YES" ~
                &TipoError="UNDO PRINCIPAL, RETURN 'ADM-ERROR'" ~
                }
                ASSIGN 
                    B-PHRD.FlgEst = "C".     /* Cerrado */
        END.
    END.
END.
IF AVAILABLE(B-PHRC) THEN RELEASE B-PHRC.
IF AVAILABLE(B-PHRD) THEN RELEASE B-PHRD.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HR_Cierre-Reprog-Multi-OD) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HR_Cierre-Reprog-Multi-OD Procedure 
PROCEDURE HR_Cierre-Reprog-Multi-OD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.

FIND Di-RutaC WHERE ROWID(Di-RutaC) = pRowid NO-LOCK.

DEF VAR x-Guias AS INT NO-UNDO.        
DEF VAR x-Guias-2 AS INT NO-UNDO.
DEF VAR x-ImpTot AS DEC NO-UNDO.
DEF VAR x-Peso AS DEC NO-UNDO.
DEF VAR x-Volumen AS DEC NO-UNDO.

DEF VAR x-CodDiv AS CHAR NO-UNDO.   /* Divisón Final */
DEF VAR x-Motivo AS CHAR NO-UNDO.
DEF VAR x-CodHR  AS CHAR NO-UNDO.
DEF VAR x-NroHR  AS CHAR NO-UNDO.

EMPTY TEMP-TABLE T-GUIAS.   /* GUIAS DE REMISION A ANULAR */

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Dos Procesos: En ambos casos las G/R relacionadas se ANULAN
        NO ENTREGADO
        DEJADO EN TIENDA:
            Cambiar la O/D como si se hubiera despachado de esa tienda 
    */
    /* ********************************************************************************************** */
    /* POR ORDENES DE DESPACHO */
    /* ********************************************************************************************** */
    FOR EACH Di-RutaD OF Di-RutaC NO-LOCK WHERE Di-RutaD.codref = "G/R" AND
        /* NO entregado y Reprogramados */
        ( (Di-RutaD.flgest = "N" AND Di-RutaD.Libre_c02 = "R") OR
        /* Dejado en Tienda */
        (Di-RutaD.flgest = "T" AND Di-RutaD.FlgEstDet <> "@DT") ),
        FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Di-RutaD.codcia
            AND Ccbcdocu.coddoc = Di-RutaD.codref   /* G/R */
            AND Ccbcdocu.nrodoc = Di-RutaD.nroref
            AND Ccbcdocu.Libre_c01 = "O/D"
            /* RHC 5/1/2021 M.R. divisiones autorizadas: EXCLUYENTES */
            AND NOT CAN-FIND(FIRST FacTabla WHERE FacTabla.codcia = s-codcia
                             AND FacTabla.tabla = 'REPROG_OD'
                             AND FacTabla.codigo = Ccbcdocu.divori NO-LOCK)
            /* Ic 19Jun2019, indicacion de MAX RAMOS, esas divisiones no se reprograman */
            /*AND LOOKUP(Ccbcdocu.divori,"00030,00070") = 0 */
        BREAK BY Ccbcdocu.Libre_c02:      /* Quiebre por número de O/D */
        IF FIRST-OF(Ccbcdocu.Libre_c02) THEN DO:
            EMPTY TEMP-TABLE T-RutaD.
            /* Limpiamos contador de guias por O/D */
            x-Guias = 0.
            x-ImpTot = 0.
            x-Peso = 0.
            x-Volumen = 0.
        END.
        x-Guias = x-Guias + 1.
        x-ImpTot = x-ImpTot + Ccbcdocu.ImpTot.
        FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
            x-Peso = x-Peso + (Almmmatg.PesMat * Ccbddocu.CanDes * Ccbddocu.Factor).
            x-Volumen = x-Volumen + (Almmmatg.Libre_d02 * Ccbddocu.CanDes * Ccbddocu.Factor / 1000000).
        END.
        /* ******************************************************************************************** */
        /* Acumulamos en el temporal */
        /* ******************************************************************************************** */
        CREATE T-RutaD.
        BUFFER-COPY Di-RutaD TO T-RutaD.
        /* ******************************************************************************************** */
        IF LAST-OF(Ccbcdocu.Libre_c02) THEN DO:
            /* Verificamos si TODAS la G/R han sido NO ENTREGADAS */
            x-Guias-2 = 0.
            FOR EACH B-RUTAD NO-LOCK WHERE B-RutaD.CodCia = Di-RutaC.CodCia AND
                B-RutaD.CodDiv = Di-RutaC.CodDiv AND
                B-RutaD.CodDoc = Di-RutaC.CodDoc AND 
                B-RutaD.NroDoc = Di-RutaC.NroDoc AND
                B-RUTAD.CodRef = "G/R",
                FIRST B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = B-RUTAD.codcia
                    AND B-CDOCU.coddoc = B-RUTAD.codref         /* G/R */
                    AND B-CDOCU.nrodoc = B-RUTAD.nroref
                    AND B-CDOCU.Libre_c01 = Ccbcdocu.libre_c01  /* O/D */
                    AND B-CDOCU.Libre_c02 = Ccbcdocu.libre_c02
                    AND B-CDOCU.FlgEst <> 'A':
                x-Guias-2 = x-Guias-2 + 1.
            END.
            /* ******************************************************************************************** */
            /* TODAS HAN SIDO "NO ENTREGADAS" */
            /* RHC 29/05/18 Si se repite el ciclo chancamos la anterior */
            /* ******************************************************************************************** */
            IF x-Guias = x-Guias-2 THEN DO:
                CASE Di-RutaD.flgest:
                    WHEN "T" THEN DO:
                        /* ******************************************************************************************** */
                        /* TIENDA: LA O/D Original migra a la tienda */
                        /* ******************************************************************************************** */
                        ASSIGN
                            x-CodDiv = Di-RutaD.Libre_c02   /* Tienda */
                            x-Motivo = DI-RutaD.FlgEstDet
                            x-CodHR  = DI-RutaC.CodDoc    /* H/R */
                            x-NroHR  = DI-RutaC.NroDoc.
                        /* ******************************************************************************************** */
                        /* Migramos la O/D a la nueva división */
                        /* ******************************************************************************************** */
                        FIND FIRST Almacen WHERE Almacen.codcia = s-codcia AND
                            Almacen.coddiv = x-CodDiv AND
                            Almacen.AlmPrincipal = YES AND
                            Almacen.Campo-c[9] <> "I" NO-LOCK NO-ERROR.
                        IF NOT AVAILABLE Almacen THEN DO:
                            MESSAGE 'La división' x-CodDiv 'NO tiene un almacén principal definido'
                                VIEW-AS ALERT-BOX ERROR.
                            UNDO RLOOP, RETURN 'ADM-ERROR'.
                        END.
                        FIND FIRST OD_Original WHERE  OD_Original.CodCia = s-codcia AND
                            OD_Original.CodDoc = Ccbcdocu.Libre_c01 AND 
                            OD_Original.NroPed = Ccbcdocu.Libre_c02
                            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                        IF NOT AVAILABLE OD_Original THEN DO:
                            MESSAGE Ccbcdocu.Libre_c01 Ccbcdocu.Libre_c02 'Bloqueado por otro usuario'
                                VIEW-AS ALERT-BOX ERROR.
                            UNDO RLOOP, RETURN 'ADM-ERROR'.
                        END.
                        ASSIGN
                            OD_Original.CodAlm = Almacen.codalm
                            OD_Original.DivDes = Almacen.coddiv.
                    END.
                    OTHERWISE DO:
                        ASSIGN
                            x-CodDiv = DI-RutaC.CodDiv      /* Por Defecto */
                            x-Motivo = DI-RutaD.FlgEstDet
                            x-CodHR  = DI-RutaC.CodDoc    /* H/R */
                            x-NroHR  = DI-RutaC.NroDoc.
                    END.
                END CASE.
                /* ******************************************************************************************** */
                /* CONTROL DE REPROGRAMACIONES */
                /* ******************************************************************************************** */
                FIND Almcdocu WHERE AlmCDocu.CodCia = Ccbcdocu.CodCia
                    AND AlmCDocu.CodLlave = x-CodDiv            /* OJO */
                    AND AlmCDocu.CodDoc = Ccbcdocu.Libre_c01    /* O/D */
                    AND AlmCDocu.NroDoc = Ccbcdocu.Libre_c02
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Almcdocu THEN DO:
                    FIND CURRENT Almcdocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                    IF ERROR-STATUS:ERROR = YES THEN DO:
                        MESSAGE 'Tabla Almcdocu en uso por otro usuario' VIEW-AS ALERT-BOX ERROR.
                        UNDO RLOOP, RETURN 'ADM-ERROR'.
                    END.
                END.
                ELSE CREATE Almcdocu.
                ASSIGN
                    AlmCDocu.CodCia = Ccbcdocu.CodCia
                    AlmCDocu.CodDoc = Ccbcdocu.Libre_c01    /* O/D */
                    AlmCDocu.NroDoc = Ccbcdocu.Libre_c02
                    AlmCDocu.CodLlave = x-CodDiv            /* OJO */
                    AlmCDocu.FchDoc = TODAY
                    AlmCDocu.FchCreacion = TODAY
                    AlmCDocu.FlgEst = "P"       /* "P": por reprogramar, "C": reprogramado, "A": no se reprograma */
                    AlmCDocu.UsrCreacion = s-user-id
                    AlmCDocu.Libre_c01 = x-CodHR            /* H/R */
                    AlmCDocu.Libre_c02 = x-NroHR
                    AlmCDocu.Libre_c03 = x-Motivo           /* Motivo */
                    AlmCDocu.Libre_d01 = x-ImpTot
                    AlmCDocu.Libre_d02 = x-Peso
                    AlmCDocu.Libre_d03 = x-Volumen
                    NO-ERROR.
                IF ERROR-STATUS:ERROR = YES THEN DO:
                    MESSAGE 'Tabla Almcdocu error en la llave' VIEW-AS ALERT-BOX ERROR.
                    UNDO RLOOP, RETURN 'ADM-ERROR'.
                END.
                /* ********************************************************************************************** */
                /* RHC 08/03/2019 Actualizamos CONTROL de PHR */
                /* ********************************************************************************************** */
                FIND FIRST B-PHRC WHERE B-PHRC.codcia = DI-RutaC.codcia
                    AND B-PHRC.coddiv = DI-RutaC.coddiv
                    AND B-PHRC.coddoc = "PHR"
                    AND B-PHRC.codref = DI-RutaC.CodDoc
                    AND B-PHRC.nroref = DI-RutaC.NroDoc
                    AND B-PHRC.flgest <> 'A'
                    AND CAN-FIND(FIRST B-PHRD OF B-PHRC WHERE B-PHRD.CodRef = Ccbcdocu.Libre_c01  /* O/D */
                                 AND B-PHRD.NroRef = Ccbcdocu.Libre_c02 NO-LOCK)
                    NO-LOCK NO-ERROR.
                IF AVAILABLE B-PHRC THEN DO:
                    {lib/lock-genericov3.i ~
                        &Tabla="B-PHRD" ~
                        &Alcance="FIRST" ~
                        &Condicion="B-PHRD.CodCia = B-PHRC.CodCia AND ~
                        B-PHRD.CodDiv = B-PHRC.CodDiv AND ~
                        B-PHRD.CodDoc = B-PHRC.CodDoc AND ~
                        B-PHRD.NroDoc = B-PHRC.NroDoc AND ~
                        B-PHRD.CodRef = Ccbcdocu.Libre_c01 AND ~
                        B-PHRD.NroRef = Ccbcdocu.Libre_c02" ~
                        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
                        &Accion="RETRY" ~
                        &Mensaje="YES" ~
                        &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'" ~
                        }
                    ASSIGN
                        B-PHRD.FlgEst = "P".    /* Regresa a EN PROCESO hasta definir su REPROGRAMACION */
                END.
                /* ********************************************************************************************** */
                /* GUIAS DE REMISION A ANULAR */
                /* RHC 10/02/2020 M.R. Ya no se anulan, marca com NO ENTREGADO o DEJADO EN TIENDA */
                /* ********************************************************************************************** */
                FOR EACH B-RUTAD OF Di-RutaC NO-LOCK WHERE B-RUTAD.codref = "G/R" AND
                        ( (B-RUTAD.flgest = "N" AND B-RUTAD.Libre_c02 = "R") OR
                        /* Dejado en Tienda */
                        (B-RUTAD.flgest = "T" AND B-RUTAD.FlgEstDet <> "@DT") ),
                    FIRST B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = B-RUTAD.codcia
                        AND B-CDOCU.coddoc = B-RUTAD.codref   /* G/R */
                        AND B-CDOCU.nrodoc = B-RUTAD.nroref
                        AND B-CDOCU.Libre_c01 = Ccbcdocu.libre_c01  /* O/D */
                        AND B-CDOCU.Libre_c02 = Ccbcdocu.libre_c02:
                    CREATE T-GUIAS.
                    BUFFER-COPY B-CDOCU TO T-GUIAS.
                    CASE TRUE:
                        WHEN (B-RUTAD.flgest = "N" AND B-RUTAD.Libre_c02 = "R") THEN T-GUIAS.FlgEst = "NE".
                        WHEN (B-RUTAD.flgest = "T" AND B-RUTAD.FlgEstDet <> "@DT") THEN T-GUIAS.FlgEst = "DT".
                    END CASE.
                END.
            END.
        END.
    END.
    /* ********************************************************************************************** */
    /* ANULA G/R POR VENTAS  */
    /* ********************************************************************************************** */
    FOR EACH T-GUIAS NO-LOCK, FIRST Ccbcdocu OF T-GUIAS EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
        ASSIGN
            /*CcbCDocu.FlgEst = "A"*/
            CcbCDocu.FlgEst = T-GUIAS.FlgEst.
        /*
            CcbCDocu.UsuAnu = s-user-id
            CcbCDocu.FchAnu = TODAY.
        */
    END.
END.
IF AVAILABLE(Almcdocu) THEN RELEASE Almcdocu.
IF AVAILABLE(B-PHRD)   THEN RELEASE B-PHRD.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HR_Cierre-Reprog-Multi-OTR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HR_Cierre-Reprog-Multi-OTR Procedure 
PROCEDURE HR_Cierre-Reprog-Multi-OTR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.

FIND Di-RutaC WHERE ROWID(Di-RutaC) = pRowid NO-LOCK.

DEF VAR x-Guias AS INT NO-UNDO.        
DEF VAR x-Guias-2 AS INT NO-UNDO.
DEF VAR x-ImpTot AS DEC NO-UNDO.
DEF VAR x-Peso AS DEC NO-UNDO.
DEF VAR x-Volumen AS DEC NO-UNDO.

DEF VAR x-CodDiv AS CHAR NO-UNDO.   /* Divisón Final */
DEF VAR x-Motivo AS CHAR NO-UNDO.
DEF VAR x-CodHR  AS CHAR NO-UNDO.
DEF VAR x-NroHR  AS CHAR NO-UNDO.

EMPTY TEMP-TABLE T-GUIAS.   /* GUIAS DE REMISION A ANULAR */

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Dos Procesos: En ambos casos las G/R relacionadas se ANULAN
        NO ENTREGADO
        DEJADO EN TIENDA:
            Cambiar la O/D como si se hubiera despachado de esa tienda 
    */
    /* ********************************************************************************************** */
    /* POR ORDENES DE TRANSFERENCIA */
    /* ********************************************************************************************** */
    FOR EACH Di-RutaG OF Di-RutaC NO-LOCK WHERE 
        /* NO entregado y Reprogramados */
        (Di-RutaG.flgest = "N" AND Di-RutaG.Libre_c02 = "R"),
        FIRST Almcmov NO-LOCK WHERE Almcmov.CodCia = Di-RutaG.CodCia
        AND Almcmov.CodAlm = Di-RutaG.CodAlm
        AND Almcmov.TipMov = Di-RutaG.Tipmov
        AND Almcmov.CodMov = Di-RutaG.Codmov
        AND Almcmov.NroSer = Di-RutaG.serref
        AND Almcmov.NroDoc = Di-RutaG.nroref
        AND Almcmov.CodRef = "OTR"
        AND Almcmov.FlgEst <> "A"
        BREAK BY Almcmov.NroRef:      /* Quiebre por número de O/D */
        IF FIRST-OF(Almcmov.NroRef) THEN DO:
            /* Limpiamos contador de guias por OTR */
            x-Guias = 0.
        END.
        x-Guias = x-Guias + 1.
        IF LAST-OF(Almcmov.NroRef) THEN DO:
            /* Verificamos si TODAS la G/R han sido NO ENTREGADAS */
            x-Guias-2 = 0.
            FOR EACH B-RUTAG OF Di-RutaC NO-LOCK /*WHERE (B-RUTAG.flgest = "N" AND B-RUTAG.Libre_c02 = "R")*/,
                FIRST B-CMOV WHERE B-CMOV.CodCia = B-RutaG.CodCia
                    AND B-CMOV.CodAlm = B-RutaG.CodAlm
                    AND B-CMOV.TipMov = B-RutaG.Tipmov
                    AND B-CMOV.CodMov = B-RutaG.Codmov
                    AND B-CMOV.NroSer = B-RutaG.serref
                    AND B-CMOV.NroDoc = B-RutaG.nroref
                    AND B-CMOV.CodRef = Almcmov.CodRef
                    AND B-CMOV.NroRef = Almcmov.NroRef
                    AND B-CMOV.FlgEst <> "A":
                x-Guias-2 = x-Guias-2 + 1.
            END.
            /* ******************************************************************************************** */
            /* TODAS HAN SIDO "NO ENTREGADAS" */
            /* RHC 29/05/18 Si se repite el ciclo chancamos la anterior */
            /* ******************************************************************************************** */
            IF x-Guias = x-Guias-2 THEN DO:
                ASSIGN
                    x-CodDiv = DI-RutaC.CodDiv      /* Por Defecto */
                    x-Motivo = DI-RutaG.FlgEstDet
                    x-CodHR  = DI-RutaC.CodDoc    /* H/R */
                    x-NroHR  = DI-RutaC.NroDoc.
                /* ********************************************************************************************** */
                /* RHC 08/03/2019 Actualizamos CONTROL de PHR */
                /* ********************************************************************************************** */
                FIND Almcdocu WHERE AlmCDocu.CodCia = s-CodCia
                    AND AlmCDocu.CodLlave = DI-RutaC.CodDiv         /* OJO */
                    AND AlmCDocu.CodDoc = Almcmov.CodRef            /* OTR */
                    AND AlmCDocu.NroDoc = Almcmov.Nroref
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Almcdocu THEN DO:
                    FIND CURRENT Almcdocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                    IF ERROR-STATUS:ERROR = YES THEN DO:
                        MESSAGE 'Tabla Almcdocu en uso por otro usuario' VIEW-AS ALERT-BOX ERROR.
                        UNDO RLOOP, RETURN 'ADM-ERROR'.
                    END.
                END.
                ELSE CREATE Almcdocu.
                ASSIGN
                    AlmCDocu.CodCia = s-CodCia
                    AlmCDocu.CodLlave = DI-RutaC.CodDiv     /* OJO */
                    AlmCDocu.CodDoc = Almcmov.CodRef        /* OTR */
                    AlmCDocu.NroDoc = Almcmov.NroRef
                    AlmCDocu.FchDoc = TODAY
                    AlmCDocu.FchCreacion = TODAY
                    AlmCDocu.FlgEst = "P"       /* "P": por reprogramar, "C": reprogramado, "A": no se reprograma */
                    AlmCDocu.UsrCreacion = s-user-id
                    AlmCDocu.Libre_c01 = x-CodHR            /* H/R */
                    AlmCDocu.Libre_c02 = x-NroHR
                    AlmCDocu.Libre_c03 = x-Motivo           /* Motivo */
                    AlmCDocu.Libre_d01 = x-ImpTot
                    AlmCDocu.Libre_d02 = x-Peso
                    AlmCDocu.Libre_d03 = x-Volumen
                    NO-ERROR.
                IF ERROR-STATUS:ERROR = YES THEN DO:
                    MESSAGE 'Tabla Almcdocu error en la llave' VIEW-AS ALERT-BOX ERROR.
                    UNDO RLOOP, RETURN 'ADM-ERROR'.
                END.
                /* ********************************************************************************************** */
                /* RHC 08/03/2019 Actualizamos CONTROL de PHR */
                /* ********************************************************************************************** */
                FIND FIRST B-PHRC WHERE B-PHRC.codcia = DI-RutaC.codcia
                    AND B-PHRC.coddiv = DI-RutaC.coddiv
                    AND B-PHRC.coddoc = "PHR"
                    AND B-PHRC.codref = DI-RutaC.CodDoc
                    AND B-PHRC.nroref = DI-RutaC.NroDoc
                    AND CAN-FIND(FIRST B-PHRD OF B-PHRC WHERE B-PHRD.CodRef = Almcmov.CodRef  /* OTR */
                                 AND B-PHRD.NroRef = Almcmov.NroRef NO-LOCK)
                    NO-LOCK NO-ERROR.
                IF AVAILABLE B-PHRC THEN DO:
                    {lib/lock-genericov3.i ~
                        &Tabla="B-PHRD" ~
                        &Alcance="FIRST" ~
                        &Condicion="B-PHRD.CodCia = B-PHRC.CodCia AND ~
                        B-PHRD.CodDiv = B-PHRC.CodDiv AND ~
                        B-PHRD.CodDoc = B-PHRC.CodDoc AND ~
                        B-PHRD.NroDoc = B-PHRC.NroDoc AND ~
                        B-PHRD.CodRef = Almcmov.CodRef AND ~
                        B-PHRD.NroRef = Almcmov.NroRef" ~
                        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
                        &Accion="RETRY" ~
                        &Mensaje="YES" ~
                        &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'" ~
                        }
                    ASSIGN
                        B-PHRD.FlgEst = "P".    /* Regresa a EN PROCESO hasta definir su REPROGRAMACION */
                END.
            END.
        END.
    END.
END.
IF AVAILABLE(Almcdocu) THEN RELEASE Almcdocu.
IF AVAILABLE(B-PHRD)   THEN RELEASE B-PHRD.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HR_Cierre-Reprogramacion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HR_Cierre-Reprogramacion Procedure 
PROCEDURE HR_Cierre-Reprogramacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.

FIND Di-RutaC WHERE ROWID(Di-RutaC) = pRowid NO-LOCK.

DEF VAR x-Guias AS INT NO-UNDO.        
DEF VAR x-Guias-2 AS INT NO-UNDO.
DEF VAR x-ImpTot AS DEC NO-UNDO.
DEF VAR x-Peso AS DEC NO-UNDO.
DEF VAR x-Volumen AS DEC NO-UNDO.

DEF VAR x-CodDiv AS CHAR NO-UNDO.   /* Divisón Final */
DEF VAR x-Motivo AS CHAR NO-UNDO.
DEF VAR x-CodHR  AS CHAR NO-UNDO.
DEF VAR x-NroHR  AS CHAR NO-UNDO.

EMPTY TEMP-TABLE T-GUIAS.   /* GUIAS DE REMISION A ANULAR */

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Dos Procesos: En ambos casos las G/R relacionadas se ANULAN
        NO ENTREGADO
        DEJADO EN TIENDA:
            Cambiar la O/D como si se hubiera despachado de esa tienda 
    */
    /* ********************************************************************************************** */
    /* POR ORDENES DE DESPACHO */
    /* ********************************************************************************************** */
    FOR EACH Di-RutaD OF Di-RutaC NO-LOCK WHERE Di-RutaD.codref = "G/R" AND
        /* NO entregado y Reprogramados */
        ( (Di-RutaD.flgest = "N" AND Di-RutaD.Libre_c02 = "R") OR
        /* Dejado en Tienda */
        (Di-RutaD.flgest = "T" AND Di-RutaD.FlgEstDet <> "@DT") ),
        FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Di-RutaD.codcia
            AND Ccbcdocu.coddoc = Di-RutaD.codref   /* G/R */
            AND Ccbcdocu.nrodoc = Di-RutaD.nroref
            AND Ccbcdocu.Libre_c01 = "O/D"
            /* Ic 19Jun2019, indicacion de MAX RAMOS, esas divisiones no se reprograman */
            AND LOOKUP(Ccbcdocu.divori,"00030,00070") = 0 
        BREAK BY Ccbcdocu.Libre_c02:      /* Quiebre por número de O/D */
        IF FIRST-OF(Ccbcdocu.Libre_c02) THEN DO:
            EMPTY TEMP-TABLE T-RutaD.
            /* Limpiamos contador de guias por O/D */
            x-Guias = 0.
            x-ImpTot = 0.
            x-Peso = 0.
            x-Volumen = 0.
        END.
        x-Guias = x-Guias + 1.
        x-ImpTot = x-ImpTot + Ccbcdocu.ImpTot.
        FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
            x-Peso = x-Peso + (Almmmatg.PesMat * Ccbddocu.CanDes * Ccbddocu.Factor).
            x-Volumen = x-Volumen + (Almmmatg.Libre_d02 * Ccbddocu.CanDes * Ccbddocu.Factor / 1000000).
        END.
        /* ******************************************************************************************** */
        /* Acumulamos en el temporal */
        /* ******************************************************************************************** */
        CREATE T-RutaD.
        BUFFER-COPY Di-RutaD TO T-RutaD.
        /* ******************************************************************************************** */
        IF LAST-OF(Ccbcdocu.Libre_c02) THEN DO:
            /* Verificamos si TODAS la G/R han sido NO ENTREGADAS */
            x-Guias-2 = 0.
            FOR EACH B-RUTAD NO-LOCK WHERE B-RutaD.CodCia = Di-RutaC.CodCia AND
                B-RutaD.CodDiv = Di-RutaC.CodDiv AND
                B-RutaD.CodDoc = Di-RutaC.CodDoc AND 
                B-RutaD.NroDoc = Di-RutaC.NroDoc AND
                B-RUTAD.CodRef = "G/R",
                FIRST B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = B-RUTAD.codcia
                    AND B-CDOCU.coddoc = B-RUTAD.codref         /* G/R */
                    AND B-CDOCU.nrodoc = B-RUTAD.nroref
                    AND B-CDOCU.Libre_c01 = Ccbcdocu.libre_c01  /* O/D */
                    AND B-CDOCU.Libre_c02 = Ccbcdocu.libre_c02:
                x-Guias-2 = x-Guias-2 + 1.
            END.
            /* ******************************************************************************************** */
            /* TODAS HAN SIDO "NO ENTREGADAS" */
            /* RHC 29/05/18 Si se repite el ciclo chancamos la anterior */
            /* ******************************************************************************************** */
            IF x-Guias = x-Guias-2 THEN DO:
                CASE Di-RutaD.flgest:
                    WHEN "T" THEN DO:
                        /* ******************************************************************************************** */
                        /* TIENDA: LA O/D Original migra a la tienda */
                        /* ******************************************************************************************** */
                        ASSIGN
                            x-CodDiv = Di-RutaD.Libre_c02   /* Tienda */
                            x-Motivo = DI-RutaD.FlgEstDet
                            x-CodHR  = DI-RutaC.CodDoc    /* H/R */
                            x-NroHR  = DI-RutaC.NroDoc.
                        /* ******************************************************************************************** */
                        /* Migramos la O/D a la nueva división */
                        /* ******************************************************************************************** */
                        FIND FIRST Almacen WHERE Almacen.codcia = s-codcia AND
                            Almacen.coddiv = x-CodDiv AND
                            Almacen.AlmPrincipal = YES AND
                            Almacen.Campo-c[9] <> "I" NO-LOCK NO-ERROR.
                        IF NOT AVAILABLE Almacen THEN DO:
                            MESSAGE 'La división' x-CodDiv 'NO tiene un almacén principal definido'
                                VIEW-AS ALERT-BOX ERROR.
                            UNDO RLOOP, RETURN 'ADM-ERROR'.
                        END.
                        FIND FIRST OD_Original WHERE  OD_Original.CodCia = s-codcia AND
                            OD_Original.CodDoc = Ccbcdocu.Libre_c01 AND 
                            OD_Original.NroPed = Ccbcdocu.Libre_c02
                            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                        IF NOT AVAILABLE OD_Original THEN DO:
                            MESSAGE Ccbcdocu.Libre_c01 Ccbcdocu.Libre_c02 'Bloqueado por otro usuario'
                                VIEW-AS ALERT-BOX ERROR.
                            UNDO RLOOP, RETURN 'ADM-ERROR'.
                        END.
                        ASSIGN
                            OD_Original.CodAlm = Almacen.codalm
                            OD_Original.DivDes = Almacen.coddiv.
                    END.
                    OTHERWISE DO:
                        ASSIGN
                            x-CodDiv = DI-RutaC.CodDiv      /* Por Defecto */
                            x-Motivo = DI-RutaD.FlgEstDet
                            x-CodHR  = DI-RutaC.CodDoc    /* H/R */
                            x-NroHR  = DI-RutaC.NroDoc.
                    END.
                END CASE.
                /* ******************************************************************************************** */
                /* CONTROL DE REPROGRAMACIONES */
                /* ******************************************************************************************** */
                FIND Almcdocu WHERE AlmCDocu.CodCia = Ccbcdocu.CodCia
                    AND AlmCDocu.CodLlave = x-CodDiv            /* OJO */
                    AND AlmCDocu.CodDoc = Ccbcdocu.Libre_c01    /* O/D */
                    AND AlmCDocu.NroDoc = Ccbcdocu.Libre_c02
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Almcdocu THEN DO:
                    FIND CURRENT Almcdocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                    IF ERROR-STATUS:ERROR = YES THEN DO:
                        MESSAGE 'Tabla Almcdocu en uso por otro usuario' VIEW-AS ALERT-BOX ERROR.
                        UNDO RLOOP, RETURN 'ADM-ERROR'.
                    END.
                END.
                ELSE CREATE Almcdocu.
                ASSIGN
                    AlmCDocu.CodCia = Ccbcdocu.CodCia
                    AlmCDocu.CodDoc = Ccbcdocu.Libre_c01    /* O/D */
                    AlmCDocu.NroDoc = Ccbcdocu.Libre_c02
                    AlmCDocu.CodLlave = x-CodDiv            /* OJO */
                    AlmCDocu.FchDoc = TODAY
                    AlmCDocu.FchCreacion = TODAY
                    AlmCDocu.FlgEst = "P"       /* "P": por reprogramar, "C": reprogramado, "A": no se reprograma */
                    AlmCDocu.UsrCreacion = s-user-id
                    AlmCDocu.Libre_c01 = x-CodHR            /* H/R */
                    AlmCDocu.Libre_c02 = x-NroHR
                    AlmCDocu.Libre_c03 = x-Motivo           /* Motivo */
                    AlmCDocu.Libre_d01 = x-ImpTot
                    AlmCDocu.Libre_d02 = x-Peso
                    AlmCDocu.Libre_d03 = x-Volumen
                    NO-ERROR.
                IF ERROR-STATUS:ERROR = YES THEN DO:
                    MESSAGE 'Tabla Almcdocu error en la llave' VIEW-AS ALERT-BOX ERROR.
                    UNDO RLOOP, RETURN 'ADM-ERROR'.
                END.
                /* ********************************************************************************************** */
                /* RHC 08/03/2019 Actualizamos CONTROL de PHR */
                /* ********************************************************************************************** */
                IF ENTRY(1, DI-RutaC.Libre_c03) = "PHR" THEN DO:
                    FIND B-PHRD WHERE B-PHRD.codcia = DI-RutaC.codcia
                        AND B-PHRD.coddiv = DI-RutaC.coddiv
                        AND B-PHRD.coddoc = ENTRY(1, DI-RutaC.libre_c03)
                        AND B-PHRD.nrodoc = ENTRY(2, DI-RutaC.libre_c03)
                        AND B-PHRD.CodRef = Ccbcdocu.Libre_c01  /* O/D */
                        AND B-PHRD.NroRef = Ccbcdocu.Libre_c02 EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                    IF ERROR-STATUS:ERROR = YES THEN DO:
                        MESSAGE 'Registro de O/D en uso por otro usuario' VIEW-AS ALERT-BOX ERROR.
                        UNDO RLOOP, RETURN 'ADM-ERROR'.
                    END.
                    ASSIGN
                        B-PHRD.FlgEst = "P".    /* Regresa a EN PROCESO hasta definir su REPROGRAMACION */
                END.
                /* ********************************************************************************************** */
                /* GUIAS DE REMISION A ANULAR */
                /* ********************************************************************************************** */
                FOR EACH B-RUTAD OF Di-RutaC NO-LOCK WHERE B-RUTAD.codref = "G/R" AND
                        ( (B-RUTAD.flgest = "N" AND B-RUTAD.Libre_c02 = "R") OR
                        /* Dejado en Tienda */
                        (B-RUTAD.flgest = "T" AND B-RUTAD.FlgEstDet <> "@DT") ),
                    FIRST B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = B-RUTAD.codcia
                        AND B-CDOCU.coddoc = B-RUTAD.codref   /* G/R */
                        AND B-CDOCU.nrodoc = B-RUTAD.nroref
                        AND B-CDOCU.Libre_c01 = Ccbcdocu.libre_c01  /* O/D */
                        AND B-CDOCU.Libre_c02 = Ccbcdocu.libre_c02:
                    CREATE T-GUIAS.
                    BUFFER-COPY B-CDOCU TO T-GUIAS.

                    /* Ic 17Feb2020, ESTADOS para No entregado/reprogramado y Dejado en tienda */
                    IF (B-RUTAD.flgest = "N" AND B-RUTAD.Libre_c02 = "R") THEN ASSIGN T-GUIAS.Libre_c01 = "NE".
                    IF (B-RUTAD.flgest = "T" AND B-RUTAD.FlgEstDet <> "@DT") THEN ASSIGN T-GUIAS.Libre_c01 = "DT".
                    
                END.
            END.
        END.
    END.
    /* ********************************************************************************************** */
    /* ANULA G/R POR VENTAS  */
    /* ********************************************************************************************** */
    FOR EACH T-GUIAS NO-LOCK, FIRST Ccbcdocu OF T-GUIAS EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
        ASSIGN
            CcbCDocu.FlgEst = T-GUIAS.Libre_c01.

        /*
        ASSIGN
            CcbCDocu.FlgEst = "A"
            CcbCDocu.UsuAnu = s-user-id
            CcbCDocu.FchAnu = TODAY.
        */
    END.
    /* ********************************************************************************************** */
    /* POR ORDENES DE TRANSFERENCIA */
    /* ********************************************************************************************** */
    FOR EACH Di-RutaG OF Di-RutaC NO-LOCK WHERE 
        /* NO entregado y Reprogramados */
        (Di-RutaG.flgest = "N" AND Di-RutaG.Libre_c02 = "R"),
        FIRST Almcmov NO-LOCK WHERE Almcmov.CodCia = Di-RutaG.CodCia
        AND Almcmov.CodAlm = Di-RutaG.CodAlm
        AND Almcmov.TipMov = Di-RutaG.Tipmov
        AND Almcmov.CodMov = Di-RutaG.Codmov
        AND Almcmov.NroSer = Di-RutaG.serref
        AND Almcmov.NroDoc = Di-RutaG.nroref
        AND Almcmov.CodRef = "OTR"
        AND Almcmov.FlgEst <> "A"
        BREAK BY Almcmov.NroRef:      /* Quiebre por número de O/D */
        IF FIRST-OF(Almcmov.NroRef) THEN DO:
            /* Limpiamos contador de guias por OTR */
            x-Guias = 0.
        END.
        x-Guias = x-Guias + 1.
        IF LAST-OF(Almcmov.NroRef) THEN DO:
            /* Verificamos si TODAS la G/R han sido NO ENTREGADAS */
            x-Guias-2 = 0.
            FOR EACH B-RUTAG OF Di-RutaC NO-LOCK /*WHERE (B-RUTAG.flgest = "N" AND B-RUTAG.Libre_c02 = "R")*/,
                FIRST B-CMOV WHERE B-CMOV.CodCia = B-RutaG.CodCia
                    AND B-CMOV.CodAlm = B-RutaG.CodAlm
                    AND B-CMOV.TipMov = B-RutaG.Tipmov
                    AND B-CMOV.CodMov = B-RutaG.Codmov
                    AND B-CMOV.NroSer = B-RutaG.serref
                    AND B-CMOV.NroDoc = B-RutaG.nroref
                    AND B-CMOV.CodRef = Almcmov.CodRef
                    AND B-CMOV.NroRef = Almcmov.NroRef
                    AND B-CMOV.FlgEst <> "A":
                x-Guias-2 = x-Guias-2 + 1.
            END.
            /* ******************************************************************************************** */
            /* TODAS HAN SIDO "NO ENTREGADAS" */
            /* RHC 29/05/18 Si se repite el ciclo chancamos la anterior */
            /* ******************************************************************************************** */
            IF x-Guias = x-Guias-2 THEN DO:
                ASSIGN
                    x-CodDiv = DI-RutaC.CodDiv      /* Por Defecto */
                    x-Motivo = DI-RutaD.FlgEstDet
                    x-CodHR  = DI-RutaC.CodDoc    /* H/R */
                    x-NroHR  = DI-RutaC.NroDoc.
                /* ********************************************************************************************** */
                /* RHC 08/03/2019 Actualizamos CONTROL de PHR */
                /* ********************************************************************************************** */
                FIND Almcdocu WHERE AlmCDocu.CodCia = s-CodCia
                    AND AlmCDocu.CodLlave = DI-RutaC.CodDiv         /* OJO */
                    AND AlmCDocu.CodDoc = Almcmov.CodRef            /* OTR */
                    AND AlmCDocu.NroDoc = Almcmov.Nroref
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Almcdocu THEN DO:
                    FIND CURRENT Almcdocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                    IF ERROR-STATUS:ERROR = YES THEN DO:
                        MESSAGE 'Tabla Almcdocu en uso por otro usuario' VIEW-AS ALERT-BOX ERROR.
                        UNDO RLOOP, RETURN 'ADM-ERROR'.
                    END.
                END.
                ELSE CREATE Almcdocu.
                ASSIGN
                    AlmCDocu.CodCia = s-CodCia
                    AlmCDocu.CodLlave = DI-RutaC.CodDiv     /* OJO */
                    AlmCDocu.CodDoc = Almcmov.CodRef        /* OTR */
                    AlmCDocu.NroDoc = Almcmov.NroRef
                    AlmCDocu.FchDoc = TODAY
                    AlmCDocu.FchCreacion = TODAY
                    AlmCDocu.FlgEst = "P"       /* "P": por reprogramar, "C": reprogramado, "A": no se reprograma */
                    AlmCDocu.UsrCreacion = s-user-id
                    AlmCDocu.Libre_c01 = x-CodHR            /* H/R */
                    AlmCDocu.Libre_c02 = x-NroHR
                    AlmCDocu.Libre_c03 = x-Motivo           /* Motivo */
                    AlmCDocu.Libre_d01 = x-ImpTot
                    AlmCDocu.Libre_d02 = x-Peso
                    AlmCDocu.Libre_d03 = x-Volumen
                    NO-ERROR.
                IF ERROR-STATUS:ERROR = YES THEN DO:
                    MESSAGE 'Tabla Almcdocu error en la llave' VIEW-AS ALERT-BOX ERROR.
                    UNDO RLOOP, RETURN 'ADM-ERROR'.
                END.
                /* ********************************************************************************************** */
                /* RHC 08/03/2019 Actualizamos CONTROL de PHR */
                /* ********************************************************************************************** */
                IF ENTRY(1, DI-RutaC.Libre_c03) = "PHR" THEN DO:
                    FIND B-PHRD WHERE B-PHRD.codcia = DI-RutaC.codcia
                        AND B-PHRD.coddiv = DI-RutaC.coddiv
                        AND B-PHRD.coddoc = ENTRY(1, DI-RutaC.libre_c03)
                        AND B-PHRD.nrodoc = ENTRY(2, DI-RutaC.libre_c03)
                        AND B-PHRD.CodRef = Almcmov.CodRef      /* OTR */
                        AND B-PHRD.NroRef = Almcmov.NroRef EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                    IF ERROR-STATUS:ERROR = YES THEN DO:
                        MESSAGE 'Registro de OTR en uso por otro usuario' VIEW-AS ALERT-BOX ERROR.
                        UNDO RLOOP, RETURN 'ADM-ERROR'.
                    END.
                    ASSIGN
                        B-PHRD.FlgEst = "P".    /* Regresa a EN PROCESO hasta definir su REPROGRAMACION */
                END.
            END.
        END.
    END.
END.
IF AVAILABLE(Almcdocu) THEN RELEASE Almcdocu.
IF AVAILABLE(B-PHRD)   THEN RELEASE B-PHRD.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HR_Cierre-reprogramacion-Old) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HR_Cierre-reprogramacion-Old Procedure 
PROCEDURE HR_Cierre-reprogramacion-Old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEF INPUT PARAMETER pRowid AS ROWID.

FIND Di-RutaC WHERE ROWID(Di-RutaC) = pRowid NO-LOCK.

DEF VAR x-Guias AS INT NO-UNDO.        
DEF VAR x-Guias-2 AS INT NO-UNDO.
DEF VAR x-ImpTot AS DEC NO-UNDO.
DEF VAR x-Peso AS DEC NO-UNDO.
DEF VAR x-Volumen AS DEC NO-UNDO.

DEF VAR x-CodDiv AS CHAR NO-UNDO.   /* Divisón Final */
DEF VAR x-Motivo AS CHAR NO-UNDO.
DEF VAR x-CodHR  AS CHAR NO-UNDO.
DEF VAR x-NroHR  AS CHAR NO-UNDO.

DEF BUFFER GUIAS FOR Ccbcdocu.        

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Dos Procesos:
        NO ENTREGADO
        DEJADO EN TIENDA:
            Crear una H/R fantasma en la tienda 
            Cambiar la O/D como si se hubiera despachado de esa tienda 
    */
    FOR EACH Di-RutaD OF Di-RutaC NO-LOCK WHERE Di-RutaD.codref = "G/R" AND
        /* NO entregado y Reprogramados */
        ( (Di-RutaD.flgest = "N" AND Di-RutaD.Libre_c02 = "R") OR
        /* Dejado en Tienda */
        (Di-RutaD.flgest = "T") ),
        FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Di-RutaD.codcia
            AND Ccbcdocu.coddoc = Di-RutaD.codref   /* G/R */
            AND Ccbcdocu.nrodoc = Di-RutaD.nroref
            AND Ccbcdocu.Libre_c01 = "O/D"
        BREAK BY Ccbcdocu.Libre_c02:      /* Quiebre por número de O/D */
        IF FIRST-OF(Ccbcdocu.Libre_c02) THEN DO:
            EMPTY TEMP-TABLE T-RutaD.
            /* Limpiamos contador de guias por O/D */
            x-Guias = 0.
            x-ImpTot = 0.
            x-Peso = 0.
            x-Volumen = 0.
        END.
        x-Guias = x-Guias + 1.
        x-ImpTot = x-ImpTot + Ccbcdocu.ImpTot.
        FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
            x-Peso = x-Peso + (Almmmatg.PesMat * Ccbddocu.CanDes * Ccbddocu.Factor).
            x-Volumen = x-Volumen + (Almmmatg.Libre_d02 * Ccbddocu.CanDes * Ccbddocu.Factor / 1000000).
        END.
        /* ******************************************************************************************** */
        /* Acumulamos en el temporal */
        /* ******************************************************************************************** */
        CREATE T-RutaD.
        BUFFER-COPY Di-RutaD TO T-RutaD.
        /* ******************************************************************************************** */
        IF LAST-OF(Ccbcdocu.Libre_c02) THEN DO:
            /* Verificamos si TODAS la G/R han sido NO ENTREGADAS */
            x-Guias-2 = 0.
            FOR EACH B-RUTAD OF Di-RutaC NO-LOCK WHERE B-RUTAD.codref = "G/R" AND
                    ( (B-RUTAD.flgest = "N" AND B-RUTAD.Libre_c02 = "R") OR
                    /* Dejado en Tienda */
                    (B-RUTAD.flgest = "T") ),
                FIRST B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = B-RUTAD.codcia
                    AND B-CDOCU.coddoc = B-RUTAD.codref   /* G/R */
                    AND B-CDOCU.nrodoc = B-RUTAD.nroref
                    AND B-CDOCU.Libre_c01 = Ccbcdocu.libre_c01
                    AND B-CDOCU.Libre_c02 = Ccbcdocu.libre_c02:
                x-Guias-2 = x-Guias-2 + 1.
            END.
            /* ******************************************************************************************** */
            /* TODAS HAN SIDO "NO ENTREGADAS" */
            /* RHC 29/05/18 Si se repite el ciclo chancamos la anterior */
            /* ******************************************************************************************** */
            IF x-Guias = x-Guias-2 THEN DO:
                CASE Di-RutaD.flgest:
                    WHEN "T" THEN DO:
                        ASSIGN
                            x-CodDiv = Di-RutaD.Libre_c02
                            x-Motivo = DI-RutaD.FlgEstDet
                            x-CodHR  = DI-RutaC.CodDoc    /* H/R */
                            x-NroHR  = DI-RutaC.NroDoc.
                        /* ******************************************************************************************** */
                        /* TIENDA */
                        /* 1ro. Generamos la H/R fantasma el la división de la tienda */
                        /* ******************************************************************************************** */
                        /* ******************************************************************************************** 
                        FIND FIRST Almacen WHERE Almacen.codcia = s-codcia AND
                            Almacen.coddiv = x-CodDiv AND
                            Almacen.AlmPrincipal = YES AND
                            Almacen.Campo-c[9] <> "I" NO-LOCK NO-ERROR.
                        IF NOT AVAILABLE Almacen THEN DO:
                            MESSAGE 'La división' x-CodDiv 'NO tiene un almacén principal definido'
                                VIEW-AS ALERT-BOX ERROR.
                            UNDO RLOOP, RETURN 'ADM-ERROR'.
                        END.
                        FIND FacCorre WHERE FacCorre.CodCia = s-codcia AND
                            FacCorre.CodDiv = x-coddiv AND
                            FacCorre.CodDoc = "H/R" AND 
                            FacCorre.FlgEst = YES
                            NO-LOCK NO-ERROR.
                        IF NOT AVAILABLE FacCorre THEN DO:
                            MESSAGE 'NO está definido el correlativo para la H/R en la división' x-CodDiv
                                VIEW-AS ALERT-BOX ERROR.
                            UNDO RLOOP, RETURN 'ADM-ERROR'.
                        END.
                        {lib/lock-genericov3.i ~
                            &Tabla="FacCorre" ~
                            &Alcance="FIRST" ~
                            &Condicion="FacCorre.CodCia = s-codcia AND ~
                            FacCorre.CodDiv = x-CodDiv AND ~
                            FacCorre.CodDoc = 'H/R' AND ~
                            FacCorre.FlgEst = YES" ~
                            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
                            &Accion="RETRY" ~
                            &Mensaje="YES" ~
                            &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'"}
                        CREATE B-RutaC.
                        BUFFER-COPY Di-RutaC TO B-RutaC
                            ASSIGN
                            B-RutaC.CodDiv = x-CodDiv
                            B-RutaC.FchDoc = TODAY
                            B-RutaC.NroDoc = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999')
                            B-RutaC.usuario = s-user-id.
                        ASSIGN 
                            FacCorre.Correlativo = FacCorre.Correlativo + 1.
                        ASSIGN
                            x-CodHR  = B-RutaC.CodDoc    /* H/R */
                            x-NroHR  = B-RutaC.NroDoc.
                        /* Detalle */
                        FOR EACH T-RutaD:
                            CREATE B-RutaD.
                            BUFFER-COPY T-RutaD TO B-RutaD
                                ASSIGN
                                B-RutaD.CodDiv = B-RutaC.CodDiv
                                B-RutaD.NroDoc = B-RutaC.NroDoc
                                B-RutaD.FlgEst = "N"
                                B-RutaD.Libre_c02 = "R"
                                B-RutaD.FlgEstDet = x-Motivo.
                        END.
                        ******************************************************************************************** */
                        /* ******************************************************************************************** */
                        /* Migramos la O/D a la nueva división */
                        /* ******************************************************************************************** */
                        FIND FIRST OD_Original WHERE  OD_Original.CodCia = s-codcia AND
                            OD_Original.CodDoc = Ccbcdocu.Libre_c01 AND 
                            OD_Original.NroPed = Ccbcdocu.Libre_c02
                            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                        IF NOT AVAILABLE OD_Original THEN DO:
                            MESSAGE Ccbcdocu.Libre_c01 Ccbcdocu.Libre_c02 'Bloqueado por otro usuario'
                                VIEW-AS ALERT-BOX ERROR.
                            UNDO RLOOP, RETURN 'ADM-ERROR'.
                        END.
                        ASSIGN
                            OD_Original.CodAlm = Almacen.codalm
                            OD_Original.DivDes = Almacen.coddiv.
                    END.
                    OTHERWISE DO:
                        ASSIGN
                            x-CodDiv = DI-RutaC.CodDiv      /* Por Defecto */
                            x-Motivo = DI-RutaD.FlgEstDet
                            x-CodHR  = DI-RutaC.CodDoc    /* H/R */
                            x-NroHR  = DI-RutaC.NroDoc.
                    END.
                END CASE.
                FIND Almcdocu WHERE AlmCDocu.CodCia = Ccbcdocu.CodCia
                    AND AlmCDocu.CodLlave = x-CodDiv            /* OJO */
                    AND AlmCDocu.CodDoc = Ccbcdocu.Libre_c01    /* O/D */
                    AND AlmCDocu.NroDoc = Ccbcdocu.Libre_c02
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Almcdocu THEN DO:
                    FIND CURRENT Almcdocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                    IF ERROR-STATUS:ERROR = YES THEN DO:
                        MESSAGE 'Tabla Almcdocu en uso por otro usuario' VIEW-AS ALERT-BOX ERROR.
                        UNDO RLOOP, RETURN 'ADM-ERROR'.
                    END.
                END.
                ELSE CREATE Almcdocu.
                ASSIGN
                    AlmCDocu.CodCia = Ccbcdocu.CodCia
                    AlmCDocu.CodDoc = Ccbcdocu.Libre_c01    /* O/D */
                    AlmCDocu.NroDoc = Ccbcdocu.Libre_c02
                    AlmCDocu.CodLlave = x-CodDiv            /* OJO */
                    AlmCDocu.FchDoc = TODAY
                    AlmCDocu.FchCreacion = TODAY
                    AlmCDocu.FlgEst = "P"       /* "P": por reprogramar, "C": reprogramado, "A": no se reprograma */
                    AlmCDocu.UsrCreacion = s-user-id
                    AlmCDocu.Libre_c01 = x-CodHR            /* H/R */
                    AlmCDocu.Libre_c02 = x-NroHR
                    AlmCDocu.Libre_c03 = x-Motivo           /* Motivo */
                    AlmCDocu.Libre_d01 = x-ImpTot
                    AlmCDocu.Libre_d02 = x-Peso
                    AlmCDocu.Libre_d03 = x-Volumen
                    NO-ERROR.
                IF ERROR-STATUS:ERROR = YES THEN DO:
                    MESSAGE 'Tabla Almcdocu error en la llave' VIEW-AS ALERT-BOX ERROR.
                    UNDO RLOOP, RETURN 'ADM-ERROR'.
                END.
                /* ********************************************************************************************** */
                /* RHC 08/03/2019 Actualizamos CONTROL de PHR */
                /* ********************************************************************************************** */
                IF ENTRY(1, DI-RutaC.Libre_c03) = "PHR" THEN DO:
                    FIND B-PHRD WHERE B-PHRD.codcia = DI-RutaC.codcia
                        AND B-PHRD.coddiv = DI-RutaC.coddiv
                        AND B-PHRD.coddoc = ENTRY(1, DI-RutaC.libre_c03)
                        AND B-PHRD.nrodoc = ENTRY(2, DI-RutaC.libre_c03)
                        AND B-PHRD.CodRef = Ccbcdocu.Libre_c01  /* O/D */
                        AND B-PHRD.NroRef = Ccbcdocu.Libre_c02 EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                    IF ERROR-STATUS:ERROR = YES THEN DO:
                        MESSAGE 'Registro de O/D en uso por otro usuario' VIEW-AS ALERT-BOX ERROR.
                        UNDO RLOOP, RETURN 'ADM-ERROR'.
                    END.
                    ASSIGN
                        B-PHRD.FlgEst = "P".    /* Regresa a EN PROCESO hasta definir su REPROGRAMACION */
                END.
            END.
        END.
    END.
    /* ********************************************************************************************** */
    /* POR ORDENES DE TRANSFERENCIA */
    /* ********************************************************************************************** */
    FOR EACH Di-RutaG OF Di-RutaC NO-LOCK WHERE 
        /* NO entregado y Reprogramados */
        (Di-RutaG.flgest = "N" AND Di-RutaG.Libre_c02 = "R"),
        FIRST Almcmov NO-LOCK WHERE Almcmov.CodCia = Di-RutaG.CodCia
        AND Almcmov.CodAlm = Di-RutaG.CodAlm
        AND Almcmov.TipMov = Di-RutaG.Tipmov
        AND Almcmov.CodMov = Di-RutaG.Codmov
        AND Almcmov.NroSer = Di-RutaG.serref
        AND Almcmov.NroDoc = Di-RutaG.nroref
        AND Almcmov.CodRef = "OTR"
        BREAK BY Almcmov.NroRef:      /* Quiebre por número de O/D */
        IF FIRST-OF(Almcmov.NroRef) THEN DO:
            /* Limpiamos contador de guias por OTR */
            x-Guias = 0.
        END.
        x-Guias = x-Guias + 1.
        IF LAST-OF(Almcmov.NroRef) THEN DO:
            /* Verificamos si TODAS la G/R han sido NO ENTREGADAS */
            x-Guias-2 = 0.
            FOR EACH B-RUTAG OF Di-RutaC NO-LOCK WHERE (B-RUTAG.flgest = "N" AND B-RUTAG.Libre_c02 = "R"),
                FIRST B-CMOV WHERE B-CMOV.CodCia = B-RutaG.CodCia
                    AND B-CMOV.CodAlm = B-RutaG.CodAlm
                    AND B-CMOV.TipMov = B-RutaG.Tipmov
                    AND B-CMOV.CodMov = B-RutaG.Codmov
                    AND B-CMOV.NroSer = B-RutaG.serref
                    AND B-CMOV.NroDoc = B-RutaG.nroref
                    AND B-CMOV.CodRef = Almcmov.CodRef
                    AND B-CMOV.NroRef = Almcmov.NroRef: 
                x-Guias-2 = x-Guias-2 + 1.
            END.
            /* ******************************************************************************************** */
            /* TODAS HAN SIDO "NO ENTREGADAS" */
            /* RHC 29/05/18 Si se repite el ciclo chancamos la anterior */
            /* ******************************************************************************************** */
            IF x-Guias = x-Guias-2 THEN DO:
                ASSIGN
                    x-CodDiv = DI-RutaC.CodDiv      /* Por Defecto */
                    x-Motivo = DI-RutaD.FlgEstDet
                    x-CodHR  = DI-RutaC.CodDoc    /* H/R */
                    x-NroHR  = DI-RutaC.NroDoc.
                FIND Almcdocu WHERE AlmCDocu.CodCia = s-CodCia
                    AND AlmCDocu.CodLlave = DI-RutaC.CodDiv         /* OJO */
                    AND AlmCDocu.CodDoc = Almcmov.CodRef            /* OTR */
                    AND AlmCDocu.NroDoc = Almcmov.Nroref
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Almcdocu THEN DO:
                    FIND CURRENT Almcdocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                    IF ERROR-STATUS:ERROR = YES THEN DO:
                        MESSAGE 'Tabla Almcdocu en uso por otro usuario' VIEW-AS ALERT-BOX ERROR.
                        UNDO RLOOP, RETURN 'ADM-ERROR'.
                    END.
                END.
                ELSE CREATE Almcdocu.
                ASSIGN
                    AlmCDocu.CodCia = s-CodCia
                    AlmCDocu.CodLlave = DI-RutaC.CodDiv     /* OJO */
                    AlmCDocu.CodDoc = Almcmov.CodRef        /* OTR */
                    AlmCDocu.NroDoc = Almcmov.NroRef
                    AlmCDocu.FchDoc = TODAY
                    AlmCDocu.FchCreacion = TODAY
                    AlmCDocu.FlgEst = "P"       /* "P": por reprogramar, "C": reprogramado, "A": no se reprograma */
                    AlmCDocu.UsrCreacion = s-user-id
                    AlmCDocu.Libre_c01 = x-CodHR            /* H/R */
                    AlmCDocu.Libre_c02 = x-NroHR
                    AlmCDocu.Libre_c03 = x-Motivo           /* Motivo */
                    AlmCDocu.Libre_d01 = x-ImpTot
                    AlmCDocu.Libre_d02 = x-Peso
                    AlmCDocu.Libre_d03 = x-Volumen
                    NO-ERROR.
                IF ERROR-STATUS:ERROR = YES THEN DO:
                    MESSAGE 'Tabla Almcdocu error en la llave' VIEW-AS ALERT-BOX ERROR.
                    UNDO RLOOP, RETURN 'ADM-ERROR'.
                END.
                /* ********************************************************************************************** */
                /* RHC 08/03/2019 Actualizamos CONTROL de PHR */
                /* ********************************************************************************************** */
                IF ENTRY(1, DI-RutaC.Libre_c03) = "PHR" THEN DO:
                    FIND B-PHRD WHERE B-PHRD.codcia = DI-RutaC.codcia
                        AND B-PHRD.coddiv = DI-RutaC.coddiv
                        AND B-PHRD.coddoc = ENTRY(1, DI-RutaC.libre_c03)
                        AND B-PHRD.nrodoc = ENTRY(2, DI-RutaC.libre_c03)
                        AND B-PHRD.CodRef = Almcmov.CodRef      /* OTR */
                        AND B-PHRD.NroRef = Almcmov.NroRef EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                    IF ERROR-STATUS:ERROR = YES THEN DO:
                        MESSAGE 'Registro de OTR en uso por otro usuario' VIEW-AS ALERT-BOX ERROR.
                        UNDO RLOOP, RETURN 'ADM-ERROR'.
                    END.
                    ASSIGN
                        B-PHRD.FlgEst = "P".    /* Regresa a EN PROCESO hasta definir su REPROGRAMACION */
                END.
            END.
        END.
    END.
END.
IF AVAILABLE(Almcdocu) THEN RELEASE Almcdocu.
IF AVAILABLE(B-PHRD)   THEN RELEASE B-PHRD.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HR_Verifica-Estibadores) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HR_Verifica-Estibadores Procedure 
PROCEDURE HR_Verifica-Estibadores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pAdmNewRecord AS CHAR.
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.
DEF INPUT PARAMETER pResponsable AS CHAR.
DEF INPUT PARAMETER pEstibadores AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.


DEF BUFFER B-RUTAC FOR DI-RutaC.
DEF VAR k AS INTE NO-UNDO.
DEF VAR j AS INTE NO-UNDO.

&SCOPED-DEFINE Condicion-1 (B-RUTAC.codcia = s-codcia AND ~
    B-RUTAC.coddiv = pCodDiv AND ~
    B-RUTAC.coddoc = pCodDoc AND ~
    B-RUTAC.nrodoc <> pNroDoc AND ~
    LOOKUP(B-RUTAC.FlgEst, 'PR,C,A,L') = 0 )

&SCOPED-DEFINE Condicion-2 (B-RUTAC.codcia = s-codcia AND ~
    B-RUTAC.coddiv = pCodDiv AND ~
    B-RUTAC.coddoc = pCodDoc AND ~
    LOOKUP(B-RUTAC.FlgEst, 'PR,C,A,L') = 0)

DEF VAR pNombre AS CHAR NO-UNDO.
DEF VAR pOrigen AS CHAR NO-UNDO.

pMensaje = ''.
CASE TRUE:
    WHEN pAdmNewRecord = "NO" THEN DO:  /* UPDATE H/R */
        /* Buscamos si se repite una ocurrencia, excepto en el mismo registro */
        /* Responsable */
        /* RHC 07/11/2019 El Responsable SIEMPRE es PROPIO
           Sin Control: Solicitado por Diego Lay */
        IF pResponsable > '' THEN DO:
/*             FIND FIRST B-RUTAC WHERE {&Condicion-1} AND B-RUTAC.responsable = pResponsable        */
/*                 NO-LOCK NO-ERROR.                                                                 */
/*             IF AVAILABLE B-RUTAC THEN DO:                                                         */
/*                 pMensaje = "Responsable YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc. */
/*                 RETURN.                                                                           */
/*             END.                                                                                  */
        END.
        /* Verificamos cada Ayudantes */
        DO k = 1 TO NUM-ENTRIES(pEstibadores):
            /* ************************************************ */
            /* RHC 07/11/19 Diego Lay: NO consistenciar PROPIOS */
            /* ************************************************ */
            RUN logis/p-busca-por-dni (INPUT ENTRY(k, pEstibadores),
                                       OUTPUT pNombre,
                                       OUTPUT pOrigen).
            IF pOrigen BEGINS 'PROPIO' THEN NEXT.
            /* ************************************************ */
            /* Buscamos desde el Ayudante-1 hasta el Ayudantre-7 */
            /* ************************************************ */
            DO j = 1 TO 7:
                CASE j:
                    WHEN 1 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-1} AND B-RUTAC.Ayudante-1 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 2 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-1} AND B-RUTAC.Ayudante-2 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 3 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-1} AND B-RUTAC.Ayudante-3 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 4 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-1} AND B-RUTAC.Ayudante-4 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 5 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-1} AND B-RUTAC.Ayudante-5 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 6 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-1} AND B-RUTAC.Ayudante-6 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 7 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-1} AND B-RUTAC.Ayudante-7 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                END CASE.
            END.    /* DO j = */
        END.    /* DO k = */
    END.
    WHEN pAdmNewRecord = "YES" THEN DO:
        /* Buscamos si se repite una ocurrencia */
        /* Responsable */
        /* RHC 07/11/2019 El Responsable SIEMPRE es PROPIO
           Sin Control: Solicitado por Diego Lay */
        IF pResponsable > '' THEN DO:
/*             FIND FIRST B-RUTAC WHERE {&Condicion-2} AND B-RUTAC.responsable = pResponsable        */
/*                 NO-LOCK NO-ERROR.                                                                 */
/*             IF AVAILABLE B-RUTAC THEN DO:                                                         */
/*                 pMensaje = "Responsable YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc. */
/*                 RETURN.                                                                           */
/*             END.                                                                                  */
        END.
        /* Verificamos cada Ayudantes */
        DO k = 1 TO NUM-ENTRIES(pEstibadores):
            /* ************************************************ */
            /* RHC 07/11/19 Diego Lay: NO consistenciar PROPIOS */
            /* ************************************************ */
            RUN logis/p-busca-por-dni (INPUT ENTRY(k, pEstibadores),
                                       OUTPUT pNombre,
                                       OUTPUT pOrigen).
            IF pOrigen BEGINS 'PROPIO' THEN NEXT.
            /* ************************************************ */
            /* Buscamos desde el Ayudante-1 hasta el Ayudantre-7 */
            /* ************************************************ */
            DO j = 1 TO 7:
                CASE j:
                    WHEN 1 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-2} AND B-RUTAC.Ayudante-1 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 2 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-2} AND B-RUTAC.Ayudante-2 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 3 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-2} AND B-RUTAC.Ayudante-3 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 4 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-2} AND B-RUTAC.Ayudante-4 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 5 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-2} AND B-RUTAC.Ayudante-5 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 6 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-2} AND B-RUTAC.Ayudante-6 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 7 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-2} AND B-RUTAC.Ayudante-7 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                END CASE.
            END.
        END.
    END.
END CASE.   /* CASE TRUE */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HR_Verifica-Estibadores-Old) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HR_Verifica-Estibadores-Old Procedure 
PROCEDURE HR_Verifica-Estibadores-Old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pAdmNewRecord AS CHAR.
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.
DEF INPUT PARAMETER pResponsable AS CHAR.
DEF INPUT PARAMETER pEstibadores AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.


DEF BUFFER B-RUTAC FOR DI-RutaC.
DEF VAR k AS INTE NO-UNDO.
DEF VAR j AS INTE NO-UNDO.

&SCOPED-DEFINE Condicion-1 (B-RUTAC.codcia = s-codcia AND ~
    B-RUTAC.coddiv = pCodDiv AND ~
    B-RUTAC.coddoc = pCodDoc AND ~
    B-RUTAC.nrodoc <> pNroDoc AND ~
    LOOKUP(B-RUTAC.FlgEst, 'PR,C,A,L') = 0 )

&SCOPED-DEFINE Condicion-2 (B-RUTAC.codcia = s-codcia AND ~
    B-RUTAC.coddiv = pCodDiv AND ~
    B-RUTAC.coddoc = pCodDoc AND ~
    LOOKUP(B-RUTAC.FlgEst, 'PR,C,A,L') = 0)

pMensaje = ''.
CASE TRUE:
    WHEN pAdmNewRecord = "NO" THEN DO:
        /* Buscamos si se repite una ocurrencia, excepto en el mismo registro */
        /* Responsable */
        IF pResponsable > '' THEN DO:
            FIND FIRST B-RUTAC WHERE {&Condicion-1} AND B-RUTAC.responsable = pResponsable
                NO-LOCK NO-ERROR.
            IF AVAILABLE B-RUTAC THEN DO:
                pMensaje = "Responsable YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                RETURN.
            END.
        END.
        /* Verificamos cada Ayudantes */
        DO k = 1 TO NUM-ENTRIES(pEstibadores):
            /* Buscamos desde el Ayudante-1 hasta el Ayudantre-7 */
            DO j = 1 TO 7:
                CASE j:
                    WHEN 1 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-1} AND B-RUTAC.Ayudante-1 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 2 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-1} AND B-RUTAC.Ayudante-2 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 3 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-1} AND B-RUTAC.Ayudante-3 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 4 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-1} AND B-RUTAC.Ayudante-4 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 5 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-1} AND B-RUTAC.Ayudante-5 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 6 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-1} AND B-RUTAC.Ayudante-6 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 7 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-1} AND B-RUTAC.Ayudante-7 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                END CASE.
            END.    /* DO j = */
        END.    /* DO k = */
    END.
    WHEN pAdmNewRecord = "YES" THEN DO:
        /* Buscamos si se repite una ocurrencia */
        /* Responsable */
        IF pResponsable > '' THEN DO:
            FIND FIRST B-RUTAC WHERE {&Condicion-2} AND B-RUTAC.responsable = pResponsable
                NO-LOCK NO-ERROR.
            IF AVAILABLE B-RUTAC THEN DO:
                pMensaje = "Responsable YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                RETURN.
            END.
        END.
        /* Verificamos cada Ayudantes */
        DO k = 1 TO NUM-ENTRIES(pEstibadores):
            /* Buscamos desde el Ayudante-1 hasta el Ayudantre-7 */
            DO j = 1 TO 7:
                CASE j:
                    WHEN 1 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-2} AND B-RUTAC.Ayudante-1 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 2 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-2} AND B-RUTAC.Ayudante-2 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 3 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-2} AND B-RUTAC.Ayudante-3 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 4 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-2} AND B-RUTAC.Ayudante-4 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 5 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-2} AND B-RUTAC.Ayudante-5 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 6 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-2} AND B-RUTAC.Ayudante-6 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                    WHEN 7 THEN DO:
                        FIND FIRST B-RUTAC WHERE {&Condicion-2} AND B-RUTAC.Ayudante-7 = ENTRY(k, pEstibadores)
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE B-RUTAC THEN DO:
                            pMensaje = "Ayudante " + ENTRY(k, pEstibadores) + 
                                " YA digitado en " + B-RUTAC.CodDoc + " " + B-RUTAC.NroDoc.
                            RETURN.
                        END.
                    END.
                END CASE.
            END.
        END.
    END.
END CASE.   /* CASE TRUE */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HR_Verifica-RutaD) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HR_Verifica-RutaD Procedure 
PROCEDURE HR_Verifica-RutaD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pVerError AS LOG.

FIND DI-RutaC WHERE ROWID(DI-RutaC) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE DI-RutaC THEN RETURN 'ADM-ERROR'.

DEF BUFFER FACTURA FOR Ccbcdocu.

FOR EACH DI-RutaD OF DI-RutaC NO-LOCK:
    /* RHC 21.05.11 control de actualizacion del estado del documento */
    IF di-rutad.flgest = 'P' THEN DO:
        IF pVerError = YES THEN MESSAGE 'ERROR Hoja de Ruta' Di-rutac.nrodoc SKIP
            'Antes debe actualizar el estado del documento' di-rutad.codref di-rutad.nroref
            VIEW-AS ALERT-BOX WARNING.
        RETURN 'ADM-ERROR'.
    END.
    IF Di-RutaD.FLgEst <> 'N' THEN DO:
        IF DI-RutaD.HorLle = '' THEN DO:
            IF pVerError = YES THEN MESSAGE 'ERROR Hoja de Ruta' Di-rutac.nrodoc SKIP
                'Debe ingresar la hora en las Facturas y Boletas'
                VIEW-AS ALERT-BOX WARNING.
            RETURN 'ADM-ERROR'.
        END.
        IF DI-RutaD.HorPar = '' THEN DO:
            IF pVerError = YES THEN MESSAGE 'ERROR Hoja de Ruta' Di-rutac.nrodoc SKIP
                'Debe ingresar la hora en las Facturas y Boletas'
                VIEW-AS ALERT-BOX WARNING.
            RETURN 'ADM-ERROR'.
        END.
    END.
    /* RHC Referencias cruzadas */
    FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia AND
        Ccbcdocu.coddiv = DI-RutaC.CodDiv AND
        Ccbcdocu.coddoc = DI-RutaD.CodRef AND               /* G/R */
        Ccbcdocu.nrodoc = DI-RutaD.NroRef NO-LOCK.
    FIND FIRST FACTURA WHERE FACTURA.codcia = s-codcia AND
        /*FACTURA.coddiv = Ccbcdocu.coddiv AND */
        FACTURA.coddoc = Ccbcdocu.codref AND
        FACTURA.nrodoc = Ccbcdocu.nroref NO-LOCK NO-ERROR.
    CASE DI-RutaD.FlgEst:
        WHEN "C" THEN DO:       /* Entregado: NO debe tener ingreso al almacén */
            FOR EACH Almcmov NO-LOCK WHERE Almcmov.codcia = s-codcia AND
                Almcmov.tipmov = 'I' AND
                Almcmov.codmov = 09  AND
                Almcmov.codref = FACTURA.coddoc AND
                Almcmov.nroref = FACTURA.nrodoc AND
                /*CAN-FIND(FIRST Almacen OF Almcmov WHERE Almacen.coddiv = s-coddiv NO-LOCK) AND*/
                Almcmov.flgest <> 'A':
                /* Veamos si coincide el artículo */
                FOR EACH Almdmov OF Almcmov NO-LOCK:
                    FIND FIRST Ccbddocu OF Ccbcdocu WHERE Ccbddocu.codmat = Almdmov.codmat
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE Ccbddocu THEN DO:
                        IF pVerError = YES THEN MESSAGE 'ERROR Hoja de Ruta' Di-rutac.nrodoc SKIP
                            'La' DI-RutaD.CodRef DI-RutaD.NroRef 'tiene un parte de ingreso en almacén'
                            VIEW-AS ALERT-BOX ERROR.
                        RETURN 'ADM-ERROR'.
                    END.
                END.
            END.
        END.
        WHEN "N" THEN DO:       /* NO Entregado: Debe tener una devolución TOTAL en almacén */
            IF DI-RutaD.Libre_c02 = "A" THEN DO:    /* NO REPROGRAMADO */
                FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
                    FIND FIRST Almcmov WHERE Almcmov.codcia = s-codcia AND
                        Almcmov.tipmov = 'I' AND
                        Almcmov.codmov = 09 AND
                        Almcmov.codref = FACTURA.coddoc AND
                        Almcmov.nroref = FACTURA.nrodoc AND
                        Almcmov.flgest <> 'A' AND
                        /*CAN-FIND(FIRST Almacen OF Almcmov WHERE Almacen.coddiv = s-coddiv NO-LOCK) AND*/
                        CAN-FIND(FIRST Almdmov OF Almcmov WHERE Almdmov.codmat = Ccbddocu.codmat AND
                                 ((Almdmov.candes * Almdmov.factor) >= (Ccbddocu.candes * Ccbddocu.factor))
                                 NO-LOCK)
                        NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE Almcmov THEN DO:
                        IF pVerError = YES THEN MESSAGE 'ERROR Hoja de Ruta' Di-rutac.nrodoc SKIP
                            'La' DI-RutaD.CodRef DI-RutaD.NroRef 'debería tener un parte de ingreso en almacén'
                            VIEW-AS ALERT-BOX ERROR.
                        RETURN 'ADM-ERROR'.
                    END.
                END.
            END.
        END.
    END CASE.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HR_Verifica-RutaDG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HR_Verifica-RutaDG Procedure 
PROCEDURE HR_Verifica-RutaDG :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pVerError AS LOG.

FIND DI-RutaC WHERE ROWID(DI-RutaC) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE DI-RutaC THEN RETURN 'ADM-ERROR'.

FOR EACH di-rutadg OF di-rutac NO-LOCK WHERE di-rutadg.flgest = 'P':
    IF pVerError = YES THEN MESSAGE 'ERROR Hoja de Ruta' Di-rutac.nrodoc SKIP
        'Antes debe actualizar el estado del documento' di-rutadg.codref di-rutadg.nroref
        VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.
FOR EACH Di-RutaDG OF Di-RutaC WHERE Di-RutaDG.FlgEst <> 'N' NO-LOCK:
  IF DI-RutaDG.HorLle = '' THEN DO:
      IF pVerError = YES THEN MESSAGE 'ERROR Hoja de Ruta' Di-rutac.nrodoc SKIP
          'Debe ingresar la hora en las Guias Itinerantes'
          VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  IF DI-RutaDG.HorPar = '' THEN DO:
      IF pVerError = YES THEN MESSAGE 'ERROR Hoja de Ruta' Di-rutac.nrodoc SKIP
          'Debe ingresar la hora en las Guias Itinerantes'
          VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HR_Verifica-RutaG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HR_Verifica-RutaG Procedure 
PROCEDURE HR_Verifica-RutaG :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pVerError AS LOG.

FIND DI-RutaC WHERE ROWID(DI-RutaC) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE DI-RutaC THEN RETURN 'ADM-ERROR'.

FOR EACH di-rutag OF di-rutac NO-LOCK WHERE di-rutag.flgest = 'P':
    IF pVerError = YES THEN MESSAGE 'ERROR Hoja de Ruta' Di-rutac.nrodoc SKIP
        'Antes debe actualizar el estado del documento G/R' di-rutag.serref di-rutag.nroref
        VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.
FOR EACH Di-RutaG OF Di-RutaC WHERE Di-RutaG.FlgEst <> 'N' NO-LOCK:
  IF DI-RutaG.HorLle = '' THEN DO:
      IF pVerError = YES THEN MESSAGE 'ERROR Hoja de Ruta' Di-rutac.nrodoc SKIP
          'Debe ingresar la hora en las Transferencias'
          VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  IF DI-RutaG.HorPar = '' THEN DO:
      IF pVerError = YES THEN MESSAGE 'ERROR Hoja de Ruta' Di-rutac.nrodoc SKIP
          'Debe ingresar la hora en las Transferencias'
          VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Import-PHR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Import-PHR Procedure 
PROCEDURE Import-PHR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRegistro AS ROWID.
DEF OUTPUT PARAMETER pRowid AS ROWID.

DEF VAR pBloqueados AS INT NO-UNDO.
DEF VAR pTotales AS INT NO-UNDO.
DEF VAR pMensaje AS CHAR INIT '' NO-UNDO.

FIND B-RUTAC WHERE ROWID(B-RUTAC) = pRegistro NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-RUTAC OR B-RUTAC.FlgEst <> "P" THEN DO:
    MESSAGE 'YA no está disponible la Pre-Hoja de Ruta' SKIP 'Proceso Abortado'
        VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.

/* Paso 1: Verificar que pase al menos una O/D u OTR */
EMPTY TEMP-TABLE T-RutaD.   /* TODOS LOS QUE NO SE VAN MIGRAR */
RUN Import-PHR-Validate (OUTPUT pBloqueados, OUTPUT pTotales, OUTPUT pMensaje).
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
/* Mensaje con la información que NO va a ser migrada */
DEF VAR pOk AS LOG NO-UNDO.
RUN dist/d-mantto-phr-del.w(pTotales, pBloqueados, INPUT TABLE T-RutaD,OUTPUT pOk).
IF pOk = NO THEN RETURN 'ADM-ERROR'.
IF pTotales = pBloqueados THEN DO:
    MESSAGE 'TODOS los documentos tienen observaciones' SKIP
        'Proceso abortado' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.

/* **************************************************************************** */
/* 2do. Generamos la Hoja de Ruta */
/* **************************************************************************** */
DEF VAR s-coddoc AS CHAR INIT 'H/R'.

DEF VAR pStatus AS CHAR NO-UNDO.
DEF VAR x-Cuenta AS INT NO-UNDO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    /* Blooqueamos Correlativo */
    {lib/lock-genericov3.i ~
        &Tabla="FacCorre" ~
        &Alcance="FIRST" ~
        &Condicion="FacCorre.CodCia = S-CODCIA  ~
        AND FacCorre.CodDiv = S-CODDIV ~
        AND FacCorre.CodDoc = S-CODDOC" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, LEAVE" ~
        }
    /* Bloqueamos PHR */
    FIND CURRENT B-RUTAC EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
        UNDO, LEAVE.
    END.
    IF B-RUTAC.FlgEst <> "P" THEN DO:
        pMensaje = 'YA no está disponible la Pre-Hoja de Ruta'.
        UNDO, LEAVE.
    END.
    /* Marcamos la información que NO va a ser migrada */
    FOR EACH T-RutaD NO-LOCK ON ERROR UNDO, THROW:
        FIND B-RutaD WHERE B-RutaD.CodCia = T-RutaD.CodCia
            AND B-RutaD.CodDiv = T-RutaD.CodDiv
            AND B-RutaD.CodDoc = T-RutaD.CodDoc
            AND B-RutaD.NroDoc = T-RutaD.NroDoc
            AND B-RutaD.CodRef = T-RutaD.CodRef
            AND B-RutaD.NroRef = T-RutaD.NroRef
            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR THEN DO:
            {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
            UNDO RLOOP, LEAVE RLOOP.
        END.
        ASSIGN
            B-RutaD.FlgEst = "A".    /* Marcamos como ANULADO */
        /*DELETE B-RutaD.*/
    END.
    /* ************************************************ */
    /* Creamos la H/R */
    /* ************************************************ */
    CREATE DI-RutaC.
    ASSIGN
        DI-RutaC.CodCia = s-codcia
        DI-RutaC.CodDiv = s-coddiv
        DI-RutaC.CodDoc = s-coddoc
        DI-RutaC.FchDoc = TODAY
        DI-RutaC.NroDoc = STRING(FacCorre.nroser, '999') + STRING(FacCorre.correlativo, '999999')
        DI-RutaC.usuario = s-user-id
        DI-RutaC.flgest  = "P"      /* Pendiente */
        DI-RutaC.Libre_L02 = NO     /* Por Importación de PHR */
        DI-RutaC.Libre_c03 = B-RUTAC.CodDoc + ',' + B-RUTAC.NroDoc  /* PARA EXTORNAR */
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
        UNDO RLOOP, LEAVE RLOOP.
    END.
    /* Información Adicional */
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.

    pRowid = ROWID(DI-RutaC).
    /* ************************************************ */
    /* Barremos las O/D y OTR Válidas de la PHR  */
    /* ************************************************ */
    FOR EACH B-RutaD EXCLUSIVE-LOCK WHERE B-RutaD.CodCia = B-RutaC.CodCia
        AND B-RutaD.CodDiv = B-RutaC.CodDiv
        AND B-RutaD.CodDoc = B-RutaC.CodDoc
        AND B-RutaD.NroDoc = B-RutaC.NroDoc
        AND B-RutaD.FlgEst <> "A" ON ERROR UNDO, THROW:
        pStatus = "*".  /* <<< OJO <<< */
        CASE B-RutaD.CodRef:
            WHEN "O/D" OR WHEN "O/M" THEN DO:
                RUN Import-PHR-GRV (OUTPUT pStatus).
                IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                    pMensaje = 'ERROR al grabar la ' + B-RutaD.CodRef + ' ' + B-RutaD.NroRef.
                    UNDO RLOOP, LEAVE RLOOP.
                END.
            END.
            WHEN "OTR" THEN DO:
                RUN Import-PHR-GRT (OUTPUT pStatus).
                IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                    pMensaje = 'ERROR al grabar la ' + B-RutaD.CodRef + ' ' + B-RutaD.NroRef.
                    UNDO RLOOP, LEAVE RLOOP.
                END.
            END.
        END CASE.
        ASSIGN
            B-RutaD.FlgEst = pStatus.   /* OJO */
    END.
    /* Verificamos que haya pasado al menos un registro */
    FIND FIRST Di-RutaD OF Di-RutaC NO-LOCK NO-ERROR.
    FIND FIRST Di-RutaG OF Di-RutaC NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Di-RutaD AND NOT AVAILABLE Di-RutaG THEN DO:
        pMensaje = "NO se ha generado ningun registro para la Hoja de Ruta" + CHR(10) +
            "Proceso Abortado".
        UNDO, LEAVE.
    END.
    /* Final */
    ASSIGN 
        B-RUTAC.FlgEst = "C"
        B-RUTAC.CodRef = DI-RutaC.CodDoc
        B-RUTAC.NroRef = DI-RutaC.NroDoc.   /* OJO: Campo Relacionado */
    /* ************************************************ */
    /* RHC 17.09.11 Control de G/R por pedidos */
    /* ************************************************ */
    
    RUN dist/p-rut001 ( ROWID(Di-RutaC), YES ).
    
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, LEAVE.
    /* ************************************************ */
    FIND CURRENT Di-RutaC EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
        UNDO RLOOP, LEAVE RLOOP.
    END.
    IF Di-RutaC.FlgEst <> "P" THEN DO:
        pMensaje = "No están completos los comprobantes" + CHR(10) + "Proceso abortado".
        UNDO, LEAVE.
    END.
END.
IF AVAILABLE(Faccorre) THEN RELEASE Faccorre.
IF AVAILABLE(B-RUTAC)  THEN RELEASE B-RUTAC.
IF AVAILABLE(DI-RutaC) THEN RELEASE DI-RutaC.
IF AVAILABLE(DI-RutaG) THEN RELEASE DI-RutaG.
IF pMensaje > '' THEN DO:
    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Import-PHR-GRT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Import-PHR-GRT Procedure 
PROCEDURE Import-PHR-GRT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pStatus AS CHAR.
ASSIGN
    pStatus = "*".  /* Valor por Defecto */

DEF BUFFER ORDENES FOR Faccpedi.

DEFINE VAR lPesos AS DEC.
DEFINE VAR lCosto AS DEC.
DEFINE VAR lVolumen AS DEC.    
DEFINE VAR lValorizado AS LOGICAL.

DEFINE VAR lCodDoc AS CHAR.
DEFINE VAR lNroDoc AS CHAR.
DEFINE VAR lComa AS CHAR.
DEFINE VAR lPaletadespachada AS LOG.
DEFINE VAR lRowId AS ROWID.

DISABLE TRIGGERS FOR LOAD OF vtadtabla.
DISABLE TRIGGERS FOR LOAD OF vtactabla.
DISABLE TRIGGERS FOR LOAD OF vtatabla.

DEFINE BUFFER z-vtadtabla FOR vtadtabla.
DEFINE VAR lRowIdx AS ROWID.

DEF BUFFER B-vtadtabla FOR vtadtabla.
DEF BUFFER B-vtactabla FOR vtactabla.

/* Buscamos la ORDEN (OTR) */
FIND ORDENES WHERE ORDENES.codcia = s-codcia
    AND ORDENES.coddoc = B-RutaD.CodRef
    AND ORDENES.nroped = B-RutaD.NroRef
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE ORDENES THEN RETURN 'ADM-ERROR'.
FOR EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = s-CodCia
    AND Almcmov.CodRef = ORDENES.CodDoc
    AND Almcmov.NroRef = ORDENES.NroPed
    AND Almcmov.TipMov = "S"
    AND Almcmov.CodMov = 03
    AND Almcmov.FlgEst <> "A",
    FIRST Almacen OF Almcmov NO-LOCK WHERE Almacen.coddiv = s-CodDiv:
    /* ********************************************************************** */
    /* RHC 01/07/2019 SI tiene un I-30 (REPROGRAMACION) => NO tomar en cuenta */
    /* ********************************************************************** */
    IF Almcmov.FlgEst = "R" THEN NEXT.
    /* ********************************************************************** */
    /* ********************************************************************** */
    ASSIGN
        pStatus = "P".  /* Correcto */
    CREATE Di-RutaG.
    ASSIGN 
        Di-RutaG.CodCia = Di-RutaC.CodCia
        Di-RutaG.CodDiv = Di-RutaC.CodDiv
        Di-RutaG.CodDoc = Di-RutaC.CodDoc
        Di-RutaG.NroDoc = Di-RutaC.NroDoc
        Di-RutaG.Tipmov = Almcmov.TipMov
        Di-RutaG.CodMov = Almcmov.CodMov
        Di-RutaG.CodAlm = Almcmov.CodAlm
        Di-RutaG.serref = Almcmov.NroSer
        Di-RutaG.nroref = Almcmov.NroDoc
        .
    /* Guardos los pesos y el costo de Mov. Almacen - Ic 10Jul2013 */
    lPesos = 0.
    lCosto = 0.
    lVolumen = 0.
    FOR EACH Almdmov OF Almcmov NO-LOCK:
        /* Costo */
        FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia 
            AND AlmStkGe.codmat = almdmov.codmat 
            AND AlmStkGe.fecha <= DI-RutaC.Fchdoc NO-LOCK NO-ERROR.
        lValorizado = NO.
        IF AVAILABLE AlmStkGe THEN DO:
            /* Ic - 29Mar2017
            Correo de Luis Figueroa 28Mar2017
            De: Luis Figueroa [mailto:lfigueroa@continentalperu.com] 
            Enviado el: martes, 28 de marzo de 2017 08:59 p.m.
            
            Enrique:
            Para el cálculo del  valorizado de las transferencias internas por favor utilizar el costo y no el precio de venta
            Esto ya lo aprobó PW            
            */
            /* Costo KARDEX */
            IF AlmStkGe.CtoUni <> ? THEN DO:
                lCosto = lCosto + (AlmStkGe.CtoUni * AlmDmov.candes * AlmDmov.factor).
                lValorizado = YES.
            END.
        END.
        /* 
        Ic - 28Feb2015 : Felix Perez indico que se valorize con el precio de venta
        Ic - 29Mar2017, se dejo sin efecto lo anterior (Felix Perez)
        */
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
            almmmatg.codmat = almdmov.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE almmmatg THEN DO:
            lVolumen = lVolumen + ( Almdmov.candes * ( almmmatg.libre_d02 / 1000000)).
            lPesos = lPesos + (almmmatg.pesmat * almdmov.candes).
        END.
        /* Volumen */
        IF lValorizado = NO THEN DO:
            IF AVAILABLE almmmatg THEN DO :
                /* Si tiene valorzacion CERO, cargo el precio de venta */
                IF lValorizado = NO THEN DO:
                    IF almmmatg.monvta = 2 THEN DO:
                        /* Dolares */
                        lCosto = lCosto + ((Almmmatg.preofi * Almmmatg.tpocmb) * AlmDmov.candes * Almdmov.factor).
                    END.
                    ELSE lCosto = lCosto + (Almmmatg.preofi * AlmDmov.candes * Almdmov.factor).
                END.
            END.
        END.
    END.
    ASSIGN 
        Di-RutaG.libre_d01 = lPesos
        Di-RutaG.libre_d02 = lCosto
        Di-RutaG.libre_d03 = lVolumen.

    /*      R A C K S      */
    IF almcmov.codref = 'OTR' THEN DO:
        /* Orden de Transferencia */
        lCodDoc = almcmov.codref.
        lNroDoc = almcmov.nroref.
    END.
    ELSE DO:
        /* Transferencia entre almacenes */
        lCodDoc = 'TRA'.
        lNroDoc = STRING(almcmov.nroser,"999") + STRING(almcmov.nrodoc,"999999").
    END.
    /* Chequeo si la O/D esta en el detalle del RACK */
    FIND FIRST vtadtabla WHERE vtadtabla.codcia = DI-RutaC.codcia AND
          vtadtabla.tabla = 'MOV-RACK-DTL' AND 
          vtadtabla.libre_c03 = lCodDoc AND 
          vtadtabla.llavedetalle = lNroDoc NO-LOCK NO-ERROR.
    IF AVAILABLE vtadtabla THEN DO:
        lComa = "".
        IF (vtadtabla.libre_c05 = ? OR TRIM(vtadtabla.libre_c05) = "") THEN DO:
            lComa = "".
        END.                
        ELSE DO :
            lComa = TRIM(vtadtabla.libre_c05).
        END.
        /* Grabo la Hoja de Ruta */
        IF lComa = "" THEN DO:
            lComa = trim(Di-RutaC.nrodoc).
        END.
        ELSE DO:
            lComa = lComa + ", " + trim(Di-RutaC.nrodoc).
        END.
        lRowIdx = ROWID(vtadtabla).
        FIND FIRST z-vtadtabla WHERE ROWID(z-vtadtabla) = lRowidx EXCLUSIVE NO-ERROR.
        IF AVAILABLE z-vtadtabla THEN DO:
            ASSIGN z-vtadtabla.libre_c05 = lComa.
        END.       
        RELEASE z-vtadtabla.
        /* * */
        FIND FIRST vtactabla WHERE vtactabla.codcia = s-codcia AND 
                    vtactabla.tabla = "MOV-RACK-HDR" AND 
                    vtactabla.llave BEGINS vtadtabla.llave AND 
                    vtactabla.libre_c02 = vtadtabla.tipo NO-LOCK NO-ERROR.
        IF AVAILABLE vtactabla THEN DO:
            /* Grabo el RACK en DI-RUTAG */
            ASSIGN Di-RutaG.libre_c05 = vtactabla.libre_c01.
            lPaletadespachada = YES.
            FOR EACH b-vtadtabla WHERE b-vtadtabla.codcia = s-codcia AND 
                    b-vtadtabla.tabla = "MOV-RACK-DTL" AND 
                    b-vtadtabla.llave = vtadtabla.llave AND 
                    b-vtadtabla.tipo = vtadtabla.tipo NO-LOCK :
                IF (b-vtadtabla.libre_c05 = ? OR b-vtadtabla.libre_c05 = "") THEN lPaletadespachada = NO.
            END.
            RELEASE B-vtadtabla.
            IF lPaletadespachada = YES THEN DO:
                /* Todos los O/D, OTR, TRA de la paleta tienen HR (Hoja de Ruta) */
                FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                            vtatabla.tabla = 'RACKS' AND 
                            vtatabla.llave_c1 = vtadtabla.llave AND
                            vtatabla.llave_c2 = vtactabla.libre_c01 EXCLUSIVE NO-ERROR.
                IF AVAILABLE vtatabla THEN DO:
                    ASSIGN vtatabla.valor[2] = vtatabla.valor[2] - 1.
                    ASSIGN vtatabla.valor[2] = IF (vtatabla.valor[2] < 0) THEN 0 ELSE vtatabla.valor[2].
                END.
                RELEASE vtatabla.
                /* la Paleta */
                lRowId = ROWID(vtactabla).  
                FIND B-vtactabla WHERE rowid(B-vtactabla) = lROwId EXCLUSIVE NO-ERROR.
                IF AVAILABLE B-vtactabla THEN DO:
                    ASSIGN B-vtactabla.libre_d03 =  pRCID
                            B-vtactabla.libre_f02 = TODAY
                            B-vtactabla.libre_c04 = STRING(TIME,"HH:MM:SS").
                END.                    
            END.
            RELEASE B-vtactabla.
        END.
    END.
    RELEASE DI-RutaG.
    RELEASE vtadtabla.
END.    /* EACH Almcmov */
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Import-PHR-GRV) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Import-PHR-GRV Procedure 
PROCEDURE Import-PHR-GRV :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pStatus AS CHAR.

ASSIGN
    pStatus = "*".  /* Valor por Defecto */

DEF BUFFER ORDENES FOR Faccpedi.
DEF BUFFER PEDIDO FOR Faccpedi.
DEF BUFFER bb-vtadtabla FOR vtadtabla.
DEF BUFFER z-vtadtabla FOR vtadtabla.
DEF BUFFER B-vtadtabla FOR vtadtabla.
DEF BUFFER B-vtactabla FOR vtactabla. 
    
DEFINE VAR pResumen AS CHARACTER   NO-UNDO.
DEFINE VAR iInt     AS INTEGER     NO-UNDO.
DEFINE VAR cValor   AS CHARACTER   NO-UNDO.
DEFINE VAR lRowId  AS ROWID.
DEFINE VAR lRowIdx AS ROWID.
DEFINE VAR lComa AS CHAR.
DEFINE VAR lPaletadespachada AS LOG.

DEFINE VAR x-gr-cod AS CHAR.
DEFINE VAR x-gr-nro AS CHAR.

/************************** Los RACKS  *****************************************/
DISABLE TRIGGERS FOR LOAD OF vtadtabla.
DISABLE TRIGGERS FOR LOAD OF vtactabla.
DISABLE TRIGGERS FOR LOAD OF vtatabla. 

/* Buscamos la ORDEN (O/D u O/M) */
FIND FIRST ORDENES WHERE ORDENES.codcia = s-codcia
    AND ORDENES.coddoc = B-RutaD.CodRef
    AND ORDENES.nroped = B-RutaD.NroRef
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE ORDENES THEN RETURN 'ADM-ERROR'.

/* Buscamos del PEDido: Puede ser del cliente o del 1er. tramo */
FIND FIRST PEDIDO WHERE PEDIDO.codcia = s-codcia
    AND PEDIDO.coddoc = ORDENES.CodRef
    AND PEDIDO.nroped = ORDENES.NroRef
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE PEDIDO THEN RETURN 'ADM-ERROR'.

/* Tiene Grupo de Reparto */
DEFINE VAR hProc AS HANDLE NO-UNDO.             /* Handle Libreria */
DEFINE VAR x-DeliveryGroup AS CHAR.
DEFINE VAR x-InvoiCustomerGroup AS CHAR.

RUN logis\logis-librerias.p PERSISTENT SET hProc.

/* Procedimientos */
RUN Grupo-reparto IN hProc (INPUT PEDIDO.codref, INPUT PEDIDO.nroref,   /* COT */
                            OUTPUT x-DeliveryGroup, OUTPUT x-InvoiCustomerGroup).       


DELETE PROCEDURE hProc.                 /* Release Libreria */


/* ******************************************************* */
/* Guias de remisión están relacionadas */
/* RHC 24/05/18 Buscamos al menos una G/R facturada pero que no esté en ninguna H/R */
/* RHC 19/05/2020 NO guias con flgest = 'DT' (dejado en tienda) o 'NE' (no entregado) */

FOR EACH x-Ccbcdocu NO-LOCK WHERE x-Ccbcdocu.codcia = s-codcia
    AND x-Ccbcdocu.codped = PEDIDO.coddoc
    AND x-Ccbcdocu.nroped = PEDIDO.nroped
    AND x-Ccbcdocu.FlgEst <> 'A'
    AND LOOKUP(x-Ccbcdocu.FlgEst, 'DT,NE') = 0:

    IF x-DeliveryGroup = "" OR x-InvoiCustomerGroup = "" THEN DO:
        /* FILTRO (Si el pedido tiene G/R) */
        IF NOT (x-Ccbcdocu.coddoc = 'G/R'
                AND x-CcbCDocu.Libre_c01 = ORDENES.CodDoc     /* O/D */
                AND x-CcbCDocu.Libre_c02 = ORDENES.NroPed
                AND x-Ccbcdocu.flgest = "F") THEN NEXT.
        /**/
        FIND FIRST T-OD-FAI-GR WHERE T-OD-FAI-GR.T-GR = "G/R-" + x-Ccbcdocu.nrodoc EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE T-OD-FAI-GR THEN DO:
            CREATE T-OD-FAI-GR.
                ASSIGN T-OD-FAI-GR.T-COD_OD = ORDENES.CodDoc
                            T-OD-FAI-GR.T-NRO_OD = ORDENES.NroPED
                            T-OD-FAI-GR.T-GR = "G/R-" + x-Ccbcdocu.nrodoc        /* G/R */
                            T-OD-FAI-GR.T-SWT = "NO".
        END.
    END.
    ELSE DO:
        /* Tiene Grupo de Reparto - TODAS LA G/R vienen en T-OD-FAI-GR */
        /*
        IF NOT (x-Ccbcdocu.coddoc = 'G/R'
                AND x-CcbCDocu.Libre_c01 = ORDENES.CodDoc     /* O/D */
                AND x-CcbCDocu.Libre_c02 = ORDENES.NroPed ) THEN NEXT.
        */
        IF NOT (x-Ccbcdocu.coddoc = 'G/R') THEN NEXT.
    END.

    /* G/R */
    FIND FIRST ccbcdocu WHERE ROWID(ccbcdocu) = ROWID(x-ccbcdocu) NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ccbcdocu THEN NEXT.

    FOR EACH T-OD-FAI-GR WHERE T-OD-FAI-GR.T-SWT = 'NO' BREAK BY T-OD-FAI-GR.T-GR :
        
        x-gr-cod = ENTRY(1,T-OD-FAI-GR.T-GR,"-").
        x-gr-nro = ENTRY(2,T-OD-FAI-GR.T-GR,"-").

        /* G/R unica para no duplicar */
        IF FIRST-OF(T-OD-FAI-GR.T-GR) THEN DO:
            
            FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                        ccbcdocu.coddoc = x-gr-cod AND
                                        ccbcdocu.nrodoc = x-gr-nro NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ccbcdocu THEN DO:
                ASSIGN T-OD-FAI-GR.T-SWT = 'SI'.
                NEXT.
            END.

            FIND FIRST Di-RutaD WHERE DI-RutaD.CodCia = s-CodCia                               
                AND DI-RutaD.CodDiv = s-CodDiv                                                
                AND DI-RutaD.CodDoc = "H/R"                                                   
                AND DI-RutaD.CodRef = Ccbcdocu.CodDoc   /* G/R */                             
                AND DI-RutaD.NroRef = Ccbcdocu.NroDoc                                         
                AND CAN-FIND(FIRST DI-RutaC OF DI-RutaD WHERE DI-RutaC.FlgEst <> "A" NO-LOCK) 
                NO-LOCK NO-ERROR.

            IF AVAILABLE Di-RutaD THEN DO:
                MESSAGE "Ya tiene HOJA DE RUTA".
                NEXT. /* La G/R ya tiene HR */
            END.

            ASSIGN
                pStatus = "P".  /* Correcto */
            CREATE DI-RutaD.
            ASSIGN
                DI-RutaD.CodCia = DI-RutaC.CodCia
                DI-RutaD.CodDiv = DI-RutaC.CodDiv
                DI-RutaD.CodDoc = DI-RutaC.CodDoc
                DI-RutaD.NroDoc = DI-RutaC.NroDoc.
            ASSIGN
                DI-RutaD.CodRef = Ccbcdocu.CodDoc
                DI-RutaD.NroRef = Ccbcdocu.NroDoc.

            /* Pesos y Volumenes */
            cValor = "".
            pResumen = "".
            RUN Vta/resumen-pedido.r (DI-RutaD.CodDiv, DI-RutaD.CodRef, DI-RutaD.NroRef, OUTPUT pResumen).
            pResumen = SUBSTRING(pResumen,2,(LENGTH(pResumen) - 2)).
            DO iint = 1 TO NUM-ENTRIES(pResumen,"/"):
                cValor = cValor + SUBSTRING(ENTRY(iint,pResumen,"/"),4) + ','.
            END.

            ASSIGN
                DI-RutaD.Libre_c01 = cValor.

            /* Grabamos el orden de impresion */
            ASSIGN
                DI-RutaD.Libre_d01 = 9999.
            FIND gn-clie WHERE gn-clie.codcia = cl-codcia
                AND gn-clie.codcli = ccbcdocu.codcli
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clie THEN DO:
                FIND Vtaubidiv WHERE VtaUbiDiv.CodCia = s-codcia
                    AND VtaUbiDiv.CodDiv = s-coddiv
                    AND VtaUbiDiv.CodDept = gn-clie.CodDept 
                    AND VtaUbiDiv.CodProv = gn-clie.CodProv 
                    AND VtaUbiDiv.CodDist = gn-clie.CodDist
                    NO-LOCK NO-ERROR.
                IF AVAILABLE VtaUbiDiv THEN DI-RutaD.Libre_d01 = VtaUbiDiv.Libre_d01.
            END.

            /* Chequeo si la O/D esta en el detalle del RACK */
            FIND FIRST bb-vtadtabla WHERE bb-vtadtabla.codcia = DI-RutaC.codcia AND
                bb-vtadtabla.tabla = 'MOV-RACK-DTL' AND 
                bb-vtadtabla.libre_c03 = ccbcdocu.libre_c01 AND   /* O/D, OTR, TRA */
                bb-vtadtabla.llavedetalle = ccbcdocu.libre_c02 NO-LOCK NO-ERROR. /* Nro */
            IF AVAILABLE bb-vtadtabla THEN DO:
                lComa = "".
                IF (bb-vtadtabla.libre_c05 = ? OR TRIM(bb-vtadtabla.libre_c05) = "") THEN DO:
                    lComa = "".
                END.
                ELSE DO :
                    lComa = TRIM(bb-vtadtabla.libre_c05).
                END.
                /* Grabo la Hoja de Ruta */
                IF lComa = "" THEN DO:
                    lComa = trim(Di-RutaC.nrodoc).
                END.
                ELSE DO:
                    lComa = lComa + ", " + trim(Di-RutaC.nrodoc).
                END.
                lRowIdx = ROWID(bb-vtadtabla).
                FIND FIRST z-vtadtabla WHERE ROWID(z-vtadtabla) = lRowidx EXCLUSIVE NO-ERROR.
                IF AVAILABLE z-vtadtabla  THEN DO:
                    ASSIGN z-vtadtabla.libre_c05 = lComa.            
                END.
                RELEASE z-vtadtabla.

                /* Libero RACKS Paletas */
                FIND FIRST vtactabla WHERE vtactabla.codcia = s-codcia AND 
                    vtactabla.tabla = "MOV-RACK-HDR" AND 
                    vtactabla.llave BEGINS bb-vtadtabla.llave AND 
                    vtactabla.libre_c02 = bb-vtadtabla.tipo NO-LOCK NO-ERROR.
                IF AVAILABLE vtactabla THEN DO:
                    /* Grabo el RACK en la RI-RUTAD */
                    ASSIGN DI-RutaD.libre_c05 = vtactabla.libre_c01.
                    /* Chequeo si todo el detalle de la paleta tiene HR (hoja de ruta) */
                    lPaletadespachada = YES.
                    FOR EACH b-vtadtabla WHERE b-vtadtabla.codcia = s-codcia AND 
                        b-vtadtabla.tabla = "MOV-RACK-DTL" AND 
                        b-vtadtabla.llave = bb-vtadtabla.llave AND /* Division */
                        b-vtadtabla.tipo = bb-vtadtabla.tipo NO-LOCK :  /* Nro paleta */
                        IF (b-vtadtabla.libre_c05 = ? OR b-vtadtabla.libre_c05 = "") THEN lPaletadespachada = NO.
                    END.
                    RELEASE B-vtadtabla.
                    IF lPaletadespachada = YES THEN DO:
                        /* Todos los O/D, OTR, TRA de la paleta tienen HR (Hoja de Ruta) */
                        FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                            vtatabla.tabla = 'RACKS' AND 
                            vtatabla.llave_c1 = bb-vtadtabla.llave AND  /* Division */
                            vtatabla.llave_c2 = vtactabla.libre_c01 EXCLUSIVE NO-ERROR.  /* Rack */
                        IF AVAILABLE vtatabla THEN DO:
                            ASSIGN vtatabla.valor[2] = vtatabla.valor[2] - 1.
                            ASSIGN vtatabla.valor[2] = IF (vtatabla.valor[2] < 0) THEN 0 ELSE vtatabla.valor[2].
                            RELEASE vtatabla.
                        END.
                        ELSE DO:
                            RELEASE vtatabla.
                            /*MESSAGE "NO EXISTE en RACK ..Division(" + bb-vtadtabla.llave + ") Rack(" + vtactabla.libre_c01 + ")" .*/
                        END.
                        /**/
                        lRowId = ROWID(vtactabla).  
                        FIND B-vtactabla WHERE rowid(B-vtactabla) = lROwId EXCLUSIVE NO-ERROR.
                        IF AVAILABLE B-vtactabla THEN DO:
                            /* Cabecera */
                            ASSIGN 
                                B-vtactabla.libre_d03 =  pRCID
                                B-vtactabla.libre_f02 = TODAY
                                B-vtactabla.libre_c04 = STRING(TIME,"HH:MM:SS").
                            RELEASE B-vtactabla.
                        END.
                        ELSE DO:
                            RELEASE B-vtactabla.
                            /*MESSAGE "NO existe CABECERA .." .*/
                        END.
                    END.
                    ELSE DO:
                        RELEASE B-vtactabla.
                        /* Aun hay O/D, TRA, OTR pendientes de despachar */
                    END.
                END.
                ELSE DO:
                    /*MESSAGE "NO esta en la CABECERA ..(" bb-vtadtabla.llave + ") (" +  bb-vtadtabla.tipo + ")".*/
                END.
            END.
            ELSE DO:
                /*MESSAGE "No esta en el DETALLE ..Tipo(" + ccbcdocu.libre_c01 + ") Nro (" + ccbcdocu.libre_c02 + ")".*/
            END.
        END.
        
        /**/
        ASSIGN T-OD-FAI-GR.T-SWT = "SI".
    END.

END.    /* EACH X-Ccbcdocu */

IF AVAILABLE vtadtabla THEN RELEASE vtadtabla.
IF AVAILABLE vtactabla THEN RELEASE vtactabla.
IF AVAILABLE b-vtactabla THEN RELEASE B-vtactabla.
IF AVAILABLE bb-vtadtabla THEN RELEASE bb-vtadtabla.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Import-PHR-GRV-COPIA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Import-PHR-GRV-COPIA Procedure 
PROCEDURE Import-PHR-GRV-COPIA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pStatus AS CHAR.

ASSIGN
    pStatus = "*".  /* Valor por Defecto */

DEF BUFFER ORDENES FOR Faccpedi.
DEF BUFFER PEDIDO FOR Faccpedi.
DEF BUFFER bb-vtadtabla FOR vtadtabla.
DEF BUFFER z-vtadtabla FOR vtadtabla.
DEF BUFFER B-vtadtabla FOR vtadtabla.
DEF BUFFER B-vtactabla FOR vtactabla. 
    
DEFINE VAR pResumen AS CHARACTER   NO-UNDO.
DEFINE VAR iInt     AS INTEGER     NO-UNDO.
DEFINE VAR cValor   AS CHARACTER   NO-UNDO.
DEFINE VAR lRowId  AS ROWID.
DEFINE VAR lRowIdx AS ROWID.
DEFINE VAR lComa AS CHAR.
DEFINE VAR lPaletadespachada AS LOG.

/************************** Los RACKS  *****************************************/
DISABLE TRIGGERS FOR LOAD OF vtadtabla.
DISABLE TRIGGERS FOR LOAD OF vtactabla.
DISABLE TRIGGERS FOR LOAD OF vtatabla. 

/* Buscamos la ORDEN (O/D u O/M) */
FIND FIRST ORDENES WHERE ORDENES.codcia = s-codcia
    AND ORDENES.coddoc = B-RutaD.CodRef
    AND ORDENES.nroped = B-RutaD.NroRef
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE ORDENES THEN RETURN 'ADM-ERROR'.

/* Buscamos del PEDido: Puede ser del cliente o del 1er. tramo */
FIND FIRST PEDIDO WHERE PEDIDO.codcia = s-codcia
    AND PEDIDO.coddoc = ORDENES.CodRef
    AND PEDIDO.nroped = ORDENES.NroRef
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE PEDIDO THEN RETURN 'ADM-ERROR'.

/* Tiene Grupo de Reparto */
DEFINE VAR hProc AS HANDLE NO-UNDO.             /* Handle Libreria */
DEFINE VAR x-DeliveryGroup AS CHAR.
DEFINE VAR x-InvoiCustomerGroup AS CHAR.

RUN logis\logis-librerias.p PERSISTENT SET hProc.

/* Procedimientos */
RUN Grupo-reparto IN hProc (INPUT PEDIDO.codref, INPUT PEDIDO.nroref,   /* COT */
                            OUTPUT x-DeliveryGroup, OUTPUT x-InvoiCustomerGroup).       


DELETE PROCEDURE hProc.                 /* Release Libreria */


/* ******************************************************* */
/* Guias de remisión están relacionadas */
/* RHC 24/05/18 Buscamos al menos una G/R facturada pero que no esté en ninguna H/R */
/* RHC 19/05/2020 NO guias con flgest = 'DT' (dejado en tienda) o 'NE' (no entregado) */

FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.codped = PEDIDO.coddoc
    AND Ccbcdocu.nroped = PEDIDO.nroped
    AND Ccbcdocu.FlgEst <> 'A'
    AND LOOKUP(Ccbcdocu.FlgEst, 'DT,NE') = 0:

    IF x-DeliveryGroup = "" OR x-InvoiCustomerGroup = "" THEN DO:
        /* FILTRO (Si el pedido tiene G/R) */
        IF NOT (Ccbcdocu.coddoc = 'G/R'
                AND CcbCDocu.Libre_c01 = ORDENES.CodDoc     /* O/D */
                AND CcbCDocu.Libre_c02 = ORDENES.NroPed
                AND Ccbcdocu.flgest = "F") THEN NEXT.
    END.
    ELSE DO:
        /* Tiene Grupo de Reparto */
        IF NOT (Ccbcdocu.coddoc = 'G/R'
                AND CcbCDocu.Libre_c01 = ORDENES.CodDoc     /* O/D */
                AND CcbCDocu.Libre_c02 = ORDENES.NroPed ) THEN NEXT.
    END.

    /*  */


    FIND FIRST Di-RutaD WHERE DI-RutaD.CodCia = s-CodCia                               
        AND DI-RutaD.CodDiv = s-CodDiv                                                
        AND DI-RutaD.CodDoc = "H/R"                                                   
        AND DI-RutaD.CodRef = Ccbcdocu.CodDoc   /* G/R */                             
        AND DI-RutaD.NroRef = Ccbcdocu.NroDoc                                         
        AND CAN-FIND(FIRST DI-RutaC OF DI-RutaD WHERE DI-RutaC.FlgEst <> "A" NO-LOCK) 
        NO-LOCK NO-ERROR.

    IF AVAILABLE Di-RutaD THEN DO:
        MESSAGE "Ya tiene HOJA DE RUTA".
        NEXT. /* La G/R ya tiene HR */
    END.

    ASSIGN
        pStatus = "P".  /* Correcto */
    CREATE DI-RutaD.
    ASSIGN
        DI-RutaD.CodCia = DI-RutaC.CodCia
        DI-RutaD.CodDiv = DI-RutaC.CodDiv
        DI-RutaD.CodDoc = DI-RutaC.CodDoc
        DI-RutaD.NroDoc = DI-RutaC.NroDoc.
    ASSIGN
        DI-RutaD.CodRef = Ccbcdocu.CodDoc
        DI-RutaD.NroRef = Ccbcdocu.NroDoc.

    /* Pesos y Volumenes */
    cValor = "".
    pResumen = "".
    RUN Vta/resumen-pedido.r (DI-RutaD.CodDiv, DI-RutaD.CodRef, DI-RutaD.NroRef, OUTPUT pResumen).
    pResumen = SUBSTRING(pResumen,2,(LENGTH(pResumen) - 2)).
    DO iint = 1 TO NUM-ENTRIES(pResumen,"/"):
        cValor = cValor + SUBSTRING(ENTRY(iint,pResumen,"/"),4) + ','.
    END.

    ASSIGN
        DI-RutaD.Libre_c01 = cValor.

    /* Grabamos el orden de impresion */
    ASSIGN
        DI-RutaD.Libre_d01 = 9999.
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = ccbcdocu.codcli
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN DO:
        FIND Vtaubidiv WHERE VtaUbiDiv.CodCia = s-codcia
            AND VtaUbiDiv.CodDiv = s-coddiv
            AND VtaUbiDiv.CodDept = gn-clie.CodDept 
            AND VtaUbiDiv.CodProv = gn-clie.CodProv 
            AND VtaUbiDiv.CodDist = gn-clie.CodDist
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaUbiDiv THEN DI-RutaD.Libre_d01 = VtaUbiDiv.Libre_d01.
    END.

    /* Chequeo si la O/D esta en el detalle del RACK */
    FIND FIRST bb-vtadtabla WHERE bb-vtadtabla.codcia = DI-RutaC.codcia AND
        bb-vtadtabla.tabla = 'MOV-RACK-DTL' AND 
        bb-vtadtabla.libre_c03 = ccbcdocu.libre_c01 AND   /* O/D, OTR, TRA */
        bb-vtadtabla.llavedetalle = ccbcdocu.libre_c02 NO-LOCK NO-ERROR. /* Nro */
    IF AVAILABLE bb-vtadtabla THEN DO:
        lComa = "".
        IF (bb-vtadtabla.libre_c05 = ? OR TRIM(bb-vtadtabla.libre_c05) = "") THEN DO:
            lComa = "".
        END.
        ELSE DO :
            lComa = TRIM(bb-vtadtabla.libre_c05).
        END.
        /* Grabo la Hoja de Ruta */
        IF lComa = "" THEN DO:
            lComa = trim(Di-RutaC.nrodoc).
        END.
        ELSE DO:
            lComa = lComa + ", " + trim(Di-RutaC.nrodoc).
        END.
        lRowIdx = ROWID(bb-vtadtabla).
        FIND FIRST z-vtadtabla WHERE ROWID(z-vtadtabla) = lRowidx EXCLUSIVE NO-ERROR.
        IF AVAILABLE z-vtadtabla  THEN DO:
            ASSIGN z-vtadtabla.libre_c05 = lComa.            
        END.
        RELEASE z-vtadtabla.

        /* Libero RACKS Paletas */
        FIND FIRST vtactabla WHERE vtactabla.codcia = s-codcia AND 
            vtactabla.tabla = "MOV-RACK-HDR" AND 
            vtactabla.llave BEGINS bb-vtadtabla.llave AND 
            vtactabla.libre_c02 = bb-vtadtabla.tipo NO-LOCK NO-ERROR.
        IF AVAILABLE vtactabla THEN DO:
            /* Grabo el RACK en la RI-RUTAD */
            ASSIGN DI-RutaD.libre_c05 = vtactabla.libre_c01.
            /* Chequeo si todo el detalle de la paleta tiene HR (hoja de ruta) */
            lPaletadespachada = YES.
            FOR EACH b-vtadtabla WHERE b-vtadtabla.codcia = s-codcia AND 
                b-vtadtabla.tabla = "MOV-RACK-DTL" AND 
                b-vtadtabla.llave = bb-vtadtabla.llave AND /* Division */
                b-vtadtabla.tipo = bb-vtadtabla.tipo NO-LOCK :  /* Nro paleta */
                IF (b-vtadtabla.libre_c05 = ? OR b-vtadtabla.libre_c05 = "") THEN lPaletadespachada = NO.
            END.
            RELEASE B-vtadtabla.
            IF lPaletadespachada = YES THEN DO:
                /* Todos los O/D, OTR, TRA de la paleta tienen HR (Hoja de Ruta) */
                FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                    vtatabla.tabla = 'RACKS' AND 
                    vtatabla.llave_c1 = bb-vtadtabla.llave AND  /* Division */
                    vtatabla.llave_c2 = vtactabla.libre_c01 EXCLUSIVE NO-ERROR.  /* Rack */
                IF AVAILABLE vtatabla THEN DO:
                    ASSIGN vtatabla.valor[2] = vtatabla.valor[2] - 1.
                    ASSIGN vtatabla.valor[2] = IF (vtatabla.valor[2] < 0) THEN 0 ELSE vtatabla.valor[2].
                    RELEASE vtatabla.
                END.
                ELSE DO:
                    RELEASE vtatabla.
                    /*MESSAGE "NO EXISTE en RACK ..Division(" + bb-vtadtabla.llave + ") Rack(" + vtactabla.libre_c01 + ")" .*/
                END.
                /**/
                lRowId = ROWID(vtactabla).  
                FIND B-vtactabla WHERE rowid(B-vtactabla) = lROwId EXCLUSIVE NO-ERROR.
                IF AVAILABLE B-vtactabla THEN DO:
                    /* Cabecera */
                    ASSIGN 
                        B-vtactabla.libre_d03 =  pRCID
                        B-vtactabla.libre_f02 = TODAY
                        B-vtactabla.libre_c04 = STRING(TIME,"HH:MM:SS").
                    RELEASE B-vtactabla.
                END.
                ELSE DO:
                    RELEASE B-vtactabla.
                    /*MESSAGE "NO existe CABECERA .." .*/
                END.
            END.
            ELSE DO:
                RELEASE B-vtactabla.
                /* Aun hay O/D, TRA, OTR pendientes de despachar */
            END.
        END.
        ELSE DO:
            /*MESSAGE "NO esta en la CABECERA ..(" bb-vtadtabla.llave + ") (" +  bb-vtadtabla.tipo + ")".*/
        END.
    END.
    ELSE DO:
        /*MESSAGE "No esta en el DETALLE ..Tipo(" + ccbcdocu.libre_c01 + ") Nro (" + ccbcdocu.libre_c02 + ")".*/
    END.
END.    /* EACH Ccbcdocu */
IF AVAILABLE vtadtabla THEN RELEASE vtadtabla.
IF AVAILABLE vtactabla THEN RELEASE vtactabla.
IF AVAILABLE b-vtactabla THEN RELEASE B-vtactabla.
IF AVAILABLE bb-vtadtabla THEN RELEASE bb-vtadtabla.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Import-PHR-Multiple) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Import-PHR-Multiple Procedure 
PROCEDURE Import-PHR-Multiple :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT  PARAMETER pRegistro AS CHAR.     /* Lista de PHR separados por comas */
DEF OUTPUT PARAMETER pRowid AS ROWID.       /* Rowid de la H/R */
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR pBloqueados AS INT NO-UNDO.
DEF VAR pTotales AS INT NO-UNDO.
DEF VAR k AS INT NO-UNDO.
DEF VAR x-NroPHR AS CHAR NO-UNDO.
DEFINE VAR x-fai-nro AS CHAR.

EMPTY TEMP-TABLE T-RutaD.   /* TODOS LOS QUE NO SE VAN MIGRAR */
DO k = 1 TO NUM-ENTRIES(pRegistro):
    x-NroPHR = ENTRY(k, pRegistro).
    FIND FIRST B-RUTAC WHERE B-RUTAC.CodCia = s-CodCia AND
        B-RUTAC.CodDiv = s-CodDiv AND
        B-RUTAC.CodDoc = "PHR" AND
        B-RUTAC.NroDoc = x-NroPHR NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-RUTAC OR B-RUTAC.FlgEst <> "P" THEN DO:
        pMensaje = 'YA no está disponible la Pre-Hoja de Ruta' + x-NroPHR + CHR(10) +
            'Proceso Abortado'.
        RETURN 'ADM-ERROR'.
    END.
    /* Paso 1: Verificar que pase al menos una O/D u OTR */
    RUN Import-PHR-Validate (OUTPUT pBloqueados, OUTPUT pTotales, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO hay ninguna O/D u OTR válidas".
        RETURN 'ADM-ERROR'.
    END.
END.

/* Mensaje con la información que NO va a ser migrada */
DEF VAR pOk AS LOG NO-UNDO.
RUN dist/d-mantto-phr-del.w(pTotales, pBloqueados, INPUT TABLE T-RutaD,OUTPUT pOk).
IF pOk = NO THEN RETURN 'ADM-ERROR'.
IF pTotales <> 0 AND pTotales = pBloqueados THEN DO:
    pMensaje = 'TODOS los documentos tienen observaciones' + CHR(10) + 
        'Proceso abortado'.
    RETURN 'ADM-ERROR'.
END.

/* Tiene Grupo de Reparto */
DEFINE VAR hProc AS HANDLE NO-UNDO.             /* Handle Libreria */
DEFINE VAR x-DeliveryGroup AS CHAR.
DEFINE VAR x-InvoiCustomerGroup AS CHAR.

RUN logis\logis-librerias.p PERSISTENT SET hProc.


/* **************************************************************************** */
/* 2do. Generamos la Hoja de Ruta */
/* **************************************************************************** */
DEF VAR s-coddoc AS CHAR INIT 'H/R'.

DEF VAR pStatus AS CHAR NO-UNDO.
DEF VAR x-Cuenta AS INT NO-UNDO.
RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Bloqueamos Correlativo */
    {lib/lock-genericov3.i ~
        &Tabla="FacCorre" ~
        &Alcance="FIRST" ~
        &Condicion="FacCorre.CodCia = S-CODCIA  ~
        AND FacCorre.CodDiv = S-CODDIV ~
        AND FacCorre.CodDoc = S-CODDOC ~
        AND FacCorre.FlgEst = YES" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        }
    /* Marcamos la información que NO va a ser migrada */
    FOR EACH T-RutaD NO-LOCK:
        FIND B-RutaD WHERE B-RutaD.CodCia = T-RutaD.CodCia
            AND B-RutaD.CodDiv = T-RutaD.CodDiv
            AND B-RutaD.CodDoc = T-RutaD.CodDoc
            AND B-RutaD.NroDoc = T-RutaD.NroDoc
            AND B-RutaD.CodRef = T-RutaD.CodRef
            AND B-RutaD.NroRef = T-RutaD.NroRef
            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR THEN DO:
            {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
            DELETE PROCEDURE hProc.
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            B-RutaD.FlgEst = "A".    /* Marcamos como ANULADO */
    END.
    /* ************************************************ */
    /* Creamos la H/R */
    /* ************************************************ */
    CREATE DI-RutaC.
    ASSIGN
        DI-RutaC.CodCia = s-codcia
        DI-RutaC.CodDiv = s-coddiv
        DI-RutaC.CodDoc = s-coddoc
        DI-RutaC.FchDoc = TODAY
        DI-RutaC.NroDoc = STRING(FacCorre.nroser, '999') + STRING(FacCorre.correlativo, '999999')
        DI-RutaC.usuario = s-user-id
        DI-RutaC.flgest  = "P"      /* Pendiente */
        DI-RutaC.Libre_L02 = NO     /* Por Importación de PHR */
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
        DELETE PROCEDURE hProc.
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        DI-RutaC.Libre_c03 = "".
    DO k = 1 TO NUM-ENTRIES(pRegistro):
        x-NroPHR = ENTRY(k, pRegistro).
        DI-RutaC.Libre_c03 = DI-RutaC.Libre_c03 +
            (IF TRUE <> (DI-RutaC.Libre_c03 > '') THEN '' ELSE '|') +
            'PHR,' + x-NroPHR.
    END.
    /* Información Adicional */
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    pRowid = ROWID(DI-RutaC).
    /* ************************************************ */
    /* Bloqueamos PHR */
    /* ************************************************ */
    
    DO k = 1 TO NUM-ENTRIES(pRegistro):
        x-NroPHR = ENTRY(k, pRegistro).

        FIND FIRST B-RUTAC WHERE B-RUTAC.CodCia = s-CodCia AND
            B-RUTAC.CodDiv = s-CodDiv AND
            B-RUTAC.CodDoc = "PHR" AND
            B-RUTAC.NroDoc = x-NroPHR EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
            DELETE PROCEDURE hProc.
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        IF B-RUTAC.FlgEst <> "P" THEN DO:
            pMensaje = 'YA no está disponible la Pre-Hoja de Ruta ' + x-NroPHR.
            DELETE PROCEDURE hProc.
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.

        /* Para caso BCP x grupo de reparto */
        FOR EACH DI-RutaD NO-LOCK WHERE DI-RutaD.CodCia = B-RutaC.CodCia
            AND DI-RutaD.CodDiv = B-RutaC.CodDiv
            AND DI-RutaD.CodDoc = B-RutaC.CodDoc
            AND DI-RutaD.NroDoc = B-RutaC.NroDoc
            AND DI-RutaD.FlgEst <> "A":

            /* Segun el pedido ubico las FAIs */
            FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                        x-faccpedi.coddoc = di-rutad.codref AND     /* O/D */
                                        x-faccpedi.nroped = di-rutad.nroref NO-LOCK NO-ERROR.
            IF AVAILABLE x-faccpedi THEN DO:
                FOR EACH x-Ccbcdocu NO-LOCK WHERE x-Ccbcdocu.codcia = s-codcia
                    AND x-Ccbcdocu.codped = x-faccpedi.codref       /* PED */
                    AND x-Ccbcdocu.nroped = x-faccpedi.nroref
                    AND x-Ccbcdocu.coddoc = 'FAI' 
                    AND x-Ccbcdocu.libre_c01 = di-rutad.codref      /* O/D */
                    AND x-Ccbcdocu.libre_c02 = di-rutad.nroref
                    AND x-Ccbcdocu.FlgEst <> 'A' :


                    x-fai-nro = TRIM(x-Ccbcdocu.coddoc) + "-" + TRIM(x-Ccbcdocu.nrodoc).
                    /**/
                    FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND
                                                vtatabla.tabla = 'CRUCE-FAI-GR' AND
                                                vtatabla.llave_c1 = x-fai-nro NO-LOCK
                                                BREAK BY vtatabla.llave_c2 :
                        IF FIRST-OF(vtatabla.llave_c2) THEN DO:

                            FIND FIRST T-OD-FAI-GR WHERE T-OD-FAI-GR.T-COD_OD = di-rutad.codref AND /* O/D */
                                                            T-OD-FAI-GR.T-NRO_OD = di-rutad.nroref AND
                                                            T-OD-FAI-GR.T-GR = vtatabla.llave_c2 /* G/R */ EXCLUSIVE-LOCK NO-ERROR.
                            IF NOT AVAILABLE T-OD-FAI-GR  THEN DO:
                                CREATE T-OD-FAI-GR.
                                        ASSIGN T-OD-FAI-GR.T-COD_OD = di-rutad.codref
                                                T-OD-FAI-GR.T-NRO_OD = di-rutad.nroref
                                                T-OD-FAI-GR.T-GR = vtatabla.llave_c2
                                                T-OD-FAI-GR.T-SWT = 'NO'.
                            END.
                        END.
                    END.

                END.
            END.

        END.

        /* Final */
        ASSIGN 
            B-RUTAC.FlgEst = "C"
            B-RUTAC.CodRef = DI-RutaC.CodDoc
            B-RUTAC.NroRef = DI-RutaC.NroDoc.   /* OJO: Campo Relacionado */
        /* ************************************************ */
        /* Barremos las O/D y OTR Válidas de la PHR  */
        /* ************************************************ */
        FOR EACH DI-RutaD NO-LOCK WHERE DI-RutaD.CodCia = B-RutaC.CodCia
            AND DI-RutaD.CodDiv = B-RutaC.CodDiv
            AND DI-RutaD.CodDoc = B-RutaC.CodDoc
            AND DI-RutaD.NroDoc = B-RutaC.NroDoc
            AND DI-RutaD.FlgEst <> "A":
            FIND B-RutaD WHERE ROWID(B-RutaD) = ROWID(DI-RutaD) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
                DELETE PROCEDURE hProc.
                UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
            pStatus = "*".  /* <<< OJO <<< */
            CASE B-RutaD.CodRef:
                WHEN "O/D" OR WHEN "O/M" THEN DO:
                    RUN Import-PHR-GRV (OUTPUT pStatus).
                    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                        pMensaje = 'ERROR al grabar la ' + B-RutaD.CodRef + ' ' + B-RutaD.NroRef.
                        DELETE PROCEDURE hProc.
                        UNDO RLOOP, RETURN 'ADM-ERROR'.
                    END.
                END.
                WHEN "OTR" THEN DO:
                    RUN Import-PHR-GRT (OUTPUT pStatus).
                    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                        pMensaje = 'ERROR al grabar la ' + B-RutaD.CodRef + ' ' + B-RutaD.NroRef.
                        DELETE PROCEDURE hProc.
                        UNDO RLOOP, RETURN 'ADM-ERROR'.
                    END.
                    
                END.
            END CASE.
            ASSIGN
                B-RutaD.FlgEst = pStatus.   /* OJO */
        END.
    END.
    /* Verificamos que haya pasado al menos un registro */
    FIND FIRST Di-RutaD OF Di-RutaC NO-LOCK NO-ERROR.
    FIND FIRST Di-RutaG OF Di-RutaC NO-LOCK NO-ERROR.

    /* RHC 25/11/2019 Poder pasar una H/R en blanco */
    IF NOT AVAILABLE Di-RutaD AND NOT AVAILABLE Di-RutaG THEN DO:
        pMensaje = "Se ha generado una Hoja de Ruta EN BLANCO" + CHR(10) +
            "Continuamos con la grabación BAJO SU PROPIO RIESGO" + CHR(10) + CHR(10) +
            "Si no desea que esté en blanco no se olvide ANULARLA".
/*         MESSAGE "NO se ha generado ningun registro para la Hoja de Ruta"                    */
/*             SKIP "Continuamos con la grabación BAJO SU PROPIO RIESGO?"                      */
/*             VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.                   */
/*         IF rpta = NO THEN DO:                                                               */
/*             pMensaje = "NO se ha generado ningun registro para la Hoja de Ruta" + CHR(10) + */
/*                 "Proceso Abortado".                                                         */
/*             UNDO RLOOP, LEAVE RLOOP.                                                        */
/*         END.                                                                                */
        LEAVE RLOOP.
    END.
    IF NOT AVAILABLE Di-RutaD AND NOT AVAILABLE Di-RutaG THEN DO:
        pMensaje = "NO se ha generado ningun registro para la Hoja de Ruta" + CHR(10) +
            "Proceso Abortado".
        DELETE PROCEDURE hProc.
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* ************************************************ */
    /* RHC 17.09.11 Control de G/R por pedidos */
    /* ************************************************ */
    RUN dist/p-rut001-v2 ( ROWID(Di-RutaC), NO, OUTPUT pMensaje ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        DELETE PROCEDURE hProc.
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
        
    /* ************************************************ */
    FIND CURRENT Di-RutaC EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
        DELETE PROCEDURE hProc.
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.

    IF Di-RutaC.FlgEst <> "P" THEN DO:
        pMensaje = "No están completos los comprobantes" + CHR(10) + "Proceso abortado".
        DELETE PROCEDURE hProc.
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    
    IF AVAILABLE(Faccorre) THEN RELEASE Faccorre.
    IF AVAILABLE(B-RUTAC)  THEN RELEASE B-RUTAC.
    IF AVAILABLE(DI-RutaC) THEN RELEASE DI-RutaC.
    IF AVAILABLE(DI-RutaG) THEN RELEASE DI-RutaG.

END.

DELETE PROCEDURE hProc.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Import-PHR-Validate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Import-PHR-Validate Procedure 
PROCEDURE Import-PHR-Validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pBloqueados AS INT NO-UNDO.
DEF OUTPUT PARAMETER pTotales AS INT NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* DEFINE VAR x-hProc AS HANDLE NO-UNDO.             */
/* RUN dist\dis-validaciones PERSISTENT SET x-hProc. */

DEF BUFFER ORDENES FOR Faccpedi.
DEF BUFFER PEDIDO  FOR Faccpedi.

DEFINE VAR x-retval AS CHAR.

ASSIGN
    pBloqueados = 0
    pTotales = 0.

/*EMPTY TEMP-TABLE T-RutaD.*/
RLOOP:
FOR EACH B-RutaD NO-LOCK WHERE B-RutaD.CodCia = B-RutaC.CodCia
    AND B-RutaD.CodDiv = B-RutaC.CodDiv
    AND B-RutaD.CodDoc = B-RutaC.CodDoc
    AND B-RutaD.NroDoc = B-RutaC.NroDoc:
    pTotales = pTotales + 1.

    /* Esta ANULADA la Orden */
/*     x-retval = "".                                                         */
/*     RUN orden-anulada IN x-hProc (INPUT "", INPUT B-RutaD.CodRef,          */
/*                                   INPUT B-RutaD.NroRef, OUTPUT x-retval) . */
/*     IF x-retval = 'OK'  THEN NEXT RLOOP.                                   */
/*                                                                            */
/*     /* Ya tiene Hoja de Ruta */                                            */
/*     x-retval = "".                                                         */
/*     RUN orden-sin-hruta IN x-hProc (INPUT B-RutaD.CodRef,                  */
/*                                   INPUT B-RutaD.NroRef, OUTPUT x-retval) . */
/*     IF x-retval <> 'OK'  THEN NEXT RLOOP.                                  */

    CASE B-RutaD.CodRef:
        WHEN "O/D" OR WHEN "O/M" THEN DO:
            /* Buscamos la ORDEN (O/D u O/M) */
            FIND FIRST ORDENES WHERE ORDENES.codcia = s-codcia
                AND ORDENES.coddoc = B-RutaD.CodRef
                AND ORDENES.nroped = B-RutaD.NroRef
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ORDENES THEN DO:
                CREATE T-RutaD.
                BUFFER-COPY B-RutaD TO T-RutaD.
                pBloqueados = pBloqueados + 1.
                NEXT RLOOP.
            END.

            /* Buscamos del PEDido: Puede ser del cliente o del 1er. tramo */
            FIND FIRST PEDIDO WHERE PEDIDO.codcia = s-codcia
                AND PEDIDO.coddoc = ORDENES.CodRef
                AND PEDIDO.nroped = ORDENES.NroRef
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE PEDIDO THEN DO:
                /*MESSAGE 'NO encontrado' s-codcia ordenes.codref ordenes.nroref.*/
                CREATE T-RutaD.
                BUFFER-COPY B-RutaD TO T-RutaD.
                pBloqueados = pBloqueados + 1.
                NEXT RLOOP.
            END.

            /* Verificamos si es x grupo de Reparto caso BCP */
            DEFINE VAR hProc AS HANDLE NO-UNDO.         /* Handle Libreria */
            DEFINE VAR x-DeliveryGroup AS CHAR.
            DEFINE VAR x-InvoiCustomerGroup AS CHAR.
            
            RUN logis\logis-librerias.r PERSISTENT SET hProc.
            
            /* Procedimientos */
            RUN Grupo-reparto IN hProc (INPUT PEDIDO.codREF, INPUT PEDIDO.nroREF, 
                                        OUTPUT x-DeliveryGroup, OUTPUT x-InvoiCustomerGroup).   
            
            
            DELETE PROCEDURE hProc.                     /* Release Libreria */

            IF x-DeliveryGroup = "" OR x-InvoiCustomerGroup = "" THEN DO:
                /* No tiene grupo de reparto */
                /* Ya debe haber pasado por FACTURACION */
                FIND FIRST Ccbcdocu USE-INDEX Llave15 WHERE Ccbcdocu.codcia = s-codcia
                    AND Ccbcdocu.codped = PEDIDO.coddoc
                    AND Ccbcdocu.nroped = PEDIDO.nroped
                    AND Ccbcdocu.coddoc = 'G/R'
                    AND Ccbcdocu.flgest = "F"
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE Ccbcdocu THEN DO:
                    CREATE T-RutaD.
                    BUFFER-COPY B-RutaD TO T-RutaD.
                    pBloqueados = pBloqueados + 1.
                    NEXT RLOOP.
                END.
            END.
            ELSE DO:    /* con GRupo de Reparto */
                /* Ubico la FAI cuyo origen es la O/D - CASO BCP */
                FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                            ccbcdocu.codcli = ORDENES.codcli AND
                                            ccbcdocu.coddoc = 'FAI' AND
                                            Ccbcdocu.libre_c01 = ORDENES.coddoc AND    /* O/D */
                                            Ccbcdocu.libre_c02 = ORDENES.nroped AND
                                            Ccbcdocu.flgest <> 'A' NO-LOCK NO-ERROR.
                IF NOT AVAILABLE ccbcdocu THEN DO:
                    CREATE T-RutaD.
                    BUFFER-COPY B-RutaD TO T-RutaD.
                    pBloqueados = pBloqueados + 1.
                    NEXT RLOOP.
                END.
                /* 01Oct2020, segun MAX llamada x cell 5:45pm, solo debe estar con G/R */
                IF (ccbcdocu.codref <> 'G/R') OR (TRUE <> (ccbcdocu.codref > "")  ) THEN DO:
                    /* La FAI aun no tiene G/R */
                    CREATE T-RutaD.
                    BUFFER-COPY B-RutaD TO T-RutaD.
                    pBloqueados = pBloqueados + 1.
                    NEXT RLOOP.
                END.
            END.
        END.
        WHEN "OTR" THEN DO:
            /* Buscamos la ORDEN (OTR) */
            FIND FIRST ORDENES WHERE ORDENES.codcia = s-codcia
                AND ORDENES.coddoc = B-RutaD.CodRef
                AND ORDENES.nroped = B-RutaD.NroRef
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ORDENES THEN DO:
                CREATE T-RutaD.
                BUFFER-COPY B-RutaD TO T-RutaD.
                pBloqueados = pBloqueados + 1.
                NEXT RLOOP.
            END.
            FIND FIRST Almcmov USE-INDEX Almc07 WHERE Almcmov.CodCia = s-CodCia
                AND Almcmov.CodRef = ORDENES.CodDoc     /* OTR */
                AND Almcmov.NroRef = ORDENES.NroPed
                AND Almcmov.TipMov = "S"
                AND Almcmov.CodMov = 03                 /* Transferencia */
                AND Almcmov.FlgEst <> "A"
                NO-LOCK NO-ERROR.
/*             FIND FIRST Almcmov USE-INDEX Almc07 WHERE Almcmov.CodCia = s-CodCia    */
/*                 AND Almcmov.CodRef = ORDENES.CodDoc     /* OTR */                  */
/*                 AND Almcmov.NroRef = ORDENES.NroPed                                */
/*                 AND Almcmov.TipMov = "S"                                           */
/*                 AND Almcmov.FlgEst <> "A"                                          */
/*                 AND CAN-FIND(FIRST Almtmovm WHERE Almtmovm.CodCia = Almcmov.CodCia */
/*                              AND Almtmovm.Tipmov = Almcmov.TipMov                  */
/*                              AND Almtmovm.Codmov = Almcmov.CodMov                  */
/*                              AND Almtmovm.MovTrf = YES NO-LOCK)                    */
/*                 NO-LOCK NO-ERROR.                                                  */
            IF NOT AVAILABLE Almcmov THEN DO:
                CREATE T-RutaD.
                BUFFER-COPY B-RutaD TO T-RutaD.
                pBloqueados = pBloqueados + 1.
                NEXT RLOOP.
            END.
        END.
    END CASE.
END.

/*DELETE PROCEDURE x-hProc.*/

/* ********************************************************************* */
/* RHC 30/10/18 Verificamos que todas las OTR de una R/A estén en la PHR */
/* ********************************************************************* */
DEF VAR LocalTipMov AS CHAR NO-UNDO.
&SCOPED-DEFINE LocalCondition T-RUTAD.CodRef = "OTR", ~
FIRST Faccpedi NO-LOCK WHERE FacCPedi.CodCia = s-CodCia AND ~
    FacCPedi.CodDoc = T-RUTAD.CodRef AND ~
    FacCPedi.NroPed = T-RUTAD.NroRef AND ~
    Faccpedi.DivDes = s-CodDiv, ~
    FIRST Almcrepo NO-LOCK WHERE almcrepo.CodCia = s-CodCia AND ~
        almcrepo.CodAlm = Faccpedi.CodCli AND ~
        almcrepo.TipMov = LocalTipMov AND ~
        almcrepo.NroSer = INTEGER(SUBSTRING(FacCPedi.NroRef,1,3)) AND ~
        almcrepo.NroDoc = INTEGER(SUBSTRING(FacCPedi.NroRef,4))

EMPTY TEMP-TABLE T-CREPO.
LocalTipMov = "M".
FOR EACH T-RUTAD NO-LOCK WHERE {&LocalCondition}:
    FIND FIRST T-CREPO WHERE T-CREPO.codcia = s-CodCia AND
        T-CREPO.nroser = Almcrepo.nroser AND
        T-CREPO.nrodoc = Almcrepo.nrodoc
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE T-CREPO THEN DO:
        CREATE T-CREPO.
        BUFFER-COPY Almcrepo TO T-CREPO.
    END.
END.
LocalTipMov = "A".
FOR EACH T-RUTAD NO-LOCK WHERE {&LocalCondition}:
    FIND FIRST T-CREPO WHERE T-CREPO.codcia = s-CodCia AND
        T-CREPO.nroser = Almcrepo.nroser AND
        T-CREPO.nrodoc = Almcrepo.nrodoc
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE T-CREPO THEN DO:
        CREATE T-CREPO.
        BUFFER-COPY Almcrepo TO T-CREPO.
    END.
END.
DEF VAR LocalNroRef AS CHAR NO-UNDO.
FOR EACH T-CREPO NO-LOCK:
    LocalNroRef = STRING(T-CREPO.NroSer, '999') + STRING(T-CREPO.NroDoc, '999999').
    FOR EACH FacCPedi NO-LOCK USE-INDEX Llave07 WHERE FacCPedi.CodCia = s-CodCia AND
        FacCPedi.CodRef = "R/A" AND
        FacCPedi.NroRef = LocalNroRef AND
        FacCPedi.CodDoc = "OTR":
        IF NOT CAN-FIND(FIRST T-RUTAD WHERE T-RUTAD.CodRef = Faccpedi.CodDoc AND
                        T-RUTAD.NroRef = Faccpedi.NroPed NO-LOCK)
            THEN DO:
            pMensaje = 'Falta la ' + Faccpedi.CodDoc + ' ' + Faccpedi.NroPed + 
                ' de la R/A ' + FacCPedi.NroRef.
            RETURN 'ADM-ERROR'.
        END.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PHR-FlgEst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PHR-FlgEst Procedure 
PROCEDURE PHR-FlgEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Dato: Almcdocu Control de NO ENTTREGADOS */
DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pFlgEst AS CHAR.    /* R reprogramado */

FIND FIRST Almcdocu WHERE ROWID(Almcdocu) = pRowid NO-LOCK NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN RETURN 'OK'.
FIND FIRST Di-RutaC WHERE DI-RutaC.CodCia = Almcdocu.codcia AND
    /*DI-RutaC.CodDiv = Almcdocu.codllave AND */    /* Caso DEJADO EN TIENDA */
    DI-RutaC.CodDoc = Almcdocu.libre_c01 AND 
    DI-RutaC.NroDoc = Almcdocu.libre_c02 
    NO-LOCK NO-ERROR.
/* Verificamos que venga de una PHR */
IF NOT AVAILABLE DI-RutaC OR ENTRY(1, DI-RutaC.Libre_c03) <> "PHR" THEN RETURN 'OK'.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH B-PHRD EXCLUSIVE-LOCK WHERE B-PHRD.codcia = DI-RutaC.codcia
        /*AND B-PHRD.coddiv = DI-RutaC.coddiv*/     /* Caso DEJADO EN TIENDA */
        AND B-PHRD.coddoc = ENTRY(1, DI-RutaC.libre_c03)    /* PHR */
        AND B-PHRD.nrodoc = ENTRY(2, DI-RutaC.libre_c03)
        AND B-PHRD.codref = Almcdocu.coddoc                 /* O/D */
        AND B-PHRD.nroref = Almcdocu.nrodoc 
        ON ERROR UNDO, THROW:
        ASSIGN 
            B-PHRD.FlgEst = pFlgEst.
    END.
END.
IF AVAILABLE(B-PHRD) THEN RELEASE B-PHRD.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

