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
         HEIGHT             = 7.04
         WIDTH              = 57.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* response en formato JSON
{
    "@odata.context": "https://192.168.20.100:50000/b1s/v2/$metadata#CL_DIVISION",
    "value": [
        {
            "Code": "00015",
            "Name": null,
            "U_CL_CODDIV": "00015"
        }
    ]
}
*/


DEFINE STREAM LectorJSON. /* <<-- DEFINE STREAM en lugar de CREATE STREAM-HANDLE */
      RUN Version_0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Version_0) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Version_0 Procedure 
PROCEDURE Version_0 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/* Programa ABL con sintaxis de Stream explícito para OpenEdge 10.1C    */
/*----------------------------------------------------------------------*/

/* Declaración de variables */
/*DEFINE STREAM LectorJSON. /* <<-- DEFINE STREAM en lugar de CREATE STREAM-HANDLE */*/

DEFINE VARIABLE cArchivoJSON AS CHARACTER   NO-UNDO INITIAL "datos_division.json".
DEFINE VARIABLE cContenido   AS LONGCHAR    NO-UNDO.

DEFINE VARIABLE cCodeValue   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iPosInicio   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iPosFin      AS INTEGER     NO-UNDO.

/* 1. Leer el contenido completo del archivo JSON */

/* Usamos el nombre del stream definido (LectorJSON) en lugar del handle */
INPUT STREAM LectorJSON FROM VALUE(cArchivoJSON) BINARY NO-MAP.

/*
SET-SIZE(cContenido) = 0. /* Limpiar la LONGCHAR */ 
*/
IMPORT STREAM LectorJSON cContenido.
/*COPY-LOB FROM STREAM LectorJSON TO cContenido.*/
INPUT STREAM LectorJSON CLOSE.

/* 2. Análisis BÁSICO de la cadena LONGCHAR para extraer el valor "Code" */

/* Buscar la posición de la clave "Code" */
iPosInicio = INDEX(cContenido, '"Code":') NO-ERROR.

IF iPosInicio = 0 THEN DO:
    MESSAGE "ERROR: Clave Code: no encontrada en el JSON." VIEW-AS ALERT-BOX.
    RETURN.
END.

/* Mover el inicio a después de la clave y el delimitador. 8 caracteres */
iPosInicio = iPosInicio + 8.

/* Buscar la posición de la comilla de cierre después del valor. */
iPosFin = INDEX(SUBSTRING(cContenido, iPosInicio), '"') NO-ERROR.

IF iPosFin = 0 THEN DO:
    MESSAGE "ERROR: No se encontró la comilla de cierre después del valor de 'Code'." VIEW-AS ALERT-BOX.
    RETURN.
END.

/* Extraer el valor de Code */
cCodeValue = SUBSTRING(cContenido, iPosInicio, iPosFin - 1).

/* 3. Mostrar el resultado */
MESSAGE "Contenido JSON cargado correctamente." SKIP
        "Valor extraído para 'Code': " cCodeValue
        VIEW-AS ALERT-BOX.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Version_1) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Version_1 Procedure 
PROCEDURE Version_1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
/*----------------------------------------------------------------------*/
/* Programa ABL para leer JSON en OpenEdge 10.1C (Método de cadena)    */
/* NOTA: Este método es extremadamente frágil y solo funciona para     */
/* una estructura JSON muy específica. Se recomienda actualizar.       */
/*----------------------------------------------------------------------*/

DEFINE VARIABLE cArchivoJSON AS CHARACTER   NO-UNDO INITIAL "datos_division.json".
DEFINE VARIABLE hFile        AS HANDLE      NO-UNDO.
DEFINE VARIABLE cContenido   AS LONGCHAR    NO-UNDO.
DEFINE VARIABLE cCodeValue   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iPosInicio   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iPosFin      AS INTEGER     NO-UNDO.

/* 1. Leer el contenido completo del archivo JSON en la variable LONGCHAR */
CREATE STREAM-HANDLE hFile.
STREAM hFile:FILE-NAME = cArchivoJSON.

INPUT STREAM hFile FROM VALUE(cArchivoJSON) BINARY NO-MAP.
SET-SIZE(cContenido) = 0. /* Limpiar la LONGCHAR */
COPY-LOB FROM STREAM hFile TO cContenido.
INPUT STREAM hFile CLOSE.

DELETE STREAM hFile.

/* 2. Análisis BÁSICO de la cadena LONGCHAR para extraer el valor "Code" */

/* Buscar la posición de la clave "Code" */
iPosInicio = INDEX(cContenido, '"Code":') NO-ERROR.

IF iPosInicio = 0 THEN DO:
    MESSAGE "ERROR: Clave '\"Code\":' no encontrada en el JSON." VIEW-AS ALERT-BOX.
    RETURN.
END.

/* Mover el inicio a después de la clave y el delimitador.
   "Code": "00015"
   |-------|      -> 8 caracteres (contando comillas y dos puntos)
*/
iPosInicio = iPosInicio + 8.

/* Buscar la posición de la comilla de cierre después del valor. */
/* Usamos SUBSTRING para buscar solo en la parte relevante del JSON */
iPosFin = INDEX(SUBSTRING(cContenido, iPosInicio), '"') NO-ERROR.

IF iPosFin = 0 THEN DO:
    MESSAGE "ERROR: No se encontró la comilla de cierre después del valor de 'Code'." VIEW-AS ALERT-BOX.
    RETURN.
END.

/* El valor de Code es la subcadena que comienza en iPosInicio y tiene una longitud de (iPosFin - 1) */
cCodeValue = SUBSTRING(cContenido, iPosInicio, iPosFin - 1).

/* 3. Mostrar el resultado */
MESSAGE "Contenido JSON cargado correctamente." SKIP
        "Valor extraído para 'Code': " cCodeValue
        VIEW-AS ALERT-BOX.

              
*/              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

