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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER S-CODCIA AS INT.
DEF INPUT PARAMETER S-CODDIV AS CHAR.
DEF INPUT PARAMETER S-CODCLI AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INT.
DEF INPUT PARAMETER F-FACTOR AS DEC.
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER S-CNDVTA AS CHAR.
DEF INPUT PARAMETER X-CANPED AS DEC.
DEF INPUT PARAMETER x-NroDec AS INT.
DEF OUTPUT PARAMETER F-PREBAS AS DEC.
DEF OUTPUT PARAMETER F-PREUNI AS DEC.
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.
DEF OUTPUT PARAMETER F-DSCTOS-1 AS DEC.

DEF VAR MaxCat AS DEC NO-UNDO.
DEF VAR MaxVta AS DEC NO-UNDO.
DEF VAR CL-CODCIA AS INT INIT 0 NO-UNDO.
DEF VAR x-ClfCli AS CHAR NO-UNDO.
DEF VAR x-fch AS DATE INIT TODAY.

FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCli THEN CL-CODCIA = S-CODCIA.
FIND Almmmatg WHERE Almmmatg.codcia = S-CODCIA
    AND Almmmatg.codmat = S-CODMAT NO-LOCK.


/* DETERMINAMOS EL PRECIO BASE */
/* CASO ESPECIAL PARA EXPOLIBRARIA: TOMA OTRA LISTA DE PRECIOS */
CASE s-coddiv:
    WHEN '00015' THEN DO:       /* EXPOLIBRERIA */
        RUN Precio-Base-Expo.
    END.
    OTHERWISE DO:
        RUN Precio-Base.
    END.
END CASE.

ASSIGN
    MaxCat = 0
    MaxVta = 0.

/* POR CLASIFICACION DEL CLIENTE */
FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
   AND gn-clie.CodCli = S-CODCLI NO-LOCK NO-ERROR.
x-ClfCli = 'C'.     /* Valor por defecto */
IF AVAIL gn-clie AND gn-clie.clfcli <> '' THEN X-CLFCLI = gn-clie.clfcli.

FIND ClfClie WHERE ClfClie.Categoria = X-CLFCLI NO-LOCK NO-ERROR.
IF AVAIL ClfClie THEN DO:
  IF Almmmatg.Chr__02 = "P" THEN 
      MaxCat = ClfClie.PorDsc.
  ELSE 
      MaxCat = ClfClie.PorDsc1.
END.
/* POR CONDICION DE VENTA */
FIND Dsctos WHERE Dsctos.CndVta = S-CNDVTA 
    AND Dsctos.clfCli = Almmmatg.Chr__02
    NO-LOCK NO-ERROR.
IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.
/***************************************************/

IF NOT AVAIL ClfClie THEN
    F-DSCTOS = (1 - (1 - MaxVta / 100)) * 100.
ELSE
    F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.

/* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */
CASE s-coddiv:
    WHEN '00015' THEN DO:       /* EXPOLIBRERIA */
        RUN Descuentos-Expo.
    END.
END CASE.


/* PRECIO UNITARIO Y % DE DESCUENTO */
F-PREUNI = F-PREBAS * (1 - F-DSCTOS / 100).

RUN src/BIN/_ROUND1(F-PREUNI,X-NRODEC,OUTPUT F-PREUNI).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Descuentos-Expo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos-Expo Procedure 
PROCEDURE Descuentos-Expo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR X-PREVTA1 AS DECI NO-UNDO.
DEFINE VAR X-PREVTA2 AS DECI NO-UNDO.
DEFINE VAR X-RANGO AS INTEGER INIT 0.
DEFINE VAR X-CANTI AS DECI    INIT 0.
DEFINE VAR J AS INTEGER.
DEFINE VAR Y-DSCTOS AS DECI NO-UNDO.

Y-DSCTOS = 0.        
FIND gn-convt WHERE gn-convt.Codig = S-CNDVTA NO-LOCK NO-ERROR.
FIND Expmmatg OF Almmmatg WHERE Expmmatg.coddiv = s-coddiv NO-LOCK NO-ERROR.
IF AVAILABLE gn-convt AND gn-convt.totdias <= 15 AND AVAILABLE Expmmatg
    THEN DO:
    /************ Descuento Promocional ************/
    /* Descuento Promocional */
    IF TODAY >= Expmmatg.PromFchD AND TODAY <= Expmmatg.PromFchH 
            AND Expmmatg.PromDto > 0 THEN DO:
        F-DSCTOS = Expmmatg.PromDto.
        F-PREUNI = Almmmatg.PreAlt[3] * (1 - F-DSCTOS / 100).
        Y-DSCTOS = Expmmatg.PromDto.
        IF Almmmatg.Monvta = 1 THEN
          ASSIGN X-PREVTA1 = F-PREUNI
                 X-PREVTA2 = ROUND(F-PREUNI / Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = F-PREUNI
                 X-PREVTA1 = ROUND(F-PREUNI * Almmmatg.TpoCmb,6).
        X-PREVTA1 = X-PREVTA1 * F-FACTOR.
        X-PREVTA2 = X-PREVTA2 * F-FACTOR.
    END.
    /* Descuento por Volumen */
    IF X-CANPED > 0 THEN DO:
        X-CANTI = X-CANPED * F-FACTOR .
        DO J = 1 TO 10:
           IF X-CANTI >= Expmmatg.DtoVolR[J] AND Expmmatg.DtoVolR[J] > 0  THEN DO:
              IF X-RANGO  = 0 THEN X-RANGO = Expmmatg.DtoVolR[J].
              IF X-RANGO <= Expmmatg.DtoVolR[J] THEN DO:
                X-RANGO  = Expmmatg.DtoVolR[J].
                F-DSCTOS = Expmmatg.DtoVolD[J].
                F-PREUNI = Almmmatg.PreAlt[3] * (1 - F-DSCTOS / 100).
                Y-DSCTOS = Expmmatg.DtoVolD[J] .
                IF Almmmatg.MonVta = 1 THEN
                   ASSIGN X-PREVTA1 = F-PREUNI
                          X-PREVTA2 = ROUND(F-PREUNI / Almmmatg.TpoCmb,6).
                ELSE
                   ASSIGN X-PREVTA2 = F-PREUNI
                          X-PREVTA1 = ROUND(F-PREUNI * Almmmatg.TpoCmb,6).
                X-PREVTA1 = X-PREVTA1 * F-FACTOR.
                X-PREVTA2 = X-PREVTA2 * F-FACTOR.
              END.
           END.
        END.
    END.
    
    IF X-PREVTA1 + X-PREVTA2 > 0 THEN DO:
        IF S-CODMON = 1 
        THEN F-PREUNI = X-PREVTA1.
        ELSE F-PREUNI = X-PREVTA2.     
    END.      
END.
/************************************************/
/* RHC 8.11.05  DESCUENTO ADICIONAL POR EXPOLIBRERIA */
/* RHC 10.01.08 SOLO SI NO TIENE DESCUENTO PROMOCIONAL */
F-DSCTOS-1 = 0.
FIND FacTabla WHERE factabla.codcia = s-codcia
    AND factabla.tabla = 'EL'
    AND factabla.codigo = STRING(YEAR(TODAY), '9999')
    NO-LOCK NO-ERROR.
IF AVAILABLE FacTabla 
    AND y-Dsctos = 0 
    AND LOOKUP(TRIM(s-CndVta), '000,001') > 0 
    THEN DO:    /* NO Promociones */
    CASE Almmmatg.Chr__02:
        WHEN 'P' THEN F-DSCTOS-1 = FacTabla.Valor[1].
        WHEN 'T' THEN F-DSCTOS-1 = FacTabla.Valor[2].
    END CASE.
END.
IF AVAILABLE FacTabla 
        AND y-Dsctos = 0 
        AND LOOKUP(TRIM(s-CndVta), '000,001') = 0 
        THEN DO:    /* NO Promociones */
    CASE Almmmatg.Chr__02:
        WHEN 'P' THEN F-DSCTOS-1 = FacTabla.Valor[1] /* - 1*/.
        WHEN 'T' THEN F-DSCTOS-1 = FacTabla.Valor[2] /* - 2*/.
    END CASE.
END.
/* ************************************************* */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Precio-Base) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Base Procedure 
PROCEDURE Precio-Base :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF S-CODMON = 1 THEN DO:
  IF Almmmatg.MonVta = 1 THEN
      ASSIGN F-PREBAS = Almmmatg.PreOfi * F-FACTOR.
  ELSE
      ASSIGN F-PREBAS = Almmmatg.PreOfi * Almmmatg.TpoCmb * F-FACTOR.
END.
IF S-CODMON = 2 THEN DO:
  IF Almmmatg.MonVta = 2 THEN
     ASSIGN F-PREBAS = Almmmatg.PreOfi * F-FACTOR.
  ELSE
     ASSIGN F-PREBAS = (Almmmatg.PreOfi / Almmmatg.TpoCmb) * F-FACTOR.
END.
/* *********************************************** */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Precio-Base-Expo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Base-Expo Procedure 
PROCEDURE Precio-Base-Expo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF S-CODMON = 1 THEN DO:
  IF Almmmatg.MonVta = 1 THEN
      ASSIGN F-PREBAS = Almmmatg.PreAlt[4] * F-FACTOR.
  ELSE
      ASSIGN F-PREBAS = Almmmatg.PreAlt[4] * Almmmatg.TpoCmb * F-FACTOR.
END.
IF S-CODMON = 2 THEN DO:
  IF Almmmatg.MonVta = 2 THEN
     ASSIGN F-PREBAS = Almmmatg.PreAlt[4] * F-FACTOR.
  ELSE
     ASSIGN F-PREBAS = (Almmmatg.PreAlt[4] / Almmmatg.TpoCmb) * F-FACTOR.
END.
/* *********************************************** */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

