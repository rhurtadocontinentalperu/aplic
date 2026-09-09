&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE BUFFER ORDEN FOR FacCPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.



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
/*
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.
*/

DEFINE VAR pCodDiv AS CHAR.
DEFINE VAR pCodDoc AS CHAR.
DEFINE VAR pNroDoc AS CHAR.
DEFINE VAR x-Mensaje AS CHAR NO-UNDO.

DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-CodCia AS INT.

DEF VAR x-Articulo-ICBPer AS CHAR INIT '099268'.


/* Para el detalle de los A/C */
DEFINE TEMP-TABLE ttDetalleDocs LIKE anticipos-aplicaciones.
DEFINE BUFFER x-anticipos-aplicaciones FOR anticipos-aplicaciones.

DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER AC-CDOCU FOR ccbcdocu.
DEFINE BUFFER BD-CDOCU FOR ccbcdocu.

/* Descuentos Pronto Pago */
DEFINE BUFFER x-vtatabla FOR vtatabla.
DEFINE VAR x-tabla-factor AS CHAR.
DEFINE VAR x-tipo-dscto AS CHAR.

x-tabla-factor = "TIPO_DSCTO_FACTOR".
x-tipo-dscto = "DSCTO_PRONTO_PG".

DEFINE TEMP-TABLE ttDsctosArtProntoPago
    FIELD   tcodmat     AS  CHAR
    FIELD   timplin     AS  DEC
    FIELD   tfactor     AS  DEC
    FIELD   timpdscto   AS  DEC.

DEFINE TEMP-TABLE tt-lineas
    FIELD   tcodfam     AS  CHAR
    FIELD   tsubfam     AS  CHAR.

DEFINE VAR x-total-descuento-pronto-pago AS DEC.

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
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: ORDEN B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 10.58
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/*

DEF SHARED VAR s-CodCia AS INT.

FIND Ccbcdocu WHERE CcbCDocu.CodCia = s-CodCia AND
    CcbCDocu.CodDiv = pCodDiv AND
    CcbCDocu.CodDoc = pCodDoc AND
    CcbCDocu.NroDoc = pNroDoc
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbcdocu THEN RETURN 'OK'.
IF LOOKUP(Ccbcdocu.CodDoc, 'FAC,BOL') = 0 THEN RETURN 'OK'.

/* Separamos el cálculo a partir del comprobante */
FIND FIRST ORDEN WHERE ORDEN.CodCia = CcbCDocu.CodCia AND
    ORDEN.CodDoc = CcbCDocu.Libre_c01 AND
    ORDEN.NroPed = CcbCDocu.Libre_c02 AND
    CAN-FIND(FIRST PEDIDO WHERE PEDIDO.CodCia = ORDEN.CodCia AND
             PEDIDO.CodDoc = ORDEN.CodRef AND
             PEDIDO.NroPed = ORDEN.NroRef AND
             CAN-FIND(FIRST COTIZACION WHERE COTIZACION.CodCia = PEDIDO.CodCia AND 
                      COTIZACION.CodDoc = PEDIDO.CodRef AND
                      COTIZACION.NroPed = PEDIDO.NroRef NO-LOCK)
             NO-LOCK)
    NO-LOCK NO-ERROR.
IF AVAILABLE ORDEN THEN DO:
    FIND FIRST PEDIDO WHERE PEDIDO.CodCia = ORDEN.CodCia AND
             PEDIDO.CodDoc = ORDEN.CodRef AND
             PEDIDO.NroPed = ORDEN.NroRef AND
        CAN-FIND(FIRST COTIZACION WHERE COTIZACION.CodCia = PEDIDO.CodCia AND 
                 COTIZACION.CodDoc = PEDIDO.CodRef AND
                 COTIZACION.NroPed = PEDIDO.NroRef NO-LOCK)
        NO-LOCK.
    FIND FIRST COTIZACION WHERE COTIZACION.CodCia = PEDIDO.CodCia AND 
        COTIZACION.CodDoc = PEDIDO.CodRef AND
        COTIZACION.NroPed = PEDIDO.NroRef NO-LOCK.
    CASE TRUE:
        WHEN PEDIDO.Cliente_Recoge = YES THEN DO:
            RUN Cliente-Recoge.
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo actualizar el descuento por CLIENTE RECOGE".
                RETURN 'ADM-ERROR'.
            END.
        END.
        OTHERWISE DO:
            /* Buscamos pronto despacho */
            FIND FIRST VtaCTabla WHERE VtaCTabla.CodCia = s-CodCia AND
                VtaCTabla.Tabla = "DSCTO_DESPACHO" AND
                /*VtaCTabla.Llave = COTIZACION.Libre_c01 AND*/
                VtaCTabla.Llave = ORDEN.Lista_de_Precios AND
                ORDEN.FchEnt <= VtaCTabla.Libre_f01
                NO-LOCK NO-ERROR.
            CASE TRUE:
                WHEN AVAILABLE VtaCTabla THEN DO:
                    RUN Pronto-Despacho.
                    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo actualizar el descuento por PRONTO DESPACHO".
                        RETURN 'ADM-ERROR'.
                    END.
                END.
            END CASE.
        END.
    END CASE.
END.

RETURN 'OK'.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-anticipos-con-saldo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE anticipos-con-saldo Procedure 
PROCEDURE anticipos-con-saldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodCli AS CHAR.

DEFINE VAR x-fecha-deposito AS DATE.
DEFINE VAR x-codmon AS INT.
DEFINE VAR x-impte AS DEC.


EMPTY TEMP-TABLE ttDetalleDocs.

/* Los A/C pendientes (con saldo) */
FOR EACH  AC-CDOCU USE-INDEX Llave06 WHERE AC-CDOCU.codcia = s-codcia
    AND AC-CDOCU.codcli = pCodCli
    AND AC-CDOCU.flgest = 'P'
    AND AC-CDOCU.coddoc = 'A/C' NO-LOCK :

    /* Los Saldos menores a 5 soles no va */
    IF AC-CDOCU.imptot < 5 THEN NEXT.
    
    /* Las facturas que dieron origen al A/C */
    FOR EACH ccbdcaja WHERE ccbdcaja.coddoc = 'I/C' AND
                             ccbdcaja.codref = ac-cdocu.codref AND      /* FAC por anticipo */
                             ccbdcaja.nroref = ac-cdocu.nroref NO-LOCK:
        FOR EACH ccbdmov WHERE ccbdmov.codcia = s-codcia AND
                                ccbdmov.codref = ccbdcaja.coddoc AND
                                ccbdmov.nroref = ccbdcaja.nrodoc NO-LOCK:
            x-fecha-deposito = ccbdmov.fchdoc.
            x-codmon = ccbdmov.codmon.
            x-impte = ccbdmov.imptot.

            /* OJO LA MONEDA AL TIPO DE CAMBIO */

            IF ccbdmov.coddoc = 'BD' THEN DO:
                x-fecha-deposito = ?.
                /* Si es BD buscar la fecha del deposito */
                FIND FIRST bd-cdocu WHERE bd-cdocu.codcia = s-codcia AND
                                            bd-cdocu.coddoc = ccbdmov.coddoc AND
                                            bd-cdocu.nrodoc = ccbdmov.nrodoc NO-LOCK NO-ERROR.
                IF AVAILABLE bd-cdocu THEN DO:
                    x-fecha-deposito = bd-cdocu.fchate.
                    x-codmon = bd-cdocu.codmon.
                    x-impte = bd-cdocu.imptot.
                END.
            END.
            IF x-fecha-deposito <> ? THEN DO:
                CREATE ttDetalleDocs.
                ASSIGN ttDetalleDocs.codformapago = ccbdmov.coddoc
                    ttDetalleDocs.nroformapago = ccbdmov.nrodoc
                    ttDetalleDocs.fchaplicada = x-fecha-deposito
                    ttDetalleDocs.codmone = x-codmon
                    ttDetalleDocs.impte = x-impte
                    ttDetalleDocs.codcmpbte = ac-cdocu.codref
                    ttDetalleDocs.nrocmpbte = ac-cdocu.nroref
                    ttDetalleDocs.codanticipo = ac-cdocu.coddoc
                    ttDetalleDocs.nroanticipo = ac-cdocu.nrodoc
                .
            END.
        END.
    END.    
END.

/* Restar los documentos aplicados */
DEFINE VAR x-impte-usado AS DEC.

FOR EACH ttDetalleDocs :
    x-impte-usado = 0.
    FOR EACH anticipos-aplicaciones WHERE anticipos-aplicaciones.codcia = s-codcia AND
                                            anticipos-aplicaciones.codcli = ccbcdocu.codcli AND
                                            anticipos-aplicaciones.codformapago = ttDetalleDocs.codformapago AND
                                            anticipos-aplicaciones.nroformapago = ttDetalleDocs.nroformapago NO-LOCK:
        /**/
        FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                                    x-ccbcdocu.coddoc = anticipos-aplicaciones.codcmpbte AND
                                    x-ccbcdocu.nrodoc = anticipos-aplicaciones.nrocmpbte NO-LOCK NO-ERROR.
        IF AVAILABLE x-ccbcdocu AND  x-ccbcdocu.flges <> 'A' THEN DO:
            x-impte-usado = x-impte-usado + anticipos-aplicaciones.impte.
        END.        
    END.
    ASSIGN ttDetalleDocs.impte = ttDetalleDocs.impte - x-impte-usado.
    IF ttDetalleDocs.impte < 0 THEN ASSIGN ttDetalleDocs.impte = 0.
END.

/* Eliminamos los que ya fueron usados */
FOR EACH ttDetalleDocs WHERE ttDetalleDocs.impte = 0 :
    DELETE ttDetalleDocs.
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-aplica-factores-pronto-pago) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aplica-factores-pronto-pago Procedure 
PROCEDURE aplica-factores-pronto-pago :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-impte-total-doc AS DEC.
DEFINE VAR x-total-descuento AS DEC.
DEFINE VAR x-sec AS INT.
DEFINE VAR x-sec1 AS INT.

DEFINE VAR x-suma-descuento AS DEC.
DEFINE VAR x-factor-descuento AS DEC.
    
/* Total descuento que le corresponde segun los BDs*/
FOR EACH ttDetalleDocs WHERE ttDetalleDocs.libre-f[3] > 0:
    x-total-descuento = x-total-descuento + ttDetalleDocs.libre-f[3].    
END.

/* Los articulos  */
IF x-total-descuento > 0 THEN DO:
    x-sec = 0.
    x-impte-total-doc = 0.
    FOR EACH ttDsctosArtProntoPago :
        x-impte-total-doc = x-impte-total-doc + ttDsctosArtProntoPago.timplin.
        x-sec = x-sec + 1.
    END.

    x-sec1 = 0.
    FOR EACH ttDsctosArtProntoPago :
        x-sec1 = x-sec1 + 1.
        IF x-sec = x-sec1 THEN DO:
            ASSIGN ttDsctosArtProntoPago.tfactor = 1 - x-factor-descuento.
                    ttDsctosArtProntoPago.timpdscto = x-total-descuento - x-suma-descuento.
        END.
        ELSE DO:
            ASSIGN ttDsctosArtProntoPago.tfactor = ROUND(ttDsctosArtProntoPago.timplin / x-impte-total-doc,4)
                    ttDsctosArtProntoPago.timpdscto = ROUND(ttDsctosArtProntoPago.tfactor * ttDsctosArtProntoPago.timplin,2).

            x-suma-descuento = x-suma-descuento + ttDsctosArtProntoPago.timpdscto.
            x-factor-descuento = x-factor-descuento + ttDsctosArtProntoPago.tfactor.
        END.
    END.
    /* No hay ningun articulo para aplicar descuento */
    IF x-impte-total-doc <= 0 THEN x-total-descuento = 0.
END.

x-total-descuento-pronto-pago = x-total-descuento.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-articulos-pronto-pago) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE articulos-pronto-pago Procedure 
PROCEDURE articulos-pronto-pago :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Detalle de la factura */
EMPTY TEMP-TABLE ttDsctosArtProntoPago.

FOR EACH ccbddocu OF ccbcdocu NO-LOCK,
    FIRST almmmatg OF ccbddocu NO-LOCK:

    /* La linea del articulo esta configurado */
    FIND FIRST tt-lineas WHERE tt-lineas.tcodfam = almmmatg.codfam AND
                                tt-lineas.tsubfam = almmmatg.subfam NO-LOCK NO-ERROR.
    IF AVAILABLE tt-lineas THEN DO:
        CREATE ttDsctosArtProntoPago.
            ASSIGN ttDsctosArtProntoPago.tcodmat = ccbddocu.codmat
                    ttDsctosArtProntoPago.timplin = ccbddocu.implin
                    ttDsctosArtProntoPago.tfactor = 0.
                    ttDsctosArtProntoPago.timpdscto = 0.

    END.   
END.
/*
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */


c-xls-file = 'd:\xpciman\articulos.xlsx'.

run pi-crea-archivo-csv IN hProc (input  buffer ttDsctosArtProntoPago:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer ttDsctosArtProntoPago:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Calcular-Descuento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcular-Descuento Procedure 
PROCEDURE Calcular-Descuento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pPorDto AS DEC.
DEF INPUT PARAMETER pImpTot AS DEC.     /* Importe que está afecto al descuento */
DEF INPUT PARAMETER pMotivo AS CHAR.

DEF VAR x-ImpDto AS DEC NO-UNDO.

/* Calculamos el descuento al total: Se va a repartir entre los artículos que están afectos al decuento */
x-ImpDto = ROUND(pImpTot * (pPorDto / 100), 2).

/* Distribuimos el descuento entre todos los productos */
DEF VAR x-Rowid AS ROWID NO-UNDO.

x-Rowid = ROWID(Ccbcdocu).

DEF BUFFER B-CDOCU FOR Ccbcdocu.
DEF BUFFER B-DDOCU FOR Ccbddocu.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="B-CDOCU" ~
        &Condicion="ROWID(B-CDOCU) = x-Rowid" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="x-Mensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
    ASSIGN
        B-CDOCU.Dcto_Otros_VV = 0
        B-CDOCU.Dcto_Otros_PV = x-ImpDto
        B-CDOCU.Dcto_Otros_Mot = pMotivo
        B-CDOCU.Dcto_Otros_Factor = pPorDto.
    /* ********************************** */
    /* Repartimos el monto por cada item */
    /* ********************************** */
    FOR EACH Ccbddocu OF B-CDOCU NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK BREAK BY Ccbddocu.codcia BY Ccbddocu.nroitm:
        /* ********************************** */
        /* Veamos si esta INCLUIDO o EXCLUIDO */
        /* ********************************** */
        FIND FIRST VtaDTabla OF VtaCTabla WHERE VtaDTabla.Tipo = Almmmatg.CodFam NO-LOCK NO-ERROR.
        IF pMotivo = "DSCTO_DESPACHO" AND NOT AVAILABLE VtaDTabla THEN NEXT.     /* Inclusiones */
        IF pMotivo = "DSCTO_RECOJO"   AND AVAILABLE VtaDTabla     THEN NEXT.     /* Excepciones */
        /* ********************************** */
        FIND B-DDOCU WHERE ROWID(B-DDOCU) = ROWID(Ccbddocu) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="x-Mensaje"}
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            B-DDOCU.Dcto_Otros_Factor = pPorDto
            B-DDOCU.Dcto_Otros_VV = 0
            B-DDOCU.Dcto_Otros_PV = ROUND((B-DDOCU.ImpLin - B-DDOCU.ImpDto2) * (pPorDto / 100), 2)
            B-DDOCU.Dcto_Otros_Mot = pMotivo.
        ASSIGN
            x-ImpDto = x-ImpDto - B-DDOCU.Dcto_Otros_PV.
        IF LAST(Ccbddocu.CodCia) THEN B-DDOCU.Dcto_Otros_PV = B-DDOCU.Dcto_Otros_PV + x-ImpDto.
        /* Importe del registro */
        ASSIGN
            B-DDOCU.ImpLin = B-DDOCU.ImpLin - B-DDOCU.Dcto_Otros_PV.
        ASSIGN
            B-DDOCU.ImpDto = (B-DDOCU.CanDes * B-DDOCU.PreUni) - B-DDOCU.ImpLin.
        /* Redondeamos */
        ASSIGN
            B-DDOCU.ImpLin = ROUND(B-DDOCU.ImpLin, 2)
            B-DDOCU.ImpDto = ROUND(B-DDOCU.ImpDto, 2).
        IF B-DDOCU.AftIsc 
            THEN ASSIGN 
                    B-DDOCU.ImpIsc = ROUND(B-DDOCU.PreBas * B-DDOCU.CanDes * (Almmmatg.PorIsc / 100),4).
        IF B-DDOCU.AftIgv 
            THEN ASSIGN 
                    B-DDOCU.Dcto_Otros_VV = B-DDOCU.Dcto_Otros_PV / ( 1 + (B-CDOCU.PorIgv / 100) )
                    B-CDOCU.Dcto_Otros_VV = B-CDOCU.Dcto_Otros_VV + ( B-DDOCU.Dcto_Otros_PV / ( 1 + (B-CDOCU.PorIgv / 100) ) )
                    B-DDOCU.ImpIgv = B-DDOCU.ImpLin - ROUND( B-DDOCU.ImpLin  / ( 1 + (B-CDOCU.PorIgv / 100) ), 4 ).
        ELSE ASSIGN B-DDOCU.Dcto_Otros_VV = B-DDOCU.Dcto_Otros_PV.
    END.
    {vtagn/i-total-factura.i &Cabecera="B-CDOCU" &Detalle="B-DDOCU"}
END.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calcular-descuento-pronto-pago) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcular-descuento-pronto-pago Procedure 
PROCEDURE calcular-descuento-pronto-pago :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*DEF INPUT PARAMETER pPorDto AS DEC.*/
DEF INPUT PARAMETER pMotivo AS CHAR.

DEF VAR x-ImpDto AS DEC NO-UNDO.
DEFINE VAR x-PorDto AS DEC.
DEFINE VAR x-nuevo-PorDto AS DEC.

DEFINE VAR x-vv-cab AS DEC.
DEFINE VAR x-factor-cab AS DEC.
DEFINE VAR x-pv-cab AS DEC.

DEFINE VAR x-vv-det AS DEC.
DEFINE VAR x-pv-det AS DEC.
DEFINE VAR x-factor-det AS DEC.
DEFINE VAR x-nuevo-PorDto-det AS DEC.

/* Descuentos existentes */
x-vv-cab = CcbCDocu.Dcto_Otros_VV.
x-pv-cab = CcbCDocu.Dcto_Otros_PV.
x-factor-cab = CcbCDocu.Dcto_Otros_Factor.

/* Calculamos el descuento al total */
x-ImpDto = x-total-descuento-pronto-pago.    /* ROUND(Ccbcdocu.ImpTot * (pPorDto / 100), 2).*/
x-PorDto = (x-total-descuento-pronto-pago / CcbCDocu.imptot ) * 100.
x-nuevo-PorDto = ((x-total-descuento-pronto-pago + x-pv-cab) / (CcbCDocu.imptot + x-pv-cab)) * 100.

/* Distribuimos el descuento entre todos los productos */
DEF VAR x-Rowid AS ROWID NO-UNDO.

x-Rowid = ROWID(Ccbcdocu).

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="Ccbcdocu" ~
        &Condicion="ROWID(Ccbcdocu) = x-Rowid" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="x-Mensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
        
        /*
    ASSIGN
        CcbCDocu.Dcto_Otros_VV = 0
        CcbCDocu.Dcto_Otros_PV = x-ImpDto
        CcbCDocu.Dcto_Otros_Mot = pMotivo
        CcbCDocu.Dcto_Otros_Factor = pPorDto.
        */

    ASSIGN
        CcbCDocu.Dcto_Otros_VV = 0
        CcbCDocu.Dcto_Otros_PV = CcbCDocu.Dcto_Otros_PV + x-total-descuento-pronto-pago
        CcbCDocu.Dcto_Otros_Factor = x-nuevo-PorDto.
    IF TRUE <> (CcbCDocu.Dcto_Otros_Mot > "") THEN DO:
        CcbCDocu.Dcto_Otros_Mot = pMotivo.
    END.
    ELSE DO:
        CcbCDocu.Dcto_Otros_Mot = CcbCDocu.Dcto_Otros_Mot + "," + pMotivo.
    END.

    /* Repartimos el monto por cada item */
    FOR EACH Ccbddocu OF Ccbcdocu, FIRST Almmmatg OF Ccbddocu NO-LOCK 
        BREAK BY Ccbddocu.codcia BY Ccbddocu.nroitm:
        /* Articulo afecto al descuento? */
        FIND FIRST ttDsctosArtProntoPago WHERE ttDsctosArtProntoPago.tcodmat = Ccbddocu.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE ttDsctosArtProntoPago THEN DO:
            /*
            ASSIGN
                CcbDDocu.Dcto_Otros_Factor = pPorDto
                CcbDDocu.Dcto_Otros_VV = 0
                CcbDDocu.Dcto_Otros_PV = ROUND(Ccbddocu.ImpLin * (pPorDto / 100), 2)
                CcbDDocu.Dcto_Otros_Mot = pMotivo.
            */
            x-vv-det = CcbDDocu.Dcto_Otros_VV.
            x-pv-det = CcbDDocu.Dcto_Otros_PV.
            x-factor-det = CcbDDocu.Dcto_Otros_Factor.

            x-nuevo-PorDto-det = ((ttDsctosArtProntoPago.timpdscto + x-pv-det) / (Ccbddocu.ImpLin + x-pv-det)) * 100.

            ASSIGN
                CcbDDocu.Dcto_Otros_Factor = x-nuevo-PorDto-det                                     /*pPorDto*/                
                CcbDDocu.Dcto_Otros_PV = CcbDDocu.Dcto_Otros_PV + ttDsctosArtProntoPago.timpdscto.  /* ROUND(Ccbddocu.ImpLin * (pPorDto / 100), 2) */
                /*CcbDDocu.Dcto_Otros_VV = 0*/
            .
            IF TRUE <> (CcbDDocu.Dcto_Otros_Mot > "") THEN DO:
                CcbDDocu.Dcto_Otros_Mot = pMotivo.
            END.
            ELSE DO:
                CcbDDocu.Dcto_Otros_Mot = CcbDDocu.Dcto_Otros_Mot + "," + pMotivo.
            END.

            /*
            ASSIGN
                x-ImpDto = x-ImpDto - CcbDDocu.Dcto_Otros_PV.

            IF LAST(Ccbddocu.CodCia) THEN CcbDDocu.Dcto_Otros_PV = CcbDDocu.Dcto_Otros_PV + x-ImpDto.
            */
            /* Importe del registro */
            ASSIGN
                Ccbddocu.ImpLin = Ccbddocu.ImpLin - ttDsctosArtProntoPago.timpdscto.        /*CcbDDocu.Dcto_Otros_PV.*/
            ASSIGN
                Ccbddocu.ImpDto = (Ccbddocu.CanDes * Ccbddocu.PreUni) - Ccbddocu.ImpLin.
            /* Redondeamos */
            ASSIGN
                Ccbddocu.ImpLin = ROUND(Ccbddocu.ImpLin, 2)
                Ccbddocu.ImpDto = ROUND(Ccbddocu.ImpDto, 2).
            IF Ccbddocu.AftIsc 
                THEN ASSIGN 
                        Ccbddocu.ImpIsc = ROUND(Ccbddocu.PreBas * Ccbddocu.CanDes * (Almmmatg.PorIsc / 100),4).
            IF Ccbddocu.AftIgv THEN DO:
                ASSIGN 
                        CcbDDocu.Dcto_Otros_VV = CcbDDocu.Dcto_Otros_PV / ( 1 + (Ccbcdocu.PorIgv / 100) )
                        Ccbddocu.ImpIgv = Ccbddocu.ImpLin - ROUND( Ccbddocu.ImpLin  / ( 1 + (Ccbcdocu.PorIgv / 100) ), 4 ).
            END.
            ELSE DO:
                ASSIGN CcbDDocu.Dcto_Otros_VV = CcbDDocu.Dcto_Otros_PV.
            END.
        END.
        /* Actualiza Cabecera */
        ASSIGN 
                CcbCDocu.Dcto_Otros_VV = CcbCDocu.Dcto_Otros_VV + CcbDDocu.Dcto_Otros_VV.

    END.
    {vtagn/i-total-factura.i &Cabecera="Ccbcdocu" &Detalle="Ccbddocu"}

    /* Guardamos los BD usados */
    FOR EACH ttDetalleDocs WHERE ttDetalleDocs.libre-f[3] > 0:
        CREATE anticipos-aplicaciones.
            ASSIGN anticipos-aplicaciones.codcia = s-codcia
                anticipos-aplicaciones.codformapago = ttDetalleDocs.codformapago
                anticipos-aplicaciones.nroformapago = ttDetalleDocs.nroformapago
                anticipos-aplicaciones.fchaplicada  = ccbcdocu.fchdoc
                anticipos-aplicaciones.impte        = ttDetalleDocs.libre-f[1]
                anticipos-aplicaciones.codmone      = ttDetalleDocs.codmone
                anticipos-aplicaciones.codcmpbte    = ccbcdocu.coddoc
                anticipos-aplicaciones.nrocmpbte    = ccbcdocu.nrodoc
                anticipos-aplicaciones.codcli       = ccbcdocu.codcli
                anticipos-aplicaciones.codanticipo  = ttDetalleDocs.codanticipo
                anticipos-aplicaciones.nroanticipo  = ttDetalleDocs.nroanticipo
                anticipos-aplicaciones.libre-f[1]   = ttDetalleDocs.libre-f[1]
                anticipos-aplicaciones.libre-f[2]   = ttDetalleDocs.libre-f[2]
                anticipos-aplicaciones.libre-f[3]   = ttDetalleDocs.libre-f[3]
                anticipos-aplicaciones.fchregistro  = TODAY
                anticipos-aplicaciones.horaregistro = STRING(TIME,"HH:MM:SS")
                anticipos-aplicaciones.usrregistro  = USERID("DICTDB")
            .
    END.
    RELEASE anticipos-aplicaciones.
END.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Cliente-Recoge) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cliente-Recoge Procedure 
PROCEDURE Cliente-Recoge :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR s-Tabla AS CHAR INIT "DSCTO_RECOJO" NO-UNDO.

/* Buscamos la configuración */
FIND VtaCTabla WHERE VtaCTabla.CodCia = s-CodCia AND 
    VtaCTabla.Tabla = s-Tabla AND 
    /* VtaCTabla.Llave = COTIZACION.Libre_c01 */        
    VtaCTabla.Llave = ORDEN.Lista_de_Precios
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaCTabla THEN RETURN 'OK'.

/* Acumulamos Importes por cada Item */
DEF VAR x-Importe AS de NO-UNDO.
FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK,
    FIRST Almmmatg OF Ccbddocu NO-LOCK:
    /* Excepciones */
    FIND FIRST VtaDTabla OF VtaCTabla WHERE VtaDTabla.Tipo = Almmmatg.CodFam NO-LOCK NO-ERROR.
    IF AVAILABLE VtaDTabla THEN NEXT.
    x-Importe = x-Importe + (CcbDDocu.ImpLin - CcbDDocu.ImpDto2).
END.
IF x-Importe <= 0 THEN RETURN 'OK'.

/* Ciudad o Periferia */
DEF VAR pCodDpto AS CHAR.
DEF VAR pCodProv AS CHAR.
DEF VAR pCodDist AS CHAR.

RUN Ubigeo-Cliente (INPUT Ccbcdocu.CodCli,
                    OUTPUT pCodDpto,
                    OUTPUT pCodProv,
                    OUTPUT pCodDist).

DEF VAR x-PorDto AS DEC NO-UNDO.

x-PorDto = VtaCTabla.Libre_d01.                             /* Ciudad */
IF pCodProv <> '01' THEN x-PorDto = VtaCTabla.Libre_d02.    /* Periferia */
IF x-PorDto <= 0 THEN RETURN 'OK'.

RUN Calcular-Descuento (INPUT x-PorDto,
                        INPUT x-Importe,
                        INPUT s-Tabla).
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-descuento-logistico) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE descuento-logistico Procedure 
PROCEDURE descuento-logistico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pxCodDiv AS CHAR.
DEF INPUT PARAMETER pxCodDoc AS CHAR.
DEF INPUT PARAMETER pxNroDoc AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

pCodDiv = pxCodDiv.
pCodDoc = pxCodDoc.
pNroDoc = pxNroDoc.

x-Mensaje = "".

FIND FIRST Ccbcdocu WHERE CcbCDocu.CodCia = s-CodCia AND
    CcbCDocu.CodDiv = pCodDiv AND
    CcbCDocu.CodDoc = pCodDoc AND
    CcbCDocu.NroDoc = pNroDoc
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbcdocu THEN RETURN 'OK'.

IF LOOKUP(Ccbcdocu.CodDoc, 'FAC,BOL') = 0 THEN RETURN 'OK'.

/* Separamos el cálculo a partir del comprobante */
FIND FIRST ORDEN WHERE ORDEN.CodCia = CcbCDocu.CodCia AND
    ORDEN.CodDoc = CcbCDocu.Libre_c01 AND
    ORDEN.NroPed = CcbCDocu.Libre_c02 AND
    CAN-FIND(FIRST PEDIDO WHERE PEDIDO.CodCia = ORDEN.CodCia AND
             PEDIDO.CodDoc = ORDEN.CodRef AND
             PEDIDO.NroPed = ORDEN.NroRef AND
             CAN-FIND(FIRST COTIZACION WHERE COTIZACION.CodCia = PEDIDO.CodCia AND 
                      COTIZACION.CodDoc = PEDIDO.CodRef AND
                      COTIZACION.NroPed = PEDIDO.NroRef NO-LOCK)
             NO-LOCK)
    NO-LOCK NO-ERROR.
IF AVAILABLE ORDEN THEN DO:
    FIND FIRST PEDIDO WHERE PEDIDO.CodCia = ORDEN.CodCia AND
             PEDIDO.CodDoc = ORDEN.CodRef AND
             PEDIDO.NroPed = ORDEN.NroRef AND
        CAN-FIND(FIRST COTIZACION WHERE COTIZACION.CodCia = PEDIDO.CodCia AND 
                 COTIZACION.CodDoc = PEDIDO.CodRef AND
                 COTIZACION.NroPed = PEDIDO.NroRef NO-LOCK)
        NO-LOCK.
    FIND FIRST COTIZACION WHERE COTIZACION.CodCia = PEDIDO.CodCia AND 
        COTIZACION.CodDoc = PEDIDO.CodRef AND
        COTIZACION.NroPed = PEDIDO.NroRef NO-LOCK.
    CASE TRUE:
        WHEN PEDIDO.Cliente_Recoge = YES THEN DO:
            RUN Cliente-Recoge.
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                IF TRUE <> (x-Mensaje > '') THEN pMensaje = "NO se pudo actualizar el descuento por CLIENTE RECOGE".
                RETURN 'ADM-ERROR'.
            END.
        END.
        OTHERWISE DO:
            /* Buscamos pronto despacho */
            FIND FIRST VtaCTabla WHERE VtaCTabla.CodCia = s-CodCia AND
                VtaCTabla.Tabla = "DSCTO_DESPACHO" AND
                VtaCTabla.Llave = COTIZACION.Libre_c01 AND
                /*VtaCTabla.Llave = ORDEN.Lista_de_Precios AND*/
                ORDEN.FchEnt <= VtaCTabla.Libre_f01
                NO-LOCK NO-ERROR.
            CASE TRUE:
                WHEN AVAILABLE VtaCTabla THEN DO:
                    RUN Pronto-Despacho.
                    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                        IF TRUE <> (x-Mensaje > '') THEN pMensaje = "NO se pudo actualizar el descuento por PRONTO DESPACHO".
                        RETURN 'ADM-ERROR'.
                    END.
                END.
            END CASE.
        END.
    END CASE.
END.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-descuento-por-pronto-pago) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE descuento-por-pronto-pago Procedure 
PROCEDURE descuento-por-pronto-pago :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pxCodDiv AS CHAR.        /* Puede ser vacio */
DEFINE INPUT PARAMETER pxCodDoc AS CHAR.        /*  FAC,BOL */
DEFINE INPUT PARAMETER pxNroDoc AS CHAR.
DEFINE OUTPUT PARAMETER pxRetVal AS CHAR NO-UNDO.

pCodDiv = pxCodDiv.
pCodDoc = pxCodDoc.
pNroDoc = pxNroDoc.

pxRetVal = "".

/* El comprobante de despacho */
IF TRUE <> (pCoddiv > "") THEN DO:
    /* Sin division */
    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                ccbcdocu.coddoc = pCodDoc AND
                                ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.
END.
ELSE DO:
    /* con division */
    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                ccbcdocu.coddiv = pCodDiv AND
                                ccbcdocu.coddoc = pCodDoc AND
                                ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.
END.

IF NOT AVAILABLE ccbcdocu THEN RETURN "OK".

/* Los anticipos con Saldos (detallado) */
RUN anticipos-con-saldo(INPUT CcbCDocu.codcli).

FIND FIRST ttDetalleDocs NO-LOCK NO-ERROR.
IF NOT AVAILABLE ttDetalleDocs THEN DO:
    /* No hay saldos a aplicar */
    RETURN "OK".
END.

/* Importes de los depositos  */
DEFINE VAR x-impte-comprobante AS DEC.
DEFINE VAR x-impte-a-considerar AS DEC.

x-impte-comprobante = ccbcdocu.imptot.

SALDOS_DEPOSITOS:
FOR EACH ttDetalleDocs BY ttDetalleDocs.fchaplicada :

    IF x-impte-comprobante > ttDetalleDocs.impte THEN DO:
        x-impte-a-considerar = ttDetalleDocs.impte.
    END.
    ELSE DO:
        x-impte-a-considerar = x-impte-comprobante.
    END.
    x-impte-comprobante = x-impte-comprobante - x-impte-a-considerar.
    /* Importe a considerar */
    ASSIGN ttDetalleDocs.libre-f[1] = x-impte-a-considerar.

    IF x-impte-comprobante <= 0 THEN LEAVE SALDOS_DEPOSITOS.
END.

x-tabla-factor = "TIPO_DSCTO_FACTOR".

/* Segun fecha de los depositos los % de descuento que les corresponde */
FOR EACH ttDetalleDocs WHERE ttDetalleDocs.libre-f[1] > 0:
    FOR EACH x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                            x-vtatabla.tabla = x-tabla-factor AND
                            x-vtatabla.llave_c1 = x-tipo-dscto /* AND
                            x-vtatabla.llave_c1 = CAMPAÑAAAAAAA
                            */ NO-LOCK :
        /* Fecha del deposito es <= del plazo */
        IF ttDetalleDocs.fchaplicada <= x-vtatabla.rango_fecha[1] THEN DO:
            ASSIGN ttDetalleDocs.libre-f[2] =  x-vtatabla.rango_valor[1]
                    ttDetalleDocs.libre-f[3] = ttDetalleDocs.libre-f[1] * (ttDetalleDocs.libre-f[2] / 100)
                    .
        END.                               
    END.
END.

/* Lineas validas para el descuento del pronto pago */
RUN lineas-pronto-pago.

/* Los Articulos para el dscto */
RUN articulos-pronto-pago.

/* Descuentos que le corresponde a nivel de item */
RUN aplica-factores-pronto-pago.

IF x-total-descuento-pronto-pago > 0 THEN DO:
    /* Aplica y Graba los descuentos en la factura */
    RUN calcular-descuento-pronto-pago(INPUT x-tipo-dscto).
END.


RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lineas-pronto-pago) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lineas-pronto-pago Procedure 
PROCEDURE lineas-pronto-pago :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-tabla AS CHAR.

x-tabla = "TIPO_DSCTO_LINEA".
x-tipo-dscto = "DSCTO_PRONTO_PG".

EMPTY TEMP-TABLE tt-lineas.

/* Todas las Lineas(*) y SubLineas(*) */
FOR EACH x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                            x-vtatabla.tabla = x-tabla AND
                            x-vtatabla.llave_c1 = x-tipo-dscto AND 
                            x-vtatabla.llave_c2 = '*' AND 
                            x-vtatabla.libre_c01 = '+' NO-LOCK:
    FOR EACH almtfami WHERE almtfami.codcia = s-codcia NO-LOCK:
        FOR EACH almsfami OF almtfami NO-LOCK:
                FIND FIRST tt-lineas WHERE tt-lineas.tcodfam = almtfam.codfam AND
                                            tt-lineas.tsubfam = almsfam.subfam
                                            EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE tt-lineas THEN DO:
                    CREATE tt-lineas.
                        ASSIGN  tt-lineas.tcodfam = almtfami.codfam
                                tt-lineas.tsubfam = almsfami.subfam
                                .
                END.
        END.                                
    END.
END.
/* Todas las Lineas (010) y SubLineas (*) */
FOR EACH x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                            x-vtatabla.tabla = x-tabla AND
                            x-vtatabla.llave_c1 = x-tipo-dscto AND 
                            x-vtatabla.llave_c2 <> '*' AND 
                            x-vtatabla.llave_c3 = '*' AND 
                            x-vtatabla.libre_c01 = '+' NO-LOCK:
    FOR EACH almtfami WHERE almtfami.codcia = s-codcia AND 
                                almtfami.codfam = x-vtatabla.llave_c2 NO-LOCK:
        FOR EACH almsfami OF almtfami NO-LOCK:
                FIND FIRST tt-lineas WHERE tt-lineas.tcodfam = almtfam.codfam AND
                                            tt-lineas.tsubfam = almsfam.subfam
                                            EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE tt-lineas THEN DO:
                    CREATE tt-lineas.
                        ASSIGN  tt-lineas.tcodfam = almtfami.codfam
                                tt-lineas.tsubfam = almsfami.subfam
                                .
                END.
        END.                                
    END.
END.

/* Todas las Lineas (010) y SubLineas (003) */
FOR EACH x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                            x-vtatabla.tabla = x-tabla AND
                            x-vtatabla.llave_c1 = x-tipo-dscto AND 
                            x-vtatabla.llave_c2 <> '*' AND 
                            x-vtatabla.llave_c3 <> '*' AND 
                            x-vtatabla.libre_c01 = '+' NO-LOCK:
    FOR EACH almtfami WHERE almtfami.codcia = s-codcia AND 
                                almtfami.codfam = x-vtatabla.llave_c2 NO-LOCK:
        FOR EACH almsfami OF almtfami WHERE almsfami.subfam = x-vtatabla.llave_c3 NO-LOCK:
                FIND FIRST tt-lineas WHERE tt-lineas.tcodfam = almtfam.codfam AND
                                            tt-lineas.tsubfam = almsfam.subfam
                                            EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE tt-lineas THEN DO:
                    CREATE tt-lineas.
                        ASSIGN  tt-lineas.tcodfam = almtfami.codfam
                                tt-lineas.tsubfam = almsfami.subfam
                                .
                END.
        END.                                
    END.
END.

/* EXCLUSIONES */
/* Todas las Lineas (010) y SubLineas (*) */
FOR EACH x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                            x-vtatabla.tabla = x-tabla AND
                            x-vtatabla.llave_c1 = x-tipo-dscto AND 
                            x-vtatabla.llave_c2 <> '*' AND 
                            x-vtatabla.llave_c3 = '*' AND 
                            x-vtatabla.libre_c01 = '-' NO-LOCK:
    FOR EACH almtfami WHERE almtfami.codcia = s-codcia AND 
                                almtfami.codfam = x-vtatabla.llave_c2 NO-LOCK:
        FOR EACH almsfami OF almtfami NO-LOCK:
                FIND FIRST tt-lineas WHERE tt-lineas.tcodfam = almtfam.codfam AND
                                            tt-lineas.tsubfam = almsfam.subfam
                                            EXCLUSIVE-LOCK NO-ERROR.
                IF AVAILABLE tt-lineas THEN DO:
                    DELETE tt-lineas.
                END.
        END.                                
    END.
END.

/* Todas las Lineas (010) y SubLineas (005) */
FOR EACH x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                            x-vtatabla.tabla = x-tabla AND
                            x-vtatabla.llave_c1 = x-tipo-dscto AND 
                            x-vtatabla.llave_c2 <> '*' AND 
                            x-vtatabla.llave_c3 <> '*' AND 
                            x-vtatabla.libre_c01 = '-' NO-LOCK:

    FIND FIRST tt-lineas WHERE tt-lineas.tcodfam = x-vtatabla.llave_c2 AND
                                tt-lineas.tsubfam = x-vtatabla.llave_c3
                                EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE tt-lineas THEN DO:
        DELETE tt-lineas.
    END.

END.
/*
/**/
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */


c-xls-file = 'd:\xpciman\lineas.xlsx'.

run pi-crea-archivo-csv IN hProc (input  buffer tt-lineas:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-lineas:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.
*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Pronto-Despacho) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pronto-Despacho Procedure 
PROCEDURE Pronto-Despacho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR s-Tabla AS CHAR INIT "DSCTO_DESPACHO" NO-UNDO.

/* Buscamos la configuración */
FIND FIRST VtaCTabla WHERE VtaCTabla.CodCia = s-CodCia AND 
    VtaCTabla.Tabla = s-Tabla AND 
    VtaCTabla.Llave = COTIZACION.Libre_c01
    /*VtaCTabla.Llave = ORDEN.Lista_de_Precios*/
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaCTabla THEN RETURN 'OK'.
IF ORDEN.FchEnt > VtaCTabla.Libre_f01 THEN RETURN 'OK'.

/* Acumulamos Importes por cada Item */
DEF VAR x-Importe AS de NO-UNDO.
FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK,
    FIRST Almmmatg OF Ccbddocu NO-LOCK:
    /* Inclusiones */
    FIND FIRST VtaDTabla OF VtaCTabla WHERE VtaDTabla.Tipo = Almmmatg.CodFam NO-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaDTabla THEN NEXT.
    x-Importe = x-Importe + (CcbDDocu.ImpLin - CcbDDocu.ImpDto2).   /* Importe neto */
END.
IF x-Importe <= 0 THEN RETURN 'OK'.

DEF VAR x-PorDto AS DEC NO-UNDO.

x-PorDto = VtaCTabla.Libre_d01.
IF x-PorDto <= 0 THEN RETURN 'OK'.

RUN Calcular-Descuento (INPUT x-PorDto,     /* % de descuento */
                        INPUT x-Importe,    /* Importe afecto */
                        INPUT s-Tabla).     /* Motivo del descuento */

IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Ubigeo-Cliente) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ubigeo-Cliente Procedure 
PROCEDURE Ubigeo-Cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodCli AS CHAR.
DEF OUTPUT PARAMETER pCodDpto AS CHAR.
DEF OUTPUT PARAMETER pCodProv AS CHAR.
DEF OUTPUT PARAMETER pCodDist AS CHAR.

DEF VAR pUbigeo AS CHAR NO-UNDO.
DEF VAR pLongitud AS DEC NO-UNDO.
DEF VAR pLatitud AS DEC NO-UNDO.

ASSIGN
    pCodDpto = '15'
    pCodProv = '01'      /* Lima - Lima */
    pCodDist = '01'
    .
RUN logis/p-datos-sede-auxiliar ("@CL",
                                 pCodCli,
                                 "@@@",
                                 OUTPUT pUbigeo,
                                 OUTPUT pLongitud,
                                 OUTPUT pLatitud).
IF pUbigeo > '' THEN DO:
    pCodDpto = SUBSTRING(pUbigeo,1,2).
    pCodProv = SUBSTRING(pUbigeo,3,2).
    pCodDist = SUBSTRING(pUbigeo,5,2).
    RETURN.
END.
FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND
    gn-clie.codcli = pCodCli NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clie THEN RETURN.
IF gn-clie.CodDept + gn-clie.CodProv + gn-clie.CodDist > '' THEN
    ASSIGN
    pCodDpto = gn-clie.CodDept 
    pCodProv = gn-clie.CodProv 
    pCodDist = gn-clie.CodDist.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

