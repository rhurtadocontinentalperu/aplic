&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-ADocu FOR CcbADocu.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : CREACIOn/ANULACION AUTOMATICA DE LA ORDEN DE DESPACHO

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       : Parche para ventas crédito LIMA
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pEvento AS CHAR.

DEF BUFFER B-CPEDI FOR Faccpedi.
DEF BUFFER B-DPEDI FOR Facdpedi.

DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-codcia AS INT.
DEF VAR s-CodDoc AS CHAR INIT 'O/D'.
DEF VAR s-NroSer AS INT.
DEF VAR s-FlgPicking LIKE GN-DIVI.FlgPicking.
DEF VAR s-FlgBarras LIKE GN-DIVI.FlgBarras.

CASE pEvento:
    WHEN 'CREATE' THEN DO:
        FIND B-CPEDI WHERE ROWID(B-CPEDI) = pRowid NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-CPEDI THEN RETURN 'OK'.
        ASSIGN
            s-CodCia = B-CPEDI.CodCia.
        FIND FIRST FacCorre WHERE FacCorre.codcia = s-CodCia
            AND FacCorre.coddoc = s-coddoc
            /*AND FacCorre.coddiv = ccbcdocu.divori*/
            AND FacCorre.coddiv = B-CPEDI.CodDiv
            AND FacCorre.flgest = YES
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE FacCorre THEN RETURN 'OK'.
        ASSIGN
            s-NroSer = FacCorre.NroSer.
    END.
    WHEN 'DELETE' THEN DO:
        FIND Ccbcdocu WHERE ROWID(Ccbcdocu) = pRowid NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Ccbcdocu THEN RETURN 'OK'.
        ASSIGN
            s-CodCia = Ccbcdocu.CodCia.
    END.
    OTHERWISE RETURN 'OK'.
END CASE.

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
      TABLE: B-ADocu B "?" ? INTEGRAL CcbADocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 6.23
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */


CASE pEvento:
    WHEN 'CREATE'    THEN DO:
        RUN Proc-Create.
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    END.
    WHEN 'WRITE'    THEN DO:
        RUN Proc-Write.
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    END.
    WHEN 'DELETE'   THEN DO:
        RUN Proc-Delete.
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    END.
END CASE.

RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Proc-Create) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Proc-Create Procedure 
PROCEDURE Proc-Create :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Si una factura es anulada y vuelta a crear hay que partir de la O/D ya registrada */
DEF VAR s-adm-new-record AS CHAR.
DEF VAR x-NroItm LIKE Facdpedi.nroitm.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND FIRST FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK.
    FOR EACH B-DPEDI OF B-CPEDI NO-LOCK, 
        FIRST Almacen NO-LOCK WHERE Almacen.codcia = B-DPEDI.codcia
        AND Almacen.codalm = B-DPEDI.almdes
        BREAK BY B-DPEDI.AlmDes:
        IF FIRST-OF(B-DPEDI.AlmDes) THEN DO:
            /* Buscar si la O/D ya fue registrada */
            FIND FacCPedi WHERE FacCPedi.codcia = B-CPEDI.codcia
                AND FacCPedi.codref = B-CPEDI.coddoc
                AND FacCPedi.nroref = B-CPEDI.nroped
                AND FacCPedi.coddoc = s-coddoc
                AND FacCPedi.codalm = B-DPEDI.almdes
                AND FacCPedi.flgest <> 'A'
                NO-LOCK NO-ERROR.
            s-adm-new-record = 'YES'.
            IF AVAILABLE FacCPedi THEN DO:
                s-adm-new-record = 'NO'.
                x-NroItm = 0.
                FOR EACH Facdpedi OF Faccpedi NO-LOCK:
                    x-NroItm = x-NroItm + 1.
                END.
            END.
            IF s-adm-new-record = 'YES' THEN DO:    /* NUEVA O/D */
                {vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}
                CREATE Faccpedi.
                BUFFER-COPY B-CPEDI
                    TO Faccpedi
                    ASSIGN
                    FacCPedi.DivDes = Almacen.coddiv
                    FacCPedi.CodAlm = Almacen.codalm
                    FacCPedi.CodDoc = s-coddoc
                    FacCPedi.NroPed = STRING(faccorre.nroser, '999') + STRING(faccorre.correlativo, '999999')
                    FacCPedi.CodRef = B-CPEDI.coddoc
                    FacCPedi.NroRef = B-CPEDI.nroped
                    FacCPedi.FchPed = TODAY
                    FacCPedi.Hora   = STRING(TIME, 'HH:MM:SS')
                    FacCPedi.FlgEst = 'C'       /* ATENDIDO */
                    FacCPedi.TpoPed = ''
                    FacCPedi.usuario = s-user-id.
                ASSIGN
                    FacCorre.Correlativo = FacCorre.Correlativo + 1
                    x-NroItm = 0.
                FIND gn-divi WHERE gn-divi.codcia = Faccpedi.codcia
                    AND gn-divi.coddiv = Faccpedi.divdes
                    NO-LOCK.
                ASSIGN
                    s-FlgPicking = GN-DIVI.FlgPicking
                    s-FlgBarras  = GN-DIVI.FlgBarras.
                IF s-FlgPicking = YES THEN FacCPedi.FlgSit = "T".    /* Por Pickear */
                IF s-FlgPicking = NO AND s-FlgBarras = NO THEN FacCPedi.FlgSit = "C".    /* Barras OK */
                IF s-FlgPicking = NO AND s-FlgBarras = YES THEN FacCPedi.FlgSit = "P".   /* Picking OK */
            END.
        END.
        FIND FacDPedi OF FacCPedi WHERE FacDPedi.codmat = B-DPEDI.codmat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE FacDPedi THEN DO:
            x-NroItm = x-NroItm + 1.
            CREATE Facdpedi.
            BUFFER-COPY B-DPEDI
                TO Facdpedi
                ASSIGN  
                    FacDPedi.CodCia  = FacCPedi.CodCia 
                    FacDPedi.coddiv  = FacCPedi.coddiv 
                    FacDPedi.coddoc  = FacCPedi.coddoc 
                    FacDPedi.NroPed  = FacCPedi.NroPed 
                    FacDPedi.FchPed  = FacCPedi.FchPed
                    FacDPedi.Hora    = FacCPedi.Hora 
                    FacDPedi.FlgEst  = FacCPedi.FlgEst
                    FacDPedi.NroItm  = x-NroItm
                    FacDPedi.CanAte  = B-DPEDI.CanPed
                    FacDPedi.CanPick = B-DPEDI.CanPed.     /* <<< OJO <<< */
        END.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Proc-Delete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Proc-Delete Procedure 
PROCEDURE Proc-Delete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-NroItm LIKE Facdpedi.nroitm.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND Faccpedi WHERE Faccpedi.codcia = Ccbcdocu.codcia
        AND Faccpedi.coddiv = Ccbcdocu.DivOri
        AND Faccpedi.coddoc = Ccbcdocu.Libre_c01
        AND Faccpedi.nroped = Ccbcdocu.Libre_c02
        EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE Faccpedi THEN DO:
        FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
            FIND Facdpedi OF Faccpedi WHERE Facdpedi.codmat = Ccbddocu.codmat
                AND Facdpedi.almdes = Ccbddocu.almdes
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Facdpedi THEN UNDO, RETURN 'ADM-ERROR'.
            DELETE Facdpedi.
        END.
        /* renumeramos items */
        x-NroItm = 1.
        FOR EACH Facdpedi OF Faccpedi:
            Facdpedi.NroItm = x-NroItm.
            x-NroItm = x-NroItm + 1.
        END.
        FIND FIRST Facdpedi OF Faccpedi NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Facdpedi 
            THEN ASSIGN 
                    Faccpedi.FlgEst = "A"
                    Faccpedi.Glosa = " A N U L A D O".
    END.
    RELEASE Faccpedi.
    RELEASE Facdpedi.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Proc-Write) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Proc-Write Procedure 
PROCEDURE Proc-Write :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND FIRST FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK.
    FIND CURRENT Ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcdocu THEN UNDO, RETURN 'ADM-ERROR'.
    IF Ccbcdocu.Libre_c01 = s-coddoc THEN DO:
        /* UPDATE */
        FIND Faccpedi WHERE Faccpedi.codcia = Ccbcdocu.codcia
            AND Faccpedi.coddoc = Ccbcdocu.Libre_c01
            AND Faccpedi.nroped = Ccbcdocu.Libre_c02
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccpedi THEN UNDO, RETURN 'ADM-ERROR'.
        FOR EACH Facdpedi OF Faccpedi:
            DELETE Facdpedi.
        END.
    END.
    ELSE DO:
        /* CREATE */
        {vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}

        FIND Almacen WHERE Almacen.codcia = ccbcdocu.codcia
            AND Almacen.codalm = ccbcdocu.codalm
            NO-LOCK.
        CREATE Faccpedi.
        BUFFER-COPY Ccbcdocu
            TO Faccpedi
            ASSIGN
            FacCPedi.DivDes = Almacen.coddiv
            FacCPedi.CodAlm = Almacen.codalm
            FacCPedi.CodDoc = s-coddoc
            FacCPedi.NroPed = STRING(faccorre.nroser, '999') + STRING(faccorre.correlativo, '999999')
            FacCPedi.FchPed = ccbcdocu.fchdoc
            FacCPedi.Hora = STRING(TIME, 'HH:MM')
            FacCPedi.CodRef = ccbcdocu.codped
            FacCPedi.NroRef = ccbcdocu.nroped
            FacCPedi.FlgEst = 'C'       /* ATENDICO */
            FacCPedi.Atencion = ccbcdocu.codant
            FacCPedi.usuario = s-user-id.
        ASSIGN
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
        ASSIGN
            CcbCDocu.Libre_c01 = FacCPedi.CodDoc        /* CONTROL ADICIONAL */
            CcbCDocu.Libre_c02 = FacCPedi.NroPed.
    END.
    FIND gn-divi WHERE gn-divi.codcia = Faccpedi.codcia
        AND gn-divi.coddiv = Faccpedi.divdes
        NO-LOCK.
    ASSIGN
        s-FlgPicking = GN-DIVI.FlgPicking
        s-FlgBarras  = GN-DIVI.FlgBarras.
    IF s-FlgPicking = YES THEN FacCPedi.FlgSit = "T".    /* Por Pickear */
    IF s-FlgPicking = NO AND s-FlgBarras = NO THEN FacCPedi.FlgSit = "C".    /* Barras OK */
    IF s-FlgPicking = NO AND s-FlgBarras = YES THEN FacCPedi.FlgSit = "P".   /* Picking OK */

    FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
        CREATE Facdpedi.
        BUFFER-COPY ccbddocu 
            TO facdpedi
            ASSIGN  
                FacDPedi.CodCia  = FacCPedi.CodCia 
                FacDPedi.coddiv  = FacCPedi.coddiv 
                FacDPedi.coddoc  = FacCPedi.coddoc 
                FacDPedi.NroPed  = FacCPedi.NroPed 
                FacDPedi.FchPed  = FacCPedi.FchPed
                FacDPedi.Hora    = FacCPedi.Hora 
                FacDPedi.FlgEst  = FacCPedi.FlgEst
                FacDPedi.CanPed  = ccbddocu.candes
                FacDPedi.CanAte  = ccbddocu.candes
                FacDPedi.CanPick = ccbddocu.candes.     /* <<< OJO <<< */
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

