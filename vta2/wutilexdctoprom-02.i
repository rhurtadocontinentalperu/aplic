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

/* CONSISTENCIA DE DATOS */
EMPTY TEMP-TABLE E-MATG.
IF RADIO-SET-1 <> 4 THEN DO:
    trloop:
    FOR EACH T-MATG NO-LOCK:
        /* Cargamos informacion */
        DO k = 1 TO 10:
            IF T-MATG.PromDto[k] <> 0 THEN DO:
                RUN vtagn/p-margen-utilidad (
                    T-MATG.CodMat,
                    T-MATG.PreVta[1] * ( 1 - (T-MATG.PromDto[k] / 100) ),
                    T-MATG.CHR__01,
                    1,                      /* Moneda */
                    T-MATG.TpoCmb,
                    NO,                     /* Muestra error? */
                    "",                     /* Almacén */
                    OUTPUT x-Margen,        /* Margen de utilidad */
                    OUTPUT x-Limite,        /* Margen mínimo de utilidad */
                    OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
                    ).
                IF pError = "ADM-ERROR" THEN DO:
                    CREATE E-MATG.
                    BUFFER-COPY T-MATG 
                        TO E-MATG
                        ASSIGN 
                        E-MATG.Libre_c01 = "Margen de utilidad NO debe ser menor a " + TRIM(STRING(x-Limite, ">>>,>>9.99")).
                    DELETE T-MATG.
                    NEXT trloop.
                END.
            END.
        END.
    END.
END.

FOR EACH T-MATG ON STOP UNDO, RETURN ON ERROR UNDO, RETURN:
    FIND {&Tabla} OF T-MATG EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE {&Tabla} THEN UNDO, RETURN.
    CASE x-MetodoActualizacion:
        WHEN 2 THEN DO:     /* Una división específica */
            /* Limpiamos informacion */
            DO k = 1 TO 10:
                IF {&Tabla}.PromDivi[k] = f-Division 
                    THEN ASSIGN
                    {&Tabla}.PromDivi[k] = ""
                    {&Tabla}.PromDto[k] = 0
                    {&Tabla}.PromFchD[k] = ?
                    {&Tabla}.PromFchH[k] = ?.
            END.
            /* Cargamos informacion */
            trloop:
            DO j = 1 TO 10:
                IF {&Tabla}.PromDivi[j] = '' THEN DO:
                    DO k = 1 TO 10:
                        IF T-MATG.PromDivi[k] = f-Division AND T-MATG.PromDto[k] <> 0 THEN DO:
                            ASSIGN
                                {&Tabla}.PromDivi[j] = T-MATG.PromDivi[k]
                                {&Tabla}.PromDto[j] = T-MATG.PromDto[k]
                                {&Tabla}.PromFchD[j] = T-MATG.PromFchD[k]
                                {&Tabla}.PromFchH[j] = T-MATG.PromFchH[k].
                            LEAVE trloop.
                        END.
                    END.
                END.
            END.
        END.
        OTHERWISE DO:       /* Todas las divisiones */
            /* Limpiamos informacion */
            DO k = 1 TO 10:
                ASSIGN
                    {&Tabla}.PromDivi[k] = ""
                    {&Tabla}.PromDto[k] = 0
                    {&Tabla}.PromFchD[k] = ?
                    {&Tabla}.PromFchH[k] = ?.
            END.
            /* Cargamos informacion */
            j = 0.
            DO k = 1 TO 10:
                IF T-MATG.PromDto[k] <> 0 THEN DO:
                    j = j + 1.
                    ASSIGN
                        {&Tabla}.PromDivi[j] = T-MATG.PromDiv[k]
                        {&Tabla}.PromDto[j] = T-MATG.PromDto[k]
                        {&Tabla}.PromFchD[j] = T-MATG.PromFchD[k]
                        {&Tabla}.PromFchH[j] = T-MATG.PromFchH[k].
                END.
            END.
        END.
    END CASE.
    {&Tabla}.fchact = TODAY.
END.
EMPTY TEMP-TABLE T-MATG.


/*
    /* Por margenes de utilidad */
    /* Oficina */
*/

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
         HEIGHT             = 3.88
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


