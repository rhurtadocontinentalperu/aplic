&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Devuelve la fecha de entrega sugerida

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* CONSISTENCIA DE FECHA DE ENTREGA */
DEF INPUT PARAMETER pPedido AS CHAR.
DEF INPUT PARAMETER pFechaBase AS DATE.
DEF INPUT PARAMETER pHoraBase AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.    /* Almacén Despacho */
DEF INPUT PARAMETER pUbigeo AS CHAR.
DEF INPUT PARAMETER pNroSKU AS INT.
DEF INPUT PARAMETER pPeso   AS DEC.
DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pDivOri AS CHAR.
DEF INPUT PARAMETER pReferencia AS CHAR.    /* La COTIZACION, Ej. COT,214000010 */
DEF INPUT-OUTPUT PARAMETER pFchEnt AS DATE.
DEF OUTPUT PARAMETER pError AS CHAR.

pError = ''.    /* Valor por Defecto */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.

IF pFchEnt < pFechaBase THEN pFchEnt = pFechaBase.

/* Parche */
IF NUM-ENTRIES(pPedido) = 0 THEN pPedido = ','.
IF NUM-ENTRIES(pReferencia) = 0 THEN pReferencia = ','.

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
         HEIGHT             = 4.08
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF BUFFER PEDIDO FOR Faccpedi.

/* *************************************************************************** */
/* DETERMINAMOD SI EL ALMACEN DE DESPACHO ES UN CENTRO DE DISTRIBUCION         */
/* *************************************************************************** */
DEF VAR s-CentroDistribucion AS LOG INIT NO NO-UNDO.

FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = pCodAlm
    AND CAN-FIND(FIRST gn-divi WHERE gn-divi.codcia = s-codcia
                 AND gn-divi.coddiv = Almacen.coddiv 
                 AND gn-divi.Campo-Log[5] = YES NO-LOCK)
    NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN s-CentroDistribucion = YES.

/* **************************************************************************** */
/* LAS EXCEPCIONES NO TIENEN HORA DE CORTE PERO POR LO MENOS UN DIA DE ATENCION */
/* **************************************************************************** */
DEF VAR x-Minimo-1 AS INT INIT 1 NO-UNDO.   /* Mínimo 1 día antes de la hora de corte */
DEF VAR x-Minimo-2 AS INT INIT 2 NO-UNDO.   /* Mínimo 2 días despues de la hora de corte */
IF WEEKDAY(pFechaBase) = 7 THEN     /* Sábado saltamos un día más */
    ASSIGN
        x-Minimo-1 = x-Minimo-1 + 1
        x-Minimo-2 = x-Minimo-2 + 1.
/* **************************************************************************** */
/* **************************************************************************** */
/* Clientes en la tabla de Excepciones */
IF CAN-FIND(FIRST FacTabla WHERE FacTabla.CodCia = s-codcia
            AND FacTabla.Tabla = 'CLNOCLI'
            AND FacTabla.Codigo = pCodCli NO-LOCK)
    THEN DO:
    /* Como mínimo un día */
    IF pFchEnt - pFechaBase < x-Minimo-1 THEN pFchEnt = pFechaBase + x-Minimo-1.
    IF WEEKDAY(pFchEnt) = 1 THEN pFchEnt = pFchEnt + 1.
    RETURN.
END.
/* ***************************************************************** */
/* División Origen en tabla de Excepciones */
/* RHC 08/11/17 Se ha agregado "Dias Minimo de despacho" */
FIND FIRST FacTabla WHERE FacTabla.CodCia = s-codcia
    AND FacTabla.Tabla = 'CLNODIV'
    AND FacTabla.Codigo = pDivOri 
    NO-LOCK NO-ERROR.
IF AVAILABLE FacTabla THEN DO:
    IF FacTabla.Valor[1] > 0 THEN DO:   /* Días Mínimo Despacho, por ejemplo 4 días */
        IF pFchEnt - pFechaBase < FacTabla.Valor[1] THEN pFchEnt = pFechaBase + FacTabla.Valor[1].
    END.
    ELSE DO:
        /* Como mínimo un día */
        IF pFchEnt - pFechaBase < x-Minimo-1 THEN pFchEnt = pFechaBase + x-Minimo-1.
    END.
    IF WEEKDAY(pFchEnt) = 1 THEN pFchEnt = pFchEnt + 1.     /* Si cae domingo */
    RETURN.
END.
/* *************************************************************************** */
/* FIN DE EXCEPCIONES                                                          */
/* *************************************************************************** */
/* *************************************************************************** */
/* REGLA GENERAL: DIAS ANTES DE DESPACHAR */
/* *************************************************************************** */
/* Definimos la hora de corte */
DEF VAR pHoraCorte AS CHAR NO-UNDO.
IF s-CentroDistribucion = YES THEN DO:
    pHoraCorte = "18:00:00".
END.
ELSE DO:
    pHoraCorte = "17:00:00".
END.
IF NUM-ENTRIES(pHoraBase,':') < 3 THEN pHoraBase = pHoraBase + ':00'.
/* *************************************************************************** */
/* RUTINA NORMAL CUANDO EL ALMACEN DE DESPACHO NO ES UN CENTRO DE DISTRIBUCION */
/* *************************************************************************** */
IF s-CentroDistribucion = NO THEN DO:
    /* La fecha de entrega no debe tener menos de 24h */
    IF pHoraBase > pHoraCorte THEN DO:
        /* Como mínimo dos días */
        IF pFchEnt - pFechaBase < x-Minimo-2 THEN pFchEnt = pFechaBase + x-Minimo-2.
    END.
    ELSE DO:
        /* Como mínimo un día */
        IF pFchEnt - pFechaBase < x-Minimo-1 THEN pFchEnt = pFechaBase + x-Minimo-1.
    END.
    IF WEEKDAY(pFchEnt) = 1 THEN pFchEnt = pFchEnt + 1.
    RETURN.     /*FIN DEL PROCESO */
END.
/* *************************************************************************** */
/* *************************************************************************** */
/* RUTINA SOLO PARA CENTRO DE DISTRIBUCION */
/* *************************************************************************** */
/* RHC 12/10/2017 Cesar Camus */
/* Buscamos la división ORIGEN */
FIND Gn-divi WHERE Gn-divi.codcia = s-codcia
    AND Gn-divi.coddiv = pDivOri
    NO-LOCK NO-ERROR.
CASE TRUE:
    WHEN GN-DIVI.CanalVenta = "TDA" OR GN-DIVI.CanalVenta = "INS" THEN DO:    
        /* Tiendas Mayoristas  o Institucionales */
        /* Corte a las 5pm mínimo 1 día */
        ASSIGN
            pHoraCorte = "17:00:00"            
            x-Minimo-1 = 1
            x-Minimo-2 = 2.
    END.
    OTHERWISE DO:   /* Las demás divisiones */
        /* Sin Corte mínimo 2 días */
        ASSIGN
            x-Minimo-1 = 2
            x-Minimo-2 = 2.
        /* Buscamos su ubigeo */
        DEF VAR cCodDept AS CHAR NO-UNDO.
        DEF VAR cCodProv AS CHAR NO-UNDO.
        DEF VAR cCodDist AS CHAR NO-UNDO.
        ASSIGN
            cCodDept = SUBSTRING(pUbigeo,1,2)
            cCodProv = SUBSTRING(pUbigeo,3,2)
            cCodDist = SUBSTRING(pUbigeo,5,2).
        IF pUbigeo = "P0" OR pUbigeo = "CR" THEN DO:
            /* Buscamos por datos del cliente */
            FIND gn-clie WHERE gn-clie.codcia = cl-codcia
                AND gn-clie.codcli = pCodCli NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clie THEN DO:
                ASSIGN
                    cCodDept = gn-clie.CodDept
                    cCodProv = gn-clie.CodProv
                    cCodDist = gn-clie.CodDist.
            END.
        END.
        ELSE DO:
            /* Suponemos que es un Código Postal */
            FIND Almtabla WHERE Almtabla.Tabla = "CP" AND Almtabla.Codigo = pUbigeo
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtabla THEN DO:
                /* CODIGO POSTAL */
                FIND TabDistr WHERE TabDistr.CodPos = Almtabla.Codigo NO-LOCK NO-ERROR.
                IF AVAILABLE TabDistr THEN DO:
                    ASSIGN
                        cCodDept = TabDistr.CodDepto 
                        cCodProv = TabDistr.CodProvi 
                        cCodDist = TabDistr.CodDistr.
                END.
            END.
        END.
        FIND TabDistr WHERE TabDistr.CodDepto = cCodDept AND
            TabDistr.CodProvi = cCodProv AND
            TabDistr.CodDistr = cCodDist
            NO-LOCK NO-ERROR.
        IF AVAILABLE TabDistr AND LOOKUP(TabDistr.CodDepto, '01,20,22,25,16') > 0 THEN DO:
            /* Sin Corte mínimo 3 días */
            ASSIGN
                x-Minimo-1 = 3
                x-Minimo-2 = 3.
        END.
    END.
END CASE.
IF WEEKDAY(pFechaBase) = 7 THEN     /* Sábado saltamos un día más */
    ASSIGN
        x-Minimo-1 = x-Minimo-1 + 1
        x-Minimo-2 = x-Minimo-2 + 1.
/* Buscamos día programado para el Centro de Distribución */
DEF VAR cCodDiv AS CHAR NO-UNDO.
cCodDiv = Almacen.CodDiv.   /* Centro de Distribución */
/* El parámetro pUbigeo puede ser:
    150103  Departamento, 
    Provincia y Distrito (DDPPdd)
    L03     Código Postal
    CR      Cliente Recoge
    P0      Provincias
    */
/* DETERMINAMOS LA ZONA GEOGRAFICA DEL DESPACHO */
DEF VAR cZonaGHR AS CHAR NO-UNDO.
DEF VAR cSubZonaGHR AS CHAR NO-UNDO.
CASE pUbigeo:
    WHEN "P0" THEN ASSIGN cZonaGHR = "02" cSubZonaGHR = "01".     /* LIMA CENTRO (AGENCIAS) */
    WHEN "CR" THEN ASSIGN cZonaGHR = "CR" cSubZonaGHR = "CR".     /* CLIENTE RECOGE */
    OTHERWISE DO:
        /* Primero suponemos que es un Código Postal */
        FIND Almtabla WHERE Almtabla.Tabla = "CP" AND Almtabla.Codigo = pUbigeo
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtabla THEN DO:
            /* CODIGO POSTAL */
            FIND TabDistr WHERE TabDistr.CodPos = Almtabla.Codigo NO-LOCK NO-ERROR.
            IF NOT AVAILABLE TabDistr THEN DO:
                pError = "NO está configurado el código postal " + pUbigeo + CHR(10) +
                    " en la programación de Pre-Hojas de Ruta".
                RETURN.
            END.
            pUbigeo = TRIM(TabDistr.CodDepto) + TRIM(TabDistr.CodProvi) + TRIM(TabDistr.CodDistr).
        END.
        /* UBIGEO */
        FIND FIRST VtaDTabla WHERE VtaDTabla.CodCia = s-CodCia
            AND VtaDTabla.Tabla = 'SZGHR'
            AND VtaDTabla.LlaveDetalle = "D"
            AND VtaDTabla.Libre_c01 = SUBSTRING(pUbigeo,1,2)
            AND VtaDTabla.Libre_c02 = SUBSTRING(pUbigeo,3,2)
            AND VtaDTabla.Libre_c03 = SUBSTRING(pUbigeo,5,2)
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE VtaDTabla THEN DO:
            pError = "NO está configurado el código de ubigeo " + pUbigeo + CHR(10) +
                " en la programación de Pre-Hojas de Ruta".
            RETURN.
        END.
        ASSIGN
            cZonaGHR    = VtaDTabla.Llave
            cSubZonaGHR = VtaDTabla.Tipo.
    END.
END CASE.
FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-codcia
    AND VtaTabla.Tabla = "SZGHRXDIA"
    AND VtaTabla.Llave_c1 = cCodDiv
    AND VtaTabla.Llave_c2 = cZonaGHR
    AND VtaTabla.Llave_c3 = cSubZonaGHR
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla THEN DO:
    pError = "NO está configurado el cronograma de despacho del ubigeo: " + pUbigeo + CHR(10) +
        " en la programación de Despachos".
    RETURN.
END.
/* *********************************************** */
/* BUSCAMOS EL MINIMO DE DIAS DE ACUERDO A LA ZONA */
/* POR EJEMPLO ZONA NORTE                          */
/* *********************************************** */
/* FIND VtaCTabla WHERE VtaCTabla.CodCia = s-codcia                                    */
/*     AND VtaCTabla.Tabla = "ZGHR"                                                    */
/*     AND VtaCTabla.Llave = cZonaGHR                                                  */
/*     NO-LOCK NO-ERROR.                                                               */
/* IF AVAILABLE VtaCTabla AND VtaCTabla.Libre_d01 > 0 THEN DO:                         */
/*     ASSIGN                                                                          */
/*         x-Minimo-1 = VtaCTabla.Libre_d01        /* Por Ejemplo LIMA NORTE 3 días */ */
/*         x-Minimo-2 = VtaCTabla.Libre_d01 + 1.                                       */
/* END.                                                                                */
/* AHORA SI DETERMINAMOS LA FECHA DE PARTIDA */
IF pHoraBase > pHoraCorte THEN DO:
    IF pFchEnt - pFechaBase < x-Minimo-2 THEN pFchEnt = pFechaBase + x-Minimo-2.
END.
ELSE DO:
    IF pFchEnt - pFechaBase < x-Minimo-1 THEN pFchEnt = pFechaBase + x-Minimo-1.
END.
IF WEEKDAY(pFchEnt) = 1 THEN pFchEnt = pFchEnt + 1.     /* Si es domingo corre un día */

/* *********************************************************************** */
/* CASO PROVINCIAS: 00060 y 00068 NO tienen programadas fechas de despacho */
/* *********************************************************************** */
FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-codcia
    AND VtaTabla.Tabla = "SZGHRXDIA"
    AND VtaTabla.Llave_c1 = cCodDiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla THEN DO:
    /* La fecha es la correcta */
    RETURN.
END.
/* *********************************************************************** */
DEF VAR fFchProg AS DATE NO-UNDO.
DEF VAR iNroSKU AS INT NO-UNDO.
DEF VAR dPeso   AS DEC NO-UNDO.

DEF BUFFER B-TABLA FOR VtaTabla.
FIND B-TABLA WHERE B-TABLA.codcia = s-codcia 
    AND B-TABLA.Tabla = 'CDSKU'
    AND B-TABLA.Llave_c1 = cCodDiv
    NO-LOCK NO-ERROR.
fFchProg = pFchEnt - 1.     /* OJO: Punto de partida */
/* BUSCAMOS DIA PROGRAMADO PARA DESPACHO */
PRINCIPAL:
REPEAT:
    fFchProg = fFchProg + 1.
    IF WEEKDAY(fFchProg) = 1 THEN NEXT.     /* Salta el domingo */
    FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia
        AND VtaTabla.Tabla = "SZGHRXDIA"
        AND VtaTabla.Llave_c1 = cCodDiv
        AND VtaTabla.Llave_c2 = cZonaGHR
        AND VtaTabla.Llave_c3 = cSubZonaGHR
        AND VtaTabla.Valor[1] = WEEKDAY(fFchProg)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaTabla THEN NEXT.    /* NO tiene programado ese día */
                                            /* Pasa al siguiente día */
    IF NOT AVAILABLE B-TABLA  THEN LEAVE.   /* NO tiene minimo de SKU, fecha OK */
    IF B-TABLA.Valor[1] = 0                 /* NO tiene mínimos definidos, fecha OK */
        AND B-TABLA.Valor[2] = 0 
        AND B-TABLA.Valor[3] = 0 
        AND B-TABLA.Valor[4] = 0
        THEN LEAVE. 
    /* ************************************************************* */
    /* RHC 31/10/17 Si ya ha sido programado entonces toma esa fecha */
    /* ************************************************************* */
/*     FIND FIRST Faccpedi WHERE Faccpedi.codcia = s-codcia                       */
/*         AND Faccpedi.divdes = cCodDiv                                          */
/*         AND Faccpedi.coddoc = 'O/D'                                            */
/*         AND Faccpedi.codcli = pCodCli                                          */
/*         AND Faccpedi.fchent = fFchProg                                         */
/*         AND LOOKUP(Faccpedi.flgest, 'A,X') = 0  /* NI anulado ni en proceso */ */
/*         NO-LOCK NO-ERROR.                                                      */
/*     IF AVAILABLE Faccpedi THEN LEAVE PRINCIPAL.                                */
    /* ************************************************************** */
    ASSIGN
        iNroSKU = 0
        dPeso   = 0.
    /* # de SKU */
    FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.divdes = cCodDiv
        AND Faccpedi.coddoc = 'PED'
        AND Faccpedi.fchent = fFchProg
        /*AND LOOKUP(Faccpedi.flgest, 'V,A,R,C,S,E,O,F') = 0:*/
        AND LOOKUP(Faccpedi.FlgEst, "G,X") > 0:      /* Pedidos por Aprobar */
        /* Programado para ese día. OJO >>> No se toma en cuenta el mismo pedido */
/*         IF NOT (Faccpedi.coddoc = ENTRY(1,pPedido) AND Faccpedi.nroped = ENTRY(2,pPedido)) */
/*             AND Faccpedi.codcli = pCodCli                                                  */
/*             AND Faccpedi.codref = ENTRY(1,pReferencia)                                     */
/*             AND Faccpedi.nroref = ENTRY(2,pReferencia)                                     */
/*             THEN LEAVE PRINCIPAL.                                                          */
        /* Acumulamos */
        FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
            iNroSKU = iNroSKU + 1.
            dPeso = dPeso + ((Facdpedi.canped * Facdpedi.factor) * Almmmatg.Pesmat).
        END.
    END.
    FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.divdes = cCodDiv
        AND Faccpedi.coddoc = 'O/D'
        AND Faccpedi.fchent = fFchProg
        AND Faccpedi.flgest = 'P':
        /* Programado para ese día */
        IF Faccpedi.codcli = pCodCli THEN DO:
            FIND FIRST PEDIDO WHERE PEDIDO.codcia = s-codcia
                AND PEDIDO.coddoc = Faccpedi.codref
                AND PEDIDO.nroped = Faccpedi.nroref
                AND PEDIDO.codref = ENTRY(1,pReferencia)
                AND PEDIDO.nroref = ENTRY(2,pReferencia)
                NO-LOCK NO-ERROR.
            IF AVAILABLE PEDIDO THEN LEAVE PRINCIPAL.
        END.
        /* Acumulamos */
        FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
            iNroSKU = iNroSKU + 1.
            dPeso = dPeso + ((Facdpedi.canped * Facdpedi.factor) * Almmmatg.Pesmat).
        END.
    END.
    FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.divdes = cCodDiv
        AND Faccpedi.coddoc = 'OTR'
        AND Faccpedi.fchent = fFchProg
        AND Faccpedi.flgest = 'P':
        /* Acumulamos */
        FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
            iNroSKU = iNroSKU + 1.
            dPeso = dPeso + ((Facdpedi.canped * Facdpedi.factor) * Almmmatg.Pesmat).
        END.
    END.
    iNroSKU = iNroSKU + pNroSKU.
    dPeso = dPeso + pPeso.
    IF WEEKDAY(fFchProg) >= 2 AND WEEKDAY(fFchProg) <= 6 THEN DO:   /* Lunes a Viernes */
        IF B-TABLA.Valor[1] > 0 AND iNroSKU > B-TABLA.Valor[1] * 1.15 THEN NEXT.
        IF B-TABLA.Valor[3] > 0 AND dPeso > B-TABLA.Valor[3] * 1.15   THEN NEXT.
        LEAVE.      /* Fecha OK */
    END.
    ELSE DO:                                                        /* Sábado y Domingo */
        IF B-TABLA.Valor[2] > 0 AND iNroSKU > B-TABLA.Valor[2] * 1.15 THEN NEXT.
        IF B-TABLA.Valor[4] > 0 AND dPeso > B-TABLA.Valor[4] * 1.15   THEN NEXT.
        LEAVE.      /* Fecha OK */
    END.
END.
pFchEnt = fFchProg.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


