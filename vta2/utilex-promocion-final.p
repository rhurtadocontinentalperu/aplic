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
         HEIGHT             = 8.04
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
DEF SHARED VAR s-user-id AS CHAR.

CASE pPromocion:
    WHEN "PREMIUM" THEN DO:
        /* ESTA PROMOCION TIENE UNA GRACIA */
        /* ADICIONALMENTE HAY QUE SOLICITAR SI ACEPTA O NO EL REGALITO */
        /* SI NO LO ACEPTA ENTONCES HAY QUE AMPLIAR LOS DESCUENTOS */
        IF TODAY <= 10/31/2013 THEN DO:
            RUN Premium.
        END.
    END.
    WHEN "MOCHILA" THEN DO:
        IF TODAY <= 10/31/2013 THEN DO:
            RUN Mochila.
        END.
    END.
    WHEN "TILIBRA" THEN DO:
        IF TODAY <= 04/30/2013 THEN DO:
            RUN Tilibra.
        END.
    END.
    WHEN "UTILEX2014-01" THEN DO:
        IF ( TODAY >= 02/15/2014 AND TODAY <= 03/02/2014 )
            OR LOOKUP(s-user-id, "ADMIN,U2014") > 0
            THEN DO:
            RUN Utilex2014-01.
        END.
    END.
    WHEN "MOCHILA-NEW" THEN DO:
        IF ( TODAY >= 02/15/2014 AND TODAY <= 03/31/2014 ) THEN DO:
            RUN MOCHILA-NEW.
        END.
    END.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Mochila) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Mochila Procedure 
PROCEDURE Mochila :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k           AS INT      NO-UNDO.
DEF VAR x-CodMat    AS CHAR     NO-UNDO.
DEF VAR x-ImpLin    AS DEC      NO-UNDO.
DEF VAR x-CodProm   AS CHAR     NO-UNDO.
DEF VAR x-PreUni    AS DEC      NO-UNDO.        /* En Soles */
DEF VAR x-Promociones   AS DEC  NO-UNDO.
DEF VAR x-Ok        AS CHAR     NO-UNDO.
DEF VAR x-NroItm    AS INT      NO-UNDO.

ASSIGN
    x-CodProm = "054634"
    x-PreUni  = 20.00
    x-Promociones = 0
    x-ImpLin = 0.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = x-CodProm
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.
FOR EACH ITEM:
    x-ImpLin = x-ImpLin + ITEM.ImpLin.
END.
IF s-CodMon = 2 THEN x-ImpLin = x-ImpLin * s-TpoCmb.
IF x-ImpLin >= 300 THEN x-Promociones = 1.
FIND FIRST ITEM WHERE ITEM.codmat = x-CodProm NO-LOCK NO-ERROR.
IF NOT AVAILABLE ITEM AND x-Promociones > 0 THEN DO:
    /* CONFIRMAMOS CUANTAS PROMOCIONES QUIERE LLEVARSE */
    /*RUN vtamay/d-promociones-manuales (x-CodProm, INPUT-OUTPUT x-Promociones, OUTPUT x-Ok).*/
    RUN vta2/dpromocionesopcionales (x-CodProm, x-PreUni, INPUT-OUTPUT x-Promociones, OUTPUT x-Ok).
    IF x-Ok <> "ADM-ERROR" AND x-Promociones > 0 THEN DO:
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
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-MOCHILA-NEW) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MOCHILA-NEW Procedure 
PROCEDURE MOCHILA-NEW :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k           AS INT      NO-UNDO.
DEF VAR x-CodMat    AS CHAR     NO-UNDO.
DEF VAR x-ImpLin    AS DEC      NO-UNDO.
DEF VAR x-CodProm   AS CHAR     NO-UNDO.
DEF VAR x-PreUni    AS DEC      NO-UNDO.        /* En Soles */
DEF VAR x-Promociones   AS DEC  NO-UNDO.
DEF VAR x-Ok        AS CHAR     NO-UNDO.
DEF VAR x-NroItm    AS INT      NO-UNDO.

ASSIGN
    x-CodProm = "063728"
    x-PreUni  = 29.90
    x-Promociones = 0
    x-ImpLin = 0.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = x-CodProm
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.
FOR EACH ITEM:
    x-ImpLin = x-ImpLin + ITEM.ImpLin.
END.
IF s-CodMon = 2 THEN x-ImpLin = x-ImpLin * s-TpoCmb.
IF x-ImpLin >= 300 THEN x-Promociones = TRUNCATE(x-ImpLin / 300, 0).
FIND FIRST ITEM WHERE ITEM.codmat = x-CodProm NO-LOCK NO-ERROR.
IF NOT AVAILABLE ITEM AND x-Promociones > 0 THEN DO:
    /* CONFIRMAMOS CUANTAS PROMOCIONES QUIERE LLEVARSE */
    RUN vta2/dpromocionesopcionales (x-CodProm, x-PreUni, INPUT-OUTPUT x-Promociones, OUTPUT x-Ok).
    IF x-Ok <> "ADM-ERROR" AND x-Promociones > 0 THEN DO:
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
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRACTIFORRO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRACTIFORRO Procedure 
PROCEDURE PRACTIFORRO :
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

/* PRACTIFORRO */
ASSIGN
    x-CodProm = "045571"    /* Practiforro */
    x-PreUni = 6
    x-Promociones = 0
    x-CanPed = 0
    x-ListaMat = "024693,024694,024695,024696,024697,024698,029777,~
033268,033852,033853,033854,033855,033859,033860,033861,033862,~
036236,036237,036238,036239,040361,~
040362,040363".

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
IF x-CanPed >= 10 THEN x-Promociones = TRUNCATE(x-CanPed / 10, 0).
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

&IF DEFINED(EXCLUDE-Premium) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Premium Procedure 
PROCEDURE Premium :
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
    x-CodProm = "056359"
    x-PreUni = 6
    x-Promociones = 0
    x-CanPed = 0
    x-ListaMat = "024693,024694,024695,024696,024697,024698,024699,024700,024701,024702,029777,~
033263,033264,033265,033266,033268,033852,033853,033854,033855,033859,033860,033861,033862,~
033863,035713,035730,036054,036055,036235,036236,036237,036238,036239,036240,036241,040361,~
040362,040363".

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
IF x-CanPed >= 10 THEN x-Promociones = TRUNCATE(x-CanPed / 10, 0).
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

&IF DEFINED(EXCLUDE-Tilibra) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Tilibra Procedure 
PROCEDURE Tilibra :
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
    x-CodProm = "040333,040331,040334,040332,040341"
    x-PreUni = 39
    x-Promociones = 0
    x-CanPed = 0
    x-ListaMat = "038206,038201,038202,045841,040329,040330,038205,038204,040327".

DO k = 1 TO NUM-ENTRIES(x-CodProm):
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = ENTRY(k, x-CodProm)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN RETURN.
END.
DO k = 1 TO NUM-ENTRIES(x-ListaMat):
    x-CodMat = ENTRY(k, x-ListaMat).
    /* buscamos la cantidad vendida */
    FIND FIRST ITEM WHERE ITEM.codmat = x-CodMat NO-LOCK NO-ERROR.
    IF AVAILABLE ITEM THEN DO:
        x-CanPed = x-CanPed + ITEM.CanPed * ITEM.Factor.
    END.
END.
IF x-CanPed >= 12 THEN x-Promociones = TRUNCATE(x-CanPed / 12, 0).
IF x-Promociones > 0 THEN DO:
    /* CONFIRMAMOS CUANTAS PROMOCIONES QUIERE LLEVARSE */
    RUN vta2/dpromocionesopcionales-a (INPUT-OUTPUT x-CodProm, x-PreUni, INPUT-OUTPUT x-Promociones, OUTPUT x-Ok).
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

&IF DEFINED(EXCLUDE-TOMATODO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE TOMATODO Procedure 
PROCEDURE TOMATODO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k           AS INT      NO-UNDO.
DEF VAR x-CodMat    AS CHAR     NO-UNDO.
DEF VAR x-ImpPed    AS DEC      NO-UNDO.
DEF VAR x-CodProm   AS CHAR     NO-UNDO.
DEF VAR x-PreUni    AS DEC      NO-UNDO.
DEF VAR x-Promociones   AS DEC  NO-UNDO.
DEF VAR x-Ok        AS CHAR     NO-UNDO.
DEF VAR x-NroItm    AS INT      NO-UNDO.

/* PRACTIFORRO */
ASSIGN
    x-CodProm = "054435"    /* Tomatodo */
    x-PreUni = 1.90
    x-Promociones = 0
    x-ImpPed = 0.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = x-CodProm
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.
FOR EACH ITEM NO-LOCK WHERE ITEM.Libre_c05 = 'OF', 
    FIRST Almmmatg OF ITEM WHERE Almmmatg.codpr1 = "10006732":
    x-ImpPed = x-ImpPed + ITEM.ImpLin.
END.
IF x-ImpPed >= 20 THEN x-Promociones = TRUNCATE(x-ImpPed / 20, 0).
IF x-Promociones > 3 THEN x-Promociones = 3.
FIND FIRST ITEM WHERE ITEM.codmat = x-CodProm NO-LOCK NO-ERROR.
IF NOT AVAILABLE ITEM AND x-Promociones > 0 THEN DO:
    /* CONFIRMAMOS CUANTAS PROMOCIONES QUIERE LLEVARSE */
    RUN vta2/dpromocionesopcionales (x-CodProm, x-PreUni, INPUT-OUTPUT x-Promociones, OUTPUT x-Ok).
    IF x-Ok <> "ADM-ERROR" AND x-Promociones > 0 THEN DO:
        /* Marcamos los productos promocionados */
        FOR EACH ITEM NO-LOCK WHERE ITEM.Libre_c05 = 'OF', 
            FIRST Almmmatg OF ITEM WHERE Almmmatg.codpr1 = "10006732":
            ASSIGN
                ITEM.Libre_c05 = "PROM".
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
        FOR EACH ITEM NO-LOCK WHERE ITEM.Libre_c05 = 'OF', 
            FIRST Almmmatg OF ITEM WHERE Almmmatg.codpr1 = "10006732":
            ASSIGN
                ITEM.Libre_c05 = "".
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Utilex2014-01) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Utilex2014-01 Procedure 
PROCEDURE Utilex2014-01 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN PRACTIFORRO.
RUN TOMATODO.
/*RUN MOCHILA-NEW.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

