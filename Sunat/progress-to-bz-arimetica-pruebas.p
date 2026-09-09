&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.



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
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR T-FELogErrores.
DEFINE OUTPUT PARAMETER pCodError AS CHAR NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pOtros AS CHAR NO-UNDO .

DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-codcia AS INT.

DEF BUFFER B-CDOCU FOR Ccbcdocu.  
DEFINE BUFFER w-ccbcdocu FOR Ccbcdocu.
DEFINE BUFFER b-ccbdcaja FOR ccbdcaja.

FIND FIRST B-CDOCU WHERE B-CDOCU.codcia = s-codcia AND 
                        B-CDOCU.coddiv = pCodDiv AND 
                        B-CDOCU.coddoc = pCodDoc AND
                        B-CDOCU.nrodoc = pNroDoc  
                        NO-LOCK NO-ERROR.   
    
IF NOT AVAILABLE B-CDOCU THEN DO:
    pCodError = "Documento (" + pCodDoc + "-" + pNroDoc + ") NO EXISTE **".
    RETURN "ADM-ERROR".
END.

IF LOOKUP(B-CDOCU.CodDoc, 'FAC,BOL,N/C,N/D') = 0 THEN RETURN "OK".

IF B-CDOCU.flgest = 'A' THEN DO:
    pCodError = "Documento (" + pCodDoc + "-" + pNroDoc + ") esta ANULADO".
    RETURN "ADM-ERROR".
END.

/* ??????????????????????????? */
/* BLOQUEADO PARA SISTEMAS */
/*IF s-user-id = 'ADMIN' THEN RETURN "OK". */

DEF SHARED VAR s-nomcia AS CHAR.
/*IF s-nomcia BEGINS 'PRUEBA' THEN RETURN "OK".*/

/* ********************************************* */
/* Inicio de actividades facturación electrónica */
/* ********************************************* */
/* DEF VAR pStatus AS LOG.                                                               */
/* RUN sunat\p-inicio-actividades (INPUT B-CDOCU.fchdoc, OUTPUT pStatus).                */
/* IF pStatus = NO THEN RETURN "OK".       /* Todavía no han iniciado las actividades */ */
/* ********************************************* */

DEF VAR cIP_ePos AS CHAR.    /* IP del servicio de BIZLINKS */
DEF VAR pTipo  AS CHAR.     /* MOSTRADOR CREDITO */
DEF VAR pCodTer AS CHAR.    /* SOLO PARA MOSTRADOR */

ASSIGN
    pTipo   = B-CDOCU.Tipo
    pCodTer = B-CDOCU.CodCaja.

DEF VAR s-Sunat-Activo AS LOG INIT NO NO-UNDO.
FIND gn-divi WHERE GN-DIVI.CodCia = B-CDOCU.CodCia
    AND GN-DIVI.CodDiv = B-CDOCU.CodDiv NO-LOCK NO-ERROR.
IF AVAILABLE gn-divi THEN s-Sunat-Activo = gn-divi.campo-log[10].

DEFINE VAR x-vvta-gravada AS DEC INIT 0 FORMAT '->>,>>>,>>9.9999'.
DEFINE VAR x-vvta-inafectas AS DEC INIT 0 FORMAT '->>,>>>,>>9.9999'.
DEFINE VAR x-vvta-exoneradas AS DEC INIT 0 FORMAT '->>,>>>,>>9.9999'.
DEFINE VAR x-vvta-gratuitas AS DEC INIT 0 FORMAT '->>,>>>,>>9.9999'.
DEFINE VAR x-total-igv AS DEC INIT 0 FORMAT '->>,>>>,>>9.9999'.               /* Total Impuestos */
DEFINE VAR x-total-igv2 AS DEC INIT 0 FORMAT '->>,>>>,>>9.9999'.              /* IGV */
DEFINE VAR x-imp-isc AS DEC INIT 0 FORMAT '->>,>>>,>>9.9999'.
DEFINE VAR x-imp-total AS DEC INIT 0 FORMAT '->>,>>>,>>9.9999'.

DEFINE VAR x-tipo-docmnto-sunat AS CHAR INIT "".
DEFINE VAR x-tipoDocumentoAdquiriente AS CHAR INIT "".
DEFINE VAR x-numeroDocumentoAdquiriente AS CHAR INIT "".
/* Caso de N/C, N/D */
DEFINE VAR x-tipoDocumentoReferenciaPrincipal AS CHAR INIT "".
DEFINE VAR x-numeroDocumentoReferenciaPrincipal AS CHAR INIT "".

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
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 5.54
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VAR cCodHash AS CHAR.
DEFINE VAR cNumDocumento AS CHAR.
DEFINE VAR cDataQR AS CHAR.
DEFINE VAR iFlagPPLL AS INT.

DEFINE VAR x-puntero-de-totales AS INT.

/* Ic - 18Jun2018, codigo de establecimiento */
DEFINE BUFFER xy-gn-divi FOR gn-divi.
DEFINE VAR x-codestable AS CHAR INIT "".

FIND FIRST xy-gn-divi WHERE xy-gn-divi.codcia = s-codcia AND 
                            xy-gn-divi.coddiv = B-CDOCU.CodDiv NO-LOCK NO-ERROR.
IF AVAILABLE xy-gn-divi THEN DO:
    /* Codigo de establecimiento */
    x-codestable = xy-gn-divi.campo-char[10]. 
END.
/* Indica que es Nulo o esta Vacio*/
IF (TRUE <> (x-codestable > "")) THEN DO:
    pCodError = "ERROR la division (" + B-CDOCU.CodDiv + ") no tiene asignado codigo de establecimiento"  + CHR(10) +
        "Salir del Sistema, volver a entrar y repetir el proceso".
    RETURN "ADM-ERROR".
END.

DEFINE VAR cRetVal AS CHAR NO-UNDO.

ENVIO_BIZLINKS:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* **************************************************************************** */
    /* RHC 12/03/2019 Rutina que genera un registro de ventas FORMATO BIZLINKS */
    /* **************************************************************************** */
    DEF VAR x-Otros AS CHAR NO-UNDO.
    x-Otros = ''.

    /* **************************************************************************** */
    /* 2do. Generamos el XML en el e-Pos */
    /* Generacion de Documento, TipoDocumnto, NroDocumnto, Division y Valor de Retorno */
    /* **************************************************************************** */
    cRetVal = "".
    RUN sunat/facturacion-electronica-bz-arimetica-pruebas.r(INPUT B-CDOCU.CodDoc, 
                                            INPUT B-CDOCU.NroDoc, 
                                            INPUT B-CDOCU.CodDiv,  
                                            OUTPUT cRetVal,
                                            INPUT-OUTPUT pOtros).  
    /* ************************************************* */
    IF cRetVal = "PLAN-B" THEN RETURN "PLAN-B".
    /* ************************************************* */
    IF pOtros BEGINS "XML" THEN DO:
        /* Solo generacion XML */
        pCodError = cRetVal.
        RETURN "OK". 
    END.

    /* RetVal = NNN|xxxxxxxxxxxxxxxx|hhhhaaaasssssshhhh */
    /* Si los 3 primeros digitos del cRetVal = "000", generacion OK y trae el HASHHHHHH */
    IF SUBSTRING(cRetVal,1,3) <> "000" OR cRetVal = ? THEN DO:

        /* Error en el XML */        
        pCodError = "ERROR envío " + cRetVal.

        /* *************** LOG DE ERRORES **************** */
        RUN Log-Error.
        /* *********************************************** */
        RETURN "ADM-ERROR". 
    END.    

    ASSIGN 
        /*iEstadoPPLL = INTEGER(ENTRY(1,cRetVal,'|')) NO-ERROR.*/
    cCodHash = ''.
    IF NUM-ENTRIES(cRetVal,'|') >= 3 THEN cCodHash = ENTRY(3,cRetVal,'|').

    /* Ic - 17Oct2017 - Datos QR */
    IF B-CDOCU.CodDoc = 'N/C' OR B-CDOCU.CodDoc = 'N/D' THEN DO:
        IF NUM-ENTRIES(cRetVal,'|') >= 4 THEN cNumDocumento = ENTRY(4,cRetVal,'|').
        IF NUM-ENTRIES(cRetVal,'|') >= 5 THEN cDataQR = ENTRY(5,cRetVal,'|').
        x-puntero-de-totales = 6.
    END.
    ELSE DO:
        IF NUM-ENTRIES(cRetVal,'|') >= 4 THEN cDataQR = ENTRY(4,cRetVal,'|').
        x-puntero-de-totales = 5.
    END.
    cDataQR = REPLACE(cDataQR,"@","|").

    /* Totales y datos adicionales*/
    IF NUM-ENTRIES(cRetVal,'|') >= x-puntero-de-totales THEN DO:
        x-vvta-gravada = DEC(ENTRY(x-puntero-de-totales,cRetVal,"|")).
        x-vvta-inafectas = DEC(ENTRY(x-puntero-de-totales + 1,cRetVal,"|")).
        x-vvta-exoneradas = DEC(ENTRY(x-puntero-de-totales + 2,cRetVal,"|")).
        x-vvta-gratuitas = DEC(ENTRY(x-puntero-de-totales + 3,cRetVal,"|")).
        x-total-igv = DEC(ENTRY(x-puntero-de-totales + 4,cRetVal,"|")).
        x-total-igv2 = DEC(ENTRY(x-puntero-de-totales + 5,cRetVal,"|")).
        x-imp-isc = DEC(ENTRY(x-puntero-de-totales + 6,cRetVal,"|")).
        x-imp-total = DEC(ENTRY(x-puntero-de-totales + 7,cRetVal,"|")).
        x-tipo-docmnto-sunat = ENTRY(x-puntero-de-totales + 8,cRetVal,"|").
        x-tipoDocumentoAdquiriente = ENTRY(x-puntero-de-totales + 9,cRetVal,"|").
        x-numeroDocumentoAdquiriente = ENTRY(x-puntero-de-totales + 10,cRetVal,"|").
        x-tipoDocumentoReferenciaPrincipal = ENTRY(x-puntero-de-totales + 11,cRetVal,"|").
        x-numeroDocumentoReferenciaPrincipal = ENTRY(x-puntero-de-totales + 12,cRetVal,"|").
    END.

    IF TRUE <> (cCodHash > '') THEN DO:        
        /* Guardamos el error pero grabamos el documento por ahora */
        pCodError = "ERROR envío código de Hash en blanco." + CHR(10) + cRetVal.
        /* *************** LOG DE ERRORES **************** */
        RUN Log-Error.
        /* *********************************************** */
        RETURN "ADM-ERROR".
    END.
    
    /* **************************************************************************** */
    /* **************************************************************************** */
    /* 3ro. GRABAMOS REGISTRO DE CONTROL EN EL FELOGCOMPROBANTES */
    /* **************************************************************************** */
    /* **************************************************************************** */
    
    RUN NEW-LOG  ("OK").
    
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        iFlagPPLL = 666.    /* Beast's number */
        /* *************** LOG DE ERRORES **************** */
        RUN Log-Error.
        /* *********************************************** */
        pCodError = "ERROR : Nose pudo grabar en el FELOGCOMPROBANTES".
        /*
        IF AVAILABLE(FELogComprobantes) THEN RELEASE FELogComprobantes.
        IF AVAILABLE(w-ccbcdocu) THEN RELEASE w-ccbcdocu NO-ERROR.
        IF AVAILABLE(b-ccbdcaja) THEN RELEASE b-ccbdcaja NO-ERROR.
        */
        RETURN "ERROR-EPOS".    /* CON ESTO PODEMOS MARCAR EL COMPROBANTE COMO ANULADO */
         
    END.          
    pCodError = "".
END.

/* Borramos de la memoria las rutinas antes cargadas */
IF AVAILABLE(FELogComprobantes) THEN RELEASE FELogComprobantes.
IF AVAILABLE(w-ccbcdocu) THEN RELEASE w-ccbcdocu NO-ERROR.
IF AVAILABLE(b-ccbdcaja) THEN RELEASE b-ccbdcaja NO-ERROR.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-log-error) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE log-error Procedure 
PROCEDURE log-error :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* IP de la PC */
DEFINE VAR x-ip AS CHAR.
DEFINE VAR x-pc AS CHAR.

RUN lib/_get_ip.r(OUTPUT x-pc, OUTPUT x-ip).

/* -- */
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


CREATE T-FELogErrores.
ASSIGN
    T-FELogErrores.CodCia = B-CDOCU.codcia
    T-FELogErrores.CodDiv = B-CDOCU.coddiv
    T-FELogErrores.CodDoc = B-CDOCU.coddoc
    T-FELogErrores.NroDoc = B-CDOCU.nrodoc
    T-FELogErrores.CodHash = cCodHash
    T-FELogErrores.ErrorDate = NOW
    T-FELogErrores.EstadoPPLL = 0
    T-FELogErrores.FlagPPLL = (IF SUBSTRING(cRetVal,1,3) = "000" THEN 1 ELSE iFlagPPLL)
    T-FELogErrores.ID_Pos = ""
    T-FELogErrores.IP_ePos = ""
    T-FELogErrores.LogDate = NOW
    T-FELogErrores.LogEstado = pCodError      /*cRetVal*/
    T-FELogErrores.LogUser = s-user-id
    T-FELogErrores.NumDocumento = cNumDocumento    
    T-FELogErrores.campo-c[1] = TRIM(lPCName) + "-" + TRIM(x-pc) + ":" + TRIM(x-ip)
    NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-new-log) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE new-log Procedure 
PROCEDURE new-log :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCaso AS CHAR.

/* 
    Autorizado por Juan Hermoza, contador de CONTINENTAL SAC
    22 Agosto 2021 - Actualizar CCBCDOCU.IMPTOTAL desde el XML
*/

IF B-CDOCU.imptot <> x-imp-total THEN DO:
    FIND FIRST w-ccbcdocu WHERE w-ccbcdocu.codcia = B-CDOCU.codcia AND 
                                w-ccbcdocu.coddoc = B-CDOCU.coddoc AND
                                w-ccbcdocu.nrodoc = B-CDOCU.nrodoc EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE w-ccbcdocu THEN DO:
        /* Cuando se envia a TESTING desde el servidor PRODUCTIVO esto NO VA 
        ASSIGN B-CDOCU.imptot = x-imp-total
            */
                /*B-CDOCU.sdoact = x-imp-total*/.       /* Para casos venta al CONTADO MOSTRADOR no iria */
    END.    

    /* Ic - 28Set2021, para pedidos de mostrador tambien actualizar el I/C detalle */
    IF B-CDOCU.codped = 'P/M' AND B-CDOCU.tipo = "MOSTRADOR" THEN DO:
        FIND FIRST b-ccbdcaja WHERE b-ccbdcaja.codcia = B-CDOCU.codcia AND
                                        b-ccbdcaja.codref = B-CDOCU.coddoc AND
                                        b-ccbdcaja.nroref = B-CDOCU.nrodoc EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE b-ccbdcaja THEN DO:
            /* Cuando se envia a TESTING desde el servidor PRODUCTIVO esto NO VA 
            ASSIGN b-ccbdcaja.imptot = x-imp-total.
            */
        END.        
    END.
END.

/* pCaso: ERROR forzar grabar agregando un "X" al final del número  YA NO SE USA
          OK debería grabar normalmente 
          */

DEF VAR cNroDoc LIKE B-CDOCU.NroDoc NO-UNDO.

cNroDoc = B-CDOCU.nrodoc.
IF pCaso = "ERROR" THEN cNroDoc = TRIM(cNroDoc) + "X".
FIND FIRST FELogComprobantes WHERE FELogComprobantes.CodCia = B-CDOCU.codcia
    AND FELogComprobantes.CodDiv = B-CDOCU.coddiv
    AND FELogComprobantes.CodDoc = B-CDOCU.coddoc
    AND FELogComprobantes.NroDoc = cNroDoc
    NO-LOCK NO-ERROR.
CASE pCaso:
    WHEN "OK" THEN DO:
        /* NO duplicados */
        IF AVAILABLE FELogComprobantes THEN DO:
            pCodError = "Duplicado comprobante en FELogComprobantes: " + B-CDOCU.coddoc + ' ' + cNroDoc.
            RETURN 'ADM-ERROR'.
        END.
    END.
    WHEN "ERROR" THEN DO:
        IF AVAILABLE FELogComprobantes THEN RETURN 'OK'.
    END.
END CASE.

/* IP de la PC */
DEFINE VAR x-ip AS CHAR.
DEFINE VAR x-pc AS CHAR.

RUN lib/_get_ip.r(OUTPUT x-pc, OUTPUT x-ip).

x-pc = IF(x-pc = ?) THEN "" ELSE TRIM(x-pc).
x-ip = IF(x-ip = ?) THEN "" ELSE TRIM(x-ip).

CREATE FELogComprobantes.
ASSIGN
    FELogComprobantes.CodCia = B-CDOCU.codcia
    FELogComprobantes.CodDiv = B-CDOCU.coddiv
    FELogComprobantes.CodDoc = B-CDOCU.coddoc
    FELogComprobantes.NroDoc = cNroDoc
    FELogComprobantes.LogDate = NOW
    FELogComprobantes.LogEstado = cRetVal
    FELogComprobantes.LogUser   = B-CDOCU.usuario
    FELogComprobantes.FlagPPLL   = (IF SUBSTRING(cRetVal,1,3) = "000" THEN 1 ELSE iFlagPPLL)
    FELogComprobantes.EstadoPPLL = 0
    FELogComprobantes.CodHash      = cCodHash
    FELogComprobantes.NumDocumento = cNumDocumento
    FELogComprobantes.IP_ePos = cIP_ePos
    FELogComprobantes.ID_Pos  = "BIZLINKS"
    FELogComprobantes.DataQR  = cDataQR
    FELogComprobantes.campo-c[1]  = x-pc + ":" + x-ip
    FELogComprobantes.vvtagravada = x-vvta-gravada
    FELogComprobantes.vvtainafecta = x-vvta-inafectas
    FELogComprobantes.vvtaexonerada = x-vvta-exoneradas
    FELogComprobantes.vvtagratuitas = x-vvta-gratuitas
    FELogComprobantes.totalimpuestos = x-total-igv
    FELogComprobantes.totaligv = x-total-igv2
    FELogComprobantes.imptetotal = x-imp-total
    FELogComprobantes.totalisc = x-imp-isc
    FELogComprobantes.tipodocsunat = x-tipo-docmnto-sunat
    FELogComprobantes.tipodocadq = x-tipoDocumentoAdquiriente
    FELogComprobantes.nrodocadq = x-numeroDocumentoAdquiriente
    FELogComprobantes.tipodocrefpri = x-tipoDocumentoReferenciaPrincipal
    FELogComprobantes.nrodocrefpri = x-numeroDocumentoReferenciaPrincipal
    NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
    pCodError = "Duplicado comprobante en FELogComprobantes: " + B-CDOCU.coddoc + ' ' + B-CDOCU.nrodoc.
    DELETE FELogComprobantes NO-ERROR.
    RETURN 'ADM-ERROR'.
END.


RETURN 'OK'.

END PROCEDURE.

/*



        DEFINE VAR x-tipo-docmnto-sunat AS CHAR INIT "".
        DEFINE VAR x-tipoDocumentoAdquiriente AS CHAR INIT "".
        DEFINE VAR x-numeroDocumentoAdquiriente AS CHAR INIT "".
        /* Caso de N/C, N/D */
        DEFINE VAR x-tipoDocumentoReferenciaPrincipal AS CHAR INIT "".
        DEFINE VAR x-numeroDocumentoReferenciaPrincipal AS CHAR INIT "".

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

