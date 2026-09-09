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

DEFINE SHARED VARIABLE pRCID AS INT.  


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
         HEIGHT             = 12.73
         WIDTH              = 52.29.
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
    {lib/lock-genericov3.i 
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
                B-RUTAC.nrodoc = ENTRY(2,Di-RutaC.Libre_c03)
                NO-LOCK)
    THEN RETURN 'OK'.
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH B-RUTAC WHERE B-RUTAC.codcia = Di-RutaC.CodCia AND
        B-RUTAC.coddiv = Di-RutaC.coddiv AND     
        B-RUTAC.coddoc = "PHR" AND 
        B-RUTAC.nrodoc = ENTRY(2,Di-RutaC.Libre_c03)
        EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
        ASSIGN
            B-RUTAC.FlgEst = "P".
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
/*
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
            B-RUTAC.FlgEst = "P".
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
*/

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
        (Di-RutaD.flgest = "T") ),
        FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Di-RutaD.codcia
            AND Ccbcdocu.coddoc = Di-RutaD.codref   /* G/R */
            AND Ccbcdocu.nrodoc = Di-RutaD.nroref
            AND Ccbcdocu.Libre_c01 = "O/D"
            /* Ic 19Jun2019, indicacion de MAX RAMOS, esas divisiones no se reprograman */
            AND LOOKUP(Ccbcdocu.divori,"00024,00030,00070") = 0 
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
                        (B-RUTAD.flgest = "T") ),
                    FIRST B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = B-RUTAD.codcia
                        AND B-CDOCU.coddoc = B-RUTAD.codref   /* G/R */
                        AND B-CDOCU.nrodoc = B-RUTAD.nroref
                        AND B-CDOCU.Libre_c01 = Ccbcdocu.libre_c01  /* O/D */
                        AND B-CDOCU.Libre_c02 = Ccbcdocu.libre_c02:
                    CREATE T-GUIAS.
                    BUFFER-COPY B-CDOCU TO T-GUIAS.
                END.
            END.
        END.
    END.
    /* ********************************************************************************************** */
    /* ANULA G/R POR VENTAS  */
    /* ********************************************************************************************** */
    FOR EACH T-GUIAS NO-LOCK, FIRST Ccbcdocu OF T-GUIAS EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
        ASSIGN
            CcbCDocu.FlgEst = "A"
            CcbCDocu.UsuAnu = s-user-id
            CcbCDocu.FchAnu = TODAY.
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
        B-RUTAC.FlgEst = "C".
/*         B-RUTAC.CodRef = DI-RutaC.CodDoc                                 */
/*         B-RUTAC.NroRef = DI-RutaC.NroDoc.   /* OJO: Campo Relacionado */ */
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
/* ******************************************************* */
FOR EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = s-CodCia
    AND Almcmov.CodRef = ORDENES.CodDoc
    AND Almcmov.NroRef = ORDENES.NroPed
    AND Almcmov.TipMov = "S"
    AND Almcmov.FlgEst <> "A",
    FIRST Almtmovm NO-LOCK WHERE Almtmovm.CodCia = Almcmov.CodCia
    AND Almtmovm.Codmov = Almcmov.CodMov
    AND Almtmovm.Tipmov = Almcmov.TipMov
    AND Almtmovm.MovTrf = YES,
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
FIND ORDENES WHERE ORDENES.codcia = s-codcia
    AND ORDENES.coddoc = B-RutaD.CodRef
    AND ORDENES.nroped = B-RutaD.NroRef
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE ORDENES THEN RETURN 'ADM-ERROR'.
/* Buscamos del PEDido: Puede ser del cliente o del 1er. tramo */
FIND PEDIDO WHERE PEDIDO.codcia = s-codcia
    AND PEDIDO.coddoc = ORDENES.CodRef
    AND PEDIDO.nroped = ORDENES.NroRef
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE PEDIDO THEN RETURN 'ADM-ERROR'.
/* ******************************************************* */
/* Guias de remisión están relacionadas */
/* RHC 24/05/18 Buscamos al menos una G/R facturada pero que no esté en ninguna H/R */
FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.coddoc = 'G/R'
    AND Ccbcdocu.codped = PEDIDO.coddoc
    AND Ccbcdocu.nroped = PEDIDO.nroped
    AND CcbCDocu.Libre_c01 = ORDENES.CodDoc     /* O/D */
    AND CcbCDocu.Libre_c02 = ORDENES.NroPed
    AND Ccbcdocu.flgest = "F":
    FIND FIRST Di-RutaD WHERE DI-RutaD.CodCia = s-CodCia                               
        AND DI-RutaD.CodDiv = s-CodDiv                                                
        AND DI-RutaD.CodDoc = "H/R"                                                   
        AND DI-RutaD.CodRef = Ccbcdocu.CodDoc   /* G/R */                             
        AND DI-RutaD.NroRef = Ccbcdocu.NroDoc                                         
        AND CAN-FIND(FIRST DI-RutaC OF DI-RutaD WHERE DI-RutaC.FlgEst <> "A" NO-LOCK) 
        NO-LOCK NO-ERROR.
    IF AVAILABLE Di-RutaD THEN NEXT.
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
    RUN Vta/resumen-pedido (DI-RutaD.CodDiv, DI-RutaD.CodRef, DI-RutaD.NroRef, OUTPUT pResumen).
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
RELEASE vtadtabla.
RELEASE vtactabla.
RELEASE B-vtactabla.
RELEASE bb-vtadtabla.

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

DEF VAR pBloqueados AS INT NO-UNDO.
DEF VAR pTotales AS INT NO-UNDO.
DEF VAR pMensaje AS CHAR INIT '' NO-UNDO.
DEF VAR k AS INT NO-UNDO.
DEF VAR x-NroPHR AS CHAR NO-UNDO.

EMPTY TEMP-TABLE T-RutaD.   /* TODOS LOS QUE NO SE VAN MIGRAR */
DO k = 1 TO NUM-ENTRIES(pRegistro):
    x-NroPHR = ENTRY(k, pRegistro).
    FIND B-RUTAC WHERE B-RUTAC.CodCia = s-CodCia AND
        B-RUTAC.CodDiv = s-CodDiv AND
        B-RUTAC.CodDoc = "PHR" AND
        B-RUTAC.NroDoc = x-NroPHR NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-RUTAC OR B-RUTAC.FlgEst <> "P" THEN DO:
        MESSAGE 'YA no está disponible la Pre-Hoja de Ruta' x-NroPHR SKIP 'Proceso Abortado'
            VIEW-AS ALERT-BOX WARNING.
        RETURN 'ADM-ERROR'.
    END.
    /* Paso 1: Verificar que pase al menos una O/D u OTR */
    RUN Import-PHR-Validate (OUTPUT pBloqueados, OUTPUT pTotales, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
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
        /*DI-RutaC.Libre_c03 = B-RUTAC.CodDoc + ',' + B-RUTAC.NroDoc  /* PARA EXTORNAR */*/
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
        UNDO RLOOP, LEAVE RLOOP.
    END.
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
        FIND B-RUTAC WHERE B-RUTAC.CodCia = s-CodCia AND
            B-RUTAC.CodDiv = s-CodDiv AND
            B-RUTAC.CodDoc = "PHR" AND
            B-RUTAC.NroDoc = x-NroPHR EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
            UNDO, LEAVE.
        END.
        IF B-RUTAC.FlgEst <> "P" THEN DO:
            pMensaje = 'YA no está disponible la Pre-Hoja de Ruta ' + x-NroPHR.
            UNDO RLOOP, LEAVE RLOOP.
        END.
        /* Final */
        ASSIGN 
            B-RUTAC.FlgEst = "C".
/*             B-RUTAC.CodRef = DI-RutaC.CodDoc                                 */
/*             B-RUTAC.NroRef = DI-RutaC.NroDoc.   /* OJO: Campo Relacionado */ */
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
    END.
    /* Verificamos que haya pasado al menos un registro */
    FIND FIRST Di-RutaD OF Di-RutaC NO-LOCK NO-ERROR.
    FIND FIRST Di-RutaG OF Di-RutaC NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Di-RutaD AND NOT AVAILABLE Di-RutaG THEN DO:
        pMensaje = "NO se ha generado ningun registro para la Hoja de Ruta" + CHR(10) +
            "Proceso Abortado".
        UNDO, LEAVE.
    END.
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

DEF BUFFER ORDENES FOR Faccpedi.
DEF BUFFER PEDIDO  FOR Faccpedi.

DEFINE VAR x-hProc AS HANDLE NO-UNDO.
DEFINE VAR x-retval AS CHAR.
RUN dist\dis-validaciones PERSISTENT SET x-hProc.

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
    x-retval = "".
    RUN orden-anulada IN x-hProc (INPUT "", INPUT B-RutaD.CodRef,
                                  INPUT B-RutaD.NroRef, OUTPUT x-retval) .
    IF x-retval = 'OK'  THEN NEXT.

    /* Ya tiene Hoja de Ruta */
    x-retval = "".
    RUN orden-sin-hruta IN x-hProc (INPUT B-RutaD.CodRef,
                                  INPUT B-RutaD.NroRef, OUTPUT x-retval) .
    IF x-retval <> 'OK'  THEN NEXT.

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
                MESSAGE 'NO encontrado' s-codcia ordenes.codref ordenes.nroref.
                CREATE T-RutaD.
                BUFFER-COPY B-RutaD TO T-RutaD.
                pBloqueados = pBloqueados + 1.
                NEXT RLOOP.
            END.
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
                AND Almcmov.FlgEst <> "A"
                AND CAN-FIND(FIRST Almtmovm WHERE Almtmovm.CodCia = Almcmov.CodCia
                             AND Almtmovm.Tipmov = Almcmov.TipMov
                             AND Almtmovm.Codmov = Almcmov.CodMov
                             AND Almtmovm.MovTrf = YES NO-LOCK)
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almcmov THEN DO:
                CREATE T-RutaD.
                BUFFER-COPY B-RutaD TO T-RutaD.
                pBloqueados = pBloqueados + 1.
                NEXT RLOOP.
            END.
        END.
    END CASE.
END.

DELETE PROCEDURE x-hProc.

/* ********************************************************************* */
/* RHC 30/10/18 Verificamos que todas las OTR de una R/A estén en la PHR */
/* ********************************************************************* */
DO:
    EMPTY TEMP-TABLE T-CREPO.
    FOR EACH T-RUTAD NO-LOCK WHERE T-RUTAD.CodRef = "OTR",
        FIRST Faccpedi NO-LOCK WHERE FacCPedi.CodCia = s-CodCia AND
        FacCPedi.CodDoc = T-RUTAD.CodRef AND
        FacCPedi.NroPed = T-RUTAD.NroRef AND
        Faccpedi.DivDes = s-CodDiv,
        FIRST Almcrepo NO-LOCK WHERE almcrepo.CodCia = s-CodCia AND
        almcrepo.CodAlm = Faccpedi.CodCli AND
        almcrepo.TipMov = "M" AND
        almcrepo.NroSer = INTEGER(SUBSTRING(FacCPedi.NroRef,1,3)) AND
        almcrepo.NroDoc = INTEGER(SUBSTRING(FacCPedi.NroRef,4)):
        FIND FIRST T-CREPO WHERE T-CREPO.codcia = s-CodCia AND
            T-CREPO.nroser = Almcrepo.nroser AND
            T-CREPO.nrodoc = Almcrepo.nrodoc
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE T-CREPO THEN DO:
            CREATE T-CREPO.
            BUFFER-COPY Almcrepo TO T-CREPO.
        END.
    END.
    FOR EACH T-RUTAD NO-LOCK WHERE T-RUTAD.CodRef = "OTR",
        FIRST Faccpedi NO-LOCK WHERE FacCPedi.CodCia = s-CodCia AND
        FacCPedi.CodDoc = T-RUTAD.CodRef AND
        FacCPedi.NroPed = T-RUTAD.NroRef AND
        Faccpedi.DivDes = s-CodDiv,
        FIRST Almcrepo NO-LOCK WHERE almcrepo.CodCia = s-CodCia AND
        almcrepo.CodAlm = Faccpedi.CodCli AND
        almcrepo.TipMov = "A" AND
        almcrepo.NroSer = INTEGER(SUBSTRING(FacCPedi.NroRef,1,3)) AND
        almcrepo.NroDoc = INTEGER(SUBSTRING(FacCPedi.NroRef,4)):
        FIND FIRST T-CREPO WHERE T-CREPO.codcia = s-CodCia AND
            T-CREPO.nroser = Almcrepo.nroser AND
            T-CREPO.nrodoc = Almcrepo.nrodoc
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE T-CREPO THEN DO:
            CREATE T-CREPO.
            BUFFER-COPY Almcrepo TO T-CREPO.
        END.
    END.
    FOR EACH T-CREPO NO-LOCK,
        EACH FacCPedi NO-LOCK WHERE FacCPedi.CodCia = s-CodCia AND
            FacCPedi.CodRef = "R/A" AND
            FacCPedi.NroRef = STRING(T-CREPO.NroSer, '999') + STRING(T-CREPO.NroDoc, '999999') AND
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
/* /* Mensaje con la información que NO va a ser migrada */                            */
/* DEF VAR pOk AS LOG NO-UNDO.                                                         */
/* RUN dist/d-mantto-phr-del.w(pTotales, pBloqueados, INPUT TABLE T-RutaD,OUTPUT pOk). */
/* IF pOk = NO THEN RETURN 'ADM-ERROR'.                                                */
/* IF pTotales = pBloqueados THEN DO:                                                  */
/*     MESSAGE 'TODOS los documentos tiene observaciones' SKIP                         */
/*         'Proceso abortado' VIEW-AS ALERT-BOX WARNING.                               */
/*     RETURN 'ADM-ERROR'.                                                             */
/* END.                                                                                */
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

FIND Almcdocu WHERE ROWID(Almcdocu) = pRowid NO-LOCK NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN RETURN 'OK'.
FIND Di-RutaC WHERE DI-RutaC.CodCia = Almcdocu.codcia AND
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

