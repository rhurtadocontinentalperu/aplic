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
         HEIGHT             = 7.5
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
DEF INPUT PARAMETER S-TPOCMB AS DEC.
DEF INPUT PARAMETER F-FACTOR AS DEC.
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER S-CNDVTA AS CHAR.
DEF INPUT PARAMETER x-NroDec AS INT.

DEF OUTPUT PARAMETER F-PREBAS AS DEC.
DEF OUTPUT PARAMETER F-PREVTA AS DEC.
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.
DEF OUTPUT PARAMETER Y-DSCTOS AS DEC.
DEF OUTPUT PARAMETER X-TIPDTO AS CHAR.

DEF VAR MaxCat AS DEC NO-UNDO.
DEF VAR MaxVta AS DEC NO-UNDO.
DEF VAR CL-CODCIA AS INT INIT 0 NO-UNDO.
DEF VAR x-ClfCli  AS CHAR NO-UNDO.      /* Clasificacion para productos propios */
DEF VAR x-ClfCli2 AS CHAR NO-UNDO.      /* Clasificacion para productos de terceros */
DEF VAR x-fch AS DATE INIT TODAY.

/* variable sacadas del include */
DEFINE VARIABLE X-PREVTA  AS DECI NO-UNDO.
DEFINE VARIABLE X-PREVTA1 AS DECI NO-UNDO.
DEFINE VARIABLE X-PREVTA2 AS DECI NO-UNDO.
/************ Descuento Promocional ************/
DEFINE VAR J AS INTEGER.
DEFINE VAR X-RANGO AS INTEGER INIT 0.   
DEFINE VAR X-CANTI AS DECI    INIT 0.   


FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCli THEN CL-CODCIA = S-CODCIA.
FIND Almmmatg WHERE Almmmatg.codcia = S-CODCIA
    AND Almmmatg.codmat = S-CODMAT NO-LOCK.

FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
    AND  gn-clie.CodCli = S-CODCLI
    NO-LOCK NO-ERROR.
ASSIGN
    x-ClfCli  = "C"         /* Valor por defecto */
    x-ClfCli2 = "C".
IF AVAIL gn-clie AND gn-clie.clfcli <> '' THEN X-CLFCLI = gn-clie.clfcli.
IF AVAIL gn-clie AND gn-clie.clfcli2 <> '' THEN x-ClfCli2 = gn-clie.clfcli2.

/* RHC 12.06.08 tipo de cambio de la familia */
s-tpocmb = Almmmatg.TpoCmb.
/* ***************************************** */

/*RDP 17.08.10 Reduce a n decimales*/
RUN BIN/_ROUND1(f-PreBas, x-NroDec, OUTPUT F-PreBas).
/****************/

/* RHC 03.03.2011 FACTOR de ajuste al precio por cambio de IGV */
DEF VAR x-Factor-Igv AS DEC DECIMALS 6 NO-UNDO.
x-Factor-Igv = 1.
FIND FacCfgGn WHERE Faccfggn.codcia = s-codcia NO-LOCK.
FIND Vtatabla WHERE Vtatabla.codcia = s-codcia
    AND Vtatabla.tabla = "XIGV"
    AND VtaTabla.Llave_c1 = s-codcli
    NO-LOCK NO-ERROR.
IF AVAILABLE Vtatabla THEN DO:
    CASE Almmmatg.CHR__02:
        WHEN "P" THEN DO:
            IF VtaTabla.Llave_c2 = 'Si' THEN x-Factor-Igv = FacCfgGn.MrgDis.
        END.
        WHEN "T" THEN DO:
            IF VtaTabla.Llave_c3 = 'Si' THEN x-Factor-Igv = FacCfgGn.MrgDis.
        END.
    END CASE.
END.
/* *********************************************************** */

/* Determinamos el precio base */
ASSIGN
    MaxCat = 0
    MaxVta = 0
    F-PreBas = Almmmatg.PreOfi * x-Factor-Igv.

/* Descuento por Clasificacion */
DEF VAR x-Cols AS CHAR INIT 'A++,A+,A-' NO-UNDO.
IF LOOKUP(Almmmatg.CodFam, '000,001,002') > 0 AND LOOKUP(x-ClfCli2, x-Cols) > 0 THEN DO:
    /* Calculamos el margen de utilidad */
    DEF VAR x-MejPre AS DEC INIT 0 NO-UNDO.
    DEF VAR x-MejMar AS DEC INIT 0 NO-UNDO.
    x-MejPre = Almmmatg.PreOfi * 0.9312 *  x-Factor-Igv.    /* (- 4% - 3%) */
    IF Almmmatg.CtoTot > 0 THEN x-MejMar = ROUND ( ( x-MejPre - Almmmatg.CtoTot ) / Almmmatg.CtoTot * 100, 2).
    FIND FIRST VtaTabla WHERE VtaTabla.codcia = s-codcia
        AND VtaTabla.Tabla = 'DTOTER'
        AND x-MejMar >= VtaTabla.Rango_valor[1] 
        AND x-MejMar <  VtaTabla.Rango_valor[2]
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaTabla THEN DO:
        IF LOOKUP(x-ClfCli2, x-Cols) > 0 THEN MaxCat = VtaTabla.Valor[LOOKUP(x-ClfCli2, x-Cols)].
    END.
    x-MejPre = x-MejPre * ( 1 - MaxCat / 100 ).
    MaxCat = ( 1 - ( x-MejPre / ( Almmmatg.PreOfi * 0.9312 * x-Factor-Igv)  ) ) * 100.
    /* PRECIO BASE Y VENTA  */
    ASSIGN
        F-PREBAS = Almmmatg.PreOfi * 0.9312 * x-Factor-Igv
        F-PREVTA = x-MejPre
        F-DSCTOS = MaxCat.
    IF S-CODMON = 1 THEN DO:
        IF Almmmatg.MonVta = 1 
        THEN ASSIGN F-PREBAS = F-PREBAS * F-FACTOR.
        ELSE ASSIGN F-PREBAS = F-PREBAS * S-TPOCMB * F-FACTOR.
    END.
    IF S-CODMON = 2 THEN DO:
        IF Almmmatg.MonVta = 2 
        THEN ASSIGN F-PREBAS = F-PREBAS * F-FACTOR.
        ELSE ASSIGN F-PREBAS = (F-PREBAS / S-TPOCMB) * F-FACTOR.
    END.
    IF S-CODMON = 1 THEN DO:
        IF Almmmatg.MonVta = 1 
        THEN ASSIGN F-PREVTA = F-PREVTA * F-FACTOR.
        ELSE ASSIGN F-PREVTA = F-PREVTA * S-TPOCMB * F-FACTOR.
    END.
    IF S-CODMON = 2 THEN DO:
        IF Almmmatg.MonVta = 2 
        THEN ASSIGN F-PREVTA = F-PREVTA * F-FACTOR.
        ELSE ASSIGN F-PREVTA = (F-PREVTA / S-TPOCMB) * F-FACTOR.
    END.
END.
ELSE DO:
    FIND ClfClie WHERE ClfClie.Categoria = X-CLFCLI NO-LOCK NO-ERROR.
    IF AVAIL ClfClie THEN DO:
      IF Almmmatg.Chr__02 = "P" THEN 
          MaxCat = ClfClie.PorDsc.
      ELSE 
          MaxCat = ClfClie.PorDsc1.
    END.
    /* Descuento por condicion de venta */    
    FIND Dsctos WHERE Dsctos.CndVta = S-CNDVTA
        AND  Dsctos.clfCli = Almmmatg.Chr__02
        NO-LOCK NO-ERROR.
    IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.
    F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.

    IF S-CODMON = 1 THEN DO:
        IF Almmmatg.MonVta = 1 THEN
            ASSIGN F-PREBAS = F-PREBAS * F-FACTOR.
        ELSE
            ASSIGN F-PREBAS = F-PREBAS * S-TPOCMB * F-FACTOR.
    END.
    IF S-CODMON = 2 THEN DO:
        IF Almmmatg.MonVta = 2 THEN
            ASSIGN F-PREBAS = F-PREBAS * F-FACTOR.
        ELSE
            ASSIGN F-PREBAS = (F-PREBAS / S-TPOCMB) * F-FACTOR.
    END.
    F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */
END.

/* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */
Y-DSCTOS = 0.        
FIND gn-convt WHERE gn-convt.Codig = S-CNDVTA NO-LOCK NO-ERROR.
IF AVAILABLE gn-convt AND  gn-convt.totdias <= 15 THEN DO:
    /* ************ Descuento Promocional ************ */
    DO J = 1 TO 10:
        IF Almmmatg.PromDivi[J] = S-CODDIV 
                AND TODAY >= Almmmatg.PromFchD[J] 
                AND TODAY <= Almmmatg.PromFchH[J] THEN DO:
            ASSIGN
                F-DSCTOS = 0
                F-PREBAS = Almmmatg.Prevta[1] * x-Factor-Igv
                F-PREVTA = Almmmatg.Prevta[1] * x-Factor-Igv
                Y-DSCTOS = Almmmatg.PromDto[J] 
                X-TIPDTO = "PROM".
            IF Almmmatg.Monvta = 1 THEN 
              ASSIGN X-PREVTA1 = F-PREVTA
                     X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.TpoCmb,6).
            ELSE
              ASSIGN X-PREVTA2 = F-PREVTA
                     X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.TpoCmb,6).
            X-PREVTA1 = X-PREVTA1 * F-FACTOR.
            X-PREVTA2 = X-PREVTA2 * F-FACTOR.             
         END.   
    END.

    IF X-PREVTA1 + X-PREVTA2 > 0 THEN DO:
        IF S-CODMON = 1 
        THEN F-PREVTA = X-PREVTA1.
        ELSE F-PREVTA = X-PREVTA2.     
    END.      
END.

/************************************************/
RUN BIN/_ROUND1(F-PREVTA, X-NRODEC, OUTPUT F-PREVTA).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


