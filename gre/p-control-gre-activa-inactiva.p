&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description : Programa disparador de error

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEF SHARED VAR s-codcia AS INTE.

DEF INPUT PARAMETER pTipoGR AS CHAR.    /* GRC o GRE */
DEF OUTPUT PARAMETER pRpta AS LOG.      /* Yes o No */

pRpta = NO.
IF LOOKUP(pTipoGR, 'GRC,GRE') = 0 THEN DO:
    MESSAGE 'El primer parámetro solo puede ser:' SKIP
        'GRC: Guía de Remisión NO Eletrónica' SKIP
        'GRE: Guía de Remisión Electrónica'
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.
/* Buscamos el switch de GRE */
FIND FIRST VtaTabla WHERE VtaTabla.codcia = s-codcia AND
    VtaTabla.tabla = 'CONFIG-GRE' AND
    VtaTabla.llave_c1 = 'ESTADO' AND
    VtaTabla.llave_c2 = 'ONLINE'
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla THEN DO:
    MESSAGE 'NO está configurado el switch de activo/inactivo de la GRE' 
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

CASE pTipoGR:
    WHEN "GRC" THEN DO:
        IF VtaTabla.Valor[1] = 1 THEN DO:
            RUN gre/d-error-gre-activa.w.
            RETURN.
        END.
    END.
    WHEN "GRE" THEN DO:
        IF VtaTabla.Valor[1] = 0 THEN DO:
            RUN gre/d-error-gre-noactiva.w.
            RETURN.
        END.
    END.
END CASE.
pRpta = YES.

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
         HEIGHT             = 4.81
         WIDTH              = 62.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


