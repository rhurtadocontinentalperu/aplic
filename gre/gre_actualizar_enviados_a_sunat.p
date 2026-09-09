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


 DEFINE TEMP-TABLE gre_header_disponibles LIKE gre_header
     FIELD rRowID AS ROWID.

 DEFINE TEMP-TABLE tTagsEstadoDoc
    FIELD   cTag    AS  CHAR    FORMAT 'x(100)' 
    FIELD   cValue  AS  CHAR    FORMAT 'x(255)'.

DEFINE STREAM sFileTxt.
define stream log-epos.     /* Trama del ePOS */

DEFINE NEW SHARED VAR s-codcia AS INT INIT 1.

DEFINE BUFFER b-gre_cmpte FOR gre_cmpte.

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

DEFINE VAR iGuias AS INT.
DEFINE VAR cFiler AS CHAR.

EMPTY TEMP-TABLE gre_header_disponibles.

FOR EACH gre_header WHERE gre_header.m_rspta_sunat = 'ENVIADO A SUNAT' /*AND
                     gre_header.m_divorigen = s-coddiv */ NO-LOCK:
    CREATE gre_header_disponibles.
    BUFFER-COPY gre_header TO gre_header_disponibles.
    ASSIGN gre_header_disponibles.rRowId = ROWID(gre_header).
    iGuias = iGuias + 1.
END.

FOR EACH gre_header WHERE gre_header.m_rspta_sunat = 'ESPERANDO RESPUESTA SUNAT' NO-LOCK:
    CREATE gre_header_disponibles.
    BUFFER-COPY gre_header TO gre_header_disponibles.
    ASSIGN gre_header_disponibles.rRowId = ROWID(gre_header).
    iGuias = iGuias + 1.
END.

cFiler = fwrite_log("Cantidad de guias  NO VENTAS esperando respuesta ---> " + STRING(iGUias)).

DEFINE VAR cCodDoc AS CHAR.
DEFINE VAR cNroDoc AS CHAR.
DEFINE VAR cMotivoRechazo AS CHAR.

DEFINE VAR cCodEstado AS CHAR.
DEFINE VAR cDesEstado AS CHAR.
DEFINE VAR ctextoQR AS CHAR.

FOR EACH gre_header_disponibles NO-LOCK:

    cCodDoc = "G/R".
    cNroDoc = STRING(gre_header_disponibles.serieGuia,"999") + STRING(gre_header_disponibles.numeroGuia,"99999999").
    cMotivoRechazo = "".
    EMPTY TEMP-TABLE tTagsEstadoDoc.

    cFiler = fwrite_log("Guia --->: " + cNroDoc).

    RUN gn/p-estado-documento-electronico-v3.r(INPUT cCodDoc,
                        INPUT cNroDoc,
                        INPUT "",
                        INPUT "ESTADO DOCUMENTO",
                        INPUT-OUTPUT TABLE tTagsEstadoDoc) NO-ERROR NO-WAIT.

    IF ERROR-STATUS:ERROR THEN DO:
        cFiler = fwrite_log("Guia : " + cNroDoc + " ERROR:" + ERROR-STATUS:GET-MESSAGE(1) ).
        /*RETURN "ADM-ERROR".*/
        NEXT.
    END.
    
    FIND FIRST tTagsEstadoDoc WHERE tTagsEstadoDoc.cTag = "messageSunat" NO-LOCK NO-ERROR.
    IF AVAILABLE tTagsEstadoDoc THEN cMotivoRechazo = tTagsEstadoDoc.cValue.
    
    FIND FIRST tTagsEstadoDoc WHERE tTagsEstadoDoc.cTag = "statusSunat" NO-LOCK NO-ERROR.
    IF AVAILABLE tTagsEstadoDoc THEN DO:

        cCodEstado = tTagsEstadoDoc.cValue.

        cFiler = fwrite_log("Guia : " + cNroDoc + "...." + cCodEstado).

        GRABAR:
        DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
            IF LOOKUP(tTagsEstadoDoc.cValue,"RC_05,AC_03,ERROR") > 0 THEN DO:
                cDesEstado = "ACEPTADO POR SUNAT".
                IF tTagsEstadoDoc.cValue = "RC_05" OR tTagsEstadoDoc.cValue = "ERROR" THEN DO:
                    cDesEstado = "RECHAZADO POR SUNAT".
                    /* Fue rechazado */
                    FIND FIRST tTagsEstadoDoc WHERE tTagsEstadoDoc.cTag = "messageSunat" NO-LOCK NO-ERROR.
                    IF AVAILABLE tTagsEstadoDoc THEN DO:
                        cMotivoRechazo = tTagsEstadoDoc.cValue.
                    END.
                END.
                /* Grabar el QR */
                ctextoQR = "".
                IF cDesEstado = "ACEPTADO POR SUNAT" THEN DO:
                    FIND FIRST gre_header_qr WHERE gre_header_qr.ncorrelativo = gre_header_disponibles.ncorrelatio NO-LOCK NO-ERROR NO-WAIT.
                    IF NOT AVAILABLE gre_header_qr THEN DO:
                        RUN get-textoQR(OUTPUT ctextoQR).                
                    END.                
                END.
    
                /* Actualizo */
                FIND FIRST gre_header WHERE ROWID(gre_header) = gre_header_disponibles.rRowid EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                IF AVAILABLE gre_header THEN DO:
                    ASSIGN gre_header.m_rspta_sunat = CAPS(cDesEstado)
                            gre_header.m_motivo_de_rechazo = cMotivoRechazo.                    
                    IF ERROR-STATUS:ERROR THEN DO:
                        cFiler = fwrite_log("1.- Guia : " + cNroDoc + " ERROR:" + ERROR-STATUS:GET-MESSAGE(1)).
                        RELEASE gre_header NO-ERROR.
                        UNDO grabar, LEAVE grabar.
                    END.
                    /* QR */
                    IF ctextoQR <> "" THEN DO:
                        FIND FIRST gre_header_qr WHERE gre_header_qr.ncorrelativo = gre_header_disponibles.ncorrelatio EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                        IF LOCKED gre_header_qr THEN DO:
                            cFiler = fwrite_log("1.- Guia : " + cNroDoc + " ERROR:" + ERROR-STATUS:GET-MESSAGE(1) ).
                            RELEASE gre_header_qr.
                            UNDO grabar, LEAVE grabar.
                        END.
                        IF NOT AVAILABLE gre_header_qr THEN DO:
                            CREATE gre_header_qr.
                                ASSIGN gre_header_qr.ncorrelativo = gre_header_disponibles.ncorrelatio
                                        gre_header_qr.USER_crea = USERID("dictdb").
                        END.
                        ASSIGN gre_header_qr.data_QR = ctextoQR.
                    END.
                END.
    
                RELEASE gre_header NO-ERROR.
                IF ERROR-STATUS:ERROR THEN DO:
                    cFiler = fwrite_log("X1.- Guia : " + cNroDoc + " ERROR:" + ERROR-STATUS:GET-MESSAGE(1) ).
                    UNDO grabar, LEAVE grabar.
                END.
                RELEASE gre_header_qr NO-ERROR.
                IF ERROR-STATUS:ERROR THEN DO:
                    cFiler = fwrite_log("X2.- Guia : " + cNroDoc + " ERROR:" + ERROR-STATUS:GET-MESSAGE(1) ).
                    UNDO grabar, LEAVE grabar.
                END.
            END.
            ELSE DO:
                FIND FIRST gre_header WHERE ROWID(gre_header) = gre_header_disponibles.rRowid EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                IF AVAILABLE gre_header THEN DO:
                    ASSIGN /*gre_header.m_estado_bizlinks = CAPS(cCodEstado)*/
                            gre_header.m_motivo_de_rechazo = cMotivoRechazo.
                    RELEASE gre_header NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN DO:
                        cFiler = fwrite_log("2.- Guia : " + cNroDoc + " ERROR:" + ERROR-STATUS:GET-MESSAGE(1) ).
                        UNDO grabar, LEAVE grabar.
                    END.
    
                END.
            END.
        END.    /* END Transaction */
    END.
    ELSE DO:
        cFiler = fwrite_log("Guia : " + cNroDoc + " no ubico statusSunat").
    END.
END.

cFiler = fwrite_log("Cantidad de guias NO VENTAS esperando respuesta " + STRING(iGUias)) + " - FIN".

/*
/* Comprobantes x VENTAS */
cFiler = fwrite_log("COMPROBANTES x VENTA - INICIO").

DEFINE VAR cEstadoBizLinks AS CHAR.
DEFINE VAR cEstadoSunat AS CHAR.
DEFINE VAR cEstadoDocumento AS CHAR.
DEFINE VAR cMensajeSunat AS CHAR.

FOR EACH gre_cmpte WHERE gre_cmpte.estado = 'CMPTE GENERADO' NO-LOCK:
    IF TRUE <> (gre_cmpte.estado_sunat > "") OR
        LOOKUP(gre_cmpte.estado_sunat,"Aceptado por sunat, Rechazado por sunat") = 0 THEN DO:

        cEstadoDocumento = "".

        EMPTY TEMP-TABLE tTagsEstadoDoc.

        RUN gn/p-estado-documento-electronico-v3.r(INPUT gre_cmpte.coddoc,
                            INPUT gre_cmpte.Nrodoc,
                            INPUT "",
                            INPUT "ESTADO DOCUMENTO",
                            INPUT-OUTPUT TABLE tTagsEstadoDoc) NO-ERROR.

        FIND FIRST tTagsEstadoDoc WHERE tTagsEstadoDoc.cTag = "statusSunat" NO-LOCK NO-ERROR.
        IF AVAILABLE tTagsEstadoDoc THEN cEstadoSunat = tTagsEstadoDoc.cValue.

        FIND FIRST tTagsEstadoDoc WHERE tTagsEstadoDoc.cTag = "messageSunat" NO-LOCK NO-ERROR.
        IF AVAILABLE tTagsEstadoDoc THEN cMensajeSunat = tTagsEstadoDoc.cValue.

        cFiler = fwrite_log("A.- COMPROBANTE VENTA " + gre_cmpte.coddoc + " " + gre_cmpte.Nrodoc + " estado :" + cEstadoDocumento ).
        /*IF LOOKUP(cEstadoSunat,"RC_05,AC_03") > 0 THEN DO:*/
        IF LOOKUP(cEstadoSunat,"RC_05,AC_03,ERROR") > 0 THEN DO:
            cEstadoDocumento = "ACEPTADO POR SUNAT".
            IF cEstadoSunat <> "AC_03" THEN cEstadoDocumento = "RECHAZADO POR SUNAT".
        END.
        ELSE DO:
            cEstadoDocumento = gre_cmpte.estado_sunat.
        END.

        FIND FIRST b-gre_cmpte WHERE ROWID(b-gre_cmpte) = ROWID(gre_cmpte) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF LOCKED(b-gre_cmpte) THEN DO:
            cFiler = fwrite_log("B.- COMPROBANTE VENTA " + gre_cmpte.coddoc + " " + gre_cmpte.Nrodoc + " esta bloqueado" ).
            RELEASE b-gre_cmpte NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                cFiler = fwrite_log("3.- Guia : " + cNroDoc + " ERROR:" + ERROR-STATUS:GET-MESSAGE(1) ).
                RETURN "ADM-ERROR".
            END.
        END.
        ELSE DO:
            IF AVAILABLE b-gre_cmpte THEN DO:
                ASSIGN b-gre_cmpte.estado_sunat = cEstadoDocumento.
                RELEASE b-gre_cmpte  NO-ERROR.
                IF ERROR-STATUS:ERROR THEN DO:
                    cFiler = fwrite_log("4.- Guia : " + cNroDoc + " ERROR:" + ERROR-STATUS:GET-MESSAGE(1) ).
                    RETURN "ADM-ERROR".
                END.
            END.
            ELSE DO:
                cFiler = fwrite_log("COMPROBANTE VENTA " + gre_cmpte.coddoc + " " + gre_cmpte.Nrodoc + " NO EXISTE????" ).
            END.
        END.
    END.
END.

RELEASE b-gre_cmpte NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
    cFiler = fwrite_log("9.- Guia : " + cNroDoc + " ERROR:" + ERROR-STATUS:GET-MESSAGE(1) ).
    RETURN "ADM-ERROR".
END.


cFiler = fwrite_log("COMPROBANTES x VENTAS - FIN").
*/

cFiler = fwrite_log("*-----------------------------------------------------------------------------------------------").

QUIT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-get-textoQR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-textoQR Procedure 
PROCEDURE get-textoQR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pcTextoQR AS CHAR NO-UNDO.

DEFINE VAR v-result AS CHAR.
DEFINE VAR v-response AS LONGCHAR.
DEFINE VAR v-content AS LONGCHAR.
DEFINE VAR cTagInicial AS CHAR.
DEFINE VAR cTagFinal AS CHAR.
DEFINE VAR cTexto AS LONGCHAR.

DEFINE VAR curlCDR AS CHAR.

pcTextoQR = "".

/* Tag del link del CDR : xmlFileSunatUrl */
FIND FIRST tTagsEstadoDoc WHERE tTagsEstadoDoc.cTag = 'xmlFileSunatUrl' NO-LOCK NO-ERROR.
IF AVAILABLE tTagsEstadoDoc THEN DO:
    
    curlCDR = TRIM( tTagsEstadoDoc.cValue).    

    RUN lib\http-get-contenido.p(cUrlCDR,output v-result,output v-response,output v-content).
                    
    IF v-result = "1:Success"  THEN DO:
        /* Sacar el el texto para generar el QR */

        cTagInicial = "<cac:DocumentReference>".
        cTagFinal = "</cac:DocumentReference>".

        RUN getValueTag(v-content,cTagInicial,cTagFinal, OUTPUT cTexto).

        IF NOT (TRUE <> (cTexto > "")) THEN DO:
            cTagInicial = "<cbc:DocumentDescription>".
            cTagFinal = "</cbc:DocumentDescription>".

            RUN getValueTAG(cTexto,cTagInicial,cTagFinal, OUTPUT pcTextoQR).            
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getValueTag) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValueTag Procedure 
PROCEDURE getValueTag :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pContent AS LONGCHAR.
    DEFINE INPUT PARAMETER pTagInicial AS CHAR.
    DEFINE INPUT PARAMETER ptagFinal AS CHAR.
    DEFINE OUTPUT PARAMETER pRetVal AS LONGCHAR.

    DEFINE VAR iPosInicial AS INT.
    DEFINE VAR iPosFinal AS INT.

    pRetVal = "".

    iPosInicial = INDEX(pContent,pTagInicial).
    IF iPosInicial > 0 THEN DO:
        iPosFinal = INDEX(pContent,pTagFinal).
        IF iPosFinal > 0 THEN DO:
            pRetVal = SUBSTRING(pContent,iPosInicial + LENGTH(pTagInicial),(iPosFinal - (iPosInicial + LENGTH(pTagInicial))) ).
        END.
        ELSE DO:
            pRetVal = SUBSTRING(pContent,iPosInicial + LENGTH(pTagInicial) ).
        END.

        pRetVal = TRIM(pRetVal).

        IF pRetVal = ? THEN pRetVal = "".
    END.


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

FIND FIRST x-factabla WHERE x-factabla.codcia = 1
                            and x-factabla.tabla = 'TXTLOGEPOS'
                            and x-factabla.codigo = 'ALL'
                            NO-LOCK NO-ERROR.

IF AVAILABLE x-factabla AND x-factabla.campo-l[1] = YES THEN DO:
    DEFINE VAR x-archivo AS CHAR.
    DEFINE VAR x-file AS CHAR.
    DEFINE VAR x-linea AS CHAR.

    x-file = STRING(TODAY,"99/99/9999").
    /*x-file = x-file + "-" + STRING(TIME,"HH:MM:SS").*/

    x-file = REPLACE(x-file,"/","").
    x-file = REPLACE(x-file,":","").

    x-archivo = session:TEMP-DIRECTORY + "LOG-estados-SUNAT-" + x-file + ".txt".

    OUTPUT STREAM log-epos TO VALUE(x-archivo) APPEND.

    x-linea = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"hh:mm:ss") + " (" + lPCName + "-" + x-pc + ":" + x-ip + ") - " + TRIM(pTexto).

    PUT STREAM log-epos x-linea FORMAT 'x(300)' SKIP.

    OUTPUT STREAM LOG-epos CLOSE.
END.


RETURN "".  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

