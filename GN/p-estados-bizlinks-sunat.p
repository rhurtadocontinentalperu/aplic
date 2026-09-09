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

DEFINE INPUT PARAMETER pEstadoBizlinks AS CHAR.
DEFINE INPUT PARAMETER pEstadoSunat AS CHAR.
DEFINE OUTPUT PARAMETER pAbreviado AS CHAR.
DEFINE OUTPUT PARAMETER pDetallado AS CHAR.


pAbreviado = "".
pDetallado = "".

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

IF ENTRY(1,pEstadoBizlinks,"|") = 'SIGNED' THEN DO:
    pAbreviado = "FIRMADO por BizLinks".
    pDetallado = "Proceso Incial - Firmado por Bizlinks".

    IF ENTRY(1,pEstadoSunat,"|") = "PE_02" THEN DO:
        pAbreviado = "Esperando respuesta SUNAT".
        pDetallado = "A la espera de resppuesta de SUNAT".
    END.                                
    IF ENTRY(1,pEstadoSunat,"|") = "PE_09" THEN DO:
        pAbreviado = "Pendiente de Envio a SUNAT".
        pDetallado = "Proceso Firmado, y Pendiente de Envio".
    END.                                
    IF ENTRY(1,pEstadoSunat,"|") = "ED_06" THEN DO:
        pAbreviado = "Enviado a SUNAT".
        pDetallado = "Proceso de firmado y enviado a SUNAT".
    END.
    IF ENTRY(1,pEstadoSunat,"|") = "AC_03" THEN DO:
        pAbreviado = "Aceptado por SUNAT".
        pDetallado = "Proceso firmado, Emitido y ACEPTADO por SUNAT".
    END.
    IF ENTRY(1,pEstadoSunat,"|") = "RC_05" THEN DO:
        pAbreviado = "Rechazado por SUNAT".
        pDetallado = "Proceso firmado, Emitido y RECHAZADO por SUNAT".
    END.        
END.
IF ENTRY(1,pEstadoBizlinks,"|") = 'MISSING' THEN DO:
    pAbreviado = "NO ENVIADO a bizlinks".
    pDetallado = "Proceso Incial - No existe en Bizlinks".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


