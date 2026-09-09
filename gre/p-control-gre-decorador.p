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

DEF INPUT PARAMETER pParam AS CHAR NO-UNDO. 
/* Ej. GRC|logis/w-mantto-gr-aut-cred */

IF NUM-ENTRIES(pParam,'|') < 3 THEN DO:
    MESSAGE 'Solo acepta 2 parámetros separados por |' SKIP
        'Sintaxis: GRC|w-mantto-gr-aut-cred|logis' 
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

DEF VAR pTipoGR AS CHAR.    /* GRC o GRE */
DEF VAR pProgram AS CHAR.   /* Programa a ejecutar */
DEF VAR pPath AS CHAR.

ASSIGN
    pTipoGR = ENTRY(1,pParam,'|')
    pProgram = ENTRY(2,pParam,'|')
    pPath = ENTRY(3,pParam,'|').

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


/* GRE */
DEFINE NEW SHARED VAR s-acceso-total  AS LOG.
DEFINE VAR lGRE_ONLINE AS LOG.

RUN gn/gre-online.r(OUTPUT lGRE_ONLINE).
CASE TRUE:
    WHEN pTipoGR = "GRC" AND lGRE_ONLINE = NO THEN s-acceso-total = YES.
    WHEN pTipoGR = "GRC" AND lGRE_ONLINE = YES THEN s-acceso-total = NO.
    WHEN pTipoGR = "GRE" AND lGRE_ONLINE = YES THEN s-acceso-total = YES.
    WHEN pTipoGR = "GRE" AND lGRE_ONLINE = NO THEN s-acceso-total = NO.
END CASE.

pProgram = pPath + '/' + pProgram.

RUN VALUE(pProgram) NO-ERROR.

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


