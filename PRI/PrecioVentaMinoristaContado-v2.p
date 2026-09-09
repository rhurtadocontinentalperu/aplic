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
DEF INPUT PARAMETER S-CODDIV AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INT.
DEF INPUT PARAMETER S-TPOCMB AS DEC.
DEF OUTPUT PARAMETER S-UNDVTA AS CHAR.
DEF OUTPUT PARAMETER f-Factor AS DEC.
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER X-CANPED AS DEC.
DEF INPUT PARAMETER x-NroDec AS INT.
DEF OUTPUT PARAMETER F-PREBAS AS DEC.
DEF OUTPUT PARAMETER F-PREVTA AS DEC.
DEF OUTPUT PARAMETER Y-DSCTOS AS DEC.
DEF OUTPUT PARAMETER Z-DSCTOS AS DEC.
DEF OUTPUT PARAMETER X-TIPDTO AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* VARIABLES GLOBALES */
DEF SHARED VAR S-CODCIA AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

/* VARIABLES LOCALES */
DEF VAR s-MonVta LIKE Almmmatg.MonVta NO-UNDO.
DEFINE VARIABLE X-PREVTA1 AS DECI NO-UNDO.
DEFINE VARIABLE X-PREVTA2 AS DECI NO-UNDO.
/************ Descuento Promocional ************/
DEFINE VAR J AS INTEGER.
DEFINE VAR X-RANGO AS INTEGER INIT 0.   
DEFINE VAR X-CANTI AS DECI    INIT 0.   

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = s-codmat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    pMensaje = 'Producto ' + s-CodMat + ' NO registrado'.
    RETURN "ADM-ERROR".
END.

/* ************************************************************************************ */
/* Verifica cuál es el tipo de cambio a usar */
/* ************************************************************************************ */
DEF VAR x-TpoCmbCompra AS DECI NO-UNDO.
DEF VAR x-TpoCmbVenta AS DECI NO-UNDO.

/* Valores por defecto */
ASSIGN
    x-TpoCmbCompra = Almmmatg.TpoCmb
    x-TpoCmbVenta  = Almmmatg.TpoCmb.

FIND FacTabla WHERE FacTabla.CodCia = s-CodCia 
    AND FacTabla.Tabla = 'GN-DIVI' 
    AND FacTabla.Codigo = s-CodDiv
    NO-LOCK NO-ERROR.
IF AVAILABLE FacTabla AND FacTabla.Campo-L[5] = YES THEN DO:
    /* TIPO DE CAMBIO COMERCIAL */
    FIND LAST Gn-tccom WHERE Gn-tccom.fecha <= TODAY NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = 'NO registrado el tipo de cambio comercial' + CHR(10) +
            'Comunicarse con el gestor financiero'.
        RETURN "ADM-ERROR".
    END.
    ASSIGN
        x-TpoCmbCompra = Gn-tccom.compra
        x-TpoCmbVenta  = Gn-tccom.venta.
END.
/* ************************************************************************************ */

/* CONFIGURACIONES DE LA DIVISION */
FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMensaje = 'NO registrada la división ' + s-coddiv + CHR(10) +
        'Comunicarse con gestor del maestro de divisiones/listas de precios'.
    RETURN "ADM-ERROR".
END.

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
         HEIGHT             = 5.65
         WIDTH              = 56.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* *************************************************************************** */
/* ******************* CALCULO GENERAL DEL PRECIO DE VENTA ******************* */
/* *************************************************************************** */
ASSIGN
    F-PreBas = Almmmatg.PreOfi.

/* LISTAS DE PRECIOS */
/* NOTA: 13/02/2013 Hasta la fecha SOLO se usa la Lista Mayorista General */
CASE gn-divi.VentaMinorista:
    WHEN 1 THEN DO:
        RUN Precio-Empresa.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    END.
/*     WHEN 2 THEN DO:                                            */
/*         RUN Precio-Division.                                   */
/*         IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR". */
/*     END.                                                       */
END CASE.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Precio-Empresa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Empresa Procedure 
PROCEDURE Precio-Empresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST VtaListaMinGn OF Almmmatg NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaListaMinGn THEN DO:
    pMensaje = 'Producto ' + Almmmatg.CodMat + ' NO definido en la lista de precios minorista'.
    RETURN "ADM-ERROR".
END.
ASSIGN 
    s-UndVta = VtaListaMinGn.Chr__01.

/* FACTOR DE EQUIVALENCIA */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
        'Unidad de venta:' s-UndVta
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
F-FACTOR = Almtconv.Equival. /* / Almmmatg.FacEqu.*/

/* RHC 12.06.08 tipo de cambio de la familia */
ASSIGN
    s-TpoCmb = Almmmatg.TpoCmb
    s-MonVta = Almmmatg.MonVta.

/* DETERMINAMOS EL PRECIO BASE A LA MONEDA DE VENTA PUBLICO */
ASSIGN
    F-PREBAS = 0.
IF S-CODMON = 1 THEN DO:
    IF s-MonVta = 1
    THEN ASSIGN F-PREBAS = VtaListaMinGn.PreOfi.
    ELSE ASSIGN F-PREBAS = VtaListaMinGn.PreOfi * x-TpoCmbVenta.        /*S-TPOCMB.*/
END.
IF S-CODMON = 2 THEN DO:
    IF s-MonVta = 2
    THEN ASSIGN F-PREBAS = VtaListaMinGn.PreOfi.
    ELSE ASSIGN F-PREBAS = (VtaListaMinGn.PreOfi / x-TpoCmbCompra).     /*S-TPOCMB).*/
END.
ASSIGN
    F-PREVTA = F-PREBAS.

/* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */
/* Tomamos el mayor descuento */ 
DEF VAR x-Old-Descuento AS DEC NO-UNDO. 
DEF VAR x-DctoPromocional AS DEC NO-UNDO.

x-Old-Descuento = 0. 
x-DctoPromocional = 0.
FOR EACH VtaDctoPromMin NO-LOCK WHERE VtaDctoPromMin.CodCia = s-CodCia AND 
    VtaDctoPromMin.CodDiv = s-CodDiv AND 
    VtaDctoPromMin.CodMat = Almmmatg.CodMat AND 
    VtaDctoPromMin.FlgEst = "A" AND
    (TODAY >= VtaDctoPromMin.FchIni AND TODAY <= VtaDctoPromMin.FchFin): 
    x-DctoPromocional = VtaDctoPromMin.Descuento. 
    x-DctoPromocional = MAXIMUM(x-DctoPromocional, x-Old-Descuento). 
    x-Old-Descuento = x-DctoPromocional. 
END. 
ASSIGN
    Y-DSCTOS = 0
    Z-DSCTOS = 0.
Y-DSCTOS = x-DctoPromocional.
X-CANTI = X-CANPED * F-Factor.
/* Determinamos el mejor descuento */
ASSIGN
    X-RANGO = 0.
DO J = 1 TO 10:
    IF X-CANTI >= VtaListaMinGn.DtoVolR[J] AND VtaListaMinGn.DtoVolR[J] > 0  THEN DO:
        IF X-RANGO  = 0 THEN X-RANGO = VtaListaMinGn.DtoVolR[J].
        IF X-RANGO <= VtaListaMinGn.DtoVolR[J] THEN DO:
            Z-DSCTOS = VtaListaMinGn.DtoVolD[J].
        END.   
    END.   
END.
IF Y-DSCTOS <> 0 OR Z-DSCTOS <> 0 THEN DO:
    IF Y-DSCTOS > Z-DSCTOS THEN DO:
        /* DESCUENTO PROMOCIONAL */
        IF GN-DIVI.FlgDtoProm = YES THEN DO:
            ASSIGN
                Y-DSCTOS = x-DctoPromocional
                X-TIPDTO = "PROM".
        END.
    END.
    ELSE DO:
        /* DESCUENTO POR VOLUMEN */
        ASSIGN
            X-CANTI = X-CANPED * F-Factor
            X-RANGO = 0.
        DO J = 1 TO 10:
            IF X-CANTI >= VtaListaMinGn.DtoVolR[J] AND VtaListaMinGn.DtoVolR[J] > 0  THEN DO:
                /* Determinamos cuál es mayor, el Promocional o Por Volúmen */
                IF X-RANGO  = 0 THEN X-RANGO = VtaListaMinGn.DtoVolR[J].
                IF X-RANGO <= VtaListaMinGn.DtoVolR[J] THEN DO:
                    ASSIGN
                        X-RANGO  = VtaListaMinGn.DtoVolR[J]
                        Y-DSCTOS = VtaListaMinGn.DtoVolD[J] 
                        X-TIPDTO = "VOL".
                END.   
            END.   
        END.
    END.
END.
/* *********************************** */
RUN BIN/_ROUND1 (F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).
/* *********************************** */
/* DESCUENTOS ADICIONALES POR DIVISION */
ASSIGN
    z-Dsctos = 0.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

