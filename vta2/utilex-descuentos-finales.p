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
         HEIGHT             = 4.35
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE TEMP-TABLE ITEM LIKE Facdpedi.

DEFINE INPUT PARAMETER pPromocion AS CHAR.
DEF INPUT-OUTPUT PARAMETER TABLE FOR ITEM.

/* RHC 30.01.2023 Por ahora no hace nada */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-porigv AS DEC.

/* EN ESTE NIVEL DEFINIMOS LAS PROMOCIONES POR CAMPAÑAS */
/* LO VAMOS PROGRAMANDO DE ACUERDO A CAMPAÑAS */
CASE pPromocion:
    WHEN "PREMIUM" THEN DO:
        IF TODAY <= 03/31/2013 THEN DO:
            RUN Premium.
        END.
    END.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Premium) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Premium Procedure 
PROCEDURE Premium :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Si supera las 50 unidades de compra => 8% dcto
------------------------------------------------------------------------------*/

DEF VAR x-CanPed AS DEC NO-UNDO.

ASSIGN
    x-CanPed = 0.
FOR EACH ITEM WHERE ITEM.Libre_c05 <> "PROM",
    FIRST Almmmatg OF ITEM NO-LOCK WHERE Almmmatg.codfam = "010" AND Almmmatg.subfam = '012':
    x-CanPed = x-CanPed + ITEM.CanPed * ITEM.Factor.
END.
IF x-CanPed >= 50 THEN DO:
    /* APLICAMOS EL 5% A LOS PRODUCTOS QUE NO TIENEN OFERTA */
    FOR EACH ITEM WHERE LOOKUP(ITEM.Libre_c05, "PROM") = 0,
        FIRST Almmmatg OF ITEM NO-LOCK WHERE Almmmatg.codfam = "010" AND Almmmatg.subfam = '012':
        /* Buscamos el mejor descuento */
        IF MAXIMUM(ITEM.Por_Dsctos[1], ITEM.Por_Dsctos[2], ITEM.Por_Dsctos[3], ITEM.PorDto2) < 5 THEN DO:
            ASSIGN
                ITEM.Por_Dsctos[1] = 0
                ITEM.Por_Dsctos[2] = 0
                ITEM.Por_Dsctos[3] = 5  /* <=== */
                ITEM.PorDto2       = 0
                ITEM.Libre_c04     = "PREMIUM".
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
    /* SI TIENEN OFERTA QUITAMOS LOS DESCUENTOS */
    FOR EACH ITEM WHERE LOOKUP(ITEM.Libre_c05, "PROM") > 0,
        FIRST Almmmatg OF ITEM NO-LOCK WHERE Almmmatg.codfam = "010" AND Almmmatg.subfam = '012':
        ASSIGN
            ITEM.Por_Dsctos[1] = 0
            ITEM.Por_Dsctos[2] = 0
            ITEM.Por_Dsctos[3] = 0
            ITEM.PorDto2       = 0.
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


/*
DEF VAR x-CanPed AS DEC NO-UNDO.

/* PROMOCION ARTESCO: */
IF TODAY <= 03/31/2013 THEN DO:
    DEF VAR x-ListaMat AS CHAR NO-UNDO.     /* Productos NO entran en la campaña */

    x-ListaMat = "024693,024694,024695,024696,024697,024698,024699,024700,024701,024702,029777,~
033263,033264,033265,033266,033268,033852,033853,033854,033855,033859,033860,033861,033862,~
033863,035713,035730,036054,036055,036235,036236,036237,036238,036239,036240,036241,040361,~
040362,040363".

    ASSIGN
        x-CanPed = 0.
    FOR EACH ITEM WHERE LOOKUP(ITEM.codmat, x-ListaMat) = 0 AND ITEM.Libre_c04 <> "PROM", 
        FIRST Almmmatg OF ITEM NO-LOCK WHERE Almmmatg.codfam = "010" AND Almmmatg.subfam = '012':
        x-CanPed = x-CanPed + ITEM.CanPed * ITEM.Factor.
    END.
    IF x-CanPed >= 50 THEN DO:
        FOR EACH ITEM WHERE LOOKUP(ITEM.codmat, x-ListaMat) = 0 AND ITEM.Libre_c04 <> "PROM", 
            FIRST Almmmatg OF ITEM NO-LOCK WHERE Almmmatg.codfam = "010"
            AND Almmmatg.subfam = '012':
            /* Buscamos el mejor descuento */
            IF MAXIMUM(ITEM.Por_Dsctos[1], ITEM.Por_Dsctos[2], ITEM.Por_Dsctos[3], ITEM.PorDto2) < 8 THEN DO:
                ASSIGN
                    ITEM.Por_Dsctos[1] = 0
                    ITEM.Por_Dsctos[2] = 0
                    ITEM.Por_Dsctos[3] = 8  /* <=== */
                    ITEM.PorDto2       = 0
                    ITEM.Libre_c04     = "PREMIUM".
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
    END.
END.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

