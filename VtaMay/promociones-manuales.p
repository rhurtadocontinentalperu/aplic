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
         HEIGHT             = 4.35
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/*DEFINE TEMP-TABLE ITEM NO-UNDO LIKE Facdpedm.*/
DEFINE TEMP-TABLE ITEM LIKE Facdpedi.

DEF INPUT-OUTPUT PARAMETER TABLE FOR ITEM.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-porigv AS DEC.

/* Oferta Standford de portatodos a S/1.00 */
DEF VAR x-CodMat AS CHAR.
DEF VAR x-CodProm AS CHAR.
DEF VAR x-ListaMat AS CHAR.
DEF VAR x-CanPed AS DEC.
DEF VAR x-Promociones AS DEC.
DEF VAR k AS INT.
DEF VAR x-Ok AS CHAR.
DEF VAR x-NroItm AS INT.

FOR EACH ITEM NO-LOCK:
    x-NroItm = x-NroItm + 1.
END.

IF TODAY >= 07/07/2012 AND TODAY <= 07/31/2012 THEN DO:
    ASSIGN
        x-CodProm = "035755"
        x-Promociones = 0
        x-ListaMat = '033238,033225,033245,033235,044975,049381,044989,~
033215,033229,033239,033226,044976,044990,039565,033227,039934,~
039917,047758,044977,047757,033217,044991'.
    DO k = 1 TO NUM-ENTRIES(x-ListaMat):
        x-CodMat = ENTRY(k, x-ListaMat).
        FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
            AND Almmmatg.codmat = x-CodProm
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg THEN RETURN.
        /* buscamos la cantidad vendida */
        FIND FIRST ITEM WHERE ITEM.codmat = x-CodMat NO-LOCK NO-ERROR.
        IF AVAILABLE ITEM THEN DO:
            /* Acumulamos por múltiplos de 25 unidades */
            x-CanPed = ITEM.CanPed * ITEM.Factor.
            IF x-CanPed > 0 THEN DO:
                x-Promociones = x-Promociones + TRUNCATE(x-CanPed / 25, 0).
            END.
        END.
    END.
    FIND FIRST ITEM WHERE ITEM.codmat = x-CodProm NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ITEM AND x-Promociones > 0 THEN DO:
        /* CONFIRMAMOS CUANTAS PROMOCIONES QUIERE LLEVARSE */
        RUN vtamay/d-promociones-manuales (x-CodProm, INPUT-OUTPUT x-Promociones, OUTPUT x-Ok).
        IF x-Ok <> "ADM-ERROR" AND x-Promociones > 0 THEN DO:
            CREATE ITEM.
            ASSIGN
                ITEM.CodCia = s-CodCia
                ITEM.NroItm = x-NroItm + 1
                ITEM.AlmDes = ENTRY(1, s-CodAlm)
                ITEM.CodMat = x-CodProm
                ITEM.CanPed = x-Promociones
                ITEM.PreUni = 1
                ITEM.UndVta = Almmmatg.UndStk
                ITEM.Factor = 1
                ITEM.Libre_c05 = 'OF'.
            ASSIGN 
                ITEM.AftIgv = Almmmatg.AftIgv
                ITEM.AftIsc = Almmmatg.AftIsc.
            ASSIGN
                ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                              ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                              ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                              ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
            IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
                THEN ITEM.ImpDto = 0.
                ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
            ASSIGN
                ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
                ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
            IF ITEM.AftIsc 
            THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
            ELSE ITEM.ImpIsc = 0.
            IF ITEM.AftIgv 
            THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
            ELSE ITEM.ImpIgv = 0.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


