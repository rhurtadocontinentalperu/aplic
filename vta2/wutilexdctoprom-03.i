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
DEF VAR pCuenta AS INT NO-UNDO.

EMPTY TEMP-TABLE E-MATG.
/* CONSISTENCIA DE DATOS */
EMPTY TEMP-TABLE E-MATG.
trloop:
FOR EACH T-MATG NO-LOCK:
    FOR EACH T-TABLA WHERE T-TABLA.Llave_c1 = T-MATG.CodMat
        AND T-TABLA.Valor[1] <> 0:
        /* Version nueva aún no aprobada */
/*         RUN Margen-de-Utilidad (INPUT T-TABLA.Llave_c2,                                    */
/*                                 INPUT T-MATG.CodMat,                                       */
/*                                 INPUT T-MATG.PreVta[1] * ( 1 - (T-TABLA.Valor[1] / 100) ), */
/*                                 INPUT T-MATG.CHR__01,                                      */
/*                                 INPUT T-MATG.TpoCmb,                                       */
/*                                 OUTPUT x-Limite,                                           */
/*                                 OUTPUT pError).                                            */
        RUN vtagn/p-margen-utilidad (
            T-MATG.CodMat,
            T-MATG.PreVta[1] * ( 1 - (T-TABLA.Valor[1] / 100) ),
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
/* GRABAMOS DESCUENTOS PROMOCIONALES */
/* Nos aseguremos que cada item pase, si no pasa regresamos a la pantalla anterior */
FOR EACH T-MATG EXCLUSIVE-LOCK ON STOP UNDO, RETURN ON ERROR UNDO, RETURN:
    FIND FIRST {&Tabla} OF T-MATG EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE {&Tabla} THEN DO:
        {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pError"}
        UNDO, RETURN.
    END.
    CASE x-MetodoActualizacion:
        WHEN 2 THEN DO:     /* Una división específica */
            /* Limpiamos informacion */
            FOR EACH VtaTabla WHERE VtaTabla.codcia = s-codcia
                AND VtaTabla.tabla = "DTOPROUTILEX"
                AND VtaTabla.llave_c1 = T-MATG.codmat
                AND VtaTabla.llave_c2 = f-Division
                EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
                DELETE VtaTabla.
            END.
            /* Cargamos informacion */
            FOR EACH T-TABLA WHERE T-TABLA.llave_c1 = T-MATG.codmat
                AND T-TABLA.llave_c2 = f-Division 
                AND (T-TABLA.valor[1] + T-TABLA.valor[2]) <> 0:
                CREATE VtaTabla.
                BUFFER-COPY T-TABLA
                    TO VtaTabla
                    ASSIGN
                    VtaTabla.codcia = s-codcia
                    VtaTabla.tabla = "DTOPROUTILEX".
            END.
        END.
        OTHERWISE DO:       /* Todas las divisiones */
            /* Limpiamos informacion */
            FOR EACH T-TABLA WHERE T-TABLA.llave_c1 = T-MATG.codmat,
                FIRST VtaTabla WHERE VtaTabla.codcia = s-codcia
                    AND VtaTabla.tabla = "DTOPROUTILEX"
                    AND VtaTabla.llave_c1 = T-TABLA.llave_c1
                    AND VtaTabla.llave_c2 = T-TABLA.llave_c2    
                    EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
                DELETE VtaTabla.
            END.
            /* Cargamos informacion */
            FOR EACH T-TABLA WHERE T-TABLA.llave_c1 = T-MATG.codmat
                AND (T-TABLA.valor[1] + T-TABLA.valor[2]) <> 0:
                txtCodMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = T-MATG.codmat + "(" + STRING(T-TABLA.valor[1]) + ")".
                CREATE VtaTabla.
                BUFFER-COPY T-TABLA
                    TO VtaTabla
                    ASSIGN
                    VtaTabla.codcia = s-codcia
                    VtaTabla.tabla = "DTOPROUTILEX".
            END.
        END.
    END CASE.
    {&Tabla}.fchact = TODAY.
    DELETE T-MATG.      /* Vamos borrando los registros ya replicados */
END.
EMPTY TEMP-TABLE T-MATG.
EMPTY TEMP-TABLE T-TABLA.

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


