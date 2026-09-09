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
/* EL PROGRAMA DEVUELVE LA CANTIDAD MINIMA SUGERIDA */
/* ******************************************************************** */
DEF INPUT PARAMETER pTpoPed AS CHAR.    /* PARA VER SI ES "E" EXPOLIBRERIA */
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCanPed AS DEC.
DEF INPUT PARAMETER pFactor AS DEC.

DEF SHARED VAR s-CodCia AS INT.
DEF VAR f-Minimo AS DEC NO-UNDO.
DEF VAR f-CanPed AS DEC NO-UNDO.

FIND Almmmatg WHERE Almmmatg.codcia = s-CodCia AND
    Almmmatg.codmat = pCodMat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.

CASE TRUE:
    WHEN pCodDiv = '00065' THEN DO:     /* CHICLAYO */
        IF AVAILABLE Almmmatg AND Almmmatg.PesoBruto > 0 THEN DO:
            f-CanPed = pCanPed * pFactor.
            f-Minimo = Almmmatg.PesoBruto.
            IF f-Minimo > 0 THEN DO:
                IF pCanPed < f-Minimo THEN DO:
                    MESSAGE "ERROR el el artículo " Almmmatg.codmat SKIP
                        "No se puede despachar menos de " f-Minimo Almmmatg.UndStk
                        VIEW-AS ALERT-BOX ERROR.
                    RETURN 'ADM-ERROR'.
                END.
                IF pCanPed > f-Minimo AND Almmmatg.Paquete > 0 THEN DO:
                    IF (pCanPed - f-Minimo) MODULO Almmmatg.Paquete > 0
                        THEN DO:
                        MESSAGE "ERROR el el artículo "  Almmmatg.codmat SKIP
                            "No se puede despachar menos de " f-Minimo Almmmatg.UndStk SKIP
                            "el incrementos de " Almmmatg.Paquete Almmmatg.UndStk
                            VIEW-AS ALERT-BOX ERROR.
                        RETURN 'ADM-ERROR'.
                    END.
                END.
            END.
            ELSE IF Almmmatg.Paquete > 0 AND pCanPed <> 1 THEN DO:
                IF pCanPed MODULO Almmmatg.Paquete > 0 THEN DO:
                    MESSAGE "ERROR el el artículo " Almmmatg.codmat SKIP
                        "Solo se puede despachar en múltiplos de " Almmmatg.Paquete Almmmatg.UndStk
                        VIEW-AS ALERT-BOX ERROR.
                    RETURN 'ADM-ERROR'.
                END.
            END.
        END.
    END.
    WHEN pTpoPed = "E" THEN DO:     /* EXPOLIBRERIAS Y EVENTOS */
        f-CanPed = pCanPed * pFactor.
        f-Minimo = Almmmatg.StkMax.     /* OJO */
        IF f-Minimo > 0 THEN DO:
            f-CanPed = TRUNCATE((f-CanPed / f-Minimo),0) * f-Minimo.
            IF f-CanPed <> (pCanPed * pFactor) THEN DO:
                MESSAGE 'Solo puede vender en múltiplos de' f-Minimo Almmmatg.UndBas
                    VIEW-AS ALERT-BOX ERROR.
                RETURN "ADM-ERROR".
            END.
        END.
    END.
    OTHERWISE DO:
        f-CanPed = pCanPed * pFactor.
        f-Minimo = Almmmatg.DEC__03.    /* MINIMO DE VENTAS MAYORISTA */
        IF f-Minimo > 0 THEN DO:
            IF f-CanPed < f-Minimo THEN DO:
                MESSAGE 'Solo puede vender como mínimo' f-Minimo Almmmatg.UndBas
                    VIEW-AS ALERT-BOX ERROR.
                RETURN "ADM-ERROR".
            END.
        END.
    END.
END CASE.

RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


