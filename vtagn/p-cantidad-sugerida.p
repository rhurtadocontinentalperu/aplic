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
         HEIGHT             = 4.81
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* EL PROGRAMA DEVUELVE LA CANTIDAD SUGERIDA DE ACUERDO AL EMPAQUE      */
/* ******************************************************************** */
DEF INPUT PARAMETER pTpoPed AS CHAR.    /* PARA VER SI ES "E" EXPOLIBRERIA */
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCanPed AS DEC.
DEF OUTPUT PARAMETER pSugerido AS DEC.
DEF OUTPUT PARAMETER pEmpaque AS DEC.

pSugerido = pCanPed.            /* Valor por Defecto */

DEF SHARED VAR s-codcia AS INT.

DEF VAR f-CanFinal AS DEC NO-UNDO.
DEF VAR f-MinimoVentas AS DEC NO-UNDO.

DEF BUFFER B-DIVI FOR gn-divi.
DEF BUFFER B-MATG FOR Almmmatg.

FIND B-MATG WHERE B-MATG.codcia = s-codcia AND B-MATG.codmat = pCodMat NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-MATG THEN RETURN.

EMPAQUE:
DO:
CASE pTpoPed:
    WHEN "E" THEN DO:
        pSugerido = 0.      /* OJO >>> Valor Inicial */
        /* ********************************** */
        /* 1ro. Redondeamos al Empaque Master */
        /* ********************************** */
        IF B-MATG.CanEmp > 0 OR B-MATG.Libre_d03 > 0 THEN DO:
            pEmpaque = B-MATG.Libre_d03.    /* Empaque Expolibreria */
            IF pEmpaque <= 0 THEN pEmpaque = B-MATG.CanEmp.     /* Empaque Empresa */
            IF pCanPed > pEmpaque THEN DO:
                f-CanFinal = TRUNCATE(pCanPed / pEmpaque, 0) * pEmpaque.
                pSugerido = pSugerido + f-CanFinal.
                pCanPed = pCanPed - f-CanFinal.
            END.
            ELSE DO:
                /* Tope mínimo 85% y se redondea al Empaque Master*/
                IF (pCanPed / pEmpaque * 100) >= 85 THEN DO:
                    f-CanFinal = pEmpaque.
                    pSugerido = pSugerido + f-CanFinal.
                    LEAVE EMPAQUE.
                END.
            END.
        END.
        IF pCanPed <= 0 THEN LEAVE EMPAQUE.
        /* ********************************* */
        /* 2do. Redondeamos al Empaque Inner */
        /* ********************************* */
        IF B-MATG.StkRep > 0 THEN DO:
            pEmpaque = B-MATG.StkRep.
            IF pCanPed > pEmpaque THEN DO:
                f-CanFinal = TRUNCATE(pCanPed / pEmpaque, 0) * pEmpaque.
                pSugerido = pSugerido + f-CanFinal.
                pCanPed = pCanPed - f-CanFinal.
            END.
            ELSE DO:
                /* Tope mínimo 85% y se redondea al Empaque Inner */
                IF (pCanPed / pEmpaque * 100) >= 85 THEN DO:
                    f-CanFinal = pEmpaque.
                    pSugerido = pSugerido + f-CanFinal.
                    LEAVE EMPAQUE.
                END.
            END.
        END.
        IF pCanPed <= 0 THEN LEAVE EMPAQUE.
        /* ********************************************* */
        /* 3ro. Redondeamos al Mínimo Venta Expolibreria */
        /* ********************************************* */
        f-MinimoVentas = B-MATG.StkMax.
        IF f-MinimoVentas <= 0 THEN f-MinimoVentas = pCanPed.   /* <<< OJO <<< */
        pEmpaque = f-MinimoVentas.
        IF pCanPed > pEmpaque THEN DO:
            f-CanFinal = TRUNCATE(pCanPed / pEmpaque, 0) * pEmpaque.
            pSugerido = pSugerido + f-CanFinal.
            pCanPed = pCanPed - f-CanFinal.
        END.
        ELSE DO:
            /* Tope mínimo 85% y se redondea al Mínimo Ventas Expolibreria */
            IF (pCanPed / pEmpaque * 100) >= 85 THEN DO:
                f-CanFinal = pEmpaque.
                pSugerido = pSugerido + f-CanFinal.
                LEAVE EMPAQUE.
            END.
        END.
        IF pCanPed <= 0 THEN LEAVE EMPAQUE.
        /* ************************************************** */
        /* 4to. Si queda un saldo lo acumulamos a lo sugerido */
        /* ************************************************** */
        IF B-MATG.StkMax > 0 THEN f-CanFinal = TRUNCATE(pCanPed / B-MATG.StkMax, 0) * B-MATG.StkMax.
        ELSE f-CanFinal = pCanPed / pEmpaque * pEmpaque.
        pSugerido = pSugerido + f-CanFinal.
    END.
    OTHERWISE DO:
        /* EN LOS DEMAS CASO QUE NO SEA EXPOLIBRERIA */
        /* Redondeamos al Mínimo Venta Mayorista */
        pEmpaque = B-MATG.DEC__03.  /* Mínimo Ventas Mayorista */
        IF pEmpaque > 0 THEN DO:
            f-CanFinal = (TRUNCATE((pCanPed / pEmpaque),0) * pEmpaque).
            pSugerido = f-CanFinal.
        END.
        ELSE pSugerido = pCanPed.
    END.
END CASE.   
END.    /* END EMPAQUE */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


