&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-TABLA FOR VtaDTabla.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE TEMP-TABLE Promocion LIKE VtaDTabla.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : PROGRAMA GENERAL DE PROMOCIONES Y OFERTAS ESPECIALES 

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* NOTAS:
- Siempre se va a cargar a la tabla BONIFICACION
- Si es COT va TODO sin preguntar, es solo una proyección

***************************************************************************** */

/* ***************************  Definitions  ************************** */
DEF TEMP-TABLE ITEM LIKE Facdpedi.
DEF TEMP-TABLE BONIFICACION LIKE Facdpedi.
DEF TEMP-TABLE DETALLE LIKE Facdpedi.
DEF TEMP-TABLE DETALLE-2 LIKE Facdpedi.
DEF TEMP-TABLE DETALLE-3 LIKE Facdpedi.

/* Todo parte del Pedido Mostrador, del Pedido al Crédito o de Pedido UTILEX */
/* RHC 29/12/2015 En caso de COTizaciones: NO se va a seleccionar, SOLO es para impresiones 
    ADEMAS se recibe la DIVISION como parámetro
*/

/* Necesitamos la tabla donde se ha registrado los productos a vender */
DEF INPUT PARAMETER s-CodDiv AS CHAR.       /* División */
DEF INPUT PARAMETER s-CodDoc AS CHAR.
DEF INPUT PARAMETER s-NroPed AS CHAR.
DEF INPUT PARAMETER TABLE FOR ITEM.
DEF OUTPUT PARAMETER TABLE FOR BONIFICACION.
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

/* ****************************************************** */
/* Artificio para poder jalar TODOS los items BONIFICADOS */
/* ****************************************************** */
DEF VAR x-SoloReporte AS LOG INIT NO NO-UNDO.
IF INDEX(s-CodDoc, '*') > 0 THEN DO:
    s-CodDoc = REPLACE(s-CodDoc, '*', '').
    x-SoloReporte = YES.
END.
/* ****************************************************** */
/* ****************************************************** */
/* Artificio para poder calcular las BONIFICACIONES */
/* ****************************************************** */
DEF VAR x-SoloBonificaciones AS LOG INIT NO NO-UNDO.
IF INDEX(s-CodDoc, '&') > 0 THEN DO:
    s-CodDoc = 'COT'.
    x-SoloBonificaciones = YES.
END.
/* ****************************************************** */

DEF SHARED VAR s-codcia AS INT.          
DEF SHARED VAR cl-codcia AS INT.

DEF VAR s-codcli AS CHAR.              
DEF VAR s-nrodec AS INT.               
DEF VAR s-PorIgv LIKE Ccbcdocu.PorIgv. 
DEF VAR s-Cmpbnte AS CHAR.

/* Limpiamos cualquier promoción */    
EMPTY TEMP-TABLE BONIFICACION.
/* ***************************** */
DEF VAR pCodDiv  AS CHAR NO-UNDO.   /* Lista de Precios */

/* VERIFICACION DE PARAMETROS DE ENTRADA */
IF x-SoloBonificaciones = NO THEN DO:
    FIND Faccpedi WHERE Faccpedi.codcia = s-CodCia AND
        Faccpedi.coddiv = s-CodDiv AND
        Faccpedi.coddoc = s-CodDoc AND
        Faccpedi.nroped = s-NroPed NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccpedi THEN RETURN 'OK'.
    IF LOOKUP(Faccpedi.CodDoc, 'PED,P/M,COT') = 0 THEN RETURN "OK". 
    IF LOOKUP(Faccpedi.FmaPgo, '900,999,899') > 0 THEN RETURN "OK".                          
    ASSIGN
        s-Cmpbnte = Faccpedi.Cmpbnte
        s-CodCli = Faccpedi.CodCli
        s-NroDec = Faccpedi.Libre_d01
        s-PorIgv = Faccpedi.PorIgv
        pCodDiv = s-CodDiv.
    IF LOOKUP(Faccpedi.CodDoc, 'PED,P/M') > 0 THEN DO:
        FIND COTIZACION WHERE COTIZACION.codcia = Faccpedi.codcia AND
            COTIZACION.coddiv = Faccpedi.coddiv AND
            COTIZACION.coddoc = Faccpedi.codref AND
            COTIZACION.nroped = Faccpedi.nroref NO-LOCK NO-ERROR.
        IF AVAILABLE COTIZACION THEN DO:
            pCodDiv = COTIZACION.Lista_de_Precios.
            IF TRUE <> (pCodDiv > '') THEN pCodDiv = COTIZACION.Libre_c01.
            IF TRUE <> (pCodDiv > '') THEN pCodDiv = COTIZACION.CodDiv.
        END.
    END.
    IF LOOKUP(Faccpedi.CodDoc, 'COT') > 0 THEN DO:
        pCodDiv = Faccpedi.Lista_de_Precios.
        IF TRUE <> (pCodDiv > '') THEN pCodDiv = FacCPedi.Libre_c01.
        IF TRUE <> (pCodDiv > '') THEN pCodDiv = FacCPedi.CodDiv.
    END.
END.
ELSE DO:
    pCodDiv = s-CodDiv.     /* OJO >>> Lista de Precios */
END.

DEF BUFFER B-DTABLA FOR Vtadtabla.
DEF BUFFER B-DTABLA2 FOR Vtadtabla.
DEF BUFFER B-DTABLA3 FOR Vtadtabla.

/* VARIABLES PARA EL CONTROL DE CADA PROMOCION */
DEF VAR x-Importes-01 AS DEC INIT 0 NO-UNDO.
DEF VAR x-Cantidades-01 AS DEC INIT 0 NO-UNDO.
DEF VAR x-Importes-02 AS DEC INIT 0 NO-UNDO.
DEF VAR x-Cantidades-02 AS DEC INIT 0 NO-UNDO.
DEF VAR x-Importes-03 AS DEC INIT 0 NO-UNDO.
DEF VAR x-Cantidades-03 AS DEC INIT 0 NO-UNDO.
DEF VAR x-ImpLin AS DEC NO-UNDO.
DEF VAR x-CanDes AS DEC NO-UNDO.
DEF VAR x-Cantidad AS DEC NO-UNDO.
DEF VAR x-Control-01 AS LOG INIT NO NO-UNDO.
DEF VAR x-Control-02 AS LOG INIT NO NO-UNDO.
DEF VAR x-Control-03 AS LOG INIT NO NO-UNDO.
DEF VAR pExcepcion AS LOG.
DEF VAR x-AcumulaImportes AS DEC NO-UNDO.
DEF VAR x-AcumulaCantidades AS DEC NO-UNDO.

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
      TABLE: B-TABLA B "?" ? INTEGRAL VtaDTabla
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: Promocion T "?" ? INTEGRAL VtaDTabla
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 7.04
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* NOTA:
    Se va a cargar el temporal Promocion
    Vtadtabla.Libre_d04: A llevar
    Vtadtabla.Libre_d05: Nuevo tope
*/
    
/* Limpiamos cualquier promoción */    
EMPTY TEMP-TABLE BONIFICACION.

FOR EACH ITEM WHERE ITEM.Libre_c05 = "OF":
    DELETE ITEM.
END.
FOR EACH ITEM:
    ASSIGN
        ITEM.Libre_D02 = 0
        ITEM.Libre_C02 = "".    /* Control de productos afectos a promoción */
END.

/* RHC 01/04/2016 Usuario SYS solo para hacer pruebas */
FOR EACH Vtactabla NO-LOCK WHERE Vtactabla.codcia = s-codcia
    AND VtaCTabla.Tabla = "PROM"
    AND VtaCTabla.Estado = "A"      /* Activa */
    AND (s-CodCli BEGINS 'SYS' OR (TODAY >= VtaCTabla.FechaInicial AND TODAY <= VtaCTabla.FechaFinal))
    AND LOOKUP(Vtactabla.Libre_c01, 'Unidades,Soles') > 0
    AND VtaCTabla.Libre_d01 > 0
    AND CAN-FIND(FIRST Vtadtabla OF Vtactabla WHERE Vtadtabla.tipo = "D"    /* División */
                 AND VtaDTabla.LlaveDetalle = pCodDiv 
                 AND ((s-CodDoc = "P/M" AND VtaDTabla.Libre_l01 = YES)
                      OR (LOOKUP(s-CodDoc, "PED,COT") > 0 AND VtaDTabla.Libre_l02 = YES))
                 NO-LOCK):
    /* Trabajamos con esta promoción */
    EMPTY TEMP-TABLE Promocion.

    RUN Carga-Promocion.

    RUN Graba-Promocion.
    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
END.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Carga-con-filtros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-con-filtros Procedure 
PROCEDURE Carga-con-filtros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-ImpLin AS DEC NO-UNDO.
DEF VAR x-CanDes AS DEC NO-UNDO.
DEF VAR x-Cantidad AS DEC NO-UNDO.
DEF VAR pExcepcion AS LOG.

ASSIGN
    x-Control-01 = NO
    x-Control-02 = NO
    x-Control-03 = NO
    x-Importes-01 = 0
    x-Cantidades-01 = 0
    x-Importes-02 = 0
    x-Cantidades-02 = 0
    x-Importes-03 = 0
    x-Cantidades-03 = 0
    x-AcumulaImportes = 0
    x-AcumulaCantidades = 0.

/* 1ro Buscamos los productos que son promocionables */
EMPTY TEMP-TABLE DETALLE.
EMPTY TEMP-TABLE DETALLE-2.
EMPTY TEMP-TABLE DETALLE-3.

FOR EACH ITEM NO-LOCK WHERE ITEM.Libre_c05 <> "OF":
    CREATE DETALLE.
    BUFFER-COPY ITEM TO DETALLE.
END.

/* **************************************************************************************************** */
/* Por artículos */
/* **************************************************************************************************** */
rloop:
FOR EACH Vtadtabla OF Vtactabla NO-LOCK WHERE Vtadtabla.Tipo = "M":
    FIND FIRST DETALLE WHERE DETALLE.codmat = Vtadtabla.LlaveDetalle NO-LOCK NO-ERROR.
    /* Verificamos el "Operador" */
    CASE TRUE:
        WHEN Vtactabla.Libre_c02 = "OR" THEN DO:    /* Por la compra de cualquiera de los productos */
            IF NOT AVAILABLE DETALLE THEN NEXT rloop.
            /* Verificamos si tiene mínimo */
            IF Vtadtabla.Libre_d01 > 0 THEN DO:      /* Debe comprar como mínimo */
                IF Vtadtabla.Libre_c01 = "Importe" THEN IF Vtadtabla.Libre_d01 > DETALLE.ImpLin THEN NEXT rloop.
                IF Vtadtabla.Libre_c01 = "Cantidad" THEN IF Vtadtabla.Libre_d01 > (DETALLE.CanPed * DETALLE.Factor) THEN NEXT rloop.
            END.
            ASSIGN
                x-Control-01 = YES
                x-Importes-01 = x-Importes-01 + DETALLE.ImpLin
                x-Cantidades-01 = x-Cantidades-01 + (DETALLE.CanPed * DETALLE.Factor).
            DELETE DETALLE.
        END.
        WHEN Vtactabla.Libre_c02 = "AND" THEN DO:    /* Debe comprar todos los productos */
            /* Debe comprarlo */
            IF NOT AVAILABLE DETALLE THEN DO:
                x-Control-01 = NO.
                x-Importes-01 = 0.
                x-Cantidades-01 = 0.
                LEAVE rloop.
            END.
            /* Verificamos si tiene mínimo */
            IF Vtadtabla.Libre_d01 > 0 THEN DO:      /* Debe comprar como mínimo */
                IF Vtadtabla.Libre_c01 = "Importe" THEN IF Vtadtabla.Libre_d01 > DETALLE.ImpLin THEN DO:
                    x-Control-01 = NO.
                    x-Importes-01 = 0.
                    x-Cantidades-01 = 0.
                    LEAVE rloop.
                END.
                IF Vtadtabla.Libre_c01 = "Cantidad" THEN IF Vtadtabla.Libre_d01 > (DETALLE.CanPed * DETALLE.Factor) THEN DO:
                    x-Control-01 = NO.
                    x-Importes-01 = 0.
                    x-Cantidades-01 = 0.
                    LEAVE rloop.
                END.
            END.
            ASSIGN
                x-Control-01 = YES
                x-Importes-01 = x-Importes-01 + DETALLE.ImpLin
                x-Cantidades-01 = x-Cantidades-01 + (DETALLE.CanPed * DETALLE.Factor).
            DELETE DETALLE.
        END.
    END CASE.
END.
IF x-Control-01 = NO THEN DO:
    EMPTY TEMP-TABLE DETALLE.
    FOR EACH ITEM NO-LOCK WHERE ITEM.Libre_c05 <> "OF":
        CREATE DETALLE.
        BUFFER-COPY ITEM TO DETALLE.
    END.
END.
/* Llevamos el saldo */
FOR EACH DETALLE:
    CREATE DETALLE-2.
    BUFFER-COPY DETALLE TO DETALLE-2.
END.
/* **************************************************************************************************** */
/* Por proveedor */
/* **************************************************************************************************** */
rloop:
FOR EACH Vtadtabla OF Vtactabla NO-LOCK WHERE Vtadtabla.Tipo = "P":
    /* Acumulamos por Proveedor */
    x-ImpLin = 0.
    x-CanDes = 0.
    FOR EACH DETALLE NO-LOCK, FIRST Almmmatg OF DETALLE NO-LOCK WHERE Almmmatg.codpr1 = Vtadtabla.LlaveDetalle:
        /* Buscamos si es una excepción */
        RUN Excepcion-Linea (OUTPUT pExcepcion).
        IF pExcepcion = YES THEN NEXT.
        /* Fin de excepciones */
        x-ImpLin = x-ImpLin + DETALLE.ImpLin.
        x-CanDes = x-CanDes + (DETALLE.CanPed * DETALLE.Factor).
        DELETE DETALLE.
    END.
    /* Buscamos si existe al menos un registro válido */
    FIND FIRST DETALLE-2 NO-LOCK WHERE CAN-FIND(FIRST Almmmatg OF DETALLE-2 WHERE Almmmatg.codpr1 = Vtadtabla.LlaveDetalle NO-LOCK)
        NO-ERROR.
    /* Verificamos el "Operador" */
    CASE TRUE:
        WHEN Vtactabla.Libre_c03 = "OR" THEN DO:    /* Por la compra de cualquier de los productos */
            /* Verificamos si tiene mínimo */
            IF Vtadtabla.Libre_d01 > 0 AND Vtadtabla.Libre_d01 > x-ImpLin THEN NEXT rloop.
            ASSIGN
                x-Control-02 = YES
                x-Importes-02 = x-Importes-02 + x-ImpLin
                x-Cantidades-02 = x-Cantidades-02 + x-CanDes.
        END.
        WHEN Vtactabla.Libre_c03 = "AND" THEN DO:    /* Debe comprar todos los productos */
            /* Debe comprarlo */
            IF NOT AVAILABLE DETALLE-2 THEN DO:
                x-Control-02 = NO.
                x-Importes-02 = 0.
                x-Cantidades-02 = 0.
                LEAVE rloop.
            END.
            /* Verificamos si tiene mínimo */
            IF Vtadtabla.Libre_d01 > 0 AND Vtadtabla.Libre_d01 > x-ImpLin THEN DO:
                x-Control-02 = NO.
                x-Importes-02 = 0.
                x-Cantidades-02 = 0.
                LEAVE rloop.
            END.
            ASSIGN
                x-Control-02 = YES
                x-Importes-02 = x-Importes-02 + x-ImpLin
                x-Cantidades-02 = x-Cantidades-02 + x-CanDes.
        END.
    END CASE.
END.
IF x-Control-02 = NO THEN DO:
    FOR EACH DETALLE-2:
        FIND FIRST DETALLE WHERE DETALLE.CodMat = DETALLE-2.CodMat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE DETALLE THEN DO:
            CREATE DETALLE.
            BUFFER-COPY DETALLE-2 TO DETALLE.
        END.
    END.
END.
/* **************************************************************************************************** */
/* Llevamos el saldo */
/* **************************************************************************************************** */
FOR EACH DETALLE:
    CREATE DETALLE-3.
    BUFFER-COPY DETALLE TO DETALLE-3.
END.
/* **************************************************************************************************** */
/* Por Líneas */
/* **************************************************************************************************** */
rloop:
FOR EACH Vtadtabla OF Vtactabla NO-LOCK WHERE Vtadtabla.Tipo = "L":
    /* Acumulamos por Línea y/o Sublinea */
    x-ImpLin = 0.
    x-Cantidad = 0.
    FOR EACH DETALLE NO-LOCK, FIRST Almmmatg OF DETALLE NO-LOCK WHERE Almmmatg.codfam = Vtadtabla.LlaveDetalle 
        AND (Vtadtabla.Libre_c01 = "" OR Almmmatg.subfam = Vtadtabla.Libre_c01):
        /* Buscamos si es una excepción */
        RUN Excepcion-Linea (OUTPUT pExcepcion).
        IF pExcepcion = YES THEN NEXT.
        /* Fin de excepciones */
        x-ImpLin = x-ImpLin + DETALLE.ImpLin.
        x-Cantidad = x-Cantidad + (DETALLE.CanPed * DETALLE.Factor).
        DELETE DETALLE.
    END.

    /* Buscamos si existe al menos un registro válido */
    FIND FIRST DETALLE-3 NO-LOCK WHERE CAN-FIND(FIRST Almmmatg OF DETALLE-3 WHERE Almmmatg.codfam = Vtadtabla.LlaveDetalle
        AND (Vtadtabla.Libre_c01 = "" OR Almmmatg.subfam = Vtadtabla.Libre_c01) NO-LOCK)
        NO-ERROR.
    /* Verificamos el "Operador" */
    CASE TRUE:
        WHEN Vtactabla.Libre_c05 = "OR" THEN DO:    /* Por la compra de cualquier de los productos */
            /* Verificamos si tiene mínimo */
            IF Vtadtabla.Libre_d01 > 0 THEN DO:      /* Debe comprar como mínimo */
                IF Vtadtabla.Libre_c02 = "Importe" THEN IF Vtadtabla.Libre_d01 > x-ImpLin THEN NEXT rloop.
                IF Vtadtabla.Libre_c02 = "Cantidad" THEN IF Vtadtabla.Libre_d01 > x-Cantidad THEN NEXT rloop.
            END.
            ASSIGN
                x-Control-03 = YES
                x-Importes-03 = x-Importes-03 + x-ImpLin 
                x-Cantidades-03 = x-Cantidades-03 + x-Cantidad.
        END.
        WHEN Vtactabla.Libre_c05 = "AND" THEN DO:    /* Debe comprar todos los productos */
            /* Debe comprarlo */
            IF NOT AVAILABLE DETALLE-3 THEN DO:
                x-Control-03 = NO.
                x-Importes-03 = 0.
                x-Cantidades-03 = 0.
                LEAVE rloop.
            END.
            /* Verificamos si tiene mínimo */
            IF Vtadtabla.Libre_d01 > 0 THEN DO:      /* Debe comprar como mínimo */
                IF Vtadtabla.Libre_c02 = "Importe" THEN IF Vtadtabla.Libre_d01 > x-ImpLin THEN DO:
                    x-Control-03 = NO.
                    x-Importes-03 = 0.
                    x-Cantidades-03 = 0.
                    LEAVE rloop.
                END.
                IF Vtadtabla.Libre_c02 = "Cantidad" THEN IF Vtadtabla.Libre_d01 > x-Cantidad THEN DO:
                    x-Control-03 = NO.
                    x-Importes-03 = 0.
                    x-Cantidades-03 = 0.
                    LEAVE rloop.
                END.
            END.
            ASSIGN
                x-Control-03 = YES
                x-Importes-03 = x-Importes-03 + x-ImpLin
                x-Cantidades-03 = x-Cantidades-03 + x-Cantidad.
        END.
    END CASE.
END.
IF x-Control-03 = NO THEN DO:
    FOR EACH DETALLE-3:
        FIND FIRST DETALLE WHERE DETALLE.CodMat = DETALLE-3.CodMat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE DETALLE THEN DO:
            CREATE DETALLE.
            BUFFER-COPY DETALLE-3 TO DETALLE.
        END.
    END.
END.
/* **************************************************************************************************** */
/* 3do Buscamos las promociones */
/* **************************************************************************************************** */
ASSIGN
    x-AcumulaImportes = x-Importes-01 + x-Importes-02 + x-Importes-03
    x-AcumulaCantidades = x-Cantidades-01 + x-Cantidades-02 + x-Cantidades-03.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Carga-Promocion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Promocion Procedure 
PROCEDURE Carga-Promocion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Verificamos los parámetros de compra */
IF LOOKUP(Vtactabla.Libre_c01, 'Unidades,Soles') = 0 THEN RETURN.
IF Vtactabla.Libre_d01 <= 0 THEN RETURN.

/* Verificamos que tenga al menos un producto promocional registrado */
FIND FIRST B-DTABLA OF Vtactabla WHERE B-DTABLA.Tipo = "OF" NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-DTABLA THEN RETURN.

/* 1ro. La promoción mas simple es la que solo tiene definido los productos promocionales */
FIND FIRST B-DTABLA OF Vtactabla WHERE B-DTABLA.Tipo = "M" NO-LOCK NO-ERROR.    /* Por articulo */
FIND FIRST B-DTABLA2 OF Vtactabla WHERE B-DTABLA2.Tipo = "P" NO-LOCK NO-ERROR.  /* Por proveedor */
FIND FIRST B-DTABLA3 OF Vtactabla WHERE B-DTABLA3.Tipo = "L" NO-LOCK NO-ERROR.  /* Por Linea */

IF NOT AVAILABLE B-DTABLA AND NOT AVAILABLE B-DTABLA2 AND NOT AVAILABLE B-DTABLA3
    THEN RUN Carga-sin-filtros.
ELSE RUN Carga-con-filtros.     /* La promoción es mas compleja */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Carga-sin-filtros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-sin-filtros Procedure 
PROCEDURE Carga-sin-filtros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-AcumulaImportes AS DEC NO-UNDO.
DEF VAR x-AcumulaCantidades AS DEC NO-UNDO.
DEF VAR pExcepcion AS LOG.

/* **************************************************************************************************** */
/* Acumulamos Importes y Cantidades */
/* **************************************************************************************************** */
EMPTY TEMP-TABLE DETALLE.
FOR EACH ITEM NO-LOCK WHERE ITEM.Libre_c05 <> "OF", FIRST Almmmatg OF ITEM NO-LOCK:
    /* Buscamos si es una excepción */
    RUN Excepcion-Linea (OUTPUT pExcepcion).
    IF pExcepcion = YES THEN NEXT.
    /* Fin de excepciones */
    x-AcumulaImportes = x-AcumulaImportes + ITEM.ImpLin.
    x-AcumulaCantidades = x-AcumulaCantidades + (ITEM.CanPed * ITEM.Factor).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Excepcion-Linea) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excepcion-Linea Procedure 
PROCEDURE Excepcion-Linea :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pExcepcion AS LOG.

pExcepcion = NO.

/* Por Linea y/o Sublinea */
FIND B-TABLA OF Vtactabla WHERE B-TABLA.LlaveDetalle = Almmmatg.codfam
    AND B-TABLA.Libre_c01 = Almmmatg.subfam
    AND B-TABLA.Tipo = "XL"
    NO-LOCK NO-ERROR.
IF AVAILABLE B-TABLA THEN pExcepcion = YES.
FIND B-TABLA OF Vtactabla WHERE B-TABLA.LlaveDetalle = Almmmatg.codfam
    AND B-TABLA.Libre_c01 = ""
    AND B-TABLA.Tipo = "XL"
    NO-LOCK NO-ERROR.
IF AVAILABLE B-TABLA THEN pExcepcion = YES.
/* Por Producto */
FIND B-TABLA OF Vtactabla WHERE B-TABLA.LlaveDetalle = Almmmatg.codmat
    AND B-TABLA.Tipo = "XM"
    NO-LOCK NO-ERROR.
IF AVAILABLE B-TABLA THEN pExcepcion = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Graba-Promocion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Promocion Procedure 
PROCEDURE Graba-Promocion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR i-nItem AS INT NO-UNDO.
DEF VAR x-StkAct AS DEC NO-UNDO.
DEF VAR s-StkComprometido AS DEC NO-UNDO.
DEF VAR s-StkDis AS DEC NO-UNDO.
DEF VAR s-UndVta AS CHAR.
DEF VAR f-Factor AS DEC.

DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE X-TIPDTO AS CHAR NO-UNDO.
DEFINE VARIABLE f-FleteUnitario AS DEC NO-UNDO.

/* **************************************************************************************************** */
/* ******************* PRIMER PASO: CARGAMOS LA TABLA TEMPORAL DE PROMOCIONES ********************* */
/* **************************************************************************************************** */
IF VtaCTabla.Libre_d01 > 0 THEN DO:
    IF Vtactabla.Libre_c01 = "Soles" AND x-AcumulaImportes < VtaCTabla.Libre_d01 THEN RETURN "OK".
    IF Vtactabla.Libre_c01 = "Unidades" AND x-AcumulaCantidades < VtaCTabla.Libre_d01 THEN RETURN "OK".
END.
/* **************************************************************************************************** */
/* **************************************************************************************************** */
/* Ordenamos por Mínimo S/. descendente */
FOR EACH Vtadtabla OF Vtactabla NO-LOCK WHERE Vtadtabla.Tipo = "OF" BY Vtadtabla.Libre_d04 DESC:
    /* Si se requiere un mínimo de compra */
    IF Vtadtabla.Libre_d04 > 0 AND Vtadtabla.Libre_d04 > x-AcumulaImportes THEN NEXT.
    /* *********************************** */
    CREATE Promocion.
    BUFFER-COPY Vtadtabla EXCEPT Vtadtabla.Libre_d04 Vtadtabla.Libre_d05 TO Promocion.
    IF VtaCTabla.Libre_d01 > 0 THEN DO:
        IF Vtactabla.Libre_c01 = "Soles" THEN 
            Promocion.Libre_d05 = TRUNCATE(x-AcumulaImportes / VtaCTabla.Libre_d01, 0) * Vtadtabla.Libre_d01.
        IF Vtactabla.Libre_c01 = "Unidades" THEN 
            Promocion.Libre_d05 = TRUNCATE(x-AcumulaCantidades / VtaCTabla.Libre_d01, 0) * Vtadtabla.Libre_d01.
        /* Tope de cada promoción */
        IF Promocion.Libre_d02 > 0 THEN Promocion.Libre_d05 = MINIMUM(Promocion.Libre_d05,Promocion.Libre_d02).
    END.
    ELSE DO:
        IF Vtactabla.Libre_c01 = "Soles" THEN Promocion.Libre_d05 = Vtadtabla.Libre_d01.
        IF Vtactabla.Libre_c01 = "Unidades" THEN Promocion.Libre_d05 = Vtadtabla.Libre_d01.
    END.
END.
/* **************************************************************************************************** */
/* ******************* SEGUNDO PASO: SOLICITAMOS LOS PRODUCTOS PROMOCIONALES  ********************* */
/* **************************************************************************************************** */
/* Limpiamos promociones */
i-nItem = 0.
FOR EACH ITEM NO-LOCK:
    i-nItem = i-nItem + 1.
END.
FOR EACH Promocion:
    Promocion.Libre_d04 = Promocion.Libre_d05.  /* Se regala todo */
END.
IF x-SoloReporte = YES THEN DO:
    FOR EACH Promocion NO-LOCK WHERE Promocion.Libre_d04 > 0,
        FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = Promocion.codcia
        AND Almmmatg.codmat = Promocion.LlaveDetalle:
        /* GRABAMOS EL REGISTRO */
        FIND FIRST BONIFICACION WHERE BONIFICACION.codmat = Almmmatg.codmat NO-ERROR.
        IF NOT AVAILABLE BONIFICACION THEN DO:
            I-NITEM = I-NITEM + 1.
            CREATE BONIFICACION.
        END.
        ASSIGN
            BONIFICACION.CodCia = s-CodCia
            BONIFICACION.CodDiv = s-CodDiv
            BONIFICACION.coddoc = s-coddoc
            BONIFICACION.NroItm = I-NITEM
            /*BONIFICACION.almdes = p-CodAlm*/
            BONIFICACION.codmat = Almmmatg.codmat
            BONIFICACION.canped = BONIFICACION.canped + Promocion.Libre_d04
            BONIFICACION.CanPick = BONIFICACION.CanPed      /* OJO */
            BONIFICACION.Factor = 1
            BONIFICACION.aftigv = Almmmatg.AftIgv
            BONIFICACION.aftisc = Almmmatg.AftIsc
            BONIFICACION.DesMatWeb = Promocion.Libre_c01.
    END.
    RETURN "OK".
END.

IF Vtactabla.Libre_c04 = "AND" AND NOT CAN-FIND(FIRST Promocion WHERE Promocion.Libre_d03 > 0 NO-LOCK)
    THEN DO:
    /* PROMOCIONES PURAS, NO PIDE SELECCIONAR */
END.
ELSE DO:
    /* Puede que solo se pueda llevar una de las promociones o tal vez quiera comprar una de las promociones */
    /* ***************************************************** */
    /* RHC En caso de COT limitamos los productos a imprimir */
    /* ***************************************************** */
    IF s-CodDoc = "COT" THEN DO:
        DEF VAR x-Item AS INT NO-UNDO.
        x-Item = 0.
        FOR EACH Promocion:
            x-Item = x-Item + 1.
            IF x-Item > 1 THEN DELETE Promocion.
        END.
        IF x-Item > 1 THEN FOR EACH Promocion:
            Promocion.Libre_c01 = "Ud. tiene acceso a producto bonificado, el vendedor le dará mas detalles".
            IF x-SoloBonificaciones = YES THEN 
                ASSIGN Promocion.Libre_c01 = "BONIFICACION MULTIPLE - " + Promocion.Llave.
        END.
    END.
    /* ***************************************************** */
    /* Pantalla general de promociones */
    /* SOLO preguntamos si NO es COT */
    /* ***************************************************** */
    IF s-CodDoc <> "COT" THEN DO:
        DEF VAR pRpta AS LOG NO-UNDO.
        RUN vta2/dpromociongeneral (VtaCTabla.Llave, Vtactabla.Libre_c04, OUTPUT pRpta, INPUT-OUTPUT TABLE Promocion).
        IF pRpta = NO THEN RETURN "OK" .    /*RETURN "ADM-ERROR".*/
    END.
END.
/* RHC 14/05/2014 NUEVO CASO: Promociones que EXCLUYEN ENCARTES */
FIND FIRST Promocion NO-LOCK NO-ERROR.
IF VtaCTabla.Libre_L01 = YES AND AVAILABLE Promocion THEN pError = "**EXCLUYENTE**".
/* **************************************************************************************************** */
/* Grabamos las Promociones */
/* **************************************************************************************************** */
IF CAN-FIND(FIRST Promocion WHERE Promocion.Libre_d04 > 0 NO-LOCK) THEN DO:
    /* Marcamos los items que SI están afectos a la promocion */
    FOR EACH ITEM:
        IF NOT CAN-FIND(FIRST Detalle WHERE Detalle.codmat = ITEM.codmat NO-LOCK)
            THEN ASSIGN
            ITEM.Libre_c02 = "PROM" + '|' + VtaCTabla.Llave + '|' + STRING(Promocion.Libre_d05) +
            '|' + STRING(Promocion.Libre_d04)
            ITEM.Libre_d02 = Promocion.Libre_d04 / Promocion.Libre_d05. /* Factor */
    END.
END.
FOR EACH Promocion NO-LOCK WHERE Promocion.Libre_d04 > 0,
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = Promocion.codcia
    AND Almmmatg.codmat = Promocion.LlaveDetalle,
    FIRST Almtfami OF Almmmatg NO-LOCK,
    FIRST Almsfami OF Almmmatg NO-LOCK:
    /* GRABAMOS EL REGISTRO */
    IF x-SoloBonificaciones = NO THEN DO:
        FIND FIRST BONIFICACION WHERE BONIFICACION.codmat = Almmmatg.codmat NO-ERROR.
        IF NOT AVAILABLE BONIFICACION THEN DO:
            I-NITEM = I-NITEM + 1.
            CREATE BONIFICACION.
        END.
    END.
    ELSE DO:
        I-NITEM = I-NITEM + 1.
        CREATE BONIFICACION.
        ASSIGN
            BONIFICACION.NroPed = Promocion.Llave. 
    END.
    ASSIGN
        BONIFICACION.CodCia = s-CodCia
        BONIFICACION.CodDiv = s-CodDiv
        BONIFICACION.coddoc = s-coddoc
        BONIFICACION.NroItm = I-NITEM
        /*BONIFICACION.almdes = p-CodAlm*/
        BONIFICACION.codmat = Almmmatg.codmat
        BONIFICACION.factor = 1
        BONIFICACION.canped = BONIFICACION.canped + Promocion.Libre_d04
        BONIFICACION.CanPick = BONIFICACION.CanPed      /* OJO */
        BONIFICACION.aftigv = Almmmatg.AftIgv
        BONIFICACION.aftisc = Almmmatg.AftIsc
        BONIFICACION.DesMatWeb = Promocion.Libre_c01.
    /* ************************************************************* */
    IF x-SoloBonificaciones = YES THEN DO:
        ASSIGN
            BONIFICACION.undvta = Almmmatg.UndBas
            BONIFICACION.factor = 1
            BONIFICACION.Libre_c05 = 'OF'          /* Marca de PROMOCION */
            .
        IF TRUE <> (Promocion.Libre_c01 > '') THEN BONIFICACION.desmat = Almmmatg.desmat.
        ELSE BONIFICACION.desmat = Promocion.Libre_c01.
        NEXT.     /* NO CALCULAMOS MAS */
    END.
    /* ************************************************************* */
    /* Hay 2 casos: Con Precio Unitario (Promocion.Libre_d03 > 0) o Sin Precio Unitario (Promocion.Libre_d03 = 0)
    */
    /* Buscamos el precio unitario referencial */
    RUN vtagn/PrecioVentaMayorCredito.p (
        "E",        /*Faccpedi.TpoPed,        */
        pCodDiv,                /*"00001",    */
        Faccpedi.CodCli,
        Faccpedi.CodMon,
        INPUT-OUTPUT s-UndVta,
        OUTPUT f-Factor,
        Almmmatg.codmat,
        Faccpedi.FmaPgo,
        BONIFICACION.CanPed,
        s-NroDec,
        OUTPUT f-PreBas,
        OUTPUT f-PreVta,
        OUTPUT f-Dsctos,
        OUTPUT y-Dsctos,
        OUTPUT z-Dsctos,
        OUTPUT x-TipDto,
        "",     /* ClfCli: lo ingresamos solo si se quiere forzar la clasificacion */
        OUTPUT f-FleteUnitario,
        "",
        NO
        ).
    /* Si no tiene precio entonces se toma el de costo */
    IF F-Factor <= 0 THEN F-Factor = 1.
    IF f-PreVta = 0 THEN DO:
        IF Faccpedi.codmon = Almmmatg.monvta THEN f-PreVta = Almmmatg.ctotot * f-Factor.
        ELSE IF Faccpedi.codmon = 1 THEN f-PreVta = Almmmatg.ctotot * f-Factor * Almmmatg.tpocmb.
        ELSE f-PreVta = Almmmatg.ctotot * f-Factor / Almmmatg.tpocmb.
    END.

    IF Promocion.Libre_d03 = 0 THEN DO:
        ASSIGN
            f-Dsctos = 0
            z-Dsctos = 0
            y-Dsctos = 100.     /* 100% de Descuento */
    END.
    ELSE DO:
        ASSIGN
            f-PreBas = Promocion.Libre_d03
            f-PreVta = Promocion.Libre_d03
            f-Dsctos = 0
            z-Dsctos = 0
            y-Dsctos = 0.
    END.
    ASSIGN
        BONIFICACION.undvta = s-undvta
        BONIFICACION.factor = f-factor
        BONIFICACION.PorDto = f-Dsctos
        BONIFICACION.PreBas = f-PreBas
        BONIFICACION.PreUni = f-PreVta
        BONIFICACION.Libre_c04 = x-TipDto
        BONIFICACION.Libre_c05 = 'OF'          /* Marca de PROMOCION */
        BONIFICACION.Por_Dsctos[2] = y-Dsctos
        BONIFICACION.Por_Dsctos[3] = z-Dsctos.
    /* ***************************************************************** */
    {vtagn/CalculoDetalleMayorCredito.i &Tabla="BONIFICACION" }
    /* ***************************************************************** */
END.
IF s-CodDoc <> "COT" THEN DO:
    FOR EACH BONIFICACION NO-LOCK:
        /* RHC Control de Precio Unitario */
        IF BONIFICACION.PreUni <= 0 THEN DO:
            pError = "Artículo Bonificado " + BONIFICACION.CodMat + " NO tiene precio unitario".
            RETURN "ADM-ERROR".
        END.
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

