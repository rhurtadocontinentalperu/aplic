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
DEF INPUT PARAMETER pCodCli AS CHAR.
DEF OUTPUT PARAMETER pMaster AS CHAR.
DEF OUTPUT PARAMETER pRelacionados AS CHAR.
DEF OUTPUT PARAMETER pAgrupados AS LOG.

DEF SHARED VAR s-codcia AS INT.


/* ************************************* */
/* Verificamos si es un cliente agrupado */
/* ¿es el Master? */
/*
    Si no es un cliente MASTER devuelve 
    el mismo código de cliente con que ingresó
*/    
/* ************************************* */
ASSIGN
    pMaster = ''
    pRelacionados = ''
    pAgrupados = NO.
FIND FIRST Vtactabla WHERE VtaCTabla.CodCia = s-CodCia AND
    VtaCTabla.Tabla = 'CLGRP' AND 
    VtaCTabla.Llave = pCodCli
    NO-LOCK NO-ERROR.
IF AVAILABLE Vtactabla THEN 
    ASSIGN 
    pAgrupados = YES 
    pMaster = VtaCTabla.Llave 
    pRelacionados = VtaCTabla.Llave.    /* El agrupador tambien forma parte */
ELSE DO:
    /* ¿es el relacionado? */
    FIND FIRST Vtadtabla WHERE (VtaDTabla.CodCia = s-CodCia
        AND VtaDTabla.Tabla = 'CLGRP')
        AND VtaDTabla.Tipo  = pCodCli
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaDTabla THEN DO:
        FIND FIRST VtaCTabla OF VtaDTabla NO-LOCK NO-ERROR.
        IF AVAILABLE VtaCTabla THEN 
            ASSIGN 
            pAgrupados = YES 
            pMaster = VtaCTabla.Llave 
            pRelacionados = VtaCTabla.Llave.    /* El agrupador */
    END.
END.
IF pAgrupados = YES THEN DO:
    FOR FIRST VtaCTabla NO-LOCK WHERE VtaCTabla.CodCia = s-CodCia AND
        VtaCTabla.Tabla = 'CLGRP' AND 
        VtaCTabla.Llave = pMaster,
        EACH VtaDTabla OF VtaCTabla NO-LOCK:
        pRelacionados = pRelacionados +
                        (IF TRUE <> (pRelacionados > '') THEN '' ELSE ',') +
                        VtaDTabla.Tipo.
    END.
END.

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
         HEIGHT             = 4.12
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


