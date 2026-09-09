&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE t-AlmDDocu NO-UNDO LIKE AlmDDocu.
DEFINE TEMP-TABLE T-DDOCU NO-UNDO LIKE VtaDDocu.



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

/* GENERACION DE HOJAS DE PICKING (HPK) A PARTIR DE UNA PRE-HOJA DE RUTA (PHR) */

DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

FIND Di-RutaC WHERE ROWID(Di-RutaC) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Di-RutaC THEN DO:
    pMensaje = "NO se ubicó la PHR" + CHR(10) + "Proceso Abortado".
    RETURN.
END.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

DEF TEMP-TABLE RESUMEN
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
    FIELD Sector AS CHAR.

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
      TABLE: PEDI T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: t-AlmDDocu T "?" NO-UNDO INTEGRAL AlmDDocu
      TABLE: T-DDOCU T "?" NO-UNDO INTEGRAL VtaDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.81
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF VAR x-CanPed AS DEC NO-UNDO.
DEF VAR x-CanMaster AS DEC NO-UNDO.
DEF VAR lSector AS CHAR NO-UNDO.
DEF VAR lUbic AS CHAR NO-UNDO.
DEF VAR lSectorOK AS LOG NO-UNDO.

pMensaje = ''.
/* ***************************************************************************************** */
/* ***************************************************************************************** */
/* 1ra. PARTE: Carga del archivo temporal DETALLE */
/* ***************************************************************************************** */
RUN Carga-Resumen.

/* ***************************************************************************************** */
/* ***************************************************************************************** */
/* ***************************************************************************************** */
/* 2da. PARTE: Generamos los HPK de acuerdo a la tabla DETALLE
    Primero: los ACUMULATIVO
    Segundo: lo demás se considera por SECTOR
*/
RUN Genera-HPK.
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo generar la Hoja de Piqueo".
    RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.
/* ***************************************************************************************** */
/* ***************************************************************************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Carga-Resumen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Resumen Procedure 
PROCEDURE Carga-Resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Barremos la información de la PHR */
EMPTY TEMP-TABLE RESUMEN.   /* VALE PARA TODA LA PHR */
/*OUTPUT TO d:\tmp\datos.txt.*/
FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
    FIRST Faccpedi NO-LOCK WHERE FacCPedi.CodCia = Di-RutaD.CodCia AND
    FacCPedi.CodDoc = Di-RutaD.CodRef AND       /* O/D */
    FacCPedi.NroPed = Di-RutaD.NroRef AND 
    FacCPedi.FlgEst = "P":
    IF NOT FacCPedi.FlgSit = "T" THEN NEXT.     /* RHC 28/01/2019 */
/*     IF Faccpedi.FlgSit = "C" THEN NEXT.  */
/*     IF Faccpedi.FlgSit = "PC" THEN NEXT. */
/*     IF Faccpedi.FlgSit = "PT" THEN NEXT. */
/*     IF CAN-FIND(FIRST Vtacdocu WHERE Vtacdocu.codcia = s-codcia AND */
/*                 Vtacdocu.coddiv = s-coddiv AND                      */
/*                 Vtacdocu.codped = "HPK" AND                         */
/*                 Vtacdocu.codref = Faccpedi.coddoc AND               */
/*                 Vtacdocu.nroref = Faccpedi.nroped AND               */
/*                 Vtacdocu.flgest <> 'A' NO-LOCK)                     */
/*         THEN NEXT.                                                  */
    /* CARGAMOS TEMPORAL */
    EMPTY TEMP-TABLE PEDI.      /* POR CADA O/D */
    FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
        CREATE PEDI.
        BUFFER-COPY Facdpedi TO PEDI.
        /* OJO: Todo lo trabajamos en UNIDADES DE STOCK */
        ASSIGN
            PEDI.CanPed = PEDI.CanPed * PEDI.Factor
            PEDI.UndVta = Almmmatg.UndStk.
        ASSIGN
            PEDI.Factor = 1.
    END.
    /* Por cada O/D generamos el detalle de acuerdo a la regla de negocio */
    FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK:
        FIND FIRST Almmmate WHERE Almmmate.codcia = PEDI.CodCia AND
            Almmmate.CodAlm = PEDI.AlmDes AND
            Almmmate.CodMat = PEDI.CodMat
            NO-LOCK NO-ERROR.
        ASSIGN
            lSector = ''
            lUbic = ''.
        IF AVAILABLE Almmmate THEN DO:
            /* DEFINIMOS EL SECTOR DEL PRODUCTO */
            lSector = CAPS(SUBSTRING(Almmmate.CodUbi,1,2)).
            lUbic = TRIM(Almmmate.CodUbi).
        END.
        lSectorOK = NO.
        /* Si el sector es Correcto y el codigo de la ubicacion esta OK */
        IF (lSector >= '01' AND lSector <= '06') AND LENGTH(lUbic) = 7 THEN DO:
            /* Ubic Ok */
            lSectorOK = YES.
        END.
        ELSE DO:
            lSector = "G0".
        END.        
        /* Por cada artículo vemos en cual de las clasificaciones cumple */
        FOR EACH VtaDTabla NO-LOCK WHERE VtaDTabla.CodCia = s-codcia AND
            VtaDTabla.Tabla = 'CFGHPK' AND
            VtaDTabla.Llave = Di-RutaC.CodDiv   /* De la PHR */
            BY VtaDTabla.Libre_d01:     /* por ORDEN */
            /* La regla de negocio es de dos tipos:
            ACUMULATIVO: debe cumplir la LINEA y SUBLINEA 
            RACK: TODOS
            */
            CASE VtaDTabla.Tipo:
                WHEN "ACUMULATIVO" THEN DO:
                    /* Debe cumplir por lo menos la LINEA */
                    IF Almmmatg.CodFam <> VtaDTabla.Libre_c01 THEN NEXT.
                    IF VtaDTabla.Libre_c02 > '' AND Almmmatg.SubFam <> VtaDTabla.Libre_c02 THEN NEXT.
                    IF VtaDTabla.Libre_c03 > '' AND Almmmatg.CodMat <> VtaDTabla.Libre_c03 THEN NEXT.
                END.
                WHEN "RACK" THEN DO:
                    /* No hay límites */
                END.
            END CASE.
            /* La cantidad puede redondearse al empaque Master o no */
            x-CanPed = PEDI.CanPed.
            x-CanMaster = 0.
            IF VtaDTabla.Libre_l01 = YES AND Almmmatg.CanEmp > 0 THEN DO:
                x-CanMaster = TRUNCATE((x-CanPed / Almmmatg.CanEmp), 0).
                x-CanMaster = x-CanMaster * Almmmatg.CanEmp.
                x-CanPed = x-CanPed - x-CanMaster.
            END.
            /* Dos posibilidades:
                Cubre el empaque master
                No llega al empaque master
                */
            IF x-CanMaster > 0 THEN DO:
                CREATE RESUMEN.
                ASSIGN
                    RESUMEN.CodCia = PEDI.CodCia
                    RESUMEN.CodDoc = PEDI.CodDoc
                    RESUMEN.NroPed = PEDI.NroPed
                    RESUMEN.AlmDes = PEDI.AlmDes
                    RESUMEN.CodMat = PEDI.CodMat
                    RESUMEN.Factor = PEDI.Factor
                    RESUMEN.UndVta = PEDI.UndVta
                    RESUMEN.Sector = lSector.
                /* Importe Referencial */
                ASSIGN
                    RESUMEN.ImpLin = ROUND(PEDI.ImpLin / PEDI.CanPed * x-CanMaster, 2).
                ASSIGN
                    RESUMEN.Tipo   = VtaDTabla.Tipo     /* ACUMULATIVO o RACK */
                    RESUMEN.CanPed = x-CanMaster.
                /*PUT UNFORMATTED 'uno|' resumen.tipo '|' resumen.coddoc '|' resumen.nroped '|' resumen.codmat '|' resumen.canped SKIP.*/
            END.
            IF x-CanPed > 0 THEN DO:
                CREATE RESUMEN.
                /* El Saldo */
                ASSIGN
                    RESUMEN.CodCia = PEDI.CodCia
                    RESUMEN.CodDoc = PEDI.CodDoc
                    RESUMEN.NroPed = PEDI.NroPed
                    RESUMEN.AlmDes = PEDI.AlmDes
                    RESUMEN.CodMat = PEDI.CodMat
                    RESUMEN.Factor = PEDI.Factor
                    RESUMEN.UndVta = PEDI.UndVta
                    RESUMEN.Sector = lSector.
                /* Importe Referencial */
                ASSIGN
                    RESUMEN.ImpLin = ROUND(PEDI.ImpLin / PEDI.CanPed * x-CanPed, 2).
                ASSIGN
                    RESUMEN.Tipo   = "ESTANTERIA"     /* OJO */
                    RESUMEN.CanPed = x-CanPed.
                /*PUT UNFORMATTED 'dos|' resumen.tipo '|' resumen.coddoc '|' resumen.nroped '|' resumen.codmat '|' resumen.canped SKIP.*/
            END.
            /* BORRAMOS LA LINEA PROCESADA Y PASAMOS AL SIGUIENTE */
            DELETE PEDI.
            LEAVE.
        END.    /* EACH VtaDTabla */
    END.    /* EACH PEDI */
    /* SI POR ALGUN MOTIVO QUEDAN SALDOS => SE VAN A ESTANTES */
    FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK:
        FIND FIRST Almmmate WHERE Almmmate.codcia = PEDI.CodCia AND
            Almmmate.CodAlm = PEDI.AlmDes AND
            Almmmate.CodMat = PEDI.CodMat
            NO-LOCK NO-ERROR.
        ASSIGN
            lSector = ''
            lUbic = ''.
        /* DEFINIMOS EL SECTOR DEL PRODUCTO */
        IF AVAILABLE Almmmate THEN DO:
            lSector = CAPS(SUBSTRING(Almmmate.CodUbi,1,2)).
            lUbic = TRIM(Almmmate.CodUbi).
        END.
        lSectorOK = NO.
        /* Si el sector es Correcto y el codigo de la ubicacion esta OK */
        IF (lSector >= '01' AND lSector <= '06') AND LENGTH(lUbic) = 7 THEN DO:
            /* Ubic Ok */
            lSectorOK = YES.
        END.
        ELSE DO:
            lSector = "G0".
        END.        
        CREATE RESUMEN.
        ASSIGN
            RESUMEN.CodCia = PEDI.CodCia
            RESUMEN.Tipo   = "ESTANTERIA"
            RESUMEN.CodDoc = PEDI.CodDoc
            RESUMEN.NroPed = PEDI.NroPed
            RESUMEN.AlmDes = PEDI.AlmDes
            RESUMEN.CodMat = PEDI.CodMat
            RESUMEN.CanPed = PEDI.CanPed
            RESUMEN.ImpLin = PEDI.ImpLin
            RESUMEN.Factor = PEDI.Factor
            RESUMEN.UndVta = PEDI.UndVta
            RESUMEN.Sector = lSector.
        /*PUT UNFORMATTED 'tres|' resumen.tipo '|' resumen.coddoc '|' resumen.nroped '|' resumen.codmat '|' resumen.canped SKIP.*/
    END.    /* EACH PEDI */
END.
/*OUTPUT CLOSE.*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Genera-HPK) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-HPK Procedure 
PROCEDURE Genera-HPK :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR xCuentaError AS INT NO-UNDO.
pMensaje = ''.
RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Bloqueamos Cabecera PHR */
    FIND CURRENT DI-RutaC EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="xCuentaError"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* Volvemos a verificar la PHR */
    IF NOT DI-RutaC.FlgEst = 'PX' THEN DO:
        pMensaje = "La Pre-Hoja de Ruta NO está pendiente de generar Hoja de Piqueo".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        DI-RutaC.FlgEst = "PK". /* Con Hoja de Picking */

    {lib/lock-genericov3.i ~
        &Tabla="Faccorre" ~
        &Alcance="FIRST" ~
        &Condicion="Faccorre.codcia = DI-RutaC.CodCia and ~
        Faccorre.coddoc = 'HPK' and ~
        Faccorre.coddiv = DI-RutaC.CodDiv and ~
        Faccorre.flgest = YES" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
        
    /* ************************************************* */
    /* 1ro. los ACUMULATIVO: No importa de que O/D viene */
    /* Se genera un HPK por cada ALMACEN de DESPACHO     */
    /* ************************************************* */
    EMPTY TEMP-TABLE T-DDOCU.
    EMPTY TEMP-TABLE t-AlmDDocu.
    FOR EACH RESUMEN WHERE RESUMEN.Tipo = "ACUMULATIVO"
        BREAK BY RESUMEN.AlmDes BY RESUMEN.CodMat:
        IF FIRST-OF(RESUMEN.AlmDes) OR FIRST-OF(RESUMEN.CodMat) THEN DO:
            CREATE T-DDOCU.
            ASSIGN
                T-DDOCU.CodCia = s-CodCia
                T-DDOCU.AlmDes = RESUMEN.AlmDes
                T-DDOCU.CodMat = RESUMEN.CodMat
                T-DDOCU.Factor = RESUMEN.Factor
                T-DDOCU.UndVta = RESUMEN.UndVta
                T-DDOCU.CodUbi = RESUMEN.Sector.
        END.
        ASSIGN
            T-DDOCU.CanPed = T-DDOCU.CanPed + RESUMEN.CanPed
            T-DDOCU.ImpLin = T-DDOCU.ImpLin + RESUMEN.ImpLin.
        /* *************************************************************************** */
        /* Esto va a detalle */
        /* *************************************************************************** */
        CREATE t-AlmDDocu.
        ASSIGN
            t-AlmDDocu.CodCia = s-CodCia
            t-AlmDDocu.CodDoc = RESUMEN.CodDoc  /* O/D */
            t-AlmDDocu.NroDoc = RESUMEN.NroPed
            t-AlmDDocu.Tipo   = RESUMEN.Tipo
            t-AlmDDocu.Codigo = RESUMEN.CodMat
            t-AlmDDocu.Libre_d01 = RESUMEN.CanPed
            t-AlmDDocu.Libre_d02 = RESUMEN.Factor
            t-AlmDDocu.Libre_d03 = RESUMEN.CanPed   /*  Cant. Base */
            t-AlmDDocu.Libre_c01 = RESUMEN.UndVta
            t-AlmDDocu.Libre_c02 = RESUMEN.Sector.
        /* *************************************************************************** */
        /* *************************************************************************** */
        IF LAST-OF(RESUMEN.AlmDes) THEN DO:
            /* NO tiene una O/D como referencia */
            CREATE VtaCDocu.
            ASSIGN
                VtaCDocu.CodTer = RESUMEN.Tipo
                VtaCDocu.CodAlm = RESUMEN.AlmDes
                VtaCDocu.CodCia = Di-RutaC.CodCia
                VtaCDocu.CodDiv = Di-RutaC.CodDiv
                VtaCDocu.CodPed = 'HPK'
                VtaCDocu.NroPed = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '99999999')
                VtaCDocu.CodOri = Di-RutaC.CodDoc   /* PHR */
                VtaCDocu.NroOri = Di-RutaC.NroDoc
                NO-ERROR.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="xCuentaError"}
                UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
            ASSIGN 
                FacCorre.Correlativo = FacCorre.Correlativo + 1.
            ASSIGN
                VtaCDocu.FlgEst = "P"
                VtaCDocu.FlgSit = "T"
                VtaCDocu.FchPed = TODAY
                VtaCDocu.Hora   = STRING(TIME, 'HH:MM:SS')
                VtaCDocu.Usuario = s-User-Id
                VtaCDocu.libre_c05 = ''.
            FOR EACH T-DDOCU:
                CREATE VtaDDocu.
                BUFFER-COPY T-DDOCU TO VtaDDocu
                    ASSIGN
                    VtaDDocu.CodCia = VtaCDocu.codcia
                    VtaDDocu.CodDiv = VtaCDocu.coddiv
                    VtaDDocu.CodPed = VtaCDocu.codped
                    VtaDDocu.NroPed = VtaCDocu.nroped
                    VtaDDocu.CanBase = T-DDOCU.CanPed.
            END.
            FOR EACH t-AlmDDocu:
                CREATE AlmDDocu.
                BUFFER-COPY t-AlmDDocu TO AlmDDocu
                    ASSIGN AlmDDocu.CodLlave = VtaCDocu.CodPed + ',' + VtaCDocu.NroPed.
            END.
            /* ********************************************************************************* */
            /* REFLEJAMOS TRACKING DE LA OD */
            /* ********************************************************************************* */
            RUN logis/actualiza-flgsit (INPUT ROWID(VtaCDocu)).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                pMensaje = 'NO se pudo actualizar el tracking de O/D'.
                UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
            /* ********************************************************************************* */
            /* LIMPIAMOS TEMPORAL */
            EMPTY TEMP-TABLE T-DDOCU.
            EMPTY TEMP-TABLE t-AlmDDocu.
        END.
    END.
    FOR EACH RESUMEN WHERE RESUMEN.Tipo = "ACUMULATIVO":
        DELETE RESUMEN.
    END.
    /* ************************************************* */
    /* 2do. los RACK: Agrupamos por O/D y Sector         */
    /* ************************************************* */
    EMPTY TEMP-TABLE T-DDOCU.
    FOR EACH RESUMEN WHERE RESUMEN.Tipo = "RACK", 
        FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-CodCia AND
            Faccpedi.coddoc = RESUMEN.CodDoc AND
            Faccpedi.nroped = RESUMEN.NroPed 
        BREAK BY RESUMEN.CodDoc BY RESUMEN.NroPed BY RESUMEN.AlmDes BY RESUMEN.Sector:
        IF FIRST-OF(RESUMEN.CodDoc) OR 
            FIRST-OF(RESUMEN.NroPed) OR 
            FIRST-OF(RESUMEN.AlmDes) OR
            FIRST-OF(RESUMEN.Sector) THEN DO:
            CREATE VtaCDocu.
            BUFFER-COPY faccpedi TO vtacdocu
            ASSIGN
                VtaCDocu.CodTer = RESUMEN.Tipo
                VtaCDocu.CodAlm = RESUMEN.AlmDes
                VtaCDocu.CodCia = Di-RutaC.CodCia
                VtaCDocu.CodDiv = Di-RutaC.CodDiv
                VtaCDocu.CodPed = 'HPK'
                VtaCDocu.NroPed = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '99999999')
                /*VtaCDocu.NroPed = Di-RutaC.NroDoc + "-" + RESUMEN.Sector*/
                VtaCDocu.CodOri = Di-RutaC.CodDoc   /* PHR */
                VtaCDocu.NroOri = Di-RutaC.NroDoc
                VtaCDocu.CodRef = RESUMEN.CodDoc    /* O/D */
                VtaCDocu.NroRef = RESUMEN.NroPed
                VtaCDocu.ZonaPickeo = RESUMEN.Sector
                NO-ERROR.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="xCuentaError"}
                UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
            ASSIGN 
                FacCorre.Correlativo = FacCorre.Correlativo + 1.
            ASSIGN
                VtaCDocu.CodCli = Faccpedi.CodCli
                VtaCDocu.DirCli = Faccpedi.DirCli
                VtaCDocu.DniCli = Faccpedi.Atencion
                VtaCDocu.FchEnt = Faccpedi.FchEnt
                VtaCDocu.Glosa  = Faccpedi.Glosa
                VtaCDocu.CodVen = Faccpedi.CodVen
                VtaCDocu.Sede = Faccpedi.CodDiv.
            ASSIGN
                VtaCDocu.FlgEst = "P"
                VtaCDocu.FlgSit = "T"
                VtaCDocu.FchPed = TODAY
                VtaCDocu.Hora   = STRING(TIME, 'HH:MM:SS')
                VtaCDocu.Usuario = s-User-Id
                VtaCDocu.libre_c05 = ''.
        END.
        CREATE VtaDDocu.
        BUFFER-COPY RESUMEN TO VtaDDocu
            ASSIGN
            VtaDDocu.CodCia = VtaCDocu.codcia
            VtaDDocu.CodDiv = VtaCDocu.coddiv
            VtaDDocu.CodPed = VtaCDocu.codped
            VtaDDocu.NroPed = VtaCDocu.nroped
            VtaDDocu.CodUbi = RESUMEN.Sector
            VtaDDocu.CanBase = RESUMEN.CanPed.
        IF LAST-OF(RESUMEN.CodDoc) OR 
            LAST-OF(RESUMEN.NroPed) OR 
            LAST-OF(RESUMEN.AlmDes) OR
            LAST-OF(RESUMEN.Sector) THEN DO:
            /* ********************************************************************************* */
            /* REFLEJAMOS TRACKING DE LA OD */
            /* ********************************************************************************* */
            RUN logis/actualiza-flgsit (INPUT ROWID(VtaCDocu)).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                pMensaje = 'NO se pudo actualizar el tracking de O/D'.
                UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
            /* ********************************************************************************* */
        END.
    END.
    FOR EACH RESUMEN WHERE RESUMEN.Tipo = "RACK":
        DELETE RESUMEN.
    END.
    /* ************************************************* */
    /* 3do. el Saldo: Agrupamos por O/D y Sector         */
    /* ************************************************* */
    EMPTY TEMP-TABLE T-DDOCU.
    FOR EACH RESUMEN,
        FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-CodCia AND
            Faccpedi.coddoc = RESUMEN.CodDoc AND
            Faccpedi.nroped = RESUMEN.NroPed 
        BREAK BY RESUMEN.CodDoc BY RESUMEN.NroPed BY RESUMEN.AlmDes BY RESUMEN.Sector:
        IF FIRST-OF(RESUMEN.CodDoc) OR 
            FIRST-OF(RESUMEN.NroPed) OR 
            FIRST-OF(RESUMEN.AlmDes) OR
            FIRST-OF(RESUMEN.Sector) THEN DO:
            CREATE VtaCDocu.
            BUFFER-COPY faccpedi TO vtacdocu
            ASSIGN
                VtaCDocu.CodTer = "ESTANTERIA"
                VtaCDocu.CodAlm = RESUMEN.AlmDes
                VtaCDocu.CodCia = Di-RutaC.CodCia
                VtaCDocu.CodDiv = Di-RutaC.CodDiv
                VtaCDocu.CodPed = 'HPK'
                VtaCDocu.NroPed = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '99999999')
                /*VtaCDocu.NroPed = Di-RutaC.NroDoc + "-" + RESUMEN.Sector*/
                VtaCDocu.CodOri = Di-RutaC.CodDoc   /* PHR */
                VtaCDocu.NroOri = Di-RutaC.NroDoc
                VtaCDocu.CodRef = RESUMEN.CodDoc    /* O/D */
                VtaCDocu.NroRef = RESUMEN.NroPed
                VtaCDocu.ZonaPickeo = RESUMEN.Sector
                NO-ERROR.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="xCuentaError"}
                UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
            ASSIGN 
                FacCorre.Correlativo = FacCorre.Correlativo + 1.
            ASSIGN
                VtaCDocu.CodCli = Faccpedi.CodCli
                VtaCDocu.DirCli = Faccpedi.DirCli
                VtaCDocu.DniCli = Faccpedi.Atencion
                VtaCDocu.FchEnt = Faccpedi.FchEnt
                VtaCDocu.Glosa  = Faccpedi.Glosa
                VtaCDocu.CodVen = Faccpedi.CodVen
                VtaCDocu.Sede = Faccpedi.CodDiv.
            ASSIGN
                VtaCDocu.FlgEst = "P"
                VtaCDocu.FlgSit = "T"
                VtaCDocu.FchPed = TODAY
                VtaCDocu.Hora   = STRING(TIME, 'HH:MM:SS')
                VtaCDocu.Usuario = s-User-Id
                VtaCDocu.libre_c05 = ''.
        END.
        CREATE VtaDDocu.
        BUFFER-COPY RESUMEN TO VtaDDocu
            ASSIGN
            VtaDDocu.CodCia = VtaCDocu.codcia
            VtaDDocu.CodDiv = VtaCDocu.coddiv
            VtaDDocu.CodPed = VtaCDocu.codped
            VtaDDocu.NroPed = VtaCDocu.nroped
            VtaDDocu.CodUbi = RESUMEN.Sector
            VtaDDocu.CanBase = RESUMEN.CanPed.
        IF LAST-OF(RESUMEN.CodDoc) OR 
            LAST-OF(RESUMEN.NroPed) OR 
            LAST-OF(RESUMEN.AlmDes) OR
            LAST-OF(RESUMEN.Sector) THEN DO:
            /* ********************************************************************************* */
            /* REFLEJAMOS TRACKING DE LA OD */
            /* ********************************************************************************* */
            RUN logis/actualiza-flgsit (INPUT ROWID(VtaCDocu)).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                pMensaje = 'NO se pudo actualizar el tracking de O/D'.
                UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
            /* ********************************************************************************* */
        END.
    END.
END.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(Vtaddocu) THEN RELEASE Vtaddocu.
IF AVAILABLE(Vtacdocu) THEN RELEASE Vtacdocu.
IF AVAILABLE(DI-RutaC) THEN RELEASE DI-RutaC.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

