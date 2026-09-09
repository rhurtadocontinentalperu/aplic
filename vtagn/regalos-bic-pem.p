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
         HEIGHT             = 4.08
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* SOLO PARA "PED" */
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroPed AS CHAR.
DEF OUTPUT PARAMETER pOk AS LOG.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.

DEF VAR x-ImpLin AS DEC NO-UNDO.
DEF VAR x-CanPed AS DEC NO-UNDO.
DEF VAR x-CanPed1 AS DEC NO-UNDO.
DEF VAR x-CanPed2 AS DEC NO-UNDO.
DEF VAR x-CodMat AS CHAR NO-UNDO.
DEF VAR x-NroItm AS INT INIT 1 NO-UNDO.

pOk = YES.

FIND Faccpedm WHERE Faccpedm.codcia = s-codcia
    AND Faccpedm.coddoc = pCodDoc
    AND Faccpedm.nroped = pNroPed
    NO-LOCK.

IF Faccpedm.FchPed > 05/15/2011 THEN RETURN.

ASSIGN
    x-ImpLin = 0
    x-CanPed = 0
    x-CanPed1 = 0
    x-CanPed2 = 0.

/* BORRAMOS INFORMACION */
FOR EACH Facdpedm WHERE Facdpedm.codcia = s-codcia
    AND Facdpedm.coddoc = pCodDoc
    AND Facdpedm.nroped = pNroPed
    AND Facdpedm.libre_c05 = 'OF':
    DELETE Facdpedm.
END.
/* 1ra campaña por importe */
FIND Faccpedm WHERE Faccpedm.codcia = s-codcia
    AND Faccpedm.coddoc = pCodDoc
    AND Faccpedm.nroped = pNroPed
    NO-LOCK.
FOR EACH Facdpedm OF Faccpedm NO-LOCK BY Facdpedm.NroItm:
    x-NroItm = Facdpedm.NroItm + 1.
    IF LOOKUP(Facdpedm.codmat, '000988,000989,000990,030018,030019,030020,002166') > 0 THEN x-ImpLin = x-ImpLin + Facdpedm.ImpLin.
END.
IF Faccpedm.codmon = 2 THEN x-ImpLin = x-ImpLin * Faccpedm.tpocmb.
x-CanPed = TRUNCATE(x-ImpLin / 150, 0).
x-CodMat = '044389'.

/* *********************** */
IF x-CanPed <= 0 THEN DO:
    FIND Faccpedm WHERE Faccpedm.codcia = s-codcia
        AND Faccpedm.coddoc = pCodDoc
        AND Faccpedm.nroped = pNroPed
        NO-LOCK.
    FOR EACH Facdpedm OF Faccpedm NO-LOCK:
        IF LOOKUP(Facdpedm.codmat, '000988,000989,000990,030018,030019,030020') > 0 THEN x-CanPed1 = x-CanPed1 + Facdpedm.Canped * Facdpedm.Factor.
        IF LOOKUP(Facdpedm.codmat, '002166') > 0 THEN x-CanPed2 = x-CanPed2 + Facdpedm.Canped * Facdpedm.Factor.
    END.
    ASSIGN
        x-CanPed1 = TRUNCATE(x-CanPed1 / 24, 0)     /* 2 docenas */
        x-CanPed2 = TRUNCATE(x-CanPed2 / 12, 0).    /* 1 docena */
    x-CanPed = MINIMUM(x-CanPed1, x-CanPed2).
    x-CodMat = '044388'.
END.
IF x-CanPed <= 0 THEN RETURN.

/* Verificamos el stock disponible */
DEF VAR s-StockComprometido AS DEC NO-UNDO.

FIND Almmmate WHERE Almmmate.codcia = s-codcia
    AND Almmmate.codmat = x-CodMat
    AND Almmmate.codalm = s-codalm
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmate THEN DO:
    MESSAGE 'Producto de PROMOCION:' x-CodMat SKIP
        'NO registrado en el almacén:' s-codalm
        VIEW-AS ALERT-BOX ERROR.
    pOk = NO.
    RETURN.
END.
FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = x-codmat 
    NO-LOCK.

RUN vtagn/Stock-Comprometido (x-CodMat,
                              s-CodAlm,
                             OUTPUT s-StockComprometido).
IF Almmmate.StkAct - s-StockComprometido - x-CanPed <= 0 THEN DO:
    MESSAGE 'Producto de PROMOCION:' x-CodMat SKIP
        'NO hay stock suficiente en el almacén:' s-codalm
        VIEW-AS ALERT-BOX ERROR.
    pOk = NO.
    RETURN.
END.

/* Creamos registro */
CREATE Facdpedm.
BUFFER-COPY Faccpedm 
    TO Facdpedm
    ASSIGN
        Facdpedm.NroItm = x-NroItm
        Facdpedm.AlmDes = s-codalm
        Facdpedm.CodMat = x-CodMat
        Facdpedm.AlmDes = s-CodAlm
        Facdpedm.CanPed = x-CanPed
        Facdpedm.Factor = 1
        Facdpedm.UndVta = Almmmatg.UndStk
        Facdpedm.PreUni = 0
        Facdpedm.AftIgv = Almmmatg.AftIgv
        Facdpedm.ImpIgv = 0
        Facdpedm.ImpLin = 0
        Facdpedm.Libre_c05 = 'OF'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


