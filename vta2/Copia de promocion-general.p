&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE Promocion NO-UNDO LIKE VtaDTabla.



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

/* ***************************  Definitions  ************************** */
DEF TEMP-TABLE ITEM LIKE Facdpedi.

/*  Todo parte del Pedido Mostrador, del Pedido al Crédito o de Pedido UTILEX */
/* Necesitamos la tabla donde se ha registrado los productos a vender */
DEF INPUT-OUTPUT PARAMETER TABLE FOR ITEM.
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-fmapgo AS CHAR.
DEF SHARED VAR s-codmon AS INT.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-tpoped AS CHAR.
DEF SHARED VAR s-codcli AS CHAR.
DEF SHARED VAR s-nrodec AS INT.
DEF SHARED VAR s-PorIgv LIKE Ccbcdocu.PorIgv.

IF LOOKUP(s-coddoc, 'PED,P/M') = 0 THEN RETURN "OK". 
IF LOOKUP (s-FmaPgo, '900,999') > 0 THEN RETURN "OK".                          

DEF BUFFER B-DTABLA FOR Vtadtabla.
DEF BUFFER B-DTABLA2 FOR Vtadtabla.

DEF VAR x-ImpTot LIKE Faccpedi.imptot INIT 0 NO-UNDO.
FOR EACH ITEM NO-LOCK:
    x-ImpTot = x-ImpTot + ITEM.ImpLin.
END.

DEF VAR p-CodAlm AS CHAR.
p-CodAlm = ENTRY(1, s-CodAlm).   /* EL ALMACÉN POR DEFECTO */

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
      TABLE: Promocion T "?" NO-UNDO INTEGRAL VtaDTabla
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
    
FOR EACH Vtactabla NO-LOCK WHERE Vtactabla.codcia = s-codcia
    AND VtaCTabla.Tabla = "PROM"
    AND VtaCTabla.Estado = "A"      /* Activa */
    AND TODAY >= VtaCTabla.FechaInicial 
    AND TODAY <= VtaCTabla.FechaFinal
    AND CAN-FIND(FIRST Vtadtabla OF Vtactabla WHERE Vtadtabla.tipo = "D"    /* División */
                 AND VtaDTabla.LlaveDetalle = s-coddiv 
                 AND ((s-CodDoc = "P/M" AND VtaDTabla.Libre_l01 = YES)
                      OR (s-CodDoc = "PED" AND VtaDTabla.Libre_l02 = YES))
                 NO-LOCK):
    /* Trabajamos con esta promoción */
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

DEF VAR x-Importes-01 AS DEC INIT 0 NO-UNDO.
DEF VAR x-Cantidades-01 AS DEC INIT 0 NO-UNDO.
DEF VAR x-Importes-02 AS DEC INIT 0 NO-UNDO.
DEF VAR x-Cantidades-02 AS DEC INIT 0 NO-UNDO.
DEF VAR x-ImpLin AS DEC NO-UNDO.
DEF VAR x-Control-01 AS LOG INIT NO NO-UNDO.
DEF VAR x-Control-02 AS LOG INIT NO NO-UNDO.
DEF VAR pExcepcion AS LOG.
DEF VAR x-AcumulaImportes AS DEC NO-UNDO.
DEF VAR x-AcumulaCantidades AS DEC NO-UNDO.

/* 1ro Buscamos los productos que son promocionables */
/* Por artículos */
rloop:
FOR EACH Vtadtabla OF Vtactabla NO-LOCK WHERE Vtadtabla.Tipo = "M":
    FIND FIRST ITEM WHERE ITEM.codmat = Vtadtabla.LlaveDetalle NO-LOCK NO-ERROR.
    /* Verificamos el "Operador" */
    CASE TRUE:
        WHEN Vtactabla.Libre_c02 = "OR" THEN DO:    /* Por la compra de cualquiera de los productos */
            IF NOT AVAILABLE ITEM THEN NEXT rloop.
            /* Verificamos si tiene mínimo */
            IF Vtadtabla.Libre_d01 > 0 THEN DO:      /* Debe comprar como mínimo */
                IF Vtadtabla.Libre_c01 = "Importe" THEN IF Vtadtabla.Libre_d01 > ITEM.ImpLin THEN NEXT rloop.
                IF Vtadtabla.Libre_c01 = "Cantidad" THEN IF Vtadtabla.Libre_d01 > (ITEM.CanPed * ITEM.Factor) THEN NEXT rloop.
            END.
            ASSIGN
                x-Control-01 = YES
                x-Importes-01 = x-Importes-01 + ITEM.ImpLin
                x-Cantidades-01 = x-Cantidades-01 + (ITEM.CanPed * ITEM.Factor).
        END.
        WHEN Vtactabla.Libre_c02 = "AND" THEN DO:    /* Debe comprar todos los productos */
            /* Debe comprarlo */
            IF NOT AVAILABLE ITEM THEN DO:
                x-Control-01 = NO.
                x-Importes-01 = 0.
                x-Cantidades-01 = 0.
                LEAVE rloop.
            END.
            /* Verificamos si tiene mínimo */
            IF Vtadtabla.Libre_d01 > 0 THEN DO:      /* Debe comprar como mínimo */
                IF Vtadtabla.Libre_c01 = "Importe" THEN IF Vtadtabla.Libre_d01 > ITEM.ImpLin THEN DO:
                    x-Control-01 = NO.
                    x-Importes-01 = 0.
                    x-Cantidades-01 = 0.
                    LEAVE rloop.
                END.
                IF Vtadtabla.Libre_c01 = "Cantidad" THEN IF Vtadtabla.Libre_d01 > (ITEM.CanPed * ITEM.Factor) THEN DO:
                    x-Control-01 = NO.
                    x-Importes-01 = 0.
                    x-Cantidades-01 = 0.
                    LEAVE rloop.
                END.
            END.
            ASSIGN
                x-Control-01 = YES
                x-Importes-01 = x-Importes-01 + ITEM.ImpLin
                x-Cantidades-01 = x-Cantidades-01 + (ITEM.CanPed * ITEM.Factor).
        END.
    END CASE.
END.
/* Por proveedor */
rloop:
FOR EACH Vtadtabla OF Vtactabla NO-LOCK WHERE Vtadtabla.Tipo = "P":
    /* Acumulamos por Proveedor */
    x-ImpLin = 0.
    FOR EACH ITEM NO-LOCK, FIRST Almmmatg OF ITEM NO-LOCK WHERE Almmmatg.codpr1 = Vtadtabla.LlaveDetalle:
        /* Buscamos si es una excepción */
        RUN Excepcion-Linea (OUTPUT pExcepcion).
        IF pExcepcion = YES THEN NEXT.
        /* Fin de excepciones */
        x-ImpLin = x-ImpLin + ITEM.ImpLin.
    END.
    /* Buscamos si existe al menos un registro válido */
    FIND FIRST ITEM NO-LOCK WHERE CAN-FIND(FIRST Almmmatg OF ITEM WHERE Almmmatg.codpr1 = Vtadtabla.LlaveDetalle NO-LOCK)
        NO-ERROR.
    /* Verificamos el "Operador" */
    CASE TRUE:
        WHEN Vtactabla.Libre_c03 = "OR" THEN DO:    /* Por la compra de cualquier de los productos */
            /* Verificamos si tiene mínimo */
            IF Vtadtabla.Libre_d01 > 0 AND Vtadtabla.Libre_d01 > x-ImpLin THEN NEXT rloop.
            ASSIGN
                x-Control-02 = YES
                x-Importes-02 = x-Importes-02 + x-ImpLin.
        END.
        WHEN Vtactabla.Libre_c03 = "AND" THEN DO:    /* Debe comprar todos los productos */
            /* Debe comprarlo */
            IF NOT AVAILABLE ITEM THEN DO:
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
                x-Importes-02 = x-Importes-02 + x-ImpLin.
        END.
    END CASE.
END.

/* 2do De acuerdo al "Operador" */
/* IF VtaCTabla.Libre_c05 = "AND" THEN DO:                                                                   */
/*     IF x-Control-01 = YES AND x-Control-02 = YES THEN DO:                                                 */
/*         IF VtaCTabla.Libre_c01 = "Soles" AND (x-Importes-01 = 0 OR x-Importes-02 = 0) THEN RETURN.        */
/*         IF VtaCTabla.Libre_c02 = "Unidades" AND (x-Cantidades-01 = 0 OR x-Cantidades-02 = 0) THEN RETURN. */
/*     END.                                                                                                  */
/* END.                                                                                                      */

/* 3do Buscamos las promociones */

ASSIGN
    x-AcumulaImportes = x-Importes-01 + x-Importes-02
    x-AcumulaCantidades = x-Cantidades-01 + x-Cantidades-02.
/* Verificamos que lleguen el monto mínimo si fuera el caso */
IF VtaCTabla.Libre_d01 > 0 THEN DO:
    IF Vtactabla.Libre_c01 = "Soles" AND x-AcumulaImportes < VtaCTabla.Libre_d01 THEN RETURN.
    IF Vtactabla.Libre_c01 = "Unidades" AND x-AcumulaCantidades < VtaCTabla.Libre_d01 THEN RETURN.
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
        IF Promocion.Libre_d02 > 0 THEN Promocion.Libre_d05 = MINIMUM(Promocion.Libre_d05,Promocion.Libre_d02).
    END.
    ELSE DO:
        IF Vtactabla.Libre_c01 = "Soles" THEN Promocion.Libre_d05 = Vtadtabla.Libre_d01.
        IF Vtactabla.Libre_c01 = "Unidades" THEN Promocion.Libre_d05 = Vtadtabla.Libre_d01.
    END.
    Promocion.Libre_d04 = Promocion.Libre_d05.
    
    /* En caso que se deba dar una sola de las promociones por un mínimo de compras */
    IF VtaCTabla.Libre_c04 = "OR" AND VtaDTabla.Libre_d05 > 0 THEN LEAVE.
END.

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
/* Verificamos que tenga al menos un producto promocional registrado */
FIND FIRST B-DTABLA OF Vtactabla WHERE B-DTABLA.Tipo = "OF" NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-DTABLA THEN RETURN.

/* 1ro. La promoción mas simple es la que solo tiene definido los productos promocionales */
FIND FIRST B-DTABLA OF Vtactabla WHERE B-DTABLA.Tipo = "M" NO-LOCK NO-ERROR.    /* Por articulo */
FIND FIRST B-DTABLA2 OF Vtactabla WHERE B-DTABLA2.Tipo = "P" NO-LOCK NO-ERROR.  /* Por proveedor */

IF NOT AVAILABLE B-DTABLA AND NOT AVAILABLE B-DTABLA2 THEN RUN Carga-sin-filtros.
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

/* Acumulamos Importes y Cantidades */
FOR EACH ITEM NO-LOCK, FIRST Almmmatg OF ITEM NO-LOCK:
    /* Buscamos si es una excepción */
    RUN Excepcion-Linea (OUTPUT pExcepcion).
    IF pExcepcion = YES THEN NEXT.
    /* Fin de excepciones */

    x-AcumulaImportes = x-AcumulaImportes + ITEM.ImpLin.
    x-AcumulaCantidades = x-AcumulaCantidades + (ITEM.CanPed * ITEM.Factor).
END.
IF Vtactabla.Libre_c01 = "Soles" THEN IF Vtactabla.Libre_d01 > x-AcumulaImportes THEN RETURN.
IF Vtactabla.Libre_c01 = "Unidades" THEN IF Vtactabla.Libre_d01 > x-AcumulaCantidades THEN RETURN.

/* Buscamos las promociones */
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
        IF Promocion.Libre_d02 > 0 THEN Promocion.Libre_d05 = MINIMUM(Promocion.Libre_d05,Promocion.Libre_d02).
    END.
    ELSE DO:
        IF Vtactabla.Libre_c01 = "Soles" THEN Promocion.Libre_d05 = Vtadtabla.Libre_d01.
        IF Vtactabla.Libre_c01 = "Unidades" THEN Promocion.Libre_d05 = Vtadtabla.Libre_d01.
    END.
    Promocion.Libre_d04 = Promocion.Libre_d05.
    /* En caso que se deba dar una sola de las promociones por un mínimo de compras */
    IF VtaCTabla.Libre_c04 = "OR" AND VtaDTabla.Libre_d05 > 0 THEN LEAVE.
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

FIND Vtadtabla OF Vtactabla WHERE Vtadtabla.LlaveDetalle = Almmmatg.codfam
    AND Vtadtabla.Libre_c01 = Almmmatg.subfam
    NO-LOCK NO-ERROR.
IF AVAILABLE Vtadtabla THEN pExcepcion = YES.
FIND Vtadtabla OF Vtactabla WHERE Vtadtabla.LlaveDetalle = Almmmatg.codfam
    AND Vtadtabla.Libre_c01 = ""
    NO-LOCK NO-ERROR.
IF AVAILABLE Vtadtabla THEN pExcepcion = YES.

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

i-nItem = 0.
FOR EACH ITEM NO-LOCK WHERE ITEM.Libre_c05 <> "OF":
    i-nItem = i-nItem + 1.
END.
FOR EACH ITEM NO-LOCK WHERE ITEM.Libre_c05 = "OF":
    DELETE ITEM.
END.

/* 1ro pasamos las promociones opcionales */
FIND FIRST Promocion WHERE Promocion.Libre_d03 > 0 NO-LOCK NO-ERROR.
IF AVAILABLE Promocion THEN DO:
    /* Existen 2 casos: cuando puede llevarse mas de una o cuando puede llevarse solo una */
    IF Vtactabla.Libre_c04 = "AND" THEN RUN vta2/dpromocionopcionaltodos (INPUT-OUTPUT TABLE Promocion).
    IF Vtactabla.Libre_c04 = "OR" THEN RUN vta2/dpromocionopcionalsolouno (INPUT-OUTPUT TABLE Promocion).
END.
/* 2do Grabamos las Promociones */
FOR EACH Promocion NO-LOCK WHERE Promocion.Libre_d04 > 0,
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = Promocion.codcia
    AND Almmmatg.codmat = Promocion.LlaveDetalle:
    /* ********************** CONSISTENCIAS ******************* */
    /* NO SE PUEDE REPETIR EL CODIGO */
    FIND FIRST ITEM WHERE ITEM.codmat = Almmmatg.CodMat NO-LOCK NO-ERROR.
    IF AVAILABLE ITEM THEN NEXT.
    /* INSCRITO EN EL ALMACEN */
    FIND Almmmate WHERE Almmmate.codcia = s-CodCia
        AND Almmmate.codalm = p-CodAlm
        AND Almmmate.codmat = Promocion.LlaveDetalle
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN DO:
        pError = 'Producto promocional ' + Almmmatg.CodMat + ' ' + Almmmatg.desmat + CHR(10) +
            'NO asignado al almacén ' + p-CodAlm.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ******************************************************** */
    /* GRABAMOS EL REGISTRO */
    I-NITEM = I-NITEM + 1.
    CREATE ITEM.
    ASSIGN
        ITEM.CodCia = s-CodCia
        ITEM.CodDiv = s-CodDiv
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
    RUN vta2/PrecioMayorista-Cred (
        s-TpoPed,
        s-CodDiv,
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
        FALSE
        ).
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
        ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                      ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                      ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                      ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
    IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
        THEN ITEM.ImpDto = 0.
        ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
    ASSIGN
        ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
        ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
    IF ITEM.AftIsc 
    THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
    ELSE ITEM.ImpIsc = 0.
    IF ITEM.AftIgv 
    THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
    ELSE ITEM.ImpIgv = 0.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

