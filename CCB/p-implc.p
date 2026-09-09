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
         HEIGHT             = 4.04
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER pCodCia AS INT.
DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pCodDiv AS CHAR.    /* OJO */
DEF OUTPUT PARAMETER pMonLC AS INT.
DEF OUTPUT PARAMETER pImpLCred AS DEC.

DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR cl-codcia AS INT.

DEF VAR lEnCampan AS LOG NO-UNDO.

/* Línea Crédito Campaña */
pMonLC = 1.
pImpLCred = 0.
lEnCampan = FALSE.
FIND FIRST gn-clie WHERE gn-clie.codcia = pcodcia AND gn-clie.codcli = pcodcli NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clie THEN RETURN.

/* ************************************* */
/* Verificamos si es un cliente agrupado */
/* ¿es el Master? */
/* ************************************* */
DEF VAR pMaster AS CHAR.
DEF VAR pRelacionados AS CHAR.
DEF VAR pAgrupados AS LOG.
RUN ccb/p-cliente-master (pCodCli,
                          OUTPUT pMaster,
                          OUTPUT pRelacionados,
                          OUTPUT pAgrupados).
IF pAgrupados = YES AND pMaster > '' THEN pCodCli = pMaster.    /* Cambiamos al Master */

FOR EACH Gn-ClieL WHERE Gn-ClieL.CodCia = pCodCia
    AND Gn-ClieL.CodCli = pCodCli
/*     AND Gn-ClieL.FchIni <> ? */
/*     AND Gn-ClieL.FchFin <> ? */
    AND TODAY >= Gn-ClieL.FchIni 
    AND TODAY <= Gn-ClieL.FchFin NO-LOCK
    BY gn-cliel.fchini BY gn-cliel.fchfin:
    IF Gn-ClieL.FchIni = ? OR Gn-ClieL.FchFin = ? THEN NEXT.
    pMonLC    = gn-cliel.monlc.
    pImpLCred = Gn-ClieL.ImpLC.     /* VALOR POR DEFECTO => LINEA DE CREDITO TOTAL */
    lEnCampan = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


