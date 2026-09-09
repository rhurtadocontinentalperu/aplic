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
         HEIGHT             = 5.85
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE TEMP-TABLE ITEM LIKE Facdpedi.

DEF INPUT PARAMETER pPromocion AS CHAR.
DEF INPUT-OUTPUT PARAMETER TABLE FOR ITEM.

/* RHC 30.01.2023 Por ahora no hace nada */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-porigv AS DEC.
DEF SHARED VAR s-codmon AS INT.
DEF SHARED VAR s-tpocmb AS DEC.

/* ASUMIMOS EL ALMACEN DEL DETALLE */
DEF VAR pCodAlm AS CHAR NO-UNDO.

CASE pPromocion:
    WHEN "MITZY" THEN DO:
            RUN MITZY.
    END.
    WHEN "AVENGER" THEN DO:
            RUN AVENGER.
    END.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Avenger) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Avenger Procedure 
PROCEDURE Avenger :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-ListaMat  AS CHAR     NO-UNDO.
DEF VAR k           AS INT      NO-UNDO.
DEF VAR x-CodMat    AS CHAR     NO-UNDO.
DEF VAR x-CanPed    AS DEC      NO-UNDO.
DEF VAR x-CodProm   AS CHAR     NO-UNDO.
DEF VAR x-PreUni    AS DEC      NO-UNDO.
DEF VAR x-Promociones   AS DEC  NO-UNDO.
DEF VAR x-Ok        AS CHAR     NO-UNDO.
DEF VAR x-NroItm    AS INT      NO-UNDO.

ASSIGN
    x-CodProm       = "059567"
    x-PreUni        = 0.7
    x-Promociones   = 0
    x-CanPed        = 0
    x-ListaMat      = "044992,044993,044994".
FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = x-CodProm
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.
DO k = 1 TO NUM-ENTRIES(x-ListaMat):
    x-CodMat = ENTRY(k, x-ListaMat).
    /* buscamos la cantidad vendida */
    FIND FIRST ITEM WHERE ITEM.codmat = x-CodMat NO-LOCK NO-ERROR.
    IF AVAILABLE ITEM THEN DO:
        x-CanPed = x-CanPed + ITEM.CanPed * ITEM.Factor.
    END.
END.
IF x-CanPed >= 50 THEN x-Promociones = TRUNCATE(x-CanPed / 50, 0).

FIND FIRST ITEM WHERE ITEM.codmat = x-CodProm NO-LOCK NO-ERROR.
IF NOT AVAILABLE ITEM AND x-Promociones > 0 THEN DO:
    /* CONFIRMAMOS CUANTAS PROMOCIONES QUIERE LLEVARSE */
    /*RUN vtamay/d-promociones-manuales (x-CodProm, INPUT-OUTPUT x-Promociones, OUTPUT x-Ok).*/
    RUN vta2/dpromocionesopcionales (x-CodProm, x-PreUni, INPUT-OUTPUT x-Promociones, OUTPUT x-Ok).
    IF x-Ok <> "ADM-ERROR" AND x-Promociones > 0 THEN DO:
        /* Marcamos los productos promocionados */
        DO k = 1 TO NUM-ENTRIES(x-ListaMat):
            x-CodMat = ENTRY(k, x-ListaMat).
            /* buscamos la cantidad vendida */
            FIND FIRST ITEM WHERE ITEM.codmat = x-CodMat NO-LOCK NO-ERROR.
            IF AVAILABLE ITEM THEN DO:
                ASSIGN
                    ITEM.Libre_c05 = "PROM".
            END.
        END.
        /* Creamos la promocion */
        CREATE ITEM.
        ASSIGN
            ITEM.CodCia = s-CodCia
            ITEM.NroItm = x-NroItm + 1
            ITEM.AlmDes = ENTRY(1, s-CodAlm)
            ITEM.CodMat = x-CodProm
            ITEM.CanPed = x-Promociones
            ITEM.PreUni = x-PreUni
            ITEM.UndVta = Almmmatg.UndStk
            ITEM.Factor = 1
            ITEM.Libre_c05 = 'OF'.
        ASSIGN
            ITEM.AftIgv = Almmmatg.AftIgv
            ITEM.AftIsc = Almmmatg.AftIsc.
        ASSIGN
            ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni *
                          ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                          ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                          ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
        IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0
            THEN ITEM.ImpDto = 0.
            ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
        ASSIGN
            ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
            ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
        IF ITEM.AftIsc
        THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
        ELSE ITEM.ImpIsc = 0.
        IF ITEM.AftIgv
        THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
        ELSE ITEM.ImpIgv = 0.
    END.
    ELSE DO:
        /* DesMarcamos los productos promocionados */
        DO k = 1 TO NUM-ENTRIES(x-ListaMat):
            x-CodMat = ENTRY(k, x-ListaMat).
            /* buscamos la cantidad vendida */
            FIND FIRST ITEM WHERE ITEM.codmat = x-CodMat NO-LOCK NO-ERROR.
            IF AVAILABLE ITEM THEN DO:
                ITEM.Libre_c05 = "".
            END.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Mitzy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Mitzy Procedure 
PROCEDURE Mitzy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-ListaMat  AS CHAR     NO-UNDO.
DEF VAR k           AS INT      NO-UNDO.
DEF VAR x-CodMat    AS CHAR     NO-UNDO.
DEF VAR x-CanPed    AS DEC      NO-UNDO.
DEF VAR x-CodProm   AS CHAR     NO-UNDO.
DEF VAR x-PreUni    AS DEC      NO-UNDO.
DEF VAR x-Promociones   AS DEC  NO-UNDO.
DEF VAR x-Ok        AS CHAR     NO-UNDO.
DEF VAR x-NroItm    AS INT      NO-UNDO.

ASSIGN
    x-CodProm       = "051140"
    x-PreUni        = 0.7
    x-Promociones   = 0
    x-CanPed        = 0
    x-ListaMat      = "039580,039581,039582".
FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = x-CodProm
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.
DO k = 1 TO NUM-ENTRIES(x-ListaMat):
    x-CodMat = ENTRY(k, x-ListaMat).
    /* buscamos la cantidad vendida */
    FIND FIRST ITEM WHERE ITEM.codmat = x-CodMat NO-LOCK NO-ERROR.
    IF AVAILABLE ITEM THEN DO:
        x-CanPed = x-CanPed + ITEM.CanPed * ITEM.Factor.
    END.
END.
IF x-CanPed >= 50 THEN x-Promociones = TRUNCATE(x-CanPed / 50, 0).

FIND FIRST ITEM WHERE ITEM.codmat = x-CodProm NO-LOCK NO-ERROR.
IF NOT AVAILABLE ITEM AND x-Promociones > 0 THEN DO:
    /* CONFIRMAMOS CUANTAS PROMOCIONES QUIERE LLEVARSE */
    RUN vta2/dpromocionesopcionales (x-CodProm, x-PreUni, INPUT-OUTPUT x-Promociones, OUTPUT x-Ok).
    IF x-Ok <> "ADM-ERROR" AND x-Promociones > 0 THEN DO:
        /* Marcamos los productos promocionados */
        DO k = 1 TO NUM-ENTRIES(x-ListaMat):
            x-CodMat = ENTRY(k, x-ListaMat).
            /* buscamos la cantidad vendida */
            FIND FIRST ITEM WHERE ITEM.codmat = x-CodMat NO-LOCK NO-ERROR.
            IF AVAILABLE ITEM THEN DO:
                ASSIGN
                    ITEM.Libre_c05 = "PROM".
            END.
        END.
        /* Creamos la promocion */
        CREATE ITEM.
        ASSIGN
            ITEM.CodCia = s-CodCia
            ITEM.NroItm = x-NroItm + 1
            ITEM.AlmDes = ENTRY(1, s-CodAlm)
            ITEM.CodMat = x-CodProm
            ITEM.CanPed = x-Promociones
            ITEM.PreUni = x-PreUni
            ITEM.UndVta = Almmmatg.UndStk
            ITEM.Factor = 1
            ITEM.Libre_c05 = 'OF'.
        ASSIGN
            ITEM.AftIgv = Almmmatg.AftIgv
            ITEM.AftIsc = Almmmatg.AftIsc.
        ASSIGN
            ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni *
                          ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                          ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                          ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
        IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0
            THEN ITEM.ImpDto = 0.
            ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
        ASSIGN
            ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
            ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
        IF ITEM.AftIsc
        THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
        ELSE ITEM.ImpIsc = 0.
        IF ITEM.AftIgv
        THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
        ELSE ITEM.ImpIgv = 0.
    END.
    ELSE DO:
        /* DesMarcamos los productos promocionados */
        DO k = 1 TO NUM-ENTRIES(x-ListaMat):
            x-CodMat = ENTRY(k, x-ListaMat).
            /* buscamos la cantidad vendida */
            FIND FIRST ITEM WHERE ITEM.codmat = x-CodMat NO-LOCK NO-ERROR.
            IF AVAILABLE ITEM THEN DO:
                ITEM.Libre_c05 = "".
            END.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

