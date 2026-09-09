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
         HEIGHT             = 4.42
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */


/*------------------------------------------------------------------------------------------------*/
/* */
/* Importar datos de un archivo CSV a una tabla de base de datos Progress.                        */
/* */
/* Requisitos:                                                                                   */
/* - Archivo CSV llamado 'datos.csv' en la misma carpeta que el programa.                         */
/* - El archivo debe tener los campos separados por comas.                                        */
/* - Tabla en la base de datos Progress llamada 'MiTabla' con los campos 'campo1' y 'campo2'.    */
/* */
/*------------------------------------------------------------------------------------------------*/

DEFINE VARIABLE cArchivo AS CHARACTER NO-UNDO.
DEFINE VARIABLE iContador AS INTEGER NO-UNDO INITIAL 0.

ASSIGN cArchivo = "d:\datos.csv".

/* Usar el comando IMPORT para leer el archivo CSV */

INPUT FROM VALUE(cArchivo) .

IF ERROR-STATUS:ERROR THEN DO:
    MESSAGE "No se pudo abrir el archivo de entrada: " + cArchivo VIEW-AS ALERT-BOX.
    RETURN.
END.

/* Ignorar el encabezado si existe (opcional) */
/* SKIP. */

/* Bucle para leer cada línea del archivo */
REPEAT:
    CREATE MiTabla.
    
    /* Leer la línea del archivo CSV y asignar los valores directamente a la tabla */
    IMPORT UNFORMATTED MiTabla.campo1 MiTabla.campo2 NO-ERROR.
    
    /* Si no se pudo leer la línea, se asume que es el final del archivo */
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE MiTabla. /* Eliminar el registro que se creó sin datos */
        LEAVE. /* Salir del bucle REPEAT */
    END.
    
    iContador = iContador + 1.
END.

/* Cerrar el archivo de entrada */
INPUT CLOSE.

MESSAGE "Importación completada con éxito." SKIP
        "Se importaron " + STRING(iContador) + " registros." VIEW-AS ALERT-BOX.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


