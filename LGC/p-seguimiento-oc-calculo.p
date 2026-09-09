&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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

/*lFechaProceso = TODAY - 1.  /*05/30/2014*/ /*TODAY - 1*/.*/

DEFINE INPUT PARAMETER lFechaProceso AS DATE    NO-UNDO.
DEFINE SHARED VAR s-codcia AS INT.

IF WEEKDAY(lFechaProceso) = 1 THEN DO:
    /* Domingo no se procesa */
    RETURN NO-APPLY.
END.

/*
DEFINE TEMP-TABLE tt-prov-alm-art
        FIELDS tt-codpro AS CHAR FORMAT 'x(11)'
        FIELDS tt-codalm AS CHAR FORMAT 'x(3)'
        FIELDS tt-codmat AS CHAR FORMAT 'x(6)'
        FIELDS tt-desmat AS CHAR FORMAT 'x(80)'
        FIELDS tt-stkact AS DECIMAL INIT 0
        FIELDS tt-costo AS DECIMAL INIT 0
        FIELDS tt-dias AS DECIMAL INIT 0
        FIELDS tt-art-oc AS CHAR FORMAT 'x(1)' INIT 'N'

        INDEX idx01 IS PRIMARY tt-codpro tt-codalm tt-codmat.
*/

DEFINE TEMP-TABLE tt-prov-art
        FIELDS tt-codpro AS CHAR FORMAT 'x(11)'
        FIELDS tt-codmat AS CHAR FORMAT 'x(6)'
        FIELDS tt-qty-oc AS DECIMAL INIT 0
        FIELDS tt-art-oc AS CHAR FORMAT 'x(1)' INIT 'N'
        FIELDS tt-nuevo AS CHAR FORMAT 'x(1)' INIT 'N'

        INDEX idx01 IS PRIMARY tt-codpro tt-codmat.

DEFINE TEMP-TABLE tt-oc-seguimiento
            FIELDS tt-codpro AS CHAR FORMAT 'X(11)'
        FIELDS tt-nompro AS CHAR FORMAT 'x(11)'
        FIELDS tt-imp-oc AS DECIMAL                 /* Importes O/C de la fecha */
        FIELDS tt-ranking AS DECIMAL EXTENT 25      /* Compras segun Rankinh */
        FIELDS tt-stk-art-oc AS DECIMAL             /* Stk actual valorizados - articulos involucrados en las O/C */
        FIELDS tt-nro-dias AS DECIMAL
        FIELDS tt-plazo AS CHAR FORMAT 'x(80)'
        FIELDS tt-rotacion AS INT
        FIELDS tt-stk-arts AS DECIMAL               /* Stk actual valaorizados - todos los articulos del proveedor */
        FIELDS tt-presupuesto AS DECIMAL INIT 0     /* Importe presupuestado */
        FIELDS tt-acumulado AS DEC INIT 0           /* Compras acumuladas del mes */
        FIELDS tt-items AS INT INIT 0               /* Nro de articulos */
        FIELDS tt-StkMaximo AS DEC INIT 0           /* Stock Maximo x Proveedor **/
        FIELDS tt-ItemMaximo AS DEC INIT 0             /* Items Maximos x Proveedor */

        INDEX idx01 IS PRIMARY tt-codpro.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Include
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
SESSION:SET-WAIT-STATE('GENERAL').
RUN ue-ordenes-compra.
RUN ue-stocks.
RUN ue-ordenes-compra-acumulada.
RUN ue-graba.

SESSION:SET-WAIT-STATE('').

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-graba Include 
PROCEDURE ue-graba :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR lFecha AS CHAR.
DEFINE VAR lRowId AS ROWID.

lFecha = STRING(YEAR(lFechaProceso),"9999").
lFecha = lFecha + STRING(MONTH(lFechaProceso),"99").
lFecha = lFecha + STRING(DAY(lFechaProceso),"99").

DISABLE TRIGGERS FOR LOAD OF vtatabla .

DEF BUFFER B-vtatabla FOR vtatabla.

/* Elimino proceso anterior de la misma fecha */
FOR EACH vtatabla WHERE vtatabla.codcia = 1 AND vtatabla.tabla = 'OC-SEGUI' 
        AND vtatabla.llave_c1 = lFecha NO-LOCK:
    ASSIGN lROwId = ROWID(vtatabla).
    FIND B-vtatabla WHERE ROWID(B-vtatabla) = lRowId EXCLUSIVE NO-ERROR.
    IF AVAILABLE B-vtatabla THEN DO:
        DELETE B-vtatabla.
    END.
END.
/* Grabo los nuevos datos calculados */
FOR EACH tt-oc-seguimiento NO-LOCK :
    CREATE B-vtatabla.
        ASSIGN B-vtatabla.codcia = s-codcia
                B-vtatabla.tabla = 'OC-SEGUI'
                B-vtatabla.llave_c1 = lFecha
                B-vtatabla.llave_c2 = tt-oc-seguimiento.tt-codpro
                B-vtatabla.libre_c01 = tt-oc-seguimiento.tt-nompro
                B-vtatabla.valor[1] = tt-oc-seguimiento.tt-imp-oc
                B-vtatabla.valor[2] = tt-oc-seguimiento.tt-ranking[1]
                B-vtatabla.valor[3] = tt-oc-seguimiento.tt-ranking[2]
                B-vtatabla.valor[4] = tt-oc-seguimiento.tt-ranking[3]
                B-vtatabla.valor[5] = tt-oc-seguimiento.tt-ranking[4]
                B-vtatabla.valor[6] = tt-oc-seguimiento.tt-ranking[5]
                B-vtatabla.valor[7] = tt-oc-seguimiento.tt-ranking[6]
                B-vtatabla.valor[8] = tt-oc-seguimiento.tt-ranking[7]
                B-vtatabla.valor[9] = tt-oc-seguimiento.tt-stk-art-oc
                B-vtatabla.valor[10] = tt-oc-seguimiento.tt-nro-dias
                B-vtatabla.libre_c02 = tt-oc-seguimiento.tt-plazo
                B-vtatabla.valor[11] = tt-oc-seguimiento.tt-stk-arts
                B-vtatabla.valor[12] = tt-oc-seguimiento.tt-presupuesto
                B-vtatabla.valor[13] = tt-oc-seguimiento.tt-acumulado
                B-vtatabla.valor[14] = tt-oc-seguimiento.tt-items
                B-vtatabla.valor[15] = if(tt-oc-seguimiento.tt-StkMaximo = 0) THEN 
                    tt-oc-seguimiento.tt-stk-arts ELSE tt-oc-seguimiento.tt-StkMaximo
                B-vtatabla.valor[16] = if(tt-oc-seguimiento.tt-ItemMaximo = 0) THEN 
                    tt-oc-seguimiento.tt-items ELSE tt-oc-seguimiento.tt-ItemMaximo.
END.

RELEASE B-vtatabla.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-ordenes-compra Include 
PROCEDURE ue-ordenes-compra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR lSec AS INT.
DEFINE VAR lCambio AS DEC.
DEFINE VAR lVenta AS DEC.
DEFINE VAR esNuevo AS LOG.

FOR EACH lg-cocmp WHERE lg-cocmp.codcia = s-codcia 
    AND lg-cocmp.fchdoc = lFechaProceso AND lg-cocmp.tpodoc = 'N' 
    AND (lg-cocmp.flgsit <> 'X' AND lg-cocmp.flgsit <> 'A' )  NO-LOCK,  /* Rechazados y Anulados */
    EACH lg-docmp OF lg-cocmp NO-LOCK, 
    FIRST almmmatg OF lg-docmp NO-LOCK,
    FIRST Almtfami OF Almmmatg NO-LOCK WHERE Almtfami.SwComercial = YES  :

    FIND FIRST gn-prov WHERE gn-prov.codcia = 0 AND gn-prov.codpro = lg-cocmp.codpro NO-LOCK NO-ERROR.

    FIND tt-oc-seguimiento WHERE tt-codpro = lg-cocmp.codpro NO-LOCK NO-ERROR.
    IF NOT AVAILABLE tt-oc-seguimiento THEN DO:
        CREATE tt-oc-seguimiento.
        ASSIGN tt-codpro    = lg-cocmp.codpro
                tt-nompro   = gn-prov.nompro
                tt-imp-oc   = 0             /* Importes de Ordenes de Compra */
                tt-stk-art-oc = 0
                tt-nro-dias = 0
                tt-plazo = ""
                tt-rotacion = 0
                tt-stk-arts = 0
                tt-presupuesto = 0
                tt-acumulado = 0
                tt-items = 0.
                
        REPEAT lSec = 1 TO 25.
            ASSIGN tt-ranking[lSec] = 0.
        END.
        /*DISPLAY gn-prov.nompro lg-docmp.codmat.*/
    END.
    /* Total de las ordenes de compras */
    lcambio = IF(lg-cocmp.codmon = 2) THEN lg-cocmp.tpocmb ELSE 1.
    lVenta = ((lg-docmp.canpedi * lg-docmp.preuni) * lCambio).
    /* Descuentos */
    lVenta = lVenta - (lVenta * (lg-docmp.dsctos[1] / 100)).
    lVenta = lVenta - (lVenta * (lg-docmp.dsctos[2] / 100)).
    lVenta = lVenta - (lVenta * (lg-docmp.dsctos[3] / 100)).
    ASSIGN tt-imp-oc = tt-imp-oc + lVenta.
                                                     
    /* totales por los rankings ( Clasificacion )*/
    lSec = 7.
    CASE almmmatg.tiprot[1]:
        WHEN 'A' THEN lsec = 1.
        WHEN 'B' THEN lSec = 2.
        WHEN 'C' THEN lSec = 3.
        WHEN 'D' THEN lSec = 4.
        WHEN 'E' THEN lSec = 5.
        WHEN 'F' THEN lSec = 6.
    END CASE.    

    /* Productos por proveedor */
    esNuevo = NO.
    FIND tt-prov-art WHERE tt-prov-art.tt-codpro = lg-cocmp.codpro AND 
                        tt-prov-art.tt-codmat = lg-docmp.codmat NO-ERROR.
    IF NOT AVAILABLE tt-prov-art THEN DO:
        CREATE tt-prov-art.
        ASSIGN tt-prov-art.tt-codpro   = lg-cocmp.codpro
                tt-prov-art.tt-codmat  = lg-docmp.codmat
                tt-prov-art.tt-qty-oc = 0
                tt-prov-art.tt-art-oc = 'S'
                tt-prov-art.tt-nuevo = IF (lSec = 7) THEN 'S' ELSE 'N'.
        esNuevo = YES.
    END.
    /*ASSIGN tt-prov-art.tt-qty-oc = tt-prov-art.tt-qty-oc + lVenta.    */

    /* Sin Clasificacion (Articulo nuevo) */
    IF lSec = 7 THEN DO:
        lVenta = IF (esNuevo = YES) THEN 1 ELSE 0.
    END.

    ASSIGN tt-oc-seguimiento.tt-ranking[lSec] = tt-oc-seguimiento.tt-ranking[lSec] + lVenta .
    ASSIGN tt-oc-seguimiento.tt-items = tt-oc-seguimiento.tt-items + IF (esNuevo = YES ) THEN 1 ELSE 0.
    
    ASSIGN tt-prov-art.tt-qty-oc = tt-prov-art.tt-qty-oc + lg-docmp.canpedi.    

END.

/* Ubico los productos que pertenecen a los proveedores solo ACTIVOS*/
FOR EACH tt-oc-seguimiento EXCLUSIVE:
    FOR EACH almmmatg WHERE almmmatg.codcia = s-codcia 
            AND almmmatg.codpr1 = tt-oc-seguimiento.tt-codpro AND almmmatg.tpoart = 'A' 
            USE-INDEX matg13  NO-LOCK ,
        FIRST Almtfami OF Almmmatg NO-LOCK WHERE Almtfami.SwComercial = YES  :

        FIND tt-prov-art WHERE tt-prov-art.tt-codpro = tt-oc-seguimiento.tt-codpro AND 
                                tt-prov-art.tt-codmat = almmmatg.codmat NO-ERROR.
        IF NOT AVAILABLE tt-prov-art THEN DO:
            CREATE tt-prov-art.
            ASSIGN tt-prov-art.tt-codpro   = tt-oc-seguimiento.tt-codpro
                    tt-prov-art.tt-codmat  = almmmatg.codmat
                    tt-prov-art.tt-qty-oc = 0
                    tt-prov-art.tt-art-oc = 'N'.

            ASSIGN tt-oc-seguimiento.tt-items = tt-oc-seguimiento.tt-items + 1.

        END.

    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-ordenes-compra-acumulada Include 
PROCEDURE ue-ordenes-compra-acumulada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* El primer dia del mes */
IF DAY(lFechaProceso) = 1 THEN DO:
    RETURN NO-APPLY.
END.

DEFINE VAR lFechaDesde AS DATE.
DEFINE VAR lFechaHasta AS DATE.
DEFINE VAR lCambio AS DEC.
DEFINE VAR lVenta AS DEC.

lFechaDesde = DATE(MONTH(lFechaProceso),1,YEAR(lFechaProceso)).
lFechaHasta = DATE(MONTH(lFechaProceso),DAY(lFechaProceso) - 1,YEAR(lFechaProceso)).

FOR EACH tt-oc-seguimiento EXCLUSIVE :
    FOR EACH lg-cocmp WHERE lg-cocmp.codcia = s-codcia 
        AND lg-cocmp.codpro = tt-oc-seguimiento.tt-codpro
        AND (lg-cocmp.fchdoc >= lFechaDesde AND lg-cocmp.fchdoc <= lFechaHasta)
        AND lg-cocmp.tpodoc = 'N' AND (lg-cocmp.flgsit <> 'X' AND lg-cocmp.flgsit <> 'A' )  /* Rechazados y Anulados */
        NO-LOCK USE-INDEX Cocmp03,
        EACH lg-docmp OF lg-cocmp NO-LOCK, 
        FIRST almmmatg OF lg-docmp NO-LOCK,
        FIRST Almtfami OF Almmmatg NO-LOCK WHERE Almtfami.SwComercial = YES  :

        lcambio = IF(lg-cocmp.codmon = 2) THEN lg-cocmp.tpocmb ELSE 1.
        lVenta = ((lg-docmp.canpedi * lg-docmp.preuni) * lCambio).
        /* Descuentos */
        lVenta = lVenta - (lVenta * (lg-docmp.dsctos[1] / 100)).
        lVenta = lVenta - (lVenta * (lg-docmp.dsctos[2] / 100)).
        lVenta = lVenta - (lVenta * (lg-docmp.dsctos[3] / 100)).

        tt-oc-seguimiento.tt-acumulado = tt-oc-seguimiento.tt-acumulado + lVenta.
    END.
END.

/* - Acumulo los importe de las O/C del dia procesado
   - Busco lo presupuestado
 */
FOR EACH tt-oc-seguimiento EXCLUSIVE :
    /* O/C del dia en cuestion*/
    tt-oc-seguimiento.tt-acumulado = tt-oc-seguimiento.tt-acumulado + tt-oc-seguimiento.tt-imp-oc.
    /* Lo presupuestado */
    FIND FIRST lg-tabla WHERE lg-tabla.codcia = s-codcia AND 
                lg-tabla.tabla = 'PRSPRV' AND 
                lg-tabla.codigo = tt-oc-seguimiento.tt-codpro NO-ERROR.
    IF AVAILABLE lg-tabla THEN DO:
        tt-oc-seguimiento.tt-presupuesto = lg-tabla.valor[1].
        tt-oc-seguimiento.tt-StkMaximo   = lg-tabla.valor[2].
        tt-oc-seguimiento.tt-ItemMax     = lg-tabla.valor[2].
    END.
    ELSE DO:
        /* Default */
        tt-oc-seguimiento.tt-presupuesto = 1000000.
    END.
        
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-stocks Include 
PROCEDURE ue-stocks :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lAlmacenes AS CHAR.
DEFINE VAR lCambio AS DEC.
DEFINE VAR lSec AS INT.
DEFINE VAR lPromPonderado AS DEC.
DEFINE VAR lDias AS DEC.
DEFINE VAR lDias1 AS DEC.
DEFINE VAR lDias2 AS DEC.
DEFINE VAR lImpArt AS DEC.
DEFINE VAR lStkArt AS DEC.
DEFINE VAR lStkAct AS DEC.
DEFINE VAR lLibreC04 AS DEC.

lAlmacenes = ''.
FOR EACH almacen NO-LOCK WHERE almacen.codcia = s-codcia 
    AND almacen.codalm <> '11T' :

    IF lAlmacenes = '' THEN lAlmacenes = TRIM(almacen.codalm).
    ELSE lAlmacenes = lAlmacenes + ',' + TRIM(almacen.codalm).
END.

/* Valorizo los stock de las Ordenes Compra
    y de todos los productos que pertenecen a los proveedores
 */
FOR EACH tt-oc-seguimiento EXCLUSIVE:

    ASSIGN tt-stk-art-oc = 0
            tt-stk-arts = 0.
    
    lDias = 0.
    lPromPonderado = 0.

    FOR EACH tt-prov-art WHERE tt-prov-art.tt-codpro = tt-oc-seguimiento.tt-codpro NO-LOCK :
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
            almmmatg.codmat =  tt-prov-art.tt-codmat NO-LOCK NO-ERROR.

        /* Tipo de Cambio */
        lCambio = IF (Almmmatg.MonVta = 2) THEN almmmatg.TpoCmb ELSE 1.
        lDias1 = 0.
        lImpArt = 0.
        lStkArt = 0.        

        DO lSec = 1 TO NUM-ENTRIES(lAlmacenes) :
            lStkAct = 0.
            FIND LAST almstkal WHERE almstkal.codcia = s-codcia AND 
                almstkal.codalm = ENTRY(lSec, lAlmacenes) AND
                almstkal.codmat = tt-prov-art.tt-codmat AND
                almstkal.fecha <= lFechaProceso NO-LOCK NO-ERROR.
            IF AVAILABLE almstkal THEN DO:
                lStkAct = almstkal.stkact.
            END.
            /*  */
            lLibreC04 = 0.
            FIND Almmmate WHERE Almmmate.codcia = s-codcia
                AND Almmmate.codalm = ENTRY(lSec, lAlmacenes)
                AND Almmmate.codmat = tt-prov-art.tt-codmat
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almmmate THEN DO:                
                lLibreC04 = DECIMAL(Almmmate.Libre_c04).
            END.
            IF tt-prov-art.tt-art-oc = 'S' THEN DO:
                tt-oc-seguimiento.tt-stk-art-oc = tt-oc-seguimiento.tt-stk-art-oc + 
                    ((lStkAct * almmmatg.ctolis) * lCambio).
                /*   */                
                lStkArt = lStkArt + lStkAct.
                lImpArt = lImpArt + ((lStkAct * almmmatg.ctolis) * lCambio).
                lDias1 = lDias1 + lLibreC04.  
            END.        
        
            tt-oc-seguimiento.tt-stk-arts = tt-oc-seguimiento.tt-stk-arts + 
                ((lStkAct * almmmatg.ctolis) * lCambio).                
            
            /*
            /* Proveedor Articulo */
            FIND FIRST tt-prov-alm-art WHERE tt-prov-alm-art.tt-codpro = tt-oc-seguimiento.tt-codpro
                        AND tt-prov-alm-art.tt-codalm = ENTRY(lSec, lAlmacenes)
                        AND tt-prov-alm-art.tt-codmat = tt-prov-art.tt-codmat
                        NO-ERROR.
            IF NOT AVAILABLE tt-prov-alm-art THEN DO:
                CREATE tt-prov-alm-art.
                    ASSIGN tt-prov-alm-art.tt-codpro = tt-oc-seguimiento.tt-codpro
                            tt-prov-alm-art.tt-codalm = ENTRY(lSec, lAlmacenes)
                            tt-prov-alm-art.tt-codmat = tt-prov-art.tt-codmat
                            tt-prov-alm-art.tt-stkact = lStkAct
                            tt-prov-alm-art.tt-costo = almmmatg.ctolis * lCambio
                            tt-prov-alm-art.tt-dias = lLibreC04
                            tt-prov-alm-art.tt-art-oc = tt-prov-art.tt-art-oc
                            tt-prov-alm-art.tt-desmat = almmmatg.desmat.

            END.
            */
        END.
        lDias2 = (IF (lDias1 > 0) THEN (lStkArt / lDias1) ELSE 0).
        lDias = lDias + lDias2.
        lPromPonderado = lPromPonderado + (lImpArt * lDias2).
    END.
    /* x Proveedor */
    tt-oc-seguimiento.tt-nro-dias = lPromPonderado / tt-oc-seguimiento.tt-stk-art-oc.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

