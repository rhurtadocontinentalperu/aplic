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

EMPTY TEMP-TABLE E-MATG.
EMPTY TEMP-TABLE A-MATG.

/* CONSISTENCIA MARGEN DE UTILIDAD */
IF RADIO-SET-1 <> 4 THEN DO:
    trloop:
    FOR EACH T-MATG NO-LOCK:
        /* Cargamos informacion */
        DO k = 1 TO 10:
            IF T-MATG.DtoVolD[k] <> 0 THEN DO:
                /* ****************************************************************************************************** */
                /* Control Margen de Utilidad */
                /* ****************************************************************************************************** */
                /* 1ro. Calculamos el margen de utilidad */
                x-PreUni = T-MATG.PreVta[1] * ( 1 - (T-MATG.DtoVolD[k] / 100) ).
                RUN PRI_Margen-Utilidad IN hProc (INPUT "",
                                                  INPUT T-MATG.CodMat,
                                                  INPUT T-MATG.CHR__01,
                                                  INPUT x-PreUni,
                                                  INPUT T-MATG.MonVta,      /*INPUT 1,*/
                                                  OUTPUT x-Margen,
                                                  OUTPUT x-Limite,
                                                  OUTPUT pError).
                IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                    /* Error crítico */
                    CREATE E-MATG.
                    BUFFER-COPY T-MATG TO E-MATG
                        ASSIGN
                        E-MATG.Libre_c01 = pError.
                    DELETE T-MATG.
                    NEXT trloop.
                END.
                /* Controlamos si el margen de utilidad está bajo a través de la variable pError */
                IF pError > '' THEN DO:
                    /* Error por margen de utilidad */
                    /* 2do. Verificamos si solo es una ALERTA, definido por GG */
                    RUN PRI_Alerta-de-Margen IN hProc (INPUT T-MATG.CodMat, OUTPUT pAlerta).
                    IF pAlerta = YES THEN DO:
                        CREATE A-MATG.
                        BUFFER-COPY T-MATG TO A-MATG
                            ASSIGN
                            A-MATG.Libre_c01 = "Margen de utilidad NO debe ser menor a " +
                                                TRIM(STRING(x-Limite, ">>>,>>9.99")).
                        NEXT trloop.
                    END.
                    ELSE DO:
                        CREATE E-MATG.
                        BUFFER-COPY T-MATG TO E-MATG
                            ASSIGN
                            E-MATG.Libre_c01 = "Margen de utilidad NO debe ser menor a " +
                                                TRIM(STRING(x-Limite, ">>>,>>9.99")).
                        DELETE T-MATG.
                        NEXT trloop.
                    END.
                END.
            END.
        END.
    END.
END.
/* CONSISTENCIA CANTIDAD DE RANGOS */
trloop:
FOR EACH T-MATG NO-LOCK:
    /* Cargamos informacion */
    iCuentaRangos = 0.
    DO k = 1 TO 10:
        IF T-MATG.DtoVolR[k] <> 0 THEN iCuentaRangos = iCuentaRangos + 1.
    END.
    IF iCuentaRangos = 0 THEN DO:
        CREATE E-MATG.
        BUFFER-COPY T-MATG 
            TO E-MATG
            ASSIGN 
            E-MATG.Libre_c01 = "Debe definir al menos un rango".
        DELETE T-MATG.
        NEXT trloop.
    END.
END.
/* CONSISTENCIA DE MENOR A MAYOR */
trloop:
FOR EACH T-MATG NO-LOCK:
    /* Cargamos informacion */
    iCuentaRangos = 0.
    DO k = 1 TO 10:
        IF iCuentaRangos > 0 AND T-MATG.DtoVolR[k] > 0
            AND T-MATG.DtoVolR[k] < iCuentaRangos 
            THEN DO:
            CREATE E-MATG.
            BUFFER-COPY T-MATG 
                TO E-MATG
                ASSIGN 
                E-MATG.Libre_c01 = "Debe definir los rangos de menor a mayor".
            DELETE T-MATG.
            NEXT trloop.
        END.
        iCuentaRangos = T-MATG.DtoVolR[k].
    END.
END.

FOR EACH T-MATG ON STOP UNDO, RETURN ON ERROR UNDO, RETURN:
    FIND {&Tabla} OF T-MATG EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE {&Tabla} THEN DO:
        MESSAGE 'Artículo' T-MATG.codmat 'no registrado en la lista de precios' SKIP
            'Actualización abortada'
            VIEW-AS ALERT-BOX WARNING.
        UNDO, RETURN.
    END.
    /* Limpiamos informacion */
    DO k = 1 TO 10:
        ASSIGN
            {&Tabla}.DtoVolR[k] = 0
            {&Tabla}.DtoVolD[k] = 0
            {&Tabla}.DtoVolP[k] = 0.
    END.
    /* Cargamos informacion */
    DO k = 1 TO 10:
        ASSIGN
            {&Tabla}.DtoVolR[k] = T-MATG.DtoVolR[k]
            {&Tabla}.DtoVolD[k] = T-MATG.DtoVolD[k]
            {&Tabla}.DtoVolP[k] = T-MATG.DtoVolP[k].
    END.
    {&Tabla}.fchact = TODAY.
    DO k = 1 TO 10:
        IF {&Tabla}.DtoVolR[k] = 0 OR {&Tabla}.DtoVolD[k] = 0
        THEN ASSIGN
                  {&Tabla}.DtoVolR[k] = 0
                  {&Tabla}.DtoVolD[k] = 0
                  {&Tabla}.DtoVolP[k] = 0.
    END.
END.
EMPTY TEMP-TABLE T-MATG.

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
         HEIGHT             = 4.92
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


