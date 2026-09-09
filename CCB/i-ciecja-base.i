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
         HEIGHT             = 4.23
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

        FIND ccbccaja OF t-ccbccaja EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Ccbccaja THEN UNDO, RETURN 'ADM-ERROR'.
        ASSIGN
            CcbCCaja.FlgCie    = "C"
            CcbCCaja.FchCie    = CcbCierr.FchCie
            CcbCCaja.HorCie    = CcbCierr.HorCie.
        IF Ccbccaja.CodDoc = "I/C" AND Ccbccaja.Tipo = "OTROS"  THEN NEXT.  /* pedido por SLM 04-07.2012 */ 
        ASSIGN
            CcbCierr.ImpNac[1] = CcbCierr.ImpNac[1] + t-ccbccaja.impnac[1]
            CcbCierr.ImpNac[2] = CcbCierr.ImpNac[2] + t-ccbccaja.impnac[2]
            CcbCierr.ImpNac[3] = CcbCierr.ImpNac[3] + t-ccbccaja.impnac[3]
            CcbCierr.ImpNac[4] = CcbCierr.ImpNac[4] + t-ccbccaja.impnac[4]
            CcbCierr.ImpNac[5] = CcbCierr.ImpNac[5] + t-ccbccaja.impnac[5]
            CcbCierr.ImpNac[6] = CcbCierr.ImpNac[6] + t-ccbccaja.impnac[6]
            CcbCierr.ImpNac[7] = CcbCierr.ImpNac[7] + t-ccbccaja.impnac[7]
            CcbCierr.ImpNac[8] = CcbCierr.ImpNac[8] + t-ccbccaja.impnac[8]
            CcbCierr.ImpNac[9] = CcbCierr.ImpNac[9] + t-ccbccaja.impnac[9]
            CcbCierr.ImpNac[10] = CcbCierr.ImpNac[10] + t-ccbccaja.impnac[10]
            CcbCierr.ImpUsa[1] = CcbCierr.ImpUsa[1] + t-ccbccaja.impusa[1]
            CcbCierr.ImpUsa[2] = CcbCierr.ImpUsa[2] + t-ccbccaja.impusa[2]
            CcbCierr.ImpUsa[3] = CcbCierr.ImpUsa[3] + t-ccbccaja.impusa[3]
            CcbCierr.ImpUsa[4] = CcbCierr.ImpUsa[4] + t-ccbccaja.impusa[4]
            CcbCierr.ImpUsa[5] = CcbCierr.ImpUsa[5] + t-ccbccaja.impusa[5]
            CcbCierr.ImpUsa[6] = CcbCierr.ImpUsa[6] + t-ccbccaja.impusa[6]
            CcbCierr.ImpUsa[7] = CcbCierr.ImpUsa[7] + t-ccbccaja.impusa[7]
            CcbCierr.ImpUsa[8] = CcbCierr.ImpUsa[8] + t-ccbccaja.impusa[8]
            CcbCierr.ImpUsa[9] = CcbCierr.ImpUsa[9] + t-ccbccaja.impusa[9]
            CcbCierr.ImpUsa[10] = CcbCierr.ImpUsa[10] + t-ccbccaja.impusa[10].
        /* Pendientes por depositar */
        IF ccbccaja.CodDoc = "I/C" THEN DO:
            /* Tarjeta de Crédito */
            IF CcbCCaja.Voucher[4] <> "" THEN DO:
                FIND ccbpendep WHERE
                    CcbPenDep.CodCia = CcbCCaja.CodCia AND
                    CcbPenDep.CodDiv = CcbCCaja.CodDiv AND
                    CcbPenDep.CodDoc = "TCR" AND
                    CcbPenDep.CodRef = CcbCCaja.CodDoc AND
                    CcbPenDep.NroRef = CcbCCaja.NroDoc AND
                    CcbPenDep.FchCie = CcbCCaja.FchCie
                    EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAIL CcbPenDep THEN DO:
                    CREATE CcbPenDep.
                    ASSIGN
                        CcbPenDep.CodCia = CcbCCaja.CodCia
                        CcbPenDep.CodDoc = "TCR"
                        CcbPenDep.CodDiv = CcbCCaja.CodDiv
                        CcbPenDep.CodRef = CcbCCaja.CodDoc
                        CcbPenDep.NroRef = CcbCCaja.NroDoc
                        CcbPenDep.FchCie = CcbCCaja.FchCie
                        CcbPenDep.NroDoc = CcbCCaja.Voucher[9] + "|" + CcbCCaja.Voucher[4]
                        CcbPenDep.FlgEst = "P"
                        CcbPenDep.HorCie = X-HorCie
                        CcbPenDep.usuario = s-user-id.
                END.
                ASSIGN
                    CcbPenDep.ImpNac = CcbPenDep.ImpNac + t-CcbCCaja.ImpNac[4]
                    CcbPenDep.SdoNac = CcbPenDep.SdoNac + t-CcbCCaja.ImpNac[4]
                    CcbPenDep.ImpUsa = CcbPenDep.ImpUsa + t-CcbCCaja.ImpUsa[4]
                    CcbPenDep.SdoUsa = CcbPenDep.SdoUsa + t-CcbCCaja.ImpUsa[4].
                /* RHC 12/01/2015 Solicitado por Susana Leon */
                RUN proc_Genera-Deposito.
                /* ***************************************** */
            END.
        END.
        /* Depósitos a Bóveda */
        IF ccbccaja.CodDoc = "E/C" AND
            ccbccaja.Tipo = "REMEBOV" AND
            (t-CcbCCaja.ImpNac[1] > 0 OR
            t-CcbCCaja.ImpUsa[1] > 0) THEN DO:
            FIND ccbpendep WHERE
                CcbPenDep.CodCia = CcbCCaja.CodCia AND
                CcbPenDep.CodDoc = "BOV" AND
                CcbPenDep.CodDiv = CcbCCaja.CodDiv AND
                CcbPenDep.CodRef = CcbCCaja.CodDoc AND
                CcbPenDep.NroRef = CcbCCaja.NroDoc AND
                CcbPenDep.FchCie = CcbCCaja.FchCie
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAIL CcbPenDep THEN DO:
                CREATE CcbPenDep.
                ASSIGN
                    CcbPenDep.CodCia = CcbCCaja.CodCia
                    CcbPenDep.CodDiv = CcbCCaja.CodDiv
                    CcbPenDep.CodDoc = "BOV"
                    CcbPenDep.CodRef = CcbCCaja.CodDoc
                    CcbPenDep.NroRef = CcbCCaja.NroDoc
                    CcbPenDep.FchCie = CcbCCaja.FchCie
                    CcbPenDep.NroDoc = ""
                    CcbPenDep.FlgEst = "P"
                    CcbPenDep.HorCie = X-HorCie
                    CcbPenDep.usuario = s-user-id.
            END.
            ASSIGN
                CcbPenDep.ImpNac = CcbPenDep.ImpNac + t-CcbCCaja.ImpNac[1]
                CcbPenDep.SdoNac = CcbPenDep.SdoNac + t-CcbCCaja.ImpNac[1]
                CcbPenDep.ImpUsa = CcbPenDep.ImpUsa + t-CcbCCaja.ImpUsa[1]
                CcbPenDep.SdoUsa = CcbPenDep.SdoUsa + t-CcbCCaja.ImpUsa[1].
        END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


