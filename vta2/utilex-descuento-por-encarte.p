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

/* ***************************  Definitions  ************************** */

/*  Todo parte del Pedido Mostrador, del Pedido al Crédito o de Pedido UTILEX */
/* Necesitamos la tabla donde se ha registrado los productos a vender */
DEF INPUT PARAMETER pRowid AS ROWID.

FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR.

DEF VAR x-CodigoEncarte AS CHAR NO-UNDO.   /* OJO: Código del ENCARTE */

/* Cupón de Descuento y Cupón VIrtual */
IF LOOKUP(Faccpedi.FlgSit,"CD,CV") > 0 THEN x-CodigoEncarte = Faccpedi.Libre_c05.    /* Por Defecto */

/* ********************************************************************************* */
/* RHC 16/02/2016 Caso Facpedi.FlgSit = "KC" Vales Continental asociado a un ENCARTE */
/* ********************************************************************************* */
DEF VAR x-CodBarra AS CHAR NO-UNDO.
DEF VAR p-CodPro AS CHAR NO-UNDO.
DEF VAR x-Producto AS CHAR NO-UNDO.
IF Faccpedi.FlgSit = "KC" THEN DO:
    /* Buscamos el Vale */
    p-CodPro = Faccpedi.Libre_c02.
    x-CodBarra = Faccpedi.Libre_c05.
    
    /* Barremos todos los productos del proveedor */
    FOR EACH Vtactickets NO-LOCK WHERE Vtactickets.codcia = Faccpedi.codcia
        AND VtaCTickets.CodPro = p-CodPro 
        AND TODAY >= VtaCTickets.FchIni
        AND TODAY <= VtaCTickets.FchFin
        AND VtaCTickets.Libre_c01 <> "":    /* Debe tener un Encarte registrado */
        /* Determinamos cual es el producto */
        IF VtaCTickets.Pos_Producto = '9999' THEN NEXT.    
        /* El vale es scaneado */
        IF LENGTH(x-CodBarra) > 20 THEN DO:
            IF LENGTH(x-CodBarra) <> VtaCTickets.Longitud THEN NEXT.    
             x-Producto = SUBSTRING(x-CodBarra, INTEGER(SUBSTRING(VtaCTickets.Pos_Producto,1,2)), INTEGER(SUBSTRING(VtaCTickets.Pos_Producto,3,2))).
             IF VtaCTickets.Producto <> x-Producto THEN NEXT.             
        END.
        x-CodigoEncarte = VtaCTickets.Libre_c01.
        /* Validar la existencia del vale */
         IF Vtactickets.libre_c02 = 'SI' THEN DO:
            DEFINE BUFFER h-vtatabla FOR vtatabla.
            FIND FIRST h-vtatabla WHERE h-vtatabla.codcia  = Faccpedi.codcia
                AND  h-vtatabla.tabla = 'VUTILEXTCK' 
                AND  h-vtatabla.llave_c1 = x-CodBarra NO-LOCK NO-ERROR.
            IF AVAILABLE h-vtatabla AND h-vtatabla.libre_c01 = '20100038146' THEN DO:
                /* A pedido de Hiroshi - 17Feb2020 */
                IF TRUE <> (x-CodigoEncarte > "") THEN DO:
                    IF NOT (TRUE <> (Faccpedi.Libre_c05 > "")) THEN x-CodigoEncarte = TRIM(Faccpedi.Libre_c05).
                END.
                /*x-CodigoEncarte = "321496".*/
            END.
            ELSE DO:
                /* Ic - 04Mar2016, si en vez de Pistoletear lo digita el vale x problemas de lectura */
                FIND FIRST h-vtatabla WHERE h-vtatabla.codcia  = Faccpedi.codcia 
                    AND  h-vtatabla.tabla = 'VUTILEXTCK' 
                    AND  h-vtatabla.llave_c5 = x-CodBarra NO-LOCK NO-ERROR.
                IF AVAILABLE h-vtatabla AND h-vtatabla.libre_c01 = '20100038146' THEN DO:
                    /* A pedido de Hiroshi - 17Feb2020 */
                    IF TRUE <> (x-CodigoEncarte > "") THEN DO:
                        IF NOT (TRUE <> (Faccpedi.Libre_c05 > "")) THEN x-CodigoEncarte = TRIM(Faccpedi.Libre_c05).
                    END.
                    /*x-CodigoEncarte = "321496".*/
                END.
            END.                 
        END.
        LEAVE.
    END.
END.
/* ********************************************************************************* */

IF TRUE <> (x-CodigoEncarte > "") THEN RETURN.

FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN.

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
         HEIGHT             = 4.88
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

IF Faccpedi.CodCli = 'SYS00000001' THEN DO:
    FIND FIRST Vtactabla WHERE Vtactabla.codcia = Faccpedi.codcia
        AND VtaCTabla.Tabla = "UTILEX-ENCARTE"
        AND VtaCTabla.Estado = "A"      /* Activa */
        AND VtaCTabla.llave = x-CodigoEncarte    /* Cupón de descuento */
        NO-LOCK NO-ERROR.
END.
ELSE DO:
    FIND FIRST Vtactabla WHERE Vtactabla.codcia = Faccpedi.codcia
        AND VtaCTabla.Tabla = "UTILEX-ENCARTE"
        AND VtaCTabla.Estado = "A"      /* Activa */
        AND TODAY >= VtaCTabla.FechaInicial
        AND TODAY <= VtaCTabla.FechaFinal
        AND VtaCTabla.llave = x-CodigoEncarte    /* Cupón de descuento */
        NO-LOCK NO-ERROR.
END.
IF NOT AVAILABLE VtaCTabla THEN RETURN.
MESSAGE 'uno ok'.
/* Verificamos que la división esté registrada */
FIND FIRST Vtadtabla OF Vtactabla WHERE Vtadtabla.Tipo = "D" 
    AND Vtadtabla.LlaveDetalle = Faccpedi.CodDiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE Vtadtabla THEN RETURN.

/* Trabajamos con esta promoción */
DEF VAR pExcepcion AS LOG.
DEF VAR pPorDto2 AS DEC NO-UNDO.
DEF VAR pPreUni  AS DEC NO-UNDO.
DEF VAR pLibre_c04 AS CHAR NO-UNDO.
DEF VAR pImporte AS DEC NO-UNDO.

&SCOPED-DEFINE Rutina-Comun ~
    pPreUni = Facdpedi.PreUni.  /* Valor por defecto */ ~
    pLibre_c04 = "CD".          /* Valor por defecto */ ~
    /* % de Descuento */ ~
    pPorDto2 = (IF VtaDTabla.Libre_d01 > 0 THEN VtaDTabla.Libre_d01 ELSE VtaCTabla.Libre_d01). ~
    IF Vtadtabla.Tipo = "M" AND Vtadtabla.Libre_d02 > 0 THEN DO:~
        /* Caso especial: Tiene definido el Precio Unitario */~
        ASSIGN~
            pLibre_c04 = "UTILEX-ROJO"~
            pPorDto2 = 0~
            pPreUni = Vtadtabla.Libre_d02.~
    END.~
    ELSE IF pPorDto2 = 0 THEN NEXT. ~
    /* Solo productos sin promociones */ ~
    IF VtaCTabla.Libre_L02 = YES AND ~
        ( MAXIMUM( Facdpedi.Por_Dsctos[1], Facdpedi.Por_Dsctos[2], Facdpedi.Por_Dsctos[3] ) > 0 ~
          OR LOOKUP(Facdpedi.Libre_c04, 'PROM,VOL') > 0 ) ~
        THEN NEXT.~
    /* El mejor descuento */ ~
    IF VtaCTabla.Libre_L01 = YES AND ~
        MAXIMUM( Facdpedi.Por_Dsctos[1], Facdpedi.Por_Dsctos[2], Facdpedi.Por_Dsctos[3] ) > pPorDto2 ~
        THEN NEXT. ~
    /* Buscamos si es una excepción */ ~
    RUN Excepcion-Linea (OUTPUT pExcepcion). ~
    IF pExcepcion = YES THEN NEXT. ~
    /* Acumulamos Importes */ ~
    pImporte = pImporte + Facdpedi.ImpLin. ~
    /* ******************* */ ~
    IF VtaCTabla.Libre_l05 = NO THEN ~
    ASSIGN ~
        Facdpedi.Por_Dsctos[1] = 0 ~
        Facdpedi.Por_Dsctos[2] = 0 ~
        Facdpedi.Por_Dsctos[3] = 0. ~
    ASSIGN ~
        Facdpedi.PreUni  = pPreUni ~
        Facdpedi.PorDto2 = pPorDto2 ~
        Facdpedi.Libre_c04 = pLibre_c04.  /* MARCA DESCUENTO POR ENCARTE */


/* MARCAMOS LOS PRODUCTOS VALIDOS PARA EL ENCARTE */
                                   
RLOOP:
DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    FOR EACH Facdpedi OF Faccpedi:
        /* Limpiamos controles */
        IF Facdpedi.PorDto2 > 0 OR LOOKUP(Facdpedi.Libre_c04, "CD,UTILEX-ROJO") > 0 THEN
            ASSIGN
            Facdpedi.PorDto2 = 0
            Facdpedi.Libre_c04 = "".
    END.
    /* ******************* POR ARTICULO ****************** */
    rloop1:
    FOR EACH Vtadtabla OF Vtactabla NO-LOCK WHERE Vtadtabla.Tipo = "M":
        FIND FIRST Facdpedi OF Faccpedi WHERE Facdpedi.codmat = Vtadtabla.LlaveDetalle 
            AND LOOKUP(Facdpedi.Libre_c04, "CD,UTILEX-ROJO") = 0 
            AND Facdpedi.Libre_c05 <> "OF"
            /*AND Facdpedi.Libre_c02 <> "*PROM*"*/
            EXCLUSIVE-LOCK NO-ERROR.
        /* Verificamos el "Operador" */
        CASE TRUE:
            WHEN Vtactabla.Libre_c02 = "OR" THEN DO:    /* Por la compra de cualquiera de los productos */
                IF NOT AVAILABLE Facdpedi THEN NEXT rloop1.
            END.
            WHEN Vtactabla.Libre_c02 = "AND" THEN DO:    /* Debe comprar todos los productos */
                /* Debe comprarlo */
                IF NOT AVAILABLE Facdpedi THEN UNDO rloop, LEAVE rloop.
            END.
        END CASE.
        {&Rutina-Comun}
    END.
    /* ******************* POR PROVEEDOR ****************** */
    rloop2:
    FOR EACH Vtadtabla OF Vtactabla NO-LOCK WHERE Vtadtabla.Tipo = "P":
        FIND FIRST Facdpedi OF Faccpedi WHERE LOOKUP(Facdpedi.Libre_c04, "CD,UTILEX-ROJO") = 0 
            AND Facdpedi.Libre_c05 <> "OF" 
            /*AND Facdpedi.Libre_c02 <> "*PROM*"*/
            AND CAN-FIND(FIRST Almmmatg OF Facdpedi WHERE Almmmatg.codpr1 = Vtadtabla.LlaveDetalle NO-LOCK)
            NO-LOCK NO-ERROR.
        /* Verificamos el "Operador" */
        CASE TRUE:
            WHEN Vtactabla.Libre_c03 = "OR" THEN DO:    /* Por la compra de cualquiera de los productos */
                IF NOT AVAILABLE Facdpedi THEN NEXT rloop2.
            END.
            WHEN Vtactabla.Libre_c03 = "AND" THEN DO:    /* Debe comprar todos los productos */
                /* Debe comprarlo */
                IF NOT AVAILABLE Facdpedi THEN UNDO rloop, LEAVE rloop.
            END.
        END CASE.
        FOR EACH Facdpedi OF Faccpedi WHERE LOOKUP(Facdpedi.Libre_c04, "CD,UTILEX-ROJO") = 0 AND
            Facdpedi.Libre_c05 <> "OF",
            FIRST Almmmatg OF Facdpedi WHERE Almmmatg.codpr1 = Vtadtabla.LlaveDetalle NO-LOCK:
            {&Rutina-Comun}
        END.
    END.
    /* ******************* POR LINEAS ****************** */
    rloop3:
    FOR EACH Vtadtabla OF Vtactabla NO-LOCK WHERE Vtadtabla.Tipo = "L":
        FIND FIRST Facdpedi OF Faccpedi WHERE LOOKUP(Facdpedi.Libre_c04, "CD,UTILEX-ROJO") = 0 
            AND Facdpedi.Libre_c05 <> "OF" 
            /*AND Facdpedi.Libre_c02 <> "*PROM*"*/
            AND CAN-FIND(FIRST Almmmatg OF Facdpedi WHERE Almmmatg.codfam = Vtadtabla.LlaveDetalle AND 
                     (Vtadtabla.Libre_c01 = "" OR Almmmatg.subfam = Vtadtabla.Libre_c01) NO-LOCK)
            NO-LOCK NO-ERROR.
        /* Verificamos el "Operador" */
        CASE TRUE:
            WHEN Vtactabla.Libre_c05 = "OR" THEN DO:    /* Por la compra de cualquiera de los productos */
                IF NOT AVAILABLE Facdpedi THEN NEXT rloop3.
            END.
            WHEN Vtactabla.Libre_c05 = "AND" THEN DO:    /* Debe comprar todos los productos */
                /* Debe comprarlo */
                IF NOT AVAILABLE Facdpedi THEN UNDO rloop, LEAVE rloop.
            END.
        END CASE.
        FOR EACH Facdpedi OF Faccpedi WHERE LOOKUP(Facdpedi.Libre_c04, "CD,UTILEX-ROJO") = 0 
            AND Facdpedi.Libre_c05 <> "OF"
            /*AND Facdpedi.Libre_c02 <> "*PROM*"*/,
            FIRST Almmmatg OF Facdpedi NO-LOCK WHERE Almmmatg.codfam = Vtadtabla.LlaveDetalle AND 
            (Vtadtabla.Libre_c01 = "" OR Almmmatg.subfam = Vtadtabla.Libre_c01):
            {&Rutina-Comun}
        END.
    END.
    /* RHC 12/12/17 Silvia Wong Mínimo de Venta */
    IF VtaCTabla.Libre_d04 > 0 AND pImporte < VtaCTabla.Libre_d04 THEN DO:
        /* Cuando la venta no llega al mínimo => Se descarta todo */
        UNDO, RETURN.
    END.
END.

/* CALCULO FINAL */
ASSIGN
    Faccpedi.ImpDto2 = 0.
FOR EACH Facdpedi OF Faccpedi WHERE LOOKUP(Facdpedi.Libre_c04, "CD,UTILEX-ROJO") > 0, 
    FIRST Almmmatg OF Facdpedi NO-LOCK:
    ASSIGN
        Facdpedi.ImpLin = Facdpedi.CanPed * Facdpedi.PreUni * 
        ( 1 - Facdpedi.Por_Dsctos[1] / 100 ) *
        ( 1 - Facdpedi.Por_Dsctos[2] / 100 ) *
        ( 1 - Facdpedi.Por_Dsctos[3] / 100 )
        Facdpedi.ImpDto2 = ROUND ( Facdpedi.ImpLin * Facdpedi.PorDto2 / 100, 2).
    IF Facdpedi.Por_Dsctos[1] = 0 AND Facdpedi.Por_Dsctos[2] = 0 AND Facdpedi.Por_Dsctos[3] = 0 
        THEN Facdpedi.ImpDto = 0.
    ELSE Facdpedi.ImpDto = Facdpedi.CanPed * Facdpedi.PreUni - Facdpedi.ImpLin.
    ASSIGN
        Facdpedi.ImpLin = ROUND(Facdpedi.ImpLin, 2)
        Facdpedi.ImpDto = ROUND(Facdpedi.ImpDto, 2).
    IF Facdpedi.AftIsc 
        THEN Facdpedi.ImpIsc = ROUND(Facdpedi.PreBas * Facdpedi.CanPed * (Almmmatg.PorIsc / 100),4).
    IF Facdpedi.AftIgv 
        THEN Facdpedi.ImpIgv = Facdpedi.ImpLin - ROUND( Facdpedi.ImpLin  / ( 1 + (Faccpedi.PorIgv / 100) ), 4 ).
    ASSIGN
        Faccpedi.ImpDto2 = Faccpedi.ImpDto2 + Facdpedi.ImpDto2.
    
END.

RUN Recalcula-importe-encarte.
/* **************************************************** */
IF VtaCTabla.Libre_d02 = 0 THEN RETURN.     /* SIN TOPE */
/* **************************************************** */

DEF VAR x-ImpDto2 LIKE Faccpedi.ImpDto2 NO-UNDO.

x-ImpDto2 = Faccpedi.ImpDto2.
Faccpedi.ImpDto2 = MINIMUM(Faccpedi.ImpDto2, VtaCTabla.Libre_d02).
IF x-ImpDto2 <> Faccpedi.ImpDto2 THEN DO:
    FOR EACH Facdpedi OF Faccpedi WHERE Facdpedi.PorDto2 > 0:
        Facdpedi.ImpDto2 = ROUND (Facdpedi.ImpDto2 * ( Faccpedi.ImpDto2 / x-ImpDto2 ), 2).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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

&IF DEFINED(EXCLUDE-Recalcula-importe-encarte) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcula-importe-encarte Procedure 
PROCEDURE Recalcula-importe-encarte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF BUFFER BDPEDI FOR facdpedi.
DEF BUFFER BCTABLA FOR vtactabla.
DEF VAR x-Tope AS DEC NO-UNDO.

FOR EACH facdpedi OF faccpedi NO-LOCK WHERE Facdpedi.PorDto2 > 0
    AND Facdpedi.Libre_c04 = "CD"
    AND Facdpedi.libre_c02 BEGINS 'PROM|'
    BREAK BY facdpedi.libre_c02:
    
    IF FIRST-OF(Facdpedi.libre_c02) THEN DO:
        FIND BCTABLA WHERE BCTABLA.codcia = Faccpedi.codcia
            AND BCTABLA.tabla = ENTRY(1, Facdpedi.Libre_c02, '|')
            AND BCTABLA.llave = ENTRY(2, Facdpedi.Libre_c02, '|')
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE BCTABLA THEN NEXT.
        IF BCTABLA.libre_d01 = 0 OR BCTABLA.libre_c01 <> 'Unidades' THEN NEXT.
        /* Tope máximo de productos afectos a la promocion */
        x-Tope = BCTABLA.libre_d01 *  INTEGER(ENTRY(4,Facdpedi.Libre_c02,'|')).
        
        /* Importe del Descuento Promocional */
        FOR EACH BDPEDI WHERE BDPEDI.codcia = Facdpedi.codcia
            AND BDPEDI.coddoc = Facdpedi.coddoc
            AND BDPEDI.nroped = Facdpedi.nroped
            AND BDPEDI.libre_c02 = Facdpedi.libre_c02:
            BDPEDI.ImpDto2 = ROUND ( BDPEDI.ImpLin * BDPEDI.PorDto2 / 100, 2).
            IF BDPEDI.CanPed <= x-Tope THEN DO:
                BDPEDI.ImpDto2 = 0.
                x-Tope = x-Tope - BDPEDI.CanPed.
            END.
            ELSE DO:
                BDPEDI.ImpDto2 = ROUND ( (BDPEDI.CanPed - x-Tope) * (BDPEDI.ImpLin / BDPEDI.CanPed) * BDPEDI.PorDto2 / 100, 2).
                x-Tope = 0.
            END.
            IF x-Tope <= 0 THEN LEAVE.
        END.
    END.
END.
/* CALCULO FINAL */
ASSIGN
    Faccpedi.ImpDto2 = 0.
FOR EACH Facdpedi OF Faccpedi WHERE LOOKUP(Facdpedi.Libre_c04, "CD") > 0:
    Faccpedi.ImpDto2 = Faccpedi.ImpDto2 + Facdpedi.ImpDto2.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

