&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE pt-Facdpedi NO-UNDO LIKE FacDPedi.



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
/* Sintaxis 
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN <libreria> PERSISTENT SET hProc.
RUN <libreria>.rutina_internaIN hProc (input  buffer tt-excel:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .
DELETE PROCEDURE hProc.
*/

/* ***************************  Definitions  ************************** */

DEFINE SHARED VAR s-codcia AS INT. 
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE SHARED VAR pv-codcia AS INTE.
DEFINE SHARED VAR s-coddiv AS CHAR.   
DEFINE SHARED VAR s-user-id AS CHAR.

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

/*  
    Ic - 02Ene2023
    Cualquier cambio que se realize a este programa, tener en consideracion que tambien sea
    desplegado en el servidor donde esta la base de datos (actualmente 192.168.100.210)
    Se usa para el proceso de generacion de OTR por compras - Lucy Mesia
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
      TABLE: pt-Facdpedi T "?" NO-UNDO INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 9.77
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-HPK_Genera-HPK-AGT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HPK_Genera-HPK-AGT Procedure 
PROCEDURE HPK_Genera-HPK-AGT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* La información de la tabla pt-Resumen-HPK la reducimos */

/* Buscamos los almacenes */
DEF VAR x-Almacenes AS CHAR NO-UNDO.

FOR EACH pt-Resumen-HPK NO-LOCK BREAK BY pt-Resumen-HPK.AlmDes:
    IF FIRST-OF(pt-Resumen-HPK.AlmDes) 
        THEN x-Almacenes = x-Almacenes + (IF TRUE <> (x-Almacenes > '') THEN '' ELSE ',') +
                            pt-Resumen-HPK.AlmDes.
END.

/* Barremos almacén por almacén y caso por caso */
DEF VAR x-CodAlm AS CHAR NO-UNDO.
DEF VAR k AS INTE NO-UNDO.
DEF VAR j AS INTE NO-UNDO.
DEF VAR x-Item AS INTE NO-UNDO.

EMPTY TEMP-TABLE pt-Resumen-HPK-2.

DO k = 1 TO NUM-ENTRIES(x-Almacenes):       /* Normalmente debería ser un solo almacén */
    x-CodAlm = ENTRY(k, x-Almacenes).
    /* Barremos caso por caso por este almacén */
    FOR EACH LogisConsolidaHpk NO-LOCK WHERE LogisConsolidaHpk.CodCia = s-CodCia
        AND LogisConsolidaHpk.CodAlm = x-CodAlm
        AND NUM-ENTRIES(LogisConsolidaHpk.Sectores) >= 2:
        /* Por cada caso debe haber al menos 2 sectores que cumplan */
        x-Item = 0.
        DO j = 1 TO NUM-ENTRIES(LogisConsolidaHpk.Sectores):
            FIND FIRST pt-Resumen-HPK WHERE pt-Resumen-HPK.almdes = LogisConsolidaHpk.CodAlm
                AND pt-Resumen-HPK.sector = ENTRY(j, LogisConsolidaHpk.Sectores)
                NO-LOCK NO-ERROR.
            IF AVAILABLE pt-Resumen-HPK THEN x-Item = x-Item + 1.
        END.
        /* Deben cumplir al menos 2 de los sectores */
        IF x-Item < 2 THEN NEXT.    
        DO j = 1 TO NUM-ENTRIES(LogisConsolidaHpk.Sectores):
            FOR EACH pt-Resumen-HPK EXCLUSIVE-LOCK WHERE pt-Resumen-HPK.almdes = LogisConsolidaHpk.CodAlm
                AND pt-Resumen-HPK.sector = ENTRY(j, LogisConsolidaHpk.Sectores):
                /* Acumulamos */
                FIND FIRST pt-Resumen-HPK-2 WHERE pt-Resumen-HPK-2.almdes = pt-Resumen-HPK.almdes
                    AND pt-Resumen-HPK-2.codmat = pt-Resumen-HPK.codmat
                    EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE pt-Resumen-HPK-2 THEN  DO:
                    CREATE pt-Resumen-HPK-2.
                    BUFFER-COPY pt-Resumen-HPK TO pt-Resumen-HPK-2 
                        ASSIGN 
                            pt-Resumen-HPK-2.Tipo = "ESTANTERIA"
                            pt-Resumen-HPK-2.Sector = "VA"
                            pt-Resumen-HPK-2.Caso = LogisConsolidaHpk.Caso.
                END.
                ELSE ASSIGN
                        pt-Resumen-HPK-2.CanPed = pt-Resumen-HPK-2.CanPed + pt-Resumen-HPK.CanPed
                        pt-Resumen-HPK-2.ImpLin = pt-Resumen-HPK-2.ImpLin + pt-Resumen-HPK.ImpLin.
                DELETE pt-Resumen-HPK.
            END.
        END.
    END.
END.
/* Añadimos los resumidos */
FOR EACH pt-Resumen-HPK-2:
    CREATE pt-Resumen-HPK.
    BUFFER-COPY pt-Resumen-HPK-2 TO pt-Resumen-HPK.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HPK_Genera-HPK-Grabar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HPK_Genera-HPK-Grabar Procedure 
PROCEDURE HPK_Genera-HPK-Grabar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowidPHR AS ROWID.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR xCuentaError AS INT NO-UNDO.
pMensaje = ''.

FIND Di-RutaC WHERE ROWID(Di-RutaC) = pRowidPHR NO-LOCK.
RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="Faccorre" ~
        &Alcance="FIRST" ~
        &Condicion="Faccorre.codcia = Di-RutaC.CodCia and ~
        Faccorre.coddoc = 'HPK' and ~
        Faccorre.coddiv = Di-RutaC.CodDiv and ~
        Faccorre.flgest = YES" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
        
    /* ************************************************* */
    /* 1ro. los RACK: Agrupamos por O/D y Sector         */
    /* ************************************************* */
    FOR EACH pt-Resumen-HPK WHERE pt-Resumen-HPK.Tipo = "RACK", 
        FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-CodCia AND
            Faccpedi.coddoc = pt-Resumen-HPK.CodDoc AND
            Faccpedi.nroped = pt-Resumen-HPK.NroPed 
        BREAK BY pt-Resumen-HPK.CodDoc BY pt-Resumen-HPK.NroPed BY pt-Resumen-HPK.AlmDes BY pt-Resumen-HPK.Sector:
        IF FIRST-OF(pt-Resumen-HPK.CodDoc) OR 
            FIRST-OF(pt-Resumen-HPK.NroPed) OR 
            FIRST-OF(pt-Resumen-HPK.AlmDes) OR
            FIRST-OF(pt-Resumen-HPK.Sector) THEN DO:
            CREATE VtaCDocu.
            BUFFER-COPY faccpedi TO vtacdocu
            ASSIGN
                VtaCDocu.CodTer = pt-Resumen-HPK.Tipo
                VtaCDocu.CodAlm = pt-Resumen-HPK.AlmDes
                VtaCDocu.CodCia = Di-RutaC.CodCia
                VtaCDocu.CodDiv = Di-RutaC.CodDiv
                VtaCDocu.CodPed = 'HPK'
                VtaCDocu.NroPed = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '99999999')
                VtaCDocu.CodOri = Di-RutaC.CodDoc   /* PHR */
                VtaCDocu.NroOri = Di-RutaC.NroDoc
                VtaCDocu.CodRef = pt-Resumen-HPK.CodDoc    /* O/D */
                VtaCDocu.NroRef = pt-Resumen-HPK.NroPed
                VtaCDocu.ZonaPickeo = pt-Resumen-HPK.Sector
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
        BUFFER-COPY pt-Resumen-HPK TO VtaDDocu
            ASSIGN
            VtaDDocu.CodCia = VtaCDocu.codcia
            VtaDDocu.CodDiv = VtaCDocu.coddiv
            VtaDDocu.CodPed = VtaCDocu.codped
            VtaDDocu.NroPed = VtaCDocu.nroped
            VtaDDocu.CodUbi = pt-Resumen-HPK.Sector
            VtaDDocu.Libre_c05 = pt-Resumen-HPK.Ubicacion
            VtaDDocu.CanBase = pt-Resumen-HPK.CanPed.
        IF LAST-OF(pt-Resumen-HPK.CodDoc) OR LAST-OF(pt-Resumen-HPK.NroPed) OR 
            LAST-OF(pt-Resumen-HPK.AlmDes) OR LAST-OF(pt-Resumen-HPK.Sector) THEN DO:
            ASSIGN
                VtaCDocu.FlgEst = "P"
                VtaCDocu.FlgSit = "T"
                VtaCDocu.FchPed = TODAY
                VtaCDocu.Hora   = STRING(TIME, 'HH:MM:SS')
                VtaCDocu.Usuario = s-User-Id
                VtaCDocu.libre_c05 = ''.
        END.
    END.
    FOR EACH pt-Resumen-HPK WHERE pt-Resumen-HPK.Tipo = "RACK":
        DELETE pt-Resumen-HPK.
    END.
    /* ************************************************* */
    /* 2do. el Saldo: Agrupamos por O/D y Sector         */
    /* ************************************************* */
    FOR EACH pt-Resumen-HPK,
        FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-CodCia AND
            Faccpedi.coddoc = pt-Resumen-HPK.CodDoc AND
            Faccpedi.nroped = pt-Resumen-HPK.NroPed 
        BREAK BY pt-Resumen-HPK.CodDoc BY pt-Resumen-HPK.NroPed BY pt-Resumen-HPK.AlmDes BY pt-Resumen-HPK.Sector BY pt-Resumen-HPK.Caso:
        IF FIRST-OF(pt-Resumen-HPK.CodDoc) OR 
            FIRST-OF(pt-Resumen-HPK.NroPed) OR 
            FIRST-OF(pt-Resumen-HPK.AlmDes) OR
            FIRST-OF(pt-Resumen-HPK.Sector) OR
            FIRST-OF(pt-Resumen-HPK.Caso)
            THEN DO:
            CREATE VtaCDocu.
            BUFFER-COPY faccpedi TO vtacdocu
            ASSIGN
                VtaCDocu.CodTer = "ESTANTERIA"
                VtaCDocu.CodAlm = pt-Resumen-HPK.AlmDes
                VtaCDocu.CodCia = Di-RutaC.CodCia
                VtaCDocu.CodDiv = Di-RutaC.CodDiv
                VtaCDocu.CodPed = 'HPK'
                VtaCDocu.NroPed = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '99999999')
                VtaCDocu.CodOri = Di-RutaC.CodDoc   /* PHR */
                VtaCDocu.NroOri = Di-RutaC.NroDoc
                VtaCDocu.CodRef = pt-Resumen-HPK.CodDoc    /* O/D */
                VtaCDocu.NroRef = pt-Resumen-HPK.NroPed
                VtaCDocu.ZonaPickeo = pt-Resumen-HPK.Sector
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
        BUFFER-COPY pt-Resumen-HPK TO VtaDDocu
            ASSIGN
            VtaDDocu.CodCia = VtaCDocu.codcia
            VtaDDocu.CodDiv = VtaCDocu.coddiv
            VtaDDocu.CodPed = VtaCDocu.codped
            VtaDDocu.NroPed = VtaCDocu.nroped
            VtaDDocu.CodUbi = pt-Resumen-HPK.Sector
            VtaDDocu.Libre_c05 = pt-Resumen-HPK.Ubicacion
            VtaDDocu.CanBase = pt-Resumen-HPK.CanPed.
        IF LAST-OF(pt-Resumen-HPK.CodDoc) OR 
            LAST-OF(pt-Resumen-HPK.NroPed) OR 
            LAST-OF(pt-Resumen-HPK.AlmDes) OR
            LAST-OF(pt-Resumen-HPK.Sector) OR
            LAST-OF(pt-Resumen-HPK.Caso)
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

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HPK_Genera-HPK-Grabar-v2) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HPK_Genera-HPK-Grabar-v2 Procedure 
PROCEDURE HPK_Genera-HPK-Grabar-v2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF BUFFER ORDENES FOR Faccpedi.
FIND ORDENES WHERE ROWID(ORDENES) = pRowid NO-LOCK NO-ERROR.

DEF VAR xCuentaError AS INT NO-UNDO.
pMensaje = ''.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="Faccorre" ~
        &Alcance="FIRST" ~
        &Condicion="Faccorre.codcia = s-CodCia and ~
        Faccorre.coddoc = 'HPK' and ~
        Faccorre.coddiv = ORDENES.DivDes and ~
        Faccorre.flgest = YES" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
        
    /* ************************************************* */
    /* 1ro. los RACK: Agrupamos por O/D y Sector         */
    /* ************************************************* */
    FOR EACH pt-Resumen-HPK WHERE pt-Resumen-HPK.Tipo = "RACK", 
        FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-CodCia AND
            Faccpedi.coddoc = pt-Resumen-HPK.CodDoc AND
            Faccpedi.nroped = pt-Resumen-HPK.NroPed 
        BREAK BY pt-Resumen-HPK.CodDoc BY pt-Resumen-HPK.NroPed BY pt-Resumen-HPK.AlmDes BY pt-Resumen-HPK.Sector:
        IF FIRST-OF(pt-Resumen-HPK.CodDoc) OR 
            FIRST-OF(pt-Resumen-HPK.NroPed) OR 
            FIRST-OF(pt-Resumen-HPK.AlmDes) OR
            FIRST-OF(pt-Resumen-HPK.Sector) THEN DO:
            CREATE VtaCDocu.
            BUFFER-COPY faccpedi TO vtacdocu
            ASSIGN
                VtaCDocu.CodTer = pt-Resumen-HPK.Tipo
                VtaCDocu.CodAlm = pt-Resumen-HPK.AlmDes
                VtaCDocu.CodCia = s-CodCia
                VtaCDocu.CodDiv = ORDENES.DivDes
                VtaCDocu.CodPed = 'HPK'
                VtaCDocu.NroPed = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '99999999')
/*                 VtaCDocu.CodOri = Di-RutaC.CodDoc   /* PHR */ */
/*                 VtaCDocu.NroOri = Di-RutaC.NroDoc             */
                VtaCDocu.CodRef = pt-Resumen-HPK.CodDoc    /* O/D */
                VtaCDocu.NroRef = pt-Resumen-HPK.NroPed
                VtaCDocu.ZonaPickeo = pt-Resumen-HPK.Sector
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
        BUFFER-COPY pt-Resumen-HPK TO VtaDDocu
            ASSIGN
            VtaDDocu.CodCia = VtaCDocu.codcia
            VtaDDocu.CodDiv = VtaCDocu.coddiv
            VtaDDocu.CodPed = VtaCDocu.codped
            VtaDDocu.NroPed = VtaCDocu.nroped
            VtaDDocu.CodUbi = pt-Resumen-HPK.Sector
            VtaDDocu.Libre_c05 = pt-Resumen-HPK.Ubicacion
            VtaDDocu.CanBase = pt-Resumen-HPK.CanPed.
        IF LAST-OF(pt-Resumen-HPK.CodDoc) OR LAST-OF(pt-Resumen-HPK.NroPed) OR 
            LAST-OF(pt-Resumen-HPK.AlmDes) OR LAST-OF(pt-Resumen-HPK.Sector) THEN DO:
            ASSIGN
                VtaCDocu.FlgEst = "P"
                VtaCDocu.FlgSit = "T"
                VtaCDocu.FchPed = TODAY
                VtaCDocu.Hora   = STRING(TIME, 'HH:MM:SS')
                VtaCDocu.Usuario = s-User-Id
                VtaCDocu.libre_c05 = ''.
        END.
    END.
    FOR EACH pt-Resumen-HPK WHERE pt-Resumen-HPK.Tipo = "RACK":
        DELETE pt-Resumen-HPK.
    END.
    /* ************************************************* */
    /* 2do. el Saldo: Agrupamos por O/D y Sector         */
    /* ************************************************* */
    FOR EACH pt-Resumen-HPK,
        FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-CodCia AND
            Faccpedi.coddoc = pt-Resumen-HPK.CodDoc AND
            Faccpedi.nroped = pt-Resumen-HPK.NroPed 
        BREAK BY pt-Resumen-HPK.CodDoc BY pt-Resumen-HPK.NroPed BY pt-Resumen-HPK.AlmDes BY pt-Resumen-HPK.Sector BY pt-Resumen-HPK.Caso:
        IF FIRST-OF(pt-Resumen-HPK.CodDoc) OR 
            FIRST-OF(pt-Resumen-HPK.NroPed) OR 
            FIRST-OF(pt-Resumen-HPK.AlmDes) OR
            FIRST-OF(pt-Resumen-HPK.Sector) OR
            FIRST-OF(pt-Resumen-HPK.Caso)
            THEN DO:
            CREATE VtaCDocu.
            BUFFER-COPY faccpedi TO vtacdocu
            ASSIGN
                VtaCDocu.CodTer = "ESTANTERIA"
                VtaCDocu.CodAlm = pt-Resumen-HPK.AlmDes
                VtaCDocu.CodCia = s-CodCia
                VtaCDocu.CodDiv = ORDENES.DivDes
                VtaCDocu.CodPed = 'HPK'
                VtaCDocu.NroPed = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '99999999')
/*                 VtaCDocu.CodOri = Di-RutaC.CodDoc   /* PHR */ */
/*                 VtaCDocu.NroOri = Di-RutaC.NroDoc             */
                VtaCDocu.CodRef = pt-Resumen-HPK.CodDoc    /* O/D */
                VtaCDocu.NroRef = pt-Resumen-HPK.NroPed
                VtaCDocu.ZonaPickeo = pt-Resumen-HPK.Sector
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
        BUFFER-COPY pt-Resumen-HPK TO VtaDDocu
            ASSIGN
            VtaDDocu.CodCia = VtaCDocu.codcia
            VtaDDocu.CodDiv = VtaCDocu.coddiv
            VtaDDocu.CodPed = VtaCDocu.codped
            VtaDDocu.NroPed = VtaCDocu.nroped
            VtaDDocu.CodUbi = pt-Resumen-HPK.Sector
            VtaDDocu.Libre_c05 = pt-Resumen-HPK.Ubicacion
            VtaDDocu.CanBase = pt-Resumen-HPK.CanPed.
        IF LAST-OF(pt-Resumen-HPK.CodDoc) OR 
            LAST-OF(pt-Resumen-HPK.NroPed) OR 
            LAST-OF(pt-Resumen-HPK.AlmDes) OR
            LAST-OF(pt-Resumen-HPK.Sector) OR
            LAST-OF(pt-Resumen-HPK.Caso)
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

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HPK_Genera-HPK-Master) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HPK_Genera-HPK-Master Procedure 
PROCEDURE HPK_Genera-HPK-Master :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Solo se puede genera HPK el almacenes configurados como Picking por Ruta */
DEF INPUT PARAMETER pRowidPHR AS ROWID.     /* Rowid de la PHR */
DEF INPUT PARAMETER pRowid AS ROWID.        /* Rowid de la O/D u OTR */

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

FIND Di-RutaC WHERE ROWID(Di-RutaC) = pRowidPHR NO-LOCK NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMensaje = "NO se pudo generar la HPK" + CHR(10) + "Registro PHR no encontrado".
    RETURN 'ADM-ERROR'.
END.

/* Sin HPK y con HPK */
/* Normalment PK */
/* IF LOOKUP(Di-RutaC.FlgEst, "PK,PX,PF") = 0 THEN RETURN "OK". */

DEF BUFFER B-CPEDI FOR Faccpedi.
DEF BUFFER B-DPEDI FOR Facdpedi.
    
DEF VAR pCodDiv AS CHAR NO-UNDO.

FIND B-CPEDI WHERE ROWID(B-CPEDI) = pRowid NO-LOCK NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMensaje = "NO se pudo generar la HPK" + CHR(10) + "Registro O/D u OTR no encontrado".
    RETURN 'ADM-ERROR'.
END.
/* Condiciones */
IF B-CPEDI.CodDoc = "OTR" AND B-CPEDI.TpoPed = "XD" THEN DO:
    RETURN 'OK'.
END.
/* Normalmente T y TG */
/* IF NOT ( B-CPEDI.FlgEst = "P" AND LOOKUP(B-CPEDI.FlgSit, "T,TG") > 0 ) THEN DO: */
/*     RETURN 'OK'.                                                                */
/* END.                                                                            */
/* ******************************************************** */
/* RHC 09/10/2019 Verificamos si tiene algún HPK NO anulada */
/* ******************************************************** */
ASSIGN
    pCodDiv = B-CPEDI.DivDes.

FIND FIRST Vtacdocu WHERE Vtacdocu.codcia = s-codcia AND 
    Vtacdocu.coddiv = pCodDiv AND
    Vtacdocu.codped = "HPK" AND
    Vtacdocu.codref = B-CPEDI.coddoc AND 
    Vtacdocu.nroref = B-CPEDI.nroped AND 
    Vtacdocu.flgest <> 'A'
    NO-LOCK NO-ERROR.
IF AVAILABLE Vtacdocu THEN RETURN 'OK'.
/* **************************************************************** */
/* RHC 12/10/2019 Ninguna que venga por reprogramación */
/* **************************************************************** */
FIND FIRST Almcdocu WHERE Almcdocu.codcia = s-codcia AND
    Almcdocu.coddoc = B-CPEDI.coddoc AND 
    Almcdocu.nrodoc = B-CPEDI.nroped AND
    Almcdocu.codllave = pCodDiv AND
    Almcdocu.libre_c01 = 'H/R' NO-LOCK NO-ERROR.
IF AVAILABLE Almcdocu THEN RETURN 'OK'.
/* ******************************************************** */
/* CARGAMOS TEMPORAL */
/* ******************************************************** */
EMPTY TEMP-TABLE pt-Facdpedi.      /* POR CADA O/D */
DETALLE:
FOR EACH B-DPEDI OF B-CPEDI NO-LOCK, 
    FIRST Almmmatg OF B-DPEDI NO-LOCK,
    FIRST Almtfami OF Almmmatg NO-LOCK:
    /* ******************************************** */
    /* RHC 10/07/2020 NO Servicios NO Drop Shipping */
    /* ******************************************** */
    CASE TRUE:
        WHEN Almtfami.Libre_c01 = "SV" THEN NEXT DETALLE.       /* FLETE */
        WHEN B-CPEDI.CodDoc = "O/D" THEN DO:
            FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
                VtaTabla.Tabla = "DROPSHIPPING" AND
                VtaTabla.Llave_c1 = B-DPEDI.CodMat 
                NO-LOCK NO-ERROR.
            IF AVAILABLE VtaTabla THEN NEXT DETALLE.
        END.
    END CASE.
    /* ******************************************** */
    CREATE pt-Facdpedi.
    BUFFER-COPY B-DPEDI TO pt-Facdpedi.
    /* OJO: Todo lo trabajamos en UNIDADES DE STOCK */
    ASSIGN
        pt-Facdpedi.CanPed = pt-Facdpedi.CanPed * pt-Facdpedi.Factor
        pt-Facdpedi.UndVta = Almmmatg.UndStk.
    ASSIGN
        pt-Facdpedi.Factor = 1.

END.
/* ************************************************** */
/* RHC 08/05/2020 Por ahora dos formas de Generar HPK */
/* ************************************************** */
EMPTY TEMP-TABLE pt-Resumen-HPK.   /* OJO: VALE SOLO PARA ESTA O/D U OTR */

    CASE B-CPEDI.CodDoc:
        WHEN "O/D" THEN DO:
            FIND VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
                VtaTabla.Tabla = 'CFGINC' AND
                VtaTabla.Llave_c1 = pCodDiv AND        /* División del Almacén que Despacha */
                VtaTabla.Llave_c2 = B-CPEDI.CodDiv     /* División Origen */
                NO-LOCK NO-ERROR.
        END.
        WHEN "OTR" THEN DO:
            FIND Almacen WHERE Almacen.codcia = s-codcia AND
                Almacen.codalm = B-CPEDI.CodCli
                NO-LOCK.
            FIND VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
                VtaTabla.Tabla = 'CFGINC' AND
                VtaTabla.Llave_c1 = pCodDiv AND        /* División del Almacén que Despacha */
                VtaTabla.Llave_c2 = Almacen.CodDiv
                NO-LOCK NO-ERROR.
        END.
    END CASE.

/* FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND                           */
/*     VtaTabla.Tabla = 'CFGINC' AND                                                  */
/*     VtaTabla.Llave_c1 = pCodDiv AND        /* División del Almacén que Despacha */ */
/*     VtaTabla.Llave_c2 = B-CPEDI.CodDiv     /* División Origen */                   */
/*     NO-LOCK NO-ERROR.                                                              */

CASE TRUE:
    WHEN AVAILABLE VtaTabla AND VtaTabla.Libre_c01 = "1" THEN DO:
        /* Una HPK por cada O/D */
        RUN HPK_Genera-HPK-Solo-Una.
    END.
    OTHERWISE DO:
        /* 1ro se calcula de la forma normal */
        /* Picking por Rutas */
        RUN HPK_Genera-HPK-Normal (INPUT pCodDiv).

        /* RHC 13/08/2020 Nuevas reglas de negocio */
        /* Si es a travéz de una AGENCIA DE TRANSPORTE (AGT) */
        IF CAN-FIND(FIRST CcbADocu WHERE CcbADocu.CodCia = B-CPEDI.codcia
                    AND CcbADocu.CodDiv = B-CPEDI.coddiv 
                    AND CcbADocu.CodDoc = B-CPEDI.codref   /* OJO: PED */
                    AND CcbADocu.NroDoc = B-CPEDI.nroref
                    AND CAN-FIND(FIRST gn-prov WHERE gn-prov.CodCia = pv-codcia 
                                 AND gn-prov.CodPro = CcbADocu.Libre_c[9]
                                 AND gn-prov.Girpro = "AGT" NO-LOCK)
                    NO-LOCK)
            THEN DO:
            /* 2do. Reducimos las HPK */
            RUN HPK_Genera-HPK-AGT.
        END.
    END.
END CASE.
/* *********************************************************************************** */
/* *********************************************************************************** */
/* PARTE 2: GRABAMOS LAS HPKs */
/* *********************************************************************************** */
/* *********************************************************************************** */
RUN HPK_Genera-HPK-Grabar (INPUT pRowidPHR,
                           OUTPUT pMensaje).
IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HPK_Genera-HPK-Master-v2) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HPK_Genera-HPK-Master-v2 Procedure 
PROCEDURE HPK_Genera-HPK-Master-v2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Solo se puede genera HPK el almacenes configurados como Picking por Ruta */
DEF INPUT PARAMETER pRowid AS ROWID.        /* Rowid de la O/D u OTR */

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF BUFFER B-CPEDI FOR Faccpedi.
DEF BUFFER B-DPEDI FOR Facdpedi.
    
DEF VAR pCodDiv AS CHAR NO-UNDO.

FIND B-CPEDI WHERE ROWID(B-CPEDI) = pRowid NO-LOCK NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMensaje = "NO se pudo generar la HPK" + CHR(10) + "Registro O/D u OTR no encontrado".
    RETURN 'ADM-ERROR'.
END.
/* Condiciones */
IF B-CPEDI.CodDoc = "OTR" AND B-CPEDI.TpoPed = "XD" THEN DO:
    RETURN 'OK'.
END.
/* Normalmente T y TG */
/* IF NOT ( B-CPEDI.FlgEst = "P" AND LOOKUP(B-CPEDI.FlgSit, "T,TG") > 0 ) THEN DO: */
/*     RETURN 'OK'.                                                                */
/* END.                                                                            */
/* ******************************************************** */
/* RHC 09/10/2019 Verificamos si tiene algún HPK NO anulada */
/* ******************************************************** */
ASSIGN
    pCodDiv = B-CPEDI.DivDes.

FIND FIRST Vtacdocu WHERE Vtacdocu.codcia = s-codcia AND 
    Vtacdocu.coddiv = pCodDiv AND
    Vtacdocu.codped = "HPK" AND
    Vtacdocu.codref = B-CPEDI.coddoc AND 
    Vtacdocu.nroref = B-CPEDI.nroped AND 
    Vtacdocu.flgest <> 'A'
    NO-LOCK NO-ERROR.
IF AVAILABLE Vtacdocu THEN RETURN 'OK'.
/* **************************************************************** */
/* RHC 12/10/2019 Ninguna que venga por reprogramación */
/* **************************************************************** */
FIND FIRST Almcdocu WHERE Almcdocu.codcia = s-codcia AND
    Almcdocu.coddoc = B-CPEDI.coddoc AND 
    Almcdocu.nrodoc = B-CPEDI.nroped AND
    Almcdocu.codllave = pCodDiv AND
    Almcdocu.libre_c01 = 'H/R' NO-LOCK NO-ERROR.
IF AVAILABLE Almcdocu THEN RETURN 'OK'.
/* ******************************************************** */
/* CARGAMOS TEMPORAL */
/* ******************************************************** */
EMPTY TEMP-TABLE pt-Facdpedi.      /* POR CADA O/D */
DETALLE:
FOR EACH B-DPEDI OF B-CPEDI NO-LOCK, 
    FIRST Almmmatg OF B-DPEDI NO-LOCK,
    FIRST Almtfami OF Almmmatg NO-LOCK:
    /* ******************************************** */
    /* RHC 10/07/2020 NO Servicios NO Drop Shipping */
    /* ******************************************** */
    CASE TRUE:
        WHEN Almtfami.Libre_c01 = "SV" THEN NEXT DETALLE.       /* FLETE */
        WHEN B-CPEDI.CodDoc = "O/D" THEN DO:
            FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
                VtaTabla.Tabla = "DROPSHIPPING" AND
                VtaTabla.Llave_c1 = B-DPEDI.CodMat 
                NO-LOCK NO-ERROR.
            IF AVAILABLE VtaTabla THEN NEXT DETALLE.
        END.
    END CASE.
    /* ******************************************** */
    CREATE pt-Facdpedi.
    BUFFER-COPY B-DPEDI TO pt-Facdpedi.
    /* OJO: Todo lo trabajamos en UNIDADES DE STOCK */
    ASSIGN
        pt-Facdpedi.CanPed = pt-Facdpedi.CanPed * pt-Facdpedi.Factor
        pt-Facdpedi.UndVta = Almmmatg.UndStk.
    ASSIGN
        pt-Facdpedi.Factor = 1.

END.
/* ************************************************** */
/* RHC 08/05/2020 Por ahora dos formas de Generar HPK */
/* ************************************************** */
EMPTY TEMP-TABLE pt-Resumen-HPK.   /* OJO: VALE SOLO PARA ESTA O/D U OTR */

    CASE B-CPEDI.CodDoc:
        WHEN "O/D" THEN DO:
            FIND VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
                VtaTabla.Tabla = 'CFGINC' AND
                VtaTabla.Llave_c1 = pCodDiv AND        /* División del Almacén que Despacha */
                VtaTabla.Llave_c2 = B-CPEDI.CodDiv     /* División Origen */
                NO-LOCK NO-ERROR.
        END.
        WHEN "OTR" THEN DO:
            FIND Almacen WHERE Almacen.codcia = s-codcia AND
                Almacen.codalm = B-CPEDI.CodCli
                NO-LOCK.
            FIND VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
                VtaTabla.Tabla = 'CFGINC' AND
                VtaTabla.Llave_c1 = pCodDiv AND        /* División del Almacén que Despacha */
                VtaTabla.Llave_c2 = Almacen.CodDiv
                NO-LOCK NO-ERROR.
        END.
    END CASE.

CASE TRUE:
    WHEN AVAILABLE VtaTabla AND VtaTabla.Libre_c01 = "1" THEN DO:
        /* Una HPK por cada O/D */
        RUN HPK_Genera-HPK-Solo-Una.
    END.
    OTHERWISE DO:
        /* 1ro se calcula de la forma normal */
        /* Picking por Rutas */
        RUN HPK_Genera-HPK-Normal (INPUT pCodDiv).

        /* RHC 13/08/2020 Nuevas reglas de negocio */
        /* Si es a travéz de una AGENCIA DE TRANSPORTE (AGT) */
        IF CAN-FIND(FIRST CcbADocu WHERE CcbADocu.CodCia = B-CPEDI.codcia
                    AND CcbADocu.CodDiv = B-CPEDI.coddiv 
                    AND CcbADocu.CodDoc = B-CPEDI.codref   /* OJO: PED */
                    AND CcbADocu.NroDoc = B-CPEDI.nroref
                    AND CAN-FIND(FIRST gn-prov WHERE gn-prov.CodCia = pv-codcia 
                                 AND gn-prov.CodPro = CcbADocu.Libre_c[9]
                                 AND gn-prov.Girpro = "AGT" NO-LOCK)
                    NO-LOCK)
            THEN DO:
            /* 2do. Reducimos las HPK */
            RUN HPK_Genera-HPK-AGT.
        END.
    END.
END CASE.
/* *********************************************************************************** */
/* *********************************************************************************** */
/* PARTE 2: GRABAMOS LAS HPKs */
/* *********************************************************************************** */
/* *********************************************************************************** */
RUN HPK_Genera-HPK-Grabar-v2 (INPUT pRowid, OUTPUT pMensaje).
IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HPK_Genera-HPK-Normal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HPK_Genera-HPK-Normal Procedure 
PROCEDURE HPK_Genera-HPK-Normal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER pCodDiv AS CHAR.

    /* Por cada O/D generamos el detalle de acuerdo a la regla de negocio */
    DEF VAR lSector AS CHAR NO-UNDO.
    DEF VAR lUbicacion AS CHAR NO-UNDO.

    DEF VAR x-CanPed AS DECI NO-UNDO.
    DEF VAR x-CanMaster AS DECI NO-UNDO.

    FOR EACH pt-Facdpedi, FIRST Almmmatg OF pt-Facdpedi NO-LOCK:
        FIND FIRST Almmmate WHERE Almmmate.codcia = pt-Facdpedi.CodCia AND
            Almmmate.CodAlm = pt-Facdpedi.AlmDes AND
            Almmmate.CodMat = pt-Facdpedi.CodMat
            NO-LOCK NO-ERROR.
        ASSIGN lSector = "G0" lUbicacion = ''.
        IF AVAILABLE Almmmate THEN DO:
            lUbicacion = Almmmate.CodUbi.
            /* DEFINIMOS EL SECTOR DEL PRODUCTO */
            FIND Almtubic WHERE almtubic.CodCia = Almmmate.codcia 
                AND almtubic.CodAlm = Almmmate.codalm
                AND almtubic.CodUbi = Almmmate.codubi
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtubic THEN lSector = almtubic.CodZona.
        END.
        IF NOT CAN-FIND(FIRST AlmtZona WHERE AlmtZona.CodCia = s-CodCia
                        AND AlmtZona.CodAlm = pt-Facdpedi.AlmDes
                        AND AlmtZona.CodZona = lSector NO-LOCK)
            THEN lSector = "G0".
        /* Por cada artículo vemos en cual de las clasificaciones cumple */
        FOR EACH VtaDTabla NO-LOCK WHERE VtaDTabla.CodCia = s-codcia AND
            VtaDTabla.Tabla = 'CFGHPK' AND
            VtaDTabla.Llave = pCodDiv   /* De la PHR */
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
            x-CanPed = pt-Facdpedi.CanPed.
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
                CREATE pt-Resumen-HPK.
                ASSIGN
                    pt-Resumen-HPK.CodCia = pt-Facdpedi.CodCia
                    pt-Resumen-HPK.CodDoc = pt-Facdpedi.CodDoc
                    pt-Resumen-HPK.NroPed = pt-Facdpedi.NroPed
                    pt-Resumen-HPK.AlmDes = pt-Facdpedi.AlmDes
                    pt-Resumen-HPK.CodMat = pt-Facdpedi.CodMat
                    pt-Resumen-HPK.Factor = pt-Facdpedi.Factor
                    pt-Resumen-HPK.UndVta = pt-Facdpedi.UndVta
                    pt-Resumen-HPK.Sector = lSector
                    pt-Resumen-HPK.Ubicacion = lUbicacion.
                /* Importe Referencial */
                ASSIGN
                    pt-Resumen-HPK.ImpLin = ROUND(pt-Facdpedi.ImpLin / pt-Facdpedi.CanPed * x-CanMaster, 2).
                ASSIGN
                    pt-Resumen-HPK.Tipo   = VtaDTabla.Tipo     /* ACUMULATIVO o RACK */
                    pt-Resumen-HPK.CanPed = x-CanMaster.
            END.
            IF x-CanPed > 0 THEN DO:
                CREATE pt-Resumen-HPK.
                /* El Saldo */
                ASSIGN
                    pt-Resumen-HPK.CodCia = pt-Facdpedi.CodCia
                    pt-Resumen-HPK.CodDoc = pt-Facdpedi.CodDoc
                    pt-Resumen-HPK.NroPed = pt-Facdpedi.NroPed
                    pt-Resumen-HPK.AlmDes = pt-Facdpedi.AlmDes
                    pt-Resumen-HPK.CodMat = pt-Facdpedi.CodMat
                    pt-Resumen-HPK.Factor = pt-Facdpedi.Factor
                    pt-Resumen-HPK.UndVta = pt-Facdpedi.UndVta
                    pt-Resumen-HPK.Sector = lSector
                    pt-Resumen-HPK.Ubicacion = lUbicacion.
                /* Importe Referencial */
                ASSIGN
                    pt-Resumen-HPK.ImpLin = ROUND(pt-Facdpedi.ImpLin / pt-Facdpedi.CanPed * x-CanPed, 2).
                ASSIGN
                    pt-Resumen-HPK.Tipo   = "ESTANTERIA"     /* OJO */
                    pt-Resumen-HPK.CanPed = x-CanPed.
            END.
            /* BORRAMOS LA LINEA PROCESADA Y PASAMOS AL SIGUIENTE */
            DELETE pt-Facdpedi.
            LEAVE.
        END.    /* EACH VtaDTabla */
    END.    /* EACH pt-Facdpedi */
    /* SI POR ALGUN MOTIVO QUEDAN SALDOS (¿?) => SE VAN A ESTANTES */
    FOR EACH pt-Facdpedi, FIRST Almmmatg OF pt-Facdpedi NO-LOCK:
        FIND FIRST Almmmate WHERE Almmmate.codcia = pt-Facdpedi.CodCia AND
            Almmmate.CodAlm = pt-Facdpedi.AlmDes AND
            Almmmate.CodMat = pt-Facdpedi.CodMat
            NO-LOCK NO-ERROR.
        ASSIGN lSector = "G0".
        /* DEFINIMOS EL SECTOR DEL PRODUCTO */
        IF AVAILABLE Almmmate THEN DO:
            FIND Almtubic WHERE almtubic.CodCia = Almmmate.codcia 
                AND almtubic.CodAlm = Almmmate.codalm
                AND almtubic.CodUbi = Almmmate.codubi
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtubic THEN lSector = almtubic.CodZona.
        END.
        IF NOT CAN-FIND(FIRST AlmtZona WHERE AlmtZona.CodCia = s-CodCia
                        AND AlmtZona.CodAlm = pt-Facdpedi.AlmDes
                        AND AlmtZona.CodZona = lSector NO-LOCK)
            THEN lSector = "G0".
        CREATE pt-Resumen-HPK.
        ASSIGN
            pt-Resumen-HPK.CodCia = pt-Facdpedi.CodCia
            pt-Resumen-HPK.Tipo   = "ESTANTERIA"
            pt-Resumen-HPK.CodDoc = pt-Facdpedi.CodDoc
            pt-Resumen-HPK.NroPed = pt-Facdpedi.NroPed
            pt-Resumen-HPK.AlmDes = pt-Facdpedi.AlmDes
            pt-Resumen-HPK.CodMat = pt-Facdpedi.CodMat
            pt-Resumen-HPK.CanPed = pt-Facdpedi.CanPed
            pt-Resumen-HPK.ImpLin = pt-Facdpedi.ImpLin
            pt-Resumen-HPK.Factor = pt-Facdpedi.Factor
            pt-Resumen-HPK.UndVta = pt-Facdpedi.UndVta
            pt-Resumen-HPK.Sector = lSector
            pt-Resumen-HPK.Ubicacion = lUbicacion.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HPK_Genera-HPK-Solo-Una) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HPK_Genera-HPK-Solo-Una Procedure 
PROCEDURE HPK_Genera-HPK-Solo-Una :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEF VAR lSector AS CHAR NO-UNDO.
    DEF VAR lUbicacion AS CHAR NO-UNDO.

    FOR EACH pt-Facdpedi EXCLUSIVE-LOCK:
        lSector = "CN".     /* FORZAMOS POR AHORA */
        lUbicacion = ''.

        FIND FIRST Almmmate WHERE Almmmate.codcia = pt-Facdpedi.CodCia AND
            Almmmate.CodAlm = pt-Facdpedi.AlmDes AND
            Almmmate.CodMat = pt-Facdpedi.CodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN lUbicacion = Almmmate.CodUbi.

        CREATE pt-Resumen-HPK.
        ASSIGN
            pt-Resumen-HPK.CodCia = pt-Facdpedi.CodCia
            pt-Resumen-HPK.Tipo   = "ESTANTERIA"
            pt-Resumen-HPK.CodDoc = pt-Facdpedi.CodDoc
            pt-Resumen-HPK.NroPed = pt-Facdpedi.NroPed
            pt-Resumen-HPK.AlmDes = pt-Facdpedi.AlmDes
            pt-Resumen-HPK.CodMat = pt-Facdpedi.CodMat
            pt-Resumen-HPK.CanPed = pt-Facdpedi.CanPed
            pt-Resumen-HPK.ImpLin = pt-Facdpedi.ImpLin
            pt-Resumen-HPK.Factor = pt-Facdpedi.Factor
            pt-Resumen-HPK.UndVta = pt-Facdpedi.UndVta
            pt-Resumen-HPK.Sector = lSector
            pt-Resumen-HPK.Ubicacion = lUbicacion.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

