&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
          cissac           PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR cissac.CcbCDocu.
DEFINE TEMP-TABLE CDEVO NO-UNDO LIKE INTEGRAL.Almcmov.
DEFINE TEMP-TABLE CDOCU NO-UNDO LIKE cissac.CcbCDocu.
DEFINE TEMP-TABLE CINGR NO-UNDO LIKE INTEGRAL.Almcmov.
DEFINE TEMP-TABLE DDEVO NO-UNDO LIKE INTEGRAL.Almdmov.
DEFINE TEMP-TABLE DDOCU NO-UNDO LIKE cissac.CcbDDocu.
DEFINE TEMP-TABLE DINGR NO-UNDO LIKE INTEGRAL.Almdmov.



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

DEF INPUT PARAMETER COMBO-BOX-NroMes AS INT.
DEF INPUT PARAMETER COMBO-BOX-Periodo AS INT.
DEF INPUT PARAMETER TABLE FOR CDEVO.
DEF INPUT PARAMETER TABLE FOR DDEVO.
DEF INPUT PARAMETER TABLE FOR CDOCU.
DEF INPUT PARAMETER TABLE FOR DDOCU.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-codalm AS CHAR INIT "21" NO-UNDO.
DEF VAR s-coddiv AS CHAR INIT "00021" NO-UNDO.

FIND cissac.Almacen WHERE cissac.Almacen.codcia = s-codcia
    AND cissac.Almacen.codalm = s-codalm
    NO-LOCK NO-ERROR.
IF AVAILABLE cissac.Almacen THEN s-coddiv = cissac.Almacen.coddiv.

DISABLE TRIGGERS FOR LOAD OF cissac.almcmov.
DISABLE TRIGGERS FOR LOAD OF cissac.almdmov.
DISABLE TRIGGERS FOR LOAD OF cissac.Almtdocm.
DISABLE TRIGGERS FOR LOAD OF cissac.Almacen.
DISABLE TRIGGERS FOR LOAD OF cissac.ccbcdocu.
DISABLE TRIGGERS FOR LOAD OF cissac.ccbddocu.
DISABLE TRIGGERS FOR LOAD OF cissac.faccorre.
DISABLE TRIGGERS FOR LOAD OF cissac.faccfggn.

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
      TABLE: B-CDOCU B "?" ? cissac CcbCDocu
      TABLE: CDEVO T "?" NO-UNDO INTEGRAL Almcmov
      TABLE: CDOCU T "?" NO-UNDO cissac CcbCDocu
      TABLE: CINGR T "?" NO-UNDO INTEGRAL Almcmov
      TABLE: DDEVO T "?" NO-UNDO INTEGRAL Almdmov
      TABLE: DDOCU T "?" NO-UNDO cissac CcbDDocu
      TABLE: DINGR T "?" NO-UNDO INTEGRAL Almdmov
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 7
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    RUN Ingreso-por-Devolucion.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    
    RUN Notas-de-Credito-por-Devolucion.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
END.

RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Ingreso-por-Devolucion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ingreso-por-Devolucion Procedure 
PROCEDURE Ingreso-por-Devolucion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-FechaD AS DATE NO-UNDO.
DEF VAR x-FechaH AS DATE NO-UNDO.
DEF VAR I-NROSER AS INT  NO-UNDO.
DEF VAR I-NRODOC AS INT  NO-UNDO.
DEF VAR r-Rowid AS ROWID NO-UNDO.

FIND cissac.FacCfgGn WHERE cissac.FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

RUN src/bin/_dateif (COMBO-BOX-NroMes, COMBO-BOX-Periodo, OUTPUT x-FechaD, OUTPUT x-FechaH).

EMPTY TEMP-TABLE CINGR.
EMPTY TEMP-TABLE DINGR.

trloop:                                                                                  
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND cissac.Almacen WHERE cissac.Almacen.CodCia = S-CODCIA 
        AND cissac.Almacen.CodAlm = s-codalm
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE cissac.Almacen THEN UNDO, RETURN 'ADM-ERROR'.
    FIND FIRST cissac.FacCorre WHERE cissac.FacCorre.CodCia = S-CODCIA 
        AND cissac.FacCorre.CodDoc = "D/F"
        AND cissac.FacCorre.CodDiv = s-coddiv
        AND cissac.FacCorre.CodAlm = s-codalm
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'NO configurado el correlativo para el documento D/F, división' s-coddiv
            SKIP 'Proceso abortado'
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    FOR EACH CDEVO NO-LOCK, 
        FIRST cissac.Ccbcdocu WHERE cissac.Ccbcdocu.codcia = s-codcia
        AND cissac.Ccbcdocu.coddoc = CDEVO.codref
        AND cissac.Ccbcdocu.nrodoc = CDEVO.nroref NO-LOCK:
        ASSIGN 
            I-NroDoc = cissac.Almacen.CorrIng.
        REPEAT:
            IF NOT CAN-FIND(FIRST cissac.Almcmov WHERE cissac.Almcmov.CodCia = s-CodCia
                            AND cissac.Almcmov.CodAlm = s-codalm
                            AND cissac.Almcmov.TipMov = "I"
                            AND cissac.Almcmov.CodMov = 09
                            AND cissac.Almcmov.NroSer = 000
                            AND cissac.Almcmov.NroDoc = i-NroDoc
                            NO-LOCK)
                THEN LEAVE.
            i-NroDoc = i-NroDoc + 1.
        END.

        CREATE cissac.Almcmov.
        ASSIGN 
            cissac.Almcmov.CodCia = S-CodCia 
            cissac.Almcmov.CodAlm = s-codalm
            cissac.Almcmov.TipMov = "I"
            cissac.Almcmov.CodMov = 09
            cissac.Almcmov.NroSer = 000
            cissac.Almcmov.NroDoc = I-NRODOC
            cissac.Almcmov.FchDoc = x-FechaH
            cissac.Almcmov.CodRef = CDEVO.CodRef
            cissac.Almcmov.NroRf1 = CDEVO.NroRef
            cissac.Almcmov.NroRef = CDEVO.NroRef
            cissac.Almcmov.NroRf3 = STRING(COMBO-BOX-Periodo, "9999") + STRING(COMBO-BOX-NroMes, "99")
            cissac.Almcmov.CodDoc = "DEVCOCI"
            cissac.Almcmov.CodMon = CDEVO.CodMon
            cissac.Almcmov.TpoCmb = cissac.FacCfgGn.Tpocmb[1]
            cissac.Almcmov.FlgEst = "C"
            cissac.Almcmov.HorRcp = "23:59:59"
            cissac.Almcmov.usuario = S-USER-ID
            cissac.Almcmov.CodCli = "20100038146".      /* CONTINENTAL */
        FIND cissac.gn-clie WHERE cissac.gn-clie.CodCia = cl-codcia 
            AND cissac.gn-clie.CodCli = cissac.Almcmov.CodCli NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN cissac.Almcmov.nomref = gn-clie.NomCli.
        ASSIGN
            cissac.Almacen.CorrIng = i-NroDoc + 1.

        ASSIGN 
            I-NroSer = cissac.FacCorre.NroSer
            I-NroDoc = cissac.FacCorre.Correlativo
            cissac.FacCorre.Correlativo = cissac.FacCorre.Correlativo + 1.
        ASSIGN 
          cissac.Almcmov.NroRf2 = STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999").

        CREATE CINGR.
        BUFFER-COPY cissac.Almcmov TO CINGR.

        FOR EACH DDEVO OF CDEVO NO-LOCK, 
            FIRST cissac.Ccbddocu OF cissac.Ccbcdocu NO-LOCK WHERE cissac.Ccbddocu.codmat = DDEVO.codmat,
            FIRST cissac.Almmmatg OF cissac.Ccbddocu NO-LOCK:
            CREATE cissac.almdmov.
            ASSIGN 
                cissac.almdmov.CodCia = cissac.Almcmov.CodCia 
                cissac.almdmov.CodAlm = cissac.Almcmov.CodAlm 
                cissac.almdmov.TipMov = cissac.Almcmov.TipMov 
                cissac.almdmov.CodMov = cissac.Almcmov.CodMov 
                cissac.almdmov.NroSer = cissac.Almcmov.NroSer
                cissac.almdmov.NroDoc = cissac.Almcmov.NroDoc 
                cissac.almdmov.CodMon = cissac.Almcmov.CodMon 
                cissac.almdmov.FchDoc = cissac.Almcmov.FchDoc 
                cissac.almdmov.TpoCmb = cissac.Almcmov.TpoCmb 
                cissac.almdmov.codmat = DDEVO.codmat
                cissac.almdmov.CanDes = DDEVO.CanDes
                cissac.almdmov.CodUnd = DDEVO.CodUnd
                cissac.almdmov.Factor = DDEVO.Factor
                cissac.almdmov.ImpCto = DDEVO.ImpCto
                cissac.almdmov.CodAjt = '' 
                cissac.almdmov.PreBas = DDEVO.PreBas 
                cissac.almdmov.PorDto = DDEVO.PorDto 
                cissac.almdmov.ImpDto = DDEVO.ImpDto 
                cissac.almdmov.CodAnt = DDEVO.CodAnt
                cissac.almdmov.Por_Dsctos[1] = DDEVO.Por_Dsctos[1]
                cissac.almdmov.Por_Dsctos[2] = DDEVO.Por_Dsctos[2]
                cissac.almdmov.Por_Dsctos[3] = DDEVO.Por_Dsctos[3]
                cissac.almdmov.HraDoc     = cissac.Almcmov.HorRcp
                R-ROWID = ROWID(cissac.almdmov).
            ASSIGN
                cissac.almdmov.PreUni = cissac.CcbDDocu.PreUni 
                cissac.almdmov.PreBas = cissac.CcbDDocu.PreBas 
                cissac.almdmov.AftIsc = cissac.CcbDDocu.AftIsc 
                cissac.almdmov.AftIgv = cissac.CcbDDocu.AftIgv
                cissac.almdmov.Flg_factor = cissac.CcbDDocu.Flg_factor.
            ASSIGN
                cissac.almdmov.ImpLin = ROUND( cissac.almdmov.PreUni * cissac.almdmov.CanDes , 2 ).
            IF cissac.almdmov.AftIsc 
                THEN cissac.almdmov.ImpIsc = ROUND(cissac.almdmov.PreBas * cissac.almdmov.CanDes * (cissac.Almmmatg.PorIsc / 100),4).
            IF cissac.almdmov.AftIgv 
                THEN cissac.almdmov.ImpIgv = cissac.almdmov.ImpLin - ROUND(cissac.almdmov.ImpLin  / (1 + (cissac.FacCfgGn.PorIgv / 100)),4).
/*        RUN ALM\ALMACSTK (R-ROWID).                                  */
/*        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
/*                                                                     */
/*        /* RHC 31.03.04 REACTIVAMOS KARDEX POR ALMACEN */            */
/*        RUN alm/almacpr1 (R-ROWID, 'U').                             */
/*        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
            CREATE DINGR.
            BUFFER-COPY cissac.Almdmov TO DINGR.
        END.
    END.
END.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Notas-de-Credito-por-Devolucion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Notas-de-Credito-por-Devolucion Procedure 
PROCEDURE Notas-de-Credito-por-Devolucion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-FechaD AS DATE NO-UNDO.
DEF VAR x-FechaH AS DATE NO-UNDO.
DEF VAR i-NroSer AS INT INIT 120 NO-UNDO.   /* OJO */
DEF VAR i-NroDoc AS INT NO-UNDO.

DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.

FIND FIRST cissac.FacCfgGn WHERE cissac.FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

RUN src/bin/_dateif (COMBO-BOX-NroMes, COMBO-BOX-Periodo, OUTPUT x-FechaD, OUTPUT x-FechaH).

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND FIRST cissac.FacCorre WHERE cissac.FacCorre.CodCia = S-CODCIA
        AND  cissac.FacCorre.CodDoc = "N/C"
        AND  cissac.FacCorre.NroSer = i-NroSer
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE cissac.FacCorre THEN DO:
        MESSAGE 'Error en el correlativo de N/C para la serie' i-nroSer
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
        
    FOR EACH CDOCU:
        FIND FIRST CINGR WHERE CINGR.codref = CDOCU.coddoc
            AND CINGR.nroref = CDOCU.nrodoc
            NO-ERROR.
        ASSIGN 
            I-NroDoc = cissac.FacCorre.Correlativo
            cissac.FacCorre.Correlativo = cissac.FacCorre.Correlativo + 1.
        CREATE cissac.Ccbcdocu.
        BUFFER-COPY CDOCU
            TO cissac.Ccbcdocu
            ASSIGN 
            cissac.Ccbcdocu.CodCia = S-CODCIA
            cissac.Ccbcdocu.FchDoc = x-FechaH
            cissac.Ccbcdocu.FchVto = x-FechaH
            cissac.Ccbcdocu.FlgEst = "P"
            cissac.Ccbcdocu.CodDoc = "N/C"
            cissac.Ccbcdocu.NroDoc = STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999")
            cissac.Ccbcdocu.CodDiv = s-coddiv
            cissac.Ccbcdocu.CndCre = 'D'
            cissac.Ccbcdocu.Tipo   = "OFICINA"
            cissac.Ccbcdocu.usuario = S-USER-ID.
        IF AVAILABLE CINGR THEN
            ASSIGN 
            cissac.Ccbcdocu.CodRef = CINGR.CodRef
            cissac.Ccbcdocu.NroPed = STRING(CINGR.NroDoc)   /* OJO */
            cissac.Ccbcdocu.NroOrd = CINGR.NroRf2
            cissac.Ccbcdocu.NroRef = CINGR.NroRf1.
        FIND cissac.gn-clie WHERE cissac.gn-clie.CodCia = cl-codcia 
            AND cissac.gn-clie.CodCli = cissac.Ccbcdocu.CodCli
            NO-LOCK NO-ERROR.
        ASSIGN
            cissac.Ccbcdocu.RucCli = cissac.gn-clie.ruc
            cissac.Ccbcdocu.DirCli = cissac.gn-clie.dircli.

        /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
        FIND cissac.gn-ven WHERE cissac.gn-ven.codcia = s-codcia
            AND cissac.gn-ven.codven = CDOCU.codven
            NO-LOCK NO-ERROR.
        IF AVAILABLE cissac.gn-ven THEN cissac.Ccbcdocu.cco = cissac.gn-ven.cco.
        FOR EACH DDOCU OF CDOCU WHERE DDOCU.CanDev > 0:
            CREATE cissac.CcbDDocu.
            BUFFER-COPY DDOCU
                TO cissac.CcbDDocu
                ASSIGN 
                cissac.CcbDDocu.CodCia = cissac.Ccbcdocu.CodCia 
                cissac.CcbDDocu.Coddiv = cissac.Ccbcdocu.Coddiv 
                cissac.CcbDDocu.CodDoc = cissac.Ccbcdocu.CodDoc 
                cissac.CcbDDocu.NroDoc = cissac.Ccbcdocu.NroDoc
                cissac.CcbDDocu.FchDoc = cissac.Ccbcdocu.FchDoc
                cissac.CcbDDocu.CanDes = DDOCU.CanDev       /* OJO */
                cissac.CcbDDocu.CanDev = 0.
            /* RECALCULAMOS IMPORTES */
            ASSIGN
                cissac.ccbddocu.ImpLin = ROUND( cissac.ccbddocu.PreUni * cissac.ccbddocu.CanDes , 2 ).
            IF cissac.ccbddocu.AftIgv 
            THEN cissac.ccbddocu.ImpIgv = cissac.ccbddocu.ImpLin - ROUND(cissac.ccbddocu.ImpLin  / (1 + (cissac.ccbcdocu.PorIgv / 100)),4).
        END.
        ASSIGN
            cissac.Ccbcdocu.ImpDto = 0
            cissac.Ccbcdocu.ImpIgv = 0
            cissac.Ccbcdocu.ImpIsc = 0
            cissac.Ccbcdocu.ImpTot = 0
            cissac.Ccbcdocu.ImpExo = 0
            F-Igv = 0
            F-Isc = 0.
        FOR EACH cissac.Ccbddocu OF cissac.Ccbcdocu NO-LOCK:        
            F-Igv = F-Igv + cissac.Ccbddocu.ImpIgv.
            F-Isc = F-Isc + cissac.Ccbddocu.ImpIsc.
            cissac.Ccbcdocu.ImpTot = cissac.Ccbcdocu.ImpTot + cissac.Ccbddocu.ImpLin.
            IF NOT cissac.Ccbddocu.AftIgv THEN cissac.Ccbcdocu.ImpExo = cissac.Ccbcdocu.ImpExo + cissac.Ccbddocu.ImpLin.
            IF cissac.Ccbddocu.AftIgv = YES
                THEN cissac.Ccbcdocu.ImpDto = cissac.Ccbcdocu.ImpDto + ROUND(cissac.Ccbddocu.ImpDto / (1 + cissac.Ccbcdocu.PorIgv / 100), 2).
            ELSE cissac.Ccbcdocu.ImpDto = cissac.Ccbcdocu.ImpDto + cissac.Ccbddocu.ImpDto.
        END.
        ASSIGN
            cissac.Ccbcdocu.ImpIgv = ROUND(F-IGV,2)
            cissac.Ccbcdocu.ImpIsc = ROUND(F-ISC,2)
            cissac.Ccbcdocu.ImpVta = cissac.Ccbcdocu.ImpTot - cissac.Ccbcdocu.ImpExo - cissac.Ccbcdocu.ImpIgv.
        /* RHC 22.12.06 */
        IF cissac.Ccbcdocu.PorDto > 0 THEN DO:
            cissac.Ccbcdocu.ImpDto = cissac.Ccbcdocu.ImpDto + ROUND((cissac.Ccbcdocu.ImpVta + cissac.Ccbcdocu.ImpExo) * cissac.Ccbcdocu.PorDto / 100, 2).
            cissac.Ccbcdocu.ImpTot = ROUND(cissac.Ccbcdocu.ImpTot * (1 - cissac.Ccbcdocu.PorDto / 100),2).
            cissac.Ccbcdocu.ImpVta = ROUND(cissac.Ccbcdocu.ImpVta * (1 - cissac.Ccbcdocu.PorDto / 100),2).
            cissac.Ccbcdocu.ImpExo = ROUND(cissac.Ccbcdocu.ImpExo * (1 - cissac.Ccbcdocu.PorDto / 100),2).
            cissac.Ccbcdocu.ImpIgv = cissac.Ccbcdocu.ImpTot - cissac.Ccbcdocu.ImpExo - cissac.Ccbcdocu.ImpVta.
        END.
        ASSIGN
            cissac.Ccbcdocu.ImpBrt = cissac.Ccbcdocu.ImpVta + cissac.Ccbcdocu.ImpIsc + cissac.Ccbcdocu.ImpDto + cissac.Ccbcdocu.ImpExo
            cissac.Ccbcdocu.SdoAct  = cissac.Ccbcdocu.ImpTot.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Notas-de-Credito-por-Devolucion-old) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Notas-de-Credito-por-Devolucion-old Procedure 
PROCEDURE Notas-de-Credito-por-Devolucion-old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-FechaD AS DATE NO-UNDO.
DEF VAR x-FechaH AS DATE NO-UNDO.
DEF VAR i-NroSer AS INT INIT 120 NO-UNDO.   /* OJO */
DEF VAR i-NroDoc AS INT NO-UNDO.

DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.

FIND FIRST cissac.FacCfgGn WHERE cissac.FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

RUN src/bin/_dateif (COMBO-BOX-NroMes, COMBO-BOX-Periodo, OUTPUT x-FechaD, OUTPUT x-FechaH).

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND FIRST cissac.FacCorre WHERE cissac.FacCorre.CodCia = S-CODCIA
        AND  cissac.FacCorre.CodDoc = "N/C"
        AND  cissac.FacCorre.NroSer = i-NroSer
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE cissac.FacCorre THEN DO:
        MESSAGE 'Error en el correlativo de N/C para la serie' i-nroSer
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
        
    FOR EACH CINGR, 
        FIRST B-CDOCU WHERE B-CDOCU.codcia = s-codcia
        AND B-CDOCU.coddoc = CINGR.codref
        AND B-CDOCU.nrodoc = CINGR.nroref NO-LOCK:
        /*MESSAGE cingr.codalm cingr.tipmov cingr.codmov cingr.nroser cingr.nrodoc.*/
        ASSIGN 
            I-NroDoc = cissac.FacCorre.Correlativo
            cissac.FacCorre.Correlativo = cissac.FacCorre.Correlativo + 1.
        CREATE cissac.Ccbcdocu.
        ASSIGN 
            cissac.Ccbcdocu.CodCia = S-CODCIA
            cissac.Ccbcdocu.FchDoc = x-FechaH
            cissac.Ccbcdocu.FchVto = x-FechaH
            cissac.Ccbcdocu.FlgEst = "P"
            cissac.Ccbcdocu.PorIgv = B-CDOCU.PorIgv
            cissac.Ccbcdocu.PorDto = B-CDOCU.PorDto
            cissac.Ccbcdocu.CodDoc = "N/C"
            cissac.Ccbcdocu.NroDoc = STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999")
            cissac.Ccbcdocu.CodDiv = s-coddiv
            cissac.Ccbcdocu.TpoCmb = FacCfgGn.TpoCmb[1]
            cissac.Ccbcdocu.CndCre = 'D'
            cissac.Ccbcdocu.Tipo   = "OFICINA"
            cissac.Ccbcdocu.usuario = S-USER-ID
            cissac.Ccbcdocu.SdoAct = cissac.Ccbcdocu.Imptot.
        ASSIGN 
            cissac.Ccbcdocu.CodCli = CINGR.CodCli 
            cissac.Ccbcdocu.CodMon = CINGR.CodMon
            cissac.Ccbcdocu.CodAlm = CINGR.CodAlm
            cissac.Ccbcdocu.CodMov = CINGR.CodMov
            cissac.Ccbcdocu.CodVen = CINGR.CodVen
            cissac.Ccbcdocu.CodRef = CINGR.CodRef
            cissac.Ccbcdocu.NroPed = STRING(CINGR.NroDoc)   /* OJO */
            cissac.Ccbcdocu.NroOrd = CINGR.NroRf2
            cissac.Ccbcdocu.NroRef = CINGR.NroRf1.
        FIND cissac.gn-clie WHERE cissac.gn-clie.CodCia = cl-codcia 
            AND cissac.gn-clie.CodCli = cissac.Ccbcdocu.CodCli
            NO-LOCK NO-ERROR.
        ASSIGN
            cissac.Ccbcdocu.RucCli = cissac.gn-clie.ruc
            cissac.Ccbcdocu.DirCli = cissac.gn-clie.dircli.

        /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
        FIND cissac.gn-ven WHERE cissac.gn-ven.codcia = s-codcia
            AND cissac.gn-ven.codven = B-CDOCU.codven
            NO-LOCK NO-ERROR.
        IF AVAILABLE cissac.gn-ven THEN cissac.Ccbcdocu.cco = cissac.gn-ven.cco.
        FOR EACH DINGR OF CINGR:
            CREATE cissac.CcbDDocu.
            ASSIGN 
                cissac.CcbDDocu.CodCia = cissac.Ccbcdocu.CodCia 
                cissac.CcbDDocu.Coddiv = cissac.Ccbcdocu.Coddiv 
                cissac.CcbDDocu.CodDoc = cissac.Ccbcdocu.CodDoc 
                cissac.CcbDDocu.NroDoc = cissac.Ccbcdocu.NroDoc
                cissac.CcbDDocu.FchDoc = cissac.Ccbcdocu.FchDoc
                cissac.CcbDDocu.codmat = DINGR.codmat 
                cissac.CcbDDocu.PreUni = DINGR.PreUni 
                cissac.CcbDDocu.CanDes = DINGR.CanDes 
                cissac.CcbDDocu.Factor = DINGR.Factor 
                cissac.CcbDDocu.ImpIsc = DINGR.ImpIsc
                cissac.CcbDDocu.ImpIgv = DINGR.ImpIgv 
                cissac.CcbDDocu.ImpLin = DINGR.ImpLin
                cissac.CcbDDocu.PorDto = DINGR.PorDto 
                cissac.CcbDDocu.PreBas = DINGR.PreBas 
                cissac.CcbDDocu.ImpDto = DINGR.ImpDto
                cissac.CcbDDocu.AftIgv = DINGR.AftIgv
                cissac.CcbDDocu.AftIsc = DINGR.AftIsc
                cissac.CcbDDocu.UndVta = DINGR.CodUnd
                cissac.CcbDDocu.Por_Dsctos[1] = DINGR.Por_Dsctos[1]
                cissac.CcbDDocu.Por_Dsctos[2] = DINGR.Por_Dsctos[2]
                cissac.CcbDDocu.Por_Dsctos[3] = DINGR.Por_Dsctos[3]
                cissac.CcbDDocu.Flg_factor = DINGR.Flg_factor
                cissac.CcbDDocu.ImpCto     = DINGR.ImpCto.
        END.
        ASSIGN
            cissac.Ccbcdocu.ImpDto = 0
            cissac.Ccbcdocu.ImpIgv = 0
            cissac.Ccbcdocu.ImpIsc = 0
            cissac.Ccbcdocu.ImpTot = 0
            cissac.Ccbcdocu.ImpExo = 0
            F-Igv = 0
            F-Isc = 0.
        FOR EACH cissac.Ccbddocu OF cissac.Ccbcdocu NO-LOCK:        
            F-Igv = F-Igv + cissac.Ccbddocu.ImpIgv.
            F-Isc = F-Isc + cissac.Ccbddocu.ImpIsc.
            cissac.Ccbcdocu.ImpTot = cissac.Ccbcdocu.ImpTot + cissac.Ccbddocu.ImpLin.
            IF NOT cissac.Ccbddocu.AftIgv THEN cissac.Ccbcdocu.ImpExo = cissac.Ccbcdocu.ImpExo + cissac.Ccbddocu.ImpLin.
            IF cissac.Ccbddocu.AftIgv = YES
                THEN cissac.Ccbcdocu.ImpDto = cissac.Ccbcdocu.ImpDto + ROUND(cissac.Ccbddocu.ImpDto / (1 + cissac.Ccbcdocu.PorIgv / 100), 2).
            ELSE cissac.Ccbcdocu.ImpDto = cissac.Ccbcdocu.ImpDto + cissac.Ccbddocu.ImpDto.
        END.
        ASSIGN
            cissac.Ccbcdocu.ImpIgv = ROUND(F-IGV,2)
            cissac.Ccbcdocu.ImpIsc = ROUND(F-ISC,2)
            cissac.Ccbcdocu.ImpVta = cissac.Ccbcdocu.ImpTot - cissac.Ccbcdocu.ImpExo - cissac.Ccbcdocu.ImpIgv.
        /* RHC 22.12.06 */
        IF cissac.Ccbcdocu.PorDto > 0 THEN DO:
            cissac.Ccbcdocu.ImpDto = cissac.Ccbcdocu.ImpDto + ROUND((cissac.Ccbcdocu.ImpVta + cissac.Ccbcdocu.ImpExo) * cissac.Ccbcdocu.PorDto / 100, 2).
            cissac.Ccbcdocu.ImpTot = ROUND(cissac.Ccbcdocu.ImpTot * (1 - cissac.Ccbcdocu.PorDto / 100),2).
            cissac.Ccbcdocu.ImpVta = ROUND(cissac.Ccbcdocu.ImpVta * (1 - cissac.Ccbcdocu.PorDto / 100),2).
            cissac.Ccbcdocu.ImpExo = ROUND(cissac.Ccbcdocu.ImpExo * (1 - cissac.Ccbcdocu.PorDto / 100),2).
            cissac.Ccbcdocu.ImpIgv = cissac.Ccbcdocu.ImpTot - cissac.Ccbcdocu.ImpExo - cissac.Ccbcdocu.ImpVta.
        END.
        ASSIGN
            cissac.Ccbcdocu.ImpBrt = cissac.Ccbcdocu.ImpVta + cissac.Ccbcdocu.ImpIsc + cissac.Ccbcdocu.ImpDto + cissac.Ccbcdocu.ImpExo
            cissac.Ccbcdocu.SdoAct  = cissac.Ccbcdocu.ImpTot.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

