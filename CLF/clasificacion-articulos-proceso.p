&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER NCREDITO FOR Ventas_Cabecera.
DEFINE TEMP-TABLE t-Ventas_Cabecera NO-UNDO LIKE Ventas_Cabecera.



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

DEFINE VAR iPeriodo AS INT NO-UNDO.
DEFINE VAR fDesde AS DATE NO-UNDO.
DEFINE VAR fHasta AS DATE NO-UNDO.

DEFINE VAR iAgrupador AS INT NO-UNDO.
DEFINE VAR cAgrupador AS CHAR NO-UNDO.
DEFINE VAR cDivisiones AS LONGCHAR NO-UNDO.

DEFINE VAR lMonedaSoles AS LOG NO-UNDO.
DEFINE VAR lIncluidoIGV AS LOG NO-UNDO.

DEFINE VAR lCrecimiento_ventas      AS LOG INIT NO NO-UNDO.
DEFINE VAR lCrecimiento_utilidad    AS LOG INIT NO NO-UNDO.
DEFINE VAR lCrecimiento_qty         AS LOG INIT NO NO-UNDO.
DEFINE VAR lCrecimiento_imp         AS LOG INIT NO NO-UNDO.

DEFINE VAR dFactorVentas            AS DEC INIT 0 NO-UNDO.
DEFINE VAR dFactorUtilidad          AS DEC INIT 0 NO-UNDO.
DEFINE VAR dFactorCantidad          AS DEC INIT 0 NO-UNDO.
DEFINE VAR dFactorImporte           AS DEC INIT 0 NO-UNDO.

DEFINE VAR iMaximoRegistrosParaProbar AS INT INIT 0 NO-UNDO.
DEFINE VAR cPeriodoDescripcion AS CHAR.
DEFINE VAR cCategoriasContables AS CHAR NO-UNDO.

DEFINE VAR lCampana AS LOG INIT NO NO-UNDO.     /* YES: Campaña   NO: No Campaña */

/* Tipo de Cáculo: por el momento tenemos 
Versión 27/8/2024
PV: Por Valor
PPM: Por Proporción del Mayor
*/
DEF VAR cTipo_Calculo AS CHAR NO-UNDO.

DEFINE VAR cDBname AS CHAR NO-UNDO.

lMonedaSoles = YES.
lIncluidoIGV = NO.
cAgrupador = "".
iPeriodo = -1.
iAgrupador = -1.
cDivisiones = "".
cDBname = "ContiProductivo".

iMaximoRegistrosParaProbar = 0. /* 15000.        0:Todos */

DEFINE TEMP-TABLE tvtas_cab NO-UNDO LIKE ventas_cabecera.
DEFINE TEMP-TABLE tvtas_det NO-UNDO LIKE ventas_detalle.
DEFINE TEMP-TABLE tvtas_cab_ant NO-UNDO LIKE ventas_cabecera.
DEFINE TEMP-TABLE tvtas_det_ant NO-UNDO LIKE ventas_detalle.

DEFINE TEMP-TABLE tclf_acumulador LIKE clf_acumulador
    FIELD descripcion AS CHAR FORMAT 'x(60)'.

DEFINE TEMP-TABLE tclf_calculo NO-UNDO
    FIELD codmat                    LIKE Clf_Temp_Calculos.codmat
    FIELD cdescripcion              LIKE Clf_Temp_Calculos.descripcion      
    FIELD cmarca                    LIKE Clf_Temp_Calculos.marca            
    FIELD cundstk                   LIKE Clf_Temp_Calculos.undstk   
    FIELD cCtgCtble                 LIKE Clf_Temp_Calculos.CtgCtble
    FIELD dventas                   LIKE Clf_Temp_Calculos.ventas           
    FIELD dutilidad                 LIKE Clf_Temp_Calculos.utilidad         
    FIELD dcantidad_act             LIKE Clf_Temp_Calculos.cantidad_act     
    FIELD dimporte_act              LIKE Clf_Temp_Calculos.importe_act      
    FIELD dcantidad_ant             LIKE Clf_Temp_Calculos.cantidad_ant     
    FIELD dimporte_ant              LIKE Clf_Temp_Calculos.importe_ant      
    FIELD dcantidad                 LIKE Clf_Temp_Calculos.cantidad         
    FIELD dimporte                  LIKE Clf_Temp_Calculos.importe          
    FIELD dpuntajeventas            LIKE Clf_Temp_Calculos.puntajeventas    
    FIELD dpuntajeutilidad          LIKE Clf_Temp_Calculos.puntajeutilidad  
    FIELD dpuntajecantidad          LIKE Clf_Temp_Calculos.puntajecantidad  
    FIELD dpuntajeimporte           LIKE Clf_Temp_Calculos.puntajeimporte   
    FIELD dsumapuntaje              LIKE Clf_Temp_Calculos.sumapuntaje      
    FIELD dpesoventas               LIKE Clf_Temp_Calculos.pesoventas       
    FIELD dpesoutilidad             LIKE Clf_Temp_Calculos.pesoutilidad     
    FIELD dpesocantidad             LIKE Clf_Temp_Calculos.pesocantidad     
    FIELD dpesoimporte              LIKE Clf_Temp_Calculos.pesoimporte      
    FIELD dpesoacumulado            LIKE Clf_Temp_Calculos.pesoacumulado    
    FIELD dpesopuntajefinal         LIKE Clf_Temp_Calculos.pesopuntajefinal 
    FIELD cclasificacion            LIKE Clf_Temp_Calculos.clasificacion    
    FIELD cOrigen                   LIKE Clf_Temp_Calculos.Origen           
    INDEX idx01 codmat
    INDEX idx02 dpesoacumulado DESC.

/* DEFINE TEMP-TABLE tclf_calculo                                                                */
/*     FIELD codmat    AS  CHAR    FORMAT 'x(8)' INIT ""                                         */
/*     FIELD cdescripcion AS CHAR    FORMAT 'x(100)' INIT ""                                     */
/*     FIELD cmarca AS CHAR    FORMAT 'x(50)' INIT ""                                            */
/*     FIELD cundstk AS CHAR    FORMAT 'x(10)' INIT ""                                           */
/*     FIELD dventas   AS  DEC     FORMAT '->>,>>>,>>>,>>9.9999' INIT 0 DECIMALS 4               */
/*     FIELD dutilidad   AS  DEC     FORMAT '->>,>>>,>>>,>>9.9999' INIT 0 DECIMALS 4             */
/*     FIELD dcantidad_act   AS  DEC     FORMAT '->>,>>>,>>>,>>9.9999' INIT 0 DECIMALS 4         */
/*     FIELD dimporte_act   AS  DEC     FORMAT '->>,>>>,>>>,>>9.9999' INIT 0 DECIMALS 4          */
/*     FIELD dcantidad_ant   AS  DEC     FORMAT '->>,>>>,>>>,>>9.9999' INIT 0 DECIMALS 4         */
/*     FIELD dimporte_ant   AS  DEC     FORMAT '->>,>>>,>>>,>>9.9999' INIT 0 DECIMALS 4          */
/*     FIELD dcantidad   AS  DEC     FORMAT '->>,>>>,>>>,>>9.9999' INIT 0 DECIMALS 4             */
/*     FIELD dimporte   AS  DEC     FORMAT '->>,>>>,>>>,>>9.9999' INIT 0 DECIMALS 4              */
/*     FIELD dpuntajeventas   AS  DEC     FORMAT '->>,>>>,>>>,>>9.999999' INIT 0 DECIMALS 6      */
/*     FIELD dpuntajeutilidad   AS  DEC     FORMAT '->>,>>>,>>>,>>9.999999' INIT 0 DECIMALS 6    */
/*     FIELD dpuntajecantidad   AS  DEC     FORMAT '->>,>>>,>>>,>>9.999999' INIT 0 DECIMALS 6    */
/*     FIELD dpuntajeimporte   AS  DEC     FORMAT '->>,>>>,>>>,>>9.999999' INIT 0 DECIMALS 6     */
/*     FIELD dsumapuntaje          AS  DEC     FORMAT '->>,>>>,>>>,>>9.999999' INIT 0 DECIMALS 6 */
/*     FIELD dpesoventas           AS  DEC     FORMAT '->>,>>>,>>>,>>9.999999' INIT 0 DECIMALS 6 */
/*     FIELD dpesoutilidad         AS  DEC     FORMAT '->>,>>>,>>>,>>9.999999' INIT 0 DECIMALS 6 */
/*     FIELD dpesocantidad         AS  DEC     FORMAT '->>,>>>,>>>,>>9.999999' INIT 0 DECIMALS 6 */
/*     FIELD dpesoimporte          AS  DEC     FORMAT '->>,>>>,>>>,>>9.999999' INIT 0 DECIMALS 6 */
/*     FIELD dpesoacumulado        AS  DEC     FORMAT '->>,>>>,>>>,>>9.999999' INIT 0 DECIMALS 6 */
/*     FIELD dpesopuntajefinal     AS  DEC     FORMAT '->>,>>>,>>>,>>9.999999' INIT 0 DECIMALS 6 */
/*     FIELD cclasificacion AS CHAR FORMAT 'x(5)'                                                */
/*     FIELD cOrigen AS CHAR FORMAT 'x(50)'                                                      */
/*     INDEX idx01 codmat                                                                        */
/*     INDEX idx02 dpesoacumulado DESC.                                                          */

DEFINE TEMP-TABLE tclf_calculo_art NO-UNDO
    FIELD codmat    AS  CHAR    FORMAT 'x(8)' INIT ""
    FIELD sipasa    AS  CHAR    FORMAT 'x(1)' INIT ""
    INDEX idx01 codmat.

DEFINE TEMP-TABLE tclf_calculo_ant NO-UNDO LIKE tclf_calculo .

/*

1.-
  ventas1 = suma de las ventas del periodo
  ordenamos de mayor a menor
  
  Ventas
  codmat    ImpVtas factor      factor1 peso
  00001     2000    2000/2000   1       1 * 0.50
  00002     1800    1800/2000   0.9     0.9 * 0.50
  00001     200     200/2000    0.1     0.1 * 0.50
  
  
  Utilidad        
  codmat    Utilidad    factor      factor1 peso
  00001     800         800/800     1       1 * 0.45
  00002     400         400/800     0.9     0.9 * 0.45
  00001     1500        150/800     0.1     0.1 * 0.45
  
  asi con Cantidad o Importe
    
2.-   
  Peso acumulado = ventas.peso + utilidad.peso + cantidad y/o importe
  
*/


DEFINE IMAGE IMAGE-1 FILENAME "IMG\Coti.ico" SIZE 12 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(60)" .

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
    SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT
    SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
    SKIP
    Fi-Mensaje NO-LABEL FONT 6
    SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
    BGCOLOR 15 FGCOLOR 0 
    TITLE "Procesando ..." FONT 7.


DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR iLatencia AS INTE INIT 10000 NO-UNDO.

/* 14/10/2024: Angie Quispe, configurable*/
DEF VAR x-Interval AS INTE INIT -3 NO-UNDO.
DEF VAR x-Units AS CHAR INIT 'months' NO-UNDO.

FIND FIRST Clf_Cfg_General NO-LOCK NO-ERROR.
IF AVAILABLE Clf_Cfg_General AND Clf_Cfg_General.New_Products_Interval-Amount > 0 THEN DO:
    x-Interval = -1 * Clf_Cfg_General.New_Products_Interval-Amount.
    x-Units = Clf_Cfg_General.New_Products_Interval-Unit.
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
   Temp-Tables and Buffers:
      TABLE: NCREDITO B "?" ? integral Ventas_Cabecera
      TABLE: t-Ventas_Cabecera T "?" NO-UNDO integral Ventas_Cabecera
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 13.54
         WIDTH              = 58.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Borra-Tablas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Tablas Procedure 
PROCEDURE Borra-Tablas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH Clf_Temp_Parameters EXCLUSIVE-LOCK 
        WHERE Clf_Temp_Parameters.Id_Agrupador = iAgrupador AND Clf_Temp_Parameters.Id_Periodo = iPeriodo
        ON ERROR UNDO, THROW:
        DELETE Clf_Temp_Parameters.
    END.
    FOR EACH Clf_Temp_Calculos EXCLUSIVE-LOCK 
        WHERE Clf_Temp_Calculos.Id_Agrupador = iAgrupador AND Clf_Temp_Calculos.Id_Periodo = iPeriodo
        ON ERROR UNDO, THROW:
        DELETE Clf_Temp_Calculos.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calcular_clasificacion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcular_clasificacion Procedure 
PROCEDURE calcular_clasificacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT    PARAMETER piPeriodo         AS INT NO-UNDO.        /* Clf_Periodos */
DEFINE INPUT    PARAMETER piAgrupador       AS INT NO-UNDO.      /* Clf_Agrupador */
DEFINE INPUT    PARAMETER plIncluyeIGV      AS LOG NO-UNDO.     /* NO: debe ser por defecto */
DEFINE INPUT    PARAMETER plMonedaSoles     AS LOG NO-UNDO.    /* YES: debe ser por defecto */
DEFINE OUTPUT   PARAMETER pcRetVal          AS CHAR NO-UNDO.

IF plIncluyeIGV = ?     THEN plIncluyeIGV = NO.
IF plMonedaSoles = ?    THEN plMonedaSoles = YES.

DEFINE VAR dSumaAcumuladores AS DEC NO-UNDO.

iPeriodo = piPeriodo.
iAgrupador = piAgrupador.
lIncluidoIGV = plIncluyeIGV.
lMonedaSoles = plMonedaSoles.

fDesde = ?.
fHasta = ?.
pcRetVal = "".
cAgrupador = "".

/* ******************************************************************************** */
/* Verificar procesos previos */
/* ******************************************************************************** */
IF CAN-FIND(FIRST Clf_Calc_Parameters WHERE Clf_Calc_Parameters.Id_Agrupador = piAgrupador AND
            Clf_Calc_Parameters.Id_Periodo = piPeriodo NO-LOCK)
    THEN DO:
    pcRetVal = "YA existe un cálculo aprobado" + CHR(10) + "Proceso abortado".
    RETURN 'ADM-ERROR'.
END.
IF CAN-FIND(FIRST Clf_Temp_Parameters WHERE Clf_Temp_Parameters.Id_Agrupador = piAgrupador
            AND Clf_Temp_Parameters.Id_Periodo = piPeriodo NO-LOCK)
    THEN DO:
    MESSAGE 'Ya existe un PRE-CALCULO realizado' SKIP
        'Desea repetir el proceso?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN.
END.

/* ******************************************************************************** */
/* Verificar acumuladores */
/* ******************************************************************************** */
RUN valida_acumuladores(OUTPUT pcRetVal).
IF NOT (TRUE <> (pcRetVal > "")) THEN DO:
    RETURN "ADM-ERROR".
END.
/* ******************************************************************************** */
/* Verificar Categorias contables */
/* ******************************************************************************** */
RUN categ_contable_consideradas(OUTPUT cCategoriasContables).
IF TRUE <> (cCategoriasContables > "") THEN DO:
    pcRetVal = "Debe configurar al menos una Categoría Contable a considerar".
    RETURN "ADM-ERROR".
END.
/* ******************************************************************************** */
/* Validar el periodo (campaña) */
/* ******************************************************************************** */
RUN valida_periodo(OUTPUT pcRetVal).
IF NOT (TRUE <> (pcRetVal > "")) THEN DO:
    RETURN "ADM-ERROR".
END.
/* ******************************************************************************** */
/* Validar agrupador */
/* ******************************************************************************** */
RUN valida_agrupador(OUTPUT pcRetVal).
IF NOT (TRUE <> (pcRetVal > "")) THEN DO:
    RETURN "ADM-ERROR".
END.
/* ******************************************************************************** */

/* Conectar a Base de datos productivo */
/* RUN conectar_dbproductivo.                                                      */
/* IF RETURN-VALUE = "ADM-ERROR" THEN DO:                                          */
/*     pcRetVal = "No se pudo conectar a la base de datos productivo Continental". */
/*     RETURN "ADM-ERROR".                                                         */
/* END.                                                                            */

/* ******************************************************************************** */
/* LOGICA PRINCIPAL */
/* ******************************************************************************** */
/* 1.- Primero borramos las tablas donde se va a alojar la información */
DISPLAY "BORRANDO TABLAS" @ Fi-Mensaje WITH FRAME F-Proceso. 
RUN Borra-Tablas.
HIDE FRAME F-Proceso.
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    pcRetVal = "NO se pudo limpiar las tablas donde se va a alojar los cálculos".
    RETURN 'ADM-ERROR'.
END.

/* 2.- Calculamos las Clasificaciones y almacenamos en la tabla temporal */
DISPLAY "CALCULANDO CLASIFICACIONES" @ Fi-Mensaje WITH FRAME F-Proceso.    
RUN calculo_procesar.
HIDE FRAME F-Proceso.

/* 3.- Grabamos la información en las tablas */
DISPLAY "GRABANDO EN TABLAS" @ Fi-Mensaje WITH FRAME F-Proceso.    
RUN Graba-Tablas.
HIDE FRAME F-Proceso.

/* DISPLAY "EXPORTANDO A EXCEL" @ Fi-Mensaje WITH FRAME F-Proceso.                  */
/* DEFINE VAR hProc AS HANDLE NO-UNDO.                                              */
/*                                                                                  */
/* RUN lib\Tools-to-excel PERSISTENT SET hProc.                                     */
/*                                                                                  */
/* def var c-csv-file as char no-undo.                                              */
/* def var c-xls-file as char no-undo. /* will contain the XLS file path created */ */
/*                                                                                  */
/* c-xls-file = 'd:\PruebaClasificacionArticulos_' + cPeriodoDescripcion + ".xlsx". */
/*                                                                                  */
/* run pi-crea-archivo-csv IN hProc (input  buffer tclf_calculo:handle,             */
/*                         /*input  session:temp-directory + "file"*/ c-xls-file,   */
/*                         output c-csv-file) .                                     */
/*                                                                                  */
/* run pi-crea-archivo-xls  IN hProc (input  buffer tclf_calculo:handle,            */
/*                         input  c-csv-file,                                       */
/*                         output c-xls-file) .                                     */
/*                                                                                  */
/* DELETE PROCEDURE hProc.                                                          */
/* HIDE FRAME F-Proceso.                                                            */

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calculo_acumuladores) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculo_acumuladores Procedure 
PROCEDURE calculo_acumuladores :
/*------------------------------------------------------------------------------
  Purpose:     Acumula los valores netos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR dImpVentas AS DEC NO-UNDO.
DEFINE VAR dImpMargen AS DEC NO-UNDO.
DEFINE VAR dQtyCrecimiento AS DEC NO-UNDO.
DEFINE VAR dImpCrecimiento AS DEC NO-UNDO.

RUN lib/p-write-log-txt.r("Clasificacion Articulos","Calcula acumuladores - Periodo Actual").

DEF VAR iContador AS INTE INIT 0 NO-UNDO.

/* Periodo ACTUAL */
FOR EACH tvtas_det NO-LOCK:
    dQtyCrecimiento = 0.
    dImpCrecimiento = 0.
    IF lMonedaSoles THEN DO:
        dImpVentas = IF (lIncluidoIgv) THEN tvtas_det.impnaccigv ELSE tvtas_det.impnacsigv.
        dImpMargen = IF (lIncluidoIgv) THEN tvtas_det.promnaccigv ELSE tvtas_det.promnacsigv.        
    END.
    ELSE DO:
        dImpVentas = IF (lIncluidoIgv) THEN tvtas_det.impextcigv ELSE tvtas_det.impextsigv.
        dImpMargen = IF (lIncluidoIgv) THEN tvtas_det.promextcigv ELSE tvtas_det.promextsigv.
    END.
    dImpMargen = dImpVentas - dImpMargen.
    /**/
    IF lCrecimiento_qty THEN DO:
        dQtyCrecimiento = tvtas_det.cantidad.
    END.
    IF lCrecimiento_imp THEN DO:
        dImpCrecimiento = dImpVentas.
    END.
    /**/
    IF iContador MODULO iLatencia = 0
        THEN DISPLAY "Calcula ACUMULADORES PERIODO ACTUAL " + tvtas_det.codmat @ Fi-Mensaje WITH FRAME F-Proceso.
    iContador = iContador + 1.

    FIND FIRST tclf_calculo WHERE tclf_calculo.codmat = tvtas_det.codmat EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE tclf_calculo THEN DO:
        CREATE tclf_calculo.
        ASSIGN 
            tclf_calculo.codmat = tvtas_det.codmat
            tclf_calculo.cOrigen = "PERIODO ACTUAL".
    END.
    /* Importes/Cantidades */
    ASSIGN 
        tclf_calculo.dventas = tclf_calculo.dventas + dImpVentas
        tclf_calculo.dutilidad = tclf_calculo.dutilidad + dImpMargen
        tclf_calculo.dcantidad_act = tclf_calculo.dcantidad_act + dQtyCrecimiento
        tclf_calculo.dimporte_act = tclf_calculo.dimporte_act + dImpCrecimiento.
END.
HIDE FRAME F-Proceso.

RUN lib/p-write-log-txt.r("Clasificacion Articulos","Calcula acumuladores - Periodo Anterior").
/* Periodo ANTERIOR */
iContador = 0.
FOR EACH tvtas_det_ant NO-LOCK:
    dQtyCrecimiento = 0.
    dImpCrecimiento = 0.
    IF lCrecimiento_imp THEN DO:
        IF lMonedaSoles THEN DO:
            dImpCrecimiento = IF (lIncluidoIgv) THEN tvtas_det_ant.impnaccigv ELSE tvtas_det_ant.impnacsigv.
        END.
        ELSE DO:
            dImpCrecimiento = IF (lIncluidoIgv) THEN tvtas_det_ant.impextcigv ELSE tvtas_det_ant.impextsigv.
        END.
    END.
    /**/
    IF lCrecimiento_qty THEN DO:
        dQtyCrecimiento = tvtas_det_ant.cantidad.
    END.
    /**/

    IF dQtyCrecimiento = 0 AND dImpCrecimiento = 0  THEN NEXT.
    IF iContador MODULO iLatencia = 0
        THEN DISPLAY "Calcula ACUMULADORES PERIODO ANTERIOR " + tvtas_det_ant.codmat @ Fi-Mensaje WITH FRAME F-Proceso.
    iContador = iContador + 1.

    FIND FIRST tclf_calculo WHERE tclf_calculo.codmat = tvtas_det_ant.codmat EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE tclf_calculo THEN DO:
        CREATE tclf_calculo.
        ASSIGN 
            tclf_calculo.codmat = tvtas_det_ant.codmat
            tclf_calculo.cOrigen = "PERIODO ANTERIOR".
    END.
    /* Importes/Cantidades */
    ASSIGN  
        tclf_calculo.dcantidad_ant = tclf_calculo.dcantidad_ant + dQtyCrecimiento
        tclf_calculo.dimporte_ant = tclf_calculo.dimporte_ant + dImpCrecimiento.
END.
HIDE FRAME F-Proceso.
RUN lib/p-write-log-txt.r("Clasificacion Articulos","Calcula acumuladores - TERMINO").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calculo_clasificacion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculo_clasificacion Procedure 
PROCEDURE calculo_clasificacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR iNroClasificaciones AS INT INIT 0 NO-UNDO.
DEFINE VAR iSec AS INT INIT 0 NO-UNDO.

RUN lib/p-write-log-txt.r("Clasificacion Articulos","Calcula clasificacion - ordenando valores").
FOR EACH clf_Clasificaciones NO-LOCK:
    iNroClasificaciones = iNroClasificaciones + 1.
END.

DEFINE VAR dClasificacionValor AS DECIMAL EXTENT.
DEFINE VAR cClasificacionValor AS CHAR EXTENT.
EXTENT(dClasificacionValor) =  iNroClasificaciones.
EXTENT(cClasificacionValor) =  iNroClasificaciones.

iNroClasificaciones = 0.
IF lCampana = YES THEN DO:      /* CAMPAÑA */
    FOR EACH clf_Clasificaciones NO-LOCK BY Valor_Campana:
        iNroClasificaciones = iNroClasificaciones + 1.
        dClasificacionValor[iNroClasificaciones] = clf_Clasificaciones.Valor_Campana.
        cClasificacionValor[iNroClasificaciones] = clf_Clasificaciones.codigo.
    END.
END.
ELSE DO:                        /* NO CAMPAÑA */
    FOR EACH clf_Clasificaciones NO-LOCK BY Valor_No_Campana:
        iNroClasificaciones = iNroClasificaciones + 1.
        dClasificacionValor[iNroClasificaciones] = clf_Clasificaciones.Valor_No_Campana.
        cClasificacionValor[iNroClasificaciones] = clf_Clasificaciones.codigo.
    END.
END.

DEFINE VAR dValorInicial AS DEC.
DEFINE VAR cClasificacion AS CHAR.

RUN lib/p-write-log-txt.r("Clasificacion Articulos","Calcula clasificacion - calculando").
DEF VAR iContador AS INTE INIT 0 NO-UNDO.
FOR EACH tclf_calculo:
    IF iContador MODULO iLatencia = 0
        THEN DISPLAY "Calcula CLASIFICACION " + tclf_calculo.codmat @ Fi-Mensaje WITH FRAME F-Proceso.
    iContador = iContador + 1.
    cClasificacion = "X".
    dValorInicial = 0.
    BUSCAR:
    REPEAT iSec = 1 TO iNroClasificaciones:
        IF tclf_calculo.dpesopuntajefinal > dValorInicial AND tclf_calculo.dpesopuntajefinal <= dClasificacionValor[iSec] THEN DO:
            cClasificacion = cClasificacionValor[iSec].
            LEAVE BUSCAR.
        END.
    END.
    ASSIGN tclf_calculo.cClasificacion = cClasificacion.
    /* */
END.
HIDE FRAME F-Proceso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calculo_peso) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculo_peso Procedure 
PROCEDURE calculo_peso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR fTotalVentas AS DEC.
DEFINE VAR fTotalUtilidad AS DEC.
DEFINE VAR fTotalCantidad AS DEC.
DEFINE VAR fTotalImporte AS DEC.

DEFINE VAR fSumaPuntajes LIKE tclf_calculo.dsumapuntaje NO-UNDO.
DEFINE VAR fValorAnterior AS DEC.

RUN lib/p-write-log-txt.r("Clasificacion Articulos","Calcula pesos - calcular puntajes y totalizar").
DEF VAR iContador AS INTE INIT 0 NO-UNDO.

/* Calculamos los "delta" */
/* El valor es un factor en base al periodo anterior */
FOR EACH tclf_calculo EXCLUSIVE-LOCK:
    ASSIGN
        tclf_calculo.dcantidad = 0
        tclf_calculo.dimporte = 0.
    CASE TRUE:
        WHEN tclf_calculo.dcantidad_act > 0 AND tclf_calculo.dcantidad_ant < 0 THEN DO:
            tclf_calculo.dcantidad = 1.
        END.
        WHEN tclf_calculo.dcantidad_ant = 0 THEN DO:
            tclf_calculo.dcantidad = 0.
        END.
        OTHERWISE DO:
            tclf_calculo.dcantidad = (tclf_calculo.dcantidad_act - tclf_calculo.dcantidad_ant) / ABS(tclf_calculo.dcantidad_ant).
        END.
    END CASE.
    CASE TRUE:
        WHEN tclf_calculo.dimporte_act > 0 AND tclf_calculo.dimporte_ant < 0 THEN DO:
            tclf_calculo.dimporte = 1.
        END.
        WHEN tclf_calculo.dimporte_ant = 0 THEN DO:
            tclf_calculo.dimporte = 0 .
        END.
        OTHERWISE DO:
            tclf_calculo.dimporte = (tclf_calculo.dimporte_act - tclf_calculo.dimporte_ant) / ABS(tclf_calculo.dimporte_ant).
        END.
    END CASE.
END.
RELEASE tclf_calculo.

DEF VAR fValorMaximoVentas AS DECI NO-UNDO.
DEF VAR fValorMaximoUtilidad AS DECI NO-UNDO.
DEF VAR fValorMaximoDeltaQty AS DECI NO-UNDO.
DEF VAR fValorMaximoDeltaImp AS DECI NO-UNDO.

IF cTipo_Calculo = "PPM" THEN DO:
    /* 1) Calculamos el peso de acuerdo al valor mayor por cada concepto:
            ventas, utilidad, cantidad y puntaje
            */
    /* Por ventas */
    fValorMaximoVentas = 0.
    FOR EACH tclf_calculo NO-LOCK BY tclf_calculo.dVentas DESC:
        fValorMaximoVentas = tclf_calculo.dventas.
        LEAVE.
    END.
    /* Por Utilidad */
    fValorMaximoUtilidad = 0.
    FOR EACH tclf_calculo NO-LOCK BY tclf_calculo.dUtilidad DESC:
        fValorMaximoUtilidad = tclf_calculo.dutilidad.
        LEAVE.
    END.
    /* Por Crecimiento Cantidad */
    fValorMaximoDeltaQty = 0.
    FOR EACH tclf_calculo NO-LOCK BY tclf_calculo.dCantidad DESC:
        fValorMaximoDeltaQty = tclf_calculo.dCantidad.
        LEAVE.
    END.
    /* Por Crecimiento Importe */
    fValorMaximoDeltaImp = 0.
    FOR EACH tclf_calculo NO-LOCK BY tclf_calculo.dImporte DESC:
        fValorMaximoDeltaImp = tclf_calculo.dImporte.
        LEAVE.
    END.
END.

FOR EACH tclf_calculo EXCLUSIVE-LOCK:
    IF iContador MODULO iLatencia = 0
        THEN DISPLAY "Calcula pesos - calcular puntajes y totalizar " + tclf_calculo.codmat @ Fi-Mensaje WITH FRAME F-Proceso.
    iContador = iContador + 1.
    CASE cTipo_Calculo:
        WHEN "PV" THEN DO:
            /* POR VALOR: tal como viene */
            ASSIGN  
                tclf_calculo.dpuntajeventas     = tclf_calculo.dventas 
                tclf_calculo.dpuntajeutilidad   = tclf_calculo.dutilidad
                tclf_calculo.dpuntajecantidad   = tclf_calculo.dcantidad
                tclf_calculo.dpuntajeimporte    = tclf_calculo.dimporte.
            ASSIGN
                tclf_calculo.dsumapuntaje       = ROUND(
                                                    (tclf_calculo.dpuntajeventas * dFactorVentas) + 
                                                    (tclf_calculo.dpuntajeutilidad * dFactorUtilidad) + 
                                                    (tclf_calculo.dpuntajecantidad * dFactorCantidad) + 
                                                    (tclf_calculo.dpuntajeimporte * dFactorImporte)
                                                    , 6).
        END.
        WHEN "PPM" THEN DO:
            /* POR PROPORCION DEL MAYOR: Sin afectarlo por el peso de cada columna */
            IF fValorMaximoVentas > 0   THEN tclf_calculo.dpuntajeventas    = (tclf_calculo.dventas / fValorMaximoVentas).
            IF fValorMaximoUtilidad > 0 THEN tclf_calculo.dpuntajeutilidad  = (tclf_calculo.dutilidad / fValorMaximoUtilidad).
            IF fValorMaximoDeltaQty > 0 THEN tclf_calculo.dpuntajecantidad  = (tclf_calculo.dcantidad / fValorMaximoDeltaQty).
            IF fValorMaximoDeltaImp > 0 THEN tclf_calculo.dpuntajeimporte   = (tclf_calculo.dimporte / fValorMaximoDeltaImp).
            /* EL ACUMULADO: Ahora sí afectado por el peso de cada columna */
            ASSIGN
                tclf_calculo.dsumapuntaje = ROUND(
                                            (tclf_calculo.dpuntajeventas   * dFactorVentas)   + 
                                            (tclf_calculo.dpuntajeutilidad * dFactorUtilidad) + 
                                            (tclf_calculo.dpuntajecantidad * dFactorCantidad) + 
                                            (tclf_calculo.dpuntajeimporte  * dFactorImporte)
                                            , 6).
        END.
    END CASE.
    ASSIGN
        fSumaPuntajes = fSumaPuntajes + tclf_calculo.dsumapuntaje.
END.
RELEASE tclf_calculo.
HIDE FRAME F-Proceso.

RUN lib/p-write-log-txt.r("Clasificacion Articulos","Calcula pesos - calcular peso x articulo").
iContador = 0.

FOR EACH tclf_calculo EXCLUSIVE-LOCK:
    IF iContador MODULO iLatencia = 0 THEN DISPLAY "Calcula pesos - calcular peso x articulo " + tclf_calculo.codmat @ Fi-Mensaje WITH FRAME F-Proceso.
    iContador = iContador + 1.

    IF fSumaPuntajes > 0 THEN ASSIGN tclf_calculo.dpesoacumulado = tclf_calculo.dsumapuntaje / fSumaPuntajes.

END.
RELEASE tclf_calculo.
HIDE FRAME F-Proceso.

fValorAnterior = 0.
iContador = 0.
/* 1) Solo se toman los valores de dPesoAcumulado >= 0 */
/* ORDENADO POR: 
    1.- dPesoAcumulado DESCENDENTE 
    2.- CodMat ASCENDENTE 
*/    
FOR EACH tclf_calculo EXCLUSIVE-LOCK WHERE tclf_calculo.dpesoacumulado >= 0 BY tclf_calculo.dpesoacumulado DESC BY tclf_calculo.codmat:
    IF iContador MODULO iLatencia = 0 THEN DISPLAY "Calcula pesos - puntaje final " + tclf_calculo.codmat @ Fi-Mensaje WITH FRAME F-Proceso.

    iContador = iContador + 1.
    IF iContador = 1 
        THEN ASSIGN tclf_calculo.dpesopuntajefinal = tclf_calculo.dpesoacumulado.
        ELSE ASSIGN tclf_calculo.dpesopuntajefinal = tclf_calculo.dpesoacumulado + fValorAnterior.

    /* Si supera 1 (100%) entonces es 1 (100%) */
    IF tclf_calculo.dpesopuntajefinal > 1 THEN ASSIGN tclf_calculo.dpesopuntajefinal = 1.
    fValorAnterior = tclf_calculo.dpesopuntajefinal.

END.
RELEASE tclf_calculo.
HIDE FRAME F-Proceso.
/* 2) Solo se toman los valores de dPesoAcumulado < 0 */
FOR EACH tclf_calculo EXCLUSIVE-LOCK WHERE tclf_calculo.dpesoacumulado < 0:
    IF iContador MODULO iLatencia = 0
        THEN DISPLAY "Calcula pesos - puntaje final " + tclf_calculo.codmat @ Fi-Mensaje WITH FRAME F-Proceso.
    iContador = iContador + 1.
    ASSIGN 
        tclf_calculo.dpesopuntajefinal = 1.     /* Valor Tope 1 (100%) */
END.
RELEASE tclf_calculo.
HIDE FRAME F-Proceso.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calculo_procesar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculo_procesar Procedure 
PROCEDURE calculo_procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR fDesdeAnt AS DATE NO-UNDO.
DEFINE VAR fHastaAnt AS DATE NO-UNDO.

RUN lib/p-write-log-txt.r("Clasificacion Articulos","INICIO").

IF lCrecimiento_ventas = YES OR lCrecimiento_utilidad = YES OR lCrecimiento_Qty = YES OR lCrecimiento_Imp = YES THEN DO:
    /* VENTAS */
    /* Carga tabla tvtas_det con Data del periodo actual */
    RUN lib/p-write-log-txt.r("Clasificacion Articulos","Data ventas periodo ACTUAL").  
    RUN extrae_ventas(fDesde, fHasta, YES).

    /* Carga tabla tvtas_det_ant con Data del periodo anterior */
    RUN lib/p-write-log-txt.r("Clasificacion Articulos","Data ventas periodo ANTERIOR").
    fDesdeAnt = ADD-INTERVAL(fDesde,-1,'year').
    fHastaAnt = ADD-INTERVAL(fHasta,-1,'year').
    RUN extrae_ventas(fDesdeAnt, fHastaAnt, NO).

    /* ACUMULADORES */
    /* Carga la table tclf_calculo con los valores netos (en soles y/o cantidades) */
    RUN lib/p-write-log-txt.r("Clasificacion Articulos","Calcula ACUMULADORES").
    RUN calculo_acumuladores.
END.

RUN lib/p-write-log-txt.r("Clasificacion Articulos","Calcula PESOS").
RUN calculo_peso.

RUN lib/p-write-log-txt.r("Clasificacion Articulos","Calcula CLASIFICACION").
RUN calculo_clasificacion.

RUN lib/p-write-log-txt.r("Clasificacion Articulos","PRODUCTOS SIN VENTAS").
RUN calculo_productos_sin_ventas.

/* IF CONNECTED(cDBname) THEN DISCONNECT VALUE(cDBname) NO-ERROR. */

RUN lib/p-write-log-txt.r("Clasificacion Articulos","FIN").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calculo_productos_sin_ventas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculo_productos_sin_ventas Procedure 
PROCEDURE calculo_productos_sin_ventas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR cDescrip AS CHAR.
DEFINE VAR cDesmar AS CHAR.
DEFINE VAR cCtgCtble AS CHAR.

RUN lib/p-write-log-txt.r("Clasificacion Articulos","Productos sin ventas - descripcion articulos").
FOR EACH tclf_calculo EXCLUSIVE-LOCK:
    /* */
    FIND FIRST DimProducto WHERE DimProducto.codmat = tclf_calculo.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE DimProducto THEN DO:
        RUN lib/limpiar-texto.r(DimProducto.desmat," ",OUTPUT cDescrip).
        RUN lib/limpiar-texto.r(DimProducto.desmar," ",OUTPUT cDesmar).

        ASSIGN 
            tclf_calculo.cdescripcion = replace(replace(REPLACE(cDescrip,";"," "),'"',' '),"'"," ")
            tclf_calculo.cmarca = replace(replace(REPLACE(cDesmar,";"," "),'"',' '),"'"," ")
            tclf_calculo.cundstk = DimProducto.undstk
            tclf_calculo.cCtgCtble = DimProducto.CtgCtble
            .
    END.
END.

RUN lib/p-write-log-txt.r("Clasificacion Articulos","Productos sin ventas - inexistentes").
DEF VAR iContador AS INTE INIT 0 NO-UNDO.
FOR EACH DimProducto NO-LOCK:
    IF DimProducto.tpoart <> 'A' THEN NEXT.
    cCtgCtble = DimProducto.CtgCtble.

    /* Aqui se validará las categorias contables ????????????????? */
    IF LOOKUP(cCtgCtble,cCategoriasContables) = 0 THEN NEXT.

    FIND FIRST tclf_calculo WHERE DimProducto.codmat = tclf_calculo.codmat NO-LOCK NO-ERROR.
    IF NOT AVAILABLE tclf_calculo THEN DO:
        IF iContador MODULO iLatencia = 0
            THEN DISPLAY "PRODUCTOS SIN VENTAS " + DimProducto.codmat @ Fi-Mensaje WITH FRAME F-Proceso.
        iContador = iContador + 1.


        CREATE tclf_calculo.
        ASSIGN 
            tclf_calculo.codmat = DimProducto.codmat
            tclf_calculo.cOrigen = "SIN VENTAS"
            tclf_calculo.cClasificacion = "F".

        RUN lib/limpiar-texto.r(DimProducto.desmat," ",OUTPUT cDescrip).
        RUN lib/limpiar-texto.r(DimProducto.desmar," ",OUTPUT cDesmar).

        ASSIGN 
            tclf_calculo.cdescripcion = replace(replace(REPLACE(cDescrip,";"," "),'"',' '),"'"," ")
            tclf_calculo.cmarca = replace(replace(REPLACE(cDesmar,";"," "),'"',' '),"'"," ")
            tclf_calculo.cundstk = DimProducto.undstk
            tclf_calculo.cCtgCtble = DimProducto.CtgCtble
            .
    END.
END.
HIDE FRAME F-Proceso.

/* 14/10/2024: Angie Quispe, configurable*/
FOR EACH DimProducto NO-LOCK WHERE DimProducto.FchIng >= ADD-INTERVAL(TODAY,x-Interval,x-Units):
    IF DimProducto.tpoart <> 'A' THEN NEXT.
    IF DimProducto.FchIng = ? THEN NEXT.
    cCtgCtble = DimProducto.CtgCtble.

    /* Aqui se validará las categorias contables ????????????????? */
    IF LOOKUP(cCtgCtble,cCategoriasContables) = 0 THEN NEXT.

    DISPLAY "PRODUCTOS NUEVOS " + DimProducto.codmat @ Fi-Mensaje WITH FRAME F-Proceso.
    FIND FIRST tclf_calculo WHERE DimProducto.codmat = tclf_calculo.codmat EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE tclf_calculo THEN DO:
        CREATE tclf_calculo.
        ASSIGN 
            tclf_calculo.codmat = DimProducto.codmat.

        RUN lib/limpiar-texto.r(DimProducto.desmat," ",OUTPUT cDescrip).
        RUN lib/limpiar-texto.r(DimProducto.desmar," ",OUTPUT cDesmar).
        ASSIGN
            tclf_calculo.cdescripcion = replace(replace(REPLACE(cDescrip,";"," "),'"',' '),"'"," ")
            tclf_calculo.cmarca = replace(replace(REPLACE(cDesmar,";"," "),'"',' '),"'"," ")
            tclf_calculo.cundstk = DimProducto.undstk
            tclf_calculo.cCtgCtble = DimProducto.CtgCtble
            .
    END.
    ASSIGN 
        tclf_calculo.cOrigen = "NUEVO"
        tclf_calculo.cClasificacion = "N".
END.
HIDE FRAME F-Proceso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-categ_contable_consideradas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE categ_contable_consideradas Procedure 
PROCEDURE categ_contable_consideradas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER xCategoriasContables AS CHAR NO-UNDO.

xCategoriasContables = "".
FOR EACH DimClfCatContable NO-LOCK:
    IF NOT (TRUE <> (xCategoriasContables > "")) THEN xCategoriasContables = xCategoriasContables + ",".
    xCategoriasContables = xCategoriasContables + DimClfCatContable.codigo.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-conectar_dbproductivo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE conectar_dbproductivo Procedure 
PROCEDURE conectar_dbproductivo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* IF NOT CONNECTED(cDBname) THEN DO:                                                 */
/*     DEFINE VAR cStrConnect AS CHAR.                                                */
/*                                                                                    */
/*     cStrConnect = "-db integral -ld " + cDBname + " -H 192.168.100.210 -S  65010". */
/*                                                                                    */
/*     CONNECT VALUE(cStrConnect) NO-ERROR.                                           */
/*                                                                                    */
/*     IF ERROR-STATUS:ERROR  THEN DO:                                                */
/*                                                                                    */
/*         MESSAGE "ERROR CONECCION" SKIP                                             */
/*             ERROR-STATUS:GET-MESSAGE(1 ).                                          */
/*                                                                                    */
/*         RETURN "ADM-ERROR".                                                        */
/*     END.                                                                           */
/*     ELSE DO:                                                                       */
/*         RETURN "OK".                                                               */
/*     END.                                                                           */
/* END.                                                                               */

RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-extrae_ventas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE extrae_ventas Procedure 
PROCEDURE extrae_ventas :
/*------------------------------------------------------------------------------
  Purpose:     Carga las tablas temporales tvtas_det y tvtas_det_ant
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pdDesde AS DATE NO-UNDO.
DEFINE INPUT PARAMETER pdHasta AS DATE NO-UNDO.
DEFINE INPUT PARAMETER plTabla AS LOGICAL NO-UNDO.         /* Yes: tabla ventas periodo actual */

DEFINE VAR cCodDiv AS CHAR NO-UNDO.
DEFINE VAR iConteo AS INT NO-UNDO.
DEFINE VAR cCtgCtble AS CHAR.

IF plTabla = YES THEN DO:
    EMPTY TEMP-TABLE tvtas_cab.
    EMPTY TEMP-TABLE tvtas_det.
END.
ELSE DO:
    EMPTY TEMP-TABLE tvtas_cab_ant.
    EMPTY TEMP-TABLE tvtas_det_ant.
END.

iConteo = 0.

DEF VAR iContador AS INTE INIT 0 NO-UNDO.

/* **************************************** */
/* PRIMERO GRABAMOS SOLO FACTURAS Y BOLETAS */
/* **************************************** */
EMPTY TEMP-TABLE t-Ventas_Cabecera.     /* AQUI VAMOS A ALMACENAR LAS N/C */
VENTAS:
FOR EACH ventas_cabecera NO-LOCK WHERE 
        ventas_cabecera.datekey >= pdDesde AND 
        ventas_cabecera.datekey <= pdHasta:
    IF LOOKUP(ventas_cabecera.coddoc, 'FAC,BOL') = 0 THEN NEXT.
    /* 1) Por las divisiones válidas */
    IF cDivisiones <> "*" THEN DO:
        cCodDiv = TRIM(ventas_cabecera.coddiv).
        IF LOOKUP(cCodDiv, cDivisiones) = 0 THEN NEXT.        
    END.

    /* 2) Las N/C relacionadas por cada FAC */
    FOR EACH NCREDITO NO-LOCK WHERE NCREDITO.codref = Ventas_Cabecera.CodDoc AND
        NCREDITO.nroref = Ventas_Cabecera.NroDoc AND
        NCREDITO.coddoc = "N/C":
        FIND FIRST t-Ventas_Cabecera WHERE t-Ventas_Cabecera.coddoc = NCREDITO.coddoc AND
            t-Ventas_Cabecera.nrodoc = NCREDITO.nrodoc NO-LOCK NO-ERROR.
        IF NOT AVAILABLE t-Ventas_Cabecera THEN DO:
            CREATE t-Ventas_Cabecera.
            BUFFER-COPY NCREDITO TO t-Ventas_Cabecera.
        END.
    END.

    /* 3) Por el artículo */
    FOR EACH ventas_detalle NO-LOCK USE-INDEX Index03 WHERE
        ventas_detalle.coddoc = ventas_cabecera.coddoc AND
        ventas_detalle.nrodoc = ventas_cabecera.nrodoc,
        FIRST DimProducto FIELDS(codmat tpoart CtgCtble) NO-LOCK WHERE DimProducto.codmat = Ventas_Detalle.codmat:
        IF DimProducto.tpoart <> 'A' THEN NEXT.
        cCtgCtble = DimProducto.CtgCtble.
        IF LOOKUP(cCtgCtble,cCategoriasContables) = 0 THEN NEXT.
        IF plTabla = YES THEN DO:
            IF iContador MODULO iLatencia = 0
                THEN DISPLAY "Data ventas periodo ACTUAL " + STRING(ventas_detalle.datekey,'99/99/9999') + ' ' + Ventas_Detalle.codmat @ Fi-Mensaje WITH FRAME F-Proceso.
            CREATE tvtas_det.
            BUFFER-COPY ventas_detalle TO tvtas_det.
        END.
        ELSE DO:
            IF iContador MODULO iLatencia = 0
                THEN DISPLAY "Data ventas periodo ANTERIOR " + STRING(ventas_detalle.datekey,'99/99/9999') + ' ' + Ventas_Detalle.codmat @ Fi-Mensaje WITH FRAME F-Proceso.
            CREATE tvtas_det_ant.
            BUFFER-COPY ventas_detalle TO tvtas_det_ant.
        END.
        iContador = iContador + 1.
    END.
/*     IF iMaximoRegistrosParaProbar > 0 THEN DO:                      */
/*         iConteo = iConteo + 1.                                      */
/*         IF iConteo >= iMaximoRegistrosParaProbar THEN LEAVE VENTAS. */
/*     END.                                                            */
END.
HIDE FRAME F-Proceso.
/* **************************************** */
/* SEGUNDO GRABAMOS SOLO N/C RELACIONADAS   */
/* **************************************** */
iContador = 0.
FOR EACH t-Ventas_Cabecera NO-LOCK,
    FIRST Ventas_Cabecera NO-LOCK WHERE Ventas_Cabecera.CodDoc = t-Ventas_Cabecera.CodDoc AND       /* N/C */
        Ventas_Cabecera.NroDoc = t-Ventas_Cabecera.NroDoc:
    FOR EACH Ventas_Detalle NO-LOCK WHERE Ventas_Detalle.CodDoc = Ventas_Cabecera.CodDoc AND
        Ventas_Detalle.NroDoc = Ventas_Cabecera.NroDoc,
        FIRST DimProducto FIELDS(codmat tpoart CtgCtble) NO-LOCK WHERE DimProducto.codmat = Ventas_Detalle.codmat:
        IF DimProducto.tpoart <> 'A' THEN NEXT.
        cCtgCtble = DimProducto.CtgCtble.
        IF LOOKUP(cCtgCtble,cCategoriasContables) = 0 THEN NEXT.
        IF plTabla = YES THEN DO:
            IF iContador MODULO iLatencia = 0
                THEN DISPLAY "Data N/C periodo ACTUAL " + STRING(ventas_detalle.datekey,'99/99/9999') + ' ' + Ventas_Detalle.codmat @ Fi-Mensaje WITH FRAME F-Proceso.
            CREATE tvtas_det.
            BUFFER-COPY ventas_detalle TO tvtas_det.
        END.
        ELSE DO:
            IF iContador MODULO iLatencia = 0
                THEN DISPLAY "Data N/C periodo ANTERIOR " + STRING(ventas_detalle.datekey,'99/99/9999') + ' ' + Ventas_Detalle.codmat @ Fi-Mensaje WITH FRAME F-Proceso.
            CREATE tvtas_det_ant.
            BUFFER-COPY ventas_detalle TO tvtas_det_ant.
        END.
        iContador = iContador + 1.
    END.
END.
HIDE FRAME F-Proceso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Graba-Tablas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Tablas Procedure 
PROCEDURE Graba-Tablas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND Clf_Agrupador WHERE Clf_Agrupador.Id_Agrupador = iAgrupador NO-LOCK.
FIND Clf_Periodos WHERE Clf_Periodos.Id_Periodo = iPeriodo NO-LOCK.
    
CREATE Clf_Temp_Parameters.
ASSIGN
    Clf_Temp_Parameters.Id_Agrupador    = iAgrupador
    Clf_Temp_Parameters.Id_Periodo      = iPeriodo
    Clf_Temp_Parameters.Codigo          = Clf_Agrupador.Codigo 
    Clf_Temp_Parameters.Divisiones      = Clf_Agrupador.Divisiones 
    Clf_Temp_Parameters.Descripcion     = Clf_Periodos.Descripcion
    Clf_Temp_Parameters.Fecha_Inicio    = Clf_Periodos.Fecha_Inicio
    Clf_Temp_Parameters.Fecha_Termino   = Clf_Periodos.Fecha_Termino
    Clf_Temp_Parameters.Periodo         = Clf_Periodos.Periodo
    Clf_Temp_Parameters.Tipo            = Clf_Periodos.Tipo
    Clf_Temp_Parameters.Tipo_Calculo    = Clf_Periodos.Tipo_Calculo
    Clf_Temp_Parameters.CtgCtbles       = cCategoriasContables
    .
ASSIGN
    Clf_Temp_Parameters.Ult_Usuario = s-user-id
    Clf_Temp_Parameters.Ult_Hora = STRING(TIME,'HH:MM:SS')
    Clf_Temp_Parameters.Ult_Fecha = TODAY
    .
ASSIGN
    Clf_Temp_Parameters.New_Products_Interval-Amount = ABS(x-Interval)
    Clf_Temp_Parameters.New_Products_Interval-Unit = x-Units
    .

RELEASE Clf_Periodos.

FOR EACH tclf_calculo NO-LOCK:
    CREATE Clf_Temp_Calculos.
    ASSIGN 
        Clf_Temp_Calculos.Id_Agrupador = iAgrupador 
        Clf_Temp_Calculos.Id_Periodo = iPeriodo.
    ASSIGN
        Clf_Temp_Calculos.codmat           = tclf_calculo.codmat            
        Clf_Temp_Calculos.descripcion      = tclf_calculo.cdescripcion      
        Clf_Temp_Calculos.marca            = tclf_calculo.cmarca            
        Clf_Temp_Calculos.undstk           = tclf_calculo.cundstk           
        Clf_Temp_Calculos.CtgCtble         = tclf_calculo.cCtgCtble         
        Clf_Temp_Calculos.ventas           = tclf_calculo.dventas           
        Clf_Temp_Calculos.utilidad         = tclf_calculo.dutilidad         
        Clf_Temp_Calculos.cantidad_act     = tclf_calculo.dcantidad_act     
        Clf_Temp_Calculos.importe_act      = tclf_calculo.dimporte_act      
        Clf_Temp_Calculos.cantidad_ant     = tclf_calculo.dcantidad_ant     
        Clf_Temp_Calculos.importe_ant      = tclf_calculo.dimporte_ant      
        Clf_Temp_Calculos.cantidad         = tclf_calculo.dcantidad         
        Clf_Temp_Calculos.importe          = tclf_calculo.dimporte          
        Clf_Temp_Calculos.puntajeventas    = tclf_calculo.dpuntajeventas    
        Clf_Temp_Calculos.puntajeutilidad  = tclf_calculo.dpuntajeutilidad  
        Clf_Temp_Calculos.puntajecantidad  = tclf_calculo.dpuntajecantidad  
        Clf_Temp_Calculos.puntajeimporte   = tclf_calculo.dpuntajeimporte   
        Clf_Temp_Calculos.sumapuntaje      = tclf_calculo.dsumapuntaje      
        Clf_Temp_Calculos.pesoventas       = tclf_calculo.dpesoventas       
        Clf_Temp_Calculos.pesoutilidad     = tclf_calculo.dpesoutilidad     
        Clf_Temp_Calculos.pesocantidad     = tclf_calculo.dpesocantidad     
        Clf_Temp_Calculos.pesoimporte      = tclf_calculo.dpesoimporte      
        Clf_Temp_Calculos.pesoacumulado    = tclf_calculo.dpesoacumulado    
        Clf_Temp_Calculos.pesopuntajefinal = tclf_calculo.dpesopuntajefinal 
        Clf_Temp_Calculos.clasificacion    = tclf_calculo.cclasificacion    
        Clf_Temp_Calculos.Origen           = tclf_calculo.cOrigen           
        .
END.
RELEASE Clf_Temp_Calculos.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-valida_acumuladores) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida_acumuladores Procedure 
PROCEDURE valida_acumuladores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER cRetVal AS CHAR NO-UNDO.

DEFINE VAR dSumaAcumuladores AS DEC NO-UNDO.
DEFINE VAR cDescripcion AS CHAR NO-UNDO.

dSumaAcumuladores = 0.
cRetVal = "".

EMPTY TEMP-TABLE tclf_acumulador.

VALIDA:
FOR EACH clf_acumulador NO-LOCK:
    dSumaAcumuladores = dSumaAcumuladores + clf_acumulador.peso.
    CREATE tclf_acumulador.
    BUFFER-COPY clf_acumulador TO tclf_acumulador.
    cDescripcion = "NO EXISTE ACUMULADOR (" + STRING(clf_acumulador.id_clfacumulador) + ")".    
    FIND FIRST DimClfAcumulador WHERE DimClfAcumulador.id_ClfAcumulador = clf_acumulador.id_clfacumulador NO-LOCK NO-ERROR.
    IF AVAILABLE DimClfAcumulador THEN DO:        
        IF TRUE <> (DimClfAcumulador.descripcion > "") THEN DO:
            cDescripcion = "ACUMULADOR (" + STRING(clf_acumulador.id_clfacumulador) + ") NO TIENE DESCRIPCION".                
        END.
        ELSE DO:
            ASSIGN tclf_acumulador.descripcion = DimClfAcumulador.descripcion.
            cDescripcion = "".
        END.
    END.
    IF NOT (TRUE <> (cDescripcion > "")) THEN DO:
        /* En caso no exista el acumulador o no tenga descripción */
        cRetVal = cDescripcion.
        LEAVE VALIDA.
    END.
    /* Por defecto los valores están en NO y los factores en 0 (cero) */
    CASE TRIM(DimClfAcumulador.descripcion):
        WHEN "VENTAS" THEN DO:
            IF clf_acumulador.peso > 0 THEN lCrecimiento_ventas = YES.
            dFactorVentas = clf_acumulador.peso.
        END.
        WHEN "UTILIDAD" THEN DO:
            IF clf_acumulador.peso > 0 THEN lCrecimiento_utilidad = YES. 
            dFactorUtilidad = clf_acumulador.peso.
        END.
        WHEN "CRECIMIENTO_CANTIDAD" THEN DO:
            IF clf_acumulador.peso > 0 THEN lCrecimiento_qty = YES.
            dFactorCantidad = clf_acumulador.peso.
        END.
        WHEN "CRECIMIENTO_IMPORTE" THEN DO:
            IF clf_acumulador.peso > 0 THEN lCrecimiento_imp = YES.
            dFactorImporte = clf_acumulador.peso.
        END.
    END CASE.
END.

IF TRUE <> (cRetVal > "") THEN DO:
    /* NO hay errores */
    IF dSumaAcumuladores <> 1 THEN DO:
        cRetVal = "La suma de los acumuladores es diferente de 1 (100%)".
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-valida_agrupador) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida_agrupador Procedure 
PROCEDURE valida_agrupador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER cRetVal AS CHAR NO-UNDO.

FIND FIRST clf_agrupador WHERE clf_agrupador.id_agrupador = iAgrupador NO-LOCK NO-ERROR.
IF NOT AVAILABLE clf_agrupador THEN DO:
    cRetVal = "El Id del agrupador no existe (" + STRING(iAgrupador) + ")".
    RETURN "ADM-ERROR".
END.
IF TRUE <> (clf_agrupador.divisiones > "") THEN DO:
    cRetVal = "El agrupador (" + STRING(iAgrupador) + " - " + clf_agrupador.codigo + ") no tiene divisiones asignadas".
    RETURN "ADM-ERROR".
END.

cAgrupador = clf_agrupador.codigo.
cDivisiones = TRIM(clf_agrupador.divisiones).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-valida_periodo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida_periodo Procedure 
PROCEDURE valida_periodo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER cRetVal AS CHAR NO-UNDO.

FIND FIRST clf_periodos WHERE clf_periodos.id_periodo = iPeriodo NO-LOCK NO-ERROR.
IF NOT AVAILABLE clf_periodos THEN DO:
    cRetVal = "El Id del periodo no existe (" + STRING(iPeriodo) + ")".
    RETURN "ADM-ERROR".
END.
IF clf_periodos.fecha_inicio = ? OR clf_periodos.fecha_termino = ? THEN DO:
    cRetVal = "Las fechas estan erradas del periodo (" + STRING(iPeriodo) + " - " + clf_periodos.descripcion + ")".
    RETURN "ADM-ERROR".
END.
IF clf_periodos.fecha_inicio > clf_periodos.fecha_termino THEN DO:
    cRetVal = "La fecha de inicio debe ser menor/igual a termino - Periodo("  + STRING(iPeriodo) + " - " + clf_periodos.descripcion +  ")".
    RETURN "ADM-ERROR".
END.

fDesde = clf_periodos.fecha_inicio.
fHasta = clf_periodos.fecha_termino.

cPeriodoDescripcion = TRIM(clf_periodos.descripcion).

cTipo_Calculo = Clf_Periodos.Tipo_Calculo.

lCampana = (IF Clf_Periodos.Tipo = "CAMPAÑA" THEN YES ELSE NO).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

