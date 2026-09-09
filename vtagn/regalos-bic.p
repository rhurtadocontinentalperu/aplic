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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

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

pOk = YES.
IF TODAY > 04/15/2011 THEN RETURN.

ASSIGN
    x-ImpLin = 0
    x-CanPed = 0
    x-CanPed1 = 0
    x-CanPed2 = 0.

/* BORRAMOS INFORMACION */
FOR EACH Facdpedi WHERE Facdpedi.codcia = s-codcia
    AND Facdpedi.coddoc = 'OF'+ pCodDoc
    AND Facdpedi.nroped = pNroPed:
    DELETE Facdpedi.
END.
/* 1ra campaña por importe */
CASE pCodDoc:
    WHEN 'P/M' THEN DO:
        FIND Faccpedm WHERE Faccpedm.codcia = s-codcia
            AND Faccpedm.coddoc = pCodDoc
            AND Faccpedm.nroped = pNroPed
            NO-LOCK.
        FOR EACH Facdpedm OF Faccpedm NO-LOCK:
            IF LOOKUP(Facdpedm.codmat, '000988,000989,000990,030018,030019,030020,002166') > 0 THEN x-ImpLin = x-ImpLin + Facdpedm.ImpLin.
        END.
        IF Faccpedm.codmon = 2 THEN x-ImpLin = x-ImpLin * Faccpedm.tpocmb.
        x-CanPed = TRUNCATE(x-ImpLin / 150, 0).
        x-CodMat = '044389'.
    END.
    WHEN 'PED' THEN DO:
        FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
            AND Faccpedi.coddoc = pCodDoc
            AND Faccpedi.nroped = pNroPed
            NO-LOCK.
        FOR EACH Facdpedi OF Faccpedi NO-LOCK:
            IF LOOKUP(Facdpedi.codmat, '000988,000989,000990,030018,030019,030020,002166') > 0 THEN x-ImpLin = x-ImpLin + Facdpedi.ImpLin.
        END.
        IF Faccpedi.codmon = 2 THEN x-ImpLin = x-ImpLin * Faccpedi.tpocmb.
        x-CanPed = TRUNCATE(x-ImpLin / 150, 0).
        x-CodMat = '044389'.
    END.
END CASE.

/* *********************** */
IF x-CanPed <= 0 THEN DO:
    /* 2do campaña por cantidades */
    CASE pCodDoc:
        WHEN 'P/M' THEN DO:
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
        WHEN 'PED' THEN DO:
            FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
                AND Faccpedi.coddoc = pCodDoc
                AND Faccpedi.nroped = pNroPed
                NO-LOCK.
            FOR EACH Facdpedi OF Faccpedi NO-LOCK:
                IF LOOKUP(Facdpedi.codmat, '000988,000989,000990,030018,030019,030020') > 0 THEN x-CanPed1 = x-CanPed1 + Facdpedi.Canped * Facdpedi.Factor.
                IF LOOKUP(Facdpedi.codmat, '002166') > 0 THEN x-CanPed2 = x-CanPed2 + Facdpedi.Canped * Facdpedi.Factor.
            END.
            ASSIGN
                x-CanPed1 = TRUNCATE(x-CanPed1 / 24, 0)     /* 2 docenas */
                x-CanPed2 = TRUNCATE(x-CanPed2 / 12, 0).    /* 1 docena */
            x-CanPed = MINIMUM(x-CanPed1, x-CanPed2).
            x-CodMat = '044388'.
        END.
    END CASE.
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
CREATE Facdpedi.
CASE pCodDoc:
    WHEN 'P/M' THEN DO:
        CREATE Facdpedi.
        BUFFER-COPY Faccpedm 
            TO Facdpedi
            ASSIGN
                Facdpedi.CodDoc = 'OF' + pCodDoc
                Facdpedi.CodMat = x-CodMat
                Facdpedi.AlmDes = s-CodAlm
                Facdpedi.CanPed = x-CanPed
                Facdpedi.Factor = 1
                Facdpedi.UndVta = Almmmatg.UndStk
                Facdpedi.PreUni = 0
                Facdpedi.AftIgv = Almmmatg.AftIgv
                Facdpedi.ImpIgv = 0
                FAcdpedi.ImpLIn = 0.
    END.
    WHEN 'PED' THEN DO:
        CREATE Facdpedi.
        BUFFER-COPY Faccpedi 
            TO Facdpedi
            ASSIGN
                Facdpedi.CodDoc = 'OF' + pCodDoc
                Facdpedi.CodMat = x-CodMat
                Facdpedi.AlmDes = s-CodAlm
                Facdpedi.CanPed = x-CanPed
                Facdpedi.Factor = 1
                Facdpedi.UndVta = Almmmatg.UndStk
                Facdpedi.PreUni = 0
                Facdpedi.AftIgv = Almmmatg.AftIgv
                Facdpedi.ImpIgv = 0
                FAcdpedi.ImpLIn = 0.
    END.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


