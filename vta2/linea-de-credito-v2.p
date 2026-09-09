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
         HEIGHT             = 3.73
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pFmaPgo AS CHAR.
DEF INPUT PARAMETER pCodMon AS INT.
DEF INPUT PARAMETER pImporte AS DEC.
DEF INPUT PARAMETER pMensaje AS LOG.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.

FIND FIRST gn-convt WHERE gn-ConVt.Codig = pFmaPgo NO-LOCK NO-ERROR.
IF AVAILABLE gn-convt AND gn-convt.tipvta = "1" THEN DO:       /* CONTADO */
    RETURN 'OK'.
END.

/* ***************************************************************************
RHC 25/01/2018 Verificamos la linea de crédito en 3 pasos
1. Solicitar línea de crédito activa
2. Solicitar deuda pendiente
3. Tomar decisión
***************************************************************************** */
DEF VAR f-MonLC AS INT INIT 1 NO-UNDO.
DEF VAR f-ImpLC AS DEC NO-UNDO.
DEF VAR f-Deuda AS DEC NO-UNDO.

RUN ccb/p-implc.r (
    cl-codcia,
    pCodCli,
    pCodDiv,                       /* División a filtrar la línea de crédito */
    OUTPUT f-MonLC,
    OUTPUT f-ImpLC
    ).
/*MESSAGE f-monlc f-implc. RETURN.*/

RUN ccb/p-saldo-actual-cliente.r (
    pCodCli,
    pCodDiv,
    f-MonLC,
    OUTPUT f-Deuda
    ).
/*MESSAGE f-deuda. RETURN.*/

FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= TODAY NO-LOCK.
IF f-MonLC = 1 AND pCodMon = 2 THEN pImporte = pImporte * gn-tcmb.Compra.
IF f-MonLC = 2 AND pCodMon = 1 THEN pImporte = pImporte / gn-tcmb.Venta.
/* Hasta un 10% de margen */
IF (f-ImpLC * 1.10)  - (pImporte + f-Deuda) < 0 THEN DO:
    IF pMensaje = YES THEN
        MESSAGE "  SALDO LINEA CREDITO: "
        (IF f-MonLC = 1 THEN "S/ " ELSE "US$ " ) 
        STRING(f-ImpLC,"ZZ,ZZZ,ZZ9.99") SKIP
        "                USADO: "
        (IF f-MonLC = 1 THEN "S/ " ELSE "US$ " ) 
        STRING(pImporte + f-Deuda,"-Z,ZZZ,ZZ9.99") SKIP
        "   CREDITO DISPONIBLE: "
        (IF f-MonLC = 1 THEN "S/. " ELSE "US$ " ) 
        STRING(f-ImpLC - (pImporte + f-Deuda),"-Z,ZZZ,ZZ9.99") SKIP(1)
        'Comunicarse con el gestor de Créditos y Cobranzas'
        VIEW-AS ALERT-BOX INFORMATION
        TITLE 'VERIFICACION DE LA LINEA DE CREDITO'.
    RETURN 'ADM-ERROR'.
END.
/* RHC 21/11/18 OJO: Si no está autorizado NO PASA */
/* IF f-ImpLC > 0 THEN DO:                                                        */
/*     FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = pCodCli */
/*         NO-LOCK NO-ERROR.                                                      */
/*     IF AVAILABLE gn-clie AND gn-clie.FlagAut <> 'A' THEN DO:                   */
/*         IF pMensaje = YES THEN DO:                                             */
/*             MESSAGE 'El Cliente NO está AUTORIZADO' VIEW-AS ALERT-BOX ERROR.   */
/*         END.                                                                   */
/*         RETURN 'ADM-ERROR'.                                                    */
/*     END.                                                                       */
/* END.                                                                           */

RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


