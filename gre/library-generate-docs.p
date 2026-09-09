&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

DEFINE BUFFER b-gre_header FOR gre_header.
DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER b1-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER b-ccbddocu FOR ccbddocu.
DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER x-ccbddocu FOR ccbddocu.
DEFINE BUFFER B-ADocu FOR ccbADocu.

DEFINE TEMP-TABLE T-CcbADocu LIKE CcbADocu.

DEFINE VAR lMueveMovAlmacen AS LOG.
DEFINE VAR rRowID AS ROWID.

lMueveMovAlmacen = NO.

/* Sintaxis 
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN <libreria> PERSISTENT SET hProc.
RUN <libreria>.rutina_internaIN hProc (input  buffer tt-excel:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .
DELETE PROCEDURE hProc.
*/

DEFINE STREAM sFileTxt.
define stream log-epos.     /* Trama del ePOS */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fwrite_log) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fwrite_log Procedure 
FUNCTION fwrite_log RETURNS CHARACTER
  (INPUT pTexto AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-GRE_Generacion_CCBCDOCU) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRE_Generacion_CCBCDOCU Procedure 
PROCEDURE GRE_Generacion_CCBCDOCU :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pSerieGuia AS INT.
DEF INPUT PARAMETER pNroGuia AS INT.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEFINE VARIABLE s-FlgPicking LIKE GN-DIVI.FlgPicking.
DEFINE VARIABLE s-FlgBarras  LIKE GN-DIVI.FlgBarras.

DEFINE VAR cNumeroComprobante AS CHAR.
DEFINE VAR FILL-IN-LugEnt AS CHAR.
DEFINE VAR pCodDpto AS CHAR.
DEFINE VAR pCodProv AS CHAR.
DEFINE VAR pCodDist AS CHAR.
DEFINE VAR pCodPos AS CHAR.
DEFINE VAR pZona AS CHAR.
DEFINE VAR pSubZona AS CHAR.
DEFINE VAR iCountItem AS INT.

DEFINE VAR cFiler AS CHAR.

DISABLE TRIGGERS FOR LOAD OF ccbadocu.

/**/
FIND FIRST gre_header WHERE gre_header.m_divorigen = pCodDiv AND 
                            gre_header.serieGuia = pSerieGuia AND
                            gre_header.numeroGuia = pNroGuia NO-LOCK NO-ERROR.
IF NOT AVAILABLE gre_header THEN DO:
    pMensaje = "Guia " + STRING(pSerieGuia,"999") + STRING(pNroGuia,"99999999") + " no existe".

    cFiler = fwrite_log("Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + 
                    "   No existe").

    RETURN "ADM-ERROR".
END.

cNumeroComprobante = STRING(gre_header.m_nroser,"999") + STRING(gre_header.m_nrodoc,"99999999").
IF gre_header.m_coddoc = 'FAI' THEN DO:
    cNumeroComprobante = STRING(gre_header.m_nroser,"999") + STRING(gre_header.m_nrodoc,"999999").
END.

FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = 1 AND x-ccbcdocu.coddoc = gre_header.m_coddoc AND
                            x-ccbcdocu.nrodoc = cNumeroComprobante NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-ccbcdocu THEN DO:

    cNumeroComprobante = STRING(gre_header.m_nroser,"999") + STRING(gre_header.m_nrodoc,"99999999").

    FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = 1 AND x-ccbcdocu.coddoc = gre_header.m_coddoc AND
                                x-ccbcdocu.nrodoc = cNumeroComprobante NO-LOCK NO-ERROR.
    IF NOT AVAILABLE x-ccbcdocu THEN DO:
        pMensaje = "El comprobante " + gre_header.m_coddoc + " " + cNumeroComprobante + " de la guia " + STRING(pSerieGuia,"999") + STRING(pNroGuia,"99999999") + ", No existe".
        cFiler = fwrite_log("Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + 
                        "  " + pMensaje).
    
        RETURN "ADM-ERROR".
    END.
END.

/* O/D */
FIND FIRST faccpedi WHERE faccpedi.codcia = 1 AND faccpedi.coddoc = x-ccbcdocu.libre_c01 AND
                        faccpedi.nroped = x-ccbcdocu.libre_c02 NO-LOCK NO-ERROR.

/* RHC Cargamos TRANSPORTISTA por defecto */
EMPTY TEMP-TABLE T-CcbADocu.
IF AVAILABLE faccpedi THEN DO:
    cFiler = fwrite_log("Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + " FACCPEDI").
    FIND FIRST Ccbadocu WHERE Ccbadocu.codcia = Faccpedi.codcia
          AND Ccbadocu.coddiv = Faccpedi.coddiv
          AND Ccbadocu.coddoc = Faccpedi.coddoc
          AND Ccbadocu.nrodoc = Faccpedi.nroped
          NO-LOCK NO-ERROR.
    IF AVAILABLE CcbADocu THEN DO:
      CREATE T-CcbADocu.
      BUFFER-COPY CcbADocu TO T-CcbADocu
          ASSIGN
          T-CcbADocu.CodDiv = CcbADocu.CodDiv
          T-CcbADocu.CodDoc = CcbADocu.CodDoc
          T-CcbADocu.NroDoc = CcbADocu.NroDoc NO-ERROR.
      IF ERROR-STATUS:ERROR = YES THEN DO:
          cFiler = fwrite_log("CCBADOCU  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + 
                          "   MSGERR:" + ERROR-STATUS:GET-MESSAGE(1) ).
      END.

      RELEASE T-CcbADocu.
    END.      
END.

cFiler = fwrite_log("Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + " INICIOOOOOO").

GRABAR:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    cFiler = fwrite_log("CREAR b-ccbcdocu  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999")).
    CREATE b-CcbCDocu.
    cFiler = fwrite_log("buffer copy  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999")).
    BUFFER-COPY x-ccbCDOCU EXCEPT x-CcbCDocu.coddoc x-CcbCDocu.nrodoc TO b-CcbCDocu.
        ASSIGN
        b-CcbCDocu.CodDiv = gre_header.m_divorigen
        b-CcbCDocu.CodDoc = "G/R"
        b-CcbCDocu.NroDoc =  STRING(gre_header.serieGuia,"999") + STRING(gre_header.numeroGuia,"99999999")
        b-CcbCDocu.FchDoc = TODAY
        b-CcbCDocu.CodRef = x-ccbCDOCU.CodDoc
        b-CcbCDocu.NroRef = x-ccbCDOCU.NroDoc
        b-CcbCDocu.FlgEst = "F"   /* FACTURADO */
        b-CcbCDocu.usuario = USERID("dictdb")
        b-CcbCDocu.TpoFac = "A"     /* AUTOMATICA (No descarga stock) */
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        cFiler = fwrite_log("ERROR  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + 
                        "   ERROR:" + ERROR-STATUS:GET-MESSAGE(1) ).

        pMensaje = "1.- No se pudo crear la G/R del comprobante " + gre_header.m_coddoc + " " + cNumeroComprobante + " de la guia " + STRING(pSerieGuia,"999") + STRING(pNroGuia,"99999999") + " " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR, RETURN "ADM-ERROR".
    END.
    cFiler = fwrite_log("OK buffer copy  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999")).

    /* La FAI referencia a la GRE */
    FIND FIRST b1-ccbcdocu WHERE ROWID(b1-ccbcdocu) = ROWID(x-ccbcdocu) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        cFiler = fwrite_log("ERROR  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + 
                        " Al actualizar la FAI con la GRE - ERROR:" + ERROR-STATUS:GET-MESSAGE(1) ).
        pMensaje = cFiler.
        UNDO GRABAR, RETURN "ADM-ERROR".
    END.
    ASSIGN b1-ccbcdocu.codref = b-CcbCDocu.CodDoc
            b1-ccbcdocu.nroref = b-CcbCDocu.NroDoc.

    /* ************************************************************* */
    /* RHC De acuerdo a la sede le cambiamos la dirección de entrega */
    /* ************************************************************* */
    
    cFiler = fwrite_log("Direccion entrega  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999")).
    IF AVAILABLE faccpedi THEN DO:
        cFiler = fwrite_log("p-lugar-de-entrega  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999")).
        RUN logis/p-lugar-de-entrega (INPUT Faccpedi.CodDoc,
                                      INPUT Faccpedi.NroPed,
                                      OUTPUT FILL-IN-LugEnt) NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            cFiler = fwrite_log("logis/p-lugar-de-entrega  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + 
                            "   ERROR:" + ERROR-STATUS:GET-MESSAGE(1) ).
            pMensaje = cFiler.
            UNDO GRABAR, RETURN "ADM-ERROR".
        END.        
        cFiler = fwrite_log("antes de ubigeo  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999")).
        ASSIGN
            b-CcbCDocu.LugEnt  = FILL-IN-LugEnt.
        cFiler = fwrite_log("ubigeo  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999")).
        RUN gn/fUbigeo (INPUT Faccpedi.CodDiv,
                        INPUT Faccpedi.CodDoc,
                        INPUT Faccpedi.NroPed,
                        OUTPUT pCodDpto,
                        OUTPUT pCodProv,
                        OUTPUT pCodDist,
                        OUTPUT pCodPos,
                        OUTPUT pZona,
                        OUTPUT pSubZona) NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            cFiler = fwrite_log("gn/fUbigeo  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + 
                        "   ERROR:" + ERROR-STATUS:GET-MESSAGE(1) ).
            pMensaje = cFiler.
            UNDO GRABAR, RETURN "ADM-ERROR".
        END.

        ASSIGN
            b-CcbCDocu.CodDpto = pCodDpto
            b-CcbCDocu.CodProv = pCodProv
            b-CcbCDocu.CodDist = pCodDist.
    END.    

    cFiler = fwrite_log("COPIAMOS TRANSPORTISTA  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") ).                        
    
    /* ************************************************************* */
    /* ************************************************************* */
    /* RHC 22/07/2015 COPIAMOS DATOS DEL TRANSPORTISTA */
    FIND FIRST T-CcbADocu NO-LOCK NO-ERROR.
    IF AVAILABLE T-CcbADocu THEN DO:
        FIND FIRST B-ADOCU WHERE B-ADOCU.codcia = b-Ccbcdocu.codcia
            AND B-ADOCU.coddiv = b-Ccbcdocu.coddiv
            AND B-ADOCU.coddoc = b-Ccbcdocu.coddoc
            AND B-ADOCU.nrodoc = b-Ccbcdocu.nrodoc
            NO-ERROR.
        IF NOT AVAILABLE B-ADOCU THEN CREATE B-ADOCU.
        BUFFER-COPY T-CcbADocu 
            TO B-ADOCU
            ASSIGN
                B-ADOCU.CodCia = b-Ccbcdocu.CodCia
                B-ADOCU.CodDiv = b-Ccbcdocu.CodDiv
                B-ADOCU.CodDoc = b-Ccbcdocu.CodDoc
                B-ADOCU.NroDoc = b-Ccbcdocu.NroDoc NO-ERROR.

        IF ERROR-STATUS:ERROR = YES THEN DO:

            pMensaje = "2.- No se pudo crear el transportista de la G/R del comprobante " + gre_header.m_coddoc + " " + cNumeroComprobante + " de la guia " + STRING(pSerieGuia,"999") + STRING(pNroGuia,"99999999") + CHR(10) + 
                    ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABAR, RETURN "ADM-ERROR".
        END.


        FIND gn-provd WHERE gn-provd.CodCia = 0 AND
            gn-provd.CodPro = B-ADOCU.Libre_C[9] AND
            gn-provd.Sede   = B-ADOCU.Libre_C[20] AND
            CAN-FIND(FIRST gn-prov OF gn-provd NO-LOCK)
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-provd THEN DO:
            ASSIGN
            b-CcbCDocu.CodAge  = gn-provd.CodPro
            b-CcbCDocu.CodDpto = gn-provd.CodDept 
            b-CcbCDocu.CodProv = gn-provd.CodProv 
            b-CcbCDocu.CodDist = gn-provd.CodDist 
            b-CcbCDocu.LugEnt2 = gn-provd.DirPro.
        END.
    END.
    cFiler = fwrite_log("FINAL COPIAMOS TRANSPORTISTA  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") ).                        
    /* 
        DETALLE del comprobante a la GRE
        /* *************************************** */
        /* RHC 11/05/2020 NO va el flete en la G/R */
        /* RHC 13/07/2020 NO va productos DROP SHIPPING */
        /* *************************************** */    
    */
    iCountItem = 1.
    FOR EACH x-ccbddocu OF x-ccbcdocu NO-LOCK,
        FIRST Almmmatg OF x-ccbddocu NO-LOCK,
        FIRST Almtfami OF Almmmatg NO-LOCK:
        CASE TRUE:
            WHEN Almtfami.Libre_c01 = "SV" THEN NEXT.
            OTHERWISE DO:
                FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
                    VtaTabla.Tabla = "DROPSHIPPING" AND
                    VtaTabla.Llave_c1 = x-ccbddocu.CodMat 
                    NO-LOCK NO-ERROR.
                IF AVAILABLE VtaTabla THEN NEXT.
            END.
        END CASE.
        CREATE b-Ccbddocu.
        BUFFER-COPY x-ccbddocu EXCEPT x-CcbdDocu.coddoc x-CcbdDocu.nrodoc x-CcbDDocu.codmat x-CcbDDocu.NroItm TO b-Ccbddocu
            ASSIGN
                b-CcbDDocu.NroItm = iCountItem
                b-CcbDDocu.codmat = x-ccbddocu.CodMat 
                b-Ccbddocu.coddiv = b-Ccbcdocu.coddiv
                b-Ccbddocu.coddoc = b-Ccbcdocu.coddoc
                b-Ccbddocu.nrodoc = b-Ccbcdocu.nrodoc NO-ERROR.

        IF ERROR-STATUS:ERROR = YES THEN DO:
            pMensaje = "3.- No se pudo crear la G/R del comprobante " + gre_header.m_coddoc + " " + cNumeroComprobante + " de la guia " + 
                STRING(pSerieGuia,"999") + STRING(pNroGuia,"99999999") + " Articulo " + x-ccbddocu.codmat + ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABAR, RETURN "ADM-ERROR".
        END.

        iCountItem = iCountItem + 1.
    END.

    cFiler = fwrite_log("Actualizo la GRE como procesada  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") ).                        

    /* Actualizo la GRE como procesada */
    FIND FIRST b-gre_header WHERE ROWID(b-gre_header) = rRowID EXCLUSIVE-LOCK NO-ERROR.
    IF LOCKED b-gre_header THEN DO:
        cFiler = fwrite_log("BLOQUEO a b-gre_header --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") ).                        
        pMensaje =  "EROR:*Cambiar el estado de m_estado_mov_almacen " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR, RETURN 'ADM-ERROR'.
    END.
    IF NOT AVAILABLE b-gre_header THEN DO:
        pMensaje =  "ERROR:**Cambiar el estado de m_estado_mov_almacen " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR, RETURN 'ADM-ERROR'.
    END.
    cFiler = fwrite_log("CASI FINAL --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") ).                        

    ASSIGN b-gre_header.m_estado_mov_almacen = "PROCESADO"
            b-gre_header.m_fechahora_mov_almacen = NOW NO-ERROR.

    IF ERROR-STATUS:ERROR = YES THEN DO:
        cFiler = fwrite_log("Actualizo la GRE como procesada  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + ERROR-STATUS:GET-MESSAGE(1)).
        pMensaje = "Actualizo la GRE como procesada  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") +  ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR, RETURN 'ADM-ERROR'.
    END.

    cFiler = fwrite_log("FINAL***** --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") ).                        

    RELEASE b-Ccbcdocu NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        cFiler = fwrite_log("Release b-Ccbcdocu  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + ERROR-STATUS:GET-MESSAGE(1)).
        pMensaje = "Release b-Ccbcdocu  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR, RETURN 'ADM-ERROR'.
    END.

    RELEASE b-Ccbddocu NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        cFiler = fwrite_log("  Release b-Ccbddocu --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + ERROR-STATUS:GET-MESSAGE(1)).
        UNDO GRABAR, RETURN 'ADM-ERROR'.
    END.

    RELEASE B-ADOCU NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        cFiler = fwrite_log("Release B-ADOCU  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + ERROR-STATUS:GET-MESSAGE(1)).
        UNDO GRABAR, RETURN 'ADM-ERROR'.
    END.

    RELEASE b1-Ccbcdocu NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        cFiler = fwrite_log("  Release b1-Ccbcdocu --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + ERROR-STATUS:GET-MESSAGE(1)).
        UNDO GRABAR, RETURN 'ADM-ERROR'.
    END.
END.

cFiler = fwrite_log("CASI OK --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") ).
/*
RELEASE b-Ccbcdocu NO-ERROR.
RELEASE b-Ccbddocu NO-ERROR.
RELEASE B-ADOCU NO-ERROR.
*/
cFiler = fwrite_log("OK --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") ).                        

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRE_Generacion_Detalle_S03) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRE_Generacion_Detalle_S03 Procedure 
PROCEDURE GRE_Generacion_Detalle_S03 PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR x-Item AS INTE INIT 1 NO-UNDO.
DEF VAR R-ROWID AS ROWID NO-UNDO.

DEFINE VAR cFiler AS CHAR.

GRABAR:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":

    FOR EACH gre_detail WHERE gre_detail.ncorrelativo = gre_header.ncorrelatio NO-LOCK:
        CREATE almdmov.
        ASSIGN 
            Almdmov.CodCia = Almcmov.CodCia 
            Almdmov.CodAlm = Almcmov.CodAlm 
            Almdmov.TipMov = Almcmov.TipMov 
            Almdmov.CodMov = Almcmov.CodMov 
            Almdmov.NroSer = Almcmov.NroSer
            Almdmov.NroDoc = Almcmov.NroDoc 
            Almdmov.CodMon = Almcmov.CodMon 
            Almdmov.FchDoc = Almcmov.FchDoc 
            Almdmov.HraDoc = Almcmov.HraDoc
            Almdmov.TpoCmb = Almcmov.TpoCmb
            Almdmov.codmat = gre_detail.codmat
            Almdmov.CanDes = gre_detail.Candes
            Almdmov.CodUnd = gre_detail.codund
            Almdmov.Factor = gre_detail.Factor
            Almdmov.PreUni = gre_detail.precio_unitario
            Almdmov.AlmOri = Almcmov.AlmDes 
            Almdmov.CodAjt = ''
            Almdmov.HraDoc = Almcmov.HorSal
            Almdmov.NroItm = gre_detail.nroitm NO-ERROR.
    
        IF ERROR-STATUS:ERROR = YES THEN DO:

            cFiler = fwrite_log("ERROR DETALLE --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + 
                                " ARTICULO:" + gre_detail.codmat + "   ERROR:" + ERROR-STATUS:GET-MESSAGE(1) ).

            pMensaje = "No se pudo adicionar el item " + gre_detail.codmat.            

            UNDO GRABAR, RETURN "ADM-ERROR".
        END.
    
        R-ROWID = ROWID(Almdmov).
    
        RUN alm/almdcstk (R-ROWID) NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            cFiler = fwrite_log("ERROR DETALLE (alm/almdcstk) --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + 
                            " ARTICULO:" + gre_detail.codmat + "   ERROR:" + ERROR-STATUS:GET-MESSAGE(1) ).
            pMensaje = "No se pudo actualizar el stock desde la guia " + STRING(Almcmov.NroSer,"999") + STRING(Almcmov.NroDoc,"99999999") + " articulo " + gre_detail.codmat + 
                        " " + ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABAR, RETURN 'ADM-ERROR'.
        END.
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            pMensaje = "No se pudo actualizar el stock desde la guia " + STRING(Almcmov.NroSer,"999") + STRING(Almcmov.NroDoc,"99999999") + " articulo " + gre_detail.codmat.
            UNDO GRABAR, RETURN 'ADM-ERROR'.
        END.

        RUN alm/almacpr1 (R-ROWID, "U") NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            cFiler = fwrite_log("ERROR DETALLE (alm/almacpr1) --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + 
                            " ARTICULO:" + gre_detail.codmat + "   ERROR:" + ERROR-STATUS:GET-MESSAGE(1) ).
            pMensaje = "No se pudo actualizar el ALMACPR1 desde la guia " + STRING(Almcmov.NroSer,"999") + STRING(Almcmov.NroDoc,"99999999") + " articulo " + gre_detail.codmat +
            " " + ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABAR, RETURN 'ADM-ERROR'.
        END.

        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            pMensaje = "No se pudo actualizar el ALMACPR1 desde la guia " + STRING(Almcmov.NroSer,"999") + STRING(Almcmov.NroDoc,"99999999") + " articulo " + gre_detail.codmat.
            UNDO GRABAR, RETURN 'ADM-ERROR'.
        END.            
    END.
END.

RETURN "OK".
/*
FOR EACH Facdpedi OF Faccpedi NO-LOCK BY Facdpedi.NroItm:
    CREATE almdmov.
    ASSIGN 
        Almdmov.CodCia = Almcmov.CodCia 
        Almdmov.CodAlm = Almcmov.CodAlm 
        Almdmov.TipMov = Almcmov.TipMov 
        Almdmov.CodMov = Almcmov.CodMov 
        Almdmov.NroSer = Almcmov.NroSer
        Almdmov.NroDoc = Almcmov.NroDoc 
        Almdmov.CodMon = Almcmov.CodMon 
        Almdmov.FchDoc = Almcmov.FchDoc 
        Almdmov.HraDoc = Almcmov.HraDoc
        Almdmov.TpoCmb = Almcmov.TpoCmb
        Almdmov.codmat = Facdpedi.codmat
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = "Registro duplicado en el código " + Facdpedi.codmat.
        UNDO, RETURN "ADM-ERROR".
    END.
    ASSIGN
        Almdmov.CanDes = Facdpedi.CanPed
        Almdmov.CodUnd = Facdpedi.UndVta
        Almdmov.Factor = Facdpedi.Factor
        /*Almdmov.ImpCto = Facdpedi.ImpCto*/
        Almdmov.PreUni = Facdpedi.PreUni
        Almdmov.AlmOri = Almcmov.AlmDes 
        Almdmov.CodAjt = ''
        Almdmov.HraDoc = Almcmov.HorSal
        Almdmov.NroItm = x-Item
        R-ROWID = ROWID(Almdmov).
    x-Item = x-Item + 1.
    RUN alm/almdcstk (R-ROWID).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    RUN alm/almacpr1 (R-ROWID, "U").
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRE_Generacion_Documentos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRE_Generacion_Documentos Procedure 
PROCEDURE GRE_Generacion_Documentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pnCorrelatio LIKE gre_header.ncorrelatio.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEFINE VAR cFiler AS CHAR.

FIND FIRST GRE_Header WHERE GRE_Header.ncorrelatio = pnCorrelatio NO-LOCK NO-ERROR.
IF NOT AVAILABLE GRE_Header THEN DO:
    pMensaje = "PRE-GRE " + STRING(pnCorrelatio) + " NO EXISTE".
    RETURN "ADM-ERROR".
END.

IF GRE_Header.serieGuia = 0 OR gre_header.numeroGuia = 0 THEN DO:
    pMensaje = "PRE-GRE " + STRING(pnCorrelatio) + " aun no tiene numero de GUIA DE REMISION".
    RETURN "ADM-ERROR".
END.

FIND FIRST almtmovm WHERE almtmovm.codcia = 1 AND
                    almtmovm.tipmov = gre_header.m_tipmov AND 
                    almtmovm.codmov = gre_header.m_codmov NO-LOCK NO-ERROR.
IF NOT AVAILABLE almtmovm THEN DO:
    pMensaje = "GRE " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") +
           " El tipo movimiento no no existe".
    RETURN "ADM-ERROR".
END.

lMueveMovAlmacen = almtmovm.MovVal.

IF NOT (gre_header.m_rspta_sunat = "ACEPTADO POR SUNAT" AND  
    gre_header.m_estado_mov_almacen = "POR PROCESAR") THEN DO:

    pMensaje = "GRE " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") +
           " NO esta aceptada por sunat y/o ya fue procesada".
    RETURN "ADM-ERROR".
END.
    
cFiler = fwrite_log("INICIO :: Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") ).

/*   */
rRowID = ROWID(gre_header).
IF lMueveMovAlmacen = YES AND LOOKUP(gre_header.m_coddoc,"FAC,BOL,FAI,N/C") = 0 THEN DO:
    /* Se debe cargar en ALMCMOV */

    cFiler = fwrite_log("Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + " --> movimiento de almacen" ).

    RUN GRE_Generacion_S03 (INPUT gre_header.m_divorigen,
                            INPUT gre_header.serieGuia,
                            INPUT gre_header.numeroGuia,
                            OUTPUT pMensaje) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        cFiler = fwrite_log("ERROR --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + " ERROR:" + ERROR-STATUS:GET-MESSAGE(1) ).
        RETURN "ADM-ERROR".
    END.

    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        FIND FIRST b-gre_header WHERE ROWID(b-gre_header) = rRowID EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE b-gre_header THEN DO:
            ASSIGN b-gre_header.m_msgerr_mov_almacen = pMensaje.
        END.
        RELEASE b-gre_header NO-ERROR.

        cFiler = fwrite_log("(ALMCMOV) Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + " MSG:" + pMensaje ).
        RETURN "ADM-ERROR".
    END.                 
END.
ELSE DO:
    /* Se debe cargar en CCBCDOCU */
    IF LOOKUP(gre_header.m_coddoc,"FAC,BOL,FAI,N/C") > 0 THEN DO:
        /* VENTAS */

        cFiler = fwrite_log("Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + " --> VENTAS" ).

        RUN GRE_Generacion_CCBCDOCU (INPUT gre_header.m_divorigen,
                                INPUT gre_header.serieGuia,
                                INPUT gre_header.numeroGuia,
                                OUTPUT pMensaje) NO-ERROR.

        IF ERROR-STATUS:ERROR THEN DO:
            cFiler = fwrite_log("ERROR (CCBCDOCU) --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + " ERROR:" + ERROR-STATUS:GET-MESSAGE(1) ).
            RETURN "ADM-ERROR".
        END.

        IF RETURN-VALUE = "ADM-ERROR" THEN DO:
            FIND FIRST b-gre_header WHERE ROWID(b-gre_header) = rRowID EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE b-gre_header THEN DO:
                ASSIGN b-gre_header.m_msgerr_mov_almacen = pMensaje.
            END.
            RELEASE b-gre_header NO-ERROR.
            cFiler = fwrite_log("(CCBCDOCU - ADMERROR) Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + " MSG:" + ERROR-STATUS:GET-MESSAGE(1) ).
            RETURN "ADM-ERROR".
        END.                 

    END.
    ELSE DO:
        cFiler = fwrite_log("Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + " --> NOOOOO VENTAS" ).

        /* NO VENTAS */
        /*
        
        Se va revisar y analizar a profundidad en que puede afectar el adicionar
        un registro en el CCBCDOCU, sabiendo que esta tabla maneja trigerrs
        */
        
        RUN GRE_Generacion_NO_VTA_NO_OTR (INPUT gre_header.m_divorigen,
                                INPUT gre_header.serieGuia,
                                INPUT gre_header.numeroGuia,
                                OUTPUT pMensaje) NO-ERROR.

        IF ERROR-STATUS:ERROR THEN DO:
            cFiler = fwrite_log("ERROR (CCB R DOCU) --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + " ERROR:" + ERROR-STATUS:GET-MESSAGE(1) ).
            RETURN "ADM-ERROR".
        END.

        IF RETURN-VALUE = "ADM-ERROR" THEN DO:
            FIND FIRST b-gre_header WHERE ROWID(b-gre_header) = rRowID EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE b-gre_header THEN DO:
                ASSIGN b-gre_header.m_msgerr_mov_almacen = pMensaje.
            END.
            RELEASE b-gre_header NO-ERROR.
            cFiler = fwrite_log("(CCBCDOCU NO-VTA - ADMERROR) Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + " MSG:" + ERROR-STATUS:GET-MESSAGE(1) ).
            RETURN "ADM-ERROR".
        END.                 
        
    END.
END.

cFiler = fwrite_log("FIN :: Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") ).

pMensaje = "OK".

RETURN "OK".
/*  
/* De acuerdo a los datos de la GRE se genera el documento */
CASE TRUE:
    WHEN GRE_Header.m_tipmov = "S" AND GRE_Header.m_codmov = 3 AND GRE_Header.m_coddoc = "OTR" THEN DO:
        
        IF lMueveMovAlmacen = YES THEN DO:
            RUN GRE_Generacion_S03 (INPUT gre_header.m_divorigen,
                                    INPUT gre_header.serieGuia,
                                    INPUT gre_header.numeroGuia,
                                    OUTPUT pMensaje).
            IF RETURN-VALUE = "ADM-ERROR" THEN DO:
                FIND FIRST b-gre_header WHERE ROWID(b-gre_header) = rRowID EXCLUSIVE-LOCK NO-ERROR.
                IF AVAILABLE b-gre_header THEN DO:
                    ASSIGN b-gre_header.m_msgerr_mov_almacen = pMensaje.
                END.
                RELEASE b-gre_header NO-ERROR.

                UNDO, RETURN "ADM-ERROR".
            END.                 
        END.
        ELSE DO:
            /* Se debe cargar en CCBCDOCU */
        END.
    END.
    WHEN GRE_Header.m_tipmov = "S" AND GRE_Header.m_codmov = 3 AND GRE_Header.m_coddoc = "OTR" THEN DO:
        IF lMueveMovAlmacen = YES THEN DO:
            /* Almcmov */
        END.
        ELSE DO:
            /* ccbcdocu */
        END.
    END.
    OTHERWISE DO:
        IF lMueveMovAlmacen = YES THEN DO:
            /* Almcmov */
        END.
        ELSE DO:
            /* ccbcdocu */
        END.
    END.
END CASE.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRE_Generacion_NO_VTA_NO_OTR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRE_Generacion_NO_VTA_NO_OTR Procedure 
PROCEDURE GRE_Generacion_NO_VTA_NO_OTR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pSerieGuia AS INT.
DEF INPUT PARAMETER pNroGuia AS INT.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEFINE VAR cFiler AS CHAR.
DEFINE VAR iLlevarTraerMercaderia AS INT.

DEFINE VAR cPartidaCod AS CHAR.
DEFINE VAR cLlegadaCod AS CHAR.
DEFINE VAR cPartidaDir AS CHAR.
DEFINE VAR cLlegadaDir AS CHAR.
DEFINE VAR cCodPed AS CHAR.
DEFINE VAR cCodAge AS CHAR.
DEFINE VAR cCodAnt AS CHAR.

FIND FIRST gre_header WHERE gre_header.m_divorigen = pCodDiv AND 
                            gre_header.serieGuia = pSerieGuia AND
                            gre_header.numeroGuia = pNroGuia NO-LOCK NO-ERROR.
IF NOT AVAILABLE gre_header THEN DO:
    pMensaje = "Guia " + STRING(pSerieGuia,"999") + STRING(pNroGuia,"99999999") + " no existe".

    cFiler = fwrite_log("Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + 
                    "   No existe").

    RETURN "ADM-ERROR".
END.

DEFINE VAR cFiler1 AS CHAR.

cFiler = fwrite_log("Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + " NO VTA, INICIOOOOOO").

cFiler1 = STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999").

iLlevarTraerMercaderia = gre_header.m_llevar_traer_mercaderia.

cPartidaCod = gre_header.m_Codalm.
cCodPed = "Almacen".
cPartidaDir = gre_header.direccionPtoPartida.
cLlegadaDir = gre_header.direccionPtoLlegada.

IF iLlevarTraerMercaderia <= 0 THEN DO:
    cLlegadaCod = gre_header.m_cliente.
    cCodAnt = "Cliente".
    IF TRUE <> (cLlegadaCod > "") THEN DO:
        cLlegadaCod = gre_header.m_proveedor.
        cCodAnt = "Proveedor".
    END.            
    IF TRUE <> (cLlegadaCod > "") THEN do:
        cLlegadaCod = gre_header.m_Codalmdes.
        cCodAnt = "Almacen".
    END.            
END.
ELSE DO:
    IF iLlevarTraerMercaderia = 1 THEN DO:  /* Llevar mercaderia */
        cLlegadaCod = gre_header.m_cliente.
        cCodAnt = "Cliente".
        IF TRUE <> (cLlegadaCod > "") THEN DO:
            cLlegadaCod = gre_header.m_proveedor.
            cCodAnt = "Proveedor".
        END.                
    END.
    ELSE DO:
        /* Traer mercaderia */
        cLlegadaCod = gre_header.m_Codalm.
        cCodAnt = "Almacen".

        cPartidaCod = gre_header.m_cliente.
        cCodPed = "Cliente".
        IF TRUE <> (cPartidaCod > "") THEN DO:
            cPartidaCod = gre_header.m_proveedor.
            cCodPed = "Proveedor".
        END.                
    END.
END.

/* Transportista */
/*cCodAge*/

DEFINE VAR cSerieNumeroDoc AS CHAR.

IF gre_header.m_tpomov = "GRVTA" THEN DO:
    cSerieNumeroDoc = STRING(gre_header.m_nroser,"999") + STRING(gre_header.m_nrodoc,"99999999").
    IF gre_header.m_coddoc = 'FAI' THEN cSerieNumeroDoc = STRING(gre_header.m_nroser,"999") + STRING(gre_header.m_nrodoc,"999999").
    /* Vta */
    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = 1 AND ccbcdocu.coddoc = gre_header.m_coddoc AND
                        ccbcdocu.nrodoc = cSerieNumeroDoc NO-LOCK NO-ERROR.
    /* Agencia de Transporte */     
    IF AVAILABLE ccbcdocu THEN DO:
        FIND FIRST ccbadocu WHERE ccbadocu.codcia = 1 AND
                                    ccbadocu.coddiv = ccbcdocu.divori AND
                                    ccbadocu.coddoc = ccbcdocu.libre_c01 AND  /* O/D */
                                    ccbadocu.nrodoc = ccbcdocu.libre_c02 NO-LOCK NO-ERROR.
        IF AVAILABLE ccbadocu THEN DO:
            /* Agencia de transporte */
            IF NOT (TRUE <> (ccbadocu.libre_c[20] > "")) THEN DO:
                /* Si tiene SEDE es agencia de transporte */
                cCodAge = ccbadocu.libre_c[10].
                cLlegadaDir = ccbadocu.libre_c[13].
                /*cDireccionEntrega = x-ccbadocu.libre_c[13].     /* Direccion del Cliente */*/
            END.
        END.
    END.
END.

GRABAR:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    CREATE b-ccbcdocu.
    ASSIGN b-ccbcdocu.codcia = 1
            b-ccbcdocu.tpoFac = 'I'
            b-ccbcdocu.coddoc = 'G/R'
            b-CcbCDocu.NroDoc =  STRING(gre_header.serieGuia,"999") + STRING(gre_header.numeroGuia,"99999999")
            b-CcbCDocu.FchDoc = TODAY
            b-CcbCDocu.usuario = USERID("dictdb")
            b-CcbCDocu.horcie = STRING(TIME,"hh:mm:ss")
            b-CcbCDocu.codped = cCodped
            b-CcbCDocu.CodAlm = cPartidaCod
            b-CcbCDocu.dircli = cPartidaDir
            b-CcbCDocu.CodAnt = cCodAnt
            b-CcbCDocu.CodCli = cLlegadaCod
            b-CcbCDocu.RucCli = cLlegadaCod     /* RUC ?????? */
            b-CcbCDocu.LugEnt2 = cLlegadaDir
            b-CcbCDocu.CodAge = cCodAge
            b-CcbCDocu.Glosa = gre_header.observaciones NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        cFiler = fwrite_log("ERROR al Actualizar la GRE como procesada  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + 
                        ERROR-STATUS:GET-MESSAGE(1)).
        pMensaje = cFiler.
        UNDO GRABAR, RETURN "ADM-ERROR".
    END.

    /* Detalle */
    FOR EACH gre_detail WHERE gre_detail.ncorrelativo = gre_header.ncorrelatio NO-LOCK:
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND almmmatg.codmat = gre_detail.codmat NO-LOCK NO-ERROR.
        CREATE ccbrdocu.
            ASSIGN ccbrdocu.codcia = s-codcia
                    ccbrdocu.coddoc = b-ccbcdocu.coddoc
                    ccbrdocu.nrodoc = b-ccbcdocu.nrodoc
                    CcbRDocu.NroItm = gre_detail.nroitm 
                    ccbrdocu.CodMat = gre_detail.codmat
                    ccbrdocu.DesMat = IF (AVAILABLE almmmatg) THEN almmmatg.desmat ELSE "<ERROR NO EXISTE>"
                    ccbrdocu.DesMar = IF (AVAILABLE almmmatg) THEN almmmatg.desmar ELSE "<ERROR NO EXISTE>"
                    ccbrdocu.CanDes = gre_detail.candes
                    ccbrdocu.UndVta = gre_detail.codund NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            cFiler = fwrite_log("ERROR al adicionar articulo " + gre_detail.codmat + " a ccbrdocu --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") +
                            ERROR-STATUS:GET-MESSAGE(1)).
            pMensaje = cFiler.
            UNDO GRABAR, RETURN "ADM-ERROR".
        END.
    END.

    FIND CURRENT gre_header EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        cFiler = fwrite_log("ERROR, gre_header esta bloqueada  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") +
                        ERROR-STATUS:GET-MESSAGE(1)).
        pMensaje = cFiler.
        UNDO GRABAR, RETURN "ADM-ERROR".
    END.

    ASSIGN gre_header.m_estado_mov_almacen = "PROCESADO"
            gre_header.m_fechahora_mov_almacen = NOW NO-ERROR.

    IF ERROR-STATUS:ERROR = YES THEN DO:
        cFiler = fwrite_log("ERROR al Actualizar la GRE como procesada  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") +
                        ERROR-STATUS:GET-MESSAGE(1)).
        pMensaje = cFiler.
        UNDO GRABAR, RETURN "ADM-ERROR".
    END.

    RELEASE b-Ccbcdocu NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        cFiler = fwrite_log("ERROR Release b-Ccbcdocu  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") +
                        ERROR-STATUS:GET-MESSAGE(1)).
        pMensaje = cFiler.
        UNDO GRABAR, RETURN "ADM-ERROR".
    END.
    RELEASE gre_header NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        cFiler = fwrite_log("ERROR Release gre_header  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") +
                        ERROR-STATUS:GET-MESSAGE(1)).
        pMensaje = cFiler.
        UNDO GRABAR, RETURN "ADM-ERROR".
    END.
    RELEASE ccbrdocu NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        cFiler = fwrite_log("ERROR Release ccbrdocu  --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") +
                        ERROR-STATUS:GET-MESSAGE(1)).
        pMensaje = cFiler.
        UNDO GRABAR, RETURN "ADM-ERROR".
    END.
END.
cFiler = fwrite_log("Guia : " + cFiler1 + " FIN OK").

pMensaje = "OK".

RETURN "OK".

END PROCEDURE.

/*
    pMensaje = "Guia " + STRING(pSerieGuia,"999") + STRING(pNroGuia,"99999999") + " no existe".

    cFiler = fwrite_log("Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + 
                    "   No existe").

    RETURN "ADM-ERROR".
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRE_Generacion_Pedido_S03) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRE_Generacion_Pedido_S03 Procedure 
PROCEDURE GRE_Generacion_Pedido_S03 PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF BUFFER B-CPEDI FOR Faccpedi.
DEF BUFFER B-DPEDI FOR Facdpedi.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FIND FIRST B-CPEDI WHERE B-CPEDI.codcia = s-codcia
        AND B-CPEDI.coddoc = Almcmov.codref
        AND B-CPEDI.nroped = Almcmov.nroref
        EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE B-CPEDI THEN DO:
    
        fwrite_log("ERROR DETALLE PEDIDO --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + 
                                'No se pudo bloquear la Orden de Transferencia ' + Almcmov.codref + " " + Almcmov.nroref ).
        pMensaje = 'No se pudo bloquear la Orden de Transferencia ' + Almcmov.codref + " " + Almcmov.nroref.
        RETURN "ADM-ERROR".
    END.
    FOR EACH almdmov OF almcmov NO-LOCK:
        FIND B-DPEDI OF B-CPEDI WHERE B-DPEDI.codmat = Almdmov.codmat
            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE B-DPEDI THEN DO:
            fwrite_log("ERROR DETALLE --->Guia : " + STRING(gre_header.serieGuia,"999") + "-" + STRING(gre_header.numeroGuia,"99999999") + 
                                " ARTICULO:" + gre_detail.codmat + "   ERROR: No se pudo bloquear el detalle de la Orden de Transferencia" ).
            pMensaje = 'No se pudo bloquear el detalle de la Orden de Transferencia'.
            UNDO RLOOP, RETURN "ADM-ERROR".
        END.
        ASSIGN
            B-DPEDI.CanAte = B-DPEDI.CanAte + Almdmov.candes.
    END.
    FIND FIRST B-DPEDI OF B-CPEDI WHERE B-DPEDI.CanPed > B-DPEDI.CanAte NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-DPEDI 
    THEN B-CPEDI.FlgEst = 'C'.     /* Atendido */
    ELSE B-CPEDI.FlgEst = 'P'.     /* Pendiente */

    ASSIGN B-CPEDI.FlgSit = 'C'.        /* Ic - 08May2023, Ruben y Max */

    /* RHC 08/07/2104 La G/R hereda el chequeo */
    ASSIGN
        Almcmov.Libre_c02 = 'C'
        Almcmov.Libre_c03 = B-CPEDI.usrchq + '|' + 
            STRING(B-CPEDI.fchchq, '99/99/9999') + '|' +
            STRING(B-CPEDI.horchq,'HH:MM:SS') + '|' +
            STRING(B-CPEDI.fecsac, '99/99/9999') + '|' + B-CPEDI.horsac
        .
END.
IF AVAILABLE(B-CPEDI) THEN RELEASE B-CPEDI.
IF AVAILABLE(B-DPEDI) THEN RELEASE B-DPEDI.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRE_Generacion_S03) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRE_Generacion_S03 Procedure 
PROCEDURE GRE_Generacion_S03 PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pSerieGuia AS INT.
DEF INPUT PARAMETER pNroGuia AS INT.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEFINE VARIABLE s-FlgPicking LIKE GN-DIVI.FlgPicking.
DEFINE VARIABLE s-FlgBarras  LIKE GN-DIVI.FlgBarras.

DEFINE VAR cDesAlmDes AS CHAR.

/**/
FIND FIRST gre_header WHERE gre_header.m_divorigen = pCodDiv AND 
                            gre_header.serieGuia = pSerieGuia AND
                            gre_header.numeroGuia = pNroGuia NO-LOCK NO-ERROR.
IF NOT AVAILABLE gre_header THEN DO:
    pMensaje = "Guia " + STRING(pSerieGuia,"999") + STRING(pNroGuia,"99999999") + " no existe".
    RETURN "ADM-ERROR".
END.

FIND FIRST gn-divi WHERE gn-divi.codcia = 1
    AND gn-divi.coddiv = gre_header.m_divorigen NO-LOCK NO-ERROR.
IF AVAILABLE gn-divi THEN 
    ASSIGN
    s-FlgPicking = GN-DIVI.FlgPicking
    s-FlgBarras  = GN-DIVI.FlgBarras.
ELSE 
    ASSIGN
    s-FlgPicking = NO
    s-FlgBarras  = NO.

FIND FIRST almacen WHERE almacen.codcia = 1 AND almacen.codalm = gre_header.m_codalmdes NO-LOCK NO-ERROR.
IF AVAILABLE almacen THEN cDesAlmDes = almacen.descripcion.

/* ***************************************************************************** */
/* RUTINA PRINCIPAL */
/* ***************************************************************************** */
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    CREATE Almcmov.
    ASSIGN
        Almcmov.CodCia = s-CodCia 
        Almcmov.TipMov = GRE_Header.m_tipmov        
        Almcmov.CodMov = GRE_Header.m_codmov        
        Almcmov.FlgSit = "T"      /* Transferido pero no Recepcionado */
        Almcmov.FchDoc = DATE(gre_header.fechahora_envio_a_sunat)
        Almcmov.HorSal = string(MTIME(gre_header.fechahora_envio_a_sunat),"HH:MM:SS")
        Almcmov.HraDoc = string(MTIME(gre_header.fechahora_envio_a_sunat),"HH:MM:SS") /*STRING(TIME,"HH:MM")*/
        Almcmov.NroSer = gre_header.serieGuia
        Almcmov.NroDoc = gre_header.numeroGuia
        Almcmov.usuario = gre_header.m_usuario
        almcmov.nomref = cDesAlmDes
        Almcmov.CodAlm = GRE_Header.m_codalm
        Almcmov.AlmDes = GRE_Header.m_codalmdes
        Almcmov.CodRef = GRE_Header.m_coddoc
        Almcmov.NroRef = STRING(gre_header.m_nroser,"999") + STRING(gre_header.m_nrodoc,"999999")
        Almcmov.Observ = GRE_Header.observacion
        Almcmov.AlmacenXD = gre_header.m_almacenXD
        Almcmov.CrossDocking = gre_header.m_crossdocking
        Almcmov.NroRf1 = GRE_Header.m_nroref1
        Almcmov.NroRf2 = GRE_Header.m_nroref2
        Almcmov.NroRf3 = gre_header.m_nroRef3
        Almcmov.Libre_l02 = gre_header.m_libre_l02
        Almcmov.Libre_c05 = gre_header.m_libre_c05 
        almcmov.codcli = gre_header.m_cliente
        almcmov.codpro = gre_header.m_proveedor
        almcmov.libre_c01 = gre_header.m_sede
        almcmov.cco = gre_header.m_cco 
        almcmov.nomref = gre_header.m_nomref NO-ERROR.
        
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = "No se pudo ingresar el movimiento en el almacen".
        UNDO, RETURN "ADM-ERROR".
    END.

    IF AVAILABLE Almtmovm AND Almtmovm.Indicador[2] = YES THEN Almcmov.FlgEst = "X".

    IF GRE_Header.m_tipmov = "S" AND GRE_Header.m_codmov = 3 AND GRE_Header.m_coddoc <> "OTR" THEN DO:
      /* RHC 31/07/2015 Control de Picking y Pre-Picking */
      IF s-FlgPicking = YES THEN ASSIGN Almcmov.Libre_c02 = "T".    /* Por Pickear en Almacén */
      IF s-FlgPicking = NO AND s-FlgBarras = NO THEN ASSIGN Almcmov.Libre_c02 = "C".    /* Barras OK */
      IF s-FlgPicking = NO AND s-FlgBarras = YES THEN ASSIGN Almcmov.Libre_c02 = "P".   /* Pre-Picking OK */

      IF Almcmov.Libre_c02 = "T"  THEN ASSIGN Almcmov.Libre_c02 = "P".
    END.

    /* ***************************************************************************** */
    /* DETALLE */
    /* ***************************************************************************** */
    RUN GRE_Generacion_Detalle_S03 (OUTPUT pMensaje) NO-ERROR.

    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
    /* ***************************************************************************** */

    /* ***************************************************************************** */
    /* ACTUALIZA ATENDIDO EN LA OTR */
    /* ***************************************************************************** */
    IF GRE_Header.m_tipmov = "S" AND GRE_Header.m_codmov = 3 AND GRE_Header.m_coddoc = "OTR" THEN DO:
        RUN GRE_Generacion_Pedido_S03 (OUTPUT pMensaje).
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
    END.
    /* ***************************************************************************** */

    /* ***************************************************************************** */
    /* RHC 01/12/17 Log para e-Commerce */
    /* ***************************************************************************** */
    DEF VAR pOk AS LOG NO-UNDO.

    RUN gn/log-inventory-qty.p (ROWID(Almcmov),
                                "C",      /* CREATE */
                                OUTPUT pOk).
    IF pOk = NO THEN DO:
        pMensaje = "NO se pudo actualizar el log de e-Commerce" + CHR(10) +
            "Proceso Abortado".
        UNDO, RETURN 'ADM-ERROR'.
    END.

    /* Solo x OTR */
    IF GRE_Header.m_tipmov = "S" AND GRE_Header.m_codmov = 3 AND GRE_Header.m_coddoc = "OTR" THEN DO:
        /* ***************************************************************************** */
        /* RHC 12/10/2020 CONTROL MR */
        /* ***************************************************************************** */
        DEFINE VAR hMaster AS HANDLE NO-UNDO.

        RUN gn/master-library PERSISTENT SET hMaster.
        RUN ML_Actualiza-TRF-Control IN hMaster (INPUT ROWID(Almcmov),     /* S-03 */
                                                 OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            DELETE PROCEDURE hMaster.
            UNDO, RETURN 'ADM-ERROR'.            
        END.
        DELETE PROCEDURE hMaster.
        /* ***************************************************************************** */
    END.

    /* Actualizo la GRE como procesada */
    FIND FIRST b-gre_header WHERE ROWID(b-gre_header) = rRowID EXCLUSIVE-LOCK NO-ERROR.
    IF LOCKED b-gre_header THEN DO:
        pMensaje =  "EROR:*Cambiar el estado de m_estado_mov_almacen " + CHR(10) + 
                    ERROR-STATUS:GET-MESSAGE(1).
        UNDO, RETURN 'ADM-ERROR'.
    END.
    IF NOT AVAILABLE b-gre_header THEN DO:
        pMensaje =  "ERROR:**Cambiar el estado de m_estado_mov_almacen " + CHR(10) + 
                    ERROR-STATUS:GET-MESSAGE(1).
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN b-gre_header.m_estado_mov_almacen = "PROCESADO"
            b-gre_header.m_fechahora_mov_almacen = NOW.

END.

RELEASE b-gre_header NO-ERROR.
RELEASE Almcmov NO-ERROR.                   
RELEASE Almdmov NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fwrite_log) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fwrite_log Procedure 
FUNCTION fwrite_log RETURNS CHARACTER
  (INPUT pTexto AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE BUFFER x-factabla FOR factabla.

/* IP de la PC */
DEFINE VAR x-ip AS CHAR.
DEFINE VAR x-pc AS CHAR.

RUN lib/_get_ip.r(OUTPUT x-pc, OUTPUT x-ip).

/* ---- */
DEFINE VAR lClientComputerName  AS CHAR.
DEFINE VAR lClientName          AS CHAR.
DEFINE VAR lComputerName        AS CHAR.

DEFINE VAR lPCName AS CHAR.
 
lClientComputerName = OS-GETENV ( "CLIENTCOMPUTERNAME"). 
lClientName         = OS-GETENV ( "CLIENTNAME").
lComputerName       = OS-GETENV ( "COMPUTERNAME").

lPcName = IF (lClientComputerName = ? OR lClientComputerName = "") THEN lClientName ELSE lClientComputerName.
lPCName = IF (CAPS(lPCName) = "CONSOLE") THEN "" ELSE lPCName.
lPCName = IF (lPCName = ? OR lPCName = "") THEN lComputerName ELSE lPCName.
/* ------ */

DEFINE VAR x-archivo AS CHAR.
DEFINE VAR x-file AS CHAR.
DEFINE VAR x-linea AS CHAR.

x-file = STRING(TODAY,"99/99/9999").
/*x-file = x-file + "-" + STRING(TIME,"HH:MM:SS").*/

x-file = REPLACE(x-file,"/","").
x-file = REPLACE(x-file,":","").

x-archivo = session:TEMP-DIRECTORY + "LOG-MOVIMIENTOS-ALMACEN-" + x-file + ".txt".

IF SESSION:WINDOW-SYSTEM = "TTY" THEN DO:
    IF lPCName = ? THEN lPCName = "SERVER/LINUX".
END.

OUTPUT STREAM log-epos TO VALUE(x-archivo) APPEND.

x-linea = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"hh:mm:ss") + " (" + lPCName + "-" + x-pc + ":" + x-ip + ") - " + TRIM(pTexto).

PUT STREAM log-epos x-linea FORMAT 'x(300)' SKIP.

OUTPUT STREAM LOG-epos CLOSE.


RETURN "".  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

