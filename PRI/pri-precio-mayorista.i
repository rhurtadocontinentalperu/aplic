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

DEF VAR cCodMat AS CHAR NO-UNDO.
DEF VAR fPreUni  AS DECI NO-UNDO.
DEF VAR f-PreVta AS DECI NO-UNDO.
DEF VAR f-PreBas AS DECI NO-UNDO.
DEF VAR y-DSCTOS AS DECI NO-UNDO.
DEF VAR cTipDto AS CHAR NO-UNDO.
DEF VAR f-Factor AS DECI NO-UNDO.
DEF VAR f-FleteUnitario AS DECI NO-UNDO.
DEF VAR F-DSCTOS AS DECI NO-UNDO.
DEF VAR z-Dsctos AS DECI NO-UNDO.
DEF VAR x-TipDto AS CHAR NO-UNDO.
DEF VAR x-CanPed AS DECI NO-UNDO.
DEF VAR s-UndVta AS CHAR NO-UNDO.
DEF VAR s-CndVta AS CHAR NO-UNDO.
DEF VAR x-DctoPromocional AS DECIMAL DECIMALS 4 NO-UNDO.
DEF VAR x-DctoxVolumen    AS DECIMAL DECIMALS 4 NO-UNDO.
DEF VAR pCodDiv AS CHAR NO-UNDO.
pCodDiv = pcCodDiv.
DEF VAR s-CodMon AS INTE NO-UNDO.
s-CodMon = piCodMon.
DEF VAR x-MonVta AS INTE NO-UNDO.       /* Moneda de venta de la lista de precios */
DEF VAR s-TpoCmb AS DECI NO-UNDO.
DEF VAR x-NroDec AS INTE NO-UNDO.
x-NroDec = s-NroDec.

DEF VAR x-FlgDtoVol     LIKE GN-DIVI.FlgDtoVol  NO-UNDO.
DEF VAR x-FlgDtoProm    LIKE GN-DIVI.FlgDtoProm NO-UNDO.
DEF VAR x-Libre_C01     LIKE GN-DIVI.Libre_C01  NO-UNDO.     /* Dcto Excluyentes, acumulados o el mejor */
DEF VAR x-Ajuste-por-flete AS LOG NO-UNDO.

cCodMat     =         ENTRY(1,ENTRY(iRegistro,pcReturn),':').
fPreUni     = DECIMAL(ENTRY(2,ENTRY(iRegistro,pcReturn),':')).
x-MonVta    = INTEGER(ENTRY(3,ENTRY(iRegistro,pcReturn),':')).
s-TpoCmb    = DECIMAL(ENTRY(4,ENTRY(iRegistro,pcReturn),':')).
s-CndVta    = pcFmaPgo.

x-FlgDtoVol     = gFlgDtoVol.
x-FlgDtoProm    = gFlgDtoProm.
x-Libre_c01     = gLibre_C01.
x-Ajuste-por-flete = gAjuste-por-flete.

/* *************************************************************************** */
/* Posicionamos registro en ITEM */
/* *************************************************************************** */
FIND FIRST ITEM WHERE ITEM.codmat = cCodMat EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
IF NOT AVAILABLE ITEM THEN NEXT.
FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = cCodMat NO-LOCK.

/* *************************************************************************** */
/* PRECIO BASE Y UNIDAD DE VENTA */
/* *************************************************************************** */
ASSIGN
    F-FACTOR = ITEM.Factor
    x-CanPed = ITEM.CanPed
    s-UndVta = ITEM.UndVta
    f-PreVta = ITEM.PreUni
    f-PreBas = ITEM.PreBas
    f-Dsctos = ITEM.PorDto
    z-Dsctos = ITEM.Por_Dsctos[2]
    y-Dsctos = ITEM.Por_Dsctos[3]
    x-TipDto = ''.

/* Unidad de Venta */
IF TRUE <> (s-UndVta > '') THEN DO:
    /*IF Almmmatg.Chr__01 > '' THEN ASSIGN s-UndVta = Almmmatg.Chr__01.*/
    IF TRUE <> (s-UndVta > '') THEN ASSIGN s-UndVta = Almmmatg.UndBas.
    IF TRUE <> (s-UndVta > '') THEN ASSIGN s-UndVta = Almmmatg.UndStk.
    IF TRUE <> (s-UndVta > '') THEN DO:
        pMensaje = 'Producto: ' + Almmmatg.CodMat + ' NO definida la unidad de venta'.
        RETURN "ADM-ERROR".
    END.
END.

ASSIGN 
    f-Factor = 1.
/* Revisemos el factor de conversión */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND 
    Almtconv.Codalter = s-UndVta NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    pMensaje = 'NO está configurado el factor de equivalencia para el producto ' + Almmmatg.codmat + CHR(10) +
        'Unidad de venta: ' + s-UndVta.
    RETURN "ADM-ERROR".
END.
f-Factor = Almtconv.Equival.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


