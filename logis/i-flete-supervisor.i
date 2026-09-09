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
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF VAR x-Flete-Peso AS DECI NO-UNDO.
DEF VAR x-Flete-Volumen AS DECI NO-UNDO.
DEF VAR x-Promedio-Peso AS DECI NO-UNDO.
DEF VAR x-Promedio-Volumen AS DECI NO-UNDO.
DEF VAR x-Cuenta-Peso AS DECI NO-UNDO.
DEF VAR x-Cuenta-Volumen AS DECI NO-UNDO.

FOR EACH t-flete_sugerido BREAK BY t-flete_sugerido.Destino:
    IF FIRST-OF(t-flete_sugerido.Destino) THEN DO:
        x-Flete-Peso = 0.
        x-Flete-Volumen = 0.
        x-Cuenta-Peso = 0.
        x-Cuenta-Volumen = 0.
        x-Promedio-Peso = 0.
        x-Promedio-Volumen = 0.
    END.
    x-Flete-Peso = x-Flete-Peso + t-flete_sugerido.Flete_Sugerido_Peso.
    x-Flete-Volumen = x-Flete-Volumen + t-flete_sugerido.Flete_Sugerido_Volumen.
    x-Promedio-Peso = x-Promedio-Peso + t-flete_sugerido.Flete_Promedio_Peso.
    x-Promedio-Volumen = x-Promedio-Volumen + t-flete_sugerido.Flete_Promedio_Volumen.
    x-Cuenta-Peso = x-Cuenta-Peso + 1.
    x-Cuenta-Volumen = x-Cuenta-Volumen + 1.
    IF LAST-OF(t-flete_sugerido.Destino) THEN DO:
        /* Promedio simple */
        x-Flete-Peso = x-Flete-Peso / x-Cuenta-Peso.
        x-Flete-Volumen = x-Flete-Volumen / x-Cuenta-Volumen.
        x-Promedio-Peso = x-Promedio-Peso / x-Cuenta-Peso.
        x-Promedio-Volumen = x-Promedio-Volumen / x-Cuenta-Volumen.
        /* Repartirmos por cada división */
        FOR EACH TabGener NO-LOCK WHERE TabGener.CodCia = s-CodCia
            AND TabGener.Clave = 'ZG_DIVI'
            AND TabGener.Codigo = t-flete_sugerido.Destino:
            FIND {&Fletes} WHERE {&Fletes}.CodCia = s-CodCia 
                AND {&Fletes}.Tabla = 'FLETE'
                AND {&Fletes}.Codigo = TabGener.Libre_c01        /* División */
                NO-LOCK NO-ERROR.
            IF AVAILABLE {&Fletes} THEN DO:
                FIND CURRENT {&Fletes} EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                IF ERROR-STATUS:ERROR = YES THEN DO:
                    {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
                        UNDO RLOOP, RETURN 'ADM-ERROR'.
                END.
                ASSIGN
                    {&Fletes}.Valor[1] = x-Flete-Peso
                    {&Fletes}.Valor[2] = x-Flete-Volumen
                    .
                &IF "{&Fletes}" = "t-FacTabla" &THEN
                    ASSIGN
                        {&Fletes}.Valor[3] = x-Promedio-Peso
                        {&Fletes}.Valor[4] = x-Promedio-Volumen.
                    ASSIGN
                        {&Fletes}.Campo-C[2] = t-flete_sugerido.Destino.
                    FIND LAST flete_sugerido USE-INDEX Idx02 WHERE flete_sugerido.CodCia = s-codcia
                        AND flete_sugerido.Destino = t-flete_sugerido.Destino
                        AND flete_sugerido.FlgEst = "A"
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE flete_sugerido THEN {&Fletes}.Campo-C[1] = STRING(flete_sugerido.FchAprobacion, '99/99/9999').
                &ENDIF
                RELEASE {&Fletes}.
            END.
        END.
    END.
END.

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
         HEIGHT             = 4.5
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


