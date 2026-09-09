&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       : Por aquí no pasa UTILEX
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF VAR j AS INT NO-UNDO.
DEF VAR x-Canti AS DEC NO-UNDO.
DEF VAR x-Rango AS DEC NO-UNDO.

/* ********************************************************************************* */
/* DESCUENTOS PROMOCIONALES Y POR VOLUMEN: SOLO SI EL VENCIMIENTO ES MENOR A 30 DIAS */                        
/* ********************************************************************************* */
ASSIGN
    x-DctoPromocional = 0
    x-DctoxVolumen = 0.
/* ************************************************************************************** */
/************ Descuento Promocional ************/ 
/* ************************************************************************************** */
IF (gn-convt.totdias <= pDiasDctoPro OR gn-convt.libre_l02 = YES)      /* Condición unica campaña (404) */
    THEN DO:
    {&Promocional}
END.
/* ************************************************************************************** */
/*************** Descuento por Volumen ****************/
/* ************************************************************************************** */
DEFINE VAR pCantidad AS DECI INIT 0 NO-UNDO.

IF (gn-convt.totdias <= pDiasDctoVol OR gn-convt.libre_l02 = YES)      /* Condición unica campaña (404) */
    AND AVAILABLE {&Tabla}
    THEN DO:
    X-CANTI = pCanPed * pFactor.
    DO J = 1 TO 10:
        IF X-CANTI >= {&Tabla}.DtoVolR[J] AND {&Tabla}.DtoVolR[J] > 0  THEN DO:
            IF X-RANGO  = 0 THEN X-RANGO = {&Tabla}.DtoVolR[J].
            IF X-RANGO <= {&Tabla}.DtoVolR[J] THEN DO:
                ASSIGN
                    X-RANGO  = {&Tabla}.DtoVolR[J]
                    x-DctoxVolumen = {&Tabla}.DtoVolD[J].
            END.   
        END.   
    END.
END.

/* Ic - 28Nov2022, Correo de Cesar Canus
    Por favor ampliar la regla de negocio para propios 
    Acabo de conversar con Gloria y no le afecta en su gestión esta regla  de negocio que funciona muy bien con Terceros
    
    Gracias        
*/

/* *************************************** */
/* DEPURAMOS LOS PORCENTAJES DE DESCUENTOS */
/* *************************************** */
IF x-FlgDtoVol  = NO THEN x-DctoxVolumen    = 0.
IF x-FlgDtoProm = NO THEN x-DctoPromocional = 0.
/* *********************************** */
/* PRECIO BASE, DE VENTA Y DESCUENTOS */
/* *********************************** */

ASSIGN
    Y-DSCTOS = 0                    /* Dcto por Volumen o Promocional */
    X-TIPDTO = "".

CASE TRUE:
    WHEN x-Libre_C01 = "" THEN DO:      /* Descuentos Excluyentes */
        /* Orden de Prioridad:
            Descuento por Volumen 
            Descuento Promocional
            Descuento por Clasificacion y Condicion 
            */
        IF x-DctoPromocional > 0 OR x-DctoxVolumen > 0 THEN DO:
            ASSIGN
                Y-DSCTOS = x-DctoPromocional    /* OJO */
                X-TIPDTO = "PROM".
            IF x-DctoxVolumen > 0 THEN 
                ASSIGN
                    Y-DSCTOS = x-DctoxVolumen    /* OJO */
                    X-TIPDTO = "VOL".
            /* RHC 11/08/2020 Se toma el mejor precio: Cesar Camus */
            IF F-PREVTA * (1 - (x-DctoPromocional / 100)) < F-PREVTA * (1 - (x-DctoxVolumen / 100))
                THEN ASSIGN 
                Y-DSCTOS = x-DctoPromocional    /* OJO */
                X-TIPDTO = "PROM".
            ELSE ASSIGN
                Y-DSCTOS = x-DctoxVolumen    /* OJO */
                X-TIPDTO = "VOL".
            /* *************************************************** */
        END.
    END.
    WHEN x-Libre_C01 = "A" THEN DO:     /* Descuentos Acumulados */
        IF x-DctoPromocional > 0 OR x-DctoxVolumen > 0 THEN DO:
            ASSIGN
                Y-DSCTOS = x-DctoPromocional    /* OJO */
                X-TIPDTO = "PROM".
            IF x-DctoxVolumen > 0 THEN 
                ASSIGN
                    Y-DSCTOS = x-DctoxVolumen   /* OJO */
                    X-TIPDTO = "VOL".
        END.
    END.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 4.81
         WIDTH              = 69.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


