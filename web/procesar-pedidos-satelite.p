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

RUN lib/p-write-log-txt.r("Procesar pedidos Satelite", 'Inicio').

SESSION:SET-WAIT-STATE('GENERAL').

RUN lib/p-write-log-txt.r("Procesar pedidos Satelite", 'Generar Pedidos Logisticos y Ordenes de despacho').

RUN procesar-cot-ped. 

RUN lib/p-write-log-txt.r("Procesar pedidos Satelite", 'Generar Ordenes de despacho').

RUN procesar-ped-od.

RUN lib/p-write-log-txt.r("Procesar pedidos Satelite", 'Generar PHR y HPK').

RUN procesar-od-phr-hpk.


SESSION:SET-WAIT-STATE('').

RUN lib/p-write-log-txt.r("Procesar pedidos Satelite", 'Fin').

QUIT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-procesar-cot-ped) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-cot-ped Procedure 
PROCEDURE procesar-cot-ped :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR cCodOrigen AS CHAR.
DEFINE VAR cNroOrigen AS CHAR.

DEFINE VAR cCodDoc AS CHAR.
DEFINE VAR cNroDoc AS CHAR.
DEFINE VAR cCodDoc1 AS CHAR.
DEFINE VAR cNroDoc1 AS CHAR.

DEFINE VAR cNewCodDoc AS CHAR.
DEFINE VAR cNewNroDoc AS CHAR.
DEFINE VAR cMsgRet AS CHAR.

DEFINE VAR dFecha AS DATE.
DEFINE VAR cHora AS CHAR.

DEFINE VAR salioError AS LOG.

cCodOrigen = "RIQRA".
cNroOrigen = "HORIZONTAL".
cCodDoc = 'COT'.
         
FOR EACH faccpedi WHERE faccpedi.codcia = 1 AND faccpedi.codorigen = cCodOrigen AND 
                        faccpedi.nroOrigen = cNroOrigen AND faccpedi.flgest = 'P' NO-LOCK:
    IF NOT faccpedi.codtrans = 'PLTFMCLI' THEN NEXT.    /* Pedido no realizado por la plataforma cliente */
    IF faccpedi.coddoc <> cCodDoc THEN NEXT.

    RUN lib/p-write-log-txt.r("Procesar pedidos Satelite", 'Pedido comercial ' + faccpedi.coddoc + ' ' + faccpedi.nroped).

    dFecha = TODAY.
    cHora = STRING(TIME,"hh:mm:ss").
    cNroDoc = faccpedi.nroped.
    cNewCodDoc = "".
    cNewNroDoc = "".
    cMsgRet = "".
    salioError = NO.

    /* Generar PED Logistico */
    RUN web/generacion-pedido-logistico.r(INPUT cCodDoc,    /* COT */
                                       INPUT cNroDoc,
                                       OUTPUT cNewCodDoc,
                                       OUTPUT cNewNroDoc,
                                       OUTPUT cMsgRet) NO-ERROR.

     IF ERROR-STATUS:ERROR = YES THEN DO:
         salioError = YES.
         cMsgRet = cMsgRet + chr(10) + ERROR-STATUS:GET-MESSAGE(1).
     END.

     FIND FIRST logproceso WHERE logproceso.fchaproc = dFecha AND                                
                                logproceso.coddoc = cCodDoc AND logproceso.nrodoc = cNroDoc AND 
                                logproceso.newcoddoc = cNewCodDoc AND logproceso.newnrodoc = cNewNroDoc 
                                NO-LOCK NO-ERROR.
    IF NOT AVAILABLE logproceso THEN DO:
        CREATE logproceso.
        ASSIGN logproceso.coddoc = cCodDoc
                logproceso.nrodoc = cNroDoc
                logproceso.fchareg = TODAY
                logproceso.horareg = STRING(TIME,"hh:mm:ss")
                logproceso.proceso = 'GENERACION PEDIDO LOGISTICO'
                logproceso.referencia = faccpedi.ordcmp.
    END.
    FIND CURRENT logproceso EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE logproceso THEN DO:
        ASSIGN logproceso.fchaproc = dFecha
                logproceso.horaproc = cHora
                logproceso.mensaje = cMsgRet.
    END.
    IF RETURN-VALUE = "ADM-ERROR" OR salioError = YES THEN DO:
        RELEASE logproceso NO-ERROR.
        NEXT.
    END.
    /**/
    ASSIGN logproceso.newcoddoc = cNewCodDoc
            logproceso.newnrodoc = cNewNroDoc.
    RELEASE logproceso NO-ERROR.

    /* Generar O/D Logistico */
    cCodDoc1 = cNewCodDoc.
    cNroDoc1 = cNewNroDoc.
    cNewCodDoc = "".
    cNewNroDoc = "".
    cMsgRet = "".
    dFecha = TODAY.
    cHora = STRING(TIME,"hh:mm:ss").
    /*
    RUN web/generacion-orden-despacho.r(INPUT cCodDoc1,     /* PED */
                                      INPUT cNroDoc1,
                                      OUTPUT cNewCodDoc,
                                      OUTPUT cNewNroDoc,
                                      OUTPUT cMsgRet).

    FIND FIRST logproceso WHERE logproceso.fchaproc = dFecha AND                            
                                logproceso.coddoc = cCodDoc1 AND logproceso.nrodoc = cNroDoc1 AND
                                logproceso.newcoddoc = cNewCodDoc AND logproceso.newnrodoc = cNewNroDoc
                                NO-LOCK NO-ERROR.
    IF NOT AVAILABLE logproceso THEN DO:
        CREATE logproceso.
        ASSIGN logproceso.coddoc = cCodDoc1
                logproceso.nrodoc = cNroDoc1
                logproceso.fchareg = TODAY
                logproceso.horareg = STRING(TIME,"hh:mm:ss").
    END.
    FIND CURRENT logproceso EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE logproceso THEN DO:
        ASSIGN logproceso.fchaproc = dFecha
                logproceso.horaproc = cHora
                logproceso.mensaje = cMsgRet.
    END.
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        RELEASE logproceso NO-ERROR.
        NEXT.
    END.
    /**/
    ASSIGN logproceso.newcoddoc = cNewCodDoc
            logproceso.newnrodoc = cNewNroDoc.
    RELEASE logproceso NO-ERROR.
    */
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-procesar-od-phr-hpk) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-od-phr-hpk Procedure 
PROCEDURE procesar-od-phr-hpk :
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
DEFINE VAR cCodOrigen AS CHAR.
DEFINE VAR cNroOrigen AS CHAR.

DEFINE VAR cCodDoc AS CHAR.
DEFINE VAR cNroDoc AS CHAR.
DEFINE VAR cCodDoc1 AS CHAR.
DEFINE VAR cNroDoc1 AS CHAR.

DEFINE VAR cNewCodDoc AS CHAR.
DEFINE VAR cNewNroDoc AS CHAR.
DEFINE VAR cMsgRet AS CHAR.

DEFINE VAR dFecha AS DATE.
DEFINE VAR cHora AS CHAR.

DEFINE VAR salioError AS LOG.

cCodOrigen = "RIQRA".
cNroOrigen = "HORIZONTAL".
cCodDoc = 'O/D'.
         
FOR EACH faccpedi WHERE faccpedi.codcia = 1 AND faccpedi.codorigen = cCodOrigen AND 
                        faccpedi.nroOrigen = cNroOrigen AND faccpedi.flgest = 'P' NO-LOCK:
    IF NOT faccpedi.codtrans = 'PLTFMCLI' THEN NEXT.    /* O/D no realizado por la plataforma cliente */
    IF NOT faccpedi.flgsit = 'K' THEN NEXT.     /* no esta pendiente de generar PHR-HPK */
    IF faccpedi.coddoc <> cCodDoc THEN NEXT.

    dFecha = TODAY.
    cHora = STRING(TIME,"hh:mm:ss").
    cNroDoc = faccpedi.nroped.
    cNewCodDoc = "".
    cNewNroDoc = "".
    cMsgRet = "".

    salioError = NO.
    /* Generar PHR y HPK Logistico */
    RUN web/generacion-phr-hpk.r(INPUT cCodDoc,    /* O/D */
                                       INPUT cNroDoc,
                                       OUTPUT cNewCodDoc,
                                       OUTPUT cNewNroDoc,
                                       OUTPUT cMsgRet) NO-ERROR.

    IF ERROR-STATUS:ERROR = YES THEN DO:
        cMsgRet = 'web/generacion-phr-hpk.r : ' + CHR(10) + ERROR-STATUS:GET-MESSAGE(1) + CHR(10) + cMsgRet .
        salioError = YES.
    END.

    FIND FIRST logproceso WHERE logproceso.fchaproc = dFecha AND
                                logproceso.coddoc = cCodDoc AND logproceso.nrodoc = cNroDoc AND 
                                logproceso.newcoddoc = cNewCodDoc AND logproceso.newnrodoc = cNewNroDoc
                                NO-LOCK NO-ERROR.
    IF NOT AVAILABLE logproceso THEN DO:
        CREATE logproceso.
        ASSIGN logproceso.coddoc = cCodDoc
                logproceso.nrodoc = cNroDoc
                logproceso.fchareg = TODAY
                logproceso.horareg = STRING(TIME,"hh:mm:ss")
                logproceso.proceso = 'GENERACION DE PHR Y HPK'
                logproceso.referencia = faccpedi.ordcmp.
    END.
    FIND CURRENT logproceso EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE logproceso THEN DO:
        ASSIGN logproceso.fchaproc = dFecha
                logproceso.horaproc = cHora
                logproceso.mensaje = cMsgRet.
    END.
    IF RETURN-VALUE = "ADM-ERROR" OR salioError = YES THEN DO:
        RELEASE logproceso NO-ERROR.
        NEXT.
    END.
    /**/
    ASSIGN logproceso.newcoddoc = cNewCodDoc
            logproceso.newnrodoc = cNewNroDoc.
    RELEASE logproceso NO-ERROR.

END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-procesar-ped-od) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-ped-od Procedure 
PROCEDURE procesar-ped-od :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR cCodOrigen AS CHAR.
DEFINE VAR cNroOrigen AS CHAR.

DEFINE VAR cCodDoc AS CHAR.
DEFINE VAR cNroDoc AS CHAR.
DEFINE VAR cCodDoc1 AS CHAR.
DEFINE VAR cNroDoc1 AS CHAR.

DEFINE VAR cNewCodDoc AS CHAR.
DEFINE VAR cNewNroDoc AS CHAR.
DEFINE VAR cMsgRet AS CHAR.

DEFINE VAR dFecha AS DATE.
DEFINE VAR cHora AS CHAR.

DEFINE VAR salioError AS LOG.

cCodOrigen = "RIQRA".
cNroOrigen = "HORIZONTAL".
cCodDoc = 'PED'.
         
FOR EACH faccpedi WHERE faccpedi.codcia = 1 AND faccpedi.codorigen = cCodOrigen AND 
                        faccpedi.nroOrigen = cNroOrigen AND faccpedi.flgest = 'G' NO-LOCK:
    IF NOT faccpedi.codtrans = 'PLTFMCLI' THEN NEXT.    /* Pedido no realizado por la plataforma cliente */
    IF faccpedi.coddoc <> cCodDoc THEN NEXT.

    dFecha = TODAY.
    cHora = STRING(TIME,"hh:mm:ss").
    cNroDoc = faccpedi.nroped.
    cNewCodDoc = "".
    cNewNroDoc = "".
    cMsgRet = "".

    salioError = NO.
    /* Generar PED Logistico */
    RUN web/generacion-orden-despacho.r(INPUT cCodDoc,    /* PED */
                                       INPUT cNroDoc,
                                       OUTPUT cNewCodDoc,
                                       OUTPUT cNewNroDoc,
                                       OUTPUT cMsgRet).

    IF ERROR-STATUS:ERROR = YES THEN DO:
        cMsgRet = 'PED_Add_Record_riqra : ' + CHR(10) + ERROR-STATUS:GET-MESSAGE(1) + CHR(10) + cMsgRet .
        salioError = YES.
    END.

    FIND FIRST logproceso WHERE logproceso.fchaproc = dFecha AND
                                logproceso.coddoc = cCodDoc AND logproceso.nrodoc = cNroDoc AND 
                                logproceso.newcoddoc = cNewCodDoc AND logproceso.newnrodoc = cNewNroDoc
                                NO-LOCK NO-ERROR.
    IF NOT AVAILABLE logproceso THEN DO:
        CREATE logproceso.
        ASSIGN logproceso.coddoc = cCodDoc
                logproceso.nrodoc = cNroDoc
                logproceso.fchareg = TODAY
                logproceso.horareg = STRING(TIME,"hh:mm:ss")
                logproceso.proceso = 'GENERACION ORDEN DE DESPACHO'
                logproceso.referencia = faccpedi.ordcmp.
    END.
    FIND CURRENT logproceso EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE logproceso THEN DO:
        ASSIGN logproceso.fchaproc = dFecha
                logproceso.horaproc = cHora
                logproceso.mensaje = cMsgRet.
    END.
    IF RETURN-VALUE = "ADM-ERROR" OR salioError = YES THEN DO:
        RELEASE logproceso NO-ERROR.
        NEXT.
    END.
    /**/
    ASSIGN logproceso.newcoddoc = cNewCodDoc
            logproceso.newnrodoc = cNewNroDoc.
    RELEASE logproceso NO-ERROR.

END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

