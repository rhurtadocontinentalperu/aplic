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
DEF TEMP-TABLE ITEM LIKE Facdpedi.
DEF TEMP-TABLE DETALLE LIKE Facdpedi.
DEF TEMP-TABLE DETALLE-2 LIKE Facdpedi.
DEF TEMP-TABLE DETALLE-3 LIKE Facdpedi.

DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddiv  AS CHAR.

/* Todo parte del Pedido Mostrador, del Pedido al Crédito o de Pedido UTILEX */
/* Necesitamos la tabla donde se ha registrado los productos a vender */
DEFINE INPUT PARAMETER pRowid AS ROWID.
DEFINE INPUT PARAMETER pFormatoTck AS LOG.
DEFINE INPUT PARAMETER pImprimeDirecto AS LOG.
DEFINE INPUT PARAMETER pNombreImpresora AS CHAR.

FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN.

DEFINE VAR cImprimeDirecto AS CHAR INIT "No" NO-UNDO.
FIND Gn-Divi WHERE Gn-Divi.codcia = s-codcia
    AND Gn-Divi.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
IF AVAILABLE Gn-Divi THEN 
    ASSIGN 
        cImprimeDirecto = GN-DIVI.Campo-Char[7].    /* OJO */

DEF BUFFER B-DTABLA FOR Vtadtabla.
DEF BUFFER B-DTABLA2 FOR Vtadtabla.
DEF BUFFER B-DTABLA3 FOR Vtadtabla.

DEF VAR x-ImpTot LIKE Faccpedi.imptot INIT 0 NO-UNDO.
FOR EACH Facdpedi OF Faccpedi NO-LOCK:
    x-ImpTot = x-ImpTot + Facdpedi.ImpLin.
    CREATE ITEM.
    BUFFER-COPY Facdpedi TO ITEM.
END.

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

DEFINE VAR s-task-no AS INT NO-UNDO.

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
         HEIGHT             = 8.12
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}

/* _UIB-CODE-BLOCK-END */
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
        ITEM.Libre_D02 = 0
        ITEM.Libre_C02 = "".    /* Control de productos afectos a promoción */
END.

/* RHC 01/04/2016 Usuario SYS solo para hacer pruebas */
FOR EACH Vtactabla NO-LOCK WHERE Vtactabla.codcia = Faccpedi.codcia
    AND VtaCTabla.Tabla = "PROMCRUZ"
    AND VtaCTabla.Estado = "A"      /* Activa */
    AND (Faccpedi.CodCli BEGINS 'SYS' OR (TODAY >= VtaCTabla.FechaInicial AND TODAY <= VtaCTabla.FechaFinal))
    AND LOOKUP(Vtactabla.Libre_c01, 'Unidades,Soles') > 0
    AND VtaCTabla.Libre_d01 > 0
    AND CAN-FIND(FIRST Vtadtabla OF Vtactabla WHERE Vtadtabla.tipo = "D"    /* División */
                 AND VtaDTabla.LlaveDetalle = Faccpedi.coddiv 
                 AND ((Faccpedi.CodDoc = "P/M" AND VtaDTabla.Libre_l01 = YES)
                      OR (LOOKUP(Faccpedi.CodDoc, "PED,COT") > 0 AND VtaDTabla.Libre_l02 = YES))
                 NO-LOCK):
    /* Trabajamos con esta promoción */
    EMPTY TEMP-TABLE Promocion.

    RUN Carga-Promocion.

    RUN Graba-Promocion.
    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
END.

RUN Imprime-Promocion.

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
/*
*/
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
/*
*/
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
/* Verificamos que tenga al menos una línea de impresión definida */
FIND FIRST B-DTABLA OF Vtactabla WHERE B-DTABLA.Tipo = "TEXT" NO-LOCK NO-ERROR.
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

/* Acumulamos Importes y Cantidades */
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
DEFINE VARIABLE x-Flete AS DEC NO-UNDO.

/* ************************************************************************************************ */
/* ******************* PRIMER PASO: CARGAMOS LA TABLA TEMPORAL DE PROMOCIONES ********************* */
/* ************************************************************************************************ */
IF VtaCTabla.Libre_d01 > 0 THEN DO:
    IF Vtactabla.Libre_c01 = "Soles" AND x-AcumulaImportes < VtaCTabla.Libre_d01 THEN RETURN "OK".
    IF Vtactabla.Libre_c01 = "Unidades" AND x-AcumulaCantidades < VtaCTabla.Libre_d01 THEN RETURN "OK".
END.
FOR EACH Vtadtabla OF Vtactabla NO-LOCK WHERE Vtadtabla.Tipo = "TEXT":
    CREATE Promocion.
    BUFFER-COPY Vtadtabla TO Promocion.
END.
/* ************************************************************************************************ */
/* ************************************************************************************************ */
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Imprime-Promocion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Promocion Procedure 
PROCEDURE Imprime-Promocion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Veamos si hay promociones */
IF NOT CAN-FIND(FIRST Promocion NO-LOCK) THEN RETURN.

DEF VAR x-Indice AS INT NO-UNDO.

s-task-no = 0.
FOR EACH Promocion NO-LOCK BREAK BY Promocion.Llave BY Promocion.LlaveDetalle:
    IF s-task-no = 0 THEN REPEAT:
        s-task-no = RANDOM(1,999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK) THEN LEAVE.
    END.
    IF FIRST-OF(Promocion.Llave) THEN DO:
        CREATE w-report.
        ASSIGN 
            w-report.task-no = s-task-no
            w-report.llave-c = Promocion.Llave.
    END.
    ASSIGN x-Indice = INTEGER(Promocion.LlaveDetalle) NO-ERROR.
    IF ERROR-STATUS:ERROR = YES OR x-Indice > 30 THEN NEXT.
    ASSIGN
        w-report.Campo-C[x-Indice] = Promocion.Libre_c01.
END.

DEFINE VAR lImpresora AS CHAR INIT "".
DEFINE VAR lPuerto AS CHAR INIT "".
DEFINE VAR x-filer AS CHAR.

DEFINE VAR x-terminal-server AS LOG.

/* se esta ejecutando en TERMINAL Server ?*/
RUN lib/_es-terminal-server.p(OUTPUT x-terminal-server).

FIND FIRST ccbdterm WHERE
    CcbDTerm.CodCia = Faccpedi.codcia AND
    CcbDTerm.CodDiv = Faccpedi.coddiv AND
    CcbDTerm.CodDoc = Faccpedi.Cmpbnte AND
    CcbDTerm.CodTer = s-codter 
    NO-LOCK NO-ERROR.
FIND FacCorre WHERE FacCorre.CodCia = Faccpedi.codcia AND 
    FacCorre.CodDiv = Faccpedi.coddiv AND
    FacCorre.CodDoc = Faccpedi.Cmpbnte AND
    FacCorre.NroSer = Ccbdterm.nroser 
    NO-LOCK NO-ERROR.
/* Suspendido temporalmente.....?????? */
x-terminal-server = NO.
CASE TRUE:
    WHEN pImprimeDirecto = YES AND LOOKUP(cImprimeDirecto, 'Si,Yes') > 0 THEN DO:
        IF x-terminal-server = YES THEN DO:

            IF pNombreImpresora > "" THEN DO:
                lImpresora = pNombreImpresora.
            END.
            ELSE DO:
                IF AVAILABLE FacCorre THEN lImpresora = FacCorre.Printer.
            END.    

            /* Ubicar la impresora en el terminal server */
            RUN lib/_impresora-terminal-server.p(INPUT-OUTPUT lImpresora, OUTPUT lPuerto).

            /* */
            IF lImpresora <> "" THEN s-port-name = lImpresora.
        END.
        /* Si no ubico la impresora en el terminal server, ubical la impresora predeterminada */
        IF lImpresora = ""  THEN DO:
            /* 1 */
            DEF VAR success AS LOGICAL.
            /* 2 Capturo la impresora por defecto */
            RUN lib/_default_printer.p (OUTPUT s-printer-name, OUTPUT s-port-name, OUTPUT success).
            /* 3 */
            IF success = NO THEN DO:
                MESSAGE "NO hay una impresora por defecto definida" VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
            /* 4 De acuerdo al sistema operativo transformamos el puerto de impresión */
            RUN lib/_port-name-v2.p (s-Printer-Name, OUTPUT s-Port-Name).
        END.
    END.
    OTHERWISE DO:
        IF x-terminal-server = YES THEN DO:
            IF pNombreImpresora > "" THEN DO:
                lImpresora = pNombreImpresora.
            END.
            ELSE DO:
                IF AVAILABLE FacCorre THEN lImpresora = FacCorre.Printer.
            END.    

            /* Ubicar la impresora en el terminal server */
            RUN lib/_impresora-terminal-server.p(INPUT-OUTPUT lImpresora, OUTPUT lPuerto).

            /* */
            IF lImpresora <> "" THEN s-port-name = lImpresora.
        END.
        /* Si no ubico la impresora en el terminal server, ubical la impresora predeterminada */
        IF lImpresora = ""  THEN DO:
            /* Si se envía un nombre se toma ese, si no se toma el de la tabla de correlativos */
            IF pNombreImpresora > "" THEN DO:
                s-printer-name = pNombreImpresora.
            END.
            ELSE DO:
                IF AVAILABLE FacCorre THEN s-printer-name = FacCorre.Printer.
            END.    

            IF pImprimeDirecto = YES AND s-printer-name > "" THEN DO:
                RUN lib/_port-name-v2.p (s-printer-name, OUTPUT s-port-name).
                IF s-port-name = '' THEN DO:
                    MESSAGE 'NO está definida la impresora por defecto' SKIP
                        'División:' Ccbcdocu.coddiv SKIP
                        'Documento:' Ccbcdocu.coddoc SKIP
                        'N° Serie:' SUBSTRING(CcbCDocu.NroDoc, 1, 3) SKIP
                        'Impresora:' FacCorre.PRINTER '<<<'
                        VIEW-AS ALERT-BOX WARNING.
                    RETURN.
                END.
            END.
            ELSE DO:
                RUN bin/_prnctr.p.
                IF s-salida-impresion = 0 THEN RETURN.
                RUN lib/_port-name-v2.p (s-printer-name, OUTPUT s-port-name).
            END.
        END.
    END.
END CASE.

DEF VAR RB-REPORT-LIBRARY AS CHAR.
DEF VAR RB-REPORT-NAME AS CHAR.
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "vta2/rbutilex.prl".
RB-REPORT-NAME = "Promocion Cruzada".
RB-INCLUDE-RECORDS = "O".
RB-FILTER = " w-report.task-no = " + STRING(s-task-no).

DEFINE VARIABLE cDatabaseName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cHostName        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNetworkProto    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPortNumber      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cOtherParams     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNewConnString   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDelimeter       AS CHARACTER NO-UNDO.

GET-KEY-VALUE SECTION "RBParametros" KEY "cDatabaseName" VALUE cDatabaseName.
GET-KEY-VALUE SECTION "RBParametros" KEY "cHostName" VALUE cHostName.
GET-KEY-VALUE SECTION "RBParametros" KEY "cNetworkProto" VALUE cNetworkProto.
GET-KEY-VALUE SECTION "RBParametros" KEY "cPortNumber" VALUE cPortNumber.
GET-KEY-VALUE SECTION "RBParametros" KEY "cOtherParams" VALUE cOtherParams.

ASSIGN cDelimeter = CHR(32).
IF NOT (cDatabaseName = ? OR cHostName = ? OR cNetworkProto = ? OR cPortNumber = ?) THEN DO:
   ASSIGN
       cNewConnString =
       "-db" + cDelimeter + cDatabaseName + cDelimeter +
       "-H" + cDelimeter + cHostName + cDelimeter +
       "-N" + cDelimeter + cNetworkProto + cDelimeter +
       "-S" + cDelimeter + cPortNumber + cDelimeter.
   IF cOtherParams > '' THEN cNewConnString = cNewConnString + cOtherParams + cDelimeter.
   RB-DB-CONNECTION = cNewConnString.
END.

ASSIGN
    RB-BEGIN-PAGE = s-pagina-inicial
    RB-END-PAGE = s-pagina-final
    RB-PRINTER-NAME = s-port-name       /*s-printer-name*/
    RB-OUTPUT-FILE = s-print-file
    RB-NUMBER-COPIES = s-nro-copias.
CASE s-salida-impresion:
  WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
  WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
  WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
END CASE.

RUN aderb/_prntrb2 (RB-REPORT-LIBRARY,
                  RB-REPORT-NAME,
                  RB-DB-CONNECTION,
                  RB-INCLUDE-RECORDS,
                  RB-FILTER,
                  RB-MEMO-FILE,
                  RB-PRINT-DESTINATION,
                  RB-PRINTER-NAME,
                  RB-PRINTER-PORT,
                  RB-OUTPUT-FILE,
                  RB-NUMBER-COPIES,
                  RB-BEGIN-PAGE,
                  RB-END-PAGE,
                  RB-TEST-PATTERN,
                  RB-WINDOW-TITLE,
                  RB-DISPLAY-ERRORS,
                  RB-DISPLAY-STATUS,
                  RB-NO-WAIT,
                  RB-OTHER-PARAMETERS,
                  "").

/* Borar el temporal */

DEF BUFFER B-w-report FOR w-report.
DEFINE VAR lRowId AS ROWID.

FOR EACH w-report WHERE w-report.task-no = s-task-no NO-LOCK:
    lRowId = ROWID(w-report).
    FIND FIRST b-w-report WHERE ROWID(b-w-report) = lRowid EXCLUSIVE NO-ERROR.
    IF AVAILABLE b-w-report THEN DO:
        DELETE b-w-report.            
    END.    
END.
RELEASE B-w-report.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

