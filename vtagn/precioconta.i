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
/* PRECIOS PRODUCTOS DE TERCEROS */
DEF VAR x-ClfCli2 LIKE gn-clie.clfcli2 INIT 'C' NO-UNDO.
DEF VAR x-Cols AS CHAR INIT 'A++,A+,A-' NO-UNDO.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = s-codcli
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie AND gn-clie.clfcli2 <> '' THEN x-ClfCli2 = gn-clie.clfcli2.
IF LOOKUP({&Catalogo}.CodFam, '000,001,002') > 0 AND LOOKUP(x-ClfCli2, x-Cols) > 0 THEN DO:
    SW-LOG1 = TRUE.
    /* Calculamos el margen de utilidad */
    DEF VAR x-MejPre AS DEC INIT 0 NO-UNDO.
    DEF VAR x-MejMar AS DEC INIT 0 NO-UNDO.
    DEF VAR MaxCat AS DEC INIT 0 NO-UNDO.

    x-MejPre = {&Catalogo}.PreOfi * 0.9312.    /* (- 4% - 3%) */
    IF {&Catalogo}.CtoTot > 0 THEN x-MejMar = ( x-MejPre - {&Catalogo}.CtoTot ) / {&Catalogo}.CtoTot * 100.
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
        F-PREVTA = x-MejPre * F-FACTOR
        F-DSCTOS = MaxCat.
    /* Recalculamos el descuento */
    IF {&Catalogo}.UndA = s-UndVta THEN DO:
        F-DSCTOS = ( {&Catalogo}.PreVta[2] -  F-PREVTA ) / {&Catalogo}.PreVta[2] * 100.
    END.
    IF {&Catalogo}.UndB = s-UndVta THEN DO:
        F-DSCTOS = ( {&Catalogo}.PreVta[3] - F-PREVTA ) / {&Catalogo}.PreVta[3] * 100.
    END.
    IF {&Catalogo}.UndC = s-UndVta THEN DO:
        F-DSCTOS = ( {&Catalogo}.PreVta[4] - F-PREVTA ) / {&Catalogo}.PreVta[4] * 100.
    END.
    IF {&Catalogo}.MonVta = 1 THEN 
      ASSIGN X-PREVTA1 = F-PREVTA
             X-PREVTA2 = ROUND(X-PREVTA1 / {&Catalogo}.TpoCmb,6).
    ELSE
      ASSIGN X-PREVTA2 = F-PREVTA
             X-PREVTA1 = ROUND(X-PREVTA2 * {&Catalogo}.TpoCmb,6).

/*     SW-LOG1 = TRUE.                                                                                         */
/*     F-DSCTOS = {&Catalogo}.dsctos[1].                                                                       */
/*     /* Calculamos el margen de utilidad */                                                                  */
/*     DEF VAR x-MejPre AS DEC INIT 0 NO-UNDO.                                                                 */
/*     DEF VAR x-MejMar AS DEC INIT 0 NO-UNDO.                                                                 */
/*     DEF VAR MaxCat AS DEC INIT 0 NO-UNDO.                                                                   */
/*     x-MejPre = {&Catalogo}.PreOfi * 0.9312.    /* (- 4% - 3%) */                                            */
/*     IF {&Catalogo}.CtoTot > 0 THEN x-MejMar = ( x-MejPre - {&Catalogo}.CtoTot ) / {&Catalogo}.CtoTot * 100. */
/*     FIND FIRST VtaTabla WHERE VtaTabla.codcia = s-codcia                                                    */
/*         AND VtaTabla.Tabla = 'DTOTER'                                                                       */
/*         AND x-MejMar >= VtaTabla.Rango_valor[1]                                                             */
/*         AND x-MejMar <  VtaTabla.Rango_valor[2]                                                             */
/*         NO-LOCK NO-ERROR.                                                                                   */
/*     IF AVAILABLE VtaTabla THEN DO:                                                                          */
/*         IF LOOKUP(x-ClfCli2, x-Cols) > 0 THEN MaxCat = VtaTabla.Valor[LOOKUP(x-ClfCli2, x-Cols)].           */
/*     END.                                                                                                    */
/*     x-MejPre = x-MejPre * ( 1 - MaxCat / 100 ).                                                             */
/*     MaxCat = ( 1 - ( x-MejPre / {&Catalogo}.PreVta[1] ) ) * 100.                                            */
/*                                                                                                             */
/*     F-DSCTOS = MaxCat.                                                                                      */
/*     F-PREVTA = {&Catalogo}.PreOfi * (1 - F-DSCTOS / 100).                                                   */
/*                                                                                                             */
/*     IF {&Catalogo}.MonVta = 1 THEN                                                                          */
/*       ASSIGN X-PREVTA1 = F-PREVTA                                                                           */
/*              X-PREVTA2 = ROUND(X-PREVTA1 / {&Catalogo}.TpoCmb,6).                                           */
/*     ELSE                                                                                                    */
/*       ASSIGN X-PREVTA2 = F-PREVTA                                                                           */
/*              X-PREVTA1 = ROUND(X-PREVTA2 * {&Catalogo}.TpoCmb,6).                                           */
/*     X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.                                                          */
/*     X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.                                                          */
END.
ELSE DO:
    /****   PRECIO C    ****/
    IF {&Catalogo}.UndC <> "" AND NOT SW-LOG1 THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = {&Catalogo}.UndBas 
            AND  Almtconv.Codalter = {&Catalogo}.UndC 
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.
        IF (x-CanPed * F-FACTOR) >= (0.25 * X-FACTOR) THEN DO:
            SW-LOG1 = TRUE.
            F-DSCTOS = {&Catalogo}.dsctos[3].
            IF {&Catalogo}.MonVta = 1 THEN
              ASSIGN X-PREVTA1 = {&Catalogo}.Prevta[4]
                     X-PREVTA2 = ROUND(X-PREVTA1 / {&Catalogo}.TpoCmb,6).
            ELSE
              ASSIGN X-PREVTA2 = {&Catalogo}.Prevta[4]
                     X-PREVTA1 = ROUND(X-PREVTA2 * {&Catalogo}.TpoCmb,6).
            X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
            X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
        END.
    END.
    /****   PRECIO B    ****/
    IF {&Catalogo}.UndB <> "" AND NOT SW-LOG1 THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = {&Catalogo}.UndBas 
            AND  Almtconv.Codalter = {&Catalogo}.UndB 
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.
        IF (x-CanPed * F-FACTOR) >= (0.25 * X-FACTOR) THEN DO:
            SW-LOG1 = TRUE.
            F-DSCTOS = {&Catalogo}.dsctos[2].
            IF {&Catalogo}.MonVta = 1 THEN 
              ASSIGN X-PREVTA1 = {&Catalogo}.Prevta[3]
                     X-PREVTA2 = ROUND(X-PREVTA1 / {&Catalogo}.TpoCmb,6).
            ELSE
              ASSIGN X-PREVTA2 = {&Catalogo}.Prevta[3]
                     X-PREVTA1 = ROUND(X-PREVTA2 * {&Catalogo}.TpoCmb,6).
            X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
            X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
        END.
    END.
    /****   PRECIO A    ****/
    IF {&Catalogo}.UndA <> "" AND NOT SW-LOG1 THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = {&Catalogo}.UndBas 
            AND  Almtconv.Codalter = {&Catalogo}.UndA 
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.
        IF (x-CanPed * F-FACTOR) >= (0.25 * X-FACTOR) THEN DO:
            SW-LOG1 = TRUE.
            F-DSCTOS = {&Catalogo}.dsctos[1].
            IF {&Catalogo}.MonVta = 1 THEN 
              ASSIGN X-PREVTA1 = {&Catalogo}.Prevta[2]
                     X-PREVTA2 = ROUND(X-PREVTA1 / {&Catalogo}.TpoCmb,6).
            ELSE
              ASSIGN X-PREVTA2 = {&Catalogo}.Prevta[2]
                     X-PREVTA1 = ROUND(X-PREVTA2 * {&Catalogo}.TpoCmb,6).
            X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
            X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
        END.
        ELSE DO:
            SW-LOG1 = TRUE.
            F-DSCTOS = {&Catalogo}.dsctos[1].
            IF {&Catalogo}.MonVta = 1 THEN 
              ASSIGN X-PREVTA1 = {&Catalogo}.Prevta[2]
                     X-PREVTA2 = ROUND(X-PREVTA1 / {&Catalogo}.TpoCmb,6).
            ELSE
              ASSIGN X-PREVTA2 = {&Catalogo}.Prevta[2]
                     X-PREVTA1 = ROUND(X-PREVTA2 * {&Catalogo}.TpoCmb,6).
            X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
            X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
        END.
    END.       
END.


/* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */
Y-DSCTOS = 0.        
  
/************ Descuento Promocional ************/
/* DEFINE VAR J AS INTEGER. */
DO J = 1 TO 10:
    IF {&Catalogo}.PromDivi[J] = S-CODDIV 
            AND TODAY >= {&Catalogo}.PromFchD[J] 
            AND TODAY <= {&Catalogo}.PromFchH[J] THEN DO:
        F-DSCTOS = {&Catalogo}.PromDto[J] .         
        F-PREVTA = {&Catalogo}.Prevta[1] * (1 - F-DSCTOS / 100).
        Y-DSCTOS = {&Catalogo}.PromDto[J] .
        SW-LOG1 = TRUE.
        IF {&Catalogo}.Monvta = 1 THEN 
          ASSIGN X-PREVTA1 = F-PREVTA
                 X-PREVTA2 = ROUND(F-PREVTA / {&Catalogo}.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = F-PREVTA
                 X-PREVTA1 = ROUND(F-PREVTA * {&Catalogo}.TpoCmb,6).
        FIND Almtconv WHERE Almtconv.CodUnid = {&Catalogo}.UndBas 
            AND Almtconv.Codalter = s-UndVta
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv
        THEN x-Factor = Almtconv.Equival.
        ELSE x-Factor = 1.
        X-PREVTA1 = X-PREVTA1 * X-FACTOR.
        X-PREVTA2 = X-PREVTA2 * X-FACTOR.             
     END.   
END.
/*************** Descuento por Volumen ****************/
IF X-CANPED > 0 THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = {&Catalogo}.UndBas 
        AND Almtconv.Codalter = s-UndVta 
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv 
    THEN ASSIGN
            X-FACTOR = Almtconv.Equival.
    ELSE ASSIGN 
            X-FACTOR = 1.
    X-CANTI = X-CANPED * X-FACTOR.
    DO J = 1 TO 10:
       IF X-CANTI >= {&Catalogo}.DtoVolR[J] AND {&Catalogo}.DtoVolR[J] > 0  THEN DO:
          IF X-RANGO  = 0 THEN X-RANGO = {&Catalogo}.DtoVolR[J].
          IF X-RANGO <= {&Catalogo}.DtoVolR[J] THEN DO:
            X-RANGO  = {&Catalogo}.DtoVolR[J].
            F-DSCTOS = {&Catalogo}.DtoVolD[J].         
            F-PREVTA = {&Catalogo}.Prevta[1] * (1 - F-DSCTOS / 100).
            Y-DSCTOS = {&Catalogo}.DtoVolD[J] .
            SW-LOG1 = TRUE.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


