&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.
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
    RETURN 'ADM-ERROR'.
END.

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR pv-codcia AS INTE.
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
    FIELD Sector AS CHAR
    FIELD Ubicacion AS CHAR
    FIELD Caso LIKE LogisConsolidaHpk.Caso
    .

DEF TEMP-TABLE RESUMEN-1 LIKE RESUMEN.
DEF TEMP-TABLE RESUMEN-2 LIKE RESUMEN.

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
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: t-AlmDDocu T "?" NO-UNDO INTEGRAL AlmDDocu
      TABLE: T-DDOCU T "?" NO-UNDO INTEGRAL VtaDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 7.62
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
  Notes:       SIN FLETES
------------------------------------------------------------------------------*/

/* Barremos la información de la PHR */
EMPTY TEMP-TABLE RESUMEN-1.   /* VALE PARA TODA LA PHR */
FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
    FIRST Faccpedi NO-LOCK WHERE FacCPedi.CodCia = Di-RutaD.CodCia AND
    FacCPedi.CodDoc = Di-RutaD.CodRef AND       /* O/D u OTR */
    FacCPedi.NroPed = Di-RutaD.NroRef AND
    (FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = "TG"):
    IF Faccpedi.CodDoc = 'OTR' AND Faccpedi.TpoPed = 'XD' THEN NEXT.
    /* ******************************************************** */
    /* RHC 09/10/2019 Verificamos si tiene algún HPK NO anulada */
    /* ******************************************************** */
    FIND FIRST Vtacdocu WHERE Vtacdocu.codcia = s-codcia AND 
        Vtacdocu.codref = Faccpedi.coddoc AND 
        Vtacdocu.nroref = Faccpedi.nroped AND 
        Vtacdocu.coddiv = s-coddiv AND
        Vtacdocu.codped = "HPK" AND
        Vtacdocu.flgest <> 'A'
        NO-LOCK NO-ERROR.
    IF AVAILABLE Vtacdocu THEN NEXT.    /* Pasa al siguiente registro */
    /* **************************************************************** */
    /* RHC 12/10/2019 Ninguna que venga por reprogramación */
    /* **************************************************************** */
    FIND FIRST Almcdocu WHERE Almcdocu.codcia = s-codcia AND
        Almcdocu.codllave = s-coddiv AND
        Almcdocu.coddoc = Faccpedi.coddoc AND 
        Almcdocu.nrodoc = Faccpedi.nroped AND
        Almcdocu.libre_c01 = 'H/R' NO-LOCK NO-ERROR.
    IF AVAILABLE Almcdocu THEN NEXT.
    /* ******************************************************** */
    /* CARGAMOS TEMPORAL */
    /* ******************************************************** */
    EMPTY TEMP-TABLE PEDI.      /* POR CADA O/D */
    DETALLE:
    FOR EACH Facdpedi OF Faccpedi NO-LOCK, 
        FIRST Almmmatg OF Facdpedi NO-LOCK,
        FIRST Almtfami OF Almmmatg NO-LOCK:
        /* ******************************************** */
        /* RHC 10/07/2020 NO Servicios NO Drop Shipping */
        /* ******************************************** */
        CASE TRUE:
            WHEN Almtfami.Libre_c01 = "SV" THEN NEXT DETALLE.       /* FLETE */
            WHEN Faccpedi.CodDoc = "O/D" THEN DO:
                FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
                    VtaTabla.Tabla = "DROPSHIPPING" AND
                    VtaTabla.Llave_c1 = Facdpedi.CodMat 
                    NO-LOCK NO-ERROR.
/*                 FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND */
/*                     VtaTabla.Tabla = "DROPSHIPPING" AND                  */
/*                     VtaTabla.Llave_c1 = Faccpedi.CodDiv AND              */
/*                     VtaTabla.Llave_c2 = Facdpedi.CodMat                  */
/*                     NO-LOCK NO-ERROR.                                    */
                IF AVAILABLE VtaTabla THEN NEXT DETALLE.
            END.
        END CASE.
        /* ******************************************** */
        CREATE PEDI.
        BUFFER-COPY Facdpedi TO PEDI.
        /* OJO: Todo lo trabajamos en UNIDADES DE STOCK */
        ASSIGN
            PEDI.CanPed = PEDI.CanPed * PEDI.Factor
            PEDI.UndVta = Almmmatg.UndStk.
        ASSIGN
            PEDI.Factor = 1.
    END.
    /* ************************************************** */
    /* RHC 08/05/2020 Por ahora dos formas de Generar HPK */
    /* ************************************************** */
    EMPTY TEMP-TABLE RESUMEN.   /* OJO: VALE SOLO PARA ESTA O/D U OTR */
    CASE Faccpedi.CodDoc:
        WHEN "O/D" THEN DO:
            FIND VtaTabla WHERE VtaTabla.CodCia = Faccpedi.CodCia AND
                VtaTabla.Tabla = 'CFGINC' AND
                VtaTabla.Llave_c1 = s-CodDiv AND        /* División del Almacén que Despacha */
                VtaTabla.Llave_c2 = Faccpedi.CodDiv     /* División Origen */
                NO-LOCK NO-ERROR.
        END.
        WHEN "OTR" THEN DO:
            FIND Almacen WHERE Almacen.codcia = s-codcia AND
                Almacen.codalm = Faccpedi.CodCli
                NO-LOCK.
            FIND VtaTabla WHERE VtaTabla.CodCia = Faccpedi.CodCia AND
                VtaTabla.Tabla = 'CFGINC' AND
                VtaTabla.Llave_c1 = s-CodDiv AND        /* División del Almacén que Despacha */
                VtaTabla.Llave_c2 = Almacen.CodDiv
                NO-LOCK NO-ERROR.
        END.
    END CASE.
    CASE TRUE:
        WHEN AVAILABLE VtaTabla AND VtaTabla.Libre_c01 = "1" THEN DO:
            /* Una HPK por cada O/D */
            RUN Una-HPK-por-OD.
        END.
        OTHERWISE DO:
            /* 1ro se calcula de la forma normal */
            /* Picking por Rutas */
            RUN Picking-por-Rutas.
            /* RHC 13/08/2020 Nuevas reglas de negocio */
            /* Si es a travéz de una AGENCIA DE TRANSPORTE (AGT) */
            IF CAN-FIND(FIRST CcbADocu WHERE CcbADocu.CodCia = Faccpedi.codcia
                        AND CcbADocu.CodDiv = Faccpedi.coddiv 
                        AND CcbADocu.CodDoc = Faccpedi.codref   /* OJO: PED */
                        AND CcbADocu.NroDoc = Faccpedi.nroref
                        AND CAN-FIND(FIRST gn-prov WHERE gn-prov.CodCia = pv-codcia 
                                     AND gn-prov.CodPro = CcbADocu.Libre_c[9]
                                     AND gn-prov.Girpro = "AGT" NO-LOCK)
                        NO-LOCK)
                THEN DO:
                /* 2do. Reducimos las HPK */
                RUN Menos-Bultos.
            END.
        END.
    END CASE.
    /* ACUMULAMOS */
    FOR EACH RESUMEN:
        CREATE RESUMEN-1.
        BUFFER-COPY RESUMEN TO RESUMEN-1.
    END.
END.
EMPTY TEMP-TABLE RESUMEN.
FOR EACH RESUMEN-1:
    CREATE RESUMEN.
    BUFFER-COPY RESUMEN-1 TO RESUMEN.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Carga-Resumen-Old) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Resumen-Old Procedure 
PROCEDURE Carga-Resumen-Old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Barremos la información de la PHR */
EMPTY TEMP-TABLE RESUMEN.   /* VALE PARA TODA LA PHR */
FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
    FIRST Faccpedi NO-LOCK WHERE FacCPedi.CodCia = Di-RutaD.CodCia AND
    FacCPedi.CodDoc = Di-RutaD.CodRef AND       /* O/D */
    FacCPedi.NroPed = Di-RutaD.NroRef AND
    (FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = "TG"):
    IF Faccpedi.CodDoc = 'OTR' AND Faccpedi.TpoPed = 'XD' THEN NEXT.
    /* ******************************************************** */
    /* RHC 09/10/2019 Verificamos si tiene algún HPK NO anulada */
    /* ******************************************************** */
    FIND FIRST Vtacdocu WHERE Vtacdocu.codcia = s-codcia AND 
        Vtacdocu.coddiv = s-coddiv AND
        Vtacdocu.codped = "HPK" AND
        Vtacdocu.codref = Faccpedi.coddoc AND 
        Vtacdocu.nroref = Faccpedi.nroped AND 
        Vtacdocu.flgest <> 'A'
        NO-LOCK NO-ERROR.
    IF AVAILABLE Vtacdocu THEN NEXT.    /* Pasa al siguiente registro */
    /* **************************************************************** */
    /* RHC 12/10/2019 Ninguna que venga por reprogramación */
    /* **************************************************************** */
    FIND FIRST Almcdocu WHERE Almcdocu.codcia = s-codcia AND
        Almcdocu.coddoc = Faccpedi.coddoc AND 
        Almcdocu.nrodoc = Faccpedi.nroped AND
        Almcdocu.codllave = s-coddiv AND
        Almcdocu.libre_c01 = 'H/R' NO-LOCK NO-ERROR.
    IF AVAILABLE Almcdocu THEN NEXT.
    /* ******************************************************** */
    /* CARGAMOS TEMPORAL */
    EMPTY TEMP-TABLE PEDI.      /* POR CADA O/D */
    FOR EACH Facdpedi OF Faccpedi NO-LOCK, 
        FIRST Almmmatg OF Facdpedi NO-LOCK,
        FIRST Almtfami OF Almmmatg NO-LOCK WHERE Almtfami.Libre_c01 <> "SV":    /* SIN FLETE */
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
            CASE VtaDTabla.Tipo:
                WHEN "RACK" THEN DO:
                    /* SECTORES */
                    IF VtaDTabla.Libre_c04 > '' THEN DO:
                        IF lSector <> VtaDTabla.Libre_c04 THEN NEXT.
                    END.
                    /* LINEAS */
                    IF VtaDTabla.Libre_c01 > '' THEN DO:
                        IF Almmmatg.CodFam <> VtaDTabla.Libre_c01 THEN NEXT.
                        IF VtaDTabla.Libre_c02 > '' AND Almmmatg.SubFam <> VtaDTabla.Libre_c02
                            THEN NEXT.
                    END.
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
            END.
            /* BORRAMOS LA LINEA PROCESADA Y PASAMOS AL SIGUIENTE */
            DELETE PEDI.
            LEAVE.
        END.    /* EACH VtaDTabla */
    END.    /* EACH PEDI */
    /* SI POR ALGUN MOTIVO QUEDAN SALDOS (¿?) => SE VAN A ESTANTES */
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
    END.
END.

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
    /* 1ro. los RACK: Agrupamos por O/D y Sector         */
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
                VtaCDocu.CodOri = Di-RutaC.CodDoc   /* PHR */
                VtaCDocu.NroOri = Di-RutaC.NroDoc
                VtaCDocu.CodRef = RESUMEN.CodDoc    /* O/D */
                VtaCDocu.NroRef = RESUMEN.NroPed
                VtaCDocu.ZonaPickeo = RESUMEN.Sector
                VtaCDocu.EmpaqEspec = FacCPedi.EmpaqEspec
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
        END.
        CREATE VtaDDocu.
        BUFFER-COPY RESUMEN TO VtaDDocu
            ASSIGN
            VtaDDocu.CodCia = VtaCDocu.codcia
            VtaDDocu.CodDiv = VtaCDocu.coddiv
            VtaDDocu.CodPed = VtaCDocu.codped
            VtaDDocu.NroPed = VtaCDocu.nroped
            VtaDDocu.CodUbi = RESUMEN.Sector
            VtaDDocu.Libre_c05 = RESUMEN.Ubicacion
            VtaDDocu.CanBase = RESUMEN.CanPed.
        IF LAST-OF(RESUMEN.CodDoc) OR LAST-OF(RESUMEN.NroPed) OR 
            LAST-OF(RESUMEN.AlmDes) OR LAST-OF(RESUMEN.Sector) THEN DO:
            ASSIGN
                VtaCDocu.FlgEst = "P"
                VtaCDocu.FlgSit = "T"
                VtaCDocu.FchPed = TODAY
                VtaCDocu.Hora   = STRING(TIME, 'HH:MM:SS')
                VtaCDocu.Usuario = s-User-Id
                VtaCDocu.libre_c05 = ''.
        END.
    END.
    FOR EACH RESUMEN WHERE RESUMEN.Tipo = "RACK":
        DELETE RESUMEN.
    END.
    /* ************************************************* */
    /* 2do. el Saldo: Agrupamos por O/D y Sector         */
    /* ************************************************* */
    EMPTY TEMP-TABLE T-DDOCU.
    FOR EACH RESUMEN,
        FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-CodCia AND
            Faccpedi.coddoc = RESUMEN.CodDoc AND
            Faccpedi.nroped = RESUMEN.NroPed 
        BREAK BY RESUMEN.CodDoc BY RESUMEN.NroPed BY RESUMEN.AlmDes BY RESUMEN.Sector BY RESUMEN.Caso:
        IF FIRST-OF(RESUMEN.CodDoc) OR 
            FIRST-OF(RESUMEN.NroPed) OR 
            FIRST-OF(RESUMEN.AlmDes) OR
            FIRST-OF(RESUMEN.Sector) OR
            FIRST-OF(RESUMEN.Caso)
            THEN DO:
            CREATE VtaCDocu.
            BUFFER-COPY faccpedi TO vtacdocu
            ASSIGN
                VtaCDocu.CodTer = "ESTANTERIA"
                VtaCDocu.CodAlm = RESUMEN.AlmDes
                VtaCDocu.CodCia = Di-RutaC.CodCia
                VtaCDocu.CodDiv = Di-RutaC.CodDiv
                VtaCDocu.CodPed = 'HPK'
                VtaCDocu.NroPed = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '99999999')
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
        END.
        CREATE VtaDDocu.
        BUFFER-COPY RESUMEN TO VtaDDocu
            ASSIGN
            VtaDDocu.CodCia = VtaCDocu.codcia
            VtaDDocu.CodDiv = VtaCDocu.coddiv
            VtaDDocu.CodPed = VtaCDocu.codped
            VtaDDocu.NroPed = VtaCDocu.nroped
            VtaDDocu.CodUbi = RESUMEN.Sector
            VtaDDocu.Libre_c05 = RESUMEN.Ubicacion
            VtaDDocu.CanBase = RESUMEN.CanPed.
        IF LAST-OF(RESUMEN.CodDoc) OR 
            LAST-OF(RESUMEN.NroPed) OR 
            LAST-OF(RESUMEN.AlmDes) OR
            LAST-OF(RESUMEN.Sector) OR
            LAST-OF(RESUMEN.Caso)
            THEN DO:
            ASSIGN
                VtaCDocu.FlgEst = "P"
                VtaCDocu.FlgSit = "T"
                VtaCDocu.FchPed = TODAY
                VtaCDocu.Hora   = STRING(TIME, 'HH:MM:SS')
                VtaCDocu.Usuario = s-User-Id
                VtaCDocu.libre_c05 = ''.
        END.
    END.
END.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(Vtaddocu) THEN RELEASE Vtaddocu.
IF AVAILABLE(Vtacdocu) THEN RELEASE Vtacdocu.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Menos-Bultos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Menos-Bultos Procedure 
PROCEDURE Menos-Bultos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       SESTAMOS TRABAJANDO SOLO CON LA O/D U OTR ACTIVA
------------------------------------------------------------------------------*/

/* La información de la tabla RESUMEN la reducimos */

/* Buscamos los almacenes */
DEF VAR x-Almacenes AS CHAR NO-UNDO.

FOR EACH RESUMEN NO-LOCK BREAK BY RESUMEN.AlmDes:
    IF FIRST-OF(RESUMEN.AlmDes) 
        THEN x-Almacenes = x-Almacenes + (IF TRUE <> (x-Almacenes > '') THEN '' ELSE ',') +
                            RESUMEN.AlmDes.
END.

/* Barremos almacén por almacén y caso por caso */
DEF VAR x-CodAlm AS CHAR NO-UNDO.
DEF VAR k AS INTE NO-UNDO.
DEF VAR j AS INTE NO-UNDO.
DEF VAR x-Item AS INTE NO-UNDO.

EMPTY TEMP-TABLE RESUMEN-2.

DO k = 1 TO NUM-ENTRIES(x-Almacenes):       /* Normalmente debería ser un solo almacén */
    x-CodAlm = ENTRY(k, x-Almacenes).
    /* Barremos caso por caso por este almacén */
    FOR EACH LogisConsolidaHpk NO-LOCK WHERE LogisConsolidaHpk.CodCia = s-CodCia
        AND LogisConsolidaHpk.CodAlm = x-CodAlm
        AND NUM-ENTRIES(LogisConsolidaHpk.Sectores) >= 2:
        /* Por cada caso debe haber al menos 2 sectores que cumplan */
        x-Item = 0.
        DO j = 1 TO NUM-ENTRIES(LogisConsolidaHpk.Sectores):
            FIND FIRST RESUMEN WHERE RESUMEN.almdes = LogisConsolidaHpk.CodAlm
                AND RESUMEN.sector = ENTRY(j, LogisConsolidaHpk.Sectores)
                NO-LOCK NO-ERROR.
            IF AVAILABLE RESUMEN THEN x-Item = x-Item + 1.
        END.
        /* Deben cumplir al menos 2 de los sectores */
        IF x-Item < 2 THEN NEXT.    
        DO j = 1 TO NUM-ENTRIES(LogisConsolidaHpk.Sectores):
            FOR EACH RESUMEN EXCLUSIVE-LOCK WHERE RESUMEN.almdes = LogisConsolidaHpk.CodAlm
                AND RESUMEN.sector = ENTRY(j, LogisConsolidaHpk.Sectores):
                /* Acumulamos */
                FIND FIRST RESUMEN-2 WHERE RESUMEN-2.almdes = RESUMEN.almdes
                    AND RESUMEN-2.codmat = RESUMEN.codmat
                    EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE RESUMEN-2 THEN  DO:
                    CREATE RESUMEN-2.
                    BUFFER-COPY RESUMEN TO RESUMEN-2 
                        ASSIGN 
                            RESUMEN-2.Tipo = "ESTANTERIA"
                            RESUMEN-2.Sector = "VA"
                            RESUMEN-2.Caso = LogisConsolidaHpk.Caso.
                END.
                ELSE ASSIGN
                        RESUMEN-2.CanPed = RESUMEN-2.CanPed + RESUMEN.CanPed
                        RESUMEN-2.ImpLin = RESUMEN-2.ImpLin + RESUMEN.ImpLin.
                DELETE RESUMEN.
            END.
        END.
    END.
END.
/* Añadimos los resumidos */
FOR EACH RESUMEN-2:
    CREATE RESUMEN.
    BUFFER-COPY RESUMEN-2 TO RESUMEN.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Picking-por-Rutas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Picking-por-Rutas Procedure 
PROCEDURE Picking-por-Rutas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Por cada O/D generamos el detalle de acuerdo a la regla de negocio */
    DEF VAR lUbicacion AS CHAR NO-UNDO.
    FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK:
        FIND FIRST Almmmate WHERE Almmmate.codcia = PEDI.CodCia AND
            Almmmate.CodAlm = PEDI.AlmDes AND
            Almmmate.CodMat = PEDI.CodMat
            NO-LOCK NO-ERROR.
        ASSIGN lSector = "G0" lUbicacion = "".
        IF AVAILABLE Almmmate THEN DO:
            /* DEFINIMOS EL SECTOR DEL PRODUCTO */
            FIND Almtubic WHERE almtubic.CodCia = Almmmate.codcia 
                AND almtubic.CodAlm = Almmmate.codalm
                AND almtubic.CodUbi = Almmmate.codubi
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtubic THEN ASSIGN lSector = almtubic.CodZona lUbicacion = Almmmate.CodUbi.
        END.
        IF NOT CAN-FIND(FIRST AlmtZona WHERE AlmtZona.CodCia = s-CodCia
                        AND AlmtZona.CodAlm = PEDI.AlmDes
                        AND AlmtZona.CodZona = lSector NO-LOCK)
            THEN lSector = "G0".
        /* Por cada artículo vemos en cual de las clasificaciones cumple */
        FOR EACH VtaDTabla NO-LOCK WHERE VtaDTabla.CodCia = s-codcia AND
            VtaDTabla.Tabla = 'CFGHPK' AND
            VtaDTabla.Llave = Di-RutaC.CodDiv   /* De la PHR */
            BY VtaDTabla.Libre_d01:     /* por ORDEN */
            CASE VtaDTabla.Tipo:
                WHEN "RACK" THEN DO:
                    /* SECTORES */
                    IF VtaDTabla.Libre_c04 > '' THEN DO:
                        IF lSector <> VtaDTabla.Libre_c04 THEN NEXT.
                    END.
                    /* LINEAS */
                    IF VtaDTabla.Libre_c01 > '' THEN DO:
                        IF Almmmatg.CodFam <> VtaDTabla.Libre_c01 THEN NEXT.
                        IF VtaDTabla.Libre_c02 > '' AND Almmmatg.SubFam <> VtaDTabla.Libre_c02
                            THEN NEXT.
                    END.
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
                    RESUMEN.Sector = lSector
                    RESUMEN.Ubicacion = lUbicacion
                    .
                /* Importe Referencial */
                ASSIGN
                    RESUMEN.ImpLin = ROUND(PEDI.ImpLin / PEDI.CanPed * x-CanMaster, 2).
                ASSIGN
                    RESUMEN.Tipo   = VtaDTabla.Tipo     /* ACUMULATIVO o RACK */
                    RESUMEN.CanPed = x-CanMaster.
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
                    RESUMEN.Sector = lSector
                    RESUMEN.Ubicacion = lUbicacion
                    .
                /* Importe Referencial */
                ASSIGN
                    RESUMEN.ImpLin = ROUND(PEDI.ImpLin / PEDI.CanPed * x-CanPed, 2).
                ASSIGN
                    RESUMEN.Tipo   = "ESTANTERIA"     /* OJO */
                    RESUMEN.CanPed = x-CanPed.
            END.
            /* BORRAMOS LA LINEA PROCESADA Y PASAMOS AL SIGUIENTE */
            DELETE PEDI.
            LEAVE.
        END.    /* EACH VtaDTabla */
    END.    /* EACH PEDI */
    /* SI POR ALGUN MOTIVO QUEDAN SALDOS (¿?) => SE VAN A ESTANTES */
    FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK:
        FIND FIRST Almmmate WHERE Almmmate.codcia = PEDI.CodCia AND
            Almmmate.CodAlm = PEDI.AlmDes AND
            Almmmate.CodMat = PEDI.CodMat
            NO-LOCK NO-ERROR.
        ASSIGN lSector = "G0" lUbicacion = "".
        /* DEFINIMOS EL SECTOR DEL PRODUCTO */
        IF AVAILABLE Almmmate THEN DO:
            FIND Almtubic WHERE almtubic.CodCia = Almmmate.codcia 
                AND almtubic.CodAlm = Almmmate.codalm
                AND almtubic.CodUbi = Almmmate.codubi
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtubic THEN ASSIGN lSector = almtubic.CodZona lUbicacion = Almmmate.CodUbi.
        END.
        IF NOT CAN-FIND(FIRST AlmtZona WHERE AlmtZona.CodCia = s-CodCia
                        AND AlmtZona.CodAlm = PEDI.AlmDes
                        AND AlmtZona.CodZona = lSector NO-LOCK)
            THEN lSector = "G0".
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
            RESUMEN.Sector = lSector
            RESUMEN.Ubicacion = lUbicacion
            .
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Una-HPK-por-OD) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Una-HPK-por-OD Procedure 
PROCEDURE Una-HPK-por-OD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

                                        
    DEF VAR lUbicacion AS CHAR NO-UNDO.

    FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK:
        lUbicacion = "".
        FIND FIRST Almmmate WHERE Almmmate.codcia = PEDI.CodCia AND
            Almmmate.CodAlm = PEDI.AlmDes AND
            Almmmate.CodMat = PEDI.CodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN lUbicacion = Almmmate.CodUbi.
        lSector = "CN".
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
            RESUMEN.Sector = lSector
            RESUMEN.Ubicacion = lUbicacion
            .
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

