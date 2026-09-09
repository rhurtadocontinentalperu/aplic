/* MARCAMOS LOS PRODUCTOS VALIDOS PARA EL ENCARTE */
RLOOP:
DO ON ERROR UNDO, LEAVE:
    /* LIMPIAMOS CONTROLES */
    FOR EACH Facdpedi OF Faccpedi:
        IF Facdpedi.PorDto2 > 0 OR Facdpedi.Libre_c04 = "CD" THEN
            ASSIGN
            Facdpedi.PorDto2 = 0
            Facdpedi.Libre_c04 = "".
    END.
    /* BARREMOS ITEMS */
    FOR EACH Facdpedi OF Faccpedi WHERE Facdpedi.Libre_c04 <> "UTILEX-ROJO" AND
        Facdpedi.Libre_c05 <> "OF",
        FIRST Almmmatg OF Facdpedi NO-LOCK:
        /* Buscamos su porcentaje */
        /* Por articulo */
        FIND FIRST Vtadtabla OF Vtactabla WHERE Vtadtabla.Tipo = "M"
            Vtadtabla.LlaveDetalle = Facdpedi.codmat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Vtadtabla THEN pPorDto2 = (IF VtaDTabla.Libre_d01 > 0 THEN VtaDTabla.Libre_d01 ELSE VtaCTabla.Libre_d01).
        /* Por Proveedor */
        IF pPorDto2 = 0 THEN DO:
            FIND FIRST Vtadtabla OF Vtactabla WHERE Vtadtabla.Tipo = "P" AND
                Vtadtabla.LlaveDetalle = Almmmatg.CodPr1
                NO-LOCK NO-ERROR.
            IF AVAILABLE Vtadtabla THEN pPorDto2 = (IF VtaDTabla.Libre_d01 > 0 THEN VtaDTabla.Libre_d01 ELSE VtaCTabla.Libre_d01).
        END.
        /* Por Linea y/o Sublinea */
        IF pPorDto2 = 0 THEN DO:
            FIND FIRST Vtadtabla OF Vtactabla WHERE Vtadtabla.Tipo = "L" AND
                Vtadtabla.LlaveDetalle = Almmmatg.CodFam AND
                (Vtadtabla.Libre_c01 = "" OR Vtadtabla.Libre_c01 = Almmmatg.SubFam)
                NO-LOCK NO-ERROR.
            IF AVAILABLE Vtadtabla THEN pPorDto2 = (IF VtaDTabla.Libre_d01 > 0 THEN VtaDTabla.Libre_d01 ELSE VtaCTabla.Libre_d01).
        END.
        /* Buscamos si es una excepción */
        /* Por Linea y/o Sublinea */
        FIND Vtadtabla OF Vtactabla WHERE Vtadtabla.LlaveDetalle = Almmmatg.codfam
            AND Vtadtabla.Libre_c01 = Almmmatg.subfam
            AND Vtadtabla.Tipo = "XL"
            NO-LOCK NO-ERROR.
        IF AVAILABLE Vtadtabla THEN pExcepcion = NEXT.
        FIND Vtadtabla OF Vtactabla WHERE Vtadtabla.LlaveDetalle = Almmmatg.codfam
            AND Vtadtabla.Libre_c01 = ""
            AND Vtadtabla.Tipo = "XL"
            NO-LOCK NO-ERROR.
        IF AVAILABLE Vtadtabla THEN pExcepcion = NEXT.
        /* Por Producto */
        FIND Vtadtabla OF Vtactabla WHERE Vtadtabla.LlaveDetalle = Almmmatg.codmat
            AND Vtadtabla.Tipo = "XM"
            NO-LOCK NO-ERROR.
        IF AVAILABLE Vtadtabla THEN pExcepcion = NEXT.
        ASSIGN
            Facdpedi.Por_Dsctos[1] = 0
            Facdpedi.Por_Dsctos[2] = 0
            Facdpedi.Por_Dsctos[3] = 0
            Facdpedi.PorDto2 = pPorDto2
            Facdpedi.Libre_c04 = "CD".  /* MARCA DESCUENTO POR ENCARTE */
    END.
END.
