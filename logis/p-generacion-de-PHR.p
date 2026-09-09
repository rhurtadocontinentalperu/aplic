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

DEFINE INPUT PARAMETE pCodPIR AS CHAR.
DEFINE INPUT PARAMETE pNroPIR AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pDocCreados AS CHAR.
DEFINE INPUT PARAMETER pSolopruebas AS LOG.

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR x-emision-desde AS DATE.
DEFINE VAR x-emision-hasta AS DATE.
DEFINE VAR x-tot-ordenes AS INT INIT 0.
DEFINE VAR x-tot-ordenes-generadas AS INT INIT 0.

/* Si adiciona un campo a esta tabla tambien hacerlo en logis/d-resumen-pre-rutas.w y d-pre-rutas-x-distrito.w*/
DEFINE TEMP-TABLE ttResumen
    FIELD   tcuadrante     AS  CHAR    FORMAT 'x(5)'
    FIELD   ttotclie    AS  INT     INIT 0
    FIELD   ttotpeso    AS  DEC     INIT 0
    FIELD   ttotvol     AS  DEC     INIT 0
    FIELD   ttotimp     AS  DEC     INIT 0
    FIELD   ttotord     AS  INT     INIT 0
    FIELD   tnro-phruta AS CHAR     FORMAT 'x(15)'
    FIELD   tobserva    AS CHAR     FORMAT 'x(15)'
    FIELD   tswok       AS CHAR     FORMAT 'x(1)' INIT ""
    INDEX idx01 tcuadrante      /* Ic */
.
/* Si adiciona un campo a esta tabla tambien hacerlo en d-pre-rutas-x-distrito*/
DEFINE TEMP-TABLE   ttDetalle
    FIELD   tdivdes     AS  CHAR    FORMAT  'x(10)'     /* Ic */
    FIELD   tcuadrante     AS  CHAR    FORMAT 'x(5)'
    FIELD   tcoddoc     AS  CHAR    FORMAT '(5)'
    FIELD   tnroped     AS  CHAR    FORMAT 'x(15)'
    FIELD   tcodcli     AS  CHAR    FORMAT 'x(12)'
    FIELD   ttotpeso    AS  DEC     INIT 0
    FIELD   ttotvol     AS  DEC     INIT 0
    FIELD   ttotimp     AS  DEC     INIT 0
    FIELD   tubigeo     AS  CHAR    FORMAT 'x(8)'
    FIELD   titems      AS  INT     INIT 0
    FIELD   tfchped     AS  DATE
    FIELD   tfchent     AS  DATE
    FIELD   tnomcli     AS  CHAR
    INDEX idx01 tcuadrante tdivdes tcoddoc tnroped  /* Ic */
    INDEX idx02 tdivdes tcuadrante tcoddoc tnroped  /* Ic */
.
/*
O/D , Cliente , Fecha Entrega,Items,Peso,S/,m3
*/
DEFINE TEMP-TABLE ttCliente
    FIELD   tcuadrante     AS  CHAR    FORMAT 'X(5)'
    FIELD   tcodcli     AS  CHAR    FORMAT 'x(11)'
    INDEX idx01 tcuadrante tcodcli          /* Ic */
    .
DEFINE TEMP-TABLE ttClientePtoDspcho
    FIELD   tcuadrante     AS  CHAR    FORMAT 'X(5)'
    FIELD   tdivdes     AS  CHAR    FORMAT  'x(10)'     /* Ic */
    FIELD   tcodcli     AS  CHAR    FORMAT 'x(11)'
    INDEX idx01 tcuadrante tdivdes tcodcli          /* Ic */
.

DEF VAR s-coddoc AS CHAR INIT 'PHR' NO-UNDO.    /* Pre Hoja de Ruta */
DEF VAR XXXs-coddoc AS CHAR INIT 'IPT' NO-UNDO.    /* Pre Hoja de Ruta */

DEFINE BUFFER x-di-rutaC FOR di-rutaC.
DEFINE BUFFER x-di-rutaD FOR di-rutaD.
DEFINE BUFFER y-di-rutaD FOR di-rutaD.

DEFINE VAR x-numero-orden AS INT .
DEFINE VAR x-serie-orden AS INT .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-evalua-condicion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD evalua-condicion Procedure 
FUNCTION evalua-condicion RETURNS LOGICAL
  ( INPUT pValor1 AS DEC, INPUT pValor2 AS DEC, INPUT pDato AS DEC, INPUT pCondLogica AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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

  SESSION:SET-WAIT-STATE("GENERAL").
  RUN procesar.
  SESSION:SET-WAIT-STATE("").
  /*RUN generar-pre-rutas.*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-generar-pre-rutas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-pre-rutas Procedure 
PROCEDURE generar-pre-rutas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

pDocCreados = "".

DEFINE VAR x-peso-desde AS DEC INIT 0.
DEFINE VAR x-peso-hasta AS DEC INIT 0.
DEFINE VAR x-vol-desde AS DEC INIT 0.
DEFINE VAR x-vol-hasta AS DEC INIT 0.
DEFINE VAR x-imp-desde AS DEC INIT 0.
DEFINE VAR x-imp-hasta AS DEC INIT 0.

DEFINE VAR x-condicion AS LOG.
DEFINE VAR x-procesado AS CHAR.

DEFINE VAR x-retval AS CHAR.
x-tot-ordenes = 0.

/* Verificar las series por cada punto de despacho */
FOR EACH ttDetalle NO-LOCK BREAK BY ttDetalle.tdivdes :

    x-tot-ordenes = x-tot-ordenes + 1.      /* Variable prestadita */

    IF FIRST-OF(ttDetalle.tdivdes) THEN DO:
        IF NOT CAN-FIND(FIRST Faccorre WHERE FacCorre.CodCia = s-codcia 
                        AND FacCorre.CodDiv = ttDetalle.tdivdes /*s-coddiv */
                        AND FacCorre.CodDoc = s-coddoc 
                        AND FacCorre.FlgEst = YES
                        NO-LOCK) THEN DO:
            pRetVal = "NO definido el correlativo para el documento : " +  s-coddoc + " Division " + ttDetalle.tdivdes.
            RETURN.
        END.

    END.
END.
/**/
FIND FIRST di-rutaC WHERE di-rutaC.codcia = s-codcia AND
                            di-rutaC.coddoc = pCodPIR AND
                            di-rutaC.nrodoc = pNroPIR NO-LOCK NO-ERROR.
IF NOT AVAILABLE di-rutaC THEN DO:
    pRetVal = "El documento " + pCodPIR + " " + pNroPir + " NO existte".
    RETURN.
END.

IF di-rutaC.flgest <> 'P' THEN DO:
    pRetVal = "El documento " + pCodPIR + " " + pNroPir + " YA NO ESTA PENDIENTE".
    RETURN.
END.

IF x-tot-ordenes = 0 THEN DO:
    pRetVal = "El documento " + pCodPIR + " " + pNroPir + " NO TIENE NINGUNA ORDEN COMO DETALLE".
    RETURN.
END.

SESSION:SET-WAIT-STATE("GENERAL").

x-tot-ordenes = 0.
x-tot-ordenes-generadas = 0.

DEFINE BUFFER b-ttResumen FOR ttResumen.

pRetVal = "OK".

GRABAR_DATOS:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE :
    /**/
    x-numero-orden = 0.
    x-serie-orden = 0.
    
    pRetVal = "OK".
    
    PROCESAR_RESUMEN:
    FOR EACH ttResumen :
        FIND FIRST rut-cuadrante-cab WHERE rut-cuadrante-cab.codcia = s-codcia AND
            rut-cuadrante-cab.cuadrante = ttResumen.tcuadrante NO-LOCK NO-ERROR.
        /* Solo aquellos que tengan ubicado el CUADRANTE */
        IF NOT AVAILABLE rut-cuadrante-cab THEN DO:
            pRetVal = "Cuadrante no esta confifurado " + ttResumen.tcuadrante.
            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
        END.

        /* Los CUADRANTES */
        CONFIGURACION:
        FOR EACH VtaCTabla WHERE VtaCTabla.codcia = s-codcia AND 
            VtaCTabla.tabla = 'COND-PRE-HRUTA' NO-LOCK BY VtaCTabla.libre_d03:
            x-condicion = NO.
            x-procesado = "".
            /* Camiones */
            CAMIONES:        
            FOR EACH rut-conf-phr WHERE rut-conf-phr.codcia = s-codcia AND 
                rut-conf-phr.tabla = VtaCTabla.tabla AND
                rut-conf-phr.llave = VtaCTabla.llave NO-LOCK BY rut-conf-phr.libre_d10 :
                x-condicion = NO.
    
                x-peso-hasta = rut-conf-phr.libre_d01.
                x-peso-desde = x-peso-hasta * ((100 - rut-conf-phr.libre_d04) / 100).
    
                x-condicion = evalua-condicion(x-peso-desde, x-peso-hasta, ttResumen.ttotpeso, TRIM(rut-conf-phr.libre_c01)).
                /* Si la condicion es FALSO siguiente CAMION */
                IF x-condicion = NO THEN NEXT.
    
                x-vol-hasta = rut-conf-phr.libre_d02.
                x-vol-desde = x-vol-hasta * ((100 - rut-conf-phr.libre_d05) / 100).
    
                x-condicion = evalua-condicion(x-vol-desde, x-vol-hasta, ttResumen.ttotvol, TRIM(rut-conf-phr.libre_c02)).
                /* Si la condicion es FALSO siguiente CAMION */
                IF x-condicion = NO THEN NEXT.
    
                x-imp-hasta = rut-conf-phr.libre_d03.
                x-imp-desde = x-imp-hasta * ((100 - rut-conf-phr.libre_d06) / 100).
    
                x-condicion = evalua-condicion(x-imp-desde, x-imp-hasta, ttResumen.ttotimp, TRIM(rut-conf-phr.libre_c03)).
                /* Si la condicion es FALSO siguiente CAMION */
                IF x-condicion = YES THEN DO:
                    /*  */      
                    x-procesado = "".
                    RUN grabar-ordenes-en-pre-ruta(INPUT ttResumen.tcuadrante, OUTPUT x-procesado, INPUT STRING(rut-conf-phr.libre_d10)) NO-ERROR.
                    
                    IF x-procesado = "OK" THEN DO:
                        LEAVE CONFIGURACION.        /* Siguiente Cuadrante */
                    END.
                    ELSE DO:
                        /* ERROR */
                        pRetVal = x-procesado.
                        UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.  
                    END.
                    
                END.
            END.
            IF x-condicion = NO AND x-procesado = "" THEN DO:
                /* Carros en TRANSITO */
                x-procesado = "".
                RUN grabar-ordenes-en-pre-ruta(INPUT ttResumen.tcuadrante, OUTPUT x-procesado, INPUT "CARRO DE TRANSITO") NO-ERROR.
                IF ERROR-STATUS:ERROR = YES  THEN DO:
                    pRetVal = x-procesado.
                    UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.  
                END.
                IF x-procesado = "OK" THEN DO:
                    /**/
                END.
                ELSE DO:
                    pRetVal = x-procesado.
                    UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
                END.
            END.
            ELSE DO:
                /* Hubo problemas al crear las PRE-RUTAS */
                pRetVal = "Hubo problemas al crear las PRE-RUTAS".
                UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.  
            END.
        END.
    END.
    /* Acutlizo el PIR */
    FIND FIRST di-rutaC WHERE di-rutaC.codcia = s-codcia AND
                                di-rutaC.coddoc = pCodPIR AND
                                di-rutaC.nrodoc = pNroPIR EXCLUSIVE-LOCK NO-ERROR.
    /* Me recontra aseguro */
    IF NOT AVAILABLE di-rutaC THEN DO:
        pRetVal = "El documento " + pCodPIR + " " + pNroPir + " NO existte".
        UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.  
    END.

    IF di-rutaC.flgest <> 'P' THEN DO:
        pRetVal = "El documento " + pCodPIR + " " + pNroPir + " YA NO ESTA PENDIENTE".
        UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.  
    END.

    /* Actualizo el PIR */
    ASSIGN di-rutaC.flgest = 'C'
            di-rutaC.usraprobacion = USERID("DICTDB")
            di-rutaC.fchaprobacion = TODAY
            di-rutaC.libre_c01 = STRING(TIME,"HH:MM:SS") NO-ERROR.
    IF ERROR-STATUS:ERROR = YES  THEN DO:
        pRetVal = "El documento " + pCodPIR + " " + pNroPir + " YA NO SE ACTUALIZAR EL NUEVO ESTADO".
        UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.  
    END.
    
END.
/* Elimino los cuadrante que no generaron Pre-Ruta */
FOR EACH ttResumen WHERE ttResumen.tswok = '' :
    
    FOR EACH ttDetalle WHERE ttDetalle.tcuadrante = ttResumen.tcuadrante :
        DELETE ttDetalle.
    END.
    DELETE ttResumen.
END.

SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generar-pre-rutas_BORRAR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-pre-rutas_BORRAR Procedure 
PROCEDURE generar-pre-rutas_BORRAR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pRetVal AS CHAR.

DEFINE VAR x-peso-desde AS DEC INIT 0.
DEFINE VAR x-peso-hasta AS DEC INIT 0.
DEFINE VAR x-vol-desde AS DEC INIT 0.
DEFINE VAR x-vol-hasta AS DEC INIT 0.
DEFINE VAR x-imp-desde AS DEC INIT 0.
DEFINE VAR x-imp-hasta AS DEC INIT 0.

DEFINE VAR x-condicion AS LOG.
DEFINE VAR x-procesado AS CHAR.

DEFINE VAR x-retval AS CHAR.

x-tot-ordenes = 0.
x-tot-ordenes-generadas = 0.

/*
EMPTY TEMP-TABLE x-di-rutaC.
EMPTY TEMP-TABLE x-di-rutaD.
*/
SESSION:SET-WAIT-STATE("GENERAL").

x-numero-orden = 0.
x-serie-orden = 0.

pRetVal = "OK".

PROCESAR_RESUMEN:
FOR EACH ttResumen :
    FIND FIRST rut-cuadrante-cab WHERE rut-cuadrante-cab.codcia = s-codcia AND
        rut-cuadrante-cab.cuadrante = ttResumen.tcuadrante NO-LOCK NO-ERROR.
    /* Solo aquellos que tengan ubicado el CUADRANTE */
    IF NOT AVAILABLE rut-cuadrante-cab THEN NEXT.
    /**/
    CONFIGURACION:
    FOR EACH VtaCTabla WHERE VtaCTabla.codcia = s-codcia AND 
        VtaCTabla.tabla = 'COND-PRE-HRUTA' NO-LOCK BY VtaCTabla.libre_d03:
        x-condicion = NO.
        x-procesado = "".
        /* Camiones */
        CAMIONES:        
        FOR EACH rut-conf-phr WHERE rut-conf-phr.codcia = s-codcia AND 
            rut-conf-phr.tabla = VtaCTabla.tabla AND
            rut-conf-phr.llave = VtaCTabla.llave NO-LOCK BY rut-conf-phr.libre_d10 :
            x-condicion = NO.

            x-peso-hasta = rut-conf-phr.libre_d01.
            x-peso-desde = x-peso-hasta * ((100 - rut-conf-phr.libre_d04) / 100).

            x-condicion = evalua-condicion(x-peso-desde, x-peso-hasta, ttResumen.ttotpeso, TRIM(rut-conf-phr.libre_c01)).
            /* Si la condicion es FALSO siguiente CAMION */
            IF x-condicion = NO THEN NEXT.

            x-vol-hasta = rut-conf-phr.libre_d02.
            x-vol-desde = x-vol-hasta * ((100 - rut-conf-phr.libre_d05) / 100).

            x-condicion = evalua-condicion(x-vol-desde, x-vol-hasta, ttResumen.ttotvol, TRIM(rut-conf-phr.libre_c02)).
            /* Si la condicion es FALSO siguiente CAMION */
            IF x-condicion = NO THEN NEXT.

            x-imp-hasta = rut-conf-phr.libre_d03.
            x-imp-desde = x-imp-hasta * ((100 - rut-conf-phr.libre_d06) / 100).

            x-condicion = evalua-condicion(x-imp-desde, x-imp-hasta, ttResumen.ttotimp, TRIM(rut-conf-phr.libre_c03)).
            /* Si la condicion es FALSO siguiente CAMION */
            IF x-condicion = YES THEN DO:
                /*  */      
                x-procesado = "".
                RUN grabar-ordenes-en-pre-ruta(INPUT ttResumen.tcuadrante, OUTPUT x-procesado, INPUT STRING(rut-conf-phr.libre_d10)).
                IF x-procesado = "OK" THEN DO:
                    LEAVE CONFIGURACION.
                END.
                ELSE DO:
                    /* ERROR */
                    pRetVal = x-procesado.
                    LEAVE PROCESAR_RESUMEN.
                END.
                
            END.
        END.
        IF x-condicion = NO AND x-procesado = "" THEN DO:
            /* Carros en TRANSITO */
            x-procesado = "".
            RUN grabar-ordenes-en-pre-ruta(INPUT ttResumen.tcuadrante, OUTPUT x-procesado, INPUT "CARRO DE TRANSITO").
            IF x-procesado = "OK" THEN DO:
                /**/
            END.
            ELSE DO:
                pRetVal = x-procesado.
                LEAVE PROCESAR_RESUMEN.
            END.
        END.
        ELSE DO:
            /* Hubo problemas al crear las PRE-RUTAS */
            pRetVal = "Hubo problemas al crear las PRE-RUTAS".
            LEAVE PROCESAR_RESUMEN.
        END.
    END.
END.
/* Elimino los cuadrante que no generaron Pre-Ruta */
FOR EACH ttResumen WHERE ttResumen.tswok = '' :
    /*MESSAGE 'eliminado' ttdetalle.tcoddoc ttdetalle.tnroped.*/
    FOR EACH ttDetalle WHERE ttDetalle.tcuadrante = ttResumen.tcuadrante :
        DELETE ttDetalle.
    END.
    DELETE ttResumen.
END.
SESSION:SET-WAIT-STATE("").

/* FOR EACH ttdetalle:                              */
/*     MESSAGE ttdetalle.tcoddoc ttdetalle.tnroped. */
/* END.                                             */


/*
x-procesado = "".
RUN logis/d-modificacion-pre-rutas.r(INPUT TABLE ttResumen, 
                                     INPUT TABLE ttDetalle, 
                                     INPUT TABLE x-di-rutaC,
                                     INPUT TABLE x-di-rutaD,
                                     OUTPUT x-procesado).
*/


/* /* A mostrar la Pre-Rutas x distrito */                                                               */
/* x-procesado = "".                                                                                     */
/* RUN logis/d-pre-rutas-x-distrito.r(INPUT TABLE ttResumen, INPUT TABLE ttDetalle, OUTPUT x-procesado). */
/* IF x-procesado = 'SI' THEN DO:                                                                        */
/*     /* La siguiente pantalla UNIR pre-RUtas*/                                                         */
/*     x-procesado = "".                                                                                 */
/*     RUN logis/d-modificacion-pre-rutas.r(INPUT TABLE ttResumen,                                       */
/*                                          INPUT TABLE ttDetalle,                                       */
/*                                          INPUT TABLE x-di-rutaC,                                      */
/*                                          INPUT TABLE x-di-rutaD,                                      */
/*                                          OUTPUT x-procesado).                                         */
/* END.                                                                                                  */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-grabar-ordenes-en-pre-ruta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-ordenes-en-pre-ruta Procedure 
PROCEDURE grabar-ordenes-en-pre-ruta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCuadrante AS CHAR.
DEFINE OUTPUT PARAMETER pProcesado AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pObserva AS CHAR.

DEFINE BUFFER b-ttResumen FOR ttResumen.

pProcesado = "OK".

GRABAR_DETALLE:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE :

    /* x las ordenes de CADA PUNTO DE DESPACHO */
    FOR EACH ttDetalle WHERE ttDetalle.tcuadrante = pCuadrante BREAK BY ttDetalle.tcuadrante BY ttDetalle.tdivdes:
        IF FIRST-OF(ttDetalle.tcuadrante) OR FIRST-OF(ttDetalle.tdivdes)  THEN DO:

            FIND FIRST faccorre WHERE FacCorre.CodCia = s-codcia 
                AND FacCorre.CodDiv = ttDetalle.tdivdes 
                AND FacCorre.CodDoc = s-coddoc 
                AND FacCorre.FlgEst = YES EXCLUSIVE-LOCK NO-ERROR.

            IF LOCKED faccorre THEN DO:
                pProcesado = "La tabla FACCORRE esta bloqueada por otro usario".
                UNDO GRABAR_DETALLE, LEAVE GRABAR_DETALLE.
            END.

            IF NOT AVAILABLE faccorre THEN DO:
                pProcesado = "No esta configurado el correlativo para tipodoc " + s-coddoc + " para la division " + ttDetalle.tdivdes.
                UNDO GRABAR_DETALLE, LEAVE GRABAR_DETALLE.
            END.
            /* Header */ 
            CREATE x-DI-RutaC.
            ASSIGN
                x-DI-RutaC.CodCia = s-codcia
                x-DI-RutaC.CodDiv = ttDetalle.tdivdes 
                x-DI-RutaC.CodDoc = s-coddoc
                x-DI-RutaC.FchDoc = TODAY
                x-DI-RutaC.NroDoc = STRING(faccorre.nroser, '999') + 
                                    STRING(faccorre.correlativo, '999999')
                x-DI-RutaC.codrut = "AUTOMATICO"    /*pGlosa*/
                x-DI-RutaC.observ = pObserva
                x-DI-RutaC.usuario = USERID("DICTDB")
                x-DI-RutaC.flgest  = "P"     /* Pendiente x Pickear*/
                x-DI-RutaC.Libre_d01 = 0    /*ttResumen.ttotclie*/  /* Datos de Topes Máximos */        
                x-DI-RutaC.Libre_d02 = 0    /*ttResumen.ttotpeso*/
                x-DI-RutaC.Libre_d03 = 0    /*ttResumen.ttotvol*/
                x-DI-RutaC.Libre_c02 = ""                 /* FILL-IN_NroPed */ 
                x-DI-RutaC.Libre_c03 = ""                 /* FILL-IN_Cliente. */
                x-di-rutaC.libre_c02 = pCodPIR
                x-di-rutaC.libre_c03 = pNroPIR
                NO-ERROR.

            IF ERROR-STATUS:ERROR = YES  THEN DO:
                pProcesado = "Imposible crear una nueva PHR - Cabecera" + CHR(13) + CHR(10) +
                                ERROR-STATUS:GET-MESSAGE(1).
                UNDO GRABAR_DETALLE, LEAVE GRABAR_DETALLE.
            END.

            ASSIGN faccorre.correlativo = faccorre.correlativo + 1 NO-ERROR.
            IF ERROR-STATUS:ERROR = YES  THEN DO:
                pProcesado = "Imposible incrementar el correlativo para " + s-coddoc + " en la division " + ttDetalle.tdivdes  + CHR(13) + CHR(10) +
                                ERROR-STATUS:GET-MESSAGE(1).
                UNDO GRABAR_DETALLE, LEAVE GRABAR_DETALLE.
            END.

            /**/
            FOR EACH ttClientePtoDspcho WHERE ttClientePtoDspcho.tcuadrante = pCuadrante AND
                                        ttClientePtoDspcho.tdivdes = ttDetalle.tdivdes NO-LOCK :
                x-DI-RutaC.Libre_d01 = x-DI-RutaC.Libre_d01 + 1.
            END.

            /**/
            IF pDocCreados <> "" THEN pDocCreados = pDocCreados + ";".
            pDocCreados = pDocCreados + x-DI-RutaC.NroDoc.
        END.
        /* DETALLE */
        CREATE x-DI-RutaD.
        ASSIGN
            x-DI-RutaD.CodCia = x-DI-RutaC.CodCia
            x-DI-RutaD.CodDiv = x-DI-RutaC.CodDiv
            x-DI-RutaD.CodDoc = x-DI-RutaC.CodDoc
            x-DI-RutaD.NroDoc = x-DI-RutaC.NroDoc
            x-DI-RutaD.CodRef = ttDetalle.tcoddoc
            x-DI-RutaD.NroRef = ttDetalle.tnroped
            x-DI-RutaD.ImpCob    = ttDetalle.ttotvol
            x-DI-RutaD.Libre_d01 = ttDetalle.ttotpeso
            x-DI-RutaD.Libre_d02 = ttDetalle.ttotimp
            x-DI-RutaD.Libre_c01 = "0" NO-ERROR.

        IF ERROR-STATUS:ERROR = YES  THEN DO:
            pProcesado = "Imposible crear una nueva " + s-coddoc + " - Detalle" + CHR(13) + CHR(10) + 
                                ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABAR_DETALLE, LEAVE GRABAR_DETALLE.
        END.

        ASSIGN x-DI-RutaC.Libre_d02 = x-DI-RutaC.Libre_d02 + ttDetalle.ttotpeso
                x-DI-RutaC.Libre_d03 = x-DI-RutaC.Libre_d03 + ttResumen.ttotvol NO-ERROR.

        IF ERROR-STATUS:ERROR = YES  THEN DO:
            pProcesado = "Imposible crear una nueva " + s-coddoc + " - Detalle" + CHR(13) + CHR(10) +
                                ERROR-STATUS:GET-MESSAGE(1)                .
            UNDO GRABAR_DETALLE, LEAVE GRABAR_DETALLE.
        END.

    END.
    /*  */
    FIND FIRST b-ttResumen WHERE b-ttResumen.tcuadrante = pCuadrante EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE b-ttResumen THEN DO:
        ASSIGN b-ttResumen.tnro-phruta = x-DI-RutaC.NroDoc          /* Seria el ultimo PHR generado */
                b-ttResumen.tobserva = pObserva
                b-ttResumen.tswok = 'S'.
    END.
    pProcesado = "OK".
END. 

RELEASE b-ttResumen.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-grabar-ordenes-en-pre-ruta-BORRAR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-ordenes-en-pre-ruta-BORRAR Procedure 
PROCEDURE grabar-ordenes-en-pre-ruta-BORRAR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCuadrante AS CHAR.
DEFINE OUTPUT PARAMETER pProcesado AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pObserva AS CHAR.

pProcesado = "".

IF NOT CAN-FIND(FIRST Faccorre WHERE FacCorre.CodCia = s-codcia 
                AND FacCorre.CodDiv = s-coddiv 
                AND FacCorre.CodDoc = s-coddoc 
                AND FacCorre.FlgEst = YES
                NO-LOCK) THEN DO:
    pProcesado = "NO definido el correlativo para el documento:" +  s-coddoc.
    RETURN.
END.

/* Se debe verificar el correlativo para todos los PUNTOS DE DESPACHO */

DEFINE BUFFER b-ttResumen FOR ttResumen.

pProcesado = "".
GRABAR_DATOS:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:

    /* x las ordenes de CADA PUNTO DE DESPACHO */

    x-numero-orden = x-numero-orden + 1.
    DO:
        /* Header update block */
        CREATE x-DI-RutaC.
        ASSIGN
            x-DI-RutaC.CodCia = s-codcia
            x-DI-RutaC.CodDiv = s-coddiv
            x-DI-RutaC.CodDoc = s-coddoc
            x-DI-RutaC.FchDoc = TODAY
            x-DI-RutaC.NroDoc = STRING(x-serie-orden, '999') + 
                                STRING(x-numero-orden, '999999')
            x-DI-RutaC.codrut = "AUTOMATICO"    /*pGlosa*/
            x-DI-RutaC.observ = pObserva
            x-DI-RutaC.usuario = s-user-id
            x-DI-RutaC.flgest  = "PX".     /* Pendiente x Pickear*/
        /* Datos de Topes Máximos */
        ASSIGN
            x-DI-RutaC.Libre_d01 = ttResumen.ttotclie
            x-DI-RutaC.Libre_d02 = ttResumen.ttotpeso
            x-DI-RutaC.Libre_d03 = ttResumen.ttotvol.
        ASSIGN
/*             x-DI-RutaC.Libre_f01 = FILL-IN-Desde                          */
/*             x-DI-RutaC.Libre_f02 = FILL-IN-Hasta                          */
/*             x-DI-RutaC.Libre_c01 = COMBO-BOX-corte    /* Hora de Corte */ */
            x-DI-RutaC.Libre_c02 = ""                 /* FILL-IN_NroPed */ 
            x-DI-RutaC.Libre_c03 = ""                 /* FILL-IN_Cliente. */
            NO-ERROR
        .
        IF ERROR-STATUS:ERROR = YES  THEN DO:
            pProcesado = "Imposible crear una nueva PHR - Cabecera".
            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
        END.
    END.
    /* Detalle de Ordenes */
    FOR EACH ttDetalle WHERE ttDetalle.tcuadrante = pCuadrante :
        CREATE x-DI-RutaD.
        ASSIGN
            x-DI-RutaD.CodCia = x-DI-RutaC.CodCia
            x-DI-RutaD.CodDiv = x-DI-RutaC.CodDiv
            x-DI-RutaD.CodDoc = x-DI-RutaC.CodDoc
            x-DI-RutaD.NroDoc = x-DI-RutaC.NroDoc
            x-DI-RutaD.CodRef = ttDetalle.tcoddoc
            x-DI-RutaD.NroRef = ttDetalle.tnroped.
        
        ASSIGN
            x-DI-RutaD.ImpCob    = ttDetalle.ttotvol
            x-DI-RutaD.Libre_d01 = ttDetalle.ttotpeso
            x-DI-RutaD.Libre_d02 = ttDetalle.ttotimp
            x-DI-RutaD.Libre_c01 = "0"                         /* STRING(T-RUTAD.Bultos). */
            NO-ERROR
        .
        IF ERROR-STATUS:ERROR = YES  THEN DO:
            pProcesado = "Imposible crear una nueva PHR - Detalle".
            UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
        END.

    END.
    /*  */
    FIND FIRST b-ttResumen WHERE b-ttResumen.tcuadrante = pCuadrante EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE b-ttResumen THEN DO:
        ASSIGN b-ttResumen.tnro-phruta = x-DI-RutaC.NroDoc
                b-ttResumen.tobserva = pObserva
                b-ttResumen.tswok = 'S'.
    END.
    ELSE DO:
        UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
    END.
    pProcesado = "OK".
END. /* TRANSACTION block */

/*  ???????????????????????????? cerrar los DI-RUTAS  */ 
RELEASE b-ttResumen.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-procesar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar Procedure 
PROCEDURE procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-sec AS INT.
DEFINE VAR x-coddiv AS CHAR.

DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nrodoc AS CHAR.
DEFINE VAR x-nro-pir AS CHAR.

DEFINE VAR x-retval AS CHAR.
DEFINE VAR x-proceso AS CHAR.

x-proceso = "OK".

EMPTY TEMP-TABLE ttResumen.
EMPTY TEMP-TABLE ttDetalle.
EMPTY TEMP-TABLE ttCliente.
EMPTY TEMP-TABLE ttClientePtoDspcho.

/* Detalle (O/D, OTR) del PIR */
DETALLE_PIR:
FOR EACH y-di-rutaD WHERE y-di-rutaD.codcia = s-codcia AND
                            y-di-rutaD.coddoc = pCodPIR AND
                            y-di-rutaD.nrodoc = pNroPIR NO-LOCK:

    RUN procesar-ordenes(INPUT y-di-rutaD.codref, INPUT y-di-rutaD.nroref, OUTPUT x-retval).
    
    IF x-retval <> "OK" THEN DO:
        x-proceso = x-RetVal.
        LEAVE DETALLE_PIR.
    END.
    
END.

IF x-proceso = "OK" THEN DO:
    x-retval = "".
    RUN generar-pre-rutas(OUTPUT x-retval).
    pRetVal = x-retval.        
END.
ELSE DO:
    pRetVal = x-proceso.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-procesar-orden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-orden Procedure 
PROCEDURE procesar-orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE OUTPUT PARAMETER pMsg AS CHAR NO-UNDO.

DEFINE VAR x-codped AS CHAR INIT "".
DEFINE VAR x-nroped AS CHAR INIT "".

DEFINE BUFFER x-faccpedi FOR faccpedi.
DEFINE BUFFER x-pedido FOR faccpedi.

DEFINE VAR x-hora-emision AS CHAR.

FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
    x-faccpedi.coddoc = pCoddoc AND
    x-faccpedi.nroped = pNroDoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-faccpedi THEN DO:
    pMsg = "Orden no existe " + pCoddoc + " " + pNroDoc.
    /*MESSAGE x-faccpedi.coddoc x-faccpedi.nroped SKIP pmsg.*/
    RETURN "ADM-ERROR".
END.

/* Validar la HORA de corte vs la emision */
x-hora-emision = x-faccpedi.hora.
IF TRUE <> (x-hora-emision > "") THEN DO:
    x-hora-emision = "00:00".
END.
IF LENGTH(x-hora-emision) > 5 THEN x-hora-emision = SUBSTRING(x-hora-emision,1,5).

/* IF x-faccpedi.fchped = fill-in-hasta AND x-hora-emision <= combo-box-corte  THEN DO: */
/*     pMsg = "La HORA esta fuera del CORTE " + pCoddoc + " " + pNroDoc.                */
/*     MESSAGE x-faccpedi.coddoc x-faccpedi.nroped SKIP pmsg.                           */
/*     RETURN "ADM-ERROR".                                                              */
/* END.                                                                                 */

/* Pedido */
/* Ubicacion de coordenadas */
DEFINE VAR x-ubigeo AS CHAR INIT "".
DEFINE VAR x-longuitud AS DEC INIT 0.
DEFINE VAR x-latitud AS DEC INIT 0.
DEFINE VAR x-filer AS DEC INIT 0.
DEFINE VAR x-cuadrante AS CHAR INIT "".
DEFINE VAR x-items AS INT.

x-codped = x-faccpedi.codref.
x-nroped = x-faccpedi.nroref.
CASE TRUE:
    WHEN pCodDoc = "O/D" OR pCodDoc = "O/M" THEN DO:
        FIND FIRST x-pedido WHERE x-pedido.codcia = s-codcia AND
                                    x-pedido.coddoc = x-codped AND 
                                    x-pedido.nroped = x-nroped NO-LOCK NO-ERROR.
        IF NOT AVAILABLE x-pedido THEN DO:
            pMsg = "Pedido no existe " + x-codped + " " + x-nroped.
            RETURN "ADM-ERROR".
        END.
        RUN logis/p-datos-sede-auxiliar(INPUT x-pedido.ubigeo[2], 
                                        INPUT x-pedido.ubigeo[3],
                                        INPUT x-pedido.ubigeo[1],
                                        OUTPUT x-ubigeo,
                                        OUTPUT x-longuitud,
                                        OUTPUT x-latitud).
    END.
    WHEN pCodDoc = "OTR" THEN DO:
        RUN logis/p-datos-sede-auxiliar(INPUT x-faccpedi.ubigeo[2], 
                                        INPUT x-faccpedi.ubigeo[3],
                                        INPUT x-faccpedi.ubigeo[1],
                                        OUTPUT x-ubigeo,
                                        OUTPUT x-longuitud,
                                        OUTPUT x-latitud).
    END.
END CASE.

IF TRUE <> (x-ubigeo > "") THEN DO:
    x-cuadrante = "ERR".
END.
ELSE DO:
    RUN logis/p-cuadrante(INPUT x-longuitud, INPUT x-latitud, OUTPUT x-cuadrante).
    IF x-cuadrante = "" THEN x-cuadrante = "P0".  /*XYZ*/
END.

pMsg = "OK".
/* Resumen */
FIND FIRST ttResumen WHERE  ttResumen.tcuadrante = x-cuadrante NO-ERROR.
IF NOT AVAILABLE ttResumen THEN DO:
    CREATE ttResumen.
        ASSIGN ttResumen.tcuadrante = x-cuadrante.
END.
ASSIGN ttResumen.ttotord = ttResumen.ttotord + 1.

/* Ordenes x Cuadrante */
FIND FIRST ttDetalle WHERE ttDetalle.tcuadrante = x-cuadrante AND
                            ttDetalle.tdivdes = x-faccpedi.divdes AND
                            ttDetalle.tcoddoc = pCodDoc AND
                            ttDetalle.tnroped = pNroDoc NO-ERROR.
IF NOT AVAILABLE ttDEtalle THEN DO:
    CREATE ttDetalle.
    ASSIGN 
        ttDetalle.tdivdes = x-faccpedi.divdes
        ttDetalle.tcuadrante = x-cuadrante
        ttDetalle.tcoddoc = pCodDoc
        ttDetalle.tnroped = pNroDoc
        ttDetalle.tubigeo = x-ubigeo
        ttDetalle.tcodcli = x-faccpedi.codcli
        ttDetalle.tfchped  = x-faccpedi.fchped
        ttDetalle.tfchent  = x-faccpedi.fchent
        ttDetalle.tnomcli = x-faccpedi.nomcli
        .
END.

/* Clientes x Cuadrante */
FIND FIRST ttCliente WHERE ttCliente.tcuadrante = x-cuadrante AND
                            ttCliente.tcodcli = x-faccpedi.codcli NO-ERROR.
IF NOT AVAILABLE ttCliente THEN DO:
    ASSIGN 
        ttResumen.ttotcli = ttResumen.ttotcli + 1.
    /**/
    CREATE ttCliente.
    ASSIGN 
        ttCliente.tcuadrante = x-cuadrante
        ttCliente.tcodcli = x-faccpedi.codcli
    .
END.


/* Clientes x Cuadrante x Pto Despacho */
FIND FIRST ttClientePtoDspcho WHERE ttClientePtoDspcho.tcuadrante = x-cuadrante AND
                            ttClientePtoDspcho.tdivdes = x-faccpedi.divdes AND
                            ttClientePtoDspcho.tcodcli = x-faccpedi.codcli NO-ERROR.
IF NOT AVAILABLE ttClientePtoDspcho THEN DO:
    /**/
    CREATE ttClientePtoDspcho.
    ASSIGN 
        ttClientePtoDspcho.tcuadrante = x-cuadrante
        ttClientePtoDspcho.tdivdes = x-faccpedi.divdes
        ttClientePtoDspcho.tcodcli = x-faccpedi.codcli
    .
END.


/* RHC TOTALES */
/* Totales x Resumen */
ASSIGN 
    ttResumen.ttotpeso = ttResumen.ttotpeso + x-Faccpedi.Peso
    ttResumen.ttotvol = ttResumen.ttotvol + x-Faccpedi.Volumen
    ttResumen.ttotimp = ttResumen.ttotimp + x-Faccpedi.AcuBon[8].
    .
/* Totales de la Orden */
ASSIGN 
    ttDetalle.ttotpeso = ttDetalle.ttotpeso + x-Faccpedi.Peso
    ttDetalle.ttotvol = ttDetalle.ttotvol + x-Faccpedi.Volumen
    ttDetalle.ttotimp = ttDetalle.ttotimp + x-Faccpedi.AcuBon[8]
    ttDetalle.titems = ttDetalle.titems + x-Faccpedi.Items
    .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-procesar-ordenes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-ordenes Procedure 
PROCEDURE procesar-ordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR INIT "OK" NO-UNDO.

/* RHC 28/01/2019 Solo cuando Faccpedi.FlgEst = "P" y Faccpedi.FlgSit = "T" */
DEFINE VAR x-msg AS CHAR.
/* RHC 10/03/2019 Nueva Rutina */

FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                            faccpedi.coddoc = pCodDoc AND
                            faccpedi.nroped = pNroDoc NO-LOCK NO-ERROR.

IF NOT AVAILABLE faccpedi THEN DO:
    pRetVal = "No existe la orden " + pCodDoc + " " + pNroDoc.
    RETURN.
END.
IF Faccpedi.FlgEst = 'P' AND          /* PENDIENTES o CERRADOS */
    (FacCPedi.FlgSit = "T" OR FacCPedi.FlgSit = "TG" ) THEN DO:

    CASE TRUE:
        WHEN Faccpedi.CodDoc = "OTR" THEN DO:
            IF Faccpedi.TpoPed = "INC" THEN DO:
                IF NOT Faccpedi.Glosa BEGINS 'INCIDENCIA: MAL ESTADO' THEN DO:

                    pRetVal = "La orden " + pCodDoc + " " + pNroDoc + " es una INCIDENCIA".
                    RETURN.
                END.
                    
            END.
            IF Faccpedi.TpoPed = "XD" THEN DO:

                pRetVal = "La orden " + pCodDoc + " " + pNroDoc + " tiene el TpoPed = 'XD (Crossdocking)'".
                RETURN.
            END.
                
        END.
        WHEN Faccpedi.CodDoc = "O/D" THEN DO:
            IF Faccpedi.TipVta = "SI"  THEN DO:
                pRetVal = "La orden " + pCodDoc + " " + pNroDoc + " es tramite documentario".
                RETURN.
            END.
                
        END.
    END CASE.
    /* ******************************************************************** */
    /* SOLO SE VAN A ACEPTAR O/D OTR O/M QUE NO TENGAN HISTORIAL EN UNA PHR */
    /* ******************************************************************** */
    IF pSolopruebas = NO THEN DO:
        FOR EACH Di-RutaD NO-LOCK WHERE Di-RutaD.codcia = s-codcia AND
            Di-RutaD.coddiv = Faccpedi.divdes /*s-coddiv*/ AND
            Di-RutaD.coddoc = "PHR" AND
            Di-RutaD.codref = Faccpedi.coddoc AND
            Di-RutaD.nroref = Faccpedi.nroped,
            FIRST Di-RutaC OF Di-RutaD NO-LOCK WHERE Di-RutaC.FlgEst <> "A":
            /* Cabecera */
            IF Di-RutaC.FlgEst BEGINS "P" THEN DO:
                pRetVal = "La orden " + Faccpedi.coddoc + " " + Faccpedi.nroped + " tiene PHR en proceso".
                RETURN.
                /* NEXT RLOOP.   /* NO debe estar en una PHR en PROCESO */ */
            END.

            /* Detalle */
            IF Di-RutaD.FlgEst = "A" THEN NEXT.         /* NO se considera el ANULADO */

            /* Si está REPROGRAMADO se acepta, caso contrario no pasa */
            IF Di-RutaD.FlgEst <> "R" THEN DO:
                pRetVal = "La orden " + Faccpedi.coddoc + " " + Faccpedi.nroped + " Tiene H/R y NO esta REPROGRAMACION". 
                RETURN.
                /* NEXT RLOOP.  /* Otra Orden */ */
            END.

        END.
    END.
    
    /* **************************************************************** */
    /* RHC 12/10/2019 Ninguna que venga por reprogramación */
    /* **************************************************************** */
    FIND FIRST Almcdocu WHERE Almcdocu.codcia = s-codcia AND
        Almcdocu.coddoc = Faccpedi.coddoc AND 
        Almcdocu.nrodoc = Faccpedi.nroped AND
        Almcdocu.codllave = Faccpedi.divdes /*s-coddiv*/ AND
        Almcdocu.libre_c01 = 'H/R' NO-LOCK NO-ERROR.
    IF AVAILABLE Almcdocu THEN DO:

        pRetVal = "La orden " + Faccpedi.coddoc + " " + Faccpedi.nroped + " ya esta REPROGRAMADO". 
        RETURN.

        /*NEXT.*/
    END.
        
    /* **************************************************************** */
        /* Grabar */
        x-msg = "".
        RUN procesar-orden(INPUT Faccpedi.coddoc, INPUT Faccpedi.nroped, OUTPUT x-msg).
        IF x-msg = 'OK' THEN DO:
            x-tot-ordenes-generadas = x-tot-ordenes-generadas + 1.
        END.
        ELSE DO:
            pRetVal = x-msg.
            RETURN.
        END.
END.
ELSE DO:
    pRetVal = "Los estados de la orden " + pCodDoc + " " + pNroDoc + ", deben ser flgest = 'P' y (flgsit = 'T' or flgsit = 'TG') ".
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validar-orden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validar-orden Procedure 
PROCEDURE validar-orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.

DEF BUFFER B-RutaC FOR Di-RutaC.
DEF BUFFER B-RUTAD FOR Di-RutaD.
DEF BUFFER B-RUTAG FOR Di-RutaG.
DEFINE BUFFER x-faccpedi FOR faccpedi.

FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                               x-faccpedi.coddoc = pCoddoc AND 
                                x-faccpedi.nroped = pNroDoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-faccpedi THEN RETURN "ADM-ERROR".

{dist/valida-od-para-phr.i}

/* ****************
/* Está en una PHR en trámite => NO va */
FIND FIRST DI-RutaD WHERE DI-RutaD.CodCia = s-CodCia AND
    DI-RutaD.CodDiv = s-CodDiv AND
    DI-RutaD.CodDoc = "PHR" AND
    DI-RutaD.CodRef = pCodDoc AND
    DI-RutaD.NroRef = pNroDoc AND
    CAN-FIND(DI-RutaC OF DI-RutaD WHERE DI-RutaC.FlgEst BEGINS "P" NO-LOCK)
    NO-LOCK NO-ERROR.
IF AVAILABLE DI-RutaD THEN RETURN 'ADM-ERROR'.

/* Si tiene una reprogramación por aprobar => No va  */
FIND FIRST Almcdocu WHERE AlmCDocu.CodCia = s-CodCia AND
  AlmCDocu.CodLlave = s-CodDiv AND
  AlmCDocu.CodDoc = pCodDoc AND 
  AlmCDocu.NroDoc = pNroDoc AND
  AlmCDocu.FlgEst = "P" NO-LOCK NO-ERROR.
IF AVAILABLE Almcdocu THEN RETURN 'ADM-ERROR'.

/* Si ya fue entregado o tiene una devolución parcial NO va */
FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
  AND CcbCDocu.CodPed = x-Faccpedi.codref       /* PED */
  AND CcbCDocu.NroPed = x-Faccpedi.nroref
  AND Ccbcdocu.Libre_c01 = x-Faccpedi.coddoc    /* O/D */
  AND Ccbcdocu.Libre_c02 = x-Faccpedi.nroped
  AND Ccbcdocu.FlgEst <> "A":
  IF NOT (Ccbcdocu.coddiv = s-coddiv AND Ccbcdocu.coddoc = "G/R") THEN NEXT.
  FOR EACH B-RutaD NO-LOCK WHERE B-RutaD.CodCia = s-codcia
      AND B-RutaD.CodDiv = s-CodDiv
      AND B-RutaD.CodDoc = "H/R"
      AND B-RutaD.CodRef = Ccbcdocu.coddoc
      AND B-RutaD.NroRef = Ccbcdocu.nrodoc,
      FIRST B-RutaC OF B-RutaD NO-LOCK WHERE B-RutaC.FlgEst = 'C':
      IF B-RutaD.FlgEst = "C" THEN RETURN 'ADM-ERROR'.  /* Entregado */
      IF B-RutaD.FlgEst = "D" THEN RETURN 'ADM-ERROR'.  /* Devolución Parcial */

      /* Verificamos que haya pasado por PHR */
      IF NOT CAN-FIND(FIRST DI-RutaD WHERE DI-RutaD.CodCia = s-CodCia AND
                      DI-RutaD.CodDiv = s-CodDiv AND
                      DI-RutaD.CodDoc = "PHR" AND
                      DI-RutaD.CodRef = x-Faccpedi.CodDoc AND
                      DI-RutaD.NroRef = x-Faccpedi.NroPed AND
                      CAN-FIND(DI-RutaC OF DI-RutaD WHERE DI-RutaC.FlgEst = "C" NO-LOCK)
                      NO-LOCK)
          THEN RETURN 'ADM-ERROR'.
  END.
END.

FOR EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = s-CodCia AND 
  Almcmov.CodRef = x-Faccpedi.CodDoc AND 
  Almcmov.NroRef = x-Faccpedi.NroPed AND
  Almcmov.FlgEst <> 'A':
  FOR EACH B-RutaG NO-LOCK WHERE B-RutaG.CodCia = s-codcia
      AND B-RutaG.CodDiv = s-CodDiv
      AND B-RutaG.CodDoc = "H/R"
      AND B-RutaG.CodAlm = Almcmov.CodAlm
      AND B-RutaG.Tipmov = Almcmov.TipMov
      AND B-RutaG.Codmov = Almcmov.CodMov
      AND B-RutaG.SerRef = Almcmov.NroSer
      AND B-RutaG.NroRef = Almcmov.NroDoc,
      FIRST B-RutaC OF B-RutaG NO-LOCK WHERE B-RutaC.FlgEst = 'C':
      IF B-RutaG.FlgEst = "C" THEN RETURN 'ADM-ERROR'.  /* Entregado */
      IF B-RutaG.FlgEst = "D" THEN RETURN 'ADM-ERROR'.  /* Devolución Parcial */
  END.
END.

/* Si está en una H/R en trámite => No va */
FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
  AND CcbCDocu.CodPed = x-Faccpedi.codref       /* PED */
  AND CcbCDocu.NroPed = x-Faccpedi.nroref
  AND Ccbcdocu.Libre_c01 = x-Faccpedi.coddoc    /* O/D */
  AND Ccbcdocu.Libre_c02 = x-Faccpedi.nroped
  AND Ccbcdocu.FlgEst <> "A":
  IF NOT (Ccbcdocu.coddiv = s-coddiv AND Ccbcdocu.coddoc = "G/R") THEN NEXT.
  FOR EACH B-RutaD NO-LOCK WHERE B-RutaD.CodCia = s-codcia
      AND B-RutaD.CodDiv = s-CodDiv
      AND B-RutaD.CodDoc = "H/R"
      AND B-RutaD.CodRef = Ccbcdocu.coddoc
      AND B-RutaD.NroRef = Ccbcdocu.nrodoc,
      FIRST B-RutaC OF B-RutaD NO-LOCK WHERE B-RutaC.FlgEst = 'P':
      RETURN 'ADM-ERROR'.
  END.
END.
FOR EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = s-CodCia AND 
  Almcmov.CodRef = Faccpedi.CodDoc AND 
  Almcmov.NroRef = Faccpedi.NroPed AND
  Almcmov.FlgEst <> 'A':
  FOR EACH B-RutaG NO-LOCK WHERE B-RutaG.CodCia = s-codcia
      AND B-RutaG.CodDiv = s-CodDiv
      AND B-RutaG.CodDoc = "H/R"
      AND B-RutaG.CodAlm = Almcmov.CodAlm
      AND B-RutaG.Tipmov = Almcmov.TipMov
      AND B-RutaG.Codmov = Almcmov.CodMov
      AND B-RutaG.SerRef = Almcmov.NroSer
      AND B-RutaG.NroRef = Almcmov.NroDoc,
      FIRST B-RutaC OF B-RutaG NO-LOCK WHERE B-RutaC.FlgEst BEGINS 'P':
      RETURN 'ADM-ERROR'.
  END.
END.
**************** */

RETURN 'OK'.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-evalua-condicion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION evalua-condicion Procedure 
FUNCTION evalua-condicion RETURNS LOGICAL
  ( INPUT pValor1 AS DEC, INPUT pValor2 AS DEC, INPUT pDato AS DEC, INPUT pCondLogica AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VAR x-retval AS LOG INIT NO.

    IF (pDato >= pValor1 AND pDato <= pValor2) THEN x-retval = YES.

    /*
    IF pCondLogica = '>' THEN DO:
        x-retval = IF (pValor1 > pValor2) THEN YES ELSE NO.
    END.
    IF pCondLogica = '<' THEN DO:
        x-retval = IF (pValor1 < pValor2) THEN YES ELSE NO.
    END.
    IF pCondLogica = '=' THEN DO:
        x-retval = IF (pValor1 = pValor2) THEN YES ELSE NO.
    END.
    IF pCondLogica = '>=' THEN DO:
        x-retval = IF (pValor1 >= pValor2) THEN YES ELSE NO.
    END.
    IF pCondLogica = '<=' THEN DO:            
        x-retval = IF (pValor1 <= pValor2) THEN YES ELSE NO.
    END.
    */

    RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

