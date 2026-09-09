&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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
DEFINE SHARED VAR s-codcia AS INT.

DEFINE VAR lDivisiones AS CHAR.
DEFINE VAR lTotCotizaciones AS DEC.
DEFINE VAR txtDesde AS DATE.
DEFINE VAR txtHasta AS DATE.

DEFINE VAR txtFechaActual AS DATE. 
txtFechaActual = TODAY. /*  01/26/2014.  Fecha Current (today) - Simulado */

/*DEFINE TEMP-TABLE tt-ccbcdocu LIKE ccbcdocu.*/

DEFINE TEMP-TABLE tt-cabecera
        FIELDS tt-coddiv AS CHAR
        FIELDS tt-fproceso AS DATE
        FIELDS tt-totcotiz AS DEC
        FIELDS tt-ndias AS INT
        FIELDS tt-meta AS DEC
        FIELDS tt-fdesde AS DATE
        FIELDS tt-fhasta AS DATE
        FIELDS tt-div-vtas AS CHAR EXTENT 50
        FIELDS tt-ndivisiones AS INT
            INDEX idx01 IS PRIMARY tt-coddiv.

DEFINE TEMP-TABLE tt-detalle
        FIELDS tt-coddiv AS CHAR
        FIELDS tt-sec AS INT
        FIELDS tt-dia-sem AS INT
        FIELDS tt-fecha AS DATE
        FIELDS tt-div-imp AS DEC EXTENT 50
        FIELDS tt-tot-dia AS DEC
        FIELDS tt-tot-acu AS DEC
        FIELDS tt-meta-dia AS DEC
        FIELDS tt-por-ava AS DEC
            INDEX idx01 IS PRIMARY tt-coddiv tt-sec.

/* Parametros para el Calculo */
FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
      factabla.tabla = 'RV' AND factabla.codigo = 'RV0001' 
      NO-LOCK NO-ERROR.
IF NOT AVAILABLE factabla THEN DO:
    RETURN NO-APPLY.
END.

lDivisiones = "".
txtDesde = factabla.campo-d[1].
txtHasta = factabla.campo-d[2].

IF factabla.campo-c[1] <> "" THEN lDivisiones = "00015".
IF factabla.campo-c[2] <> "" THEN DO:
  IF lDivisiones = "" THEN DO:
      lDivisiones = "10015".
  END.
  ELSE lDivisiones = lDivisiones + ",10015".
END.
IF factabla.campo-c[3] <> "" THEN DO:
  IF lDivisiones = "" THEN DO:
      lDivisiones = "00017".
  END.
  ELSE lDivisiones = lDivisiones + ",00017".
END.
IF factabla.campo-c[4] <> "" THEN DO:
  IF lDivisiones = "" THEN DO:
      lDivisiones = "00018".
  END.
  ELSE lDivisiones = lDivisiones + ",00018".
END.
IF lDivisiones = "" THEN DO:
    RETURN NO-APPLY.
END.

IF txtDesde > txtHasta THEN DO:
    RETURN NO-APPLY.
END.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DISABLE TRIGGERS FOR LOAD OF vtatabla.

RUN ue-cotizaciones.
RUN ue-ventas.
RUN ue-totales.
RUN ue-grabar.
/**/
RUN ue-distribucion-global.
/*RUN ue-excel.*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ue-borrar-anteriores) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-borrar-anteriores Procedure 
PROCEDURE ue-borrar-anteriores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lRowId AS ROWID.

/*  */
EMPTY TEMP-TABLE tt-cabecera.
EMPTY TEMP-TABLE tt-detalle.

/* Los articulos por divisiones */
DEFINE BUFFER b-vtatabla FOR vtatabla.
FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'REPEXPO' NO-LOCK:
    lRowId = ROWID(vtatabla).
    FIND FIRST b-vtatabla WHERE ROWID(b-vtatabla) = lRowId EXCLUSIVE NO-ERROR.
    IF AVAILABLE b-vtatabla THEN DO:
        DELETE b-vtatabla.
    END.
END.

RELEASE b-vtatabla.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ue-cotizaciones) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-cotizaciones Procedure 
PROCEDURE ue-cotizaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lSec AS INT.
DEFINE VAR lSec1 AS INT.
DEFINE VAR lDia AS DATE.

DEFINE VAR lFechaX AS DATE.
DEFINE VAR lUbigeo AS CHAR.
DEFINE VAR lUbigeoX AS CHAR.

/*lFechaX = txtFechaActual + 6.   /* Adiciono una semana mas */*/

RUN ue-fecha-proyectada (INPUT txtFechaActual, OUTPUT lFechaX).

/* Limpio las Tablas */
RUN ue-borrar-anteriores.

/* Sumando las Cotizaciones que no esten anuladas */
FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia AND 
    faccpedi.coddoc = 'COT' AND 
    (faccpedi.fchped  >= txtDesde AND faccpedi.fchped <= txtHasta ) AND
    LOOKUP (faccpedi.coddiv,lDivisiones) > 0 AND
    (faccpedi.flgest <> 'A')
    NO-LOCK :

    FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND gn-clie.codcli = faccpedi.codcli NO-LOCK NO-ERROR.

    /* Ubigeo */
    lUbigeo = "".
    IF AVAILABLE gn-clie THEN DO:
        lUbigeo = IF (gn-clie.coddept = ? OR trim(gn-clie.coddept)="") THEN "XX" ELSE gn-clie.coddept.
        lUbigeo = lUbigeo + IF (gn-clie.codprov = ? OR trim(gn-clie.codprov)="") THEN "XX" ELSE gn-clie.codprov.
        lUbigeo = lUbigeo + IF (gn-clie.coddist = ? OR trim(gn-clie.coddist)="") THEN "XX" ELSE gn-clie.coddist.
    END.   
    lUbigeoX = REPLACE(lUbigeo,"X","").

    /* Detalle de las cotizaciones */
    FOR EACH facdpedi OF faccpedi NO-LOCK:
        lTotCotizaciones = lTotCotizaciones + facdpedi.implin.
        /*  Para las REPOSICIONES de mercaderias hay que 
            considerar aquellas cotizaciones que la fecha de entrega
            sea menos/igual al de la siguiente semana
        */
        IF faccpedi.fchent <= lFechaX THEN DO:
            /*   */
            FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia 
                AND vtatabla.tabla = 'REPEXPO' AND vtatabla.llave_c1 = facdpedi.codmat 
                AND vtatabla.llave_c2 = faccpedi.coddiv
                AND vtatabla.llave_c3 = lUbigeo EXCLUSIVE NO-ERROR.
            IF NOT AVAILABLE vtatabla THEN DO:
                /* Segun Ubigeo Ubico Almmacen */
                FIND FIRST ubigeo WHERE ubgCod = lUbigeo NO-LOCK NO-ERROR.
                /* CodArticulo + Division + Ubigeo */
                CREATE vtatabla.
                    ASSIGN vtatabla.codcia = s-codcia
                        vtatabla.tabla = 'REPEXPO'
                        vtatabla.llave_c1 = facdpedi.codmat
                        vtatabla.llave_c2 = faccpedi.coddiv
                        vtatabla.llave_c3 = lUbigeo
                        vtatabla.valor[1] = 0  /* Qty pedida */
                        vtatabla.valor[2] = 0  /* Qty atendida */
                        vtatabla.libre_c01 = IF(AVAILABLE ubigeo) THEN ubigeo.libre_c01 ELSE "NO-ALM".
                /* Canal Moderno/Provincias el almacen 21e - Lurin  */
                IF (faccpedi.coddiv = '00017' OR faccpedi.coddiv = '00018') THEN DO:
                    ASSIGN vtatabla.libre_c01 = '21e'.
                END.
                /* Si hay problemas con el Ubigeo x default le asignamos al 11e */
                IF vtatabla.libre_c01 = "" OR vtatabla.libre_c01 = ? THEN DO:
                    ASSIGN vtatabla.libre_c01 = '11e'.
                END.
            END.
            ASSIGN vtatabla.valor[1] = vtatabla.valor[1] + (facdpedi.canped * facdpedi.factor).

            /* Articulos */   
            FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia 
                AND vtatabla.tabla = 'REPEXPO' AND vtatabla.llave_c1 = 'DISTRIB'  
                AND vtatabla.llave_c2 = 'COTIZA' 
                AND vtatabla.llave_c3 = facdpedi.codmat EXCLUSIVE NO-ERROR.
            IF NOT AVAILABLE vtatabla THEN DO:
                /* CodArticulo */
                CREATE vtatabla.
                    ASSIGN vtatabla.codcia = s-codcia
                        vtatabla.tabla = 'REPEXPO'
                        vtatabla.llave_c1 = 'DISTRIB'
                        vtatabla.llave_c2 = 'COTIZA'
                        vtatabla.llave_c3 = facdpedi.codmat
                        vtatabla.valor[1] = 0  /* Qty pedida */
                        vtatabla.valor[2] = 0. /* Qty atendida */
            END.
            ASSIGN vtatabla.valor[1] = vtatabla.valor[1] + (facdpedi.canped * facdpedi.factor).
            
        END.
    END.

    /* Por el RESUMEN TOTAL */
    FIND FIRST tt-cabecera WHERE tt-cabecera.tt-coddiv = 'XXXXX' EXCLUSIVE NO-ERROR.
    IF NOT AVAILABLE tt-cabecera THEN DO:
        CREATE tt-cabecera.
            ASSIGN  tt-cabecera.tt-coddiv   = 'XXXXX'
                    tt-cabecera.tt-fproceso = txtFechaActual /* TODAY */
                    tt-cabecera.tt-ndias    = (txtHasta - txtDesde) + 1
                    tt-cabecera.tt-fdesde   = txtDesde
                    tt-cabecera.tt-fhasta   = txtHasta.
        REPEAT lSec = 1 TO 50 : 
            ASSIGN tt-div-vtas[lSec] = "".
        END.
    END.
    ASSIGN tt-cabecera.tt-totcotiz  = tt-cabecera.tt-totcotiz + faccpedi.imptot
            tt-cabecera.tt-meta     = (tt-cabecera.tt-totcotiz / tt-cabecera.tt-ndias).

    /* Por cada uno de las DIVISIONES */
    FIND FIRST tt-cabecera WHERE tt-cabecera.tt-coddiv = faccpedi.coddiv EXCLUSIVE NO-ERROR.
    IF NOT AVAILABLE tt-cabecera THEN DO:
        CREATE tt-cabecera.
            ASSIGN  tt-cabecera.tt-coddiv   = faccpedi.coddiv
                    tt-cabecera.tt-fproceso = txtFechaActual /*TODAY*/
                    tt-cabecera.tt-ndias    = (txtHasta - txtDesde) + 1
                    tt-cabecera.tt-fdesde   = txtDesde
                    tt-cabecera.tt-fhasta   = txtHasta.
        REPEAT lSec = 1 TO 50 : 
            ASSIGN tt-div-vtas[lSec] = "".
        END.
    END.
    ASSIGN tt-cabecera.tt-totcotiz  = tt-cabecera.tt-totcotiz + faccpedi.imptot
            tt-cabecera.tt-meta     = (tt-cabecera.tt-totcotiz / tt-cabecera.tt-ndias).
END.

/* El Detalle de las cabeceras */
FOR EACH tt-cabecera :
    /* Detalle */
    lSec =  0.
    REPEAT lDia = txtDesde TO txtHasta:
        lSec = lSec + 1.
        CREATE tt-detalle.
            ASSIGN  tt-detalle.tt-coddiv = tt-cabecera.tt-coddiv
                    tt-detalle.tt-sec = lSec
                    tt-detalle.tt-dia-sem = WEEKDAY(lDia)
                    tt-detalle.tt-fecha = lDia
                    tt-detalle.tt-tot-dia = 0 
                    tt-detalle.tt-tot-acu = 0
                    tt-detalle.tt-meta-dia = 0
                    tt-detalle.tt-por-ava = 0.

         lSec1 = 0.
         REPEAT lSec1 = 1 TO 50 : 
             ASSIGN tt-detalle.tt-div-imp[lSec1] = 0.
         END.       
    END.

END.



/*
/* Cabecera */
CREATE tt-cabecera.
    ASSIGN tt-fproceso = TODAY
            tt-totcotiz = lTotCotizaciones
            tt-ndias    = (txtHasta - txtDesde) + 1
            tt-cabecera.tt-meta     = (lTotCotizaciones / tt-ndias)
            tt-fdesde   = txtDesde
            tt-fhasta   = txtHasta.
REPEAT lSec = 1 TO 50 : 
    ASSIGN tt-div-vtas[lSec] = "".
END.


/* Detalle */
lSec =  0.
REPEAT lDia = txtDesde TO txtHasta:
    lSec = lSec + 1.
    CREATE tt-detalle.
        ASSIGN  tt-sec = lSec
                tt-dia-sem = WEEKDAY(lDia)
                tt-fecha = lDia
                tt-tot-dia = 0 
                tt-tot-acu = 0
                tt-meta-dia = 0
                tt-por-ava = 0.

        lSec1 = 0.
     REPEAT lSec1 = 1 TO 50 : 
         ASSIGN tt-div-imp[lSec1] = 0.
     END.       
END.
 */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ue-distribucion-global) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-distribucion-global Procedure 
PROCEDURE ue-distribucion-global :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR lgTotPed AS INT.
DEFINE VAR lgTotAte AS INT.
DEFINE VAR lProdPro AS CHAR.

DISABLE TRIGGERS FOR LOAD OF vtatabla.

DEFINE BUFFER b-vtatabla FOR vtatabla.
DEFINE BUFFER b-vtatabla2 FOR vtatabla.

FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = "REPEXPO" AND 
    vtatabla.llave_c1 <> 'DISTRIB' NO-LOCK :

    lgTotPed = lgTotPed + vtatabla.valor[1].
    lgTotAte = lgTotAte + vtatabla.valor[2].

    /* Busco si es Producto Propio */
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
        almmmatg.codmat = vtatabla.llave_c1 NO-LOCK NO-ERROR.
    lProdPro = IF (AVAILABLE almmmatg) THEN almmmatg.CHR__02 ELSE "P".

    /* GLOBAL */
    FIND FIRST b-vtatabla WHERE b-vtatabla.codcia = s-codcia AND 
            b-vtatabla.tabla = 'REPEXPO' AND
            b-vtatabla.llave_c1 = 'DISTRIB' AND 
            b-vtatabla.llave_c2 = 'GLOBAL' AND
            b-vtatabla.llave_c3 = 'GLOBAL' EXCLUSIVE NO-ERROR.
    IF NOT AVAILABLE b-vtatabla THEN DO:
        CREATE b-vtatabla.
            ASSIGN b-vtatabla.codcia = s-codcia
                b-vtatabla.tabla = 'REPEXPO'
                b-vtatabla.llave_c1 = 'DISTRIB'
                b-vtatabla.llave_c2 = 'GLOBAL'
                b-vtatabla.llave_c3 = 'GLOBAL'
                b-vtatabla.valor[1] = 0  /* Qty pedida */
                b-vtatabla.valor[2] = 0  /* Qty Atendida */
                b-vtatabla.valor[3] = 0. /* Qty x atender */
    END.
    ASSIGN b-vtatabla.valor[1] = b-vtatabla.valor[1] + vtatabla.valor[1]
            b-vtatabla.valor[2] = b-vtatabla.valor[2] + vtatabla.valor[2]
            /* x Atender */
            b-vtatabla.valor[3] = If(b-vtatabla.valor[1] - b-vtatabla.valor[2]) > 0 THEN
                                    b-vtatabla.valor[1] - b-vtatabla.valor[2] ELSE 0.

    /* PROPIOS / TERCEROS */
    FIND FIRST b-vtatabla WHERE b-vtatabla.codcia = s-codcia AND 
            b-vtatabla.tabla = 'REPEXPO' AND
            b-vtatabla.llave_c1 = 'DISTRIB' AND 
            b-vtatabla.llave_c2 = 'ORGPROD' AND
            b-vtatabla.llave_c3 = lProdPro EXCLUSIVE NO-ERROR.
    IF NOT AVAILABLE b-vtatabla THEN DO:
        CREATE b-vtatabla.
            ASSIGN b-vtatabla.codcia = s-codcia
                b-vtatabla.tabla = 'REPEXPO'
                b-vtatabla.llave_c1 = 'DISTRIB'
                b-vtatabla.llave_c2 = 'ORGPROD'
                b-vtatabla.llave_c3 = lProdPro
                b-vtatabla.valor[1] = 0  /* Qty pedida */
                b-vtatabla.valor[2] = 0  /* Qty Atendida */
                b-vtatabla.valor[3] = 0  /* Qty x atender */
                b-vtatabla.valor[4] = 0  /* Qty en Almacenes */
                b-vtatabla.valor[5] = 0. /* Qty x Producir/Comprar */
    END.
    ASSIGN b-vtatabla.valor[1] = b-vtatabla.valor[1] + vtatabla.valor[1]
            b-vtatabla.valor[2] = b-vtatabla.valor[2] + vtatabla.valor[2]
            /* x Atender */
            b-vtatabla.valor[3] = IF (b-vtatabla.valor[1] - b-vtatabla.valor[2] > 0) THEN 
                (b-vtatabla.valor[1] - b-vtatabla.valor[2]) ELSE 0.

    /**/
    FIND FIRST b-vtatabla2 WHERE b-vtatabla2.codcia = s-codcia AND 
            b-vtatabla2.tabla = 'REPEXPO' AND
            b-vtatabla2.llave_c1 = 'DISTRIB' AND 
            b-vtatabla2.llave_c2 = vtatabla.llave_c1 AND /* Articulo */
            b-vtatabla2.llave_c3 = vtatabla.libre_c01 EXCLUSIVE NO-ERROR. /* Almacen */
    IF NOT (AVAILABLE b-vtatabla2) THEN DO:
        CREATE b-vtatabla2.
            ASSIGN b-vtatabla2.codcia = s-codcia
                b-vtatabla2.tabla = 'REPEXPO'
                b-vtatabla2.llave_c1 = 'DISTRIB'
                b-vtatabla2.llave_c2 = vtatabla.llave_c1
                b-vtatabla2.llave_c3 = vtatabla.libre_c01
                b-vtatabla2.valor[1] = 0  /* Qty x Atender */
                b-vtatabla2.valor[2] = 0.  /* Stock en Almacen */
    END.
    ASSIGN b-vtatabla2.valor[1] = b-vtatabla2.valor[1] + (vtatabla.valor[1] - vtatabla.valor[2])
            b-vtatabla2.valor[1] = IF(b-vtatabla2.valor[1] < 1) THEN 0 ELSE b-vtatabla2.valor[1] .

    /*
    /* x Cada Articulo busco su Stock en Almacenes Comerciales */
    FOR EACH almacen WHERE almacen.codcia = s-codcia AND CAPS(almacen.campo-c[6]) = 'SI' NO-LOCK:        
        FIND LAST AlmStkAl WHERE almstkal.codcia = s-codcia AND 
            almstkal.codalm = almacen.codalm AND
            almstkal.codmat = vtatabla.llave_c1 AND  /* Articulo */
            almstkal.fecha <= txtFechaActual NO-LOCK NO-ERROR.
        IF AVAILABLE almstkal AND almstkal.stkact > 0 THEN DO:
            FIND FIRST b-vtatabla2 WHERE b-vtatabla2.codcia = s-codcia AND 
                    b-vtatabla2.tabla = 'REPEXPO' AND
                    b-vtatabla2.llave_c1 = 'DISTRIB' AND 
                    b-vtatabla2.llave_c2 = 'ALMA' AND
                    b-vtatabla2.llave_c3 = almacen.codalm EXCLUSIVE NO-ERROR.
            IF NOT AVAILABLE b-vtatabla2 THEN DO:
                CREATE b-vtatabla2.
                    ASSIGN b-vtatabla2.codcia = s-codcia
                        b-vtatabla2.tabla = 'REPEXPO'
                        b-vtatabla2.llave_c1 = 'DISTRIB'
                        b-vtatabla2.llave_c2 = 'ALMA'
                        b-vtatabla2.llave_c3 = almacen.codalm
                        b-vtatabla2.valor[1] = 0.  /* Qty Almacenada */
            END.
            b-vtatabla2.valor[1] = b-vtatabla2.valor[1] + almstkal.stkact.

            /* Stock en Almacen PROPIO/TERCEROS */
            b-vtatabla.valor[4] = b-vtatabla.valor[4] + almstkal.stkact.
            /* Por Producir o Comprar PROPIO/TERCEROS */
            b-vtatabla.valor[5] = IF (b-vtatabla.valor[3] - b-vtatabla.valor[4]) > 0 
                THEN (b-vtatabla.valor[3] - b-vtatabla.valor[4]) ELSE 0. 

        END.
    END.   
    */
END.
RELEASE vtatabla.
RELEASE b-vtatabla.
RELEASE b-vtatabla2.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ue-excel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-excel Procedure 
PROCEDURE ue-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE x-signo                 AS DECI.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = FALSE.

/* Para crear a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/*FIND FIRST tt-cabecera NO-LOCK NO-ERROR.*/

iColumn = 0.

FOR EACH tt-cabecera :    
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    cRange = "A"  + cColumn.
    chWorkSheet:Range(cRange):Value = "Division".
    cRange = "B"  + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-cabecera.tt-coddiv.
    
    cRange = "C"  + cColumn.
    chWorkSheet:Range(cRange):Value = "Total".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-totcotiz.

    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Dias".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-ndias.

    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Meta".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-meta.
    
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Sec".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Dia.Sem".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Dia".
    
    REPEAT iIndex = 1 TO tt-cabecera.tt-ndivisiones :
        cRange = CHR(67 + iIndex) + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-div-vtas[iIndex].
    END.
    
    cRange = CHR(67 + iIndex) + cColumn.
    chWorkSheet:Range(cRange):Value = "Total Dia".
    iIndex = iIndex + 1.
    cRange = CHR(67 + iIndex) + cColumn.
    chWorkSheet:Range(cRange):Value = "Total Acumulado".
    iIndex = iIndex + 1.
    cRange = CHR(67 + iIndex) + cColumn.
    chWorkSheet:Range(cRange):Value = "Meta".
    iIndex = iIndex + 1.
    cRange = CHR(67 + iIndex) + cColumn.
    chWorkSheet:Range(cRange):Value = "%".
    
    FOR EACH tt-detalle WHERE tt-detalle.tt-coddiv = tt-cabecera.tt-coddiv :
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
    
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):VALUE = tt-sec.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):VALUE = tt-dia-sem.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):VALUE = tt-fecha.
    
        REPEAT iIndex = 1 TO tt-cabecera.tt-ndivisiones :
            cRange = CHR(67 + iIndex) + cColumn.
            chWorkSheet:Range(cRange):Value = tt-div-imp[iIndex].
        END.
    
        cRange = CHR(67 + iIndex) + cColumn.
        chWorkSheet:Range(cRange):Value = tt-tot-dia.
        iIndex = iIndex + 1.
        cRange = CHR(67 + iIndex) + cColumn.
        chWorkSheet:Range(cRange):Value = tt-tot-acu.
        iIndex = iIndex + 1.
        cRange = CHR(67 + iIndex) + cColumn.
        chWorkSheet:Range(cRange):Value = tt-meta-dia.
        iIndex = iIndex + 1.
        cRange = CHR(67 + iIndex) + cColumn.
        chWorkSheet:Range(cRange):Value = tt-por-ava.
    END.
    iColumn = iColumn + 2.
END.
/*

/**/
iColumn = iColumn + 2.
cColumn = STRING(iColumn).

cRange = "A" + cColumn.
chWorkSheet:Range(cRange):VALUE = "Div.Origen".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):VALUE = "Division".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):VALUE = "Cod.Doc".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):VALUE = "Nro Dcto".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):VALUE = "Fecha Emision".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):VALUE = "Importe".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):VALUE = "Tipo Fac".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):VALUE = "CndCre.".

FOR EACH tt-ccbcdocu :
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "'" + tt-ccbcdocu.divori.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "'" + tt-ccbcdocu.coddiv.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "'" + tt-ccbcdocu.coddoc.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "'" + tt-ccbcdocu.nrodoc.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):VALUE = tt-ccbcdocu.fchdoc.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):VALUE = tt-ccbcdocu.imptot.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):VALUE = tt-ccbcdocu.tpofac.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):VALUE = tt-ccbcdocu.cndcre.
END.
*/
MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

/*chExcelApplication:Quit().*/
chExcelApplication:Visible = TRUE.


/* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR. 


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ue-fecha-proyectada) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-fecha-proyectada Procedure 
PROCEDURE ue-fecha-proyectada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pFechaInicio AS DATE.
DEFINE OUTPUT PARAMETER pFechaProyectada AS DATE.

DEFINE VAR lQtyDom AS INT.
DEFINE VAR lDia AS DATE.

lQtyDom = 0. /* Cuantos domingos paso */
DO lDia = pFechaInicio TO pFechaInicio + 20:
    pFechaProyectada = lDia.
    /* Es Domingo */
    IF WEEKDAY(lDia) = 1 THEN DO:
        lQtyDom = lQtyDom + 1.
    END.
    IF lQtyDom = 2 THEN DO:
        /* Ubico el siguiente 2do proximo Domingo */
        LEAVE.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ue-grabar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-grabar Procedure 
PROCEDURE ue-grabar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lSec AS INT.

FOR EACH RatioDet EXCLUSIVE :
    DELETE RatioDet.
END.
FOR EACH RatioCab EXCLUSIVE :
    DELETE RatioCab.
END.

FOR EACH tt-cabecera :
    CREATE RatioCab.
            ASSIGN  RatioCab.coddiv      = tt-cabecera.tt-coddiv
                    RatioCab.fproceso    = tt-cabecera.tt-fproceso
                    RatioCab.totcotiz    = tt-cabecera.tt-totcotiz
                    RatioCab.ndias       = tt-cabecera.tt-ndias
                    RatioCab.meta        = tt-cabecera.tt-meta
                    RatioCab.fdesde      = tt-cabecera.tt-fdesde
                    RatioCab.fhasta      = tt-cabecera.tt-fhasta                    
                    RatioCab.ndivisiones = tt-cabecera.tt-ndivisiones.

     DO lSec = 1 TO 50 :
         ASSIGN RatioCab.div-vtas[lsec]    = tt-cabecera.tt-div-vtas[lsec].
     END.
END.

FOR EACH tt-detalle :

    CREATE RatioDet.

            ASSIGN  RatioDet.Coddiv     = tt-detalle.tt-Coddiv
                    RatioDet.Sec        = tt-detalle.tt-Sec
                    RatioDet.Dia-sem    = tt-detalle.tt-Dia-sem
                    RatioDet.Fecha      = tt-detalle.tt-Fecha                    
                    RatioDet.tot-dia    = tt-detalle.tt-tot-dia
                    RatioDet.tot-acu    = tt-detalle.tt-tot-acu
                    RatioDet.meta-dia   = tt-detalle.tt-meta-dia
                    RatioDet.por-ava    = tt-detalle.tt-por-ava.
   DO lSec = 1 TO 50 :
       ASSIGN RatioDet.div-imp[lSec]    = tt-detalle.tt-div-imp[lSec].
   END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ue-totales) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-totales Procedure 
PROCEDURE ue-totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR iIndex AS INT.
DEFINE VAR lTotDia AS DEC.
DEFINE VAR lImpAnt AS DEC.
DEFINE VAR lAcuAnt AS DEC.

/*FIND FIRST tt-cabecera NO-LOCK NO-ERROR.*/

FOR EACH tt-cabecera NO-LOCK  :
    lImpAnt = 0.
    lAcuAnt = 0.
    
    FOR EACH tt-detalle WHERE tt-detalle.tt-coddiv = tt-cabecera.tt-coddiv EXCLUSIVE :
        REPEAT iIndex = 1 TO tt-cabecera.tt-ndivisiones :
            ASSIGN tt-tot-dia = tt-tot-dia + tt-div-imp[iIndex].
        END.
        ASSIGN tt-tot-acu = lImpAnt + tt-tot-dia
            tt-meta-dia = (tt-cabecera.tt-totcotiz - lAcuAnt) / (tt-cabecera.tt-ndias - (tt-sec - 1) ) 
            tt-por-ava = (tt-tot-acu / tt-cabecera.tt-totcotiz) * 100 .
        lImpAnt = lImpAnt + tt-tot-dia.
        lAcuAnt = tt-tot-acu.
    END.

END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ue-ventas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-ventas Procedure 
PROCEDURE ue-ventas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR lDiv-vtas AS CHAR.

DEFINE VAR ldiv-pos-dtl AS INT.
DEFINE VAR ldiv-pos-hdr AS INT.

DEFINE VAR lDiv-sec AS INT.
DEFINE VAR lSigno AS INT.
DEFINE VAR lDocOk AS LOG.
DEFINE VAR lTipoCamb AS DEC.
DEFINE VAR lSec AS INT.
DEFINE VAR lImpTotal AS DEC.
DEFINE VAR lFechaVenta AS DATE.
DEFINE VAR lUbigeo AS CHAR.

ldiv-sec = 0.
lDiv-vtas = "".

DEFINE BUFFER btt-detalle FOR tt-detalle.

FOR EACH tt-detalle WHERE tt-coddiv <> 'XXXXX' :
    
    lFechaVenta = IF (tt-detalle.tt-fecha <= txtFechaActual) THEN tt-detalle.tt-fecha ELSE 12/31/2099.

    FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
        (ccbcdocu.coddoc = 'TCK' OR ccbcdocu.coddoc = 'BOL' OR 
         ccbcdocu.coddoc = 'FAC' OR ccbcdocu.coddoc = 'N/C' OR
         ccbcdocu.coddoc = 'N/D') AND
        ccbcdocu.fchdoc = lFechaVenta  AND
        ccbcdocu.flgest <> 'A' AND 
        ccbcdocu.divori = tt-detalle.tt-coddiv :

        /* Excepciones */
        /* si la N/C es por PRONTO PAGO, GO EFECTIVO ETC*/
        IF (ccbcdocu.coddoc = 'N/C' AND ccbcdocu.cndcre = 'N') THEN NEXT. 
        /* Si la Factura es por Adelanto de Campaña o Servicio. */
        IF ccbcdocu.coddoc = 'FAC' AND (ccbcdocu.tpofac = 'A' OR ccbcdocu.tpofac = 'S') THEN NEXT.

        lSigno = 1.
        IF ccbcdocu.coddoc = 'N/C' THEN lSigno = -1.

        /* Ubico la division */
        /* ---------------- LA DIVISION PUNTUAL ---------------------------- */
        ldiv-pos-hdr = 0.
        ldiv-sec    = 0.
        FIND FIRST tt-cabecera WHERE tt-cabecera.tt-coddiv = tt-detalle.tt-coddiv NO-LOCK NO-ERROR.        
        REPEAT lSec = 1 TO 50 :
            /* Si es que la division existe */
            IF tt-cabecera.tt-div-vtas[lSec] = ccbcdocu.coddiv  THEN ldiv-pos-hdr = lSec.
            /* Cuantas divisiones existen */
            IF tt-cabecera.tt-div-vtas[lSec] <> "" THEN ldiv-sec = ldiv-sec + 1.
        END.

        IF lDiv-Pos-hdr = 0 THEN DO:
            /* Si no existe es nueva division, incremento */
            ldiv-sec = ldiv-sec + 1.
            lDiv-pos-hdr = ldiv-sec.
            /* Actualizo la cabecera la lista de las divisiones */
            ASSIGN tt-div-vtas[lDiv-pos-hdr] = TRIM(ccbcdocu.coddiv)
                    tt-ndivisiones = ldiv-sec .
        END.
        /* Acumulo Importes del detalle*/
        lDocOk = NO.

        FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND gn-clie.codcli = ccbcdocu.codcli NO-LOCK NO-ERROR.

        /* Ubigeo */
        lUbigeo = "".
        IF AVAILABLE gn-clie THEN DO:
            lUbigeo = IF (gn-clie.coddept = ? OR trim(gn-clie.coddept)="") THEN "XX" ELSE gn-clie.coddept.
            lUbigeo = lUbigeo + IF (gn-clie.codprov = ? OR trim(gn-clie.codprov)="") THEN "XX" ELSE gn-clie.codprov.
            lUbigeo = lUbigeo + IF (gn-clie.coddist = ? OR trim(gn-clie.coddist)="") THEN "XX" ELSE gn-clie.coddist.
        END.    

        lTipoCamb = 1.
        lImpTotal = 0.
        /* Tipo de Cambio */
        IF ccbcdocu.codmon <> 1 THEN lTipoCamb = ccbcdocu.tpocmb.
        /* Detalle de la Factura */
        FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
            /* Ventas en la Cabecera, segun division */
            ASSIGN tt-div-imp[lDiv-pos-hdr] = tt-div-imp[lDiv-pos-hdr] + ((ccbddocu.implin * lSigno) * lTipoCamb).

            lImpTotal = lImpTotal + ((ccbddocu.implin * lSigno) * lTipoCamb).
            lDocOk = YES.
            /* Los despachos de los articuloss  */
            FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia 
                AND vtatabla.tabla = 'REPEXPO' 
                AND vtatabla.llave_c1 = ccbddocu.codmat 
                AND vtatabla.llave_c2 = ccbcdocu.divori
                AND vtatabla.llave_c3 = lUbigeo EXCLUSIVE NO-ERROR.
            IF AVAILABLE vtatabla THEN DO:
                ASSIGN vtatabla.valor[2] = vtatabla.valor[2] + ((ccbddocu.candes * ccbddocu.factor) * lSigno).
            END.            
            /*  */
            FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia 
                AND vtatabla.tabla = 'REPEXPO' 
                AND vtatabla.llave_c1 =  'DISTRIB'
                AND vtatabla.llave_c2 = 'COTIZA'
                AND vtatabla.llave_c3 = ccbddocu.codmat EXCLUSIVE NO-ERROR.
            IF AVAILABLE vtatabla THEN DO:
                ASSIGN vtatabla.valor[2] = vtatabla.valor[2] + ((ccbddocu.candes * ccbddocu.factor)  * lSigno).
            END.
            
        END.
        /*
        IF lDocOk = YES THEN DO:
            CREATE tt-ccbcdocu.
            BUFFER-COPY Ccbcdocu TO tt-ccbcdocu.
        END.
        */
        /* ----------------------- POR EL ACUMULADO ---------------------------- */
        ldiv-pos-hdr = 0.
        ldiv-sec    = 0.
        FIND FIRST tt-cabecera WHERE tt-cabecera.tt-coddiv = 'XXXXX' NO-LOCK NO-ERROR.        
        REPEAT lSec = 1 TO 50 :
            IF tt-cabecera.tt-div-vtas[lSec] = ccbcdocu.coddiv  THEN ldiv-pos-hdr = lSec.
            IF tt-cabecera.tt-div-vtas[lSec] <> "" THEN ldiv-sec = ldiv-sec + 1.
        END.

        IF lDiv-Pos-hdr = 0 THEN DO:
            /* Si no existe */
            ldiv-sec = ldiv-sec + 1.
            lDiv-pos-hdr = ldiv-sec.
            /* Actualizo la cabecera la lista de las divisiones */
            ASSIGN tt-div-vtas[lDiv-pos-hdr] = TRIM(ccbcdocu.coddiv)
                    tt-ndivisiones = ldiv-sec .
        END.
        
        FIND FIRST btt-detalle WHERE btt-detalle.tt-coddiv = tt-cabecera.tt-coddiv AND 
            btt-detalle.tt-sec = tt-detalle.tt-sec EXCLUSIVE NO-ERROR.
            
        ASSIGN btt-detalle.tt-div-imp[lDiv-pos-hdr] = btt-detalle.tt-div-imp[lDiv-pos-hdr] + lImpTotal.

    END.
END.

RELEASE btt-detalle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

