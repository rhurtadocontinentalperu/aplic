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
IF S-CODMON = 1 THEN DO:
    IF {&Catalogo}.MonVta = 1 
    THEN ASSIGN F-PREBAS = {&Catalogo}.PreOfi * F-FACTOR.
    ELSE ASSIGN F-PREBAS = {&Catalogo}.PreOfi * S-TPOCMB * F-FACTOR.
END.
IF S-CODMON = 2 THEN DO:
    IF {&Catalogo}.MonVta = 2 
    THEN ASSIGN F-PREBAS = {&Catalogo}.PreOfi * F-FACTOR.
    ELSE ASSIGN F-PREBAS = ({&Catalogo}.PreOfi / S-TPOCMB) * F-FACTOR.
END.

ASSIGN
    MaxCat = 0
    MaxVta = 0.
/* Descuento por Clasificacion */
FIND ClfClie WHERE ClfClie.Categoria = X-CLFCLI NO-LOCK NO-ERROR.
IF AVAIL ClfClie THEN DO:
    IF {&Catalogo}.Chr__02 = "P" 
    THEN MaxCat = ClfClie.PorDsc.
    ELSE MaxCat = ClfClie.PorDsc1.
END.
/* Descuento por condicion de venta */    
FIND Dsctos WHERE Dsctos.CndVta = S-CNDVTA
    AND  Dsctos.clfCli = {&Catalogo}.Chr__02
    NO-LOCK NO-ERROR.
IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.

/* Definimos el precio de venta y el descuento aplicado */    
IF NOT AVAIL ClfClie 
THEN F-DSCTOS = (1 - (1 - MaxVta / 100)) * 100.
ELSE F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.

F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */

/* DE ACUERDO A LA DIVISION DONDE SE GENERA LA VENTA */
CASE s-CodDiv:
    WHEN '00000' THEN DO:       /* ATE */
        /*Precio Promocional*/
        DO J = 1 TO 10:
            IF {&Catalogo}.PromDivi[J] = S-CODDIV 
                AND TODAY >= {&Catalogo}.PromFchD[J] 
                AND TODAY <= {&Catalogo}.PromFchH[J] THEN DO:
                F-PREBAS = {&Catalogo}.Prevta[1] * F-FACTOR.
                F-DSCTOS = {&Catalogo}.PromDto[J] .         
                F-PREVTA = {&Catalogo}.Prevta[1] * (1 - F-DSCTOS / 100).
                IF S-CODMON = 1 THEN DO:
                  IF {&Catalogo}.MonVta = 1 THEN
                      ASSIGN F-PREVTA = F-PREVTA * F-FACTOR.
                  ELSE
                      ASSIGN F-PREVTA = F-PREVTA * {&Catalogo}.TpoCmb * F-FACTOR.
                END.
                IF S-CODMON = 2 THEN DO:
                  IF {&Catalogo}.MonVta = 2 THEN
                     ASSIGN F-PREVTA = F-PREVTA * F-FACTOR.
                  ELSE
                     ASSIGN F-PREVTA = (F-PREVTA / {&Catalogo}.TpoCmb) * F-FACTOR.
                END.        
             END.   
        END.
    END.
    OTHERWISE DO:
        /* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */
        Y-DSCTOS = 0.        
        FIND gn-convt WHERE gn-convt.Codig = S-CNDVTA NO-LOCK NO-ERROR.
        IF AVAILABLE gn-convt AND  gn-convt.totdias <= 15 THEN DO:
            /************ Descuento Promocional ************/ 
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
            /* PRECIO FINAL */
            IF X-PREVTA1 + X-PREVTA2 > 0 THEN DO:
                IF S-CODMON = 1 
                THEN F-PREVTA = X-PREVTA1.
                ELSE F-PREVTA = X-PREVTA2.     
            END.    
        END.
    END.
END CASE.
/* RECALCULAMOS EL PRECIO BASE */
F-PREBAS = F-PREVTA / ( 1 - F-DSCTOS / 100 ).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


