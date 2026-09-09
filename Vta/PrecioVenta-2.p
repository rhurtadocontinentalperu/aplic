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

DEFINE SHARED VAR s-coddiv AS CHAR.

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
DEF INPUT PARAMETER S-CODCLI AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INT.
DEF INPUT PARAMETER F-FACTOR AS DEC.
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER S-CNDVTA AS CHAR.
DEF INPUT PARAMETER x-NroDec AS INT.
DEF OUTPUT PARAMETER F-PREBAS AS DEC.
DEF OUTPUT PARAMETER F-PREVTA AS DEC.
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.

DEF VAR MaxCat AS DEC NO-UNDO.
DEF VAR MaxVta AS DEC NO-UNDO.
DEF VAR CL-CODCIA AS INT INIT 0 NO-UNDO.
DEF VAR x-ClfCli  AS CHAR NO-UNDO.      /* Clasificacion para productos propios */
DEF VAR x-ClfCli2 AS CHAR NO-UNDO.      /* Clasificacion para productos de terceros */
DEF VAR x-fch AS DATE INIT TODAY.
DEF VAR j AS INTEGER NO-UNDO.

FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCli THEN CL-CODCIA = S-CODCIA.
FIND Almmmatg WHERE Almmmatg.codcia = S-CODCIA
    AND Almmmatg.codmat = S-CODMAT NO-LOCK.

/*********/
FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
   AND gn-clie.CodCli = S-CODCLI NO-LOCK NO-ERROR.
ASSIGN
    x-ClfCli  = "C"         /* Valor por defecto */
    x-ClfCli2 = "C".

IF AVAIL gn-clie AND gn-clie.clfcli <> '' THEN X-CLFCLI  = gn-clie.clfcli.
IF AVAIL gn-clie AND gn-clie.clfcli2 <> '' THEN x-ClfCli2 = gn-clie.clfcli2.

ASSIGN
    MaxCat = 0
    MaxVta = 0
    F-PREBAS = Almmmatg.PreOfi.

DEF VAR x-Cols AS CHAR INIT 'A++,A+,A-' NO-UNDO.
IF LOOKUP(Almmmatg.CodFam, '000,001,002') > 0 AND LOOKUP(x-ClfCli2, x-Cols) > 0 THEN DO:
    /* Calculamos el margen de utilidad */
    DEF VAR x-MejPre AS DEC INIT 0 NO-UNDO.
    DEF VAR x-MejMar AS DEC INIT 0 NO-UNDO.

    x-MejPre = Almmmatg.PreOfi * 0.9312.    /* (- 4% - 3%) */
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
    MaxCat = ( 1 - ( x-MejPre / Almmmatg.PreVta[1] ) ) * 100.
    /* PRECIO BASE Y VENTA  */
    ASSIGN
        F-PREBAS = Almmmatg.PreVta[1]
        F-PREVTA = x-MejPre
        F-DSCTOS = MaxCat.
    IF S-CODMON = 1 THEN DO:
        IF Almmmatg.MonVta = 1 
        THEN ASSIGN F-PREBAS = F-PREBAS * F-FACTOR.
        ELSE ASSIGN F-PREBAS = F-PREBAS * Almmmatg.TpoCmb * F-FACTOR.
    END.
    IF S-CODMON = 2 THEN DO:
        IF Almmmatg.MonVta = 2 
        THEN ASSIGN F-PREBAS = F-PREBAS * F-FACTOR.
        ELSE ASSIGN F-PREBAS = (F-PREBAS / Almmmatg.TpoCmb) * F-FACTOR.
    END.
    IF S-CODMON = 1 THEN DO:
        IF Almmmatg.MonVta = 1 
        THEN ASSIGN F-PREVTA = F-PREVTA * F-FACTOR.
        ELSE ASSIGN F-PREVTA = F-PREVTA * Almmmatg.TpoCmb * F-FACTOR.
    END.
    IF S-CODMON = 2 THEN DO:
        IF Almmmatg.MonVta = 2 
        THEN ASSIGN F-PREVTA = F-PREVTA * F-FACTOR.
        ELSE ASSIGN F-PREVTA = (F-PREVTA / Almmmatg.TpoCmb) * F-FACTOR.
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
        AND Dsctos.clfCli = Almmmatg.Chr__02
        NO-LOCK NO-ERROR.
    IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.

    F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.

    /*RD01 - Reduce a 4 decimales*/
    RUN src/BIN/_ROUND1(F-PREBAS,4,OUTPUT F-PREBAS).
    /*Fin*/

    /* RHC 12.06.08 al tipo de cambio de la familia */
    IF S-CODMON = 1 THEN DO:
      IF Almmmatg.MonVta = 1 THEN
          ASSIGN F-PREBAS = F-PREBAS * F-FACTOR.
      ELSE
          ASSIGN F-PREBAS = F-PREBAS * Almmmatg.TpoCmb * F-FACTOR.
    END.
    IF S-CODMON = 2 THEN DO:
      IF Almmmatg.MonVta = 2 THEN
         ASSIGN F-PREBAS = F-PREBAS * F-FACTOR.
      ELSE
         ASSIGN F-PREBAS = (F-PREBAS / Almmmatg.TpoCmb) * F-FACTOR.
    END.

    F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).

END.


/*Precio Promocional*/
DO J = 1 TO 10:
    IF Almmmatg.PromDivi[J] = S-CODDIV 
        AND TODAY >= Almmmatg.PromFchD[J] 
        AND TODAY <= Almmmatg.PromFchH[J] THEN DO:
        F-PREBAS = Almmmatg.Prevta[1] * F-FACTOR.
        F-DSCTOS = Almmmatg.PromDto[J] .         
        F-PREVTA = Almmmatg.Prevta[1] * (1 - F-DSCTOS / 100).
        IF S-CODMON = 1 THEN DO:
          IF Almmmatg.MonVta = 1 THEN
              ASSIGN F-PREVTA = F-PREVTA * F-FACTOR.
          ELSE
              ASSIGN F-PREVTA = F-PREVTA * Almmmatg.TpoCmb * F-FACTOR.
        END.
        IF S-CODMON = 2 THEN DO:
          IF Almmmatg.MonVta = 2 THEN
             ASSIGN F-PREVTA = F-PREVTA * F-FACTOR.
          ELSE
             ASSIGN F-PREVTA = (F-PREVTA / Almmmatg.TpoCmb) * F-FACTOR.
        END.        
     END.   
END.

/*MESSAGE F-PREBAS SKIP F-PREVTA.*/
    RUN src/BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


