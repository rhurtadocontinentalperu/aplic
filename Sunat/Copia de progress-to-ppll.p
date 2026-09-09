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

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pTipo  AS CHAR.     /* MOSTRADOR CREDITO */
DEF INPUT PARAMETER pCodTer AS CHAR.    /* SOLO PARA MOSTRADOR */
DEF OUTPUT PARAMETER pCodError AS CHAR NO-UNDO.

DEF BUFFER B-CDOCU FOR Ccbcdocu.
FIND B-CDOCU WHERE ROWID(B-CDOCU) = pRowid NO-LOCK NO-ERROR.
IF LOOKUP(B-CDOCU.CodDoc, 'FAC,BOL,N/C,N/D') = 0 THEN RETURN "OK".

/* ********************************************* */
/* Inicio de actividades facturación electrónica */
/* ********************************************* */
DEF VAR pStatus AS LOG.
RUN sunat\p-inicio-actividades (INPUT B-CDOCU.fchdoc, OUTPUT pStatus).
IF pStatus = NO THEN RETURN "OK".       /* Todavía no han iniciado las actividades */
/* ********************************************* */

DEF VAR pID_Pos AS CHAR NO-UNDO.

CASE pTipo:
    WHEN "MOSTRADOR" THEN DO:
        FIND CcbCTerm WHERE CcbCTerm.CodCia = B-CDOCU.codcia 
            AND CcbCTerm.CodDiv = B-CDOCU.coddiv
            AND CcbCTerm.CodTer = pCodTer
            NO-LOCK NO-ERROR.
        IF CcbCTerm.ID_Pos = '' THEN DO:
            pCodError = "ERROR e-Pos: Terminal NO tiene configurado ID para el e-Pos".
            RETURN 'ADM-ERROR'.
        END.
        pID_Pos = CcbCTerm.ID_Pos.
    END.
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
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.5
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
DEFINE SHARED VAR hSocket AS HANDLE NO-UNDO.
DEFINE VAR cCodHash AS CHAR NO-UNDO.
DEFINE VAR iEstadoPPLL AS INT NO-UNDO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR':
    /* Levantamos las rutinas a memoria */
    RUN sunat\facturacion-electronica.p PERSISTENT SET hProc.

    IF VALID-HANDLE(hSocket) THEN DELETE OBJECT hSocket.
    CREATE SOCKET hSocket.

    /* 1ro. Nos conectamos al e-Pos */
    /* Si devuelve 000|xxxxxxxxxxx la coneción está OK */
    RUN pconectar-epos IN hProc (INPUT B-CDOCU.CodDiv, 
                                 INPUT pID_Pos,
                                 OUTPUT cRetVal).
    IF SUBSTRING(cRetVal,1,3) <> "000" THEN DO:
        /* Borramos de la memoria las rutinas antes cargadas */
        cFilled = DYNAMIC-FUNCTION('fdesconectar-epos':U IN  hProc).
        DELETE OBJECT hSocket.
        DELETE PROCEDURE hProc.
        /* Guardamos el error pero grabamos el documento por ahora */
        pCodError = "ERROR e-Pos: " + cRetVal.
        RUN New-Log.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        RETURN "OK".    /* Debe ser "ADM-ERROR" */
    END.
    
    /* 2do. Generamos el XML en el e-Pos */
    /* Generacion de Documento, TipoDocumnto, NroDocumnto, Division y Valor de Retorno */
    cRetVal = "".
    RUN penviar-documento IN hProc (INPUT B-CDOCU.CodDoc, 
                                    INPUT B-CDOCU.NroDoc, 
                                    INPUT B-CDOCU.CodDiv,  
                                    OUTPUT cRetVal).
    /* RetVal = NNN|xxxxxxxxxxxxxxxx|hhhhaaaasssssshhhh */
    /* Si los 3 primeros digitos del cRetVal = "000", generacion OK y trae el HASHHHHHH */
    IF SUBSTRING(cRetVal,1,3) <> "000" THEN DO:
        /* Borramos de la memoria las rutinas antes cargadas */
        cFilled = DYNAMIC-FUNCTION('fdesconectar-epos':U IN  hProc).
        DELETE OBJECT hSocket.
        DELETE PROCEDURE hProc.
        /* Guardamos el error pero grabamos el documento por ahora */
        pCodError = "ERROR e-Pos: " + cRetVal.
        RUN New-Log.                         
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        RETURN "OK".    /* Debe ser "ADM-ERROR" */
    END.
    ASSIGN iEstadoPPLL = INTEGER(ENTRY(1,cRetVal,'|')) NO-ERROR.
    IF NUM-ENTRIES(cRetVal,'|') >= 3 THEN cCodHash = ENTRY(3,cRetVal,'|').

    /* 3ro. Enviamos la Confirmacion */
/*     RUN pconfirmar-documento IN hProc (INPUT B-CDOCU.CodDoc,          */
/*                                        INPUT B-CDOCU.NroDoc,          */
/*                                        INPUT B-CDOCU.CodDiv,          */
/*                                        OUTPUT cRetVal).               */
/*     /* Si los 3 primeros digitos del cRetVal = "000" */               */
/*     IF SUBSTRING(cRetVal,1,3) <> "000" THEN DO:                       */
/*         /* Borramos de la memoria las rutinas antes cargadas */       */
/*         cFilled = DYNAMIC-FUNCTION('fdesconectar-epos':U IN  hProc).  */
/*         DELETE OBJECT hSocket.                                        */
/*         DELETE PROCEDURE hProc.                                       */
/*         /* Guardamos el error pero grabamos el documento por ahora */ */
/*         pCodError = "ERROR e-Pos: " + cRetVal.                        */
/*         RUN New-Log.                                                  */
/*         IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.  */
/*         RETURN "OK".    /* Debe ser "ADM-ERROR" */                    */
/*     END.                                                              */

    /* 4ro. Grabamos el LOG de control */
    RUN New-Log.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    CATCH eBlockError AS PROGRESS.Lang.Error:
        IF eBlockError:NumMessages > 0 THEN DO:
            pCodError = eBlockError:GetMessage(1).
            DO ix = 2 TO eBlockError:NumMessages:
                pCodError = pCodError + CHR(10) + eBlockError:GetMessage(ix).
            END.
        END.
        /* Borramos de la memoria las rutinas antes cargadas */
        cFilled = DYNAMIC-FUNCTION('fdesconectar-epos':U IN  hProc).
        DELETE OBJECT hSocket.
        DELETE PROCEDURE hProc.
        DELETE OBJECT eBlockError.
        UNDO, RETURN 'ADM-ERROR'.
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

&IF DEFINED(EXCLUDE-New-Log) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE New-Log Procedure 
PROCEDURE New-Log :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* NO duplicados */
    FIND FIRST FELogComprobantes WHERE FELogComprobantes.CodCia = B-CDOCU.codcia
        AND FELogComprobantes.CodDiv = B-CDOCU.coddiv
        AND FELogComprobantes.CodDoc = B-CDOCU.coddoc
        AND FELogComprobantes.NroDoc = B-CDOCU.nrodoc
        NO-LOCK NO-ERROR.
    IF AVAILABLE FELogComprobantes THEN DO:
        pCodError = "Duplicado comprobante el FELogComprobantes".
        RETURN 'ADM-ERROR'.
    END.
    CREATE FELogComprobantes.
    ASSIGN
        FELogComprobantes.CodCia = B-CDOCU.codcia
        FELogComprobantes.CodDiv = B-CDOCU.coddiv
        FELogComprobantes.CodDoc = B-CDOCU.coddoc
        FELogComprobantes.NroDoc = B-CDOCU.nrodoc
        FELogComprobantes.LogDate = NOW
        FELogComprobantes.LogEstado = cRetVal
        FELogComprobantes.LogUser = B-CDOCU.usuario
        FELogComprobantes.FlagPPLL = (IF ENTRY(1,cRetVal,'|') = "000" THEN 1 ELSE 0)
        FELogComprobantes.CodHash = cCodHash
        FELogComprobantes.EstadoPPLL = iEstadoPPLL
        .
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

