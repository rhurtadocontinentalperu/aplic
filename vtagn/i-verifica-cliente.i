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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE lOK        AS LOGICAL NO-UNDO.
DEFINE VARIABLE iTotDias   AS INTEGER NO-UNDO.
DEFINE VARIABLE cLibre_c05 AS CHAR NO-UNDO.

IF VtaCDocu.Flgest = "X" THEN DO:       /* SOLO POR APROBAR */
    /* POR CONFIGURACION DE LA U.N. */
    FIND gn-divi WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = s-coddiv NO-LOCK.
    IF gn-div.FlgAprPed = YES 
    THEN lOK = YES.
    ELSE lOK = NO.
    IF NOT lOK THEN cLibre_c05 = "APROBACION MANUAL".

    /* POR LA LINEA DE CREDITO */
    DEF VAR t-Resultado AS CHAR NO-UNDO.
    RUN vtagn/p-linea-de-credito ( VtaCDocu.CodCli,
                              VtaCDocu.ImpTot,
                              VtaCDocu.CodMon,
                              VtaCDocu.FmaPgo,
                              FALSE,
                              OUTPUT t-Resultado).
    IF t-Resultado = 'ADM-ERROR' THEN lOK = FALSE.
    IF NOT lOK THEN cLibre_c05 = "SUPERA LA LINEA DE CREDITO".

    /* POR LA CONDICION DE VENTA */
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = Vtacdocu.codcli NO-LOCK.
    FIND gn-convt WHERE gn-convt.Codig = gn-clie.cndvta NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN iTotDias = gn-convt.totdias.
    FIND gn-convt WHERE gn-convt.Codig = VtaCDocu.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN IF gn-convt.totdias > iTotDias AND iTotDias > 0 THEN lOK = FALSE.
    /* SOLO CONTADO CONTRAENTREGA, CONTADO ANTICIPADO Y TRANSFERENCIA GRATUITA */
    IF LOOKUP(VtaCDocu.fmaPgo,"001,002,900") > 0 THEN lOK = FALSE.
    IF NOT lOK  THEN cLibre_c05 = "CONDICION DE VENTA".

    IF lOk = NO 
    THEN ASSIGN
            Vtacdocu.Libre_c05 = cLibre_c05.
    ELSE ASSIGN
            Vtacdocu.FlgEst = "P"
            VtaCDocu.FchAprobacion = TODAY
            VtaCDocu.UsrAprobacion = s-user-id.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


