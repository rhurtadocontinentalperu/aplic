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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF TEMP-TABLE Detalle
    FIELD FchDoc AS DATE
    FIELD CanDes AS DEC
    INDEX Llave01 AS PRIMARY FchDoc.

DEF INPUT PARAMETER pFchIni AS DATE.
DEF INPUT PARAMETER pFchFin AS DATE.
DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF OUTPUT PARAMETER pVtaPromedio AS DEC.

DEF SHARED VAR s-codcia AS INT.

DEF VAR x-Items AS INT NO-UNDO.
DEF VAR x-Promedio AS DEC NO-UNDO.
DEF VAR x-Desviacion AS DEC NO-UNDO.
DEF VAR x-Fecha AS DATE NO-UNDO.
DEF VAR x-Factor AS DEC NO-UNDO.


/* CALCULO ESTADISTICO DE LAS VENTAS DIARIAS */
FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = pCodAlm
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almacen THEN RETURN.


FOR EACH Detalle:
    DELETE Detalle.
END.

/* PRIMERA PASADA */
ASSIGN
    x-Factor = 1
    pVtaPromedio = 0.
RUN Carga-Temporal.

/* SEGUNDA PASADA: CARGAMOS LAS VENTAS POR EL CODIGO EQUIVALENTE */
FIND Vtapmatg WHERE Vtapmatg.codcia = s-codcia
    AND Vtapmatg.codmat = pCodMat
    NO-LOCK NO-ERROR.
IF AVAILABLE Vtapmatg AND Vtapmatg.Tipo = "E" AND Vtapmatg.codequ <> "" AND Vtapmatg.factor <> 0 THEN DO:
    ASSIGN
        x-Factor = Vtapmatg.Factor
        pCodMat = Vtapmatg.codequ.
    RUN Carga-Temporal.
END.

/* Desviacion estandar */
ASSIGN
    x-Items = 0
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Carga-Temporal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal Procedure 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR X-CODDIA AS INTEGER NO-UNDO INIT 1.
DEFINE VAR X-CODANO AS INTEGER NO-UNDO.
DEFINE VAR X-CODMES AS INTEGER NO-UNDO.
DEFINE VAR I        AS INTEGER NO-UNDO.

FOR EACH estavtas.EvtArtDv NO-LOCK WHERE estavtas.EvtArtDv.codcia = s-codcia
        AND estavtas.EvtArtDv.coddiv = Almacen.coddiv
        AND estavtas.EvtArtDv.codmat = pCodMat
        AND ( estavtas.EvtArtDv.Nrofch >= INTEGER(STRING(YEAR(pFchIni),"9999") + STRING(MONTH(pFchIni),"99"))
        AND   estavtas.EvtArtDv.Nrofch <= INTEGER(STRING(YEAR(pFchFin),"9999") + STRING(MONTH(pFchFin),"99")) ):
    /***************** Capturando el Mes siguiente *******************/
    IF estavtas.EvtArtDv.Codmes < 12 THEN DO:
      ASSIGN
          X-CODMES = estavtas.EvtArtDv.Codmes + 1
          X-CODANO = estavtas.EvtArtDv.Codano .
    END.
    ELSE DO: 
      ASSIGN
          X-CODMES = 01
          X-CODANO = estavtas.EvtArtDv.Codano + 1 .
    END.
    /*********************** Calculo Para Obtener los datos diarios ************/
     DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
          X-FECHA = DATE(STRING(I,"99") + "/" + STRING(estavtas.EvtArtDv.Codmes,"99") + "/" + STRING(estavtas.EvtArtDv.Codano,"9999")).
          IF X-FECHA >= pFchIni AND X-FECHA <= pFchFin THEN DO:
              FIND Gn-tcmb WHERE Gn-tcmb.Fecha = DATE(STRING(I,"99") + "/" + STRING(estavtas.EvtArtDv.Codmes,"99") + "/" + STRING(estavtas.EvtArtDv.Codano,"9999")) 
                  NO-LOCK NO-ERROR.
              IF AVAILABLE Gn-tcmb THEN DO: 
                  FIND Detalle WHERE Detalle.FchDoc = X-FECHA NO-ERROR.
                  IF NOT AVAILABLE Detalle THEN CREATE Detalle.
                  ASSIGN
                      Detalle.fchdoc = X-FECHA
                      Detalle.candes = Detalle.candes + estavtas.EvtArtDv.CanxDia[I] * x-Factor.
              END.
          END.
     END.         
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

