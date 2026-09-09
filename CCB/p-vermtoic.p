&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE OUTPUT PARAMETER para_lExcede AS LOGICAL NO-UNDO.

DEF SHARED VARIABLE s-codcia AS INTEGER.
DEF SHARED VARIABLE s-coddiv LIKE gn-divi.coddiv.
DEF SHARED VARIABLE s-codter LIKE ccbcterm.codter.
DEF SHARED VARIABLE s-user-id AS CHARACTER.

DEFINE VARIABLE fTotalCja AS DECIMAL NO-UNDO.
DEFINE VARIABLE fEfectivo AS DECIMAL NO-UNDO.
DEFINE VARIABLE fTpoCmb AS DECIMAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



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
         HEIGHT             = 2.01
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Tipo de cambio Caja */
FIND LAST Gn-tccja WHERE
    Gn-tccja.Fecha <= TODAY NO-LOCK NO-ERROR.
IF AVAILABLE Gn-Tccja THEN fTpoCmb = Gn-Tccja.Compra.
ELSE fTpoCmb = 1.

/* Verifica Monto Tope por Caja */
para_lExcede = FALSE.

FIND UsrCjaCo WHERE
    UsrCjaCo.CodCia = s-CodCia AND
    UsrCjaCo.Usuario = s-user-id NO-LOCK NO-ERROR.
IF AVAILABLE UsrCjaCo AND UsrCjaCo.Campo-F[1] <> 0 THEN DO:
    FOR EACH ccbccaja WHERE
        ccbccaja.codcia = s-codcia AND
        ccbccaja.coddiv = s-coddiv AND
        LOOKUP(ccbccaja.coddoc,"I/C,E/C") > 0 AND
/*MLR* 28/02/08 ***
        ccbccaja.fchdoc = TODAY AND
* ***/
        ccbccaja.tipo >= "" AND
        ccbccaja.codcaja = s-codter AND
        ccbccaja.usuario = s-user-id AND
        ccbccaja.flgest <> "A" AND
        ccbccaja.flgcie = "P" NO-LOCK:
        fEfectivo = 0.
        IF ccbccaja.codmon = 1 THEN DO:
            fEfectivo = CcbCCaja.ImpNac[1] - CcbCCaja.VueNac.
        END.
        ELSE DO:
            fEfectivo = CcbCCaja.ImpUSA[1] - CcbCCaja.VueUSA.
            fEfectivo = fEfectivo * fTpoCmb.
        END.
        IF ccbccaja.coddoc = "E/C" THEN fEfectivo = fEfectivo * -1.
        fTotalCja = fTotalCja + fEfectivo.
    END.
    IF fTotalCja > UsrCjaCo.Campo-F[1] THEN DO:
        para_lExcede = TRUE.
        MESSAGE
            "Ha excedido el MONTO PERMITIDO POR CAJA." SKIP
            "Realize E/C Remesa a Bóveda para continuar"
            VIEW-AS ALERT-BOX ERROR.
    END.
END.



/* RUTINA ANTERIOR: VERIFICACION POR TERMINAL 
FIND CcbCTerm WHERE
    CcbCTerm.CodCia = s-CodCia AND
    CcbCTerm.CodDiv = s-CodDiv AND
    CcbCTerm.CodTer = s-CodTer NO-LOCK NO-ERROR.
IF CcbCTerm.Campo-F[1] <> 0 THEN DO:
    FOR EACH ccbccaja WHERE
        ccbccaja.codcia = s-codcia AND
        ccbccaja.coddiv = s-coddiv AND
        LOOKUP(ccbccaja.coddoc,"I/C,E/C") > 0 AND
        ccbccaja.fchdoc = TODAY AND
        ccbccaja.tipo >= "" AND
        /*ccbccaja.codcaja = s-codter AND*/
        ccbccaja.usuario = s-user-id AND
        ccbccaja.flgcie = "P" NO-LOCK:
        IF ccbccaja.codmon = 1 THEN DO:
            fEfectivo = CcbCCaja.ImpNac[1] - CcbCCaja.VueNac.
        END.
        ELSE DO:
            fEfectivo = CcbCCaja.ImpUSA[1] - CcbCCaja.VueUSA.
            fEfectivo = fEfectivo * fTpoCmb.
        END.
        IF ccbccaja.coddoc = "E/C" THEN fEfectivo = fEfectivo * -1.
        fTotalCja = fTotalCja + fEfectivo.
    END.
    IF fTotalCja > CcbCTerm.Campo-F[1] THEN DO:
        para_lExcede = TRUE.
        MESSAGE
            "Ha excedido el MONTO PERMITIDO POR CAJA." SKIP
            "Realize E/C Remesa a Bóveda para continuar"
            VIEW-AS ALERT-BOX ERROR.
    END.
END.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


