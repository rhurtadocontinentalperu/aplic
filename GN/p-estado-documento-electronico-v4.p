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

DEFINE TEMP-TABLE tTagsEstadoDoc
    FIELD   cTag    AS  CHAR    FORMAT 'x(100)'
    FIELD   cValue  AS  CHAR    FORMAT 'x(255)'.

DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.         /* puede venir vacio */
DEFINE OUTPUT PARAMETER pStatusSunat AS CHAR.
DEFINE OUTPUT PARAMETER pEstado AS CHAR.
DEFINE OUTPUT PARAMETER pMessageSunat AS CHAR.
DEFINE OUTPUT PARAMETER pTextoQR AS CHAR.


/*
DEFINE INPUT PARAMETER pContenido AS CHAR.      /*  */
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
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 73.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */


pStatusSunat = '999'.
pEstado = "TIPO DE DOCUMENTO ERRADO(" + pCodDoc + ")".
IF LOOKUP(pCodDoc,"FAC,BOL,N/C,N/D,G/R") > 0 THEN DO:

    IF LOOKUP(pCodDoc,"FAC,BOL,N/C,N/D") > 0 THEN DO:
        /* Verificar si el documento fue enviado a BIZLINKS */
        
        FIND FIRST felogcomprobantes WHERE felogcomprobantes.codcia = 1 AND
                                                felogcomprobantes.coddoc = pCodDoc AND
                                                felogcomprobantes.nrodoc = pNroDoc NO-LOCK NO-ERROR.
        IF NOT AVAILABLE felogcomprobantes THEN DO:
            pEstado = "DOCUMENTO NO FUE ENVIADO A SUNAT".
            RETURN.
        END.
        
    END.

    RUN gn/p-estado-documento-electronico-v3.r(INPUT pCodDoc,
                        INPUT pNroDoc,
                        INPUT pCoddiv,
                        INPUT "ESTADO DOCUMENTO",
                        INPUT-OUTPUT TABLE tTagsEstadoDoc).
    /*
    FIND FIRST tTagsEstadoDoc NO-LOCK NO-ERROR.
    IF NOT AVAILABLE tTagsEstadoDoc THEN DO:
        pEstado = "DOCUMENTO NO SE ENCUENTRA EN SUNAT".
        RETURN.
    END.
    */
    pEstado = "DOCUMENTO NO SE ENCUENTRA EN SUNAT".
    FIND FIRST tTagsEstadoDoc WHERE tTagsEstadoDoc.cTag = "messageSunat" NO-LOCK NO-ERROR.
    IF AVAILABLE tTagsEstadoDoc THEN DO:
        pMessageSunat = tTagsEstadoDoc.cValue.
    END.
    
    FIND FIRST tTagsEstadoDoc WHERE tTagsEstadoDoc.cTag = "statusSunat" NO-LOCK NO-ERROR.
    IF AVAILABLE tTagsEstadoDoc THEN  DO:
        pStatusSunat = tTagsEstadoDoc.cValue.
        IF tTagsEstadoDoc.cValue = "AN_04" THEN pEstado = "BAJA EN SUNAT".
        IF tTagsEstadoDoc.cValue = "ED_06" THEN pEstado = "ENVIADO A SUNAT".
        IF tTagsEstadoDoc.cValue = "PE_09" THEN pEstado = "PENDIENTE DE ENVIO A SUNAT".
        IF tTagsEstadoDoc.cValue = "PE_02" THEN pEstado = "ESPERANDO RESPUESTA DE SUNAT".
    
        IF LOOKUP(tTagsEstadoDoc.cValue,"RC_05,AC_03,ERROR") > 0 THEN DO:
            pEstado = "ACEPTADO POR SUNAT".
            IF tTagsEstadoDoc.cValue = "AC_03" THEN pEstado = "ACEPTADO POR SUNAT".
            IF tTagsEstadoDoc.cValue = "RC_05" OR tTagsEstadoDoc.cValue = "ERROR" THEN DO:
                pEstado = "RECHAZADO POR SUNAT".
                /* Fue rechazado */
                FIND FIRST tTagsEstadoDoc WHERE tTagsEstadoDoc.cTag = "messageSunat" NO-LOCK NO-ERROR.
                IF AVAILABLE tTagsEstadoDoc THEN DO:
                    pMessageSunat = tTagsEstadoDoc.cValue.
                END.
            END.
            /* Grabar el QR */
            pTextoQR = "".
            IF pEstado = "ACEPTADO POR SUNAT" THEN DO:
                RUN get-textoQR(OUTPUT pTextoQR).                
            END.
        END.
    END.
    ELSE DO:
        FIND FIRST tTagsEstadoDoc WHERE tTagsEstadoDoc.cTag = "status" NO-LOCK NO-ERROR.        
        IF AVAILABLE tTagsEstadoDoc THEN  DO:
            pEstado = tTagsEstadoDoc.cValue.
            IF tTagsEstadoDoc.cValue = "MISSING" THEN pEstado = "DOCUMENTO NO EXISTE EN SUNAT".
        END.

    END.
    
    pMessageSunat = CODEPAGE-CONVERT(pMessageSunat, SESSION:CHARSET, "utf-8").

END.

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


IF pCodDoc <> 'G/R' THEN DO:
    /* Comprobantes que no es guia de remision se envia la URL del pdf */
    FIND FIRST tTagsEstadoDoc WHERE tTagsEstadoDoc.cTag = 'pdfFileUrl' NO-LOCK NO-ERROR.
    IF AVAILABLE tTagsEstadoDoc THEN DO:
        pcTextoQR = TRIM( tTagsEstadoDoc.cValue).
    END.
END.
ELSE DO:
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

