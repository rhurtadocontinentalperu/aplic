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

DEFINE INPUT PARAMETER pcCoddiv AS CHAR.
DEFINE INPUT PARAMETER pcCoddoc AS CHAR.
DEFINE INPUT PARAMETER pcNroDoc AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER pcDatosExtras AS CHAR.
DEFINE OUTPUT PARAMETER pcRetVal AS CHAR.

DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR s-codalm AS CHAR.
DEFINE SHARED VAR s-codcia AS INT.

DEFINE BUFFER b-gre_cmpte FOR gre_cmpte.
DEFINE BUFFER b-gre_header FOR gre_header.
DEFINE BUFFER b-gre_detail FOR gre_detail.
DEFINE BUFFER x-gn-clie FOR gn-clie.
DEFINE BUFFER b-gre_doc_relacionado FOR gre_doc_relacionado.

DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER b-ccbddocu FOR ccbddocu.

DEFINE VAR cSaltoLinea AS CHAR.

cSaltoLinea = CHR(13) + CHR(10).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-f-get-utf8) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-get-utf8 Procedure 
FUNCTION f-get-utf8 RETURNS CHARACTER
  ( INPUT pString AS CHAR )  FORWARD.

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

FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND
                            b-ccbcdocu.coddoc = pcCoddoc AND
                            b-ccbcdocu.nrodoc = pcNroDoc NO-LOCK NO-ERROR.

IF NOT AVAILABLE b-ccbcdocu THEN DO:
    pcRetVal = "NO EXISTE COMPROBANTE".
    RETURN "ADM-ERROR".
END.    
IF b-ccbcdocu.flgest = 'A' THEN DO:
    pcRetVal = "COMPROBANTE ESTA ANULADO".
    RETURN "ADM-ERROR".
END.

DEFINE VAR iCorrelativo AS INT.

RUN gre/correlativo-gre.r(OUTPUT iCorrelativo).

IF RETURN-VALUE = "ADM-ERROR" THEN DO:
    pcRetVal = "PROBLEMAS AL CREAR EL CORRELATIVO DE PRE-GRE".
    RETURN "ADM-ERROR".
END.
    
/* Datos del destinatario */
DEFINE VAR x-nom-cli AS CHAR.
DEFINE VAR x-dir-cli AS CHAR.
DEFINE VAR x-ruc-cli AS CHAR.
DEFINE VAR x-tipo-ide AS CHAR.

DEFINE VAR cNumeroDocRel AS CHAR.

x-Ruc-Cli = IF (b-ccbcdocu.ruccli = ?) THEN "" ELSE TRIM(b-ccbcdocu.ruccli).
x-Nom-Cli = IF (b-ccbcdocu.nomcli = ?) THEN "" ELSE TRIM(b-ccbcdocu.nomcli).
x-Dir-Cli = IF (b-ccbcdocu.dircli = ?) THEN "" ELSE b-ccbcdocu.dircli.
x-Tipo-Ide = '6'.

x-Nom-Cli = f-get-utf8(x-Nom-Cli).  /* UTF-8 */
x-Dir-Cli = f-get-utf8(x-Dir-Cli).

IF x-Ruc-Cli = "" THEN DO:
    /* DNI */
    x-Ruc-Cli = IF (b-ccbcdocu.codant = ?) THEN "" ELSE TRIM(b-ccbcdocu.codant).
    /* BUscamos error */
    DEF VAR i-Ruc-Cli AS INT NO-UNDO.
    ASSIGN
        i-Ruc-Cli = INTEGER(x-Ruc-Cli) NO-ERROR.

    /*IF ERROR-STATUS:ERROR = YES THEN x-Ruc-Cli = ''.  Se anula x C.E que son Alfanumericos */

    x-Tipo-Ide = '1'.
    /*IF x-Ruc-Cli = "" OR INTEGER(x-Ruc-Cli) = 0 OR x-Ruc-Cli BEGINS "11111" THEN DO:*/
    IF x-Ruc-Cli = "" OR x-Ruc-Cli BEGINS "11111" THEN DO:
        /* Si Ruc o DNI es generico */
        x-Ruc-Cli = '0'.    /* DOC.TRIB.NO.DOM.SIN.RUC */
        x-Tipo-Ide = '0'.
    END.
    ELSE DO:
        FIND FIRST x-gn-clie WHERE x-gn-clie.codcia = 0 AND x-gn-clie.codcli = b-ccbcdocu.codcli NO-LOCK NO-ERROR.

        IF AVAILABLE x-gn-clie AND x-gn-clie.libre_c01 = 'E' THEN DO:
            /* Carnet de Extranjero */
            x-Ruc-Cli = x-Ruc-Cli.            
            x-Tipo-Ide = '4'.
        END.
        ELSE DO:
            /* 8 Digitos de DNI */
            x-Ruc-Cli = "00000000" + x-Ruc-Cli.            
            x-Ruc-Cli = SUBSTRING(x-Ruc-Cli, (LENGTH(x-Ruc-Cli) - 8) + 1).
        END.
    END.
END.
ELSE DO:
    IF LENGTH(x-Ruc-Cli) = 11 AND SUBSTRING(x-Ruc-Cli,1,3) = '000' THEN DO:
        /* ES DNI */
        x-Tipo-Ide = '1'.
        x-Ruc-Cli = SUBSTRING(x-Ruc-Cli,4).
        x-Ruc-Cli = "00000000" + x-Ruc-Cli.            
        x-Ruc-Cli = SUBSTRING(x-Ruc-Cli, (LENGTH(x-Ruc-Cli) - 8) + 1).
    END.
    ELSE DO:
        IF x-Ruc-Cli BEGINS "11111" THEN DO:
            x-Ruc-Cli = '0'.
            x-Tipo-Ide = '0'.
        END.
    END.
END.

IF x-Nom-Cli = "" THEN x-Nom-Cli = "-".

DEFINE VAR cPuntoOrigen AS CHAR.
DEFINE VAR cUbigeoOrigen AS CHAR.
DEFINE VAR cDireccionOrigen AS CHAR.
DEFINE VAR dPeso AS DEC.
DEFINE VAR iBultos AS DEC.
DEFINE VAR rRowId AS ROWID.

/*FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = b-ccbcdocu.coddiv NO-LOCK NO-ERROR.  X las reprogramaciones  */
FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.   
IF AVAILABLE gn-divi THEN DO:
    cPuntoOrigen = gn-divi.campo-char[10].
    cUbigeoOrigen = gn-divi.campo-char[3] + gn-divi.campo-char[4] + gn-divi.campo-char[5].
    cDireccionOrigen = gn-divi.dirdiv.   
END.

DEFINE VAR cMotivoTraslado AS CHAR.
DEFINE VAR cDescripcioMotivoTraslado AS CHAR.
DEFINE VAR cUbigeoPtoLlegada AS CHAR.
DEFINE VAR cCodigoPtoLlegada AS CHAR.
DEFINE VAR cDireccionPtoLlegada AS CHAR.
DEFINE VAR iTrasbordoProgramado AS INT.

DEFINE VAR cSerieNumeroCmpte AS CHAR.

DEFINE VAR cSede AS CHAR.

cMotivoTraslado = "01". /* Ventas */
iTrasbordoProgramado = 0.

FIND FIRST sunat_fact_electr_detail WHERE sunat_fact_electr_detail.catalogue = 20 AND
                                    sunat_fact_electr_detail.CODE = cMotivoTraslado NO-LOCK NO-ERROR.
IF AVAILABLE sunat_fact_electr_detail THEN DO:
    cDescripcioMotivoTraslado = sunat_fact_electr_detail.DESCRIPTION.
END.

/* Sede del cliente */
cDireccionPtoLlegada = b-ccbcdocu.dircli.
cSede = b-ccbcdocu.sede.
FIND FIRST gn-clieD WHERE gn-clieD.codcia = 0 AND gn-clieD.codcli = b-ccbcdocu.codcli AND
                            gn-clieD.sede = b-ccbcdocu.sede NO-LOCK NO-ERROR.
IF AVAILABLE gn-clieD THEN DO:
    cUbigeoPtoLlegada = TRIM(gn-clieD.coddept) + TRIM(gn-clieD.codprov) + TRIM(gn-clieD.coddis).
    cDireccionPtoLlegada = TRIM(gn-clieD.dirCli).
END.                       

/* 
    Punto de llegada :  - Sede del cliente
                        - Agencia de transporte
*/
/*

/* 
    Ic - 22Dic2023, Susana Leon, Juan Hermoza, Alejando Morales indicaron que la direccion del pto de llegada sea
    la del cliente, se le hara firmar un documento al cliente esto coordinado con don Pablo
 */

FIND FIRST ccbadocu WHERE ccbadocu.codcia = s-codcia AND
                            ccbadocu.coddiv = b-ccbcdocu.divori AND
                            ccbadocu.coddoc = b-ccbcdocu.libre_c01 AND  /* O/D */
                            ccbadocu.nrodoc = b-ccbcdocu.libre_c02 NO-LOCK NO-ERROR.


IF AVAILABLE ccbadocu AND NOT (TRUE <> (ccbadocu.libre_c[20] > ""))  THEN DO:
    /* Agencia de transporte y tiene SEDE */
    cDireccionPtoLlegada = ccbadocu.libre_c[12].
    cSede = ccbadocu.libre_c[20].
    iTrasbordoProgramado = 1.

    /* Buscar el ubigeo de la sede del proveedor */
    FIND FIRST gn-provD WHERE gn-provD.codcia = 0 AND gn-provD.codpro = ccbadocu.libre_c[9]
                                AND gn-provD.sede = ccbadocu.libre_c[20] NO-LOCK NO-ERROR.
    IF AVAILABLE gn-provD THEN DO:
        cUbigeoPtoLlegada = TRIM(gn-provD.coddept) + TRIM(gn-provD.codprov) + TRIM(gn-provD.coddis).
    END.                           
END.
ELSE DO:
    /* Sede del cliente */
    cDireccionPtoLlegada = b-ccbcdocu.dircli.
    cSede = b-ccbcdocu.sede.
    FIND FIRST gn-clieD WHERE gn-clieD.codcia = 0 AND gn-clieD.codcli = b-ccbcdocu.codcli AND
                                gn-clieD.sede = b-ccbcdocu.sede NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clieD THEN DO:
        cUbigeoPtoLlegada = TRIM(gn-clieD.coddept) + TRIM(gn-clieD.codprov) + TRIM(gn-clieD.coddis).
        cDireccionPtoLlegada = TRIM(gn-clieD.dirCli).
    END.                       
END
*/

/* Bultos */
iBultos = 0.
FOR EACH ccbcbult WHERE ccbcbult.codcia = s-codcia AND
                        ccbcbult.coddoc = b-ccbcdocu.libre_c01 AND  /* O/D */
                        ccbcbult.nrodoc = b-ccbcdocu.libre_c02 NO-LOCK:
    iBultos = iBultos + ccbcbult.bultos.
END.

cSerieNumeroCmpte = b-ccbcdocu.nrodoc.

pcRetVal = "OK".

GRABAR_DATA:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
            /* Header update block */
        CREATE b-gre_header.
        ASSIGN b-gre_header.ncorrelatio = iCorrelativo
                b-gre_header.m_tipmov = 'S'
                b-gre_header.m_codmov = b-ccbcdocu.codmov
                b-gre_header.correoRemitente = "-"
                b-gre_header.correoDestinatario = "-"
                b-gre_header.tipoDocumentoGuia = "09"
                b-gre_header.fechaEmisionGuia = TODAY
                b-gre_header.horaEmisionGuia = STRING(TIME,"hh:mm:ss")                
                b-gre_header.motivoTraslado = cMotivoTraslado
                b-gre_header.descripcionMotivoTraslado = cDescripcioMotivoTraslado
                b-gre_header.numeroBultos = iBultos
                /* Datos del remitente */
                b-gre_header.tipoDocumentoRemitente = '6'
                b-gre_header.numeroDocumentoRemitente = '20100038146'
                b-gre_header.razonSocialRemitente = 'Continental SAC'
                b-gre_header.numeroDocumentoEstablecimiento = b-gre_header.numeroDocumentoRemitente
                b-gre_header.tipoDocumentoEstablecimiento = b-gre_header.tipoDocumentoRemitente
                b-gre_header.razonSocialEstablecimiento = b-gre_header.razonSocialRemitente
                /* Datos del destinatario */
                b-gre_header.numeroDocumentoDestinatario = x-ruc-cli
                b-gre_header.tipoDocumentoDestinatario = x-Tipo-Ide
                b-gre_header.razonSocialDestinatario = x-Nom-Cli
                /* Otros */
                b-gre_header.m_tpomov = 'GRVTA'
                b-gre_header.m_rspta_sunat = "SIN ENVIAR"
                b-gre_header.m_usuario = USERID("DICTDB")
                b-gre_header.m_codalm = s-codalm /* b-ccbcdocu.codalm - Para la reprogramaciones*/
                b-gre_header.m_codalmdes = ""
                b-gre_header.m_cliente = b-ccbcdocu.codcli
                b-gre_header.m_proveedor = ""
                b-gre_header.m_sede = cSede
                b-gre_header.m_coddoc = b-ccbcdocu.coddoc
                b-gre_header.m_nroser = int(substring(b-ccbcdocu.nrodoc,1,3))
                b-gre_header.m_nrodoc = int(substring(b-ccbcdocu.nrodoc,4))           
                b-gre_header.m_divorigen = s-coddiv     /*b-ccbcdocu.coddiv - X las reprogramaciones */
                b-gre_header.m_divdestino = ""
                /* */
                b-gre_header.codigoPtoPartida = cPuntoOrigen
                b-gre_header.ubigeoPtoPartida = cUbigeoOrigen
                b-gre_header.direccionPtoPartida = cDireccionOrigen
                /* */
                b-gre_header.ubigeoPtoLlegada = cUbigeoPtoLlegada
                b-gre_header.codigoPtoLlegada = ""
                b-gre_header.direccionPtoLlegada = cDireccionPtoLlegada
                b-gre_header.observaciones = "(" + SUBSTRING(b-ccbcdocu.coddoc,1,1) + substring(b-ccbcdocu.nrodoc,1,3) + 
                            "-" + substring(b-ccbcdocu.nrodoc,4) + ") " + b-ccbcdocu.glosa
                /**/
                b-gre_header.indTransbordoProgramado = iTrasbordoProgramado NO-ERROR.
             
        IF ERROR-STATUS:ERROR THEN DO:
            pcRetVal = "Problemas al crear registro en gre_header" + cSaltoLinea + 
                        ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABAR_DATA, RETURN 'ADM-ERROR'.
        END.

        /* Documentos relacionados */
        IF b-ccbcdocu.coddoc <> 'FAI' THEN DO:
            cNumeroDocRel = IF(b-ccbcdocu.coddoc='FAC') THEN "F" ELSE "B".
            cNumeroDocRel = cNumeroDocRel + SUBSTRING(b-ccbcdocu.nrodoc,1,3) + "-" + SUBSTRING(b-ccbcdocu.nrodoc,4).
            CREATE b-gre_doc_relacionado.
                ASSIGN b-gre_doc_relacionado.ncorrelativo = iCorrelativo
                        b-gre_doc_relacionado.indicador = 'R'
                        b-gre_doc_relacionado.ordenDocRel = 1
                        b-gre_doc_relacionado.tipoDocumentoDocRel = IF(b-ccbcdocu.coddoc='FAC') THEN "FACTURA" ELSE "BOLETA DE VENTA"
                        b-gre_doc_relacionado.codigoDocumentoDocRel = IF(b-ccbcdocu.coddoc='FAC') THEN "01" ELSE "03"
                        b-gre_doc_relacionado.numeroDocumentoDocRel = cNumeroDocRel                    
                        b-gre_doc_relacionado.numeroDocumentoEmisorDocRel = b-gre_header.numeroDocumentoRemitente
                        b-gre_doc_relacionado.tipoDocumentoEmisorDocRel = b-gre_header.tipoDocumentoRemitente 
                        b-gre_doc_relacionado.userCrea = USERID("DICTDB") NO-ERROR
                    .
           IF ERROR-STATUS:ERROR THEN DO:
               pcRetVal = "Problemas al crear registro en gre_doc_relacionado" + cSaltoLinea + 
                           ERROR-STATUS:GET-MESSAGE(1).
               UNDO GRABAR_DATA, RETURN 'ADM-ERROR'.
           END.
        END.
         
    dPeso = 0.
    FOR EACH b-ccbddocu OF b-ccbcdocu NO-LOCK: 
        dPeso = dPeso + b-ccbddocu.pesmat.
        CREATE b-gre_detail.
       ASSIGN b-gre_detail.ncorrelativo = b-gre_header.ncorrelatio
           b-gre_detail.nroitm = b-ccbddocu.nroitm
           b-gre_detail.codmat = b-ccbddocu.codmat
           b-gre_detail.candes = b-ccbddocu.candes
           b-gre_detail.codund = b-ccbddocu.undvta
           b-gre_detail.factor = b-ccbddocu.factor
           b-gre_detail.peso_unitario = b-ccbddocu.pesmat / (b-ccbddocu.candes * b-ccbddocu.factor)
           b-gre_detail.peso_total_item = b-ccbddocu.pesmat NO-ERROR.           
       IF ERROR-STATUS:ERROR THEN DO:
           pcRetVal = "Problemas al crear registro en gre_detail - articulo (" + b-ccbddocu.codmat + ")" + cSaltoLinea + 
                       ERROR-STATUS:GET-MESSAGE(1).
           UNDO GRABAR_DATA, RETURN 'ADM-ERROR'.
       END.

    END.
    ASSIGN b-gre_header.pesoBrutoTotalBienes = dPeso
            b-gre_header.unidadMedidaPesoBruto = "KGM" NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcRetVal = "Problemas en gre_header al asignar el peso total y la unidad de medida KGM" + cSaltoLinea + 
                    ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR_DATA, RETURN 'ADM-ERROR'.
    END.

    RELEASE b-gre_header NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcRetVal = "ERROR en RELEASE b-gre_header " + cSaltoLinea + 
                    ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR_DATA, RETURN 'ADM-ERROR'.
    END.

    RELEASE b-gre_detail NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcRetVal = "ERROR en RELEASE b-gre_detail " + cSaltoLinea + 
                    ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR_DATA, RETURN 'ADM-ERROR'.
    END.

    RELEASE b-gre_doc_relacionado NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pcRetVal = "ERROR en RELEASE b-gre_doc_relacionado " + cSaltoLinea + 
                    ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABAR_DATA, RETURN 'ADM-ERROR'.
    END.

END. /* TRANSACTION block */

pcRetVal = "OK".

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-f-get-utf8) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-get-utf8 Procedure 
FUNCTION f-get-utf8 RETURNS CHARACTER
  ( INPUT pString AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VAR lRetVal AS CHAR.
DEF VAR x-dice AS CHAR NO-UNDO.
DEF VAR x-debedecir AS CHAR NO-UNDO.

/* UTF-8 */
x-dice = TRIM(pString).
RUN lib\limpiar-texto(x-dice,'',OUTPUT x-debedecir).
lRetVal = CODEPAGE-CONVERT(x-debedecir, "utf-8", SESSION:CHARSET).
lRetVal = REPLACE(x-debedecir,"´","'").
lRetVal = REPLACE(x-debedecir,"á","a").
lRetVal = REPLACE(x-debedecir,"é","e").
lRetVal = REPLACE(x-debedecir,"í","i").
lRetVal = REPLACE(x-debedecir,"ó","o").
lRetVal = REPLACE(x-debedecir,"ú","u").
lRetVal = REPLACE(x-debedecir,"Á","A").
lRetVal = REPLACE(x-debedecir,"É","E").
lRetVal = REPLACE(x-debedecir,"Í","I").
lRetVal = REPLACE(x-debedecir,"Ó","O").
lRetVal = REPLACE(x-debedecir,"Ú","U").
lRetVal = REPLACE(x-debedecir,"ü","u").
lRetVal = REPLACE(x-debedecir,"Ü","U").
lRetVal = REPLACE(x-debedecir,"ü","u").
lRetVal = REPLACE(x-debedecir,"º"," ").
lRetVal = REPLACE(x-debedecir,"´","'").
lRetVal = REPLACE(x-debedecir,"Ø"," ").
lRetVal = REPLACE(x-debedecir,"º"," ").
lRetVal = REPLACE(x-debedecir,"ª"," ").
lRetVal = REPLACE(x-debedecir,"º"," ").
lRetVal = REPLACE(x-debedecir,"º"," ").

RETURN lRetVal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

