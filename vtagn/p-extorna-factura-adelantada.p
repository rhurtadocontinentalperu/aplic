&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Anular todas las aplicaciones de facturas adelantadas

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
DEF INPUT PARAMETER pRowid AS ROWID.

DEFINE BUFFER F-CDOCU FOR CcbCDocu.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* RUTINA NUEVA */
    FIND Ccbcdocu WHERE ROWID(Ccbcdocu) = pRowid EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcdocu THEN DO:
        MESSAGE 'NO se pudo extornar las aplicaciones de adelantos'
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    FOR EACH Ccbdcaja WHERE Ccbdcaja.codcia = Ccbcdocu.codcia
        AND ccbdcaja.coddoc = "A/C"
        AND Ccbdcaja.codref = Ccbcdocu.coddoc
        AND Ccbdcaja.nroref = Ccbcdocu.nrodoc,
        FIRST F-CDOCU WHERE F-CDOCU.codcia = Ccbdcaja.codcia
        AND F-CDOCU.coddoc = Ccbdcaja.coddoc
        AND F-CDOCU.nrodoc = Ccbdcaja.nrodoc:
        /* Elimina Detalle de la Aplicación para A/C */
        FOR EACH CCBDMOV WHERE CCBDMOV.CodCia = ccbdcaja.CodCia 
            AND CCBDMOV.CodDoc = F-CDOCU.coddoc
            AND CCBDMOV.NroDoc = F-CDOCU.nrodoc
            AND CCBDMOV.CodRef = Ccbcdocu.coddoc 
            AND CCBDMOV.NroRef = Ccbcdocu.nrodoc:
            DELETE CCBDMOV.
        END.
        /* Actualizamos saldo anticipo campaña */
        IF F-CDOCU.CodMon = Ccbdcaja.codmon
        THEN F-CDOCU.SdoAct = F-CDOCU.SdoAct + Ccbdcaja.ImpTot.
        ELSE IF F-CDOCU.CodMon = 1
            THEN F-CDOCU.SdoAct = F-CDOCU.SdoAct + Ccbdcaja.ImpTot * Ccbdcaja.TpoCmb.
            ELSE F-CDOCU.SdoAct = F-CDOCU.SdoAct + Ccbdcaja.ImpTot / Ccbdcaja.TpoCmb.
        ASSIGN
            F-CDOCU.FlgEst = "P"
            F-CDOCU.FchCan = ?.
        DELETE Ccbdcaja.
    END.
    /* RUTINA ANTERIOR */
/*     FOR EACH Ccbdcaja WHERE Ccbdcaja.codcia = Ccbcdocu.codcia                           */
/*         AND LOOKUP (ccbdcaja.coddoc, 'FAC,BOL') > 0      /* FACTURA ADELANTADA */       */
/*         AND Ccbdcaja.codref = Ccbcdocu.coddoc                                           */
/*         AND Ccbdcaja.nroref = Ccbcdocu.nrodoc,                                          */
/*         FIRST F-CDOCU WHERE F-CDOCU.codcia = Ccbdcaja.codcia                            */
/*         AND F-CDOCU.coddoc = Ccbdcaja.coddoc                                            */
/*         AND F-CDOCU.nrodoc = Ccbdcaja.nrodoc:                                           */
/*         /* Actualizamos saldo factura adelantada */                                     */
/*         IF F-CDOCU.CodMon = Ccbdcaja.codmon                                             */
/*         THEN F-CDOCU.ImpTot2 = F-CDOCU.ImpTot2 + Ccbdcaja.ImpTot.                       */
/*         ELSE IF F-CDOCU.CodMon = 1                                                      */
/*             THEN F-CDOCU.ImpTot2 = F-CDOCU.ImpTot2 + Ccbdcaja.ImpTot * Ccbdcaja.TpoCmb. */
/*             ELSE F-CDOCU.ImpTot2 = F-CDOCU.ImpTot2 + Ccbdcaja.ImpTot / Ccbdcaja.TpoCmb. */
/*         DELETE Ccbdcaja.                                                                */
/*     END.                                                                                */
END.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


