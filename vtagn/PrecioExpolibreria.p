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
DEF INPUT PARAMETER S-TPOCMB AS DEC.
DEF INPUT PARAMETER F-FACTOR AS DEC.
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER S-CNDVTA AS CHAR.
DEF INPUT PARAMETER X-CANPED AS DEC.
DEF INPUT PARAMETER x-NroDec AS INT.

DEF OUTPUT PARAMETER F-PREBAS AS DEC.
DEF OUTPUT PARAMETER F-PREVTA AS DEC.
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.
DEF OUTPUT PARAMETER Y-DSCTOS AS DEC.
DEF OUTPUT PARAMETER Z-DSCTOS AS DEC.

/* VARIABLES LOCALES */
DEF VAR MaxCat AS DEC NO-UNDO.
DEF VAR MaxVta AS DEC NO-UNDO.
DEF VAR CL-CODCIA AS INT INIT 0 NO-UNDO.
DEF VAR x-ClfCli AS CHAR NO-UNDO.
/*DEF VAR x-fch AS DATE INIT TODAY.*/
DEFINE VARIABLE X-PREVTA1 AS DECI NO-UNDO.
DEFINE VARIABLE X-PREVTA2 AS DECI NO-UNDO.
/************ Descuento Promocional ************/
DEFINE VAR J AS INTEGER.
DEFINE VAR X-RANGO AS INTEGER INIT 0.   
DEFINE VAR X-CANTI AS DECI    INIT 0.   

FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCli THEN CL-CODCIA = S-CODCIA.
FIND Almmmatg WHERE Almmmatg.codcia = S-CODCIA
    AND Almmmatg.codmat = S-CODMAT 
    NO-LOCK.

/* CLASIFICACION DEL CLIENTE */
x-ClfCli = 'C'.     /* Valor por defecto */
FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
    AND  gn-clie.CodCli = S-CODCLI
    NO-LOCK.
IF AVAIL gn-clie AND gn-clie.clfcli <> '' THEN X-CLFCLI = gn-clie.clfcli.

/* RHC 12.06.08 tipo de cambio de la familia */
s-tpocmb = Almmmatg.PreAlt[6].
/* ***************************************** */

/* Determinamos el precio base */
F-PREBAS = Almmmatg.PreAlt[4] * F-FACTOR.
IF S-CODMON = 1 THEN DO:
    IF Almmmatg.PreAlt[5] = 1 
    THEN ASSIGN F-PREBAS = Almmmatg.PreAlt[4] * F-FACTOR.
    ELSE ASSIGN F-PREBAS = Almmmatg.PreAlt[4] * S-TPOCMB * F-FACTOR.
END.
IF S-CODMON = 2 THEN DO:
    IF Almmmatg.PreAlt[5] = 2 
    THEN ASSIGN F-PREBAS = Almmmatg.PreAlt[4] * F-FACTOR.
    ELSE ASSIGN F-PREBAS = (Almmmatg.PreAlt[4] / S-TPOCMB) * F-FACTOR.
END.

/* NOTA IMPORTANTE 27.10.2010
    NO VA A HABER DCUENTOS ADICIONALES */
ASSIGN
    MaxCat = 0
    MaxVta = 0.
/* Descuento por Clasificacion */
FIND ClfClie WHERE ClfClie.Categoria = X-CLFCLI NO-LOCK NO-ERROR.
IF AVAIL ClfClie THEN DO:
    IF Almmmatg.Chr__02 = "P" 
    THEN MaxCat = ClfClie.PorDsc.
    ELSE MaxCat = ClfClie.PorDsc1.
END.
/* RHC 06.11.10 PARCHE */
IF x-ClfCli = 'C' THEN MaxCat = 6.2500.
/* *************** */

/* Descuento por condicion de venta */    
FIND Dsctos WHERE Dsctos.CndVta = S-CNDVTA
    AND  Dsctos.clfCli = Almmmatg.Chr__02
    NO-LOCK NO-ERROR.
IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.

/* Definimos el precio de venta y el descuento aplicado */    
IF NOT AVAIL ClfClie 
THEN F-DSCTOS = (1 - (1 - MaxVta / 100)) * 100.
ELSE F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.

F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */

/* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */
Y-DSCTOS = 0.        
FIND gn-convt WHERE gn-convt.Codig = S-CNDVTA NO-LOCK NO-ERROR.
IF AVAILABLE gn-convt AND  gn-convt.totdias <= 15 THEN DO:
    /************ Descuento Promocional ************/
    FIND Expmmatg OF Almmmatg WHERE Expmmatg.coddiv = s-coddiv NO-LOCK NO-ERROR.
    IF AVAILABLE Expmmatg THEN DO:
        /* Descunto Promocional */
        IF TODAY >= Expmmatg.PromFchD AND TODAY <= Expmmatg.PromFchH 
                AND Expmmatg.PromDto > 0 THEN DO:
            F-DSCTOS = Expmmatg.PromDto.
            F-PREVTA = Almmmatg.PreAlt[3] * (1 - F-DSCTOS / 100).
            Y-DSCTOS = Expmmatg.PromDto.
            IF Almmmatg.PreAlt[5] = 1 THEN
              ASSIGN X-PREVTA1 = F-PREVTA
                     X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.PreAlt[6],6).
            ELSE
              ASSIGN X-PREVTA2 = F-PREVTA
                     X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.PreAlt[6],6).
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
                    F-PREVTA = Almmmatg.PreAlt[3] * (1 - F-DSCTOS / 100).
                    Y-DSCTOS = Expmmatg.DtoVolD[J] .
                    IF Almmmatg.PreAlt[5] = 1 THEN
                       ASSIGN X-PREVTA1 = F-PREVTA
                              X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.PreAlt[6],6).
                    ELSE
                       ASSIGN X-PREVTA2 = F-PREVTA
                              X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.PreAlt[6],6).
                    X-PREVTA1 = X-PREVTA1 * F-FACTOR.
                    X-PREVTA2 = X-PREVTA2 * F-FACTOR.
                  END.
               END.
            END.
        END.
    END.
    /* PRECIO FINAL */
    IF X-PREVTA1 + X-PREVTA2 > 0 THEN DO:
        IF S-CODMON = 1 
        THEN F-PREVTA = X-PREVTA1.
        ELSE F-PREVTA = X-PREVTA2.     
    END.    
END.
/* RECALCULAMOS EL PRECIO BASE */
F-PREBAS = F-PREVTA / ( 1 - F-DSCTOS / 100 ).
/************************************************/
RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).

/* RHC 8.11.05  DESCUENTO ADICIONAL POR EXPOLIBRERIA */
/* RHC 10.01.08 SOLO SI NO TIENE DESCUENTO PROMOCIONAL */
z-Dsctos = 0.
FIND FacTabla WHERE factabla.codcia = s-codcia
    AND factabla.tabla = 'EL'
    AND factabla.codigo = STRING(YEAR(TODAY), '9999')
    NO-LOCK NO-ERROR.
IF AVAILABLE FacTabla AND y-Dsctos = 0 
    AND LOOKUP(TRIM(s-CndVta), '000,001') > 0 
    THEN DO:    /* NO Promociones */
    CASE Almmmatg.Chr__02:
        WHEN 'P' THEN z-Dsctos = FacTabla.Valor[1].
        WHEN 'T' THEN z-Dsctos = FacTabla.Valor[2].
    END CASE.
END.
IF AVAILABLE FacTabla AND y-Dsctos = 0 
        AND LOOKUP(TRIM(s-CndVta), '400,401') > 0 
        THEN DO:    /* NO Promociones */
    CASE Almmmatg.Chr__02:
        WHEN 'P' THEN z-Dsctos = FacTabla.Valor[1] /* - 1*/.
        WHEN 'T' THEN z-Dsctos = FacTabla.Valor[2] /* - 2*/.
    END CASE.
END.
/* ************************************************* */

/* RHC 06.11.10 PARCHE */
IF LOOKUP(s-CodMat, '040153,040154,033251,035722,035725,033252,037904,033711,026925,037914,015725,026930') > 0 
    THEN z-Dsctos = 5.
IF LOOKUP(s-CodMat, '018178,031237,023030,037923,040152,040155,035387') > 0 
    THEN z-Dsctos = 5.
IF LOOKUP(s-CodMat, '023063,039755,037917') > 0 
    THEN z-Dsctos = 10.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


