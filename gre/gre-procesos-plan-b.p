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

DEFINE INPUT PARAMETER pserieGRE AS INT NO-UNDO.
DEFINE INPUT PARAMETER pnumeroGRE AS INT NO-UNDO.
DEFINE INPUT PARAMETER pCodDiv AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pserieGRF AS INT NO-UNDO.        /* Guia de remision Fisica */
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

DEFINE VAR s-codcia AS INT INIT 1.
/*DEFINE SHARED VAR s-coddiv AS CHAR.*/
/**/
DEFINE BUFFER b-gre_header FOR gre_header.
DEFINE BUFFER b-almcmov FOR almcmov.
DEFINE BUFFER b-almdmov FOR almdmov.
DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER fai-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER b-ccbddocu FOR ccbddocu.
DEFINE BUFFER b-faccorre FOR faccorre.
DEFINE BUFFER B-ADocu FOR ccbADocu.
DEFINE BUFFER b-ccbrdocu FOR ccbrdocu.

/**/
DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER x-ccbddocu FOR ccbddocu.

/* Temporales */
DEFINE TEMP-TABLE t-almcmov LIKE almcmov
    INDEX idx01 codcia codalm tipmov codmov.
DEFINE TEMP-TABLE t-almdmov LIKE almdmov
    INDEX idx01 codcia codalm tipmov codmov.
DEFINE TEMP-TABLE t-ccbcdocu LIKE ccbcdocu
    INDEX idx01 codcia coddoc.
DEFINE TEMP-TABLE t-ccbddocu LIKE ccbddocu
    INDEX idx01 codcia coddoc.
DEFINE TEMP-TABLE T-CcbADocu LIKE CcbADocu
    INDEX idx01 codcia coddoc.
DEFINE TEMP-TABLE T-CcbRDocu LIKE CcbRDocu
    INDEX idx01 codcia coddoc.

DEFINE VAR iItemsxGR AS INT.

/*s-coddiv = pCodDiv.*/

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

DEFINE VAR cRetval AS CHAR.      

FIND FIRST b-gre_header WHERE b-gre_header.serieGuia = pserieGRE AND b-gre_header.numeroGuia = pnumeroGRE NO-LOCK NO-ERROR.

IF NOT AVAILABLE b-gre_header THEN DO:
    pRetval = "La guia de remision " + STRING(pserieGRE,"999") + "-" + STRING(pnumeroGRE,"99999999") + " no existe".
    RETURN "ADM-ERROR".
END.

IF LOOKUP(b-gre_header.m_rspta,'ENVIADO A SUNAT,ESPERANDO RESPUESTA SUNAT') = 0 THEN DO:
    pRetval = "La guia de remision " + STRING(pserieGRE,"999") + "-" + STRING(pnumeroGRE,"99999999") + " Ya no se encuentra enviada a Sunat".
    RETURN "ADM-ERROR".
END.


FIND FIRST almtmovm WHERE almtmovm.codcia = 1 AND
                    almtmovm.tipmov = b-gre_header.m_tipmov AND 
                    almtmovm.codmov = b-gre_header.m_codmov NO-LOCK NO-ERROR.
IF NOT AVAILABLE almtmovm THEN DO:
    pRetVal = "GRE " + STRING(b-gre_header.serieGuia,"999") + "-" + STRING(b-gre_header.numeroGuia,"99999999") +
           " El codigo movimiento(" + b-gre_header.m_tipmov + string(b-gre_header.m_codmov,"99") + ") NO existe".
    RETURN "ADM-ERROR".
END.

FIND FIRST almacen WHERE almacen.codcia = s-codcia AND almacen.codalm = b-gre_header.m_codalm NO-LOCK NO-ERROR.
/* la division del almacen */
IF pCoddiv <> almacen.coddiv THEN DO:
    pRetVal = "La division(" + almacen.coddiv + ") que pertenece al almacen(" + b-gre_header.m_codalm + ") de la GRE " + STRING(b-gre_header.serieGuia,"999") + "-" + STRING(b-gre_header.numeroGuia,"99999999") +
           " no coincide con la division(" + pCoddiv + ") enviado como parametro".
    RETURN "ADM-ERROR".
END.
/*
FIND FIRST gn-divi WHERE gn-divi.codcia = 1
    AND gn-divi.coddiv = pCoddiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    pRetval = "La guia de remision " + STRING(pserieGRE,"999") + "-" + STRING(pnumeroGRE,"99999999") + 
                " el almacen (" + b-gre_header.m_codalm + ") tiene una division(" + s-coddiv + ") que no existe".
    RETURN "ADM-ERROR".
END.
*/
/* Almacen destino */
FIND FIRST almacen WHERE almacen.codcia = s-codcia AND almacen.codalm = b-gre_header.m_codalmdes NO-LOCK NO-ERROR.

iItemsxGR = 0.     /* Segun la serie se debe definir cuantos Items x GRF */

IF b-gre_header.m_tpomov = 'GRVTA' THEN RUN items-segun-formato(pCodDiv,'VTA',iItemsxGR).
IF b-gre_header.m_tpomov <> 'GRVTA' THEN RUN items-segun-formato(pCodDiv,'TRA',iItemsxGR).

IF iItemsxGR < 0 THEN DO:
    pRetVal = "La division(" + pCodDiv + ") que pertenece al almacen(" + b-gre_header.m_codalm + ") de la GRE " + STRING(b-gre_header.serieGuia,"999") + "-" + STRING(b-gre_header.numeroGuia,"99999999") +
           " No tiene configurado la cantidad de Items para las GR Fisicas".
    RETURN "ADM-ERROR".
END.

/* Cargar a temporales */
CASE TRUE:
    WHEN b-gre_header.m_tpomov = 'GRVTA' AND LOOKUP(b-gre_header.m_coddoc,"FAC,BOL,FAI,N/C") > 0 THEN DO:
        /* GRE x ventas */
        RUN GRE_CCBCDOCU_TEMPORAL(OUTPUT pRetval).
        IF RETURN-VALUE = "ADM-ERROR" THEN DO:
            RETURN "ADM-ERROR".
        END.
        FIND FIRST t-ccbddocu NO-LOCK NO-ERROR.
        IF NOT AVAILABLE t-ccbddocu THEN DO:
            pRetval = "La guia de remision " + STRING(pserieGRE,"999") + "-" + STRING(pnumeroGRE,"99999999") + " no tiene detalle de items(t-ccbddocu)".
            RETURN "ADM-ERROR".
        END.

    END.
    /*WHEN b-gre_header.m_tpomov = 'GRTRA' AND b-gre_header.m_codmov = 3 THEN DO:*/
    WHEN almtmovm.movval = YES AND LOOKUP(b-gre_header.m_coddoc,"FAC,BOL,FAI,N/C") = 0 THEN DO:
        /* GRE x OTR / GRE OTROS y mueven almacen */
        RUN gre-mov-almacen-temporal(OUTPUT pRetval).
        IF RETURN-VALUE = "ADM-ERROR" THEN DO:
            RETURN "ADM-ERROR".
        END.
        FIND FIRST t-almdmov NO-LOCK NO-ERROR.
        IF NOT AVAILABLE t-almdmov THEN DO:
            pRetval = "La guia de remision " + STRING(pserieGRE,"999") + "-" + STRING(pnumeroGRE,"99999999") + " no tiene detalle de items".
            RETURN "ADM-ERROR".
        END.
    END.
    OTHERWISE DO:
        /* OTROS */
        RUN GRE_NO_VTA_NO_OTR_temporal(OUTPUT pRetval).
        IF RETURN-VALUE = "ADM-ERROR" THEN DO:
            RETURN "ADM-ERROR".
        END.
        FIND FIRST t-ccbRdocu NO-LOCK NO-ERROR.
        IF NOT AVAILABLE t-ccbRdocu THEN DO:
            pRetval = "La guia de remision " + STRING(pserieGRE,"999") + "-" + STRING(pnumeroGRE,"99999999") + " no tiene detalle de items(t-ccbRdocu)".
            RETURN "ADM-ERROR".
        END.
    END.
END CASE.



/*
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = 'd:\xpciman\t-ccbcdocu.xlsx'.

run pi-crea-archivo-csv IN hProc (input  buffer t-ccbcdocu:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer t-ccbcdocu:handle,
                        input  c-csv-file,
                        output c-xls-file) .

c-xls-file = 'd:\xpciman\t-ccbddocu.xlsx'.

run pi-crea-archivo-csv IN hProc (input  buffer t-ccbddocu:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer t-ccbddocu:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.

MESSAGE "TEMPORALESSS".     /* ?????????????????????????? */

RETURN "ADM-ERROR".
*/

pRetval = "Hubo problemas al grabar".

GRABAR_DATOS:
DO TRANSACTION ON ERROR UNDO GRABAR_DATOS, LEAVE ON STOP UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS:

    /* Los correlativos de la G/R */
    FIND FIRST b-faccorre WHERE b-faccorre.codcia = s-codcia AND b-faccorre.coddiv = pCoddiv 
                                AND b-faccorre.coddoc = 'G/R' AND b-faccorre.nroser = pserieGRF EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR THEN DO:
        pRetVal = "Correlativos : Division(" + pCoddiv + ") Doc(G/R) Serie : " + STRING(pserieGRF) + " ERROR : "+ ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
    END.

    FIND CURRENT b-gre_header EXCLUSIVE-LOCK NO-ERROR NO-WAIT.    
    IF ERROR-STATUS:ERROR THEN DO:
        pRetVal = "Problemas al grabar en GRE_HEADER : " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
    END.
    ASSIGN b-gre_header.m_rspta_sunat = "ANULADO".
    
    /**/
    CASE TRUE:
        /*WHEN b-gre_header.m_tpomov = 'GRVTA' THEN DO:*/
        WHEN b-gre_header.m_tpomov = 'GRVTA' AND LOOKUP(b-gre_header.m_coddoc,"FAC,BOL,FAI,N/C") > 0 THEN DO:
            /* GRE x ventas */
            RUN GRE_CCBCDOCU_GRABAR(OUTPUT pRetval).
            IF RETURN-VALUE = "ADM-ERROR" THEN DO:
                UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
            END.
            IF ERROR-STATUS:ERROR THEN DO:
                pRetVal = "ERROR al grabar la guia en CCBCDOCU :" + ERROR-STATUS:GET-MESSAGE(1).
                UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
            END.
        END.
        /*WHEN b-gre_header.m_tpomov = 'GRTRA' AND b-gre_header.m_codmov = 3 THEN DO:*/
        WHEN almtmovm.movval = YES AND LOOKUP(b-gre_header.m_coddoc,"FAC,BOL,FAI,N/C") = 0 THEN DO:
            /* GRE x OTR */
            RUN gre-mov-almacen-grabar(OUTPUT pRetval).
            IF RETURN-VALUE = "ADM-ERROR" THEN DO:
                UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
            END.
            IF ERROR-STATUS:ERROR THEN DO:
                pRetVal = "ERROR al grabar los movimientos de almamcen :" + ERROR-STATUS:GET-MESSAGE(1).
                UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
            END.
        END.
        OTHERWISE DO:
            /* OTROS */
            RUN GRE_NO_VTA_NO_OTR_grabar(OUTPUT pRetval).
            IF RETURN-VALUE = "ADM-ERROR" THEN DO:
                UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
            END.
            IF ERROR-STATUS:ERROR THEN DO:
                pRetVal = "ERROR al grabar la guia en CCBCDOCU :" + ERROR-STATUS:GET-MESSAGE(1).
                UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
            END.
        END.
    END CASE.

    RELEASE b-gre_header NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pRetVal = "ERROR : release gre_header -> " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
    END.
    
    pRetVal = 'OK'.
END.

IF pRetVal = 'OK' THEN RETURN "OK".

RETURN "ADM-ERROR".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-generar-guias-fisicas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-guias-fisicas Procedure 
PROCEDURE generar-guias-fisicas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-gre-mov-almacen-grabar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gre-mov-almacen-grabar Procedure 
PROCEDURE gre-mov-almacen-grabar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pcRetVal AS CHAR NO-UNDO.

DEFINE VAR iCorrelativo AS INT.
DEFINE VAR rRowId AS ROWID.

DEFINE VAR iserieTempo AS INT.
DEFINE VAR inumeroTempo AS INT.

iCorrelativo = b-faccorre.correlativo.

FOR EACH t-almcmov :

    iserieTempo = t-almcmov.nroser.
    inumeroTempo = t-almcmov.nrodoc.

    FOR EACH t-almdmov WHERE t-almdmov.nroser = iserieTempo AND t-almdmov.nrodoc = inumeroTempo:
        ASSIGN t-almdmov.nroser = b-faccorre.nroser. /*t-almcmov.nroser*/
                t-almdmov.nrodoc = iCorrelativo.     /*t-almcmov.nrodoc.*/

    END.
    ASSIGN t-almcmov.nroser = b-faccorre.nroser
            t-almcmov.nrodoc = iCorrelativo.

    iCorrelativo = iCorrelativo + 1.
END.

pcRetVal = "PROCESANDO".

GRABAR_MOV_ALMACEN:
DO TRANSACTION ON ERROR UNDO GRABAR_MOV_ALMACEN, LEAVE ON STOP UNDO GRABAR_MOV_ALMACEN, LEAVE GRABAR_MOV_ALMACEN:

    FOR EACH t-almcmov NO-LOCK:
        /* Cabaecera */
        CREATE b-almcmov.
        BUFFER-COPY t-almcmov TO b-almcmov NO-ERROR.

        IF ERROR-STATUS:ERROR THEN DO:
            pcRetVal = "ERROR AL ADD ALMCMOV : " + ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABAR_MOV_ALMACEN, LEAVE GRABAR_MOV_ALMACEN.
        END.

        FOR EACH t-almdmov WHERE t-almdmov.nroser = t-almcmov.nroser AND t-almdmov.nrodoc = t-almcmov.nrodoc NO-LOCK:
            CREATE b-almdmov.
            BUFFER-COPY t-almdmov TO b-almdmov NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pcRetVal = "ERROR AL ADD ALMDMOV, ARTICULO : (" + t-almdmov.codmat + ") " + ERROR-STATUS:GET-MESSAGE(1).
                UNDO GRABAR_MOV_ALMACEN, LEAVE GRABAR_MOV_ALMACEN.
            END.

            rROWID = ROWID(b-Almdmov).
            /* */
            RUN alm/almdcstk(rROWID) NO-ERROR.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                pcRetVal = "ERROR RUTINA alm/almdcstk, ARTICULO : (" + t-almdmov.codmat + ") " + ERROR-STATUS:GET-MESSAGE(1).
                UNDO GRABAR_MOV_ALMACEN, LEAVE GRABAR_MOV_ALMACEN.
            END.

            /* */
            RUN alm/almacpr1 (rROWID, "U") NO-ERROR.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                pcRetVal = "ERROR RUTINA alm/almacpr1, ARTICULO : (" + t-almdmov.codmat + ") " + ERROR-STATUS:GET-MESSAGE(1).
                UNDO GRABAR_MOV_ALMACEN, LEAVE GRABAR_MOV_ALMACEN.
            END.
        END.
        /* ***************************************************************************** */
        /* ACTUALIZA ATENDIDO EN LA OTR */
        /* ***************************************************************************** */
        IF b-GRE_Header.m_tipmov = "S" AND b-GRE_Header.m_codmov = 3 AND b-GRE_Header.m_coddoc = "OTR" THEN DO:
            RUN GRE_Generacion_Pedido_S03 (OUTPUT pcRetVal).
            IF RETURN-VALUE = "ADM-ERROR" THEN UNDO GRABAR_MOV_ALMACEN, LEAVE GRABAR_MOV_ALMACEN.
        END.
        /* ***************************************************************************** */
        /* RHC 01/12/17 Log para e-Commerce */
        /* ***************************************************************************** */
        DEF VAR pOk AS LOG NO-UNDO.
    
        RUN gn/log-inventory-qty.p (ROWID(b-Almcmov),
                                    "C",      /* CREATE */
                                    OUTPUT pOk).
        IF pOk = NO THEN DO:
            pcRetVal = "NO se pudo actualizar el log de e-Commerce" + CHR(10) +
                "Proceso Abortado".
            UNDO GRABAR_MOV_ALMACEN, LEAVE GRABAR_MOV_ALMACEN.
        END.
        /* Solo x OTR */
        IF b-GRE_Header.m_tipmov = "S" AND b-GRE_Header.m_codmov = 3 AND b-GRE_Header.m_coddoc = "OTR" THEN DO:
            /* ***************************************************************************** */
            /* RHC 12/10/2020 CONTROL MR */
            /* ***************************************************************************** */
            DEFINE VAR hMaster AS HANDLE NO-UNDO.
    
            RUN gn/master-library PERSISTENT SET hMaster.
            RUN ML_Actualiza-TRF-Control IN hMaster (INPUT ROWID(b-Almcmov),     /* S-03 */
                                                     OUTPUT pcRetVal).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                pcRetVal = "ML_Actualiza-TRF-Control : " + CHR(10) + pcRetVal + CHR(10) +
                    "Proceso Abortado".
                DELETE PROCEDURE hMaster.
                UNDO GRABAR_MOV_ALMACEN, LEAVE GRABAR_MOV_ALMACEN.
            END.
            DELETE PROCEDURE hMaster.
            /* ***************************************************************************** */
        END.

        /* */
        iCorrelativo = iCorrelativo + 1.
    END.
    
    ASSIGN b-faccorre.correlativo = iCorrelativo.

    RELEASE b-faccorre NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pRetVal = "ERROR : release faccorre -> " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR_MOV_ALMACEN, LEAVE GRABAR_MOV_ALMACEN.
    END.
    RELEASE b-almcmov NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pRetVal = "ERROR : release almcmov -> " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR_MOV_ALMACEN, LEAVE GRABAR_MOV_ALMACEN.
    END.
    RELEASE b-almdmov NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pRetVal = "ERROR : release almdmov -> " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR_MOV_ALMACEN, LEAVE GRABAR_MOV_ALMACEN.
    END.

    pcRetVal = "OK".
END.

IF pcRetVal = "OK" THEN RETURN "OK".

RETURN "ADM-ERROR".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-gre-mov-almacen-temporal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gre-mov-almacen-temporal Procedure 
PROCEDURE gre-mov-almacen-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pcRetVal AS CHAR NO-UNDO.

/*iItemsxGR*/
EMPTY TEMP-TABLE t-almcmov.
EMPTY TEMP-TABLE t-almdmov.

DEFINE VAR iTotalItemsGRE AS INT.
DEFINE VAR iCuantasGRF AS INT.

DEFINE VAR iItems AS INT.
DEFINE VAR iGRFtempo AS INT.

DEFINE VAR cDesAlmDes AS CHAR.
DEFINE VARIABLE s-FlgPicking LIKE GN-DIVI.FlgPicking.
DEFINE VARIABLE s-FlgBarras  LIKE GN-DIVI.FlgBarras.

/* Cuantos Items tiene la GRE */
FOR EACH gre_detail WHERE gre_detail.ncorrelativo = b-gre_header.ncorrelatio NO-LOCK :
    iTotalItemsGRE = iTotalItemsGRE + 1.
END.

/* Cuantas GRF se van a crear */
iCuantasGRF = TRUNCATE(iTotalItemsGRE / iItemsxGR,0).
IF (iTotalItemsGRE MODULO iTotalItemsGRE) > 0 THEN iCuantasGRF = iCuantasGRF + 1.

/* almacen destino */
cDesAlmDes = IF (AVAILABLE almacen) THEN almacen.descripcion ELSE "".

ASSIGN
s-FlgPicking = NO
s-FlgBarras  = NO.

IF AVAILABLE gn-divi THEN DO:
    ASSIGN
    s-FlgPicking = GN-DIVI.FlgPicking
    s-FlgBarras  = GN-DIVI.FlgBarras.
END.

iItems = 1.
iGRFtempo = 0.
FOR EACH gre_detail WHERE gre_detail.ncorrelativo = b-gre_header.ncorrelatio NO-LOCK :
    IF iItems = 1 THEN DO:
        iGRFtempo = iGRFtempo + 1.
        /* Crear cabecera */
        CREATE t-almcmov.
        ASSIGN
            t-Almcmov.CodCia = s-CodCia 
            t-Almcmov.TipMov = b-GRE_Header.m_tipmov        
            t-Almcmov.CodMov = b-GRE_Header.m_codmov        
            t-Almcmov.FlgSit = "T"      /* Transferido pero no Recepcionado */
            t-Almcmov.FchDoc = TODAY
            t-Almcmov.HorSal = string(TIME,"HH:MM:SS")
            t-Almcmov.HraDoc = string(TIME,"HH:MM:SS") /*STRING(TIME,"HH:MM")*/
            t-Almcmov.NroSer = iGRFtempo
            t-Almcmov.NroDoc = iGRFtempo
            t-Almcmov.usuario = USERID("dictdb")
            t-almcmov.nomref = cDesAlmDes
            t-Almcmov.CodAlm = b-GRE_Header.m_codalm
            t-Almcmov.AlmDes = b-GRE_Header.m_codalmdes
            t-Almcmov.CodRef = b-GRE_Header.m_coddoc
            t-Almcmov.NroRef = STRING(b-gre_header.m_nroser,"999") + STRING(b-gre_header.m_nrodoc,"999999")
            t-Almcmov.Observ = b-GRE_Header.observacion
            t-Almcmov.AlmacenXD = b-gre_header.m_almacenXD
            t-Almcmov.CrossDocking = b-gre_header.m_crossdocking
            t-Almcmov.NroRf1 = b-GRE_Header.m_nroref1
            t-Almcmov.NroRf2 = b-GRE_Header.m_nroref2
            t-Almcmov.NroRf3 = b-gre_header.m_nroRef3
            t-Almcmov.Libre_l02 = b-gre_header.m_libre_l02
            t-Almcmov.Libre_c05 = b-gre_header.m_libre_c05 
            t-almcmov.codcli = b-gre_header.m_cliente
            t-almcmov.codpro = b-gre_header.m_proveedor
            t-almcmov.libre_c01 = b-gre_header.m_sede
            t-almcmov.cco = b-gre_header.m_cco 
            t-almcmov.nomref = b-gre_header.m_nomref NO-ERROR.

        IF ERROR-STATUS:ERROR THEN DO:
            pcRetVal = "ERROR header temporal :" + ERROR-STATUS:GET-MESSAGE(1).
            RETURN "ADM-ERROR".
        END.

        IF AVAILABLE Almtmovm AND Almtmovm.Indicador[2] = YES THEN t-Almcmov.FlgEst = "X".
    
        IF b-GRE_Header.m_tipmov = "S" AND b-GRE_Header.m_codmov = 3 AND b-GRE_Header.m_coddoc <> "OTR" THEN DO:
          /* RHC 31/07/2015 Control de Picking y Pre-Picking */
          IF s-FlgPicking = YES THEN ASSIGN t-Almcmov.Libre_c02 = "T".    /* Por Pickear en Almacén */
          IF s-FlgPicking = NO AND s-FlgBarras = NO THEN ASSIGN t-Almcmov.Libre_c02 = "C".    /* Barras OK */
          IF s-FlgPicking = NO AND s-FlgBarras = YES THEN ASSIGN t-Almcmov.Libre_c02 = "P".   /* Pre-Picking OK */
    
          IF t-Almcmov.Libre_c02 = "T"  THEN ASSIGN t-Almcmov.Libre_c02 = "P".
        END.
    END.

    CREATE t-almdmov.
    ASSIGN 
        t-Almdmov.CodCia = t-Almcmov.CodCia 
        t-Almdmov.CodAlm = t-Almcmov.CodAlm 
        t-Almdmov.TipMov = t-Almcmov.TipMov 
        t-Almdmov.CodMov = t-Almcmov.CodMov 
        t-Almdmov.NroSer = t-Almcmov.NroSer
        t-Almdmov.NroDoc = t-Almcmov.NroDoc 
        t-Almdmov.CodMon = t-Almcmov.CodMon 
        t-Almdmov.FchDoc = t-Almcmov.FchDoc 
        t-Almdmov.HraDoc = t-Almcmov.HraDoc
        t-Almdmov.TpoCmb = t-Almcmov.TpoCmb
        t-Almdmov.codmat = gre_detail.codmat
        t-Almdmov.CanDes = gre_detail.Candes
        t-Almdmov.CodUnd = gre_detail.codund
        t-Almdmov.Factor = gre_detail.Factor
        t-Almdmov.PreUni = gre_detail.precio_unitario
        t-Almdmov.AlmOri = t-Almcmov.AlmDes 
        t-Almdmov.CodAjt = ''
        t-Almdmov.HraDoc = t-Almcmov.HorSal
        t-Almdmov.NroItm = iItems NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        pcRetVal = "ERROR detail temporal :" + ERROR-STATUS:GET-MESSAGE(1).
        RETURN "ADM-ERROR".
    END.

    /**/
    iItems = iItems + 1.
    IF iItems > iItemsxGR THEN DO:
        iItems = 1.
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRE_CCBCDOCU_GRABAR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRE_CCBCDOCU_GRABAR Procedure 
PROCEDURE GRE_CCBCDOCU_GRABAR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pcRetVal AS CHAR NO-UNDO.

DEFINE VAR iCorrelativo AS INT.
DEFINE VAR cNumeroComprobante AS CHAR.

DEFINE VAR cCoddocTempo AS CHAR.
DEFINE VAR cNrodocTempo AS CHAR.

cNumeroComprobante = STRING(b-gre_header.m_nroser,"999") + STRING(b-gre_header.m_nrodoc,"99999999").
IF b-gre_header.m_coddoc = 'FAI' THEN DO:
    cNumeroComprobante = STRING(b-gre_header.m_nroser,"999") + STRING(b-gre_header.m_nrodoc,"999999").
END.

iCorrelativo = b-faccorre.correlativo.

FOR EACH t-ccbcdocu WHERE t-ccbcdocu.codcia = 1 :
    
    cCoddocTempo = t-ccbcdocu.coddoc.
    cNroDocTempo = t-ccbcdocu.nrodoc.

    FOR EACH t-ccbddocu WHERE t-ccbddocu.codcia = t-ccbcdocu.codcia AND t-ccbddocu.coddoc = cCoddocTempo AND t-ccbddocu.nrodoc = cNroDocTempo:
        ASSIGN t-ccbddocu.nrodoc = string(pserieGRF,"999") + string(iCorrelativo,"999999").
    END.

    ASSIGN t-ccbcdocu.nrodoc = string(pserieGRF,"999") + string(iCorrelativo,"999999").

    iCorrelativo = iCorrelativo + 1.    
END.

/*
DEFINE BUFFER w-ccbcdocu FOR t-ccbcdocu.

FOR EACH t-ccbcdocu WHERE t-ccbcdocu.codcia = 1 NO-LOCK:
    MESSAGE iCorrelativo1 SKIP
        t-ccbcdocu.nrodoc.
    FIND FIRST w-ccbcdocu WHERE ROWID(w-ccbcdocu) = ROWID(t-ccbcdocu) EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE w-ccbcdocu THEN DO:
        ASSIGN w-ccbcdocu.nrodoc = string(pserieGRF,"999") + string(iCorrelativo1,"999999").
        iCorrelativo1 = iCorrelativo1 + 1.
    END.
    ELSE DO:
        pcRetVal = "ERROR AL TEMPORALLLLL".
        RETURN "ADM-ERROR".
    END.
END.
*/

pcRetVal = "PROCESANDO".

GRABAR_CCBCDOCU:
DO TRANSACTION ON ERROR UNDO GRABAR_CCBCDOCU, LEAVE ON STOP UNDO GRABAR_CCBCDOCU, LEAVE GRABAR_CCBCDOCU:
    FOR EACH t-ccbcdocu NO-LOCK:
        CREATE b-ccbcdocu.
        BUFFER-COPY t-ccbcdocu TO b-ccbcdocu NO-ERROR.

        IF ERROR-STATUS:ERROR THEN DO:
            pcRetVal = "ERROR AL ADD CCBCDOCU : " + ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABAR_CCBCDOCU, LEAVE GRABAR_CCBCDOCU.
        END.
        /*  */
        /* La FAI/BOL/FAC referencia a la GRE */
        FIND FIRST fai-ccbcdocu WHERE ROWID(fai-ccbcdocu) = ROWID(x-ccbcdocu) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            pcRetVal = "ERROR  --->Guia : " + STRING(b-gre_header.serieGuia,"999") + "-" + STRING(b-gre_header.numeroGuia,"99999999") + 
                            " Al actualizar la FAI/FAC/BOL con la GRE - ERROR:" + ERROR-STATUS:GET-MESSAGE(1) .
            UNDO GRABAR_CCBCDOCU, LEAVE GRABAR_CCBCDOCU.
        END.
        ASSIGN fai-ccbcdocu.codref = b-CcbCDocu.CodDoc
                fai-ccbcdocu.nroref = b-CcbCDocu.NroDoc.

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
    
                pcRetVal = "No se pudo crear el transportista de la G/R del comprobante " + b-gre_header.m_coddoc + " " + cNumeroComprobante + " de la guia " + 
                    STRING(b-gre_header.serieGuia,"999") + STRING(b-gre_header.numeroGuia,"99999999") + CHR(10) + ERROR-STATUS:GET-MESSAGE(1).

                UNDO GRABAR_CCBCDOCU, LEAVE GRABAR_CCBCDOCU.
            END.
    
            FIND gn-provd WHERE gn-provd.CodCia = 0 AND
                gn-provd.CodPro = B-ADOCU.Libre_C[9] AND
                gn-provd.Sede   = B-ADOCU.Libre_C[20] AND
                CAN-FIND(FIRST gn-prov OF gn-provd NO-LOCK) NO-LOCK NO-ERROR.
            IF AVAILABLE gn-provd THEN DO:
                ASSIGN
                b-CcbCDocu.CodAge  = gn-provd.CodPro
                b-CcbCDocu.CodDpto = gn-provd.CodDept 
                b-CcbCDocu.CodProv = gn-provd.CodProv 
                b-CcbCDocu.CodDist = gn-provd.CodDist 
                b-CcbCDocu.LugEnt2 = gn-provd.DirPro.
            END.
        END.

        /* Detalle Items */
        FOR EACH t-ccbddocu WHERE t-ccbddocu.codcia = t-ccbcdocu.codcia AND t-ccbddocu.coddoc = t-ccbcdocu.coddoc AND
                                    t-ccbddocu.nrodoc = t-ccbcdocu.nrodoc NO-LOCK:
            CREATE b-ccbddocu.
            BUFFER-COPY t-ccbddocu TO b-ccbddocu NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pcRetVal = "ERROR AL ADD CCBDDOCU, ARTICULO : (" + t-ccbddocu.codmat + ") " + ERROR-STATUS:GET-MESSAGE(1).
                UNDO GRABAR_CCBCDOCU, LEAVE GRABAR_CCBCDOCU.
            END.

        END.
    END.
    /**/
    ASSIGN b-faccorre.correlativo = iCorrelativo.

    RELEASE b-faccorre NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcRetVal = "ERROR : release faccorre -> " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR_CCBCDOCU, LEAVE GRABAR_CCBCDOCU.
    END.
    RELEASE b-ccbcdocu NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcRetVal = "ERROR : release ccbcdocu -> " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR_CCBCDOCU, LEAVE GRABAR_CCBCDOCU.
    END.
    RELEASE b-ccbddocu NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcRetVal = "ERROR : release ccbddocu -> " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR_CCBCDOCU, LEAVE GRABAR_CCBCDOCU.
    END.
    RELEASE b-adocu NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcRetVal = "ERROR : release ccbAdocu -> " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR_CCBCDOCU, LEAVE GRABAR_CCBCDOCU.
    END.
    RELEASE fai-ccbcdocu NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcRetVal = "ERROR : release fai-ccbcdocu -> " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR_CCBCDOCU, LEAVE GRABAR_CCBCDOCU.
    END.
    /**/
    pcRetVal = "OK".
END.

IF pcRetVal = "OK" THEN RETURN "OK".

RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRE_CCBCDOCU_TEMPORAL) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRE_CCBCDOCU_TEMPORAL Procedure 
PROCEDURE GRE_CCBCDOCU_TEMPORAL :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pcRetval2 AS CHAR NO-UNDO.

DEFINE VAR cNumeroComprobante AS CHAR.
DEFINE VAR FILL-IN-LugEnt AS CHAR.
DEFINE VAR cCodDpto AS CHAR.
DEFINE VAR cCodProv AS CHAR.
DEFINE VAR cCodDist AS CHAR.
DEFINE VAR cCodPos AS CHAR.
DEFINE VAR cZona AS CHAR.
DEFINE VAR cSubZona AS CHAR.

cNumeroComprobante = STRING(b-gre_header.m_nroser,"999") + STRING(b-gre_header.m_nrodoc,"99999999").
IF b-gre_header.m_coddoc = 'FAI' THEN DO:
    cNumeroComprobante = STRING(b-gre_header.m_nroser,"999") + STRING(b-gre_header.m_nrodoc,"999999").
END.

FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = 1 AND x-ccbcdocu.coddoc = b-gre_header.m_coddoc AND
                            x-ccbcdocu.nrodoc = cNumeroComprobante NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-ccbcdocu THEN DO:
    pcRetVal2 = "El comprobante " + b-gre_header.m_coddoc + " " + cNumeroComprobante + " de la guia " + STRING(b-gre_header.serieGuia,"999") + STRING(b-gre_header.numeroGuia,"99999999") + ", No existe".
    RETURN "ADM-ERROR".
END.

/* O/D */
FIND FIRST faccpedi WHERE faccpedi.codcia = 1 AND faccpedi.coddoc = x-ccbcdocu.libre_c01 AND
                        faccpedi.nroped = x-ccbcdocu.libre_c02 NO-LOCK NO-ERROR.
/* RHC Cargamos TRANSPORTISTA por defecto */
EMPTY TEMP-TABLE T-CcbADocu.
IF AVAILABLE faccpedi THEN DO:
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
          pcRetVal2 = "ERROR en CCBADOCU, Datos del transportista " + STRING(b-gre_header.serieGuia,"999") + "-" + STRING(b-gre_header.numeroGuia,"99999999") + 
                          "   MSGERR:" + ERROR-STATUS:GET-MESSAGE(1).
          RETURN "ADM-ERROR".
      END.

      RELEASE T-CcbADocu.
    END.      
END.

/**/
IF AVAILABLE faccpedi THEN DO:
    RUN logis/p-lugar-de-entrega (INPUT Faccpedi.CodDoc,
                                  INPUT Faccpedi.NroPed,
                                  OUTPUT FILL-IN-LugEnt) NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pcRetVal2 = "ERROR al buscar el lugar de entrega " + STRING(b-gre_header.serieGuia,"999") + "-" + STRING(b-gre_header.numeroGuia,"99999999") + 
                        "   MSGERR:" + ERROR-STATUS:GET-MESSAGE(1).
        RETURN "ADM-ERROR".
    END.
    /**/
    RUN gn/fUbigeo (INPUT Faccpedi.CodDiv,
                    INPUT Faccpedi.CodDoc,
                    INPUT Faccpedi.NroPed,
                    OUTPUT cCodDpto,
                    OUTPUT cCodProv,
                    OUTPUT cCodDist,
                    OUTPUT cCodPos,
                    OUTPUT cZona,
                    OUTPUT cSubZona) NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pcRetVal2 = "ERROR al buscar el ubigeo " + STRING(b-gre_header.serieGuia,"999") + "-" + STRING(b-gre_header.numeroGuia,"99999999") + 
                        "   MSGERR:" + ERROR-STATUS:GET-MESSAGE(1).
        RETURN "ADM-ERROR".
    END.
END.

EMPTY TEMP-TABLE t-ccbcdocu.
EMPTY TEMP-TABLE t-ccbddocu.

/**/
DEFINE VAR iTotalItemsGRE AS INT.
DEFINE VAR iCuantasGRF AS INT.

DEFINE VAR iItems AS INT.
DEFINE VAR iGRFtempo AS INT.

/* Cuantos Items tiene la GRE */
FOR EACH gre_detail WHERE gre_detail.ncorrelativo = b-gre_header.ncorrelatio NO-LOCK :
    iTotalItemsGRE = iTotalItemsGRE + 1.
END.

/* Cuantas GRF se van a crear */
iCuantasGRF = TRUNCATE(iTotalItemsGRE / iItemsxGR,0).
IF (iTotalItemsGRE MODULO iTotalItemsGRE) > 0 THEN iCuantasGRF = iCuantasGRF + 1.

iItems = 1.
iGRFtempo = 0.
FOR EACH gre_detail WHERE gre_detail.ncorrelativo = b-gre_header.ncorrelatio NO-LOCK :
    IF iItems = 1 THEN DO:
        iGRFtempo = iGRFtempo + 1.
        CREATE t-ccbcdocu.
        BUFFER-COPY x-ccbCDOCU EXCEPT x-CcbCDocu.coddoc x-CcbCDocu.nrodoc TO t-CcbCDocu.
            ASSIGN
            t-CcbCDocu.CodDiv = b-gre_header.m_divorigen
            t-CcbCDocu.CodDoc = "G/R"
            t-CcbCDocu.NroDoc =  STRING(iGRFtempo,"999") + STRING(iGRFtempo,"99999999")
            t-CcbCDocu.FchDoc = TODAY
            t-CcbCDocu.CodRef = x-ccbCDOCU.CodDoc
            t-CcbCDocu.NroRef = x-ccbCDOCU.NroDoc
            t-CcbCDocu.FlgEst = "F"   /* FACTURADO */
            t-CcbCDocu.usuario = USERID("dictdb")
            t-CcbCDocu.TpoFac = "A"     /* AUTOMATICA (No descarga stock) */
            t-ccbcdocu.LugEnt = fill-in-Lugent
            t-CcbCDocu.CodDpto = cCodDpto
            t-CcbCDocu.CodProv = cCodProv
            t-CcbCDocu.CodDist = cCodDist NO-ERROR.

        IF ERROR-STATUS:ERROR = YES THEN DO:
            /**/
            pcRetval2 = "ERROR temporal CCBCDOCU: " + ERROR-STATUS:GET-MESSAGE(1).
            RETURN "ADM-ERROR".
        END.
    END.
    FIND FIRST x-ccbddocu WHERE x-ccbddocu.codcia = x-ccbcdocu.codcia AND x-ccbddocu.coddiv = x-ccbcdocu.coddiv AND
                                x-ccbddocu.coddoc = x-ccbcdocu.coddoc AND x-ccbddocu.nrodoc = x-ccbcdocu.nrodoc AND
                                x-ccbddocu.codmat = gre_detail.codmat NO-LOCK NO-ERROR.
    IF NOT AVAILABLE x-ccbddocu THEN NEXT.

        CREATE t-Ccbddocu.
        BUFFER-COPY x-ccbddocu EXCEPT x-CcbdDocu.coddoc x-CcbdDocu.nrodoc x-CcbDDocu.codmat x-CcbDDocu.NroItm TO t-Ccbddocu
            ASSIGN
                t-CcbDDocu.coddoc = t-CcbcDocu.coddoc
                t-CcbDDocu.nrodoc = t-CcbcDocu.nrodoc
                t-CcbDDocu.NroItm = iItems
                t-CcbDDocu.codmat = x-ccbddocu.CodMat NO-ERROR.

        IF ERROR-STATUS:ERROR = YES THEN DO:
            pcRetval2 = "ERROR temporal detaill " + b-gre_header.m_coddoc + " " + cNumeroComprobante + " Articulo " + x-ccbddocu.codmat + ERROR-STATUS:GET-MESSAGE(1).
            RETURN "ADM-ERROR".
        END.
        iItems = iItems + 1.

        /**/
        IF iItems > iItemsxGR THEN DO:
            iItems = 1.
        END.
    
    /*END.*/
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRE_Generacion_Pedido_S03) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRE_Generacion_Pedido_S03 Procedure 
PROCEDURE GRE_Generacion_Pedido_S03 :
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
        AND B-CPEDI.coddoc = b-Almcmov.codref
        AND B-CPEDI.nroped = b-Almcmov.nroref
        EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE B-CPEDI THEN DO:
        pMensaje = 'No se pudo bloquear la Orden de Transferencia ' + b-Almcmov.codref + " " + b-Almcmov.nroref.
        UNDO RLOOP, LEAVE RLOOP.
    END.
    FOR EACH b-almdmov OF b-almcmov NO-LOCK:
        FIND B-DPEDI OF B-CPEDI WHERE B-DPEDI.codmat = b-Almdmov.codmat
            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE B-DPEDI THEN DO:
            pMensaje = 'No se pudo bloquear el detalle de la Orden de Transferencia'.
            UNDO RLOOP, LEAVE RLOOP.
        END.
        ASSIGN
            B-DPEDI.CanAte = B-DPEDI.CanAte + b-Almdmov.candes.
    END.
    FIND FIRST B-DPEDI OF B-CPEDI WHERE B-DPEDI.CanPed > B-DPEDI.CanAte NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-DPEDI 
    THEN B-CPEDI.FlgEst = 'C'.     /* Atendido */
    ELSE B-CPEDI.FlgEst = 'P'.     /* Pendiente */

    ASSIGN B-CPEDI.FlgSit = 'C'.        /* Ic - 08May2023, Ruben y Max */

    /* RHC 08/07/2104 La G/R hereda el chequeo */
    ASSIGN
        b-Almcmov.Libre_c02 = 'C'
        b-Almcmov.Libre_c03 = B-CPEDI.usrchq + '|' + 
            STRING(B-CPEDI.fchchq, '99/99/9999') + '|' +
            STRING(B-CPEDI.horchq,'HH:MM:SS') + '|' +
            STRING(B-CPEDI.fecsac, '99/99/9999') + '|' + B-CPEDI.horsac.

    IF AVAILABLE(B-CPEDI) THEN RELEASE B-CPEDI NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "ERROR : release faccpedi -> " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO RLOOP, LEAVE RLOOP.
    END.

    IF AVAILABLE(B-DPEDI) THEN RELEASE B-DPEDI NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "ERROR : release faccpedi -> " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO RLOOP, LEAVE RLOOP.
    END.

    pRetVal = "OK".
END.

IF pRetVal = "OK" THEN RETURN "OK".

RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRE_NO_VTA_NO_OTR_grabar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRE_NO_VTA_NO_OTR_grabar Procedure 
PROCEDURE GRE_NO_VTA_NO_OTR_grabar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pcRetVal AS CHAR NO-UNDO.

DEFINE VAR iCorrelativo AS INT.

DEFINE VAR cCoddocTempo AS CHAR.
DEFINE VAR cNrodocTempo AS CHAR.

iCorrelativo = b-faccorre.correlativo.

FOR EACH t-ccbcdocu WHERE t-ccbcdocu.codcia = 1 :
    
    cCoddocTempo = t-ccbcdocu.coddoc.
    cNroDocTempo = t-ccbcdocu.nrodoc.

    FOR EACH t-ccbRdocu WHERE t-ccbRdocu.codcia = t-ccbcdocu.codcia AND t-ccbRdocu.coddoc = cCoddocTempo AND t-ccbRdocu.nrodoc = cNroDocTempo:
        ASSIGN t-ccbRdocu.nrodoc = string(pserieGRF,"999") + string(iCorrelativo,"999999").
    END.

    ASSIGN t-ccbcdocu.nrodoc = string(pserieGRF,"999") + string(iCorrelativo,"999999").

    iCorrelativo = iCorrelativo + 1.    
END.

pcRetVal = "PROCESANDO".

GRABAR_CCBCDOCU:
DO TRANSACTION ON ERROR UNDO GRABAR_CCBCDOCU, LEAVE ON STOP UNDO GRABAR_CCBCDOCU, LEAVE GRABAR_CCBCDOCU:
    FOR EACH t-ccbcdocu NO-LOCK:
        CREATE b-ccbcdocu.
        BUFFER-COPY t-ccbcdocu TO b-ccbcdocu NO-ERROR.

        IF ERROR-STATUS:ERROR THEN DO:
            pcRetVal = "ERROR AL ADD CCBCDOCU : " + ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABAR_CCBCDOCU, LEAVE GRABAR_CCBCDOCU.
        END.
        /**/
        /* Detalle Items */
        FOR EACH t-ccbRdocu WHERE t-ccbRdocu.codcia = t-ccbcdocu.codcia AND t-ccbRdocu.coddoc = t-ccbcdocu.coddoc AND
                                    t-ccbRdocu.nrodoc = t-ccbcdocu.nrodoc NO-LOCK:
            CREATE b-ccbRdocu.
            BUFFER-COPY t-ccbRdocu TO b-ccbRdocu NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pcRetVal = "ERROR AL ADD CCBrDOCU, ARTICULO : (" + t-ccbRdocu.codmat + ") " + ERROR-STATUS:GET-MESSAGE(1).
                UNDO GRABAR_CCBCDOCU, LEAVE GRABAR_CCBCDOCU.
            END.
        END.
    END.
    /**/
    ASSIGN b-faccorre.correlativo = iCorrelativo.

    RELEASE b-faccorre NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcRetVal = "ERROR : release faccorre -> " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR_CCBCDOCU, LEAVE GRABAR_CCBCDOCU.
    END.
    RELEASE b-ccbcdocu NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcRetVal = "ERROR : release ccbcdocu -> " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR_CCBCDOCU, LEAVE GRABAR_CCBCDOCU.
    END.
    RELEASE b-ccbRdocu NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcRetVal = "ERROR : release ccbRdocu -> " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR_CCBCDOCU, LEAVE GRABAR_CCBCDOCU.
    END.
    RELEASE b-adocu NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcRetVal = "ERROR : release ccbAdocu -> " + ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR_CCBCDOCU, LEAVE GRABAR_CCBCDOCU.
    END.
    /**/
    pcRetVal = "OK".
END.

IF pcRetVal = "OK" THEN RETURN "OK".

RETURN "ADM-ERROR".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRE_NO_VTA_NO_OTR_temporal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRE_NO_VTA_NO_OTR_temporal Procedure 
PROCEDURE GRE_NO_VTA_NO_OTR_temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pcRetval2 AS CHAR NO-UNDO.

DEFINE VAR cFiler AS CHAR.
DEFINE VAR iLlevarTraerMercaderia AS INT.

DEFINE VAR cPartidaCod AS CHAR.
DEFINE VAR cLlegadaCod AS CHAR.
DEFINE VAR cPartidaDir AS CHAR.
DEFINE VAR cLlegadaDir AS CHAR.
DEFINE VAR cCodPed AS CHAR.
DEFINE VAR cCodAge AS CHAR.
DEFINE VAR cCodAnt AS CHAR.

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

EMPTY TEMP-TABLE t-ccbcdocu.
EMPTY TEMP-TABLE t-ccbddocu.

/**/
DEFINE VAR iTotalItemsGRE AS INT.
DEFINE VAR iCuantasGRF AS INT.

DEFINE VAR iItems AS INT.
DEFINE VAR iGRFtempo AS INT.

/* Cuantos Items tiene la GRE */
FOR EACH gre_detail WHERE gre_detail.ncorrelativo = b-gre_header.ncorrelatio NO-LOCK :
    iTotalItemsGRE = iTotalItemsGRE + 1.
END.

/* Cuantas GRF se van a crear */
iCuantasGRF = TRUNCATE(iTotalItemsGRE / iItemsxGR,0).
IF (iTotalItemsGRE MODULO iTotalItemsGRE) > 0 THEN iCuantasGRF = iCuantasGRF + 1.

iItems = 1.
iGRFtempo = 0.
iItems = 1.
iGRFtempo = 0.
FOR EACH gre_detail WHERE gre_detail.ncorrelativo = b-gre_header.ncorrelatio NO-LOCK :
    IF iItems = 1 THEN DO:
        iGRFtempo = iGRFtempo + 1.
        CREATE t-ccbcdocu.
        ASSIGN t-ccbcdocu.codcia = 1
                t-ccbcdocu.tpoFac = 'I'
                t-ccbcdocu.coddoc = 'G/R'
                t-CcbCDocu.NroDoc =  STRING(iGRFtempo,"999") + STRING(iGRFtempo,"99999999")
                t-CcbCDocu.FchDoc = TODAY
                t-CcbCDocu.usuario = USERID("dictdb")
                t-CcbCDocu.horcie = STRING(TIME,"hh:mm:ss")
                t-CcbCDocu.codped = cCodped
                t-CcbCDocu.CodAlm = cPartidaCod
                t-CcbCDocu.dircli = cPartidaDir
                t-CcbCDocu.CodAnt = cCodAnt
                t-CcbCDocu.CodCli = cLlegadaCod
                t-CcbCDocu.RucCli = cLlegadaCod     /* RUC ?????? */
                t-CcbCDocu.LugEnt2 = cLlegadaDir
                t-CcbCDocu.CodAge = cCodAge
                t-CcbCDocu.Glosa = gre_header.observaciones NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            /**/
            pcRetval2 = "ERROR temporal T-CCBCDOCU: " + ERROR-STATUS:GET-MESSAGE(1).
            RETURN "ADM-ERROR".
        END.
    END.
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND almmmatg.codmat = gre_detail.codmat NO-LOCK NO-ERROR.
    CREATE t-ccbrdocu.
        ASSIGN t-ccbrdocu.codcia = s-codcia
                t-ccbrdocu.coddoc = t-ccbcdocu.coddoc
                t-ccbrdocu.nrodoc = t-ccbcdocu.nrodoc
                t-CcbRDocu.NroItm = iItems 
                t-ccbrdocu.CodMat = gre_detail.codmat
                t-ccbrdocu.DesMat = IF (AVAILABLE almmmatg) THEN almmmatg.desmat ELSE "<ERROR NO EXISTE>"
                t-ccbrdocu.DesMar = IF (AVAILABLE almmmatg) THEN almmmatg.desmar ELSE "<ERROR NO EXISTE>"
                t-ccbrdocu.CanDes = gre_detail.candes
                t-ccbrdocu.UndVta = gre_detail.codund NO-ERROR.

      IF ERROR-STATUS:ERROR = YES THEN DO:
          pcRetval2 = "ERROR al adicionar articulo " + gre_detail.codmat + " a t-ccbrdocu --->Guia : " + 
              STRING(b-gre_header.serieGuia,"999") + "-" + STRING(b-gre_header.numeroGuia,"99999999") + " : " + ERROR-STATUS:GET-MESSAGE(1).
          RETURN "ADM-ERROR".
      END.

    /* */
    iItems = iItems + 1.
    
    /**/
    IF iItems > iItemsxGR THEN DO:
      iItems = 1.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-items-segun-formato) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE items-segun-formato Procedure 
PROCEDURE items-segun-formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pxDivision AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pxTipoGR AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pCantidadItems AS INT NO-UNDO.

DEFINE VAR iItem AS INT.

pCantidadItems = -99.

FIND FIRST factabla WHERE factabla.codcia = 1 AND factabla.tabla = 'CFG_FMT_GR' AND factabla.codigo = pxDivision NO-LOCK NO-ERROR.
IF AVAILABLE factabla THEN DO:
    IF pxTipoGR = "VTA" THEN DO:
        iItem = INTEGER(TRIM(factabla.campo-c[1])) NO-ERROR.        
    END.
    ELSE DO:        
        iItem = INTEGER(TRIM(factabla.campo-c[2])) NO-ERROR.
    END.
    IF iItem = ? THEN iItem = 0.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

