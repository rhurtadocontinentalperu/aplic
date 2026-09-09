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

DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-codcia AS INT.

DEF BUFFER B-CDOCU FOR Ccbcdocu.

FIND B-CDOCU WHERE B-CDOCU.codcia = s-codcia AND 
                        B-CDOCU.coddiv = pCodDiv AND 
                        B-CDOCU.coddoc = pCodDoc AND
                        B-CDOCU.nrodoc = pNroDoc
                        NO-LOCK NO-ERROR.

IF NOT AVAILABLE B-CDOCU THEN DO:
    MESSAGE "Documento (" + pCodDoc + "-" + pNroDoc + ") NO EXISTE".
    RETURN "ADM-ERROR".
END.

IF LOOKUP(B-CDOCU.CodDoc, 'FAC,BOL,N/C,N/D') = 0 THEN RETURN "OK".

IF B-CDOCU.flgest = 'A' THEN DO:
    MESSAGE "Documento (" + pCodDoc + "-" + pNroDoc + ") esta ANULADO".
    RETURN "ADM-ERROR".
END.

/* ********************************** */
/* RHC 03/01/2018 Certificado digital */   
/* ********************************** */
/* IF TODAY = DATE(01,04,2019) THEN DO:                            */
/*     IF STRING(TIME, 'HH:MM:SS') <= '16:00:00' THEN RETURN 'OK'. */
/* END.                                                            */
/* ********************************** */


/* ??????????????????????????? */
/* BLOQUEADO PARA SISTEMAS */
IF s-user-id = 'ADMIN' THEN RETURN "OK".
DEF SHARED VAR s-nomcia AS CHAR.
IF s-nomcia BEGINS 'PRUEBA' THEN RETURN "OK".

/* ********************************************* */
/* Inicio de actividades facturación electrónica */
/* ********************************************* */
/* DEF VAR pStatus AS LOG.                                                               */
/* RUN sunat\p-inicio-actividades (INPUT B-CDOCU.fchdoc, OUTPUT pStatus).                */
/* IF pStatus = NO THEN RETURN "OK".       /* Todavía no han iniciado las actividades */ */
/* ********************************************* */

DEF VAR pID_Pos AS CHAR NO-UNDO.
DEF VAR pTipo  AS CHAR.     /* MOSTRADOR CREDITO */
DEF VAR pCodTer AS CHAR.    /* SOLO PARA MOSTRADOR */

ASSIGN
    pTipo   = B-CDOCU.Tipo
    pCodTer = B-CDOCU.CodCaja.

DEF VAR s-Sunat-Activo AS LOG INIT NO NO-UNDO.
FIND gn-divi WHERE GN-DIVI.CodCia = B-CDOCU.CodCia
    AND GN-DIVI.CodDiv = B-CDOCU.CodDiv NO-LOCK NO-ERROR.
IF AVAILABLE gn-divi THEN s-Sunat-Activo = gn-divi.campo-log[10].

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
         HEIGHT             = 6.23
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/** ***************************  Main Block  *************************** */
DEF VAR cFilled AS CHAR NO-UNDO.
DEF VAR ix AS INT NO-UNDO.
DEFINE VAR hProc AS HANDLE NO-UNDO.
DEFINE VAR cRetVal AS CHAR.
DEFINE VAR cCodHash AS CHAR NO-UNDO.
DEFINE VAR iEstadoPPLL AS INT NO-UNDO.
DEFINE VAR cIP_ePos AS CHAR NO-UNDO.
DEFINE VAR cID_caja  AS CHAR NO-UNDO.
DEFINE VAR cNumDocumento AS CHAR NO-UNDO.
DEFINE VAR iFlagPPLL AS INT NO-UNDO.

DEFINE VAR cDataQR AS CHAR.

DEFINE SHARED VAR hSocket AS HANDLE NO-UNDO.

/* Levantamos las rutinas a memoria Version 2 */
RUN sunat\facturacion-electronicav2.p PERSISTENT SET hProc NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pCodError = "ERROR en las librerias de la Facturación Electrónica" + CHR(10) +
        "Salir del Sistema, volver a entrar y repetir el proceso".
    RETURN "ADM-ERROR".
END.

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
if TRUE <> (x-codestable > "") THEN DO:
    pCodError = "ERROR la division (" + B-CDOCU.CodDiv + ") no tiene asignado codigo de establecimiento"  + CHR(10) +
        "Salir del Sistema, volver a entrar y repetir el proceso".

    RELEASE xy-gn-divi.

    RETURN "ADM-ERROR".
END.

RELEASE xy-gn-divi.


IF VALID-HANDLE(hSocket) THEN DELETE OBJECT hSocket.
CREATE SOCKET hSocket.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* **************************************************************************** */
    /* 1ro. Nos conectamos al e-Pos */
    /* Si devuelve 000|xxxxxxxxxxx la coneción está OK */
    /* **************************************************************************** */
    RUN pconecto-epos IN hProc (INPUT B-CDOCU.CodDiv, 
                                 INPUT B-CDOCU.CodCaja,
                                 OUTPUT cRetVal).
    IF SUBSTRING(cRetVal,1,3) <> "000" THEN DO:
        iFlagPPLL = 0.  
        /* NO se pudo conectar */
        /* Borramos de la memoria las rutinas antes cargadas */
        cFilled = DYNAMIC-FUNCTION('fdesconectar-epos':U IN  hProc).
        DELETE OBJECT hSocket.
        DELETE PROCEDURE hProc.
        pCodError = "ERROR conexión e-Pos: " + cRetVal.
        /* *************** LOG DE ERRORES **************** */
        RUN Log-Error.
        /* *********************************************** */
        RETURN "ADM-ERROR".
    END.
    IF NUM-ENTRIES(cRetVal,'|') >= 4 THEN 
        ASSIGN
        cIP_ePos = ENTRY(3,cRetVal,'|')
        cID_caja  = ENTRY(4,cRetVal,'|').
    
    /* **************************************************************************** */
    /* 2do. Generamos el XML en el e-Pos */
    /* Generacion de Documento, TipoDocumnto, NroDocumnto, Division y Valor de Retorno */
    /* **************************************************************************** */
    cRetVal = "".
    RUN penvio-documento IN hProc (
        INPUT cIP_ePos,
        INPUT cID_caja,
        INPUT B-CDOCU.CodDoc, 
        INPUT B-CDOCU.NroDoc, 
        INPUT B-CDOCU.CodDiv,  
        OUTPUT cRetVal).
    /* RetVal = NNN|xxxxxxxxxxxxxxxx|hhhhaaaasssssshhhh */
    /* Si los 3 primeros digitos del cRetVal = "000", generacion OK y trae el HASHHHHHH */
    IF SUBSTRING(cRetVal,1,3) <> "000" THEN DO:
        iFlagPPLL = 0.
        /* Error en el XML */
        cFilled = DYNAMIC-FUNCTION('fdesconectar-epos':U IN  hProc).
        DELETE OBJECT hSocket.
        DELETE PROCEDURE hProc.
        /* Guardamos el error pero grabamos el documento por ahora */
        pCodError = "ERROR envío e-Pos: " + cRetVal.
        /* *************** LOG DE ERRORES **************** */
        RUN Log-Error.
        /* *********************************************** */
        RETURN "ADM-ERROR".
    END.
    

    ASSIGN 
        iEstadoPPLL = INTEGER(ENTRY(1,cRetVal,'|')) NO-ERROR.
    cCodHash = ''.
    IF NUM-ENTRIES(cRetVal,'|') >= 3 THEN cCodHash = ENTRY(3,cRetVal,'|').

    /* Ic - 17Oct2017 - Datos QR */
    IF B-CDOCU.CodDoc = 'N/C' OR B-CDOCU.CodDoc = 'N/D' THEN DO:
        IF NUM-ENTRIES(cRetVal,'|') >= 4 THEN cNumDocumento = ENTRY(4,cRetVal,'|').
        IF NUM-ENTRIES(cRetVal,'|') >= 5 THEN cDataQR = ENTRY(5,cRetVal,'|').
    END.
    ELSE DO:
        IF NUM-ENTRIES(cRetVal,'|') >= 4 THEN cDataQR = ENTRY(4,cRetVal,'|').
    END.
    cDataQR = REPLACE(cDataQR,"@","|").
    
    IF TRUE <> (cCodHash > '') THEN DO:
        cFilled = DYNAMIC-FUNCTION('fdesconectar-epos':U IN  hProc).
        DELETE OBJECT hSocket.
        DELETE PROCEDURE hProc.
        /* Guardamos el error pero grabamos el documento por ahora */
        pCodError = "ERROR envío e-Pos: código de Hash en blanco." + CHR(10) + cRetVal.
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
        cFilled = DYNAMIC-FUNCTION('fdesconectar-epos':U IN  hProc).
        DELETE OBJECT hSocket.
        DELETE PROCEDURE hProc.
        /* *************** LOG DE ERRORES **************** */
        RUN Log-Error.
        /* *********************************************** */
        RETURN "ERROR-EPOS".    /* CON ESTO PODEMOS MARCAR EL COMPROBANTE COMO ANULADO */
        /*RETURN "ADM-ERROR".*/
    END.
    /* **************************************************************************** */
    /* 4to. AHORA SÍ: Enviamos la Confirmacion */
    /* **************************************************************************** */
    cRetVal = "".
    RUN pconfirmo-documento IN hProc (
        INPUT cIP_ePos,
        INPUT cID_caja,
        INPUT B-CDOCU.CodDoc,
        INPUT B-CDOCU.NroDoc,
        INPUT B-CDOCU.CodDiv,
        OUTPUT cRetVal).
    /*cRetVal = '888'.*/
    /* Si los 3 primeros digitos del cRetVal = "000" */
    IF SUBSTRING(cRetVal,1,3) <> "000" THEN DO:
        iFlagPPLL = 2.
        cFilled = DYNAMIC-FUNCTION('fdesconectar-epos':U IN  hProc).
        DELETE OBJECT hSocket.
        DELETE PROCEDURE hProc.
        pCodError = "ERROR confirmación e-Pos: " + cRetVal.
        /* *************** LOG DE ERRORES **************** */
        RUN Log-Error.
        /* *********************************************** */
        RETURN "ERROR-EPOS".
        /* **************************************************** */
    END.
    
    CATCH eBlockError AS PROGRESS.Lang.Error:
        IF eBlockError:NumMessages > 0 THEN DO:
            pCodError = eBlockError:GetMessage(1).
            DO ix = 2 TO eBlockError:NumMessages:
                pCodError = pCodError + CHR(10) + eBlockError:GetMessage(ix).
            END.
        END. 
        /* *************** LOG DE ERRORES **************** */
        pCodError = "ERROR INESPERADO DEL SISTEMA".
        RUN Log-Error.
        /* *********************************************** */
        /* Borramos de la memoria las rutinas antes cargadas */
        cFilled = DYNAMIC-FUNCTION('fdesconectar-epos':U IN  hProc).
        DELETE OBJECT hSocket.
        DELETE PROCEDURE hProc.
        DELETE OBJECT eBlockError.
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END CATCH.
END.

/* Borramos de la memoria las rutinas antes cargadas */
cFilled = DYNAMIC-FUNCTION('fdesconectar-epos':U IN  hProc).
DELETE OBJECT hSocket.
DELETE PROCEDURE hProc.

IF AVAILABLE(FELogComprobantes) THEN RELEASE FELogComprobantes.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Log-Error) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Log-Error Procedure 
PROCEDURE Log-Error :
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
    T-FELogErrores.EstadoPPLL = iEstadoPPLL
    T-FELogErrores.FlagPPLL = (IF SUBSTRING(cRetVal,1,3) = "000" THEN 1 ELSE iFlagPPLL)
    T-FELogErrores.ID_Pos = cID_caja
    T-FELogErrores.IP_ePos = cIP_ePos
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

&IF DEFINED(EXCLUDE-New-Log) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE New-Log Procedure 
PROCEDURE New-Log :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCaso AS CHAR.

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
    FELogComprobantes.EstadoPPLL = iEstadoPPLL
    FELogComprobantes.CodHash      = cCodHash
    FELogComprobantes.NumDocumento = cNumDocumento
    FELogComprobantes.IP_ePos = cIP_ePos
    FELogComprobantes.ID_Pos  = cID_caja
    FELogComprobantes.DataQR  = cDataQR
    FELogComprobantes.campo-c[1]  = x-pc + ":" + x-ip
    NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
    pCodError = "Duplicado comprobante en FELogComprobantes: " + B-CDOCU.coddoc + ' ' + B-CDOCU.nrodoc.
    DELETE FELogComprobantes NO-ERROR.
    RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

