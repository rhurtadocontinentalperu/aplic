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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER s-CodCia AS INT.
DEF INPUT PARAMETER s-CodDoc AS CHAR.
DEF INPUT PARAMETER s-CodDiv AS CHAR.
DEF INPUT PARAMETER s-NroDoc AS CHAR.

DEF VAR x-ImpLin LIKE Ccbddocu.ImpLin.      /* Importe en Soles */
DEF VAR x-Factor LIKE Ccbddocu.Factor.
DEF VAR x-Costo  AS DEC.
DEF VAR x-MrgUti AS DEC.
DEF VAR x-Puntos AS DEC.
DEF VAR x-Signo AS INTEGER INIT 1 NO-UNDO.
DEF VAR x-NroCard AS CHAR NO-UNDO.

FIND Ccbcdocu WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.coddoc = s-coddoc
    AND ccbcdocu.coddiv = s-coddiv
    AND ccbcdocu.nrodoc = s-nrodoc
    EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbcdocu THEN RETURN 'ADM-ERROR'.

/* Calculamos los puntos bonos por el total */
/* Margen de Utilidad */
ASSIGN
    x-NroCard = Ccbcdocu.NroCard
    x-ImpLin = 0        /*CcbCDocu.ImpTot*/
    x-Costo  = CcbCDocu.ImpCto.
    /*x-MrgUti = ( (x-ImpLin / x-Costo) - 1 ) * 100.*/

FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK,
        FIRST Almmmatg OF Ccbddocu NO-LOCK:
    /* Productos excluidos del calculo de bonos RHC 21.10.06 */
    FIND FacTabla WHERE FacTabla.CodCia = s-codcia
        AND FacTabla.Tabla = 'XB'       /* OJO */
        AND FacTabla.Codigo = Ccbddocu.codmat
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacTabla THEN NEXT.
    /* **************************************************** */
    /* En caso de LICENCIATARIOS se reduce en 10% la venta */
    IF Almmmatg.Licencia[1] <> ''
    THEN x-ImpLin = x-ImpLin + Ccbddocu.ImpLin * 0.90.
    ELSE x-ImpLin = x-ImpLin + Ccbddocu.ImpLin.
END.
IF Ccbcdocu.PorDto > 0 THEN x-ImpLin = ROUND(x-ImpLin * (1 - Ccbcdocu.PorDto / 100),2).
ASSIGN
    x-MrgUti = ( (x-ImpLin / x-Costo) - 1 ) * 100.

/* Importe en Moneda Nacional por el Valor Total */
x-ImpLin = CcbCDocu.ImpTot.
IF Ccbcdocu.codmon = 2 THEN x-ImpLin = x-ImpLin * Ccbcdocu.TpoCmb.

/* Puntos Bonus */
x-Puntos = 0.
FOR EACH TabGener WHERE Tabgener.codcia = s-codcia
        AND tabgener.clave = 'PB' NO-LOCK:
    IF x-mrguti >= Tabgener.ValorIni AND x-mrguti < Tabgener.ValorFin
    THEN DO:
        x-Puntos = TRUNCATE(x-ImpLin / Tabgener.Parametro[2], 0) * Tabgener.Parametro[1].
        /*message x-mrguti.*/
        LEAVE.
    END.
END.      

/* DEVOLUCION DE PUNTOS POR NOTA DE CREDITO */
IF CcbCDocu.CodDoc = 'N/C' THEN DO:
    x-Signo = -1.
    DEF BUFFER B-CDOC FOR Ccbcdocu.
    x-Puntos = 0.
    FIND B-CDOC WHERE B-CDOC.codcia = Ccbcdocu.codcia
        AND B-CDOC.coddoc = Ccbcdocu.codref
        AND B-CDOC.nrodoc = Ccbcdocu.nroref NO-LOCK NO-ERROR.
    IF AVAILABLE B-CDOC THEN DO:
        x-NroCard = B-CDOC.NroCard.
        x-Puntos = TRUNCATE(Ccbcdocu.ImpTot / B-CDOC.ImpTot * B-CDOC.Puntos, 0).
    END.    
END.
ASSIGN
    CcbCDocu.Puntos = x-Puntos.      

/* RHC 05.10.05 Saldo en el cliente pero en la TARJETA */
FIND GN-CARD WHERE GN-CARD.NroCard = x-NroCard EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE GN-CARD THEN DO:
    GN-CARD.AcuBon[10] = GN-CARD.AcuBon[10] + (x-Puntos * x-Signo).
END.
RELEASE GN-CARD.


/* **************************************** */

/* ******************** RHC BLOQUEADO *********************** 
/* Calculamos los puntos bonos en el detalle */
FOR EACH Ccbddocu OF ccbcdocu,
        FIRST Almmmatg OF Ccbddocu NO-LOCK:
    x-ImpLin = Ccbddocu.ImpLin.
    x-Factor = Ccbddocu.Factor.
    x-Costo  = 0.
    /* Costo Unitario */
    IF Ccbcdocu.codmon = 1 THEN DO:
        IF Almmmatg.monvta = 1
        THEN x-Costo = Almmmatg.CtoTot.
        ELSE x-Costo = Almmmatg.CtoTot * Almmmatg.TpoCmb.
    END.
    IF Ccbcdocu.codmon = 2 THEN DO:
        IF Almmmatg.monvta = 2
        THEN x-Costo = Almmmatg.CtoTot.
        ELSE x-Costo = Almmmatg.CtoTot / Almmmatg.TpoCmb.
    END.
    /* Margen de Utilidad */
    x-Costo = Ccbddocu.candes * x-Costo * x-Factor.
    Ccbddocu.MrgUti = ( (x-ImpLin / x-Costo) - 1 ) * 100.
    /* Importe en Moneda Nacional */
    IF Ccbcdocu.codmon = 2 THEN x-ImpLin = x-ImpLin * Ccbcdocu.TpoCmb.
    /* Puntos Bonus */
    FOR EACH TabGener WHERE Tabgener.codcia = s-codcia
            AND tabgener.clave = 'PB' NO-LOCK:
        IF Ccbddocu.mrguti > Tabgener.ValorIni AND Ccbddocu.mrguti <= Tabgener.ValorFin
        THEN DO:
            Ccbddocu.Puntos = TRUNCATE(x-ImpLin / Tabgener.Parametro[2], 0) * Tabgener.Parametro[1].
            Ccbcdocu.Puntos = Ccbcdocu.Puntos + Ccbddocu.Puntos.
            LEAVE.
        END.
    END.            
END.
 ****************************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


