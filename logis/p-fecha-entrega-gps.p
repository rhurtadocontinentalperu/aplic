&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-DIVI FOR GN-DIVI.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE BUFFER DOCBASE FOR FacCPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.



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
DEF INPUT PARAMETER pCodAlm AS CHAR.    /* Almacén Despacho */
DEF INPUT PARAMETER pFechaBase AS DATE.
DEF INPUT PARAMETER pHoraBase AS CHAR.
DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pDivOri AS CHAR.    /* División Solicitante */
DEF INPUT PARAMETER pUbigeo AS CHAR.
DEF INPUT PARAMETER pLongitud AS DEC.   /* Eje X */
DEF INPUT PARAMETER pLatitud AS DEC.    /* Eje Y */
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroPed AS CHAR.
DEF INPUT PARAMETER pNroSKU AS INT.
DEF INPUT PARAMETER pPeso   AS DEC.
DEF INPUT-OUTPUT PARAMETER pFchEnt AS DATE.
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

pError = ''.    /* Valor por Defecto */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.

IF pFchEnt = ? THEN pFchEnt = pFechaBase.
IF pFchEnt < pFechaBase THEN pFchEnt = pFechaBase.

/* RHC 21/05/2018 Se van a definir las llaves para cada pestaña de trabajo */
DEF VAR s-Llave-Capacidad AS CHAR NO-UNDO.
DEF VAR s-Llave-Zona AS CHAR NO-UNDO.
DEF VAR s-Llave-Canal AS CHAR NO-UNDO.
DEF VAR s-Llave-CanalDia AS CHAR NO-UNDO.

DEF VAR cCodDiv AS CHAR NO-UNDO.
DEF VAR cCodDoc AS CHAR NO-UNDO.    /* DOCUMENTO BASE PARA CONFIGURAR EL CALENDARIO POR CUADRANTES */
CASE pCodDoc:
    WHEN "O/D" OR WHEN "O/M" OR WHEN "PED" THEN DO:
        s-Llave-Capacidad = "CDSKU_OD".
        s-Llave-Zona = "SZGHRXDIA_OD".
        s-Llave-Canal = "CANALHR_OD".
        s-Llave-CanalDia = "CANALHRXDIA_OD".
        cCodDoc = "O/D".
    END.
    WHEN "OTR" OR WHEN "R/A" THEN DO:
        s-Llave-Capacidad = "CDSKU_OTR".
        s-Llave-Zona = "SZGHRXDIA_OTR".
        s-Llave-Canal = "CANALHR_OTR".
        s-Llave-CanalDia = "CANALHRXDIA_OTR".
        cCodDoc = "OTR".
    END.
    OTHERWISE DO:
        pError = 'Documento NO contemplado: ' + pCodDoc + ' ???'.
        RETURN.
    END.
END CASE.

/* RHC 22/01/2018 Ajustes a los parámetros en caso de OTR */
/* IF pCodDoc = "OTR" THEN DO:                                                                                         */
/*     FIND Faccpedi WHERE Faccpedi.codcia = s-codcia                                                                  */
/*         AND Faccpedi.coddoc = pCodDoc                                                                               */
/*         AND Faccpedi.nroped = pNroPed                                                                               */
/*         NO-LOCK NO-ERROR.                                                                                           */
/*     IF AVAILABLE Faccpedi THEN DO:                                                                                  */
/*         /* El destino es un almacén */                                                                              */
/*         FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = Faccpedi.codcli NO-LOCK NO-ERROR.         */
/*         IF AVAILABLE Almacen THEN DO:                                                                               */
/*             FIND B-DIVI WHERE B-DIVI.codcia = s-codcia                                                              */
/*                 AND B-DIVI.coddiv = Almacen.coddiv                                                                  */
/*                 NO-LOCK NO-ERROR.                                                                                   */
/*             IF AVAILABLE B-DIVI THEN DO:                                                                            */
/*                 pDivOri = B-DIVI.CodDiv.                                                                            */
/*                 /*pUbigeo = TRIM(B-DIVI.Campo-Char[3]) + TRIM(B-DIVI.Campo-Char[4]) + TRIM(B-DIVI.Campo-Char[5]).*/ */
/*             END.                                                                                                    */
/*         END.                                                                                                        */
/*     END.                                                                                                            */
/* END.                                                                                                                */

DEF VAR fFechaBase AS DATE NO-UNDO.
IF pCodDoc > '' AND pNroPed > '' THEN DO:
    /* Buscamos el documento Base */
    FIND DOCBASE WHERE DOCBASE.codcia = s-codcia
        AND DOCBASE.coddoc = pCodDoc
        AND DOCBASE.nroped = pNroPed
        NO-LOCK NO-ERROR.
    IF AVAILABLE DOCBASE THEN fFechaBase = DOCBASE.FchPed.
END.
ELSE fFechaBase = TODAY.

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
      TABLE: B-DIVI B "?" ? INTEGRAL GN-DIVI
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: DOCBASE B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 6
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* DETERMINAMOS SI EL ALMACEN DE DESPACHO ES UN CENTRO DE DISTRIBUCION         */
/* *************************************************************************** */
DEF VAR s-CentroDistribucion AS LOG INIT NO NO-UNDO.

FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = pCodAlm
    AND CAN-FIND(FIRST gn-divi WHERE gn-divi.codcia = s-codcia
                 AND gn-divi.coddiv = Almacen.coddiv 
                 AND gn-divi.Campo-Log[5] = YES     /* Centro de Distribucion */
                 NO-LOCK)
    NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN s-CentroDistribucion = YES.

/* *************************************************************************** */
/* REGLA GENERAL: DIAS ANTES DE DESPACHAR */
/* *************************************************************************** */
DEF VAR x-Minimo AS INT INIT 2 NO-UNDO.   /* Mínimo 2 días antes de la hora de corte */

IF WEEKDAY(fFechaBase) = 1 THEN x-Minimo = x-Minimo + 1.    /* Domingo */
FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = pCodAlm
    NO-LOCK NO-ERROR.
cCodDiv = Almacen.CodDiv.   /* ALMACEN DE DESPACHO */
/* Definimos la hora de corte */
DEF VAR x-HoraCorte AS CHAR NO-UNDO.

IF s-CentroDistribucion = YES THEN x-HoraCorte = "18:00:00".
ELSE x-HoraCorte = "17:00:00".
/* ************************************** */
/* RHC 01/02/2018 Buscamos lo configurado */
/* ************************************** */
FIND VtaTabla WHERE VtaTabla.CodCia = s-CodCia
    AND VtaTabla.Tabla = s-Llave-Canal      /*'CANALHR'*/
    AND VtaTabla.Llave_c1 = cCodDiv
    AND VtaTabla.Llave_c2 = pDivOri
    NO-LOCK NO-ERROR.
IF AVAILABLE VtaTabla THEN
    ASSIGN
        x-Minimo    = VtaTabla.Valor[1] + (IF WEEKDAY(fFechaBase) = 1 THEN 1 ELSE 0)
        x-HoraCorte = VtaTabla.Libre_c01.
IF NUM-ENTRIES(x-HoraCorte,':') < 3 THEN x-HoraCorte = x-HoraCorte + ':00'.
IF NUM-ENTRIES(pHoraBase,':') < 3 THEN pHoraBase = pHoraBase + ':00'.
/* *********************************************************************************** */
/* *********************************************************************************** */
/* DEFINIMOS EL SECTOR AL QUE CORRESPONDE LA COORDENADA */
/* NUCLEO DEL CALCULO */
/* Debe haber siempre dos valores predefinidos en los Cuadrantes:
    CR: para Cliente Recoge
    P0: para Provincias
*/    
/* *********************************************************************************** */
/* *********************************************************************************** */

DEF VAR pCuadrante AS CHAR NO-UNDO.
IF LOOKUP(pUbigeo, "CR,P0") > 0 THEN pCuadrante = pUbigeo.   /* Cliente Recoge o Provincias */
ELSE DO:
    /* Buscamos el cuadrante válido definido en las tablas de cuadrantes*/
    /* OJO: Si no lo encuentra => Se asume que es PROVINCIA (P0) */
    RUN logis/p-cuadrante (pLongitud, pLatitud, OUTPUT pCuadrante).
    IF TRUE <> (pCuadrante > '') THEN pCuadrante = "P0".  /* Provincias */
END.

/* *********************************************************************************** */
/* *********************************************************************************** */
IF s-CentroDistribucion = YES THEN DO:
    /* **************************************************************************** */
    /* LAS EXCEPCIONES NO TIENEN HORA DE CORTE PERO POR LO MENOS UN DIA DE ATENCION */
    /* **************************************************************************** */
    DEF VAR x-Excepciones AS LOG INIT NO NO-UNDO.
    EXCEPCIONES:
    DO:
        /* Clientes en la tabla de Excepciones */
        FIND FIRST FacTabla WHERE FacTabla.CodCia = s-codcia
            AND FacTabla.Tabla = 'CLNOCLI'
            AND FacTabla.Codigo = pCodCli NO-LOCK NO-ERROR.
        IF AVAILABLE FacTabla THEN DO:
            ASSIGN
                x-Minimo    = FacTabla.Valor[1] + (IF WEEKDAY(fFechaBase) = 1 THEN 1 ELSE 0)
                x-HoraCorte = FacTabla.Campo-C[1].
            x-Excepciones = YES.
            LEAVE EXCEPCIONES.
        END.
        /* Divisiones en la tabla de Excepciones */
        FIND FIRST FacTabla WHERE FacTabla.CodCia = s-codcia
            AND FacTabla.Tabla = 'CLNODIV'
            AND FacTabla.Codigo = pDivOri 
            NO-LOCK NO-ERROR.
        IF AVAILABLE FacTabla THEN DO:
            ASSIGN
                x-Minimo    = FacTabla.Valor[1] + (IF WEEKDAY(fFechaBase) = 1 THEN 1 ELSE 0)
                x-HoraCorte = FacTabla.Campo-C[1].
            x-Excepciones = YES.
            LEAVE EXCEPCIONES.
        END.
        /* Departamentos en la tabla de Excepciones */
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
        FIND FIRST FacTabla WHERE FacTabla.CodCia = s-codcia
            AND FacTabla.Tabla = 'CLNOUBI'
            AND FacTabla.Codigo = cCodDept NO-LOCK NO-ERROR.
        IF AVAILABLE FacTabla THEN DO:
            ASSIGN
                x-Minimo    = FacTabla.Valor[1] + (IF WEEKDAY(fFechaBase) = 1 THEN 1 ELSE 0)
                x-HoraCorte = FacTabla.Campo-C[1].
            x-Excepciones = YES.
            LEAVE EXCEPCIONES.
        END.
    END.
    IF NUM-ENTRIES(x-HoraCorte,':') < 3 THEN x-HoraCorte = x-HoraCorte + ':00'.
    IF x-Excepciones = YES THEN DO:
        IF pHoraBase > x-HoraCorte THEN x-Minimo = x-Minimo + 1.
        IF pFchEnt - pFechaBase < x-Minimo THEN pFchEnt = pFechaBase + x-Minimo.
        pFchEnt = pFchEnt - 1.
        REPEAT:
            pFchEnt = pFchEnt + 1.
            /* Si cae domingo salta un día más */
            IF WEEKDAY(pFchEnt) = 1 THEN NEXT.
            /* ************************************************************** */
            /* RHC 16/12/17 CONFIGURADO COMO FERIADO, SALTA AL DIA SIGUIENTE  */
            /* ************************************************************** */
            FIND FacTabla WHERE FacTabla.CodCia = s-codcia
                AND FacTabla.Tabla = 'SZGHRFERIADO'
                AND FacTabla.Codigo = cCodDiv
                NO-LOCK NO-ERROR.
            IF AVAILABLE FacTabla AND FacTabla.Campo-L[WEEKDAY(pFchEnt) - 1] = YES THEN NEXT.
            /* ************************************************************** */
            RETURN.     /* FIN DEL PROCESO */
        END.
    END.
    /* *************************************************************************** */
    /* FIN DE EXCEPCIONES                                                          */
    /* *************************************************************************** */
END.
/* *************************************************************************** */
/* RUTINA NORMAL CUANDO EL ALMACEN DE DESPACHO NO ES UN CENTRO DE DISTRIBUCION */
/* *************************************************************************** */
IF s-CentroDistribucion = NO THEN DO:
    /* La fecha de entrega no debe tener menos de 24h */
    IF pHoraBase > x-HoraCorte THEN x-Minimo = x-Minimo + 1.
    pFchEnt = pFechaBase + x-Minimo.
    /* Si cae domingo salta un día más */
    IF WEEKDAY(pFchEnt) = 1 THEN pFchEnt = pFchEnt + 1.
    RETURN.     /*FIN DEL PROCESO */
END.
/* *************************************************************************** */
/* *************************************************************************** */
/* RUTINA SOLO PARA CENTRO DE DISTRIBUCION */
/* *************************************************************************** */
/* *************************************************************************** */
/* Buscamos día programado para el Centro de Distribución */
/* El parámetro pUbigeo puede ser:
    150103  Departamento, 
    Provincia y Distrito (DDPPdd)
    L03     Código Postal
    CR      Cliente Recoge
    P0      Provincias
    */

RUN CentroDistribucion.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-CentroDistribucion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CentroDistribucion Procedure 
PROCEDURE CentroDistribucion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* RHC 19/12/17 La programación x CANAL es opcional */
DEF VAR x-CanalHR AS LOG INIT YES NO-UNDO.
FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-codcia
    AND VtaTabla.Tabla = s-Llave-CanalDia       /*"CANALHRXDIA"*/
    AND VtaTabla.Llave_c1 = cCodDiv
    AND VtaTabla.Llave_c2 = pDivOri
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla THEN x-CanalHR = NO.  /* NO Hay programacion por CANAL DE VENTA */

/* Obligatorio cronograma de despacho por CD */
FIND FIRST rut-progr-despachos WHERE rut-progr-despachos.CodCia = s-CodCia AND
    rut-progr-despachos.CodDiv = cCodDiv AND
    rut-progr-despachos.CodDoc = cCodDoc AND
    rut-progr-despachos.Cuadrante = pCuadrante
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE rut-progr-despachos THEN DO:
    pError = "NO está configurado el cronograma de despacho: " + CHR(10) + 
        "del ubigeo: " + pUbigeo + CHR(10) +
        "del cuadrante: " + pCuadrante + CHR(10) +
        " en la programación de Despachos".
    RETURN.
END.

/* RHC 08/06/2018 Nueva consistencia */
DEF BUFFER B-TABLA FOR VtaTabla.
DEF BUFFER B-DESPACHOS FOR rut-progr-despachos.
DEF VAR x-Ok AS LOG NO-UNDO.

x-Ok = YES.
IF x-CanalHR = YES THEN DO:
    x-Ok = NO.
    RLOOP:
    FOR EACH VtaTabla NO-LOCK WHERE VtaTabla.CodCia = s-codcia
        AND VtaTabla.Tabla = s-Llave-CanalDia       /*"CANALHRXDIA"*/
        AND VtaTabla.Llave_c1 = cCodDiv
        AND VtaTabla.Llave_c2 = pDivOri:
        /* Cruzamos contra programacion por cuadrante */
        FIND FIRST B-DESPACHOS WHERE B-DESPACHOS.CodCia = s-CodCia AND
            B-DESPACHOS.CodDiv = cCodDiv AND
            B-DESPACHOS.CodDoc = cCodDoc AND
            B-DESPACHOS.Cuadrante = pCuadrante AND
            B-DESPACHOS.Campo-L[INTEGER(VtaTabla.Valor[1])] = YES
            NO-LOCK NO-ERROR.
        IF AVAILABLE B-DESPACHOS THEN DO:
            x-Ok = YES.
            LEAVE RLOOP.
        END.
    END.
END.
IF x-Ok = NO THEN DO:
    pError = "ERROR en el cronograma de despacho " + CHR(10) +
        "Revise los siguientes parámetros: " + CHR(10) +
        "           Ubigeo = " + pUbigeo + CHR(10) +
        "  Llave Canal Dia = " + s-Llave-CanalDia + CHR(10) +
        "Sede Distribución = " + cCodDiv + CHR(10) +
        "   Canal de Venta = " + pDivOri + CHR(10) +
        "        Cuadrante = " + pCuadrante + CHR(10) +
        "POSIBLE PROBLEMA CON LA PROGRAMACION DE DESPACHOS".
    RETURN.
END.
/* ********************************* */
/* AHORA SI DETERMINAMOS LA FECHA DE PARTIDA */
IF pHoraBase > x-HoraCorte THEN x-Minimo = x-Minimo + 1.
IF pFchEnt - pFechaBase < x-Minimo THEN DO:
    IF WEEKDAY(pFechaBase) = 7 AND x-Minimo > 1 THEN x-Minimo = x-Minimo + 1.
    pFchEnt = pFechaBase + x-Minimo.
END.
/* Si es domingo corre un día */
IF WEEKDAY(pFchEnt) = 1 THEN pFchEnt = pFchEnt + 1.     
/* *************************************************************************** */
/* BUSCAMOS DIA DE DESPACHO */
/* *************************************************************************** */
DEF VAR fFchProg AS DATE NO-UNDO.
DEF VAR iNroSKU AS INT NO-UNDO.
DEF VAR iNroPed AS INT NO-UNDO.     /* Número de pedidos despachados del día */
DEF VAR dPeso   AS DEC NO-UNDO.
/* Buscamos si tiene límite de capacidad por SKU's */
FIND FIRST B-TABLA WHERE B-TABLA.codcia = s-codcia 
    AND B-TABLA.Tabla = s-Llave-Capacidad       /*'CDSKU'*/
    AND B-TABLA.Llave_c1 = cCodDiv
    NO-LOCK NO-ERROR.
fFchProg = pFchEnt - 1.     /* OJO: Punto de partida */
/* **************************************************************************************** */
/* BUSCAMOS DIA PROGRAMADO PARA DESPACHO */
/* **************************************************************************************** */
PRINCIPAL:
REPEAT:
    fFchProg = fFchProg + 1.
    /* ************************************************************** */
    IF WEEKDAY(fFchProg) = 1 THEN NEXT.     /* Salta el domingo */
    /* ************************************************************* */
    /* RHC 31/10/17 Si ya ha sido programado entonces toma esa fecha */
    /* ************************************************************* */
    FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.divdes = cCodDiv
        AND LOOKUP(Faccpedi.coddoc, 'O/D,OTR') > 0
        AND LOOKUP(Faccpedi.flgest, "P,C") > 0:
        IF Faccpedi.codcli = pCodCli
            AND Faccpedi.coddoc <> pCodDoc
            AND Faccpedi.nroped <> pNroPed  /* NO el mismo */
            AND Faccpedi.fchent = fFchProg
            THEN LEAVE PRINCIPAL.
    END.
    /* ************************************************************** */
    /* RHC 16/12/17 CONFIGURADO COMO FERIADO, SALTA AL DIA SIGUIENTE  */
    /* ************************************************************** */
    FIND FacTabla WHERE FacTabla.CodCia = s-codcia
        AND FacTabla.Tabla = 'SZGHRFERIADO'
        AND FacTabla.Codigo = cCodDiv
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacTabla AND FacTabla.Campo-L[WEEKDAY(fFchProg) - 1] = YES THEN NEXT.
    /* ************************************************************** */
    /* Día de despacho de acuerdo al Canal de Venta */
    IF x-CanalHR = YES THEN DO:
        FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-codcia
            AND VtaTabla.Tabla = s-Llave-CanalDia       /*"CANALHRXDIA"*/
            AND VtaTabla.Llave_c1 = cCodDiv
            AND VtaTabla.Llave_c2 = pDivOri
            AND VtaTabla.Valor[1] = WEEKDAY(fFchProg)
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE VtaTabla THEN NEXT.
    END.
    /* Día de despacho de acuerdo al cronograma logístico */
    FIND rut-progr-despachos WHERE rut-progr-despachos.CodCia = s-CodCia AND
        rut-progr-despachos.CodDoc = cCodDoc AND
        rut-progr-despachos.CodDiv = cCodDiv AND
        rut-progr-despachos.Cuadrante = pCuadrante AND
        rut-progr-despachos.Campo-L[WEEKDAY(fFchProg)] = YES
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE rut-progr-despachos THEN NEXT.     /* NO tiene programado ese día */
                                                        /* Pasa al siguiente día */
    
    IF NOT AVAILABLE B-TABLA  THEN LEAVE PRINCIPAL.   /* NO tiene minimo de SKU, fecha OK */
    
    /* NO tiene mínimos definidos, fecha OK */
    IF B-TABLA.Valor[1] = 0 
        AND B-TABLA.Valor[2] = 0 
        AND B-TABLA.Valor[3] = 0 
        AND B-TABLA.Valor[4] = 0
        AND B-TABLA.Valor[5] = 0
        THEN LEAVE PRINCIPAL. 
    /* **************************************************************************************** */
    /* VERIFICAMOS LA CAPACIDAD CONFIGURADA PARA EL CD */
    /* **************************************************************************************** */
    ASSIGN
        iNroSKU = 0
        iNroPed = 0
        dPeso   = 0.
    /* POR ORDENES DE DESPACHO CREDITO */
    FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.divdes = cCodDiv
        AND Faccpedi.coddoc = 'O/D'
        AND Faccpedi.fchent = fFchProg
        AND (Faccpedi.flgest = 'P' OR Faccpedi.flgest = 'C'):
        /* Acumulamos */
        /* ************************************************************************** */
        /* RHC 22/01/18 Control de pedidos por FERias (Expolibreria) */
        /* ************************************************************************** */
        FIND FIRST PEDIDO WHERE PEDIDO.codcia = Faccpedi.codcia
            AND PEDIDO.coddiv = Faccpedi.coddiv
            AND PEDIDO.coddoc = Faccpedi.codref
            AND PEDIDO.nroped = Faccpedi.nroref
            NO-LOCK NO-ERROR.
        IF AVAILABLE PEDIDO THEN DO:
            FIND FIRST COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
                AND COTIZACION.coddiv = PEDIDO.coddiv
                AND COTIZACION.coddoc = PEDIDO.codref
                AND COTIZACION.nroped = PEDIDO.nroref
                NO-LOCK NO-ERROR.
            IF AVAILABLE COTIZACION THEN DO:
                FIND B-DIVI WHERE B-DIVI.codcia = s-codcia 
                    AND B-DIVI.coddiv = COTIZACION.Libre_c01      /* Lista de Precios */
                    NO-LOCK NO-ERROR.
                IF AVAILABLE B-DIVI AND B-DIVI.CanalVenta = "FER" THEN iNroPed = iNroPed + 1.
            END.
        END.
        /* ************************************************************************** */
        FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
            iNroSKU = iNroSKU + 1.
            dPeso = dPeso + ((Facdpedi.canped * Facdpedi.factor) * Almmmatg.Pesmat).
        END.
    END.
    /* POR ORDENES DE DESPACHO MOSTRADOR */
    FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.divdes = cCodDiv
        AND Faccpedi.coddoc = 'O/M'
        AND Faccpedi.fchent = fFchProg
        AND Faccpedi.flgest = 'P':
        /* Acumulamos */
        FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
            iNroSKU = iNroSKU + 1.
            dPeso = dPeso + ((Facdpedi.canped * Facdpedi.factor) * Almmmatg.Pesmat).
        END.
    END.
    /* POR ORDENES DE TRANSFERENCIA */
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
    /* RHC 22/01/2018 Control de # de Pedidos Expolibreria */
    IF B-TABLA.Valor[5] > 0 AND pCodDoc = "O/D" THEN DO:
        FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
            AND Faccpedi.coddoc = pCodDoc
            AND Faccpedi.nroped = pNroPed
            NO-LOCK NO-ERROR.
        IF AVAILABLE Faccpedi THEN DO:
            FIND B-DIVI WHERE B-DIVI.codcia = s-codcia 
                AND B-DIVI.coddiv = Faccpedi.Libre_c01      /* Lista de Precios */
                NO-LOCK NO-ERROR.
            IF AVAILABLE B-DIVI AND B-DIVI.CanalVenta = "FER" THEN DO:
                IF iNroPed > B-TABLA.Valor[5] THEN NEXT PRINCIPAL.
            END.
        END.
    END.
    /* INCREMENTAMOS DATOS EXTERNOS en 10% */
    iNroSKU = iNroSKU + pNroSKU.
    dPeso = dPeso + pPeso.
    IF WEEKDAY(fFchProg) >= 2 AND WEEKDAY(fFchProg) <= 6 THEN DO:   /* Lunes a Viernes */
        IF B-TABLA.Valor[1] > 0 AND iNroSKU > B-TABLA.Valor[1] * 1.10 THEN NEXT.
        IF B-TABLA.Valor[3] > 0 AND dPeso > B-TABLA.Valor[3] * 1.10   THEN NEXT.
        LEAVE PRINCIPAL.      /* Fecha OK */
    END.
    ELSE DO:                                                        /* Sábado y Domingo */
        IF B-TABLA.Valor[2] > 0 AND iNroSKU > B-TABLA.Valor[2] * 1.10 THEN NEXT.
        IF B-TABLA.Valor[4] > 0 AND dPeso > B-TABLA.Valor[4] * 1.10   THEN NEXT.
        LEAVE PRINCIPAL.      /* Fecha OK */
    END.
END.
pFchEnt = fFchProg.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

