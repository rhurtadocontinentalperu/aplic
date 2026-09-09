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

/* Determinamos el precio base */
ASSIGN
    MaxCat = 0
    MaxVta = 0
    F-PreBas = {&Catalogo}.PreOfi.

/* Descuento por Clasificacion */
DEF VAR x-Cols AS CHAR INIT 'A++,A+,A-' NO-UNDO.
IF LOOKUP({&Catalogo}.CodFam, '000,001,002') > 0 AND LOOKUP(x-ClfCli2, x-Cols) > 0 THEN DO:
    /* Calculamos el margen de utilidad */
    DEF VAR x-MejPre AS DEC INIT 0 NO-UNDO.
    DEF VAR x-MejMar AS DEC INIT 0 NO-UNDO.
    x-MejPre = {&Catalogo}.PreOfi * 0.9312.    /* (- 4% - 3%) */
    IF {&Catalogo}.CtoTot > 0 THEN x-MejMar = ROUND ( ( x-MejPre - {&Catalogo}.CtoTot ) / {&Catalogo}.CtoTot * 100, 2).
    FIND FIRST VtaTabla WHERE VtaTabla.codcia = s-codcia
        AND VtaTabla.Tabla = 'DTOTER'
        AND x-MejMar >= VtaTabla.Rango_valor[1] 
        AND x-MejMar <  VtaTabla.Rango_valor[2]
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaTabla THEN DO:
        IF LOOKUP(x-ClfCli2, x-Cols) > 0 THEN MaxCat = VtaTabla.Valor[LOOKUP(x-ClfCli2, x-Cols)].
    END.
    x-MejPre = x-MejPre * ( 1 - MaxCat / 100 ).
    MaxCat = ( 1 - ( x-MejPre / {&Catalogo}.PreVta[1] ) ) * 100.
    /* PRECIO BASE Y VENTA  */
    ASSIGN
        F-PREBAS = Almmmatg.PreVta[1]
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
      IF {&Catalogo}.Chr__02 = "P" THEN 
          MaxCat = ClfClie.PorDsc.
      ELSE 
          MaxCat = ClfClie.PorDsc1.
    END.
    /* Descuento por condicion de venta */    
    FIND Dsctos WHERE Dsctos.CndVta = S-CNDVTA
        AND  Dsctos.clfCli = {&Catalogo}.Chr__02
        NO-LOCK NO-ERROR.
    IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.
    F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.

    IF S-CODMON = 1 THEN DO:
        IF {&Catalogo}.MonVta = 1 THEN
            ASSIGN F-PREBAS = F-PREBAS * F-FACTOR.
        ELSE
            ASSIGN F-PREBAS = F-PREBAS * S-TPOCMB * F-FACTOR.
    END.
    IF S-CODMON = 2 THEN DO:
        IF {&Catalogo}.MonVta = 2 THEN
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
/*     /************ Descuento Promocional ************/ */
    DO J = 1 TO 10:
        IF {&Catalogo}.PromDivi[J] = S-CODDIV 
                AND TODAY >= {&Catalogo}.PromFchD[J] 
                AND TODAY <= {&Catalogo}.PromFchH[J] THEN DO:
            F-DSCTOS = {&Catalogo}.PromDto[J] .         
            F-PREVTA = {&Catalogo}.Prevta[1] * (1 - F-DSCTOS / 100).
            Y-DSCTOS = {&Catalogo}.PromDto[J] .
            IF {&Catalogo}.Monvta = 1 THEN 
              ASSIGN X-PREVTA1 = F-PREVTA
                     X-PREVTA2 = ROUND(F-PREVTA / {&Catalogo}.TpoCmb,6).
            ELSE
              ASSIGN X-PREVTA2 = F-PREVTA
                     X-PREVTA1 = ROUND(F-PREVTA * {&Catalogo}.TpoCmb,6).
            X-PREVTA1 = X-PREVTA1 * F-FACTOR.
            X-PREVTA2 = X-PREVTA2 * F-FACTOR.             
         END.   
    END.

    /*************** Descuento por Volumen ****************/
    /* RHC 28.12.09 POR EL CIERRAPUERTA DEL 5 y 6 DE ENERO */
    IF (s-coddiv = '00015' AND TODAY >= 01/04/2010 AND TODAY <= 01/31/2010) THEN DO:
        /* NO CALCULA POR VOLUMEN */
    END.
    ELSE DO:
        IF X-CANPED > 0 THEN DO:
            X-CANTI = X-CANPED * F-FACTOR .
            DO J = 1 TO 10:
               IF X-CANTI >= {&Catalogo}.DtoVolR[J] AND {&Catalogo}.DtoVolR[J] > 0  THEN DO:
                  IF X-RANGO  = 0 THEN X-RANGO = {&Catalogo}.DtoVolR[J].
                  IF X-RANGO <= {&Catalogo}.DtoVolR[J] THEN DO:
                    X-RANGO  = {&Catalogo}.DtoVolR[J].
                    F-DSCTOS = {&Catalogo}.DtoVolD[J].         
                    F-PREVTA = {&Catalogo}.Prevta[1] * (1 - F-DSCTOS / 100).
                    Y-DSCTOS = {&Catalogo}.DtoVolD[J] .
                    IF {&Catalogo}.MonVta = 1 THEN 
                       ASSIGN X-PREVTA1 = F-PREVTA
                              X-PREVTA2 = ROUND(F-PREVTA / {&Catalogo}.TpoCmb,6).
                    ELSE
                       ASSIGN X-PREVTA2 = F-PREVTA
                              X-PREVTA1 = ROUND(F-PREVTA * {&Catalogo}.TpoCmb,6).
                    X-PREVTA1 = X-PREVTA1 * F-FACTOR.
                    X-PREVTA2 = X-PREVTA2 * F-FACTOR.                                        
                  END.   
               END.   
            END.
        END.        
    END.
    IF X-PREVTA1 + X-PREVTA2 > 0 THEN DO:
        IF S-CODMON = 1 
        THEN F-PREVTA = X-PREVTA1.
        ELSE F-PREVTA = X-PREVTA2.     
    END.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


