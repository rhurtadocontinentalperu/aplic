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
         HEIGHT             = 5
         WIDTH              = 47.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER S-CODDIV AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INT.
DEF INPUT PARAMETER S-TPOCMB AS DEC.
DEF OUTPUT PARAMETER S-UNDVTA AS CHAR.
DEF OUTPUT PARAMETER f-Factor AS DEC.
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER S-CNDVTA AS CHAR.
DEF INPUT PARAMETER X-CANPED AS DEC.
DEF INPUT PARAMETER x-NroDec AS INT.

DEF OUTPUT PARAMETER F-PREBAS AS DEC.
DEF OUTPUT PARAMETER F-PREVTA AS DEC.
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.
DEF OUTPUT PARAMETER Y-DSCTOS AS DEC.
DEF OUTPUT PARAMETER Z-DSCTOS AS DEC.

/* VARIABLES GLOBALES */
DEF SHARED VAR S-CODCIA AS INT.

/* VARIABLES LOCALES */
DEFINE VARIABLE X-PREVTA1 AS DECI NO-UNDO.
DEFINE VARIABLE X-PREVTA2 AS DECI NO-UNDO.
DEFINE VARIABLE X-CANTI AS DECI NO-UNDO.
DEFINE VARIABLE J AS INT NO-UNDO.
DEFINE VARIABLE X-RANGO AS DECI NO-UNDO.

/* *************************************************************************** */
/* ******************* CALCULO GENERAL DEL PRECIO DE VENTA ******************* */
/* *************************************************************************** */
FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = s-codmat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
/*   MESSAGE "Codigo del producto no existe" VIEW-AS ALERT-BOX ERROR. */
    RETURN "ADM-ERROR".
END.

/* CONFIGURACIONES DE LA DIVISION */
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv NO-LOCK.

/* LISTAS DE PRECIOS */
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv NO-LOCK.
CASE gn-divi.VentaMinorista:
    WHEN 1 THEN DO:
        RUN Precio-Empresa.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    END.
    WHEN 2 THEN DO:
        RUN Precio-Division.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    END.
END CASE.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Precio-Division) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Division Procedure 
PROCEDURE Precio-Division :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST VtaListaMin OF Almmmatg WHERE VtaListaMin.CodDiv = s-CodDiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaListaMin THEN DO:
/*      MESSAGE 'Producto NO definido en la lista de precios de esta división' */
/*          VIEW-AS ALERT-BOX ERROR.                                           */
    RETURN "ADM-ERROR".
END.
ASSIGN
    s-UndVta = VtaListaMin.Chr__01.

/* FACTOR DE EQUIVALENCIA */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
/*     MESSAGE "Equivalencia NO definida" SKIP               */
/*         "Unidad base :" Almmmatg.undbas SKIP              */
/*         "Unidad venta:" s-undvta VIEW-AS ALERT-BOX ERROR. */
    RETURN "ADM-ERROR".
END.
F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.

/* RHC 12.06.08 tipo de cambio de la familia */
s-tpocmb = VtaListaMin.TpoCmb.     /* ¿? */

/* PRECIO BASE  */
IF S-CODMON = 1 THEN DO:
    IF VtaListaMin.MonVta = 1 
    THEN ASSIGN F-PREBAS = VtaListaMin.PreOfi.
    ELSE ASSIGN F-PREBAS = VtaListaMin.PreOfi * S-TPOCMB.
END.
IF S-CODMON = 2 THEN DO:
    IF VtaListaMin.MonVta = 2 
    THEN ASSIGN F-PREBAS = VtaListaMin.PreOfi.
    ELSE ASSIGN F-PREBAS = (VtaListaMin.PreOfi / S-TPOCMB).
END.

/* Definimos el precio de venta y el descuento aplicado */    
F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */
/************************************************/

RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Precio-Empresa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Empresa Procedure 
PROCEDURE Precio-Empresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* FACTOR DE EQUIVALENCIA */
ASSIGN
    s-UndVta = Almmmatg.Chr__01.

FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
/*      MESSAGE "Equivalencia NO definida" SKIP               */
/*          "Unidad base :" Almmmatg.undbas SKIP              */
/*          "Unidad venta:" s-undvta VIEW-AS ALERT-BOX ERROR. */
    RETURN "ADM-ERROR".
END.
F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.

/* RHC 12.06.08 tipo de cambio de la familia */
s-tpocmb = Almmmatg.TpoCmb.     /* ¿? */

/* PRECIO BASE  */
IF S-CODMON = 1 THEN DO:
    IF Almmmatg.MonVta = 1 
    THEN ASSIGN F-PREBAS = Almmmatg.PreOfi * F-FACTOR.
    ELSE ASSIGN F-PREBAS = Almmmatg.PreOfi * S-TPOCMB * F-FACTOR.
END.
IF S-CODMON = 2 THEN DO:
    IF Almmmatg.MonVta = 2 
    THEN ASSIGN F-PREBAS = Almmmatg.PreOfi * F-FACTOR.
    ELSE ASSIGN F-PREBAS = (Almmmatg.PreOfi / S-TPOCMB) * F-FACTOR.
END.

/* Definimos el precio de venta y el descuento aplicado */    
F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */

/************************************************/
RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

