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

/* ICBPER */
DEFINE VAR x-articulo-ICBPER AS CHAR.

x-articulo-ICBPER = '099268'.

DEFINE BUFFER x-vtatabla FOR vtatabla.

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
         HEIGHT             = 5.92
         WIDTH              = 69.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pContado AS LOG.
DEF OUTPUT PARAMETER pComprometido AS DEC NO-UNDO.

DEFINE VAR x-flg-reserva-stock AS CHAR.

pComprometido = 0.  /* Valor por defecto */   

IF NUM-ENTRIES(pCodAlm) > 1 THEN pCodAlm = ENTRY(1, pCodAlm).   /* El 1er almacén */

/* CALCULO DEL STOCK COMPROMETIDO */
DEF SHARED VAR s-codcia AS INT.

FIND FIRST integral.FacCfgGn WHERE integral.faccfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE integral.Faccfggn THEN RETURN.

/* IMPSTO BOLSAS PLASTICAS NO CONTROLA STOCK */
IF x-articulo-ICBPER = pCodMat THEN RETURN.
/* **************************************************************************** */
/* RHC 12/06/2020 Líneas de Productos con Cat. Contab. = "SV" no controla stock */
/* **************************************************************************** */
FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia AND
    Almmmatg.codmat = pCodMat NO-LOCK NO-ERROR.
IF AVAILABLE Almmmatg THEN DO:
    FIND FIRST Almtfami OF Almmmatg NO-LOCK NO-ERROR.
    IF AVAILABLE Almtfami AND Almtfami.Libre_c01 = "SV" THEN RETURN.
END.
/* **************************************************************************** */
/* Buffers de trabajo */
DEF BUFFER B-DPEDI FOR integral.Facdpedi.
DEF BUFFER B-CPEDI FOR integral.Faccpedi.
DEF BUFFER B-CREPO FOR integral.Almcrepo.
DEF BUFFER B-DREPO FOR integral.Almdrepo.

/* ********************************************************************************************* */
/* Stock comprometido por PEDIDOS ACTIVOS MOSTRADOR */
/* ********************************************************************************************* */
DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.
DEF VAR TimeLimit AS CHARACTER NO-UNDO.

IF pContado = YES THEN DO:
    /* Tiempo por defecto fuera de campaña */
    TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
              (FacCfgGn.Hora-Res * 3600) + 
              (FacCfgGn.Minu-Res * 60).
    FOR EACH B-DPEDI USE-INDEX Llave04 NO-LOCK WHERE B-DPEDI.codcia = s-CodCia
        AND B-DPEDI.almdes = pCodAlm
        AND B-DPEDI.codmat = pCodMat
        AND B-DPEDI.coddoc = 'P/M'
        AND B-DPEDI.flgest = 'P',
        FIRST B-CPEDI OF B-DPEDI NO-LOCK WHERE B-CPEDI.FlgEst = "P":
        TimeNow = (TODAY - B-CPEDI.FchPed) * 24 * 3600.
        TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(B-CPEDI.Hora, 1, 2)) * 3600) +
                  (INTEGER(SUBSTRING(B-CPEDI.Hora, 4, 2)) * 60) ).
        IF TimeOut > 0 THEN DO:
            IF TimeNow <= TimeOut   /* Dentro de la valides */
            THEN DO:
                /* cantidad en reservacion */
                pComprometido = pComprometido + (B-DPEDI.Factor * B-DPEDI.CanPed).
            END.
        END.
    END.
END.
/* ********************************************************************************************* */
/* RHC 23/04/2020 Mercadería comprometida por Cotizaciones */
/* ********************************************************************************************* */
/* Barremos todas las divisiones que comprometen stock por COTIZACIONES */
RLOOP:
FOR EACH FacTabla NO-LOCK WHERE FacTabla.codcia = s-CodCia AND
    FacTabla.tabla = 'GN-DIVI' AND
    FacTabla.campo-l[2] = YES:
    /* RHC 21/05/2020 Ahora tiene horas y/o hora tope */
    /* Pasada esa hora NO vale la Cotización */
    TimeLimit = ''.
    IF FacTabla.campo-c[1] > '' AND FacTabla.campo-c[1] > '0000' THEN DO:
        TimeLimit = STRING(FacTabla.campo-c[1], 'XX:XX').
        IF STRING(TIME, 'HH:MM') > TimeLimit THEN NEXT RLOOP.
    END.
    TimeOut = 0.
    IF FacTabla.valor[1] > 0 THEN TimeOut = (FacTabla.Valor[1] * 3600).       /* Tiempo máximo en en segundos */

    x-flg-reserva-stock = "P".

    /*  Ic - 10Feb2021
        Divisiones que tienen que reservar Stock con un flgest en particular
     
        Correo de Daniel Llican, meet con Karim Mujica y Hiroshi Salcedo
        3. Una programación excepcional (si es posible que sea configurable) que rompa la actual regla del 
            canal mayorista para que no sea necesario aprobaciones de administrador y supervisor antes de 
            reservar stock, ya que en el canal de venta minorista whatsapp quien registra el pedido comercial 
            es un administrador, comparativamente con un vendedor la posibilidad de error es mucho menor 
            (pedido comercial OK en SKU y Cantidad al primer intento).        
     */
    
    FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                                x-vtatabla.tabla = "CONFIG-VTAS" AND
                                x-vtatabla.llave_c1 = "PEDIDO.COMERCIAL" AND
                                x-vtatabla.llave_c2 = "FLG.RESERVA.STOCK" AND
                                x-vtatabla.llave_c3 = FacTabla.Codigo NO-LOCK NO-ERROR.     /* division */
    IF AVAILABLE x-vtatabla THEN DO:
       IF NOT (TRUE <> (x-vtatabla.llave_c4 > "")) THEN DO:
            x-flg-reserva-stock = TRIM(x-vtatabla.llave_c4).
       END.
    END.

    /* Barremos todas las cotizaciones relacionadas */
    DEF VAR k AS INTE NO-UNDO.
    DO k = 1 TO NUM-ENTRIES(x-Flg-Reserva-Stock):
        FOR EACH B-DPEDI USE-INDEX Llave04 NO-LOCK WHERE B-DPEDI.codcia = s-CodCia
                AND B-DPEDI.almdes = pCodAlm
                AND B-DPEDI.codmat = pCodMat
                AND B-DPEDI.coddoc = 'COT'
                AND B-DPEDI.flgest = 'P' 
                AND B-DPEDI.CanPed > B-DPEDI.canate
                AND B-DPEDI.CodDiv = FacTabla.Codigo,
            FIRST B-CPEDI OF B-DPEDI NO-LOCK WHERE B-CPEDI.CodDiv = FacTabla.Codigo 
            AND B-CPEDI.FlgEst = ENTRY(k, x-Flg-Reserva-Stock):
            /*AND LOOKUP(B-CPEDI.FlgEst, x-Flg-Reserva-Stock) > 0:*/
            TimeNow = (TODAY - B-CPEDI.FchPed) * 24 * 3600.
            TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(B-CPEDI.Hora, 1, 2)) * 3600) +
                      (INTEGER(SUBSTRING(B-CPEDI.Hora, 4, 2)) * 60) ).
            IF TimeOut > 0 THEN DO:
                IF TimeNow <= TimeOut   /* Dentro de la valides */
                THEN DO:
                    /* cantidad en reserva */
                    pComprometido = pComprometido + (B-DPEDI.Factor * (B-DPEDI.CanPed - B-DPEDI.CanAte)).
                END.
            END.
        END.
    END.
END.
/* ********************************************************************************************* */
/**********   Barremos para los PEDIDOS AL CREDITO   ***********************/ 
/* ********************************************************************************************* */
RUN PED-Comprometido (pCodAlm,pCodMat,"O/D","P",INPUT-OUTPUT pComprometido).
RUN PED-Comprometido (pCodAlm,pCodMat,"OTR","P",INPUT-OUTPUT pComprometido).

FOR EACH B-DPEDI NO-LOCK WHERE B-DPEDI.codcia = s-CodCia
    AND B-DPEDI.almdes = pCodAlm
    AND B-DPEDI.codmat = pCodMat
    AND B-DPEDI.coddoc = "PED"
    AND B-DPEDI.flgest = 'P'
    AND B-DPEDI.CanPed > B-DPEDI.canate,
    FIRST B-CPEDI WHERE B-CPEDI.codcia = B-DPEDI.codcia
        AND B-CPEDI.coddiv = B-DPEDI.coddiv
        AND B-CPEDI.coddoc = B-DPEDI.coddoc
        AND B-CPEDI.nroped = B-DPEDI.nroped NO-LOCK:
    IF LOOKUP(B-CPEDI.FlgEst, "G,X,P,W,WX,WL") = 0 THEN NEXT.
    pComprometido = pComprometido + (B-DPEDI.Factor * (B-DPEDI.CanPed - B-DPEDI.canate)).
END.
/*
FOR EACH B-DPEDI NO-LOCK WHERE B-DPEDI.codcia = s-CodCia
    AND B-DPEDI.almdes = pCodAlm
    AND B-DPEDI.codmat = pCodMat
    AND B-DPEDI.coddoc = "PED"
    AND B-DPEDI.flgest = 'P'
    AND B-DPEDI.CanPed > B-DPEDI.canate,
    FIRST B-CPEDI OF B-DPEDI WHERE LOOKUP(B-CPEDI.FlgEst, "G,X,P,W,WX,WL") > 0 NO-LOCK:
    pComprometido = pComprometido + (B-DPEDI.Factor * (B-DPEDI.CanPed - B-DPEDI.canate)).
END.
*/

/* ********************************************************************************************* */
/* Stock Comprometido por Pedidos por Reposicion Automatica */
/* ********************************************************************************************* */
/* A: R/A Automática */
/* M: R/A Manual */
/* RAN: R/A Nocturna */
/* INC: R/A por Incidencia */
/* OJO ver tambien el programa vtamay/c-conped.w */

/* 18/03/2022 tomar en cuenta estado "X" para las reposiciones "EN PROCESO" RAN */
FOR EACH B-DREPO NO-LOCK WHERE B-DREPO.codcia = s-codcia
    AND B-DREPO.codmat = pCodMat
    AND B-DREPO.flgest = "P"
    AND B-DREPO.almped = pCodAlm,
    FIRST B-CREPO OF B-DREPO WHERE LOOKUP(B-CREPO.FlgEst, "P,X") > 0 NO-LOCK:
    IF LOOKUP(B-DREPO.TipMov, 'A,M,RAN,INC') = 0 THEN NEXT.
    pComprometido = pComprometido + (B-DREPO.CanApro - B-DREPO.CanAten).
END.

/* FOR EACH B-DREPO NO-LOCK WHERE B-DREPO.codcia = s-codcia                       */
/*     AND B-DREPO.codmat = pCodMat                                               */
/*     AND B-DREPO.flgest = "P"                                                   */
/*     AND B-DREPO.almped = pCodAlm                                               */
/*     AND LOOKUP(B-DREPO.TipMov, 'A,M,RAN,INC') > 0:                             */
/*     FIND FIRST B-CREPO OF B-DREPO WHERE B-CREPO.FlgEst = "P" NO-LOCK NO-ERROR. */
/*     IF NOT AVAILABLE B-CREPO THEN NEXT.                                        */
/*     pComprometido = pComprometido + (B-DREPO.CanApro - B-DREPO.CanAten).       */
/* END.                                                                           */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-PED-Comprometido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PED-Comprometido Procedure 
PROCEDURE PED-Comprometido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pFlgEst AS CHAR.
DEF INPUT-OUTPUT PARAMETER pComprometido AS DECI.

DEFINE VAR x-flg-reserva-stock AS CHAR.

x-flg-reserva-stock = pFlgEst.

IF pCodDoc = "COT" THEN DO:   

    /*  Ic - 10Feb2021
        Divisiones que tienen que reservar Stock con un flgest en particular
     
        Correo de Daniel Llican, meet con Karim Mujica y Hiroshi Salcedo
        3. Una programación excepcional (si es posible que sea configurable) que rompa la actual regla del 
            canal mayorista para que no sea necesario aprobaciones de administrador y supervisor antes de 
            reservar stock, ya que en el canal de venta minorista whatsapp quien registra el pedido comercial 
            es un administrador, comparativamente con un vendedor la posibilidad de error es mucho menor 
            (pedido comercial OK en SKU y Cantidad al primer intento).        
     */
    
    FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                                x-vtatabla.tabla = "CONFIG-VTAS" AND
                                x-vtatabla.llave_c1 = "PEDIDO.COMERCIAL" AND
                                x-vtatabla.llave_c2 = "FLG.RESERVA.STOCK" AND
                                x-vtatabla.llave_c3 = FacTabla.Codigo NO-LOCK NO-ERROR.     /* division */
    IF AVAILABLE x-vtatabla THEN DO:
       IF NOT (TRUE <> (x-vtatabla.llave_c4 > "")) THEN DO:
            x-flg-reserva-stock = TRIM(x-vtatabla.llave_c4).
       END.
    END.
END.

DEF VAR k AS INTE NO-UNDO.

DO k = 1 TO NUM-ENTRIES(x-flg-reserva-stock):
    FOR EACH B-DPEDI NO-LOCK WHERE B-DPEDI.codcia = s-CodCia
        AND B-DPEDI.almdes = pCodAlm 
        AND B-DPEDI.codmat = pCodMat
        AND B-DPEDI.coddoc = pCodDoc
        AND B-DPEDI.flgest = 'P'    
        AND B-DPEDI.CanPed > B-DPEDI.canate:
        FIND FIRST B-CPEDI OF B-DPEDI WHERE B-CPEDI.FlgEst = ENTRY(k, x-flg-reserva-stock) NO-LOCK NO-ERROR.
        /*FIND FIRST B-CPEDI WHERE LOOKUP(B-CPEDI.FlgEst,x-flg-reserva-stock) > 0  NO-LOCK NO-ERROR.*/
        IF NOT AVAILABLE B-CPEDI THEN NEXT.
        pComprometido = pComprometido + (B-DPEDI.Factor * (B-DPEDI.CanPed - B-DPEDI.canate)).
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

