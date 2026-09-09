&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : _FechaHora
    Purpose     : Formato de texto para grabar la fecha y la hora 

    Syntax      : RUN lib/_FechaHora (INPUT pTipo, INPUT pFecha, INPUT pHora, OUPUT pFechaHora)
                pTipo = 'S' calculado por el sistema
                        'M' macual, calculado en base a pFecha y pHora
                pFechaHora = resultado en formato aaaammddhh:mm

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pTipo AS CHAR.                                   
DEF INPUT PARAMETER pFecha AS DATE.                                                              
DEF INPUT PARAMETER pHora AS CHAR.
DEF OUTPUT PARAMETER pFechaHora AS CHAR FORMAT 'x(13)'.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

CASE pTipo:
    WHEN 'M' THEN DO:
        pFechaHora = STRING(YEAR(pFecha), '9999') +
                        STRING(MONTH(pFecha), '99') +
                        STRING(DAY(pFecha), '99') +
                        SUBSTRING(pHora,1,5).
    END.
    WHEN 'S' THEN DO:
        pFechaHora = STRING(YEAR(TODAY), '9999') +
                        STRING(MONTH(TODAY), '99') +
                        STRING(DAY(TODAY), '99') +
                        STRING(TIME, 'HH:MM').
    END.
    OTHERWISE DO:
        MESSAGE 'El primer parámetro debe ser M (manual) o S (sistema)'
            VIEW-AS ALERT-BOX ERROR.
        pFechaHora = 'ADM-ERROR'.
    END.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


