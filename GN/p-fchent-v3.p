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
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroPed AS CHAR.
DEF INPUT PARAMETER pNroSKU AS INT.
DEF INPUT PARAMETER pPeso   AS DEC.
DEF INPUT-OUTPUT PARAMETER pFchEnt AS DATE.
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

pError = ''.    /* Valor por Defecto */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.


/* RHC 21/05/2018 Se van a definir las llaves para cada pestaña de trabajo */
DEF VAR s-Llave-Capacidad AS CHAR NO-UNDO.
DEF VAR s-Llave-Zona AS CHAR NO-UNDO.
DEF VAR s-Llave-Canal AS CHAR NO-UNDO.
DEF VAR s-Llave-CanalDia AS CHAR NO-UNDO.
CASE pCodDoc:
    WHEN "O/D" OR WHEN "O/M" OR WHEN "PED" THEN DO:
        s-Llave-Capacidad = "CDSKU_OD".
        s-Llave-Zona = "SZGHRXDIA_OD".
        s-Llave-Canal = "CANALHR_OD".
        s-Llave-CanalDia = "CANALHRXDIA_OD".
    END.
    WHEN "OTR" OR WHEN "R/A" THEN DO:
        s-Llave-Capacidad = "CDSKU_OTR".
        s-Llave-Zona = "SZGHRXDIA_OTR".
        s-Llave-Canal = "CANALHR_OTR".
        s-Llave-CanalDia = "CANALHRXDIA_OTR".
    END.
    OTHERWISE DO:
        pError = 'Documento NO contemplado: ' + pCodDoc + ' ???'.
        RETURN.
    END.
END CASE.

/* RHC 22/01/2018 Ajustes a los parámetros en caso de OTR */
FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
    AND Faccpedi.coddoc = pCodDoc
    AND Faccpedi.nroped = pNroPed
    NO-LOCK NO-ERROR.
IF pCodDoc = "OTR" THEN DO:
    IF AVAILABLE Faccpedi THEN DO:
        /* El destino es un almacén */
        FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = Faccpedi.codcli NO-LOCK NO-ERROR.
        IF AVAILABLE Almacen THEN DO:
            FIND B-DIVI WHERE B-DIVI.codcia = s-codcia
                AND B-DIVI.coddiv = Almacen.coddiv
                NO-LOCK NO-ERROR.
            IF AVAILABLE B-DIVI THEN DO:
                pDivOri = B-DIVI.CodDiv.
                pUbigeo = TRIM(B-DIVI.Campo-Char[3]) + TRIM(B-DIVI.Campo-Char[4]) + TRIM(B-DIVI.Campo-Char[5]).
            END.
        END.
    END.
END.

IF pFechaBase = ? AND pCodDoc > '' AND pNroPed > '' THEN DO:
    /* Buscamos el documento Base */
    FIND DOCBASE WHERE DOCBASE.codcia = s-codcia
        AND DOCBASE.coddoc = pCodDoc
        AND DOCBASE.nroped = pNroPed
        NO-LOCK NO-ERROR.
    IF AVAILABLE DOCBASE THEN pFechaBase = DOCBASE.FchPed.
END.
IF pFechaBase = ? THEN pFechaBase = TODAY.
IF pFchEnt = ? THEN pFchEnt = pFechaBase.
IF pFchEnt < pFechaBase THEN pFchEnt = pFechaBase.

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
                 AND gn-divi.Campo-Log[5] = YES NO-LOCK)
    NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN s-CentroDistribucion = YES.
/* *************************************************************************** */
/* REGLA GENERAL: DIAS ANTES DE DESPACHAR */
/* *************************************************************************** */
DEF VAR x-Minimo AS INT INIT 2 NO-UNDO.     /* Mínimo 2 días antes de la hora de corte */
DEF VAR cCodDiv AS CHAR NO-UNDO.            /* División Despachante */

IF WEEKDAY(pFechaBase) = 1 THEN x-Minimo = x-Minimo + 1.
FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = pCodAlm
    NO-LOCK NO-ERROR.
cCodDiv = Almacen.CodDiv.   /* Valor por Defecto */

/* *************************************** */
/* RHC 30/11/2020 MR por embalaje especial */
/* *************************************** */
IF FacCPedi.EmpaqEspec = YES THEN DO:
    FIND VtaTabla WHERE VtaTabla.CodCia = s-CodCia
        AND VtaTabla.Tabla = "CDSKU_OD"
        AND VtaTabla.Llave_c1 = cCodDiv
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaTabla THEN pFchEnt = pFchEnt + VtaTabla.Valor[6].
    
END.
/* *************************************** */
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
IF AVAILABLE VtaTabla THEN DO:
    ASSIGN
        x-Minimo    = VtaTabla.Valor[1] + (IF WEEKDAY(pFechaBase) = 1 THEN 1 ELSE 0)
        x-HoraCorte = VtaTabla.Libre_c01.
    /* Si fuera sábado */
    IF WEEKDAY(pFechaBase) = 7 AND VtaTabla.Libre_c02 > '' 
        THEN ASSIGN x-HoraCorte = VtaTabla.Libre_c02.
    
END.
IF NUM-ENTRIES(x-HoraCorte,':') < 3 THEN x-HoraCorte = x-HoraCorte + ':00'.
IF NUM-ENTRIES(pHoraBase,':')   < 3 THEN pHoraBase   = pHoraBase   + ':00'.

/* ************************************** */
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
                x-Minimo    = FacTabla.Valor[1] + (IF WEEKDAY(pFechaBase) = 1 THEN 1 ELSE 0)
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
                x-Minimo    = FacTabla.Valor[1] + (IF WEEKDAY(pFechaBase) = 1 THEN 1 ELSE 0)
                x-HoraCorte = FacTabla.Campo-C[1].
            x-Excepciones = YES.
            /* Caso de s+abado */
            IF WEEKDAY(pFechaBase) = 7 AND FacTabla.Campo-C[2] > '' THEN x-HoraCorte = FacTabla.Campo-C[2].
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
                x-Minimo    = FacTabla.Valor[1] + (IF WEEKDAY(pFechaBase) = 1 THEN 1 ELSE 0)
                x-HoraCorte = FacTabla.Campo-C[1].
            x-Excepciones = YES.
            LEAVE EXCEPCIONES.
        END.
        
    END.
    IF NUM-ENTRIES(x-HoraCorte,':') < 3 THEN x-HoraCorte = x-HoraCorte + ':00'.
    IF x-Excepciones = YES THEN DO:
        IF pHoraBase > x-HoraCorte THEN x-Minimo = x-Minimo + 1.
        IF (pFchEnt - pFechaBase) < x-Minimo THEN DO:
            /* RHC 31/08/2020 saltar un domingo o feriado */
            pFchEnt = pFechaBase.
            REPEAT:
                RUN Dia-Valido (INPUT-OUTPUT pFchEnt).
                IF (pFchEnt - pFechaBase) >= x-Minimo THEN LEAVE.
                pFchEnt = pFchEnt + 1.
            END.
        END.
        RUN Dia-Valido (INPUT-OUTPUT pFchEnt).
        
        RETURN.     /* FIN DEL PROCESO */
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
    /* Si cae domingo o feriado salta un día más */
    RUN Dia-Valido (INPUT-OUTPUT pFchEnt).
    
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


/* *************************************************************************** */
/* DETERMINAMOS LA ZONA GEOGRAFICA DEL DESPACHO */
/* *************************************************************************** */
DEF VAR cZonaGHR AS CHAR NO-UNDO.
DEF VAR cSubZonaGHR AS CHAR NO-UNDO.


CASE pUbigeo:
    WHEN "P0" THEN ASSIGN cZonaGHR = "02" cSubZonaGHR = "01".     /* LIMA CENTRO (AGENCIAS) */
    WHEN "CR" THEN ASSIGN cZonaGHR = "CR" cSubZonaGHR = "CR".     /* CLIENTE RECOGE - TRAMITE DOCUMENTARIO */
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

/* RHC 19/12/17 La programación x CANAL es opcional */
DEF VAR x-CanalHR AS LOG INIT YES NO-UNDO.
FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-codcia
    AND VtaTabla.Tabla = s-Llave-CanalDia       /*"CANALHRXDIA"*/
    AND VtaTabla.Llave_c1 = cCodDiv
    AND VtaTabla.Llave_c2 = pDivOri
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla THEN x-CanalHR = NO.  /* NO Hay programacion por CANAL DE VENTA */


/* Obligatorio cronograma de despacho por CD */
FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-codcia
    AND VtaTabla.Tabla = s-Llave-Zona       /*"SZGHRXDIA"*/
    AND VtaTabla.Llave_c1 = cCodDiv
    AND VtaTabla.Llave_c2 = cZonaGHR
    AND VtaTabla.Llave_c3 = cSubZonaGHR
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla THEN DO:
    pError = "NO está configurado el cronograma de despacho del ubigeo: " + pUbigeo + CHR(10) +
        " en la programación de Despachos".
    RETURN.
END.
/* RHC 08/06/2018 Nueva consistencia */
DEF BUFFER B-TABLA FOR VtaTabla.
DEF VAR x-Ok AS LOG NO-UNDO.

x-Ok = YES.
IF x-CanalHR = YES THEN DO:
    x-Ok = NO.
    RLOOP:
    FOR EACH VtaTabla NO-LOCK WHERE VtaTabla.CodCia = s-codcia
        AND VtaTabla.Tabla = s-Llave-CanalDia       /*"CANALHRXDIA"*/
        AND VtaTabla.Llave_c1 = cCodDiv
        AND VtaTabla.Llave_c2 = pDivOri:
        FIND FIRST B-TABLA WHERE B-TABLA.codcia = s-codcia
            AND B-TABLA.tabla = s-Llave-Zona
            AND B-TABLA.llave_c1 = cCodDiv
            AND B-TABLA.llave_c2 = cZonaGHR
            AND B-TABLA.llave_c3 = cSubZonaGHR
            AND B-TABLA.valor[1] = VtaTabla.Valor[1]
            NO-LOCK NO-ERROR.
        IF AVAILABLE B-TABLA THEN DO:
            x-Ok = YES.
            LEAVE RLOOP.
        END.
    END.
END.
IF x-Ok = NO THEN DO:
    pError = "ERROR en el cronograma de despacho " + CHR(10) +
        "Revise los siguientes parámetros: " + CHR(10) +
        "     Ubigeo = " + pUbigeo + CHR(10) +
        "Llave Canal = " + s-Llave-CanalDia + CHR(10) + 
        " Llave Zona = " + s-Llave-Zona + CHR(10) +
        "   División = " + cCodDiv + CHR(10) + 
        "    Destino = " + pDivOri + CHR(10) +
        "       Zona = " + cZonaGHR + CHR(10) +
        "    SubZona = " + cSubZonaGHR + CHR(10) +
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
/* Si es domingo o feriado corre un día */
RUN Dia-Valido (INPUT-OUTPUT pFchEnt).

/* *************************************************************************** */
/* BUSCAMOS DIA DE DESPACHO */
/* *************************************************************************** */
DEF VAR fFchProg AS DATE NO-UNDO.
DEF VAR iNroSKU AS INT NO-UNDO.
DEF VAR iNroPed AS INT NO-UNDO.     /* Número de pedidos despachados del día */
DEF VAR dPeso   AS DEC NO-UNDO.

FIND FIRST B-TABLA WHERE B-TABLA.codcia = s-codcia 
    AND B-TABLA.Tabla = s-Llave-Capacidad       /*'CDSKU'*/
    AND B-TABLA.Llave_c1 = cCodDiv
    NO-LOCK NO-ERROR.
fFchProg = pFchEnt - 1.     /* OJO: Punto de partida */
/* **************************************************************************************** */
/* BUSCAMOS DIA PROGRAMADO PARA DESPACHO */
/* **************************************************************************************** */
DEF VAR x-Loop-Feriados AS CHAR NO-UNDO.
DEF VAR x-Dia-Feriado AS CHAR NO-UNDO.

/* CONTROL DE VUELTAS */
DEF VAR LocalLoops AS INT NO-UNDO.
LocalLoops = 0.
PRINCIPAL:
REPEAT:
    LocalLoops = LocalLoops + 1.
    IF LocalLoops > 30 THEN DO:
        /* No puede ser mas de 30 días */
        pError = "No se ha podido programar dentro de los 30 días siguientes" + CHR(10) +
            "Revise sus parámetros de configuración de FECHA DE DESPACHO".
        RETURN.
    END.
    fFchProg = fFchProg + 1.
    /* ************************************************************** */
    IF WEEKDAY(fFchProg) = 1 THEN NEXT.     /* Salta el domingo */
    /* ************************************************************** */
    /* RHC 16/12/17 CONFIGURADO COMO FERIADO, SALTA AL DIA SIGUIENTE  */
    /* ************************************************************** */
    FIND FacTabla WHERE FacTabla.CodCia = s-codcia
        AND FacTabla.Tabla = 'SZGHRFERIADO'
        AND FacTabla.Codigo = cCodDiv
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacTabla AND FacTabla.Campo-L[WEEKDAY(fFchProg) - 1] = YES THEN DO:
        x-Dia-Feriado = TRIM(STRING(WEEKDAY(fFchProg) - 1)).
        IF TRUE <> (x-Loop-Feriados > '') THEN DO:
            x-Loop-Feriados = x-Dia-Feriado.
            NEXT.
        END.
        ELSE DO:
            /* Solo debe pasar una vez por el control */
            IF LOOKUP(x-Dia-Feriado, x-Loop-Feriados) = 0 THEN DO:
                x-Loop-Feriados = x-Loop-Feriados + ',' + x-Dia-Feriado.
                NEXT.
            END.
       END.
    END.
    /* ************************************************************* */
    /* RHC 31/10/17 Si ya ha sido programado entonces toma esa fecha */
    /* ************************************************************* */
    FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.divdes = cCodDiv
        AND Faccpedi.coddoc = 'O/D'
        AND LOOKUP(Faccpedi.flgest, "P,C") > 0:
        IF Faccpedi.codcli = pCodCli
            AND Faccpedi.coddoc <> pCodDoc
            AND Faccpedi.nroped <> pNroPed  /* NO el mismo */
            AND Faccpedi.fchent = fFchProg
            THEN DO:
            LEAVE PRINCIPAL.
        END.
    END.
    FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.divdes = cCodDiv
        AND Faccpedi.coddoc = 'OTR'
        AND LOOKUP(Faccpedi.flgest, "P,C") > 0:
        IF Faccpedi.codcli = pCodCli
            AND Faccpedi.coddoc <> pCodDoc
            AND Faccpedi.nroped <> pNroPed  /* NO el mismo */
            AND Faccpedi.fchent = fFchProg
            THEN LEAVE PRINCIPAL.
    END.
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
    FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-codcia
        AND VtaTabla.Tabla = s-Llave-Zona       /*"SZGHRXDIA"*/
        AND VtaTabla.Llave_c1 = cCodDiv
        AND VtaTabla.Llave_c2 = cZonaGHR
        AND VtaTabla.Llave_c3 = cSubZonaGHR
        AND VtaTabla.Valor[1] = WEEKDAY(fFchProg)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaTabla THEN NEXT.    /* NO tiene programado ese día */
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
        AND (Faccpedi.flgest = 'P' OR Faccpedi.flgest = 'C') :
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
        /* RHC 17/10/2019 Suponiendo que el peso está correcto en la cabecera */
        dPeso = Faccpedi.Libre_d02.
/*         FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:   */
/*             iNroSKU = iNroSKU + 1.                                                   */
/*             dPeso = dPeso + ((Facdpedi.canped * Facdpedi.factor) * Almmmatg.Pesmat). */
/*         END.                                                                         */
    END.
    /* POR ORDENES DE DESPACHO MOSTRADOR */
    FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.divdes = cCodDiv
        AND Faccpedi.coddoc = 'O/M'
        AND Faccpedi.fchent = fFchProg
        AND Faccpedi.flgest = 'P':
        /* Acumulamos */
        /* RHC 17/10/2019 Suponiendo que el peso está correcto en la cabecera */
        dPeso = Faccpedi.Libre_d02.
/*         FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:   */
/*             iNroSKU = iNroSKU + 1.                                                   */
/*             dPeso = dPeso + ((Facdpedi.canped * Facdpedi.factor) * Almmmatg.Pesmat). */
/*         END.                                                                         */
    END.
    /* POR ORDENES DE TRANSFERENCIA */
    FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.divdes = cCodDiv
        AND Faccpedi.coddoc = 'OTR'
        AND Faccpedi.fchent = fFchProg
        AND Faccpedi.flgest = 'P':
        /* Acumulamos */
        /* RHC 17/10/2019 Suponiendo que el peso está correcto en la cabecera */
        dPeso = Faccpedi.Libre_d02.
/*         FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:   */
/*             iNroSKU = iNroSKU + 1.                                                   */
/*             dPeso = dPeso + ((Facdpedi.canped * Facdpedi.factor) * Almmmatg.Pesmat). */
/*         END.                                                                         */
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
                IF iNroPed > B-TABLA.Valor[5] THEN DO:
                    NEXT PRINCIPAL.
                END.
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

&IF DEFINED(EXCLUDE-Dia-Valido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Dia-Valido Procedure 
PROCEDURE Dia-Valido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT-OUTPUT PARAMETER pFchEnt AS DATE.

pFchEnt = pFchEnt - 1.
RLOOP:
REPEAT:
    pFchEnt = pFchEnt + 1.
    IF WEEKDAY(pFchEnt) = 1 THEN NEXT.
    /* ************************************************************** */
    /* RHC 16/12/17 CONFIGURADO COMO FERIADO, SALTA AL DIA SIGUIENTE  */
    /* ************************************************************** */
    FIND FacTabla WHERE FacTabla.CodCia = s-codcia
        AND FacTabla.Tabla = 'SZGHRFERIADO'
        AND FacTabla.Codigo = cCodDiv
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacTabla AND FacTabla.Campo-L[WEEKDAY(pFchEnt) - 1] = YES THEN NEXT.
    LEAVE RLOOP.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

