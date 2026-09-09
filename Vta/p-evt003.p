&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Conecta la base de datos de estadisticas y luego la cierra

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pParametro AS CHAR.
/* Sistaxis de pParamtero
+COSTO    Imprimir el valor del costo
-COSTO    Imprimir sin el valor del costo
************************** */

RUN vtagn/conecta-estadisticas.
IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
/*
IF NOT CONNECTED("estavtas") THEN DO:
    CONNECT -pf estadisticas.pf NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'NO se pudo conectar la base de estadísticas' SKIP
            'Comunicar al administrador de base de datos'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
END.
*/
RUN vta/w-evt003-01 (pParametro).
/*RUN vta/w-evt003.*/

RUN vtagn/desconecta-estadisticas.
/*
IF CONNECTED("estavtas") THEN DISCONNECT estavtas NO-ERROR.
*/

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
         HEIGHT             = 2.58
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


