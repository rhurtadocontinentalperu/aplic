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
         HEIGHT             = 3.69
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pDiasUtiles AS INT.
DEF INPUT PARAMETER pAlmacenes AS CHAR.
DEF OUTPUT PARAMETER pVentaDiaria AS DEC.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR pv-codcia AS INT.

DEF TEMP-TABLE Detalle
    FIELD FchDoc AS DATE
    FIELD CanDes AS DEC
    INDEX Llave01 AS PRIMARY FchDoc.

FIND Almmmate WHERE ROWID(Almmmate) = pRowid
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmate THEN RETURN.
FIND Vtapmatg OF Almmmatg NO-LOCK NO-ERROR.

FIND Almmmatg OF Almmmate NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.

/* determinamos las fechas de venta */
DEF VAR x-FchIni-Ant AS DATE NO-UNDO.
DEF VAR x-FchFin-Ant AS DATE NO-UNDO.
DEF VAR x-FchIni-Hoy AS DATE NO-UNDO.
DEF VAR x-FchFin-Hoy AS DATE NO-UNDO.
DEF VAR x-Venta-Ant AS DEC NO-UNDO.
DEF VAR x-Venta-Hoy AS DEC NO-UNDO.
DEF VAR x-Venta-Mes AS DEC NO-UNDO.
DEF VAR pVentaPromedio AS DEC NO-UNDO.

DEF VAR x-Mes AS INT NO-UNDO.
DEF VAR x-Ano AS INT NO-UNDO.
DEF VAR x-Meses AS INT INIT 3 NO-UNDO.      /* Meses de estudio estadístico */

/* *** PRIMERA PASADA *** */
/* rango del año pasado */
x-FchFin-Ant = TODAY - 365.
x-FchIni-Ant = x-FchFin-Ant - x-Meses * 30.

/*RUN Venta-Diaria-Promedio-Estadistica (x-FchIni-Ant, x-FchFin-Ant, OUTPUT x-Venta-Ant).*/
RUN vtagn/ventas-promedio-01 (x-FchIni-Ant, x-FchFin-Ant, Almmmate.CodAlm, Almmmatg.CodMat, OUTPUT pVentaPromedio).
x-Venta-Ant = pVentaPromedio.
IF AVAILABLE Vtapmatg AND Vtapmatg.tipo = "E" AND Vtapmatg.codequ <> '' AND Vtapmatg.factor <> 0 THEN DO:
    RUN vtagn/ventas-promedio-01 (x-FchIni-Ant, x-FchFin-Ant, Almmmate.CodAlm, Vtapmatg.CodEqu, OUTPUT pVentaPromedio).
    x-Venta-Ant = x-Venta-Ant + pVentaPromedio * Vtapmatg.Factor.
END.

/* rango del presente año */
x-FchFin-Hoy = TODAY.
x-FchIni-Hoy = x-FchFin-Hoy - x-Meses * 30.

/*RUN Venta-Diaria-Promedio-Estadistica (x-FchIni-Hoy, x-FchFin-Hoy, OUTPUT x-Venta-Hoy).*/
RUN vtagn/ventas-promedio-01 (x-FchIni-Hoy, x-FchFin-Hoy, Almmmate.CodAlm, Almmmatg.CodMat, OUTPUT pVentaPromedio).
x-Venta-Hoy = pVentaPromedio.
IF AVAILABLE Vtapmatg AND Vtapmatg.tipo = "E" AND Vtapmatg.codequ <> '' AND Vtapmatg.factor <> 0 THEN DO:
    RUN vtagn/ventas-promedio-01 (x-FchIni-Hoy, x-FchFin-Hoy, Almmmate.CodAlm, Vtapmatg.CodEqu, OUTPUT pVentaPromedio).
    x-Venta-Hoy = x-Venta-Hoy + pVentaPromedio * Vtapmatg.Factor.
END.

/* Salidas por ventas del presente mes año pasado */
x-FchFin-Ant = TODAY - 365.
x-FchIni-Ant = x-FchFin-Ant - 30.

/*RUN Venta-Diaria-Promedio-Estadistica (x-FchIni-Ant, x-FchFin-Ant, OUTPUT x-Venta-Mes).*/
RUN vtagn/ventas-promedio-01 (x-FchIni-Ant, x-FchFin-Ant, Almmmate.CodAlm, Almmmatg.CodMat, OUTPUT pVentaPromedio).
x-Venta-Mes = pVentaPromedio.
IF AVAILABLE Vtapmatg AND Vtapmatg.tipo = "E" AND Vtapmatg.codequ <> '' AND Vtapmatg.factor <> 0 THEN DO:
    RUN vtagn/ventas-promedio-01 (x-FchIni-Ant, x-FchFin-Ant, Almmmate.CodAlm, Vtapmatg.CodEqu, OUTPUT pVentaPromedio).
    x-Venta-Mes = x-Venta-Mes + pVentaPromedio * Vtapmatg.Factor.
END.

IF x-Venta-Ant <= 0 THEN DO:
    pVentaDiaria = x-Venta-Hoy.
    RETURN.
END.
IF ( x-Venta-Hoy / x-Venta-Ant ) > 3 OR ( x-Venta-Hoy / x-Venta-Ant ) < (1 / 3) THEN DO: 
    pVentaDiaria = x-Venta-Hoy.
    RETURN.
END.
IF ( x-Venta-Hoy / x-Venta-Mes ) > 3 OR ( x-Venta-Hoy / x-Venta-Mes ) < (1 / 3) THEN DO: 
    pVentaDiaria = x-Venta-Hoy.
    RETURN.
END.
pVentaDiaria = x-Venta-Hoy / x-Venta-Ant * x-Venta-Mes.

RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Venta-Diaria-Promedio) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Venta-Diaria-Promedio Procedure 
PROCEDURE Venta-Diaria-Promedio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pFchIni AS DATE.
DEF INPUT PARAMETER pFchFin AS DATE.
DEF OUTPUT PARAMETER pVtaPromedio AS DEC.

DEF VAR x-Items AS INT NO-UNDO.
DEF VAR x-Promedio AS DEC NO-UNDO.
DEF VAR x-Desviacion AS DEC NO-UNDO.
DEF VAR x-Almacenes AS CHAR NO-UNDO.
DEF VAR x-Fecha AS DATE NO-UNDO.
DEF VAR k AS INT NO-UNDO.

/* CALCULO ESTADISTICO DE LAS VENTAS DIARIAS */
pVtaPromedio = 0.

FOR EACH Detalle:
    DELETE Detalle.
END.

/* Buscamos las ventas de todos los almacenes involucrados */
x-Almacenes = Almmmate.CodAlm.
DO k = 1 TO NUM-ENTRIES(pAlmacenes):
    IF ENTRY(k, pAlmacenes) <> Almmmate.CodAlm 
    THEN x-Almacenes = TRIM(x-Almacenes) + ',' + ENTRY(k, pAlmacenes).
END.
/* Ventas de TODOS los almacenes */
DO k = 1 TO NUM-ENTRIES(x-Almacenes):
    FOR EACH almdmov USE-INDEX almd03 NO-LOCK WHERE almdmov.codcia = s-codcia
        AND almdmov.codalm = ENTRY(k, x-Almacenes)
        AND almdmov.codmat = almmmate.codmat
        AND almdmov.fchdoc >= pFchIni
        AND almdmov.fchdoc <= pFchFin
        AND almdmov.tipmov = 'S'
        AND almdmov.codmov = 02,     /* Ventas */
        FIRST almcmov OF almdmov NO-LOCK WHERE almcmov.flgest <> 'A':  /* NO anuladas */
        FIND Detalle WHERE Detalle.FchDoc = Almdmov.fchdoc NO-ERROR.
        IF NOT AVAILABLE Detalle THEN CREATE Detalle.
        ASSIGN
            Detalle.fchdoc = Almdmov.fchdoc
            Detalle.candes = Detalle.candes + almdmov.candes * almdmov.factor.
    END.
/*     IF almmmatg.codant <> '' THEN DO:   /* Ventas por el codigo equivalente */               */
/*         FOR EACH almdmov USE-INDEX almd03 NO-LOCK WHERE almdmov.codcia = s-codcia            */
/*             AND almdmov.codalm = ENTRY(k, x-Almacenes)                                       */
/*             AND almdmov.tipmov = 'S'                                                         */
/*             AND almdmov.codmov = 02     /* Ventas */                                         */
/*             AND almdmov.fchdoc >= pFchIni                                                    */
/*             AND almdmov.fchdoc <= pFchFin                                                    */
/*             AND almdmov.codmat = almmmatg.codant,                                            */
/*             FIRST almcmov OF almdmov NO-LOCK WHERE almcmov.flgest <> 'A':  /* NO anuladas */ */
/*             FIND Detalle WHERE Detalle.FchDoc = Almdmov.fchdoc NO-ERROR.                     */
/*             IF NOT AVAILABLE Detalle THEN CREATE Detalle.                                    */
/*             ASSIGN                                                                           */
/*                 Detalle.fchdoc = Almdmov.fchdoc                                              */
/*                 Detalle.candes = Detalle.candes + almdmov.candes * almdmov.factor.           */
/*         END.                                                                                 */
/*     END.                                                                                     */
END.
/* Desviacion estandar */
x-Items = 0.
x-Promedio = 0.
DO x-Fecha = pFchIni TO pFchFin:
    FIND Detalle WHERE Detalle.fchdoc = x-Fecha NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle AND WEEKDAY(x-Fecha) = 1 THEN NEXT.    /* DOMINGO SIN VENTA */
    x-Items = x-Items + 1.
    IF AVAILABLE Detalle THEN x-Promedio = x-Promedio + Detalle.candes.
END.
x-Promedio = x-Promedio / x-Items.

DO x-Fecha = pFchIni TO pFchFin:
    FIND Detalle WHERE Detalle.fchdoc = x-Fecha NO-LOCK NO-ERROR.
    IF AVAILABLE Detalle 
    THEN x-Desviacion = x-Desviacion + EXP( ( Detalle.CanDes - x-Promedio ) , 2 ).
    ELSE x-Desviacion = x-Desviacion + EXP( ( 0 - x-Promedio ) , 2 ).
END.
x-Desviacion = SQRT ( x-Desviacion / ( x-Items - 1 ) ).

/* Eliminamos los items que están fuera de rango */
FOR EACH Detalle:
    IF Detalle.candes > (x-Promedio + 3 * x-Desviacion) OR Detalle.candes < (x-Promedio - 3 * x-Desviacion) 
    THEN DO:
        DELETE Detalle.
        x-Items = x-Items - 1.
    END.
END.
x-Promedio = 0.
FOR EACH Detalle:
    x-Promedio = x-Promedio + Detalle.candes.
END.
pVtaPromedio = x-Promedio / x-Items.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Venta-Diaria-Promedio-Estadistica) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Venta-Diaria-Promedio-Estadistica Procedure 
PROCEDURE Venta-Diaria-Promedio-Estadistica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pFchIni AS DATE.
DEF INPUT PARAMETER pFchFin AS DATE.
DEF OUTPUT PARAMETER pVtaPromedio AS DEC.

DEF VAR x-Items AS INT NO-UNDO.
DEF VAR x-Promedio AS DEC NO-UNDO.
DEF VAR x-Desviacion AS DEC NO-UNDO.
DEF VAR x-Fecha AS DATE NO-UNDO.

DEFINE VAR X-CODDIA AS INTEGER INIT 1 NO-UNDO.
DEFINE VAR X-CODANO AS INTEGER NO-UNDO.
DEFINE VAR X-CODMES AS INTEGER NO-UNDO.
DEFINE VAR I        AS INTEGER NO-UNDO.

/* CALCULO ESTADISTICO DE LAS VENTAS DIARIAS */
pVtaPromedio = 0.

FOR EACH Detalle:
    DELETE Detalle.
END.

FOR EACH integral.EvtArti USE-INDEX Llave01 NO-LOCK WHERE integral.EvtArti.codcia = s-codcia
        AND integral.EvtArti.coddiv = s-coddiv
        AND integral.EvtArti.codmat = Almmmate.codmat
        AND ( integral.EvtArti.Nrofch >= INTEGER(STRING(YEAR(pFchIni),"9999") + STRING(MONTH(pFchIni),"99"))
        AND   integral.EvtArti.Nrofch <= INTEGER(STRING(YEAR(pFchFin),"9999") + STRING(MONTH(pFchFin),"99")) ):
    /***************** Capturando el Mes siguiente *******************/
    IF integral.EvtArti.Codmes < 12 THEN DO:
      ASSIGN
          X-CODMES = integral.EvtArti.Codmes + 1
          X-CODANO = integral.EvtArti.Codano .
    END.
    ELSE DO: 
      ASSIGN
          X-CODMES = 01
          X-CODANO = integral.EvtArti.Codano + 1 .
    END.
    /*********************** Calculo Para Obtener los datos diarios ************/
     DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
          X-FECHA = DATE(STRING(I,"99") + "/" + STRING(integral.EvtArti.Codmes,"99") + "/" + STRING(integral.EvtArti.Codano,"9999")).
          IF X-FECHA >= pFchIni AND X-FECHA <= pFchFin THEN DO:
              FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(integral.EvtArti.Codmes,"99") + "/" + STRING(integral.EvtArti.Codano,"9999")) 
                  NO-LOCK NO-ERROR.
              IF AVAILABLE Gn-tcmb THEN DO: 
                  FIND Detalle WHERE Detalle.FchDoc = X-FECHA NO-ERROR.
                  IF NOT AVAILABLE Detalle THEN CREATE Detalle.
                  ASSIGN
                      Detalle.fchdoc = X-FECHA
                      Detalle.candes = Detalle.candes + integral.EvtArti.CanxDia[I].
              END.
          END.
     END.         
END.

/* Desviacion estandar */
x-Items = 0.
x-Promedio = 0.
DO x-Fecha = pFchIni TO pFchFin:
    FIND Detalle WHERE Detalle.fchdoc = x-Fecha NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle AND WEEKDAY(x-Fecha) = 1 THEN NEXT.    /* DOMINGO SIN VENTA */
    x-Items = x-Items + 1.
    IF AVAILABLE Detalle THEN x-Promedio = x-Promedio + Detalle.candes.
END.
x-Promedio = x-Promedio / x-Items.

DO x-Fecha = pFchIni TO pFchFin:
    FIND Detalle WHERE Detalle.fchdoc = x-Fecha NO-LOCK NO-ERROR.
    IF AVAILABLE Detalle 
    THEN x-Desviacion = x-Desviacion + EXP( ( Detalle.CanDes - x-Promedio ) , 2 ).
    ELSE x-Desviacion = x-Desviacion + EXP( ( 0 - x-Promedio ) , 2 ).
END.
x-Desviacion = SQRT ( x-Desviacion / ( x-Items - 1 ) ).

/* Eliminamos los items que están fuera de rango */
FOR EACH Detalle:
    IF Detalle.candes > (x-Promedio + 3 * x-Desviacion) OR Detalle.candes < (x-Promedio - 3 * x-Desviacion) 
    THEN DO:
        DELETE Detalle.
        x-Items = x-Items - 1.
    END.
END.
x-Promedio = 0.
FOR EACH Detalle:
    x-Promedio = x-Promedio + Detalle.candes.
END.
pVtaPromedio = x-Promedio / x-Items.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

