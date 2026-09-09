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
         HEIGHT             = 5.42
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Diferencia-de-Caja Include 
PROCEDURE Diferencia-de-Caja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR Monto_Nac AS DEC NO-UNDO.
DEF VAR Monto_Usa AS DEC NO-UNDO.
DEF VAR x-IngNac AS DEC NO-UNDO.
DEF VAR x-IngUsa AS DEC NO-UNDO.
DEF VAR x-EgrNac AS DEC NO-UNDO.
DEF VAR x-EgrUsa AS DEC NO-UNDO.

DEF BUFFER B-CCAJA FOR Ccbccaja.

ASSIGN
    x-EgrNac = CCBDECL.ImpNac[1]
    x-EgrUsa = CCBDECL.ImpUSA[1].
FOR EACH B-CCAJA NO-LOCK WHERE B-CCAJA.codcia = s-codcia 
    AND B-CCAJA.coddoc = "I/C" 
    AND B-CCAJA.flgcie = "C" 
    AND B-CCAJA.fchcie = ccbcierr.fchcie 
    AND B-CCAJA.horcie = ccbcierr.horcie 
    AND B-CCAJA.flgest NE "A" 
    AND B-CCAJA.usuario = ccbcierr.Usuario
    AND (B-CCAJA.ImpNac[1] + B-CCAJA.ImpUSA[1]) <> 0:
    monto_nac = B-CCAJA.ImpNac[1] - B-CCAJA.VueNac.
    monto_usa = B-CCAJA.ImpUSA[1] - B-CCAJA.VueUSA.
    /* Guarda Efectivo Recibido */
    x-IngNac = x-IngNac + monto_Nac.
    x-IngUsa = x-IngUsa + monto_USA.
END.
IF ABS(x-IngNac - x-EgrNac) > 1 
    OR ABS(x-IngUsa - x-EgrUsa) > 1 THEN DO:
    CREATE CcbPenDep.
    ASSIGN
        CcbPenDep.CodCia = Ccbcierr.codcia
        CcbPenDep.CodDiv = s-coddiv
        CcbPenDep.CodDoc = "DCC"    /* Diferencia cierre de caja */
        CcbPenDep.CodRef = "DCC"
        CcbPenDep.FchCie = Ccbcierr.fchcie
        CcbPenDep.FchEmi = TODAY
        CcbPenDep.FlgEst = "P"
        CcbPenDep.HorCie = Ccbcierr.horcie
        CcbPenDep.ImpNac = x-IngNac     /* SISTEMA */
        CcbPenDep.ImpUsa = x-IngUsa
        CcbPenDep.NroDoc = Ccbcierr.Usuario + '|' + STRING(Ccbcierr.fchcie,'99/99/9999') + '|' + Ccbcierr.horcie
        CcbPenDep.NroRef = Ccbcierr.Usuario + '|' + STRING(Ccbcierr.fchcie,'99/99/9999') + '|' + Ccbcierr.horcie
        CcbPenDep.SdoNac = x-EgrNac     /* DECLARADO */
        CcbPenDep.SdoUsa = x-EgrUsa
        CcbPenDep.usuario = Ccbcierr.usuario
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
END.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CreateECCJA Include 
PROCEDURE proc_CreateECCJA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER para_codmon AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER para_importe AS DECIMAL NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR' WITH FRAME {&FRAME-NAME}:
    FIND FacCorre WHERE 
        FacCorre.CodCia = s-codcia AND
        FacCorre.CodDoc = s-coddoc AND 
        FacCorre.NroSer = s-ptovta
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCorre THEN UNDO, RETURN ERROR.
    CREATE CcbCCaja.
    ASSIGN
        CcbCCaja.CodCia  = s-codcia
        CcbCCaja.CodDiv  = s-coddiv
        CcbCCaja.CodDoc  = s-coddoc
        CcbCCaja.NroDoc  = STRING(faccorre.nroser, "999") +  STRING(faccorre.correlativo, "999999")
        CcbCCaja.Tipo    = s-tipo
        CcbCCaja.usuario = s-user-id
        CcbCCaja.CodCaja = s-codter
        CcbCCaja.FchDoc  = INPUT CcbCierr.FchCie
        CcbcCaja.Flgest  = "C"
        CcbCCaja.Voucher[10] = STRING(TIME,"HH:MM:SS").
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /* Tipo de Cambio */
    FIND LAST gn-tccja WHERE gn-tccja.Fecha <= INPUT CcbCierr.FchCie NO-LOCK NO-ERROR.
    IF AVAILABLE gn-tccja THEN ASSIGN CcbCCaja.TpoCmb = gn-tccja.Compra.
    CREATE CcbDCaja.
    ASSIGN
        CcbDCaja.CodCia = CcbCCaja.CodCia
        CcbDCaja.CodDoc = CcbCCaja.CodDoc
        CcbDCaja.NroDoc = CcbCCaja.NroDoc
        CcbDCaja.CodMon = para_codmon
        CcbDCaja.CodRef = CcbCCaja.CodDoc
        CcbDCaja.NroRef = CcbCCaja.NroDoc
        CcbDCaja.FchDoc = CcbCCaja.FchDoc
        CcbDCaja.CodDiv = CcbCCaja.CodDiv
        CcbDCaja.TpoCmb = CcbCCaja.TpoCmb.
    IF para_codmon = 1 THEN DO:
        CcbCCaja.ImpNac[1] = para_importe.
        CcbDCaja.ImpTot = CcbCCaja.ImpNac[1].
    END.
    ELSE DO:
        CcbCCaja.ImpUsa[1] = para_importe.
        CcbDCaja.ImpTot = CcbCCaja.ImpUsa[1].
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Genera-Deposito Include 
PROCEDURE proc_Genera-Deposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* OJO: Ya va con los valores del depósito */
DEF VAR F-Banco AS CHAR INIT 'CO'       NO-UNDO.
DEF VAR F-Cta   AS CHAR INIT '10413100' NO-UNDO.
DEF VAR FILL-IN-NroOpe AS CHAR          NO-UNDO.
DEF VAR F-Fecha AS DATE                 NO-UNDO.

ASSIGN F-Fecha = TODAY.

/* RHC 13/10/2018 RHC: a pedido de Susana Leon */
    ASSIGN 
        F-Banco = 'IB' 
        F-Cta = '10416100'.
/* IF CcbPenDep.NroDoc BEGINS '07' OR      /* AMEX o American Express */ */
/*     CcbPenDep.NroDoc BEGINS '02'        /* MC o Mastercard */         */
/*     THEN DO:                                                          */
/*     ASSIGN                                                            */
/*         F-Banco = 'IB'                                                */
/*         F-Cta = '10416100'.                                           */
/* END.                                                                  */
/* RHC 01/12/2016 UTILEX */
/* FIND gn-divi WHERE gn-divi.codcia = s-codcia                                                   */
/*     AND gn-divi.coddiv = s-coddiv                                                              */
/*     NO-LOCK NO-ERROR.                                                                          */
/* IF AVAILABLE gn-divi AND GN-DIVI.CanalVenta = 'MIN' THEN DO:                                   */
/*     ASSIGN F-Banco = 'IB' F-Cta = '10416100'.                                                  */
/*     IF LOOKUP(s-CodDiv, '00516,00517,00518') = 0 AND CcbPenDep.NroDoc BEGINS '07'   /* AMEX */ */
/*         THEN ASSIGN F-Banco = 'CO' F-Cta = '10413100'.                                         */
/* END.                                                                                           */

{ccb/i-pendep-02-v2.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

