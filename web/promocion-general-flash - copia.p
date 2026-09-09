&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-TABLA FOR VtaDTabla.
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

&SCOPED-DEFINE ARITMETICA-SUNAT YES

&SCOPED-DEFINE precio-venta-general web/PrecioFinalCreditoMayorista.p

/* ***************************  Definitions  ************************** */
DEF TEMP-TABLE ITEM LIKE Facdpedi.
DEF TEMP-TABLE DETALLE LIKE Facdpedi.
DEF TEMP-TABLE DETALLE-2 LIKE Facdpedi.
DEF TEMP-TABLE DETALLE-3 LIKE Facdpedi.  

/* Todo parte del Pedido Mostrador, del Pedido al Crédito o de Pedido UTILEX */
/* RHC 29/12/2015 En caso de COTizaciones: NO se va a seleccionar, SOLO es para impresiones 
    ADEMAS se recibe la DIVISION como parámetro
*/

/* Necesitamos la tabla donde se ha registrado los productos a vender */
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.   /* Nuevo parámetro: para control de stock */
DEF INPUT PARAMETER pEvento AS CHAR.   /* Nuevo parámetro: "CREATE" "UPDATE" */
DEF INPUT-OUTPUT PARAMETER TABLE FOR ITEM. 
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.


DEF SHARED VAR s-codcia AS INT.               
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-fmapgo AS CHAR.
DEF SHARED VAR s-codmon AS INT.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-tpoped AS CHAR.
DEF SHARED VAR s-codcli AS CHAR.
DEF SHARED VAR s-nrodec AS INT.
DEF SHARED VAR s-PorIgv LIKE Ccbcdocu.PorIgv.

IF LOOKUP(s-coddoc, 'PED,P/M,COT') = 0 THEN RETURN "OK". 
IF LOOKUP (s-FmaPgo, '900,999,899') > 0 THEN RETURN "OK".                          

DEF BUFFER B-DTABLA FOR Vtadtabla.
DEF BUFFER B-DTABLA2 FOR Vtadtabla.
DEF BUFFER B-DTABLA3 FOR Vtadtabla.

DEF VAR x-ImpTot LIKE Faccpedi.imptot INIT 0 NO-UNDO.
FOR EACH ITEM NO-LOCK:
    x-ImpTot = x-ImpTot + ITEM.ImpLin.
END.
IF x-ImpTot <= 0 THEN RETURN 'OK'.

DEF VAR p-CodAlm AS CHAR.
p-CodAlm = ENTRY(1, s-CodAlm).   /* EL ALMACÉN POR DEFECTO */

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
FOR EACH ITEM WHERE ITEM.Libre_c05 = "OF":
    DELETE ITEM.
END.
FOR EACH ITEM:
    ASSIGN
        /*ITEM.Libre_D02 = 0*/
        ITEM.Libre_C02 = "".    /* Control de productos afectos a promoción */
END.

/* RHC 01/04/2016 Usuario SYS solo para hacer pruebas */
FOR EACH Vtactabla NO-LOCK WHERE Vtactabla.codcia = s-codcia
    AND VtaCTabla.Tabla = "PROM"
    AND VtaCTabla.Estado = "A"      /* Activa */
    AND (pCodCli BEGINS 'SYS' OR (TODAY >= VtaCTabla.FechaInicial AND TODAY <= VtaCTabla.FechaFinal))
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
/* Por artículos */
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
/* Por proveedor */
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
/* Llevamos el saldo */
FOR EACH DETALLE:
    CREATE DETALLE-3.
    BUFFER-COPY DETALLE TO DETALLE-3.
END.
/* Por Líneas */
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

/* 3do Buscamos las promociones */
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

/* DEF VAR x-AcumulaImportes AS DEC NO-UNDO.   */
/* DEF VAR x-AcumulaCantidades AS DEC NO-UNDO. */
DEF VAR pExcepcion AS LOG.

/* Acumulamos Importes y Cantidades */
ASSIGN
    x-AcumulaImportes = 0
    x-AcumulaCantidades = 0.

EMPTY TEMP-TABLE DETALLE.
FOR EACH ITEM NO-LOCK WHERE ITEM.Libre_c05 <> "OF", FIRST Almmmatg OF ITEM NO-LOCK:
    /* Buscamos si es una excepción */
    RUN Excepcion-Linea (OUTPUT pExcepcion).
    IF pExcepcion = YES THEN NEXT.
    /* Fin de excepciones */
    x-AcumulaImportes = x-AcumulaImportes + ITEM.ImpLin.
    x-AcumulaCantidades = x-AcumulaCantidades + (ITEM.CanPed * ITEM.Factor).
END.
/* IF Vtactabla.Libre_c01 = "Soles" THEN IF Vtactabla.Libre_d01 > x-AcumulaImportes THEN RETURN.      */
/* IF Vtactabla.Libre_c01 = "Unidades" THEN IF Vtactabla.Libre_d01 > x-AcumulaCantidades THEN RETURN. */
/* Buscamos las promociones */
/* Ordenamos por Mínimo S/. descendente */
/* FOR EACH Vtadtabla OF Vtactabla NO-LOCK WHERE Vtadtabla.Tipo = "OF" BY Vtadtabla.Libre_d04 DESC:                */
/*     /* Si se requiere un mínimo de compra */                                                                    */
/*     IF Vtadtabla.Libre_d04 > 0 AND Vtadtabla.Libre_d04 > x-AcumulaImportes THEN NEXT.                           */
/*     /* *********************************** */                                                                   */
/*     CREATE Promocion.                                                                                           */
/*     BUFFER-COPY Vtadtabla EXCEPT Vtadtabla.Libre_d04 Vtadtabla.Libre_d05 TO Promocion.                          */
/*     IF VtaCTabla.Libre_d01 > 0 THEN DO:                                                                         */
/*         IF Vtactabla.Libre_c01 = "Soles" THEN                                                                   */
/*             Promocion.Libre_d05 = TRUNCATE(x-AcumulaImportes / VtaCTabla.Libre_d01, 0) * Vtadtabla.Libre_d01.   */
/*         IF Vtactabla.Libre_c01 = "Unidades" THEN                                                                */
/*             Promocion.Libre_d05 = TRUNCATE(x-AcumulaCantidades / VtaCTabla.Libre_d01, 0) * Vtadtabla.Libre_d01. */
/*         IF Promocion.Libre_d02 > 0 THEN Promocion.Libre_d05 = MINIMUM(Promocion.Libre_d05,Promocion.Libre_d02). */
/*     END.                                                                                                        */
/*     ELSE DO:                                                                                                    */
/*         IF Vtactabla.Libre_c01 = "Soles" THEN Promocion.Libre_d05 = Vtadtabla.Libre_d01.                        */
/*         IF Vtactabla.Libre_c01 = "Unidades" THEN Promocion.Libre_d05 = Vtadtabla.Libre_d01.                     */
/*     END.                                                                                                        */
/*     Promocion.Libre_d04 = Promocion.Libre_d05.                                                                  */
/*     /* En caso que se deba dar una sola de las promociones por un mínimo de compras */                          */
/*     IF VtaCTabla.Libre_c04 = "OR" AND VtaDTabla.Libre_d05 > 0 THEN LEAVE.                                       */
/* END.                                                                                                            */


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
DEFINE VARIABLE x-Flete AS DEC NO-UNDO.
DEFINE VARIABLE pmensaje AS CHAR NO-UNDO.

DEF VAR x-Registros AS INTE NO-UNDO.
DEF VAR x-Elegido AS INTE NO-UNDO.

/* ******************* PRIMER PASO: CARGAMOS LA TABLA TEMPORAL DE PROMOCIONES ********************* */

IF VtaCTabla.Libre_d01 > 0 THEN DO:
    IF Vtactabla.Libre_c01 = "Soles" AND x-AcumulaImportes < VtaCTabla.Libre_d01 THEN RETURN "OK".
    IF Vtactabla.Libre_c01 = "Unidades" AND x-AcumulaCantidades < VtaCTabla.Libre_d01 THEN RETURN "OK".
END.

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
/* ************************************************************************************************ */
/* ******************* SEGUNDO PASO: SOLICITAMOS LOS PRODUCTOS PROMOCIONALES  ********************* */
/* Limpiamos promociones */
i-nItem = 0.
FOR EACH ITEM NO-LOCK:
    i-nItem = i-nItem + 1.
END.
/* Si Vtactabla.Libre_c04 = "AND" y NO hay promociones con precio unitario => se graba automaticamente */
IF Vtactabla.Libre_c04 = "AND" AND NOT CAN-FIND(FIRST Promocion WHERE Promocion.Libre_d03 > 0 NO-LOCK)
    THEN DO:
    FOR EACH Promocion:
        Promocion.Libre_d04 = Promocion.Libre_d05.  /* Se regala todo */
    END.
END.
ELSE DO:
    /* Puede que solo se pueda llevar una de las promociones o tal vez quiera comprar una de las promociones */
    FOR EACH Promocion:
        Promocion.Libre_d04 = Promocion.Libre_d05.  /* Se regala todo */
    END.
    /* Pantalla general de promociones */
    IF s-CodDoc <> "COT" THEN DO:
        /* *********************************************************************************************** */
        /* 25/07/2023: En caso de ser una regalo ALEATORIO */
        /* *********************************************************************************************** */
        CASE TRUE:
            WHEN Vtactabla.Libre_L05 = YES AND Vtactabla.Libre_c04 = "OR" THEN DO:
                /* **************************************************************** */
                /* Buscamos stock disponible */
                /* **************************************************************** */
                FOR EACH Promocion:
                    x-StkAct = 0.
                    FIND Almmmate WHERE Almmmate.codcia = s-codcia
                        AND Almmmate.codalm = pCodAlm
                        AND Almmmate.codmat = Promocion.LlaveDetalle
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE Almmmate THEN x-StkAct = Almmmate.StkAct.
                    IF x-StkAct > 0 THEN DO:
                        RUN gn/Stock-Comprometido-v2 (Promocion.LlaveDetalle, pCodAlm, YES, OUTPUT s-StkComprometido).
                        /* **************************************************************** */
                        /* OJO: Cuando se modifica hay que actualizar el STOCK COMPROMETIDO */
                        /* **************************************************************** */
                        IF pEvento = "UPDATE" THEN DO:
                            FIND FIRST ITEM.
                            FIND FIRST Facdpedi WHERE Facdpedi.codcia = ITEM.codcia AND
                                Facdpedi.coddoc = ITEM.coddoc AND
                                Facdpedi.nroped = ITEM.nroped AND
                                Facdpedi.codmat = Promocion.LlaveDetalle
                                NO-LOCK NO-ERROR.
                            IF AVAILABLE Facdpedi THEN s-StkComprometido = s-StkComprometido - (Facdpedi.canped * Facdpedi.factor).
                        END.
                    END.
                    s-StkDis = x-StkAct - s-StkComprometido.
                    IF s-StkDis <= 0 OR Promocion.Libre_d04 > s-StkDis THEN DELETE Promocion.
                END.
                x-Registros = 0.
                x-Elegido = 0.
                FOR EACH Promocion:
                    x-Registros = x-Registros + 1.
                END.
                IF x-Registros = 0 THEN RETURN "OK".
                IF x-Registros > 1 THEN DO:
                    /* Escogemos 1 al azar */
                    x-Elegido = RANDOM(1, x-Registros).
                    x-Registros = 0.
                    FOR EACH Promocion:
                        x-Registros = x-Registros + 1.
                        IF x-Registros <> x-Elegido THEN DELETE Promocion.
                    END.
                END.
            END.
            OTHERWISE DO:
                DEF VAR pRpta AS LOG NO-UNDO.
                RUN vta2/dpromociongeneral (VtaCTabla.Llave, Vtactabla.Libre_c04, OUTPUT pRpta, INPUT-OUTPUT TABLE Promocion).
                IF pRpta = NO THEN RETURN "OK" .    /*RETURN "ADM-ERROR".*/
            END.
        END CASE.
    END.
END.
/* RHC 14/05/2014 NUEVO CASO: Promociones que EXCLUYEN ENCARTES */
FIND FIRST Promocion NO-LOCK NO-ERROR.
IF VtaCTabla.Libre_L01 = YES AND AVAILABLE Promocion THEN pError = "**EXCLUYENTE**".
/* Grabamos las Promociones */
IF CAN-FIND(FIRST Promocion WHERE Promocion.Libre_d04 > 0 NO-LOCK) THEN DO:
    /* Marcamos los items que SI están afectos a la promocion */
    FOR EACH ITEM:
        IF NOT CAN-FIND(FIRST Detalle WHERE Detalle.codmat = ITEM.codmat NO-LOCK) 
            THEN ASSIGN 
                    ITEM.Libre_c02 = "PROM" + '|' + VtaCTabla.Llave + '|' + STRING(Promocion.Libre_d05) + 
                    '|' + STRING(Promocion.Libre_d04).
                    /*ITEM.Libre_d02 = Promocion.Libre_d04 / Promocion.Libre_d05. /* Factor */*/
    END.
END.
FOR EACH Promocion NO-LOCK WHERE Promocion.Libre_d04 > 0,
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = Promocion.codcia
    AND Almmmatg.codmat = Promocion.LlaveDetalle:
    /* ********************** CONSISTENCIAS ******************* */
    /* NO SE PUEDE REPETIR EL CODIGO PROMOCIONAL */
    /* ******************************************************** */
    FIND FIRST ITEM WHERE ITEM.codmat = Almmmatg.CodMat NO-LOCK NO-ERROR.
    IF AVAILABLE ITEM THEN DO:
        /* ************************************************************************************************ */
        /* 25/07/2022: CCamus Se incrementa a lo vendido siempre y cuando sea un regalo (100% de descuento) */
        IF NOT ( ITEM.Libre_c05 <> "OF" AND Promocion.Libre_d03 = 0 ) THEN NEXT.
        /* ************************************************************************************************ */
        ASSIGN
            ITEM.CanPed = ITEM.CanPed + (Promocion.Libre_d04 / ITEM.Factor).
        ASSIGN
            ITEM.Por_Dsctos[1] = 1 - ( (ITEM.ImpLin) / (ITEM.CanPed * ITEM.PreUni) / (1 - ITEM.Por_Dsctos[2] / 100) / (1 - ITEM.Por_Dsctos[3] / 100) ).
        ASSIGN
            ITEM.Por_Dsctos[1] = ITEM.Por_Dsctos[1] * 100.
        /* *********************** */
        /* 08/09/2022 Efecto SUNAT */
        /* *********************** */
        &IF {&ARITMETICA-SUNAT} &THEN
            ITEM.Por_Dsctos[1] = ROUND((1 - ( (ITEM.cImporteTotalConImpuesto) / (ITEM.CanPed * ITEM.PreUni) / (1 - ITEM.Por_Dsctos[2] / 100) / (1 - ITEM.Por_Dsctos[3] / 100) )) * 100, 6).
        &ENDIF
        /* *********************** */
        {vta2/calcula-linea-detalle.i &Tabla="ITEM"}
        ASSIGN
            ITEM.Libre_d03 = ITEM.Libre_d03 + (Promocion.Libre_d04 / ITEM.Factor).   /* OJO: Control */
        NEXT.
    END.
    /* INSCRITO EN EL ALMACEN */
    IF s-CodDoc <> "COT" THEN DO:
        FIND Almmmate WHERE Almmmate.codcia = s-CodCia
            AND Almmmate.codalm = p-CodAlm
            AND Almmmate.codmat = Promocion.LlaveDetalle
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmate THEN DO:
            pError = 'Producto promocional ' + Almmmatg.CodMat + ' ' + Almmmatg.desmat + CHR(10) +
                'NO asignado al almacén ' + p-CodAlm.
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END.
    /* ******************************************************** */
    /* GRABAMOS EL REGISTRO */
    I-NITEM = I-NITEM + 1.
    CREATE ITEM.
    ASSIGN
        ITEM.CodCia = s-CodCia
        ITEM.CodDiv = pCodDiv
        ITEM.coddoc = s-coddoc
        ITEM.NroItm = I-NITEM
        ITEM.almdes = p-CodAlm
        ITEM.codmat = Almmmatg.codmat
        ITEM.canped = Promocion.Libre_d04
        ITEM.CanPick = ITEM.CanPed      /* OJO */
        ITEM.aftigv = Almmmatg.AftIgv
        ITEM.aftisc = Almmmatg.AftIsc.
    /* Hay 2 casos: Con Precio Unitario (Promocion.Libre_d03 > 0) o Sin Precio Unitario (Promocion.Libre_d03 = 0)
    */
    /* Buscamos el precio unitario referencial */
    RUN {&precio-venta-general} (
        s-TpoPed,
        pCodDiv,
        s-CodCli,
        s-CodMon,
        INPUT-OUTPUT s-UndVta,
        OUTPUT f-Factor,
        Almmmatg.CodMat,
        s-FmaPgo,
        ITEM.CanPed,
        s-NroDec,
        OUTPUT f-PreBas,
        OUTPUT f-PreVta,
        OUTPUT f-Dsctos,
        OUTPUT y-Dsctos,
        OUTPUT z-Dsctos,
        OUTPUT x-TipDto,
        "",     /* ClfCli: lo ingresamos solo si se quiere forzar la clasificacion */
        OUTPUT x-Flete,
        "",
        FALSE,
        OUTPUT pMensaje).
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
        ITEM.undvta = s-undvta
        ITEM.factor = f-factor
        ITEM.PorDto = f-Dsctos
        ITEM.PreBas = f-PreBas
        ITEM.PreUni = f-PreVta
        ITEM.Libre_c04 = x-TipDto
        ITEM.Libre_c05 = 'OF'          /* Marca de PROMOCION */
        ITEM.Por_Dsctos[2] = y-Dsctos
        ITEM.Por_Dsctos[3] = z-Dsctos.
    ASSIGN
        ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni * 
                      ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                      ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                      ( 1 - ITEM.Por_Dsctos[3] / 100 ).
    IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
        THEN ITEM.ImpDto = 0.
        ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
    IF ITEM.AftIsc 
    THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
    ELSE ITEM.ImpIsc = 0.
    IF ITEM.AftIgv 
    THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
    ELSE ITEM.ImpIgv = 0.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

