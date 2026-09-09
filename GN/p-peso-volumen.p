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
         HEIGHT             = 4.96
         WIDTH              = 53.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.
DEF OUTPUT PARAMETER pPeso AS DECI.         /* kg */
DEF OUTPUT PARAMETER pVolumen AS DECI.      /* m3 */
DEF OUTPUT PARAMETER pImpVta AS DECI.
DEF OUTPUT PARAMETER pImpCto AS DECI.

/* CALCULO DEL STOCK COMPROMETIDO */
DEF SHARED VAR s-codcia AS INT.

/*CUENTA ARTICULOS POR FAMILIA*/
ASSIGN
    pPeso    = 0
    pVolumen = 0
    pImpVta = 0
    pImpCto = 0.
CASE pCodDoc:
    WHEN "G/R" OR WHEN "FAC" OR WHEN "BOL" THEN DO:

        FOR EACH CcbDDocu WHERE ccbddocu.codcia = s-codcia
            AND ccbddocu.coddoc = pCodDoc
            AND ccbddocu.nrodoc = pNroDoc NO-LOCK,
            FIRST CcbCDocu OF CcbDDocu NO-LOCK,
            FIRST almmmatg WHERE almmmatg.codcia = CcbDDocu.CodCia
            AND almmmatg.codmat = CcbDDocu.CodMat NO-LOCK:
            IF almmmatg.libre_d02 <> ? THEN DO:
                pVolumen = pVolumen + (CcbDDocu.candes * CcbDDocu.factor * (almmmatg.libre_d02 / 1000000)).
            END.
            IF Almmmatg.PesMat <> ? THEN DO:
                pPeso = pPeso + (CcbDDocu.candes * CcbDDocu.factor * almmmatg.pesmat).
            END.
            pImpVta = pImpVta + Ccbddocu.ImpLin * (IF Ccbcdocu.codmon = 2 THEN Ccbcdocu.tpocmb ELSE 1).
            IF Almmmatg.CtoTot <> ? AND Almmmatg.MonVta <> ? THEN DO:
                pImpCto = pImpCto + Ccbddocu.CanDes * Ccbddocu.Factor * Almmmatg.CtoTot * (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1).
            END.
        END.
    END.
    WHEN "O/M" OR WHEN "COT" OR WHEN "C/M" OR WHEN "O/D" OR WHEN "PED" OR WHEN "P/M" THEN DO:
        FOR EACH Facdpedi WHERE Facdpedi.codcia = s-codcia
            AND Facdpedi.coddoc = pCodDoc
            AND Facdpedi.nroped = pNroDoc NO-LOCK,
            FIRST Faccpedi OF Facdpedi NO-LOCK,
            FIRST Almmmatg WHERE Almmmatg.codcia = Facdpedi.CodCia
            AND Almmmatg.codmat = Facdpedi.CodMat NO-LOCK:
            IF Almmmatg.libre_d02 <> ? THEN DO:
                pVolumen = pVolumen + (Facdpedi.canped * Facdpedi.factor * (Almmmatg.libre_d02 / 1000000)).
            END.
            IF Almmmatg.PesMat <> ? THEN DO:
                pPeso = pPeso + (Facdpedi.canped * Facdpedi.factor * Almmmatg.pesmat).
            END.
            pImpVta = pImpVta + Facdpedi.ImpLin * (IF Faccpedi.codmon = 2 THEN Faccpedi.tpocmb ELSE 1).
            IF Almmmatg.CtoTot <> ? AND Almmmatg.MonVta <> ? THEN DO:
                pImpCto = pImpCto + Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.CtoTot * (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1).
            END.
        END.
    END.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


