&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b-CcbCDocu FOR CcbCDocu.
DEFINE TEMP-TABLE T-CcbDCaja NO-UNDO LIKE CcbDCaja.



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

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR cl-codcia AS INT. 
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR. 

DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER x-ccbddocu FOR ccbddocu.
DEFINE BUFFER x-gn-ConVt FOR gn-ConVt. 
DEFINE BUFFER x-trazabilidad-mov FOR trazabilidad-mov.
DEFINE BUFFER b-trazabilidad-mov FOR trazabilidad-mov.

DEFINE BUFFER x-CcbDMvto FOR CcbDMvto.
DEFINE BUFFER x-Ccbccaja FOR Ccbccaja.
DEFINE BUFFER x-Ccbdcaja FOR Ccbdcaja.
DEFINE BUFFER y-Ccbdcaja FOR Ccbdcaja.

DEFINE VAR x-articulo-ICBPER AS CHAR.
x-articulo-ICBPER = "099268".

DEFINE TEMP-TABLE tt-w-report LIKE w-report.
DEFINE TEMP-TABLE x-w-report LIKE w-report.
DEFINE TEMP-TABLE tw-report LIKE w-report.

DEFINE TEMP-TABLE wrk_ret NO-UNDO
    FIELDS CodCia LIKE CcbDCaja.CodCia
    FIELDS CodCli LIKE CcbCDocu.CodCli
    FIELDS CodDoc LIKE CcbCDocu.CodDoc COLUMN-LABEL "Tipo  "
    FIELDS NroDoc LIKE CcbCDocu.NroDoc COLUMN-LABEL "Documento " FORMAT "x(10)"
    FIELDS CodRef LIKE CcbDCaja.CodRef
    FIELDS NroRef LIKE CcbDCaja.NroRef
    FIELDS FchDoc LIKE CcbCDocu.FchDoc COLUMN-LABEL "    Fecha    !    Emisión    "
    FIELDS FchVto LIKE CcbCDocu.FchVto COLUMN-LABEL "    Fecha    ! Vencimiento"
    FIELDS CodMon AS CHARACTER COLUMN-LABEL "Moneda" FORMAT "x(3)"
    FIELDS ImpTot LIKE CcbDCaja.ImpTot COLUMN-LABEL "Importe Total"
    FIELDS ImpRet LIKE CcbDCaja.ImpTot COLUMN-LABEL "Importe!a Retener"
    FIELDS FchRet AS DATE
    FIELDS NroRet AS CHARACTER
    INDEX ind01 CodRef NroRef.

/* Para la impresion del EECC */
DEFINE TEMP-TABLE ttTempo
    FIELD   tcoddoc     AS  CHAR
    FIELD   tnrodoc     AS  CHAR.

DEFINE VAR s-task-no AS INT.

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
      TABLE: b-CcbCDocu B "?" ? INTEGRAL CcbCDocu
      TABLE: T-CcbDCaja T "?" NO-UNDO INTEGRAL CcbDCaja
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 24.73
         WIDTH              = 62.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-amortizaciones-con-nc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE amortizaciones-con-nc Procedure 
PROCEDURE amortizaciones-con-nc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
    Suma el importe de las N/C con la que se pago la Factura o Boleta 
*/

DEFINE INPUT PARAMETER pCodDOc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS DEC.

pRetVal = 0.

SESSION:SET-WAIT-STATE("GENERAL").

VERIFICANDO:
FOR EACH ccbdcaja WHERE ccbdcaja.codcia = s-codcia AND
                            ccbdcaja.codref = pCodDoc AND         /* FAC,BOL */
                            ccbdcaja.nroref = pNroDoc NO-LOCK :

    FIND FIRST ccbccaja WHERE ccbccaja.codcia = ccbdcaja.codcia AND
                                        ccbccaja.coddoc = ccbdcaja.coddoc AND   /* I/C */
                                        ccbccaja.nrodoc = ccbdcaja.nrodoc NO-LOCK NO-ERROR.
    IF AVAILABLE ccbccaja THEN DO:
        IF ccbccaja.flgest = 'A' THEN NEXT.
    END.
                        
    FOR EACH ccbdmov WHERE ccbdmov.codcia = s-codcia AND
                            ccbdmov.codref = ccbdcaja.coddoc AND
                            ccbdmov.nroref = ccbdcaja.nrodoc AND 
                            ccbdmov.coddoc = 'N/C' NO-LOCK:
        IF ccbdmov.codmon = 2 THEN DO:
            pRetVal = pRetVal + (ccbdmov.imptot * ccbdmov.tpocmb).
        END.
        ELSE DO:
            pRetVal = pRetVal + ccbdmov.imptot.
        END.
    END.
END.

SESSION:SET-WAIT-STATE("").


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-antiguedad-cmpte-referenciado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE antiguedad-cmpte-referenciado Procedure 
PROCEDURE antiguedad-cmpte-referenciado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pConcepto AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pDias AS INT NO-UNDO.

DEFINE VAR x-tabla AS CHAR INIT "TIPO_DSCTO_CONC".
pDias = 0.     /* x default 180 Dias - 14May2020, susana indico que tome el valor de tabla */

FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                            vtatabla.tabla = x-tabla AND
                            vtatabla.llave_c1 = pConcepto NO-LOCK NO-ERROR.
IF AVAILABLE vtatabla THEN DO:
    pDias = vtatabla.rango_valor[2].
END.

IF pDias <= 0 THEN pDias = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-articulo-con-notas-de-credito) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE articulo-con-notas-de-credito Procedure 
PROCEDURE articulo-con-notas-de-credito :
/*------------------------------------------------------------------------------
  Purpose:  Devuelve la cantidad de veces que un articulo de la misma factura o
            boleta tiene notas de credito(N/C) y/o pre-notas de credito (PNC).   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pConceptoNC AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pCodArticulo AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pCodDoc AS CHAR NO-UNDO.     /* FAC,BOL */
DEFINE INPUT PARAMETER pNroDoc AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pCantidad AS INT NO-UNDO.

DEFINE VAR x-cantidad AS INT INIT 0.
DEFINE VAR x-estado AS CHAR.

/*
    pCantidad : devuelve la cantidad de N/C y/o PNC (PNC pendientes de generar N/C)        
*/

/* PNC pendientes de Aprobar */
FOR EACH x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                            x-ccbcdocu.codref = pCodDoc AND
                            x-ccbcdocu.nroref = pNroDoc AND
                            x-ccbcdocu.coddoc = "PNC" AND
                            x-ccbcdocu.tpofac = 'OTROS' AND     /* con detalle de articulo */
                            LOOKUP(x-ccbcdocu.flgest,"E,T,AP,D,P") > 0 NO-LOCK :   /* Por Aprobar, Generada, Aprobacion parcial, En proceso, Aprobado */

    FIND FIRST x-ccbddocu WHERE x-ccbddocu.codcia = s-codcia AND
                                x-ccbddocu.coddiv = x-ccbcdocu.coddiv AND
                                x-ccbddocu.coddoc = x-ccbcdocu.coddoc AND
                                x-ccbddocu.nrodoc = x-ccbcdocu.nrodoc AND
                                x-ccbddocu.codmat = pCodArticulo NO-LOCK NO-ERROR.

    IF AVAILABLE x-ccbddocu THEN DO:
        IF TRUE <> (x-ccbddocu.flg_factor > "") THEN DO:
            /* Aun sin revisar*/
            x-estado = "".
        END.
        ELSE DO:
            x-estado = ENTRY(1,x-ccbddocu.flg_factor,"|").
        END.

        IF x-estado <> "EXCLUIDO" THEN x-cantidad = x-cantidad + 1.
    END.

END.
/* N/C  */
FOR EACH x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                            x-ccbcdocu.codref = pCodDoc AND
                            x-ccbcdocu.nroref = pNroDoc AND
                            x-ccbcdocu.coddoc = "N/C" AND
                            x-ccbcdocu.tpofac = 'OTROS' AND     /* con detalle de articulo */
                            x-ccbcdocu.flgest <> 'A' NO-LOCK :  
    FIND FIRST x-ccbddocu WHERE x-ccbddocu.codcia = s-codcia AND
                                x-ccbddocu.coddiv = x-ccbcdocu.coddiv AND
                                x-ccbddocu.coddoc = x-ccbcdocu.coddoc AND
                                x-ccbddocu.nrodoc = x-ccbcdocu.nrodoc AND
                                x-ccbddocu.codmat = pCodArticulo NO-LOCK NO-ERROR.

    IF AVAILABLE x-ccbddocu THEN x-cantidad = x-cantidad + 1.

END.

pCantidad = x-cantidad.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CCB_Aplica-NCI) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CCB_Aplica-NCI Procedure 
PROCEDURE CCB_Aplica-NCI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Aplicación de la NCI a la FAI
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDoc AS CHAR.    /*  NCI */
DEF INPUT PARAMETER pNroDoc AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO. 

/* Buscamos el NCI (b-CcbCDocu) */
FIND FIRST b-CcbCDocu WHERE b-CcbCDocu.codcia = s-CodCia
    AND b-CcbCDocu.coddoc = pCodDoc
    AND b-CcbCDocu.nrodoc = pNroDoc
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE b-CcbCDocu 
    OR NOT (b-CcbCDocu.CodDoc = "NCI" AND b-CcbCDocu.CodRef = "FAI")
    THEN RETURN 'OK'.
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Bloqueamos la NCI */
    {lib/lock-genericov3.i ~
        &Tabla="b-CcbCDocu" ~
        &Alcance="FIRST" ~
        &Condicion="b-CcbCDocu.codcia = s-CodCia ~
                    AND b-CcbCDocu.coddoc = pCodDoc ~
                    AND b-CcbCDocu.nrodoc = pNroDoc" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
        
    /* Bloqueamos la FAI de referencia (x-ccbcdocu) */
    FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-CodCia
        AND x-ccbcdocu.coddoc = b-ccbcdocu.codref
        AND x-ccbcdocu.nrodoc = b-ccbcdocu.nroref
        EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    IF x-ccbcdocu.flgest <> "P" THEN DO:
        pMensaje = "El documento " + x-ccbcdocu.coddoc + " " + x-ccbcdocu.nrodoc + 
            " NO está pendiente de pago".
        UNDO, RETURN 'ADM-ERROR'.
    END.

    /* Verificamos que el importe de la NCI cubra el saldo de la FAI */
    DEF VAR x-ImpTot-Origen AS DEC NO-UNDO.
    DEF VAR x-ImpTot-Destino AS DEC NO-UNDO.
    DEF VAR x-TpoCmb-Venta AS DECI INIT 1 NO-UNDO.
    DEF VAR x-TpoCmb-Compra AS DECI INIT 1 NO-UNDO.

    x-ImpTot-Origen = b-CcbCDocu.SdoAct.        /* A la moneda de la NCI */
    x-ImpTot-Destino = b-CcbCDocu.SdoAct.       /* A la moneda de la NCI */
    IF b-CcbCDocu.CodMon <> x-CcbCDocu.CodMon THEN DO:  /* Diferentes Monedas */
        FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= TODAY NO-LOCK NO-ERROR.
        IF AVAILABLE gn-tcmb THEN
            ASSIGN
            x-TpoCmb-Compra = gn-tcmb.compra
            x-TpoCmb-Venta = gn-tcmb.venta.
        /* Pasamos a la moneda del FAI */
        IF x-CcbCDocu.CodMon = 1 
        THEN x-ImpTot-Destino = x-ImpTot-Destino * x-TpoCmb-Compra.     /* NCI en US$ y FAI en S/. */
        ELSE x-ImpTot-Destino = x-ImpTot-Destino / x-TpoCmb-Venta.      /* NCI en S/. y FAI en US$ */
    END.

    /* Aplicamos */
    DEF VAR x-ImpTot-Aplicar AS DECI NO-UNDO.

    x-ImpTot-Aplicar = MINIMUM(x-ccbcdocu.sdoact, x-ImpTot-Destino).
    ASSIGN
        x-ccbcdocu.SdoAct = x-ccbcdocu.SdoAct - x-ImpTot-Aplicar.
    IF x-ccbcdocu.sdoact <= 0 THEN
        ASSIGN
        x-CcbCDocu.FlgEst = "C"     /* Se camcela la FAI */
        x-CcbCDocu.FchCan = TODAY.
    CREATE Ccbdcaja.
    ASSIGN
        CcbDCaja.CodCia = s-CodCia
        CcbDCaja.CodDiv = b-CcbCDocu.CodDiv
        CcbDCaja.CodDoc = b-CcbCDocu.CodDoc     /* NCI */
        CcbDCaja.NroDoc = b-CcbCDocu.NroDoc
        CcbDCaja.CodCli = b-CcbCDocu.CodCli
        CcbDCaja.CodRef = b-CcbCDocu.CodRef     /* FAI */
        CcbDCaja.NroRef = b-CcbCDocu.NroRef
        CcbDCaja.CodMon = x-CcbCDocu.CodMon     /* A la moneda de la FAI */ 
        CcbDCaja.FchDoc = TODAY 
        CcbDCaja.ImpTot = x-ImpTot-Aplicar
        CcbDCaja.TpoCmb = (IF x-CcbCDocu.CodMon = 1 THEN x-TpoCmb-Venta ELSE x-TpoCmb-Compra)
        NO-ERROR
        .
     IF ERROR-STATUS:ERROR = YES THEN DO:
         pMensaje = "El documento " + b-ccbcdocu.coddoc + " " + b-ccbcdocu.nrodoc + 
             " NO se pudo grabar en CcbDcaja".
         UNDO, RETURN 'ADM-ERROR'.
     END.

    /* Amortizamos la NCI */
    x-ImpTot-Origen = x-ImpTot-Aplicar.
    IF b-CcbCDocu.CodMon <> x-CcbCDocu.CodMon THEN DO:
        IF b-CcbCDocu.CodMon = 1 THEN x-ImpTot-Origen = x-ImpTot-Origen / x-TpoCmb-Compra.
        ELSE x-ImpTot-Origen = x-ImpTot-Origen * x-TpoCmb-Venta.
    END.
    ASSIGN
        b-CcbCDocu.SdoAct = b-CcbCDocu.SdoAct - x-ImpTot-Origen.
    IF b-ccbcdocu.sdoact <= 0 THEN
        ASSIGN
        b-CcbCDocu.FlgEst = "C"     /* La NCI nace canceladas */
        b-CcbCDocu.FchCan = TODAY.
    CREATE Ccbdmov.
    ASSIGN
        CCBDMOV.CodCia = s-CodCia
        CCBDMOV.CodCli = b-CcbCDocu.CodCli
        CCBDMOV.CodDiv = b-CcbCDocu.CodDiv
        CCBDMOV.CodDoc = b-CcbCDocu.CodDoc  /* NCI */
        CCBDMOV.CodMon = b-CcbCDocu.CodMon
        CCBDMOV.CodRef = b-CcbCDocu.CodDoc
        CCBDMOV.FchDoc = TODAY
        CCBDMOV.FchMov = TODAY
        CCBDMOV.HraMov = STRING(TIME, 'HH:MM:SS')
        CCBDMOV.ImpTot = x-ImpTot-Origen
        CCBDMOV.NroDoc = b-CcbCDocu.NroDoc
        CCBDMOV.NroRef = b-CcbCDocu.NroDoc
        CCBDMOV.TpoCmb = (IF b-CcbCDocu.CodMon = 1 THEN x-TpoCmb-Venta ELSE x-TpoCmb-Compra)
        CCBDMOV.usuario = s-user-id
        NO-ERROR.

    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = "El documento " + b-ccbcdocu.coddoc + " " + b-ccbcdocu.nrodoc + 
            " NO se pudo grabar en CCBDMOV".
        UNDO, RETURN 'ADM-ERROR'.
    END.

END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CCB_Extorna-Aplica-NCI) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CCB_Extorna-Aplica-NCI Procedure 
PROCEDURE CCB_Extorna-Aplica-NCI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDoc AS CHAR.    /* NCI */
DEF INPUT PARAMETER pNroDoc AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

FIND FIRST b-CcbCDocu WHERE b-CcbCDocu.codcia = s-CodCia
    AND b-CcbCDocu.coddoc = pCodDoc
    AND b-CcbCDocu.nrodoc = pNroDoc
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE b-CcbCDocu 
    OR NOT (b-CcbCDocu.CodDoc = "NCI" AND b-CcbCDocu.CodRef = "FAI")
    THEN RETURN 'OK'.
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Bloqueamos la NCI */
    {lib/lock-genericov3.i ~
        &Tabla="b-CcbCDocu" ~
        &Alcance="FIRST" ~
        &Condicion="b-CcbCDocu.codcia = s-CodCia ~
                    AND b-CcbCDocu.coddoc = pCodDoc ~
                    AND b-CcbCDocu.nrodoc = pNroDoc" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
        
    /* Bloqueamos la FAI de referencia */
    FIND x-ccbcdocu WHERE x-ccbcdocu.codcia = s-CodCia
        AND x-ccbcdocu.coddoc = b-ccbcdocu.codref
        AND x-ccbcdocu.nrodoc = b-ccbcdocu.nroref
        EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.

    /* Extornamos aplicación al FAI */
    FOR EACH Ccbdcaja EXCLUSIVE-LOCK WHERE CcbDCaja.CodCia = s-CodCia
        AND CcbDCaja.CodDiv = b-CcbCDocu.CodDiv
        AND CcbDCaja.CodDoc = b-CcbCDocu.CodDoc     /* NCI */
        AND CcbDCaja.NroDoc = b-CcbCDocu.NroDoc
        AND CcbDCaja.CodRef = b-CcbCDocu.CodRef     /* FAI */
        AND CcbDCaja.NroRef = b-CcbCDocu.NroRef:
        ASSIGN
            x-ccbcdocu.sdoact = x-ccbcdocu.sdoact + ccbdcaja.imptot
            x-ccbcdocu.flgest = 'P'
            x-ccbcdocu.fchcan = ?.
        DELETE ccbdcaja.
    END.
    /* Extornamos aplicación a la NCI */
    FOR EACH Ccbdmov EXCLUSIVE-LOCK WHERE CCBDMOV.CodCia = s-CodCia
        AND CCBDMOV.CodDiv = b-CcbCDocu.CodDiv
        AND CCBDMOV.CodDoc = b-CcbCDocu.CodDoc  /* NCI */
        AND CCBDMOV.CodRef = b-CcbCDocu.CodDoc
        AND CCBDMOV.NroDoc = b-CcbCDocu.NroDoc
        AND CCBDMOV.NroRef = b-CcbCDocu.NroDoc:
        ASSIGN
            b-ccbcdocu.sdoac = b-ccbcdocu.sdoact + ccbdmov.imptot
            b-ccbcdocu.flgest = 'P'     /* OJO CON ESTO */
            b-ccbcdocu.fchcan = ?.
        DELETE ccbdmov.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CCB_Retenciones) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CCB_Retenciones Procedure 
PROCEDURE CCB_Retenciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pImporte AS DECI.
DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDocCja AS CHAR.
DEF INPUT PARAMETER TABLE FOR t-CcbDCaja.
DEF INPUT PARAMETER TABLE FOR wrk_ret.
DEF OUTPUT PARAMETER monto_ret AS DECI.

IF pImporte <= 0 THEN RETURN.

DEF VAR dTpoCmb AS DECI NO-UNDO.

FIND gn-clie WHERE
    gn-clie.codcia = cl-codcia AND
    gn-clie.codcli = pCodCli
    NO-LOCK NO-ERROR.
/* Agente de Retención */
IF AVAILABLE gn-clie AND gn-clie.rucold = "Si" THEN DO:
    dTpoCmb = 1.
    FOR EACH t-CcbDCaja NO-LOCK:
        /* Solo Facturas */
        IF LOOKUP(T-CcbDCaja.CodRef,"FAC,N/D") = 0 THEN NEXT.
        /* Busca Documento */
        FIND FIRST ccbcdocu WHERE
            ccbcdocu.codcia = s-codcia AND
            ccbcdocu.coddoc = T-CcbDCaja.CodRef AND
            ccbcdocu.nrodoc = T-CcbDCaja.NroRef
            USE-INDEX LLAVE01 NO-LOCK NO-ERROR.
        IF AVAILABLE ccbcdocu THEN DO:
            /* Tipo de Cambio Caja */
            IF dTpoCmb = 1 THEN DO:
                FIND LAST Gn-tccja WHERE Gn-tccja.fecha <= TODAY NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tccja THEN DO:
                    IF ccbcdocu.Codmon = 1 THEN dTpoCmb = Gn-tccja.Compra.
                    ELSE dTpoCmb = Gn-tccja.Venta.
                END.
            END.
            CREATE wrk_ret.
            ASSIGN
                wrk_ret.CodCia = ccbcdocu.codcia
                wrk_ret.CodCli = ccbcdocu.codcli
                wrk_ret.CodDoc = ccbcdocu.coddoc
                wrk_ret.NroDoc = ccbcdocu.nrodoc
                wrk_ret.FchDoc = ccbcdocu.fchdoc
                wrk_ret.CodRef = pCodDoc
                wrk_ret.NroRef = pNroDocCja
                wrk_ret.CodMon = "S/.".
            /* OJO: Cálculo de Retenciones Siempre en Soles */
            IF T-CcbDCaja.CodDoc = "S/." THEN DO:
                /*ML01*/
                wrk_ret.ImpTot = ccbcdocu.SdoAct *
                    (IF ccbcdocu.coddoc = "N/C" THEN -1 ELSE 1).
                wrk_ret.ImpRet = ROUND((wrk_ret.ImpTot * (6 / 100)),2).
            END.
            ELSE DO:
                /*ML01*/
                wrk_ret.ImpTot = ROUND((ccbcdocu.SdoAct * dTpoCmb),2) *
                    IF ccbcdocu.coddoc = "N/C" THEN -1 ELSE 1.
                wrk_ret.ImpRet = ROUND((wrk_ret.ImpTot * (6 / 100)),2).
            END.
            monto_ret = monto_ret + wrk_ret.ImpRet.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cliente-moroso) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cliente-moroso Procedure 
PROCEDURE cliente-moroso :
/*------------------------------------------------------------------------------
  Purpose: Si un cliente es moroso (tiene deudas vencidas)    
           La tolerancia incluida
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodcli AS CHAR.
DEFINE INPUT PARAMETER pToleranciaDias AS INT.
DEFINE OUTPUT PARAMETER pRetVal AS LOG NO-UNDO.

DEF VAR LocalMaster AS CHAR.
DEF VAR LocalRelacionados AS CHAR.
DEF VAR LocalAgrupados AS LOG.
DEF VAR LocalCliente AS CHAR NO-UNDO.

/*
RUN ccb/p-cliente-master.r(INPUT pCodCli,
                          OUTPUT LocalMaster,
                          OUTPUT LocalRelacionados,
                          OUTPUT LocalAgrupados).

IF LocalAgrupados = YES AND LocalRelacionados > '' THEN .
ELSE LocalRelacionados = pCodCli.
*/

pRetVal = NO.

IF pToleranciaDias < 0 THEN pToleranciaDias = 0.

FIND FIRST CcbCDocu WHERE CcbCDocu.CodCia = FacCPedi.CodCia
    AND  CcbCDocu.CodCli = pCodCli 
    AND  CcbCDocu.FlgEst = "P"
    AND  LOOKUP(CcbCDocu.CodDoc, "FAC,BOL,CHQ,LET,N/D") > 0
    AND  (CcbCDocu.FchVto + pToleranciaDias ) < TODAY     /* N dias de plazo */
    AND  ccbcdocu.sdoact > 0
    NO-LOCK NO-ERROR.
IF AVAIL CcbCDocu THEN pRetVal = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cliente-nuevo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cliente-nuevo Procedure 
PROCEDURE cliente-nuevo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodCli AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS LOG.


pRetVal = NO.

/* 27Set2019 - verificar si el cliente es nuevo */

/*
Gerardo Daniel Llican
02 Octubre 2019, 09:31 (hace 0 minutos)
para Cesar, Susana, Rodolfo, Julissa, Luis, Rubén

Hola Cesar, la intención de esta funcionalidad es reservar el riesgo de la cobranza en efectivo solo para clientes con quienes ya se tiene una relación de confianza (con base en sus re-compras).
Entendiendo por cliente nuevo cuando es la primera vez que nos hace una compra.
Cuando ya es un cliente con varias compras queda en manos de los gestores del maestro de clientes (Mayra - Crédito y Cobranza) autorizar vía un atributo que el sistema le permita hacer pedidos con condición de venta "Contado-Contra entrega".

Quedamos atentos a alguna precisión adicional por parte del equipo que esta en copia antes del despliegue de esta nueva validación a ambiente productivo.

Saludos
*/

IF NOT (pCodCli BEGINS '11111111') THEN DO:

    /*
        28Oct2019 - Mayra Padilla envio correo, se debe trabajar por GRUPO tambien.
        
        Sr. César,

        Buen día, si bien es cierto un cliente nuevo es cuando no ha realizado ningún tipo de compra en la compañía.

        Pero tenemos el caso de clientes que han venido trabajando con nosotros en esta condición (contado contra entrega) y desean agregar un nuevo ruc a su grupo para seguir haciendo sus compras, pero el sistema no permite ya que el RUC es "nuevo", pero el comprador sigue siendo el mismo.
        
    */
    
    DEF VAR LocalMaster AS CHAR.
    DEF VAR LocalRelacionados AS CHAR.
    DEF VAR LocalAgrupados AS LOG.
    DEF VAR LocalCliente AS CHAR NO-UNDO.

    DEFINE VAR x-sec AS INT.
    DEFINE VAR x-codcli AS CHAR.

    RUN ccb/p-cliente-master.r(INPUT pCodCli,
                              OUTPUT LocalMaster,
                              OUTPUT LocalRelacionados,
                              OUTPUT LocalAgrupados).

    IF LocalAgrupados = YES AND LocalRelacionados > '' THEN .
    ELSE LocalRelacionados = pCodCli.

    pRetVal = YES.

    GRUPO_CLIENTES:
    REPEAT x-sec = 1 TO NUM-ENTRIES(LocalRelacionados,","):
        x-codcli = ENTRY(x-sec,LocalRelacionados,",").
        FIND FIRST ccbcdocu USE-INDEX llave06 WHERE ccbcdocu.codcia = s-codcia AND
                                    ccbcdocu.codcli = x-CodCli AND
                                    ccbcdocu.flgest <> 'A' NO-LOCK NO-ERROR.
        IF AVAILABLE ccbcdocu THEN DO:
            /* Tiene ventas */
            pRetVal = NO.
            LEAVE GRUPO_CLIENTES.
        END.
    END.

    IF pRetVal = NO THEN DO:
        /* NO es cliente Nuevo */
    END.
    ELSE DO:
        FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                    vtatabla.tabla = 'AUT-CL-NUEVOS' AND
                                    vtatabla.llave_c1 = pCodCli NO-LOCK NO-ERROR.
        IF AVAILABLE vtatabla THEN DO:
            /* Tiene Autorizacion por parte del administrador */
            pRetVal = NO.
        END.
    END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-comprobante-con-notas-de-credito) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE comprobante-con-notas-de-credito Procedure 
PROCEDURE comprobante-con-notas-de-credito :
/*------------------------------------------------------------------------------
  Purpose:  Devuelve la cantidad de veces que un articulo de la misma factura o
            boleta tiene notas de credito y/o pre-notas de credito.   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pConceptoNC AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pCodDoc AS CHAR NO-UNDO.     /* FAC,BOL */
DEFINE INPUT PARAMETER pNroDoc AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pCantidad AS INT NO-UNDO.

DEFINE VAR x-cantidad AS INT INIT 0.
DEFINE VAR x-estado AS CHAR.

/*
    pCantidad : devuelve la cantidad de N/C y/o PNC (PNC pendientes de generar N/C) tiene referenciado a pNroDoc
*/

RUN notas-credito-del-comprobante(INPUT pConceptoNC, INPUT pCodDoc, INPUT pNroDoc,
                                           INPUT-OUTPUT TABLE tw-report).
FOR EACH tw-report NO-LOCK:
    x-cantidad = x-cantidad + 1.
END.

pCantidad = x-cantidad.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-comprobante-con-notas-de-debito) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE comprobante-con-notas-de-debito Procedure 
PROCEDURE comprobante-con-notas-de-debito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pConceptoNC AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pCodDoc AS CHAR NO-UNDO.     /* FAC,BOL */
DEFINE INPUT PARAMETER pNroDoc AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pCantidad AS INT NO-UNDO.

DEFINE VAR x-cantidad AS INT INIT 0.
DEFINE VAR x-estado AS CHAR.

/*
    pCantidad : devuelve la cantidad de N/D tiene referenciado a pNroDoc
*/

RUN notas-debito-del-comprobante(INPUT pConceptoNC, INPUT pCodDoc, INPUT pNroDoc,
                                           INPUT-OUTPUT TABLE tw-report).
FOR EACH tw-report NO-LOCK: 
    x-cantidad = x-cantidad + 1.   
END.
 
pCantidad = x-cantidad.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-comprobante-liquidado-con-nc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE comprobante-liquidado-con-nc Procedure 
PROCEDURE comprobante-liquidado-con-nc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
    Devuelve YES si el comprobante fue cancelado ya sea total o parcial con una N/C
*/

DEFINE INPUT PARAMETER pCodDOc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS LOG.

pRetVal = NO.


SESSION:SET-WAIT-STATE("GENERAL").

VERIFICANDO:
FOR EACH ccbdcaja WHERE ccbdcaja.codcia = s-codcia AND
                            ccbdcaja.codref = pCodDoc AND /*pCodDoc */         /* FAC,BOL */
                            ccbdcaja.nroref = pNroDoc /* pNroDoc*/ NO-LOCK :

    FIND FIRST ccbccaja WHERE ccbccaja.codcia = ccbdcaja.codcia AND
                                        ccbccaja.coddoc = ccbdcaja.coddoc AND   /* I/C */
                                        ccbccaja.nrodoc = ccbdcaja.nrodoc NO-LOCK NO-ERROR.
    IF AVAILABLE ccbccaja THEN DO:
        IF ccbccaja.flgest = 'A' THEN NEXT.
    END.
                        
    FOR EACH ccbdmov WHERE ccbdmov.codcia = s-codcia AND
                            ccbdmov.codref = ccbdcaja.coddoc AND
                            ccbdmov.nroref = ccbdcaja.nrodoc AND 
                            ccbdmov.coddoc = 'N/C' NO-LOCK:
        pRetVal = YES.
        LEAVE VERIFICANDO.
    END.
END.

SESSION:SET-WAIT-STATE("").


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-condicion-vta-genera-nota-credito) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE condicion-vta-genera-nota-credito Procedure 
PROCEDURE condicion-vta-genera-nota-credito :
/*------------------------------------------------------------------------------
  Purpose:     Dado una condicion de venta indica si permite generar 
                Notas de Credito (incluye PNC)
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCondVta AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pRetVal AS LOG.

pRetVal = NO.

FIND FIRST x-gn-ConVt WHERE x-gn-ConVt.codig = pCondVta NO-LOCK NO-ERROR.

IF AVAILABLE x-gn-ConVt THEN DO:
    IF NOT ( TRUE <> (x-gn-ConVt.libre_c01 > "")) THEN DO:
        IF CAPS(x-gn-ConVt.libre_c01) = "SI" THEN pRetVal = YES.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-direccion-de-moroso) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE direccion-de-moroso Procedure 
PROCEDURE direccion-de-moroso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pCodCli AS CHAR.
    DEFINE INPUT PARAMETER pLugEnt AS CHAR.
    DEFINE INPUT PARAMETER pCondVta AS CHAR.
    DEFINE OUTPUT PARAMETER pRetVal AS CHAR.

    DEFINE VAR x-retval AS LOG.

    pRetVal = "".
    x-retval = NO.

    LOOP_CLIENTES:
    /*FOR EACH gn-clieD WHERE gn-clieD.dircli = pLugEnt NO-LOCK:*/
    FOR EACH gn-clieD NO-LOCK WHERE gn-clieD.dircli CONTAINS pLugEnt 
        BREAK BY gn-clied.codcli:
        IF FIRST-OF(gn-clied.codcli) THEN DO:
            x-retval = NO.
            RUN cliente-moroso(INPUT gn-clieD.codcli, 
                               INPUT 0, 
                               OUTPUT x-retval).
            IF x-retval = YES THEN DO:
                /* Cliente MOROSO */
                pRetVal = gn-clieD.codcli.
                LEAVE LOOP_CLIENTES.
            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-eecc-cargar-documentos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eecc-cargar-documentos Procedure 
PROCEDURE eecc-cargar-documentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodCli AS CHAR.

DEFINE VAR x-sec AS INT.
DEFINE VAR x-signo AS INT.
DEFINE VAR x-doc AS CHAR.
DEFINE VAR x-estados AS CHAR.
DEFINE VAR x-situacion AS CHAR.
DEFINE VAR x-banco AS CHAR.
DEFINE VAR x-nrounico AS CHAR.
DEFINE VAR x-grupo AS CHAR.
DEFINE VAR x-grupo2 AS CHAR.
DEFINE VAR x-documentos AS CHAR.

DEFINE VAR x-ubicacion AS CHAR.

/* Ic - 18Dic2019, LPA - Ticket 68717*/

x-documentos = "A/C,A/R,LPA,LET,FAC,BOL,DCO,N/C,N/D,BD".
/*x-documentos = "A/R,LPA,LET,FAC,BOL,DCO,N/C,N/D,BD".*/

DEFINE VAR x1 AS DATETIME.
DEFINE VAR x2 AS DATETIME.

x1 = NOW.

EMPTY TEMP-TABLE ttTempo.

FOR EACH ccbcdocu  WHERE ccbcdocu.codcia = s-codcia AND 
    ccbcdocu.codcli = pCodCli AND
    LOOKUP(ccbcdocu.coddoc,x-documentos) > 0 AND 
    ccbcdocu.sdoact > 0 NO-LOCK:
    IF ccbcdocu.flgest = 'A' THEN NEXT.
    
    x-banco = "".
    x-nrounico = "".
    x-ubicacion = "".
    x-situacion = "".
    /* FILTRANDO DOCUMENTOS */
    IF ccbcdocu.coddoc = 'LET' THEN DO:
        /**/        
        x-ubicacion = ccbcdocu.flgubi.
        IF ccbcdocu.flgubi = 'C' THEN x-ubicacion = "Cartera".
        IF ccbcdocu.flgubi = 'B' THEN x-ubicacion = "Banco".

        RUN gn/fFlgSitCCB.r(INPUT ccbcdocu.flgsit, OUTPUT x-situacion).

        IF ccbcdocu.flgsit = 'P' AND ccbcdocu.flgubi = 'C' THEN DO:
            /* Ic - 19Set2018 / Correo de Julissa (14Set2018) si la LET esta Protestada y en Cartera, no mostrar Banco ni Nro Unico */
        END.
        ELSE DO:
            FIND FIRST cb-ctas WHERE cb-ctas.codcia = 0 AND 
                                        cb-ctas.codcta = ccbcdocu.codcta
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE cb-ctas THEN DO:
                FIND FIRST cb-tabl WHERE cb-tabl.tabla = "04" AND
                                            cb-tabl.codigo = cb-ctas.codbco NO-LOCK NO-ERROR.
                IF AVAILABLE cb-tabl THEN DO:
                    x-banco = cb-tabl.nombre.
                END.
            END.
            x-nrounico = ccbcdocu.nrosal.
        END.
        /**/
        /* Pendiente, Judicial y En Trámite */
        IF LOOKUP(ccbcdocu.flgest,'P,J,X') = 0 THEN NEXT.
    END.
    ELSE DO:
        /* Pendiente, Judicial */
        IF LOOKUP(ccbcdocu.flgest,'P,J') = 0  THEN NEXT.
    END.    
    /* */
    FIND FIRST gn-convt WHERE gn-convt.codig = ccbcdocu.fmapgo NO-LOCK NO-ERROR.
    /* */
    x-signo = 1.

    x-Grupo = "E.- LETRAS PENDIENTES".  /* Por Defecto */
    IF ccbcdocu.coddoc = 'A/R' THEN x-grupo = "A.- ANTICIPOS RECIBIDOS".
    IF ccbcdocu.coddoc = 'A/C' THEN x-grupo = "A.- ANTICIPOS DE CAMPAÑA".
    IF ccbcdocu.coddoc = 'LPA' THEN x-grupo = "A.- LETRA PRE-ACEPTADA".     /* Ticket 68717 */
    IF ccbcdocu.coddoc = 'LET' AND ccbcdocu.flgest = 'X' THEN x-grupo = "B.- LETRAS POR ACEPTAR".

    /* A pedido de Julissa Calderon - 06Feb2019, Letras en Descuento debe estar en el mismo grupo de Letras Pendientes */
    /*IF ccbcdocu.coddoc = 'LET' AND ccbcdocu.flgsit = 'D' THEN x-grupo = "C.- LETRAS EN DESCUENTO".*/
    IF ccbcdocu.coddoc = 'LET' AND ccbcdocu.flgsit = 'T' THEN x-grupo = "D.- LETRAS ACEPTADA EN TRANSITO".
    IF ccbcdocu.coddoc = "FAC" THEN x-grupo = "F.- FACTURAS".
    IF ccbcdocu.coddoc = "BOL" THEN x-grupo = "G.- BOLETAS".
    IF ccbcdocu.coddoc = "DCO" THEN x-grupo = "H.- DOCUMENTOS DE COBRANZAS".
    IF ccbcdocu.coddoc = 'N/C' THEN x-grupo = "I.- NOTAS DE CREDITO".
    IF ccbcdocu.coddoc = 'N/D' THEN x-grupo = "J.- NOTAS DE DEBITO".
    IF ccbcdocu.coddoc = 'BD' THEN x-grupo = "K.- BOLETAS DE DEPOSITO".
    /* */
    x-Grupo2 = "LETRA(S) PENDIENTE(S)".    /* Por Defecto */
    IF ccbcdocu.coddoc = 'A/R' THEN x-grupo2 = "ANTICIPOS RECIBIDOS".
    IF ccbcdocu.coddoc = 'A/C' THEN x-grupo2 = "ANTICIPOS DE CAMPAÑA".
    IF ccbcdocu.coddoc = 'LPA' THEN x-grupo2 = "LETRA PRE-ACEPTADA".        /* Ticket 68717 */
    IF ccbcdocu.coddoc = 'LET' AND ccbcdocu.flgest = 'X' THEN x-grupo2 = "LETRA(S) POR ACEPTAR".
    /* A pedido de Julissa Calderon - 06Feb2019, Letras en Descuento debe estar en el mismo grupo de Letras Pendientes */
    /*IF ccbcdocu.coddoc = 'LET' AND ccbcdocu.flgsit = 'D' THEN x-grupo2 = "LETRA(S) EN DESCUENTO".*/
    IF ccbcdocu.coddoc = 'LET' AND ccbcdocu.flgsit = 'T' THEN x-grupo2 = "LETRA(S) ACEPTADA EN TRANSITO".
    /*IF lookup(ccbcdocu.coddoc,"FAC,BOL,DCO") > 0 THEN x-grupo2 = "FACTURAS".    /*"FACTURAS/BOLETAS/DOC.COBRANZAS".*/*/
    IF ccbcdocu.coddoc = "FAC" THEN x-grupo2 = "FACTURA(S) PENDIENTE(S)".
    IF ccbcdocu.coddoc = "BOL" THEN x-grupo2 = "BOLETA(S) PENDIENTES(S)".
    IF ccbcdocu.coddoc = "DCO" THEN x-grupo2 = "DOCUMENTO(S) DE COBRANZA PENDIENTE(S)".
    IF ccbcdocu.coddoc = 'N/C' THEN x-grupo2 = "NOTAS DE CREDITO(S) PENDIENTE(S)".
    IF ccbcdocu.coddoc = 'N/D' THEN x-grupo2 = "NOTAS DE DEBITO(S) PENDIENTE(S)".
    IF ccbcdocu.coddoc = 'BD' THEN x-grupo2 = "BOLETA(S) DE DEPOSITO(S)".
    /* Signos */
    IF ccbcdocu.coddoc = 'A/R' THEN x-signo = -1.       
    IF ccbcdocu.coddoc = 'A/C' THEN x-signo = -1.       
    IF ccbcdocu.coddoc = 'LPA' THEN x-signo = -1.       /* Ticket 68717 */
    IF ccbcdocu.coddoc = 'N/C' THEN x-signo = -1.
    IF ccbcdocu.coddoc = 'BD' THEN x-signo = -1.
    
    CREATE w-report.
    ASSIGN
        w-report.task-no = s-task-no 
        w-report.llave-c = x-Grupo
        w-report.campo-c[1] = "1.- DOCUMENTOS"
        w-report.campo-c[2] = ccbcdocu.coddoc
        w-report.campo-c[3] = ccbcdocu.nrodoc
        w-report.campo-d[1] = ccbcdocu.fchdoc
        w-report.campo-d[2] = ccbcdocu.FchVto
        w-report.campo-c[4] = x-ubicacion
        w-report.campo-c[5] = x-situacion
        /*
        w-report.campo-c[4] = ccbcdocu.fmapgo
        w-report.campo-c[5] = IF(AVAILABLE gn-convt) THEN gn-convt.vencmtos ELSE ""
        */
        w-report.campo-c[6] = x-banco
        w-report.campo-c[7] = x-nrounico
        w-report.campo-f[1] = ccbcdocu.imptot 
        w-report.campo-c[8] = IF(ccbcdocu.codmon = 1) THEN "S/" ELSE "US$"
        w-report.campo-f[2] = ccbcdocu.sdoact
        w-report.campo-i[2] = IF (TODAY - CcbCDocu.FchVto) > 0 THEN (TODAY - CcbCDocu.FchVto) ELSE 0        
        w-report.campo-f[3] = ccbcdocu.sdoact     /* Para la sumatoria */
        /* para los subtotales */
        w-report.campo-f[4] = IF(ccbcdocu.codmon = 2) THEN 0 ELSE ccbcdocu.sdoact       /* Soles */
        w-report.campo-f[5] = IF(ccbcdocu.codmon = 2) THEN ccbcdocu.sdoact ELSE 0       /* Dolares */
        w-report.campo-f[6] = 0
        w-report.campo-f[7] = 0.
        
    /* para el total gral */
    IF ccbcdocu.coddoc = 'LET' AND ccbcdocu.flgest = 'X' THEN DO:
        /* B.- LETRAS POR ACEPTAR no suma al total general es referencial */
        ASSIGN w-report.campo-f[6] = 0
                w-report.campo-f[7] = 0.
    END.
    ELSE DO:
        ASSIGN w-report.campo-f[6] = IF(ccbcdocu.codmon = 2) THEN 0 ELSE ccbcdocu.sdoact       /* Soles */
                w-report.campo-f[7] = IF(ccbcdocu.codmon = 2) THEN ccbcdocu.sdoact ELSE 0.       /* Dolares */   
    END.
    ASSIGN 
        w-report.campo-f[6] = w-report.campo-f[6] * x-signo
        w-report.campo-f[7] = w-report.campo-f[7] * x-signo.
        
    ASSIGN  
        w-report.campo-c[25] = x-grupo2
        w-report.campo-c[26] = " ".         /* "DOCUMENTOS PENDIENTES". - Correo de Julissa Calderon 14Ago2018 */

    /* Para Letras pendientes por aceptar, guardo los canjes */        
    IF ccbcdocu.coddoc = 'LET' AND ccbcdocu.flgest = 'X' THEN DO:
        FIND FIRST ttTempo WHERE ttTempo.tcoddoc = CcbCDocu.codref AND
                                    ttTempo.tnrodoc = CcbCDocu.nroref NO-ERROR.
        IF NOT AVAILABLE ttTempo THEN DO:
            CREATE ttTempo.
                ASSIGN ttTempo.tcoddoc = CcbCDocu.codref
                        ttTempo.tnrodoc = CcbCDocu.nroref.
        END.
    END.

END.

/* Docuemntos que involucran el canje */
FOR EACH ttTempo.
    FOR EACH ccbdmvto WHERE ccbdmvto.codcia = s-codcia AND 
                                ccbdmvto.coddoc = ttTempo.tcoddoc AND 
                                ccbdmvto.nrodoc = ttTempo.tnrodoc NO-LOCK:

        FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                                    ccbcdocu.coddoc = ccbdmvto.codref AND 
                                    ccbcdocu.nrodoc = ccbdmvto.nroref NO-LOCK NO-ERROR.
        IF AVAILABLE ccbcdocu THEN DO:
            FIND FIRST gn-convt WHERE gn-convt.codig = ccbcdocu.fmapgo NO-LOCK NO-ERROR.
        END.       

        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no 
            w-report.llave-c = "B.- LETRAS POR ACEPTAR"
            w-report.campo-c[1] = "2.- DOCUMENTOS COMPROMETIDOS EN EL CANJE"
            w-report.campo-c[2] = ccbdmvto.codref
            w-report.campo-c[3] = ccbdmvto.nroref
            w-report.campo-d[1] = if(AVAILABLE ccbcdocu) THEN ccbcdocu.fchdoc ELSE ? 
            w-report.campo-d[2] = if(AVAILABLE ccbcdocu) THEN ccbcdocu.FchVto ELSE ?
            w-report.campo-c[4] = if(AVAILABLE ccbcdocu) THEN ccbcdocu.fmapgo ELSE ""
            w-report.campo-c[5] = IF(AVAILABLE gn-convt) THEN gn-convt.vencmtos ELSE ""
            w-report.campo-c[6] = "" 
            w-report.campo-c[7] = ""
            w-report.campo-c[8] = if(AVAILABLE ccbcdocu) THEN (IF(ccbcdocu.codmon = 1) THEN "S/" ELSE "US$") ELSE ""
            /* A pedido de Julisa Calderon con Autorizacion de Daniel Llican, 04Feb2019 - 16:11pm - Este no va
            w-report.campo-f[1] = if(AVAILABLE ccbcdocu) THEN (ccbdmvto.imptot * IF(ccbcdocu.codmon = 2) THEN ccbcdocu.tpocmb ELSE 1) ELSE 0            
            w-report.campo-f[2] = if(AVAILABLE ccbcdocu) THEN (ccbcdocu.sdoact * IF(ccbcdocu.codmon = 2) THEN ccbcdocu.tpocmb ELSE 1) ELSE 0 
            */
            w-report.campo-f[1] = if(AVAILABLE ccbcdocu) THEN ccbcdocu.imptot ELSE 0            
            w-report.campo-f[2] = if(AVAILABLE ccbcdocu) THEN ccbcdocu.sdoact ELSE 0 
            w-report.campo-i[2] = if(AVAILABLE ccbcdocu) THEN (IF (TODAY - CcbCDocu.FchVto) > 0 THEN (TODAY - CcbCDocu.FchVto) ELSE 0) ELSE 0
            w-report.campo-f[3] = 0
            /* Para el SubtTotal */
            w-report.campo-f[4] = IF(ccbcdocu.codmon = 2) THEN 0 ELSE ccbcdocu.sdoact       /* Soles */
            w-report.campo-f[5] = IF(ccbcdocu.codmon = 2) THEN ccbcdocu.sdoact ELSE 0       /* Dolares */
            /* Para el total GRAl, no considerar como deuda */
            w-report.campo-f[6] = 0
            w-report.campo-f[7] = 0
            .
        ASSIGN w-report.campo-c[25] = "LETRA(S) POR ACEPTAR"
                w-report.campo-c[26] = "DOCUMENTOS COMPROMETIDOS EN EL CANJE".
    END.
END.

RELEASE w-report.

x2 = NOW.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-eecc-enviar-pdf) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eecc-enviar-pdf Procedure 
PROCEDURE eecc-enviar-pdf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodCli AS CHAR.
DEFINE INPUT PARAMETER pRuta AS CHAR.

DEFINE VAR x-filename-pdf AS CHAR.

/* Fijar como DEFAULT la impresora del PDFCreator */
DEFINE VARIABLE x-current-printername AS CHARACTER NO-UNDO.

x-current-printername          = SESSION:PRINTER-NAME.

DEFINE VARIABLE x-new-printer-name AS CHARACTER.
DEFINE VARIABLE x-new-ireturn AS INTEGER.

IF CAPS(x-current-printername) <> "PDFCREATOR" THEN DO:
    x-new-printer-name = "PDFCreator".
    RUN SetDefaultPrinterA(INPUT x-new-printer-name, OUTPUT x-new-ireturn).

    IF x-new-ireturn <> 1 THEN DO:
        MESSAGE "No esta instalado la impresora " + x-new-printer-name.
        RETURN.
    END.

END.

/* Finaliza el proceso de PDFCreator si que estuviese en linea */
DOS Silent VALUE("taskkill /F /IM PDFCreator.exe /T").

/*Variáveis de instancia PDFCreator*/
DEFINE VARIABLE PDFObjQueue AS COM-HANDLE      NO-UNDO.
DEFINE VARIABLE PDFObj AS COM-HANDLE      NO-UNDO.
DEFINE VARIABLE PDFPrintJob AS COM-HANDLE      NO-UNDO.

/*DEFINE VARIABLE PDF AS COM-HANDLE      NO-UNDO.*/

CREATE "PDFCreator.PDFCreatorObj" pdfObj NO-ERROR.
IF NOT VALID-HANDLE (pdfobj) THEN DO:
    MESSAGE "NO esta instalado el PDFCreator" SKIP
            ERROR-STATUS:GET-MESSAGE(1).
    RETURN.
END.
CREATE "PDFCreator.JobQueue" PDFObjQueue NO-ERROR.
IF NOT VALID-HANDLE (PDFObjQueue) THEN DO:
    MESSAGE "NO se pudo crear el PDFObj" SKIP
            ERROR-STATUS:GET-MESSAGE(1).
    RETURN.
END.

PDFObjQueue:Initialize() NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    MESSAGE "NO se pudo inicializar la cola de impresion del PDFCreator" SKIP
            ERROR-STATUS:GET-MESSAGE(1).
END.

/* La impresora a imprimir */
DEFINE VAR x-filer AS CHAR.
x-filer = PDFObj:GetPDFCreatorPrinters.

RUN eecc-generar(INPUT pCodCli, INPUT YES).

/* Capturo en la cola de impresion del PDFCreator de lo enviado a imprimir  */
DEFINE VAR x-sec AS INT.
DEFINE VAR x-sec1 AS INT.

x-sec1 = 0.

ATRAPAR_PRINT:
REPEAT x-sec = 1 TO 15:
    PDFObjQueue:WaitForJob(1).
    IF PDFObjQueue:COUNT = 0 THEN DO:
        /**/
    END.
    ELSE DO:
        pdfPrintJob = PDFObjQueue:NextJob.
        x-sec1 = 1.
        LEAVE ATRAPAR_PRINT.
    END.
END.


IF x-sec1 = 0 THEN DO:
    /**/
END.
ELSE DO:
    pdfPrintJob:SetProfileByGuid("DefaultGuid").
    pdfPrintJob:SetProfileSetting("ShowProgress", "False").
    /*
    pdfObj:SetProfileSetting("TargetDirectory","D:\tmp").
    pdfObj:SetProfileSetting("OutputFormat","Jpeg").
    pdfObj:SetProfileSetting("Printing.SelectPrinter","SelectedPrinter").
    pdfObj:SetProfileSetting("Printing.PrinterName","PDFCreator").    
    */

    /* OJO: pRuta debe terminar en "\" o "/" */
    IF SUBSTRING(pRuta, LENGTH(pRuta),1) <> "\" OR
        SUBSTRING(pRuta, LENGTH(pRuta),1) <> "/"
        THEN pRuta = TRIM(pRuta) + "\".

    x-filename-pdf = pRuta + 
                    pCodCli + "EECC" + STRING(YEAR(NOW),"9999") + STRING(MONTH(NOW),"99") + STRING(DAY(NOW),"99").

    /*pdfPrintJob:ConvertTo("d:\COMPRO-FAC-26300003515").*/
    pdfPrintJob:ConvertTo(x-filename-pdf).
END.

/*encerrar processo*/
pdfobjQueue:ReleaseCom.

RELEASE OBJECT pdfobj.
RELEASE OBJECT pdfPrintJob NO-ERROR.
RELEASE OBJECT PDFObjQueue.

/* Finalizo el proceso */
DOS Silent VALUE("taskkill /F /IM PDFCreator.exe /T").

/* Devuelvo el defaulto de la impresora */
RUN SetDefaultPrinterA(INPUT x-current-printername, OUTPUT x-new-ireturn).


IF x-sec1 = 0 THEN DO:
    RETURN "ADM-ERROR".
END.
ELSE DO:
    RETURN "OK".
END.

END PROCEDURE.

PROCEDURE SetDefaultPrinterA EXTERNAL "WINSPOOL.drv":U :
DEFINE INPUT PARAMETER pszPrinter AS CHARACTER.
DEFINE RETURN PARAMETER ireturn AS LONG.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-eecc-generar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eecc-generar Procedure 
PROCEDURE eecc-generar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodCli AS CHAR.
DEFINE INPUT PARAMETER pToPDF AS LOG.           /* YES: Directo a PDF */

DEF VAR RB-REPORT-LIBRARY AS CHAR.  /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.     /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR. /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.  /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     /* Otros parametros */

DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

/* capturamos ruta inicial */
DEF VAR S-REPORT-LIBRARY AS CHAR.
GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE s-report-library.

DEFINE VAR x-linea-credito AS DEC.
DEFINE VAR x-credito-utilizado AS DEC.
DEFINE VAR x-credito-disponible AS DEC.

DEFINE VAR x-mone-linea-credito AS INT.

/* creo el temporal */ 
REPEAT:
    s-task-no = RANDOM(1, 999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no
                    /*AND w-report.llave-c = s-user-id*/ NO-LOCK)
        THEN DO:
        
        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no
            w-report.llave-c = "**BORRAR-LINEA**".        
        LEAVE.
    END.
END.

SESSION:SET-WAIT-STATE('GENERAL').

RUN eecc-cargar-documentos(INPUT pCodCli).

SESSION:SET-WAIT-STATE('').

RUN get-linea-de-credito(INPUT pCodCli, OUTPUT x-mone-linea-credito, OUTPUT x-linea-credito).
RUN get-linea-de-credito-usado(INPUT pCodCli, INPUT x-mone-linea-credito, OUTPUT x-credito-utilizado).

x-credito-disponible = x-linea-credito - x-credito-utilizado.

FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = pCodCli NO-LOCK NO-ERROR.

IF AVAILABLE gn-clie THEN DO:
    FIND FIRST gn-ven WHERE gn-ven.codcia = s-codcia AND 
                            gn-ven.codven = gn-clie.codven NO-LOCK NO-ERROR.
END.
ELSE DO:
    FIND FIRST gn-ven WHERE gn-ven.codcia = s-codcia AND 
                            gn-ven.codven = "*NOCLIENTE*" NO-LOCK NO-ERROR.
END.

GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
ASSIGN
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'ccb/rbccb.prl'
    RB-REPORT-NAME = 'eecc-clientes'       
    RB-INCLUDE-RECORDS = 'O'.

RB-FILTER = " w-report.task-no = " + STRING(s-task-no) + " and w-report.llave-c <> ''".

RB-OTHER-PARAMETERS = "s-nomcli = " + IF(AVAILABLE gn-clie) THEN gn-clie.nomcli ELSE " ".
RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS + "~ns-direccion = " + IF(AVAILABLE gn-clie) THEN gn-clie.dircli ELSE " ".
RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS + "~ns-hasta = " + STRING(TODAY,"99/99/9999").
RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS + "~ns-ruc = " + IF(AVAILABLE gn-clie) THEN gn-clie.ruc ELSE " ".
RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS + "~ns-linea-credito = " + STRING(x-linea-credito,"->>,>>>,>>>,>>9.99").
RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS + "~ns-credito-utilizado = " + string(x-credito-utilizado,"->>,>>>,>>>,>>9.99").
RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS + "~ns-credito-disponible = " + string(x-credito-disponible,"->>,>>>,>>>,>>9.99").
RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS + "~ns-telefono = 715-8888".
RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS + "~ns-fax = 715-8888".
RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS + "~ns-vendedor = " + IF(AVAILABLE gn-ven) THEN gn-ven.nomven ELSE "".
                              

IF pToPDF = NO THEN DO:
    RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                        RB-REPORT-NAME,
                        RB-INCLUDE-RECORDS,
                        RB-FILTER,
                        RB-OTHER-PARAMETERS).
END.
ELSE DO:

    DEF VAR success AS LOGICAL.
    /* 2 Capturo la impresora por defecto */
    RUN lib/_default_printer.p (OUTPUT s-printer-name, OUTPUT s-port-name, OUTPUT success).
    /* 3 */
    IF success = NO THEN DO:
        MESSAGE "NO hay una impresora por defecto definida" VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    /* 4 De acuerdo al sistema operativo transformamos el puerto de impresión */
    RUN lib/_port-name-v2.p (s-Printer-Name, OUTPUT s-Port-Name).

    DEFINE VARIABLE cDatabaseName    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cHostName        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cNetworkProto    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cPortNumber      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cOtherParams     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cNewConnString   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDelimeter       AS CHARACTER NO-UNDO.

    GET-KEY-VALUE SECTION "RBParametros" KEY "cDatabaseName" VALUE cDatabaseName.
    GET-KEY-VALUE SECTION "RBParametros" KEY "cHostName" VALUE cHostName.
    GET-KEY-VALUE SECTION "RBParametros" KEY "cNetworkProto" VALUE cNetworkProto.
    GET-KEY-VALUE SECTION "RBParametros" KEY "cPortNumber" VALUE cPortNumber.
    GET-KEY-VALUE SECTION "RBParametros" KEY "cOtherParams" VALUE cOtherParams.

    ASSIGN cDelimeter = CHR(32).
    IF NOT (cDatabaseName = ? OR cHostName = ? OR cNetworkProto = ? OR cPortNumber = ?) THEN DO:
        DEFINE VAR x-rb-user AS CHAR.
        DEFINE VAR x-rb-pass AS CHAR.

        RUN lib/RB_credenciales(OUTPUT x-rb-user, OUTPUT x-rb-pass).

        IF x-rb-user = "**NOUSER**" THEN DO:
            MESSAGE "No se pudieron ubicar las credenciales para" SKIP
                    "la conexion del REPORTBUILDER" SKIP
                    "--------------------------------------------" SKIP
                    "Comunicarse con el area de sistemas - desarrollo"
                VIEW-AS ALERT-BOX INFORMATION.

            SESSION:SET-WAIT-STATE('').

            RETURN "ADM-ERROR".
        END.

       ASSIGN
           cNewConnString =
           "-db" + cDelimeter + cDatabaseName + cDelimeter +
           "-H" + cDelimeter + cHostName + cDelimeter +
           "-N" + cDelimeter + cNetworkProto + cDelimeter +
           "-S" + cDelimeter + cPortNumber + cDelimeter +
           "-U " + x-rb-user  + cDelimeter + cDelimeter +
           "-P " + x-rb-pass + cDelimeter + cDelimeter.
       IF cOtherParams > '' THEN cNewConnString = cNewConnString + cOtherParams + cDelimeter.
       RB-DB-CONNECTION = cNewConnString.
    END.
    ASSIGN 
        RB-BEGIN-PAGE = 1
        RB-END-PAGE = 9999
        RB-PRINTER-NAME = s-port-name       /*s-printer-name*/
        /*RB-PRINTER-PORT = s-port-name*/
        RB-OUTPUT-FILE = s-print-file
        RB-NUMBER-COPIES = s-nro-copias.

    CASE s-salida-impresion:
      WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
      WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
      WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
    END CASE.

    RUN aderb/_prntrb2 (RB-REPORT-LIBRARY,
                      RB-REPORT-NAME,
                      RB-DB-CONNECTION,
                      RB-INCLUDE-RECORDS,
                      RB-FILTER,
                      RB-MEMO-FILE,
                      RB-PRINT-DESTINATION,
                      RB-PRINTER-NAME,
                      RB-PRINTER-PORT,
                      RB-OUTPUT-FILE,
                      RB-NUMBER-COPIES,
                      RB-BEGIN-PAGE,
                      RB-END-PAGE,
                      RB-TEST-PATTERN,
                      RB-WINDOW-TITLE,
                      RB-DISPLAY-ERRORS,
                      RB-DISPLAY-STATUS,
                      RB-NO-WAIT,
                      RB-OTHER-PARAMETERS,  
                      "").

END.

/* Borar el temporal */
SESSION:SET-WAIT-STATE('GENERAL').
DEF BUFFER B-w-report FOR w-report.
DEFINE VAR lRowId AS ROWID.

FOR EACH w-report WHERE w-report.task-no = s-task-no NO-LOCK:
    lRowId = ROWID(w-report).
    FIND FIRST b-w-report WHERE ROWID(b-w-report) = lRowid EXCLUSIVE NO-ERROR.
    IF AVAILABLE b-w-report THEN DO:
        DELETE b-w-report.            
    END.    
END.

RELEASE B-w-report.

SESSION:SET-WAIT-STATE('').


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-eecc-imprimir) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eecc-imprimir Procedure 
PROCEDURE eecc-imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodCli AS CHAR.
DEFINE INPUT PARAMETER pToPDF AS LOG.
DEFINE INPUT PARAMETER pRuta AS CHAR.

IF pToPDF = YES THEN DO:
    IF TRUE <> (pRuta > "") THEN DO:
        pRuta = SESSION:TEMP-DIRECTORY.
    END.
END.

IF pToPDF = YES THEN DO:
    RUN eecc-enviar-pdf(INPUT pCodCli, INPUT pRuta).
END.
ELSE DO:
    RUN eecc-generar(INPUT pCodCli, INPUT NO).
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-linea-de-credito) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-linea-de-credito Procedure 
PROCEDURE get-linea-de-credito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pCodCli AS CHAR.
    DEFINE OUTPUT PARAMETER pMonedaLineaCredito AS INT.
    DEFINE OUTPUT PARAMETER pLineaCredito AS DEC.

    RUN ccb/p-implc (cl-codcia,
                     pCodCli,
                     s-coddiv,
                     OUTPUT pMonedaLineaCredito,
                     OUTPUT pLineaCredito).



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-linea-de-credito-usado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-linea-de-credito-usado Procedure 
PROCEDURE get-linea-de-credito-usado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pCodCli AS CHAR.
    DEFINE INPUT PARAMETER pMonedaLineaCreditoUsado AS INT.
    DEFINE OUTPUT PARAMETER pLineaCreditoUsado AS DEC.

    RUN ccb/p-saldo-actual-cliente (pCodCli,
                                    s-CodDiv,
                                    pMonedaLineaCreditoUsado,
                                    OUTPUT pLineaCreditoUsado).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-grupo-moroso) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grupo-moroso Procedure 
PROCEDURE grupo-moroso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodcli AS CHAR.
DEFINE INPUT PARAMETER pToleranciaDias AS INT.
DEFINE OUTPUT PARAMETER pRetVal AS LOG NO-UNDO.

DEF VAR LocalMaster AS CHAR.
DEF VAR LocalRelacionados AS CHAR.
DEF VAR LocalAgrupados AS LOG.
DEF VAR LocalCliente AS CHAR NO-UNDO.

RUN ccb/p-cliente-master.r(INPUT pCodCli,
                          OUTPUT LocalMaster,
                          OUTPUT LocalRelacionados,
                          OUTPUT LocalAgrupados).

IF LocalAgrupados = YES AND LocalRelacionados > '' THEN .
ELSE LocalRelacionados = pCodCli.

pRetVal = NO.

IF pToleranciaDias < 0 THEN pToleranciaDias = 0.

FIND FIRST CcbCDocu WHERE CcbCDocu.CodCia = FacCPedi.CodCia
    AND  LOOKUP(CcbCDocu.CodCli, LocalRelacionados) > 0     /* = FacCPedi.Codcli */
    AND  CcbCDocu.FlgEst = "P"
    AND  LOOKUP(CcbCDocu.CodDoc, "FAC,BOL,CHQ,LET,N/D") > 0
    AND  (CcbCDocu.FchVto + pToleranciaDias ) < TODAY     /* N dias de plazo */
    AND  ccbcdocu.sdoact > 0
    NO-LOCK NO-ERROR.
IF AVAIL CcbCDocu THEN DO:
    pRetVal = YES.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-letra-origen-del-movimiento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE letra-origen-del-movimiento Procedure 
PROCEDURE letra-origen-del-movimiento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.      /* LET */
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE OUTPUT PARAMETER pCodMov AS CHAR.     /* Deberia ser CJE o CLA */
DEFINE OUTPUT PARAMETER pNroMov AS CHAR.

DEFINE VAR x-sec AS INT.
DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nrodoc AS CHAR.

pCodMov = "".
pNroMov = "".
x-coddoc = pCodDoc.
x-nrodoc = pNroDoc.

LOOP:
REPEAT x-sec = 1 TO 100:
    FIND FIRST x-trazabilidad-mov WHERE x-trazabilidad-mov.codcia = s-codcia AND 
                                        x-trazabilidad-mov.coddoc = x-CodDoc AND
                                        x-trazabilidad-mov.nrodoc = x-NroDoc NO-LOCK NO-ERROR.
    IF AVAILABLE x-trazabilidad-mov THEN DO:
        pCodMov = x-trazabilidad-mov.codmov.
        pNroMov = x-trazabilidad-mov.nromov.
        /**/
        x-coddoc = x-trazabilidad-mov.codref.
        x-nrodoc = x-trazabilidad-mov.nroref.
        IF TRUE <> (x-coddoc > "") THEN DO:
            LEAVE LOOP.
        END.
    END.
    ELSE DO:
        LEAVE LOOP.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-maximo-nc-pnc-x-articulo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE maximo-nc-pnc-x-articulo Procedure 
PROCEDURE maximo-nc-pnc-x-articulo :
/*------------------------------------------------------------------------------
  Purpose:     Dado un concepto de nota de credito cuantas veces puede usar
               a un codigo de articulo.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pConcepto AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pCantidad AS INT NO-UNDO.

DEFINE VAR x-tabla AS CHAR INIT "TIPO_DSCTO_CONC".
pCantidad = 1.

FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                            vtatabla.tabla = x-tabla AND
                            vtatabla.llave_c1 = pConcepto NO-LOCK NO-ERROR.
IF AVAILABLE vtatabla THEN DO:
    IF (TODAY >= vtatabla.rango_fecha[1] AND TODAY <= vtatabla.rango_fecha[2]) THEN pCantidad = vtatabla.rango_valor[1].
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-notas-credito-del-comprobante) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE notas-credito-del-comprobante Procedure 
PROCEDURE notas-credito-del-comprobante :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pConceptoNC AS CHAR NO-UNDO. /* (* = Todos) */
DEFINE INPUT PARAMETER pCodDoc AS CHAR NO-UNDO.     /* FAC,BOL */
DEFINE INPUT PARAMETER pNroDoc AS CHAR NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tw-report.

DEFINE VAR x-cantidad AS INT INIT 0.
DEFINE VAR x-estado AS CHAR.

DEFINE VAR x-valido AS CHAR.

/* LIMPIAR */
EMPTY TEMP-TABLE tw-report.

/* PNC pendientes de Aprobar */
FOR EACH x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                            x-ccbcdocu.codref = pCodDoc AND
                            x-ccbcdocu.nroref = pNroDoc AND
                            x-ccbcdocu.coddoc = "PNC" AND
                            /*x-ccbcdocu.tpofac = 'OTROS' AND     /* con detalle de articulo */*/
                            LOOKUP(x-ccbcdocu.flgest,"E,T,AP,D,P") > 0 NO-LOCK :   
    /* Por Aprobar, Generada, Aprobacion parcial, En proceso, Aprobado */

    x-valido = 'SI'.
    IF pConceptoNC <> '*' THEN DO:
        x-valido = 'NO'.
        IF x-ccbcdocu.codcta = pConceptoNC THEN x-valido = 'SI'.
    END.

    IF x-valido = 'SI' THEN DO:
        CREATE tw-report.
        ASSIGN tw-report.campo-c[1] = x-ccbcdocu.coddoc
                tw-report.campo-c[2] = x-ccbcdocu.nrodoc
                tw-report.campo-c[3] = x-ccbcdocu.coddiv
                tw-report.campo-c[4] = IF ( x-ccbcdocu.codmon = 2) THEN "DOLARES" ELSE "SOLES"
                tw-report.campo-c[5] = x-ccbcdocu.codcta        /* Concepto */
                tw-report.campo-c[6] = x-ccbcdocu.codcli
                tw-report.campo-d[1] = x-ccbcdocu.fchdoc
                tw-report.campo-f[1] = x-ccbcdocu.TotalPrecioVenta      /* Airmetica Sunat */
                tw-report.campo-f[2] = x-ccbcdocu.tpocmb
            .
        IF tw-report.campo-f[1] <= 0 THEN ASSIGN tw-report.campo-f[1] = x-ccbcdocu.imptot.
    END.
    
END.
/* N/C  */
FOR EACH x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                            x-ccbcdocu.codref = pCodDoc AND
                            x-ccbcdocu.nroref = pNroDoc AND
                            x-ccbcdocu.coddoc = "N/C" AND
                            /*x-ccbcdocu.tpofac = 'OTROS' AND     /* con detalle de articulo */*/
                            x-ccbcdocu.flgest <> 'A' NO-LOCK :  
    x-valido = 'SI'.
    IF pConceptoNC <> '*' THEN DO:
        x-valido = 'NO'.
        IF x-ccbcdocu.codcta = pConceptoNC THEN x-valido = 'SI'.
    END.

    IF x-valido = 'SI' THEN DO:
        CREATE tw-report.
        ASSIGN tw-report.campo-c[1] = x-ccbcdocu.coddoc
                tw-report.campo-c[2] = x-ccbcdocu.nrodoc
                tw-report.campo-c[3] = x-ccbcdocu.coddiv
                tw-report.campo-c[4] = IF ( x-ccbcdocu.codmon = 2) THEN "DOLARES" ELSE "SOLES"
                tw-report.campo-c[5] = x-ccbcdocu.codcta        /* Concepto */
                tw-report.campo-c[6] = x-ccbcdocu.codcli
                tw-report.campo-d[1] = x-ccbcdocu.fchdoc
                tw-report.campo-f[1] = x-ccbcdocu.TotalPrecioVenta      /* Airmetica Sunat */
                tw-report.campo-f[2] = x-ccbcdocu.tpocmb
            .
        IF tw-report.campo-f[1] <= 0 THEN ASSIGN tw-report.campo-f[1] = x-ccbcdocu.imptot.
    END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-notas-creditos-supera-comprobante) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE notas-creditos-supera-comprobante Procedure 
PROCEDURE notas-creditos-supera-comprobante :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR NO-UNDO.     /* FAC,BOL */
DEFINE INPUT PARAMETER pNroDoc AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

/*
    pRetVal =   SI : Todas la N/C superan al comprobante
                NO : No supera
*/

pRetVal = "NO".

FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                            x-ccbcdocu.coddoc = pCodDOc AND 
                            x-ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-ccbcdocu THEN RETURN.

/* Notas de Creditos que hacen referencia al comprobante */
RUN notas-credito-del-comprobante(INPUT "*", INPUT pCodDoc, INPUT pNroDoc,
                                           INPUT-OUTPUT TABLE tw-report).
DEFINE VAR x-importe-cmpbte AS DEC.
DEFINE VAR x-importe-nc AS DEC.
DEFINE VAR x-mone-cmpbte AS CHAR.

/* Del Comprobante */
FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                            x-ccbcdocu.coddoc = pCodDOc AND 
                            x-ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.

x-mone-cmpbte = IF ( x-ccbcdocu.codmon = 2) THEN "DOLARES" ELSE "SOLES".

x-importe-cmpbte = x-ccbcdocu.TotalPrecioVenta. /* con la aritmetica de sunat */
IF x-importe-cmpbte = 0 THEN x-importe-cmpbte = x-ccbcdocu.imptot.

/* Ic - 15Dic2021 - Verificamos si tiene A/C para sacar le importe real del comprobante */
IF x-ccbcdocu.imptot2 > 0 THEN DO:
    FIND FIRST FELogComprobantes WHERE FELogComprobantes.codcia = s-codcia AND
                                    FELogComprobantes.coddoc = x-ccbcdocu.coddoc AND
                                    FELogComprobantes.nrodoc = x-ccbcdocu.nrodoc NO-LOCK NO-ERROR.
    IF AVAILABLE FELogComprobantes THEN DO:
        IF NUM-ENTRIES(FELogComprobantes.dataQR,"|") > 5 THEN DO:
            IF x-importe-cmpbte = 0 THEN x-importe-cmpbte = DEC(TRIM(ENTRY(6,FELogComprobantes.dataQR,"|"))).
        END.
    END.
END.

FOR EACH tw-report NO-LOCK:
    IF x-mone-cmpbte = tw-report.campo-c[4] THEN DO:
        x-importe-nc = x-importe-nc + tw-report.campo-f[1].
    END.
    ELSE DO:
        x-importe-nc = x-importe-nc + (tw-report.campo-f[1] * tw-report.campo-f[2]).
    END.
END.

IF x-importe-nc > x-importe-cmpbte THEN pRetVal = 'SI'.

END PROCEDURE.

/*
        ASSIGN tw-report.campo-c[1] = x-ccbcdocu.coddoc
                tw-report.campo-c[2] = x-ccbcdocu.nrodoc
                tw-report.campo-c[3] = x-ccbcdocu.coddiv
                tw-report.campo-c[4] = IF ( x-ccbcdocu.codmon = 2) THEN "DOLARES" ELSE "SOLES"
                tw-report.campo-c[5] = x-ccbcdocu.codcta        /* Concepto */
                tw-report.campo-c[6] = x-ccbcdocu.codcli
                tw-report.campo-d[1] = x-ccbcdocu.fchdoc
                tw-report.campo-f[1] = x-ccbcdocu.imptot
                tw-report.campo-f[2] = x-ccbcdocu.tpocmb

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-notas-debito-del-comprobante) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE notas-debito-del-comprobante Procedure 
PROCEDURE notas-debito-del-comprobante :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pConceptoNC AS CHAR NO-UNDO. /* (* = Todos) */
DEFINE INPUT PARAMETER pCodDoc AS CHAR NO-UNDO.     /* FAC,BOL */
DEFINE INPUT PARAMETER pNroDoc AS CHAR NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tw-report.

DEFINE VAR x-cantidad AS INT INIT 0.
DEFINE VAR x-estado AS CHAR.

DEFINE VAR x-valido AS CHAR.

/* LIMPIAR */
EMPTY TEMP-TABLE tw-report.

/* N/D que hacen referencia al comprobante (pCodDoc, pNroDoc) */
FOR EACH x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                            x-ccbcdocu.codref = pCodDoc AND
                            x-ccbcdocu.nroref = pNroDoc AND
                            x-ccbcdocu.coddoc = "N/D" AND
                            x-ccbcdocu.flgest <> "A" NO-LOCK :
    x-valido = 'SI'.
    IF pConceptoNC <> '*' THEN DO:
        x-valido = 'NO'.
        IF x-ccbcdocu.codcta = pConceptoNC THEN x-valido = 'SI'.
    END.

    IF x-valido = 'SI' THEN DO:
        CREATE tw-report.
        ASSIGN tw-report.campo-c[1] = x-ccbcdocu.coddoc
                tw-report.campo-c[2] = x-ccbcdocu.nrodoc
                tw-report.campo-c[3] = x-ccbcdocu.coddiv
                tw-report.campo-c[4] = IF ( x-ccbcdocu.codmon = 2) THEN "DOLARES" ELSE "SOLES"
                tw-report.campo-c[5] = x-ccbcdocu.codcta        /* Concepto */
                tw-report.campo-c[6] = x-ccbcdocu.codcli
                tw-report.campo-d[1] = x-ccbcdocu.fchdoc
                tw-report.campo-f[1] = x-ccbcdocu.imptot
                tw-report.campo-f[2] = x-ccbcdocu.tpocmb
            .
    END.
    
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-numero-anticipo-x-canje-adelantado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE numero-anticipo-x-canje-adelantado Procedure 
PROCEDURE numero-anticipo-x-canje-adelantado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodMov AS CHAR.      /* CLA */
DEFINE INPUT PARAMETER pNroMov AS CHAR.
DEFINE OUTPUT PARAMETER pCoddoc AS CHAR.     /* Deberia ser LPA o A/R */
DEFINE OUTPUT PARAMETER pNroDoc AS CHAR.

DEFINE VAR x-sec AS INT.

pCodDoc = "".
pNroDoc = "".

LOOP:
FOR EACH x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                            x-ccbcdocu.codref = pCodMov AND
                            x-ccbcdocu.nroref = pNroMov AND 
                            x-ccbcdocu.coddoc <> 'LET' AND 
                            x-ccbcdocu.flges <> 'A' NO-LOCK:
    IF LOOKUP(x-ccbcdocu.coddoc,'LPA,A/R') > 0 THEN DO:
        pCodDoc = x-ccbcdocu.coddoc.
        pNroDoc = x-ccbcdocu.nrodoc.
        LEAVE LOOP.
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-precio-impsto-bolsas-plastica) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE precio-impsto-bolsas-plastica Procedure 
PROCEDURE precio-impsto-bolsas-plastica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pFecha AS DATE.
DEFINE OUTPUT PARAMETER pPrecioImpsto AS DEC.

DEFINE VAR x-tabla AS CHAR INIT "IMPSTO_BOL_PLASTICA".
DEFINE VAR x-fecha AS DATE.

x-fecha = pFecha.

/* Indica que la configuracion para el precio del impsto a la bolsa NO esta configurado*/
pPrecioImpsto = -9.99.

FIND FIRST factabla WHERE factabla.codcia = s-codcia AND
                            factabla.tabla = x-tabla AND
                            (x-fecha >= factabla.campo-d[1] AND x-fecha <= factabla.campo-d[2])
                             NO-LOCK NO-ERROR.
IF AVAILABLE factabla THEN DO:
    pPrecioImpsto = factabla.valor[1].
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-serie-cambia-fecha) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serie-cambia-fecha Procedure 
PROCEDURE serie-cambia-fecha :
/*------------------------------------------------------------------------------
  Purpose:  Dado una tipo documento y la serie, verificamos si este puede
            modificar la fecha de emision. Se usa en notas de credito
               pronto pago
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDOc AS CHAR.
DEFINE INPUT PARAMETER pSerie AS CHAR. 
DEFINE OUTPUT PARAMETER pRetVal AS LOG.
 
pRetVal = NO.

FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                            vtatabla.tabla = 'SERIE-MOD-FEMISION' AND
                            vtatabla.llave_c1 = pCodDOc AND
                            vtatabla.llave_c2 = pSerie NO-LOCK NO-ERROR.

IF AVAILABLE vtatabla AND vtatabla.libre_c01 = 'SI' THEN DO:
    pRetVal = YES.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sumar-imptes-nc_ref-cmpte) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sumar-imptes-nc_ref-cmpte Procedure 
PROCEDURE sumar-imptes-nc_ref-cmpte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pConceptoNC AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pCodDoc AS CHAR NO-UNDO.     /* FAC,BOL */
DEFINE INPUT PARAMETER pNroDoc AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pImpte AS DEC NO-UNDO.

DEFINE VAR x-impte AS DEC INIT 0.
DEFINE VAR x-estado AS CHAR.

/*
    pCantidad : devuelve la cantidad de N/C y/o PNC (PNC pendientes de generar N/C) tiene referenciado a pNroDoc
*/

RUN notas-credito-del-comprobante(INPUT pConceptoNC, INPUT pCodDoc, INPUT pNroDoc,
                                           INPUT-OUTPUT TABLE tw-report).
FOR EACH tw-report NO-LOCK:
    x-impte = x-impte + tw-report.campo-f[1].
END.

pImpte = x-Impte.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trazabilidad-inicial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trazabilidad-inicial Procedure 
PROCEDURE trazabilidad-inicial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodMov AS CHAR.     /* N/B, I/C */
DEFINE INPUT PARAMETER pNroMov AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

IF pCodMov = 'N/B' THEN DO:
    RUN trazabilidad-notas-bancarias(INPUT pCodMov, INPUT pNroMov, OUTPUT pRetval).
    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
END.
IF pCodMov = 'I/C' THEN DO:
    RUN trazabilidad-liquidaciones-caja(INPUT pCodMov, INPUT pNroMov, OUTPUT pRetval).
    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
END.

pRetVal = "OK".

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trazabilidad-liquidaciones-caja) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trazabilidad-liquidaciones-caja Procedure 
PROCEDURE trazabilidad-liquidaciones-caja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodMov AS CHAR.     /* I/C */
DEFINE INPUT PARAMETER pNroMov AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR.

pRetVal = "PROCESANDO".

EMPTY TEMP-TABLE x-w-report.

FOR EACH y-Ccbdcaja NO-LOCK WHERE y-Ccbdcaja.CodCia = s-codcia
    AND y-Ccbdcaja.CodDoc = pCodMov         /* I/C */
    AND y-Ccbdcaja.NroDoc = pNroMov :

    IF y-Ccbdcaja.codref = "LET" THEN DO:

        RUN trazabilidad-mov-del-lpa(INPUT pCodMov, 
                                     INPUT pNroMov,      /* I/C */
                                     INPUT y-Ccbdcaja.codref, 
                                     INPUT y-Ccbdcaja.nroref,   /* LET */
                                     INPUT y-Ccbdcaja.imptot, 
                                     OUTPUT pRetVal).
    END.
END.

/* Toda la trazabilidad de las letras contenidas en el I/C */
EMPTY TEMP-TABLE tw-report.

FOR EACH x-w-report:
    FIND FIRST tw-report WHERE tw-report.campo-c[3] = x-w-report.campo-c[3]     /* LET */
                                AND tw-report.campo-c[4] = x-w-report.campo-c[4]
                                AND tw-report.campo-c[5] = x-w-report.campo-c[5]   /* I/C del uso del LPA o A/R */
                                AND tw-report.campo-c[6] = x-w-report.campo-c[6]
                                AND tw-report.campo-c[7] = x-w-report.campo-c[7]    /* FAC,BOL, DCO,.... */
                                AND tw-report.campo-c[8] = x-w-report.campo-c[8] EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE tw-report THEN DO:
        CREATE tw-report.
            ASSIGN tw-report.campo-c[3] = x-w-report.campo-c[3]     /* LET */
                    tw-report.campo-c[4] = x-w-report.campo-c[4]
                    tw-report.campo-c[5] = x-w-report.campo-c[5]   /* I/C del uso del LPA o A/R */
                    tw-report.campo-c[6] = x-w-report.campo-c[6]
                    tw-report.campo-c[7] = x-w-report.campo-c[7]    /* FAC,BOL, DCO,.... */
                    tw-report.campo-c[8] = x-w-report.campo-c[8]
                    tw-report.campo-f[1] = 0
                    tw-report.campo-f[2] = 0
                    .
    END.
    ASSIGN tw-report.campo-f[1] = tw-report.campo-f[1] + x-w-report.campo-f[1]
            tw-report.campo-f[2] = tw-report.campo-f[2] + x-w-report.campo-f[2].
END.

/* Grabo la trazabilidad */

pRetVal = "PROCESANDO".

TRAZABILIDAD:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH tw-report:
    
        CREATE b-trazabilidad-mov.
        ASSIGN  b-trazabilidad-mov.codcia = s-codcia
                b-trazabilidad-mov.coddoc = tw-report.campo-c[3]     /* LET */
                b-trazabilidad-mov.nrodoc = tw-report.campo-c[4]
                b-trazabilidad-mov.codcmpte = tw-report.campo-c[7]    /* FAC,BOL, DCO,.... */
                b-trazabilidad-mov.nrocmpte = tw-report.campo-c[8]
                b-trazabilidad-mov.impcalculado = tw-report.campo-f[1]
                b-trazabilidad-mov.imporigen = 0
                b-trazabilidad-mov.codref = ""
                b-trazabilidad-mov.nroref = ""
                b-trazabilidad-mov.codmov = tw-report.campo-c[5]   /* I/C del uso del LPA o A/R */
                b-trazabilidad-mov.nromov = tw-report.campo-c[6]
                b-trazabilidad-mov.usrcrea = USERID("DICTDB")
                b-trazabilidad-mov.fchcrea = TODAY
                b-trazabilidad-mov.horacrea = STRING(TIME,"HH:MM:SS")
                NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pRetVal = "ERROR trazabilidad-liquidaciones-cancelaciones: " + tw-report.campo-c[3] + " " + tw-report.campo-c[4] + CHR(10) + CHR(13) +
                    "Comprobante :" + tw-report.campo-c[7] + " " + tw-report.campo-c[8] + CHR(10) + CHR(13) +
                    "MSG : " + ERROR-STATUS:GET-MESSAGE(1).
    
            UNDO TRAZABILIDAD, RETURN 'ADM-ERROR'.
        END.
    
    END.
END.
RELEASE b-trazabilidad-mov NO-ERROR.

pRetVal = "OK".

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trazabilidad-mov-del-lpa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trazabilidad-mov-del-lpa Procedure 
PROCEDURE trazabilidad-mov-del-lpa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodMov AS CHAR.     /* N/B, I/C */
DEFINE INPUT PARAMETER pNroMov AS CHAR.
DEFINE INPUT PARAMETER pCodDoc AS CHAR.     /* LET */
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE INPUT PARAMETER pImpteLetra AS DEC.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR.

DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nrodoc AS CHAR.
DEFINE VAR x-codmov AS CHAR.
DEFINE VAR x-nromov AS CHAR.

DEFINE VAR x-monto-lpa-ar AS DEC.
DEFINE VAR x-monto-lpa-ar-usado AS DEC.
DEFINE VAR x-total AS DEC.

DEFINE VAR x-suma AS DEC.
DEFINE VAR x-conteo AS INT.
DEFINE VAR x-conteoX AS INT.

x-codmov = "".
x-nromov = "".
/* Movimiento de origen de la LETRA */
RUN letra-origen-del-movimiento(INPUT pCodDoc, INPUT pNroDoc, 
                                          OUTPUT x-codmov, OUTPUT x-nromov).

IF x-codmov = 'CLA' THEN DO:

    x-coddoc = "".
    x-nrodoc = "".
    /* Es un canje de letra adelantada, devuelve el numero del LPA o A/R */
    RUN numero-anticipo-x-canje-adelantado(INPUT x-codmov, INPUT x-nromov, 
                                              OUTPUT x-coddoc, OUTPUT x-nrodoc).
    /* Monto del LPA o A/R */
    FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                                    x-ccbcdocu.coddoc = x-coddoc AND 
                                    x-ccbcdocu.nrodoc = x-nrodoc NO-LOCK NO-ERROR.
    x-monto-lpa-ar = 0.
    IF AVAILABLE x-ccbcdocu THEN x-monto-lpa-ar = x-ccbcdocu.imptot.    /* El monto total del LPA o A/R */

    /* Todas las cancelaciones en donde uso el LPA o A/R */
    FOR EACH x-ccbccaja WHERE x-ccbccaja.codcia = s-codcia and x-ccbccaja.tipo = 'CANCELACION' and 
                            x-ccbccaja.coddoc = 'I/C' and x-ccbccaja.codbco[7] = x-coddoc AND
                            x-ccbccaja.voucher[7] = x-nrodoc AND x-ccbccaja.flgest <> 'A' NO-LOCK:
       
        x-monto-lpa-ar-usado = x-ccbccaja.impnac[7].    /* Monto del LPA o A/R usado en caja */
        x-conteo = 0.
        x-total = 0.                
        /* Cuantos documentos cancelo */
        FOR EACH x-ccbdcaja OF x-ccbccaja WHERE LOOKUP(x-ccbdcaja.codref,"N/C,NCI") = 0 NO-LOCK:
            x-conteo = x-conteo + 1.
            CREATE x-w-report.
                ASSIGN x-w-report.task-no = x-conteo
                        x-w-report.campo-c[1] = pCodMov   /* I/C o N/B de la cancelacion de la letra */
                        x-w-report.campo-c[2] = pNroMov
                        x-w-report.campo-c[3] = pCodDoc   /* LET */
                        x-w-report.campo-c[4] = pNroDoc
                        x-w-report.campo-c[5] = x-ccbccaja.coddoc   /* I/C del uso del LPA o A/R*/
                        x-w-report.campo-c[6] = x-ccbccaja.nrodoc
                        x-w-report.campo-c[7] = x-ccbdcaja.codref   /* FAC,BOL, DCO,.... */
                        x-w-report.campo-c[8] = x-ccbdcaja.nroref
                        x-w-report.campo-f[1] = (x-ccbdcaja.imptot * (x-monto-lpa-ar-usado / x-monto-lpa-ar) )
                        .
            x-total = x-total + x-w-report.campo-f[1].
        END.
        /* deberian ser iguales x-total y x-monto-lpa-ar-usado */

        /*  */
        x-conteoX = 1.
        x-suma = 0.
        FOR EACH w-report WHERE x-w-report.campo-c[1] = pCodMov   /* I/C o N/B de la cancelacion de la letra */
                                AND x-w-report.campo-c[2] = pNroMov
                                AND x-w-report.campo-c[3] = pCodDoc   /* LET */
                                AND x-w-report.campo-c[4] = pNroDoc
                                AND x-w-report.campo-c[5] = x-ccbccaja.coddoc   /* I/C del uso del LPA o A/R */
                                AND x-w-report.campo-c[6] = x-ccbccaja.nrodoc NO-LOCK:
            IF x-conteoX = x-conteo THEN DO:
                ASSIGN x-w-report.campo-f[2] = pImpteLetra - x-suma.
            END.
            ELSE DO:
                ASSIGN x-w-report.campo-f[2] =  pImpteLetra * (x-w-report.campo-f[1] / x-total).
                x-suma = x-suma + x-w-report.campo-f[2].
            END.
            x-conteoX = x-conteoX + 1.
        END.
    END.            
END.

pRetVal = "OK".
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trazabilidad-notas-bancarias) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trazabilidad-notas-bancarias Procedure 
PROCEDURE trazabilidad-notas-bancarias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodMov AS CHAR.     /* N/B */
DEFINE INPUT PARAMETER pNroMov AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR.

pRetVal = "".

EMPTY TEMP-TABLE x-w-report.

FOR EACH x-Ccbdmvto NO-LOCK WHERE x-CcbDMvto.CodCia = s-codcia
    AND x-CcbDMvto.CodDoc = pCodMov         /* N/B */
    AND x-CcbDMvto.NroDoc = pNroMov :

    IF x-CcbDMvto.codref = "LET" THEN DO:

        RUN trazabilidad-mov-del-lpa(INPUT x-CcbDMvto.CodDoc, INPUT x-CcbDMvto.NroDoc, 
                                        INPUT x-CcbDMvto.codref, INPUT x-CcbDMvto.nroref,   /* LET */
                                        INPUT x-CcbDMvto.imptot, OUTPUT pRetVal).
    END.
END.

/* Toda la trazabilidad de las letras contenidas en la N/B */
EMPTY TEMP-TABLE tw-report.

FOR EACH x-w-report:
    FIND FIRST tw-report WHERE tw-report.campo-c[3] = x-w-report.campo-c[3]     /* LET */
                                AND tw-report.campo-c[4] = x-w-report.campo-c[4]
                                AND tw-report.campo-c[5] = x-w-report.campo-c[5]   /* I/C */
                                AND tw-report.campo-c[6] = x-w-report.campo-c[6]
                                AND tw-report.campo-c[7] = x-w-report.campo-c[7]    /* FAC,BOL, DCO,.... */
                                AND tw-report.campo-c[8] = x-w-report.campo-c[8] EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE tw-report THEN DO:
        CREATE tw-report.
            ASSIGN tw-report.campo-c[3] = x-w-report.campo-c[3]     /* LET */
                    tw-report.campo-c[4] = x-w-report.campo-c[4]
                    tw-report.campo-c[5] = x-w-report.campo-c[5]   /* I/C */
                    tw-report.campo-c[6] = x-w-report.campo-c[6]
                    tw-report.campo-c[7] = x-w-report.campo-c[7]    /* FAC,BOL, DCO,.... */
                    tw-report.campo-c[8] = x-w-report.campo-c[8]
                    tw-report.campo-f[1] = 0
                    tw-report.campo-f[2] = 0
                    .
    END.
    ASSIGN tw-report.campo-f[1] = tw-report.campo-f[1] + x-w-report.campo-f[1]
            tw-report.campo-f[2] = tw-report.campo-f[2] + x-w-report.campo-f[2].
END.

/* Grabo la trazabilidad */
pRetVal = "PROCESANDO".
TRAZABILIDAD:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH tw-report:
    
        CREATE b-trazabilidad-mov.
        ASSIGN  b-trazabilidad-mov.codcia = s-codcia
                b-trazabilidad-mov.coddoc = tw-report.campo-c[3]     /* LET */
                b-trazabilidad-mov.nrodoc = tw-report.campo-c[4]
                b-trazabilidad-mov.codcmpte = tw-report.campo-c[7]    /* FAC,BOL, DCO,.... */
                b-trazabilidad-mov.nrocmpte = tw-report.campo-c[8]
                b-trazabilidad-mov.impcalculado = tw-report.campo-f[1]
                b-trazabilidad-mov.imporigen = 0
                b-trazabilidad-mov.codref = ""
                b-trazabilidad-mov.nroref = ""
                b-trazabilidad-mov.codmov = tw-report.campo-c[5]   /* I/C usado con el LPA o A/R */
                b-trazabilidad-mov.nromov = tw-report.campo-c[6]
                b-trazabilidad-mov.usrcrea = USERID("DICTDB")
                b-trazabilidad-mov.fchcrea = TODAY
                b-trazabilidad-mov.horacrea = STRING(TIME,"HH:MM:SS")
                NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pRetVal = "ERROR trazabilidad-notas-bancaria: " + tw-report.campo-c[3] + " " + tw-report.campo-c[4] + CHR(10) + CHR(13) +
                    "Comprobante :" + tw-report.campo-c[7] + " " + tw-report.campo-c[8] + CHR(10) + CHR(13) +
                    "MSG : " + ERROR-STATUS:GET-MESSAGE(1).
    
            UNDO TRAZABILIDAD, RETURN 'ADM-ERROR'.
        END.
    
    END.
END.
RELEASE b-trazabilidad-mov NO-ERROR.

pRetVal = "OK".

RETURN "OK".

END PROCEDURE.

/*
DEFINE VAR x-codmov AS CHAR.
DEFINE VAR x-nromov AS CHAR.
DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nrodoc AS CHAR.
DEFINE VAR x-suma AS DEC.
DEFINE VAR x-total AS DEC.
DEFINE VAR x-signo AS INT.
DEFINE VAR x-conteo AS INT.
DEFINE VAR x-conteox AS INT.

DEFINE VAR x-monto-lpa-ar AS DEC.
DEFINE VAR x-monto-lpa-ar-usado AS DEC.
DEFINE VAR x-importe-letra AS DEC.          /* Monto que esta cancelando */
*/

        /*
        x-codmov = "".
        x-nromov = "".
        /* Movimiento de origen de la LETRA */
        RUN letra-origen-del-movimiento(INPUT x-CcbDMvto.codref, INPUT x-CcbDMvto.nroref, 
                                                  OUTPUT x-codmov, OUTPUT x-nromov).
        
        IF x-codmov = 'CLA' THEN DO:

            x-importe-letra = x-CcbDMvto.imptot.
            x-coddoc = "".
            x-nrodoc = "".
            /* Es un canje de letra adelantada */
            RUN numero-anticipo-x-canje-adelantado(INPUT x-codmov, INPUT x-nromov, 
                                                      OUTPUT x-coddoc, OUTPUT x-nrodoc).
            /* Monto del LPA o A/R */
            FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                                            x-ccbcdocu.coddoc = x-coddoc AND 
                                            x-ccbcdocu.nrodoc = x-nrodoc NO-LOCK NO-ERROR.
            x-monto-lpa-ar = 0.
            IF AVAILABLE x-ccbcdocu THEN x-monto-lpa-ar = x-ccbcdocu.imptot.    /* El monto total del LPA o A/R */

            /* Todas las cancelaciones en donde uso el LPA o A/R */
            FOR EACH x-ccbccaja WHERE x-ccbccaja.codcia = s-codcia and x-ccbccaja.tipo = 'CANCELACION' and 
                                    x-ccbccaja.coddoc = 'I/C' and x-ccbccaja.codbco[7] = x-coddoc AND
                                    x-ccbccaja.voucher[7] = x-nrodoc NO-LOCK:
               
                x-monto-lpa-ar-usado = x-ccbccaja.impnac[7].    /* Monto del LPA o A/R usado en caja */
                x-conteo = 0.
                x-total = 0.                
                /* Cuantos documentos cancelo */
                FOR EACH x-ccbdcaja OF x-ccbccaja WHERE LOOKUP(x-ccbdcaja.codref,"N/C,NCI") = 0 NO-LOCK:
                    x-conteo = x-conteo + 1.
                    CREATE x-w-report.
                        ASSIGN x-w-report.task-no = x-conteo
                                x-w-report.campo-c[1] = x-CcbDMvto.CodDoc   /* N/B */
                                x-w-report.campo-c[2] = x-CcbDMvto.NroDoc
                                x-w-report.campo-c[3] = x-CcbDMvto.codref   /* LET */
                                x-w-report.campo-c[4] = x-CcbDMvto.nroref
                                x-w-report.campo-c[5] = x-ccbccaja.coddoc   /* I/C */
                                x-w-report.campo-c[6] = x-ccbccaja.nrodoc
                                x-w-report.campo-c[7] = x-ccbdcaja.codref   /* FAC,BOL, DCO,.... */
                                x-w-report.campo-c[8] = x-ccbdcaja.nroref
                                x-w-report.campo-f[1] = (x-ccbdcaja.imptot * (x-monto-lpa-ar-usado / x-monto-lpa-ar) )
                                .
                    x-total = x-total + x-w-report.campo-f[1].
                END.
                /* deberian ser iguales x-total y x-monto-lpa-ar-usado */

                /*  */
                x-conteoX = 1.
                x-suma = 0.
                FOR EACH w-report WHERE x-w-report.campo-c[1] = x-CcbDMvto.CodDoc   /* N/B */
                                        AND x-w-report.campo-c[2] = x-CcbDMvto.NroDoc
                                        AND x-w-report.campo-c[3] = x-CcbDMvto.codref   /* LET */
                                        AND x-w-report.campo-c[4] = x-CcbDMvto.nroref
                                        AND x-w-report.campo-c[5] = x-ccbccaja.coddoc   /* I/C */
                                        AND x-w-report.campo-c[6] = x-ccbccaja.nrodoc NO-LOCK:
                    IF x-conteoX = x-conteo THEN DO:
                        ASSIGN x-w-report.campo-f[2] = x-importe-letra - x-suma.
                    END.
                    ELSE DO:
                        ASSIGN x-w-report.campo-f[2] = x-importe-letra * (x-w-report.campo-f[1] / x-total).
                        x-suma = x-suma + x-w-report.campo-f[2].
                    END.
                    x-conteoX = x-conteoX + 1.
                END.
            END.            
        END.
        */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-usuario-concepto-permitido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE usuario-concepto-permitido Procedure 
PROCEDURE usuario-concepto-permitido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pUsuario AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-w-report.

DEFINE VAR x-tabla AS CHAR INIT 'PERFIL-APRO'.
DEFINE VAR x-tabla-conceptos-nc AS CHAR INIT "N/C".

EMPTY TEMP-TABLE tt-w-report.
EMPTY TEMP-TABLE x-w-report.

IF pUsuario = 'ADMIN' OR USERID("DICTDB") = 'MASTER' THEN DO:
    
    FOR EACH ccbtabla WHERE ccbtabla.codcia = s-codcia AND
                            ccbtabla.tabla = x-tabla-conceptos-nc AND
                            /*ccbtabla.codigo <> '00026' AND*/
                            ccbtabla.libre_l02 = YES NO-LOCK:
        CREATE tt-w-report.
        ASSIGN tt-w-report.task-no = 1 
                tt-w-report.llave-c = ccbtabla.codigo.
        
    END.
    
END.
ELSE DO:
    FOR EACH vtadtabla WHERE vtadtabla.codcia = s-codcia AND 
                                vtadtabla.tabla = x-tabla AND
                                vtadtabla.tipo = pUsuario NO-LOCK:

        CREATE x-w-report.
        ASSIGN x-w-report.task-no = 1 
                x-w-report.llave-c = vtadtabla.llave.  /* PERFIL */

    END.
    FOR EACH x-w-report :
        FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND
                                vtatabla.tabla = x-tabla AND
                                vtatabla.llave_c2 = x-w-report.llave-c NO-LOCK:

            FIND FIRST tt-w-report WHERE tt-w-report.llave-c = vtatabla.llave_c1 NO-LOCK NO-ERROR.

            IF NOT AVAILABLE tt-w-report THEN DO:
                CREATE tt-w-report.
                ASSIGN tt-w-report.task-no = 1 
                        tt-w-report.llave-c = vtatabla.llave_c1.  /* CONCEPTO */

            END.

        END.

    END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

