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
DEF INPUT PARAMETER s-FlgSit AS CHAR.
DEF INPUT PARAMETER s-CodBco AS CHAR.
DEF INPUT PARAMETER s-Tarjeta AS CHAR.
DEF INPUT PARAMETER s-CodPro AS CHAR.
DEF INPUT PARAMETER s-NroVale AS CHAR.
DEF OUTPUT PARAMETER F-PREBAS AS DEC.
DEF OUTPUT PARAMETER F-PREVTA AS DEC.
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.
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
DEF VAR MaxCat AS DEC NO-UNDO.
DEF VAR MaxVta AS DEC NO-UNDO.
DEF VAR x-ClfCli  AS CHAR NO-UNDO.      /* Clasificacion para productos propios */
DEF VAR x-ClfCli2 AS CHAR NO-UNDO.      /* Clasificacion para productos de terceros */
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
         WIDTH              = 62.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* *************************************************************************** */
/* ******************* CALCULO GENERAL DEL PRECIO DE VENTA ******************* */
/* *************************************************************************** */
ASSIGN
    MaxCat = 0
    MaxVta = 0
    F-PreBas = 0.

/* CONFIGURACIONES DE LA DIVISION */
FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK.

/* LISTAS DE PRECIOS */
/* NOTA: 13/02/2013 Hasta la fecha SOLO se usa la Lista Mayorista General */
CASE gn-divi.VentaMinorista:
    WHEN 1 THEN DO:
        RUN Precio-Empresa.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    END.
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

/* PRECIO BASE Y UNIDAD DE VENTA */
FIND FIRST VtaListaMinGn OF Almmmatg NO-LOCK NO-ERROR.

IF Almmmatg.Chr__01 > '' THEN ASSIGN s-UndVta = Almmmatg.Chr__01.
IF TRUE <> (s-UndVta > '') THEN ASSIGN s-UndVta = Almmmatg.UndBas.
IF TRUE <> (s-UndVta > '') THEN DO:
/*     MESSAGE 'Producto' Almmmatg.CodMat 'NO definido la unidad de venta' */
/*         VIEW-AS ALERT-BOX WARNING.                                      */
    pMensaje = 'Producto ' + Almmmatg.CodMat + ' NO definido la unidad de venta'.
    RETURN "ADM-ERROR".
END.
ASSIGN 
    f-Factor = 1.
/* FACTOR DE EQUIVALENCIA */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    pMensaje = 'NO está configurado el factor de equivalencia para el producto ' + Almmmatg.codmat + CHR(10) +
        'Unidad de venta: ' + s-UndVta.
    RETURN "ADM-ERROR".
END.
F-FACTOR = Almtconv.Equival. /* / Almmmatg.FacEqu.*/

/* *************************************************************************** */
/* ******************* CALCULO GENERAL DEL PRECIO DE VENTA ******************* */
/* *************************************************************************** */
DEF VAR pSalesChannel AS CHAR NO-UNDO.

FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-CodDiv NO-LOCK.
pSalesChannel = TRIM(STRING(INTEGER(GN-DIVI.Grupo_Divi_GG))).

/* *************************************************************************************** */
/* Capturamos si la división pertenece a un peldaño que es parte de la escalera de precios */
/* 31/05/2024: Pasamos aquí el control de PELDAÑO                                          */
/* *************************************************************************************** */
DEFINE VAR hProcPeldano AS HANDLE NO-UNDO.
DEFINE VAR LogParteEscalera AS LOG NO-UNDO.

RUN web/web-library.p PERSISTENT SET hProcPeldano.
RUN web_api-captura-peldano-valido IN hProcPeldano (INPUT s-CodDiv,
                                                    OUTPUT LogParteEscalera,
                                                    OUTPUT pSalesChannel,      /* << OJO << */
                                                    OUTPUT pMensaje).
DELETE PROCEDURE hProcPeldano.
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
IF LogParteEscalera = NO THEN DO:
    pMensaje = "La División " + s-CodDiv + " NO pertenece a una escalera de precios" + CHR(10) +
        "Comunicarse con el KEY USER de COMERCIAL".
    RETURN 'ADM-ERROR'.
END.

DEFINE VAR hProc AS HANDLE NO-UNDO.
DEFINE VAR cReturnValue AS CHAR NO-UNDO.

RUN web/web-library.p PERSISTENT SET hProc.
/*RUN lib/p-write-log-txt.p("VENTAS-UTILEX","CODIGO:" + s-CodMat + ' api precio-empresa').*/
RUN web_api-pricing-preuni IN hProc (INPUT s-CodMat,
                                     INPUT pSalesChannel,
                                     INPUT "C",
                                     INPUT "000",       /* Contado */
                                     OUTPUT s-MonVta,
                                     OUTPUT s-TpoCmb,
                                     OUTPUT f-PreVta,       /* Precio descontado ClfCli y CndVta */
                                     OUTPUT pMensaje).

cReturnValue = RETURN-VALUE.
/*RUN lib/p-write-log-txt.p("VENTAS-UTILEX","CODIGO:" + s-CodMat + ' api precio-empresa FIN').*/
DELETE PROCEDURE hProc.
IF cReturnValue = 'ADM-ERROR' THEN DO:
    RETURN 'ADM-ERROR'.
END.
/* *************************************************************************** */
/* *************************************************************************** */
/* PRECIO BASE  */
/*RUN lib/p-write-log-txt.p("VENTAS-UTILEX","CODIGO:" + s-CodMat + ' precio base').*/
F-PREVTA = F-PREVTA * f-Factor.
IF S-CODMON = 1 THEN DO:
    IF s-MonVta = 1
    THEN ASSIGN F-PREBAS = f-PreVta.
    ELSE ASSIGN F-PREBAS = f-PreVta * S-TPOCMB.
END.
IF S-CODMON = 2 THEN DO:
    IF s-MonVta = 2
    THEN ASSIGN F-PREBAS = f-PreVta.
    ELSE ASSIGN F-PREBAS = (f-PreVta / S-TPOCMB).
END.

/* Definimos el precio de venta y el descuento aplicado */    
F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */

/* RHC 13/02/2014 PRODUCTOS SIN NINGUN TIPO DE DESCUENTO (SELLO ROJO )*/ 
DEF VAR x-Dia-de-Hoy AS DATE NO-UNDO.

x-Dia-de-Hoy = TODAY.

/* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */

/* Ic - 28Nov2022, Correo de Cesar Canus
    Por favor ampliar la regla de negocio para propios 
    Acabo de conversar con Gloria y no le afecta en su gestión esta regla  de negocio que funciona muy bien con Terceros
    
    Gracias        
*/

/* Tomamos el mayor descuento */ 
/* Determinamos el mejor descuento */
DEF VAR x-Old-Descuento AS DEC NO-UNDO. 
DEF VAR x-DctoPromocional AS DEC NO-UNDO.

x-Old-Descuento = 0. 
x-DctoPromocional = 0.
FOR EACH VtaDctoPromMin NO-LOCK WHERE VtaDctoPromMin.CodCia = s-CodCia AND 
    VtaDctoPromMin.CodDiv = s-CodDiv AND 
    VtaDctoPromMin.CodMat = Almmmatg.CodMat AND 
    VtaDCtoPromMin.FlgEst = "A" AND
    (TODAY >= VtaDctoPromMin.FchIni AND TODAY <= VtaDctoPromMin.FchFin): 

    x-DctoPromocional = VtaDctoPromMin.Descuento. 
    x-DctoPromocional = MAXIMUM(x-DctoPromocional, x-Old-Descuento). 
    x-Old-Descuento = x-DctoPromocional. 
END.

ASSIGN
    Y-DSCTOS = 0
    Z-DSCTOS = 0.
Y-DSCTOS = x-DctoPromocional.
IF AVAILABLE VtaListaMinGn THEN DO:
    X-CANTI = X-CANPED * F-Factor.
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
                    F-DSCTOS = 0
                    F-PREVTA = f-PreVta
                    Y-DSCTOS = x-DctoPromocional
                    X-TIPDTO = "PROM".
                IF s-Monvta = 1 THEN
                  ASSIGN X-PREVTA1 = F-PREVTA
                         X-PREVTA2 = ROUND(F-PREVTA / s-TpoCmb,6).
                ELSE
                  ASSIGN X-PREVTA2 = F-PREVTA
                         X-PREVTA1 = ROUND(F-PREVTA * s-TpoCmb,6).
                X-PREVTA1 = X-PREVTA1.
                X-PREVTA2 = X-PREVTA2.
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
                            F-DSCTOS = 0
                            F-PREVTA = f-PreVta
                            Y-DSCTOS = VtaListaMinGn.DtoVolD[J] 
                            X-TIPDTO = "VOL".
                        IF s-MonVta = 1 THEN
                           ASSIGN X-PREVTA1 = F-PREVTA
                                  X-PREVTA2 = ROUND(F-PREVTA / s-TpoCmb,6).
                        ELSE
                           ASSIGN X-PREVTA2 = F-PREVTA
                                  X-PREVTA1 = ROUND(F-PREVTA * s-TpoCmb,6).
                        X-PREVTA1 = X-PREVTA1.
                        X-PREVTA2 = X-PREVTA2.
                    END.   
                END.   
            END.
        END.
    END.
END.
/*RUN lib/p-write-log-txt.p("VENTAS-UTILEX","CODIGO:" + s-CodMat + ' precio base FIN').*/

/* *********************************** */
RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).
/* *********************************** */
/* DESCUENTOS ADICIONALES POR DIVISION */
ASSIGN
    z-Dsctos = 0.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

