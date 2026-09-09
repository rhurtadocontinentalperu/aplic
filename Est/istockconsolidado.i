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

EMPTY TEMP-TABLE tt-DimProducto.

IF FILL-IN-filetxt <> "" THEN DO:
    FOR EACH tt-txt :
        FOR EACH estavtas.DimProducto NO-LOCK WHERE estavtas.DimProducto.codmat = tt-txt.codigo,
            FIRST {&Base}.Almmmatg NO-LOCK WHERE {&Base}.Almmmatg.codcia = s-codcia
            AND {&Base}.Almmmatg.codmat = estavtas.DimProducto.CodMat:

            CREATE tt-DimProducto.
                    BUFFER-COPY estavtas.DimProducto TO tt-DimProducto.

        END.
    END.
END.
ELSE DO:
    DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) IN FRAME {&FRAME-NAME} THEN DO:
            FOR EACH estavtas.DimProducto NO-LOCK WHERE estavtas.DimProducto.CodFam = estavtas.DimLinea.CodFam
                AND (FILL-IN-CodPro = "" OR estavtas.DimProducto.CodPro[1] = FILL-IN-CodPro),
                /*FIRST estavtas.DimSubLinea OF estavtas.DimProducto NO-LOCK,*/
                FIRST {&Base}.Almmmatg NO-LOCK WHERE {&Base}.Almmmatg.codcia = s-codcia
                AND {&Base}.Almmmatg.codmat = estavtas.DimProducto.CodMat:
                CREATE tt-DimProducto.
                BUFFER-COPY estavtas.DimProducto TO tt-DimProducto.
            END.
        END.
    END.
END.

FOR EACH tt-DimProducto,
    FIRST estavtas.DimSubLinea OF tt-DimProducto NO-LOCK,
    FIRST estavtas.DimLinea OF tt-DimProducto NO-LOCK,
    FIRST {&Base}.Almmmatg NO-LOCK WHERE {&Base}.Almmmatg.codcia = s-codcia
    AND {&Base}.Almmmatg.codmat = tt-DimProducto.CodMat:

    FOR EACH {&Base}.Almmmate NO-LOCK WHERE {&Base}.Almmmate.CodCia = s-codcia
        AND LOOKUP({&Base}.Almmmate.codalm, FILL-IN-CodAlm) > 0
        AND {&Base}.Almmmate.codmat = tt-DimProducto.CodMat
        AND (chkboxSoloConStock = NO OR {&Base}.Almmmate.stkact <> 0 ),
        FIRST {&Base}.Almacen OF {&Base}.Almmmate NO-LOCK WHERE {&Base}.Almacen.codalm <> '999':
    
        FIND FIRST {&Base}.almtabla WHERE {&Base}.almtabla.tabla = 'MK' 
            AND {&Base}.almtabla.codigo = {&Base}.Almmmatg.codmar NO-LOCK NO-ERROR.
    
        CREATE Detalle.
        ASSIGN
            Detalle.Compania = "{&Empresa}"
            Detalle.CodAlm  = {&Base}.Almmmate.codalm
            Detalle.Almacen = TRIM({&Base}.Almacen.CodAlm) + ' ' + {&Base}.Almacen.Descripcion
            Detalle.Producto = TRIM(tt-DimProducto.codmat) + ' ' + TRIM(tt-DimProducto.DesMat)
            Detalle.Linea = tt-DimProducto.codfam + ' ' + estavtas.DimLinea.NomFam
            Detalle.Sublinea = tt-DimProducto.subfam + ' ' + estavtas.DimSubLinea.NomSubFam 
            Detalle.Unidad = tt-DimProducto.undstk
            Detalle.StkAct = {&Base}.Almmmate.StkAct
            /* 23Jul2013 - Ic */
            Detalle.clasificacion = {&Base}.Almmmatg.tiprot[1]
            Detalle.iranking = {&Base}.Almmmatg.ordtmp
            Detalle.clsfutlx = {&Base}.Almmmatg.undalt[3]
            Detalle.rnkgutlx = {&Base}.Almmmatg.libre_d04
            Detalle.clsfmayo = {&Base}.Almmmatg.undalt[4]
            Detalle.rnkgmayo = {&Base}.Almmmatg.libre_d05
            /* Fin 23Jul2013 Ic */

            /* 11Dic2014 Ic */
            detalle.tpoart      = {&Base}.Almmmatg.tpoart
            detalle.almacenes   = {&Base}.Almmmatg.tpomrg
            detalle.catconta    = {&Base}.Almmmatg.catconta[1].
            /* Fin 11Dic2014 Ic */
        /* Proveedor */
        ASSIGN
            Detalle.Proveedor = TRIM(tt-DimProducto.CodPro[1]).
        FIND estavtas.DimProveedor WHERE estavtas.DimProveedor.CodPro = Detalle.Proveedor
            NO-LOCK NO-ERROR.
        IF AVAILABLE estavtas.DimProveedor THEN Detalle.Proveedor = Detalle.Proveedor + ' ' + TRIM(estavtas.DimProveedor.NomPro).
        /* Stock Comprometido */
        IF TOGGLE-Comprometido = YES THEN DO:
            {est/istockconsolidado-02.i &Base={&Base} }
            ASSIGN
                Detalle.Reservado = x-StockComprometido.
        END.
        /* Costo Reposicion */
        IF {&Base}.Almmmatg.monvta = 1 THEN
            ASSIGN
            Detalle.CostoMn = {&Base}.Almmmatg.CtoLis.
        ELSE 
            ASSIGN
            Detalle.CostoMn = {&Base}.Almmmatg.CtoLis * {&Base}.Almmmatg.TpoCmb.
        /* Costo Promedio */
        FIND LAST {&Base}.AlmStkge WHERE {&Base}.AlmStkge.CodCia = s-codcia
            AND {&Base}.AlmStkge.codmat = tt-DimProducto.codmat
            AND {&Base}.AlmStkge.Fecha <= TODAY 
            NO-LOCK NO-ERROR.
        IF AVAILABLE {&Base}.AlmStkge THEN Detalle.PromedioMn = {&Base}.AlmStkge.CtoUni.
        /* Información del Almacén */
        CASE {&Base}.Almacen.campo-c[2]:
            WHEN '1' THEN Detalle.TpoAlm = "Mayorista".
            WHEN '2' THEN Detalle.TpoAlm = "Minorista".
            OTHERWISE Detalle.TpoAlm = "No definido".
        END CASE.
        CASE {&Base}.Almacen.campo-c[3]:
            WHEN "Si" THEN Detalle.AlmRem = "Si".
            OTHERWISE Detalle.AlmRem = "No".
        END CASE.
        Detalle.AlmCom = {&Base}.Almacen.campo-c[6].
        Detalle.CodDiv = {&Base}.Almacen.coddiv.
        Detalle.StkMin = {&Base}.Almmmate.StkMin.
        Detalle.StkMax = {&Base}.Almmmate.StkMax.
        detalle.codmar = almmmatg.codmar.
        detalle.desmar = IF (AVAILABLE {&Base}.almtabla) THEN {&Base}.almtabla.nombre ELSE ''.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 3.42
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


