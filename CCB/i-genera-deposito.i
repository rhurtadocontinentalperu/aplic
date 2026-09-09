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

    DEFINE BUFFER b_pen FOR CcbPenDep.
    DEFINE VARIABLE n AS INTEGER NO-UNDO.

    FOR EACH T-CcbPenDep TRANSACTION ON STOP UNDO, RETURN 'ADM-ERROR'
        ON ERROR UNDO, RETURN 'ADM-ERROR':
        CREATE CcbDMvto.
        ASSIGN
            CcbDMvto.CodCia = T-CcbPenDep.CodCia
            CcbDMvto.CodDoc = T-CcbPenDep.CodRef
            CcbDMvto.NroDoc = T-CcbPenDep.NroRef
            CcbDMvto.TpoRef = T-CcbPenDep.CodDoc
            CcbDMvto.CodRef = T-CcbPenDep.CodDoc
            CcbDMvto.NroRef = T-CcbPenDep.NroDoc
            CcbDMvto.CodDiv = T-CcbPenDep.CodDiv
            CcbDMvto.codbco = F-Banco
            CcbDMvto.CodCta = F-Cta
            CcbDMvto.NroDep = FILL-IN-NroOpe
            CcbDMvto.FchEmi = F-Fecha
            CcbDMvto.DepNac[1] = (IF T-CcbPenDep.CodMon = 1 THEN T-CcbPenDep.SdoAct ELSE 0)
            CcbDMvto.DepUsa[1] = (IF T-CcbPenDep.CodMon = 2 THEN T-CcbPenDep.SdoAct ELSE 0)
            CcbDMvto.FchCie = T-CcbPenDep.FchCie
            CcbDMvto.HorCie = T-CcbPenDep.HorCie
            CcbDMvto.FlgEst = "P"
            CcbDMvto.usuario = s-user-id.
        /* Busca I/C o E/C */
        FIND CcbCCaja WHERE
            CcbCCaja.CodCia = CcbDMvto.CodCia AND
            CcbCCaja.CodDoc = CcbDMvto.CodDoc AND
            CcbCCaja.NroDoc = CcbDMvto.NroDoc
            NO-LOCK NO-ERROR.
        IF AVAILABLE CcbCCaja THEN
            CcbDMvto.CodCli = CcbCCaja.CodCli.
        /* Actualiza Flag T-CcbPenDep */
        FIND FIRST b_pen WHERE b_pen.codcia = T-CcbPenDep.codcia
            AND b_pen.coddiv = T-CcbPenDep.coddiv
            AND b_pen.coddoc = T-CcbPenDep.coddoc
            AND b_pen.nrodoc = T-CcbPenDep.nrodoc
            AND b_pen.codref = T-CcbPenDep.codref
            AND b_pen.nroref = T-CcbPenDep.nroref
            EXCLUSIVE-LOCK NO-ERROR.
        IF T-CcbPenDep.CodMon = 1 THEN
            ASSIGN b_pen.SdoNac = b_pen.SdoNac - T-CcbPenDep.SdoAct.
        IF T-CcbPenDep.CodMon = 2 THEN
            ASSIGN b_pen.SdoUsa = b_pen.SdoUsa - T-CcbPenDep.SdoAct.
        IF b_pen.SdoNac + b_pen.SdoUSA <= 0 THEN
            ASSIGN b_pen.FlgEst = "C".
        RELEASE b_pen.
        DELETE T-CcbPenDep.
    END.

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
         HEIGHT             = 3.62
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


